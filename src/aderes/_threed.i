/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u AND qbf-threed THEN
  ASSIGN
    std_fillin_bgcolor = ? 
    FRAME {1}:THREE-D  = qbf-threed
    .
