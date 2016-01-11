&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                    *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: ryxmlplipp.p

  Description:  Xml Extract Procedures

  Purpose:      Xml Extract Procedures

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   28/02/2002  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryxmlplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&SCOPED-DEFINE mip-notify-user-on-plip-close   NO
&SCOPED-DEFINE DEFAULT_XSL_NAME af/rep/xmlreport.xsl /* Default XML Style sheet file name */

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttDataSource
  FIELD tt_tag   AS CHARACTER
  FIELD tt_value AS CHARACTER EXTENT {&max-crystal-fields}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-replaceInvalidChars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceInvalidChars Procedure
FUNCTION replaceInvalidChars RETURNS CHARACTER 
	(INPUT pcName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dateToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dateToXsd Procedure 
FUNCTION dateToXsd RETURNS CHARACTER
  ( ptDate AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decimalToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD decimalToXsd Procedure 
FUNCTION decimalToXsd RETURNS CHARACTER
  ( pdDecimal AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getValue Procedure 
FUNCTION getValue RETURNS CHARACTER
  ( pcToken AS CHARACTER,
    pcList  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logicalToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD logicalToXsd Procedure 
FUNCTION logicalToXsd RETURNS CHARACTER
  ( INPUT plLogical AS LOGICAL )  FORWARD.

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
         HEIGHT             = 13.76
         WIDTH              = 54.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createXML Procedure 
PROCEDURE createXML :
/*------------------------------------------------------------------------------
  Purpose:     Create the actual XML report
  Parameters:  phTT - Temp table handle containing all the information
               pcNodeData - String of data relative to the report
               phXML - XML document handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER phTT       AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeData AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phXml      AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hReportNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHeaderNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldNode         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataNode          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hValueNode         AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE phTTBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cXSLFileName       AS CHARACTER  NO-UNDO.

  CREATE X-DOCUMENT phXml       IN WIDGET-POOL "xmlPrint".                        
  CREATE X-NODEREF  hReportNode IN WIDGET-POOL "xmlPrint".
  CREATE X-NODEREF  hHeaderNode IN WIDGET-POOL "xmlPrint".
  CREATE X-NODEREF  hFieldNode  IN WIDGET-POOL "xmlPrint".
  CREATE X-NODEREF  hDataNode   IN WIDGET-POOL "xmlPrint".
  CREATE X-NODEREF  hRecordNode IN WIDGET-POOL "xmlPrint".
  CREATE X-NODEREF  hValueNode  IN WIDGET-POOL "xmlPrint".
  
  /*set the XMl stylesheet*/
  phXml:CREATE-NODE(hReportNode, "xml-stylesheet", "PROCESSING-INSTRUCTION").

  /* Get preferred XML Style sheet */
  cXSLFileName = DYNAMIC-FUNCTION('getSessionParam':U IN TARGET-PROCEDURE, 'print_preview_stylesheet':U) NO-ERROR.

  cXSLFileName = SEARCH(cXSLFileName).
  
  IF cXSLFileName = ? OR cXSLFileName = "?" OR cXSLFileName = "":U THEN
    ASSIGN cXSLFileName = "{&DEFAULT_XSL_NAME}".
           cXSLFileName = SEARCH(cXSLFileName).

  IF cXSLFileName = ? OR cXSLFileName = "?" OR cXSLFileName = "":U THEN
    cXSLFileName = "":U.
  ELSE
    cXSLFileName = REPLACE(cXSLFileName,"~\":U,"/":U).
  
  /* Check for current directory - we need a full path */
  IF SUBSTRING(cXSLFileName,1,1) = ".":U THEN
    ASSIGN FILE-INFO:FILE-NAME     = ".":U
           cXSLFileName = REPLACE(FILE-INFO:FULL-PATHNAME + SUBSTRING(cXSLFileName,2),"~\":U,"/":U).

  /* Only if we have a valid XML Style sheet, then include in report */
  IF cXSLFileName <> "":U THEN 
  DO:
    cXSLFileName = "file://" + cXSLFileName.
    hReportNode:NODE-VALUE = "type='text/xsl' href='" + cXSLFileName + "'".
  END.
  
  phXml:APPEND-CHILD(hReportNode).

  /*create the report (root) node*/
  phXml:CREATE-NODE(hReportNode, "report", "ELEMENT").
  DO iLoop = 1 TO NUM-ENTRIES(pcNodeData, CHR(3)) /* BY 2 */:
    IF ENTRY(iLoop,pcNodeData,CHR(3)) BEGINS "report_" THEN
      hReportNode:SET-ATTRIBUTE(REPLACE(ENTRY(iLoop, pcNodeData, CHR(3)), "report_":U, "":U), getValue(ENTRY(iLoop, pcNodeData, CHR(3)), pcNodeData)).
  END.
  phXml:APPEND-CHILD(hReportNode).
  
  /*set the temp-table buffer*/
  ASSIGN
    phTTBuffer = phTT:DEFAULT-BUFFER-HANDLE.
  
  /*create the header node*/
  phXml:CREATE-NODE(hHeaderNode, "header", "ELEMENT").
  hReportNode:APPEND-CHILD(hHeaderNode).

  DO iLoop = 1 TO phTTBuffer:NUM-FIELDS:
    hBufferField = phTTBuffer:BUFFER-FIELD(iLoop).
    IF hBufferField:EXTENT = 0 THEN
    DO:
      phXml:CREATE-NODE(hFieldNode, "field", "ELEMENT").
      phXml:CREATE-NODE(hValueNode, ?, "TEXT").
      hFieldNode:SET-ATTRIBUTE("WIDTH", STRING(hBufferField:WIDTH)).
      hFieldNode:SET-ATTRIBUTE("NAME", STRING(hBufferField:NAME)).
      hFieldNode:SET-ATTRIBUTE("DATA-TYPE", STRING(hBufferField:DATA-TYPE)).
      hValueNode:NODE-VALUE = hBufferField:LABEL.
      hHeaderNode:APPEND-CHILD(hFieldNode).
      hFieldNode:APPEND-CHILD(hValueNode).
    END.
    ELSE
    DO iCount = 1 TO hBufferField:EXTENT:
      phXml:CREATE-NODE(hFieldNode, "field", "ELEMENT").
      phXml:CREATE-NODE(hValueNode, ?, "TEXT").
      hFieldNode:SET-ATTRIBUTE("WIDTH", STRING(hBufferField:WIDTH)).
      hValueNode:NODE-VALUE = SUBSTITUTE("&1[&2]", hBufferField:LABEL, iCount).
      hHeaderNode:APPEND-CHILD(hFieldNode).
      hFieldNode:APPEND-CHILD(hValueNode).
    END.
  END.
  
  CREATE QUERY hQuery IN WIDGET-POOL "xmlPrint".
  hQuery:SET-BUFFERS(phTTBuffer).
  hQuery:QUERY-PREPARE("FOR EACH " + phTTBuffer:NAME).
  hQuery:QUERY-OPEN().
  
  phXml:CREATE-NODE(hDataNode, "data", "ELEMENT").
  hReportNode:APPEND-CHILD(hDataNode).
  
  REPEAT:
    hQuery:GET-NEXT.
    IF hQuery:QUERY-OFF-END THEN LEAVE.
    phXml:CREATE-NODE(hRecordNode, "record", "ELEMENT").
    hDataNode:APPEND-CHILD(hRecordNode).
    DO iLoop = 1 TO phTTBuffer:NUM-FIELDS:
      hBufferField = phTTBuffer:BUFFER-FIELD(iLoop).
      IF hBufferField:EXTENT = 0 THEN
      DO:
        phXml:CREATE-NODE(hFieldNode, replaceInvalidChars(hBufferField:NAME), "ELEMENT").
        phXml:CREATE-NODE(hValueNode, ?, "TEXT").
        IF hBufferField:DATA-TYPE = "DECIMAL" THEN
          hValueNode:NODE-VALUE = decimalToXsd(hBufferField:BUFFER-VALUE).
        ELSE
        IF hBufferField:DATA-TYPE = "DATE" THEN
          hValueNode:NODE-VALUE = dateToXsd(hBufferField:BUFFER-VALUE).
        ELSE
        IF hBufferField:DATA-TYPE = "LOGICAL" THEN
          hValueNode:NODE-VALUE = logicalToXsd(hBufferField:BUFFER-VALUE).
        ELSE
          hValueNode:NODE-VALUE = STRING(hBufferField:BUFFER-VALUE).
        hRecordNode:APPEND-CHILD(hFieldNode).
        hFieldNode:APPEND-CHILD(hValueNode).
      END.
      ELSE
      DO iCount = 1 TO hBufferField:EXTENT:
        phXml:CREATE-NODE(hFieldNode, replaceInvalidChars(hBufferField:NAME), "ELEMENT").
        phXml:CREATE-NODE(hValueNode, ?, "TEXT").
        IF hBufferField:DATA-TYPE = "DECIMAL" THEN
          hValueNode:NODE-VALUE = decimalToXsd(hBufferField:BUFFER-VALUE(iCount)).
        ELSE
        IF hBufferField:DATA-TYPE = "DATE" THEN
          hValueNode:NODE-VALUE = dateToXsd(hBufferField:BUFFER-VALUE(iCount)).
        ELSE
        IF hBufferField:DATA-TYPE = "LOGICAL" THEN
          hValueNode:NODE-VALUE = logicalToXsd(hBufferField:BUFFER-VALUE(iCount)).
        ELSE
          hValueNode:NODE-VALUE=STRING(hBufferField:BUFFER-VALUE(iCount)).
        hRecordNode:APPEND-CHILD(hFieldNode).
        hFieldNode:APPEND-CHILD(hValueNode).
      END.
    END.
  END.
  
  DELETE OBJECT hReportNode.  
  DELETE OBJECT hHeaderNode.     
  DELETE OBJECT hFieldNode.    
  DELETE OBJECT hDataNode.   
  DELETE OBJECT hRecordNode.     
  DELETE OBJECT hValueNode.   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-printXMLReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printXMLReport Procedure 
PROCEDURE printXMLReport :
/*------------------------------------------------------------------------------
  Purpose:     The main XML report extract procedure
  Parameters:  ttDataSource - Temp table containing data relative to the data source
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttDatasource.

  DEFINE VARIABLE hTT          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hXml         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUSerLogin   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReportName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProcess     AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttBuffer2 FOR ttDataSource.
  DEFINE BUFFER ttBuffer3 FOR ttDataSource.

  CREATE WIDGET-POOL "xmlPrint".

  cUserLogin = DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager, "currentUserLogin", NO).

  IF cUserLogin <> "" THEN
    ASSIGN
      cNodeData = cNodeData +
                  IF cNodeData <> "" THEN
                    CHR(3)
                  ELSE
                    ""
      cNodeData = cNodeData +
                  "report_user" +
                  CHR(3) +
                  cUserLogin.

  ASSIGN
    cNodeData = cNodeData +
                IF cNodeData <> "" THEN
                  CHR(3)
                ELSE
                  ""
    cNodeData = cNodeData +
                "report_date" +
                CHR(3) +
                STRING(TODAY,"99/99/9999":U) +
                CHR(3) +
                "report_time" +
                CHR(3) +
                STRING(TIME,"HH:MM:SS":U).

  FOR EACH ttDataSource NO-LOCK
    WHERE ttDataSource.tt_tag BEGINS "F0":U: /* Header data */
      ASSIGN
        cNodeData   = cNodeData +
                      IF cNodeData <> "" THEN
                        CHR(3)
                      ELSE
                        ""
        cNodeData   = cNodeData +
                      "report_title" +
                      CHR(3) +
                      ttDataSource.tt_value[1] +
                      CHR(3) +
                      "report_filters" +
                      CHR(3) +
                      ttDataSource.tt_value[2]
        cReportName = SESSION:TEMP-DIR + "XMLReport.xml".
  END.

  CREATE TEMP-TABLE hTT IN WIDGET-POOL "xmlPrint" NO-ERROR.

  FIND ttDataSource NO-LOCK
    WHERE ttDataSource.tt_tag BEGINS "F1":U. /* Fieldnames */
  FIND ttBuffer2 NO-LOCK
    WHERE ttBuffer2.tt_tag BEGINS "F2":U. /* Labels */
  FIND ttBuffer3 NO-LOCK
    WHERE ttBuffer3.tt_tag BEGINS "F3":U. /* Data types */

  DO iLoop = 1 TO {&max-crystal-fields}:
    IF ttDataSource.tt_value[iLoop] <> "":U THEN
      hTT:ADD-NEW-FIELD(ttDataSource.tt_value[iLoop],
                        "CHARACTER":U,
                        0,
                        "X(" + ttBuffer3.tt_value[iLoop] + ")",
                        "",
                        ttBuffer2.tt_value[iLoop],
                        ttBuffer2.tt_value[iLoop]).

  END.

  hTT:TEMP-TABLE-PREPARE("ttTable":U).
  hTTBuffer = hTT:DEFAULT-BUFFER-HANDLE.

  FOR EACH ttDataSource
    WHERE ttDataSource.tt_tag = "D":U:

      hTTBuffer:BUFFER-CREATE().

      DO iLoop = 1 TO hTTBuffer:NUM-FIELDS:
        ASSIGN
          hBufferField = hTTBuffer:BUFFER-FIELD(iLoop)
          hBufferField:BUFFER-VALUE = ttDataSource.tt_value[iLoop]
          NO-ERROR.
      END.

      hTTBuffer:BUFFER-RELEASE().
  END.

  RUN createXML (INPUT hTT, INPUT cNodeData, OUTPUT hXml).
  hXml:SAVE("file", cReportName).
  
  /* Open the report in the associated reader */
  OS-COMMAND NO-WAIT VALUE("~"" + cReportName + "~"").
    
  DELETE WIDGET-POOL "xmlPrint".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-replaceInvalidChars) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceInvalidChars Procedure
FUNCTION replaceInvalidChars RETURNS CHARACTER 
	(INPUT pcName AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose: Replaces invaild characters for XML node element name.
    Notes: Progress allows some characters (i.e.: #,$,% and &) in the table or
           field names, that are not allowed in XML element names. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cInvalidChars AS CHARACTER NO-UNDO INITIAL "#,$,%,&".
DEFINE VARIABLE cNewChars     AS CHARACTER NO-UNDO INITIAL "a,b,c,d".

DEFINE VARIABLE iChars AS INTEGER     NO-UNDO.

REPEAT iChars = 1 TO NUM-ENTRIES(cInvalidChars):
    ASSIGN pcName = REPLACE(pcName, ENTRY(iChars, cInvalidChars), ENTRY(iChars, cNewChars)).
END.

RETURN pcName.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dateToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dateToXsd Procedure 
FUNCTION dateToXsd RETURNS CHARACTER
  ( ptDate AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  Formats an XML date
    Notes:  
------------------------------------------------------------------------------*/

  IF ptDate <> ? THEN 
    RETURN STRING(YEAR(ptDate),"9999") + "-" + STRING(MONTH(ptDate),"99") + "-" + STRING(DAY(ptDate),"99").
  ELSE 
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decimalToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION decimalToXsd Procedure 
FUNCTION decimalToXsd RETURNS CHARACTER
  ( pdDecimal AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Formats a decimal as XML
    Notes:  
------------------------------------------------------------------------------*/

  IF SESSION:NUMERIC-DECIMAL-POINT<>"." THEN
    RETURN REPLACE(STRING(pdDecimal),SESSION:NUMERIC-DECIMAL-POINT,".").
  ELSE
    RETURN STRING(pdDecimal).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getValue Procedure 
FUNCTION getValue RETURNS CHARACTER
  ( pcToken AS CHARACTER,
    pcList  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF LOOKUP(pcToken,pcList,CHR(3)) > 0 THEN
    RETURN ENTRY(LOOKUP(pcToken,pcList,CHR(3)) + 1,pcList,CHR(3)).
  ELSE
    RETURN "No " + CAPS(SUBSTRING(pcToken,1,1)) + LC(SUBSTRING(pcToken,2)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logicalToXsd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION logicalToXsd Procedure 
FUNCTION logicalToXsd RETURNS CHARACTER
  ( INPUT plLogical AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF plLogical THEN
    RETURN "TRUE":U.
  ELSE
    RETURN "FALSE":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

