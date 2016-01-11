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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2002-2003 by Progress Software Corporation ("PSC"),  *
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
*********************************************************************/
/*----------------------------------------------------------------------------
  File:         ry/app/ryuimsrvrp.p

  Description:  UI Manager for Complex-HTML/DHTML/B2B Client Type

  Purpose:      Performs for all UI input and output functionality.
                This UI Manager is specific to the Complex-HTML/DHTML/B2B client type.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:
                Date:   03/27/2002  Author:     Tim Huffam

  Update Notes: Created from Template rytemprocp.p

------------------------------------------------------------------------------*/
/*              This .W file was created with the Progress AppBuilder         */
/*----------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{af/sup2/afglobals.i NEW GLOBAL}
{af/sup/afghplipdf.i NEW GLOBAL}
{src/web2/wrap-cgi.i}

/* Repository attribute values */
{ ry/app/ryobjretri.i }
/* Menu/Toolbar temp tables etc */
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

DEFINE VARIABLE gcAttrNames            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAttrValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAttrValues           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBand                 AS CHARACTER  NO-UNDO. /* Band portion of menu controller */
DEFINE VARIABLE gcBaseHref             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDefaultStaticPath    AS CHARACTER  NO-UNDO INITIAL '../dhtml/'.
DEFINE VARIABLE gcEventObjectActions   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectHotkeys   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectLabels    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectLevels    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectType      AS CHARACTER  NO-UNDO. /* menubar, toolbar, treeview */
DEFINE VARIABLE gcHotkey               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcImagePath            AS CHARACTER  NO-UNDO INITIAL 'ry/img/,../img/'.
DEFINE VARIABLE gcPageProps            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcIncludeJS            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcIncludeCSS           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcStyleSheet           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcJS                   AS CHARACTER  NO-UNDO. /* Accumulate JS for data section */
DEFINE VARIABLE gcJsRun                AS CHARACTER  NO-UNDO. /* Accumulate JS for data section */
DEFINE VARIABLE gcLogicalObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcContainerMode        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMainMenuType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMasterLink           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMenu                 AS CHARACTER  NO-UNDO. /* for one toolbar object */
DEFINE VARIABLE gcMenues               AS CHARACTER  NO-UNDO. /* accumulated output at end */
DEFINE VARIABLE gcNewLine              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPanel                AS CHARACTER  NO-UNDO. /* screen portion of panel-type smart-toolbar */
DEFINE VARIABLE gcRequestEvents        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcRunAttribute         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcScreen               AS CHARACTER  NO-UNDO. /* Accumulate screen specific properties */
DEFINE VARIABLE gcSessionResultCodes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcJustification        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFolderType           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCurrentLanguageObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdCurrentUserObj       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghBufferCacheBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghClassTable           AS HANDLE     NO-UNDO EXTENT 26.
DEFINE VARIABLE ghCustomizationManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLinkBuffer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLinkTable            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectBuffer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageBuffer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageInstanceTable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageTable            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRequestManager       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUiEventBuffer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUiEventTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghttLinkedObj          AS HANDLE     NO-UNDO.
DEFINE VARIABLE giMinTabindex          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giMaxTabindex          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giAttrInd              AS INTEGER    NO-UNDO.
DEFINE VARIABLE giFieldOffsetTop       AS INTEGER    NO-UNDO INITIAL -10.
DEFINE VARIABLE giNumAttrs             AS INTEGER    NO-UNDO.
DEFINE VARIABLE giPixelsPerColumn      AS INTEGER    NO-UNDO INITIAL 5.
DEFINE VARIABLE giPixelsPerRow         AS INTEGER    NO-UNDO INITIAL 21.
DEFINE VARIABLE giViewerOffsetHeight   AS INTEGER    NO-UNDO INITIAL 10.
DEFINE VARIABLE giViewerOffsetWidth    AS INTEGER    NO-UNDO INITIAL 20.
DEFINE VARIABLE glDoMainMenu           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glNeedToDoUI           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glOK                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glOutputToHiddenFrame  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glPageStarted          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glTableIO              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glExportData           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glMasterLink           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSDOContainer         AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghSecurityManager      AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSecuredTokens        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLocalFieldCounter    AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE ttCols NO-UNDO 
  FIELD fldColumn  AS DECIMAL
  FIELD fldSeq     AS INTEGER
  .
DEFINE TEMP-TABLE ttEvent NO-UNDO
  FIELD cEvent  AS CHARACTER
  FIELD cAction AS CHARACTER
  .
DEFINE TEMP-TABLE ttLinkedField NO-UNDO
  FIELD cSDO    AS CHARACTER
  FIELD cViewer AS CHARACTER
  FIELD cWidget AS CHARACTER
  FIELD cLookup AS CHARACTER
  FIELD cField  AS CHARACTER
  FIELD lIsLocal AS LOGICAL
  INDEX cSDO    cSDO cViewer cWidget
  .
DEFINE TEMP-TABLE ttMessages NO-UNDO
  FIELD msgType    AS CHARACTER
  FIELD msgTitle   AS CHARACTER
  FIELD msgText    AS CHARACTER
  FIELD msgButtons AS CHARACTER
  .
DEFINE TEMP-TABLE ttSDO NO-UNDO
  FIELD ttName     AS CHARACTER
  FIELD ttPath     AS CHARACTER
  FIELD ttFields   AS CHARACTER   /* delimited list of SDO fields */
  FIELD ttReal     AS CHARACTER   /* Full table and field qualifier */
  FIELD ttUsed     AS CHARACTER   /* If it appears on the page */
  FIELD ttHandle   AS HANDLE
  INDEX ttName     IS PRIMARY ttName
  INDEX ttPath     ttPath
  .
DEFINE TEMP-TABLE ttLink NO-UNDO
  FIELD ttFrom       AS DECIMAL
  FIELD ttTo         AS DECIMAL
  FIELD ttType       AS CHARACTER
  FIELD ttSDO        AS CHARACTER
  FIELD ttIO         AS CHARACTER
  INDEX ttFrom       IS PRIMARY ttFrom
  .
DEFINE TEMP-TABLE ttSDOFieldsUsed NO-UNDO
  FIELD topObjectName AS CHARACTER
  FIELD SDOName       AS CHARACTER
  FIELD SDOFieldsUsed AS CHARACTER
  /* To denote that we have stored all fields for this SDO's instance */
  FIELD isComplete    AS LOGICAL
  .
DEFINE TEMP-TABLE ttObjAttr NO-UNDO
  FIELD topObjectName AS CHARACTER
  FIELD objName       AS CHARACTER
  FIELD attrName      AS CHARACTER
  FIELD attrValue     AS CHARACTER
  INDEX prim          IS PRIMARY UNIQUE topObjectName objName attrName
  .
DEFINE TEMP-TABLE ttClientAction NO-UNDO
  FIELD ttAction AS CHARACTER
  .
DEFINE TEMP-TABLE ttSDOData NO-UNDO
  FIELD SDOName   AS CHARACTER
  FIELD Counter   AS INTEGER
  FIELD SDOCols   AS CHARACTER
  FIELD SDOValues AS CHARACTER
  INDEX prima     IS PRIMARY UNIQUE SDOName Counter
  .
DEFINE TEMP-TABLE ttSDOLink NO-UNDO
  FIELD SDOName       AS CHARACTER
  FIELD ParentSDOName AS CHARACTER
  FIELD ForeignFields AS CHARACTER
  FIELD SDOEvent      AS CHARACTER
  FIELD SaveFilter    AS LOGICAL
  INDEX primar        IS PRIMARY UNIQUE SDOName
  .
DEFINE TEMP-TABLE ttSDOCount NO-UNDO
  FIELD SDOName     AS CHARACTER
  FIELD rowsToBatch AS INTEGER
  FIELD iCount      AS INTEGER
  INDEX primar      IS PRIMARY UNIQUE SDOName
  .
DEFINE STREAM sText.

DEFINE TEMP-TABLE ttDSSaveEvents NO-UNDO
  FIELD DSName AS CHARACTER
  FIELD DSSaveEvent AS CHARACTER
  FIELD IsSBO AS LOGICAL
  INDEX primar IS PRIMARY UNIQUE DSName
  .
{ry/app/ryuimbl.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkIfOtherInstanceExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkIfOtherInstanceExists Procedure 
FUNCTION checkIfOtherInstanceExists RETURNS LOGICAL
  ( pcViewerName AS CHARACTER,
    pcFieldName AS CHARACTER,
    phObjectBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatValue Procedure 
FUNCTION formatValue RETURNS CHARACTER
    ( INPUT pcValue AS CHARACTER,
      INPUT pcFormat AS CHARACTER,
      INPUT pcDataType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferHandle Procedure 
FUNCTION getBufferHandle RETURNS HANDLE
    ( INPUT pcBufferCache AS HANDLE,
      INPUT pcBufferName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkTypes Procedure 
FUNCTION getLinkTypes RETURNS CHARACTER
  (INPUT d1 AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOLink Procedure 
FUNCTION getSDOLink RETURNS CHARACTER
  (INPUT d1 AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecurityTokens Procedure 
FUNCTION getSecurityTokens RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-jsTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD jsTrim Procedure 
FUNCTION jsTrim RETURNS CHARACTER
  ( INPUT c1 AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( pcImagePath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabIndex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tabIndex Procedure 
FUNCTION tabIndex RETURNS INTEGER
  ( INPUT i1 AS INT )  FORWARD.

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
         HEIGHT             = 26.86
         WIDTH              = 48.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

MESSAGE "Starting UIM".
CREATE WIDGET-POOL NO-ERROR.

ASSIGN
  /* Get the request manager handle */
  ghRequestManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                    "RequestManager":U)
  gcNewLine        = (IF OPSYS = "UNIX":U THEN "~\~\n":U ELSE "~\n":U).
        
ON CLOSE OF THIS-PROCEDURE
DO:
  DELETE WIDGET-POOL NO-ERROR.

  /* TBD: Shut down any persistent procedures started by the UIM (?) */
  DELETE PROCEDURE THIS-PROCEDURE.
  RETURN.
  
END.

&IF DEFINED(server-side) <> 0 &THEN
  /* TBD: insert any server side specific processing (?) */
&ENDIF

DEFINE VARIABLE gcDataClasses            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDataFieldClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynBrowClasses         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynButtonClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynComboBoxClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynComboClasses        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynEditorClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynFillinClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynImageClasses        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynLookupClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynMencClasses         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynObjClasses          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynRadioSetClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynRectangleClasses    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynSDOClasses          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynSelectionClasses    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynTextClasses         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynToggleClasses       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDynViewClasses         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFieldClasses           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcProgressWidgetClasses  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSBOClasses             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartFolderClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartToolbarClasses    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartViewerClasses     AS CHARACTER  NO-UNDO.

ASSIGN 
  gcDataClasses         = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
    "Data,SBO,DynObjc,DynSDO,DynLookup,SmartFolder,DynBrow,DynView,SmartToolbar,DynMenc,SmartViewer,Field,DataField,DynToggle,DynRadioSet,DynEditor,DynFillin,DynComboBox,DynSelection,DynButton,DynText,DynImage,DynRectangle,DynCombo,ProgressWidget":U)
  gcSBOClasses          = ENTRY(2, gcDataClasses, CHR(3))
  gcDynObjClasses       = ENTRY(3, gcDataClasses, CHR(3))
  gcDynSDOClasses       = ENTRY(4, gcDataClasses, CHR(3))
  gcDynLookupClasses    = ENTRY(5, gcDataClasses, CHR(3))
  gcSmartFolderClasses  = ENTRY(6, gcDataClasses, CHR(3))
  gcDynBrowClasses      = ENTRY(7, gcDataClasses, CHR(3))
  gcDynViewClasses      = ENTRY(8, gcDataClasses, CHR(3))
  gcSmartToolbarClasses = ENTRY(9, gcDataClasses, CHR(3))
  gcDynMencClasses      = ENTRY(10, gcDataClasses, CHR(3))
  gcSmartViewerClasses  = ENTRY(11, gcDataClasses, CHR(3))
  gcFieldClasses        = ENTRY(12, gcDataClasses, CHR(3))
  gcDataFieldClasses    = ENTRY(13, gcDataClasses, CHR(3))
  gcDynToggleClasses    = ENTRY(14, gcDataClasses, CHR(3))
  gcDynRadioSetClasses  = ENTRY(15, gcDataClasses, CHR(3))
  gcDynEditorClasses    = ENTRY(16, gcDataClasses, CHR(3))
  gcDynFillinClasses    = ENTRY(17, gcDataClasses, CHR(3))
  gcDynComboBoxClasses  = ENTRY(18, gcDataClasses, CHR(3))
  gcDynSelectionClasses = ENTRY(19, gcDataClasses, CHR(3))
  gcDynButtonClasses    = ENTRY(20, gcDataClasses, CHR(3))
  gcDynTextClasses      = ENTRY(21, gcDataClasses, CHR(3))
  gcDynImageClasses     = ENTRY(22, gcDataClasses, CHR(3))
  gcDynRectangleClasses = ENTRY(23, gcDataClasses, CHR(3))
  gcDynComboClasses     = ENTRY(24, gcDataClasses, CHR(3))
  gcProgressWidgetClasses = ENTRY(25, gcDataClasses, CHR(3))
  gcDataClasses         = ENTRY(1, gcDataClasses, CHR(3)) + ",":U + ENTRY(2, gcDataClasses, CHR(3)).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-clearObjectCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearObjectCache Procedure 
PROCEDURE clearObjectCache :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBufferCacheBuffer AS HANDLE NO-UNDO.

  DEFINE VARIABLE hQ            AS HANDLE NO-UNDO.
  DEFINE VARIABLE hTT           AS HANDLE NO-UNDO.
  DEFINE VARIABLE hObjectBuffer AS HANDLE NO-UNDO.

  IF NOT VALID-HANDLE(phBufferCacheBuffer) THEN
    RETURN.

  hObjectBuffer = getBufferHandle(phBufferCacheBuffer, "cache_Object":U).
  IF NOT VALID-HANDLE(hObjectBuffer) THEN
    RETURN.

  /* Remove attribute tts (by looping through cache_Object tt to get their handles). */
  CREATE QUERY hQ IN WIDGET-POOL 'B2BUIM'.
  hQ:ADD-BUFFER(hObjectBuffer).
  hQ:QUERY-PREPARE("FOR EACH "  + hObjectBuffer:NAME ).
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  DO WHILE hObjectBuffer:AVAILABLE:
    hTT = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    IF VALID-HANDLE(hTT) THEN
        DELETE OBJECT hTT NO-ERROR.
    hQ:GET-NEXT().
  END.
  hq:QUERY-CLOSE().
  DELETE OBJECT hq.
  hq = ?.

  /* Remove class (cache_*) tts (by looping through cache_BufferCache tt to get their handles). */
  CREATE QUERY hQ IN WIDGET-POOL 'B2BUIM'.
  hQ:ADD-BUFFER(phBufferCacheBuffer).
  hQ:QUERY-PREPARE("FOR EACH "  + phBufferCacheBuffer:NAME ).
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  DO WHILE phBufferCacheBuffer:AVAILABLE:
    hTT = phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE.

    IF VALID-HANDLE(hTT:TABLE-HANDLE) THEN
        DELETE OBJECT hTT:TABLE-HANDLE NO-ERROR.

    IF VALID-HANDLE(hTT) THEN
        DELETE OBJECT hTT NO-ERROR.
    hQ:GET-NEXT().
  END.
  hq:QUERY-CLOSE().
  DELETE OBJECT hq.
  hq = ?.

  /* Ditch the buffer cache (cache_BufferCache) */
  IF VALID-HANDLE(phBufferCacheBuffer:TABLE-HANDLE) THEN
      DELETE OBJECT phBufferCacheBuffer:TABLE-HANDLE NO-ERROR.

  IF VALID-HANDLE(phBufferCacheBuffer) THEN
      DELETE OBJECT phBufferCacheBuffer NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBrowse Procedure 
PROCEDURE doBrowse :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       - tt_object_instance was read in outputUILayout which called this routine
               - Use 'b' + SDO name for browse id
               -
               - ttSDORequiredFields is populated here to save having to run
                 determineSDOFieldsUsed.
               ttSDORequiredFields
 Issues:    - browse height & wide
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldSecurity    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFiltType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFldNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlClass        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlStyle        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJavaScriptObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecurity         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dAttrRecId        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttrBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iFld              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumFlds          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lNoLabel          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTableIOTarget    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cSecuredHiddenFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredReadOnlyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames       AS CHARACTER  NO-UNDO.

  ASSIGN
    dObj         = ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE
    cLogicalName = ghObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
    cSDOName     = getSdoLink(dObj)
    hAttrBuf     = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
    dAttrRecId   = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
  hAttrBuf:FIND-FIRST(" WHERE ":U + hAttrBuf:NAME + ".tRecordIdentifier = DEC('" + STRING(dAttrRecId) + "')") NO-ERROR.

  ASSIGN
    cFldNames        = hAttrBuf:BUFFER-FIELD("DisplayedFields":U):BUFFER-VALUE
    cHtmlClass       = hAttrBuf:BUFFER-FIELD("HtmlClass":U):BUFFER-VALUE
    cDataSourceNames = hAttrBuf:BUFFER-FIELD("DataSourceNames":U):BUFFER-VALUE
    cFieldSecurity   = hAttrBuf:BUFFER-FIELD("FieldSecurity":U):BUFFER-VALUE
    c                = hAttrBuf:BUFFER-FIELD("FolderWindowToLaunch":U):BUFFER-VALUE
    cFiltType        = hAttrBuf:BUFFER-FIELD("FilterType":U):BUFFER-VALUE
    iNumFlds         = NUM-ENTRIES(cFldNames).
    
  cHtmlStyle        = hAttrBuf:BUFFER-FIELD("HtmlStyle":U):BUFFER-VALUE NO-ERROR.
  cJavaScriptObject = hAttrBuf:BUFFER-FIELD("JavaScriptObject":U):BUFFER-VALUE NO-ERROR.
  
  IF (cDataSourceNames = ? OR cDataSourceNames = "":U) THEN
    cDataSourceNames = cSDOName.
  IF cHtmlClass = "" OR cHtmlClass = ? THEN
    cHtmlClass = "browse".
  ASSIGN 
    cHtmlStyle        = (IF cHtmlStyle = ? THEN "" ELSE cHtmlStyle + ';':U)
    cJavaScriptObject = (IF cJavaScriptObject = ? OR cJavaScriptObject = ""
                         THEN "browse":U ELSE cJavaScriptObject).
    
  /* Determine which fields are hidden and which are readonly */
  DO iFld = 1 TO NUM-ENTRIES(cFldNames, ",":U):
    cFieldName = ENTRY(iFld, cFldNames) NO-ERROR.
    cSecurity  = ENTRY(iFld, cFieldSecurity) NO-ERROR.
    IF (ERROR-STATUS:ERROR) THEN
    ASSIGN
      ERROR-STATUS:ERROR = FALSE
      cSecurity          = '':U.
    IF ( cSecurity = 'Hidden':U ) THEN
      cSecuredHiddenFields = cSecuredHiddenFields + "," + cFieldName.
    ELSE IF ( cSecurity = 'Read Only':U OR cSecurity = 'Read-Only':U ) THEN
    ASSIGN
      cSecuredReadOnlyFields = cSecuredReadOnlyFields + "," + cFieldName
      cDisplayedFields       = cDisplayedFields + "," + cFieldName.
    ELSE
      cDisplayedFields = cDisplayedFields + "," + cFieldName.
  END.
  ASSIGN
    cDisplayedFields       = TRIM(cDisplayedFields, ",":U)
    cSecuredReadOnlyFields = TRIM(cSecuredReadOnlyFields, ",":U)
    cSecuredHiddenFields   = TRIM(cSecuredHiddenFields, ",":U).
  
  /* Save the hidden field list for sdo security */
  saveDSSecurity(gcLogicalObjectName, cSDOName, cSecuredHiddenFields).

  /* Set included Javascriptfiles */
  RUN includeJS(hAttrBuf:BUFFER-FIELD("JavaScriptFile":U):BUFFER-VALUE) NO-ERROR.
  
  /* Fieldset and browse DIV tags can have width and height for style attributes. */
  {&OUT}
    '<div class="' cHtmlClass '" style="width:' INTEGER(hAttrBuf:BUFFER-FIELD("MinWidth":U):BUFFER-VALUE * giPixelsPerColumn)
    'px;height:':U INTEGER(hAttrBuf:BUFFER-FIELD("MinHeight":U):BUFFER-VALUE * giPixelsPerRow)
    'px;' cHtmlStyle '" resize="resize" wdo="' cDataSourceNames '"' gcJustification ' id="':U + 
    cLogicalName + '" name="':U + cLogicalName + '" objtype="' + cJavaScriptObject + '" ':U 
    (IF cFiltType = "inline":U THEN 'filter="inline"':U ELSE "") SKIP
    '  fields="':U.

  /* Store the value of FolderWindowToLaunch attribute against the SDO.
     This is used in doSDO. */
  IF c <> '':U AND c <> ? THEN DO:
    FIND ttObjAttr WHERE
         ttObjAttr.topObjectName = gcLogicalObjectName AND
         ttObjAttr.objName       = cSDOName AND
         ttObjAttr.attrName      = 'FolderWindowToLaunch':U
         NO-ERROR.
    IF NOT AVAILABLE ttObjAttr THEN DO:
      CREATE ttObjAttr.
      ASSIGN
        ttObjAttr.topObjectName = gcLogicalObjectName
        ttObjAttr.objName       = cSDOName
        ttObjAttr.attrName      = 'FolderWindowToLaunch':U.
    END.
    ttObjAttr.attrValue = c.
  END.

  {&OUT} 
    html-encode(REPLACE(LC(cDisplayedFields), ",":U, "|":U)) + '"':U SKIP 
    ' enabled="':U.

  /* If the Browse is not a TableIO target, then its fields should not be 
     enabled. Otherwise defer to EnabledFields attribute to apply correct 
     enabled state. */
  IF CAN-FIND(FIRST ttLink WHERE ttLink.ttType = "TableIO":U AND 
                ttLink.ttSDO = cSDOName AND ttLink.ttTo = dObj) THEN
    lTableIOTarget = TRUE.
  cEnabledFields = hAttrBuf:BUFFER-FIELD("EnabledFields":U):BUFFER-VALUE.
  DO iFld = 1 TO iNumFlds:
    IF (LOOKUP(ENTRY(iFld, cFldNames), cDisplayedFields) > 0 ) THEN
    DO:
      {&OUT} 
        (IF NOT lTableIOTarget THEN 'n':U ELSE
          (IF LOOKUP(ENTRY(iFld, cFldNames), cSecuredReadOnlyFields) > 0 THEN 'n':U ELSE
            (IF LOOKUP(ENTRY(iFld, cFldNames), cEnabledFields) > 0 
              THEN 'y':U ELSE 'n':U))) +         
        (IF iFld < iNumFlds THEN '|':U ELSE '':U).
    END.
  END.

  {&OUT}
    '" ':U SKIP
    '  labels="':U.

  DO iFld = 1 TO iNumFlds:
    IF (LOOKUP(ENTRY(iFld, cFldNames), cDisplayedFields) > 0 ) THEN
      ASSIGN
        cLabel  = ENTRY(iFld, hAttrBuf:BUFFER-FIELD('BrowseColumnLabels':U):BUFFER-VALUE, CHR(5))
        cLabel  = (IF cLabel <> '?' THEN cLabel ELSE ENTRY(iFld, cFldNames))
        cLabels = cLabels + '|':U + cLabel.
  END. /* DO iFld = 1 TO iNumFlds */
    
  /* Remove first | as we check for first entry when building this list (for 
     performance) */
  cLabels = TRIM(cLabels, '|':U). 
  {&OUT}
    cLabels '"></div>~n':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doButton Procedure 
PROCEDURE doButton :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for BUTTON
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cImage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled   AS LOGICAL    NO-UNDO.

  ASSIGN lEnabled = LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE) NO-ERROR.
  /* Token Security for the buttons */
  IF ( gcSecuredTokens > "":U AND CAN-DO(gcSecuredTokens, pcID)) THEN
    lEnabled = FALSE.

  ASSIGN
    iOrder   = phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE
    pcHtml   = SUBSTITUTE(
               '<button id="&1" name="&1" class="&2" title="&3" tabindex="&4"':U
               ,pcID
               ,pcHtmlClass + IF lEnabled THEN " enable" ELSE " disable" 
               ,pcToolTip
               ,iOrder)
    cStyle   = SUBSTITUTE(
               ' style="top:&1px;left:&2px;height:&3px;width:&4px;&5"'
               ,piFieldRow
               ,piColumn
               ,piHeight + 5
               ,piWidth + 10
               ,pcHtmlStyle)
    cImage   = getImagePath(phBuffer:BUFFER-FIELD("IMAGE-FILE":U):BUFFER-VALUE)
    pcHtml   = pcHtml + cStyle +
               (IF phBuffer:BUFFER-FIELD("FLAT-BUTTON":U):BUFFER-VALUE 
                THEN " flat":U ELSE "":U) +
               (IF cImage <> '':U AND cImage <> ? 
                THEN " imgup='":U + cImage + "'":U ELSE "":U) +
               pcEventList + 
               (IF lEnabled THEN '>':U ELSE ' disabled="true">':U) + 
               pcLabel + '</button>':U
    pcHtml   = REPLACE(pcHtml,'~\':U,'/':U)
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doClientMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doClientMessages Procedure 
PROCEDURE doClientMessages :
/*------------------------------------------------------------------------------
  Purpose:     Provide the translations for client side messages.  Retrieve all
               HTM group messages.
  Parameters:  <none>
  Notes:       TBD: This should be moved to an external API.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.

  DEFINE BUFFER buf_gsc_error FOR gsc_error.
  
  ASSIGN 
    gdCurrentLanguageObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                            "currentLanguageObj":U, FALSE).
  FOR EACH gsc_error NO-LOCK
    WHERE gsc_error.error_group = "HTM":U
      AND gsc_error.source_language:
      
    FIND buf_gsc_error NO-LOCK
      WHERE buf_gsc_error.error_group  = gsc_error.error_group
        AND buf_gsc_error.error_number = gsc_error.error_number
        AND buf_gsc_error.language_obj = gdCurrentLanguageObj NO-ERROR.
    ASSIGN 
        cMessage = cMessage + (IF cMessage > '' THEN ',' ELSE '') + 
                 '"HTM':U + STRING(gsc_error.error_number) + '|' +
                 (IF AVAILABLE buf_gsc_error 
                 THEN buf_gsc_error.error_full_description
                 ELSE gsc_error.error_full_description) + '"~n'.
  END.
  gcJsRun = gcJsRun + '~napp.main.info.load([' + cMessage + ']);'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doComboBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doComboBox Procedure 
PROCEDURE doComboBox :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Progress COMBO-BOX, SELECTION-LIST
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcVisualization AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcClassName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piLabelRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDelimiter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelect    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListItems AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStep      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMultiple  AS LOGICAL    NO-UNDO.

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE)) NO-ERROR.
  
  IF pcVisualization = "SELECTION-LIST":U THEN 
    lMultiple  = LOGICAL(phBuffer:BUFFER-FIELD("multiple":U):BUFFER-VALUE) NO-ERROR.
        
  ASSIGN
    /* No LABEL property for SELECTION-LISTs in GUI */
    iOrder     = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)

    cLabel     = SUBSTITUTE(
                 '<label for="&4" style="top:&2px;left:0px;width:&3px;">&1&&#160;</label>~n':U
                 ,TRIM(html-encode(pcLabel))
                 ,piLabelRow
                 ,piColumn
                 ,pcID)
    cSelect    = SUBSTITUTE(
                 '<select class="&2" id="&1" name="&1" tabindex="&4" title="&3"&5&6'
                 ,pcID
                 ,pcHtmlClass
                 ,pcToolTip
                 ,iOrder
                 ,(IF lEnabled THEN '' ELSE ' disable="true"')
                 ,(IF lMultiple THEN ' multiple="multiple"' ELSE ''))
    cStyle     = SUBSTITUTE(
                 ' style="top:&1px;left:&2px;width:&3px;&4" size=&5 ':U
                 ,piFieldRow
                 ,piColumn
                 ,piWidth
                 ,pcHtmlStyle
                 ,(IF LOOKUP(pcClassName, gcDynComboBoxClasses) > 0 AND pcVisualization = "COMBO-BOX":U THEN '1' 
                   ELSE STRING(INTEGER(phBuffer:BUFFER-FIELD("height-chars":U):BUFFER-VALUE))))
    cDelimiter = phBuffer:BUFFER-FIELD("DELIMITER":U):BUFFER-VALUE
    pcHtml     = cLabel + cSelect + cStyle + pcEventList + '>~n':U.

  IF LENGTH(phBuffer:BUFFER-FIELD("LIST-ITEM-PAIRS":U):BUFFER-VALUE) > 0 THEN
    ASSIGN
      cListItems = phBuffer:BUFFER-FIELD("LIST-ITEM-PAIRS":U):BUFFER-VALUE
      iStep      = 1.
  ELSE
    ASSIGN
      cListItems = phBuffer:BUFFER-FIELD("LIST-ITEMS":U):BUFFER-VALUE
      iStep      = 0.
      
  DO ix = 1 TO NUM-ENTRIES(cListItems, cDelimiter):
    ASSIGN
      pcHTML = pcHTML +
               '<option value="':U +
               TRIM(ENTRY(ix + iStep, cListItems, cDelimiter)) +
               '">':U +
               TRIM(html-encode(TRIM(ENTRY(ix, cListItems, cDelimiter)))) +
               '</option>~n':U
      ix     = ix + iStep.
  END.
  
  pcHtml = pcHtml + '</select>':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doContainer Procedure 
PROCEDURE doContainer :
/*------------------------------------------------------------------------------
  Purpose:     Output the UI Layout
  Parameters:  <none>
  Notes:       Coded specifically for the DHTML client type
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClassName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerClass AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJustifyCode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLayoutCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLayoutPosition AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosition       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQ              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCurrPageNumber AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrRow        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastPageNumber AS INTEGER    NO-UNDO INITIAL -1.
  DEFINE VARIABLE iLastRow        AS INTEGER    NO-UNDO.
    
  /* Support up to 30 tabs x 9 rows each */
  DEFINE VARIABLE iNumRowObjects  AS INTEGER    NO-UNDO EXTENT 309. 
  DEFINE VARIABLE lRowStarted     AS LOGICAL    NO-UNDO.

  /* First correct the layout positions for backwards compatability. */
  ghObjectBuffer:FIND-FIRST(" WHERE ":U + ghObjectBuffer:NAME + 
    ".tLogicalObjectName = '":U + gcLogicalObjectName + "'":U ) NO-ERROR.
  IF ghObjectBuffer:AVAILABLE THEN DO:
    cContainerClass = ghObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE NO-ERROR.
    ghPageBuffer:FIND-FIRST(" WHERE ":U + ghPageBuffer:NAME + 
                            ".tRecordIdentifier = DEC('":U + 
                            ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE + "')") NO-ERROR.
    IF ghPageBuffer:AVAILABLE THEN
      ASSIGN cLayoutCode = ghPageBuffer:BUFFER-FIELD("tLayoutCode":U):BUFFER-VALUE NO-ERROR.
  END.


  CREATE QUERY hQ IN WIDGET-POOL 'B2BUIM':U.
  /* Make sure no previous record causes 'available' in the WHILE phrase below
     if the query fails. */
  ghObjectBuffer:BUFFER-RELEASE(). 
  ghPageBuffer:BUFFER-RELEASE(). 

  hQ:ADD-BUFFER(ghObjectBuffer).
  hQ:QUERY-PREPARE("FOR EACH ":U  + ghObjectBuffer:NAME + " WHERE ":U
    + ghObjectBuffer:NAME + ".tContainerObjectName = '":U + gcLogicalObjectName + "' AND ":U
    + "LOOKUP(" + ghObjectBuffer:NAME + ".tClassName, '" + gcDynObjClasses + "') = 0 AND ":U
    + "LOOKUP(" + ghObjectBuffer:NAME + ".tClassName, '" + gcDataClasses + "') = 0":U).

  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  /* Data rows */
  DO WHILE ghObjectBuffer:AVAILABLE:
    /* Store how many objects are on each row.  This is used so we can optimize 
       the HTML that determines the container layout.  If there is more than 1
       object on a row, then we will put all those objects within a table.
       Otherwise, if there is only 1 object on the row then we won't put it in 
       a table, because tables slow down the HTML to render. */
    ASSIGN
      iCurrRow = INTEGER(SUBSTRING(ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE,2,1)) NO-ERROR.
      IF ERROR-STATUS:ERROR OR iCurrRow = ? OR iCurrRow = 0 THEN
        iCurrRow = 1.
    /* Cater for up to 30 tabs x 9 rows each */
    ASSIGN
      iCurrRow = (ghObjectBuffer:BUFFER-FIELD('tPageNumber':U):BUFFER-VALUE * 10) + iCurrRow
      iNumRowObjects[iCurrRow] = iNumRowObjects[iCurrRow] + 1.

    /* Determine how to interpret the layout position for backwards compatability */
    ASSIGN
      cLayoutPosition = SUBSTRING(ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE,1,1).
    CASE cLayoutCode:
      WHEN "01":U OR WHEN "05":U THEN
        ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '':U.
      WHEN "02":U OR WHEN "03":U THEN DO:
        CASE cLayoutPosition:
          WHEN "T":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '111':U.
          WHEN "C":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '121':U.
          WHEN "M":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '1':U + SUBSTRING(ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE,2).
          WHEN "B":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '191':U.
        END CASE.   /* layout position */
      END.
      WHEN "04":U THEN DO:
        CASE cLayoutPosition:
          WHEN "L":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '111':U.
          WHEN "C":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '112':U.
          WHEN "R":U THEN ASSIGN ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '113':U.
        END CASE.   /* layout position */
      END.
      OTHERWISE DO:
        CASE cLayoutPosition:
          WHEN "T":U THEN
            ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '0':U + SUBSTRING(ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE,2).
          WHEN "M":U THEN
            ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '1':U + SUBSTRING(ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE,2).
          WHEN "B":U THEN
            ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE = '2':U + SUBSTRING(ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE,2).
        END CASE.   /* layout position */
      END.
    END CASE.
    hQ:GET-NEXT().
  END.
  hq:QUERY-CLOSE().

  RUN doSmartLinks.

  /* Do visual objects first (do SDO's after) */
  ASSIGN
    cWhere   = "FOR EACH ":U + ghObjectBuffer:NAME + " WHERE ":U
             + ghObjectBuffer:NAME + ".tContainerObjectName = '":U + gcLogicalObjectName + "'"
             + " BY ":U + ghObjectBuffer:NAME + ".tPageNumber":U
             + " BY ":U + ghObjectBuffer:NAME + ".tLayoutPosition":U
             + " BY ":U + ghObjectBuffer:NAME + ".tRecordIdentifier":U
    gcMenues = ''
    gcScreen = ''.
    
  /* Make sure nothing available - stop potential infinite loop below if query fails. */
  ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    logNote('note', "** ERROR preparing query for looping through UI objects, where: ":U + 
            cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + 
            PROGRAM-NAME(1)) NO-ERROR.
    RUN setMessage (INPUT "** ERROR preparing query for looping through UI objects, where: ":U + 
                    cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + 
                    PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().

  DO WHILE ghObjectBuffer:AVAILABLE:
    ASSIGN
      cClassName      = ghObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
      iCurrPageNumber = ghObjectBuffer:BUFFER-FIELD("tPageNumber":U):BUFFER-VALUE
      cPosition       = ghObjectBuffer:BUFFER-FIELD("tLayoutPosition":U):BUFFER-VALUE
      /* Justify (L,C,R) is in the Column character, ie if = L, C or R then no specified column - just justify instead (assume only one object if justified) */
      cJustifyCode    = SUBSTR(ENTRY(1,cPosition), LENGTH(ENTRY(1,cPosition)), 1) 
      gcJustification = IF cJustifyCode = 'L':U THEN ' align=left ':U ELSE 
                        IF cJustifyCode = 'C':U THEN ' align=center ':U ELSE 
                        IF cJustifyCode = 'R':U THEN ' align=right ':U ELSE '':U
      NO-ERROR.
    ASSIGN
      iCurrRow = INTEGER(SUBSTRING(ghObjectBuffer:BUFFER-FIELD('tLayoutPosition':U):BUFFER-VALUE,2,1)) NO-ERROR.
    IF ERROR-STATUS:ERROR OR iCurrRow = ? OR iCurrRow = 0 THEN
      iCurrRow = 1.
    /* Cater for upto 30 tabs x 9 rows each */
    iCurrRow = (ghObjectBuffer:BUFFER-FIELD('tPageNumber':U):BUFFER-VALUE * 10) + iCurrRow.

    /*lognote('note','Page/Pos/Class:' + string(iCurrPageNumber) + '/' + cPosition + '/' + cClassName).*/
    IF ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE = '0':U THEN 
    DO:
      {&OUT} '~n<form name="' gcLogicalObjectName '">':U SKIP.
      hQ:GET-NEXT().
      NEXT.
    END.

    IF cClassName <> "":U AND LOOKUP(cClassName, gcDataClasses) = 0 THEN 
    DO:
      /* We do a DIV for each row (in the 9x9 grid).  Note that the page 
         number is specified on each row so that they show on the correct tab */
      IF iCurrPageNumber > iLastPageNumber OR    /* change page */
         iCurrRow > iLastRow THEN   /* change row */
      DO:            
        IF lRowStarted THEN  /* end previous row and/or page */
        DO:                  
          IF iNumRowObjects[iLastRow] > 1 THEN
            {&OUT}  '</tr></table>':U SKIP.
          {&OUT} '</div>':U SKIP.
        END.

        /* Start row and/or page */
        lRowStarted = true.
        {&OUT}
          '~n<div class="pager':U (IF iCurrPageNumber > 0 
                   THEN (IF iCurrPageNumber = 1 THEN ' show' ELSE ' hide') 
                      + '" page="':U + STRING(iCurrPageNumber) 
                   ELSE '') + '">':U SKIP.

        /* For efficiency only output a table if there is more than one
           object on the current row, since HTML tables are slow to render. */
        IF iNumRowObjects[iCurrRow] > 1 THEN
          {&OUT}  '<table class="pos"><tr>':U SKIP.
      END.

      IF iNumRowObjects[iCurrRow] > 1 THEN
        {&OUT} '<td class="pos">':U SKIP.

      IF LOOKUP(cClassName, gcSmartFolderClasses) <> 0 THEN
        RUN doFolder.
      ELSE
      IF LOOKUP(cClassName, gcDynBrowClasses) <> 0 THEN
        RUN doBrowse.
      ELSE
      IF LOOKUP(cClassName, gcDynViewClasses) <> 0 THEN
        RUN doViewer (ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE).
      ELSE
      IF LOOKUP(cClassName, gcSmartToolbarClasses) <> 0 THEN
        RUN doToolbar(iCurrPageNumber,
          INPUT ghObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE,
          INPUT ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE,
          INPUT iCurrPageNumber > 0 OR NOT cPosition < "12").
      ELSE
      /* Skip reporting error for static SmartViewer on Menu Controller. */
      IF NOT(LOOKUP(cContainerClass, gcDynMencClasses) <> 0 AND LOOKUP(cClassName, gcSmartViewerClasses) <> 0) THEN
        {&OUT} "<h3>Unsupported:" + cClassName + "(" + STRING(ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE) + ")</h3>".

      IF iNumRowObjects[iCurrRow] > 1 THEN
        {&OUT} SKIP '</td>':U SKIP.
      /* Set iLastPageNumber to 1 if the current page is 0, i.e. no folders are 
         used.  Subsequent loops can tell that we're not on the first object and
         won't output another page TR & TD. */
      ASSIGN
        iLastPageNumber = iCurrPageNumber
        iLastRow        = iCurrRow.
    END. /* if not an SDO or SBO */
    hQ:GET-NEXT().
  END. /* FOR EACH tt_object_instance on page (Browse & Viewer objects) */
  hQ:QUERY-CLOSE().

  /* End previous row and/or page */
  IF lRowStarted THEN DO:
    IF iNumRowObjects[iLastRow] > 1 THEN
      {&OUT} '</tr></table>':U SKIP.
    {&OUT} '</div>':U SKIP.
  END.

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
    'screen_':U + gcLogicalObjectName, gcScreen, NO).
  
  {&OUT} '~n</form>~n':U SKIP.
  /* SDO must be done after Browse & Viewer as these build a list of fields
     used - so the SDO doesn't have to output unused fields (for performance).
     If you really need to do SDO's before Browse & viewers then comment out
     the code in them that builds the ttSDOusedFields tt and run determineSDOFieldsUsed
     before SDO's */
  {&OUT} '<div id="wbo" objtype="wbo">':U SKIP.
  IF glMasterLink THEN 
    {&OUT} '<div class="wdo" id="dmaster" remote="master" objtype="wdo"></div>~n'.
  cWhere  = "FOR EACH ":U + ghObjectBuffer:NAME + " WHERE ":U
          + ghObjectBuffer:NAME + ".tContainerObjectName = '":U + gcLogicalObjectName + "' AND ":U  
          + ghObjectBuffer:NAME + ".tUserObj = '":U + STRING(gdCurrentUserObj) + "' AND ":U         
          + ghObjectBuffer:NAME + ".tResultCode = '":U + gcSessionResultCodes + "' AND ":U
          + ghObjectBuffer:NAME + ".tRunAttribute = '":U + gcRunAttribute + "' AND ":U
          + ghObjectBuffer:NAME + ".tLanguageObj = '":U + STRING(gdCurrentLanguageObj) + "' AND ":U
          + ghObjectBuffer:NAME + ".tObjectInstanceObj <> 0 AND ":U                                 
          + "LOOKUP(" + ghObjectBuffer:NAME + ".tClassName, '" + gcDataClasses + "') <> 0 "
          + " BY ":U + ghObjectBuffer:NAME + ".tPageNumber":U
          + " BY ":U + ghObjectBuffer:NAME + ".tInstanceOrder":U.
  lognote('note','SDOquery=' + cWhere).
  ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. /* Make sure nothing available - stop potential infinate loop below if query fails. */
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    logNote('note', "** ERROR preparing query for looping through SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)) NO-ERROR.
    RUN setMessage  (INPUT "** ERROR preparing query for looping through SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  DO WHILE ghObjectBuffer:AVAILABLE:
    lognote('note','SDO=' + ghObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE).
    RUN doSDO.
    hQ:GET-NEXT().
  END. /* FOR EACH SDO */
  hQ:QUERY-CLOSE().
  DELETE OBJECT hQ NO-ERROR.
  ASSIGN hQ = ?.
  {&OUT} '</div>':U SKIP. /* end WBO */

  /* If top-level menu controller, then we don't need this
  RUN outputMenu("|2|app.exit|<button & title='Back'>Back</button>",'toolbar page=0').
  */
  IF LOOKUP(cContainerClass, gcDynMencClasses) = 0 THEN
    RUN outputMenu("|2|app.exit|<img & src='../img/exit.gif' title='Exit (ALT-X)' />",'"toolbar" page="0"').
  {&OUT} gcMenues.

  IF cContainerClass = 'DynTree' THEN DO:
    RUN doTreeview(gcLogicalObjectName,'','').
    gcJSrun = gcJSrun + "~napp.main.treeview.branch('" 
            + gcLogicalObjectName + "',null," + RETURN-VALUE + ");~n".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynCombo Procedure 
PROCEDURE doDynCombo :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Dynamics DynCombo
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phAttrBuf   AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.
    
  DEFINE VARIABLE cComboFlag        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlStyle        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelect           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldRow         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLabelRow         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOrder            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE oBFhD             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oBFhI             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oBh               AS HANDLE     NO-UNDO EXTENT 20.
  DEFINE VARIABLE oDbValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oDisplayFieldName AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE oDisplayTemp      AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE oDisplayValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oIdx              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE oNotEmpty         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE oQh               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oSuccess          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phAttrBuf:BUFFER-FIELD("EnableField":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
    cDescSubstitute = phAttrBuf:BUFFER-FIELD("DescSubstitute":U):BUFFER-VALUE
    cDispFields     = phAttrBuf:BUFFER-FIELD("DisplayedField":U):BUFFER-VALUE
    cKeyField       = phAttrBuf:BUFFER-FIELD("keyField":U):BUFFER-VALUE
    cQueryTables    = phAttrBuf:BUFFER-FIELD("queryTables":U):BUFFER-VALUE
    iOrder          = tabIndex(phAttrBuf:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    cComboFlag      = phAttrBuf:BUFFER-FIELD("ComboFlag":U):BUFFER-VALUE
    cFlagValue      = phAttrBuf:BUFFER-FIELD("FlagValue":U):BUFFER-VALUE
    cFormat         = phAttrBuf:BUFFER-FIELD("KeyFormat":U):BUFFER-VALUE
    cDataType       = phAttrBuf:BUFFER-FIELD("KeyDataType":U):BUFFER-VALUE
    NO-ERROR.

  cHtmlStyle      = phAttrBuf:BUFFER-FIELD("HtmlStyle":U):BUFFER-VALUE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    lognote('note',ERROR-STATUS:GET-MESSAGE(1)).
        
  DO oIdx = 1 TO NUM-ENTRIES(cDispFields):
    ASSIGN
      oDisplayFieldName[oIdx] = ENTRY(oIdx,cDispFields)
      oDisplayFieldName[oIdx] = (IF INDEX(oDisplayFieldName[oIdx], ".":U) > 0 
                                 THEN ENTRY(2, oDisplayFieldName[oIdx], ".":U) 
                                 ELSE oDisplayFieldName[oIdx]).
  END.
  oFieldName = (IF INDEX(cKeyField, ".":U) > 0 THEN ENTRY(2, cKeyField, ".":U) ELSE cKeyField).
  CREATE QUERY oQh IN WIDGET-POOL "B2BUIM":U.
  REPEAT oIdx = 1 TO NUM-ENTRIES(cQueryTables):
    CREATE BUFFER oBh[oIdx] FOR TABLE ENTRY(oIdx,cQueryTables) 
      IN WIDGET-POOL "B2BUIM":U NO-ERROR.

    IF ERROR-STATUS:ERROR THEN NEXT.
    oQh:ADD-BUFFER(oBh[oIdx]) NO-ERROR.
  END.
  oSuccess = oQh:QUERY-PREPARE(phAttrBuf:BUFFER-FIELD("baseQueryString":U):BUFFER-VALUE) NO-ERROR.
  IF oSuccess THEN DO:
    ASSIGN cLabel = phAttrBuf:BUFFER-FIELD("FieldLabel":U):BUFFER-VALUE NO-ERROR.
    IF (cLabel > "":U AND INDEX(cLabel, ":") = 0) THEN
      cLabel = cLabel + ":":U.
    cHtmlStyle = IF cHtmlStyle = ? THEN "" ELSE cHtmlStyle + ';'.

    ASSIGN
      iLabelRow = INTEGER(phAttrBuf:BUFFER-FIELD("row":U):BUFFER-VALUE * giPixelsPerRow) + 
                    giFieldOffsetTop
      iFieldRow = iLabelRow - 2
      pcHtml    = SUBSTITUTE(
                  '<label for="&4" style="top:&2px;left:0px;width:&3px;">&1&&#160;</label>~n'
                  ,TRIM(html-encode(cLabel))
                  ,iLabelRow
                  ,INTEGER(phAttrBuf:BUFFER-FIELD("column":U):BUFFER-VALUE * giPixelsPerColumn)
                  ,pcID)
      cSelect   = SUBSTITUTE(
                  '<select class="field" id="&1" name="&1" tab="&3" size="1" title="&2" &4'
                  ,pcID  
                  ,phAttrBuf:BUFFER-FIELD("FieldTooltip":U):BUFFER-VALUE
                  ,iOrder
                  ,(IF lEnabled THEN '' ELSE 'disable="true"':U))
      cStyle    = SUBSTITUTE(
                  ' style="top:&1px;left:&2px;height:&3px;width:&4px;&5" &6>~n':U
                  ,iFieldRow
                  ,INTEGER(phAttrBuf:BUFFER-FIELD("column":U):BUFFER-VALUE * giPixelsPerColumn)
                  ,INTEGER(phAttrBuf:BUFFER-FIELD("height-chars":U):BUFFER-VALUE * giPixelsPerRow)
                  ,INTEGER(phAttrBuf:BUFFER-FIELD("width-chars":U):BUFFER-VALUE * giPixelsPerColumn)
                  ,cHtmlStyle
                  ,pcEventList)
      pcHtml    = pcHtml + cSelect + cStyle.

    /* Run the query */
    oQh:QUERY-OPEN().
    oNotEmpty = oQh:GET-FIRST(NO-LOCK).
    IF NOT(oQh:QUERY-OFF-END) AND oNotEmpty THEN 
    DO:
      ASSIGN oIdx = MAXIMUM(1, LOOKUP(ENTRY(1, oFieldName, ".":U), cQueryTables)).
      IF VALID-HANDLE(oBh[oIdx]) AND oBh[oIdx]:AVAILABLE THEN 
      DO:
        IF (cFormat > "":U) THEN
          ASSIGN oBh[oIdx]:BUFFER-FIELD(oFieldName):FORMAT = cFormat.
        ASSIGN oBFhI = oBh[oIdx]:BUFFER-FIELD(oFieldName) NO-ERROR.
        
        /* Just in case */
        IF (cFormat = ? OR cFormat = "":U) THEN
          cFormat = oBFhI:FORMAT.
        IF (cDataType = ? OR cDataType = "":U) THEN
          cDataType = oBFhI:DATA-TYPE.
      END.
    END.
                
    /* <all> or <none> option is being used. */
    IF cComboFlag <> ? AND cComboFlag <> "" THEN
      ASSIGN
        cFlagValue = formatValue(cFlagValue, cFormat, cDataType)
        pcHtml     = pcHtml + '<option value="':U + cFlagValue + '">':U + 
                     html-encode(IF cComboFlag = "A":U THEN '<all>' ELSE '<none>') + 
                     '</option>~n':U.

    REPEAT WHILE NOT(oQh:QUERY-OFF-END) AND oNotEmpty:
      /* Get display value */
      ASSIGN
        oDbValue      = RIGHT-TRIM(oBFhI:STRING-VALUE)
        oDisplayValue = "":U
        oDisplayTemp  = "":U.
        
      DO oIdx = 1 TO NUM-ENTRIES(cDispFields):
        ASSIGN 
                cField = ENTRY(oIdx, cDispFields)
                ix     = MAXIMUM(1, LOOKUP(ENTRY(1, cField, ".":U), cQueryTables))
          oBFhD  = oBh[ix]:BUFFER-FIELD(ENTRY(2,cField,".":U)).
        IF VALID-HANDLE(oBFhD) THEN
          oDisplayTemp[oIdx] = RIGHT-TRIM(STRING(oBFhD:BUFFER-VALUE())).
      END.
      oDisplayValue = SUBSTITUTE(cDescSubstitute,oDisplayTemp[1],oDisplayTemp[2],oDisplayTemp[3],oDisplayTemp[4],oDisplayTemp[5],oDisplayTemp[6],oDisplayTemp[7],oDisplayTemp[8],oDisplayTemp[9]).
      /* Write out the OPTION tag */
      pcHtml = pcHtml + '<option value="' + oDbValue + '">' + 
               TRIM(html-encode(RIGHT-TRIM(oDisplayValue))) + 
               '</option>~n'.
      oQh:GET-NEXT(NO-LOCK).
    END. /* REPEAT */
    
    pcHtml = pcHtml + '</select>~n'.
  END. /* If <success on query prepare> */
  
  /* Clean up */
  oQh:QUERY-CLOSE().
  DO oIdx = 1 TO NUM-ENTRIES(cQueryTables):
    DELETE OBJECT oBh[oIdx] NO-ERROR.
    ASSIGN oBh[oIdx] = ?.
  END.
  DELETE OBJECT oQh NO-ERROR.
  ASSIGN oQh = ?.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynLookup Procedure 
PROCEDURE doDynLookup :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Dynamic Lookup (SmartDataField)
  Parameters:  <none>
  Notes:       ***** SSB ****
               The <local> field implementation in this procedure is a 
               temperory work-around and needs to be addressed.
               ***** SSB ****
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piLabelRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSdoName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE INPUT  PARAMETER pcViewer    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cID             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInput          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedWidgets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedWidget   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupObj      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIsLocalField   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQualifiedParentField AS CHARACTER  NO-UNDO.

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("EnableField":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
    iOrder          = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    cDisplayedField = ENTRY(2, phBuffer:BUFFER-FIELD("DisplayedField":U):BUFFER-VALUE, ".":U)
    cLinkedFields   = phBuffer:BUFFER-FIELD("ViewerLinkedFields":U):BUFFER-VALUE
    cLinkedWidgets  = phBuffer:BUFFER-FIELD("ViewerLinkedWidgets":U):BUFFER-VALUE
    cKeyField       = phBuffer:BUFFER-FIELD("KeyField":U):BUFFER-VALUE
    cParentField    = phBuffer:BUFFER-FIELD("ParentField":U):BUFFER-VALUE
    cLookupObj      = ENTRY(2,pcID,'.')
    cLField         = cDisplayedField
    NO-ERROR.

  ASSIGN lIsLocalField = phBuffer:BUFFER-FIELD("LocalField":U):BUFFER-VALUE NO-ERROR.

  DO ix = 1 TO NUM-ENTRIES(cParentField, ",":U):
    cQualifiedParentField = cQualifiedParentField + "," + pcSdoName + "." + ENTRY(ix, cParentField, ",":U).
  END.
  cQualifiedParentField = TRIM(cQualifiedParentField, ",":U).

  /* This is handling for local fields */
  IF (cLookupObj = "<local>") THEN
  DO:
    ASSIGN lIsLocalField = YES
           giLocalFieldCounter = giLocalFieldCounter + 1
           cLookupObj = "local_" + STRING(giLocalFieldCounter).
  END.
  ELSE IF (cLookupObj BEGINS "<") THEN
  DO:
    ASSIGN lIsLocalField = YES
           cLookupObj = TRIM(cLookupObj, ">":U)
           cLookupObj = TRIM(cLookupObj, "<":U).
  END.

  /* Save off linked widget references for later processing of the target object. */
  IF cLinkedFields <> "" AND cLinkedFields <> ? THEN 
  DO ix = 1 TO NUM-ENTRIES(cLinkedFields):
    ASSIGN
      cLinkedField  = ENTRY(ix, cLinkedFields)
      cLinkedWidget = ENTRY(ix, cLinkedWidgets)
      cLField       = cLField + ',' + ENTRY(NUM-ENTRIES(cLinkedField,'.'),cLinkedField,'.').
        
    IF NOT CAN-FIND(FIRST ttLinkedField WHERE
      ttLinkedField.cSDO    = pcSDOName AND 
      ttLinkedfield.cViewer = pcViewer AND
      ttLinkedField.cWidget = cLinkedWidget) THEN 
    DO:
      CREATE ttLinkedField.
      ASSIGN
        ttLinkedField.cSDO     = pcSDOName
        ttLinkedField.cViewer  = pcViewer
        ttLinkedField.cLookup  = cLookupObj
        ttLinkedField.cWidget  = cLinkedWidget
        ttLinkedField.cField   = cLinkedField
        ttLinkedField.lIsLocal = lIsLocalField
        .
    END.
  END.

  ASSIGN cFieldLabel = phBuffer:BUFFER-FIELD("FieldLabel":U):BUFFER-VALUE NO-ERROR.
  IF (cFieldLabel > "":U AND INDEX(cFieldLabel, ":") = 0) THEN
    cFieldLabel = cFieldLabel + ":":U.

  ASSIGN
    cID    = LC(pcSdoName + "._":U + cLookupObj)
    cType  = "text" /* (IF plDisplay THEN "text":U ELSE "hidden":U) */
    cLabel = SUBSTITUTE(
             '<label for="&1" style="top:&2px;left:0px;width:&3px;&4">&5&&#160;</label>~n'
             ,cID
             ,piLabelRow
             ,piColumn
             ,"" /* (IF NOT plDisplay THEN "display:none" ELSE "") */
             ,TRIM(html-encode(cFieldLabel)))
    cInput = SUBSTITUTE(
             '<input class="&1" type="&2" id="&3" name="&3" tab="&4" title="&5" lookup="&6" lfield="&7" dfield="&8" utilimg="../img/find.gif" utiltip="Lookup &6" lookupparent="&9"'
             ,pcHtmlClass
             ,cType
             ,cID
             ,iOrder
             ,phBuffer:BUFFER-FIELD("FieldTooltip":U):BUFFER-VALUE
             ,LC(phBuffer:BUFFER-FIELD("LogicalObjectName":U):BUFFER-VALUE)
             ,LC(cLookupObj)
             ,LC(cLField)
             ,LC(cQualifiedParentField))             
    cStyle = SUBSTITUTE(
             ' style="top:&1px;left:&2px;width:&3px;&4" &5 />'
             ,piFieldRow
             ,piColumn
             /* Reduce size to allow for lookup button to be inserted by js */
             ,(piWidth - 20)
             ,pcHtmlStyle
             ,(IF lEnabled THEN '' ELSE 'disabled="disabled"'))
    pcHtml = cLabel + cInput + cStyle.
    
  IF NOT lISlocalField THEN
  DO:
    IF LOOKUP(pcSdoName,gcScreen,'|') = 0 THEN
      gcScreen = gcScreen + '|' + pcSDOName + '|'.
    
    ASSIGN
      ix                        = LOOKUP(pcSdoName,gcScreen,'|':U) + 1
      ENTRY(ix, gcScreen,'|':U) = ENTRY(ix, gcScreen,'|':U)
        + (IF ENTRY(ix, gcScreen,'|':U) = "" THEN "" ELSE CHR(4))
        + cKeyField + CHR(4)
        + phBuffer:BUFFER-FIELD("DisplayedField":U):BUFFER-VALUE + CHR(4)
        + phBuffer:BUFFER-FIELD("KeyDataType":U):BUFFER-VALUE + CHR(4)
        + phBuffer:BUFFER-FIELD("FieldName":U):BUFFER-VALUE + CHR(4)
        + phBuffer:BUFFER-FIELD("BaseQueryString":U):BUFFER-VALUE + CHR(4)
        + phBuffer:BUFFER-FIELD("QueryTables":U):BUFFER-VALUE + CHR(4)
        + phBuffer:BUFFER-FIELD("ViewerLinkedFields":U):BUFFER-VALUE + CHR(4)
        + cLookupObj.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEditor Procedure 
PROCEDURE doEditor :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for EDITOR 
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cHtmlTag   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lWrap      AS LOGICAL    NO-UNDO.

  ASSIGN 
    lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
               (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE)) 
    lWrap    = LOGICAL(phBuffer:BUFFER-FIELD("word-wrap":U):BUFFER-VALUE) NO-ERROR.
  
  IF pcLabel <> "" THEN
    cLabel   = SUBSTITUTE(
               '<label for="&4" style="top:&2px;left:0px;width:&3px;">&1&&#160;</label>~n'
               ,TRIM(html-encode(pcLabel))
               ,piFieldRow
               ,piColumn
               ,pcID).
  ASSIGN
    iOrder   = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    pcHTML   = SUBSTITUTE(
               '<textarea class="&2" id="&1" name="&1" &3 tab="&4" title="&5" &6'
               ,pcID
               ,pcHtmlClass
               ,(IF lWrap THEN 'wrap="wrap"':U ELSE '')
               ,iOrder
               ,pcToolTip
               ,(IF lEnabled THEN '' ELSE 'disable="true"':U))
    cStyle     = SUBSTITUTE(
               ' style="top:&1px;left:&2px;height:&3px;width:&4px;&5" '
               ,piFieldRow
               ,piColumn
               ,piHeight
               ,piWidth
               ,pcHtmlStyle)
    pcHtml   = cLabel + pcHtml + cStyle + pcEventList + '></textarea>'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doFillIn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doFillIn Procedure 
PROCEDURE doFillIn :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for FILL-IN
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piLabelRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSDOName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcViewer    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cLabel   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInput   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPopup   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewer  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lPopup   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lEnabled AS LOGICAL    NO-UNDO.

  /* Check if this field is a Dynamic Lookup LinkedWidget, then override pcID. */
  cName = phBuffer:BUFFER-FIELD("NAME":U):BUFFER-VALUE NO-ERROR.
  FIND FIRST ttLinkedField 
    WHERE ttLinkedField.cSDO    = pcSDOName AND
          ttLinkedField.cViewer = pcViewer AND
          ttLinkedField.cWidget = cName NO-ERROR.
  IF AVAILABLE ttLinkedField THEN
    pcID = LC(pcSDOName + '._':U + ttLinkedField.cLookup + ENTRY(2, ttLinkedField.cField, ".":U)).

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
    iOrder = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    cLabel = SUBSTITUTE(
             '<label for="&4" style="top:&2px;left:0px;width:&3px;">&1&&#160;</label>~n'
             ,TRIM(html-encode(pcLabel))
             ,piLabelRow
             ,piColumn
             ,pcID)
    cInput = SUBSTITUTE(
             '<input class="&1" type="text" id="&2" name="&2" tab="&3" title="&4" &5'
             ,pcHtmlClass
             ,pcID
             ,iOrder
             ,pcToolTip
             , (IF lEnabled THEN '' ELSE 'disable="true"':U))
    cStyle = SUBSTITUTE(
             ' style="top:&1px;left:&2px;height:&3px;width:&4px;&5" &6 />'
             ,piFieldRow
             ,piColumn
             ,piHeight
             ,piWidth
             ,pcHtmlStyle
             ,pcEventList).
  IF phBuffer:BUFFER-FIELD("ShowPopup":U):BUFFER-VALUE THEN 
    CASE (phBuffer:BUFFER-FIELD("DATA-TYPE":U):STRING-VALUE):
      WHEN "date" THEN 
        cPopup = 'util="../dhtml/rycalendar.htm" utilimg="../img/calendar.gif" utiltip="Calendar tool" '.
      WHEN "integer" OR WHEN "decimal" THEN 
        cPopup = 'util="../dhtml/rycalculator.htm" utilimg="../img/calculator.gif" utiltip="Calculator tool" '.
    END CASE.
  ASSIGN
    pcHtml = cLabel + cInput + cPopup + cStyle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doFolder Procedure 
PROCEDURE doFolder :
/*------------------------------------------------------------------------------
  Purpose:     Do Folder Tabs
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTabLabels  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dAttrRecId  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttrBuf    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTabEnabled AS CHARACTER  NO-UNDO.

  ASSIGN
    hAttrBuf   = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
    dAttrRecId = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
  hAttrBuf:FIND-FIRST(" WHERE ":U + hAttrBuf:NAME + ".tRecordIdentifier  = DEC('" + STRING(dAttrRecId) + "')") NO-ERROR.

  ASSIGN
    cTabLabels  = hAttrBuf:BUFFER-FIELD("FolderLabels":U):BUFFER-VALUE
    cTabEnabled = hAttrBuf:BUFFER-FIELD("TabEnabled":U):BUFFER-VALUE
    cVisType    = gcFolderType NO-ERROR.

  logNote('note','Folder=' + cVisType).
  /* Default to tabs */
  ASSIGN cVisType = IF (cVisType <> ? AND cVisType BEGINS 'wizard':U) 
                    THEN 'wizard':U ELSE 'folder':U.

  {&OUT}
    '<div id="':U + cVisType + '" name="':U + cVisType + '" tabs="':U + REPLACE(cTabLabels, '&':U, '':U) + 
      '" enabled="':U + cTabEnabled + '" objtype="' cVisType '"></div>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doImage Procedure 
PROCEDURE doImage :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for IMAGE
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cImage   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnabled AS LOGICAL    NO-UNDO.

  ASSIGN lEnabled = LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE) NO-ERROR.
  
  ASSIGN
    cImage = SUBSTITUTE(
             '<img class="&2" id="&1" name="&1" src="&3" alt="&4" &5'
             ,pcID
             ,pcHtmlClass
             ,getImagePath(phBuffer:BUFFER-FIELD("IMAGE-FILE":U):BUFFER-VALUE)
             ,pcToolTip
             ,(IF lEnabled THEN '' ELSE 'disable="true"':U))
    cStyle = SUBSTITUTE(
             ' style="top:&1px;left:&2px;&3" &4 />~n':U
             ,piFieldRow
             ,piColumn
             ,pcHtmlStyle
             ,pcEventList)
    pcHtml = REPLACE(cImage + cStyle,'~\':U,'/':U)
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doLookup Procedure 
PROCEDURE doLookup :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWindowTitle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAttrBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2                AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cParentField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTemp              AS CHARACTER  NO-UNDO.

  RUN fetchUI.
  hAttrBuf = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
  hAttrBuf:FIND-FIRST(" WHERE " + hAttrBuf:NAME + ".tRecordIdentifier = DEC('"
         + ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE + "')") NO-ERROR.

  ASSIGN
    cDispField       = hAttrBuf:BUFFER-FIELD("DisplayedField":U):BUFFER-VALUE
    cRowsToBatch     = hAttrBuf:BUFFER-FIELD("RowsToBatch":U):BUFFER-VALUE
    cQueryFields     = hAttrBuf:BUFFER-FIELD("BrowseFields":U):BUFFER-VALUE
    cKeyField        = hAttrBuf:BUFFER-FIELD("KeyField":U):BUFFER-VALUE
    cQueryTables     = hAttrBuf:BUFFER-FIELD("QueryTables":U):BUFFER-VALUE
    cParentField     = hAttrBuf:BUFFER-FIELD("ParentField":U):BUFFER-VALUE
    cParentFilterQuery = hAttrBuf:BUFFER-FIELD("ParentFilterQuery":U):BUFFER-VALUE
    cLookupValue     = GET-VALUE('lookup')
    i1               = NUM-ENTRIES(cQueryFields)
    cDispField       = ENTRY(NUM-ENTRIES(cDispField,'.'),cDispField,'.')
    cBrowseFields    = REPLACE(cQueryFields,ENTRY(1,cQueryFields,'.') + '.','')
    /* Note that the start command will clean-up any previous context */
    gcRequestEvents  = '|lookup.start|lookup.filter'
    cWindowTitle     = hAttrBuf:BUFFER-FIELD("BrowseTitle":U):BUFFER-VALUE
    .
  IF (cParentField > "":U) THEN
    cParentFieldValue = GET-VALUE('lookupParent').

  logNote('note','lookupvalue=' + GET-VALUE('lookupParent')).

  /** Provide only the matches of entered begins search **/
  IF (cRowsToBatch = ? OR cRowsToBatch = '':U) THEN
    cRowsToBatch = "50":U.

  saveDSProperty(gcLogicalObjectName, "lookup":U, "RowsToBatch":U, cRowsToBatch).
  saveDSPath("lookup":U, "adm2/dynsdo.w":U).

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
   'LookupQuery,LookupTables,LookupFields,LookupDisplay,LookupValue',
    hAttrBuf:BUFFER-FIELD("BaseQueryString":U):BUFFER-VALUE
    + CHR(3) + cQueryTables
    + CHR(3) + cKeyField + ',' + cQueryFields 
    + CHR(3) + cDispField
    + CHR(3) + cLookupValue
    ,NO).

  cTemp = "":U.
  /* This is if the value is partially typed */
  logNote("note":U, "Parent field is: " + cParentField + " parent filter: " + cPArentFilterQuery + " parent field value: " + cParentFieldValue).

  IF (cLookupValue > '':U) THEN 
  DO:
    IF hAttrBuf:BUFFER-FIELD("DisplayDataType":U):BUFFER-VALUE = "character"  THEN
      cTemp = '|' + cDispField + ' > ' + cLookupValue + '|' + cDispField + ' < ' + cLookupValue + CHR(255).
    ELSE
      cTemp = '|' + cDispField + ' > ' + cLookupValue.
  END.
  /* This is if the Parent field has been specified */
  IF (cParentFieldValue > "":U AND cParentFilterQuery > "":U) THEN 
  DO:
    cParentFilterQuery = REPLACE(cParentFilterQuery, "'", "":U).
    cParentFilterQuery = REPLACE(cParentFilterQuery, '"', '':U).
    cTemp = cTemp + '|' + SUBSTITUTE(cParentFilterQuery, cParentFieldValue).
  END.
  /* This is concat of the two cases above */
  IF (cTemp > "":U) THEN
    set-user-field('dlookup._filter':U, cTemp).

  {&OUT}
    '~napp.wbo.lookup("' cWindowTitle '","' REPLACE(LC(cBrowseFields),',','|') '");~n'.
  RUN setClientAction('wbo.lookup').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doRadioSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doRadioSet Procedure 
PROCEDURE doRadioSet :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for RADIO-SET 
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE c1          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iItems      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLabelTop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLabelWidth AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOrder      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHorizontal AS LOGICAL    NO-UNDO.

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
    iOrder      = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    lHorizontal = LOGICAL(phBuffer:BUFFER-FIELD("Horizontal":U):BUFFER-VALUE)
    iLabelTop   = piFieldRow + 4
    iLabelWidth = piColumn - 5
    pcHtml      = SUBSTITUTE(
                  '<div class="&3" style="top:&6px;left:0px;width:&7px" align="right">&5</div>~n' +
                  '<div class="&3" style="top:&1px;left:&2px;" title="&4">~n':U
                  ,piFieldRow
                  ,piColumn
                  ,pcHtmlClass
                  ,pcToolTip
                  ,pcLabel
                  ,iLabelTop
                  ,iLabelWidth)
    c1          = phBuffer:BUFFER-FIELD("RADIO-BUTTONS":U):BUFFER-VALUE
    iItems      = NUM-ENTRIES(c1) / 2
    cDelimiter  = phBuffer:BUFFER-FIELD("DELIMITER":U):BUFFER-VALUE.
     
  /* Example value of RADIO-BUTTONS attr value (between single quotes): 
     '"String 1", "1", "String 2", "2", "String 3", "3"' */
  DO ix = 1 TO NUM-ENTRIES(c1,cDelimiter) BY 2:
    ASSIGN
      iRow    = (IF lHorizontal THEN 0 ELSE (piHeight / (iItems) * (ix - 1) / 2))
      cStyle  = (IF lHorizontal THEN "" ELSE
                   SUBSTITUTE(' style="top:&1px;left:0px;&2"',iRow,pcHtmlStyle))
      cLabel  = SUBSTITUTE(
                '  <label for="&3" class="&1"&2>~n'
                ,(IF lHorizontal THEN 'radlbl':U ELSE pcHtmlClass)
                ,cStyle
                ,pcID)
      pcHTML  = pcHTML + cLabel + SUBSTITUTE(
                '<input class="radfld" type="radio" id="&2" name="&2" tabindex="&6" value="&3" &4 &5 />&1</label>&7~n'
                ,TRIM(html-encode(TRIM(REPLACE(ENTRY(ix, c1, cDelimiter), '"', ''))))
                ,pcID
                ,TRIM(REPLACE(ENTRY(ix + 1, c1, cDelimiter), '"', ''))
                ,pcEventList
                ,(IF lEnabled THEN '' ELSE 'disable="true"':U)
                ,iOrder
                ,(IF lHorizontal THEN '&#160;' ELSE '')).
  END.
  pcHtml = pcHtml + '</div>':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doRectangle Procedure 
PROCEDURE doRectangle :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for RECTANGLE
  Parameters:  <none>
  Notes:       Rectangles should be implemented as <FIELDSET> tags, but these
               conflict with the FIELDSET used to display a viewer.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  /*
  pcHtml = SUBSTITUTE(
           '<div class="&1" id="&2" style="top:&3px;left:&4px;height:&5px;width:&6px;"/>'
           ,pcHtmlClass
           ,pcID
           ,piFieldRow
           ,piColumn
           ,piHeight
           ,piWidth).
  */
  pcHtml = SUBSTITUTE(
           '<fieldset id="&2" style="top:&3px;left:&4px;height:&5px;width:&6px;&7"></fieldset>'
           ,pcHtmlClass /* ignored */
           ,pcID
           ,piFieldRow
           ,piColumn
           ,piHeight
           ,piWidth
           ,pcHtmlStyle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doSDO Procedure 
PROCEDURE doSDO :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAutoCommit         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClassName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicSDOInfo     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicSDOParam    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicSDOValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExport             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentChildSupport AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkTypes          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOPath            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTarget       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dAttrRecId          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttrBuf            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDO                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFillBatchOnRepos   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIsSBO              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSBOName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOs               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDO                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMasterSDO          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMasterSDOName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSBO                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParent             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalParent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterParent       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParentSDO          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMasterParentChildSupport AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicSDORequiredProperties   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsASbo             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCommit             AS CHARACTER  NO-UNDO.

  ASSIGN
    cSDOName   = jsTrim(ENTRY(1,ghObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE,'.'))
    cSDOPath   = ghObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE
    dObj       = ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj"):BUFFER-VALUE
    cClassName = ghObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
    cLinkTypes = getLinkTypes(dObj).

  logNote('note','SDOname=' + cSDOname).
  /* Find if object exports data link to container */
  IF CAN-DO(cLinkTypes,'PrimarySDO') THEN
    cExport = '~n uplink="true"'.
  IF dObj = 9.9 THEN                  /* treeview */ 
    cExport = '~n uplink="tree"'.

  /* See if there is an associated maintenance window to launch for updating.
     Unfortunately this is an attribute (FolderWindowToLaunch) of the browse
     object and not the SDO. */
  FIND FIRST ttLink WHERE ttLink.ttFrom = dObj AND ttLink.ttType = 'SDO'.
  cUpdateTarget = ttLink.ttIO. /* default TableIoType */
  IF gcContainerMode = 'view' AND cUpdateTarget = 'on' THEN 
      cUpdateTarget = 'view'.

  FIND FIRST ttObjAttr WHERE
    ttObjAttr.topObjectName = gcLogicalObjectName AND
    ttObjAttr.objName       = cSDOName /* tt_object_instance.instance_object_name */ AND
    ttObjAttr.attrName      = 'FolderWindowToLaunch':U
    NO-ERROR.
  IF AVAILABLE ttObjAttr THEN
    cUpdateTarget = 'dlg.':U + ttObjAttr.attrValue.
  RELEASE ttObjAttr.

  /* See if this SDO is a child of another (parent) SDO.  We do this by 
     checking for a value in the ForeignFields attribute.  If there is a 
     value then we find the parent by checking the smart link.
     ( parent=order link=Ordernum) */
  ASSIGN
    hAttrBuf   = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
    dAttrRecId = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
    cWhere     = " WHERE ":U + hAttrBuf:NAME + ".tRecordIdentifier = DEC('" + STRING(dAttrRecId) + "')".
  hAttrBuf:FIND-FIRST(cWhere) NO-ERROR.
  ASSIGN
    cForeignFields = hAttrBuf:BUFFER-FIELD("ForeignFields":U):BUFFER-VALUE
    cOriginalForeignFields = cForeignFields
    cAutoCommit    =  STRING(NOT CAN-DO(cLinkTypes,'Commit'), "true/false":U)
    cParentChildSupport = '':U.

  IF ( LOGICAL(cAutoCommit) ) THEN 
    cCommit = STRING( hAttrBuf:BUFFER-FIELD("AutoCommit":U):BUFFER-VALUE, "true/false":U).
  ELSE
    cCommit = "false".
  /* SBO's don't have these properties */
  /* SBOOOO */

  ASSIGN 
    cRowsToBatch   = hAttrBuf:BUFFER-FIELD("RowsToBatch":U):BUFFER-VALUE NO-ERROR.

  IF (ERROR-STATUS:ERROR) THEN
    ASSIGN ERROR-STATUS:ERROR = NO
           cRowsToBatch = "50".

  ASSIGN 
    lFillBatchOnRepos = hAttrBuf:BUFFER-FIELD("FillBatchOnRepos":U):BUFFER-VALUE NO-ERROR.

  IF (ERROR-STATUS:ERROR) THEN
    ASSIGN lFillBatchOnRepos = YES
           ERROR-STATUS:ERROR = NO.

  ASSIGN 
    cDataDelimiter = hAttrBuf:BUFFER-FIELD("DataDelimiter":U):BUFFER-VALUE NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    ASSIGN ERROR-STATUS:ERROR = NO
           cDataDelimiter = "|":U.

  /* Save the SDO Rows To Batch */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'RowsToBatch':U, cRowsToBatch).

  /* Save FillBatchOnRepos property */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'FillBatchOnRepos':U, STRING(lFillBatchOnRepos)).

  /* Save the SDO Data Demiliter */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'DataDelimiter':U, cDataDelimiter).
  /* Save the Auto Commit Property of the SDO */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'AutoCommit':U, cCommit).
  
  /* Set included Javascriptfiles */
  RUN includeJS(hAttrBuf:BUFFER-FIELD("JavaScriptFile":U):BUFFER-VALUE) NO-ERROR.
  
  /* Check if this is a Dynamic SDO. If so, build the context for the SDO parameters */
  IF LOOKUP(cClassName, gcDynSDOClasses) <> 0 THEN
  DO:
    ASSIGN cDynamicSDORequiredProperties = hAttrBuf:BUFFER-FIELD("RequiredProperties":U):BUFFER-VALUE NO-ERROR.
    DO i1 = 1 TO NUM-ENTRIES(cDynamicSDORequiredProperties, ",":U):
      cDynamicSDOParam = ENTRY(i1, cDynamicSDORequiredProperties, ",":U).
      cDynamicSDOValue = hAttrBuf:BUFFER-FIELD(cDynamicSDOParam):BUFFER-VALUE NO-ERROR.
      IF ( cDynamicSDOValue = ? ) THEN
        cDynamicSDOValue = "":U.
      cDynamicSDOInfo = cDynamicSDOInfo + '#':U + TRIM(cDynamicSDOParam) + '$':U + cDynamicSDOValue.
    END.
    cDynamicSDOInfo = TRIM(cDynamicSDOInfo, '#':U).

    /* Save the Dynamic SDO Info */
    saveDynamicDSInfo(cSDOName, cDynamicSDOInfo).
  END.

  /* Check if this is a SBO */
  ASSIGN
    hSDO  = getDSHandle(cSDOName, cSDOPath)
    cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hSDO)) NO-ERROR.

  lIsASbo = FALSE.
  IF (ERROR-STATUS:ERROR OR cSDOs = ? OR cSDOs = "":U) THEN
    ASSIGN ERROR-STATUS:ERROR = NO.
  ELSE
    ASSIGN lIsASbo = TRUE.

  IF cForeignFields > '':U THEN
  DO:
    cParent = getSdoLink(dObj).
    logNote("note":U, "The parent for SDO " + STRING(dObj) + " with name : " + cSDOName + " is : " + cParent + " and foreign fields: " + cForeignFields ).
    IF (cParent > "":U) THEN
    DO:
      ASSIGN
        c1 = TRIM(ENTRY(1,cForeignFields))
        c1 = ENTRY(NUM-ENTRIES(c1,'.'),c1,'.')
        ENTRY(1,cForeignFields) = c1
        cParentChildSupport = ' parent=':U + cParent + ' link=' + LC(cForeignFields) + ' '.

      IF ( NOT lIsASbo) THEN
      DO:
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
          INPUT gcLogicalObjectName + '.parent_':U + cSDOName,
          INPUT cOriginalForeignFields + ',' + cParent,
          INPUT NO).

        /* Set the children */
        setChildSDOInfo(gcLogicalObjectName, cSDOName, cParent, cOriginalForeignFields).
      END.
    END.
  END.

  /* If this is a SBO, then we need to do the loop for all the SDO's in the SBO */
  IF (NOT lIsASbo) THEN
  DO:
    ASSIGN cSBOName = "":U.
    RUN outputSDO( INPUT gcLogicalObjectName, 
                   INPUT cSDOName, 
                   INPUT hSDO,
                   INPUT cAutoCommit, 
                   INPUT cUpdateTarget, 
                   INPUT cExport, 
                   INPUT cParentChildSupport, 
                   INPUT cSBOName).

    ASSIGN gcRequestEvents = gcRequestEvents + '|':U + cSDOName + '.start':U.
  END.
  ELSE 
  DO:
    ASSIGN 
      cSBOName = cSDOName
      hSBO = hSDO
      cMasterParentChildSupport = cParentChildSupport
      cMasterForeignFields = cForeignFields
      cMasterParent = cParent
      hMasterSDO = DYNAMIC-FUNCTION("getMasterDataObject":U IN hSDO)
      cMasterSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hMasterSDO).

    DO i1 = 1 TO NUM-ENTRIES(cSDOs):
      ASSIGN cSDO = ENTRY(i1, cSDOs, ",":U)
             hSDO = WIDGET-HANDLE(cSDO)
             cSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO ).

      IF (cSDOName = cMasterSDOName) THEN
        ASSIGN 
          cParentChildSupport = cMasterParentChildSupport
          cForeignFields = cMasterForeignFields
          cParent = cMasterParent
          cFinalParent = cMasterParent.
      ELSE
      DO:
        ASSIGN cForeignFields = DYNAMIC-FUNCTION("getForeignFields":U IN hSDO)
               cOriginalForeignFields = cForeignFields.

        IF cForeignFields > "":U THEN
          ASSIGN 
            c1 = TRIM(ENTRY(1,cForeignFields))
            c1 = ENTRY(NUM-ENTRIES(c1,'.'),c1,'.')
            ENTRY(1,cForeignFields) = c1.

        ASSIGN hParentSDO = DYNAMIC-FUNCTION("getDataSource":U IN hSDO) NO-ERROR.
        IF ( VALID-HANDLE(hParentSDO) )THEN
          ASSIGN cParent = DYNAMIC-FUNCTION("getObjectName":U IN  hParentSDO).
          IF (NUM-ENTRIES(cParent, ".") > 1 ) THEN
            ASSIGN cFinalParent = cParent
                   cParent = ENTRY(2, cParent, ".").
          ELSE
            cFinalParent = cSBOName + ".":U + cParent.

        IF (cForeignFields > "":U AND cParent > "":U) THEN
          cParentChildSupport = ' parent=':U + cParent + ' link=' + LC(cForeignFields) + ' '.
        ELSE
          cParentChildSupport = "":U.
      END.

      IF ( NUM-ENTRIES(cSDOName, ".":U) > 1 ) THEN
        cFinalSDOName = cSDOName.
      ELSE
        cFinalSDOName = cSBOName + ".":U + cSDOName.

      RUN outputSDO( INPUT gcLogicalObjectName, 
                     INPUT cSDOName, 
                     INPUT hSDO,
                     INPUT cAutoCommit, 
                     INPUT cUpdateTarget, 
                     INPUT cExport, 
                     INPUT cParentChildSupport, 
                     INPUT cSBOName).

      /* Set parent child relations - A Double linked link list */

      IF cForeignFields > "":U THEN
      DO:
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
          INPUT gcLogicalObjectName + '.parent_':U + cFinalSDOName,
          INPUT cOriginalForeignFields + ',' + cFinalParent,
          INPUT NO).

        /* Set the children */
        setChildSDOInfo(gcLogicalObjectName, cFinalSDOName, cFinalParent, cOriginalForeignFields).
      END.
      ASSIGN gcRequestEvents = gcRequestEvents + '|':U + cFinalSDOName + '.start':U.
    END.
  END.
  logNote("note", "Req: " + gcRequestEvents).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doSmartLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doSmartLinks Procedure 
PROCEDURE doSmartLinks :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c1          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c2          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c3          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLinks      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjects    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQ          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
    
    DEFINE BUFFER bLink FOR ttLink.
    DEFINE BUFFER newLink FOR ttLink.
    DEFINE BUFFER buffLink FOR ttLink.

    glMasterLink = FALSE.
    cWhere  = "FOR EACH cache_Object WHERE cache_Object.tContainerObjectName = '":U + gcLogicalObjectName + "' AND LOOKUP(cache_Object.tClassName, '" + gcDataClasses + "') > 0":U.
    /* Make sure nothing available - stop potential infinate loop below if query fails. */
    ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
    CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
    hQ:ADD-BUFFER(ghObjectBuffer).
    glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
    IF NOT glOk OR ERROR-STATUS:ERROR THEN
    DO:
      logNote('note', "** ERROR preparing query for SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)) NO-ERROR.
      RUN setMessage  (INPUT "** ERROR preparing query for SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
      RETURN.
    END.
    hQ:QUERY-OPEN().
    hQ:GET-FIRST().
    DO WHILE ghObjectBuffer:AVAILABLE:
      IF i1 > 1000 THEN LEAVE.
      CREATE ttLink.
      ASSIGN
        i1 = i1 + 1
        ttFrom = ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE
        ttTo   = ttFrom
        ttType = 'SDO'
        ttIO   = 'auto'.
      ASSIGN
        ttSDO  = jsTrim(ENTRY(1,STRING(ghObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE),'.'))
        .
      IF ttSDO > '' THEN
        saveDSPath(ttLink.ttSDO,ghObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE).
      hQ:GET-NEXT().
    END.

    cWhere = "FOR EACH cache_ObjectLink":U.
    
    /* Make sure nothing available - stop potential infinate loop below if query fails. */
    ghLinkBuffer:BUFFER-RELEASE() NO-ERROR. 
    CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
    hQ:ADD-BUFFER(ghLinkBuffer).
    glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
    IF NOT glOk OR ERROR-STATUS:ERROR THEN
    DO:
      logNote('note', "** ERROR preparing query for smartlinks, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)) NO-ERROR.
      RUN setMessage  (INPUT "** ERROR preparing query for smartlinks, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
      RETURN.
    END.
    hQ:QUERY-OPEN().
    hQ:GET-FIRST().
    DO WHILE ghLinkBuffer:AVAILABLE:
      IF i1 > 1000 THEN LEAVE.
      c1 = ghLinkBuffer:BUFFER-FIELD("tLinkName":U):BUFFER-VALUE.
      IF NOT CAN-DO('toggledata,PAGE*',c1) THEN DO:
        CREATE ttLink.
        ASSIGN
          i1            = i1 + 1
          ttLink.ttFrom = ghLinkBuffer:BUFFER-FIELD("tSourceObjectInstanceObj":U):BUFFER-VALUE
          ttLink.ttTo   = ghLinkBuffer:BUFFER-FIELD("tTargetObjectInstanceObj":U):BUFFER-VALUE
          ttLink.ttType = c1
          .
      END.
      hQ:GET-NEXT().
    END.

/*     FOR EACH ttLink:                                                                                                                                */
/*       lognote('link','OLD :' + string(ttLink.ttFrom) + '->' + string(ttLink.ttTo) + '=' + ttLink.ttType + '/' + ttLink.ttSDO + '/' + ttLink.ttIO).  */
/*     END.                                                                                                                                            */
    
    gcMasterLink = 'master'.
    FIND FIRST ttLink WHERE ttLink.ttType = 'PrimarySDO' NO-ERROR.
    IF AVAILABLE ttLink THEN 
    DO:
      IF ttLink.ttFrom = 0 THEN
        ttLink.ttFrom = ttLink.ttTo.
      ELSE 
        ttLink.ttTo   = ttLink.ttFrom.

      ASSIGN ttLink.ttSDO = 'PrimarySDO'
             glMasterLink = TRUE.
      /*
      FIND FIRST bLink WHERE bLink.ttType = 'SDO' AND bLink.ttFrom = ttLink.ttTo NO-ERROR.
      IF AVAILABLE bLink THEN gcMasterLink = bLink.ttSDO.
      */
    END.
    CREATE ttLink.
    ASSIGN ttLink.ttFrom = 0
           ttLink.ttTo   = 0
           ttLink.ttType = 'SDO'
           ttLink.ttSDO  = gcMasterLink.

    /** Determine if there is data linked from container **/
    IF NOT glMasterLink THEN 
        glMasterLink = CAN-FIND(FIRST ttLink WHERE ttLink.ttFrom = 0 AND ttLink.ttType = 'Data').
   
    /****
      Results in
      From   To        SDO     Description       Lookup
      SDO    "SDO"     Name    SDO defs          NA
      SDO    SDO       "SDO"   parent-child      SDO -> reads the other
      x      SDO       name                      Reads the SDO value
      SDO    x         name                      Reads the SDO value
      x      x         [blank]                   Returns ''
    ****/

    /*** Parent-child SDO Linkage ***/
    FOR EACH ttLink WHERE ttLink.ttSDO = '':
        IF CAN-FIND(bLink WHERE bLink.ttFrom = ttLink.ttFrom
                            AND bLink.ttType = 'SDO') AND

           CAN-FIND(bLink WHERE bLink.ttFrom = ttLink.ttTo
                            AND bLink.ttType = 'SDO') THEN
        ASSIGN ttLink.ttSDO = 'SDO'.
    END.

    /* Change Group Assign links to update */
    FOR EACH ttLink WHERE ttLink.ttSDO = '' 
                      AND ttLink.ttType = 'update'
       ,EACH bLink  WHERE blink.ttFrom = ttLink.ttFrom
                      AND bLink.ttType = 'groupassign':

          /* Create a TableIO link - For this first find the Toolbar*/
          CREATE newLink.
          ASSIGN
            newLink.ttType = 'TableIO'
            newLink.ttFrom = bLink.ttTo
            newLink.ttTo = bLink.ttTo.
          
          FIND FIRST buffLink WHERE buffLink.ttTo = bLink.ttFrom
                                AND buffLink.ttType = 'TableIO'
          NO-ERROR.
          IF AVAILABLE buffLink THEN
             newLink.ttFrom = buffLink.ttFrom.

          /* Now change the Group Assign to Update */
          ASSIGN
              blink.ttType = 'update'
              blink.ttFrom = bLink.ttTo
              blink.ttTo   = ttLink.ttTo.
    END.
   
    /* From Object to SDO or vice versa */
    FOR EACH ttLink WHERE ttLink.ttSDO = '' :
        FIND FIRST bLink WHERE (bLink.ttFrom = ttLink.ttTo
                            OR bLink.ttFrom = ttLink.ttFrom)
                           AND blink.ttFrom <> 0
                           AND bLink.ttType = 'SDO' NO-ERROR.
        IF AVAILABLE bLink THEN ttLink.ttSDO = bLink.ttSDO.
    END.

    /* From Object to SDO-linked object (only when not already linked) */
    FOR EACH ttLink WHERE ttLink.ttSDO = '':
        FIND FIRST bLink WHERE (bLink.ttFrom = ttLink.ttTo
                             OR bLink.ttFrom = ttLink.ttFrom)
                           AND bLink.ttSDO > ''
                           AND blink.ttFrom <> 0
                           AND CAN-DO('data',bLink.ttType) NO-ERROR.
        IF NOT AVAILABLE bLink THEN
        FIND FIRST bLink WHERE (bLink.ttTo = ttLink.ttTo
                             OR bLink.ttTo = ttLink.ttFrom)
                           AND bLink.ttSDO > ''
                           AND blink.ttTo <> 0
                           AND CAN-DO('data',bLink.ttType) NO-ERROR.
        IF AVAILABLE bLink THEN ASSIGN
            ttLink.ttSDO = bLink.ttSDO.
    END.

/*     FOR EACH ttLink:                                                                                                                                */
/*       lognote('link','LINK:' + string(ttLink.ttFrom) + '->' + string(ttLink.ttTo) + '=' + ttLink.ttType + '/' + ttLink.ttSDO + '/' + ttLink.ttIO).  */
/*     END.                                                                                                                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doText Procedure 
PROCEDURE doText :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for TEXT
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piWidth     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDiv   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle AS CHARACTER  NO-UNDO.
  
  ASSIGN
    cDiv   = SUBSTITUTE(
             '<div class="&2" id="&1" title="&7"':U
             ,pcID
             ,pcHtmlClass
             ,pcToolTip)
    cStyle = SUBSTITUTE(
             ' style="top:&1px;left:&2px;height:&3px;clip:rect(auto,&4,auto,auto);&5">&6</div>':U
             ,piFieldRow
             ,piColumn
             ,piHeight
             ,piWidth
             ,pcHtmlStyle
             ,phBuffer:BUFFER-FIELD("INITIALVALUE":U):BUFFER-VALUE)
    pcHtml = cDiv + cStyle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToggleBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToggleBox Procedure 
PROCEDURE doToggleBox :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for TOGGLE-BOX 
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcID        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlClass AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcHtmlStyle AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcToolTip   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piLabelRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piFieldRow  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plTableIO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredReadOnlyField  AS LOGICAL  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHtml      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cInput   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled AS LOGICAL    NO-UNDO.

  ASSIGN lEnabled = IF (plSecuredReadOnlyField) THEN FALSE ELSE
    (plTableIO AND LOGICAL(phBuffer:BUFFER-FIELD("Enabled":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
    cType  = "checkbox" /* (IF plDisplay THEN "checkbox":U ELSE "hidden":U) */
    iOrder = tabIndex(phBuffer:BUFFER-FIELD("Order":U):BUFFER-VALUE)
    cInput = SUBSTITUTE(
             '<input class="&1" type="&2" id="&3" name="&3" tab="&4" title="&5" &6'
             ,pcHtmlClass
             ,cType
             ,pcID
             ,iOrder
             ,pcToolTip
             ,(IF lEnabled THEN '' ELSE 'disable="true"':U))
    cStyle = SUBSTITUTE(
             ' style="top:&1px;left:&2px;&3" &4 &5 />~n':U 
             ,piFieldRow
             ,piColumn
             ,pcHtmlStyle
             ,(IF LOGICAL(phBuffer:BUFFER-FIELD("CHECKED":U):BUFFER-VALUE) 
               THEN 'checked="checked"':U ELSE '':U)
             ,pcEventList)
    cLabel = SUBSTITUTE(
             '<label for="&4" style="top:&2px;left:&3px;">&&#160;&1</label>~n':U
             ,TRIM(html-encode(pcLabel))
             ,piLabelRow
             /* Width is about 13 pixels so add a couple more for a gap 
                between checkbox and label. */   
             ,(piColumn + 15)
             ,pcID)
    pcHtml = cInput + cStyle + cLabel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToolBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToolBand Procedure 
PROCEDURE doToolBand :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cBand            AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER iLevel           AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER cType            AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcToolbarObjID   AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER pcHiddenActions  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcTarget         AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER plDoToolbar      AS LOGICAL    NO-UNDO.


    DEFINE VARIABLE cAction   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTarget   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCaption  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotkey   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotCode  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotkey2  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cImage    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c1        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSpacer   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dAttrRecId         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hToolbarAttrBuf    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cNavigationTarget  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cActionGroups      AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER bBand       FOR ttBand.
    DEFINE BUFFER bAction     FOR ttAction.
    DEFINE BUFFER bBandAction FOR ttBandAction.

    /* Getting Nav targer not be in this recursive proc - 
       But since the API signature can not be changed it is in this IP
    */
    ASSIGN 
      dAttrRecId     = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
      hToolbarAttrBuf = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

    hToolbarAttrBuf:FIND-FIRST(" WHERE " + hToolbarAttrBuf:NAME + ".tRecordIdentifier = DECIMAL('" + STRING(dAttrRecId) + "')") NO-ERROR.
    ASSIGN 
        lSpacer           = FALSE
        cNavigationTarget = hToolbarAttrBuf:BUFFER-FIELD("NavigationTargetName"):BUFFER-VALUE
        cActionGroups     = hToolbarAttrBuf:BUFFER-FIELD("ActionGroups"):BUFFER-VALUE NO-ERROR.
    FIND FIRST bBand WHERE bBand.band = cBand.
    
/*     lognote('menu','BAND:' + cBand + '=' + bBand.BandType).  */
    FOR EACH bBandAction WHERE
             bBandAction.band = cBand
       ,EACH bAction WHERE
             bAction.action = bBandAction.action
        BY bBandAction.sequence:

        IF bAction.Action = 'DynamicMenu' AND bAction.Category = 'SubMenu' THEN DO:
            RUN outputMenu(gcMenu,pcTarget).
            gcMenu = ''.
            FOR EACH ttObjectband:
                FIND FIRST bBand WHERE bBand.band = ttObjectBand.band.
                FIND FIRST ttAction WHERE ttAction.Action = bBand.BandLabelAction.
                cCaption = ttAction.Caption.
                IF INDEX(cCaption, '&':U) > 0 THEN
                    cCaption = ENTRY(1,cCaption,'&') + '<u>' + SUBSTRING(ENTRY(2,cCaption,'&'), 1, 1) + '</u>' + SUBSTRING(ENTRY(2,cCaption,'&'),2).
                gcBand = gcBand + "|" + string(iLevel) + "|g." + ttAction.Action + "|" + cCaption.
                RUN doToolBand(ttObjectband.Band,iLevel + 1,"band",pcToolbarObjID,pcHiddenActions,pcTarget,plDoToolbar).
            END.
            NEXT.
        END.

/*       lognote('menu','Action:' + bAction.action + '/' + bAction.category).  */
        
        /* If Hidden Action or not in ActionGroups then ignore it */
        IF pcHiddenActions > "":U AND CAN-DO(pcHiddenActions,bBandAction.Action) THEN NEXT.
        IF bAction.TYPE = "publish" AND bAction.Category > "" AND 
           NOT CAN-DO(cActionGroups + ",toolbar,submenu,",bAction.Category) THEN NEXT. 

        /* If the token is secured, then ignore it */
        IF (gcSecuredTokens > "":U) THEN DO:
          IF ( CAN-DO(gcSecuredTokens,bBandAction.Action) OR 
             CAN-DO(gcSecuredTokens,bAction.SecurityToken)) THEN NEXT.
        END.

        /* If the menu security is set then take away the menu */
        IF (bAction.Disabled) THEN NEXT.

        /* Show Hotkey as '(Ctrl+X)' (where X is the hotkey) appended to
           end of tooltip - rather than menu method of underlining hotkey */

        ASSIGN
            cHotkey  = bAction.ACCELERATOR
            cHotkey2 = ''
            cCaption = bAction.Caption.
        IF INDEX(cCaption, '&':U) > 0 THEN
          ASSIGN
            cCaption = ENTRY(1,cCaption,'&') + '<u>' + SUBSTRING(ENTRY(2,cCaption,'&'), 1, 1) + '</u>' + SUBSTRING(ENTRY(2,cCaption,'&'),2).
        ASSIGN
            cAction = LC(bBandAction.action)
            cImage  = baction.IMAGE
            cImage  = ENTRY(1 + LOOKUP(cImage,'ry/img/affunnel.gif,ry/img/filter.gif,ry/img/afstatus.gif')
                                      ,cImage + ',ry/img/filteru.gif,ry/img/filteru.gif,ry/img/statusu.gif')
            cImage  = getImagePath(cImage)
            .
        
        /* Adjust the browse toolbar */ 
        IF CAN-DO('add2,delete2,copy2,modify,view,filter2,export,find',cAction) THEN ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'view,modify,filter2')
                     ,cAction + ',view2,update2,filter')
            bAction.link = IF bAction.link = '' THEN 'toolbar-target' ELSE bAction.link.
        IF cAction BEGINS 'folder' THEN cAction = SUBSTRING(cAction,7).
        /* Find the target SDO for that action */
        cTarget = 'nolink'.
        FIND ttLink NO-LOCK
             WHERE ttLink.ttType = ENTRY(1,bAction.link,'-')
              AND (ttLink.ttFrom = pcToolbarObjID
                OR ttLink.ttTo   = pcToolbarObjID) NO-ERROR.
        IF AVAILABLE ttLink THEN cTarget = ttLink.ttSDO.
        IF ( (cTarget > "":U) AND (cNavigationTarget > "":U) )THEN
          cTarget = cNavigationTarget.

        IF AMBIGUOUS ttLink THEN cTarget = 'wdo'.
        IF cTarget = '' THEN cTarget = gcMasterLink /* 'master' */.
        
        IF CAN-DO('status,relogon,calculator,calendar',cAction) THEN ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'status,relogon,calculator,calendar')
                                      ,cAction + ',main.info.toggle,dlg.login,util.../dhtml/rycalculator.htm,util.../dhtml/rycalendar.htm')
            .
        ELSE IF cAction BEGINS 'help':U THEN ASSIGN
                cAction = 'app.':U + cAction.
        ELSE ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'find,filter')    /* WDO utilities */
                                      ,cAction + ',lookup,filter.toggle')
            cAction = (IF CAN-DO('commit,navigation,tableio,toolbar',ENTRY(1,bAction.link,'-'))
                       THEN cTarget
                       ELSE (IF bAction.link = '' THEN 'app' ELSE 'nolink')
                       ) + '.' + cAction                               /* Application utilties */
            .

        
        /**** Disable various non-supported tools ***/
        IF CAN-DO('suspend,notepad,wordpad,email,internet,word,excel,rule,pref,printsetup,translate,rydynhelpw,multiwindow,preview,audit,comments',ENTRY(2,cAction,'.')) THEN 
            ENTRY(1,cAction,'.') = 'nolink'.

        IF cHotkey > '' THEN DO:
            ASSIGN
                cHotkey2 = ' (':U + CAPS(cHotkey) + ')'
                cHotCode = ''.
            /* Encode hotkeys to the DHTML client format */
            IF LOOKUP('SHIFT',cHotkey,'-') > 0 THEN cHotCode = cHotCode + 'S'.
            IF LOOKUP('CTRL' ,cHotkey,'-') > 0 THEN cHotCode = cHotCode + 'C'.
            IF LOOKUP('ALT'  ,cHotkey,'-') > 0 THEN cHotCode = cHotCode + 'A'.
            cHotkey = REPLACE(REPLACE(REPLACE(REPLACE(cHotkey,'-','_'),'SHIFT_',''),'CTRL_',''),'ALT_','').
            cHotkey = cHotCode + '_' + ENTRY(LOOKUP(cHotkey,
                 "CURSOR_LEFT,CURSOR_RIGHT,CURSOR_UP,CURSOR_DOWN" ) + 1,CAPS(cHotkey) + ',' +
                 "37,39,38,40"     ).
        END.

        IF bAction.Category = 'submenu' THEN 
            cAction = 'g.' + bAction.action. 

        IF bAction.TYPE = 'launch' THEN
            cAction = IF bAction.LogicalObjectName > '' 
                      THEN 'prg.' + bAction.LogicalObjectName
                      ELSE 'nolink.' + cAction.
        IF bAction.TYPE = 'url' THEN
            cAction = 'prg.' + bAction.onChoose.

        
        IF cHotkey > '' THEN
            gcHotkey = gcHotkey + '||' + cAction + '|' + cHotkey.

        IF plDoToolbar AND CAN-DO('Menu&Toolbar',bBand.BandType) THEN ASSIGN
            lSpacer = TRUE
            gcPanel = gcPanel +  "|" + STRING(iLevel) + "|" + cAction + "|" + (IF cImage > ''
                THEN "<img & src='" + cImage + "' title='" + REPLACE(bAction.Caption,'&','') + cHotkey2  + "' />"
                ELSE "<button & title='" + REPLACE(bAction.Caption,'&','') + cHotkey2 + "'>" + cCaption + "</button>").
        
        IF CAN-DO('Menubar,Submenu',bBand.BandType) OR 
          (CAN-DO('Menu&Toolbar',bBand.BandType) AND iLevel > 1)  THEN DO: 
            c1 = "|" + STRING(iLevel) + "|" + cAction + (IF cImage > ''
                THEN "|<img src='" + cImage + "' />" + cCaption + cHotkey2
                ELSE "|" + cCaption + cHotkey2).
            IF cType = "band" 
                THEN gcBand = gcBand + c1.
                ELSE gcMenu = gcMenu + c1.
        END.

/*        lognote('note',cAction + '/' + STRING(iLevel) + '/' + bBand.BandType + '=' + bAction.category).  */
        IF bBandAction.ChildBand > '' THEN
            RUN doToolBand(bBandAction.ChildBand,iLevel + 1,cType,pcToolbarObjID,pcHiddenActions,pcTarget,lSpacer).

    END. /* FOR EACH ttToolbarAction */
    IF lSpacer THEN DO:
        gcPanel = gcPanel +  "|1|break|<IMG & src='../img/ws_spacer.gif' title=''>".

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToolbar Procedure 
PROCEDURE doToolbar :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPagenumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pcToolbarObjName AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcToolbarObjID   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER plInPage         AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE c1          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c2          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c3          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAction     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotkey     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cImage      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMenuObject AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObject     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPage       AS CHARACTER  NO-UNDO INITIAL 'p|':U.
    DEFINE VARIABLE cTargetBand AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTargetMenu AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE httObj      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lInPage     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lLocal      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cType       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUserObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dOrganisationObj AS DECIMAL    NO-UNDO.
    
    DEFINE VARIABLE dAttrRecId       AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hAttrBuf         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTableIoType     AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER bLink FOR ttLink.

    CREATE BUFFER httObj FOR TABLE ghObjectBuffer 
      BUFFER-NAME 'ttObj':U IN WIDGET-POOL "B2BUIM":U.

    EMPTY TEMP-TABLE ttToolbarBand.
    EMPTY TEMP-TABLE ttObjectBand.
    EMPTY TEMP-TABLE ttBand.
    EMPTY TEMP-TABLE ttBandAction.
    EMPTY TEMP-TABLE ttAction.
    EMPTY TEMP-TABLE ttCategory.

    cType       = IF pcToolbarObjName = "MenuController" THEN 'menu' ELSE ''.
    cTargetMenu = IF cType = 'menu' THEN 'mainmenu' ELSE 'progmenu'.
    cTargetBand = IF cType = 'menu' THEN 'mainband' ELSE 'progband'.

    /* Get the current user and organisation */
    ASSIGN dUserObj         = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentUserObj":U,INPUT NO))
           dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentOrganisationObj":U,INPUT NO)).

    RUN ry/app/rygetmensp.p 
        (INPUT pcToolbarObjName, /* toolbar */
        INPUT gcLogicalObjectName, /* pObjectName, */
        INPUT '':U,
        INPUT dUserObj,
        INPUT dOrganisationObj,
        OUTPUT TABLE ttToolbarBand,
        OUTPUT TABLE ttObjectBand,
        OUTPUT TABLE ttBand,
        OUTPUT TABLE ttBandAction,
        OUTPUT TABLE ttAction,
        OUTPUT TABLE ttCategory)
    NO-ERROR.

    IF NOT(CAN-FIND(FIRST ttToolbarBand 
      WHERE ttToolbarBand.toolbar = pcToolbarObjName)) THEN LEAVE.

    /* Find the attributes */
    ASSIGN 
      hAttrBuf   = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
      dAttrRecId = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
      hAttrBuf:FIND-FIRST(" WHERE ":U + hAttrBuf:NAME + ".tRecordIdentifier = DEC('" + STRING(dAttrRecId) + "')") NO-ERROR.

    ASSIGN 
      cHiddenActions = hAttrBuf:BUFFER-FIELD("HiddenActions":U):BUFFER-VALUE 
      cTableIoType   = hAttrBuf:BUFFER-FIELD("TableIoType":U):BUFFER-VALUE 
           NO-ERROR.
    IF cTableIoType = 'save' THEN DO:
      FOR EACH ttLink WHERE ttLink.ttFrom = pcToolbarObjID AND ttLink.ttType = 'TableIO'
         ,EACH bLink  WHERE bLink.ttSDO = ttLink.ttSDO AND bLink.ttType = 'SDO':
         bLink.ttIO = 'on'.
      END.
    END.

    /* Menutype Toolbar/menubar/treeview/outlookbar - output on header section */
    IF piPagenumber > 0 THEN
      cPage = 'p' + STRING(piPagenumber) + '|'.
    IF cType = 'menu' THEN
      cPage = 'g|'.

    FOR EACH ttToolbarBand BY LOOKUP(ttToolbarBand.Alignment,'left,center,right') BY ttToolbarBand.sequence:
      lognote('menu','MenuMain:' + ttToolbarBand.Band).
      RUN doToolBand(ttToolbarBand.Band,1,cType,pcToolbarObjID,cHiddenActions,
        '"' + cTargetMenu + '" page="' + STRING(piPagenumber) + '"',TRUE).
    END. /* FOR EACH ttToolbarBand */

    /* Panel - output into grid */
    IF plInPage THEN DO:
      {&OUT} '<div class="panel">~n':U.
      DO i1 = 2 TO NUM-ENTRIES(gcPanel,'|') BY 3:
        cImage = ENTRY(i1 + 2,gcPanel,'|').
        c1 = ENTRY(i1 + 1,gcPanel,'|').
        IF CAN-DO(c2,c1) THEN NEXT.
        c2 = c2 + ',' + c1.
        {&OUT} ' ':U
          REPLACE(cImage,' & ',' class="tool ' +
          (IF c1 BEGINS 'nolink' THEN 'nolink' ELSE 'enable') + '" id="' + c1 + '" name="' + c1 + '" ') '~n':U.
      END.
      {&OUT} '</div>':U.
    END.
    ELSE 
      RUN outputMenu(gcPanel,'"toolbar" page="' + STRING(piPagenumber) + '"').
    gcPanel = ''.

    RUN outputMenu(gcBand,'"' + cTargetBand + '" page="' + STRING(piPagenumber) + '"').
    gcBand = ''.
    
    RUN outputMenu(gcMenu,'"' + cTargetMenu + '" page="' + STRING(piPagenumber) + '"').
    gcMenu = ''.

    RUN outputMenu(gcHotkey,'"hotkey" page="' + STRING(piPagenumber) + '"').
    gcHotkey = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doTreeview) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doTreeview Procedure 
PROCEDURE doTreeview :
/*------------------------------------------------------------------------------
  Purpose: Outputs nodes for dynTreeview branch    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /** ry/app/rywebtreeview.p **/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcNodeName          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcKey               AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cData     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDS       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cParentDS AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLabel    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dNodeObj  AS DECIMAL   NO-UNDO.

  IF pcNodeName = '' THEN DO:
    /** Root node **/
    FIND rym_wizard_tree NO-LOCK WHERE rym_wizard_tree.object_name = pcLogicalObjectName.         
    RUN outputTreedata(rym_wizard_tree.root_node_code,'','',
                       INPUT-OUTPUT cDS,INPUT-OUTPUT cData).
  END.
  ELSE DO:
    /** Branch node **/
    FIND gsm_node NO-LOCK WHERE gsm_node.node_code = pcNodeName.
    dNodeObj  = gsm_node.node_obj.
    cParentDS = gsm_node.primary_sdo.
    FOR EACH gsm_node NO-LOCK WHERE gsm_node.parent_node_obj = dNodeObj:
      cDS   = cDS + (IF cDS > '' THEN '|' ELSE '') + gsm_node.data_source.
      RUN outputTreedata(gsm_node.node_code,cParentDS,pcKey,
                         INPUT-OUTPUT cDS,INPUT-OUTPUT cData).
    END.
  END.
  RETURN "'" + cDS + "'," + (IF cData > '' THEN cData + ']' ELSE 'null').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doViewer Procedure 
PROCEDURE doViewer :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       ttSDORequiredFields is populated here to save having to run
                 determineSDOFieldsUsed.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER dObj AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE c1                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClassName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelimiter             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventClass            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFldName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtml                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlClass             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHtmlStyle             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cID                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJavaScript            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListItems             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterIdentifier      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredFields         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredHiddenFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredReadOnlyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecurity              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionResultCodes    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyleSheet            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToolTip               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisualization         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dAttrRecId             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttrBuf               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObjBuf                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQ                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hViewerAttrBuf         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFieldNo               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFieldRow              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iHeight                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIdx                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLabelRow              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOrder                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStep                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWidth                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lCalculatedField       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDSIsASBO              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDisplay               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lEnabled               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHideOnInit            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSecuredHiddenField    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSecuredReadOnlyField  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTableIOTarget         AS LOGICAL    NO-UNDO.
  
  CREATE BUFFER hObjBuf FOR TABLE ghObjectBuffer.
  EMPTY TEMP-TABLE ttCols.

  /* Set viewer attributes. If the Viewer is not a TableIO target, then its 
     fields should not be enabled. Otherwise defer to EnabledFields attribute 
     to apply correct enabled state. */
  ASSIGN
    giMinTabIndex  = giMaxTabIndex
    cViewerName    = ghObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
    cMasterIdentifier = STRING(ghObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE)
    cSDOName       = getSdoLink(dObj)
    lDSIsASBO      = DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,cSDOName,"SBO":U)
    lTableIOTarget = CAN-DO(getLinkTypes(dObj),'TableIO')
    hViewerAttrBuf = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
    dAttrRecId     = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.

  hViewerAttrBuf:FIND-FIRST(" WHERE " + hViewerAttrBuf:NAME + ".tRecordIdentifier = DECIMAL('" + STRING(dAttrRecId) + "')") NO-ERROR.

  IF (lDSIsASBO) THEN
  DO:
    ASSIGN cSBOName = cSDOName 
           cSDOName = "":U
           cDataSourceNames = hViewerAttrBuf:BUFFER-FIELD("DataSourceNames":U):BUFFER-VALUE NO-ERROR.
           
    IF ( cDataSourceNames > "":U ) THEN 
    DO:
      IF ( NUM-ENTRIES(cDataSourceNames, ",":U) = 1 ) THEN
        cSDOName = cDataSourceNames.
      ELSE
        cSDOName = "":U.
    END.
  END.  
  
  ASSIGN cHtmlClass  = hViewerAttrBuf:BUFFER-FIELD("HtmlClass":U):BUFFER-VALUE NO-ERROR.
  ASSIGN cHtmlStyle  = hViewerAttrBuf:BUFFER-FIELD("HtmlStyle":U):BUFFER-VALUE NO-ERROR.
  ASSIGN
    cHtmlClass  = (IF cHtmlClass = ? THEN "" ELSE cHtmlClass) 
    cHtmlStyle  = (IF cHtmlStyle = ? THEN "" ELSE cHtmlStyle + ';') 
    lHideOnInit = hViewerAttrBuf:BUFFER-FIELD("HideOnInit":U):BUFFER-VALUE
    NO-ERROR.
    
  /* IF lHideOnInit THEN RETURN. */

  RUN includeJS(hViewerAttrBuf:BUFFER-FIELD("JavaScriptFile":U):BUFFER-VALUE) NO-ERROR.
  RUN includeCSS(hViewerAttrBuf:BUFFER-FIELD("StyleSheetFile":U):BUFFER-VALUE) NO-ERROR.
  
  {&OUT}
    SUBSTITUTE('<div class="&1" style="height:&2px;width:&3px;&4&5" wdo="&6" id="&7" name="&7">'
      ,(IF cHtmlClass <> "" THEN cHtmlClass ELSE 'viewer':U)
      ,STRING(INTEGER(hViewerAttrBuf:BUFFER-FIELD("MinHeight":U):BUFFER-VALUE * giPixelsPerRow) + 
        giViewerOffsetHeight)
      ,STRING(INTEGER(hViewerAttrBuf:BUFFER-FIELD("MinWidth":U):BUFFER-VALUE * giPixelsPerColumn) + 
        giViewerOffsetWidth)
      ,(IF lHideOnInit THEN 'display:none;':U ELSE '')
      ,cHtmlStyle
      ,cSDOName + gcJustification
      ,cViewerName) SKIP.

  /* Viewer attribute buffer no longer needed. */
  DELETE OBJECT hViewerAttrBuf NO-ERROR.
  hViewerAttrBuf = ?.
  
  /* Loop through viewer objects.  The BY phrase is included to sort by object 
     class, such that DynLookup is processed first.  In this way linked field 
     references are recorded for later processing of the linked field itself. */
  cWhere  = "FOR EACH ":U + hObjBuf:NAME + " WHERE ":U
          + hObjBuf:NAME + ".tContainerObjectName = '":U + cViewerName + "' AND ":U
          + hObjBuf:NAME + ".tContainerRecordIdentifier = " + cMasterIdentifier + " AND ":U 
          + hObjBuf:NAME + ".tLogicalObjectName <> '":U + cViewerName + "'":U
          + " BY LOOKUP(" + hObjBuf:NAME + ".tClassName, '":U + gcDynLookupClasses + "') DESCENDING":U 
          + " BY " + hObjBuf:NAME + ".tInstanceOrder":U 
          .

  CREATE QUERY hQ.
  hQ:ADD-BUFFER(hObjBuf).
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    logNote('note',"Error preparing query.  ErrorMsg: ":U + ERROR-STATUS:GET-MESSAGE(1) + 
      ', Program: ' + PROGRAM-NAME(1)) NO-ERROR.
    RUN setMessage  (INPUT "** ERROR preparing query for loop through fields on viewer, where: ":U + 
      cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + 
      PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.

  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  
  DO WHILE hObjBuf:AVAILABLE:
    ASSIGN 
      lSecuredHiddenField   = LOGICAL(hObjBuf:BUFFER-FIELD("tSecuredHidden":U):BUFFER-VALUE)
      lSecuredReadOnlyField = LOGICAL(hObjBuf:BUFFER-FIELD("tSecuredReadOnly":U):BUFFER-VALUE)
      hAttrBuf              = hObjBuf:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    
    hAttrBuf:FIND-FIRST(" WHERE " + hAttrBuf:NAME + ".tRecordIdentifier  = DEC('" + 
      hObjBuf:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE + "')").
    
    /* Progress widgets do not have FieldName attribute, so assign cFldName 
       separately. */
    ASSIGN
      cFldName         = hAttrBuf:BUFFER-FIELD("FieldName":U):BUFFER-VALUE NO-ERROR.

    ASSIGN
      cLogicalName     = TRIM(LC(hObjBuf:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE))
      cInstanceName    = TRIM(LC(hObjBuf:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE))
      cClassName       = hObjBuf:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
      lDisplay         = (IF DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,cLogicalName,"DataField":U) OR 
                            DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,cLogicalName,"Field":U) THEN
                            LOGICAL(hAttrBuf:BUFFER-FIELD("DisplayField":U):BUFFER-VALUE)
                          ELSE
                            LOGICAL(hAttrBuf:BUFFER-FIELD("Visible":U):BUFFER-VALUE)) NO-ERROR.
                            
    RUN doViewerFieldID(INPUT cLogicalName, 
                        INPUT cInstanceName,
                        INPUT cClassName,
                        INPUT cSDOName, 
                        INPUT lDSIsASBO,
                        INPUT-OUTPUT cFldName, 
                        OUTPUT cID).

    IF (lSecuredHiddenField) THEN
    DO:
      cSecuredHiddenFields = cSecuredHiddenFields + ",":U + cFldName.
      hQ:GET-NEXT().
      NEXT.
    END.
    
    IF NOT lDisplay THEN 
    DO:
      hQ:GET-NEXT().
      NEXT.
    END.

    ASSIGN
      cVisualization = hAttrBuf:BUFFER-FIELD("VisualizationType":U):BUFFER-VALUE.

    ASSIGN  
      iLabelRow   = INTEGER(hAttrBuf:BUFFER-FIELD("row":U):BUFFER-VALUE * giPixelsPerRow) 
                    + giFieldOffsetTop
      iFieldRow   = iLabelRow - 2 /* manually offset field as they appear lower than labels */
      iColumn     = INTEGER(hAttrBuf:BUFFER-FIELD("column":U):BUFFER-VALUE * giPixelsPerColumn)
      iWidth      = INTEGER(hAttrBuf:BUFFER-FIELD("width-chars":U):BUFFER-VALUE * giPixelsPerColumn)
      iHeight     = INTEGER(hAttrBuf:BUFFER-FIELD("height-chars":U):BUFFER-VALUE * giPixelsPerRow)
      cEventList  = ""
      NO-ERROR.

    ASSIGN cHtmlClass = hAttrBuf:BUFFER-FIELD("HtmlClass":U):BUFFER-VALUE NO-ERROR.
    ASSIGN cHtmlStyle = hAttrBuf:BUFFER-FIELD("HtmlStyle":U):BUFFER-VALUE NO-ERROR.
    
    IF iWidth = ? THEN 
      iWidth = 10 * giPixelsPerColumn.  /* Dealing with Repository Data Problems */

    ASSIGN
      cHtmlClass  = IF cHtmlClass = "" OR cHtmlClass = ? THEN "field":U ELSE cHtmlClass
      cHtmlStyle  = IF cHtmlStyle = ? THEN '' ELSE cHtmlStyle + ';'
      cToolTip    = hAttrBuf:BUFFER-FIELD("HELP":U):BUFFER-VALUE
      cToolTip    = IF cToolTip = "":U OR cToolTip = ? THEN
                      hAttrBuf:BUFFER-FIELD("TOOLTIP":U):BUFFER-VALUE ELSE cToolTip
      NO-ERROR.

    ASSIGN
      cLabels     = hAttrBuf:BUFFER-FIELD("LABELS":U):BUFFER-VALUE
      cLabel      = "" NO-ERROR.
      
    IF cLabels = ? OR cLabels = "" OR (cLabels <> ? AND LOGICAL(cLabels)) THEN 
      ASSIGN
        cLabel      = hAttrBuf:BUFFER-FIELD("Label":U):BUFFER-VALUE
        cLabel      = (IF cLabel = ? THEN "" ELSE cLabel) NO-ERROR.
    IF cLabel > '' THEN cLabel = cLabel + ':'.
    /* Accumulate UI Event data */
    RUN doViewerEvents( INPUT STRING(hObjBuf:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE), 
                        OUTPUT cEventList).
    
    /* Explicit/absolute positioning and sizing is now used.  Labels are 
       positioned by making left=0 and width=col/left of field, then right-
       aligning the label text. */
    ASSIGN cHtml = "":U.

    /* For non-DataField, non-SmartDataField objects, the ID is found in 
       tObjectInstanceName attribute.  For all other objects, ID is found in 
       the tLogicalObjectName attribute. */

    IF ( cVisualization = 'TOGGLE-BOX':U AND 
        ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
          LOOKUP(cClassName, gcDynToggleClasses) > 0 )) THEN
      RUN doToggleBox (hAttrBuf, cLabel, cID, cHtmlClass, cHtmlStyle, cToolTip, iLabelRow, 
                       iColumn, iFieldRow, cEventList, lTableIOTarget, lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'RADIO-SET':U AND 
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynRadioSetClasses) > 0 )) THEN
      RUN doRadioSet (hAttrBuf, cLabel, cID, cHtmlClass, cHtmlStyle, cToolTip, iColumn, iHeight, 
                      iWidth, iFieldRow, cEventList, lTableIOTarget, lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'EDITOR':U AND 
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynEditorClasses) > 0 )) THEN
      RUN doEditor (hAttrBuf, cLabel, cID, cHtmlClass, cHtmlStyle, cToolTip, iColumn, iHeight,
                    iWidth, iFieldRow, cEventList, lTableIOTarget, lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'FILL-IN':U AND 
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynFillinClasses) > 0 )) THEN
    DO:
      /* Check if any DynCombo or DynLookup object with the same name exists */
      IF (NOT checkIfOtherInstanceExists(cViewerName, 
          hObjBuf:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE, hObjBuf) ) THEN
      DO:
        IF hAttrbuf:BUFFER-FIELD("DATA-TYPE":U):STRING-VALUE = "date":U THEN
           iWidth = iWidth + 8.
        RUN doFillIn (hAttrBuf, cLabel, cID, cHtmlClass, cHtmlStyle, cToolTip, iLabelRow,
                      iColumn, iHeight, iWidth, iFieldRow, cEventList, lTableIOTarget,
                      lSecuredReadOnlyField, cSDOName, cViewerName, OUTPUT cHtml).
      END.
    END.
    ELSE IF ( cVisualization = 'COMBO-BOX':U AND 
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynComboBoxClasses) > 0 )) THEN
      RUN doComboBox (hAttrBuf, cVisualization, cClassName, cLabel, cID, cHtmlClass, 
                      cHtmlStyle, cToolTip, iLabelRow, iColumn, iWidth, iFieldRow, 
                      cEventList, lTableIOTarget, lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'SELECTION-LIST':U AND
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynSelectionClasses) > 0 )) THEN
      RUN doComboBox (hAttrBuf, cVisualization, cClassName, cLabel, cID, cHtmlClass, 
                      cHtmlStyle, cToolTip, iLabelRow, iColumn, iWidth, iFieldRow, 
                      cEventList, lTableIOTarget, lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'BUTTON':U AND
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynButtonClasses) > 0 )) THEN
      RUN doButton (hAttrBuf, cLabel, cID, cHtmlClass, cHtmlStyle, cToolTip, iColumn,
                    iHeight, iWidth, iFieldRow, cEventList, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'TEXT':U AND
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynTextClasses) > 0 )) THEN
      RUN doText (hAttrBuf, cID, cHtmlClass, cHtmlStyle, cToolTip, iColumn, iHeight,
                  iWidth, iFieldRow, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'IMAGE':U AND
             ( LOOKUP(cClassName, gcDataFieldClasses) > 0 OR 
               LOOKUP(cClassName, gcDynImageClasses) > 0 )) THEN
      RUN doImage (hAttrBuf, cID, cHtmlClass, cHtmlStyle, cToolTip, iColumn, iFieldRow,
                   cEventList, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'RECTANGLE':U AND
              LOOKUP(cClassName, gcDynRectangleClasses) > 0 ) THEN
      RUN doRectangle (hAttrBuf, cID, cHtmlClass, cHtmlStyle, iColumn, iHeight, iWidth,
                       iFieldRow, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'SmartDataField':U AND
              LOOKUP(cClassName, gcDynLookupClasses) > 0 ) THEN
      RUN doDynLookup (hAttrBuf, cID, cHtmlClass, cHtmlStyle, iLabelRow, iColumn, 
                       iWidth, cSdoName, iFieldRow, lTableIOTarget, 
                       lSecuredReadOnlyField, cViewerName, OUTPUT cHtml).
    ELSE IF ( cVisualization = 'SmartDataField':U AND
              LOOKUP(cClassName, gcDynComboClasses) > 0 ) THEN
      RUN doDynCombo (hAttrBuf, cID, cEventList, lTableIOTarget, 
                      lSecuredReadOnlyField, OUTPUT cHtml).
    ELSE
    DO:
      ASSIGN /* What field type is this? */
        iOrder   = hAttrBuf:BUFFER-FIELD("Order":U):BUFFER-VALUE
        lEnabled = IF (lSecuredReadOnlyField) THEN FALSE ELSE
                  (lTableIOTarget AND LOGICAL(hAttrBuf:BUFFER-FIELD("Enabled":U):BUFFER-VALUE))
      NO-ERROR.

      ASSIGN
        cHTML    = SUBSTITUTE(
                 '<label for="&1" style="top:&2px;left:0px;width:&3px">&4&&#160;</label>~n'
                 ,cID
                 ,iLabelRow
                 ,iColumn
                 ,TRIM(html-encode(STRING(hAttrBuf:BUFFER-FIELD("Label":U):BUFFER-VALUE))))
        cHTML    = cHtml + SUBSTITUTE(
                 '<input class="&2" type="text" id="&1" name="&1" tabindex="&3" title="&4"'
                 ,cID
                 ,(IF cHtmlClass = "" OR cHtmlClass = ? THEN "field":U ELSE cHtmlClass)
                 ,iOrder
                 ,cToolTip + '(':U + cClassName + ',':U + cVisualization + ')':U)
        cHTML    = cHtml + SUBSTITUTE(
                 ' style="top:&1px;left:&2px;height:&3px;width:&4px;&5" &6 />~n'
                 ,iFieldRow
                 ,iColumn
                 ,iHeight
                 ,iWidth
                 ,cHtmlStyle
                 ,(IF lEnabled THEN '' ELSE 'disabled="disabled"'))
      NO-ERROR.
    END.
    {&OUT} cHTML SKIP.
    hQ:GET-NEXT().
  END. /* for each field object (hObjBuf) */
  cSecuredHiddenFields = TRIM(cSecuredHiddenFields, ",").

  /* Save the SDO Security */
  saveDSSecurity(gcLogicalObjectName, cSDOName, cSecuredHiddenFields).

  hQ:QUERY-CLOSE().
  hObjBuf:BUFFER-RELEASE() NO-ERROR.
  DELETE OBJECT hObjBuf   NO-ERROR.
  DELETE OBJECT hQ      NO-ERROR.
  ASSIGN hQ = ?.
  {&OUT} '</div>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doViewerEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doViewerEvents Procedure 
PROCEDURE doViewerEvents :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       This procedure returns a string of events for objects in the viewer.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcRecId     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEventList AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEventAction        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hUIEventQuery       AS HANDLE     NO-UNDO.

  /* Accumulate UI Event data */
  ASSIGN pcEventList = "".
  
  ghUIEventBuffer:FIND-FIRST("WHERE " + ghUIEventBuffer:NAME + ".tRecordIdentifier = DEC('":U +
    pcRecId + "')") NO-ERROR.

  IF ghUIEventBuffer:AVAILABLE THEN 
  DO:
    CREATE QUERY hUIEventQuery IN WIDGET-POOL "B2BUIM":U.
    hUIEventQUERY:ADD-BUFFER(ghUIEventBuffer) NO-ERROR.
    EMPTY TEMP-TABLE ttEvent.
    
    cEventQuery = "FOR EACH " + ghUIEventBuffer:NAME  + " WHERE ":U +
      ghUIEventBuffer:NAME + ".tRecordIdentifier = DEC('":U + pcRecId + "')".
    
    hUIEventQuery:QUERY-PREPARE(cEventQuery) NO-ERROR.
    hUIEventQuery:QUERY-OPEN().
    hUIEventQuery:GET-FIRST().
    
    DO WHILE ghUIEventBuffer:AVAILABLE:
      ASSIGN
        cEventName   = ghUIEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE
        cEventAction = ghUIEventBuffer:BUFFER-FIELD("tEventAction":U):BUFFER-VALUE.
       
      /* We build this temp-table of UI events by object to ensure that we 
        only export one event handler, e.g. onBlur, per object.  An event 
         action could have been defined at the class, master, and instance 
         levels, we only want the latter, not all three. We are assuming that
         the class, master, and instance events are retrieved in that order. */
         
      IF cEventAction > "" THEN 
      DO:
        FIND FIRST ttEvent WHERE ttEvent.cEvent = cEventName NO-ERROR.
        IF NOT AVAILABLE ttEvent THEN DO:
          CREATE ttEvent.
          ASSIGN ttEvent.cEvent = cEventName.
        END.
        ttEvent.cAction = cEventAction.
      END.
      
      hUIEventQuery:GET-NEXT().
    END.
    /* TBD: Need to encode quotes so that Progress and/or JavaScript do not
       get confused. */
    FOR EACH ttEvent:
      pcEventList = pcEventList + " ":U + ttEvent.cEvent + '="':U + ttEvent.cAction + '"':U.
    END.
    /* Cleanup */
    hUIEventQuery:QUERY-CLOSE.
    ghUIEventBuffer:BUFFER-RELEASE().
    DELETE OBJECT hUIEventQuery.
    ASSIGN
      hUIEventQuery  = ?.     
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doViewerFieldID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doViewerFieldID Procedure 
PROCEDURE doViewerFieldID :
/*------------------------------------------------------------------------------
  Purpose: This ip returns the ID for the viewer field 
  Parameters:  <none>
  Notes: If the data Source is SBO and the SDONAme is "" then
         Either there are multiple data sources or the data source is not specified.
         NOTE: Is there a need to even look at FieldName ? - Needs to be determined
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER         pcLogicalName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER         pcInstanceName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER        pcClassName     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER         pcSDOName       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER         plDSIsASBO      AS LOGICAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER  pcFldName       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER  cID                   AS CHARACTER  NO-UNDO.

  /*
  DEFINE VARIABLE lCalculatedField AS LOGICAL    NO-UNDO.
  ASSIGN lCalculatedField = LOGICAL(DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,pcLogicalName,"CalculatedField":U)).
  */

  /* Progress widgets do not have FieldName attribute */
  IF LOOKUP(pcClassName, gcProgressWidgetClasses) > 0 THEN
  DO:
    ASSIGN pcFldName = LC(pcInstanceName)
                 cID = LC(pcInstanceName).
  END.
  /*
  ELSE IF lCalculatedField THEN
  DO:
    IF (plDSIsASBO ) THEN 
    DO:
      IF (pcSDOName > "":U) THEN
        ASSIGN pcFldName = LC(pcLogicalName)
                     cID = LC(pcSDOName + '.':U + pcLogicalName).
      ELSE
        ASSIGN pcFldName = LC(REPLACE(pcInstanceName, ' ':U, '':U))
                     cID = LC(pcFldName).
    END.
    ELSE
      ASSIGN pcFldName = LC(pcLogicalName)
                   cID = LC(pcSDOName + '.':U + pcLogicalName).
  END.
  */
  ELSE IF pcFldName > '' THEN 
  DO:
    IF (plDSIsASBO ) THEN 
    DO:
      IF (pcSDOName > "":U) THEN
        cID = LC(pcSDOName + '.':U + pcFldName).
      ELSE
        cID = LC(pcFldName).
    END.
    ELSE
      cID = LC(pcSDOName + '.':U + pcFldName).
  END.
  ELSE 
  DO:
    pcFldName  = pcLogicalName. 
    IF INDEX(pcFldName, ".":U) > 0 THEN
      ASSIGN pcFldName = ENTRY(2, pcFldName,".":U).
    
    IF (plDSIsASBO ) THEN 
    DO:
      IF (pcSDOName > "":U) THEN
        cID = LC(pcSDOName + '.':U + pcFldName).
      ELSE
        cID = LC(REPLACE(pcInstanceName, ' ':U, '':U)).
    END.
    ELSE
      cID = LC(pcSDOName + '.':U + pcFldName).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchUI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchUI Procedure 
PROCEDURE fetchUI :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lGotIt          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hQ              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTreeSDO        AS CHARACTER NO-UNDO.
  
  ASSIGN ghCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U).
  IF VALID-HANDLE(ghCustomizationManager) THEN
    ASSIGN gcSessionResultCodes  = DYNAMIC-FUNCTION("getSessionResultCodes":U IN ghCustomizationManager).

  gcRunAttribute = ''.

  logNote('note',"Fetch UI from Repository for ":U + gcLogicalObjectName) NO-ERROR.

  /* Clear cache in repository manager */
  RUN clearClientCache in gshRepositoryManager.

  /* Add SDO for treeview container */
  IF(get-value('lookup') BEGINS 'TREE=') THEN DO:
    FIND gsm_node NO-LOCK WHERE gsm_node.node_code = entry(2,entry(1,get-value('lookup'),'|'),'=').
    cTreeSDO = gsm_node.data_source.

    MESSAGE 'treeview SDO=' cTreeSDO.
    logNote('note',"Treecontainer SDO fetch":U).
    ASSIGN lGotIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                   INPUT cTreeSDO,
                                   INPUT gcSessionResultCodes,
                                   INPUT gcRunAttribute,
                                   INPUT NO                ) NO-ERROR.
    logNote('note',"Treecontainer SDO fetch complete=":U + STRING(lGotIt)).
    /* Make sure nothing available - stop potential infinate loop below if query fails. */
    CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
    ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
    ghObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
    hQ:ADD-BUFFER(ghObjectBuffer).
    hQ:QUERY-PREPARE("FOR EACH cache_Object WHERE LOOKUP(cache_Object.tClassName, '" + gcDataClasses + "') > 0":U).
    hQ:QUERY-OPEN().
    hQ:GET-FIRST().
    DO WHILE ghObjectBuffer:AVAILABLE:
      ASSIGN
        ghObjectBuffer:BUFFER-FIELD("tContainerObjectName":U):BUFFER-VALUE = gcLogicalObjectName
        ghObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE = 9.9
        ghObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE = cTreeSDO
        .
      hq:GET-NEXT().
    END.
  END.
  
  /* Retrieve outermost container object and it's children */
  ASSIGN lGotIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                                   gcLogicalObjectName, gcSessionResultCodes,
                                   gcRunAttribute, FALSE) NO-ERROR.
  IF ERROR-STATUS:ERROR OR NOT lGotIt THEN
  DO:
    logNote('note',"Error Running cacheObjectOnClient API.  ErrorMsg: ":U + ERROR-STATUS:GET-MESSAGE(1)) NO-ERROR.
    RUN setMessage  (INPUT "** ERROR Running cacheObjectOnClient API. ErrorMsg: ":U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    RETURN.
  END.
  logNote('note',"Repository fetch complete":U) NO-ERROR.

  ASSIGN 
    ghObjectBuffer       = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
    ghPageBuffer         = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager)
    ghUIEventBuffer      = DYNAMIC-FUNCTION("getCacheUIEventBuffer":U IN gshRepositoryManager)
    ghLinkBuffer         = DYNAMIC-FUNCTION("getCacheLinkBuffer":U IN gshRepositoryManager)
    .

  /* Get the secured tokens */
  gcSecuredTokens = getSecurityTokens(gcLogicalObjectName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUIChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUIChanges Procedure 
PROCEDURE getUIChanges :
/*------------------------------------------------------------------------------
  Purpose:     For each supported UI change type, get the list of objects to
               apply the change to, if any
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChange     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChangeList AS CHARACTER  NO-UNDO 
    INITIAL "enable,disable,highlight,unhighlight,hide,show,mark":U.
  DEFINE VARIABLE cScript     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount1     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.

  /* cObjList is a comma-delimited list of object names/id's */
  DO iCount1 = 1 TO NUM-ENTRIES(cChangeList):
    ASSIGN
      cChange  = ENTRY(iCount1, cChangeList)
      cObjList = DYNAMIC-FUNCTION("getProperty":U IN ghRequestManager,
                                  cChange + "Widget":U) NO-ERROR.

    IF cObjList <> ? AND cObjList <> "" THEN
    DO iCount2 = 1 TO NUM-ENTRIES(cObjList, CHR(3)):
      RUN setClientAction(ENTRY(iCount2, cObjList, CHR(3)) + ".":U + cChange).
    END. /* objects */
  END. /* change */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-includeCSS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE includeCSS Procedure 
PROCEDURE includeCSS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcCSS AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  
  IF pcCSS = ? OR pcCSS = '' THEN RETURN.
  DO i1 = 1 TO NUM-ENTRIES(pcCSS):
    ASSIGN c1 = ENTRY(i1,pcCSS).
    IF NOT CAN-DO(gcStyleSheet + ',':U + gcIncludeCSS,c1) THEN 
      gcIncludeCSS = gcIncludeCSS + (IF gcIncludeCSS > '' THEN ',':U ELSE '') + c1.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-includeJS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE includeJS Procedure 
PROCEDURE includeJS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM pcJS AS CHAR NO-UNDO.
  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  
  IF pcJS = ? OR pcJS = '' THEN RETURN.
  DO i1 = 1 TO NUM-ENTRIES(pcJS):
    ASSIGN c1 = ENTRY(i1,pcJS).
    IF NOT CAN-DO(gcIncludeJS,c1) THEN 
      gcIncludeJS = gcIncludeJS + (IF gcIncludeJS > '' THEN ',' ELSE '') + c1.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputMenu Procedure 
PROCEDURE outputMenu :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cMenu    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER cTarget  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE c1    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c3    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1    AS INTEGER    NO-UNDO.

  DO i1 = 2 TO NUM-ENTRIES(cMenu,'|') BY 3:
    ASSIGN
      c1 = c1 + '|' + ENTRY(i1,cMenu,'|')
      c2 = c2 + '|' + ENTRY(i1 + 1,cMenu,'|')
      c3 = c3 + '|' + ENTRY(i1 + 2,cMenu,'|').
  END.
  cPath = getImagePath("ry/img/":U).
  IF c1 > '' THEN 
    gcMenues = gcMenues
             + '~n<div id="menu" name="menu" target=' + cTarget + ' ~n  level="' + c1
             + '"~n  actions="' + c2
             + '"~n  labels="' 
             + REPLACE(c3,"src=ry/img/","src=" + cPath)
             + '"></div>~n'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputSDO Procedure 
PROCEDURE outputSDO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phSDO                  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcAutoCommit           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcUpdateTarget         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcExport               AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcParentChildSupport   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSBOName              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE c1                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllColProps        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColProps           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCols               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTypes          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabled            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilter             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilters            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromVal            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInitVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupObj          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSorting            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToVal              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToVals             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateableCols     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i3                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumCols            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFirst              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE rRowid              AS ROWID      NO-UNDO.

  cFinalSDOName = IF ( NUM-ENTRIES(pcSDOName, ".":U) > 1 ) 
                  THEN ENTRY(2, pcSDOName, ".":U) ELSE pcSDOName.

  {&OUT}
    '<div class="wdo" objtype="wdo" id="d':U + cFinalSDOName + '" sbo="' + TRIM(LC(pcSBOName)) + 
    '" commit="' + TRIM(pcAutoCommit) + '" update="':U + pcUpdateTarget '" ':U + pcParentChildSupport SKIP.

  ASSIGN
    lFirst          = TRUE
    cCols           = getSDODataColumns(pcLogicalObjectName, phSDO, NO)
    iNumCols        = NUM-ENTRIES(cCols)
    cUpdateableCols = getSDODataColumns(pcLogicalObjectName, phSDO, YES)
    cAllColProps    = DYNAMIC-FUNCTION('columnProps':U    IN phSDO, cCols, 'DataType,Initial':U)
    cFilterKey      = pcLogicalObjectName + ".":U + pcSDOName + ".filter":U
    cFilters        = TRIM(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                        cFilterKey, NO),"|":U).

  /* Check Profile Manager for saved filter settings */
  IF cFilters = "" THEN
    RUN getProfileData IN gshProfileManager 
      ("SDO":U,             /* Profile type code */
       "Attributes":U,      /* Profile code */
       cFilterKey,          /* Profile data key */
       "NO":U,              /* Get next record flag */
       INPUT-OUTPUT rRowid, /* Rowid of profile data */
       OUTPUT cFilters) NO-ERROR.

  DO i = 1 TO iNumCols:
    ASSIGN
      cFieldName = ENTRY(i, cCols)
      cColProps  = ENTRY(i, cAllColProps, CHR(3))
      cDataType  = ENTRY(2, cColProps, CHR(4))
      cDataType  = ENTRY(1 + LOOKUP(cDataType,"date,decimal,integer,logical":U),
                                              ",date,dec,int,log":U)
      cFromVal   = ""
      cToVal     = "".

    IF cFilters <> "" AND cFilters <> ? THEN
    DO i1 = 1 TO NUM-ENTRIES(cFilters, "|":U):
      cEntry = ENTRY(i1, cFilters, "|":U).
      IF ENTRY(1, cEntry, " ":U) = cFieldName THEN DO:
        IF ENTRY(2, cEntry, " ":U) = ">":U THEN
                cFromVal = ENTRY(3, cEntry, " ":U).
        ELSE
        IF ENTRY(2, cEntry, " ":U) = "<":U THEN
                cToVal = ENTRY(3, cEntry, " ":U).
      END.
    END.
  
    ASSIGN
      cFieldNames  = cFieldNames + (IF lFirst THEN "":U ELSE "|":U) + LC(cFieldName)
      cEnabled     = cEnabled + (IF lFirst THEN "":U ELSE "|":U) +
                       (IF LOOKUP(cFieldName, cUpdateableCols) <> 0 THEN 'y':U ELSE 'n':U)
      cDataTypes   = cDataTypes + (IF lFirst THEN "":U ELSE "|":U) + cDataType
      cInitVals    = cInitVals + (IF lFirst THEN "":U ELSE "|":U) +
                       TRIM(ENTRY(3, cColProps, CHR(4)))
      cFromVals    = cFromVals + (IF lFirst THEN "":U ELSE "|":U) + cFromVal
      cToVals      = cToVals + (IF lFirst THEN "":U ELSE "|":U) + cToVal
      cFormat      = cFormat + "|":U
      cFilter      = cFilter + (IF lFirst THEN "":U ELSE "|":U) + 'y':U
      cSorting     = cSorting + (IF lFirst THEN "":U ELSE "|":U) + 'y':U
      cTableFields = cTableFields + (IF lFirst THEN "":U ELSE ",":U) + cFieldName
      lFirst       = no.
  END.
  
  ASSIGN i1        = LOOKUP(pcSDOName,gcScreen,'|') + 1.
    
  IF i1 > 1 THEN DO:
    c1 = ENTRY(i1,gcScreen,'|':U).
    
    /* Get initial lookup display value */
    DO i2 = 1 TO NUM-ENTRIES(c1, CHR(4)) BY 8:
      ASSIGN
        cFieldName    = LC(ENTRY(i2 + 3, c1, CHR(4)))
        cDisplayField = LC(ENTRY(2, ENTRY(i2 + 1, c1, CHR(4)), '.':U))
        cLookupObj    = LC(ENTRY(i2 + 7, c1, CHR(4)))
        cFieldNames   = cFieldNames + '|_':U + cLookupObj
        cEnabled      = cEnabled + (IF CAN-DO(cUpdateableCols, cFieldName) THEN '|y':U ELSE '|':U)
        c2            = c2 + "|":U 
        NO-ERROR.
    
      /* Get linked field display value */    
      cFields = ENTRY(i2 + 6, c1, CHR(4)).
      IF cFields <> "" AND cFields <> ? THEN
      DO i3 = 1 TO NUM-ENTRIES(cFields):
        ASSIGN
          cLinkField   = LC(ENTRY(2, ENTRY(i3, cFields), ".":U))
          cFieldNames  = cFieldNames + '|_':U + cLookupObj + cLinkField
          cEnabled     = cEnabled  + '|':U
          c2           = c2 + '|':U
          NO-ERROR.
      END.
    END.
    ASSIGN cInitVals = appendLookupData("", pcSDOName, cCols, cInitVals) NO-ERROR.
  END.

  {&OUT}
    ' fields="':U + cFieldNames + '" ':U SKIP
    ' validate="':U + cDataTypes + c2 + '" ':U SKIP /* previously datatype=... */
    ' enabled="':U + cEnabled + '" ':U SKIP
    ' initvals="':U + cInitVals + '" ':U SKIP
    ' from="':U + cFromVals + c2 + '" ':U SKIP
    ' to="':U + cToVals + c2 + '" ':U SKIP
    ' format="':U + cFormat + c2 + '" ':U SKIP
    ' filter="':U + cFilter + c2 + '" ':U SKIP
    ' sorting="':U + cSorting + c2 + '" ':U + pcExport + '>~n</div>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputTreeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputTreeData Procedure 
PROCEDURE outputTreeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER        pcNodeCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER        pcParentDS AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER        pcKey      AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER cDS        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER cData      AS CHARACTER  NO-UNDO.
  
  MESSAGE 'Treenode:'  pcNodeCode '=' pcParentDS '/' pcKey.

  FIND gsm_node NO-LOCK WHERE gsm_node.node_code = pcNodeCode.
  ASSIGN    
    cDS   = cDS + (IF cDS > '' THEN '|' ELSE '') + gsm_node.data_source
    cData = cData + (IF cData > '' THEN ',' ELSE '[') 
          + "'" + gsm_node.node_code                 /* tree node */
          + "|" + gsm_node.logical_object            /* container */
          + "|" + gsm_node.node_label                /* LABEL  */
          + "|" + gsm_node.image_file_name           /* Image1 */
          + "|" + gsm_node.selected_image_file_name  /* Image2 */
          + "|unknown"                               /* branch */
          + "|rowid"                                 /* Data rowident */
          + "'".
  /*** 
  Here should be code to 
  1. start parent SDO  
  2. start SDO
  3. position parent SDO to rowid (pcKey)
  4. output defs and rowid for each record.

  Note, SDOs are only identified by name as the repository object.
  
  ***/ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenBegin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenBegin Procedure 
PROCEDURE screenBegin :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTitle       AS CHARACTER  NO-UNDO INITIAL 'Dynamics'.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cJavascript  AS CHARACTER  NO-UNDO.

  /* Get container, so we can check for StyleSheetFile and/or JavaScriptFile
     attributes. */
  IF VALID-HANDLE(ghObjectBuffer) THEN 
  DO:
    ghObjectBuffer:FIND-FIRST(" WHERE cache_Object.tLogicalObjectName = '":U + gcLogicalObjectName + "'" ) NO-ERROR.
    IF ghObjectBuffer:AVAILABLE THEN DO:
        hBuffer = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE NO-ERROR.
      hBuffer:FIND-FIRST(" WHERE " + hBuffer:NAME + ".tRecordIdentifier = DEC('"
               + ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE + "')") NO-ERROR.

      IF hBuffer:AVAILABLE THEN DO:
        ASSIGN cTitle          = hBuffer:BUFFER-FIELD("WindowName":U):BUFFER-VALUE NO-ERROR.
        ASSIGN gcContainerMode = hBuffer:BUFFER-FIELD("ContainerMode":U):BUFFER-VALUE NO-ERROR.
        ASSIGN ix              = hBuffer:BUFFER-FIELD("StartPage":U):BUFFER-VALUE NO-ERROR.
        ASSIGN cJavaScript     = hBuffer:BUFFER-FIELD("JavaScriptFile":U):BUFFER-VALUE NO-ERROR.
        ASSIGN gcStylesheet    = hBuffer:BUFFER-FIELD("StyleSheetFile":U):BUFFER-VALUE NO-ERROR.
        ASSIGN gcFolderType    = hBuffer:BUFFER-FIELD("FolderType":U):BUFFER-VALUE NO-ERROR.

        IF gcStyleSheet = ? OR gcStyleSheet = "" THEN gcStyleSheet = "../dhtml/ryapp.css":U.
        IF cJavaScript = ? THEN cJavaScript = "".

        IF ix > 0 THEN gcPageProps = gcPageProps + 'startpage=' + STRING(ix).
      END.
    END.
  END.

  /* Output HTTP Header */
  output-content-type ("text/html":U).

  ASSIGN
    gcJS    = ''
    gcJsRun = ''
    cTitle  = (IF cTitle = ? THEN '' ELSE cTitle) /* + ' &#160; ' + FILL('_',120) */.

  {&OUT}
    '<?xml version="1.0" encoding="UTF-8"?>~n':U
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"~n':U
    '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">~n':U
    '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">~n':U
    '<head my="head">~n':U 
    '<title>':U cTitle '</title>~n':U 
    '<meta name="Generator" content="Dynamics20" />~n':U 
    (IF gcBaseHref > '':U THEN 
      '<base href="':U + ENTRY(1,gcBaseHref,'|':U) + '" />~n':U ELSE '':U).

  RUN includeJS(cJavascript) NO-ERROR.  /** At the end **/

  /* The main stylesheet reference is output here for smooth screen drawing. */
  /* Output StyleSheet file reference(s) */
  DO ix = 1 TO NUM-ENTRIES(gcStyleSheet):
    {&OUT}
      '<link rel="stylesheet" type="text/css" href="' + TRIM(ENTRY(ix,gcStyleSheet)) + '" />~n':U.
  END.
  {&OUT}
    '</head>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenData Procedure 
PROCEDURE screenData :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  /* Output HTTP Header */
  output-content-type ("text/html":U).

  {&OUT}
    '<?xml version="1.0" encoding="UTF-8"?>~n':U SKIP
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"~n':U SKIP
    '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">~n':U SKIP
    '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">~n':U SKIP
    '<body onload="parent.apph.ready(window)">':U SKIP
    '<script language="javascript"><!--':U SKIP
    'function run(app)~{':U SKIP
    .
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenEmpty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenEmpty Procedure 
PROCEDURE screenEmpty :
/*------------------------------------------------------------------------------
  Purpose:     Just send the client Action to the client.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  IF get-value('do') > '' THEN
    RUN screenData.
  ELSE DO:
    /* Output HTTP Header */
    output-content-type ("text/html":U).
    {&OUT}
      '<?xml version="1.0" encoding="UTF-8"?>~n':U
      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"~n':U
      '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">~n':U
      '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">~n<head>~n':U 
      '<link rel="stylesheet" type="text/css" href="../dhtml/ryapp.css" />~n':U
      '</head>~n':U 
      '<body><div id="wbo" objtype="wbo"></div>~n':U 
      '<script language="javascript"><!--~n':U
      'function run(app)~{~n':U.
  END.
  
  RUN ScreenEnd.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenEnd Procedure 
PROCEDURE screenEnd :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMimeCharset AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRet         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER    NO-UNDO.

  IF NOT glNeedToDoUI THEN
    RUN getUIChanges NO-ERROR.
    
/*
  IF WEB-CONTEXT:HTML-CHARSET <> "" THEN DO:
    RUN adecomm/convcp.p (WEB-CONTEXT:HTML-CHARSET, "toMime":U, OUTPUT cMimeCharset) NO-ERROR.
        lognote('note','wscharset=' + cmimecharset).
        RUN setClientAction ('wscharset.set|' + cMimeCharset).
  END.
*/

  FOR EACH ttClientAction EXCLUSIVE-LOCK:
    cRet = cRet + (IF cRet > "" THEN "  ,":U ELSE " app.apph.actions(~n  [":U) 
           + '"':U + ttClientAction.ttAction + '"~n':U.
    DELETE ttClientAction.
  END.
  IF cRet > "" THEN
    cRet = cRet + " ]);~n":U.

  {&OUT} '~n':U gcJsRun '~n':U cRet '~n}~n':U gcJS '~n--></script>'.

  /* Output CSS include file(s). */
  DO ix = 1 TO NUM-ENTRIES(gcIncludeCSS):
    {&OUT} '<link rel="stylesheet" type="text/css" href="' TRIM(ENTRY(ix,gcIncludeCSS)) '" />~n':U.
  END.
  
  /* Output JavaScript include file(s). */
  DO ix = 1 TO NUM-ENTRIES(gcIncludeJS):
    {&OUT} '<script language="javascript" src="':U TRIM(ENTRY(ix,gcIncludeJS)) '"></script>~n':U.
  END.
  
  {&OUT} 
    '~n</body>~n</html>':U SKIP.

  /* Flush the web stream, so control is passed back to the user immediately
     (so they don't have to wait for the rest of cleanup to be done. */
  PUT {&WEBSTREAM} CONTROL NULL(0).

  EMPTY TEMP-TABLE ttLinkedField.
  EMPTY TEMP-TABLE ttLink.
  
  ASSIGN 
    gcJS          = '':U
    gcJsRun       = '':U
    gcIncludeCSS  = '':U
    gcIncludeJS   = '':U
    giMinTabindex = 0
    giMaxTabindex = 0
    gcPageProps   = ''
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenError Procedure 
PROCEDURE screenError :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       We also do a JavaScript alert, in case this is output to a 
               hidden frame.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcErrorMsg AS CHARACTER NO-UNDO.

  {&OUT}       
    '<?xml version="1.0" encoding="UTF-8"?>~n':U
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"~n':U
    '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">~n':U
    '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">~n':U
    '<head>~n':U SKIP
    '<title> Dynamics User Interface Manager - ERROR! </title>~n':U SKIP
    '</head>~n':U SKIP
    '<body>~n':U SKIP
    '<h1>Dynamics User Interface Manager - ERROR!</h1>~n':U SKIP
    '<h2>An error occurred while generating the user interface. Details are as follows:</h2>~n':U SKIP
    pcErrorMsg
    '<script language="javascript">alert("UI Manager - ERROR:~\n':U pcErrorMsg '");</script>~n':U SKIP
    '</body>~n':U SKIP
    '</html>~n':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenUI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenUI Procedure 
PROCEDURE screenUI :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  RUN fetchUI.
  RUN screenBegin.

  IF get-value('lookup':U) BEGINS "DYN=":U THEN
    RUN doClientMessages.

  {&OUT} '<body tabindex="-1" ' gcPageProps '>':U SKIP.

  logNote('note',"Running Container":U).
  RUN doContainer.
  {&OUT}
    '<script language="javascript"><!--':U SKIP
    'function run(app)~{':U SKIP.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDOFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSDOFields Procedure 
PROCEDURE setSDOFields :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will set the SDO fields used for the widget.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSDOName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFieldList         AS CHARACTER  NO-UNDO.

  FIND FIRST ttSDOFieldsUsed WHERE
     ttSDOFieldsUsed.topObjectName   = pcLogicalObjectName AND
     ttSDOFieldsUsed.SDOName         = pcSDOName
  NO-ERROR.
  IF NOT AVAILABLE ttSDOFieldsUsed THEN
  DO:
    CREATE ttSDOFieldsUsed.
    ASSIGN
        ttSDOFieldsUsed.topObjectName   = pcLogicalObjectName
        ttSDOFieldsUsed.SDOName         = pcSDOName.
  END.
  IF NOT ttSDOFieldsUsed.isComplete THEN
  DO:
    ttSDOFieldsUsed.SDOFieldsUsed = ttSDOFieldsUsed.SDOFieldsUsed + "," + pcFieldList.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkIfOtherInstanceExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkIfOtherInstanceExists Procedure 
FUNCTION checkIfOtherInstanceExists RETURNS LOGICAL
  ( pcViewerName AS CHARACTER,
    pcFieldName AS CHARACTER,
    phObjectBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will check if another instance od the field exists 
            in the results returned from the fetch Object.
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hObjectBuffer   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lReturnValue    AS LOGICAL NO-UNDO.

  CREATE BUFFER hObjectBuffer FOR TABLE phObjectBuffer IN WIDGET-POOL "B2BUIM":U.

  DEFINE VARIABLE cWhere AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQ     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE glOk   AS LOGICAL    NO-UNDO.

  cWhere  = " FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
          + hObjectBuffer:NAME + ".tContainerObjectName = '":U + pcViewerName + "' AND ":U
          + hObjectBuffer:NAME + ".tLogicalObjectName = '":U + pcFieldName + "' AND ":U
          + " LOOKUP(" + hObjectBuffer:NAME + ".tClassTableName, '" + gcFieldClasses + "') > 0 ":U.

  /* Make sure nothing available - stop potential infinite loop below if query fails. */
  hObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
  CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
  hQ:ADD-BUFFER(hObjectBuffer).
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN
  DO:
    logNote('note',"Error preparing query.  ErrorMsg: ":U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)) NO-ERROR.
    RUN setMessage  (INPUT "** ERROR preparing query for loop through fields on viewer, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  lReturnValue = hObjectBuffer:AVAILABLE.

  hQ:QUERY-CLOSE().
  hObjectBuffer:BUFFER-RELEASE() NO-ERROR.
  DELETE OBJECT hQ      NO-ERROR.
  ASSIGN hQ = ?.

  RETURN lReturnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatValue Procedure 
FUNCTION formatValue RETURNS CHARACTER
    ( INPUT pcValue AS CHARACTER,
      INPUT pcFormat AS CHARACTER,
      INPUT pcDataType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return format applied to a value
    Notes:
------------------------------------------------------------------------------*/
  IF pcFormat = "" OR pcFormat = ? THEN RETURN pcValue.
  CASE pcDataType:
    WHEN "character":U THEN
      RETURN STRING(pcValue, pcFormat).
    WHEN "date":U THEN
      RETURN STRING(DATE(pcValue), pcFormat).
    WHEN "decimal":U THEN
      RETURN STRING(DECIMAL(pcValue), pcFormat).
    WHEN "integer":U THEN
      RETURN STRING(INTEGER(pcValue), pcFormat).
    WHEN "logical":U THEN
      RETURN STRING(LOGICAL(pcValue), pcFormat).
    OTHERWISE 
      RETURN pcValue.
  END CASE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferHandle Procedure 
FUNCTION getBufferHandle RETURNS HANDLE
    ( INPUT pcBufferCache AS HANDLE,
      INPUT pcBufferName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle for a specified buffer from the buffer cache
            temp-table.
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.

  IF VALID-HANDLE(pcBufferCache) THEN
  DO:
    pcBufferCache:FIND-FIRST(" WHERE ":U + pcBufferCache:NAME + ".tBufferName = '":U + pcBufferName + "' ":U ) NO-ERROR.
    IF pcBufferCache:AVAILABLE THEN
      ASSIGN hBuffer = pcBufferCache:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE NO-ERROR.
  END.    /* valid buffer cache buffer */

  RETURN hBuffer.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Get the image file path
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFrom    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTo      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLen     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER    NO-UNDO.

  DO ix = 1 TO NUM-ENTRIES(gcImagePath) BY 2:
    ASSIGN
      cFrom = ENTRY(ix, gcImagePath)
      iLen  = LENGTH(cFrom, "character":U)
      cTo   = ENTRY(ix + 1, gcImagePath).
    
    IF pcFileName BEGINS cFrom THEN DO:
      SUBSTRING(pcFileName, 1, iLen, "character":U) = cTo.
      LEAVE.
    END.
  END.

  RETURN pcFileName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkTypes Procedure 
FUNCTION getLinkTypes RETURNS CHARACTER
  (INPUT d1 AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRet AS CHARACTER NO-UNDO.
  
  FOR EACH ttLink WHERE (ttFrom = d1 OR ttTo = d1) AND ttType <> 'SDO':
      cRet = cRet + (IF cRet > '' THEN ',' ELSE '') + ttLink.ttType.
  END.

  RETURN cRet.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOLink Procedure 
FUNCTION getSDOLink RETURNS CHARACTER
  (INPUT d1 AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  
  IF CAN-FIND(ttLink WHERE ttLink.ttFrom = d1 AND ttLink.ttType = 'sdo') THEN DO:
    /* For SDOs you only want to find the parent SDO */
    FIND FIRST ttLink WHERE ttTo = d1 AND ttSDO = 'SDO' NO-ERROR.
    IF AVAILABLE ttLink THEN DO:
      d1 = ttFrom. /* Finding the SDO it goes from */
      FIND FIRST ttLink WHERE ttLink.ttType = 'SDO' AND ttLink.ttFrom = d1.
      c1 = ttLink.ttSDO.
    END.
  END.
  ELSE DO:
    FOR EACH ttLink WHERE ttFrom = d1 OR ttTo = d1 AND ttSDO > '':
        IF ttLink.ttSDO = '' THEN NEXT.
        c1 = IF (c1 > '' AND c1 <> ttLink.ttSDO) THEN 'wdo' ELSE ttLink.ttSDO.
    END.
  END.

  IF c1 = '' OR c1 = 'master' THEN c1 = gcMasterLink.
  RETURN LC(c1).   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecurityTokens Procedure 
FUNCTION getSecurityTokens RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns the token securoty for the Object 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSecuredTokens AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghSecurityManager) THEN
    ghSecurityManager =  DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                          "SecurityManager":U).
  
  IF NOT VALID-HANDLE(ghSecurityManager) THEN
    RETURN "":U.

  /* get list of secured tokens for the container instance */
  RUN tokenSecurityGet IN ghSecurityManager (INPUT ?,
                                             INPUT pcLogicalObjectName,
                                             INPUT "":U,
                                             OUTPUT cSecuredTokens).

  IF (cSecuredTokens = ?) THEN
    cSecuredTokens = "":U.

  RETURN cSecuredTokens.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-jsTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION jsTrim Procedure 
FUNCTION jsTrim RETURNS CHARACTER
  ( INPUT c1 AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Trims special characters for Javascript names  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN  
    c1 = REPLACE(REPLACE(LC(c1),'(','_'),')','')
    c1 = REPLACE(REPLACE(c1,'-','_'),'*','_')
    c1 = REPLACE(REPLACE(c1,'/','_'),'+','_')
    c1 = REPLACE(REPLACE(c1,' ',''),':','')
    .
  RETURN c1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( pcImagePath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  gcImagePath = pcImagePath.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabIndex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tabIndex Procedure 
FUNCTION tabIndex RETURNS INTEGER
  ( INPUT i1 AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Set the TabIndex for the object 
    Notes:  
------------------------------------------------------------------------------*/
  IF i1 < 1 THEN RETURN -1.
  i1 = giMinTabIndex + i1.
  IF i1 > giMaxTabIndex THEN giMaxTabIndex = i1.
  RETURN i1.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

