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

File: _drwcomb.p

Description:
    Draws a COMBO-BOX field. Cloned from _drwfill.p

Input Parameters:
   f_side_labels: TRUE if the parent frame uses side-labels. This is used
                  to decide the default alignment for the widget.

Output Parameters:
   <None>

Author: RPR

Date Created: 12/93

Modified:
    06/08/99  tsm  Added support for editable combo-box
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER f_side_labels AS LOGICAL NO-UNDO.

{adeuib/layout.i}
{adeuib/uniwidg.i}
{adeuib/sharvars.i}

/* -------------------------------------------------------------------- */
/*                          Local Variables                             */
/* -------------------------------------------------------------------- */

DEFINE VAR offset          AS INTEGER                           NO-UNDO.
DEFINE VAR cur-lo          AS CHARACTER                         NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Define the minimum size of a widget of this type.  If the user has asked  */
/* for a very-small space, use a default size of "Combo Box xx: ________"    */
/* Otherwise, set the combo-box to NO-LABEL.                                 */

&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _F.
CREATE _L.

ASSIGN /* TYPE-specific settings */
       _count[{&CBBOX}]   = _count[{&CBBOX}] + 1
       _U._NAME           = "COMBO-BOX-" + STRING(_COUNT[{&CBBOX}])
       _U._TYPE           = "COMBO-BOX":U
       _U._SUBTYPE        = "DROP-DOWN-LIST":U
       _F._DATA-TYPE	  = "Character":U
       _F._BLANK          = FALSE	
       _F._DEBLANK        = FALSE
       _F._INNER-LINES    = 5 /* Use this as a default value - widget returns 0 */
       /* Set the following as UNKNOWN -- If they are set in Custom Settings
          then we will know not to use our regular default values. */
       _F._FORMAT         = ?   
       _U._LABEL          = ?
       _L._NO-LABELS      = ?
       _F._LIST-ITEMS     = ? 
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .

/* Set the widget size.  This may be overridden in the Custom Section.
   NOTE: Height can only be set simple combo-box widgets.  */ 
IF (_L._WIDTH < {&min-cols})THEN _L._WIDTH = (IF _cur_win_type THEN 16 ELSE 10). 
ELSE _L._WIDTH = (_second_corner_x - _frmx + 1) /
                     SESSION:PIXELS-PER-COLUMN / _cur_col_mult.
IF _L._WIDTH < {&min-cols} THEN _L._WIDTH = (IF _cur_win_type THEN 16 ELSE 10). 

/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).
     
IF _U._SUBTYPE = "SIMPLE" THEN DO:
  _L._HEIGHT = (_second_corner_y - _frmy + 1) / 
                SESSION:PIXELS-PER-ROW / _cur_row_mult.
  /* If we are IN TTY MODE, then default to a one PPU height */
  IF NOT _cur_win_type THEN _L._HEIGHT = 1.0.
  ELSE DO:
    /* If the height is small, then default to the default height. */
    IF (_L._HEIGHT < {&min-height-chars}) THEN _L._HEIGHT = ?.
  END.
END.  /* if simple */
              
/* Set the label (and the NO-LABELS attribute) */
IF _U._LABEL ne ? THEN DO:
  /* If the Custom Widget specified a LABEL, then assume they really want it. */
  IF _L._NO-LABELS eq ? THEN _L._NO-LABELS = NO.
END.
ELSE DO:
  /* Set Label based on default name.  Set NO-LABELS if this name is too
     long to fit. */
  _U._LABEL = "Combo " + STRING(_count[{&CBBOX}]).
  IF _L._NO-LABELS eq ? THEN DO:
    ASSIGN offset = FONT-TABLE:GET-TEXT-WIDTH-P (_U._LABEL + ":", _h_frame:FONT) +
                    (2 * SESSION:PIXELS-PER-COLUMN)
           _L._NO-LABELS = (_frmx <= offset). /* Use NO-LABELS for a long name */
  END.
END.

/* If there are no LIST-ITEMS, then make some based on type. */
IF _F._LIST-ITEMS eq ? THEN DO:
  CASE _F._DATA-TYPE:
    WHEN "Integer":U OR
    WHEN "Decimal":U   THEN _F._LIST-ITEMS = "0".
    WHEN "Character":U THEN _F._LIST-ITEMS = "Item 1".
    WHEN "Logical":U   THEN _F._LIST-ITEMS = "Yes" + CHR(10) + "No".
    /* OTHERWISE, just leave it unknown. */
  END CASE.
END.

/* Base the default format on the data-type, if it is still unknown. */
IF _F._FORMAT eq ? THEN DO: 
  /* Character is the only datatype we override -- other data-types get the
     default format from the fill-in. */
  IF _F._DATA-TYPE eq "Character":U THEN _F._FORMAT = "X(256)":U.
  IF NOT _L._WIN-TYPE THEN DO:
    CASE _F._DATA-TYPE:
      WHEN "DATE":U    THEN ASSIGN _F._FORMAT       = "99/99/99".
      WHEN "DECIMAL":U THEN ASSIGN _F._FORMAT       = "->>,>>9.99"
                                   _F._INITIAL-DATA = "0.00".
      WHEN "INTEGER":U THEN ASSIGN _F._FORMAT       = "->,>>>,>>9"
                                   _F._INITIAL-DATA = "0".
      WHEN "LOGICAL":U THEN ASSIGN _F._FORMAT       = "yes/no".
      WHEN "RECID":U   THEN ASSIGN _F._FORMAT       = ">>>>>>>".
    END.
  END.
END.

/* For Logicals make sure that the INITIAL-DATA is either "no", "yes" or "?" */
IF _F._DATA-TYPE = "LOGICAL":U AND _F._INITIAL-DATA = "":U THEN
  _F._INITIAL-DATA = "no":U.

/* Make a final check on the name */
IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
  THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).

/* Create the widget based on the Universal widget record. */
RUN adeuib/_undcomb.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
