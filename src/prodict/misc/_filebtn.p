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

----------------------------------------------------------------------------*/

DEFINE INPUT parameter p_Fillin AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT parameter p_Title  AS CHAR NO-UNDO.
DEFINE INPUT parameter p_Filter  AS CHAR NO-UNDO.
DEFINE INPUT parameter p_Mustexist  AS LOGICAL NO-UNDO.

DEFINE VAR pickedOne  AS LOGICAL NO-UNDO.
DEFINE VAR fname      AS CHARACTER NO-UNDO.
DEFINE VAR filt       AS CHAR    NO-UNDO.
DEFINE VAR rindex     AS INTEGER NO-UNDO.
DEFINE VAR Get_Must_Exist AS CHAR NO-UNDO.

fname = TRIM(p_Fillin:screen-value).
IF (p_Filter = "") OR (p_Filter = ?) THEN DO:
   rindex = R-INDEX(fname, ".").
   IF (rindex = 0) THEN filt = "*".
   ELSE filt = "*" + SUBSTRING(fname, rindex).
END.
ELSE filt = p_Filter.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
IF p_Mustexist THEN
     SYSTEM-DIALOG GET-FILE
                    fname 
                    filters filt filt 
                    title                p_Title 
                    must-exist
                    update             pickedOne.
ELSE
     SYSTEM-DIALOG GET-FILE
                    fname 
                    filters filt filt 
                    title                p_Title 
                    update             pickedOne.

&ELSE
      ASSIGN Get_Must_Exist = IF p_Mustexist THEN "MUST-EXIST"
                                             ELSE "".
      RUN adecomm/_filecom.p
          ( INPUT filt /* p_Filter */, 
            INPUT "" /* p_Dir */ , 
            INPUT "" /* p_Drive */ ,
            INPUT NO , /* p_Save_As */
            INPUT p_Title ,
            INPUT Get_Must_Exist ,
            INPUT-OUTPUT fname,
               OUTPUT pickedOne ). 
&ENDIF

IF pickedOne THEN
   p_Fillin:screen-value = fname.
