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
/*
 * _arest.i
 *
 *    THe rest of the stuff needed to make all the admin dialog boxes
 *    consistant. It is not limited to sullivan stuff, although that is
 *    is the only stuff in here right now.
 */


ON HELP OF FRAME {&FRAME-NAME}
  OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("res":u, "CONTEXT":u, {&HELP-NO}, ?).
END.

ASSIGN
  qbf-ok:SENSITIVE   IN FRAME {&FRAME-NAME} = TRUE
  qbf-ee:SENSITIVE   IN FRAME {&FRAME-NAME} = TRUE
  qbf-help:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
  .

/* Restore the current-window if it is an icon.  
 * Otherwise the dialog box will be hidden     
 */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED THEN
  CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/* The UIB thinks this line is important */
PAUSE 0 BEFORE-HIDE.

/* _arest.i - end of file */

