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
    /* UIB triggers for WINDOW widgets - used in _drwwind and _rdwind */
    ON ENTRY             PERSISTENT RUN wind-event IN _h_uib ("WINDOW-ENTRY":U).
    ON MOUSE-SELECT-DOWN PERSISTENT RUN wind-select-down IN _h_uib.
    ON MOUSE-SELECT-UP   PERSISTENT RUN wind-select-up   IN _h_uib.
    ON WINDOW-CLOSE 	 PERSISTENT RUN wind-event IN _h_uib ("WINDOW-CLOSE":U).
    ON WINDOW-MINIMIZED  PERSISTENT RUN wind-event IN _h_uib ("WINDOW-MINIMIZED":U). 
    ON WINDOW-RESIZED    PERSISTENT RUN adeuib/_rszwind.p (TRUE).
    /* Help in the dialog-box design windows */
    ON HELP ANYWHERE     PERSISTENT RUN disp_help      IN _h_uib.
                             
    /* Group Triggers (to apply Main Menu Accelerators in design window) */
    {adeuib/grptrig.i}
