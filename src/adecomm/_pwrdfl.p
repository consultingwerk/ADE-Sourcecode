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
    Procedure:  _pwrdfl.p
    
    Purpose:    Reads a specified file into a Procedure Window
                editor widget and updates the PW Title bar.
                Updates ED:NAME as well.

    Syntax :    
                RUN adecomm/_pwrdfl.p
                    ( INPUT  p_Editor , INPUT  p_File_Name ,
                      OUTPUT p_Read_OK ).

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

DEFINE INPUT  PARAMETER p_Editor    AS WIDGET    NO-UNDO.
DEFINE INPUT  PARAMETER p_File_Name AS CHARACTER NO-UNDO.     
DEFINE OUTPUT PARAMETER p_Read_OK   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE Broker_URL   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Dlg_Answer   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE In_Library   AS CHARACTER NO-UNDO.
DEFINE VARIABLE OK_Close     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Open_Msg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Private_Data AS CHARACTER NO-UNDO.
DEFINE VARIABLE pw_Window    AS WIDGET    NO-UNDO.
DEFINE VARIABLE Temp_File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE URL_Host     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Web_File     AS LOGICAL   NO-UNDO.

&SCOPED-DEFINE debug FALSE

IF NUM-ENTRIES(p_File_Name, CHR(3)) eq 2 THEN
  ASSIGN Web_File    = TRUE
         Temp_File   = ENTRY( 2, p_File_Name, CHR(3))
         p_File_Name = ENTRY( 1, p_File_Name, CHR(3)).

DO ON STOP UNDO, LEAVE:

    /* --- Begin SCM changes ----- */
    ASSIGN p_Read_OK = TRUE.
    RUN adecomm/_adeevnt.p 
        ( INPUT {&PW_NAME} ,
          INPUT "Before-Open", INPUT ?, INPUT p_File_Name ,
          OUTPUT p_Read_OK ).
    IF NOT p_Read_OK THEN RETURN.
    /* --- End SCM changes ----- */

    /* Get widget handle of Procedure Window. */
    RUN adecomm/_pwgetwh.p ( INPUT p_Editor , OUTPUT pw_Window ).

    /* Try to read file. */
    ASSIGN p_Read_OK = p_Editor:READ-FILE
      (IF Web_File THEN Temp_File ELSE p_File_Name ) NO-ERROR.
      
    IF (p_Read_OK = FALSE) OR (ERROR-STATUS:NUM-MESSAGES > 0)
    THEN DO:
      ASSIGN In_Library = LIBRARY( p_File_Name ).
      IF ( In_Library <> ? ) THEN
        /* 1. File in R-code Library. */
        ASSIGN Open_Msg = "File is in R-code Library " +
                           In_Library + ".":U .
      ELSE DO:
        /* 2. Path or Filename incorrect. */
        ASSIGN FILE-INFO:FILE-NAME = (IF Web_File THEN Temp_File ELSE p_File_Name).
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            ASSIGN Open_Msg = "The path or filename may be incorrect or " +
                              "the file may not exist.".
        /* 3. No read permissions. */
        ELSE IF INDEX(FILE-INFO:FILE-TYPE , "R":U) = 0 THEN
            ASSIGN Open_Msg = "You do not have read permission.".
        /* 4. File may be too large. */
        ELSE
            ASSIGN Open_Msg = "The file may be too large to open.".
      END.
      MESSAGE p_File_Name skip
              "Cannot open file." SKIP(1)
              Open_Msg
              VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW pw_Window.
    END.

    IF p_Read_OK = FALSE THEN RETURN.
    
    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
    RUN adeuib/_uibinfo.p (?, "SESSION":U, "URLhost":U, 
                           OUTPUT URL_Host) NO-ERROR.

    /* Update information. */
    ASSIGN p_Editor:NAME   = p_File_Name
           pw_Window:TITLE = {&PW_Title_Leader} + p_File_Name +
                             (IF Web_File THEN URL_Host ELSE "").
           
    
    IF Web_File THEN DO:
      IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "BrokerURL":U, 
                             OUTPUT Broker_URL) NO-ERROR.
      IF Broker_URL ne "" THEN
        ASSIGN Private_Data          = p_Editor:PRIVATE-DATA 
               ENTRY ( {&PW_Broker_URL_Pos}, Private_Data ) = Broker_URL 
               p_Editor:PRIVATE-DATA = Private_Data.
    END.
END.
