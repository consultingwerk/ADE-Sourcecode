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

File: _drwfram.p

Description:
   Draw a frame.

Input Parameters:

   pl_box: TRUE if we want a box and a title

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pl_box AS LOGICAL NO-UNDO.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adeuib/gridvars.i}
{adeuib/windvars.i}

DEFINE VAR i		AS INTEGER				      NO-UNDO.
DEFINE VAR AZ		AS CHARACTER				      NO-UNDO.
DEFINE VAR cur-lo       AS CHARACTER                                  NO-UNDO.
DEFINE VAR stupid       AS LOGICAL                                    NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.


/* Define the minimum size of a widget of this type.  Convert this to pixels */
/* by scaling according to the _h_win dimensions -                           */
&Scoped-define min-height-chars 2
&Scoped-define min-cols 11  

/* Get the RECID of the parent frame OR window */
/* Are both endpoints in the current frame ? */
IF VALID-HANDLE(_h_frame) AND _second_corner_x <= _h_frame:WIDTH-PIXELS
                          AND _second_corner_y <= _h_frame:HEIGHT-PIXELS THEN DO:
  /* Yes, make _h_frame the parent of this frame */
  FIND parent_U WHERE parent_U._HANDLE = _h_frame. 
END.
ELSE FIND parent_U WHERE parent_U._HANDLE eq _h_win.

FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _L.
CREATE _C.
CREATE _Q.
       
/* Setup the Universal Widget Record for the Browser.  */
ASSIGN /* TYPE-specific settings */
       _count[{&FRAME}]  = _count[{&FRAME}] + 1
       /* Compute a name for the frame like A,B,C...Z,AA..AZ,BA,BB..ZZ. */
       i                     = TRUNCATE ((_count[{&FRAME}] - 1) / 26, 0)
       AZ                    = IF i < 1 THEN "" ELSE CHR(64 + i)
       i                     =  ((_count[{&FRAME}] - 1) MODULO 26) + 1
       AZ                    = AZ + CHR(64 + i) 
       _U._NAME              = "FRAME-" + AZ
       _U._TYPE              = "FRAME":U
       _C._BACKGROUND        = ?
       _L._NO-BOX            = NOT pl_box
       _C._BOX-SELECTABLE    = FALSE
       _C._default-btn-recid = ? 
       _C._DOWN              = FALSE
       _U._LABEL             = "Frame " + AZ  /* Title */
       _L._NO-LABELS         = NO
       _L._3-D               = parent_L._3-D
       _Q._OpenQury          = TRUE           /* Automatically Open Query */
       _Q._OptionList        = "SHARE-LOCK"   /* default to SHARE-LOCK    */
       _C._OVERLAY           = TRUE
       _C._PAGE-BOTTOM       = NO
       _C._PAGE-TOP          = NO
       _C._RETAIN            = 0
       _C._SCROLLABLE        = FALSE
       _C._SIDE-LABELS       = TRUE
       _C._TITLE             = pl_box
       _C._TOP-ONLY          = FALSE
       _L._NO-UNDERLINE      = TRUE
       _C._q-recid           = RECID(_Q)

       /* Standard Settings for Universal and Layout records */
       cur-lo                 = parent_U._LAYOUT-NAME
       _U._WINDOW-HANDLE      = _h_win
       _U._x-recid            = RECID(_C)
       _U._parent-recid       = RECID(parent_U)
       _U._ALIGN              = "L"   /* LEFT-ALIGN */
       _U._MANUAL-HIGHLIGHT   = FALSE
       _U._MOVABLE            = FALSE
       _U._RESIZABLE          = FALSE
       _U._SELECTABLE         = FALSE
       _U._SELECTED           = FALSE
       _U._SENSITIVE          = TRUE
       _U._lo-recid           = RECID(_L)
       _L._LO-NAME            = cur-lo
       _L._u-recid            = RECID(_U)
       _L._COL                = 1.0 + (_frmx / SESSION:PIXELS-PER-COLUMN)
       _L._ROW                = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW)
       _L._COL-MULT           = parent_L._COL-MULT
       _L._ROW-MULT           = parent_L._ROW-MULT
       _L._WIN-TYPE           = parent_L._WIN-TYPE
       _U._WIN-TYPE           = parent_L._WIN-TYPE.

/* Assign width and height based on area drawn by user. 
  (NOTE: this may be overriden in the custom section) */
ASSIGN _L._WIDTH = MAX( {&min-cols}, ((_second_corner_x - _frmx + 1) /
                                _cur_col_mult) / SESSION:PIXELS-PER-COLUMN) 
       _L._HEIGHT = MAX( {&min-height-chars},
                                ((_second_corner_y - _frmy + 1) /
                                _cur_row_mult) / SESSION:PIXELS-PER-ROW).

/* Are there any custom widget overrides?                               */
IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).

/* Set virtual size, if it has not been set already */
IF _L._VIRTUAL-WIDTH  eq ? THEN _L._VIRTUAL-WIDTH  = _L._WIDTH.
IF _L._VIRTUAL-HEIGHT eq ? THEN _L._VIRTUAL-HEIGHT = _L._HEIGHT.

/* Create the widget based on the Universal widget record. */
RUN adeuib/_undfram.p (RECID(_U)).

stupid = _U._HANDLE:MOVE-TO-TOP().

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}

