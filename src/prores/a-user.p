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
/* a-user.p - S. Sign-on Program/Product Name & U. User Options */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-w AS CHARACTER NO-UNDO.
/*
qbf-w:
  a-user.p ("b") - B. Browse Program for Query
  a-user.p ("e") - E. User-Defined Export Format
  a-user.p ("s") - S. Sign-on Program/Product Name
  a-user.p ("u") - U. User Option
*/

DEFINE VARIABLE qbf-a AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT    8 NO-UNDO.

{ prores/t-set.i &mod=a &set=3 }
ASSIGN
  qbf-m[2] = qbf-signon
  qbf-m[3] = qbf-product
  qbf-m[4] = qbf-u-prog
  qbf-m[5] = qbf-lang[22] /*"PROGRESS RESULTS"*/
  qbf-m[6] = qbf-u-expo
  qbf-m[7] = qbf-u-enam
  qbf-m[8] = qbf-u-brow.
{ prores/t-set.i &mod=a &set=2 }

/*--------------------------------------------------------------------------*/

FORM
  /*Enter the name of the include file to be used for the*/
  /*Browse option in the Query module.                   */
  qbf-lang[1] FORMAT "x(72)" SKIP
  qbf-lang[2] FORMAT "x(72)" SKIP(1)
  qbf-m[8]    FORMAT "x(64)" ATTR-SPACE SKIP(1)
  qbf-lang[3] FORMAT "x(24)" "  prores/u-browse.i" SKIP /*"Default Include File:"*/
  WITH FRAME qbf-browse ROW 4 COLUMN 2 NO-ATTR-SPACE NO-LABELS OVERLAY NO-BOX.

IF qbf-w BEGINS "b" THEN DO WITH FRAME qbf-browse:
  DISPLAY qbf-m[8] qbf-lang[1 FOR 3].
  DO WHILE NOT qbf-a ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SET qbf-m[8].
    qbf-a = SEARCH(qbf-m[8]) <> ?.
    /*8:"Cannot find program"*/
    IF NOT qbf-a THEN
      MESSAGE qbf-lang[8] '"' + qbf-m[8] + '"'.
    ELSE
      qbf-u-brow = qbf-m[8].
  END.
END.

ELSE /*---------------------------------------------------------------------*/

FORM
  /*This allows a user-designed data export program to be used.*/
  /*Please enter both the procedure name and the description   */
  /*for the "Data Export - Settings" menu.                     */
  qbf-lang[20] FORMAT "x(72)" SKIP
  qbf-lang[21] FORMAT "x(72)" SKIP
  qbf-lang[22] FORMAT "x(72)" SKIP(1)

  qbf-lang[23] FORMAT "x(72)" SKIP /*Procedure:*/
  qbf-m[6] FORMAT "x(64)" ATTR-SPACE SKIP(1)

  qbf-lang[24] FORMAT "x(72)" SKIP /*Description:*/
  qbf-m[7] FORMAT "x(32)" ATTR-SPACE SKIP

  WITH FRAME qbf-export ROW 4 COLUMN 2 NO-ATTR-SPACE NO-LABELS OVERLAY NO-BOX.

IF qbf-w BEGINS "e" THEN DO WITH FRAME qbf-export:
  DISPLAY qbf-m[6] qbf-m[7] qbf-lang[20 FOR 5].
  DO WHILE NOT qbf-a ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SET qbf-m[6] qbf-m[7].
    qbf-a = SEARCH(qbf-m[6]) <> ?.
    /* now check for .r when .p does not exist in propath */
    IF NOT qbf-a AND qbf-m[6] MATCHES "*~~.p" THEN
      qbf-a = SEARCH(SUBSTRING(qbf-m[6],1,LENGTH(qbf-m[6]) - 1) + "r") <> ?.
    /*8:"Cannot find program"*/
    IF NOT qbf-a THEN
      MESSAGE qbf-lang[8] '"' + qbf-m[6] + '"'.
    ELSE
      ASSIGN
        qbf-u-expo = qbf-m[6]
        qbf-u-enam = qbf-m[7].
  END.
END.

ELSE /*---------------------------------------------------------------------*/

FORM
  /*Enter the name of the signon program.  This program can be either*/
  /*a simple logo, or a complete login procedure similar to "login.p"*/
  /*in the "DLC" directory.  This program is executed as soon as the */
  /*"signon=" line is read from the DBNAME.qc file.                  */
  qbf-lang[ 9] FORMAT "x(72)" SKIP
  qbf-lang[10] FORMAT "x(72)" SKIP
  qbf-lang[11] FORMAT "x(72)" SKIP
  qbf-lang[12] FORMAT "x(72)" SKIP

  /*"  Sign-on Program:"*/
  qbf-lang[15] FORMAT "x(24)" qbf-m[2] FORMAT "x(48)" ATTR-SPACE SKIP(1)

  /*Enter the name of the product as you want it displayed*/
  /*on the Main Menu.*/
  qbf-lang[13] FORMAT "x(72)" SKIP
  qbf-lang[14] FORMAT "x(72)" SKIP

  /*"     Product Name:"*/
  qbf-lang[16] FORMAT "x(24)" qbf-m[3] FORMAT "x(25)" ATTR-SPACE SKIP(1)

  qbf-lang[17] FORMAT "x(24)" SKIP /*"Defaults:"*/
  qbf-m[1] FORMAT "x(48)" SKIP /*"Sign-on Program:"  'prores/u-logo.p'*/
  qbf-m[5] FORMAT "x(48)" SKIP(1) /*"Product Name:"  'PROGRESS RESULTS'*/
  WITH FRAME qbf-signon ROW 3 COLUMN 2
  NO-ATTR-SPACE NO-LABELS OVERLAY NO-BOX.

IF qbf-w BEGINS "s" THEN DO WITH FRAME qbf-signon:
  DISPLAY qbf-m[2] qbf-m[3] qbf-lang[9 FOR 9]
    qbf-lang[15] + " prores/u-logo.p" @ qbf-m[1]
    qbf-lang[16] + " " + qbf-m[5] @ qbf-m[5].
  DO WHILE NOT qbf-a ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SET qbf-m[2] qbf-m[3].
    qbf-a = SEARCH(qbf-m[2]) <> ?.
    /* now check for .r when .p does not exist in propath */
    IF NOT qbf-a AND qbf-m[2] MATCHES "*~~.p" THEN
      qbf-a = SEARCH(SUBSTRING(qbf-m[2],1,LENGTH(qbf-m[2]) - 1) + "r") <> ?.
    /*8:"Cannot find program"*/
    IF NOT qbf-a THEN
      MESSAGE qbf-lang[8] '"' + qbf-m[2] + '"'.
    ELSE
      ASSIGN
        qbf-signon  = qbf-m[2]
        qbf-product = qbf-m[3].
  END.
END.

ELSE /*---------------------------------------------------------------------*/

FORM
  qbf-lang[18] FORMAT "x(72)" SKIP /*PROGRESS User Procedure:*/
  qbf-m[4]     FORMAT "x(64)" ATTR-SPACE SKIP
  qbf-lang[19] FORMAT "x(72)" SKIP
  /*This procedure runs when the ~"User~" option is selected from any menu.*/
  WITH FRAME qbf-user ROW 4 COLUMN 2 NO-ATTR-SPACE NO-LABELS OVERLAY NO-BOX.

IF qbf-w BEGINS "u" THEN DO WITH FRAME qbf-user:
  DISPLAY qbf-m[4] qbf-lang[18 FOR 2].
  DO WHILE NOT qbf-a ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SET qbf-m[4].
    qbf-a = SEARCH(qbf-m[4]) <> ? OR qbf-m[4] = "".
    /* now check for .r when .p does not exist in propath */
    IF NOT qbf-a AND qbf-m[4] MATCHES "*~~.p" THEN
      qbf-a = SEARCH(SUBSTRING(qbf-m[4],1,LENGTH(qbf-m[4]) - 1) + "r") <> ?.
    /*8:"Cannot find program"*/
    IF NOT qbf-a THEN
      MESSAGE qbf-lang[8] '"' + qbf-m[4] + '"'.
    ELSE
      qbf-u-prog = qbf-m[4].
  END.
END.

/*--------------------------------------------------------------------------*/

HIDE FRAME qbf-browse NO-PAUSE.
HIDE FRAME qbf-export NO-PAUSE.
HIDE FRAME qbf-signon NO-PAUSE.
HIDE FRAME qbf-user   NO-PAUSE.

{ prores/t-reset.i }
RETURN.
