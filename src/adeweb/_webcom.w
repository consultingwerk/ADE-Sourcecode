&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2005-2018 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _webcom.w

  Description: Issues a file command to a WebSpeed agent. Communicates with 
    a WebSpeed agent via a Web server using Crescent CIHTTP control.
      
  Input Parameters:
    p_proc-id    procedure RECID (integer)
    p_brokerURL  host and messenger to reach WebSpeed agent
    p_fileName   relative path of file to open
    p_options    A string indicating what the intent of this call is, e.g.
                 analyze, bestname, checkSection, checkSyntax, compile, open, 
                 offset, procInfo(NOT USED), run, save, saveAs, search.  
                 If procInfo or saveAs, then an additional parameter will be 
                 included, separated by a colon, e.g. compile:okToCompile 
                 or saveAs:okToSave*. (the Objecttype may be added:
                 okToSaveSmartDataObject) 
                 
  Output Parameters:
    p_relName    Relative path of file to open, search or procedure info or
                 CGI info.
    
  Input-Output Parameters:
    p_tempFile:  Local temp file name for reading/writing.  On an "open" this
                 parameter is usually input empty and output with a filename. 
                 On a "save", "saveAs" this parameter is input with a filename 
                 to copy to the web.

  Author:  D.M.Adams
  Created: January 1998
  Changed: 06/01/98 hdaniels Added ANALYZE option and changed logic to use
                             p_tempfile if given on open,analyze etc.  
           06/17/99 tsm      Assigned cErrorText = "ERROR" when the broker is 
                             down so that a file being opened on the MRU 
                             filelist will error appropriately.
           01/24/01 adams    Added CGI environment variables info retrieval
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{ adeuib/sharvars.i } 
{ adeuib/uniwidg.i }
{ adeweb/web_file.i }

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER p_proc-id   AS RECID     NO-UNDO.
DEFINE INPUT        PARAMETER p_brokerURL AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_fileName  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_options   AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER p_relName   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_tempFile  AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cAction       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cBase         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cErrorText    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileExt      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFunction     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHtmlFile     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResultText   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPrefix       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProcInfo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cScrap        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTempFile     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWebServer    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWebTemp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE hProBar       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iBytesSaved   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iFileSize     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSection      AS INTEGER   NO-UNDO.
DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lError        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lEndOfFile    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCancel       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFileClosed   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lScrap        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cClassType    AS CHARACTER INIT ? NO-UNDO.

/* options */
DEFINE VARIABLE lAnalyze      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lBestName     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCGI          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCheckSection AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCheckSyntax  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCompile      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lDelete       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lHostName     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lNoBar        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOffset       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOpen         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lProcInfo     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRun          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSave         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSaveAs       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSearch       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSmartData    AS LOGICAL   NO-UNDO.

DEFINE STREAM webstream.  /* use for reading a file to put to the web. */
DEFINE STREAM instream.
DEFINE STREAM outstream.

&SCOPED-DEFINE debug FALSE
&SCOPED-DEFINE EOL CHR(10)

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD url-encode C-Win 
FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHostName C-Win 
FUNCTION getHostName RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS 
         AT COL 1 ROW 1
         SIZE 39.4 BY 2.19.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Window"
         HEIGHT             = 2.19
         WIDTH              = 39.8
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

/* OCX BINARY:FILENAME is: adeweb\_webcom.wrx */

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME        = FRAME DEFAULT-FRAME:HANDLE
       ROW          = 1.48
       COLUMN       = 4
       HEIGHT       = 1.43
       WIDTH        = 6.4
       HIDDEN       = no
       SENSITIVE    = yes.
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {DE90AEA3-1461-11CF-858F-0080C7973784} type: CIHTTP */

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.FileClosed
PROCEDURE CtrlFrame.CIHTTP.FileClosed .
/*------------------------------------------------------------------------------
  Purpose:     This event fires when the GET or POST has completed.
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewLine    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLineCnt    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lFileExists AS LOGICAL   NO-UNDO.
  
  ASSIGN
    lFileClosed = TRUE
    lEndOfFile  = lEndOfFile OR (lCompile AND NOT lSave AND NOT lSaveAs).

  &if {&debug} &then
  message "[_webcom.w] FileClosed" skip
    view-as alert-box.
  &endif

  /* For Compile, Check Section, and Check Syntax only do this code on the 
     way out. */
  IF lAnalyze  
  OR lBestName 
  OR lCGI
  OR (lCompile AND lEndOfFile)
  OR lDelete
  OR lOffset 
  OR lOpen 
  OR lProcInfo
  OR (lSave AND lEndOfFile) /* included here to trap for error messages or
                               "no-compile" or "compile" returned from 
                               _cpyfile.p for HTML files */
  OR (lSaveAs AND cFunction BEGINS "okToSave":U) 
  OR lSearch 
  OR ((lCheckSection OR lCheckSyntax) AND lEndOfFile) THEN 
  DO:
    /* Now rewrite the temp file, stripping off the first two HTML lines 
       inserted by the CIHTTP control. The ANALYZE statement in vrfyimp.i
       will complain if we don't do this.  Use tempfile if given. */   
    IF p_tempFile = "" THEN DO:
      /* To enable color editing to work properly for remote editing, the temp
         file extension is set to match that of the file being opened. -jep */
      RUN adecomm/_osfext.p (p_filename, OUTPUT cFileExt).
      IF (cFileExt = "") OR (cFileExt = ?) THEN
        cFileExt = ".tmp":U.
      RUN adecomm/_tmpfile.p ("ws":U, cFileExt, OUTPUT p_tempFile).
    END.

    INPUT STREAM instream FROM VALUE(cTempFile) NO-ECHO.
    OUTPUT STREAM outstream TO VALUE(p_TempFile).
  
    read-block:
    REPEAT:
      cNewLine = "".
      IMPORT STREAM instream UNFORMATTED cNewLine.
      iLineCnt = iLineCnt + 1.

      IF iLineCnt = 1 THEN DO:
        IF NOT cNewLine BEGINS "<!--":U THEN DO:
          RUN html_error.
          cErrorText = "ERROR":U.
          LEAVE read-block.
        END.
        ELSE NEXT.
      END.
      
      IF iLineCnt < 3 THEN NEXT.
        
      /* 3rd line contains procedure info (procInfo), relative path to file 
         (offset, open, saveas, search), CGI environment name=value pairs 
         (cgi), or managed error messages. */
      IF iLineCnt = 3 THEN DO:
        /* Check for errors from webutil/_cpyfile.p. */
        IF cNewLine BEGINS "ERROR:":U OR
           cNewLine BEGINS "OPTION:":U THEN
          ASSIGN 
            lError      = TRUE
            lFileExists = (INDEX(cNewLine,"File exists":U) ne 0).
        ELSE IF cNewLine BEGINS "<HTML>":U THEN DO:
          RUN html_error.
          LEAVE read-block.
        END.
        ELSE DO:
          ASSIGN p_relName = TRIM(cNewLine).
          IF lSearch OR lCGI THEN LEAVE read-block.
          NEXT.
        END.
      END.
      
      IF lError THEN DO:                
        /* This is the normal case of file exists. */ 
        /* IF iLineCnt > 4 AND lFileExists THEN */
        IF iLineCnt = 4 AND lFileExists THEN /* 19990317-029 */
          p_relName = TRIM(cNewLine).                           
        
        /* If file exists, line 5 means that we have found a .i when trying to
           save a SmartDataObject, line 4 has the .i and line 5 the .w.  We 
           must make sure that the returned p_relname is the .w. */
        IF iLineCnt = 5 AND lFileExists THEN
           p_relName = TRIM(cNewLine). 
        
        /* We don't need the 5th line in the errortext, but we do return the 
           4th line for the message box in webfile.  It will usually be the 
           same as the p_relfile. */
        ELSE            
          cErrorText = cErrorText + cNewLine + {&EOL}.
        
      END.
        
      /* 4th line begins actual file contents. */
      PUT STREAM outstream UNFORMATTED cNewLine {&EOL}.
      
      IF iLineCnt >= 4 AND lProcInfo THEN 
        cProcInfo = cProcInfo + cNewLine + {&EOL}.
        
    END. /* read-block */
    OUTPUT STREAM outstream CLOSE.
    INPUT STREAM instream CLOSE.
    
    OS-DELETE VALUE(cTempFile).
    APPLY "U1":U TO THIS-PROCEDURE.
  END.
  
  IF lSave OR (lSaveAs AND NOT (cFunction BEGINS "okToSave":U)) 
  OR lCheckSection 
  OR lCheckSyntax THEN 
  DO:
    OS-DELETE VALUE(cTempFile).
    
    IF NOT VALID-HANDLE(hProBar) THEN
      lCancel = TRUE.

    IF lEndOfFile OR lCancel THEN
      APPLY "U1":U TO THIS-PROCEDURE.
    ELSE
      RUN connect_server.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.HTTPServerConnection
PROCEDURE CtrlFrame.CIHTTP.HTTPServerConnection .
/*------------------------------------------------------------------------------
  Purpose:     Connection was made to HTTP server, so now submit URL request.
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
    
  &if {&debug} &then
  message "[_webcom.w] HTTPServerConnection" skip
    view-as alert-box.
  &endif
    
  IF lSave 
  OR (lSaveAs AND NOT (cFunction BEGINS "okToSave":U)) 
  OR lCheckSection 
  OR lCheckSyntax THEN 
  DO:
    ASSIGN
      iSection = iSection + 1
      cAction  = (IF iSection = 1 THEN "first":U ELSE "append":U).
      
    RUN put_section (cAction, cBase, iSection).
  END.

  IF lAnalyze 
  OR lBestName
  OR lCGI
  OR (lCompile AND NOT lSave AND NOT lSaveAs)
  OR lDelete
  OR lOpen 
  OR lOffset 
  OR lProcInfo 
  OR (lSaveAs AND cFunction BEGINS "okToSave":U) 
  OR lSearch THEN 
  DO:
    ASSIGN
      chCtrlFrame:CIHTTP:URL = p_brokerURL + 
        "/webutil/_cpyfile.p":U +
        "?options=":U + p_options + 
        "&action=":U + (IF lCGI OR lCompile OR lProcInfo OR lSaveAs OR lSearch 
                        THEN cFunction ELSE "") +
        "&fileName=":U + url-encode(p_fileName,"query":U) +
        "&htmlFile=":U + url-encode(cHtmlFile,"query":U)
        .
    chCtrlFrame:CIHTTP:GET.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.WSAError
PROCEDURE CtrlFrame.CIHTTP.WSAError .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    error_number
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-error_number AS INTEGER NO-UNDO.

  &if {&debug} &then
  message "[_webcom.w] WSAError" p-error_number 
    view-as alert-box.
  &endif
  
  ASSIGN
    lError     = TRUE			
    cErrorText = DYNAMIC-FUNCTION("WSAError":U in _h_func_lib, p-error_number).

  MESSAGE
    cErrorText
    VIEW-AS ALERT-BOX ERROR.
        
  chCtrlFrame:CIHTTP:CleanupConnection.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


IF p_brokerURL = "":U THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
    "The WebSpeed Broker URL is blank.  Make sure it is set in Preferences.^^This operation will be aborted.").
  RETURN "Error":U.
END.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
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

  IF p_proc-id ne ? THEN DO:
    FIND _P WHERE RECID(_P) = p_proc-id.
    IF p_fileName = "" THEN 
       p_fileName = _P._SAVE-AS-FILE.

    ASSIGN
      cHtmlFile  = _P._html-file
      lSmartData = (_P._TYPE eq "SmartDataObject":U).
  END.


  /* check for filename(classtype) */
  IF (INDEX(p_fileName,"|":U) > 0) THEN
      ASSIGN 
          ix = INDEX(p_fileName,"|":U)
          cClassType = SUBSTRING(p_fileName,ix + 1)
          p_fileName = SUBSTRING(p_fileName,1,ix - 1)
          cClassType = (IF cClassType = ? THEN "" ELSE cClassType)
      .
  
  DO ix = 1 TO NUM-ENTRIES(p_options):
    cValue = TRIM(ENTRY(ix,p_options)).
    
    IF NUM-ENTRIES(cValue,":":U) > 1 THEN DO:
      IF cValue BEGINS "cgi":u THEN
        ASSIGN
          lCGI                = TRUE
          cFunction           = ENTRY(2,cValue,":":U)
          ENTRY(ix,p_options) = "cgi":U.
      IF cValue BEGINS "compile":u THEN
        ASSIGN
          lCompile            = TRUE
          cFunction           = ENTRY(2,cValue,":":U)
          ENTRY(ix,p_options) = "compile":U.
      ELSE IF cValue BEGINS "procInfo":u THEN
        ASSIGN
          lProcInfo           = TRUE
          cFunction           = ENTRY(2,cValue,":":U)
          ENTRY(ix,p_options) = "procInfo":U.
      ELSE IF cValue BEGINS "saveAs":u THEN
        ASSIGN
          lSaveAs             = TRUE
          cFunction           = ENTRY(2,cValue,":":U)
          ENTRY(ix,p_options) = "saveAs":U.      
      ELSE IF cValue BEGINS "search":u THEN
        ASSIGN
          lSearch             = TRUE
          cFunction           = ENTRY(2,cValue,":":U)
          ENTRY(ix,p_options) = "search":U.
    END.
    ELSE
      ASSIGN
        lAnalyze      = (lAnalyze      OR cValue eq "analyze":U)
        lBestName     = (lBestName     OR cValue eq "bestname":U)
        lCGI          = (lCGI          OR cValue eq "cgi":U)
        lCheckSection = (lCheckSection OR cValue eq "checkSection":U)
        lCheckSyntax  = (lCheckSyntax  OR cValue eq "checkSyntax":U)
        lCompile      = (lCompile      OR cValue eq "compile":U)
        lDelete       = (lDelete       OR cValue eq "delete":U)
        lHostName     = (lHostName     OR cValue eq "HostName":U)
        lNoBar        = (lNoBar        OR cValue eq "noBar":U)
        lOffset       = (lOffset       OR cValue eq "offset":U)
        lOpen         = (lOpen         OR cValue eq "open":U)
        lRun          = (lRun          OR cValue eq "run":U)
        lSave         = (lSave         OR cValue eq "save":U)
        lSaveAs       = (lSaveAs       OR cValue eq "saveAs":U)
        lSearch       = (lSearch       OR cValue eq "search":U)
        .  
  END.
  
  /* if we have the save-as-path info, then we need to concatenate it when saving the file
     so we save changes to correct file */
  IF AVAILABLE (_P) AND lSave THEN DO:
      IF _P._save-as-path NE ?  AND _P._SAVE-AS-FILE = p_fileName THEN
          p_fileName = _P._save-as-path + _P._SAVE-AS-FILE.
  END.
  ELSE DO:
      /* this should NOT happen, but just in case we find out way here
         with the file info passed by _webfile.w. If we have the info to
         construct the absolute file name */
      IF (lOpen OR lSave OR lSaveas) AND 
          ws-get-save-as-path (INPUT p_fileName) NE ? THEN
         ASSIGN p_fileName = ws-get-absolute-path (INPUT p_fileName).
  END.

  &if {&debug} &then
  message "[_webcom.w]" skip
    "p_proc-id"       p_proc-id     skip
    "p_brokerURL"     p_brokerURL   skip
    "p_fileName"      p_fileName    skip
    "p_options"       p_options     skip
    "p_relName"       p_relName     skip
    "p_tempFile"      p_tempFile    skip
    "cFunction"       cFunction     skip(1)
    "lCGI"            lCGI          skip
    "lCheckSection"   lCheckSection skip
    "lCheckSyntax"    lCheckSyntax  skip
    "lCompile"        lCompile      skip
    "lDelete"         lDelete       skip
    "lHostName"       lHostName     skip
    "lNoBar"          lNoBar        skip
    "lOffset"         lOffset       skip
    "lOpen"           lOpen         skip
    "lProcInfo"       lProcInfo     skip
    "lRun"            lRun          skip
    "lSave"           lSave         skip
    "lSaveAs"         lSaveAs       skip
    "lSearch"         lSearch       skip
    view-as alert-box.
  &endif
  
  /* Precheck for Apache web server which won't handle forward slashes in 
     the filename.  We don't want to url-encode / to %2F. */
  IF NOT lCGI THEN
    RUN adeweb/_webcom.w (?, p_brokerURL, "", "cgi:server_software":U,
                          OUTPUT cWebServer, INPUT-OUTPUT cScrap).    

  IF lSave OR lSaveAs OR lCheckSection OR lCheckSyntax THEN DO:
    /* Create a temp file name to use for remote save. */
    RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cWebTemp).
    RUN adecomm/_osprefx.p (cWebTemp, OUTPUT cPrefix, OUTPUT cBase).
    
    IF NOT (lSaveAs AND cFunction BEGINS "okToSave":U) THEN DO:
      cValue = "".

      FORM cValue VIEW-AS EDITOR LARGE SIZE 1 BY 1 WITH FRAME a.
      cValue:READ-FILE(p_tempFile) IN FRAME a.
      ASSIGN
        iFileSize = cValue:LENGTH IN FRAME a
        cValue    = p_fileName + 
                    (IF lCheckSection OR lCheckSyntax THEN 
                       " as " + cBase ELSE "").
      IF NOT lNoBar THEN DO:
        RUN webutil/_probar.w PERSISTENT SET hProBar (cValue, p_brokerURL, 0).
        IF VALID-HANDLE(hProBar) THEN
          RUN set_scale IN hProBar (0).
      END.

      INPUT STREAM webstream FROM VALUE(p_tempFile) NO-ECHO.
    END.
  END.
  ELSE
    RUN adecomm/_setcurs.p ("WAIT":U). 
  
  IF lRun THEN
    RUN runBrowser.
  ELSE IF lHostName THEN DO:
    cHostName = getHostName().
    RETURN cHostName.
  END.
  ELSE
    RUN connect_server.
  
  REPEAT WHILE NOT lRun:
    WAIT-FOR U1 OF THIS-PROCEDURE.
  
    IF lFileClosed THEN DO:
      IF lAnalyze
      OR lBestName 
      OR lCGI
      OR (lCompile AND NOT lSave AND NOT lSaveAs)
      OR lDelete
      OR lOffset 
      OR lOpen 
      OR lProcInfo 
      OR (lSaveAs AND cFunction BEGINS "okToSave":U)
      OR lSearch THEN 
        LEAVE.
      
      ELSE 
      IF lSave 
      OR lSaveAs 
      OR lCheckSection 
      OR lCheckSyntax THEN 
      DO:
        IF lEndOfFile OR lCancel THEN LEAVE.
        RUN connect_server.
      END.
    END.
  END.

  OS-DELETE VALUE(cTempFile).
  
  /* Delete p_tempFile for those cases where the CIHTTP response file does not
     need to be left around to be read by another program. */
  IF NOT lAnalyze AND NOT lOffset AND NOT lOpen THEN
    OS-DELETE VALUE(p_tempFile).
    
  RUN adecomm/_setcurs.p ("":U).

  IF lSave OR (lSaveAs AND NOT (cFunction BEGINS "okToSave":U)) 
  OR lCheckSection 
  OR lCheckSyntax THEN DO:
    INPUT STREAM webstream CLOSE.
    DELETE PROCEDURE hProbar NO-ERROR.
  END.

  /* Cleanup any remote .tmp files left over from incomplete save. */
  IF lCancel THEN
    RUN adeweb/_webcom.w (?, p_brokerURL, cBase, "DELETE":U,
                          OUTPUT cScrap, INPUT-OUTPUT cScrap).    

  RUN adecomm/_setcurs.p ("":U). 

  IF lError THEN
    RETURN cErrorText.
  ELSE 
  IF lProcInfo THEN
    RETURN cProcInfo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connect_server C-Win 
PROCEDURE connect_server :
/*------------------------------------------------------------------------------
  Purpose:     Connect to a Web server. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iResult AS INTEGER NO-UNDO.
  
  &if {&debug} &then
  message "[_webcom.w] connect_server" skip
    view-as alert-box.
  &endif
    
  RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cTempFile).

  /* Connect to Web server and pass URL. */
  ASSIGN
    chCtrlFrame:CIHTTP:LocalFileName = cTempFile
    chCtrlFrame:CIHTTP:ParseURL      = TRUE
    chCtrlFrame:CIHTTP:URL           = p_brokerURL 
    iResult                          = chCtrlFrame:CIHTTP:ConnectToHTTPServer
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "adeweb\_webcom.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "adeweb\_webcom.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win _DEFAULT-ENABLE
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
  RUN control_load.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE html_error C-Win 
PROCEDURE html_error :
/*------------------------------------------------------------------------------
  Purpose:     Display HTML error in user's web browser
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN lError = TRUE.
  INPUT STREAM instream CLOSE.
  RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
    "An error occured on the web server and will be displayed in your web browser.").
          
  IF _WebBrowser = "" THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
      "You have not defined a web browser in Preferences.").
  ELSE
    RUN adeweb/_runbrws.p (_WebBrowser,chCtrlFrame:CIHTTP:URL,_open_new_browse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE post_data C-Win 
PROCEDURE post_data :
/*------------------------------------------------------------------------------
  Purpose:     Post data to the web
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_action   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_webTemp  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_postData AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_section  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE p_newline AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE apacheVersion AS CHARACTER NO-UNDO.
  DEFINE VARIABLE apacheMajorVersion AS CHARACTER NO-UNDO.
    
  /*  IIS 6 requires the use of \r\n terminator characters for each new line in
     the header, so verify the web server type and set the newline control 
     properly. This is backward compatible with IIS 5 and earlier.
  */     
  IF cWebServer BEGINS "Microsoft-IIS":U  THEN
      p_newline = CHR(13) + CHR(10).
      /* PSC00361090-apache httpd server has issue with white space characters(CRLF) 
         for request header information. from the version apache 2.4 CRLF is expected in header information.
         affected apache versions: 2.4.23, 2.4.20, 2.4.18, 2.4.17, 2.4.16, 2.4.12, 2.4.10, 2.4.9, 2.4.7, 2.4.6, 2.4.4, 2.4.3, 2.4.2, 2.4.1
      */
  else if cWebServer BEGINS "Apache":U  then do:
      apacheVersion = SUBSTRING(cWebServer,index(cWebServer,"/") + 1, INDEX(cWebServer," ") - INDEX(cWebServer,"/"),"character").
      apacheMajorVersion = SUBSTRING(apacheVersion,INDEX(apacheVersion,".") - 1, R-INDEX(apacheVersion,".") - 1,"character").
      /* In coming future this may be fixed by apache community. so we may need minor version info.
         use below substring to fetch the minor version.
         SUBSTRING(apacheVer,R-INDEX(apacheVer,".") + 1, INDEX(apacheVer," "),"character").
         NOTE: if this issue is fixed in latest version of apache then below condition must be changed to exclude it.
      */       
      if apacheMajorVersion GE "2.4":U then
          p_newline = CHR(13) + CHR(10).
  end.
  ELSE
      p_newline = CHR(10).


  ASSIGN
    chCtrlFrame:CIHTTP:URL        = p_brokerURL
      + "/webutil/_cpyfile.p":U 
      + "?options=":U + p_options
      + "&action=":U + p_action
      + "&tempFile=":U + url-encode(p_webTemp,"query":U)
      + "&fileName=":U + url-encode(p_fileName, "query":U)
      + "&section=":U + p_section
      + (IF cClassType <> ? THEN
          "&isClass=yes&classtype=":U + URL-ENCODE(cClassType,"query":U)
          ELSE "":U)
    chCtrlFrame:CIHTTP:HTTPHeader = "Content-type: text/plain" + p_newline + 
                                    "Content-Length: " + 
                                    STRING(LENGTH(p_postdata,"RAW":U)) + 
                                    p_newline + p_newline + p_postdata
    .
  chCtrlFrame:CIHTTP:POST.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put_section C-Win 
PROCEDURE put_section :
/*------------------------------------------------------------------------------
  Purpose:     Copy a file section to a WebSpeed agent.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_action  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_base    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_section AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cNewLine  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPostData AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLength   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPercent  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iTarget   AS INTEGER   NO-UNDO INITIAL 500.

  &if {&debug} &then
  message "[_webcom.w] put_section" skip
    view-as alert-box.
  &endif
  
  REPEAT WHILE iLength <= 18000 :
    cNewLine = "".
    IMPORT STREAM webstream UNFORMATTED cNewLine NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      lEndOfFile = TRUE.
      LEAVE.
    END.
    
    ASSIGN
      cPostData   = cPostData + (IF cPostData <> "" THEN {&EOL} ELSE "")
                      + cNewLine
      iLength     = iLength + LENGTH(cNewLine,"RAW":U)

      iBytesSaved = iBytesSaved + LENGTH(cNewLine,"RAW":U)
      iPercent    = INTEGER(iBytesSaved / iFileSize * 100)
      .
      
    IF (lSave OR lSaveAs OR lCheckSection OR lCheckSyntax) 
      AND iBytesSaved >= iTarget THEN DO:
      IF VALID-HANDLE(hProBar) THEN
        RUN set_scale IN hProBar (iPercent).
      iTarget = iTarget + 200.
    END.
  END. /* REPEAT WHILE... */

  IF ERROR-STATUS:ERROR THEN 
    lEndOfFile = TRUE.
  
  IF (lSave OR lSaveAs OR lCheckSection OR lCheckSyntax) AND 
    lEndOfFile AND VALID-HANDLE(hProBar) THEN
    RUN set_scale IN hProBar (100).

  RUN post_data (IF lEndOfFile THEN "last":U ELSE p_action,
                 cBase, cPostData, p_section).
                   
  OS-DELETE VALUE(p_tempFile).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runBrowser C-Win 
PROCEDURE runBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Run a file on a WebSpeed agent.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    chCtrlFrame:CIHTTP:ParseURL = TRUE
    chCtrlFrame:CIHTTP:URL      = p_brokerURL + 
      (IF NOT lSmartData THEN 
         ("/":U + url-encode(p_fileName, "query":U))
       ELSE
         ("/webutil/_sdoinfo.p?procedure=":U + 
          url-encode(p_fileName, "query":U) + 
          "&attribute=ObjectViewer":U)).
  
  RUN adeweb/_runbrws.p (_WebBrowser, chCtrlFrame:CIHTTP:URL, _open_new_browse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHostName C-Win 
FUNCTION getHostName RETURNS CHARACTER :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN 
    chCtrlFrame:CIHTTP:ParseURL = TRUE
    chCtrlFrame:CIHTTP:URL      = p_brokerURL.
  
  RETURN chCtrlFrame:CIHTTP:HostName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION url-encode C-Win 
FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cReserved   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE encode-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hx          AS CHARACTER NO-UNDO 
    INITIAL "0123456789ABCDEF":U.
  DEFINE VARIABLE iValue      AS INTEGER   NO-UNDO.

  DEFINE VARIABLE url_unsafe   AS CHARACTER NO-UNDO 
    INITIAL " <>~"#%{}|~\^~~[]`":U.
  DEFINE VARIABLE url_reserved AS CHARACTER NO-UNDO 
    INITIAL "~;/?:@=&":U.
 
  /* Don't bother with blank input */
  IF LENGTH(p_value) = 0 THEN RETURN "".

  /* The Apache web server does not convert an encoded slash (%2F) causing 
     any URL with this string to fail, so remove it from reserved list. */
  IF cWebServer BEGINS "Apache":U THEN
    url_reserved = REPLACE(url_reserved, "~/":U, "").
  
  /* What kind of encoding should be used? */
  CASE p_enctype:
    WHEN "query":U THEN              /* QUERY_STRING name=value parts */
      encode-list = url_unsafe + url_reserved + "+":U.
    WHEN "cookie":U THEN             /* Persistent Cookies */
      encode-list = url_unsafe + " ,~;":U.
    WHEN "default":U OR WHEN "" THEN /* Standard URL encoding */
      encode-list = url_unsafe.
    OTHERWISE
      encode-list = url_unsafe + p_enctype.   /* user specified ... */
  END CASE.

  /* Loop through entire input string */
  ASSIGN iValue = 0.
  DO WHILE TRUE:
    ASSIGN
      iValue = iValue + 1  /* Next character */
      /* ASCII value of character */
      c = ASC(SUBSTRING(p_value, iValue, 1, "RAW":U)).
    IF c <= 31 OR c >= 127 OR INDEX(encode-list, CHR(c)) > 0 THEN DO:
      /* Replace character with %hh hexidecimal triplet */
      SUBSTRING(p_value, iValue, 1, "RAW":U) = "%":U +
        SUBSTRING(hx, INTEGER(TRUNCATE(c / 16, 0)) + 1, 1, "RAW":U) + /* high */
        SUBSTRING(hx, c MODULO 16 + 1, 1, "RAW":U).             /* low digit */
      ASSIGN iValue = iValue + 2.   /* skip over hex triplet just inserted */
    END.
    IF iValue = LENGTH(p_value,"RAW") THEN LEAVE.
  END.

  RETURN p_value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



