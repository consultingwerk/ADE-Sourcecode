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
/* b-misc.p -initialize miscellaneous system parameters */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-print.i }
{ prores/a-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=b &set=2 }

DEFINE VARIABLE qbf-a AS LOGICAL              NO-UNDO.
DEFINE VARIABLE qbf-d AS LOGICAL INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER              NO-UNDO.

/* is all connected databases are demo dbs, set default differently */
DO qbf-i = 1 TO NUM-DBS:
  CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(qbf-i)).
  IF DBTYPE(qbf-i) = "PROGRESS" THEN
    RUN prores/b-isdemo.p (OUTPUT qbf-a).
  ELSE
    qbf-a = FALSE.
  qbf-d = qbf-d AND qbf-a.
END.

/*-------------------------------------------------- Loading color settings */
ASSIGN
  qbf-t-name[1] = 'co80'
  qbf-t-hues[1] = 'BLACK/CYAN,WHITE/RED,GRAY/RED,RED/GRAY,BLUE/GRAY,GRAY/BLUE'.

/*--------------------------------------------------- Loading printer setup */
ASSIGN
  qbf-printer#    = 3

  qbf-printer[1]  = 'TERMINAL'
  qbf-pr-dev[1]   = ''
  qbf-pr-perm[1]  = '*'
  qbf-pr-type[1]  = 'page'
  qbf-pr-width[1] = 80

  qbf-printer[2]  = 'FILE'
  qbf-pr-dev[2]   = ''
  qbf-pr-perm[2]  = '*'
  qbf-pr-type[2]  = 'file'
  qbf-pr-width[2] = 80

  qbf-printer[3]  = 'PRINTER'
  qbf-pr-dev[3]   = 'PRINTER'
  qbf-pr-perm[3]  = '*'
  qbf-pr-type[3]  = 'to'
  qbf-pr-width[3] = 80.

IF TERMINAL = "MS-WIN" THEN
  ASSIGN
    qbf-printer#               = qbf-printer# + 1
    qbf-printer[qbf-printer#]  = 'Windows Clipboard'
    qbf-pr-dev[qbf-printer#]   = 'CLIPBOARD'
    qbf-pr-perm[qbf-printer#]  = '*'
    qbf-pr-type[qbf-printer#]  = 'to'
    qbf-pr-width[qbf-printer#] = 255.


/*----------------------- Loading auto-select field list for mailing labels */
ASSIGN
  qbf-l-auto[ 1] = qbf-lang[ 1]  /*name*/
  qbf-l-auto[ 2] = qbf-lang[ 2]  /*addr1*/
  qbf-l-auto[ 3] = qbf-lang[ 3]  /*addr2*/
  qbf-l-auto[ 4] = qbf-lang[ 4]  /*addr3*/
  qbf-l-auto[ 5] = qbf-lang[ 5]  /*city*/
  qbf-l-auto[ 6] = qbf-lang[ 6]  /*state*/
  qbf-l-auto[ 7] = qbf-lang[ 7]  /*zip*/
  qbf-l-auto[ 8] = qbf-lang[ 8]  /*zip+4*/
  qbf-l-auto[ 9] = qbf-lang[ 9]  /*city-state-zip*/
  qbf-l-auto[10] = qbf-lang[10]. /*country*/

/*----------------------------------------- Initializing security subsystem */

ASSIGN
  qbf-m-perm    = "*"
  qbf-q-perm    = "*"
  qbf-q-perm[5] = (IF qbf-d THEN "*" ELSE "!*")
  qbf-q-perm[6] = (IF qbf-d THEN "*" ELSE "!*")
  qbf-q-perm[7] = (IF qbf-d THEN "*" ELSE "!*")
  qbf-q-perm[8] = (IF qbf-d THEN "*" ELSE "!*").

/*------------------------------------------------ Loading user option info */
ASSIGN
  qbf-u-prog = (IF qbf-d THEN "prores/u-option.p" ELSE "") /* user-program= */
  qbf-u-expo = (IF qbf-d THEN "prores/u-export.p" ELSE "") /* user-export=  */
  qbf-u-enam = (IF qbf-d THEN qbf-lang[15] ELSE "") /*'Sample Export'*/
  qbf-u-brow = "prores/u-browse.i".          /* Query Browse Program */

/*------------------------------------------ Loading system report defaults */
ASSIGN
  qbf-r-head    = "" /* 1..24 for headers/footers */
  qbf-r-attr[1] = 1  /* left-margin= */
  qbf-r-attr[2] = 66 /* page-size= (change this to 72 for Australia) */
  qbf-r-attr[3] = 1  /* column-spacing= */
  qbf-r-attr[4] = 1  /* line-spacing= */
  qbf-r-attr[5] = 1  /* top-margin= */
  qbf-r-attr[6] = 0  /* before-body= */
  qbf-r-attr[7] = 0. /* after-body= */

{ prores/t-reset.i }
RETURN.
