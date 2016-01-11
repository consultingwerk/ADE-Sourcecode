/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-etime.i - ETIME for pre-6.2F PROGRESS */

(IF KEYWORD("ETIME") = ? THEN TIME * 1000 ELSE ETIME)

/*
If this routine fails to compile (on 6.2A thru 6.2E), then change the 
above line to:

  (TIME * 1000)
*/
