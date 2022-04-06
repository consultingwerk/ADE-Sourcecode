/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwsavas.p
    
    Purpose:    Execute Procedure Window File->Save command.

    Syntax :    RUN adecomm/_pwsavas.p (INPUT pw_Editor).

    Parameters:
    Description:
   1.  Test if the file is "untitled".
   2.  If untitled, execute the Save As Dialog, allowing
       user to enter a file name to save.
   3.  Write contents of editor to disk.

    Notes   :
    Authors : John Palazzo
    Date    : January, 1994
    Modified: 6/17/98 adams support for 9.0a remote file management
             05/10/99 tsm   added support for AppBuilder MRU Filelist for
                            unstructured files that can be created from the
                            AppBuilder such as blank, detail and report
                            web objects
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

/* MRU Filelist Temp Table Definition */
{adeshar/mrudefs.i}

{adeweb/web_file.i}

DEFINE INPUT  PARAMETER pw_Editor   AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE AB_License     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Broker_URL     AS CHARACTER NO-UNDO.
DEFINE VARIABLE File_Name      AS CHARACTER NO-UNDO.
DEFINE VARIABLE File_Path      AS CHARACTER NO-UNDO.
DEFINE VARIABLE Dlg_Answer     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE New_Name       AS CHARACTER NO-UNDO.
DEFINE VARIABLE Old_Broker_URL AS CHARACTER NO-UNDO.
DEFINE VARIABLE Option_List    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Private_Data   AS CHARACTER NO-UNDO.
DEFINE VARIABLE Remote_File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Save_OK        AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE Temp_File      AS CHARACTER NO-UNDO.
DEFINE VARIABLE URL_Host       AS CHARACTER NO-UNDO.
DEFINE VARIABLE Web_File       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Web_License    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Web_Untitled   AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE cReturnValue   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileWeb       AS CHARACTER NO-UNDO INIT ?.

DO ON STOP UNDO, LEAVE:
    /* Need widget handle of Procedure Window for this editor widget. */
    pw_Window = pw_Editor:WINDOW.

    /* We're about to save to a remote WebSpeed agent if
       1) this procedure window was run from AppBuilder
       2) AppBuilder's Development Mode is remote
       */
    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
    DO:
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "Remote":U, 
                             OUTPUT Remote_File) NO-ERROR.
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "BrokerURL":U, 
                             OUTPUT Broker_URL) NO-ERROR.
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "ABLicense":U, 
                             OUTPUT AB_License) NO-ERROR.
    END.

    IF Remote_File eq "TRUE":U AND 
      pw_Window:PRIVATE-DATA = "_ab.p":U THEN 
      ASSIGN Web_File = TRUE.

    ASSIGN 
      Web_Untitled   = (pw_Editor:NAME BEGINS {&PW_Untitled} AND Web_File)
      File_Name      = (IF pw_Editor:NAME BEGINS {&PW_Untitled} 
                        THEN "" ELSE pw_Editor:NAME)
      Old_Broker_URL = ENTRY ( {&PW_Broker_URL_Pos}, pw_Editor:PRIVATE-DATA )
      Web_License    = AB_License > "1":U.
                             
    /* Handle cases where local file is being saved remotely or remote 
       file is being saved locally.  Strip off the file path, since it 
       will invariably be invalid. */
    IF File_Name ne "" AND File_Name ne ? AND
      ((Remote_File eq "TRUE":U AND Old_Broker_URL eq "") OR
       (Remote_File eq "TRUE":U AND Old_Broker_URL ne Broker_URL) OR
       (Remote_File ne "TRUE":U AND Old_Broker_URL ne "")) THEN DO:
      RUN adecomm/_osprefx.p (File_Name, OUTPUT File_Path, OUTPUT New_Name).
      File_Name = New_Name.
    END.

    IF Web_License AND Web_File THEN DO:

      RUN adeweb/_webfile.w ("uib":U, "saveas":U, "Save As":U, "":U,
                             INPUT-OUTPUT File_Name, OUTPUT Temp_File, 
                             OUTPUT Dlg_Answer) NO-ERROR.

      IF ws-get-save-as-path (INPUT File_Name) NE ? THEN
          /* file name passed by _webfile.w may have the path to construct
             the full name.
          */
          ASSIGN cFileWeb = File_Name
                 File_Name = ws-get-absolute-path (INPUT File_Name).

    END.
    ELSE
      RUN adecomm/_getfile.p ( pw_Window , INPUT "Procedure" ,
                              "Save As" , "Save As" , "SAVE", 
                              INPUT-OUTPUT File_Name ,
                              OUTPUT Dlg_Answer ).       

    IF Dlg_Answer = YES AND File_Name ne ? THEN DO:
      IF Web_File THEN
        Option_List = (IF Web_Untitled THEN CHR(3) + "untitled":U ELSE "").
                   
      /* Save file to disk. */
      RUN adecomm/_pwsavef.p ( INPUT pw_Editor , 
                               INPUT File_Name + 
                                 (IF NOT Web_File THEN "" ELSE Option_List),
                               TRUE /* Save As */, OUTPUT Save_OK ).
      ASSIGN cReturnValue = RETURN-VALUE.                                                    

      IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
        RUN adeuib/_uibinfo.p (?, "SESSION":U, "URLhost":U, 
                               OUTPUT URL_Host) NO-ERROR.
      /* If Save_OK is true, the ed:SAVE-FILE was successful and the ed:NAME 
         field has the saved file name. So update the Window title. */
      IF Save_OK THEN DO:
      
        IF Web_License AND Web_File AND (cFileWeb NE ?) THEN DO:
            /* need to make sure we display only the relative path part of 
               the file name
            */
            ASSIGN pw_Editor:NAME = ws-get-relative-path (INPUT cFileWeb).
        END.

        ASSIGN pw_Window:TITLE = {&PW_Title_Leader} + pw_Editor:NAME +
                                 (IF Web_File THEN URL_Host ELSE "").
      END.

      ELSE RETURN.
   
      IF pw_Window:PRIVATE-DATA = "_ab.p":U AND Web_File /*Web_Untitled */ THEN 
        RUN adeshar/_mrulist.p ((IF cFileWeb NE ? THEN cFileWeb ELSE pw_Editor:NAME), 
                                Broker_URL).

      ASSIGN 
        Private_Data           = pw_Editor:PRIVATE-DATA 
        ENTRY ( {&PW_Broker_URL_Pos}, Private_Data ) = 
          (IF Web_File THEN Broker_URL ELSE "")
        /* save the full file name for Web Files */
        ENTRY ( {&PW_Web_File_Name_Pos}, Private_Data ) = 
           (IF Web_File THEN File_Name ELSE "")
          
        pw_Editor:PRIVATE-DATA = Private_Data.
    END.
    ELSE RETURN "ERROR".
END.
RETURN cReturnValue.

/* RETURN-VALUE error processing */
{ adecomm/rtnval.i }

/* _pwsavas.p - end of file */
