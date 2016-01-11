/*********************************************************************
* Copyright (C) 2005-2009 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
/* Actional support */
DEFINE VARIABLE actionalEnabled    AS LOGICAL    INIT ? NO-UNDO.
DEFINE VARIABLE actionalUrl        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE actionalGroup      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE actionalService    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE actionalSI         AS CLASS      actional.ServerInteraction.
DEFINE VARIABLE tmpChr1            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tmpChr             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tmpInt             AS INTEGER    NO-UNDO.

/* Set the web-request trigger. */
ON "WEB-NOTIFY":U ANYWHERE DO:
  OUTPUT {&WEBSTREAM} TO "WEB":U.

  /* Parse the request/CGI from the web server. */
  RUN init-cgi     IN web-utilities-hdl.
  /* Initialize for web-request. */
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

  AppProgram = (IF AppProgram = "debug":U THEN "webutil/debug.p":U ELSE
               (IF AppProgram = "ping":U  THEN "webutil/ping.p":U  ELSE
               (IF AppProgram = "reset":U THEN "webutil/reset.p":U ELSE
                AppProgram))).

  /* Actional support */
  DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "actionalEnabled is " + STRING(actionalEnabled)).  
  IF actionalEnabled = ? THEN DO:
    IF LOOKUP("-ACTIONALENABLED", SESSION:STARTUP-PARAMETERS) <> 0 THEN
      actionalEnabled = TRUE.
    ELSE
      actionalEnabled = FALSE.

    /* setup Actional information */
    IF actionalEnabled THEN DO:
    DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "Initializing Actional").  
      /* setup defaults */
      actionalGroup = "OpenEdge".
      actionalService = "wsbroker".

      /* setup group and service name from command-line switch */
      tmpInt = INDEX(SESSION:STARTUP-PARAMETERS,"-ACTIONALGROUP").
      IF tmpInt <> 0 THEN DO:

        /* switch was specified, get the parameter */
        tmpChr = SUBSTRING(SESSION:STARTUP-PARAMETERS, tmpInt).
        tmpChr = ENTRY(1, tmpChr).
        tmpChr = TRIM(SUBSTRING(tmpChr, LENGTH("-ACTIONALGROUP "))).

        /* parameter is  <group name>:<service name> */
        IF INDEX(tmpChr, ":") <> 0 THEN DO:

          /* get the group name */
          tmpChr1 = ENTRY(1, tmpChr, ":").
          IF LENGTH(tmpChr1) <> 0 THEN
            actionalGroup = tmpChr1.

          /* get the service name */
          tmpChr1 = ENTRY(2, tmpChr, ":").
          IF LENGTH(tmpChr1) <> 0 THEN
            actionalService = tmpChr1.
        END.
        ELSE DO:
          /* no separator was specified, */
          /* parameter is the group name */
          actionalGroup = tmpChr.
        END.
      END.
      actionalUrl = "OpenEdge://" + SERVER_NAME + "/WebSpeed/" + actionalService.
      DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "Actional URL: " + actionalUrl).  
      DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "Actional Group: " + actionalGroup).  
      DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "Actional Service: " + actionalService).  
    END.
  END.
    
  IF actionalEnabled THEN DO:
    DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "Creating new ServerInteraction").  
    actionalSI = NEW actional.ServerInteraction().
    actionalSI:Begin().
    actionalSI:SetUrl(actionalUrl).
    actionalSI:SetPeerAddr(REMOTE_HOST).
    actionalSI:SetGroupName(actionalGroup).
    actionalSI:SetAppType(actional.ServerInteraction:ACT_DT_OEGROUP).
    actionalSI:SetServiceName(actionalService).
    actionalSI:SetSvcType(actional.ServerInteraction:ACT_DT_WEBSPEED).
    actionalSI:SetOpName(AppProgram).
    actionalSI:RequestAnalyzed().
  END.

  RUN run-web-object IN web-utilities-hdl (AppProgram) NO-ERROR. 
  
  /* Done with Actional */
  IF actionalEnabled THEN DO:
    DYNAMIC-FUNCTION("logNote":U IN web-utilities-hdl, "ACTIONAL", "ServerInteraction completed for operation " + AppProgram).  
    actionalSI:End().
    actionalSI:freeSInteraction().
    actionalSI = ?.
  END.

  /* Run clean up and maintenance code */
  RUN end-request IN web-utilities-hdl NO-ERROR.
  
  /* If any debugging options are set except "top" ... */
  IF debugging-enabled AND debug-options <> "" AND LOOKUP("top":U,debug-options) = 0 AND 
      /* don't do it for these procedures */
      LOOKUP(AppProgram,"webutil/debug.p,webutil/reset.p,webutil/ping.p") = 0 THEN
     RUN web/support/printval.p (debug-options).

  /* Output any pending messages queued up by queue-message() */
  IF available-messages(?) THEN
    output-messages("all", ?, "Messages:").

  /* Output an HTML "... generated by ..." comment at the end of every
     output page but only if HTML is being output. The comment was originally at then beginning of 
     the page but unfortunately IE has a problem with the DOCTYPE not being the first tag
     in standards mode such as XHTML.
  */
  IF CAN-DO ("text/html*,text/x-server-parsed-html*",output-content-type) THEN
    {&OUT} 
      "~n~n<!-- Generated by Webspeed: http://www.webspeed.com/ -->~n":U.

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
    /* Usually return to the "None" state, except in a RETRY which is
       treated like a start. */
    transaction-state = IF transaction-state EQ "RETRY-PENDING":U THEN
                          "START-PENDING":U ELSE "NONE":U .
       
    RUN check-exclusive-pause IN web-utilities-hdl (OUTPUT dPausePeriod).
    
    IF transaction-state EQ "NONE" THEN DO:    
      IF dPausePeriod > 0 AND NOT cfg-eval-mode THEN 
        WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW
          PAUSE dPausePeriod EXCLUSIVE-WEB-USER.
      ELSE DO:
        /* Increment the EXCLUSIVE-ID manually every time we are in a
           non-locking state. */
        {&MANUAL-WSEU-INCREMENT}
        WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW. 
      END.
    END. /* IF transaction-state EQ "NONE"... */
    
    /* Check to see if the user wants to start a transaction. */
    IF transaction-state EQ "START-PENDING":U THEN DO:
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
              RUN check-exclusive-pause IN web-utilities-hdl (OUTPUT dPausePeriod).  
              /* If all state-aware objects have timed out, then leave the
                 block.  NOTE the user should have set Transaction-State =
                 "COMMIT" if they had wanted to commit the changes. */          
              IF dPausePeriod EQ 0 THEN
                UNDO Transaction-Block.
              ELSE DO:
                /* Continue everything that we have started. */
                transaction-state = "ACTIVE":U. 
                /* If in evaluation mode, don't lock the Agent */
                IF cfg-eval-mode THEN
                  WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW.
                ELSE
                  WAIT-FOR "WEB-NOTIFY":U OF DEFAULT-WINDOW
                     PAUSE dPausePeriod {&EXCLUSIVE-WEB-USER}.     
              END. /* IF dPausePeriod ne 0... */
            END. /* WHEN "Start-Pending" OR..."Active"... */
          END CASE.
        END. /* REPEAT... */ 
      END. /* Transaction-Block: DO TRANSACTION... */
    END. /* IF...<transaction>... */ 
  END. /* lStateAware */
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
