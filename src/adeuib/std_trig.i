/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Standard UIB triggers for most drawn widgets */
ON SELECTION              PERSISTENT RUN setselect      IN _h_uib.
ON DESELECTION            PERSISTENT RUN setdeselection IN _h_uib.
ON END-MOVE               PERSISTENT RUN endmove        IN _h_uib.
ON END-RESIZE             PERSISTENT RUN endresize      IN _h_uib.
ON MOUSE-SELECT-DOWN, MOUSE-EXTEND-DOWN
                          PERSISTENT RUN setxy          IN _h_uib.
ON MOUSE-SELECT-CLICK, MOUSE-EXTEND-CLICK
                          PERSISTENT RUN drawobj        IN _h_uib.
ON MOUSE-SELECT-DBLCLICK  PERSISTENT RUN double-click   IN _h_uib.
ON HELP                   PERSISTENT RUN disp_help      IN _h_uib.
ON CURSOR-LEFT, CURSOR-RIGHT, CURSOR-DOWN, CURSOR-UP
                          PERSISTENT RUN tapit          IN _h_uib.
