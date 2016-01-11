&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------
    File        : _runbrws.p
    Purpose     : Control a Web browser for running a Web object

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 
DEFINE INPUT PARAMETER p_Browser  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_URL      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_OpenNew  AS LOGICAL   NO-UNDO.
  
DEFINE VARIABLE cAppName   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cBrowser   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cFileBase  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cFileName  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE hFrame     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iInit      AS INTEGER       NO-UNDO.
DEFINE VARIABLE iURL       AS INTEGER       NO-UNDO.
DEFINE VARIABLE hWindow    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE oldhWindow AS WIDGET-HANDLE NO-UNDO.

&SCOPED-DEFINE debug FALSE

&IF {&debug} &THEN
DEFINE STREAM logstream.
OUTPUT STREAM logstream TO "dde.log":U.
PUT STREAM logstream
  "ID" FORMAT "x(2) ":U
  "ERR" FORMAT "x(3) ":U
  "NAME" FORMAT "x(8) ":U
  "TOPIC" FORMAT "x(18) ":U
  "ITEM" FORMAT "x(14)":U
  SKIP.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
CREATE WINDOW hWindow
  ASSIGN
    HIDDEN  = TRUE.

ASSIGN
  oldhWindow     = CURRENT-WINDOW
  CURRENT-WINDOW = hWindow.
  
CREATE FRAME hFrame
  ASSIGN
    VISIBLE = TRUE
    HIDDEN  = TRUE.
  
RUN adecomm/_osprefx.p (p_Browser, OUTPUT cFileBase, OUTPUT cFileName).
ASSIGN
  cBrowser = p_Browser
  cAppName = SUBSTRING(cFileName,1,R-INDEX(cFileName,".":U) - 1,"CHARACTER":U).

/* Test to see if web browser is already running by initiating a channel. */
DDE INITIATE iInit FRAME hFrame APPLICATION cAppName
  TOPIC "WWW_Activate" NO-ERROR. 
RUN logExchange.
  
/* Start Web browser if it's not already running or user wants to start a new 
   browser instance with each Web object RUN. */
IF iInit eq 0 OR p_openNew THEN DO:
  RUN WinExec (cBrowser + " " + p_URL, 1). 
  IF iInit ne 0 THEN DO:
    DDE TERMINATE iInit NO-ERROR. 
    Run logExchange.
  END.
END.
ELSE DO:
  /* Open the URL. */
  DDE INITIATE iURL FRAME hFrame APPLICATION cAppName
    TOPIC "WWW_OpenURL" NO-ERROR. 
  RUN logExchange.
  DDE EXECUTE iURL COMMAND p_URL TIME 0 NO-ERROR. 
  RUN logExchange.
  DDE TERMINATE iURL  NO-ERROR. 
  Run logExchange.
END.

&IF {&debug} &THEN
OUTPUT STREAM logstream CLOSE.
&ENDIF
DELETE WIDGET hWindow.
CURRENT-WINDOW = oldhWindow.

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEFINE INPUT PARAMETER prog_name  AS CHARACTER.
  DEFINE INPUT PARAMETER icon_style AS SHORT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logExchange Procedure 
PROCEDURE logExchange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &IF {&debug} &THEN
  CASE hFrame:DDE-ERROR:
    WHEN 1 THEN
      MESSAGE "DDE INITIATE failure."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 2 THEN
      MESSAGE "DDE statement (ADVISE, EXECUTE, GET, REQUEST, or SEND) timeout."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 3 THEN
      MESSAGE "Memory Allocation Error."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 4 THEN
      MESSAGE "Invalid channel number (not an open conversation)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 5 THEN
      MESSAGE "Invalid data item (in topic)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 6 THEN
      MESSAGE "DDE ADVISE failure (data link not accepted)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 7 THEN
      MESSAGE "DDE EXECUTE failure (commands not accepted)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 8 THEN
      MESSAGE "DDE GET failure (data not available)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 9 THEN
      MESSAGE "DDE SEND failure (data not accepted)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 10 THEN
      MESSAGE "DDE REQUEST failure (data not available)."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 11 THEN
      MESSAGE "Data for DDE-NOTIFY event not available."
        VIEW-AS ALERT-BOX ERROR.
    WHEN 99 THEN
      MESSAGE "Internal error (unknown)."
        VIEW-AS ALERT-BOX ERROR.
  END CASE.
  
  PUT STREAM logstream UNFORMATTED
    STRING(hFrame:DDE-ID,">9 ":U)
    STRING(hFrame:DDE-ERROR,">>9 ":U)
    hFrame:DDE-NAME FORMAT "x(8) ":U
    hFrame:DDE-TOPIC FORMAT "x(18) ":U
    hFrame:DDE-ITEM FORMAT "x(45)":U SKIP.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

