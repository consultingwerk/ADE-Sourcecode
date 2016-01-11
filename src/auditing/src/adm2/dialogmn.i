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
