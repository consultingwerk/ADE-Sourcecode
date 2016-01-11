&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME h_sewin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS h_sewin 
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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/******************************************************************************

Procedure: _semain.w

Syntax   :
       RUN adeuib/_semain.w SET hSecEd.

Purpose  :          
    UIB Section Editor Window.

Description:
    This PROGRESS procedure is the UIB's Section Editor Window. It is
    RUN PERSISTENT by the UIB code. There is no WAIT-FOR or other blocking
    statement in this program.
       
Parameters:
Notes :

Author: John Palazzo

Date  : January,  1995
Last  : November, 1995

*****************************************************************************/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Direct all dialogs usng okbar.i to be 3D. */
&SCOPED-DEFINE USE-3D    YES
&GLOBAL-DEFINE WIN95-BTN YES

/* Section Editor Preprocessor Defines. */
&GLOBAL-DEFINE  SE_Name         "Section Editor"
&GLOBAL-DEFINE  SE_Title_Leader "Section Editor - "
&GLOBAL-DEFINE  SE_Untitled     "Untitled"


/* Create an unnamed pool to store all the widgets created by this procedure.
   This is a good default which assures that this procedure's triggers and
   internal procedures will execute in this procedure's storage, and that
   proper cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives     */
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

{adecomm/_adetool.i}       /* Identify as an ADE Tool Persistent Proc.  */
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */
{web/method/cgidefs.i NEW} /* WebSpeed stream, global definitions       */

/* ====================================================================== */
/*                        TEMP TABLE Definitions                          */
/* ====================================================================== */
{adeuib/uniwidg.i  }       /* Universal Widget TEMP-TABLE definition      */
{adeuib/brwscols.i }       /* Temp-Table definition of browse column info */
{adeuib/triggers.i }       /* Trigger TEMP-TABLE definition               */
{adecomm/tt-brws.i NEW }   /* Temp-Table Support in UIB                   */
{web/method/tagmap.i NEW } /* WebSpeed HTML offsets temp-table            */

DEFINE TEMP-TABLE _SEW NO-UNDO
       FIELD _psection  AS CHARACTER
       FIELD _precid    AS RECID
       FIELD _pevent    AS CHARACTER
       FIELD _TRG_Recid AS RECID
       FIELD _U_Recid   AS RECID
       FIELD _hwin      AS WIDGET-HANDLE.

DEFINE BUFFER _SEW_U   FOR _U.
DEFINE BUFFER _SEW_F   FOR _F.
DEFINE BUFFER _SEW_TRG FOR _TRG.
DEFINE BUFFER _SEW_BC  FOR _BC.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/sharvars.i }  /* UIB Shared Variables                 */
{adeuib/std_dlg.i}    /* Standard UIB stuff for dialog boxes  */

/* Needed by _inscall.w and _inscal8.w when running web/objects/web-util.p
   persistenly for V9.x Web objects. Also defined in web/objects/web-disp.p
   and web/objects/web-util.p.  Need to centralize this. */
DEFINE NEW SHARED VARIABLE transaction-state AS CHARACTER NO-UNDO.
DEFINE NEW SHARED VARIABLE server-connection AS CHARACTER NO-UNDO.

/* Editor Popup Menu Definitions                                        */
&SCOPED-DEFINE ED_POPUP     "SE_POPUP":u
/* These provide editor functionality */
{adecomm/dedit.i}    /* Edit Defines */
{adecomm/pedit.i}    /* Edit Procedures */

/* SEARCH_ALL enables the Search All Sections capability via adecomm routines. */
&SCOPED-DEFINE SEARCH_ALL   "SE_SEARCH_ALL":u
{adecomm/dsearch.i}  /* Search Defines */
{adecomm/psearch.i}  /* Search Procedures */

/* Query Builder shared functionality. */
{adeshar/quryshar.i "NEW GLOBAL"}

&Scoped-define DEBUG FALSE

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "~r" + &ENDIF CHR(10)

DEFINE VAR v_h          AS WIDGET                                NO-UNDO.
               /* Handle of a generic widget                               */
DEFINE VAR h_win_trig   AS WIDGET                                NO-UNDO.
               /* Handle of window for the triggers and code               */
DEFINE VAR win_recid    AS RECID                                 NO-UNDO.
               /* RECID of window for the triggers and code                */
DEFINE VAR h_first_obj  AS WIDGET                                NO-UNDO.
               /* Handle of first object that can have a trigger.          */
DEFINE VAR dummy        AS LOGICAL                               NO-UNDO.
               /* Temp logical necessitated by ADD_FIRST function.         */
DEFINE VAR h_Editor     AS WIDGET                                NO-UNDO.
               /* Handle of Trigger Code editor.                           */               
DEFINE VAR editted_event   AS CHAR                               NO-UNDO.
               /* The most recent event name entered by the user.          */
DEFINE VAR recent_trig     AS CHAR                               NO-UNDO.
               /* The most recent control event examined.                  */
DEFINE VAR recent_proc     AS CHAR                               NO-UNDO.
               /* The most recent procedure block examined.                */
DEFINE VAR recent_func     AS CHAR                               NO-UNDO.
               /* The most recent function  block examined.                */
DEFINE VAR recent_recid    AS RECID                              NO-UNDO.
               /* The most recent control recid examined.                  */
               
/* These variables are used in the Field Schema Picker and are saved
   between calls to it. */
DEFINE VAR Schema_Database AS CHAR                               NO-UNDO.
               /* Name of most recently viewed database.                   */
DEFINE VAR Schema_Prefix   AS INTEGER INITIAL 2                  NO-UNDO.
               /* Type of prefix to use in schema picker (2 = all)         */
DEFINE VAR Schema_Table    AS CHAR                               NO-UNDO.
               /* Name of most recently viewed table.                      */

DEFINE VAR _SEW-recid      AS RECID                              NO-UNDO.
               /* The record id of either _SEW_U or _SEW_BC which ever is  */
               /* currently available - there should only be one of them.  */

DEFINE VAR Definitions      AS CHARACTER INIT "Definitions"         NO-UNDO.
DEFINE VAR Libraries        AS CHARACTER INIT "Included Libraries"  NO-UNDO.
DEFINE VAR Trigs            AS CHARACTER INIT "Triggers"            NO-UNDO.
DEFINE VAR Main_Block       AS CHARACTER INIT "Main Block"          NO-UNDO.
DEFINE VAR Procedures       AS CHARACTER INIT "Procedures"          NO-UNDO.
DEFINE VAR Functions        AS CHARACTER INIT "Functions"           NO-UNDO.

DEFINE VAR Type_Definitions AS CHARACTER INIT "_DEFINITIONS"        NO-UNDO.
DEFINE VAR Type_Trigger     AS CHARACTER INIT "_CONTROL"            NO-UNDO.
DEFINE VAR Type_Libraries   AS CHARACTER INIT "_INCLUDED-LIBRARIES" NO-UNDO.
DEFINE VAR Type_Main_Block  AS CHARACTER INIT "_MAIN-BLOCK"         NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "_PROCEDURE"          NO-UNDO.
DEFINE VAR Type_Function    AS CHARACTER INIT "_FUNCTION"           NO-UNDO.
DEFINE VAR Type_Local       AS CHARACTER INIT "_LOCAL"              NO-UNDO.

/* These procedure name definitions and the Type definitions below them
   must correspond to the template definitions in adeshar/_coddflt.p.
   - jep 04/94
*/
DEFINE VAR UIB_Procedures   AS CHARACTER NO-UNDO
                            INIT
"adm-create-objects,adm-row-available,enable_UI,disable_UI,send-records".
DEFINE VAR Adm_Create_Obj       AS CHARACTER INIT "adm-create-objects"  NO-UNDO.
DEFINE VAR Adm_Row_Avail        AS CHARACTER INIT "adm-row-available"   NO-UNDO.
DEFINE VAR Enable_UI            AS CHARACTER INIT "enable_UI"           NO-UNDO.
DEFINE VAR Disable_UI           AS CHARACTER INIT "disable_UI"          NO-UNDO.
DEFINE VAR Send_Records         AS CHARACTER INIT "send-records"        NO-UNDO.
DEFINE VAR Type_Adm_Create_Obj  AS CHARACTER INIT "_ADM-CREATE-OBJECTS" NO-UNDO.
DEFINE VAR Type_Adm_Row_Avail   AS CHARACTER INIT "_ADM-ROW-AVAILABLE"  NO-UNDO.
DEFINE VAR Type_Def_Enable      AS CHARACTER INIT "_DEFAULT-ENABLE"     NO-UNDO.
DEFINE VAR Type_Def_Disable     AS CHARACTER INIT "_DEFAULT-DISABLE"    NO-UNDO.
DEFINE VAR Type_Send_Records    AS CHARACTER INIT "_ADM-SEND-RECORDS"   NO-UNDO.
DEFINE VAR Smart_Prefix         AS CHARACTER INIT "adm-"                NO-UNDO.
DEFINE VAR Local_Prefix         AS CHARACTER INIT "local-"              NO-UNDO.
DEFINE VAR SE_Created           AS LOGICAL                              NO-UNDO.
DEFINE VAR h_mbar               AS HANDLE                               NO-UNDO.
DEFINE VAR h_frame              AS HANDLE                               NO-UNDO.

/* Standard OK buttons                                                */
DEFINE BUTTON btn_help       LABEL "&Help"               {&STDPH_OKBTN} .
DEFINE BUTTON btn_ok         LABEL "OK"     AUTO-GO      {&STDPH_OKBTN} .
/* We need a normal (ENDKEY) cancel button for some dialogs, and a Not-ENDkey
   one for the section editor [Because CANCEL only undoes one change, not
   the whole transaction] */        
DEFINE BUTTON btn_cancel     LABEL "Cancel" AUTO-ENDKEY  {&STDPH_OKBTN} .
DEFINE BUTTON btn_not_ok     LABEL "Cancel"              {&STDPH_OKBTN} .

/* Rectangles to color screen */
&IF {&OKBOX} &THEN
DEF RECTANGLE bar2  {&STDPH_OKBOX}.
&ENDIF

DEFINE STREAM   msgs.

/* *************************** Picklist FRAME ****************************** */
/* These dialogs should go in UIB .w files. */

/* Single Picklist */
DEFINE VAR s_PickList AS CHAR NO-UNDO
   VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SORT
           SIZE 64 BY 9.
           
/* Multiple Picklist */
DEFINE VAR m_PickList AS CHAR NO-UNDO
   VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL SORT
           SIZE 64 BY 9 
           FONT 0.  /* Use fixed font because this is multiple column */
   
DEFINE FRAME f_pick       /* Layout the frame for the widget selection list */
      SKIP ({&TFM_WID})
      SPACE({&HFM_WID}) s_PickList SPACE({&HFM_WID})
      m_PickList   AT ROW-OF s_PickList COLUMN-OF s_PickList
      { adecomm/okform.i 
         &BOX    = bar2
         &OK     = btn_ok
         &CANCEL = btn_cancel
         &HELP   = btn_help }
   WITH NO-LABELS VIEW-AS DIALOG-BOX THREE-D DEFAULT-BUTTON btn_ok.

/* Standard run-time layout */
{ adecomm/okrun.i 
       &FRAME  = "FRAME f_pick"
       &BOX    = bar2
       &OK     = btn_ok
       &HELP   = btn_help }

/* Standard CLOSE action = END-ERROR */
ON WINDOW-CLOSE OF FRAME f_pick APPLY "END-ERROR":U TO SELF.

/* In this frame, always go on a dbl-click selection */
ON DEFAULT-ACTION OF s_PickList, m_PickList DO:
  APPLY "GO":U TO FRAME f_pick.
END.

/* *********************** New Procedure FRAME *******************************/
/* Frame and var definitions for out pick list dialog box. */
DEFINE VAR new_name  AS CHAR NO-UNDO LABEL "Name" FORMAT "X(40)" {&STDPH_FILL} .
DEFINE VAR proc_type AS CHAR NO-UNDO.

/* *********************** Rename FRAME **************************************/
DEFINE FRAME f_rename    /* Layout the frame for the rename dlg. */
       SKIP ({&TFM_WID})
       SPACE({&HFM_WID})  new_name  SKIP ({&VM_WIDG})
      { adecomm/okform.i 
         &BOX    = bar2
         &OK     = btn_ok
         &CANCEL = btn_cancel
         &HELP   = btn_help }
   WITH SIDE-LABELS VIEW-AS DIALOG-BOX THREE-D
        DEFAULT-BUTTON btn_ok CANCEL-BUTTON btn_cancel
        TITLE "Rename".

/* Standard run-time layout */
{ adecomm/okrun.i 
       &FRAME  = "FRAME f_rename"
       &BOX    = bar2
       &OK     = btn_ok
       &HELP   = btn_help }

/* Standard CLOSE action = END-ERROR */
ON WINDOW-CLOSE OF FRAME f_rename APPLY "END-ERROR":U TO SELF.

/* Help for this Frame */
ON CHOOSE OF btn_help IN FRAME f_rename OR HELP OF FRAME f_rename
  RUN adecomm/_adehelp.p
                ("AB", "CONTEXT", {&Rename_Procedure_Dlg_Box}  , "").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_edit

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS isection btn_List btn_Pcall db_required ~
private_block se_event btn_New btn_Rename wname txt 
&Scoped-Define DISPLAYED-OBJECTS isection db_required private_block ~
se_event wname txt read_only 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR h_sewin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mnu_File 
       MENU-ITEM m_Print_Section LABEL "&Print Section"
       MENU-ITEM m_Close        LABEL "&Close Window" .

DEFINE SUB-MENU m_Format_Menu1 
       MENU-ITEM m_EditIndent   LABEL "&Indent"       
       MENU-ITEM m_EditUnindent LABEL "&Unindent"     
       MENU-ITEM m_EditComment  LABEL "&Comment"      
       MENU-ITEM m_EditUncomment LABEL "Unc&omment"    .

DEFINE SUB-MENU mnu_Edit 
       MENU-ITEM m_EditUndo     LABEL "&Undo"          ACCELERATOR "CTRL-Z"
       MENU-ITEM m_EditRevert   LABEL "Undo &All..."  
       RULE
       MENU-ITEM m_EditCut      LABEL "Cu&t"           ACCELERATOR "CTRL-X"
       MENU-ITEM m_EditCopy     LABEL "&Copy"          ACCELERATOR "CTRL-C"
       MENU-ITEM m_EditPaste    LABEL "&Paste"         ACCELERATOR "CTRL-V"
       RULE
       MENU-ITEM m_EditDelete   LABEL "&Delete..."    
       RULE
       SUB-MENU  m_Format_Menu1 LABEL "&Format Selection".

DEFINE SUB-MENU mnu_Insert 
       MENU-ITEM m_InsertDBFields LABEL "&Database Fields..."
       MENU-ITEM m_InsertEventName LABEL "&Event Name..."
       MENU-ITEM m_InsertProcCall LABEL "Procedure &Call..."
       MENU-ITEM m_InsertPreprocessorName LABEL "&Preprocessor Name..."
       MENU-ITEM m_InsertQuery  LABEL "&Query..."     
       MENU-ITEM m_InsertWidgetName LABEL "&Object Name..."
       RULE
       MENU-ITEM m_InsertFile   LABEL "&File Contents..."
       MENU-ITEM m_InsertFileName LABEL "File &Name..." .

DEFINE SUB-MENU mnu_Search 
       MENU-ITEM m_Find         LABEL "&Find..."       ACCELERATOR "CTRL-F"
       MENU-ITEM m_Find_Next    LABEL "Find &Next"     ACCELERATOR "F9"
       MENU-ITEM m_Find_Prev    LABEL "Find &Previous" ACCELERATOR "SHIFT-F9"
       MENU-ITEM m_Replace      LABEL "&Replace.."     ACCELERATOR "CTRL-R".

DEFINE SUB-MENU mnu_Compile 
       MENU-ITEM m_Cmp_Check_Syntax LABEL "&Check Syntax"  ACCELERATOR "SHIFT-F2".

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_Contents     LABEL "&Help Topics"  
       MENU-ITEM m_Tool_Help    LABEL "&Section Editor Help" ACCELERATOR "F1"
       RULE
       MENU-ITEM m_Messages     LABEL "M&essages..."  
       MENU-ITEM m_Recent_Messages LABEL "&Recent Messages...".

DEFINE MENU mnb_SectionEd MENUBAR
       SUB-MENU  mnu_File       LABEL "&File"         
       SUB-MENU  mnu_Edit       LABEL "&Edit"         
       SUB-MENU  mnu_Insert     LABEL "&Insert"       
       SUB-MENU  mnu_Search     LABEL "&Search"       
       SUB-MENU  mnu_Compile    LABEL "&Compile"      
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_List 
     LABEL "&List..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON btn_New 
     LABEL "&New..." 
     SIZE 11 BY 1.14.

DEFINE BUTTON btn_Pcall 
     LABEL "Inser&t Call..." 
     SIZE 18 BY 1.14.

DEFINE BUTTON btn_Rename 
     LABEL "&Rename..." 
     SIZE 18 BY 1.14.

DEFINE VARIABLE isection AS CHARACTER FORMAT "X(256)":U 
     LABEL "Section" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Definitions","Triggers","Main Block","Procedures","Functions" 
     DROP-DOWN-LIST
     SIZE 31 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE se_event AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "ON" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 31 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE wname AS CHARACTER FORMAT "X(256)":U 
     LABEL "OF" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 30 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE txt AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 20000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 86 BY 17.24
     FONT 2 NO-UNDO.

DEFINE VARIABLE read_only AS LOGICAL FORMAT "Read-Only/Edit-Mode":U INITIAL NO 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE db_required AS LOGICAL INITIAL no 
     LABEL "&DB-Required" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE private_block AS LOGICAL INITIAL no 
     LABEL "&Private" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_edit
     isection AT ROW 1.33 COL 8 COLON-ALIGNED
     btn_List AT ROW 1.33 COL 41.6
     btn_Pcall AT ROW 1.33 COL 53
     db_required AT ROW 1.48 COL 72
     private_block AT ROW 1.48 COL 72
     se_event AT ROW 2.52 COL 8 COLON-ALIGNED
     btn_New AT ROW 2.52 COL 41.6
     btn_Rename AT ROW 2.52 COL 53
     wname AT ROW 2.52 COL 55 COLON-ALIGNED
     txt AT ROW 3.67 COL 1 NO-LABEL
     read_only AT ROW 2.62 COL 76 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.86 BY 19.96.


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
  CREATE WINDOW h_sewin ASSIGN
         HIDDEN             = YES
         TITLE              = "Section Editor"
         HEIGHT             = 19.95
         WIDTH              = 87.8
         MAX-HEIGHT         = 19.95
         MAX-WIDTH          = 87.8
         VIRTUAL-HEIGHT     = 19.95
         VIRTUAL-WIDTH      = 87.8
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mnb_SectionEd:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT h_sewin:LOAD-ICON("adeicon/uib%":U) THEN
    MESSAGE "Unable to load icon: adeicon/uib%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW h_sewin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f_edit
                                                                        */
ASSIGN 
       FRAME f_edit:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN read_only IN FRAME f_edit
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       read_only:HIDDEN IN FRAME f_edit           = TRUE.

/* SETTINGS FOR COMBO-BOX se_event IN FRAME f_edit
   SHARED                                                               */
ASSIGN 
       txt:AUTO-INDENT IN FRAME f_edit      = TRUE
       txt:RETURN-INSERTED IN FRAME f_edit  = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(h_sewin)
THEN h_sewin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME h_sewin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON END-ERROR OF h_sewin /* Section Editor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON ENTRY OF h_sewin /* Section Editor */
DO:
  DEFINE VARIABLE WinHandle       AS WIDGET-HANDLE NO-UNDO.

  /* Set current design window to the one for this section editor. (jep) */
  /* 20000604-003 & 19981020-031. (jep) */
  RUN check_UIB_current_window.

  /* Move design window to top. (jep) */
  IF AVAILABLE _P AND VALID-HANDLE(_P._WINDOW-HANDLE) THEN
  DO:
    ASSIGN WinHandle = _P._WINDOW-HANDLE.
    /* If design window is a dialog box, we need its window handle. */
    IF WinHandle:TYPE <> "WINDOW":u THEN
      ASSIGN WinHandle = WinHandle:WINDOW.
    WinHandle:MOVE-TO-TOP() NO-ERROR.
    /* Leave the section editor window on topmost, since it was just clicked.
       19991018-046 (jep ) */
    h_sewin:MOVE-TO-TOP() NO-ERROR.
  END.

  /* Set the global setting for current section editor to this one. (jep) */
  RUN call_sew_setHandle IN _h_uib (THIS-PROCEDURE:HANDLE).
  
  /* Set se_event and se_section to their current values for this SE instance. 
     19990907-029 (dma) */
  /* Updated to first try and use _SEW record values instead of screen values to
     set current values. I left screen value usage in as a fallback. Preserves the
     fix this code was placed here for (19990907-029) and fixes (19991012-027)
     where se_event was being set to ? when using the screen value to set it.
     That's why _SEW is preferred. (jep) */
  IF AVAILABLE _SEW THEN
  DO:
    ASSIGN
      isection   = isection:SCREEN-VALUE IN FRAME f_edit
      se_event   = _SEW._pevent
      se_recid   = _SEW._precid
      se_section = _SEW._psection.
  END.
  ELSE
  DO:
    ASSIGN
      isection   = isection:SCREEN-VALUE IN FRAME f_edit
      se_event   = se_event:SCREEN-VALUE IN FRAME f_edit
                   WHEN se_event:SCREEN-VALUE IN FRAME f_edit <> ?
      se_section = IF ( isection = Trigs       ) THEN Type_Trigger
              ELSE IF ( isection = Procedures  ) THEN Type_Procedure
              ELSE IF ( isection = Functions   ) THEN Type_Function
              ELSE IF ( isection = Definitions ) THEN Type_Definitions
              ELSE IF ( isection = Libraries   ) THEN Type_Libraries
              ELSE                                    Type_Main_Block.
  END.

  /* Put checkmark next to this SE instance on the Window menu. (dma) */
  IF VALID-HANDLE(_h_WinMenuMgr) AND VALID-HANDLE(_h_win) THEN
    RUN WinMenuSetActive IN _h_WinMenuMgr (_h_WindowMenu, h_sewin:TITLE).

  RUN setToolTip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON WINDOW-CLOSE OF h_sewin /* Section Editor */
DO:
  RUN SEClose ( INPUT "SE_CLOSE":u ).
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON WINDOW-RESIZED OF h_sewin /* Section Editor */
DO:
  RUN adeuib/_seresz.p ( INPUT {&WINDOW-NAME} ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_List
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_List h_sewin
ON CHOOSE OF btn_List IN FRAME f_edit /* List... */
DO:
  RUN ListBlocks.
  RUN setToolTip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_New
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_New h_sewin
ON CHOOSE OF btn_New IN FRAME f_edit /* New... */
DO:
  RUN NewBlock.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Pcall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Pcall h_sewin
ON CHOOSE OF btn_Pcall IN FRAME f_edit /* Insert Call... */
DO:
  RUN InsertProcName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Rename
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Rename h_sewin
ON CHOOSE OF btn_Rename IN FRAME f_edit /* Rename... */
DO:
  RUN RenameProc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME isection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL isection h_sewin
ON VALUE-CHANGED OF isection IN FRAME f_edit /* Section */
DO:
  RUN ChangeSection ( INPUT SELF:SCREEN-VALUE ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mnu_Edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mnu_Edit h_sewin
ON MENU-DROP OF MENU mnu_Edit /* Edit */
OR MENU-DROP OF MENU mnu_EdPopup
DO:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":u &THEN
  /* Is it the Section Editor Edit menu drop or popup menu? */
  IF SELF = MENU {&SELF-NAME}:HANDLE THEN RUN se_emdrp.
  ELSE RUN EdPopupDrop (INPUT txt:HANDLE IN FRAME f_edit).
  &ELSE
  RETURN NO-APPLY.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Close h_sewin
ON CHOOSE OF MENU-ITEM m_Close /* Close Window */
DO:
  RUN SEClose ( INPUT "SE_CLOSE":u ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cmp_Check_Syntax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cmp_Check_Syntax h_sewin
ON CHOOSE OF MENU-ITEM m_Cmp_Check_Syntax /* Check Syntax */
OR CHOOSE OF MENU-ITEM m_Check_Syntax
DO:
  RUN CheckSyntax.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents h_sewin
ON CHOOSE OF MENU-ITEM m_Contents /* Help Topics */
DO:
  RUN adecomm/_adehelp.p 
      ( INPUT "AB":u , INPUT "TOPICS":u ,
        INPUT {&Section_Editor_Contents} , INPUT ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditComment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditComment h_sewin
ON CHOOSE OF MENU-ITEM m_EditComment /* Comment */
OR CHOOSE OF MENU-ITEM m_Comment
DO:
  RUN CommentSelection ( h_Editor, YES ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditCopy h_sewin
ON CHOOSE OF MENU-ITEM m_EditCopy /* Copy */
OR CHOOSE OF MENU-ITEM m_Copy
DO:
  RUN EditCopy ( h_Editor ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditCut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditCut h_sewin
ON CHOOSE OF MENU-ITEM m_EditCut /* Cut */
OR CHOOSE OF MENU-ITEM m_Cut
DO:
  RUN EditCut ( h_Editor ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditDelete h_sewin
ON CHOOSE OF MENU-ITEM m_EditDelete /* Delete... */
DO:
  RUN DeleteBlock.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditIndent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditIndent h_sewin
ON CHOOSE OF MENU-ITEM m_EditIndent /* Indent */
OR CHOOSE OF MENU-ITEM m_Indent
DO:
  RUN ApplyTab ( h_Editor, YES ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditPaste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditPaste h_sewin
ON CHOOSE OF MENU-ITEM m_EditPaste /* Paste */
OR CHOOSE OF MENU-ITEM m_Paste
DO:
  RUN EditPaste ( h_Editor ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditRevert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditRevert h_sewin
ON CHOOSE OF MENU-ITEM m_EditRevert /* Undo All... */
DO:
  RUN UndoChange.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditUncomment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditUncomment h_sewin
ON CHOOSE OF MENU-ITEM m_EditUncomment /* Uncomment */
OR CHOOSE OF MENU-ITEM m_UnComment
DO:
  RUN CommentSelection ( h_Editor, NO ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditUndo h_sewin
ON CHOOSE OF MENU-ITEM m_EditUndo /* Undo */
DO:
  RUN EditUndo (txt:HANDLE IN FRAME {&FRAME-NAME}).
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_EditUnindent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_EditUnindent h_sewin
ON CHOOSE OF MENU-ITEM m_EditUnindent /* Unindent */
OR CHOOSE OF MENU-ITEM m_UnIndent
DO:
    RUN ApplyBackTab ( h_Editor, YES ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Find
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Find h_sewin
ON CHOOSE OF MENU-ITEM m_Find /* Find... */
DO:
  RUN FindText( INPUT h_Editor ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Find_Next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Find_Next h_sewin
ON CHOOSE OF MENU-ITEM m_Find_Next /* Find Next */
DO:
  RUN FindNext ( INPUT h_Editor , INPUT Find_Criteria ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Find_Prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Find_Prev h_sewin
ON CHOOSE OF MENU-ITEM m_Find_Prev /* Find Previous */
DO:
  RUN FindPrev ( INPUT h_Editor , INPUT Find_Criteria ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertDBFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertDBFields h_sewin
ON CHOOSE OF MENU-ITEM m_InsertDBFields /* Database Fields... */
OR CHOOSE OF MENU-ITEM m_DB_Fields
DO:
  RUN InsertDBFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertEventName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertEventName h_sewin
ON CHOOSE OF MENU-ITEM m_InsertEventName /* Event Name... */
OR CHOOSE OF MENU-ITEM m_Event_Name
DO:
  RUN InsertEventName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertFile h_sewin
ON CHOOSE OF MENU-ITEM m_InsertFile /* File Contents... */
OR CHOOSE OF MENU-ITEM m_File_Contents
DO:
  RUN insert_file ("CONTENTS":U, txt:HANDLE in frame {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertFileName h_sewin
ON CHOOSE OF MENU-ITEM m_InsertFileName /* File Name... */
OR CHOOSE OF MENU-ITEM m_File_Name
DO:
  RUN insert_file ("NAME":U, txt:HANDLE IN FRAME f_edit).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertPreprocessorName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertPreprocessorName h_sewin
ON CHOOSE OF MENU-ITEM m_InsertPreprocessorName /* Preprocessor Name... */
OR CHOOSE OF MENU-ITEM m_Preprocessor_Name
DO:
  RUN InsertPreProcName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertProcCall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertProcCall h_sewin
ON CHOOSE OF MENU-ITEM m_InsertProcCall /* Procedure Call... */
OR CHOOSE OF MENU-ITEM m_Procedure_Call
DO:
  RUN InsertProcName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertQuery h_sewin
ON CHOOSE OF MENU-ITEM m_InsertQuery /* Query... */
OR CHOOSE OF MENU-ITEM m_Query
DO:
  RUN InsertQuery.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_InsertWidgetName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_InsertWidgetName h_sewin
ON CHOOSE OF MENU-ITEM m_InsertWidgetName /* Object Name... */
OR CHOOSE OF MENU-ITEM m_Object_Name
DO:
  RUN InsertWidgetName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Messages
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Messages h_sewin
ON CHOOSE OF MENU-ITEM m_Messages /* Messages... */
DO:
  RUN prohelp/_msgs.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Print_Section
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Print_Section h_sewin
ON CHOOSE OF MENU-ITEM m_Print_Section /* Print Section */
DO:
  RUN PrintSection.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Recent_Messages
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Recent_Messages h_sewin
ON CHOOSE OF MENU-ITEM m_Recent_Messages /* Recent Messages... */
DO:
  RUN prohelp/_rcntmsg.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Replace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Replace h_sewin
ON CHOOSE OF MENU-ITEM m_Replace /* Replace.. */
DO:
  DEFINE VAR Sect-List     AS CHAR    NO-UNDO.
  DEFINE VAR Sect-Curr     AS CHAR    NO-UNDO.
  DEFINE VAR Sect-First    AS CHAR    NO-UNDO.
  DEFINE VAR Replace_All   AS LOGI    NO-UNDO.
  DEFINE VAR Found_One     AS LOGI    NO-UNDO. /* True if found an occurrence. */
  DEFINE VAR Done_Msg      AS CHAR    NO-UNDO.
  DEFINE VAR Num_Replaced  AS INTEGER NO-UNDO.

  DO ON STOP UNDO, LEAVE:
    RUN ReplaceText ( INPUT h_Editor ).

    /* Search_All is defined in adecomm/dsearch.i. */
    IF (Search_All = NO) OR (RETURN-VALUE BEGINS "_CANCEL":U) THEN
    DO:
        ASSIGN Search_All = NO. /* If not reset, could affect Find/Find Next/Prev. */
        RETURN.
    END.
    ASSIGN Num_Replaced = h_Editor:NUM-REPLACED.
    
    ASSIGN Replace_All = (RETURN-VALUE BEGINS "_REPLACE-ALL":U).
    ASSIGN Found_One = (INDEX(RETURN-VALUE, "yes":U) > 0).
    IF Replace_All THEN
        ASSIGN Done_Msg = "Replace All complete for all sections.".
    ELSE
        ASSIGN Done_Msg = "Replace complete for all sections.".
  
    RUN GetSearchAllList
         (INPUT  h_win_trig, INPUT se_section, INPUT _SEW-recid, INPUT se_event,
          OUTPUT Sect-List , OUTPUT Sect-Curr).

    IF NUM-ENTRIES(Sect-List) = 1 THEN
    DO:
      MESSAGE Done_Msg Num_Replaced "occurrences replaced."
        VIEW-AS ALERT-BOX INFORMATION IN WINDOW h_sewin.
      LEAVE.
    END.
    ASSIGN Sect-First = Sect-Curr.
    
    DO WHILE TRUE:
        RUN NextSearchBlock (INPUT Sect-List, INPUT Sect-First, INPUT-OUTPUT Sect-Curr).
        CASE RETURN-VALUE:
            WHEN "_CANCEL":U THEN LEAVE.
            WHEN "_DONE":U OR WHEN "_NOT-FOUND":U THEN
            DO:
                IF RETURN-VALUE = "_DONE":U OR Found_One THEN
                DO:
                    IF Replace_All THEN
                        ASSIGN Done_Msg = Done_Msg + " " +
                                          STRING(Num_Replaced) + " " + "occurrences replaced.".
                    MESSAGE Done_Msg
                            VIEW-AS ALERT-BOX INFORMATION IN WINDOW h_sewin.
                END.
                ELSE
                    MESSAGE "Find text not found in any section."
                            VIEW-AS ALERT-BOX INFORMATION IN WINDOW h_sewin.
                LEAVE.
            END.
        END CASE.
        IF NOT Replace_All THEN
            RUN ReplaceConfirm (INPUT h_Editor).
        ELSE
        DO:
            RUN ReplaceAll (INPUT h_Editor).
            ASSIGN Num_Replaced = Num_Replaced + h_Editor:NUM-REPLACED.
        END.
        IF RETURN-VALUE BEGINS "_CANCEL":U THEN LEAVE.
    END.
  END.
  ASSIGN Search_All = NO. /* If not reset, could affect Find/Find Next/Prev. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tool_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tool_Help h_sewin
ON CHOOSE OF MENU-ITEM m_Tool_Help /* Section Editor Help */
DO:
/*    Help:
 *     Display window help if no text is selected. If text is selected.
 *     you receive syntax help.
 */
  RUN se_help (INPUT 0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME se_event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL se_event h_sewin
ON VALUE-CHANGED OF se_event IN FRAME f_edit /* ON */
DO:
  DEFINE VAR ok2change     AS LOGICAL NO-UNDO.
  DEFINE VAR new_event     AS CHAR    NO-UNDO.
  /* If the number of words > 1, then only use the first word */
  new_event = se_event:SCREEN-VALUE.
  IF NUM-ENTRIES(new_event, " ") > 1 
  THEN DO:
       ASSIGN new_event = ENTRY(1,new_event, " ")
              se_event:SCREEN-VALUE = new_event.
  END.
  RUN change_trg (se_section, _SEW-recid, new_event, 
                  yes, yes, OUTPUT ok2change).
  /* in case user decided not to change trg */
  IF NOT ok2change THEN se_event:SCREEN-VALUE = editted_event.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt h_sewin
ON BACK-TAB OF txt IN FRAME f_edit
DO:
 /*--------------------------------------------------------------------------
    Purpose:    Put a Progress standard back-tab into an editor field.
  ---------------------------------------------------------------------------*/
  RUN ApplyBackTab( txt:HANDLE , NO ).
  RETURN NO-APPLY. /* Bypass regular tab handling */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt h_sewin
ON TAB OF txt IN FRAME f_edit
OR CTRL-TAB OF txt
DO:
 /*--------------------------------------------------------------------------
    Purpose:    Put a Progress standard tab into an editor field.
  ---------------------------------------------------------------------------*/
  RUN ApplyTab( txt:HANDLE , NO ).
  RETURN NO-APPLY. /* Bypass regular tab handling */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wname
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wname h_sewin
ON VALUE-CHANGED OF wname IN FRAME f_edit /* OF */
DO:
 /*--------------------------------------------------------------------------
    Purpose:    If an item has been selected from the name list, then remove
                the label which should be on the same line and redisplay.
  ---------------------------------------------------------------------------*/

  DEFINE VAR ok2change  AS LOGICAL NO-UNDO.
  DEFINE VAR new_wname  AS CHAR    NO-UNDO.
  DEFINE BUFFER ipU     FOR _U.

  DO WITH FRAME f_edit:
    /* Get the new widget name, but keep showing the old one */
    /* This gets around a "feature" in the combo-box.        */
    new_wname = ENTRY(1, wname:SCREEN-VALUE, " ").
    
    RUN setToolTip.
    
    /* Get this new widget */
    IF LOOKUP("Column>", wname:SCREEN-VALUE," ":U) = 0 THEN DO:
      /* Check that the object is not a database field. Database fields
         in the Section Editor wname combo-box display as
         "dbname.table.field Label"
      */
      IF INDEX(new_wname , ".") = 0 THEN
        FIND ipU WHERE ipU._NAME = new_wname AND
                       ipU._WINDOW-HANDLE = h_win_trig  NO-ERROR.
      ELSE
        FIND ipU WHERE ipU._NAME   = ENTRY(3, new_wname, ".")
                   AND ipU._DBNAME = ENTRY(1, new_wname, ".")
                   AND ipU._TABLE  = ENTRY(2, new_wname, ".") 
                   AND ipU._WINDOW-HANDLE = h_win_trig  NO-ERROR.

      IF AVAILABLE ipU
      THEN RUN change_trg ("_CONTROL", RECID(ipU), editted_event,
                           FALSE, TRUE,
                           OUTPUT ok2change).
    END. /* If NOT a BROWSE COLUMN */       
    
    ELSE DO:  /* Handle the browse column */
      FIND ipU WHERE ipU._NAME = ENTRY(1,ENTRY(2,wname:SCREEN-VALUE,"<":U)," ":U) AND
                     ipU._WINDOW-HANDLE = h_win_trig NO-ERROR.
      IF AVAILABLE ipU THEN DO:
        FIND _BC WHERE _BC._x-recid = RECID(ipU)
                   AND _BC._DISP-NAME = ENTRY(1,wname:SCREEN-VALUE,"<":U) NO-ERROR.
        IF AVAILABLE _BC THEN
          RUN change_trg("_CONTROL", RECID(_BC), editted_event,
                          FALSE, TRUE,
                          OUTPUT ok2change).
      END.
    END. /* End of Browse Column Case */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK h_sewin 


/* ***************************  Main Block  *************************** */
RUN init-win.
RUN set_vars.
RUN initial_adjustments.

ON GO OF FRAME f_rename
DO:
  DEFINE VARIABLE a_ok              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Invalid_List      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Smart_List        AS CHARACTER NO-UNDO.

  ASSIGN new_name:SCREEN-VALUE = TRIM(new_name:SCREEN-VALUE).
  IF new_name:SCREEN-VALUE = se_event:SCREEN-VALUE IN FRAME f_edit THEN RETURN.
  RUN adecomm/_valpnam.p
      (INPUT  new_name:SCREEN-VALUE, INPUT TRUE, INPUT "_INTERNAL":U,
       OUTPUT a_ok).
  IF a_ok
  THEN DO:
    /* Make sure name is not already defined (other than itself). */
    /* Get procedure names of a) all procedures and b) ADM SmartMethod
       subset. Both take care of procedures defined in the current object
       as well as Included Libraries. */
    RUN Get_Proc_Lists
        (INPUT YES, OUTPUT Invalid_List , OUTPUT Smart_List).
    ASSIGN a_ok = NOT CAN-DO(Invalid_List, new_name:SCREEN-VALUE).
    IF NOT a_ok THEN DO:
      MESSAGE new_name:SCREEN-VALUE SKIP(1)
             "A procedure or function already has this name." 
              VIEW-AS ALERT-BOX WARNING IN WINDOW h_sewin.
    END.
  END.
  IF NOT a_ok THEN 
  DO:
    APPLY "ENTRY":U TO new_name.
    RETURN NO-APPLY.
  END.
END.


/* Editor Popup Keyword Help trigger. */
ON CHOOSE OF MENU-ITEM m_Keyword_Help /* Keyword Help */
DO:
  RUN se_help (INPUT ?).
END.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN SEClose ( INPUT "SE_EXIT":u ).

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* If Webspeed Workshop-only, then change UIB image to Workshop image */
IF _AB_License = 2 THEN DO:
  IF NOT h_sewin:LOAD-ICON("adeicon/workshp%":U) THEN
    MESSAGE "Unable to load icon: adeicon/workshp%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
  DO:
    RUN enable_UI.
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.
END.

/* Include the other Section Editor internal procedures. */
{adeuib/_seprocs.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI h_sewin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(h_sewin)
  THEN DELETE WIDGET h_sewin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI h_sewin  _DEFAULT-ENABLE
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
  DISPLAY isection db_required private_block se_event wname txt read_only 
      WITH FRAME f_edit IN WINDOW h_sewin.
  ENABLE isection btn_List btn_Pcall db_required private_block se_event btn_New 
         btn_Rename wname txt 
      WITH FRAME f_edit IN WINDOW h_sewin.
  VIEW FRAME f_edit IN WINDOW h_sewin.
  {&OPEN-BROWSERS-IN-QUERY-f_edit}
  VIEW h_sewin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-win h_sewin 
PROCEDURE init-win :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ldummy    AS LOGICAL NO-UNDO.
  
  ASSIGN
    {&WINDOW-NAME}:PARENT         = _h_menu_win
    {&WINDOW-NAME}:PRIVATE-DATA   = "{&UIB_SHORT_NAME}"
    {&WINDOW-NAME}:NAME           = {&SE_Name}
    {&WINDOW-NAME}:TITLE          = {&SE_Title_Leader} + {&SE_Untitled}
    {&WINDOW-NAME}:MIN-WIDTH      = 1 /* Zero is not acceptable to UIM. */
    {&WINDOW-NAME}:MIN-HEIGHT     = 1 /* Zero is not acceptable to UIM. */
    
    /* For Motif, make the menubar's Help option a Motif-Style Help item. */
    MENU m_Help:SUB-MENU-HELP     = TRUE
    .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initial_adjustments h_sewin 
PROCEDURE initial_adjustments :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adj_height  AS DECIMAL NO-UNDO.
               /* Adjustment factor for window height. */
  DEFINE VARIABLE adj_width   AS DECIMAL NO-UNDO.

  DEFINE VARIABLE vDef_Win    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE vSEW_Height AS INTEGER NO-UNDO.
  DEFINE VARIABLE scm_ok      AS LOGICAL NO-UNDO.


  DO WITH FRAME {&FRAME-NAME}:
  
  RUN SetEditor (INPUT txt:HANDLE).   /* adecomm/peditor.i */

  /* Use ADE Standards for Editor widget. */
  ASSIGN txt:FONT       = editor_font
         txt:BGCOLOR    = std_ed4gl_bgcolor
         txt:FGCOLOR    = std_ed4gl_fgcolor
         /* Add the popup menu to editor widget. */
         txt:POPUP-MENU = MENU mnu_EdPopup:HANDLE.

  /* Center Read-Only text widget to the wname combo-box. */
  ASSIGN read_only:ROW = read_only:ROW +
                        (wname:HEIGHT - read_only:HEIGHT) / 2.0.

  /* Set height to approx. 1/3 of screen height, and a little less in 640x480. */
  IF (SESSION:HEIGHT-PIXELS <= 480) THEN
     ASSIGN h_sewin:HEIGHT-PIXELS =  (SESSION:HEIGHT-PIXELS * 0.60).
  ELSE
     ASSIGN h_sewin:HEIGHT-PIXELS = (SESSION:HEIGHT-PIXELS * 0.67).

  /* Move the DB-Required check box to the right of the Private check box. */
  ASSIGN db_required:COL = (private_block:COL + private_block:WIDTH + 3).

  /* Set width of window to 85 characters wide for editor font. We use the
     MAX function to be sure we don't shrink the window smaller than its
     original size. That causes scrollbars to sprout.
     
     Also, db_required can wind up too far right to fit in the frame,
     especially with large fonts. Take that into account when calculating
     the adjusted width of the window.  -jep
  */
  ASSIGN adj_width     = MAX(h_sewin:WIDTH-PIXELS , db_required:X + db_required:WIDTH-PIXELS)
         h_sewin:WIDTH = FONT-TABLE:GET-TEXT-WIDTH(FILL("0", 85), editor_font)
         h_sewin:WIDTH-PIXELS = MAX(adj_width, h_sewin:WIDTH-PIXELS).

  /* Resize the frame and editor areas to fit the window. */
  RUN adeuib/_seresz.p (INPUT h_sewin).
  
  /* When there's room, increase the width of the Object combo-box. */
  ASSIGN wname:WIDTH-PIXELS = (txt:WIDTH-PIXELS - wname:X) NO-ERROR.
  

  /* Notify SCM of Section Editor Startup. */
  RUN adecomm/_adeevnt.p
      (INPUT  "Section Editor":u , INPUT "STARTUP":u ,
       INPUT  STRING(THIS-PROCEDURE) , INPUT STRING(h_sewin) ,
       OUTPUT scm_ok ) NO-ERROR.

  END. /* WITH FRAME */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setToolTip h_sewin 
PROCEDURE setToolTip :
/*------------------------------------------------------------------------------
  Purpose:     Set widget TOOLTIP attribute so that long widget names can be 
               viewed without a horizontal scrollbar. (19970409-045)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  wname:TOOLTIP IN FRAME f_edit = 
    ENTRY(wname:LOOKUP(wname:SCREEN-VALUE IN FRAME f_edit),
          wname:LIST-ITEMS IN FRAME f_edit, CHR(10)).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_vars h_sewin 
PROCEDURE set_vars :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  ASSIGN h_frame        = FRAME f_edit:HANDLE
         h_frame:PARENT = h_sewin
         h_Editor       = txt:HANDLE IN FRAME f_edit
         h_mbar         = h_sewin:MENU-BAR
    . /* ASSIGN */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

