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
