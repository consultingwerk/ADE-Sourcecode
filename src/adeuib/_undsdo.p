/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undsdo.p

Description: Undelete a "SmartData" widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Sonia Kuenzig
Date Created: 01/98
Copied from _undqry.p

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adeuib/custwidg.i}  /* Define Palette-Items (and their images) */

DEFINE VARIABLE ldummy   AS LOGICAL NO-UNDO.
DEFINE VARIABLE h        as widget  no-undo.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _C       WHERE RECID(_C)       eq _U._x-recid.
FIND _Q       WHERE RECID(_Q)       eq _C._q-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.

ASSIGN _L._WIN-TYPE = parent_L._WIN-TYPE.
IF NOT _L._WIN-TYPE THEN _L._HEIGHT = 1.

/* Create a frame and an image in the frame. This will be the widget that the 
   UIB uses to reference the object. Use the image itself as the visualization 
   within the UIB. */
CREATE FRAME _U._HANDLE ASSIGN
          HEIGHT-P   = {&ImageSize} - 2
          WIDTH-P    = {&ImageSize} - 2
          ROW        = _L._ROW
          COLUMN     = _L._COL
          HIDDEN     = YES
          OVERLAY    = YES
          BOX        = NO
          BGCOLOR    = 8
          SCROLLABLE = NO
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

IF parent_U._TYPE eq "WINDOW" THEN _U._HANDLE:PARENT = parent_U._HANDLE.
ELSE _U._HANDLE:FRAME  = parent_U._HANDLE.

ASSIGN _U._HANDLE:ROW        = _L._ROW
       _U._HANDLE:COLUMN     = _L._COL
       _U._HANDLE:MOVABLE    = YES
       _U._HANDLE:SELECTABLE = YES
       .

/* Place object within parent's boundaries. */
{adeuib/onframe.i
     &_whFrameHandle = "parent_U._HANDLE"
     &_whObjHandle   = "_U._HANDLE"
     &_lvHidden      = YES }

/* Create an "visualization" image on the object. */
CREATE IMAGE h ASSIGN
      FRAME             = _U._HANDLE
      X                 = 0
      Y                 = 0
      HEIGHT-P          = {&ImageSize} - 2 
      WIDTH-P           = {&ImageSize} - 2
      CONVERT-3D-COLORS = TRUE
      HIDDEN            = false
      .
/* The image name is stored in _palette_item for many known types.
   Otherwise, just use a default icon */
FIND _palette_item WHERE _palette_item._name eq "SmartDataObject" NO-ERROR.
IF AVAILABLE _palette_item
THEN ldummy = h:LOAD-IMAGE (_palette_item._icon_up,
                            _palette_item._icon_up_x + 1,
                            _palette_item._icon_up_y + 1,
                            {&ImageSize} - 2,
                            {&ImageSize} - 2).
ELSE ldummy = h:LOAD-IMAGE ("adeicon/smartobj", 1, 1,
                            {&ImageSize} - 2, {&ImageSize} - 2).

/* Assign Handles that we now know (including _h_cur_widg). */
ASSIGN  {adeuib/std_ul.i &section = "HANDLES"} .

/* Set the correct visualization */
ASSIGN _U._HANDLE:HIDDEN = _L._REMOVE-FROM-LAYOUT.

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_ul.i &section = "GEOMETRY"} .

{ adeuib/rstrtrg.i } /* Restore triggers */

RETURN.
