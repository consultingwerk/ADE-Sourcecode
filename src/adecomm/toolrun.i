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

File: adecomm/toolrun.i

Description:

This file is part of the quartet of toolmenu.i, toolrun.i, toolsupp, _toollic.p.
These files together will build the standard tools menu used by all the
ADE applications.

Usage:

Include {adecomm/toolmenu.i} with your other menu defines.  See toolmenu.i
for any arguments.

Include {adecomm/toolrun.i} after your menubar definition.  This file
should only be run once per menubar.  When being called from the AB
(DEFINED(EXCLUDE_UIB) <> 0) there is no need to also include toolsupp.i as
this file includes it for you.  In the AB it needed to be broken out as
this file is included inside of an internal procedure (mode_morph) thereby
making it illegal to define the internal procedure utilities required by
this file (_RunTool and tools_check_call_stack).

This file will attempt to RUN enable_widgets and disable_widgets.  These
should be internal procedures in the file which includes toolrun.i.  
These procedures should perform any specific operations that your application
must do to prepare for running another application.  One example is 
resetting CURRENT-WINDOW back to your application's current window in
procedure enable_widgets.

Items on the Tool menu are enabled or disabled based on a number of states:
1. licensed or not - not visible if not licensed (use GET-LICENSE)
2. installed or not - grayed out if not installed (use SEARCH for _edit.p, ...).
3. tty or not - not visible if not applicable (use preprocessor)
4. in the call stack already or not - grays out of already in call stack 
  (Tran Mgr will not show up on the Editor Tools menu if _tran.p can be 
   found in the call tree - use PROGRAM-NAME)
5. in that tool already or not - not visible if not (Editor does not have 
   Editor on Tools menu - use preprocessor)

There is also a 6th condition to handle a RUN not on the tools menu.

6. if self is already in the call stack, display a message and set the
   tool_bomb variable to let includer handle the exit

Arguments:

{ adecomm/toolrun.i 
      &MENUBAR="mnb_Desktop"
      /* &EXCLUDE_ADMIN=yes */
      /* &EXCLUDE_DICT=yes */
      /* &EXCLUDE_EDIT=yes */
      /* &EXCLUDE_UIB=yes */
      /* &EXCLUDE_RPT=yes */
      /* &EXCLUDE_TRAN=yes */
      /* &EXCLUDE_VTRAN=yes */
      /* &EXCLUDE_COMP=yes */
      /* &ENABLE_WIDGETS_PROC = alternate enable routine [optional]  */
      /* &DISABLE_WIDGETS_PROC = alternate disable routine [optional] */
      /* &DISABLE_ONLY = on choose of tool, call disable routine
                                           only - [optional (for dictionary)] */
      /* &PERSISTENT=PERSISTENT = makes triggers persistent, default is scoped */
      /* &TOOL_RUN=yes */
}

&MENUBAR    - name the menubar that contains the toolmenu.i include.
&EXCLUDE_*  - The calling tool should exclude itself from the menu.
&TOOL_RUN   - If passed/define, indicates toolrun.i has been included once
              already. Use by Procedure Editor to attach both static and
              dynamic mnu_Tools menus to support Advanced Editing Options
              features.

NOTE: This procedure defines two local variables
        tool_bomb - set true if the current tool should not be running
        tool_pgm_list - list of tools running (used to define triggers).

Author: Mike Pacholec

Date Created: May 21, 1993
          
Change Log:
08-19-01 jep   For EXLCUDE_UIB menu items, added support for h_sm handle to specify
               dynamic Tools menu parent in place of static mnu_Tools reference.
               Part of ICF support. jep-icf
06-29-99 jep   Added TOOL_RUN support for including file a second time.
               See above notes.
05-07-99 gfs   Added Actuate DWB and ARD
04-16-98 hd    Added WebTools  
11-14097 drh   Made many of the menu items dynamic when called from the UIB
01-29-96 jep   Removed Proclib tool from tool set (PLIB).
09-05-95 jep   Correct calls to VTRAN.
06-29-95 jep   Corrected PROT*Tools menu handling to be consistent.
05-17-95 jep   Added Visual Translator Tool (VTRAN) - supplemental tool for
               Tran Man II.
06-23-94 jep   Improved message about running a tool more than once.
06-25-93 jep   Corrected COMP_ENTRYPT from procomp.p to _procomp.p.
06-03-93 stern Added DISABLE_ONLY argument.
06-01-93 mikep re-enabled check for > 1 run of a tool
05-26-93 mikep cache get-license, check call stack
05-26-93 wood  removed WIDGET-POOL; Moved i and pgm_name into internal
               procedure tools_check_call_stack.
               Added optional parameter ENABLE_WIDGETS_PROC and
               DISABLE_WIDGETS_PROC to replace calls to enable_widgets
               and disable_widgets.
05-25-93 mikep disable non-installed menu items
05-21-93 mikep created and tested with Dictionary

----------------------------------------------------------------------------*/

&SCOP ADMIN_ENTRYPT "prodict/_dictc.p"
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
&SCOP DICT_ENTRYPT  "prodict/_dictc.p"
&ELSE
&SCOP DICT_ENTRYPT  "adedict/_dictg.p"
&ENDIF
&SCOP EDIT_ENTRYPT  "adeedit/_proedit.p"
&SCOP UIB_ENTRYPT   "adeuib/_uibmain.p"
&SCOP RPT_ENTRYPT   "aderes/aderes.p"
&SCOP RB_ENTRYPT    "aderb/_startrb.p"
&SCOP TRAN_ENTRYPT  "adetran/pm/_pmmain.p"
&SCOP VTRAN_ENTRYPT "adetran/vt/_main.p"
&SCOP COMP_ENTRYPT  "adecomp/_procomp.p"

&IF DEFINED(EXCLUDE_UIB) = 0 AND DEFINED(TOOL_RUN) = 0 &THEN
  DEFINE VARIABLE tool_pgm_list AS CHARACTER                          NO-UNDO.
  DEFINE VARIABLE tool_bomb     AS LOGICAL                            NO-UNDO.
&ENDIF


/*--------------------------------------------------------------------------*/
IF ade_licensed[1] = ? THEN
    RUN adecomm/_toollic.p.

/*--------------------- Check the call stack ----------------------------*/

RUN tools_check_call_stack.

/* FIX - Once all tools check for tool_bomb this should be uncommented.
IF tool_bomb THEN RETURN.
*/


/*--------------------- DICTIONARY MENU PROCESSING --------------------------*/

&IF DEFINED(EXCLUDE_DICT) = 0 AND DEFINED(EXCLUDE_UIB) = 0 &THEN
  IF ade_licensed[{&DICT_IDX}] <> {&INSTALLED} OR 
     CAN-DO(tool_pgm_list, {&DICT_ENTRYPT}) 
  THEN MENU-ITEM mnu_dict:SENSITIVE IN MENU mnu_Tools = No.
  ELSE ON CHOOSE OF MENU-ITEM mnu_dict IN MENU mnu_Tools
                    {&PERSISTENT} RUN _RunTool( INPUT "_dict.p" ).

&ELSEIF DEFINED(EXCLUDE_DICT) = 0 AND DEFINED(EXCLUDE_UIB) <> 0 &THEN
  CREATE MENU-ITEM mnu_dict ASSIGN LABEL = "&Data Dictionary"         PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN _RunTool(INPUT "_dict.p"). END TRIGGERS.

&ENDIF

/*--------------------- EDITOR MENU PROCESSING --------------------------*/

&IF DEFINED(EXCLUDE_EDIT) = 0 AND DEFINED(EXCLUDE_UIB) = 0 &THEN
  IF ade_licensed[{&EDIT_IDX}] <> {&INSTALLED} OR 
     CAN-DO(tool_pgm_list, {&EDIT_ENTRYPT}) 
  THEN MENU-ITEM mnu_editor:SENSITIVE IN MENU mnu_Tools = No.
  ELSE ON CHOOSE OF MENU-ITEM mnu_editor IN MENU mnu_Tools
                   {&PERSISTENT} RUN _RunTool( INPUT "_edit.p" ).

&ELSEIF DEFINED(EXCLUDE_EDIT) = 0 AND DEFINED(EXCLUDE_UIB) <> 0 &THEN
  CREATE MENU-ITEM mnu_editor ASSIGN LABEL = "Procedure &Editor"      PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_editor IN _h_UIB. END TRIGGERS.

&ENDIF

/*--------------------- ADMIN MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_ADMIN) = 0 AND DEFINED(EXCLUDE_UIB) = 0 &THEN
  IF ade_licensed[{&ADMIN_IDX}] <> {&INSTALLED} OR 
     CAN-DO(tool_pgm_list, {&ADMIN_ENTRYPT}) 
  THEN MENU-ITEM mnu_admin:SENSITIVE IN MENU mnu_Tools = No.
  ELSE ON CHOOSE OF MENU-ITEM mnu_admin IN MENU mnu_Tools
                   {&PERSISTENT} RUN _RunTool( INPUT "_admin.p" ).

&ELSEIF DEFINED(EXCLUDE_ADMIN) = 0 AND DEFINED(EXCLUDE_UIB) <> 0 &THEN
  CREATE MENU-ITEM mnu_admin ASSIGN LABEL = "Data &Administration"     PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN _RunTool(INPUT "_admin.p"). END TRIGGERS.
  mnu_admin:SENSITIVE = (ade_licensed[{&ADMIN_IDX}] = {&INSTALLED} AND
                            NOT CAN-DO(tool_pgm_list, {&ADMIN_ENTRYPT})).

&ENDIF
/*--------------------- PRO*TOOLS MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_UIB) = 0 &THEN
  IF ade_licensed[{&PTOOL_IDX}] <> {&INSTALLED}
  THEN MENU-ITEM mnu_protools:SENSITIVE IN MENU mnu_Tools = No.
  ELSE ON CHOOSE OF MENU-ITEM mnu_protools IN MENU mnu_Tools
                 RUN "protools/_protool.p" PERSISTENT.

&ELSEIF DEFINED(EXCLUDE_UIB) <> 0 &THEN
  CREATE MENU-ITEM mnu_protools ASSIGN LABEL = "&PRO*Tools"  PARENT = h_sm
         TRIGGERS:
           ON CHOOSE PERSISTENT RUN run-protool.
         END TRIGGERS.
  mnu_protools:SENSITIVE = (ade_licensed[{&PTOOL_IDX}] = {&INSTALLED}).

&ENDIF

/*--------------------- Tool Menu Internal Procecdures ------------------*/

/*------------------------------ OS SHELL -------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
ON CHOOSE OF MENU-ITEM mnu_OS_Shell IN MENU mnu_Tools
DO:
    DO ON STOP UNDO, RETRY:
        IF NOT RETRY
        THEN DO:
            RUN disable_widgets.
            OS-COMMAND.
        END.
        RUN enable_widgets.
    END.
END.
&ENDIF

/*---------------------- AB MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_UIB) = 0 &THEN
IF ade_licensed[{&UIB_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_uib_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_uib_wh
        ASSIGN 
            LABEL       = "App&Builder"
            PARENT      = MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_ab.p" ).
    END TRIGGERS.
    IF ade_licensed[{&UIB_IDX}] <> {&INSTALLED} OR 
       CAN-DO(tool_pgm_list, {&UIB_ENTRYPT}) 
    THEN
        mnu_uib_wh:SENSITIVE = No.
END.
&ENDIF

/*--------------------- WEBTOOLS MENU PROCESSING --------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&IF DEFINED(TOOL_RUN) = 0 &THEN
DEFINE VARIABLE mnu_webtools AS WIDGET-HANDLE NO-UNDO.
&ENDIF
IF ade_licensed[{&WTOOL_IDX}] <> {&NOT_AVAIL} THEN 
DO:
  CREATE MENU-ITEM mnu_webtools 
    ASSIGN LABEL  = "&WebT&ools" 
           PARENT = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                    &ELSE h_sm &ENDIF
         TRIGGERS:
           ON CHOOSE PERSISTENT RUN adeweb/_abrunwb.p("workshop").
         END TRIGGERS.
  mnu_webtools:SENSITIVE = (ade_licensed[{&WTOOL_IDX}] = {&INSTALLED}).
END.
&ENDIF

/*--------------------- RB MENU PROCESSING --------------------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN

&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_RB) = 0 &THEN
IF ade_licensed[{&RB_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_rb_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_rb_wh
        ASSIGN 
            LABEL       = "Report B&uilder"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_rbuild.p" ).
    END TRIGGERS.
    IF ade_licensed[{&RB_IDX}] <> {&INSTALLED} OR 
       CAN-DO(tool_pgm_list, {&RB_ENTRYPT}) 
    THEN
        mnu_rb_wh:SENSITIVE = No.
END.
&ENDIF
&ENDIF

/*--------------------- RW MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" AND DEFINED(EXCLUDE_RPT) = 0 &THEN
IF ade_licensed[{&RPT_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_rpt_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_rpt_wh
        ASSIGN 
            LABEL       = "&RESULTS"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "results.p" ).
    END TRIGGERS.
    IF ade_licensed[{&RPT_IDX}] <> {&INSTALLED} OR 
       CAN-DO(tool_pgm_list, {&RPT_ENTRYPT}) 
    THEN
        mnu_rpt_wh:SENSITIVE = No.
END.
&ENDIF

/*--------------------- TRANMAN MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" AND DEFINED(EXCLUDE_TRAN) = 0 &THEN
IF ade_licensed[{&TRAN_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_tran_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_tran_wh
        ASSIGN 
            LABEL       = "&Translation Manager"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_tran.p" ).
    END TRIGGERS.
    IF ade_licensed[{&TRAN_IDX}] <> {&INSTALLED} OR 
       CAN-DO(tool_pgm_list, {&TRAN_ENTRYPT}) 
    THEN
        mnu_tran_wh:SENSITIVE = No.
END.
&ENDIF

/*------------ VISUAL TRANSLATOR MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" AND DEFINED(EXCLUDE_VTRAN) = 0 &THEN
IF ade_licensed[{&VTRAN_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_vtran_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_vtran_wh
        ASSIGN
            LABEL       = "&Visual Translator"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_vtran.p").
    END TRIGGERS.
    IF ade_licensed[{&VTRAN_IDX}] <> {&INSTALLED} OR
       CAN-DO(tool_pgm_list, {&VTRAN_ENTRYPT})
    THEN
        mnu_vtran_wh:SENSITIVE = No.
END.
&ENDIF

/*--------------------- COMPILER MENU PROCESSING --------------------------*/

&IF DEFINED(EXCLUDE_COMP) = 0 &THEN
IF ade_licensed[{&COMP_IDX}] <> {&NOT_AVAIL} THEN DO:

    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_comp_wh AS WIDGET-HANDLE.
    &ENDIF
    CREATE MENU-ITEM mnu_comp_wh
        ASSIGN 
            LABEL       = "Application &Compiler"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN _RunTool( INPUT "_comp.p" ).
    END TRIGGERS.
    IF ade_licensed[{&COMP_IDX}] <> {&INSTALLED} OR  
       CAN-DO(tool_pgm_list, {&COMP_ENTRYPT}) 
    THEN
        mnu_comp_wh:SENSITIVE = No.
END.
&ENDIF

/*--------------------- DWB MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
IF ade_licensed[{&DWB_IDX}] <> {&NOT_AVAIL} THEN DO:
    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_dwb_wh AS WIDGET-HANDLE.
    &ENDIF
        
    CREATE MENU-ITEM mnu_dwb_wh
        ASSIGN 
            LABEL       = "Actuate Developer &Workbench"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN adecomm/_rundwb.p.
    END TRIGGERS.
END.
&ENDIF

/*--------------------- ARD MENU PROCESSING --------------------------*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
IF ade_licensed[{&ARD_IDX}] <> {&NOT_AVAIL} THEN DO:
    &IF DEFINED(TOOL_RUN) = 0 &THEN
    DEFINE VARIABLE mnu_ard_wh AS WIDGET-HANDLE.
    &ENDIF
        
    CREATE MENU-ITEM mnu_ard_wh
        ASSIGN 
            LABEL       = "e.Report Des&igner"
            PARENT      = &IF DEFINED(EXCLUDE_UIB) = 0 &THEN MENU mnu_Tools:HANDLE IN MENU {&MENUBAR}
                          &ELSE h_sm &ENDIF
    TRIGGERS:
        ON CHOOSE {&PERSISTENT} RUN adecomm/_runard.p.
    END TRIGGERS.
END.
&ENDIF

&IF DEFINED(EXCLUDE_UIB) = 0 AND DEFINED(TOOL_RUN) = 0 &THEN
  &IF DEFINED(DISABLE_ONLY) NE 0 &THEN
     {adecomm/toolsupp.i 
               &DISABLE_WIDGETS_PROC = {&DISABLE_WIDGETS_PROC}
               &DISABLE_ONLY = {&DISABLE_ONLY} }
   &ELSE
     {adecomm/toolsupp.i}
   &ENDIF
&ENDIF



