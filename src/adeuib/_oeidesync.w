&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME h_sewin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS h_sewin 
/*************************************************************/
/* Copyright (c) 1984-2015 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adeuib/_oeidesync.w

  Description: Program that connects the AppBuilder to the OpenEdge IDE.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: egarcia

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL "IDE_EDITOR_POOL" PERSISTENT NO-ERROR.
DEFINE NEW GLOBAL SHARED VARIABLE _comp_temp_file AS CHARACTER  NO-UNDO.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE OEIDE_ABSecEd   AS HANDLE NO-UNDO.
DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.

{adecomm/oeideservice.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/triggers.i}
{adeuib/links.i}
{adeuib/uibhlp.i}
{adeuib/advice.i}
{adeuib/brwscols.i}  

/* get overrides may call web object - tagmap is required not sure of the others */
{ src/web/method/cgidefs.i  NEW } /* standard WS cgidefs.i: functions,vars */
{ src/web/method/cgiarray.i NEW } /* standard WS cgiarray.i: vars          */ 
{ src/web/method/tagmap.i   NEW } /* standard WS tagmap.i: TT tagmap       */
{ src/web/method/webutils.i NEW }

/* Common - routine to check whether a links are valid */
{adeuib/_chkrlnk.i}

DEFINE BUFFER b_P FOR _P.
DEFINE BUFFER _SEW_U   FOR _U.
DEFINE BUFFER _SEW_F   FOR _F.
DEFINE BUFFER _SEW_TRG FOR _TRG.
DEFINE BUFFER x_U      FOR _U.
DEFINE BUFFER x_S      FOR _S.

DEFINE VAR Type_Local       AS CHARACTER INIT "_LOCAL"              NO-UNDO.
DEFINE VAR Type_Trigger     AS CHARACTER INIT "_CONTROL"            NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "_PROCEDURE"          NO-UNDO.
DEFINE VAR Type_Function    AS CHARACTER INIT "_FUNCTION"           NO-UNDO.
DEFINE VAR editted_event    AS CHARACTER                            NO-UNDO.

DEFINE VAR Adm_Create_Obj       AS CHARACTER INIT "adm-create-objects"  NO-UNDO.
DEFINE VAR Type_Adm_Create_Obj  AS CHARACTER INIT "_ADM-CREATE-OBJECTS" NO-UNDO.
DEFINE VAR Adm_Row_Avail        AS CHARACTER INIT "adm-row-available"   NO-UNDO.
DEFINE VAR Type_Adm_Row_Avail   AS CHARACTER INIT "_ADM-ROW-AVAILABLE"  NO-UNDO.


DEFINE VAR Type_Def_Enable      AS CHARACTER INIT "_DEFAULT-ENABLE"     NO-UNDO.
DEFINE VAR Type_Def_Disable     AS CHARACTER INIT "_DEFAULT-DISABLE"    NO-UNDO.

DEFINE VAR Send_Records         AS CHARACTER INIT "send-records"        NO-UNDO.
DEFINE VAR Type_Send_Records    AS CHARACTER INIT "_ADM-SEND-RECORDS"   NO-UNDO.

DEFINE VARIABLE g_dABModDateTime    AS DATETIME   NO-UNDO.
DEFINE VAR Enable_UI            AS CHARACTER INIT "enable_UI"           NO-UNDO.
DEFINE VAR Disable_UI           AS CHARACTER INIT "disable_UI"          NO-UNDO.

DEFINE VARIABLE g_dtIDEModDateTime  AS DATETIME   NO-UNDO.


/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR h_sewin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Test" 
     SIZE 15 BY 1.1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BUTTON-1 AT ROW 1.24 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 29.6 BY 3.43.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW h_sewin ASSIGN
         HIDDEN             = YES
         TITLE              = "Section Editor"
         HEIGHT             = 3.43
         WIDTH              = 29.6
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 174
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 174
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW h_sewin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(h_sewin)
THEN h_sewin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME h_sewin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON END-ERROR OF h_sewin /* Section Editor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL h_sewin h_sewin
ON WINDOW-CLOSE OF h_sewin /* Section Editor */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK h_sewin 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
/*    
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
*/       

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
/*
ON CLOSE OF THIS-PROCEDURE 
   RUN SEClose ( INPUT "SE_EXIT":u ).
*/   
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProc):
      IF hProc:PRIVATE-DATA = "adeuib/synserver.p":U THEN
          LEAVE.
      hProc = hProc:NEXT-SIBLING.
  END.

  OEIDE_ABSecEd = THIS-PROCEDURE:HANDLE.
  RUN initializeEditor.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

{ adeuib/seprocs2.i }
/* To make _oeidesync.w work as a proxy of _semain.w use: 
   RUN adeuib/_semain.w PERSISTENT SET hProc. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI h_sewin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(h_sewin)
  THEN DELETE WIDGET h_sewin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI h_sewin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  RETURN.
/*  ENABLE BUTTON-1                                */
/*      WITH FRAME DEFAULT-FRAME IN WINDOW h_sewin.*/
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeEditor h_sewin 
PROCEDURE initializeEditor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 
&IF DEFINED(EXCLUDE-saveABUntitled) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveABUntitled h_sewin 
PROCEDURE saveABUntitled:
    DEFINE INPUT  PARAMETER pcSaveAsfile AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCancel AS LOGICAL NO-UNDO.
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    DEFINE VARIABLE cancel AS LOGICAL NO-UNDO.
 
    IF _h_win = ? THEN  RUN report-no-win.
    ELSE DO:
       FIND _U WHERE _U._HANDLE = _h_win. 
       FIND _P WHERE _P._u-recid eq RECID(_U).       
      _P._save-as-file = pcSaveAsFile.
          /* SEW call to store current trigger code for specific window. */
       RUN call_sew in _h_uib("SE_STORE_WIN":U).
       run changewidg in _h_uib (_h_win, no) . 
       RUN setAppBuilder_UBuffer IN _h_uib (RECID(_U)).
       RUN save_window in _h_uib(NO, OUTPUT pcCancel).
    END.
    
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-syncFromIDE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncFromAB h_sewin 

PROCEDURE syncFromAB :
/*------------------------------------------------------------------------------
  Purpose:     Write .w file to linked file if file is out of sync.
  Parameters:  pcLinkedFile - Full path name to the linked file.
  Notes:       Deprecated 
               This procedure is called from the OEIDE Editor when it gets focus,
               specifically, it is called from sanityCheckState.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hWindow        AS HANDLE     NO-UNDO.
    RUN getWindowOfFile IN hOEIDEService (pcLinkedFile, OUTPUT hWindow).
    run syncFromAppbuilder(hWindow,pcLinkedFile) .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-syncFromIDE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncFromAB h_sewin 

PROCEDURE syncFromAppbuilder :
/*------------------------------------------------------------------------------
  Purpose:     Write .w file to linked file if file is out of sync.
  Parameters:  pcLinkedFile - Full path name to the linked file.
  Notes:       This procedure is called from the OEIDE Editor when it gets focus,
               specifically, it is called from sanityCheckState.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER    NO-UNDO.

DEFINE VARIABLE orig_temp_file AS CHARACTER  NO-UNDO.
DEFINE VARIABLE orig_save_file AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dtSyncTime     AS DATETIME   NO-UNDO.

DEFINE VARIABLE hWin           AS WIDGET     NO-UNDO.
DEFINE VARIABLE hCurWidg       AS WIDGET     NO-UNDO.
/*
RUN getSyncTimeStamp IN hOEIDEService (pcLinkedFile, OUTPUT dtSyncTime).
IF dtSyncTime <> ? THEN RETURN.
*/
FIND b_P WHERE b_P._WINDOW-HANDLE = phWindow NO-ERROR.
if not avail b_P then
do:
    if phWindow:type = "WINDOW":U then
         phWindow = phWindow:first-child.
    FIND b_P WHERE b_P._WINDOW-HANDLE = phWindow NO-ERROR.   
end.
IF NOT AVAILABLE b_P THEN RETURN.
/* Save value of _h_win */       
ASSIGN hWin     = _h_win
       hCurWidg = _h_cur_widg
       _h_win = phWindow
   /* Gen4GL code */
       orig_temp_file  = _comp_temp_file
       _comp_temp_file = pcLinkedFile
       orig_save_file  = _save_file
       _save_file = b_P._save-as-file.
                     
RUN adecomm/_setcurs.p ("WAIT":U).
RUN adeshar/_gen4gl.p ("PRINT":U).
RUN setstatus IN _h_uib ("":U, "":U).
ASSIGN _comp_temp_file = orig_temp_file
       _save_file      = orig_save_file.

/* Restore value of _h_win */
IF _h_win <> hWin THEN
DO:
    IF NOT VALID-HANDLE(hCurWidg) THEN
       ASSIGN hCurWidg = hWin.
    ASSIGN _h_win = hWin.
    RUN changewidg IN _h_uib (hCurWidg, FALSE).           
END.
/*
FILE-INFO:FILE-NAME = pcLinkedFile.
RUN setSyncTimeStamp IN hOEIDEService
    (pcLinkedFile, DATETIME(FILE-INFO:FILE-MOD-DATE, FILE-INFO:FILE-MOD-TIME)).
*/    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-syncFromIDE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncFromIDE h_sewin 

PROCEDURE syncFromIDE :
/*------------------------------------------------------------------------------
  Purpose:     Synchronize AppBuilder with OEIDE using linked file.
  Parameters:  pcLinkedFile - Full path name to the linked file.
  Notes:       This procedure is called from the OEIDE Editor when losing focus.
               Content of .w file is read only if it is out of sync.
------------------------------------------------------------------------------*/
define input  parameter phOldWindow as handle no-undo.
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER    NO-UNDO.

DEFINE VARIABLE hNewWindow   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWidgetName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lMRUFileList AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ocxFileName AS CHARACTER NO-UNDO.
define variable hFrame      as handle no-undo.
DEFINE BUFFER buf_P FOR _P.

    IF pcLinkedFile = ? OR pcLinkedFile = "" THEN RETURN.
    
    FILE-INFO:FILE-NAME = pcLinkedFile.
    IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN. /* Linked file does not exist */
    
    FIND buf_P WHERE buf_P._WINDOW-HANDLE = phOldWindow EXCLUSIVE-LOCK NO-ERROR.
    if not avail buf_P then
    do:
         if phOldWindow:type = "WINDOW":U then
             hFrame = phOldWindow:first-child.
         FIND buf_P WHERE buf_P._WINDOW-HANDLE = hFrame EXCLUSIVE-LOCK NO-ERROR.
    end.
    IF NOT AVAILABLE buf_P THEN RETURN.
    cFileName = buf_P._save-as-file.
 
    IF cFileName = ? OR cFileName = "" THEN RETURN.

    RUN setstatus IN _h_uib ("WAIT":U, "":U).

    /** TODO - TEST - Test widget selection code with multiple windows */    
    IF VALID-HANDLE(_h_cur_widg) THEN
    DO:
        FIND _SEW_U WHERE _SEW_U._HANDLE = _h_cur_widg NO-ERROR.
        IF AVAILABLE _SEW_U AND _SEW_U._WINDOW-HANDLE = phOldWindow THEN
            cWidgetName = _SEW_U._NAME.        
    END.    
    /* buf_P._save-as-file pclinkedFile */
    /* Read 4GL code */
    ASSIGN lMRUFileList  = _mru_filelist
           _mru_filelist = NO.
           
    /* Save in-memory OCX properties to a temporary OCX file at the location of the linked file. */
    RUN saveOCXFile(phOldWindow, pcLinkedFile).       
    /* Load .w file. Use OCX properties from temporary location if file is available. */
    RUN adeuib/_qssuckr.p (pcLinkedFile, "", "Synch-Silent":U, FALSE).

    /* Delete temporary OCX file */
    ocxFileName = substr(pcLinkedFile, 1, r-index(pcLinkedFile, ".":u) - 1) + ".wrx".
    OS-DELETE VALUE(ocxFileName).

    ASSIGN _mru_filelist = lMRUFileList
           hNewWindow    = _h_win.
    
    IF VALID-HANDLE(hNewWindow) THEN
    DO:
        FIND b_P WHERE b_P._WINDOW-HANDLE = hNewWindow EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b_P THEN RETURN.
        ASSIGN b_P._save-as-file     = cFileName
               b_P._file-saved       = FALSE                /* File was modified in IDE */
               b_P._hSecEd           = OEIDE_ABSecEd.
               
        FIND _SEW_U WHERE _SEW_U._HANDLE = hNewWindow NO-LOCK NO-ERROR.
        IF hNewWindow:TYPE = "FRAME":U THEN
            hNewWindow = hNewWindow:PARENT.
        IF AVAILABLE _SEW_U THEN
            RUN adeuib/_wintitl.p (hNewWindow, _SEW_U._LABEL, ? , cFileName).
        /* reOpen exists only in the ide subclass version _treeview.p
           so no-error is perhaps questionable  */
        if valid-handle(b_P._tv-proc) then 
             run reopened in b_P._tv-proc no-error.
        
        /* View new window */           
        hNewWindow:VISIBLE = TRUE.
    END.    
                     
    IF VALID-HANDLE(phOldWindow) THEN
    DO:
        buf_P._file-saved = TRUE. /* Prevents a save prompt when closing the window */    
        phOldWindow:PRIVATE-DATA = "_RELOAD". /* Reload mode avoids the closing of the editor in the IDE */    
        RUN wind-close IN _h_uib (phOldWindow) NO-ERROR.
    END.    
    RUN WinMenuRebuild IN _h_uib NO-ERROR.
    IF cWidgetName > "" THEN
    DO:
        FIND _SEW_U WHERE _SEW_U._WINDOW-HANDLE = hNewWindow 
                  AND _SEW_U._NAME          = cWidgetName NO-ERROR.
        IF AVAILABLE _SEW_U THEN
            RUN changewidg IN _h_uib (_SEW_U._HANDLE, TRUE).
    END.    
    RUN setstatus IN _h_uib ("":U, "":U).
    
    /* Sets _U buffer to point to the current window after syncFromIDE */
    FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
    IF AVAILABLE _U THEN
        RUN setAppBuilder_UBuffer IN _h_uib (RECID(_U)).
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshSmartObjects h_sewin 
PROCEDURE refreshSmartObjects :
/*------------------------------------------------------------------------------
  Purpose:     Refresh SmartObjects containing instances of the object specified.
  Parameters:  pcFileName - Full path name to an updated SmartObject.
  Notes:       This procedure is called from the OEIDE Editor when a .w 
               file is saved.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFileName AS CHARACTER    NO-UNDO.

DEFINE VARIABLE can_run      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lOk          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE file_name    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE comp_file    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE compile-into AS CHARACTER    NO-UNDO.
DEFINE VARIABLE admVersion   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTemp        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTemp2       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTemp3       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTempError   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE choice       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE never-again  AS LOGICAL      NO-UNDO.

  can_run = TRUE.
  
  /* Ensure r-code of file is up to date. */
  COMPILE VALUE(pcFileName) NO-ERROR.

  /* Save the file we compiled into. */
  RUN get-comp-file (pcFileName, compile-into, OUTPUT comp_file).  

  /* If we saved a SmartObject, then recreate all the objects that this file
     points to. [Note: we need to test with FILE-INFO because the pathnames may
     be stored differently. */
  IF can_run
  THEN DO:     
    /* Get the complete file name for the saved file. */
    ASSIGN
      FILE-INFO:FILE-NAME = pcFileName
      file_name           = FILE-INFO:FULL-PATHNAME
      .
    /* Preselect here because "_recreat.p" is going to create a new _U._HANDLE
       which would change the default ordering in a FOR EACH _U... */
    RECREATE-BLOCK:
    REPEAT PRESELECT EACH _U WHERE _U._TYPE   EQ "SmartObject"
                             AND   _U._STATUS NE "DELETED":U:
      FIND NEXT _U.
      FIND _S WHERE RECID(_S) EQ _U._x-recid.
      FILE-INFO:FILE-NAME = _S._FILE-NAME.
      /* Is the smartObject an instance of either the source file or the compiled file? */
      IF FILE-INFO:FULL-PATHNAME EQ file_name OR 
         (comp_file NE ? AND FILE-INFO:FULL-PATHNAME EQ comp_file) THEN DO:
        /* Before we recreate the object, check the flag.  Note that this code
           will happen only on the 2nd SmartObject found.  Tell the user that
           we are going to stop recreating instances of the file. */
        IF NOT can_run THEN DO:
          MESSAGE pcFileName SKIP
                  "The SmartObject was saved. However, it does not" {&SKP}
                  "run successfully."   SKIP (1)
                  "Additional instances of this" _P._TYPE "will not" {&SKP}
                  "be recreated using the new master file until the" {&SKP}
                  "errors have been fixed."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.            
          /* Stop recreating objects */
          LEAVE RECREATE-BLOCK.
        END.
        RUN adeuib/_recreat.p (RECID(_U)).
        /* If the SmartObject did not recreate successfully, set the flag so
           we won't try to use it again. */
        IF NOT _S._valid-object THEN can_run = no.
        /* Check all the _admlimks and determine if there are still valid */
        ELSE 
        DO:
           /** ************************************
            ** DELETE _admlinks if corresponding _U's signature do not match 
            **/
           /* Determine if queryObject
            * Determine if datalink
            * Determine if signature check required 
            */
           {adeuib/admver.i _S._HANDLE admVersion}
           IF admVersion >= "ADM2":U THEN
           DO:
              ASSIGN lOK = YES
                     cTemp2 = "The SmartObject " + _U._NAME + " was saved."
                              + " However, the following links no longer have a matching signature."
                              + CHR(10).
              .
              LOOPLINKS:
              FOR EACH _admlinks WHERE 
                       (CAN-DO("Data,Update,Filter":U,_admlinks._link-type))
           AND  (INTEGER(_admlinks._link-source) = INTEGER(RECID(_U))
                        OR INTEGER(_admlinks._link-dest) = INTEGER(RECID(_U))) :
                 IF INTEGER(_admlinks._link-dest) = INTEGER(RECID(_U)) THEN
                 DO:
                    FIND x_U WHERE INTEGER(RECID(x_U)) = 
                        INTEGER(_admlinks._link-source) NO-ERROR.

                    /* Pass thru links rely on a link to the _P record rather than _X. There is no
                       point checking the signature with passthrus as they won't match anyway. 
                       I put this code in here to fix 20000404-013. - BSG */
                    IF NOT AVAILABLE(x_U) AND 
                      CAN-FIND(_P WHERE RECID(_P) = INTEGER(_admlinks._link-source)) THEN
                      NEXT LOOPLINKS.

                    ASSIGN cTemp = "from " + x_U._NAME + " to " + _U._NAME
                           cTemp3 = x_U._NAME + " -> " + CAPS(_admlinks._link-type) + " -> " + _U._NAME.
                 END.
                 ELSE
                 DO:
                    FIND x_U WHERE INTEGER(RECID(x_U)) = 
                        INTEGER(_admlinks._link-dest) NO-ERROR.

                    /* Pass thru links rely on a link to the _P record rather than _X. There is no
                       point checking the signature with passthrus as they won't match anyway. 
                       I put this code in here to fix 20000404-013. - BSG */
                    IF NOT AVAILABLE(x_U) AND 
                      CAN-FIND(_P WHERE RECID(_P) = INTEGER(_admlinks._link-dest)) THEN
                      NEXT LOOPLINKS.

                    ASSIGN cTemp = "from " + _U._NAME + " to " + x_U._NAME
                           cTemp3 = _U._NAME + " -> " + CAPS(_admlinks._link-type) + " -> " + x_U._NAME.
                 END.
                 FIND x_S WHERE RECID(x_S) = x_U._x-recid.

                 RUN ok-sig-match (INPUT _S._HANDLE,
                                   INPUT x_S._HANDLE,
                                   INPUT _admlinks._link-type,
                                   INPUT NO,
                                   OUTPUT lOK,
                                   OUTPUT cTempError).
                 IF NOT lOK THEN DO:
                     cTemp2 = cTemp2 + cTemp3 + CHR(10).
                 END. /* Not OK */
              END. /* Each _admlinks */
              IF NOT lOK THEN
              DO:
                     RUN adeuib/_advisor.w (
                     /* Text        */ INPUT cTemp2,
                     /* Options     */ INPUT "",
                     /* Toggle Box  */ INPUT TRUE,
                     /* Help Tool   */ INPUT "uib":U,
                     /* Context     */ INPUT {&Advisor_Link_Conflict},
                     /* Choice      */ INPUT-OUTPUT choice,
                     /* Never Again */ OUTPUT never-again). 
          
                    /* Store the never again value */
                    {&NA-Signature-Mismatch-advslnk} = never-again.
              END.
           END.  /* version ADM2 or greater */
        END.
      END. /* IF..comp_file...*/
    END. /* RECREATE-BLOCK: REPEAT... */
  END. /* IF can_run... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openABFile h_sewin 
procedure saveFileEvent:
    define input parameter phWindow as handle no-undo.
    define variable cContext  as character no-undo.
    define variable cfilename as character no-undo.
    define variable lEventResult as logical no-undo.
    
    find _SEW_U where _SEW_U._HANDLE = phWindow no-error.
    find b_P where b_P._WINDOW-HANDLE = phWindow no-error.
    if available _SEW_U and available b_P then
    do:
        assign cContext = string(recid(_SEW_U))
               cFileName = b_P._SAVE-AS-FILE.
               
        run adecomm/_adeevnt.p
              ("UIB", "SAVE", cContext, cFileName, output lEventResult).
        if b_P._TYPE begins "Smart":U then
        do:
            file-info:file-name = cFileName.
            cFileName = file-info:full-pathname.        
            if cFileName > "" then
                run refreshSmartObjects (cFileName).
        end.
        run saveOCXFile(phWindow, cFileName).
    end.          

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openABFile h_sewin 
PROCEDURE openABUntitled :
/*------------------------------------------------------------------------------
  Purpose:     Open the specified template in the AppBuilder.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFileList AS CHARACTER    NO-UNDO.

DEFINE VARIABLE i         AS INTEGER NO-UNDO.
DEFINE VARIABLE open_file AS CHARACTER NO-UNDO.

IF LENGTH(pcFileList,"CHARACTER":U) > 0 THEN
DO:
    DO i = 1 TO NUM-ENTRIES(pcFileList):
      open_file = ENTRY(i,pcFileList).
      FILE-INFO:FILE-NAME = open_file.
      IF FILE-INFO:FULL-PATHNAME = ? THEN NEXT.
      open_file = FILE-INFO:FULL-PATHNAME.
      FIND FIRST b_P WHERE b_P._save-as-file = open_file NO-LOCK NO-ERROR.
      IF AVAILABLE b_P THEN NEXT.
      open_file = REPLACE(open_file, "~\", "/").
       RUN adeuib/_open-w.p (open_file, "", "UNTITLED":U).
    END.                      
END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendABFileAction h_sewin 
PROCEDURE sendABFileEvent :
/*------------------------------------------------------------------------------
  Purpose:     Perform actions for events associated with the specified file.
  Parameters:  
  Notes:       Deprecated - not used by integrated appbuilder or oe text editor .
               saveFileEvent is called directly
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCmd AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cEvent      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkedFile AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.

DEFINE VARIABLE cContext     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEventResult AS LOGICAL    NO-UNDO.

IF NUM-ENTRIES(pcCmd, " ") < 2 THEN RETURN.

ASSIGN
    pcCmd       = pcCmd + " "
    cLinkedFile = TRIM(SUBSTRING(pcCmd,INDEX(pcCmd,' ') + 1))
    cEvent      = TRIM(ENTRY(1,pcCmd,' ')).

CASE cEvent:
    WHEN "SAVE":U THEN DO:
        RUN getWindowOfFile IN hOEIDEService (cLinkedFile, OUTPUT hWindow).
        run saveFileEvent(hWindow) .
    END. /* SAVE event */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveOCXFile h_sewin 
PROCEDURE saveOCXFile :
/*------------------------------------------------------------------------------
  Purpose:     Saves the OCX file for the specified window.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow   AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER pcFileName AS CHARACTER    NO-UNDO.

IF phWindow = ? OR pcFileName = ? OR pcFileName = "" THEN RETURN.

IF NOT CAN-FIND(FIRST x_U WHERE x_U._WINDOW-HANDLE EQ phWindow
                            AND x_U._TYPE          EQ "OCX":U
                            AND x_U._STATUS        EQ "NORMAL":U) THEN RETURN.

DEFINE VARIABLE OCXBinary      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE madeBinary     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE bStatus        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTmp           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE saveBinaryName AS CHARACTER  NO-UNDO.
                
/* Figures out the name of the OCX binary. */
cTmp = _save_file.
_save_file = pcFileName.
RUN adeshar/_contbnm.p (TRUE, phWindow, "SAVE":U, OUTPUT OCXBinary).
_save_file = cTmp.

/* Creates backup copy of binary file. */
FILE-INFO:FILE-NAME = OCXBinary.
IF FILE-INFO:FULL-PATHNAME > "" THEN DO:
   RUN adecomm/_tmpfile.p ("cf", ".sbx", OUTPUT saveBinaryName).
   OS-COPY VALUE(OCXBinary) VALUE(saveBinaryName).
END.    

/* Creates OCX binary file. */
RUN adeshar/_contbin.p (phWindow, "NORMAL":U, "SAVE":U, OCXBinary, OUTPUT madeBinary, OUTPUT bStatus).

/* Checks status. */
IF bStatus <> 0 THEN
    MESSAGE "The OCX binary file could not be created." skip
            "The previous version of the binary file has been" skip
            "saved as" saveBinaryName + ". The " skip
            "binary file and the .w file may be out of synch." skip
            "You should try to save using a new filename."
        VIEW-AS ALERT-BOX ERROR TITLE "Binary File Not Created".
ELSE
    OS-DELETE VALUE(saveBinaryName).
                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE winsave h_sewin 
PROCEDURE winsave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER lipValue AS LOGICAL    NO-UNDO.
 
RUN setEditorModified IN hOEIDEService (phWindow).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-comp-file h_sewin 
PROCEDURE get-comp-file :
/* get-comp-file: starting with a source file and a compile-into directory,
 * Try to get the full pathname of the file that they were compiled into.
 * If the r-code does not exist, return ?. */

  DEFINE INPUT  PARAMETER p_source  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_dir     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_rcode   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cnt               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE file-base         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE file-prfx         AS CHARACTER  NO-UNDO.

  /* Break the file name into its component parts. For example:
     c:\bin.win\gui\test.w => file-prfx "c:\bin.win\gui\", file-base "test.r" */
  RUN adecomm/_osprefx.p (p_source, OUTPUT file-prfx, OUTPUT file-base).

  /* Replace the file extention with "r". */
  cnt = NUM-ENTRIES(file-base, ".").
  CASE cnt:
    WHEN 0 THEN file-base = ?.
    WHEN 1 THEN file-base = file-base + ".r".
    OTHERWISE   ENTRY(cnt, file-base, ".") = "r".
  END CASE.

  /* Is the p_dir (compile) directory a real directory?  If so, parse it,
     Otherwise, use the current directory. */
  IF  p_dir NE ?
  AND p_dir NE "."
  THEN DO:
    /* Is the compile directory a full path, or is it relative to the file 
       prefix?  Check for names that have ":", indicating a DRIVE or names
       that start with / or \.  */
    IF (CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS)
    AND INDEX(p_dir,":":u) > 0) 
    OR  CAN-DO("~\/", SUBSTRING(p_dir, 1, 1, "CHARACTER"))
    THEN file-prfx = p_dir + "/".
    ELSE file-prfx = file-prfx + p_dir + "/".
  END.

  /* Return the full pathname of the compiled file, if it exists. */
  ASSIGN
    FILE-INFO:FILE-NAME = file-prfx + file-base
    p_rcode = FILE-INFO:FULL-PATHNAME
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
