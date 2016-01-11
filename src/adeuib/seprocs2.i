/*************************************************************/
/* Copyright (c) 1984-2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/******************************************************************************

Procedure: seprocs2.i

Syntax   : From adeuib/_oeidesync.w
       { adeuib/seprocs2.i }

Purpose  :          
    Include file with entry points from the AppBuilder Section Editor
    Only used by the OpenEdge IDE portion of the AppBuilder

Description:
    This include file contains entry points to the Section Editor procedures.
    The code for these produces implement the functionality that the 
    AppBuilder, and the section editor replacement: adeuib/_oeidesync.w,
    need in order to work with the OpenEdge IDE.
           
    RUN ADEPersistent IN hProc NO-ERROR.
       
Parameters:
Notes :
    The procedures that have DEBUG messages are not expected to be called.
    
    Should a DEBUG message be seen while using the AppBuilder, the 
    procedure functionality should be reviewed and implement for the 
    OpenEdge IDE. Some procedures may not need to be implemented.


Author: Edsel Garcia

History: 
    rkamboj 03/21/2012  Override button disabled in OEA AppBuilder for ADM1 objects (OE00217457)

*****************************************************************************/
DEFINE NEW SHARED STREAM WebStream.

PROCEDURE ADEPersistent:
END PROCEDURE.


PROCEDURE EdPopupDrop:
    DEFINE INPUT PARAMETER p_Editor AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EdPopupDrop'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EdPopupDrop IN hProc ( INPUT p_Editor ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditUndo:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EditUndo'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditUndo IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditCut:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EditCut'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditCut IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditCopy:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EditCopy'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditCopy IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditPaste:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EditPaste'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditPaste IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE IndentSelection:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pi_indent AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG IndentSelection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN IndentSelection IN hProc ( INPUT p_Buffer , INPUT pi_indent ) NO-ERROR.
END PROCEDURE.


PROCEDURE CommentSelection:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pl_comment AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG CommentSelection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN CommentSelection IN hProc ( INPUT p_Buffer , INPUT pl_comment ) NO-ERROR.
END PROCEDURE.


PROCEDURE CommentBox:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pl_comment AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG CommentBox'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN CommentBox IN hProc ( INPUT p_Buffer , INPUT pl_comment ) NO-ERROR.
END PROCEDURE.


PROCEDURE InsertFile:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG InsertFile'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertFile IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE FieldSelector:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG FieldSelector'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FieldSelector IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditHelp:
    DEFINE INPUT PARAMETER p_Editor AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Tool_Name AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_Context AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG EditHelp'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditHelp IN hProc ( INPUT p_Editor , INPUT p_Tool_Name , INPUT p_Context ) NO-ERROR.
END PROCEDURE.


PROCEDURE ApplyTab:
    DEFINE INPUT PARAMETER p_Editor AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Return_Error AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG ApplyTab'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ApplyTab IN hProc ( INPUT p_Editor , INPUT p_Return_Error ) NO-ERROR.
END PROCEDURE.


PROCEDURE ApplyBackTab:
    DEFINE INPUT PARAMETER p_Editor AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Return_Error AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG ApplyBackTab'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ApplyBackTab IN hProc ( INPUT p_Editor , INPUT p_Return_Error ) NO-ERROR.
END PROCEDURE.


PROCEDURE Indent_Selection:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pi_indent AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Applied AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Indent_Selection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Indent_Selection IN hProc ( INPUT p_Buffer , INPUT pi_indent , OUTPUT p_Applied ) NO-ERROR.
END PROCEDURE.


PROCEDURE Comment_Selection:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pl_comment AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Applied AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Comment_Selection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Comment_Selection IN hProc ( INPUT p_Buffer , INPUT pl_comment , OUTPUT p_Applied ) NO-ERROR.
END PROCEDURE.


PROCEDURE Comment_Box:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pl_comment AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Applied AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Comment_Box'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Comment_Box IN hProc ( INPUT p_Buffer , INPUT pl_comment , OUTPUT p_Applied ) NO-ERROR.
END PROCEDURE.


PROCEDURE Apply_Tab:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Applied AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Apply_Tab'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Apply_Tab IN hProc ( INPUT p_Buffer , OUTPUT p_Applied ) NO-ERROR.
END PROCEDURE.


PROCEDURE Apply_BackTab:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Applied AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Apply_BackTab'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Apply_BackTab IN hProc ( INPUT p_Buffer , OUTPUT p_Applied ) NO-ERROR.
END PROCEDURE.


PROCEDURE SetEdBufType:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_File_Name AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG SetEdBufType'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN SetEdBufType IN hProc ( INPUT p_Buffer , INPUT p_File_Name ) NO-ERROR.
END PROCEDURE.


PROCEDURE EditingOptions:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG EditingOptions'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN EditingOptions IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE SetEdHelpFile:
    MESSAGE 'DEBUG SetEdHelpFile'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN SetEdHelpFile IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE SetEditor:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG SetEditor'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN SetEditor IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE FindText:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG FindText'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FindText IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE ReplaceText:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG ReplaceText'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ReplaceText IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE ReplaceConfirm:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG ReplaceConfirm'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ReplaceConfirm IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE ReplaceAll:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG ReplaceAll'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ReplaceAll IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE FindAssign:
    DEFINE OUTPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG FindAssign'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FindAssign IN hProc ( OUTPUT p_Find_Criteria ) NO-ERROR.
END PROCEDURE.


PROCEDURE ReplaceAssign:
    MESSAGE 'DEBUG ReplaceAssign'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ReplaceAssign IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE FindNext:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG FindNext'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FindNext IN hProc ( INPUT p_Buffer , INPUT p_Find_Criteria ) NO-ERROR.
END PROCEDURE.


PROCEDURE FindPrev:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG FindPrev'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FindPrev IN hProc ( INPUT p_Buffer , INPUT p_Find_Criteria ) NO-ERROR.
END PROCEDURE.


PROCEDURE FindAgain:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Again_Find_Command AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p_Again_Find_Criteria AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG FindAgain'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN FindAgain IN hProc ( INPUT p_Buffer , INPUT p_Again_Find_Command , INPUT p_Again_Find_Criteria ) NO-ERROR.
END PROCEDURE.


PROCEDURE MakeQMark:
    DEFINE INPUT-OUTPUT PARAMETER p_String AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_Large AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG MakeQMark'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN MakeQMark IN hProc ( INPUT-OUTPUT p_String , INPUT p_Large ) NO-ERROR.
END PROCEDURE.


PROCEDURE GotoLine:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG GotoLine'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN GotoLine IN hProc ( INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE MoveCursor:
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Cursor_Line AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG MoveCursor'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN MoveCursor IN hProc ( INPUT p_Buffer , INPUT p_Cursor_Line ) NO-ERROR.
END PROCEDURE.


PROCEDURE SecEdWindow:
/*------------------------------------------------------------------------------
  Purpose: Represents the SecEdWindow procedure used by the section 
           in the AppBuilder.
  Parameters: 
  Notes: 
      - Parameter p_command uses a value "SE_OEOPEN" to indicate 
      that the section editor is being accessed in an open operation 
      from _open-w.p.
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER pi_section AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER pi_event AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_command AS CHARACTER NO-UNDO.
    
    /** During dev for 11.2 the various case statements here became dead ends
        We currently need the api since it is called from many places when the handle is valid
        So really...do nothing */
     
END PROCEDURE.

PROCEDURE AssignSEW:
    DEFINE INPUT PARAMETER se_section AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER se_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER se_event AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_U_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER p_TRG_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER p_hwin AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG AssignSEW'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN AssignSEW IN hProc ( INPUT se_section , INPUT se_recid , INPUT se_event , INPUT p_U_recid , INPUT p_TRG_recid , INPUT p_hwin ) NO-ERROR.
END PROCEDURE.


PROCEDURE se_store:
    DEFINE INPUT PARAMETER p_command AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG se_store'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_store IN hProc ( INPUT p_command ) NO-ERROR.
END PROCEDURE.


PROCEDURE se_upd_disp:
    DEFINE OUTPUT PARAMETER p_upd_disp AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG se_upd_disp'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_upd_disp IN hProc ( OUTPUT p_upd_disp ) NO-ERROR.
END PROCEDURE.


PROCEDURE SEClose:
    DEFINE INPUT PARAMETER p_command AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG SEClose'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN SEClose IN hProc ( INPUT p_command ) NO-ERROR.
END PROCEDURE.


PROCEDURE se_upd_widget_list:
    MESSAGE 'DEBUG se_upd_widget_list'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_upd_widget_list IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE se_emdrp:
    MESSAGE 'DEBUG se_emdrp'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_emdrp IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE se_set_title:
    DEFINE INPUT PARAMETER p_U_handle AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG se_set_title'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_set_title IN hProc ( INPUT p_U_handle ) NO-ERROR.
END PROCEDURE.


PROCEDURE se_help:
    DEFINE INPUT PARAMETER p_Help_Context AS INTEGER NO-UNDO.
    MESSAGE 'DEBUG se_help'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN se_help IN hProc ( INPUT p_Help_Context ) .
END PROCEDURE.


PROCEDURE build_event_list:
    MESSAGE 'DEBUG build_event_list'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN build_event_list IN hProc .
END PROCEDURE.


PROCEDURE build_proc_list:
    /* romiller remove begin
    DEFINE INPUT PARAMETER phList AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG build_proc_list'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN build_proc_list IN hProc ( INPUT phList ) NO-ERROR.
    romiller remove end add begin */
    /*--------------------------------------------------------------------------
      Purpose:       Sets the se_event  COMBO-BOX to a value appropriate for the
                     current window's procedures.
      Run Syntax:    RUN build_proc_list.
      Parameters:     phList - the handle of the selection list to populate.
      Notes:         Require a current win_recid.
    ---------------------------------------------------------------------------*/
    def input parameter  phList     as widget  no-undo.

    def var l_ok     as logical no-undo.
    def var procname as char    no-undo.

    /* Empty the current list. */
    ASSIGN phList:SCREEN-VALUE = ?
           phList:LIST-ITEMS = "".        
    /* Get all the procedures for the current UIB Design Object. */
    FOR EACH _SEW_TRG WHERE _SEW_TRG._wRECID = b_P._u-recid /* win_recid */
                      AND   _SEW_TRG._tSECTION = Type_Procedure :
      ASSIGN procname = _SEW_TRG._tEVENT
             l_ok     =  phList:ADD-LAST(procname).
    END.
    /* romiller add end */
END PROCEDURE.


PROCEDURE build_func_list:
    DEFINE INPUT PARAMETER phList AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG build_func_list'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN build_func_list IN hProc ( INPUT phList ) NO-ERROR.
END PROCEDURE.


PROCEDURE build_widget_list:
    DEFINE INPUT PARAMETER init_value AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG build_widget_list'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN build_widget_list IN hProc ( INPUT init_value ) NO-ERROR.
END PROCEDURE.


PROCEDURE Has_Freeform:
    DEFINE INPUT PARAMETER p_u-recid AS RECID NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Has_Freeform AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Has_Freeform'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Has_Freeform IN hProc ( INPUT p_u-recid , OUTPUT p_Has_Freeform ) NO-ERROR.
END PROCEDURE.


PROCEDURE Has_Trigger:
    DEFINE INPUT PARAMETER p_sew_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER p_event AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_has_trigger AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG Has_Trigger'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN Has_Trigger IN hProc ( INPUT p_sew_recid , INPUT p_event , OUTPUT p_has_trigger ) NO-ERROR.
END PROCEDURE.


PROCEDURE freeform_update:
    DEFINE INPUT PARAMETER p_u-recid AS RECID NO-UNDO.
    MESSAGE 'DEBUG freeform_update'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN freeform_update IN hProc ( INPUT p_u-recid ) NO-ERROR.
END PROCEDURE.


PROCEDURE GetAttribute:
    DEFINE INPUT PARAMETER p_Attribute AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Value AS CHARACTER NO-UNDO.
    CASE p_Attribute:
        WHEN "SE-WINDOW" THEN p_Value = STRING(h_sewin).
        OTHERWISE DO:
        END.
    END CASE.
    
END PROCEDURE.


PROCEDURE GetWidgetListName:
    DEFINE INPUT PARAMETER p_Name AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_Label AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_List_Item AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG GetWidgetListName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN GetWidgetListName IN hProc ( INPUT p_Name , INPUT p_Label , OUTPUT p_List_Item ) NO-ERROR.
END PROCEDURE.


PROCEDURE ChangeSection:
    DEFINE INPUT PARAMETER p_new_section AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG ChangeSection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ChangeSection IN hProc ( INPUT p_new_section ) NO-ERROR.
END PROCEDURE.


PROCEDURE NoProcs:
    DEFINE INPUT PARAMETER p_Type AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_oknew AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG NoProcs'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN NoProcs IN hProc ( INPUT p_Type , OUTPUT p_oknew ) NO-ERROR.
END PROCEDURE.


PROCEDURE ListBlocks:
    MESSAGE 'DEBUG ListBlocks'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN ListBlocks IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE NextSearchBlock:
    DEFINE INPUT PARAMETER p_Sect-List AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_Sect-First AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_Sect-Curr AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG NextSearchBlock'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN NextSearchBlock IN hProc ( INPUT p_Sect-List , INPUT p_Sect-First , INPUT-OUTPUT p_Sect-Curr ) NO-ERROR.
END PROCEDURE.


PROCEDURE GetNextSearchSection:
    DEFINE INPUT PARAMETER h_trg_win AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Sect-List AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_Sect-Curr AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_section AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_recid AS RECID NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p_event AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_ok AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG GetNextSearchSection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN GetNextSearchSection IN hProc ( INPUT h_trg_win , INPUT p_Sect-List , INPUT-OUTPUT p_Sect-Curr , INPUT-OUTPUT p_section , INPUT-OUTPUT p_recid , INPUT-OUTPUT p_event , OUTPUT p_ok ) NO-ERROR.
END PROCEDURE.


PROCEDURE GetSearchAllList:
    DEFINE INPUT PARAMETER h_trg_win AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_section AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER p_event AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Sect-List AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Sect-Curr AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG GetSearchAllList'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN GetSearchAllList IN hProc ( INPUT h_trg_win , INPUT p_section , INPUT p_recid , INPUT p_event , OUTPUT p_Sect-List , OUTPUT p_Sect-Curr ) NO-ERROR.
END PROCEDURE.


PROCEDURE change_trg:
    DEFINE INPUT PARAMETER new_section AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER new_recid AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER new_event AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER use_new_event AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER store_code AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER change_ok AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG change_trg'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN change_trg IN hProc ( INPUT new_section , INPUT new_recid , INPUT new_event , INPUT use_new_event , INPUT store_code , OUTPUT change_ok ) NO-ERROR.
END PROCEDURE.


PROCEDURE CheckSyntax:
    MESSAGE 'DEBUG CheckSyntax'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN CheckSyntax IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE UndoChange:
    MESSAGE 'DEBUG UndoChange'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN UndoChange IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE DeleteBlock:
    MESSAGE 'DEBUG DeleteBlock'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN DeleteBlock IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE NewBlock:
    RUN NewBlock IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE NewTriggerBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Edit->Insert->Trigger
    Run Syntax:     RUN NewTriggerBlock ( event_name ).
    Parameters:     p_new_event
    - p_new_event name of the event for the trigger
      ?     - prompt user for event name
      ""    - use default event for widget
      event - name of event
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_new_event AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE a_ok              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE event_list        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_cwin            AS WIDGET    NO-UNDO.
  DEFINE VARIABLE Invalid_List      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_command       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_recid         AS RECID     NO-UNDO.
  DEFINE VARIABLE new_spcl          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE proc_entry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE proc_list         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Smart_List        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Type              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Returns_Type      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Code_Block        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Define_As         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE window-handle     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Create_Block      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE code_type         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSuper_Proc       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Super_Procs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Super_Handles     AS CHARACTER NO-UNDO .
  DEFINE VARIABLE Super_Entries     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iItem             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lOK               AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE strt              AS INTEGER   NO-UNDO.
  
  DEFINE BUFFER b_U FOR _U.

      IF NOT VALID-HANDLE(_h_cur_widg) THEN RETURN.
      
      FIND _SEW_U WHERE _HANDLE = _h_cur_widg NO-LOCK NO-ERROR.
      IF NOT AVAILABLE _SEW_U THEN RETURN.
      IF _SEW_U._TYPE = "TEXT":U THEN RETURN.      
      IF _SEW_U._TYPE = "SmartObject":U THEN RETURN.
      new_recid = RECID(_SEW_U).      
      
      IF NOT CAN-QUERY(_h_cur_widg, "WINDOW":U) THEN RETURN.
      FIND b_P WHERE b_P._WINDOW-HANDLE = _h_cur_widg:WINDOW NO-LOCK NO-ERROR.
      /* For controls in a dialog-box, the _WINDOW-HANDLE field corresponds to the FRAME */
      IF NOT AVAILABLE b_P THEN
          FIND b_P WHERE b_P._WINDOW-HANDLE = _h_cur_widg:FRAME NO-LOCK NO-ERROR.
      /* When the dialog-box is selected, the handle is the actual widget */
      IF NOT AVAILABLE b_P THEN
          FIND b_P WHERE b_P._WINDOW-HANDLE = _h_cur_widg NO-LOCK NO-ERROR.    
      IF NOT AVAILABLE b_P THEN RETURN.

  ASSIGN se_section = "_CONTROL":U /* Type_Trigger */
         new_spcl   = ?.      
      
  IF p_new_event = ? THEN DO: /* Ask for a new event */
    ASSIGN p_new_event = editted_event.
    
    ASSIGN       
           Type           = IF AVAILABLE _SEW_U THEN _SEW_U._TYPE ELSE "BROWSE-COLUMN":U.
    DO ON STOP UNDO, LEAVE:
      IF TYPE eq "{&WT-CONTROL}" 
      THEN DO:
         /*
          * If the VBX is "halfway there" then warn the
          * user that NEW VBX event procedures aren't
          * available. This can happen when an existing
          * .w file was created with a VBX that the 
          * current user doesn't have a license for.
          */
         
         FIND _SEW_F WHERE RECID(_SEW_F) = _SEW_U._x-recid.
         IF _SEW_F._SPECIAL-DATA <> ? THEN
             MESSAGE "The {&WT-CONTROL}," _SEW_F._IMAGE-FILE ", is missing or unavailable" skip
                     "for" _SEW_U._NAME ". New {&WT-CONTROL} events cannot edited. Existing" skip
                     "{&WT-CONTROL} events and PROGRESS events can be edited."
             VIEW-AS ALERT-BOX INFORMATION.
             
             
         RUN adeuib/_ocxevnt.p (INPUT _SEW_U._HANDLE, INPUT "", OUTPUT event_list).
      END.
      IF LOOKUP(TYPE,"QUERY,FRAME,BROWSE,DIALOG-BOX":U) > 0 THEN DO:
        /* See if its a free form query */
        IF AVAILABLE _SEW_U THEN DO:
          IF CAN-FIND(FIRST _TRG WHERE _TRG._tEVENT = "OPEN_QUERY" AND
                                       _TRG._wRECID = RECID(_SEW_U)) THEN
            event_list = "FFQ":U.  /* Free Form Query */
        END.
      END.  /* If a query, frame, browse or dialog */

      /* Add any special events such as Data.<event>. Not used for BROWSE-COLUMN. */
      IF (TYPE NE "BROWSE-COLUMN":U) THEN
        ASSIGN event_list = TRIM(event_list + ",":u + b_P._events, ",").
      RUN adeuib/_selevnt.p
        (INPUT TYPE,
         INPUT (IF TYPE NE "BROWSE-COLUMN":U THEN _SEW_U._SUBTYPE ELSE ""),
         INPUT event_list,
         INPUT _cur_win_type,
         INPUT RECID(b_P),
         INPUT-OUTPUT p_new_event).
    END.
  END.
  ELSE DO:
    IF p_new_event = "" THEN
      RUN get_default_event(_SEW_U._TYPE, OUTPUT p_new_event).
  END.
  
    IF p_new_event <> "" THEN
    DO:
        Create_Block = NOT CAN-FIND(_SEW_TRG WHERE _tSECTION = se_section
                                               AND _wRECID   = new_recid
                                               AND _tEVENT   = p_new_event).
    END.
    ELSE
        Create_Block = FALSE.
    
    IF Create_Block THEN
    DO:
      CREATE _SEW_TRG.
      ASSIGN _SEW_TRG._tSECTION = se_section
             _SEW_TRG._tSPECIAL = new_spcl
             _SEW_TRG._pRECID   = RECID(b_P)
             _SEW_TRG._wRECID   = new_recid
             _SEW_TRG._tEVENT   = p_new_event
             _SEW_TRG._tCODE    = ?
             a_ok               = yes.
    END.

    /* If we created a new one, or if it is ok to go to the old one, then go */
    IF a_ok THEN DO:
      /* Fill the new trigger unless 1) it is special or 2) we are
         viewing an existing code block. */
      IF new_spcl = ? THEN
      DO:
              DO:
                /* For all special events (e.g., OCX.event), store it in _tSPECIAL. */
                IF NUM-ENTRIES(p_new_event, ".":u) > 1 THEN
                DO:
                    ASSIGN _SEW_TRG._tSPECIAL = p_new_event
                           _SEW_TRG._tTYPE    = "_CONTROL-PROCEDURE" NO-ERROR.
                END.
                    
                IF AVAILABLE _SEW_U AND _SEW_U._TYPE eq "{&WT-CONTROL}" THEN
                  RUN adeshar/_ocxdflt.p
                            (p_new_event, se_section, new_recid, OUTPUT _SEW_TRG._tCODE). 
                ELSE DO:
                  ASSIGN code_type = se_section. /* Default code type. */
                  IF (p_new_event = "DEFINE_QUERY") THEN
                    ASSIGN code_type = "_DEFINE-QUERY":U.
                  ELSE IF (_SEW_TRG._tTYPE <> "") THEN
                    ASSIGN code_type = p_new_event.
                  RUN adeshar/_coddflt.p (code_type, new_recid, OUTPUT _SEW_TRG._tCODE).
                  /* Add comment to trigger block to force adeshar/_gen4gl.p to save it. */
                  strt = INDEX(_SEW_TRG._tCODE,":") + 1.
                  IF strt > 1 THEN DO:
                    _SEW_TRG._tCODE = SUBSTRING(_SEW_TRG._tCODE, 1, strt) +
                                 "  /* new trigger */":U +
                                 SUBSTRING(_SEW_TRG._tCODE, strt + 1).
                  END.                  
                END.
              END.

          RUN adecomm/_adeevnt.p ("UIB":U, "New":U, INTEGER(RECID(_SEW_TRG)),
                                        se_section, OUTPUT lOK).
      END.

      IF Create_Block THEN
      DO:
        DEFINE VARIABLE cLinkedFile   AS CHARACTER  NO-UNDO.
        
        RUN adeuib/_winsave.p (b_P._WINDOW-HANDLE, FALSE).

       /* If treeview, update it. */
       IF VALID-HANDLE(b_P._tv-proc) THEN
       DO:
         RUN addCodeNode IN b_P._tv-proc
               (INPUT se_section, INPUT new_recid, INPUT se_event).
       END.

        RUN getLinkedFileName IN hOEIDEService (b_P._WINDOW-HANDLE, OUTPUT cLinkedFile).
        /* IF cLinkedFile > "" THEN
          RUN syncFromAB (cLinkedFile). */ 
      END.      
  END.

IF NOT AVAILABLE b_P THEN RETURN.
IF b_P._save-as-file = ? THEN RETURN.

DEFINE VARIABLE cWidgetName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWindowName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindowHandle AS HANDLE     NO-UNDO.

/* If the specified event exist, then use findAndSelect to select it in the editor */      
FIND _SEW_TRG WHERE _SEW_TRG._tSECTION = se_section
                AND _SEW_TRG._wRECID   = new_recid
                AND _SEW_TRG._tEVENT   = p_new_event NO-LOCK NO-ERROR.
IF NOT AVAILABLE _SEW_TRG THEN RETURN.
              
cWidgetName = _SEW_U._NAME.
                      
FIND _SEW_U WHERE RECID(_SEW_U) = _SEW_TRG._wrecid NO-LOCK NO-ERROR.

cWidgetName = IF AVAILABLE _SEW_U THEN _SEW_U._name ELSE ?.
hWindowHandle = IF AVAILABLE _SEW_U THEN _SEW_U._window-handle ELSE ?.
IF hWindowHandle <> ? THEN
DO:
  FIND FIRST _SEW_U WHERE _SEW_U._handle = hWindowHandle NO-LOCK NO-ERROR.
  cWindowName = IF AVAILABLE _SEW_U THEN _SEW_U._name ELSE ?.
END.

IF INDEX(p_new_event, ".":U) > 0 THEN /* OCX event */
  findAndSelect(getProjectName(),
  b_P._save-as-file,
              '"' + "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ":U 
                  + cWidgetName + " " + cWindowName + '"', TRUE).
ELSE
DO:
  IF _h_cur_widg:TYPE = "FRAME":U THEN
      cWidgetName = "FRAME ":U + cWidgetName.
  findAndSelect(getProjectName(), b_P._save-as-file,
              '"' + "ON ":U + p_new_event + " OF ":U + cWidgetName + '"', TRUE). 
END.              
               
END PROCEDURE.

PROCEDURE GetOverrides.
  /*-------------------------------------------------------------------------
    Purpose:        Called from IDE to get list of overrides for Add Procedure and
                    Add Function wizards 
    Run Syntax:     RUN NewProcedureBlock.
    Parameters:     
  ---------------------------------------------------------------------------*/
    define input  parameter pwin as handle  no-undo.
    define input parameter p_se_section as character no-undo.
    define output parameter Smart_List as longchar no-undo.
    define variable Super_Procs       as character no-undo.
    define variable Super_Handles     as character no-undo .
    define variable Invalid_List      as character no-undo.
    define variable hFrame as handle no-undo.
    
    find b_P where b_P._WINDOW-HANDLE = pwin no-lock no-error.
    if not avail b_p then 
    do:
        hFrame = pwin:first-child.
        find b_P where b_P._WINDOW-HANDLE = hFrame no-lock no-error.
    end.
    if not avail b_p then 
        return.
        
    run Get_Proc_Lists
          (input no , output Invalid_List , output Smart_List).
    
    case p_se_section:
         when Type_Procedure then
         do:
             /* Build list of the object's Super Procedure internal procedures. */
             run get-super-procedures in _h_mlmgr ( input string(b_P._WINDOW-HANDLE) ,
                                                    input-output Super_Procs ,
                                                    input-output Super_Handles).
                                                    
             run get-super-procs in _h_mlmgr (input Super_Handles ,
                                              input-output Smart_List).
        end.
        when Type_Function then
        do:
            /* Build list of the object's Super Procedure user functions. */
            run get-super-procedures in _h_mlmgr ( input string(b_P._WINDOW-HANDLE) ,
                                                   input-output Super_Procs ,
                                                   input-output Super_Handles).
            run get-super-funcs in _h_mlmgr (input Super_Handles ,
                                             input-output Smart_List).
        end.                                   
    end.    
end procedure.

PROCEDURE GetOverrideBody.
  /*-------------------------------------------------------------------------
    Purpose:        Called from IDE to override body
                    Add Function wizards 
    Run Syntax:     RUN NewProcedureBlock.
    Parameters:     
  ---------------------------------------------------------------------------*/
    define input  parameter pwin as handle  no-undo.
    define input parameter p_se_section as character no-undo.
    define input  parameter pcName as character no-undo.
    define output parameter pcode  as longchar no-undo.
    
    define variable Smart_List        as character no-undo.
    define variable Super_Procs       as character no-undo.
    define variable Super_Handles     as character no-undo .
    define variable Invalid_List      as character no-undo.
    define variable hProc             as handle no-undo.
    define variable cDummy            as character no-undo.
    define variable lDummy            as logical no-undo.
    define variable cCode             as character no-undo.
    define variable i1                as integer no-undo.
    define variable i2                as integer no-undo.
    define variable cReturn           as character no-undo.
    define variable hFrame            as handle no-undo.
    find b_P where b_P._WINDOW-HANDLE = pwin no-lock no-error.
    if not avail b_p then 
    do:
        hFrame = pwin:first-child.
        find b_P where b_P._WINDOW-HANDLE = hFrame no-lock no-error.
    end.
    if not avail b_p then 
        return.
    
    run Get_Proc_Lists
          (input no , output Invalid_List , output Smart_List).
    
    case p_se_section:
         when Type_Procedure then
         do:
             /* Build list of the object's Super Procedure internal procedures. */
             run get-super-procedures in _h_mlmgr ( input string(b_P._WINDOW-HANDLE) ,
                                                    input-output Super_Procs ,
                                                    input-output Super_Handles).
                                                    
             run get-super-procs in _h_mlmgr (input Super_Handles ,
                                              input-output Smart_List).
             

             RUN adeuib/_newproc.w persistent set hProc( INPUT Super_Handles   ,
                                     INPUT "OVERRIDE"     ,
                                     INPUT Smart_List      ,
                                     INPUT Invalid_List    ,
                                     INPUT-OUTPUT cDummy ,
                                     OUTPUT cDummy           ,
                                     OUTPUT cDummy     ,
                                     OUTPUT lDummy           ) .
             
             run getCode in hProc (pcName,"_LOCAL",output ccode).
             if cCode = "" then 
             do:
                  RUN get-local-template IN _h_mlmgr (pcName, OUTPUT ccode).
                  /* return body - ide adds comments and end procedure */
                  i1 = index(ccode,"*/") + 2. 
                  i2 = index (ccode,"END PROCEDURE.").
                  if(i1 > 2 and i2 > i1) then 
                     cCode =  substr(ccode,i1,i2 - i1).
                  else if i2 > 0 then
                     cCode =  substr(ccode,1,i2).
                 
             end.
             pcode = ccode.    
        end.
        when Type_Function then
        do:
            /* Build list of the object's Super Procedure user functions. */
            run get-super-procedures in _h_mlmgr ( input string(b_P._WINDOW-HANDLE) ,
                                                   input-output Super_Procs ,
                                                   input-output Super_Handles).
            run get-super-funcs in _h_mlmgr (input Super_Handles ,
                                             input-output Smart_List).
            run adeuib/_newfunc.w persistent set hProc ( input Super_Handles   ,
                                    input "OVERRIDE"     ,
                                    input Smart_List      ,
                                    input Invalid_List    ,
                                    input-output cDummy ,
                                    output cDummy,
                                    output cDummy,
                                    output cDummy,
                                    output cDummy,
                                    output lDummy).
             run getCode in hProc (pcName,"_LOCAL",output ccode,output cReturn). 
             pcode = ccode.                          
        end.                                   
    end.
    finally:
        if valid-handle(hProc) then
            delete procedure hProc.		
    end finally.    
end procedure.


PROCEDURE NewCodeBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Edit->Insert->Procedure
    Run Syntax:     RUN NewProcedureBlock.
    Parameters:     
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_se_section AS CHARACTER NO-UNDO.
     
  DEFINE VARIABLE proc_type         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_event         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_name          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE a_ok              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE event_list        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_cwin            AS WIDGET    NO-UNDO.
  DEFINE VARIABLE Invalid_List      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_command       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_recid         AS RECID     NO-UNDO.
  DEFINE VARIABLE new_spcl          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE proc_entry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE proc_list         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Smart_List        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Type              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Returns_Type      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Code_Block        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Define_As         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE window-handle     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Create_Block      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE code_type         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSuper_Proc       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE Super_Procs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Super_Handles     AS CHARACTER NO-UNDO .
  DEFINE VARIABLE Super_Entries     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iItem             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lOK               AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE strt              AS INTEGER   NO-UNDO. 
  
  
      IF NOT VALID-HANDLE(_h_win) THEN RETURN.
      FIND b_P WHERE b_P._WINDOW-HANDLE = _h_win NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b_P THEN RETURN.

      new_recid = b_P._u-recid.
      se_section = p_se_section.
      
        
    /* Ask for a new procedure name. */
    ASSIGN new_event = ""
           new_name  = ""
           proc_type = ?    /* Standard new procedure */
           . /* END ASSIGN */

    /* Get names of a) all procs & funcs and b) ADM SmartMethod and SmartFunction
       (subset). Both take care of items defined in the current object as well as
       in Included Libraries. */
    IF se_section = Type_Procedure OR se_section = Type_Function THEN
    DO:
      RUN Get_Proc_Lists
          (INPUT NO , OUTPUT Invalid_List , OUTPUT Smart_List).
    
      ASSIGN new_command = "NEW":U.
      CASE se_section:
        WHEN Type_Procedure THEN
        DO:
          /* Build list of the object's Super Procedure internal procedures. */
          RUN get-super-procedures IN _h_mlmgr ( INPUT STRING(_h_win) ,
                                                 INPUT-OUTPUT Super_Procs ,
                                                 INPUT-OUTPUT Super_Handles).
          RUN get-super-procs IN _h_mlmgr (INPUT Super_Handles ,
                                           INPUT-OUTPUT Smart_List).
          RUN adeuib/_newproc.w ( INPUT Super_Handles   ,
                                  INPUT new_command     ,
                                  INPUT Smart_List      ,
                                  INPUT Invalid_List    ,
                                  INPUT-OUTPUT new_name ,
                                  OUTPUT Type           ,
                                  OUTPUT Code_Block     ,
                                  OUTPUT a_OK           ).
        END.
        WHEN Type_Function THEN
        DO:
          /* Build list of the object's Super Procedure user functions. */
          RUN get-super-procedures IN _h_mlmgr ( INPUT STRING(_h_win) ,
                                                 INPUT-OUTPUT Super_Procs ,
                                                 INPUT-OUTPUT Super_Handles).
          RUN get-super-funcs IN _h_mlmgr (INPUT Super_Handles ,
                                           INPUT-OUTPUT Smart_List).
          RUN adeuib/_newfunc.w ( INPUT Super_Handles   ,
                                  INPUT new_command     ,
                                  INPUT Smart_List      ,
                                  INPUT Invalid_List    ,
                                  INPUT-OUTPUT new_name ,
                                  OUTPUT Type           ,
                                  OUTPUT Returns_Type   ,
                                  OUTPUT Define_As      ,
                                  OUTPUT Code_Block     ,
                                  OUTPUT a_OK           ).
          
        END.
      END CASE.
      IF a_OK = FALSE THEN RETURN "_CANCEL":u.
    END.
    
    
    IF Type = "_DEFAULT":U THEN
    CASE new_name :
        WHEN Adm_Create_Obj THEN
            ASSIGN proc_type = Type_Adm_Create_Obj
                   Type      = proc_type.
        WHEN Adm_Row_Avail THEN
            ASSIGN proc_type = Type_Adm_Row_Avail
                   Type      = proc_type.
        WHEN Enable_UI THEN
            ASSIGN proc_type = Type_Def_Enable
                   Type      = proc_type.
        WHEN Disable_UI THEN
            ASSIGN proc_type = Type_Def_Disable
                   Type      = proc_type.
        WHEN Send_Records THEN
            ASSIGN proc_type = Type_Send_Records
                   Type      = proc_type.
    END CASE.
               
    ASSIGN new_event   = new_name
           new_spcl    = proc_type. /* Use same "language" as _CONTROL above */  
           
    IF new_event <> "" THEN
    DO:
        Create_Block = NOT CAN-FIND(_SEW_TRG WHERE _tSECTION = se_section
                                               AND _wRECID   = new_recid
                                               AND _tEVENT   = new_event).
    END.
    ELSE
        Create_Block = FALSE.

    IF Create_Block THEN
    DO:
      CREATE _SEW_TRG.
      ASSIGN _SEW_TRG._tSECTION = se_section
             _SEW_TRG._tSPECIAL = new_spcl
             _SEW_TRG._pRECID   = RECID(b_P)
             _SEW_TRG._wRECID   = new_recid
             _SEW_TRG._tEVENT   = new_event
             _SEW_TRG._tCODE    = ?
             _SEW_TRG._DB-REQUIRED = NO WHEN (proc_type = Type_Adm_Create_Obj)
             a_ok               = yes.
    END.

    /* If we created a new one, or if it is ok to go to the old one, then go */
    IF a_ok THEN DO:
      /* Fill the new trigger unless 1) it is special or 2) we are
         viewing an existing code block. */
    IF new_spcl = ? THEN
    DO:
      /* romiller add begin */
      IF Type = Type_Local AND VALID-HANDLE( _h_mlmgr ) AND Code_Block = "" THEN 
      /* romiller add begin */
      DO:
        /* romiller add end */
        RUN get-local-template IN _h_mlmgr ( INPUT  new_name ,
                                             OUTPUT _SEW_TRG._tCODE ).
      END.
      ELSE
        /* romiller add end */
      DO:
      
          CASE se_section:
            WHEN Type_Procedure THEN DO:
              /* If Code_Block is Nul, then get standard code default for a 
                 procedure. Otherwise, its an override whose code was generated by
                 _newproc.p. */
              IF (Code_Block = "") THEN
                RUN adeshar/_coddflt.p (se_section, new_recid, OUTPUT _SEW_TRG._tCODE).
              ELSE
                ASSIGN _SEW_TRG._tCode = Code_Block.
            END.
            WHEN Type_Function THEN DO:
              /* Function blocks are built by _newfunc.w, not _coddflt.p. */
              ASSIGN _SEW_TRG._tCODE = Code_Block.
            END.                      
          END CASE.
          RUN adecomm/_adeevnt.p ("UIB":U, "New":U, INTEGER(RECID(_SEW_TRG)),
                                        se_section, OUTPUT lOK).
      END.
      END.

      RELEASE _SEW_TRG. /* Releases _TRG record */

      IF Create_Block THEN
      DO:
        DEFINE VARIABLE cLinkedFile   AS CHARACTER  NO-UNDO.
        
        RUN adeuib/_winsave.p (b_P._WINDOW-HANDLE, FALSE).

       /* If treeview, update it. */
       IF VALID-HANDLE(b_P._tv-proc) THEN
       DO:
         RUN addCodeNode IN b_P._tv-proc
               (INPUT se_section, INPUT new_recid, INPUT se_event).
       END.

        RUN getLinkedFileName IN hOEIDEService (b_P._WINDOW-HANDLE, OUTPUT cLinkedFile).
        IF cLinkedFile > "" THEN
          RUN syncFromAB (cLinkedFile).
      END.      
  END.

IF NOT AVAILABLE b_P THEN RETURN.
IF b_P._save-as-file = ? THEN RETURN.

DEFINE VARIABLE cWidgetName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWindowName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindowHandle AS HANDLE     NO-UNDO.

/* If the specified event exist, then use findAndSelect to select it in the editor */      
FIND _SEW_TRG WHERE _SEW_TRG._tSECTION = se_section
                AND _SEW_TRG._wRECID   = new_recid
                AND _SEW_TRG._tEVENT   = new_event NO-LOCK NO-ERROR.

IF NOT AVAILABLE _SEW_TRG THEN RETURN.

IF _h_win <> ? THEN
DO:
  FIND FIRST _SEW_U WHERE _SEW_U._handle = _h_win NO-LOCK NO-ERROR.
  cWindowName = IF AVAILABLE _SEW_U THEN _SEW_U._name ELSE ?.
END.

findAndSelect(getProjectName(),
  b_P._save-as-file,
            '"' + "&ANALYZE-SUSPEND _UIB-CODE-BLOCK ":U + se_section + " "
                  + new_event + " " + cWindowName + '"', TRUE ).
    
END.

PROCEDURE RenameProc:
    MESSAGE 'DEBUG RenameProc'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN RenameProc IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE check_UIB_current_window:
    /* RUN check_UIB_current_window IN hProc NO-ERROR. */
END PROCEDURE.


PROCEDURE check_store_trg:
    DEFINE INPUT PARAMETER check_only AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER print_section AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER code_ok AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG check_store_trg'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN check_store_trg IN hProc ( INPUT check_only , INPUT print_section , OUTPUT code_ok ) NO-ERROR.
END PROCEDURE.


PROCEDURE display_trg:
    MESSAGE 'DEBUG display_trg'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN display_trg IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE CodeModified:
    DEFINE INPUT PARAMETER p_Modified AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG CodeModified'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN CodeModified IN hProc ( INPUT p_Modified ) NO-ERROR.
END PROCEDURE.


PROCEDURE insert_file:
    DEFINE INPUT PARAMETER p_Mode AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_Buffer AS HANDLE NO-UNDO.
    MESSAGE 'DEBUG insert_file'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN insert_file IN hProc ( INPUT p_Mode , INPUT p_Buffer ) NO-ERROR.
END PROCEDURE.


PROCEDURE get_default_event.
  /*--------------------------------------------------------------------------
    Purpose:       Gets the "normal" event for a given widget-type.
    Run Syntax:    RUN get_default_event (INPUT _SEW_U._TYPE, OUTPUT se_event).
    Parameters:    INPUT w_type      - widget type
                   OUTPUT dflt       - best choice for an event.                   
    Notes:         Require a current _SEW_U record.
                   Returns "" if w_type is unknown.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  w_type      AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER dflt        AS CHAR NO-UNDO.

  CASE w_type:
    WHEN "BROWSE":U                        THEN dflt = "VALUE-CHANGED":U.
    WHEN "DIALOG-BOX":U OR WHEN "FRAME":U  THEN dflt = "GO":U.
    WHEN "EDITOR":U OR WHEN "FILL-IN":U OR
    WHEN "BROWSE-COLUMN":U
    OR WHEN "{&WT-CONTROL}":U              THEN dflt = "LEAVE":U.
    WHEN "IMAGE":U OR WHEN "RECTANGLE":U   THEN dflt = "MOUSE-SELECT-CLICK":U.
    WHEN "SUB-MENU":U OR WHEN "MENU":U     THEN dflt = "MENU-DROP":U.
    WHEN "COMBO-BOX":U
    OR WHEN "RADIO-SET":U
    OR WHEN "SLIDER":U 
    OR WHEN "SELECTION-LIST":U 
    OR WHEN "TOGGLE-BOX":U                 THEN dflt = "VALUE-CHANGED":U.
    WHEN "BUTTON":U                        THEN dflt = "CHOOSE":U.
    WHEN "QUERY":U                         THEN dflt = "OPEN_QUERY":U.
    WHEN "MENU-ITEM":U      
      THEN IF _SEW_U._SUBTYPE = "TOGGLE-BOX":U THEN dflt = "VALUE-CHANGED":U. 
                                           ELSE dflt = "CHOOSE":U.
    WHEN "WINDOW":U                        THEN dflt = "WINDOW-CLOSE":U.
    OTHERWISE DO:
        dflt = "":U.
    END.
  END CASE.

  RETURN.
  
END PROCEDURE. /* get_default_event. */


PROCEDURE Get_Proc_Lists.
  /*-------------------------------------------------------------------------
    Purpose:        Returns important procedure name lists, such as
                    Smart List and List of All Procedure Names.
    Run Syntax:     
        RUN Get_Proc_Lists
            (INPUT p_Incl_UserDef , OUTPUT p_All_List, OUTPUT p_Smart_List).
    Parameters: 
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT  PARAMETER p_Incl_UserDef AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER p_All_List     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Smart_List   AS CHARACTER NO-UNDO.

  /* romiller add begin */

  DEFINE /*{&NEW} SHARED*/ VARIABLE se_event AS CHARACTER FORMAT "X(256)":U INITIAL ? 
       LABEL "ON"
       VIEW-AS COMBO-BOX INNER-LINES 8
       DROP-DOWN-LIST
       SIZE 31 BY 1
       FONT 2 NO-UNDO.

  DEFINE FRAME f_edit
       se_event
      .

  DEFINE VARIABLE proc_entry    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE proc_list     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE window-handle AS HANDLE    NO-UNDO.
  DEFINE VARIABLE adm-version   AS CHARACTER NO-UNDO.
  
  DEFINE VAR Smart_Prefix         AS CHARACTER INIT "adm-"                NO-UNDO.

  IF se_section = Type_Procedure THEN
      RUN build_proc_list (INPUT se_event:HANDLE in FRAME f_edit).
    
  DO WITH FRAME f_edit:
    /* Get names of all Procedures defined in all the Included Libraries
       and get the subset of SmartMethod procedures in the Included Libraries.
    */
    IF VALID-HANDLE( _h_mlmgr ) THEN
    DO ON STOP UNDO, LEAVE:
        RUN get-saved-methods IN _h_mlmgr ( /* INPUT STRING(_SEW._hwin) , */
                                            INPUT STRING(b_P._WINDOW-HANDLE) ,
                                            INPUT-OUTPUT p_All_List   ,
                                            INPUT-OUTPUT p_Smart_List ).
        /* Get names of all Functions defined in all the Included Libraries
           and get the subset of SmartFunctions in the Included Libraries.
        */
        RUN get-saved-funcs   IN _h_mlmgr ( /* INPUT STRING(_SEW._hwin) , */
                                            INPUT STRING(b_P._WINDOW-HANDLE) ,
                                            INPUT-OUTPUT p_All_List   ,
                                            INPUT-OUTPUT p_Smart_List ).
    END.
  
    /* Add to the All List any user defined procedures and add to the
       Smart List any user defined ADM Methods for the current design
       window. Smart List of "adm-" procs is for ADM1 objects only. - jep
    */
    /*
    FIND _P WHERE _P._u-recid =  win_recid NO-ERROR.
    IF AVAILABLE _P THEN
        ASSIGN adm-version = _P._ADM-Version.
    */
    adm-version = b_P._ADM-Version.
        
    ASSIGN proc_list = se_event:HANDLE IN FRAME f_edit.
    DO proc_entry = 1 TO proc_list:NUM-ITEMS :
        IF proc_list:ENTRY( proc_entry ) BEGINS Smart_Prefix 
           AND adm-version BEGINS "ADM1":U THEN
            ASSIGN p_Smart_List = p_Smart_List + "," +
                                proc_list:ENTRY( proc_entry ) .
        IF p_Incl_UserDef THEN
            ASSIGN p_All_List = p_All_List + "," + proc_list:ENTRY( proc_entry ) .
    END.
    /* Ensure there are no leading or trailing commas. */
    ASSIGN p_Smart_List = TRIM(p_Smart_List, ",":U).
    
    /* Add to the p_All_List the names of the Procedure Object's Reserved
       Procedure Names (see Procedure Settings dialog).
    */                                                               
    IF AVAILABLE b_P AND b_P._RESERVED-PROCS <> "" THEN
        ASSIGN p_All_List = p_All_List + "," + b_P._RESERVED-PROCS.

    /* Ensure there are no leading or trailing commas. */
    ASSIGN p_All_List = TRIM(p_All_List, ",":U).
            
  END. /* DO WITH FRAME */
  /* romiller add end */             
END PROCEDURE.

PROCEDURE paste_txt:
    DEFINE INPUT PARAMETER str AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG paste_txt'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN paste_txt IN hProc ( INPUT str ) NO-ERROR.
END PROCEDURE.


PROCEDURE set_isection:
    MESSAGE 'DEBUG set_isection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN set_isection IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE set_cursor:
    MESSAGE 'DEBUG set_cursor'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN set_cursor IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE show_read_only:
    MESSAGE 'DEBUG show_read_only'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN show_read_only IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE show_private_block:
    DEFINE INPUT PARAMETER p_cur_section AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG show_private_block'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN show_private_block IN hProc ( INPUT p_cur_section ) NO-ERROR.
END PROCEDURE.


PROCEDURE show_db_required:
    DEFINE INPUT PARAMETER p_cur_section AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG show_db_required'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN show_db_required IN hProc ( INPUT p_cur_section ) NO-ERROR.
END PROCEDURE.


PROCEDURE store_trg:
    DEFINE INPUT PARAMETER explicit AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER code_ok AS LOGICAL NO-UNDO.
    MESSAGE 'DEBUG store_trg'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN store_trg IN hProc ( INPUT explicit , OUTPUT code_ok ) NO-ERROR.
END PROCEDURE.


PROCEDURE InsertEventName:
    MESSAGE 'DEBUG InsertEventName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertEventName IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE InsertWidgetName:
    MESSAGE 'DEBUG InsertWidgetName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertWidgetName IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE doInsertWidgetName:
    DEFINE INPUT PARAMETER pString AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG doInsertWidgetName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN doInsertWidgetName IN hProc ( INPUT pString ) NO-ERROR.
END PROCEDURE.


PROCEDURE getInsertWidgetNameList:
    DEFINE OUTPUT PARAMETER pList AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pItem AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG getInsertWidgetNameList'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN getInsertWidgetNameList IN hProc ( OUTPUT pList , OUTPUT pItem ) NO-ERROR.
END PROCEDURE.


PROCEDURE InsertPreProcName:
    MESSAGE 'DEBUG InsertPreProcName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertPreProcName IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE doInsertPreProcName:
    DEFINE INPUT PARAMETER pString AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG doInsertPreProcName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN doInsertPreProcName IN hProc ( INPUT pString ) NO-ERROR.
END PROCEDURE.


PROCEDURE getPreProcNameList:
    DEFINE OUTPUT PARAMETER pList AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pItem AS CHARACTER NO-UNDO.
    MESSAGE 'DEBUG getPreProcNameList'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN getPreProcNameList IN hProc ( OUTPUT pList , OUTPUT pItem ) NO-ERROR.
END PROCEDURE.


PROCEDURE InsertProcName:
    MESSAGE 'DEBUG InsertProcName'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertProcName IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE InsertDBFields:
    MESSAGE 'DEBUG InsertDBFields'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertDBFields IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE InsertQuery:
    MESSAGE 'DEBUG InsertQuery'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN InsertQuery IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE PrintSection:
    MESSAGE 'DEBUG PrintSection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN PrintSection IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE init-win:
    MESSAGE 'DEBUG init-win'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN init-win IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE initial_adjustments:
    MESSAGE 'DEBUG initial_adjustments'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN initial_adjustments IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE setToolTip:
    MESSAGE 'DEBUG setToolTip'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN setToolTip IN hProc NO-ERROR.
END PROCEDURE.


PROCEDURE set_vars:
    MESSAGE 'DEBUG set_vars'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN set_vars IN hProc NO-ERROR.
END PROCEDURE.


FUNCTION GetProcFuncSection RETURNS character ( 
    INPUT p_name AS CHARACTER
    ) :
    MESSAGE 'DEBUG GetProcFuncSection'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    DYNAMIC-FUNCTION ( 'GetProcFuncSection' IN hProc , INPUT p_name ) NO-ERROR.
END FUNCTION.