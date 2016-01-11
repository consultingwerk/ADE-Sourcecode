&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

File: _offsrch.w

Description:
    Find and generate the offset file if necessary

Input Parameters:
    pWebfile:     Name of html file to generate the offset file for 
                    (or base name of file without file extension)
                  For example:
                    ncust-wo                  /* V1 style */
                    shopping/ncust-wo.html    /* V2 Style */

    pOffsetFile:  Name of offset file, if we know it
                        
    pRunName:     Name of Web object, for example
                    shopping/ncust-wo.r       /* at runtime */
                    shopping/ncust-wo.w       /* at design time */

Output Parameters:
    pOffsetFile:  Full path of offset file

Author:  D.M.Adams
Created: March 1997
---------------------------------------------------------------------------- */
&IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
{ src/web/method/cgidefs.i }
&ENDIF
{ webutil/tagextr.i }

DEFINE INPUT        PARAMETER pWebFile    AS CHARACTER NO-UNDO. /* WEB-FILE   */
DEFINE INPUT        PARAMETER pRunName    AS CHARACTER NO-UNDO. /* procedure file */
DEFINE INPUT-OUTPUT PARAMETER pOffsetFile AS CHARACTER NO-UNDO. /* offset file */

/* ***************************  Definitions  ************************** */
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cNewLine        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER NO-UNDO.
DEFINE VARIABLE file-ext        AS CHARACTER NO-UNDO.
DEFINE VARIABLE file-name       AS CHARACTER NO-UNDO.
DEFINE VARIABLE html-file       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-scrap         AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE offset-file     AS CHARACTER NO-UNDO.
DEFINE VARIABLE proc-file       AS CHARACTER NO-UNDO. /* web object, not used */
DEFINE VARIABLE rslt            AS LOGICAL   NO-UNDO.

&SCOPED-DEFINE debug FALSE    
&IF {&debug} &THEN
DEFINE STREAM debug.
OUTPUT STREAM debug TO _offsrch.log APPEND.
&ENDIF

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

&IF {&debug} &THEN
PUT STREAM debug UNFORMATTED SKIP(1)
  "pOffsetFile #1 " pOffsetFile SKIP
  "pWebFile       " pWebFile SKIP
  "pRunName       " pRunName SKIP.
&ENDIF

IF SEARCH(pOffsetFile) = ? THEN DO:
  CASE file-ext:
    WHEN ".off":U THEN
      offset-file = pWebFile.
    WHEN ".htm":U OR WHEN ".html":U THEN
      offset-file = SUBSTRING(pWebFile,1,R-INDEX(pWebFile,".":U),"CHARACTER":U) + "off":U.
    WHEN "" THEN
      offset-file = pWebFile + ".off":U.

    /* Unknown file extension, so raise error and return. */
    OTHERWISE DO:
      &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
      RUN HtmlError IN web-utilities-hdl
        (SUBSTITUTE("The file extension '&1' is invalid. Expected .htm, .html, or .off. [_offsrch.p]",
                    file-ext)).
      &ELSE
      MESSAGE 
        SUBSTITUTE("The file extension '&1' is invalid. Expected .htm, .html, or .off. [_offsrch.p]",
                   file-ext)
        VIEW-AS ALERT-BOX.
      &ENDIF

      &IF {&debug} &THEN
      OUTPUT STREAM debug CLOSE.
      &ENDIF
      RETURN "Error":U.
    END.
  END.
END.
ELSE
  offset-file = pOffsetFile.

/* Look for file as given. */
ASSIGN
  pOffsetFile = SEARCH(offset-file)
  pRunName    = ENTRY(NUM-ENTRIES(pRunName," ":U),pRunName," ":U) 
                 WHEN NUM-ENTRIES(pRunName," ":U) > 0.

&IF {&debug} &THEN
PUT STREAM debug UNFORMATTED
  "pOffsetFile #2 " pOffsetFile SKIP
  "offset-file    " offset-file SKIP
  "pRunName       " pRunName SKIP.
&ENDIF

IF pOffsetFile = ? THEN DO:
  /* Strip path and look again. */
  RUN adecomm/_osprefx.p (offset-file, OUTPUT cPath, OUTPUT offset-file).
  pOffsetFile = SEARCH(offset-file).
  
  IF pOffsetFile = ? AND pRunName <> "" THEN DO:
    /* Look for file with the Web object (.w extension). */
    ASSIGN
      FILE-INFO:FILE-NAME = pRunName
      proc-file           = FILE-INFO:FULL-PATHNAME
      file-name           = SUBSTRING(proc-file,1,R-INDEX(proc-file,".":U),
                              "CHARACTER":U) + "off":U
      pOffsetFile         = SEARCH(file-name)
      .
      
    /* Look for file with the Web object (.r extension). */
    IF pOffsetfile = ? THEN
    ASSIGN
      FILE-INFO:FILE-NAME = SUBSTRING(pRunName,1,R-INDEX(pRunName,".":U),
                              "CHARACTER":U) + "r":U
      proc-file           = FILE-INFO:FULL-PATHNAME
      file-name           = SUBSTRING(proc-file,1,R-INDEX(proc-file,".":U),
                              "CHARACTER":U) + "off":U
      pOffsetFile         = SEARCH(file-name)
      .
  END.
END.

&IF {&debug} &THEN
PUT STREAM debug UNFORMATTED
  "pOffsetFile #3 " pOffsetFile SKIP
  "proc-file      " proc-file SKIP
  "file-name      " file-name SKIP.
&ENDIF

/* Find HTML file first.  If we can't find it we're hosed.  _htmsrch.p 
   returns html-file with full path. */
RUN webutil/_htmsrch.p (pWebFile, pRunName, OUTPUT html-file).
IF pOffsetFile = ? THEN DO:
  IF html-file = ? THEN DO:
    &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
    RUN HtmlError IN web-utilities-hdl
      (SUBSTITUTE("The HTML file &1 cannot be found. [_offsrch.p]", html-file)).
    &ELSE
    MESSAGE 
      SUBSTITUTE("The HTML file &1 cannot be found. [_offsrch.p]", html-file)
      VIEW-AS ALERT-BOX.
    &ENDIF
    
    &IF {&debug} &THEN
    OUTPUT STREAM debug CLOSE.
    &ENDIF
    RETURN "Error":U.
  END.
END.

/* Found offset file, now check date/time against its HTML parent */
ELSE DO:
  IF file-ext = ".htm":U OR file-ext = ".html":U THEN
    ASSIGN
      FILE-INFO:FILE-NAME = SEARCH(pWebFile)
      html-file           = FILE-INFO:FULL-PATHNAME.
  ASSIGN
    FILE-INFO:FILE-NAME = pOffsetFile
    pOffsetFile         = FILE-INFO:FULL-PATHNAME.

  /* Note: TE_needToMakeOffsets needs a FULL path to each input file. */
  IF html-file ne ? THEN
    RUN TE_needToMakeOffsets (html-file, pOffsetFile, OUTPUT i-scrap).
END.

/* Generate offset file because we can't find it or because its date/time stamp
   is older than its parent HTML file. */

&IF {&debug} &THEN
PUT STREAM debug UNFORMATTED
  "pOffsetFile #4 " pOffsetFile SKIP
  "html-file      " html-file SKIP.
&ENDIF

IF pOffsetFile = ? OR i-scrap = 1 THEN DO:  
  RUN webutil/_genoff.p (html-file, OUTPUT pOffsetFile).
  /* Was the offset file generation successful? */
  IF RETURN-VALUE = "error":U THEN DO:
    &IF "{&WINDOW-SYSTEM}" EQ "TTY":U &THEN
    RUN HtmlError IN web-utilities-hdl
      ("The offset file was not successfully generated. [_offsrch.p]").
    &ELSE
    MESSAGE "The offset file was not successfully generated. [_offsrch.p]"
      VIEW-AS ALERT-BOX.
    &ENDIF
    
    &IF {&debug} &THEN
    OUTPUT STREAM debug CLOSE.
    &ENDIF
    RETURN "Error":U.
  END.
END.

&IF {&debug} &THEN
OUTPUT STREAM debug CLOSE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _offsrch.p - end of file */
