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

File: onframe.i

Description:
    Makes sure that widget h is indeed on the frame.
    
    NOTE: Once we got the ability to parent things to windows as well as frames
    I changes this so that the "FrameHandle" can be any container: Window or
    Frame.

Assumptions:
     _whFrameHandle  is a frame that exists. It can be a scrolling frame.
     _whObjHandle    is a widget that is going to be made visible on frame.
          i.e. You make a widget and give it its size, but it is invisible.
                call onframe.i. THEN you make _whObjHandle visible
		(or sensitive).

Input Parameters:
   _whFrameHandle - the widget handle of the frame.
   _whObjHandle   - the widget handle of the object we want to make sure
		    fits on the frame.
   _lvHidden      - make the widget hidden in this layout
   
Output Parameters:  <none>

Author: Wm.T.Wood & Greg O'Connor

Date Created: January 12, 1993

Modified:
  3/27/95 wood - allow _whFrameHandle to be a window.

----------------------------------------------------------------------------*/
DEFINE VAR _ivParentHeight     AS INTEGER                             NO-UNDO.
DEFINE VAR _ivParentWidth      AS INTEGER                             NO-UNDO.

/* Compute the size of the frame (or window) so that we don't exceed it. */
IF {&_whFrameHandle}:TYPE eq "WINDOW" 
THEN ASSIGN
       _ivParentWidth  = {&_whFrameHandle}:VIRTUAL-WIDTH-PIXELS
       _ivParentHeight = {&_whFrameHandle}:VIRTUAL-HEIGHT-PIXELS.
ELSE ASSIGN
       _ivParentWidth  = (IF {&_whFrameHandle}:SCROLLABLE THEN
			   {&_whFrameHandle}:VIRTUAL-WIDTH-PIXELS
                         ELSE {&_whFrameHandle}:WIDTH-PIXELS) -
                           {&_whFrameHandle}:BORDER-LEFT-PIXELS - 
			   {&_whFrameHandle}:BORDER-RIGHT-PIXELS
       _ivParentHeight = (IF {&_whFrameHandle}:SCROLLABLE THEN
			   {&_whFrameHandle}:VIRTUAL-HEIGHT-PIXELS
                         ELSE {&_whFrameHandle}:HEIGHT-PIXELS) -
                           {&_whFrameHandle}:BORDER-TOP-PIXELS -
			   {&_whFrameHandle}:BORDER-BOTTOM-PIXELS.

/* Case 1: object is bigger than the parent.
   Make it the same size as the parent. */
IF {&_whObjHandle}:WIDTH-PIXELS > _ivParentWidth 
THEN ASSIGN {&_whObjHandle}:X = 0
            {&_whObjHandle}:WIDTH-PIXELS = _ivParentWidth.
/* Case 2: h won't fit on the parent at the current positon > Move it right */
ELSE IF {&_whObjHandle}:X + {&_whObjHandle}:WIDTH-PIXELS > _ivParentWidth
THEN {&_whObjHandle}:X = _ivParentWidth - {&_whObjHandle}:WIDTH-PIXELS.
/* Case 3: {&_whObjHandle}:X < 0 -- we don't worry about this */

/* Repeat logic for the Height */
IF {&_whObjHandle}:HEIGHT-PIXELS > _ivParentHeight
THEN ASSIGN {&_whObjHandle}:Y = 0
            {&_whObjHandle}:HEIGHT-PIXELS = _ivParentHeight.
ELSE IF {&_whObjHandle}:Y + {&_whObjHandle}:HEIGHT-PIXELS > _ivParentHeight
THEN {&_whObjHandle}:Y = _ivParentHeight - {&_whObjHandle}:HEIGHT-PIXELS.

{&_whObjHandle}:HIDDEN = {&_lvHidden} NO-ERROR.

