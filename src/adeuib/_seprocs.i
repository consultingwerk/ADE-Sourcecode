/*********************************************************************
* Copyright (C) 2000-2016 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _seprocs.i

Description:
    The internal procedures for the UIB Section Editor Window.

Author: Wm.T.Wood & J. Palazzo

Date Created: March 31, 1993

Modified:
   04/14/99  tsm  Added support for various Intl Numeric Formats (in addition
                  to European and American) by using session 
                  set-numeric-format method to set format back to users's
                  setting
                   
   05/12/99  tsm  Added support for Print Section
   05/27/99  tsm  Changed filters parameter in call to _fndfile.p because it 
                  now needs list-item pairs rather than list-items to support 
                  new image formats
   06/16/99  tsm  Changed call to abprint to always send filename rather than
                  tempfilename so that Untitled will print in header for unsaved files
   06/17/99  tsm  Added section name to header that will print in abprint.
   08/08/00  jep  Assign _P recid to newly created _SEW_TRG records (= _TRG recs).
   02/05/00  jep  Issue 316: Clear _P._hSecEd handle when deleting a Sec Ed Window.
   09/28/01  jep  IZ 1429 adm-create-objects is db-required. Now defaults
                  to not db-required.
   03/07/02  jep  IZ 4098 AppBuilder undoes code changes wrong.
----------------------------------------------------------------------------*/


/* Function Prototypes. */
FUNCTION GetProcFuncSection RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) FORWARD.

PROCEDURE SecEdWindow.
/*----------------------------------------------------------------------------

File: SecEdWindow / _codedit.p

Description:
    The UIB code section editor (Section Editor Window).

Input Parameters:
   pi_section - the section to start in (eg. _CUSTOM, _CONTROL, _PROCEDURE, _FUNCTION)
               [if ? -> se_section = "_CONTROL"]
   pi_recid   - the recid of the widget to look at (or the Window if a
               custom or procedure section.
               [if ? -> se_recid = RECID(_U._h_cur_widg)]
   pi_event   - the event to start at (or name of pseudo-event).
               eg.  CHOOSE or _DEFINITIONS.
               [if ? -> se_event = DEFAULT event for the object type. ]
   p_command  - Section Editor Window command.  Form: "SE_COMMAND". 

Output Parameters:
   <None>

Author: John Palazzo, W. Wood

Date Created: March 1994

----------------------------------------------------------------------------*/

/* jep - part of included sew changes - se_event param -> pi_event. */
DEFINE INPUT PARAMETER  pi_section AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  pi_recid   AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER  pi_event   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  p_command  AS CHARACTER NO-UNDO.

DEFINE BUFFER x_U FOR _U.

DEFINE VARIABLE current_avail AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Has_Freeform  AS LOGICAL       NO-UNDO.
DEFINE VARIABLE SEW_Logical   AS LOGICAL       NO-UNDO.
DEFINE VARIABLE window-handle AS WIDGET-HANDLE NO-UNDO.


/* ***************************************************************************
                              Main Code Block                              
***************************************************************************** */

/* ------------------------------------------------------------------------- */
/*                        Get the initial trigger to edit                    */
/* ------------------------------------------------------------------------- */

/* jep - part of included sew changes - se_event param -> pi_event. */
/* Need this assign to be sure and update global p_ variables for SEW. */

ASSIGN se_section = pi_section
       se_recid   = pi_recid
       se_event   = pi_event.

IF NOT VALID-HANDLE(h_sewin) THEN RETURN. /* dma */

/* If SEW window is not visible, assign HIDDEN = TRUE. */
IF h_sewin:VISIBLE = FALSE THEN ASSIGN h_sewin:HIDDEN = TRUE.

/* Since the Section Editor is now Persistent, references to _U do not
   by default point to any record, even if _uibmain.p has a record
   in that buffer. So we point the local _U buffer to the current widget
   for cases in the Section Editor code where _U will be needed.
*/
IF VALID-HANDLE( _h_cur_widg ) THEN
    FIND _U where _U._HANDLE = _h_cur_widg NO-ERROR.
/* Section Editor Window - Event Handling. */
CASE p_command :
        
        WHEN "" OR WHEN "SE_ERROR":U
        THEN DO:
            RUN se_store ( INPUT p_command ).
        END.
        
        /* DOES NOT AFFECT SEW DISPLAY STATE */
        WHEN "SE_STORE":U
        THEN DO:
            /* No need to update SEW here if is not visible. */
            IF h_sewin:VISIBLE = FALSE THEN RETURN.
            
            /* This store is called when Closing all windows in UIB
               or if Exiting - then we want to store the code even if
               the UIB current window is different than the SEW.
            */
            RUN se_store ( INPUT p_command ).
            /* Change the values which we use to determine whether or not code 
               has changed when we try to change triggers.
            */
            RUN CodeModified ( INPUT FALSE ).
            RETURN.
        END.
        
        /* DOES NOT AFFECT SEW DISPLAY STATE */
        WHEN "SE_STORE_WIN":U OR WHEN "SE_STORE_SELECTED":U
        THEN DO:

            /* If store for specific window and its not the window
               current in the SEW, then do not store and return
               instead.
            */
            IF NOT AVAILABLE _SEW THEN RETURN.
            IF _h_win = ?
               OR _SEW._hwin = ?
               OR _h_win <> _SEW._hwin THEN RETURN.
            
            /* No need to update SEW here if is not visible. */
            IF h_sewin:VISIBLE = FALSE THEN RETURN.
            
            /* If SE_STORE_SELECTED, then we only want to store the trigger
               code if the current Section Editor widget is selected in the
               design window.  Used for Cut, Copy, Duplicate, Delete, and
               Copy to File where we want to store the code only if its
               one of the selected widgets for the UIB Edit command.
            */
            IF ( p_Command = "SE_STORE_SELECTED") THEN
            DO:
               IF ( AVAILABLE _SEW_U ) AND ( _SEW_U._SELECTEDib = FALSE ) THEN
                   RETURN.
               ELSE IF ( NOT AVAILABLE _SEW_U ) THEN
                   RETURN. 
            END.

            RUN se_store ( INPUT p_command ).
            /* Change the values which we use to determine whether or not code 
               has changed when we try to change triggers.
            */
            RUN CodeModified ( INPUT FALSE ).
            RETURN.
        END.
        
        /* AFFECTS SEW DISPLAY STATE */
        WHEN "SE_PROPS":U
        THEN DO:
            /* No need to update SEW here if is not visible. */
            IF h_sewin:VISIBLE = FALSE THEN RETURN.
            
            /* In case widget name or label changed in UIB, update
               the SEW display. Handles SEW title change in case
               window widget's name or title changes.
            */
            RUN se_upd_widget_list.
            PUBLISH "SE_UPDATE_WIDGETS":u FROM THIS-PROCEDURE.
            RETURN.            
        END.
        
        WHEN "SE_HIDE":U
        THEN DO:
            IF h_sewin:VISIBLE = TRUE
            THEN DO:
                ASSIGN h_sewin:HIDDEN = TRUE
                       h_sewin:TITLE = "SE_HIDDEN " + h_sewin:TITLE
                .
            END.
            RETURN.
        END.

        WHEN "SE_VIEW":U
        THEN DO:
            IF h_sewin:TITLE BEGINS "SE_HIDDEN "
            THEN DO:
                ASSIGN h_sewin:TITLE   =
                           REPLACE( h_sewin:TITLE , "SE_HIDDEN " , "" ) 
                       h_sewin:VISIBLE = TRUE
                .
            END.
            RETURN.
        END.

        WHEN "SE_CLOSE":U
        THEN DO:
            RUN SEClose ( INPUT p_command ).
            RETURN.
        END.

        WHEN "SE_CLOSE_SELECTED":U
        THEN DO:
            /* If close for specific window and its not the window
               current in the SEW, then do not close and return instead.
            */
            IF NOT AVAILABLE _SEW THEN RETURN.
            IF _h_win = ?
               OR _SEW._hwin = ?
               OR _h_win <> _SEW._hwin THEN RETURN.
            
            /* No need to update SEW here if is not visible. */
            IF h_sewin:VISIBLE = FALSE THEN RETURN.

            RUN SEClose ( INPUT p_command ).
            RETURN.
        END.
        
        WHEN "SE_EXIT":U
        THEN DO:
            RUN SEClose ( INPUT p_command ).
            RETURN.
        END.

        /* AFFECTS SEW DISPLAY STATE */
        OTHERWISE   /* Adding and/or deleting widgets. */
        DO:
            /* IF UIB Window the SEW was open for is now deleted,
               then close the SEW.
            */
            IF AVAILABLE _SEW AND NOT VALID-HANDLE( _SEW._hwin )
            THEN DO:
                RUN SEClose ( INPUT "SE_CLOSE" ).
                RETURN.
            END.
            
            /* Call to check that UIB window is same as SEW. */
            RUN se_upd_disp ( OUTPUT SEW_Logical ).
            IF SEW_Logical = FALSE THEN RETURN.
            
            /* No need to update SEW here if its not visible. */
            IF h_sewin:VISIBLE = FALSE THEN RETURN.

            /* If current widget in SEW has not been deleted,
               then just update the wname widget list and return.
            */
            ASSIGN current_avail = (AVAILABLE _SEW_U ) AND (_SEW_U._STATUS <> "DELETED").
            IF NOT current_avail THEN /* check for _BC's parent */
                ASSIGN current_avail = (AVAILABLE _SEW_BC) AND
                                        CAN-FIND(_U WHERE RECID(_U)  = _SEW_BC._x-recid
                                                      AND _U._STATUS <> "DELETED").

            IF current_avail THEN
            DO:
                RUN build_widget_list (wname).
                ASSIGN  se_section = _SEW._psection
                        se_recid   = _SEW._precid
                        se_event   = _SEW._pevent
                . /* ASSIGN */

                PUBLISH "SE_UPDATE_WIDGETS":u FROM THIS-PROCEDURE.
                RETURN.
            END.
            /* Otherwise, this is SE_DELETE and we must repoint section
               editor to new current widget.
            */
            ELSE ASSIGN se_recid = RECID( _U ).
        END.    /* OTHERWISE */
END CASE.

EDIT-BLOCK:
DO ON STOP UNDO, RETRY EDIT-BLOCK
   ON ERROR UNDO, LEAVE EDIT-BLOCK:

  RUN adecomm/_setcurs.p (INPUT "":U).

  IF _err_recid = ? THEN DO: /* Trigger editor is called normally. */
    /* Verify the calling recid */
    FIND _SEW_U WHERE RECID(_SEW_U) = se_recid NO-ERROR.
    IF NOT AVAILABLE _SEW_U THEN
      FIND _SEW_BC WHERE RECID(_SEW_BC) = se_recid NO-ERROR.
    IF NOT AVAILABLE _SEW_U AND NOT AVAILABLE _SEW_BC THEN DO:
      FIND _SEW_U WHERE _SEW_U._HANDLE = _h_cur_widg NO-ERROR.
      IF NOT AVAILABLE _SEW_U THEN DO:
        BELL.
        MESSAGE "No object is currently selected." 
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK
                IN WINDOW h_sewin.
        LEAVE EDIT-BLOCK.
      END.
    END.

    /* Menubars, Literal Text, Queries, SmartObjects and Design-Windows
       cannot have triggers.
       Go to Editing the Main Code Block. Exception: Query defined as
       Freeform will have an OPEN_QUERY _TRG record. We do check for it.
    */
    IF AVAILABLE _SEW_U AND
       ( CAN-DO("QUERY,SmartObject,TEXT":U , _SEW_U._TYPE )
         OR (_SEW_U._TYPE = "MENU":U AND _SEW_U._SUBTYPE = "MENUBAR":U )
         OR (_SEW_U._SUBTYPE = "DESIGN-WINDOW":U)
       )
    THEN DO:
        ASSIGN Has_Freeform = FALSE. 
        IF _SEW_U._TYPE = "QUERY":U THEN
          RUN Has_Freeform (INPUT RECID(_SEW_U) , OUTPUT Has_Freeform).

        IF Has_Freeform = FALSE THEN DO:
          /* Get the _U record for the container. */
          ASSIGN v_h = _SEW_U._WINDOW-HANDLE.
          FIND _SEW_U WHERE _SEW_U._HANDLE = v_h.
          ASSIGN se_section = "_CUSTOM":U
                 se_event   = Type_Main_Block
                 se_recid   = RECID(_SEW_U)
                 _SEW-recid = se_recid
                 recent_recid = se_recid
                 recent_proc = ""
                 recent_func = ""
                 recent_trig = ""
                 . /* END ASSIGN */
        END.
    END.
  END. /* _err_recid = ? */
  ELSE DO:  /* Bad compile forced call or a call from treeview to show code. */
    /* We need to view the frame here in order to show the error message 
       This gets around a bug in the HIDDEN attribure
    MESSAGE "Debugging code to find blank section editor" skip
            "Error Recid" _err_recid
            "COMPILER:FILE-OFFSET" COMPILER:FILE-OFFSET. */

    VIEW FRAME f_Edit.
    
    FIND _SEW_TRG WHERE RECID(_SEW_TRG) = _err_recid. 
    FIND _SEW_U WHERE RECID(_SEW_U) = _SEW_TRG._wRECID NO-ERROR.
    IF NOT AVAILABLE _SEW_U THEN
      FIND _SEW_BC WHERE RECID(_SEW_BC) = _SEW_TRG._wRECID.
    ASSIGN se_section    = _SEW_TRG._tSECTION
           se_event      = _SEW_TRG._tEVENT                
           _SEW-recid    = _SEW_TRG._wRECID
           se_event:LIST-ITEMS IN FRAME f_edit = se_event
    . /* ASSIGN */

  END.  /* Bad compile forced call or a call from treeview to show code. */
  
  IF AVAILABLE _SEW_U THEN DO:
    ASSIGN _SEW-recid = RECID(_SEW_U).
    FIND _P WHERE _P._WINDOW-HANDLE = _SEW_U._WINDOW-HANDLE.
  END.
  ELSE DO:
    ASSIGN _SEW-recid = RECID(_SEW_BC).
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
    FIND _P WHERE _P._WINDOW-HANDLE = x_U._WINDOW-HANDLE.
  END.
  
  /* Handle adding back in the Triggers section for .w files. */
  IF ( _P._FILE-TYPE = "w":U ) AND
     (isection:LOOKUP( Trigs ) IN FRAME f_edit = 0) THEN
      ASSIGN dummy = isection:INSERT( Trigs , Main_Block ) IN FRAME f_edit.
  /* Remove the Triggers section for .p and .i files and switch the default
     startup section to Definitions when not given a specific section
     via _err_recid. */
  IF ( _P._FILE-TYPE <> "w":U ) THEN
  DO:
      ASSIGN dummy = isection:DELETE( Trigs ) IN FRAME f_edit NO-ERROR.

      IF _err_recid = ? THEN
          ASSIGN se_section   = "_CUSTOM":U
                 se_event     = Type_Definitions
                 recent_recid = se_recid
                 recent_proc  = ""
                 recent_func  = ""
                 recent_trig  = ""
                 . /* END ASSIGN */
  END.
  
  /* Add the Included Libraries section for WebSpeed V2 files. */
  IF ( _P._file-version BEGINS "WDT_v2":U ) AND
     (isection:LOOKUP( Libraries ) IN FRAME f_edit = 0) THEN
      ASSIGN dummy = isection:INSERT( Libraries , Main_Block ) IN FRAME f_edit.
  /* Remove the Included Libraries section for all non-WebSpeed V2 files. */
  IF NOT ( _P._file-version BEGINS "WDT_v2":U ) THEN
      ASSIGN dummy = isection:DELETE( Libraries ) IN FRAME f_edit NO-ERROR.

  /* Get the window (and its save-as-file) for this trigger */
  IF AVAILABLE _SEW_U THEN
    h_win_trig = _SEW_U._WINDOW-HANDLE.
  ELSE DO:
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
    h_win_trig = x_U._WINDOW-HANDLE.
  END.
  FIND x_U WHERE x_U._HANDLE = h_win_trig.
  ASSIGN win_recid = RECID(x_U)
         se_recid  = _SEW-recid.
  
  /* Assign the Section Editor window title bar. */
  RUN se_set_title ( h_win_trig ).

  /* get an alphabetic list of widgets */
  RUN build_widget_list (wname).

  /* The conditions below cover re-opening the Section Editor window
     or displaying it for the first time.  In any case, we only want
     to enable the widgets during an SE_ERROR if the Section Editor
     window has never been displayed.  Otherwise, the code after
     this takes care of displaying the correct section.
  */
  IF SE_Created = FALSE THEN
  DO:
    /* Position the Section Editor window's initial location at just
       below the UIB Main window, flush right to the screen edge.
    */
    ASSIGN h_sewin:ROW = (_h_menu_win:HEIGHT + 3) NO-ERROR.
    ASSIGN h_sewin:COLUMN = (SESSION:WIDTH - h_sewin:WIDTH) - 1 NO-ERROR.
    ENABLE isection btn_list btn_pcall
           se_event btn_new btn_rename wname txt
        WITH FRAME f_edit.
  END.

  /* Initialize isection */
  isection =      IF ( se_section = Type_Trigger )      THEN Trigs
             ELSE IF ( se_section = Type_Procedure )    THEN Procedures
             ELSE IF ( se_section = Type_Function  )    THEN Functions
             ELSE IF ( se_event   = Type_Definitions )  THEN Definitions
             ELSE IF ( se_event   = Type_Libraries )    THEN Libraries
             ELSE Main_Block .
  RUN set_isection.
  RUN change_trg (se_section, _SEW-recid, se_event, NO, NO,
                  OUTPUT dummy). 
  
  /* get an alphabetic list of widgets */
  RUN build_widget_list (wname).
  
  /* Assign current SEW status to _SEW record. - jep. */
  IF AVAILABLE _SEW_U THEN
    ASSIGN window-handle = _SEW_U._WINDOW-HANDLE.
  ELSE DO:
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
    ASSIGN window-handle = x_U._WINDOW-HANDLE.
  END.
  RUN AssignSEW ( se_section , se_recid , se_event , _SEW-recid , RECID(_SEW_TRG) ,
                  window-handle ).

  VIEW FRAME f_edit.
  
  IF _err_recid NE ? AND COMPILER:ERROR THEN
  DO ON STOP   UNDO, LEAVE
     ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE:
    ASSIGN _err_recid = ?.
    IF (_err_msg <> "") AND (_err_msg <> ?) THEN
    MESSAGE _err_msg
           VIEW-AS ALERT-BOX ERROR BUTTONS OK
                   IN WINDOW h_sewin.
    ASSIGN _err_msg   = "".
  END.

  IF CAN-DO(",SE_ERROR" , p_command ) THEN
  DO:
    IF h_sewin:VISIBLE = FALSE THEN ASSIGN h_sewin:VISIBLE = TRUE.
    
    /* First Time SEW is visible. */
    IF SE_Created = FALSE
    THEN DO:
      ASSIGN SE_Created = TRUE.
      
      /* Set max height to unknown ? to allow for maximizing. */
      ASSIGN h_sewin:MAX-HEIGHT = ?
             h_sewin:MAX-WIDTH  = ?.
      
      /* Make run-time adjustments to frame and txt widget H x W by
         programmatically calling the Section Editor window's resize routine.
         This handles small MSW resolutions where the FULL H and FULL W of
         the window are smaller than the initial Section Editor frame width.
      */
      RUN adeuib/_seresz.p ( INPUT h_sewin ).
      
    END.
    
    IF h_sewin:WINDOW-STATE = WINDOW-MINIMIZED
    THEN ASSIGN h_sewin:WINDOW-STATE = WINDOW-NORMAL.
    ELSE ASSIGN SEW_Logical = h_sewin:MOVE-TO-TOP().
  
    /* Enter the widget text. */
    APPLY "ENTRY" TO txt.

  END.
  
END. /* EDIT-BLOCK */

END PROCEDURE. 


PROCEDURE AssignSEW.
/*
  /* Assign current SEW status to _SEW record. - jep. */
  RUN AssignSEW ( se_section , se_recid , se_event ,
                  p_U_recid , p_TRG_recid , p_hwin ).
*/

DEFINE INPUT PARAMETER  se_section   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  se_recid     AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER  se_event     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  p_U_recid   AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER  p_TRG_recid AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER  p_hwin      AS WIDGET    NO-UNDO.

    IF NOT AVAILABLE _SEW
    THEN CREATE _SEW.
    ASSIGN _SEW._psection  = se_section
           _SEW._precid    = se_recid
           _SEW._pevent    = se_event
           _SEW._U_recid   = p_U_recid

           /* Don't assign null value.  99-05-13-011 (dma) */
           _SEW._TRG_recid = p_TRG_recid WHEN p_TRG_recid <> ?
           _SEW._hwin      = p_hwin
    . /* ASSIGN */

END PROCEDURE.


PROCEDURE se_store.

DEFINE INPUT PARAMETER p_command AS CHARACTER NO-UNDO.

DEFINE VARIABLE  l_section LIKE se_section.
DEFINE VARIABLE  l_recid   LIKE se_recid.
DEFINE VARIABLE  l_event   LIKE se_event.

DEFINE VARIABLE SEW_Logical AS LOGICAL INITIAL TRUE NO-UNDO.

    /* Its possible the widget got deleted in UIB main or that its a
       Browse Column field. */
    IF (AVAILABLE _SEW_U AND (_SEW_U._STATUS <> "DELETED"))
       OR
       (AVAILABLE _SEW_BC AND (RECID(_SEW_BC) = se_recid))
     THEN DO:

         ASSIGN l_section = se_section
                l_recid   = se_recid
                l_event   = se_event
                se_section = _SEW._psection
                se_recid   = _SEW._precid
                se_event   = _SEW._pevent
        . /* ASSIGN */
        
        /* Not first time, so save current code block. */
        RUN store_trg (TRUE, OUTPUT SEW_Logical).

        IF CAN-DO( ",SE_ERROR" , p_command )
        THEN DO:
            /* Re-assign back to incoming values. */
            ASSIGN  se_section = l_section
                    se_recid   = l_recid
                    se_event   = l_event
            . /* ASSIGN */
        END.
        IF NOT SEW_Logical THEN RETURN ERROR.
    END.

END PROCEDURE.


PROCEDURE se_upd_disp.

DEFINE OUTPUT PARAMETER p_upd_disp AS LOGICAL INITIAL FALSE NO-UNDO.
    
    /* A UIB event occurred which affects the SEW. However, since
       the SEW is not visible, then we can wait until the next
       time it becomes visible to update its screen info.
    */
    IF h_sewin:VISIBLE = FALSE THEN RETURN.
    
    /* Second case - event affecting SEW occurred, but in a
       window the SE is not currently open for.  Just return.
    */
    
    IF NOT AVAILABLE _SEW THEN RETURN.
    IF    _h_win = ?
       OR _SEW._hwin = ?
       OR _h_win <> _SEW._hwin THEN RETURN.
       
    ASSIGN p_upd_disp = TRUE.
END PROCEDURE.
    

PROCEDURE SEClose.
  /*-------------------------------------------------------------------------
    Purpose:    Executes the Section->Close option for the Section
                Editor window and optionally deletes the entire
                SEW and its child widgets.
                
    Run Syntax: RUN SEClose (INPUT p_command ).
    Parameters: 
    Notes     : The ON GO OF FRAME f_edit triggers duplicates this code.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_command AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ok2close   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE h_sewin    AS WIDGET  NO-UNDO.
  DEFINE VARIABLE scm_ok     AS LOGICAL NO-UNDO.

  ASSIGN ok2close = AVAILABLE( _SEW ) AND VALID-HANDLE( _SEW._hwin ).
  IF ok2close
  THEN DO:
    RUN store_trg (TRUE, OUTPUT ok2close). /* Store without asking */ 
    IF NOT ok2close THEN RETURN ERROR.
  END.
    
  /* For included version of SEW. - jep */
  ASSIGN h_sewin         = FRAME f_edit:PARENT
         h_sewin:VISIBLE = FALSE.

  /* Code References window detects this to see if it should close. (jep) */
  IF p_command = "SE_CLOSE":U THEN
    PUBLISH "SE_CLOSE":U.

  /* Code References window detects this to destroy itself. (jep) */
  IF p_command = "SE_EXIT":u THEN
    PUBLISH "SE_EXIT":U.
  
  IF p_command = "SE_EXIT" OR 
    (p_command = "SE_CLOSE" AND _multiple_section_ed) THEN
  DO: /* Delete SEW and its children. */
      /* Notify SCM of Section Editor Shutdown. */
      RUN adecomm/_adeevnt.p
          (INPUT  "Section Editor":U , INPUT "SHUTDOWN" ,
           INPUT  STRING(THIS-PROCEDURE) , INPUT STRING(h_sewin) ,
           OUTPUT scm_ok ) NO-ERROR.


      /* Issue 316: Clear _P._hSecEd handle when deleting a Sec Ed Window. */
      FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
      IF AVAILABLE _P THEN
        ASSIGN _P._hSecEd = ?.
    
      DELETE WIDGET h_sewin .
      DELETE PROCEDURE THIS-PROCEDURE.
  END.
  
  /* Update the Window menu active window items. (dma) */
  RUN WinMenuRebuild IN _h_uib.
    
END PROCEDURE.


PROCEDURE se_upd_widget_list .
  /*--------------------------------------------------------------------------
    Purpose:       In case widget name or label changed in UIB,
                   update the SEW widget list display.
    Run Syntax:    RUN se_upd_widget_list .
    Parameters:    <none>
    Notes:         
  ---------------------------------------------------------------------------*/
  DEFINE VARIABLE SEW_Logical  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE l_item       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_name       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Has_Freeform AS LOGICAL   NO-UNDO.

  DO WITH FRAME f_edit:

    /* Call to check that UIB window is same as SEW. */
    RUN se_upd_disp ( OUTPUT SEW_Logical ).
    IF SEW_Logical = FALSE THEN RETURN.

    /* Assign the Section Editor window title bar, in case
       the window name or title changed. */
    RUN se_set_title ( _SEW._hwin ).
    
    ASSIGN l_name = _U._NAME.
    /* If dbfield, make name = dbname.table.field-name. */
    IF _U._DBNAME <> ? THEN
       ASSIGN l_name = (_U._DBNAME + "." + _U._TABLE + "." + _U._NAME) .
    
    RUN GetWidgetListName ( INPUT l_name ,
                            INPUT _U._LABEL ,
                            OUTPUT l_item ).

    /* If not in the list, then there was either a Name or Label change. */
    IF wname:LOOKUP( l_item ) <= 0 THEN
    DO:
      /* If Current UIB widget is same as in SEW, update to
         new widget name/label.  Otherwise, just rebuild
         widget list but don't change name of current SEW
         widget.
      */
      IF RECID( _U ) = _SEW-recid
        THEN RUN build_widget_list ( l_name ).
        ELSE RUN build_widget_list ( wname ).
    END.
    ELSE IF RECID( _U ) = _SEW-recid THEN
    DO:
      /* Check if the section ed object got trigger events added. This can
         happen for objects that acquire Freeform queries from the
         Property Sheet. Must add any new events to the event list. */
      RUN Has_Freeform (INPUT _SEW-recid , OUTPUT Has_Freeform).
      IF Has_Freeform AND se_event:LOOKUP("OPEN_QUERY":U) = 0 THEN
      DO:
        ASSIGN l_name = se_event:SCREEN-VALUE.
        /* Running this here picks up the new Freeform event triggers. */
        RUN build_event_list.
        ASSIGN se_event:SCREEN-VALUE = l_name.
      END.
    END.
  END. /* DO WITH */

END PROCEDURE.
            
PROCEDURE se_emdrp.
  /*-------------------------------------------------------------------------
    Purpose:   On the MENU-DROP event for the UIB Section Editor Window's
               Edit Menu, set the sensitive state of the Edit Menu
               selections.
    Run Syntax:     RUN se_emdrp.
    Parameters:     None
    Description:
    Notes  :
                
    Authors: John Palazzo
    Date   : March, 1994
  ---------------------------------------------------------------------------*/

DEFINE VARIABLE h_Menu_Item    AS WIDGET    NO-UNDO.

DO ON STOP UNDO, LEAVE WITH FRAME f_edit:

    ASSIGN h_Menu_Item           = MENU mnu_edit:FIRST-CHILD /* Undo  */
           h_Menu_Item:SENSITIVE = /* TRUE IF... */
                (txt:EDIT-CAN-UNDO AND txt:MODIFIED)
           h_Menu_Item           = h_Menu_Item:NEXT-SIBLING  /* Undo All */
           h_Menu_Item:SENSITIVE = /* TRUE IF... */
                ( NOT txt:READ-ONLY )
                AND txt:MODIFIED OR
                    (editted_event <> se_event
                     AND CAN-DO(Type_Trigger + "," + Type_Procedure + ","
                                                   + Type_Function,
                                se_section) )
           h_Menu_Item           = h_Menu_Item:NEXT-SIBLING  /* Rule  */
           h_Menu_Item           = h_Menu_Item:NEXT-SIBLING  /* Cut   */
           /* You can always do a cut in the source editor. It will cut
           ** the selection if text is selected. Otherwise it cuts the
           ** line the cursor is on.
           */
           h_Menu_Item:SENSITIVE = /* TRUE IF... */
                IF txt:SOURCE-EDITOR THEN
                    ( NOT txt:READ-ONLY )
                ELSE
                    ( NOT txt:READ-ONLY ) AND ( txt:TEXT-SELECTED )
           h_Menu_Item           = h_Menu_Item:NEXT-SIBLING  /* Copy  */
           /* You can always do a copy in the source editor. It will copy
           ** the selection if text is selected. Otherwise it copies the
           ** line the cursor is on.
           */
           h_Menu_Item:SENSITIVE = /* TRUE IF... */
                IF txt:SOURCE-EDITOR THEN
                    TRUE
                ELSE
                    ( txt:TEXT-SELECTED )
           h_Menu_Item           = h_Menu_Item:NEXT-SIBLING  /* Paste */
           h_Menu_Item:SENSITIVE = /* TRUE IF... */
                ( txt:EDIT-CAN-PASTE ) AND ( NOT txt:READ-ONLY )
           SUB-MENU  m_Format_Menu1:SENSITIVE = /* TRUE IF */
                ( NOT txt:READ-ONLY ) AND ( txt:TEXT-SELECTED )
           .
END. /* DO ON STOP */

END PROCEDURE.


PROCEDURE se_set_title:
  /*-------------------------------------------------------------------------
    Purpose:    Assigns the Section Editor Window Title Bar.
                
    Run Syntax: RUN se_set_title ( INPUT p_U_handle ).
    Parameters: 
    Notes     : 
  ---------------------------------------------------------------------------*/

  /* Window handle of current design window being edited by Section Editor. */
  DEFINE INPUT PARAMETER p_U_handle AS HANDLE    NO-UNDO.

  DEFINE BUFFER   b_U FOR _U.
  
  DEFINE VARIABLE cHostName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldTitle  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE v_FileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v_Handle   AS HANDLE    NO-UNDO.
  
  FIND b_U WHERE b_U._HANDLE = p_U_handle.
  FIND _P  WHERE _P._u-recid = RECID(b_U).

  /* Get the current filename. */
  ASSIGN v_Filename = _P._SAVE-AS-FILE.
  
  /* If the value is UNKNOWN, then the window is Untitled. However, if there
     are multilple untitled windows, then the title shows as "Untitled:2".
     Look at the actual window and get the "Untilted:n". Remember to
     get the 'true' window if the design window is a DIALOG-BOX. */
  IF v_Filename eq ? THEN DO: 
    ASSIGN v_Handle = IF p_U_Handle:TYPE = "WINDOW"
                      THEN p_U_Handle ELSE p_U_Handle:PARENT NO-ERROR.
           ix       = INDEX(v_Handle:TITLE, "Untitled").
    IF ix eq 0 THEN v_Filename = "Untitled":U. /* This should never happen. */
    ELSE DO:
      v_Filename = SUBSTRING (v_Handle:TITLE, ix, -1, "CHARACTER":U).
      /* Watch out for cases where there are layout names after the Untitled. */
      v_FileName = ENTRY (1, v_FileName, " ":U).
    END. /* IF ix > 0 ... */
  END. /* IF v_FileName eq ? THEN DO: ... */
  
  /* Title is "Section Editor - <ObjectType> - <Filename>". 
     The ENTRY(NUM-ENTRIES) code picks the last item in the window's
     title if the base filename is unknown.
  */                 
  ASSIGN
    cOldTitle     = h_sewin:TITLE
    h_sewin:TITLE = {&SE_Title_Leader} + _P._TYPE + " - ":U + v_FileName + 
                    DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, TRUE,
                                     STRING(_h_win)) NO-ERROR.

  /* Update the Window menu. (dma) */
  IF VALID-HANDLE(_h_WinMenuMgr) THEN
    RUN WinMenuChangeName IN _h_WinMenuMgr 
      (_h_WindowMenu, cOldTitle, h_sewin:TITLE).
  
END PROCEDURE.


PROCEDURE se_help.  
  /*-------------------------------------------------------------------------
    Purpose:    Display appropriate Help for Section Editor Window.
              
    Run Syntax: RUN se_help (INPUT p_Help_Context).
    Parameters: 
    Notes     : 
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Help_Context AS INTEGER NO-UNDO.
  
  DO WITH FRAME f_edit:
    IF (p_Help_Context <> ?) THEN
    CASE isection:
        WHEN Definitions THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Defs}.
        WHEN Trigs THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Trigs}.
        WHEN Libraries THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Libs}.
        WHEN Main_Block THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Main}.
        WHEN Procedures THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Procs}.
        WHEN Functions THEN
            ASSIGN p_Help_Context = {&Section_Editor_Help_Funcs}.
    END CASE.
        
    RUN EditHelp ( txt:HANDLE , "AB" , p_Help_Context ).
  END.
  
END PROCEDURE.


PROCEDURE build_event_list.
  /*--------------------------------------------------------------------------
    Purpose:       Sets the se_event COMBO-BOX to a value appropriate for the
                   current _SEW_U record. i.e. all TRIGGERS and all normal
                   events.
    Run Syntax:    RUN build_event_list.
    Parameters:    <none>
    Notes:         Require a current _SEW_U record.
  ---------------------------------------------------------------------------*/
  DEF VAR h          AS widget  NO-UNDO.
  DEF VAR l_ok       AS logical NO-UNDO.
  DEF VAR other      AS char    NO-UNDO.
  DEF VAR widg-type  AS char    NO-UNDO.

  DEFINE BUFFER x_SEW_TRG FOR _SEW_TRG.
  
  /* Empty the current list. */
  ASSIGN h = se_event:HANDLE in FRAME f_edit
         h:SCREEN-VALUE = ?
         h:LIST-ITEMS = ""
         h:DELIMITER  = CHR(10). /* We could have a comma as a item.  */        
  /* Get all the _CONTROL triggers for the current widget */
  FOR EACH x_SEW_TRG WHERE x_SEW_TRG._wRECID   = _SEW-recid
                     AND   x_SEW_TRG._tSECTION = Type_Trigger :
    ASSIGN l_ok  =  h:ADD-LAST(x_SEW_TRG._tEVENT).
  END.
  ASSIGN widg-type = IF AVAILABLE _SEW_U THEN _SEW_U._TYPE
                                         ELSE "BROWSE-COLUMN":U.
  
  /* Add in the other (best default event) */
  RUN get_default_event (INPUT widg-type, OUTPUT other).
  IF ( h:LOOKUP(other) = 0 ) THEN
    ASSIGN l_ok = h:ADD-LAST( other ) .
  
END PROCEDURE. /*  build_event_list. */

PROCEDURE build_proc_list.
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
  FOR EACH _SEW_TRG WHERE _SEW_TRG._wRECID = win_recid
                    AND   _SEW_TRG._tSECTION = Type_Procedure :
    ASSIGN procname = _SEW_TRG._tEVENT
           l_ok     =  phList:ADD-LAST(procname).
  END.
END PROCEDURE. /* build_proc_list. */


PROCEDURE build_func_list.
  /*--------------------------------------------------------------------------
    Purpose:       Sets the se_event  COMBO-BOX to a value appropriate for the
                   current window's functions.
    Run Syntax:    RUN build_func_list.
    Parameters:     phList - the handle of the selection list to populate.
    Notes:         Require a current win_recid.
  ---------------------------------------------------------------------------*/
  def input parameter  phList     as widget  no-undo.

  def var l_ok     as logical no-undo.
  def var funcname as char    no-undo.
  
  /* Empty the current list. */
  ASSIGN phList:SCREEN-VALUE = ?
         phList:LIST-ITEMS = "".        
  /* Get all the functions for the current UIB Design Object. */
  FOR EACH _SEW_TRG WHERE _SEW_TRG._wRECID = win_recid
                    AND   _SEW_TRG._tSECTION = Type_Function :
    ASSIGN funcname = _SEW_TRG._tEVENT
           l_ok     =  phList:ADD-LAST(funcname).
  END.
END PROCEDURE. /* build_func_list. */


PROCEDURE build_widget_list.
  /*--------------------------------------------------------------------------
    Purpose:       Sets the wname COMBO-BOX to a value appropriate
                   for the current window's list of widgets.
    Run Syntax:    RUN build_widget_list.
    Parameters:    init_value - the starting value.
    Notes:         Require a current win_recid.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER init_value AS CHAR NO-UNDO. 
  
  DEFINE BUFFER x_U  FOR _U.
  DEFINE BUFFER x_BC FOR _BC.
  DEFINE BUFFER p_U  FOR _U.
  
  DEFINE VAR list_item    AS CHAR NO-UNDO.
  DEFINE VAR object_name  AS CHAR NO-UNDO.
  DEFINE VAR Has_Freeform AS LOGI NO-UNDO.

  IF NOT VALID-HANDLE(h_win_trig) THEN DO:
    /* Get the window (and its save-as-file) for this trigger */
    IF AVAILABLE _SEW_U THEN
      h_win_trig = _SEW_U._WINDOW-HANDLE.
    ELSE RETURN.
  END.
  DO WITH FRAME f_edit:
  
    /* Using ADD-LAST is visibly slow in Motif. So hide widget. */
    IF SESSION:WINDOW-SYSTEM = "OSF/Motif" THEN
        ASSIGN wname:HIDDEN = TRUE.

    ASSIGN wname:DELIMITER  = CHR(10) /* Some labels will have commas  */
           wname:LIST-ITEMS = "".
    /* Put names of widgets of current window into widget combo-box.  
       alphabetically. Don't include QUERY, SmartObject, TEXT, RULE, SKIP 
       or MENUBAR widgets (which cannot have triggers).  
       EXCEPTION: Query that has Freeform query can have OPEN_QUERY trigger. */
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE = h_win_trig AND 
                       x_U._STATUS NE "DELETED" BY x_U._NAME:
      IF NOT (CAN-DO("SmartObject,TEXT", x_U._TYPE) OR
              x_U._SUBTYPE = "DESIGN-WINDOW":U OR
             (CAN-DO("MENU,MENU-ITEM",x_U._TYPE) AND
              CAN-DO("MENUBAR,RULE,SKIP",x_U._SUBTYPE)))
      THEN DO:
        
        IF x_U._TYPE = "QUERY":U THEN
        DO:
          RUN Has_Freeform (INPUT RECID(x_U), OUTPUT Has_Freeform).
          IF Has_Freeform = FALSE THEN NEXT.
        END.

        /* This assign handles when object is a dbfield. */
        ASSIGN object_name = IF x_U._DBNAME = ?
                             THEN x_U._NAME
                             ELSE (x_U._DBNAME + "." +
                                   x_U._TABLE  + "." +
                                   x_U._NAME)
               . /* END ASSIGN */

        /* Rohit- if dbfield is part of FRAME, getWidgetListName requires <FRAME> in label. */
        if INDEX( object_name , "." ) NE 0 THEN DO:
	FIND p_U WHERE RECID(p_U) = x_U._PARENT-RECID NO-ERROR.
	  IF AVAILABLE p_U THEN RUN GetWidgetListName ( INPUT Object_Name , INPUT "<":U + p_U._NAME + " FRAME>" ,
                                OUTPUT list_item ).
	  else
	  RUN GetWidgetListName ( INPUT Object_Name , INPUT x_U._LABEL ,
                                OUTPUT list_item ).

        END.
        else 
        RUN GetWidgetListName ( INPUT Object_Name , INPUT x_U._LABEL ,
                                OUTPUT list_item ).

        ASSIGN dummy = wname:ADD-LAST(list_item).
        IF object_name = ENTRY( 1 , init_value , " ")
           AND wname:SCREEN-VALUE <> list_item
        THEN wname:SCREEN-VALUE = list_item. 
        
        /* Assign the handle of the first trigger object. */
        ASSIGN h_first_obj = x_U._HANDLE WHEN wname:NUM-ITEMS = 1.

        IF x_U._TYPE = "BROWSE":U THEN DO:
          FOR EACH x_BC WHERE x_BC._x-recid = RECID(x_U)
                          AND (x_BC._DATA-TYPE <> ?):  /* ? if calc field */
            RUN GetWidgetListName (INPUT x_BC._DISP-NAME,
                                   INPUT "<":U + x_U._NAME + " Column>",
                                   OUTPUT list_item ).
            ASSIGN dummy = wname:ADD-LAST(list_item).
            IF (list_item = init_value) AND (wname:SCREEN-VALUE <> list_item)
            THEN wname:SCREEN-VALUE = list_item.

          END. /* FOR EACH BROWSE */
        END. /* If a Browse */
      END.
    END.
    /* Prevent an invalid inital value. - jep */
    IF wname:LOOKUP(wname) <= 0 THEN ASSIGN wname = "".
    
    /* Only need to see the widget if its the Triggers section. */
    IF SESSION:WINDOW-SYSTEM = "OSF/Motif" AND se_section = Type_Trigger THEN
        ASSIGN wname:VISIBLE = TRUE.
        
  END.

END PROCEDURE.  

        
PROCEDURE Has_Freeform .
  /*--------------------------------------------------------------------------
    Purpose: Returns whether an object has a Freeform query or not.

    Run Syntax:
        RUN Has_Freeform (INPUT RECID(_SEW_U), OUTPUT p_Has_Freeform).

    Parameters:   
    Notes:        
  ---------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_u-recid      AS RECID NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Has_Freeform AS LOGICAL NO-UNDO.
 
  DEFINE BUFFER x_U   FOR _U.
  DEFINE BUFFER x_TRG FOR _TRG.

  FIND FIRST x_TRG WHERE x_TRG._wRECID   = p_u-recid
                    AND  x_TRG._tSPECIAL = "_OPEN-QUERY":U
                    AND  x_TRG._STATUS <> "DELETED":U
                   NO-LOCK NO-ERROR.
  ASSIGN p_Has_Freeform = AVAILABLE x_TRG.
  RETURN.
END PROCEDURE.

PROCEDURE Has_Trigger .
  /*--------------------------------------------------------------------------
    Purpose: Returns whether an event for an object has a trigger block.

    Run Syntax:
        RUN Has_Trigger
            (INPUT RECID(_SEW_U), INPUT p_event, OUTPUT p_Has_Trigger).

    Parameters:
    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_sew_recid   AS RECID NO-UNDO.
  DEFINE INPUT  PARAMETER p_event       AS CHAR  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_has_trigger AS LOGICAL NO-UNDO.

  DEFINE BUFFER x_SEW_TRG FOR _SEW_TRG.
  FIND x_SEW_TRG WHERE x_SEW_TRG._tSECTION = Type_Trigger
                 AND   x_SEW_TRG._wRECID = p_sew_recid
                 AND   x_SEW_TRG._tEVENT = p_event
                 AND   x_SEW_TRG._STATUS <> "DELETED"
                 NO-LOCK NO-ERROR.
  ASSIGN p_has_trigger = AVAILABLE x_SEW_TRG.
  RETURN.
END PROCEDURE.

PROCEDURE freeform_update .
  /*--------------------------------------------------------------------------
    Purpose:       Updates a freeform query object.
    
    Run Syntax:
        RUN freeform_update (INPUT RECID(_SEW_U)).
    
    Parameters:    
    Notes:         
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_u-recid AS RECID NO-UNDO.
  
  DEFINE BUFFER x_SEW_U FOR _U.
  DEFINE BUFFER x_C FOR _C.
  DEFINE BUFFER x_Q FOR _Q.
  
  FIND x_SEW_U WHERE RECID(x_SEW_U) = p_u-recid.
  /* Get the Container record. */
  FIND x_C WHERE RECID(x_C) = x_SEW_U._x-recid.
  /* Get the Query record. */
  FIND x_Q WHERE RECID(x_Q) = x_C._q-recid.
  /* Clear the query. */
  ASSIGN x_Q._4GLQury = ""
         x_Q._TblList = ""
         . /* END ASSIGN */

  /* Recreate the freeform browse object in the container window. */
  IF x_SEW_U._TYPE = "BROWSE":U THEN DO:
      IF VALID-HANDLE(x_SEW_U._PROC-HANDLE) THEN /* SmartBrowse */
        RUN destroyObject IN x_SEW_U._PROC-HANDLE.
      ELSE IF VALID-HANDLE(x_SEW_U._HANDLE) THEN /* Other Browse */
        DELETE WIDGET x_SEW_U._HANDLE.
      RUN adeuib/_undbrow.p ( INPUT p_u-recid ).
  END.

END PROCEDURE.

PROCEDURE GetAttribute.
  /*--------------------------------------------------------------------------
    Purpose:
        Returns the value of a specified Section Editor attribute
        as a character string.
        
    Run Syntax:
    
        RUN GetAttribute ( INPUT p_Attribute , OUTPUT p_Value ).

    Notes:         
  ---------------------------------------------------------------------------*/
        
  DEFINE INPUT  PARAMETER p_Attribute AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Value     AS CHARACTER NO-UNDO.
  
  /* IF NOT AVAILABLE _SEW THEN RETURN. - jep */
  /* This line is commented out because it prevents some of the attribute
     requests from completing when _SEW is not available. Use NO-ERROR's
     instead of just returning. - jep October 12, 1999.
  */

  CASE p_Attribute:
    /* Recid of the _TRG record being editing in the Section Editor. */
    WHEN "CURRENT-TRG":U THEN
        ASSIGN p_Value = STRING(_SEW._TRG_Recid) NO-ERROR.
    
    /* Recid of the _U record being editing in the Section Editor. */
    WHEN "CURRENT-OBJECT":U THEN
        ASSIGN p_Value = STRING(_SEW._U_Recid) NO-ERROR.
        
    /* Handle of the window container being edited in the Section Editor. */
    WHEN "CURRENT-WINDOW":U THEN
        ASSIGN p_Value = STRING(_SEW._hwin) NO-ERROR.
           
    /* Recid of the procedure object being edited in the Section Editor. */
    WHEN "CURRENT-PROCEDURE":U THEN
    DO:
        FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
        ASSIGN p_Value = STRING(RECID(_P)) NO-ERROR.
    END.

    /* Handle of the section editor window. */
    WHEN "SE-WINDOW":U THEN
        ASSIGN p_Value = STRING(h_sewin) NO-ERROR.
       
  END CASE.

END PROCEDURE.

PROCEDURE GetWidgetListName .
  /*--------------------------------------------------------------------------
    Purpose:       Returns the name of a widget list item based on
                   the widget's Name and Label.
    Run Syntax:    RUN GetWidgetListName
                       ( INPUT p_Name , INPUT p_Label ,
                         OUTPUT p_List_Item ).

    Parameters:    
    Notes:         
  ---------------------------------------------------------------------------*/
        
  DEFINE INPUT  PARAMETER p_Name      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_Label     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_List_Item AS CHARACTER NO-UNDO.

  DEFINE VARIABLE col_stop AS INTEGER NO-UNDO.
  DO WITH FRAME f_edit:
    ASSIGN col_stop = INTEGER( MAX(.33 * wname:WIDTH, 15) ).
    ASSIGN p_list_item = p_Name.
    IF p_Label <> ? THEN
    DO:
      IF LENGTH( p_list_item , "RAW":U) < col_stop THEN
          SUBSTRING( p_list_item , col_stop + 1 ) = p_Label.
      ELSE
          ASSIGN p_list_item = (p_list_item + " ":U + p_Label).
    END.
  END.
END PROCEDURE.
        

PROCEDURE ChangeSection.
  /*-------------------------------------------------------------------------
    Purpose:        Change to a new section in the Section Editor window.
    Run Syntax:     RUN ChangeSection (INPUT p_new_section).
    Parameters:     
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_new_section AS CHARACTER NO-UNDO.
  
  DEFINE BUFFER x_SEW_TRG FOR _SEW_TRG.

  DEFINE VAR vsection     AS CHARACTER NO-UNDO.
  DEFINE VAR ok2change    AS LOGICAL   NO-UNDO.
  DEFINE VAR Sec-Type     AS CHARACTER NO-UNDO.
  DEFINE VAR recent_block AS CHARACTER NO-UNDO.
  
  IF isection <> p_new_section THEN DO:
    ASSIGN isection:SCREEN-VALUE IN FRAME f_edit = p_new_section .
    
    CASE isection:SCREEN-VALUE IN FRAME f_edit :
      WHEN Definitions THEN
        RUN change_trg ("_CUSTOM", win_recid, Type_Definitions ,
                        NO, YES, OUTPUT ok2change).
      WHEN Trigs THEN
        RUN change_trg (Type_Trigger, recent_recid, recent_trig, NO, YES,
                         OUTPUT ok2change).
      WHEN Libraries THEN
        RUN change_trg ("_CUSTOM", win_recid, Type_Libraries ,
                        NO, YES, OUTPUT ok2change).
      WHEN Main_Block THEN
        RUN change_trg ("_CUSTOM", win_recid, Type_Main_Block ,
                        NO, YES, OUTPUT ok2change).
      WHEN Procedures OR WHEN Functions THEN
      DO:
        ASSIGN Sec-Type     = IF p_new_section = Procedures THEN Type_Procedure ELSE Type_Function
               recent_block = IF p_new_section = Procedures THEN recent_proc ELSE recent_func.
        
        /* Check that there are internal procedures. */
        FIND FIRST x_SEW_TRG WHERE x_SEW_TRG._wRECID   = win_recid
                             AND   x_SEW_TRG._tSECTION = Sec-Type
                             AND   x_SEW_TRG._STATUS <> "DELETED" NO-ERROR.
        IF AVAILABLE x_SEW_TRG THEN
          RUN change_trg (Sec-Type , win_recid, recent_block, NO, YES,
                          OUTPUT ok2change).
        ELSE  /* If no procs or functions, request for a new one. */
        DO:
          /* Save the current section code before asking if the user want's
             to create a new procedure or function.
          */
          CASE isection: /* isection's value is current section */
            WHEN Definitions THEN
                RUN change_trg ("_CUSTOM", win_recid, Type_Definitions ,
                                NO, YES, OUTPUT ok2change).
            WHEN Trigs THEN
                RUN change_trg (Type_Trigger, recent_recid,recent_trig, NO, YES,
                                OUTPUT ok2change).
            WHEN Libraries THEN
                RUN change_trg ("_CUSTOM", win_recid, Type_Libraries,
                                NO, YES, OUTPUT ok2change).
            WHEN Main_Block THEN
                RUN change_trg ("_CUSTOM", win_recid, Type_Main_Block,
                                NO, YES, OUTPUT ok2change).
            WHEN Procedures OR WHEN Functions THEN
                RUN store_trg (FALSE, OUTPUT ok2change).
          END CASE.

          ASSIGN vsection   = se_section
                 se_section = Sec-Type .
          RUN NoProcs ( INPUT Sec-Type, OUTPUT ok2change ).
          IF NOT ok2change THEN ASSIGN se_section = vsection.
        END.
      END. /* WHEN Procedures */
    END CASE.
    
    IF ok2change THEN DO:
      isection = p_new_section.
      RUN set_isection.
    END.
    ELSE DO: 
        /* Go back to old section value. */
        ASSIGN isection:SCREEN-VALUE IN FRAME f_edit = isection.
        APPLY "ENTRY" TO txt IN FRAME f_edit.
    END.
  END.

END PROCEDURE.


PROCEDURE NoProcs.
  /*-------------------------------------------------------------------------
    Purpose:        Requests user for new procedure or function when there are none.
    Run Syntax:     RUN NoProcs ( INPUT p_Type, OUTPUT p_oknew ).
    Parameters: 
    Notes:          Changes Section Editor-wide variable se_section.    
  ---------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER p_Type    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_oknew   AS LOGICAL   NO-UNDO.
  
  DEFINE VAR MsgText AS CHARACTER NO-UNDO.
  
  DEFINE BUFFER x_SEW_TRG FOR _SEW_TRG.
          
  DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
    IF NOT RETRY THEN DO:
        ASSIGN p_oknew       = TRUE.
        
        IF (p_Type = Type_Procedure) THEN
          ASSIGN MsgText = "There are no procedures defined.".
        ELSE
          ASSIGN MsgText = "There are no functions defined.".

        MESSAGE MsgText + " Create a new one?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                        UPDATE p_oknew IN WINDOW h_sewin.
        IF p_oknew THEN
        DO:
            /* Here, se_section is = "_PROCEDURE" or "_FUNCTION" . */
            RUN NewBlock.
            /* Check that a new internal procedure/function was created. */
            FIND FIRST x_SEW_TRG WHERE x_SEW_TRG._wRECID = win_recid
                                 AND   x_SEW_TRG._tSECTION = p_Type
                                 AND   x_SEW_TRG._tSECTION <> "DELETED":U
                                 NO-ERROR.
            IF NOT AVAILABLE x_SEW_TRG OR (RETURN-VALUE = "_CANCEL":u) THEN
            DO:
                ASSIGN p_oknew = FALSE.
                STOP.
            END.
        END.
    END.
    ELSE
        ASSIGN p_oknew = FALSE.
  END.
END PROCEDURE.

PROCEDURE ListBlocks.
  /*-------------------------------------------------------------------------
    Purpose:        Trigger for choosing sections from the list.
    Run Syntax:     RUN ListBlocks.
    Parameters:     None
  ---------------------------------------------------------------------------*/

  DEFINE VAR n_section     AS CHAR        NO-UNDO.
  DEFINE VAR n_recid       AS RECID       NO-UNDO.
  DEFINE VAR n_event       AS CHAR        NO-UNDO.

  DEFINE VAR ok2change     AS LOGICAL     NO-UNDO.
  DEFINE VAR n_isection    AS CHARACTER   NO-UNDO.
  DEFINE VAR n_codeitems   AS CHARACTER   NO-UNDO.
  DEFINE VAR h_cwin        AS WIDGET      NO-UNDO.

  ASSIGN n_section = se_section
         n_recid   = _SEW-recid
         n_event   = se_event.

  IF NOT VALID-HANDLE(h_win_trig) THEN DO:
    /* Get the window (and its save-as-file) for this trigger */
    IF AVAILABLE _SEW_U THEN
      h_win_trig = _SEW_U._WINDOW-HANDLE.
    ELSE RETURN.
  END.

  ASSIGN h_cwin         = CURRENT-WINDOW
         CURRENT-WINDOW = h_sewin.
  DO ON STOP UNDO, LEAVE:
    RUN adeuib/_seltrg.p
        (INPUT h_win_trig,
         INPUT "_LIST" /* command */,
         INPUT-OUTPUT n_section,
         INPUT-OUTPUT n_recid,
         INPUT-OUTPUT n_event,
         OUTPUT n_codeitems /* unused ny ListBlocks */,
         OUTPUT ok2change).
  END.
  ASSIGN CURRENT-WINDOW = h_cwin.
 
  IF ok2change AND 
     (n_section <> se_section OR n_recid <> _SEW-recid OR n_event <> se_event) 
  THEN DO:
    RUN change_trg (n_section, n_recid,  n_event, no, yes, OUTPUT ok2change).  
    n_isection =     IF (n_section = Type_Trigger )   THEN Trigs
                ELSE IF (n_section = Type_Procedure ) THEN Procedures
                ELSE IF (n_section = Type_Function  ) THEN Functions
                ELSE IF (n_event = Type_Definitions ) THEN Definitions
                ELSE IF (n_event = Type_Libraries )   THEN Libraries  
                ELSE Main_Block.
    IF ok2change AND n_isection <> isection THEN DO:
      isection = n_isection.
      RUN set_isection.
    END.
  END.
END PROCEDURE.


PROCEDURE NextSearchBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Move to next search all code block in a list.
    Run Syntax:     RUN NextSearchBlock
                        (INPUT p_Sect-List, INPUT p_Sect-First, INPUT-OUTPUT p_Sect-Curr).
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER  p_Sect-List     AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER  p_Sect-First    AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER  p_Sect-Curr     AS CHAR NO-UNDO.

  DEFINE VAR n_section     AS CHAR        NO-UNDO.
  DEFINE VAR n_recid       AS RECID       NO-UNDO.
  DEFINE VAR n_event       AS CHAR        NO-UNDO.

  DEFINE VAR ok2change     AS LOGICAL     NO-UNDO.
  DEFINE VAR n_isection    AS CHARACTER   NO-UNDO.
  DEFINE VAR h_cwin        AS WIDGET      NO-UNDO.
  DEFINE VAR p_list        AS CHAR        NO-UNDO.

  DEFINE BUFFER b_SEW_TRG FOR _SEW_TRG.

  IF NOT VALID-HANDLE(h_win_trig) THEN DO:
    /* Get the window (and its save-as-file) for this trigger */
    IF AVAILABLE _SEW_U THEN
      h_win_trig = _SEW_U._WINDOW-HANDLE.
    ELSE RETURN.
  END.

  ASSIGN n_section = se_section
         n_recid   = _SEW-recid
         n_event   = se_event.

  ASSIGN h_cwin         = CURRENT-WINDOW
         CURRENT-WINDOW = h_sewin.
  Blk_Find:
  DO WHILE TRUE ON STOP UNDO, LEAVE:
    RUN GetNextSearchSection (h_win_trig, INPUT p_Sect-List, INPUT-OUTPUT p_Sect-Curr,
                                          INPUT-OUTPUT n_section,
                                          INPUT-OUTPUT n_recid,
                                          INPUT-OUTPUT n_event,
                                          OUTPUT ok2change).

    IF (ok2change = FALSE) THEN LEAVE Blk_Find.
    FIND b_SEW_TRG WHERE b_SEW_TRG._tSECTION = n_section AND
                         b_SEW_TRG._wRECID   = n_recid AND
                         b_SEW_TRG._tEVENT   = n_event AND
                         b_SEW_TRG._STATUS <> "DELETED" NO-ERROR.
    IF (p_Sect-Curr = p_Sect-First)
        OR INDEX(b_SEW_TRG._tCODE, Find_Text) > 0 THEN LEAVE Blk_Find.
  END.
  ASSIGN CURRENT-WINDOW = h_cwin.
 
  IF ok2change AND 
     (n_section <> se_section OR n_recid <> _SEW-recid OR n_event <> se_event) THEN
  DO:
    RUN change_trg (n_section, n_recid,  n_event, no, yes, OUTPUT ok2change).  
    n_isection = IF (n_section = Type_Trigger ) THEN Trigs
                ELSE IF (n_section = Type_Procedure ) THEN Procedures
                ELSE IF (n_section = Type_Function )  THEN Functions
                ELSE IF (n_event = Type_Definitions ) THEN Definitions
                ELSE IF (n_event = Type_Libraries )   THEN Libraries
                ELSE Main_Block.
    IF ok2change AND n_isection <> isection THEN
    DO:
      isection = n_isection.
      RUN set_isection.
    END.
    IF (p_Sect-Curr = p_Sect-First) THEN RETURN "_DONE":U.
  END.
  ELSE IF (not ok2change) AND (p_Sect-First = "":U) THEN
  DO:
    /* Back at the first section, when that section as an "empty" or
       unchanged default trigger section. */
    RETURN "_DONE":U.
  END.
  ELSE RETURN "_NOT-FOUND":U.
END PROCEDURE.


PROCEDURE GetNextSearchSection.
/*-----------------------------------------------------------------------------

  Procedure: GetNextSearchSection

  Description: 
      Return the next code block section from the list of blocks. Used by
      Search All Sections filter.

      Must be kept in sync with:
          adeuib/_seltrg.p
          adeuib/_seprocs.i PROCEDURE GetSearchAllList.

  Input Parameters:
      h_trg_win   -  The handle of the window to list triggers for.
      p_Sect-List -  Comma-delimited list of Code Sections.

  Input-Output Parameters:
      p_Sect-Curr - INPUT: current code section; OUTPUT: next section.
      p_section - the current section at input; the desired section at
                  output (eg. _CUSTOM, _CONTROL, _PROCEDURE, _FUNCTION)
      p_recid   - the current (and desired) recid
      p_event   - the current (and desired) name of pseudo-event or event.
                  eg.  CHOOSE or _DEFINITIONS.
  
  Output Parameters:
      p_ok     - TRUE if user pressed OK.

  Author  : J. Palazzo
  Created : 14 Nov 1996
  Modified:
-----------------------------------------------------------------------------*/
/* Define Parameters. */
DEFINE INPUT        PARAMETER  h_trg_win    AS WIDGET   NO-UNDO.
DEFINE INPUT        PARAMETER  p_Sect-List  AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_Sect-Curr  AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_section    AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_recid      AS RECID    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_event      AS CHAR     NO-UNDO.
DEFINE       OUTPUT PARAMETER  p_ok         AS LOGICAL  NO-UNDO.

/* Local Buffers. */
DEFINE BUFFER x_U  FOR _U.
DEFINE BUFFER p_U  FOR _U.
DEFINE BUFFER x_BC FOR _BC.

/* Local Variable Definitions. */
DEF  VAR win_recid    AS RECID                                   NO-UNDO.
         /* RECID of window for the triggers and code                 */
DEF  VAR l_dummy      AS LOGICAL                                 NO-UNDO.
         /* dummy logical to accept result of methods                 */
DEF  VAR item         AS CHAR                                    NO-UNDO.
         /* store 1 item of sel-list                                  */
DEF  VAR object_name  AS CHAR                                    NO-UNDO.
DEF  VAR rule_char    AS CHAR    INIT "-":u                      NO-UNDO.
DEF  VAR tcode        AS CHAR                                    NO-UNDO.


/* Get the window record */
FIND x_U WHERE x_U._HANDLE = h_trg_win NO-ERROR.
IF NOT AVAILABLE x_U THEN RETURN.  /* this should never happen. */
ASSIGN win_recid = RECID(x_U)
       p_ok      = FALSE. /* Unless we here otherwise */

IF LOOKUP(p_Sect-Curr, p_Sect-List) = NUM-ENTRIES(p_Sect-List) THEN
  ASSIGN p_Sect-Curr = ENTRY(1 , p_Sect-List).
ELSE
  ASSIGN p_Sect-Curr = ENTRY(LOOKUP(p_Sect-Curr, p_Sect-List) + 1, p_Sect-List).

DO:
  ASSIGN p_ok = TRUE.
  
  IF p_Sect-Curr = "DEFINITIONS" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_DEFINITIONS".
  ELSE IF p_Sect-Curr = "INCLUDED LIBRARIES" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_INCLUDED-LIBRARIES".
  ELSE IF p_Sect-Curr = "MAIN BLOCK" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_MAIN-BLOCK".
  ELSE IF p_Sect-Curr BEGINS "PROCEDURE" THEN
       ASSIGN p_section = "_PROCEDURE"
              p_recid   = win_recid
              p_event   = ENTRY( 2 , p_Sect-Curr , " " ).
  ELSE IF p_Sect-Curr BEGINS "FUNCTION" THEN
       ASSIGN p_section = "_FUNCTION"
              p_recid   = win_recid
              p_event   = ENTRY( 2 , p_Sect-Curr , " " ).
  ELSE IF (p_Sect-Curr <> ?) AND (p_Sect-Curr <> "") THEN
  DO:
    /* ON event OF widget */
    
    /* Get the name and check to see if its a dbfield (db.table.name). */
    ASSIGN object_name = TRIM(ENTRY( 4, p_Sect-Curr, " ")).
    
    /* special case- frame contains multiple db fields */
    if INDEX( object_name , "." ) NE 0 and num-entries(p_Sect-Curr," ") GT 5 and ENTRY(6, p_Sect-Curr, " ") = "FRAME":U THEN DO:
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = h_trg_win
              AND x_U._STATUS <> "DELETED"
                  AND x_U._NAME          = ENTRY(3,object_name,".")
                  AND x_U._DBNAME        = ENTRY(1,object_name,".")
                  AND x_U._TABLE         = ENTRY(2,object_name,".") :
	  FIND p_U WHERE p_U._DBNAME <> ? and RECID(p_U) = x_U._PARENT-RECID NO-ERROR.
          IF AVAILABLE p_U and p_U._NAME EQ ENTRY(7, p_Sect-Curr, " ") THEN DO:
   	      ASSIGN p_section = "_CONTROL"
                     p_recid   = RECID (x_U)
                     p_event   = ENTRY (2, p_Sect-Curr," ")
		     p_ok = true.
		     leave.
          end.
      end.
    end.
    else IF INDEX( object_name , "." ) = 0 THEN
        FIND x_U WHERE x_U._WINDOW-HANDLE = h_trg_win
                   AND x_U._NAME          = object_name
                   AND x_U._STATUS        <> "DELETED" NO-ERROR.
    ELSE
        FIND x_U WHERE x_U._WINDOW-HANDLE = h_trg_win
                   AND x_U._NAME          = ENTRY(3,object_name,".")
                   AND x_U._DBNAME        = ENTRY(1,object_name,".")
                   AND x_U._TABLE         = ENTRY(2,object_name,".")
                   AND x_U._STATUS        <> "DELETED" NO-ERROR.
                      
    IF NOT AVAILABLE x_U AND ENTRY(6, p_Sect-Curr, " ") = "BROWSE":U THEN
    DO:
      /* Handle the browse-column case */
      FIND x_U WHERE x_U._WINDOW-HANDLE = h_trg_win AND
                     x_U._NAME          = TRIM(ENTRY(7, p_Sect-Curr, " ")) AND
                     x_U._STATUS        <> "DELETED" NO-ERROR.
      IF AVAILABLE x_U THEN
        FIND x_BC WHERE x_BC._x-recid = RECID(x_U)
                    AND x_BC._DISP-NAME = TRIM(ENTRY(4, p_Sect-Curr, " ")) NO-ERROR.
    END.

    IF NOT AVAILABLE x_U AND NOT AVAILABLE x_BC THEN p_ok = FALSE.
    ELSE IF AVAILABLE x_BC AND ENTRY(6, p_Sect-Curr, " ") = "BROWSE":U THEN
      ASSIGN p_section = "_CONTROL"
             p_recid   = RECID (x_BC)
             p_event   = ENTRY (2, p_Sect-Curr," ").
    ELSE
      ASSIGN p_section = "_CONTROL"
             p_recid   = RECID (x_U)
             p_event   = ENTRY (2, p_Sect-Curr," ").
  END.
  ELSE /* p_Sect-Curr = ? or = "" */
  DO:
    /* We've reached the starting search section (an "empty" or unchanged
       default trigger section) so searching is done. */
    ASSIGN p_ok = FALSE.
  END.
END.

END PROCEDURE.


PROCEDURE GetSearchAllList.
/*-----------------------------------------------------------------------------

  Procedure: GetSearchAllList

  Description: 
      Returns comma-delimited list of custom/user created code sections and
      the current section the user is editing. Used by Search All Sections.

      Must be kept in sync with:
          adeuib/_seltrg.p
          adeuib/_seprocs.i PROCEDURE GetNextSearchSection.

  Input Parameters:
      h_trg_win   -  The handle of the window to list triggers for.
      p_section - the current section at input; the desired section at
                  output (eg. _CUSTOM, _CONTROL, _PROCEDURE, _FUNCTION)
      p_recid   - the current (and desired) recid
      p_event   - the current (and desired) name of pseudo-event or event.
                  eg.  CHOOSE or _DEFINITIONS.
  
  Output Parameters:
      p_Sect-List - Comma-delimited list of section names.
      p_Sect-Curr - Current Section.
      
  Author    : J. Palazzo
  Created   : 14 Nov 1996
  Modified  : 
-----------------------------------------------------------------------------*/

/* Define Parameters. */
DEFINE INPUT        PARAMETER  h_trg_win    AS WIDGET   NO-UNDO.
DEFINE INPUT        PARAMETER  p_section    AS CHAR     NO-UNDO.
DEFINE INPUT        PARAMETER  p_recid      AS RECID    NO-UNDO.
DEFINE INPUT        PARAMETER  p_event      AS CHAR     NO-UNDO.
DEFINE OUTPUT       PARAMETER  p_Sect-List  AS CHAR     NO-UNDO.
DEFINE OUTPUT       PARAMETER  p_Sect-Curr  AS CHAR     NO-UNDO.

/* Local Variable Definitions. */
DEF  VAR win_recid    AS RECID                                   NO-UNDO.
         /* RECID of window for the triggers and code                 */
DEF  VAR l_dummy      AS LOGICAL                                 NO-UNDO.
         /* dummy logical to accept result of methods                 */
DEF  VAR item         AS CHAR                                    NO-UNDO.
         /* store 1 item of sel-list                                  */
DEF  VAR object_name  AS CHAR                                    NO-UNDO.
DEF  VAR rule_char    AS CHAR    INIT "-":u                      NO-UNDO.
DEFINE BUFFER p_U FOR _U.
DEF  VAR s  AS CHAR                                              NO-UNDO.

/* Get the window record */
FIND _U WHERE _U._HANDLE = h_trg_win NO-ERROR.
IF NOT AVAILABLE _U THEN RETURN.  /* this should never happen. */
ASSIGN win_recid = RECID(_U).

/* Go through all widgets and initialize the list, starting with DEFINITIONS. */
ASSIGN p_Sect-List = "DEFINITIONS":U.
IF (p_section = "_CUSTOM" AND p_event = "_DEFINITIONS") THEN
  ASSIGN p_Sect-Curr = p_Sect-List.

/* Controls */
FOR EACH _U WHERE _U._WINDOW-HANDLE = h_trg_win
              AND _U._STATUS <> "DELETED":
  FIND p_U WHERE RECID(p_U) = _U._PARENT-RECID NO-ERROR.
  IF AVAILABLE p_U and p_U._DBNAME <> ? THEN 
        s = " IN" + " FRAME":U + " " + p_u._name .
     else
        s = "".

  FOR EACH _TRG WHERE _TRG._wRECID = RECID (_U)
                  AND _TRG._STATUS <> "DELETED"
                  AND _TRG._tSECTION = "_CONTROL":

    /* Check if dbfield and if so, change to db.table.name. */
    IF _U._DBNAME = ? THEN
        ASSIGN object_name = _U._NAME.
    ELSE
        ASSIGN object_name = _U._DBNAME + "." + _U._TABLE + "." + _U._NAME.
    
    ASSIGN item        = ("TRIGGER " + _TRG._tEVENT + " OF " + object_name + s)
           p_Sect-List = p_Sect-List + "," + item.
           
    IF p_section = "_CONTROL" AND p_recid = RECID(_U)  AND p_event = _TRG._tEVENT THEN
      ASSIGN p_Sect-Curr = item.
  END.
  IF _U._TYPE = "BROWSE":U THEN DO:
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U),
        EACH _TRG WHERE _TRG._wRECID = RECID (_BC)
                    AND _TRG._STATUS <> "DELETED"
                    AND _TRG._tSECTION = "_CONTROL":

      ASSIGN item      = ("TRIGGER " + _TRG._tEVENT + " OF " + _BC._DISP-NAME + 
                          " IN BROWSE " + _U._NAME)
           p_Sect-List = p_Sect-List + "," + item.
           
      IF (p_Sect-Curr = "") AND (p_section = "_CONTROL") AND (p_recid = RECID(_BC))
         AND (p_event = _TRG._tEVENT) THEN ASSIGN p_Sect-Curr = item.
    END.
  END.
END.


/* Main Block */
ASSIGN p_Sect-List = p_Sect-List + "," + "MAIN BLOCK":U.
ASSIGN p_Sect-Curr = IF (p_section = "_CUSTOM" AND p_event = "_MAIN-BLOCK")
                     THEN "MAIN BLOCK":U ELSE p_Sect-Curr.
    
/* Procedures */
FOR EACH _TRG WHERE _TRG._wRECID = win_recid
                AND _TRG._STATUS <> "DELETED"
                AND _TRG._tSECTION = "_PROCEDURE":
    /* Do not include read-only sections. */
    IF (_TRG._tSPECIAL <> ?) AND (_TRG._tCODE = ?) THEN NEXT.

    ASSIGN item        = "PROCEDURE " + _TRG._tEVENT.
           p_Sect-List = p_Sect-List + "," + item.
           
    IF (p_section = "_PROCEDURE") AND (p_recid = win_recid) AND (p_event = _TRG._tEVENT) THEN
      ASSIGN p_Sect-Curr = item.
END.

/* Functions */
FOR EACH _TRG WHERE _TRG._wRECID = win_recid
                AND _TRG._STATUS <> "DELETED"
                AND _TRG._tSECTION = "_FUNCTION":
    /* Do not include read-only sections. */
    IF (_TRG._tSPECIAL <> ?) AND (_TRG._tCODE = ?) THEN NEXT.

    ASSIGN item        = "FUNCTION " + _TRG._tEVENT.
           p_Sect-List = p_Sect-List + "," + item.
           
    IF (p_section = "_FUNCTION") AND (p_recid = win_recid) AND (p_event = _TRG._tEVENT) THEN
      ASSIGN p_Sect-Curr = item.
END.

/* If we don't have a "current section", the user probably invoked the
   Search All Sections option while in the Triggers section with an unchanged
   default trigger section. Such sections (also referred to as Empty Triggers)
   in the Section Editor aren't actually created until the block is changed.
   Thats why code in this procedure doesn't find an _TRG record for the current 
   block, leaving p_Sect-Curr as null and not adding its section to the search 
   list. To resolve this, we add a null section to the end of the search section 
   list. Calling code then behaves correctly, along with some other minor 
   changes to NextSearchBlock and GetNextSearchSection.
   Fixes 20000627-013. - jep. */
IF p_Sect-Curr = "" THEN
  ASSIGN p_Sect-List = p_Sect-List + "," + p_Sect-Curr.
ELSE   /* Trim any trailing empty entries - which we don't do to the prior condition. */
  ASSIGN p_Sect-List = TRIM(p_Sect-List, ",").

RETURN.

END PROCEDURE.


PROCEDURE change_trg.
  /* -------------------------------------------------------------------------
    Purpose:        Change from the current values of SECTION/_U/EVENT to
                    new ones.
    Run Syntax:     RUN change_trg  ("_CONTROL", RECID(_SEW_U), "SELECTION" ).
    Parameters:     INPUT  new_section - like se_section
		    INPUT  new_recid   - like se_recid
		    INPUT  new_event   - like se_event
		    INPUT  use_new_event - IF TRUE then always use the
		             new-event, even it is not one usually used
		             for this widget. IF FALSE, then only use the
		             new_event if it is one on the regular event list.
		    INPUT  store_code - IF FALSE then don't bother storing code
		    OUTPUT change_ok   - TRUE if the code was changed.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER new_section     AS CHAR     NO-UNDO.
  DEFINE INPUT  PARAMETER new_recid       AS RECID    NO-UNDO.
  DEFINE INPUT  PARAMETER new_event       AS CHAR     NO-UNDO.
  DEFINE INPUT  PARAMETER use_new_event   AS LOGICAL  NO-UNDO.
  DEFINE INPUT  PARAMETER store_code      AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER change_ok       AS LOGICAL NO-UNDO.

  DEF BUTTON btn_sv   LABEL "Store Changes":C14 SIZE 16 BY 1.
  DEF BUTTON btn_cl   LABEL "Cancel Changes":C14 SIZE 16 BY 1.
  
  DEF VAR l_ok        AS LOGICAL NO-UNDO.
  DEF VAR Has_Trigger AS LOGICAL NO-UNDO.
  DEF VAR i           AS INTEGER NO-UNDO.

  DO WITH FRAME f_edit:
    IF store_code THEN DO:
      RUN store_trg (FALSE, OUTPUT change_ok).
      /* Don't change the trigger if there was a problem with the code */
      IF NOT change_ok THEN RETURN.
    END.
    ELSE change_ok = YES. /* If we don't store the code, we always change */
    /* Find the new Trigger (or just initialize the text editor).  If this
       is a control, then make sure that new_event is a member of the 
       valid events. */
    IF new_recid = ? THEN new_recid = win_recid.
    /* Fix to 98-05-20-065 jep
       If can't find an _U or an _BC for new_recid, then we've
       probably switched windows or even reopend the same one.
       In that case, get the window as the widget. */
    FIND _SEW_U  WHERE RECID(_SEW_U) = new_recid NO-ERROR.
    IF NOT AVAILABLE _SEW_U THEN
    DO:
        FIND _SEW_BC WHERE RECID(_SEW_BC) = new_recid NO-ERROR.
        IF NOT AVAILABLE _SEW_BC THEN
        DO:
            new_recid = win_recid.
            FIND _SEW_U  WHERE RECID(_SEW_U) = new_recid NO-ERROR.
            IF NOT AVAILABLE _SEW_U THEN RETURN.
        END.
    END.

    IF AVAILABLE _SEW_U THEN DO:
      _SEW-recid = RECID(_SEW_U).
      /* Check status = deleted to see if the last widget the section editor
         was on is now gone, we must switch to the current widget.  No
         need to check or update section here, as status = DELETED
         should only occur when choosing to move to the Triggers section. 
         Fixes bug 94-07-14-031.
      */
      IF _SEW_U._STATUS = "DELETED" THEN
      DO:
        FIND _SEW_U WHERE _SEW_U._HANDLE = _h_cur_widg.
        
        ASSIGN new_recid  = RECID(_SEW_U)
               _SEW-recid = new_recid.
      END.
      
      /* When switching focus between tree-view objects, you would get an 
         error message if you selected Triggers because the combo-box wname 
         was being DISPLAYED with the _SEW_U from the previous window. 
         Finding the _SEW_U for the current window forces the same behavior 
         as if we enter the Window for the first time.
         Fixes bug 98-04-15-010  HD 
       */  
      IF _SEW_U._WINDOW-HANDLE <> _h_win THEN           
         FIND _SEW_U WHERE RECID(_SEW_U) = win_recid NO-ERROR.    
      
      IF CAN-DO(Type_Trigger + "," + Type_Procedure + "," + Type_Function, new_section) THEN
      DO:
        IF new_section = Type_Trigger THEN
        DO:
          IF _SEW_U._SUBTYPE = "DESIGN-WINDOW":U THEN
          DO: /* Fixes bug 95-07-26-007. */
            /* If the object is a design-only window, make the Triggers
               section point to the first object that can have a trigger.
               If there are none, tell the user and do not go to the
               Triggers section. */
            RUN build_widget_list ( "" ).
            /* add a check for wname:list-items = ? because h_first_obj may
             * still be valid but not have any triggers for it anymore --
             * we may have just deleted it. For example, when we delete
             * open_query trigger for sdo, the list-items is blank but
             * h_first_obj is still valid because query_main still exists.
             */
            IF NOT VALID-HANDLE(h_first_obj) OR wname:LIST-ITEMS = ? THEN
            DO:
                ASSIGN change_ok = NO.
                MESSAGE
        "There are no objects in" _SEW_U._LABEL "that can have triggers."
                    VIEW-AS ALERT-BOX INFORMATION IN WINDOW h_sewin.
                RETURN.
            END.
            ELSE DO:
                FIND _SEW_U WHERE _SEW_U._HANDLE = h_first_obj.
                ASSIGN new_recid  = RECID(_SEW_U)
                       _SEW-recid = new_recid.
            END.
          END.
          RUN build_event_list.
        END.
        ELSE IF new_section = Type_Procedure THEN
          RUN build_proc_list (INPUT se_event:HANDLE in FRAME f_edit).
        ELSE IF new_section = Type_Function THEN
          RUN build_func_list (INPUT se_event:HANDLE in FRAME f_edit).

        /* What if our new event is not in the valid list.  Then either use
           the default event or add the new event to the list. */
        i = se_event:LOOKUP(new_event) .
        IF i eq ? OR i = 0 THEN DO:
          IF use_new_event THEN l_ok = se_event:ADD-FIRST(new_event).
          ELSE IF (new_section = Type_Trigger) THEN DO:
            RUN get_default_event (INPUT _SEW_U._TYPE, OUTPUT new_event).
            IF (_SEW_U._TYPE <> "BROWSE":U) THEN DO:
              /* Display the default event trigger if there is one. Otherwise,
                 display the first trigger event in the list. */
              RUN Has_Trigger (INPUT _SEW-recid, INPUT new_event,
                               OUTPUT Has_Trigger).
              IF Has_Trigger = FALSE THEN
                ASSIGN new_event = se_event:ENTRY(1).
            END.
            ELSE IF (se_event:LOOKUP("OPEN_QUERY":U) <> 0) THEN
              /* Override typical BROWSE default event with Freeform event. */
              ASSIGN new_event = "OPEN_QUERY":U.
          END.
          ELSE ASSIGN new_event = se_event:ENTRY(1).
        END.
      ASSIGN se_event:SCREEN-VALUE = new_event.
      END.
    END.  /* IF available _SEW_U */
    
    ELSE DO:   /* DO the above with a _BC RECORD */
      FIND _SEW_BC WHERE RECID(_SEW_BC) = new_recid.
      _SEW-recid = RECID(_SEW_BC).
      IF CAN-DO(Type_Trigger + "," + Type_Procedure + "," + Type_Function, new_section) THEN
      DO:
        IF new_section = Type_Trigger
          THEN RUN build_event_list.
        ELSE IF new_section = Type_Procedure THEN
          RUN build_proc_list (INPUT se_event:HANDLE in FRAME f_edit).
        ELSE IF new_section = Type_Function  THEN
          RUN build_func_list (INPUT se_event:HANDLE in FRAME f_edit).

        /* What if our new event is not in the valid list.  Then either use
           the default event or add the new event to the list. */
        i = se_event:LOOKUP(new_event) .
        IF i eq ? OR i = 0 THEN DO:
          IF use_new_event THEN l_ok = se_event:ADD-FIRST(new_event).
          ELSE IF (new_section = Type_Trigger) THEN DO: /* Use default event */
            /* Display the default event trigger if there is one. Otherwise,
               display the first trigger event in the list. */
            RUN get_default_event (INPUT "BROWSE-COLUMN":U, OUTPUT new_event).
            RUN Has_Trigger (INPUT _SEW-recid, INPUT new_event,
                             OUTPUT Has_Trigger).
            IF Has_Trigger = FALSE THEN
              ASSIGN new_event = se_event:ENTRY(1).
          END.
          ELSE ASSIGN new_event = se_event:ENTRY(1).
        END.
      ASSIGN se_event:SCREEN-VALUE = new_event.
      END.
    END.  /* _SEW_BC CASE */
    /* Now get the trigger for this event */
    ASSIGN se_section  = new_section
           se_event    = new_event
           se_recid    = _SEW-recid
    . /* ASSIGN */
    RUN display_trg.     
   
  END. /* DO WITH FRAME f_edit... */
END PROCEDURE.

PROCEDURE CheckSyntax.
  /*-------------------------------------------------------------------------
    Purpose:        Section Editor Check Syntax (Compile->Check Syntax).
    Run Syntax:     RUN CheckSyntax.
    Parameters:     None
  ---------------------------------------------------------------------------*/
  
    DEFINE VAR code_ok 	   AS LOGICAL   NO-UNDO.
    DEFINE VAR cPrevStatus AS CHARACTER NO-UNDO.

    ASSIGN cPrevStatus = _p_status.
           _p_status   = "CHECK-SYNTAX":U.
    RUN check_store_trg (TRUE, FALSE, OUTPUT code_ok).
    ASSIGN _p_status = cPrevStatus.
    IF code_ok
    THEN MESSAGE "Syntax is correct."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK
                    IN WINDOW h_sewin.
    APPLY "ENTRY" TO txt IN FRAME f_edit.
    
END PROCEDURE.


PROCEDURE UndoChange.
  /*-------------------------------------------------------------------------
    Purpose:        Section Editor Edit->Undo Change
    Run Syntax:     RUN UndoChange.
    Parameters:     None
  ---------------------------------------------------------------------------*/
  DEF VAR ans AS LOGICAL NO-UNDO.

  DO WITH FRAME f_edit:
    IF txt:MODIFIED OR
       (editted_event <> se_event AND
        CAN-DO(Type_Trigger + "," + Type_Procedure + "," + Type_Function, se_section))
    THEN DO:
      MESSAGE "Do you want to undo all changes to this code block?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
                 UPDATE ans IN WINDOW h_sewin.
      IF ans THEN RUN display_trg.
    END.
    ELSE MESSAGE "No changes to undo."
                 VIEW-AS ALERT-BOX INFORMATION
                         IN WINDOW h_sewin.
  END.
  APPLY "ENTRY" TO txt IN FRAME f_edit.
  
END PROCEDURE.

PROCEDURE DeleteBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Section Editor Edit->Delete Block
    Run Syntax:     RUN DeleteBlock.
    Parameters:     None
  ---------------------------------------------------------------------------*/
  
  DEF VAR ans           AS LOGICAL                       NO-UNDO.
  DEF VAR whichQuestion AS CHARACTER INITIAL "_NORMAL":U NO-UNDO.
  DEF VAR window-handle AS WIDGET-HANDLE                 NO-UNDO.
  DEF VAR Changed_Sect  AS LOGICAL                       NO-UNDO.
  DEF VAR okdummy       AS LOGICAL                       NO-UNDO.
  DEF VAR win_name      AS CHARACTER                     NO-UNDO.

  DEF BUFFER x_U FOR _U.
  
  DO WITH FRAME f_edit:
    IF AVAILABLE _SEW_U THEN DO:
      IF _SEW_U._TYPE eq "{&WT-CONTROL}" THEN DO:
        IF NUM-ENTRIES(_SEW._pevent, ".") > 1 THEN DO:
          /*
           * If the VBX is "halfway there" then warn the
           * user that NEW VBX event procedures aren't
           * available. This can happen when an existing
           * .w file was created with a VBX that the 
           * current user doesn't have a license for.
           */
          FIND _SEW_F WHERE RECID(_SEW_F) = _SEW_U._x-recid.
          IF _SEW_F._SPECIAL-DATA <> ? THEN whichQuestion = "_VBX":U.
        END.
      END.
      ELSE IF AVAILABLE _SEW_TRG AND
              CAN-DO("_OPEN-QUERY,_DISPLAY-FIELDS":U, _SEW_TRG._tSPECIAL)
      THEN ASSIGN whichQuestion = "_FREEFORM-QUERY":U.
    END. /* IF AVAILABLE _SEW_U */

    CASE whichQuestion :
      WHEN "_NORMAL":U THEN
        MESSAGE "Do you want to delete this code block?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                        UPDATE ans IN WINDOW h_sewin.
      WHEN "_VBX":U THEN
        MESSAGE
          "The {&WT-CONTROL}," _SEW_F._IMAGE-FILE ", is missing or unavailable"
          skip
          "for" _SEW_U._NAME ". This code block cannot be recovered in this"
          skip
          "session if it is deleted. Do you want to delete this code block?" 
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  UPDATE ans IN WINDOW h_sewin.    
      WHEN "_FREEFORM-QUERY":U THEN
        MESSAGE
          "Deleting" _SEW_TRG._tEVENT "also deletes all Freeform query code"
          SKIP
          "for" _SEW_U._NAME + "."
          SKIP
          "Do you want to delete this code block?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  UPDATE ans IN WINDOW h_sewin.
    END CASE.
        
    IF ans THEN DO:
      IF AVAILABLE _SEW_TRG THEN DO:
        /* If we have stored code, "delete" it, otherwise just display the
           current default (which will appear to erase the old copy )*/
        CASE se_section:
          WHEN "_CUSTOM":U THEN ASSIGN txt = "".
          
          WHEN Type_Procedure OR WHEN Type_Trigger OR WHEN Type_Function THEN DO:
            ASSIGN se_recid = _SEW_TRG._wRECID.

            /* If treeview, update it. */
            IF (NOT AVAILABLE _P) THEN
              FIND _P WHERE _P._u-recid = win_recid.
            IF VALID-HANDLE(_P._tv-proc) THEN
            DO:
              RUN deleteCodeNode IN _P._tv-proc
                    (INPUT se_section,
                     INPUT _SEW-recid,
                     INPUT se_event).
            END.

            DELETE _SEW_TRG.

            /* If deleting a Freeform query, remove the other Freeform query
               trigger event, if its there. */
            IF whichQuestion = "_FREEFORM-QUERY":U THEN
            DO:
                FIND FIRST _SEW_TRG WHERE _SEW_TRG._wRECID = se_recid
                                    AND  CAN-DO("_OPEN-QUERY,_DISPLAY-FIELDS":U,
                                                 _SEW_TRG._tSPECIAL)
                                    NO-ERROR.
                IF AVAILABLE _SEW_TRG THEN DELETE _SEW_TRG.
                RUN freeform_update (INPUT RECID(_SEW_U)).
            END.
            
            /* Go to the next trigger */
            FIND NEXT _SEW_TRG WHERE _SEW_TRG._wRECID = se_recid
                               AND   _SEW_TRG._tSECTION = se_section NO-ERROR.
            IF NOT AVAILABLE _SEW_TRG 
            THEN FIND PREV _SEW_TRG WHERE _SEW_TRG._wRECID = se_recid AND
                           _SEW_TRG._tSECTION = se_section NO-ERROR.
            IF AVAILABLE _SEW_TRG THEN se_event = _SEW_TRG._tEVENT.
            ELSE DO:
              IF (se_section = Type_Procedure) OR (se_section = Type_Function) OR
                 /* freeform query deleted */
                 (AVAILABLE _SEW_U AND _SEW_U._TYPE = "QUERY":U) THEN
              DO:

                /* If deleting Freeform Query, we must make the recent
                   object point to the query's window. */
                IF _SEW_U._TYPE = "QUERY":U THEN
                DO:
                   ASSIGN okdummy = wname:DELETE(wname:SCREEN-VALUE).
                   ASSIGN window-handle = _SEW_U._WINDOW-HANDLE.
                   FIND _SEW_U WHERE _SEW_U._HANDLE = window-handle.
                   ASSIGN recent_recid = RECID(_SEW_U)
                          _SEW-recid   = recent_recid.
                   RUN get_default_event
                     (INPUT _SEW_U._TYPE , OUTPUT recent_trig).
                   RUN GetWidgetListName ( INPUT _SEW_U._NAME ,
                                           INPUT _SEW_U._LABEL ,
                                           OUTPUT win_name ).

                   /* set the combo-box to the query object name but not
                    * if it doesn't exist in the list of items because then you 
                    * will get an error. 
                    * If it doesn't exist in the list, then set it to main 
                    * block. (It might not exist in the list anymore because we
                    * might have deleted it from the list because we deleted the
                    * last trigger on it. example: delete open_query trigger from
                    * freeform sdo.) 
                    */
                   IF INDEX(wname:LIST-ITEMS,win_name) > 0 THEN DO:
                       ASSIGN wname:SCREEN-VALUE = win_name.
                       APPLY "VALUE-CHANGED" TO wname.
                   END.
                   ELSE RUN ChangeSection ( INPUT Main_Block ).
                   ASSIGN Changed_Sect = TRUE.

                END.
                ELSE DO:
                   /* Display the main block */
                   RUN ChangeSection ( INPUT Main_Block ).
                   ASSIGN Changed_Sect = TRUE.
                END.

              END.
              ELSE DO:
                   RUN get_default_event (IF AVAILABLE _SEW_U
                                          THEN _SEW_U._TYPE
                                          ELSE "BROWSE-COLUMN":U,
                                          OUTPUT se_event).
              END.
            END.
            CASE se_section:
              WHEN Type_Procedure THEN
                RUN build_proc_list (INPUT se_event:HANDLE in FRAME f_edit).
              WHEN Type_Function  THEN
                RUN build_func_list (INPUT se_event:HANDLE in FRAME f_edit).
              OTHERWISE
                RUN build_event_list.
            END CASE.
          END.
        END CASE.
        /* set the window-saved state to false, just deleted a trigger */
        IF AVAILABLE _SEW_U THEN window-handle = _SEW_U._WINDOW-HANDLE.
        ELSE DO:
          FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
          window-handle = x_U._WINDOW-HANDLE.
        END.
        RUN adeuib/_winsave.p(window-handle, FALSE).
      END.
      /* Don't redisplay for custom. Allows Undo to rebuild deleted
         custom sections (currently, Main and Definitions). */
      IF se_section <> "_CUSTOM" OR (Changed_Sect = TRUE) THEN
        RUN display_trg.
      ELSE DO:
        DISPLAY txt WITH FRAME f_edit.
        APPLY "ENTRY":U TO txt.
        RUN CodeModified (INPUT TRUE).
      END.
      
    END. 
  END. /* DO WITH FRAME f_edit:... */

END PROCEDURE.

PROCEDURE NewBlock.
  /*-------------------------------------------------------------------------
    Purpose:        Section Editor Edit->New Block
    Run Syntax:     RUN NewBlock.
    Parameters:     None
  ---------------------------------------------------------------------------*/
  
  DEFINE VARIABLE a_ok              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE event_list        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_cwin            AS WIDGET    NO-UNDO.
  DEFINE VARIABLE Invalid_List      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_command       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE new_event         AS CHARACTER NO-UNDO.
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
  
  DEFINE BUFFER b_U FOR _U.

  IF (NOT AVAILABLE _P) THEN
    FIND _P WHERE _P._u-recid = win_recid.

  IF se_section = Type_Trigger THEN DO: /* Ask for a new event */
    ASSIGN new_event = editted_event
           new_recid = (IF AVAILABLE(_SEW_U) THEN RECID(_SEW_U) ELSE _SEW-RECID)
           new_spcl  = ?.
    
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = h_sewin
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
        ASSIGN event_list = TRIM(event_list + ",":u + _P._events, ",").
      RUN adeuib/_selevnt.p
        (INPUT TYPE,
         INPUT (IF TYPE NE "BROWSE-COLUMN":U THEN _SEW_U._SUBTYPE ELSE ""),
         INPUT event_list,
         INPUT _cur_win_type,
         INPUT RECID(_P),
         INPUT-OUTPUT new_event).
    END.
    ASSIGN CURRENT-WINDOW = h_cwin.
  END.
  ELSE DO:
  
    /* Ask for a new procedure name. */
    ASSIGN new_event = ""
           new_name  = ""
           new_recid = win_recid
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
          RUN get-super-procedures IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
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
          RUN get-super-procedures IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
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
  END.
  
  /* Create new triggers if new_event is not-blank. */
  IF (new_event <> "") AND (new_event <> se_event) THEN DO: 
    CASE se_section:
      /* Is there already an event/procedure/function with this name? */
      WHEN Type_Trigger THEN
          ASSIGN Create_Block = (se_event:LOOKUP(new_event) IN FRAME f_edit = 0).
      WHEN Type_Procedure OR WHEN Type_Function THEN
      DO:
          /* The OR handles bug 95-07-31-052. */
          ASSIGN Create_Block = (GetProcFuncSection(new_event) = "")
                                OR (NOT se_event:VISIBLE IN FRAME f_edit).
      END.
    END CASE.
    
    IF NOT Create_Block THEN
    DO:
        ASSIGN a_ok = YES.
        IF se_section = Type_Trigger THEN
          MESSAGE CAPS(new_event)     SKIP(1)
                  TRIM(wname) "already has a trigger for this event." SKIP
                  "Do you want to edit the existing code?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE a_ok
                      IN WINDOW h_sewin.
        ELSE IF GetProcFuncSection(new_event) = Type_Procedure THEN   /* Procedure */
        DO:
          MESSAGE new_event     SKIP(1)
                  "There is already a procedure with this name."    SKIP
                  "Do you want to edit the existing code?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE a_ok
                      IN WINDOW h_sewin.
          /* Section must update if changing from Proc to Func section or vice-versa. */
          IF a_ok AND se_section <> Type_Procedure THEN
          DO:
            RUN ChangeSection (INPUT Procedures).
            ASSIGN se_section = Type_Procedure.
          END.
        END.
        ELSE IF GetProcFuncSection(new_event) = Type_Function  THEN   /* Function */
        DO:
          MESSAGE new_event     SKIP(1)
                  "There is already a function with this name."    SKIP
                  "Do you want to edit the existing code?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE a_ok
                      IN WINDOW h_sewin.
          /* Section must update if changing from Proc to Func section or vice-versa. */
          IF a_ok AND se_section <> Type_Function THEN
          DO:
            RUN ChangeSection (INPUT Functions).
            ASSIGN se_section = Type_Function.
          END.
        END.
        
        /* At this point, we do not want to overrwite the code block
           the user wants to view.  So we assign new_spcl to the
           event name to prevent this from happening.  Fixes
           bug 94-06-24-042.
        */
        IF a_ok AND new_spcl = ? THEN ASSIGN new_spcl = CAPS(new_event).
    END.
    ELSE DO:
      CREATE _SEW_TRG.
      ASSIGN _SEW_TRG._tSECTION = se_section
             _SEW_TRG._tSPECIAL = new_spcl
             _SEW_TRG._pRECID   = RECID(_P)
             _SEW_TRG._wRECID   = new_recid
             _SEW_TRG._tEVENT   = new_event
             _SEW_TRG._tCODE    = ?
             _SEW_TRG._DB-REQUIRED = NO WHEN (proc_type = Type_Adm_Create_Obj) /* jep: IZ 1429 */
             a_ok               = yes.
    END.
    /* If we created a new one, or if it is ok to go to the old one, then go */
    IF a_ok THEN DO:
      /* Fill the new trigger unless 1) it is special or 2) we are
         viewing an existing code block. */
      IF new_spcl = ? THEN
      DO:
        IF Type = Type_Local AND VALID-HANDLE( _h_mlmgr ) AND Code_Block = "" THEN 
          RUN get-local-template IN _h_mlmgr ( INPUT  new_name ,
                                               OUTPUT _SEW_TRG._tCODE ).
        ELSE
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
            OTHERWISE /* Type_Trigger */
              DO:
                /* For all special events (e.g., OCX.event), store it in _tSPECIAL. */
              	IF NUM-ENTRIES(new_event, ".":u) > 1 THEN
              	DO:
                    ASSIGN _SEW_TRG._tSPECIAL = new_event
                           _SEW_TRG._tTYPE    = "_CONTROL-PROCEDURE" NO-ERROR.
                END.
                    
                IF AVAILABLE _SEW_U AND _SEW_U._TYPE eq "{&WT-CONTROL}" THEN
                  RUN adeshar/_ocxdflt.p
                            (new_event, se_section, new_recid, OUTPUT _SEW_TRG._tCODE). 
                ELSE DO:
                  ASSIGN code_type = se_section. /* Default code type. */
                  IF (new_event = "DEFINE_QUERY") THEN
                    ASSIGN code_type = "_DEFINE-QUERY":U.
                  ELSE IF (_SEW_TRG._tTYPE <> "") THEN
                    ASSIGN code_type = new_event.
                  RUN adeshar/_coddflt.p (code_type, new_recid, OUTPUT _SEW_TRG._tCODE).
                END.
              END.
          END CASE.
          RUN adecomm/_adeevnt.p ("UIB":U, "New":U, INTEGER(RECID(_SEW_TRG)),
                                        se_section, OUTPUT lOK).
        END.
      END.

      /* Change to the new event... */
      RUN change_trg (se_section, new_recid, new_event, yes, yes, OUTPUT a_ok).

      /* If this is a new block, mark the window as changed and update
         its treeview if it has one. */
      IF Create_Block THEN
      DO:
        RUN adeuib/_winsave.p (_SEW._hwin, FALSE).

        /* If treeview, update it. */
        IF (NOT AVAILABLE _P) THEN
          FIND _P WHERE _P._u-recid = win_recid.
        IF VALID-HANDLE(_P._tv-proc) THEN
        DO:
          RUN addCodeNode IN _P._tv-proc
                (INPUT se_section, INPUT _SEW-recid, INPUT se_event).
        END.
      END. /* Create_Block */
    END.
  END.

END PROCEDURE.


PROCEDURE RenameProc.
  /*-------------------------------------------------------------------------
    Purpose:        Section Editor Rename Procedure dialog box execution.
    Run Syntax:     RUN RenameProc.
    Parameters:     None
  ---------------------------------------------------------------------------*/
  
  DEFINE VAR new_pname   AS CHAR    NO-UNDO CASE-SENSITIVE.
  DEFINE VAR new_spcl    AS CHAR    NO-UNDO.
  DEFINE VARIABLE a_ok   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE h_cwin AS WIDGET  NO-UNDO.
  
  DEFINE BUFFER b_U FOR _U.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /* Ask for a new procedure name - using the f_rename frame. */
    ASSIGN new_pname = ""
           new_name  = se_event:SCREEN-VALUE IN FRAME f_edit.
    UPDATE new_name btn_ok btn_cancel btn_help 
           WITH FRAME f_rename DEFAULT-BUTTON btn_ok
                      IN WINDOW h_sewin.

    ASSIGN new_pname   = new_name.

    /* We have a trigger ON GO which checks for renaming to a Procedure
       that already exists.  So at this point, we simply replace the old
       procedure name with the new one. */
    /* new_pname <> "" - a valid procedure name was entered. NOTE we need
       to check for a new CASE on the name. */
    IF (new_pname <> "") AND (new_pname <> se_event) THEN
    DO: 
      IF (NOT AVAILABLE _P) THEN
          FIND _P WHERE _P._u-recid = win_recid.
      IF NOT AVAILABLE _SEW_TRG THEN
        FIND _SEW_TRG WHERE _SEW_TRG._wRECID = win_recid AND
                            _SEW_TRG._tEVENT = se_event NO-ERROR.

      IF VALID-HANDLE(_P._tv-proc) THEN
        RUN renameCode IN _P._tv-proc
            (INPUT se_event /* old */,
             INPUT new_pname,
             INPUT (IF isection = Procedures THEN "Procedure":U ELSE "Function":U) )
             NO-ERROR.

      ASSIGN a_ok             = se_event:REPLACE( new_pname , se_event )
             se_event          = new_pname
             editted_event    = new_pname
             _SEW_TRG._tEVENT = new_pname
             _SEW._pevent     = new_pname
             se_event:SCREEN-VALUE IN FRAME f_edit = new_pname
      . /* ASSIGN */
      /* Set the window-saved state to false, since we just changed a
         procedure name. */
      IF AVAILABLE _SEW_U THEN h_cwin = _SEW_U._WINDOW-HANDLE.
      ELSE DO:
        FIND b_U WHERE RECID(b_U) = _SEW_BC._x-recid.
        h_cwin = b_U._WINDOW-HANDLE.
      END.
      RUN adeuib/_winsave.p ( h_cwin, FALSE ).
    END.
  END.
  HIDE FRAME f_rename.
  APPLY "ENTRY" TO txt IN FRAME f_edit.
  
END PROCEDURE.

PROCEDURE check_UIB_current_window :
  /*--------------------------------------------------------------------------
    Purpose:   Is the UIB Main Window pointing to the window whose code 
               we are editting?  If not, change the "current widget" to
               the one editted by the Section Editor.
    Notes:     Requires a current _SEW_U or _SEW_BC record.
  ---------------------------------------------------------------------------*/

  DEFINE BUFFER x_U FOR _U.

  DEFINE VARIABLE SEW_U-Handle    AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE SEW_U-WinHandle AS WIDGET-HANDLE NO-UNDO.

  /* Ensure the current design window is the same as the one being edited
     in the Section Editor as appropriate. Only actually run the check
     if the requestor is the Section Editor or the Section Editor was the
     last active window. Fixes 20000604-003 & 19981020-031. - jep */
  IF ( VALID-HANDLE(SELF) AND (SELF:WINDOW = h_sewin ) OR
     ( ACTIVE-WINDOW = h_sewin ) ) THEN
  DO:
    IF AVAILABLE _SEW_U THEN        /* Regular widget.                */
    DO:
      ASSIGN SEW_U-Handle    = _SEW_U._HANDLE
             SEW_U-WinHandle = _SEW_U._WINDOW-HANDLE.
    END.
    ELSE IF AVAILABLE _SEW_BC THEN  /* Else Browse or SDO column      */
    DO:
      FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.  /* Get column's parent */
      ASSIGN SEW_U-Handle    = x_U._HANDLE
             SEW_U-WinHandle = x_U._WINDOW-HANDLE.
    END.
    ELSE RETURN.

    IF (SEW_U-WinHandle <> _h_win) THEN
      RUN changewidg IN _h_UIB (SEW_U-Handle, yes /* Deselect others */).

  END.  /* if valid-handle(self)... */
  
END PROCEDURE.  /* check_UIB_current_window */

PROCEDURE check_store_trg.
  /*--------------------------------------------------------------------------
    Purpose:       stores the current contents of event, name and trigger code
                   to a _SEW_TRG record (IF and ONLY IF they have been changed).
                   If _auto_check, then we also do a check syntax .
    Run Syntax:    RUN check_store_trg (INPUT check_only, OUTPUT code_ok).
    Parameters:    INPUT check_only - If true, then we don't store the trigger.
                   INPUT print_section - If true then we are actually printing
                   OUTPUT code_ok   - TRUE if _auto_check is FALSE or no errors
    Notes:         Require a current _SEW_U record.
  ---------------------------------------------------------------------------*/

  /* PROGRESS Preprocessor system message number. */
  &SCOPED-DEFINE PP-4345      4345

  DEFINE INPUT  PARAMETER check_only    AS LOGICAL  NO-UNDO.
  DEFINE INPUT  PARAMETER print_section AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER code_ok       AS LOGICAL  NO-UNDO.

  DEFINE VARIABLE Err_Num       AS INTEGER       NO-UNDO.
  DEFINE VARIABLE Err_Msg       AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE v_h_win       AS WIDGET        NO-UNDO.
  DEFINE VARIABLE window-handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE New_Trg       AS LOGICAL       /* MUST BE UNDO */.
  DEFINE VARIABLE Temp_Code     AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE Temp_Restore  AS LOGICAL       NO-UNDO.
  
  DEFINE BUFFER b_U FOR _U.
  
  ASSIGN code_ok = yes. /* Unless we hear otherwise */

  /* Now store the contents of txt. (Which we may undo later after checkin). */
  STORE-BLOCK:
  DO TRANSACTION WITH FRAME f_edit:
    /* If multiple SEs are open, se_event may point to another SE window and
       not necessarily the one that has focus.  editted_event is more reliable.  
       See bug 99-05-07-001. (dma)
    FIND _SEW_TRG WHERE _SEW_TRG._wRECID = _SEW-recid AND
                    _SEW_TRG._tEVENT = se_event AND   /* The current value */
                    _SEW_TRG._STATUS <> "DELETED" NO-ERROR.
    */
    FIND _SEW_TRG WHERE _SEW_TRG._wRECID eq _SEW-recid AND
                        _SEW_TRG._tEVENT eq editted_event AND
                        _SEW_TRG._STATUS ne "DELETED" NO-ERROR.
                    
    /* Make sure the UIB is pointing to the correct window. */
    RUN check_UIB_current_window.
      
    /* NOTE: Special case of empty _CONTROL & _PROCEDURE code.  Delete any
       old _SEW_TRG and return true. */
    IF CAN-DO (Type_Trigger + "," + Type_Procedure + "," + Type_Function, se_section) AND
       (LENGTH(TRIM(txt:SCREEN-VALUE)) = 0)
    THEN DO: 
      IF AVAILABLE _SEW_TRG AND NOT check_only THEN DELETE _SEW_TRG.
      /* set the window-saved state to false, since we just cut object(s) */
      IF AVAILABLE _SEW_U THEN window-handle = _SEW_U._WINDOW-HANDLE.
      ELSE DO:
        FIND b_U WHERE RECID(b_U) = _SEW_BC._x-recid.
        window-handle = b_U._WINDOW-HANDLE.
      END.
      
      RUN adeuib/_winsave.p (INPUT window-handle, INPUT FALSE).
      
      RETURN.
    END. /* IF empty trigger text */
    /* Make a new (not special) code block */
    IF NOT AVAILABLE _SEW_TRG THEN
    DO:
      ASSIGN New_Trg = TRUE.
      IF (NOT AVAILABLE _P) THEN
        FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
      CREATE _SEW_TRG.
      ASSIGN _SEW_TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
             _SEW_TRG._tSPECIAL = ?
             _SEW_TRG._tSECTION = se_section          
             _SEW_TRG._wRECID   = _SEW-recid
             _SEW_TRG._tEVENT   = editted_event.
      /* Handle case where we are creating a special event. */
      IF (NUM-ENTRIES(_SEW_TRG._tEVENT, ".") > 1) THEN
        ASSIGN _SEW_TRG._tSPECIAL = _SEW_TRG._tEVENT.
    END.

    /* Don't overwrite existing trig from different section. Fixes 97-02-24-040. */
    IF _SEW_TRG._tSECTION = se_section THEN
        ASSIGN _SEW_TRG._tSECTION = se_section          
               _SEW_TRG._wRECID   = _SEW-recid
               _SEW_TRG._tEVENT   = editted_event  /* If value has changed */    
               . /* ASSIGN */
    /* Store the trigger code (except for a read-only special block) */
    IF read_only AND _SEW_TRG._tSPECIAL ne ? THEN
      _SEW_TRG._tCODE = ?.
    ELSE DO:
        /* The editor widget's screen contents have to be written to the underlying
           TRG temp-table so _qikcomp.p can process the "check_only" (check syntax or
           print section). To support undoing any changes after a check syntax or a
           print section, the original value of the code section is stored in temp_code
           variable where it will be restored to the temp-table field after the check_only
           request is completed. IZ 4098. */
        IF check_only THEN
        DO:
            ASSIGN Temp_Restore = YES
                   Temp_Code    = _SEW_TRG._tCODE.
        END.
        ASSIGN _SEW_TRG._tCODE    = txt:SCREEN-VALUE.
        IF CAN-DO("_OPEN-QUERY,_DISPLAY-FIELDS":U, _SEW_TRG._tSPECIAL) 
          AND NOT check_only THEN  /* 19990513-011 (dma) */
          RUN freeform_update (INPUT RECID(_SEW_U)).
        ELSE 
        ASSIGN _SEW_TRG._tSPECIAL = ? WHEN _SEW_TRG._tSPECIAL = "".
    END.
    /* Save off DB-REQUIRED setting. */
    ASSIGN db_required           = db_required:CHECKED
           _SEW_TRG._DB-REQUIRED = db_required        .
    
    /* Save off Private setting. */
    ASSIGN private_block           = private_block:CHECKED
           _SEW_TRG._PRIVATE-BLOCK = private_block.

    IF _auto_check or check_only THEN DO:
      ASSIGN _err_recid = RECID(_SEW_TRG).

      /* NOTE: Bug 19940630-025 Fix
         Because _qikcomp.p checks the syntax of the current UIB window
         _h_win, we must temporarily repoint _h_win to the window the
         Section Editor is currently working with.  We use the ON STOP
         block to ensure that even in the case of a hard error, the code
         will repoint _h_win back to the selected window in the UIB.
      */
      ASSIGN v_h_win = _h_win.
      DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY:
        IF NOT RETRY THEN
        DO:
          IF AVAILABLE _SEW_U THEN
            ASSIGN _h_win  = _SEW_U._WINDOW-HANDLE.
          ELSE DO:
            FIND b_U WHERE RECID(b_U) = _SEW_BC._x-recid.
            _h_win = b_U._WINDOW-HANDLE.
          END.
          RUN adeuib/_qikcomp.p (INPUT IF print_section THEN "PRINT-SECTION":U ELSE "":U).
          IF RETURN-VALUE BEGINS "ERROR":U THEN 
            code_ok = FALSE.
        END.
        ASSIGN _h_win = v_h_win.
      END.

      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      _err_recid = ?.

      /* There are cases when we need to restore the code in the temp-table to its original
         value to support undo. Temp_Code does this. This is done as close after the
         _qikcomp.p as possible so the original code is restored to the correct
         _SEW_TRG record. IZ 4098. */
      IF AVAILABLE _SEW_TRG AND Temp_Restore THEN
      DO:
        ASSIGN _SEW_TRG._tCode = Temp_Code.
      END.

      IF NOT print_section THEN DO:
        IF COMPILER:STOPPED = FALSE THEN DO:
        IF COMPILER:ERROR THEN DO:
 
          /* Verify that error is in this trigger!!!! */
          IF (_SEW_TRG._tOFFSET < COMPILER:FILE-OFFSET)
             AND (COMPILER:FILE-OFFSET < (_SEW_TRG._tOFFSET + LENGTH(txt:SCREEN-VALUE, "RAW")))
          THEN DO:
            RUN adecomm/_errmsgs.p ( INPUT h_sewin , INPUT COMPILER:FILE-NAME ,
                                     INPUT _comp_temp_file ).
 
            ASSIGN txt:CURSOR-OFFSET IN FRAME f_edit =
                     MAX(1, INTEGER(COMPILER:FILE-OFFSET) - _SEW_TRG._tOFFSET)
                   NO-ERROR.
          END.
          ELSE DO:
            /* An error occured in another section -- tell the user */
            /* If it occurred in a an include file, report those errors. */
            IF COMPILER:FILE-NAME <> _comp_temp_file THEN
            DO:
              MESSAGE "This section could not be checked because of an" {&SKP}
                      "error in an include file referenced in this or"  {&SKP}
                      "another section."
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW h_sewin.
              RUN adecomm/_errmsgs.p ( INPUT h_sewin , INPUT COMPILER:FILE-NAME ,
                                       INPUT _comp_temp_file ).
            END.
            ELSE
            DO:
              /* Get message for first non-preprocessor message. */
              DO Err_Num = 1 TO ERROR-STATUS:NUM-MESSAGES:
                  IF ERROR-STATUS:GET-NUMBER( Err_Num ) <> {&PP-4345} THEN LEAVE.
              END.
              ASSIGN _err_msg = ERROR-STATUS:GET-MESSAGE( Err_Num ).
            END.
  
            /* Must do this FIND AFTER check on IF COMPILER:FILE-NAME..ELSE because
               adecomm/_errmsgs.p requires that ERROR-STATUS be the result of
               a COMPILE...NO-ERROR and not the FIND...NO-ERROR.
            */ 
            FIND FIRST _SEW_TRG WHERE (_SEW_TRG._tOFFSET < COMPILER:FILE-OFFSET)
             AND COMPILER:FILE-OFFSET < (_SEW_TRG._tOFFSET + LENGTH(_SEW_TRG._tCODE, "RAW"))
             AND _SEW_TRG._STATUS <> "DELETED"
             NO-ERROR.
            IF COMPILER:FILE-NAME = _comp_temp_file THEN
            DO:
              ASSIGN Err_Msg = "This section could not be checked because of an" + CHR(10)
                               + "error in ".

              IF NOT AVAILABLE _SEW_TRG THEN
                  ASSIGN Err_Msg = Err_Msg + "another section:" + CHR(10) + CHR(10) + _err_msg.
              ELSE IF _SEW_TRG._tEVENT = "_DEFINITIONS" THEN
                  ASSIGN Err_Msg = Err_Msg + "the Definitions Code Block:" + CHR(10) + CHR(10) + _err_msg.
              ELSE IF _SEW_TRG._tEVENT = "_INCLUDED-LIB" THEN
              DO:
                  ASSIGN Err_Msg = Err_Msg + "a Method Library include reference:" + CHR(10) + CHR(10) + _err_msg
                                   + CHR(10) + CHR(10) +
                          "Check that the file exists and can be found in the PROPATH."
                          + CHR(10) +
                          "The including file may not compile correctly until the Method"
                          + CHR(10) + "Library can be found in the PROPATH.".
              END.
              ELSE
                  ASSIGN Err_Msg = Err_Msg + "the Main Code Block:" + CHR(10) + CHR(10) + _err_msg.
  
              WARNING_BLOCK:
              DO ON STOP UNDO WARNING_BLOCK, LEAVE WARNING_BLOCK:
                  MESSAGE Err_Msg
                      VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW h_sewin.
              END.
            END.
          END.
          APPLY "ENTRY":U to txt.
          ASSIGN _err_msg   = ""
                 code_ok    = no.
        END.  /* IF ERROR... */
        ELSE /* Display any preprocessor messages. */
            RUN adecomm/_errmsgs.p ( INPUT h_sewin , INPUT COMPILER:FILE-NAME ,
                                     INPUT _comp_temp_file ).
        END.  /* IF STOPPED */
        ELSE DO:
          /* Compilation was stopped. */
          ASSIGN _err_msg   = ""
                 code_ok    = no.
        END.
      
        /* Empty the trigger offsets established in quikcomp. */
        FOR EACH _SEW_TRG WHERE _SEW_TRG._tOFFSET NE ?:
          _SEW_TRG._tOFFSET = ?.
        END.

        /* Remove the temporary compile file. It is not saved */
        OS-DELETE VALUE(_comp_temp_file).
      END.  /* if not print_section */
        
      /* The UNDO seems to be a left-over from when the Section
      ** Editor was modal; It does not appear to be doing anything
      ** useful.  Moreover this is causing unwanted side-effects,
      ** such as bug 20000523-018 (7/17/00 tomn).
      */
      /* Undo changes if we were only testing syntax, or on error */
      IF check_only OR NOT code_ok THEN /*UNDO STORE-BLOCK,*/ RETURN.

    END.  /* IF auto_check */
    /* set the window-saved state to false, since we just added a trigger */
    IF AVAILABLE _SEW_U THEN window-handle = _SEW_U._WINDOW-HANDLE.
    ELSE DO:
      FIND b_U WHERE RECID(b_U) = _SEW_BC._x-recid.
      window-handle = b_U._WINDOW-HANDLE.
    END.
    RUN adeuib/_winsave.p(window-handle, FALSE).
    /* Commented out - 3/94 - jep. Was breaking SE_ERROR coding. */
    /* _err_recid = ?              */

    /* If its a new code block and proc obj uses treeview, create the
       treeview node. - jep */
    IF New_Trg THEN
    DO:
      IF (NOT AVAILABLE _P) THEN
          FIND _P WHERE _P._u-recid = win_recid.
      IF VALID-HANDLE(_P._tv-proc) THEN
      DO:
          RUN addCodeNode IN _P._tv-proc
                (INPUT se_section,
                 INPUT _SEW-recid,
                 INPUT editted_event).
      END.
    END.
  END.  /* STORE-BLOCK TRANSACTION */
END PROCEDURE. /* check_store_trg. */

PROCEDURE display_trg.
  /* -------------------------------------------------------------------------
    Purpose:        Find a trigger and display it.
    Run Syntax:     RUN display_trg.
    Parameters:     <none>
    Assumptions:    se_section, RECID(_SEW_U), se_event point to the desired trigger
  ---------------------------------------------------------------------------*/
  DEFINE VARIABLE list_item     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE list_label    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE window-handle AS HANDLE    NO-UNDO.
  DEFINE VARIABLE code_type     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL   NO-UNDO.

  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER p_U FOR _U.

  /* Assign current SEW status to _SEW record. - jep. */
  IF AVAILABLE _SEW_U THEN
    ASSIGN window-handle = _SEW_U._WINDOW-HANDLE.
  ELSE IF AVAILABLE _SEW_BC THEN DO:
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.  /* Get browse record */
    ASSIGN window-handle = x_U._WINDOW-HANDLE.
  END.
  ELSE RETURN.
          
  RUN AssignSEW ( se_section , se_recid , se_event ,
                  _SEW-recid , RECID(_SEW_TRG) ,
                  window-handle).
  
  DO WITH FRAME f_edit:
    FIND _SEW_TRG WHERE _SEW_TRG._tSECTION = se_section AND
                        _SEW_TRG._wRECID   = _SEW-recid AND
                        _SEW_TRG._tEVENT   = se_event AND
                        _SEW_TRG._STATUS <> "DELETED" NO-ERROR.
    IF AVAILABLE _SEW_TRG THEN DO:
      txt = _SEW_TRG._tCODE.
      IF (_SEW_TRG._tSPECIAL NE ?) AND (_SEW_TRG._tCODE = ?)
      THEN RUN adeshar/_coddflt.p (_SEW_TRG._tSPECIAL, _SEW-recid, OUTPUT txt).
    END.
    ELSE DO:  /* Trigger doesn't exist, make some temporary txt for editor */
      /* Initialize for the code text using the default code builder (for
         the relevant template) */ 

      ASSIGN code_type = se_section. /* Default code type. */
      IF (se_event = "DEFINE_QUERY") THEN
        ASSIGN code_type = "_DEFINE-QUERY":U.
      ELSE IF (NUM-ENTRIES(se_event, ".") > 1) THEN
        ASSIGN code_type = se_event.
      RUN adeshar/_coddflt.p (code_type, _SEW-recid, OUTPUT txt).
      
      /* Since _SEW_TRG doesn't exist, lets create a temporary version
         to trick adecomm/_adeevnt.p into modifying txt in the case a
         user wants to trap a create trigger event.                 */
      IF (NOT AVAILABLE _P) THEN
          FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
      CREATE _SEW_TRG.
      ASSIGN _SEW_TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
             _SEW_TRG._tSECTION = se_section
             _SEW_TRG._wRECID   = _SEW-recid
             _SEW_TRG._tEVENT   = se_event
             _SEW_TRG._tCODE    = txt.
      RUN adecomm/_adeevnt.p ("UIB":U, "New":U, INTEGER(RECID(_SEW_TRG)),
                                        se_section, OUTPUT lOK).
      txt = _SEW_TRG._tCODE.
      DELETE _SEW_TRG.  /* We are finished tricking _adeevnt */
    END.  /* _SEW_TRG isn't available */
    
    /* Lock the txt and show the templates */
    read_only  = AVAILABLE(_SEW_TRG)
                 AND (_SEW_TRG._tSPECIAL ne ?)
                 AND (_SEW_TRG._tCODE = ?).
    RUN show_read_only.
    
    /* If the new display is a control then show control related things. */
    CASE se_section:
      WHEN Type_Trigger THEN DO:
        ASSIGN recent_recid = _SEW-recid
               recent_trig  = se_event
               list_item    = IF AVAILABLE _SEW_U
                              THEN (IF _SEW_U._DBNAME = ?
                                    THEN _SEW_U._NAME
                                    ELSE (_SEW_U._DBNAME + "." +
                                          _SEW_U._TABLE  + "." +
                                          _SEW_U._NAME))
                              ELSE _SEW_BC._DISP-NAME
               list_label   = IF AVAILABLE _SEW_U
                                THEN _SEW_U._LABEL
				ELSE "<":U + x_U._NAME + " Column>".
     if available _SEW_U and _SEW_U._DBNAME NE ?   THEN DO:
     FIND p_U WHERE RECID(p_U) = _sew_U._PARENT-RECID NO-ERROR.
      IF AVAILABLE p_U THEN
        list_label = "<":U  + p_U._NAME + " Frame>".
     END.


        RUN GetWidgetListName ( INPUT list_item ,
                                INPUT list_label ,
                                OUTPUT list_item ).
        ASSIGN wname = list_item.
        DISPLAY se_event wname WITH FRAME f_edit.
      END.
      WHEN Type_Procedure THEN DO:
        recent_proc  = se_event.  /* Save for later */
        DISPLAY se_event read_only WHEN read_only WITH FRAME f_edit.
      END.
      WHEN Type_Function THEN DO:
        recent_func  = se_event.  /* Save for later */
        DISPLAY se_event read_only WHEN read_only WITH FRAME f_edit.
      END.
    END CASE.

    RUN show_private_block (INPUT se_section).
    
    RUN show_db_required (INPUT se_section).
    
    /* For Freeform QUERY object, no real 4GL events can be created.
       We check if AVAILABLE first because _SEW_U may not be
       present if the section editor object is a Browse Column.  */
/*  ASSIGN btn_New:SENSITIVE = NOT (AVAILABLE _SEW_U AND
                                    _SEW_U._TYPE = "QUERY":U).
    We need to new button for free form queries so that users can get
    a psuedo trigger for define query  DRH 10/15/97              */
    
    /* Show the code */
    DISPLAY txt WITH FRAME f_edit.

    /* Position text cursor. */
    RUN set_cursor.
    
    /* Auto-entry -- whether its "windows standard" or not, its more usable. */
    APPLY "ENTRY":U TO txt.

    /* Change the values which we use to determine whether or not code has
       changed when we try to change triggers */
    RUN CodeModified ( INPUT FALSE ).

  END. /* DO WITH FRAME f_edit... */
END PROCEDURE. /* display_trg. */

PROCEDURE CodeModified.
  /*--------------------------------------------------------------------------
    Purpose:        Change the values which we use to determine whether or
                    not code has changed when we try to change triggers.

    Run Syntax:     RUN CodeModified ( INPUT p_Modified ).

    Parameters:     INPUT  p_Modified
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Modified AS LOGICAL NO-UNDO.

  DO WITH FRAME f_edit:
    ASSIGN txt:MODIFIED  = p_Modified
           editted_event = se_event.

    /* Reset the EDIT-CAN-UNDO attribute. */
    IF p_Modified = FALSE THEN
      ASSIGN txt:EDIT-CAN-UNDO = FALSE.
  END.
  
END PROCEDURE.

PROCEDURE insert_file:
  /*--------------------------------------------------------------------------
    Purpose:        Ask the user for a file name and put its name or
                    contents in the p_Buffer editor widget.

    Run Syntax:     RUN insert_file ( INPUT p_Mode, INPUT p_Buffer ).

    Parameters:     INPUT  p_Mode	CHAR - "NAME" or "CONTENTS"
		    INPUT  p_Buffer	WIDGET-HANDLE
		    Edit Buffer handle to insert file into.
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Mode   AS CHAR NO-UNDO .
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE Absolute_File  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE File_Name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE IF_OK          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Insert_File    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Save-CW        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE vTitle         AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE File_Filters   AS CHARACTER NO-UNDO.
  
  ASSIGN 
    vTitle         = "Insert File " + IF p_Mode = "NAME" THEN "Name" ELSE "Contents" 
    save-cw        = current-window
    current-window = h_sewin.

  /* Insert file name found on remote WebSpeed agent. */
  IF _remote_file THEN
  RUN adeweb/_webfile.w ("uib":U, "Open":U, vTitle, "":U,
                         INPUT-OUTPUT File_Name, OUTPUT Insert_File, 
                         OUTPUT IF_OK) NO-ERROR.
  ELSE DO:
    File_Filters = 
      "Includes & Procedures (*.i,*.p)|*.i,*.p|Windows & Export (*.w,*.wx)|*.w,*.wx|All Files|*.*":U.  
    RUN adecomm/_fndfile.p (INPUT vTitle,                   /* pTitle         */
                            INPUT "TEXT",                   /* pMode          */
                            INPUT File_Filters,             /* pFilters       */
                            INPUT-OUTPUT {&CODE-DIRS},      /* pDirList       */
                            INPUT-OUTPUT insert_File,       /* pFileName      */
                            OUTPUT Absolute_File,        /* pAbsoluteFileName */
                            OUTPUT IF_OK).                  /* pOK            */
  END.  /* else do */
  
  ASSIGN CURRENT-WINDOW = Save-CW.
    
  IF IF_OK THEN DO:
    IF p_Mode eq "NAME":U THEN
    DO:
      IF _remote_file THEN Insert_File = File_Name.
      /* Change backslash to forward slash for UNIX compatibility. */
      ASSIGN Insert_File = REPLACE(Insert_File, "~\":U, "/":U).
      RUN paste_txt ( Insert_File ).
    END.
    ELSE DO:
      ASSIGN IF_OK = p_Buffer:INSERT-FILE( Insert_File ) NO-ERROR.
      IF ( IF_OK eq NO ) THEN
        MESSAGE (IF _remote_file THEN File_Name ELSE Insert_File) SKIP
                 "Unable to find or open file." SKIP(1)
                 "The file may not exist or may be too large" SKIP
                 "to insert into the current buffer."
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW h_sewin.
    END.
  END.
  APPLY "ENTRY":U TO p_Buffer .

END PROCEDURE.  /* insert_file */

PROCEDURE get_default_event.
  /*--------------------------------------------------------------------------
    Purpose:       Gets the "normal" event for a given widget-type.
    Run Syntax:    RUN get_default_event (INPUT _SEW_U._TYPE, OUTPUT se_event).
    Parameters:    INPUT w_type      - widget type
                   OUTPUT dflt       - best choice for an event.
    Notes:         Require a current _SEW_U record.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  w_type      AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER dflt        AS CHAR NO-UNDO.

  /* JEP-UNFINISHED - This should work fine for PDO's and Web Objects. */
  /* If the procedure object supports special events only, use the first
     one as the default for whatever object we have. */
  IF NOT AVAILABLE _P THEN
    FIND _P WHERE _P._u-recid eq win_recid.
  IF CAN-DO(_P._EDITING, "SPECIAL-EVENTS-ONLY") THEN
  DO:
      ASSIGN dflt = ENTRY(1 , _P._EVENTS) NO-ERROR. /* NO-ERROR in case list is empty. */
      IF (dflt = "") THEN
        ASSIGN dflt = "Unknown.Event".
      RETURN.
  END.
  
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
        MESSAGE "Unknown type :" w_type
            view-as alert-box information buttons OK
                    in window h_sewin.
        dflt = "MOUSE-SELECT-CLICK":U.
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

  DEFINE VARIABLE proc_entry    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE proc_list     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE window-handle AS HANDLE    NO-UNDO.
  DEFINE VARIABLE adm-version   AS CHARACTER NO-UNDO.
  
  DEFINE BUFFER b_U FOR _U.
    
  DO WITH FRAME f_edit:
    /* Get names of all Procedures defined in all the Included Libraries
       and get the subset of SmartMethod procedures in the Included Libraries.
    */
    IF VALID-HANDLE( _h_mlmgr ) THEN
    DO ON STOP UNDO, LEAVE:
        RUN get-saved-methods IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
                                            INPUT-OUTPUT p_All_List   ,
                                            INPUT-OUTPUT p_Smart_List ).
        /* Get names of all Functions defined in all the Included Libraries
           and get the subset of SmartFunctions in the Included Libraries.
        */
        RUN get-saved-funcs   IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
                                            INPUT-OUTPUT p_All_List   ,
                                            INPUT-OUTPUT p_Smart_List ).
    END.

    /* Add to the All List any user defined procedures and add to the
       Smart List any user defined ADM Methods for the current design
       window. Smart List of "adm-" procs is for ADM1 objects only. - jep
    */
    FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
    IF AVAILABLE _P THEN
        ASSIGN adm-version = _P._ADM-Version.
        
    ASSIGN proc_list = se_event:HANDLE IN FRAME f_edit .
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
    IF AVAILABLE _SEW_U THEN
      ASSIGN window-handle = _SEW_U._WINDOW-HANDLE.
    ELSE DO:
      FIND b_U WHERE RECID(b_U) = _SEW_BC._x-recid.
      ASSIGN window-handle = b_U._WINDOW-HANDLE.
    END.
    FIND _P WHERE _P._WINDOW-HANDLE = window-handle NO-ERROR .
    IF AVAILABLE _P AND _P._RESERVED-PROCS <> "" THEN
        ASSIGN p_All_List = p_All_List + "," + _P._RESERVED-PROCS.

    /* Ensure there are no leading or trailing commas. */
    ASSIGN p_All_List = TRIM(p_All_List, ",":U).
            
  END. /* DO WITH FRAME */
  
END PROCEDURE.


PROCEDURE paste_txt.
 /*--------------------------------------------------------------------------
    Purpose:       Take an input string and paste it into the text editor.
                   This will replace the current selection, or insert the string
                   if nothing is selected.  If the editor is read-only, we
                   don't paste.
    Run Syntax:    RUN paste_txt (str).
    Parameters:    INPUT str - char.
   ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER str AS CHAR    NO-UNDO.
  DEFINE VAR   stat          AS LOGICAL NO-UNDO.
  DEFINE VAR   h             AS WIDGET  NO-UNDO.
  
  h = txt:HANDLE IN FRAME f_edit.
  IF h:READ-ONLY THEN RETURN.
  IF ( h:TEXT-SELECTED )
  THEN stat = h:REPLACE-SELECTION-TEXT( str ). /* Text selected: replace it. */
  ELSE stat = h:INSERT-STRING( str ).          /* or, insert new string.     */ 
  APPLY "ENTRY" TO txt IN FRAME f_edit.
END PROCEDURE.

PROCEDURE set_isection.
  /*--------------------------------------------------------------------------
    Purpose:       Sets the currently displayed SECTION.
    Run Syntax:    RUN set_isection.
    Parameters:    <none>
    Notes:         Require SECTION, EVENT.
  ---------------------------------------------------------------------------*/
  DEFINE VAR l_ctrl       AS LOGICAL   NO-UNDO.
  DEFINE VAR l_ctrl_proc  AS LOGICAL   NO-UNDO.
  DEFINE VAR code_section AS CHARACTER NO-UNDO.
  DEFINE VAR nsection     AS INTEGER   NO-UNDO.
  
  DO WITH FRAME f_edit:
  
    DISPLAY isection.
    CASE isection :
        WHEN Definitions    THEN ASSIGN nsection = 1.
        WHEN Trigs          THEN ASSIGN nsection = 2.
        WHEN Libraries      THEN ASSIGN nsection = 3.
        WHEN Main_Block     THEN ASSIGN nsection = 4.
        WHEN Procedures     THEN ASSIGN nsection = 5.
        WHEN Functions      THEN ASSIGN nsection = 6. 
    END CASE.
    
    ASSIGN  l_ctrl             = (isection = Trigs)
            l_ctrl_proc        = (isection = Trigs) OR
                                 (isection = Procedures) OR (isection = Functions)
            se_event:LABEL     = IF isection = Trigs
                                   THEN "ON"
                                 ELSE IF (isection = Procedures) OR (isection = Functions)
                                   THEN "Name"
                                 ELSE se_event:LABEL
            se_event:VISIBLE   = l_ctrl_proc
            btn_new:VISIBLE    = l_ctrl_proc
            btn_rename:VISIBLE = (isection = Procedures) OR (isection = Functions)
            wname:VISIBLE      = l_ctrl.     

    /* Show different objects based on the current section. */
    IF l_ctrl_proc THEN     /* Triggers or Procedures */
        DISPLAY se_event WITH frame f_edit.    
    IF l_ctrl THEN          /* Triggers only */
        DISPLAY wname WITH frame f_edit.

    /* Change labels of various menu options. - jep  */
    ASSIGN code_section = ENTRY( nsection , "Definitions,Trigger,Library,Main,Procedure,Function").
    ASSIGN MENU-ITEM m_EditDelete:LABEL     IN MENU mnu_Edit
                = "&Delete " + code_section + "..."
    . /* ASSIGN */
    
  END.
END PROCEDURE.

PROCEDURE set_cursor.
  /*--------------------------------------------------------------------------
    Purpose:       Sets the position of the editor text cursor.
    Run Syntax:    RUN set_cursor.
    Parameters:    <none>
    Notes:         
  ---------------------------------------------------------------------------*/
  DEFINE VAR off_set AS INTEGER INIT 1  NO-UNDO.        
  DEFINE VAR ret_val AS LOGICAL         NO-UNDO. 
  
  DO WITH FRAME f_edit:

    /* First handle positioning cursor when not the Trigger section or
       when error has occurred. */
    IF (se_section <> Type_Trigger)
       OR (_err_recid <> ? AND COMPILER:FILE-OFFSET <> ?) THEN
    DO:
      /* Do the following assign no-error because it might fail. */
      ASSIGN off_set =
             IF _err_recid = ? OR COMPILER:FILE-OFFSET = ? OR
                INTEGER(COMPILER:FILE-OFFSET) - _SEW_TRG._tOFFSET < 1 OR
                INTEGER(COMPILER:FILE-OFFSET) - _SEW_TRG._tOFFSET >
                LENGTH(txt:SCREEN-VALUE)
             THEN off_set
             ELSE INTEGER(COMPILER:FILE-OFFSET) - _SEW_TRG._tOFFSET
             NO-ERROR.

      ASSIGN txt:CURSOR-OFFSET = off_set NO-ERROR.
      RETURN.
    END.

    /* Trigger section cursor handling (when no error has occurred.)
       Try to position within the first DO:  END. block. We do this by
       finding the first colon (:) and positioning one line after and
       three characters in (assuming an indent of 2). */
    ASSIGN ret_val = txt:SEARCH(":" , FIND-NEXT-OCCURRENCE).
    IF ret_val = TRUE THEN
    DO:
        ASSIGN txt:CURSOR-LINE = txt:CURSOR-LINE + 1 NO-ERROR.
        ASSIGN txt:CURSOR-CHAR = 3 NO-ERROR.
    END.
    ELSE
        ASSIGN txt:CURSOR-OFFSET = off_set NO-ERROR.
    
  END.
  RETURN.
  
END PROCEDURE.

PROCEDURE show_read_only.
  /*--------------------------------------------------------------------------
    Purpose:       Sets all aspects of the display that show the user whether
                   the text editor is READ-ONLY or not (This includes buttons
                   and paste triggers).  Most of the things disabled are things
                   that would insert strings into the text widget.
    Run Syntax:    RUN show_read_only
    Parameters:    <none>
    Notes:         Require read_only.
  ---------------------------------------------------------------------------*/
  
  DO WITH FRAME f_edit:
    IF txt:READ-ONLY <> read_only THEN DO:
      ASSIGN txt:READ-ONLY = read_only
             txt:BGCOLOR   = (IF read_only THEN 8 ELSE std_ed4gl_bgcolor )
             read_only:VISIBLE = read_only
             MENU-ITEM m_EditUndo:SENSITIVE    IN MENU mnu_Edit   = NOT read_only
             MENU-ITEM m_EditCut:SENSITIVE     IN MENU mnu_Edit   = NOT read_only
             MENU-ITEM m_EditPaste:SENSITIVE   IN MENU mnu_Edit   = NOT read_only
             SUB-MENU  m_Format_Menu1:SENSITIVE              = NOT read_only
             MENU mnu_Insert:SENSITIVE                       = NOT read_only                         
             MENU-ITEM m_Replace:SENSITIVE IN MENU mnu_Search = NOT read_only
             MENU-ITEM m_Cmp_Check_Syntax:SENSITIVE IN MENU mnu_Compile
                = NOT read_only
             btn_pcall:SENSITIVE         = NOT read_only
      &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN    
             MENU mnu_EdPopup:SENSITIVE  = NOT read_only
      &ENDIF
      . /* ASSIGN */
    END.
  END.
END PROCEDURE.

PROCEDURE show_private_block.
  /*--------------------------------------------------------------------------
    Purpose:       Sets all aspects of the display that shows the user whether
                   the code block is a Private procedure or function.
    Run Syntax:    RUN show_private_block (INPUT p_cur_section).
    Parameters:    p_cur_section - Current Code Section Type.
    Notes:         Requires private_block field.
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_cur_section AS CHAR NO-UNDO.
  
  DEFINE BUFFER x_P FOR _P.

  DO WITH FRAME f_edit:
    CASE p_cur_section:
        WHEN Type_Procedure OR WHEN Type_Function THEN
        DO:

            IF NOT AVAILABLE(_SEW_TRG) THEN
                ASSIGN private_block = FALSE.
            ELSE
                ASSIGN private_block  = _SEW_TRG._PRIVATE-BLOCK.
            ASSIGN private_block:VISIBLE = TRUE.
            ASSIGN private_block:SENSITIVE = TRUE.
            DISPLAY private_block WITH FRAME f_edit.
        END.
        OTHERWISE
        DO:
            ASSIGN private_block:VISIBLE = FALSE
                   private_block:CHECKED = private_block.
        END.
    END CASE.
  END.
    
END PROCEDURE.


PROCEDURE show_db_required.
  /*--------------------------------------------------------------------------
    Purpose:       Sets all aspects of the display that shows the user whether
                   the code block is a DB-REQUIRED block (specific to PDO's).
    Run Syntax:    RUN show_db_required (INPUT p_cur_section).
    Parameters:    p_cur_section - Current Code Section Type.
    Notes:         Requires db_required field.
  ---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_cur_section AS CHAR NO-UNDO.
  
  DEFINE BUFFER x_P FOR _P.
  
  DO WITH FRAME f_edit:
    IF NOT AVAILABLE _P THEN
        FIND x_P WHERE x_P._u-recid eq win_recid.
    ELSE
        FIND x_P WHERE RECID(x_P) = RECID(_P).
    
    /* If this procedure doesn't support DB-REQUIRED code blocks,
       then override p_cur_section to ensure we never display the
       DB-REQUIRED check-box in the Section Editor window. */
    IF NOT _P._DB-AWARE THEN ASSIGN p_cur_section = "".

    CASE p_cur_section:
        WHEN Type_Procedure OR WHEN Type_Function THEN
        DO:
            IF NOT AVAILABLE(_SEW_TRG) THEN
                ASSIGN db_required = FALSE.
            ELSE
                ASSIGN db_required  = _SEW_TRG._DB-REQUIRED.
            ASSIGN db_required:VISIBLE = TRUE.
            ASSIGN db_required:SENSITIVE = TRUE.
            DISPLAY db_required WITH FRAME f_edit.
        END.
        OTHERWISE
        DO:
            ASSIGN db_required:VISIBLE = FALSE
                   db_required:CHECKED = db_required.
        END.
    END CASE.
  END.
    
END PROCEDURE.


PROCEDURE store_trg.
  /*--------------------------------------------------------------------------
    Purpose:       stores the current contents of event, name and trigger code
                   to a _SEW_TRG record (IF and ONLY IF they have been changed).
                   If _auto_check, then we also do a check syntax and return
                   the state of the code.
    Run Syntax:    RUN store_trg (INPUT explicit, OUTPUT code_ok).
    Parameters:    INPUT  explicit - if TRUE then the user has asked to
                      store explicitly.  We don't ask again if the user wants
                      to store. 
                   OUTPUT code_ok   - TRUE if the no errors were found.
                      i.e. User did not want to check on store OR
                           User stored with _auto_check and code is ok OR
                           User cancelled the store.
    Notes:         Require a current _SEW_U record.
  ---------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER explicit       AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER code_ok        AS LOGICAL NO-UNDO.

  DEF VAR ans        AS LOGICAL NO-UNDO.
  
  DO WITH FRAME f_edit:
    ASSIGN code_ok = TRUE.
    /* If the text, event, or DB-REQUIRED has been modified  */
    IF (txt:MODIFIED) OR
       (CAN-DO( Type_Trigger + "," + Type_Procedure + "," + Type_Function, se_section) AND
        editted_event ne se_event) OR
       (db_required:CHECKED <> db_required) OR
       (private_block:CHECKED <> private_block)
    THEN 
        RUN check_store_trg (FALSE, FALSE, OUTPUT code_ok).
  END.
END PROCEDURE. /* store_trg. */


/*================== Insert 4GL Menu Procedures ================= */
PROCEDURE InsertEventName.
  /*-------------------------------------------------------------------------
    Purpose:    Insert a 4GL Event name into the section editor.
    Run Syntax: RUN InsertEventName.
    Parameters:     
  ---------------------------------------------------------------------------*/
  
  
  DEFINE VAR event  AS CHAR   NO-UNDO.
  DEFINE VAR h_cwin AS WIDGET NO-UNDO.

  ASSIGN h_cwin         = CURRENT-WINDOW
         CURRENT-WINDOW = h_sewin.
  DO ON STOP UNDO, LEAVE:
    IF (NOT AVAILABLE _P) THEN
      FIND _P WHERE _P._u-recid = win_recid.

    /* Ask for a new event and put its quoted name into the code. */
    RUN adeuib/_selevnt.p
        (INPUT "ALL",
         INPUT "ALL",
         INPUT "SE_INSERT_EVENT":U,
         INPUT _cur_win_type,
         INPUT RECID(_P),
         INPUT-OUTPUT event).
  END.
  ASSIGN CURRENT-WINDOW = h_cwin.
  
  IF event <> "" THEN RUN paste_txt ("~"" + event + "~":U").
  APPLY "ENTRY" TO txt IN FRAME f_edit.

END PROCEDURE.


PROCEDURE InsertWidgetName.
  /*-------------------------------------------------------------------------
    Purpose:    Insert a UIB Widget name into the section editor.
    Run Syntax: RUN InsertWidgetName.
    Parameters:     
  ---------------------------------------------------------------------------*/

  RUN call_coderefs IN _h_uib (INPUT "displayTab:Objects":u).
    
  RETURN.
END PROCEDURE.

PROCEDURE doInsertWidgetName.
  /*-------------------------------------------------------------------------
    Purpose:    Insert a UIB Widget name into the section editor.
    Run Syntax: RUN doInsertWidgetName.
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pString AS CHARACTER NO-UNDO.
  
  DEFINE VAR result AS CHAR     NO-UNDO.
  DEFINE VAR vList  AS CHAR     NO-UNDO.
  DEFINE VAR item   AS CHAR     NO-UNDO.
  DEFINE VAR delim  AS CHAR     NO-UNDO.
  DEFINE VAR i      AS INTEGER  NO-UNDO.
  DEFINE VAR list_item AS CHAR  NO-UNDO.
  DEFINE VAR name_list AS CHAR  NO-UNDO.
  
  ASSIGN delim = CHR(10) /* wname:DELIMITER in frame f_edit */.

  ASSIGN vList = pString.
  IF vList <> ? THEN
  DO:
    ASSIGN result = "".
    /* vList contains a string of the form "NAME    label". Remove label
       in each line. */
    DO i = 1 to NUM-ENTRIES (vList , delim):
      ASSIGN item = ENTRY(i, vList ,delim)   /* "NAME  label" */
             item = ENTRY(1, item, " ")      /* "NAME"        */
             result = (IF i EQ 1 THEN item ELSE (result + " " + item)).
    END.
    /* If the string begins with "Temp-Tables.", remove that. Its an AppBuilder
       temp-table object and we don't want to include the "Temp-Tables." part.
    */
    IF (result BEGINS "Temp-Tables.":U) THEN
        ASSIGN result = REPLACE(result, "Temp-Tables.":U, "":U).
    RUN paste_txt (result).
  END.
  APPLY "ENTRY" TO txt IN FRAME f_edit.
  
END PROCEDURE.

PROCEDURE getInsertWidgetNameList.
  /*-------------------------------------------------------------------------
    Purpose:    Return a delimited list of object names and the name of the
                current object, if applicable.
    Run Syntax: 
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pList AS CHARACTER NO-UNDO. /* Name List */
  DEFINE OUTPUT PARAMETER pItem AS CHARACTER NO-UNDO. /* Item to Select */
  
  DEFINE BUFFER x_U  FOR _U.
  
  DEFINE VAR result AS CHAR     NO-UNDO.
  DEFINE VAR vList  AS CHAR     NO-UNDO.
  DEFINE VAR item   AS CHAR     NO-UNDO.
  DEFINE VAR delim  AS CHAR     NO-UNDO.
  DEFINE VAR i      AS INTEGER  NO-UNDO.
  DEFINE VAR list_item AS CHAR  NO-UNDO.
  DEFINE VAR name_list AS CHAR  NO-UNDO.
  
  IF NOT VALID-HANDLE(h_win_trig) THEN DO:
    /* Get the window (and its save-as-file) for this trigger */
    IF AVAILABLE _SEW_U THEN
      h_win_trig = _SEW_U._WINDOW-HANDLE.
    ELSE RETURN.
  END.

  /* To avoid frame reparenting, parent the f_pick dialog box frame
     to section editor window now.  */
  IF NOT VALID-HANDLE( FRAME f_Pick:PARENT ) THEN
    ASSIGN FRAME f_Pick:PARENT = h_sewin.

  /* Fill the picklist with "NAME   Label,which may contain commas" */
  /* Note that we change the Delimiter here just to be safe.        */
  ASSIGN FRAME f_pick:TITLE = "Object Names"
         delim              = wname:DELIMITER in frame f_edit
         name_list          = wname:LIST-ITEMS in frame f_edit
         s_PickList:HIDDEN IN FRAME f_pick = TRUE /* Hide other picklist */
         .
  IF (name_list = ?) THEN name_list = "".

  /* Add the QUERY, SmartObject, MENUBAR, and Control Frame COM-HANDLE
     names to the Names list. */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = h_win_trig
               AND   x_U._STATUS NE "DELETED"
               AND   (x_U._TYPE    eq "SmartObject":U OR
                      x_U._TYPE    eq "QUERY":U  OR
                      x_U._SUBTYPE eq "MENUBAR":U OR
                      x_U._TYPE = "{&WT-CONTROL}":U)
               BY x_U._NAME :

        RUN GetWidgetListName ( INPUT x_U._NAME, INPUT x_U._LABEL ,
                                OUTPUT list_item ).
        IF (x_U._TYPE = "{&WT-CONTROL}":U) THEN
            ASSIGN list_item = "ch" + x_U._NAME + ":" + x_U._LABEL.

        /* Ensure we don't add an item twice (e.g., freeform queries. */
        IF LOOKUP(list_item, name_list, delim) = 0 THEN
            ASSIGN name_list = name_list + delim + list_item.
  END.
  /* Trim any leading/trailing spaces and delimiter chars. */
  ASSIGN name_list = TRIM(TRIM(name_list), delim).

  ASSIGN m_PickList  = "" 
         m_PickList:DELIMITER IN FRAME f_pick  = delim
         m_PickList:LIST-ITEMS IN FRAME f_pick = name_list
         m_PickList  = (IF wname:NUM-ITEMS IN FRAME f_edit > 0
                        THEN wname:ENTRY(1) IN FRAME f_edit
                        ELSE m_PickList:ENTRY(1) IN FRAME f_pick) .

  ASSIGN pList = m_PickList:LIST-ITEMS IN FRAME f_pick
         pItem = m_PickList.

  RETURN.

END PROCEDURE.

PROCEDURE InsertPreProcName.
  /*-------------------------------------------------------------------------
    Purpose:    Insert UIB Preprocessor name into the section editor.
    Run Syntax: RUN InsertPreProcName.
    Parameters:     
  ---------------------------------------------------------------------------*/

  RUN call_coderefs IN _h_uib (INPUT "displayTab:Preprocessor":u).
    
  RETURN.
END PROCEDURE.

PROCEDURE doInsertPreProcName.

  DEFINE INPUT PARAMETER pString AS CHARACTER NO-UNDO.
  
  /* Paste non-empty pString into the buffer, with appropriate preprocessor
     headings.  */
  IF TRIM(pString) <> "" AND pString <> ? THEN
  DO:
    /* Was this a User List? If so, strip off the "1. ". */
    IF SUBSTRING(pString, 2, 1, "CHARACTER":U) = ".":U THEN
      pString = ENTRY(2, pString, " ":U).  /* "2. MyLst" becomes "MyLst" */
    /* The DEFINED(UIB_is_Running) is a special case */
    IF pString <> "DEFINED(UIB_is_Running) NE 0" THEN
      pString = "~{&":U + pString + "}":U.
    RUN paste_txt (pString).
  END.
  APPLY "ENTRY":U TO txt IN FRAME f_edit.

END PROCEDURE.

PROCEDURE getPreProcNameList.

  DEFINE OUTPUT PARAMETER pList AS CHARACTER NO-UNDO. /* Preproc List */
  DEFINE OUTPUT PARAMETER pItem AS CHARACTER NO-UNDO. /* Item to Select */

  DEFINE VAR i          AS INTEGER NO-UNDO.
  DEFINE VAR user_lists AS CHAR NO-UNDO.

  /* This line checks the compile time preprocessor variables to ensure
     that all the user defined lists are in the Insert 4GL/List items. 
     If the preprocessor name is "wrong", this line will catch it and
     someone who compiles this file will see the bug.   The code below
     assumes that there are no more than 9 items. */
  &IF {&MaxUserLists} > 9 &THEN
  &MESSAGE [_seprocs.i] *** FIX NOW *** Code can't handle more than 9 User Lists (wood)
  &ENDIF
  /* Get a list of User-Lists (prefaced with numbers, eg. '1. List-1') */
  FIND _P WHERE _P._u-recid eq win_recid NO-ERROR.
  IF NOT AVAILABLE _P THEN
  DO:
    ASSIGN pList = "":u
           pItem = "":u.
    RETURN.
  END.
  
  DO i = 1 to {&MaxUserLists}:
    user_lists = user_lists + STRING(i) + ". ":U + ENTRY(i,_P._LISTS) + ",":U.
  END.
  
/* Note: SELF-NAME has a valid value only in a trigger section, but
   we display it for all sections any way. Changed to do this in 9.1A. -jep */
  
  ASSIGN FRAME f_pick:TITLE = "Preprocessor Names"
         m_PickList:HIDDEN = TRUE /* Hide other picklist */
         s_PickList ="" 
         s_PickList:list-items IN FRAME f_pick = user_lists +
"ADM-CONTAINER~
,ADM-SUPPORTED-LINKS~
,BROWSE-NAME~
,DEFINED(UIB_is_Running) NE 0~
,DISPLAYED-FIELDS~
,DISPLAYED-OBJECTS~
,ENABLED-FIELDS~
,ENABLED-FIELDS-IN-QUERY-~{&BROWSE-NAME}~
,ENABLED-FIELDS-IN-QUERY-~{&FRAME-NAME}~
,ENABLED-OBJECTS~
,ENABLED-TABLES~
,ENABLED-TABLES-IN-QUERY-~{&BROWSE-NAME}~
,ENABLED-TABLES-IN-QUERY-~{&FRAME-NAME}~
,EXTERNAL-TABLES~
,FIELDS-IN-QUERY-~{&BROWSE-NAME}~
,FIELDS-IN-QUERY-~{&FRAME-NAME}~
,FILE-NAME~
,FIRST-ENABLED-TABLE~
,FIRST-ENABLED-TABLE-IN-QUERY-~{&BROWSE-NAME}~
,FIRST-ENABLED-TABLE-IN-QUERY-~{&FRAME-NAME}~
,FIRST-ENABLED-TABLE-IN-QUERY-~{&QUERY-NAME}~
,FIRST-EXTERNAL-TABLE~
,FIRST-TABLE-IN-QUERY-~{&BROWSE-NAME}~
,FIRST-TABLE-IN-QUERY-~{&FRAME-NAME}~
,FIRST-TABLE-IN-QUERY-~{&QUERY-NAME}~
,FRAME-NAME~
,INTERNAL-TABLES~
,LAYOUT-VARIABLE~
,LINE-NUMBER~
,NEW~
,OPEN-BROWSERS-IN-QUERY-~{&FRAME-NAME}~
,OPEN-QUERY-~{&BROWSE-NAME}~
,OPEN-QUERY-~{&FRAME-NAME}~
,OPEN-QUERY-~{&QUERY-NAME}~
,OPSYS~
,PROCEDURE-TYPE~
,QUERY-NAME~
,SELF-NAME~
,SECOND-ENABLED-TABLE~
,SECOND-ENABLED-TABLE-IN-QUERY-~{&BROWSE-NAME}~
,SECOND-ENABLED-TABLE-IN-QUERY-~{&FRAME-NAME}~
,SECOND-ENABLED-TABLE-IN-QUERY-~{&QUERY-NAME}~
,SECOND-EXTERNAL-TABLE~
,SEQUENCE~
,TABLES-IN-QUERY-~{&BROWSE-NAME}~
,TABLES-IN-QUERY-~{&FRAME-NAME}~
,TABLES-IN-QUERY-~{&QUERY-NAME}~
,THIRD-ENABLED-TABLE~
,THIRD-ENABLED-TABLE-IN-QUERY-~{&BROWSE-NAME}~
,THIRD-ENABLED-TABLE-IN-QUERY-~{&FRAME-NAME}~
,THIRD-ENABLED-TABLE-IN-QUERY-~{&QUERY-NAME}~
,THIRD-EXTERNAL-TABLE~
,UIB_is_Running~
,WINDOW-NAME~
,WINDOW-SYSTEM":U.

  ASSIGN s_PickList = s_PickList:list-items IN FRAME f_pick.

  ASSIGN pList = s_PickList
         pItem = "FRAME-NAME":U.

  RETURN.

END PROCEDURE.

PROCEDURE InsertProcName.
  /*-------------------------------------------------------------------------
    Purpose:    Insert Procedure Call into the section editor.
    Run Syntax: RUN InsertProcName.
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE BUFFER x_U   FOR _U.     /* Universal Object table.  */
  DEFINE BUFFER x_S   FOR _S.     /* SmartObject table.       */  
  DEFINE BUFFER x_TRG FOR _TRG.   /* Trigger table.           */  

  DEFINE VAR Methods_List   AS CHARACTER NO-UNDO .
  DEFINE VAR Smart_List     AS CHARACTER NO-UNDO .
  DEFINE VAR Funcs_List     AS CHARACTER NO-UNDO .
  DEFINE VAR Objects        AS CHARACTER NO-UNDO .
  DEFINE VAR This_Methods   AS CHARACTER NO-UNDO .
  DEFINE VAR This_Funcs     AS CHARACTER NO-UNDO .
  DEFINE VAR Command        AS CHARACTER NO-UNDO .
  DEFINE VAR Return_Value   AS CHARACTER NO-UNDO .
  DEFINE VAR OK             AS LOGICAL   NO-UNDO .
  DEFINE VAR iItem          AS INTEGER   NO-UNDO .
  DEFINE VAR hSuper_Proc    AS HANDLE    NO-UNDO .
  DEFINE VAR Proc_Id        AS RECID     NO-UNDO .
  DEFINE VAR Super_Procs    AS CHARACTER NO-UNDO .
  DEFINE VAR Super_Handles  AS CHARACTER NO-UNDO .

  /* To avoid frame reparenting via the call to build_proc_list, parent the
     f_pick dialog box frame to section editor window now.
  */
  IF NOT VALID-HANDLE( FRAME f_Pick:PARENT ) THEN
    ASSIGN FRAME f_Pick:PARENT = h_sewin.

  ASSIGN FRAME f_pick:TITLE = "Procedure Names"
         m_PickList:HIDDEN IN FRAME f_Pick = TRUE. /* Hide other picklist */

  /* Fill the list of procedures and select the first value. */
  RUN build_proc_list (INPUT s_PickList:HANDLE IN FRAME f_pick) .

  IF VALID-HANDLE( _h_mlmgr ) THEN
      RUN get-saved-methods IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
                                          INPUT-OUTPUT Methods_List   ,
                                          INPUT-OUTPUT Smart_List ).
  ASSIGN dummy        = s_PickList:ADD-LAST(Methods_List) IN FRAME f_Pick
         s_PickList   = s_PickList:ENTRY(1) IN FRAME f_Pick.
         
  ASSIGN This_Methods = s_PickList:LIST-ITEMS IN FRAME f_Pick
         Objects      = "THIS-PROCEDURE 0"
         Proc_Id      = RECID(_P)
         . 

  IF s_PickList:LIST-ITEMS IN FRAME f_pick = ? THEN
    ASSIGN This_Methods = ""
           s_PickList:LIST-ITEMS IN FRAME f_pick = This_Methods.

  /* Fill the list of functions and select the first value. */
  RUN build_func_list (INPUT s_PickList:HANDLE IN FRAME f_pick) .

  IF VALID-HANDLE( _h_mlmgr ) THEN
      RUN get-saved-funcs IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
                                        INPUT-OUTPUT Funcs_List   ,
                                        INPUT-OUTPUT Funcs_List ).
  ASSIGN dummy        = s_PickList:ADD-LAST(Funcs_List) IN FRAME f_Pick
         s_PickList   = s_PickList:ENTRY(1) IN FRAME f_Pick.
         
  ASSIGN This_Funcs = s_PickList:LIST-ITEMS IN FRAME f_Pick
         . /* END ASSIGN */

  IF s_PickList:LIST-ITEMS IN FRAME f_pick = ? THEN
    ASSIGN This_Funcs = ""
           s_PickList:LIST-ITEMS IN FRAME f_pick = This_Funcs.

  /* Build a comma list of active SmartObjects in this container. */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND x_U._TYPE = "SmartObject":U
                 AND x_U._STATUS <> "DELETED":U NO-LOCK,
           x_S WHERE RECID(x_S) = x_U._X-RECID NO-LOCK:
    IF NOT VALID-HANDLE( x_S._HANDLE) THEN NEXT.
    ASSIGN Objects = Objects + "," + x_U._NAME + " " + STRING(x_S._HANDLE).
  END.        

  /* Build a list of the object's Super Procedures and add them
     to the Objects list. */
  RUN get-super-procedures IN _h_mlmgr ( INPUT STRING(_SEW._hwin) ,
                                         INPUT-OUTPUT Super_Procs ,
                                         INPUT-OUTPUT Super_Handles).
  DO iItem = 1 TO NUM-ENTRIES(Super_Handles):
    ASSIGN hSuper_Proc = WIDGET-HANDLE(ENTRY(iItem, Super_Handles )).
    IF NOT VALID-HANDLE(hSuper_Proc) THEN NEXT.
    ASSIGN Objects = Objects + "," + hSuper_Proc:FILE-NAME + " " + STRING(hSuper_Proc).
  END.

  RUN adeuib/_inscall.w
      (INPUT  Objects ,
       INPUT  This_Methods ,
       INPUT  This_Funcs   ,
       INPUT  Super_Handles,
       INPUT  Proc_Id,
       OUTPUT Command      ,
       OUTPUT Return_Value ,
       OUTPUT OK           ) .

  IF (OK = TRUE) THEN
  DO:
    IF (Command = "_INSERT") THEN
        RUN paste_txt (Return_Value).
    ELSE DO:   /* Command = "_LOCAL" */     
      RUN ChangeSection ( INPUT Procedures ).

      ASSIGN se_section = Type_Procedure.
             
      /* If the local procedure does not exist, create it. Otherwise,
         we'll just go to it. */
      IF se_event:LOOKUP(Return_Value) IN FRAME f_edit = 0 THEN
      DO:
        IF (NOT AVAILABLE _P) THEN
          FIND _P WHERE _P._u-recid = win_recid NO-ERROR.
        CREATE _SEW_TRG.
        ASSIGN _SEW_TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
               _SEW_TRG._tSECTION = se_section
               _SEW_TRG._tSPECIAL = ?
               _SEW_TRG._wRECID   = _SEW-recid
               _SEW_TRG._tEVENT   = Return_Value
               _SEW_TRG._tCODE    = ?
               . /* END ASSIGN */
        IF VALID-HANDLE( _h_mlmgr ) THEN 
          RUN get-local-template IN _h_mlmgr
              ( INPUT  Return_Value , OUTPUT _SEW_TRG._tCODE ).
      END.
            
      /* Change to the new event... */
      RUN change_trg
         (se_section, _SEW-recid, Return_Value, yes, yes, OUTPUT ok).
    END.  
    
  END.

  APPLY "ENTRY" TO txt IN FRAME f_edit.

END PROCEDURE.


PROCEDURE InsertDBFields.
  /*-------------------------------------------------------------------------
    Purpose:    Insert DB Field Names into the section editor.
    Run Syntax: RUN InsertDBFields.
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE VAR i             AS INTEGER      NO-UNDO.
  DEFINE VAR pressed_ok    AS LOGICAL      NO-UNDO.
  DEFINE VAR Schema_Flds   AS CHAR         NO-UNDO.
  DEFINE VAR tt-info       AS CHAR         NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.
  
  IF AVAILABLE _SEW_U THEN DO:
    ASSIGN _SEW-recid = RECID(_SEW_U).
    FIND _P WHERE _P._WINDOW-HANDLE = _SEW_U._WINDOW-HANDLE.
  END.
  ELSE DO:
    ASSIGN _SEW-recid = RECID(_SEW_BC).
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
    FIND _P WHERE _P._WINDOW-HANDLE = x_U._WINDOW-HANDLE.
  END.
  
  /* Omit D and W types-- those are used to track temp-table info for
     SmartDataViewer and Web-Objects by AB and not meant to be exposed to
     user here. jep-code 4/22/98 */
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                          AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE)) THEN
  DO:
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P)
                   AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE):
      tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
    END.
    tt-info = LEFT-TRIM(tt-info,",":U).
  END.
  ELSE tt-info = ?.

  RUN adecomm/_fldsel.p
    ( INPUT TRUE /* p_Multi */ ,
      INPUT ?    /* data type */ ,
      INPUT tt-info ,
      INPUT-OUTPUT Schema_Prefix ,
      INPUT-OUTPUT Schema_Database ,
      INPUT-OUTPUT Schema_Table ,
      INPUT-OUTPUT Schema_Flds ,
      OUTPUT pressed_ok )   NO-ERROR.
 /* Remove database references for temp-table databases */
 IF Schema_Prefix = 2 THEN DO:
   DO i = 1 TO NUM-ENTRIES(_tt_log_name):
     Schema_Flds = REPLACE(Schema_Flds, ENTRY(i, _tt_log_name) + ".":U, "":U).
   END.  /* Do for each temp-table database name */
 END.  /* Replace temp-table databases */
 
 /* Paste a space-delimited list of chosen fields */
 IF pressed_ok THEN RUN paste_txt (REPLACE (Schema_Flds, ",", " ")).
  APPLY "ENTRY" TO txt IN FRAME f_edit.
 
END PROCEDURE.


PROCEDURE InsertQuery.
  /*-------------------------------------------------------------------------
    Purpose:    Insert Query into the section editor.
    Run Syntax: RUN InsertQuery.
    Parameters:     
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE v_TblNum AS INTEGER NO-UNDO.
  DEFINE VARIABLE lDummy   AS LOGICAL NO-UNDO.
  DEFINE BUFFER x_U FOR _U.

  /* Make sure there is at least one database connected (and that
     DICTDB is defined). */
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to insert a query.",
      OUTPUT lDummy).
    if lDummy eq no THEN RETURN.
  END.
  /* Now check for DICTDB - it is ? if it is not defined. */
  IF LDBNAME("DICTDB":U) eq ? 
  THEN CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(1)).

  ASSIGN _4GLQury  = ""
         _TblList  = ""
         _FldList  = ""
         _OrdList  = "".

  DO v_TblNum = 1 to EXTENT (_Where):
    ASSIGN
      _JoinCode[v_TblNum] = ""
      _Where[v_TblNum]    = "".
  END.
  
  IF AVAILABLE _SEW_U THEN DO:
    ASSIGN _SEW-recid = RECID(_SEW_U).
    FIND _P WHERE _P._WINDOW-HANDLE = _SEW_U._WINDOW-HANDLE.
  END.
  ELSE DO:
    ASSIGN _SEW-recid = RECID(_SEW_BC).
    FIND x_U WHERE RECID(x_U) = _SEW_BC._x-recid.
    FIND _P WHERE _P._WINDOW-HANDLE = x_U._WINDOW-HANDLE.
  END.
  
  /* Populate _tt-tbl and _tt-fld tables if necessary */
  /* Omit D and W types-- those are used to track temp-table info for
     SmartDataViewer and Web-Objects by AB and not meant to be exposed to
     user here. jep-code 4/22/98 */
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                          AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE)) THEN
  DO:
    /* Clean out old records */
    FOR EACH _tt-tbl:
      DELETE _tt-tbl.
    END.
    FOR EACH _tt-fld:
      DELETE _tt-fld.
    END.
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P)
                   AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE):
      CREATE _tt-tbl.
      ASSIGN _tt-tbl.tt-name    = IF _TT._NAME = ? THEN _TT._LIKE-TABLE
                                                   ELSE _TT._NAME
             _tt-tbl.like-db    = _TT._LIKE-DB
             _tt-tbl.like-table = _TT._LIKE-TABLE
             _tt-tbl.table-type = _TT._TABLE-TYPE.
      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(SDBNAME(_TT._LIKE-DB)).
      /* Build the field records for this table */
      RUN adecomm/_bldfld.w (INPUT RECID(_tt-tbl), INPUT _TT._LIKE-TABLE).
    END.  /* For each _TT */
  END.  /* If there are any temp-tables for this _P */

  _FreeFormEnable = NO.
  RUN adeshar/_query.p ("",                        /* browser-name    */
                        _suppress_dbname,          /* suppress_dbname */
                        "AB":u,                    /* application     */
                        "Table,Join,Where,Sort":u, /* pcValidStates   */
                        NO,                        /* plVisitFields   */
                        _auto_check,               /* auto_check      */
                        OUTPUT lDummy ).           /* cancelled?      */
                 
  IF _4GLQury ne "" THEN RUN paste_txt ( _4GLQury ).
  APPLY "ENTRY" TO txt IN FRAME f_edit.

END PROCEDURE.

PROCEDURE PrintSection:
  /*-------------------------------------------------------------------------
    Purpose:    Print section currently displayed in editor.
    Run Syntax: RUN PrintSection.
    Parameters:     
  ---------------------------------------------------------------------------*/
  DEFINE VARIABLE lPrinted    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE code_ok     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iNumEntries AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cBaseName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSection    AS CHARACTER NO-UNDO.
  
  RUN check_store_trg (TRUE, TRUE, OUTPUT code_ok).
  
  IF _P._save-as-file NE ? THEN
    ASSIGN iNumEntries = NUM-ENTRIES(_P._save-as-file, "~\")
           cBaseName   = ENTRY(iNumEntries, _P._save-as-file, "~\").
  ELSE cBaseName = ?.
  
  CASE se_section:
    WHEN "_CUSTOM" THEN DO:
      CASE editted_event:
        WHEN "_DEFINITIONS" THEN cSection = " - Definitions".
        WHEN "_MAIN-BLOCK"  THEN cSection = " - Main Block".
      END CASE.  /* editted_event */
    END.  /* _custom */
    WHEN "_PROCEDURE" THEN cSection = " - PROCEDURE " + editted_event.
    WHEN "_FUNCTION"  THEN cSection = " - FUNCTION " + editted_event.
    WHEN "_CONTROL"   THEN DO:
      CASE editted_event:
        WHEN "OPEN_QUERY" THEN cSection = " - Freeform OPEN_QUERY".
        WHEN "DISPLAY"    THEN cSection = " - Freeform DISPLAY".
        OTHERWISE DO:
          IF NUM-ENTRIES(editted_event, ".") > 1 THEN 
            cSection = " - " + ENTRY(1, editted_event, ".") + " Pseudo Trigger".
          ELSE cSection = " - " + editted_event + " OF " + ENTRY(1, wname, "").
        END.  /* otherwise */
      END CASE.  /* editted_event */
    END.  /* _control */
  END CASE.  /* se_section */
  
  RUN adeuib/_abprint.p ( INPUT _comp_temp_file,
                          INPUT _h_win,
                          INPUT cBaseName,
                          INPUT cSection,
                          OUTPUT lPrinted ) .
  
  /* The temp file is no longer needed */
  OS-DELETE VALUE(_comp_temp_file).

  APPLY "ENTRY" TO txt IN FRAME f_edit.

END PROCEDURE.  /* Print Section */

FUNCTION GetProcFuncSection RETURNS CHARACTER
  (INPUT p_name AS CHARACTER):

  DEFINE BUFFER x_SEW_TRG FOR _SEW_TRG.
  
  FIND FIRST x_SEW_TRG WHERE x_SEW_TRG._wRECID = win_recid
                       AND   (x_SEW_TRG._tSECTION = Type_Procedure OR
                              x_SEW_TRG._tSECTION = Type_Function)
                       AND   x_SEW_TRG._tEVENT = p_name NO-ERROR.

  IF AVAILABLE x_SEW_TRG THEN
    RETURN x_SEW_TRG._tSECTION.
  ELSE
    RETURN "".
  
END FUNCTION.



