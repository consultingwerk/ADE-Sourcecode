&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: rdoffr.p

Description:
    Read the contents of an HTML offset file at run time and create
    HTMOFF temp-table records.

Input Parameters:
    pFileName: Name of html or offset file to open.

Output Parameters:
   <None>

Author: D.M.Adams

Date Created:  June 1996
---------------------------------------------------------------------------- */
/*Copyright (c) by PROGRESS SOFTWARE CORPORATION. 1996 - AllRights Reserved. */

{ src/web/method/cgidefs.i }
{ src/web/method/htmoff.i }   /* Run time Web HTMOFF temp table              */

DEFINE INPUT PARAMETER pFileName AS CHARACTER NO-UNDO.

DEFINE VARIABLE endLine         AS INTEGER   NO-UNDO.
DEFINE VARIABLE endOffset       AS INTEGER   NO-UNDO.
DEFINE VARIABLE fileExt         AS CHARACTER NO-UNDO.
DEFINE VARIABLE htmlField       AS CHARACTER NO-UNDO.
DEFINE VARIABLE htmlFile        AS CHARACTER NO-UNDO.
DEFINE VARIABLE htmlTag         AS CHARACTER NO-UNDO.
DEFINE VARIABLE htmlType        AS CHARACTER NO-UNDO.
DEFINE VARIABLE offset-file     AS CHARACTER NO-UNDO.
DEFINE VARIABLE offset-token    AS CHARACTER NO-UNDO.
DEFINE VARIABLE offset-value    AS CHARACTER NO-UNDO.
DEFINE VARIABLE old-startLine   AS INTEGER   NO-UNDO.
DEFINE VARIABLE old-startOffset AS INTEGER   NO-UNDO.
DEFINE VARIABLE params          AS CHARACTER NO-UNDO.
DEFINE VARIABLE rslt            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE startLine       AS INTEGER   NO-UNDO.
DEFINE VARIABLE startOffset     AS INTEGER   NO-UNDO.
DEFINE VARIABLE wdtType         AS CHARACTER NO-UNDO.

/* Use this to turn debugging on after each line that is read in. 
   (i.e. rename no-DEBUG  to DEBUG) */
&SCOPED-DEFINE no-debug MESSAGE offset-token offset-value VIEW-AS ALERT-BOX.
&SCOPED-DEFINE debug false

/* Define preprocessors that allow this file to compile under WorkBench. */     
&IF "{&OPSYS}" = "MSDOS" &THEN
  &SCOPED-DEFINE WEB-NOTIFY WINDOW-CLOSE
  &SCOPED-DEFINE WEB-CURRENT-ENVIRONMENT ""
  &SCOPED-DEFINE WEB-FORM-INPUT ""
  &SCOPED-DEFINE WEB-EXCLUSIVE-ID "="
&ELSE
  &SCOPED-DEFINE WEB-NOTIFY WEB-NOTIFY
  &SCOPED-DEFINE WEB-CURRENT-ENVIRONMENT WEB-CONTEXT:CURRENT-ENVIRONMENT
  &SCOPED-DEFINE WEB-FORM-INPUT WEB-CONTEXT:FORM-INPUT
  &SCOPED-DEFINE WEB-EXCLUSIVE-ID WEB-CONTEXT:EXCLUSIVE-ID
&ENDIF

DEFINE STREAM _inp_line.

&if {&debug} &then
define stream debug.
output stream debug to aa-rdoffr.log.
&endif

/* Radio-set items may not be contiguous in the HTML and offset files.
   This temp-table keeps track of previously encountered radio-sets
   and the number of radio-items found so far. */
DEFINE TEMP-TABLE radio-sets NO-UNDO
  FIELD set-name  AS CHARACTER
  FIELD last-item AS INTEGER
  INDEX set-name IS PRIMARY set-name.

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

/* Look for offset file and generate it if not found. */
RUN webutil/_offsrch.p (pFileName,PROGRAM-NAME(2),INPUT-OUTPUT offset-file).

&if {&debug} &then
put stream debug unformatted
  "caller: " program-name(2) skip
  "pfilename: " pfilename skip
  "offset-file: " offset-file skip.
output stream debug close.
&endif

IF offset-file = ? THEN DO:
  RUN HtmlError IN web-utilities-hdl 
    (SUBSTITUTE("The offset file &1 was not found and could not be regenerated. [rdoffr.p]",pFileName)).
  RETURN "Error":U.
END.
  
INPUT STREAM _inp_line FROM VALUE(offset-file) NO-ECHO.

/* Repeat the following block for each offset line. */
main-loop:
REPEAT:
  ASSIGN 
    offset-token = ""
    offset-value = "".
    
  IMPORT STREAM _inp_line offset-token offset-value.
  
  IF offset-token = "htm-file=":U THEN DO: /* set HTML filename */
    ASSIGN htmFname = TRIM(offset-value).
    NEXT main-loop.
  END.
  
  IF offset-token = "version=":U THEN DO: /* version mismatch */
    /* put error processing here */
    NEXT main-loop.
  END.
  
  IF NOT offset-token MATCHES "field[*]=":U THEN NEXT main-loop.

  ASSIGN 
    htmlField   = ENTRY(1,offset-value)
    htmlTag     = ENTRY(2,offset-value)
    htmlType    = ENTRY(3,offset-value)
    wdtType     = ENTRY(4,offset-value)
    startLine   = INTEGER(ENTRY(5,offset-value))
    startOffset = INTEGER(ENTRY(6,offset-value))
    endLine     = INTEGER(ENTRY(7,offset-value))
    endOffset   = INTEGER(ENTRY(8,offset-value))
    .
  
  IF wdtType = "RADIO-SET":U THEN DO:
    FIND FIRST radio-sets WHERE set-name = htmlField NO-ERROR.
    IF NOT AVAILABLE radio-sets THEN DO:
      CREATE radio-sets.
      ASSIGN radio-sets.set-name = htmlField.
    END.
    ASSIGN radio-sets.last-item = radio-sets.last-item + 1.
  END.

  CREATE HTMOFF.
  ASSIGN
    HTMOFF.HTM-NAME  = htmlField
    HTMOFF.HTM-TAG   = htmlTag
    HTMOFF.HTM-TYPE  = htmlType
    HTMOFF.WDT-TYPE  = wdtType
    HTMOFF.ITEM-CNT  = radio-sets.last-item WHEN wdtType = "RADIO-SET":U
    HTMOFF.BEG-LINE  = startLine
    HTMOFF.BEG-BYTE  = startOffset
    HTMOFF.END-LINE  = endLine
    HTMOFF.END-BYTE  = endOffset
    .
END.  /* main-loop */

INPUT STREAM _inp_line CLOSE.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* rdoffr.p - end of file */
