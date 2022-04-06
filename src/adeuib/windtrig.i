/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    /* moved out to avoid defining for oeide 11.3 {adeuib/grptrig.i} */
