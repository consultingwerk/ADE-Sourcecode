/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * j-define.i - table and relations caches
 */

&GLOBAL-DEFINE maxRelSize 1024

/* Count of WHERE relations and tables */
DEFINE {1} SHARED VARIABLE qbf-rel-whr# AS INTEGER   INITIAL   0 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rel-tbl# AS INTEGER   INITIAL   0 NO-UNDO.

/* Table list and relationships */
DEFINE {1} SHARED TEMP-TABLE qbf-rel-tt NO-UNDO
  FIELD tid     AS INTEGER    /* table index */
  FIELD tname   AS CHARACTER  /* table name */
  FIELD tdesc   AS CHARACTER  /* table description */
  FIELD rels    AS CHARACTER  /* relationships */
  FIELD crc     AS CHARACTER  /* CRC */
  FIELD cansee  AS LOGICAL    /* Table available to user */
  FIELD sid     AS INTEGER    /* This table is an synonym (alias) of */
  INDEX tidix   IS UNIQUE tid
  INDEX tnameix IS UNIQUE tname.

/* Table join WHERE clause */
DEFINE {1} SHARED TEMP-TABLE qbf-rel-whr NO-UNDO
  FIELD wid     AS INTEGER    /* WHERE clause index */
  FIELD jwhere  AS CHARACTER  /* WHERE clause */
  INDEX widix   IS UNIQUE wid.
  
/*--------------------------------------------------------------------
   qbf-rel-tt.rels format: 

   ",?x:y,?x,?x,..."  /* Note the leading comma */

   where "?" is the relation code:
     '=' for 1:1, '<' for 1:M, '>' for M:1 or '*' for M:M
     '?' means unsure, and should be treated as M:M
   and "x" is the table id (qbf-rel-tt.tid) that the current
     file is joinable with
   and ":y" is an optional reference to the qbf-rel-whr record which
     holds the WHERE-clause.  no ":y", means that an OF join is used.
  
  qbf-rel-whr contains the WHERE-clause corresponding to the :y from
  above.
  
---------------------------------------------------------------------*/

/* These are local buffers that access the qbf-rel-tt info.  This way
   each .p will have a local buffer and we don't have to worry about .p's
   globbering each other's buffer contents.
*/
DEFINE BUFFER qbf-rel-buf  for qbf-rel-tt.
DEFINE BUFFER qbf-rel-buf2 for qbf-rel-tt.

&GLOBAL-DEFINE FIND_TABLE_BY_ID    FIND qbf-rel-buf WHERE qbf-rel-buf.cansee AND qbf-rel-buf.tid =
&GLOBAL-DEFINE FIND_TABLE_BY_NAME  FIND qbf-rel-buf WHERE qbf-rel-buf.cansee AND qbf-rel-buf.tname =
&GLOBAL-DEFINE FIND_TABLE2_BY_ID   FIND qbf-rel-buf2 WHERE qbf-rel-buf2.cansee AND qbf-rel-buf2.tid =
&GLOBAL-DEFINE FIND_TABLE2_BY_NAME FIND qbf-rel-buf2 WHERE qbf-rel-buf2.cansee AND qbf-rel-buf2.tname =
&GLOBAL-DEFINE TBNAME_TO_BUFNAME   ENTRY(2,qbf-rel-buf.tname,".":u)
&GLOBAL-DEFINE TBNAME2_TO_BUFNAME  ENTRY(2,qbf-rel-buf2.tname,".":u)

/* For accessing qbf-rel-whr table join WHERE clause */
DEFINE BUFFER qbf-rel-whr2 FOR qbf-rel-whr.
&GLOBAL-DEFINE FIND_WHERE_BY_ID    FIND qbf-rel-whr WHERE qbf-rel-whr.wid =
&GLOBAL-DEFINE FIND_WHERE2_BY_ID   FIND qbf-rel-whr2 WHERE qbf-rel-whr2.wid =

/* List of Join Choices
   The format of this is "1:4,8:2" where the 1st # in each entry 
   represents a table id (qbf-rel-tt.tid) and the associated # is the
   id which is the join partner chosen by the user out of 2 or more that 
   would make sense.
*/
DEFINE {1} SHARED VARIABLE qbf-rel-choice AS CHARACTER NO-UNDO. 

/* List of databases */
DEFINE {1} SHARED VARIABLE qbf-dbs      AS CHARACTER NO-UNDO.

DEFINE {1} SHARED TEMP-TABLE _tableWhere
  FIELD _tableId AS INTEGER
  FIELD _text    AS CHARACTER
  INDEX _tableWhereInd IS UNIQUE _tableId
.

&GLOBAL-DEFINE joinOneToOne         "1:1":u
&GLOBAL-DEFINE joinOneToMany        "1:M":u
&GLOBAL-DEFINE joinManyToOne        "M:1":u
&GLOBAL-DEFINE joinManyToMany       "M:M":u
&GLOBAL-DEFINE joinTypeUnknown      "???":u
&GLOBAL-DEFINE joinShTypeUnknown    "?":u
&GLOBAL-DEFINE joinTypeTextList     "1:1,1:M,M:1,M:M,???":u
&GLOBAL-DEFINE joinTypeSymbolList   "=,<,>,*,?":u
&GLOBAL-DEFINE joinTypeSymbolString "=<>*?":u

/* j-define.i - end of file */

