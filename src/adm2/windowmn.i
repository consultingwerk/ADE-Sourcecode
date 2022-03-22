/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* windowmn.i - New V9 Main Block code for objects which create windows.*/
/* Skip all of this if no window was created. */
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */

DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN DO:
    ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

    /* The CLOSE event can be used from inside or outside the procedure to  */
    /* terminate it.                                                        */
    ON CLOSE OF THIS-PROCEDURE 
    DO:
      RUN destroyObject NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN NO-APPLY.
    END.
    
    /* By default, Make sure current-window is always the window with focus. */
    /* To get the old behavior, simply define OldCurrentWindowFocus.    */
    &IF DEFINED(OldCurrentWindowFocus) = 0 &THEN    /* if not defined */
      ON ENTRY OF {&WINDOW-NAME} DO:
        ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
      END.
    &ENDIF 

    RUN createObjects. 

/* Execute this code only if not being run PERSISTENT, i.e., if in test mode
   of one kind or another or if this is a Main Window. Otherwise postpone 
   'initialize' until told to do so. */

&IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
&ENDIF
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
    /* Now enable the interface and wait for the exit condition.            */
       RUN initializeObject.
       IF NOT THIS-PROCEDURE:PERSISTENT THEN
           WAIT-FOR CLOSE OF THIS-PROCEDURE.
    END.
&IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
END.
&ENDIF
END.

