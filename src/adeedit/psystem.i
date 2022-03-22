/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  psystem.i 
  System-wide Procedures for Editor
--------------------------------------------------------------------------*/


PROCEDURE ExecuteRun.
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Editor's integration when it "RUNs" a procedure.
    Run Syntax:     RUN ExecuteRun 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ,
			INPUT p_Never_Pause ).
    Parameters:
            p_Never_Pause    (LOGICAL)
                Tool calls and the editor running an os file directly
                should never pause after running.  This allows for control
                of that behavoir.

    Description:
    Notes:
		    References the system-wide FRAME f_Buffers and
		    ProEditor widgets.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Never_Pause     AS LOGICAL       NO-UNDO.

    DEFINE VARIABLE Run_Flags AS CHARACTER NO-UNDO.

    DEFINE VARIABLE app_handle AS HANDLE NO-UNDO.

    
    REPEAT ON QUIT       , RETRY
           ON STOP   UNDO, RETRY
           ON ERROR  UNDO, RETRY
           ON ENDKEY UNDO, RETRY:
           
        IF NOT RETRY
        THEN DO:
            RUN DisableEditor
                ( INPUT p_Edit_Window, 
                  INPUT p_Execute_Window, 
                  INPUT p_Execute_Title ,
                  INPUT p_Run_File ).
                  
            IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
            THEN DO:
                RUN WinStatusMsg 
                    ( INPUT p_Edit_Window , INPUT "MT_INPUT" , 
                      INPUT "Running " + Proeditor:PRIVATE-DATA + " ...",
                      INPUT "" ) .
             END.
            
	    /* Auto-cleanup orphaned dynamic widgets? */
	    IF ( Sys_Options.Auto_Cleanup = NO ) THEN
                ASSIGN Run_Flags = "_KEEP-WIDGETS":U.
            
            /* Only pause when told to do so. */
            IF ( Sys_Options.Pause_AfterRun = YES ) AND
               ( p_Never_Pause = FALSE ) THEN
                ASSIGN Run_Flags = Run_Flags + "," + "_PAUSE":U.

            DO ON QUIT     , LEAVE
               ON STOP UNDO, LEAVE:
              RUN adecomm/_runcode.p
                  ( INPUT p_Run_File   ,
                    INPUT Run_Flags ,
                    INPUT ?     /* p_Stop_Widget */,
                    OUTPUT app_handle ) .
            END.
      
        END.
        RUN EnableEditor
            ( INPUT p_Edit_Window, 
              INPUT p_Execute_Window, 
              INPUT p_Execute_Title ,
              INPUT p_Run_File ,
              INPUT p_Never_Pause ).
        LEAVE.
    END.
    
END PROCEDURE.    


PROCEDURE DisableEditor .
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Disabling Editor before running user code
                    or another ADE Tool.
    
    Run Syntax:     RUN DisableEditor 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ).
    Parameters:

    Description:
    Notes       : References the system-wide Edit_Win_State var.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    
    DEFINE VAR Temp_Logical   AS LOGICAL NO-UNDO.
    
    /*---------------------------------------------------------------- 
       Need to trap in case CTRL-C while editor is disabled and while
       running program.
    ----------------------------------------------------------------*/
 /*   
    DISABLE_BLOCK:
    DO ON STOP UNDO DISABLE_BLOCK , LEAVE DISABLE_BLOCK :
  */    

        /* Unset global active ade tool variable. */
        ASSIGN h_ade_tool = ?.

	/* Reset Progress Session defaults for execute window. */
	RUN SessionDefaults ( INPUT p_Execute_Window ) .

	IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
	THEN DO:  /* GUI */
	  ASSIGN Edit_Win_State = p_Edit_Window:WINDOW-STATE.
          IF ( Sys_Options.Minimize_BeforeRun = YES )
          THEN DO:
                ASSIGN p_Edit_Window:WINDOW-STATE = WINDOW-DELAYED-MINIMIZE.
                RUN adecomm/_pwwinst.p (INPUT Editor_Name /* Parent ID */ ,
                                        INPUT WINDOW-MINIMIZED ).
          END.
	    
	  /* Disable the Editor Window menubar items. */
	  RUN EnableEditWin ( INPUT p_Edit_Window, 
                              INPUT FALSE /* disable */ ).

	  ASSIGN p_Execute_Window:SENSITIVE = TRUE
		 p_Execute_Window:TITLE   = p_Execute_Title
		 p_Execute_Window:MENUBAR = ?
		 CURRENT-WINDOW 	  = p_Execute_Window
		 .
	END.
	ELSE DO: /* TTY */
            ASSIGN p_Execute_Window:MENUBAR = ?.
        END.
        
        /* Ensure the Procedure Editor does not have focus when running
           user's code by "killing" FOCUS - that is, making it null.
        */
        RUN KillFocus ( INPUT p_Execute_Window ,
                        INPUT FRAME f_Buffers:HANDLE ).
        
    /*
    END. /* DISABLE_BLOCK */
    */
    
END PROCEDURE.


PROCEDURE EnableEditor .
  /*--------------------------------------------------------------------------
    Purpose:	    Handles Enabling Editor after running user code
                    or another ADE Tool.
    
    Run Syntax:     RUN EnableEditor 
		      ( INPUT p_Edit_Window, 
			INPUT p_Execute_Window, 
			INPUT p_Execute_Title ,
			INPUT p_Run_File ,
			INPUT p_Never_Pause ).
    Parameters:
            p_Never_Pause    (LOGICAL)
                Tool calls and the editor running an os file directly
                should never pause after running.  This allows for control
                of that behavoir.

    Description :
    Notes       : References the system-wide FRAME f_Buffers and
                  ProEditor widgets and Edit_Win_State var.
  --------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER p_Edit_Window     AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Execute_Title   AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Run_File	     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p_Never_Pause     AS LOGICAL       NO-UNDO.
    
    DEFINE VAR Temp_Logical   AS LOGICAL NO-UNDO.
    
    PAUSE_BLOCK : 
    REPEAT ON STOP UNDO PAUSE_BLOCK , RETRY PAUSE_BLOCK :

      /* Set global active ade tool procedure handle to Procedure Editor. */
      ASSIGN h_ade_tool = THIS-PROCEDURE.

      /******************************************************************
         I want this block executed whether there's a retry or not
         a retry condition. Its the code to re-enable the editor.
         Progress' default behavior is to override an UNDO RETRY with
         UNDO LEAVE if the RETRY block has no user interaction and has
         not evaluated the RETRY function.  This next statement forces 
         a RETRY evaluation and allows the execution to continue with
         the rest of the code. Got it?  - jep  11/18/94
      ******************************************************************/

      IF RETRY = (NOT RETRY) THEN RETURN.
      
      /* Reset Progress Session defaults for execute window. */
      RUN SessionDefaults ( INPUT p_Execute_Window ) .

      /* Post-run reset. */    
      IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
      THEN DO:
        /* Reset major attributes for execute window (font, title etc. */
        RUN DefWinReset ( INPUT p_Execute_Window ).
	/* Re-enable Editor Window. */
	RUN EnableEditWin ( INPUT p_Edit_Window, INPUT TRUE /* enable */ ).
 	ASSIGN CURRENT-WINDOW = p_Edit_Window.
      END.
      ELSE DO:
          ASSIGN p_Edit_Window:MENUBAR = MENU mnb_ProEdit:HANDLE .
      END.
     
      ASSIGN Temp_Logical = p_Edit_Window:LOAD-MOUSE-POINTER("").
      
      IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) AND
         ( Sys_Options.Restore_AfterRun = YES )
      THEN DO:
        /*-----------------------------------------------------------
            Restore Editor window state:
                - MSW  : Return to previous state.
                - MOTIF: Return to Normal state. Does not support
                         return to Maximized.
                       
            Restore Procedure Window states:
                - Restore all Procedure Windows.
                - Restore to Normal state always.
        -----------------------------------------------------------*/
        RUN adecomm/_pwwinst.p (INPUT Editor_Name /* Parent ID */ ,
                                INPUT WINDOW-NORMAL ).
        IF ( p_Edit_Window:WINDOW-STATE = WINDOW-MINIMIZED )
            THEN ASSIGN p_Edit_Window:WINDOW-STATE = WINDOW-NORMAL .
      END.

      IF ( SESSION:WINDOW-SYSTEM <> "TTY":U ) THEN
          /* In GUI, ensure Editor was not hidden by user code. */
          ASSIGN p_Edit_Window:HIDDEN = FALSE.
      ELSE DO:
          /* f_Buffers is a system-wide reference. */ 
          /* No need to re-VIEW under GUI, just TTY.  Re-viewing under GUI
             here can cause buffer ordering problems. */
          VIEW FRAME f_Buffers IN WINDOW p_Edit_Window.
          RUN WinSetTitle( INPUT p_Edit_Window , 
                           INPUT ProEditor:PRIVATE-DATA ).
      END.

      RUN WinStatusMsg ( p_Edit_Window , "MT_INPUT" , "" , "" ) .
      APPLY "ENTRY" TO ProEditor.
      LEAVE PAUSE_BLOCK.
    END.  /* PAUSE_BLOCK */
      
    /* Ensure the delayed minimize window state is cleared. Fixes 97-08-13-040. */
    IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
        ASSIGN p_Edit_Window:WINDOW-STATE = p_Edit_Window:WINDOW-STATE.
    RETURN.  /* Use to reset RETURN-VALUE function to Null (""). */

END PROCEDURE.


PROCEDURE KillFocus .
  /*--------------------------------------------------------------------------
    Purpose:        Kills FOCUS so its no longer in Procedure Editor.
    Run Syntax:
        RUN KillFocus ( INPUT p_Execute_Window ,
                        INPUT p_hFrame ).
                        
    Parameters:
    
    Description:
        1. Ensures the Procedure Editor does not have focus
           when it becomes disabled before running user's code.
        2. User can no longer access the Procedure Editor handle via
           FOCUS or FRAME-VALUE when their code runs.
    
    Notes:
        1. To move focus out of Editor, we move focus into a temp editor
           widget and then delete the widget.  Also...
        2. We Apply entry to the execute window.
        
        One and Two together move FOCUS out to nowhere (null focus) and
        deacticates FRAME-VALUE until user actives it. 
        
        This only works for GUI, not TTY.
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_hFrame          AS WIDGET-HANDLE NO-UNDO.

  DEFINE VARIABLE hTempEd                  AS WIDGET-HANDLE NO-UNDO.
  
  
  DO ON STOP UNDO, LEAVE:
  
      /* Create a temp editor widget. We'll put focus in it, then destroy
         it before running user's code. This ensures the Procedure Editor
         will not have focus when the user's code runs. User can no longer
         access the Procedure Editor handle via FOCUS or FRAME-VALUE when 
         their code runs.
      */
      CREATE EDITOR hTempEd
        ASSIGN HIDDEN    = TRUE
               FRAME     = p_hFrame
               SENSITIVE = TRUE
        . /* ASSIGN */
      APPLY "ENTRY" TO hTempED.
      ASSIGN hTempEd:SENSITIVE = FALSE.
  
  END. /* DO ON STOP */
  
  /* Destory the temp focus editor.  Progress puts focus nowhere, so the
     Editor will not have it. Note the VALID-HANDLE check prevents the
     DELETE WIDGET from executing if some stop condition occurred
     before hTempEd got created.
     
     The APPLY ensures we move focus out of the Editor window under
     Motif.
  */
  IF VALID-HANDLE( hTempEd )
    THEN DELETE WIDGET hTempED.
  IF VALID-HANDLE( p_Execute_Window )
    THEN APPLY "ENTRY" TO p_Execute_Window.
  
  RETURN.
  
END PROCEDURE.	/* KillFocus. */


PROCEDURE DefWinReset.
  /*--------------------------------------------------------------------------
    Purpose:        Resets a window's attributes to the Progress 
                    Initial window defaults.

    Run Syntax:     RUN DefWinReset( INPUT p_Window ).

    Parameters:     INPUT p_Window  - Window to reset.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Default_Win AS WIDGET-HANDLE NO-UNDO.
    
    /* proc-main */
    REPEAT ON STOP UNDO, RETRY:
        IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN RETURN.
        IF NOT RETRY
        THEN DO:
            CREATE WINDOW Default_Win.
            ASSIGN
                p_Window:FONT    = Default_Win:FONT
                p_Window:BGCOLOR = Default_Win:BGCOLOR
                p_Window:FGCOLOR = Default_Win:FGCOLOR
                p_Window:TITLE   = Default_Win:TITLE
                p_Window:MENUBAR = ?
                p_Window:VIRTUAL-WIDTH   = Default_Win:VIRTUAL-WIDTH
                p_Window:VIRTUAL-HEIGHT  = Default_Win:VIRTUAL-HEIGHT
                p_Window:MAX-WIDTH   = Default_Win:MAX-WIDTH
                p_Window:MAX-HEIGHT  = Default_Win:MAX-HEIGHT
                p_Window:MIN-WIDTH   = Default_Win:MIN-WIDTH
                p_Window:MIN-HEIGHT  = Default_Win:MIN-HEIGHT
                p_Window:WIDTH   = Default_Win:WIDTH
                p_Window:HEIGHT  = Default_Win:HEIGHT
            . /* END-ASSIGN */
        END.
        DELETE WIDGET Default_Win.
        LEAVE.
    END.
    
END PROCEDURE.


PROCEDURE GetFile.  
  /*--------------------------------------------------------------------------
    Purpose:        Open a file from disk, or if the file is already open
                    in a buffer, make it the current buffer.

    Run Syntax:     RUN GetFile
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

  /* References to system editor vars here. */
  DO:
      FILE-INFO:FILENAME   = p_File_Name .
      Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME.
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
        p_Return_Status = TRUE.
      END.
      ELSE IF ( Fullpath_Buffer_Name <> ? )
      THEN DO: /* File on disk but not open in buffer. */
        /* Go open the file from the operating system. */
        RUN FileOpen ( INPUT win_ProEdit , INPUT p_File_Name ,
                       INPUT TRUE ,
                       INPUT-OUTPUT p_Current_Buffer ).
        p_Return_Status = TRUE.
      END.
      ELSE DO: /* Can't find file with error. */
        p_Return_Status = FALSE.
      END.
      RETURN .
  END.

END PROCEDURE .



PROCEDURE SessionDefaults.
  /*--------------------------------------------------------------------------
    Purpose:	    Reset Progress Session defaults for specfied window.
    Run Syntax:     RUN SessionDefaults ( INPUT p_Window ).
    Parameters:     p_Window : Handle to window to set session defaults.
    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Temp_Var   AS LOGICAL NO-UNDO.
  DEFINE VAR Immed_Disp AS LOGICAL NO-UNDO.

  /* Most important after run.  Must be sure user wait state is cleared. */
  ASSIGN 
      Temp_Var = SESSION:SET-WAIT-STATE("")
      Temp_Var = p_Window:LOAD-MOUSE-POINTER("")
  NO-ERROR . /* END ASSIGN */

  /* Hide the execute window. */
  HIDE p_Window.
	  
  /* Clear the execute window.		    */
  HIDE ALL NO-PAUSE IN WINDOW p_Window .
	
  /* Clear previous messages.*/
  HIDE MESSAGE NO-PAUSE IN WINDOW p_Window .

  /* Reset Status Input and Default to PROGRESS defaults. */
  /* Needed to force display of status using IMMEDIATE-DISPLAY. */
  ASSIGN Immed_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
  STATUS DEFAULT IN WINDOW p_Window .
  STATUS INPUT	 IN WINDOW p_Window .
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Immed_Disp.
	
  /* Default PAUSE processsing. 	    */	
  PAUSE IN WINDOW p_Window BEFORE-HIDE.
  
  /* Be certain to reset to default Progress Environment File. */
  USE "" NO-ERROR.
       
  /* In TTY, Use Message area for R-T errors. GUI: Use Alert-Boxes. */
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = ( SESSION:WINDOW-SYSTEM <> "TTY" ) .
  
  /* Set DATA-ENTRY-RETURN to appropriate default for window system. */
  ASSIGN SESSION:DATA-ENTRY-RETURN  = ( SESSION:WINDOW-SYSTEM = "TTY" ) . 
  
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Bring the default execution window (DEFAULT-WINDOW) topmost.  This
     does not mean its made visible.  It just means that if the user displays
     or gets input from it, by default the window will be brought to the
     top.  See bug 92-12-23-023. jep */
  Temp_Var = p_Window:MOVE-TO-TOP().
  &ENDIF

END PROCEDURE.


PROCEDURE EnableEditWin .

  /*--------------------------------------------------------------------------
    Purpose:        Enables/Disables an Editor Window and all its buffers.
    Run Syntax:     RUN EnableEditWin ( INPUT p_Window, INPUT p_Enabled ).
    Parameters:
    Description:
		    1. Enables/Disables window menubar and all window edit 
		       buffers.
    Notes:
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Enabled AS LOGICAL       NO-UNDO.

  DEFINE VARIABLE hMenubar         AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer          AS WIDGET-HANDLE NO-UNDO.
  
  ASSIGN
      hMenubar                  = p_Window:MENUBAR
      hMenubar:SENSITIVE        = p_Enabled
      FRAME f_Buffers:SENSITIVE = p_Enabled
  . /* END ASSIGN */
  
  /* Set SENSITIVE state of all Editor buffers. */
  ASSIGN hBuffer = FRAME f_Buffers:FIRST-CHILD   /* Field Group         */
         hBuffer = hBuffer:FIRST-CHILD           /* First Editor Buffer */
  . /* ASSIGN */
  DO WHILE VALID-HANDLE( hBuffer ) :
    ASSIGN hBuffer:SENSITIVE = p_Enabled
           hBuffer           = hBuffer:NEXT-SIBLING
    . /* ASSIGN */
  END.
  
END PROCEDURE.	/* EnableEditWin. */


PROCEDURE RunProc.
  /*--------------------------------------------------------------------------
    Purpose:        Runs a specified procedure file.

    Run Syntax:     RUN RunProc ( INPUT p_Run_Procedure ,
                                  INPUT p_Never_Pause ) .

    Parameters:
        Input Parameters
            p_Run_Procedure  (CHAR)
                Operating system name of Progress Procedure to be run.

	    p_Never_Pause    (LOGICAL)
		Tool calls and the editor running an os file directly
		should never pause after running.  This allows for control
		of that behavoir.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Run_Procedure AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER p_Never_Pause   AS LOGICAL NO-UNDO.

  RunProc_Block:
  DO ON STOP UNDO RunProc_Block , RETRY RunProc_Block :

    IF NOT RETRY
    THEN RUN ExecuteRun
             ( INPUT win_Proedit,
               INPUT Run_Window,
               INPUT Editor_Name + " - Run",
               INPUT p_Run_Procedure ,
	       INPUT p_Never_Pause ).
             
  END. /* RunProc_Block */

  RETURN.
  
END PROCEDURE.  


PROCEDURE SysOptsGetPut .
 
/*----------------------------------------------------------------------------

  Syntax:
	RUN SysOptsGetPut .

  Description:

    Reads/Saves Editor System Options settings from current PROGRESS 
    Environment file (e.g., PROGRESS.INI or .Xdefaults) and assigns them 
    to the System Var worktable which holds the settings during an editor 
    session.

  Parameters
 INPUT p_Mode CHAR
    "GET"  :  Reads System Options from current Env. file.

    "PUT"  : Saves System Options to current Env. file.
    If Save_Settings = NO, saves only this setting.
    Otherwise, saves all settings.

    "PUT_SAVE" : Saves all System Options regardless of the
    Save_Settings setting.  This allows editor to
    save current settings during a session.
     
  
  Author: John Palazzo

  Date Created: 11.17.92 

 
----------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Mode AS CHAR NO-UNDO .
  
  DEFINE VAR Key_Value         AS CHAR NO-UNDO .
  DEFINE VAR Settings_NotSaved AS LOGICAL INIT TRUE.

  DO ON STOP  UNDO, LEAVE
     ON ERROR UNDO, LEAVE:
  
  FIND FIRST Sys_Options .  /* One record in table contains all settings. */
  IF SESSION:WINDOW-SYSTEM = 'TTY':U THEN
  DO:
    Sys_Options.Save_Settings = NO.
    RETURN.
  END.
  
  USE "" NO-ERROR.
  
    Key_Value = STRING( Sys_Options.Save_Settings ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "SaveSettings" ,
                 INPUT-OUTPUT Key_Value ) .
        
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Save_Settings = CAN-DO( "YES" , Key_Value ).
    /*-----------------------------------------------------------------
       If I'm in PUT mode but user does not want to save prefs on
       exit, save only this setting and don't save the others.
    -----------------------------------------------------------------*/
    IF ( p_Mode = "PUT" ) AND ( Sys_Options.Save_Settings = NO ) 
    THEN DO:
        ASSIGN Settings_NotSaved = FALSE.
        RETURN.
    END.

    Key_Value = STRING( Sys_Options.Exit_Warning ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "ExitWarning" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Exit_Warning = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Save_BufList ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "SaveBufList" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Save_BufList = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Minimize_BeforeRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MinimizeBeforeRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Minimize_BeforeRun = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Restore_AfterRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "RestoreAfterRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Restore_AfterRun = CAN-DO( "YES" , Key_Value ).
    
    Key_Value = STRING( Sys_Options.Pause_AfterRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "PauseAfterRun" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value )
      THEN Sys_Options.Pause_AfterRun = CAN-DO( "YES" , Key_Value ).

    Key_Value = STRING( Sys_Options.Auto_Cleanup ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "AutoCleanup" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.Auto_Cleanup = CAN-DO( "YES" , Key_Value ).
      
    Key_Value = STRING( Sys_Options.MRU_Filelist ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MostRecentlyUsedFileList" ,
                 INPUT-OUTPUT Key_Value ) .
    IF Key_Value EQ ? THEN Sys_Options.MRU_Filelist = TRUE.
    ELSE IF CAN-DO( "YES,NO" , Key_Value )
      THEN Sys_Options.MRU_Filelist = CAN-DO( "YES", Key_Value ).
      
    Key_Value = STRING( Sys_Options.MRU_Entries ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "MRUEntries" ,
                 INPUT-OUTPUT Key_Value ) .
    CASE Key_Value:
      WHEN ? THEN Sys_Options.MRU_Entries = IF Sys_Options.MRU_Filelist THEN 4 ELSE 0.
      OTHERWISE DO:
        ASSIGN Sys_Options.MRU_Entries = INTEGER( Key_Value ) NO-ERROR.
        IF ERROR-STATUS:ERROR 
          THEN ASSIGN Sys_Options.MRU_Entries = 0.
      END.  /* otherwise do */
    END CASE.
    
    Key_Value = STRING( Sys_Options.EditorFont ).
    IF ( Key_Value = ? ) THEN ASSIGN Key_Value = "Default".
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "EditorFont" ,
                 INPUT-OUTPUT Key_Value ) .
                 
    /* See also adeedit/pinit.i for bg/fgcolor initialization. 
       Editor_Font comes from adecomm/_adeload.p. */
    CASE Key_Value:
        WHEN ? OR WHEN ""       
            THEN ASSIGN Sys_Options.EditorFont = Editor_Font NO-ERROR.
        WHEN "Default" 
            THEN ASSIGN Sys_Options.EditorFont = ? NO-ERROR.
        OTHERWISE DO:
          ASSIGN Sys_Options.EditorFont = INTEGER( Key_Value ) NO-ERROR.
          IF ERROR-STATUS:ERROR 
             THEN ASSIGN Sys_Options.EditorFont = Editor_Font NO-ERROR.
        END.
    END CASE.  

    Key_Value = STRING( Sys_Options.SaveClass_BeforeRun ) .
    RUN KeyVals (INPUT p_Mode ,
                 INPUT KeyValue_Section ,
                 INPUT "AutoSaveCls" ,
                 INPUT-OUTPUT Key_Value ) .
    IF CAN-DO( "YES,NO" , Key_Value ) 
      THEN Sys_Options.SaveClass_BeforeRun = CAN-DO( "YES" , Key_Value ).

    ASSIGN Settings_NotSaved = FALSE.
    
  END. /* DO ON ERROR */

/* Don't report save errors. They are annoying. If you want them, uncomment below. */
/*  IF Settings_NotSaved THEN
    RUN adeshar/_puterr.p ( INPUT Editor_Name , INPUT ProEditor ). */
  
END PROCEDURE . /* SysOptsGetPut */


PROCEDURE KeyVals .
 
/*----------------------------------------------------------------------------
  Purpose:  Reads/saves Key Values to and from Progress Environment File.  
  Syntax:
	    RUN KeyVals (INPUT p_Mode ,
                         INPUT p_Section ,
                         INPUT p_Key ,
                         INPUT-OUTPUT p_Value ) .

  Description:
  
  Author: John Palazzo

  Date Created: 11.17.92 
----------------------------------------------------------------------------*/
 
    DEFINE INPUT        PARAMETER p_Mode    AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT        PARAMETER p_Section AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT        PARAMETER p_Key     AS CHAR FORMAT "x(15)" NO-UNDO .
    DEFINE INPUT-OUTPUT PARAMETER p_Value   AS CHAR FORMAT "x(15)" NO-UNDO .

    DEFINE VARIABLE Key_Value AS CHAR NO-UNDO.
    
    /* proc-main */
    DO ON STOP  UNDO, RETURN ERROR
       ON ERROR UNDO, RETURN ERROR :

        /*-----------------------------------------------------------------
            Get the key value. Do this regadless of PUT or GET mode.
            Then, if PUT mode and the key's value is different than
            what's currently in environment file, go ahead and save
            the new value.
        -----------------------------------------------------------------*/
        
        ASSIGN Key_Value = p_Value .

        GET-KEY-VALUE SECTION p_Section KEY p_Key VALUE p_Value.
        IF ( p_Mode = "PUT" ) AND ( Key_Value <> p_Value )
        THEN DO:
            ASSIGN p_Value = Key_Value .
            PUT-KEY-VALUE SECTION p_Section KEY p_Key VALUE p_Value NO-ERROR.
            IF ERROR-STATUS:ERROR THEN STOP.
        END.
    END.
    
END PROCEDURE.	/* KeyVals */



PROCEDURE DlgSysOptions .
/*----------------------------------------------------------------------------
  Syntax:
	RUN DlgSysOptions .

  Description:
    Editor Preferences Dialog Box for viewing and setting editor 
    system options.
  
  Author: John Palazzo
----------------------------------------------------------------------------*/

  DEFINE BUTTON btn_OK	    LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
  DEFINE BUTTON btn_Cancel  LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON btn_Help    LABEL "&Help"
    {&STDPH_OKBTN}.
    
  DEFINE VARIABLE OK_Pressed AS LOGICAL NO-UNDO.

  /* Dialog Button Box */
  &IF {&OKBOX} &THEN
  DEFINE RECTANGLE SO_Btn_Box    {&STDPH_OKBOX}.
  &ENDIF

  /*---------------- Editor Settings Dialog Box ----------------*/    
  DEFINE FRAME DLG_SysOptions
    SKIP( {&TFM_WID} )
     "Exit Preferences:"  {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
        Sys_Options.Exit_Warning AT 5
    SKIP( {&VM_WID} )
        Save_BufList       AT 5
    SKIP( {&VM_WID} )
        MRU_FileList       AT 5
        MRU_Entries        AT 31 FORMAT "9" NO-LABEL
        "entries" VIEW-AS TEXT
    SKIP( {&VM_WIDG} )
     "Run Preferences:"   {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
        Minimize_BeforeRun AT 5
    SKIP( {&VM_WID} )
        Restore_AfterRun   AT 5
    SKIP( {&VM_WID} )
        Pause_AfterRun     AT 5
    SKIP( {&VM_WID} )
        Auto_Cleanup       AT 5
    { adecomm/okform.i
        &BOX    ="SO_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
  WITH TITLE "Preferences" SIDE-LABELS
       VIEW-AS DIALOG-BOX
               DEFAULT-BUTTON btn_OK
               CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DLG_SysOptions"
        &BOX    = "SO_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }
  
  ON HELP OF FRAME DLG_SysOptions ANYWHERE
    RUN adeedit/_edithlp.p ( INPUT "System_Options_Dialog_Box" ).
  ON CHOOSE OF btn_Help IN FRAME DLG_SysOptions
    RUN adeedit/_edithlp.p ( INPUT "System_Options_Dialog_Box" ).
  
  ON GO OF FRAME DLG_SysOptions
  DO:
    OK_Pressed = YES.
  END.
  
  ON WINDOW-CLOSE OF FRAME DLG_SysOptions
     OR CHOOSE OF btn_Cancel IN FRAME DLG_SysOptions
  DO:
    /* Nothing. */
  END.
  
  ON ENTRY OF FRAME DLG_SysOptions DO:
    IF NOT Sys_Options.MRU_FileList THEN 
      MRU_Entries:SENSITIVE IN FRAME DLG_SysOptions = FALSE.
  END.  /* of entry of frame */
  
  ON VALUE-CHANGED OF MRU_FileList IN FRAME DLG_SysOptions DO:
    IF MRU_FileList:SCREEN-VALUE = "yes" THEN ASSIGN
      MRU_Entries:SCREEN-VALUE = "4"
      MRU_Entries:SENSITIVE = TRUE.
    ELSE ASSIGN
      MRU_Entries:SCREEN-VALUE = "0"
      MRU_Entries:SENSITIVE = FALSE.
  END.  /* value-changed of filelist */
  
  ON VALUE-CHANGED OF MRU_Entries IN FRAME DLG_SysOptions DO:
    IF MRU_Entries:SCREEN-VALUE = "0" THEN ASSIGN
      MRU_FileList:SCREEN-VALUE = "no"
      MRU_Entries:SENSITIVE = FALSE.
  END.  /* value-changed of entries */

DO: /* MAIN */
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "WAIT" ) .
  FIND FIRST Sys_Options.
  RUN WinStatusMsg ( win_ProEdit , "MT_INPUT" , "" , "" ) .

  _DLG_BOX :
  DO  ON ERROR  UNDO _DLG_BOX , LEAVE _DLG_BOX 
      ON ENDKEY UNDO _DLG_BOX , LEAVE _DLG_BOX
      ON STOP   UNDO _DLG_BOX , LEAVE _DLG_BOX :
    UPDATE 
        Exit_Warning
        Save_BufList
        MRU_FileList
        MRU_Entries 
        Minimize_BeforeRun 
        Restore_AfterRun 
        Pause_AfterRun 
        Auto_Cleanup 
        btn_OK btn_Cancel btn_Help
    GO-ON ( GO,WINDOW-CLOSE )
    WITH FRAME DLG_SysOptions .
    IF LAST-EVENT:FUNCTION = "WINDOW-CLOSE" THEN UNDO, LEAVE.
  END.
  ASSIGN 
    MRU_FileList 
    MRU_Entries.
  RUN MRUList ( INPUT "":U ).
  HIDE FRAME DLG_SysOptions NO-PAUSE.
  
  IF OK_Pressed THEN
  DO ON STOP UNDO, LEAVE: /* Save settings and menu accelerators now. */
    RUN SysOptsGetPut ( INPUT "PUT":u ) .
    RUN adecomm/_mnkvals.p (INPUT win_ProEdit:MENUBAR ,
                            INPUT "PUT" , INPUT KeyValue_Section ,
                            INPUT Exclude_Menus /* see dsystem.i */ ,
                            OUTPUT g_Editor_Cached_Accels ).
  END. /* OK_Pressed */
  
  APPLY "ENTRY" TO ProEditor.

END.  /* MAIN */

END PROCEDURE.	/* DlgSysOptions */


PROCEDURE DlgMenuAccels.
/*----------------------------------------------------------------------------
  Syntax: RUN DlgMenuAccels.

  Description:
    Display Menu Accelerators dialog box and save accelerator settings if
    OK is pressed.
  
  Author: John Palazzo
----------------------------------------------------------------------------*/

  DO ON STOP  UNDO, LEAVE
     ON ERROR UNDO, LEAVE:
    RUN adecomm/_dlgmnua.p (INPUT win_ProEdit:MENUBAR , INPUT Exclude_Menus).
    IF RETURN-VALUE = "OK":U THEN /* Save accelerator settings now. */
      RUN adecomm/_mnkvals.p (INPUT win_ProEdit:MENUBAR ,
                              INPUT "PUT" , INPUT KeyValue_Section ,
                              INPUT Exclude_Menus /* see dsystem.i */ ,
                              OUTPUT g_Editor_Cached_Accels ).
  END. /* ON STOP */
  RETURN. /* Reset RETURN-VALUE to Null. */
  
END PROCEDURE.


PROCEDURE ChangeDefFont .
  /*---------------------------------------------------------------------------
     Presents the Default Editor Font dialog, which allows the user to choose a 
     default font for the Procedure Editor.  The chosen font is used as the
     font for new Buffers and Procedure Windows, when created.  Its also the 
     value stored in the Progress Environment File as the Procedure 
     Editor's default font.
   ---------------------------------------------------------------------------*/

    DEFINE BUFFER BEdit_Buffer FOR Edit_Buffer.
    
    DEFINE VAR Old_Font   AS INTEGER NO-UNDO.
    DEFINE VAR Pressed_OK AS LOGICAL NO-UNDO.

    DO ON STOP UNDO, LEAVE:
    
        FIND FIRST Sys_Options.
        ASSIGN Old_Font = Sys_Options.EditorFont .
        
        RUN adecomm/_chsfont.p ( INPUT Editor_Name + " Default Font" , 
                                 INPUT ?,  /* Use System Default Font */
  			         INPUT-OUTPUT Sys_Options.EditorFont ,
                                 OUTPUT Pressed_OK ) .
        IF ( Pressed_OK = TRUE ) AND ( Sys_Options.EditorFont <> Old_Font )
        THEN DO:
            /* Change as needed, the Editor Buffer Fonts. */
            FOR EACH BEdit_Buffer :
                IF ( BEdit_Buffer.hBuffer:FONT = Old_Font )
                    THEN BEdit_Buffer.hBuffer:FONT = Sys_Options.EditorFont .
            END.
            /* Change as needed, the Procedure Window Fonts. */
            RUN adecomm/_pwchfnt.p (INPUT Editor_Name  /* Parent_ID */ ,
                                    INPUT ?            /* PW Handle */ ,
                                    INPUT Old_Font , 
                                    INPUT Sys_Options.EditorFont ).
            /* Save the Font settings change. */
            RUN SysOptsGetPut ( INPUT "PUT":u ) .
        END.

    END.
    
END PROCEDURE.


PROCEDURE OptionsSetSave.
  /*--------------------------------------------------------------------------
    Purpose: Sets/Toggles the Save Settings on Exit system option.

    Run Syntax: RUN OptionsSetSave( INPUT p_Save_State ) .

    Parameters:
  INPUT
	p_Save_State (LOGICAL) - When TRUE, Procedure Editor 
    saves all system option values to Environment file.
    FALSE - settings are not saved when editor ends.
    Description:

    Notes: 
 
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Save_State AS LOGICAL NO-UNDO .
  
  /* proc-main */
  DO:
      FIND FIRST Sys_Options.
      ASSIGN Sys_Options.Save_Settings = p_Save_State .
  END.

END PROCEDURE.


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/* TTY Only Procedure. */
PROCEDURE CreateEditorBars.
/*--------------------------------------------------------------------------
    Purpose:        Creates the Character Procedure Editor top and
                    bottom editor bars and name of current buffer handle.

    Run Syntax:     RUN CreateEditorBars (INPUT p_Frame ) .

    Parameters:

          INPUT     p_Frame (WIDGET-HANDLE)
                    Handle to frame to place editor bars.

    Description:

    Notes:
---------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p_Frame        AS WIDGET-HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Cur_Buf_Name AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Top_Bar    AS WIDGET-HANDLE NO-UNDO.
    DEFINE VAR Bottom_Bar AS WIDGET-HANDLE NO-UNDO.

    DO:
        CREATE RECTANGLE Top_Bar
        ASSIGN 
            FRAME   = p_Frame
            ROW     = 1
            COL     = 1
            WIDTH   = p_Frame:WIDTH
            HEIGHT  = 1
            GRAPHIC-EDGE = YES
        . /* END ASSIGN. */
        
        CREATE RECTANGLE Bottom_Bar
        ASSIGN 
            FRAME   = p_Frame
            ROW     = p_Frame:HEIGHT
            COL     = 1
            WIDTH   = p_Frame:WIDTH
            HEIGHT  = 1
            GRAPHIC-EDGE = YES
            DCOLOR      = 2  /* DISPLAY COLOR MESSAGES in protermcap. */
            PFCOLOR     = 2  /* PROMPT-FOR COLOR MESSAGES in protermcap. */
        . /* END ASSIGN. */
        
        CREATE TEXT p_Cur_Buf_Name
        ASSIGN
            FRAME       = p_Frame
            AUTO-RESIZE = TRUE
            ROW         = Bottom_Bar:ROW
            COL         = 2
            DCOLOR      = 2  /* DISPLAY COLOR MESSAGES in protermcap. */
        . /* END ASSIGN. */
    END.

END PROCEDURE.
&ENDIF


PROCEDURE WinSetTitle .
/*
    RUN WinSetTitle ( p_Window , p_Text ) .
*/

  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT PARAMETER p_Text   AS CHARACTER	   NO-UNDO .

  DEFINE VAR Title_Text AS CHARACTER NO-UNDO.
  DEFINE VAR MaxWidth   AS INTEGER   NO-UNDO.

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
      ASSIGN p_Window:TITLE = Editor_Name + IF ( p_Text <> ""  )
                                            THEN " - " + p_Text
                                            ELSE "".
  &ELSE

      p_Text = " File: " + p_Text + " ".

      /* Max file display width is two less than the window width
         to account for the file name display starting at column 1
         and the trailing space added to make the display look nice. */
      MaxWidth = p_Window:WIDTH - 2.

      /* If file path is too long, get a short name for it. */
      IF LENGTH( p_Text ) > MaxWidth THEN
      DO:
          RUN adecomm/_ossfnam.p
              (INPUT  p_Text,
               INPUT  MaxWidth,
               INPUT  ? /* Font */,
               OUTPUT p_Text).
      END.
      hCur_Buf_Name:FORMAT = "x(" + 
                             STRING( MIN( LENGTH( p_Text ) , MaxWidth ) )
                                + ")" NO-ERROR.
      hCur_Buf_Name:SCREEN-VALUE = p_Text NO-ERROR.
  &ENDIF
END PROCEDURE. /* WinSetTitle */


PROCEDURE WinStatusMsg.
  /*

     RUN WinStatusMsg ( p_Window , p_Msg_Type , p_Message , 
   p_Mouse_Cursor ) .

  */

  DEFINE INPUT PARAMETER p_Window	AS WIDGET-HANDLE	 NO-UNDO .
  DEFINE INPUT PARAMETER p_Msg_Type	AS CHARACTER	 INIT "MT_INPUT" 
		NO-UNDO .
  DEFINE INPUT PARAMETER p_Message	AS CHARACTER	 INIT "" NO-UNDO .
  DEFINE INPUT PARAMETER p_Mouse_Cursor AS CHARACTER	 INIT "" NO-UNDO .

  DEFINE VAR Temp_Logical AS LOGICAL NO-UNDO.
  DEFINE VAR Immed_Disp AS LOGICAL NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    IF p_Message = ""
    THEN DO:
        ASSIGN p_Message = " " + KBLABEL("GO") + "=RUN  "
/* jep 2/12/96             + KBLABEL("HELP") + "=HELP  "                 */
                           + KBLABEL("ENTER-MENUBAR") + "=MENUS  "
                           + KBLABEL("GET") + "=OPEN  "
                           + KBLABEL("PUT") + "=SAVE  "
                           + KBLABEL("CLEAR") + "=CLOSE" .
       /* On vt100 based terminals, standard key labels cause CLOSE to be
          truncated.  So, remove double spacing between Function items. */
       /* 63 is max string length for PROGRESS STATUS LINE. */
       IF ( LENGTH( p_Message ) > 63 )
       THEN ASSIGN p_Message = REPLACE( p_Message , "  " , " " ).
    END.

  &ENDIF

  /* Needed to force display of status. */
  ASSIGN Immed_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
  IF p_Msg_Type <> "MT_INPUT" 
      THEN STATUS DEFAULT p_Message IN WINDOW p_Window.
      ELSE STATUS INPUT   p_Message IN WINDOW p_Window.
  /* Reset Immediate Display. */
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Immed_Disp.
  RUN adecomm/_setcurs.p ( INPUT p_Mouse_Cursor ).

END PROCEDURE.


PROCEDURE _winevnt.p .
/*----------------------------------------------------------------------------
  Purpose:  Executes appropriate Window Event Procedure for Procedure Editor.

  Syntax:
            RUN _winevnt.p ( INPUT p_Win_Event ).

  Description:

           The Window Event procedures for PERSISTENT RUN triggers are not
           found by Progress when running user application code.  Therefore,
           a call is made to this procedure first.  An external .p file called
           _winevnt.p is in $DLC/gui.  Its a no-op procedure and will be
           found by Progress instead of the internal _winevnt procedure.
           This avoids the unpleasant "could not find file" error.

           See external _winevnt.p for more details.

  Author: John Palazzo
----------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Win_Event AS CHARACTER NO-UNDO.

    /* proc-main */
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:

      CASE p_Win_Event :
        WHEN "ED_WINDOW_CLOSE"
          THEN RUN WinExitEditor.
      END CASE.

    END.
    /* Prevent Beep from Window System. */
    RETURN ERROR.

END PROCEDURE.


PROCEDURE BufValidName .
  /*-------------------------------------------------------------
     Returns TRUE
       -  Buffer Name is blank, null, or unknown.
       -  If no buffer with same name as p_Buffer_Name
          already exists (other than itself, of course) or
       -  If user is attempting to assign a second editor buffer to the same
          OS file.

     Returns FALSE otherwise.
  -------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_Buffer        AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT  PARAMETER p_Buffer_Name   AS CHAR          NO-UNDO .
  DEFINE OUTPUT PARAMETER p_Valid_BufName AS LOGICAL INIT TRUE NO-UNDO .

  DEFINE BUFFER bEdit_Buffer FOR Edit_Buffer.
  DEFINE VARIABLE Fullpath_Buffer_Name AS CHAR NO-UNDO .

    IF ( TRIM( p_Buffer_Name ) = "" ) OR ( p_Buffer_Name = ? )
    THEN DO:
      MESSAGE p_Buffer_Name SKIP
              "Cannot assign buffer name." SKIP(1)
              "A blank buffer name is invalid."
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      p_Valid_BufName = FALSE .
      RETURN.
    END.

    /* Check 1) Buffer with same name already open? */
    FIND FIRST bEdit_Buffer WHERE ( bEdit_Buffer.Buffer_Name = p_Buffer_Name )
			    AND ( bEdit_Buffer.hBuffer <> p_Buffer )
			    NO-ERROR.
    IF AVAILABLE( bEdit_Buffer )
    THEN DO:
      MESSAGE p_Buffer_Name SKIP
	      "Cannot assign buffer name." SKIP(1)
	      "A buffer already exists with this name."
	      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      p_Valid_BufName = FALSE .
    END.
    ELSE DO:
      /* Check 2) Buffer already open for specified OS file? */
      FILE-INFO:FILENAME = p_Buffer_Name.
      Fullpath_Buffer_Name = FILE-INFO:FULL-PATHNAME.
      IF Fullpath_Buffer_Name = ? THEN RETURN.	
	 /* File not in PROPATH, so can't make any determination.  Guess that
its valid. */
	 
      FIND FIRST bEdit_Buffer WHERE ( bEdit_Buffer.File_Name = 
		Fullpath_Buffer_Name )
				AND ( bEdit_Buffer.hBuffer <> p_Buffer	     
 )	
			      NO-ERROR.
      IF AVAILABLE( bEdit_Buffer )
      THEN DO:
	MESSAGE p_Buffer_Name SKIP
		"Cannot assign buffer name." SKIP(1)
		"A buffer is already open for this file."
		VIEW-AS ALERT-BOX WARNING BUTTONS OK.
	p_Valid_BufName = FALSE .
      END.
    END.

END PROCEDURE.	/* BufValidName */


PROCEDURE QuitBuffer .
  /* Returns TRUE if buffer is a QUIT buffer; FALSE if not. */
    DEFINE INPUT  PARAMETER p_Buffer AS WIDGET-HANDLE      NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Quit   AS LOGICAL INIT FALSE NO-UNDO.

    DEFINE VARIABLE Buffer_Code AS CHAR NO-UNDO.

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    IF ( p_Buffer:NUM-LINES < 6 ) /* Avoids ditem errors. */
    THEN DO:
    &ELSE
    IF ( p_Buffer:LENGTH < 256 ) /* Avoids ditem errors. */
    THEN DO:
    &ENDIF
      /*----------------------------------------------------------------
         Following code tests if buffer code is just a QUIT statement.

         1. Trim off any leading or trailing white space.
         2. Test if QUIT token is the first non-whitespace word
            in buffer.  If not, its not a QUIT-only buffer.
         3. The IF Buffer tests for a buffer of only "QUIT or "QUIT.".
         4. The "ELSE IF (..." tests the case where the token QUIT
            is not followed immediately by its terminating period
            and or its terminating period has something following it.
            The only characters we allow between QUIT and its period
            is whitespace.  The ELSE IF checks this.
      ----------------------------------------------------------------*/
      Buffer_Code = TRIM( p_Buffer:SCREEN-VALUE ) .
      IF ( Buffer_Code BEGINS "QUIT" )
      THEN DO:
        IF ( Buffer_Code = "QUIT" ) OR ( Buffer_Code = "QUIT." )
        THEN p_Quit = TRUE .
        ELSE IF ( INDEX( Buffer_Code , "." ) > 0 AND
                  TRIM( SUBSTRING(Buffer_Code , 5 ) ) = "." )
        THEN p_Quit = TRUE .
      END.
    END. /* IF Quit_Pending */
END PROCEDURE.
