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

File: _updtclr.p

Description:
    Changes the color of all the TTY simulator widgets.
    Also changes the global variables for new tty widgets (_tty_bgcolor and
    _tty_fgcolor).

Input Parameters:
   pi_new_fg - New foreground color.
   pi_new_bg - New background color.
Output Parameters:
   <none>

Author: Wm.T.Wood

Date Created: December 16, 1992

----------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER pi_new_fg AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pi_new_bg AS INTEGER NO-UNDO.

ASSIGN _tty_bgcolor = pi_new_bg
       _tty_fgcolor = pi_new_fg.
       
SCAN-BLK:
FOR EACH _U WHERE _U._STATUS <> "DELETED":
  IF _U._lo-recid = ? THEN NEXT SCAN-BLK. 
  
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  IF NOT _L._WIN-TYPE THEN DO:

    ASSIGN _L._BGCOLOR            = _tty_bgcolor
           _U._HANDLE:BGCOLOR     = _tty_bgcolor
           _L._FGCOLOR            = _tty_fgcolor
           _U._HANDLE:FGCOLOR     = _tty_fgcolor.
         
    /* If a frame and the title is same as frame, change the title too */
    IF CAN-DO("FRAME,BROWSE,DIALOG-BOX",_U._TYPE) THEN DO:
      ASSIGN _L._TITLE-BGCOLOR   = _tty_bgcolor
             _L._TITLE-FGCOLOR   = _tty_fgcolor.
      /* Avoid setting color in simulated widgets that don't support title color */
      IF CAN-SET(_U._HANDLE, "TITLE-BGCOLOR")  
      THEN ASSIGN _U._HANDLE:TITLE-BGCOLOR = _tty_bgcolor
                  _U._HANDLE:TITLE-FGCOLOR = _tty_fgcolor.
    END. /* If a frame */
  END.  /* If not _win-type (if tty) */
END. /* FOR EACH ... */
