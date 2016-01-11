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
/* reswidg.i */

/* qbf-a (b-join.i) */
DEFINE {1} SHARED TEMP-TABLE qbf-a
  FIELD iIndex AS INTEGER
  FIELD aValue AS INTEGER
  FIELD xValue AS RECID
  FIELD bValue AS INTEGER
  FIELD yValue AS RECID
  FIELD cScrap AS CHARACTER
  INDEX iIndex IS UNIQUE PRIMARY iIndex xValue
  INDEX aValue aValue
  INDEX cScrap cScrap.
  
/* qbf-cfld (c-cache.i) */
DEFINE {1} SHARED TEMP-TABLE qbf-cfld NO-UNDO
  FIELD iIndex AS INTEGER
  FIELD cValue AS CHARACTER
  FIELD cScrap AS CHARACTER
  INDEX iIndex IS UNIQUE PRIMARY iIndex
  INDEX cValue cValue
  INDEX cScrap cScrap.
                                      
/* qbf-form (c-form.i). cValue has the following parts:
  format: "db.filename,progname,####"
  example: "demo.order-line,order-li,0006"
       or: "demo.order-line,,0006"
  dbfilename  = name of file in database with mandatory "db." qualifier
  ,           = comma separator
  progname    = name of .p.  1 to 8 characters, .p omitted.  if blank, use
                substr(entry(1,qbf-form[]),index(entry(1,qbf-form[]),".") + 1,8)
  ,           = comma separator
  ####        = array element number (same as subscript in [])
  |           = vertical bar character
  
  cDesc       = "" means get from _File._Desc on-the-fly, otherwise use
                what's here.
*/
DEFINE {1} SHARED TEMP-TABLE qbf-form
  FIELD iIndex AS INTEGER
  FIELD cValue AS CHARACTER /*qbf-form*/
  FIELD cDesc  AS CHARACTER
  FIELD xValue AS CHARACTER /*qbf-fext*/
  INDEX iIndex IS UNIQUE PRIMARY iIndex
  INDEX cValue cValue.

/* qbf-join (c-form.i). cValue has the following parts:
  format: "db.file1,db.file2"
  example: "demo.customer,demo.order"
       or: "first.customer,second.agedar"
  db.file1    = first db.file name
  ,           = comma separator
  db.file2    = join to db.file name
  
  cWhere      = where clause, or "" for "OF" relationship
                for where clause, "WHERE" is not stored
*/
DEFINE {1} SHARED TEMP-TABLE qbf-join
  FIELD iIndex AS INTEGER
  FIELD cValue AS CHARACTER
  FIELD cWHERE AS CHARACTER
  FIELD cScrap AS CHARACTER
  INDEX iIndex IS UNIQUE PRIMARY iIndex
  INDEX cValue cValue
  INDEX cScrap cScrap.

/* qbf-schema (c-merge.i). 
   qbf-schema.cValue = "filename,dbname,0000description"
     but warning!  a-join.p alters the structure of this array to be:
   qbf-schema.cValue = "filename,dbname,###,###,....."
     where the ### is a list of pointers into qbf-join temp-table of join 
     records that contains a reference to that file.
*/
DEFINE {1} SHARED TEMP-TABLE qbf-schema
  FIELD iIndex AS INTEGER
  FIELD cValue AS CHARACTER
  FIELD cSort  AS CHARACTER
  INDEX iIndex IS UNIQUE PRIMARY iIndex
  INDEX cSort  cSort.
  
DEFINE {1} SHARED BUFFER buf-a      FOR qbf-a.
DEFINE {1} SHARED BUFFER buf-cfld   FOR qbf-cfld.
DEFINE {1} SHARED BUFFER buf-form   FOR qbf-form.
DEFINE {1} SHARED BUFFER buf-join   FOR qbf-join.
DEFINE {1} SHARED BUFFER buf-schema FOR qbf-schema.

&GLOBAL-DEFINE FIND_QBF_A      FIND FIRST qbf-a WHERE qbf-a.iIndex =
&GLOBAL-DEFINE FIND_QBF_CFLD   FIND qbf-cfld WHERE qbf-cfld.iIndex =
&GLOBAL-DEFINE FIND_QBF_FORM   FIND qbf-form WHERE qbf-form.iIndex =
&GLOBAL-DEFINE FIND_QBF_JOIN   FIND qbf-join WHERE qbf-join.iIndex =
&GLOBAL-DEFINE FIND_QBF_SCHEMA FIND qbf-schema WHERE qbf-schema.iIndex =

&GLOBAL-DEFINE FIND_BUF_A      FIND FIRST buf-a WHERE buf-a.iIndex =
&GLOBAL-DEFINE FIND_BUF_CFLD   FIND buf-cfld WHERE buf-cfld.iIndex =
&GLOBAL-DEFINE FIND_BUF_FORM   FIND buf-form WHERE buf-form.iIndex =
&GLOBAL-DEFINE FIND_BUF_JOIN   FIND buf-join WHERE buf-join.iIndex =
&GLOBAL-DEFINE FIND_BUF_SCHEMA FIND buf-schema WHERE buf-schema.iIndex =
