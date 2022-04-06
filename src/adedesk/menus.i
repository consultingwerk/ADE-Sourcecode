/*********************************************************************
* Copyright (C) 2000-2015 by Progress Software Corporation.          *
* All rights reserved. Prior versions of this work may contain       *
* portions contributed by participants of Possenet.                  *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  menus.i
  DEFINE MENUS and Triggers for ADE Desktop.
----------------------------------------------------------------------------*/

/*-----------------------------  DEFINE MENUS   -----------------------------*/

DEFINE SUB-MENU mnu_New
    MENU-ITEM mnu_new_db     LABEL "&Database..."     
    MENU-ITEM mnu_new_proc   LABEL "&Procedure".
    
DEFINE SUB-MENU mnu_Open
    MENU-ITEM mnu_open_db    LABEL "&Database..."     
    MENU-ITEM mnu_open_proc  LABEL "&Procedure...".

DEFINE SUB-MENU mnu_File
    SUB-MENU mnu_New         LABEL "&New"
    SUB-MENU mnu_Open        LABEL "&Open"
    RULE
    MENU-ITEM _Exit          LABEL "E&xit".

{ adecomm/toolmenu.i }

DEFINE SUB-MENU mnu_Pref
&IF {&TOOL_STACKING} = 1 &THEN
    MENU-ITEM mnu_enable     LABEL {&ENABLE_PREF}
&ENDIF
    MENU-ITEM mnu_hide       LABEL "&Minimize on Use" TOGGLE-BOX.

DEFINE SUB-MENU mnu_Help SUB-MENU-HELP
    MENU-ITEM _Help_Master   LABEL "OpenEdge &Master Help"
    MENU-ITEM _Help_Topics   LABEL "Desktop &Help Topics"
    RULE
    MENU-ITEM _Menu_Messages LABEL "M&essages..."
    MENU-ITEM _Menu_Recent   LABEL "&Recent Messages..."
    RULE
    MENU-ITEM _About         LABEL "&About Desktop".

DEFINE MENU mnb_Desktop
    MENUBAR
    SUB-MENU mnu_File        LABEL "&File"
    SUB-MENU mnu_Tools       LABEL "&Tools"
    SUB-MENU mnu_Pref        LABEL "&Options"
    SUB-MENU mnu_Help        LABEL "&Help".

/*--------------------------------------------------------------------------*/
/*-------------------------  MENU TRIGGERS    ------------------------------*/
/*--------------------------------------------------------------------------*/

{ adecomm/toolrun.i
      &MENUBAR="mnb_Desktop"
}

/*------------------- ADDITIONAL DICTIONARY MENU TRIGGERS ---------------------*/

ON CHOOSE OF MENU-ITEM mnu_open_db IN MENU mnu_Open
DO:
    RUN NewOpenDatabase(INPUT 1).
END.

ON CHOOSE OF MENU-ITEM mnu_new_db IN MENU mnu_New
DO:
    RUN NewOpenDatabase (INPUT 0).
END.

ON CHOOSE OF btn_dict IN FRAME Develop
DO:
    RUN _RunTool(INPUT "_dict.p").
END.

/*--------------------- ADDITIONAL EDITOR TRIGGERS --------------------------*/

ON CHOOSE OF MENU-ITEM mnu_new_proc IN MENU mnu_New
DO:
    /* Add a STOP block, to catch user STOPS and restore the cursor */
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
        IF NOT RETRY THEN
	DO:
	    RUN disable_widgets.
	    RUN adecomm/_setcurs.p ("WAIT").
	    RUN adeedit/_proedit.p(INPUT ?, INPUT "NEW").
        END.
        RUN enable_widgets.
	RUN adecomm/_setcurs.p ("").
    END.
END.

ON CHOOSE OF MENU-ITEM mnu_open_proc IN MENU mnu_Open
DO:
    DEFINE VARIABLE filespec AS CHAR INITIAL ?.
    RUN EditorOpenCommonDialog(Input-Output filespec).
    IF filespec <> ? AND filespec <> "" THEN
    DO:
        /* Add a STOP block, to catch user STOPS and restore the cursor */
        DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
            IF NOT RETRY THEN
	    DO:
	        RUN disable_widgets.
	        RUN adecomm/_setcurs.p ("WAIT").
		RUN adeedit/_proedit.p(INPUT filespec, INPUT ?).
            END.
            RUN enable_widgets.
	    RUN adecomm/_setcurs.p ("").
        END.
    END.
END.

ON CHOOSE OF btn_edit IN FRAME Develop
DO:
    RUN _RunTool(INPUT "_edit.p").
END.

/*---------------------- ADDITIONAL AB TRIGGERS --------------------------*/

IF ade_licensed[{&UIB_IDX}] <> {&NOT_AVAIL} THEN DO:

    DEFINE VARIABLE mnu_new_win_wh AS WIDGET-HANDLE.
    DEFINE VARIABLE mnu_open_win_wh AS WIDGET-HANDLE.

    CREATE MENU-ITEM mnu_new_win_wh
        ASSIGN 
            LABEL       = "&Window / Dialog"
            PARENT      = MENU mnu_New:HANDLE IN MENU mnu_File
    TRIGGERS:
        ON CHOOSE  DO:
           /* Add a STOP block, to catch user STOPS and restore the cursor */
           DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
		IF NOT RETRY THEN
	        DO:
	            /* Profiler Checkpoint */
	            {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="start"}
	            {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="stotal"
	                          &infostr="[_desk.p] UIB starting from menu."}
		    RUN disable_widgets.
	            RUN adecomm/_setcurs.p ("WAIT").
                    /* Run UIB with special input to indicate NEW file */
                    RUN adeuib/_uibmain.p (INPUT "?,NEW").
		END.
		RUN enable_widgets.
	        RUN adecomm/_setcurs.p ("").
            END.
        END.
    END TRIGGERS.

    CREATE MENU-ITEM mnu_open_win_wh
        ASSIGN 
            LABEL       = "&Window / Dialog..."
            PARENT      = MENU mnu_Open:HANDLE IN MENU mnu_File
    TRIGGERS:
        ON CHOOSE DO:
            DEFINE VARIABLE filespec AS CHAR INITIAL ?.
            SYSTEM-DIALOG GET-FILE filespec FILTERS "Windows(*.w)" "*.w".      
            IF filespec <> ? and filespec <> "" THEN DO:
               /* Add a STOP block, to catch user STOPS and restore the cursor */
               DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
		    IF NOT RETRY THEN
		    DO:
  	                /* Profiler Checkpoint */
	                {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="start"}
	                {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="stotal"
	                              &infostr="[_desk.p] UIB starting from File->Open."}
			RUN disable_widgets.
	                RUN adecomm/_setcurs.p ("WAIT").
                        RUN adeuib/_uibmain.p (INPUT filespec).
		    END.
		    RUN enable_widgets.
	            RUN adecomm/_setcurs.p ("").
		END.
            END.
        END.
    END TRIGGERS.

    ON CHOOSE OF btn_uib IN FRAME Develop
    DO:
        /* Profiler Checkpoint */
        {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="start"}
        {adeshar/mp.i &timer="DESK_uibstart" &mp-macro="stotal"
                      &infostr="[_desk.p] UIB starting from button."}
        RUN _RunTool(INPUT "_ab.p").
    END.
END.

/*--------------------- ADDITIONAL RW TRIGGERS --------------------------*/
IF ade_licensed[{&RPT_IDX}] <> {&NOT_AVAIL} THEN DO:

    ON CHOOSE OF btn_rpt IN FRAME Develop
    DO:
        RUN _RunTool("results.p").
    END.
END.
/*--------------------- ADDITIONAL RB TRIGGERS --------------------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN

IF ade_licensed[{&RB_IDX}] <> {&NOT_AVAIL} THEN DO:

    ON CHOOSE OF btn_rb IN FRAME Develop
    DO:
        RUN _RunTool("_rbuild.p").
    END.
END.
&ENDIF
/*--------------------- ADDITIONAL DEBUGGER TRIGGERS --------------------------*/

IF ade_licensed[{&DBG_IDX}] <> {&NOT_AVAIL} THEN DO:

    DEFINE VARIABLE mnu_dbg_wh AS WIDGET-HANDLE.

    CREATE MENU-ITEM mnu_dbg_wh
        ASSIGN 
            LABEL       = "Application Debu&gger"
            PARENT      = MENU mnu_Tools:HANDLE IN MENU mnb_Desktop
    TRIGGERS:
        ON CHOOSE DO:
            RUN RunDebugger.
        END.        
    END TRIGGERS.

    ON CHOOSE OF btn_dbg IN FRAME Develop
    DO:
        RUN RunDebugger.
    END.
            
    ASSIGN mnu_dbg_wh:SENSITIVE = ade_licensed[{&DBG_IDX}] = {&INSTALLED}.

END.

PROCEDURE RunDebugger.
    DO ON STOP UNDO, LEAVE:    
        RUN disable_widgets.
        ASSIGN CURRENT-WINDOW = DEFAULT-WINDOW.
    
        /* Create widget pool to cleanup orphaned dynamic widgets.  The
           pool is implicitly deleted when this procedure ends.
        */
        CREATE WIDGET-POOL.
    
        /* Build table of existing Persistent procedures. Delete ones not in
           table after debugger session.
        */
        RUN BuildPersistProc.
    
        ASSIGN ok = DEBUGGER:DEBUG().
        IF NOT ok THEN
            MESSAGE "Unable to run the Application Debugger." 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END. /* DO ON STOP */
    
    /* Delete Persistent Procedures created by user debugger session. */
    RUN DeletePersistProc.
    
    ASSIGN DEFAULT-WINDOW:VISIBLE = NO
           CURRENT-WINDOW         = Desktop_Window.
           
    RUN enable_widgets.
END.

/*-------------------- ADDITIONAL TRANMAN TRIGGERS -----------------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN

IF ade_licensed[{&TRAN_IDX}] <> {&NOT_AVAIL} THEN DO:
    ON CHOOSE OF btn_tran IN FRAME Develop
    DO:
        RUN _RunTool("_tran.p").
    END.
END.
&ENDIF

/*-------------------- ADDITIONAL DWB TRIGGERS -----------------------*/
IF ade_licensed[{&DWB_IDX}] <> {&NOT_AVAIL} THEN DO:
    ON CHOOSE OF btn_dwb IN FRAME Develop
    DO:
        RUN adecomm/_rundwb.p.
    END.
END.

/*-------------------- ADDITIONAL DWB TRIGGERS -----------------------*/
IF ade_licensed[{&ARD_IDX}] <> {&NOT_AVAIL} THEN DO:
    ON CHOOSE OF btn_ard IN FRAME Develop
    DO:
        RUN adecomm/_runard.p.
    END.
END.

/*--------------------- HELP MENU TRIGGERS --------------------------*/

{ adedesk/deskhlp.i }

ON HELP OF FRAME Develop ANYWHERE
    RUN adecomm/_adehelp.p("desk", "TOPICS", {&PROGRESS_Desktop}, ?). 

ON CHOOSE OF MENU-ITEM _Help_Topics IN MENU mnu_Help
    RUN adecomm/_adehelp.p("desk", "TOPICS", ?, ?).

ON CHOOSE OF MENU-ITEM _Help_Master IN MENU mnu_Help
    RUN adecomm/_adehelp.p("mast", "TOPICS", ?, ?).

ON CHOOSE OF MENU-ITEM _Menu_Messages IN MENU mnu_Help
DO:
    RUN prohelp/_msgs.p.
END.

ON CHOOSE OF MENU-ITEM _Menu_Recent IN MENU mnu_Help
DO:
    RUN prohelp/_rcntmsg.p.
END.

ON CHOOSE OF MENU-ITEM _About IN MENU mnu_Help
    RUN adecomm/_about.p("Desktop", "adeicon/desktop").

/*--------------------- OTHER TRIGGERS --------------------------*/
ON CHOOSE OF MENU-ITEM _exit IN MENU mnu_File
DO:
    DEFINE VARIABLE OK_Close AS LOGICAL INIT TRUE NO-UNDO.
    DEFINE VARIABLE OK_Shut  AS LOGICAL INIT TRUE NO-UNDO.
    
    /* Now perform a close all for any open Procedure Windows belonging to
       the Desktop. The Procedure Windows created from ProTools are ones
       "owned" by the Desktop.
    */
    REPEAT ON STOP UNDO, LEAVE:
      RUN adecomm/_pwexit.p ( INPUT "" /* PW Parent ID */ ,
                              OUTPUT OK_Close ).
      LEAVE.
    END.
    /* Cancel the close event. */
    IF OK_Close <> TRUE THEN RETURN NO-APPLY.
    
    /* Issue the shutdown event for the Desktop. Don't stop the event, just
       notify those interested. */
    RUN adecomm/_adeevnt.p
        (INPUT 'Desktop', INPUT 'Shutdown', INPUT STRING(THIS-PROCEDURE),
         INPUT STRING(Desktop_Window), OUTPUT OK_Shut).
         
END.

&IF {&TOOL_STACKING} = 1 &THEN
ON CHOOSE OF MENU-ITEM mnu_Enable IN MENU mnu_Pref
DO:
    IF Pref_Enable = Yes THEN DO:
        Pref_Enable = NO.
        MENU-ITEM mnu_Enable:LABEL IN MENU mnu_Pref = {&ENABLE_PREF}.
    END.
    ELSE DO:
        Pref_Enable = YES.
        MENU-ITEM mnu_Enable:LABEL IN MENU mnu_Pref = "Disable &Panel After Selection".
   END.   
END.
&ENDIF

