&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: _htmsrch.p

Description:
    Find the HTML file.

Input Parameters:
    pWebFile:     WEB-FILE file.  Could have .htm, .html, .off or no extension,
                  with or without path.
                  
    pFileName:    THIS-PROCEDURE:FILE-NAME.  The Web object file.

Output Parameters:
    pHtmlFile:    Full pathname

Author: D.M.Adams

Date Created:  March 1997
---------------------------------------------------------------------------- */
&IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
{ src/web/method/cgidefs.i }
&ENDIF

DEFINE INPUT  PARAMETER pWebfile  AS CHARACTER NO-UNDO. /* WEB-FILE */       
DEFINE INPUT  PARAMETER pFileName AS CHARACTER NO-UNDO. /* procedure file */
DEFINE OUTPUT PARAMETER pHtmlFile AS CHARACTER NO-UNDO. /* output file */

/* ***************************  Definitions  ************************** */
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-path      AS CHARACTER NO-UNDO.
DEFINE VARIABLE file-ext    AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-file1  AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-file2  AS CHARACTER NO-UNDO.
DEFINE VARIABLE rslt        AS LOGICAL   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

/* Get WEB-FILE file extension. */
RUN adecomm/_osfext.p (pWebFile,OUTPUT file-ext).

CASE file-ext:
  WHEN ".htm":U OR WHEN ".html":U THEN
    html-file1 = pWebFile.
  WHEN ".off":U OR WHEN ".w":U THEN
    ASSIGN
      html-file1 = SUBSTRING(pWebFile,1,R-INDEX(pWebFile,".":U),"CHARACTER":U) + "htm":U
      html-file2 = SUBSTRING(pWebFile,1,R-INDEX(pWebFile,".":U),"CHARACTER":U) + "html":U.
  WHEN "" THEN
    ASSIGN
      html-file1 = pWebFile + ".htm":U
      html-file2 = pWebFile + ".html":U.

  /* Unknown file extension, so raise error and return. */
  OTHERWISE DO:
    &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
    RUN HtmlError IN web-utilities-hdl 
      (SUBSTITUTE("The file extension '&1' is invalid. Expected .htm, .html, or .off. [_htmsrch.p]",
      file-ext)).
    &ELSE
    MESSAGE SUBSTITUTE("The file extension '&1' is invalid. Expected .htm, .html, or .off. [_htmsrch.p]",
            file-ext)
      VIEW-AS ALERT-BOX.
    &ENDIF
    RETURN "Error":U.
  END.
END.

/* Look for HTML based on WEB-FILE name */
RUN find-html (html-file1,pFileName,OUTPUT pHtmlFile).
IF pHtmlFile = ? AND html-file2 <> "" THEN DO:
  RUN find-html (html-file2,pFileName,OUTPUT pHtmlFile).

  IF SEARCH(pHtmlFile) = ? THEN DO:
    &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
    RUN HtmlError IN web-utilities-hdl ("Could not find the HTML file. [_htmsrch.p]").
    &ELSE
    MESSAGE "Could not find the HTML file. [_htmsrch.p]"
      VIEW-AS ALERT-BOX.
    &ENDIF
    RETURN "Error":U.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-html
PROCEDURE find-html:
  DEFINE INPUT  PARAMETER file-name  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER proc-file  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER full-path  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE html-file AS CHARACTER NO-UNDO.
  
  /* Look for file as given. */
  full-path = SEARCH(file-name).
  IF full-path = ? THEN DO:
    /* Strip path and look again. */
    RUN adecomm/_osprefx.p (file-name,OUTPUT c-path,OUTPUT file-name).
    full-path = SEARCH(file-name).
    
    IF full-path = ? AND proc-file <> "" THEN DO:
      /* Look for file with the web object. Note that the passed in filename is the name of
         THIS-PROCEDURE:FILE-NAME, which will be, for example, "detail.w".  This file might
         not be there at deployment when only r-code exists. So look for r-code if the actual
         FILE-NAME is not there. */
      RUN adecomm/_rsearch.p (pFileName, OUTPUT proc-file).
      ASSIGN
        FILE-INFO:FILE-NAME = proc-file
        proc-file           = FILE-INFO:FULL-PATHNAME
        .
      /* If still not found, try the FILE-NAME as given. */
      IF proc-file eq ? THEN proc-file = pFileName.
      ASSIGN
        file-name           = SUBSTRING(proc-file,1,R-INDEX(proc-file,".":U),"CHARACTER") + "htm":U 
        full-path           = SEARCH(file-name)
        .
    END.
  END.
  
  ASSIGN
    FILE-INFO:FILE-NAME = full-path
    full-path           = FILE-INFO:FULL-PATHNAME.
  
END PROCEDURE.
  
&ANALYZE-RESUME

/* _htmsrch.p - end of file */
