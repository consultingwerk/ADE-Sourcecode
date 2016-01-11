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
 CREATE WIDGET-POOL.  

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Shared Variable Definitions ---                                       */
{adeuib/pre_proc.i}
{adeuib/uibhlp.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/bld_tbls.i}     /* Build table list procedure                        */
{adeuib/brwscols.i}   /* Definitions for _BC records                    */


/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{defrescd.i}
/* Global Variable Definitions ---                                      */
/* jep-icf-temp: Should call Repos API and not icf globals directly. */
DEFINE NEW GLOBAL SHARED VARIABLE gshSessionManager     AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gshRepositoryManager  AS HANDLE       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE AB_Default_MenubarHandle  AS HANDLE         NO-UNDO.

/* Property Sheet specific variables */
DEFINE VARIABLE mi_dynproperties          AS HANDLE         NO-UNDO. 
DEFINE VARIABLE DynProperty_Button        AS WIDGET-HANDLE  NO-UNDO.
/* Handle to property sheet persistent library */
DEFINE VARIABLE ghPropertySheet           AS HANDLE     NO-UNDO.
/* Comma delimited list of registered objects (Widget handles) */ 
DEFINE VARIABLE gcRegisteredObjects       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gc_UAttributeName   AS CHARACTER EXTENT 200  NO-UNDO.
DEFINE VARIABLE gh_UAttribute       AS HANDLE    EXTENT 200 NO-UNDO.
DEFINE VARIABLE gc_UAttributeList   AS CHARACTER  NO-UNDO.

/* Temp-table definition for ttAttribute, used in proc propUpdateMaster     */
DEFINE TEMP-TABLE ttStoreAttribute      NO-UNDO
    FIELD tAttributeParent      AS CHARACTER
    FIELD tAttributeParentObj   AS DECIMAL
    FIELD tAttributeLabel       AS CHARACTER
    FIELD tConstantValue        AS LOGICAL      INITIAL NO
    FIELD tCharacterValue       AS CHARACTER
    FIELD tDecimalValue         AS DECIMAL
    FIELD tIntegerValue         AS INTEGER
    FIELD tDateValue            AS DATE
    FIELD tRawValue             AS RAW
    FIELD tLogicalValue         AS LOGICAL
    INDEX idxParent
        tAttributeParent
    INDEX idxObj
        tAttributeParentObj
    .  
DEFINE TEMP-TABLE ttStoreAttribute2 LIKE ttStoreAttribute.


/* Function prototypes */
FUNCTION validate-format RETURNS LOGICAL
  (INPUT pformat AS CHARACTER, 
   INPUT pdataType AS CHARACTER) IN _h_func_lib.

 /* FUNCTION PROTOTYPE */
  FUNCTION db-tbl-name RETURNS CHARACTER
    (INPUT db-tbl AS CHARACTER) IN _h_func_lib.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CanConvertFromToDynamic C-Win 
FUNCTION CanConvertFromToDynamic RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canSetDPS C-Win 
FUNCTION canSetDPS RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeMasterValue C-Win 
FUNCTION getAttributeMasterValue RETURNS CHARACTER
  ( phAttributeBuffer AS HANDLE,
    plisMaster        AS LOG,
    pcResultCode      AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValue C-Win 
FUNCTION getAttributeValue RETURNS CHARACTER
  ( phAttributeBuffer AS HANDLE,
    plisMaster        AS LOG,
    pcResultCode      AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertySheetBuffer C-Win 
FUNCTION getPropertySheetBuffer RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSmartSetting C-Win 
FUNCTION getSmartSetting RETURNS CHARACTER
  ( pcSetting AS CHAR,pcattr AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasCustomSuperProc C-Win 
FUNCTION hasCustomSuperProc RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasDataLogicProc C-Win 
FUNCTION hasDataLogicProc RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasObjectType C-Win 
FUNCTION hasObjectType RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsContainerObject C-Win 
FUNCTION IsContainerObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsSaved C-Win 
FUNCTION IsSaved RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsStaticObject C-Win 
FUNCTION IsStaticObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isValueLogical C-Win 
FUNCTION isValueLogical RETURNS LOGICAL
  ( phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSmartSetting C-Win 
FUNCTION setSmartSetting RETURNS LOGICAL
   ( prRecid AS recid,
     pcAttribute AS CHAR,
     pcValue     AS CHAR )  FORWARD.

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
       MENU-ITEM m_Open_Procedure LABEL "Open Custom Super Proce&dure"
       MENU-ITEM m_Open         LABEL "&Open File..."  ACCELERATOR "F3"
       MENU-ITEM m_Close        LABEL "&Close"         ACCELERATOR "F8"
       MENU-ITEM m_close_all    LABEL "C&lose Windows..." ACCELERATOR "SHIFT-F8"
       RULE
       MENU-ITEM m_Save         LABEL "&Save"          ACCELERATOR "F6"
       MENU-ITEM m_Save_As      LABEL "Save &As..."    ACCELERATOR "SHIFT-F6"
       MENU-ITEM m_Save_All     LABEL "Sa&ve All"     
       RULE
       MENU-ITEM m_Save_As_Object LABEL "Save As &Object..."
       MENU-ITEM m_Reg_in_Repos LABEL "&Register in Repository..."
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
       MENU-ITEM m_Generate_Objects LABEL "Object &Generator".

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
         HEIGHT             = 2.57
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
ON CHOOSE OF MENU-ITEM m_Generate_Objects /* Object Generator */
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


&Scoped-define SELF-NAME m_Open_Procedure
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open_Procedure C-Win
ON CHOOSE OF MENU-ITEM m_Open_Procedure /* Open Custom Super Procedure */
DO:
  DEFINE VARIABLE cFileName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullFilename  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDesignManager AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpenObject    AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER local_U FOR _U.
  DEFINE BUFFER local_C FOR _C.

  FIND local_U WHERE local_U._HANDLE = _h_win NO-ERROR.
  IF AVAILABLE local_U THEN
     FIND local_C WHERE RECID(local_C)  = local_U._x-recid NO-ERROR. 
  IF INDEX(SELF:LABEL,"Data") > 0 THEN
     ASSIGN cFileName = local_C._DATA-LOGIC-PROC.
  ELSE
     ASSIGN cFileName = local_C._CUSTOM-SUPER-PROC.  

  ASSIGN cFullFileName = SEARCH(cFileName) NO-ERROR.
  
  IF cFullFilename <> ? THEN
  DO:
     hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
     IF VALID-HANDLE(hDesignManager) THEN
        lOpenObject  = DYNAMIC-FUNCTION("openRyObjectAB" IN hDesignManager, INPUT cFullFilename).
     RUN setstatus IN _h_UIB (?, "Opening file...") .
     RUN adeuib/_open-w.p  (TRIM(cFullFilename), "", "WINDOW":U) .
     RUN setstatus IN _h_UIB ("":U, "":U) .
  END.



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


&Scoped-define SELF-NAME m_Reg_in_Repos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Reg_in_Repos C-Win
ON CHOOSE OF MENU-ITEM m_Reg_in_Repos /* Register in Repository... */
DO:
    RUN choose_reg_in_repos IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME m_Save_As_Object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_As_Object C-Win
ON CHOOSE OF MENU-ITEM m_Save_As_Object /* Save As Object... */
DO:
  IF isStaticObject() THEN
     RUN choose_file_save_as_dynamic IN _h_UIB.
  ELSE IF CanConvertFromToDynamic()  THEN
     RUN choose_file_save_as_static IN _h_UIB.
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
            ASSIGN
              LABEL = "&Container Builder"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "rycntpshtw":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "&Toolbar and Menu Designer"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN runToolbarDesigner IN THIS-PROCEDURE.
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "Rep&ository Maintenance"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "rycsotreew":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "S&martDataField Maintenance"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "rysdfmaintw":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              SUBTYPE = "RULE" PARENT = h_parent.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "Tree &Node Control"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "gsmndobjcw":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "Dynamic &TreeView Builder"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "rytreemntw":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              SUBTYPE = "RULE" PARENT = h_parent.
        CREATE MENU-ITEM h_menu_item
            ASSIGN
              LABEL = "Set Site Number"
              PARENT = h_parent
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "gsmsisetnw":U , INPUT YES , INPUT YES ).
            END TRIGGERS.
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
        ASSIGN
          SUBTYPE = "RULE"                 PARENT = h_parent.
    CREATE MENU-ITEM h_menu_item
        ASSIGN
          LABEL = "&Administration"
          PARENT = h_parent
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "afallmencw":U , INPUT YES , INPUT YES ).
        END TRIGGERS.
    CREATE MENU-ITEM h_menu_item
        ASSIGN
          LABEL = "De&velopment"
          PARENT = h_parent
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN ry/prc/rycsolnchp.p (INPUT "rywizmencw":U , INPUT YES , INPUT YES ).
        END TRIGGERS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPropertyButton C-Win 
PROCEDURE addPropertyButton :
/*------------------------------------------------------------------------------
  Purpose:    Adds the Dynamics Properties window 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piBarCount AS INTEGER    NO-UNDO.

DEFINE VARIABLE ldummy              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.

CREATE BUTTON DynProperty_Button
        ASSIGN FRAME        = _h_button_bar[1]:FRAME
               X            = _h_button_bar[piBarCount]:X + 25
               Y            = _h_button_bar[1]:Y
               WIDTH-P      = _h_button_bar[1]:WIDTH-P
               HEIGHT-P     = _h_button_bar[1]:HEIGHT-P
               PRIVATE-DATA = "DynProperties":U
               BGCOLOR      = _h_button_bar[1]:BGCOLOR
               FONT         = _h_button_bar[1]:FONT
               TOOLTIP      = "Dynamic Properties"
               NO-FOCUS     = YES
               FLAT-BUTTON  = YES
               HIDDEN       = YES
               SENSITIVE    = FALSE
        TRIGGERS:
            ON CHOOSE PERSISTENT RUN choose_dynproperties IN THIS-PROCEDURE.
        END TRIGGERS.

      ldummy = DynProperty_Button:LOAD-IMAGE-UP("ry/img/properties.gif":U) NO-ERROR.
      /* Move the remote button over */
      DO i = 11 to piBarCount:
          /* Make adjustments for buttons that have the rectangles between them. */
          ASSIGN _h_button_bar[i]:X = _h_button_bar[i]:X + 30.
      END.  /* DO i = 1 to bar_count */
      ASSIGN DynProperty_Button:HIDDEN = FALSE
             NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPropertyMenu C-Win 
PROCEDURE addPropertyMenu :
/*------------------------------------------------------------------------------
  Purpose:     Adds the Property Menu items
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CREATE MENU-ITEM mi_dynproperties 
   ASSIGN LABEL = "&Dynamic Properties"
         PARENT = _h_WindowMenu
   TRIGGERS: 
         ON CHOOSE PERSISTENT RUN choose_dynproperties IN THIS-PROCEDURE. 
   END TRIGGERS. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSDOFieldListsByTable C-Win 
PROCEDURE buildSDOFieldListsByTable :
/*------------------------------------------------------------------------------
  Purpose:     Several SDO attributes are fields broken by Table.  This procedure 
               contructs them.  (In particular... cAssignList, cUpdateColumnsByTable
               and cDataColumnsByTable
  Parameters:
     INPUT  pURecid              = Recid of _U for query of SDO
            pcTables             - The list of tables participating in the SDO
     OUTPUT pcAssignList         - List of fields that have different names from
                                   their DB field counterparts
            pcUpdatableColumnsByTable
            pcDataColumnsByTable  
  Notes: The 3 output lists are comma delimited but each table group is separated
         with a semi-colon (;) 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pURecid                     AS RECID          NO-UNDO.
  DEFINE INPUT  PARAMETER pcTables                    AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAssignList                AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUpdatableColumnsByTable   AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDataColumnsByTable        AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE i                                   AS INTEGER        NO-UNDO.
  DEFINE VARIABLE lCalcColumn                         AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE lUpdtCalcColumn                     AS LOGICAL        NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(pcTables):

    /* pcAssignList */
    pcAssignList = pcAssignList + ";":U.
    FOR EACH _BC WHERE _BC._x-recid = pURecid 
                   AND _BC._DBNAME <> "_<CALC>":U
                   AND _BC._TABLE = ENTRY(i,pcTables)
                   AND _BC._DISP-NAME <> _BC._NAME 
                   AND _BC._DISP-NAME <> ?
                   AND _BC._DISP-NAME <> "":U
                   AND _BC._NAME <> "":U
                   AND _BC._NAME <> ?
                 BY _BC._SEQUENCE:
      ASSIGN pcAssignList = pcAssignList + _BC._DISP-NAME + ",":U + 
                                           _BC._NAME + ",":U.
    END. /* FOR EACH _BC */
    pcAssignList = TRIM(pcAssignList, ",":U).

      
    /* pcDataColumnsByTable and pcUpdatableColumnsByTable */
    ASSIGN pcDataColumnsByTable      = pcDataColumnsByTable + ";":U
           pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + ";":U.
    FOR EACH _BC WHERE _BC._x-recid = pURecid 
                 AND _BC._DBNAME <> "_<CALC>":U
                 AND _BC._TABLE = ENTRY(i,pcTables)
                 AND _BC._DISP-NAME <> ?
                 AND _BC._DISP-NAME <> "":U
                 BY _BC._SEQUENCE:
      ASSIGN pcDataColumnsByTable = pcDataColumnsByTable + _BC._DISP-NAME + ",":U.
      IF _BC._ENABLED THEN
        ASSIGN pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + 
                                           _BC._DISP-NAME + ",":U.
    END. /* FOR EACH _BC */
    ASSIGN pcDataColumnsByTable      = TRIM(pcDataColumnsByTable,",":U)
           pcUpdatableColumnsByTable = TRIM(pcUpdatableColumnsByTable,",":U).
  END.  /* Do i for all of the tables */
  /* Remove 1st ";" */
  ASSIGN pcAssignList              = SUBSTRING(pcAssignList, 2, -1, "CHARACTER":U)
         pcDataColumnsByTable      = SUBSTRING(pcDataColumnsByTable, 2, -1, "CHARACTER":U)
         pcUpdatableColumnsByTable = SUBSTRING(pcUpdatableColumnsByTable, 2, -1, "CHARACTER":U).

  /* Now that all of the table columns are done, add any calculated fields to
     pcDataColumnsByTable and pcUpdatableColumnsByTable */
  ASSIGN lCalcColumn              = NO
         lUpdtCalcColumn          = NO.
  FOR EACH _BC WHERE _BC._x-recid = pURecid 
               AND _BC._DBNAME = "_<CALC>":U
               AND _BC._DISP-NAME <> ?
               AND _BC._DISP-NAME <> "":U
               BY _BC._SEQUENCE:
    ASSIGN pcDataColumnsByTable = pcDataColumnsByTable + 
                                    (IF NOT lCalcColumn THEN ";":U ELSE ",") + 
                                        _BC._DISP-NAME
           lCalcColumn          = YES.      /* We have one */
    IF _BC._ENABLED THEN
      ASSIGN pcUpdatableColumnsByTable = pcUpdatableColumnsByTable + 
                                           (IF NOT lUpdtCalcColumn THEN ";":U ELSE ",") +
                                           _BC._DISP-NAME + ",":U
             lUpdtCalcColumn           = YES.  /* We have one */
  END. /* FOR EACH _BC */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildSDOSimpleLists C-Win 
PROCEDURE BuildSDOSimpleLists :
/*------------------------------------------------------------------------------
  Purpose:    To construct simple list of SDO informationthat map directly to 
              _BC records.  These lists are: cDataColumns, cUpdatableColumns, 
              cQBFieldDataTypes, cQBFieldDBNames, cQBFieldHelp, cQBFieldWidths 
              and cQBInhVals
  Parameters:
     INPUT  pURecid              - Record id of _U of SDO query
     OUTPUT pcDataColumns        - Names (displayNames) of the columns of the SDO
     OUTPUT pcUpdatableColumns   - Name of columns that are updatable
     OUTPUT pcInstanceColumns    - Columns whose attributes are stored at the instnace level
     OUTPUT pcQBFieldDataTypes   - Data-types of the columns
     OUTPUT pcQBFieldDBNames     - DBNAMEs of the columns
     OUTPUT pcQBFieldFormats,    - Formats of the columns
     OUTPUT pcQBFieldHelp        - Help strings of the columns
     OUTPUT pcQBFieldLabels      - Labels of the columns
     OUTPUT pcQBFieldWidths      - Integer widths of the fields
     OUTPUT pcQBInhVals          - List of Yes/No values indicating if dictionary
                                   validation is to be used
  Notes:  pcQBFieldFormats, pcQBFieldHelp and pcQBFieldLabels are delimited by CHR(5), 
          the rest are by comma (,)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pURecid                  AS RECID            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDataColumns            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcUpdatableColumns       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcInstanceColumns        AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDataTypes       AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldDBNames         AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldFormats         AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldHelp            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldLabels          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBFieldWidths          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcQBInhVals              AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE i                                AS INTEGER          NO-UNDO.
    DEFINE VARIABLE lFormatsBlank                    AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lHelpBlank                       AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lLabelsBlank                     AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lValidateBlank                   AS LOGICAL          NO-UNDO.


    FOR EACH _BC WHERE _BC._x-recid = pURecid
             AND _BC._DISP-NAME <> ?
             AND _BC._DISP-NAME <> "":U
             BY _BC._SEQUENCE:
      ASSIGN pcDataColumns      = pcDataColumns      + _BC._DISP-NAME              + ",":U
             pcQBFieldDataTypes = pcQBFieldDataTypes + _BC._DATA-TYPE              + ",":U
             pcQBFieldDBNames   = pcQBFieldDBNames   + _BC._DBNAME                 + ",":U
             pcQBFieldFormats   = pcQBFieldFormats   + (IF _BC._FORMAT = _BC._DEF-FORMAT
                                                        THEN "?":U ELSE _BC._FORMAT) + CHR(5)
             pcQBFieldHelp      = pcQBFieldHelp      + _BC._HELP                   + CHR(5)
             pcQBFieldLabels    = pcQBFieldLabels    + (IF _BC._LABEL = _BC._DEF-LABEL
                                                        THEN "?":U ELSE _BC._LABEL)  + CHR(5)
             pcQBFieldWidths    = pcQBFieldWidths    + STRING(INTEGER(_BC._WIDTH)) + ",":U
             pcQBInhVals        = pcQBInhVals        + IF _BC._INHERIT-VALIDATION 
                                                       THEN "Yes,":U ELSE "No,":U.

      IF _BC._ENABLED THEN
        ASSIGN pcUpdatableColumns = pcUpdatableColumns + _BC._DISP-NAME + ",":U.
      IF _BC._INSTANCE-LEVEL THEN
        ASSIGN pcInstanceColumns  = pcInstanceColumns  + _BC._DISP-NAME + ",":U.
    END. /* FOR EACH _BC */

    /* Trim trailing delimiter */
    ASSIGN pcDataColumns      = RIGHT-TRIM(pcDataColumns,      ",":U)
           pcUpdatableColumns = RIGHT-TRIM(pcUpdatableColumns, ",":U)
           pcQBFieldDataTypes = RIGHT-TRIM(pcQBFieldDataTypes, ",":U)
           pcQBFieldDBNames   = RIGHT-TRIM(pcQBFieldDBNames,   ",":U)
           pcQBFieldFormats   = RIGHT-TRIM(pcQBFieldFormats,   CHR(5))
           pcQBFieldLabels    = RIGHT-TRIM(pcQBFieldLabels,    CHR(5))
           pcQBFieldWidths    = RIGHT-TRIM(pcQBFieldWidths,    ",":U)
           pcQBInhVals        = RIGHT-TRIM(pcQBInhVals,        ",":U)
           pcInstanceColumns  = RIGHT-TRIM(pcInstanceColumns,  ",":U).
    /* Note: it is possible if the last few help strings are blank, that you could TRIM too
       many CHR(5)'s from its string.  It is better to just remove the one that we know is
       there. We will do this after we determine that we can't blank out the entire string */

    /* We want to blank out attributes that have all default values so as to not write
       the attribute to the repository                                                    */
    ASSIGN lFormatsBlank  = YES
           lHelpBlank     = YES
           lLabelsBlank   = YES
           lValidateBlank = YES.
    DO i = 1 TO NUM-ENTRIES(pcQBInhVals):
      IF ENTRY(i,pcQBFieldFormats,CHR(5)) NE "?":U    THEN lFormatsBlank  = NO.
      IF ENTRY(i,pcQBFieldLabels,CHR(5)) NE "?":U     THEN lLabelsBlank   = NO.
      IF ENTRY(i,pcQBInhVals) NE "NO":U               THEN lValidateBlank = NO.
      IF ENTRY(i,pcQBFieldHelp,CHR(5)) NE "":U        THEN lHelpBlank     = NO.
    END.

    IF lFormatsBlank  THEN pcQBFieldFormats = "":U.
    IF lLabelsBlank   THEN pcQBFieldLabels  = "":U.
    IF lValidateBlank THEN pcQBInhVals      = "":U.
    IF lHelpBlank     THEN pcQBFieldHelp    = "":U.
    ELSE  /* Now trim the trailing chr(5) */
      pcQBFieldHelp = SUBSTRING(pcQBFieldHelp, 1,
                                LENGTH(pcQBFieldHelp,"CHARACTER") - 1, "CHARACTER").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_dynProperties C-Win 
PROCEDURE choose_dynProperties :
/*------------------------------------------------------------------------------
  Purpose:     launches the dynamic property sheet
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* Load the Property Sheet library */
IF NOT VALID-HANDLE(ghPropertySheet) THEN
   RUN Load_propertySheet NO-ERROR.

RUN launchPropertyWindow IN ghPropertySheet. 
RUN Display_PropSheet IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_reg_in_repos C-Win 
PROCEDURE choose_reg_in_repos :
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
        ASSIGN MENU-ITEM m_Reg_in_Repos:SENSITIVE IN MENU m_file = CanAddtoRepos().
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectBrowseColumns C-Win 
PROCEDURE collectBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:     To make a single pass through the _BC records of a browse
               and retrieve all attribute information on them. 
  Parameters:  INPUT bRecid_U - The recid of the _U of the browse
               OUTPUT pcfldList        - comma delimited list of browse column name
                      pcEnabledFields - comma delimited list of enabled fields
                      pcColBGCs       - CHR(5) delimited list of Background colors
                      pcColFGCs       - CHR(5) delimited list of Foreground colors
                      pcColFonts      - CHR(5) delimited list of Fonts
                      pcColFormats    - CHR(5) delimited list of Formats
                      pcLblBGCs       - CHR(5) delimited list of label BGCs
                      pcLblFGCs       - CHR(5) delimited list of label FGCs
                      pcLblFonts      - CHR(5) delimited list of label Fonts
                      pcLabels        - CHR(5) delimited list of labels
                      pcWidths        - CHR(5) delimited list of widths (integer 
                                       values only)
  Notes:  All CHR(5) delimited list must have the same number of entries as the
          pcfldList.
          IF all values of a CHR(5) delimited list is the default value (usually
          ? or blank, then the entire list is blank   
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER bRecid_U           AS RECID      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcfldList          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEnabledFields    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcColBGCs          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcColFGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcColFonts          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcColFormats        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLblBGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLblFGCs           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLblFonts          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLabels            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcWidths            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         NumCols            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColBGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFonts          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iColFormats        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblBGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblFGCs           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLblFonts          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         iLabels            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE         hcol-hdl           AS HANDLE     NO-UNDO.

  DEFINE BUFFER brws_U FOR _U.

  /* First resequence the columns as the user may have shuffled them with the mouse */
  FIND brws_U WHERE RECID(brws_U) = bRecid_U.
  ASSIGN iLoop    = 1
         hcol-hdl = brws_U._HANDLE:FIRST-COLUMN WHEN VALID-HANDLE(brws_U._HANDLE).
  FOR EACH _BC WHERE _BC._x-recid = bRecid_U:
     _BC._SEQUENCE = _BC._SEQUENCE * -1.
  END.
  DO WHILE VALID-HANDLE(hcol-hdl):
    FIND _BC WHERE _BC._x-recid    = bRecid_U AND
                   _BC._COL-HANDLE = hcol-hdl NO-ERROR.
    IF AVAILABLE _BC THEN
      ASSIGN _BC._SEQ = iLoop
             iLoop    = iLoop + 1.
    hcol-hdl  = hcol-hdl:NEXT-COLUMN.
  END.  /* DO WHILE VALID-HANDLE */

  FOR EACH _BC WHERE _BC._x-recid = bRecid_U:
    ASSIGN pcfldList = pcfldList + "," + _BC._NAME
           pcEnabledFields = pcEnabledFields + (IF _BC._ENABLED THEN ",":U + _BC._NAME ELSE "":U)
           pcColBGCs       = pcColBGCs    + CHR(5) + IF _BC._BGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._BGCOLOR)
           pcColFGCs       = pcColFGCs    + CHR(5) + IF _BC._FGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._FGCOLOR)
           pcColFonts      = pcColFonts   + CHR(5) + IF _BC._FONT = ? THEN "?":U
                                                   ELSE STRING(_BC._FONT)
           pcColFormats    = pcColFormats + CHR(5) + IF _BC._FORMAT = _BC._DEF-FORMAT THEN "?":U
                                                   ELSE _BC._FORMAT
           pcLblBGCs       = pcLblBGCs    + CHR(5) + IF _BC._LABEL-BGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-BGCOLOR)
           pcLblFGCs       = pcLblFGCs    + CHR(5) + IF _BC._LABEL-FGCOLOR = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-FGCOLOR)
           pcLblFonts      = pcLblFonts   + CHR(5) + IF _BC._LABEL-FONT = ? THEN "?":U
                                                   ELSE STRING(_BC._LABEL-FONT)
           pcLabels        = pcLabels     + CHR(5) + IF _BC._LABEL = _BC._DEF-LABEL THEN "?":U
                                                   ELSE _BC._LABEL
           pcWidths        = pcWidths     + CHR(5) + STRING(INTEGER(_BC._WIDTH))

           NumCols        = NumCols     + 1
           iColBGCs       = iColBGCs    + IF _BC._BGCOLOR = ?              THEN 0 ELSE 1
           iColFGCs       = iColFGCs    + IF _BC._FGCOLOR = ?              THEN 0 ELSE 1
           iColFonts      = iColFonts   + IF _BC._FONT = ?                 THEN 0 ELSE 1
           iColFormats    = iColFormats + IF _BC._FORMAT = _BC._DEF-FORMAT THEN 0 ELSE 1
           iLblBGCs       = iLblBGCs    + IF _BC._LABEL-BGCOLOR = ?        THEN 0 ELSE 1
           iLblFGCs       = iLblFGCs    + IF _BC._LABEL-FGCOLOR = ?        THEN 0 ELSE 1
           iLblFonts      = iLblFonts   + IF _BC._LABEL-FONT = ?           THEN 0 ELSE 1
           iLabels        = iLabels     + IF _BC._LABEL = _BC._DEF-LABEL   THEN 0 ELSE 1
           .
  END.   /* Have looped through the fields and collected all of the info */

  /* Now TRIM and blank out all output parameters that are all defaults */

  ASSIGN pcfldList        = LEFT-TRIM(pcfldList, ",":U)
         pcEnabledFields = LEFT-TRIM(pcEnabledFields, ",":U)
         pcColBGCs       = IF iColBGCs    GT 0 THEN SUBSTRING(pcColBGCs,2,-1,"CHARACTER")    ELSE "":U
         pcColFGCs       = IF iColFGCs    GT 0 THEN SUBSTRING(pcColFGCs,2,-1,"CHARACTER")    ELSE "":U
         pcColFonts      = IF iColFonts   GT 0 THEN SUBSTRING(pcColFonts,2,-1,"CHARACTER")   ELSE "":U
         pcColFormats    = IF iColFormats GT 0 THEN SUBSTRING(pcColFormats,2,-1,"CHARACTER") ELSE "":U
         pcLblBGCs       = IF iLblBGCs    GT 0 THEN SUBSTRING(pcLblBGCs,2,-1,"CHARACTER")    ELSE "":U
         pcLblFGCs       = IF iLblFGCs    GT 0 THEN SUBSTRING(pcLblFGCs,2,-1,"CHARACTER")    ELSE "":U
         pcLblFonts      = IF iLblFonts   GT 0 THEN SUBSTRING(pcLblFonts,2,-1,"CHARACTER")   ELSE "":U
         pcLabels        = IF iLabels     GT 0 THEN SUBSTRING(pcLabels,2,-1,"CHARACTER")     ELSE "":U
         pcWidths        = SUBSTRING(pcWidths,2,-1,"CHARACTER").
         
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ConstructTableList C-Win 
PROCEDURE ConstructTableList :
/*------------------------------------------------------------------------------
  Purpose:    To create a list of SDO tables
  Parameters: 
     INPUT  pURecid       - recid of _U of SDO window
     INPUT  pcQueryTables - List of tables in query (includes external tables)
     OUTPUT pcTables      - List that gets created
              
  Notes: This code was stolen from put_tbllist_internal in adeuib/_genproc.i     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pPRecid         AS RECID                   NO-UNDO.
    DEFINE INPUT  PARAMETER pURecid         AS RECID                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcQueryTables   AS CHARACTER               NO-UNDO.
    DEFINE OUTPUT PARAMETER pcTables        AS CHARACTER               NO-UNDO.
    
    DEFINE VARIABLE cnt                     AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE i                       AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE TblName                 AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE tbls-in-q               AS CHARACTER               NO-UNDO.

    /* Handle freeform query case if it exists */
    FIND _TRG WHERE _TRG._wRECID = pURecid AND
                    _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
      ASSIGN tbls-in-q = pcQueryTables.

      RUN build_table_list (INPUT _TRG._tCODE, INPUT ",":U, 
                            INPUT NO, /* If this flag is set to yes, temp-tables
                                         do not work. */
                            INPUT-OUTPUT tbls-in-q).
    END.
    ELSE tbls-in-q = pcQueryTables.
    
    /* Build the tblList excluding external tables */
    cnt = NUM-ENTRIES(tbls-in-q).
    DO i = 1 TO cnt:
      TblName = ENTRY (1, TRIM (ENTRY (i,tbls-in-q)), " ").
      IF NOT CAN-DO (_P._xTblList, TblName) THEN DO:
        IF NUM-ENTRIES(TblName,".":U) > 1 THEN
          TblName = db-tbl-name(TblName).
        IF NOT CAN-DO(pcTables, TblName) THEN
          pcTables = pcTables + ",":U + TblName.
      END.  /* If not in the external table list */
    END.  /* DO i 1 to cnt */
  
    pcTables = LEFT-TRIM(pcTables, ",":U).
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display_PropSheet C-Win 
PROCEDURE display_PropSheet :
/*------------------------------------------------------------------------------
  Purpose:     Called when the property sheet window has been launched and the 
               user selects a widget from the appBuilder.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P     FOR _P.
  DEFINE BUFFER     local_U     FOR _U.
  
  
  DEFINE VARIABLE cClassName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectHandle    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClass           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPropWindow      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lExtendsDynView  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExtendsDynOther AS LOGICAL    NO-UNDO.


  /* If property sheet window is closed or prop library isn't valid, return */
  IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.
  hPropWindow = DYNAMIC-FUNC("getPropSheet":U IN ghPropertySheet).
  IF NOT VALID-HANDLE(hPropWindow) THEN RETURN.

  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.

  /* IF NOT a registered Object (smartobject_obj= 0) then return */
  IF NOT AVAILABLE local_P  THEN
     RETURN.
  /* Determine whether the object type extends a dynamic viewer */
  ASSIGN
  lExtendsDynView  = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, local_P.object_type_code,"DynView":U)
  lExtendsDynOther = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, local_P.object_type_code,"DynSDO":U)
                     OR DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, local_P.object_type_code,"DynBrow":U).

  FIND local_U WHERE local_U._HANDLE = _h_cur_widg NO-ERROR.
  IF NOT AVAILABLE local_U  THEN
     FIND local_U WHERE local_U._HANDLE = _h_win NO-ERROR.
  /* Find the _U record of the window */
  IF AVAILABLE local_U THEN
     cResultCode   =  IF local_U._LAYOUT-NAME = "Master Layout":U
                      THEN ""
                      ELSE local_U._LAYOUT-NAME.
  
  /* First check the window handle and verify whether this window has yet been registered.
     If not, register it now in the Property Sheet Library. */
  ASSIGN cObjectHandle = STRING(local_P._WINDOW-HANDLE).
  
  /* If the object is an existing object in the repository, register the object and it's instances */       
  IF LOOKUP(cObjectHandle,gcRegisteredObjects) = 0 AND local_P.smartobject_obj > 0  THEN 
  DO:
     RUN Prop_register IN THIS-PROCEDURE (INPUT STRING(_h_win), INPUT cObjectHandle).
     /* Now register all new widgets on this window that have been added to the DynView since it was opened */
     IF lExtendsDynView THEN
     DO:
        ASSIGN hWidget = local_P._WINDOW-HANDLE:FIRST-CHILD /* get frame */
               hWidget = hWidget:CURRENT-ITERATION  /* get field group */.
               hWidget = hWidget:FIRST-CHILD        /* get first widget */
               NO-ERROR. 
        DO WHILE VALID-HANDLE(hWidget):
           IF (NOT hWidget:NAME BEGINS "_LBL-":U OR hWidget:TYPE NE "TEXT":U )
            AND LOOKUP(STRING(hWidget),gcRegisteredObjects) = 0 THEN
               RUN prop_registerWidget IN THIS-PROCEDURE (STRING(_h_win),STRING(hWidget) ).
           hWidget = hWidget:NEXT-SIBLING.
        END.
     END.
     IF AVAILABLE local_U THEN
        cObjectList = STRING( local_U._HANDLE).
     ELSE
        cObjectList = cObjectHandle.

  END.
  ELSE IF AVAILABLE local_U AND lExtendsDynOther THEN /* If object is a DynBrowse or a DynSDO, register object  */
  DO:
     IF LOOKUP(cObjectHandle,gcRegisteredObjects) = 0 THEN 
        RUN Prop_registerWidget  IN THIS-PROCEDURE (INPUT STRING(_h_win), INPUT cObjectHandle).
     ASSIGN cObjectList = cObjectHandle.
  END.
  ELSE IF AVAILABLE local_U AND lExtendsDynView THEN /* If object is a dynamic viewer, and a new widget is added, */                                                     
  DO:                                                /* the widget or viewer can be registered  */
     IF LOOKUP(cObjectHandle,gcRegisteredObjects) = 0 
          OR LOOKUP(string(local_U._HANDLE),gcRegisteredObjects) = 0  THEN 
     DO:
       cObjectHandle = STRING(local_U._WINDOW-HANDLE).
       RUN Prop_registerWidget  IN THIS-PROCEDURE (INPUT STRING(_h_win), INPUT cObjectHandle). /* register the window */
       ASSIGN cObjectList = cObjectHandle.
       ASSIGN hWidget = local_P._WINDOW-HANDLE:FIRST-CHILD /* get frame */
              hWidget = hWidget:CURRENT-ITERATION  /* get field group */.
              hWidget = hWidget:FIRST-CHILD        /* get first widget */
              NO-ERROR. 
       DO WHILE VALID-HANDLE(hWidget):        /* Register all new widgets added - for new or existing viewers*/
           IF (NOT hWidget:NAME BEGINS "_LBL-":U OR hWidget:TYPE NE "TEXT":U )
               AND LOOKUP(STRING(hWidget),gcRegisteredObjects) = 0 THEN
                  RUN prop_registerWidget IN THIS-PROCEDURE (STRING(_h_win),STRING(hWidget) ).
              hWidget = hWidget:NEXT-SIBLING.
       END.
     END.
     IF local_U._TYPE ="FRAME":U  THEN
        cObjectHandle = STRING(local_U._WINDOW-HANDLE).
     ELSE
        cObjectHandle = STRING(local_U._HANDLE).
     ASSIGN cObjectList = cObjectHandle.
  END.
  /* IF multiple objects are selected, there is no current widget, and no _U record available */
  ELSE IF lExtendsDynView AND NOT AVAILABLE local_U THEN
  DO: 
    FOR EACH local_U WHERE local_U._WINDOW-HANDLE = local_P._WINDOW-HANDLE
                       AND local_U._SELECTEDib:
       IF local_U._TYPE ="FRAME":U  THEN
          cObjectHandle = STRING(local_U._WINDOW-HANDLE).
       ELSE
          cObjectHandle = STRING(local_U._HANDLE).

       cObjectList = cObjectList + (IF cObjectList = "" THEN "" ELSE CHR(3)) + cObjectHandle.
    END.
  END.
  ELSE  /* For any other registered object, use the window handle as the registered object */
     cObjectList = string(local_P._WINDOW-HANDLE).

  IF NUM-ENTRIES(cObjectList,CHR(3)) = 1 AND LOOKUP(cObjectList,gcRegisteredObjects) = 0 THEN
     ASSIGN cObjectList = string(_h_win).

  /* Synchronize AppBuiulder propeties with dynamic property sheet */
  RUN Prop_SynchProperties IN THIS-PROCEDURE.

  IF VALID-HANDLE(ghPropertySheet) AND cObjectList > "" THEN
     RUN displayProperties IN ghPropertySheet
          (THIS-PROCEDURE,  /* Calling procedure */
           STRING(_h_win),  /* Container Handle */
           cObjectList,     /* List of Object Handles selected */
           cResultCode,     /* Force current result code */
           YES,             /* Disable result combo-box */
           0).              /* Page View - both attributes and events page */



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load_PropertySheet C-Win 
PROCEDURE load_PropertySheet :
/*------------------------------------------------------------------------------
  Purpose:    Loads the Property Sheet persistent window 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure  AS HANDLE     NO-UNDO.

  /* IF the Property sheet library is not running persistently, run it now */
  IF NOT VALID-HANDLE(ghPropertySheet) THEN
  DO:
     hProcedure = SESSION:FIRST-PROCEDURE.
     DO WHILE VALID-HANDLE(hProcedure) AND hProcedure:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
       hProcedure = hProcedure:NEXT-SIBLING.
     END.
     IF NOT VALID-HANDLE(hProcedure) THEN
       RUN ry/prc/ryvobplipp.p PERSISTENT SET ghPropertySheet NO-ERROR.
     ELSE 
       ASSIGN ghPropertySheet = hProcedure.
     /* Subscribe to events */
     SUBSCRIBE TO 'PropertyChangedObject':U    IN ghPropertySheet.
     SUBSCRIBE TO 'PropertyChangedResult':U    IN ghPropertySheet.
     SUBSCRIBE TO 'PropertyChangedAttribute':U IN ghPropertySheet.
     SUBSCRIBE TO 'PropertyChangedEvent':U     IN ghPropertySheet.
     SUBSCRIBE TO 'PropertyChangedClass':U     IN ghPropertySheet.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PropDeleteWidget C-Win 
PROCEDURE PropDeleteWidget :
/*------------------------------------------------------------------------------
  Purpose:   Unregisters widgets in the property sheet.
  Parameters: phWidget   Handle of widget being deleted.
  Notes:      Called from deletion of widget adeuib/delete_u.i
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phWidget AS HANDLE     NO-UNDO.

IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.

RUN deleteObject IN ghPropertySheet
             (INPUT THIS-PROCEDURE,
              INPUT STRING(_h_win),
              STRING(phWidget)
             )  NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PropertyChangedAttribute C-Win 
PROCEDURE PropertyChangedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     Published from proeprty sheet when attribute value is changed
  Parameters:  phHandle     Handle of procedure that object belongs to
               pcContainer  
               pcObject     
               pcResultCode 
               pcAttribute  
               pcValue      
               pcDataType   
               plOverride   
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phHandle      AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainer   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObject      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttribute   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValue       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOverride    AS LOGICAL    NO-UNDO.


DEFINE VARIABLE hWindow    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE dValue     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iFont      AS INTEGER    NO-UNDO.
DEFINE VARIABLE lValue     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iPos       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cListItems AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hPropLib   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttribute AS HANDLE     NO-UNDO.
DEFINE VARIABLE cClassName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmp       AS CHARACTER  NO-UNDO.

/* get the Current window and widget */
ASSIGN hWindow = WIDGET-HANDLE(pcContainer)
       hWidget = WIDGET-HANDLE(pcObject)
       NO-ERROR.

/* Return if object is not created from this procedure */
IF phHandle <> THIS-PROCEDURE THEN RETURN.

DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER f_L FOR _L.
DEFINE BUFFER f_F FOR _F.
DEFINE BUFFER f_C FOR _C.
DEFINE BUFFER f_P FOR _P.


FIND f_U WHERE f_U._WINDOW-HANDLE = hWindow AND f_U._HANDLE = hWidget NO-ERROR.
FIND f_L WHERE RECID(f_L) = f_U._lo-recid NO-ERROR.
FIND f_F WHERE RECID(f_F) = f_U._x-recid NO-ERROR.
FIND f_C WHERE RECID(f_C) = f_U._x-recid NO-ERROR.
FIND f_P WHERE  f_P._WINDOW-HANDLE = f_U._WINDOW-HANDLE NO-ERROR.
cClassName = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT f_P._TYPE).
IF cClassName = "" THEN
   cClassName = f_P._TYPE.
IF cClassname = "DynBrow":U THEN
DO:
   FIND f_U WHERE f_U._WINDOW-HANDLE =  hWindow
              AND f_U._TYPE          = "BROWSE" NO-ERROR. 
   FIND f_C WHERE RECID(f_C)  = f_U._x-recid NO-ERROR.
   FIND f_L WHERE RECID(f_L)  = f_U._lo-recid NO-ERROR.
END.


/* Manage layout attributes which require refreshing*/
IF CAN-DO("ROW,COLUMN,HEIGHT-CHARS,WIDTH-CHARS":U,pcAttribute) THEN
DO:
   ASSIGN dValue = DECIMAL(pcValue) NO-ERROR.
   IF dValue > 0 THEN
   DO:
     CASE pcAttribute:
        WHEN "ROW":U THEN
          ASSIGN f_U._HANDLE:ROW = dValue
                 f_L._ROW        = dValue NO-ERROR.
        WHEN "COLUMN":U THEN
          ASSIGN f_U._HANDLE:COL = dValue
                 f_L._COL        = dValue NO-ERROR.
        WHEN "HEIGHT-CHARS":U THEN
          ASSIGN f_U._HANDLE:HEIGHT = dValue
                 f_L._HEIGHT        = dValue NO-ERROR.
        WHEN "WIDTH-CHARS":U THEN
          ASSIGN f_U._HANDLE:WIDTH = dValue
                 f_L._WIDTH        = dValue NO-ERROR.
     END CASE.
     
     IF CAN-DO("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",f_u._TYPE) 
           AND pcAttribute NE "WIDTH-CHARS":U AND f_U._l-recid NE ? THEN
        RUN adeuib/_showlbl.p (f_U._HANDLE).
   END.
END.
ELSE DO:
   ASSIGN lValue = (pcValue = "yes":U) OR (pcValue = "true":U).
   /* If result code is custom, only synchronize _L fields */
   IF pcResultCode > "" THEN
   DO:
     CASE pcAttribute:
       WHEN "BGColor":U           THEN ASSIGN f_L._BGCOLOR  = INT(pcValue)
                                              f_U._HANDLE:BGCOLOR = f_L._BGCOLOR NO-ERROR.  
       WHEN "BOX":U               THEN f_L._NO-BOX          = NOT lValue.
       WHEN "CONVERT-3D-COLORS":U THEN f_L._CONVERT-3D-COLORS = lValue.
       WHEN "EDGE-PIXELS":U       THEN ASSIGN f_L._EDGE-PIXELS = INT(pcValue)
                                              f_U._HANDLE:EDGE-PIXELS = f_L._EDGE-PIXELS NO-ERROR.
       WHEN "FGCOLOR":U           THEN ASSIGN f_L._FGCOLOR  = INT(pcValue)
                                             f_U._HANDLE:FGCOLOR = f_L._FGCOLOR NO-ERROR.
       WHEN "FONT":U              THEN 
       DO:
         ASSIGN iFont = INTEGER(pcValue) NO-ERROR.
         IF error-status:ERROR OR iFont < 0 OR iFont > FONT-TABLE:NUM-ENTRIES THEN
           MESSAGE "Invalid Font:" pcValue SKIP
                   "Font number must be between 0 and " 
                   STRING(FONT-TABLE:NUM-ENTRIES) + "." VIEW-AS ALERT-BOX ERROR.
         ELSE DO:
           IF f_U._TYPE = "BROWSE":U 
           THEN ASSIGN f_L._FONT = iFont.
           ELSE ASSIGN f_U._HANDLE:FONT  = iFont
                      f_L._FONT        =  f_U._HANDLE:FONT.
        END.
       END.
       WHEN "GRAPHIC-EDGE":U     THEN ASSIGN f_L._GRAPHIC-EDGE = lValue
                                            f_U._HANDLE:GRAPHIC-EDGE = lValue.
      WHEN "LABEL":U OR
      WHEN "FieldLabel":U THEN  
      DO:
         RUN Prop_changeLabel (pcAttribute, hWidget, pcValue).
         /* If the user entered a label, set the LABELS attribute to Yes (or No-LABEL to NO */
         hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
         ASSIGN hAttribute = DYNAMIC-FUNC("getBuffer":U IN hPropLib,"ttAttribute":U).
         hAttribute:FIND-FIRST(" WHERE " + hAttribute:NAME + ".callingProc = '":U + STRING(phHandle) + "' AND ":U 
                          + hAttribute:NAME + ".containerName = '":U + STRING(pcContainer) + "' AND ":U
                          + hAttribute:NAME + ".resultCode = '":U + pcResultCode + "' AND ":U
                          + hAttribute:NAME + ".objectName = '":U + STRING(pcObject) + "' AND ":U
                          + hAttribute:NAME + ".attrLabel = 'LABELS'":U  ) NO-ERROR.
         IF hAttribute:AVAILABLE THEN 
         DO:
            hAttribute:BUFFER-FIELD("setValue"):BUFFER-VALUE = (IF pcValue > "" THEN "Yes":U ELSE "No":U).
            RUN displayProperties IN hPropLib (THIS-PROCEDURE, STRING(pcContainer),STRING(pcObject),?,?,?).
         END.

      END.
      WHEN "LABELS":U  THEN 
      DO:
         ASSIGN f_L._NO-LABEL        = NOT lValue.
         RUN Prop_changeLabel (pcAttribute, hWidget, pcValue).
      END.
      WHEN "NO-FOCUS":U         THEN f_L._NO-FOCUS         = lValue.
      WHEN "SEPARATOR-FGCOLOR":U THEN    ASSIGN f_L._SEPARATOR-FGCOLOR = INT(pcValue)
                                                f_U._HANDLE:SEPARATOR-FGCOLOR = INT(pcValue).
      WHEN "SEPARATORS":U        THEN    ASSIGN f_L._SEPARATORS        = lValue
                                                f_U._HANDLE:SEPARATORS = lVAlue.

     END CASE.
   END. /* End ResultCode is custom */
   ELSE
     CASE pcAttribute:
      WHEN "ALLOW-COLUMN-SEARCHING":U THEN  f_C._COLUMN-SEARCHING = lValue.
      WHEN "AppService":U        THEN f_P._PARTITION       = pcValue.
      WHEN "AUTO-COMPLETION":U   THEN f_F._AUTO-COMPLETION = lValue.
      WHEN "AUTO-END-KEY":U      THEN f_F._AUTO-ENDKEY     = lValue.
      WHEN "AUTO-GO":U           THEN f_F._AUTO-GO         = lValue.
      WHEN "AUTO-INDENT":U       THEN f_F._AUTO-INDENT     = lValue.
      WHEN "AUTO-RESIZE":U       THEN f_F._AUTO-RESIZE     = lValue.
      WHEN "AUTO-RETURN":U       THEN f_F._AUTO-RETURN     = lValue.
      WHEN "AUTO-VALIDATE":U     THEN f_C._NO-AUTO-VALIDATE = lValue.
      WHEN "BLANK":U             THEN f_F._BLANK           = lValue.
      WHEN "BGColor":U           THEN ASSIGN f_L._BGCOLOR  = INT(pcValue)
                                             f_U._HANDLE:BGCOLOR = f_L._BGCOLOR NO-ERROR.
      WHEN "BOX":U               THEN f_L._NO-BOX          = NOT lValue.
      WHEN "BOX-SELECTABLE":U    THEN f_C._BOX-SELECTABLE  = lValue.
      WHEN "CHECKED":U           THEN 
         IF f_U._TYPE = "TOGGLE-BOX":U THEN f_F._INITIAL-DATA = IF lValue
                                                                THEN "YES":U ELSE "NO":U.
      WHEN "COLUMN-MOVABLE":U    THEN f_C._COLUMN-MOVABLE  = lValue.
      WHEN "COLUMN-RESIZABLE":U THEN  f_C._COLUMN-RESIZABLE = lValue.
      WHEN "COLUMN-SCROLLING":U THEN  f_C._COLUMN-SCROLLING = lValue.
      WHEN "CONTEXT-HELP-ID":U   THEN f_U._CONTEXT-HELP-ID = INT(pcValue) NO-ERROR.
      WHEN "CONVERT-3D-COLORS":U THEN f_L._CONVERT-3D-COLORS = lValue.
      WHEN "DataBaseName":U      THEN f_U._DBNAME          = pcValue.
      WHEN "Data-Type":U         THEN f_F._DATA-TYPE       = pcValue.
      WHEN "DataLogicProcedure":U THEN
         IF AVAILABLE f_C THEN        f_C._DATA-LOGIC-PROC = pcValue.
      WHEN "DEBLANK":U           THEN f_F._DEBLANK         = lValue.
      WHEN "DEFAULT":U           THEN f_F._DEFAULT         = lValue.
      WHEN "DELIMITER":U         THEN f_F._DELIMITER       = pcValue.
      WHEN "DISABLE-AUTO-ZAP":U  THEN f_F._DISABLE-AUTO-ZAP = lValue.
      WHEN "DisplayField":U      THEN f_U._DISPLAY         = lValue.
      WHEN "Down":U              THEN f_C._DOWN            = lValue.
      WHEN "DRAG-ENABLED":U      THEN f_F._DRAG-ENABLED    = lValue.
      WHEN "DROP-TARGET":U       THEN f_U._DROP-TARGET     = lValue.
      WHEN "EDGE-PIXELS":U       THEN ASSIGN f_L._EDGE-PIXELS = INT(pcValue)
                                             f_U._HANDLE:EDGE-PIXELS = f_L._EDGE-PIXELS NO-ERROR.
      WHEN "ENABLED":U           THEN f_U._ENABLE          = lValue.
      WHEN "EXPAND":U            THEN f_F._EXPAND          = lValue.
      WHEN "FGCOLOR":U           THEN ASSIGN f_L._FGCOLOR  = INT(pcValue)
                                             f_U._HANDLE:FGCOLOR = f_L._FGCOLOR NO-ERROR.
      WHEN "FILLED":U            THEN ASSIGN f_L._FILLED   = lValue
                                             f_U._HANDLE:FILLED = lValue .
      WHEN "FIT-LAST-COLUMN":U   THEN f_C._FIT-LAST-COLUMN = lValue.
      WHEN "FLAT-BUTTON":U       THEN ASSIGN f_F._FLAT     = lValue.
      WHEN "FolderWindowToLaunch":U THEN f_C._FOLDER-WINDOW-TO-LAUNCH = pcValue.
      WHEN "FONT":U              THEN 
      DO:
        ASSIGN iFont = INTEGER(pcValue) NO-ERROR.
        IF error-status:ERROR OR iFont < 0 OR iFont > FONT-TABLE:NUM-ENTRIES THEN
           MESSAGE "Invalid Font:" pcValue SKIP
                   "Font number must be between 0 and " 
                   STRING(FONT-TABLE:NUM-ENTRIES) + "." VIEW-AS ALERT-BOX ERROR.
        ELSE DO:
          IF f_U._TYPE = "BROWSE":U 
          THEN ASSIGN f_L._FONT = iFont.
          ELSE ASSIGN f_U._HANDLE:FONT  = iFont
                      f_L._FONT        =  f_U._HANDLE:FONT.

        END.
      END.
      WHEN "FORMAT":U THEN
      DO:
        IF validate-format(pcValue,f_F._DATA-TYPE) THEN
           ASSIGN f_F._FORMAT = pcvalue.
      END.
      WHEN "GRAPHIC-EDGE":U     THEN ASSIGN f_L._GRAPHIC-EDGE = lValue
                                            f_U._HANDLE:GRAPHIC-EDGE = lVAlue.
      WHEN "HELP":U             THEN f_U._HELP            = pcValue.
      WHEN "HIDDEN":U           THEN ASSIGN f_U._HIDDEN          = lValue
                                            f_U._VISIBLE         = NOT f_U._HIDDEN.
      WHEN "Horizontal":U       THEN f_F._HORIZONTAL      = lValue.
      WHEN "InitialValue":U     THEN ASSIGN f_F._INITIAL-DATA = pcValue
                                            f_U._HANDLE:SCREEN-VALUE = pcValue.
      WHEN "Inner-Lines":U      THEN f_F._INNER-LINES     = INT(pcValue) NO-ERROR.
      WHEN "LARGE":U            THEN f_F._LARGE           = lValue.
      WHEN "IMAGE-FILE":U       THEN f_F._IMAGE-FILE      = pcValue.
      WHEN "LABEL":U OR
      WHEN "FieldLabel":U THEN  
      DO:
         RUN Prop_changeLabel (pcAttribute, hWidget, pcValue).
         /* If the user entered a label, set the LABELS attribute to Yes (or No-LABEL to NO */
         hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
         ASSIGN hAttribute = DYNAMIC-FUNC("getBuffer":U IN hPropLib,"ttAttribute":U).
         hAttribute:FIND-FIRST(" WHERE " + hAttribute:NAME + ".callingProc = '":U + STRING(phHandle) + "' AND ":U 
                          + hAttribute:NAME + ".containerName = '":U + STRING(pcContainer) + "' AND ":U
                          + hAttribute:NAME + ".resultCode = '":U + pcResultCode + "' AND ":U
                          + hAttribute:NAME + ".objectName = '":U + STRING(pcObject) + "' AND ":U
                          + hAttribute:NAME + ".attrLabel = 'LABELS'":U  ) NO-ERROR.
         IF hAttribute:AVAILABLE THEN 
         DO:
            hAttribute:BUFFER-FIELD("setValue"):BUFFER-VALUE = (IF pcValue > "" THEN "Yes":U ELSE "No":U).
            RUN displayProperties IN hPropLib (THIS-PROCEDURE, STRING(pcContainer),STRING(pcObject),?,?,?).
         END.

      END.
      WHEN "LABELS":U           THEN DO:
         ASSIGN f_L._NO-LABEL        = NOT lValue.
         RUN Prop_changeLabel (pcAttribute, hWidget, pcValue).
      END.
      WHEN "LIST-ITEM-PAIRS":U  THEN f_F._LIST-ITEM-PAIRS  = pcValue.
      WHEN "LIST-ITEMS":U       THEN f_F._LIST-ITEMS       = pcValue.   
      WHEN "MANUAL-HIGHLIGHT":U THEN f_U._MANUAL-HIGHLIGHT = lValue.
      WHEN "MAX-CHARS":U        THEN f_F._MAX-CHARS       = INT(pcValue).
      WHEN "MAX-DATA-GUESS":U   THEN f_C._MAX-DATA-GUESS  = INT(pcValue).
      WHEN "MOVABLE":U          THEN f_U._MOVABLE         = lValue.
      WHEN "MULTIPLE":U         THEN f_F._MULTIPLE        = lValue.
      WHEN "NAME":U  OR
      WHEN "WidgetName":U       THEN 
         IF pcValue > ""        THEN f_U._NAME             = pcValue.
      WHEN "NO-FOCUS":U         THEN f_L._NO-FOCUS         = lValue.
      WHEN "NO-EMPTY-SPACE":U   THEN f_C._NO-EMPTY-SPACE   = lValue.
      WHEN "NUM-LOCKED-COLUMNS":U THEN f_C._NUM-LOCKED-COLUMNS = INT(pcValue).
      WHEN "ORDER":U            THEN f_U._TAB-ORDER        = INT(pcValue) NO-ERROR.
      WHEN "OVERLAY":U          THEN f_C._OVERLAY          = lValue.
      WHEN "PAGE-BOTTOM":U      THEN f_C._PAGE-BOTTOM      = lValue.
      WHEN "PAGE-TOP":U         THEN f_C._PAGE-TOP         = lValue.
      WHEN "PRIVATE-DATA":U     THEN f_U._PRIVATE-DATA     = pcValue.
      WHEN "RADIO-BUTTONS":U    THEN 
        IF f_U._TYPE = "RADIO-SET":U THEN 
        DO:  /* Need to reformat the radio buttons */
          ASSIGN f_F._LIST-ITEMS = pcValue.
          IF NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) > 3 AND
             NUM-ENTRIES(f_F._LIST-ITEMS, CHR(10)) < 2 THEN 
          DO:
              DO iPos = 3 TO NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) BY 2:
                ENTRY(iPos, f_F._LIST-ITEMS, f_F._DELIMITER) = CHR(10) + 
                    trim(ENTRY(iPos, f_F._LIST-ITEMS, f_F._DELIMITER)).
              END.
              RUN adeuib/_rbtns.p( f_F._LIST-ITEMS, "INTEGER", f_F._DELIMITER, OUTPUT cTmp).
              f_U._HANDLE:RADIO-BUTTONS = cTmp NO-ERROR.
          END.  /* There are more than 1 item and no <CR>s */
        END. /* Reformating radio-buttons attribute */
      WHEN "READ-ONLY":U        THEN     ASSIGN f_F._READ-ONLY        = lValue
                                                f_U._HANDLE:READ-ONLY = lValue.
      WHEN "RESIZABLE":U        THEN     f_U._RESIZABLE       = lValue.
      WHEN "RETAIN-SHAPE":U     THEN     ASSIGN f_F._RETAIN-SHAPE        = lValue
                                                f_U._HANDLE:RETAIN-SHAPE = lValue.
      WHEN "RETURN-INSERTED":U  THEN     f_F._RETURN-INSERTED = lValue.
      WHEN "ROW-HEIGHT-CHARS":U THEN     ASSIGN f_C._ROW-HEIGHT      = DEC(pcValue)
                                                f_U._HANDLE:ROW-HEIGHT = DEC(pcValue).
      WHEN "SCROLLBAR-HORIZONTAL":U THEN f_F._SCROLLBAR-H     = lValue.
      WHEN "SCROLLBAR-VERTICAL":U   THEN f_U._SCROLLBAR-V     = lValue.
      WHEN "SELECTABLE":U       THEN     f_U._SELECTABLE      = lValue.
      WHEN "SENSITIVE":U        THEN     f_U._SENSITIVE       = lValue.
      WHEN "SEPARATOR-FGCOLOR":U THEN    ASSIGN f_L._SEPARATOR-FGCOLOR = INT(pcValue)
                                                f_U._HANDLE:SEPARATOR-FGCOLOR = INT(pcValue).
      WHEN "SEPARATORS":U       THEN     ASSIGN f_L._SEPARATORS        = lValue
                                                f_U._HANDLE:SEPARATORS = lVAlue.
      WHEN "ShowPopup":U        THEN     f_U._SHOW-POPUP      = lValue.
      WHEN "SIDE-LABELS":U      THEN     f_C._SIDE-LABELS     = lValue.
      WHEN "SizeToFit":U        THEN     f_C._SIZE-TO-FIT     = lValue.
      WHEN "SORT":U             THEN     f_F._SORT            = lValue.
      WHEN "STRETCH-TO-FIT":U   THEN     ASSIGN f_F._STRETCH-TO-FIT        = lValue
                                                f_U._HANDLE:STRETCH-TO-FIT = lValue.
      WHEN "SubType":U          THEN     f_U._SUBTYPE         = pcValue.
      WHEN "TAB-STOP":U         THEN     f_U._NO-TAB-STOP     = NOT lValue.
      WHEN "TableName":U        THEN  ASSIGN f_U._BUFFER      = pcValue
                                             f_U._TABLE       = pcValue.
      WHEN "THREE-D":U          THEN     f_L._3-D             = lValue.
      WHEN "Tooltip":U          THEN     ASSIGN f_U._TOOLTIP  = pcValue
                                                f_U._HANDLE:TOOLTIP = pcValue.
      WHEN "TRANSPARENT":U      THEN     f_F._TRANSPARENT     = lValue.
      WHEN "VISIBLE":U          THEN    ASSIGN
                                        f_U._VISIBLE         = lValue  
                                        f_U._HIDDEN          = NOT lValue.
      WHEN "VisualizationType":U THEN ASSIGN f_U._TYPE        = pcValue
                                             f_U._ALIGN       = IF LOOKUP(f_U._TYPE,"RADIO-SET,IMAGE,SELECTION-LIST,EDITOR":U) > 0
                                                                THEN "L":U 
                                                                ELSE "C":U.
      WHEN "WindowTitleField":U  THEN    f_C._WINDOW-TITLE-FIELD = pcValue.
      WHEN "WORD-WRAP":U        THEN ASSIGN f_F._WORD-WRAP       = lValue.
      OTHERWISE DO:
         /* Check for changes in SmartObject properties */
           setSmartSetting(f_U._x-recid,pcAttribute,pcValue).
      END.
   END CASE.

END.
/* Flag window as modified */
RUN adeuib/_winsave.p (_h_win,FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PropertyChangedEvent C-Win 
PROCEDURE PropertyChangedEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle         AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcContainer      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcObject         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcResultCode     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventAction    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionType     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionTarget   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEventParameter AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plEventDisabled  AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER plOverride       AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcFieldsModified AS CHARACTER  NO-UNDO.

  /* Flag window as modified */
RUN adeuib/_winsave.p (_h_win,FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PropertyChangedObject C-Win 
PROCEDURE PropertyChangedObject :
/*------------------------------------------------------------------------------
  Purpose:     Called when the property sheet perfroms a value-changed
               event on the Object combo-box.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phProc      AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainer AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObject    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow  AS HANDLE     NO-UNDO.

IF phProc <> THIS-PROCEDURE THEN
   RETURN.

ASSIGN hWidget = WIDGET-HANDLE(pcObject) 
       hWIndow = WIDGET-HANDLE(pcContainer) NO-ERROR.

FOR EACH _U WHERE _U._SELECTEDib AND _U._WINDOW-HANDLE = hWindow:
   ASSIGN _U._SELECTEDib       = FALSE
          _U._HANDLE:SELECTED = FALSE.
END.

FIND _U WHERE  _U._WINDOW-HANDLE = hWindow AND _U._HANDLE = hWIdget NO-ERROR.
IF AVAIL _U AND CAN-SET( _U._HANDLE,"SELECTED":U) THEN
   ASSIGN _U._SELECTEDib      = TRUE
          _U._HANDLE:SELECTED = TRUE.











END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propUndoWidget C-Win 
PROCEDURE propUndoWidget :
/*------------------------------------------------------------------------------
  Purpose:   UnDeletes widgets that have previously been deleted
  Parameters: phWidget   Handle of widget being undone.
  Notes:      Called from Undo of widget adeuib/_undo.p
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcOldWidgetName AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER phNewWidget     AS HANDLE     NO-UNDO.

IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.

RUN undeleteObject IN ghPropertySheet
             (INPUT THIS-PROCEDURE,
              INPUT STRING(_h_win),
              INPUT pcOldWidgetName,
              INPUT STRING(phNewWidget)
             )  NO-ERROR.

gcRegisteredObjects = gcRegisteredObjects + (IF gcRegisteredObjects = "" THEN "" ELSE ",") 
                                                + STRING(phNewWidget).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propUpdateMaster C-Win 
PROCEDURE propUpdateMaster :
/*------------------------------------------------------------------------------
  Purpose:     Updates registered non-dynamic object attributes 
  Parameters:  phWindow            Window handle of container
               pd_smartObject_obj  Object_obj of master object
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER  phWindow          AS HANDLE     NO-UNDO.
 DEFINE INPUT  PARAMETER  pdSmartObject_obj AS DECIMAL    NO-UNDO.
 
 DEFINE VARIABLE hPropBuffer           AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hPropLib              AS HANDLE      NO-UNDO.
 DEFINE VARIABLE httClassBuffer        AS HANDLE      NO-UNDO.
 DEFINE VARIABLE cResultCode           AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cDataType             AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE cValue                AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE hQuery                AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hUnknown              AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRepDesignManager     AS HANDLE     NO-UNDO.


hPropLib = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN THIS-PROCEDURE).
IF VALID-HANDLE(hPropLib) THEN 
DO:
  ASSIGN hPropBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hPropLib, "ttAttribute":U).
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hPropBuffer).
  hQuery:QUERY-PREPARE(" FOR EACH ttAttribute WHERE " 
                        + hPropBuffer:NAME + ".callingProc = '":U + STRING(THIS-PROCEDURE) + "' AND ":U 
                        + hPropBuffer:NAME + ".containerName = '":U + STRING(phWindow) + "' AND ":U
                        + hPropBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
                        + hPropBuffer:NAME + ".objectName = '":U + STRING(phWindow) + "' AND "
                        + hPropBuffer:NAME + ".RowModified = 'true'") .
  hQuery:QUERY-OPEN().

  hQuery:GET-FIRST(NO-LOCK).
  DO WHILE hPropBuffer:AVAILABLE:
    /* check whether the attribute was modified and if it's override flag is set */
    IF hPropBuffer:BUFFER-FIELD("RowOverride":U):BUFFER-VALUE = TRUE THEN
    DO:
      ASSIGN cDataType = hPropBuffer:BUFFER-FIELD("dataType":U):BUFFER-VALUE
             cValue    = hPropBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE.

      CREATE ttStoreAttribute.
      ASSIGN ttStoreAttribute.tAttributeParent    = "MASTER":U
             ttStoreAttribute.tAttributeParentObj = pdSmartObject_obj
             ttStoreAttribute.tAttributeLabel     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE
             ttStoreAttribute.tConstantValue      = NO.  /* Always no, otherwise we wouldn't be setting it */

      CASE cDataType:
          WHEN "CHARACTER":U OR WHEN "CHAR":U THEN ttStoreAttribute.tCharacterValue = cValue.
          WHEN "DECIMAL":U   OR WHEN "DEC":U  THEN ttStoreAttribute.tDecimalValue   = DECIMAL(cValue).
          WHEN "INTEGER":U   OR WHEN "INT":U  THEN ttStoreAttribute.tIntegerValue   = INT(cValue).
          WHEN "LOGICAL":U   OR WHEN "LOG":U  THEN ttStoreAttribute.tLogicalValue   = (cValue = "YES" OR cValue = "true").
          WHEN "DATE":U                       THEN ttStoreAttribute.tDateValue      = DATE(cValue).
          OTHERWISE                        ttStoreAttribute.tCharacterValue = cValue.
      END CASE.

    END.  /* if an attribute was modified and overridden */
    ELSE 
    DO:
       /* Override was de-selected to remove attribute */
      CREATE ttStoreAttribute2.
      ASSIGN ttStoreAttribute2.tAttributeParent    = "MASTER":U
             ttStoreAttribute2.tAttributeParentObj = pdSmartObject_obj
             ttStoreAttribute2.tAttributeLabel     = hPropBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE
             ttStoreAttribute2.tConstantValue      = NO.  /* Always no, otherwise we wouldn't be setting it */
    END.

    hQuery:GET-NEXT().
  END. /* DO WHILE  PropBuffer Exists */
END.  /* If hPropLib is valid */

IF CAN-FIND(FIRST ttStoreAttribute) THEN
DO:
   RUN StoreAttributeValues IN gshRepositoryManager
         (INPUT TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE ,
          INPUT TABLE-HANDLE hUnKnown).  /* Compiler requires a variable with unknown */
   EMPTY TEMP-TABLE ttStoreAttribute.
END.
IF CAN-FIND(FIRST ttStoreAttribute2) THEN
DO:
   hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
   RUN RemoveAttributeValues IN hRepDesignManager
          (INPUT TEMP-TABLE ttStoreAttribute2:DEFAULT-BUFFER-HANDLE ,
           INPUT TABLE-HANDLE hUnknown).
   EMPTY TEMP-TABLE ttStoreAttribute2.
END.

DELETE OBJECT hQuery NO-ERROR.
 

  /* if _h_menubar_proc is valid */ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prop_addResultCode C-Win 
PROCEDURE prop_addResultCode :
/*------------------------------------------------------------------------------
  Purpose:     Adds a result code to the dynamic propertysheet
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcResultCode AS CHARACTER  NO-UNDO.

IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.

RUN addResultCode IN ghPropertySheet
             (INPUT THIS-PROCEDURE,
              INPUT STRING(_h_win),
              INPUT pcResultCode )  NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prop_changeContainer C-Win 
PROCEDURE prop_changeContainer :
/*------------------------------------------------------------------------------
  Purpose:     Wrapper program to change name of container
               in the Dynamic Property Sheet
  Parameters:  phOldWin
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcOldWin AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pcNewWin AS CHARACTER     NO-UNDO.

IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.

RUN ChangeContainerName IN ghPropertySheet
                  (INPUT THIS-PROCEDURE,
                   INPUT pcOldWin,
                   INPUT pcNewWin) NO-ERROR.
gcRegisteredObjects = REPLACE(gcRegisteredObjects,pcOldWin, pcNewWin).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prop_changeGeometry C-Win 
PROCEDURE Prop_changeGeometry :
/*------------------------------------------------------------------------------
  Purpose:    Called when an object is moved or resized within a dynamic viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phWidget AS HANDLE  NO-UNDO.

DEFINE VARIABLE cWidgetList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hPropWindow AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAttributes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode AS CHARACTER  NO-UNDO.

DEFINE BUFFER local_P FOR _P.
DEFINE BUFFER local_U FOR _U.
FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  
/* IF NOT a registered dynamic Viewer Object then return */
IF NOT AVAILABLE local_P 
    OR local_P.smartobject_obj = 0  
    OR local_P.object_type_code <> "DynView":U
    OR NOT VALID-HANDLE(ghpropertySheet) THEN 
  RETURN.

/* If property sheet window is closed, return */
IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.
hPropWindow = DYNAMIC-FUNC("getPropSheet":U IN ghPropertySheet).
IF NOT VALID-HANDLE(hPropWindow) THEN RETURN.

FIND  local_U WHERE local_U._HANDLE = phWidget NO-ERROR.
IF NOT AVAILABLE local_U THEN RETURN.


FIND _L  WHERE RECID(_L) = local_U._lo-recid NO-ERROR.
cResultCode = "".
IF AVAIL _L THEN
   cResultCode = IF _L._LO-NAME = "Master Layout":U 
                 THEN ""
                 ELSE _L._LO-NAME.
ASSIGN 
  cAttributes = "ROW" + CHR(3) + cResultCode + CHR(3) + STRING(local_U._HANDLE:ROW) + CHR(3) 
                + "COLUMN":U + CHR(3) + cResultCode + CHR(3) + string(local_U._HANDLE:COL) + CHR(3) 
                + "HEIGHT-CHARS":U + CHR(3)+ cResultCode + CHR(3) + string(local_U._HANDLE:HEIGHT) + CHR(3) 
                + "WIDTH-CHARS":U + CHR(3) + cResultCode + CHR(3) + string(local_U._HANDLE:WIDTH).

  
RUN assignPropertyValues IN ghPropertySheet
         (THIS-PROCEDURE, 
          STRING(_h_win),
          STRING(phWidget),
          cAttributes,
          "",
          YES).

RUN displayProperties IN ghPropertySheet
         (THIS-PROCEDURE, STRING(_h_win),STRING(phWidget),?,?,?).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prop_changeLabel C-Win 
PROCEDURE Prop_changeLabel :
/*------------------------------------------------------------------------------
  Purpose:     Change the label of the current widget.  
  Parameters:  pcAttribute  Attribute being changed. LABELS or LABEL
               phWidget     Handle of widget being changed
               pcValue      Value of pcAttribute
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAttribute     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER phWidget        AS HANDLE  NO-UNDO.
DEFINE INPUT  PARAMETER pcValue         AS CHARACTER  NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER label2_U FOR _U.
DEFINE BUFFER ip_F     FOR _F.
DEFINE BUFFER parent_L FOR _L.

   
DEFINE VARIABLE text-sa AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBName AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE hRDM    AS HANDLE     NO-UNDO.

FIND _U WHERE _U._HANDLE = phWidget NO-ERROR.
FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
FIND _L WHERE RECID(_L)  = _U._lo-recid.
FIND _C WHERE RECID(_C)  = _U._x-recid NO-ERROR.
IF AVAIL _U THEN 
DO:
  IF CAN-SET(_U._HANDLE, "LABEL":U) THEN 
  DO:  
    /* Get the parent. */
    FIND parent_U WHERE RECID(parent_U) = _U._PARENT-RECID.
    FIND _C       WHERE RECID(_C)       = parent_U._x-recid.
    IF pcAttribute = "LABEL":U AND (pcValue EQ "?" OR pcValue EQ ?) THEN
    DO: /* Label is "unknown", so use "D"efault -- note: for DB fields, we
           need to refetch the Default label. We only bother with this change
           if the old value was not "D"efault. */
       IF _U._LABEL-SOURCE ne "D" THEN 
       DO:
         IF _U._BUFFER = "RowObject":U THEN /* Get dbname as the _U._DbNAME = Temp-Tables for datafields */
           ASSIGN hRDM    = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                             INPUT "RepositoryDesignManager":U)
                  cDBName = DYNAMIC-FUNCTION("getBufferDbName":U IN hRDM, _U._TABLE) NO-ERROR.
         ELSE
            cdbName = _U._DBNAME.
         FIND ip_F WHERE RECID(_F) = _U._x-recid NO-ERROR.
         IF cdbName ne ?  THEN
           RUN adeuib/_fldlbl.p (
              cDBName,
              _U._TABLE,
              IF AVAIL _F AND _F._DISPOSITION = "LIKE":U 
              THEN _F._LIKE-FIELD 
              ELSE _U._NAME,
              _C._SIDE-LABELS, 
              OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).   
         /*_U._LABEL-SOURCE = "D".*/
       END.  
    END. /* End if pcValue = ? */
    ELSE IF pcAttribute = "LABEL":U THEN
       ASSIGN _U._LABEL        = pcValue
              _U._LABEL-SOURCE = "E"
              _L._LABEL        = pcValue.

    /* Now change the label */
    CASE _U._TYPE:
      WHEN "BUTTON":U OR WHEN "TOGGLE-BOX":U THEN DO:
        RUN adeuib/_sim_lbl.p (_U._HANDLE). /* i.e. buttons and toggles */
      END.
      /* Menus and Sub-menus have a label, but no _F record. */
      WHEN "MENU-ITEM":U OR WHEN "SUB-MENU":U THEN DO:
        RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT text-sa).
        _U._HANDLE:LABEL = text-sa.
      END.
      OTHERWISE  DO:
        /* For editors, set the _LABEL to the actual label */
        IF pcAttribute = "LABELS":U AND pcValue = "Yes" AND _U._TYPE = "EDITOR" 
                      AND (_U._LABEL = ? OR _U._LABEL = "") THEN
        DO:
           ASSIGN _U._LABEL-SOURCE = "E"
                  _U._LABEL = _U._NAME
                  _L._LABEL = _U._NAME.
        END.
        /* Get the objects layout and parent records */
        FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
        FIND _F WHERE RECID(_F) eq _U._x-recid.
        FIND _L WHERE RECID(_L) eq _U._lo-recid.
        IF pcAttribute = "LABEL":U THEN
              _L._NO-LABELS = (TRIM(_U._LABEL) EQ ""). /* Set no-label */
        IF NOT _C._SIDE-LABELS AND NOT parent_L._NO-LABELS AND _L._NO-LABELS
        THEN RUN adeuib/_chkpos.p (INPUT _U._HANDLE).
        IF CAN-DO("EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN
        DO:
            FIND label2_U WHERE RECID(label2_U) = _U._l-recid NO-ERROR.
            IF NOT AVAILABLE Label2_U OR NOT VALID-HANDLE(label2_U._HANDLE) THEN
            DO:
              {adeuib/addlabel.i}
            END.
        END.
        RUN adeuib/_showlbl.p (_U._HANDLE).
      END.
    END CASE.
  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prop_ChangeObjectName C-Win 
PROCEDURE prop_ChangeObjectName :
/*------------------------------------------------------------------------------
  Purpose:     Wrapper program to change name of an Object
               in the Dynamic Property Sheet
  Parameters:  phOldWin
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcOldContainer AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldObject    AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pcNewObject    AS CHARACTER     NO-UNDO.

IF NOT VALID-HANDLE(ghPropertySheet) THEN RETURN.

RUN ChangeObjectName IN ghPropertySheet
                   (INPUT THIS-PROCEDURE,
                    INPUT pcOldContainer,
                    INPUT pcOldObject,
                    INPUT pcNewObject) NO-ERROR.
gcRegisteredObjects = REPLACE(gcRegisteredObjects,pcOldObject, pcNewObject).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prop_register C-Win 
PROCEDURE Prop_register :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the specified object from the repositiry, extracts the 
               attributes and events, and registers the object in the Property sheet 
  Parameters:  pcContainerHandle  Handle string of current window
               pcObjectHandle     Handle string of current widget
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcContainerHandle AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectHandle    AS CHARACTER  NO-UNDO.

DEFINE BUFFER BUFF_U  FOR _U.
DEFINE BUFFER BUFF2_U FOR _U.
DEFINE BUFFER BUFF_P  FOR _P.
DEFINE BUFFER BUFF_S  FOR _S.

DEFINE VARIABLE hWidget             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cClass              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributes         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEvents             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultAttributes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultEvents      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c_UName             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectHandle       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObjectBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectBuffer2      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttributeBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUIEventBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectQuery        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hEventQuery         AS HANDLE     NO-UNDO.
DEFINE VARIABLE dRecordIdentifier   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lisMaster           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFldName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectList         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCodeList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstanceName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectHandleList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectNameList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClassList          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventList          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultAttrList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultEventList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPos                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cIsMasterList       AS CHARACTER  NO-UNDO.

IF pcObjectHandle = ? OR pcObjectHandle = ""  THEN
   RETURN.

ASSIGN hWidget = WIDGET-HANDLE(pcObjectHandle)
       hWindow = WIDGET-HANDLE(pcContainerHandle)
       NO-ERROR.

IF NOT VALID-HANDLE(hWidget) OR NOT VALID-HANDLE(hWindow) THEN
   RETURN.

FIND BUFF_P WHERE BUFF_P._WINDOW-HANDLE = hWindow NO-ERROR.
/* IF NOT a registered Object (object_type_code = "") then return */
IF NOT AVAILABLE BUFF_P OR BUFF_P.object_type_code = "" OR BUFF_P.OBJECT_FILENAME = "" THEN
   RETURN.

FIND BUFF_U WHERE BUFF_U._HANDLE = hWidget NO-ERROR.
IF NOT AVAILABLE  BUFF_U  THEN RETURN.

IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT BUFF_P.OBJECT_FILENAME,
                     INPUT "*", /* Get all Result Codes */
                     INPUT "",  /* RunTime Attributes not applicable in design mode */
                     INPUT YES  /* Design Mode is yes */
                  )  THEN
   ASSIGN hObjectBuffer  = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
          hUIEventBuffer = DYNAMIC-FUNC("getCacheUIEventBuffer":U IN gshRepositoryManager).
ELSE
DO:
  MESSAGE "Could not register object " VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN.
END.

CREATE BUFFER hObjectBuffer2 FOR TABLE hObjectBuffer.
CREATE QUERY hObjectQuery.
hObjectQuery:ADD-BUFFER(hObjectBuffer).
/* Build result code list for DynViewer  master */
hObjectQuery:QUERY-PREPARE( " FOR EACH " + hObjectBuffer:NAME + " WHERE ":U 
                                         + hObjectBuffer:NAME +  ".tLogicalObjectName = '" +  BUFF_P.OBJECT_FILENAME + "'").
hObjectQuery:QUERY-OPEN().
hObjectQuery:GET-FIRST().
DO WHILE hObjectBuffer:AVAILABLE: 
   IF LOOKUP(hObjectBuffer:BUFFER-FIELD("tResultCode"):BUFFER-VALUE,cResultCodeList) = 0 THEN
      cResultCodeList = cResultCodeList + (IF cResultCodeList = "" THEN "" ELSE ",") 
                                        + hObjectBuffer:BUFFER-FIELD("tResultCode"):BUFFER-VALUE.
   hObjectQuery:GET-NEXT().
END.
/* Add any result codes that may have been added since object was opened*/
FOR EACH _L WHERE _L._U-RECID = RECID(BUFF_U):
   IF _L._LO-NAME = "Master Layout" THEN
      NEXT.
   IF LOOKUP(_L._LO-NAME,cResultCodeList) = 0 THEN
      cResultCodeList = cResultCodeList + (IF cResultCodeList = "" THEN "" ELSE ",") + trim(_L._LO-NAME).
END.

hObjectQuery:QUERY-CLOSE().
hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                            + hObjectBuffer:NAME + ".tContainerObjectName = '" + BUFF_P.OBJECT_FILENAME + "'":U).
                            

hObjectQuery:QUERY-OPEN().
hObjectQuery:GET-FIRST().
Object-Loop:
DO WHILE hObjectBuffer:AVAILABLE: 
   ASSIGN hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
          cResultCode       = hObjectBuffer:BUFFER-FIELD("tResultCode"):BUFFER-VALUE
          cClass            = hObjectBuffer:BUFFER-FIELD("tClassName"):BUFFER-VALUE
          dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
          cObjectName       = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName"):BUFFER-VALUE  
          cInstanceName     = hObjectBuffer:BUFFER-FIELD("tObjectInstanceName"):BUFFER-VALUE 
          cInstanceName     = IF cInstanceName = "" OR cInstanceName = ? THEN cObjectName ELSE cInstanceName
          NO-ERROR.
          
   /* To get the actual result codes of instances, we must find the container object and use it's result code */
   IF cObjectName NE BUFF_P.OBJECT_FILENAME THEN
   DO:
      hObjectBuffer2:FIND-FIRST(" WHERE " + hObjectBuffer:NAME + ".tRecordIdentifier = " 
                                          + QUOTER(hObjectBuffer:BUFFER-FIELD("tContainerRecordIdentifier":U):BUFFER-VALUE)).
      IF hObjectBuffer2:AVAILABLE THEN
         cResultCode = hObjectBuffer2:BUFFER-FIELD("tResultCode"):BUFFER-VALUE.
   END.
        
    /* To avoid duplicate records, ensure we're not retrieving the same object. Key = instanceName & resultcode*/
   IF LOOKUP(cInstanceName + cResultCode,cObjectList) = 0 THEN
       cObjectList = cObjectList + (IF cObjectList = "" THEN "" ELSE ",") + cInstanceName + cResultCode.
   ELSE DO:
       hObjectQuery:GET-NEXT().
       NEXT Object-Loop.
   END.
   ASSIGN cObjectHandle = "".
   /* MASTER OBJECT */
   IF cObjectName EQ BUFF_P.OBJECT_FILENAME THEN
      ASSIGN cObjectHandle = pcObjectHandle
             lIsMaster     = YES.
   ELSE DO:
      /* INSTANCE OBJECTS of Master */
      ASSIGN
        c_UName          = cObjectName
        lIsMaster        = NO.
        

      /* Find the _U record containing this instance */
      IF NUM-ENTRIES(c_UName,".") = 2 THEN
        c_UName = ENTRY(2,c_UName, ".").
      FIND FIRST BUFF2_U WHERE BUFF2_U._WINDOW-HANDLE = hWindow 
                           AND BUFF2_U._NAME = c_UName 
                           AND BUFF2_U._STATUS <> "DELETED":U NO-ERROR.
      IF AVAIL BUFF2_U THEN
         ASSIGN cObjectHandle    = STRING(BUFF2_U._HANDLE).
      ELSE DO:
        /* Check whether widget is a Smart Data Field  */
         SmartObject-Loop:
         FOR EACH BUFF_S, 
             FIRST BUFF2_U WHERE BUFF2_U._x-recid = RECID(BUFF_S)
                            AND BUFF2_U._Window-Handle = hWindow
                            AND BUFF2_U._STATUS <> "DELETED":U:

            ASSIGN cFldName = DYNAMIC-FUNCTION('getFieldName':U IN BUFF_S._HANDLE) NO-ERROR.

            IF (NUM-ENTRIES(cObjectName,".") = 2 AND ENTRY(2,cObjectName,".") = cFldName)
               OR cFldName = cObjectName THEN
            DO:
               ASSIGN cObjectHandle   = STRING(BUFF2_U._HANDLE).
               LEAVE SmartObject-Loop.
            END.
         END. /* End SmartObject Loop */
         IF cObjectHandle = "" THEN 
         DO:
            /* Find Instance Name (for non datafield widgets */
            FIND FIRST BUFF2_U WHERE BUFF2_U._WINDOW-HANDLE = hWindow 
                                 AND BUFF2_U._NAME = cInstanceName
                                 AND BUFF2_U._STATUS <> "DELETED":U NO-ERROR.
            IF AVAIL BUFF2_U THEN
               ASSIGN cObjectHandle    = STRING(BUFF2_U._HANDLE).
            ELSE DO:
              hObjectQuery:GET-NEXT().
              NEXT Object-Loop.
            END.
         END.
      END.
         
   END. /* END Instance Objects only */
   /* Get attribute buffer for the master and it's instances and call function to build it */
   hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                           + STRING(dRecordIdentifier) + "' ":U) NO-ERROR.
                            
   cAttributes = getAttributeValue(hAttributeBuffer,lIsmaster,cResultCode).
   ASSIGN cAttributes = "NAME" + CHR(3) + CHR(3) + cObjectName + (IF cAttributes = "" THEN "" ELSE CHR(3))
                               + cAttributes.
      
   /* Now get the master object for each instance and calculate the default attribute values Not necessaru for custom */
   IF NOT lIsMaster AND cResultCode = "{&DEFAULT-RESULT-CODE}":U THEN
   DO:
      hObjectBuffer2:FIND-FIRST(" WHERE " + hObjectBuffer2:NAME + ".tRecordIdentifier = '" 
                                          + hObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE 
                                          + "'").
      IF hObjectBuffer2:AVAILABLE THEN
      DO:
        hAttributeBuffer  = hObjectBuffer2:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                           + hObjectBuffer2:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE  + "' ":U) .
        cDefaultAttributes = getAttributeMasterValue(hAttributeBuffer,lIsmaster,cResultCode).
      END.   /* End IF hObjectBuffer2 is available */

   END.  /* End if Not lIsmaster */

   /* Now get the UI Events  */
   IF VALID-HANDLE(hUIEventBuffer) THEN
   DO:
     CREATE QUERY hEventQuery.                                                                                
     hEventQuery:SET-BUFFERS(hUIEventBuffer).                                                              
     hEventQuery:QUERY-PREPARE("FOR EACH " + hUIEventBuffer:NAME + " WHERE " 
                                + hUIEventBuffer:NAME + ".trecordIdentifier = "  
                                + QUOTER(string(drecordIdentifier)) ). 
     hEventQuery:QUERY-OPEN().                                                                                
     hEventQuery:GET-FIRST(). 
     cEvents = "".
     DO WHILE hUIEventBuffer:AVAILABLE:
        cEvents = cEvents + (IF cEvents = "" THEN "" ELSE CHR(3)) 
                 +  hUIEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE + CHR(3)
                 + (IF cResultCode = "{&DEFAULT-RESULT-CODE}":U THEN "" ELSE cResultCode) + CHR(3) 
                 + hUIEventBuffer:BUFFER-FIELD("tEventAction":U):BUFFER-VALUE + CHR(3)
                 + hUIEventBuffer:BUFFER-FIELD("tActionType":U):BUFFER-VALUE + CHR(3)
                 + hUIEventBuffer:BUFFER-FIELD("tActionTarget":U):BUFFER-VALUE + CHR(3)
                 + hUIEventBuffer:BUFFER-FIELD("tEventParameter":U):BUFFER-VALUE + CHR(3)
                 + hUIEventBuffer:BUFFER-FIELD("tEventDisabled":U):BUFFER-VALUE .
        hEventQuery:GET-NEXT().   
     END.
   END.

   /* Now get the UI Default Events for instances by using the master record identifier*/
   IF NOT lIsMaster AND VALID-HANDLE(hUIEventBuffer) THEN
   DO:
     hEventQuery:SET-BUFFERS(hUIEventBuffer).                                                              
     hEventQuery:QUERY-PREPARE("FOR EACH " + hUIEventBuffer:NAME + " WHERE " 
                                + hUIEventBuffer:NAME + ".trecordIdentifier = "  
                                + QUOTER(hObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE) ). 
     hEventQuery:QUERY-OPEN().                                                                                
     hEventQuery:GET-FIRST(). 
     cDefaultEvents = "".
     DO WHILE hUIEventBuffer:AVAILABLE:
        cDefaultEvents = cDefaultEvents + (IF cDefaultEvents = "" THEN "" ELSE CHR(3)) 
              +  hUIEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE + CHR(3)
              + (IF cResultCode = "{&DEFAULT-RESULT-CODE}":U THEN "" ELSE cResultCode) + CHR(3) 
              + hUIEventBuffer:BUFFER-FIELD("tEventAction":U):BUFFER-VALUE + CHR(3)
              + hUIEventBuffer:BUFFER-FIELD("tActionType":U):BUFFER-VALUE + CHR(3)
              + hUIEventBuffer:BUFFER-FIELD("tActionTarget":U):BUFFER-VALUE + CHR(3)
              + hUIEventBuffer:BUFFER-FIELD("tEventParameter":U):BUFFER-VALUE + CHR(3)
              + hUIEventBuffer:BUFFER-FIELD("tEventDisabled":U):BUFFER-VALUE .
        hEventQuery:GET-NEXT().   

     END.
   END.
   DELETE OBJECT hEventQuery NO-ERROR.
   
   /* Build lists if there are custom layouts so that the objects can be registered once with
      the custom information */
   IF NUM-ENTRIES(cResultCodeList) > 1 THEN
   DO:

      IF LOOKUP(cObjectHandle,cObjectHandleList) > 0 THEN /* add the attributes and events to existing string */
      DO:
         ASSIGN iPos =            LOOKUP(cObjectHandle,cObjectHandleList).
         
         
         ENTRY(iPos,cAttributeList,CHR(5)) =  ENTRY(iPos,cAttributeList,CHR(5)) 
                                                   + (IF ENTRY(iPos,cAttributeList,CHR(5)) = "" THEN "" ELSE CHR(3))
                                                   + cAttributes.
         ENTRY(iPos,cEventList,CHR(5)) =  ENTRY(iPos,cEventList,CHR(5)) 
                                                    + (IF ENTRY(iPos,cEventList,CHR(5)) = "" THEN "" ELSE CHR(3))
                                                    + cEvents.
         ENTRY(iPos,cDefaultAttrList,CHR(5)) =  ENTRY(iPos,cDefaultAttrList,CHR(5)) 
                                                   + (IF ENTRY(iPos,cDefaultAttrList,CHR(5)) = "" THEN "" ELSE CHR(3))
                                                   + cDefaultAttributes.
         ENTRY(iPos,cDefaultEventList,CHR(5)) =  ENTRY(iPos,cDefaultEventList,CHR(5)) 
                                                   + (IF ENTRY(iPos,cDefaultEventList,CHR(5)) = "" THEN "" ELSE CHR(3))
                                                   + cDefaultEvents.                                        
      END.
      ELSE 
         ASSIGN 
            cAttributeList    = cAttributeList +  CHR(5) + cAttributes
            cEventList        = cEventList + CHR(5) + cEvents
            cDefaultAttrList  = cDefaultAttrList + CHR(5) + cDefaultAttributes
            cDefaultEventList = cDefaultEventList + CHR(5) + cDefaultEvents
            cObjectHandleList = cObjectHandleList + "," + cObjectHandle
            cObjectNameList   = cObjectNameList +  "," + cObjectName
            cClassList        = cClassList +  "," + cClass
            cIsMasterList     = cIsMasterList + "," + IF lIsMaster THEN "yes":U ELSE "no":U.
   END.

   /* Register the master objects and instances in the property sheet. 
      Only register it here if there are no custom layouts. */
   IF LOOKUP(cObjectHandle,gcRegisteredObjects) = 0 AND NUM-ENTRIES(cResultCodeList) = 1 THEN 
   DO:
      RUN registerObject IN ghPropertySheet
            (THIS-PROCEDURE,         /* Calling procedure handle */
             pcContainerHandle,      /* Name of container object */
             BUFF_P.OBJECT_FILENAME, /* Label of container */
             cObjectHandle,          /* Name of object.. same as container */
             cObjectName,            /* Label of Object */
             cClass,                 /* Class name */
             "",                    /* Other supported classes */
             IF lIsMaster THEN "MASTER":U
                          ELSE "INSTANCE":U ,             /* MASTER or INSTANCE */
             cAttributes,            /* List of attributes to set */
             cEvents,                /* List of events to set */
             cDefaultAttributes,        /* Default values of master */
             cDefaultEvents,            /* Default events of master */
             cResultCodeList      ).    /* Result Codes */
      /* Add handle to string of already registered objects */
      gcRegisteredObjects = gcRegisteredObjects + (IF gcRegisteredObjects = "" THEN "" ELSE ",") 
                                                + cObjectHandle.
   END.
   hObjectQuery:GET-NEXT().
END.  /* END DO WHILE hObjectQuery:AVAILABLE */

/* If there are mutiple custom layouts, we need to register with combined attributes and defaults.*/
IF NUM-ENTRIES(cResultCodeList) > 1 THEN
DO iPos = 2 to NUM-ENTRIES(cObjectHandleList):
  IF LOOKUP(ENTRY(iPos,cObjectHandleList),gcRegisteredObjects) = 0 THEN 
  DO:
     RUN registerObject IN ghPropertySheet
        (THIS-PROCEDURE,          /* Calling procedure handle */
         pcContainerHandle,       /* Name of container object */
        BUFF_P.OBJECT_FILENAME,   /* Label of container */
        ENTRY(iPos,cObjectHandleList), /* Name of object.. same as container */
        ENTRY(iPos,cObjectNameList),   /* Label of Object */
        ENTRY(iPos,cClassList),        /* Class name */
        "",                            /* Other supported classes */
        IF ENTRY(iPos,cIsMasterList) =  "yes" THEN "MASTER":U
                                              ELSE "INSTANCE":U ,             /* MASTER or INSTANCE */
        ENTRY(iPos,cAttributeList,CHR(5)), /* List of attributes to set */
        ENTRY(iPos,cEventList,CHR(5))    , /* List of events to set */
        ENTRY(iPos,cDefaultAttrList,CHR(5)) , /* Default values of master */
        ENTRY(iPos,cDefaultEventList,CHR(5)) ,     /* Default events of master */
        cResultCodeList      ).    /* Result Codes */

    /* Add handle to string of already registered objects */
    gcRegisteredObjects = gcRegisteredObjects + (IF gcRegisteredObjects = "" THEN "" ELSE ",") 
                          + ENTRY(iPos,cObjectHandleList).
   END.
END.

hObjectQuery:QUERY-CLOSE().
DELETE OBJECT hObjectQuery NO-ERROR.

/* Delete Attribute and UIEvent Tables */
DELETE OBJECT hObjectBuffer:TABLE-HANDLE NO-ERROR.
DELETE OBJECT hUIEventBuffer:TABLE-HANDLE NO-ERROR.

RUN assignPropertySensitive IN ghPropertySheet
      (INPUT THIS-PROCEDURE, INPUT pcContainerHandle, INPUT "*", INPUT "*",
       INPUT "Name" + CHR(3) + "FieldName":U + CHR(3) + "VisualizationType":U + CHR(3) + "LogicalObjectName":U
             + CHR(3) + "AssignList":U + CHR(3) + "BaseQuery":U + CHR(3) + "DataColumns":U + CHR(3) + "DataColumnsByTable":U
             + CHR(3) + "QueryBuilderFieldDataTypes":U  + CHR(3) + "QueryBuilderDBNames":U + CHR(3) + "QueryBuilderFieldFormatList":U
             + CHR(3) + "QueryBuilderFieldHelp":U + CHR(3) + "QueryBuilderFieldLabelList":U + CHR(3) + "QueryBuilderFieldWidths":U
             + CHR(3) + "QueryBuilderInheritValidations":U + CHR(3) + "QueryBuilderWhereClauses":U + CHR(3) + "Tables":U 
             + CHR(3) + "QueryBuilderJoinCode":U + CHR(3) + "QueryBuilderOptionList":U + CHR(3) + "QueryBuilderOrderList":U 
             + CHR(3) + "QueryBuilderTableOptionList":U + CHR(3) + "QueryBuilderTableList":U + CHR(3) + "QueryBuilderTuneOptions":U 
             + CHR(3) + "QueryBuilderWhereClauses":U +  CHR(3) + "UpdatableColumns":U + CHR(3) + "UpdatableColumnsByTable":U 
             + CHR(3) + "BrowseColumnBGColors":U +  CHR(3) + "BrowseColumnFGColors":U + CHR(3) + "BrowseColumnFonts":U 
             + CHR(3) + "BrowseColumnFormats":U +  CHR(3) + "BrowseColumnLabelBGColors":U + CHR(3) + "BrowseColumnLabelFGColors":U 
             + CHR(3) + "BrowseColumnLabelFonts":U +  CHR(3) + "BrowseColumnLabels":U + CHR(3) + "BrowseColumnWidths":U 
             + CHR(3)  + "DisplayedFields":U +  CHR(3) + "EnabledFields":U ,
       INPUT "",
       INPUT YES).
DYNAMIC-FUNC("setAttributeFirst" IN ghPropertySheet, THIS-PROCEDURE,"NAME").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prop_registerWidget C-Win 
PROCEDURE Prop_registerWidget :
/*------------------------------------------------------------------------------
  Purpose:     Called from register_PropertySheet. Registers static widgets in
               the property sheet.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcContainerHandle AS CHAR   NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectHandle    AS CHAR   NO-UNDO.

DEFINE BUFFER BUFF_P FOR _P.
DEFINE BUFFER BUFF_U FOR _U.
DEFINE BUFFER BUFF_S FOR _S.
DEFINE BUFFER BUFF_L FOR _L.

DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cClass          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttrs          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCodeList AS CHARACTER  NO-UNDO.

ASSIGN hWidget = WIDGET-HANDLE(pcObjectHandle)
       hWindow = WIDGET-HANDLE(pcContainerHandle) 
       NO-ERROR.
IF NOT VALID-HANDLE(hWidget) OR NOT VALID-HANDLE(hWindow) THEN
   RETURN.

FIND BUFF_P WHERE BUFF_P._WINDOW-HANDLE = hWindow NO-ERROR.
/* IF NOT a registered Object (object_type_code = "") then return */
IF NOT AVAILABLE BUFF_P OR BUFF_P.object_type_code = "" OR BUFF_P.OBJECT_FILENAME = "" THEN
   RETURN.

/* Find the  _U record for the passed widget. */
FIND BUFF_U WHERE BUFF_U._HANDLE = hWidget NO-ERROR.
IF NOT AVAILABLE  BUFF_U THEN RETURN.

IF BUFF_U._CLASS-NAME > "" THEN
   ASSIGN cClass = BUFF_U._CLASS-NAME.
ELSE DO:
   IF BUFF_U._TABLE > "" THEN
      cClass = "DataField":U.
   ELSE
   CASE BUFF_U._TYPE:
      WHEN "BROWSE":U THEN
         cClass= "DynBrow":U.
      WHEN "BUTTON":U THEN
         cClass= "DynButton":U.
      WHEN "COMBO-BOX":U THEN
         cClass= "DynComboBox":U.
      WHEN "EDITOR":U THEN
         cClass= "DynEditor":U.
      WHEN "FILL-IN":U THEN
         cClass= "DynFillIn":U.
      WHEN "IMAGE":U THEN
         cClass= "DynImage":U.
      WHEN "RADIO-SET":U THEN
         cClass= "DynRadioSet":U.
      WHEN "RECTANGLE":U THEN
         cClass= "DynRectangle":U.
      WHEN "TEXT":U THEN
         cClass = "DynText":U.
      WHEN "TOGGLE-BOX":U THEN
        cClass = "DynToggle":U.
      WHEN "SELECTION-LIST":U THEN
        cClass = "DynSelection":U.
      WHEN "SMARTOBJECT":U THEN
      DO:
         IF INDEX(BUFF_U._NAME,"DynCombo":U) > 0 THEN
            cClass = "DynCombo":U.
         ELSE IF INDEX(BUFF_U._NAME,"DynLookup":U) > 0 THEN
            cClass = "DynLookup":U.
      END.
      OTHERWISE
         cClass = BUFF_P.OBJECT_TYPE_CODE.
   END CASE.
END.
/* Build list of attributes */
FOR EACH  _U WHERE  _U._WINDOW-HANDLE = hWindow AND _U._HANDLE = hWidget,
     EACH _L WHERE _L._u-recid = RECID(_U) :
   
   ASSIGN cResultCode     =  IF _L._LO-NAME = "Master Layout":U THEN "" ELSE _L._LO-NAME
          cAttrs      = "ROW":U          + CHR(3) + cResultCode + CHR(3) + STRING(MAX(1,_L._ROW)) + CHR(3) + 
                        "COLUMN":U       + CHR(3) + cResultCode + CHR(3) + STRING(MAX(1,_L._COL)) + CHR(3) + 
                        "WIDTH-CHARS":U  + CHR(3) + cResultCode + CHR(3) + STRING(_L._WIDTH)  + CHR(3) + 
                        "HEIGHT-CHARS":U + CHR(3) + cResultCode + CHR(3) + STRING(_L._HEIGHT) + CHR(3) + 
                        "LABEL"          + CHR(3) + cResultCode + CHR(3) + (IF _U._LABEL = ? THEN _U._NAME ELSE _U._LABEL) .
                       

  
  IF LOOKUP(cResultCode,cResultCodeList) = 0 THEN
       cResultCodeList = cResultCodeList + (IF cResultCodeList = "" THEN "" ELSE ",") + cresultCode.

END.

IF LOOKUP(pcObjectHandle,gcRegisteredObjects) = 0 THEN 
DO:
   RUN registerObject IN ghPropertySheet
            (THIS-PROCEDURE,         /* Calling procedure handle */
             pcContainerHandle,      /* Name of container object */
             BUFF_P.OBJECT_FILENAME, /* Label of container */
             pcObjectHandle,         /* Name of object.. same as container */
             IF BUFF_U._TABLE > "" 
             THEN BUFF_U._TABLE + "." + BUFF_U._NAME
             ELSE BUFF_U._NAME,           /* Label of Object */
             cClass,                 /* Class name */
             ""               ,      /* Other supported classes */
             "INSTANCE":U,           /* MASTER or INSTANCE */
             cAttrs,                 /* List of attributes to set */
             "",                     /* List of events to set */
             cAttrs,                 /* Default properties of master */
             "",                     /* Default events of master */
             cResultCodeList) NO-ERROR.    /* Default values of master */


   gcRegisteredObjects = gcRegisteredObjects + (IF gcRegisteredObjects = "" THEN "" ELSE ",") 
                                             + pcObjectHandle.

   RUN assignPropertySensitive IN ghPropertySheet
         (INPUT THIS-PROCEDURE,
          INPUT pcContainerHandle,
          INPUT "*",
          INPUT "*",
          INPUT "Name" + CHR(3) + "FieldName":U + CHR(3) + "VisualizationType":U + CHR(3) + "LogicalObjectName":U,
          INPUT "",
          INPUT YES).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prop_SynchProperties C-Win 
PROCEDURE Prop_SynchProperties :
/*------------------------------------------------------------------------------
  Purpose:     Synchs up the object properties with the dynamic properties
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE i                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cResultCode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttribute               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSmartSetting            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClassName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindow                  AS HANDLE     NO-UNDO.
/* DynSDO variables */
DEFINE VARIABLE cTables                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAssignList              AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cUpdatableColumns        AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cDataColumns             AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cDataColumnsByTable      AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBFieldDataTypes        AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQbFieldDBNames          AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBFieldFormats          AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBFieldHelp             AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBFieldLabels           AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBFieldWidths           AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBInhVals               AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cQBJoinCode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQBWhereClauses          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstanceColumns         AS CHARACTER  NO-UNDO INIT ?.
DEFINE VARIABLE cBaseQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSkipJoin                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lSkipWhere               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cQueryParse              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lTmp                     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTmp                     AS CHARACTER  NO-UNDO.
/* DynBrow variables */
DEFINE VARIABLE cBrowseFields            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColBGColors         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColFGColors         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColFonts            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColFormats          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColLabelBGColors    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColLabelFGColors    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColLabelFonts       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColLabels           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrwsColWidths           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRecID                   AS RECID      NO-UNDO.

IF _h_cur_widg = ? OR NOT VALID-HANDLE(ghPropertySheet) THEN 
   RETURN.

ASSIGN hWidget = _h_cur_widg.
IF LOOKUP(String(_h_cur_widg),gcRegisteredObjects) = 0 THEN
      hWidget = _h_win.

/* Field Buffer */
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER f_L FOR _L.
DEFINE BUFFER f_F FOR _F.
DEFINE BUFFER f_C FOR _C.
DEFINE BUFFER f_S FOR _S.

/* Query Buffers */
DEFINE BUFFER q_U FOR _U.
DEFINE BUFFER q_C FOR _C.
DEFINE BUFFER q_Q FOR _Q.

FIND f_U WHERE f_U._HANDLE = hWidget NO-ERROR.

IF AVAILABLE f_U THEN 
DO:
   ASSIGN hWindow = f_U._WINDOW-HANDLE.
   FIND f_L WHERE RECID(f_L)  = f_U._lo-recid NO-ERROR.
   FIND f_F WHERE RECID(f_F)  = f_U._x-recid NO-ERROR.
   FIND f_S WHERE RECID(f_S)  = f_U._x-recid NO-ERROR.
   FIND f_C WHERE RECID(f_C)  = f_U._x-recid NO-ERROR.
   FIND _P  WHERE _P._WINDOW-HANDLE =  f_U._WINDOW-HANDLE NO-ERROR. 
END.

cClassName = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT _P._TYPE).
IF cClassName = "" THEN
   cClassname = _P._TYPE.
IF cClassName = "DynBrow":U THEN
DO:
   /* Find the Browse _U record */
   FIND f_U WHERE f_U._WINDOW-HANDLE =  hWindow
                AND f_U._TYPE        = "BROWSE" NO-ERROR. 
   FIND f_C WHERE RECID(f_C)  = f_U._x-recid NO-ERROR.
   FIND f_L WHERE RECID(f_L)  = f_U._lo-recid NO-ERROR.
   RUN collectBrowseColumns( INPUT RECID(f_U),
                             OUTPUT cBrowseFields,
                             OUTPUT cEnabledFields,
                             OUTPUT cBrwsColBGColors,
                             OUTPUT cBrwsColFGColors,
                             OUTPUT cBrwsColFonts,
                             OUTPUT cBrwsColFormats,
                             OUTPUT cBrwsColLabelBGColors,
                             OUTPUT cBrwsColLabelFGColors,
                             OUTPUT cBrwsColLabelFonts,
                             OUTPUT cBrwsColLabels,
                             OUTPUT cBrwsColWidths).
END.
ELSE IF cClassName = "DynSDO":U AND AVAILABLE q_Q AND AVAILABLE q_U THEN 
DO:
      /* Find the _U of the query record */
   FIND q_U WHERE q_U._WINDOW-HANDLE =  f_U._WINDOW-HANDLE
              AND q_U._TYPE          = "QUERY":U NO-ERROR.
   IF AVAILABLE q_U THEN
   DO:
     FIND q_C WHERE RECID(q_C)  = q_U._x-recid NO-ERROR.
     FIND q_Q WHERE RECID(q_Q)  = q_C._q-recid NO-ERROR.
   END.

   RUN ConstructTableList(INPUT RECID(q_U), INPUT RECID(f_U), INPUT q_Q._TblList, OUTPUT cTables).
   RUN BuildSDOFieldListsByTable 
                         (INPUT RECID(q_U),
                          INPUT  cTables,
                          OUTPUT cAssignList,
                          OUTPUT cUpdatableColumnsByTable,
                          OUTPUT cDataColumnsByTable).

    /* Build cDataColumns, cUpdateableColumns and other lists necessary for SDOs to be read
       back into the AppBuilder from the repository                                         */
   RUN BuildSDOSimpleLists(INPUT RECID(q_U),
                           OUTPUT cDataColumns,
                           OUTPUT cUpdatableColumns,
                           OUTPUT cInstanceColumns,
                           OUTPUT cQBFieldDataTypes,
                           OUTPUT cQBFieldDBNames,
                           OUTPUT cQBFieldFormats,
                           OUTPUT cQBFieldHelp,
                           OUTPUT cQBFieldLabels,
                           OUTPUT cQBFieldWidths,
                           OUTPUT cQBInhVals).

   /* Build Query Builder internal lists */
   DO i = 1 TO NUM-ENTRIES(q_Q._TblList):
      ASSIGN cQBJoinCode     = cQBJoinCode + (IF cQBJoinCode = "" THEN "" ELSE CHR(5)) + 
                                  (IF q_Q._JoinCode[i] = ? THEN "?":U ELSE q_Q._JoinCode[i])
             cQBWhereClauses = cQBWhereClauses + (IF cQBWhereClauses = "" THEN "" ELSE CHR(5))+ 
                                  (IF q_Q._Where[i] = ? THEN "?":U ELSE q_Q._Where[i]).
      IF  q_Q._JoinCode[i] = ? THEN
         lSkipJoin  = YES.
      IF q_Q._Where[i] = ? THEN
         lSkipWhere = YES.
   END. /* Do i = 1 to num-tables */
    
   IF lSkipJoin THEN
      cQBJoinCode = "":U.
   IF lSKipWhere THEN
      cQBWhereClauses = "":U.

    /* Need to strip DB name from base query so that query-prepare can handle it */
   cBaseQuery = "FOR":U.
   DO i = 1 TO NUM-ENTRIES(q_Q._4GLQury," ":U):
      cQueryParse = ENTRY(i, q_Q._4GLQury, " ":U).
      IF NUM-ENTRIES(cQueryParse,".":U) = 2 AND
        LOOKUP(ENTRY(1, cQueryParse, ".":U), cQBFieldDBNames) > 0 THEN 
          cQueryParse = ENTRY(2, cQueryParse, ".":U).
      IF NUM-ENTRIES(cQueryParse,".":U) = 3 AND
        LOOKUP(ENTRY(1, cQueryParse, ".":U), cQBFieldDBNames) > 0 THEN
          cQueryParse = ENTRY(2, cQueryParse, ".":U) + ".":U + ENTRY(3, cQueryParse, ".":U).
      cBaseQuery = cBaseQuery + " ":U + cQueryParse.
   END.
END. /* End DynSDO IF available _Q */
ELSE IF cClassNAME = "DynView":U AND AVAILABLE f_U THEN  
DO:
  IF f_U._TYPE = "WINDOW":U THEN
  DO:
     cRecid = RECID(f_U).
     FIND f_U WHERE F_U._TYPE = "FRAME":U 
                AND F_U._PARENT-RECID = cRecid NO-ERROR.
     IF AVAILABLE f_U THEN
        FIND f_C WHERE RECID(f_C)  = f_U._x-recid NO-ERROR.
  END.
END.
IF AVAIL f_U THEN
    ASSIGN cResultCode = IF f_U._LAYOUT-NAME = "Master Layout":U
                         THEN ""
                         ELSE f_U._LAYOUT-NAME.
   
ASSIGN hBuffer     = DYNAMIC-FUNCTION("getBuffer":U IN ghPropertySheet, "ttAttribute":U).
       
CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME + " WHERE " 
                      + hBuffer:NAME + ".callingProc = '":U + STRING(THIS-PROCEDURE) + "' AND ":U 
                      + hBuffer:NAME + ".containerName = '":U + STRING(_h_win) + "' AND ":U
                      + hBuffer:NAME + ".resultCode = '":U + cResultCode + "' AND ":U
                      + hBuffer:NAME + ".objectName = '":U + STRING(hWidget) + "'" ).
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
DO WHILE hBuffer:AVAILABLE:
   ASSIGN cLabel      = hBuffer:BUFFER-FIELD("attrLabel":U):BUFFER-VALUE
          cResultCode = hBuffer:BUFFER-FIELD("ResultCode":U):BUFFER-VALUE.
   IF AVAILABLE f_S THEN
      cSmartSetting = getSmartSetting(f_S._SETTINGS, cLabel).
   ELSE
      cSmartSetting = ?.
   IF cResultCode > "" THEN
     CASE cLabel:
       WHEN "BGColor":U          THEN 
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._BGCOLOR) THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._BGColor = ? THEN "?" ELSE string(f_L._BGCOLOR)).  
       WHEN "BOX":U              THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) = f_L._NO-BOX AND f_L._NO-BOX <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(NOT f_L._NO-BOX,"yes/no":U).  
       WHEN "COLUMN":U           THEN
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._COL) AND f_L._COL <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._COL).  
       WHEN "CONVERT-3D-COLORS":U THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._CONVERT-3D-COLORS AND f_L._CONVERT-3D-COLORS <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._CONVERT-3D-COLORS,"yes/no":U).  
       WHEN "EDGE-PIXELS":U      THEN 
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._EDGE-PIXELS) AND f_L._EDGE-PIXELS <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._EDGE-PIXEL).  
      WHEN "FGCOLOR":U          THEN 
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_L._FGCOLOR) THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._FGColor = ? THEN "?" ELSE string(f_L._FGCOLOR)).    
      WHEN "FILLED":U           THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._FILLED AND f_L._FILLED <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._FILLED,"yes/no":U).  
     WHEN "FONT":U             THEN 
         IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <>  STRING(f_L._FONT)  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_L._FONT = ? THEN "?" ELSE string(f_L._FONT)).    
     WHEN "GRAPHIC-EDGE":U     THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._GRAPHIC-EDGE  AND f_L._GRAPHIC-EDGE <> ?  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._GRAPHIC-EDGE,"yes/no":U).  
     WHEN "HEIGHT-CHARS":U THEN
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._HEIGHT)  AND f_L._HEIGHT <> ?  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._HEIGHT).  
     WHEN "LABEL":U  OR WHEN "ColumnLabel"THEN
         IF AVAILABLE f_U AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> f_U._LABEL  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + (IF f_U._LABEL = ? THEN f_U._NAME ELSE f_U._LABEL).  
     WHEN "LABELS":U           THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) = f_L._NO-LABELS  AND f_L._NO-LABELS <> ?  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(NOT f_L._NO-LABELS,"yes/no":U).  
     WHEN "NO-FOCUS":U         THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._NO-FOCUS AND f_L._NO-FOCUS <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._NO-FOCUS,"yes/no":U).  
     WHEN "ROW":U               THEN
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._ROW) AND f_L._ROW <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._ROW).  
     WHEN "SEPARATOR-FGCOLOR":U THEN
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._SEPARATOR-FGCOLOR) AND f_L._SEPARATOR-FGCOLOR <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + STRING(f_L._SEPARATOR-FGCOLOR).  
     WHEN "SEPARATORS":U        THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <> f_L._SEPARATORS AND f_L._SEPARATORS <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._SEPARATORS,"yes/no":U).  
     WHEN "THREE-D":U          THEN 
         IF AVAILABLE f_L AND isValueLogical(hBuffer) <>  f_L._3-D AND  f_L._3-D <> ?  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._3-D,"yes/no":U). 
     WHEN "WIDTH-CHARS":U THEN
         IF AVAILABLE f_L AND hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> STRING(f_L._WIDTH)  AND f_L._WIDTH <> ?  THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + string(f_L._WIDTH).  

     END CASE.
   ELSE
     CASE cLabel:
       /* Include file for all mapped properties */
       {adeuib/abmbarprop.i}
       /* SmartObject Properties */
       OTHERWISE DO:
         IF hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE <> cSmartSetting   AND cSmartSetting <> ? THEN
            cAttribute = cAttribute + CHR(3) + cLabel + CHR(3) + cResultCode + CHR(3) + cSmartSetting. 
       END.
     END CASE.
   
   hQuery:GET-NEXT().
END.
cAttribute = LEFT-TRIM(cAttribute,CHR(3)).

RUN assignPropertyValues IN ghPropertySheet
      (INPUT THIS-PROCEDURE, 
       INPUT STRING(_h_win),
       INPUT STRING(hWidget),
       INPUT cAttribute,
       INPUT "",
       INPUT YES ).

DELETE OBJECT hQuery.


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
    
    RUN ry/prc/rycsolnchp.p (INPUT "afgenobjsw":U , INPUT YES , INPUT YES ) NO-ERROR.

    RETURN.
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
  DEFINE INPUT  PARAMETER pMenu      AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE         h_mitem    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE         cLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE         lStatic    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE         lContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE         lSaved     AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic    = IsStaticObject()
         lStatic    = IF lStatic = ? THEN NO ELSE lStatic.
  ASSIGN lContainer = IsContainerObject().
  ASSIGN lSaved     = IsSaved().

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
              ASSIGN h_mitem:SENSITIVE = lStatic OR (lContainer AND lSaved).
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
  
  ASSIGN lStatic = IsStaticObject()
         lStatic = IF lStatic = ? THEN NO ELSE lStatic.

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
  
  DEFINE VARIABLE h_mitem      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabel       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lStatic      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCanConv     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSupportsDLP AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSupportsCSP AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic  = IsStaticObject()
         lStatic  = IF lStatic = ? THEN NO ELSE lStatic
         lCanConv = CanConvertFromToDynamic()
         lSupportsDLP = hasDataLogicProc()
         lSupportsCSP = hasCustomSuperProc()
         NO-ERROR.

  /* Process menu-items. */
  ASSIGN h_mitem = pMenu:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_mitem):
      /* Assign No-Error skips items that don't have labels. */
      ASSIGN cLabel = ?.
      ASSIGN cLabel = h_mitem:LABEL NO-ERROR.
      CASE cLabel:
          WHEN MENU-ITEM m_open_procedure:LABEL IN MENU m_file THEN
          DO:
         /* If DynSDO or DynSBO then change label to Data Logic Procedure. If DynView,DynBrow 
            then change to "Custom Super Procedure' */
             IF lSupportsDLP THEN
                ASSIGN h_mitem:LABEL      = "Open Data Logic Proce&dure"
                        h_mitem:SENSITIVE = TRUE.
             ELSE IF lSupportsCSP THEN
                ASSIGN h_mitem:LABEL     = "Open Custom Super Proce&dure"
                       h_mitem:SENSITIVE = TRUE.
             ELSE
               ASSIGN h_mitem:LABEL =  "Open Associated Procedure"
                      h_mitem:SENSITIVE = FALSE.
             ASSIGN MENU-ITEM m_open_procedure:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.

          END.
          WHEN MENU-ITEM m_close:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_close:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_close_all:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_close_all:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_save:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save_all:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_save_all:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_save_as:LABEL IN MENU m_file THEN
              ASSIGN MENU-ITEM m_save_as:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
          WHEN MENU-ITEM m_Save_As_Object:LABEL IN MENU m_file THEN 
          DO:
             /* If dynamic existing object, set label to Save Dynamic AS Static,
                if static object, change label to Save Static As Dynamic */
             ASSIGN h_mitem:SENSITIVE = lCanConv
                    MENU-ITEM m_save_as_object:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE.
             IF lCanConv THEN
                h_mitem:LABEL =  IF lStatic THEN "Save Static O&bject As Dynamic"
                                            ELSE "Save Dynamic O&bject As Static".
             ELSE   h_mitem:LABEL = "Save As O&bject".

          END.
          WHEN MENU-ITEM m_print:LABEL IN MENU m_file THEN
              /* You cannot perform this option on a dynamic repository object. */
              ASSIGN h_mitem:SENSITIVE = lStatic
                     MENU-ITEM m_print:SENSITIVE IN MENU m_file = h_mitem:SENSITIVE
                     _h_button_bar[4]:SENSITIVE = h_mitem:SENSITIVE. /* print button */
      END CASE.
      /* Get the next menu-item. */
      h_mitem = h_mitem:NEXT-SIBLING.
  END.

  /* Can we perform a register to repos? */
  ASSIGN MENU-ITEM m_Reg_in_Repos:SENSITIVE IN MENU m_file = CanAddtoRepos().

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
  
  ASSIGN lStatic = IsStaticObject()
         lStatic = IF lStatic = ? THEN NO ELSE lStatic.

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
  
  DEFINE VARIABLE  h_mitem        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE  cLabel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE  lStatic        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCanSetDPS      AS LOGICAL    NO-UNDO.
  
  ASSIGN lStatic = IsStaticObject()
         lCanSetDPS = CanSetDPS().
  
  ASSIGN pMenu   = MENU m_Options:HANDLE
         pMenu   = pMenu:NEXT-SIBLING   /* Layout menu  */ 
         pMenu   = pMenu:NEXT-SIBLING  /* Windows menu */
         h_mitem = pMenu:FIRST-CHILD. /* Code Section Edit option */

  /* You cannot perform this option on a dynamic repository object. */
  ASSIGN h_mitem:SENSITIVE = IF lStatic = ? THEN NO ELSE lStatic /* edit menu item */
        _h_button_bar[7]:SENSITIVE = IF lStatic = ? THEN NO ELSE lStatic. /* edit button */

  ASSIGN mi_dynproperties:SENSITIVE   = IF lCanSetDPS THEN TRUE ELSE FALSE
         DynProperty_Button:SENSITIVE = mi_dynproperties:SENSITIVE 
         NO-ERROR.
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unregister_PropertySheet C-Win 
PROCEDURE unregister_PropertySheet :
/*------------------------------------------------------------------------------
  Purpose:     Unregisters the object in the Property Sheet
  Parameters:  pcContainerName   Name of container to unregister
               pcObjectName      Name of object to unregister
                                 IF "*", unregisters all objects in container
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcContainerName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName    AS CHARACTER  NO-UNDO.

 DEFINE BUFFER BUFF_U FOR _U.
 DEFINE BUFFER BUFF_P FOR _P.

 DEFINE VARIABLE hWindow               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hWidget               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjects              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cNewRegisteredObjects AS CHARACTER  NO-UNDO.

 ASSIGN hWindow = WIDGET-HANDLE(pcContainerName) NO-ERROR.
 IF NOT VALID-HANDLE(hWindow) THEN RETURN.
 IF pcObjectName <> "*" THEN 
 DO:
    ASSIGN hWidget = WIDGET-HANDLE(pcObjectName) NO-ERROR.
    IF NOT VALID-HANDLE(hWindow) THEN RETURN.
 END.
    
 IF NOT VALID-HANDLE(ghPropertySheet) THEN
    RUN Load_propertySheet IN THIS-PROCEDURE NO-ERROR.

 RUN unregisterObject IN ghPropertySheet (THIS-PROCEDURE,pcContainerName,pcObjectName) NO-ERROR.
 RUN destroyObject IN ghPropertySheet NO-ERROR.

 IF pcObjectName = "*":U THEN
 FOR EACH BUFF_U WHERE BUFF_U._WINDOW-HANDLE = hWindow:
     cObjects = cObjects + (IF cObjects = "" THEN "" ELSE ",") + STRING(BUFF_U._HANDLE).
 END.
 ELSE
    cObjects = pcObjectName.

 DO iloop = 1 TO NUM-ENTRIES(gcRegisteredObjects):
    /* Do not include those objects that are being unregistered */
    IF LOOKUP(ENTRY(iLoop,gcRegisteredObjects),cObjects) > 0  THEN
      NEXT.

   cNewRegisteredObjects = cNewRegisteredObjects + (IF cNewRegisteredObjects = "" THEN "" ELSE ",")
                                               + ENTRY(iloop,gcRegisteredObjects).
 END.

 ASSIGN gcRegisteredObjects = cNewRegisteredObjects.

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
  DEFINE BUFFER   local_P     FOR _P.

  DEFINE VARIABLE lCanAdd         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSavedPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName       AS CHARACTER  NO-UNDO.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  IF NOT AVAIL local_P  THEN RETURN FALSE.

  /* Can only add files that are:
        - Not in repository and that are titled (not untitled).
        - Not include-only files
  */
  ASSIGN lCanAdd = (local_P.design_ryobject = NO AND local_P._SAVE-AS-FILE <> ?) AND
                   (NOT CAN-DO("i":U, local_P._file-type)).

  /* Don't call cacheObjectOnClient if there is a compiler error currently.
     it wipes out the COMPILER:FILE-OFFSET need to position the cursor */
  IF COMPILER:FILE-OFFSET NE ? THEN lCanAdd = FALSE.

  /* Check whether object is already registered in repository. If a static file 
     was opened, we need to test it */
  IF lCanAdd THEN
  DO:
    RUN adecomm/_osprefx.p (INPUT local_P._SAVE-AS-FILE, OUTPUT cSavedPath, OUTPUT cFileName).
    IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                          INPUT ENTRY(1,cFilename,"."),  /* Strip off the extension */
                          INPUT "", /* Get all Result Codes */
                          INPUT "",  /* RunTime Attributes not applicable in design mode */
                          INPUT YES  /* Design Mode is yes */
                       )  THEN
       ASSIGN lCanAdd  = FALSE.
    
    ELSE IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                             INPUT cFilename,  /* Try with extension */
                             INPUT "", /* Get all Result Codes */
                             INPUT "",  /* RunTime Attributes not applicable in design mode */
                             INPUT YES  /* Design Mode is yes */
                          )  THEN
       ASSIGN lCanAdd   = FALSE.
  
  END.
  
    
   ASSIGN NO-ERROR. /* Clear Error status. */
  
  RETURN lCanAdd.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CanConvertFromToDynamic C-Win 
FUNCTION CanConvertFromToDynamic RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P        FOR _P.
  DEFINE VARIABLE   lCanConvert    AS LOGICAL    NO-UNDO.

  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  IF AVAILABLE local_P THEN DO:
    IF local_P.static_object THEN  /* Going from static to dynamic */
      ASSIGN lCanConvert = LOOKUP(local_P._TYPE,
                         "SmartDataViewer,SmartViewer,SmartDataBrowser,SmartBrowser,SmartDataObject":U) > 0
                         AND LOOKUP("NEW":U,local_P.design_action) = 0.
    ELSE  /* Going from Dynamic to Static (Limit the choices for now) */
      ASSIGN lCanConvert = LOOKUP(local_P._TYPE,
         /* IZ 9851 & 9855 "SmartDataViewer,SmartViewer,SmartDataBrowser,SmartBrowser,SmartDataObject":U) > 0 */
                         "SmartDataViewer,SmartViewer":U) > 0
                         AND LOOKUP("NEW":U,local_P.design_action) = 0.
    
  END. /* If available local_P */
                         

  RETURN lCanConvert.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canSetDPS C-Win 
FUNCTION canSetDPS RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P       FOR _P.
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.

  IF AVAILABLE local_P THEN DO:
    IF (local_P.product_module_code > "" AND local_P.smartObject_obj > 0)
       OR (local_P.product_module_code > "" AND NOT local_P.static_object )THEN
       RETURN TRUE.
    ELSE 
       RETURN FALSE.

  END.
  ELSE
    RETURN FALSE.   /* Function return value. */
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeMasterValue C-Win 
FUNCTION getAttributeMasterValue RETURNS CHARACTER
  ( phAttributeBuffer AS HANDLE,
    plisMaster        AS LOG,
    pcResultCode      AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds the attribute list 
    Notes:  Called form prop_register procedure.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAttributes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLevel       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRunTimeList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSystemList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cvalue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hColumn      AS HANDLE     NO-UNDO.

IF phAttributeBuffer:AVAILABLE THEN
DO: 
  /* Attribute settings are returned as lists of field numbers */ 
  ASSIGN
    cRunTimeList = phAttributeBuffer:BUFFER-FIELD("tRuntimeList":U):BUFFER-VALUE
    cSystemList  = phAttributeBuffer:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE NO-ERROR.

  DO iColumn = 1 TO phAttributeBuffer:NUM-FIELDS:
    /* Skip runtime attributes */
    IF CAN-DO(cRunTimeList,STRING(iColumn)) THEN
      NEXT.
     /* Skip system attributes  */
    IF CAN-DO(cSystemList,STRING(iColumn)) THEN
      NEXT.
    ASSIGN
      hColumn =  phAttributeBuffer:BUFFER-FIELD(iColumn)
      cName =    hColumn:NAME
      cValue =   IF hColumn:BUFFER-VALUE = ? THEN "?" ELSE STRING(hColumn:BUFFER-VALUE)
      NO-ERROR.
    ASSIGN iLevel = INT(trim(ENTRY(iColumn,phAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE))) NO-ERROR.
    IF iLevel = 3 THEN
      cAttributes = cAttributes + (IF cAttributes = "" THEN "" ELSE CHR(3))
                        + cName + CHR(3) 
                        + (IF pcResultCode = "{&DEFAULT-RESULT-CODE}":U THEN "" ELSE pcResultCode) + CHR(3) 
                        + cValue.
  END. /* END DO iColumns = 1 to.. */
END.   /* End If phAttributeBuffer:Avail */

RETURN cAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValue C-Win 
FUNCTION getAttributeValue RETURNS CHARACTER
  ( phAttributeBuffer AS HANDLE,
    plisMaster        AS LOG,
    pcResultCode      AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds the attribute list 
    Notes:  Called form prop_register procedure.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAttributes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLevel       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRunTimeList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSystemList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cvalue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hColumn      AS HANDLE     NO-UNDO.


IF phAttributeBuffer:AVAILABLE THEN
   DO: 
     /* Attribute settings are returned as lists of field numbers */ 
     ASSIGN
       cRunTimeList = phAttributeBuffer:BUFFER-FIELD("tRuntimeList":U):BUFFER-VALUE
       cSystemList  = phAttributeBuffer:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE NO-ERROR.

     DO iColumn = 1 TO phAttributeBuffer:NUM-FIELDS:
       /* Skip runtime attributes */
       IF CAN-DO(cRunTimeList,STRING(iColumn)) THEN
         NEXT.
        /* Skip system attributes  */
       IF CAN-DO(cSystemList,STRING(iColumn)) THEN
         NEXT.
       ASSIGN
         hColumn =  phAttributeBuffer:BUFFER-FIELD(iColumn)
         cName =    hColumn:NAME
         cValue =   IF hColumn:BUFFER-VALUE = ? THEN "?" ELSE STRING(hColumn:BUFFER-VALUE)
         NO-ERROR.
         
       ASSIGN iLevel = INT(trim(ENTRY(iColumn,phAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE))) NO-ERROR.
       IF (iLevel >= 5 AND NOT plIsMaster) OR (iLevel >= 3 AND plIsMaster)  THEN
         cAttributes = cAttributes + (IF cAttributes = "" THEN "" ELSE CHR(3))
                     + cName + CHR(3) 
                     + (IF pcResultCode = "{&DEFAULT-RESULT-CODE}":U THEN "" ELSE pcResultCode) + CHR(3) 
                     + cValue.
     END. /* END DO iColumns = 1 to.. */
   END.   /* End If phAttributeBuffer:Avail */
   
  RETURN cAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertySheetBuffer C-Win 
FUNCTION getPropertySheetBuffer RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghPropertySheet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSmartSetting C-Win 
FUNCTION getSmartSetting RETURNS CHARACTER
  ( pcSetting AS CHAR,pcattr AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttribute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcSetting, CHR(3)):
    ASSIGN cEntry = ENTRY(iLoop,pcSetting, CHR(3))
           cAttribute = ENTRY(1,cEntry,CHR(4))
           cValue     = ENTRY(2,cEntry,CHR(4))
           NO-ERROR.
    IF cAttribute = pcAttr THEN
       RETURN cValue.

  END.
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasCustomSuperProc C-Win 
FUNCTION hasCustomSuperProc RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether the current design window  has an associated
           custom super procedure
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_U       FOR _U.
  DEFINE BUFFER     local_C       FOR _C.
  
  
  FIND local_U WHERE local_U._HANDLE = _h_win NO-ERROR.
  IF AVAILABLE local_U THEN
     FIND local_C WHERE RECID(local_C)  = local_U._x-recid NO-ERROR.
  
  IF AVAILABLE local_C AND local_C._CUSTOM-SUPER-PROC > "" THEN
     RETURN TRUE.
  ELSE
     RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasDataLogicProc C-Win 
FUNCTION hasDataLogicProc RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether the current design window  has an associated
           datalogic procedure
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_U       FOR _U.
  DEFINE BUFFER     local_C       FOR _C.
  
  
  FIND local_U WHERE local_U._HANDLE = _h_win NO-ERROR.
  IF AVAILABLE local_U THEN
     FIND local_C WHERE RECID(local_C)  = local_U._x-recid NO-ERROR.
  
  IF AVAILABLE local_C AND local_C._DATA-LOGIC-PROC > "" THEN
     RETURN TRUE.
  ELSE
     RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasObjectType C-Win 
FUNCTION hasObjectType RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P       FOR _P.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.

  IF AVAILABLE local_P THEN DO:
    RETURN local_P.object_type_code > "".
  END.
  ELSE
    RETURN FALSE.   /* Function return value. */

  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsSaved C-Win 
FUNCTION IsSaved RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER     local_P     FOR _P.
  DEFINE VARIABLE   lSaved      AS LOGICAL    NO-UNDO.
  
  FIND local_P WHERE local_P._WINDOW-HANDLE = _h_win NO-ERROR.
  IF AVAILABLE local_P THEN DO:
    /* If the proeprty sheet has never been established, then this
       was just read and not changed so it is equivalent to being saved */
    IF NOT VALID-HANDLE(local_P.design_hpropsheet) AND
       local_P.design_propsheet_file NE "":U THEN
      ASSIGN lSaved = TRUE.
    /* If the property sheet is running, then ask if anything has been modified */
    ELSE IF VALID-HANDLE(local_P.design_hpropsheet) THEN
      lSaved = NOT DYNAMIC-FUNCTION('isModified':U IN local_P.design_hpropsheet) 
               NO-ERROR.
  END.

  RETURN lSaved.   /* Function return value. */

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
  
  IF AVAILABLE local_P THEN
    ASSIGN lStatic = local_P.static_object NO-ERROR.
  ELSE
     lStatic = ?.

  RETURN lStatic.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isValueLogical C-Win 
FUNCTION isValueLogical RETURNS LOGICAL
  ( phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF phBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE = "true":U
      OR phBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE = "yes":U THEN
    RETURN TRUE.   /* Function return value. */
  ELSE
   RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSmartSetting C-Win 
FUNCTION setSmartSetting RETURNS LOGICAL
   ( prRecid AS recid,
     pcAttribute AS CHAR,
     pcValue     AS CHAR ) :
 /*------------------------------------------------------------------------------
   Purpose: Sets values in the smartObject properties _S._SETTINGS 
     Notes:  
 ------------------------------------------------------------------------------*/
   DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAttribute AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

   DEFINE BUFFER f_S FOR _S.

   FIND f_S WHERE RECID(f_S) = prRecid NO-ERROR.
   
   IF AVAILABLE f_S THEN
   DO:
     DO iLoop = 1 TO NUM-ENTRIES(f_S._SETTINGS, CHR(3)):
       ASSIGN cEntry = ENTRY(iLoop,f_S._SETTINGS, CHR(3))
              cAttribute = trim(ENTRY(1,cEntry,CHR(4)))
              cValue     = trim(ENTRY(2,cEntry,CHR(4)))
              NO-ERROR.
       IF cAttribute = pcAttribute THEN 
       DO:
          ASSIGN ENTRY(2,cEntry,CHR(4))            = pcValue
                 ENTRY(iLoop,f_S._SETTINGS,CHR(3)) = cEntry.
          RETURN TRUE.

       END. /* End found attribute */
     END. /* End loop through _SETTINGS */
   END.   /* End if available */
   
   RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

