&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------
  File: pplist.w
  
  Description: List an Agent's persistent procedures 

  Parameters:  <none>

  Updated: 08/21/96 wood@progress.com
             Initial version
           01/08/97 nhorn@progress.com
             Clean up HTML, add "time remaining" info for web-state
           08/28/01 adams@progress.com
             Substitute "-" for missing types, add sort order radio set
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttProc
  FIELD cObject    AS CHARACTER
  FIELD iSequence  AS INTEGER
  FIELD cType      AS CHARACTER
  FIELD cState     AS CHARACTER
  FIELD dPeriod    AS DECIMAL
  INDEX iSequence  IS PRIMARY iSequence
  INDEX cObject cObject.

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebTool


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSort     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStack    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWebState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dPeriod   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dWebTime  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hProc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
  /* Standard Header */
  {&OUT} 
    {webtools/html.i
      &AUTHOR   = "D.M.Adams"
      &FRAME    = "WS_main" 
      &TITLE    = "Object State"
      &SEGMENTS = "head,open-body,title-line"  
      &CONTEXT  = "{&Webtools_Persistent_Objects_Help}" }.

  ASSIGN
    cPath  = IF get-value("order":U) = "path":U THEN "CHECKED":U ELSE ""
    cStack = IF get-value("order":U) = "stack":U OR 
                get-value("order":U) = "" THEN "CHECKED":U ELSE ""
    cSort  = IF cPath = "CHECKED":U THEN " BY ttProc.cObject" ELSE ""
    hProc  = SESSION:FIRST-PROCEDURE.

  /* Output a Table for the Persistent Procedures. */
  {&OUT} 
    '<CENTER><BR>~n':U
    '<SCRIPT LANGUAGE="javascript1.2"><!--~n':U
    'function fCheck() ~{~n':U
    '  var rStack = document.forms[0].order[0]~;~n':U
    '  var rPath  = document.forms[0].order[1]~;~n':U
    '  if ((rStack.checked != rStack.defaultChecked) ||~n':U
    '      (rPath.checked != rPath.defaultChecked)) ~{~n':U
    '    document.form.submit()~;~n':U
    '  }~n':U
    '}~n':U
    '--></SCRIPT>~n':U
    '<FORM NAME="form" ACTION="pplist.w">':U
    '<TABLE':U get-table-phrase('') '>~n':U
    '<TR BGCOLOR="#CCFFFF">~n':U
    '  <TD COLSPAN="3" ALIGN="center">':U
    format-label ('Sort Order:', 'COLUMN':U, '') '~n':U
    '    <INPUT TYPE="radio" NAME="order" VALUE="stack" ':U cStack '~n':U
    '      onClick="fCheck()">':U 'Stack' '~n':U
    '    <INPUT TYPE="radio" NAME="order" VALUE="path" ':U cPath '~n':U
    '      onClick="fCheck()">':U 'Path' '~n':U
    '  </TD>~n':U
    '</TR>~n':U
    '<TR>~n':U
    '  <TH ALIGN="left">':U format-label ('Web Object', "COLUMN":U, "") '</TH>~n':U
    '  <TH>':U format-label ('Type', "COLUMN":U, "":U) '</TH>~n':U
    '  <TH>':U format-label ('Web-State', "COLUMN":U, "") '<BR>':U
               format-text('(Time Left)', 'HighLight':U) '</TH>~n':U
    '</TR>~n':U.
 
  DO WHILE VALID-HANDLE (hProc):
    RUN get-attribute IN hProc ('web-state':U) NO-ERROR.
    cWebState = IF ERROR-STATUS:ERROR THEN "-":U ELSE RETURN-VALUE.
    /*
    /* This is a workaround until 'getObjectType' works in the super procs */
    IF h:file-name begins "adm2/":U
    OR h:file-name begins "web2/":U THEN
      ASSIGN
        cType     = "Super Procedure":U 
        cWebState = IF cWebState = "-" THEN "persistent":U ELSE cWebState.
                
    ElSE */
    IF CAN-DO(hProc:INTERNAL-ENTRIES,'getObjectType':U) THEN  
      ASSIGN
        cType = DYNAMIC-FUNCTION('getObjectType':U IN hProc)
        cType = IF cType = "SUPER":U THEN "Super-Procedure" ELSE cType NO-ERROR.
    ELSE DO:    
      RUN get-attribute IN hProc ('Type':U) NO-ERROR.
      cType = IF ERROR-STATUS:ERROR THEN "-":U ELSE RETURN-VALUE.
    END.
    ASSIGN
      cWebState = IF cWebState = "-":U THEN "persistent":U ELSE cWebState
      cType     = IF cType = "" THEN "-":U ELSE cType.
    
    IF cWebState EQ 'State-Aware':U THEN DO:
      RUN get-attribute IN hProc ('Web-Time-Remaining':U) NO-ERROR.
      dWebTime = IF ERROR-STATUS:ERROR THEN ? ELSE DECIMAL(RETURN-VALUE).
    END.

    CREATE ttProc.
    ASSIGN
      iCount            = iCount + 1
      ttProc.cObject    = hProc:FILE-NAME
      ttProc.iSequence  = iCount
      ttProc.cType      = cType
      ttProc.cState     = cWebState
      ttProc.dPeriod    = dWebTime.
  
    hProc = hProc:NEXT-SIBLING.
  END.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(BUFFER ttProc:HANDLE).
  hQuery:QUERY-PREPARE('FOR EACH ttProc NO-LOCK ' + cSort).
  hQuery:QUERY-OPEN() NO-ERROR.

  REPEAT:
    hQuery:GET-NEXT.
    IF hQuery:QUERY-OFF-END THEN DO:
      DELETE OBJECT hQuery. /* no memory leaks here... */
      LEAVE.
    END.

    {&OUT} 
      "<TR><TD>":U ttProc.cObject "</TD>":U
      "<TD><CENTER>":U ttProc.cType "</CENTER></TD>":U
      "<TD><CENTER>":U ttProc.cState .
	  
    IF (ttProc.cState EQ 'State-Aware':U) AND (ttProc.dPeriod NE ?) THEN
      {&OUT} '<BR>':U
         format-text ('(':U + STRING(ttProc.dPeriod, 
           (IF ttProc.dPeriod > 2 THEN ">>>,>>>,>>9":U 
            ELSE ">>>,>>>,>>9.99":U) ) + ' min.~)', "HighLight":U)
         '</CENTER></TD></TR>~n':U.
    ELSE
      {&OUT} "</TD></TR>~n":U.
  END.
  
  {&OUT} 
    '</TABLE>~n':U
    '</FORM>~n':U
    '</CENTER>~n':U
    '</BODY>~n':U
    '</HTML>~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
 

