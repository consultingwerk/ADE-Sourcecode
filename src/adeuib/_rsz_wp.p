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
/*----------------------------------------------------------------------------

File: _rsz_wp.p

Description:
    Resize the "object toolbox" in the UIB. 
    
    We want an integer number of buttons so we can't let anyone totally resize
    the window.

Input Parameters:
    pl_pal_init - If TRUE, then this is the palette has just been built.
                  get the items-per-row from the ini file.  Otherwise
                  determine the items-per-row by looking at the width of
                  the window.

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: December 20, 1992

Modified by: GFS on 11/95 - Add width adjustment for Win95.
                     2/95 - New palette support for RoadRunner
                    10/96 - Make minimum size adjustments for WIN95 Shell
----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adecomm/adefext.i}        

DEFINE INPUT PARAMETER pl_pal_init       
                           AS LOGICAL NO-UNDO.

DEFINE VAR border-pixels   AS INTEGER NO-UNDO.

DEFINE VAR h               AS WIDGET  NO-UNDO.
DEFINE VAR i               AS INTEGER NO-UNDO.
DEFINE VAR items_per_row   AS INTEGER NO-UNDO. 
DEFINE VAR item-height-p   AS INTEGER NO-UNDO.
DEFINE VAR item-width-p    AS INTEGER NO-UNDO.
DEFINE VAR iRow            AS INTEGER NO-UNDO.
DEFINE VAR iCol            AS INTEGER NO-UNDO.
DEFINE VAR min-win-width-p AS INTEGER NO-UNDO.
DEFINE VAR num_rows        AS INTEGER NO-UNDO.
DEFINE VAR z               AS INTEGER NO-UNDO.
DEFINE VARIABLE v          AS CHAR    NO-UNDO.
DEFINE VARIABLE sctn       AS CHAR    NO-UNDO INITIAL "Pro{&UIB_SHORT_NAME}".
DEFINE VARIABLE winver     AS DECIMAL NO-UNDO.
DEFINE VARIABLE fudgefact  AS INTEGER NO-UNDO.

ASSIGN fudgefact = 3.
IF SESSION:WINDOW-SYSTEM = "MS-WIN95" THEN
    ASSIGN fudgefact = 3.

/* Size of each palette item is the size of the first child.
   (i.e. all items in the palette are the same size) */
ASSIGN h = _h_object_win:FIRST-CHILD.
IF NOT VALID-HANDLE(h) THEN RETURN.  /* Just in case no children */
ASSIGN item-height-p   = h:HEIGHT-P
       item-width-p    = h:WIDTH-P
       min-win-width-p = fudgefact * SESSION:PIXELS-PER-ROW /* minimum window width of palette (guess) */
       .

/* Get the window size in items_per_row.  Round this to a nice number.
   (i.e. We want 14 x 1, 7 x 2, 5 x 3, 4 x 4, etc. 
   NOTE: Add a little to the width in case the user is close the next integer
   number of rows.  
   ALSO NOTE: There is a minimum window width that we can use (based on the contents
   of a title bar.  Use the minumum size even if the user requested a smaller width). */
IF NOT pl_pal_init
  THEN items_per_row = TRUNCATE(MAX (_h_object_win:WIDTH-P + (item-width-p / 3),
                                   min-win-width-p) / item-width-p, 
                                0). 
ELSE DO:
  /* When the palette initializes, however, we want to get the items_per_row
     from the ini file.  If the value is not there, then just use 1. */
  GET-KEY-VALUE SECTION sctn KEY "PaletteItemsPerRow" VALUE v.
  IF v eq ? THEN items_per_row = 2.
  ELSE DO:
    ASSIGN items_per_row = INT(v) NO-ERROR.
    /* Whoops - invalid value. */
    IF ERROR-STATUS:ERROR THEN items_per_row = 2.
  END. 
  /* Note that we have a minumum size on windows and we increase items per row accordingly. */
  items_per_row = MAX (items_per_row, min-win-width-p / item-width-p).
END.
                         
IF items_per_row < 1 THEN items_per_row = 1.

/* How many rows do we now need? */
num_rows = _palette_count / items_per_row. 
IF num_rows * items_per_row < _palette_count THEN num_rows = num_rows + 1.

/* Can we fit this many rows on the screen (assume 2 extra "rows" to account for
   title-bar, window decoration, and menu-bar.*/
DO WHILE num_rows * item-height-p + 3 * SESSION:PIXELS-PER-ROW > SESSION:HEIGHT-P:
  ASSIGN items_per_row = items_per_row + 1
         num_rows      = _palette_count / items_per_row
         .
  IF num_rows * items_per_row < _palette_count THEN num_rows = num_rows + 1.
END. 

/* Note: this division could truncate inappropriately, so add 1 if we need to */
IF num_rows * items_per_row < _palette_count THEN num_rows = num_rows + 1.

/* WTW 7.1C Limititation: all windows have a minimum width (because we
   cannot get rid of the icons on the title-bar). The minimum width is
   approximitely equal to the three buttons in the title-bar (Ventilator,
   miniimize & maximize) each of which is about 1 PPU square. 
   */
IF item-width-p * items_per_row < min-win-width-p
THEN border-pixels = (min-win-width-p - (item-width-p * items_per_row)) / 2.

/* These settings have to be set in this particular order for some unknown reason */
ASSIGN _h_object_win:MAX-HEIGHT-P     =  num_rows * item-height-p + 2 * border-pixels
       _h_object_win:HEIGHT-PIXELS    = _h_object_win:MAX-HEIGHT-P
       _h_object_win:VIRTUAL-HEIGHT-P = _h_object_win:HEIGHT-P
       _h_object_win:WIDTH-P          = items_per_row * item-width-p + 2 * border-pixels.

/* The window height shrinks by one pixel in the above ASSIGN statement */
/* &message [_rsz_wp.p] Remove adjustment to window size for Win95 when core fixed (gfs) */
ASSIGN _h_object_win:HEIGHT-PIXELS = num_rows * item-height-p + 2 * border-pixels.

/* Walk through the child frames of the window.  Each of these has its
   order stored in private data.  Position it based on its order. */
h = _h_object_win:FIRST-CHILD.
DO WHILE h <> ? AND z < _palette_count:
  ASSIGN i    = INTEGER(h:PRIVATE-DATA)
         iRow = TRUNCATE((i - 1) / items_per_row,0)  /* 0 based */
         iCol = i - (items_per_row * iRow) - 1     /* 0 based */
         h:Y  = border-pixels + (iRow * item-height-p)
         h:X  = border-pixels + (iCol * item-width-p)
         .
/*         if h:X NE border-pixels + (iCol * item-width-p) then
 *            message "h:X= " h:X skip
 *                    "want:"  border-pixels + (iCol * item-width-p) skip
 *                    "_h_object_win:WIDTH-P=" _h_object_win:WIDTH-P
 *                    view-as alert-box.
 *          if h:Y NE border-pixels + (iRow * item-height-p) then
 *            message "h:Y= " h:Y skip
 *                    "want:"  border-pixels + (iRow * item-height-p) skip
 *                    "_h_object_win:HEIGHT-P=" _h_object_win:HEIGHT-P skip
 *                    "item-height-p = " item-height-p
 *                    view-as alert-box.
 * */
  /* Try the next frame */
  h = h:NEXT-SIBLING.
  z = z + 1.
END. 

/* Set visualization here, since doing it in the loop right above
 * causes problems
 */
ASSIGN h = _h_object_win:FIRST-CHILD
       i = 1.
DO WHILE VALID-HANDLE(h):
    IF i >= 1000 THEN LEAVE.
    IF _palette_menu THEN h:HIDDEN = TRUE.
    ELSE h:HIDDEN = FALSE.
    h = h:NEXT-SIBLING.
    i = i + 1.
END.

/* Show the window. Set the window size "correctly". */
ASSIGN _h_object_win:WIDTH-P  = (items_per_row * item-width-p) + (2 * border-pixels)
       _h_object_win:HEIGHT-P = 
           IF NOT _palette_menu THEN ((num_rows * item-height-p) + (2 * border-pixels))
                      ELSE MAX(2 * border-pixels, 1)
       _h_object_win:MAX-HEIGHT-P = IF NOT _palette_menu THEN MIN(item-height-p * _palette_count, SESSION:HEIGHT-P)
                                    ELSE _h_object_win:HEIGHT-P
         . 
IF _palette_menu THEN
  ASSIGN _h_object_win:MIN-HEIGHT-P = _h_object_win:HEIGHT-P
         _h_object_win:MIN-WIDTH-P  = _h_object_win:WIDTH-P.
ELSE
  ASSIGN _h_object_win:MIN-HEIGHT-P = item-height-p
         _h_object_win:MIN-WIDTH-P  = item-width-p.
 
/* If the window is MAXIMIZED, set the maximum height of the window to the actual height.
   This avoids a bug where the window is HIDDEN and VIEWED.  Under Windows, this would
   cause the window to change sizes. */
IF _h_object_win:WINDOW-STATE = WINDOW-MAXIMIZED THEN DO:
   _h_object_win:MAX-HEIGHT   = _h_object_win:HEIGHT. 
END. 

IF _h_object_win:HIDDEN EQ yes AND _AB_License NE 2 THEN _h_object_win:HIDDEN = no.
