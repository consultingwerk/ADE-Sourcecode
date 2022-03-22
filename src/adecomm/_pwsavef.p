/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _pwsavef.p
    
    Purpose:    Low-level routine to save editor contents to disk file.  If
                saving to a remote WebSpeed agent, this program will save the
                editor contents to a local temp file only.

    Syntax :    RUN adecomm/_pwsavef.p ( INPUT p_Editor , 
                                         INPUT p_File_Selected , 
                                         TRUE [FALSE],
                                         OUTPUT p_Saved_File ) .

    Parameters: p_Editor
                
                p_File_Selected
                  If saving to a WebSpeed agent, this parameter will contain
                  the name of file to save and the local temp file, separated 
                  by CHR(3).
                  
                p_Save_Mode
                  Save As (TRUE) or Save (FALSE)
                
                p_Saved_File
                
    Description:
    Notes   :
    Authors : John Palazzo
    Date    : January, 1994
    Modified: 06/15/98 adams Added 9.0A support for remote file management
              02/23/00 adams Added 9.1B support for converting/compiling HTML 
                             files locally
**************************************************************************/

{src/web/method/cgidefs.i NEW}

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

DEFINE INPUT  PARAMETER p_Editor         AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_File_Selected  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Save_As        AS LOGICAL       NO-UNDO.
DEFINE OUTPUT PARAMETER p_Saved_File     AS LOGICAL       NO-UNDO.

DEFINE VARIABLE AB_License     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Broker_URL     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Compile_File   AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Compile_Prompt AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Convert_File   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE E4GLOptions    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE File_Ext       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Html_File      AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Local_Host     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE lScrap         AS LOGICAL       NO-UNDO.
DEFINE VARIABLE No_Compile     AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Ok_To_Save     AS LOGICAL       NO-UNDO INITIAL TRUE.
DEFINE VARIABLE Old_Broker_URL AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Option_List    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Private_Data   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE pw_Window      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Rel_Name       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Remote_File    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Scrap_File     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Temp_File      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE URL_Host       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Web_Action     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Web_Error      AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Web_File       AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Web_License    AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Web_Object     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Web_Untitled   AS LOGICAL       NO-UNDO.
DEFINE VARIABLE lOK            AS LOGICAL       NO-UNDO.
DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTempDBLib     AS HANDLE    NO-UNDO.  
DEFINE VARIABLE cRelName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTables        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileWeb       AS CHARACTER NO-UNDO INIT ?.

/* --- Begin SCM changes --- */
DEFINE VARIABLE scm_ok    AS LOGICAL       NO-UNDO.
/* --- End SCM changes ----- */

DO ON STOP UNDO, LEAVE:
  /* Get widget handles of Procedure Window. */
  RUN adecomm/_pwgetwh.p ( INPUT p_Editor , OUTPUT pw_Window ).

  IF pw_Window:PRIVATE-DATA = "_ab.p":U THEN DO:
    /* This could be part of a remote WebSpeed Save As, in which case we need 
       to save to a local temp file first. */
    IF NUM-ENTRIES( p_File_Selected, CHR(3)) ge 2 THEN
      ASSIGN
        Option_List     = ENTRY( 2, p_File_Selected, CHR(3))
        p_File_Selected = ENTRY( 1, p_File_Selected, CHR(3))
        Web_Untitled    = CAN-DO(Option_List, "untitled":U)
        Option_List     = "".

    /* Check AppBuilder Development Mode. */
    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN DO:
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "REMOTE":U, 
                              OUTPUT Remote_File ) NO-ERROR.
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "BrokerURL":U, 
                              OUTPUT Broker_URL ) NO-ERROR.
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "ABLicense":U, 
                              OUTPUT AB_License ) NO-ERROR.
      RUN adeuib/_uibinfo.p ( ?, "SESSION":U, "LocalHost":U, 
                              OUTPUT Local_Host ) NO-ERROR.
    END.

    ASSIGN    
      Old_Broker_URL  = ENTRY({&PW_Broker_URL_Pos}, p_Editor:PRIVATE-DATA)
      Web_License     = AB_License > "1":U.
    
    /* for web files, we store the full path name for the file in the private-date,
       so get it if it's there. Don't do this for save-as since we already get the
       full path name in that case.
    */
    IF NOT p_Save_As THEN
       cFileWeb = ENTRY ( {&PW_Web_File_Name_Pos}, p_Editor:PRIVATE-DATA) NO-ERROR.
    
    IF cFileWeb = ? OR cFileWeb = "" THEN
       cFileWeb =  p_File_Selected.

    /* Get temp file name to use for saving to a remote WebSpeed agent. Either
       we're attempting a SaveAs (in which case the value of Remote_File is
       important) on a new or existing file or we want to Save an existing 
       file. */
    IF (    p_Save_As AND Remote_File eq "TRUE":U) OR
       (NOT p_Save_As AND Old_Broker_URL ne "") OR Web_Untitled THEN DO:
    
      RUN adecomm/_tmpfile.p ( "ws":U, ".tmp":U, OUTPUT Temp_File ).
      Web_File = TRUE.
    END.
    
    IF NOT p_Save_As THEN 
      Broker_URL = IF Old_Broker_URL eq "" THEN Broker_URL ELSE Old_Broker_URL.
      
  END. /* pw_Window:PRIVATE-DATA = "_ab.p":U */
  
  RUN adecomm/_osfext.p ( p_File_Selected, OUTPUT File_Ext ).
  IF (File_Ext eq ".htm":U OR File_Ext eq ".html":U) THEN
    Html_File = TRUE.
    
  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p 
      (INPUT  {&PW_NAME} , INPUT "Before-Save",
       INPUT STRING( p_Editor ), INPUT p_File_Selected , 
       OUTPUT scm_ok ).
  IF scm_ok = FALSE THEN
  DO:
      ASSIGN p_Saved_File = FALSE.  /* Cancel Save. */
      RETURN.
  END.
  /* --- End SCM changes ----- */

  ASSIGN p_Saved_File = p_Editor:SAVE-FILE 
    ( IF Web_File THEN Temp_File ELSE p_File_Selected ) NO-ERROR.

  IF ( p_Saved_File = FALSE )
  THEN DO:
      MESSAGE p_File_Selected SKIP
        "Cannot save to this file."  SKIP(1)
        "File is read-only or the path specified" SKIP
        "is invalid. Use a different filename."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW pw_Window.
     RETURN "ERROR":U.
  END.
  ELSE DO:

    RUN SetEdBufType (INPUT p_Editor, INPUT p_File_Selected).   /* adecomm/peditor.i */

    /* Save WebSpeed file remotely and/or compile it. */
    IF Web_License AND (Html_File OR Web_File) THEN DO:
      IF Web_File THEN DO:
        /* Check to see if the file already exists or is writeable for Save.  For
           SaveAs, we already checked in adecomm/_pwsavas.p (adeweb/_webfile.w), 
           so there is no need to do it again. */
        IF NOT p_Save_As THEN DO:
          RUN adeweb/_webcom.w ( ?, Broker_URL, cFileWeb, "saveas:okToSave":U,
                                 OUTPUT Rel_Name, INPUT-OUTPUT Scrap_File ) NO-ERROR.

          /* We're only interested in 'writeable' case, not 'file exists'. */
          IF INDEX(RETURN-VALUE, "Not writeable":U) ne 0 THEN
            RUN returnValue ( RETURN-VALUE, p_File_Selected, "saved", 
                              OUTPUT Ok_To_Save ).
        END.
      END.
      
      IF Web_File OR (NOT Web_File AND Html_File) THEN DO:
        /* Check for special flags indicating whether we should compile. */
        IF Ok_To_Save THEN DO:
          IF Web_File THEN DO: /* remote */
            RUN adeweb/_webcom.w ( ?, Broker_URL, cFileWeb, "save":U,
                                  OUTPUT Rel_Name, INPUT-OUTPUT Temp_File ) NO-ERROR.
            IF INDEX(RETURN-VALUE, "No compile":U) ne 0 THEN
              No_Compile = TRUE.
            ELSE IF INDEX(RETURN-VALUE, "Do compile":U) ne 0 THEN
              Compile_File = TRUE.
            ELSE IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
              RUN returnValue ( RETURN-VALUE, p_File_Selected, "saved", 
                                OUTPUT lScrap ).
              p_Saved_File = FALSE.
            END.
          END. /* remote */
          ELSE DO: /* local */
            RUN adecomm/_tmpfile.p ("ws", ".cmp":U, OUTPUT Scrap_File).
            E4GLOptions = "".
            RUN webutil/e4gl-gen.p (p_File_Selected, 
                                    INPUT-OUTPUT E4GLOptions, 
                                    INPUT-OUTPUT Scrap_File).
            IF CAN-DO(E4GLOptions, "no-compile":U) THEN
              No_Compile   = TRUE.
            IF CAN-DO(E4GLOptions, "compile":U) THEN
              Compile_File = TRUE.
            OS-DELETE VALUE(Scrap_File).
          END. /* local */
        END. /* Ok_To_Save */
      END.
      OS-DELETE VALUE(Temp_File).

      /* Prompt user to compile the file to rcode if
         1. it's an HTML file and
         2. META wsoption "no-compile" is not present and
         3. META wsoption "compile" is not present and
         4. user has not been prompted before for this file
       */
      IF Html_File AND NOT No_Compile AND NOT Web_Error THEN DO:
        Compile_Prompt  = (ENTRY({&PW_Compile_Prompt_Pos}, 
                             p_Editor:PRIVATE-DATA) BEGINS "YES":U).
        IF NOT Compile_File AND Compile_Prompt THEN
          RUN adecomm/_s-alert.p ( INPUT-OUTPUT Compile_File, "question":U, "yes-no":U,
            "If this file contains SpeedScript you can compile it into a runnable Web object on your WebSpeed agent.^^Do you want to compile it now?" ).
          
        /* Does file contain META "compile" option or has user previously 
           said they want to compile the file when saving? */
        ELSE
          Compile_File = Compile_File OR 
                         ENTRY(2, ENTRY({&PW_Compile_Prompt_Pos}, 
                           p_Editor:PRIVATE-DATA), ":":U) = "YES":U.
      END.

      /* Compile the HTML file to SpeedScript rcode. */
      IF Html_File AND Compile_File AND p_Saved_File AND NOT Web_Error THEN DO:
        Web_Object = SUBSTRING(cFileWeb, 1,
                               R-INDEX(cFileWeb, ".":U),
                               "CHARACTER":U) + "w":U.
      
        /* Check remotely to see if the .w file exists or is writeable. */
        IF Web_File THEN DO:
          RUN adeweb/_webcom.w ( ?, Broker_URL, Web_Object, "COMPILE:okToSave":U,
                                 OUTPUT Rel_Name, INPUT-OUTPUT Temp_File ) NO-ERROR.
          IF RETURN-VALUE BEGINS "ERROR:":U THEN
            RUN returnValue ( RETURN-VALUE, Web_Object, "compiled", 
                              OUTPUT Ok_To_Save ).
        END.
        /* Check locally */
        ELSE IF SEARCH(Web_Object) NE ? THEN
          RUN adecomm/_s-alert.p ( INPUT-OUTPUT Ok_To_Save, "warning":U, "yes-no":U,
            SUBSTITUTE("An intermediate SpeedScript file cannot be created for &1.^^&2 already exists.^Do you want to replace it?",
            p_File_Selected,Web_Object)).

        IF Ok_To_Save THEN DO:
          IF Web_File THEN DO: /* remote */
            /* Create the Web object (.w) and compile it (.r). */
            RUN adeweb/_webcom.w (?, Broker_URL, cFileWeb, "COMPILE":U,
                                OUTPUT Rel_Name, INPUT-OUTPUT Temp_File) NO-ERROR.
            IF RETURN-VALUE BEGINS "ERROR:":U THEN
              RUN returnValue (RETURN-VALUE, p_File_Selected, "compiled", 
                               OUTPUT lScrap ).
          END.
          ELSE DO: /* local */
            E4GLOptions = "".
            RUN webutil/e4gl-gen.p (p_File_Selected, 
                                    INPUT-OUTPUT E4GLOptions, 
                                    INPUT-OUTPUT Web_Object).
            COMPILE VALUE(Web_Object) SAVE NO-ERROR.
            IF COMPILER:ERROR THEN DO:
              RUN adecomm/_tmpfile.p ("ws", ".cmp":U, OUTPUT Scrap_File).
              RUN adecomm/_errmsgs.p (INPUT pw_Window ,
                                      INPUT COMPILER:FILENAME ,
                                      INPUT Scrap_File ).
              OS-DELETE VALUE(Scrap_File).
            END.
            OS-DELETE VALUE(Web_Object).            
          END.
        END.
      END. /* Html_File and Compile_File */
    END. /* Html_File or Web_File */

    IF Web_File THEN
      OS-DELETE VALUE(Temp_File).

    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "URLhost":U, 
                             OUTPUT URL_Host) NO-ERROR.

    /* Assign new file name to editor widget and update Window title. */
    IF p_Saved_File THEN
      ASSIGN p_Editor:NAME         = p_File_Selected
             pw_Window:TITLE       = {&PW_Title_Leader} + p_Editor:NAME +
                                     (IF Web_File THEN URL_Host ELSE "")
             Private_Data          = p_Editor:PRIVATE-DATA
             ENTRY( {&PW_Broker_URL_Pos}, Private_Data ) = 
                                     (IF Web_File THEN Broker_URL ELSE "")
                                     
             /* Don't prompt again to compile the HTML file to rcode, but 
                use last response to the prompt or existance of META "compile" 
                option to drive compile feature. */
             ENTRY( {&PW_Compile_Prompt_Pos}, Private_Data ) = "NO:":U +
                                     (IF Compile_File THEN "YES":U ELSE "NO":U)

             /* Clear the compile filename, in case this buffer previously
             ** contained a compiled file.  We will generate a new compile
             ** file name when the new buffer is run.
             */
             ENTRY( {&PW_Compile_File_Pos}, Private_Data ) = ""
             p_Editor:PRIVATE-DATA = Private_Data.
        
    /* Reset the EDIT-CAN-UNDO attribute. */
    ASSIGN p_Editor:EDIT-CAN-UNDO = FALSE.

    /* Integration with the TEMP-DB Maintenance tool */
    IF p_Saved_File AND NOT Web_File AND CONNECTED ("TEMP-DB") THEN
    DO:
      RUN adeuib/_tempdbvalid.p (OUTPUT lOK). /* Check that control file is present in TEMP-DB */
      IF lOK THEN
      DO:          
        GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBIntegration":U VALUE cValue.
        IF CAN-DO ("true,yes,on",cValue) THEN
        DO:
          GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBExtension":U VALUE cValue.
          IF cValue > "" AND p_File_Selected MATCHES cValue THEN 
          DO:
            RUN adecomm/_relname.p (INPUT p_File_Selected, INPUT "", OUTPUT cRelName).
            RUN adeuib/_tempdbfind.p (INPUT "SOURCE":U,
                                      INPUT cRelName ,
                                      OUTPUT cTables).
            /* Only update if source file already exists */                          
            IF cTables > "" THEN
            DO:
              hTempDBLib = SESSION:FIRST-PROCEDURE.
              DO WHILE VALID-HANDLE(hTempDBLib) AND hTempDBLib:FILE-NAME NE "adeuib/_tempdblib.p":U:
                 hTempDBLib = hTempDBLib:NEXT-SIBLING.
              END.

              IF NOT VALID-HANDLE(hTempDBLib) THEN
              DO:
                RUN VALUE("adeuib/_tempdblib.p":U) PERSISTENT SET hTempDBLib.
                RUN RebuildImport in hTempDBLib (cRelName).
                IF VALID-HANDLE(hTempDBLib) THEN
                  DELETE PROCEDURE hTempDBLib.
              END.
              ELSE   
                RUN RebuildImport in hTempDBLib (cRelName).

            END.
          END.  /* End if file extension matches */
        END.  /* End if flag is set to yes to do perfrom TEmp-DB rebuild */
      END.  /* End if temp-db is valid */
    END.  /* End If connected Temp-DB */


   
    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p 
        (INPUT  {&PW_NAME} , INPUT "Save",
         INPUT STRING( p_Editor ), INPUT p_Editor:NAME , 
         OUTPUT scm_ok ).
    /* --- End SCM changes ----- */
    
    RUN adecomm/_setcurs.p ("").
  END. /* p_Saved_File = TRUE */
END.
RETURN.

/* RETURN-VALUE error processing */
{ adecomm/rtnval.i }

{ adecomm/peditor.i }   /* Editor procedures. */

/* _pwsavef.p - end of file */
