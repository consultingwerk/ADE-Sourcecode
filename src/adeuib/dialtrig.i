/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* UIB triggers for dialog widgets - used in _drwdial and _rdfram */
&IF "{&SECTION}" eq "WINDOW" &THEN
      /* Triggers on the "Window" part of the UIB dialog widget */
      ON ENTRY            PERSISTENT RUN wind-event IN _h_uib ("DIALOG-ENTRY":U).
      ON WINDOW-MAXIMIZED PERSISTENT RUN wind-event IN _h_uib ("DIALOG-MAXIMIZED":U).
      ON WINDOW-RESTORED  PERSISTENT RUN wind-event IN _h_uib ("DIALOG-RESTORED":U).
      ON WINDOW-CLOSE     PERSISTENT RUN wind-event IN _h_uib ("DIALOG-CLOSE":U).
      ON WINDOW-MINIMIZED PERSISTENT RUN wind-event IN _h_uib ("DIALOG-MINIMIZED":U).
      ON WINDOW-RESIZED   PERSISTENT RUN adeuib/_rszdial.p.
      /* Help in the dialog-box design windows */
      ON HELP ANYWHERE    PERSISTENT RUN adecomm/_adehelp.p 
                          ( "AB", "CONTEXT", {&Pop_design_window}, ? ).
      /* Group Triggers (to apply Main Menu Accelerators in design window) */
      /* moved out to avoid defining for oeide 11.3 {adeuib/grptrig.i} */
&ELSE
      /* Triggers on the "frame" part of the UIB dialog widget */
      /* Note: Dialog boxes are one of the few things that we  */
      /* cannot select or deselect through progress            */
      ON MOUSE-SELECT-DOWN, MOUSE-EXTEND-DOWN
  		               PERSISTENT RUN setxy                IN _h_uib.
      ON MOUSE-SELECT-UP, MOUSE-EXTEND-UP
                               PERSISTENT RUN frame-select-up      IN _h_uib.
      ON EMPTY-SELECTION       PERSISTENT RUN drawobj-or-select    IN _h_uib.
      ON END-BOX-SELECTION     PERSISTENT RUN frame-select-up      IN _h_uib.
      ON START-BOX-SELECTION   PERSISTENT RUN frame-startboxselect IN _h_uib.
      ON CURSOR-LEFT, CURSOR-RIGHT, CURSOR-UP, CURSOR-DOWN
                               PERSISTENT RUN tapit                IN _h_uib.
&ENDIF
ON HELP                   PERSISTENT RUN disp_help      IN _h_uib.
