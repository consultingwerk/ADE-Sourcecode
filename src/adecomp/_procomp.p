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

/*
  File        : _procomp.p
  Syntax      : RUN adecomp/_procomp.p
  Description : This is the main window program for the Progress
                Application Compiler Tool.

  Author      : John Palazzo
  Date Created: 03/16/93
*/

/*
 WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING 


 When a directory
 name is entered in the compiler tool, a leading part of that directory
 name may already be in the propath.  In that case the leading PROPATH
 component is removed from the users entry.  If that leading PROPATH
 component was not the first entry in the propath, it moved
 to the front of the propath.  This way the file will be found in the
 intended directory as opposed to being found in some other directory
 earlier in the propath.

 For instance, if the PROPATH contains ",/appl" and the user enteres
 the directory "/appl/ar" and the file name "*.p", then the users
 directory will be changed to "ar" and durring the compile the PROPATH
 will be "/appl,".  This will have the effect of recording names in
 the xrf file as ar *.p as opposed to /appl/ar *.p or anything else.

 If two elements of the PROPATH are both leading the user's entered
 directory, the longest element is removed.

 For instance, if the PROPATH contains ",/appl,/appl/ar" and the
 user enters dir "/appl/ar" file "*.p", then the propath will be
 changed to "/appl/ar,,/appl" and the program names will not have
 any directory name in the .xrf file.

 When the call is finally made to _compile.p, the recursive program
 that does the actual compiling, s_ProPathDir contains the PROPATH
 directory, if any, that was split off from the entered directory
 name.  s_fspec is a concatination of the relative directory name
 and the file spec to compile.

 WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING 
*/          

/* Name of the .ini section for the compiler */
&GLOBAL-DEFINE CompSect "Procomp"
&GLOBAL-DEFINE WIN95-BTN YES

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds THEN RUN adecomm/_adeload.p.

{ adecomm/adeintl.i }         /* ADE Int'l Standards.         */
{ adecomp/compvars.i "NEW"}   /* SHARED VAR Definitions       */
{ adecomp/comphelp.i }        /* Compiler Help Context Defs.  */

/*----------------------------------------------------------------------
                      Define Menus
----------------------------------------------------------------------*/
DEFINE SUB-MENU mnu_File
  MENU-ITEM _Exit       LABEL "E&xit"  .

DEFINE SUB-MENU mnu_Compile
  MENU-ITEM _Start      LABEL "&Start Compile" ACCELERATOR KBLABEL("GO")  .

/* ADE Standard Tools Menu Include. */
{ adecomm/toolmenu.i }
  
DEFINE SUB-MENU mnu_Options
  MENU-ITEM _Options       LABEL "&Compiler..."
  RULE
  MENU-ITEM _Show_Status   TOGGLE-BOX LABEL "Sh&ow Status"
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _Save_Settings TOGGLE-BOX LABEL "&Save Settings on Exit"
&ENDIF
  .
  
DEFINE SUB-MENU mnu_Help SUB-MENU-HELP
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _Help_Topics   LABEL "&Help Topics"
  RULE
&ENDIF
  MENU-ITEM _Menu_Messages LABEL "M&essages..."
  MENU-ITEM _Menu_Recent   LABEL "&Recent Messages..."
  RULE
  MENU-ITEM _About         LABEL "&About Application Compiler".

DEFINE MENU mnu_ProMake MENUBAR
  SUB-MENU mnu_File     LABEL "&File"
  SUB-MENU mnu_Compile  LABEL "&Compile"
  SUB-MENU mnu_Tools    LABEL "&Tools"
  SUB-MENU mnu_Options  LABEL "&Options"
  SUB-MENU mnu_Help     LABEL "&Help".

DEFINE MENU mnu_Popup 
  MENU-ITEM m_Add          LABEL "&Add..."
  MENU-ITEM m_Modify       LABEL "&Modify..."    
  MENU-ITEM m_Delete       LABEL "&Delete..."
  RULE
  MENU-ITEM m_StartComp    LABEL "&Start Compile"
  .

/*----------------------------------------------------------------------
                      Define Variables
----------------------------------------------------------------------*/
DEFINE VAR vQualifiedProPath AS CHAR NO-UNDO.

DEFINE VAR win_Promake AS WIDGET-HANDLE.
DEFINE VAR win_OldCurrent AS WIDGET-HANDLE.
DEFINE VAR Counter AS INTEGER.
DEFINE VAR Temp    AS LOGICAL.
DEFINE VAR Key_Value AS CHAR NO-UNDO.

DEFINE VAR t_int AS INTEGER NO-UNDO.
DEFINE VAR t_log AS LOGICAL NO-UNDO.

&IF "{&OPSYS}" = "VMS" &THEN
    DEFINE VAR vms_cwd AS CHAR NO-UNDO.
&ENDIF
/*------------------------------------------------------------------------
                    Define List, Query, and Browse
------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ListItem NO-UNDO
  FIELD File_Spec  AS CHAR FORMAT "X(50)" 
                   LABEL "Files/Directories to Compile"
  FIELD Proc_Types AS CHAR FORMAT "X(15)" 
                   LABEL "Types"
  INDEX File_Spec IS UNIQUE File_Spec.

DEFINE QUERY Qry_ListItem FOR ListItem SCROLLING.

DEFINE BROWSE B_Compile QUERY Qry_ListItem
    DISPLAY ListItem.File_Spec WIDTH 50 FORMAT "x(256)"
            ListItem.Proc_Types WIDTH 15 FORMAT "x(256)"
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
        &THEN WITH SIZE 71 BY 8 .
        &ELSE WITH SIZE 71 BY 11.
    &ENDIF

/*------------------------------------------------------------------------
                    Define UI (Buttons, Frames, Triggers)
------------------------------------------------------------------------*/

DEFINE BUTTON btn_Propath LABEL "&Propath..."
    SIZE 13 BY 1
    TRIGGERS:
        ON CHOOSE RUN GetPropath.
    END .

DEFINE BUTTON btn_Add LABEL "&Add..."
    SIZE 13 BY 1
    TRIGGERS:
        ON CHOOSE RUN AddListItem.
    END .

DEFINE BUTTON btn_Modify LABEL "&Modify..."
    SIZE 13 BY 1
    TRIGGERS:
        ON CHOOSE RUN ModifyListItem.
    END .

DEFINE BUTTON btn_Delete LABEL "&Delete"
    SIZE 13 BY 1
    TRIGGERS:
        ON CHOOSE RUN DeleteListItem.
    END .

DEFINE BUTTON btn_Start_Compile LABEL "&Start Compile"
    SIZE 17 BY 1 AUTO-GO .

/* Dialog Box */    
FORM
  SKIP( {&TFM_WID} )

  B_Compile {&AT_OKBOX} SPACE(1) /* Widen Window by 1 char. */
  SKIP( {&VM_WIDG} )
    s_saver   {&AT_OKBOX} s_rmoldr AT 41
  SKIP( {&VM_WID} )
    s_subdirs {&AT_OKBOX} s_ifnor  AT 41
  SKIP( {&VM_WIDG} )
    btn_Propath {&AT_OKBOX} btn_Add btn_Modify btn_Delete btn_Start_Compile 
    SPACE({&HFM_WID})
  SKIP( {&VM_WIDG} )
    WITH FRAME main NO-LABELS THREE-D 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN NO-BOX &ENDIF .

/*------------------------------------------------------------------------
                    Other UI Triggers
------------------------------------------------------------------------*/

ON DEFAULT-ACTION OF BROWSE B_Compile
   OR MOUSE-SELECT-DBLCLICK OF BROWSE B_Compile
DO:
    IF AVAILABLE ListItem THEN
        RUN ModifyListItem.
    ELSE
        RUN AddListItem.
END.

ON HELP OF FRAME main ANYWHERE
DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p
        ( INPUT "comp" ,
          INPUT "TOPICS" ,
          INPUT {&Compiler_Window} , INPUT ? ).
  END.    
END.

ON VALUE-CHANGED OF s_rmoldr
DO:
  IF s_rmoldr:SCREEN-VALUE BEGINS "Y" THEN
    s_ifnor:SCREEN-VALUE = "NO".
END.

ON VALUE-CHANGED OF s_ifnor 
DO:
  IF s_ifnor:SCREEN-VALUE BEGINS "Y" THEN
    s_rmoldr:SCREEN-VALUE = "NO".
END.


ON DELETE-CHARACTER OF FRAME main ANYWHERE
DO:
  RUN DeleteListItem.
END.

ON GO OF FRAME main
DO:
    IF ( MENU-ITEM _Start:SENSITIVE IN MENU mnu_Compile = TRUE )
    THEN APPLY "CHOOSE" TO MENU-ITEM _Start IN MENU mnu_Compile .
    ELSE MESSAGE "Compile list is empty." SKIP(1)
                 "Choose Add or Propath to add a file or directory to the" SKIP
                 "compile list."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* Ignore Esc key in Application. Window. */
ON END-ERROR OF FRAME main ANYWHERE RETURN NO-APPLY. 

/*----------------------------------------------------------------------
                      Menu Triggers
----------------------------------------------------------------------*/
/*-----------   Compile Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Start IN MENU mnu_Compile
DO:
  RUN StartCompile.
END.

/*-----------   Tools Menu Triggers  --------------*/
{ adecomm/toolrun.i 
      &MENUBAR="mnu_ProMake"
      &EXCLUDE_COMP=yes
}

/*-----------   Options Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Options IN MENU mnu_Options
DO:
    RUN DlgOptions .
END.

ON VALUE-CHANGED OF MENU-ITEM _Show_Status IN MENU mnu_Options
DO:
    s_Show_Status = MENU-ITEM _Show_Status:CHECKED IN MENU mnu_Options .
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON VALUE-CHANGED OF MENU-ITEM _Save_Settings IN MENU mnu_Options
DO:
    s_Save_Settings = MENU-ITEM _Save_Settings:CHECKED IN MENU mnu_Options .
END.
&ENDIF

/*-----------   Help Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

ON CHOOSE OF MENU-ITEM _Help_Topics IN MENU mnu_help
DO:
  DO ON STOP UNDO , LEAVE:
      RUN adecomm/_adehelp.p ("comp", "TOPICS", ?, ?).
  END.
END.

&ENDIF

ON CHOOSE OF MENU-ITEM _Menu_Messages IN MENU mnu_Help
DO:
    RUN _RunProc ( INPUT "prohelp/_msgs.p" ).
END.

ON CHOOSE OF MENU-ITEM _Menu_Recent IN MENU mnu_Help
DO:
    RUN _RunProc ( INPUT "prohelp/_rcntmsg.p" ).
END.

ON CHOOSE OF MENU-ITEM _About in menu mnu_help
DO:
  DO ON STOP UNDO, LEAVE:
      RUN adecomm/_about.p ("Application Compiler", "adeicon/comp%").
  END.
END.

/*-----------   Popup Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM m_Add IN MENU mnu_Popup
  RUN AddListItem.

ON CHOOSE OF MENU-ITEM m_Modify IN MENU mnu_Popup
  RUN ModifyListItem.

ON CHOOSE OF MENU-ITEM m_Delete IN MENU mnu_Popup
  RUN DeleteListItem.

ON CHOOSE OF MENU-ITEM m_StartComp IN MENU mnu_Popup
  RUN StartCompile.

/*----------------------------------------------------------------------
                    Internal Procedures
----------------------------------------------------------------------*/
{ adecomp/acprocs.i }

/*------------------------- MAIN --------------------------------------*/
DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:

  /* ===================================================================== */
  /*                        TOOL RUNNING CHECK                             */
  /* ===================================================================== */
  /* If this ADE Tool is already running, don't run again. Return. */
  /* The adecomm tool routine sets tool_bomb. */
  IF ( tool_bomb = TRUE ) THEN RETURN.

  /* =====================================================================*/
  /*                             LICENSE CHECK                             */
  /* ===================================================================== */
  ASSIGN Get_License = GET-LICENSE ("COMPILER-TOOL").
  IF ( Get_License  <> 0 )
  THEN DO:
    CASE Get_License :
      WHEN 1 OR WHEN 3 THEN
        MESSAGE "A license for the" {&COMP_NAME} "is not available."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      WHEN 2 THEN
        MESSAGE "Your copy of the" {&COMP_NAME} "is past it's expiration date."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END CASE.
    LEAVE /* Main_Block */.
  END.


    IF SESSION:WINDOW-SYSTEM <> "TTY" THEN
    DO:
      CREATE WINDOW win_ProMake
      ASSIGN
          MENUBAR         = MENU mnu_ProMake:HANDLE
          TITLE          = s_Appl_Title
          MESSAGE-AREA         = NO
          STATUS-AREA         = YES
          SCROLL-BARS         = NO
          RESIZE         = YES
          HEIGHT-CHARS         = FRAME main:HEIGHT-CHARS
          WIDTH-CHARS         = FRAME main:WIDTH-CHARS
          MAX-BUTTON          = NO
      .
      /* Load the Compiler's minimized icon. */
      ASSIGN Temp = win_ProMake:LOAD-ICON("adeicon/comp%").
    END.
    ELSE DO:
        win_Promake         = DEFAULT-WINDOW.
        win_Promake:MENUBAR = MENU mnu_ProMake:HANDLE.
    END.

    
    /* save current window handle */
    ASSIGN
    win_OldCurrent = CURRENT-WINDOW
        CURRENT-WINDOW    = win_Promake
    .  /* END ASSIGN */

  { adecomm/okrun.i 
      &forcedef = yes
      &FRAME="frame EditorDisplay" 
      &BOX="s_rct_bottom"
      &OK="b_ViewOK"
      &CANCEL="b_CompileCancel"
      &HELP="b_CompileHelp"
  }

    RUN SetDefaults ( INPUT win_Promake ).

    /*
    ** Make a char field like PROPATH but with the expanded name of each
    ** PROPATH directory.
    */

&IF "{&OPSYS}" = "VMS"
&THEN
    ASSIGN
	FILE-INFO:FILE-NAME = "[]"
	vms_cwd = FILE-INFO:FULL-PATHNAME.
&ENDIF

    DO t_int = 1 to num-entries(PROPATH):
      ASSIGN
&IF "{&OPSYS}" = "VMS"
&THEN
	FILE-INFO:FILE-NAME = MAXIMUM(vms_cwd, ENTRY(t_int,PROPATH))
&ELSE
        FILE-INFO:FILE-NAME = MAXIMUM(".",ENTRY(t_int,PROPATH))
&ENDIF
        vQualifiedProPath =  vQualifiedProPath + "," + FILE-INFO:FULL-PATHNAME.
    END.
    /* Take off the leading comma */
    SUBSTR(vQualifiedProPath,1,1) = "".
    
    /* Retrieve settings from .INI or .Xdefaults and initialize menu
       settings. 
    */
    IF SESSION:WINDOW-SYSTEM <> "TTY" THEN
      RUN GetSetUp.ip.
    ASSIGN MENU-ITEM _Show_Status:CHECKED IN MENU mnu_Options = s_Show_Status
    .  /* END ASSIGN */

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    ASSIGN
        MENU-ITEM _Save_Settings:CHECKED IN MENU mnu_Options = s_Save_Settings
    .  /* END ASSIGN */
    &ENDIF

    /* Initialize Procedure List Items. */
    RUN InitListItems .

    ENABLE ALL WITH FRAME main.
    RUN UpdateList.

    IF NOT AVAILABLE ListItem
    THEN DO:
        APPLY "ENTRY" TO btn_Add IN FRAME main.
        RUN EnableStart ( INPUT NO ).
    END.

    DISPLAY s_saver s_rmoldr s_subdirs s_ifnor WITH FRAME main.

    /* Attach popup menu. */
    ASSIGN BROWSE B_Compile:POPUP-MENU = MENU mnu_Popup:HANDLE.

    /* Set global active ade tool procedure handle to this tool. */
    ASSIGN h_ade_tool = THIS-PROCEDURE.

    REPEAT ON STOP UNDO, RETRY ON ENDKEY UNDO, RETRY ON ERROR UNDO, RETRY :

          WAIT-FOR    CHOOSE       OF MENU-ITEM _Exit IN MENU mnu_File
                   OR WINDOW-CLOSE OF win_Promake
          . /* WAIT-FOR */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
          Key_Value = STRING (s_Save_Settings).
          USE "" NO-ERROR.

          REPEAT ON STOP UNDO, RETRY ON ERROR UNDO, RETRY:
            IF NOT RETRY
            THEN DO:
                 PUT-KEY-VALUE SECTION {&CompSect} KEY "SaveSettings" 
                               VALUE Key_Value NO-ERROR.
                 IF ERROR-STATUS:ERROR THEN STOP.
                 
                 IF ( s_Save_Settings = YES ) 
                 THEN DO:
                      CLOSE QUERY Qry_ListItem.
                      ASSIGN  INPUT FRAME main s_saver
                              INPUT FRAME main s_rmoldr
                              INPUT FRAME main s_subdirs
                              INPUT FRAME main s_ifnor.
                      RUN PutSetUp.ip.
                 END.
             END.
             ELSE RUN adeshar/_puterr.p (INPUT "Application Compiler" ,
                                         INPUT win_Promake ).
             LEAVE.
          END.

          /* Close PROGRESS Help Window if open. */
          DO ON STOP UNDO, LEAVE: /* ON STOP prevents infinite RETRY loop. */
              RUN adecomm/_adehelp.p ( INPUT "comp" , INPUT "QUIT" ,
                                       INPUT ? , INPUT ? ).
          END.
&ENDIF
          LEAVE.
    END.

    CLOSE QUERY Qry_ListItem.
    HIDE win_Promake.
    DISABLE ALL WITH FRAME main.
    STATUS INPUT.
    STATUS DEFAULT.
    
    IF ( SESSION:WINDOW-SYSTEM <> "TTY" )
    THEN DO:
        DELETE WIDGET win_Promake.
    END.
END. /* MAIN */
CURRENT-WINDOW = win_OldCurrent.
