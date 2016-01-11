/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* i-define.i - object directory */

/* export lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-d-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-d-hi AS INTEGER NO-UNDO.

/* graph lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-g-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-g-hi AS INTEGER NO-UNDO.

/* label lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-l-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-hi AS INTEGER NO-UNDO.

/* query lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-q-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-q-hi AS INTEGER NO-UNDO.

/* report lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-r-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-r-hi AS INTEGER NO-UNDO.


DEFINE {1} SHARED VARIABLE qbf-dir-ent  AS CHARACTER
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-dbs  AS CHARACTER
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-flg  AS LOGICAL
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-ent# AS INTEGER   INITIAL  0 NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-dir-vrs  AS CHARACTER NO-UNDO.
