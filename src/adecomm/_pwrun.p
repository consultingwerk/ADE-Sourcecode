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
    Procedure:  _pwrun.p
    
    Purpose:    Execute Procedure Window commands
                  Compile->Run
                  Compile->Check Syntax

    Syntax :    RUN adecomm/_pwrun.p (INPUT p_Action).

    Parameters:
    Description:
    Notes   :
    Authors : John Palazzo
    Date    : July, 1995
    Modified: 6/19/98 adams support for 9.0A remote file managment
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

/* PROGRESS Preprocessor system message number. */
&SCOPED-DEFINE PP-4345      4345

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wfRunning     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.

DEFINE VARIABLE h_menu        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_tool        AS HANDLE    NO-UNDO.
DEFINE VARIABLE pw_Editor     AS HANDLE    NO-UNDO.
DEFINE VARIABLE pw_Window     AS HANDLE    NO-UNDO.

DEFINE VARIABLE app_handle    AS HANDLE    NO-UNDO.
DEFINE VARIABLE Broker_URL    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Cannot_Run    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Comp_Err      AS INTEGER   NO-UNDO.
DEFINE VARIABLE Comp_File     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Comp_Stopped  AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE Dlg_Answer    AS LOGICAL   NO-UNDO.             
DEFINE VARIABLE Error_Col     AS INTEGER   NO-UNDO.
DEFINE VARIABLE Error_File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Error_Found   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Error_Msg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Error_Offset  AS INTEGER   NO-UNDO.
DEFINE VARIABLE Error_Row     AS INTEGER   NO-UNDO.
DEFINE VARIABLE File_Ext      AS CHARACTER NO-UNDO.
DEFINE VARIABLE File_Modified AS LOGICAL   NO-UNDO.
DEFINE VARIABLE File_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Html_File     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Private_Data   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Proxy_Broker  AS CHARACTER NO-UNDO.
DEFINE VARIABLE Rel_Name      AS CHARACTER NO-UNDO.
DEFINE VARIABLE Remote_File   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Run_Action    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Run_Msg       AS CHARACTER NO-UNDO.
DEFINE VARIABLE Saved_File    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Web_File      AS LOGICAL   NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
    
    ASSIGN Run_Msg = REPLACE(LC(p_Action) , "-syntax":U , "").
    
    IF ( pw_Editor:EMPTY ) THEN
    DO:
        MESSAGE "Nothing in this procedure to " + Run_Msg + ".":U
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
    END.
    
    /* Put up the wait cursor. */
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    /* Generate a temporary filename for writing editor contents. */
    /* Remember the filename so it will be reused for subsequent runs.
    ** The debugger requires that the filename remain the same within
    ** a session so that breakpoints can be remembered for multiple
    ** files.
    */
    Comp_File = ENTRY( {&PW_Compile_File_Pos}, pw_Editor:PRIVATE-DATA ).
    IF Comp_File = "" THEN
    DO:
        /* Generate the unique compiler file name for this buffer. */
        RUN adecomm/_uniqfil.p ( pw_Editor:NAME , ".cmp":U, OUTPUT Comp_File ).

        ASSIGN 
          Private_Data = pw_Editor:PRIVATE-DATA 
          ENTRY( {&PW_Compile_File_Pos}, Private_Data ) = Comp_File
          pw_Editor:PRIVATE-DATA = Private_Data.
    END.

    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
    DO:
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "Remote":U, 
                             OUTPUT Remote_File) NO-ERROR.
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "BrokerURL":U, 
                             OUTPUT Proxy_Broker) NO-ERROR.
    END.
    
    RUN adecomm/_pwfmod.p ( INPUT pw_Editor, OUTPUT File_Modified).
    ASSIGN 
      File_Name  = pw_Editor:NAME
      Broker_URL = ENTRY ( {&PW_Broker_URL_Pos}, pw_Editor:PRIVATE-DATA )
      Run_Msg    = REPLACE(LC(p_Action) , "-":U , "").
      Run_Action = (IF p_Action BEGINS "check":U THEN "checked":U 
                    ELSE LC(p_Action)).

    RUN adecomm/_osfext.p ( File_Name, OUTPUT File_Ext).
    IF (File_Ext eq ".htm":U OR File_Ext eq ".html":U) THEN
      Html_File = TRUE.
    
    /* Do we want to run or check a remote web file? */  
    IF (File_Name BEGINS {&PW_Untitled} AND Remote_File eq "TRUE":U) OR
      Html_File OR Broker_URL ne "" THEN DO:
      
      /* Save changes to disk. */
      IF Html_File AND File_Modified THEN
        RUN adecomm/_pwsave.p (INPUT pw_Editor).

      /* File must be saved before running. */
      IF p_Action eq "run":U AND File_Modified THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT Dlg_Answer, "error":U, "ok":U,
          SUBSTITUTE("&1 has changes which must be saved before running.",
            File_Name)).
        RETURN.
      END.

      Web_File = TRUE.
      
      /* Save to a local temp file when checking syntax. */
      IF p_Action eq "check-syntax":U THEN DO:
        ASSIGN Saved_File = pw_Editor:SAVE-FILE (Comp_File) NO-ERROR.
        RUN SetEdBufType (INPUT pw_Editor, INPUT File_Name).    /* adecomm/peditor.i */
        IF NOT Saved_File THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT Dlg_Answer, "error":U, "ok":U,
            SUBSTITUTE("Cannot save to this file.  &1 is read-only or the path specified is invalid.",
            Comp_File)).
          RETURN.
        END.
      END.
      
      IF Broker_URL = "" AND Proxy_Broker ne ? THEN
        Broker_URL = Proxy_Broker.
      
      /* Run or check Web object. */
      RUN adeweb/_webcom.w ( ?, Broker_URL, File_Name, Run_Msg,
                            OUTPUT Rel_Name, INPUT-OUTPUT Comp_File ).
      IF RETURN-VALUE BEGINS "ERROR:":U THEN
        RUN returnValue (RETURN-VALUE, pw_Editor:NAME, Run_Action, 
                         OUTPUT Dlg_Answer).
      ELSE IF p_Action eq "CHECK-SYNTAX":U THEN
        MESSAGE "Syntax is correct."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    
    /* Compile the contents of the editor widget. */
    ELSE DO:
      RUN adecomm/_pwcmpfl.p (INPUT  pw_Editor      /* Editor handle.   */ ,
                              INPUT  "CMP_NOERROR"  /* Messages Dest.   */ ,
                              INPUT  Comp_File      /* Compile file.    */ ,
                              INPUT  ""             /* Messages file.   */ ,
                              OUTPUT Comp_Stopped   /* Compile Stopped? */ ).

      /* Force out of the DO ON STOP and perform temp file deletions. */
      IF Comp_Stopped THEN STOP.
    END.

    ASSIGN Error_Found = COMPILER:ERROR.
    IF ( Error_Found = TRUE ) THEN
    DO:
        /* Assign these COMPILER widget attributes to vars to prevent their
           current values from being overwritten by a session compile during
           development.
        */
        ASSIGN Error_File   = COMPILER:FILENAME
               Error_Row    = COMPILER:ERROR-ROW
               Error_Col    = COMPILER:ERROR-COLUMN
               Error_Offset = COMPILER:FILE-OFFSET
               . /* END ASSIGN */      
        /* If the error occurs in an include file, the names here will not be
           the same.  When this happens, we cannot move to the line with the
           error, because the COMPILER widget is reporting the error values
           relative to the include file, not the file being compiled.  So,
           only move the cursor if the error occurred in the file being
           compiled.
        */
        IF ( Error_File = Comp_File ) THEN
        DO:
          &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
           /* LARGE MSW editor does not support :CURSOR-OFFSET. */
           ASSIGN pw_Editor:CURSOR-LINE = Error_Row WHEN Error_Row <> 0
                  pw_Editor:CURSOR-CHAR = Error_Col WHEN Error_Col <> 0.
          &ELSE
           ASSIGN pw_Editor:CURSOR-OFFSET = Error_Offset
                                            WHEN Error_Offset <> 0.
          &ENDIF
        END.
    END.    
        
    /* Remove the wait cursor. */
    RUN adecomm/_setcurs.p (INPUT "":U).

    /* WARNING:
       DO NOT USE THE NO-ERROR OPTION ON ANY STATEMENT BETWEEN
       RUN adecomm/_pwcmpfl.p AND THIS CALL TO _errmsgs.p.
       PROCEDURE _errmsgs.p relies on the ERROR-STATUS HANDLE
       TO CORRECTLY REPORT ERRORS.
    */
    /* Display preprocessor and error messages, if any. */
    IF NOT Web_File AND NOT Html_File THEN
      RUN adecomm/_errmsgs.p (INPUT pw_Window ,
                              INPUT Error_File ,
                              INPUT Comp_File ).
        
    IF Error_Found = FALSE AND NOT Web_File AND NOT Html_File THEN
    DO: /* No error. */
    CASE p_Action:

      WHEN "RUN":U THEN
      DO:
        RUN adecomm/_wfrun.p
            ( INPUT "A " + pw_Window:NAME + "," + STRING(pw_Window),
              OUTPUT Cannot_Run ).
        IF Cannot_Run = FALSE THEN
        DO ON STOP UNDO, RETRY:
            ASSIGN h_tool = h_ade_tool.
            IF NOT RETRY THEN
            DO:
              RUN disable_widgets IN h_tool NO-ERROR.
              ASSIGN pw_Window:VISIBLE = FALSE.
              RUN adecomm/_runcode.p
                  ( INPUT Comp_File ,
                    INPUT "_PAUSE":U /* Run Flags */ ,
                    INPUT ?     /* p_Stop_Widget */ ,
                    OUTPUT app_handle ) .
            END. 
            RUN enable_widgets IN h_tool NO-ERROR.
            ASSIGN wfRunning = "".
            ASSIGN pw_Window:VISIBLE = TRUE.
         END.
      END. /* WHEN "RUN":U */

      WHEN "CHECK-SYNTAX":U THEN
         MESSAGE "Syntax is correct."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END CASE.
    END. /* Error_Found = FALSE */
END. /* DO ON STOP */

OS-DELETE VALUE ( Comp_File ).
  
/* If compile stopped, ensure wait cursor is removed. */
IF Comp_Stopped THEN
  RUN adecomm/_setcurs.p (INPUT "":U).

APPLY "ENTRY":U TO pw_Editor.

/* RETURN-VALUE error processing */
{ adecomm/rtnval.i }

{ adecomm/peditor.i }   /* Editor procedures. */

/* _pwrun.p - end of file. */
