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
/* r-layout.p - set report dimensions */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL INITIAL FALSE NO-UNDO. /* changed? */

/*--------------------------------------------------------------------------*/
/*
              ^                                           ^
             ___ lines before header                      |
           ___v_______________________________________    |
          | report header                             |   |
   left   |___________________________________________|   |
  margin      ^                                           |
|---___---|  ___ lines between header and body            |
           ___v_______________________________________    |
          |                               ___         |   |
          | xxxxxxxx  spaces   xxxxxxxx  / ^          |   |  total
          | --------  between  -------- /  |  line    |  ___ page
          | xxxxxxxx  columns  xxxxxxxx<  ___ spacing |   |  length
          | xxxxxxxx<---___--->xxxxxxxx \  |          |   |
          | xxxxxxxx           xxxxxxxx  \_v_         |   |
          |___________________________________________|   |
              ^                                           |
             ___ lines between body and footer            |
           ___v_______________________________________    |
          | report footer                             |   |
          |___________________________________________|   v
*/
/*--------------------------------------------------------------------------*/

DEFINE VARIABLE hdl    AS HANDLE    NO-UNDO. 
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. 
DEFINE VARIABLE qbf-l  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE fldwid AS INTEGER   NO-UNDO. /* width of fields w/o spacing */ 

DEFINE VARIABLE qbf-1 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-origin-vt */
DEFINE VARIABLE qbf-2 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-origin-hz */
DEFINE VARIABLE qbf-3 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-header-body */
DEFINE VARIABLE qbf-4 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-space-hz */
DEFINE VARIABLE qbf-5 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-space-vt */
DEFINE VARIABLE qbf-6 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-page-size */
DEFINE VARIABLE qbf-7 AS INTEGER   NO-UNDO. /* qbf-rsys.qbf-body-footer */

DEFINE IMAGE qbf-bo1 FILENAME "adeicon/l-both":u.
DEFINE IMAGE qbf-bo2 FILENAME "adeicon/l-both":u.
DEFINE IMAGE qbf-bo3 FILENAME "adeicon/l-both":u.
DEFINE IMAGE qbf-up1 FILENAME "adeicon/l-up":u.	/* up arrow */ 
DEFINE IMAGE qbf-dn1 FILENAME "adeicon/l-dn":u.	/* down arrow */
DEFINE IMAGE qbf-lf1 FILENAME "adeicon/r-lf":u.	/* left arrow */
DEFINE IMAGE qbf-rt1 FILENAME "adeicon/l-rt":u.	/* right arrow */
DEFINE IMAGE qbf-lf2 FILENAME "adeicon/r-lf":u.	/* left arrow */
DEFINE IMAGE qbf-rt2 FILENAME "adeicon/r-rt":u.	/* right arrow */
DEFINE IMAGE qbf-tw1 FILENAME "adeicon/l-tween":u.

DEFINE RECTANGLE qbf-r1 SIZE-CHAR 45 BY  2      /* report header */
  NO-FILL EDGE-PIXELS 3.
DEFINE RECTANGLE qbf-r2 SIZE-CHAR 45 BY  5      /* report body */
  NO-FILL EDGE-PIXELS 3.
DEFINE RECTANGLE qbf-r3 SIZE-CHAR 45 BY  2      /* report footer */
  NO-FILL EDGE-PIXELS 3.
DEFINE RECTANGLE qbf-r4 SIZE-PIXELS 30 BY  3    /* left column label */
  EDGE-PIXELS 3.
DEFINE RECTANGLE qbf-r5 SIZE-PIXELS 30 BY  3    /* right column label */
  EDGE-PIXELS 3.
DEFINE RECTANGLE qbf-r6 SIZE-PIXELS  3 BY 80    /* page length bar */
  EDGE-PIXELS 3.

DEFINE VARIABLE qbf-h AS CHARACTER EXTENT 14 NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT 12 NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.

/*--------------------------------------------------------------------------*/

/* this entire frame is re-layed-out below. */
FORM
  qbf-c  AT ROW 1 COLUMN 1 VIEW-AS TEXT FORMAT "x":u
  qbf-r1 AT ROW 1 COLUMN 1
  qbf-r2 AT ROW 1 COLUMN 1
  qbf-r3 AT ROW 1 COLUMN 1
  qbf-r4 AT ROW 1 COLUMN 1
  qbf-r5 AT ROW 1 COLUMN 1
  qbf-r6 AT ROW 1 COLUMN 1
  qbf-1  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-2  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-3  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL} 
  qbf-4  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL} 
  qbf-5  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL} 
  qbf-6  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL} 
  qbf-7  AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL} 
  qbf-bo1 AT ROW 1 COLUMN 1
  qbf-bo2 AT ROW 1 COLUMN 1
  qbf-bo3 AT ROW 1 COLUMN 1
  qbf-tw1 AT ROW 1 COLUMN 1	
  qbf-up1 AT ROW 1 COLUMN 1
  qbf-dn1 AT ROW 1 COLUMN 1							 
  qbf-lf1 AT ROW 1 COLUMN 1
  qbf-rt1 AT ROW 1 COLUMN 1
  qbf-lf2 AT ROW 1 COLUMN 1
  qbf-rt2 AT ROW 1 COLUMN 1							 
  qbf-h   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-t   AT ROW 1 COLUMN 1 VIEW-AS TEXT 

  &IF "{&WINDOW-SYSTEM}":u = "OSF/Motif":u &THEN
    SKIP(12)
  &ELSE
    SKIP(14)
  &ENDIF

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = NO
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  WITH FRAME qbf-dim SIDE-LABELS NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee
  TITLE "Custom Page" BGCOLOR 15 VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-dim OR CHOOSE OF qbf-help IN FRAME qbf-dim
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Report_Dimensions_Dlg_Box},?).

ON ALT-L OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-1 IN FRAME qbf-dim.

ON ALT-M OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-2 IN FRAME qbf-dim.

ON ALT-B OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-3 IN FRAME qbf-dim.

ON ALT-C OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-4 IN FRAME qbf-dim.

ON ALT-S OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-5 IN FRAME qbf-dim.

ON ALT-P OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-6 IN FRAME qbf-dim.

ON ALT-F OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-7 IN FRAME qbf-dim.

ON GO OF FRAME qbf-dim DO:
  ASSIGN
    qbf-1 = INPUT FRAME qbf-dim qbf-1
    qbf-2 = INPUT FRAME qbf-dim qbf-2
    qbf-3 = INPUT FRAME qbf-dim qbf-3
    qbf-4 = INPUT FRAME qbf-dim qbf-4
    qbf-5 = INPUT FRAME qbf-dim qbf-5
    qbf-6 = INPUT FRAME qbf-dim qbf-6
    qbf-7 = INPUT FRAME qbf-dim qbf-7.

  qbf-i = qbf-1 + qbf-3 + qbf-7 + 1.
  IF qbf-i > qbf-6 THEN 
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "warning":u, "ok":u,
      SUBSTITUTE("The total height of 'Lines Before Header,' 'Lines Between Header and Body' and 'Lines Between Body and Footer' exceeds the page size of &1.", 
      qbf-6)).

  IF qbf-2 = 0 OR qbf-5 = 0 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "error":u, "ok":u,
      "Left margin and line spacing cannot be less than 1.").
    RETURN NO-APPLY.
  END.

  qbf-i = (qbf-2 - 1) + ((qbf-rc# - 1) * qbf-4) + fldwid.

  IF qbf-i > 255 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "error":u, "ok":u,
      SUBSTITUTE('The total width of the left margin, spaces between columns, and the width of all report fields is &1, which exceeds the maximum of 255.^^Reduce the left margin, adjust field formats or delete some fields to reduce the overall report width by &2.',
      qbf-i, qbf-i - 255)).
    RETURN NO-APPLY.
  END.

  ASSIGN
    qbf-o = (qbf-rsys.qbf-origin-vt   <> qbf-1
          OR qbf-rsys.qbf-origin-hz   <> qbf-2
          OR qbf-rsys.qbf-header-body <> qbf-3
          OR qbf-rsys.qbf-space-hz    <> qbf-4
          OR qbf-rsys.qbf-space-vt    <> qbf-5
          OR qbf-rsys.qbf-page-size   <> qbf-6
          OR qbf-rsys.qbf-body-footer <> qbf-7)

    qbf-dirty                = qbf-dirty OR qbf-o
    qbf-redraw               = qbf-redraw OR qbf-o
    qbf-rsys.qbf-origin-vt   = qbf-1
    qbf-rsys.qbf-origin-hz   = qbf-2
    qbf-rsys.qbf-header-body = qbf-3
    qbf-rsys.qbf-space-hz    = qbf-4
    qbf-rsys.qbf-space-vt    = qbf-5
    qbf-rsys.qbf-page-size   = qbf-6
    qbf-rsys.qbf-body-footer = qbf-7.
END.

ON WINDOW-CLOSE OF FRAME qbf-dim
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.
         
ASSIGN   
  FRAME qbf-dim:THREE-D = SESSION:THREE-D
  qbf-h[ 1] = TRIM("&Lines Before Header":t32)            
  qbf-h[ 2] = TRIM("Lines Between Header and &Body":t32)
  qbf-h[ 3] = TRIM("Lines Between Body and &Footer":t32)
  qbf-h[ 4] = TRIM("Left":t10)
  qbf-h[ 5] = TRIM("&Margin":t10)
  qbf-h[ 6] = TRIM("Spaces":t10)
  qbf-h[ 7] = TRIM("Between":t10)
  qbf-h[ 8] = TRIM("&Columns":t10)
  qbf-h[ 9] = TRIM("Line":t10)
  qbf-h[10] = TRIM("&Spacing":t10)
  qbf-h[11] = "(":u + TRIM("Report Header Area":t32) + ")":u
  qbf-h[12] = "(":u + TRIM("Report Footer Area":t32) + ")":u
  qbf-h[13] = ("&Page":t10)
  qbf-h[14] = ("Length":t10)

  qbf-1     = qbf-rsys.qbf-origin-vt
  qbf-2     = qbf-rsys.qbf-origin-hz
  qbf-3     = qbf-rsys.qbf-header-body
  qbf-4     = qbf-rsys.qbf-space-hz
  qbf-5     = qbf-rsys.qbf-space-vt
  qbf-6     = qbf-rsys.qbf-page-size
  qbf-7     = qbf-rsys.qbf-body-footer
  fldwid    = qbf-rsys.qbf-width - (qbf-2 - 1) - ((qbf-rc# - 1) * qbf-4).

DO qbf-i = 1 TO EXTENT(qbf-h):
  IF LENGTH(qbf-h[qbf-i],"CHARACTER":u) = 0 THEN 
    qbf-h[qbf-i] = " ":u.
END.

/*--------------------------------------------------------------------------*/

ASSIGN
  qbf-r1:HEIGHT-PIXELS IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim 
                                        * 2
  qbf-r2:HEIGHT-PIXELS IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim 
                                        * 6 + 33
  qbf-r3:HEIGHT-PIXELS IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim 
                                        * 2

  qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim  = 
    &IF "{&WINDOW-SYSTEM}":u = "OSF/Motif":u &THEN
      qbf-c:WIDTH-PIXELS IN FRAME qbf-dim * 45
    &ELSE
      qbf-c:WIDTH-PIXELS IN FRAME qbf-dim * 26
    &ENDIF

  qbf-r2:WIDTH-PIXELS IN FRAME qbf-dim  = qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-r3:WIDTH-PIXELS IN FRAME qbf-dim  = qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim

  qbf-lf1:X IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim 
  qbf-2:X   IN FRAME qbf-dim = qbf-lf1:WIDTH-PIXELS IN FRAME qbf-dim + 8
  qbf-rt1:X IN FRAME qbf-dim = qbf-2:X IN FRAME qbf-dim
                             + qbf-2:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-r1:X IN FRAME qbf-dim  = qbf-rt1:X IN FRAME qbf-dim
                             + qbf-rt1:WIDTH-PIXELS IN FRAME qbf-dim - 3
  qbf-r1:Y IN FRAME qbf-dim  = qbf-bo1:HEIGHT-PIXELS IN FRAME qbf-dim - 3
                             + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-bo1:X IN FRAME qbf-dim = qbf-r1:X IN FRAME qbf-dim + 20
  qbf-bo1:Y IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim

  qbf-bo2:X IN FRAME qbf-dim = qbf-bo1:X IN FRAME qbf-dim
  qbf-bo2:Y IN FRAME qbf-dim = qbf-r1:Y IN FRAME qbf-dim
                             + qbf-r1:HEIGHT-PIXELS IN FRAME qbf-dim - 3

  qbf-i                      = qbf-bo2:Y IN FRAME qbf-dim
                             + qbf-bo2:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-lf1:Y IN FRAME qbf-dim = qbf-i 
                             - qbf-lf1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-rt1:Y IN FRAME qbf-dim = qbf-lf1:Y IN FRAME qbf-dim
  qbf-2:Y IN FRAME qbf-dim   = qbf-i - qbf-2:HEIGHT-PIXELS IN FRAME qbf-dim / 2

  qbf-r2:X IN FRAME qbf-dim  = qbf-r1:X IN FRAME qbf-dim
  qbf-r2:Y IN FRAME qbf-dim  = qbf-bo2:Y IN FRAME qbf-dim
                             + qbf-bo2:HEIGHT-PIXELS IN FRAME qbf-dim - 3

  qbf-bo3:X IN FRAME qbf-dim = qbf-bo1:X IN FRAME qbf-dim
  qbf-bo3:Y IN FRAME qbf-dim = qbf-r2:Y IN FRAME qbf-dim 
                             + qbf-r2:HEIGHT-PIXELS IN FRAME qbf-dim - 3

  qbf-r3:X IN FRAME qbf-dim  = qbf-r1:X IN FRAME qbf-dim 
  qbf-r3:Y IN FRAME qbf-dim  = qbf-bo3:Y IN FRAME qbf-dim
                             + qbf-bo3:HEIGHT-PIXELS IN FRAME qbf-dim - 3. 
   
ASSIGN
  qbf-i                      = qbf-bo1:X IN FRAME qbf-dim
                             + qbf-bo1:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-1:X IN FRAME qbf-dim   = qbf-i
  qbf-3:X IN FRAME qbf-dim   = qbf-i 
  qbf-7:X IN FRAME qbf-dim   = qbf-i

  qbf-i                      = qbf-bo1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-1:Y IN FRAME qbf-dim   = qbf-bo1:Y IN FRAME qbf-dim + qbf-i
  qbf-3:Y IN FRAME qbf-dim   = qbf-bo2:Y IN FRAME qbf-dim + qbf-i 
  qbf-7:Y IN FRAME qbf-dim   = qbf-bo3:Y IN FRAME qbf-dim + qbf-i

  qbf-h[1]:X IN FRAME qbf-dim = qbf-1:X IN FRAME qbf-dim
                              + qbf-1:WIDTH-PIXELS IN FRAME qbf-dim + 4
  qbf-h[2]:X IN FRAME qbf-dim = qbf-3:X IN FRAME qbf-dim
                              + qbf-3:WIDTH-PIXELS IN FRAME qbf-dim + 4 
  qbf-h[3]:X IN FRAME qbf-dim = qbf-7:X IN FRAME qbf-dim
                              + qbf-7:WIDTH-PIXELS IN FRAME qbf-dim + 4

  qbf-h[1]:Y IN FRAME qbf-dim = qbf-1:Y IN FRAME qbf-dim
                              + qbf-1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                              - qbf-h[1]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[2]:Y IN FRAME qbf-dim = qbf-3:Y IN FRAME qbf-dim
                              + qbf-3:HEIGHT-PIXELS IN FRAME qbf-dim / 2 
                              - qbf-h[2]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[3]:Y IN FRAME qbf-dim = qbf-7:Y IN FRAME qbf-dim
                              + qbf-7:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                              - qbf-h[3]:HEIGHT-PIXELS IN FRAME qbf-dim / 2

  qbf-h[1]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[1],"RAW":u) + 2) 
                                   + ")":u
  qbf-h[2]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[2],"RAW":u) + 2) 
                                   + ")":u
  qbf-h[3]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[3],"RAW":u) + 2) 
                                   + ")":u
  qbf-h[1]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[1]
  qbf-h[2]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[2]
  qbf-h[3]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[3]

  qbf-h[4]:X      IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-h[5]:X      IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-h[5]:Y      IN FRAME qbf-dim = qbf-2:Y IN FRAME qbf-dim
                                   - qbf-h[5]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[4]:Y      IN FRAME qbf-dim = qbf-h[5]:Y IN FRAME qbf-dim
                                   - qbf-h[4]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[4]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[4],"RAW":u)) 
                                   + ")":u
  qbf-h[5]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[5],"RAW":u)) 
                                   + ")":u
  qbf-h[4]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[4]
  qbf-h[5]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[5].
	 
ASSIGN
  qbf-i = 8
  qbf-c = "x(":u + STRING(qbf-i) + ")":u
  qbf-t[1]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 2]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 3]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 4]:FORMAT IN FRAME qbf-dim = qbf-c							 
  qbf-t[ 5]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 6]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 7]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 8]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[ 9]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[10]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[11]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-t[12]:FORMAT IN FRAME qbf-dim = qbf-c
  qbf-c = FILL("x":u,qbf-i)
  qbf-t[ 1]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 2]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 3]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 4]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 5]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 6]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 7]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 8]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[ 9]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[10]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[11]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c
  qbf-t[12]:SCREEN-VALUE IN FRAME qbf-dim  = qbf-c.

ASSIGN
  qbf-r4:WIDTH-PIXELS IN FRAME qbf-dim = qbf-t[1]:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-r5:WIDTH-PIXELS IN FRAME qbf-dim = qbf-t[1]:WIDTH-PIXELS IN FRAME qbf-dim

  qbf-t[ 1]:X IN FRAME qbf-dim  = qbf-r2:X IN FRAME qbf-dim + 7
  qbf-r4:X IN FRAME qbf-dim     = qbf-t[ 1]:X IN FRAME qbf-dim
  qbf-t[ 2]:X IN FRAME qbf-dim  = qbf-t[ 1]:X IN FRAME qbf-dim
  qbf-t[ 3]:X IN FRAME qbf-dim  = qbf-t[ 1]:X IN FRAME qbf-dim
  qbf-t[ 4]:X IN FRAME qbf-dim  = qbf-t[ 1]:X IN FRAME qbf-dim
  qbf-t[ 5]:X IN FRAME qbf-dim  = qbf-t[ 1]:X IN FRAME qbf-dim
  qbf-t[ 6]:X IN FRAME qbf-dim  = qbf-t[ 1]:X IN FRAME qbf-dim

  qbf-i = qbf-t[1]:HEIGHT-PIXELS IN FRAME qbf-dim + 2
  qbf-t[ 1]:Y IN FRAME qbf-dim  = qbf-r2:Y IN FRAME qbf-dim + 7
  qbf-r4:Y IN FRAME qbf-dim     = qbf-t[ 1]:Y IN FRAME qbf-dim + qbf-i + 3
  qbf-t[ 2]:Y IN FRAME qbf-dim  = qbf-t[ 1]:Y IN FRAME qbf-dim + qbf-i + 9
  qbf-t[ 3]:Y IN FRAME qbf-dim  = qbf-t[ 2]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[ 4]:Y IN FRAME qbf-dim  = qbf-t[ 3]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[ 5]:Y IN FRAME qbf-dim  = qbf-t[ 4]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[ 6]:Y IN FRAME qbf-dim  = qbf-t[ 5]:Y IN FRAME qbf-dim + qbf-i.

ASSIGN
  qbf-lf2:X IN FRAME qbf-dim = qbf-r4:X IN FRAME qbf-dim
                             + qbf-r4:WIDTH-PIXELS IN FRAME qbf-dim + 1
  qbf-4:X IN FRAME qbf-dim   = qbf-lf2:X IN FRAME qbf-dim
                             + qbf-lf2:WIDTH-PIXELS IN FRAME qbf-dim 
  qbf-rt2:X IN FRAME qbf-dim = qbf-4:X IN FRAME qbf-dim
                             + qbf-4:WIDTH-PIXELS IN FRAME qbf-dim

  qbf-lf2:Y IN FRAME qbf-dim = qbf-t[2]:Y IN FRAME qbf-dim
  qbf-rt2:Y IN FRAME qbf-dim = qbf-lf2:Y IN FRAME qbf-dim
  qbf-4:Y IN FRAME qbf-dim   = qbf-lf2:Y IN FRAME qbf-dim
                             + qbf-lf2:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-4:HEIGHT-PIXELS IN FRAME qbf-dim / 2

  qbf-t[ 7]:X IN FRAME qbf-dim  = qbf-rt2:X IN FRAME qbf-dim
                                + qbf-rt2:WIDTH-PIXELS IN FRAME qbf-dim + 1
  qbf-r5:X IN FRAME qbf-dim     = qbf-t[ 7]:X IN FRAME qbf-dim
  qbf-t[ 8]:X IN FRAME qbf-dim  = qbf-t[ 7]:X IN FRAME qbf-dim
  qbf-t[ 9]:X IN FRAME qbf-dim  = qbf-t[ 7]:X IN FRAME qbf-dim
  qbf-t[10]:X IN FRAME qbf-dim  = qbf-t[ 7]:X IN FRAME qbf-dim
  qbf-t[11]:X IN FRAME qbf-dim  = qbf-t[ 7]:X IN FRAME qbf-dim
  qbf-t[12]:X IN FRAME qbf-dim  = qbf-t[ 7]:X IN FRAME qbf-dim

  qbf-i = qbf-t[1]:HEIGHT-PIXELS IN FRAME qbf-dim + 2
  qbf-t[ 7]:Y IN FRAME qbf-dim  = qbf-r2:Y IN FRAME qbf-dim + 7
  qbf-r5:Y IN FRAME qbf-dim     = qbf-t[ 7]:Y IN FRAME qbf-dim + qbf-i + 3
  qbf-t[ 8]:Y IN FRAME qbf-dim  = qbf-t[ 7]:Y IN FRAME qbf-dim + qbf-i + 9
  qbf-t[ 9]:Y IN FRAME qbf-dim  = qbf-t[ 8]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[10]:Y IN FRAME qbf-dim  = qbf-t[ 9]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[11]:Y IN FRAME qbf-dim  = qbf-t[10]:Y IN FRAME qbf-dim + qbf-i
  qbf-t[12]:Y IN FRAME qbf-dim  = qbf-t[11]:Y IN FRAME qbf-dim + qbf-i


  qbf-h[6]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[6],"RAW":u)) 
                                   + ")":u
  qbf-h[7]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[7],"RAW":u)) 
                                   + ")":u
  qbf-h[8]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[8],"RAW":u)) 
                                   + ")":u
  qbf-h[6]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[6]
  qbf-h[7]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[7]
  qbf-h[8]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[8]
  qbf-i = MAXIMUM(
            qbf-h[6]:WIDTH-PIXELS IN FRAME qbf-dim,
            qbf-h[7]:WIDTH-PIXELS IN FRAME qbf-dim,
            qbf-h[8]:WIDTH-PIXELS IN FRAME qbf-dim
          )
  qbf-h[6]:Y IN FRAME qbf-dim = qbf-4:Y IN FRAME qbf-dim
                              + qbf-4:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[7]:Y IN FRAME qbf-dim = qbf-h[6]:Y IN FRAME qbf-dim
                              + qbf-h[6]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[8]:Y IN FRAME qbf-dim = qbf-h[7]:Y IN FRAME qbf-dim
                              + qbf-h[7]:HEIGHT-PIXELS IN FRAME qbf-dim

  qbf-i = MAXIMUM(
            qbf-lf2:X IN FRAME qbf-dim,
            qbf-4:X IN FRAME qbf-dim
            + qbf-4:WIDTH-PIXELS IN FRAME qbf-dim / 2 - qbf-i / 2
          )
  qbf-h[6]:X IN FRAME qbf-dim = qbf-i
  qbf-h[7]:X IN FRAME qbf-dim = qbf-i
  qbf-h[8]:X IN FRAME qbf-dim = qbf-i.

ASSIGN
  qbf-h[11]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[11],"RAW":u)) 
                                           + ")":u
  qbf-h[12]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[12],"RAW":u)) 
                                           + ")":u
  qbf-h[11]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[11]
  qbf-h[12]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[12]

  qbf-h[11]:X IN FRAME qbf-dim = qbf-r1:X IN FRAME qbf-dim
                               + qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim / 2
                               - qbf-h[11]:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-h[12]:X IN FRAME qbf-dim = qbf-r3:X IN FRAME qbf-dim
                               + qbf-r3:WIDTH-PIXELS IN FRAME qbf-dim / 2
                               - qbf-h[12]:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-h[11]:Y IN FRAME qbf-dim = qbf-r1:Y IN FRAME qbf-dim
                               + qbf-r1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                               - qbf-h[11]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[12]:Y IN FRAME qbf-dim = qbf-r3:Y IN FRAME qbf-dim
                               + qbf-r3:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                               - qbf-h[12]:HEIGHT-PIXELS IN FRAME qbf-dim / 2.

ASSIGN
  qbf-h[ 9]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[ 9],"RAW":u)) 
                                           + ")":u
  qbf-h[10]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[10],"RAW":u)) 
                                           + ")":u
  qbf-h[ 9]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[ 9]
  qbf-h[10]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[10]
  qbf-tw1:X IN FRAME qbf-dim   = qbf-r5:X IN FRAME qbf-dim
                               + qbf-r5:WIDTH-PIXELS IN FRAME qbf-dim + 1
  qbf-tw1:Y IN FRAME qbf-dim   = qbf-t[3]:Y IN FRAME qbf-dim / 2
                               + qbf-t[3]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                               + qbf-t[2]:Y IN FRAME qbf-dim / 2
                               - qbf-tw1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-5:X IN FRAME qbf-dim     = qbf-tw1:X IN FRAME qbf-dim
                               + qbf-tw1:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-5:Y IN FRAME qbf-dim     = qbf-tw1:Y IN FRAME qbf-dim
                               + qbf-tw1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                               - qbf-5:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[ 9]:X IN FRAME qbf-dim = qbf-5:X IN FRAME qbf-dim + 4
  qbf-h[10]:X IN FRAME qbf-dim = qbf-h[9]:X IN FRAME qbf-dim
  qbf-h[ 9]:Y IN FRAME qbf-dim = qbf-5:Y IN FRAME qbf-dim
                               + qbf-5:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[10]:Y IN FRAME qbf-dim = qbf-h[9]:Y IN FRAME qbf-dim
                               + qbf-h[9]:HEIGHT-PIXELS IN FRAME qbf-dim
  .
ASSIGN
  qbf-up1:Y IN FRAME qbf-dim     = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-up1:X IN FRAME qbf-dim     = qbf-r1:X IN FRAME qbf-dim
                                 + qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim + 20
  qbf-dn1:Y IN FRAME qbf-dim     = qbf-r3:Y IN FRAME qbf-dim
                                 + qbf-r3:HEIGHT-PIXELS IN FRAME qbf-dim + 3
                                 - qbf-dn1:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-dn1:X IN FRAME qbf-dim     = qbf-up1:X IN FRAME qbf-dim
  qbf-r6:X  IN FRAME qbf-dim     = qbf-up1:X IN FRAME qbf-dim + 12
  qbf-r6:Y  IN FRAME qbf-dim     = qbf-up1:HEIGHT-PIXELS IN FRAME qbf-dim
                                 + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-r6:HEIGHT-PIXELS IN FRAME qbf-dim = qbf-dn1:Y IN FRAME qbf-dim
                                 - qbf-up1:Y IN FRAME qbf-dim
                                 - qbf-up1:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-r4:BGCOLOR IN FRAME qbf-dim = 0
  qbf-r5:BGCOLOR IN FRAME qbf-dim = 0
  qbf-r6:BGCOLOR IN FRAME qbf-dim = 0

  qbf-6:X IN FRAME qbf-dim       = qbf-r6:X IN FRAME qbf-dim
                                 + qbf-r6:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                 - qbf-6:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-6:Y IN FRAME qbf-dim       = qbf-r6:Y IN FRAME qbf-dim
                                 + qbf-r6:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                                 - qbf-6:HEIGHT-PIXELS IN FRAME qbf-dim / 2

  qbf-h[13]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[13],"RAW":u)) 
                                           + ")":u
  qbf-h[14]:FORMAT IN FRAME qbf-dim        = "x(":u 
                                           + STRING(LENGTH(qbf-h[14],"RAW":u)) 
                                           + ")":u
  qbf-h[13]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[13]
  qbf-h[14]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[14]
  qbf-h[13]:X IN FRAME qbf-dim   = qbf-6:X IN FRAME qbf-dim
                                 + qbf-6:WIDTH-PIXELS IN FRAME qbf-dim + 4
  qbf-h[14]:X IN FRAME qbf-dim   = qbf-h[13]:X IN FRAME qbf-dim

  qbf-h[14]:Y IN FRAME qbf-dim = qbf-6:Y IN FRAME qbf-dim
                               + qbf-6:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[13]:Y IN FRAME qbf-dim = qbf-h[14]:Y IN FRAME qbf-dim
                               - qbf-h[14]:HEIGHT-PIXELS IN FRAME qbf-dim

  FRAME qbf-dim:WIDTH-PIXELS   = qbf-h[13]:X IN FRAME qbf-dim
                               + qbf-h[13]:WIDTH-PIXELS IN FRAME qbf-dim + 19

  qbf-h[ 1]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 1]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 2]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 2]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 3]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 3]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 4]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 4]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 5]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 5]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 6]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 6]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 7]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 7]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 8]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 8]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[ 9]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[ 9]:SCREEN-VALUE IN FRAME qbf-dim,0)
  qbf-h[10]:WIDTH IN FRAME qbf-dim = 
    FONT-TABLE:GET-TEXT-WIDTH(qbf-h[10]:SCREEN-VALUE IN FRAME qbf-dim,0)
  .

/*--------------------------------------------------------------------------*/

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-dim" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

DISPLAY qbf-1 qbf-2 qbf-3 qbf-4 qbf-5 qbf-6 qbf-7 
  WITH FRAME qbf-dim.
  
ENABLE qbf-1 qbf-2 qbf-3 qbf-4 qbf-5 qbf-6 qbf-7 qbf-ok qbf-ee qbf-Help
  WITH FRAME qbf-dim.

APPLY "ENTRY":u TO qbf-1 IN FRAME qbf-dim.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-dim.
END.

HIDE FRAME qbf-dim NO-PAUSE.
RETURN.

/* r-layout.p - end of file */

