/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
DEFINE VARIABLE File_Ext     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFullPathWeb AS CHARACTER NO-UNDO.

&SCOPED-DEFINE debug FALSE

IF NUM-ENTRIES(p_File_Name, CHR(3)) eq 3 THEN
  ASSIGN Web_File    = TRUE
         Temp_File   = ENTRY( 2, p_File_Name, CHR(3))
         cFullPathWeb = ENTRY( 3, p_File_Name, CHR(3))
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

    /* get the file extension to check for .cls */
    RUN adecomm/_osfext.p ( p_File_Name, OUTPUT File_Ext).

    /* Update information. */
    /* Clear the compile filename, in case this buffer previously contained
    ** a compiled file.  We will generate a new compile file name when the
    ** new buffer is run.
    ** Also clear any Class_Type we have saved, and any Class_TmpDir we have created
    */
    ASSIGN p_Editor:NAME   = p_File_Name
           pw_Window:TITLE = {&PW_Title_Leader} + p_File_Name +
                             (IF Web_File THEN URL_Host ELSE "")
           Private_Data = p_Editor:PRIVATE-DATA 
           ENTRY( {&PW_Compile_File_Pos}, Private_Data ) = ""
           ENTRY( {&PW_Class_Type_Pos}, Private_Data ) = 
                             (IF File_Ext = ".cls":U THEN "?" ELSE "")
           ENTRY( {&PW_Class_TmpDir_Pos}, Private_Data ) = ""
           p_Editor:PRIVATE-DATA = Private_Data.
           
    
    IF Web_File THEN DO:
      IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "BrokerURL":U, 
                             OUTPUT Broker_URL) NO-ERROR.
      IF Broker_URL ne "" THEN
        ASSIGN Private_Data          = p_Editor:PRIVATE-DATA 
               ENTRY ( {&PW_Broker_URL_Pos}, Private_Data ) = Broker_URL 
               ENTRY ( {&PW_Web_File_Name_Pos}, Private_Data ) = cFullPathWeb
               p_Editor:PRIVATE-DATA = Private_Data.
    END.
END.
