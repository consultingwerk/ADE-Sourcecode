/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
* Contributors:  Per Digre/PSC, Chad Thompson/Bravepoint             *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: web/objects/web-disp.p

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
{ src/web/method/cgidefs.i  NEW } /* standard WS cgidefs.i: functions,vars */
{ src/web/method/cgiarray.i NEW } /* standard WS cgiarray.i: vars          */ 
{ src/web/method/tagmap.i   NEW } /* standard WS tagmap.i: TT tagmap       */
{ src/web/method/webutils.i NEW }

/* Dummy variable for logical assign. */
DEFINE VARIABLE lDummy AS LOGICAL NO-UNDO.

&SCOPED-DEFINE EXCLUSIVE-WEB-USER EXCLUSIVE-WEB-USER
&SCOPED-DEFINE MANUAL-WSEU-INCREMENT lDummy = WEB-CONTEXT:INCREMENT-EXCLUSIVE-ID (1).

/* Also defined in web/objects/web-util.p and adeuib/_semain.w.  This needs to
   be centralized. */
DEFINE NEW SHARED VARIABLE server-connection AS CHARACTER NO-UNDO.
DEFINE NEW SHARED VARIABLE transaction-state AS CHARACTER NO-UNDO.

DEFINE VARIABLE cfg-eval-mode      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMimeCharset       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProCharset        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cStateAware        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dPausePeriod       AS DECIMAL    NO-UNDO.  
DEFINE VARIABLE hWebStart          AS HANDLE     NO-UNDO.
DEFINE VARIABLE iBatchInterval     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTest              AS INTEGER    NO-UNDO.
DEFINE VARIABLE ix                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE lStateAware        AS LOGICAL    NO-UNDO.

/* Set the web-request trigger. */
ON "WEB-NOTIFY":U ANYWHERE DO:
  OUTPUT {&WEBSTREAM} TO "WEB":U.

  /* Parse the request from the web server. */
  RUN init-request IN web-utilities-hdl.

  &IF KEYWORD-ALL("HTML-CHARSET") <> ? &THEN  
  ASSIGN
    cMimeCharset = get-value("wscharset":U)
    cProCharset  = ""
    iTest        = 0.
    
  IF cMimeCharset <> ? AND cMimeCharset <> "" THEN DO:
    /* Confirm receipt of valid MIME character set */
    RUN adecomm/convcp.p (cMimeCharset, "toProg":U, OUTPUT cProCharset) NO-ERROR.
    IF cProCharset = "" THEN
      MESSAGE SUBSTITUTE("The &1 character set has no Progress equivalent.",
                         cMimeCharset).
    ELSE DO:
      ASSIGN iTest = ASC("A":U, SESSION:CPINTERNAL, cProCharset) NO-ERROR.
      IF iTest > 0 THEN
        WEB-CONTEXT:HTML-CHARSET = cProCharset.
    END.

    IF iTest >= 0 AND WEB-CONTEXT:HTML-CHARSET <> "" 
      AND WEB-CONTEXT:HTML-CHARSET <> SESSION:CPSTREAM THEN
      OUTPUT {&WEBSTREAM} TO "WEB":U CONVERT TARGET WEB-CONTEXT:HTML-CHARSET.
  END.
  &ENDIF
  
  /* Run the web object */
  RUN run-web-object IN web-utilities-hdl (AppProgram) NO-ERROR.

  /* Run clean up and maintenance code */
  RUN end-request IN web-utilities-hdl NO-ERROR.
  
  /* Output any pending messages queued up by queue-message() */
  IF available-messages(?) THEN
    output-messages("all", ?, "Messages:").
    
  OUTPUT {&WEBSTREAM} CLOSE.
END. /* ON "WEB-NOTIFY" */

/* Load standard and user-defined super procedures.  web/objects/web-util.p and 
   init-session runs within.  This program is set as web-utilities-hdl. */
RUN webutil/webstart.p PERSISTENT SET hWebStart.

/* Initialize the tagmap file. */
RUN reset-tagmap-utilities IN web-utilities-hdl.

ASSIGN
  iBatchInterval = INTEGER(DYNAMIC-FUNCTION("getAgentSetting":U IN web-utilities-hdl,
                                            "Misc":U, "", "BatchInterval":U)) 
  cStateAware    = DYNAMIC-FUNCTION("getAgentSetting":U IN web-utilities-hdl,
                                    "Session":U, "", "StateAware":U)
  lStateAware    = (cStateAware = "yes":U)
  cfg-eval-mode  = check-agent-mode("EVALUATION":U)
  NO-ERROR.
  
/* Turn on manual WSEU incrementing if state-aware support is active. */
IF lStateAware THEN
  {&MANUAL-WSEU-INCREMENT}

/* Wait for a web-request to come in */
WAIT-FOR-BLOCK: 
REPEAT ON ERROR UNDO WAIT-FOR-BLOCK, LEAVE WAIT-FOR-BLOCK 
       ON QUIT  UNDO WAIT-FOR-BLOCK, LEAVE WAIT-FOR-BLOCK
       ON STOP  UNDO WAIT-FOR-BLOCK, NEXT  WAIT-FOR-BLOCK: 
  IF lStateAware THEN DO:
    RUN check-exclusive-pause IN web-utilities-hdl (OUTPUT dPausePeriod).
    IF dPausePeriod > 0 AND NOT cfg-eval-mode THEN 
      WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW
        PAUSE dPausePeriod EXCLUSIVE-WEB-USER.
    ELSE DO:
      {&MANUAL-WSEU-INCREMENT}
      WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW. 
    END.
  END.
  ELSE DO:
    IF iBatchInterval > 14 THEN DO:
      WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW PAUSE iBatchInterval.
      /* If there is a batch program that needs to be run, then run it now. */
      RUN init-batch       IN web-utilities-hdl NO-ERROR. 
      RUN run-batch-object IN web-utilities-hdl NO-ERROR. 
      RUN end-batch        IN web-utilities-hdl NO-ERROR. 
    END.
    ELSE 
      WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW. 
  END.
END. /* WAIT-FOR-BLOCK: REPEAT... */

APPLY "close":U TO hWebStart.

/* web-disp.p - end of file */
