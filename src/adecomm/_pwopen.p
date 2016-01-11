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

/**************************************************************************
    Procedure:  _pwopen.p
    
    Purpose:    Execute Procedure Window File->Open... command.

    Syntax :    RUN adecomm/_pwopen.p.

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE VARIABLE pw_Editor AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE Dlg_Answer   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Drop_Count   AS INTEGER   NO-UNDO.
DEFINE VARIABLE File_Name    AS CHARACTER NO-UNDO.     
DEFINE VARIABLE In_Library   AS CHAR      NO-UNDO.
DEFINE VARIABLE lScrap       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE OK_Close     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Read_OK      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Remote_File  AS CHARACTER NO-UNDO.     
DEFINE VARIABLE Temp_File    AS CHARACTER NO-UNDO.     
DEFINE VARIABLE Web_File     AS LOGICAL   NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VAR scm_ok       AS LOGICAL        NO-UNDO.
DEFINE VAR scm_context  AS CHARACTER      NO-UNDO.
DEFINE VAR scm_filename AS CHARACTER      NO-UNDO.
/* --- End SCM changes ----- */

DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
    
    RUN adecomm/_pwclosf.p ( INPUT pw_Window, INPUT pw_Editor ,
                             INPUT "Open", OUTPUT OK_Close ).
    IF OK_Close <> TRUE THEN
    DO:
        /* End any dropped-files processing. */
        pw_Window:END-FILE-DROP().
        RETURN.
    END.

    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p
        (INPUT  {&PW_NAME} , INPUT "Before-Close",
         INPUT STRING( pw_Editor ) , INPUT pw_Editor:NAME ,
         OUTPUT scm_ok ).
    IF scm_ok = FALSE THEN
    DO:
        /* End any dropped-files processing. */
        pw_Window:END-FILE-DROP().
        RETURN.
    END.
    /* --- End SCM changes ----- */
    
    /* --- Begin SCM changes --- */
    ASSIGN scm_context  = STRING( pw_Editor )
           scm_filename = pw_Editor:NAME .
    /* --- End SCM changes ----- */           

    /* Only prompt for a file when there are no dropped-files. */
    IF (pw_Window:NUM-DROPPED-FILES = ?) THEN
    DO:
      IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "REMOTE":U, 
                             OUTPUT Remote_File) NO-ERROR.
      IF Remote_File = "TRUE":U AND 
        pw_Window:PRIVATE-DATA = "_ab.p":U THEN
        Web_File = TRUE.
          
      IF Web_File THEN
        RUN adeweb/_webfile.w ("uib":U, "Open":U, "Open":U, "":U,
                               INPUT-OUTPUT File_Name, OUTPUT Temp_File, 
                               OUTPUT Dlg_Answer) NO-ERROR.
      ELSE
        RUN adecomm/_getfile.p (pw_Window , "Procedure" , 
                                "Open" , "Open" , "OPEN" , 
                                INPUT-OUTPUT File_Name ,
                                OUTPUT Dlg_Answer).
    END.
    ELSE
      ASSIGN File_Name    = pw_Window:GET-DROPPED-FILE(1)
             Dlg_Answer   = TRUE.
    IF Dlg_Answer = NO THEN RETURN. /* Cancel. */
    
    /* Try to read specified file into editor widget. If successful,
       pw_Editor:NAME and pw_Window:TITLE are updated to reflect file
       name read.
    */
    RUN adecomm/_pwrdfl.p ( INPUT  pw_Editor,
                            INPUT  (File_Name + 
                                   (IF Temp_File eq "" THEN "" 
                                    ELSE CHR(3) + Temp_File)),
                            OUTPUT Read_OK).

    IF Read_OK <> FALSE THEN
    DO:
        /* --- Begin SCM changes --- */
        RUN adecomm/_adeevnt.p 
            (INPUT  {&PW_NAME} , INPUT "Close",
             INPUT scm_context , INPUT scm_filename , 
             OUTPUT scm_ok ).
        /* --- End SCM changes ----- */
    
        APPLY "ENTRY" TO pw_Editor.

        /* --- Begin SCM changes --- */
        RUN adecomm/_adeevnt.p 
            (INPUT  {&PW_NAME} , INPUT "Open",
             INPUT STRING( pw_Editor ), INPUT pw_Editor:NAME , 
             OUTPUT scm_ok ).
        /* --- End SCM changes ----- */
    END.

    /* If there are more than one dropped-files, open them in their own Procedure Windows. */
    IF (pw_Window:NUM-DROPPED-FILES > 1) THEN
    DO Drop_Count = 2 TO pw_Window:NUM-DROPPED-FILES:
       RUN adecomm/_pwmain.p (INPUT pw_Window:PRIVATE-DATA         /* PW Parent ID  */ ,
                              INPUT pw_Window:GET-DROPPED-FILE(Drop_Count) /* File to open */  ,
                              INPUT ""                             /* PW Command    */ ).
    END.

    /* Always release dropped-files memory. */
    pw_Window:END-FILE-DROP().

END.
