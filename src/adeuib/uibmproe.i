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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/*----------------------------------------------------------------------------

File: uibmproe.i

Description:
   The internal procedures of the main routine of the UIB.  E -> Z

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Modified:
    04/07/99  tsm  - Added support for various Intl Numeric Formats (in addition
                     to American and European) by using session set-numeric-format
                     to set format back to user's setting after setting it to 
                     American
    04/09/99  tsm  - Changed call to protools/_dblist.w (DB Connections) to call
                     run-dblist internal procedure instead which will run 
                     protools/_dblist.w persistently
    04/21/99  tsm  - Added print button to toolbar
    05/04/99  tsm  - Added support for most recently used file list 
    05/17/99  tsm  - Added support for Save All option
    06/02/99  jep  - Added Code References Window support.
    06/25/99  tsm  - Added print button to menu items that are disabled when
                     there is no file open in the AppBuilder
    06/30.99  tsm  - Changed call to mrulist.p to always use _save_file instead of
                     FILE-INFO:FULL-PATHNAME.  When a file failed to compile it
                     showed up as blank on the mru filelist.                 
    07/08/99  jep  - Added support for Editing Options menu for
                     Advanced Editing features.
    08/06/01  jep  - IZ 1508 : AppBuilder Memory Leak w/Section Editors
    08/19/01  jep  - jep-icf: Search on jep-icf changes for details.
    09/18/01  jep  - jep-icf: Display icf related status bar info with call
                     to displayStatusBarInfo. Added call for isModified to
                     determine changed status of dynamic object properties
                     in property sheet window.
    09/18/01  jep  - jep-icf: Add OpenObject_Button create for AB toolbar
                     to procedure mode-morph and enable it in enable_widgets.
    09/25/01  jep  - jep-icf: Added ICF custom files handling. Search on
                     _custom_files_savekey and _custom_files_default.
    10/02/01  jep  - IZ 1981 Saving asks for Module even if already given in New dialog
                     Fix: Saving static objects is processed in save_window now.
    10/10/01  jep-icf IZ 2101 Run button enabled when editing dynamic objects.
                     Renamed h_button_bar to _h_button_bar (new shared).
    10/12/01  jep-icf IZ 2381 Save static file always asks to save to repository.
                     Revised procedure save_window and added save_window_static
                     to handle static saves properly. Static files are now saved
                     when they are already from the repository or when they are
                     being added using AppBuilder's Add to Repository option.
    02/12/02 Ross  - Revised save_window_static to check to see if it should save
                     as dynamic (viewers and browsers only at this point) then
                     call ry/prc/rygendynp.p if it should.
-----------------------------------------------------------------------------*/
/*  =======================================================================  */
/*                        INTERNAL PROCEDURE Definitions                     */
/*  =======================================================================  */
PROCEDURE edit_preferences:
  RUN adeuib/_edtpref.w.
  
  /* The MRU filelist may need to be adjusted b/c the MRU preferences may
     have been changed by the user */
     
  RUN adeshar/_mrulist.p ("":U, "":U).
  
  Schema_Prefix = IF _suppress_dbname THEN 1 ELSE 2.
END.

/* editing_options - Editing Options dialog box. */
PROCEDURE editing_options.
    RUN ABEditingOptions (INPUT _h_menu_win, INPUT 'w':u).
END.

/* editMasterDataField - Procedure to bring up the data field master editor */
PROCEDURE editMasterDataField:
  DEFINE INPUT  PARAMETER hField AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cProcType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProcHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hViewer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCnt           AS INTEGER    NO-UNDO.


  IF NOT VALID-HANDLE(hField) THEN RETURN.
  FIND _U WHERE _U._HANDLE = hField NO-ERROR.
  IF NOT AVAILABLE _U THEN RETURN.

  RUN launchContainer IN gshSessionManager
      (INPUT "datafieldw",
       INPUT "",
       INPUT "datafieldw",
       INPUT NO,
       INPUT "",
       INPUT "",
       INPUT "",
       INPUT "",
       INPUT ?,
       INPUT ?,
       INPUT ?,
       OUTPUT hProcHandle,
       OUTPUT cProcType).

  {get containerTarget cTargets hProcHandle}.

  /* Look for the datafield viewer and then run setParentInfo in it */
  DO iCnt = 1 TO NUM-ENTRIES(cTargets):
      ASSIGN hViewer = WIDGET-HANDLE(ENTRY(iCnt, cTargets)) NO-ERROR.
      IF VALID-HANDLE(hViewer)
      AND LOOKUP("setParentInfo":U, hViewer:INTERNAL-ENTRIES) > 0 THEN
          RUN setParentInfo IN hViewer (INPUT _U._TABLE,
                                        INPUT _U._OBJECT-NAME).
  END.



END PROCEDURE.  /* editMasterDataField */


/* enable_widgets - procedure to enable the UIB after another tool ran      */
procedure enable_widgets.
  DEFINE VAR cnt         AS INTEGER   NO-UNDO.
  DEFINE VAR h           AS WIDGET    NO-UNDO.
  DEFINE VAR h-tmp       AS WIDGET    NO-UNDO.
  DEFINE VAR i           AS INTEGER   NO-UNDO. 
  DEFINE VAR c           AS INTEGER   NO-UNDO.
  DEFINE VAR h-menubar   AS WIDGET    NO-UNDO.

  PAUSE 0 BEFORE-HIDE.
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = YES
         SESSION:DATA-ENTRY-RETURN  = NO
         /* Reenable for user input - in case user set wait state */
         ldummy                     = SESSION:SET-WAIT-STATE ("")
         _h_menu_win:SENSITIVE      = yes    
         _h_status_line:SENSITIVE   = yes /* Status bar has dbl-click actions */
         h-menubar                  = _h_menu_win:MENU-BAR  /* jep-icf: avoid static ref */
         h-menubar:SENSITIVE        = yes                   /* jep-icf: avoid static ref */
         CURRENT-WINDOW             = _h_menu_win 
         SESSION:THREE-D            = YES
         SESSION:DATE-FORMAT        = _orig_dte_fmt.

  /* Assign UIB as currently active ade tool. */
  ASSIGN h_ade_tool = _h_uib.

  /* Restore the UIB's main window */
  IF _h_menu_win:WINDOW-STATE eq WINDOW-MINIMIZED THEN _h_menu_win:WINDOW-STATE = WINDOW-NORMAL.
  
  /* View all previously hidden child windows (this includes Cue Cards,
     object palette, design windows, and attribute window). */
  cnt = NUM-ENTRIES (windows2view).
  DO i = 1 to cnt:
    ASSIGN h = WIDGET-HANDLE(ENTRY(i,windows2view))
           h:HIDDEN = no NO-ERROR.  
    IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
    DO c = 1 TO ERROR-STATUS:NUM-MESSAGES:  
      MESSAGE ERROR-STATUS:GET-MESSAGE(c) VIEW-AS ALERT-BOX ERROR.
    END.
  END.
  /* Show Property Editor window if need to. */
  RUN show_control_properties (INPUT 3).

  /* There is a frame bug where z-order changes when window is made visible.
     This causes SmartObjects on a FOLDER to move under the folder.  As a 
     workaround, force all PAGE-SOURCE objects to move to the bottom.
     To test the feature, add some SmO's on top of a SmartFolder.  Run the
     window.  When you return, the SmO's are under the SmartFolder. */
  FOR EACH _admlinks WHERE _admlinks._link-type eq "Page":U,
      EACH _U WHERE RECID(_U) eq INTEGER(_admlinks._link-source)
                AND _U._STATUS eq "NORMAL":
    ldummy = _U._HANDLE:MOVE-TO-BOTTOM().
  END.
  

  /* Hiding and viewing the current window will have turned off the
     display of all the visible marking of selected widgets.  Redisplay
     the current widget. */
  RUN display_current.
    
  DO WITH FRAME action_icons:
    /* Sensitize the UIB Main Window. */
    ASSIGN _h_button_bar[1]:SENSITIVE  = YES /* New */
           _h_button_bar[2]:SENSITIVE  = YES /* Open */
           Mode_Button:SENSITIVE       = YES WHEN VALID-HANDLE(Mode_Button)
           OpenObject_Button:SENSITIVE = YES WHEN VALID-HANDLE(OpenObject_Button)
           .
    RUN sensitize_main_window ("WIDGET,WINDOW").
    /* Reset the sensitivity of the fill-in fields */ 
    ASSIGN cur_widg_text:SENSITIVE = cur_widg_text:PRIVATE-DATA eq "y"
           cur_widg_name:SENSITIVE  = cur_widg_name:PRIVATE-DATA eq "y".
  END.  /* DO WITH FRAME action_icons */
      
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.

  /* SEW call to make SEW visible if it was before disabling UIB. */
  RUN call_sew ( INPUT "SE_VIEW" ).
    
  /* Go to _h_win or to the _h_menu_win if there is no _h_win. */
  IF _h_win = ? THEN h-tmp = _h_menu_win.
  ELSE IF _h_win:TYPE = "WINDOW" THEN h-tmp = _h_win.
  ELSE h-tmp = _h_win:PARENT. /* i.e. a UIB dialog-box */
  
  /* Ensure UIB Palette, Main and current design window are on top. */
  ASSIGN ldummy = _h_object_win:MOVE-TO-TOP() WHEN _AB_License NE 2
         ldummy = _h_menu_win:MOVE-TO-TOP()
         ldummy = h-tmp:MOVE-TO-TOP().

  /* If possbile, put focus in a widget in the design window. */  
  IF VALID-HANDLE( _h_cur_widg ) THEN
    APPLY "ENTRY":U TO _h_cur_widg. 
  ELSE
    APPLY "ENTRY":U TO h-tmp.
 
  /* If widget in current design window can't get focus, try UIB Main
     widget name or label fields. */
  IF NOT VALID-HANDLE( FOCUS ) THEN
  DO:
     IF cur_widg_name:SENSITIVE = TRUE THEN 
       APPLY "ENTRY":U TO cur_widg_name.
     ELSE
       APPLY "ENTRY":U TO cur_widg_text.
  END.

  /* Get rid user specified cursors */
  RUN setstatus ("":U, "":U).

END. /* PROCEDURE enable_widgets */

PROCEDURE endmove.
  DEFINE BUFFER parent_U    FOR _U.
  DEFINE BUFFER x_U         FOR _U.
  DEFINE BUFFER parent_L    FOR _L.
  DEFINE BUFFER sync_L      FOR _L.
  DEFINE VAR    recid-string AS CHARACTER NO-UNDO.
  

  FIND _U WHERE _U._HANDLE = SELF.
  FIND _L WHERE RECID(_L) = _U._lo-recid.

  /* Is this widget in a frame? */
  FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
  IF parent_U._TYPE eq "FRAME":U THEN DO:
    FIND _C WHERE RECID(_C) eq parent_U._x-recid.
    FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
    IF NOT parent_L._NO-LABELS AND NOT _C._SIDE-LABELS  /* If column labels...   */
    THEN RUN adeuib/_chkpos.p (INPUT SELF).         /* Check iteration & header  */
  END.

  IF RETURN-VALUE = "NO-ROOM" THEN RETURN.
  
  IF _undo-num-objects = ? THEN DO:
    _undo-num-objects = 0.
    FOR EACH x_U WHERE x_U._SELECTEDib:
      _undo-num-objects = _undo-num-objects + 1.
    END.
    CREATE _action.
    ASSIGN _undo-start-seq-num = _undo-seq-num
           _action._seq-num    = _undo-seq-num
           _action._operation  = "StartMove"
           _undo-seq-num       = _undo-seq-num + 1.
  END.

  recid-string = "".
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid =  _L._u-recid AND
                          sync_L._lo-name NE _L._lo-name AND
                          NOT sync_L._CUSTOM-POSITION:
       ASSIGN sync_L._ROW = ((SELF:ROW - 1) / _cur_row_mult) + 1
              sync_L._COL = ((SELF:COL - 1) / _cur_col_mult) + 1
              recid-string    = recid-string + STRING(RECID(sync_L)) + ",".
    END.  /* For each alternative layout */
  END.  /* If moving something in the master layout */
  ELSE _L._CUSTOM-POSITION = TRUE.   /* This is now a custom position. */
                     
  CREATE _action.
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Move"
         _action._u-recid       = RECID(_U)
         _action._window-handle = _U._WINDOW-HANDLE
         _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW)
         _action._other_Ls      = recid-string
         _undo-seq-num          = _undo-seq-num + 1
         _undo-num-objects      = _undo-num-objects - 1.

  IF _undo-num-objects < 1 THEN DO:
    CREATE _action.
    ASSIGN _action._seq-num    = _undo-seq-num
           _action._operation  = "EndMove"
           _undo-seq-num       = _undo-seq-num + 1
           _action._data       = STRING(_undo-start-seq-num)
           _undo-start-seq-num = ?
           _undo-num-objects   = ?.
    RUN UpdateUndoMenu("&Undo Move").

    /* The move operation is complete, now update the file-saved field */
    RUN adeuib/_winsave.p(_h_win, FALSE).
  END.      
    
  /* If a SmartObject has been moved, use the set-position method to
     try and move it. */
  IF _U._TYPE eq "SmartObject":U THEN DO:
    FIND _S WHERE RECID(_S) eq _U._x-recid.
    IF _S._visual THEN DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
      IF _P._adm-version < "ADM2" THEN
        RUN set-position IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
      ELSE
        RUN repositionObject IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.        
    END. /* If _S._VISUAL */
  END.

  /* Assign the new location. */
  ASSIGN _L._COL  = ((SELF:COL - 1) / _cur_col_mult) + 1
         _L._ROW  = ((SELF:ROW - 1) / _cur_row_mult) + 1.

  /* Adjusts for TTY Frames, and takes care of storing integer values for TTY. 
     Will overwrite the above assigned values when it needs to. */
  { adeuib/ttysnap.i &hSELF   = SELF       
                     &hPARENT = parent_U._HANDLE
                     &U_Type  = _U._TYPE
                     &Mode    = "MOVE"
                     }

  /* Move a fill-in's label */
  IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
    RUN adeuib/_showlbl.p (SELF).
    SELF:SELECTED = TRUE.
  END. 
  
  /* Update the Geometry in the Attribute Window, if necessary. */
  IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
  THEN RUN show-geometry IN hAttrEd NO-ERROR.

  /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_Changegeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.


END.


PROCEDURE endresize.
  DEFINE BUFFER parent_U    FOR _U.
  DEFINE BUFFER parent_L    FOR _L.
  DEFINE BUFFER x_U    FOR _U.
  DEFINE BUFFER x_L    FOR _L.
  DEFINE BUFFER sync_L FOR _L.
  DEFINE VARIABLE frame_rec    AS RECID                                  NO-UNDO.
  DEFINE VARIABLE fg_handle    AS WIDGET-HANDLE                          NO-UNDO.
  DEFINE VARIABLE recid-string AS CHAR                                   NO-UNDO. 
  
  FIND _U WHERE _U._HANDLE = SELF.
  FIND _L WHERE RECID(_L)  = _U._lo-recid.

  /* Have we resized a widget in a column-label frame? */
  /* First see if the widget is in a frame. */
  FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
  IF parent_U._TYPE eq "FRAME":U THEN DO:
    FIND _C WHERE RECID(_C) eq parent_U._x-recid.
    FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
    IF NOT parent_L._NO-LABELS AND NOT _C._SIDE-LABELS   /* If column labels ...  */
    THEN DO:
      RUN adeuib/_chkpos.p (INPUT SELF).              /* Check iteration & header  */
      IF RETURN-VALUE = "NO-ROOM" THEN RETURN.        
    END.
  END.
  
  /* Are we resizing a frame? */
  IF _U._TYPE eq "FRAME":U THEN DO: 
    FIND x_U WHERE x_U._HANDLE = SELF.         /* See if all children fit   */
    FIND _C WHERE RECID(_C) eq x_U._x-recid.
    FIND x_L WHERE RECID(x_L) eq x_U._lo-recid.
    frame_rec = RECID(x_U).
    IF NOT x_L._NO-LABELS AND NOT _C._SIDE-LABELS   /* If column labels          */
    THEN DO:
      FOR EACH x_U WHERE x_U._PARENT-RECID = frame_rec AND
                         NOT x_U._NAME BEGINS "_LBL":
        RUN adeuib/_chkpos.p (INPUT x_U._HANDLE).
        IF RETURN-VALUE = "NO-ROOM" THEN RETURN.
      END.  /* For each child widget                                        */
    END.  /* A down frame with labels - make sure everything fits           */
  END.  /*  A frame has been resized                                        */
  
  CREATE _action.
  ASSIGN _undo-start-seq-num = _undo-seq-num
         _action._seq-num    = _undo-seq-num
         _action._operation  = "StartResize"
         _undo-seq-num       = _undo-seq-num + 1.

  recid-string = "".
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid  = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME AND
                          NOT sync_L._CUSTOM-SIZE:
      recid-string = recid-string + STRING(RECID(sync_L)) + ",".
    END.
  END.  /* If changing the Master Layout */
  ELSE _L._CUSTOM-SIZE = TRUE.
  
  CREATE _action.
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Resize"
         _action._u-recid       = RECID(_U)
         _action._window-handle = _U._WINDOW-HANDLE
         _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW) + "|":U +
                    STRING(_L._WIDTH) + "|":U + STRING(_L._HEIGHT)
         _action._other_Ls      = recid-string                   
         _undo-seq-num          = _undo-seq-num + 1.

  CREATE _action.
  ASSIGN _action._seq-num = _undo-seq-num
         _action._operation = "EndResize"
         _undo-seq-num = _undo-seq-num + 1
         _action._data = STRING(_undo-start-seq-num)
         _undo-start-seq-num = ?.
  RUN UpdateUndoMenu("&Undo Resize").

  /* Setting size can cause a variety of errors... trap these explicitly. */
  Size-Block:
  DO ON ERROR UNDO Size-Block, LEAVE Size-Block 
     ON STOP  UNDO Size-Block, LEAVE Size-Block:
    /* Handle TTY mode for all objects. */
    IF (_L._WIN-TYPE eq NO) 
    THEN DO:
      SELF:HIDDEN = TRUE.
      /* Make sure TTY mode heights are 1 row high                              */
      IF CAN-DO("BROWSE,BUTTON,TEXT,FILL-IN,COMBO-BOX,TOGGLE-BOX":U,_U._TYPE) THEN
        ASSIGN SELF:HEIGHT  = _L._ROW-MULT
               _L._HEIGHT = 1
               _L._WIDTH  = SELF:WIDTH / _L._COL-MULT.
      ELSE IF _U._TYPE eq "SLIDER" THEN DO:
        fg_handle = SELF:PARENT.
        IF SELF:HORIZONTAL THEN DO:
          IF (SELF:ROW - 1) + 2 * _L._ROW-MULT > fg_handle:HEIGHT THEN
            SELF:ROW = (fg_handle:HEIGHT - 2 * _L._ROW-MULT) + 1.          
          ASSIGN SELF:HEIGHT = 2 * _L._ROW-MULT
                 _L._HEIGHT  = 2
                 _L._WIDTH   = INTEGER(SELF:WIDTH / _L._COL-MULT).
        END. /* HORIZONTAL */
        ELSE DO:
          IF (SELF:COLUMN - 1) + 9 * _cur_col_mult > fg_handle:WIDTH THEN
            SELF:COLUMN = (fg_handle:WIDTH - 9 * _L._COL-MULT) + 1.
          ASSIGN SELF:WIDTH = MAX(SELF:WIDTH, 9 * _L._COL-MULT)
                  _L._WIDTH = INTEGER(SELF:WIDTH-CHARS / _L._COL-MULT).
        END. /* Not HORIZONTAL */  
      END. /* A SLider */   
      ELSE IF _U._TYPE eq "SmartObject":U THEN DO:
      RUN adeuib/_setsize.p (RECID(_U), INTEGER(SELF:HEIGHT / _L._ROW-MULT),
                                        INTEGER(SELF:WIDTH  / _L._COL-MULT)).
      END.
      IF CAN-DO("BUTTON,COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
        IF _U._SUBTYPE NE "TEXT" THEN RUN adeuib/_sim_lbl.p (SELF).
      END. /* A Button */
      ASSIGN SELF:HIDDEN   = FALSE
             SELF:SELECTED = _U._SELECTEDib.
    END. /* IF TTY MODE */
    
    /* If a SmartObject has been resized.  Make sure that the widget knows about
       the new size (so that it can respond to the size change).   We do this 
       by sending the Object the "set-size" method. This is done inside
       the "_setsize.p" which also handles sizing our visualization.
       (Note that a RESIZE can also change an object's position, 
        so call set-position as well.) */
    ELSE IF _U._TYPE eq "SmartObject":U THEN DO:
      RUN adeuib/_setsize.p (RECID(_U), SELF:HEIGHT / _L._ROW-MULT,
                                        SELF:WIDTH  / _L._COL-MULT).
      FIND _S WHERE RECID(_S) eq _U._x-recid.
      IF _S._visual THEN DO: 
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
        IF _P._adm-version < "ADM2" THEN
          RUN set-position IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
        ELSE
          RUN repositionObject IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
      END.  /* If _S._VISUAL */
    END. /* IF..."SmartObject"... */

    ELSE IF _U._TYPE = "IMAGE":U THEN DO:
      FIND _F WHERE RECID(_F) = _U._x-recid.
      IF _F._IMAGE-FILE NE "" THEN _U._HANDLE:LOAD-IMAGE(_F._IMAGE-FILE).    
    END.  /* If an end-resize of an image */
      
    /* The resize operation is complete, now update the file-saved field */
    RUN adeuib/_winsave.p(_h_win, FALSE).
  
    /* Assign the new size and position (NOTE if you resize the top left, you
       change the position as well as size )*/
    IF _U._TYPE = "FRAME" AND NOT _L._WIN-TYPE THEN DO:
      /* Update the Universal widget's H,W, Row, and Col and adjust for TTY Frame. 
        We also update the _U pixels information as well (X,Y,H-P,W-P) and
        store tty values as integers. Overwrites above assigned values
        when needed for frames */
    { adeuib/ttysnap.i &hSELF   = SELF       
                       &hPARENT = parent_U._HANDLE
                       &U_Type  = _U._TYPE
                       &Mode    = "RESIZE" 
                       }
    END.
    ELSE ASSIGN _L._COL      = ((SELF:COL - 1) / _L._COL-MULT) + 1
                _L._ROW      = ((SELF:ROW - 1) / _L._ROW-MULT) + 1
                _L._HEIGHT   = SELF:HEIGHT-CHARS / _L._ROW-MULT
                _L._WIDTH    = SELF:WIDTH-CHARS / _L._COL-MULT.
     
    IF _U._TYPE = "FRAME" THEN DO:
      IF NOT _C._SCROLLABLE THEN
         ASSIGN _L._VIRTUAL-WIDTH  = _L._WIDTH
                _L._VIRTUAL-HEIGHT = _L._HEIGHT.
      ELSE ASSIGN _L._VIRTUAL-WIDTH  = SELF:VIRTUAL-WIDTH
                  _L._VIRTUAL-HEIGHT = SELF:VIRTUAL-HEIGHT.
    END. /* A Frame */
           
    IF recid-string NE "" THEN DO i = 1 TO NUM-ENTRIES(recid-string) - 1:
      FIND sync_L WHERE RECID(sync_L) = INTEGER(ENTRY(i,recid-string)).
      ASSIGN sync_L._COL    = _L._COL
             sync_L._ROW    = _L._ROW
             sync_L._HEIGHT = _L._HEIGHT
             sync_L._WIDTH  = _L._WIDTH.
      IF _U._TYPE = "FRAME" THEN DO:
        IF NOT _C._SCROLLABLE THEN
          ASSIGN sync_L._VIRTUAL-WIDTH  = _L._WIDTH
                 sync_L._VIRTUAL-HEIGHT = _L._HEIGHT.
      END. /* A Frame */
    END. /* DO  1 to num-entries */
             
    /* Move a fill-in's label */
    IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
      RUN adeuib/_showlbl.p (SELF).
      SELF:SELECTED = TRUE.
    END. /* Fill-in or combo-box */
             
    /* Do our own redraw for editor in tty-mode */
    IF (NOT _L._WIN-TYPE AND _U._TYPE = "Editor") THEN DO:
      FIND _F WHERE RECID(_F) = _U._x-recid.
      RUN adeuib/_ttyedit.p (_U._HANDLE, _F._SCROLLBAR-H, _U._SCROLLBAR-V).
      IF _F._INITIAL-DATA NE "" THEN
        _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.
    END.  /* Editor in TTY Mode */
  END. /* Size-Block: DO:... */

  /* Check to see if this is a "LIKE" variable so we can set SIZE-SOURCE
     to Explicit                                                          */
  FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
  IF AVAILABLE (_F) AND _F._DISPOSITION = "LIKE":U THEN
    _F._SIZE-SOURCE = "E":U.
  
  /* Update the Geometry in the Attribute Window, if necessary. */
  IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
  THEN RUN show-geometry IN hAttrEd NO-ERROR.

  /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_Changegeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.

END.  /* endresize */


PROCEDURE Even-l-to-r.  /* Evenly space widgets from left to right */
  RUN adeuib/_align.p ("E-l-to-r", ?).
END PROCEDURE.  /* Even-l-to-r */


PROCEDURE Even-t-to-b.  /* Even spacing from top to bottom */
  RUN adeuib/_align.p (?, "E-t-to-b").
END PROCEDURE.  /* Even-t-to-b */

PROCEDURE exit_proc:
  APPLY "WINDOW-CLOSE":U TO _h_menu_win.
END PROCEDURE.  /* exit_proc */

/* frame-select-up  - short tag to run this on frame select up.            */
/*             This is run for both FRAMES and DIALOG-BOXES.               */
/*             Look at the function and decide what to do.  This routine   */
/*        This routine lets us click respond differently toframe      */
/*             events which are all triggered by a MOUSE-SELECT-UP         */
/*             We also call this with MOUSE-EXTEND-UP, because it uses the */
/*             same mouse button in MS-WINDOWS (Ctrl-SELECT == EXTEND)     */
procedure frame-select-up.
  DEFINE BUFFER frame_U FOR _U.
  DEFINE BUFFER ipU FOR _U.
  
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("frame-select-up"). &ENDIF
  CASE LAST-EVENT:FUNCTION :
    WHEN "" OR WHEN "MOUSE-SELECT-CLICK" OR WHEN "MOUSE-EXTEND-CLICK" THEN 
      run drawobj-or-select.
    WHEN "MOUSE-SELECT-DBLCLICK" THEN RUN double-click.
    WHEN "END-BOX-SELECTION" THEN DO:
      IF _next_draw ne ? THEN RUN drawobj-in-box. 
      ELSE DO:
        /* Box-selecting is over. Redisplay the current widget. */
        box-selecting = no.
    
        /* If nothing is selected in the frame, then the current widget has been set
           to the window, but this has not been displayed.  (display_current did not
           actually display the widget because we wanted to avoid flashing).  If this
           is the case, then we need to actually display the current selection.  If
           something was selected, then we want to show the selection. */
        FIND frame_U WHERE frame_U._HANDLE eq SELF.
        FIND FIRST _U WHERE _U._SELECTEDib 
                        AND _U._parent-recid eq RECID(frame_U) NO-ERROR.
        IF AVAILABLE _U THEN DO: 
          /* Is there anything selected in any other window? If so, deselect it. */     
          IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                                   AND ipU._WINDOW-HANDLE ne _U._WINDOW-HANDLE) 
          THEN RUN deselect_all (SELF, _U._WINDOW-HANDLE).
                                                              
          /* Are there still two things selected?  If so, don't show a single
             current widget. */
          IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib 
                                   AND ipU._HANDLE ne _U._HANDLE)
          THEN _h_cur_widg = ?.
          ELSE RUN changewidg (_U._HANDLE, no).
        END.   
        /* If there is a new widget selected then display the values.
           Even if no new widget is selected, the number of widgets selected
           may have changed, so we still want to sensitize the buttons in
           the window. */
        IF h_display_widg ne _h_cur_widg THEN RUN display_current.
        ELSE DO:
          /* Show the current values of the selected set of widgets in the 
             Attributes window. (Note: This was done in "display_current.) */
          IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
          THEN RUN show-attributes IN hAttrEd NO-ERROR.
          RUN show_control_properties (INPUT 0).
          /* Update the main window. */
          RUN sensitize_main_window ("WIDGET").    
        END. 
      END.
    END. /* when end-box-selection... */   
  END CASE.
END PROCEDURE.

/* frame-startboxselect  - Change the cursor in the current window to the    */
/*                         end-draw value if we are drawing.  If we are      */
/*                         actually marking, note that we don't need to      */
/*                         redisplay the selection.                          */
procedure frame-startboxselect.
  if _next_draw <> ? THEN
    ASSIGN ldummy = _h_win:MOVE-TO-TOP()
           ldummy = _h_win:LOAD-MOUSE-POINTER({&end_draw_cursor}). 
  ELSE box-selecting = YES.
END.

/* get-attribute  - Return some internal attribute of the UIB (as the RETURN-
 * VALUE.  For example, return the handle of the Section Editor. 
 */
procedure get-attribute :
  define input parameter p_name as char no-undo.
  
  CASE p_name:
    WHEN "Section-Editor-Handle"   THEN RETURN STRING(hSecEd).
    WHEN "Attribute-Window-Handle" OR WHEN "Group-Properties-Window-Handle" 
    THEN DO:
      /* Watch out -- the attribute window could have been deleted and the
         procedure handle reused.  Check for this case. */
      IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME ne "{&AttrEd}"
      THEN hAttrEd = ?.
      RETURN STRING(hAttrEd).
    END.
  END CASE.

END.

/* Load another custom object file */
PROCEDURE get_custom_widget_defs : 
  DEFINE VARIABLE rc       AS LOGICAL NO-UNDO. /* return code yes=ok no=cancel */
  DEFINE VARIABLE cDynList AS CHARACTER NO-UNDO. /* Add Palette/Template to list */

  RUN setstatus ("":U, "Select custom object files...":U).
   /* If Dynamics is running and it's using the cst in the repository, send template and palette objects */
  IF CAN-DO(_AB_Tools,"Enable-ICF") AND _dyn_cst_template > "" AND _dyn_cst_palette > "" THEN
  DO:
     ASSIGN cDynList = "~~@DummyTemplates:,*************,":U +  _dyn_cst_template
            cDynList = cDynlist + ",,Palettes:,************," + _dyn_cst_palette.
     
     RUN adeuib/_getcust.w (INPUT-OUTPUT cDynlist, OUTPUT rc). /* ask for file */  
  END.
  ELSE
     RUN adeuib/_getcust.w (INPUT-OUTPUT {&CUSTOM-FILES}, OUTPUT rc). /* ask for file */
  IF NOT rc THEN DO: /* cancelled. */
    RUN setstatus("":U,"":U).
    RETURN.
  END.
  RUN  update_palette.

END.

/* GetParent - Get the parent of a Progress window (real HWND) */
PROCEDURE GetParent EXTERNAL "USER32.DLL":
   DEFINE INPUT  PARAMETER in-hwn AS LONG.
   DEFINE RETURN PARAMETER hwnd   AS LONG.
END.          

/* Check to see if there any dirty OCX controls */
PROCEDURE is_control_dirty.
  DEFINE INPUT  PARAMETER hWindow   AS WIDGET  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Dirty   AS LOGICAL NO-UNDO INITIAL FALSE.
  
  DEFINE VARIABLE s AS INTEGER NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.
  

  FOR EACH x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                AND (    x_U._WINDOW-HANDLE = hWindow 
                     AND x_U._STATUS <> "DELETED":u):
      p_Dirty = x_U._COM-HANDLE:Dirty.
      IF p_Dirty THEN LEAVE.
  END.

END.

/* Set Dirty attribute for all OCX controls. */
PROCEDURE Set_Control_Dirty.
  DEFINE INPUT  PARAMETER hWindow   AS WIDGET  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Dirty   AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE s AS INTEGER NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.

  FOR EACH x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                AND (    x_U._WINDOW-HANDLE = hWindow 
                     AND x_U._STATUS <> "DELETED":u):
      ASSIGN x_U._COM-HANDLE:Dirty = p_Dirty.
  END.

END.


/* Launch a dynamic object */
PROCEDURE launch_object.
  DEFINE INPUT  PARAMETER pRecid     AS RECID      NO-UNDO.

  DEFINE VARIABLE lMultiInstance              AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cChildDataKey               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRunAttribute               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerWindow            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerSource            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObject                     AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hRunContainer               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cRunContainerType           AS CHARACTER    NO-UNDO.

  FIND _P WHERE RECID(_P) = pRecid.

  /* Assume user wants the cache cleared, if not they need to use the 
     dynamic launcher noddy                                           */
  IF VALID-HANDLE(gshRepositoryManager) THEN
    RUN clearClientCache IN gshRepositoryManager.

  ASSIGN
    lMultiInstance    = NO
    cChildDataKey     = "":U
    cRunAttribute     = "":U
    hContainerWindow  = ?
    hContainerSource  = ?
    hObject           = ?
    hContainerWindow  = ?
    cRunContainerType = "":U
    .

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
    RUN launchContainer IN gshSessionManager
        (INPUT  _P._save-as-file     /* object filename if physical/logical names unknown */
        ,INPUT  "":U                 /* physical object name (with path and extension) if known */
        ,INPUT  _P._save-as-file     /* logical object name if applicable and known */
        ,INPUT  (NOT lMultiInstance) /* run once only flag YES/NO */
        ,INPUT  "":U                 /* instance attributes to pass to container */
        ,INPUT  cChildDataKey        /* child data key if applicable */
        ,INPUT  cRunAttribute        /* run attribute if required to post into container run */
        ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
        ,INPUT  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
        ,INPUT  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
        ,INPUT  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
        ,OUTPUT hRunContainer        /* procedure handle of object run/running */
        ,OUTPUT cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
        ).
    
    WAIT-FOR WINDOW-CLOSE, CLOSE OF hRunContainer. 

  END.  /* do on stop, on error */

  /* Choosing the stop button raises the stop condition and leaves the DO 
     block so the container that was launched needs to be closed. */
  IF VALID-HANDLE(hRunContainer) THEN APPLY "CLOSE":U TO hRunContainer.

END.  /* PROCEDURE launch_object */


/* The mode between local and remote has changed */
PROCEDURE mode_change.
  IF SELF:PRIVATE-DATA EQ "Local" THEN DO:
    /* Switching from local to remote */
    ASSIGN SELF:PRIVATE-DATA = "Remote"
           SELF:TOOLTIP      = "Switch to local development"
           _remote_file      = Yes
           SELF:VISIBLE      = NO.
    ASSIGN ldummy = SELF:LOAD-IMAGE-UP({&ADEICON-DIR} + "remote" +
                    "{&BITMAP-EXT}") NO-ERROR.
    IF ldummy ne YES or ERROR-STATUS:ERROR                
    THEN ASSIGN Stop_Button:LABEL = "Remote".
    PUT-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE("Yes":U).
  END.  /* If switching from local to remote */
  ELSE DO:  /* Switching from remote to local */
    ASSIGN SELF:PRIVATE-DATA = "Local"
           SELF:TOOLTIP      = "Switch to remote development"
           _remote_file      = No
           SELF:VISIBLE      = NO.
    ASSIGN ldummy = SELF:LOAD-IMAGE-UP({&ADEICON-DIR} + "Local" +
                    "{&BITMAP-EXT}") NO-ERROR.
    IF ldummy ne YES or ERROR-STATUS:ERROR                
    THEN ASSIGN Stop_Button:LABEL = "Local".
    PUT-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE("No":U).
  END. /* Else switch from remote to local */
  SELF:VISIBLE = YES.
END.  /* Procedure mode_change */

/* The _visual-obj variable has changed, have the tool morph */
PROCEDURE mode-morph.
  DEFINE INPUT PARAMETER mode   AS CHARACTER   NO-UNDO.
  /* Mode is one of "INIT", "UIB", or "WEB"                  */
  
  DEFINE VARIABLE ActiveWindows AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ActiveItem    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE h_menu-bar    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_sm          AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_s           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h             AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_f           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE v             AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE rh            AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_icfmenubar  AS HANDLE      NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER NO-UNDO.
  DEFINE VARIABLE AboutImage    AS CHARACTER   NO-UNDO.

  
  /* jep-icf: Check to see if we should replace the AB menubar with ICF menubar. */
  IF (mode = "INIT":U) AND CAN-DO(_AB_Tools,"Enable-ICF") THEN
  DO ON ERROR UNDO, LEAVE:
      /* Start persistent AB Menubar Procedure. */
      RUN adeuib/_abmbar.w PERSISTENT SET _h_menubar_proc.
      IF VALID-HANDLE(_h_menubar_proc) THEN
      DO:
        /* Get the handle of the menubar that replaces the AB default menubar. */
        RUN getMenubarHandle IN _h_menubar_proc (INPUT MENU m_menubar:HANDLE, OUTPUT h_icfmenubar).
        /* Replace the AB's default menu-bar with the new one. */
        ASSIGN _h_menu_win:MENU-BAR = h_icfmenubar.
        /* Display icf related status bar info. */
        RUN displayStatusbarInfo IN _h_menubar_proc.
      END.
  END.


  ASSIGN last-mode  = mode
         h_menu-bar = _h_menu_win:MENU-BAR.

  IF mode = "INIT" THEN DO: /* This is the INIT case - create necessary stuff */
  
    /* Set AppBuilder's About box image. */
    ASSIGN AboutImage = IF (_AB_License = 2) THEN "adeicon/workshp%.ico":U ELSE "adeicon/uib%.ico":U.
    ASSIGN AboutImage = "adeicon/icfdev.ico" WHEN CAN-DO(_AB_Tools, "Enable-ICF":u).

    /* jep-icf: Set handles of several AB menus and items. The menubar may be the
       default statically defined AB menubar or one that's taken it's place. So
       we must reference menus and menu items with handles instead.
       Note: If the order of the File and Edit menu's ever changes, this code will
       need updating. */
    ASSIGN m_menubar  = _h_menu_win:MENU-BAR.
    ASSIGN m_hFile    = h_menu-bar:FIRST-CHILD. /* jep-icf: File menu. */
    ASSIGN m_hEdit    = m_hFile:NEXT-SIBLING.   /* jep-icf: Edit menu. */
  
    /* jep-icf: "Open Object" Button takes the place of "Open" button and shifts all remaining buttons to the right. */
    IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
    DO:
      ASSIGN i = LOOKUP( "Open" , bar_labels).
      CREATE BUTTON OpenObject_Button
        ASSIGN FRAME        = _h_button_bar[i]:FRAME
               X            = _h_button_bar[i]:X
               Y            = _h_button_bar[i]:Y
               WIDTH-P      = _h_button_bar[i]:WIDTH-P
               HEIGHT-P     = _h_button_bar[i]:HEIGHT-P
               PRIVATE-DATA = "openobject":U
               BGCOLOR      = _h_button_bar[i]:BGCOLOR
               FONT         = _h_button_bar[i]:FONT
               TOOLTIP      = "Open Object"
               NO-FOCUS     = YES
               FLAT-BUTTON  = YES
               HIDDEN       = YES
               SENSITIVE    = FALSE
        TRIGGERS:
            ON CHOOSE PERSISTENT RUN choose_object_open IN _h_UIB.
        END TRIGGERS.

      ldummy = OpenObject_Button:LOAD-IMAGE-UP({&ADEICON-DIR} + OpenObject_Button:PRIVATE-DATA) NO-ERROR.
      
      /* Starting with the "Open" button (2), move the remaining toolbar buttons to the right. */
      DO i = 2 to bar_count:
          /* Make adjustments for buttons that have the rectangles between them. */
          IF i = 5 OR i = 8 THEN
            ASSIGN _h_button_bar[i]:X = _h_button_bar[i]:X + 30.
          ELSE
            ASSIGN _h_button_bar[i]:X = _h_button_bar[i]:X + 25.
      END.  /* DO i = 1 to bar_count */
      
      /* Adjust all the icon group rectangles for the new icf buttons. */
      ASSIGN  group1:WIDTH-P IN FRAME action_icons = group1:WIDTH-P IN FRAME action_icons + 25
              group2:WIDTH-P IN FRAME action_icons = group2:WIDTH-P IN FRAME action_icons + 25
              group3:WIDTH-P IN FRAME action_icons = group3:WIDTH-P IN FRAME action_icons + 50
              group4:WIDTH-P IN FRAME action_icons = group4:WIDTH-P IN FRAME action_icons + 50 NO-ERROR.
              
      ASSIGN OpenObject_Button:HIDDEN    = FALSE
             OpenObject_Button:SENSITIVE = YES.
      
      IF CAN-DO(_AB_Tools,"Enable-ICF") AND VALID-HANDLE(_h_menubar_proc) THEN
         RUN addPropertyButton IN _h_menubar_proc (INPUT bar_count) NO-ERROR.

    END. /* Enable-ICF */


    /* Do the visual part first */
    IF _AB_license > 1 THEN DO: /* WebSpeed is licensed then create the 
                                   mode button.                          */
 
      CREATE BUTTON Mode_Button
      ASSIGN FRAME       = FRAME action_icons:HANDLE
            X            = /*_h_status_line:X + _h_status_line:WIDTH-PIXELS -
                                              _h_button_bar[1]:WIDTH-PIXELS -
                                              SESSION:PIXELS-PER-COLUMN*/
                           IF CAN-DO(_AB_Tools,"Enable-ICF") AND VALID-HANDLE(_h_menubar_proc) 
                           THEN  _h_button_bar[10]:X + _h_button_bar[10]:WIDTH-P + 31
                           ELSE  _h_button_bar[10]:X + _h_button_bar[10]:WIDTH-P + 6
            Y            = _h_button_bar[1]:Y
            WIDTH-P      = _h_button_bar[1]:WIDTH-P
            HEIGHT-P     = _h_button_bar[1]:HEIGHT-P
            PRIVATE-DATA = "Local":U
            BGCOLOR      = _h_button_bar[1]:BGCOLOR
            FONT         = 4
            TOOLTIP      = "(Local/Remote)"
            NO-FOCUS     = YES
            FLAT-BUTTON  = YES
            HIDDEN       = YES
            SENSITIVE    = FALSE
          TRIGGERS:
            ON CHOOSE PERSISTENT RUN mode_change.
          END TRIGGERS. 
      /* Initialize the button */
      GET-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE v.
      ASSIGN _remote_file = NOT((last-mode EQ ?) OR CAN-DO ("False,no,off", v))
             Mode_Button:PRIVATE-DATA = IF _remote_file THEN "remote" ELSE "local"
             Mode_Button:TOOLTIP = IF _remote_file THEN "Switch to local development"
                                                   ELSE "Switch to remote development"
             ldummy       = Mode_Button:LOAD-IMAGE-UP({&ADEICON-DIR} + 
                            Mode_Button:PRIVATE-DATA + 
                           "{&BITMAP-EXT}") NO-ERROR.
      /* Add label in case image fails to load */
      IF ldummy ne YES or ERROR-STATUS:ERROR 
      THEN ASSIGN Mode_Button:LABEL = "Mode".

      ASSIGN Mode_button:HIDDEN    = FALSE
             Mode_button:SENSITIVE = YES.
    END.  /* If WebSpeed is licensed create the mode button */
  
    /* Create the visible menu-bar items */
    ASSIGN h           = h_menu-bar
           _visual-obj = no.
    /* _h_button_bar[10] is the color button */
    IF _AB_License = 2 THEN DO: /* WebSpeed only */
      ASSIGN _h_button_bar[10]:HIDDEN = TRUE.
      /* Reposition the last two toolbar rectangles
         and the mode button */
      ASSIGN rh = _h_button_bar[10]:FRAME
             rh = rh:FIRST-CHILD
             rh = rh:FIRST-CHILD.
      DO WHILE rh <> ?:
        IF rh:PRIVATE-DATA = "group3":U OR
           rh:PRIVATE-DATA = "group4":U THEN 
             rh:WIDTH-P = rh:WIDTH-P - _h_button_bar[10]:WIDTH-P.
        ASSIGN rh = rh:NEXT-SIBLING.
      END.
      ASSIGN Mode_Button:X = Mode_Button:X - _h_button_bar[10]:WIDTH-P.
    END.
    ELSE DO:  /* UIB is licensed */
      ASSIGN _h_button_bar[10]:HIDDEN    = FALSE
             _h_button_bar[10]:SENSITIVE = FALSE.

      /* Add Layout Menu */
      CREATE SUB-MENU m_layout ASSIGN LABEL = "&Layout" SENSITIVE = YES
                   PARENT = h.
      CREATE MENU-ITEM mi_chlayout ASSIGN LABEL = "Alternate &Layout..."
                   PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN morph_layout. END TRIGGERS.
      CREATE MENU-ITEM mi_chCustLayout ASSIGN LABEL = "Custom &Layout..."
                   PARENT = m_layout
      TRIGGERS: ON CHOOSE PERSISTENT RUN morph_layout. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                   PARENT = m_layout.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "&Center Left-to-Right in Frame"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Center-l-to-r. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Center Top-to-Bottom in &Frame"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Center-t-to-b. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                   PARENT = m_layout.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "&Even Spacing Left-to-Right"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Even-l-to-r. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Even &Spacing Top-to-Bottom"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Even-t-to-b. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                    PARENT = m_layout.
      CREATE MENU-ITEM mi_topmost ASSIGN LABEL = "Move-to-&Top"       PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN movetotop. END TRIGGERS.
      CREATE MENU-ITEM mi_bottommost ASSIGN LABEL = "Move-to-&Bottom" PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN movetobottom. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                    PARENT = m_layout.
      CREATE SUB-MENU m_align ASSIGN LABEL = "&Align"                 PARENT = m_layout.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Colons"                     PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("COLON", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN SUBTYPE = "RULE"                      PARENT = m_align.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Left Sides"                 PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("LEFT", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Horizontal Centers"         PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("CENTER", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Right Sides"                PARENT = m_align
        TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("RIGHT", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN SUBTYPE = "RULE"                      PARENT = m_align.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Top Edges"                  PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "TOP"). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Vertical Centers"           PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "CENTER"). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Bottom Edges"               PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "BOTTOM"). END TRIGGERS.
    END.  /* When UIB is licensed */
  
    h = h_menu-bar.
    /* Always add Windows and Help Menus */

    /* Windows Menu */
    CREATE SUB-MENU _h_WindowMenu ASSIGN LABEL = "&Window"                 PARENT = h.
    CREATE MENU-ITEM mi_code_edit ASSIGN LABEL = "Code &Section Editor" 
         ACCELERATOR = "Ctrl-S"                                            PARENT = _h_WindowMenu
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_codedit. END TRIGGERS.
    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_show_toolbox ASSIGN LABEL = "&Hide Object Palette"
          ACCELERATOR = "Ctrl-T"                                             PARENT = _h_WindowMenu
           TRIGGERS: ON CHOOSE PERSISTENT RUN choose_show_palette. END TRIGGERS.
    CREATE MENU-ITEM mi_attributes ASSIGN LABEL = "&Properties Window"
         ACCELERATOR = "Ctrl-P"                                            PARENT = _h_WindowMenu
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_attributes. END TRIGGERS.
    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_control_props ASSIGN LABEL = "&OCX Property Editor"
                                                                           PARENT = _h_WindowMenu
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_control_props. END TRIGGERS.
    /* Check whether Dynamics is Running */
    IF CAN-DO(_AB_Tools, "Enable-ICF":u) AND VALID-HANDLE(_h_menubar_proc) THEN
       RUN AddPropertyMenu IN _h_menubar_proc NO-ERROR.
      

    /* Help Menu */
    CREATE SUB-MENU h_sm ASSIGN LABEL = "&Help"                            PARENT = h.
    CREATE MENU-ITEM mi_contents ASSIGN LABEL = "&Help Topics"             PARENT = h_sm
         TRIGGERS: ON CHOOSE
          PERSISTENT RUN adecomm/_adehelp.p ("AB", "TOPICS", {&Main_Contents}, ? ).
       END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_messages ASSIGN LABEL = "M&essages..."             PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN prohelp/_msgs.p. END TRIGGERS.
    CREATE MENU-ITEM mi_recent ASSIGN LABEL = "&Recent Messages..."         PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN prohelp/_rcntmsg.p. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_cuecards ASSIGN LABEL = "&Cue Cards..."            PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_cuelist.w. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_about ASSIGN LABEL = "&About AppBuilder"           PARENT = h_sm
       TRIGGERS: ON CHOOSE
          PERSISTENT RUN adecomm/_about.p 
                   ("{&UIB_NAME}", AboutImage).
       END TRIGGERS.
     
    /* Now go back and fill in non-visible stuff */

    /* Edit Menu */
    ASSIGN h_sm = h:FIRST-CHILD
           h_sm = h_sm:NEXT-SIBLING.  /* Edit Menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM mi_duplicate ASSIGN LABEL = "&Duplicate" SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_duplicate. END TRIGGERS.
    END.  /* IF UIB is licensed */
  
    /* Always do this */
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_erase ASSIGN LABEL = "De&lete"                     PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_erase. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_export ASSIGN LABEL = "Copy to &File..."           PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_export_file. END TRIGGERS.
    CREATE MENU-ITEM mi_import ASSIGN LABEL = "&Insert from File..."       PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_import_file. END TRIGGERS.

    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_tab_edit ASSIGN LABEL = "T&ab Order..." SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_tab_edit. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_goto_page ASSIGN LABEL = "&Goto Page..."
               SENSITIVE = FALSE      PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_goto_page. END TRIGGERS.
    END.  /* IF UIB */

    /* Compile Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Compile menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Cl&ose Character Run Window"    PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_ttysx.p (INPUT TRUE). END TRIGGERS.
    END.  /* IF UIB or BOTH */

    /* jep-icf: If the location of the ICF menu changes in adeuib/_abmbar.w, then
       we must move this assignment as well. This assignment "skips over" the ICF
       menu defined by the AB's persistent menubar procedure. */
    /* ICF Menu */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN DO:
      ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* ICF menu */
    END.  /* ICF Menu */
 
    /* Tools Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Tools menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM mi_property_sheet ASSIGN LABEL = "Propert&y Sheet..."
               SENSITIVE = FALSE  PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_prop_sheet. END TRIGGERS.
    END.

    CREATE MENU-ITEM mi_proc_settings ASSIGN LABEL = "Procedure &Settings..." PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_proc_settings. END TRIGGERS.

    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_color ASSIGN LABEL = "C&olor..." SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_selcolr. END TRIGGERS.

    /* jep-icf: Add ICF menu items to the Tools menu. */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN DO:
      IF VALID-HANDLE(_h_menubar_proc) THEN
        RUN addICFTools IN _h_menubar_proc (INPUT h_sm).
    END.  /* ICF */


    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_dbconnect ASSIGN LABEL = "Database Co&nnections" PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN run-dblist. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    {adecomm/toolrun.i
      &PERSISTENT  = PERSISTENT
      &MENUBAR     = m_menubar
      &EXCLUDE_UIB = YES
      } 


    /* Options Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Options menu */
    IF {adecomm/editsrc.i} THEN DO:
      CREATE MENU-ITEM mi_editing_opts ASSIGN LABEL = "&Editing Options..."
                SENSITIVE = TRUE                                           PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN editing_options. END TRIGGERS.

    END.

    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_grid_snap ASSIGN LABEL = "Snap to &Grid"
                SENSITIVE = FALSE    TOGGLE-BOX = YES                PARENT = h_sm
         TRIGGERS: ON VALUE-CHANGED PERSISTENT RUN change_grid_snap. END TRIGGERS.

      CREATE MENU-ITEM mi_grid_display ASSIGN LABEL = "&Display Grid"
                SENSITIVE = FALSE    TOGGLE-BOX = YES PARENT = h_sm
         TRIGGERS: ON VALUE-CHANGED PERSISTENT RUN change_grid_display. END TRIGGERS.

      ASSIGN mi_grid_snap:CHECKED    = _cur_grid_snap
             mi_grid_display:CHECKED = _cur_grid_visible.
    END.  /* If NOT WebSpeed only */
  END.  /* IF mode = "INIT" */

  ELSE DO: /* Mode is either UIB or WEB - NOT INIT */ 

    /* Show palette if UIB, hide if WEB */
    IF VALID-HANDLE(_h_object_win) THEN DO:
      IF MODE = "UIB" AND VALID-HANDLE(mi_show_toolbox) AND 
         mi_show_toolbox:LABEL = "&Hide Object Palette" AND
         _h_menu_win:WINDOW-STATE NE 2
        THEN _h_object_win:HIDDEN = no.
      ELSE _h_object_win:HIDDEN = yes.
    END.
    
    /* Hide "Label" field if a WEB object */
    DO WITH FRAME action_icons:
      IF MODE = "WEB" THEN ASSIGN cur_widg_text:HIDDEN = YES
                                  h = cur_widg_text:SIDE-LABEL-HANDLE
                                  h:HIDDEN = YES.
      ELSE ASSIGN cur_widg_text:HIDDEN = NO
                  h = cur_widg_text:SIDE-LABEL-HANDLE
                  h:HIDDEN = NO.
    END.  /* DO with FRAME action_icons */
    
    /* Appropriately grey or sensitize things */
    IF _AB_License NE 2 THEN
      ASSIGN _h_button_bar[10]:SENSITIVE = (mode = "UIB") AND _visual-obj
             m_layout:SENSITIVE          = _h_button_bar[10]:SENSITIVE
             mi_control_props:SENSITIVE  = m_layout:SENSITIVE
             mi_duplicate:SENSITIVE      = m_layout:SENSITIVE
             mi_tab_edit:SENSITIVE       = m_layout:SENSITIVE
             mi_goto_page:SENSITIVE      = m_layout:SENSITIVE
             mi_property_sheet:SENSITIVE = _h_button_bar[9]:SENSITIVE
             mi_color:SENSITIVE          = m_layout:SENSITIVE
             mi_grid_snap:SENSITIVE      = m_layout:SENSITIVE
             mi_grid_display:SENSITIVE   = m_layout:SENSITIVE.

    /* Update the menu of windows */
/*    IF VALID-HANDLE(_h_WinMenuMgr) THEN
      RUN WinMenuRebuild IN _h_uib.  */
  END. /* ELSE mode is not INIT */

END.  /* mode-morph */

/* In all other tools this is included in adecomm/toolsrun.i, but in the UIB
   it is here */
{adecomm/toolsupp.i}

/* Morph the Layout  */
PROCEDURE morph_layout.
  
  DEFINE VARIABLE cObjType      AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cur-lo-name   AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE hCustomLayout AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE lDynamic      AS LOGICAL                   NO-UNDO.
  DEFINE VARIABLE tmp-win       AS WIDGET-HANDLE             NO-UNDO.

  DEFINE BUFFER b_U    FOR _U.
  DEFINE BUFFER b_L    FOR _L.
  DEFINE BUFFER sync_L FOR _L.

  tmp-win = _h_win.
  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  IF NOT AVAILABLE _U THEN DO:
    BELL.
    MESSAGE "To change to a different layout a window must be present."
            VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  ASSIGN cur-lo-name   = _U._LAYOUT-NAME
         _cur_win_type = _U._WIN-TYPE      /* This is probably redundant */
         .
      
  /* Determine if this is a customizable Dynamic object */
  lICFIsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF lICFIsRunning = TRUE THEN
     lDynamic = DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) OR
                DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U).
  ELSE lDynamic = FALSE.

  IF lDynamic THEN DO:
    RUN disable_widgets.

    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:

      /* Before morphing Copy all labels to _L record */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win:
        FIND b_L WHERE b_L._LO-NAME = cur-lo-name AND b_L._u-recid = RECID(b_U) NO-ERROR.
        IF AVAILABLE b_L THEN DO:
          /* If we are morphing "away" from the master change the _L of all labels that are 
             in sync with the master */
          IF b_L._LO-NAME = "Master Layout":U THEN DO:
            FOR EACH sync_L WHERE sync_L._u-recid = b_L._u-recid AND
                                  sync_L._LABEL   = b_L._LABEL:
              sync_L._LABEL = b_U._LABEL.  /* b_U._LABEL has the latest version */
            END.  /* Updated all labels in sync with the master */
          END.  /* If we're morphing away from the master layout */
          b_L._LABEL = b_U._LABEL.  /* Update _L of what we are morphing away from */
        END.  /* If this object has an _L */
      END.  /* Copy labels for layout morphing away from */
           
      RUN launchContainer IN gshSessionManager
          (INPUT  "rycstlow":U         /* object filename if physical/logical names unknown */
          ,INPUT  "":U                 /* physical object name (with path and extension) if known */
          ,INPUT  "rycstlow":U         /* logical object name if applicable and known */
          ,INPUT  YES                  /* run once only flag YES/NO */
          ,INPUT  "":U                 /* instance attributes to pass to container */
          ,INPUT  "":U                 /* child data key if applicable */
          ,INPUT  "":U                 /* run attribute if required to post into container run */
          ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
          ,INPUT  ?                    /* parent (caller) window handle if known (container window handle) */
          ,INPUT  ?                    /* parent (caller) procedure handle if known (container procedure handle) */
          ,INPUT  ?                    /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
          ,OUTPUT hCustomLayout        /* procedure handle of object run/running */
          ,OUTPUT cObjType             /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
          ).
      
      WAIT-FOR WINDOW-CLOSE, CLOSE OF hCustomLayout.   
    
    END.  /* do on stop, on error */

    RUN enable_widgets.
  END.  /* If we have a dynamic object */
  ELSE RUN adeuib/_layout.w.

  IF NOT AVAILABLE _U THEN DO:  /* It gets losts with the disable_widgets */
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
    FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  END.
  IF (cur-lo-name <> _U._LAYOUT-NAME) OR (_cur_win_type <> _U._WIN-TYPE) THEN
  DO:
    /* Bug fix 19940518-055  jep
       If Section Editor window is open for window being morphed, then close it.
    */
    RUN call_sew ( INPUT "SE_CLOSE_SELECTED" ).

    ASSIGN _U._WIN-TYPE = _cur_win_type.

    IF lDynamic THEN DO:
      /* Before rendering the new layout, set the Labels in the _U */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win:
        FIND b_L WHERE b_L._LO-NAME = _U._LAYOUT-NAME AND b_L._u-recid = RECID(b_U) NO-ERROR.
        IF AVAILABLE b_L THEN
          b_U._LABEL = b_L._LABEL. /* Copy the label from the new layout _L */
        ELSE DO:  /* There is no new _L ... create it from the old one */
          CREATE b_L.
          ASSIGN b_L._LO-NAME = _U._LAYOUT-NAME
                 b_L._u-recid = RECID(b_U).
          FIND sync_L WHERE sync_L._LO-NAME = cur-lo-name AND 
                            sync_L._u-recid = RECID(b_U) NO-ERROR.
          IF AVAILABLE sync_L THEN
            BUFFER-COPY sync_L EXCEPT _LO-NAME _u-recid TO b_L.
        END.
      END.  /* Copy labels for layout morphing away from */
    END.  /* If Dynamics */


    RUN sensitize_main_window ("WINDOW").
    RUN adeuib/_recreat.p (RECID(_U)).
    /* If dynamic, may need to inform the Dynamic Property Sheet */
    IF lDynamic AND VALID-HANDLE(_h_menubar_proc) THEN
       RUN prop_changeContainer in _h_menubar_proc (STRING(tmp-win),STRING(_h_win)) NO-ERROR.
    
    /* After morphing disable undo */
    FOR EACH _action:
      DELETE _action.
    END.
    RUN DisableUndoMenu.
    RUN choose-pointer.
    RUN deselect_all(_h_win, ?).
    RUN curframe(_h_win).
    _h_cur_widg = _h_win.
    RUN display_current.
  END.
END.


/* Move selected widgets to bottom. */
PROCEDURE movetobottom.
  DEFINE VAR h AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR cnt AS INTEGER INITIAL 0 NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib OR 
          (_U._HANDLE = _h_cur_widg AND _U._STATUS NE "DELETED"): 
    ASSIGN h = IF _U._TYPE NE "DIALOG-BOX" 
               THEN _U._HANDLE
               ELSE _U._HANDLE:PARENT  /* UIB dialog window */
           ldummy = h:MOVE-TO-BOTTOM()
           cnt = cnt + 1.
  END.

  /* set the file-saved state to false, since we just created an obj. */
  IF cnt > 0 THEN RUN adeuib/_winsave.p(_h_win, FALSE).
END. /* PROCEDURE movetobottom */

/* Move selected widgets to top. */
PROCEDURE movetotop.
  DEFINE VAR h AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR cnt AS INTEGER INITIAL 0 NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib OR 
          (_U._HANDLE = _h_cur_widg AND _U._STATUS NE "DELETED"): 
    ASSIGN h = IF _U._TYPE NE "DIALOG-BOX" 
               THEN _U._HANDLE
               ELSE _U._HANDLE:PARENT  /* UIB dialog window */
           ldummy = h:MOVE-TO-TOP()
           cnt = cnt + 1.
  END.

  /* set the file-saved state to false, since we just created an obj. */
  IF cnt > 0 THEN RUN adeuib/_winsave.p(_h_win, FALSE).
END. /* PROCEDURE movetotop */

PROCEDURE mru_menu:
/* mru_menu : Update the most recently used file list in the File menu */

  DEFINE VARIABLE cAbbrevName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  
  i = 1.
  DO WHILE i < 10:
    IF VALID-HANDLE(mi_mrulist[i]) THEN DELETE WIDGET mi_mrulist[i].
    i = i + 1. 
  END.  /* do while */
  IF VALID-HANDLE(mi_rule) THEN DELETE WIDGET mi_rule.
  IF VALID-HANDLE(mi_exit) THEN DELETE WIDGET mi_exit.
  
  FOR EACH _mru_files:
    /* Get abbreviated filename to display in menu */
    RUN adecomm/_ossfnam.p 
      (INPUT _mru_files._file, 
       INPUT 30,
       INPUT ?,
       OUTPUT cAbbrevName).
    IF _mru_files._broker NE ? AND _mru_files._broker NE "" THEN
      cAbbrevName = cAbbrevName + DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, 
                                                   FALSE, _mru_files._broker).
    CREATE MENU-ITEM mi_mrulist[_mru_files._position]
      ASSIGN PARENT = m_hFile   /* jep-icf: replaces static MENU m_File reference. */
             LABEL = STRING(_mru_files._position) + " ":U + cAbbrevName
             TRIGGERS: ON CHOOSE PERSISTENT RUN choose_mru_file (_mru_files._position). END TRIGGERS.
  END.  /* for each _mru_files */

  FIND FIRST _mru_files NO-ERROR.
  IF AVAIL _mru_files THEN 
    CREATE MENU-ITEM mi_rule
      ASSIGN SUBTYPE = "RULE"
             PARENT  = m_hFile. /* jep-icf: replaces static MENU m_File reference. */
         
  CREATE MENU-ITEM mi_exit
    ASSIGN PARENT = m_hFile     /* jep-icf: replaces static MENU m_File reference. */
           LABEL = "E&xit"
           TRIGGERS: ON CHOOSE PERSISTENT RUN exit_proc. END TRIGGERS.

END.  /* PROCEDURE mru_menu */

/* open_so_untitled : Open a .W file untitled for a SmartObject
 *                    Also checks SO type to see if a database
 *                    should be connected prior to selecting it.
 */
PROCEDURE Open_SO_Untitled:
  DEFINE INPUT PARAMETER so-type      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER file_to_open AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE l                   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lICFRunning         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProductModuleCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRepDesignManager   AS HANDLE     NO-UNDO.
  
  FIND _palette_item WHERE _palette_item._name = so-type NO-ERROR.
  IF AVAILABLE _palette_item THEN DO:
    IF _palette_item._dbconnect and NUM-DBS = 0 THEN DO:
      RUN adecomm/_dbcnnct.p
        (INPUT "You must have at least one connected database to create a " 
               + (IF INDEX(_palette_item._name, 'object':U) = 0 THEN " object." ELSE ".":U),
         OUTPUT l).
        IF l EQ NO THEN 
        DO:
           RUN choose-pointer.
           RETURN.  
        END.
    END.
  END.
  ASSIGN lICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF lICFRunning  THEN
  DO:
    FIND FIRST _custom WHERE _design_template_file     = file_to_open 
                         AND _custom._object_type_code = so-type NO-ERROR.
    IF AVAILABLE (_custom) THEN
    DO:
       ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
       IF VALID-HANDLE(hRepDesignManager) THEN
          ASSIGN cProductModuleCode = DYNAMIC-FUNC("getCurrentProductModule":U IN hRepDesignManager) 
                 cProductModuleCode = ENTRY(1,cProductModuleCode,"/":U)  NO-ERROR. 

       /* Fill in the _RyObject record for the AppBuilder. */
       FIND _RyObject WHERE _RyObject.object_filename = so-type NO-ERROR.
       IF NOT AVAILABLE _RyObject THEN
          CREATE _RyObject.
       ASSIGN _RyObject.object_type_code       = IF _custom._object_type_code = ""
                                                 THEN _custom._type ELSE _custom._object_type_code
              _RyObject.parent_classes         = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.object_type_code)
              _RyObject.object_filename        = file_to_open
              _RyObject.product_module_code    = cProductModuleCode
              _RyObject.static_object          = _custom._static_object
              _RyObject.container_object       = _custom._type = "Container":u
              _RyObject.design_action          = "NEW":u
              _RyObject.design_ryobject        = YES
              _RyObject.design_template_file   = file_to_open
              _RyObject.design_propsheet_file  = _custom._design_propsheet_file
              _RyObject.design_image_file      = _custom._design_image_file.

    END. /* If AVAIL(_custom) */
            
  END.
  RUN Open_Untitled (file_to_open).


END PROCEDURE.
   
/* open_untitled : Open a .W file untitled (i.e. template) */
PROCEDURE Open_Untitled:
  DEFINE INPUT PARAMETER file_to_open AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hWin AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lExtendsDynObject AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lICFRunning         AS LOGICAL    NO-UNDO.

  RUN deselect_all (?, ?).
  /* Open the choice as an untitled window. */
  RUN setstatus ("WAIT":U, "Opening template...").
  RUN adeuib/_open-w.p (file_to_open, "", "UNTITLED":U).
  ASSIGN lICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF RETURN-VALUE <> "_ABORT":U AND lICFRunning AND AVAILABLE _P
  THEN DO:
     lExtendsDynObject  = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynView":U)
                         OR DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynSDO":U)
                         OR DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynBrow":U).
     IF lExtendsDynObject THEN
        ASSIGN hWin        =  _P._WINDOW-HANDLE:WINDOW
               hWin:TITLE  = IF NUM-ENTRIES(hWin:TITLE,"-") >= 2
                             THEN ENTRY(1,hWin:TITLE,"-") + "(":U + _P.object_type_code + ")" + " - " + ENTRY(2,hWin:TITLE,"-") 
                             ELSE hwin:TITLE + "(":U + _P.object_type_code + ")"
               NO-ERROR.
  END.
  /* Select the current name of the base widget. */
  APPLY "ENTRY":U TO cur_widg_name IN FRAME action_icons.
  
  RUN setstatus ("":U, "":U).
   /* Return to pointer mode. */
   IF _next_draw NE ? THEN RUN choose-pointer.

END PROCEDURE.

/* property_sheet : Edit the property sheet of a widget (h_self).       */
PROCEDURE property_sheet:
  DEFINE INPUT PARAMETER h_self AS WIDGET   NO-UNDO.

  DEFINE VAR   h_parent_win     AS WIDGET                       NO-UNDO.
  DEFINE VAR   h_temp           AS WIDGET                       NO-UNDO.
  DEFINE VAR   cType            AS CHARACTER                    NO-UNDO.
  DEFINE VAR   ldummy           AS LOGICAL                      NO-UNDO.

  /* Don't go into property sheets if the last event was a dbl-click and
     we were in draw mode */
  IF LAST-EVENT:FUNCTION = "MOUSE-SELECT-DBLCLICK" AND _next_draw NE ? 
  THEN RETURN.

  /* Tell the user we are doing something, then draw it. */
  RUN setstatus ("WAIT":U, "Edit properties of current object."). 
  /* If h_self is not specified, then use SELF -- also, parent the dialog boxes
     that will come up to the window where SELF is */
  IF h_self = ? THEN DO:
    /* Run this in the window where the user clicked (if, keep getting parents
     of self until we have a window). */
    ASSIGN  h_self = SELF
            h_parent_win = SELF.
    DO WHILE h_parent_win:TYPE NE "WINDOW":
       IF CAN-QUERY(h_parent_win, "PARENT") 
       THEN h_parent_win = h_parent_win:PARENT. /* Normal case */
       ELSE h_parent_win = h_parent_win:OWNER.  /* For menus   */
    END.
    CURRENT-WINDOW = h_parent_win.
  END.

  /* Deselect All widgets (except h_self) */
  RUN deselect_all (h_self, ?).
  /* Make this the current widget */
  RUN curframe (h_self).
  _h_cur_widg = h_self.
  RUN display_current.
  
  /* Now fork depending on the type of the widget, h_self. */
  FIND _U WHERE _U._HANDLE = h_self.

  /* Display the property sheet.  Keep track of the TYPE in case the _U 
     record is deleted. */
  cType       = _U._TYPE.

  /* SEW call to store current trigger code for specific window. */
  /* Needed for check syntax of calculated fields */
  IF cType = "BROWSE":U THEN RUN call_sew ( INPUT "SE_STORE_WIN").

  /* WEB: */
  FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
  IF _P._TYPE BEGINS "WEB":U THEN
    RUN choose_attributes.
  ELSE
    RUN adeuib/_proprty.p (h_self).
    
  /* For menus, the property sheet may have deleted the widget. */
  IF CAN-DO("MENU,MENU-ITEM,SUB-MENU",cTYPE) THEN DO:
    IF AVAILABLE _U THEN  
      ASSIGN h_self      = _U._HANDLE
             _h_cur_widg = h_self. 
    RUN del_cur_widg_check.
  END.
  ELSE DO:
     IF NOT AVAILABLE _U THEN
        FIND _U WHERE _U._HANDLE = h_self.  
    /* If removed from layout everywhere, delete it */
    IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                               NOT _L._REMOVE-FROM-LAYOUT) THEN RUN choose_erase.

    /* The following is necessary if the widget was recreated. */
    IF h_self ne _U._HANDLE THEN DO:
      h_self = _U._HANDLE.
      RUN changewidg (_U._HANDLE, TRUE).
    END.

  END. /* Not a menu. */

  /* Restore the current window */
  CURRENT-WINDOW = _h_menu_win.
  
  /* Update the current widget display, in case label or name
     has changed. */
  RUN display_current.

  /* SEW call to update widget name and label in SEW if necessary. */
  RUN call_sew ( INPUT "SE_PROPS" ).

  /* Reset the current cursor and wait for user input. */
  RUN setstatus ("":U, "":U).
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer. 
  /* Set the default-window cursor back to normal */
  if _h_win <> ? THEN
    ldummy = _h_win:LOAD-MOUSE-POINTER(IF _next_draw = ? 
                                       THEN "" ELSE {&start_draw_cursor}).
END PROCEDURE. /* property_sheet */

/* report-no-win   is a procedure that tells the user _h_win is unknown.  */
PROCEDURE report-no-win.
  BELL.
  MESSAGE  "No window is selected." {&SKP}
           "Please choose an existing window," {&SKP}
      "or new one." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END PROCEDURE.

/* save_palette  Save the position and orientation of the object palette as
 *               well as custom file list.
 */
PROCEDURE save_palette: /* by GFS 2/95 */
    DEFINE VAR sctn           AS CHAR INITIAL "Pro{&UIB_SHORT_NAME}" NO-UNDO.
    DEFINE VAR textout        AS CHAR                                NO-UNDO.
    DEFINE VAR okflag         AS LOGICAL INITIAL no                  NO-UNDO.
    DEFINE VAR v              AS CHARACTER                           NO-UNDO.
    DEFINE VAR c_v            AS CHARACTER                           NO-UNDO.
    
    USE "" NO-ERROR.  /* Make sure that we are using startup defaults file */
    ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    PUTPREFS-BLOCK:
    DO ON STOP  UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK
       ON ERROR UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK:
            
       PUT-KEY-VALUE SECTION sctn KEY "PaletteLoc" VALUE 
                     STRING(_h_object_win:X) + "," + STRING(_h_object_win:Y) NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.

       ASSIGN textout = "".
       IF MENU-ITEM mi_menu_only:CHECKED   IN MENU m_toolbox THEN 
         ASSIGN textout = textout + (IF textout NE "" THEN ",Menu" ELSE "Menu").
       &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
         IF MENU-ITEM mi_top_only:CHECKED IN MENU m_toolbox THEN 
           ASSIGN textout = textout +
                            (IF textout NE "" THEN ",Top-Only" ELSE "Top-Only").
       &ENDIF
       /* 7/14 (gfs) - changed textout to be a CDL of selected options */
       PUT-KEY-VALUE SECTION sctn KEY "PaletteVisualization" VALUE textout NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.
       
       ASSIGN h = _h_object_win:LAST-CHILD.
       IF NOT VALID-HANDLE(h) THEN LEAVE PUTPREFS-BLOCK.  /* Just in case no children */
       ASSIGN textout = STRING(TRUNCATE((_h_object_win:WIDTH-P + (h:WIDTH-P / 3)) / 
                         h:WIDTH-P, 0)). 
       PUT-KEY-VALUE SECTION sctn KEY "PaletteItemsPerRow" VALUE textout NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.    
       
       GET-KEY-VALUE SECTION sctn KEY _custom_files_savekey VALUE v.
       ASSIGN c_v = {&CUSTOM-FILES}.
       IF c_v eq _custom_files_default
         THEN c_v = ?. /* Default Value */
       IF v ne c_v THEN 
         PUT-KEY-VALUE SECTION sctn KEY _custom_files_savekey VALUE c_v NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.    

       ASSIGN okflag = yes. /* got through w/o error */
    END.
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal). 

    IF NOT okflag THEN
        RUN adeshar/_puterr.p ( INPUT "Object Palette" , INPUT _h_object_win ).
END PROCEDURE. /* Save Palette */

/* save_window   Saves the current _U to the related _P._SAVE-AS-FILE and 
                 updates the window title. */
PROCEDURE save_window:
  DEFINE INPUT  PARAMETER ask_file_name  AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER user_cancel    AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cAction       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBrokerURL    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFile         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstLine    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOptions      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPath         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReturnValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSaveFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE file_ext      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_title_win   AS WIDGET    NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lMRUSave      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOk           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lok2save      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSaveUntitled AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE OldTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE proxy-file    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hWin          AS WIDGET    NO-UNDO.
  DEFINE VARIABLE hCurWidg      AS WIDGET    NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDefCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRecID        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lICFRunning   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRegisterObj  AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE lNew          AS LOGICAL    NO-UNDO.
  

  DEFINE BUFFER d_P FOR _P.
  DEFINE BUFFER x_U FOR _U.

  FIND _P WHERE _P._u-recid eq RECID(_U).    
  
  /* Is the file missing any links, or is it OK to Save */
  RUN adeuib/_advsrun.p (_h_win,"SAVE":U, OUTPUT lok2save).  
  IF NOT lOk2save THEN RETURN.

  ASSIGN 
    h_title_win   = _U._HANDLE
    _save_file    = _P._SAVE-AS-FILE
    user_cancel   = YES 
    lSaveUntitled = (_remote_file AND NOT ask_file_name AND _save_file = ?)
    lICFRunning   = DYNAMIC-FUNCTION("IsICFRunning":U) 
   NO-ERROR.

 
  IF _P.design_ryobject AND lICFRunning
  AND (NOT _P.static_object)
  THEN DO:

    /* Set the cursor pointer in all windows */
    RUN setstatus ("WAIT":U,"Saving object...").

    IF _P.container_object THEN
    DO:
      IF VALID-HANDLE(_P.design_hpropsheet)
      THEN DO:
        DEFINE VARIABLE lNewObject  AS LOGICAL NO-UNDO.
      
        /* Plan to add this object to the MRU list of its new and save is completed. */
        ASSIGN lNewObject = CAN-DO(_P.design_action ,"NEW":u)
               lMRUSave   = lNewObject.

        /* Call the object's property sheet to save the object. */
        RUN saveObject IN _P.design_hpropsheet
          (INPUT-OUTPUT _save_file, OUTPUT user_cancel).
        /* Update MRU list if save of new object is successful. */
        ASSIGN lMRUSave = (lNewObject AND user_cancel = NO).

        IF NOT user_cancel THEN
        DO:
          ASSIGN
            user_cancel            = NO 
            _P._FILE-SAVED         = TRUE
            _P._SAVE-AS-FILE       = _save_file
            _P.design_action       = "OPEN":u
            h_title_win            = _P._WINDOW-HANDLE:WINDOW
            OldTitle               = h_title_win:TITLE.

          RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                                 _P._SAVE-AS-FILE).
  
          /* Change the active window title on the Window menu. */
          IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
            RUN WinMenuChangeName IN _h_WinMenuMgr
              (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
  
          /* Notify the Section Editor of the window title change. Data after 
             "SE_PROPS" added for 19990910-003. */
          RUN call_sew ( "SE_PROPS":U ). 
  
          /* Update most recently used filelist */    
          IF lMRUSave AND _mru_filelist THEN 
            RUN adeshar/_mrulist.p (_save_file, IF _remote_file THEN _BrokerURL ELSE "").
  
          /* IZ 776 Redisplay current filename in AB Main window. */
          RUN display_current IN _h_uib.
        END. /* save ok */
  
      END. /* valid-handle prop sheet */
      /* This message should never be given.  The container builder will now open
         for any container opened in the AppBuilder.  When a container is run in the 
         AppBuilder, the container builder will not be destroyed (it was to avoid being
         viewed when the container stopped running even if it was hidden before it was run). */
      ELSE 
        MESSAGE "Container not saved to the repository.  Its property sheet is not open.":U  VIEW-AS ALERT-BOX.
    END.  /* if container object */
    /* Check for DynBrowse, DYnView and DynSDO which are not containers */
    ELSE DO:
       ASSIGN lNew = CAN-DO(_P.design_action, "NEW":u).
       IF lNew OR ask_file_name THEN 
       DO: 
          RUN adeuib/_accsect.p("GET":U,
                                 ?,
                                 "DEFINITIONS":U,
                                 INPUT-OUTPUT iRecID,
                                 INPUT-OUTPUT cDefCode ).
          ASSIGN 
            iStart     = INDEX(cDefCode,"File:")
            iEnd       = INDEX(cDefCode,CHR(10),iStart)
            _save_file = IF iStart > 0 AND iEnd > 0 
                         THEN TRIM(SUBSTRING(cDefCode,iStart + 5,  iEnd - iStart - 5 ))
                         ELSE _save_file
            _P._SAVE-AS-FILE = _save_File
            NO-ERROR.
          /* If we are saving As, set the save-as-file equal to the original object name */
          IF _P._SAVE-AS-FILE = "" THEN
             ASSIGN _P._SAVE-AS-FILE = _P.object_fileName.
          
          RUN af/cod/afsvwizdw.w (INPUT NO, OUTPUT lRegisterObj, OUTPUT lOK).
          IF NOT lOK THEN 
          DO:
             IF lNew THEN ASSIGN _P._SAVE-AS-FILE = ?.
             ASSIGN user_cancel     = YES.
             RETURN.
          END.
       END.
       /* If we are saving an existing dynamic object as another dynamic object, we must */
       /* set the object_obj to zero for all instances */
       IF NOT lNew AND ask_file_name THEN
       DO:
          /* Need to change the object filename */
          FIND _RyObject WHERE _RyObject.design_precid = RECID(_P) NO-ERROR.
          IF AVAIL _RyObject THEN ASSIGN _RyObject.object_filename = _P.object_filename.
          IF AVAIL _U THEN
          DO:
           /* Save the object-obj values in private data in case save fails and it needs to be reset */
             IF VALID-HANDLE(_U._HANDLE) AND _U._OBJECT-OBJ <> ? THEN
               ASSIGN _U._HANDLE:PRIVATE-DATA = STRING(_U._OBJECT-OBJ) + CHR(4) 
                                                 + IF _U._HANDLE:PRIVATE-DATA = ? THEN "" ELSE _U._HANDLE:PRIVATE-DATA.

           
             ASSIGN _U._OBJECT-OBJ = 0. 
             FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                              x_U._STATUS = "NORMAL":U AND
                              NOT x_U._NAME BEGINS "_LBL-":U AND
                              x_U._TYPE NE "WINDOW":U AND
                              x_U._TYPE NE "FRAME":U:
                IF VALID-HANDLE(x_U._HANDLE) AND x_U._OBJECT-OBJ <> ? THEN
                   ASSIGN x_U._HANDLE:PRIVATE-DATA = STRING(x_U._OBJECT-OBJ) + CHR(4) + x_U._HANDLE:PRIVATE-DATA.
                ASSIGN x_U._OBJECT-OBJ = 0.
             END.
          END.
       END.

       /* The design action might have been "NEW", but now object is save. So the
          action is changed to "OPEN". */
       IF lNew THEN
         ASSIGN _P.design_action  = REPLACE(_P.design_action, "NEW":U, "OPEN":U).

       RUN setstatus ("WAIT":U,"Saving object...":U).

       /* Here's where we save the dynamic object */
       RUN ry/prc/rygendynp.p (INPUT RECID(_P), OUTPUT cError).
       
       RUN setstatus ("":U, "":U).

       IF (cError <> "") THEN
       DO:
          MESSAGE "Object was not saved to the repository." SKIP(1)
             cError
             VIEW-AS ALERT-BOX.
          IF lNew THEN
             ASSIGN _P._SAVE-AS-FILE = ?
                    _P.design_action = REPLACE (_P.design_action, "OPEN":U,"NEW":U ).
          ELSE DO:
             /* Reset the Object-Obj fields back to their original state */
             FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
             IF AVAIL _U THEN
             DO:
             /* Save the object-obj values in private data in case user cancels and it needs to be rest */
                IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                   ASSIGN _U._OBJECT-OBJ = DECIMAL(ENTRY(1,_U._HANDLE:PRIVATE-DATA, CHR(4))) 
                          _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA, CHR(4))
                          NO-ERROR.
                FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                                   x_U._STATUS = "NORMAL":U AND
                                   NOT x_U._NAME BEGINS "_LBL-":U AND
                                   x_U._TYPE NE "WINDOW":U AND
                                   x_U._TYPE NE "FRAME":U:
                   IF VALID-HANDLE(x_U._HANDLE) AND NUM-ENTRIES(x_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                      ASSIGN x_U._OBJECT-OBJ = DECIMAL(ENTRY(1,x_U._HANDLE:PRIVATE-DATA, CHR(4))) 
                             x_U._HANDLE:PRIVATE-DATA = ENTRY(2,x_U._HANDLE:PRIVATE-DATA, CHR(4))
                             NO-ERROR.
                END.
             END. /* End if avail _U */
          END. /* End if existing object */

          RETURN.
       END. /* If there was an error */

      /* Return the private data to it's original state */
       IF NOT lNew AND ask_file_name THEN
       DO:
          FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
          IF AVAIL _U THEN
          DO:
          /* Save the object-obj values in private data in case user cancels and it needs to be rest */
             IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                ASSIGN _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA, CHR(4)) NO-ERROR.
             
             FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                                x_U._STATUS = "NORMAL":U AND
                                NOT x_U._NAME BEGINS "_LBL-":U AND
                                x_U._TYPE NE "WINDOW":U AND
                                x_U._TYPE NE "FRAME":U:
                IF VALID-HANDLE(x_U._HANDLE) AND NUM-ENTRIES(x_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                   ASSIGN x_U._HANDLE:PRIVATE-DATA = ENTRY(2,x_U._HANDLE:PRIVATE-DATA, CHR(4)) NO-ERROR.
             END.
           END. /* End if avail _U */
       END.
       
       ASSIGN
         _P._FILE-SAVED         = TRUE
         h_title_win            = _P._WINDOW-HANDLE:WINDOW
         OldTitle               = h_title_win:TITLE
         User_cancel            = NO.

       RUN adeuib/_wintitl.p (h_title_win, _U._LABEL + "(" + _P.OBJECT_type_code + ")", _U._LABEL-ATTR, 
                              _P._SAVE-AS-FILE).
 
       /* Change the active window title on the Window menu. */
       IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
         RUN WinMenuChangeName IN _h_WinMenuMgr
           (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
 
       /* Notify the Section Editor of the window title change. Data after 
          "SE_PROPS" added for 19990910-003. */
       RUN call_sew ( "SE_PROPS":U ). 
 
       /* Update most recently used filelist */  
       
       IF _mru_filelist THEN 
         RUN adeshar/_mrulist.p (_P.Object_fileName,IF _remote_file THEN _BrokerURL ELSE "").
 
       /* IZ 776 Redisplay current filename in AB Main window. */
       RUN display_current IN _h_uib.


    END. /* End check for DynBrowse, DynView or DynSDO */

    RUN setstatus ("":U,"":U).  /* Set the cursor pointer in all windows */
    RETURN.
  END. /* dynamic repository object save */          

  /* If there is no name, or we need to ask, or if there was a wizard which 
     assigned a product_module, then get a new file name. */
  IF ask_file_name OR _save_file = ?  THEN 
  DO:
    /* When saving a new file or saving an existing file as something
       else we need to update the MRU filelist after the save is done */
    ASSIGN lMRUSave    = TRUE.
    /*  If we can't find the file, that means this is a new file. */
    
    IF _save_file = ?
    THEN DO:
      IF _P._html-file <> "":U
      THEN DO:
        /* Set the filename to be like the name of the HTML file. */
        ASSIGN 
          cSaveFile = IF _remote_file
                      THEN _P._html-file
                      ELSE SEARCH(_P._html-file)
          ix        = R-INDEX(cSaveFile, ".":U).
        IF i > 0 AND INDEX(cSaveFile, "/":U, ix) = 0
        THEN
          cSaveFile = SUBSTRING(cSaveFile, 1, ix - 1, "CHARACTER":U).

        /* Watch for cases of a period in the directory, but not in the file 
           extension, e,g. /user/test.dir/myfile) */
        IF ix > 0 AND INDEX(REPLACE(cSaveFile,"~\":U,"/":U), "/":U, ix) = 0
        THEN
          ASSIGN cSaveFile = SUBSTRING(cSaveFile, 1, ix - 1, "CHARACTER":U).
        IF _P._file-type = "":U
        OR _P._file-type = ?
        THEN _P._file-type = "w":U.
        ASSIGN
          _save_file = cSaveFile + ".":U + _P._file-type.
      END.
      ELSE DO:
        /* Get the current contents of the definition section 
           and set the default filename equal to the previously entered value
           donb-Issue 3393  */
        RUN adeuib/_accsect.p("GET":U,
                              ?,
                              "DEFINITIONS":U,
                              INPUT-OUTPUT iRecID,
                              INPUT-OUTPUT cDefCode ).
        ASSIGN 
          iStart     = INDEX(cDefCode,"File:")
          iEnd       = INDEX(cDefCode,CHR(10),iStart)
          _save_file = IF iStart > 0 AND iEnd > 0 
                       THEN TRIM(SUBSTRING(cDefCode,iStart + 5,  iEnd - iStart - 5 ))
                       ELSE _save_file
          NO-ERROR.


        /* WIN95-LFN - Win95 long filename support. jep 12/14/95 */
        IF _save_file = ? THEN
          _save_file = IF LENGTH(_U._NAME, "RAW":U) < 9 OR OPSYS <> "WIN32":u
                       THEN lc(_U._NAME) + ".":U + _P._FILE-TYPE
                       ELSE lc(SUBSTRING(_U._NAME,1,8,"FIXED":U)) + ".":U + 
                         _P._FILE-TYPE.
      END.

    END. /* END _Save-file = ? */

      /* Handle cases where local file is being saved remotely or remote file is being saved locally.
         Strip off the file path, since it will invariably be invalid. */
    IF ask_file_name  AND _save_file <> "" AND _save_file <> ?
       AND ((   _remote_file AND _P._broker-url =  "")
       OR  (NOT _remote_file AND _P._broker-url <> ""))
    THEN DO:
      RUN adecomm/_osprefx.p (_save_file, OUTPUT cPath, OUTPUT cFile).
      _save_file = cFile.
    END.

    /* Get name for an untitled, remote file, check to see if it exists and is writeable.
       _save_file will contain the relative file path. */
    IF _remote_file
    THEN DO:
      RUN adeweb/_webfile.w ("uib":U, "saveas":U, "Save As":U, "":U,
                             INPUT-OUTPUT _save_file, OUTPUT cTempFile, 
                             OUTPUT lOk).
      IF NOT lOk THEN RETURN.   /* the user cancelled */
    END.
    ELSE DO:
       /* Check whether wizard previously saved the filename and module */
      IF lICFRunning AND _P.Product_module_code > "" THEN
      DO: /* Run wizard confirmation dialog */
         ASSIGN _P._SAVE-AS-FILE = _save_file.

         /* IZ 9872 and IZ 9903 Workaround to be fixed properly later */
         IF NOT VALID-HANDLE(_h_cur_widg) THEN _h_cur_widg = _h_win.

         RUN af/cod/afsvwizdw.w (INPUT IF ask_file_name THEN YES ELSE NO, 
                                 OUTPUT lRegisterObj,OUTPUT lOK).
         IF NOT lOK THEN DO:
            ASSIGN _P._SAVE-AS-FILE = ?.
            RETURN.
         END.
         
         ASSIGN _save_file = _P._SAVE-AS-FILE.
         IF lRegisterObj THEN _P.design_ryObject = YES.
      END.
      ELSE DO:
         RUN adeuib/_sel_fn.p ("Save As", 
               IF (_save_file = ? OR _save_file = "") THEN "":U 
               ELSE ENTRY(NUM-ENTRIES(_save_file,"/":U), _save_file, "/":U)).
         IF _save_file = ? THEN RETURN.  /* the user cancelled */
      END.
    END.

    /*
     * If ask_file_name is set then a "save as" is occuring.
     * Cover a situation with a OCX control. If an existing
     * file is being saved-as something else and the OCX binary
     * file is not using the default name, find out if the 
     * user wants to keep or reset the OCX binary name
     */
    IF OPSYS = "WIN32":U
    THEN DO:
      IF ask_file_name
      AND CAN-FIND(FIRST x_U WHERE x_U._TYPE = "{&WT-CONTROL}")
      THEN DO:
        /* There is a OCX control and this a save as.
           If the OCX binary file is not being saved in the default location
           then ask the user for direction. */

        IF _P._VBX-FILE <> ?
        THEN DO:

          MESSAGE "Do you want to continue to save the" SKIP
                  "{&WT-CONTROL} binary file in" _P._VBX-FILE + "?" SKIP
                  "Choose YES to to continue; Choose NO to" SKIP
                  "reset to the default location." SKIP
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "Save {&WT-CONTROL} Binary File?"
                  UPDATE lOk.

          IF lOk = NO THEN _P._VBX-FILE = ?.
        END.
      END.
    END. /* MS-WINDOWS OCX */

    /* If the filename doesn't have an extension, use the proc type extension. - jep */
    RUN adecomm/_osfext.p
        (INPUT  _save_file , OUTPUT File_Ext ).
    IF (File_Ext = "") THEN
      ASSIGN _save_file = _save_file + "." + _P._FILE-TYPE.

    /*  Make sure that we have the full pathname of the local file,
        not just a local path. Build the full pathname.  */
    IF NOT _remote_file
    THEN DO:
      _save_file = REPLACE(_save_file,"~\":U, "/").
      /* If filename has not been selected, fix it up */
      FILE-INFO:FILE-NAME = _save_file.
      IF FILE-INFO:FULL-PATHNAME = ? 
          AND _P._save-as-path <> "":U
          AND _P._save-as-path <> ".":U
          AND NOT _save_file BEGINS (_P._save-as-path + "/":U) /* Don't double it */
      THEN
        FILE-INFO:FILE-NAME = RIGHT-TRIM(_P._save-as-path, "/":U) + "/":U + _save_file.


      IF FILE-INFO:FULL-PATHNAME = ?
      THEN DO:
        /* Figure out the current path, but first, figure out if the
           proposed name already is a fully qualified name. 
           If the path is "?" then there was no path. The _save_file 
           is a simple name. Build a full path for it.  */
        RUN adecomm/_osprefx.p(_save_file, OUTPUT cPath, OUTPUT cFile).
        IF (LENGTH(cPath) = 0)
        THEN DO:
          FILE-INFO:FILE-NAME = ".":U.
          RUN adecomm/_osfmush.p(FILE-INFO:FULL-PATHNAME, _save_file,
                                 OUTPUT _save_file).
        END.
      END.
      ELSE
        _save_file = FILE-INFO:FULL-PATHNAME.

    END. /* NOT remote_file */

    /*
     * Now check to see if the file that the user selected is already in
     * the list of active windows. If it is, then let the user know there
     * is a conflict. It is up to the user to get everything figured
     * out. We check to see if there are 2 records with the same name.
     * If there are 0 or 1 the FIND NEXT will fail.
     */
    FIND d_P WHERE d_P._SAVE-AS-FILE = _save_file  AND
                   RECID(d_P) <> RECID(_P) NO-ERROR.
    IF AVAILABLE d_P THEN DO:
      MESSAGE
        "Another window uses" _save_file "to save into." SKIP
        "Either close that window or choose another filename" SKIP
        "for this window. The 'Save As...' operation has been cancelled."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      _save_file = ?.
    END.
  END.

  /*
   * Now check to see if the local file to save is writable. If not, tell the 
   * user and abort the save.  Note: Message used here is the same as the 
   * Procedure Editor and Procedure Windows use.
   */
  IF NOT _remote_file THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = _save_file.
    IF (FILE-INFO:FULL-PATHNAME <> ?) AND
       (INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0)
    THEN DO:
      DO ON STOP   UNDO, LEAVE
         ON ENDKEY UNDO, LEAVE
         ON ERROR  UNDO, LEAVE:
        MESSAGE _save_file SKIP
          "Cannot save to this file."  SKIP(1)
          "File is read-only or the path specified" SKIP
          "is invalid. Use a different filename."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW ACTIVE-WINDOW.
      END.
      ASSIGN _save_file = ?.
    END.
  END. /* NOT remote_file */

  /*  
   * We'll live off the state of the _save_file variable. If there is no
   * value then the user cancelled out of the save. That means that
   * the user wants to abort the operation. If the use of _save_file
   * changes then this check could be hosed.
   */
  IF _save_file NE ? THEN DO:
    /* Set the cursor pointer in all windows */
    RUN setstatus ("WAIT":U,"Saving file...").
    ASSIGN
      _h_win       = _U._HANDLE
      web-tmp-file = ""
      _save_mode   = (IF ask_file_name THEN "T":U ELSE "F":U) + ",":U +
                     (IF lSaveUntitled THEN "T":U ELSE "F":U).
    /* Save existing or untitled WebSpeed file to a local temp file first. */
    IF (NOT ask_file_name AND _P._broker-url ne "") OR 
       (    ask_file_name AND _remote_file        ) OR lSaveUntitled THEN
      RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT web-tmp-file).

    ASSIGN hWin     = _h_win
           hCurWidg = _h_cur_widg.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "SAVE":U, ?, _save_file, OUTPUT cScrap).
    ELSE
      RUN adeshar/_gen4gl.p (IF ask_file_name THEN "SAVEAS" ELSE "SAVE":U).
    /* Closing/saving a SmartObject may cause focus to move to the instance of
       the object in a SmartWindow due to it being recreated after code generation.
       This can set the current window and widget _h_win and _h_cur_widg to the
       SmartWindow containing the instance, which is undesirable. So if it does
       change, reset the current window and widget back to what it was before
       the close/save/code generation. 9.1B Fix 20000510-005 -jep. */
    IF _h_win <> hWin THEN
    DO:
      /* If the "current widget" prior to code gen is gone or we never had one
         (for example, multiple widgets were selected), set current widget to
         design window. -jep */
      IF NOT VALID-HANDLE(hCurWidg) THEN
        ASSIGN hCurWidg = hWin.
      RUN changewidg (INPUT hCurWidg , INPUT NO /* deselect others */).
    END.

    /* With user defined code in SmartObjects it is possible that focus is lost.
       This causes _U to get lost, so we restore it here. */
    IF NOT AVAILABLE _U THEN
      FIND _U WHERE _U._HANDLE = _h_win.

    /* Save remote file to a WebSpeed agent and restore web-tmp-file. */
    IF (NOT ask_file_name AND _P._broker-url <> "") OR 
       (    ask_file_name AND _remote_file        ) OR lSaveUntitled THEN DO:
      IF NOT RETURN-VALUE BEGINS "Error":U THEN DO:
        ASSIGN
          cBrokerURL = IF (ask_file_name OR _P._broker-url eq "")
                       THEN _BrokerURL ELSE _P._broker-url
          cOptions   = (IF ask_file_name OR lSaveUntitled 
                         THEN "SAVEAS":U ELSE "SAVE":U) +
                       (IF (_P._compile AND NOT _P._template) 
                         THEN ",COMPILE":U ELSE "").

        RUN disable_widgets.
        
        RUN adeweb/_webcom.w (RECID(_P), cBrokerURL, _save_file, cOptions,
                              OUTPUT cRelName, INPUT-OUTPUT web-tmp-file).
        
        IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
          ASSIGN
            cFirstLine   = ENTRY(1, RETURN-VALUE, CHR(10))
            cAction      = IF NUM-ENTRIES(cFirstLine, " ":U) ge 3 THEN
                             ENTRY(3, cFirstLine, " ":U) ELSE "saved".
            cReturnValue = SUBSTRING(RETURN-VALUE, INDEX(RETURN-VALUE,CHR(10)) + 1,
                                     -1, "CHARACTER":U).
          RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
            SUBSTITUTE("&1 could not be &2 for the following reason:^^&3",
            _save_file, cAction, cReturnValue)).
        END.
        ELSE DO:
          IF cRelName ne ? AND cRelName ne "" THEN 
            _save_file = cRelName.
            
          /* If saving a DB-Aware object, compile the proxy file now.  We 
             couldn't do it before (adeshar/_gen4gl.p), since the .w did not
             yet exist. */
          IF _P._DB-AWARE THEN DO:
            proxy-file = SUBSTRING(_save_file,1,R-INDEX(_save_file,".":U) - 1,
                              "CHARACTER":U) + "_cl.w":U.

            RUN adeweb/_webcom.w (RECID(_P), cBrokerURL, proxy-file, 
                                  "compile":U, OUTPUT cRelName, 
                                  INPUT-OUTPUT web-tmp-file).
            IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
              cReturnValue = SUBSTRING(RETURN-VALUE, INDEX(RETURN-VALUE,CHR(10)) + 1,
                                       -1, "CHARACTER":U).
              RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
                SUBSTITUTE("&1 could not be compiled for the following reason:^^&2",
                proxy-file, cReturnValue)).
            END.
          END. /* writing a proxy file */
          
          /* check for _u SmartObjects, use preselect because 
             adeuib/_recreat.p deletes and creates an _u.
            Note that recreat will reset _h_win  */
          hWin = _h_win. 
          REPEAT PRESELECT EACH _U WHERE _U._TYPE EQ "SmartObject" 
                                 AND   _U._STATUS NE "DELETED":U:
          
         FIND NEXT _U.
         FIND _S WHERE RECID(_S) = _u._x-recid.
                           
            /* If the smartObject is the saved one */
            IF _s._file-name = _save_file THEN 
            DO: 
              /* find the procedure and recreate the smartobject if the 
                 url matches */                  
              FIND d_P WHERE d_P._window-handle = _U._window-handle no-error.
              IF AVAIL d_P 
              AND d_P._broker-url <> "" 
              AND d_P._broker-url = cBrokerUrl 
              AND VALID-HANDLE(d_p._tv-proc) THEN 
                RUN adeuib/_recreat.p (RECID(_U)).
         END.
       END. /* repeat preselect */ 
          _h_win = hWin. /* window handle may change in  _recreat.p  */
        END.
                    
        RUN enable_widgets.                              
  
  /* Refind _U that was "lost" during previous run of enable_widgets. */
        FIND _U WHERE _U._HANDLE = _h_win.
      END.
      OS-DELETE VALUE(web-tmp-file).
      ASSIGN web-tmp-file = "".
    END.
    
    IF NOT (RETURN-VALUE BEGINS "Error":U) THEN DO:
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      ASSIGN
        user_cancel            = NO 
        _P._FILE-SAVED         = TRUE
        _P._SAVE-AS-FILE       = _save_file
        h_title_win            = IF (_U._TYPE = "DIALOG-BOX":U)
                                  THEN _U._HANDLE:PARENT
                                  ELSE _U._HANDLE
        OldTitle               = h_title_win:TITLE.

      IF ask_file_name OR lSaveUntitled THEN
        _P._BROKER-URL = IF _remote_file THEN _BrokerURL ELSE "".
        
      RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                             _P._SAVE-AS-FILE).
      /* Change the active window title on the Window menu. */
      IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
        RUN WinMenuChangeName IN _h_WinMenuMgr
          (_h_WindowMenu, OldTitle, h_title_win:TITLE). 

      /* We updated the dirty setting for OCX controls in _gen4gl.p by calling
         Set_Control_Dirty. Just wanted you to know. -jep */
         
      /* Notify the Section Editor of the window title change. Data after 
         "SE_PROPS" added for 19990910-003. */
      RUN call_sew ( "SE_PROPS":U ). 

      /* If we are saving a Method Library, LIB-MGR reopens it in memory. */
      /* Fixes bug 19950601-042. */
      IF _P._TYPE = "Method-Library":U THEN
        RUN reopen-lib IN _h_mlmgr (_save_file, _P._Broker-URL).     
          
      /* Update most recently used filelist */    
      IF lMRUSave AND _mru_filelist AND NOT lRegisterObj THEN 
        RUN adeshar/_mrulist.p (_save_file, IF _remote_file THEN _BrokerURL ELSE "").

      /* IZ 776 Redisplay current filename in AB Main window. */
      RUN display_current IN _h_uib.
      
    END. /* If no _gen4gl error */
    
    RUN setstatus ("":U,"":U).  /* Set the cursor pointer in all windows */
    
    /* If we compiled (and found an error) then show the Error in the SEW. */
    IF _P._compile AND _err_recid <> ? THEN DO:
      RUN call_sew ( INPUT "SE_ERROR":U).
      ASSIGN _err_recid = ?.
    END.

    /* Unlike other UIB actions, don't Return to pointer mode 
       (see bug 19931206-02). */
       
    /* jep-icf: IZ 1981 Save static repository object. */
    /* Only save if user specified to register the object */
    IF lICFRunning  AND lRegisterObj THEN 
       RUN save_window_static (INPUT RECID(_P), OUTPUT cError).

    _P.design_action = "OPEN":U.
  END. /* _save_file NE ? */
END PROCEDURE. /* save_window */


/* save_window_static Saves the current _P as a static repository object. */
PROCEDURE save_window_static :
  
/* Note this is the historical name.  This will also identify if a window is
   to be converted to a dynamic window and save it accordingly           */

    DEFINE INPUT  PARAMETER pPrecid   AS RECID      NO-UNDO.
    DEFINE OUTPUT PARAMETER pError    AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE lPrompt          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSavedPath       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjPath         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilename        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLine            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLogicProc       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRelname         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dDlObj           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hObjectBuffer    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeTable  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lmrusave         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lregLP           AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iEnd             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iStart           AS INTEGER    NO-UNDO.

    /* If we aren't running ICF, leave now. */
    IF NOT CAN-DO(_AB_Tools,"Enable-ICF") THEN RETURN.

    /* Save off type code as we may need it later (IZ 6132) */
    ASSIGN cObjectType = _P.object_type_code.

    FIND _P WHERE RECID(_P) = pPrecid NO-ERROR.
    IF NOT AVAILABLE _P THEN
    DO:
      RETURN.
    END.

    ASSIGN  lMRUSave   = CAN-DO(_P.design_action ,"NEW":u).

    /* If this is a NEW static SDO and user has indicated it should be registered,
       then the logic procedure should be registered also                      */
    IF lMRUSave AND _P.OBJECT_type_code = "SmartDataObject":U AND 
       _P.static_object THEN lregLP = YES.

    /* If the object isn't to be defined as a repository object */
    IF (_P.design_ryobject = NO) THEN RETURN.
      
    /* If the object is to be stored as a dynamic object then call rygendynp.p */
    IF (_P.static_object = NO) THEN DO ON ERROR UNDO, LEAVE:

      RUN setstatus ("WAIT":U,"Saving object...":U).
      
      /* The design action might have been "NEW", but now object is save. So the
         action is changed to "OPEN". */
      IF CAN-DO(_P.design_action, "NEW":U) THEN
        ASSIGN _P.design_action = REPLACE(_P.design_action, "NEW":U, "OPEN":U).

      RUN ry/prc/rygendynp.p (INPUT pPrecid, OUTPUT pError).
         
      RUN setstatus ("":U,"":U).

      IF (pError <> "") THEN
      DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
          MESSAGE "Object not saved to repository." SKIP(1)
                  pError
            VIEW-AS ALERT-BOX.
      END.

    END. /* If a dynamic or logical object */

    ELSE DO ON ERROR UNDO, LEAVE:
    
      RUN setstatus ("":U,"":U).
      
      /* The design action might have been "NEW", but now object is save. So the
         action is changed to "OPEN". */
      IF CAN-DO(_P.design_action, "NEW":U) THEN
        ASSIGN _P.design_action = REPLACE(_P.design_action, "NEW":U, "OPEN":U).

      /* For consistent translation from AB type to repository type, reset to AB type.
         Save code will translate properly to repository type. */
      ASSIGN _P.object_type_code  = _P._TYPE.

      /* If the user changed the filename during a save as, update the object filename.
         This results in the file being saved to the repository with a different name. */
      RUN adecomm/_osprefx.p (INPUT _P._SAVE-AS-FILE, OUTPUT cSavedPath, OUTPUT cFilename).
      ASSIGN _P.object_filename = cFilename.

      /* Determine the propath relative name for this object. This may be different
         than the product module and even where the object was originally opened
         from. */
      RUN adecomm/_relfile.p
          (INPUT _P._SAVE-AS-FILE, INPUT NO /* plCheckRemote */,
           INPUT "" /* pcOptions */, OUTPUT cRelname).

      /* cRelname contains filename. Take it off so we just have propath relative path. */
      RUN adecomm/_osprefx.p
          (INPUT cRelname, OUTPUT cRelname, OUTPUT cFilename).

      /* Trim trailing directory slashes (\ or /) and replace remaining ones with
         forward slash for portability with how repository stores paths. */
      ASSIGN cRelname = REPLACE(LC(RIGHT-TRIM(cRelname, '~\/')), "~\", "/").
      ASSIGN _P.object_path = cRelname.
      

      /* Prompt for Product Module if for some reason we don't have it. */
      ASSIGN lPrompt = (_P.product_module_code = "":u).
      
      RUN setstatus ("WAIT":U,"Saving object...":U).
      RUN af/sup2/afsdocrdbp.p
        (INPUT _P._SAVE-AS-FILE, 
         INPUT _P._TYPE, 
         INPUT _P.product_module_code,
         INPUT _P.object_description, 
         INPUT _P.deployment_type,
         INPUT _P.design_only,
         INPUT lPrompt, /* prompt for PM */
         OUTPUT pError).

      IF pError <> "":U AND NOT pError MATCHES "directory":U THEN DO:
        /* Don't give up yet, try the Dynamics Object Type ... IZ 6132 */

          RUN af/sup2/afsdocrdbp.p
            (INPUT _P._SAVE-AS-FILE, 
             INPUT cObjectType, 
             INPUT _P.product_module_code,
             INPUT _P.object_description, 
             INPUT _P.deployment_type,
             INPUT _P.design_only,
             INPUT lPrompt,  /* prompt for PM */
             OUTPUT pError).
      END.

      /* If registering a static SDO then register its logic procedure (if specified) */
      IF lregLP AND pError = "":U THEN DO:
        /* Find the name of the logic procedure, only register is valid */
        FIND _TRG WHERE _TRG._pRecid = RECID(_P) AND
                        _TRG._tSECTION = "_CUSTOM":U AND
                        _TRG._tEVENT = "_DEFINITIONS":U NO-ERROR.
        IF AVAILABLE _TRG THEN DO:
          /* Get the DATA-LOGIC-PROCEDURE line from the definitions sesction */
          ASSIGN iStart     = INDEX(_TRG._tCode,"&GLOB DATA-LOGIC-PROCEDURE":U)
                 iStart     = IF iStart = 0 
                              THEN INDEX(_TRG._tCode,"&GLOBAL-DEFINE DATA-LOGIC-PROCEDURE":U)
                              ELSE iStart
                 iEnd       = IF iStart > 0 
                              THEN INDEX(_TRG._tCode,".p":U, iStart)
                              ELSE 0
                 iEnd       = IF iEnd = 0  
                              THEN INDEX(_TRG._tCode,CHR(10), iStart)
                              ELSE iEnd
                 cLine      = IF iStart > 0 AND iEnd > 0 
                              THEN  SUBSTRING(_TRG._tCode, iStart, iEnd - iStart + 2)
                              ELSE ""
                 cLogicProc = IF cLine > ""
                              THEN  TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U)))
                              ELSE "".
          /* Default template for preprocessor is .p. Ignore this if unchanged */
          IF cLogicProc <> ".p":U AND cLogicProc <> "" THEN DO:
            ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
            IF VALID-HANDLE(ghRepositoryDesignManager) THEN DO:
              ASSIGN hAttributeBuffer = ?
                     hAttributeTable  = ?
                     .
              RUN insertObjectMaster IN ghRepositoryDesignManager 
                  ( INPUT  cLogicProc,                               /* pcObjectName         */
                    INPUT  "":U,                                     /* pcResultCode         */
                    INPUT  _P.product_module_code,                   /* pcProductModuleCode  */
                    INPUT  "DLProc":U,                               /* pcObjectTypeCode     */
                    INPUT  "Logic Procedure for ":U + cFilename,     /* pcObjectDescription  */
                    INPUT  "":U,                                     /* pcObjectPath         */
                    INPUT  _P._SAVE-AS-FILE,                         /* pcSdoObjectName      */
                    INPUT  "":U,                                     /* pcSuperProcedureName */
                    INPUT  NO,                                       /* plIsTemplate         */
                    INPUT  YES,                                      /* plIsStatic           */
                    INPUT  "":U,                                     /* pcPhysicalObjectName */
                    INPUT  NO,                                       /* plRunPersistent      */
                    INPUT  "":U,                                     /* pcTooltipText        */
                    INPUT  "":U,                                     /* pcRequiredDBList     */
                    INPUT  "":U,                                     /* pcLayoutCode         */
                    INPUT  hAttributeBuffer,
                    INPUT  TABLE-HANDLE hAttributeTable,
                    OUTPUT dDlObj                                   ) NO-ERROR.

            END.  /* We have the handle of the Repository Design Manager */
          END.  /* If we have a logic proc name */
        END. /* If available _TRG */
      END.  /* If we should attempt to register the LP */

      RUN setstatus ("":U,"":U).
          
      IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                        INPUT _P.object_filename,
                        INPUT "", /* Get all Result Codes */
                        INPUT "",  /* RunTime Attributes not applicable in design mode */
                        INPUT YES  /* Design Mode is yes */
                         )  
     THEN ASSIGN 
         hObjectBuffer = DYNAMIC-FUNC("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
           _P.SmartObject_Obj =  hObjectBuffer:BUFFER-FIELD("tSmartObjectObj":U):BUFFER-VALUE
           _P.Object_FileName = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
           _P.design_RyObject = yes.
/*
      message "Saving object..." SKIP(1)
              "File:  " _P._SAVE-AS-FILE  SKIP
              "Type:  " _P._TYPE          SKIP
              "PMCode:" _P.product_module_code SKIP
              "OType: " _P.object_type_code SKIP
              "Path:  " _P.object_path    SKIP
              "Name:  " _P.object_filename SKIP
              "Desc:  " _P.object_description SKIP
              "Action:" _P.design_action    SKIP
              "Object:" _P.object_filename SKIP
              "SmartObj:" _P.smartObject_Obj SKIP
              "ParClasses:" _P.PARENT_classes
           VIEW-AS ALERT-BOX.
*/
  
      IF (pError <> "") THEN
      DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
          MESSAGE "Object not saved to repository." SKIP(1)
                  pError
            VIEW-AS ALERT-BOX.
      END.
      ELSE
      DO:   /* Add static registered object to mru list */
         IF lMRUSave AND _mru_filelist  THEN 
            RUN adeshar/_mrulist.p ( _P.Object_FileName, IF _remote_file THEN _BrokerURL ELSE "").
         RUN display_current IN _h_uib.
      END.
    END. /* DO ON ERROR */
  
END PROCEDURE.  /* save_window_static */


/* sensitize_main_window - change the sensitive status of widgets in the UIB's
 *       main window based on the current state of affairs.
 *       There are various things we can check for in this procedure.  These are
 *       listed in the pCheck string.  The items are:
 *          WINDOW - check for the existance of a window, and its type
 *          WIDGET - check for the existance and type of _h_cur_widg
 */
PROCEDURE sensitize_main_window :
  DEFINE INPUT PARAMETER pCheck AS CHAR NO-UNDO.
  
  DEFINE VARIABLE l             AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE lDynamic      AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE lMulti        AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE menu_handle   AS HANDLE            NO-UNDO.
  DEFINE VARIABLE window-check  AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE widget-check  AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE frame_cnt     AS INTEGER INITIAL 0 NO-UNDO.

  /* Decide what items to check. */
  ASSIGN widget-check = CAN-DO(pCheck, "WIDGET") 
         window-check = CAN-DO(pCheck, "WINDOW").

  /* Do window checking. */
  IF window-check THEN DO:
    /* Disable things if there is NO window - the "key" widget here is the
       "Save" button.  If that is already set, then don't worry about it. */
    l = VALID-HANDLE(_h_win).
    IF l THEN FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
    IF l NE _h_button_bar[3]:SENSITIVE THEN
    DO:
      ASSIGN _h_button_bar[3]:SENSITIVE = l /* save */
             _h_button_bar[4]:SENSITIVE = l /* print */
             _h_button_bar[5]:SENSITIVE = l /* proc */
             _h_button_bar[6]:SENSITIVE = l /* run */
             _h_button_bar[7]:SENSITIVE = l /* edit */
             _h_button_bar[8]:SENSITIVE = l /* list */
             _h_button_bar[10]:SENSITIVE = l AND _visual-obj.  /* color */
     /* IF VALID-HANDLE(_h_button_bar[11]) THEN
         ASSIGN
           _h_button_bar[11]:SENSITIVE = l.
           
     */
             /* File Menu */
      ASSIGN MENU-ITEM mi_close:SENSITIVE     IN MENU m_file = l 
             MENU-ITEM mi_close_all:SENSITIVE IN MENU m_file = l
             MENU-ITEM mi_save:SENSITIVE      IN MENU m_file = l
             MENU-ITEM mi_save_all:SENSITIVE  IN MENU m_file = l
             MENU-ITEM mi_save_as:SENSITIVE   IN MENU m_file = l 
             MENU-ITEM mi_print:SENSITIVE     IN MENU m_file = l.
             
             /* Edit Menu */
      ASSIGN MENU-ITEM mi_paste:SENSITIVE     IN MENU m_edit = l AND
                AVAILABLE _P AND (NOT _P._TYPE BEGINS "WEB":U OR 
                                  CAN-FIND(FIRST _U WHERE _U._SELECTEDib))
             mi_export:SENSITIVE  = l AND
                                    MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit
                                              WHEN VALID-HANDLE(mi_export) 
             /* Note: we can export a file of internal procedures, even if no
                widgets are selected.  "Copy to File..." does not depend on
                the existance of selected widgets (like COPY). */ 
             mi_import:SENSITIVE  = l AND
                                    MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit
                                               WHEN VALID-HANDLE(mi_import) .
                                               
             /* Compile Menu */
      ASSIGN MENU-ITEM mi_run:SENSITIVE       IN MENU m_compile = l 
             MENU-ITEM mi_check:SENSITIVE     IN MENU m_compile = l
             MENU-ITEM mi_debugger:SENSITIVE  IN MENU m_compile = l
             MENU-ITEM mi_preview:SENSITIVE   IN MENU m_compile = l .

             /* Tools Menu Menu */
      ASSIGN mi_proc_settings:SENSITIVE = l   WHEN VALID-HANDLE(mi_proc_settings)
             mi_color:SENSITIVE         = _h_button_bar[10]:SENSITIVE
                                              WHEN VALID-HANDLE(mi_color)
              /* Windows Menu */
             mi_code_edit:SENSITIVE     = l   WHEN VALID-HANDLE(mi_code_edit).
    END.
    
    /* Some actions depend on the _P settings. This is the
       Pages (which only work in PAGE-TARGETS) and Alternate Layouts. */
    IF NOT l THEN
      ASSIGN mi_goto_page:SENSITIVE    = NO WHEN VALID-HANDLE(mi_goto_page)
             mi_chlayout:SENSITIVE     = NO WHEN VALID-HANDLE(mi_chlayout)
             mi_chCustLayout:SENSITIVE = NO WHEN VALID-HANDLE(mi_chCustLayout)
      .
    ELSE DO:
      /* Determine if this is a customizable Dynamic object */
      lICFIsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
      IF lICFIsRunning = TRUE THEN
         lDynamic = DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) OR
                    DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U).
      ELSE lDynamic = FALSE.
      
      /* Does the SmartContainer support paging. */
      ASSIGN mi_goto_page:SENSITIVE = CAN-DO(_P._links, "PAGE-TARGET")
                        WHEN VALID-HANDLE(mi_goto_page)
             lMulti = (_P._FILE-TYPE eq "w":U) AND NOT lDynamic
                      /* Are multi-layout supported by this type? 
                         That is, by anything that is a .w file. */
             mi_chlayout:SENSITIVE = lMulti WHEN VALID-HANDLE(mi_chlayout)
             mi_chCustLayout:SENSITIVE = lDynamic WHEN VALID-HANDLE(mi_chCustLayout)
             
             /* Disable Debug for WebSpeed Web objects. */
             MENU-ITEM mi_debugger:SENSITIVE IN MENU m_compile = 
               (NOT _P._TYPE BEGINS "WEB":U AND
                NOT CAN-FIND(FIRST _TRG WHERE 
                      _TRG._pRECID   eq RECID(_P) 
                  AND _TRG._tSECTION eq "_PROCEDURE":U
                  AND _TRG._tEVENT   eq "process-web-request":U))
             .
    END.  /* Else do */
                   
    /* Disable things if there is TTY window - the "key" widget here is the
       "Snap to Grid" menu-item button.  If that is already set, then don't
       worry about it. */
    l = (_cur_win_type ne NO).  /* This can be ? at startup. */
      
    IF VALID-HANDLE(mi_grid_snap) AND l ne mi_grid_snap:SENSITIVE THEN
      ASSIGN _h_button_bar[10]:SENSITIVE = l AND _visual-obj  /* Color */
             mi_grid_snap:SENSITIVE    = l AND _visual-obj
             mi_color:SENSITIVE        = _h_button_bar[10]:SENSITIVE
                                             WHEN VALID-HANDLE(mi_color).
  END.  /* IF window-check...*/
  
  /* Now do test for the current widgets. */
  IF widget-check THEN DO:
    /* Disable things if there is NO current widget - the "key" widget 
       here is the "Property" button.  If that is already set, then don't 
       worry about it. */
    l = VALID-HANDLE(_h_cur_widg).
    IF l NE _h_button_bar[9]:SENSITIVE THEN
      ASSIGN _h_button_bar[9]:SENSITIVE   = l  /* properties */
             /* Tools Menu Menu */
             mi_property_sheet:SENSITIVE = l WHEN VALID-HANDLE(mi_property_sheet).

    /* Disable things if there is NO current or selected widgets - the "key"
       here is the "Attribute" menu-item.  If that is already set, then don't 
       worry about it. */
    l = VALID-HANDLE(_h_cur_widg) OR CAN-FIND (FIRST _U WHERE _U._SELECTEDib).
    IF l ne mi_attributes:SENSITIVE THEN DO:
      ASSIGN mi_attributes:SENSITIVE    = l WHEN VALID-HANDLE(mi_attributes)
             mi_control_props:SENSITIVE = l WHEN VALID-HANDLE(mi_control_props).

      /* Only change the Color button and menu if we are in GUI mode. */
      IF _cur_win_type AND VALID-HANDLE(mi_color) THEN 
        ASSIGN _h_button_bar[10]:SENSITIVE = l AND _visual-obj   /* color */
               mi_color:SENSITIVE        = _h_button_bar[10]:SENSITIVE.
                                                          /* Tools Menu Menu */
    END.  /* If l ne mi_attributes:SENSITIVE */

    /* Disable things that imply a selected widget. */
    l = CAN-FIND (FIRST _U WHERE _U._SELECTEDib).
    IF AVAILABLE _P AND _P._TYPE BEGINS "WEB":U THEN DO:
      IF CAN-FIND(FIRST _U WHERE _U._SELECTEDib AND
                                 _U._TYPE = "FILL-IN":U) THEN l = FALSE.
      IF NOT CAN-FIND(FIRST _U WHERE _U._SELECTEDib) THEN
        ASSIGN MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit = FALSE
               mi_export:SENSITIVE = FALSE
               mi_import:SENSITIVE = FALSE.
    END.

    IF l NE MENU-ITEM mi_copy:SENSITIVE IN MENU m_edit THEN DO:
      /* Note that PASTE and IMPORT depend on the existence of a place
         to put it, not whether anything is assigned. */
      ASSIGN MENU-ITEM mi_copy:SENSITIVE IN MENU m_edit = l
             mi_duplicate:SENSITIVE   = l WHEN VALID-HANDLE(mi_duplicate)
             mi_erase:SENSITIVE       = l WHEN VALID-HANDLE(mi_erase)
             mi_topmost:SENSITIVE     = l WHEN VALID-HANDLE(mi_topmost)
             mi_bottommost:SENSITIVE  = l WHEN VALID-HANDLE(mi_bottommost)
             m_align:SENSITIVE        = l WHEN VALID-HANDLE(m_align).
      IF VALID-HANDLE(mi_topmost) THEN DO:
        /* The four menu-items above mi_topmost (but not the 2 rules) must
           be set according to l                                            */
        ASSIGN menu_handle = mi_topmost:PREV-SIBLING
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l.
      END.
    END.
    
    /* Edit/Cut cannot be done for Alternate layouts. */
    IF l AND CAN-FIND (FIRST _U WHERE _U._SELECTEDib 
                          AND _U._LAYOUT-NAME ne "{&Master-Layout}":U)
    THEN l = false.

    IF l NE MENU-ITEM mi_cut:SENSITIVE IN MENU m_edit 
    THEN MENU-ITEM mi_cut:SENSITIVE    IN MENU m_edit = l. 

    /* Set Tab Edit menu item's sensitivity based upon whether    */
    /* a single frame is selected, or a dialog box is active, and */
    /* the master layout is active.                               */
    
    /* IZ 839 Changing _U reference to a local buffer has         */
    /* undesirable side effects. Leave direct _U reference as is. */

    l = false.
    FOR EACH _U WHERE  _U._STATUS <> "DELETED":U AND
                       _U._TYPE = "FRAME":U AND
                       _U._SELECTEDib = TRUE:
      frame_cnt = frame_cnt + 1.
    END.

    IF frame_cnt = 1 AND VALID-HANDLE(_h_win) THEN DO:
      FIND _U WHERE _U._HANDLE = _h_win.
      FIND _L WHERE RECID (_L) = _U._lo-recid.
      l = _L._LO-NAME = "Master Layout".
    END.
    ELSE IF CAN-FIND (FIRST _U WHERE _U._TYPE = "DIALOG-BOX":U AND 
                            _U._HANDLE = _h_win AND
                            _U._STATUS <> "DELETED":U) THEN l = TRUE.
    
    IF VALID-HANDLE(mi_tab_edit) THEN ASSIGN mi_tab_edit:SENSITIVE = l. 
    
  END.  /* IF widget-check...*/
  
  /* jep-icf: Sensitize icf menubar if there is one. The menubar procedure uses the
     already set enable/disable states of the AB's default static menubar to enable/disable
     it's menubar. */
  IF VALID-HANDLE(_h_menubar_proc) THEN
    RUN sensitize_main_window IN _h_menubar_proc (INPUT pCheck).
  
END PROCEDURE. /* sensitize_main_window */


/* setBrowseRow
     When the user uses the mouse to change the height of a Browse Row, this
     gets called to store the change in the _C record.                       */
PROCEDURE setBrowseRow.
  FIND _U WHERE _U._HANDLE = SELF.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  ASSIGN _C._ROW-HEIGHT = SELF:ROW-HEIGHT.
  RUN adeuib/_winsave.p(_h_win, FALSE).         
END PROCEDURE. /* setBrowseRow */


/* setDataFieldEnable
     When drawing a data field for an object that is using a SmartData
     object, set the data field's Enable property based on the data object
     getUpdatableColumns. Must do this here since its not picked up automatically
     in the temp-table definition like format and label. Mainly used in a
     SmartObject that allows the drawing of SmartData field columns.
     jep-code 4/29/98 */
PROCEDURE setDataFieldEnable.

  DEFINE INPUT PARAMETER p-rec AS RECID  NO-UNDO.
  DEFINE BUFFER x_U            FOR _U.
  DEFINE BUFFER x_P            FOR _P.

  DEFINE VAR upd-fields    AS CHARACTER NO-UNDO.
  DEFINE VAR ret-msg       AS CHARACTER NO-UNDO.
  DEFINE VAR hSDO          AS HANDLE    NO-UNDO.
  DEFINE VAR lICFIsRunning AS LOGICAL   NO-UNDO.

  FIND x_P WHERE RECID(x_P) = p-rec.
  
  /* Get the handle of the SDO. */
  hSDO       = DYNAMIC-FUNCTION("get-proc-hdl" IN _h_func_lib, INPUT x_P._data-object).
  IF NOT VALID-HANDLE(hSDO) THEN RETURN.
  lICFIsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) NO-ERROR.

  /* Get the comma-list of updatable colums from the data object. */
  upd-fields = DYNAMIC-FUNCTION("getUpdatableColumns":U IN hSDO).
  /* Go through all SmartViewer fields that are not in the updatable list and set
     enable attribute to no. */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win
                 AND x_U._DBNAME = "Temp-Tables":U
                 AND x_U._TABLE  = "RowObject":U:
    IF NOT CAN-DO(upd-fields, x_U._NAME) THEN x_U._ENABLE = NO.
    IF lICFIsRunning = TRUE AND LOOKUP(x_P.OBJECT_type_code,
                                DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynView":U)) <> 0 THEN DO:
      ASSIGN x_U._TABLE = DYNAMIC-FUNCTION("ColumnTable":U IN hSDO, x_U._NAME) NO-ERROR.
      ASSIGN x_U._CLASS-NAME = "DataField":U
             x_U._OBJECT-NAME = x_U._TABLE + ".":U + x_U._NAME.
             x_U._LABEL-SOURCE = "E".
      IF NOT VALID-HANDLE(X_U._HANDLE:POPUP-MENU) THEN
        RUN createDataFieldPopup IN _h_uib (x_U._HANDLE).
    END.  /* If working with a dynamic viewer */
  END.
  ret-msg = DYNAMIC-FUNCTION("shutdown-proc" IN _h_func_lib, INPUT x_P._data-object).
END.


/* setdeselection is a procedure to set the universal widget record to be    */
/*           deselectioned each time that a widget becomes deselected.       */
PROCEDURE setdeselection.
  DEFINE BUFFER ipU FOR _U.

  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setdeselection"). &ENDIF
  FIND _U WHERE _U._HANDLE = SELF.
  ASSIGN _U._SELECTEDib = FALSE.
  IF _U._TYPE eq "FRAME":U THEN DO:   
    FIND _C WHERE RECID(_C) = _U._x-recid.
    IF NOT _C._SIDE-LABELS THEN 
      _C._FRAME-BAR:WIDTH-P = SELF:WIDTH-P -
                              (SELF:BORDER-LEFT-P + SELF:BORDER-RIGHT-P).
  END.
  /* Current widget must be selected */
  IF SELF EQ _h_cur_widg THEN DO:
    /* Is there another widget selected with the same parent? */
    FIND FIRST ipU WHERE ipU._SELECTEDib AND ipU._PARENT EQ _U._PARENT AND 
         ipU._HANDLE NE ? NO-ERROR.
    /* Is there another widget selected at all? */
    IF NOT AVAILABLE ipU
    THEN FIND FIRST ipU WHERE ipU._SELECTEDib 
                          AND ipU._STATUS ne "DELETED":U NO-ERROR.
    /* At least select the current window (unless it is a Design Window, in which
       case, look for a frame. */
    IF NOT AVAILABLE ipU 
    THEN FIND ipU WHERE ipU._HANDLE = _U._WINDOW-HANDLE NO-ERROR.
    /* Don't select a design window. */
    IF AVAILABLE ipU AND ipU._SUBTYPE eq "Design-Window":U 
    THEN FIND FIRST ipU WHERE ipU._TYPE eq "FRAME":U 
                          AND ipU._STATUS ne "DELETED":U
                          AND ipU._parent eq _U._WINDOW-HANDLE 
                        NO-ERROR.
    /* Set the current widget to the new ipU. */
    IF AVAILABLE ipU THEN DO:
       RUN curframe (ipU._HANDLE).
      _h_cur_widg = ipU._HANDLE.
    END.
    ELSE ASSIGN _h_cur_widg = ?.  
    RUN display_current.
  END. /* Deselecting the current widget. */
  ELSE DO:
    /* If there is now only one widget selected, then display it. */  
    FIND FIRST _U WHERE _U._SELECTEDib NO-ERROR.
    IF AVAILABLE _U AND 
       NOT CAN-FIND(FIRST ipU WHERE ipU._SELECTEDib 
                                AND ipU._HANDLE ne _U._HANDLE)
    THEN RUN changewidg (_U._HANDLE, false).
  END.
END.  /* PROCEDURE setdeselection */

/* setselect is a procedure to set the universal widget record to be         */
/*         selected each time that a widget becomes selected.  Note that     */
/*         we don't select widgets when the pointer is not selected          */
PROCEDURE setselect.
  &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("setselect"). &ENDIF
  DEFINE BUFFER f_U      FOR _U.
  DEFINE BUFFER ipU      FOR _U.
  DEFINE BUFFER f_L      FOR _L.
  DEFINE BUFFER linked_U FOR _U.
  DEFINE VAR    h_linked AS WIDGET NO-UNDO.
  DEFINE VAR    s        AS INTEGER NO-UNDO.    
  DEFINE VAR    utype    AS CHAR NO-UNDO.

  /* Select the current widget */
  FIND _U WHERE _U._HANDLE = SELF NO-ERROR.
  IF NOT AVAILABLE _U THEN RUN adeuib/_sanitiz.p.
  ELSE DO:    
    utype = _U._TYPE.
    /* Check the down frame iteration and display. */
    IF _U._TYPE eq "FRAME" THEN DO:
      FIND _C WHERE RECID(_C) = _U._x-recid.
      IF NOT _C._SIDE-LABELS THEN _C._FRAME-BAR:WIDTH-P = 1.
    END.  
    ELSE IF _U._PARENT:TYPE ne "WINDOW":U THEN DO:  
      /* Its not a frame, and its parent is not a window.   i.e. its
         parent is a frame, so check the iteration. */
      FIND f_U WHERE RECID(f_U) eq _U._parent-recid.
      FIND _C WHERE RECID(_C) eq f_U._x-recid.
      FIND f_L WHERE RECID(f_L) eq f_U._lo-recid.
      IF NOT f_L._NO-LABELS AND NOT _C._SIDE-LABELS  /* If column labels          */
      THEN RUN adeuib/_chkpos.p (INPUT SELF).        /* Check iteration & header  */
    END.
    IF VALID-HANDLE(mi_color) THEN DO:   
      IF utype = "IMAGE":U THEN
        /* Turn off color button if the current widget is an image */
        ASSIGN _h_button_bar[10]:SENSITIVE = FALSE
               mi_color:SENSITIVE        = FALSE.
      ELSE IF _cur_win_type AND _visual-obj THEN
        ASSIGN _h_button_bar[10]:SENSITIVE = TRUE
               mi_color:SENSITIVE        = TRUE.
    END.
            
    /* Mark the widget selected */
    _U._SELECTEDib = TRUE.
    /* If we are in the middle of BOX-SELECTION then don't update the screen. */
    IF NOT box-selecting THEN DO:
 
      /* Is there anything selected in any other window? If so, deselect it. */     
      IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                               AND ipU._WINDOW-HANDLE ne _U._WINDOW-HANDLE) 
      THEN RUN deselect_all (SELF, _U._WINDOW-HANDLE).
      
      /* Make this the current widget if the current widget is not also selected.*/
      IF NOT CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                                   AND ipU._HANDLE ne SELF) 
      THEN DO:
        IF NOT ((CAN-QUERY(_h_cur_widg,"SELECTED") EQ yes) AND _h_cur_widg:SELECTED)
        THEN RUN curwidg.     
      END.
      ELSE DO:  
        /* If there is more than one widget selected then there is no current
           widget.  Make sure that that is displayed.  Display-current will
           show-attributes.  However, if we don't call display-current, then
           call show-attributes directly so that we can update the display
           for the multiple selection. */
        _h_cur_widg = ?.
        IF h_display_widg ne _h_cur_widg 
        THEN RUN display_current.     
        ELSE DO:
          /* Show the current values of the selected set of widgets in the 
             Attributes window. */
          IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
          THEN RUN show-attributes IN hAttrEd NO-ERROR.

           /* Show the current values in the dynamic attribute window */
          IF VALID-HANDLE(_h_menubar_proc) THEN
             RUN Display_PropSheet IN _h_menubar_proc NO-ERROR.

          RUN show_control_properties (INPUT 0).
        END.
      END.     
    END.
  END.
END.  /* PROCEDURE setselect */

/* setstatus sets the WAIT cursor and writes a message to the status line.   */
/*           This is really just a front end to adeuib/_setcurs.p that also  */
/*           sets the status line.                                           */
PROCEDURE setstatus:
  DEFINE INPUT PARAMETER pcCursor AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER pcStatus AS CHAR NO-UNDO.  
  
  /* Set the cursor (if not unknown) */
  IF pcCursor ne ? THEN 
    RUN adecomm/_setcurs.p (pcCursor). 
  
  /* Set the status message (if not unknown) */
  IF pcStatus ne ? THEN 
    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Main}, pcStatus).

END PROCEDURE. /* setstatus */

/* setxy saves the current value of X and Y within a frame when          */
/*       the user clicks down (i.e. she is starting to draw a widget.)   */
PROCEDURE setxy:
  DEFINE VARIABLE utype AS CHAR NO-UNDO.
  
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setxy"). &ENDIF

  /* See where the user clicked and record this as the start of a draw.  */
  /* (if we are drawing)              */
  IF _next_draw eq  ? THEN ASSIGN _frmx = ?
                                  _frmy = ?.
  ELSE DO:
    /* Find the current object */
    FIND _U WHERE _U._HANDLE eq SELF.
    utype = _U._TYPE.
  
    /* Set the current frame/window context [and make curwidg unknown]. */
    RUN curframe (_U._HANDLE).

    ASSIGN  _frmx            = LAST-EVENT:X
            _frmy            = LAST-EVENT:Y
            _second_corner_x = ?
            _second_corner_y = ? .

    /* _frmx and _frmy need to be adjusted for non-resizable targets */
    IF utype = "SmartObject":U AND NOT SELF:RESIZABLE THEN
      ASSIGN _frmx = _frmx + SELF:X
             _frmy = _frmy + SELF:Y.
  END.
END.  /* PROCEDURE setxy */

/* setxy_lbl is only slightly similar to setuxy. It applies the lastkey */
/*           to the related fill-in (hopefully).                        */
PROCEDURE setxy_lbl.
  DEFINE BUFFER ipU for _U.
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setxy_lbl"). &ENDIF
  FIND _U WHERE _U._HANDLE = SELF.
  FIND ipU WHERE RECID(ipU) = _U._l-recid.

  APPLY LASTKEY TO ipU._HANDLE.
END.  /* PROCEDURE setxy_lbl */

/*
 * show-control-properties  Display the OCX property window
 */
PROCEDURE show_control_properties:

DEFINE INPUT PARAM p_Mode AS INTEGER NO-UNDO.

DEFINE VARIABLE multControls AS INTEGER     NO-UNDO INITIAL 0.
DEFINE VARIABLE s            AS INTEGER     NO-UNDO.
DEFINE VARIABLE windowList   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE windowActive AS CHARACTER   NO-UNDO.
DEFINE VARIABLE chFrame      AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE hdlCtl       AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE hdlColl      AS COM-HANDLE  NO-UNDO.

DEFINE BUFFER   x_U FOR _U.
DEFINE BUFFER   y_U FOR _U.

  IF NOT VALID-HANDLE(_h_Controls) THEN RETURN.

  IF (p_Mode = 2 OR p_Mode = 3) THEN
  DO:
    /* p_Mode of 2 is Hide property editor window for Run or Tools menu call. */
    IF (p_Mode = 2) THEN
    DO:
      ASSIGN PropEditorVisible = _h_Controls:PropertyEditorVisible.
      ASSIGN _h_Controls:PropertyEditorVisible = No.
      RETURN.
    END.
    /* p_Mode of 3 is Show property editor window after Run or Tools menu call. */
    IF (p_Mode = 3) THEN
    DO:
      ASSIGN _h_Controls:PropertyEditorVisible = PropEditorVisible.
      /* Return now because display_current calls this proc already
         from enable_widgets. */
      RETURN. 
    END.
  END.
    
  /* If there are no open windows then close the property editor. This is
   * needed to take down the property editor when the last window is closed.
   */
  RUN WinMenuGetActive(OUTPUT windowList, OUTPUT windowActive).
  IF LENGTH(windowList) = 0 THEN
  DO:
    /* Hide OCX Property Editor window. */
    _h_Controls:PropertyEditorVisible = No.
    RETURN.
  END.

  /* Figure out if 0, 1, or 2+ things are selected. The property editor
   * doesn't work with group edit.
   */
  FIND FIRST x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                   AND (    x_U._HANDLE = _h_cur_widg 
                        AND x_U._STATUS <> "DELETED":u)
                 NO-ERROR.
  IF AVAILABLE x_U THEN
  DO:
    /* There's at least one thing selected. But is there only one? */ 
    IF NOT CAN-FIND(FIRST y_U
                    WHERE y_U._SELECTEDib AND RECID(y_U) ne RECID(x_U))
    THEN multControls = 1.
    ELSE multControls = 2.
  END.
  
  IF multControls = 0 OR multControls = 2 THEN
  DO:
    /* Clear Property Editor window. */
    _h_Controls:ClearProperties.
    /* Show Property Editor window if mode calls for it. */
    IF p_mode = 1 THEN _h_Controls:PropertyEditorVisible = Yes.
  END.
  ELSE
  DO:
    /* Set window to edit current control. */
    chFrame = x_U._COM-HANDLE.    
    hdlColl = chFrame:Controls.
    hdlCtl  = hdlColl:Item(1) NO-ERROR. /* NO-ERROR in case control was not created. */
    RELEASE OBJECT hdlColl.
    _h_Controls:EditProperties(hdlCtl) NO-ERROR.
    /* Show Property Editor window if mode calls for it. */
    IF p_mode = 1 THEN _h_Controls:PropertyEditorVisible = Yes.
  END.    

END PROCEDURE.

/* switch_palette_menu: Toggles menu-only mode in the object palette */
PROCEDURE switch_palette_menu: /* by GFS 2/95 */
  DEFINE INPUT PARAMETER setting AS LOGICAL.
  
  DEFINE VARIABLE h  AS WIDGET-HANDLE.

  ASSIGN _h_object_win:HIDDEN = yes           /* hide palette window */
         h                    = _h_object_win /* get palette window */
         h                    = h:FIRST-CHILD /* 1st frame */
         _palette_menu        = setting.
  DO WHILE h <> ?:
    IF setting THEN h:HIDDEN = yes. ELSE h:HIDDEN = no.
    h = h:NEXT-SIBLING. /* next frame */
  END.
  IF setting THEN 
    ASSIGN _h_object_win:WIDTH-PIXELS = {&ImageSize} + {&ImageSize} * 2
           _h_object_win:MAX-WIDTH-P  = _h_object_win:WIDTH-P
    .
  ELSE 
    ASSIGN _h_object_win:MAX-WIDTH-PIXELS  = MIN((_palette_count * {&ImageSize}),SESSION:WIDTH-P)
    .
  RUN adeuib/_rsz_wp.p (INPUT no). /* resize palette window */
END.


PROCEDURE tapit.
  DEFINE BUFFER parent_U                FOR _U.
  DEFINE BUFFER parent_L                FOR _L.
  DEFINE BUFFER sync_L                  FOR _L.
  DEFINE VAR    recid-string            AS CHARACTER NO-UNDO.
  DEFINE VAR    x-increment             AS INTEGER   NO-UNDO.
  DEFINE VAR    y-increment             AS INTEGER   NO-UNDO.
  DEFINE VAR    h                       AS WIDGET    NO-UNDO.
  DEFINE VAR    h_parent                AS WIDGET    NO-UNDO.
  DEFINE VAR    tmp_x                   AS INTEGER   NO-UNDO.
  DEFINE VAR    tmp_y                   AS INTEGER   NO-UNDO.
  DEFINE VAR    other_action_taken      AS LOGICAL   NO-UNDO.
  DEFINE VAR    num_undoable_widgets    AS INTEGER   NO-UNDO.
  DEFINE VAR    max-height              AS INTEGER   NO-UNDO.
  DEFINE VAR    max-width               AS INTEGER   NO-UNDO.

  CASE LAST-EVENT:FUNCTION:
    WHEN "CURSOR-LEFT":U  THEN ASSIGN x-increment = -1.
    WHEN "CURSOR-RIGHT":U THEN ASSIGN x-increment =  1.
    WHEN "CURSOR-DOWN":U  THEN ASSIGN y-increment =  1.
    WHEN "CURSOR-UP":U    THEN ASSIGN y-increment = -1.
  END CASE.

  /* The following FOR EACH block checks if any of the selected widgets
     will be moved outside of the parent. It also builds a comma-separated
     list of recids of the selected widgets, which is used to see if we need
     to create a new sequence of undoable widgets.                             */
  FOR EACH _U WHERE _U._SELECTEDib AND
                    _U._STATUS <> "DELETED":
    FIND parent_U WHERE RECID(parent_U) = _U._parent-recid.
    FIND parent_L WHERE RECID(parent_L) = parent_U._lo-recid.

    ASSIGN h_parent   = parent_U._HANDLE
           h          = _U._HANDLE
           tmp_y      = h:Y + y-increment
           tmp_x      = h:X + x-increment
           max-width  = IF parent_U._TYPE = "FRAME" OR
                           parent_U._TYPE = "DIALOG-BOX" THEN
                          h_parent:WIDTH-PIXELS - 
                          (h_parent:BORDER-LEFT-PIXELS +
                           h_parent:BORDER-RIGHT-PIXELS)
                        ELSE
                          h_parent:WIDTH-PIXELS

           max-height = IF parent_U._TYPE = "FRAME" OR
                           parent_U._TYPE = "DIALOG-BOX" THEN
                          h_parent:HEIGHT-PIXELS - 
                          (h_parent:BORDER-TOP-PIXELS +
                           h_parent:BORDER-BOTTOM-PIXELS)
                        ELSE
                          h_parent:HEIGHT-PIXELS.
        
    IF tmp_y < 0 OR tmp_x < 0 OR
       (tmp_y + h:HEIGHT-P - 1 > max-height)   OR
       (tmp_x + h:WIDTH-P  - 1 > max-width) THEN  RETURN.

    ASSIGN recid-string = recid-string + STRING(RECID(_U)) + ",":U.  
  END.  /* For each selected object */
  recid-string = RIGHT-TRIM(recid-string, ",":U).

  /* Determine if other undoable actions (like Move, Resize or selecting
     another or different widgets) have been done since the last time; assume
     that another action has been taken.                                             */
  ASSIGN other_action_taken = TRUE.
  FIND LAST _action NO-ERROR.
  IF AVAILABLE _action THEN DO:

    IF _action._operation = "EndTapIt":U THEN
    test-tapit:
    DO:
      ASSIGN num_undoable_widgets = _action._seq-num - INT(_action._data) - 1.
      /* When this record was created we stored the starting sequence number
         in _action._data */
      
      IF NUM-ENTRIES(recid-string) = num_undoable_widgets THEN DO:
        /* This could be a continuation as at least the number of widgets is the same */
        LOOKING-FOR-START:
        DO WHILE TRUE:
          FIND PREV _action NO-ERROR.
          IF _action._operation = "StartTapIt" THEN LEAVE LOOKING-FOR-START.
          
          /* Compare the recid of the selected widgets in the previous undo
             sequence with the currently selected widgets. If there is a
             difference we want to create a new sequence in the undo stack;
             so leave test-tapit and 'other_action_taken' will be true
          */
          IF STRING(_action._u-recid) <>
             ENTRY(num_undoable_widgets, recid-string) THEN
            LEAVE test-tapit.  /* Not a match, must be a new series of TapIts */
          
          ASSIGN num_undoable_widgets = num_undoable_widgets - 1.
        END.  /* LOOKING-FOR-START: Do While True */
        
        /*  Have found the "StartTapIt" and it looks like this action is a 
            continuation of the same series                                 */
        ASSIGN other_action_taken = FALSE.
      END.  /* If num_undoable_widgets = NUM-ENTRIES */
    END.  /* test-tapit: DO: */
  END.  /* If available _action */

  /* At this point we are starting a new tapit series if other_action_taken is TRUE,
     or continuing an existing series if other_action_taken is FALSE.  If continuing
     then nothing needs to be done to the undo stack.  If starting then we need to
     create a StartTapIt record, followed by the positions of each selected object,
     followed by and EndTapIt record                                                */

  IF other_action_taken THEN DO:
    /* Create the initial StartTapIt record */
    CREATE _action.
    ASSIGN _undo-start-seq-num  = _undo-seq-num
           _action._seq-num     = _undo-seq-num
           _action._operation   = "StartTapIt"
           _undo-seq-num        = _undo-seq-num + 1
           num_undoable_widgets = 0.
  
    /* For each selected object, save its current position in a "TapIt" Record */
    FOR EACH _U WHERE _U._SELECTEDib AND
                      _U._STATUS <> "DELETED":
      /* For this widget, get a list of alternate layout _L's that are in sync
         with it because they need to be moved too!                            */
      FIND _L WHERE RECID(_L) = _U._lo-recid.
      recid-string = "".
      IF _L._LO-NAME = "Master Layout" THEN DO:
        FOR EACH sync_L WHERE sync_L._u-recid  = _L._u-recid AND
                              sync_L._LO-NAME NE _L._LO-NAME AND
                              NOT sync_L._CUSTOM-POSITION:
          recid-string = recid-string + STRING(RECID(sync_L)) + ",".
        END.
      END.  /* If changing the Master Layout */
      ELSE _L._CUSTOM-POSITION = TRUE.

      /* Now create the Undo record for this widget */
      CREATE _action.
      ASSIGN _action._seq-num       = _undo-seq-num
             _action._operation     = "TapIt"
             _action._u-recid       = RECID(_U)
             _action._window-handle = _U._WINDOW-HANDLE
             _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW)
             _action._other_Ls      = RIGHT-TRIM(recid-string,",")
             num_undoable_widgets   = num_undoable_widgets + 1
             _undo-seq-num          = _undo-seq-num + 1.

    END.  /* For each selected goodie */

    /* Now that the original positions have been saved, create the "EndTapIt" record */
    CREATE _action.
    ASSIGN _action._seq-num    = _undo-seq-num
           _action._operation  = "EndTapit"
           _undo-seq-num       = _undo-seq-num + 1
           _action._data       = STRING(_undo-start-seq-num)
           _undo-start-seq-num = ?.
    RUN UpdateUndoMenu("&Undo Tapit").
  END. /* If other_action_taken */

  /* Now just wiggle the widgets */  
  FOR EACH _U WHERE _U._SELECTEDib AND
                    _U._STATUS <> "DELETED":
    FIND _L WHERE RECID(_L) = _U._lo-recid.
    ASSIGN h       = _U._HANDLE
           h:Y     = h:Y + y-increment
           h:X     = h:X + x-increment
           _L._ROW = ((h:ROW - 1) / _cur_row_mult) + 1
           _L._COL = ((h:COL - 1) / _cur_col_mult) + 1.

    /* Adjusts for TTY Frames, and takes care of storing integer values for TTY. 
     Will overwrite the above assigned values when it needs to. */
    { adeuib/ttysnap.i &hSELF   = _U._HANDLE
                       &hPARENT = parent_U._HANDLE
                       &U_Type  = _U._TYPE
                       &Mode    = "MOVE"
                       }

    /* Move a fill-in's label */
    IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
      RUN adeuib/_showlbl.p (_U._HANDLE).
      _U._HANDLE:SELECTED = TRUE.
    END. /* For fill-ins and combos */

    /* If a SmartObject has been moved, use the set-position method to
       try and move it. */
    IF _U._TYPE = "SmartObject":U THEN DO:
      FIND _S WHERE RECID(_S) = _U._x-recid.
      IF _S._visual THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
        IF _P._adm-version < "ADM2" THEN
          RUN set-position IN _S._HANDLE (_L._ROW, _L._COL) NO-ERROR.
        ELSE
          RUN repositionObject IN _S._HANDLE (_L._ROW, _L._COL) NO-ERROR.        
      END.  /* IF _S._VISUAL */
    END.  /* If a SmartObject */

    /* Update the Geometry in the Attribute Window, if necessary. */
    IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
    THEN RUN show-geometry IN hAttrEd NO-ERROR.

     /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_ChangeGeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.

  END.  /* For each selected object */

  ASSIGN _undo-num-objects  = ?.

  /* The move operation is complete, now update the file-saved field */
  RUN adeuib/_winsave.p(_h_win, FALSE).
    
END. /* PROCEDURE tapit */


/* Message to tell users they can't manipulate test in alternative layouts */
PROCEDURE text_message.
  /* Text widgets are not changeable in an alternative layout */
  MESSAGE "Text objects may only be modified in the Master Layout." SKIP
          "Use a fill-in with the VIEW-AS-TEXT attribute instead."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* tool_choose - Select a tool (_next_draw).  Change the status bar to show
   the current tool and hide the up image associated with it. 
   
   cType = 0 if from palette
           1 if from palette menu or toolbar menu
           2 <future> tool bar menu
           3 other source
   
   tool  = The name of the palette tool to use. 
           ? if want to force another tool choose
           of the last tool.
   
   
 */  
procedure tool_choose:
  DEFINE INPUT PARAMETER cType  AS INTEGER                          NO-UNDO.
  DEFINE INPUT PARAMETER tool   AS CHAR                             NO-UNDO. 
  DEFINE INPUT PARAMETER custom AS CHAR                             NO-UNDO. 
  
  DEFINE VARIABLE cancelled      AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE cStatus_line   AS CHARACTER                       NO-UNDO. 
  DEFINE VARIABLE customTool     AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE filechosen     AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE ParentHWND     AS INTEGER                         NO-UNDO.
  DEFINE VARIABLE parse          AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE ptool          AS CHARACTER INITIAL "smartObject" NO-UNDO.
  DEFINE VARIABLE sameCustom     AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE sameTool       AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE saveCustom     AS RECID                           NO-UNDO.
  DEFINE VARIABLE saveCustomDraw AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE saveItem       AS RECID                           NO-UNDO.
  DEFINE VARIABLE saveNextDraw   AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE toolframe      AS WIDGET-HANDLE                   NO-UNDO.
  DEFINE VARIABLE unused         AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE tmpString      AS CHARACTER                       NO-UNDO.

  /*
   * The "rules" for tool choosing and locking:
   *
   *  1. Choosing the POINTER will set all flags and
   *     variables to ?
   *  2. Choosing a tool or custom different than the current
   *     object will change state to that tool or custom
   *     and the click_cnt set to 1
   *  3. Choosing the same tool will lock the tool in
   *     whatever was chosen in the previous click
   *  4. Choosing the same tool  again will unlock
   *     the tool.
   *  5. When the user clicks "too many" times on the same
   *     tool or custom the UIB will inform the user to
   *     "cut it out."
   *  6. If the user cancels out of any picker dialog box, 
   *     under any circumsance, the UIB will go to the POINTER
   *  7. Any custom item that forces a picker to be displayed
   *     breaks any lock
   *
   *  In effect the odd numbered clicks unlock the tool and
   *  bring up pickers / choose defaults. Even clicks lock
   *  the tool on the last pick.
   */
   
  /*
   * Don't set the watch cursor for all items, only those that
   * bring up a dialog box.
   */
   
  IF tool = "POINTER":U THEN DO:
      RUN choose-pointer.
      RETURN.
  END.

  /*
   * Force this tool choose to run like the
   * previous call
   */

/*message "tool" tool skip
        "custom" custom skip
        "ctype" cType skip
        view-as alert-box. */
  IF (tool = ?) AND (cType = 3) THEN DO:
  
    FIND _palette_item WHERE RECID(_palette_item) = _palette_choice NO-ERROR.
    IF AVAILABLE (_palette_item) THEN ASSIGN tool = _palette_item._name.
    ELSE RETURN.
  END. 
  /*
   * In case the user first comes in through the
   * "other path" before any tool is chosen.
   */
  IF tool = ? THEN RETURN.
    
  ASSIGN
    customTool       = custom
    saveItem         = _palette_choice
    saveCustom       = _palette_custom_choice
    widget_click_cnt = widget_click_cnt + 1
    goBack2pntr      = YES
    saveNextDraw     = _next_draw
    saveCustomDraw   = _custom_draw
  .
      
  FIND _palette_item WHERE _palette_item._name = tool.
  _palette_choice = recid(_palette_item).
      
  FIND _custom WHERE _custom._name = custom 
               AND   _custom._type = tool no-error.
  IF AVAILABLE _custom THEN DO:
    ASSIGN
      _palette_custom_choice = recid(_custom)
      parse = TRIM(_custom._ATTR)
    .
            /*message "   CUSTOM REC" skip
                "tool     " tool skip
                "custom   " custom skip
                "base type" _custom._type skip
                         view-as alert-box.  */

  END.
  ELSE DO:
    ASSIGN
      _palette_custom_choice = ?
      parse = TRIM(_palette_item._ATTR)
    .
         
    /*    message "NO CUSTOM REC" skip
                "tool     " tool skip
                "custom   " custom skip
                "cType    " cType skip
                "parse    " parse skip
                view-as alert-box. */
  END.                
  /* If the click count is 1 then the user
   * moved off the POINTER.
   */
 
  IF widget_click_cnt > 1 THEN DO:
     
     ASSIGN
       sameTool = (saveItem = _palette_choice)
       sameCustom = (saveCustom = _palette_custom_choice)
     .
           
     IF sameTool THEN DO:

       /*
        * The user is working in the same tool.
        */
 
       IF (cType = 0) THEN DO:
         
         /*
          * The tool_choose came from a palette icon
          * Lock/unlock the palette icon
          */
          
         RUN tool_lock (saveNextdraw, saveCustomdraw).
         IF ((widget_click_cnt modulo 2) = 0) THEN RETURN.
         IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN RETURN.
         
       END.
       ELSE IF cType = 3 THEN DO:
         /*
          * The tool_choose came from an outside source
          * (the lock status area is one case). Perform
          * the same operations as if cType = 0 
          */
          
         RUN tool_lock (saveNextdraw, saveCustomdraw).
         IF ((widget_click_cnt modulo 2) = 0) THEN RETURN.
         
         /*
          * We've just unlocked.If we're working with a picker
          * then don't bring it up in this case
          */
          
         IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN RETURN.
         
       END.
       ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN DO:
       
         /*
          * The tool_choose came from a menu and the custom
          * item is a picker. Break the lock.
          */
         
         widget_click_cnt = 1.
         RUN tool_lock (saveNextdraw, saveCustomdraw). 
         
       END.
       ELSE IF sameCustom THEN DO:
       
         /*
          * The exact same tool and custom was picked
          * twice in row. Force the lock.
          */
         widget_click_cnt = 2.          
         RUN tool_lock (saveNextdraw, saveCustomdraw).

         RETURN.
         
       END.
       ELSE
         ASSIGN 
           goBack2pntr      = YES
           widget_click_cnt = 1
        .
    
  END.
     ELSE
       ASSIGN 
         goBack2pntr      = YES
         widget_click_cnt = 1
       .
  END.
          
  /* Special cases - Browses or dbFields with no connected databases */
  IF _palette_item._dbconnect AND NUM-DBS = 0 THEN DO:
     /* If we find the term 'object' anywhere in the palette item name,
        don't bother adding the 'object' part to the message we'll give
        the customer. Keeps from displaying something like
        'create a SmartObject object.' - jep */
     IF INDEX(_palette_item._name, 'object':U) = 0 THEN
        tmpString = " object.".
     ELSE
        tmpString = ".".
        
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to " 
            + (IF   _palette_item._name = "DB-FIELDS" THEN "add database fields."
               ELSE "create a " + _palette_item._name + tmpString),
      OUTPUT ldummy).
    IF ldummy eq no THEN 
    DO:
       RUN choose-pointer.
       RETURN.
    END.
  END.
  
  /* If tool is text and not master layout give message and return */
  IF tool = "TEXT":U THEN DO:
    FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
    IF AVAILABLE _U THEN DO:
      IF _U._LAYOUT-NAME NE "Master Layout" THEN DO:
        MESSAGE "Text objects may only be drawn in the Master Layout." SKIP
                "Use a fill-in with the VIEW-AS-TEXT attribute instead."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN.
      END.
    END.
  END.
  

  /* Now see if we have a pointer or other tool */
  
  DO WITH FRAME widget_icons:
  
    /* Which palette entry corresponds to this tool */
    FIND _palette_item WHERE _palette_item._NAME = tool NO-ERROR.
    
    /* "Restore" the old choice to its "up" state */
    
      IF hDrawTool NE ? AND hDrawTool:PRIVATE-DATA NE tool
        THEN hDrawTool:HIDDEN    = NO.
    
      IF h_lock NE ? THEN h_lock:HIDDEN       = YES.
    
      ASSIGN toolframe         = hDrawTool:FRAME
             toolframe:BGCOLOR = ?.
 
      /* "Depress" the new choice widget tool by hiding it. */
    
      ASSIGN
          hDrawTool   = _h_up_image
          h_lock      = WIDGET-HANDLE(ENTRY(2,_h_up_image:PRIVATE-DATA)).
    
      IF NOT hDrawTool:HIDDEN THEN hDrawTool:HIDDEN = YES. 
      IF NOT h_lock:HIDDEN    THEN h_lock:HIDDEN = YES.
    
      ASSIGN toolframe         = hDrawTool:FRAME
             toolframe:BGCOLOR = 7.
      
 /* For SmartObjects, the user could have chosen "NEW" or cancel from
     * a "CHOOSE", in which case we don't want to do anything
     */
 IF _palette_item._TYPE <> {&P-BASIC} THEN DO: /* custom icon, SmartObject or OCX control*/
      IF custom eq "NEW" THEN DO:
          IF _palette_item._New_Template <> "" THEN DO:
            FILE-INFO:FILE-NAME = _palette_item._New_Template.
            RUN adeuib/_open-w.p (FILE-INFO:FULL-PATHNAME, "",
                                  "UNTITLED").
          END.
          RUN choose-pointer.
          RETURN.
      END.
      ELSE DO:
        /* If this a OCX control then call out to the OCX picker */
        IF ENTRY(1, parse, CHR(10)) BEGINS "CONTROL" THEN
          ASSIGN _object_draw = entry(2, parse, CHR(10))
                 customTool   = entry(3, parse, CHR(10))
                 tool         = "{&WT-CONTROL}".
        ELSE IF tool = "{&WT-CONTROL}" THEN DO:
          run adecomm/_setcurs.p("WAIT").
          ASSIGN SESSION:DATE-FORMAT = _orig_dte_fmt.

          /* Present OCX dialog via call to PROX. Get window parent handle
             to position OCX dialog over Palette window. */
          RUN GetParent(INPUT _h_object_win:HWND, OUTPUT ParentHWND).
          ASSIGN _ocx_draw = _h_Controls:GetControl(ParentHWND) NO-ERROR.

          /* _ocx_draw will contain a valid com-handle. */
          IF VALID-HANDLE(_ocx_draw) THEN DO:
            ASSIGN
              _object_draw = _ocx_draw:ClassID
              _custom_draw = _ocx_draw:ShortName
              customTool   = _custom_draw.
          END.
          ELSE _object_draw = ?.
          
          run adecomm/_setcurs.p("").
        END.
        ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "USE" THEN
            _object_draw = TRIM(SUBSTRING(ENTRY(1,parse,CHR(10)),4,-1,"CHARACTER")).
        ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN DO:
          run adecomm/_setcurs.p("WAIT").
          ASSIGN SESSION:DATE-FORMAT = _orig_dte_fmt.
          IF tool = "SmartDataObject":U THEN ptool = tool. /* Otherwise smartObject */
          RUN adecomm/_chosobj.w (INPUT ptool,
                                  INPUT parse, 
                                  INPUT _palette_item._New_Template,
                                  INPUT "BROWSE,NEW,PREVIEW",
                                  OUTPUT filechosen,
                                  OUTPUT unused,
                                  OUTPUT cancelled).
          IF filechosen <> "" THEN _object_draw = filechosen.
          ELSE ASSIGN _object_draw = ?.
        END.  /* IF directory list */
        
        IF _object_draw eq ? THEN DO:

          /*
           * If there is no object draw at this point (usually happens when
           * a user cancels out of a picker) then go back to the pointer
           *
           */
          RUN choose-pointer.
          RETURN.
  
        END. 

      END. /* NOT "NEW" */
    END. /* NOT TYPE 1 */
 
    /* If we were in Pointer mode (next_draw = ?) and are now in draw mode,
       then make everything deselectionable (and deselectioned) if the
       last value of _next_draw was a pointer. Also set unmovable. */
    IF _next_draw EQ ? THEN DO:
      FOR EACH _U WHERE _U._HANDLE <> ? AND
          NOT CAN-DO("WINDOW,DIALOG-BOX,MENU,SUB-MENU,MENU-ITEM", _U._TYPE):
        ASSIGN _U._HANDLE:MOVABLE    = FALSE
               _U._HANDLE:SELECTABLE = FALSE
               _U._SELECTEDib        = FALSE.
      END.
    END.
    
    /* "Depress" the new choice widget tool by hiding it. */
    IF _palette_item._type eq {&P-BASIC} THEN _object_draw = ?. 
    ASSIGN _next_draw   = tool
           _custom_draw = customTool.

    /* Set mouse pointer to selected item */
    RUN adeuib/_setpntr.p (_next_draw, input-output _object_draw).
  
    /* Show the user what the current tool is (in the HELP attribute of the
       drawing tool. */
    IF custom eq ? 
    THEN cStatus_Line = hDrawTool:HELP.  /* eg. "Button" or "Selection-List" */
    ELSE DO:
      /* Set the status line to custom (eg.  "OK" or "Cancel").  */
      cStatus_line = custom.
      /* Remove underbars (& characters), but not ampersands (&&) */
      cStatus_line = REPLACE (  REPLACE ( REPLACE (
                        cStatus_line,
                        "&&":U,CHR(10)),
                        "&":U, "":U),
                        CHR(10), "&&":U).
      /* We would like the status line to list the widget type as well, 
         so add the hDrawTool:HELP  if we isn't already in the custom name.  
         (eg. if custom = "OK Button" we don't o say "OK Button Button".) */
      IF INDEX(cStatus_line, hDrawTool:HELP) eq 0
      THEN cStatus_line = RIGHT-TRIM(cStatus_line) + " ":U + hDrawTool:HELP.
    END.

    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Tool}, cStatus_line).
    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, 
                            IF goBack2Pntr THEN "" ELSE "Lock").
  END. /* IF _next_draw = ?..ELSE... */

END PROCEDURE. /* Click on on widget tool button */

/* tool_lock - Select and "lock" a tool (_next_draw).  Clicking if
   if already locked, toggles it off. Continured clicking on the same tool
   (i.e. they are clicking on the hilite object or the lock) brings up an
   error message. (clicking off an icon also toggles the state).  
   
   If tool is UNKNOWN then assume it is the current tool. */

procedure tool_lock:
  DEFINE INPUT PARAMETER tool   AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER custom AS CHAR NO-UNDO.

  DEFINE VAR thing     AS CHAR. /* text string for what we are drawing      */
  DEFINE VAR draw_in_a AS CHAR. /* where drawing goes ("frame" or "window") */
  /* Tool defaults to the current tool. */
  IF tool eq ? THEN tool = _next_draw .
  IF custom eq ? THEN custom = _custom_draw .

  /* Make sure the desired tool is actually selected. (This will select it
     as being NOT locked.  The following line will lock it. */
    
  IF (_next_draw <> "{&WT-CONTROL}") THEN DO:
  
     IF (tool ne _next_draw) OR (custom ne _custom_draw) 
     THEN RUN tool_choose (tool, custom).
  
  END.
  /* Lock has no effect in Pointer mode (_next_draw eq ?). */
  IF _next_draw NE ? THEN DO:
    /* Toggle the lock state .*/
    goBack2pntr   = ((widget_click_cnt modulo 2) <> 0).
    h_lock:HIDDEN = goBack2pntr.

    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, 
                            IF goBack2Pntr THEN "" ELSE "Lock"). 
  END.

  IF (widget_click_cnt > 6) AND (_uib_prefs._user_hints) THEN DO:
     widget_click_cnt = 1. /* Reset the counter */
     IF _next_draw = ?
     THEN MESSAGE "You have already chosen the POINTER tool.  This tool" {&SKP}
                  "allows you to select and move objects that you have" {&SKP}
                  "already created. Double-clicking on an object will" {&SKP}
                  "bring up the Attribute Editor for that object."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Pointer Tool".
     ELSE DO:
       ASSIGN draw_in_a = IF _next_draw = "FRAME" THEN "window or frame" ELSE "frame"
              thing     = IF _next_draw = "SCHEMA-LIST" THEN "DB FIELDS"
                          ELSE IF _next_draw = "TOGGLE" THEN "TOGGLE BOX"
                          ELSE _next_draw.
       MESSAGE "You have already chosen the" thing "tool." {&SKP}
               "There are two ways to create a new" thing "object -" SKIP
               " 1) Click & Drag to define a position and size; OR" SKIP
               " 2) Click in a" draw_in_a "to create a default" thing SKIP SKIP
               "NOTE: Clicking with MOUSE-EXTEND will ~"lock~" your " {&SKP}
               "choice of drawing tool."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Information".
     END.
   END.
END PROCEDURE.

/* Enables/Disables the UIB's Stop button image when user runs code. */
PROCEDURE uib-stopbutton.

  DEFINE INPUT PARAMETER p_Stop_Button AS WIDGET  NO-UNDO.
  DEFINE INPUT PARAMETER p_Sensitive   AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hWindow  AS WIDGET  NO-UNDO.  /* UIB Main window */
  DEFINE VARIABLE hFrame   AS WIDGET  NO-UNDO.
  DEFINE VARIABLE ldummy   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Imm_Disp AS LOGICAL NO-UNDO.

  DO ON STOP   UNDO, LEAVE
     ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE :
     
  ASSIGN Imm_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
      
  /* We must enable the UIB Main window for input as well as the
     Stop button/image. Ditto for disabling.

     By enabling the window, we must handle window events.  This is done
     in _uibmain.p.

  */  
  ASSIGN hFrame                  = p_Stop_Button:FRAME
         hWindow                 = hFrame:PARENT
         hWindow:SENSITIVE       = p_Sensitive
         p_Stop_Button:SENSITIVE = p_Sensitive
         p_Stop_Button:HIDDEN    = NOT p_Sensitive
         ldummy                  = IF p_Sensitive
                                   THEN p_Stop_Button:MOVE-TO-TOP()
                                   ELSE p_Stop_Button:MOVE-TO-BOTTOM() 
  . /* ASSIGN */
  
  END. /* DO */
  
  /* Restore this session attribute. */
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Imm_Disp.  
  
END PROCEDURE.

PROCEDURE update_palette :

  RUN setstatus ("WAIT":U, "Rebuilding palette icons and menus...":U).
  RUN copyPaletteCustom.
  FOR EACH _custom: /* remove old _custom records */
    DELETE _custom.
  END.    
  /* We are going to rebuild the palette window, after first hiding it.
     The Window System might then choose some other windows (eg. the 
     Program Manager) to take focus.  Avoid this by explicitly moving
     focus to the UIB main window. */  
  APPLY "ENTRY" TO _h_menu_win.
  RUN adeuib/_initpal.p.           /* re-initialize the palette */
  RUN adeuib/_cr_cust.p (INPUT no).           /* read new custom file */
  IF RETURN-VALUE = "_CANCEL" THEN RUN restorePaletteCustom.
  RUN adeuib/_cr_pal.p(INPUT yes). /* delete old palette items and rebuild */
  RUN adeuib/_cr_cmnu.p(INPUT MENU m_toolbox:HANDLE). /* add custom menus */

  /* Create popup menu on the 'New' button */
  RUN adeuib/_cr_npop.p (INPUT _h_button_bar[1]).
  ASSIGN hDrawTool = ?
         h_Lock    = ?.
  FIND _palette_item WHERE _palette_item._NAME = "Pointer".
  ASSIGN h_wp_pointer = _h_up_image.
  RUN choose-pointer.

  /* Reset the cursor pointer in all windows */
  RUN setstatus ("":U, "":U).
  
END.

/* wind-close  - delete the current window  */
procedure wind-close.
  DEFINE INPUT PARAMETER h_self  AS WIDGET NO-UNDO.
  
  DEFINE VAR save_opt   AS LOGICAL           NO-UNDO.
  DEFINE VAR cancel     AS LOGICAL           NO-UNDO.
  DEFINE VAR context    AS CHAR              NO-UNDO.
  DEFINE VAR file-name  AS CHAR              NO-UNDO.
  DEFINE VAR tmp-name   AS CHAR              NO-UNDO.
  DEFINE VAR lib_parent AS CHAR              NO-UNDO.
  DEFINE VAR askToSave  AS LOGICAL           NO-UNDO INITIAL FALSE.
  DEFINE VAR tmp_hSecEd AS HANDLE            NO-UNDO.
  DEFINE VAR hPropSheet AS HANDLE            NO-UNDO.
  
  FIND _U WHERE _U._HANDLE = h_self NO-ERROR.
  FIND _P WHERE _P._u-recid eq RECID(_U).

  /* jep-icf: Change the file saved state of design window based on prop sheet. */
  IF VALID-HANDLE(_P.design_hpropsheet) THEN
    ASSIGN _P._FILE-SAVED = NOT DYNAMIC-FUNC('isModified':u IN _P.design_hpropsheet) NO-ERROR.
  
  ASSIGN /* dma */
    tmp_hSecEd = hSecEd
    hSecEd     = _P._hSecEd.
    
  /* IZ 1508 This call can create a Section Editor window for
     a procedure that's being closed. Only make the call if the
     procedure already has a Section Editor window open for it. - jep */
  /* SEW call to store current trigger code for specific window. */
  IF VALID-HANDLE(_P._hSecEd) THEN
    RUN call_sew ( INPUT "SE_STORE_WIN").

  /* If the file is dirty then save, if not, then check to
     see if OCX controls are dirty */
  IF _P._FILE-SAVED EQ no THEN askToSave = yes.
  ELSE IF (OPSYS = "WIN32":u) THEN
  DO: /* OCX Dirty Check */
     RUN is_control_dirty(h_self, output askToSave).
  END.
 
  IF askToSave = yes THEN DO: 
    /* This save question should be similar to the one for dialogs and in closeup.p */
    /* Set default responce to "YES - Save changes! "                  */
    ASSIGN save_opt = yes
           tmp-name = IF _U._SUBTYPE eq "Design-Window" THEN _U._LABEL
                      ELSE _U._NAME.

    MESSAGE (IF _P._SAVE-AS-FILE <> ? 
            THEN tmp-name + " (" + _P._SAVE-AS-FILE  + ") " 
            ELSE tmp-name ) SKIP
           "This window has changes which have not been saved." SKIP(1)
           "Save changes before closing?"
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL UPDATE save_opt.
    IF save_opt THEN RUN save_window (INPUT no, OUTPUT cancel).
    ELSE IF save_opt = ? THEN cancel = yes.
    IF cancel THEN DO: /* dma */
      hSecEd = tmp_hSecEd.
      RETURN.
    END.
  END.
  
  /* IZ 839 Save_window calls sensitize_main_window, which can move the current
     record out of _U so it's no longer available. Refind it here just in case. */
  FIND _U WHERE _U._HANDLE = h_self NO-ERROR.
    
  /* Check with source code control programs and see if we really should close 
     the file.  [Save the context and file name so that we can report the
     event after the file has closed and _U is no longer valid.] */
   ASSIGN context    = STRING(RECID(_U))
          file-name  = _P._SAVE-AS-FILE
          lib_parent = STRING(_U._WINDOW-HANDLE).
  RUN adecomm/_adeevnt.p 
         (INPUT "UIB", "Before-Close", context, file-name,
          OUTPUT save_opt).
  IF save_opt THEN DO:
    RUN PurgeActionRecords( _U._HANDLE ).

    /* Hide the window to prevent flashing. */
    h_self:HIDDEN = TRUE.

    /* Delete this procedure's Section Editor, if it exists, and the "Display
       multiple Section Editors" preference has been selected. (dma) */
    IF _multiple_section_ed THEN
      RUN call_sew ( INPUT "SE_EXIT").

    /* db: dynamics propertysheet unregister */
    IF VALID-HANDLE(_h_menubar_proc) THEN
    DO:
        hPropSheet = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
        IF VALID-HANDLE(hpropSheet) THEN
        DO:
          RUN unregisterObject IN hPropSheet (INPUT _h_menuBar_proc,
                                              INPUT STRING(_U._WINDOW-HANDLE),
                                              INPUT "*").
          RUN destroyObject IN hPropSheet.
        END.
    END.

    /* Tell the dynamics property sheets, like the Container Builder to close
       before we delete the frames, widgets, etc. */
    IF VALID-HANDLE(_P.design_hpropsheet) THEN
      PUBLISH "closePropSheet":U FROM _P.design_hpropsheet.

    /* Delete all the contained widgets. This will recursively call itself
       and delete contained frames. */
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash */) .
    
    /* Delete the procedure record */
    {adeuib/delete_p.i} 

    
    /* Have we deleted the current widget */
    RUN del_cur_widg_check.

    /* Deactivate any layouts not being used any more */
    FOR EACH _layout WHERE _layout._LO-NAME NE "Master Layout" AND _layout._ACTIVE:
      IF NOT CAN-FIND(FIRST _L WHERE _L._LO-NAME = _layout._LO-NAME) THEN
        _layout._ACTIVE = FALSE.
    END.

    /* Note the CLOSE as being finished */
    RUN adecomm/_adeevnt.p 
         (INPUT "UIB", "Close", context, file-name, OUTPUT save_opt).

    /* Tell the ADE LIB-MGR Object that this UIB object is closing. */
    IF VALID-HANDLE( _h_mlmgr ) THEN
        RUN close-parent IN _h_mlmgr ( INPUT lib_parent ).

    /* Update the Window menu active window items. */
    RUN WinMenuRebuild IN _h_uib.
  
    /* Update hSecEd for current window. (dma) */
    IF NOT AVAILABLE _P THEN
      FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win NO-ERROR.
    IF AVAILABLE _P THEN
      RUN call_sew_setHandle (INPUT _P._hSecEd).
    /* Don't add an ELSE here that sets the section editor handle
       to ?. Doing so can cause AB to create extra section editor
       instances when they aren't necessary.

       See bug 19991013-024 "Extra Section Editor instances created"
       for details. - jep Oct 13, 1999. */

  END.
END.  /* procedure wind-close...*/

/* wind-select-down  - short tag to run this on window select down */
procedure wind-select-down.
  RUN curwidg.
  RUN adeuib/_windsdn.p.
END.

/* wind-select-up  - short tag to run this on window select up.  */
/*                   Look at the function and decide what to do. */
procedure wind-select-up.
  DEFINE VAR action-string       AS CHAR                               NO-UNDO.

  /* If we are not drawing, then see if we want to go into the property sheet */
  IF _next_draw eq ? THEN DO:  
    IF LAST-EVENT:FUNCTION eq "MOUSE-SELECT-DBLCLICK":U 
    THEN RUN double-click.
    ELSE RUN curwidg.
  END.
  ELSE DO:

    /* We can only draw FRAMES and SmartObjects in a Window */
    IF    CAN-DO ("FRAME,QUERY":U, _next_draw)
       OR ((_object_draw ne ?) /* i.e. SmartObject */
            AND (_next_draw <> "{&WT-CONTROL}":U))
    THEN DO:
      /* Draw these legal cases */
      CASE LAST-EVENT:FUNCTION :
        WHEN "":U THEN RUN drawobj-in-box.
        WHEN "MOUSE-SELECT-CLICK":U THEN RUN drawobj.
      END CASE.
    END.
    ELSE DO: /* Report illegal cases */
      /*  Action_string will be either "create" or "select" depending on 
          whether any frames exist */
      IF CAN-FIND (_U WHERE _U._WINDOW-HANDLE eq SELF 
                        AND _U._TYPE eq "FRAME":U
                        AND _U._STATUS ne "DELETED":U)
      THEN action-string = "select".
      ELSE action-string = "create".
      MESSAGE "An" _next_draw "object cannot be drawn outside a frame." SKIP
              "Please" action-string  "a frame."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
  END.
END PROCEDURE.

/* wind-event - common processor of all PERSISTENT window and dialog events . */
/*            NOTE: ENTRY events are ignored under MOTIF because they happen  */
/*            every time the mouse crosses the window. (wood 9/15/93).        */
/* NOTE: this used to be an exteranl .p (_winevnt.p) before we could run      */
/* persistent triggers IN a given context.                                    */
PROCEDURE wind-event:
  DEF INPUT PARAMETER p_case AS CHAR NO-UNDO.
  
  /* NOTE: there have been reported cases of events being issued to a 
     deleted window.  For example, the MS-WINDOW's Task Manager closes a
     PROGRESS window by first sending the CLOSE event, then the ENTRY event.
     ENTRY fails because the window is no longer valid. 
     
     The following check is purely to handle this degenerate case */
  IF NOT VALID-HANDLE(SELF) THEN RETURN.
   
  CASE p_case:
    WHEN "DIALOG-CLOSE"     THEN RUN dialog-close (SELF).
    WHEN "DIALOG-MINIMIZED" THEN DO:
      RUN adeuib/_vldwin.p (SELF:FIRST-CHILD).
      RUN display_current.
    END.
    WHEN "DIALOG-MAXIMIZED" THEN 
    DO: 
     &IF "{&WINDOW-SYSTEM}" ne "OSF/MOTIF" &THEN
        IF SELF NE _h_win THEN DO:
          IF NOT VALID-HANDLE(_h_win) THEN _h_win = SELF:FIRST-CHILD.
          RUN curframe(SELF:FIRST-CHILD).
          RUN display_current.
          RUN show_control_properties (INPUT 0).
        END.
     &ENDIF
    END.
    WHEN "DIALOG-RESTORED" THEN 
    DO: 
     &IF "{&WINDOW-SYSTEM}" ne "OSF/MOTIF" &THEN
        IF SELF NE _h_win THEN DO:
          IF NOT VALID-HANDLE(_h_win) THEN _h_win = SELF:FIRST-CHILD.
          RUN curframe(SELF:FIRST-CHILD).
          RUN display_current.
          RUN show_control_properties (INPUT 0).
        END.
     &ENDIF
    END.
    WHEN "WINDOW-CLOSE"     THEN RUN wind-close (SELF).
    WHEN "WINDOW-ENTRY" OR WHEN "DIALOG-ENTRY":U THEN DO: 
      IF SELF:TYPE EQ "WINDOW" AND SELF:WINDOW-STATE NE WINDOW-MINIMIZED AND
         SELF NE _h_win THEN DO:
        IF NOT VALID-HANDLE(_h_win) THEN _h_win = SELF.
        RUN curwidg.
        RUN show_control_properties (INPUT 0).
      END.
    END.
    WHEN "WINDOW-MINIMIZED" THEN DO:
      RUN adeuib/_vldwin.p (SELF).
      RUN display_current.
    END.
    OTHERWISE MESSAGE "Unexpected Window Event called:" p_case.
  END CASE.
END PROCEDURE.

/* WinExec
 *      Run a Windows program using Win32 API
 */
PROCEDURE WinExec EXTERNAL "KERNEL32.DLL":
  DEFINE INPUT PARAMETER prog_name  AS CHARACTER.
  DEFINE INPUT PARAMETER prog_style AS LONG.
END.

/* WinMenuGetActive -                                                       */
/*      Return delimited window title list of all active AB design          */
/*      windows and the current active title.                               */
PROCEDURE WinMenuGetActive :
  DEFINE OUTPUT PARAMETER p_ActiveWindows AS CHARACTER  NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE OUTPUT PARAMETER p_ActiveItem    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER x_P FOR _P.
  
  DEFINE VARIABLE Delim        AS CHARACTER NO-UNDO INITIAL ",":U.
  DEFINE VARIABLE hWindow      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE h_active_win AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER NO-UNDO.
  
  DO:
    ASSIGN h_active_win = _h_win.
    /* _h_win can be invalid if the current active window got deleted/closed. */
    IF NOT VALID-HANDLE( h_active_win ) THEN
    DO:
        /* Make the first valid window the active window. */
        FOR EACH x_P NO-LOCK:
            IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
            ASSIGN h_active_win = x_P._WINDOW-HANDLE.
        END.
        IF NOT VALID-HANDLE(h_active_win) THEN RETURN.
    END.
    
    ASSIGN h_active_win = (IF h_active_win:TYPE = "WINDOW":U
                           THEN h_active_win ELSE h_active_win:PARENT).
    FOR EACH x_P NO-LOCK :
        IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
        ASSIGN hWindow = x_P._WINDOW-HANDLE
               hWindow = (IF hWindow:TYPE = "WINDOW":U
                          THEN hWindow ELSE hWindow:PARENT).
        IF NOT VALID-HANDLE( hWindow ) THEN NEXT.
        
        ASSIGN p_ActiveWindows = p_ActiveWindows + Delim + hWindow:TITLE.
        IF (hWindow = h_active_win) THEN       
          ASSIGN p_ActiveItem = h_active_win:TITLE.
          
        /* Add this window's Section Editor, if it's visible. (dma) */
        IF VALID-HANDLE(x_P._hSecEd) THEN DO:
          RUN GetAttribute IN x_P._hSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
          hWindow = WIDGET-HANDLE(cHandle).
          IF NOT VALID-HANDLE(hWindow) THEN NEXT.
          
          IF hWindow:VISIBLE THEN
            ASSIGN p_ActiveWindows = p_ActiveWindows + Delim + hWindow:TITLE.
        END.
    END.
    ASSIGN p_ActiveWindows = TRIM(p_ActiveWindows, Delim).
  END.

END PROCEDURE.

/* WinMenuRebuild -                                                         */
/*      Rebuild the Window menu active window items and assign one as the   */
/*      current active window.                                              */
PROCEDURE WinMenuRebuild :
  DEFINE VAR ActiveWindows AS CHARACTER  NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE VAR ActiveItem    AS CHARACTER  NO-UNDO.

  DO:
    IF NOT VALID-HANDLE( _h_WinMenuMgr ) THEN RETURN.
       
    RUN WinMenuGetActive IN THIS-PROCEDURE
        (OUTPUT ActiveWindows , OUTPUT ActiveItem).
    
    RUN WinMenuRebuild IN _h_WinMenuMgr
        (INPUT _h_WindowMenu ,
         INPUT ActiveWindows , INPUT ActiveItem , INPUT THIS-PROCEDURE).
         
  END.

END PROCEDURE.

/* WinMenuChoose -                                                          */
/*      Handles the action where user chooses an active window from the     */
/*      Window menu or More Windows dialog.  This procedure is actually     */
/*      called by the WinMenuMgr object. The active window items run        */
/*      a routine in the WinMenuMgr and that in turn calls this procedure   */
/*      with window title of the window to make current.                    */
PROCEDURE WinMenuChoose :
  DEFINE INPUT PARAMETER p_ActiveItem AS CHARACTER      NO-UNDO.
         /* Title of active window menu item chosen. */

  DEFINE BUFFER x_P FOR _P.
  
  DEFINE VARIABLE hWindow      AS HANDLE         NO-UNDO.
  DEFINE VARIABLE lIsSE        AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE RetValue     AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER      NO-UNDO.

  DO:
    IF NOT VALID-HANDLE( _h_WinMenuMgr ) THEN RETURN.
    FOR EACH x_P NO-LOCK :
        IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
        ASSIGN hWindow         = x_P._WINDOW-HANDLE
               hWindow         = (IF hWindow:TYPE = "WINDOW":U
                                  THEN hWindow ELSE hWindow:PARENT).
        IF NOT VALID-HANDLE(hWindow) THEN NEXT.
        
        IF (hWindow:TITLE <> p_ActiveItem) THEN DO:
          /* Did user select this window's Section Editor instance? (dma) */
          IF VALID-HANDLE(x_P._hSecEd) THEN DO:
            RUN GetAttribute IN x_P._hSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
            hWindow = WIDGET-HANDLE(cHandle).
            IF NOT VALID-HANDLE(hWindow) THEN NEXT.
            
            IF (hWindow:VISIBLE AND hWindow:TITLE <> p_activeItem) OR
              NOT hWindow:VISIBLE THEN NEXT.
            ASSIGN lIsSE = TRUE.
          END.
          ELSE NEXT.
        END.
        
        /* We've found the window to make active. */
        ASSIGN hWindow:WINDOW-STATE = WINDOW-NORMAL
                       WHEN hWindow:WINDOW-STATE = WINDOW-MINIMIZED
               hWindow:VISIBLE      = YES
               RetValue             = hWindow:MOVE-TO-TOP().
  
        /* Only "make current" if its not already current. */
        IF x_P._WINDOW-HANDLE <> _h_win AND NOT lIsSE THEN
        DO:
            RUN changewidg (INPUT x_P._WINDOW-HANDLE , INPUT TRUE).
            /* Open Section Editor for non-.w files (.p and .i files) or
               enter the current window. */
            IF (x_P._FILE-TYPE <> "w":U) THEN
                RUN call_sew (INPUT "SE_OPEN":U ).
            ELSE
                APPLY "ENTRY" TO hWindow.
        END.
        ELSE APPLY "ENTRY" TO hWindow.
        
        LEAVE.
    END. /* FOR EACH x_P */
  END.

END PROCEDURE.

PROCEDURE copyPaletteCustom:
  FOR EACH _save_palette_item: DELETE _save_palette_item. END.
  FOR EACH _save_custom: DELETE _save_custom. END.
  FOR EACH _palette_item:
     CREATE _save_palette_item.
     {adeuib/setcwidp.i "_save_palette_item" "_palette_item"}
  END.
  FOR EACH _custom:
     CREATE _save_custom.
     {adeuib/setcwidc.i "_save_custom" "_custom"}
  END.
END PROCEDURE. /* copy PaletteCustom */

PROCEDURE restorePaletteCustom:
  FOR EACH _palette_item: DELETE _palette_item. END.
  FOR EACH _custom: DELETE _custom. END.
  FOR EACH _save_palette_item:
     CREATE _palette_item.
     {adeuib/setcwidp.i "_palette_item" "_save_palette_item"}
     DELETE _save_palette_item.
  END.
  FOR EACH _save_custom:
     CREATE _custom.
     {adeuib/setcwidc.i "_custom" "_save_custom"}
     DELETE _save_custom.
  END.
END PROCEDURE. /* restore PaletteCustom */
