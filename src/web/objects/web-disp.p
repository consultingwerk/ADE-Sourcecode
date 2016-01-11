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

File: web-disp.p

Description:                Main PROGRESS entry dispatch procedure  

Input Parameters:   <none>

Output Parameters:  <none>

Author: D.Adams, B.Burton, L.Laferriere, Wm.T.Wood

Created: May 1996

---------------------------------------------------------------------------*/

{ src/web/method/cgidefs.i NEW }      /* Basic CGI variables */
{ src/web/method/cgiarray.i NEW }     /* Extended CGI array variables */
{ src/web/method/tagmap.i NEW }       /* HTML/PSC type mapping */

/* Dummy variable for logical assign. */
DEFINE VARIABLE l_dummy AS LOGICAL NO-UNDO.

/* Also defined in web/objects/web-util.p and adeuib/_semain.w.  This needs to
   be centralized. */
DEFINE NEW SHARED VARIABLE server-connection AS CHARACTER NO-UNDO.
DEFINE NEW SHARED VARIABLE transaction-state AS CHARACTER NO-UNDO.

&Scoped-define MANUAL-WSEU-INCREMENT l_dummy = WEB-CONTEXT:INCREMENT-EXCLUSIVE-ID (1).
&Scoped-define WEB-NOTIFY WEB-NOTIFY
&Scoped-define EXCLUSIVE-WEB-USER EXCLUSIVE-WEB-USER

DEFINE VARIABLE cfg-eval-mode       AS LOGICAL NO-UNDO.
DEFINE VARIABLE ix                  AS INTEGER NO-UNDO.
DEFINE VARIABLE pause-period        AS INTEGER NO-UNDO.

/* Trigger for handling all web requests */   
ON "{&WEB-NOTIFY}":U ANYWHERE DO:
  DEFINE VARIABLE c-value AS CHARACTER NO-UNDO.

  OUTPUT {&WEBSTREAM} TO "WEB":U.
 
  /* Parse the request from the web server. */
  RUN init-request IN web-utilities-hdl.

  /* Check for specific requests: 
       PING               - respond that web-disp.p is running
       DEBUG              - call up debugging administration form
       RESET              - reset the web-utilities.
       WEB-UTILITY:<name> - Run <name> in the utilities procedure. */
  IF AppProgram EQ "PING":U THEN DO:
    output-http-header("Content-Type":U, "text/html":U).
    output-http-header("","").
    {&OUT}
      '<HTML>':U SKIP
      '<HEAD><TITLE>':U "WebSpeed Agent successfully accessed"
        '</TITLE></HEAD>':U SKIP
      '<BODY BGCOLOR="#FFFFCC" TEXT="#000000">':U SKIP
      '<H1>':U "WebSpeed Agent successfully accessed" '</H1>':U SKIP
    {&END}
    IF debugging-enabled THEN DO:
      ASSIGN FILE-INFO:FILE-NAME = ".":U.  /* current directory */
      {&OUT}
        '<DL>':U SKIP
        '  <DT><B>':U "Default Directory:" '</B>':U SKIP
        '    <DD><FONT SIZE="-1">':U FILE-INFO:FULL-PATHNAME 
        '</FONT><BR><BR>':U SKIP
        '  <DT><B>':U "Web Object Path (PROPATH):" '</B>':U SKIP
        '    <DD><FONT SIZE="-1">':U REPLACE(PROPATH, ",":U, "<BR>~n":U) 
        '</FONT><BR><BR>':U SKIP
        '  <DT><B>':U "Connected Databases:" '</B>':U SKIP.

      DO ix = 1 TO NUM-DBS:
        {&OUT}
          '    <DD><FONT SIZE="-1">':U LDBNAME(ix) ' (':U DBTYPE(ix)
          ')</FONT>':U SKIP.
      END.        
      {&OUT} '</DL>':U SKIP.
    END.
    {&OUT} '</BODY></HTML>':U SKIP.
  END.

  /* If debugging is enabled (probably Environment = Development mode) */
  ELSE IF AppProgram EQ "DEBUG":U AND debugging-enabled THEN 
    RUN web/support/printval.p ("admin":U).

  /* Reset all web utilities including web-util.p */
  ELSE IF AppProgram EQ "RESET":U AND debugging-enabled THEN DO:
    RUN reset-utilities.
    output-http-header("Content-Type":U, "text/plain":U).
    output-http-header("","").
    {&OUT}
      "Reset " (IF VALID-HANDLE(web-utilities-hdl)
        THEN "succeeded" ELSE "failed") " for this Agent." SKIP
    {&END}
  END.

  ELSE IF AppProgram BEGINS "WEB-UTILITY:":U AND debugging-enabled THEN DO:
    RUN dispatch IN web-utilities-hdl (ENTRY (2, AppProgram, ":":U)) NO-ERROR.
    output-http-header("Content-Type":U, "text/plain":U).
    output-http-header("","").
    {&OUT}
      AppProgram (IF ERROR-STATUS:ERROR THEN " failed" ELSE " succeeded")
      " on this Agent." SKIP
    {&END}
  END.

  /* Try to run whatever was specified in the URL */
  ELSE DO:
    /* If debugging is disabled, don't allow running any files starting
       with the path "src/web/". */
    IF NOT debugging-enabled AND AppProgram BEGINS "src/web/":U THEN
      RUN HtmlError IN web-utilities-hdl
          (SUBSTITUTE ("Unable to run Web object '&1'", AppProgram )).
    ELSE
      /* Try to run the Web object application program. */
      RUN run-web-object IN web-utilities-hdl (AppProgram).
  
    /* If any debugging options are set except "top" ... */
    IF debugging-enabled AND debug-options <> "" AND
        LOOKUP("top":U,debug-options) = 0 THEN
      RUN web/support/printval.p (debug-options).
  END.

  /* Output any pending messages queued up by queue-message() */
  IF available-messages(?) THEN
    output-messages("all", ?, "Messages:").

  OUTPUT {&WEBSTREAM} CLOSE.

END. /* ON "{&WEB-NOTIFY}"... */

/* Initialize the utilities. */
RUN reset-utilities.  

/* Initialize any session-specific information */
RUN init-session IN web-utilities-hdl.

/* Turn on manual WSEU incrementing. */
{&MANUAL-WSEU-INCREMENT}

/* Determine if Evaluation mode or not. */
ASSIGN cfg-eval-mode = check-agent-mode("EVALUATION":U).

WAIT-FOR-BLOCK:
REPEAT ON ERROR UNDO WAIT-FOR-BLOCK, LEAVE WAIT-FOR-BLOCK 
       ON QUIT  UNDO WAIT-FOR-BLOCK, LEAVE WAIT-FOR-BLOCK
       ON STOP  UNDO WAIT-FOR-BLOCK, NEXT WAIT-FOR-BLOCK:  /* Why is NEXT here? (wood)  */
  
  /* Usually return to the "None" state, except in a RETRY which is
     treated like a start. */
  IF transaction-state eq "RETRY-PENDING":U THEN
    transaction-state = "START-PENDING":U.
  ELSE 
    transaction-state = "NONE":U .
       
  RUN check-exclusive-pause IN web-utilities-hdl (OUTPUT pause-period).
  /* OUTPUT {&WEBSTREAM} TO "WEB":U UNBUFFERED.
   * {&OUT} "pause-period = " pause-period. */
  IF transaction-state eq "NONE" THEN DO:
    /* If in evaluation mode, don't lock the Agent */
    IF cfg-eval-mode THEN
      WAIT-FOR "{&WEB-NOTIFY}":U OF DEFAULT-WINDOW.
    ELSE IF pause-period > 0 THEN 
      WAIT-FOR "{&WEB-NOTIFY}":U OF DEFAULT-WINDOW
               PAUSE pause-period {&EXCLUSIVE-WEB-USER}.
    ELSE DO:
      /* Increment the exclusive user id manually every time we are in a
         non-locking state. */
      {&MANUAL-WSEU-INCREMENT}
      WAIT-FOR "{&WEB-NOTIFY}":U OF DEFAULT-WINDOW. 
    END. /* IF pause-period [eq] 0... */
  END. /* IF transaction-state eq "NONE"... */
  /* Check to see if the user wants to start a transaction. */
  IF transaction-state eq "START-PENDING":U THEN DO:
    Transaction-Block: 
    DO TRANSACTION:
      REPEAT ON ERROR UNDO Transaction-Block, LEAVE Transaction-Block
             ON QUIT  UNDO Transaction-Block, LEAVE Transaction-Block
             ON STOP  UNDO Transaction-Block, LEAVE Transaction-Block:
        CASE transaction-state:
          WHEN "UNDO-PENDING":U    THEN UNDO  Transaction-Block.
          WHEN "RETRY-PENDING":U   THEN UNDO  Transaction-Block.
          WHEN "COMMIT-PENDING":U  THEN LEAVE Transaction-Block.
          WHEN "START-PENDING":U OR 
          WHEN "ACTIVE":U THEN DO:
            RUN check-exclusive-pause IN web-utilities-hdl (OUTPUT pause-period).  
            /* If all state-aware objects have timed out, then leave the
               block.  NOTE the user should have set Transaction-State =
               "COMMIT" if they had wanted to commit the changes. */          
            IF pause-period eq 0 THEN
              UNDO Transaction-Block.
            ELSE DO:
              /* Continue everything that we have started. */
              transaction-state = "ACTIVE". 
              /* If in evaluation mode, don't lock the Agent */
              IF cfg-eval-mode THEN
                WAIT-FOR "{&WEB-NOTIFY}":U OF DEFAULT-WINDOW.
              ELSE
                WAIT-FOR "{&WEB-NOTIFY}":U OF DEFAULT-WINDOW
                         PAUSE pause-period {&EXCLUSIVE-WEB-USER}.     
            END. /* IF pause-period ne 0... */
          END. /* WHEN "Start-Pending" OR..."Active"... */
        END CASE.
      END. /* REPEAT... */ 
    END. /* Transaction-Block: DO TRANSACTION... */
  END. /* IF...<transaction>... */ 
END. /* WAIT-FOR-BLOCK: REPEAT... */

  
/* -------------------------------------------------------------------
   Procedure: reset-utilities
   Purpose:   Restarts the web-utilities-hdl, and initializes is.
 --------------------------------------------------------------------*/   
PROCEDURE reset-utilities :      
  /* Clean up the existing utilities procedure. */
  IF VALID-HANDLE(web-utilities-hdl) THEN DO: 
    RUN dispatch IN web-utilities-hdl ('destroy') NO-ERROR.
    /* Make sure it worked. */
    IF VALID-HANDLE(web-utilities-hdl) 
    THEN DELETE PROCEDURE web-utilities-hdl.
  END.
  /* Create the utilities handle as a persistent procedure. */
  RUN web/objects/web-util.p PERSISTENT SET web-utilities-hdl.

  /* If this didn't work, there are big problems. */
  IF NOT VALID-HANDLE(web-utilities-hdl) THEN QUIT.

  /* Initialize the tagmap file. */
  RUN dispatch IN web-utilities-hdl ('reset-tagmap-utilities':U).
END PROCEDURE.
             
/* web-disp.p - end of file */
