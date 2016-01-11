/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * i-define.i - object directory
 */

DEFINE {1} SHARED VARIABLE qbf-dir-dbs  AS CHARACTER EXTENT 256 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-ent  AS CHARACTER EXTENT 256 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-num  AS INTEGER   EXTENT 256 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-flg  AS LOGICAL   EXTENT 256 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-ent# AS INTEGER   INITIAL  0 NO-UNDO.

/* i-define.i - end of file */

