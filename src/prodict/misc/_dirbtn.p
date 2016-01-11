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

File: _dirbtn.p

Description:
   Trigger code for the directory... button in a dialog.  

Input Parameters:
   p_Fillin  - Associated fill-in widget handle
   p_Title   - Title for the get-file dialog.
   p_Filter  - Filter (if null, figure something out from p_Filename)
   

Author: Donna McMann

Date Created: 08/04/03

----------------------------------------------------------------------------*/

DEFINE INPUT parameter p_Fillin AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT parameter p_Title  AS CHAR NO-UNDO.
DEFINE INPUT parameter p_Filter  AS CHAR NO-UNDO.


DEFINE VAR pickedOne  AS LOGICAL NO-UNDO.
DEFINE VAR fname      AS CHARACTER NO-UNDO.
DEFINE VAR filt       AS CHAR    NO-UNDO.
DEFINE VAR rindex     AS INTEGER NO-UNDO.
DEFINE VAR Get_Must_Exist AS CHAR NO-UNDO.

fname = TRIM(p_Fillin:screen-value).
IF (p_Filter = "") OR (p_Filter = ?) THEN 
  ASSIGN filt = "*" .
ELSE 
  ASSIGN filt = p_Filter.

SYSTEM-DIALOG GET-DIR
             fname 
     INITIAL-DIR "./"
     title   p_Title 
     update  pickedOne.


IF pickedOne THEN
   p_Fillin:screen-value = fname.
