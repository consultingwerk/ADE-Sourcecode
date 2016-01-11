/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*
 * j-define.i - table and relations caches
 */

&GLOBAL-DEFINE maxRelSize 1024

/* Count of tables */
DEFINE {1} SHARED VARIABLE qbf-rel-tbl# AS INTEGER   INITIAL   0 NO-UNDO.

/*
 * Define a shared temp table to handle relationship between tables. The
 * temp table will make it easier to  eliminate duplicate relationships.
 * It is only used during the gathering process. The table is destroyed
 * when this function goes out of scope.
 */

DEFINE {1} SHARED TEMP-TABLE _rels NO-UNDO
  FIELD baseTable    AS INTEGER
  FIELD relatedTable AS INTEGER
  INDEX baseIx baseTable.

/* Table list and relationships */
DEFINE {1} SHARED TEMP-TABLE qbf-rel-tt NO-UNDO
  FIELD tid     AS INTEGER    /* table index */
  FIELD tname   AS CHARACTER  /* table name */
  FIELD rels    AS CHARACTER  /* relationships */
  FIELD joinfld AS CHARACTER  /* join field list */
  INDEX tidix   IS UNIQUE tid
  INDEX tnameix IS UNIQUE tname.

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

&GLOBAL-DEFINE FIND_TABLE_BY_ID    FIND qbf-rel-buf WHERE qbf-rel-buf.tid =
&GLOBAL-DEFINE FIND_TABLE_BY_NAME  FIND qbf-rel-buf WHERE qbf-rel-buf.tname =
&GLOBAL-DEFINE FIND_TABLE2_BY_ID   FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tid =
&GLOBAL-DEFINE FIND_TABLE2_BY_NAME FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tname =
&GLOBAL-DEFINE TBNAME_TO_BUFNAME   ENTRY(2,qbf-rel-buf.tname,".":u)
&GLOBAL-DEFINE TBNAME2_TO_BUFNAME  ENTRY(2,qbf-rel-buf2.tname,".":u)

/* List of Join Choices
   The format of this is "1:4,8:2" where the 1st # in each entry 
   represents a table id (qbf-rel-tt.tid) and the associated # is the
   id which is the join partner chosen by the user out of 2 or more that 
   would make sense.
*/

/* List of databases */
DEFINE {1} SHARED VARIABLE qbf-dbs      AS CHARACTER NO-UNDO.

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

