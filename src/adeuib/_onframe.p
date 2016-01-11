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

File: _onframe.p

Description:
    Makes sure that widget h is indeed on the frame h_f.

Assumptions:
     h_f  is a frame that exists. It can be a scrolling frame.
     h    is a widget that is going to be made visible on frame h_f.
          i.e. You make a widget and give it its size, but it is invisible.
                call _onframe.p.  THEN you make h visible (or sensitive).

Input Parameters:
   h_f - the widget handle of the frame.
   h   - the widget handle of the object we want to make sure fits on the frame.
   hd  - make the widget hidden
   
Output Parameters:
   <none>

Author: Wm.T.Wood & Greg O'Connor

Date Created: January 12, 1993

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER h_f AS WIDGET                            NO-UNDO.
DEFINE INPUT PARAMETER h   AS WIDGET                            NO-UNDO.
DEFINE INPUT PARAMETER hd  AS LOGICAL                           NO-UNDO.

DEFINE VAR f_height     AS INTEGER                              NO-UNDO.
DEFINE VAR f_width      AS INTEGER                              NO-UNDO.

/* Compute the size of the frame so that we don't exceed it. */
ASSIGN f_width         = (IF h_f:SCROLLABLE THEN h_f:VIRTUAL-WIDTH-PIXELS
                                            ELSE h_f:WIDTH-PIXELS) -
                          h_f:BORDER-LEFT-PIXELS - h_f:BORDER-RIGHT-PIXELS
       f_height        = (IF h_f:SCROLLABLE THEN h_f:VIRTUAL-HEIGHT-PIXELS
                                            ELSE h_f:HEIGHT-PIXELS) -
                          h_f:BORDER-TOP-PIXELS - h_f:BORDER-BOTTOM-PIXELS.

/* Case 1: h is bigger than the frame > Make it the same size as the frame. */
IF h:WIDTH-PIXELS > f_width 
THEN ASSIGN h:X = 0
            h:WIDTH-PIXELS = f_width.
/* Case 2: h won't fit on the frame at the current positon > Move it right */
ELSE IF h:X + h:WIDTH-PIXELS > f_width
THEN h:X = f_width - h:WIDTH-PIXELS.
/* Case 3: h:X < 0 -- we don't worry about this */

/* Repeat logic for the Height */
IF h:HEIGHT-PIXELS > f_height
THEN ASSIGN h:Y = 0
            h:HEIGHT-PIXELS= f_height.
ELSE IF h:Y + h:HEIGHT-PIXELS > f_height
THEN h:Y = f_HEIGHT - h:HEIGHT-PIXELS.

h:HIDDEN = hd.
