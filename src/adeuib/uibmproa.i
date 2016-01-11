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

File: uibmproa.i

Description:
   The internal procedures of the main routine of the UIB (beginning with a-d).

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Date Modified: 1/25/94 (RPR)
               6/14/94 (tullmann) Added profiler checkpoints
               12/16/94 GFS       changed uib_enable/disable to disable/enable_widgets
               02/01/95 GFS       New palette support for RoadRunner.
               03/05/95 JEP       LIB-MGR support.
               01/31/96 PAL       Added support for tab editor.
               01/24/97 GFS       Added designFrame triggers & OCX support
               01/24/97 SLK       Added custom OCX support
               03/09/98 SLK       Added support for V8 on V9 containers, viceversa
               01/19/99 JEP       Code changes for bug fix 98-12-28-020.
               04/07/99 TSM       Added support for various Intl Numeric formats (in
                                  addition to American and European) by using 
                                  session set-numeric-format method when changing
                                  format back to user's setting
               04/21/99 TSM       Added choose_file_print procedure for 
                                  File/Print option
               05/07/99 TSM       Added support for Most Recently Used FileList
                                  when files are opened
               05/17/99 TSM       Added support for Save All option
               05/20/99 XBO       Added support for New ADM2 class option
               05/27/99 TSM       Changed filters parameter in call to _fndfile.p
                                  because it now needs list-item pairs rather
                                  than list-items to support new image formats
               06/02/99 JEP       Added Code References Window support.
               06/16/99 TSM       Changed call to abprint to always send filename
                                  rather than tempfilename so that Untitled will
                                  print in header for unsaved files
               06/24/99 TSM       Changed MRU File List code to allow remotes files
                                  to be opened from the broker url used when they
                                  were saved and not the current Broker URL
               08/08/00 JEP       Assign _P recid to newly created _TRG records.
               04/26/01 JEP       IZ 993 - Check Syntax support for WebSpeed V2 files.
     
----------------------------------------------------------------------------*/
/*  =======================================================================  */
/*                        INTERNAL PROCEDURE Definitions                     */
/*  =======================================================================  */

/* These variables are shared amongst the procedures defined in this .i      */
DEF VAR orig_y      AS INTEGER                                       NO-UNDO.
/*      orig_y      is the original Y coordinate of the down frame box       */

/* Add OCX control to Palette */
PROCEDURE Add_palette_custom_widget_defs:
   RUN adeuib/_acontp.w.
END PROCEDURE.

/* Add OCX control to Submenu */
PROCEDURE Add_submenu_custom_widget_defs:
   RUN adeuib/_prvcont.w.
END PROCEDURE.

/* Add XFTR from Extentions Palette */
PROCEDURE AddXFTR:
    DEFINE INPUT PARAMETER xftrName AS CHAR NO-UNDO.

    DEFINE BUFFER x_P FOR _P.
    
    FIND _U WHERE _U._HANDLE eq _h_win NO-ERROR.
    IF NOT AVAILABLE (_U) THEN DO:
        MESSAGE "No design window is available." VIEW-AS ALERT-BOX
            ERROR BUTTONS OK.
        RETURN.
    END.
    FIND _XFTR WHERE _XFTR._name = xftrName.
    FIND x_P WHERE x_P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.
    CREATE _TRG.
    ASSIGN
        _TRG._pRECID    = (IF AVAIL(x_P) THEN RECID(x_P) ELSE ?)
        _TRG._xRECID    = RECID(_XFTR)
        _TRG._tEVENT    = ?
        _TRG._tLocation = _XFTR._defloc
        _TRG._tSECTION  = "_XFTR"
        _TRG._tSPECIAL  = ?
        _TRG._tOFFSET   = 0
        _TRG._STATUS    = "NORMAL"
        _TRG._wRECID    = RECID(_U)
        /*_XFTR._wRECID   = RECID(_U)*/.
    IF _xftr._read    NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      RUN value(_xftr._read) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).   
    END.
    IF _xftr._realize NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      RUN value(_xftr._realize) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.
END.

/* Browse the PROGRESS KnowledgeBase via Web Browser */
PROCEDURE BrowseKBase:
  IF _WebBrowser NE ? AND _WebBrowser NE "" THEN
    RUN WinExec ( _WebBrowser + " http://www.progress.com/services/techsupport":U, 1).
  ELSE
    MESSAGE "Please define your web browser in Preferences" VIEW-AS ALERT-BOX ERROR.
END PROCEDURE.

/* call_run - run or debug a file.
              pc_Mode is RUN or DEBUG.   */
PROCEDURE call_run :
  DEFINE INPUT PARAMETER pc_Mode AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cBroker       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE choice        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldTitle     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOptions      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyBroker  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyCompile AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProxyName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxySaved   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRCodeFile    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSaveFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTitleWin     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCancel       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRemote       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lScrap        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ok2run        AS LOGICAL   NO-UNDO INITIAL YES.

  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:     
    /* Does the user want to be asked about running TTY windows in MS-WIN ?*/
    IF NOT (_cur_win_type or (OPSYS = "WIN32":U)) AND NOT {&NA-Run-TTY-in-GUI} THEN DO: 
      choice = "_RUN":U.
      RUN adeuib/_advisor.w (
          INPUT "PROGRESS cannot directly test character layouts " +
                "from inside Windows." + CHR(10) + CHR(10) +
                "However, you can test this file using the Windows " +
                "graphical user interface instead.",
          INPUT "&Run. Run the file with a graphical interface,_RUN," +
                "&Cancel. Do not run. Return to the UIB.,_CANCEL" ,
          INPUT TRUE,
          INPUT "{&UIB_SHORT_NAME}",
          INPUT {&Advisor_Run_TTY_on_GUI},
          INPUT-OUTPUT choice,
          OUTPUT {&NA-Run-TTY-in-GUI}).  
      /* Does the user still want to run? */
      ok2run = (choice eq "_RUN":U).
    END.
		   
    /* Is the file missing any links, or is it OK to RUN? */
    IF ok2run THEN 
      RUN adeuib/_advsrun.p (_h_win, "RUN":U, OUTPUT ok2run).   
    
    IF ok2run THEN DO:
      /* SEW call to store current trigger code for specific window. */
      RUN call_sew ("SE_STORE_WIN").
  
      APPLY "ENTRY":U TO h_button_bar[5].  /* Kludge to get consistent behavior.  */
      /* Set the cursor in windows. */
      RUN setstatus ("WAIT":U, IF pc_mode eq "RUN":U THEN "Running file..."
                               ELSE "Debugging file..."). 
      RUN-BLK:
      DO ON STOP  UNDO RUN-BLK, LEAVE RUN-BLK
         ON ERROR UNDO RUN-BLK, LEAVE RUN-BLK:
      
        FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
        FIND _U WHERE _U._HANDLE        eq _h_win.
        ASSIGN web-tmp-file = "".
          
        IF _P._TYPE BEGINS "WEB":U OR
          (_P._TYPE eq "SmartDataObject":U AND _P._BROKER-URL ne "") OR
          (_P._TYPE eq "SmartDataObject":U AND _P._SAVE-AS-FILE eq ? AND
           _remote_file) OR
          CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P) 
                                AND _TRG._tSECTION eq "_PROCEDURE":U
                                AND _TRG._tEVENT   eq "process-web-request":U) THEN 
        DO:
          
          /* Save file before running. */
          IF NOT _P._FILE-SAVED THEN DO:
            /* Using _U._HANDLE:TITLE because it's more reliable than 
               _P._SAVE-AS-FILE, especially if the file is untitled. */
            ASSIGN
              hTitleWin = (IF (_U._TYPE = "DIALOG-BOX") THEN
                             _U._HANDLE:PARENT ELSE _U._HANDLE)
              cFileName = TRIM((IF _P._SAVE-AS-FILE eq ? THEN
                                  SUBSTRING(hTitleWin:TITLE,
                                  INDEX(hTitleWin:TITLE,"-":U) + 1,
                                  -1, "CHARACTER":U)
                                ELSE _P._SAVE-AS-FILE))
              .
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
              SUBSTITUTE("&1 has changes which must be saved before running.",
                cFileName)).
            LEAVE RUN-BLK.
          END.
          
          cBroker = IF _P._BROKER-URL eq "" THEN _BrokerURL ELSE _P._BROKER-URL.
 
          RUN adeweb/_webcom.w (RECID(_P), cBroker, cRelName, "RUN":U, 
                                OUTPUT cRelName, INPUT-OUTPUT cTempFile).
          IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
              SUBSTITUTE("&1 could not be run for the following reason:^^&2",
              _p._save-as-file, 
              SUBSTRING(RETURN-VALUE,INDEX(RETURN-VALUE,CHR(10)),-1,
                        "CHARACTER":U))).
            LEAVE RUN-BLK.
          END.
          lRemote = TRUE.
        END. /* Web object */
        ELSE DO:
          RUN disable_widgets.
          /* Enable the Stop_Button only when running graphical design windows. */
          IF _cur_win_type = TRUE THEN
            RUN uib-stopbutton (Stop_Button, TRUE /* p_Sensitive */ ).

          RUN adeshar/_gen4gl.p (pc_Mode).
        END.
        
        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal). 
      
        /* Disable the Stop_Button only when running graphical design windows. */
        IF _cur_win_type = TRUE AND _P._broker-url = "" AND NOT lRemote THEN
          RUN uib-stopbutton (Stop_Button, FALSE /* p_Sensitive */ ).
      
        IF NOT lRemote THEN 
          RUN enable_widgets.
      
      END. /* RUN-BLK: DO....*/
      
      RUN setstatus ("":U, "":U).
      
      /* If Syntax Error, call SEW to show error. */
      IF _err_recid <> ? THEN DO:
        RUN call_sew ("SE_ERROR":U).
        ASSIGN _err_recid = ?.
      END.
    END. /* IF ok2run...*/
  END. /* IF _h_win...*/
END PROCEDURE.

/* call_sew - called by UIB to trigger events for Section Editor Window. 
     If the section editor is not running, then don't bother processing the
     call UNLESS the user wants to start up the section editor.  There are
     two cases where the Section Editor should be started: (1) if the user
     wants to start it, or (2) if an error has been found. */
PROCEDURE call_sew:
  DEFINE INPUT PARAMETER p_secommand AS CHARACTER NO-UNDO.

  /* Get the Section Editor for the current window. */
  RUN call_sew_getHandle (INPUT _h_win, INPUT p_secommand, INPUT-OUTPUT hSecEd).
  IF NOT VALID-HANDLE( hSecEd ) THEN RETURN.

  CASE p_secommand :
    WHEN "SE_OPEN":U THEN
    DO:
      IF _h_win EQ ? THEN RUN report-no-win.         
      ELSE DO:

        IF _h_cur_widg NE ? THEN
        DO:
            FIND _U WHERE _U._HANDLE = _h_cur_widg.
            RUN SecEdWindow IN hSecEd ("_CONTROL", RECID(_U), ?, "").
             /* Codedit can rename widgets, so redisplay the current widget
                in case its name has changed.  Also it could change numeric
                format.
            */
            SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
            RUN display_current.
        END.
        ELSE DO: 
            /* If no current widget, go to main block for window */
            FIND _U WHERE _U._HANDLE = _h_win.
            RUN SecEdWindow IN hSecEd
                            ("_CUSTOM":U, RECID(_U), "_MAIN-BLOCK":U, "").
        END.
      END. /* IF _h_win ne ? ... */

    END. /* WHEN "SE_OPEN" */
    
    WHEN "SE_ERROR":U THEN
    DO:
        /* Show the error (it is stored in _err_recid) */
        RUN SecEdWindow IN hSecEd (?, ?, ?, p_secommand).
    END.

    WHEN "SE_CHECK_CURRENT_WINDOW":U THEN
    DO:
      /* If user was in the Section Editor, ensure the current design
         window is the same as the one being edited in the Section Editor.
         Fixes 19981020-031. See also 20000604-003. - jep */
      RUN check_UIB_current_window IN hSecEd.
    END. /* WHEN "SE_CHECK_CURRENT_WINDOW" */
        
    OTHERWISE /* All other Section Editor commands */
      RUN SecEdWindow IN hSecEd (se_section, se_recid, se_event, p_secommand).
     
  END CASE.

  RETURN.

END PROCEDURE.  /* call_sew */

/* call_sew_getHandle - Returns the handle to the design window's Section 
   Editor procedure. Starts a Section Editor window as needed. */
PROCEDURE call_sew_getHandle :
  DEFINE INPUT        PARAM ph_win      AS HANDLE    NO-UNDO.
  DEFINE INPUT        PARAM psecommand  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAM phSecEd     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE hWindow    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lAddToMenu AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cHandle    AS CHARACTER NO-UNDO.

  DEFINE BUFFER x_P FOR _P.
  
  /* Get the procedure record to retrieve its section editor handle. */
  FIND x_P WHERE x_P._WINDOW-HANDLE = ph_win NO-ERROR.
  ASSIGN phSecEd = x_P._hSecEd NO-ERROR.

  /* If the procedure's section editor handle isn't valid (probably
     has not been assigned a value yet) and the current AB setting
     for single section editor is Yes, then set the procedure's section
     editor handle to the current section editor handle. We don't do
     this for multiple section editors because we want to create a
     new section editor anyways. -jep */
  IF NOT VALID-HANDLE(phSecEd) AND NOT _multiple_section_ed THEN
  DO:
    ASSIGN phSecEd = hSecEd. /* Current global setting. */
    ASSIGN x_P._hSecEd = hSecEd NO-ERROR.
  END.
    
  /* If we don't yet have a valid section editor handle, we need one. */
  IF NOT VALID-HANDLE(phSecEd) THEN
  DO:
    RUN adeuib/_semain.w PERSISTENT SET phSecEd.
    ASSIGN x_P._hSecEd = phSecEd NO-ERROR.
    ASSIGN lAddToMenu  = TRUE.
  END.
    
  /* Try adding a Section Editor entry to AB's Window menu only for
     SE_OPEN and SE_ERROR, since they are the only ones which can create
     section editor's. -jep */
  IF CAN-DO("SE_OPEN,SE_ERROR":U, psecommand ) THEN
  DO:
    RUN GetAttribute IN phSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
    hWindow = WIDGET-HANDLE(cHandle).
    IF VALID-HANDLE(hWindow) AND hWindow:VISIBLE = FALSE THEN
      ASSIGN lAddToMenu = TRUE.
   
    IF VALID-HANDLE(_h_WinMenuMgr) AND lAddToMenu THEN /* dma */
      RUN WinMenuAddItem IN _h_WinMenuMgr ( _h_WindowMenu, hWindow:TITLE, _h_uib ).
  END.

  RETURN.
  
END PROCEDURE.
                
/* call_sew_setHandle - Set the default hSecEd handle to the handle of the SE
   parented to the design window that has focus. */
PROCEDURE call_sew_setHandle :
  DEFINE INPUT PARAMETER phSecEd AS HANDLE NO-UNDO.

  ASSIGN hSecEd = phSecEd.
  PUBLISH "AB_call_sew_setHandle":u FROM THIS-PROCEDURE.

  RETURN.
  
END PROCEDURE.
                

/* call_coderefs - Sends events to the Code References Window. */
PROCEDURE call_coderefs :
  DEFINE INPUT PARAMETER pcCommand  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE runCommand  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE runParams   AS CHARACTER NO-UNDO.
  
  DO ON STOP UNDO, LEAVE:
  
    IF NOT VALID-HANDLE(_h_CodeRefs) THEN
    DO:
      RUN adeuib/_coderefs.w PERSISTENT SET _h_CodeRefs.
      RUN initializeObject IN _h_CodeRefs.
    END.
    ELSE
    DO:
      RUN restoreWindow IN _h_CodeRefs.
    END.
    
    IF NUM-ENTRIES(pcCommand , ":":U) > 1 THEN
      ASSIGN runCommand = ENTRY(1, pcCommand, ":":U)
             runParams  = ENTRY(2, pcCommand, ":":U).
    ELSE
      ASSIGN runCommand = pcCommand.
      
    RUN VALUE(runCommand) IN _h_CodeRefs (INPUT runParams).
  
  END. /* DO ON STOP */
      
END PROCEDURE.  /* call_coderefs */
  

PROCEDURE Center-l-to-r.  /* Align fields down the center */
  RUN adeuib/_align.p ("c-l-to-r", ?).
END PROCEDURE.  /* Center-l-to-r */


PROCEDURE Center-t-to-b.  /* Align across the center */
  RUN adeuib/_align.p (?, "c-t-to-b").
END PROCEDURE.  /* Center-t-to-b */


PROCEDURE change_grid_display.
  _cur_grid_visible = SELF:CHECKED.
  FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?: 
    ASSIGN  _U._HANDLE:GRID-VISIBLE = _cur_grid_visible.
  END.
END.

PROCEDURE change_grid_snap.
  /* Change grid snapping, but only on Graphical frames */
  _cur_grid_snap = SELF:CHECKED.
  FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?,
       EACH _L WHERE RECID(_L) = _U._lo-recid: 
    IF _L._WIN-TYPE THEN _U._HANDLE:GRID-SNAP = _cur_grid_snap.
  END.
END.


PROCEDURE change_grid_units.
   DEFINE VAR changed    AS LOGICAL                             NO-UNDO.
   DEFINE VAR saved_gd   AS LOGICAL                             NO-UNDO.
   DEFINE VAR hf         AS WIDGET                              NO-UNDO.
   
   /* This uses the current values for grid setup */
   RUN adeuib/_edtgrid.p ("Grid Units", OUTPUT changed).
   IF changed THEN DO:
     FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?,
       EACH _L WHERE RECID(_L) = _U._lo-recid: 
      /* Change the grid - first turn off the grid display so that
         everything does not flash. */
      ASSIGN            hf              = _U._HANDLE
                        saved_gd        = hf:GRID-VISIBLE
                        hf:GRID-VISIBLE = FALSE.
     /* Only change grid units on Graphical windows (not TTY) */
      IF _L._WIN-TYPE THEN DO:                  
        IF _cur_layout_unit
        THEN ASSIGN hf:GRID-UNIT-WIDTH-CHAR     = _cur_grid_wdth
                    hf:GRID-UNIT-HEIGHT-CHAR    = _cur_grid_hgt.
        ELSE ASSIGN hf:GRID-UNIT-WIDTH-PIXELS   = _cur_grid_wdth
                    hf:GRID-UNIT-HEIGHT-PIXELS  = _cur_grid_hgt.
      END.
      ASSIGN    hf:GRID-FACTOR-V = _cur_grid_factor_v
                hf:GRID-FACTOR-H = _cur_grid_factor_h
                hf:GRID-VISIBLE  = saved_gd.
     END.
   END.
END.  /* change_grid_units */


PROCEDURE change_label.
  DEFINE VAR h_ttl_widg  AS WIDGET                              NO-UNDO.
  DEFINE VAR oldTitle    AS CHAR                                NO-UNDO.
  DEFINE VAR text-sa     AS CHAR                                NO-UNDO.
  DEFINE VAR wc          AS INTEGER                             NO-UNDO.
  
  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.
  
  error_on_leave = no.
  DO WITH FRAME action_icons:
    /* Has it changed? */
    IF cur_widg_text <> SELF:SCREEN-VALUE THEN DO:
      FIND _U WHERE _U._HANDLE = h_display_widg NO-ERROR.
      IF AVAILABLE _U THEN DO:
        IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) THEN
          FIND _L WHERE RECID(_L) = _U._lo-recid.
        
        /* set the file-saved state to false */
        RUN adeuib/_winsave.p(_h_win, FALSE).
        
        ASSIGN cur_widg_text
               display_text = cur_widg_text.
        /* Text is a special case because you CAN-SET its label but we never
           use one in the UIB */
        IF _U._TYPE = "TEXT" THEN DO:
            FIND _F WHERE RECID(_F) = _U._x-recid.
            ASSIGN  _F._INITIAL-DATA         = cur_widg_text
                    wc                       = MAX(1,LENGTH(_F._INITIAL-DATA, "raw"))
                    _F._FORMAT               = "X(" + STRING(wc) + ")"
                    _U._HANDLE:FORMAT        = _F._FORMAT
                    _U._HANDLE:SCREEN-VALUE  = _F._INITIAL-DATA
                    /* Fill "label" for use in widg.browser */
                    _U._LABEL                = "~"" + _F._INITIAL-DATA + "~"" .
        END.
        ELSE IF _U._TYPE eq "BROWSE":U THEN DO:
          _U._LABEL = IF cur_widg_text eq ? THEN "" ELSE cur_widg_text.
          /* Change the title - note we need to simulate browse contents */
          FIND _C WHERE RECID(_C) eq _U._x-recid.
          IF _C._TITLE THEN DO:
            IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyObject IN _U._PROC-HANDLE.
            ELSE IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
            RUN adeuib/_undbrow.p (RECID(_U)).
          END.
        END.        
        ELSE IF _U._TYPE eq "FRAME":U THEN DO:
          _U._LABEL = IF cur_widg_text eq ? THEN "" ELSE cur_widg_text.
           FIND _C WHERE RECID(_C) eq _U._x-recid.
           IF _C._TITLE AND NOT _L._NO-BOX THEN DO:
             RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT text-sa).
             IF text-sa ne _U._HANDLE:TITLE THEN _U._HANDLE:TITLE = text-sa.
           END.
        END.        
        ELSE IF CAN-DO ("MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
          _U._LABEL = IF cur_widg_text eq ? THEN "" ELSE cur_widg_text.
          RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, no, OUTPUT text-sa).
          _U._HANDLE:LABEL = text-sa.        
        END.
        ELSE IF CAN-SET(_U._HANDLE, "LABEL") THEN DO:
          IF cur_widg_text EQ "?" OR cur_widg_text EQ ?
          THEN DO:
            /* Label is "unknown", so use "D"efault -- note: for DB fields, we
               need to refetch the Default label. We only bother with this change
               if the old value was not "D"efault. */
            IF _U._LABEL-SOURCE ne "D" THEN DO:
              IF _U._DBNAME ne ? THEN RUN adeuib/_fldlbl.p 
                            (_U._DBNAME, _U._TABLE, _U._NAME, _C._SIDE-LABELS, 
                             OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).   
              _U._LABEL-SOURCE = "D".
            END.                                    
          END.
          ELSE ASSIGN _U._LABEL = cur_widg_text
                      _U._LABEL-SOURCE = "E".
         IF NOT CAN-DO("COMBO-BOX,FILL-IN":U, _U._TYPE)
         THEN RUN adeuib/_sim_lbl.p (_U._HANDLE). /* i.e. buttons and toggles */
         ELSE DO:
            FIND f_U WHERE RECID(f_U) = _U._PARENT-RECID.
            ASSIGN _h_frame = f_U._HANDLE.
            FIND _C WHERE RECID(_C) eq f_U._x-recid.
            FIND f_L WHERE RECID(f_L) eq f_U._lo-recid.
            FIND _F WHERE RECID(_F) eq _U._x-recid.
            FIND _L WHERE RECID(_L) eq _U._lo-recid.
            _L._NO-LABELS = (TRIM(_U._LABEL) EQ ""). /* Set no-label */
            IF NOT _C._SIDE-LABELS AND NOT f_L._NO-LABELS AND _L._NO-LABELS
            THEN RUN adeuib/_chkpos.p (_U._HANDLE).
            RUN adeuib/_showlbl.p (_U._HANDLE).
          END.
        END.
        ELSE IF CAN-DO("DIALOG-BOX,WINDOW",_U._TYPE) THEN DO:
          /* We have a window or dialog box. The only other widget with a 
             title is MENU and it is not setable.  Display the title (note we 
             need to find the window for a dialog box. Also note that frames 
             have no title-bar, i.e. TITLE = ?.  If that is the case then 
             don't set title. */
           ASSIGN _U._LABEL  = cur_widg_text
                  h_ttl_widg = IF _U._TYPE eq "DIALOG-BOX" 
                               THEN _U._HANDLE:PARENT ELSE _U._HANDLE.
           FIND _P WHERE _P._u-recid eq RECID(_U).
           ASSIGN oldTitle = h_ttl_widg:TITLE.
           RUN adeuib/_wintitl.p (h_ttl_widg, _U._LABEL, _U._LABEL-ATTR, 
                                  _P._SAVE-AS-FILE).
           /* Change the active window title on the Window menu. */
           IF (h_ttl_widg:TITLE <> oldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
             RUN WinMenuChangeName IN _h_WinMenuMgr 
               (_h_WindowMenu, oldTitle, h_ttl_widg:TITLE).
        END.
                
        /* SEW call to update widget label in SEW. */
        RUN call_sew ("SE_PROPS").

      END.  /* IF AVAILABLE _U */
    END.    /* IF .. <> SCREEN-VALUE */
  END.      /* DO WITH FRAME */
  /* On return, don't do default action, just stay in the field */
  IF LAST-EVENT:FUNCTION EQ "RETURN":U THEN RETURN ERROR.
END. /* on return, leave of cur_widg_text... */


PROCEDURE change_name.
  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.
  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  error_on_leave = no.
  /* Has it been modified ? */
  IF cur_widg_name <> SELF:SCREEN-VALUE THEN DO:
    FIND _U WHERE _U._HANDLE = h_display_widg NO-ERROR.
    IF AVAILABLE _U AND (_U._TYPE ne "TEXT") THEN DO:
      IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) THEN
        FIND _L WHERE RECID(_L) eq _U._lo-recid.

      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF NOT valid_name THEN DO:
        ASSIGN error_on_leave    = yes
               SELF:SCREEN-VALUE = cur_widg_name.
        RETURN ERROR.
      END.
      ELSE DO WITH FRAME action_icons:
        ASSIGN cur_widg_name
               display_name     = cur_widg_name 
               _U._NAME         = cur_widg_name
               error_on_leave   = no.
        
        /* If this is a OCX control then CORE needs to know the change */
        
        IF _U._TYPE = "{&WT-CONTROL}" THEN _U._HANDLE:NAME = _U._NAME.

        /* set the file-saved state to false */
        RUN adeuib/_winsave.p(_h_win, FALSE).

        /* For some fields, if there are defaults then update the label */
        IF (_U._LABEL-SOURCE = "D") AND (_U._TABLE = ?) AND  
           CAN-DO ("BUTTON,FILL-IN,TOGGLE-BOX", _U._TYPE) THEN DO:
          IF CAN-DO("COMBO-BOX,FILL-IN":U, _U._TYPE) THEN DO:
            FIND f_U WHERE f_U._HANDLE eq _h_frame.
            FIND f_L WHERE RECID(f_L) eq f_U._lo-recid.
            FIND _C WHERE RECID(_C) eq f_U._x-recid.
            IF NOT _C._SIDE-LABELS AND NOT f_L._NO-LABELS AND _L._NO-LABELS
            THEN RUN adeuib/_chkpos.p (_U._HANDLE).
            RUN adeuib/_showlbl.p (_U._HANDLE).
          END. /* IF fill-in */
          ELSE RUN adeuib/_sim_lbl.p (_U._HANDLE).
        END.
        
        /* SEW call to update widget name in SEW. */
        RUN call_sew ("SE_PROPS":U).
        
      END.
    END.
  END.
  /* On return, don't do default action, just stay in the field */
  IF LAST-EVENT:FUNCTION EQ "RETURN":U THEN RETURN ERROR.
END. /* on return, leave of cur_widg_name... */

/* changewidg  is a procedure to change the currently selected widget,       */
/*             frame and window.  This procedure is like curwidg, except     */
/*             it takes an input parameter: the new widget.                  */
PROCEDURE changewidg :
  DEFINE INPUT PARAMETER h_self AS WIDGET NO-UNDO.
  DEFINE INPUT PARAMETER deselect_others AS LOGICAL NO-UNDO.

  /* Has anything changed? */
  IF h_self ne _h_cur_widg THEN DO:
    /* If requested (esp. if the curent widget is a SmartObject or a Menu item)
       then deselect all the other wigets. */
    IF deselect_others THEN DO:
      FOR EACH _U WHERE _U._SELECTEDib:
        ASSIGN _U._SELECTEDib      = FALSE
               _U._HANDLE:SELECTED = FALSE.
      END.
    END. 
    IF h_self ne ? THEN RUN curframe (h_self).
    _h_cur_widg = h_self. 
  END.
  /* Occasionally, this routine is called by a routine that has changed
     _h_cur_widg itself.  Really, the caller wants to change the
     displayed widget.  So handle this to. */  
  IF _h_cur_widg ne h_display_widg THEN RUN display_current.
END PROCEDURE. /* changewidg */


/* choose_attributes - called by UIB to trigger events in the Attributes Editor
                       floating window. */
PROCEDURE choose_attributes :

  /* If it doesn't exist, them create it.  Otherwise, move it to the top.
     NOTE that we need to make sure the handle points to the same item
     (because PROGRESS reuses procedure handles). */
  IF VALID-HANDLE(hAttrEd) AND hAttrED:FILE-NAME eq "{&AttrEd}"
  THEN RUN move-to-top IN hAttrEd NO-ERROR.
  ELSE RUN {&AttrEd} PERSISTENT SET hAttrEd .
  
  /* Show the current values. */
  RUN show-attributes IN hAttrEd NO-ERROR.
  
END PROCEDURE. /* choose_attributes */

/* choose_close: Close the current window */
PROCEDURE choose_close:
  IF _h_win = ? THEN  RUN report-no-win.
  ELSE
    /* Close the window */
    RUN wind-close (_h_win).
END PROCEDURE.


/* choose_close_all: Close one or more windows */
PROCEDURE choose_close_all:
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code regardless of what the
       current window is in UIB.  */
    RUN call_sew ("SE_STORE":U).
    
    RUN adeuib/_closeup.p.
    RUN del_cur_widg_check.   /* Have we deleted the current widget */
  
    /* Update the Window menu active window items. */
    RUN WinMenuRebuild IN _h_uib.
  END.
END PROCEDURE.

/*  choose_check_syntax: Check the syntax of the current window */
PROCEDURE choose_check_syntax:
  DEFINE VARIABLE cBroker     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTitleWin   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iErrOffset  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lScrap      AS LOGICAL   NO-UNDO.

  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Checking syntax...").
    
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
    FIND _U WHERE _U._HANDLE        eq _h_win.
    ASSIGN 
      web-tmp-file = ""
      _save_mode   = "".

    /* Check syntax on remote WebSpeed agent if Broker URL is known for this
       file or the file is new, untitled and Development Mode is remote. */
    IF _P._BROKER-URL ne "" OR (_P._SAVE-AS-FILE eq ? AND _remote_file) 
      THEN DO:
      RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cTempFile).

      /* DO NOT change or reuse web-tmp-file until AFTER adeweb/_webcom.w 
         runs in DELETE mode further down in this procedure. If the object
         to be checked is a SmartDataObject, then this variable is used to 
         hold the field definition include filename. */
      ASSIGN 
        web-tmp-file = cTempFile
        _save_mode   = (IF _P._SAVE-AS-FILE eq ? THEN "T":U ELSE "F":U) + 
                        ",":U +
                       (IF _P._SAVE-AS-FILE eq ? AND _remote_file 
                        THEN "T":U ELSE "F":U).
                       
      IF _P._file-version BEGINS "WDT_v2":U THEN
        RUN adeweb/_genweb.p (RECID(_P), "SAVE":U, ?, _P._SAVE-AS-FILE, 
                              OUTPUT cScrap).
      ELSE
        RUN adeshar/_gen4gl.p ("SAVE:CHECK":U).
      
      ASSIGN 
        cBroker   = (IF _P._BROKER-URL ne "" 
                     THEN _P._BROKER-URL ELSE _BrokerURL)
        hTitleWin = (IF (_U._TYPE = "DIALOG-BOX") THEN
                      _U._HANDLE:PARENT ELSE _U._HANDLE)
        cFileName = TRIM((IF _P._SAVE-AS-FILE eq ? THEN
                            SUBSTRING(hTitleWin:TITLE,
                              INDEX(hTitleWin:TITLE,"-":U) + 1,
                              -1, "CHARACTER":U)
                     ELSE _P._SAVE-AS-FILE))
        cScrap    = "".
    
      /* Copy the file to a WebSpeed agent as a temp file and check syntax
         remotely. */
      RUN adeweb/_webcom.w (RECID(_P), cBroker, cFileName,
                            "checkSyntax":U, OUTPUT cRelName, 
                            INPUT-OUTPUT cTempFile).
                            
      /* If there's an error, we want to load the correct section in the 
         Section Editor.  We do this by setting _err_recid based on the
         COMPILER:FILE-OFFSET. */
      IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
        iErrOffset = INTEGER(ENTRY(2,ENTRY(1,RETURN-VALUE,CHR(10))," ":U)).

        RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
          SUBSTRING(RETURN-VALUE,INDEX(RETURN-VALUE,CHR(10)),-1,"CHARACTER":U)).
        
        FIND LAST _TRG WHERE _TRG._pRECID  eq RECID(_P)
                         AND _TRG._tOFFSET lt iErrOffset
                         USE-INDEX _tOFFSET NO-ERROR.
        _err_recid = IF AVAILABLE _TRG THEN RECID(_TRG) ELSE ?.
      END. /* RETURN-VALUE BEGINS "ERROR:" */
      ELSE
        MESSAGE "Syntax is correct."
          VIEW-AS ALERT-BOX INFORMATION.
          
      /* Cleanup any left over remote .ab.i files. */
      RUN adeweb/_webcom.w (?, cBroker, web-tmp-file, "DELETE":U,
                          OUTPUT cScrap, INPUT-OUTPUT cScrap).
      web-tmp-file = "".
    END.
    ELSE
    DO: /* IZ 993 - Check Syntax support for WebSpeed V2 files. */
      IF _P._file-version BEGINS "WDT_v2":U THEN
        RUN adeweb/_genweb.p (RECID(_P), "CHECK-SYNTAX":U, ?, _P._SAVE-AS-FILE, OUTPUT cScrap).
      ELSE
        RUN adeshar/_gen4gl.p ("CHECK-SYNTAX":U).
    END.
    
        
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).
    
    /* If Syntax Error, call SEW to show error. */
    IF _err_recid <> ? THEN DO:
      RUN call_sew ("SE_ERROR":U).
      ASSIGN _err_recid = ?.
    END.
  END.  
END PROCEDURE. 

/* choose_code_preview - called by menu and button-bar. */
PROCEDURE choose_code_preview:
  DEFINE VARIABLE cScrap AS CHARACTER NO-UNDO.

  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Generating code to preview...").
    
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "PREVIEW":U, ?, ?, OUTPUT cScrap).
    ELSE
      RUN adeshar/_gen4gl.p ("PREVIEW":U).
      
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).
    RUN adeuib/_prvw4gl.p (_comp_temp_file, ?, ?, ?).
    /* The temp file is no longer needed */
    OS-DELETE VALUE(_comp_temp_file).
  END.									   
END.

/* choose_control_props - Bring up the OCX property editor */

PROCEDURE choose_control_props:

  DEFINE VARIABLE multControls AS  INTEGER NO-UNDO.
  DEFINE VARIABLE s            AS  INTEGER NO-UNDO.
  DEFINE BUFFER   f_u          FOR _U.

  /* Set and display the Property Editor window. */
  RUN show_control_properties (1).

END.

/* choose_codedit - called by mi_code_edit, button-bar and Accelerators. */
PROCEDURE choose_codedit:

  RUN adecomm/_setcurs.p ("WAIT":U) NO-ERROR.
  RUN call_sew ("SE_OPEN":U).
  RUN adecomm/_setcurs.p ("":U) NO-ERROR.
  
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* of Code editor button */

/* choose_copy - called by Edit/Copy; Copy Accelerators.  */
PROCEDURE choose_copy.
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE VAR dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win eq ? THEN RUN report-no-win.
  ELSE DO:
    RUN adeuib/_chksel.p(OUTPUT ivCount). /* check selection for same parents */
    IF ivCount > 0 THEN DO: /* Valid Copy */
      /* SEW store current trigger code before copying to clipboard. */
      RUN call_sew ("SE_STORE_SELECTED":U).

      RUN setstatus ("WAIT":U, "Copying to clipboard...").
      IF _comp_temp_file = ? THEN
        RUN adecomm/_tmpfile.p({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                               OUTPUT _comp_temp_file).
      ASSIGN cvCurrentSaveFile = _save_file 
             _save_file = _comp_temp_file.
             
      /* Delete any OCX binary cut files */
      IF OPSYS = "WIN32":U THEN
      DO:
          OS-DELETE VALUE(_control_cut_file).
          ASSIGN _control_cb_op = TRUE.
      END.

      RUN adeuib/_chsxprt.p (FALSE).
      ASSIGN _save_file = cvCurrentSaveFile
             _control_cb_op = FALSE.
     /* ADE only works with a single clipboard format - text only. */
     ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
            CLIPBOARD:MULTIPLE = FALSE.
      /* Move the text into the clipboard */
      DO WITH FRAME _clipboard_editor_frame:
        ASSIGN _clipboard_editor:SCREEN-VALUE = ""
               dummy = _clipboard_editor:INSERT-FILE(_comp_temp_file)
               CLIPBOARD:VALUE = _clipboard_editor:SCREEN-VALUE.
      END.
      /* Restore clipboard multiple value. */
      ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
      RUN setstatus ("":U, "":U).
      OS-DELETE VALUE(_comp_temp_file).
    END. /* Valid Copy */
    ELSE DO: /* Invalid Copy */
      IF ivCount = 0 THEN
        MESSAGE "There is nothing selected to copy." VIEW-AS ALERT-BOX
              INFORMATION BUTTONS OK.
      ELSE
        MESSAGE "There are selected objects with different parents." SKIP
            "Copy only works on objects with the same parent."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.  /* Invalid Copy */
  END. /* IF _h_win...ELSE DO: */
END PROCEDURE.

/* choose_cut - called by Edit/Cut; Cut Accelerators.  */
PROCEDURE choose_cut.
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0.
  DEFINE VARIABLE dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win eq ? THEN RUN report-no-win.
  ELSE DO:
    /* check selection: if different parents, then ivCount will be < 0 */
    RUN adeuib/_chksel.p (OUTPUT ivCount).
    IF ivCount > 0 THEN DO: /* Valid Cut */      
      /* Cannot cut from alternate layouts. */
      IF CAN-FIND (FIRST _U WHERE _U._SELECTEDib 
                     AND _U._LAYOUT-NAME ne "{&Master-Layout}":U)
      THEN MESSAGE "Objects cannot be cut from alternate layouts." SKIP(1)
                   "Return to the Master Layout to cut these objects,"
                   "or go to their property sheets to remove them from"
                   "this layout."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ELSE DO:
        /* SEW store current trigger code before cutting to clipboard. */
        RUN call_sew ("SE_STORE_SELECTED":U).
        RUN setstatus ("WAIT":U, "Cutting to clipboard...").
        /* If any of the selected objects are in the current frame, then remove
           the selected objects from the current query. */
        IF _h_frame ne ? THEN RUN adeuib/_vrfyqry.p (_h_frame, "REMOVE-SELECTED-FIELDS":U, "").
        IF _comp_temp_file = ? THEN
          RUN adecomm/_tmpfile.p({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                             OUTPUT _comp_temp_file).
        ASSIGN cvCurrentSaveFile = _save_file 
              _save_file = _comp_temp_file.
              
        /* Delete any OCX binary cut files. */
        IF OPSYS = "WIN32":u THEN
        DO:    
            OS-DELETE VALUE(_control_cut_file).
            ASSIGN _control_cb_op = TRUE.
        END.
        
        RUN adeuib/_chsxprt.p (FALSE).
        RUN CutSelected.  /* This is where the object gets deleted */
        
        ASSIGN _save_file = cvCurrentSaveFile
               _control_cb_op = FALSE.
      
        /* ADE only works with a single clipboard format - text only. */
        ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
               CLIPBOARD:MULTIPLE = FALSE.
        /* Move the text into the clipboard */
        DO WITH FRAME _clipboard_editor_frame:
          ASSIGN _clipboard_editor:SCREEN-VALUE = ""
               dummy = _clipboard_editor:INSERT-FILE(_comp_temp_file)
               CLIPBOARD:VALUE = _clipboard_editor:SCREEN-VALUE.
        END.
        /* Restore clipboard multiple value. */
        ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
  
        RUN adeuib/_winsave.p(_h_win, FALSE). /* update the file-saved state */
        OS-DELETE VALUE(_comp_temp_file).
        RUN del_cur_widg_check. /* Have we deleted the current widget? */
        RUN setstatus ("":U, "":U).    
      END. /* IF...Master-Layout... */
    END. /* Valid Cut */
    ELSE DO:  /* Invalid Cut */
      IF ivCount = 0 
      THEN MESSAGE "There is nothing selected to cut."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      ELSE MESSAGE "There are selected objects with different parents." SKIP
                   "Cut only works on objects with the same parent."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END. /* Invalid Cut */
  END.
END PROCEDURE.  /* choose_cut */

/* choose_debug -- run the current window with the debugger */
PROCEDURE choose_debug:
  RUN call_run ("DEBUG").
END PROCEDURE.

 /* choose_duplicate - called by Edit/Duplicate.  */
PROCEDURE choose_duplicate .
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE ivCount           AS INTEGER    INITIAL 0.
  DEFINE VARIABLE OCXCount          AS INTEGER    NO-UNDO INITIAL 0.
  DEFINE VARIABLE dup_file          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE par-rec           AS RECID      NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib:
    ivCount = ivCount + 1.
    IF _U._TYPE = "{&WT-CONTROL}" THEN OCXCount = OCXCount + 1.
  END.

  IF ivCount = 0 THEN
    MESSAGE "There is nothing selected to duplicate." VIEW-AS ALERT-BOX
            INFORMATION BUTTONS OK.
  ELSE DO:
    
    /* SEW store current trigger code before duplicating in UIB. */
    RUN call_sew ("SE_STORE_SELECTED":U).
    
    cvCurrentSaveFile = _save_file.
    RUN "adecomm/_tmpfile.p"({&STD_TYP_UIB_DUP}, {&STD_EXT_UIB}, OUTPUT dup_file).

    /* set the file-saved state to false, since we will create object(s) */
    RUN adeuib/_winsave.p (_h_win, FALSE).

     _save_file = dup_file.
    IF _h_win = ? THEN RUN report-no-win.
    ELSE RUN adeuib/_chsxprt.p (FALSE).
    /* Make sure we don't duplicate a frame into its self */
    IF VALID-HANDLE(_h_frame) THEN DO:
      FIND _U WHERE _U._HANDLE eq _h_frame.
      IF _U._TYPE eq "FRAME":U AND _U._SELECTEDib THEN DO:
        par-rec = _U._PARENT-RECID.
        FIND _U WHERE RECID(_U) = par-rec.
        IF _U._TYPE eq "WINDOW":U THEN _h_frame = ?.
        ELSE _h_frame = _U._HANDLE.  /* Parent duplicate to frame or dialog. */
      END.
    END.
    RUN adeuib/_qssuckr.p (dup_file, "", "IMPORT", FALSE).
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN display_current.  
      
    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).
    
    _save_file = cvCurrentSaveFile.

    /* The analyzer creates a file that we have to delete. It is based on
     * name of dup_file, with a different extension
     */

    OS-DELETE VALUE(dup_file)
              VALUE((SUBSTR(dup_file, 1, R-INDEX(dup_file, ".") - 1) + {&STD_EXT_UIB_QS})).
              
    /*
     * If this is a control then delete the temporary OCX binary file that was
     * created for the duplicate.     
     */
      IF OPSYS = "WIN32":u AND (OCXCount > 0) THEN
         OS-DELETE VALUE((SUBSTR(dup_file, 1, R-INDEX(dup_file, ".") - 1) + {&STD_EXT_UIB_WVX})).
      
  END.

END PROCEDURE. /* Duplicate */

/* choose_editor - called from the mnu_editor dynamic menu-item in the mnu-tools menu */
/*                 This summons the Procedure Editor                                  */                            
PROCEDURE choose_editor.
  RUN _RunTool("_edit.p":U).
  SESSION:DATE-FORMAT = _orig_dte_fmt.
END PROCEDURE. /* Choose editor */

/* choose_erase - called by Edit/Delete; Delete Anywhere  */
/*                Erase marked widgets                                   */
PROCEDURE choose_erase.
  DEFINE VARIABLE cnt  AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE BUFFER   x_U  FOR _U.

  /*
     NOTE: when we delete a dialog-box, this trigger is not run. If this
     is changed, then there would be an empty action record start and end
     created.  This trigger needs to be changed appropriately, when this
     happens.
  */
  FOR EACH _U WHERE _U._SELECTEDib:
    ASSIGN cnt = cnt + 1.
  END.
  
  IF cnt = 0 THEN
    MESSAGE "There is nothing selected for deletion."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE DO: /* objects to delete */
    /* SEW store current trigger code before deleting. */
    RUN call_sew ("SE_STORE_SELECTED":U).

    RUN setstatus ("WAIT":U, ?).
    /* For each frame that is not selected itself, run through the selected
       widgets that it contains and remove them from the query */
    FOR EACH _U WHERE NOT _U._SELECTEDib
                  AND _U._WINDOW-HANDLE eq _h_win
                  AND CAN-DO("DIALOG-BOX,FRAME":U,_U._TYPE):
      RUN adeuib/_vrfyqry.p (_U._HANDLE, "REMOVE-SELECTED-FIELDS":U, "":U).
    END.
    /* IF the current layout is the Master Layout then do an old fashioned delete */
    FIND _U WHERE _U._HANDLE = _h_win.

    /* Now create the undo record and DELETE the objects */
    CREATE _action.
    ASSIGN cnt                = _undo-seq-num /* note: cnt is clobbered */
           _action._seq-num   = _undo-seq-num
           _action._operation = "StartDelete":U
           _undo-seq-num      = _undo-seq-num + 1.

    IF _U._LAYOUT-NAME = "Master Layout" THEN
      RUN delselected.  /* Here is where we delete the widgets */
    ELSE DO:  /* Only mark things "remove-from-layout" */
      FOR EACH _U WHERE _U._SELECTEDib:
      
        IF _U._TYPE = "FRAME" THEN DO:
          FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win AND
                   x_U._PARENT-RECID = RECID(_U) AND
                   NOT x_U._NAME BEGINS "_LBL-":
            FIND _L WHERE RECID(_L) = x_U._lo-recid.
            IF x_U._HANDLE:HIDDEN = FALSE AND _L._REMOVE-FROM-LAYOUT = FALSE THEN DO:
              CREATE _action.
              ASSIGN _action._seq-num       = _undo-seq-num
                     _action._operation     = "Delete"
                     _action._u-recid       = RECID(x_U)
                     _action._window-handle = x_U._WINDOW-HANDLE
                     _undo-seq-num          = _undo-seq-num + 1
                     x_U._HANDLE:HIDDEN     = TRUE
                     _L._REMOVE-FROM-LAYOUT = TRUE.
              /* See if it is in any layout */
              IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(x_U) AND
                                NOT _L._REMOVE-FROM-LAYOUT) THEN
                x_U._STATUS = "DELETED".                   
            END.  /* If not all ready done */
          END.  /* For each field level widget of the frame */
        END.  /* If  a frame */
        
        FIND _L WHERE RECID(_L) = _U._lo-recid.
        CREATE _action.
        ASSIGN _action._seq-num       = _undo-seq-num
               _action._operation     = "Delete"
               _action._u-recid       = RECID(_U)
               _action._window-handle = _U._WINDOW-HANDLE
               _undo-seq-num          = _undo-seq-num + 1
               _U._HANDLE:HIDDEN      = TRUE
               _L._REMOVE-FROM-LAYOUT = TRUE.
               
        /* See if it is in any layout */
        IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                          NOT _L._REMOVE-FROM-LAYOUT) THEN
          _U._STATUS = "DELETED".
          
        IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME":U,_U._TYPE) THEN
          ASSIGN _h_cur_widg = _h_frame.
      END.  /* For each selected widget */
      IF VALID-HANDLE(_h_cur_widg) AND _h_cur_widg:TYPE = "FRAME" THEN
        RUN display_current.                                              
    END.  /* Else an altenative layout */

    CREATE _action.
    ASSIGN _action._seq-num = _undo-seq-num
           _action._operation = "EndDelete":U
           _undo-seq-num = _undo-seq-num + 1
           _action._data = STRING(cnt).

    /* set the file-saved state to false, since we just deleted object(s) */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    RUN UpdateUndoMenu("&Undo Delete").
    RUN setstatus ("":U, ?).
  END. /* objects to delete */            
END. 


/* choose_export_file -- Export selected objects to an export file. */
PROCEDURE choose_export_file.
  DEFINE VARIABLE cnt AS INTEGER NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    RUN adeuib/_chksel.p ( OUTPUT cnt ).
    IF cnt >= 0 THEN
    DO:
      /* SEW store current trigger code before copying to file. */
      RUN call_sew ("SE_STORE_SELECTED":U).
      RUN adeuib/_chsxprt.p (TRUE).
    END.
    ELSE DO: /* Invalid Selection */
      MESSAGE "There are selected objects with different parents." SKIP
              "Copy to File only works on objects with the same parent."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END. /* Invalid Selection */ 
  END.
END.

/* choose_file_new  is a procedure that creates a new window or dialog-box  */
/*                  and makes sure that the new item is the current object  */
PROCEDURE choose_file_new :
  DEFINE VAR choice    AS CHAR NO-UNDO.
  DEFINE VAR cChoice   AS CHAR NO-UNDO.
  DEFINE VAR cFileExt  AS CHAR NO-UNDO.
  DEFINE VAR lHtmlFile AS LOG  NO-UNDO.

  RUN adeuib/_newobj.w ( OUTPUT choice ).
  /* DESELECT everything that is selected if a choice was made. */ 
  IF choice ne "" and choice ne ? THEN DO:
    RUN adecomm/_osfext.p ( choice, OUTPUT cFileExt ).
    IF (cFileExt eq ".htm":U OR cFileExt eq ".html":U) AND 
      _AB_license > 1 THEN DO:
      
      lHtmlFile = TRUE.
      RUN adeweb/_trimdsc.p (choice, OUTPUT cChoice) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        choice = cChoice.
    END.
      
    RUN Open_Untitled (choice).
    
    /* Delete temp file. */
    IF lHtmlFile THEN
      OS-DELETE VALUE(choice).
      
    RUN display_curwin.
  END. /* If a valid choice */
END PROCEDURE.

/* choose_file_open - called by File/Open or Ctrl-O */
PROCEDURE choose_file_open:
  DEFINE VARIABLE cTempFile    AS CHARACTER              NO-UNDO.
  DEFINE VARIABLE h_curwin     AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE h_active_win AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE lnth_sf      AS INTEGER                NO-UNDO.
  DEFINE VARIABLE pressed-ok   AS LOGICAL                NO-UNDO.

  ASSIGN h_curwin = _h_win.

  /* Deselect the currently selected widgets */
  RUN deselect_all (?, ?).
  
  /* Get a file name to open. If WebSpeed is licensed, call web file dialog,
     unless user has also licensed Enterprise and wants local file management. */
  IF _AB_license > 1 AND _remote_file THEN
    RUN adeweb/_webfile.w ("uib":U, "Open":U, "Open":U, "":U,
      INPUT-OUTPUT open_file, OUTPUT cTempFile, OUTPUT pressed-ok).

  IF _AB_license = 1 OR NOT _remote_file OR RETURN-VALUE = "HTTPFailure":U THEN 
    RUN adecomm/_getfile.p (CURRENT-WINDOW, "uib", "Open", "Open", "OPEN",
                            INPUT-OUTPUT open_file, OUTPUT pressed-ok).
  
  IF pressed-ok THEN DO:
    RUN setstatus (?, "Opening file...").
    RUN adeuib/_open-w.p (TRIM(open_file), TRIM(cTempFile), "WINDOW":U).

    /* In case of _qssuckr failure, reset the cursors . */
    RUN setstatus ("":U, "":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.
  
    /* If no file was opened, leave now. */
    IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.

  END.  /* IF pressed_OK... */
  
  /* Special Sanity check -- sanitize our records.  Always do this (even if
     the user cancelled the file open)  */
  RUN adeuib/_sanitiz.p.
END PROCEDURE. 

/* choose_file_print - called by File/Print */
PROCEDURE choose_file_print.
  DEFINE VARIABLE cScrap AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lPrinted AS LOGICAL NO-UNDO.
  
  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Generating code to print...").
    
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "PREVIEW":U, ?, ?, OUTPUT cScrap).
    ELSE
      RUN adeshar/_gen4gl.p ("PRINT":U).
    
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).
    RUN adeuib/_abprint.p ( INPUT _comp_temp_file,
                            INPUT _h_win,
                            INPUT _P._save-as-file,
                            INPUT ?,
                            OUTPUT lPrinted ) .

    /* The temp file is no longer needed */
    OS-DELETE VALUE(_comp_temp_file).
  END.  /* else do - _h_win <> ? */									   
END PROCEDURE.  /* choose_file_print */




/* choose_file_save - called by File/Save or Ctrl-S */
PROCEDURE choose_file_save.
  DEFINE VARIABLE cancel AS LOGICAL NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).

    RUN save_window (no, OUTPUT cancel).
  END.
END PROCEDURE.

/* choose_file_save_all - called by File/Save All */
PROCEDURE choose_file_save_all:
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER x_P FOR _P.
    
  FOR EACH x_U WHERE CAN-DO("WINDOW,DIALOG-BOX",x_U._TYPE)
                                         AND x_U._STATUS NE "DELETED":
                                        
    IF x_U._TYPE = "DIALOG-BOX":U THEN RUN changewidg (x_U._HANDLE, yes).
    ELSE APPLY "ENTRY":U TO x_U._HANDLE.
    
    FIND x_P WHERE x_P._u-recid eq RECID(x_U).    
    IF x_P._SAVE-AS-FILE = ? THEN 
      MESSAGE IF x_U._SUBTYPE eq "Design-Window" THEN x_U._LABEL ELSE x_U._NAME SKIP
        "This window has not been previously saved."
        VIEW-AS ALERT-BOX INFORMATION.

    RUN choose_file_save.    
            
  END.  /* for each x_u */
END PROCEDURE.  /* choose_file_save_all */

/*  choose_file_save_as: Save current window with a new name */
PROCEDURE choose_file_save_as:
  DEFINE VARIABLE cancel AS LOGICAL NO-UNDO.
  IF _h_win = ? THEN  RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    
    RUN save_window (yes, OUTPUT cancel).
  END.

END PROCEDURE.

/* choose_goto_page - change the page number shown for the current window */
PROCEDURE choose_goto_page :  
  /* Does this procedure support paging? If so change the page and display
     it? */
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:  
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
    IF CAN-DO (_P._links, "PAGE-TARGET") THEN DO:   
      /* Only page 0 is allowed on alternate layouts. */
      FIND _U WHERE RECID(_U) eq _P._u-recid.
      IF _U._LAYOUT-NAME eq '{&Master-Layout}':U THEN DO:                                         
        RUN adeuib/_gotopag.w (RECID(_P)).
        RUN display_page_number.         
      END.
      ELSE DO:
        MESSAGE "Changing pages is not supported except in the {&Master-Layout}."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        IF _P._page-current NE 0 THEN RUN adeuib/_showpag.p (0). 
      END. /* IF <not master layout>... */
    END. /* IF CAN-DO...Page-Target... */
  END. /* IF valid window... */
END PROCEDURE.  

/* choose_import_fields: load fields (and their VIEW-AS) from the database */
PROCEDURE choose_import_fields:
  DEFINE VAR drawn AS LOGICAL INITIAL FALSE NO-UNDO.
  DEFINE VAR tfile AS CHARACTER NO-UNDO.
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      "You must have at least one connected database to insert database fields.",
      OUTPUT ldummy).
    IF ldummy eq no THEN RETURN.
  END.
  IF _h_frame = ? THEN DO:
    /* Assume the first frame in the window (if there is one). */
    FIND _U WHERE _U._TYPE eq "FRAME":U
              AND _U._STATUS ne "DELETED":U
              AND _U._WINDOW-HANDLE eq _h_win NO-ERROR.
    IF AVAILABLE _U THEN _h_frame = _U._HANDLE.
    ELSE DO:
      MESSAGE "Please select a frame in which to insert database fields."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END.
  END.
  
  drawn = FALSE.
  RUN setstatus (?, "Choose fields.").
  
  IF LDBNAME("DICTDB":U) = ? OR DBTYPE("DICTDB":U)NE "PROGRESS":U THEN
  FIND-PRO:
  DO i = 1 TO NUM-DBS:
    IF DBTYPE(i) = "PROGRESS":U THEN DO:
      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(LDBNAME(i)).
      LEAVE FIND-PRO.
    END.
  END.
  
  RUN adeuib/_drwflds.p (INPUT "", INPUT-OUTPUT drawn, OUTPUT tfile).
  IF drawn THEN DO:
    RUN setstatus ("WAIT":U, "Inserting fields...").
    SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    RUN adeuib/_qssuckr.p (tfile, "", "IMPORT", TRUE).
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

    /* When drawing a data field for an object that is using a SmartData
       object, set the data field's Enable property based on the data object
       getUpdatableColumns. Must do this here since its not picked up automatically
       in the temp-table definition like format and label.  jep-code 4/29/98 */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    IF (AVAILABLE _P) AND (_P._data-object <> "") THEN
      RUN setDataFieldEnable IN _h_uib (INPUT RECID(_P)).

    RUN display_current.
    
    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).

    /* set the file-saved state to false */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    /*
     * Delete the temp file
     */
    OS-DELETE VALUE(tfile) NO-ERROR.
  END.
  SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
  RUN setstatus ("":U, "":U).  /* Reset status and wait-cursor */
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END.

/* choose_import_file: Import an exported file. */
PROCEDURE choose_import_file:
  DEF VAR lnth_sf AS INTEGER NO-UNDO.
  DEF VAR pressed_ok AS LOGICAL NO-UNDO.
  DEF VAR absolute_name AS CHAR NO-UNDO.

  /* Choose a *.wx file from the saved set of WIDGET-DIRS.  Use TEMPLATE
     mode here so that we can show related pictures of the choosen file
     (if they exist). */
  open_file = "".
  RUN adecomm/_fndfile.p (INPUT "Insert From File",                   /* pTitle            */
                          INPUT "TEMPLATE",                           /* pMode             */
                          INPUT "Export (*.wx)|*.wx|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&WIDGET-DIRS},                /* pDirList          */
                          INPUT-OUTPUT open_file,                     /* pFileName         */
                          OUTPUT absolute_name,                       /* pAbsoluteFileName */
                          OUTPUT pressed_ok).                         /* pOK               */
  IF pressed_OK THEN DO:  
    open_file = absolute_name.   
    /* Deselect the currently selected widgets. */
    RUN deselect_all (?, ?).
    RUN setstatus ("":U, "Insert from file...").
    IF open_file <> "" AND open_file <> ? THEN
      RUN adeuib/_qssuckr.p (open_file, "", "IMPORT":U, FALSE).
    
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

    /* In case of _qssuckr failure, reset the cursors. */
    RUN setstatus ("":U, "":U).

    /* Special Sanity check -- sanitize our records */
    RUN adeuib/_sanitiz.p.
 
    IF (_h_win = ?) THEN RETURN.

    /* set the file-saved state to false */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    FIND _U WHERE _U._HANDLE = _h_win.
    ASSIGN _h_cur_widg    = _U._HANDLE
           _h_frame       = (IF _U._TYPE eq "WINDOW":U THEN ? ELSE _U._HANDLE)
           .  
    RUN display_current.
    
    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).
   
    /* Return to pointer mode. */
    IF _next_draw NE ? THEN 
      RUN choose-pointer.
  END.
END.

/* choose_mru_file: opens file from the MRU Filelist */
PROCEDURE choose_mru_file:
  DEFINE INPUT PARAMETER ifile AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE cTempFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE glScrap     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE h_curwin    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFileError  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lStayList   AS LOGICAL   NO-UNDO.  
  DEFINE VARIABLE relPathName AS CHARACTER NO-UNDO. 

  FIND _mru_files WHERE _mru_files._position = ifile NO-ERROR.
  IF AVAILABLE _mru_files THEN DO:
    
    ASSIGN h_curwin = _h_win.

    /* Deselect the currently selected widgets */
    RUN deselect_all (?, ?).

    IF _mru_files._broker <> "" THEN DO:
      RUN adeweb/_webcom.w (?, _mru_files._broker, _mru_files._file, "open",
        OUTPUT relpathname, INPUT-OUTPUT ctempfile).
    
      IF RETURN-VALUE BEGINS "ERROR":U THEN 
      DO:
        IF INDEX(RETURN-VALUE,"Not readable":U) ne 0 THEN
          RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
            SUBSTITUTE("Cannot open &1.  WebSpeed agent does not have read permission.", 
            _mru_files._file)).
          
        IF INDEX(RETURN-VALUE,"File not found":U) ne 0 THEN
          MESSAGE _mru_files._file "not found in WebSpeed agent PROPATH."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        
        DELETE _mru_files.
        RUN adeshar/_mrulist.p("":U, "":U).
        lFileError = TRUE.
      END. /* if return-value begins 'error' */
      ELSE _mru_broker_url = _mru_files._broker.  /* need to set _mru_broker_url so that
                                                     the remote file can be opened on the 
                                                     broker it was saved to - not necessarily
                                                     the current broker url */  
    END.  /* if broker <> "" - remote file */
    ELSE DO:
      ASSIGN FILE-INFO:FILE-NAME = _mru_files._file.
      IF FILE-INFO:FILE-TYPE = ? THEN DO:
        MESSAGE _mru_files._file "cannot be found." VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
        DELETE _mru_files.
        RUN adeshar/_mrulist.p("":U, "":U).
        lFileError = TRUE. 
      END.  /* if file type = ? */
    END.  /* else - local file */
    
    IF NOT lFileError THEN DO:
      RUN setstatus (?, "Opening file...").
      RUN adeuib/_open-w.p (TRIM(_mru_files._file), TRIM(cTempFile), "WINDOW":U).
    END.  /* if not file error */
    
    /* Need to re-set _mru_broker_url to blank after file has been opened */
    _mru_broker_url = "".
    
    RUN setstatus ("":U, "":U).
    
    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.
  
    /* If no file was opened, leave now. */
    IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.
    
    /* Special Sanity check -- sanitize our records.  Always do this (even if
     the user cancelled the file open)  */
    RUN adeuib/_sanitiz.p.

  END.  /* if avail mru files */

END.  /* PROCEDURE choose_mru_file */

/* choose_new_pw    is a procedure that creates a new Procedure Window.     */
PROCEDURE choose_new_pw :

DO ON STOP UNDO, LEAVE:
  RUN adecomm/_pwmain.p ("_ab.p":U /* PW Parent ID */,
                         ""  /* Files to open */,
                         ""  /* PW Command */ ).
END.

END PROCEDURE.

/* choose_new_adm2_class is a procedure that calls _clasnew.w    
   to create a new ADM2 class */
PROCEDURE choose_new_adm2_class :

    RUN adeuib/_clasnew.w.

END PROCEDURE.


/* choose_paste - called by Edit/Paste; PASTE Accelerators.  */
PROCEDURE choose_paste.
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE temp_file         AS CHARACTER.
  DEFINE VARIABLE dummy             AS LOGICAL.
  DEFINE VARIABLE Clip_Multiple     AS LOGICAL    NO-UNDO INIT FALSE.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
  /* ADE only works with a single clipboard format - text only. */
  ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
         CLIPBOARD:MULTIPLE = FALSE.
  
  ASSIGN temp_file = CLIPBOARD:VALUE NO-ERROR.  /* Using temp_file */
  IF temp_file = "" OR temp_file = ? THEN
    MESSAGE "The clipboard is empty, there are no objects to paste."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE DO:
  /* we have to check for the clipbaord format, before we save the stuff */

    
    RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_CLIP},
                                {&STD_EXT_UIB}, OUTPUT temp_file).
    cvCurrentSaveFile = _save_file.

    _clipboard_editor:SCREEN-VALUE IN FRAME _clipboard_editor_frame = "".
    _clipboard_editor:SCREEN-VALUE IN FRAME _clipboard_editor_frame = CLIPBOARD:VALUE.
    dummy = _clipboard_editor:SAVE-FILE(temp_file)
                IN FRAME _clipboard_editor_frame.

    /*
     * Check to see if the contents of the clipboard contain stuff that
     * we understand
     */

    IF  (entry(1, _clipboard_editor:SCREEN-VALUE, " ") = "&ANALYZE-SUSPEND") 
    AND (entry(2, _clipboard_editor:SCREEN-VALUE, " ") = "_EXPORT-NUMBER") THEN DO:

      /* Make sure the OCX control file is retrieved. Windows 3.1 only. */
      IF (OPSYS = "WIN32":u) THEN ASSIGN _control_cb_op = true.
      
      RUN adeuib/_qssuckr.p(temp_file, "", "IMPORT":U, FALSE).
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      RUN display_current.
      
      /* SEW Update after adding widgets in UIB. */
      RUN call_sew ("SE_ADD":U).
      
      OS-DELETE VALUE((SUBSTR(temp_file, 1, R-INDEX(temp_file, ".") - 1) + {&STD_EXT_UIB_QS})).
      _save_file = cvCurrentSaveFile.
      
      IF OPSYS = "WIN32":u THEN ASSIGN _control_cb_op = false.

      /* set the file-saved state to false, since we just pasted object(s) */
      RUN adeuib/_winsave.p(_h_win, FALSE).
    END.
    ELSE DO:
      MESSAGE "The contents of the clipboard cannot be pasted into the design window."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    OS-DELETE VALUE(temp_file).
    
    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.  
  END.
  END. /* DO ON STOP */
  
  /* Restore clipboard multiple value. */
  ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
    
END PROCEDURE.

/* choose_tab_edit is the procedure that fires off the tab-editor. */
PROCEDURE choose_tab_edit:

  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:     
    FIND _U WHERE _U._HANDLE = _h_frame.
    RUN adeuib/_tabedit.w (RECID (_U)).
  END.
END PROCEDURE.

/* choose-pointer is a procedure to change the _next_draw tool back to       */
/*                the pointer tool.                                          */
PROCEDURE choose-pointer.
  DEFINE VARIABLE toolframe AS WIDGET-HANDLE.
  
  /* Unhilite the current tool  - if it isn't the pointer  */
  IF hDrawTool NE ? AND hDrawTool:PRIVATE-DATA NE "POINTER":U
  THEN DO:
    ASSIGN hDrawTool:HIDDEN  = no
           toolframe         = hDrawTool:FRAME
           toolframe:bgcolor = ?. 
  END.  
  /* Hide the old lock -- pointer mode is NEVER locked */
  IF h_lock NE ? AND h_lock:HIDDEN ne YES 
  THEN h_lock:HIDDEN = YES.
  /* Set the current selection to the pointer.                */
  ASSIGN hDrawTool         = h_wp_Pointer
         hDrawTool:HIDDEN  = yes
         goBack2pntr       = TRUE 
         ldummy            = _h_object_win:LOAD-MOUSE-POINTER("":U)
         toolframe         = hDrawTool:FRAME
         toolframe:bgcolor = 7.   

  /* Make everything selectable and movable again.
     For speed, only do this if the old mode was not pointer.  */
  IF _next_draw <> ? THEN DO:
    FOR EACH _U WHERE _U._HANDLE <> ? AND
        NOT CAN-DO("WINDOW,DIALOG-BOX,MENU,SUB-MENU,MENU-ITEM", _U._TYPE):
      ASSIGN _U._HANDLE:MOVABLE  = TRUE
             _U._HANDLE:SELECTABLE = (_U._SUBTYPE <> "LABEL").
    END.
    IF _h_win NE ? THEN ldummy = _h_win:LOAD-MOUSE-POINTER("":U).
  END.
  ASSIGN _next_draw = ? /* Indicates POINTER mode (nothing to draw next) */
         _object_draw = ?
         _custom_draw = ?
         _palette_choice = ?
         _palette_custom_choice = ?
         widget_click_cnt = 0
         .
  RUN adeuib/_setpntr.p (_next_draw, input-output _object_draw).
  /* Show the user we are using the Pointer Tool */
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Tool},  h_wp_Pointer:HELP).
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, "":U).
END PROCEDURE. /* choose-pointer */

/* choose_proc_settings - bring up the property sheet for current procedure. */
PROCEDURE choose_proc_settings:
  DEFINE VAR cur_page AS INTEGER NO-UNDO.
  
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    /* Save the current page incase the user changes it. */
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
    cur_page = _P._page-current.
    /* Procedure Settings editor */ 
    RUN adeuib/_edtproc.p (_h_win). 
    IF cur_page NE _P._page-current THEN RUN display_page_number.
  END. 
END PROCEDURE.

/* choose_prop_sheet - bring up the property sheet. */
PROCEDURE choose_prop_sheet:

  IF _h_cur_widg <> ?
  THEN run property_sheet (_h_cur_widg).
  ELSE MESSAGE "No object is currently selected." {&SKP}
               "Please select an object with the pointer and try again."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.  
END PROCEDURE.

/* choose_template - called by 'New' popup menu */
PROCEDURE choose_template.
  DEFINE VARIABLE pFileName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pAbsoluteFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pOK               AS LOGICAL   NO-UNDO.                  

  RUN adecomm/_fndfile.p (INPUT "Choose Other Template",             /* pTitle            */
                          INPUT "TEMPLATE",                          /* pMode             */
                          INPUT "Windows (*.w)|*.w|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&TEMPLATE-DIRS},             /* pDirList          */
                          INPUT-OUTPUT pFileName,                    /* pFileName         */
                          OUTPUT       pAbsoluteFileName,            /* pAbsoluteFileName */
                          OUTPUT       pOK).                         /* pOK               */
  IF pOK AND pAbsoluteFileName <> "" THEN 
    RUN adeuib/_open-w.p (pAbsoluteFileName, "", "UNTITLED":U).
    
END PROCEDURE. /* choose_template */
  
/* choose_run - called by F2 or Compile/Run. */
PROCEDURE choose_run.
  RUN call_run ("RUN").
END PROCEDURE.

/* choose_show_palette - called by CTRL-T or Windows/Show Tool Palette.
   This shows or hides the tool palette. */
PROCEDURE choose_show_palette:
  DEFINE VAR h AS WIDGET  NO-UNDO.

  IF _AB_License EQ 2 THEN RETURN.
  h = mi_show_toolbox.
  IF _h_object_win:VISIBLE THEN
    ASSIGN _h_object_win:HIDDEN = yes
           h:LABEL              = "Show Object &Palette".
  ELSE DO:  
    /* Restore iconinized (Minimized) palette. (Note we have to apply
       the WINDOW-RESTORED event manually because it won't fire in
       this case.)  */
    IF _h_object_win:WINDOW-STATE = WINDOW-MINIMIZED THEN DO:
      _h_object_win:WINDOW-STATE = WINDOW-NORMAL.
      APPLY "WINDOW-RESTORED":U TO _h_object_win.
    END.
    /* Show the palette window */
    ASSIGN _h_object_win:HIDDEN  = no
           ldummy                = _h_object_win:MOVE-TO-TOP()
           h:LABEL               = "&Hide Object Palette".
  END.
END PROCEDURE. /* choose_show_palette */

/* choose_uib_browser:  First we deselect everything, because"
    1) the browser doesn't show the cur_widg [due to 7.1C browser limitation
       setting the CURRENT-ITERATION.
    2) we need to have nothing selected for the reinstantiation logic to work
       (in case user goes into a property sheet and changes NO-BOX, for example)
       This gets around a UIB limitation where reinstantiate = DELETE/UNDO of
       selected objects . */
PROCEDURE choose_uib_browser.

   IF NOT CAN-FIND(FIRST _U) THEN DO:
     MESSAGE "There are no objects to list." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     RETURN.
   END.
   RUN deselect_all (?, ?).  /* 7.1C needed for our new reinstantiation logic */

   /* SEW call to store current trigger code for specific window. */
   RUN call_sew ("SE_STORE_WIN":U).
   RUN adeuib/_uibrows.p.
   IF VALID-HANDLE(_h_cur_widg) THEN DO:
     FIND _U WHERE _U._HANDLE = _h_cur_widg.
     IF _U._LAYOUT-NAME NE "Master Layout"  AND _U._TYPE = "TEXT" THEN DO:
       /* Can't select a text widget in an alternate layout */
       FIND _U WHERE _U._HANDLE = _h_frame.
       ASSIGN _h_cur_widg = _h_frame.
     END.
     /* If removed from layout everywhere, delete it */
     IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                                NOT _L._REMOVE-FROM-LAYOUT) AND
                                NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) AND
                                _U._STATUS = "NORMAL" THEN RUN choose_erase.
     RUN display_current.  
     /* Pop the window with the current widget to the top and make it active. */
     ldummy = _h_win:MOVE-TO-TOP ().
     APPLY "ENTRY":U TO _h_win.  /* See bug #94-06-13-04 */
   END. 
   
   /* SEW Update after adding widgets in UIB. */
   RUN call_sew ("SE_PROPS":U).

END PROCEDURE.

/* choose_undo - called by CTRL-Z or Edit/Undo */
PROCEDURE choose_undo.
  /* Say that we are undoing the current action (Note: the undo menu-item is
     of the form "Undo Move". */
  /* This is necessary as the CTRL-Z will fire this even if there is nothing to undo */
  IF NUM-ENTRIES(_undo-menu-item:LABEL," ":U) < 2 THEN DO:
    MESSAGE "There is nothing to undo." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  
  RUN setstatus ("WAIT":U, "Undoing " + ENTRY(2,_undo-menu-item:LABEL, " ":U) + 
                          "...":U).   /* Show the wait-cursor  */
  RUN adeuib/_undo.p.
  RUN setstatus ("":U, " ":U).        /* Clear the wait-cursor */
  
  RUN display_current.  /* Show the last widget undone */
  
  /* SEW Update after adding/deleting widgets in UIB. */
  RUN call_sew ("SE_UNDO":U).
  
  FIND LAST _action NO-ERROR.
  IF (NOT AVAILABLE _action) THEN RUN DisableUndoMenu.
  ELSE RUN UpdateUndoMenu( "&Undo " +
                           SUBSTRING(_action._operation, 4, -1, "CHARACTER":U) ).
END PROCEDURE. /* choose_undo */

           
/* curframe  is a procedure to change the currently frame and window.         */
/*           This procedure is called when the user                           */
/*           clicks anywhere but you don't want to change the curwidg.        */
/*           NOTE _h_cur_widg is set to ? if the frame is different           */
PROCEDURE curframe :
  DEFINE INPUT PARAMETER h_thing AS WIDGET                         NO-UNDO.

  DEFINE VAR old_frame  AS WIDGET-HANDLE                           NO-UNDO.
  DEFINE VAR old_win    AS WIDGET-HANDLE                           NO-UNDO.

  /* Is this widget in a frame that differs from the _h_cur_widg. */
  IF h_thing <> _h_cur_widg THEN DO:
    /* Set the current widget and check that the frame has changed */
    ASSIGN old_frame   = _h_frame
           old_win     = _h_win.
    FIND _U WHERE _U._HANDLE = h_thing.
    _h_win = _U._WINDOW-HANDLE.
    CASE _U._TYPE:
      WHEN "WINDOW" THEN 
        ASSIGN _h_frame = ?.
      /* Dialog boxes*/
      WHEN "DIALOG-BOX" THEN 
        ASSIGN _h_frame = h_thing.
      /* frames (can parent to frames OR windows) */
      WHEN "FRAME" THEN 
        ASSIGN _h_frame = h_thing.
      /* menus, sub-menus and menu-items */
      WHEN "MENU" OR WHEN "SUB-MENU" OR WHEN "MENU-ITEM" THEN 
        ASSIGN _h_frame = ?.
      /* SmartObjects and Queries can parent to frames or windows */
      WHEN "SmartObject" OR WHEN "QUERY" THEN
        ASSIGN _h_frame = h_thing:PARENT    /* Window OR field-group */
               _h_frame = (IF _h_frame:TYPE eq "WINDOW" THEN ?
                           ELSE _h_frame:PARENT).
      OTHERWISE      
        ASSIGN _h_frame = h_thing:PARENT    /* field-group    */
               _h_frame = _h_frame:PARENT.  /* the real frame */
    END CASE.
      
    /* If we are in a new frame, then there is no current widget. */
    IF (_h_frame <> old_frame) THEN  _h_cur_widg = ?. 
    
    /* Finally, if we are in a new window, update various things. */
    IF (_h_win <> old_win) THEN DO:
        _h_cur_widg    = ?.
      FIND _U WHERE _U._HANDLE = _h_win.
      FIND _L WHERE RECID(_L)  = _U._lo-recid.
      FIND _C WHERE RECID(_C)  = _U._x-recid.
      IF VALID-HANDLE(old_win) THEN ldummy = old_win:LOAD-MOUSE-POINTER("":U).
      ASSIGN  ldummy        = _h_win:LOAD-MOUSE-POINTER(IF _next_draw = ?
                                     THEN "" ELSE {&start_draw_cursor})
              _cur_win_type = _L._WIN-TYPE
              _cur_col_mult = _L._COL-MULT
              _cur_row_mult = _L._ROW-MULT
              .
      /* DESELECT everything that is selected in other windows. */
      RUN deselect_all (?, _h_win).
    END.
  END.
END PROCEDURE. /* curframe */

/* curwidg  is a procedure to change the currently selected widget,          */
/*          frame and window.  This procedure is called when the user        */
/*          clicks anywhere the user selects a widget.                       */
PROCEDURE curwidg:
  /* Has anything changed? */
  IF SELF ne _h_cur_widg THEN DO:
    RUN curframe (SELF).    
    _h_cur_widg = SELF.
  END.
  /* Show the new current widget, if necessary. */
  IF _h_cur_widg ne h_display_widg THEN RUN display_current.

END PROCEDURE. /* curwidg */

/* del_cur_widg_check  Check to see if the "current widget" still exists    */
PROCEDURE del_cur_widg_check :
  /* Show the current widget, which should be empty. */
  FIND _U where _U._HANDLE = _h_cur_widg NO-ERROR.
  IF (NOT AVAILABLE _U) OR _U._STATUS = "DELETED" THEN DO:
    /* The current widget was deleted, find another current object */
    /* Was the current widget a field level object? */
    IF _h_cur_widg NE _h_frame AND _h_cur_widg NE _h_win THEN DO:
      _h_cur_widg = ?.
      FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
      IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
      THEN _h_cur_widg = _h_frame.
      ELSE DO:  /* No frame available, find a window */
        _h_frame = ?.
        FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
        IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
        THEN _h_cur_widg = _h_win.
        ELSE RUN adeuib/_vldwin.p (?). /* Find normal window */
      END.  /* Else find a window */
    END.  /* Deleted current widget wasn't the current frame or window */

    /* Was the current frame a deleted object? */
    ELSE IF _h_cur_widg = _h_frame THEN DO:
      ASSIGN _h_cur_widg    = ?
             _h_frame       = ?
             .
      FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
      IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
      THEN _h_cur_widg = _h_win.
      ELSE RUN adeuib/_vldwin.p (?). 
    END.  /* Current widget was a deleted frame */

    ELSE RUN adeuib/_vldwin.p (?). /* The current widget was a window */
  END.  /* The current object was deleted */

  /* Show the current window/widget (if there is one). */
  RUN display_current.
  
  /* jep - SEW Update after delete event in UIB. */
  RUN call_sew ("SE_DELETE":U).
  
END PROCEDURE. /* del_cur_widg_check */

/* delselected is the procedure to deleted all selected widgets.  This is   */
/*           run only have the user has confirmed that this is what     */
/*           they want.                                                 */
PROCEDURE delselected.
  /* Delete selected FRAME and DIALOG-BOX first. */
  RUN DeleteSelectedComposite.

  /* Now delete all other selected field-level widgets. */
  FOR EACH _U WHERE _U._SELECTEDib:
    /* Do not put menus on the UNDO stack */
    IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
      CREATE _action.
      ASSIGN _action._seq-num       = _undo-seq-num
             _action._operation     = "Delete"
             _action._u-recid       = RECID(_U)
             _action._window-handle = _U._WINDOW-HANDLE
             _undo-seq-num          = _undo-seq-num + 1.
             
      /* If this is an OCX control then save and remember
       * the state of the OCX in a binary file.
       */
      IF OPSYS = "WIN32":u THEN
      DO:
        DEFINE VARIABLE S AS INTEGER NO-UNDO.
        IF _U._TYPE = "{&WT-CONTROL}" THEN
        DO:
            FIND _F WHERE RECID(_F) = _U._x-recid.
            RUN adecomm/_tmpfile.p({&STD_TYP_UIB_CLIP}, {&STD_EXT_UIB_WVX},
                                   OUTPUT _F._VBX-BINARY).
/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.
            RUN ControlSaveControl IN _h_controls (_U._HANDLE,
                                                   _F._VBX-BINARY,
                                                   OUTPUT s).
*/                                                  
            _U._COM-HANDLE:SaveControls(_F._VBX-BINARY, _U._NAME).
            _F._VBX-BINARY = _F._VBX-BINARY + "," + _U._NAME.
        END.
      END.
      
    END.
   
    {adeuib/delete_u.i &TRASH = FALSE}
  END.  /* For each selected widget */
  /* Have we deleted the current widget? */
  RUN del_cur_widg_check.
END.  /* PROCEDURE delselected */

/* deselect_all: Deselect all widgets (except except_h) that are not in  */
/*               window except_h_win                                     */
PROCEDURE deselect_all:
  def input parameter except_h     as widget no-undo.
  def input parameter except_h_win as widget no-undo.
  
  FOR EACH _U WHERE _U._SELECTEDib
                AND _U._HANDLE ne except_h
                AND _U._WINDOW-HANDLE ne except_h_win:
     _U._SELECTEDib      = FALSE.
     IF VALID-HANDLE(_U._HANDLE) THEN _U._HANDLE:SELECTED = FALSE.
  END.
END PROCEDURE. /* deselect_all */

/* designFrame.ControlNameChanged: Special trigger for Control-Frames...
   Gets the new name of a control when it's changed in the Property Editor */
PROCEDURE designFrame.ControlNameChanged:
  DEFINE INPUT PARAMETER hCtrl      AS COM-HANDLE. /* OCX Control   */
  DEFINE INPUT PARAMETER oldname    AS CHARACTER.  /* old name of control */
  DEFINE INPUT PARAMETER newname    AS CHARACTER.  /* new name of control */

  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = newname
         _U._LABEL    = newname.
  RUN Display_Current IN _h_uib.   /* update data in the Main Window */
  RUN call_sew ("SE_PROPS":U). /* notify Section Editor of change */
END PROCEDURE. /* designFrame.ControlNameChanged */

/* designFrame.ObjectCreated:  Special trigger for Control-Frames...
   Grab the name of each OCX control created within a Control-Frame */
PROCEDURE designFrame.ObjectCreated:
  DEFINE INPUT PARAMETER name       AS CHARACTER.  /* name of control */
  
  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = name
         _U._LABEL    = name.
END PROCEDURE. /* designFrame.ObjectCreated */

/* dialog-close  - redirects this to wind-close after making sure that h_self
 *             points to the proper widget (and not the dummy window itself). */
procedure dialog-close.
  DEFINE INPUT PARAMETER h_self  AS WIDGET  NO-UNDO.
  IF h_self:TYPE = "WINDOW":U THEN 
    h_self = h_self:FIRST-CHILD.
  RUN wind-close (h_self).
END PROCEDURE.

/* disable_widgets - procedure to disable the UIB so that another tool can run */
procedure disable_widgets.
  DEFINE VAR h           AS WIDGET  NO-UNDO.
  DEFINE VAR ldummy      AS LOGICAL NO-UNDO.
  
  /* DESELECTION everything (because if we don't we might run setdeselection
     when we click in the windows we are running */
  FOR EACH _U WHERE _U._SELECTEDib AND _U._TYPE <> "WINDOW":
    _U._SELECTEDib        = FALSE.
    IF _U._STATUS <> "DELETED" THEN _U._HANDLE:SELECTED = FALSE.
  END.
  
  /* SEW call to hide the SEW if its visible. */
  RUN call_sew ("SE_HIDE":U).
 
  ASSIGN 
    _h_menu_win:SENSITIVE      = no  
    _h_status_line:SENSITIVE   = no /* Status bar has some dbl-click actions */
    MENU m_menubar:SENSITIVE   = no.
  
  /* Hide all children of the UIB Main window.  This should include:
         Object Palette, Design Windows, Attribute Window, Section Editor
         and Cue Cards
     Keep a list of these windows so we can show them again later. */
  ASSIGN h = _h_menu_win:FIRST-CHILD
         windows2view = "".
  DO WHILE VALID-HANDLE(h):
    IF h:TYPE eq "WINDOW" AND h:VISIBLE THEN DO:
      IF windows2view eq "" THEN  windows2view = STRING(h).
      ELSE windows2view = windows2view + "," + STRING(h).
      h:HIDDEN = yes.
    END.
    ASSIGN h = h:NEXT-SIBLING.
  END.
  /* Hide OCX Property Editor window. */
  RUN show_control_properties (2).
  
  DO WITH FRAME action_icons:
    /* Desensitize the action bar. */
    DO i = 1 TO {&bar_count}:
      h_button_bar[i]:SENSITIVE = NO.
    END.
    ASSIGN
      /* Store the sensitivity of the fill-in fields */
      cur_widg_text:PRIVATE-DATA = IF cur_widg_text:SENSITIVE THEN "y" ELSE "n"
      cur_widg_text:SENSITIVE    = NO
      cur_widg_name:PRIVATE-DATA = IF cur_widg_name:SENSITIVE THEN "y" ELSE "n"
      cur_widg_name:SENSITIVE    = NO.
    IF VALID-HANDLE(Mode_Button) THEN Mode_Button:SENSITIVE = NO.
  END.
  
  /* Restore the users value for THREE-D. Ditto for DATE-FORMAT. */
  ASSIGN SESSION:THREE-D     = save_3d
         SESSION:DATE-FORMAT = _orig_dte_fmt.
  
  /* Set Pause before-hide so that running from the UIB acts like running
     from the editor. */
  PAUSE BEFORE-HIDE.

  /* Unset UIB as active ADE tool. */
  ASSIGN h_ade_tool = ?.

END. /* PROCEDURE disable_widgets */


/* disp_help        Dispatches help for the current widget.  This means  */
/*                  that it calls help with the context-id set to the    */
/*                  property sheet help of the widget type               */
PROCEDURE disp_help:
  DEFINE VARIABLE help-context AS INTEGER NO-UNDO.
  DEFINE BUFFER i_U FOR _U.
  DEFINE BUFFER i_P FOR _P.
  
  FIND i_U WHERE i_U._HANDLE = _h_cur_widg NO-ERROR.
     
  IF AVAILABLE i_U THEN DO:
    FIND i_P WHERE i_p._WINDOW-HANDLE = i_u._WINDOW-HANDLE NO-ERROR.
     /* tree-view have different help */
    IF VALID-HANDLE(i_p._tv-proc) THEN 
    DO:  
      CASE i_U._TYPE:
        WHEN "EDITOR"         THEN help-context = {&EDITOR_Web}.
        WHEN "FILL-IN"        THEN help-context = {&FILL_IN_Web}.
        WHEN "RADIO-SET"      THEN help-context = {&RADIO_SET_Web}.
        WHEN "SELECTION-LIST" THEN help-context = {&SELECTION_LIST_Web}.
        WHEN "TOGGLE-BOX"     THEN help-context = {&TOGGLE_BOX_Web}.
        OTHERWISE DO:
          help-context = IF DYNAMIC-FUNCTION('FileIsHTMLMapping':U IN i_p._tv-proc)
                         THEN {&HTML_Mapping_Procedure_Treeview}                               
                         ELSE {&Code_only_Treeview}.
        END.
      END CASE.
    END.
    ELSE DO:
      CASE i_U._TYPE:
        WHEN "BROWSE"         THEN help-context = {&BROWSER_Attrs}.
        WHEN "BUTTON"         THEN help-context = {&BUTTON_Attrs}.
        WHEN "COMBO-BOX"      THEN help-context = {&COMBO_BOX_Attrs}.
        WHEN "DIALOG-BOX"     THEN help-context = {&DIALOG_BOX_Attrs}.
        WHEN "EDITOR"         THEN help-context = {&EDITOR_Attrs}.
        WHEN "FILL-IN"        THEN help-context = {&FILL_IN_Attrs}.
        WHEN "FRAME"          THEN help-context = {&FRAME_Attrs}.
        WHEN "IMAGE"          THEN help-context = {&IMAGE_Attrs}.
        WHEN "RADIO-SET"      THEN help-context = {&RADIO_SET_Attrs}.
        WHEN "RECTANGLE"      THEN help-context = {&RECTANGLE_Attrs}.
        WHEN "SELECTION-LIST" THEN help-context = {&SELECTION_LIST_Attrs}.
        WHEN "SmartObject"    THEN help-context = {&Property_Sheet_SmartObjects}.
        WHEN "SLIDER"         THEN help-context = {&SLIDER_Attrs}.
        WHEN "TEXT"           THEN help-context = {&TEXT_Attrs}.
        WHEN "TOGGLE-BOX"     THEN help-context = {&TOGGLE_BOX_Attrs}.
        WHEN "{&WT-CONTROL}"  THEN i_U._COM-HANDLE:ShowHelp().
        WHEN "WINDOW"         THEN help-context = {&WINDOW_Attrs}.
      END CASE.
    END. /* not htm */
    
    IF i_U._TYPE NE "{&WT-CONTROL}":U THEN
    DO:
      RUN adecomm/_adehelp.p ( "AB", "CONTEXT", help-context, ? ).
    END.
  END. /* if avail i_U */
END. /* PROCEDURE disp_help */

/* display_current  shows the name and label of the current widget in    */
/*                  in the menu window.                                  */
PROCEDURE display_current:
  /* This is only debugging code I use to see if current window/frame/widget
     is set correctly --------------------------------- 
  DISPLAY ((IF _h_cur_widg NE ? THEN STRING(_h_cur_widg) ELSE "?") + " " +
           (IF _h_frame NE ?    THEN STRING(_h_frame)    ELSE "?") + " " + 
           (IF _h_win NE ?      THEN STRING(_h_win)      ELSE "?"))
           AT ROW 2.8 COL 38 BGC 1 FGC 15 FORMAT "X(30)"  VIEW-AS TEXT
       WITH FRAME action_icons.  
    -------------------------------------------------------------------- */
  DEFINE VARIABLE cs-char  AS CHARACTER CASE-SENSITIVE NO-UNDO.
  DEFINE VARIABLE l_master AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER ipU FOR _U.
  
  /* DBG STATEMENTs to help reduce flashing
  def var zzz as char no-undo.
  zzz =  LAST-EVENT:LABEL +      "  " + LAST-EVENT:FUNCTION + "  " +
      /* LAST-EVENT:EVENT-TYPE + "  " + */ LAST-EVENT:TYPE +     "  (" +
           STRING(LAST-EVENT:X) + "," +   STRING(LAST-EVENT:Y) + ")".
    run adecomm/_statdsp.p (_h_status_line, {&STAT-Main}, zzz). */
    
  /* To reduce flashing, check the last event.  If we did a MOUSE-SELECT
     DOWN in a UIB widget, then ignore the event. */
  IF NOT (LAST-EVENT:LABEL eq "MOUSE-SELECT-DOWN":U AND 
          CAN-FIND (ipU WHERE ipU._HANDLE eq SELF))
  THEN DO WITH FRAME action_icons:   

    /* Before changing the current displayed widget, make sure any user 
       changes to cur_widg_name and cur_widg_text are dealt with.

      [This is because clicking in another window does not explicitly send
      LEAVE to the fields in the main window].  First check for VALID-HANDLE
      to avoid changing deleted widgets or current widget UNKNOWN.

      Note 1:
      We don't need to check for changes on fill-ins that aren't sensitive.

      Note 2:
      This code is also in uibmtrig.i ON LEAVE OF _h_menu_win. Its needed here
      because under Windows, clicking back into the design window's frame
      does not fire the LEAVE event.  It does under Motif. I think this
      is a bug, but I'll have to figure it out better and log a separate bug.
      The ON LEAVE trigger fixes bug 94-03-11-046. (jep 08/08/94).
      */     
      
    IF VALID-HANDLE(h_display_widg) THEN DO:
      error_on_leave = no.
      IF cur_widg_name:SENSITIVE AND INPUT cur_widg_name NE display_name THEN
        APPLY "LEAVE":U TO cur_widg_name.
      IF cur_widg_text:SENSITIVE AND INPUT cur_widg_text NE display_text THEN
        APPLY "LEAVE":U TO cur_widg_text.
      IF error_on_leave THEN RETURN.
    END.
    
    FIND _U WHERE _U._HANDLE = _h_cur_widg AND _U._STATUS <> "DELETED"
            NO-ERROR.
    IF AVAILABLE _U AND _next_draw eq ? THEN DO:
      /* Menus don't have _L's */
      FIND _L WHERE RECID(_L) = _U._lo-recid NO-ERROR.
      /* Move FOCUS to the current widget, if possible. This is because Motif
         sometimes gets lost (and sometimes shows a large focus border.  
         Regardless, always make sure FOCUS is set (otherwise the ON ANYWHERE
         triggers will not work.  NOTE that we don't apply entry to the
         current widget because this will highlight it in certain cases
         (eg. if it is a COMBO-BOX or FILL-IN).  */
      &IF "{&WINDOW-SYSTEM}" eq "OSF/Motif" 
      &THEN IF FOCUS ne _h_cur_widg THEN APPLY "ENTRY":U TO _h_win. 
      &ELSE IF FOCUS eq ? THEN APPLY "ENTRY":U TO _h_win. 
      &ENDIF
      /* Show it selected */
      IF CAN-SET(_h_cur_widg,"SELECTED":U) AND _U._TYPE NE "DIALOG-BOX":U 
      THEN ASSIGN _U._SELECTEDib       = yes 
                  _h_cur_widg:SELECTED = yes.
    
      /* Edit the name (except for text widgets which will be literals)   */
      /* and db fields where we shouldn't allow name changes.             */
      /* The trigger button is disabled for widgets that don't have names */
      ASSIGN cur_widg_name            = IF (_U._TABLE = ?) THEN _U._NAME
                                        ELSE _U._NAME + " (" +  _U._TABLE + ")"
             cur_widg_name:SENSITIVE  = (_U._TYPE <> "TEXT") AND
                                           (_U._TABLE = ?).
      IF _U._TABLE NE ? THEN DO:
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._DISPOSITION eq "LIKE" THEN
          ASSIGN cur_widg_name = _U._NAME.
      END.  /* If there is a table name */

      /* Label, etc. is only edittable in Master Layout. */
      l_master = _U._LAYOUT-NAME eq "{&Master-Layout}".
      
      /* What is it? Is it text (then show value). Does it have a label?   */
      /* then show it (NOTE: TEXT has a LABEL but the UIB doesn't use it). */
      /* Show TITLE for frames/windows                                     */
      /* Show name for html objects and don't check their widget type */      
      IF CAN-FIND (_HTM WHERE _HTM._U-recid = RECID(_U)) THEN DO:     
        FIND _HTM WHERE _HTM._U-recid = RECID(_U).
        ASSIGN cur_widg_text:SENSITIVE    = FALSE
               cur_widg_text              = _htm._HTM-NAME.
        IF cur_widg_text:LABEL <> "Name":R7 THEN
          ASSIGN cur_widg_text:LABEL = "Name":R7.       
      END.  /* If an HTML object */
      ELSE IF CAN-DO("EDITOR,IMAGE,MENU,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,{&WT-CONTROL}",
                _U._TYPE) THEN DO:
        IF _U._TYPE <> "{&WT-CONTROL}" THEN DO:
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = "":U.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.  /* If not an OCX */
        ELSE DO: /* Must be one of Ed, Img, Menu, RS, Rect, Sel-L or Slider */
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = _U._OCX-NAME.
          IF cur_widg_text:LABEL <> "OCX":R7 THEN
            ASSIGN cur_widg_text:LABEL = "OCX":R7.
        END.  /* Must be one of the list above */
      END.  /* If can-do a bunch */
      ELSE DO:  /* Else something else */
        IF _U._TYPE = "TEXT" THEN DO:
          FIND _F WHERE RECID(_F)  = _U._x-recid.
          ASSIGN cur_widg_text           = _F._INITIAL-DATA
                 cur_widg_text:SENSITIVE = l_master.
          IF cur_widg_text:LABEL <> "Text":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Text":R7.
        END.  /* If text */
        ELSE IF _U._TYPE = "SmartObject" THEN DO:
          FIND _S WHERE RECID(_S)  = _U._x-recid.
          ASSIGN cur_widg_text           = _S._FILE-NAME
                 cur_widg_text:SENSITIVE = NO.
          IF cur_widg_text:LABEL <> "Master":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Master":R7.
        END.  /* If SmartObject */
        ELSE IF _U._TYPE eq "WINDOW" THEN DO:
          /* Don't show the Window if it is not allowed */
          IF _U._SUBTYPE ne "Design-Window":U THEN DO:
            FIND _C WHERE RECID(_C) = _U._x-recid.
            ASSIGN cur_widg_text        = IF _U._LABEL ne ?
                                          THEN _U._LABEL ELSE "".
            IF cur_widg_text:LABEL <> "Title":R7 
            THEN cur_widg_text:LABEL = "Title":R7.
            cur_widg_text:SENSITIVE = l_master.
          END. 
          ELSE DO:
            /* Don't show the true name */
            FIND _P WHERE _P._u-recid eq RECID(_U).
            ASSIGN cur_widg_text = IF _P._SAVE-AS-FILE eq ? THEN "Untitled" 
                                   ELSE _P._SAVE-AS-FILE
                   cur_widg_name = _P._TYPE
                   cur_widg_text:SENSITIVE = NO
                   cur_widg_name:SENSITIVE = no.
            IF cur_widg_text:LABEL <> "File":R7 THEN
              ASSIGN cur_widg_text:LABEL = "File":R7.
          END.
        END.  /* If Window */
        ELSE IF CAN-DO("BROWSE,DIALOG-BOX,FRAME":U, _U._TYPE) THEN DO:
          FIND _C WHERE RECID(_C) = _U._x-recid.
          ASSIGN cur_widg_text        = IF _U._LABEL ne ?
                                        THEN _U._LABEL ELSE "".
          IF cur_widg_text:LABEL <> "Title":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Title":R7.
                 
          /* Browses and frames with no-box can't change title */
          IF CAN-DO("BROWSE,FRAME":U, _U._TYPE)
             AND (_L._NO-BOX OR _C._TITLE eq NO)
          THEN ASSIGN cur_widg_text:SENSITIVE = NO
                      cur_widg_text           = "<No Title>".
          ELSE cur_widg_text:SENSITIVE = l_master. 
        END.  /* If Browse, Dialog or Frame */
        ELSE IF CAN-SET(_U._HANDLE, "LABEL") THEN DO:
          ASSIGN cur_widg_text           = (IF _U._LABEL-SOURCE EQ "D" 
                                            THEN "?" ELSE _U._LABEL)
                 cur_widg_text:SENSITIVE = l_master.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.  /* If if label is a valid, setable attribute */
        ELSE DO:
          ASSIGN cur_widg_text           = "<not defined>":U 
                 cur_widg_text:SENSITIVE = NO.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.            
      END.  /* ELSE DO (not editor,image,radio-set etc. */
    END.  /* If AVAIL _U AND next_draw eq ? */
    
    /* No current widget -- blank everything out.  (Or show multiple
       selections.)*/
    ELSE ASSIGN cur_widg_name           = "":U
                cur_widg_text           = "":U   
                cur_widg_text:SENSITIVE = NO
                cur_widg_name:SENSITIVE = no
                /* This is a safety net incase CURRENT-WINDOW is ever reset */
                CURRENT-WINDOW          = _h_menu_win.

    /* To avoid unnecessary flashing only display things that changed */
    ASSIGN cs-char = cur_widg_name.
    IF cs-char NE INPUT cur_widg_name THEN 
      display cur_widg_name.

    /* Now redisplay the text field to get around a 4GL bug that was
       eating all the "&" characters when I set the SCREEN-VALUE. */
    ASSIGN cs-char = cur_widg_text.
    IF cs-char NE INPUT cur_widg_text THEN 
      display cur_widg_text.
    
    /* Change the sensitivity on buttons etc. */
    RUN sensitize_main_window ("WIDGET").
    
    /* Store the currently displayed values */
    ASSIGN h_display_widg = _h_cur_widg
           display_name   = cur_widg_name
           display_text   = cur_widg_text. 
    
    /* Now display (or hide) items depending on the current window. 
       This catches changing the current window, or changing pages
       in the current window. */
    RUN display_curwin.
  
    /* Show the current values in the Attributes window. */
    IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
    THEN RUN show-attributes IN hAttrEd NO-ERROR.
    
    /* Show OCX Property Editor Window. Don't do this if the user is changing
       the Name attribute in the Prop Ed. We don't need to refresh the Prop Ed
       window at that point. */
    IF NOT PROGRAM-NAME(2) BEGINS "DesignFrame.ControlNameChanged":U THEN
      RUN show_control_properties (0).
      
  END. /* If not mouse-select-down. */  
END PROCEDURE. /* display_current */

/* display_curwin -  when the current window changes, then hide or show 
   information relevant to it */
PROCEDURE display_curwin:
  DEFINE VAR h_true_win     AS HANDLE      NO-UNDO.
  DEFINE VAR new-visual-obj AS LOGICAL     NO-UNDO.
  DEFINE VAR new-mode       AS CHARACTER   NO-UNDO.
      
  /* If the current window has not changed then do nothing */
  IF _h_win ne h_display_win THEN DO:
    IF VALID-HANDLE(_h_win) THEN FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
    IF AVAILABLE _P THEN DO:
      ASSIGN new-visual-obj = CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                                     (_U._TYPE = "FRAME" OR
                                                      _U._TYPE = "DIALOG-BOX")) AND
                                                      _P._TYPE NE "WEB-OBJECT":U
             new-mode       = IF _P._TYPE = "WEB-OBJECT" THEN "WEB" ELSE "UIB".
      IF new-visual-obj NE _visual-obj OR new-mode NE last-mode THEN DO:
        _visual-obj = new-visual-obj.
        RUN mode-morph (new-mode).
      END.
    END.  
    /* Sensitize the UIB main window based on the type of window. */
    RUN sensitize_main_window ("WINDOW").

    IF VALID-HANDLE(mi_goto_page) THEN DO:
      /* Show page information */
      IF VALID-HANDLE(_h_win) AND CAN-DO (_P._links, "PAGE-TARGET") THEN DO:  
        mi_goto_page:SENSITIVE = YES.
        RUN display_page_number.
      END.
      ELSE DO:
        mi_goto_page:SENSITIVE = NO.
        RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Page}, "").
      END. 
    END.  /* If it is a visual object */
   
    /* Save the value for next time */
    ASSIGN h_display_win = _h_win.
    
    /* Update the checked active window on the Window menu. */
    IF VALID-HANDLE( _h_WinMenuMgr ) AND VALID-HANDLE(_h_win) THEN DO:
      ASSIGN h_true_win = (IF _h_win:TYPE = "WINDOW":U
                             THEN _h_win ELSE _h_win:PARENT).
      RUN WinMenuSetActive IN _h_WinMenuMgr (_h_WindowMenu, h_true_win:TITLE).
    END.
  END. 
 
END PROCEDURE.

/* display_page_number - show the current page number in the UIB's status line.
   If the page number is long, then show it as "p. 123", if it is very long, then
   just show it.  Remove commas from really big numbers. */
PROCEDURE display_page_number :
  DEF VAR cPage AS CHAR NO-UNDO.
  IF _P._page-current eq ? THEN cPage = "All Pages".
  ELSE DO:
    cPage = LEFT-TRIM(STRING(_P._page-current, ">,>>>,>>9":U)).
    IF LENGTH (cPage, "CHARACTER") <= 1 THEN cPage = "Page " + cPage. 
    ELSE IF LENGTH (cPage, "CHARACTER") <=3 THEN cPage = "p. " + cPage.  
    ELSE IF LENGTH (cPage, "CHARACTER") < 6 THEN cPage = REPLACE(cPage,",":U,"":U).
  END.
  /* Show the new value. */
  RUN adecomm/_statdsp.p  (_h_status_line, {&STAT-Page}, cPage). 
END PROCEDURE.

/* drawobj is a procedure to figure out what widget is to be drawn in a frame */
PROCEDURE drawobj.
  DEFINE VARIABLE fproc      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lValid     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRowObj    AS LOGICAL   NO-UNDO INIT TRUE.

  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("drawobj"). &ENDIF

  IF _next_draw ne ? THEN DO:
    /* check 'drawing' permissions for this procedure */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    FIND _palette_item WHERE _palette_item._name = _next_draw.
    IF _palette_item._type EQ {&P-BASIC} OR _palette_item._type EQ {&P-XCONTROL} THEN DO:  
      CASE _next_draw:
        WHEN "DB-Fields" OR WHEN "Browse" OR WHEN "Query" THEN DO:
          IF NOT CAN-DO (_P._Allow, _next_draw) THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* DB-Fields, browse or Query */
        WHEN "Frame" THEN DO:
          RUN adeuib/_uibinfo.p (INT(RECID(_P)), ?, "FRAMES", OUTPUT fproc).
          CASE _P._max-frame-count:
            WHEN 0 THEN DO: /* No frames allowed */
              BELL.
              RETURN.
            END. /* When 0 */
            WHEN 1 THEN DO: /* Exactly 1 frame allowed */
              IF fproc NE ? AND fproc NE "" THEN DO:
                BELL.
                RETURN.
              END.
            END. /* When 1 */
          END CASE. /* _P._max-frame-count */
        END.  /* Frame */
        OTHERWISE DO:
          IF NOT CAN-DO(_P._ALLOW,"Basic") THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* Otherwise */
      END CASE.  /* CASE _next_draw */
    END.  /* If thing to draw is either a basic control or an Xcontrol */
    ELSE DO:  /* The thing to draw is either a SmartObject or a User object */
      CASE _next_draw:
        WHEN "SmartFolder" THEN IF NOT CAN-DO(_P._LINKS,"Page-Target") THEN DO:
            BELL.
            RETURN.
        END.
        
        WHEN "SmartDataField" THEN DO:
          /* First make sure that _P is a SmartViewer */
          IF _P._TYPE NE "SmartDataViewer" THEN DO:
            BELL.
            RETURN.
          END.

          /* Find the field to replace */
          ASSIGN hField = _h_win:FIRST-CHILD  /* The frame       */
                 hField = hField:FIRST-CHILD  /* The field group */
                 hField = hField:FIRST-CHILD. /* The first field */
          SEARCH-BLOCK:
          REPEAT WHILE hField ne ?:
            IF hField:X < _frmx AND
               hField:Y < _frmy AND
               hField:X + hField:WIDTH-PIXELS > _frmx AND
               hField:Y + hField:HEIGHT-PIXELS > _frmy THEN DO:
                 ASSIGN _h_cur_widg   = hField.
                 FIND _U WHERE _U._HANDLE = hField.

                 /* Presume the field is not a Data Field and save its name
                    for displaying in messages. */
                 ASSIGN lRowObj = NO
                        cName   = _U._NAME.

                 /* Determine if user clicked into a Data Field (e.g., an SDO
                    RowObject field or SBO field). Since Data Field objects are
                    managed using the _P object's temp tables, we can check for that
                    first. It could be a user-defined temp-table, so we need to
                    check its table type as well. "D" types are Data Fields, "T"
                    types are user defined temp-tables, etc. We want "D" types. -jep */
                 IF _U._DBNAME = "Temp-Tables":u THEN
                 DO:
                   /* In 9.1B, with SBOs, a Viewer can have fields which are qualified
                      by the SDO's ObjectName, not always RowObject, as is the case
                      with SDO's. _U._TABLE and _TT._NAME hold these values and we
                      use them to see if the _TT is for a Data Source object. -jep */
                   FIND FIRST _TT WHERE _TT._P-RECID = RECID(_P)
                                    AND _TT._NAME    = _U._TABLE NO-LOCK NO-ERROR.
                   IF AVAILABLE _TT THEN
                      ASSIGN lRowObj = (_TT._TABLE-TYPE = "D":U).
                   ELSE /* This should not happen. If it does, its not a valid field. */
                      ASSIGN lRowObj = NO.
                 END. /* IF Temp-Table THEN */

                 /* User did click in a Data Source field. */
                 IF lRowObj THEN
                 DO:
                   /* A field was clicked into and it is a Data Source
                     (RowObject or SBO) field. */
                   ASSIGN lValid        = TRUE
                          _h_cur_widg   = hField
                          hField:HIDDEN = TRUE
                          _U._HIDDEN    = TRUE.
                   LEAVE SEARCH-BLOCK.
                 END.
             END. /* If this field was clicked into */
             hField = hField:NEXT-SIBLING.
          END.  /* SEARCH-BLOCK: Repeat WHILE looking for the field */
          /* If a widget was clicked into but it was not a RowObject field
             we need to let the user know and return */
          IF NOT lRowObj AND NOT lValid THEN DO:
            MESSAGE cName "is not a Data Source field. A SmartDataField must be dropped onto a Data Source field.".
            BELL.
            RETURN.
          END.  /* If not lRowObj and not lValid */
          /* If no widget was clicked into then we need to let the user
             know and return */
          ELSE IF NOT lValid THEN DO:
            MESSAGE "A SmartDataField must be dropped onto a Data Source field.".
            BELL.
            RETURN.
          END.  /* Else if not lValid */          
        END.  /* When drawing a SmartDataField */
        
        OTHERWISE DO:
          ASSIGN canDraw = FALSE
                 canRun  = TRUE.
          {adeuib/sookver.i _object_draw canDraw yes}
          IF NOT canDraw THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* Otherwise */
      END CASE.
    END.

    /* Special case of TTY mode */
    IF (NOT _cur_win_type) AND CAN-DO("IMAGE,{&WT-CONTROL}",_next_draw) THEN DO:
      MESSAGE "Character mode windows cannot contain" _next_draw "objects."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      RUN choose-pointer.
      
      /*
       * No sense in trying to draw something that can't be drawn.
       */
      RETURN.
    END.
    IF VALID-HANDLE(mi_color) THEN DO:
      IF (NOT _cur_win_type) OR _next_draw = "IMAGE":U THEN
        ASSIGN h_button_bar[9]:SENSITIVE = FALSE
               mi_color:SENSITIVE        = FALSE.
      ELSE
        ASSIGN h_button_bar[9]:SENSITIVE = TRUE
               mi_color:SENSITIVE        = TRUE.
    END.

    
    /* Now draw... */
    RUN setstatus ("WAIT":U, "Drawing " + _next_draw + "...").
    IF LDBNAME("DICTDB":U) = ? OR DBTYPE("DICTDB":U)NE "PROGRESS":U THEN
    FIND-PRO:
    DO i = 1 TO NUM-DBS:
      IF DBTYPE(i) = "PROGRESS":U THEN DO:
        CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(LDBNAME(i)).
        LEAVE FIND-PRO.
      END.
    END.
  
    RUN adeuib/_drawobj.p (goback2pntr).
    
    IF RETURN-VALUE NE "NO DRAW" THEN DO:
      /* Show the current widget and reset the pointer. */
      IF goback2pntr THEN RUN choose-pointer.
      RUN display_current.
      
      /* SEW Update after adding widgets in UIB. */
      RUN call_sew ("SE_ADD":U).
    
    END.
    RUN setstatus ("":U, "":U).
  END. /* IF _next_draw ne ? */
END.  /* PROCEDURE drawobj */

/* double-click is called by persistent triggers on UIB objects.  It calls */
/*              the standard MOUSE-SELECT-DBLCLICK action.                 */
PROCEDURE double-click:
  /* For everything but a OCX control, run the property sheet or section 
     editor (depending on _dblclick_section_ed). IF a control, then use 
     OCX property editor                                                   */
   
  FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  
  IF NOT AVAILABLE _U AND SELF NE _h_cur_widg THEN DO:
    ASSIGN _h_cur_widg = SELF.
    FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  END.
  
  IF NOT AVAILABLE _U THEN return.
  
  IF _U._TYPE = "{&WT-CONTROL}" THEN DO:
    IF _U._LAYOUT-NAME = "Master Layout" THEN DO:
      /* Set and display the Property Editor window. */
      RUN show_control_properties (1).
    END.
    ELSE
      MESSAGE "You may not change OCX properties in an alternate layout." SKIP
              "You may change the size, position and color of the Control Frame."
              VIEW-AS ALERT-BOX INFORMATION.
  END.
  ELSE DO:  /* A normal progress widget */
    IF _dblclick_section_ed THEN RUN choose_codedit.
    ELSE RUN property_sheet (?).
  END. /* DO for a normal progress widget */
END.

/* drawobj-in-box is called at the end of a box-select and it computes     */
/*                the second-corner of a draw before calling draw-obj.     */
/*                It Can be called from a WINDOW or a FRAME.               */
PROCEDURE drawobj-in-box.
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("draw..in-box"). &ENDIF
  DEFINE VAR itemp AS   INTEGER                                  NO-UNDO.
 
  ASSIGN _second_corner_x = LAST-EVENT:X
         _second_corner_y = LAST-EVENT:Y.  

  /* Check for drawing the "wrong" way (from lower-right to upper-left) */
  IF _second_corner_x < _frmx THEN
    ASSIGN itemp            = _frmx
           _frmx            = _second_corner_x
           _second_corner_x = itemp.
  IF _second_corner_y < _frmy THEN
    ASSIGN itemp            = _frmy
           _frmy            = _second_corner_y
           _second_corner_y = itemp.
 
  /* Now draw the widget. */
  RUN drawobj.
END.  /* PROCEDURE drawobj-in-box */

/* drawobj-or-select is called when we want to either select the frame draw  */
/* draw a default widget (depending on what _next_draw is).                  */
/* Note that we do not draw widgets if we are on the border                  */
PROCEDURE drawobj-or-select.
  &IF {&dbgmsg_lvl} > 0
      &THEN run msg_watch("draw..or-select" + _next_draw). &ENDIF
  /* Draw an object -- let progress select the frame but we need to 
    "select" the dialog-box because it is not selectable. */
  FIND _U WHERE _U._HANDLE = SELF.
  IF _next_draw eq ? THEN DO:
    /* Select the dialog-box and deselect all other widgets. */
    IF _U._TYPE eq "DIALOG-BOX" THEN RUN changewidg (SELF, yes).
  END.
  ELSE DO:
    /* Note that we cannot draw frames in dialog-boxes, and the only
       thing we can draw on frame borders is another frame.   */
    IF LAST-EVENT:ON-FRAME-BORDER THEN RETURN.
    ELSE RUN drawobj.
  END.
END. /* drawobj-or-select */

{adeuib/uibdel.i}  /* common delete code moved out */









