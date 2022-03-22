/*********************************************************************
* Copyright (C) 2005,2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  pbuffers.i
  Buffer and Buffer List Mgt Procedures for Editor.
---------------------------------------------------------------------------*/


PROCEDURE OpenWindow.
  /*---------------------------------------------------------------------
      Opens a top-level editor window.
  ----------------------------------------------------------------------*/
 
  /* Don`t create a window under TTY. Just assign as default window. */
  IF SESSION:WINDOW-SYSTEM <> "TTY" 
    THEN RUN CreateWindow ( OUTPUT win_ProEdit ).
    ELSE win_ProEdit = DEFAULT-WINDOW.
  
  RUN MakeEditWin ( INPUT win_ProEdit ).
  
  CURRENT-WINDOW = win_ProEdit.
  VIEW win_ProEdit.
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
  /* Assign W x H needed for Window RESIZE and MAXIMIZE. */
  ASSIGN
    win_ProEdit:MAX-WIDTH  = ?
    win_ProEdit:MAX-HEIGHT = ? .

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .


  /* --- Begin SCM changes --- */
  /* Do custom setup -- this file is generally a no-op, but it can
     be used to initialize custom modifications. */
  DEFINE VARIABLE scm_ok AS LOGICAL NO-UNDO.
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "STARTUP", INPUT STRING(THIS-PROCEDURE), INPUT STRING(win_ProEdit),
        OUTPUT scm_ok ).
  /* --- End SCM changes ----- */


  ASSIGN
    /* w and h of frame for proedit's editing window area. */
    FRAME f_Buffers:SCROLLABLE  = NO
    FRAME f_Buffers:WIDTH       = win_ProEdit:WIDTH
    FRAME f_Buffers:HEIGHT      = win_ProEdit:HEIGHT
    FRAME f_Buffers:SENSITIVE   = TRUE
  . /* END ASSIGN */

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* Attach Char Mode top and bottom editor bars and current buffer name. */
  RUN CreateEditorBars( INPUT FRAME f_Buffers:HANDLE , OUTPUT hCur_Buf_Name ).
  &ENDIF

  VIEW FRAME f_Buffers IN WINDOW win_ProEdit.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  
END PROCEDURE.  /* OpenWindow */
  

PROCEDURE CreateWindow .
  /*---------------------------------------------------------------------
      Creates a window and returns its window handle.
  ---------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  CREATE WINDOW p_Window
    ASSIGN
      MAX-WIDTH      = ?
      MAX-HEIGHT     = ?
      MIN-WIDTH      = 1 /* Zero is not acceptable to UIM */
      MIN-HEIGHT     = 1
      SCROLL-BARS    = NO
      RESIZE         = YES
      DROP-TARGET    = TRUE
      SENSITIVE      = TRUE
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          TITLE        = Editor_Name  /* System Var in dsystem.i */ 
          MESSAGE-AREA = NO
      &ENDIF
      
      TRIGGERS:
        ON WINDOW-CLOSE PERSISTENT
          RUN _winevnt.p ( INPUT "ED_WINDOW_CLOSE" ) .
        ON WINDOW-RESIZED PERSISTENT
          RUN adeedit/_winrsz.p ( INPUT p_Window ).
        ON DROP-FILE-NOTIFY PERSISTENT
          RUN OpenFile IN THIS-PROCEDURE.
      END
      
    . /* END ASSIGN */
  
  ASSIGN
    p_Window:WIDTH          = FONT-TABLE:GET-TEXT-WIDTH(FILL("0", 85), editor_font)
    p_Window:HEIGHT         = (SESSION:HEIGHT * 0.66)
    p_Window:VIRTUAL-WIDTH  = SESSION:WIDTH
    p_Window:VIRTUAL-HEIGHT = SESSION:HEIGHT
    NO-ERROR.

END PROCEDURE.  /* CreateWindow */


PROCEDURE MakeEditWin .
  /*---------------------------------------------------------------------
      Makes a window an editor window.
      
      - Assigns standard editor menubar and adds to window list.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Return_Status AS LOGICAL NO-UNDO.

  RUN MenuBarSet(p_Window).
  
  /* :ACCELERATOR not supported under TTY, so skip it. */
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
  THEN DO:
      /* Load the Editor's minimized icon. */
      Return_Status = p_Window:LOAD-ICON("adeicon/edit%").
      /* Read accelerator key settings from Env File, if necessary. */
      IF ( g_Editor_Cached_Accels = "" )
      THEN DO:
        RUN adecomm/_mnkvals.p ( INPUT p_Window:MENUBAR , INPUT "GET" , 
                                INPUT KeyValue_Section ,
                                INPUT Exclude_Menus /* see dsystem.i */ , 
                                OUTPUT g_Editor_Cached_Accels ).
      END.
  END.
  /* Initialize accelerators and enable states. */
  RUN MenuInit.

  FIND FIRST Edit_Window WHERE Edit_Window.hWindow = p_Window NO-ERROR.
  IF NOT AVAILABLE Edit_Window THEN
  DO:
    CREATE /* WORKFILE */ Edit_Window.
    ASSIGN
      Edit_Window.hWindow = p_Window.
  END.
    
END PROCEDURE.  /* MakeEditWin */



PROCEDURE CreateBuffer .
  /*---------------------------------------------------------------------
      Creates an editor buffer for a window and returns its buffer handle.
      
      - Adds buffer to p_Window's buffer list.
      - Does NOT make buffer visible by default.  This is deliberate 
        and making it visible here may screw up other procedures.

      Note: We substract 2 from the editor height for tty to make room
            for the display of the editor bars and current buffer name.
            See PROCEDURE WinSetTitle for actual disp of buffer name
            and PROCEDURE CreateEditorBars as well.
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  CREATE EDITOR p_Buffer
    ASSIGN
      FRAME          = FRAME f_Buffers:HANDLE
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      ROW            = 2
      &ENDIF
      WIDTH          = FRAME f_Buffers:WIDTH -
                       ( FRAME f_Buffers:BORDER-LEFT + 
                         FRAME f_Buffers:BORDER-RIGHT )
      HEIGHT         = FRAME f_Buffers:HEIGHT -
                       ( FRAME f_Buffers:BORDER-TOP +
                         FRAME f_Buffers:BORDER-BOTTOM )
                       - IF ( SESSION:WINDOW-SYSTEM = "TTY" )
                         THEN 2
                         ELSE 0
      PROGRESS-SOURCE = YES        /* TTY - For Proper wrapping. */
      WORD-WRAP      = FALSE
      SCROLLBAR-H    = ( SESSION:WINDOW-SYSTEM <> "TTY" )
      SCROLLBAR-V    = ( SESSION:WINDOW-SYSTEM <> "TTY" )
      AUTO-INDENT    = TRUE
      RETURN-INSERTED = TRUE
      FONT           = Sys_Options.EditorFont
      BGCOLOR        = Sys_Options.BG_Color
      FGCOLOR        = Sys_Options.FG_Color
      /* Since widget is not realized, safe to assign pfcolor under GUI. */
      PFCOLOR        = 0
      PRIVATE-DATA   = Untitled
      LARGE          = TRUE
      
    TRIGGERS:
    
      {adeedit/dbftrigs.i}
     
    END.

  RUN SetEditor (INPUT p_Buffer).   /* adecomm/peditor.i */
  ASSIGN p_Buffer:SENSITIVE = TRUE.
  
  /* Add buffer to Buffer List which attaches buffer to a window. */
  FIND LAST Edit_Buffer NO-ERROR. /* List is in Chronological order. */
  CREATE /* WORKFILE */ Edit_Buffer.
  ASSIGN
     Edit_Buffer.hWindow = p_Window
     Edit_Buffer.hBuffer = p_Buffer
     Edit_Buffer.File_Name = Untitled.
     
END PROCEDURE.  /* CreateBuffer */


PROCEDURE AssignBuffer .
  /*---------------------------------------------------------------------
     Assigns the buffer to a file.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Name AS CHAR NO-UNDO.

  DEFINE VARIABLE File_Ext AS CHARACTER   NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
 
   /*------------------------------------------------------------------------ 
      Buffer:PRIVATE-DATA is actually Edit_Buffer.Buffer_Name.  This represents
      the name the user used to open the file.  This can be different than
      Buffer.File_Name.  e.g., "PROC1.p" is buffer name, "C:\APPL\AR\PROC1.p" is
      original fullpath file name.
   ------------------------------------------------------------------------*/
  ASSIGN p_Buffer:PRIVATE-DATA   = p_File_Name
         Edit_Buffer.Buffer_Name = p_File_Name .
  /*---------------------------------------------------------------------- 
     Note:  E_B:File_Name is the fullpath name of the os file from which buffer
     was originally read. 
  --------------------------------------------------------------------- */
  ASSIGN FILE-INFO:FILENAME    = p_File_Name
         Edit_Buffer.File_name = FILE-INFO:FULL-PATHNAME.

  /* adecomm/peditor.i */
  RUN SetEdBufType (INPUT p_Buffer, INPUT p_File_Name).

  RUN adecomm/_uniqfil.p (p_File_Name, ".ped", OUTPUT Edit_Buffer.Compile_Name).

  /* If this is a .cls file, set the CLASS_TYPE to "" to indicate this.
   * As long as it is not ?, we know it is a .cls, and can set it 
   * with the correct class namespace later. */
  RUN adecomm/_osfext.p(INPUT  p_File_Name, OUTPUT File_Ext).
  IF (File_Ext = ".cls") THEN
    Edit_Buffer.Class_Type = "".

END PROCEDURE.  /* AssignBuffer */


PROCEDURE BufReName .
  /*---------------------------------------------------------------------
     Renames a buffer's Buffer Name.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Name AS CHAR NO-UNDO.

  DEFINE VARIABLE File_Ext AS CHARACTER   NO-UNDO.

  /* We don't need p_Window because buffer handles are unique system-wide. */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
 
   /*-------------------------------------------------------------------- 
      Buffer:PRIVATE-DATA is actually Edit_Buffer.Buffer_Name.  This represents
      the name the user used to open the file.  This can be different than
      Buffer.File_Name.  e.g., "PROC1.p" is buffer name, "C:\APPL\AR\PROC1.p" is
      original fullpath file name.
   --------------------------------------------------------------------*/
  p_Buffer:PRIVATE-DATA   = p_File_Name.
  Edit_Buffer.Buffer_Name = p_File_Name .

  /* adecomm/peditor.i */
  RUN SetEdBufType (INPUT p_Buffer, INPUT p_File_Name).

  RUN adecomm/_uniqfil.p (p_File_Name, ".ped", OUTPUT Edit_Buffer.Compile_Name).
      
  /* check for .cls extension */
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :
      RUN adecomm/_osfext.p (INPUT  p_File_Name,OUTPUT File_Ext).
  END. /* DO ON STOP */
  /* If this is a class file, reset the Class_Type.
   * We will only be able to get the namespace name from the COMPILER handle. 
   * But set this to something that is not ?, so we know it is a class. 
   * The later compilation (RunFile()) will set it correctly.
   * For non-.cls files, this should be ?.
   */
  Edit_Buffer.Class_Type = (IF FILE_Ext = ".cls" THEN "" ELSE ?).

END PROCEDURE.  /* BufRename */


PROCEDURE MakeCurrent .
  /*---------------------------------------------------------------------
     Makes a buffer the current buffer for p_Window and
     Assigns a title to the window. 
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VAR Temp_Var AS LOGICAL NO-UNDO.
  DEFINE VAR hTemp    AS HANDLE  NO-UNDO.

  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  RUN WinSetTitle( INPUT p_Window , INPUT Edit_Buffer.hBuffer:PRIVATE-DATA ) .

  &IF DEFINED(ED_POPUP) &THEN
  /* Assign popup menu to current buffer. */
  ASSIGN hTemp               = MENU mnu_EdPopup:OWNER
         hTemp:POPUP-MENU    = ? NO-ERROR.
  ASSIGN p_Buffer:POPUP-MENU = MENU mnu_EdPopup:HANDLE.
  &ENDIF
  
  p_Buffer:VISIBLE = TRUE.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  Temp_Var = p_Buffer:MOVE-TO-TOP().
  &ENDIF

  APPLY "ENTRY" TO p_Buffer.

  /* Updating ProEditor provides calls to _adeevnt.p with
     the correct current buffer handle. */
  ASSIGN ProEditor = p_Buffer.

END PROCEDURE.  /* MakeCurrent */



PROCEDURE CreateUntitledBufName .
  /*---------------------------------------------------------------------
  ---------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_Untitled_BufName AS CHAR NO-UNDO.
  
  Num_Untitled_Buffers = Num_Untitled_Buffers + 1.
  p_Untitled_BufName = Untitled +
  			TRIM( STRING( Num_Untitled_Buffers , ">>9" ) ).
  			  	
END PROCEDURE.  /* CreateUntitledBufName */



PROCEDURE CloseWindow.
  /*---------------------------------------------------------------------
      Closes an editor window and deletes it from window list.
      Under GUI, ensures that any open Procedure Windows are also
      closed.
  ---------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
   
  DEFINE VARIABLE OK_Close AS LOGICAL NO-UNDO.

  /* Perform a close all for any open Procedure Windows belonging to
     the Procedure Editor. Not checked if TTY.
  */
  IF SESSION:WINDOW-SYSTEM <> "TTY" THEN
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_pwexit.p ( INPUT  "_edit.p":U /* PW Parent ID */ ,
                            OUTPUT OK_Close ).
  END.
  
  /*
  ** Changed by R. Ryan to fix bug 94-08-30-017. This fix allows the procedure
  ** windows cancel on exit to act like the close buffer's cancel.
  */
  IF OK_Close = ? THEN
  DO:
    Saved_File = ?.
    RETURN.
  END.
  
  ELSE
    ASSIGN OK_Close = TRUE.

  /* Cancel the close event? */
  IF OK_Close <> TRUE THEN RETURN.

  /* Saved_File tells us if user cancelled the close window because
     buffers were opened with unsaved changes. */
  RUN CloseAllBuffers( INPUT-OUTPUT p_Window ).
  IF Saved_File = ? THEN RETURN.

  /* --- Begin SCM changes --- */
  /* Do custom shutdown -- this is generally a no-op, but it can
     be used to cleanup custom modifications */
  DEFINE VARIABLE scm_ok  AS LOGICAL NO-UNDO.
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "SHUTDOWN", INPUT STRING(THIS-PROCEDURE), STRING(p_Window),
        OUTPUT scm_ok ).
  /* --- End SCM changes ----- */

  /*---------------------------------------------------------------------
     The following cleanup is only necessary for GUI platforms.
     Under TTY, editor window is DEFAULT-WINDOW.
  ---------------------------------------------------------------------*/
  IF SESSION:WINDOW-SYSTEM <> "TTY"
  THEN DO: 
    /* HIDE p_Window  - done in closeallbuffers too.                    */  
    p_Window:VISIBLE = NO . 
    p_Window:SENSITIVE = NO .

  
    /* Later, put in code here to go to next open window, if any.       */
    /*---------------------------------------------------------------------
       All buffers have been deleted at this point, so delete window.
    ---------------------------------------------------------------------*/
    RUN DeleteWindow( INPUT-OUTPUT p_Window ).
  END. /* TTY */
  
END PROCEDURE.  /* CloseWindow */


PROCEDURE CloseAllBuffers .
  /*---------------------------------------------------------------------
      Closes all buffers for specified window and deletes each buffer
      from the buffer list.
  ---------------------------------------------------------------------*/
  
  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Mod_List  AS CHAR NO-UNDO .
  DEFINE VARIABLE Save_List AS CHAR NO-UNDO .
  DEFINE VARIABLE vBuffer   AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE SA_OK     AS LOGICAL NO-UNDO .
  DEFINE VARIABLE SA_Filename AS CHAR NO-UNDO .
  DEFINE VARIABLE Old_Filename AS CHAR NO-UNDO .
  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO.

  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok       AS LOGICAL NO-UNDO.
  DEFINE VAR scm_context  AS CHAR    NO-UNDO.
  DEFINE VAR scm_filename AS CHAR    NO-UNDO.
  /* --- End SCM changes ----- */

  /* Editor System Flag for Exiting. */
  Saved_File = Sys_Options.Exit_Warning .  
 
  IF ( Sys_Options.Exit_Warning = YES )
  THEN DO:
  /* Build comma-delimited list of modified buffers. */
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
    RUN BufQMod ( Edit_Buffer.hBuffer , OUTPUT Buf_Modified ) . 
    IF ( Buf_Modified = FALSE ) THEN NEXT.
    Mod_List = Mod_List + Edit_Buffer.hBuffer:PRIVATE-DATA + ",".
  END.
  /* Trim-off trailing comma left over from building list. */ 
  Mod_List = IF Mod_List <> ""
  		THEN SUBSTRING( Mod_List , 1 , LENGTH( Mod_List ) - 1 )
  		ELSE "".

  IF NUM-ENTRIES( Mod_List ) <> 0
  THEN DO:
    Save_List = Mod_List.
    MESSAGE "You have buffers with changes that have not been saved." SKIP(1)
	    "Save changes before exiting?"
	    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL
                    UPDATE Saved_File .
    IF ( Saved_File = ? ) THEN RETURN .
    IF ( Saved_File = YES )
    THEN DO:
      /* Display Save Buffers with Changes dialog. */
      RUN adeedit/_dlgsbuf.p
          ( p_Window , "Save Buffers with Changes" , Mod_List , 
            OUTPUT Save_List ) .

      IF ( Save_List = ? )   
      THEN DO: 		   /* User pressed Cancel.                */
        Saved_File = ?.    /* Tells WAIT-FOR user pressed Cancel. */
        RETURN .
      END.

      IF Saved_File = YES
      THEN DO:
        FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:

          IF LOOKUP( Edit_Buffer.hBuffer:PRIVATE-DATA , Save_List ) = 0
          THEN NEXT.
          
          RUN SaveFile (Edit_Buffer.hBuffer).
          IF (RETURN-VALUE = "_CANCEL":U)
          THEN DO:
              ASSIGN SA_OK = YES.
              MESSAGE "Save cancelled. Continue Exit?"
                      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                              UPDATE SA_OK .
              IF ( SA_OK = YES ) THEN NEXT.
              ASSIGN Saved_File = ?. /* System var - ? means cancel Exit. */
              RETURN.
          END.
        END.  /* FOR EACH */
      END.  /* IF Saved_File = YES */
    END.  /* IF Saved_File = YES */
  END. /* Mod Buffers */
  END. /* Exit_Warning = Yes */
  
  /* Now delete the buffers.  We'll hide the window first. */
  ASSIGN p_Window:VISIBLE = FALSE.
  ASSIGN Sys_Options.BufList = "".  /* Always clear out buf list. */
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
      vBuffer = Edit_Buffer.hBuffer.

      /* --- Begin SCM changes --- */
      /* Check with source code control programs and see if we really should
       * close the file.  [Save the context and file name so that we can
       * report the event after the file has closed.]
       */
      ASSIGN scm_context  = STRING(vBuffer)
             scm_filename = vBuffer:PRIVATE-DATA.
      RUN adecomm/_adeevnt.p 
             (INPUT "Editor",
              INPUT "Before-Close", INPUT scm_context, INPUT scm_filename,
              OUTPUT scm_ok).
              
      IF NOT scm_ok THEN
      DO:
          /* If close is cancelled by SCM, make that buffer current. */
          ASSIGN ProEditor = vBuffer
                 File_Name = ProEditor:PRIVATE-DATA .
          RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor ) .

          /* Under Character Progress, if we don't assign ? and then reassign
             mnb_Proedit, Progress won't redisplay the menubar.
          */
          IF SESSION:DISPLAY-TYPE = "TTY" THEN
              ASSIGN p_Window:MENUBAR = ?
                     p_Window:MENUBAR = MENU mnb_ProEdit:HANDLE .

          ASSIGN p_Window:VISIBLE = TRUE
                 Saved_File       = ?.   /* System var - ? means cancel Exit. */
          RETURN.
      END.
      /* --- End SCM changes ----- */

      IF ( Sys_Options.Save_BufList = YES ) AND 
	 ( NOT Edit_Buffer.hBuffer:PRIVATE-DATA BEGINS Untitled ) THEN
      DO:
        Sys_Options.BufList = IF ( Sys_Options.BufList <> "" )
        			THEN ( Sys_Options.BufList + "," +
        			       Edit_Buffer.hBuffer:PRIVATE-DATA )
        			ELSE Edit_Buffer.hBuffer:PRIVATE-DATA .
      END.
      
      RUN DeleteBuffer( INPUT-OUTPUT vBuffer ).

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
          (INPUT "Editor",
           INPUT "Close", INPUT scm_context, INPUT scm_filename, 
           OUTPUT scm_ok).
      /* --- Begin SCM changes --- */

  END.
  
  DO ON ERROR UNDO, LEAVE:
    /* Be certain to reset to default Progress Environment File. */
    USE "" NO-ERROR.
    /* Always save buf list. */
    RUN adecomm/_kvlist.p ( INPUT "PUT" ,
                          INPUT KeyValue_Section ,
                          INPUT "BufList",
                          INPUT-OUTPUT Sys_Options.BufList ).
  END.                          
 
END PROCEDURE.  /* CloseAllBuffers */  


    

PROCEDURE SaveBuffer .
  /*---------------------------------------------------------
     Save contents of current Buffer in buffer list for 
     this window. 
  ---------------------------------------------------------*/
 
  DEFINE INPUT  PARAMETER p_Buffer     AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File AS LOGICAL       NO-UNDO.

  DEFINE BUFFER tEdit_Buffer FOR Edit_Buffer.
  DEFINE VAR Valid_BufName AS LOGICAL NO-UNDO.
  /* --- Begin SCM changes --- */
  DEFINE VAR scm_ok        AS LOGICAL NO-UNDO.
  /* --- End SCM changes ----- */


/* Uncommenting this code will warn user before saving an empty buffer.
  DEFINE VAR Save_Empty  AS LOGICAL NO-UNDO.
  
  IF p_Buffer:EMPTY
  THEN DO:
      Save_Empty = YES.
      MESSAGE p_Buffer:PRIVATE-DATA SKIP
        "This buffer is empty.  Save it anyways?" 
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE Save_Empty.
      ASSIGN p_Saved_File = Save_Empty .
      IF ( Save_Empty = NO ) THEN RETURN.
  END.
*/

  RUN BufValidName ( INPUT p_Buffer , INPUT p_Buffer:PRIVATE-DATA ,
                     OUTPUT Valid_BufName ) .
  IF NOT Valid_BufName THEN RETURN.


  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p 
      ( INPUT "Editor",
        INPUT "Before-Save", INPUT STRING(p_Buffer), INPUT p_Buffer:PRIVATE-DATA,
        OUTPUT p_Saved_File).
  IF NOT p_Saved_File THEN RETURN.
  /* --- End SCM changes ----- */


  ASSIGN p_Saved_File = p_Buffer:SAVE-FILE( p_Buffer:PRIVATE-DATA ) NO-ERROR .

  IF ( p_Saved_File = FALSE )
  THEN DO:
      MESSAGE p_Buffer:PRIVATE-DATA SKIP
        "Cannot save to this file."  SKIP(1)
        "File is read-only or the path specified" SKIP
        "is invalid. Use a different filename."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.

  END.
  ELSE DO:
      FIND FIRST tEdit_Buffer WHERE tEdit_Buffer.hBuffer = p_Buffer.
      ASSIGN
          FILE-INFO:FILENAME     = p_Buffer:PRIVATE-DATA
          tEdit_Buffer.File_Name = FILE-INFO:FULL-PATHNAME
          .

      /* adecomm/peditor.i */
      RUN SetEdBufType (INPUT p_Buffer, INPUT p_Buffer:PRIVATE-DATA).

      /* Reset the EDIT-CAN-UNDO attribute-GUI only. */
      ASSIGN p_Buffer:EDIT-CAN-UNDO = FALSE WHEN SESSION:WINDOW-SYSTEM <> "TTY".

      /* --- Begin SCM changes --- */
      RUN adecomm/_adeevnt.p 
          ( INPUT "Editor",
            INPUT "Save", INPUT STRING(p_Buffer), INPUT p_Buffer:PRIVATE-DATA,
            OUTPUT scm_ok ).
      /* --- End SCM changes ----- */
  END.
        
END PROCEDURE.  /* SaveBuffer */



PROCEDURE DeleteWindow .

  DEFINE INPUT-OUTPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  
  FIND FIRST Edit_Window WHERE Edit_Window.hWindow = p_Window.
  DELETE Edit_Window.
  DELETE WIDGET p_Window.
  
END PROCEDURE.  /* DeleteWindow */



PROCEDURE DeleteBuffer .

  DEFINE INPUT-OUTPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
  p_Buffer:VISIBLE = FALSE.
  /* if this file has a Class_TmpDir, remove this directory */
  /* TO DO: CHECK IF THIS COULD ACCIDENTALLY DELETE A VALID DIR */
  IF (Edit_Buffer.Class_TmpDir <> ?) THEN
      OS-DELETE VALUE(Edit_Buffer.Class_TmpDir) RECURSIVE.
  DELETE Edit_Buffer.
  DELETE WIDGET p_Buffer.
  
END PROCEDURE.  /* DeleteBuffer */


PROCEDURE NumBuffers .
  /*------------------------------------------------------------- 
     Returns the number of open buffers for a window.
  ------------------------------------------------------------- */

  DEFINE INPUT  PARAMETER p_Window       AS WIDGET-HANDLE NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Buffers_Open AS INTEGER NO-UNDO.

  p_Buffers_Open = 0.
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window:
    p_Buffers_Open =  p_Buffers_Open + 1.
  END.
   
END PROCEDURE.  /* NumBuffers */


PROCEDURE NextBuffer .

  /* More than the current buffer open? */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer <> ProEditor
                         NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
  DO:
    MESSAGE "No other buffers open."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer = ProEditor.
  FIND NEXT Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                              Edit_Buffer.hBuffer <> ProEditor NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                                 Edit_Buffer.hBuffer <> ProEditor.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN ProEditor:VISIBLE = FALSE.
  &ENDIF

  ProEditor = Edit_Buffer.hBuffer.
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor).
    
END PROCEDURE.  /* NextBuffer */



PROCEDURE PrevBuffer .
  
  /* More than the current buffer open? */
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer <> ProEditor
                         NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
  DO:
    MESSAGE "No other buffers open."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  
  FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                               Edit_Buffer.hBuffer = ProEditor.
  FIND PREV Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                              Edit_Buffer.hBuffer <> ProEditor NO-ERROR.
  IF NOT AVAILABLE Edit_Buffer THEN
    FIND LAST Edit_Buffer WHERE Edit_Buffer.hWindow = win_ProEdit AND
                                Edit_Buffer.hBuffer <> ProEditor.
    
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  /* To avoid flashing in tty, hide current buffer. */
  ASSIGN ProEditor:VISIBLE = FALSE.
  &ENDIF

  ProEditor = Edit_Buffer.hBuffer.
  RUN MakeCurrent( INPUT win_ProEdit, INPUT ProEditor).
  
END PROCEDURE.  /* PrevBuffer */


PROCEDURE BufQMod .
  /* Returns TRUE if buffer is a modified buffer; FALSE if not. */
    DEFINE INPUT  PARAMETER p_Buffer   AS WIDGET-HANDLE      NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Modified AS LOGICAL INIT FALSE NO-UNDO.
    
    DEFINE VARIABLE Buffer_Code AS CHAR NO-UNDO.

    /* If the buffer being checked is the current buffer and its a QUIT
       buffer, then we don't consider it a modified buffer. */
    IF ( p_Buffer = ProEditor )
       AND Quit_Pending
    THEN p_Modified = FALSE.
    ELSE IF ( p_Buffer:MODIFIED = NO ) OR 
       ( p_Buffer:PRIVATE-DATA BEGINS Untitled AND
         p_Buffer:EMPTY ) 
    THEN p_Modified = FALSE.
    ELSE p_Modified = TRUE.

END PROCEDURE. /* BufQMod */


PROCEDURE BufferList .
  
  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE Buffer_Handle_List AS CHARACTER INIT "".
  DEFINE VARIABLE Buffer_File_Name_List AS CHARACTER INIT "".
  DEFINE VARIABLE Buffer_List AS CHARACTER 
    LABEL "Select &Buffer:" 
    VIEW-AS SELECTION-LIST SINGLE SIZE 60 BY 6 
            SCROLLBAR-V SCROLLBAR-H {&STDPH_FIX}.
  DEFINE VARIABLE Buffer_Handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE Num_Open AS INTEGER NO-UNDO.  
  DEFINE VARIABLE Buf_Modified AS LOGICAL NO-UNDO .
  DEFINE VARIABLE Buffer_Selected AS CHAR NO-UNDO .
  DEFINE VARIABLE Buf_Mod_Marker  AS CHAR INIT "*  " NO-UNDO .
  DEFINE VARIABLE Buf_UMod_Marker AS CHAR INIT "   " NO-UNDO.
  DEFINE VARIABLE List_Handle     AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE Temp_Logical AS LOGICAL NO-UNDO .

  DEFINE BUTTON b_OK       LABEL "OK"     {&STDPH_OKBTN} AUTO-GO .
  DEFINE BUTTON b_Cancel   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON b_Save     LABEL "&Save"  {&STDPH_OKBTN} .
  DEFINE BUTTON b_Help     LABEL "&Help"  {&STDPH_OKBTN}  .
  
  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE BL_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /* Dialog Box */    
  FORM
    SKIP( {&TFM_WID} )
    "Select Buffer:" {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
    Buffer_List  {&AT_OKBOX}
    SKIP( {&VM_WID} )
    "*=Modified" {&AT_OKBOX} VIEW-AS TEXT
    { adecomm/okform.i
        &BOX    ="BL_Btn_Box"
        &OK     ="b_OK"
        &CANCEL ="b_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) b_Save"
        &HELP   ="b_Help" 
    }
    WITH FRAME Buffer_List
         VIEW-AS DIALOG-BOX TITLE "Buffer List" NO-LABELS
	 DEFAULT-BUTTON b_OK
         CANCEL-BUTTON  b_Cancel .
    { adecomm/okrun.i
        &FRAME  = "FRAME Buffer_List"
        &BOX    = "BL_Btn_Box"
        &OK     = "b_OK"
        &OTHER  = "b_Save"
        &HELP   = "b_Help"
    }
 
  ON HELP OF FRAME Buffer_List ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "Buffer_List_Dialog_Box" ).
  ON CHOOSE OF b_Help IN FRAME Buffer_List 
    RUN adeedit/_edithlp.p ( INPUT "Buffer_List_Dialog_Box" ).
 
  ON GO OF FRAME Buffer_List OR
     DEFAULT-ACTION OF Buffer_List 
                       IN FRAME Buffer_List
  DO:
    User_Selection = "EDIT".
  END.
 
  ON CHOOSE OF b_Save IN FRAME Buffer_List
  DO:
    DEFINE VAR Buffer_Name AS CHAR NO-UNDO.

    Buffer_Name = SUBSTRING(Buffer_List:SCREEN-VALUE IN FRAME Buffer_List , 
			  LENGTH( Buf_Mod_Marker ) + 1 ) .

    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window AND
			   Edit_Buffer.Buffer_Name = Buffer_Name.
    User_Selection = "SAVE".
    RUN SaveFile ( INPUT Edit_Buffer.hBuffer ).
    IF ( Edit_Buffer.hBuffer:MODIFIED = FALSE )
    THEN DO:

      Buffer_Name = Buf_UMod_Marker + Edit_Buffer.Buffer_Name.
      Temp_Logical = Buffer_List:REPLACE( Buffer_Name, 
                         Buffer_List:SCREEN-VALUE IN FRAME Buffer_List )
                         IN FRAME Buffer_List.
      Buffer_List:SCREEN-VALUE IN FRAME Buffer_List = Buffer_Name.
    END.
    APPLY "ENTRY" TO SELF.
  END.

  ON WINDOW-CLOSE OF FRAME Buffer_List OR
     CHOOSE OF b_Cancel IN FRAME Buffer_List
  DO:
    User_Selection = "CANCEL".
  END.
  
  RUN WinStatusMsg (win_ProEdit , "MT_INPUT" , "" , "WAIT").
    
  /* Build Buffer List for window's buffers with files open in them. */
  Buffer_File_Name_List = "".
  FOR EACH Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window :
    RUN BufQMod ( Edit_Buffer.hBuffer , OUTPUT Buf_Modified ).
    
    IF ( Buffer_File_Name_List <> "" ) 
    THEN
      Buffer_File_Name_List = Buffer_File_Name_List + "," +
				IF Buf_Modified 
				THEN Buf_Mod_Marker  /* Add MOD Marker. */
				ELSE Buf_UMod_Marker.
    ELSE
      Buffer_File_Name_List = IF Buf_Modified 
				THEN Buf_Mod_Marker  /* Add MOD Marker. */
				ELSE Buf_UMod_Marker.
    Buffer_File_Name_List = Buffer_File_Name_list + 
				Edit_Buffer.hBuffer:PRIVATE-DATA.
  END.
  
  Buffer_List:LIST-ITEMS IN FRAME Buffer_List = Buffer_File_Name_List .
  RUN BufQMod( p_Buffer , OUTPUT Buf_Modified ).
  Buffer_List:SCREEN-VALUE IN FRAME Buffer_List = IF Buf_Modified
						THEN Buf_Mod_Marker + 
						     p_Buffer:PRIVATE-DATA
						ELSE Buf_UMod_Marker +
						     p_Buffer:PRIVATE-DATA.
  ASSIGN List_Handle = Buffer_List:HANDLE IN FRAME Buffer_List.

  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
  ENABLE ALL EXCEPT b_Help WITH FRAME Buffer_List.
  ENABLE b_Help {&WHEN_HELP} WITH FRAME Buffer_List.
  
  User_Selection = "CANCEL".
  REPEAT ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:  
    SET Buffer_List
      GO-ON ( GO,WINDOW-CLOSE
              DEFAULT-ACTION OF Buffer_List )
      WITH FRAME Buffer_List.
    LEAVE.
  END.
 
 /* debug leave these lines here for now.  */
  HIDE FRAME Buffer_List NO-PAUSE.
  DISABLE ALL WITH FRAME Buffer_List.

  IF User_Selection <> "CANCEL" THEN
  DO:
    IF User_Selection = "Edit" THEN
    DO:
      /* Strip off leading MODIFIED MARKER. */
      Buffer_Selected = SUBSTRING(Buffer_List:SCREEN-VALUE 
						IN FRAME Buffer_List , 
				  LENGTH( Buf_Mod_Marker ) + 1 ) .

      FIND FIRST Edit_Buffer WHERE Edit_Buffer.hWindow = p_Window AND
				   Edit_Buffer.Buffer_Name = Buffer_Selected.


      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      /* To avoid flashing in tty, hide current buffer. */
      ASSIGN p_Buffer:VISIBLE = FALSE.
      &ENDIF

      p_Buffer = Edit_Buffer.hBuffer.
      RUN MakeCurrent ( INPUT p_Window, INPUT p_Buffer ).
      ProEditor = p_Buffer. 
    END.
    ELSE APPLY "ENTRY" TO p_Buffer.
  END.

END PROCEDURE.  /* BufferList */


PROCEDURE BufChangeFont .
  /*-------------------------------------------------------------------------
     Presents the Buffer Font dialog, which allows the user to choose a font
     for an editor buffer.
  -------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Pressed_OK AS LOGICAL NO-UNDO.

    DO ON STOP UNDO, LEAVE:
        FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
        ASSIGN Edit_Buffer.Font_Num = p_Buffer:FONT .
        RUN adecomm/_chsfont.p ( INPUT "Buffer Font" , 
                                 INPUT ?,  /* Use System Default Font */
    			         INPUT-OUTPUT Edit_Buffer.Font_Num ,
                                 OUTPUT Pressed_OK ) .
        IF ( Pressed_OK = TRUE ) AND 
           ( p_Buffer:FONT <> Edit_Buffer.Font_Num )
        THEN p_Buffer:FONT = Edit_Buffer.Font_Num .
    END.
END PROCEDURE.

PROCEDURE DlgBufSettings  .
  /*--------------------------------------------------------------------------
     The Buffer Information Dialog permits a user to view various attributes 
     specific to a buffer.
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VAR EFile_Name   LIKE Edit_Buffer.File_Name   NO-UNDO .
  DEFINE VAR Valid_BufName AS LOGICAL NO-UNDO .
  
  DEFINE VAR File_Access  AS CHAR    LABEL "File Access" FORMAT "x(1)".
  DEFINE VAR Read_Access  AS LOGICAL LABEL "Read"  VIEW-AS TOGGLE-BOX.
  DEFINE VAR Write_Access AS LOGICAL LABEL "Write" VIEW-AS TOGGLE-BOX.
  DEFINE VAR l_Length     AS INTEGER NO-UNDO.
  DEFINE VAR short_name    AS CHAR    NO-UNDO.
  
  DEFINE BUTTON btn_OK   LABEL "OK"    {&STDPH_OKBTN} AUTO-GO .
  DEFINE BUTTON btn_HELP LABEL "&Help" {&STDPH_OKBTN} .

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE BI_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /* Dialog Box */    
    
  FORM
    SKIP( {&TFM_WID} )
    EFile_Name    COLON 13 
    SKIP( {&VM_WID} )
    File_Access   COLON 13 Read_Access Write_Access
    SKIP( {&VM_WID} )
    Edit_Buffer.Cursor_Line COLON 13
    Edit_Buffer.Length      COLON 42
    SKIP( {&VM_WID} )
    Edit_Buffer.Cursor_Char COLON 13
    Edit_Buffer.Modified  FORMAT "Yes /No "  COLON 42
    { adecomm/okform.i
        &BOX    ="BI_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL =" "
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
    WITH FRAME Dlg_BufSettings 
         VIEW-AS DIALOG-BOX TITLE "Buffer Information" USE-TEXT
         SIDE-LABELS OVERLAY  
         DEFAULT-BUTTON btn_OK.
    { adecomm/okrun.i
        &FRAME  = "FRAME Dlg_BufSettings"
        &BOX    = "BI_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }

  /* The Read and Write toggles are display fields only. However, when
     displayed as disabled fields, the toggle labels are grayed
     out and do not display well. So we enable them. Since the dialog is
     for display-only, we prevent the user from changing the toggle values
     using this trigger.
  */
  ON VALUE-CHANGED OF Read_Access IN FRAME  Dlg_BufSettings
  OR VALUE-CHANGED OF Write_Access IN FRAME  Dlg_BufSettings
  DO:
    ASSIGN SELF:SCREEN-VALUE = IF SELF:SCREEN-VALUE = "yes":U
                               THEN "no" ELSE "yes".
    RETURN NO-APPLY.
  END.

  ON HELP OF FRAME Dlg_BufSettings ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "Buffer_Settings_Dialog_Box" ).
  ON CHOOSE OF btn_Help IN FRAME Dlg_BufSettings 
    RUN adeedit/_edithlp.p ( INPUT "Buffer_Settings_Dialog_Box" ).

  DLG_BUFSET :
  DO ON STOP   UNDO DLG_BUFSET , LEAVE DLG_BUFSET 
     ON ERROR  UNDO DLG_BUFSET , LEAVE DLG_BUFSET 
     ON ENDKEY UNDO DLG_BUFSET , LEAVE DLG_BUFSET
     WITH FRAME Dlg_BufSettings:
  
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .  
    
    /* Calculate the buffer size based on what the OS thinks it is. Avoids
       differences and speed issues with the <editor>:LENGTH attribute on
       different platforms.
    */
    IF NOT p_Buffer:EMPTY THEN
    RUN adecomm/_getflen.p
                (INPUT  p_Buffer     /* Editor handle.   */ ,
                 INPUT  ""           /* OS file.         */ ,
                 OUTPUT l_Length     /* Length in bytes  */ ).

    /* We don't need p_Window because buffer handles are unique system-wide. */
    FIND FIRST Edit_Buffer WHERE Edit_Buffer.hBuffer = p_Buffer.
    ASSIGN  Edit_Buffer.Cursor_Line = p_Buffer:CURSOR-LINE
            Edit_Buffer.Cursor_Char = p_Buffer:CURSOR-CHAR
            Edit_Buffer.Font_Num    = p_Buffer:FONT
            Edit_Buffer.Length      = l_Length
            Edit_Buffer.Modified    = p_Buffer:MODIFIED
            EFile_Name              = (IF Edit_Buffer.File_Name <> ?
                                       THEN Edit_Buffer.File_Name
                                       ELSE "<No File>")
    . /* END ASSIGN */

    /* adecomm/peditor.i */
    RUN SetEdBufType (INPUT p_Buffer, INPUT Edit_Buffer.Buffer_Name).
    
    /* Shorten display name. If we do, set tooltip to long name. */
    RUN adecomm/_ossfnam.p
        (INPUT EFile_Name,
         INPUT EFile_Name:WIDTH IN FRAME Dlg_BufSettings,
         INPUT EFile_Name:FONT IN FRAME Dlg_BufSettings,
         OUTPUT short_name).
    IF EFile_Name <> short_name THEN
        ASSIGN EFile_Name:TOOLTIP = Efile_Name
               EFile_Name         = short_name.

    IF ( Edit_Buffer.File_Name <> ? ) /* Not Untitled */
    THEN DO:
        ASSIGN FILE-INFO:FILENAME = Edit_Buffer.File_Name
               Read_Access  = ( INDEX( FILE-INFO:FILE-TYPE , "R" ) > 0 )
               Write_Access = ( INDEX( FILE-INFO:FILE-TYPE , "W" ) > 0 )
        .
    END.
    
    RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
    DISPLAY EFile_Name Read_Access Write_Access
            Edit_Buffer.Cursor_Line Edit_Buffer.Cursor_Char
            Edit_Buffer.Length Edit_Buffer.Modified
            WITH FRAME Dlg_BufSettings .

    IF (EFile_Name <> "<No File>") AND (SESSION:WINDOW-SYSTEM <> "TTY":U) THEN
      ENABLE Read_Access Write_Access WITH FRAME Dlg_BufSettings.

    UPDATE btn_OK btn_Help {&WHEN_HELP}
           GO-ON ( GO,WINDOW-CLOSE )
	   WITH FRAME Dlg_BufSettings .

  END.  /* DLG_BUFSET DO: */
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .
         
END PROCEDURE.  /* DlgBufSettings */
 
