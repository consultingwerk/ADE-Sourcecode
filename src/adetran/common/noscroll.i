/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* This helps frames not grow scrollbars when run on different resolutions
   from what they were built on                                             */

IF FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P > FRAME {&FRAME-NAME}:HEIGHT-P OR
   FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P > FRAME {&FRAME-NAME}:WIDTH-P THEN
  ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P = FRAME {&FRAME-NAME}:HEIGHT-P
         FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P  = FRAME {&FRAME-NAME}:WIDTH-P
         FRAME {&FRAME-NAME}:SCROLLABLE       = NO.

