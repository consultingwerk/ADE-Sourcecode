/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-define.i - local definitions for query module */

DEFINE {1} SHARED VARIABLE qbf-brow  AS CHARACTER EXTENT 5 INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-index AS CHARACTER EXTENT 5 INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-level AS INTEGER            INITIAL  1 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-query AS LOGICAL   EXTENT 5 INITIAL  ? NO-UNDO.

/*
  qbf-brow[n]  = browse fields
  qbf-index[n] = use-index index name
  qbf-level    = depth of query ([n] in these variables)
  qbf-query[n] = ?     for no Where or Query clause
               = TRUE  for a Query
               = FALSE for a Where
*/
