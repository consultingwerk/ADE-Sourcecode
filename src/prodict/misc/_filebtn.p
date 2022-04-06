/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _filebtn.p

Description:
   Trigger code for the Files... button in a dialog.  Use either the 
   specified filter in the get-file dialog, or use the same one as 
   on the default filename parameter.

Input Parameters:
   p_Fillin  - Associated fill-in widget handle
   p_Title   - Title for the get-file dialog.
   p_Filter  - Filter (if null, figure something out from p_Filename)
   p_Suffix  - Default extension (if null, figure something out from p_Filename)
   p_Mustexit- Must the file exist?

Author: Bryan Mau

Date Created: 05/13/93

              04/03/05  kmcintos Optimized and beautified
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Fillin    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p_Title     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Filter    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Mustexist AS LOGICAL   NO-UNDO.
                       
DEFINE VARIABLE pickedOne      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE fname          AS CHARACTER NO-UNDO.
DEFINE VARIABLE filt           AS CHARACTER NO-UNDO.
DEFINE VARIABLE Get_Must_Exist AS CHARACTER NO-UNDO.

fname     = TRIM(p_Fillin:SCREEN-VALUE).

IF (p_Filter = "") OR (p_Filter = ?) THEN DO:
   IF (NUM-ENTRIES(fname,".") < 2) THEN filt = "*".
   ELSE filt = "*" + ENTRY(NUM-ENTRIES(fname,"."),fname,".").
END.
ELSE filt = p_Filter.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  IF p_Mustexist THEN
    SYSTEM-DIALOG GET-FILE    fname 
                  FILTERS    filt filt 
                  TITLE      p_Title 
                  MUST-EXIST 
                  UPDATE     pickedOne.
  ELSE
    SYSTEM-DIALOG GET-FILE fname 
                  FILTERS filt filt 
                  TITLE   p_Title 
                  UPDATE  pickedOne.

&ELSE
  ASSIGN Get_Must_Exist = IF p_Mustexist THEN "MUST-EXIST" ELSE "".
  RUN adecomm/_filecom.p ( INPUT filt, /* p_Filter */
                           INPUT "", /* p_Dir */
                           INPUT "", /* p_Drive */
                           INPUT NO, /* p_Save_As */
                           INPUT p_Title,
                           INPUT Get_Must_Exist,
                           INPUT-OUTPUT fname,
                           OUTPUT pickedOne ). 
&ENDIF

IF pickedOne THEN
  p_Fillin:SCREEN-VALUE = fname.
