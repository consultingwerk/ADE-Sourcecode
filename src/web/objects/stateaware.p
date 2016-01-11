&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 - adm2
/* Procedure Description
"State Aware Object

This is run persistently by web/objects/webstart.p. It includes methods for supporting state-aware web-objects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS State-Aware-Object 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------

File: stateaware.p 

Description:  Provides support for state-aware web objects.

Input Parameters:   <none>

Output Parameters:  <none>

Author : D.Adams
Updated: 01/10/02 adams@progress.com
           Adapted from web/objects/web-util.p V9.1C, this procedure provides 
           support for state-aware web-objects.
         05/08/02 adams
           Reimplemented support for database transactions that span multiple
           web requests.

---------------------------------------------------------------------------*/

/* *********************** Included Definitions *********************** */

{ src/web/method/cgidefs.i }      /* Basic CGI variables */
{ src/web/method/cgiarray.i }     /* Extended CGI array variables */
{ src/web/method/webutils.i }

/* ***************************  Definitions  ************************** */

&Scoped-define WEB-CURRENT-ENVIRONMENT WEB-CONTEXT:CURRENT-ENVIRONMENT
&Scoped-define WEB-EXCLUSIVE-ID WEB-CONTEXT:EXCLUSIVE-ID
&Global-define WSEU-NAME "WSEU":U

/* Computing timeout periods needs the number of seconds in one day. */
&Scoped-define ONE-DAY 86400

/* Define temp-table to hold state-aware object handles and their timeout 
   date and time. */
DEFINE TEMP-TABLE wo NO-UNDO
  FIELD hdl          AS HANDLE
  FIELD id           AS INTEGER
  FIELD timeout-date AS DATE
  FIELD timeout-time AS INTEGER
  FIELD new-object   AS LOGICAL
  INDEX date-time    IS PRIMARY timeout-date timeout-time
  INDEX id IS UNIQUE id.

/* Also defined in web/objects/web-disp.p and adeuib/_semain.w.  This needs to
   be centralized. */
DEFINE SHARED VARIABLE transaction-state AS CHARACTER NO-UNDO.

/* Variables for configuration options.  Initialized upon Agent startup. */
DEFINE VARIABLE cfg-eval-mode       AS LOGICAL   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE State-Aware-Object
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: State-Aware-Object
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW State-Aware-Object ASSIGN
         HEIGHT             = 23.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB State-Aware-Object 
/* ************************* Included-Libraries *********************** */

{src/web/method/proto.i}
{src/web/method/admweb.i}
{src/web/method/cgiutils.i}
{src/web/method/cookies.i}
{src/web/method/message.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK State-Aware-Object 


/* ***************************  Main Block  *************************** */
/* It is run persistent by webstart.p. */
RUN set-attribute-list IN THIS-PROCEDURE ("Web-State=persistent":U).

/* User Defined Functions */
FUNCTION fetch-attr RETURNS CHARACTER 
( p_wo-hdl    AS HANDLE,
  p_attr-name AS CHARACTER ):
  
  DEFINE VARIABLE cFunction AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(p_wo-hdl) THEN DO:
    /* See if this is a 9.0A file.  If so, run new function. */
    cFunction = "get":U + REPLACE(p_attr-name,"-":U,"").

    ASSIGN cValue = DYNAMIC-FUNCTION(cFunction IN p_wo-hdl) NO-ERROR.
    
    IF cValue eq ? THEN
      RUN get-attribute IN p_wo-hdl (INPUT p_attr-name) NO-ERROR.
    
    RETURN (IF cValue ne ? THEN cValue 
            ELSE IF ERROR-STATUS:ERROR THEN "" ELSE RETURN-VALUE).
  END.
  ELSE RETURN "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-exclusive-pause State-Aware-Object 
PROCEDURE check-exclusive-pause :
/*------------------------------------------------------------------------------
  Purpose:     Go through all the state-aware Web objects and look for the
               next one to timeout.  Delete all the ones that have already
               timed out.
  Parameters:  p_period - OUTPUT the minimum timeout period
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_period AS DECIMAL NO-UNDO.
  
  DEFINE BUFFER ip_wo FOR wo.
  
  /* Run adm-timing-out for each Web object that has a Web-State of 
   * 'State-Aware' and has timed out.  Adm-timing-out in turn sets the Web 
   * object's Web-State to 'Timed-Out'.  If the Web object has a 
   * local-timing-out procedure then the Web-State may still be 
   * 'State-Aware', so run check-web-state so that the timeout period of the 
   * Web object may be reset before returning the timeout period/pause period 
   * to web-disp.p. 
  */
  FOR EACH ip_wo:
    IF fetch-attr(ip_wo.hdl, 'Web-State':U) eq 'State-Aware':U THEN DO:
      IF (ip_wo.timeout-date < TODAY OR
         (ip_wo.timeout-date = TODAY AND ip_wo.timeout-time <= TIME)) THEN DO:
        IF ip_wo.new-object THEN
          RUN timingOut IN ip_wo.hdl NO-ERROR.
        ELSE
          RUN dispatch IN ip_wo.hdl ('timing-out':U) NO-ERROR.
        
        /* See if the web object reset it's web-state back to State-Aware
           instead of timing-out. */
        IF fetch-attr(ip_wo.hdl, 'Web-State':U) eq 'State-Aware':U THEN 
          RUN check-web-state (ip_wo.hdl) NO-ERROR.
      END. /* IF ip_wo.timeout-date... */
    END. /* IF fetch-attr(... */
    
    /* State-less objects with timeout = 0; delete procedure now */
    ELSE IF fetch-attr(ip_wo.hdl, 'Web-State':U) eq 'state-less':U AND p_period = 0 THEN DO:
      IF ip_wo.new-object THEN
        RUN destroy IN ip_wo.hdl NO-ERROR.
      ELSE
        RUN dispatch IN ip_wo.hdl ('destroy':U) NO-ERROR.
      /* Make sure it's dead. */
      IF VALID-HANDLE(ip_wo.hdl) THEN 
        DELETE PROCEDURE ip_wo.hdl.
      /* Delete the web-object record. */
      DELETE ip_wo.
    END.
  END. /* FOR EACH ip_wo */

  /* Find the first state-aware web-object and return the time remaining on its 
     timeout. Note that the primary index is 'date-time' which includes Web 
     object timeout-time and timeout-date.  Since the default sorting on the 
     records in the 'wo' temp-table is ascending, the remaining timeout period 
     will come from the first 'wo' record which is the next Web object to 
     timeout.  This will be the exclusive pause period. */
  FOR EACH ip_wo:
    IF fetch-attr(ip_wo.hdl, 'Web-State':U) = 'State-Aware':U THEN DO:
      p_period = (ip_wo.timeout-date - TODAY) * {&ONE-DAY} +
                 (ip_wo.timeout-time - TIME).
      LEAVE.
    END.
  END.

  /* Don't return a negative number. */
  IF p_period < 0 THEN 
    p_period = 0.
 
  /* If the pause-period is 0, then the agent will no longer be locked, so 
   * delete all timed out objects.  Indeed all objects should be deleted. */
  IF p_period eq 0 THEN DO:
    FOR EACH ip_wo:
      IF VALID-HANDLE(ip_wo.hdl) THEN DO:
        IF ip_wo.new-object THEN
          RUN destroy IN ip_wo.hdl NO-ERROR.
        ELSE
          RUN dispatch IN ip_wo.hdl ('destroy':U) NO-ERROR.
        /* Make sure it was really destroyed. */
        IF VALID-HANDLE(ip_wo.hdl) THEN 
          DELETE PROCEDURE ip_wo.hdl.
      END.
      /* Delete the web-object record. */
      DELETE ip_wo.
    END. /* FOR EACH ip_wo: */
  END. /* IF p_period eq 0... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-web-state State-Aware-Object 
PROCEDURE check-web-state :
/*------------------------------------------------------------------------------
  Purpose:     Check the web-state of the current Web object. If it is
               state-aware, store it's timeout period in the Web object
               temp-table.
  Parameters:  p_wo-hdl: Procedure handle of the Web object.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_wo-hdl AS HANDLE NO-UNDO.
 
  DEFINE VARIABLE timeout    AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE lNewObject AS LOGICAL   NO-UNDO INITIAL TRUE.

  DEFINE BUFFER ip_wo FOR wo.

  lNewObject = NOT CAN-DO(p_wo-hdl:INTERNAL-ENTRIES,"dispatch":U).

  /* Ask for the Web object's state and timeout period */ 
  CASE (fetch-attr(p_wo-hdl, 'Web-State':U)):

    WHEN 'State-Aware':U THEN DO:
      /* Find a record in the 'wo' temp-table whose handle matches
       * the one passed to this procedure. */
      FIND ip_wo WHERE ip_wo.id eq p_wo-hdl:UNIQUE-ID NO-ERROR.

      IF NOT AVAILABLE ip_wo THEN DO:
        /* If a 'wo' record does not exist, then create a new one. */
        CREATE ip_wo.
        ASSIGN 
          ip_wo.hdl        = p_wo-hdl
          ip_wo.id         = p_wo-hdl:UNIQUE-ID
          ip_wo.new-object = lNewObject.
      END.
 
      /* If a Web object is available, state-aware, then reset the timeout period. */
      ASSIGN timeout = DECIMAL (fetch-attr(ip_wo.hdl, 'Web-Timeout':U)).
      IF timeout < 1.0 THEN 
        timeout = 5.0.
 
      /* Store the timeout period as an expiration date and time, starting
       * from right now. */
      ASSIGN 
        ip_wo.timeout-date = TODAY
        ip_wo.timeout-time = TIME + (timeout * 60). /*sec. since midnight*/

      /* Watch out for times longer than a day. */
      DO WHILE ip_wo.timeout-time >= {&ONE-DAY}:
        ASSIGN ip_wo.timeout-date = ip_wo.timeout-date + 1
               ip_wo.timeout-time = ip_wo.timeout-time - {&ONE-DAY}.
      END. /* DO WHILE... */
    END. /* WHEN 'State-Aware' */

    WHEN ('Timed-Out':U) THEN DO:  
      /* Do nothing.  Just leave it around. It will be deleted on the next
         check-exclusive-pause that finds no state-aware objects. */
    END. /* WHEN 'Timed-Out */

    OTHERWISE DO:
      /* The expected case here will be 'State-less', however, the same action should
       * be taken for any unexpected case, or for objects that did not have a web-state.
       * If the Web object's Web-State is 'State-less' then just delete
       * it's procedure handle, as there is no entry for it in the Web
       * object temp-table. */
      IF VALID-HANDLE(p_wo-hdl) THEN DO:  
        /* Delete the wo record if it exists. */
        FIND ip_wo WHERE ip_wo.id eq p_wo-hdl:UNIQUE-ID NO-ERROR.
        IF AVAILABLE ip_wo THEN 
          DELETE ip_wo.
        
        IF lNewObject THEN
          RUN destroy IN p_wo-hdl NO-ERROR.
        ELSE
          RUN dispatch IN p_wo-hdl ('destroy':U) NO-ERROR.
          
        IF VALID-HANDLE(p_wo-hdl) THEN 
          DELETE PROCEDURE p_wo-hdl.
      END. /* IF VALID-HANDLE... */
    END. /* WHEN 'Stateless' */
  END. /* CASE RETURN-VALUE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE continue-processing State-Aware-Object 
PROCEDURE continue-processing :
/*------------------------------------------------------------------------------
 Purpose:     Process another web request in a state-aware Web object .
 Parameters:  piFileName: File Name of this Web object.
              piUniqueId: Unique ID of this procedure.
 Notes:
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFileName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER piUniqueId  AS INTEGER   NO-UNDO.

  DEFINE VARIABLE iTimeRemaining    AS INTEGER NO-UNDO.
  
  DEFINE BUFFER ip_wo    FOR wo.
  DEFINE BUFFER ip_sa_wo FOR wo.

  /* Find a record in the 'wo' temp-table whose handle matches the one passed 
     to this procedure. */
  FIND ip_wo WHERE ip_wo.id EQ piUniqueId NO-ERROR.
  IF NOT AVAILABLE (ip_wo) THEN DO:
    /* If there is no 'wo' record that has a handle that matches the one passed 
       to this procedure then the the Web object must have timed out or the Agent 
       that was running the Web object became AVAILABLE and LOCKED to another 
       browser/user. */
    IF RIGHT-TRIM(wseu-cookie, '012346789':U) <>
       RIGHT-TRIM(ENTRY(2, {&WEB-EXCLUSIVE-ID}, '=':U), '0123456789':U) THEN
      RUN HtmlError 
        (SUBSTITUTE('The Agent process to which you were attached has timed-out. Please start again.  You will be reattached to another Agent process.  The expected Agent is &1, but request was received by &2.', 
        wseu-cookie, ENTRY(2, {&WEB-EXCLUSIVE-ID}, '=':U))).
    ELSE DO:
      /* Kill the cookie used by this Agent to identify the Web object. */
      delete-cookie(pcFileName, ?, ?).
      RUN HtmlError ('The Web object to which you were attached has timed-out. Please start again.').
    END.
  END. /* IF NOT AVAILABLE */ 
  ELSE DO:
    IF VALID-HANDLE (ip_wo.hdl) THEN DO:
      /* If the Web object was found in the temp-table, then it is 'State-Aware'
         and has not timed out.  Therefore dispatch 'process-web-request in the 
         Web object handle since it is already running.  Once process-web-request 
         completes, run check-web-state to check to see if the 'State-Aware' Web 
         object has timed out, and in that case delete it's record from the 'wo' 
         temp-table. */
      /* Catch all possible Progress run-time "break" conditions.  [NOTE: this is 
         similar to the ExecuteRun logic in adeedit/psystem.i]. */
      Run-Block:   
      DO ON ERROR  UNDO Run-Block, LEAVE Run-Block  
         ON ENDKEY UNDO Run-Block, LEAVE Run-Block
         ON STOP   UNDO Run-Block, LEAVE Run-Block
         ON QUIT                 , LEAVE Run-Block:  

        /* Run the Web object and note any errors after running it. */
        IF ip_wo.new-object THEN
          RUN process-web-request IN ip_wo.hdl NO-ERROR.
        ELSE
          RUN dispatch IN ip_wo.hdl ('process-web-request':U) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          RUN show-error-status NO-ERROR.
          RUN HtmlError (SUBSTITUTE ("Unable to continue running Web object '&1'", ip_wo.hdl:FILE-NAME)).
        END. /* IF...ERROR... */
      END. /* Run-Block: DO... */
    
      RUN check-exclusive-pause (OUTPUT iTimeRemaining).

    END. /* End IF VALID-HANDLE */ 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-web-objects State-Aware-Object 
PROCEDURE find-web-objects :
/*------------------------------------------------------------------------------
  Purpose:     Find any persistently running Web objects and return logical
               success flag.
  Parameters:  rslt -- TRUE if at least one STATE-AWARE Web object can be found.
  Notes:
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER rslt AS LOGICAL INITIAL FALSE NO-UNDO.
  
  DEFINE BUFFER ip_wo FOR wo.
  
  /* Look for at least one Web object that is still state-aware. Stop when
     one is found. */
  FOR EACH ip_wo:
    IF fetch-attr(ip_wo.hdl, 'Web-State':U) eq "state-aware":U THEN DO:
      rslt = TRUE.
      LEAVE.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-time-remaining State-Aware-Object 
PROCEDURE get-time-remaining :
/*------------------------------------------------------------------------------
  Purpose:     Get time remaining (before timeout) of a state-aware web object.   
  Parameters:  p_wo-hdl:  Procedure handle of the Web object.
               p_period:  Time Remaining before timeout.
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_wo-hdl AS HANDLE  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_period AS DECIMAL NO-UNDO. 

  FIND FIRST wo WHERE wo.id = p_wo-hdl:UNIQUE-ID NO-ERROR.
  IF AVAILABLE(wo) AND (fetch-attr(wo.hdl, 'Web-State':U) = 'State-Aware':U) THEN DO: 
    p_period = (wo.timeout-date - TODAY) * {&ONE-DAY} + (wo.timeout-time - TIME).
    IF p_period ne 0 THEN p_period = ( p_period / 60 ).
  END.
  ELSE
    p_period = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-transaction-state State-Aware-Object 
PROCEDURE get-transaction-state :
/*------------------------------------------------------------------------------
  Purpose:     Return the transaction state.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RETURN transaction-state.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request State-Aware-Object 
PROCEDURE init-request :
/*---------------------------------------------------------------------------
Procedure:   init-request
Description: Initializes WebSpeed environment for each web request
Input:       Environment variables
Output:      Sets global variables defined in src/web/method/cgidefs.i
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cDebugCookie  AS CHARACTER FORMAT "x(20)" NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER FORMAT "x(40)" NO-UNDO.
  
  ASSIGN
    /* Check for a "WSDebug" Cookie */
    cDebugCookie  = get-cookie ("WSDebug":U)
    /* Initialize debug options based on Cookie.  If there is no Cookie,
       then debug-options will be blank.  This is fine because it needs
       to be initialized for each request anyway. */
    debug-options = cDebugCookie
    /* Get the WSEU cookie. */
    wseu-cookie   = get-cookie ({&WSEU-NAME}).
  
  /* Get debugging options if specified in QUERY_STRING or form input */
  ASSIGN cValue = get-field("debug":U).

  /* Check for "debug" with no options in QUERY_STRING for backwards
     compatibility. */
  IF cValue = "" AND QUERY_STRING MATCHES "*debug*":U THEN
    ASSIGN cValue = "all":U.

  /* Don't allow debugging if disabled via configuration options. */
  IF debugging-enabled = FALSE THEN
    ASSIGN cValue = "".
    
  /* Turn debugging off? */
  IF CAN-DO(cValue,"off":U) THEN DO:  /* debug=off? */
    ASSIGN debug-options = "".
    IF cDebugCookie <> "" THEN
      delete-cookie("WSDebug":U,?,?).  /* delete cookie if there is one */
  END.

  /* Else, if debug=option1,option2 etc. was specified, turn debugging on? */
  ELSE IF cValue <> "" THEN DO:
    IF CAN-DO(cValue,"on":U) THEN     /* debug=on? */
      ASSIGN debug-options = "all":U.
    /* Else, assign specified values */
    ELSE
      ASSIGN debug-options = cValue.
    /* Set the debug Cookie if different than debug options or not set */
    IF debug-options <> cDebugCookie THEN
      set-cookie ("WSDebug":U, debug-options, ?, ?, ?, ?, ?).
  END.

END PROCEDURE.  /* init-request */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE list-web-objects State-Aware-Object 
PROCEDURE list-web-objects :
/*------------------------------------------------------------------------------
  Purpose:     Display the contents of the web object temp-table.
               This is intended as a debugging aid.
  Parameters:  <none>
  Notes:       The easiest place to call this is from the WebTools Script 
               Editor.  Just type in:
                  RUN list-web-objects IN web-utilities-hdl.
------------------------------------------------------------------------------*/
  IF CAN-FIND (FIRST wo) THEN DO:  
    FOR EACH wo:
      DISPLAY wo.id INTEGER(wo.hdl) LABEL "Handle"
              wo.hdl:FILE-NAME LABEL "FILE-NAME" FORMAT "X(24)":U
              wo.timeout-date wo.timeout-time.
    END.  
  END.
  ELSE {&OUT} "No Web Objects exist in the web-utilities-hdl.". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy State-Aware-Object 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Destroy Web object, if any, before destroying this-procedure. 
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  
  /* Destroy any state-aware Web object. */
  FOR EACH wo:
    /* Delete the persistent process. */
    IF VALID-HANDLE(wo.hdl) THEN DO:
      IF wo.new-object THEN
        RUN destroy IN wo.hdl NO-ERROR.
      ELSE
        RUN dispatch IN wo.hdl ('destroy':U) NO-ERROR.
    END.
    /* Now the record can be deleted. */
    DELETE wo.
  END.  

  /* Now do standard 'destroy'. */
  RUN dispatch IN THIS-PROCEDURE ('destroy':U) NO-ERROR.

  /* The global web-utilities-hdl is now invalid. */
  web-utilities-hdl = ?.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-web-object State-Aware-Object 
PROCEDURE run-web-object :
/*------------------------------------------------------------------------------
  Purpose:     Try to run a program  
  Parameters:  p_FileName - (CHAR) Name of application file
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pFileName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hWebObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTimeoutHandler   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCookie           AS CHARACTER  NO-UNDO.
  DEFINE VARIABL  cCookieEntries    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUniqueId         AS INTEGER    NO-UNDO.

  DEFINE BUFFER ip_wo FOR wo.
  
  /* Is this attempt to run on LOCKED agent? We can tell by looking to see if
     the WSEU cookie was sent from the browser.  If it was, then we need to
     check the individual web-object cookie.  In Evaluation mode, pretend
     there's a WSEU cookie. */
  IF wseu-cookie NE "":U OR cfg-eval-mode THEN DO:  
    /* Get the cookie of the Web object being run. */
    ASSIGN cCookie = get-cookie(pFileName).
    
    /* Since the Web object cookie can potentially have
     * 0, 1, or 2 entries in it, determine the number of entries in it.
     *
     * cCookieEntries = 0:
     *   o this is only true if the Web object being run is 'State-less'
     *   o if this is the case, then just run the Web object
     *   o once the Web object has been run, run check-web-state so its
     *     procedure handle can be deleted
     *
     * cCookieEntries = 1:
     *   o entry 1 = cUniqueId of the Web object
     *   o Web object is 'State-Aware'
     *   o if the Web object has an entry in the 'wo' temp-table, then verify
     *     that it has not timed out by running check-web-state, and then
     *     run continue-processing
     *   o if the Web object does not have an entry in the 'wo' temp-table
     *     and is 'State-Aware' then just run the Web object
     *   
     * cCookieEntries = 2:
     *   o entry 1 = cUniqueId of the Web object
     *   o entry 2 = name of Web object/procedure to run when the 'State-Aware'
     *               Web object that is currently running times out
     *   o if the Web object has an entry in the 'wo' temp-table', then verify
     *     that it has not timed out by running check-web-state, and then
     *     run continue-processing if it has not timed out or run the timeout
     *     handler if it has timed out
     *   o if the Web object does not have an entry in the 'wo' temp-table
     *     and is 'State-Aware' then just run the Web object
     */
    cCookieEntries = NUM-ENTRIES(cCookie).
    
    CASE (cCookieEntries):
      WHEN 0 THEN DO:
        ASSIGN 
          cUniqueId       = 0 
          cTimeoutHandler = "".
        /* If in Evaluation mode, try to find an entry for the Web object
           based on the file name rather than the unique id.  This handles
           the case where the user may have quit the browser and lost the
           Web object cookies and allows multiple browsers to access the
           application. */
        IF cfg-eval-mode THEN DO:
          FOR EACH ip_wo:
            IF ip_wo.hdl:FILE-NAME EQ pFileName THEN DO:
              RUN continue-processing IN web-utilities-hdl (pFileName, ip_wo.id). 
              RETURN.
            END.
          END.
        END.
      END.
  
      WHEN 1 THEN DO: 
        ASSIGN cUniqueId = INTEGER(cCookie).
        FIND FIRST ip_wo WHERE ip_wo.id EQ cUniqueId NO-ERROR.
        IF AVAILABLE ip_wo AND VALID-HANDLE (ip_wo.hdl) THEN DO:
          RUN continue-processing IN web-utilities-hdl (pFileName, cUniqueId). 
          RETURN.
        END. /* IF AVAILABLE */  
        ELSE DO:
          /* Kill the cookie used by this Agent to and return an error
             because there is no custom timeout handler. */
          delete-cookie(pFileName, ?, ?).
          RUN HtmlError ('The Web object to which you were attached has timed-out. Please start again.'). 
          RETURN.
        END. /* ELSE DO */
      END. /* WHEN 1 */
  
      WHEN 2 THEN DO:
        ASSIGN 
          cUniqueId       = INTEGER(ENTRY(1, cCookie))
          cTimeoutHandler = ENTRY(2, cCookie).
        FIND FIRST ip_wo WHERE ip_wo.id EQ cUniqueId NO-ERROR.
        /* If the object exists, use it...
           ...even if it has Web-State=Timed-out */
        IF AVAILABLE (ip_wo) AND VALID-HANDLE (ip_wo.hdl) THEN DO:
          RUN continue-processing IN web-utilities-hdl (pFileName, cUniqueId).
          RETURN.
        END. /* IF VALID-HANDLE */
        ELSE DO:
          /* Agent has timed out, run the timeout handler instead. Delete
             the old cookie. */
          delete-cookie(pFileName, ?, ?).
          pFileName = cTimeoutHandler.   
        END.
      END. /* WHEN 2*/
    END. /* CASE cCookie-values */
  END. /* IF wseu-cookie ne "":U... */
  
  /* Run standard run-web-object procedure in web/objects/web-util.p. */
  DO ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE
     ON STOP   UNDO, LEAVE
     ON QUIT       , LEAVE:  

    /* Run the file and note any run errors. */
    RUN VALUE(pFileName) PERSISTENT SET hWebObject NO-ERROR. 
    IF ERROR-STATUS:ERROR THEN DO:
      RUN show-error-status NO-ERROR.
      RUN HtmlError (SUBSTITUTE ("Unable to run Web object '&1'", pFileName )).
    END.
  END.
  
  /* Check the web-state (and delete objects that aren't state-aware). */
  IF VALID-HANDLE(hWebObject) THEN 
    RUN check-web-state (hWebObject).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-transaction-state State-Aware-Object 
PROCEDURE set-transaction-state :
/*------------------------------------------------------------------------------
  Purpose:     Sets the transaction state to a new and legal value.
               The six states are:
                   NONE, START-PENDING
                   ACTIVE, UNDO-PENDING, RETRY-PENDING, and COMMIT-PENDING.
               The only legal way to set this is:
                  * START-PENDING is legal only if state is NONE.
                  * UNDO-PENDING, RETRY-PENDING,  and COMMIT-PENDING
                    are only legal if the transaction-state is ACTIVE.
               All other values cannot be set.
               
  Parameters:  p_state -- (INPUT) the desired new state.
  Notes:       When setting states, you can omit the  "-PENDING"
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_state AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE new-state AS CHARACTER NO-UNDO.
  
  /* Capitalize, and complete the state name. */
  new-state = CAPS(p_state).
  IF (new-state BEGINS "START") AND ("START-PENDING" BEGINS new-state) THEN
    new-state = "START-PENDING".
  ELSE IF (new-state BEGINS "UNDO") AND ("UNDO-PENDING" BEGINS new-state) THEN
    new-state = "UNDO-PENDING".
  ELSE IF (new-state BEGINS "RETRY") AND ("RETRY-PENDING" BEGINS new-state) THEN
    new-state = "RETRY-PENDING".
  ELSE IF (new-state BEGINS "COMMIT") AND ("COMMIT-PENDING" BEGINS new-state) THEN
    new-state = "COMMIT-PENDING".
  
  CASE new-state:
    WHEN "START-PENDING":U THEN DO:
      IF transaction-state eq "NONE":U THEN 
      	transaction-state = "START-PENDING":U.
      ELSE 
      	RUN HtmlError (SUBSTITUTE (
          'Transaction cannot be STARTED while the transaction state is &1.',
          transaction-state)).
    END. /* WHEN "START"... */
    
    WHEN "UNDO-PENDING":U OR WHEN "RETRY-PENDING":U OR WHEN "COMMIT-PENDING":U 
    THEN DO:        
      IF transaction-state eq "ACTIVE":U THEN 
      	transaction-state = new-state.
      ELSE 
      	RUN HtmlError (SUBSTITUTE (
          'Transaction state cannot be set to &1 while the state is &2.',
          p_state,
          transaction-state)).
    END. /* WHEN "UNDO" OR "COMMIT"... */
    
    OTHERWISE DO:        
      RUN HtmlError (SUBSTITUTE (
        'Transaction state cannot be set to &1. It can only be set to ' +
        ' START, UNDO, RETRY, and COMMIT.',
        p_state)).
    END. /* OTHERWISE... */
  END CASE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-web-state State-Aware-Object 
PROCEDURE set-web-state :
/*------------------------------------------------------------------------------
  Purpose:     Set web-state for the current Web object. Create appropriate 
               cookie information.
  Parameters:  p_wo-hdl:  Procedure handle of the Web object
               p_timeout: Timeout period in minutes
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_wo-hdl          AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER p_timeout         AS DECIMAL NO-UNDO.

  DEFINE VARIABLE cTimeoutHandler   AS CHARACTER NO-UNDO.
 
  /* Before setting the web state for the web object, be sure to check
   * and see if the web object has a process-web-request procedures.
   * This check is primarily for when e4gl files are being run and if by
   * chance they run set-web-state without having a process-web-request
   * procedure in them.  Re:  97-02-06-028.
  */
  IF NOT CAN-DO(p_wo-hdl:INTERNAL-ENTRIES,"process-web-request":U) THEN DO:
    RUN HtmlError ("A Web object must support 'process-web-request' in order to be State-Aware.").
    RETURN.
  END.

  IF p_timeout > 0 THEN DO:
    /* Re: 19970206-006.  Although, v1.0 allowed timeout to be entered as a
     * decimal, it was being converted to an integer in set-attribute-list
     * and stored as an integer in the wo temp-table.  So, in order to
     * maintain 1.0 backwards compatibility, where users may have set timeout
     * to be a decimal value in their web objects, set-web-state will allow
     * timeout to be passed as a decimal, but it will be rounded up.
    */
    p_timeout = TRUNCATE (p_timeout + .99, 0).
    
    /* Set the attributes of the Web object itself. */
    RUN set-attribute-list IN p_wo-hdl 
      ('Web-State = state-aware,Web-Timeout = ':U + 
       STRING(p_timeout,">>>>>>>>9":U)) NO-ERROR. 
        
    /* Create the Web Object record for this object. It is necessary to do this
       right away if it does not exist because a call to find-web-objects is 
       executed when output-content-type() is called. This must find all the 
       state-aware web-objects. */
    RUN check-web-state (p_wo-hdl).
    
    /* Get the Web-cTimeoutHandler if it has been defined so that it */
    /* can be appended to the end of the cUniqueId */
    cTimeoutHandler = fetch-attr(p_wo-hdl, 'Web-cTimeoutHandler':U).

    /* Create the cookie used by the Broker to identify this Agent. */
    set-wseu-cookie(ENTRY(2,WEB-CONTEXT:EXCLUSIVE-ID,"=":U)).

    /* Create the cookie used by this Agent to identify the Web object. */
    /* Append cTimeoutHandler to the end of the cUniqueId if it exists */
    IF (cTimeoutHandler <> "" AND cTimeoutHandler <> ?) THEN
      set-cookie(p_wo-hdl:FILE-NAME /* "WSObjectId":U */,
                     (STRING(p_wo-hdl:UNIQUE-ID) + ',':U + cTimeoutHandler), 
                     ?, ?, ?, ?, ?).
    ELSE
      set-cookie(p_wo-hdl:FILE-NAME /* "WSObjectId":U */,
                     STRING(p_wo-hdl:UNIQUE-ID), ?, ?, ?, ?, ?).
  END.
  
  /* Explicitly kill the State-Aware web object */
  ELSE DO:
    RUN set-attribute-list IN p_wo-hdl 
      ('Web-State = state-less,Web-Timeout = 0':U) NO-ERROR. 

    /* Kill the cookie used by this web agent to identify the Web object. */
    delete-cookie(p_wo-hdl:FILE-NAME, ?, ?). /* "WSObjectId":U */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-error-status State-Aware-Object 
PROCEDURE show-error-status :
/* ---------------------------------------------------------------------------
  Purpose:  Output PROGRESS ERROR-STATUS errors
  Parameters:  <none>
  Notes:    A localization of this method can look at the message number to 
            display a custom error or suppress standard error display.
--------------------------------------------------------------------------- */
  DEFINE VARIABLE ix  AS INTEGER    NO-UNDO.

  /* Check to see if there are any errors. If so, output them one by one. */
  IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
    output-content-type("text/html":U).
    {&OUT}
      "<H1>WebSpeed Error Messages</H1>~n~n":U .
      
    DO ix = 1 TO ERROR-STATUS:NUM-MESSAGES:
      {&OUT}
        "<P>":U html-encode(ERROR-STATUS:GET-MESSAGE(ix)) "</P>~n":U.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
