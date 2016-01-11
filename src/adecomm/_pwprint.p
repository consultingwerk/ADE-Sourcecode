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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/**************************************************************************
    Procedure:  _pwprint.p
    
    Purpose:    Execute Procedure Window File->Print command.

    Syntax :    RUN adecomm/_pwprint.p.

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor AS WIDGET-HANDLE NO-UNDO.

DEFINE VAR Return_Status AS LOGICAL NO-UNDO.
DEFINE VAR Printed       AS LOGICAL NO-UNDO.
DEFINE VAR vModified     AS LOGICAL NO-UNDO.    
DEFINE VAR Tmp_File      AS CHARACTER NO-UNDO.

_PRINT_BLOCK:
DO ON STOP UNDO _PRINT_BLOCK , RETRY _PRINT_BLOCK:
  /* Get widget handles of Procedure Window and its editor widget. */
  RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
  RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).

  IF NOT RETRY THEN
  DO:
    IF pw_Editor:EMPTY THEN
    DO:
      MESSAGE "Nothing in this procedure to print."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK
            IN WINDOW pw_Window.
      RETURN.
    END.
    
    /* In Windows, we put up a dialog box. So we don't need the wait. */
    IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
        RUN adecomm/_setcurs.p ( INPUT "WAIT" ).
    DO ON STOP UNDO, LEAVE:
       RUN adecomm/_tmpfile.p ( "p" , ".ped" , OUTPUT Tmp_File ).
    END.
    ASSIGN vModified         = pw_Editor:MODIFIED
           Return_Status     = pw_Editor:SAVE-FILE( Tmp_File )
           pw_Editor:MODIFIED = vModified
    . /* END ASSIGN */
    RUN SetEdBufType (INPUT pw_Editor, INPUT pw_Editor:NAME).   /* adecomm/peditor.i */
    
    RUN adecomm/_osprint.p ( INPUT pw_Window,
                             INPUT Tmp_File,
                             INPUT pw_Editor:FONT,
                             INPUT 1 +
                              (IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0),
                             INPUT 0,
                             INPUT 0,
                             OUTPUT Printed ) .
  
  END. /* NOT RETRY */

  OS-DELETE VALUE( Tmp_File ) .
  /* In Windows, we put up a dialog box. So we don't need the wait. */
  IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
      RUN adecomm/_setcurs.p ( INPUT "" ).
  /* This is just to be sure the user winds up in the editor. */
  APPLY "ENTRY" TO pw_Editor.

END. /* DO ON STOP */

{ adecomm/peditor.i }   /* Editor procedures. */

/* _pwprint.p - end of file */
