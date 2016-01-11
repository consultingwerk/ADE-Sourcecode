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

/* userctr.i - dictionary user interface code to center frame--use this
   only when the frame is pretty large--TTY centering algorithm can put
   the frame just a hair below the menubar, which looks non-optimal.
   This code will move it down, so that the frame partially obscures
   the message line and status line--this looks better than being
   cheek-to-jowl with the menubar.  For shorter frames, the normal
   TTY centering algorithm works better. */

/**
** PARAMETERS:
** &FRAME    widget name of the frame to be centered
**/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    {&FRAME}:ROW = 2 + (CURRENT-WINDOW:HEIGHT - {&FRAME}:HEIGHT) / 2.
&ENDIF

