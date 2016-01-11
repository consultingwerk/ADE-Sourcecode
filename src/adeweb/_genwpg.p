&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------
      File        : _genwpg.p
    Purpose     : Generate Embedded HTML page from .dat    
 
    Syntax      : 

    Description : Runs persistent from wizards and sends and receives data 
                  to and from wizard page objects.  

    Author(s)   : Haavard Danielsen
    Created     : July 98
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE NEW SHARED STREAM webstream.   

{adeuib/uniwidg.i}
{adeuib/brwscols.i}


DEFINE SHARED VARIABLE _suppress_dbname AS LOGICAL NO-UNDO.

DEFINE VARIABLE cInfo            AS CHARACTER NO-UNDO. 
DEFINE VARIABLE gFuncLibHdl      AS HANDLE    NO-UNDO. 
DEFINE VARIABLE gLastPreviewName AS CHARACTER NO-UNDO. 
DEFINE VARIABLE gRemote          AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE gWizardHdl       AS HANDLE    NO-UNDO. 

/* Data that is used in the wizard */ 
DEFINE TEMP-TABLE _PAGE 
FIELD ColumnList         AS CHAR
FIELD DataObject         AS CHAR INIT ?
FIELD ForeignFields      AS CHAR
FIELD ExternalJoin       AS CHAR
FIELD ExternalDispNames  AS CHAR
FIELD ExternalTypes      AS CHAR
FIELD ExternalWhere      AS CHAR
FIELD ProcID             AS INTEGER 
FIELD PageTitle          AS CHAR
FIELD UseSearchForm      AS LOG 
FIELD UseNavigationPanel AS LOG INIT TRUE
FIELD UseColumnHeadings  AS LOG INIT TRUE
FIELD UseAdd             AS LOG INIT TRUE
FIELD UseDelete          AS LOG INIT TRUE
FIELD UseReset           AS LOG INIT TRUE
FIELD UseSubmit          AS LOG INIT TRUE
FIELD UseCancel          AS LOG INIT TRUE
FIELD TableRows          AS INT INIT 10 
FIELD TableBorder        AS INT INIT 2
FIELD Tables             AS CHAR INIT ?
FIELD PageBackground     AS CHAR
FIELD TableBackground    AS CHAR
FIELD SearchColumns      AS CHAR
FIELD TargetFrame        AS CHAR INIT '_self':U 
FIELD StatusLine         AS CHAR  
FIELD LinkColumn         AS CHAR  
FIELD WebObject          AS CHAR  
FIELD JoinLink           AS LOG  INIT TRUE  
FIELD JoinColumns        AS CHAR /* Extend this in 9.0B 
                                    setField sets it from JoinLink */
FIELD PageBgRed          AS INT INIT ?
FIELD PageBgGreen        AS INT INIT ?
FIELD PageBgBlue         AS INT INIT ?
FIELD StyleSheet         AS CHAR
FIELD TableBgRed         AS INT INIT ?
FIELD TableBgGreen       AS INT INIT ?
FIELD TableBgBlue        AS INT INIT ?.

DEFINE TEMP-TABLE _FrameField 
  FIELD Hdl  AS HANDLE 
  FIELD Name AS CHAR
  INDEX Name AS UNIQUE Name. 
   
DEFINE FRAME Page-frm 
  _PAGE WITH SIDE-LABELS.

DEFINE STREAM InSTREAM.
DEFINE STREAM OutSTREAM.

DEFINE NEW GLOBAL SHARED VAR OEIDEIsRunning AS LOGICAL    NO-UNDO.

FUNCTION getFuncLibHandle RETURNS HANDLE
  (  )  IN SOURCE-PROCEDURE.

FUNCTION get-sdo-hdl RETURNS HANDLE  
 (pName     AS CHAR,
  pOwnerHdl AS HANDLE) IN gFuncLibHdl.

{adecomm/rtnval.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-BgColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BgColor Procedure 
FUNCTION BgColor RETURNS CHARACTER
  (pRed   AS INT,
   pGreen AS INT,
   pBlue  AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EmbeddedExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EmbeddedExpression Procedure 
FUNCTION EmbeddedExpression RETURNS CHARACTER
  (pField AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genOverrideDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD genOverrideDelete Procedure 
FUNCTION genOverrideDelete RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genValidationFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD genValidationFrame Procedure 
FUNCTION genValidationFrame RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getField Procedure 
FUNCTION getField RETURNS CHARACTER
  (pField AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHexValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHexValue Procedure 
FUNCTION getHexValue RETURNS CHARACTER
(INPUT asc-value AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Hex2Dec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Hex2Dec Procedure 
FUNCTION Hex2Dec RETURNS DECIMAL
 (INPUT Hexvalue AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLAttribute Procedure 
FUNCTION HTMLAttribute RETURNS CHARACTER
  (pAttrName  AS CHAR,
   pFieldName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLTagLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLTagLink Procedure 
FUNCTION HTMLTagLink RETURNS CHARACTER
  (pTag  AS CHAR,
   pLink AS CHAR,
   pAttr AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD instanceProperties Procedure 
FUNCTION instanceProperties RETURNS CHARACTER
  (pcVarName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-overrideColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD overrideColumns Procedure 
FUNCTION overrideColumns RETURNS CHARACTER
  ( pAttr AS CHAR /* attribute to check */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReadFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ReadFile Procedure 
FUNCTION ReadFile RETURNS LOGICAL
  (pName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDbref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeDbref Procedure 
FUNCTION removeDbref RETURNS CHARACTER
  (pString AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeTableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeTableFields Procedure 
FUNCTION removeTableFields RETURNS CHARACTER
  (pcColumns AS CHAR,
   pcTables AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setField Procedure 
FUNCTION setField RETURNS LOGICAL
  ( pcField AS CHAR,
    pcValue AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 14.95
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* Create the Temp-table record. */
CREATE _PAGE.

ON CLOSE OF THIS-PROCEDURE DO:
  RUN DestroyObject.
END.

/* Tell the wizard NOT to exit normally */ 
DYNAMIC-FUNCTION ('setCancelOnFinish':U IN SOURCE-PROCEDURE, TRUE).

/* Tell the wizard to allow for preview on the last page  */
DYNAMIC-FUNCTION ('setPreview':U IN SOURCE-PROCEDURE, TRUE).

/* The _wizard.w publishes this when the finish button is pressed */
SUBSCRIBE "ab_WizardFinished":U IN SOURCE-PROCEDURE.

/* The _wizend.w publishes this when preview is pressed
   ANYWHERE is used because we don't know the handle at this moment */
SUBSCRIBE "ab_WizardPreview":U ANYWHERE.

/* The _datasrc.w publishes this when a datasource is changed */
SUBSCRIBE "ab_dataSourceRemoved":U ANYWHERE.

RUN adeuib/_uibinfo.p(?,'SESSION':U,'REMOTE', OUTPUT cinfo).
  
ASSIGN
  gRemote      = cInfo EQ "TRUE":U
  gFuncLibHdl  = getFuncLibHandle()
  gWizardHdl   = SOURCE-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ab_dataSourceRemoved) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ab_dataSourceRemoved Procedure 
PROCEDURE ab_dataSourceRemoved :
/*------------------------------------------------------------------------------
  Purpose:  Clean up design time data when a dataSource is changed.    
  Parameters:  prId      recid(_P)
               pcTables  Comma separated list of fully qualified tables 
                         "*"  for all
  Notes: published from _datasrc.w                 
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER prID     AS RECID     NO-UNDO.
  DEF INPUT PARAMETER pcTables AS CHARACTER NO-UNDO.
  
  DEF VAR iTbl         AS INTEGER NO-UNDO.
  DEF VAR iCol         AS INTEGER NO-UNDO.
  DEF VAR cColumn      AS CHAR NO-UNDO.
  DEF VAR cTablePrefix AS CHAR NO-UNDO.
  
  IF _Page.Procid = INT(prId) THEN 
  DO:
    ASSIGN
      ForeignFields     = "":U
      ExternalJoin      = "":U
      ExternalDispNames = "":U
      ExternalTypes     = "":U
      ExternalWhere     = "":U.
     
    IF pcTables = "*" THEN
    DO:
      Assign 
        LinkColumn    = "":U
        SearchColumns = "":U
        JoinColumns   = IF JoinColumns = "ROWID":U OR JoinColumns = "" 
                        THEN JoinColumns
                        ELSE "":U.                         
    END. /* pctable = "*" */
    ELSE 
      ASSIGN
        pcTables      = removeDbref(pcTables)
        LinkColumn    = removeTablefields(linkColumn,pcTables)
        SearchColumns = removeTablefields(SearchColumns,pcTables)
        JoinColumns   = removeTablefields(JoinColumns,pcTables).
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ab_WizardFinished) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ab_WizardFinished Procedure 
PROCEDURE ab_WizardFinished :
/*------------------------------------------------------------------------------
  Purpose: Run when the wizard is finished      
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName    AS CHAR NO-UNDO.  
  DEFINE VARIABLE cTmpFileName AS CHAR NO-UNDO.  
  DEFINE VARIABLE cBrokerUrl   AS CHAR NO-UNDO.  
  DEFINE VARIABLE cEditOption  AS CHAR NO-UNDO.  
  
  IF gLastPreviewName <> "" AND NOT gRemote THEN 
    cFileName = gLastPreviewName.
  ELSE DO:    
    RUN adecomm/_tmpfile.p ("ws":U, IF OEIDEIsRunning THEN ".html":U ELSE ".tmp":U, OUTPUT cTmpFileName).
    cFileName = cTmpFileName.
  END.  
  
  RUN GenerateHTML(cFileName).
  
  IF gLastPreViewName <> "" THEN 
  DO:
    IF gRemote THEN
      RUN adeuib/_uibinfo.p (?, "SESSION":U, "BrokerUrl":U, OUTPUT cBrokerUrl).
  
    ASSIGN
      cEditOption  = "":U
      cFileName    = gLastPreviewName 
                      
                      /* Procedure Window remote info */ 
   
                     + IF cBrokerURL <> "":U THEN                      
                       (CHR(3) 
                        + cTmpFileName 
                        + CHR(3)
                        + cBrokerURL)
                       ELSE "":U.
    
  END. /* if glastpreview <> '' */ 
  ELSE
    ASSIGN 
     cEditOption = "UNTITLED":U.
     
  /* Send the generated file to the Procedure Window */
  RUN adecomm/_pwmain.p ("_ab.p":U, cFileName, cEditOption).
                       
  OS-DELETE VALUE(cTmpFileName).
  
  /* Yes, we are finished */
  RUN DestroyObject.                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ab_wizardPreview) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ab_wizardPreview Procedure 
PROCEDURE ab_wizardPreview :
/*----------------------------------------------------------------------------
  Purpose:  Logic to preview the embedded HTML speedscript    
  Parameters:  
  Notes:    Compile is always done remotely, because the proc that converts
            HTML to 4GL uses a method on the WEB-CONTEXT handle, only available
            on the WebSpeed agent.  Subsequently Save As also checks remotely.
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pFileName AS CHAR NO-UNDO.  
  
  DEF VAR cBrokerURL   AS CHAR NO-UNDO.  
  DEF VAR cCodeFile    AS CHAR NO-UNDO.  
  DEF VAR cSourceName  AS CHAR NO-UNDO.  
  DEF VAR cTmpFileName AS CHAR NO-UNDO.  
  DEF VAR cRelFile     AS CHAR NO-UNDO.  
  DEF VAR lOK          AS LOG  NO-UNDO.  
   
  RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cTmpFileName).
    
  /* If remote we generate the HTML in the tempfile */
  IF gRemote THEN 
  DO:
    cCodeFile = cTmpFileName.
    RUN adeuib/_uibinfo.p(?, "SESSION":U, "BrokerURL":U, OUTPUT cBrokerURL).
  END.

  /* If local we generate the HTML directly in the pfilename. */
  ELSE    
    ASSIGN 
      cCodeFile = pFileName.

  lOK = TRUE.
  
  /* Check if the file (.html) or .w source exists. */
  IF gLastPreviewName <> pFileName THEN
  DO:
    RUN fileExists(pFileName, gRemote, cBrokerURL, cTmpFileName, OUTPUT lOk).
    
    IF lOk THEN
    DO:
      /* Check for the .w file */
      cSourceName = SUBSTRING(pFileName,1,R-INDEX(pFileName,".":U)) + "w":U.
      RUN fileExists(cSourceName, gRemote, cBrokerURL, cTmpFileName, OUTPUT lOk).
    END. /* if lok */
  END. /* lastname <> input name */
  
  IF lOK THEN
  DO:
    /* Write to a local file. */
    RUN GenerateHTML(cCodeFile).

    IF gRemote THEN DO:
      RUN adeweb/_webcom.w (?, 
                            cBrokerURL, 
                            pFileName, 
                            "save":U, 
                            OUTPUT cRelfile, 
                            INPUT-OUTPUT cTmpFileName).

      /* Show save errors. */
      IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
        RUN returnValue ( RETURN-VALUE, pFileName, "saved", OUTPUT lOK ).
        RETURN.
      END.
    END.
    
    /* Add file to mru filelist. */
    RUN adeshar/_mrulist.p (pFileName, (IF gRemote THEN cBrokerURL ELSE "":U)).
    
    /* 'Compile' converts the .html to .w and compiles it to rcode. */ 
    IF NOT gRemote THEN
    DO:
      RUN compileE4gl(pFileName, OUTPUT lok).      
    END.
    ELSE DO:
      RUN adeweb/_webcom.w (?, 
                            cBrokerURL, 
                            pFileName, 
                            "compile":U, 
                            OUTPUT cRelfile, 
                            INPUT-OUTPUT cTmpFileName).
      /* Show compile errors. */
      IF RETURN-VALUE BEGINS "ERROR:":U THEN 
        RUN returnValue ( RETURN-VALUE, pFileName, "compiled":U, OUTPUT lOK ).
    END.

    IF lOK THEN 
      /* Start WebBrowser with the file */  
      RUN adeweb/_abrunwb.p (pFileName). 
      
    gLastPreviewName = pFileName.
  END. /* if lok */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compileE4gl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileE4gl Procedure 
PROCEDURE compileE4gl :
/*------------------------------------------------------------------------------
  Purpose: local compile of embedded speedscript html     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName AS CHAR   NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk       AS LOG    NO-UNDO.

  DEFINE VARIABLE cOptions     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cCompileFile AS CHAR   NO-UNDO.
  
  /**
  RUN adecomm/_osfext.p (cRelName, OUTPUT cFileExt).
  IF cFileExt eq ".htm":U OR cFileExt eq ".html":U THEN DO:
  **/
   
  /* Convert HTML files to SpeedScript. */
  RUN webutil/e4gl-gen.p (pcFileName,
                           INPUT-OUTPUT cOptions, 
                           INPUT-OUTPUT cCompileFile).
      
  /* Don't compile if we're processing an Embedded SpeedScript file and
     the "no-compile" option exists. */
  IF NOT CAN-DO(cOptions,"no-compile":U) THEN
  DO ON ERROR UNDO, LEAVE:
    COMPILE VALUE(cCompileFile) SAVE.
    plOk = TRUE.
  END.
  ELSE
    MESSAGE  "The HTML file has a 'no-compile' option and was not compiled"
    VIEW-AS ALERT-BOX. 
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DestroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DestroyObject Procedure 
PROCEDURE DestroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DElETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FileExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FileExists Procedure 
PROCEDURE FileExists :
/*------------------------------------------------------------------------------
  Purpose:   Check if file exists  
  Parameters: pcfilename  -  
              plremote    - yes if remote 
              pcBrokerurl - url for remote
              pctempfile  - tempfile for remote operation
       output plok        - yes to continue 
  Notes:      Called from ab_preview to check .html and .w  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHAR   NO-UNDO.
  DEFINE INPUT  PARAMETER plRemote    AS LOG    NO-UNDO.
  DEFINE INPUT  PARAMETER pcBrokerURL AS CHAR   NO-UNDO.
  DEFINE INPUT  PARAMETER pcTempFile  AS CHAR   NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk        AS LOG    NO-UNDO.
  
  DEFINE VARIABLE cRelFile AS CHAR   NO-UNDO.
  
  plOk = TRUE.

  IF NOT plRemote THEN
  DO:
    IF SEARCH(pcFileName) <> ? THEN
    DO:
      plOk = FALSE.
      MESSAGE pcFileName "already exists." SKIP
             "Do you want to replace it?"
      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE plOk.
    END.
  END.
  ELSE DO:
    RUN adeweb/_webcom.w (?, 
                          pcBrokerURL, 
                          pcFileName, 
                          "SaveAs:OkToSave":U, 
                          OUTPUT cRelfile, 
                          INPUT-OUTPUT pcTempFile).
    IF RETURN-VALUE BEGINS "ERROR:":U THEN
      RUN returnValue ( RETURN-VALUE, pcFileName, "save":U, OUTPUT plOK ).
  END. /* else (= Remote) */  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GenerateHTML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GenerateHTML Procedure 
PROCEDURE GenerateHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pFileName AS CHAR NO-UNDO.
 
 OUTPUT STREAM OutStream TO VALUE(pFileName). 

 ReadFile(getField('HTMLTemplate':U)).

 OUTPUT STREAM OutStream CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-BgColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BgColor Procedure 
FUNCTION BgColor RETURNS CHARACTER
  (pRed   AS INT,
   pGreen AS INT,
   pBlue  AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Return HTML formatted HEX color based on red green and blue value 
    Notes: Return '' if one of the values is unknown (default)  
------------------------------------------------------------------------------*/
  DEF VAR cRed   AS CHAR NO-UNDO.
  DEF VAR cGreen AS CHAR NO-UNDO.
  DEF VAR cBlue  AS CHAR NO-UNDO.
    
  IF pRed = ? OR pGreen = ? OR pBlue = ? THEN
    RETURN '':U.
  ELSE
    RETURN
      '#':U + GetHexValue(pRed) + GetHexValue(pGreen) + GetHexValue(pBlue).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EmbeddedExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EmbeddedExpression Procedure 
FUNCTION EmbeddedExpression RETURNS CHARACTER
  (pField AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: In order to support the ability to use Embedded SpeedScript Expressions
           in the wizards, we must replace the tags with quote and + if this variable 
           is placed inside a Embedded Speed script and is not translated by 
           e4gl-gen.p.                        
          
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cString  AS CHAR  NO-UNDO.
  
  /* Start tag is replaced with quote and + */ 
  DEF VAR cOpen    AS CHAR INIT "~" + ":U NO-UNDO.
  
  /* Close tag is replaced with + and quote */   
  DEF VAR cClose   AS CHAR INIT " + ~"":U NO-UNDO.
  DEF VAR iPos     AS INT  NO-UNDO.  
  DEF VAR iCnt     AS INT  NO-UNDO.  
  DEF VAR lOpen    AS LOG  NO-UNDO.  
 
  ASSIGN
    cString = getField(pField)  
    cString = REPLACE(cString,"<%=":U,cOpen)
    cString = REPLACE(cString,"<!--WSE":U,cOpen)  
    cString = REPLACE(cString,"~{=":U,cOpen)
    cString = REPLACE(cString,"%>":U,cClose)
    cString = REPLACE(cString,"-->":U,cClose)  
    cString = REPLACE(cString,"=~}":U,cClose).
            
  /* There's no way to see to check the difference between open and close,
     so we replace backticks one by one */
  DO WHILE TRUE:
    iPos = INDEX(cString,"`").
    IF iPos > 0 THEN
    DO:
      ASSIGN
       lOpen = NOT lOpen
       iCnt  = ICnt + 1.  
      SUBSTRING(cString,iPos,1) = IF lOpen THEN cOpen ELSe cCLose.
    END.
    ELSE LEAVE.    
  END.
  
  RETURN  "~"" + cString + "~"".   
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genOverrideDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION genOverrideDelete Procedure 
FUNCTION genOverrideDelete RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValExp    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDb        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbTable   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDelTables AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDef       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.

  ASSIGN cTables = getField('dbTables').
  
  DO i = 1 TO NUM-ENTRIES(cTables):
    ASSIGN cDbTable = ENTRY(i,cTables)
           cDb      = ENTRY(1,cDbTable,".":U)
           cTable   = ENTRY(2,cDbTable,".":U).
    
    /* CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(cDb)).
       Should create ALIAS off the schema holder, not logical, database
       name. Bug 19991108-032 (dma) */
    CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME(cDb)).
    RUN adecomm/_s-schem.p (cDb,
                            cTable,
                            "*":U,
                            "FILE:VALEXP":U,
                             OUTPUT cValExp).
 
    IF cValExp <> ? THEN 
      ASSIGN
        cDelTables = cDelTables 
                   + (IF cDelTables = "":U THEN "":U ELSe ",":U)
                   + cDbTable.
  END. /* do i = 1 to num-entries(cTables) */
    
  IF cDelTables <> "":U THEN DO:  
    ASSIGN
      CDef =   "/* Tables with schema validation can only be deleted by the delete statement."
             + CHR(10)               
             + "   Override deleteBuffer for these tables. */"
             + CHR(10)               
             + "FUNCTION deleteBuffer"
             + CHR(10)
             + " RETURNS LOGICAL"
             + CHR(10)
             + " (phBuffer AS HANDLE):"
             + CHR(10)
             + " CASE ":U               
             + (IF  NOT _suppress_dbname 
                THEN "phBuffer:DBNAME + ~".~":U + " 
                ELSE " ":U)   
             + "phBuffer:TABLE:"
             + CHR(10)           
             .
             
    DO i = 1 TO NUM-ENTRIES(cDelTAbles):        
      ASSIGN
        cDbTable = ENTRY(i,cDelTables) 
        cDb      = (IF NUM-ENTRIES(cDbTable,".":U) = 2 
                    AND _suppress_dbname = FALSE
                    THEN ENTRY(1,cDbTable,".":U) + ".":U
                    ELSE "":U)                           
        cDbTable = cDb + ENTRY(NUM-ENTRIES(cDbTable,".":U),cDbTable,".":U)
        
        cDef   = Cdef       
               + "   WHEN ~"":U 
               + cDbTable 
               + "~" THEN":U
               + CHR(10) 
               + "   DO:"
               + CHR(10) 
               + "     FIND ":U 
               + cDbTable + " WHERE ROWID(":U 
               + cDbTable 
               + ") = phBuffer:ROWID":U
               + CHR(10)
               + "     EXCLUSIVE-LOCK":U 
               + CHR(10)
               + "     NO-ERROR":U 
               + CHR(10)
               + "     NO-WAIT.":U 
               + CHR(10)
               + "     IF AVAIL ":U             
               + cDbTable 
               + " THEN ":u
               + CHR(10)
               + "       DELETE ":U 
               + cDbTable
               + " NO-ERROR.":U
               + CHR(10)
               + "   END. /* WHEN ":U
               + cDbTable 
               + " */":U
               + CHR(10).
    END.
    ASSIGN
      cDef = cDef
           + "   OTHERWISE RETURN SUPER(phBuffer)."
           + CHR(10)
           + " END CASE.":U
           + CHR(10)
           + " IF ERROR-STATUS:ERROR THEN":U  
           + CHR(10)
           + "   RUN addMessage(?,?,phBuffer:TABLE).":U  
           + CHR(10) 
           + " RETURN NOT ERROR-STATUS:ERROR.":U                
           + CHR(10)
           + "END FUNCTION.".                  
  END.                      
  RETURN cDef.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genValidationFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION genValidationFrame Procedure 
FUNCTION genValidationFrame RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Generate DEFINE FRAME and setFrameHandle and enable statement 
           if any of the fields have _inherit_validation.  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i     AS INT NO-UNDO.
  DEF VAR cCode AS CHAR NO-UNDO.
  
  FIND _P WHERE RECID(_P) = _PAGE.Procid NO-ERROR.
  
  IF AVAIL _P THEN
    FIND _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
            AND   _U._TYPE          = "QUERY":U NO-ERROR.
  
  IF AVAIL _U THEN
  DO:        
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U)
                 AND   _BC._INHERIT-VALIDATION = TRUE: 
       cCode = cCode 
               + CHR(10) 
               + "  ":U
               + (IF _suppress_dbname THEN "":U ELSE _BC._DBNAME + ".":U)
               + _BC._TABLE
               + ".":U
               + _BC._NAME. 
                 
    END. /* for each _bc */
    IF cCode <> '' THEN 
    DO:
      cCode = 
       '/** Define the frame to use for validation */' 
       + CHR(10)                
       + 'DEFINE FRAME ValidationFrame' 
       + cCode 
       + CHR(10)
       + 'WITH STREAM-IO.':U
       + CHR(10)
       + CHR(10)
       + '/** Set the frame handle in the super procedure '
       + CHR(10)
       + '    The super procedure assigns its screen-value using get-field and  '
       + CHR(10)
       + '    performs the validate() method */' 
       + CHR(10)                
       + 'setFrameHandle(FRAME ValidationFrame:HANDLE).':U
       + CHR(10)
       + CHR(10)
       + '/** Enable the frame in order to validate */' 
       + CHR(10)
       + 'ENABLE ALL WITH FRAME ValidationFrame.':U
       + CHR(10).                
                
    END.    
    
  END. /* if avail _U */

  RETURN cCode. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getField Procedure 
FUNCTION getField RETURNS CHARACTER
  (pField AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Fetch values form the _PAGE temp-table 
    Notes: Called form wizard pages and when the HTML code is generated. 
           Some of the values are NOT stored in _page.   
------------------------------------------------------------------------------*/
  DEF VAR hBuff          AS HANDLE NO-UNDO.
  DEF VAR hField         AS HANDLE NO-UNDO.
  DEF VAR iLoop          AS INT    NO-UNDO.
  DEF VAR iByPos         AS INT    NO-UNDO.
  DEF VAR iIndexRPos     AS INT    NO-UNDO.
  DEF VAR cInfo          AS CHAR   NO-UNDO.
  DEF VAR cByField       AS CHAR   NO-UNDO.
  DEF VAR cDataObject    AS CHAR   NO-UNDO.
  DEF VAR hDataObject    AS HANDLE NO-UNDO.
  DEF VAR cExternalNames AS CHAR   NO-UNDO.
  DEF VAR cObjectName    AS CHAR   NO-UNDO.


  /* Values that may contain db name */
  DEF VAR xcDbFlds AS CHAR   NO-UNDO INIT 
"columnList,SearchColumns,LinkColumn,ExternalTables,ExternalJoin,ExternalWhere":U.
    
  ASSIGN
    hBuff  = BUFFER _PAGE:HANDLE
    hField = hBuff:BUFFER-FIELD(pField) NO-ERROR.
  
  IF VALID-HANDLE(hField) THEN
  DO:
    IF CAN-DO(xcDbFlds,pField) THEN 
      RETURN removeDbref(hField:BUFFER-VALUE).
  
    /* tables and dataobject may have been stored when defining external tables.
       (They are used in _wizetbl to check if the stored values are different)  
       UNKNOWN means untouched and we must check the UIBinfo further down */     
    ELSE
    IF pField = "TABLES":U THEN 
    DO: 
      IF hField:BUFFER-VALUE <> ? THEN 
        RETURN RemoveDbRef(hField:BUFFER-VALUE). 
    END. /* if pfield = 'Tables' */
    ELSE IF pField = "DataObject":U THEN 
    DO: 
      IF hField:BUFFER-VALUE <> ?  THEN 
        RETURN hField:BUFFER-VALUE. 
    END. /* if pfield = 'DataObject' */
    ELSE 
      RETURN hField:BUFFER-VALUE. 
  END.
   
  /* Check for all special cases */

  IF pField = "ExternalTables":U THEN
  DO:
    /* The html.dat references ExternalTables, but from 3.1B the wizard 
       uses ExternalDispNames. 
        (setField still supports ExternalTables for old wizards) */
    cExternalNames = getField('ExternalDispNames':U).
    /* External Object are stored as 'filename (objectname)' we only
       want objectname in the html file */ 
          
    IF INDEX(cExternalNames,"(":U) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(cExternalNames,"|":U):
      cObjectName = ENTRY(iLoop,cExternalNames,"|":U).
      /* if "(" then get the objectname from the parenthesis */
      IF INDEX(cObjectName,"(":U) > 0 THEN 
        ENTRY(iLoop,cExternalNames,"|":U) = 
            TRIM(ENTRY(2,cObjectName,"(":U),")":U).
    END. /* if "(" in list then do iloop  */
    RETURN cExternalNames. 
  END.
  ELSE IF pField = "AppService":U THEN
  DO:
    ASSIGN
      cDataObject = getField("DataObject":U)
      cInfo       = "":U.
    /* getSDOHandle should normally NOT be called from a function when 
       running remotely because it has a input blocking statement to WAIT-FOR
       data returned by http control, but that's only the first time and 
       the SDO Must already run when the Appservice is called so this should 
       be safe. */ 
    IF cDataObject <> "" AND cDataObject <> ? THEN
    DO:
      RUN getSDOHandle IN gWizardHdl (cDataObject, OUTPUT hDataObject).
      IF VALID-HANDLE(hDataObject) THEN 
        cInfo = DYNAMIC-FUNCTION('getAppService':U IN hDataObject).
    END.
    RETURN cInfo.
  END.  
  ELSE IF pField = "DataObject":U THEN
  DO:
    RUN adeuib/_uibinfo.p (_PAGE.ProcID, "":U,pField, OUTPUT cInfo).    
    RETURN cInfo.
  END.  
  ELSE IF pField = "HTMLTemplate":U THEN
  DO:
    RUN adeuib/_uibinfo.p (_PAGE.ProcID,"":U, "HTML-FILE-NAME":U, OUTPUT cInfo).    
    RETURN cInfo.
  END.  
  ELSE
  If CAN-DO('dbTables,Tables,4GLQuery,FirstSortColumn',Pfield) THEN
  DO:
    RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, 
       "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT cInfo).
    
    If cInfo <> ? AND cInfo <> "":U THEN
    DO:
      RUN adeuib/_uibinfo.p(INT(cInfo), ?, 
                            IF CAN-DO("Tables,DbTables":U,pField) THEN "TABLES":U 
                            ELSE                       "4GL-QUERY":U,
                            OUTPUT cInfo).
      
      
      IF pField = "4GLQUERY":U THEN
      DO:  
        /* If no by clause we use the searchcolumn, also add FOR to the query */ 
        ASSIGN
          cByField   = IF INDEX(cInfo," BY":U) = 0 
                       THEN ENTRY(1,getField('SearchColumns')) 
                       ELSE "":U
          cInfo      = "FOR ":U 
                     + cInfo.          
                      
        /* Add the field found in the searchColumns as the default sort */
        IF cByField  <> "":U THEN
        DO:  
          ASSIGN /* indexed-reposition is the last word, so we add a blank to 
                    search for the whole word */ 
            iIndexRPos = INDEX(cInfo + " ":U," INDEXED-REPOSITION ":U).         
            cByField   = " BY ":U + cByField.
        
          /* Make sure indexed-reposition is AFTER by */  
          IF iIndexRPOs > 0 THEN 
            SUBSTR(cInfo,iIndexRPos,0) = cByField.
          ELSE     
             cInfo = Cinfo + cByField. 
        END. /* if cByField <> '' */      
      END. /* IF pField = "4GLQUERY" */
                                     
      IF pField = "FirstSortColumn":U THEN
      DO:
        ASSIGN
          iByPos = INDEX(cInfo," BY":U) 
          cInfo  = IF iByPos > 0 
                   THEN TRIM(ENTRY(2,SUBSTR(cInfo,iByPos + 1)," "),CHR(10))
                   ELSE "":U.
      END. /* if pfield = 'firstSortcolumn' */
      
      RETURN IF cInfo = ? THEN "":U 
             ELSE 
             IF pField = "dbTables" THEN cInfo
             ELSE removeDbref(cInfo).
    END. /* If cInfo <> ? AND cInfo <> "":U */    
    ELSE RETURN "":U.  
  END.   
  ELSE IF pField = 'PagebgColor' THEN 
    RETURN bgColor(_Page.PageBgRed,_Page.PageBgGreen,_Page.PageBgBlue).
  ELSE IF pField = 'TablebgColor' THEN 
    RETURN bgColor (_Page.TableBgRed,_Page.TableBgGreen,_Page.TableBgBlue).
  
  ELSE 
   MESSAGE "Function getField was not able to process field: " pField
   VIEW-AS ALERT-BOX ERROR.
  
  RETURN "".
       
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHexValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHexValue Procedure 
FUNCTION getHexValue RETURNS CHARACTER
(INPUT asc-value AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: Get the HEX value of an integer 
    Notes: Used to generate correct Hex code for Red Blue Green 
------------------------------------------------------------------------------*/
 
   DEF VAR j AS INT  NO-UNDO.
   DEF VAR h AS CHAR NO-UNDO.
   DO WHILE TRUE:
     Assign      
      j = asc-value MODULO 16
      h = (IF j < 10 THEN STRING(j) ELSE CHR(ASC("A") + j - 10)) + h.
      IF asc-value < 16 THEN LEAVE.
      asc-value = (asc-value - j) / 16.
   END.
   RETURN (if length(h) = 1 then "0" + h ELSE h).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Hex2Dec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Hex2Dec Procedure 
FUNCTION Hex2Dec RETURNS DECIMAL
 (INPUT Hexvalue AS CHAR):
  DEF VAR dAsc   AS DECIMAL NO-UNDO.   
  DEF VAR dValue AS DECIMAL NO-UNDO.   
  DEF VAR iRest  AS INTEGER NO-UNDO.   
  DEF VAR cAsc   AS CHAR    NO-UNDO.
  DEF VAR i      AS INT     NO-UNDO.
  DEF VAR iDigit AS INT     NO-UNDO.
  
  iDigit = LENGTH(HexValue).   
  DO i = 1 to LENGTH(HexValue):
    ASSIGN 
      cAsc   = CAPS(SUBSTR(HexValue,i,1)).
    
    IF cAsc  > "F":U THEN DO:
      Message "Invalid Value in HEX value." 
      VIEW-AS ALERT-BOX ERROR.
      RETURN ?.     
    END.
    
    ASSIGN   
      iRest  = ASC(cAsc) - ASC("A":U)     
      dAsc   = IF iRest >= 0 
               THEN 10 + iRest    
               ELSE INT(cAsc)
      dAsc   = dAsc * EXP(16,iDigit - 1)
      dValue = dValue + dasc 
      iDigit = iDigit - 1.
  END.
  RETURN dValue. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLAttribute Procedure 
FUNCTION HTMLAttribute RETURNS CHARACTER
  (pAttrName  AS CHAR,
   pFieldName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return attribute="value" for use in side of HTML tags   
    Notes: The function returns SPACE and attribute if attribute <> '' or ? 
           and no space if not valid.      
------------------------------------------------------------------------------*/
  DEFINE VAR FldValue AS CHAR NO-UNDO.
  
  
  
  FldValue = GetField(pfieldName).
   
  RETURN IF FldValue = '':U THEN '':U 
         ELSE ' ':U 
              + pAttrName 
              + '=':U
              + '~"':U
              + FLdValue
              + '~"':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLTagLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLTagLink Procedure 
FUNCTION HTMLTagLink RETURNS CHARACTER
  (pTag  AS CHAR,
   pLink AS CHAR,
   pAttr AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Put a tag in the generated HTML 
           <pTag HREF="pLink" pAttr> 
    Notes: Returns BLANK if getfield(pLink) is blank   
------------------------------------------------------------------------------*/
  DEFINE VAR cFldValue AS CHAR NO-UNDO.
  
  cFldValue = GetField(pLink).
   
  RETURN IF cFldValue = '':U THEN '':U 
         ELSE '<':U 
              + pTag 
              + ' ':U
              + 'HREF=~"':U
              + cFLdValue
              + '~"':U
              + ' '
              + pAttr
              + '>'.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION instanceProperties Procedure 
FUNCTION instanceProperties RETURNS CHARACTER
  (pcVarName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Generate the function calls to set instance properties in the sdo  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE         iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE         cEntry        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cProperty     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cSignature    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cCode         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cDataObject   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         hDataObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE         cPropList     AS CHAR      NO-UNDO.
    
  cDataObject = getField('DataObject').
  cCode = ' ' + pcVarname + ' = dynamic-function("getDataSource").'.
  IF cDataObject <> "" THEN 
  DO:  
    RUN getSDOHandle IN gWizardHdl (cDataObject, OUTPUT hDataObject).
    
    cPropList   =      
       DYNAMIC-FUNCTION("instancePropertyList":U IN hdataObject,"":U).
    
    DO iEntry = 1 TO NUM-ENTRIES(cPropList, CHR(3)):
      cEntry = ENTRY(iEntry, cPropList, CHR(3)).
      cProperty = ENTRY(1, cEntry, CHR(4)).
    
      IF cProperty = "AppService":U THEN NEXT. /* this is taken care of */
     
      cValue = ENTRY(2, cEntry, CHR(4)).
      /* Get the datatype from the return type of the get function. */
      cSignature = dynamic-function
        ("Signature":U IN hDataObject, "get":U + cProperty).
      
      cCode = cCode + CHR(10)  
      + '  dynamic-function("set' + cProperty + '":U IN ' + pcVarName + ','. 
      CASE ENTRY(2,cSignature):
        WHEN "CHARACTER":U THEN
          cCode = cCode + '"' + cValue + '":U).'.   
        WHEN "LOGICAL":U THEN
          cCode = cCode + (IF cValue = "yes" THEN "yes" ELSe "no") + ').'.   
        OTHERWISE
          cCode = cCode + ENTRY(2,cSignature) + '("' + cValue + '":U)).'.           
      END CASE.     
    END.
  END.
  RETURN cCode. 
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-overrideColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION overrideColumns Procedure 
FUNCTION overrideColumns RETURNS CHARACTER
  ( pAttr AS CHAR /* attribute to check */ ) :
/*------------------------------------------------------------------------------
  Purpose: Generate assignColumn* call for each column thats different than 
           the database  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i     AS INT NO-UNDO.
  DEF VAR cCode AS CHAR NO-UNDO.
  
  FIND _P WHERE RECID(_P) = _PAGE.Procid NO-ERROR.
  
  IF AVAIL _P THEN
    FIND _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
            AND   _U._TYPE          = "QUERY":U NO-ERROR.
  
  IF AVAIL _U THEN
  DO:        
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U): 
      IF (pAttr = "Label":U  AND  _BC._LABEL  <> _BC._DEF-LABEL)
      OR (pAttr = "Format":U AND  _BC._FORMAT <> _BC._DEF-FORMAT)
      OR (pAttr = "Width":U  AND  _BC._WIDTH  <> _BC._DEF-WIDTH)
      OR (pAttr = "Help":U   AND  _BC._HELP   <> _BC._DEF-HELP) THEN
      DO:
        cCode = cCode + 
                "assignColumn":U 
                + pAttr 
                + "(":U
                + "~'":U 
                + (IF _suppress_dbname THEN "":U ELSE _BC._DBNAME + ".":U)
                + _BC._TABLE
                + ".":U
                + _BC._NAME 
                + "~'":U 
                + ",":U 
                + "~'":U  
                + (IF pAttr = "Label":U THEN _BC._LABEL
                   ELSE
                   IF pAttr = "Format":U THEN _BC._FORMAT
                   ELSE
                   IF pAttr = "Width":U THEN STRING(_BC._WIDTH)
                   ELSE 
                   IF pAttr = "HELP":U THEN _BC._HELP
                   ELSE "":U)
                + "~'":U                                   
                + ").":U
                + CHR(10).
      END. /* if pattr ... */          
    END. /* for each _bc */    
  END. /* if avail _U */

  RETURN cCode. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReadFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ReadFile Procedure 
FUNCTION ReadFile RETURNS LOGICAL
  (pName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: read the .dat file and replace ## ## and 
           <for each  with wizard data in the generated HTML 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR Mark        AS CHAR INIT '##'  NO-UNDO.  
  DEF VAR SpacedMark  AS CHAR INIT ' ##' NO-UNDO.  
  DEF VAR FirstMark   AS CHAR NO-UNDO.  
  DEF VAR ReplaceTxt  AS CHAR NO-UNDO.  
  DEF VAR InLine      AS CHAR NO-UNDO.  
  DEF VAR RepeatLine1 AS CHAR NO-UNDO.  
  DEF VAR RepeatLine2 AS CHAR NO-UNDO.  
  DEF VAR IfLine      AS CHAR NO-UNDO.  
  DEF VAR ReadLine    AS CHAR NO-UNDO.  
  DEF VAR Action      AS CHAR NO-UNDO.
  DEF VAR CallFunc    AS CHAR NO-UNDO.
  DEF VAR ParamList   AS CHAR NO-UNDO.
  DEF VAR Param1      AS CHAR NO-UNDO.
  DEF VAR Param2      AS CHAR NO-UNDO.
  DEF VAR Param3      AS CHAR NO-UNDO.
  DEF VAR Param4      AS CHAR NO-UNDO.
  DEF VAR Pos         AS INT  NO-UNDO.
  DEF VAR ForEach     AS LOG  NO-UNDO.
  DEF VAR IfTest      AS LOG  NO-UNDO.
  DEF VAR endPos      AS INT  NO-UNDO.
  DEF VAR i           AS INT  NO-UNDO.
  DEF VAR NumParam    AS INT  NO-UNDO.
  DEF VAR NumQuotes   AS INT  NO-UNDO.
  DEF VAR QuoteChar   AS CHAR NO-UNDO INIT '~''.

  INPUT STREAM instream FROM VALUE(SEARCH(pName)) NO-ECHO.
  
  Inline:
  REPEAT ON ERROR UNDO,LEAVE: 
    IMPORT STREAM instream UNFORMATTED InLine.

  DO WHILE TRUE:

      ASSIGN
        ForEach = INDEX(InLine,'##EachColumn') > 0     
        Pos     = INDEX(InLine,Mark).
      
        /* Check for '<for each'  in source code. 
           If found everything inside will be repeated for each column */
      
      IF Foreach then
      DO:
        ASSIGN
            RepeatLine1 = '' 
            RepeatLine2 = ''
            IfLine      = ''. 
                  
        /* Start reading the lines on the inside of <for each  */
        DO WHILE TRUE ON ERROR UNDO, LEAVE:
            IMPORT Stream InStream UNFormatted InLine. 
            
            /* ##end marks the end of ##eachColumn or ##ifLinkcolumn */
            IF TRIM(INLINE) BEGINS 'end##' THEN DO:
               Inline = "". 
               IF Iftest THEN 
                 IfTest = FALSE. 
               ELSE LEAVE. /* -------------------------> */
            END.
            ELSE /* <if column marks the HTML code to insert only 
                    for the LinkColumn */ 
            IF TRIM(INLINE) BEGINS '##IfLinkColumn' THEN DO:
               Inline = "". 
               IfTest = TRUE.
            END.
            
            /* Add to Ifline if we are inside the <ifcolumn */ 
            IF IfTest THEN 
               IfLine = IfLine + InLine + CHR(10).
            
            ELSE DO:
              /* if IfLine has data we must separate what's before and after */ 
              IF IfLine = '':U THEN 
                RepeatLine1 = RepeatLine1 + InLine + CHR(10).         
              ELSE 
                RepeatLine2 = RepeatLine2 + InLine + CHR(10).         
            END.   
        END. /* do while true */        
          /* Output HTML for each column */ 
          
        DO i = 1 to NUM-ENTRIES(_Page.ColumnList): 
            /* First put out readline 1 */
            PUT STREAM OutStream UNFORMATTED
               REPLACE(RepeatLine1,'##ColumnName##',
                                   ENTRY(i,_Page.ColumnList)).          
             
            /* Put out the html that only is used for LinkColumn */
            IF IfLine <> "" AND ENTRY(i,_Page.ColumnList) = _Page.LinkColumn THEN 
            DO:
             
              IfLine = REPLACE(IfLine,'##WebObject##',_Page.weBobject).          
              IfLine = REPLACE(IfLine,'##StatusLine##',_Page.StatusLine).          
              IfLine = REPLACE(IfLine,'##TargetFrame##',_Page.TargetFrame).          
              IfLine = REPLACE(IfLine,'##JoinColumns##',_Page.JoinColumns).          
              
              PUT STREAM OutStream UNFORMATTED 
                IfLine.
            END.          
            /* Put out the html that are after LinkColumn */           
            PUT STREAM OutStream UNFORMATTED
               REPLACE(RepeatLine2,'##ColumnName##',
                                   ENTRY(i,_Page.ColumnList)).          
                               
        END. /* do i = 1 to num-entries */
      END.
     
      /** 
      Look for ##Functionname('Parameter'[,'parameter'])## in the .dat file
      and replace that with whatever the function returns.
      Parameters uses single quotes. 
      **/       
      ELSE IF Pos > 0 THEN DO:
        ASSIGN         
         /* Logic to remove optional space before ## */
         FirstMark  = IF Pos > 1 AND SUBSTR(InLine,Pos - 1,1) = ' ' 
                      THEN SpacedMark 
                      ELSE Mark 
         ReadLine   = SUBSTR(InLine,Pos + 2)  
         EndPos     = INDEX(Readline,'##') - 1
         Action     = SUBSTR(ReadLine,1,EndPos)
         ParamList  = REPLACE(ENTRY(2,Action,'('),')','')
         NumQuotes  = MAX(0,NUM-ENTRIES(ParamList,QuoteChar) - 1)
         NumParam   = IF NumQuotes = 0 THEN 0  ELSE (NumQuotes / 2)
         CallFunc   = ENTRY(1,Action,'(')
         ReplaceTxt = FirstMark + Action + Mark.
        
        /* Call the function with the right number of parameters*/ 
        CASE NumParam:   
          WHEN 0 THEN
            InLine = REPLACE (InLine, 
                            ReplaceTxt,
                            DYNAMIC-FUNCTION(Callfunc)).         
          WHEN 1 THEN 
            ASSIGN
              Param1 = ENTRY(2,Action,QuoteChar)     
              InLine = REPLACE (InLine, 
                            ReplaceTxt,
                            DYNAMIC-FUNCTION(Callfunc,Param1)).         
          
          WHEN 2 THEN
            ASSIGN
              Param1 = ENTRY(2,Action,QuoteChar)     
              Param2 = ENTRY(4,Action,QuoteChar)    
              InLine = REPLACE (InLine,
                              ReplaceTxt,
                              DYNAMIC-FUNCTION(Callfunc,Param1,Param2)).
          
                                     
          WHEN 3 THEN 
            ASSIGN
              Param1 = ENTRY(2,Action,QuoteChar)     
              Param2 = ENTRY(4,Action,QuoteChar)     
              Param3 = ENTRY(6,Action,QuoteChar)     
              InLine = REPLACE (InLine, 
                              ReplaceTxt,
                              DYNAMIC-FUNCTION(Callfunc,Param1,Param2,Param3)).
          WHEN 4 THEN 
            ASSIGN
              Param1 = ENTRY(2,Action)     
              Param2 = ENTRY(3,Action)     
              Param3 = ENTRY(4,Action)     
              Param4 = ENTRY(5,Action)     
              InLine = REPLACE (InLine, 
                              ReplaceTxt,
                             DYNAMIC-FUNCTION(Callfunc,Param1,Param2,Param3,Param4)).
          OTHERWISE
          DO:
          
            MESSAGE 
           'Maximum number of Designtime Function Parameters in the input file is 4.' SKIP
           'Function call to ' CallFunc ' was ignored.' 
           VIEW-AS ALERT-BOX INFORMATION.
        
            InLine = REPLACE (InLine, 
                            ReplaceTxt,'').
            NEXT Inline.
          END. 
        END CASE.                
      END. /* else if pos > 0) */  
             
      ELSE LEAVE. /* leave do while if pos = 0 */ 
      
    END. /* Do while true */ 
    IF Inline <> ? THEN    
      PUT STREAM OutStream UNFORMATTED InLine CHR(10).     
  
  END. /* repeat */
  
  INPUT CLOSE.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDbref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeDbref Procedure 
FUNCTION removeDbref RETURNS CHARACTER
  (pString AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Remove dbreference from columnlists, queries or tablelists    
    Notes: 
------------------------------------------------------------------------------*/
  DEF VAR i       AS INTEGER NO-UNDO. 
      
  IF _suppress_dbname THEN
  DO i = 1 TO NUM-DBS:
    /* 
    If for instance a db was named XXXA and another XA 
    we must ensure that XA not is removed from XXXA.       
    So the db. must be after a blank, comma or in the beginning of the
    string */
    ASSIGN   
      pString = REPLACE(pString," ":U + LDBNAME(i) + ".":U," ":U)
      pString = REPLACE(pString,",":U + LDBNAME(i) + ".":U,",":U)
      pString = IF pString BEGINS LDBNAME(i) + "."  
                THEN SUBSTR(pString,LENGTH(LDBNAME(i) + ".":U,"CHARACTER":U) + 1)
                ELSE pString.               
  END.      
  RETURN pString.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeTableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeTableFields Procedure 
FUNCTION removeTableFields RETURNS CHARACTER
  (pcColumns AS CHAR,
   pcTables AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Remove all columns that belongs to the tables   
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR iTable        AS INT NO-UNDO. 
  DEF VAR iColumn       AS INT NO-UNDO. 
  DEF VAR cColumn       AS CHAR NO-UNDO. 
  DEF VAR cTable        AS CHAR NO-UNDO. 
  DEF VAR cNewColumns   AS CHAR NO-UNDO. 
  
  DO iTable = 1 TO NUM-ENTRIES(pcTables):
    ASSIGN
      cTable = ENTRY(iTable,pcTables). 
    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      cColumn = ENTRY(iColumn,pcColumns). 
     
      IF NOT (cColumn BEGINS cTable + ".") THEN
        cNewColumns  = cNewColumns 
                       + (IF cNewColumns = "":U THEN "":U ELSE ",":U)
                       + cColumn.                   
   END. /* do icolumn = 1 to */  
 END. /* do iTable = 1 to */
   
 RETURN TRIM(cNewColumns).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setField Procedure 
FUNCTION setField RETURNS LOGICAL
  ( pcField AS CHAR,
    pcValue AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Store data in _page 
    Notes: Called from different wizard pages. 
------------------------------------------------------------------------------*/
  DEF VAR BuffHDL   AS HANDLE  NO-UNDO.
  DEF VAR FldHDL    AS HANDLE  NO-UNDO.
  DEF VAR HashPos   AS INT     NO-UNDO.
  DEF VAR iEntry    AS INT     NO-UNDO.
  DEF VAR cEntry    AS CHAR    NO-UNDO.
  DEF VAR cValue    AS CHAR    NO-UNDO.
  DEF VAR cProperty AS CHAR    NO-UNDO.
  
  IF CAN-DO("PageBgColor,TableBgColor":U,pcField) THEN 
  DO:
    IF pcField BEGINS "PAGE":U THEN   
      ASSIGN 
        _PAGE.PageBgRed   = Hex2Dec(SUBSTR(pcValue,1,2)) 
        _PAGE.PageBgGreen = Hex2Dec(SUBSTR(pcValue,3,2))
        _PAGE.PageBgBlue  = Hex2Dec(SUBSTR(pcValue,5,2)).
    ELSE 
      ASSIGN 
        _PAGE.TableBgRed   = Hex2Dec(SUBSTR(pcValue,1,2))
        _PAGE.TableBgGreen = Hex2Dec(SUBSTR(pcValue,3,2)) 
        _PAGE.TableBgBlue  = Hex2Dec(SUBSTR(pcValue,5,2)).
       
  END. /* CAN-DO("PageBgColor,TableBgColor" */  
  ELSE /* From 3.1B  _wizetbl.w uses ExternalDispNames internally, we just
          store ExternalTables here if someone has a local old wizard */
  IF pcField = 'ExternalTables':U THEN
    setField('ExternalDispNames':U,pcValue).

  ELSE DO:
    ASSIGN
      BuffHdl = BUFFER _PAGE:HANDLE    
      FldHdl  = BuffHdl:BUFFER-FIELD(pcField)
      FldHdl:BUFFER-VALUE = pcValue.
    
    /* fix to support foreignfields in 9.0a */  
    IF pcField = "JoinLink":U THEN 
      setField('JoinColumns':U,IF pcValue = "yes":U THEN "ROWID":U ELSE "":U).
  END.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

