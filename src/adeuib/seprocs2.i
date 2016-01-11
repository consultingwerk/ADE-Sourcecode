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
define new shared stream WebStream.

procedure ADEPersistent:
end procedure.


procedure EdPopupDrop:
    define input parameter p_Editor as handle no-undo.
    message 'DEBUG EdPopupDrop'
      view-as alert-box info buttons ok.
    run EdPopupDrop in hProc ( input p_Editor ) no-error.
end procedure.


procedure EditUndo:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG EditUndo'
      view-as alert-box info buttons ok.
    run EditUndo in hProc ( input p_Buffer ) no-error.
end procedure.


procedure EditCut:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG EditCut'
      view-as alert-box info buttons ok.
    run EditCut in hProc ( input p_Buffer ) no-error.
end procedure.


procedure EditCopy:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG EditCopy'
      view-as alert-box info buttons ok.
    run EditCopy in hProc ( input p_Buffer ) no-error.
end procedure.


procedure EditPaste:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG EditPaste'
      view-as alert-box info buttons ok.
    run EditPaste in hProc ( input p_Buffer ) no-error.
end procedure.


procedure IndentSelection:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pi_indent as integer no-undo.
    message 'DEBUG IndentSelection'
      view-as alert-box info buttons ok.
    run IndentSelection in hProc ( input p_Buffer , input pi_indent ) no-error.
end procedure.


procedure CommentSelection:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pl_comment as logical no-undo.
    message 'DEBUG CommentSelection'
      view-as alert-box info buttons ok.
    run CommentSelection in hProc ( input p_Buffer , input pl_comment ) no-error.
end procedure.


procedure CommentBox:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pl_comment as logical no-undo.
    message 'DEBUG CommentBox'
      view-as alert-box info buttons ok.
    run CommentBox in hProc ( input p_Buffer , input pl_comment ) no-error.
end procedure.


procedure InsertFile:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG InsertFile'
      view-as alert-box info buttons ok.
    run InsertFile in hProc ( input p_Buffer ) no-error.
end procedure.


procedure FieldSelector:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG FieldSelector'
      view-as alert-box info buttons ok.
    run FieldSelector in hProc ( input p_Buffer ) no-error.
end procedure.


procedure EditHelp:
    define input parameter p_Editor as handle no-undo.
    define input parameter p_Tool_Name as character no-undo.
    define input parameter p_Context as integer no-undo.
    message 'DEBUG EditHelp'
      view-as alert-box info buttons ok.
    run EditHelp in hProc ( input p_Editor , input p_Tool_Name , input p_Context ) no-error.
end procedure.


procedure ApplyTab:
    define input parameter p_Editor as handle no-undo.
    define input parameter p_Return_Error as logical no-undo.
    message 'DEBUG ApplyTab'
      view-as alert-box info buttons ok.
    run ApplyTab in hProc ( input p_Editor , input p_Return_Error ) no-error.
end procedure.


procedure ApplyBackTab:
    define input parameter p_Editor as handle no-undo.
    define input parameter p_Return_Error as logical no-undo.
    message 'DEBUG ApplyBackTab'
      view-as alert-box info buttons ok.
    run ApplyBackTab in hProc ( input p_Editor , input p_Return_Error ) no-error.
end procedure.


procedure Indent_Selection:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pi_indent as integer no-undo.
    define output parameter p_Applied as logical no-undo.
    message 'DEBUG Indent_Selection'
      view-as alert-box info buttons ok.
    run Indent_Selection in hProc ( input p_Buffer , input pi_indent , output p_Applied ) no-error.
end procedure.


procedure Comment_Selection:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pl_comment as logical no-undo.
    define output parameter p_Applied as logical no-undo.
    message 'DEBUG Comment_Selection'
      view-as alert-box info buttons ok.
    run Comment_Selection in hProc ( input p_Buffer , input pl_comment , output p_Applied ) no-error.
end procedure.


procedure Comment_Box:
    define input parameter p_Buffer as handle no-undo.
    define input parameter pl_comment as logical no-undo.
    define output parameter p_Applied as logical no-undo.
    message 'DEBUG Comment_Box'
      view-as alert-box info buttons ok.
    run Comment_Box in hProc ( input p_Buffer , input pl_comment , output p_Applied ) no-error.
end procedure.


procedure Apply_Tab:
    define input parameter p_Buffer as handle no-undo.
    define output parameter p_Applied as logical no-undo.
    message 'DEBUG Apply_Tab'
      view-as alert-box info buttons ok.
    run Apply_Tab in hProc ( input p_Buffer , output p_Applied ) no-error.
end procedure.


procedure Apply_BackTab:
    define input parameter p_Buffer as handle no-undo.
    define output parameter p_Applied as logical no-undo.
    message 'DEBUG Apply_BackTab'
      view-as alert-box info buttons ok.
    run Apply_BackTab in hProc ( input p_Buffer , output p_Applied ) no-error.
end procedure.


procedure SetEdBufType:
    define input parameter p_Buffer as handle no-undo.
    define input parameter p_File_Name as character no-undo.
    message 'DEBUG SetEdBufType'
      view-as alert-box info buttons ok.
    run SetEdBufType in hProc ( input p_Buffer , input p_File_Name ) no-error.
end procedure.


procedure EditingOptions:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG EditingOptions'
      view-as alert-box info buttons ok.
    run EditingOptions in hProc ( input p_Buffer ) no-error.
end procedure.


procedure SetEdHelpFile:
    message 'DEBUG SetEdHelpFile'
      view-as alert-box info buttons ok.
    run SetEdHelpFile in hProc no-error.
end procedure.


procedure SetEditor:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG SetEditor'
      view-as alert-box info buttons ok.
    run SetEditor in hProc ( input p_Buffer ) no-error.
end procedure.


procedure FindText:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG FindText'
      view-as alert-box info buttons ok.
    run FindText in hProc ( input p_Buffer ) no-error.
end procedure.


procedure ReplaceText:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG ReplaceText'
      view-as alert-box info buttons ok.
    run ReplaceText in hProc ( input p_Buffer ) no-error.
end procedure.


procedure ReplaceConfirm:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG ReplaceConfirm'
      view-as alert-box info buttons ok.
    run ReplaceConfirm in hProc ( input p_Buffer ) no-error.
end procedure.


procedure ReplaceAll:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG ReplaceAll'
      view-as alert-box info buttons ok.
    run ReplaceAll in hProc ( input p_Buffer ) no-error.
end procedure.


procedure FindAssign:
    define output parameter p_Find_Criteria as integer no-undo.
    message 'DEBUG FindAssign'
      view-as alert-box info buttons ok.
    run FindAssign in hProc ( output p_Find_Criteria ) no-error.
end procedure.


procedure ReplaceAssign:
    message 'DEBUG ReplaceAssign'
      view-as alert-box info buttons ok.
    run ReplaceAssign in hProc no-error.
end procedure.


procedure FindNext:
    define input parameter p_Buffer as handle no-undo.
    define input parameter p_Find_Criteria as integer no-undo.
    message 'DEBUG FindNext'
      view-as alert-box info buttons ok.
    run FindNext in hProc ( input p_Buffer , input p_Find_Criteria ) no-error.
end procedure.


procedure FindPrev:
    define input parameter p_Buffer as handle no-undo.
    define input parameter p_Find_Criteria as integer no-undo.
    message 'DEBUG FindPrev'
      view-as alert-box info buttons ok.
    run FindPrev in hProc ( input p_Buffer , input p_Find_Criteria ) no-error.
end procedure.


procedure FindAgain:
    define input parameter p_Buffer as handle no-undo.
    define input parameter p_Again_Find_Command as integer no-undo.
    define input parameter p_Again_Find_Criteria as integer no-undo.
    message 'DEBUG FindAgain'
      view-as alert-box info buttons ok.
    run FindAgain in hProc ( input p_Buffer , input p_Again_Find_Command , input p_Again_Find_Criteria ) no-error.
end procedure.


procedure MakeQMark:
    define input-output parameter p_String as character no-undo.
    define input parameter p_Large as logical no-undo.
    message 'DEBUG MakeQMark'
      view-as alert-box info buttons ok.
    run MakeQMark in hProc ( input-output p_String , input p_Large ) no-error.
end procedure.


procedure GotoLine:
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG GotoLine'
      view-as alert-box info buttons ok.
    run GotoLine in hProc ( input p_Buffer ) no-error.
end procedure.


procedure MoveCursor:
    define input parameter p_Buffer as handle no-undo.
    define input parameter p_Cursor_Line as integer no-undo.
    message 'DEBUG MoveCursor'
      view-as alert-box info buttons ok.
    run MoveCursor in hProc ( input p_Buffer , input p_Cursor_Line ) no-error.
end procedure.


procedure SecEdWindow:
/*------------------------------------------------------------------------------
  Purpose: Represents the SecEdWindow procedure used by the section 
           in the AppBuilder.
  Parameters: 
  Notes: 
      - Parameter p_command uses a value "SE_OEOPEN" to indicate 
      that the section editor is being accessed in an open operation 
      from _open-w.p.
------------------------------------------------------------------------------*/    
    define input parameter pi_section as character no-undo.
    define input parameter pi_recid as recid no-undo.
    define input parameter pi_event as character no-undo.
    define input parameter p_command as character no-undo.
    
    /** During dev for 11.2 the various case statements here became dead ends
        We currently need the api since it is called from many places when the handle is valid
        So really...do nothing */
     
end procedure.

procedure AssignSEW:
    define input parameter se_section as character no-undo.
    define input parameter se_recid as recid no-undo.
    define input parameter se_event as character no-undo.
    define input parameter p_U_recid as recid no-undo.
    define input parameter p_TRG_recid as recid no-undo.
    define input parameter p_hwin as handle no-undo.
    message 'DEBUG AssignSEW'
      view-as alert-box info buttons ok.
    run AssignSEW in hProc ( input se_section , input se_recid , input se_event , input p_U_recid , input p_TRG_recid , input p_hwin ) no-error.
end procedure.


procedure se_store:
    define input parameter p_command as character no-undo.
    message 'DEBUG se_store'
      view-as alert-box info buttons ok.
    run se_store in hProc ( input p_command ) no-error.
end procedure.


procedure se_upd_disp:
    define output parameter p_upd_disp as logical no-undo.
    message 'DEBUG se_upd_disp'
      view-as alert-box info buttons ok.
    run se_upd_disp in hProc ( output p_upd_disp ) no-error.
end procedure.


procedure SEClose:
    define input parameter p_command as character no-undo.
    message 'DEBUG SEClose'
      view-as alert-box info buttons ok.
    run SEClose in hProc ( input p_command ) no-error.
end procedure.


procedure se_upd_widget_list:
    message 'DEBUG se_upd_widget_list'
      view-as alert-box info buttons ok.
    run se_upd_widget_list in hProc no-error.
end procedure.


procedure se_emdrp:
    message 'DEBUG se_emdrp'
      view-as alert-box info buttons ok.
    run se_emdrp in hProc no-error.
end procedure.


procedure se_set_title:
    define input parameter p_U_handle as handle no-undo.
    message 'DEBUG se_set_title'
      view-as alert-box info buttons ok.
    run se_set_title in hProc ( input p_U_handle ) no-error.
end procedure.


procedure se_help:
    define input parameter p_Help_Context as integer no-undo.
    message 'DEBUG se_help'
      view-as alert-box info buttons ok.
    run se_help in hProc ( input p_Help_Context ) .
end procedure.


procedure build_event_list:
    message 'DEBUG build_event_list'
      view-as alert-box info buttons ok.
    run build_event_list in hProc .
end procedure.


procedure build_proc_list:
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
    assign phList:screen-value = ?
           phList:list-items = "".        
    /* Get all the procedures for the current UIB Design Object. */
    for each _SEW_TRG where _SEW_TRG._wRECID = b_P._u-recid /* win_recid */
                      and   _SEW_TRG._tSECTION = Type_Procedure :
      assign procname = _SEW_TRG._tEVENT
             l_ok     =  phList:add-last(procname).
    end.
    /* romiller add end */
end procedure.


procedure build_func_list:
    define input parameter phList as handle no-undo.
    message 'DEBUG build_func_list'
      view-as alert-box info buttons ok.
    run build_func_list in hProc ( input phList ) no-error.
end procedure.


procedure build_widget_list:
    define input parameter init_value as character no-undo.
    message 'DEBUG build_widget_list'
      view-as alert-box info buttons ok.
    run build_widget_list in hProc ( input init_value ) no-error.
end procedure.


procedure Has_Freeform:
    define input parameter p_u-recid as recid no-undo.
    define output parameter p_Has_Freeform as logical no-undo.
    message 'DEBUG Has_Freeform'
      view-as alert-box info buttons ok.
    run Has_Freeform in hProc ( input p_u-recid , output p_Has_Freeform ) no-error.
end procedure.


procedure Has_Trigger:
    define input parameter p_sew_recid as recid no-undo.
    define input parameter p_event as character no-undo.
    define output parameter p_has_trigger as logical no-undo.
    message 'DEBUG Has_Trigger'
      view-as alert-box info buttons ok.
    run Has_Trigger in hProc ( input p_sew_recid , input p_event , output p_has_trigger ) no-error.
end procedure.


procedure freeform_update:
    define input parameter p_u-recid as recid no-undo.
    message 'DEBUG freeform_update'
      view-as alert-box info buttons ok.
    run freeform_update in hProc ( input p_u-recid ) no-error.
end procedure.


procedure GetAttribute:
    define input parameter p_Attribute as character no-undo.
    define output parameter p_Value as character no-undo.
    case p_Attribute:
        when "SE-WINDOW" then p_Value = string(h_sewin).
        otherwise do:
        end.
    end case.
    
end procedure.


procedure GetWidgetListName:
    define input parameter p_Name as character no-undo.
    define input parameter p_Label as character no-undo.
    define output parameter p_List_Item as character no-undo.
    message 'DEBUG GetWidgetListName'
      view-as alert-box info buttons ok.
    run GetWidgetListName in hProc ( input p_Name , input p_Label , output p_List_Item ) no-error.
end procedure.


procedure ChangeSection:
    define input parameter p_new_section as character no-undo.
    message 'DEBUG ChangeSection'
      view-as alert-box info buttons ok.
    run ChangeSection in hProc ( input p_new_section ) no-error.
end procedure.


procedure NoProcs:
    define input parameter p_Type as character no-undo.
    define output parameter p_oknew as logical no-undo.
    message 'DEBUG NoProcs'
      view-as alert-box info buttons ok.
    run NoProcs in hProc ( input p_Type , output p_oknew ) no-error.
end procedure.


procedure ListBlocks:
    message 'DEBUG ListBlocks'
      view-as alert-box info buttons ok.
    run ListBlocks in hProc no-error.
end procedure.


procedure NextSearchBlock:
    define input parameter p_Sect-List as character no-undo.
    define input parameter p_Sect-First as character no-undo.
    define input-output parameter p_Sect-Curr as character no-undo.
    message 'DEBUG NextSearchBlock'
      view-as alert-box info buttons ok.
    run NextSearchBlock in hProc ( input p_Sect-List , input p_Sect-First , input-output p_Sect-Curr ) no-error.
end procedure.


procedure GetNextSearchSection:
    define input parameter h_trg_win as handle no-undo.
    define input parameter p_Sect-List as character no-undo.
    define input-output parameter p_Sect-Curr as character no-undo.
    define input-output parameter p_section as character no-undo.
    define input-output parameter p_recid as recid no-undo.
    define input-output parameter p_event as character no-undo.
    define output parameter p_ok as logical no-undo.
    message 'DEBUG GetNextSearchSection'
      view-as alert-box info buttons ok.
    run GetNextSearchSection in hProc ( input h_trg_win , input p_Sect-List , input-output p_Sect-Curr , input-output p_section , input-output p_recid , input-output p_event , output p_ok ) no-error.
end procedure.


procedure GetSearchAllList:
    define input parameter h_trg_win as handle no-undo.
    define input parameter p_section as character no-undo.
    define input parameter p_recid as recid no-undo.
    define input parameter p_event as character no-undo.
    define output parameter p_Sect-List as character no-undo.
    define output parameter p_Sect-Curr as character no-undo.
    message 'DEBUG GetSearchAllList'
      view-as alert-box info buttons ok.
    run GetSearchAllList in hProc ( input h_trg_win , input p_section , input p_recid , input p_event , output p_Sect-List , output p_Sect-Curr ) no-error.
end procedure.


procedure change_trg:
    define input parameter new_section as character no-undo.
    define input parameter new_recid as recid no-undo.
    define input parameter new_event as character no-undo.
    define input parameter use_new_event as logical no-undo.
    define input parameter store_code as logical no-undo.
    define output parameter change_ok as logical no-undo.
    message 'DEBUG change_trg'
      view-as alert-box info buttons ok.
    run change_trg in hProc ( input new_section , input new_recid , input new_event , input use_new_event , input store_code , output change_ok ) no-error.
end procedure.


procedure CheckSyntax:
    message 'DEBUG CheckSyntax'
      view-as alert-box info buttons ok.
    run CheckSyntax in hProc no-error.
end procedure.


procedure UndoChange:
    message 'DEBUG UndoChange'
      view-as alert-box info buttons ok.
    run UndoChange in hProc no-error.
end procedure.


procedure DeleteBlock:
    message 'DEBUG DeleteBlock'
      view-as alert-box info buttons ok.
    run DeleteBlock in hProc no-error.
end procedure.


procedure NewBlock:
    run NewBlock in hProc no-error.
end procedure.

procedure insertTriggerBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Insert Trigger
    Run Syntax:     RUN NewTriggerBlock ( event_name ).
    Parameters:     phWin design window handle
                    pcType  u._type ()
                    pcName
                    pcNewEvent name of the event for the trigger
  ---------------------------------------------------------------------------*/
    define input  parameter phWin       as handle    no-undo.
    define input  parameter pcType      as character no-undo.
    define input  parameter pcName      as character no-undo.
    define input  parameter pcNewEvent  as character no-undo.
    define input  parameter pcBrowseName  as character no-undo.
    define output parameter plok        as logical no-undo.
    define variable hParent           as handle no-undo. 
    define variable new_recid         as recid  no-undo.
    define variable code_type         as character no-undo.
    define variable strt              as integer no-undo.
    define variable lok               as logical no-undo.
/*    define variable new_spcl          as character no-undo.*/
    define variable cSection          as character no-undo.
    define buffer _sew_bc for  _bc.
    
    if pcNewEvent = "" or pcNewEvent = ? then 
        undo, throw new Progress.Lang.AppError("No event passed to InsertTriggerBlock()",?).
  
    find b_P where b_P._window-handle = phWin no-lock no-error.
    if not avail b_p then 
    do:
        hParent = phWin:first-child.
        find b_P where b_P._window-handle = hParent no-lock no-error.
        if not avail b_p then 
            return. 
    end.
    else 
        hParent = phWin.
    if pcType= "CONTROL-FRAME":U then
        pcType = "{&WT-CONTROL}":U.
    
    /* Rohit- browse column fix */    
    if pcType = "BROWSE-COLUMN" then 
    do: 
        /* incomplete - find out how to get this from java
           adding a new parameter for the parent/browse 
           instead of using pcname */   
        
        find _sew_u where _sew_u._window-handle = hParent 
                      and _sew_u._type          = "BROWSE" 
                      and _sew_u._name          = pcBrowseName no-error.        
        if not avail _sew_u then
            return. 
            
        if num-entries(pcname,".") = 3 then
        do:
              find _sew_bc where _sew_bc._x-recid = recid(_sew_u)
                           and _sew_bc._dbname = entry(1,pcname,".")
                           and _sew_bc._table = entry(2,pcname,".")
                           and _sew_bc._name = entry(3,pcname,".") 
                           no-error.
        
        end.
        else if num-entries(pcname,".") = 2 then
        do:
              find _sew_bc where _sew_bc._x-recid = recid(_sew_u)
                           and _sew_bc._table = entry(1,pcname,".")
                           and _sew_bc._name = entry(2,pcname,".")
                           no-error.
               
        end.    
        else do:
           find _sew_bc where _sew_bc._x-recid = recid(_sew_u)
                       and _sew_bc._name = pcname no-error.
        
        end.    
 
/*        IF NOT CAN-DO("_<CALC>,_<SDO>", _BC._DBNAME) THEN         */
/*        tmp_string = db-fld-name("_BC":U, RECID(_BC)).            */
/*      ELSE IF _BC._table > '' AND _BC._table <> 'RowObject':U THEN*/
/*        tmp_string = _BC._table + '.':U + _bc._name.              */
/*      ELSE tmp_string = _BC._DISP-NAME.                           */
/*/*                                                                  */*/

        if not avail _sew_bc then
            return.
        
        new_recid = recid(_sew_bc).       
    end.
    else 
    do:    
        find _sew_u where _sew_u._window-handle = hParent 
                      and _sew_u._type          = pcType
                      and _sew_u._name          = pcName no-error.
        
        if not avail _sew_u then
            return. 
     
        /* we could have checked thw ptype input param ... but the code here should work 
           no matter how we find the data */ 
        if _sew_u._TYPE = "TEXT":U then 
            return.      
          
        if _sew_u._TYPE = "SmartObject":U then 
            return.
            
        assign 
            new_recid = recid(_sew_u).
        
    end. 
        
    cSection  = "_CONTROL":U.  /* Type_Trigger */
        /* Not in use - this code was derived from NewTriggerBlock where tihs  variable 
           was set to ? and never changed... in that code the  _tCode was also assinged 
           if new_spcl <>  ? (which always was true)
          @TODO      
         new_spcl   = ?. */
          
    if can-find(_sew_trg where _tSECTION = cSection
                         and   _wRECID   = new_recid
                         and   _tEVENT   = pcNewEvent) then 
        return ERROR "Event " + pcNewEvent + " already exists for " + pcType + " " + pcname.
    
    create _sew_trg.
    assign _sew_trg._tSECTION = cSection
           _sew_trg._tSPECIAL = ?   /*new_spcl*/
           _sew_trg._pRECID   = recid(b_P)
           _sew_trg._wRECID   = new_recid
           _sew_trg._tEVENT   = pcNewEvent
           _sew_trg._tCODE    = ?.
    /* For all special events (e.g., OCX.event), store it in _tSPECIAL. */
    if num-entries(pcNewEvent, ".":u) > 1 then
    do:
        assign _sew_trg._tSPECIAL = pcNewEvent
               _sew_trg._tTYPE    = "_CONTROL-PROCEDURE" NO-ERROR. /* what if error? */
    end.
    if available _SEW_U and _SEW_U._TYPE eq "{&WT-CONTROL}" then
    do:
        run adeshar/_ocxdflt.p(pcNewEvent, cSection, new_recid, output _sew_trg._tCODE). 
    end.
    else do:
        assign code_type = cSection. /* Default code type. */
        if (pcNewEvent = "DEFINE_QUERY") then
            assign code_type = "_DEFINE-QUERY":U.
        else if (_sew_trg._tTYPE <> "") then
            assign code_type = pcNewEvent.
        run adeshar/_coddflt.p (code_type, new_recid, output _sew_trg._tCODE).
        /* not necessary,  _gen4gl does not delete empty triggers when ide is running
        /* Add comment to trigger block to force adeshar/_gen4gl.p to save it. */
        strt = index(_sew_trg._tCODE,":") + 1.
        if strt > 1 then 
        do:
            _sew_trg._tCODE = substring(_sew_trg._tCODE, 1, strt) 
                            + "  /* new trigger */":U 
                            + substring(_sew_trg._tCODE, strt + 1).
        end. 
        */
    end.                     
    run adecomm/_adeevnt.p ("UIB":U, "New":U, integer(recid(_sew_trg)),se_section, output lok).
    run adeuib/_winsave.p (b_P._WINDOW-HANDLE, false).
    plok = true.
end procedure. 


procedure NewTriggerBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Edit->Insert->Trigger
    Run Syntax:     RUN NewTriggerBlock ( event_name ).
    Parameters:     p_new_event
    - p_new_event name of the event for the trigger
      ?     - prompt user for event name
      ""    - use default event for widget
      event - name of event
  ---------------------------------------------------------------------------*/
  
  define input parameter p_new_event as character no-undo.
    
  define variable a_ok              as logical   no-undo.
  define variable event_list        as character no-undo.
  define variable h_cwin            as WIDGET    no-undo.
  define variable Invalid_List      as character no-undo.
  define variable new_command       as character no-undo.
  define variable new_recid         as recid     no-undo.
  define variable new_spcl          as character no-undo.
  define variable proc_entry        as integer   no-undo.
  define variable proc_list         as handle    no-undo.
  define variable Smart_List        as character no-undo.
  define variable Type              as character no-undo.
  define variable Returns_Type      as character no-undo.
  define variable Code_Block        as character no-undo.
  define variable Define_As         as character no-undo.
  define variable window-handle     as handle    no-undo.
  define variable Create_Block      as logical   no-undo.
  define variable code_type         as character no-undo.
  define variable hSuper_Proc       as handle    no-undo.
  define variable Super_Procs       as character no-undo.
  define variable Super_Handles     as character no-undo .
  define variable Super_Entries     as character no-undo.
  define variable iItem             as integer   no-undo.
  define variable iEntry            as integer   no-undo.
  define variable lOK               as logical   no-undo.
  define variable strt              as integer   no-undo.
  

      if not valid-handle(_h_cur_widg) then return.
      
      find _SEW_U where _HANDLE = _h_cur_widg no-lock no-error.
      if not available _SEW_U then return.
      if _SEW_U._TYPE = "TEXT":U then return.      
      if _SEW_U._TYPE = "SmartObject":U then return.
      new_recid = recid(_SEW_U).      
      
      if not can-query(_h_cur_widg, "WINDOW":U) then return.
      find b_P where b_P._WINDOW-HANDLE = _h_cur_widg:WINDOW no-lock no-error.
      /* For controls in a dialog-box, the _WINDOW-HANDLE field corresponds to the FRAME */
      if not available b_P then
          find b_P where b_P._WINDOW-HANDLE = _h_cur_widg:FRAME no-lock no-error.
      /* When the dialog-box is selected, the handle is the actual widget */
      if not available b_P then
          find b_P where b_P._WINDOW-HANDLE = _h_cur_widg no-lock no-error.    
      if not available b_P then return.

  assign se_section = "_CONTROL":U /* Type_Trigger */
         new_spcl   = ?.      
      
  if p_new_event = ? then do: /* Ask for a new event */
    assign p_new_event = editted_event.
    
    assign       
           Type           = if available _SEW_U then _SEW_U._TYPE else "BROWSE-COLUMN":U.
    do on stop undo, leave:
      if TYPE eq "{&WT-CONTROL}" 
      then do:
         /*
          * If the VBX is "halfway there" then warn the
          * user that NEW VBX event procedures aren't
          * available. This can happen when an existing
          * .w file was created with a VBX that the 
          * current user doesn't have a license for.
          */
         
         find _SEW_F where recid(_SEW_F) = _SEW_U._x-recid.
         if _SEW_F._SPECIAL-DATA <> ? then
             message "The {&WT-CONTROL}," _SEW_F._IMAGE-FILE ", is missing or unavailable" skip
                     "for" _SEW_U._NAME ". New {&WT-CONTROL} events cannot edited. Existing" skip
                     "{&WT-CONTROL} events and PROGRESS events can be edited."
             view-as alert-box information.
             
             
         run adeuib/_ocxevnt.p (input _SEW_U._HANDLE, input "", output event_list).
      end.
      if lookup(TYPE,"QUERY,FRAME,BROWSE,DIALOG-BOX":U) > 0 then do:
        /* See if its a free form query */
        if available _SEW_U then do:
          if can-find(first _TRG where _TRG._tEVENT = "OPEN_QUERY" and
                                       _TRG._wRECID = RECID(_SEW_U)) then
            event_list = "FFQ":U.  /* Free Form Query */
        end.
      end.  /* If a query, frame, browse or dialog */

      /* Add any special events such as Data.<event>. Not used for BROWSE-COLUMN. */
      if (TYPE ne "BROWSE-COLUMN":U) then
        assign event_list = trim(event_list + ",":u + b_P._events, ",").
      run adeuib/_selevnt.p
        (input TYPE,
         input (if TYPE ne "BROWSE-COLUMN":U then _SEW_U._SUBTYPE else ""),
         input event_list,
         input _cur_win_type,
         input recid(b_P),
         input-output p_new_event).
    end.
  end.
  else do:
    if p_new_event = "" then
      run get_default_event(_SEW_U._TYPE, output p_new_event).
  end.
  
    if p_new_event <> "" then
    do:
        Create_Block = not can-find(_SEW_TRG where _tSECTION = se_section
                                               and _wRECID   = new_recid
                                               and _tEVENT   = p_new_event).
    end.
    else
        Create_Block = false.
    
    if Create_Block then
    do:
      create _SEW_TRG.
      assign _SEW_TRG._tSECTION = se_section
             _SEW_TRG._tSPECIAL = new_spcl
             _SEW_TRG._pRECID   = recid(b_P)
             _SEW_TRG._wRECID   = new_recid
             _SEW_TRG._tEVENT   = p_new_event
             _SEW_TRG._tCODE    = ?
             a_ok               = yes.
    end.

    /* If we created a new one, or if it is ok to go to the old one, then go */
    if a_ok then do:
      /* Fill the new trigger unless 1) it is special or 2) we are
         viewing an existing code block. */
      if new_spcl = ? then
      do:
              do:
                /* For all special events (e.g., OCX.event), store it in _tSPECIAL. */
                if num-entries(p_new_event, ".":u) > 1 then
                do:
                    assign _SEW_TRG._tSPECIAL = p_new_event
                           _SEW_TRG._tTYPE    = "_CONTROL-PROCEDURE" NO-ERROR.
                end.
                    
                if available _SEW_U and _SEW_U._TYPE eq "{&WT-CONTROL}" then
                  run adeshar/_ocxdflt.p
                            (p_new_event, se_section, new_recid, output _SEW_TRG._tCODE). 
                else do:
                  assign code_type = se_section. /* Default code type. */
                  if (p_new_event = "DEFINE_QUERY") then
                    assign code_type = "_DEFINE-QUERY":U.
                  else if (_SEW_TRG._tTYPE <> "") then
                    assign code_type = p_new_event.
                  run adeshar/_coddflt.p (code_type, new_recid, output _SEW_TRG._tCODE).
                  /* Add comment to trigger block to force adeshar/_gen4gl.p to save it. */
                  strt = index(_SEW_TRG._tCODE,":") + 1.
                  if strt > 1 then do:
                    _SEW_TRG._tCODE = substring(_SEW_TRG._tCODE, 1, strt) +
                                 "  /* new trigger */":U +
                                 SUBSTRING(_SEW_TRG._tCODE, strt + 1).
                  end.                  
                end.
              end.

          run adecomm/_adeevnt.p ("UIB":U, "New":U, integer(recid(_SEW_TRG)),
                                        se_section, output lOK).
      end.

      if Create_Block then
      do:
        define variable cLinkedFile   as character  no-undo.
        
        run adeuib/_winsave.p (b_P._WINDOW-HANDLE, false).

       /* If treeview, update it. */
       if valid-handle(b_P._tv-proc) then
       do:
         run addCodeNode in b_P._tv-proc
               (input se_section, input new_recid, input se_event).
       end.

        run getLinkedFileName in hOEIDEService (b_P._WINDOW-HANDLE, output cLinkedFile).
        /* IF cLinkedFile > "" THEN
          RUN syncFromAB (cLinkedFile). */ 
      end.      
  end.

if not available b_P then return.
if b_P._save-as-file = ? then return.

define variable cWidgetName   as character  no-undo.
define variable cWindowName   as character  no-undo.
define variable hWindowHandle as handle     no-undo.

/* If the specified event exist, then use findAndSelect to select it in the editor */      
find _SEW_TRG where _SEW_TRG._tSECTION = se_section
                and _SEW_TRG._wRECID   = new_recid
                and _SEW_TRG._tEVENT   = p_new_event no-lock no-error.
if not available _SEW_TRG then return.
              
cWidgetName = _SEW_U._NAME.
                      
find _SEW_U where recid(_SEW_U) = _SEW_TRG._wrecid no-lock no-error.

cWidgetName = if available _SEW_U then _SEW_U._name else ?.
hWindowHandle = if available _SEW_U then _SEW_U._window-handle else ?.
if hWindowHandle <> ? then
do:
  find first _SEW_U where _SEW_U._handle = hWindowHandle no-lock no-error.
  cWindowName = if available _SEW_U then _SEW_U._name else ?.
end.

if index(p_new_event, ".":U) > 0 then /* OCX event */
  findAndSelect(getProjectName(),
  b_P._save-as-file,
              '"' + "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ":U 
                  + cWidgetName + " " + cWindowName + '"', true).
else
do:
  if _h_cur_widg:TYPE = "FRAME":U then
      cWidgetName = "FRAME ":U + cWidgetName.
  findAndSelect(getProjectName(), b_P._save-as-file,
              '"' + "ON ":U + p_new_event + " OF ":U + cWidgetName + '"', true). 
end.              
               
end procedure.

procedure GetOCXEvents.
  /*-------------------------------------------------------------------------
    Purpose:     Called from IDE to get list of ocx events
    Parameters:  
       output  poEvents   ocxtype and events as comma separated list
  ---------------------------------------------------------------------------*/
    define input  parameter pwin as handle  no-undo.
    define input  parameter pocxname as character no-undo.
    
    define output parameter poEvents as longchar no-undo.
    
    define variable EventList      as character no-undo.
    define variable hParent as handle no-undo.
    define variable cOcxType as character no-undo.   
    find b_P where b_P._WINDOW-HANDLE = pwin no-lock no-error.
    if not avail b_p then 
    do:
        hParent = pwin:first-child.
        find b_P where b_P._WINDOW-HANDLE = hParent no-lock no-error.
        if not avail b_p then 
           return.
   
    end.
    else hParent = pwin.
    
    find _SEW_U where _SEW_U._WINDOW-HANDLE = hParent 
                  and _SEW_U._TYPE          = "{&WT-CONTROL}"
                  and _SEW_U._NAME          = pocxname no-error.
    if available _SEW_U then
    do:
        /*
        * If the VBX is "halfway there" then warn the
        * user that NEW VBX event procedures aren't
        * available. This can happen when an existing
        * .w file was created with a VBX that the 
        * current user doesn't have a license for.
        */
     
        find _SEW_F where recid(_SEW_F) = _SEW_U._x-recid.
        if _SEW_F._SPECIAL-DATA <> ? then
        do:
           poEvents =  "ERROR:The {&WT-CONTROL}, "  + _SEW_F._IMAGE-FILE  + ", is missing or unavailable"   
                    +  " for " + _SEW_U._NAME + ". New {&WT-CONTROL} events cannot be edited. Existing" 
                    + " {&WT-CONTROL} events and PROGRESS events can be edited.".
           return.  
        end. 
            
        run adeuib/_ocxevnt.p (input _SEW_U._HANDLE, input "", output EventList).
        cOcxType = if (_SEW_U._OCX-NAME = "":U) or (_SEW_U._OCX-NAME = ?)
                   then pocxname 
                   else _SEW_U._OCX-NAME.
        poEvents = cOcxType + "," + EventList.
    end.           
end procedure.


procedure GetOverrides.
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

procedure GetOverrideBody.
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
             

             run adeuib/_newproc.w persistent set hProc( input Super_Handles   ,
                                     input "OVERRIDE"     ,
                                     input Smart_List      ,
                                     input Invalid_List    ,
                                     input-output cDummy ,
                                     output cDummy           ,
                                     output cDummy     ,
                                     output lDummy           ) .
             
             run getCode in hProc (pcName,"_LOCAL",output ccode).
             if cCode = "" then 
             do:
                  run get-local-template in _h_mlmgr (pcName, output ccode).
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


procedure NewCodeBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Edit->Insert->Procedure
    Run Syntax:     RUN NewProcedureBlock.
    Parameters:     
  ---------------------------------------------------------------------------*/
  
  define input parameter p_se_section as character no-undo.
     
  define variable proc_type         as character no-undo.
  define variable new_event         as character no-undo.
  define variable new_name          as character no-undo.
  define variable a_ok              as logical   no-undo.
  define variable event_list        as character no-undo.
  define variable h_cwin            as WIDGET    no-undo.
  define variable Invalid_List      as character no-undo.
  define variable new_command       as character no-undo.
  define variable new_recid         as recid     no-undo.
  define variable new_spcl          as character no-undo.
  define variable proc_entry        as integer   no-undo.
  define variable proc_list         as handle    no-undo.
  define variable Smart_List        as character no-undo.
  define variable Type              as character no-undo.
  define variable Returns_Type      as character no-undo.
  define variable Code_Block        as character no-undo.
  define variable Define_As         as character no-undo.
  define variable window-handle     as handle    no-undo.
  define variable Create_Block      as logical   no-undo.
  define variable code_type         as character no-undo.
  define variable hSuper_Proc       as handle    no-undo.
  define variable Super_Procs       as character no-undo.
  define variable Super_Handles     as character no-undo .
  define variable Super_Entries     as character no-undo.
  define variable iItem             as integer   no-undo.
  define variable iEntry            as integer   no-undo.
  define variable lOK               as logical   no-undo.
  define variable strt              as integer   no-undo. 
  
  
      if not valid-handle(_h_win) then return.
      find b_P where b_P._WINDOW-HANDLE = _h_win no-lock no-error.
      if not available b_P then return.

      new_recid = b_P._u-recid.
      se_section = p_se_section.
      
        
    /* Ask for a new procedure name. */
    assign new_event = ""
           new_name  = ""
           proc_type = ?    /* Standard new procedure */
           . /* END ASSIGN */

    /* Get names of a) all procs & funcs and b) ADM SmartMethod and SmartFunction
       (subset). Both take care of items defined in the current object as well as
       in Included Libraries. */
    if se_section = Type_Procedure or se_section = Type_Function then
    do:
      run Get_Proc_Lists
          (input no , output Invalid_List , output Smart_List).
    
      assign new_command = "NEW":U.
      case se_section:
        when Type_Procedure then
        do:
          /* Build list of the object's Super Procedure internal procedures. */
          run get-super-procedures in _h_mlmgr ( input string(_h_win) ,
                                                 input-output Super_Procs ,
                                                 input-output Super_Handles).
          run get-super-procs in _h_mlmgr (input Super_Handles ,
                                           input-output Smart_List).
          run adeuib/_newproc.w ( input Super_Handles   ,
                                  input new_command     ,
                                  input Smart_List      ,
                                  input Invalid_List    ,
                                  input-output new_name ,
                                  output Type           ,
                                  output Code_Block     ,
                                  output a_OK           ).
        end.
        when Type_Function then
        do:
          /* Build list of the object's Super Procedure user functions. */
          run get-super-procedures in _h_mlmgr ( input string(_h_win) ,
                                                 input-output Super_Procs ,
                                                 input-output Super_Handles).
          run get-super-funcs in _h_mlmgr (input Super_Handles ,
                                           input-output Smart_List).
          run adeuib/_newfunc.w ( input Super_Handles   ,
                                  input new_command     ,
                                  input Smart_List      ,
                                  input Invalid_List    ,
                                  input-output new_name ,
                                  output Type           ,
                                  output Returns_Type   ,
                                  output Define_As      ,
                                  output Code_Block     ,
                                  output a_OK           ).
          
        end.
      end case.
      if a_OK = false then return "_CANCEL":u.
    end.
    
    
    if Type = "_DEFAULT":U then
    case new_name :
        when Adm_Create_Obj then
            assign proc_type = Type_Adm_Create_Obj
                   Type      = proc_type.
        when Adm_Row_Avail then
            assign proc_type = Type_Adm_Row_Avail
                   Type      = proc_type.
        when Enable_UI then
            assign proc_type = Type_Def_Enable
                   Type      = proc_type.
        when Disable_UI then
            assign proc_type = Type_Def_Disable
                   Type      = proc_type.
        when Send_Records then
            assign proc_type = Type_Send_Records
                   Type      = proc_type.
    end case.
               
    assign new_event   = new_name
           new_spcl    = proc_type. /* Use same "language" as _CONTROL above */  
           
    if new_event <> "" then
    do:
        Create_Block = not can-find(_SEW_TRG where _tSECTION = se_section
                                               and _wRECID   = new_recid
                                               and _tEVENT   = new_event).
    end.
    else
        Create_Block = false.

    if Create_Block then
    do:
      create _SEW_TRG.
      assign _SEW_TRG._tSECTION = se_section
             _SEW_TRG._tSPECIAL = new_spcl
             _SEW_TRG._pRECID   = recid(b_P)
             _SEW_TRG._wRECID   = new_recid
             _SEW_TRG._tEVENT   = new_event
             _SEW_TRG._tCODE    = ?
             _SEW_TRG._DB-REQUIRED = no when (proc_type = Type_Adm_Create_Obj)
             a_ok               = yes.
    end.

    /* If we created a new one, or if it is ok to go to the old one, then go */
    if a_ok then do:
      /* Fill the new trigger unless 1) it is special or 2) we are
         viewing an existing code block. */
    if new_spcl = ? then
    do:
      /* romiller add begin */
      if Type = Type_Local and VALID-HANDLE( _h_mlmgr ) and Code_Block = "" then 
      /* romiller add begin */
      do:
        /* romiller add end */
        run get-local-template in _h_mlmgr ( input  new_name ,
                                             output _SEW_TRG._tCODE ).
      end.
      else
        /* romiller add end */
      do:
      
          case se_section:
            when Type_Procedure then do:
              /* If Code_Block is Nul, then get standard code default for a 
                 procedure. Otherwise, its an override whose code was generated by
                 _newproc.p. */
              if (Code_Block = "") then
                run adeshar/_coddflt.p (se_section, new_recid, output _SEW_TRG._tCODE).
              else
                assign _SEW_TRG._tCode = Code_Block.
            end.
            when Type_Function then do:
              /* Function blocks are built by _newfunc.w, not _coddflt.p. */
              assign _SEW_TRG._tCODE = Code_Block.
            end.                      
          end case.
          run adecomm/_adeevnt.p ("UIB":U, "New":U, integer(recid(_SEW_TRG)),
                                        se_section, output lOK).
      end.
      end.

      release _SEW_TRG. /* Releases _TRG record */

      if Create_Block then
      do:
        define variable cLinkedFile   as character  no-undo.
        
        run adeuib/_winsave.p (b_P._WINDOW-HANDLE, false).

       /* If treeview, update it. */
       if valid-handle(b_P._tv-proc) then
       do:
         run addCodeNode in b_P._tv-proc
               (input se_section, input new_recid, input se_event).
       end.

        run getLinkedFileName in hOEIDEService (b_P._WINDOW-HANDLE, output cLinkedFile).
        if cLinkedFile > "" then
          run syncFromAB (cLinkedFile).
      end.      
  end.

if not available b_P then return.
if b_P._save-as-file = ? then return.

define variable cWidgetName   as character  no-undo.
define variable cWindowName   as character  no-undo.
define variable hWindowHandle as handle     no-undo.

/* If the specified event exist, then use findAndSelect to select it in the editor */      
find _SEW_TRG where _SEW_TRG._tSECTION = se_section
                and _SEW_TRG._wRECID   = new_recid
                and _SEW_TRG._tEVENT   = new_event no-lock no-error.

if not available _SEW_TRG then return.

if _h_win <> ? then
do:
  find first _SEW_U where _SEW_U._handle = _h_win no-lock no-error.
  cWindowName = if available _SEW_U then _SEW_U._name else ?.
end.

findAndSelect(getProjectName(),
  b_P._save-as-file,
            '"' + "&ANALYZE-SUSPEND _UIB-CODE-BLOCK ":U + se_section + " "
                  + new_event + " " + cWindowName + '"', true ).
    
end.

procedure RenameProc:
    message 'DEBUG RenameProc'
      view-as alert-box info buttons ok.
    run RenameProc in hProc no-error.
end procedure.


procedure check_UIB_current_window:
    /* RUN check_UIB_current_window IN hProc NO-ERROR. */
end procedure.


procedure check_store_trg:
    define input parameter check_only as logical no-undo.
    define input parameter print_section as logical no-undo.
    define output parameter code_ok as logical no-undo.
    message 'DEBUG check_store_trg'
      view-as alert-box info buttons ok.
    run check_store_trg in hProc ( input check_only , input print_section , output code_ok ) no-error.
end procedure.


procedure display_trg:
    message 'DEBUG display_trg'
      view-as alert-box info buttons ok.
    run display_trg in hProc no-error.
end procedure.


procedure CodeModified:
    define input parameter p_Modified as logical no-undo.
    message 'DEBUG CodeModified'
      view-as alert-box info buttons ok.
    run CodeModified in hProc ( input p_Modified ) no-error.
end procedure.


procedure insert_file:
    define input parameter p_Mode as character no-undo.
    define input parameter p_Buffer as handle no-undo.
    message 'DEBUG insert_file'
      view-as alert-box info buttons ok.
    run insert_file in hProc ( input p_Mode , input p_Buffer ) no-error.
end procedure.


procedure get_default_event.
  /*--------------------------------------------------------------------------
    Purpose:       Gets the "normal" event for a given widget-type.
    Run Syntax:    RUN get_default_event (INPUT _SEW_U._TYPE, OUTPUT se_event).
    Parameters:    INPUT w_type      - widget type
                   OUTPUT dflt       - best choice for an event.                   
    Notes:         Require a current _SEW_U record.
                   Returns "" if w_type is unknown.
  ---------------------------------------------------------------------------*/
  define input parameter  w_type      as char no-undo.
  define output parameter dflt        as char no-undo.

  case w_type:
    when "BROWSE":U                        then dflt = "VALUE-CHANGED":U.
    when "DIALOG-BOX":U or when "FRAME":U  then dflt = "GO":U.
    when "EDITOR":U or when "FILL-IN":U or
    when "BROWSE-COLUMN":U
    or when "{&WT-CONTROL}":U              then dflt = "LEAVE":U.
    when "IMAGE":U or when "RECTANGLE":U   then dflt = "MOUSE-SELECT-CLICK":U.
    when "SUB-MENU":U or when "MENU":U     then dflt = "MENU-DROP":U.
    when "COMBO-BOX":U
    or when "RADIO-SET":U
    or when "SLIDER":U 
    or when "SELECTION-LIST":U 
    or when "TOGGLE-BOX":U                 then dflt = "VALUE-CHANGED":U.
    when "BUTTON":U                        then dflt = "CHOOSE":U.
    when "QUERY":U                         then dflt = "OPEN_QUERY":U.
    when "MENU-ITEM":U      
      then if _SEW_U._SUBTYPE = "TOGGLE-BOX":U then dflt = "VALUE-CHANGED":U. 
                                           else dflt = "CHOOSE":U.
    when "WINDOW":U                        then dflt = "WINDOW-CLOSE":U.
    otherwise do:
        dflt = "":U.
    end.
  end case.

  return.
  
end procedure. /* get_default_event. */


procedure Get_Proc_Lists.
  /*-------------------------------------------------------------------------
    Purpose:        Returns important procedure name lists, such as
                    Smart List and List of All Procedure Names.
    Run Syntax:     
        RUN Get_Proc_Lists
            (INPUT p_Incl_UserDef , OUTPUT p_All_List, OUTPUT p_Smart_List).
    Parameters: 
  ---------------------------------------------------------------------------*/
  
  define input  parameter p_Incl_UserDef as logical   no-undo.
  define output parameter p_All_List     as character no-undo.
  define output parameter p_Smart_List   as character no-undo.

  /* romiller add begin */

  define /*{&NEW} SHARED*/ variable se_event as character format "X(256)":U initial ? 
       label "ON"
       view-as combo-box inner-lines 8
       drop-down-list
       size 31 by 1
       font 2 no-undo.

  define frame f_edit
       se_event
      .

  define variable proc_entry    as integer   no-undo.
  define variable proc_list     as handle    no-undo.
  define variable window-handle as handle    no-undo.
  define variable adm-version   as character no-undo.
  
  define var Smart_Prefix         as character init "adm-"                no-undo.

  if se_section = Type_Procedure then
      run build_proc_list (input se_event:HANDLE in frame f_edit).
    
  do with frame f_edit:
    /* Get names of all Procedures defined in all the Included Libraries
       and get the subset of SmartMethod procedures in the Included Libraries.
    */
    if valid-handle( _h_mlmgr ) then
    do on stop undo, leave:
        run get-saved-methods in _h_mlmgr ( /* INPUT STRING(_SEW._hwin) , */
                                            input string(b_P._WINDOW-HANDLE) ,
                                            input-output p_All_List   ,
                                            input-output p_Smart_List ).
        /* Get names of all Functions defined in all the Included Libraries
           and get the subset of SmartFunctions in the Included Libraries.
        */
        run get-saved-funcs   in _h_mlmgr ( /* INPUT STRING(_SEW._hwin) , */
                                            input string(b_P._WINDOW-HANDLE) ,
                                            input-output p_All_List   ,
                                            input-output p_Smart_List ).
    end.
  
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
        
    assign proc_list = se_event:HANDLE in frame f_edit.
    do proc_entry = 1 to proc_list:num-items :
        if proc_list:entry( proc_entry ) begins Smart_Prefix 
           and adm-version begins "ADM1":U then
            assign p_Smart_List = p_Smart_List + "," +
                                proc_list:entry( proc_entry ) .
        if p_Incl_UserDef then
            assign p_All_List = p_All_List + "," + proc_list:entry( proc_entry ) .
    end.
    /* Ensure there are no leading or trailing commas. */
    assign p_Smart_List = trim(p_Smart_List, ",":U).
    
    /* Add to the p_All_List the names of the Procedure Object's Reserved
       Procedure Names (see Procedure Settings dialog).
    */                                                               
    if available b_P and b_P._RESERVED-PROCS <> "" then
        assign p_All_List = p_All_List + "," + b_P._RESERVED-PROCS.

    /* Ensure there are no leading or trailing commas. */
    assign p_All_List = trim(p_All_List, ",":U).
            
  end. /* DO WITH FRAME */
  /* romiller add end */             
end procedure.

procedure paste_txt:
    define input parameter str as character no-undo.
    message 'DEBUG paste_txt'
      view-as alert-box info buttons ok.
    run paste_txt in hProc ( input str ) no-error.
end procedure.


procedure set_isection:
    message 'DEBUG set_isection'
      view-as alert-box info buttons ok.
    run set_isection in hProc no-error.
end procedure.


procedure set_cursor:
    message 'DEBUG set_cursor'
      view-as alert-box info buttons ok.
    run set_cursor in hProc no-error.
end procedure.


procedure show_read_only:
    message 'DEBUG show_read_only'
      view-as alert-box info buttons ok.
    run show_read_only in hProc no-error.
end procedure.


procedure show_private_block:
    define input parameter p_cur_section as character no-undo.
    message 'DEBUG show_private_block'
      view-as alert-box info buttons ok.
    run show_private_block in hProc ( input p_cur_section ) no-error.
end procedure.


procedure show_db_required:
    define input parameter p_cur_section as character no-undo.
    message 'DEBUG show_db_required'
      view-as alert-box info buttons ok.
    run show_db_required in hProc ( input p_cur_section ) no-error.
end procedure.


procedure store_trg:
    define input parameter explicit as logical no-undo.
    define output parameter code_ok as logical no-undo.
    message 'DEBUG store_trg'
      view-as alert-box info buttons ok.
    run store_trg in hProc ( input explicit , output code_ok ) no-error.
end procedure.


procedure InsertEventName:
    message 'DEBUG InsertEventName'
      view-as alert-box info buttons ok.
    run InsertEventName in hProc no-error.
end procedure.


procedure InsertWidgetName:
    message 'DEBUG InsertWidgetName'
      view-as alert-box info buttons ok.
    run InsertWidgetName in hProc no-error.
end procedure.


procedure doInsertWidgetName:
    define input parameter pString as character no-undo.
    message 'DEBUG doInsertWidgetName'
      view-as alert-box info buttons ok.
    run doInsertWidgetName in hProc ( input pString ) no-error.
end procedure.


procedure getInsertWidgetNameList:
    define output parameter pList as character no-undo.
    define output parameter pItem as character no-undo.
    message 'DEBUG getInsertWidgetNameList'
      view-as alert-box info buttons ok.
    run getInsertWidgetNameList in hProc ( output pList , output pItem ) no-error.
end procedure.


procedure InsertPreProcName:
    message 'DEBUG InsertPreProcName'
      view-as alert-box info buttons ok.
    run InsertPreProcName in hProc no-error.
end procedure.


procedure doInsertPreProcName:
    define input parameter pString as character no-undo.
    message 'DEBUG doInsertPreProcName'
      view-as alert-box info buttons ok.
    run doInsertPreProcName in hProc ( input pString ) no-error.
end procedure.


procedure getPreProcNameList:
    define output parameter pList as character no-undo.
    define output parameter pItem as character no-undo.
    message 'DEBUG getPreProcNameList'
      view-as alert-box info buttons ok.
    run getPreProcNameList in hProc ( output pList , output pItem ) no-error.
end procedure.


procedure InsertProcName:
    message 'DEBUG InsertProcName'
      view-as alert-box info buttons ok.
    run InsertProcName in hProc no-error.
end procedure.


procedure InsertDBFields:
    message 'DEBUG InsertDBFields'
      view-as alert-box info buttons ok.
    run InsertDBFields in hProc no-error.
end procedure.


procedure InsertQuery:
    message 'DEBUG InsertQuery'
      view-as alert-box info buttons ok.
    run InsertQuery in hProc no-error.
end procedure.


procedure PrintSection:
    message 'DEBUG PrintSection'
      view-as alert-box info buttons ok.
    run PrintSection in hProc no-error.
end procedure.


procedure init-win:
    message 'DEBUG init-win'
      view-as alert-box info buttons ok.
    run init-win in hProc no-error.
end procedure.


procedure initial_adjustments:
    message 'DEBUG initial_adjustments'
      view-as alert-box info buttons ok.
    run initial_adjustments in hProc no-error.
end procedure.


procedure setToolTip:
    message 'DEBUG setToolTip'
      view-as alert-box info buttons ok.
    run setToolTip in hProc no-error.
end procedure.


procedure set_vars:
    message 'DEBUG set_vars'
      view-as alert-box info buttons ok.
    run set_vars in hProc no-error.
end procedure.


function GetProcFuncSection returns character ( 
    input p_name as character
    ) :
    message 'DEBUG GetProcFuncSection'
      view-as alert-box info buttons ok.
    dynamic-function ( 'GetProcFuncSection' in hProc , input p_name ) no-error.
end function.