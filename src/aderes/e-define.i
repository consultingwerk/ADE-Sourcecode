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
/* e-define.i - export definitions */

DEFINE {1} SHARED WORK-TABLE qbf-esys NO-UNDO
/*  FIELD qbf-live  AS LOGICAL */    /* true=query, false=template          */
  FIELD qbf-type    AS CHARACTER  /* format type                            */
  FIELD qbf-desc    AS CHARACTER  /* description of format                  */
  FIELD qbf-headers AS LOGICAL    /* include field headers (ascii only)     */
  FIELD qbf-fixed   AS LOGICAL    /* fixed width export?                    */
  FIELD qbf-prepass AS LOGICAL    /* needs initial prepass to count records */
  FIELD qbf-base    AS DATE       /* base date or ? to export date as char  */
  FIELD qbf-width   AS INTEGER    /* used internally by some generators     */
  FIELD qbf-program AS CHARACTER  /* name of program that generates code    */
  FIELD qbf-lin-beg AS CHARACTER  /* line starter character (ascii only)    */
  FIELD qbf-lin-end AS CHARACTER  /* line delimiter character (ascii only)  */
  FIELD qbf-fld-dlm AS CHARACTER  /* field delimiter character (ascii only) */
  FIELD qbf-fld-sep AS CHARACTER  /* field separator character (ascii only) */
  FIELD qbf-dlm-typ AS CHARACTER INITIAL "*":u     /* data types to delimit */
  FIELD qbf-code    AS CHARACTER EXTENT 4.  /* code for 'put control' stmts */
/*
qbf-esys.qbf-code[1] -> qbf-esys.qbf-lin-beg - line starter
qbf-esys.qbf-code[2] -> qbf-esys.qbf-lin-end - line delimiter
qbf-esys.qbf-code[3] -> qbf-esys.qbf-fld-dlm - field delimiter
qbf-esys.qbf-code[4] -> qbf-esys.qbf-fld-sep - field separator
*/

DEFINE {1} SHARED VARIABLE qbf-e-cat AS CHARACTER EXTENT 64 NO-UNDO.
/*
Each element in qbf-e-cat[] contains entries which are one or more of
the following codes, in any order, "|"-delimited:
  b= qbf-base    - base date or ? to export date as char
  d= qbf-dlm-typ - data types to delimit with i-fld-dlm
  f= qbf-fixed   - fixed width export?
  h= qbf-headers - include field headers
  i= qbf-prepass - needs initial prepass to count records
  l= qbf-desc    - description of format
  p= qbf-program - name of program that generates code
  t= qbf-type    - format type
  1= qbf-lin-beg - line starter character (ascii only)
  2= qbf-lin-end - line delimiter character (ascii only)
  3= qbf-fld-dlm - field delimiter character (ascii only)
  4= qbf-fld-sep - field separator character (ascii only)

  b= base date or ? to export date as char (used for DIF)       [?]
  d= data types to delimit with '3=' from below, or '*' for all [*]
  f= fixed width export? 'y' or 'n'.                            [n]
  h= include field headers? 'y' or 'n'.                         [n]
  i= needs initial prepass to count records? 'y' or 'n'.        [n]
  l= description of format   
  p= name of program that generates code.
  t= format type.  must be unique.
  1= line starter characters, comma-delimited                   []
  2= line delimiter characters, comma-delimited                 []
  3= field delimiter characters, comma-delimited                []
  4= field separator characters, comma-delimited                []
*/

/*
for converion from V6 results:
  qbf-d-attr[1]: qbf-type - format type (see t-d-eng.p set #3)
  qbf-d-attr[2]: qbf-headers - y/n, include field headers (ascii only)
  qbf-d-attr[3]: qbf-lin-beg - line starter character (ascii only)
  qbf-d-attr[4]: qbf-lin-end - line delimiter character (ascii only)
  qbf-d-attr[5]: qbf-fld-dlm - field delimiter character (ascii only)
  qbf-d-attr[6]: qbf-fld-sep - field separator character (ascii only)
  qbf-d-attr[7]: qbf-dlm-typ - data types to delimit with i-fld-dlm
*/

/* e-define.i - end of file */
