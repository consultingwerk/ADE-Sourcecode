/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* af-idefs.i
*
*    Used for fastload. This file contains all of the internal variables 
*    that are needed for the fastload code but that we DO NOT want users 
*    to see.  When shipped to users this file must be encrypted.
*    Unfortunately, these are duplicates of the real definitions. The 
*    various definitions must be kept in synch.  Finally, no variable 
*    starting with an '_' would be in this file.  An end user will not be 
*    able to compile this insert.
*/

DEFINE SHARED VARIABLE lGlbStatus   AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE lGlbToolbar  AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE qbf-awrite   AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE qbf-checkdb  AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE qbf-dbs      AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-e-cat    AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-goodbye  AS LOGICAL.
DEFINE SHARED VARIABLE qbf-govergen AS LOGICAL.
DEFINE SHARED VARIABLE qbf-governor AS INTEGER.
DEFINE SHARED VARIABLE qbf-l-auto   AS CHARACTER NO-UNDO EXTENT 10.
DEFINE SHARED VARIABLE qbf-l-cat    AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-langset  AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-left     AS CHARACTER.
DEFINE SHARED VARIABLE qbf-p-cat    AS CHARACTER NO-UNDO EXTENT 64.
DEFINE SHARED VARIABLE qbf-product  AS CHARACTER.
DEFINE SHARED VARIABLE qbf-preview  AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE qbf-qdpubl   AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-right    AS CHARACTER.
DEFINE SHARED VARIABLE qbf-rel-tbl# AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE qbf-rel-whr# AS INTEGER   NO-UNDO.
DEFINE SHARED VARIABLE qbf-threed   AS LOGICAL INITIAL TRUE.
DEFINE SHARED VARIABLE qbf-u-hook   AS CHARACTER NO-UNDO EXTENT 16.

DEFINE {1} SHARED TEMP-TABLE qbf-rel-tt NO-UNDO
  FIELD tid     AS INTEGER      /* table index */
  FIELD tname   AS CHARACTER    /* table name */
  FIELD tdesc   AS CHARACTER    /* table description */
  FIELD rels    AS CHARACTER    /* relationships */
  FIELD crc     AS CHARACTER    /* CRC */
  FIELD cansee  AS LOGICAL      /* Table available to user */
  FIELD sid     AS INTEGER      /* Table Id */
  INDEX tidix   IS UNIQUE tid
  INDEX tnameix IS UNIQUE tname.

/* Table join WHERE clause */
DEFINE {1} SHARED TEMP-TABLE qbf-rel-whr NO-UNDO
  FIELD wid     AS INTEGER    /* WHERE clause index */
  FIELD jwhere  AS CHARACTER  /* WHERE clause */
  INDEX widix   IS UNIQUE wid.
  
DEFINE BUFFER qbf-rel-buf FOR qbf-rel-tt.
DEFINE BUFFER qbf-rel-buf2 FOR qbf-rel-tt.
DEFINE BUFFER qbf-rel-whr2 FOR qbf-rel-whr.

&GLOBAL-DEFINE FIND_TABLE_BY_ID    FIND qbf-rel-buf WHERE qbf-rel-buf.tid =
&GLOBAL-DEFINE FIND_TABLE_BY_NAME  FIND qbf-rel-buf WHERE qbf-rel-buf.tname =
&GLOBAL-DEFINE FIND_TABLE2_BY_ID   FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tid =
&GLOBAL-DEFINE FIND_TABLE2_BY_NAME FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tname =
&GLOBAL-DEFINE FIND_WHERE_BY_ID    FIND qbf-rel-whr WHERE qbf-rel-whr.wid =
&GLOBAL-DEFINE FIND_WHERE2_BY_ID   FIND qbf-rel-whr2 WHERE qbf-rel-whr2.wid =

&GLOBAL-DEFINE joinTypeSymbolString "=<>*?":u
&GLOBAL-DEFINE joinTypeTextList     "1:1,1:M,M:1,M:M,???":u
&GLOBAL-DEFINE joinShTypeUnknown    "?":u

DEFINE SHARED WORK-TABLE qbf-rsys NO-UNDO
  FIELD qbf-live         AS LOGICAL
  FIELD qbf-format       AS CHARACTER
  FIELD qbf-dimen        AS CHARACTER
  FIELD qbf-origin-hz    AS INTEGER
  FIELD qbf-origin-vt    AS INTEGER
  FIELD qbf-page-size    AS INTEGER
  FIELD qbf-space-hz     AS INTEGER
  FIELD qbf-space-vt     AS INTEGER
  FIELD qbf-header-body  AS INTEGER
  FIELD qbf-body-footer  AS INTEGER
  FIELD qbf-page-eject   AS CHARACTER
  FIELD qbf-width        AS INTEGER
  .

{ aderes/af-rship.i }  /* procedure af-rship. */

&GLOBAL-DEFINE qdUqExt .qd7
&GLOBAL-DEFINE qdExt   "{&qdUqExt}":u

/* af-idefs.i - end of file */

