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
 * y-page.p - Moves between print preview pages
 */

{ aderes/s-system.i }
{ aderes/y-define.i }
{ aderes/s-output.i }

{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/_fdefs.i   }
{ adeshar/_mnudefs.i }
{ aderes/reshlp.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* file name */
DEFINE INPUT PARAMETER qbf-s AS INTEGER   NO-UNDO. /* # pages */

/*
+-------+ +------+ +-------+ +------+ +------+ +------+ +-------+ +------+
| Print | | Page | | First | | Prev | | Next | | Last | | Close | | Help |
+-------+ +------+ +-------+ +------+ +------+ +------+ +-------+ +------+
*/

DEFINE VARIABLE iFields   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-a     AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-x     AS INTEGER   NO-UNDO. /* width */
DEFINE VARIABLE qbf-y     AS INTEGER   NO-UNDO. /* height */

IF SEARCH(qbf-f) = ? THEN RETURN. /* file not found */

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.
FIND FIRST qbf-lsys.

INPUT FROM VALUE(qbf-f) NO-ECHO.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IMPORT UNFORMATTED qbf-c.
END.
IF SEEK(INPUT) = ? THEN RETURN. /* empty file or already at eof */
INPUT CLOSE.

IF qbf-s >= EXTENT(qbf-wsys.qbf-wseek) THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "warning":u, "ok":u,
    SUBSTITUTE('Too many pages in the report to preview.  You can only preview up to &1 pages.  To view the entire report, choose the Print icon to output the report to a printer.',
    EXTENT(qbf-wsys.qbf-wseek))).

CREATE qbf-wsys.
ASSIGN
  qbf-x = (IF qbf-module = "r":u THEN
            qbf-rsys.qbf-width
          ELSE IF qbf-module = "l":u THEN
            qbf-lsys.qbf-origin-hz - 1
            + qbf-lsys.qbf-space-hz * (qbf-lsys.qbf-across - 1)
            + qbf-lsys.qbf-label-wd * qbf-lsys.qbf-across
          ELSE
            80
          )
  qbf-y = (IF qbf-module = "r":u THEN
            qbf-rsys.qbf-page-size
          ELSE
            DEFAULT-WINDOW:MAX-HEIGHT-CHARS
          )
  qbf-wsys.qbf-wfile = qbf-f
  qbf-wsys.qbf-wlast = MINIMUM(qbf-s, EXTENT(qbf-wsys.qbf-wseek))
  qbf-wsys.qbf-wsize = qbf-rsys.qbf-page-size
  qbf-preview        = qbf-preview + 1
  .

CREATE WINDOW qbf-wsys.qbf-wwin
  ASSIGN
    TITLE          = "Print Preview: " + STRING(qbf-preview)
                   + (IF qbf-name = "" THEN "" 
                      ELSE " - [":u + qbf-name + "]":u)
    MESSAGE-AREA   = FALSE
    STATUS-AREA    = FALSE
    MIN-WIDTH      = {&MIN_WIN_WIDTH}
    MIN-HEIGHT     = {&MIN_WIN_HEIGHT}
    SCROLL-BARS    = FALSE
    RESIZE         = TRUE
    THREE-D        = ("{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u AND qbf-threed)
    .

ASSIGN
  qbf-wsys.qbf-wwin:HEIGHT         = {&DEF_WIN_HEIGHT}
  qbf-wsys.qbf-wwin:WIDTH          = def-win-wid
  qbf-wsys.qbf-wwin:VIRTUAL-WIDTH  = SESSION:WIDTH
  qbf-wsys.qbf-wwin:VIRTUAL-HEIGHT = SESSION:HEIGHT
  NO-ERROR.

/* You can only do this after the window is visible */
ASSIGN
 qbf-wsys.qbf-wwin:MAX-WIDTH  = qbf-win:FULL-WIDTH
 qbf-wsys.qbf-wwin:MAX-HEIGHT = qbf-win:FULL-HEIGHT
 NO-ERROR.

RUN adecomm/_status.p (qbf-wsys.qbf-wwin,"50,20":u,TRUE,4, 
                       OUTPUT qbf-wsys.wStatus,OUTPUT iFields). 

/* close of window */
ON WINDOW-CLOSE OF qbf-wsys.qbf-wwin
  OR END-ERROR OF qbf-wsys.qbf-wwin PERSISTENT
  RUN aderes/y-page2.p ("c":u, qbf-wsys.qbf-wwin, qbf-s).

CREATE FRAME qbf-wsys.qbf-wfrm
  ASSIGN
    BOX            = FALSE
    OVERLAY        = TRUE
    PARENT         = qbf-wsys.qbf-wwin
    X              = 0
    Y              = 0
    HEIGHT-PIXELS  = qbf-wsys.qbf-wwin:HEIGHT-PIXELS
                     - qbf-wsys.wStatus:HEIGHT-PIXELS
    WIDTH-PIXELS   = qbf-wsys.qbf-wwin:WIDTH-PIXELS
    VISIBLE        = FALSE
    SCROLLABLE     = TRUE /* dma */
    THREE-D        = ("{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u AND qbf-threed)
    .

/* Create print button */
RUN create_button (1).
RUN load_image (1,"adeicon/pvprint":u,"adeicon/pvprintd":u,"").

/* Create pages button */
RUN create_button (2).
RUN load_image (2,"adeicon/pvpage":u,"adeicon/pvpaged":u,"adeicon/pvpagex":u).

/* Create first page button */
RUN create_button (3).
RUN load_image (3,"adeicon/pvfirst":u,"adeicon/pvfirstd":u,"adeicon/pvfirstx":u).

/* Create previous page button */
RUN create_button (4).
RUN load_image (4,"adeicon/pvback":u,"adeicon/pvbackd":u,"adeicon/pvbackx":u).

/* Create next page button */
RUN create_button (5).
RUN load_image (5,"adeicon/pvforw":u,"adeicon/pvforwd":u,"adeicon/pvforwx":u).

/* Create last page button */
RUN create_button (6).
RUN load_image (6,"adeicon/pvlast":u,"adeicon/pvlastd":u,"adeicon/pvlastx":u).

/* Create close button */
RUN create_button (7).
RUN load_image (7,"adeicon/pvstop":u,"adeicon/pvstopd":u,"").

/* Create help button */
RUN create_button (8).
RUN load_image (8,"adeicon/pvmark":u,"adeicon/pvmarkd":u,"").

qbf-i = qbf-wsys.qbf-wbut[1]:HEIGHT-PIXELS 
      + qbf-wsys.qbf-wbut[1]:Y + 4.

CREATE EDITOR qbf-wsys.qbf-wedi
  ASSIGN
    X                    = 0
    Y                    = qbf-i
    AUTO-RESIZE          = TRUE
    WORD-WRAP            = FALSE
    SCROLLBAR-HORIZONTAL = TRUE
    SCROLLBAR-VERTICAL   = TRUE
    WIDTH-PIXELS         = qbf-wsys.qbf-wfrm:WIDTH-PIXELS 
    HEIGHT-PIXELS        = qbf-wsys.qbf-wfrm:HEIGHT-PIXELS - qbf-i 
    FRAME                = qbf-wsys.qbf-wfrm
    READ-ONLY            = TRUE
    VISIBLE              = FALSE
    SENSITIVE            = TRUE
    FONT                 = 0.

/*--------------------------------------------------------------------------*/

/* print button */
ON CHOOSE OF qbf-wsys.qbf-wbut[1] PERSISTENT
  RUN aderes/y-page2.p ("*":u, qbf-wsys.qbf-wwin, qbf-s).

/* goto page # */
ON CHOOSE OF qbf-wsys.qbf-wbut[2] PERSISTENT
  RUN aderes/y-page2.p ("#":u, qbf-wsys.qbf-wwin, qbf-s).

/* first page */
ON CHOOSE OF qbf-wsys.qbf-wbut[3] PERSISTENT
  RUN aderes/y-page2.p ("f":u, qbf-wsys.qbf-wwin, qbf-s).

/* prev page */
ON CHOOSE OF qbf-wsys.qbf-wbut[4] PERSISTENT
  RUN aderes/y-page2.p ("p":u, qbf-wsys.qbf-wwin, qbf-s).

/* next page */
ON CHOOSE OF qbf-wsys.qbf-wbut[5] PERSISTENT
  RUN aderes/y-page2.p ("n":u, qbf-wsys.qbf-wwin, qbf-s).

/* last button */
ON CHOOSE OF qbf-wsys.qbf-wbut[6] PERSISTENT
  RUN aderes/y-page2.p ("l":u, qbf-wsys.qbf-wwin, qbf-s).

/* close button */
ON CHOOSE OF qbf-wsys.qbf-wbut[7] PERSISTENT
  RUN aderes/y-page2.p ("c":u, qbf-wsys.qbf-wwin, qbf-s).

/* help button */
ON HELP OF qbf-wsys.qbf-wfrm 
  OR CHOOSE OF qbf-wsys.qbf-wbut[8] PERSISTENT 
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Print_Preview_Window},?).

/* window-resized */
ON WINDOW-RESIZED OF qbf-wsys.qbf-wwin PERSISTENT
  RUN aderes/y-page2.p ("w":u, qbf-wsys.qbf-wwin, qbf-s).

/*--------------------------------------------------------------------------*/

ASSIGN
  qbf-wseek                      = ?
  qbf-wseek[1]                   = 0
  qbf-wsys.qbf-wbut[1]:HIDDEN    = FALSE 
  qbf-wsys.qbf-wbut[2]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[3]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[4]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[5]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[6]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[7]:HIDDEN    = FALSE
  qbf-wsys.qbf-wbut[8]:HIDDEN    = FALSE

  qbf-wsys.qbf-wedi:HIDDEN       = FALSE
  qbf-wsys.wStatus:SENSITIVE     = TRUE
  qbf-wsys.wStatus:HIDDEN        = FALSE
  qbf-wsys.wStatus:SCROLLABLE    = TRUE
  qbf-wsys.qbf-wfrm:VISIBLE      = TRUE.

/*------------ 
   See comment in y-page2.p (search from qbf1.d) for why this is 
   commented out.
IF qbf-wsys.qbf-wfile = "qbf1.d":u THEN
  INPUT STREAM qbf-wio FROM VALUE(qbf-f) NO-ECHO.
--------------*/

RUN aderes/y-page2.p ("f":u, qbf-wsys.qbf-wwin, qbf-s). /* first page */

APPLY "ENTRY":u to qbf-wsys.qbf-wbut[7].
RETURN.

/*--------------------------------------------------------------------------*/
PROCEDURE create_button:
  DEFINE INPUT  PARAMETER qbf-j AS INTEGER   NO-UNDO. /* button # */

  CREATE BUTTON qbf-wsys.qbf-wbut[qbf-j]
    ASSIGN
      FRAME          = qbf-wsys.qbf-wfrm
      AUTO-RESIZE    = TRUE
      X              = IF qbf-j = 1 THEN 4
                       ELSE qbf-wbut[qbf-j - 1]:X 
                          + qbf-wbut[qbf-j - 1]:WIDTH-PIXELS + 2
      Y              = 4
      HEIGHT-PIXELS  = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN 25 ELSE 26
      WIDTH-PIXELS   = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN 33 ELSE 34
      BGCOLOR        = 8
      VISIBLE        = FALSE
      SENSITIVE      = TRUE.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE load_image:
  DEFINE INPUT  PARAMETER qbf-j AS INTEGER   NO-UNDO. /* button # */
  DEFINE INPUT  PARAMETER qbf-u AS CHARACTER NO-UNDO. /* up */
  DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* down */
  DEFINE INPUT  PARAMETER qbf-i AS CHARACTER NO-UNDO. /* insensitive */

  ASSIGN
    qbf-a = qbf-wsys.qbf-wbut[qbf-j]:LOAD-IMAGE-UP(qbf-u)
    qbf-a = qbf-wsys.qbf-wbut[qbf-j]:LOAD-IMAGE-INSENSITIVE(qbf-i)
    .
  IF qbf-d > "" THEN
    qbf-a = qbf-wsys.qbf-wbut[qbf-j]:LOAD-IMAGE-DOWN(qbf-d).
END PROCEDURE.

/* y-page.p - end of file */

