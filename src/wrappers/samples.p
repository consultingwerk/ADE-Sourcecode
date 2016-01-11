/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* This procedure is designed to launch sample applications.  In V8.0      */
/* the only sample application is adm/samples/w-ordtrk.w.  In the          */
/* future this procedure can be made into a menu procedure to launch       */
/* multiple sample applications as they become available.                  */


/* Since adm/samples/w-ordtrk.w is design to be a GUI application, we      */
/* need to give a message and return if SESSION:DISPLAY-TYPE = "TTY".      */

IF SESSION:DISPLAY-TYPE = "TTY":U THEN DO:
  MESSAGE "The order tracking sample application is designed for" SKIP
          "GUI mode only." VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

RUN adm/samples/w-ordtrk.w.
