&IF DEFINED(DCUERROR)
&THEN
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN DO:
      ASSIGN 
        cDcuMessage = IF RETURN-VALUE <> ? THEN RETURN-VALUE ELSE "":U.
      DO iDcuLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        ASSIGN
          cDcuMessage = cDcuMessage + (IF cDcuMessage = "":U THEN "":U ELSE CHR(10)) +
                     ERROR-STATUS:GET-MESSAGE(iDcuLoop).
      END.
    
      /* get rid of error status */
      ASSIGN 
        cDcuMessage = cDcuMessage NO-ERROR.
    
      IF "{&LOGFILE}" = "YES" THEN
        PUT STREAM sLogFile UNFORMATTED
          "   ERROR: " + cDcuMessage SKIP.

      MESSAGE 
          cDcuMessage
          VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Install Error".

      IF "{&LOGFILE}" = "YES" THEN
        OUTPUT STREAM sLogFile CLOSE.
      RETURN ERROR cDcuMessage.
    END.
&ELSE
    &GLOBAL-DEFINE DCUERROR YES
    DEFINE VARIABLE cDcuMessage AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDcuLoop    AS INTEGER    NO-UNDO.
&ENDIF

