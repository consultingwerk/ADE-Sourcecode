/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Main Block code for ADM2 SmartDialogs. 
   Checks to be sure the Dialog Box has not been run persistent;
   creates any SmartObjects contained in the Dialog Box;
   sets up standard Dialog initialization and termination.
*/

DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF THIS-PROCEDURE:PERSISTENT THEN DO:
    MESSAGE "A SmartDialog is not intended to be run " + CHR(10) + 
            "Persistent or to be placed in another ":U + CHR(10) +
            "SmartObject at AppBuilder design time."
            VIEW-AS ALERT-BOX ERROR.
    RUN disable_UI.
    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

RUN createObjects.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initializeObject.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} {&FOCUS-Phrase}.
END.


RUN destroyObject.
