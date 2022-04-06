/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: adecomm/toolsupp.i

Description:

This file is part of the foursome of toolmenu.i, toolrun.i, toolsupp.i,
_toollic.p.  These files together will build the standard tools menu used by
all the ADE applications.

Usage:

adecomm/toolsupp.i used to be part of toolrun.i which has traditionally been
included in the "Main procedure" part of each tool.  It contains two support
procedures (_RunTool and tools_check_call_stack) to support the creation of
tools menu at run-time based on which tools have been licensed.  In 9.0 the
UIB needs to dynamically morph the menus so the UIB needs to have a "mode-morph"
procedure to set up the tools menu.  This "internal" procedure cannot define
other internal procedures, so toolsupp.i was created so that the UIB can move
these procedure definitions "outside" of the "mode-morph" procedure.


NOTE: These procedures need two local variables
        tool_bomb - set true if the current tool should not be running
        tool_pgm_list - list of tools running (used to define triggers).  */


PROCEDURE _RunTool.
/*----------------------------------------------------------------------------
  Purpose     : Runs an ADE Tool.  Tool to run cannot have Run-Time Parameters
                or arguments.
  Syntax      :
                  RUN _RunTool( INPUT  p_Program_Name ) .

  Description :

  Author      : J. Palazzo
----------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Program_Name  AS CHARACTER NO-UNDO.

    /* DISABLE_WIDGETS_PROC is still used in adedict/_dictg.p */

    &IF DEFINED(DISABLE_ONLY) NE 0 &THEN
        &IF DEFINED(DISABLE_WIDGETS_PROC) EQ 0  
        &THEN RUN disable_widgets (INPUT p_Program_Name).
        &ELSE RUN {&DISABLE_WIDGETS_PROC} (INPUT p_Program_Name). &ENDIF
    &ELSE   
       REPEAT ON STOP UNDO, RETRY:
           IF NOT RETRY
           THEN DO:
               &IF DEFINED(DISABLE_WIDGETS_PROC) EQ 0  
               &THEN RUN disable_widgets.
               &ELSE RUN {&DISABLE_WIDGETS_PROC} . &ENDIF
               RUN VALUE( p_Program_Name ).
           END.
           &IF DEFINED(ENABLE_WIDGETS_PROC) EQ 0 
           &THEN RUN enable_widgets.
           &ELSE RUN {&ENABLE_WIDGETS_PROC} . &ENDIF
           LEAVE.
       END. /* REPEAT RETRY */
    &ENDIF
    
END PROCEDURE.

 
PROCEDURE tools_check_call_stack:
    /* --------------------------------------------------------------------
       This procedure is defined to minimize the use of Local variables in
       toolrun.i which might conflict with the calling program.
       It checks what ADE tools are running and 
     --------------------------------------------------------------------*/
    DEFINE VARIABLE i          AS INTEGER NO-UNDO INITIAL 1.
    DEFINE VARIABLE pgm_name   AS CHAR NO-UNDO.
    DEFINE VARIABLE this_tool  AS CHAR NO-UNDO.
    DEFINE VARIABLE this_count AS INTEGER INITIAL 0.

    &IF     DEFINED(EXCLUDE_ADMIN) <> 0 &THEN this_tool = {&ADMIN_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_DICT)  <> 0 &THEN this_tool = {&DICT_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_EDIT)  <> 0 &THEN this_tool = {&EDIT_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_UIB)   <> 0 &THEN this_tool = {&UIB_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_RPT)   <> 0 &THEN this_tool = {&RPT_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_RB)    <> 0 &THEN this_tool = {&RB_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_TRAN)  <> 0 &THEN this_tool = {&TRAN_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_VTRAN) <> 0 &THEN this_tool = {&VTRAN_ENTRYPT}.
    &ELSEIF DEFINED(EXCLUDE_COMP)  <> 0 &THEN this_tool = {&COMP_ENTRYPT}.
    &ELSE
        this_tool = ?.
    &ENDIF

    pgm_name = PROGRAM-NAME(i).
    i = i + 1.
    DO WHILE (pgm_name <> ?):
        IF pgm_name = this_tool THEN DO:
           this_count = this_count + 1.
           IF this_count > 1 THEN DO:
             MESSAGE "This tool is already running. PROGRESS cannot run more than" 
                      &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN &ELSE SKIP &ENDIF
                      "one copy of an ADE tool."
                      VIEW-AS ALERT-BOX ERROR.
             ASSIGN tool_bomb = True.
           END.
        END.
        ASSIGN
            tool_pgm_list = tool_pgm_list + "," + pgm_name
            pgm_name = PROGRAM-NAME(i)
            i = i + 1.
    END.

    &IF {&DEBUG} &THEN
    MESSAGE "tool_pgm_list" tool_pgm_list 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    &ENDIF

END PROCEDURE.


