/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-cache1.i - used by c-cache.p */

FIND NEXT qbf-c{&cursor}
  WHERE qbf-c{&cursor}._File-recid = qbf-p[{&cursor}]
    AND CAN-DO(qbf-d,qbf-c{&cursor}._Data-type) /*"!rowid,!raw,*"*/
    AND CAN-DO(qbf-c{&cursor}._Can-read,USERID("RESULTSDB"))
    AND (qbf-a OR qbf-c{&cursor}._Extent = 0)
  USE-INDEX _File/Field
  NO-LOCK NO-ERROR.
