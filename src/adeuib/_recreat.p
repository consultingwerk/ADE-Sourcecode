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
/*----------------------------------------------------------------------------

File: _recreate.p

Description:
    Recreate a widget.  This version just does a DELETE/Undo Delete.  This was
    the fastest way to do a reinstantiation of a widget for 7.1C.

    We only call this when we want to change an attribute that cannot be 
    changed after a widget is instantiated, such as FRAME:BOX or 
    EDITOR:SCROLLBAR-V or RADIO-SET:HORIZONTAL.

Input Parameters:
    p_recid : recid of _U to be recreated
    
Output Parameters:
   <None>

Author: Ravi

Date Created: 1992 

Last modified on 12/19/96 by GFS - ported code for use with OCXs
                 05/15/95 by GFS - Added calls to DESTROY and REALIZE XFTRs.
                 10/05/94 by GFS - Added XFTR.I
                 
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_recid AS RECID NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition   */
{adeuib/layout.i}
{adeuib/triggers.i}     /* Code BLock TEMP-TABLE definition         */
{adeuib/uibhlp.i}
{adeuib/_undo.i}	/* Undo TEMP-TABLE definition		    */
{adeuib/sharvars.i}
{adeuib/gridvars.i}
{adecomm/adefext.i}
{adeuib/xftr.i}         /* XFTR TEMP-TABLE definition               */

DEFINE VARIABLE h_self              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_dlg_win           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER       NO-UNDO INITIAL 0.
DEFINE VARIABLE h_menu-bar          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_popup             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE new_win             AS HANDLE        NO-UNDO.
DEFINE VARIABLE old_win             AS HANDLE        NO-UNDO.
DEFINE VARIABLE stupid              AS LOGICAL       NO-UNDO.
DEFINE VARIABLE tmp_col             AS DECIMAL       NO-UNDO.
DEFINE VARIABLE tmp_row             AS DECIMAL       NO-UNDO.
DEFINE VARIABLE startSequenceNumber AS INTEGER       NO-UNDO.
DEFINE VARIABLE endSequenceNumber   AS INTEGER       NO-UNDO.
DEFINE VARIABLE tcode               AS CHARACTER     NO-UNDO.
DEFINE VARIABLE tempBinaryFile      AS CHARACTER     NO-UNDO INITIAL ?.
DEFINE BUFFER f_U FOR _U.

/* First unselect ALL BUT the object of interest. */
FOR EACH _U WHERE _U._SELECTEDib AND RECID(_U) NE p_recid:
   ASSIGN _U._SELECTEDib = FALSE.
   IF VALID-HANDLE(_U._HANDLE) THEN _U._HANDLE:SELECTED = FALSE.
END.

/* Verify that _U is selected. */
FIND _U WHERE RECID(_U) EQ p_recid.
_U._SELECTEDib = true.

/* If the object is a WINDOW, select its frames before calling              */
/* DeleteSelectedComposite - It will wipe out all frames and field-level    */
/* widgets. Also select other objects that parent to the window directly.   */
/* (i.e. SmartObjects and Queries).                                         */
IF _U._TYPE eq "WINDOW":U THEN DO:
  FOR EACH f_U WHERE f_U._parent eq _U._HANDLE AND
                     f_U._STATUS NE "DELETED":U:
    f_U._SELECTEDib = TRUE.
  END.
  /* Make the WINDOW unselected ... temporarily */
  _U._SELECTEDib = FALSE.
END.  /* If recreating a window */

ELSE IF _U._TYPE = "DIALOG-BOX":U THEN DO:
  ASSIGN tmp_col = _U._PARENT:COL
         tmp_row = _U._PARENT:ROW
         old_win = _U._HANDLE.  /* Actually this is the frame not the window */
END.

/* If there any controls (VBX) out there then save the state of the controls */
IF OPSYS = "WIN32":u THEN DO:
  IF    _U._TYPE = "WINDOW":U
     OR _U._TYPE = "DIALOG-BOX":U
     OR _U._TYPE = "FRAME":U THEN DO:

    IF CAN-FIND(FIRST f_U WHERE f_U._TYPE = "{&WT-CONTROL}":U
                            AND f_U._STATUS <> "DELETED":U) THEN DO:
                                
      RUN adecomm/_tmpfile.p({&STD_TYP_UIB_CLIP},
                             {&STD_EXT_UIB_WVX},
                              OUTPUT tempBinaryFile).

      FOR EACH f_U WHERE f_U._TYPE = "{&WT-CONTROL}":U
                     AND f_U._STATUS <> "DELETED":U :
/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.
              run ControlSaveControlKeepState in _h_controls(f_U._HANDLE, tempBinaryFile, output i).
*/            
        /* Save the control to the wrx file using the control-frame name */
        f_U._COM-HANDLE:SaveControls(tempBinaryFile, f_U._NAME).
      END. /* For each f_U */
    END. /* If can find a WT-CONTROL */
  END.  /* IF a window,dialog or frame */
END. /* IF OPSYS is WIN32 */

/* Delete the frames and field level objects */
CREATE _action.
ASSIGN i                  = _undo-seq-num
       _action._seq-num   = _undo-seq-num
       _action._operation = "StartDelete"
       _undo-seq-num      = _undo-seq-num + 1.


/* Delete selected FRAMEs */
RUN DeleteSelectedComposite.

/* Now delete all other selected field-level widgets. */
FOR EACH _U WHERE _U._SELECTEDib:
  IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
    CREATE _action.
    ASSIGN _action._seq-num       = _undo-seq-num
           _action._operation     = "Delete"
           _action._u-recid       = RECID(_U)
           _action._window-handle = _U._WINDOW-HANDLE
           _undo-seq-num          = _undo-seq-num + 1.
  END.
  RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT no  /* no trash */ ).
END.  /* For each selected widget */
CREATE _action.
_action._seq-num = _undo-seq-num.
_action._operation = "EndDelete".
_undo-seq-num = _undo-seq-num + 1.
_action._data = STRING(i).

FIND _U WHERE RECID(_U) = p_recid.  /* Restore original buffer after FOR EACH      */
FIND _L WHERE RECID(_L) = _U._lo-recid.
IF _U._TYPE = "WINDOW" THEN DO:
  /* Now delete the window */
  DELETE WIDGET _U._HANDLE.
  ASSIGN old_win    = _U._HANDLE
         _U._HANDLE = ?
         _U._STATUS = "DELETED".
  VALIDATE _U.
END.

/* If _U that was recreated was a window or a dialog then
 * Run DESTROY XFTRs for this Window or Dialog */
IF _U._TYPE = "WINDOW" OR _U._TYPE = "DIALOG-BOX" THEN DO:
  FOR EACH _XFTR WHERE _XFTR._wRECID = p_recid:
    FIND _TRG WHERE _TRG._xRecid = RECID(_XFTR) NO-ERROR.
    IF AVAILABLE _TRG AND _XFTR._destroy NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      ASSIGN tcode = _TRG._tCode.
      RUN VALUE(_XFTR._destroy) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT tcode).
      IF AVAILABLE _TRG THEN ASSIGN _TRG._tCode = tCode.
    END.
  END.
END.

/*  ******************************************************************************  */
/*             AT THIS POINT OBJECT and ALL DESCENDENTS ARE DELETED                 */
/*  ******************************************************************************  */

/* If object to be recreated is a WINDOW or dialog-box, recreate them first,
   then reinstate the other objects through the undo feature.                      */
   
IF _U._TYPE = "WINDOW" THEN DO:
  FIND _C WHERE RECID(_C)   = _U._x-recid.
  FIND _P WHERE _P._u-recid = RECID(_U).
  ASSIGN _cur_win_type  = _L._WIN-TYPE
         _U._STATUS     = "NORMAL"
         _U._SELECTEDib = FALSE.

  CREATE WINDOW _h_win
    ASSIGN PARENT         = _h_menu_win
           COL            = _L._COL
           ROW            = _L._ROW
           VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT * _L._ROW-MULT
           VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH * _L._COL-MULT
&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
           MAX-HEIGHT     = _L._VIRTUAL-HEIGHT * _L._ROW-MULT
           MAX-WIDTH      = _L._VIRTUAL-WIDTH * _L._COL-MULT
&ELSE
           MAX-HEIGHT     = SESSION:HEIGHT
           MAX-WIDTH      = SESSION:WIDTH
&ENDIF
           HEIGHT         = _L._HEIGHT * _L._ROW-MULT
           WIDTH          = _L._WIDTH * _L._COL-MULT
           BGCOLOR        = IF _cur_win_type THEN _L._BGCOLOR ELSE _tty_bgcolor
           FGCOLOR        = IF _cur_win_type THEN _L._FGCOLOR ELSE _tty_fgcolor
           FONT           = IF _cur_win_type THEN _L._FONT    ELSE _tty_font
           SENSITIVE      = TRUE
           MESSAGE-AREA   = IF _L._WIN-TYPE THEN _C._MESSAGE-AREA
                            ELSE IF _U._SUBTYPE eq "Design-Window":U
                            THEN NO ELSE YES
           STATUS-AREA    = IF _L._WIN-TYPE THEN _C._STATUS-AREA  
                            ELSE IF _U._SUBTYPE eq "Design-Window":U
                            THEN NO ELSE YES
           SCROLL-BARS    = _C._SCROLL-BARS
           THREE-D        = _L._3-D
           KEEP-FRAME-Z-ORDER = TRUE
           VISIBLE        = TRUE
           TITLE          = ""
        TRIGGERS:
          {adeuib/windtrig.i}
        END TRIGGERS.
        
   IF _C._menu-recid NE ? THEN DO:
     RUN adeuib/_updmenu.p (NO, _C._menu-recid, OUTPUT h_menu-bar).
     _h_win:MENU-BAR = h_menu-bar.
   END.
   IF _U._popup-recid NE ? THEN DO:
     RUN adeuib/_updmenu.p (NO, _U._popup-recid, OUTPUT h_popup).
     _h_win:POPUP-MENU = h_popup.
   END.
   IF _C._ICON NE ? AND _C._ICON NE "" THEN
     stupid = _h_win:LOAD-ICON(_C._ICON).

   ASSIGN _U._HANDLE        = _h_win
          _h_cur_widg       = _h_win
          _U._WINDOW-HANDLE = _h_win
          _P._WINDOW-HANDLE = _U._WINDOW-HANDLE
          new_win           = _h_win
          _h_frame          = ?.
   VALIDATE _U.
           
   /* update action records */
   FOR EACH _action WHERE _action._window-handle = old_win:
     _action._window-handle = new_win.
   END.
   /* update Method Library Manager records - parent id's are win handles. - jep */
   IF VALID-HANDLE(_h_mlmgr) THEN
   RUN change-pid IN _h_mlmgr ( INPUT STRING(old_win),
                                INPUT STRING(new_win) ).

   RUN adeuib/_wintitl.p (_h_win, _U._LABEL, _U._LABEL-ATTR, _P._SAVE-AS-FILE).
END.   
   
IF _U._TYPE = "DIALOG-BOX" THEN DO:
  FIND _C WHERE RECID(_C) = _U._x-recid.
  FIND _P WHERE _P._u-recid = RECID(_U).
  ASSIGN _cur_win_type  = _L._WIN-TYPE
         _U._STATUS     = "NORMAL"
         _U._SELECTEDib = FALSE.

  CREATE WINDOW h_dlg_win
    ASSIGN PARENT         = _h_menu_win
           COL            = tmp_col
           ROW            = tmp_row
           HEIGHT         = _L._HEIGHT * _L._ROW-MULT
           WIDTH          = _L._WIDTH * _L._COL-MULT
           MAX-WIDTH      = SESSION:WIDTH
           MAX-HEIGHT     = SESSION:HEIGHT
           VIRTUAL-HEIGHT = SESSION:HEIGHT
           VIRTUAL-WIDTH  = SESSION:WIDTH
           BGCOLOR        = IF _cur_win_type THEN _L._BGCOLOR ELSE _tty_bgcolor
           FGCOLOR        = IF _cur_win_type THEN _L._FGCOLOR ELSE _tty_fgcolor
           FONT           = IF _cur_win_type THEN _L._FONT    ELSE _tty_font
           SENSITIVE      = TRUE
           MESSAGE-AREA   = FALSE
           STATUS-AREA    = FALSE
           SCROLL-BARS    = FALSE
           RESIZE         = TRUE
           THREE-D        = _L._3-D
           TITLE          = ""
        TRIGGERS:
          {adeuib/dialtrig.i &SECTION = WINDOW}
        END TRIGGERS.
        
  /* The GREAT MOTIF SHUFFLE */
  &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN
    ASSIGN h_dlg_win:COL = h_dlg_win:COL + (tmp_col - h_dlg_win:COL)
           h_dlg_win:ROW = h_dlg_win:ROW + (tmp_row - h_dlg_win:ROW).
  &ENDIF
        
  CREATE FRAME h_self
       ASSIGN PARENT           = h_dlg_win
              X                = 0
              Y                = 0
              HEIGHT-CHARS     = h_dlg_win:HEIGHT-CHARS
              WIDTH-CHARS      = h_dlg_win:WIDTH-CHARS
              SIDE-LABELS      = TRUE
              BOX              = FALSE
              THREE-D          = _L._3-D
              VISIBLE          = TRUE
              BOX-SELECTABLE   = TRUE
              OVERLAY          = TRUE
              BGCOLOR          = IF _cur_win_type THEN _L._BGCOLOR ELSE _tty_bgcolor
              FGCOLOR          = IF _cur_win_type THEN _L._FGCOLOR ELSE _tty_fgcolor
              FONT             = IF _cur_win_type THEN _L._FONT    ELSE _tty_font
              SENSITIVE        = TRUE
              /* Dialog boxes act more like windows - they are not enabled
                 for direct manipulation.  We do not select them except by
                 making them the current widget */
              RESIZABLE        = FALSE
              SELECTABLE       = FALSE
              MOVABLE          = FALSE
              SCROLLABLE       = FALSE
            TRIGGERS:
                 {adeuib/dialtrig.i &SECTION = FRAME}
            END TRIGGERS.

    ASSIGN _U._HANDLE            = h_self
           _U._PARENT            = h_self:PARENT
           _C._CURRENT-ITERATION = h_self:CURRENT-ITERATION
           _U._WINDOW-HANDLE     = h_self
           _P._WINDOW-HANDLE     = _U._WINDOW-HANDLE
           _h_frame              = h_self
           _h_cur_widg           = h_self
           _h_win                = h_self
           new_win               = _h_win.
           
   /* update action records */
   FOR EACH _action WHERE _action._window-handle = old_win:
     _action._window-handle = h_self.
   END.        
   /* update Method Library Manager records - parent id's are win handles. - jep */
   IF VALID-HANDLE(_h_mlmgr) THEN
   RUN change-pid IN _h_mlmgr ( INPUT STRING(old_win),
                                INPUT STRING(new_win) ).

  RUN adeuib/_wintitl.p (h_dlg_win, _U._LABEL, _U._LABEL-ATTR, _P._SAVE-AS-FILE).
  /* Now draw the grid (NOTE make sure it is not displayed until the end
    (to prevent lots of redrawing).                                             */
  h_self:GRID-VISIBLE     = FALSE.
  IF NOT _L._WIN-TYPE
  THEN ASSIGN h_self:GRID-SNAP              = TRUE
              h_self:GRID-UNIT-HEIGHT-CHAR  = _L._ROW-MULT
              h_self:GRID-UNIT-WIDTH-CHAR   = _L._COL-MULT.
  ELSE DO:
    h_self:GRID-SNAP = _cur_grid_snap.
    IF _L._WIN-TYPE
    THEN ASSIGN h_self:GRID-UNIT-HEIGHT-CHAR   = _cur_grid_hgt
                h_self:GRID-UNIT-WIDTH-CHAR    = _cur_grid_wdth.
    ELSE ASSIGN h_self:GRID-UNIT-WIDTH-PIXELS  = _cur_grid_wdth
                h_self:GRID-UNIT-HEIGHT-PIXELS = _cur_grid_hgt.
  END.

  ASSIGN h_self:GRID-FACTOR-V  = _cur_grid_factor_v
         h_self:GRID-FACTOR-H  = _cur_grid_factor_h
         h_self:GRID-VISIBLE   = _cur_grid_visible.
         
  FOR EACH _TRG WHERE _TRG._wRECID = RECID(_U):
    _TRG._STATUS = "NORMAL".
  END.

END.   

/* Now Reinstantiate by using the UNDO Mechanism */
FIND LAST _action NO-ERROR.
IF (NOT AVAILABLE _action) THEN RETURN.  /* This should not happen since */
					 /* we just created records      */
endSequenceNumber = _action._seq-num.
startSequenceNumber = INTEGER(_action._data).

DO i = endSequenceNumber TO startSequenceNumber BY -1:
  FIND _action WHERE _action._seq-num = i.
  IF _action._operation BEGINS "Start" OR
		_action._operation BEGINS "End" THEN DO:
    DELETE _action.
  END.
  ELSE DO:   /* Process each widget that makes up this undo operation */
    FIND _U WHERE RECID(_U) = _action._u-recid.
    IF VALID-HANDLE(_action._window-handle) AND new_win = ? THEN
      _h_win = _action._window-handle.
    _U._WINDOW-HANDLE = _h_win.
    
    CASE _action._operation:
      WHEN "DELETE" THEN DO:
        IF _U._TYPE NE "DIALOG-BOX" THEN DO:
          CASE _U._TYPE:
            WHEN "BUTTON" THEN RUN adeuib/_undbutt.p(_action._u-recid).
            WHEN "COMBO-BOX" THEN RUN adeuib/_undcomb.p(_action._u-recid).
	    WHEN "EDITOR" THEN RUN adeuib/_undedit.p(_action._u-recid).
	    WHEN "RECTANGLE" THEN RUN adeuib/_undrect.p(_action._u-recid).
            WHEN "IMAGE" THEN RUN adeuib/_undimag.p(_action._u-recid).
	    WHEN "QUERY" THEN RUN adeuib/_undqry.p(_action._u-recid).
            WHEN "SLIDER" THEN RUN adeuib/_undslid.p(_action._u-recid).
	    WHEN "TEXT" THEN /* Don't Undo (redraw) Labels */
	      IF _U._SUBTYPE NE "LABEL" THEN
	        RUN adeuib/_undtext.p(_action._u-recid).
	    WHEN "SELECTION-LIST" THEN RUN adeuib/_undsele.p(_action._u-recid).
	    WHEN "FILL-IN" THEN RUN adeuib/_undfill.p(_action._u-recid).
	    WHEN "TOGGLE-BOX" THEN RUN adeuib/_undtogg.p(_action._u-recid).
	    WHEN "RADIO-SET" THEN RUN adeuib/_undradi.p(_action._u-recid).
	    WHEN "FRAME" THEN RUN adeuib/_undfram.p(_action._u-recid).
	    WHEN "BROWSE" THEN RUN adeuib/_undbrow.p(_action._u-recid).
	    WHEN "BROWSE" THEN RUN adeuib/_undbrow.p(_action._u-recid).
	    WHEN "SmartObject" THEN RUN adeuib/_undsmar.p(_action._u-recid).
            WHEN "{&WT-CONTROL}" THEN DO:
              IF tempBinaryFile <> ? THEN DO:
                FIND f_U WHERE RECID(f_U) = _action._u-recid.
                FIND _F WHERE RECID(_F) = f_U._x-recid.         
                _F._VBX-BINARY = tempBinaryFile + "," + f_U._NAME.
              END.
              RUN adeuib/_undcont.p(_action._u-recid).
            END.
	    OTHERWISE 
	      MESSAGE _U._TYPE + " currently not supported. ({&FILE-NAME})"
	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	  END CASE.
	END.  /* Not Dialog-box */
        /* Note that undsmar.p might have failed (for example,
           if the SmartObject file was not found). */
        IF AVAILABLE (_U) THEN DO:
          ASSIGN _U._STATUS        = "NORMAL"
                 _U._WINDOW-HANDLE = _h_win.
          /* If there is a POP-UP create the popups */
	  IF _U._POPUP-RECID NE ? THEN
	    RUN adeuib/_undmenu.p( _U._POPUP-RECID, _U._HANDLE ).
	END.
      END. /* DELETE */
      OTHERWISE MESSAGE _action._operation + " not processed."
	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END CASE.
    DELETE _action.
  END.  /* ELSE DO */
END. /* DO loop */

/* If there's a binary file then delete it */

IF tempBinaryFile <> ? THEN DO:

   OS-DELETE VALUE(SEARCH(tempBinaryFile)).
END.
/* IF a window or dialog, make sure that _U._WINDOW-HANDLE is set properly for all
   widgets - mostly we need to do this for menu items                               */
IF old_win NE ? THEN DO:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = old_win:
    _U._WINDOW-HANDLE = _h_win.
  END.
END.
/* The WINDOW_SAVED is set elsewhere */

/* If _U that was recreated was a window or a dialog then
 * Run REALIZE XFTRs for this Window or Dialog */
FIND _U WHERE RECID(_U) = p_recid.
IF _U._TYPE = "WINDOW" OR _U._TYPE = "DIALOG-BOX" THEN DO:
  FOR EACH _XFTR WHERE _XFTR._wRECID = p_recid:
    FIND _TRG WHERE _TRG._xRecid = RECID(_XFTR) NO-ERROR.
    IF AVAILABLE _TRG AND _XFTR._realize NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      ASSIGN tcode = _TRG._tCode.
      RUN VALUE(_XFTR._realize) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT tcode).
      IF AVAILABLE _TRG THEN ASSIGN _TRG._tCode = tCode.
    END.
  END.
END.

{adeuib/uibdel.i}
