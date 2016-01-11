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

File: _drwtext.p

Description:
   Draw a text field onto the current h_frame.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/

/* Define the minimum size of a widget of this type */
&Scoped-define min-cols 7
 
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR hgt_rows     AS DECIMAL                                    NO-UNDO.
DEFINE VAR wdth_cols    AS DECIMAL                                    NO-UNDO.
DEFINE VAR txt_value    AS CHAR                                       NO-UNDO.
DEFINE VAR cur-lo       AS CHARACTER                                  NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Define the minimum size of a widget of this type. For a very-small space, */
/* use a default size of "Text xx". Otherwise, use a minimun size of "T xx"  */
/* for real small spaces and "Text xx" for bigger ones.                      */ 
&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4
ASSIGN _count[{&TEXT}] = _count[{&TEXT}] + 1
        hgt_rows    = (_second_corner_y - _frmy + 1) / SESSION:PIXELS-PER-ROW /
                        _cur_row_mult
        wdth_cols   = (_second_corner_x - _frmx + 1) / SESSION:PIXELS-PER-COL /
                        _cur_col_mult
        .
IF (wdth_cols < {&min-cols}) AND (hgt_rows < {&min-height-chars})
THEN ASSIGN
       wdth_cols   = ?  /* Use default */
       hgt_rows    = ?  /* Use default */
       txt_value   = "Text "+ STRING(_count[{&TEXT}]).
ELSE DO:
  IF wdth_cols < 1 THEN ASSIGN wdth_cols = 1
                               txt_value = "T".
  ELSE IF (wdth_cols > 1) AND (wdth_cols < 5) 
  THEN txt_value  = "T " + STRING(_count[{&TEXT}]).
  ELSE DO:
    txt_value  = "Text " + STRING(_count[{&TEXT}]).
    /* Fill the text value so that it fills the drawn area */
	/* ksu 02/22/94 LENGTH use raw mode, but in FILL, LENGTH use default */
    IF wdth_cols > (2 + LENGTH(txt_value, "raw":U))
    THEN txt_value  = FILL (txt_value + " ", 
                            INTEGER( (wdth_cols - 1) / (LENGTH(txt_value) + 1))).
  END.
END.
  
/* Get the RECIDs of the parent frame */
FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.


/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _F.
CREATE _L.

ASSIGN /* TYPE-specific settings */
      _U._NAME          = "TEXT-" + STRING(_count[{&TEXT}])
      _U._TYPE          = "TEXT":U
      _F._DATA-TYPE     = "Character":U
      _F._INITIAL-DATA  = txt_value
      _L._NO-LABELS     = TRUE
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .


/* Set the size drawn by the user.  NOTE: the Custom Section may 
   override this. */
 ASSIGN _L._WIDTH  = wdth_cols 
        _L._HEIGHT = hgt_rows.

/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).

/* Make a final check on the name */
IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
  THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).
  
/* Create the widget based on the contents of the Universal Widget record */
RUN adeuib/_undtext.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
