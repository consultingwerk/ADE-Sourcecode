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
/*----------------------------------------------------------------------------

File: uibmdefs.i

Description:
   The menu and variable definitions for main routine of the UIB.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Date Modified: 6/10/94 by RPR (adeicon directory variable)
               2/7/95  by GFS Modified palette menubar
               3/8/95  by GFS Removed 'Insert DB Fields'
               1/31/96 by PAL Added tab order access from Edit menu.
               6/26/96 by WTW Remove Standard MOTIF layout.
              10/28/96 by GFS Added tooltips to button bar
              01/10/97 by GFS Made main window/frame bigger on NT 3.51
              01/23/97 by GFS Added NO-FOCUS to toolbar buttons
              02/01/97 by SLK Added Add OCX
              03/03/97 by JEP Changed Help menu to use Help Topics.
              03/31/97 by GFS Removed 'Progress Technical Services'
              07/21/98 by GFS Use flat buttons on main toolbar
              04/21/99 by TSM Added Print Option to File submenu and toolbar
              05/04/99 by TSM Added support for most recently used filelist by
                              removing mi_Exit menu item, it is now defined
                              dynamically in mru_menu internal procedure
              05/17/99 by TSM Added Save All menu item
              05/20/99 by XBO Added New ADM2 class menu item
              06/29/99 by JEP Added Editing Options support.
              11/08/99 by TSN Changed references from "ADM2" to "ADM" on menu
              08/19/01 by jep Changes for ICF development tools support. jep-icf
                              - Moved status line preprocessor defs to _uibmain.p.
                              - Moved "new shared" include references to
                                _uibmain.p. They didn't belong here anyways.
                              - Added m_menubar, m_hFile, and m_hEdit handles to
                                track menu handles instead of using static refs.
              09/18/01 by jep-icf Added openobject_button handle for the toolbar icon.
                              Changed Scoped-Define bar_labels, bar_tips,
                              bar_images, bar_actions to variables.
              10/10/01 by jep-icf IZ 2101 Run button enabled when editing
                              dynamic objects. Moved h_button_bar to sharvars.i
                              and renamed to _h_button_bar (new shared).
----------------------------------------------------------------------------*/

/* Compile time defines */
DEFINE SUB-MENU m_file
       MENU-ITEM mi_new            LABEL "&New..."     ACCELERATOR "Shift-F3"
       RULE
       MENU-ITEM mi_open           LABEL "&Open..."    ACCELERATOR "F3"
       MENU-ITEM mi_close          LABEL "&Close"      ACCELERATOR "F8"
       MENU-ITEM mi_close_all      LABEL "C&lose Windows..."
						       ACCELERATOR "Shift-F8"
       RULE
       MENU-ITEM mi_save           LABEL "&Save"       ACCELERATOR "F6"
       MENU-ITEM mi_save_as        LABEL "Save &As..." ACCELERATOR "Shift-F6"
       MENU-ITEM mi_save_all       LABEL "Sa&ve All"
       RULE
       MENU-ITEM mi_print          LABEL "&Print".
       RULE.

DEFINE SUB-MENU m_edit
       MENU-ITEM mi_undo           LABEL "&Undo"        ACCELERATOR "CTRL-Z"
							DISABLED
       RULE
       MENU-ITEM mi_cut            LABEL "Cu&t"         ACCELERATOR "CTRL-X"
       MENU-ITEM mi_copy           LABEL "&Copy"        ACCELERATOR "CTRL-C"
       MENU-ITEM mi_paste          LABEL "&Paste"       ACCELERATOR "CTRL-V".

DEFINE SUB-MENU m_compile
       MENU-ITEM mi_run            LABEL "&Run"           ACCELERATOR "F2"
       MENU-ITEM mi_check          LABEL "&Check Syntax"  ACCELERATOR "Shift-F2"
       MENU-ITEM mi_debugger       LABEL "&Debug"         ACCELERATOR "Shift-F4"
       RULE
       MENU-ITEM mi_preview        LABEL "Code &Preview"  ACCELERATOR "F5".

/* The handles below are needed for adjusting sensitivity.                 */
DEFINE VARIABLE m_menubar         AS HANDLE                          NO-UNDO. /* jep-icf */
DEFINE VARIABLE m_hFile           AS HANDLE                          NO-UNDO. /* jep-icf */
DEFINE VARIABLE m_hEdit           AS HANDLE                          NO-UNDO. /* jep-icf */
DEFINE VARIABLE m_align           AS HANDLE                          NO-UNDO.
DEFINE VARIABLE m_layout          AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_about          AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_attributes     AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_chCustLayout   AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_bottommost     AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_chlayout       AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_code_edit      AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_color          AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_contents       AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_master         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_control_props  AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_cuecards       AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_CustomParams   AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_duplicate      AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_dbconnect      AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_erase          AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_exit           AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_export         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_goto_page      AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_editing_opts   AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_grid_display   AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_grid_snap      AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_import         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_messages       AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_mrulist        AS HANDLE  EXTENT 9                NO-UNDO.
DEFINE VARIABLE mi_proc_settings  AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_property_sheet AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_rule           AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_recent         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_show_toolbox   AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_tab_edit       AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mi_topmost        AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mnu_admin         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mnu_dict          AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mnu_editor        AS HANDLE                          NO-UNDO.
DEFINE VARIABLE mnu_protools      AS HANDLE                          NO-UNDO.

/* These variables are necessary for controlling the dynamic tools menu */
DEFINE VARIABLE mode_button       AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE last-mode         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE tool_pgm_list     AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE tool_bomb         AS LOGICAL                             NO-UNDO.
DEFINE VARIABLE openobject_button AS WIDGET-HANDLE                       NO-UNDO.
DEFINE VARIABLE gcResultCodes     AS CHARACTER  INITIAL ?                NO-UNDO.


/* Make the tools menu using the ade standards */
{ adecomm/toolmenu.i
  &EXCLUDE_UIB  = YES
  &CUSTOM_TOOLS =
     " MENU-ITEM mi_new_pw         LABEL ""Ne&w Procedure Window""
				   ACCELERATOR ""CTRL-F3"" "
}

/* The &EXCLUDE_UIB = YES had the effect of totally wiping out the UIB Tools menu */
DEFINE SUB-MENU mnu_Tools
       MENU-ITEM mi_new_pw         LABEL "Ne&w Procedure Window"
				   ACCELERATOR "CTRL-F3".
       MENU-ITEM mi_new_adm2_class LABEL "New AD&M Class..."
       MENU-ITEM mi_tempdb_maint   LABEL "&TEMP-DB Maintenance Tool...".

DEFINE SUB-MENU m_options
       MENU-ITEM mi_user_prefs     LABEL "&Preferences...".


/* MSW Style Guide Note:
     "Help" is always last item; "Window" (no "s") precedes it */
DEFINE MENU m_menubar MENUBAR
       SUB-MENU m_file             LABEL "&File"
       SUB-MENU m_edit             LABEL "&Edit"
       SUB-MENU m_compile          LABEL "&Compile"
       SUB-MENU mnu_tools          LABEL "&Tools"
       SUB-MENU m_options          LABEL "&Options".

/* Menus for the Toolbox */
DEFINE SUB-MENU m_tb_options
       &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
       MENU-ITEM mi_top_only      LABEL "&Top-Only Window"   TOGGLE-BOX
       &ENDIF
       MENU-ITEM mi_menu_only     LABEL "Show &Menu Only"    TOGGLE-BOX
       MENU-ITEM mi_save_palette  LABEL "&Save Palette"
       .

DEFINE SUB-MENU m_ocx_options
       MENU-ITEM mi_ocx_palette     LABEL "Add as &Palette Icon"
       MENU-ITEM mi_ocx_submenu     LABEL "Add to Palette &SubMenu"
       .

DEFINE SUB-MENU m_Toolbox
       SUB-MENU m_tb_options       LABEL "&Options"
       MENU-ITEM mi_get_custom     LABEL "&Use Custom..."
       SUB-MENU m_ocx_options	   LABEL "&Add OCX"
       RULE
       /* The rest of this menu is created Dynamically */
       .

DEFINE MENU mb_toolbox MENUBAR
       SUB-MENU m_Toolbox       LABEL "&Menu"
       .

/* Determine if the UIB (as opposed to just WS) is licensed.  If it is,
   then show "visual" type menu if it isn't show non-visual type menu.  */
   ASSIGN _visual-obj = (GET-LICENSE("UIB") = 0).


/* Now update the tools menu based upon what is running and what the
   user has licensed.  This also defines the triggers for this.
   If this file (_uibmain) is already running then tool_bomb is set.
{adecomm/toolrun.i
      &MENUBAR              = m_menubar
      &EXCLUDE_UIB          = yes
}
/* UIB is already running so quit */
IF tool_bomb THEN return.
*/

/* Explicitly set the enable attribute for the debugger menu-item */
IF GET-LICENSE("DEBUGGER":U) ne 0 THEN MENU-ITEM mi_debugger:SENSITIVE = NO.

/* ===================================================================== */
/*                        TEMP TABLE Definitions                         */
/* ===================================================================== */
{adeuib/uniwidg.i  NEW}      /* Universal Widget TEMP-TABLE definition   */
{adeuib/triggers.i NEW}      /* Trigger TEMP-TABLE definition            */
{adeuib/xftr.i     NEW}      /* eXternal Feature TEMP-TABLE definition   */
{adeuib/_undo.i    NEW}      /* Undo TEMP-TABLE definition               */
{adeuib/layout.i   NEW}      /* Multiple Layout TEMP-TABLE definitions   */
{adeuib/brwscols.i NEW}      /* Browse columns TEMP-TABLE definitions    */
{adeuib/advice.i   NEW}      /* PROGRESS Advisor shared definitoins      */

RUN create_layout_table.    /* Internal procedure below                 */


/* ===================================================================== */
/*                    Input Parameter Definitions                        */
/* ===================================================================== */
DEFINE INPUT PARAMETER p_File_List AS CHARACTER NO-UNDO.
		     /* Files UIB should open automatically on start-up. */
		     /* If p_File_List = ?,NEW then create a new window  */


/* ===================================================================== */
/*                        LOCAL VARIABLE Definitions                     */
/* ===================================================================== */

DEFINE VAR _clipboard_editor AS CHAR                               NO-UNDO
		             VIEW-AS EDITOR LARGE SIZE-CHAR 75 BY 15.
       /* _clipboard_editor Used to transfer cut/paste object            */
       /*                   information from file to system clipboard    */
DEFINE FRAME _clipboard_editor_frame
             _clipboard_editor AT 2
       WITH NO-LABELS TITLE "Clipboard" VIEW-AS DIALOG-BOX.

DEFINE VAR i                       AS INTEGER                      NO-UNDO.
DEFINE VAR widget_click_cnt        AS INTEGER  INITIAL 0           NO-UNDO.
DEFINE VAR open_file               AS CHAR                         NO-UNDO.
&IF {&dbgmsg_lvl} > 0 &THEN
DEFINE VAR msg_watcher  AS CHAR LABEL "message" FORMAT "X(132)"    NO-UNDO.
&ENDIF

DEFINE  VAR   cur_widg_name        AS CHAR      FORMAT "X(20)"     NO-UNDO
	      LABEL "Object".
DEFINE  VAR   cur_widg_text        AS CHAR      FORMAT "X(25)"     NO-UNDO
	      LABEL "Label"
	      CASE-SENSITIVE. /* Do this to catch case changes. */

/* Variables to store session settings we want to save and restore .        */
DEFINE VAR save_3D                 AS LOGICAL                      NO-UNDO.
DEFINE VAR save_interval           AS INTEGER                      NO-UNDO.
DEFINE VAR save_settings           AS LOGICAL                      NO-UNDO.
DEFINE VAR Schema_Prefix           AS INTEGER INITIAL 2            NO-UNDO.

DEFINE VAR    box-selecting  AS LOGICAL                            NO-UNDO.
DEFINE VAR    last-draw      LIKE _next_draw                       NO-UNDO.
DEFINE VAR    goback2pntr    AS LOGICAL     INITIAL TRUE           NO-UNDO.
DEFINE VAR    h              AS WIDGET                             NO-UNDO.
DEFINE VAR    hDrawTool      AS WIDGET                             NO-UNDO.
DEFINE VAR    h_lock         AS WIDGET                             NO-UNDO.
DEFINE VAR    idummy         AS INTEGER                            NO-UNDO.
DEFINE VAR    ldummy         AS LOGICAL                            NO-UNDO.
DEFINE VAR    h_wp_Pointer   AS WIDGET                             NO-UNDO.
DEFINE VAR    hAttrEd        AS HANDLE                             NO-UNDO.
DEFINE VAR    hSecEd         AS HANDLE                             NO-UNDO.
DEFINE VAR    windows2view   AS CHAR                               NO-UNDO.
DEFINE VAR    hTempDB        AS HANDLE                             NO-UNDO.

/* Variables used to "remember" what widget is displayed in the main window */
DEFINE VAR    h_display_widg AS WIDGET                             NO-UNDO.
DEFINE VAR    h_display_win  AS WIDGET                             NO-UNDO.
DEFINE VAR    hCustomization AS WIDGET                             NO-UNDO.
DEFINE VAR    display_name   AS CHAR                               NO-UNDO.
DEFINE VAR    display_text   AS CHAR                               NO-UNDO.
DEFINE VAR    error_on_leave AS LOGICAL                            NO-UNDO.

DEFINE RECTANGLE h-rule-1
       EDGE-PIXELS 2 SIZE-PIXELS 100 BY 2.

DEFINE RECTANGLE tbrect
       EDGE-PIXELS 2 SIZE-PIXELS 100 BY 2.

DEFINE RECTANGLE group1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE-PIXELS 105 BY 30.

DEFINE RECTANGLE group2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE-PIXELS 185 BY 30.

DEFINE RECTANGLE group3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE-PIXELS 265 BY 30.

DEFINE RECTANGLE group4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE-PIXELS 295 BY 30.

/* NOTE: we use a THREE-D look in Windows.  So there is a slight difference in
   the frame
   ************************ MS-Windows Layout ********************* */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"  &THEN

/* Action Icon Frame is 3-D -- this will force Progress to use 3D for all system
   dialog-boxes.  NOTE: these fill-ins will be white (a break with the ADE standard). */
DEFINE FRAME action_icons
     tbrect             AT X 0 Y  0
     h-rule-1           AT X 0 Y 28
     group1             AT X 0 Y  0
     group2             AT X 0 Y  0
     group3             AT X 0 Y  0
     group4             AT X 0 Y  0
     cur_widg_name      AT X 6 Y 35
     cur_widg_text      AT X 6 Y 35  /* we'll fix this later */
     &IF {&dbgmsg_lvl} > 0 &THEN
     msg_watcher    AT 1 NO-LABEL VIEW-AS EDITOR SIZE-CHAR 75 BY 5
		    SCROLLBAR-VERTICAL
     &ENDIF
   WITH SIDE-LABELS NO-BOX WIDTH /*76*/ 68 THREE-D FONT 4.
&ELSE
/* ************************ Other Layout ********************* */

DEFINE FRAME action_icons
     h-rule-1           AT X 0 Y 44
     cur_widg_name      {&STDPH_FILL} AT X 6 Y 40
     cur_widg_text      {&STDPH_FILL} AT X 6 Y 40 /* we'll fix this later */
     &IF {&dbgmsg_lvl} > 0 &THEN
     msg_watcher    AT 1 NO-LABEL VIEW-AS EDITOR SIZE-CHAR 75 BY 5
		    SCROLLBAR-VERTICAL
     &ENDIF
   WITH SIDE-LABELS NO-BOX WIDTH 76.
&ENDIF

/* Extra width for Win31 shell */
IF SESSION:WINDOW-SYSTEM = "MS-WINDOWS" THEN /* NT 3.51 */
  ASSIGN FRAME action_icons:WIDTH = 92.

/* Special case -- small screen and big font. */
IF SESSION:PIXELS-PER-COLUMN = 8 AND SESSION:WIDTH-PIXELS = 640 THEN
  ASSIGN cur_widg_text:WIDTH = 31
	 FRAME action_icons:WIDTH  = 67
	 FRAME action_icons:HEIGHT = 3.
ELSE DO:
  /* Never allow a frame to be too small. */
  IF FRAME action_icons:WIDTH-PIXELS < 388 THEN FRAME action_icons:WIDTH-P = 388.
END.
/* Do some minimal run-time adjustment of the frame. Make it the correct size.
   Adjust the width and position of the text field. */
ASSIGN /* There is a "bug" if a Frame is 3D.  The fill-in height does
          not properly account for the 3D, so descenders ("g") are truncated.
          The height of a fill-in should be 1.5 * text-height + 2.
          Do this only on Windows. */
     &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
       cur_widg_name:HEIGHT-P =
         (1.5 * FONT-TABLE:GET-TEXT-HEIGHT-P (FRAME action_icons:FONT)) +
         (IF FRAME action_icons:THREE-D THEN 2 ELSE 0)
       h = cur_widg_name:SIDE-LABEL-HANDLE
       h:HEIGHT-P = cur_widg_name:HEIGHT-P
       cur_widg_text:HEIGHT-P = cur_widg_name:HEIGHT-P
     &ENDIF
       h = cur_widg_text:SIDE-LABEL-HANDLE
       h:HEIGHT-P = cur_widg_text:HEIGHT-P
       /* Save the gap between the text fill-in and its label. */
       i   = cur_widg_text:X - h:X
       cur_widg_text:X = 6 + cur_widg_name:WIDTH-P +
              /* Allow space for the labels on cur_widg_name and cur_widg_text. */
              FONT-TABLE:GET-TEXT-WIDTH-P
                   ("Object:  Master: ":U, FRAME action_icons:FONT)
       cur_widg_text:WIDTH-P = FRAME action_icons:WIDTH-P -
                               FRAME action_icons:BORDER-LEFT-P -
                               FRAME action_icons:BORDER-RIGHT-P -
                               cur_widg_text:X
       h:X = cur_widg_text:X - i
       FRAME action_icons:HEIGHT-PIXELS = cur_widg_name:Y + cur_widg_name:HEIGHT-P +
                                          FRAME action_icons:BORDER-TOP-P +
                                          FRAME action_icons:BORDER-BOTTOM-P
       .

ASSIGN tbrect:WIDTH-PIXELS = FRAME action_icons:WIDTH-PIXELS
       group3:PRIVATE-DATA = "group3"
       group4:PRIVATE-DATA = "group4".

/* Profiler Checkpoint */
{adeshar/mp.i &TIMER="UIB_startup" &MP-MACRO="stotal"
	      &INFOSTR="[  uibmdefs.i] Before create of Button Bar" }

/* *************************** Button Bar ******************************* */

/* Add the button bar.  Create a button in the action_icons frame with
   the appropriate icon and action.   */
/* jep-icf IZ 2101 Button widget handles are stored in _h_button_bar defined in sharvars.i
   with max extent currently at 20. */
DEFINE VARIABLE bar_count   AS INTEGER    NO-UNDO INITIAL 10.
DEFINE VARIABLE bar_labels  AS CHARACTER  NO-UNDO INITIAL "New,Open,Save,Print,Procedure,Run,Edit,List,Property,Colors".
DEFINE VARIABLE bar_tips    AS CHARACTER  NO-UNDO INITIAL "New,Open,Save,Print,Procedure settings,Run,Edit code,List objects,Object properties,Colors".
DEFINE VARIABLE bar_images  AS CHARACTER  NO-UNDO INITIAL "new,open,save,print,proc,run,editcode,list,props,color".
DEFINE VARIABLE bar_actions AS CHARACTER  NO-UNDO INITIAL "choose_file_new,choose_file_open,choose_file_save,~
choose_file_print,choose_proc_settings,choose_run,choose_codedit,choose_uib_browser,choose_prop_sheet,adeuib/_selcolr.p".

DEFINE VAR xloc         AS INTEGER NO-UNDO initial 2.
DEFINE VAR button_skip1 AS INTEGER NO-UNDO initial 4.
DEFINE VAR button_skip2 AS INTEGER NO-UNDO initial 7.

/* jep-icf: Buttons to skip a little extra are up by 1 because of "Open Object" button. */
IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
  ASSIGN button_skip1 = 5
         button_skip2 = 8.

/* Create the toolbar buttons */
DO i = 1 to bar_count:

  CREATE BUTTON _h_button_bar[i]
    ASSIGN FRAME       = FRAME action_icons:HANDLE
	   X            = xloc
	   Y            = 4
	   WIDTH-P      = 24
	   HEIGHT-P     = 23
	   PRIVATE-DATA = ENTRY(i, bar_actions)
	   BGCOLOR      = std_okbox_bgcolor   /* Grey */
	   FONT         = 4                   /* Small 8-pt font (MS-Windows) */
	   SENSITIVE    = YES
	   TOOLTIP      = ENTRY(i, bar_tips)
          NO-FOCUS     = YES
          FLAT-BUTTON  = YES
    TRIGGERS:
       ON DEL    RUN choose_erase.
       ON CHOOSE RUN VALUE(SELF:PRIVATE-DATA).
    END TRIGGERS.
  /* Load up image for button. */
  ASSIGN ldummy = _h_button_bar[i]:LOAD-IMAGE-UP({&ADEICON-DIR} +
				  ENTRY(i, bar_images) + "{&BITMAP-EXT}") NO-ERROR.
  /* Add label in case image fails to load. */
  IF ldummy ne YES or ERROR-STATUS:ERROR
  THEN ASSIGN _h_button_bar[i]:LABEL   = ENTRY(i, bar_labels).

  /* We are putting dividing rectangles between after the 3rd and
     sixth button in this routine. We have to skip a little extra
     in those cases */
  IF i = button_skip1 OR i = button_skip2 THEN
    xloc = xloc + 30.
  ELSE
    xloc = xloc + 25.
END.  /* DO i = 1 to btn_count: */

/* Create a Stop Button image for use when running user's code.
   CAUTION: This is a hidden button. Watch out when you use ENABLE ALL
   WITH FRAME action_icons.
*/
/* "Stop" Button overlays the "Run" button, so get handle of the run button. */
ASSIGN i = LOOKUP( "Run" , bar_labels).
CREATE BUTTON Stop_Button
  ASSIGN FRAME        = _h_button_bar[i]:FRAME
         X            = IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN _h_button_bar[i + 1]:X ELSE _h_button_bar[i]:X
         Y            = IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN _h_button_bar[i + 1]:Y ELSE _h_button_bar[i]:Y
         WIDTH-P      = _h_button_bar[i]:WIDTH-P
         HEIGHT-P     = _h_button_bar[i]:HEIGHT-P
         PRIVATE-DATA = "stop":U
         BGCOLOR      = _h_button_bar[i]:BGCOLOR
         FONT         = 4
         TOOLTIP      = "Stop"
         NO-FOCUS     = YES
         FLAT-BUTTON  = YES
         HIDDEN       = YES
         SENSITIVE    = FALSE
  TRIGGERS:
      ON CHOOSE STOP.
  END TRIGGERS.

ASSIGN ldummy = Stop_Button:LOAD-IMAGE-UP({&ADEICON-DIR} + "stop" + "{&BITMAP-EXT}") NO-ERROR.
/* Add label in case image fails to load */
IF ldummy ne YES or ERROR-STATUS:ERROR
THEN ASSIGN Stop_Button:LABEL = "Stop"
            Stop_Button:TOOLTIP = Stop_Button:LABEL.

/* Profiler Checkpoint */
{adeshar/mp.i &TIMER="UIB_startup" &MP-MACRO="stotal"
	      &INFOSTR="[   uibmdefs.i] Done create of Button Bar"}

PROCEDURE create_layout_table.
  /* Initialize with standard layouts                                      */
  CREATE _LAYOUT.
  ASSIGN _LAYOUT._LO-NAME   = "Master Layout"
	 _LAYOUT._GUI-BASED = YES    /* Get from .ini File */
	 _LAYOUT._ACTIVE    = YES
	 _LAYOUT._COMMENT   = "This layout is the master layout for this " +
			      "window.  It determines the ~"compile-time~" " +
			      "layout.  Other layouts are determined " +
			      "at ~"run-time~".".
  CREATE _LAYOUT.
  ASSIGN _LAYOUT._LO-NAME    = "Standard Windows 95"
         _LAYOUT._GUI-BASED  = YES
         _LAYOUT._ACTIVE     = NO
         _LAYOUT._EXPRESSION = "SESSION:WINDOW-SYSTEM = 'MS-WIN95':U"
         _LAYOUT._COMMENT    = "This layout is the standard layout " +
                               "specification for a customized Windows 95 " +
                               "window.  It is usually selected to " +
                               "modify a window that needs to have " +
                               "a standard ~"Windows 95~" look.".

  CREATE _LAYOUT.
  ASSIGN _LAYOUT._LO-NAME    = "Standard MS Windows"
	 _LAYOUT._GUI-BASED  = YES
	 _LAYOUT._ACTIVE     = NO
	 _LAYOUT._EXPRESSION = "SESSION:WINDOW-SYSTEM = 'MS-WINDOWS':U "
	 _LAYOUT._COMMENT    = "This layout is the standard layout " +
			       "specification for a customized MS Windows " +
			       "window.  It is usually selected to " +
			       "modify a window that needs to have " +
			       "a standard ~"MS Windows~" look.".

  CREATE _LAYOUT.
  ASSIGN _LAYOUT._LO-NAME    = "Standard Character"
	 _LAYOUT._GUI-BASED  = NO
	 _LAYOUT._ACTIVE     = NO
	 _LAYOUT._EXPRESSION = "SESSION:DISPLAY-TYPE = 'TTY':U "
	 _LAYOUT._COMMENT    = "This layout is the standard layout " +
			       "specification for a customized Character " +
			       "based terminal.  It is usually selected to " +
			       "modify a window that has a GUI based " +
			       "master layout.".
END.  /* create_layout_table */




