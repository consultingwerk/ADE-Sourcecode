&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 - adm2
/* Procedure Description
"WEB Utilities Object

This is run persistently by the WEB-DISP.P procedure. It includes methods for manipulating Web files, cookies, and CGI variables."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Web-Utilities-Object 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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

File: web-util.p 

Description:
    WEB Utilities Procedures.  These are available to all procedures that
    can access the NEW GLOBAL SHARED VARIABLE web-utilities-hdl

Modifications:
    Added get-time-remaining procedure for new  nhorn 1/31/97 
    attribute WEB-TIME-REMAINING

    Changed to use new function API calls such as html-encode(),
    set-cookie(), get-cookie(), and delete-cookie(). billb 2/10/97

Input Parameters:   <none>

Output Parameters:  <none>

Author: D.Adams, B.Burton, L.Laferriere, Wm.T.Wood

Created: 06/3/96

---------------------------------------------------------------------------*/

/* *********************** Included Definitions *********************** */

/* Indicate we're in web-util.p.  This allows function prototypes to be
   correctly defined for internal use here or external use by Web objects. */
&GLOBAL-DEFINE WEB-UTIL_P TRUE
{ src/web/method/cgidefs.i {&NEW} }      /* Basic CGI variables */
{ src/web/method/cgiarray.i {&NEW} }     /* Extended CGI array variables */
{ src/web/method/tagmap.i {&NEW} }       /* HTML/PSC type mapping */

/* ***************************  Definitions  ************************** */

/* tagmap definitions. */
&SCOPED-DEFINE tagMapFileName "tagmap.dat":U
DEFINE STREAM tagMapStream.

&Scoped-define WEB-NOTIFY WEB-NOTIFY
&Scoped-define WEB-CURRENT-ENVIRONMENT WEB-CONTEXT:CURRENT-ENVIRONMENT
&Scoped-define WEB-FORM-INPUT WEB-CONTEXT:FORM-INPUT
&Scoped-define WEB-EXCLUSIVE-ID WEB-CONTEXT:EXCLUSIVE-ID

/* Field name in WEB-CONTENT:EXCLUSIVE-ID */
&Global-define CONNECTION-NAME "SERVER_CONNECTION_ID":U
&Global-define WSEU-NAME "WSEU":U

/* Computing timeout periods needs the number of seconds in one day */
&Scoped-define ONE-DAY 86400

/* Define a Temp-Table to hold the handles of state-aware objects, and
   their timeout date and time. */
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
DEFINE SHARED VARIABLE server-connection AS CHARACTER NO-UNDO.

/* Variables for configuration options.  Initialized upon Agent startup. */
DEFINE VARIABLE cfg-environment     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cfg-eval-mode       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cfg-appurl          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cfg-debugging       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cfg-cookiepath      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cfg-cookiedomain    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFunction           AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Utilities-Object
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD check-agent-mode Web-Utilities-Object 
FUNCTION check-agent-mode RETURNS LOGICAL
  (INPUT p_mode AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-config Web-Utilities-Object 
FUNCTION get-config RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Utilities-Object
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW Web-Utilities-Object ASSIGN
         HEIGHT             = 23.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Web-Utilities-Object 
/* ************************* Included-Libraries *********************** */

{src/web/method/proto.i}
{src/web/method/admweb.i}
{src/web/method/cgiutils.i}
{src/web/method/cookies.i}
{src/web/method/message.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Web-Utilities-Object 


/* This procedure is sets up the GLOBAL variable: web-utilities-hdl */
web-utilities-hdl = THIS-PROCEDURE.

/* It is run persistent by web-disp.p (the startup procedure). */
RUN set-attribute-list IN THIS-PROCEDURE ("Web-State=persistent":U).

/* User Defined Functions */
FUNCTION fetch-attr RETURNS CHARACTER 
( p_wo-hdl    AS HANDLE,
  p_attr-name AS CHARACTER ):
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(p_wo-hdl) THEN DO:
    /* See if this is a 9.0a file.  If so, run new function. */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-delete-tagmap-utilities Web-Utilities-Object 
PROCEDURE adm-delete-tagmap-utilities :
/*------------------------------------------------------------------------------
  Purpose:     Delete any tagmap utility procedures as well as the tagmap
               records.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Remove any existing tagmap records and persistent utilities. */
  FOR EACH tagmap:
    /* Delete the persistent process. */
    IF VALID-HANDLE(tagmap.util-Proc-Hdl) THEN
      DELETE PROCEDURE tagmap.util-Proc-Hdl.
    /* Now the record can be deleted. */
    DELETE tagmap.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-reset-tagmap-utilities Web-Utilities-Object 
PROCEDURE adm-reset-tagmap-utilities :
/*------------------------------------------------------------------------------
  Purpose:     Load the tagmap.dat file and create entries in the tagmap temp-
               table. Run the procedures associated with each one of these
               files.              
  Parameters:  <none>
  Notes:       Any existing tagmap records are first deleted.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE next-line   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tagmapfile  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rSearchFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-count     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE num-ent     AS INTEGER   NO-UNDO.
  
  DEFINE BUFFER xtagmap FOR tagmap.
  
  /* Remove any existing tagmap records and persistent utilities. */
  RUN dispatch IN THIS-PROCEDURE ('delete-tagmap-utilities':U) NO-ERROR.
  
  /* Make sure the tagmap.dat file exists in the PROPATH */
  ASSIGN tagmapfile = SEARCH({&tagMapFileName})
         i-count    = 0.
  IF tagmapfile = ? THEN DO:
    RUN HtmlError (SUBSTITUTE("The file &1 must be in your PROPATH", 
                    {&tagMapFileName})).
    RETURN ERROR.
  END.
  INPUT STREAM tagMapStream FROM VALUE(tagmapfile) NO-ECHO.

  REPEAT ON ENDKEY UNDO, LEAVE:
    /* Clear variable before read to handle blank lines. */
    ASSIGN next-line = "". 
    IMPORT STREAM tagMapStream UNFORMATTED next-line.
    
    IF LENGTH(next-line,"CHARACTER":U) > 4 AND
      SUBSTRING(next-line,1,1,"CHARACTER":U) <> "#":U THEN DO:
      CREATE tagmap.
      ASSIGN
        i-count               = i-count + 1
        num-ent               = NUM-ENTRIES(next-line)
        tagmap.i-order        = i-count
        tagmap.htm-Tag        = ENTRY(1,next-line)
        tagmap.htm-Type       = (IF num-ent >= 3 THEN 
                                   ENTRY(3,next-line) ELSE "":U)
        tagmap.psc-Type       = (IF num-ent >= 4 
                                   THEN ENTRY(4,next-line) ELSE "":U)
        tagmap.util-Proc-Name = (IF num-ent >= 5 
                                   THEN ENTRY(5,next-line) ELSE "":U)
        .
      
      /* We allow for empty utility procedures. */
      IF tagmap.util-Proc-Name ne "":U THEN DO:
        /* If there another tagmap that is already running this procedure? */
        FIND FIRST xtagmap WHERE xtagmap.util-Proc-Name eq tagmap.util-Proc-Name
                             AND RECID(xtagmap) ne RECID(tagmap) NO-ERROR.
        IF AVAILABLE (xtagmap) AND VALID-HANDLE(xtagmap.util-Proc-Hdl) THEN
          tagmap.util-Proc-Hdl = xtagmap.util-Proc-Hdl.
        ELSE DO:
          /* Check that the file exists. */
          RUN adecomm/_rsearch.p (INPUT tagmap.util-Proc-Name, OUTPUT rSearchFile).
          IF rSearchFile ne ? THEN DO:
            RUN VALUE(rSearchFile) PERSISTENT SET tagmap.util-Proc-Hdl NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
              tagmap.util-Proc-Hdl = ?.
              RUN HtmlError (SUBSTITUTE ("Unable to run Tagmap Utility file '&1'", 
                                         tagmap.util-Proc-Name )).
            END. /* IF...ERROR... */
          END. /* IF rSearchFile ne ?... */
          ELSE
            RUN HtmlError (SUBSTITUTE ("Unable to find Tagmap Utility file '&1'", 
                                       tagmap.util-Proc-Name )).
        END. /* IF <not> AVAILABLE (xtagmap)... */
      END. /* IF...util-Proc-Name ne ""... */
     END. /* IF LENGTH... */
  END. /* REPEAT... */
  
  /* Close the tabmap stream. */
  INPUT STREAM tagMapStream CLOSE.
  
END PROCEDURE.

/* run_utility_procs - end of file */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-show-error-status Web-Utilities-Object 
PROCEDURE adm-show-error-status :
/* -----------------------------------------------------------
      Purpose:  Output PROGRESS ERROR-STATUS errors
      Parameters:  <none>
      Notes:    A localization of this method can look at the message
                number to display a custom error or suppress standard
                error display.
    ------------------------------------------------------------- */
    DEFINE VARIABLE cntr AS INTEGER   NO-UNDO.
    DEFINE VARIABLE txt  AS CHARACTER NO-UNDO.

    /* Check to see if there are any errors. If so, output them one by one. */
    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      output-content-type("text/html":U).
      {&OUT}
      "<H1>WebSpeed Error Messages</H1>~n~n":U .
      
      DO cntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
        {&OUT}
        "<P>":U html-encode(ERROR-STATUS:GET-MESSAGE(cntr)) "</P>~n":U.
      END. /* DO cntr... */
    END. /* IF...NUM-MESSAGES > 0 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-exclusive-pause Web-Utilities-Object 
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

  /* Find the first state-aware web-object and return the time
   * remaining on its timeout. 
   * Note that the primary index is 'date-time' which includes
   * Web object timeout-time and timeout-date.  Since the
   * default sorting on the records in the 'wo' temp-table is
   * ascending, the remaining timeout period will come from the
   * first 'wo' record which is the next Web object to timeout.
   * This will be the exclusive pause period. 
  */
  Min-Search:
  FOR EACH ip_wo:
    IF fetch-attr(ip_wo.hdl, 'Web-State':U) = 'State-Aware':U THEN DO:
      p_period = (ip_wo.timeout-date - TODAY) * {&ONE-DAY} +
                 (ip_wo.timeout-time - TIME).
      LEAVE Min-Search.
    END. /* IF fetch-attr(... */
  END. /* FOR EACH ip_wo */

  /* Don't return a negative number */
  IF p_period < 0 THEN 
    p_period = 0.
 
  /* If the pause-period is 0, then the agent will no longer be locked, so 
   * delete all timed out objects.  Indeed all objects should be deleted.
   */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-web-state Web-Utilities-Object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE continue-processing Web-Utilities-Object 
PROCEDURE continue-processing :
/*------------------------------------------------------------------------------
 Purpose:     Process another web request in a state-aware Web object .
 Parameters:  p_FileName: File Name of this Web object.
              p_unique-id: Unique ID of this procedure.
 Notes:
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_FileName   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_unique-id  AS INTEGER   NO-UNDO.

  DEFINE VARIABLE l_locked            AS LOGICAL NO-UNDO.
  DEFINE VARIABLE i_time-remaining    AS INTEGER NO-UNDO.
  
  DEFINE BUFFER ip_wo    FOR wo.
  DEFINE BUFFER ip_sa_wo FOR wo.

  /* Find a record in the 'wo' temp-table whose handle matches
   * the one passed to this procedure.
   */
  FIND ip_wo WHERE ip_wo.id eq p_unique-id NO-ERROR.
  IF NOT AVAILABLE (ip_wo) THEN DO:
    /* If there is no 'wo' record that has a handle that matches the one
     * passed to this procedure then the the Web object must have timed out
     * or the Agent that was running the Web object became AVAILABLE and
     * LOCKED to another browser/user.
     */
    IF RIGHT-TRIM(wseu-cookie, '012346789':U) <>
       RIGHT-TRIM(ENTRY(2, {&WEB-EXCLUSIVE-ID}, '=':U), '0123456789':U) THEN
      RUN HtmlError 
        (SUBSTITUTE('The Agent process to which you were attached has timed-out. Please start again.  You will be reattached to another Agent process.  The expected Agent is &1, but request was received by &2.', 
        wseu-cookie, ENTRY(2, {&WEB-EXCLUSIVE-ID}, '=':U))).
    ELSE DO:
      /* Kill the cookie used by this Agent to identify the Web object. */
      delete-cookie(p_FileName, ?, ?).
      RUN HtmlError ('The Web object to which you were attached has timed-out. Please start again.').
    END.
  END. /* IF NOT AVAILABLE */ 
  ELSE DO:
    IF VALID-HANDLE (ip_wo.hdl) THEN DO:
      /* If the Web object was found in the temp-table, then it is 'State-Aware'
       * and has not timed out.  Therefore dispatch 'process-web-request in
       * the Web object handle since it is already running.
       * Once 'process-web-request completes, run check-web-state to check 
       * to see if the 'State-Aware' Web object has timed out, and in that
       * case delete it's record from the 'wo' temp-table.
       */
      /* Catch all possible Progress run-time "break" conditions.  
       * [NOTE: this is similar to the ExecuteRun logic in adeedit/psystem.i].
       */
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
          RUN dispatch IN THIS-PROCEDURE ('show-error-status':U) NO-ERROR.
          RUN HtmlError (SUBSTITUTE ("Unable to continue running Web object '&1'", ip_wo.hdl:FILE-NAME)).
        END. /* IF...ERROR... */
      END. /* Run-Block: DO... */
    
      RUN check-exclusive-pause (OUTPUT i_time-remaining).

    END. /* End IF VALID-HANDLE */ 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-web-objects Web-Utilities-Object 
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
  Search-Loop:
  FOR EACH ip_wo:
    IF fetch-attr(ip_wo.hdl, 'Web-State':U) eq "state-aware":U THEN DO:
      rslt = TRUE.
      LEAVE Search-Loop.
    END.
  END. /* Search-Loop: */   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-server-connection Web-Utilities-Object 
PROCEDURE get-server-connection :
/*------------------------------------------------------------------------------
  Purpose:     Return the value of SESSION:SERVER-CONNECTION-ID
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RETURN server-connection.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-time-remaining Web-Utilities-Object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-transaction-state Web-Utilities-Object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-form Web-Utilities-Object 
PROCEDURE init-form :
/*---------------------------------------------------------------------------
Procedure:   init-form
Description: Initializes variables from the web form input and QUERY_STRING
             part of the URL.
Input:       Web form input
Output:      Sets global variables defined in src/web/method/cgidefs.i
----------------------------------------------------------------------------*/
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.
  DEFINE VARIABLE k AS INTEGER NO-UNDO.
  DEFINE VARIABLE m AS INTEGER NO-UNDO.
  DEFINE VARIABLE a AS INTEGER NO-UNDO.
  DEFINE VARIABLE i-field AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-old-field AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-pair AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-www-form-urlencoded AS CHARACTER NO-UNDO.

  ASSIGN
    i-www-form-urlencoded = ""
    FieldVar              = ""
    FieldList             = ""
    j                     = 0.

  RETURN.
  
&IF FALSE &THEN
  IF use-core-api THEN RETURN.
 
  IF CONTENT_TYPE BEGINS "application/x-www-form-urlencoded":U THEN
    ASSIGN i-www-form-urlencoded =
      SUBSTRING({&WEB-FORM-INPUT}, 1, CONTENT_LENGTH, "RAW":U).

  /* First iteration, decode any form input via the POST method.
     Second iteration, decode QUERY_STRING which has the same format
     when arguments are passed via the GET method. */
  ASSIGN
    a = 0
    i-old-field = "".

  DO k = 1 TO 2:
    IF k = 1 AND LENGTH(i-www-form-urlencoded) = 0 THEN NEXT.
    ELSE IF k = 2 THEN
      i-www-form-urlencoded = QUERY_STRING.

    /* Replaces pluses with spaces */
    ASSIGN i-www-form-urlencoded =
      REPLACE(i-www-form-urlencoded, "+":U, " ":U).

    /* Loop through each field=value pair */
    DO i = 1 TO NUM-ENTRIES(i-www-form-urlencoded, "&":U):
      ASSIGN i-pair = ENTRY(i, i-www-form-urlencoded, "&":U).
      /* Do we have a field=value pair? */
      IF NUM-ENTRIES(i-pair,"=":U) > 1 THEN
        ASSIGN
          i-field = url-decode(ENTRY(1, i-pair, "=":U))
          i-value = url-decode(ENTRY(2, i-pair, "=":U)).
      /* No, just a bare value */
      ELSE
        ASSIGN
          a = a + 1        /* argument counter */
          i-field = "arg":U + STRING(a)  /* name is "argN" */
          i-value = url-decode(i-pair).

      /* If the prior field name is the same as the current one, then
         just add the new value to the same field with a comma
         delimiter (default).  */
      IF i-field = i-old-field THEN
        FieldVar[j] = FieldVar[j] + SelDelim + i-value.
      ELSE DO:
        /* If the current field name already exists but is out of
           order (faulty HTML authoring?), add the current field
           value to the existing field value (list). */
        ASSIGN m = LOOKUP(i-field, FieldList).
        IF m > 0 THEN
          FieldVar[m] = FieldVar[m] + SelDelim + i-value.
        ELSE 
          ASSIGN        
            /* Normal case--new field.  Add new field to field list. */
            j           = j + 1     /* next field subscript in array */
            FieldVar[j] = i-value 
            FieldList   = (IF FieldList eq "":U THEN "":U ELSE FieldList + ",":U)
                          + i-field
            i-old-field = i-field
            .
      END. /* different field name from prior one */
    END.  /* each & */
  END.  /* form, query_string decoding */
&ENDIF /* use-core-api */

END PROCEDURE.  /* init-form */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Web-Utilities-Object 
PROCEDURE init-request :
/*---------------------------------------------------------------------------
Procedure:   init-request
Description: Initializes WebSpeed environment for each web request
Input:       Environment variables
Output:      Sets global variables defined in src/web/method/cgidefs.i
---------------------------------------------------------------------------*/
  DEFINE VARIABLE i-key           AS CHARACTER FORMAT "x(20)" NO-UNDO.
  DEFINE VARIABLE i-value         AS CHARACTER FORMAT "x(40)" NO-UNDO.
  DEFINE VARIABLE i-debug-cookie  AS CHARACTER FORMAT "x(20)" NO-UNDO.
  DEFINE VARIABLE i               AS INTEGER NO-UNDO.
  DEFINE VARIABLE v-http-host     AS CHARACTER FORMAT "x(40)" NO-UNDO.
  DEFINE VARIABLE v-host          AS CHARACTER FORMAT "x(40)" NO-UNDO.
  DEFINE VARIABLE v-port          AS CHARACTER FORMAT "x(5)"  NO-UNDO.

  ASSIGN
    /* Check for a "WSDebug" Cookie */
    i-debug-cookie = get-cookie ("WSDebug":U)
    /* Initialize debug options based on Cookie.  If there is no Cookie,
       then debug-options will be blank.  This is fine because it needs
       to be initialized for each request anyway. */
    debug-options = i-debug-cookie.

  RUN init-variables.    /* initialize CGI and misc. variables */
  RUN init-form.         /* initialize form input and parse QUERY_STRING */

  /* Get the WSEU cookie. */
  wseu-cookie       = get-cookie ({&WSEU-NAME}).
  
  /* Reset the server-connection variable and SERVER_CONNECTION_ID cookie. */
  RUN set-server-connection(SESSION:SERVER-CONNECTION-ID).
  
  /* Initialize User Fields */
  ASSIGN
    UserFieldVar  = ""
    UserFieldList = "".

  /* Get debugging options if specified in QUERY_STRING or form input */
  ASSIGN i-value = get-field("debug":U).

  /* Check for "debug" with no options in QUERY_STRING for backwards
     compatibility. */
  IF i-value = "" AND QUERY_STRING MATCHES "*debug*":U THEN
    ASSIGN i-value = "all":U.

  /* Don't allow debugging if disabled via configuration options. */
  IF debugging-enabled = FALSE THEN
    ASSIGN i-value = "".
    
  /* Turn debugging off? */
  IF CAN-DO(i-value,"off":U) THEN DO:  /* debug=off? */
    ASSIGN debug-options = "".
    IF i-debug-cookie <> "" THEN
      delete-cookie("WSDebug":U,?,?).  /* delete cookie if there is one */
  END.

  /* Else, if debug=option1,option2 etc. was specified, turn debugging on? */
  ELSE IF i-value <> "" THEN DO:
    IF CAN-DO(i-value,"on":U) THEN     /* debug=on? */
      ASSIGN debug-options = "all":U.
    /* Else, assign specified values */
    ELSE
      ASSIGN debug-options = i-value.
    /* Set the debug Cookie if different than debug options or not set */
    IF debug-options <> i-debug-cookie THEN
      set-cookie ("WSDebug":U, debug-options, ?, ?, ?, ?, ?).
  END.

  /*
  ** Set global variables HostURL, AppURL and SelfURL so self-referencing
  ** URL's cat be generated by applications.
  */

  /* If the Host: header (HTTP_HOST) was sent by the browser, using it will
     provide for fewer problems with self-referencing URL's than
     SERVER_NAME and SERVER_PORT. */
  ASSIGN v-http-host = get-cgi("HTTP_HOST":U).
  IF v-http-host = "" THEN
    /* No Host: header was sent by the browser. */
    ASSIGN v-host = SERVER_NAME
           v-port = SERVER_PORT.
  ELSE IF NUM-ENTRIES(v-http-host, ":":U) = 2 THEN
    /* Host: hostname:port combination was sent by the browser */
    ASSIGN v-host = ENTRY(1, v-http-host, ":":U)
           v-port = ENTRY(2, v-http-host, ":":U).
  ELSE
    /* Else Host: hostname with no port number was sent by the browser */
    ASSIGN v-host = v-http-host
           v-port = SERVER_PORT.
  /* Set the scheme, host and port of the URL to ourself.  Omit
     port if 80 or 443 if https is on. */
  IF HTTPS = "ON" THEN
    ASSIGN HostURL = (IF v-host = "" THEN ""
                      ELSE "https://":U + v-host +
                           (IF v-port = "443":U THEN "" ELSE ":":U + v-port)).
  ELSE
    ASSIGN HostURL = (IF v-host = "" THEN ""
                      ELSE "http://":U + v-host +
                           (IF v-port = "80":U THEN "" ELSE ":":U + v-port)).

  ASSIGN
    /* Server-relative URL to ourself (this program) except for optional
       QUERY_STRING. */
    SelfURL = SCRIPT_NAME + PATH_INFO.

  /* Check for alternate URL format used by the Messengers */
  IF PATH_INFO BEGINS "/WService=":U THEN
    ASSIGN
      /* Web object filename is everything after the second "/" in PATH_INFO */
      AppProgram = (IF NUM-ENTRIES(PATH_INFO, "/":U) >= 3
                    THEN SUBSTRING(PATH_INFO, INDEX(PATH_INFO, "/":U, 2) + 1)
                    ELSE "")
      /* Server relative URL of this Web objects's application */
      AppURL     = SCRIPT_NAME + "/":U + ENTRY(2, PATH_INFO, "/":U).

  ELSE
    ASSIGN
      /* Web object filename is everything after the second "/" in PATH_INFO */
      AppProgram = SUBSTRING(PATH_INFO, 2)
      /* Server relative URL of this Web objects's application */
      AppURL     = SCRIPT_NAME.

  /* If the ApplicationURL option was set in the Windows Registry or
     webspeed.cnf, then use that to set AppURL instead of SCRIPT_NAME and
     PATH_INFO.  Make sure it's prefixed with a "/" since we don't handle
     an entire URL. */
  IF cfg-appurl BEGINS "/":U THEN
    ASSIGN
      AppURL = cfg-appurl
      SelfURL = AppURL + "/":U + AppProgram.

  /* The Alibaba 2.0 NT server upper cases SCRIPT_NAME and PATH_INFO.  This
     is a bug.  To work around this, lower case AppURL, etc.  Otherwise
     Cookies (which are case sensitive) will fail to match preventing
     locking from working . */
  IF SERVER_SOFTWARE BEGINS "Alibaba/2":U THEN
    ASSIGN
      HostURL = LC(HostURL)
      AppURL = LC(AppURL)
      SelfURL = LC(SelfURL)
      AppProgram = LC(AppProgram).

  /* An HTTP header newline must have both CR and LF for all OS's.
     Bug: 97-03-04-008  Some web servers such as Netscape-Fasttrack 2.01
     don't like the CR character so allow the newline to be changed. 
     (NOTE: The FrontPage Personal Web Server is also based on the same
     NCSA Webserver, so treat it the same way.) */
  IF SERVER_SOFTWARE BEGINS "Netscape-":U OR SERVER_SOFTWARE BEGINS "FrontPage-PWS":U THEN
    ASSIGN http-newline = "~n":U.
  ELSE
    ASSIGN http-newline = "~r~n":U.

  /* Set Cookie defaults from either configuration defaults or AppURL */
  ASSIGN
    CookiePath = (IF cfg-cookiepath <> "" THEN cfg-cookiepath ELSE AppURL)
    CookieDomain = cfg-cookiedomain.
    
END PROCEDURE.  /* init-request */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Web-Utilities-Object 
PROCEDURE init-session :
/*---------------------------------------------------------------------------
Procedure:   init-session
Description: Initializes PROGRESS session variables from the environment. 
Input:       <none>
Output:      Sets global variables defined in src/web/method/cgidefs.i
Notes:
             These values should be the default values on a WEB-based client.
             (But it never hurts to make sure.)
             
----------------------------------------------------------------------------*/
  /* Never pause for user input. */
  PAUSE 0 BEFORE-HIDE.
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = no
         SESSION:APPL-ALERT-BOXES   = no
         .
  /* Get configuration settings from ubroker.properties */
  ASSIGN
    cfg-environment  = WEB-CONTEXT:GET-CONFIG-VALUE("srvrAppMode":U)
    cfg-eval-mode    = check-agent-mode("Evaluation") /* TRUE if eval mode */
    cfg-debugging    = WEB-CONTEXT:GET-CONFIG-VALUE("srvrDebug":U)
    cfg-appurl       = WEB-CONTEXT:GET-CONFIG-VALUE("applicationURL":U)
    cfg-cookiepath   = WEB-CONTEXT:GET-CONFIG-VALUE("defaultCookiePath":U)
    cfg-cookiedomain = WEB-CONTEXT:GET-CONFIG-VALUE("defaultCookieDomain":U)
    RootURL          = WEB-CONTEXT:GET-CONFIG-VALUE("wsRoot":U)
    .
    
  /* If in Production mode and debugging is not enabled or debugging is
     disabled, then set flag to disable debugging. */
  IF (check-agent-mode("Production":U) AND
    NOT CAN-DO(cfg-debugging, "Enabled":U)) OR
    CAN-DO(cfg-debugging, "Disabled":U) THEN
    ASSIGN debugging-enabled = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-variables Web-Utilities-Object 
PROCEDURE init-variables :
/*---------------------------------------------------------------------------
Procedure:   init-variables
Description: Initializes PROGRESS variables from the environment
Input:       Environment variables
Output:      Sets global variables defined in src/web/method/cgidefs.i
----------------------------------------------------------------------------*/
  DEFINE VARIABLE i-field AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-pair  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE asc-del AS CHARACTER NO-UNDO 
    INITIAL "~377":U.   /* delimiter character in octal = CHR(255) */
  DEFINE VARIABLE hex-del AS CHARACTER NO-UNDO
    INITIAL "%FF":U.    /* delimiter character in encoded hex */
  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE eql     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE n-entry AS INTEGER   NO-UNDO.  /* for the do loop */
    n-entry = NUM-ENTRIES({&WEB-CURRENT-ENVIRONMENT},asc-del).

  /* Global variables to initialize with each request */
  ASSIGN
    CgiVar              = ""  
    CgiList             = ""  
    output-content-type = ""
    SelDelim            = ",":U.

  /* If there are more environment variables than the array can handle,
     put a message into the server log and truncate. */
  IF n-entry > {&MAX-CGI} THEN DO:
    MESSAGE " ** CGIIP is sending too many environment variables--truncating to " {&MAX-CGI}.
    n-entry = {&MAX-CGI}.
  END.

  /* Read in the CGI environment variable pairs which are delimited by 
     ASCII 255 characters.  Any literal ASCII 255 values have been encoded
     as hexidecimal %FF ("~377") in the same manner as URL encoding. */
  DO ix = 1 TO n-entry:
    ASSIGN
      i-pair     = ENTRY(ix,{&WEB-CURRENT-ENVIRONMENT},asc-del)
      eql        = INDEX(i-pair,"=":U)
      i-field    = SUBSTRING(i-pair,1,eql - 1,"RAW":U)
      CgiVar[ix] = REPLACE(SUBSTRING(i-pair,eql + 1,-1,"RAW":U),hex-del,asc-del)
      CgiList    = CgiList + (IF CgiList = "" THEN "" ELSE ",":U ) + i-field.
  END.

  /* Import CGI 1.1 variables into global variables */
  ASSIGN
    GATEWAY_INTERFACE       = get-cgi("GATEWAY_INTERFACE":U)
    SERVER_SOFTWARE         = get-cgi("SERVER_SOFTWARE":U)
    SERVER_PROTOCOL         = get-cgi("SERVER_PROTOCOL":U)
    SERVER_NAME             = get-cgi("SERVER_NAME":U)
    SERVER_PORT             = get-cgi("SERVER_PORT":U)
    REQUEST_METHOD          = get-cgi("REQUEST_METHOD":U)
    SCRIPT_NAME             = get-cgi("SCRIPT_NAME":U)
    PATH_INFO               = get-cgi("PATH_INFO":U)
    PATH_TRANSLATED         = get-cgi("PATH_TRANSLATED":U)
    QUERY_STRING            = get-cgi("QUERY_STRING":U)
    REMOTE_ADDR             = get-cgi("REMOTE_ADDR":U)
    REMOTE_HOST             = get-cgi("REMOTE_HOST":U)
    REMOTE_IDENT            = get-cgi("REMOTE_IDENT":U)
    REMOTE_USER             = get-cgi("REMOTE_USER":U)
    AUTH_TYPE               = get-cgi("AUTH_TYPE":U)
    REMOTE_IDENT            = get-cgi("REMOTE_IDENT":U)
    CONTENT_TYPE            = get-cgi("CONTENT_TYPE":U)
    CONTENT_LENGTH          = INTEGER(get-cgi("CONTENT_LENGTH":U)) NO-ERROR.

  /* Import some HTTP variables into global variables */
  ASSIGN
    HTTP_ACCEPT             = get-cgi("HTTP_ACCEPT":U)
    HTTP_COOKIE             = get-cgi("HTTP_COOKIE":U)
    HTTP_REFERER            = get-cgi("HTTP_REFERER":U)
    HTTP_USER_AGENT         = get-cgi("HTTP_USER_AGENT":U)
    HTTPS                   = get-cgi("HTTPS":U)
    .

  /* Test for Microsoft's IIS which doesn't use HTTPS ON/OFF */
  IF SERVER_SOFTWARE BEGINS "Microsoft-IIS/":U AND
    get-cgi("SERVER_PORT_SECURE":U) = "1":U THEN
    ASSIGN HTTPS = "ON":U.

  /* Other environment variables */
  ASSIGN
    utc-offset              = WEB-CONTEXT:UTC-OFFSET
    useConnID               = get-cgi("useConnID":U)
    .
    
  /* If SERVER_PORT is null, then set it 80 or 443 if HTTPS is ON */
  IF SERVER_PORT = "" THEN
    ASSIGN SERVER_PORT = (IF HTTPS = "ON":U THEN "443":U ELSE "80":U).

END PROCEDURE.  /* init-variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE list-web-objects Web-Utilities-Object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy Web-Utilities-Object 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-web-object Web-Utilities-Object 
PROCEDURE run-web-object :
/*------------------------------------------------------------------------------
  Purpose:     Try to run a program  
  Parameters:  p_FileName - (CHAR) Name of application file
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_FileName AS CHAR NO-UNDO.

  DEFINE VARIABLE rSearchFile       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rFileExt          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE this-wo-hdl       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE wo-cookie         AS CHARACTER NO-UNDO. /* Web object */
  DEFINE VARIABL  wo-cookie-entries AS INTEGER   NO-UNDO.
  DEFINE VARIABLE unique-id         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE timeout-handler   AS CHARACTER NO-UNDO.

  DEFINE BUFFER ip_wo FOR wo.
  
  /* Is this a attempt to run on LOCKED agent? We can tell by looking to see
     if the wseu cookie was sent from the browser.  If it was, then we need
     to check the individual web-object cookie.  In Evaluation mode, pretend
     there's a WSEU cookie. */
  IF wseu-cookie ne "":U OR cfg-eval-mode THEN DO:  
     
    /* Get the cookie of the Web object being run. */
    ASSIGN wo-cookie = get-cookie(p_FileName).
    
    /* Since the Web object cookie can potentially have
     * 0, 1, or 2 entries in it, determine the number of entries in it.
     *
     * wo-cookie-entries = 0:
     *   o this is only true if the Web object being run is 'State-less'
     *   o if this is the case, then just run the Web object
     *   o once the Web object has been run, run check-web-state so its
     *     procedure handle can be deleted
     *
     * wo-cookie-entries = 1:
     *   o entry 1 = unique-id of the Web object
     *   o Web object is 'State-Aware'
     *   o if the Web object has an entry in the 'wo' temp-table, then verify
     *     that it has not timed out by running check-web-state, and then
     *     run continue-processing
     *   o if the Web object does not have an entry in the 'wo' temp-table
     *     and is 'State-Aware' then just run the Web object
     *   
     * wo-cookie-entries = 2:
     *   o entry 1 = unique-id of the Web object
     *   o entry 2 = name of Web object/procedure to run when the 'State-Aware'
     *               Web object that is currently running times out
     *   o if the Web object has an entry in the 'wo' temp-table', then verify
     *     that it has not timed out by running check-web-state, and then
     *     run continue-processing if it has not timed out or run the timeout
     *     handler if it has timed out
     *   o if the Web object does not have an entry in the 'wo' temp-table
     *     and is 'State-Aware' then just run the Web object
     */
    wo-cookie-entries = NUM-ENTRIES(wo-cookie).
    
    CASE (wo-cookie-entries):
      WHEN 0 THEN DO:
        ASSIGN 
          unique-id       = 0 
          timeout-handler = "".
        /* If in Evaluation mode, try to find an entry for the Web object
           based on the file name rather than the unique id.  This handles
           the case where the user may have quit the browser and lost the
           Web object cookies and allows multiple browsers to access the
           application. */
        IF cfg-eval-mode THEN DO:
          FOR EACH ip_wo:
            IF ip_wo.hdl:FILE-NAME eq p_FileName THEN DO:
              RUN continue-processing IN web-utilities-hdl (p_FileName, ip_wo.id). 
              RETURN.
            END.
          END.
        END.
      END.
  
      WHEN 1 THEN DO: 
        ASSIGN unique-id = INTEGER(wo-cookie).
        FIND FIRST ip_wo WHERE ip_wo.id eq unique-id NO-ERROR.
        IF AVAILABLE ip_wo AND VALID-HANDLE (ip_wo.hdl) THEN DO:
          RUN continue-processing IN web-utilities-hdl (p_FileName, unique-id). 
          RETURN.
        END. /* IF AVAILABLE */  
        ELSE DO:
          /* Kill the cookie used by this Agent to and return an error
             because there is no custom timeout handler. */
          delete-cookie(p_FileName, ?, ?).
          RUN HtmlError ('The Web object to which you were attached has timed-out. Please start again.'). 
          RETURN.
        END. /* ELSE DO */
      END. /* WHEN 1 */
  
      WHEN 2 THEN DO:
        ASSIGN 
          unique-id = INTEGER(ENTRY(1, wo-cookie))
          timeout-handler = ENTRY(2, wo-cookie).
        FIND FIRST ip_wo WHERE ip_wo.id eq unique-id NO-ERROR.
        /* If the object exists, use it...
           ...even if it has Web-State=Timed-out */
        IF AVAILABLE (ip_wo) AND VALID-HANDLE (ip_wo.hdl) THEN DO:
          RUN continue-processing IN web-utilities-hdl (p_FileName, unique-id).
          RETURN.
        END. /* IF VALID-HANDLE */
        ELSE DO:
          /* Agent has timed out, run the timeout handler instead. Delete
             the old cookie. */
          delete-cookie(p_FileName, ?, ?).
          p_FileName = timeout-handler.   
        END.
      END. /* WHEN 2*/
    END. /* CASE wo-cookie-values */
  END. /* IF wseu-cookie ne "":U... */
  
  /* If you get here, then the Web object is being run for the first
   * time, or a timeout handler Web object/procedure is being run.
   * Before running the file, verify that is has the correct extension,
   * and it can be found in the PROPATH.
   * Once the run is complete, run check-web-state so that a 'State-less'
   * Web object can have its procedure handle deleted, or to verify
   * if a State-Aware Web object has timed out. 
  */

  /* Verify file extension is valid, i.e. .w, .r, .p, or .  */
  RUN adecomm/_osfext.p (INPUT p_FileName, OUTPUT rFileExt).
  IF NOT CAN-DO(".w,.p,.r,.":U,rFileExt) AND rFileExt <> "" THEN 
    /* Does compiled code exists. Look for a .r extension. */ 
    rSearchFile = SEARCH(SUBSTRING(p_FileName, 1, R-INDEX(p_FileName, ".":U),
                                  "CHARACTER":U) + "r":U).
    IF rSearchFile eq ?  THEN 
      RUN HtmlError (SUBSTITUTE ("'&1' cannot be run as a Web object.", p_FileName )).
  ELSE DO:
    /* Now actually look for the 4GL file (or its rcode). */
    RUN adecomm/_rsearch.p (INPUT p_FileName, OUTPUT rSearchFile).
    IF rSearchFile = ? THEN
      RUN HtmlError (SUBSTITUTE ("Unable to find Web object file '&1'", 
                                 p_FileName )).  
  END.
  IF rSearchFile ne ? THEN DO:                              
    /* Program exists ... run it. Catch all possible Progress run-time
     * "break" conditions.  We do not report any of these errors.
     * [NOTE: this is similar to the ExecuteRun logic in adeedit/psystem.i].
    */ 
    Execute-Block:   
    DO ON ERROR  UNDO Execute-Block, LEAVE Execute-Block  
       ON ENDKEY UNDO Execute-Block, LEAVE Execute-Block
       ON STOP   UNDO Execute-Block, LEAVE Execute-Block
       ON QUIT                     , LEAVE Execute-Block:  

      /* Run the file and note any run errors. */
      RUN VALUE(p_FileName) PERSISTENT SET this-wo-hdl NO-ERROR. 
      IF ERROR-STATUS:ERROR THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-error-status':U) NO-ERROR.
        RUN HtmlError (SUBSTITUTE ("Unable to run Web object '&1'", 
                                    p_FileName )).
      END. /* IF...ERROR... */
    END. /* Execute-Block: DO... */
    
    /* Check the web-state (and delete objects that aren't state-aware). */
    IF VALID-HANDLE(this-wo-hdl) THEN 
      RUN check-web-state (this-wo-hdl).
    
  END. /* IF rSearchFile ne ? THEN DO: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-server-connection Web-Utilities-Object 
PROCEDURE set-server-connection :
/*------------------------------------------------------------------------------
  Purpose:     Used to reset server-connection variable or destroy the 
               SERVER_CONNECTION_ID cookie
  Parameters:  p_wo-hdl        - TARGET-PROCEDURE handle
               p_connection-id - SESSION:SERVER-CONNECTION-ID value or blank
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_connection-id   AS CHARACTER NO-UNDO.

  server-connection = p_connection-id.

  IF useConnID = "0":U THEN DO:
    /* Delete the SERVER_CONNECTION_ID cookie */
    IF INDEX(HTTP_COOKIE,"SERVER_CONNECTION_ID=":U) > 0 THEN
      delete-cookie({&CONNECTION-NAME}, ?, ?).
    
    /* Let core know the logical session has ended */
    WEB-CONTEXT:SESSION-END = TRUE.
  END.
  ELSE IF p_connection-id <> "" THEN DO:
    /* Create the SERVER_CONNECTION_ID cookie used to maintain context across 
       browser sessions. */
    set-cookie({&CONNECTION-NAME}, p_connection-id, ?, ?, ?, ?, ?).
    
    /* Let core know the logical session is active */
    WEB-CONTEXT:SESSION-END = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-transaction-state Web-Utilities-Object 
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
      IF transaction-state eq "NONE":U 
      THEN transaction-state = "START-PENDING":U.
      ELSE RUN HtmlError (SUBSTITUTE (
               'Transaction cannot be STARTED while the transaction state is &1.',
                transaction-state)).
    END. /* WHEN "START"... */
    
    WHEN "UNDO-PENDING":U OR WHEN "RETRY-PENDING":U OR WHEN "COMMIT-PENDING":U 
    THEN DO:        
      IF transaction-state eq "ACTIVE":U
      THEN transaction-state = new-state.
      ELSE RUN HtmlError (SUBSTITUTE (
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-web-state Web-Utilities-Object 
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

  DEFINE VARIABLE timeout-handler   AS CHARACTER NO-UNDO.
 
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
    /* Re: 97-02-06-006.  Although, v1.0 allowed timeout to be entered as a
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
    
    /* Get the Web-Timeout-Handler if it has been defined so that it */
    /* can be appended to the end of the unique-id */
    timeout-handler = fetch-attr(p_wo-hdl, 'Web-Timeout-Handler':U).

    /* Create the cookie used by the Broker to identify this Agent. */
    set-wseu-cookie(ENTRY(2,WEB-CONTEXT:EXCLUSIVE-ID,"=":U)).

    /* Create the cookie used by this Agent to identify the Web object. */
    /* Append timeout-handler to the end of the UNIQUE-ID if it exists */
    IF (timeout-handler <> "" AND timeout-handler <> ?) THEN
      set-cookie(p_wo-hdl:FILE-NAME /* "WSObjectId":U */,
                     (STRING(p_wo-hdl:UNIQUE-ID) + ',':U + timeout-handler), 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION check-agent-mode Web-Utilities-Object 
FUNCTION check-agent-mode RETURNS LOGICAL
  (INPUT p_mode AS CHARACTER):
  /*---------------------------------------------------------------------------
    Purpose:     Return TRUE if the specified Agent Mode (Environment) option
                 is set.
    Parameters:  p_mode:  Agent Mode to check.
    Notes:       This does not do a simple compare for equality because the
                 actual configuration value may contain other (unsupported)
                 options.
    Example:     IF check-agent-mode("Production") THEN ...
    ---------------------------------------------------------------------------*/
  RETURN CAN-DO(cfg-environment, p_mode).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-config Web-Utilities-Object 
FUNCTION get-config RETURNS CHARACTER
  (INPUT p_name AS CHARACTER):
  /*---------------------------------------------------------------------------
    Purpose:     Return value of the specified configuration option
    Parameters:  p_name:  name of configuration option
    Notes:
    ---------------------------------------------------------------------------*/
  RETURN WEB-CONTEXT:GET-CONFIG-VALUE(p_name).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

