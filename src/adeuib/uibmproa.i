&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*---------------------------------------------------------------------------
 File: uibmproa.i

Description:
   The internal procedures of the main routine of the UIB 
   (beginning with a-d).

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
               08/06/01 JEP       IZ 1508 : AppBuilder Memory Leak w/Section Editors
               08/19/01 JEP       jep-icf Minor change to remove static menubar
                                  reference in disable_widgets procedure for ICF.
               09/18/01 JEP       jep-icf Added procedures choose_open and
                                  choose_object_open to support File->Open Object
                                  so objects outside of repository can be opened.
               09/18/01 JEP       jep-icf disable OpenObject_Button in disable_widgets.
               10/01/01 JEP       IZ 1611 <Local> field support for SmartDataFields.
               10/10/01 JEP-ICF   IZ 2101 Run button enabled when editing dynamic objects.
                                  Renamed h_button_bar to _h_button_bar (new shared).
               11/07/01 JEP-ICF   IZ 2342 MRU List doesn't work with dynamics objects.
                                  Fix : Update to procedure choose_mru_file.
 -------------------------------------------------------------------------*/

/* These variables are shared amongst the procedures defined in this .i      */
/*      orig_y      is the original Y coordinate of the down frame box       */
DEF VAR orig_y      AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

{adeuib/uibdel.i}  /* common delete code moved out */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 18.29
         WIDTH              = 64.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddXFTR Include 
PROCEDURE AddXFTR :
/*------------------------------------------------------------------------------
  Purpose:     Add XFTR from Extentions Palette
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER xftrName AS CHAR NO-UNDO.
  
    DEFINE BUFFER x_P FOR _P.
  
    FIND _U WHERE _U._HANDLE EQ _h_win NO-ERROR.
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
      RUN VALUE(_xftr._read) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.
    IF _xftr._realize NE ? THEN
    DO ON STOP UNDO, LEAVE:
      RUN VALUE(_xftr._realize) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add_palette_custom_widget_defs Include 
PROCEDURE Add_palette_custom_widget_defs :
/*------------------------------------------------------------------------------
  Purpose:  Add OCX control to Palette    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_acontp.w.
END PROCEDURE. /* Add_palette_custom_widget_defs */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add_submenu_custom_widget_def Include 
PROCEDURE Add_submenu_custom_widget_def :
/*------------------------------------------------------------------------------
  Purpose:   Add OCX control to Submenu  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_prvcont.w.
END PROCEDURE. /* Add_submenu_custom_widget_def */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseKBase Include 
PROCEDURE BrowseKBase :
/*------------------------------------------------------------------------------
  Purpose:  Browse the PROGRESS KnowledgeBase via Web Browser   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _WebBrowser NE ? AND _WebBrowser NE "" THEN
    RUN WinExec ( _WebBrowser + " http://www.progress.com/services/techsupport":U, 1).
  ELSE
    MESSAGE "Please define your web browser in Preferences" VIEW-AS ALERT-BOX ERROR.

END PROCEDURE. /* BrowseKBase */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE call_coderefs Include 
PROCEDURE call_coderefs :
/*------------------------------------------------------------------------------
  Purpose: Sends events to the Code References Window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

END PROCEDURE. /*  call_coderefs */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE call_run Include 
PROCEDURE call_run :
/*------------------------------------------------------------------------------
  Purpose:  run or debug a file.
  Parameters:  pc_Mode is RUN or DEBUG.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pc_Mode AS CHAR NO-UNDO.

  DEFINE VARIABLE cBroker        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE choice         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOptions       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyBroker   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyCompile  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProxyName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxySaved    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRCodeFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSaveFile      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTitleWin      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCancel        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRemote        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lScrap         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ok2run         AS LOGICAL   NO-UNDO INITIAL YES.
  DEFINE VARIABLE orig_temp_file AS CHARACTER NO-UNDO.

  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    /* Does the user want to be asked about running TTY windows in MS-WIN ?*/
    IF NOT (_cur_win_type OR (OPSYS = "WIN32":U)) AND NOT {&NA-Run-TTY-in-GUI} THEN DO:
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
      ok2run = (choice EQ "_RUN":U).
    END.

    /* Is the file missing any links, or is it OK to RUN? */
    IF ok2run THEN
      RUN adeuib/_advsrun.p (_h_win, "RUN":U, OUTPUT ok2run).

    IF ok2run THEN DO:
      /* SEW call to store current trigger code for specific window. */
      RUN call_sew ("SE_STORE_WIN").

      APPLY "ENTRY":U TO _h_button_bar[5].  /* Kludge to get consistent behavior.  */
      /* Set the cursor in windows. */
      RUN setstatus ("WAIT":U, IF pc_mode EQ "RUN":U THEN "Running file..."
                               ELSE "Debugging file...").
      RUN-BLK:
      DO ON STOP  UNDO RUN-BLK, LEAVE RUN-BLK
         ON ERROR UNDO RUN-BLK, LEAVE RUN-BLK:

        FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
        FIND _U WHERE _U._HANDLE        EQ _h_win.
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
              cFileName = TRIM((IF _P._SAVE-AS-FILE EQ ? THEN
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

          cBroker = IF _P._BROKER-URL EQ "" THEN _BrokerURL ELSE _P._BROKER-URL.

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
          IF (NOT _P.static_object) AND _P.container_object THEN
            RUN launch_object (INPUT RECID(_P)).
          ELSE DO:
            /* Each object needs a unique temporary file so the debugger
               can differentiate between the objects and maintain separate
               breakpoint lists. */
            IF _P._comp_temp_file = ? OR _P._comp_temp_file = "":U THEN
              IF _P._save-as-file = ? OR _P._save-as-file = "" THEN
                RUN adecomm/_uniqfil.p("Untitled", {&STD_EXT_UIB}, OUTPUT _P._comp_temp_file).
              ELSE
                RUN adecomm/_uniqfil.p(_P._save-as-file, {&STD_EXT_UIB}, OUTPUT _P._comp_temp_file).
            /* Store the original comp_temp_file name to reset it after
               calling gen4gl because comp_temp_file is used by many other
               generic functions of the AppBulder and should not include
               filenames for those functions. */
            ASSIGN
              orig_temp_file  = _comp_temp_file
              _comp_temp_file = _P._comp_temp_file.

            RUN adeshar/_gen4gl.p (pc_Mode).

            _comp_temp_file = orig_temp_file.

          END.  /* else static object */
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
END PROCEDURE. /* call_run */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE call_sew Include 
PROCEDURE call_sew :
/*------------------------------------------------------------------------------
  Purpose: called by UIB to trigger events for Section Editor Window.
           If the section editor is not running, then don't bother processing the
           call UNLESS the user wants to start up the section editor.  There are
           two cases where the Section Editor should be started: (1) if the user
           wants to start it, or (2) if an error has been found.     
  Parameters:  p_secommand  
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER p_secommand AS CHARACTER NO-UNDO.

 DEFINE VARIABLE lOEIDEOpen AS LOGICAL    NO-UNDO.
    
 IF p_secommand = "SE_OEOPEN" THEN
     ASSIGN p_secommand = "SE_OPEN" lOEIDEOpen = TRUE.

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
            RUN SecEdWindow IN hSecEd ("_CONTROL", RECID(_U), ?, IF lOEIDEOpen THEN "SE_OEOPEN" ELSE "").
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
                            ("_CUSTOM":U, RECID(_U), "_MAIN-BLOCK":U, IF lOEIDEOpen THEN "SE_OEOPEN" ELSE "").
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

END PROCEDURE. /* call_sew */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE call_sew_getHandle Include 
PROCEDURE call_sew_getHandle :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle to the design window's Section Editor procedure.
          Starts a Section Editor window as needed.    

  Notes:       
------------------------------------------------------------------------------*/
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
    /* If OEIDEIsRunning the _oeidesync.w should be used instead of the 
       standard section editor.
     */
    IF OEIDEIsRunning THEN
        RUN adeuib/_oeidesync.w PERSISTENT SET phSecEd.
    ELSE
        RUN adeuib/_semain.w PERSISTENT SET phSecEd.
    ASSIGN x_P._hSecEd = phSecEd NO-ERROR.
    ASSIGN lAddToMenu  = TRUE.
  END.

  /* Try adding a Section Editor entry to AB's Window menu only for
     SE_OPEN and SE_ERROR, since they are the only ones which can create
     section editor's. -jep */
  IF NOT OEIDEIsRunning AND CAN-DO("SE_OPEN,SE_ERROR":U, psecommand ) THEN
  DO:
    RUN GetAttribute IN phSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
    hWindow = WIDGET-HANDLE(cHandle).
    IF VALID-HANDLE(hWindow) AND hWindow:VISIBLE = FALSE THEN
      ASSIGN lAddToMenu = TRUE.

    IF VALID-HANDLE(_h_WinMenuMgr) AND lAddToMenu THEN /* dma */
      RUN WinMenuAddItem IN _h_WinMenuMgr ( _h_WindowMenu, hWindow:TITLE, _h_uib ).
  END.

  RETURN.

END PROCEDURE. /* call_sew_getHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE call_sew_setHandle Include 
PROCEDURE call_sew_setHandle :
/*------------------------------------------------------------------------------
  Purpose: Set the default hSecEd handle to the handle of the SE parented to
           the design window that has focus.     
 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phSecEd AS HANDLE NO-UNDO.

  ASSIGN hSecEd = phSecEd.
  PUBLISH "AB_call_sew_setHandle":u FROM THIS-PROCEDURE.

  RETURN.
END PROCEDURE. /* call_sew_getHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Center-l-to-r Include 
PROCEDURE Center-l-to-r :
/*------------------------------------------------------------------------------
  Purpose: Align fields down the center    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_align.p ("c-l-to-r", ?).
END PROCEDURE.  /* Center-l-to-r */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Center-t-to-b Include 
PROCEDURE Center-t-to-b :
/*------------------------------------------------------------------------------
  Purpose:   Align across the center  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_align.p (?, "c-t-to-b").
END PROCEDURE.  /* Center-t-to-b */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changewidg Include 
PROCEDURE changewidg :
/*------------------------------------------------------------------------------
  Purpose:     Change the currently selected widget, frame and window.  
               This procedure is like curwidg, except it takes an input 
               parameter: the new widget.     

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_self AS WIDGET NO-UNDO.
  DEFINE INPUT PARAMETER deselect_others AS LOGICAL NO-UNDO.

  /* Has anything changed? */
  IF h_self NE _h_cur_widg THEN DO:
    /* If requested (esp. if the curent widget is a SmartObject or a Menu item)
       then deselect all the other wigets. */
    IF deselect_others THEN DO:
      FOR EACH _U WHERE _U._SELECTEDib:
        ASSIGN _U._SELECTEDib      = FALSE
               _U._HANDLE:SELECTED = FALSE.
      END.
    END.
    IF h_self NE ? THEN RUN curframe (h_self).
    _h_cur_widg = h_self.
  END.
  /* Occasionally, this routine is called by a routine that has changed
     _h_cur_widg itself.  Really, the caller wants to change the
     displayed widget.  So handle this to. */
  IF _h_cur_widg NE h_display_widg THEN RUN display_current.
END PROCEDURE. /* changewidg */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Change_Customization_Parameters Include 
PROCEDURE Change_Customization_Parameters :
/*------------------------------------------------------------------------------
  Purpose: Change the session parameters for controling Dynamics customizations    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationTypes      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomPriorities        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomizationReferences AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCodelist                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPriority                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReferenceCode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResCode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCodes             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTypeAPI                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTypeList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCustomizationManager    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPriority                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTypeLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lok                      AS LOGICAL    NO-UNDO.

  hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U).

  IF gcResultCodes = ? THEN DO:  /* Haven't run this before, so get system information */
    cCustomPriorities = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                         INPUT "CustomizationTypePriority":U).
    /* If no customizations have been specified, then cCodeList (List of ResultCodes
       in the right selection list of the rycusmodw.w window) is blank  */
    IF cCustomPriorities = ? OR cCustomPriorities = "":U THEN cCodeList = "":U.
    ELSE DO:
      RUN rycusfapip IN hCustomizationManager ( INPUT cCustomPriorities, OUTPUT cTypeAPI ) NO-ERROR.

      /* Build the list of references */
      IF VALID-HANDLE(hCustomizationManager) THEN DO:
        DO iTypeLoop = 1 TO NUM-ENTRIES(cTypeApi):
          ASSIGN cReferenceCode = "":U
                 cReferenceCode = DYNAMIC-FUNCTION(ENTRY(iTypeLoop, cTypeApi) IN hCustomizationManager)
                 NO-ERROR.

          /* Ensure that there's at least something */
          IF cReferenceCode EQ "":U OR cReferenceCode EQ ? THEN
              ASSIGN cReferenceCode = "DEFAULT-RESULT-CODE":U.

          ASSIGN cCustomizationReferences = cCustomizationReferences +
                           (IF NUM-ENTRIES(cCustomizationReferences) EQ 0 THEN "":U ELSE ",":U)
                           + cReferenceCode.
        END.    /* loop through gcCustomisationTypesPrioritised */
      END.  /* If valid customization manager handle */

      /* Determine the result codes from the references */
      RUN rycusrr2rp IN hCustomizationManager
                              ( INPUT        cCustomPriorities,
                                INPUT        cTypeApi,
                                INPUT-OUTPUT cCustomizationReferences,
                                OUTPUT       cResultCodes              ) NO-ERROR.

      cCodeList = "":U.
      DO iTypeLoop = 1 TO NUM-ENTRIES(cCustomPriorities):
        cResCode = ENTRY(iTypeLoop, cResultCodes).
        cCodeList = cCodeList + "|" + ENTRY(iTypeLoop, cCustomPriorities) + "|":U +
                    ENTRY(iTypeLoop, cCustomPriorities) + CHR(4) +
                    IF cResCode EQ "DEFAULT-RESULT-CODE":U THEN "Default":U ELSE cResCode.
      END.
      cCodeList = LEFT-TRIM(cCodeList, "|":U).
    END. /* Else some customizations have been specified */
  END.  /* IF haven't run before */
  ELSE cCodeList = gcResultCodes.

  /* Make a complete list of customization types for the left selection list */
  RUN FetchCustomizationTypes IN hCustomizationManager
      (INPUT  YES,
       OUTPUT cTypeList).

  IF cTypeList NE "" THEN DO:
    DO iTypeLoop = 1 TO NUM-ENTRIES(cTypeList):
      cCustomizationTypes = cCustomizationTypes + "|":U +
                             ENTRY(iTypeLoop,cTypeList) + "|":U +
                             ENTRY(iTypeLoop,cTypeList) + CHR(4).
    END.
    cCustomizationTypes = LEFT-TRIM(cCustomizationTypes,"|":U).
  END.
  ELSE cCustomizationTypes = "":U.

  /* Call the customization Priority Editor */
  RUN ry/prc/rycusmodw.w (
    INPUT "Customization Priority Editor|Available|Selected", /* Window Title */
    INPUT "|":U, /* Delimiter  */
    INPUT YES,   /* Use images */
    INPUT YES,   /* Allow Sort */
    INPUT YES,
    INPUT YES,   /* List Item Pairs (Not List Items) */
    INPUT cCustomizationTypes,
    INPUT-OUTPUT cCodeList,
    OUTPUT lok).

  IF lok THEN DO: /* The user did not cancel, save the changes */
    gcResultCodes = "":U.  /* Setup for next time */

    /* If no customisation has been set up, return the DEFAULT code. */
    IF cCodeList EQ "":U OR cCodeList EQ ? THEN
        ASSIGN cResultCodes = "{&DEFAULT-RESULT-CODE}":U
               hCustomization:HIDDEN = YES.
    ELSE DO:
      cResultCodes = "":U.
      DO iTypeLoop = 2 TO NUM-ENTRIES(cCodeList,"|":U) BY 2:
        cResultCodes = cResultCodes + ",":U +
                     ENTRY(2, ENTRY(iTypeLoop, cCodeList, "|":U), CHR(4)).
        gcResultCodes = gcResultCodes + "|":U +
                     ENTRY(1, ENTRY(iTypeLoop, cCodeList, "|":U), CHR(4)) +
                     "|":U + ENTRY(iTypeLoop, cCodeList, "|":U).
      END.
      ASSIGN cResultCodes  = LEFT-TRIM(cResultCodes,",":U)
             gcResultCodes = LEFT-TRIM(gcResultCodes,"|":U)
             hCustomization:HIDDEN    = NO
             hCustomization:SENSITIVE = YES.
    END.

    RUN setSessionResultCodes IN hCustomizationManager
            (INPUT cResultCodes,
             INPUT YES). /* If the cache was not accurate, we want to reset
                                            the prop on the Appserver */
  END.

END PROCEDURE.  /* Change_Customization_Parameters */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_grid_display Include 
PROCEDURE change_grid_display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  _cur_grid_visible = SELF:CHECKED.
  FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?:
    ASSIGN  _U._HANDLE:GRID-VISIBLE = _cur_grid_visible.
  END.
END. /* change_grid_display */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_grid_snap Include 
PROCEDURE change_grid_snap :
/*------------------------------------------------------------------------------
  Purpose: Change grid snapping, but only on Graphical frames     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  _cur_grid_snap = SELF:CHECKED.
  FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?,
       EACH _L WHERE RECID(_L) = _U._lo-recid:
    IF _L._WIN-TYPE THEN _U._HANDLE:GRID-SNAP = _cur_grid_snap.
  END.
END PROCEDURE. /* change_grid_snap */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_grid_units Include 
PROCEDURE change_grid_units :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_label Include 
PROCEDURE change_label :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h_ttl_widg  AS WIDGET                              NO-UNDO.
  DEFINE VAR oldTitle    AS CHAR                                NO-UNDO.
  DEFINE VAR text-sa     AS CHAR                                NO-UNDO.
  DEFINE VAR wc          AS INTEGER                             NO-UNDO.

  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  error_on_leave = NO.
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
        ELSE IF _U._TYPE EQ "BROWSE":U THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
          /* Change the title - note we need to simulate browse contents */
          FIND _C WHERE RECID(_C) EQ _U._x-recid.
          IF _C._TITLE THEN DO:
            IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyObject IN _U._PROC-HANDLE.
            ELSE IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
            RUN adeuib/_undbrow.p (RECID(_U)).
          END.
        END.
        ELSE IF _U._TYPE EQ "FRAME":U THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
           FIND _C WHERE RECID(_C) EQ _U._x-recid.
           IF _C._TITLE AND NOT _L._NO-BOX THEN DO:
             RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, NO, OUTPUT text-sa).
             IF text-sa NE _U._HANDLE:TITLE THEN _U._HANDLE:TITLE = text-sa.
           END.
        END.
        ELSE IF CAN-DO ("MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
          RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, NO, OUTPUT text-sa).
          _U._HANDLE:LABEL = text-sa.
        END.
        ELSE IF CAN-SET(_U._HANDLE, "LABEL") THEN DO:
          IF cur_widg_text EQ "?" OR cur_widg_text EQ ?
          THEN DO:
            /* Label is "unknown", so use "D"efault -- note: for DB fields, we
               need to refetch the Default label. We only bother with this change
               if the old value was not "D"efault. */
            IF _U._LABEL-SOURCE NE "D" THEN DO:
              IF _U._DBNAME NE ? THEN RUN adeuib/_fldlbl.p
                            (_U._DBNAME, _U._TABLE, _U._NAME, _C._SIDE-LABELS,
                             OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
              _U._LABEL-SOURCE = "D".
            END.
          END.
          ELSE ASSIGN _U._LABEL = cur_widg_text
                      _U._LABEL-SOURCE = "E".
         IF NOT CAN-DO("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U, _U._TYPE)
         THEN RUN adeuib/_sim_lbl.p (_U._HANDLE). /* i.e. buttons and toggles */
         ELSE DO:
            FIND f_U WHERE RECID(f_U) = _U._PARENT-RECID.
            ASSIGN _h_frame = f_U._HANDLE.
            FIND _C WHERE RECID(_C) EQ f_U._x-recid.
            FIND f_L WHERE RECID(f_L) EQ f_U._lo-recid.
            FIND _F WHERE RECID(_F) EQ _U._x-recid.
            FIND _L WHERE RECID(_L) EQ _U._lo-recid.
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
                  h_ttl_widg = IF _U._TYPE EQ "DIALOG-BOX"
                               THEN _U._HANDLE:PARENT ELSE _U._HANDLE.
           FIND _P WHERE _P._u-recid EQ RECID(_U).
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
END. /*  change_label */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change_name Include 
PROCEDURE change_name :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.
  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  error_on_leave = NO.
  /* Has it been modified ? */
  IF cur_widg_name <> SELF:SCREEN-VALUE THEN DO:
    FIND _U WHERE _U._HANDLE = h_display_widg NO-ERROR.
    IF AVAILABLE _U AND (_U._TYPE NE "TEXT") THEN DO:
      IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) THEN
        FIND _L WHERE RECID(_L) EQ _U._lo-recid.

      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF NOT valid_name THEN DO:
        ASSIGN error_on_leave    = YES
               SELF:SCREEN-VALUE = cur_widg_name.
        RETURN ERROR.
      END.
      ELSE DO WITH FRAME action_icons:
        ASSIGN cur_widg_name
               display_name     = cur_widg_name
               _U._NAME         = cur_widg_name
               error_on_leave   = NO.

        /* If this is a OCX control then CORE needs to know the change */

        IF _U._TYPE = "{&WT-CONTROL}" THEN _U._HANDLE:NAME = _U._NAME.

        /* set the file-saved state to false */
        RUN adeuib/_winsave.p(_h_win, FALSE).

        /* For some fields, if there are defaults then update the label */
        IF (_U._LABEL-SOURCE = "D") AND (_U._TABLE = ?) AND
           CAN-DO ("BUTTON,FILL-IN,TOGGLE-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER", _U._TYPE) THEN DO:
          IF CAN-DO("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U, _U._TYPE) THEN DO:
            FIND f_U WHERE f_U._HANDLE EQ _h_frame.
            FIND f_L WHERE RECID(f_L) EQ f_U._lo-recid.
            FIND _C WHERE RECID(_C) EQ f_U._x-recid.
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
END. /* change_name */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose-pointer Include 
PROCEDURE choose-pointer :
/*------------------------------------------------------------------------------
  Purpose:  change the _next_draw tool back to the pointer tool   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE toolframe AS WIDGET-HANDLE.

  /* Unhilite the current tool  - if it isn't the pointer  */
  IF hDrawTool NE ? AND hDrawTool:PRIVATE-DATA NE "POINTER":U
  THEN DO:
    ASSIGN hDrawTool:HIDDEN  = NO
           toolframe         = hDrawTool:FRAME
           toolframe:bgcolor = ?.
  END.
  /* Hide the old lock -- pointer mode is NEVER locked */
  IF h_lock NE ? AND h_lock:HIDDEN NE YES
  THEN h_lock:HIDDEN = YES.
  /* Set the current selection to the pointer.                */
  ASSIGN hDrawTool         = h_wp_Pointer
         hDrawTool:HIDDEN  = YES
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
  RUN adeuib/_setpntr.p (_next_draw, INPUT-OUTPUT _object_draw).
  /* Show the user we are using the Pointer Tool */
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Tool},  h_wp_Pointer:HELP).
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, "":U).
END PROCEDURE. /* choose-pointer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_assign_widgetID Include 
PROCEDURE choose_assign_widgetID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    MESSAGE "Widget IDs will be written to all frames and widgets of this container. " +
            "If widget IDs have already been assigned to frames and widgets they will be overwritten. " +
            "Do you wish to continue?" 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinue.
    IF lContinue THEN
    do:
      RUN adeuib/_assignwidgid.p (INPUT _h_win).
      RUN adeuib/_winsave.p(_h_win, FALSE).
    END.
  END.
END PROCEDURE.  /* choose_assign_widgetID */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_attributes Include 
PROCEDURE choose_attributes :
/*------------------------------------------------------------------------------
  Purpose: called by UIB to trigger events in the Attributes Editor
           floating window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* If it doesn't exist, them create it.  Otherwise, move it to the top.
     NOTE that we need to make sure the handle points to the same item
     (because PROGRESS reuses procedure handles). */
  IF VALID-HANDLE(hAttrEd) AND hAttrED:FILE-NAME EQ "{&AttrEd}"
  THEN RUN move-to-top IN hAttrEd NO-ERROR.
  ELSE RUN {&AttrEd} PERSISTENT SET hAttrEd .

  /* Show the current values. */
  RUN show-attributes IN hAttrEd NO-ERROR.

END PROCEDURE. /* choose_attributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_check_syntax Include 
PROCEDURE choose_check_syntax :
/*------------------------------------------------------------------------------
  Purpose: Check the syntax of the current window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    FIND _U WHERE _U._HANDLE        EQ _h_win.
    ASSIGN
      web-tmp-file = ""
      _save_mode   = "".

    /* Check syntax on remote WebSpeed agent if Broker URL is known for this
       file or the file is new, untitled and Development Mode is remote. */
    IF _P._BROKER-URL NE "" OR (_P._SAVE-AS-FILE EQ ? AND _remote_file)
      THEN DO:
      RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cTempFile).

      /* DO NOT change or reuse web-tmp-file until AFTER adeweb/_webcom.w
         runs in DELETE mode further down in this procedure. If the object
         to be checked is a SmartDataObject, then this variable is used to
         hold the field definition include filename. */
      ASSIGN
        web-tmp-file = cTempFile
        _save_mode   = (IF _P._SAVE-AS-FILE EQ ? THEN "T":U ELSE "F":U) +
                        ",":U +
                       (IF _P._SAVE-AS-FILE EQ ? AND _remote_file
                        THEN "T":U ELSE "F":U).

      IF _P._file-version BEGINS "WDT_v2":U THEN
        RUN adeweb/_genweb.p (RECID(_P), "SAVE":U, ?, _P._SAVE-AS-FILE,
                              OUTPUT cScrap).
      ELSE
        RUN adeshar/_gen4gl.p ("SAVE:CHECK":U).

      ASSIGN
        cBroker   = (IF _P._BROKER-URL NE ""
                     THEN _P._BROKER-URL ELSE _BrokerURL)
        hTitleWin = (IF (_U._TYPE = "DIALOG-BOX") THEN
                      _U._HANDLE:PARENT ELSE _U._HANDLE)
        cFileName = TRIM((IF _P._SAVE-AS-FILE EQ ? THEN
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

        FIND LAST _TRG WHERE _TRG._pRECID  EQ RECID(_P)
                         AND _TRG._tOFFSET LT iErrOffset
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
END PROCEDURE. /* choose_check_syntax */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_close Include 
PROCEDURE choose_close :
/*------------------------------------------------------------------------------
  Purpose: Close the current window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_win = ? THEN  
    RUN report-no-win.
  ELSE
    /* Close the window */
    RUN wind-close (_h_win).
END PROCEDURE. /* choose_close */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_close_all Include 
PROCEDURE choose_close_all :
/*------------------------------------------------------------------------------
  Purpose:  Close one or more windows    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code regardless of what the
       current window is in UIB.  */
    RUN call_sew ("SE_STORE":U).

    RUN adeuib/_closeup.p.
    RUN del_cur_widg_check.   /* Have we deleted the current widget */

    /* Update the Window menu active window items. */
    RUN WinMenuRebuild IN _h_uib.
  END.
END PROCEDURE. /* choose_close_all */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_codedit Include 
PROCEDURE choose_codedit :
/*------------------------------------------------------------------------------
  Purpose: called by mi_code_edit, button-bar and Accelerators.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT mi_code_edit:SENSITIVE THEN RETURN NO-APPLY.
  RUN adecomm/_setcurs.p ("WAIT":U) NO-ERROR.
  RUN call_sew ("SE_OPEN":U).
  RUN adecomm/_setcurs.p ("":U) NO-ERROR.

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_codedit */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_code_preview Include 
PROCEDURE choose_code_preview :
/*------------------------------------------------------------------------------
  Purpose:  called by menu and button-bar   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScrap AS CHARACTER NO-UNDO.

  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    IF NOT MENU-ITEM mi_preview:SENSITIVE IN MENU m_compile THEN RETURN NO-APPLY.

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
END. /* choose_code_preview */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_control_props Include 
PROCEDURE choose_control_props :
/*------------------------------------------------------------------------------
  Purpose:  Bring up the OCX property editor    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE multControls AS  INTEGER NO-UNDO.
  DEFINE VARIABLE s            AS  INTEGER NO-UNDO.
  DEFINE BUFFER   f_u          FOR _U.

  /* Set and display the Property Editor window. */
  RUN show_control_properties (1).

END PROCEDURE. /* choose_control_props */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_copy Include 
PROCEDURE choose_copy :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Copy; Copy Accelerators.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE VAR dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win EQ ? THEN RUN report-no-win.
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
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
      DO:
      IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,BROWSE-COLUMN":U,SELF:TYPE) THEN
            SELF:Edit-Copy().
      END.
      ELSE DO:
        IF ivCount = 0 THEN
           MESSAGE "There is nothing selected to copy." VIEW-AS ALERT-BOX
              INFORMATION BUTTONS OK.
        ELSE
          MESSAGE "There are selected objects with different parents." SKIP
              "Copy only works on objects with the same parent."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
    END.  /* Invalid Copy */
  END. /* IF _h_win...ELSE DO: */
END PROCEDURE. /* choose_copy  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_cut Include 
PROCEDURE choose_cut :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Cut; Cut Accelerators    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0.
  DEFINE VARIABLE dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win EQ ? THEN RUN report-no-win.
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
        IF _h_frame NE ? THEN RUN adeuib/_vrfyqry.p (_h_frame, "REMOVE-SELECTED-FIELDS":U, "").
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
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
        APPLY LASTKEY TO SELF.
      ELSE DO:
        IF ivCount = 0
           THEN MESSAGE "There is nothing selected to cut."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ELSE MESSAGE "There are selected objects with different parents." SKIP
                   "Cut only works on objects with the same parent."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
    END. /* Invalid Cut */
  END.
END PROCEDURE.  /* choose_cut */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_debug Include 
PROCEDURE choose_debug :
/*------------------------------------------------------------------------------
  Purpose: run the current window with the debugger      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN call_run ("DEBUG").
END PROCEDURE. /* choose_debug */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_duplicate Include 
PROCEDURE choose_duplicate :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Duplicate.      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
      FIND _U WHERE _U._HANDLE EQ _h_frame.
      IF _U._TYPE EQ "FRAME":U AND _U._SELECTEDib THEN DO:
        par-rec = _U._PARENT-RECID.
        FIND _U WHERE RECID(_U) = par-rec.
        IF _U._TYPE EQ "WINDOW":U THEN _h_frame = ?.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_editor Include 
PROCEDURE choose_editor :
/*------------------------------------------------------------------------------
  Purpose: called from the mnu_editor dynamic menu-item in the mnu-tools menu
           This summons the Procedure Editor                         
Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN _RunTool("_edit.p":U).
  SESSION:DATE-FORMAT = _orig_dte_fmt.
END PROCEDURE. /* Choose editor */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_erase Include 
PROCEDURE choose_erase :
/*------------------------------------------------------------------------------
  Purpose:  Erase marked widgets 
            called by Edit/Delete; Delete Anywhere     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cnt           AS INTEGER INITIAL 0 NO-UNDO.

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

  IF cnt = 0 THEN DO:
    IF _DynamicsIsRunning THEN
    DO:
        IF SELF:TYPE = "EDITOR":U THEN
        DO:
           IF SELF:TEXT-SELECTED THEN
             SELF:REPLACE-SELECTION-TEXT("":U).
           ELSE
              SELF:DELETE-CHAR().
        END.
        ELSE DO:
          APPLY LASTKEY TO SELF.
          RETURN NO-APPLY.
       END.
    END.
    ELSE
      MESSAGE "There is nothing selected for deletion."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
  ELSE DO: /* objects to delete */
    /* Bailout if user is attempting to delete the browser off a DynBrows */
    IF _DynamicsIsRunning AND AVAILABLE _P THEN DO:
      IF LOOKUP(_P.OBJECT_type_code,
                  DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynBrow":U)) <> 0 THEN
        RETURN NO-APPLY.
    END.

    /* SEW store current trigger code before deleting. */
    RUN call_sew ("SE_STORE_SELECTED":U).

    RUN setstatus ("WAIT":U, ?).
    /* For each frame that is not selected itself, run through the selected
       widgets that it contains and remove them from the query */
    FOR EACH _U WHERE NOT _U._SELECTEDib
                  AND _U._WINDOW-HANDLE EQ _h_win
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
               _U._HANDLE:HIDDEN      = IF _U._TYPE NE "SmartObject":U THEN TRUE
                                        ELSE FALSE    /* Hide this later */
               _L._REMOVE-FROM-LAYOUT = TRUE.

        IF _U._TYPE EQ "SmartObject":U THEN DO:
          FIND _S WHERE RECID(_S) EQ _U._x-recid.
          RUN HideObject IN _S._HANDLE.
        END.

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
END. /* choose_erase */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_export_file Include 
PROCEDURE choose_export_file :
/*------------------------------------------------------------------------------
  Purpose: Export selected objects to an export file.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
END. /* choose_export_file */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_new Include 
PROCEDURE choose_file_new :
/*------------------------------------------------------------------------------
  Purpose:  creates a new window or dialog-box and makes sure that the new item 
            is the current object    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR choice    AS CHAR NO-UNDO.
  DEFINE VAR cChoice   AS CHAR NO-UNDO.
  DEFINE VAR cFileExt  AS CHAR NO-UNDO.
  DEFINE VAR lHtmlFile AS LOG  NO-UNDO.
  DEFINE VAR h_curwin  AS HANDLE NO-UNDO.


  /* Save off the current object design window handle. Use it to determine
     if a new object was actually created (handle will change). */
  ASSIGN h_curwin = _h_win.

  RUN adeuib/_newobj.w ( OUTPUT choice ).
  /* DESELECT everything that is selected if a choice was made. */
  IF choice NE "" AND choice NE ? THEN DO:
    RUN adecomm/_osfext.p ( choice, OUTPUT cFileExt ).
    IF (cFileExt EQ ".htm":U OR cFileExt EQ ".html":U) AND
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

    /* je-icf: Show the property sheet of new dynamic repository object. */
    IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
      IF AVAILABLE(_P) AND (NOT _P.static_object) AND
               LOOKUP("DynView":U,_P.parent_classes)= 0
           AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
           AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
           AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0   THEN
        RUN choose_prop_sheet IN _h_UIB.

    END.

  END. /* If a valid choice */
END PROCEDURE.  /* choose_file_new */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_open Include 
PROCEDURE choose_file_open :
/*------------------------------------------------------------------------------
  Purpose:  called by File/Open or Ctrl-O    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN choose_open (INPUT "FILE":u).

END PROCEDURE.  /* choose_file_open */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_print Include 
PROCEDURE choose_file_print :
/*------------------------------------------------------------------------------
  Purpose:   called by File/Print   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_save Include 
PROCEDURE choose_file_save :
/*------------------------------------------------------------------------------
  Purpose: called by File/Save or Ctrl-S    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cancel       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE saveStatic   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE pError       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pAssocError  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRegisterObj AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDefCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iReciD       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE _save_file   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE h_title_win  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE OldTitle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSaveFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecid       AS RECID      NO-UNDO.
  DEFINE VARIABLE cAbort       AS CHARACTER  NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    ASSIGN saveStatic = YES.
    FIND _U WHERE _U._HANDLE = _h_win.

    /* If we are running Dynamics, check to see if this is a dynamic
       object and save it as such if it is                         */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN 
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
      IF (NOT _P.static_object) AND
         LOOKUP(_P._TYPE,"SmartDataBrowser,SmartDataObject,SmartDataViewer,SmartViewer":U) > 0 THEN 
      DO:
        /* Wizard Confirmation Dialog */
        IF CAN-DO(_P.design_action,"NEW":u) THEN 
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
            NO-ERROR.
            ASSIGN cSaveFile       = _P._SAVE-AS-FILE
                   _P._SAVE-AS-FILE = _save_File
                   rRecid           = RECID(_P).

            /* The call to _saveaswizd.w requires a valid _h_cur_widg, but this
               won't be the case if multiple objects are choosen. In this case
               set it to _h_win.  */
            IF NOT VALID-HANDLE(_h_cur_widg) THEN 
              _h_cur_widg = _h_win.
            run adeuib/_saveaswizd.w (input no, output lRegisterObj, output lOK).            
            IF rRecid <> RECID(_P) THEN
               FIND _P WHERE  RECID(_P) = rRecid .
            IF NOT lOK THEN DO:
              _P._SAVE-AS-FILE = cSaveFile.
              RETURN.
            END.
        END.

         /* The design action might have been "NEW", but now object is save. So the
            action is changed to "OPEN". */
        ASSIGN lNew              = LOOKUP("NEW":U,_P.design_action) > 0
               _P.design_action  = REPLACE (_P.design_action, "NEW":U, "OPEN":U)
               saveStatic        = NO NO-ERROR. /* This is to clear the ERROR handle */

        RUN setstatus ("WAIT":U,"Saving object...":U).

        /* Here's where we save the dynamic object */
        RUN ry/prc/rygendynp.p (INPUT RECID(_P),
                                OUTPUT pError,              /* Error saving object */
                                OUTPUT pAssocError).        /* Error saving data logic procedure */

        RUN setstatus ("":U, "":U).

        IF (pError <> "") THEN
        DO:
            RUN showMessages IN gshSessionManager (INPUT pError,
                                                   INPUT "ERR":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "Object Save Error",
                                                   INPUT YES,
                                                   INPUT ?,
                                                 OUTPUT cAbort).

           IF lNew THEN
              ASSIGN _P._SAVE-AS-FILE = ?
                     _P.design_action = REPLACE (_P.design_action, "OPEN":U,"NEW":U ).
           RETURN.
        END. /* If there was an error */

        ASSIGN
          _P._FILE-SAVED         = TRUE
          h_title_win            = _P._WINDOW-HANDLE:WINDOW
          OldTitle               = h_title_win:TITLE.
          .

        IF NOT AVAILABLE _U THEN
          FIND _U WHERE _U._HANDLE = h_title_win.
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
          RUN adeshar/_mrulist.p (ENTRY(NUM-ENTRIES(_P._SAVE-AS-FILE,"/":U),_P._SAVE-AS-FILE,"/":U), IF _remote_file THEN _BrokerURL ELSE "").

        /* IZ 776 Redisplay current filename in AB Main window. */
        RUN display_current IN _h_uib.

        /* Dynamics: IZ 6618. When saving an object, force tools to refresh its instances of the saved smartobject */
        IF _DynamicsIsRunning                 AND
           VALID-HANDLE(gshRepositoryManager) AND
           _P.smartObject_obj <> ?            AND
           _P.smartObject_obj <> 0            THEN
          PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT _P.smartObject_obj, INPUT _P.Object_FileName).

        IF _P._TYPE = "SmartDataObject":U AND pAssocError NE "":U THEN
        DO:
          pAssocError = "The SDO's data logic procedure failed to compile with the following errors: ":U
                        + CHR(10) + CHR(10) + pAssocError + CHR(10)
                        + "Do you wish to open the data logic procedure to correct its compile errors?":U.

          RUN showMessages IN gshSessionManager (INPUT pAssocError,
                                                 INPUT "ERR":U,
                                                 INPUT "YES,NO,CANCEL":U,
                                                 INPUT "YES":U,
                                                 INPUT "CANCEL":U,
                                                 INPUT "Data Logic Procedure Compile Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cAbort).
          IF cAbort = "YES":U AND VALID-HANDLE(_h_menubar_proc) THEN
            RUN runOpenProcedure IN _h_menubar_proc.
        END.  /* if SDO and data logic procedure did not compile */

      END. /* if it is a dynamic SDV object */
      ELSE DO:
         IF VALID-HANDLE(_h_menubar_proc) AND _P.smartObject_Obj > 0 THEN
            RUN PropUpdateMaster IN _h_menubar_proc
                      (_P._WINDOW-HANDLE, _P.smartObject_Obj).
      END.
    END. /* If we are running dynamics */

    IF saveStatic THEN DO:
      /* SEW call to store current trigger code for specific window. */
      RUN call_sew ("SE_STORE_WIN":U).

      RUN save_window (NO, OUTPUT cancel).
    END. /* If saving a static object */
  END. /* Else we have a valid window handle */
END PROCEDURE. /* choose_file_save */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_saveAsStatic_Undo Include 
PROCEDURE choose_file_saveAsStatic_Undo :
/*------------------------------------------------------------------------------
  Purpose:     Returns _U records to their previous state
  Parameters:  plIsSBO      Yes - Data Object is an SBO
                            NO  - Data Object is an SDO
               phL          Handle of temp-table buffer built against _L table
               pcResultCode Custom result code
  Notes:       Called from choose_file_save_as_static
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plIsSBO      AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER phL          AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode AS CHARACTER NO-UNDO.

DEFINE VARIABLE hLBuf  AS HANDLE NO-UNDO.

/* Re-aasign the _U._Table back to what it was */
IF NOT plIsSBO THEN
DO:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
             AND _U._BUFFER        = "RowObject":U:
     IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA,CHR(4)) = 2 THEN
       ASSIGN _U._TABLE = ENTRY(1,_U._HANDLE:PRIVATE-DATA,CHR(4))
              _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA,CHR(4))
              NO-ERROR.
  END.
END.
ELSE DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        > "":

     IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA,CHR(4)) = 2 THEN
     ASSIGN _U._BUFFER = ENTRY(1,_U._HANDLE:PRIVATE-DATA,CHR(4))
            _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA,CHR(4))
            NO-ERROR.
   END. /* End For each _U */
END.

/* Restore the custom _L records from the temp-table buffer */
IF phL NE ? THEN
DO:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND _U._STATUS = "NORMAL":U :
    
     phL:FIND-FIRST("where Undo_L._u-recid = " + STRING(RECID(_U))). 
     IF phL:AVAILABLE THEN
     DO:
        FIND _L WHERE _L._lo-name = "Master Layout":U AND _L._u-recid = RECID(_U) NO-ERROR.
        IF AVAIL _L THEN
        DO:
           hLBuf = BUFFER _L:HANDLE.  
           hLBuf:BUFFER-CREATE().
           hLBuf:BUFFER-COPY(phL).
           ASSIGN _U._Layout-name = pcResultCode
                  _U._lo-recid    = hLBuf:RECID.
        END.
     END.
     
  END.
END.

END PROCEDURE. /* choose_file_saveAsStatic_Undo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_save_all Include 
PROCEDURE choose_file_save_all :
/*------------------------------------------------------------------------------
  Purpose: called by File/Save All     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER x_P FOR _P.

  FOR EACH x_U WHERE CAN-DO("WINDOW,DIALOG-BOX",x_U._TYPE)
                                         AND x_U._STATUS NE "DELETED":

    IF x_U._TYPE = "DIALOG-BOX":U THEN RUN changewidg (x_U._HANDLE, YES).
    ELSE APPLY "ENTRY":U TO x_U._HANDLE.

    FIND x_P WHERE x_P._u-recid EQ RECID(x_U).
    IF x_P._SAVE-AS-FILE = ? THEN
      MESSAGE IF x_U._SUBTYPE EQ "Design-Window" THEN x_U._LABEL ELSE x_U._NAME SKIP
        "This window has not been previously saved."
        VIEW-AS ALERT-BOX INFORMATION.

    RUN choose_file_save.

  END.  /* for each x_u */
END PROCEDURE.  /* choose_file_save_all */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_save_as Include 
PROCEDURE choose_file_save_as :
/*------------------------------------------------------------------------------
  Purpose:  Save current window with a new name   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cancel        AS LOGICAL    NO-UNDO.

  IF _h_win = ? THEN  RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN save_window (YES, OUTPUT cancel).
  END.

END PROCEDURE. /*choose_file_save_as */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_save_as_dynamic Include 
PROCEDURE choose_file_save_as_dynamic :
/*------------------------------------------------------------------------------
  Purpose: Save current window with a new name     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pressed-OK    AS LOGICAL    NO-UNDO.

  IF _h_win = ? THEN  RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).

    /* Choose the Product module and object Name */
    RUN adeuib/_chsPM.p
        (INPUT _h_menu_win,             /* Parent Window    */
         INPUT RECID(_P),               /* _P recid         */
         INPUT _P.product_module_code,  /* Product Module   */
         INPUT _P._SAVE-AS-FILE,        /* Object to add    */
         INPUT _P._TYPE,                /* File type        */
         OUTPUT pressed-ok).
  END.

END PROCEDURE. /*  choose_file_save_as_dynamic */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_file_save_as_static Include 
PROCEDURE choose_file_save_as_static :
/*------------------------------------------------------------------------------
  Purpose:     Save dynamic object as static
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cOldSaveAsFile AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldObjectType AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldTitle      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE h_title_win    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTemplateWin   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rTemplateRecid AS RECID      NO-UNDO.
 DEFINE VARIABLE r_URecid       AS RECID      NO-UNDO.
 DEFINE VARIABLE r_PRecid       AS RECID      NO-UNDO.
 DEFINE VARIABLE lMRUFileList   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hOldWin        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hOldWidg       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDesignManager AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cEventCode     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEventTarget   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE c_UName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lisSBO         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE dOldObjectObj  AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cResultCode    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCustom        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE tthL           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE bhL            AS HANDLE     NO-UNDO.

 DEFINE BUFFER template_P    FOR _P.
 DEFINE BUFFER template_TRG  FOR _TRG.
 DEFINE BUFFER template_XFTR FOR _XFTR.
 DEFINE BUFFER Event_U       FOR _U.
 DEFINE BUFFER b_L           FOR _L.

 IF _h_win = ? THEN 
 DO: 
    RUN report-no-win IN THIS-PROCEDURE.
    RETURN.
 END.
 
 FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
 FIND _U WHERE _U._HANDLE        = _h_win.

 /* Determine the equivalent static object type   */

 IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynView":U) THEN
    cObjectType = "StaticSDV":U.
 ELSE IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynSDO":U) THEN
    cObjectType = "SDO":U.
 ELSE IF DYNAMIC-FUNCTION('classIsA':u in gshRepositoryManager, _P.Object_Type_Code, 'DynDataView':u) THEN
     cObjectType = 'StaticDataView':u.
 ELSE DO:
   MESSAGE "Only Dynamic Viewers, Dynamic SDOs and Dynamic DataViews are supported for saving as static." view-as alert-box.
   RETURN.
 END.

 ASSIGN r_PRecid               = RECID(_P)
        cOldSaveAsFile         = _P._SAVE-AS-FILE
        _P._SAVE-AS-FILE       = ?
        _P.static_object       = YES
        cOldObjectType         = _P.object_type_code
        _P.object_type_code    = cObjectType
        _P.smartObject_obj     = 0
        r_URecid               = RECID(_U)
        hOldWin                = _h_win
        hOldWidg               = _h_cur_widg
        dOldObjectObj          = _P.smartObject_obj        
        cResultCode            = IF _U._LAYOUT-NAME = "Master Layout":U THEN "" ELSE _U._LAYOUT-NAME
        NO-ERROR.

/* Get object's Data Object from repository and check whether it is derived from a dynamic SBO */
IF _P._data-Object > "" THEN 
DO:
  hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  RUN retrieveDesignObject IN hDesignManager 
     (INPUT _P._data-Object ,
      INPUT  "",  /* Get default  result Codes */
      OUTPUT TABLE ttObject,
      OUTPUT TABLE ttPage,
      OUTPUT TABLE ttLink,
      OUTPUT TABLE ttUiEvent,
      OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
  FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = _P._data-Object NO-ERROR.
  IF AVAIL ttObject THEN
    lIsSBO = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, ttObject.tClassName,"SBO":U). 
END.


 /* For Objects whose data-object is a SDO, change the _U._Table field from the table name to RowObject */
 /* Save the current _TABLE record in the private data in case the user cancels the save */.
 IF NOT lisSBO THEN
 DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        = "RowObject":U:
      IF VALID-HANDLE(_U._HANDLE) THEN
      DO:
        ASSIGN _U._HANDLE:PRIVATE-DATA = _U._TABLE + CHR(4) + _U._HANDLE:PRIVATE-DATA
               _U._TABLE = "RowObject":U.
        /* If the source data type is CLOB, the local name must be set.

           SDO data source: _U._NAME is the data field name (e.g. custnum)
           and is the instance name of the field in the dynamic viewer,
           therefore it is unique.

           SBO data source: _U._NAME is the data field name (e.g. custnum) but
           the instance name of the field in the dynamic viewer is qualified
           with the SDO name (e.g. custfullo.custnum) therefore it is not
           unique and requires logic to set the _LOCAL-NAME to a unqiue name.
           This cannot be done until 20040427-038 is resolved.  */
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._SOURCE-DATA-TYPE = "CLOB":U THEN
          _U._LOCAL-NAME = _U._NAME.
      END.
   END.
 END.
 /* IF data source is an SBO,change Buffer to equal the SDO object */
 ELSE DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        > "":
      IF VALID-HANDLE(_U._HANDLE) THEN
      DO:
        ASSIGN _U._HANDLE:PRIVATE-DATA = _U._BUFFER + CHR(4) + _U._HANDLE:PRIVATE-DATA
               _U._BUFFER = _U._TABLE.
        
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._SOURCE-DATA-TYPE = "CLOB":U THEN
          _U._LOCAL-NAME = _U._NAME.
      END.
   END.
 END.
 /* Load template into the Appbuilder so that the code sections (Main block, definitions, etc) of the 
    template can be copied to the static object */
 IF SEARCH(_P.design_template_file) <> ? THEN
 DO:
  ASSIGN lMRUFileList  = _mru_filelist
         _mru_filelist = NO.

   RUN adeuib/_qssuckr.p (INPUT _P.design_template_file,   /* File to read        */
                          INPUT "",                 /* WebObject           */
                          INPUT "WINDOW-SILENT":U,  /* Import mode         */
                          INPUT FALSE).             /* Reading from schema */
   ASSIGN _mru_filelist = lMRUFileList.
   IF RETURN-VALUE BEGINS "_ABORT":U THEN
   DO:
     MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     FIND _P WHERE RECID(_P) =  r_PRecid.
     ASSIGN _P._SAVE-AS-FILE   = cOldSaveAsFile
           _P.static_object    = NO
           _P.object_type_code = cOldObjectType
           _P.smartObject_obj  = dOldObjectObj.
     
     /* Re-aasign the _U._Table back to what it was */
     RUN choose_file_saveAsStatic_Undo (lIsSBO,?,cResultCode).
     RETURN.
   END.
 END. /* End if SEARCH(_P._Design_template_file) */
 ELSE DO:
    MESSAGE "Could not save object as static." SKIP(1)
            "Template file " +  _P.design_template_file + "was not found"
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
    FIND _P WHERE RECID(_P) =  r_PRecid.
    ASSIGN _P._SAVE-AS-FILE    = cOldSaveAsFile
           _P.static_object    = NO
           _P.object_type_code = cOldObjectType
           _P.smartObject_obj  = dOldObjectObj            .
    /* Re-aasign the _U._Table back to what it was */
    RUN choose_file_saveAsStatic_Undo (lIsSBO,?,cResultCode).
    RETURN.
 END.
 
 FIND template_P WHERE template_P._WINDOW-HANDLE = _h_win.
 FIND _P WHERE RECID(_P)                         = r_PRecid.
 FIND _U         WHERE RECID(_U)                 = r_URecid.
 ASSIGN hTemplateWin   = _h_win
        rTemplateRecid = RECID(template_P)
        _P._links      = template_P._links.

 /* For each _TRG record in the template file, copy to the current object */
 FOR EACH template_TRG WHERE template_TRG._pRECID = rTemplateRecid:
    FIND FIRST _TRG WHERE _TRG._pRecid = RECID(_P)
                      AND _TRG._wRecid = RECID(_U)
                      AND _TRG._tevent = template_TRG._tevent NO-ERROR.
    /* Skip XFTR sections */
    IF  template_TRG._tsection = "_XFTR":U THEN
       NEXT.
    IF NOT AVAIL _TRG THEN
    DO:
       CREATE _TRG.
       BUFFER-COPY template_TRG TO _TRG
         ASSIGN _TRG._pRECID = RECID(_P)
                _TRG._wRECID = RECID(_U).
    END.
    ELSE
       BUFFER-COPY template_TRG EXCEPT _pRECID _wRECID _tEvent TO _TRG.
 END.  /* End For Each template_TRG */
 

DO iCustom = 1 TO (IF cResultCode = "" THEN 1 ELSE 2):
   /* Retrieve the UI events specified for the dynamic object and create a 
      trigger for each */ 
   EMPTY TEMP-TABLE ttUIEvent.
   RUN retrieveDesignObject IN hDesignManager 
       (INPUT _P.Object_Filename ,
        INPUT  (IF iCustom = 1 THEN "" ELSE cResultCode) ,  /* Get default  result Codes */
        OUTPUT TABLE ttObject,
        OUTPUT TABLE ttPage,
        OUTPUT TABLE ttLink,
        OUTPUT TABLE ttUiEvent,
        OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 

   FOR EACH ttUIEvent:
       FIND FIRST ttObject WHERE ttObject.tSmartObjectObj    = ttUIEvent.tSmartObjectObj
                             AND ttObject.tObjectInstanceObj = ttUIEvent.tObjectInstanceObj NO-ERROR.
       IF NOT AVAIL ttObject THEN NEXT.

       /* If the data source is an SBO, the instance name will contain the SDO prefixed. Strip it out 
          to find the _U record. */
       ASSIGN c_UName = IF NUM-ENTRIES(ttObject.tObjectInstanceName,".") >= 2 
                        THEN ENTRY(2,ttObject.tObjectInstanceName,".")
                        ELSE ttObject.tObjectInstanceName.

       FIND Event_U WHERE Event_U._NAME = c_UName NO-ERROR. 
       IF NOT AVAIL Event_U AND c_UName > "" THEN 
          NEXT.

       IF NOT AVAIL Event_U THEN 
       DO: /* Find the Frame widget */
           FIND FIRST Event_U WHERE Event_U._TYPE = "FRAME":U AND Event_U._parent = hOldWin NO-ERROR.
           IF NOT AVAIL Event_U THEN NEXT.
       END.
       ASSIGN cEventCode   = "/*  Generated trigger from Dynamic Object '" + _P.Object_Filename + "' */" + CHR(10) + "DO:" + CHR(10)
              cEventTarget = "".


      CASE ttUIEvent.tActionTarget:

         WHEN "SELF":U      THEN ASSIGN cEventTarget =  "TARGET-PROCEDURE" .
         WHEN "CONTAINER":U THEN ASSIGN cEventTarget = "  ~{get ContainerSource hTarget~}.":U.
         /* Run anywhere. This is only valid for an action type of PUB. */
         WHEN "ANYWHERE":U  THEN ASSIGN cEventTarget = "":U.
         /* Run on the AppServer. This is only valid for an action type of RUN. */
         WHEN "AS":U        THEN ASSIGN cEventTarget = "gshAstraAppServer":U.
         /* Managers: of the manager handle is used, we use the hard-coded,
          * predefined handle variables.                                        */
         WHEN "GM":U        THEN ASSIGN cEventTarget = "gshGenManager":U.
         WHEN "SM":U        THEN ASSIGN cEventTarget = "gshSessionManager":U.
         WHEN "SEM":U       THEN ASSIGN cEventTarget = "gshSecurityManager":U.
         WHEN "PM":U        THEN ASSIGN cEventTarget = "gshProfileManager":U.
         WHEN "RM":U        THEN ASSIGN cEventTarget = "gshRepositoryManager":U.
         WHEN "TM":U        THEN ASSIGN cEventTarget = "gshTranslationManager":U.
         OTHERWISE  DO:
           IF ttUIEvent.tActionTarget > "" THEN
              cEventTarget = "  hTarget = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT " + '"' + ttUIEvent.tActionTarget + '":U' + ") NO-ERROR.":U. 
         END.
       END CASE.

      /* If event is disabled, comment out trigger */
      IF ttUIEvent.tEventDisabled THEN
         cEventCode   = cEventCode + "/******************** Disabled Event ********************" + CHR(10).
    /* Add the code to retrieve the target for container and other targets.*/
       IF NUM-ENTRIES(cEventTarget, " ") > 1 THEN
          cEventCode = cEventCode + "  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.":U + CHR(10)
                                  + cEventTarget + CHR(10).

       IF ttUIEvent.tActionType = "RUN":U THEN
           cEventCode = cEventCode + "  RUN ":U + ttUIEvent.tEventAction
                                   + (IF ttUIEvent.tActionTarget = "AS":U OR ttUIEvent.tActionTarget = "AppServerConnectionManager":U THEN " ON ":U 
                                      ELSE IF cEventTarget > "" THEN " IN ":U ELSE "") 
                                   + (IF NUM-ENTRIES(cEventTarget, " ") > 1 THEN "hTarget":U  ELSE cEventTarget).
       ELSE 
           cEventCode = cEventCode + "  PUBLISH ":U + '"' + ttUIEvent.tEventAction + '":U'
                                   + (IF NUM-ENTRIES(cEventTarget, " ") > 1 
                                      THEN " FROM hTarget ":U  
                                      ELSE IF cEventTarget > "" THEN " FROM " + cEventTarget
                                                                ELSE "")  .

       IF ttUIEvent.tEventParameter > "" THEN
           cEventCode = cEventCode + " ( INPUT " + '"' + ttUIEvent.tEventParameter + '":U' + ")":U.

       IF ttUIEvent.tActionType = "RUN":U THEN 
          cEventCode = cEventCode + " NO-ERROR.":U.
       ELSE
          cEventCode = cEventCode + ".":U .

       IF ttUIEvent.tActionType = "RUN":U  THEN
          cEventCode = cEventCode + CHR(10) 
                                  + "  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE '' THEN"
                                  + CHR(10) + "     RETURN NO-APPLY.".

      IF ttUIEvent.tEventDisabled THEN
       cEventCode = cEventCode + CHR(10) + "*******************************************************/":U .

      cEventCode = cEventCode + CHR(10) + "END.":U.

      FIND FIRST _TRG WHERE _TRG._pRecid = RECID(_P)
                        AND _TRG._wRecid = RECID(Event_U)
                        AND _TRG._tevent = ttUIEvent.tEventNAME NO-ERROR.

      IF NOT AVAIL _TRG THEN
         CREATE _TRG.
      ASSIGN _TRG._tSECTION = "_CONTROL":U
             _TRG._wRECID   = RECID(Event_U)
             _TRG._tEVENT   = CAPS(ttUIEvent.tEventNAME)
             _TRG._tCODE    = cEventCode
             _TRG._STATUS   = "NORMAL":U
             _TRG._pRECID   = RECID(_P).
  END.
END. /* End iCustom  1 to 1 or 2) */

/* Need to copy the _L records from the custom code to the master layout */
IF cResultCode > "" THEN
DO:
   /* Store the contents of _L to a temp table in case we need to undo the copying of _L records */
   CREATE TEMP-TABLE tthL.
   tthL:CREATE-LIKE(BUFFER _L:HANDLE).
   tthL:TEMP-TABLE-PREPARE("Undo_L").

   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                 AND _U._STATUS = "NORMAL":U:
      
      RELEASE _L NO-ERROR.
      /* Find b_L of custom */      
      FIND b_L WHERE b_L._lo-name = cResultCode AND b_L._u-recid = RECID(_U) NO-ERROR.
      /* Find _L of Master Layout */
      IF AVAIL b_L THEN
        FIND _L WHERE _L._lo-name = "Master Layout":U AND _L._u-recid = b_L._u-recid NO-ERROR.

      IF AVAIL _L THEN
      DO:
         bhL = tthl:DEFAULT-BUFFER-HANDLE.
         bhL:BUFFER-CREATE.
         bhL:BUFFER-COPY(BUFFER _L:HANDLE).
         /* Now copy the _L records from the custom to the master, so that the save will use the _l records. */
         BUFFER-COPY b_L EXCEPT _LO-NAME _BASE-LAYOUT TO _L.
         /* Now delete the custom record */
         DELETE b_L.
        ASSIGN _U._lo-recid = RECID(_L)
               _U._layout-name = "Master Layout":U.
       END.
   END. /* For each _U */
END. /* End if cResultCode > "" */
 
 /* Refind _P after closing template window and reassign _h_Win incase it was confused*/
 FIND _P WHERE RECID(_P) = r_PRecid.
 FIND _U WHERE RECID(_U) = r_URecid.


  
 IF _h_win NE hOldWin THEN
 DO:
    ASSIGN _h_Win      = hOldWin
           _h_cur_widg = hOldWidg.
    FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
    IF AVAILABLE _F THEN 
       _h_frame = _F._FRAME.
    ELSE DO:
        IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN 
           _h_frame = _U._HANDLE.
        ELSE _h_frame = ?.
    END.
    RUN curframe IN THIS-PROCEDURE (_h_cur_widg).
 END.

 FIND _P WHERE RECID(_P) = r_PRecid.
 FIND _U WHERE RECID(_U) = r_URecid.

 RUN save_window IN THIS-PROCEDURE (YES, OUTPUT lCancel).

 IF VALID-HANDLE(hTemplateWin)THEN
    RUN wind-close IN THIS-PROCEDURE (hTemplateWin).
 
 IF lCancel THEN
 DO:
    FIND _P WHERE RECID(_P) =  r_PRecid.
    ASSIGN _P._SAVE-AS-FILE       = cOldSaveAsFile
           _P.static_object       = NO
           _P.object_type_code    = cOldObjectType
           _P.smartObject_obj     = dOldObjectObj.          
     
    RUN choose_file_saveAsStatic_Undo (lIsSBO,bHL,cResultCode).
    
 END.
 ELSE DO:
   /* Un register dynamic object in property sheet */
   IF VALID-HANDLE(_h_menubar_proc) THEN
       RUN Unregister_PropSheet IN _h_menubar_proc (_h_win,"*") NO-ERROR. 
   
 END.
 RUN display_current IN THIS-PROCEDURE.
 DELETE OBJECT ttHL NO-ERROR.
END PROCEDURE. /* choose_file_save_as_static */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_goto_page Include 
PROCEDURE choose_goto_page :
/*------------------------------------------------------------------------------
  Purpose: change the page number shown for the current window     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* Does this procedure support paging? If so change the page and display
     it? */
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    IF CAN-DO (_P._links, "PAGE-TARGET") THEN DO:
      /* Only page 0 is allowed on alternate layouts. */
      FIND _U WHERE RECID(_U) EQ _P._u-recid.
      IF _U._LAYOUT-NAME EQ '{&Master-Layout}':U THEN DO:
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
END PROCEDURE. /* choose_goto_page */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_import_fields Include 
PROCEDURE choose_import_fields :
/*------------------------------------------------------------------------------
  Purpose:  load fields (and their VIEW-AS) from the database   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR drawn AS LOGICAL INITIAL FALSE NO-UNDO.
  DEFINE VAR tfile AS CHARACTER NO-UNDO.
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      "You must have at least one connected database to insert database fields.",
      OUTPUT ldummy).
    IF ldummy EQ NO THEN RETURN.
  END.
  IF _h_frame = ? THEN DO:
    /* Assume the first frame in the window (if there is one). */
    FIND _U WHERE _U._TYPE EQ "FRAME":U
              AND _U._STATUS NE "DELETED":U
              AND _U._WINDOW-HANDLE EQ _h_win NO-ERROR.
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
END PROCEDURE. /* choose_import_fields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_import_file Include 
PROCEDURE choose_import_file :
/*------------------------------------------------------------------------------
  Purpose: Import an exported file    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR lnth_sf AS INTEGER NO-UNDO.
  DEF VAR pressed_ok AS LOGICAL NO-UNDO.
  DEF VAR absolute_name AS CHAR NO-UNDO.

  /* Choose a *.wx file from the saved set of WIDGET-DIRS.  Use TEMPLATE
     mode here so that we can show related pictures of the choosen file
     (if they exist). */
  open_file = "".
  RUN adecomm/_fndfile.p (INPUT "From File",                          /* pTitle            */
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
           _h_frame       = (IF _U._TYPE EQ "WINDOW":U THEN ? ELSE _U._HANDLE)
           .
    RUN display_current.

    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN
      RUN choose-pointer.
  END.
END PROCEDURE. /* choose_import_file */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_insert_trigger Include 
PROCEDURE choose_insert_trigger :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Choose Event dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
  IF NOT mi_insert_trigger:SENSITIVE THEN RETURN NO-APPLY.
  IF VALID-HANDLE(OEIDE_ABSecEd) THEN
    RUN NewTriggerBlock IN OEIDE_ABSecEd (?) NO-ERROR.  /* prompt for event name */

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_insert_trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_insert_procedure Include 
PROCEDURE choose_insert_procedure :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Add Procedure dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
  IF NOT mi_insert_procedure:SENSITIVE THEN RETURN NO-APPLY.
  IF VALID-HANDLE(OEIDE_ABSecEd) THEN
    RUN NewCodeBlock IN OEIDE_ABSecEd ("_PROCEDURE":U) NO-ERROR.

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_insert_procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_insert_function Include 
PROCEDURE choose_insert_function :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Add Function dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
  IF NOT mi_insert_function:SENSITIVE THEN RETURN NO-APPLY.
  IF VALID-HANDLE(OEIDE_ABSecEd) THEN
    RUN NewCodeBlock IN OEIDE_ABSecEd ("_FUNCTION":U) NO-ERROR.

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_insert_function */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_mru_file Include 
PROCEDURE choose_mru_file :
/*------------------------------------------------------------------------------
  Purpose: opens file from the MRU Filelist    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ifile AS INTEGER NO-UNDO.

  DEFINE VARIABLE cTempFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE glScrap     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE h_curwin    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFileError  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOpenObject AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lStayList   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE relPathName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER NO-UNDO.

  FIND _mru_files WHERE _mru_files._position = ifile NO-ERROR.
  IF AVAILABLE _mru_files THEN DO:

    ASSIGN h_curwin = _h_win.

    /* Deselect the currently selected widgets */
    RUN deselect_all (?, ?).

    IF _mru_files._broker <> "" THEN DO:
      
      /* for web files, this may include the path, so need to pass full
         path name to _webcom.w 
      */
      ASSIGN cFileName = ws-get-absolute-path (INPUT _mru_files._file).
      
      RUN adeweb/_webcom.w (?, _mru_files._broker, cFileName, "open",
        OUTPUT relpathname, INPUT-OUTPUT ctempfile).

      IF RETURN-VALUE BEGINS "ERROR":U THEN
      DO:
        /* _mru_files._file may have info to construct the full path name.
           For the error message, we just want the relative path name, if available.
        */        
        IF INDEX(RETURN-VALUE,"Not readable":U) NE 0 THEN
          RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
            SUBSTITUTE("Cannot open &1.  WebSpeed agent does not have read permission.",
            ws-get-relative-path (INPUT _mru_files._file) )).

        IF INDEX(RETURN-VALUE,"File not found":U) NE 0 THEN
          MESSAGE ws-get-relative-path (INPUT _mru_files._file) "not found in WebSpeed agent PROPATH."
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
      /* jep-icf IZ 2342 If ICF, look for the MRU file in the repository. Currently Works for dynamic object only. */
      IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
      DO:
         ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
         IF VALID-HANDLE(ghRepositoryDesignManager) THEN
            ASSIGN lOpenObject  = DYNAMIC-FUNCTION("openRyObjectAB" IN ghRepositoryDesignManager, INPUT _mru_files._file)
                   lFileError   = (lOpenObject = NO).

      END.
      /* IZ 2342 If not ICF or can't find the repository object, look for the MRU file in the file system. */
      IF NOT CAN-DO(_AB_Tools, "Enable-ICF":u) OR lFileError THEN
      DO:
          ASSIGN FILE-INFO:FILE-NAME = _mru_files._file.
          ASSIGN lFileError = (FILE-INFO:FILE-TYPE = ?).
      END.

      IF lFileError THEN DO:
        MESSAGE _mru_files._file "cannot be found." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        DELETE _mru_files.
        RUN adeshar/_mrulist.p("":U, "":U).
        lFileError = TRUE.
      END.  /* if file type = ? */
    END.  /* else - local file */

    IF NOT lFileError THEN DO:
      IF lOpenObject THEN
        RUN setstatus (?, "Opening object...").
      ELSE
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

    /* Show the property sheet of a dynamic repository object. */
    IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
      IF AVAILABLE(_P) AND (NOT _P.static_object) AND
               LOOKUP("DynView":U,_P.parent_classes)= 0
           AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
           AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
           AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0  THEN
         RUN choose_prop_sheet IN _h_UIB.
    END.

    /* Special Sanity check -- sanitize our records.  Always do this (even if
     the user cancelled the file open)  */
    RUN adeuib/_sanitiz.p.

  END.  /* if avail mru files */

END PROCEDURE.  /*choose_mru_file */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_new_adm2_class Include 
PROCEDURE choose_new_adm2_class :
/*------------------------------------------------------------------------------
  Purpose: create a new ADM2 class    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN adeuib/_clasnew.w.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_new_pw Include 
PROCEDURE choose_new_pw :
/*------------------------------------------------------------------------------
  Purpose: creates a new Procedure Window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_pwmain.p ("_ab.p":U /* PW Parent ID */,
                           ""  /* Files to open */,
                           ""  /* PW Command */ ).
  END.

END PROCEDURE. /* choose_new_pw */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_object_open Include 
PROCEDURE choose_object_open :
/*------------------------------------------------------------------------------
  Purpose: called by File/Open Object to Open Repository Object     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN choose_open (INPUT "OBJECT":u).

END PROCEDURE.  /* choose_object_open */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_open Include 
PROCEDURE choose_open :
/*------------------------------------------------------------------------------
  Purpose: Displays Open File or Open Object dialog and performs the open     
 
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pOpenMode AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cTempFile    AS CHARACTER              NO-UNDO.
  DEFINE VARIABLE h_curwin     AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE h_active_win AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE lnth_sf      AS INTEGER                NO-UNDO.
  DEFINE VARIABLE pressed-ok   AS LOGICAL                NO-UNDO.
  DEFINE VARIABLE cOpenMsg     AS CHARACTER              NO-UNDO.
  DEFINE VARIABLE hRepDesignManager  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE cAbort       AS CHARACTER              NO-UNDO.

  ASSIGN
    h_curwin = _h_win.

  /* Deselect the currently selected widgets */
  RUN deselect_all (?, ?).

  CASE pOpenMode:
    WHEN "FILE":U
      THEN DO:
        /* Get a file name to open. */
        /* If WebSpeed is licensed, call web file dialog, unless user has also licensed Enterprise and wants local file management. */
        IF _AB_license > 1
        AND _remote_file
        THEN
          RUN adeweb/_webfile.w (INPUT "uib":U
                                ,INPUT "Open":U
                                ,INPUT "Open":U
                                ,INPUT "":U
                                ,INPUT-OUTPUT open_file
                                ,OUTPUT cTempFile
                                ,OUTPUT pressed-ok
                                ).

        IF _AB_license = 1
        OR NOT _remote_file
        OR RETURN-VALUE = "HTTPFailure":U
        THEN
          RUN adecomm/_getfile.p(INPUT CURRENT-WINDOW
                                ,INPUT "uib"
                                ,INPUT "Open"
                                ,INPUT "Open"
                                ,INPUT "OPEN"
                                ,INPUT-OUTPUT open_file
                                ,OUTPUT pressed-ok
                                ).
        ASSIGN
          cOpenMsg = "Opening file...".
       /* Check whether the file is registered in the repository */
       IF pressed-ok AND CAN-DO(_AB_Tools, "Enable-ICF":U) THEN
       DO:
         hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
         IF VALID-HANDLE(hRepDesignManager) THEN
            DYNAMIC-FUNCTION("openRyObjectAB" IN hRepDesignManager, INPUT open_file).
       END.


      END.

    WHEN "OBJECT":U
    THEN DO:
      /* jep-icf: If ICF is running, get an object name to open using Open dialog. */
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)
      THEN DO:
        RUN adecomm/_getobject.p (INPUT _h_menu_win   /* Window Handle             */
                                 ,INPUT ""            /* Product Module            */
                                 ,INPUT YES           /* Open in AppBuilder        */
                                 ,INPUT "Open Object" /* Title to display          */
                                 ,OUTPUT open_file    /* Name of File being opened */
                                 ,OUTPUT pressed-ok   /* Pressed OK on selection   */
                                 ).

        ASSIGN
          cOpenMsg = "Opening object...".
      END.
    END.

  END CASE.

  IF pressed-ok THEN
  DO:
    RUN setstatus (?, cOpenMsg).
    RUN adeuib/_open-w.p (open_file, cTempFile, "WINDOW":U).
    IF _DynamicsIsRunning AND RETURN-VALUE > "" AND NOT RETURN-VALUE BEGINS  "_":U THEN
    DO:
       RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                                  INPUT "ERR":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "Object Open Error",
                                                  INPUT YES,
                                                  INPUT ?,
                                                 OUTPUT cAbort).
       RETURN RETURN-VALUE.
    END.

    IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.

    /* In case of _qssuckr failure, reset the cursors . */
    RUN setstatus ("":U, "":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.

    /* If no file was opened, leave now. */
    IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.
  END.

  /* Show the property sheet of a dynamic repository object. */
  IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
  DO:
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    IF AVAILABLE(_P) AND (NOT _P.static_object) AND
              LOOKUP("DynView":U,_P.parent_classes)= 0
          AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
          AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
          AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0  THEN
      RUN choose_prop_sheet IN _h_UIB.
  END.

  /* Special Sanity check -- sanitize our records.  Always do this (even if
   the user cancelled the file open)  */
  RUN adeuib/_sanitiz.p.

END PROCEDURE.    /* choose_open */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_paste Include 
PROCEDURE choose_paste :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Paste; PASTE Accelerators     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

    IF  (ENTRY(1, _clipboard_editor:SCREEN-VALUE, " ") = "&ANALYZE-SUSPEND")
    AND (ENTRY(2, _clipboard_editor:SCREEN-VALUE, " ") = "_EXPORT-NUMBER") THEN DO:

      /* Make sure the OCX control file is retrieved. Windows 3.1 only. */
      IF (OPSYS = "WIN32":u) THEN ASSIGN _control_cb_op = TRUE.

      RUN adeuib/_qssuckr.p(temp_file, "", "IMPORT":U, FALSE).
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      RUN display_current.

      /* SEW Update after adding widgets in UIB. */
      RUN call_sew ("SE_ADD":U).

      OS-DELETE VALUE((SUBSTR(temp_file, 1, R-INDEX(temp_file, ".") - 1) + {&STD_EXT_UIB_QS})).
      _save_file = cvCurrentSaveFile.

      IF OPSYS = "WIN32":u THEN ASSIGN _control_cb_op = FALSE.

      /* set the file-saved state to false, since we just pasted object(s) */
      RUN adeuib/_winsave.p(_h_win, FALSE).
    END.
    ELSE DO:
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
      APPLY LASTKEY TO SELF.
      ELSE
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
END PROCEDURE. /* choose_paste   */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_proc_settings Include 
PROCEDURE choose_proc_settings :
/*------------------------------------------------------------------------------
  Purpose:  bring up the property sheet for current procedure   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR cur_page AS INTEGER NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    /* Save the current page incase the user changes it. */
    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    cur_page = _P._page-current.
    /* Procedure Settings editor */
    RUN adeuib/_edtproc.p (_h_win).
    IF cur_page NE _P._page-current THEN RUN display_page_number.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_prop_sheet Include 
PROCEDURE choose_prop_sheet :
/*------------------------------------------------------------------------------
  Purpose:  bring up the property sheet   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_cur_widg <> ?
  THEN RUN property_sheet (_h_cur_widg).
  ELSE MESSAGE "No object is currently selected." {&SKP}
               "Please select an object with the pointer and try again."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_run Include 
PROCEDURE choose_run :
/*------------------------------------------------------------------------------
  Purpose: called by F2 or Compile/Run    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN call_run ("RUN").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_show_palette Include 
PROCEDURE choose_show_palette :
/*------------------------------------------------------------------------------
  Purpose:  This shows or hides the tool palette   
  Parameters:  <none>
  Notes:   called by CTRL-T or Windows/Show Tool Palette.     
------------------------------------------------------------------------------*/
 DEFINE VAR h AS WIDGET  NO-UNDO.

  IF _AB_License EQ 2 THEN RETURN.
  h = mi_show_toolbox.
  IF _h_object_win:VISIBLE THEN
    ASSIGN _h_object_win:HIDDEN = YES
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
    ASSIGN _h_object_win:HIDDEN  = NO
           ldummy                = _h_object_win:MOVE-TO-TOP()
           h:LABEL               = "&Hide Object Palette".
  END.
END PROCEDURE. /* choose_show_palette */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_tab_edit Include 
PROCEDURE choose_tab_edit :
/*------------------------------------------------------------------------------
  Purpose: fires off the tab-editor    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
    IF NOT AVAILABLE _U THEN DO:
      /* This happens when a smartviewer is opened, but not entered */
      FIND FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND _U._TYPE = "FRAME":U
        NO-ERROR.
      IF NOT AVAILABLE _U THEN
        MESSAGE "Please click on the frame you want to edit."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      ELSE _h_frame = _U._HANDLE.
    END.  /* If not available _U */
    RUN adeuib/_tabedit.w (RECID (_U)).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_tempdb_maint Include 
PROCEDURE choose_tempdb_maint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Called from selecting TEMP-DB Maintenance Tool in the Tools menu      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChoice AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK     AS LOGICAL   NO-UNDO.

  ASSIGN Db_Pname = "TEMP-DB":U
                           Db_Lname = ?
                           Db_Type  = "PROGRESS".

  IF NOT CONNECTED("TEMP-DB":U) THEN
  DO:
     RUN adeuib/_advisor.w (
                    INPUT "This utility requires a connection to the 'TEMP-DB' database."
                     + CHR(10) + "Would you like to connect to this database?",
                    INPUT  "Co&nnect.  Connect to '" + 'TEMP-DB' + "' now.,_CONNECT,
&Cancel.  Do not start this utility.,_CANCEL" ,
                    INPUT FALSE,
                    INPUT "",
                    INPUT 0,
                    INPUT-OUTPUT cChoice,
                    OUTPUT ldummy ).
     IF cChoice = "_CONNECT":U THEN
             RUN adecomm/_dbconn.p
                     (INPUT-OUTPUT  Db_Pname,
                            INPUT-OUTPUT  Db_Lname,
                            INPUT-OUTPUT  Db_Type).
  END.

  IF NOT CONNECTED("TEMP-DB":U) THEN
    RETURN "ERROR":U.

  IF NOT VALID-HANDLE(hTempDB) THEN
  DO:
      SESSION:SET-WAIT-STATE('GENERAL':U).
      RUN adeuib/_TempDBCheck.p (OUTPUT lOK).       
      IF lOK THEN
      DO:
         RUN adeuib/_tempdb.w PERSISTENT SET hTempDB .
         RUN initializeObject IN hTempDB.
      END.  
      SESSION:SET-WAIT-STATE('':U). 
  END.
  ELSE 
    RUN MoveToTop IN hTempDB.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_template Include 
PROCEDURE choose_template :
/*------------------------------------------------------------------------------
  Purpose:  called by 'New' popup menu   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_uib_browser Include 
PROCEDURE choose_uib_browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: First we deselect everything, because"
      1) the browser doesn't show the cur_widg [due to 7.1C browser limitation
         setting the CURRENT-ITERATION.
      2) we need to have nothing selected for the reinstantiation logic to work
         (in case user goes into a property sheet and changes NO-BOX, for example)
         selected objects .       
------------------------------------------------------------------------------*/

   IF NOT CAN-FIND(FIRST _U) THEN DO:
     MESSAGE "There are no objects to list." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     RETURN.
   END.
   RUN deselect_all (?, ?).  /* 7.1C needed for our new reinstantiation logic */

   /* SEW call to store current trigger code for specific window. */
   RUN call_sew ("SE_STORE_WIN":U).
   RUN adeuib/_uibrows.p.

   IF VALID-HANDLE(_h_cur_widg) THEN DO:
     /*The no-error and the return no-apply were added for the fix of OE00120832.
       The FIND fails if _h_cur_widg is the window itself. This won't happen once an object is selected either in
       the window or in the object lists, h_cur_widg will always return an object
       type that could be found in _U.*/
     FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
     IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE choose_undo Include 
PROCEDURE choose_undo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  called by CTRL-Z or Edit/Undo     
------------------------------------------------------------------------------*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateDataFieldPopup Include 
PROCEDURE CreateDataFieldPopup :
/*------------------------------------------------------------------------------
  Purpose: creates popup menus for all datafield objects     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hField      AS HANDLE                    NO-UNDO.

  DEFINE VARIABLE hPopupMenu          AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hEditMaster         AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hEditInstance       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hRule               AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hCut                AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hCopy               AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hDelete             AS HANDLE                    NO-UNDO.

  CREATE MENU hPopupMenu
    ASSIGN POPUP-ONLY = TRUE.

  CREATE MENU-ITEM heditMaster
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Edit DataField &Master..."
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN editMasterDataField IN _h_uib (INPUT hField).
    END TRIGGERS.

  CREATE MENU-ITEM heditInstance
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Edit DataField &Instance..."
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN property_sheet IN _h_uib (INPUT hField).
    END TRIGGERS.

  CREATE MENU-ITEM hRule
    ASSIGN PARENT = hPopupMenu
           SUBTYPE = "Rule":U.

  CREATE MENU-ITEM hCut
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Cut"
           ACCELERATOR = "Ctrl+X"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_cut IN _h_uib.
    END TRIGGERS.

  CREATE MENU-ITEM hCopy
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Copy"
           ACCELERATOR = "Ctrl+C"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_copy IN _h_uib.
    END TRIGGERS.

  CREATE MENU-ITEM hDelete
    ASSIGN PARENT = hPopupMenu
           LABEL  = "&Delete"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_erase IN _h_uib.
    END TRIGGERS.

    ASSIGN hField:POPUP-MENU = hPopupMenu.

END PROCEDURE. /* CreateDataFieldPopup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE curframe Include 
PROCEDURE curframe :
/*------------------------------------------------------------------------------
  Purpose:  change the currently frame and window.  
            This procedure is called when the user clicks anywhere but you 
            don't want to change the curwidg    
 
  Notes: _h_cur_widg is set to ? if the frame is different   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_thing AS WIDGET                         NO-UNDO.

  DEFINE VAR old_frame  AS WIDGET-HANDLE                           NO-UNDO.
  DEFINE VAR old_win    AS WIDGET-HANDLE                           NO-UNDO.
  DEFINE VAR hframe     AS WIDGET-HANDLE                           NO-UNDO.
  /* Is this widget in a frame that differs from the _h_cur_widg. */
  IF h_thing <> _h_cur_widg THEN DO:
    /* Set the current widget and check that the frame has changed */
    ASSIGN old_frame   = _h_frame
           old_win     = _h_win.

    FIND _U WHERE _U._HANDLE = h_thing NO-ERROR.
    IF NOT AVAIL _U THEN
    DO:
      /* May be a Dialog, get the frame widget handle */
      ASSIGN hFrame = h_thing:FIRST-CHILD NO-ERROR.
      FIND _U WHERE _U._HANDLE =  hFrame NO-ERROR.
      IF NOT AVAIL _U THEN RETURN.
      ELSE IF _U._TYPE = "DIALOG-BOX":U THEN
      DO:
        ASSIGN _h_Frame        = hFrame
               _h_win          = h_thing
               _h_cur_widg     = ?
                h_display_widg = ?
               NO-ERROR.
        RUN changewidg (hFrame, NO).
        RETURN "ERROR":U.
      END.
    END.

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
               _h_frame = (IF _h_frame:TYPE EQ "WINDOW" THEN ?
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
  RETURN .
END PROCEDURE. /* curframe */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE curwidg Include 
PROCEDURE curwidg :
/*------------------------------------------------------------------------------
  Purpose: change the currently selected widget frame and window    
  Parameters:  <none>
  Notes: This procedure is called when the user clicks anywhere 
         the user selects a widget.      
------------------------------------------------------------------------------*/
  /* Has anything changed? */
  IF SELF NE _h_cur_widg THEN DO:
    RUN curframe (SELF).
    IF RETURN-VALUE <> "ERROR":U THEN
       _h_cur_widg = SELF.
  END.
  /* Show the new current widget, if necessary. */
  IF _h_cur_widg NE h_display_widg THEN RUN display_current.
  IF VALID-HANDLE(_h_cur_widg) THEN DO:
    IF _h_cur_widg:TYPE NE "WINDOW":U AND _h_cur_widg:TYPE NE "FRAME":U THEN
      APPLY "SELECTION":U TO _h_cur_widg.
  END.

END PROCEDURE. /* curwidg */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delselected Include 
PROCEDURE delselected :
/*------------------------------------------------------------------------------
  Purpose: deleted all selected widgets    
  Parameters:  <none>
  Notes:  the user has confirmed that this is what they want.     
------------------------------------------------------------------------------*/
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
END PROCEDURE. /* delselected */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE del_cur_widg_check Include 
PROCEDURE del_cur_widg_check :
/*------------------------------------------------------------------------------
  Purpose: Check to see if the "current widget" still exists    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Show the current widget, which should be empty. */
  FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
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

  /* IZ 1508 This call can create a Section Editor window for
     a procedure that's being closed. Only make the call if the
     procedure already has a Section Editor window open for it. - jep */
  /* jep - SEW Update after delete event in UIB. */
  IF VALID-HANDLE(hSecEd) THEN
    RUN call_sew ("SE_DELETE":U).

END PROCEDURE. /* del_cur_widg_check */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deselect_all Include 
PROCEDURE deselect_all :
/*------------------------------------------------------------------------------
  Purpose: Deselect all widgets (except except_h) that are not in window 
           except_h_win      

  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER except_h     AS widget NO-UNDO.
  DEF INPUT PARAMETER except_h_win AS widget NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib
                AND _U._HANDLE NE except_h
                AND _U._WINDOW-HANDLE NE except_h_win:
     _U._SELECTEDib      = FALSE.
     IF VALID-HANDLE(_U._HANDLE) THEN _U._HANDLE:SELECTED = FALSE.
  END.
END PROCEDURE. /* deselect_all */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE designFrame.ControlNameChanged Include 
PROCEDURE designFrame.ControlNameChanged :
/*------------------------------------------------------------------------------
  Purpose: Special trigger for Control-Frames...     
           Gets the new name of a control when it's changed in the 
           Property Editor 
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER hCtrl      AS COM-HANDLE. /* OCX Control   */
  DEFINE INPUT PARAMETER oldname    AS CHARACTER.  /* old name of control */
  DEFINE INPUT PARAMETER newname    AS CHARACTER.  /* new name of control */

  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = newname
         _U._LABEL    = newname.
  RUN Display_Current IN _h_uib.   /* update data in the Main Window */
  RUN call_sew ("SE_PROPS":U). /* notify Section Editor of change */
END PROCEDURE. /* designFrame.ControlNameChanged */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE designFrame.ObjectCreated Include 
PROCEDURE designFrame.ObjectCreated :
/*------------------------------------------------------------------------------
  Purpose: Special trigger for Control-Frames...
           Grab the name of each OCX control created within a Control-Frame     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER name       AS CHARACTER.  /* name of control */

  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = name
         _U._LABEL    = name.
END PROCEDURE. /* designFrame.ObjectCreated */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dialog-close Include 
PROCEDURE dialog-close :
/*------------------------------------------------------------------------------
  Purpose: redirects this to wind-close after making sure that h_self points 
           to the proper widget (and not the dummy window itself).    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_self  AS WIDGET  NO-UNDO.
  IF h_self:TYPE = "WINDOW":U THEN
    h_self = h_self:FIRST-CHILD.
  RUN wind-close (h_self).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_widgets Include 
PROCEDURE disable_widgets :
/*------------------------------------------------------------------------------
  Purpose:  disable the UIB so that another tool can run   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h           AS WIDGET  NO-UNDO.
  DEFINE VAR ldummy      AS LOGICAL NO-UNDO.
  DEFINE VAR h-menubar   AS WIDGET  NO-UNDO.

  /* DESELECTION everything (because if we don't we might run setdeselection
     when we click in the windows we are running */
  FOR EACH _U WHERE _U._SELECTEDib AND _U._TYPE <> "WINDOW":
    _U._SELECTEDib        = FALSE.
    IF _U._STATUS <> "DELETED" THEN _U._HANDLE:SELECTED = FALSE.
  END.

  /* SEW call to hide the SEW if its visible. */
  RUN call_sew ("SE_HIDE":U).

  ASSIGN
    _h_menu_win:SENSITIVE      = NO
    _h_status_line:SENSITIVE   = NO /* Status bar has some dbl-click actions */
    h-menubar                  = _h_menu_win:MENU-BAR   /* jep-icf avoids static m_menbar ref */
    h-menubar:SENSITIVE        = NO.                    /* jep-icf avoids static m_menbar ref */

  /* Hide all children of the UIB Main window.  This should include:
         Object Palette, Design Windows, Attribute Window, Section Editor
         and Cue Cards
     Keep a list of these windows so we can show them again later. */
  ASSIGN h = _h_menu_win:FIRST-CHILD
         windows2view = "".
  DO WHILE VALID-HANDLE(h):
    IF h:TYPE EQ "WINDOW" AND h:VISIBLE THEN DO:
      IF windows2view EQ "" THEN  windows2view = STRING(h).
      ELSE windows2view = windows2view + "," + STRING(h).
      h:HIDDEN = YES.
    END.
    ASSIGN h = h:NEXT-SIBLING.
  END.
  /* Hide OCX Property Editor window. */
  RUN show_control_properties (2).

  DO WITH FRAME action_icons:
    /* Desensitize the action bar. */
    DO i = 1 TO bar_count:
      _h_button_bar[i]:SENSITIVE = NO.
    END.
    ASSIGN
      /* Store the sensitivity of the fill-in fields */
      cur_widg_text:PRIVATE-DATA = IF cur_widg_text:SENSITIVE THEN "y" ELSE "n"
      cur_widg_text:SENSITIVE    = NO
      cur_widg_name:PRIVATE-DATA = IF cur_widg_name:SENSITIVE THEN "y" ELSE "n"
      cur_widg_name:SENSITIVE    = NO.
    IF VALID-HANDLE(Mode_Button) THEN Mode_Button:SENSITIVE = NO.
    IF VALID-HANDLE(OpenObject_Button) THEN OpenObject_Button:SENSITIVE = NO.
  END.

  /* Restore the users value for THREE-D. Ditto for DATE-FORMAT. */
  ASSIGN SESSION:THREE-D     = save_3d
         SESSION:DATE-FORMAT = _orig_dte_fmt.

  /* Set Pause before-hide so that running from the UIB acts like running
     from the editor. */
  PAUSE BEFORE-HIDE.

  /* Unset UIB as active ADE tool. */
  ASSIGN h_ade_tool = ?.

END PROCEDURE. /* disable_widgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display_current Include 
PROCEDURE display_current :
/*------------------------------------------------------------------------------
  Purpose: shows the name and label of the current widget in in the menu window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* debugging code to see if current window/frame/widget is set correctly 
  ---------------------------------
  DISPLAY ((IF _h_cur_widg NE ? THEN STRING(_h_cur_widg) ELSE "?") + " " +
           (IF _h_frame NE ?    THEN STRING(_h_frame)    ELSE "?") + " " +
           (IF _h_win NE ?      THEN STRING(_h_win)      ELSE "?"))
           AT ROW 2.8 COL 38 BGC 1 FGC 15 FORMAT "X(30)"  VIEW-AS TEXT
       WITH FRAME action_icons.
  -------------------------------------------------------------------- */
  DEFINE VARIABLE cs-char       AS CHARACTER CASE-SENSITIVE NO-UNDO.
  DEFINE VARIABLE l_master      AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE l_DynLabel    AS LOGICAL                  NO-UNDO.

  DEFINE BUFFER ipU FOR _U.

  DEFINE BUFFER b_U FOR _U.
  /* DBG STATEMENTs to help reduce flashing
  def var zzz as char no-undo.
  zzz =  LAST-EVENT:LABEL +      "  " + LAST-EVENT:FUNCTION + "  " +
      /* LAST-EVENT:EVENT-TYPE + "  " + */ LAST-EVENT:TYPE +     "  (" +
           STRING(LAST-EVENT:X) + "," +   STRING(LAST-EVENT:Y) + ")".
    run adecomm/_statdsp.p (_h_status_line, {&STAT-Main}, zzz). */

  /* To reduce flashing, check the last event.  If we did a MOUSE-SELECT
     DOWN in a UIB widget, then ignore the event. */
  IF NOT (LAST-EVENT:LABEL EQ "MOUSE-SELECT-DOWN":U AND
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
      error_on_leave = NO.
      IF cur_widg_name:SENSITIVE AND INPUT cur_widg_name NE display_name THEN
        APPLY "LEAVE":U TO cur_widg_name.
      IF cur_widg_text:SENSITIVE AND INPUT cur_widg_text NE display_text THEN
        APPLY "LEAVE":U TO cur_widg_text.
      IF error_on_leave THEN RETURN.
    END.

    FIND b_U WHERE b_U._HANDLE = _h_cur_widg AND b_U._STATUS <> "DELETED"
            NO-ERROR.
    IF AVAILABLE b_U AND _next_draw EQ ? THEN DO:
      /* Menus don't have _L's */
      FIND _L WHERE RECID(_L) = b_U._lo-recid NO-ERROR.
      /* Move FOCUS to the current widget, if possible. This is because Motif
         sometimes gets lost (and sometimes shows a large focus border.
         Regardless, always make sure FOCUS is set (otherwise the ON ANYWHERE
         triggers will not work.  NOTE that we don't apply entry to the
         current widget because this will highlight it in certain cases
         (eg. if it is a COMBO-BOX or FILL-IN).  */
      &IF "{&WINDOW-SYSTEM}" eq "OSF/Motif"
      &THEN IF FOCUS NE _h_cur_widg THEN APPLY "ENTRY":U TO _h_win.
      &ELSE IF FOCUS EQ ? THEN APPLY "ENTRY":U TO _h_win.
      &ENDIF
      /* Show it selected */
      IF CAN-SET(_h_cur_widg,"SELECTED":U) AND b_U._TYPE NE "DIALOG-BOX":U
      THEN ASSIGN b_U._SELECTEDib       = YES
                  _h_cur_widg:SELECTED = YES.

      /* Edit the name (except for text widgets which will be literals)   */
      /* and db fields where we shouldn't allow name changes.             */
      /* The trigger button is disabled for widgets that don't have names */
      ASSIGN cur_widg_name            = IF (b_U._TABLE = ?) THEN b_U._NAME
                                        ELSE b_U._NAME + " (" +  b_U._TABLE + ")"
             cur_widg_name:SENSITIVE  = (b_U._TYPE <> "TEXT") AND
                                           (b_U._TABLE = ?).
      IF b_U._TABLE NE ? THEN DO:
        FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._DISPOSITION EQ "LIKE" THEN
          ASSIGN cur_widg_name = b_U._NAME.
      END.  /* If there is a table name */

      /* Label, etc. is only edittable in Master Layout. */
      l_master = b_U._LAYOUT-NAME EQ "{&Master-Layout}".
      IF NOT l_master THEN DO:
        /* We will allow label of fields of dynamic viewers to be sensitive */
        IF NOT AVAILABLE _P THEN
          FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

        IF AVAILABLE _P AND _DynamicsIsRunning THEN l_DynLabel = (LOOKUP(_P.OBJECT_type_code,
                        DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynView":U)) <> 0).
      END.

      /* What is it? Is it text (then show value). Does it have a label?   */
      /* then show it (NOTE: TEXT has a LABEL but the UIB doesn't use it). */
      /* Show TITLE for frames/windows                                     */
      /* Show name for html objects and don't check their widget type */
      IF CAN-FIND (_HTM WHERE _HTM._U-recid = RECID(b_U)) THEN DO:
        FIND _HTM WHERE _HTM._U-recid = RECID(b_U).
        ASSIGN cur_widg_text:SENSITIVE    = FALSE
               cur_widg_text              = _htm._HTM-NAME.
        IF cur_widg_text:LABEL <> "Name":R7 THEN
          ASSIGN cur_widg_text:LABEL = "Name":R7.
      END.  /* If an HTML object */
      ELSE IF CAN-DO("EDITOR,IMAGE,MENU,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,{&WT-CONTROL}",
                b_U._TYPE) THEN DO:
        IF b_U._TYPE <> "{&WT-CONTROL}" THEN DO:
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = "":U.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.  /* If not an OCX */
        ELSE DO: /* Must be one of Ed, Img, Menu, RS, Rect, Sel-L or Slider */
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = b_U._OCX-NAME.
          IF cur_widg_text:LABEL <> "OCX":R7 THEN
            ASSIGN cur_widg_text:LABEL = "OCX":R7.
        END.  /* Must be one of the list above */
      END.  /* If can-do a bunch */
      ELSE DO:  /* Else something else */
        IF b_U._TYPE = "TEXT" THEN DO:
          FIND _F WHERE RECID(_F)  = b_U._x-recid.
          ASSIGN cur_widg_text           = _F._INITIAL-DATA
                 cur_widg_text:SENSITIVE = l_master.
          IF cur_widg_text:LABEL <> "Text":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Text":R7.
        END.  /* If text */
        ELSE IF b_U._TYPE = "SmartObject" THEN DO:
          FIND _S WHERE RECID(_S)  = b_U._x-recid.
          ASSIGN cur_widg_text           = _S._FILE-NAME
                 cur_widg_text:SENSITIVE = NO.
          IF cur_widg_text:LABEL <> "Master":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Master":R7.
        END.  /* If SmartObject */
        ELSE IF b_U._TYPE EQ "WINDOW" THEN DO:
          /* Don't show the Window if it is not allowed */
          IF b_U._SUBTYPE NE "Design-Window":U THEN DO:
            FIND _C WHERE RECID(_C) = b_U._x-recid.
            ASSIGN cur_widg_text        = IF b_U._LABEL NE ?
                                          THEN b_U._LABEL ELSE "".
            IF cur_widg_text:LABEL <> "Title":R7
            THEN cur_widg_text:LABEL = "Title":R7.
            cur_widg_text:SENSITIVE = l_master.
          END.
          ELSE DO:
            /* Don't show the true name */
            FIND _P WHERE _P._u-recid EQ RECID(b_U).
            ASSIGN cur_widg_text = IF _P._SAVE-AS-FILE EQ ? THEN "Untitled"
                                   ELSE _P._SAVE-AS-FILE
                   cur_widg_name = _P._TYPE
                   cur_widg_text:SENSITIVE = NO
                   cur_widg_name:SENSITIVE = NO.
            IF cur_widg_text:LABEL <> "File":R7 THEN
              ASSIGN cur_widg_text:LABEL = "File":R7.
          END.
        END.  /* If Window */
        ELSE IF CAN-DO("BROWSE,DIALOG-BOX,FRAME":U, b_U._TYPE) THEN DO:
          FIND _C WHERE RECID(_C) = b_U._x-recid.
          ASSIGN cur_widg_text        = IF b_U._LABEL NE ?
                                        THEN b_U._LABEL ELSE "".
          IF cur_widg_text:LABEL <> "Title":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Title":R7.

          /* Browses and frames with no-box can't change title */
          IF CAN-DO("BROWSE,FRAME":U, b_U._TYPE)
             AND (_L._NO-BOX OR _C._TITLE EQ NO)
          THEN ASSIGN cur_widg_text:SENSITIVE = NO
                      cur_widg_text           = "<No Title>".
          ELSE cur_widg_text:SENSITIVE = l_master.
        END.  /* If Browse, Dialog or Frame */
        ELSE IF CAN-SET(b_U._HANDLE, "LABEL") THEN DO:
          ASSIGN cur_widg_text           = (IF b_U._LABEL-SOURCE EQ "D"
                                            THEN "?" ELSE b_U._LABEL)
                 cur_widg_text:SENSITIVE = l_master OR l_DynLabel.
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
    END.  /* If AVAIL b_U AND next_draw eq ? */

    /* No current widget -- blank everything out.  (Or show multiple
       selections.)*/
    ELSE ASSIGN cur_widg_name           = "":U
                cur_widg_text           = "":U
                cur_widg_text:SENSITIVE = NO
                cur_widg_name:SENSITIVE = NO
                /* This is a safety net incase CURRENT-WINDOW is ever reset */
                CURRENT-WINDOW          = _h_menu_win.
    
    /* To avoid unnecessary flashing only display things that changed */
    ASSIGN cs-char = cur_widg_name.
    IF cs-char NE INPUT cur_widg_name THEN
      DISPLAY cur_widg_name.
    /* Now redisplay the text field to get around a 4GL bug that was
       eating all the "&" characters when I set the SCREEN-VALUE. */
    ASSIGN cs-char = cur_widg_text.
    IF cs-char NE INPUT cur_widg_text THEN
      DISPLAY cur_widg_text.
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
    IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME EQ "{&AttrEd}" THEN 
      RUN show-attributes IN hAttrEd NO-ERROR.
    /* Show the current values in the dynamic attribute window */
    IF VALID-HANDLE(_h_menubar_proc) THEN
      RUN Display_PropSheet IN _h_menubar_proc (YES) NO-ERROR.
    /* Show OCX Property Editor Window. Don't do this if the user is changing
       the Name attribute in the Prop Ed. We don't need to refresh the Prop Ed
       window at that point. */
    IF NOT PROGRAM-NAME(2) BEGINS "DesignFrame.ControlNameChanged":U THEN
      RUN show_control_properties (0).
  END. /* If not mouse-select-down. */
END PROCEDURE. /* display_current */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display_curwin Include 
PROCEDURE display_curwin :
/*------------------------------------------------------------------------------
  Purpose: when the current window changes, then hide or show information 
           relevant to it     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h_true_win     AS HANDLE      NO-UNDO.
  DEFINE VAR new-visual-obj AS LOGICAL     NO-UNDO.
  DEFINE VAR new-mode       AS CHARACTER   NO-UNDO.

  /* If the current window has not changed then do nothing */
  IF _h_win NE h_display_win THEN DO:
    IF VALID-HANDLE(_h_win) THEN FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win NO-ERROR.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display_page_number Include 
PROCEDURE display_page_number :
/*------------------------------------------------------------------------------
  Purpose: show the current page number in the UIB's status line.
          If the page number is long, then show it as "p. 123", if it is very
          long, then just show it.  Remove commas from really big numbers.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF VAR cPage AS CHAR NO-UNDO.
  IF _P._page-current EQ ? THEN cPage = "All Pages".
  ELSE DO:
    cPage = LEFT-TRIM(STRING(_P._page-current, ">,>>>,>>9":U)).
    IF LENGTH (cPage, "CHARACTER") <= 1 THEN cPage = "Page " + cPage.
    ELSE IF LENGTH (cPage, "CHARACTER") <=3 THEN cPage = "p. " + cPage.
    ELSE IF LENGTH (cPage, "CHARACTER") < 6 THEN cPage = REPLACE(cPage,",":U,"":U).
  END.
  /* Show the new value. */
  RUN adecomm/_statdsp.p  (_h_status_line, {&STAT-Page}, cPage).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disp_help Include 
PROCEDURE disp_help :
/*------------------------------------------------------------------------------
  Purpose: Dispatches help for the current widget.  This means that it calls 
           help with the context-id set to the property sheet help of the 
           widget type      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
END PROCEDURE. /* disp_help */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE double-click Include 
PROCEDURE double-click :
/*------------------------------------------------------------------------------
  Purpose: called by persistent triggers on UIB objects  
           It calls the standard MOUSE-SELECT-DBLCLICK action.      
  Parameters:  <none>
  Notes:   
------------------------------------------------------------------------------*/
  /* For everything but a OCX control, run the property sheet or section
     editor (depending on _dblclick_section_ed). IF a control, then use
     OCX property editor                                                   */

  FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.

  IF NOT AVAILABLE _U AND SELF NE _h_cur_widg THEN DO:
    ASSIGN _h_cur_widg = SELF.
    FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  END.

  IF NOT AVAILABLE _U THEN RETURN.

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
    IF _dblclick_section_ed THEN DO:
      /* Find _P of _h_cur_widg and if it is dynamic don't bring up the editor */
      FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
      IF AVAILABLE _P AND NOT _P.static_object THEN DO:
        /* A dynamic object, don't open the section editor */
        MESSAGE "The Section Editor is not used for dynamic objects."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      END.  /* If a dynamic object */
      ELSE RUN choose_codedit.
    END. /* If dection editor */
    ELSE RUN property_sheet (?).
  END. /* DO for a normal progress widget */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE drawobj Include 
PROCEDURE drawobj :
/*------------------------------------------------------------------------------
  Purpose: drawobj is a procedure to figure out what widget is to be drawn 
           in a frame    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE fproc      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lValid     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRowObj    AS LOGICAL   NO-UNDO INIT TRUE.

  &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("drawobj"). &ENDIF

  IF _next_draw NE ? THEN DO:
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
          /* First make sure that _P is a SmartViewer or simple SmartObject. IZ 1611 */
          IF NOT CAN-DO("SmartDataViewer,SmartObject":U, _P._TYPE) THEN DO:
            BELL.
            RETURN.
          END.

          /* Find the field to replace */
          ASSIGN hField = _h_win:FIRST-CHILD  /* The frame       */
                 hField = hField:FIRST-CHILD  /* The field group */
                 hField = hField:FIRST-CHILD. /* The first field */
          SEARCH-BLOCK:
          REPEAT WHILE hField NE ?:
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
                   IF _U._CLASS-NAME = "DataField" THEN lRowObj = YES.
                   ELSE IF _U._BUFFER = "RowObject" THEN lRowObj = YES.
                   ELSE DO:
                     FIND FIRST _TT WHERE _TT._P-RECID = RECID(_P)
                                      AND _TT._NAME    = _U._TABLE NO-LOCK NO-ERROR.
                     IF AVAILABLE _TT THEN
                        ASSIGN lRowObj = (_TT._TABLE-TYPE = "D":U).
                     ELSE IF _U._BUFFER = "RowObject" THEN lRowObj = YES.
                     ELSE /* This should not happen. If it does, its not a valid field. */
                        ASSIGN lRowObj = NO.
                   END.
                 END. /* IF Temp-Table THEN */

                 /* User did click in a Data Source field. */
                 IF lRowObj OR (_U._TYPE = "FILL-IN":U AND _U._dbName = ? AND _U._TABLE = ?)
                 THEN DO:
                   /* A field was clicked into and it is a Data Source
                     (RowObject or SBO) field or a local field. IZ 1611 */
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
          {adeuib/sookver.i _object_draw canDraw YES}
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
        ASSIGN _h_button_bar[9]:SENSITIVE = FALSE
               mi_color:SENSITIVE         = FALSE.
      ELSE
        ASSIGN _h_button_bar[9]:SENSITIVE = TRUE
               mi_color:SENSITIVE         = TRUE.
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
END PROCEDURE.  /* drawobj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE drawobj-in-box Include 
PROCEDURE drawobj-in-box :
/*------------------------------------------------------------------------------
  Purpose: called at the end of a box-select and it computes the second-corner 
           of a draw before calling draw-obj.
  Parameters:  <none>
  Notes:    Can be called from a WINDOW or a FRAME.      
------------------------------------------------------------------------------*/
 &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("draw..in-box"). &ENDIF
  DEFINE VAR itemp AS   INTEGER                                  NO-UNDO.
  DEFINE VARIABLE hOldFrame AS HANDLE NO-UNDO.
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
        ASSIGN hOldFrame = _h_frame
               _h_frame = SELF.
        RUN drawobj.
        ASSIGN _h_frame = hOldFrame.
END PROCEDURE.  /* drawobj-in-box */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE drawobj-or-select Include 
PROCEDURE drawobj-or-select :
/*------------------------------------------------------------------------------
  Purpose: called when we want to either select the frame draw   
           draw a default widget (depending on what _next_draw is).  
  Parameters:  <none>
  Notes:    we do not draw widgets if we are on the border          
------------------------------------------------------------------------------*/
DEFINE VARIABLE hOldFrame AS HANDLE NO-UNDO.
  &IF {&dbgmsg_lvl} > 0
      &THEN RUN msg_watch("draw..or-select" + _next_draw). &ENDIF
  /* Draw an object -- let progress select the frame but we need to
    "select" the dialog-box because it is not selectable. */
  FIND _U WHERE _U._HANDLE = SELF.

  IF _next_draw EQ ? THEN DO:
    /* Select the dialog-box and deselect all other widgets. */
    IF _U._TYPE EQ "DIALOG-BOX" THEN RUN changewidg (SELF, YES).
  END.
  ELSE DO:
    /* Note that we cannot draw frames in dialog-boxes, and the only
       thing we can draw on frame borders is another frame.   */
    IF LAST-EVENT:ON-FRAME-BORDER THEN RETURN.
    ELSE DO:
        ASSIGN hOldFrame = _h_frame
               _h_frame = SELF.
        RUN drawobj.
        ASSIGN _h_frame = hOldFrame.
    END.
  END.
END PROCEDURE. /* drawobj-or-select */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

