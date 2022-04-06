/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

