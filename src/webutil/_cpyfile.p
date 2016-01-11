&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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
**********************************************************************

  File: _cpyfile.p
  Description: 
  CGI Parameters:
    p_options  -- analyze     - ANALYZE has two output files.  Only the first 
                                one is returned, but the name of the second is
                                returned so it can be fetched using options 
                                'open,delete'
                  bestname    - Find the first NON-existing file.     
                                (adecomm/_bstfnam.p)                                            
                  CGI         - Return CGI Environment variable(s)
                  checkSyntax 
                  compile     - Compile a 4GL file
                  debug
                  delete      - Implemented to delete the second analyze file,
                                and are only tested in that context. 
                  open        - Open a file
                  offset      - Return a HTML Mapping offset file
                  run         - Run a Web object
                  save        - Save to a file
                  saveAs      - Save to a file with a different name
                  saveW       - Save intermediate E4GL .w file
                  search
                             
    p_action   -- first, append, last 
    p_fileName -- The pathname of the file. The file is assumed to 
                  exist (relative to PROPATH). 
    p_htmlFile -- The pathname of the HTML file. The file is assumed to 
                  exist (relative to PROPATH). 
    p_tempFile -- Name of temp-file to use during save process.
                                  
  Author:  D.M.Adams
  Created: 01/98
  Changed: 06/98    hdaniels Added analyze and delete options   
           01/18/01 adams    Broke up Main Block monolith
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
{ src/web/method/wrap-cgi.i }

DEFINE VARIABLE cAction       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAnalyzeFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCompileFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cConvertFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cErrMsgs      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileExt      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cIncName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewLine      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNextLine     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOffsetFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOptions      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPath         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRCodeFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRunFile      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lDoCompile    AS LOGICAL   NO-UNDO.             
DEFINE VARIABLE lE4glFile     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFileExists   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lIsIE         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lNoCompile    AS LOGICAL   NO-UNDO.          
DEFINE VARIABLE lScrap        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE p_action      AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_fileName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_htmlFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_oldFile     AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_options     AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_section     AS INTEGER   NO-UNDO.
DEFINE VARIABLE p_postData    AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_tempFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_txt         AS CHARACTER NO-UNDO.

/* options */
DEFINE VARIABLE lAnalyze      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lBestName     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCGI          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCheckSection AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCheckSyntax  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lCompile      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lDebug        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lDelete       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lEditor       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOffset       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOpen         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lProcInfo     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRun          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSave         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSaveAs       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSaveW        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lSearch       AS LOGICAL   NO-UNDO.

/* These logicals modify the HTML code generated after the Save is complete. 
   These must be mutually exclusive - only one can be true at a time. */
DEFINE VARIABLE lFileClose    AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE lFileNew      AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE lFileOpen     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFileSave     AS LOGICAL   NO-UNDO.

DEFINE STREAM instream. 
DEFINE STREAM outstream.
DEFINE STREAM teststream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


ASSIGN
  p_action     = get-field("action":U)
  p_fileName   = get-field("fileName":U)
  p_htmlFile   = get-field("htmlFile":U)
  p_oldFile    = get-field("oldFile":U)
  p_options    = get-field("options":U)
  p_postData   = WEB-CONTEXT:FORM-INPUT
  p_section    = INTEGER(get-field("section":U))
  p_tempFile   = get-field("tempFile":U)
  
  /* Support for 9.1A+ browser-based Editor WebTool. */
  p_txt        = get-field("txt0":U)
  p_postdata   = (IF p_txt NE "" THEN p_txt ELSE p_postdata)
  lIsIE        = (INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0)
  cNewLine     = (IF OPSYS = "UNIX" THEN "~\~\n" ELSE "~\n")
  .
  
/* Output the MIME header. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).  

IF NOT WEB-CONTEXT:GET-CONFIG-VALUE("srvrAppMode":U) BEGINS "Dev":U THEN DO:
  {&OUT} "ERROR: ":U SKIP
    "webutil/_cpyfile.r is supported in Development Mode only." SKIP.
	RETURN.
END.

ASSIGN
  lAnalyze      = CAN-DO(p_options,"analyze":U)
  lBestName     = CAN-DO(p_options,"bestName":U)
  lCGI          = CAN-DO(p_options,"cgi":U)
  lCheckSection = CAN-DO(p_options,"checkSection":U)
  lCheckSyntax  = CAN-DO(p_options,"checkSyntax":U)
  lCompile      = CAN-DO(p_options,"compile":U)
  lDebug        = CAN-DO(p_options,"debug":U)
  lDelete       = CAN-DO(p_options,"delete":U)
  lEditor       = CAN-DO(p_options,"editor":U)
  lFileClose    = CAN-DO(p_options,"fileClose":U)
  lFileNew      = CAN-DO(p_options,"fileNew":U)
  lFileOpen     = CAN-DO(p_options,"fileOpen":U)
  lFileSave     = CAN-DO(p_options,"fileSave":U)
  lOffset       = CAN-DO(p_options,"offset":U)
  lOpen         = CAN-DO(p_options,"open":U)
  lProcInfo     = CAN-DO(p_options,"procInfo":U)
  lRun          = CAN-DO(p_options,"run":U)
  lSave         = CAN-DO(p_options,"save":U)
  lSaveAs       = CAN-DO(p_options,"saveas":U)
  lSaveW        = CAN-DO(p_options,"savew":U)
  lSearch       = CAN-DO(p_options,"search":U)

  cTarget       = (IF lFileClose THEN "fileClose":U ELSE 
                   IF lFileNew   THEN "fileNew":U   ELSE 
                   IF lFileOpen  THEN "fileOpen":U  ELSE
                   IF lFileSave  THEN "fileSave":U  ELSE "").
  
/* Return one or all CGI environment variables. */
IF lCGI THEN DO:
  {&OUT} get-cgi(p_action) SKIP.
  RETURN.
END.

/* Treated separately because it returns a non-existent file */ 
IF lBestName THEN DO:
  RUN adecomm/_bstfnam.p (p_filename, OUTPUT cRelname).  
  {&OUT} cRelname SKIP.
END.

/* Many of the following RUN statements were implemented to break up the Main 
   Block monolith.  We were exceeding the editor's 20K block limit. (adams) */
IF lAnalyze OR lOpen OR lOffset OR lProcInfo OR lSearch THEN DO:
  RUN miscAction.
  IF RETURN-VALUE = "leave":U THEN RETURN.
END.

/* Save a file to disk */
IF lSave OR lSaveAs OR lCheckSection OR lCheckSyntax OR
  (lCompile AND p_action BEGINS "okTo":U) THEN DO:
  RUN savefile.
  IF RETURN-VALUE = "leave":U THEN RETURN.
END.

IF lRun OR (lCompile AND p_action eq "") OR
  (p_action eq "last":U AND
    (lCheckSection OR lCheckSyntax OR lCompile)) THEN DO:
  RUN runFile.
  IF RETURN-VALUE = "leave":U THEN RETURN.
END.

IF lProcInfo THEN DO:
  DEFINE VARIABLE _h_proc AS HANDLE NO-UNDO.
 
  DO ON STOP UNDO, LEAVE:  
    RUN VALUE(p_filename) PERSISTENT SET _h_proc NO-ERROR.
  END.
  
  /* Report any errors. */
  IF COMPILER:ERROR OR ERROR-STATUS:ERROR THEN DO:
    cErrMsgs = IF ERROR-STATUS:NUM-MESSAGES gt 1 
               THEN "errors" ELSE "error".
    {&OUT} "ERROR: ":U COMPILER:FILE-OFFSET SKIP
      SUBSTITUTE("The following &1 occurred on the WebSpeed agent.",
                 cErrMsgs) SKIP(1).
    RUN webtools/util/_errmsgs.w (COMPILER:FILE-NAME, 
                                  "NO-HTML,LINE-NUMBERS":U).
    RETURN.
  END.
  
  IF VALID-HANDLE(_h_proc) THEN DO:
    ASSIGN cValue = DYNAMIC-FUNCTION(p_action IN _h_proc) NO-ERROR.
  
    DELETE PROCEDURE _h_proc NO-ERROR.
  END.
END.

IF lDelete THEN
  RUN deleteFile (p_fileName, "#9").

IF lProcInfo THEN
  {&OUT} cValue SKIP.

IF lSave OR (lCompile AND p_action BEGINS "okToCompile":U) THEN DO:
  /* Prompt the Editor WebTool to send the next section. */
  IF lEditor THEN DO:
    IF lSave THEN DO:
       {&OUT} 
         '<HTML>':U SKIP
         '<HEAD>':U SKIP
         '<SCRIPT LANGUAGE="JavaScript1.2" SRC="' RootURL '/script/common.js"><!--':U SKIP
         '  document.write("Included common.js file not found.");':U SKIP
         '//--></SCRIPT>':U SKIP
         '<SCRIPT LANGUAGE="JavaScript1.2"><!--':U SKIP
         '  function init() ~{':U SKIP
         '    getBrowser();':U SKIP.
       
       /* Call back to the Editor to send the next file section. */
       IF (p_action ne "last":U) THEN
         {&OUT}
           '      parent.WS_menu.postData(':U (p_section + 1) 
           ',"","postData","' cTarget '");':U SKIP.
       ELSE DO:
         {&OUT}
           '    parent.WS_edit.lCheckSyntax = false;':U SKIP 
           '    parent.WS_menu.lCheckSyntax = false;':U SKIP.
           
         IF (NOT lCheckSyntax) THEN DO:
           RUN adecomm/_osprefx.p (p_filename, OUTPUT cPath, OUTPUT cValue).
       
           {&OUT}
             '    if (isIE4up) ~{':U SKIP
             '      parent.WS_menu.saveValue                  = ':U
                     (IF lFileNew THEN '"";':U ELSE 'parent.WS_edit.form1.txt.value;':U) SKIP
             '      parent.WS_hdr.headerTitle.innerText       = "Editor - " + "':U 
                     (IF lFileNew THEN "Untitled" ELSE cValue) '";':U SKIP
             '      parent.WS_menu.document.body.style.cursor = "default";':U SKIP
             '    }':U SKIP
             '    else if (isNav4up) ~{':U SKIP
             '      var formObj = parent.WS_edit.document.layer1.document.form1;':U SKIP
             '      formObj.elements["fileName"].value = "':U 
                      (IF lFileNew THEN "Untitled" ELSE cValue) '";':U SKIP
             '      formObj.elements["dirPath"].value  = "':U 
                      (IF lFileNew THEN "" ELSE cPath) '";':U SKIP
             '      parent.WS_menu.saveValue           = ':U
                      (IF lFileNew THEN '"";':U ELSE 'formObj.elements["txt"].value;':U) SKIP
             '      parent.WS_menu.cFileName           = "':U 
                      (IF lFileNew THEN "Untitled" ELSE p_filename) '";':U SKIP
             '      parent.WS_menu.setHeaderTitle();':U SKIP
             '      if (':U STRING(lFileOpen,"true/false") ')':U SKIP
             '        parent.WS_menu.fileOpen("");':U SKIP
             '    }':U SKIP
             '    if (':U STRING(lFileNew,"true/false") ')':U SKIP
             '      parent.WS_menu.fileNew("OK");':U SKIP.
         END.

         {&OUT}
             '  parent.WS_menu.saveBar("delete");':U SKIP.
       END. /* p_action = "last" */
       
       {&OUT}
         '  }':U SKIP
         '//--></SCRIPT>':U SKIP
         '</HEAD>':U SKIP
         '<BODY onLoad="init()">':U SKIP
         '</BODY>':U SKIP
         '</HTML>':U.
    END.
    ELSE IF lCompile THEN DO:
      IF lNoCompile THEN
        RUN webAlert ('The META "no-compile" option was detected.' + cNewLine +
                      'The file was not compiled.', "").
      ELSE
        RUN webConfirm ("", "compile").
    END.
  END. /* IF lEditor */
  ELSE DO:
    IF lNoCompile THEN
      {&OUT} "OPTION: No compile" SKIP.
    IF lDoCompile THEN
      {&OUT} "OPTION: Do compile" SKIP.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-copyFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyFile Procedure 
PROCEDURE copyFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcTempFile AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcFileName AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cError AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iError AS INTEGER   NO-UNDO.

  OS-COPY VALUE(pcTempFile) VALUE(pcFileName).
 
  iError = OS-ERROR.
  IF iError ne 0 THEN DO:
    RUN adecomm/_oserr.p (OUTPUT cError).
    
    IF lEditor THEN
      RUN webAlert("Error creating " + pcFileName + ".  " + 
                   STRING(cError) + ".", "").
    ELSE
      {&OUT} 
        "ERROR: ":U SKIP 
        "[_cpyfile.p: OS-COPY] " pcFileName SKIP 
        cError SKIP.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteFile Procedure 
PROCEDURE deleteFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFileName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcOptions  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cError AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iError AS INTEGER   NO-UNDO.
  
  IF pcFileName eq "" THEN RETURN.
  
  OS-DELETE VALUE(pcFileName) NO-ERROR.
  iError = OS-ERROR.
  
  IF iError ne 0 AND iError ne 2 THEN DO:
    RUN adecomm/_oserr.p (OUTPUT cError).
    
    IF lEditor THEN
      RUN webAlert("Error deleting " + pcFileName + "." + cNewLine + 
                   STRING(cError) + ".", "").
    ELSE
      {&OUT} 
        "ERROR: ":U SKIP
        "[_cpyfile.p: OS-DELETE] " pcFileName SKIP 
        cError SKIP.
  END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getE4glOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getE4glOptions Procedure 
PROCEDURE getE4glOptions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
  RUN adecomm/_osfext.p (p_filename, OUTPUT cFileExt).
  RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cConvertFile).
  
  IF cFileExt eq ".htm":U OR cFileExt eq ".html":U THEN DO:
    /* Convert HTML file to SpeedScript .w, so we can find out what
       wsoptions are specified in the META/WSMETA tags. */
    RUN webutil/e4gl-gen.p (p_filename,
                            INPUT-OUTPUT cOptions, 
                            INPUT-OUTPUT cConvertFile).
      
    IF CAN-DO(cOptions, "no-compile":U) THEN
      lNoCompile = TRUE.
    IF CAN-DO(cOptions, "compile":U) THEN
      lDoCompile = TRUE.
    RUN deleteFile (cConvertFile, "#10").
  END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-miscAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE miscAction Procedure 
PROCEDURE miscAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF lOffset THEN DO:
    RUN webutil/_offsrch.p (p_htmlFile, p_fileName, INPUT-OUTPUT cOffsetFile).
    
    IF cOffsetFile = ? THEN DO:
      {&OUT} "ERROR: ":U SKIP
        "HTML offset file could not be found by the WebSpeed agent." SKIP.
      RETURN "leave":U.
    END.
    ELSE 
      p_fileName = cOffsetFile.
  END.
  
  IF lAnalyze THEN DO:
    RUN adecomm/_tmpfile.p ("ws":U, ".qs":U, OUTPUT cAnalyzeFile).
        
    ANALYZE VALUE(p_filename) 
            VALUE(cAnalyzeFile)
            OUTPUT VALUE(cAnalyzeFile + "2":U) NO-ERROR.
    
    IF COMPILER:ERROR THEN DO:
      cErrMsgs = IF ERROR-STATUS:NUM-MESSAGES gt 1 THEN "errors" ELSE "error".
      {&OUT} "ERROR: ":U SKIP
        SUBSTITUTE("The following &1 occurred on the WebSpeed agent.",
                   cErrMsgs) SKIP(1).
      RUN webtools/util/_errmsgs.w (COMPILER:FILE-NAME, 
                                    "NO-HTML,LINE-NUMBERS":U).
      RUN deleteFile (cAnalyzeFile, "#1").
      RUN deleteFile (cAnalyzeFile + '2':U, "#2").
      RETURN "leave":U.
    END.    
  END.
 
  /* Send the relative path first. */
  RUN webutil/_relname.p (p_fileName, "must-exist":U, OUTPUT cRelName).
  
  IF lSearch THEN DO:
    IF p_Action = "FILE-INFO":U AND cRelName <> ? THEN
      ASSIGN 
        FILE-INFO:FILE-NAME = cRelName 
        cRelName            = cRelName + ":":U + FILE-INFO:FILE-TYPE.
    {&OUT} cRelname SKIP. 
  END.
  ELSE IF cRelName = ? THEN DO:
    {&OUT} "ERROR: ":U SKIP
      "File not found in WebSpeed agent PROPATH.":U SKIP.
    RETURN "leave":U.
  END.
  ELSE IF lAnalyze THEN
    {&OUT} SEARCH(cAnalyzeFile + '2') SKIP.
  ELSE IF lOpen THEN DO:
    /* Check if the file is readable. */
    ASSIGN
      FILE-INFO:FILE-NAME = cRelName
      cValue              = FILE-INFO:FILE-TYPE.
          
    IF OPSYS = "UNIX":U AND INDEX(p_filename," ":U) > 0 THEN DO:
      IF lEditor THEN
        RUN webAlert (p_filename + " contains spaces.", "").
      ELSE 
        {&OUT} "ERROR: Filename spaces":U SKIP.
      RETURN "leave":U.
    END.
    
    IF INDEX(cValue,"R":U) eq 0 THEN DO:
      IF lEditor THEN
        RUN webAlert(p_filename + " is not readable.", "").
      ELSE
        {&OUT} "ERROR: Not readable":U + CHR(10) + TRIM(p_filename) SKIP.
      RETURN "leave":U.
    END.
    ELSE IF NOT lEditor THEN
      {&OUT} cRelname SKIP.
  END.
  ELSE  
    {&OUT} cRelname SKIP.
  
  IF lOffset OR lOpen OR lAnalyze THEN DO:
    IF lOpen AND lEditor THEN DO:
      RUN adecomm/_osprefx.p (p_filename, OUTPUT cPath, OUTPUT cValue).
      
      {&OUT} 
        '<HTML>':U SKIP
        '<HEAD>':U SKIP
        '<SCRIPT LANGUAGE="JavaScript1.2" SRC="' RootURL '/script/common.js"><!--':U SKIP
        '  document.write("Included common.js file not found.");':U SKIP
        '//--></SCRIPT>':U SKIP
        '<SCRIPT LANGUAGE="JavaScript1.2"><!--':U SKIP
        '  var formObj;':U SKIP
        '  function copyTxt() ~{':U SKIP
        '    if (isIE4up) ~{':U SKIP
        '      parent.WS_edit.form1.txt.value       = ':U SKIP
        '        parent.WS_file.form0.txt0.value;':U SKIP
        '      parent.WS_edit.form1.fileName.value  = "':U cValue '";':U SKIP
        '      parent.WS_edit.form1.dirPath.value   = "':U cPath '";':U SKIP
        '      parent.WS_menu.lUntitled             = false;':U SKIP
        '      parent.WS_menu.saveValue             = ':U SKIP
        '        parent.WS_file.form0.txt0.value;':U SKIP
        '      parent.WS_hdr.headerTitle.innerText  = "Editor - " + "':U cValue '";':U SKIP
        '      parent.WS_menu.document.body.style.cursor = "default";':U SKIP
        '      var textObj = parent.WS_edit.form1.txt.createTextRange();':U SKIP
        '      textObj.collapse();':U SKIP
        '      textObj.select();':U SKIP
        '    }':U SKIP
        '    else if (isNav4up) ~{':U SKIP
        '      formObj.elements["txt"].value      = ':U SKIP
        '        document.form0.elements["txt0"].value;':U SKIP
        '      formObj.elements["fileName"].value = "':U cValue '";':U SKIP
        '      formObj.elements["dirPath"].value  = "':U cPath '";':U SKIP
        '      parent.WS_menu.saveValue           = ':U SKIP
        '        document.form0.elements["txt0"].value;':U SKIP
        '      parent.WS_menu.lUntitled           = false;':U SKIP
        '      parent.WS_menu.setHeaderTitle();':U SKIP
        '      getLength();':U SKIP
        '    }':U SKIP
        '  }':U SKIP
        '  function getLength() ~{':U SKIP
        '    var cString = new String(formObj.elements["txt"].value);':U SKIP
        '    if (cString.length > 30000)':U SKIP
        '      alert("The file exceeds 30,000 characters and cannot be editted':U
        cNewLine 'in Netscape Navigator.  It will be opened read-only.");':U SKIP
        '  }':U SKIP
        '  function init() ~{':U SKIP
        '    getBrowser();':U SKIP
        '    if (isNav4up)':U SKIP
        '      formObj = parent.WS_edit.document.layer1.document.form1;':U SKIP        
        '    copyTxt();':U SKIP
        '  }':U SKIP
        '//--></SCRIPT>':U SKIP
        '</HEAD>':U SKIP
        '<BODY onLoad="init()">':U SKIP
        '<FORM ID="form0" NAME="form0">':U SKIP
        '<TEXTAREA ID="txt0" NAME="txt0" WRAP="no">':U SKIP.
    END.
        
    /* Read the file line by line. */
    INPUT STREAM instream FROM VALUE(IF lAnalyze THEN cAnalyzeFile 
                                     ELSE SEARCH(p_fileName)) NO-ECHO.
    Read-Block:
    REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
      IMPORT STREAM instream UNFORMATTED cNextLine.
      
      IF lOpen AND lEditor THEN
        {&OUT} html-encode(cNextLine) CHR(10).
      ELSE
        {&OUT} cNextLine CHR(10).
    END. /* Read-Block: */
    INPUT STREAM instream CLOSE.

    IF lOpen AND lEditor THEN
      {&OUT} 
        '</TEXTAREA>':U SKIP
        '</FORM>':U SKIP
        '</BODY>':U SKIP
        '</HTML>':U.
  END. /* lOffset OR lOpen OR lAnalyze  */

  /* cAnalyzefile is being read so we can delete it.  cAnalyzefile2 must be 
     kept until it's sent to the client (it will be read and deleted with 
     open,delete) */
  IF lAnalyze THEN 
    RUN deleteFile (cAnalyzeFile, "#3").
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runFile Procedure 
PROCEDURE runFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
             
  /* Does the file exist in PROPATH?  If must be a relative name in order to
     be run as a Web Object. */
  RUN webutil/_relname.p (p_fileName, "must-exist":U, OUTPUT cRelName).
  IF cRelName eq ? AND NOT lCheckSection AND NOT lCheckSyntax THEN DO:
    IF lEditor THEN
      RUN webAlert (p_filename + " not found in WebSpeed agent PROPATH.", "").
    ELSE
      {&OUT} "ERROR: ":U SKIP "File not found in WebSpeed agent PROPATH." SKIP.
    RUN deleteFile (p_tempFile, "#6").
    RETURN "leave":U.
  END.
  ELSE DO:
    IF lCompile OR lCheckSection OR lCheckSyntax THEN DO:
      ASSIGN cCompileFile = (IF lCompile THEN cRelName ELSE p_tempfile).
      
      RUN adecomm/_osfext.p (cRelName, OUTPUT cFileExt).
      IF cFileExt eq ".htm":U OR cFileExt eq ".html":U THEN DO:
        ASSIGN lE4glFile = TRUE.
          
        /* Convert HTML files to SpeedScript. */
        RUN webutil/e4gl-gen.p ((IF lCompile THEN cRelName ELSE p_tempfile),
                                INPUT-OUTPUT cOptions, 
                                INPUT-OUTPUT cConvertFile).
        cCompileFile = cConvertFile.
      END.
      
      /* Don't compile if we're processing an Embedded SpeedScript file and
         the "no-compile" option exists. */
      IF lCompile AND (NOT lE4glFile OR 
        (lE4glFile AND NOT CAN-DO(cOptions,"no-compile"))) THEN
        COMPILE VALUE(cCompileFile) SAVE NO-ERROR.
      ELSE IF lCheckSection OR lCheckSyntax THEN
        COMPILE VALUE(cCompileFile)      NO-ERROR.
      
      /* Return the relative path to the converted file. */
      IF NOT COMPILER:ERROR AND lCompile AND lE4glFile AND NOT lEditor THEN
        {&OUT} cConvertFile SKIP.
      
      RUN deleteFile (p_tempFile, "#7"). 
      IF NOT lSaveW THEN
        RUN deleteFile (cConvertFile, "#8").
    END.
    ELSE IF lRun THEN 
      COMPILE VALUE(cRelName) NO-ERROR.
    
    /* Report any errors. */
    IF COMPILER:ERROR THEN DO:
      ASSIGN
        cAction  = IF lCompile THEN " compiled" ELSE ""
        cErrMsgs = IF ERROR-STATUS:NUM-MESSAGES gt 1 
                   THEN "errors" ELSE "error".

      IF lEditor THEN
        RUN webAlert ("", "header").
      ELSE
        {&OUT} "ERROR: ":U COMPILER:FILE-OFFSET cAction SKIP
          SUBSTITUTE("The following &1 occurred on the WebSpeed agent.",
                     cErrMsgs) SKIP(1).
                     
      RUN webtools/util/_errmsgs.w (COMPILER:FILE-NAME, 
        "NO-HTML,LINE-NUMBERS":U + (IF lEditor THEN ",EDITOR" ELSE "")).
        
      IF lEditor THEN
        RUN webAlert ("", "footer").
        
      RETURN "leave":U.
    END.
    ELSE IF lRun THEN
      RUN VALUE(IF lE4glFile THEN cConvertFile ELSE cRelName) NO-ERROR.
    ELSE IF lCheckSyntax AND lEditor THEN
      RUN webAlert ("Syntax is correct.", "").
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveFile Procedure 
PROCEDURE saveFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  CASE p_action:
    WHEN "append":U THEN DO:
      OUTPUT STREAM outstream TO VALUE(p_tempFile) APPEND.
      PUT STREAM outstream UNFORMATTED p_postData SKIP.
      OUTPUT STREAM outstream CLOSE.
    END.
    /* Output first file section to a temp-file. */
    WHEN "first":U THEN DO:
      OUTPUT STREAM outstream TO VALUE(p_tempFile).
      PUT STREAM outstream UNFORMATTED p_postData SKIP.
      OUTPUT STREAM outstream CLOSE.
    END.
    /* Output last file section. */
    WHEN "last":U THEN DO:
      IF p_section > 1 THEN
        OUTPUT STREAM outstream TO VALUE(p_tempFile) APPEND.
      ELSE 
        OUTPUT STREAM outstream TO VALUE(p_tempFile).
      PUT STREAM outstream UNFORMATTED p_postData SKIP.
      OUTPUT STREAM outstream CLOSE.
  
      /* Now move the temp-file to the actual filename. */
      IF lSave OR lSaveAs THEN
        RUN copyFile (p_tempFile, p_fileName).

      IF NOT lCheckSection AND NOT lCheckSyntax THEN
        RUN deleteFile (p_tempFile, "#4").
        
      /* Return a warning if we're saving an HTML file and the "no-compile" or
         "compile" options were detected.  */
      IF lSave AND NOT lCheckSyntax THEN
        RUN getE4glOptions.
    END. /* last */
    OTHERWISE DO: 
      IF p_Action BEGINS "okToSave":U THEN DO:
        /* For a Save As, check if the file already exists. */
        RUN webutil/_relname.p (p_fileName, "must-exist":U, OUTPUT cRelName).
        
        IF cRelName ne ? THEN DO:
          IF lEditor THEN DO:
            RUN webConfirm (cRelName + " already exists." + cNewLine + cNewLine + 
                            "Do you want to replace it?", "save").
            lFileExists = TRUE.
          END.
          ELSE 
            {&OUT} "ERROR: File exists":U + CHR(10) + TRIM(cRelName) SKIP.
        END.
        
        /* Check if there is a standalone .i that will be overwritten 
           when the SDO include is generated */  
        ELSE IF p_action = "OkToSaveSmartDataObject":U THEN DO:
          /* For a Save As of SDO, also check if the include already exists. */
          RUN webutil/_relname.p 
             (SUBSTR(p_fileName,1,R-INDEX(p_filename,".")) + "i":U, 
              "must-exist":U, 
              OUTPUT cIncName).                   
          
          IF cIncName ne ? THEN
            {&OUT} "ERROR: File exists":U + CHR(10) + TRIM(cIncName) SKIP.
        END. /* else if p_action = 'oktosaveSmartDataobject' */                
                
        /* Check if the file is writeable. */
        IF cRelName eq ? THEN
          RUN adecomm/_osfrw.p (p_fileName, "_write-test,_delete-file":U, OUTPUT cValue).
        ELSE
          ASSIGN
            FILE-INFO:FILE-NAME = cRelName
            cValue              = FILE-INFO:FILE-TYPE.
      
        IF OPSYS = "UNIX":U AND INDEX(p_filename," ":U) > 0 THEN DO:
          IF lEditor THEN
            RUN webAlert (cRelName + " contains spaces.", "").
          ELSE 
            {&OUT} "ERROR: Filename spaces":U SKIP.
        END.
              
        ELSE IF INDEX(cValue,"W":U) eq 0 THEN DO:
          IF lEditor THEN
            RUN webAlert (cRelName + " is not writeable.", "").
          ELSE
            {&OUT} "ERROR: Not writeable":U + CHR(10) + TRIM(p_filename) SKIP.
        END.

        /* File is OK, so signal the Editor WebTool to start the save. */
        ELSE IF lEditor AND (NOT lFileExists) THEN DO:
          {&OUT} 
            '<HTML>':U SKIP
            '<HEAD>':U SKIP
            '<SCRIPT LANGUAGE="JavaScript1.2"><!--':U SKIP
            '  parent.WS_menu.lUntitled = false;':U SKIP
            '  parent.WS_menu.fileSave("fileSave","' cTarget '");':U SKIP
            '//--></SCRIPT>':U SKIP
            '</HEAD>':U SKIP
            '<BODY>':U SKIP
            '</BODY>':U SKIP
            '</HTML>':U.
        END.
                
        /* Return relative path.  */
        ELSE IF cRelName eq ? THEN DO:
          /* Create the file temporarily, so we can get it's relative name. */
          OUTPUT STREAM testStream TO VALUE(p_fileName).
          OUTPUT STREAM testStream CLOSE.
        
          RUN webutil/_relname.p (p_fileName, "must-exist":U, OUTPUT cRelName).
          {&OUT} cRelName SKIP.
          RUN deleteFile (p_fileName, "#5").
        END.
      END. /* p_action begins okToSave */

      /* Check if HTML file should be compiled. */
      ELSE IF p_action BEGINS "okToCompile":U THEN
        RUN getE4glOptions.
    END. /* otherwise */
  END CASE. /* p_action */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-webAlert) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE webAlert Procedure 
PROCEDURE webAlert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cMessage AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cSection AS CHARACTER NO-UNDO.

  IF (cSection eq "header" OR cSection eq "") THEN
    {&OUT} 
      '<HTML>':U SKIP
      '<HEAD>':U SKIP
      '<SCRIPT LANGUAGE="JavaScript1.2"><!--':U SKIP
      '  alert(~''.
    
  IF (cSection eq "") THEN
    {&OUT}
      cMessage.
     
  IF (cSection eq "footer" OR cSection eq "") THEN DO:
    {&OUT}
      '~');' SKIP.
      
    IF lCheckSyntax THEN
      {&OUT}
        '  parent.WS_menu.lCheckSyntax = false;':U SKIP.
        
    {&OUT}
      '//--></SCRIPT>':U SKIP
      '</HEAD>':U SKIP
      '<BODY>':U SKIP
      '</BODY>':U SKIP
      '</HTML>':U.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-webConfirm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE webConfirm Procedure 
PROCEDURE webConfirm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cMessage AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER cMode    AS CHARACTER NO-UNDO.
  
  {&OUT} 
    '<HTML>':U SKIP
    '<HEAD>':U SKIP
    '<SCRIPT LANGUAGE="JavaScript1.2"><!--':U SKIP
    '  var lReturn = true;':U SKIP.
    
  IF cMode eq "save" THEN
    {&OUT}
      '  lReturn = confirm("' cMessage '");' SKIP.
    
  {&OUT}
    '  if (lReturn) ~{':U SKIP.
    
  CASE cMode:
    WHEN "compile" THEN 
      {&OUT} 
        '    parent.WS_menu.runFile("compile");':U SKIP.
    WHEN "save" THEN
      {&OUT} 
        '    parent.WS_menu.cFileName = "':U p_filename '";':U SKIP
        '    parent.WS_menu.lUntitled = false;':U SKIP
        '    parent.WS_menu.fileSave("fileSave","':U cTarget '");':U SKIP.
  END CASE.
    
  {&OUT}
    '  }':U SKIP
    
    /* Cancel the save information. */
    '  else ~{':U SKIP
    '    parent.WS_menu.cFileName = "':U p_oldFile '";':U SKIP.
    
  {&OUT}
    (IF lIsIE THEN
       '    parent.WS_edit.form1.fileName.value = "':U
     ELSE
       '    parent.WS_edit.document.layer1.document.form1.elements["fileName"].value = "':U).
       
  {&OUT}
      p_oldFile '";':U SKIP
    '    parent.WS_menu.lUntitled = ':U 
      (IF p_oldFile = "" THEN 'true;':U ELSE 'false;':U) SKIP
    '  }':U SKIP
    '//--></SCRIPT>':U SKIP
    '</HEAD>':U SKIP
    '<BODY></BODY>':U SKIP
    '</HTML>':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

