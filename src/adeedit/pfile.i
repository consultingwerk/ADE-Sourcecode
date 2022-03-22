/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  pfile.i 
  File Commands-Related Procedures for Editor
--------------------------------------------------------------------------*/


PROCEDURE WinExitEditor:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the EXIT command, exiting the PROGRESS Editor.

    Run Syntax:     RUN WinExitEditor.

    Parameters:

    Description:
        1. Allow user chance to save any changes to open buffers.

    Notes: See ExitEditor  procedure in this file.
    Modified: 12/96 Added SKIP(2) to printile for TTY bug#96-09-19-036
  ---------------------------------------------------------------------------*/

  APPLY "CHOOSE" TO mi_Exit.
  RETURN ERROR.
END PROCEDURE.  /* WinExitEditor. */


PROCEDURE FileChanged:

  /*--------------------------------------------------------------------------
    Purpose:        Executes File Changed Dialog, which asks user to save
                    changes made to a modified file before continuing some
                    operation.

    Run Syntax:     RUN FileChanged( INPUT p_Buffer , OUTPUT p_Message_Response)

    Parameters:
        p_Message_Repsonse   YES - User wants changes.
                             NO  - User does not want changes saved.
                              ?  - User wants to Cancel the current
                                   operation.
    Description:
    
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO. 
  DEFINE OUTPUT PARAMETER p_Message_Response AS LOGICAL NO-UNDO.

  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO.

  /* PROC BufQMod can be found in adeedit/pbuffers.i. */
  RUN BufQMod ( INPUT p_Buffer , OUTPUT Buf_Modified ).
  IF ( Buf_Modified = TRUE ) THEN DO:
    p_Message_Response = YES.
    MESSAGE p_Buffer:PRIVATE-DATA SKIP
            "This buffer has changes which have not been saved." SKIP(1)
              "Save changes before closing?"
             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL 
                      UPDATE p_Message_Response. 
  END.
  ELSE
    p_Message_Response = NO.  /* No changes, so skip the save. */
    
  RETURN.
  
END PROCEDURE.  /* AlertClose */


PROCEDURE NewFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes NEW File Command, which creates a new 
                    current untitled buffer.

    Run Syntax:     RUN NewFile

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE VAR Buf_Name AS CHAR NO-UNDO.
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok   AS LOGICAL NO-UNDO.
  /* --- End SCM changes ----- */
  
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Creating new buffer..." ,
                        "WAIT" ) .

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    /* To avoid flashing in tty, hide current buffer. */
    ASSIGN ProEditor:VISIBLE = FALSE NO-ERROR.
  &ENDIF

  /* OpenNewBuffer */
  RUN CreateBuffer (INPUT win_ProEdit, OUTPUT ProEditor ) .
  RUN CreateUntitledBufName (OUTPUT Buf_Name ) .
  ASSIGN ProEditor:PRIVATE-DATA = Buf_Name.
  RUN AssignBuffer ( INPUT ProEditor , INPUT ProEditor:PRIVATE-DATA ).
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor ) .
  ASSIGN File_Name = ProEditor:PRIVATE-DATA.

  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p 
      (INPUT  "Editor", INPUT "New", INPUT STRING(ProEditor), ?, 
       OUTPUT scm_ok).
  /* --- End SCM changes ----- */

  /* Clear Undo state. */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ASSIGN ProEditor:EDIT-CAN-UNDO = FALSE.
  &ENDIF

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  /* Although MakeCurrent executes an APPLY "ENTRY", the wait state was set
     which causes PROGRESS to block the event. So we do it again after the
     wait state has been turned off.
  */
  APPLY "ENTRY" TO ProEditor.

END PROCEDURE.  /* NewFile */


PROCEDURE OpenFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the OPEN command, which allows user to select
                    and edit an existing file.  Opens file into new buffer.
                    
                    For GUI, handles dropped files processing as well.

    Run Syntax:     RUN OpenFile.

    Parameters:

    Description:

        1. If there are no dropped files, prompt user for a filename.
        2. For files selected or dropped:
            - Check for a reopen
            - Otherwise open the file
        3. Opened files are added to Editor's Buffer List, if not already on it.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE hCur_Buffer AS WIDGET-HANDLE NO-UNDO.
  /* In case we cannot read the "Open File" into a buffer, we'll go back
     to hCur_Buffer.                                 
  */
  DEFINE VARIABLE OF_OK         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE File_Selected AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE File_Count    AS INTEGER      NO-UNDO.
  
  IF (win_ProEdit:NUM-DROPPED-FILES = ?) OR
     (win_ProEdit:NUM-DROPPED-FILES = 0) THEN
  DO:
      RUN adeedit/_dlggetf.p 
          ( INPUT "Open" ,
            INPUT NO ,
            INPUT 1 /* Initial_Filter */ ,
            INPUT-OUTPUT File_Selected ,
            OUTPUT OF_OK ) .
  END.
  ELSE
  DO File_Count = 1 TO win_ProEdit:NUM-DROPPED-FILES:
      ASSIGN File_Selected = File_Selected + ",":U + win_Proedit:GET-DROPPED-FILE(File_Count)
             OF_OK         = TRUE.
  END.
  IF NOT OF_OK THEN RETURN. /* User pressed Cancel. */

  /* Remove leading comma that may have been added in dropped-files processing. */
  ASSIGN File_Selected = TRIM(File_Selected, ",":U).

  OPEN_BLOCK:
  DO File_Count = 1 TO NUM-ENTRIES(File_Selected):
      /* Test for reopening file. Here's what the return values mean:
            OF_OK = YES : File was open with changes and got reopened.
                    NO  : File was open with changes and user did not want it reopened.
                    ?   : File was not already open.
      */
      RUN ReOpenFile ( INPUT ENTRY(File_Count, File_Selected) , INPUT-OUTPUT ProEditor ,
                       OUTPUT OF_OK ).
      IF ( OF_OK = ? ) THEN
      DO: /* Go open file. */
          RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Opening file..." ,
                             "WAIT" ) .
          RUN FileOpen
                ( INPUT        win_ProEdit ,
                  INPUT        ENTRY(File_Count, File_Selected) ,
                  INPUT        FALSE ,
                  INPUT-OUTPUT ProEditor ).
          File_Name = ProEditor:PRIVATE-DATA.
          &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          /* If File_Name begins untitled then there was an error opening the 
             file and we don't want to add the file to the MRU filelist */
          IF File_Name BEGINS Untitled THEN.
          ELSE RUN MRUList ( INPUT File_Name ).
          &ENDIF
      END.
      ELSE
      DO: /* File either got reopened or did not get reopened. */
          File_Name = ProEditor:PRIVATE-DATA.
          NEXT OPEN_BLOCK.
      END.
  END. /* DO OPEN_BLOCK */
  
  /* Be certain the system-wide File_Name var is set to correct current file name. */
  File_Name = ProEditor:PRIVATE-DATA.

  /* Always release dropped-files memory before returning. */
  win_ProEdit:END-FILE-DROP().


  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .


  /* Although FileOpen which calls MakeCurrent executes an APPLY "ENTRY", 
     the wait state was set which causes PROGRESS to block the event.
     So we do it again after the wait state has been turned off.
  */
  APPLY "ENTRY" TO ProEditor.
  
END PROCEDURE.  /* OpenFile */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
PROCEDURE OpenMRUFile:

  /*--------------------------------------------------------------------------
    Purpose:        Open a File from the MRU FileList
                    
    Run Syntax:     RUN OpenMRUFile ( INPUT p_File_Num ).

    Parameters:     p_File_Num     INTEGER
                    File position of the file in the MRU FileList to be opened

    Description:

    Notes:
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_File_Num AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE hCur_Buffer AS WIDGET-HANDLE NO-UNDO.
  /* In case we cannot read the "Open File" into a buffer, we'll go back
     to hCur_Buffer.                                 
  */
  DEFINE VARIABLE OF_OK         AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL      NO-UNDO.
  
  FIND MRU_Files WHERE MRU_Files.mru_position = p_File_Num NO-ERROR.
  IF AVAILABLE MRU_Files THEN DO:
    /* Test for reopening file. Here's what the return values mean:
          OF_OK = YES : File was open with changes and got reopened.
                  NO  : File was open with changes and user did not want it reopened.
                  ?   : File was not already open.
    */
    RUN ReOpenFile ( INPUT MRU_Files.mru_file , INPUT-OUTPUT ProEditor , OUTPUT OF_OK ).
    IF ( OF_OK = ? ) THEN
    DO: /* Go open file. */
        RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Opening file..." ,
                           "WAIT" ) .
        RUN FileOpen
              ( INPUT        win_ProEdit ,
                INPUT        MRU_Files.mru_file ,
                INPUT        FALSE ,
                INPUT-OUTPUT ProEditor ).
        File_Name = ProEditor:PRIVATE-DATA.
        /* If File_Name begins untitled then there was an error opening the
           file so we remove the file from the filelist */
        IF File_Name BEGINS Untitled THEN DO:
          DELETE MRU_Files.
          RUN MRUList ( INPUT "":U ).
        END.  /* if file_name begins untitled */
        /* File was opened successfully so we must adjust its position on the
           filelist */
        ELSE RUN MRUList ( INPUT File_Name ).
    END.
    ELSE
    DO: /* File either got reopened or did not get reopened. */
        File_Name = ProEditor:PRIVATE-DATA.
    END.
  
    /* Be certain the system-wide File_Name var is set to correct current file name. */
    File_Name = ProEditor:PRIVATE-DATA.

    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

    /* Although FileOpen which calls MakeCurrent executes an APPLY "ENTRY", 
       the wait state was set which causes PROGRESS to block the event.
       So we do it again after the wait state has been turned off.
    */
    APPLY "ENTRY" TO ProEditor.
  END.  /* if avail MRU_Files */
  
END PROCEDURE.  /* OpenMRUFile */
&ENDIF

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
PROCEDURE NewPW:
  /*--------------------------------------------------------------------------
    Purpose:        Executes File->New Procedure Window editor command.

    Run Syntax:     RUN NewPW.

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE VARIABLE pw_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE pw_Editor  AS WIDGET-HANDLE NO-UNDO.
  
  RUN WinStatusMsg ( win_ProEdit , 
                     "MT_INPUT"  ,
                     "Creating new procedure window..." ,
                     "WAIT" ) .
  /* Open new Procedure Window. */
  RUN adecomm/_pwmain.p ( INPUT "_edit.p":U /* PW Parent ID */ ,
                          INPUT ""          /* PW File List */ ,
                          INPUT ""          /* PW Command   */ ).
  
  /* Get handle of new PW. */
  ASSIGN pw_Window = SESSION:LAST-CHILD.
  
  /* Get widget handle of Procedure Window editor widget. */
  RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
  
  /* Make new PW inherit font of Procedure Editor default font. */
  IF pw_Editor:FONT <> Sys_Options.EditorFont
  THEN ASSIGN pw_Editor:FONT = Sys_Options.EditorFont.

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
   
END PROCEDURE.
&ENDIF

PROCEDURE ReOpenFile:
  /*--------------------------------------------------------------------------
    Purpose:        Re-Open a file from disk, or if the file is already open
                    in a buffer, make it the current buffer.

    Run Syntax:     RUN ReOpenFile
                      ( INPUT p_File_Name ,
                        INPUT-OUTPUT p_Current_Buffer ,
                        OUTPUT p_Return_Status ) .

    Parameters:

    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_File_Name      AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Current_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_Return_Status  AS LOGICAL NO-UNDO.

  DEFINE VAR Fullpath_Buffer_Name AS CHAR NO-UNDO.
  DEFINE VAR Delete_Buffer AS WIDGET-HANDLE.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok    AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context   AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */

  /* References to system editor vars here. */
  DO: /* proc-main */
      ASSIGN
          p_Return_Status      = ?
          FILE-INFO:FILENAME   = p_File_Name .
          Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME
      . /* END ASSIGN. */
      /*----------------------------------------------------------------
         Be sure we can find file. User may have renamed or deleted it.
         Don't search for Edit_Buffer with File_Name = ? because
         that finds the first Untitled buffer.
      ----------------------------------------------------------------*/
      IF ( Fullpath_Buffer_Name <> ? ) 
      THEN FIND FIRST Edit_Buffer WHERE ( Edit_Buffer.File_Name =
                                          Fullpath_Buffer_Name )
                                  NO-ERROR.

      IF AVAILABLE( Edit_Buffer ) AND ( Fullpath_Buffer_Name <> ? )
      THEN DO:  /* File already open in editor buffer. */
      
        p_Return_Status = YES.
        IF ( Edit_Buffer.hBuffer:MODIFIED = YES )
        THEN DO:  /* Modified */
            MESSAGE p_File_Name SKIP
                    "File is already open with changes." SKIP(1)
                    "Discard changes and re-open file?"
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                            UPDATE p_Return_Status .
            
            IF ( p_Return_Status = NO ) 
            THEN DO: /* Switch to open buffer. */
                /* If its not already the current buffer, make it current. */
                IF ( p_Current_Buffer <> Edit_Buffer.hBuffer )
                THEN DO:

                  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                  /* To avoid flashing in tty, hide current buffer. */
                  ASSIGN p_Current_Buffer:VISIBLE = FALSE NO-ERROR.
                  &ENDIF

                  p_Current_Buffer = Edit_Buffer.hBuffer .
                  File_Name = p_Current_Buffer:PRIVATE-DATA.
                  RUN MakeCurrent ( INPUT Edit_Buffer.hWindow ,
                                    INPUT Edit_Buffer.hBuffer ).
                END.
                ELSE APPLY "ENTRY" TO p_Current_Buffer.
                RETURN.
            END.     /* Switch to open buffer. */
            &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            /* If file is being re-opened then we must adjust its placement
               in the MRU filelist */
            ELSE RUN MRUList ( INPUT p_File_Name ).
            &ENDIF
        END.     /* Modified */


        /* --- Begin SCM changes --- */
        IF ( p_Return_Status = TRUE ) THEN
        DO:
          /* Check with source code control programs and see if we really
           * should reopen/close the file. [Save the scm_context and file name
           * so that we can report the event after the file has closed.]
           */
          ASSIGN scm_context  = STRING(Edit_Buffer.hbuffer)
                 scm_filename = Edit_Buffer.hbuffer:PRIVATE-DATA.
          RUN adecomm/_adeevnt.p 
                 (INPUT "Editor", INPUT "Before-Open", INPUT ?, INPUT scm_filename,
                  OUTPUT p_Return_Status).

          IF ( p_Return_Status = TRUE ) THEN
             RUN adecomm/_adeevnt.p 
                 (INPUT "Editor", "Before-Close", scm_context, scm_filename,
                  OUTPUT p_Return_Status ).
        END.
        /* --- End SCM changes ----- */
            

        IF ( p_Return_Status = TRUE ) THEN
        DO: /* Re-open. */
              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , 
                                 "Re-opening file..." , "WAIT") . 
              ASSIGN
                  File_Name       = p_File_Name
                  Delete_Buffer   = Edit_Buffer.hBuffer
              . /* END ASSIGN. */
              IF SESSION:WINDOW-SYSTEM = "TTY" THEN 
                  RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).
              RUN FileOpen ( INPUT win_ProEdit , INPUT File_Name ,
                             INPUT TRUE ,
                             INPUT-OUTPUT p_Current_Buffer ).
              IF SESSION:WINDOW-SYSTEM <> "TTY" THEN 
                  RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).

              /* --- Begin SCM changes --- */
              RUN adecomm/_adeevnt.p 
                  (INPUT "Editor", "Close", scm_context, scm_filename, 
                   OUTPUT scm_ok ).
              /* --- End SCM changes ----- */

              RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 
              APPLY "ENTRY" TO p_Current_Buffer.
        END.     /* Re-open. */   
      END.  /* File already open in editor buffer. */
      /* ELSE - File is not already open, so caller should open it. */
      RETURN .
  END. /* proc-main */

END PROCEDURE .


PROCEDURE FileOpen:
/*----------------------------------------------------------------------------

Syntax:
        RUN FileOpen
            ( INPUT        p_Assign_Window ,
              INPUT        p_OpenList ,
              INPUT        p_ReOpen ,
              INPUT-OUTPUT p_Current_Buffer ).

Description:

  Opens a buffer for one or more existing files and assigned the buffer
  to the specified window.

INPUT Parameters

  p_Assign_Window  WIDGET-HANDLE        
          Editor window files are assigned to.

  p_OpenList       CHARACTER            
          Comma-delimited list of files to open.  Files are opened in the 
          same order as the list (creating a buffer list in the same
          order as well). The first file in the list is always made
          the current buffer (see p_Current_Buffer).

  p_ReOpen         LOGICAL
          If TRUE, Editor will not attempt to check if file is already
          open in the editor.  If FALSE, it will check and not allow
          the file to be reopened.

INPUT-OUTPUT Parameters
  p_Current_Buffer WIDGET-HANDLE
        IN :  Handle to current editor buffer.
        OUT:  Handle to current editor buffer.  This probably is a different
              buffer, since one or more files have been opened.  


Author: John Palazzo

Date Created: 08.05.92 

----------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER p_Assign_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT        PARAMETER p_OpenList       AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER p_ReOpen         AS LOGICAL   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Current_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  /* PROGRESS Preprocessor Message Number - 104:
     Invalid Characters were replaced with blanks. (104)
  */
  &SCOPED-DEFINE MSG-104       104

  DEFINE VARIABLE List_Item    AS INTEGER       NO-UNDO.
  DEFINE VARIABLE File_to_Open AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE Search_File  AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE hCur_Buffer  AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE In_Library   AS CHAR          NO-UNDO.
  DEFINE VARIABLE Read_OK      AS LOGICAL       NO-UNDO.
  DEFINE VARIABLE Open_Msg     AS CHARACTER     NO-UNDO.
  
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context  AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */
  
  DEFINE VARIABLE Valid_BufName AS LOGICAL NO-UNDO .

  IF LENGTH( p_OpenList ) = 0 THEN RETURN.
  
  OPEN_BLOCK:
  DO List_Item = 1 TO NUM-ENTRIES( p_OpenList ) :

    /* Save whandle to current buffer in case of read-file failure. */
    hCur_Buffer  = p_Current_Buffer.
    
    /* Get file to open and the search name. */
    File_to_Open = ENTRY( List_Item , p_OpenList ).

    ASSIGN scm_ok = TRUE.
    IF ( p_ReOpen = FALSE ) THEN
    DO:
        RUN BufValidName ( INPUT ? , INPUT File_to_Open ,
                            OUTPUT Valid_BufName ).
        IF NOT Valid_BufName THEN NEXT OPEN_BLOCK.

        /* --- Begin SCM changes --- */
        RUN adecomm/_adeevnt.p 
               (INPUT "Editor", INPUT "Before-Open", INPUT ?, INPUT File_to_Open, OUTPUT scm_ok).
        IF NOT scm_ok AND VALID-HANDLE(hCur_Buffer) THEN
          NEXT OPEN_BLOCK. /* SCM Cancelled Open. */
        /* --- End SCM changes ----- */
    END.

    
    /* OpenNewBuffer */
    RUN CreateBuffer ( INPUT p_Assign_Window, OUTPUT p_Current_Buffer ).
    RUN AssignBuffer
        ( INPUT p_Current_Buffer , INPUT File_to_Open ).
    
    ASSIGN FILE-INFO:FILE-NAME = File_to_Open
           Search_File         = FILE-INFO:FULL-PATHNAME.

    /* Try to read file to newly created, but not visible buffer. */
    ASSIGN Read_OK = scm_ok NO-ERROR. /* Clear ERROR-STATUS. */
    IF scm_ok THEN ASSIGN Read_OK = p_Current_Buffer:READ-FILE( Search_File ) NO-ERROR.

    /* If its Invalid Characters message, show it and open the file. */
    IF ERROR-STATUS:GET-NUMBER(1) = {&MSG-104} THEN
    DO ON STOP UNDO, LEAVE:
        MESSAGE File_to_Open SKIP
                ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
    END.

    IF (Read_OK = FALSE) THEN
    DO:
      IF scm_ok THEN
      DO:
        ASSIGN In_Library = LIBRARY( File_to_Open ).
        IF ( In_Library <> ? ) THEN
          /* 1. File in R-code Library. */
          ASSIGN Open_Msg = "File is in R-code Library " +
                             In_Library + ".":U .
        ELSE DO:
          /* 2. Path or Filename incorrect. */
          ASSIGN FILE-INFO:FILE-NAME = File_to_Open.
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
      END. /* scm */

      DO ON STOP UNDO, LEAVE:
        MESSAGE File_to_Open        SKIP
                "Cannot open file." SKIP(1)
                Open_Msg            SKIP
                "Creating Untitled buffer in its place."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      END.
        
      /* Get rid of newly created buffer */
      RUN DeleteBuffer ( INPUT-OUTPUT p_Current_Buffer ).
      /* Create an Untitled buffer in its place. */
      RUN NewFile.
      ASSIGN p_Current_Buffer = ProEditor
             File_Name        = p_Current_Buffer:PRIVATE-DATA
      . /* END ASSIGN */
    END.

    ELSE 
    DO:
      /* Set the editor source type to get 4GL syntax highlighting.
       * Refer to comment in adecomm/_pwmain.p */
      /* adecomm/peditor.i */
      RUN SetEdBufType (INPUT p_Current_Buffer, INPUT Edit_Buffer.Buffer_Name).

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
        (INPUT  "Editor", "Open", STRING(p_Current_Buffer), File_to_Open, 
         OUTPUT scm_ok).
      /* --- End SCM changes ----- */
    END.

  END. /* DO List_Item */


/* --- Begin SCM changes --- */
/* Because "File Open" from another source (such as an SCM) could
 * potentially return a list of files to open, we want to try to position
 * on the first file in the new list, rather than on the first edit buffer.
 */
  IF ( NUM-ENTRIES( p_OpenList ) > 1 )
  THEN DO:
      FIND FIRST Edit_Buffer
           WHERE Edit_Buffer.Buffer_Name = ENTRY( 1 , p_OpenList )
           NO-ERROR.
      IF NOT AVAILABLE Edit_Buffer THEN FIND FIRST Edit_Buffer.
      ASSIGN p_Current_Buffer = Edit_Buffer.hBuffer
             File_Name        = p_Current_Buffer:PRIVATE-DATA
      . /* END ASSIGN */
  END.
/* --- End SCM changes ----- */


  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN hCur_Buffer:VISIBLE = FALSE NO-ERROR.
  &ENDIF

  /* Display the new current buffer. */
  RUN MakeCurrent ( INPUT p_Assign_Window , INPUT p_Current_Buffer ).
    
END PROCEDURE.  /* FileOpen. */


PROCEDURE SaveFile:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE command, saving contents of edit
                    buffer to current file name. Allows user to continue
                    editing uninterrupted.

    Run Syntax:     RUN SaveFile ( INPUT p_Buffer ) .

    Parameters:
        
    Description:
        1.  Test if the file is "untitled".
        2.  If untitled, execute the Save As Dialog, allowing
            user to enter a file name to save.
        3.  Write contents of edit buffer to File_Name.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .
  
  DEFINE VARIABLE File_Selected AS CHARACTER NO-UNDO.
  DEFINE VARIABLE SF_OK         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Old_Filename  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTempDBLib    AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables       AS CHARACTER NO-UNDO.
  
  ASSIGN Saved_File = FALSE.               /* system var */
  IF p_Buffer:PRIVATE-DATA  BEGINS Untitled THEN
  DO:
    RUN SaveAsFile ( INPUT p_Buffer ).
    RETURN RETURN-VALUE.
  END.
  ELSE
  DO:
      ASSIGN File_Selected = p_Buffer:PRIVATE-DATA.
      RUN FileSave ( INPUT p_Buffer , INPUT File_Selected , OUTPUT SF_OK ).
      IF SF_OK = TRUE THEN
      DO:
        IF CONNECTED ("TEMP-DB") THEN
        DO:
          RUN adeuib/_tempdbvalid.p (OUTPUT lOK). /* Check that control file is present in TEMP-DB */
          IF lOK THEN
          DO:          
            GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBIntegration":U VALUE cValue.
            IF CAN-DO ("true,yes,on",cValue) THEN
            DO:
              GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBExtension":U VALUE cValue.
              IF cValue > "" AND File_Selected MATCHES cValue THEN 
              DO:
                RUN adecomm/_relname.p (INPUT File_Selected, INPUT "", OUTPUT cRelName).
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
        
        RETURN.
      END.  
      ELSE
        RETURN "_CANCEL":U.
  END.

END.    /* SaveFile */


PROCEDURE SaveAsFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE AS command, saving contents of edit
                    buffer to a user selected file name.

    Run Syntax:     RUN SaveAsFile ( INPUT p_Buffer ) .

    Parameters:

    Description:

        1. Prompts user for name of file to save current edit buffer
           contents to.
        2. Calls SaveFile procedure to execute actual save.

        Users execute the SAVE AS command to:
            1.  Save an Untitled file.
            2.  Save an existing file to a different file name.

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE File_Selected AS CHAR     NO-UNDO.
  DEFINE VARIABLE Was_Saved     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE SA_OK         AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE Old_Filename  AS CHAR     NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL  NO-UNDO.
  
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .
  IF (p_Buffer:PRIVATE-DATA BEGINS Untitled) THEN
  DO:
    /* When Exiting, help user out with default name, otherwise they don't
       know which of several buffers they are closing. */
    IF (PROGRAM-NAME(3) BEGINS "CloseAllBuffers":U) THEN
        ASSIGN File_Selected = REPLACE(p_Buffer:PRIVATE-DATA , ":" , "" ) + ".p":U.
  END.
  ELSE ASSIGN File_Selected = p_Buffer:PRIVATE-DATA.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

  SAVE_AS_BLOCK:
  DO WHILE TRUE:

    RUN adeedit/_dlggetf.p
        ( INPUT "Save As" ,
          INPUT YES ,
          INPUT 1 /* Initial_Filter */ ,
          INPUT-OUTPUT File_Selected ,
          OUTPUT SA_OK ) .

    IF NOT SA_OK THEN RETURN "_CANCEL":U. /* User pressed Cancel. */
    RUN BufValidName ( INPUT p_Buffer , INPUT File_Selected ,
                       OUTPUT Valid_BufName ).
    IF NOT Valid_BufName THEN NEXT SAVE_AS_BLOCK.
    
    RUN FileSave ( INPUT p_Buffer , INPUT File_Selected  ,
                   OUTPUT Was_Saved ).
    IF ( Was_Saved = TRUE ) THEN DO:
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      /* If a new file is saved or an existing file is saved as, the file
         name must be added to the MRU filelist */
      RUN MRUList ( INPUT File_Selected ).
      &ENDIF
      LEAVE SAVE_AS_BLOCK.
    END.  /* if was_saved true */

  END. /* DO */
  RETURN.
END PROCEDURE.  /* SaveAsFile */


PROCEDURE FileSave:
  /*--------------------------------------------------------------------------
    Purpose:        Low-level routine to save buffer contents to os file.
                    Updates Window Title if file name has changed.

    Run Syntax:     RUN FileSave ( INPUT p_Buffer , 
                                   INPUT p_File_Selected ,
                                   OUTPUT p_Saved_File ) .

    Parameters:
        
    Description:

    Notes:
  ---------------------------------------------------------------------------*/
 
  DEFINE INPUT PARAMETER p_Buffer        AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Selected AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File   AS LOGICAL NO-UNDO.
  
  DEFINE VAR Old_BufName AS CHAR NO-UNDO .
  DEFINE VAR Save_OK     AS LOGICAL NO-UNDO.
   
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Saving file..." , "WAIT" ) .
    ASSIGN
        Old_BufName       = p_Buffer:PRIVATE-DATA  /* Store old name. */
        p_Buffer:PRIVATE-DATA = p_File_Selected.  /* Assign new name. */
    RUN SaveBuffer ( INPUT p_Buffer , OUTPUT Save_OK ).
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
    IF ( Save_OK = FALSE )
    THEN DO:
        ASSIGN
            p_Buffer:PRIVATE-DATA = Old_BufName
            p_Saved_File      = FALSE
            Saved_File        = FALSE
        .
        RETURN.
    END.
    
    Saved_File   = TRUE.  /* Global status var. */
    p_Saved_File = TRUE.

    IF ( p_Buffer:PRIVATE-DATA <> Old_BufName )
    THEN DO:    /* Filename changed (new name, from untitled, etc.. */
      RUN BufRename ( INPUT p_Buffer , INPUT p_File_Selected ).
      IF ( p_Buffer = ProEditor ) /* Was the Current Buffer Renamed? */
      THEN DO:
        RUN WinSetTitle ( win_ProEdit , p_Buffer:PRIVATE-DATA ) .
        File_Name = p_File_Selected. /* Global File Name var */
      END.
    END.
    
END PROCEDURE.  /* FileSave */



PROCEDURE CloseFile:

  /*--------------------------------------------------------------------------
    Purpose:        Executes CLOSE File Command, which closes the current
                    buffer.
    
    Run Syntax:     RUN CloseFile ( INPUT p_Buffer ).

    Parameters:

    Description:
            -   If file in current buffer has been modified, allows user
                to save changes before closing buffer.
            -   If file in current buffer is untitled, prompts user for
                a name to save the file as.
            -   When current buffer is deleted the prev buffer in the
                window's buffer list becomes current.
            -   If the current buffer is the only open buffer in the
                window's buffer list, then it is made an Untitled 
                buffer.
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Message_Response AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Delete_Buffer AS WIDGET-HANDLE NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok     AS LOGICAL           NO-UNDO.
  DEFINE VAR scm_context  AS CHAR              NO-UNDO.
  DEFINE VAR scm_filename AS CHAR              NO-UNDO.
  /* --- End SCM changes ----- */
  
  RUN FileChanged(INPUT p_Buffer , OUTPUT Message_Response).
  IF Message_Response = ? THEN RETURN.  /* Cancel */
  IF Message_Response = YES THEN
  DO:
    RUN SaveFile ( INPUT p_Buffer ).
    IF NOT Saved_File THEN RETURN.  /* Global SysVar */
  END.


  /* --- Begin SCM changes --- */
  /* Check with source code control programs and see if we really should close 
     the file.  [Save the scm_context and file name so that we can report the
     event after the file has closed.] */
  ASSIGN scm_context  = STRING(p_Buffer)
         scm_filename = p_Buffer:PRIVATE-DATA.
  RUN adecomm/_adeevnt.p 
         (INPUT "Editor", "Before-Close", scm_context, scm_filename,
          OUTPUT scm_ok).
  /* --- End SCM changes ----- */

  /* --- Begin SCM changes --- */
  IF scm_ok THEN DO:
  /* --- End SCM changes ----- */
 
    RUN WinStatusMsg
      ( win_ProEdit , "MT_INPUT" , "Closing buffer..." , "WAIT") . 
    ASSIGN Delete_Buffer = p_Buffer .

    /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p
         (INPUT "Editor", "Close", scm_context, scm_filename,
          OUTPUT scm_ok).
    /* --- End SCM changes ----- */

    IF ( p_Buffer = ProEditor )
    THEN DO: 
      /* p_Buffer is Current Buffer, so update editor current buffer. */ 
      /* Determine if window has another buffer to make current. */
      RUN NumBuffers ( INPUT win_ProEdit, OUTPUT Buffers_Open ).
      IF Buffers_Open > 1 
        THEN RUN PrevBuffer.       /* Make prev buffer current. */
        ELSE RUN NewFile.          /* Make a new untitled buffer. */
      File_Name = ProEditor:PRIVATE-DATA.
    END.
    
    RUN DeleteBuffer ( INPUT-OUTPUT Delete_Buffer ).
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) . 

    /*  IF ( SESSION:WINDOW-SYSTEM = "TTY" )
    THEN   /* Prevents clipping problems in VV. */ */
    APPLY "ENTRY" TO ProEditor.

  /* --- Begin SCM changes --- */
  END.   /* IF scm_ok */
  /* --- End SCM changes ----- */


END PROCEDURE.  /* CloseFile */


PROCEDURE FilePrintCall:
/* Internal Call to FilePrint. Added to keep backwards compatibility
   for FilePrint. */

  RUN FilePrint (INPUT ProEditor).

END PROCEDURE.


PROCEDURE FilePrint:

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Return_Status AS LOGICAL NO-UNDO.
  DEFINE VAR Printed       AS LOGICAL NO-UNDO.
  DEFINE VAR vModified     AS LOGICAL NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  Compile_FileName = Edit_Buffer.Compile_Name.

  _PRINT_BLOCK:
  DO ON STOP UNDO _PRINT_BLOCK , RETRY _PRINT_BLOCK:

  IF NOT RETRY THEN
  DO:
    IF p_Buffer:EMPTY THEN
    DO:
      MESSAGE "Nothing in this buffer to print."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END.

    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "Printing procedure..." , 
                       "" ) .
    /* In Windows, we put up a dialog box. So we don't need the wait. */
    IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
        RUN adecomm/_setcurs.p ( INPUT "WAIT" ).
        
    ASSIGN vModified         = p_Buffer:MODIFIED
           Return_Status     = p_Buffer:SAVE-FILE( Compile_FileName )
           p_Buffer:MODIFIED = vModified
    . /* END ASSIGN */

    /* adecomm/peditor.i */
    RUN SetEdBufType (INPUT p_Buffer, INPUT p_Buffer:PRIVATE-DATA).
    
    IF SESSION:WINDOW-SYSTEM = "TTY":U THEN
    DO:
       OUTPUT STREAM ttyStream TO VALUE(Compile_FileName) APPEND NO-ECHO.
       PUT STREAM ttyStream UNFORMATTED SKIP(2).
       OUTPUT STREAM ttyStream CLOSE. 
    END.
    RUN adecomm/_osprint.p ( INPUT win_ProEdit,
                             INPUT Compile_FileName,
                             INPUT p_Buffer:FONT,
                             INPUT 1 + /* use print dialog */
                               (IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0),
                             INPUT 0, /* page size */
                             INPUT 0, /* page count */
                             OUTPUT Printed ) .
  END. /* NOT RETRY */

  OS-DELETE VALUE( Compile_FileName ) .
  IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
      RUN adecomm/_setcurs.p ( INPUT "" ).
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  /* This is just to be sure the user winds up in the editor. */
  APPLY "ENTRY" TO p_Buffer.
  
  END. /* DO ON STOP */

END PROCEDURE. /* FilePrint */


PROCEDURE ExitEditor:

  /*--------------------------------------------------------------------------
    Purpose:        Executes the EXIT command, exiting the PROGRESS Editor.

    Run Syntax:     RUN ExitEditor.

    Parameters:

    Description:
        1. Allow user chance to save any changes to open buffers.

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE VARIABLE filekey    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE mru_actual AS INTEGER   NO-UNDO.
  DEFINE VARIABLE mru_count  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ok_save    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE v          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_v        AS CHARACTER NO-UNDO.
  
  /* Save settings is done in the various dialogs and not on exit anymore.
     Except for MRU. */
  
  APPLY "U9":U TO win_ProEdit.
  
  RUN CloseWindow( INPUT-OUTPUT win_ProEdit ).
  /* At this point, Saved_File will = ? if user cancelled Exit. 
     This is detected by main wait-for and we re-enter it.
  */

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  /* Save the MRU File list to the registry for non-tty. */
  PUTMRU-BLOCK:
  DO ON STOP  UNDO PUTMRU-BLOCK, LEAVE PUTMRU-BLOCK
     ON ERROR UNDO PUTMRU-BLOCK, LEAVE PUTMRU-BLOCK:

    mru_count = 1.
    mru_actual = Sys_Options.MRU_Entries.
    DO WHILE mru_count < 10:
      ASSIGN filekey = "MRUFile" + STRING(mru_count).
      GET-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE v.
      FIND MRU_Files where MRU_Files.mru_position = mru_count NO-ERROR.
      IF AVAILABLE MRU_Files THEN DO:
        IF mru_count <= mru_actual THEN DO:
          c_v = MRU_Files.mru_file.
          IF v NE c_v THEN
          DO:
            PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE c_v NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP.
          END.
        END.  /* if mru_count <= mru entries */
        ELSE DO:
          PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE ? NO-ERROR.
          IF ERROR-STATUS:ERROR THEN STOP.
        END.  /* else do - mru_count > mru entries */    
      END.  /* if avail MRU_Files */
      ELSE DO:
        PUT-KEY-VALUE SECTION KeyValue_Section KEY filekey VALUE ? NO-ERROR.
        IF ERROR-STATUS:ERROR THEN STOP.
      END.  /* else do MRU_Files not avail */
      mru_count = mru_count + 1 NO-ERROR.
    END.  /* do while */    
    
    /* If we got here, then all desired save were successful. */
    ok_save = yes.

  END.  /* putprefs-block */
  
  /* Don't report save errors. They are annoying. jep. */
  /* IF ok_save = NO THEN
    RUN adeshar/_puterr.p ( INPUT "Most Recently Used File" , INPUT ProEditor ). */
  
  /* Remove internally maintained MRU Filelist */
  FOR EACH MRU_Files:
    DELETE MRU_Files.
  END.  /* for each mru */
  &ENDIF
  
END PROCEDURE.  /* ExitEditor */


PROCEDURE AddtoRepos:
  /*--------------------------------------------------------------------------
    Purpose:        Executes the Add to Repository command (Dynamics Only) on
                    the current buffer. User can then add file to repository.

    Run Syntax:     RUN AddtoRepos.
    Parameters:
    Description:
    Notes:          Added to support IZ 2513 Error when trying to save
                    structured include in Dynamics framework.
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE hWindow     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Add_OK      AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE FileExt     AS CHARACTER NO-UNDO.
  
  DO ON STOP UNDO, LEAVE:
      /* Need window handle of this editor widget. */
      hWindow = ProEditor:WINDOW.
             
      /* Cannot add untitled / unsaved files to repository. */
      IF ProEditor:PRIVATE-DATA BEGINS Untitled THEN
      DO:
          MESSAGE "Cannot add to repository:" ProEditor:PRIVATE-DATA SKIP(1)
                  "The file must be saved before it can be added to a repository."
                  VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
          RETURN.
      END.

      /* IZ 2513 Cannot add include files to repository. We can only filter on .i extensions. */
      RUN adecomm/_osfext.p
          (INPUT  ProEditor:PRIVATE-DATA  /* OS File Name.   */ ,
           OUTPUT FileExt                 /* File Extension. */ ).
      IF (FileExt = ".i":U) THEN
      DO:
        MESSAGE "Cannot add to repository:" ProEditor:PRIVATE-DATA SKIP(1)
                "Include file types cannot be added to a repository."
                VIEW-AS ALERT-BOX INFORMATION IN WINDOW hWindow.
        RETURN.
      END.
  
      /* Call to run Add to Repository dialog and add file to repository. */
      RUN adeuib/_reposaddfile.p
          (INPUT hWindow,                /* Parent Window    */
           INPUT ?,                      /* _P recid         */
           INPUT "",                     /* Product Module   */
           INPUT ProEditor:PRIVATE-DATA, /* File to add      */
           INPUT "",                     /* File type        */
           OUTPUT Add_OK).
  END.
  
END.    /* AddtoRepos */


/* pfile.i -  end of file */


