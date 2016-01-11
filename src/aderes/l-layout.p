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
/* l-layout.p - set label dimensions */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/l-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL NO-UNDO. /* changed? */

/*--------------------------------------------------------------------------*/
/*
left margin                label width                  number across
|---___---|--------------------___--------------------|           ___

     ---  +-------------------------------------------+         +----
   h  |   |                                           |         |
   e  |   |                                           | spaces  |
   i  |   |                                           | between |
   g ___  |                                           |---___---|
   h  |   |                                           |         |
   t  |   |                                           |         |
      |   |                                           |         |
     ---  +-------------------------------------------+         +----
                               |
                               |
___ copies of each            ___ lines between
                               |
                               |
          +-------------------------------------------+
          |                                           |
*/
/*--------------------------------------------------------------------------*/

DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l   AS LOGICAL   NO-UNDO. /* scrap */

DEFINE VARIABLE qbf-1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-2   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-3   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-4   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-5   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-6   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-7   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-8   AS INTEGER   NO-UNDO.

DEFINE IMAGE qbf-up1 FILENAME "adeicon/l-up":u.
DEFINE IMAGE qbf-up2 FILENAME "adeicon/l-up":u.
DEFINE IMAGE qbf-dn1 FILENAME "adeicon/l-dn":u.
DEFINE IMAGE qbf-dn2 FILENAME "adeicon/l-dn":u.
DEFINE IMAGE qbf-lf1 FILENAME "adeicon/l-lf":u.
DEFINE IMAGE qbf-lf2 FILENAME "adeicon/l-lf":u.
DEFINE IMAGE qbf-lf3 FILENAME "adeicon/l-lf":u.
DEFINE IMAGE qbf-rt1 FILENAME "adeicon/l-rt":u.
DEFINE IMAGE qbf-rt2 FILENAME "adeicon/l-rt":u.
DEFINE IMAGE qbf-rt3 FILENAME "adeicon/l-rt":u.
DEFINE IMAGE qbf-yes FILENAME "adeicon/l-yes":u.
DEFINE IMAGE qbf-no  FILENAME "adeicon/l-no":u.

DEFINE RECTANGLE qbf-r1 SIZE-PIXELS 40 BY  3. /* width dim bar */
DEFINE RECTANGLE qbf-r2 SIZE-PIXELS  3 BY 40. /* height dim bar */
DEFINE RECTANGLE qbf-r3 SIZE-PIXELS  3 BY 40. /* label right -vertical bar */
DEFINE RECTANGLE qbf-r4 SIZE-PIXELS 30 BY  3. /* label right -top horizontal bar */
DEFINE RECTANGLE qbf-r5 SIZE-PIXELS 30 BY  3. /* label right -btm horizontal bar */
DEFINE RECTANGLE qbf-o2 SIZE-PIXELS 40 BY  3. /* label below -horizontal bar */
DEFINE RECTANGLE qbf-o3 SIZE-PIXELS  3 BY 30. /* label below -lf vertical bar */
DEFINE RECTANGLE qbf-o4 SIZE-PIXELS  3 BY 30. /* label below -rt vertical bar */
DEFINE RECTANGLE qbf-o1 SIZE-CHAR   50 BY  6  /* label simulation outline */
  EDGE-PIXELS 3 FGCOLOR 0 NO-FILL.

DEFINE VARIABLE qbf-h AS CHARACTER EXTENT 7 NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER EXTENT 8 NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.

/*--------------------------------------------------------------------------*/

/* this entire frame is re-layed-out below. */
FORM
  qbf-c AT ROW 1 COLUMN 1 VIEW-AS TEXT           FORMAT "x":u
  qbf-1 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-2 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-3 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-4 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-5 AT ROW 1 COLUMN 1 VIEW-AS TOGGLE-BOX LABEL "&Omit Blank Lines"
  qbf-6 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-7 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-8 AT ROW 1 COLUMN 1 VIEW-AS FILL-IN FORMAT ">>9":u {&STDPH_FILL}
  qbf-up1 AT ROW 1 COLUMN 1 
  qbf-up2 AT ROW 1 COLUMN 1 
  qbf-dn1 AT ROW 1 COLUMN 1 
  qbf-dn2 AT ROW 1 COLUMN 1 
  qbf-lf1 AT ROW 1 COLUMN 1 
  qbf-lf2 AT ROW 1 COLUMN 1 
  qbf-lf3 AT ROW 1 COLUMN 1 
  qbf-rt1 AT ROW 1 COLUMN 1 
  qbf-rt2 AT ROW 1 COLUMN 1 
  qbf-rt3 AT ROW 1 COLUMN 1 
  qbf-r1  AT ROW 1 COLUMN 1 
  qbf-r2  AT ROW 1 COLUMN 1 
  qbf-r3  AT ROW 1 COLUMN 1 
  qbf-r4  AT ROW 1 COLUMN 1 
  qbf-r5  AT ROW 1 COLUMN 1 
  qbf-o1  AT ROW 1 COLUMN 1 
  qbf-o2  AT ROW 1 COLUMN 1 
  qbf-o3  AT ROW 1 COLUMN 1 
  qbf-o4  AT ROW 1 COLUMN 1 
  qbf-h[1]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[2]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[3]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[4]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[5]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[6]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-h[7]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[1]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[2]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[3]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[4]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[5]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[6]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[7]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-v[8]   AT ROW 1 COLUMN 1 VIEW-AS TEXT
  qbf-yes AT ROW 1 COLUMN 1  

  SKIP (9)
  qbf-no AT 67

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  WITH FRAME qbf-dim SIDE-LABELS NO-LABELS SCROLLABLE THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Custom Label" BGCOLOR 15 VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON VALUE-CHANGED OF qbf-5 IN FRAME qbf-dim
  ASSIGN
    qbf-yes:VISIBLE IN FRAME qbf-dim = INPUT FRAME qbf-dim qbf-5
    qbf-no:VISIBLE  IN FRAME qbf-dim = NOT INPUT FRAME qbf-dim qbf-5.

ON ALT-M OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-1 IN FRAME qbf-dim.

ON ALT-W OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-2 IN FRAME qbf-dim.

ON ALT-A OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-3 IN FRAME qbf-dim.

ON ALT-E OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-4 IN FRAME qbf-dim.

ON ALT-O OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-5 IN FRAME qbf-dim.

ON ALT-S OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-6 IN FRAME qbf-dim.

ON ALT-C OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-7 IN FRAME qbf-dim.

ON ALT-L OF FRAME qbf-dim
  APPLY "ENTRY":u TO qbf-8 IN FRAME qbf-dim.

ON GO OF FRAME qbf-dim DO:
  ASSIGN
    qbf-1 = INPUT FRAME qbf-dim qbf-1
    qbf-2 = MAXIMUM(1,INPUT FRAME qbf-dim qbf-2)
    qbf-3 = MAXIMUM(1,INPUT FRAME qbf-dim qbf-3)
    qbf-4 = MAXIMUM(1,INPUT FRAME qbf-dim qbf-4)
    qbf-5 = INPUT FRAME qbf-dim qbf-5
    qbf-6 = INPUT FRAME qbf-dim qbf-6
    qbf-7 = MAXIMUM(1,INPUT FRAME qbf-dim qbf-7)
    qbf-8 = INPUT FRAME qbf-dim qbf-8.

  IF qbf-4 > EXTENT(qbf-l-text) THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "error":u, "ok":u, 
      SUBSTITUTE('You have entered a label height of &1, but the maximum is &2.  Please reduce the height value.', 
      qbf-4, EXTENT(qbf-l-text))).
    RETURN NO-APPLY.
  END.
 
  /* left margin + (# across * label width) +
     ((# across - 1) * spaces between) */
  qbf-i = qbf-1 + (qbf-3 * qbf-2) + ((qbf-3 - 1) * qbf-6).

  IF qbf-i > 255 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u, 
      SUBSTITUTE('The total width of the left margin, # labels across and spaces between labels is &1, which exceeds the maximum value of 255.  Please adjust these values to reduce the overall width.', 
      qbf-i)).
    RETURN NO-APPLY.
  END.
  
  ASSIGN
    qbf-o = (qbf-lsys.qbf-origin-hz <> qbf-1 
          OR qbf-lsys.qbf-label-wd  <> qbf-2
          OR qbf-lsys.qbf-across    <> qbf-3
          OR qbf-lsys.qbf-label-ht  <> qbf-4
          OR qbf-lsys.qbf-omit      <> qbf-5
          OR qbf-lsys.qbf-space-hz  <> qbf-6
          OR qbf-lsys.qbf-copies    <> qbf-7
          OR qbf-lsys.qbf-space-vt  <> qbf-8)
    qbf-dirty              = qbf-dirty OR qbf-o
    qbf-redraw             = qbf-o
    qbf-lsys.qbf-origin-hz = qbf-1
    qbf-lsys.qbf-label-wd  = qbf-2
    qbf-lsys.qbf-across    = qbf-3
    qbf-lsys.qbf-label-ht  = qbf-4
    qbf-lsys.qbf-omit      = qbf-5
    qbf-lsys.qbf-space-hz  = qbf-6
    qbf-lsys.qbf-copies    = qbf-7
    qbf-lsys.qbf-space-vt  = qbf-8
    .
END.

ON WINDOW-CLOSE OF FRAME qbf-dim
  APPLY "END-ERROR":u TO SELF.             

ON HELP OF FRAME qbf-dim OR CHOOSE OF qbf-help IN FRAME qbf-dim
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Label_Dimensions_Dlg_Box},?).
  
/*--------------------------------------------------------------------------*/

FIND FIRST qbf-lsys.

ASSIGN
  FRAME qbf-dim:THREE-D = SESSION:THREE-D
  
  qbf-h[1] = TRIM("Left &Margin")
  qbf-h[2] = TRIM("Label &Width")
  qbf-h[3] = TRIM("Number &Across")
  qbf-h[4] = TRIM("&Spaces")
  qbf-h[5] = TRIM("Between")
  qbf-h[6] = TRIM("&Copies of Each")
  qbf-h[7] = TRIM("&Lines Between")
  qbf-v[1] = "Height":c8

  qbf-1 = qbf-lsys.qbf-origin-hz
  qbf-2 = qbf-lsys.qbf-label-wd
  qbf-3 = qbf-lsys.qbf-across
  qbf-4 = qbf-lsys.qbf-label-ht
  qbf-5 = qbf-lsys.qbf-omit
  qbf-6 = qbf-lsys.qbf-space-hz
  qbf-7 = qbf-lsys.qbf-copies
  qbf-8 = qbf-lsys.qbf-space-vt
  .

/*--------------------------------------------------------------------------*/

ASSIGN
  qbf-h[1]:X      IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-h[1]:Y      IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim 
  qbf-h[1]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[1],"RAW":u)) 
                                   + ")":u
  qbf-h[1]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[1]

  qbf-i = MAXIMUM(qbf-lf1:HEIGHT-PIXELS IN FRAME qbf-dim,qbf-1:HEIGHT-PIXELS 
                                                         IN FRAME qbf-dim)

  qbf-lf1:X       IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-1:X         IN FRAME qbf-dim = qbf-lf1:WIDTH-PIXELS IN FRAME qbf-dim + 5
  qbf-rt1:X       IN FRAME qbf-dim = qbf-1:WIDTH-PIXELS IN FRAME qbf-dim
                                   + qbf-lf1:WIDTH-PIXELS IN FRAME qbf-dim 
  qbf-lf1:Y       IN FRAME qbf-dim = qbf-h[1]:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-i / 2
                                   - qbf-lf1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-rt1:Y       IN FRAME qbf-dim = qbf-h[1]:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-i / 2
                                   - qbf-rt1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-1:Y         IN FRAME qbf-dim = qbf-h[1]:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-i / 2
                                   - qbf-1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  .

ASSIGN
  qbf-o1:X IN FRAME qbf-dim        = qbf-rt1:X IN FRAME qbf-dim + 24
  qbf-o1:Y IN FRAME qbf-dim        = qbf-rt1:Y IN FRAME qbf-dim + 30

  qbf-lf2:X IN FRAME qbf-dim       = qbf-o1:X IN FRAME qbf-dim
  qbf-rt2:X IN FRAME qbf-dim       = qbf-o1:X IN FRAME qbf-dim
                                   + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim - 27

  qbf-lf2:Y IN FRAME qbf-dim       = qbf-lf1:Y IN FRAME qbf-dim
  qbf-rt2:Y IN FRAME qbf-dim       = qbf-rt1:Y IN FRAME qbf-dim

  qbf-r1:X IN FRAME qbf-dim        = qbf-lf2:X IN FRAME qbf-dim + 27
  qbf-r1:Y IN FRAME qbf-dim        = qbf-lf2:Y IN FRAME qbf-dim + 12
  qbf-r1:WIDTH-PIXELS IN FRAME qbf-dim = 
                                     qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim - 54

  qbf-2:Y IN FRAME qbf-dim         = qbf-h[1]:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-i / 2
                                   - qbf-2:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-2:X IN FRAME qbf-dim         = qbf-o1:X IN FRAME qbf-dim
                                   + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-2:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-h[2]:Y      IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[2]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[2],"RAW":u)) 
                                   + ")":u
  qbf-h[2]:SCREEN-VALUE IN FRAME qbf-dim = qbf-h[2]
  qbf-h[2]:X      IN FRAME qbf-dim = qbf-o1:X IN FRAME qbf-dim
                                   + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-h[2]:WIDTH-PIXELS IN FRAME qbf-dim / 2
  .
         
ASSIGN
  qbf-h[3]:Y      IN FRAME qbf-dim = qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[3]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[3],"RAW":u) + 1) 
                                   + ")":u
  qbf-h[3]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[3]
  qbf-h[3]:X      IN FRAME qbf-dim = qbf-o1:X IN FRAME qbf-dim
                                   + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim + 20

  qbf-3:Y IN FRAME qbf-dim         = qbf-h[3]:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-c:HEIGHT-PIXELS IN FRAME qbf-dim
                                   + qbf-i / 2
                                   - qbf-3:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  
  /* fix for 95-07-24-026 */
  FRAME qbf-dim:WIDTH              = MAXIMUM(FRAME qbf-dim:WIDTH,1 +
                                             qbf-h[3]:COL IN FRAME qbf-dim +
                                             qbf-h[3]:WIDTH IN FRAME qbf-dim +
                                             qbf-3:WIDTH IN FRAME qbf-dim)

  qbf-3:X IN FRAME qbf-dim         = qbf-h[3]:X IN FRAME qbf-dim
                                   + qbf-h[3]:WIDTH-PIXELS IN FRAME qbf-dim
                                   - qbf-3:WIDTH-PIXELS IN FRAME qbf-dim
  .
ASSIGN
  qbf-up1:X IN FRAME qbf-dim     = qbf-o1:X IN FRAME qbf-dim - 30
  qbf-up1:Y IN FRAME qbf-dim     = qbf-o1:Y IN FRAME qbf-dim
  qbf-dn1:X IN FRAME qbf-dim     = qbf-o1:X IN FRAME qbf-dim - 30
  qbf-dn1:Y IN FRAME qbf-dim     = qbf-o1:Y IN FRAME qbf-dim
                                 + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim - 27

  qbf-r2:X IN FRAME qbf-dim      = qbf-up1:X IN FRAME qbf-dim + 12
  qbf-r2:Y IN FRAME qbf-dim      = qbf-up1:Y IN FRAME qbf-dim + 27
  qbf-r2:HEIGHT-PIXELS IN FRAME qbf-dim = 
                                   qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim - 54

  qbf-4:Y IN FRAME qbf-dim       = qbf-o1:Y IN FRAME qbf-dim
                                 + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                                 - qbf-4:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-i                          = qbf-up1:WIDTH-PIXELS IN FRAME qbf-dim
                                 - qbf-4:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-4:X IN FRAME qbf-dim       = qbf-up1:X IN FRAME qbf-dim
                                 + MINIMUM(qbf-i,qbf-i / 2).

ASSIGN
  qbf-5:X IN FRAME qbf-dim   = qbf-o1:X IN FRAME qbf-dim + 10
  qbf-5:Y IN FRAME qbf-dim   = qbf-o1:Y IN FRAME qbf-dim
                             + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-5:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-yes:Y IN FRAME qbf-dim = qbf-o1:Y IN FRAME qbf-dim
                             + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-yes:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-yes:X IN FRAME qbf-dim = qbf-o1:X IN FRAME qbf-dim
                             + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim
                             - qbf-yes:WIDTH-PIXELS IN FRAME qbf-dim - 10
  qbf-no:Y IN FRAME qbf-dim  = qbf-yes:Y IN FRAME qbf-dim
  qbf-no:X IN FRAME qbf-dim  = qbf-yes:X IN FRAME qbf-dim
  .

ASSIGN
  qbf-lf3:X IN FRAME qbf-dim = qbf-o1:X IN FRAME qbf-dim
                             + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim - 3
  qbf-lf3:Y IN FRAME qbf-dim = qbf-o1:Y IN FRAME qbf-dim
                             + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-lf3:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-6:X IN FRAME qbf-dim   = qbf-lf3:X IN FRAME qbf-dim
                             + qbf-lf3:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-6:Y IN FRAME qbf-dim   = qbf-o1:Y IN FRAME qbf-dim
                             + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                             - qbf-6:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-rt3:X IN FRAME qbf-dim = qbf-6:X IN FRAME qbf-dim
                             + qbf-6:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-rt3:Y IN FRAME qbf-dim = qbf-lf3:Y IN FRAME qbf-dim

  qbf-r3:HEIGHT-PIXELS IN FRAME qbf-dim = qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-r3:X IN FRAME qbf-dim      = qbf-rt3:X IN FRAME qbf-dim + 24
  qbf-r3:Y IN FRAME qbf-dim      = qbf-o1:Y IN FRAME qbf-dim

  /* fix for 95-07-24-026 */
  FRAME qbf-dim:WIDTH            = MAXIMUM(FRAME qbf-dim:WIDTH,1 +
                                           qbf-r3:COL IN FRAME qbf-dim +
                                           qbf-r4:WIDTH IN FRAME qbf-dim)
  
  qbf-r4:Y IN FRAME qbf-dim = qbf-r3:Y IN FRAME qbf-dim
  qbf-r4:X IN FRAME qbf-dim = qbf-r3:X IN FRAME qbf-dim
  
  qbf-r5:X IN FRAME qbf-dim = qbf-r3:X IN FRAME qbf-dim
  qbf-r5:Y IN FRAME qbf-dim = qbf-r3:Y IN FRAME qbf-dim
                            + qbf-r3:HEIGHT-PIXELS IN FRAME qbf-dim - 3

  qbf-h[5]:Y      IN FRAME qbf-dim = qbf-6:Y IN FRAME qbf-dim
                                   - qbf-h[5]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[5]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[5],"RAW":u)) 
                                   + ")":u
  qbf-h[5]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[5]
  qbf-h[5]:X      IN FRAME qbf-dim = qbf-6:X IN FRAME qbf-dim
                                   + qbf-6:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-h[5]:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-h[4]:Y      IN FRAME qbf-dim = qbf-h[5]:Y IN FRAME qbf-dim
                                   - qbf-h[4]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-h[4]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[4],"RAW":u)) 
                                   + ")":u
  qbf-h[4]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[4]
  qbf-h[4]:X      IN FRAME qbf-dim = qbf-6:X IN FRAME qbf-dim
                                   + qbf-6:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-h[4]:WIDTH-PIXELS IN FRAME qbf-dim / 2
                                   .

ASSIGN
  qbf-up2:X IN FRAME qbf-dim = qbf-o1:X IN FRAME qbf-dim
                             + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim / 2
                             - qbf-up2:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-up2:Y IN FRAME qbf-dim = qbf-o1:Y IN FRAME qbf-dim
                             + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim - 3

  qbf-8:X IN FRAME qbf-dim   = qbf-o1:X IN FRAME qbf-dim
                             + qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim / 2
                             - qbf-8:WIDTH-PIXELS IN FRAME qbf-dim / 2
  qbf-8:Y IN FRAME qbf-dim   = qbf-up2:Y IN FRAME qbf-dim
                             + qbf-up2:HEIGHT-PIXELS IN FRAME qbf-dim

  qbf-dn2:X IN FRAME qbf-dim = qbf-up2:X IN FRAME qbf-dim
  qbf-dn2:Y IN FRAME qbf-dim = qbf-8:Y IN FRAME qbf-dim
                             + qbf-8:HEIGHT-PIXELS IN FRAME qbf-dim

  qbf-o2:X IN FRAME qbf-dim     = qbf-o1:X IN FRAME qbf-dim
  qbf-o2:WIDTH-PIXELS IN FRAME qbf-dim = qbf-o1:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-o2:Y IN FRAME qbf-dim     = qbf-dn2:Y IN FRAME qbf-dim + 24

  qbf-o3:X IN FRAME qbf-dim     = qbf-o2:X IN FRAME qbf-dim
  qbf-o4:X IN FRAME qbf-dim     = qbf-o2:X IN FRAME qbf-dim
                                + qbf-o2:WIDTH-PIXELS IN FRAME qbf-dim - 3
  qbf-o3:Y IN FRAME qbf-dim     = qbf-o2:Y IN FRAME qbf-dim
  qbf-o4:Y IN FRAME qbf-dim     = qbf-o2:Y IN FRAME qbf-dim

  qbf-h[7]:Y      IN FRAME qbf-dim = qbf-8:Y IN FRAME qbf-dim
                                   + qbf-8:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-h[7]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[7]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[7],"RAW":u) + 1) 
                                   + ")":u
  qbf-h[7]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[7]
  qbf-h[7]:X      IN FRAME qbf-dim = qbf-8:X IN FRAME qbf-dim
                                   + qbf-8:WIDTH-PIXELS IN FRAME qbf-dim
                                   .

ASSIGN
  qbf-7:X IN FRAME qbf-dim = qbf-c:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-7:Y IN FRAME qbf-dim = qbf-8:Y IN FRAME qbf-dim

  qbf-h[6]:Y      IN FRAME qbf-dim = qbf-7:Y IN FRAME qbf-dim
                                   + qbf-7:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                                   - qbf-h[6]:HEIGHT-PIXELS IN FRAME qbf-dim / 2
  qbf-h[6]:FORMAT IN FRAME qbf-dim = "x(":u 
                                   + STRING(LENGTH(qbf-h[6],"RAW":u)) 
                                   + ")":u
  qbf-h[6]:SCREEN-VALUE  IN FRAME qbf-dim = qbf-h[6]
  qbf-h[6]:X      IN FRAME qbf-dim = qbf-7:WIDTH-PIXELS IN FRAME qbf-dim
                                   + qbf-c:WIDTH-PIXELS IN FRAME qbf-dim

  qbf-r1:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-r2:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-r3:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-r4:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-r5:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-o2:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-o3:BGCOLOR  IN FRAME qbf-dim = 0
  qbf-o4:BGCOLOR  IN FRAME qbf-dim = 0
  .

&IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  &GLOBAL-DEFINE HTSTR_FMT 2
&ELSE
  &GLOBAL-DEFINE HTSTR_FMT 3
&ENDIF

ASSIGN
  qbf-v[1]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[2]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[3]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[4]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[5]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[6]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[7]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u
  qbf-v[8]:FORMAT IN FRAME qbf-dim = "x({&HTSTR_FMT})":u

  qbf-v[1]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],1,1,"CHARACTER":u)
  qbf-v[2]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],2,1,"CHARACTER":u)
  qbf-v[3]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + "&":u + SUBSTRING(qbf-v[1],3,1,"CHARACTER":u)
  qbf-v[4]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],4,1,"CHARACTER":u)
  qbf-v[5]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],5,1,"CHARACTER":u)
  qbf-v[6]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],6,1,"CHARACTER":u)
  qbf-v[7]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],7,1,"CHARACTER":u)
  qbf-v[8]:SCREEN-VALUE IN FRAME qbf-dim  = " ":u 
    + SUBSTRING(qbf-v[1],8,1,"CHARACTER":u)

  qbf-i = qbf-4:X IN FRAME qbf-dim
          - qbf-v[1]:WIDTH-PIXELS IN FRAME qbf-dim
  qbf-v[1]:X IN FRAME qbf-dim = qbf-i
  qbf-v[2]:X IN FRAME qbf-dim = qbf-i
  qbf-v[3]:X IN FRAME qbf-dim = qbf-i
  qbf-v[4]:X IN FRAME qbf-dim = qbf-i
  qbf-v[5]:X IN FRAME qbf-dim = qbf-i
  qbf-v[6]:X IN FRAME qbf-dim = qbf-i
  qbf-v[7]:X IN FRAME qbf-dim = qbf-i
  qbf-v[8]:X IN FRAME qbf-dim = qbf-i

  qbf-i                       = qbf-o1:Y IN FRAME qbf-dim
                              + qbf-o1:HEIGHT-PIXELS IN FRAME qbf-dim / 2
                              - qbf-v[1]:HEIGHT-PIXELS IN FRAME qbf-dim * 4
  qbf-v[1]:Y IN FRAME qbf-dim = qbf-i
  qbf-v[2]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[2]:HEIGHT-PIXELS IN FRAME qbf-dim
  qbf-v[3]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[3]:HEIGHT-PIXELS IN FRAME qbf-dim * 2
  qbf-v[4]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[4]:HEIGHT-PIXELS IN FRAME qbf-dim * 3
  qbf-v[5]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[5]:HEIGHT-PIXELS IN FRAME qbf-dim * 4
  qbf-v[6]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[6]:HEIGHT-PIXELS IN FRAME qbf-dim * 5
  qbf-v[7]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[7]:HEIGHT-PIXELS IN FRAME qbf-dim * 6
  qbf-v[8]:Y IN FRAME qbf-dim = qbf-i 
                              + qbf-v[8]:HEIGHT-PIXELS IN FRAME qbf-dim * 7
  .

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-dim" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help"}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

DISPLAY qbf-1 qbf-2 qbf-3 qbf-4 qbf-5 qbf-6 qbf-7 qbf-8 WITH FRAME qbf-dim.
ASSIGN
  qbf-yes:VISIBLE IN FRAME qbf-dim = qbf-5
  qbf-no:VISIBLE  IN FRAME qbf-dim = NOT qbf-5.

ENABLE qbf-1 qbf-2 qbf-3 qbf-4 qbf-5 qbf-6 qbf-7 qbf-8 qbf-ok qbf-ee qbf-help
  WITH FRAME qbf-dim.
APPLY "ENTRY":u TO qbf-1 IN FRAME qbf-dim.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-dim.
  
  IF FRAME qbf-dim qbf-1 ENTERED OR
     FRAME qbf-dim qbf-2 ENTERED OR
     FRAME qbf-dim qbf-3 ENTERED OR
     FRAME qbf-dim qbf-4 ENTERED OR
     FRAME qbf-dim qbf-5 ENTERED OR
     FRAME qbf-dim qbf-6 ENTERED OR
     FRAME qbf-dim qbf-8 ENTERED THEN
    ASSIGN
      lbl-custom        = TRUE
      qbf-lsys.qbf-type = "Custom Layout".
END.

HIDE FRAME qbf-dim NO-PAUSE.
RETURN.

/* l-layout.p - end of file */

