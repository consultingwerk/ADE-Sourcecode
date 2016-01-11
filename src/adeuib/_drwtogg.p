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

File: _drwtogg.p

Description:
    Draw a toggle-box.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/
 
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR cur-lo       AS CHARACTER                                  NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.

&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE RECID(parent_L)  = parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _L.
CREATE _F.

ASSIGN /* TYPE-specific settings */
       _count[{&TOGGL}]  = _count[{&TOGGL}] + 1
       _U._NAME          = "TOGGLE-" + STRING(_count[{&TOGGL}])
       _U._TYPE          = "TOGGLE-BOX":U 
       _F._DATA-TYPE     = "Logical":U
       _F._INITIAL-DATA  = "no":U
       _U._LABEL         = "Toggle " + STRING(_count[{&TOGGL}])
       /* Standard Settings for Universal and Field records */
       { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
       .
       
/* Assign width and height based on area drawn by user. 
  (NOTE: this may be overriden in the custom section) */
ASSIGN _L._HEIGHT = (_second_corner_y - _frmy + 1) / SESSION:PIXELS-PER-ROW /
                        _cur_row_mult
       _L._WIDTH = (_second_corner_x - _frmx + 1) / SESSION:PIXELS-PER-COL /
                        _cur_col_mult .
IF (_L._WIDTH < {&min-cols}) AND (_L._HEIGHT < {&min-height-chars})
THEN ASSIGN _L._WIDTH  = ?  /* Use default */
            _L._HEIGHT = ?. /* Use default */
  
/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).
 
/* For the case of a default-sized TTY toggle (our simulation), we cannot
   rely on the VT to give us the default size.  So guess the simulated size
   for "<Label>".  In TTY, always draw the default height. */
IF _L._WIN-TYPE eq NO THEN DO:
  _L._HEIGHT = ?.
  IF _L._WIDTH eq ? 
  THEN _L._WIDTH = (IF _h_frame:FONT eq ? 
                    THEN FONT-TABLE:GET-TEXT-WIDTH ("[ ]" + _U._LABEL)
                    ELSE FONT-TABLE:GET-TEXT-WIDTH ("[ ]" + _U._LABEL, 
                                                    _h_frame:FONT)) 
                    / _L._COL-MULT.
END.

/* Create the toggle based on the contents of the Universal Widget record */
RUN adeuib/_undtogg.p (RECID(_U)).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
