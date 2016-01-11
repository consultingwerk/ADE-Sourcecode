/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-time.i - format millisecond time as MM:SS.SS */

(
  STRING(TRUNCATE({1} / 60000,0),"99") + ":"
    + STRING(({1} MODULO 60000) / 1000,"99.99")
)
