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
/* a-main.p - Administration module main procedure */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/a-define.i NEW }

DEFINE VARIABLE qbf#  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

FORM " "
  WITH DOWN FRAME qbf-shadow WIDTH 80 ROW 2 COLUMN 1 NO-ATTR-SPACE OVERLAY
  TITLE COLOR VALUE(qbf-mlo) qbf-c.

HIDE ALL NO-PAUSE.

/*
programs available:
  b-again.p (FALSE) - A. Application Rebuild
  a-user.p ("b")    - B. Browse Program for Query
  a-info.p          - C. Contents of a User Directory
  r-set.p (FALSE)   - D. Default Report Options
  a-user.p ("e")    - E. User-Defined Export Format
  a-form.p (TRUE)   - F. Form Definitions for Query
  a-lang.p          - G. Language
  n/a               - H. How to Exit Application
  a-label.p         - L. Label Field Selection
  a-perm.p ("m")    - M. Module Permissions
  a-print.p         - P. Printer Setup
  a-perm.p ("q")    - Q. Query Permissions
  a-join.p          - R. Relations Between Files
  a-user.p ("s")    - S. Sign-on Program/Product Name
  a-color.p         - T. Terminal Color Settings
  a-user.p ("u")    - U. User Option
*/

/*
abcdefghijklmnopqrstuvwxyz
a----f-----------r-------- Files
------g--------p---t------ Configuration
--c----h----m---q-s------- Security
-b-de------l--------u----- Modules
--------ijk--no------vwxyz *available*
*/

{ prores/t-set.i &mod=a &set=4 }
HIDE MESSAGE NO-PAUSE.
/*Loading additional administration settings from configuration file.*/
MESSAGE qbf-lang[28].
RUN prores/a-read.p.
HIDE MESSAGE NO-PAUSE.

FORM SKIP(1)
  qbf-lang[22] FORMAT "x(20)" SPACE(18) /*"Files:"*/
  qbf-lang[23] FORMAT "x(20)" SKIP      /*"Configuration:"*/
  SPACE(2) qbf-lang[ 1] FORMAT "x(33)"
  SPACE(5) qbf-lang[11] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 2] FORMAT "x(33)"
  SPACE(5) qbf-lang[12] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 3] FORMAT "x(33)"
  SPACE(5) qbf-lang[13] FORMAT "x(33)" SKIP(1)
  qbf-lang[24] FORMAT "x(20)" SPACE(18) /*"Security:"*/
  qbf-lang[25] FORMAT "x(20)" SKIP      /*"Modules:"*/
  SPACE(2) qbf-lang[ 4] FORMAT "x(33)"
  SPACE(5) qbf-lang[14] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 5] FORMAT "x(33)"
  SPACE(5) qbf-lang[15] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 6] FORMAT "x(33)"
  SPACE(5) qbf-lang[16] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 7] FORMAT "x(33)"
  SPACE(5) qbf-lang[17] FORMAT "x(33)" SKIP
  SPACE(2) qbf-lang[ 8] FORMAT "x(33)"
  SPACE(5) qbf-lang[18] FORMAT "x(33)" SKIP(1)
  WITH FRAME root ROW 1 COLUMN 1 WIDTH 80 ATTR-SPACE NO-LABELS
  TITLE COLOR VALUE(qbf-mlo) " " + qbf-lang[26] + " ". /*Administration*/
COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

{ prores/a-fast.i }

DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:

  PAUSE 0.
  { prores/t-set.i &mod=a &set=4 }
  DISPLAY qbf-lang[1 FOR 8] qbf-lang[11 FOR 8] qbf-lang[22 FOR 4]
    WITH FRAME root.
  HIDE FRAME qbf-shadow NO-PAUSE.
  /*Select an option or press [END-ERROR] to exit and save changes.*/
  STATUS DEFAULT qbf-lang[21].
  ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.
  ASSIGN
    qbf-c      = " " + qbf-lang[27] + " " + qbf-vers + " " /*Version*/
    qbf-module = "a"
    qbf#       = 21.
  PUT SCREEN ROW 15 COLUMN 3 COLOR VALUE(qbf-mhi) " " + qbf-product + " ".
  PUT SCREEN ROW 15 COLUMN 79 - LENGTH(qbf-c) COLOR VALUE(qbf-mhi) qbf-c.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    CHOOSE FIELD qbf-lang[1 FOR 8] qbf-lang[11 FOR 8]
      COLOR VALUE(qbf-mhi) AUTO-RETURN GO-ON("F2" "CTRL-W") WITH FRAME root.
    qbf# = FRAME-INDEX.
  END.
  ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
  STATUS DEFAULT.

  IF KEYFUNCTION(LASTKEY) = "HELP" THEN DO:
    qbf# = 0.
    RUN prores/applhelp.p.
  END.

  IF qbf# >= 1 AND qbf# <= 20 AND qbf-lang[qbf#] <> "" THEN DO:
    ASSIGN
      qbf-c      = SUBSTRING(FRAME-VALUE,4) + " "
      qbf-module = "a" + STRING(qbf#) /*+ "s"*/ .
    VIEW FRAME qbf-shadow.
    PAUSE 0.
  END.

  /*--------------------------------------------------- Application Rebuild */
  IF qbf# = 1 THEN DO:
    qbf-a = FALSE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#29").
    /*Are you sure you want to rebuild the application?*/
    IF qbf-a THEN 
      RUN prores/b-again.p (FALSE).
  END.
  ELSE
  /*-------------------------------------------- Form Definitions for Query */
  IF qbf# = 2 THEN
    RUN prores/a-form.p (TRUE).
  ELSE
  /*----------------------------------------------- Relations Between Files */
  IF qbf# = 3 THEN
    RUN prores/a-join.p.
  ELSE
  /*------------------------------------------ Contents of a User Directory */
  IF qbf# = 4 THEN
    RUN prores/a-info.p.
  ELSE
  /*----------------------------------------------- How to Exit Application */
  IF qbf# = 5 THEN DO:
    qbf-a = qbf-goodbye.
    /*QUIT and RETURN are the PROGRESS keywords and cannot be translated*/
    /*When the user leaves the main menu, should this program Quit or Return?*/
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,"QUIT","RETURN","#30").
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN 
      qbf-goodbye = qbf-a.
  END.
  ELSE
  /*---------------------------------------------------- Module Permissions */
  IF qbf# = 6 THEN
    RUN prores/a-perm.p ("m").
  ELSE
  /*----------------------------------------------------- Query Permissions */
  IF qbf# = 7 THEN
    RUN prores/a-perm.p ("q").
  ELSE
  /*------------------------------------------ Sign-on Program/Product Name */
  IF qbf# = 8 THEN DO:
    RUN prores/a-user.p ("s").
    HIDE FRAME root NO-PAUSE. /* refresh in case product name changed */
  END.
  ELSE
  /*-------------------------------------------------------------- Language */
  IF qbf# = 11 THEN DO:
    RUN prores/a-lang.p.
    HIDE FRAME root NO-PAUSE. /* refresh in case language changed */
  END.
  ELSE
  /*--------------------------------------------------------- Printer Setup */
  IF qbf# = 12 THEN
    RUN prores/a-print.p.
  ELSE
  /*----------------------------------------------- Terminal Color Settings */
  IF qbf# = 13 THEN DO:
    RUN prores/a-color.p.
    HIDE FRAME root NO-PAUSE. /* refresh in case colors changed */
  END.
  ELSE
  /*---------------------------------------------- Browse Program for Query */
  IF qbf# = 14 THEN
    RUN prores/a-user.p ("b").
  ELSE
  /*------------------------------------------------ Default Report Options */
  IF qbf# = 15 THEN
    RUN prores/r-set.p (FALSE).
  ELSE
  /*-------------------------------------------- User-Defined Export Format */
  IF qbf# = 16 THEN
    RUN prores/a-user.p ("e").
  ELSE
  /*------------------------------------------------- Label Field Selection */
  IF qbf# = 17 THEN
    RUN prores/a-label.p.
  ELSE
  /*----------------------------------------------------------- User Option */
  IF qbf# = 18 THEN
    RUN prores/a-user.p ("u").
  ELSE
  /*------------------------------------------------------------------ Exit */
  IF qbf# = 21 THEN DO:
    qbf-a = FALSE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#31").
    /*Are you sure that you want to leave the Administration menu now?*/
    IF qbf-a THEN LEAVE.
  END.

END.

HIDE FRAME qbf-shadow NO-PAUSE.
HIDE FRAME root       NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
/*Verifying configuration file structure and saving any changes.*/
MESSAGE qbf-lang[32].
RUN prores/a-fast.p (OUTPUT qbf-c).
RUN prores/a-write.p. /* write out all changes at once */
DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
  COMPILE VALUE(ENTRY(qbf-i,qbf-c)) SAVE ATTR-SPACE.
END.
RUN prores/a-zap.p (qbf-c).
HIDE ALL NO-PAUSE.

ASSIGN
  qbf-signon = ? /* force recache */
  qbf-module = ?.
RETURN.
