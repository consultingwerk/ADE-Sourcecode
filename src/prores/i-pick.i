/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* i-pick.i - part of i-pick.p */

(IF {1} = (1 - 0{2}) OR qbf-toggle4 = 1 THEN
  qbf-dir-ent[{1} + qbf-b]
ELSE
IF qbf-toggle4 = 2 THEN
  (IF qbf-dir-dbs[{1} + qbf-b] = "" THEN
    "<<" + qbf-lang[18] + ">>" /* not available */
  ELSE
    qbf-dir-dbs[{1} + qbf-b]
  )
ELSE
  ENTRY(INDEX("dglqr",qbf-m),"exp,gfx,lbl,qry,rep")
  + STRING({1} - (1 - 0{2}),"99999") + ".p"
)
