/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
