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

File: _wintitl.p

Description:
    Sets the title of a UIB Design time window (or dialog-box) to
         "Title/Label - Untitled" or 
         "Title/Label - Save-as-file"
    If title is blank, then we just use 
          "Untitled" or 
          Save-as-file

Input Parameters:
   h_win     : The handle of the window widget
   lbl       : The label/title of the design-time window record
   lbl-sa    : The label/title string attributes.
   save-file : The file name (or ? if UNTITLED).

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: March 3, 1993 
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER h_win     AS WIDGET        NO-UNDO.
DEFINE INPUT PARAMETER lbl       AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER lbl-sa    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER save-file AS CHARACTER     NO-UNDO.

DEFINE VAR   fc                  AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR   h                   AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR   oldnum              AS INTEGER       NO-UNDO.
DEFINE VAR   n                   AS INTEGER       NO-UNDO.
DEFINE VAR   use-flag            AS CHAR          NO-UNDO.
DEFINE VAR   path                AS CHAR          NO-UNDO.
DEFINE VAR   file-name           AS CHAR          NO-UNDO.

{adeuib/sharvars.i}
{adeuib/uniwidg.i}

FIND _U WHERE _U._HANDLE = h_win NO-ERROR.
IF NOT AVAILABLE _U THEN DO:  /* Must be the window of a fake dialog-box. */  
  fc = h_win:FIRST-CHILD.
  DO WHILE fc:TYPE NE "FRAME" AND fc NE ?:
    fc = fc:NEXT-SIBLING.    
  END.
  IF fc = ? THEN RETURN.
  FIND _U WHERE _U._HANDLE = fc.
END.

/* If label is blank then just use the file name.  Otherwise, use "label -". */
IF lbl eq ? OR TRIM(lbl) = "" THEN lbl = "".
ELSE DO:
  IF lbl-sa NE "" AND lbl-sa NE "U" THEN
     RUN adeuib/_strfmt.p (lbl, lbl-sa, FALSE, OUTPUT lbl).
  lbl = lbl + " - ".
END.   

/* Get the short file name  [or use Untitled]. */
IF save-file eq ? THEN
  file-name = "Untitled" .
ELSE 
  RUN adecomm/_osprefx.p (INPUT save-file, OUTPUT path, OUTPUT file-name).

/* Change the window title. */
ASSIGN
  h_win:TITLE = lbl + file-name + 
                (IF _U._LAYOUT-NAME NE "Master Layout" THEN 
                  (" - ":U + _U._LAYOUT-NAME) ELSE "").

/* If 'UNTITLED' find first unused number and add ":n" to the title */
use-flag = FILL("n", 256).
IF save-file eq ?  THEN DO:
  FOR EACH _P WHERE _P._SAVE-AS-FILE = ?, 
      EACH _U WHERE RECID(_U) eq _P._u-recid:
    /* Get the handle of the true window */
    h = IF _U._TYPE eq "DIALOG-BOX":U THEN 
      _U._HANDLE:PARENT ELSE _U._HANDLE.
      
    IF R-INDEX(h:TITLE,":":U) > 0 THEN
      oldnum = INT(SUBSTRING(h:TITLE,R-INDEX(h:TITLE,":":U) + 1,-1,"CHARACTER":U)).
      
    IF oldnum >= n THEN 
      n = oldnum + 1.
    IF oldnum > 0 AND oldnum <= 256 THEN 
      SUBSTRING(use-flag,oldnum,1,"CHARACTER":U) = "y".
  END.
  IF n = 0 THEN n = 1.
  IF n <= 256 THEN  n = INDEX(use-flag,"n").
  h_win:TITLE = h_win:TITLE + ":" + TRIM(STRING(n)).
  file-name   = file-name + ":" + TRIM(STRING(n)).
END.

/* Add hostname suffix for remote WebSpeed files. */
ASSIGN
  h_win:TITLE = h_win:TITLE + 
                DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, 
                                 TRUE, STRING(h_win)).

FIND _P WHERE _P._WINDOW-HANDLE = h_win NO-ERROR.
IF AVAILABLE _P AND VALID-HANDLE(_P._tv-proc) THEN 
  ASSIGN file-name = DYNAMIC-FUNCTION("setFilename":U IN _P._tv-proc, INPUT file-name).

/* _wintitl.p - end of file */
