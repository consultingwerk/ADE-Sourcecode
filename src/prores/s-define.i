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
/* s-define.i - system-wide defines */

/*--------------------------------------------------------------------------*/
/*file-level stuff:*/
DEFINE {1} SHARED VARIABLE qbf-asked AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-db    AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-file  AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-of    AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-order AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-where AS CHARACTER EXTENT 5 NO-UNDO.

/*--------------------------------------------------------------------------*/
/*field-level stuff:*/
/*
qbf-rc#
qbf-rcn[]: field-names
qbf-rcl[]: field-labels
qbf-rcf[]: field-formats
qbf-rcc[]: calc field stuff
qbf-rca[]: field-attrs (totals/subtotals)
qbf-rcw[]: field-widths
qbf-rct[]: data-types - 1=char,2=date,3=log,4=int,5=dec,6=raw,7=rowid
*/
DEFINE {1} SHARED VARIABLE qbf-rc# AS INTEGER                         NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcn AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcl AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcf AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rca AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcc AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcw AS INTEGER   EXTENT { prores/s-limcol.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rct AS INTEGER   EXTENT { prores/s-limcol.i } NO-UNDO.

/*--------------------------------------------------------------------------*/
/*data export stuff:*/
/*
qbf-d-attr[ 1]:   i-type - format type (see t-d-eng.p set #3)
qbf-d-attr[ 2]:   i-headers - y/n, include field headers (ascii only)
qbf-d-attr[ 3]:   i-lin-beg - line starter character (ascii only)
qbf-d-attr[ 4]:   i-lin-end - line delimiter character (ascii only)
qbf-d-attr[ 5]:   i-fld-dlm - field delimiter character (ascii only)
qbf-d-attr[ 6]:   i-fld-sep - field separator character (ascii only)
qbf-d-attr[ 7]:   i-dlm-typ - data types to delimit with i-fld-dlm
*/
DEFINE {1} SHARED VARIABLE qbf-d-attr AS CHARACTER EXTENT 7 NO-UNDO.

/*--------------------------------------------------------------------------*/
/*labels stuff:*/
/*
qbf-l-attr[1]:     l-x-lm (int) left margin
qbf-l-attr[2]:     l-x-ls (int) label width
qbf-l-attr[3]:     l-y-th (int) total height
qbf-l-attr[4]:     l-y-tm (int) top margin
qbf-l-attr[5]:     l-x-na (int) number across
qbf-l-attr[6]:     l-omit (int, 0=false, 1=true) omit blank lines
qbf-l-attr[7]:     copies (int)
qbf-l-auto[1..10]: can-do style patterns for selecting fields:
                   name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country
qbf-l-text[1..64]: label text and fields (note UNDO-able!)
*/
DEFINE {1} SHARED VARIABLE qbf-l-attr AS INTEGER   EXTENT    7 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-auto AS CHARACTER EXTENT   10 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-text AS CHARACTER EXTENT { prores/s-limlbl.i }.

/*--------------------------------------------------------------------------*/
/*report writer stuff:*/
/*
qbf-r-attr[ 1]:     rml (integer initial 1)  left margin
qbf-r-attr[ 2]:     rps (integer initial 66) page size
qbf-r-attr[ 3]:     rbs (integer initial 1)  column spacing
qbf-r-attr[ 4]:     rls (integer initial 1)  line spacing
qbf-r-attr[ 5]:     new (integer initial 1)  starting line
qbf-r-attr[ 6]:     integers initial 0 header-body spacing
qbf-r-attr[ 7]:     integers initial 0 body-footer spacing
qbf-r-attr[ 8]:     =0 for regular, =1 for summary report
qbf-r-attr[ 9]:     number of order-by to page-eject at, or 0
qbf-r-attr[10]:     <available>
qbf-r-head[ 1.. 3]: first-page-only header lines 1 to 3
qbf-r-head[ 4.. 6]: last-page-only  footer lines 1 to 3
qbf-r-head[ 7.. 9]: top-left   header lines 1 to 3
qbf-r-head[10..12]: top-center header lines 1 to 3
qbf-r-head[13..15]: top-right  header lines 1 to 3
qbf-r-head[16..18]: bot-left   footer lines 1 to 3
qbf-r-head[19..21]: bot-center footer lines 1 to 3
qbf-r-head[22..24]: bot-right  footer lines 1 to 3
*/
DEFINE {1} SHARED VARIABLE qbf-r-attr AS INTEGER   EXTENT 10 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-r-head AS CHARACTER EXTENT 24 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-r-defs AS CHARACTER EXTENT 32 NO-UNDO.

/*--------------------------------------------------------------------------*/
/* query module stuff: */
DEFINE {1} SHARED VARIABLE qbf-q-opts AS LOGICAL EXTENT 21 NO-UNDO.

/*--------------------------------------------------------------------------*/
/*user module stuff:*/

/*
qbf-u-brow - name of browse include file used in query
qbf-u-enam - description of user-defined export type
qbf-u-expo - program name for user-defined export type
qbf-u-prog - program to run when 'User' selected from menu
qbf-user   - is 'User' program installed?
*/
DEFINE {1} SHARED VARIABLE qbf-u-brow AS CHARACTER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-u-enam AS CHARACTER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-u-expo AS CHARACTER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-u-prog AS CHARACTER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-user   AS LOGICAL INITIAL FALSE NO-UNDO.

/*--------------------------------------------------------------------------*/
