&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/*------------------------------------------------------------------------

  File:         _abmbar.w

  Description:  AppBuilder Menubar Persistent Procedure. Creates a menubar
                the AppBuilder uses as a replacement for it's default
                menubar. Part of commercial ICF support.
                
  Syntax:       RUN adeuib/_abmbar.w PERSISTENT SET _h_menubar_proc.
                (Example variable name used is from adeuib/sharvars.i)

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Notes:        This .w acts as a menubar editor for the AppBuilder's ICF menubar
                and for menu-item enable/disable state. It's menubar and all
                labels used for the menu-items must be kept exactly as the
                AppBuilder's is defined (statically in adeuib/uibmdefs.i). This is
                important to how the enable/disable code works.
                
                The window created in this procedure is not actually used during
                run-time and is therefore deleted during main-block initialization.
                When this .w is edited/run in the AppBuilder, the window remains so
                the menubar functionality can be viewed and tested.
                
                If the location of the ICF menu on the main menubar changes, then
                we must change the location of the ICF menu code in uibmproe.i
                procedure morph-mode accordningly. See the comments in that
                procedure as well.

  
  Author:       jep (J. Palazzo, jep@progress.com)
  Created:      August, 2001

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
/* Above comment doesn't apply here. This procedure is meant to work
   inside of the AppBuilder's widget pools, so we won't create our own. */
/* CREATE WIDGET-POOL.  */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Shared Variable Definitions ---                                       */
{adeuib/pre_proc.i}
{adeuib/uibhlp.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

/* Global Variable Definitions ---                                      */
/* jep-icf-temp: Should call Repos API and not icf globals directly. */
DEFINE NEW GLOBAL SHARED VARIABLE gshSessionManager     AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gshRepositoryManager  AS HANDLE       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE AB_Default_MenubarHandle    AS HANDLE       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CanAddtoRepos C-Win 
FUNCTION CanAddtoRepos RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsContainerObject C-Win 
FUNCTION IsContainerObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsStaticObject C-Win 
FUNCTION IsStaticObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_New          LABEL "&New..."        ACCELERATOR "SHIFT-F3"
       RULE
       MENU-ITEM m_Open_Object  LABEL "Open O&bject..." ACCELERATOR "CTRL-O"
       MENU-ITEM m_Open         LABEL "&Open File..."  ACCELERATOR "F3"
       MENU-ITEM m_Close        LABEL "&Close"         ACCELERATOR "F8"
       MENU-ITEM m_close_all    LABEL "C&lose Windows..." ACCELERATOR "SHIFT-F8"
       RULE
       MENU-ITEM m_Save         LABEL "&Save"          ACCELERATOR "F6"
       MENU-ITEM m_Save_As      LABEL "Save &As..."    ACCELERATOR "SHIFT-F6"
       MENU-ITEM m_Save_All     LABEL "Sa&ve All"     
       MENU-ITEM m_Add_to_Repos LABEL "Add to &Repository..."
       RULE
       MENU-ITEM m_ReLogon      LABEL "Re-&Logon..."  
       MENU-ITEM m_Session_Reset LABEL "Session Rese&t..."
       RULE
       MENU-ITEM m_Print        LABEL "&Print"        
       RULE.

DEFINE SUB-MENU m_Edit 
       MENU-ITEM m_Undo         LABEL "&Undo"          ACCELERATOR "CTRL-Z"
       RULE
       MENU-ITEM m_Cut          LABEL "Cu&t"           ACCELERATOR "CTRL-X"
       MENU-ITEM m_Copy         LABEL "&Copy"          ACCELERATOR "CTRL-C"
       MENU-ITEM m_Paste        LABEL "&Paste"         ACCELERATOR "CTRL-V".

DEFINE SUB-MENU m_Compile 
       MENU-ITEM m_Run          LABEL "&Run"           ACCELERATOR "F2"
       MENU-ITEM m_check        LABEL "&Check Syntax"  ACCELERATOR "SHIFT-F2"
       MENU-ITEM m_debugger     LABEL "&Debug"         ACCELERATOR "SHIFT-F4"
       RULE
       MENU-ITEM m_Dynamic_Run_Launcher LABEL "Dynamic &Launcher..." ACCELERATOR "CTRL-F2"
       MENU-ITEM m_Clear_Repository_Cache LABEL "Clear Repository C&ache..."
       RULE
       MENU-ITEM m_preview      LABEL "Code &Preview"  ACCELERATOR "F5".

DEFINE SUB-MENU m_Build 
       MENU-ITEM m_Generate_Objects LABEL "&Generate Objects".

DEFINE SUB-MENU m_Tools 
       MENU-ITEM m_new_pw       LABEL "Ne&w Procedure Window" ACCELERATOR "CTRL-F3"
       MENU-ITEM m_new_adm2_class LABEL "New AD&M Class...".

DEFINE SUB-MENU m_Options 
       MENU-ITEM m_user_prefs   LABEL "&Preferences...".

DEFINE MENU AB-Menubar MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Edit         LABEL "&Edit"         
       SUB-MENU  m_Compile      LABEL "&Compile"      
       SUB-MENU  m_Build        LABEL "&Build"        
       SUB-MENU  m_Tools        LABEL "&Tools"        
       SUB-MENU  m_Options      LABEL "&Options"      .


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.6 BY 2.76.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "AB_Menubar_Proc"
         HEIGHT             = 2.76
         WIDTH              = 126.2
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 173.8
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 173.8
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = no.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU AB-Menubar:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* AB_Menubar_Proc */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* AB_Menubar_Proc */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Add_to_Repos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Add_to_Repos C-Win
ON CHOOSE OF MENU-ITEM m_Add_to_Repos /* Add to Repository... */
DO:
    RUN choose_add_to_repos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_check
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_check C-Win
ON CHOOSE OF MENU-ITEM m_check /* Check Syntax */
DO:
    /* Check Syntax of current window */
    RUN choose_check_syntax IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Clear_Repository_Cache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Clear_Repository_Cache C-Win
ON CHOOSE OF MENU-ITEM m_Clear_Repository_Cache /* Clear Repository Cache... */
DO:
    RUN ry/prc/ryclrcachp.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Close C-Win
ON CHOOSE OF MENU-ITEM m_Close /* Close */
DO:
    /* Close only the current window */
    RUN choose_close IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_close_all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_close_all C-Win
ON CHOOSE OF MENU-ITEM m_close_all /* Close Windows... */
DO:
    /* Close one or more windows */
    RUN choose_close_all IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Copy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Copy C-Win
ON CHOOSE OF MENU-ITEM m_Copy /* Copy */
DO:
    RUN choose_copy IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cut C-Win
ON CHOOSE OF MENU-ITEM m_Cut /* Cut */
DO:
    RUN choose_cut IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_debugger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_debugger C-Win
ON CHOOSE OF MENU-ITEM m_debugger /* Debug */
DO:
    /* Debug current window */
    RUN choose_debug IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Dynamic_Run_Launcher
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Dynamic_Run_Launcher C-Win
ON CHOOSE OF MENU-ITEM m_Dynamic_Run_Launcher /* Dynamic Launcher... */
DO:
    RUN runDynamicRunLauncher IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Generate_Objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Generate_Objects C-Win
ON CHOOSE OF MENU-ITEM m_Generate_Objects /* Generate Objects */
DO:
    RUN runGenerateObjects IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_New
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_New C-Win
ON CHOOSE OF MENU-ITEM m_New /* New... */
DO:
    RUN choose_file_new IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_new_adm2_class
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_new_adm2_class C-Win
ON CHOOSE OF MENU-ITEM m_new_adm2_class /* New ADM Class... */
DO:
    RUN choose_new_adm2_class IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_new_pw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_new_pw C-Win
ON CHOOSE OF MENU-ITEM m_new_pw /* New Procedure Window */
DO:
    /* Open a New Procedure Window. */
    RUN choose_new_pw IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Open
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open C-Win
ON CHOOSE OF MENU-ITEM m_Open /* Open File... */
DO:
    /* Open a File */
    RUN choose_file_open IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Open_Object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open_Object C-Win
ON CHOOSE OF MENU-ITEM m_Open_Object /* Open Object... */
DO:
    /* Open Object */
    RUN choose_object_open IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Paste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Paste C-Win
ON CHOOSE OF MENU-ITEM m_Paste /* Paste */
DO:
    RUN choose_paste IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_preview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_preview C-Win
ON CHOOSE OF MENU-ITEM m_preview /* Code Preview */
DO:
    RUN choose_code_preview IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Print C-Win
ON CHOOSE OF MENU-ITEM m_Print /* Print */
DO:
    RUN choose_file_print IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ReLogon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ReLogon C-Win
ON CHOOSE OF MENU-ITEM m_ReLogon /* Re-Logon... */
DO:
    RUN relogon IN gshSessionManager.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Run
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Run C-Win
ON CHOOSE OF MENU-ITEM m_Run /* Run */
DO:
    /* Running (or hitting GO/F2 in any window) test-runs the window */
    RUN choose_run IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save C-Win
ON CHOOSE OF MENU-ITEM m_Save /* Save */
DO:
    RUN choose_file_save IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_All
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_All C-Win
ON CHOOSE OF MENU-ITEM m_Save_All /* Save All */
DO:
    RUN choose_file_save_all IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_As
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_As C-Win
ON CHOOSE OF MENU-ITEM m_Save_As /* Save As... */
DO:
    RUN choose_file_save_as IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Session_Reset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Session_Reset C-Win
ON CHOOSE OF MENU-ITEM m_Session_Reset /* Session Reset... */
DO:
    RUN af/cod2/afprogrunw.w PERSISTENT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Undo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Undo C-Win
ON CHOOSE OF MENU-ITEM m_Undo /* Undo */
DO:
    RUN choose_undo IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_user_prefs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_user_prefs C-Win
ON CHOOSE OF MENU-ITEM m_user_prefs /* Preferences... */
DO:
    RUN edit_preferences IN _h_UIB.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

SUBSCRIBE TO 'ClientCachedDataChanged' IN gshSessionManager RUN-PROCEDURE 'displayStatusbarInfo'.

ASSIGN THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE IN WINDOW {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
    RUN disable_UI.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  &IF DEFINED(UIB_is_Running) > 0 &THEN
    /* Running in AB development-mode. Keep the window and show it so
       menubar functionality can be tested.  */
    ASSIGN {&WINDOW-NAME}:VISIBLE   = TRUE.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = TRUE.
    ASSIGN FRAME {&FRAME-NAME}:VISIBLE = TRUE.
    ENABLE ALL IN WINDOW {&WINDOW-NAME}.
  &ELSE
    /* We don't want the window hanging around. We got it's menu-bar so
       get rid of it. This also deallocates the menu-bar from this
       window so it can be reassigned to the AppBuilder main window. */
    IF VALID-HANDLE({&WINDOW-NAME}) THEN
    DO:
        DELETE WIDGET {&WINDOW-NAME}.
    END.
  &ENDIF

  RUN addBuildTools (INPUT MENU m_Build:HANDLE).

  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* Define this procedure as a persistent ADE Tool procedure. */
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addBuildTools C-Win 
PROCEDURE addBuildTools :
/*------------------------------------------------------------------------------
  Purpose:     Dynamically adds options to the AppBuilder's Build menu.
  Parameters:  h_parent : Handle of the parent menu, in this case, a Build menu.
  Notes:       
               
               Progress does not allow a RUN..PERSISTENT call from a
               PERSISTENT trigger. So, we have to call an internal procedure
               to this-procedure and then it in turn can perform the actual
               RUN..PERSISTENT.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER h_parent AS HANDLE     NO-UNDO.

    DEFINE VARIABLE h_menu_item AS HANDLE     NO-UNDO.

    DO ON ERROR UNDO, LEAVE:
      /* Because the AB treats a top menu bar menu as a menu-item if it has
         no items, the Generate Objects item is defined as a static item
         in the Build menu and the rest of the items are added dynamically. */
/*       CREATE MENU-ITEM h_menu_item                                                               */
/*           ASSIGN LABEL = "&Generate Objects"   PARENT = h_parent                                 */
/*           TRIGGERS: ON CHOOSE PERSISTENT RUN runGenerateObjects IN THIS-PROCEDURE. END TRIGGERS. */
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "&Page Layout"   PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runPageLayout IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "&Toolbar and Menu Designer"   PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runToolbarDesigner IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "Rep&ository Maintenance"    PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runRepObjectMaint IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "S&martDataField Maintenance"    PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runSDFMaintenance IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN SUBTYPE = "RULE" PARENT = h_parent.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "Tree &Node Control"   PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runTreeNode IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "&TreeView Wizard"   PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runTreeView IN THIS-PROCEDURE. END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN SUBTYPE = "RULE" PARENT = h_parent.
        CREATE MENU-ITEM h_menu_item
            ASSIGN LABEL = "Set Site Number"    PARENT = h_parent
            TRIGGERS: ON CHOOSE PERSISTENT RUN runSetSiteNumber IN THIS-PROCEDURE. END TRIGGERS.
    END. /* DO ON ERROR */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addICFTools C-Win 
PROCEDURE addICFTools :
/*------------------------------------------------------------------------------
  Purpose:     Dynamically adds Dynamics options to the AppBuilder's Tools menu.
  Parameters:  h_parent : Handle of the parent menu, in this case, a Tools menu.
  Notes:       The AppBuilder makes a call to this procedure during it's menu
               initialization in procedure morph-mode uibmproe.i.
               
               Progress does not allow a RUN..PERSISTENT call from a
               PERSISTENT trigger. So, we have to call an internal procedure
               to this-procedure and then it in turn can perform the actual
               RUN..PERSISTENT.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER h_parent AS HANDLE     NO-UNDO.

    DEFINE VARIABLE h_menu_item AS HANDLE     NO-UNDO.

      CREATE MENU-ITEM h_menu_item
          ASSIGN SUBTYPE = "RULE"                 PARENT = h_parent.
      CREATE MENU-ITEM h_menu_item
          ASSIGN LABEL = "Dynamics &Administration"    PARENT = h_parent
          TRIGGERS: ON CHOOSE PERSISTENT RUN runICFAdmin IN THIS-PROCEDURE. END TRIGGERS.
      CREATE MENU-ITEM h_menu_item
          ASSIGN LABEL = "Dynamics De&velopment"       PARENT = h_parent
          TRIGGERS: ON CHOOSE PERSISTENT RUN runICFDev IN THIS-PROCEDURE. END TRIGGERS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_add_to_repos C-Win 
PROCEDURE choose_add_to_repos :
/*------------------------------------------------------------------------------
  Purpose:     Does the Add to Repository AB option.
  Parameters:  <none>
  Notes:       Works against the current design window _h_win.
              Part of IZ 2513 Error when trying to save structured include
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cFilename   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSavedPath  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cError      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE pressed-ok  AS LOGICAL    NO-UNDO.

    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    IF NOT AVAILABLE _P THEN RETURN.
    
    /* Run Add to Repos dialog and perform add to repos if need be. */
    RUN adeuib/_reposaddfl.p
        (INPUT _h_menu_win,             /* Parent Window    */
         INPUT RECID(_P),               /* _P recid         */
         INPUT _P.product_module_code,  /* Product Module   */
         INPUT _P._SAVE-AS-FILE,        /* Object to add    */
         INPUT _P._TYPE,                /* File type        */
         OUTPUT pressed-ok).
    
    IF pressed-OK THEN
        /* Can we perform an Add to repos any more? */
        ASSIGN MENU-ITEM m_Add_to_Repos:SENSITIVE IN MENU m_file = CanAddtoRepos().
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy C-Win 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:    Destroy and close this-procedure. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayStatusbarInfo C-Win 
PROCEDURE displayStatusbarInfo :
/*------------------------------------------------------------------------------
  Purpose:     Display ICF information in AB status bar.
  Parameters:  <none>
  Notes:       SUBSCRIBE TO 'ClientCachedDataChanged':u IN gshSessionManager
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPropertyValues             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCurrentUserLogin           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCurrentOrganisationName    AS CHARACTER  NO-UNDO.
    
    /* jep-icf-temp: Should be calling appropriate icf API and not
       gshSessionManager directly. */
    IF NOT VALID-HANDLE(gshSessionManager) THEN RETURN.
    
    cPropertyValues = DYNAMIC-FUNCTION('getPropertyList' IN gshSessionManager, "currentUserName,currentOrganisationName", TRUE).
    cCurrentUserLogin         = ENTRY(1,cPropertyValues,CHR(3)) NO-ERROR.
    cCurrentOrganisationName  = ENTRY(2,cPropertyValues,CHR(3)) NO-ERROR.

    RUN adecomm/_statdsp.p (_h_status_line, 5, cCurrentUserLogin).
    RUN adecomm/_statdsp.p (_h_status_line, 6, cCurrentOrganisationName).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doNothing C-Win 
PROCEDURE doNothing :
/*------------------------------------------------------------------------------
  Purpose:     Does "nothing" so accelerator keys added to a dynamic object
               design window via adeuib/grptrig.i can be effectively
               disabled. Certain options don't apply, so we disable their shorcuts.
  Parameters:  <none>
  Notes:       The accelerator keys that are disabled are defined by triggers
               added to the design window's frame in adeuib/_setdesignwin.w.
------------------------------------------------------------------------------*/

    DO ON ERROR UNDO, LEAVE:
        MESSAGE "The option selected is not enabled for this object type."
          VIEW-AS ALERT-BOX INFORMATION.
    END.    
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMenubarHandle C-Win 
PROCEDURE getMenubarHandle :
/*------------------------------------------------------------------------------
  Purpose:     Return the handle to the menubar defined in this-procedure.
               The AB then replaces its default menubar with this one.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phABDefaultMenubar AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER phMenubar          AS HANDLE NO-UNDO.

    DO ON ERROR UNDO, LEAVE:
        /* Return the menubar handle. */
        ASSIGN phMenubar = MENU AB-Menubar:HANDLE NO-ERROR.
        
        /* Store away the AB's default menubar handle. This menu bar procedure
           uses it to help set the enable/disable states of the new menubar. */
        RUN setAttribute IN THIS-PROCEDURE
          ("AB_Default_MenubarHandle", STRING(phABDefaultMenubar)).

    END.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runDynamicRunLauncher C-Win 
PROCEDURE runDynamicRunLauncher :
/*------------------------------------------------------------------------------
  Purpose:     Runs Dynamic Run Launcher window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO ON ERROR UNDO, LEAVE:    
        RUN ry/uib/rycsolnchw.w PERSISTENT.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runGenerateObjects C-Win 
PROCEDURE runGenerateObjects :
/*------------------------------------------------------------------------------
  Purpose:     Runs Generate Objects window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO ON ERROR UNDO, LEAVE:    
        RUN af/cod2/fulloobjcw.w PERSISTENT.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runICFAdmin C-Win 
PROCEDURE runICFAdmin :
/*------------------------------------------------------------------------------
  Purpose:     Runs ICF Administration window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "afallmencw":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runICFDev C-Win 
PROCEDURE runICFDev :
/*------------------------------------------------------------------------------
  Purpose:     Runs ICF Development window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "rywizmencw":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runLaunchContainer C-Win 
PROCEDURE runLaunchContainer :
/*------------------------------------------------------------------------------
  Purpose:      Runs ICF Launch Dynamic SmartObject Container.
  Parameters:   Input pObjectName - Name of container object to launch.
                Output phRun - Procedure handle of launched object.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pObjectName  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phRun        AS HANDLE    NO-UNDO.
  
  RUN-BLOCK:
  DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
  
      /* 1st clear client cache      */
      IF VALID-HANDLE(gshRepositoryManager) THEN
        RUN clearClientCache IN gshRepositoryManager.
      
      /* TreeView container */
      IF (pObjectName = "rycsotreew") THEN
      DO:
          RUN ry/uib/rydyntreew.w PERSISTENT SET phRun.
      END.
      /* Standard container */
      ELSE
      DO:
          RUN ry/uib/rydyncontw.w PERSISTENT SET phRun.
      END.
      
      DYNAMIC-FUNCTION('setLogicalObjectName' IN phRun, INPUT pObjectName ).
      RUN initializeObject IN phRun.
      
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runPageLayout C-Win 
PROCEDURE runPageLayout :
/*------------------------------------------------------------------------------
  Purpose:     Runs Page Layout tool.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO ON ERROR UNDO, LEAVE:    
        RUN ry/uib/rypagelayw.w PERSISTENT.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runRepObjectMaint C-Win 
PROCEDURE runRepObjectMaint :
/*------------------------------------------------------------------------------
  Purpose:     Runs Repository Object Maintenance Tool
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "rycsotreew":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runSDFMaintenance C-Win 
PROCEDURE runSDFMaintenance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "rydynsdfmw":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runSetSiteNumber C-Win 
PROCEDURE runSetSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     Runs Set Site Number program.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO ON ERROR UNDO, LEAVE:    
        RUN af/obj2/gsmsisetvw.w PERSISTENT.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runToolbarDesigner C-Win 
PROCEDURE runToolbarDesigner :
/*------------------------------------------------------------------------------
  Purpose:     Runs Toolbar/Menu Designer.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hRun AS HANDLE     NO-UNDO.

    DO ON ERROR UNDO, LEAVE:    
        RUN af/cod2/afmenumaintw.w PERSISTENT SET hRun.
        RUN initializeObject IN hRun.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runTreeNode C-Win 
PROCEDURE runTreeNode :
/*------------------------------------------------------------------------------
  Purpose:     Runs TreeView Node Control
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "gsmndobjcw":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runTreeView C-Win 
PROCEDURE runTreeView :
/*------------------------------------------------------------------------------
  Purpose:     Runs TreeView Generation
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR hRun AS HANDLE.

    RUN runLaunchContainer (INPUT "rymwtobjcw":u, OUTPUT hRun).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitize_main_window C-Win 
PROCEDURE sensitize_main_window :
/*------------------------------------------------------------------------------
  Purpose:     Set the sensitive state (enable/disable) of the menubar.
  Parameters:  pCheck
  Notes:       Based on sensitize_main_window in uibmproe.i. Keep in sync.
------------------------------------------------------------------------------*/

/* sensitize_main_window - change the sensitive status of widgets in the UIB's
 *       main window based on the current state of affairs.
 *       There are various things we can check for in this procedure.  These are
 *       listed in the pCheck string.  The items are:
 *          WINDOW - check for the existance of a window, and its type
 *          WIDGET - check for the existance and type of _h_cur_widg
 */
  DEFINE INPUT PARAMETER pCheck AS CHAR NO-UNDO.

  DEFINE VARIABLE window-check  AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE widget-check  AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE h_mitem       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cLabel        AS CHARACTER    NO-UNDO.

  /* Decide what items to check. */
  ASSIGN widget-check = CAN-DO(pCheck, "WIDGET") 
         window-check = CAN-DO(pCheck, "WINDOW").

  /* Do window checking. Are there windows open and why at type affects the enable/disable
     state of several menus and their items. */
  IF window-check THEN
  DO:
      /* Process the top-level menu-bar items (File, Edit, etc.). */
      ASSIGN h_mitem = AB_Default_MenubarHandle:FIRST-CHILD NO-ERROR.
      DO WHILE VALID-HANDLE(h_mitem):
          /* Assign No-Error skips items that don't have labels. */
          ASSIGN cLabel = ?.
          ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
          IF (cLabel <> ?) THEN
          DO:
              CASE cLabel:
                  WHEN MENU m_file:LABEL THEN RUN setFileMenuState IN THIS-PROCEDURE (INPUT h_mitem).
                  WHEN MENU m_edit:LABEL THEN RUN setEditMenuState IN THIS-PROCEDURE (INPUT h_mitem).
                  WHEN MENU m_compile:LABEL THEN RUN setCompileMenuState IN THIS-PROCEDURE (INPUT h_mitem).
                  WHEN MENU m_Tools:LABEL THEN RUN setToolsMenuState IN THIS-PROCEDURE (INPUT h_mitem).
                  WHEN "&Windows" THEN RUN setWindowsMenuState IN THIS-PROCEDURE (INPUT ?).
              END CASE.
          END.
          /* Get the next menu-bar item. */
          ASSIGN h_mitem = h_mitem:NEXT-SIBLING.
      END.
  END.

  /* Test for current widgets and disable/enable based on that. This affects primarily
     the Edit, Layout, and Window menu-items. */
  IF widget-check THEN
  DO:
      /* Process specifc top-level menu-bar items: Edit only for now. */
      ASSIGN h_mitem = AB_Default_MenubarHandle:FIRST-CHILD NO-ERROR.
      DO WHILE VALID-HANDLE(h_mitem):
          /* Assign No-Error skips items that don't have labels. */
          ASSIGN cLabel = ?.
          ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
          IF (cLabel <> ?) THEN
          DO:
              CASE cLabel:
                  WHEN MENU m_edit:LABEL THEN RUN setEditMenuState IN THIS-PROCEDURE (INPUT h_mitem).
              END CASE.
          END.
          /* Get the next menu-bar item. */
          ASSIGN h_mitem = h_mitem:NEXT-SIBLING.
      END.
  END.  /* IF widget-check...*/
  
  RUN setMenusStaticObject.

END PROCEDURE. /* sensitize_main_window */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttribute C-Win 
PROCEDURE setAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pAttribute  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pValue      AS CHARACTER  NO-UNDO.

CASE pAttribute:
    
    WHEN "AB_Default_MenubarHandle" THEN
        ASSIGN AB_Default_MenubarHandle = WIDGET-HANDLE(pValue) NO-ERROR.

END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCompileMenuState C-Win 
PROCEDURE setCompileMenuState :
/*------------------------------------------------------------------------------
  Purpose:     Set the enable/disable state of this menu's options.
  Parameters:  pMenu
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMenu     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE         lContainer AS LOGICAL   NO-UNDO.
  
  ASSIGN lStatic    = IsStaticObject().
  ASSIGN lContainer = IsContainerObject().

  /* Process menu-items. */
  ASSIGN h_mitem = pMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_mitem):
      /* Assign No-Error skips items that don't have labels. */
      ASSIGN cLabel = ?.
      ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
      CASE cLabel:
          WHEN MENU-ITEM m_run:LABEL IN MENU m_compile THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_run:SENSITIVE IN MENU m_compile = h_mitem:SENSITIVE.
              ASSIGN _h_button_bar[6]:SENSITIVE = h_mitem:SENSITIVE. /* run button */
          END.
          WHEN MENU-ITEM m_check:LABEL IN MENU m_compile THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_check:SENSITIVE IN MENU m_compile = h_mitem:SENSITIVE.
          END.
          WHEN MENU-ITEM m_debugger:LABEL IN MENU m_compile THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_debugger:SENSITIVE IN MENU m_compile = h_mitem:SENSITIVE.
          END.
          WHEN MENU-ITEM m_preview:LABEL IN MENU m_compile THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_preview:SENSITIVE IN MENU m_compile = h_mitem:SENSITIVE.
          END.
      END CASE.
      /* Get the next menu-item. */
      h_mitem = h_mitem:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEditMenuState C-Win 
PROCEDURE setEditMenuState :
/*------------------------------------------------------------------------------
  Purpose:     Set the enable/disable state of this menu's options.
  Parameters:  pMenu
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMenu     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic   AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic = IsStaticObject().

  /* Process menu-items. */
  ASSIGN h_mitem = pMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_mitem):
      /* Assign No-Error skips items that don't have labels. */
      ASSIGN cLabel = ?.
      ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
      CASE cLabel:
          WHEN MENU-ITEM m_cut:LABEL IN MENU m_edit THEN
              ASSIGN MENU-ITEM m_cut:SENSITIVE IN MENU m_edit = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_copy:LABEL IN MENU m_edit THEN
              ASSIGN MENU-ITEM m_copy:SENSITIVE IN MENU m_edit = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_paste:LABEL IN MENU m_edit THEN
              ASSIGN MENU-ITEM m_paste:SENSITIVE IN MENU m_edit = h_mitem:SENSITIVE.
          WHEN "Copy to &File...":U THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
          END.
          WHEN "&Insert from File...":U THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
          END.
      END CASE.
      /* Get the next menu-item. */
      h_mitem = h_mitem:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFileMenuState C-Win 
PROCEDURE setFileMenuState :
/*------------------------------------------------------------------------------
  Purpose:     Set the enable/disable state of this menu's options.
  Parameters:  pMenu
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMenu     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic   AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic  = IsStaticObject().

  /* Process menu-items. */
  ASSIGN h_mitem = pMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_mitem):
      /* Assign No-Error skips items that don't have labels. */
      ASSIGN cLabel = ?.
      ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
      CASE cLabel:
          WHEN MENU-ITEM m_close:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_close:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_close_all:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_close_all:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_save:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save_all:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_save_all:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save_as:LABEL IN MENU m_file THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_save_as:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          END.
          WHEN MENU-ITEM m_print:LABEL IN MENU m_file THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN MENU-ITEM m_print:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
              ASSIGN _h_button_bar[4]:SENSITIVE = h_mitem:SENSITIVE. /* print button */
          END.
      END CASE.
      /* Get the next menu-item. */
      h_mitem = h_mitem:NEXT-SIBLING.
  END.

  /* Can we perform an Add to repos? */
  ASSIGN MENU-ITEM m_Add_to_Repos:SENSITIVE IN MENU m_file = CanAddtoRepos().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMenusStaticObject C-Win 
PROCEDURE setMenusStaticObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO:
        RUN setFileMenuState IN THIS-PROCEDURE (INPUT MENU m_file:HANDLE).
        RUN setEditMenuState IN THIS-PROCEDURE (INPUT MENU m_edit:HANDLE).
        RUN setCompileMenuState IN THIS-PROCEDURE (INPUT MENU m_compile:HANDLE).
        RUN setToolsMenuState IN THIS-PROCEDURE (INPUT MENU m_tools:HANDLE).
        RUN setWindowsMenuState IN THIS-PROCEDURE (INPUT ?).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setToolsMenuState C-Win 
PROCEDURE setToolsMenuState :
/*------------------------------------------------------------------------------
  Purpose:     Set the enable/disable state of this menu's options.
  Parameters:  pMenu
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMenu     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic   AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic = IsStaticObject().

  /* Process menu-items. */
  ASSIGN h_mitem = pMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_mitem):
      /* Assign No-Error skips items that don't have labels. */
      ASSIGN cLabel = ?.
      ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
      CASE cLabel:
          WHEN "Procedure &Settings..." THEN
          DO:
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic.
              ASSIGN _h_button_bar[5]:SENSITIVE = h_mitem:SENSITIVE. /* proc button */
          END.
      END CASE.
      /* Get the next menu-item. */
      h_mitem = h_mitem:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setWindowsMenuState C-Win 
PROCEDURE setWindowsMenuState :
/*------------------------------------------------------------------------------
  Purpose:     Set the enable/disable state of this menu's options.
  Parameters:  pMenu
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pMenu     AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic   AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic = IsStaticObject().
  
  ASSIGN pMenu = MENU m_Options:HANDLE
         pMenu = pMenu:NEXT-SIBLING   /* Layout menu  */ 
         pMenu = pMenu:NEXT-SIBLING.  /* Windows menu */
  ASSIGN h_mitem = pMenu:FIRST-CHILD. /* Code Section Edit option */

  /* You cannot perform this option on a dynamic repository object. */
  ASSIGN h_mitem:SENSITIVE = lStatic. /* edit menu item */
  ASSIGN _h_button_bar[7]:SENSITIVE = lStatic. /* edit button */
  ASSIGN _h_button_bar[8]:SENSITIVE = lStatic. /* list button */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CanAddtoRepos C-Win 
FUNCTION CanAddtoRepos RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns Yes if a design window can be added to repository. Otherwise,
            returns No that it cannot. Used to enable and disable the
            Add to Repository AB option.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P     FOR _P.
  DEFINE VARIABLE   lCanAdd     AS LOGICAL    NO-UNDO.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  /* Can only add files that are:
        - Not in repository and that are titled (not untitled).
        - Not include-only files
  */
  ASSIGN lCanAdd = (local_P.design_ryobject = NO AND local_P._SAVE-AS-FILE <> ?) AND
                   (NOT CAN-DO("i":U, local_P._file-type))
                   NO-ERROR.
  ASSIGN NO-ERROR. /* Clear Error status. */
  
  RETURN lCanAdd.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsContainerObject C-Win 
FUNCTION IsContainerObject RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P     FOR _P.
  DEFINE VARIABLE   lContainer  AS LOGICAL    NO-UNDO.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  ASSIGN lContainer = local_P.container_object NO-ERROR.

  RETURN lContainer.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsStaticObject C-Win 
FUNCTION IsStaticObject RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P     FOR _P.
  DEFINE VARIABLE   lStatic     AS LOGICAL    NO-UNDO.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  ASSIGN lStatic = NOT (local_P.logical_object) NO-ERROR.

  RETURN lStatic.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

