/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
      /* UIB triggers for frame widgets - used in _drwfram and _rdfram */
      ON SELECTION          PERSISTENT RUN setselect            IN _h_uib.
      ON DESELECTION        PERSISTENT RUN setdeselection       IN _h_uib.
      ON END-MOVE           PERSISTENT RUN endmove              IN _h_uib.
      ON END-RESIZE         PERSISTENT RUN endresize            IN _h_uib.
      ON MOUSE-SELECT-DOWN, MOUSE-EXTEND-DOWN
                            PERSISTENT RUN setxy                 IN _h_uib.
      ON MOUSE-SELECT-UP, MOUSE-EXTEND-UP
                             PERSISTENT RUN frame-select-up      IN _h_uib.
      ON EMPTY-SELECTION     PERSISTENT RUN drawobj-or-select    IN _h_uib.
      ON END-BOX-SELECTION   PERSISTENT RUN frame-select-up      IN _h_uib.
      ON START-BOX-SELECTION PERSISTENT RUN frame-startboxselect IN _h_uib.
      ON HELP                PERSISTENT RUN disp_help            IN _h_uib.
      ON CURSOR-LEFT, CURSOR-RIGHT, CURSOR-UP, CURSOR-DOWN
                             PERSISTENT RUN tapit                IN _h_uib.
