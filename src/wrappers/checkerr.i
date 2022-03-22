/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* af/sup2/afcheckerr.i - to check for errors and handle them.
   This include file takes the following arguments:
   {&display-error}     YES = Display the error if not in a transaction
   {&return-only}       YES = Do not pass on the error but do a return
   {&return-error}      YES = Pass on error - defaults to this if in a transaction
   {&no-return}         YES = Do not return when finished - let programmer decide what to do
   {&errors-not-zero}   YES = Build messages even if ERROR-STATUS:ERROR = NO
   {&ignore-errorlist}  YES = do not use get-message errors at all (use with care)
   {&define-only}       YES = define the variables you need but take no other action

   If they are displaying an error message, then these arguements are also available:
   {&message-type}      Type of message, e.g. 'MES','INF','WAR','ERR','HAL','QUE', default = 'ERR'
   {&message-buttons}   Comma list of buttons, default is 'OK'
   {&button-default}    Default button, default is 'OK'
   {&button-cancel}     Cancel button, default is 'OK'
   {&message-title}     Title, default is ''
   {&display-empty}     YES = display message dialog even if empty, default = YES

   And if message type is QUE for Question then these arguments are also available:
   {&message-datatype}  Datatype, default is 'Character'
   {&message-format}    Format of question, default = 'CHR(35)'
   {&default-answer}    Default answer, default is empty
   Also, for questions, the other defaults change to message-buttons = 'OK,CANCEL', and
   button-default = 'OK', and button-cancel = 'CANCEL'.

   RULES:
   1. Required logical arguments must be passed in unquoted as YES or NO. Other text
      arguments must be single quoted literals, e.g. 'text' or unquoted variables, 
      and if the literals require spaces, they should be double quoted then single
      quoted, e.g. "'text'".
   2. All arguments may be left blank - in which cased the error will not be displayed and will be passed on with a return error.
   3. If everything is left blank except display-error = YES, then the error will be
      displayed using the Astra dialog and a standard return statement done.
   4. If in a transaction, the error will be passed on regardless, unless they say no-return = YES.
   5. If they display the error, the default is to do a return only as already displayed error.
   6. If they do not display the error, the default is to do a return error to pass errr on.
   7. If return-only is set to YES, this will override any other return settings.

   Following the include file if they said not to return, then the following variable
   values will be available for the programmer:
   cMessageList           CHR(3) delimited list of error messages
   cMessageButton         Button Pressed if message displayed
   cMessageAnswer         Answer if question dialog used

*/
/* set up defaults if arguements not passed in */
&IF DEFINED(ignore-errorlist) = 0 &THEN
  &SCOPED-DEFINE ignore-errorlist FALSE   /* Default to use get-message list of no return-value */
&ENDIF
&IF DEFINED(display-error) = 0 &THEN
  &SCOPED-DEFINE display-error FALSE      /* Default to not display an error */
&ENDIF
&IF DEFINED(no-return) = 0 &THEN
  &SCOPED-DEFINE no-return FALSE          /* Default to actually do a return */
&ENDIF
&IF DEFINED(errors-not-zero) = 0  &THEN
  &SCOPED-DEFINE errors-not-zero FALSE       /* Default to not return error if displaying errors */
&ENDIF
&IF DEFINED(return-error) = 0 AND {&display-error} &THEN
  &SCOPED-DEFINE return-error FALSE       /* Default to not return error if displaying errors */
&ENDIF
&IF DEFINED(return-error) = 0 AND NOT {&display-error} &THEN
  &SCOPED-DEFINE return-error TRUE        /* Default to return error if not displaying errors */
&ENDIF
&IF DEFINED(return-only) = 0 AND {&display-error} &THEN
  &SCOPED-DEFINE return-only TRUE         /* Default to return only when display errors */
&ENDIF
&IF DEFINED(return-only) = 0 AND NOT {&display-error} &THEN
  &SCOPED-DEFINE return-only FALSE        /* Default to not return only when not displaying errors */
&ENDIF
&IF DEFINED(message-type) = 0 &THEN
  &SCOPED-DEFINE message-type 'ERR'       /* Default to message type of Error */
&ENDIF
&IF DEFINED(message-buttons) = 0 AND {&message-type} = "QUE" &THEN
  &SCOPED-DEFINE message-buttons 'OK,CANCEL' /* Default buttons to 'OK,CANCEL' for questions */
&ENDIF
&IF DEFINED(message-buttons) = 0 AND {&message-type} <> "QUE" &THEN
  &SCOPED-DEFINE message-buttons 'OK'     /* Default buttons to 'OK' for normal show messages */
&ENDIF
&IF DEFINED(button-default) = 0 AND {&message-type} = "QUE" &THEN
  &SCOPED-DEFINE button-default 'OK'      /* Default button is 'OK' for questions */
&ENDIF
&IF DEFINED(button-default) = 0 AND {&message-type} <> "QUE" &THEN
  &SCOPED-DEFINE button-default 'OK'     /* Default buttons is 'OK' for normal show messages */
&ENDIF
&IF DEFINED(button-cancel) = 0 AND {&message-type} = "QUE" &THEN
  &SCOPED-DEFINE button-cancel 'CANCEL'      /* Cancel button is 'CANCEL' for questions */
&ENDIF
&IF DEFINED(button-cancel) = 0 AND {&message-type} <> "QUE" &THEN
  &SCOPED-DEFINE button-cancel 'OK'     /* Cancel buttons is 'OK' for normal show messages */
&ENDIF
&IF DEFINED(display-empty) = 0 &THEN
  &SCOPED-DEFINE display-empty TRUE      /* Default to display an empty dialog */
&ENDIF
&IF DEFINED(define-only) = 0 &THEN
  &SCOPED-DEFINE define-only FALSE      /* Default to not merely defining variables */
&ENDIF

&IF DEFINED(error-variables) = 0 &THEN
  DEFINE VARIABLE iErrorLoop          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessageList        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessageButton      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessageAnswer      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lMessageAnswer      AS LOGICAL    NO-UNDO.
  &GLOBAL-DEFINE error-variables
&ENDIF

&IF NOT {&define-only} 
&THEN
    ASSIGN
      cMessageList = "":U
      cMessageButton = "":U
       cMessageAnswer = "":U
      .
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" OR {&errors-not-zero} = YES THEN
    DO:
      ASSIGN cMessageList = IF RETURN-VALUE <> ? THEN RETURN-VALUE ELSE "":U.
      IF cMessageList = "":U AND NOT {&ignore-errorlist} THEN
      DO iErrorLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cMessageList = cMessageList + (IF cMessageList = "":U THEN "":U ELSE CHR(3)) +
                     ERROR-STATUS:GET-MESSAGE(iErrorLoop) + CHR(4) + CHR(4).
      END.

      /* get rid of error messages in get-message list */
      ASSIGN cMessageList = cMessageList NO-ERROR.

      /* display error if they said to do so and not in a transaction */
      IF NOT TRANSACTION AND {&display-error} THEN
      DO:
        &IF {&message-type} = "QUE" &THEN
          /* use AskQuestion */
          ASSIGN cMessageAnswer = &IF "{&default-answer}" <> "" &THEN {&default-answer} &ELSE "":U &ENDIF 
          .
          IF VALID-HANDLE(gshSessionManager) THEN
            RUN askQuestion IN gshSessionManager (
                  INPUT cMessageList,       
                  INPUT {&message-buttons}, 
                  INPUT {&button-default},  
                  INPUT {&button-cancel},  
                  INPUT &IF "{&message-title}" <> "" &THEN {&message-title} &ELSE "":U &ENDIF,           
                  INPUT &IF "{&message-datatype}" <> "" &THEN {&message-datatype} &ELSE "":U &ENDIF,
                  INPUT &IF "{&message-format}" <> "" &THEN {&message-format} &ELSE "":U &ENDIF,
                  INPUT-OUTPUT cMessageAnswer, /* answer */
                  OUTPUT cMessageButton 
                  ).
          ELSE
            IF cMessageList <> "":U THEN
              MESSAGE REPLACE(cMessageList,CHR(3),CHR(13))
                      VIEW-AS ALERT-BOX 
                        QUESTION BUTTONS YES-NO-CANCEL 
                        TITLE  &IF "{&message-title}" <> "" &THEN {&message-title} &ELSE "":U &ENDIF
                        UPDATE lMessageAnswer.

        &ELSE
          /* use ShowMessages */

          IF VALID-HANDLE(gshSessionManager) THEN
           RUN showMessages IN gshSessionManager (
                INPUT cMessageList,       
                INPUT {&message-type},    
                INPUT {&message-buttons}, 
                INPUT {&button-default},  
                INPUT {&button-cancel},  
                INPUT &IF "{&message-title}" <> "" &THEN {&message-title} &ELSE "":U &ENDIF,          
                INPUT {&display-empty},
                INPUT ?,
                OUTPUT cMessageButton
                ).
          ELSE
            IF cMessageList <> "":U THEN
              MESSAGE REPLACE(cMessageList,CHR(3),CHR(13))
                      VIEW-AS ALERT-BOX 
                        TITLE  &IF "{&message-title}" <> "" &THEN {&message-title} &ELSE "":U &ENDIF.
        &ENDIF
      END.


      &IF {&NO-RETURN} 
      &THEN
      &ELSE
        /* now deal with what they wanted us to do afterwards */  
        /* if in a transaction, cannot display error so pass it on unless they said do nothing */
        IF TRANSACTION AND NOT {&no-return} THEN
          RETURN ERROR cMessageList.

        /* do what they wanted us to */
          IF {&return-error} AND NOT {&no-return} THEN
            RETURN ERROR cMessageList.
          IF {&return-only} AND NOT {&no-return} THEN
            RETURN.
      &ENDIF

    /*Cancel any wait state if error occurs*/
    IF SESSION:GET-WAIT-STATE() <> "":U THEN
      SESSION:SET-WAIT-STATE("").

    END.  /* IF ERROR-STATUS:ERROR THEN */
&ENDIF /* not {&define-only} */
