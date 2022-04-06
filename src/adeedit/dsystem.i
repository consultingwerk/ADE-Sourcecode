/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dsystem.i
  Editor-Wide DEFINES.
--------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER p_File_List AS CHARACTER NO-UNDO.
  /* Files editor should open automatically on start-up. */
DEFINE INPUT PARAMETER p_Edit_Command AS CHARACTER NO-UNDO.
  /*---------------------------------------------------------------
    Edit Command.  Behavoir is as follows:
        1. "NEW"         - Ignore p_File_List and Saved Buffer List.  Gives
                           user Empty Untitled buffer.
        2. Anything Else - If p_File_List has value, use it.
                           Otherwise, use Saved Buffer List.
    See Also: adeedit/pinit.i PROCEDURE InitFileList .
  ---------------------------------------------------------------*/
        
/* Not implemented.
DEFINE INPUT PARAMETER p_Obj_IDList AS CHARACTER NO-UNDO.
  /*--------------------------------------------------------------- 
     ADE Object Names for Files editor should open automatically. 
     Null value means this list can be ignored. 
  ---------------------------------------------------------------*/
*/

DEFINE NEW GLOBAL SHARED VAR g_Editor_Cached_Accels AS CHAR NO-UNDO.
    /*------------------------------------------------------------
       To keep Procedure Editor from reading the Menu Accelerators
       for the Editor menu every time the editor is invoked,
       this var is assigned menu accelerator values when:
            1) Editor is invoked for first time during a session.
            2) When the user changes the Accelerators using
               the Menus Accelerator dialog.
       Note: If user changes Env. File during a Progress session,
       Editor will not see changes after first invocation.
       
       Form:
       Comma-delimited list of Menu Items and their accelerators 
       in the form:
                                
          "MenuLabel:Accelerator,..."
                                
       The menu labels have all &, spaces, and ellipses removed.
    ------------------------------------------------------------*/
DEFINE VARIABLE Exclude_Menus AS CHARACTER INIT "&Tools" NO-UNDO.
  /* Comma-delimited list of Editor Menus to not assign/read menu 
     accelerators.  The Tools menu is built dynamically at run-time.
  */
  
/*--------------------------------------------------------------------------
             Editor System-Related Defines for Editor 
--------------------------------------------------------------------------*/
DEFINE VARIABLE Editor_Name AS CHARACTER INIT "Procedure Editor" NO-UNDO.
  /* Name of PROGRESS Editor.  Used in Window:Title, etc. */

DEFINE VARIABLE ProEditor AS WIDGET-HANDLE NO-UNDO.
  /* Editor's Edit Buffer. */

DEFINE VARIABLE win_ProEdit AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE win_ProEdit_Menubar AS WIDGET-HANDLE NO-UNDO. /* SOURCE-EDITOR */

/* Editor System Options Definitions.  Used as default editor-wide settings. */
DEFINE VAR KeyValue_Section AS CHAR INITIAL "Proedit" .

DEFINE WORK-TABLE Sys_Options NO-UNDO
  FIELD KeyGroup AS CHAR INITIAL "SysOptions":u
  
  /* Exit Options */
  FIELD Save_Settings AS LOGICAL LABEL "Save Settings on Exit" 
  		        INITIAL NO VIEW-AS TOGGLE-BOX 
  FIELD Exit_Warning  AS LOGICAL LABEL "Exit Warning to Save Changes" 
  		      INITIAL YES VIEW-AS TOGGLE-BOX 
  FIELD Save_BufList  AS LOGICAL LABEL "Save Buffer List to Open on Startup" 
  		      INITIAL NO VIEW-AS TOGGLE-BOX 
  FIELD BufList       AS CHAR INITIAL ""
  
  /* Run Options */
  FIELD Minimize_BeforeRun  AS LOGICAL LABEL "Minimize Editor Before Running"
  		            INITIAL NO VIEW-AS TOGGLE-BOX
  FIELD Restore_AfterRun    AS LOGICAL LABEL "Restore Editor After Running"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD Pause_AfterRun      AS LOGICAL LABEL "Pause After Running"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD Auto_Cleanup        AS LOGICAL LABEL "Auto-Cleanup Dynamic Widgets"
  		            INITIAL YES VIEW-AS TOGGLE-BOX
  FIELD MRU_FileList        AS LOGICAL LABEL "Recently Used Filelist:"
                          INITIAL NO VIEW-AS TOGGLE-BOX
  FIELD MRU_Entries         AS INTEGER VIEW-AS FILL-IN INITIAL 0
  		            
  FIELD EditorFont	    AS INTEGER INITIAL ?
  FIELD BG_Color            AS INTEGER INITIAL ?
  FIELD FG_Color            AS INTEGER INITIAL ?
  FIELD SaveClass_BeforeRun AS LOGICAL LABEL "Auto-Save Class Before Running"
                    INITIAL NO VIEW-AS TOGGLE-BOX
  /* END DEFINE */ .

    
DEFINE VARIABLE Untitled AS CHARACTER INIT "Untitled:" NO-UNDO .
  /* 
     Beginning Name of an untitled ProEditor file.  A number is added after (:)
  */
DEFINE VARIABLE Num_Untitled_Buffers AS INTEGER NO-UNDO .
  /* Incrementing counter for untitled buffers. */


DEFINE VARIABLE  User_Selection AS CHARACTER NO-UNDO.
  /*  User's selected action (e.g., "OK" or "CANCEL").  */

DEFINE VARIABLE Saved_File AS LOGICAL NO-UNDO.
  /* Used system-wide to determine if file is saved successfully. */
  
DEFINE VARIABLE Quit_Pending AS LOGICAL INIT FALSE NO-UNDO .
  /* Indicates if QUIT statement executed when running user's code. */
    
DEFINE VAR Edit_Win_State AS INTEGER NO-UNDO.
  /* Editor Window state before Run or Debug. */

DEFINE VAR hCur_Buf_Name AS WIDGET-HANDLE NO-UNDO.
  /* Handle to widget which displays name of current buffer in Char mode. */

/*    Temp-table used to store the internally maintained list of 
      most recently used files */
DEFINE TEMP-TABLE MRU_Files NO-UNDO
    FIELD mru_file         AS CHARACTER
    FIELD mru_position     AS INTEGER
    INDEX mru_idx_position IS UNIQUE PRIMARY mru_position ASCENDING
    INDEX mru_idx_pos_desc IS UNIQUE mru_position         DESCENDING
    INDEX mru_idx_file     IS UNIQUE mru_file             ASCENDING.

/*-----------------------------  DEFINE FORMS -------------------------------*/

/*---------------------------------------------------------------------
   Editor Frame.  All editor widgets get created in this frame.
   In TTY, only current buffer has :VISIBLE = TRUE.  In GUI (which can
   clip overlayed widgets), all buffers have :VISIBLE = TRUE (but only
   current buffer can be seen).
---------------------------------------------------------------------*/

FORM WITH FRAME f_Buffers NO-LABELS NO-BOX.
