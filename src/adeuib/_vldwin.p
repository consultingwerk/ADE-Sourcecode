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

File: _vldwin.p

Description:
    Return to a valid window

Input Parameters:
    not_me: window being closed or otherwise discarded

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: 1996

Modified on 01/09/97 gfs - changed setting of _cur_win_type from _U._WIN-TYPE
                           (which seems to be always ?, to _L._WIN-TYPE, which
                            seems to accurately reflect GUI vs. TTY mode)
----------------------------------------------------------------------------*/
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER not_me AS WIDGET NO-UNDO.    

DEFINE VAR real_win     AS WIDGET NO-UNDO.
DEFINE VAR new_cur_widg AS WIDGET NO-UNDO.
DEFINE VAR new_frame    AS WIDGET NO-UNDO.
DEFINE VAR new_win      AS WIDGET NO-UNDO.

/* Set _h_win to the next valid window. */
ASSIGN new_cur_widg = ?
       new_frame    = ?
       new_win      = ?.
WINDOW-SEARCH:
/* Find the next window that is not minimized and is not "not_me" */
FOR EACH _U WHERE CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) AND
	_U._STATUS NE "DELETED"
	BY _U._HANDLE:ROW DESCENDING:
  real_win = IF _U._TYPE EQ "WINDOW":U THEN _U._HANDLE ELSE _U._HANDLE:PARENT.
  IF _U._HANDLE NE not_me AND real_win:WINDOW-STATE NE WINDOW-MINIMIZED
  THEN DO:
    ASSIGN new_win        = _U._HANDLE
           new_frame      = (IF _U._TYPE eq "WINDOW":U THEN ? ELSE _U._HANDLE)
           new_cur_widg   = _U._HANDLE
           .
    new_cur_widg:MOVE-TO-TOP().
    LEAVE WINDOW-SEARCH.
  END.
END.  /* For each window */  


IF (new_cur_widg ne _h_cur_widg) 
   OR (new_frame ne _h_frame) OR (new_win ne _h_win) 
THEN DO:   
  /* Set the new values. */
  ASSIGN _h_frame = new_frame
         _h_win   = new_win.
  RUN changewidg IN _h_UIB (new_cur_widg, TRUE /* Deselect others */ ).  
  RUN sensitize_main_window IN _h_UIB ("WINDOW,WIDGET").   
  
  /* Make sure the global variables associated with _h_win are set. */ 
  IF _h_win ne ? THEN DO:
    FIND _U WHERE _U._HANDLE = _h_win.
    FIND _L WHERE RECID(_L) eq _U._lo-recid.
    ASSIGN _cur_win_type = _L._WIN-TYPE
           _cur_col_mult = _L._COL-MULT
           _cur_row_mult = _L._ROW-MULT.  
  END. /* IF _h_win ne ? ... */
END. /* IF...new...ne _h_... */
