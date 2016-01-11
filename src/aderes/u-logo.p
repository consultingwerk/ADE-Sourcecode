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
/*
*   u-logo.p
*
*    Makes the Progress Cover Screen. This screen is seen when Results
*    is started.
*/

DEFINE VARIABLE ourCover AS HANDLE  NO-UNDO.
DEFINE VARIABLE hImage   AS HANDLE  NO-UNDO.
DEFINE VARIABLE ldummy   AS LOGICAL NO-UNDO.

CREATE FRAME ourCover
  ASSIGN
    BOX        = FALSE
    OVERLAY    = TRUE
    PARENT     = CURRENT-WINDOW
    X          =  0
    Y          =  0
    VISIBLE    = YES
    SCROLLABLE = TRUE
    .

CREATE IMAGE hImage
  ASSIGN
    FRAME      = ourCover
    VISIBLE    = YES
    SENSITIVE  = YES
    .

/*
 * The following are needed to insure that the logo screen is
 * displayed during startup. This insures that window switch
 * events etc. get handled during long startup.
 * It gets reset in y-menu.p.
 */
ASSIGN
  SESSION:IMMEDIATE-DISPLAY            = TRUE
  SESSION:MULTITASKING-INTERVAL        = 40
  ldummy                               = hImage:LOAD-IMAGE("adeicon/u-logo":u)
  CURRENT-WINDOW:VIRTUAL-WIDTH-PIXELS  = hImage:WIDTH-PIXELS
  CURRENT-WINDOW:VIRTUAL-HEIGHT-PIXELS = hImage:HEIGHT-PIXELS
  CURRENT-WINDOW:WIDTH-PIXELS          = hImage:WIDTH-PIXELS
  CURRENT-WINDOW:HEIGHT-PIXELS         = hImage:HEIGHT-PIXELS
  CURRENT-WINDOW:MAX-WIDTH-PIXELS      = hImage:WIDTH-PIXELS
  CURRENT-WINDOW:MAX-HEIGHT-PIXELS     = hImage:HEIGHT-PIXELS

  /* put logo window in the middle of the screen */
  CURRENT-WINDOW:ROW                   = MAXIMUM(1,(SESSION:HEIGHT 
                                            - CURRENT-WINDOW:HEIGHT) / 2)
  CURRENT-WINDOW:COLUMN                = MAXIMUM(1,(SESSION:WIDTH  
                                            - CURRENT-WINDOW:WIDTH) / 2)

  ourCover:WIDTH-PIXELS                = hImage:WIDTH-PIXELS
  ourCover:HEIGHT-PIXELS               = hImage:HEIGHT-PIXELS
  ourCover:VIRTUAL-HEIGHT-PIXELS       = hImage:HEIGHT-PIXELS
  ourCover:VIRTUAL-WIDTH-PIXELS        = hImage:WIDTH-PIXELS
  CURRENT-WINDOW:VISIBLE               = TRUE
  .

VIEW ourCover.

/* u-logo.p - end of file */

