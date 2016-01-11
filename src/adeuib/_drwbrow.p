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

File: _drwbrow.p

Description:
   Draw a browse widget.  Actually, we cannot make a browser that is dynamic
   therefore we really draw an editor widget and we say it is a browser.
   
   This is just like a editor drawing except:
      (1) name is different
      (2) _U._TYPE = "BROWSE"
      (3) set to DOWN 6
      (4) different calls.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

Modified on 01/30/97 gfs Added _U._SCROLLBAR-V which defaults to TRUE
----------------------------------------------------------------------------*/
/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR l_dummy      AS LOGICAL                                    NO-UNDO.
DEFINE VAR cur-lo       AS CHARACTER                                  NO-UNDO.
DEFINE VAR i            AS INTEGER                                    NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.


/* Define the minimum size of a widget of this type.                   */

&Scoped-define min-height-chars 4.5
&Scoped-define min-cols 30
 
/* Get the RECID of the parent frame */
FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.

/* Handle the case when the dictionary is busy */
DO TRANSACTION ON STOP UNDO,LEAVE:

  /* Create a Universal Widget Record and populate it as much as possible. */
  CREATE _U.
  CREATE _L.
  CREATE _C.
  CREATE _Q.
      
  /* Setup the Universal Widget Record for the Browser.  */
  ASSIGN /* TYPE-specific settings */
         _count[{&BRWSR}]      = _count[{&BRWSR}] + 1 
         _U._NAME              = "BROWSE-" + STRING(_count[{&BRWSR}])
         _U._TYPE              = "BROWSE":U
         _C._BOX-SELECTABLE    = FALSE
         _C._DOWN              = TRUE
         _C._FIT-LAST-COLUMN   = TRUE
         _U._LABEL             = "Browse " + STRING(_count[{&BRWSR}])
         _L._NO-BOX            = FALSE          /* Can't Simulate */
         _L._NO-LABELS         = FALSE          /* Default for Browsers */
         _C._TITLE             = FALSE          /* Can't Simulate */
         _Q._OpenQury          = TRUE           /* Automatically Open Query */
         _C._SCROLLABLE        = FALSE
         _U._SCROLLBAR-V       = TRUE
         _L._SEPARATORS        = parent_L._WIN-TYPE
         _C._SIDE-LABELS       = FALSE
       
         /* Standard Settings for Universal and Layout records */
         _U._WINDOW-HANDLE     = _h_win
         _U._x-recid           = RECID(_C)
         _U._parent-recid      = RECID(parent_U)
         _L._WIN-TYPE          = parent_L._WIN-TYPE
         _U._ALIGN             = "L"   /* LEFT-ALIGN */
         _L._COL               = 1.0 + (_frmx / SESSION:PIXELS-PER-COL / _cur_col_mult)
         _L._ROW               = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW / _cur_row_mult)
         _U._MANUAL-HIGHLIGHT  = FALSE
         _U._MOVABLE           = FALSE
         _U._RESIZABLE         = FALSE
         _U._SELECTABLE        = FALSE
         _U._SELECTED          = FALSE
         _U._SENSITIVE         = TRUE
         _U._lo-recid          = RECID(_L)
         _L._u-recid           = RECID(_U)
         _L._LO-NAME           = cur-lo
         _L._COL-MULT          = parent_L._COL-MULT
         _L._ROW-MULT          = parent_L._ROW-MULT
         _C._q-recid           = RECID(_Q).

  /* Set the widget size.  This may be overridden in the Custom Section. */
  ASSIGN _L._WIDTH = MAX( {&min-cols}, ((_second_corner_x - _frmx + 1) /
                       _cur_col_mult) / SESSION:PIXELS-PER-COLUMN).
         _L._HEIGHT = MAX( {&min-height-chars}, ((_second_corner_y - _frmy + 1) /
                       _cur_row_mult) / SESSION:PIXELS-PER-ROW).
       
  /* Are there any custom widget overrides?                               */
  IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).

  /* Restore Cursor to normal before asking for user input */
  l_dummy = CURRENT-WINDOW:LOAD-MOUSE-POINTER ("").

  /* Add a query to the browse. */
  IF LDBNAME("DICTDB":U) = ? OR DBTYPE("DICTDB":U) NE "PROGRESS":U THEN
  FIND-PRO:
  DO i = 1 TO NUM-DBS:
    IF DBTYPE(i) = "PROGRESS":U THEN DO:
      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(LDBNAME(i)).
      LEAVE FIND-PRO.
    END.
  END.
  RUN adeuib/_callqry.p ("_U":U, RECID(_U), "CHECK-FIELDS":U).

  /* Make a final check on the name */
  IF CAN-FIND(FIRST x_U WHERE x_U._NAME = _U._NAME AND x_U._STATUS = "NORMAL":U)
    THEN RUN adeshar/_bstname.p (_U._NAME, ?, ?, ?, _h_win, OUTPUT _U._NAME).

  /* Create the widget based on the Universal widget record. */
  RUN adeuib/_undbrow.p (RECID(_U)).
END.  /* TRANSACTION */

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}

