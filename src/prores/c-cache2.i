/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-cache2.i - used by c-cache.p */

ASSIGN
  qbf-k = LOOKUP(ENTRY({&cursor},qbf-f) + "." + qbf-c{&cursor}._Field-name,
          qbf-o)
  qbf-t = "".
IF qbf-k > 0 THEN
  ASSIGN
    OVERLAY(qbf-u,qbf-k * 5 - 4,4) = STRING(qbf-ctop,"9999")
    qbf-t = ENTRY(qbf-k,qbf-v).

ASSIGN
  qbf-ctop           = qbf-ctop + 1
  lReturn            = getRecord("qbf-cfld":U, qbf-ctop)
  qbf-cfld.cValue    = ENTRY({&cursor},qbf-f) + ","
                     + qbf-c{&cursor}._Field-name
                     + (IF qbf-c{&cursor}._Extent = 0
                       THEN ","
                       ELSE "[" + qbf-t + "]," + STRING(qbf-c{&cursor}._Extent))
                     + ",|"
                     + (IF qbf-c{&cursor}._Label = ?
                       THEN qbf-c{&cursor}._Field-name
                       ELSE qbf-c{&cursor}._Label)
                     + (IF qbf-c{&cursor}._Extent = 0
                       THEN ""
                       ELSE "[" + qbf-t + "]").
