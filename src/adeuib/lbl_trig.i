/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
         /* WB triggers for labels (on fill-ins) */
         ON MOUSE-SELECT-DOWN     PERSISTENT RUN setxy_lbl IN _h_uib.  
         ON MOUSE-SELECT-CLICK    PERSISTENT RUN drawobj   IN _h_uib.
         ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN adeuib/_prp_lbl.p (?).
