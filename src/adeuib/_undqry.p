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

File: _undqry.p

Description: Undelete a "query" widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Gerry Seidl

Date Created: 03/26/95
     Changed: 05/27/98 HD. Don't draw image if tree-view is used. 
     Changed: 07/14/98 HD. Skip adeuib/onframe.i if UsingTreeView  
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adeuib/custwidg.i}  /* Define Palette-Items (and their images) */

DEFINE VARIABLE ldummy        AS LOGICAL NO-UNDO.
DEFINE VARIABLE h             as widget  no-undo.
DEFINE VARIABLE UsingTreeView as LOGICAL no-undo.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)         eq uRecId.
FIND _L       WHERE RECID(_L)         eq _U._lo-recid.
FIND _C       WHERE RECID(_C)         eq _U._x-recid.
FIND _Q       WHERE RECID(_Q)         eq _C._q-recid.
FIND parent_U WHERE RECID(parent_U)   eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L)   eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C)   eq parent_U._x-recid.
FIND _P       WHERE _P._WINDOW-HANDLE eq parent_U._WINDOW-HANDLE. 

ASSIGN 
  UsingTreeView = VALID-HANDLE(_P._tv-proc)
  _L._WIN-TYPE  = parent_L._WIN-TYPE.

IF NOT _L._WIN-TYPE THEN _L._HEIGHT = 1.

 /* create a frame and an image in the frame. 
    This will be the widget that the UIB uses to reference the object. 
    Use the image itself as the visualization within the UIB. */

ASSIGN _L._ROW = IF _L._ROW = ? THEN 1 ELSE _L._ROW
       _L._COL = IF _L._COL = ? THEN 1 ELSE _L._COL.

IF NOT UsingTreeView THEN
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
ELSE /* i.e. UsingTreeView */  
  /* A lot of the AppBuilder logic is depending on valid handles
     and we need a frame for the Query */ 
  CREATE FRAME _U._HANDLE     
    ASSIGN 
      HIDDEN = YES.

IF parent_U._TYPE eq "WINDOW" THEN 
  _U._HANDLE:PARENT = parent_U._HANDLE.
ELSE 
  _U._HANDLE:FRAME  = parent_U._HANDLE.
       
/* Skip the image for treeview */   
IF NOT UsingTreeView THEN 
DO:
  /* Place object within parent's boundaries. */
  {adeuib/onframe.i
     &_whFrameHandle = "parent_U._HANDLE"
     &_whObjHandle   = "_U._HANDLE"
     &_lvHidden      = YES }
 
  ASSIGN
    _U._HANDLE:MOVABLE    = YES
    _U._HANDLE:SELECTABLE = YES
    . 
 
  /* Create an "visualization" image on the object. */
  CREATE IMAGE h ASSIGN
         FRAME        = _U._HANDLE
         X            = 0
         Y            = 0
         HEIGHT-P     = {&ImageSize} - 2 
         WIDTH-P      = {&ImageSize} - 2
         HIDDEN       = false
         .
  /* The image name is stored in _palette_item for many known types.
     Otherwise, just use a default icon */
  FIND _palette_item WHERE _palette_item._name eq "QUERY" NO-ERROR.
  IF AVAILABLE _palette_item
  THEN ldummy = h:LOAD-IMAGE (_palette_item._icon_up,
                              _palette_item._icon_up_x + 1,
                              _palette_item._icon_up_y + 1,
                              {&ImageSize} - 2,
                              {&ImageSize} - 2).
  ELSE ldummy = h:LOAD-IMAGE ("adeicon/smartobj", 1, 1,
                              {&ImageSize} - 2, {&ImageSize} - 2).

  /* Set the correct visualization */
  ASSIGN _U._HANDLE:HIDDEN = _L._REMOVE-FROM-LAYOUT.
  
END. /* If not UsingTreeView */
  
/* Assign Handles that we now know (including _h_cur_widg). */
ASSIGN  {adeuib/std_ul.i &section = "HANDLES"}.

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_ul.i &section = "GEOMETRY"}.
{ adeuib/rstrtrg.i } /* Restore triggers */

RETURN.

