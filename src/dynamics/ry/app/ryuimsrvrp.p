&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------
  File:         ry/app/ryuimsrvrp.p

  Description:  UI Manager for DHTML/B2B Client Type

  Purpose:      Performs for all UI input and output functionality.
                This UI Manager is specific to the DHTML/B2B client type.

  Parameters:   <none>

  History:
  --------

  Update Notes: Created from Template rytemprocp.p

------------------------------------------------------------------------------*/
/*              This .W file was created with the Progress AppBuilder         */
/*----------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Removing Version 10 specific datatypes in 2.1B */
&IF NOT PROVERSION BEGINS "9" &THEN
&GLOBAL newdatatypes CLOB,BLOB,DATETIME,DATETIME-TZ
&GLOBAL clobtype LONGCHAR
&ELSE
&GLOBAL clobtype CHARACTER
&ENDIF

{af/sup2/afglobals.i NEW GLOBAL}
{af/sup/afghplipdf.i NEW GLOBAL}
{src/web2/wrap-cgi.i}
{lognote.i icf}

/* Repository attribute values */
{ry/app/ryobjretri.i }

/* Menu/Toolbar temp tables etc */
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}
{src/adm2/treettdef.i}
  
/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

&SCOPED-DEFINE htmlLayout JavascriptFile,StylesheetFile,LayoutPosition,MinWidth,MinHeight,HideOnInit,HtmlStyle,ObjectName,LogicalObjectName
&SCOPED-DEFINE htmlProps  HtmlClass,HELP,Order
&SCOPED-DEFINE htmlLabel  row,column,LABELS

&SCOPED-DEFINE lval_names  cAttNames
&SCOPED-DEFINE lval_values cAttValues

/** Logging **/
DEFINE VARIABLE timeMenu     AS INTEGER    NO-UNDO INIT 0.
DEFINE VARIABLE timeEvent    AS INTEGER    NO-UNDO INIT 0.
DEFINE VARIABLE timeCombo    AS INTEGER    NO-UNDO INIT 0.

DEFINE VARIABLE timeSDOstart AS INTEGER    NO-UNDO INIT 0.
DEFINE VARIABLE timeLookup   AS INTEGER    NO-UNDO INIT 0.

/** Attribute cache that is also defined here to avoid running multiple times in various cases. GLOBAL **/
DEFINE VARIABLE cAttNames  AS CHARACTER NO-UNDO.   
DEFINE VARIABLE cAttValues AS CHARACTER NO-UNDO.
    
DEFINE VARIABLE gcHtmlHeader AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAttrNames            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAttrValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAttrValues           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBand                 AS CHARACTER  NO-UNDO. /* Band portion of menu controller */
DEFINE VARIABLE gcCssTheme             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseHref             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLayoutCode           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTreeRootNode         AS CHARACTER  NO-UNDO. /* Dynamic Treeview */
DEFINE VARIABLE gcTreeAutoSort         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTreeRowsToBatch      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDefaultStaticPath    AS CHARACTER  NO-UNDO INITIAL '../dhtml/'.
DEFINE VARIABLE gcEventObjectActions   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectHotkeys   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectLabels    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectLevels    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventObjectType      AS CHARACTER  NO-UNDO. /* menubar, toolbar */
DEFINE VARIABLE gcHotkey               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcImagePath            AS CHARACTER  NO-UNDO INITIAL 'ry/img/,../img/'.
DEFINE VARIABLE gcPageProps            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcIncludeJS            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcIncludeCSS           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcStyleSheet           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcJS                   AS CHARACTER  NO-UNDO. /* Accumulate JS for data section */
DEFINE VARIABLE gcJsRun                AS CHARACTER  NO-UNDO. /* Accumulate JS for data section */
DEFINE VARIABLE gcLogicalObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMasterObjectId       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupContainerName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcContainerMode        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMainMenuType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMasterLink           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMenu                 AS CHARACTER  NO-UNDO. /* for one toolbar object */
DEFINE VARIABLE gcMenues               AS CHARACTER  NO-UNDO. /* accumulated output at end */
DEFINE VARIABLE gcNewLine              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPanel                AS CHARACTER  NO-UNDO. /* screen portion of panel-type smart-toolbar */

/** Variables being defined with outside scope to avoid excesive parameter passing in doViewer() **/
DEFINE VARIABLE gcViewerName           AS CHARACTER  NO-UNDO. /* current viewer being processed */
DEFINE VARIABLE gcSdoName              AS CHARACTER  NO-UNDO. /* current SDO for viewer         */
DEFINE VARIABLE gcSboName              AS CHARACTER  NO-UNDO. /* current SBO for viewer         */
DEFINE VARIABLE gcEvents               AS CHARACTER  NO-UNDO. /* Events                         */
DEFINE VARIABLE gcId                   AS CHARACTER  NO-UNDO. /* Field name/ID                  */
DEFINE VARIABLE gcState                AS CHARACTER  NO-UNDO. /* Enabled/Disabled state         */

DEFINE VARIABLE gcRequestEvents        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcRunAttribute         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSessionResultCodes   AS CHARACTER  NO-UNDO.
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
DEFINE VARIABLE glExportLOBData        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glMasterLink           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glIsDynFrame           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSDOContainer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE glOutputSDODefinition  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSecurityManager      AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSecuredTokens        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLocalFieldCounter    AS INTEGER    NO-UNDO.
DEFINE VARIABLE giDataCounter          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giRowNumber            AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcDataDelimiter        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveSDOName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glViewerShowPopup      AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttLinkedField NO-UNDO
  FIELD cSDO    AS CHARACTER
  FIELD cViewer AS CHARACTER
  FIELD cWidget AS CHARACTER
  FIELD cLookup AS CHARACTER
  FIELD cField  AS CHARACTER
  FIELD lIsLocal AS LOGICAL
  INDEX cSDO    cSDO cViewer cWidget
  .
DEFINE TEMP-TABLE ttSDO NO-UNDO
  FIELD ttContainer AS CHARACTER
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
  FIELD ttFrom       AS CHARACTER
  FIELD ttTo         AS CHARACTER
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
  FIELD hasComments AS LOGICAL
  INDEX prima     IS PRIMARY UNIQUE SDOName Counter
  .
DEFINE TEMP-TABLE ttCLOBData NO-UNDO
  FIELD SDOName      AS CHARACTER
  FIELD ttCounter    AS INTEGER
  FIELD ttSubCounter AS INTEGER
  FIELD ttColumnName AS CHARACTER
&IF DEFINED(newdatatypes) &THEN
  FIELD ttValue      AS CLOB
&ELSE
  FIELD ttValue      AS CHARACTER
&ENDIF
  FIELD ttDelimiter  AS CHARACTER
  INDEX prima     IS PRIMARY UNIQUE SDOName ttCounter ttSubCounter
  .

DEFINE TEMP-TABLE ttSDOLink NO-UNDO
  FIELD SDOName       AS CHARACTER
  FIELD ParentSDOName AS CHARACTER
  FIELD ForeignFields AS CHARACTER
  FIELD SDOEvent      AS CHARACTER
  FIELD SaveFilter    AS LOGICAL
  INDEX primar        IS PRIMARY UNIQUE SDOName
  .

DEFINE STREAM sText.

DEFINE TEMP-TABLE ttDSSaveEvents NO-UNDO
  FIELD DSName AS CHARACTER
  FIELD DSSaveEvent AS CHARACTER
  FIELD IsSBO AS LOGICAL
  INDEX primar IS PRIMARY UNIQUE DSName
  .

DEFINE TEMP-TABLE ttCommittedData NO-UNDO
  FIELD DSName     AS CHARACTER
  FIELD Counter    AS INTEGER
  FIELD Data       AS CHARACTER
  FIELD LookupData AS CHARACTER
  FIELD Action     AS CHARACTER
  FIELD hasComments AS LOGICAL
  INDEX primar IS PRIMARY DSName Counter
  .
DEFINE TEMP-TABLE ttConflictData NO-UNDO
  FIELD DSName     AS CHARACTER
  FIELD Counter    AS INTEGER
  FIELD Data       AS CHARACTER
  FIELD LookupData AS CHARACTER
  FIELD hasComments AS LOGICAL
  INDEX primar IS PRIMARY DSName Counter
  .

DEFINE TEMP-TABLE ttComboData NO-UNDO
    FIELD ttComboName AS CHARACTER
    FIELD ttData AS CHARACTER
    INDEX primar IS PRIMARY ttComboName
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

&IF DEFINED(EXCLUDE-doMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD doMenu Procedure 
FUNCTION doMenu RETURNS CHARACTER PRIVATE
  (INPUT cMenu AS CHARACTER, INPUT cTarget AS CHARACTER, INPUT cWdo AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatValue Procedure 
FUNCTION formatValue RETURNS CHARACTER PRIVATE
    ( INPUT pcValue AS CHARACTER,
      INPUT pcFormat AS CHARACTER,
      INPUT pcDataType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER PRIVATE
  ( pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkTypes Procedure 
FUNCTION getLinkTypes RETURNS CHARACTER PRIVATE
  (INPUT c1 AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOForComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOForComments Procedure 
FUNCTION getSDOForComments RETURNS HANDLE
  (plPositionToRow AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOLink Procedure 
FUNCTION getSDOLink RETURNS CHARACTER PRIVATE
  (INPUT cIn AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecurityTokens Procedure 
FUNCTION getSecurityTokens RETURNS CHARACTER PRIVATE
  ( pcLogicalObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarSource Procedure 
FUNCTION getToolbarSource RETURNS CHARACTER PRIVATE
  ( pcTargetName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeString Procedure 
FUNCTION getTreeString RETURNS CHARACTER PRIVATE
  (BUFFER bNode FOR ttNode) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVal Procedure 
FUNCTION getVal RETURNS CHARACTER PRIVATE
  (INPUT c1 AS CHARACTER, INPUT c2 AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlClass Procedure 
FUNCTION htmlClass RETURNS CHARACTER PRIVATE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlLabel Procedure 
FUNCTION htmlLabel RETURNS CHARACTER PRIVATE
  ( cLabelId AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlLayout Procedure 
FUNCTION htmlLayout RETURNS CHARACTER PRIVATE
  (cObjectType AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD htmlProps Procedure 
FUNCTION htmlProps RETURNS CHARACTER PRIVATE
  (cTipName AS CHAR, cState AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-jsTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD jsTrim Procedure 
FUNCTION jsTrim RETURNS CHARACTER PRIVATE
  ( INPUT c1 AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-maxlength) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD maxlength Procedure 
FUNCTION maxlength RETURNS CHARACTER PRIVATE
  (INPUT cFormat AS CHARACTER, INPUT cDatatype AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processFieldSecurity Procedure 
FUNCTION processFieldSecurity RETURNS LOGICAL PRIVATE
        (INPUT pcInstanceName AS CHARACTER,
     INPUT pcFieldSecurity AS CHARACTER, 
     INPUT-OUTPUT pcHiddenFields AS CHARACTER, 
     OUTPUT plIsReadonly AS LOGICAL ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveDynLookupInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDynLookupInfo Procedure 
FUNCTION saveDynLookupInfo RETURNS LOGICAL PRIVATE
  (INPUT pcLogicalObjectName AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-setLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLayout Procedure 
FUNCTION setLayout RETURNS LOGICAL PRIVATE
    ( INPUT lToolbar AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabIndex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tabIndex Procedure 
FUNCTION tabIndex RETURNS INTEGER PRIVATE
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
         HEIGHT             = 27.14
         WIDTH              = 55.
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
  gcNewLine        = (IF OPSYS = "UNIX":U THEN "~\~\n":U ELSE "~\n":U)

/*   
  gcHtmlHeader = '~n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"~n "http://www.w3.org/TR/xhtml1/DTD/xhtml1-t.dtd">':U
               + '~n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">'
  gcHtmlHeader = '~n<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"~n    "http://www.w3.org/TR/html4/loose.dtd">':U
               + '~n<html>'
  gcHtmlHeader = '~n<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"~n "http://www.w3.org/TR/html4/strict.dtd">':U
               + '~n<html>'
*/   

  gcHtmlHeader = '<?xml version="1.0" encoding="UTF-8"?>~n<html>'
   .

/*  Old header definitions  
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
*/


        
ON CLOSE OF THIS-PROCEDURE
DO:
  DELETE WIDGET-POOL NO-ERROR.

  /* TBD: Shut down any persistent procedures started by the UIM (?) */
  DELETE PROCEDURE THIS-PROCEDURE.
  RETURN.
  
END.

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
DEFINE VARIABLE gcDynFrameClasses        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTreeviewClasses        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFieldClasses           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcProgressWidgetClasses  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSBOClasses             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartFolderClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartToolbarClasses    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartViewerClasses     AS CHARACTER  NO-UNDO.

ASSIGN 
  gcDataClasses         = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
    "Data,SBO,DynObjc,DynSDO,DynLookup,SmartFolder,DynBrow,DynView,SmartToolbar,DynMenc,SmartViewer,Field,DataField,DynToggle,DynRadioSet,DynEditor,DynFillin,DynComboBox,DynSelection,DynButton,DynText,DynImage,DynRectangle,DynCombo,DynFrame,ProgressWidget":U)
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
  gcDynFrameClasses     = ENTRY(25, gcDataClasses, CHR(3))
  gcProgressWidgetClasses = ENTRY(26, gcDataClasses, CHR(3))
  gcDataClasses         = ENTRY(1, gcDataClasses, CHR(3)) + ",":U + ENTRY(2, gcDataClasses, CHR(3))
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-doBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBrowse Procedure 
PROCEDURE doBrowse PRIVATE :
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

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldSecurity    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFiltType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFldNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJavaScriptObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelOut         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecurity         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFld              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumFlds          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lNoLabel          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTableIOTarget    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cSecuredHiddenFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredReadOnlyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoReal               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSIsASBO              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDSIsASBO              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSDO                   AS HANDLE     NO-UNDO.

  RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
    '{&htmlLayout},DisplayedFields,EnabledFields,DataSourceNames,FieldSecurity,FolderWindowToLaunch,FilterType,JavaScriptObject,BrowseColumnLabels').
  setLayout(false).

  ASSIGN
    cObjectName   = ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE
    cSDOName      = getSdoLink(cObjectName)
    cDSIsASBO      =  getSavedDSProperty(gcLogicalObjectName, cSDOName, 'isSBO':U)
    lDSIsASBO      =  (IF cDSIsASBO > "":U THEN LOGICAL(cDSIsASBO) ELSE NO)
  .


  ASSIGN
    cLabels           = {ry/inc/lval.i BrowseColumnLabels  }
    cFldNames         = {ry/inc/lval.i DisplayedFields     }
    cDataSourceNames  = {ry/inc/lval.i DataSourceNames     }
    cFieldSecurity    = {ry/inc/lval.i FieldSecurity       }
    c                 = {ry/inc/lval.i FolderWindowToLaunch}
    cFiltType         = {ry/inc/lval.i FilterType          }
    cJavaScriptObject = {ry/inc/lval.i JavaScriptObject    }
    cJavaScriptObject = (IF cJavaScriptObject = ? OR cJavaScriptObject = ""
                         THEN "browse":U ELSE cJavaScriptObject)
    iNumFlds          = NUM-ENTRIES(cFldNames).
  
  IF (cDataSourceNames = ? OR cDataSourceNames = "":U) THEN
    cDataSourceNames = cSDOName.

  IF (cDataSourceNames = 'master':U) THEN
    ASSIGN cOverrideLogicalObjectName = getPassThruSDOInfo(1)
           cSdoReal = getPassThruSDOInfo(2).
  ELSE
    ASSIGN cSdoReal = (IF lDSIsASBO THEN cSDOName + "." + cDataSourceNames ELSE cDataSourceNames)
           cOverrideLogicalObjectName = gcLogicalObjectName.

  IF cSdoReal > "":U AND cOverrideLogicalObjectName > "":U AND NUM-ENTRIES(cSdoReal, ",":U) = 1 THEN
  DO:
    ASSIGN hSDO = getDataSourceHandle(cOverrideLogicalObjectName, cSdoReal,"":U) NO-ERROR.
    ASSIGN ERROR-STATUS:ERROR = NO.
  END.
  
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
          ASSIGN cSecuredReadOnlyFields = cSecuredReadOnlyFields + "," + cFieldName
                 cDisplayedFields       = cDisplayedFields + "," + cFieldName.
    ELSE
      cDisplayedFields = cDisplayedFields + "," + cFieldName.
  END.

  ASSIGN cDisplayedFields       = TRIM(cDisplayedFields, ",":U)
         cSecuredReadOnlyFields = TRIM(cSecuredReadOnlyFields, ",":U)
         cSecuredHiddenFields   = TRIM(cSecuredHiddenFields, ",":U).
  
  /* Save the hidden field list for sdo security */
  saveDSSecurity(cOverrideLogicalObjectName, cSDOName, cSecuredHiddenFields).

  /* Fieldset and browse DIV tags can have width and height for style attributes. */
  {&OUT} '<div' htmlLayout('browse')
    ' resize="resize" wdo="' cDataSourceNames '" objtype="' + cJavaScriptObject + '" ':U 
    (IF cFiltType = "inline":U THEN 'filter="inline"':U ELSE "") SKIP
    '  fields="':U.

  /* Store the value of FolderWindowToLaunch attribute against the SDO.
     This is used in doDS. */
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
                ttLink.ttSDO = cSDOName AND ttLink.ttTo = cObjectName) THEN
    lTableIOTarget = TRUE.

  cEnabledFields = {ry/inc/lval.i EnabledFields}.
  DO iFld = 1 TO iNumFlds:
    IF (LOOKUP(ENTRY(iFld, cFldNames), cDisplayedFields) > 0 ) THEN
    DO:
      ASSIGN cLabel = (IF NUM-ENTRIES(cLabels, CHR(5)) > iFld THEN ENTRY(iFld, cLabels, CHR(5)) ELSE '':U).
      IF cLabel = '?' OR cLabel = "":U THEN
      DO:
        IF VALID-HANDLE(hSDO) THEN
        DO:
          ASSIGN cLabel = DYNAMIC-FUNCTION("columnColumnLabel" IN hSDO, ENTRY(iFld, cFldNames)) NO-ERROR.
          ASSIGN ERROR-STATUS:ERROR = NO.
        END.
        ELSE
          ASSIGN cLabel = ENTRY(iFld, cFldNames).
      END.
      ASSIGN cLabelOut = cLabelOut + (IF cLabelOut > '' THEN '|' ELSE '') + cLabel.

      {&OUT} 
        (IF NOT lTableIOTarget THEN 'n':U ELSE
          (IF LOOKUP(ENTRY(iFld, cFldNames), cSecuredReadOnlyFields) > 0 THEN 'n':U ELSE
            (IF LOOKUP(ENTRY(iFld, cFldNames), cEnabledFields) > 0 
              THEN 'y':U ELSE 'n':U))) +         
        (IF iFld < iNumFlds THEN '|':U ELSE '':U).
    END.
  END.
  {&OUT} '" ~n labels="' cLabelOut '">~n</div></div>~n':U SKIP.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doButton Procedure 
PROCEDURE doButton PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for BUTTON
  Parameters:  <none>
  Notes:

  Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO.
  /* HtmlClass,ToolTip,Order,row,column,height-chars,width-chars,HtmlStyle,FLAT-BUTTON,Label */ 

  ASSIGN 
        cImage   = getImagePath({ry/inc/lval.i IMAGE-FILE})
        cLabel   = {ry/inc/lval.i Label}
        i1       = INDEX(cLabel,"&")
        .
  IF i1 > 0 AND i1 < LENGTH(cLabel) THEN ASSIGN
          c1 = SUBSTRING(cLabel,i1 + 1,1)
          SUBSTRING(cLabel,i1,2) = "<u>" + c1 + "</u>"
          c1 = ' accesskey="' + c1 + '"'
          .
  
  RETURN REPLACE(
        SUBSTITUTE('<button id="&1" name="&1" class="&2" type="button" title="&3" tabindex="&4"&5':U
        ,gcID
        ,htmlClass() 
        ,{ry/inc/lval.i ToolTip}
        ,tabIndex(INT({ry/inc/lval.i Order}))
        ,c1
        )
      + SUBSTITUTE(' style="top:&1px;left:&2px;height:&3px;width:&4px;&5" &6&7&8>'
        ,INT(DEC({ry/inc/lval.i row         }) * giPixelsPerRow) + giFieldOffsetTop - 2
        ,INT(DEC({ry/inc/lval.i column      }) * giPixelsPerColumn)
        ,INT(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
        ,INT(DEC({ry/inc/lval.i width-chars }) * giPixelsPerColumn)
        ,    {ry/inc/lval.i HtmlStyle   }
        ,IF LOGICAL({ry/inc/lval.i FLAT-BUTTON}) THEN " flat":U ELSE "":U
        ,IF cImage > '':U THEN " src='":U + cImage + "'":U ELSE "":U
        ,gcEvents + gcState 
        )
      + cLabel + '</button>':U
   ,'~\':U,'/':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doClientMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doClientMessages Procedure 
PROCEDURE doClientMessages PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Provide the translations for client side messages.  Retrieve all
               HTM group messages.
  Parameters:  <none>
  Notes:       TBD: This should be moved to an external API.
  
  Note! This is an internal API not intended for public use and is subject to change
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
PROCEDURE doComboBox PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Progress COMBO-BOX, SELECTION-LIST
  Parameters:  <none>
  Notes:
  
  Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pcHtml     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisual    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClass     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelimiter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cListItems AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStep      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lMultiple  AS LOGICAL    NO-UNDO.

  /* {&htmlLabel},HtmlClass,VisualizationType,multiple,InitialValue,DELIMITER,ToolTip,Order,width-chars,HtmlStyle,height-chars,LIST-ITEM-PAIRS,LIST-ITEMS */ 

  ASSIGN timeCombo = timeCombo - ETIME.

  ASSIGN
    cClass     = htmlClass()
    cVisual    = {ry/inc/lval.i VisualizationType}
    lMultiple  = IF cVisual = "SELECTION-LIST":U THEN LOGICAL({ry/inc/lval.i multiple}) ELSE FALSE
    cValue     = {ry/inc/lval.i InitialValue}
    cDelimiter = {ry/inc/lval.i DELIMITER}
    pcHtml     = htmlLabel("label") 
               + SUBSTITUTE('<select class="&2" id="&1" name="&1" tabindex="&4" title="&3"&5&6'
                 ,gcID
                 ,cClass
                 ,         {ry/inc/lval.i ToolTip}
                 ,tabIndex(INT({ry/inc/lval.i Order}))
                 ,gcState
                 ,IF lMultiple THEN ' multiple="multiple"' ELSE ''
                 ) 
               + SUBSTITUTE(' style="top:&1px;left:&2px;width:&3px;&4" size=&5 ':U
                 ,INT(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
                 ,INT(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                 ,INT(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                 ,    {ry/inc/lval.i HtmlStyle}
                 ,IF LOOKUP(cClass, gcDynComboBoxClasses) > 0 AND cVisual = "COMBO-BOX":U THEN 1 
                   ELSE INT({ry/inc/lval.i height-chars}) 
                 ) 
               + gcEvents 
               + '>~n':U.

  IF LENGTH({ry/inc/lval.i LIST-ITEM-PAIRS}) > 0 THEN
    ASSIGN
      cListItems = {ry/inc/lval.i LIST-ITEM-PAIRS}
      iStep      = 1.
  ELSE
    ASSIGN
      cListItems = {ry/inc/lval.i LIST-ITEMS}
      iStep      = 0.
      
  DO ix = 1 TO NUM-ENTRIES(cListItems, cDelimiter):
    ASSIGN
      c1     = ENTRY(ix + iStep, cListItems, cDelimiter)
      c1     = formatValue(c1,{ry/inc/lval.i FORMAT},{ry/inc/lval.i DATA-TYPE}) NO-ERROR.
    IF c1 <> ? THEN 
      ASSIGN
        pcHTML = pcHTML
               + '<option value="':U + LC(c1)
               + (IF cValue = c1 THEN '" selected="true">':U ELSE '">')
               + TRIM(html-encode(TRIM(ENTRY(ix, cListItems, cDelimiter))))
               + '</option>~n':U
        ix     = ix + iStep.
  END.
  pcHtml = pcHtml + '</select>':U.
  ASSIGN timeCombo = timeCombo + ETIME.
  RETURN pcHtml.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doContainer Procedure 
PROCEDURE doContainer PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Output the UI Layout
  Parameters:  <none>
  Notes:       Coded specifically for the DHTML client type
  
  Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClassName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerClass AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosition       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQ              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCurrPageNumber AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrRow        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLasPageNumber AS INTEGER    NO-UNDO INITIAL -1.
  DEFINE VARIABLE iLastRow        AS INTEGER    NO-UNDO.
    
  {log "'**** doContainer:' + gcLogicalObjectName"} 

/* Find correct layout code for fixing backwards compatibility. */
  ghObjectBuffer:FIND-FIRST(" WHERE ":U + ghObjectBuffer:NAME + 
    ".ObjectName = '":U + gcLogicalObjectName + "'":U ) NO-ERROR.
  IF ghObjectBuffer:AVAILABLE THEN DO:
    cContainerClass = ghObjectBuffer:BUFFER-FIELD('ClassName'):BUFFER-VALUE.
    ghPageBuffer:FIND-FIRST(" WHERE ":U + ghPageBuffer:NAME + ".InstanceId = ":U + gcMasterObjectId ) NO-ERROR.
    IF ghPageBuffer:AVAILABLE THEN
      gcLayoutCode = ghPageBuffer:BUFFER-FIELD("LayoutCode":U):BUFFER-VALUE.
  END.

/**********************************************************/
/**********************************************************/
/**********************************************************/

  CREATE QUERY hQ IN WIDGET-POOL 'B2BUIM':U.
  /* Make sure no previous record causes 'available' in the WHILE phrase below
     if the query fails. */
  ghObjectBuffer:BUFFER-RELEASE(). 
  ghPageBuffer:BUFFER-RELEASE(). 
  hQ:ADD-BUFFER(ghObjectBuffer).

  RUN doSmartLinks.

  /* Do visual objects first (do SDO's after) */
  ASSIGN
    cWhere   = "FOR EACH ":U + ghObjectBuffer:NAME + " WHERE ":U
      + ghObjectBuffer:NAME + ".ContainerInstanceId = ":U + gcMasterObjectId
      + " AND LOOKUP(" + ghObjectBuffer:NAME + ".ClassName, '" + gcDataClasses + "') = 0 "
      + " BY ":U + ghObjectBuffer:NAME + ".PageNumber":U
    gcMenues = ''.
    
  /* Make sure nothing available - stop potential infinite loop below if query fails. */
  ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    {log "'** ERROR preparing query for looping through UI objects, where: ':U +" 
            "cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' +" 
            "PROGRAM-NAME(1)"}
    RUN setMessage (INPUT "** ERROR preparing query for looping through UI objects, where: ":U + 
                    cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + 
                    PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().

  DO WHILE ghObjectBuffer:AVAILABLE:
    ASSIGN
      cClassName      = ghObjectBuffer:BUFFER-FIELD('ClassName'):BUFFER-VALUE
      iCurrPageNumber = ghObjectBuffer:BUFFER-FIELD('PageNumber'):BUFFER-VALUE
      cPosition       = SUBSTRING(ghObjectBuffer:BUFFER-FIELD('LayoutPosition'):BUFFER-VALUE,2)
      NO-ERROR.
   /* message "Object:" cClassName '=' ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE . */ 

    IF CAN-DO(gcSmartToolbarClasses,cClassName) THEN
      RUN doToolbar.   
    ELSE
    IF CAN-DO(gcSmartFolderClasses,cClassName) THEN
      RUN doFolder.
    ELSE
    IF CAN-DO(gcDynBrowClasses,cClassName) THEN
      RUN doBrowse.
    ELSE 
    IF CAN-DO(gcDynViewClasses,cClassName) THEN
      RUN doViewer.
    ELSE
    IF CAN-DO(gcDynFrameClasses,cClassName) THEN
      RUN doDynFrame.
    ELSE

    /* Skip reporting error for static SmartViewer on Menu Controller. */
    IF NOT (CAN-DO(gcDynMencClasses,cContainerClass) AND CAN-DO(gcSmartViewerClasses,cClassName)) THEN DO:
      RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'','{&htmlLayout}').
      setLayout(false).
      {&OUT} '<h3 min="100,20">Unsupported:' + cClassName + "(" + cInstanceName + ")</h3>".
      {&out} "~n</div>" SKIP.
    END.
    hQ:GET-NEXT().
  END. /* FOR EACH tt_object_instance on page (Browse & Viewer objects) */
  hQ:QUERY-CLOSE().

  IF cContainerClass = 'DynTree' THEN DO:  /* Add Treeview Objects to HTML */
    RUN doDynTree.
  END.
  
  {&OUT} SKIP.
  {log "'///// doContainer: Data'"} 
  /* SDO must be done after Browse & Viewer as these build a list of fields
     used - so the SDO doesn't have to output unused fields (for performance).
     If you really need to do SDO's before Browse & viewers then comment out
     the code in them that builds the ttSDOusedFields tt and run determineSDOFieldsUsed
     before SDO's */
  {&OUT} '<div style="display:none;visibility:hidden;">~n':U. /* Hidden elements */
  {&OUT} '<div id="wbo" objtype="wbo">':U SKIP.
  {&OUT} '<div class="wdo" id="master" remote="master" objtype="wdo"></div>~n'.
  cWhere  = "FOR EACH ":U + ghObjectBuffer:NAME + " WHERE ":U
          + ghObjectBuffer:NAME + ".ContainerInstanceId = ":U + gcMasterObjectId + " AND ":U  
          + "LOOKUP(" + ghObjectBuffer:NAME + ".ClassName, '" + gcDataClasses + "') <> 0 "
          + " BY ":U + ghObjectBuffer:NAME + ".PageNumber":U
          + " BY ":U + ghObjectBuffer:NAME + ".Order":U.
  {log "'SDOquery=' + cWhere"} 
  ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. /* Make sure nothing available - stop potential infinate loop below if query fails. */
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    {log "'** ERROR preparing query for looping through SDO objects, where: ' + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)"}
    RUN setMessage  (INPUT "** ERROR preparing query for looping through SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.
  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  DO WHILE ghObjectBuffer:AVAILABLE:
    /* message "DS Object:" cClassName '=' ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE . */
    RUN doDS.
    hQ:GET-NEXT().
  END. /* FOR EACH SDO */
  hQ:QUERY-CLOSE().
  DELETE OBJECT hQ NO-ERROR.
  ASSIGN hQ = ?.

  IF cContainerClass = 'DynTree' THEN DO:  /* Add Treeview SDOs to SBO section */
    RUN doDynTreeSdo.
  END.

  {&OUT} '</div>~n':U. /* end WBO */

  {&OUT} gcMenues.
  {&OUT} '</div>~n':U. /* end HIDDEN */


  {log "'---- doContainer:'"} 
  {log "'TIME: Menus=' + STRING(timeMenu)"}
  {log "'TIME: Event=' + STRING(timeEvent)"}
  {log "'TIME: Combo=' + STRING(timeCombo)"}
  {log "'TIME: SDO-h=' + STRING(timeSDOstart)"}
  ASSIGN 
      timeMenu  = 0
      timeEvent = 0
      timeCombo = 0
      timeSDOstart = 0
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDS Procedure 
PROCEDURE doDS PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAutoCommit         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClassName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExport             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentChildSupport AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkTypes          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOPath            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTarget       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE j                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFillBatchOnRepos   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDestroyStateless   AS CHARACTER  NO-UNDO.
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
  DEFINE VARIABLE cFinalSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsASbo             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCommit             AS CHARACTER  NO-UNDO.

  RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
    'PhysicalObjectName,ObjectName,RenderingProcedure,ForeignFields,AutoCommit,RowsToBatch,DestroyStateless,FillBatchOnRepos,DataDelimiter,JavaScriptFile,RequiredProperties').

  ASSIGN
    cObjectName = ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE
    cSDOName   = jsTrim(ENTRY(1,cObjectName,'.'))
    cSDOPath   = {ry/inc/lval.i RenderingProcedure} + {ry/inc/lval.i PhysicalObjectName}  
         /* DynSDO uses RenderingProcedure, Static uses PhysicalObjectName */
    cClassName = ghObjectBuffer:BUFFER-FIELD('ClassName'):BUFFER-VALUE
    cLinkTypes = getLinkTypes(cObjectName).

  {log "'DS:' + cObjectName + '=' + cSDOName + '/' + cClassName"}

  /* Find if object exports data link to container */
  IF CAN-DO(cLinkTypes,'PrimarySDO') THEN
    cExport = ' uplink="true"'.

  /* See if there is an associated maintenance window to launch for updating.
     Unfortunately this is an attribute (FolderWindowToLaunch) of the browse
     object and not the SDO. */
  FIND FIRST ttLink WHERE ttLink.ttFrom = cObjectName AND ttLink.ttType = 'SDO'.
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
    cForeignFields = {ry/inc/lval.i ForeignFields}
    cOriginalForeignFields = cForeignFields
    cAutoCommit    =  STRING(NOT CAN-DO(cLinkTypes,'Commit'), "true/false":U)
    cParentChildSupport = '':U.

  IF ( LOGICAL(cAutoCommit) ) THEN 
    cCommit = {ry/inc/lval.i AutoCommit}.
  ELSE
    cCommit = "false".
    
  /* SBO's don't have these properties */
  ASSIGN cRowsToBatch   = {ry/inc/lval.i RowsToBatch} NO-ERROR.

  IF (ERROR-STATUS:ERROR or cRowsToBatch = "" or cRowsToBatch = ?) THEN
    ASSIGN ERROR-STATUS:ERROR = NO
           cRowsToBatch = "50".

  ASSIGN cDestroyStateless = {ry/inc/lval.i DestroyStateless} NO-ERROR.

  IF (ERROR-STATUS:ERROR or cDestroyStateless = "" or cDestroyStateless = ?) THEN
    ASSIGN ERROR-STATUS:ERROR = NO
           cDestroyStateless = "NO".
    
  ASSIGN cFillBatchOnRepos = {ry/inc/lval.i FillBatchOnRepos} NO-ERROR.

  IF (ERROR-STATUS:ERROR or cFillBatchOnRepos = "" or cFillBatchOnRepos = ?) THEN
    ASSIGN cFillBatchOnRepos = "YES"
           ERROR-STATUS:ERROR = NO.

  ASSIGN cDataDelimiter = {ry/inc/lval.i DataDelimiter} NO-ERROR.

  IF ERROR-STATUS:ERROR or cDataDelimiter = "" or cDataDelimiter = ? THEN
    ASSIGN ERROR-STATUS:ERROR = NO
           cDataDelimiter = "|":U.

  /* Save the SDO Rows To Batch */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'RowsToBatch':U, cRowsToBatch).
  
  /* Save the SDO DestroyStateless */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'DestroyStateless':U, cDestroyStateless ).

  /* Save FillBatchOnRepos property */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'FillBatchOnRepos':U, cFillBatchOnRepos).

  /* Save the SDO Data Demiliter */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'DataDelimiter':U, cDataDelimiter).
  
  /* Save the Auto Commit Property of the SDO */
  saveDSProperty(gcLogicalObjectName, cSDOName, 'AutoCommit':U, cCommit).
  
  /* Set included Javascriptfiles */
  RUN includeJS({ry/inc/lval.i JavaScriptFile}) NO-ERROR.
  
  ASSIGN timeSDOstart = timeSDOstart - ETIME.
  /* Check if this is a SBO */
  ASSIGN
    hSDO  = getDataSourceHandle(gcLogicalObjectName, cSDOName, cSDOPath)
    cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hSDO)) NO-ERROR.
  ASSIGN timeSDOstart = timeSDOstart + ETIME.
  
  lIsASbo = FALSE.
  IF (ERROR-STATUS:ERROR OR cSDOs = ? OR cSDOs = "":U) THEN
    ASSIGN ERROR-STATUS:ERROR = NO.
  ELSE
    ASSIGN lIsASbo = TRUE.

  IF cForeignFields > '':U THEN
  DO:
    cParent = getSdoLink(cObjectName).
     logNote("note":U, "The parent for SDO " + cObjectName + " with name : " + cSDOName + " is : " + cParent + " and foreign fields: " + cForeignFields ).  
    IF (cParent > "":U) THEN
    DO:
      DO j = 1 TO NUM-ENTRIES(cForeignFields):
          ASSIGN
            c1 = TRIM(ENTRY(j,cForeignFields))
            c1 = ENTRY(NUM-ENTRIES(c1,'.'),c1,'.')
            ENTRY(j,cForeignFields) = c1.
      END.
      ASSIGN cParentChildSupport = ' parent="':U + cParent + '" link="' + LC(cForeignFields) + '" '.

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
   /* {log "'Lone SDO=' + cSDOName + '->' + string(valid-handle(hSDO))"} */
  
    ASSIGN cSBOName = "":U.
    RUN outputSDO( INPUT cSDOName, 
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
        DO i2 = 1 TO NUM-ENTRIES(cForeignFields):
          ASSIGN 
            c1 = TRIM(ENTRY(i2,cForeignFields))
            c1 = ENTRY(NUM-ENTRIES(c1,'.'),c1,'.')
            ENTRY(i2,cForeignFields) = c1.
        END.

        ASSIGN hParentSDO = DYNAMIC-FUNCTION("getDataSource":U IN hSDO) NO-ERROR.
        IF ( VALID-HANDLE(hParentSDO) )THEN
          ASSIGN cParent = DYNAMIC-FUNCTION("getObjectName":U IN  hParentSDO).
          IF (NUM-ENTRIES(cParent, ".") > 1 ) THEN
            ASSIGN cFinalParent = cParent
                   cParent = ENTRY(2, cParent, ".").
          ELSE
            cFinalParent = cSBOName + ".":U + cParent.

        IF (cForeignFields > "":U AND cParent > "":U) THEN
          cParentChildSupport = ' parent="':U + cParent + '" link="' + LC(cForeignFields) + '" '.
        ELSE
          cParentChildSupport = "":U.
      END.

      IF ( NUM-ENTRIES(cSDOName, ".":U) > 1 ) THEN
        cFinalSDOName = cSDOName.
      ELSE
        cFinalSDOName = cSBOName + ".":U + cSDOName.

      RUN outputSDO( INPUT cSDOName, 
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
  logNote("note", "DS Req: " + gcRequestEvents). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynCombo Procedure 
PROCEDURE doDynCombo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Dynamics DynCombo
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* FieldName,DisplayField,FieldTooltip,{&htmlProps},{&htmlLabel},height-chars,width-chars,DescSubstitute,DisplayedField,keyField,queryTables,ComboFlag,FlagValue,KeyFormat,KeyDataType,FieldName,baseQueryString,HtmlStyle */ 

  DEFINE VARIABLE pcHtml                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispFields                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagOption                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSdoReal                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQueryString           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboParamName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboInfo                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFields              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQualifiedParentField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSDOName                   AS CHARACTER  NO-UNDO.

  ASSIGN timeCombo = timeCombo - ETIME.
  
  ASSIGN
    cDescSubstitute = {ry/inc/lval.i DescSubstitute}
    cDispFields     = {ry/inc/lval.i DisplayedField}
    cKeyField       = {ry/inc/lval.i keyField      }
    cQueryTables    = {ry/inc/lval.i queryTables   }
    cComboFlag      = {ry/inc/lval.i ComboFlag     }
    cFlagValue      = {ry/inc/lval.i FlagValue     }
    cFormat         = {ry/inc/lval.i KeyFormat     }
    cDataType       = {ry/inc/lval.i KeyDataType   }
    cFieldName       = {ry/inc/lval.i FieldName     }
    cBaseQueryString = {ry/inc/lval.i baseQueryString}
    cParentFields     = {ry/inc/lval.i ParentField}
    cParentFilterQuery = {ry/inc/lval.i ParentFilterQuery}
  .             
  
  /* We can't use the KeyFormat that's in the SDF as we rely on SDO to format the 
     values and the runtime SDO could have a different format (as the runtimne SDO can 
     be different than desgin time ) than the KeyFormat specified in the SDF. 
     So let us get the format from the SDO.
  */
  IF (gcSdoName = 'master':U) THEN
    ASSIGN cOverrideLogicalObjectName = getPassThruSDOInfo(1)
           cSdoReal = getPassThruSDOInfo(2)
           cSDOName = cSdoReal.
  ELSE
  DO:
    ASSIGN cSdoReal = (IF gcSboName > "":U THEN gcSboName + "." + gcSdoName ELSE gcSdoName)
           cOverrideLogicalObjectName = gcLogicalObjectName
           cSDOName = gcSdoName.
  END.
  
  IF cSdoReal > "":U AND cOverrideLogicalObjectName > "":U THEN
  DO:
    ASSIGN hSDO = getDataSourceHandle(cOverrideLogicalObjectName, cSdoReal,"":U) NO-ERROR.
    IF VALID-HANDLE(hSDO) THEN
      ASSIGN cFormat = DYNAMIC-FUNCTION("columnFormat":U in hSDO, ENTRY(NUM-ENTRIES(cKeyField,".":U), cKeyField, ".":U)) NO-ERROR.
    ASSIGN ERROR-STATUS:ERROR = NO.
  END.
        
  DO ix = 1 TO NUM-ENTRIES(cParentFields, ",":U):
    ASSIGN cParentField = ENTRY(ix, cParentFields, ",":U)
    cQualifiedParentField = cQualifiedParentField + "," + cSDOName + "." + ENTRY(NUM-ENTRIES(cParentField, ".":U), cParentField, ".":U).
  END.
  cQualifiedParentField = TRIM(cQualifiedParentField, ",":U).

  ASSIGN cComboParamName = gcLogicalObjectName + ".":u + gcID + ".combo":U
         cComboInfo      = (IF cKeyField > "":U THEN cKeyField ELSE "":U) + CHR(4)
                           + (IF cQueryTables > "":U THEN cQueryTables ELSE "":U) + CHR(4) 
                           + (IF cBaseQueryString > "":U THEN cBaseQueryString ELSE "":U) + CHR(4) 
                           + (IF cDispFields > "":U THEN cDispFields ELSE "":U) + CHR(4) 
                           + (IF cFieldName > "":U THEN cFieldName ELSE "":U) + CHR(4) 
                           + (IF cFormat > "":U THEN cFormat ELSE "":U) + CHR(4) 
                           + (IF cDataType > "":U THEN cDataType ELSE "":U) + CHR(4) 
                           + (IF cDescSubstitute > "":U THEN cDescSubstitute ELSE "":U) + CHR(4) 
                           + (IF cComboFlag > "":U THEN cComboFlag ELSE "":U) + CHR(4) 
                           + (IF cFlagValue > "":U THEN cFlagValue ELSE "":U) + CHR(4)
                           + (IF cParentFields > "":U THEN cParentFields ELSE "":U) + CHR(4)
                           + (IF cParentFilterQuery > "":U THEN cParentFilterQuery ELSE "":U)
  .

  /* Save this info for later retrieval */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                        cComboParamName, cComboInfo, NO).
  {log "'Combo:' +  cComboParamName + '=' + cComboInfo"}
  
  ASSIGN pcHtml    = htmlLabel("fieldLabel")
                + SUBSTITUTE(
                  '<select &1 size="1" comboparent="&5" style="&2;&3" &4>'
                  ,htmlProps('FieldTooltip',gcState)
                  ,SUBSTITUTE('top:&1px;left:&2px;height:&3px;width:&4px;'
                     ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow + giFieldOffsetTop - 2)
                     ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                     ,INTEGER(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
                     ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                     )
                  ,{ry/inc/lval.i HtmlStyle}
                  ,gcEvents
                  ,cQualifiedParentField
                  ).
  /* If the combo has more than 32K data, we can't store in a variable so output */
  {&OUT} pcHtml.
  
  /* run the query for the combo options only if the parent is blank 
  */
  IF (cParentFields = "":U OR cParentFilterQuery = "":U) THEN 
    RUN runCombo(INPUT gcLogicalObjectName, INPUT gcID, INPUT YES, INPUT "|":U).

  {&OUT} '</select>~n'.
  
  ASSIGN timeCombo = timeCombo + ETIME.
  RETURN '':U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynFrame Procedure 
PROCEDURE doDynFrame PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',
    '{&htmlLayout}').
  setLayout(false).
  {&OUT} 
    '<div' htmlLayout('dynframe') 
    ' uplink="' getSdoLink(ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE) '"'
    ' resize="on" objtype="dynframe">~n</div></div>' SKIP.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynLookup Procedure 
PROCEDURE doDynLookup PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Dynamic Lookup (SmartDataField)
  Parameters:  <none>
  Notes:       ***** SSB ****
               The <local> field implementation in this procedure is a 
               temperory work-around and needs to be addressed.
               ***** SSB ****

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* FieldName,DisplayField,FieldToolTip,{&htmlProps},FieldLabel,{&htmlLabel},DisplayedField,ViewerLinkedFields,ViewerLinkedWidgets,KeyField,ParentField,LogicalObjectName,LocalField,width-chars,HtmlStyle */ 

/*

 Stored screen information on lookups:
 ========================= 
 It will store the list of lookup instances within the SDO.
  1. [container].[sdo].lookup
    
 It will store the information necessary to create the context for each instance.
  2. [container].[LookupInstanceName].lookupObj

 
 Executing a lookup:
 ===================
 The lookup will use the LogicalName for initiating an SDO context.
 In this moment the Container name is set to the Lookup Logical Object name.
 This prevents other SDOs within the real container to be initialized. 
  3. [LookupLogicalName].lookup.context
 A) gcLogicalObjectName = [LookupLogicalName]
 B) gcLookupObjectName  = same.

 ProcessLookup() procedure will configure the SDO named context.
 The sdo named lookup will be been initialized with the context stored in (2)


Suggestion: 
 gcLookup  = [container].[sdo].[LookupInstanceName]
 (2) [container].[LookupInstanceName].lookupObj

2. get/setContext recognize the lookup name

*/

  DEFINE VARIABLE pcHtml          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cID             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInput          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedWidgets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedWidget   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupObj      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStyle          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEnabled        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIsLocalField   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cutil           AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cQualifiedParentField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER NO-UNDO.
  

  ASSIGN
    cDisplayedField = LC({ry/inc/lval.i DisplayedField})
    cLinkedFields   = {ry/inc/lval.i ViewerLinkedFields}
    cLinkedWidgets  = {ry/inc/lval.i ViewerLinkedWidgets}
    cKeyField       = {ry/inc/lval.i KeyField}
    cParentField    = {ry/inc/lval.i ParentField}
    cLookupObj      = ENTRY(NUM-ENTRIES(gcId,'.'),gcId,'.')
    cLookupName     = LC({ry/inc/lval.i LogicalObjectName})
    cDField         = cDisplayedField
    .
  ASSIGN lIsLocalField = LOGICAL({ry/inc/lval.i LocalField}).

  DO ix = 1 TO NUM-ENTRIES(cParentField, ",":U):
    cQualifiedParentField = cQualifiedParentField + "," + gcSdoName + "." + ENTRY(ix, cParentField, ",":U).
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
  {log "'cLinkedFields: ' + cLinkedFields + '/' + cLinkedWidgets"}

  IF cLinkedFields <> "" AND cLinkedFields <> ? THEN 
  DO ix = 1 TO NUM-ENTRIES(cLinkedFields):
    ASSIGN
      cLinkedField  = ENTRY(ix, cLinkedFields)
      cLinkedWidget = ENTRY(ix, cLinkedWidgets)
      cDField       = cDField + ',' + cLinkedField.
        
    IF NOT CAN-FIND(FIRST ttLinkedField WHERE
      ttLinkedField.cSDO    = gcSDOName AND 
      ttLinkedfield.cViewer = gcViewerName AND
      ttLinkedField.cWidget = cLinkedWidget) THEN 
    DO:
      CREATE ttLinkedField.
      ASSIGN
        ttLinkedField.cSDO     = gcSDOName
        ttLinkedField.cViewer  = gcViewerName
        ttLinkedField.cLookup  = cLookupObj
        ttLinkedField.cWidget  = cLinkedWidget
        ttLinkedField.cField   = cLinkedField
        ttLinkedField.lIsLocal = lIsLocalField
        .
    END.
  END.

  IF (gcSdoName = 'master':U) THEN
  DO:
    ASSIGN cOverrideLogicalObjectName = getPassThruSDOInfo(1).
    IF ( cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = gcLogicalObjectName.
  END.
  ELSE
    cOverrideLogicalObjectName = gcLogicalObjectName.
    
  /* If the object is based off of a datafield then there would be sdo.fieldname
     else it would just contain the field name 
  */
  IF (NUM-ENTRIES(gcId, ".":U) > 1) THEN
    ASSIGN gcId   = gcSdoName + '._' + cLookupObj
           cutil = gcId.
  ELSE
    ASSIGN cutil = "wdo." + cLookupObj.

  ASSIGN 
    cType  = "text" /* (IF plDisplay THEN "text":U ELSE "hidden":U) */
    pcHtml = htmlLabel("fieldLabel") 
           + SUBSTITUTE('<input &1 lookup="&2" dfield="&3" util="&5.lookup" utilimg="../img/find.gif" utiltip="Lookup &3" lookupparent="&4"'
             ,htmlProps('FieldTooltip',REPLACE(gcState,'disabled','readonly'))
             ,cLookupObj + ".":U + LC(cOverrideLogicalObjectName)
             ,LC(cDField)
             ,LC(cQualifiedParentField)
             ,cutil)
           + SUBSTITUTE(' style="top:&1px;left:&2px;width:&3px;&4" &5 />'
             ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
             ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
             /* Reduce size to allow for lookup button to be inserted by js */
             ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn) - 20
             ,{ry/inc/lval.i HtmlStyle}
             ,maxlength({ry/inc/lval.i DisplayFormat},{ry/inc/lval.i DisplayDataType}) + gcEvents                        
             )
           + SUBSTITUTE('<span name="&1" id="&1" title="Lookup &2" style="position:absolute;top:&3px;left:&4px;" &5><img name="&6" src="../img/find.gif" tabindex="-1" /></span>'
             ,gcId
             ,LC(cDField)
             ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
             ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn + INT({ry/inc/lval.i width-chars}) * giPixelsPerColumn) - 20
             ,IF gcState > '' THEN 'class="disable"' ELSE 'class="enable"'
             ,REPLACE(gcId,'._','.')
             ).
    
  {log "'Lookup ' + gcId + '/' + gcsdoname"} 
  /* Lookup info needs to be saved even if this is a local field */
  /* Check if this SDO is a SDO on the parent page (pass-thru scenario). If so 
     then the lookup info needs to be set-up in the parent and the 
     SDO definition needs to be sent to the Client again */
  
  saveDynLookupInfo(cOverrideLogicalObjectName).

  RETURN pcHtml.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynTree Procedure 
PROCEDURE doDynTree PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  {log "'**** doTreeView:' + gcLogicalObjectName"} 
  {&OUT} 
    '~n<div class="layout" pos="21">'
    '~n<div class="dyntree" min="100,150" style="" id="dyntree" name="dyntree" resize="resizex" objtype="dyntree" autosort="' gcTreeAutoSort '">'
    '~n</div></div>'
    '~n<div class="layout" pos="22">'
    '~n<div class="treeframe" min="350,150" style="" id="treeframe" name="treeframe" resize="resize" objtype="treeframe">'
    '~n</div></div>~n'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doDynTreeSdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDynTreeSdo Procedure 
PROCEDURE doDynTreeSdo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSdoName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoObject   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCtxname     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExtract     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE c1           AS CHARACTER  NO-UNDO.

  
  EMPTY TEMP-TABLE ttNode.
  RUN ry/app/rytrenodep.p(gcTreeRootNode,?,OUTPUT TABLE ttNode).
   
  FOR EACH ttNode BY ttNode.node_code:
 
    /* Decode SDO name and set it correctly in the temp-table */
    IF ttNode.data_source_type = "sdo" THEN DO:
      ASSIGN 
        cSdoObject         = ENTRY(NUM-ENTRIES(ttNode.data_source,"/"),ttNode.data_source,"/")
        cSdoName           = LC(ENTRY(1,cSdoObject,'.'))
        ttNode.data_source = cSdoName.    /* For output data */
    END.

    /*  Root menu gets resolved immediately */
    IF ttNode.data_source_type = "mnu" AND ttNode.node_code = gcTreeRootNode THEN DO: 
      RUN getTreeData("wbo.-1." + ttNode.data_source + ".mnu.dyntree").
    END.
    ELSE ASSIGN c1 = c1 + (IF c1 > '' THEN '~n,"' ELSE '~n"') + getTreeString(BUFFER ttNode). 

    IF ttNode.data_source_type = "prg" AND ttNode.node_code = gcTreeRootNode THEN DO: 
      lExtract = TRUE. 
    END.

    /*  Create the SDO wrapper for data to Client */
    IF ttNode.data_source_type = "sdo" AND NOT CAN-DO(cSdoList,cSdoName) THEN DO: 
      lognote('','SDO:' + cSdoName + "=" + cSdoObject). 

      /* SDOs appearing twice in treeview should still only have one instance */        
      ASSIGN cSdoList = cSdoList + (IF cSdoList > "" THEN "," ELSE "") + cSdoName.
      RUN startDataObject IN gshRepositoryManager (INPUT cSdoObject, OUTPUT hSDO).
      RUN outputSDO( cSdoName, hSDO
                   ,INPUT "true"  /* AutoCommit */ 
                   ,INPUT ""      /* UpdateTarget */
                   ,INPUT ""      /* Export */ 
                   ,INPUT ""      /* Parent-child */ 
                   ,INPUT "").    /* SBO-name */
      saveDSPath(cSdoName, hSDO:file-name).               
      saveDSProperty(gcLogicalObjectName, cSDOName, 'RowsToBatch':U, gcTreeRowsToBatch ).
      saveDSProperty(gcLogicalObjectName, cSDOName, 'DestroyStateless':U, DYNAMIC-FUNCTION('getDestroyStateless':U IN hSDO) ).
      saveDSProperty(gcLogicalObjectName, cSDOName, 'FillBatchOnRepos':U, DYNAMIC-FUNCTION('getFillBatchOnRepos':U IN hSDO) ).
      saveDSProperty(gcLogicalObjectName, cSDOName, 'DataDelimiter':U, DYNAMIC-FUNCTION('getDataDelimiter':U IN hSDO)).
/*
      saveDSProperty(gcLogicalObjectName, cSDOName, 'AutoCommit':U, cCommit).
*/   
      setDataSourceHandle(gcLogicalObjectName, cSdoName, ?, hSDO).
      cContext = DYNAMIC-FUNCTION("obtainContextForClient":U IN hSDO).
      ASSIGN 
        cCtxname = gcLogicalObjectName + '.' + cSdoName + '.context'
        cContext = REPLACE(cContext, CHR(3), '#':U)
        cContext = REPLACE(cContext, CHR(4), '$':U).
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, cCtxname, cContext, NO).

      lognote('','SetCxt:' + cCtxname + '=' + cContext). 
      /* only start root DS if there's no filter viewer as in gcViewerName */ 
      IF ttNode.node_code = gcTreeRootNode AND gcViewerName = "" THEN DO:  
        IF ttNode.parent_node_filter > '' THEN DO:
          lognote('',cSdoName + '=' + ttNode.parent_node_filter).
          set-user-field('_' + cSdoName + '._filter',ttNode.parent_node_filter).
          gcRequestEvents = gcRequestEvents + '|':U + cSdoName + '.filter':U.
        END.
        ELSE gcRequestEvents = gcRequestEvents + '|':U + cSdoName + '.first':U.
      END.
      ELSE gcJsRun = gcJsRun + "~napp._" + cSdoName + ".load([],'|',0);".                
    END.    
  END.    
  ASSIGN gcJsRun = gcJsRun 
                 + '~napp.dyntree.structure([' + c1 + ']);'
                 + '~napp.dyntree.initTree("' + LC(gcTreeRootNode) + '");'.

  /* Rootnode extract program will need to be processed last because it will use ttNode temptable */
  IF lExtract THEN DO:
    RUN getTreeData("wbo.-1." + LC(gcTreeRootNode) + ".prg.dyntree").
    ASSIGN gcJsRun = gcJsRun 
           + '~napp.dyntree.initialize();'.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEditor Procedure 
PROCEDURE doEditor PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for EDITOR 
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* ToolTip,{&htmlProps},{&htmlLabel},height-chars,width-chars,HtmlStyle,word-wrap,InitialValue */ 

  RETURN htmlLabel("label") 
           +  SUBSTITUTE('<textarea &1 style="&2;&3" &4&5 >&6</textarea>'
             ,htmlProps('ToolTip',REPLACE(gcState,'disabled','readonly'))
             ,SUBSTITUTE('top:&1px;left:&2px;height:&3px;width:&4px;'
                 ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow + giFieldOffsetTop - 2)
                 ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                 ,INTEGER(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
                 ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                 )
             ,{ry/inc/lval.i HtmlStyle}
             ,gcEvents
             ,IF LOGICAL({ry/inc/lval.i word-wrap}) THEN ' wrap="soft"':U ELSE ' wrap="off"'
             ,HTML-ENCODE({ry/inc/lval.i InitialValue})
      ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doFillin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doFillin Procedure 
PROCEDURE doFillin PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for FILL-IN
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cPopup      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lViewAsText AS LOGICAL    NO-UNDO.

  /* ToolTip,{&htmlProps},label,{&htmlLabel},height-chars,width-chars,ShowPopup,DATA-TYPE,HtmlStyle,InitialValue */ 
  
  /** Special treatment of view-as-text fill-ins **/
  lViewAsText = {ry/inc/lval.i VisualizationType} = 'Text'.
  IF lViewAsText THEN gcState = ' disable="true" disabled="true"':U. 

  /* Check for popup utilities calendar/calculator */
  IF LOGICAL({ry/inc/lval.i ShowPopup}) AND glViewerShowPopup THEN 
    CASE {ry/inc/lval.i DATA-TYPE}:
      WHEN "date" THEN 
        cPopup = 'tool="calendar"   util="util.../dhtml/rycalendar.htm"   /><span name="&1" id="&1" title="Calendar tool"   style="position:absolute;top:&2px;left:&3px;" &4><img src="../img/calendar.gif" tabindex="-1" /></span>'.
      WHEN "integer" OR WHEN "decimal" THEN 
        cPopup = 'tool="calculator" util="util.../dhtml/rycalculator.htm" /><span name="&1" id="&1" title="Calculator tool" style="position:absolute;top:&2px;left:&3px;" &4><img src="../img/calculator.gif" tabindex="-1" /></span>'.
    END CASE.
    
  IF {ry/inc/lval.i DATA-TYPE} = "file" THEN
        cPopup = 'tool="upload" util="util.../dhtml/ryupload.icf" readonly="true" /><span name="&1" id="&1" title="File Attachement" style="position:absolute;top:&2px;left:&3px;" &4><img src="../img/itemdynamic.gif" tabindex="-1" /></span>'.

  RETURN htmlLabel("label":U) 
           + SUBSTITUTE('<input &1 type="text" style="&2;&3" &4 value="&5" '
             ,htmlProps('Tooltip',REPLACE(gcState,'disabled','readonly'))
             ,SUBSTITUTE('top:&1px;left:&2px;height:&3px;width:&4px;'
                     ,INTEGER((DEC({ry/inc/lval.i row}) + (IF lViewAsText THEN -.19 ELSE 0)) * giPixelsPerRow + giFieldOffsetTop - 2)
                     ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                     ,INTEGER((DEC({ry/inc/lval.i height-chars}) + (IF lViewAsText THEN .38 ELSE 0)) * giPixelsPerRow)
                     ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                     )
             ,{ry/inc/lval.i HtmlStyle}                 
             ,maxlength({ry/inc/lval.i FORMAT},{ry/inc/lval.i DATA-TYPE}) + gcEvents                        
             ,(IF NUM-ENTRIES(gcId,'.') = 2 THEN '' ELSE {ry/inc/lval.i InitialValue})              
                 )                            
      + IF cPopup > '' THEN SUBSTITUTE( cPopup
             ,gcID  
             ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
             ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn + DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
             ,IF gcState > '' THEN 'class="disable"' ELSE 'class="enable"') ELSE '/>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doFolder Procedure 
PROCEDURE doFolder PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Do Folder Tabs
  Parameters:  <none>
  Notes: 

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTabLabels  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTabEnabled AS CHARACTER  NO-UNDO.

  RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
    'FolderLabels,TabEnabled').
  setLayout(false).
  ASSIGN
    cTabLabels  = {ry/inc/lval.i FolderLabels}
    cTabEnabled = {ry/inc/lval.i TabEnabled  }
    cVisType    = gcFolderType NO-ERROR.

  /* logNote('note','Folder=' + cVisType). */
  /* Default to tabs */
  ASSIGN cVisType = IF (cVisType <> ? AND cVisType BEGINS 'wizard':U) 
                    THEN 'wizard':U ELSE 'folder':U.
 
  {&OUT} 
    '<div id="':U + cVisType + '" name="':U + cVisType + '" tabs="':U + REPLACE(cTabLabels, '&':U, '':U) + 
      '" enabled="':U + cTabEnabled + '" objtype="' cVisType '" height="40">~n</div></div>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doImage Procedure 
PROCEDURE doImage PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for IMAGE
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* HtmlClass,IMAGE-FILE,ToolTip,row,column,HtmlStyle */ 

  RETURN REPLACE(
        SUBSTITUTE('<img class="&2" id="&1" name="&1" src="&3" alt="&4" &5'
         ,gcID
         ,htmlClass()
         ,getImagePath({ry/inc/lval.i IMAGE-FILE})
         ,{ry/inc/lval.i ToolTip}
         ,gcState
        )
      + SUBSTITUTE(' style="top:&1px;left:&2px;&3" &4 />~n':U
         ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
         ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
         ,{ry/inc/lval.i HtmlStyle}
         ,gcEvents)
    ,'~\':U,'/':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doRadioSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doRadioSet Procedure 
PROCEDURE doRadioSet PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for RADIO-SET 
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* HtmlClass,Order,InitialValue,row,column,ToolTip,RADIO-BUTTONS,DELIMITER,Horizontal,height-chars,width-chars */ 

  DEFINE VARIABLE pcHtml      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iItems      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iOrder      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix          AS INTEGER    NO-UNDO INIT 0. /* horizontal position */
  DEFINE VARIABLE iy          AS INTEGER    NO-UNDO INIT 0. /* vertical position */
  DEFINE VARIABLE idx         AS INTEGER    NO-UNDO INIT 0. /* horizontal change */
  DEFINE VARIABLE idy         AS INTEGER    NO-UNDO INIT 0. /* vertical change */

  ASSIGN
    iOrder      = tabIndex(INT({ry/inc/lval.i Order}))
    cValue      = {ry/inc/lval.i InitialValue}
    pcHtml      = htmlLabel("label":U)
                + SUBSTITUTE(
                  '<div class="&3" style="top:&1px;left:&2px;" title="&4">~n':U
                  ,INT(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
                  ,INT(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)  - 5
                  ,htmlClass()
                  ,{ry/inc/lval.i ToolTip}
                  )
    c1          = {ry/inc/lval.i RADIO-BUTTONS}
    iItems      = NUM-ENTRIES(c1) / 2
    cDelimiter  = {ry/inc/lval.i DELIMITER}.
  IF LOGICAL({ry/inc/lval.i Horizontal}) THEN ASSIGN
       iy  = INT(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow / 2) - 9    
       idx = INT(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn / iItems).
  ELSE ASSIGN
       idy = INT(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow / iItems).

  /* Example value of RADIO-BUTTONS attr value (between single quotes): 
     '"String 1", "1", "String 2", "2", "String 3", "3"' */
  DO i1 = 1 TO NUM-ENTRIES(c1,cDelimiter) BY 2:
    ASSIGN
            cLabel  = SUBSTITUTE(
                '  <label class="radio" style="top:&1px;left:&2px">'
                ,iy
                ,ix
                )
      c2      = TRIM(REPLACE(ENTRY(i1 + 1, c1, cDelimiter), '"', ''))
      pcHTML  = pcHTML + cLabel 
              + SUBSTITUTE(
                '<input class="radio" type="radio" id="&2" name="&2" tabindex="&6" value="&3" &4 &5 />&1</label>~n'
                ,html-encode(TRIM(REPLACE(ENTRY(i1, c1, cDelimiter), '"', '')))
                ,gcID
                ,LC(c2)
                ,gcEvents + (IF cValue = c2 THEN 'checked="true" ' ELSE '')
                ,gcState
                ,iOrder
                )
      ix = ix + idx
      iy = iy + idy.

  END.
  RETURN pcHtml + '</div>':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doRectangle Procedure 
PROCEDURE doRectangle PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for RECTANGLE
  Parameters:  <none>
  Notes:       Rectangles should be implemented as <FIELDSET> tags, but these
               conflict with the FIELDSET used to display a viewer.

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/


  /* HtmlClass,row,column,height-chars,width-chars,HtmlStyle */ 

  RETURN SUBSTITUTE('<fieldset style="top:&2px;left:&3px;height:&4px;width:&5px;&6"></fieldset>'
           ,htmlClass() /* ignored */
           ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
           ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
           ,INTEGER(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
           ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
           ,{ry/inc/lval.i HtmlStyle}
           ).
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doSmartLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doSmartLinks Procedure 
PROCEDURE doSmartLinks PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c1          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c2          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c3          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLinks      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjects    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQ          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i2          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cClassName  AS CHARACTER  NO-UNDO.    
    
    DEFINE VARIABLE cDynamicSDORequiredProperties AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDynamicSDOParam              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDynamicSDOValue              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDynamicSDOInfo               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRunAttribute                 AS CHARACTER  NO-UNDO.    
    
    DEFINE BUFFER bLink FOR ttLink.
    DEFINE BUFFER newLink FOR ttLink.
    DEFINE BUFFER buffLink FOR ttLink.

    glMasterLink = FALSE.
    cWhere  = "FOR EACH " + ghObjectBuffer:NAME + 
              " WHERE " + ghObjectBuffer:NAME + ".ContainerInstanceId = ":U + gcMasterObjectId + 
              " AND LOOKUP(" + ghObjectBuffer:NAME + ".ClassName, '" + gcDataClasses + "') > 0":U.
    /* Make sure nothing available - stop potential infinate loop below if query fails. */
    ghObjectBuffer:BUFFER-RELEASE() NO-ERROR. 
    CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
    hQ:ADD-BUFFER(ghObjectBuffer).
    glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
    IF NOT glOk OR ERROR-STATUS:ERROR THEN
    DO:
      {log "'** ERROR preparing query for SDO objects, where: ':U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)"}
      RUN setMessage  (INPUT "** ERROR preparing query for SDO objects, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
      RETURN.
    END.
    hQ:QUERY-OPEN().
    hQ:GET-FIRST().
    DO WHILE ghObjectBuffer:AVAILABLE:

      RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
                 'RenderingProcedure,PhysicalObjectName,LogicalObjectName,RequiredProperties,RunAttribute').
    
      IF i1 > 1000 THEN LEAVE.
      CREATE ttLink.
      ASSIGN
        i1 = i1 + 1
        ttFrom = ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE
        ttTo   = ttFrom
        ttType = 'SDO'
        ttIO   = 'auto'.
      ASSIGN
        ttSDO  = jsTrim(ENTRY(1,STRING(ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE),'.'))
        .
      IF ttSDO > '' THEN
      DO:
        ASSIGN cClassName = ghObjectBuffer:BUFFER-FIELD('ClassName'):BUFFER-VALUE NO-ERROR.
        
        saveDSProperty(gcLogicalObjectName, 
                        ttLink.ttSDO, 
                        'isSBO':U, 
                        STRING(CAN-DO(gcSBOClasses,cClassName))).
        saveDSPath(ttLink.ttSDO,{ry/inc/lval.i RenderingProcedure} + {ry/inc/lval.i PhysicalObjectName} ).
        
        /* We need to support the case where there are "."'s in the logical name -
           So we add a mapping if the Objectname is NOT the same as first entry */
        
        IF {ry/inc/lval.i LogicalObjectName} <> ttSDO THEN
        DO:
          saveDSProperty(gcLogicalObjectName, 
                        ttLink.ttSDO, 
                        'ObjectName':U, 
                        {ry/inc/lval.i LogicalObjectName}).
        END.
        
        /* Check if this is a Dynamic SDO. If so, build the context for the SDO parameters */
        IF LOOKUP(cClassName, gcDynSDOClasses) <> 0 THEN
        DO:
          ASSIGN cDynamicSDORequiredProperties = {ry/inc/lval.i RequiredProperties}
                 cRunAttribute = {ry/inc/lval.i RunAttribute}.
                 
          RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
            cDynamicSDORequiredProperties).

          ASSIGN cDynamicSDOInfo  = "".
          DO i2 = 1 TO NUM-ENTRIES(cDynamicSDORequiredProperties, ",":U):
            cDynamicSDOParam = ENTRY(i2, cDynamicSDORequiredProperties, ",":U).
            cDynamicSDOValue = ENTRY(LOOKUP(cDynamicSDOParam,cAttNames) + 1,CHR(1) + cAttValues,CHR(1)).
            IF ( cDynamicSDOValue = ? ) THEN
              cDynamicSDOValue = "":U.
            cDynamicSDOInfo = cDynamicSDOInfo + '#':U + TRIM(cDynamicSDOParam) + '$':U + cDynamicSDOValue.
          END.
          cDynamicSDOInfo = TRIM(cDynamicSDOInfo, '#':U).
          
          /* Append the runAttribute */
          IF cRunAttribute > "":U THEN
            cDynamicSDOInfo = cDynamicSDOInfo + '#RunAttribute$':U + cRunAttribute.
          
          {log "'DynSDO info for SDO: ' + ttSDO + 'is: ' + cDynamicSDOInfo"}

          /* Save the Dynamic SDO Info */
          saveDynamicDSInfo(gcLogicalObjectName, ttSDO, cDynamicSDOInfo).
        END.
      END.
      hQ:GET-NEXT().
    END.

    cWhere = "FOR EACH " + ghLinkBuffer:NAME.
    
    /* Make sure nothing available - stop potential infinate loop below if query fails. */
    ghLinkBuffer:BUFFER-RELEASE() NO-ERROR. 
    CREATE QUERY hQ IN WIDGET-POOL "B2BUIM":U.
    hQ:ADD-BUFFER(ghLinkBuffer).
    glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
    IF NOT glOk OR ERROR-STATUS:ERROR THEN
    DO:
      {log "'** ERROR preparing query for smartlinks, where: ':U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)"}
      RUN setMessage  (INPUT "** ERROR preparing query for smartlinks, where: ":U + cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
      RETURN.
    END.
    hQ:QUERY-OPEN().
    hQ:GET-FIRST().
    DO WHILE ghLinkBuffer:AVAILABLE:
      IF i1 > 1000 THEN LEAVE.
      c1 = ghLinkBuffer:BUFFER-FIELD("LinkName":U):BUFFER-VALUE.
      IF CAN-DO("Commit,ContainerToolbar,Data,Filter,GroupAssign,Navigation,PrimarySdo,TableIO,Toolbar,Update,", c1) THEN
      DO:
        CREATE ttLink.
        ASSIGN
          i1            = i1 + 1
          ttLink.ttFrom = ghLinkBuffer:BUFFER-FIELD("SourceInstanceName":U):BUFFER-VALUE
          ttLink.ttFrom = IF ttLink.ttFrom = "THIS-OBJECT" THEN "master" ELSE ttLink.ttFrom
          ttLink.ttTo   = ghLinkBuffer:BUFFER-FIELD("TargetInstanceName":U):BUFFER-VALUE
          ttLink.ttTo   = IF ttLink.ttTo   = "THIS-OBJECT" THEN "master" ELSE ttLink.ttTo
          ttLink.ttType = c1
          .
      END.
      hQ:GET-NEXT().
    END.

/*
     FOR EACH ttLink:                                                                                                                                
       {log "'OLD :' + ttLink.ttFrom + '->' + ttLink.ttTo + '=' + ttLink.ttType + '/' + ttLink.ttSDO + '/' + ttLink.ttIO"}  
     END.                                                                                                                                            
*/
    
    gcMasterLink = 'master'.
    FIND FIRST ttLink WHERE ttLink.ttType = 'PrimarySDO' NO-ERROR.
    IF AVAILABLE ttLink THEN 
    DO:
      IF ttLink.ttFrom = "" THEN
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
    ASSIGN ttLink.ttFrom = ''
           ttLink.ttTo   = ''
           ttLink.ttType = 'SDO'
           ttLink.ttSDO  = gcMasterLink.

    /** Determine if there is data linked from container **/
    IF NOT glMasterLink THEN 
        glMasterLink = CAN-FIND(FIRST ttLink WHERE ttLink.ttFrom = '' AND ttLink.ttType = 'Data').
   
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
    
    /* IF there is a TableIO link but no update link then remove the tableio link too */
    FOR EACH ttLink WHERE ttLink.ttSDO = '':U AND ttLink.ttType = 'TableIO':
      FIND FIRST bLink WHERE blink.ttFrom = ttLink.ttTo AND bLink.ttType = 'Update' NO-ERROR.
      IF NOT AVAILABLE bLink THEN
        DELETE ttLink.
    END.
    
    /* From Object to SDO or vice versa */
    FOR EACH ttLink WHERE ttLink.ttSDO = '' :
        FIND FIRST bLink WHERE (bLink.ttFrom = ttLink.ttTo
                            OR bLink.ttFrom = ttLink.ttFrom)
                           AND blink.ttFrom > ''
                           AND bLink.ttType = 'SDO' NO-ERROR.
        IF AVAILABLE bLink THEN ttLink.ttSDO = bLink.ttSDO.
    END.

    /* From Object to SDO-linked object (only when not already linked) */
    FOR EACH ttLink WHERE ttLink.ttSDO = '':
        FIND FIRST bLink WHERE (bLink.ttFrom = ttLink.ttTo
                             OR bLink.ttFrom = ttLink.ttFrom)
                           AND bLink.ttSDO > ''
                           AND bLink.ttFrom <> 'master'
                           AND blink.ttFrom > ''
                           AND bLink.ttType = 'data' NO-ERROR.
        IF NOT AVAILABLE bLink THEN
        FIND FIRST bLink WHERE (bLink.ttTo = ttLink.ttTo
                             OR bLink.ttTo = ttLink.ttFrom)
                           AND bLink.ttSDO > ''
                           AND bLink.ttTo <> 'master'
                           AND blink.ttTo  > ''
                           AND bLink.ttType = 'data' NO-ERROR.
        IF AVAILABLE bLink THEN ASSIGN
            ttLink.ttSDO = bLink.ttSDO.
    END.
/*
      FOR EACH ttLink:                                                                                                                                
        {log "'LINK:' + ttLink.ttFrom + '->' + ttLink.ttTo + '=' + ttLink.ttType + '/' + ttLink.ttSDO + '/' + ttLink.ttIO"}  
      END.                                                                                                                                            
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doText Procedure 
PROCEDURE doText PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for TEXT
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/
  /* ToolTip,{&htmlProps},row,column,height-chars,width-chars,HtmlStyle,INITIALVALUE */ 

  /* If the Text field is a linked field  then we want to do the fillin */
  FIND FIRST ttLinkedField 
    WHERE ttLinkedField.cSDO    = gcSDOName AND
          ttLinkedField.cViewer = gcViewerName AND
          ttLinkedField.cWidget = {ry/inc/lval.i NAME} NO-ERROR.
          
  IF {ry/inc/lval.i TableName} > '' OR 
     AVAILABLE ttLinkedField THEN
  DO:  
    /* Redirect view-as-text data fill-ins */
    RUN doFillIn.  
    RETURN RETURN-VALUE.
  END.
  ASSIGN ERROR-STATUS:ERROR = NO.
  
  RETURN SUBSTITUTE('<label &1 style="&2;&3" &4/>&5</label>'
             ,htmlProps('Tooltip',"")   /* "" = Always enabled */
             ,SUBSTITUTE('top:&1px;left:&2px;height:&3px;width:&4px;'
                     ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow + giFieldOffsetTop - 2)
                     ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                     ,INTEGER(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
                     ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                     )
             ,{ry/inc/lval.i HtmlStyle}
             ,gcEvents
             ,{ry/inc/lval.i INITIALVALUE}
                ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToggleBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToggleBox Procedure 
PROCEDURE doToggleBox PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for TOGGLE-BOX 
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* Tooltip,{&htmlProps},Label,row,column,HtmlStyle,CHECKED */ 

  RETURN SUBSTITUTE('<label for="&4" style="top:&2px;left:&3px;">&&#160;&1</label>~n':U
         ,html-encode(TRIM({ry/inc/lval.i Label}))
         ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
         ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn) + 15
         ,gcID
         )
       + SUBSTITUTE('<input &1 type="checkbox" style="top:&2px;left:&3px;&4" &5&6 />'
         ,htmlProps('Tooltip',gcState)
         ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop - 2
         ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
         ,{ry/inc/lval.i HtmlStyle}
         ,gcEvents
         ,IF LOGICAL({ry/inc/lval.i CHECKED}) THEN 'checked="checked"':U ELSE ''
         ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToolBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToolBand Procedure 
PROCEDURE doToolBand PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cBand            AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER iLevel           AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER cType            AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcToolbarInstance   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcHiddenActions  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcTarget         AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER plDoToolbar      AS LOGICAL    NO-UNDO.
    DEFINE INPUT PARAMETER cWdo             AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cAction            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTarget            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCaption           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotkey            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotCode           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHotkey2           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cImage             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c1                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSpacer            AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dAttrRecId         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cNavigationTarget  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cActionGroups      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDSIsASBO          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lDSIsASBO          AS LOGICAL    NO-UNDO.
    
    DEFINE BUFFER bBand       FOR ttBand.
    DEFINE BUFFER bAction     FOR ttAction.
    DEFINE BUFFER bBandAction FOR ttBandAction.

    /* Getting Nav targer not be in this recursive proc - 
       But since the API signature can not be changed it is in this IP
    */

    ASSIGN 
        lSpacer           = FALSE
        cNavigationTarget = {ry/inc/lval.i NavigationTargetName}
        cActionGroups     = {ry/inc/lval.i ActionGroups} NO-ERROR.
    FIND FIRST bBand WHERE bBand.band = cBand.
    
    /* {log "'BAND:' + cBand + '=' + bBand.BandType"} */
    FOR EACH bBandAction WHERE
             bBandAction.band = cBand
       ,EACH bAction WHERE
             bAction.action = bBandAction.action
        BY bBandAction.sequence:

        IF bAction.Action = 'DynamicMenu' AND bAction.Category = 'SubMenu' THEN DO:
            ASSIGN
              gcMenues = gcMenues + doMenu(gcMenu,pcTarget,cWdo)
              gcMenu = ''.
            FOR EACH ttObjectband:
                FIND FIRST bBand WHERE bBand.band = ttObjectBand.band.
                FIND FIRST ttAction WHERE ttAction.Action = bBand.BandLabelAction.
                cCaption = ttAction.Caption.
                gcBand = gcBand + ";" + string(iLevel) + "|g." + ttAction.Action + "|" + cCaption + "||".
                RUN doToolBand(ttObjectband.Band,iLevel + 1,"band",pcToolbarInstance,pcHiddenActions,pcTarget,plDoToolbar,cWdo).
            END.
            NEXT.
        END.

        /* {log "'Action:' + bAction.action + '/' + bAction.category + '/' + bBand.BandType + '/' + string(plDoToolbar)"} */
        
        IF (pcHiddenActions > "":U AND CAN-DO(pcHiddenActions,bBandAction.Action)) OR
        /* If Hidden Action or not in ActionGroups then ignore it */
           (bAction.TYPE = "publish" AND bAction.Category > "" AND 
            NOT CAN-DO(cActionGroups + ",toolbar,submenu,",bAction.Category)) OR
        /* If the menu security is set then take away the menu */
           (bAction.Disabled)
            THEN NEXT. 

        /* If the token is secured, then ignore it */
        IF (gcSecuredTokens > "":U) THEN DO:
          IF ( CAN-DO(gcSecuredTokens,bBandAction.Action) OR 
             CAN-DO(gcSecuredTokens,bAction.SecurityToken)) THEN NEXT.
        END.
        


        /* Show Hotkey as '(Ctrl+X)' (where X is the hotkey) appended to
           end of tooltip - rather than menu method of underlining hotkey */

        ASSIGN
            cHotkey  = bAction.ACCELERATOR
            cHotkey2 = ''
            cCaption = bAction.Caption
            cAction  = LC(bBandAction.action)
            cImage   = baction.IMAGE
            cImage   = ENTRY(1 + LOOKUP(cImage,'ry/img/affunnel.gif,ry/img/filter.gif,ry/img/afstatus.gif')
                                      ,cImage + ',ry/img/filteru.gif,ry/img/filteru.gif,ry/img/statusu.gif')
            cImage   = getImagePath(cImage)
            .

        /* Fix changing of command names in order to deal with javascript problems */
        IF CAN-DO('delete2,delete',cAction) THEN ASSIGN cAction = 
           ENTRY(LOOKUP(cAction,'delete2,delete'),'del2,del').

        /* Adjust the browse toolbar */ 
        IF CAN-DO('add2,del2,copy2,modify,view,filter2,export,find',cAction) THEN ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'view,modify,filter2')
                     ,cAction + ',view2,update2,filter')
            bAction.link = IF bAction.link = '' THEN 'toolbar-target' ELSE bAction.link.
        IF cAction BEGINS 'folder' THEN cAction = SUBSTRING(cAction,7).
        /* Find the target SDO for that action */
        
        cTarget = 'nolink'.   
        /* Check for multiple toolbar targets */
        FOR EACH ttLink NO-LOCK
           WHERE ttLink.ttType = ENTRY(1,bAction.link,'-')
            AND (ttLink.ttFrom = pcToolbarInstance
              OR ttLink.ttTo   = pcToolbarInstance):
              
          IF cTarget = 'nolink' THEN 
          DO:
            ASSIGN cTarget    = ttLink.ttSDO
                   cDSIsASBO  = getSavedDSProperty(gcLogicalObjectName, cTarget, 'isSBO':U)
                   lDSIsASBO  = (IF cDSIsASBO > "":U THEN LOGICAL(cDSIsASBO) ELSE NO).
            IF lDSIsASBO THEN
              ASSIGN cTarget = 'wdo'.
          END.
          IF cTarget <> ttLink.ttSDO THEN cTarget = 'wdo'.
        END.

        /* Check for navigation target attribute */
        IF cTarget > "" AND cTarget <> "nolink" AND cNavigationTarget > "" THEN cTarget = cNavigationTarget.
        IF cTarget = '' THEN cTarget = 'master'.

        IF CAN-DO('status,relogon,calculator,calendar',cAction) THEN ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'status,relogon,calculator,calendar')
                                      ,cAction + ',main.info.toggle,dlg.login,util.../dhtml/rycalculator.htm,util.../dhtml/rycalendar.htm')
            .
        ELSE IF cAction BEGINS 'help':U THEN ASSIGN
                cAction = 'app.':U + cAction.
        ELSE ASSIGN
            cAction = ENTRY(1 + LOOKUP(cAction,'find,filter')    /* WDO utilities */
                                      ,cAction + ',lookup,filter.toggle')
            cAction = (IF CAN-DO('commit,navigation,tableio,toolbar,containertoolbar',ENTRY(1,bAction.link,'-'))
                       THEN cTarget
                       ELSE (IF bAction.link = '' THEN 'app' ELSE 'nolink')
                       ) + '.' + cAction                               /* Application utilties */
            .

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

        /**** Disable various non-supported tools ***/
        IF CAN-DO('suspend,notepad,wordpad,email,internet,word,excel,rule,pref,printsetup,translate,rydynhelpw,multiwindow,audit',ENTRY(2,cAction,'.')) THEN 
            ENTRY(1,cAction,'.') = 'nolink'.
        
        IF cHotkey > '' THEN
            gcHotkey = gcHotkey + ';|' + cAction + '|' + cHotkey + '||'.

        IF plDoToolbar AND CAN-DO('Menu&Toolbar',bBand.BandType) THEN ASSIGN
            lSpacer = TRUE
            gcPanel = gcPanel +  ";" + STRING(iLevel) + "|" + cAction + "|" + REPLACE(bAction.Caption,'&','') + cHotkey2 + "|" + cImage + "|".
        
        IF CAN-DO('Menubar,Submenu',bBand.BandType) OR 
          (CAN-DO('Menu&Toolbar',bBand.BandType) AND iLevel > 1)  THEN DO: 
            c1 = ";" + STRING(iLevel) + "|" + cAction + "|" + cCaption + cHotkey2 + "|" + cImage + "|".
            IF cType = "band" 
                THEN gcBand = gcBand + c1.
                ELSE gcMenu = gcMenu + c1.
        END.

        IF bBandAction.ChildBand > '' THEN
            RUN doToolBand(bBandAction.ChildBand,iLevel + 1,cType,pcToolbarInstance,pcHiddenActions,pcTarget,plDoToolbar,cWdo).

    END. /* FOR EACH ttToolbarAction */
    IF lSpacer THEN DO:
        gcPanel = gcPanel +  ";1|break|||".

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doToolbar Procedure 
PROCEDURE doToolbar PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cLogicalName     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cWdo             AS CHARACTER  NO-UNDO INIT ''.
    DEFINE VARIABLE cTargetBand      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTargetMenu      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iPagenumber      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lInPage          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cType            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNavTargetName   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUserObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dOrganisationObj AS DECIMAL    NO-UNDO.
    DEFINE BUFFER bLink FOR ttLink.
    
    DEFINE VARIABLE cDS              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDSIsASBO        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSDOs            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSDO             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lDSIsASBO        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hSDO             AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i1               AS INTEGER    NO-UNDO.

    ASSIGN 
      dUserObj         = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentUserObj":U,INPUT NO))
      dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentOrganisationObj":U,INPUT NO))
      timeMenu         = timeMenu - ETIME
      cObjectName      = ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE
      .
        
    RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
      'LayoutPosition,HiddenActions,TableIoType,NavigationTargetName,LogicalObjectName,ActionGroups,ToolbarDrawDirection').

    ASSIGN 
      cNavTargetName = {ry/inc/lval.i NavigationTargetName}
      iPagenumber    = ghObjectBuffer:BUFFER-FIELD('PageNumber'):BUFFER-VALUE
      lInPage        = setLayout(true)   /* true - check for top of page */ 
      .
/*    {log "'Toolbar:' + cObjectName + '/' + string(iPagenumber) + '/' + string(lInPage) + '/' + string(glIsDynFrame)"} */

    cType       = IF cObjectName = "MenuController" THEN 'menu' ELSE ''.
    cTargetMenu = IF cType = 'menu' THEN 'mainmenu' ELSE 'progmenu'.
    cTargetBand = IF cType = 'menu' THEN 'mainband' ELSE 'progband'.

    RUN getToolbarBandActions IN gshRepositoryManager
     (INPUT {ry/inc/lval.i LogicalObjectName},   /* toolbar */
      INPUT gcLogicalObjectName,                 /* pObjectName, */
      INPUT '',
      OUTPUT TABLE ttToolbarBand,
      OUTPUT TABLE ttObjectBand,
      OUTPUT TABLE ttBand,
      OUTPUT TABLE ttBandAction,
      OUTPUT TABLE ttAction,
      OUTPUT TABLE ttCategory)
        NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      MESSAGE "ERROR:getToolbarBandActions:" {1} '-' {2} '=' RETURN-VALUE '/' ERROR-STATUS:GET-MESSAGE(1).
    
    IF {ry/inc/lval.i TableIoType} = 'save' THEN DO:
      FOR EACH ttLink WHERE ttLink.ttFrom = cObjectName AND ttLink.ttType = 'TableIO'
         ,EACH bLink  WHERE bLink.ttSDO = ttLink.ttSDO AND bLink.ttType = 'SDO':
         bLink.ttIO = 'on'.
      END.
    END.
    
    /* Setup the WDOs being controlled by the toolbar */
    IF cNavTargetName > '' THEN cWdo = cNavTargetName.
    ELSE
    DO:
      FOR EACH ttLink NO-LOCK WHERE ttLink.ttFrom = cObjectName OR ttLink.ttTo   = cObjectName:
        IF ttLink.ttSDO > "":U AND NOT CAN-DO(cWdo,ttLink.ttSDO) THEN
        DO:
          ASSIGN cDS        = ttLink.ttSDO
                 cDSIsASBO  = getSavedDSProperty(gcLogicalObjectName, cDS, 'isSBO':U)
                 lDSIsASBO  = (IF cDSIsASBO > "":U THEN LOGICAL(cDSIsASBO) ELSE NO).
                
          IF NOT lDSIsASBO THEN
            ASSIGN cWdo = (IF cWdo > '' THEN cWdo + ',' ELSE '') + ttLink.ttSDO. 
          ELSE 
          DO:
            /* This is a SBO, so check if this is a toolbar link is so find the 
               appropriate navigation link */
            IF ttLink.ttType = "Toolbar" AND ttLink.ttTo > "":U THEN
              ASSIGN cWdo = (IF cWdo > '' THEN cWdo + ',' ELSE '') + getToolbarSource(ttLink.ttTo).

            /* This is a SBO and Navigation target is blank, then set all the SDO's
               In the SBO to be th navigation targets */
            IF cWdo = "":U THEN
            DO:
              ASSIGN
                hSDO  = getDataSourceHandle(gcLogicalObjectName, cDS, "":U)
                cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hSDO)) NO-ERROR.
           
              IF cSDOs > "":U THEN
              DO i1 = 1 TO NUM-ENTRIES(cSDOs):
                ASSIGN cSDO = ENTRY(i1, cSDOs, ",":U)
                       hSDO = WIDGET-HANDLE(cSDO)
                       cSDO = DYNAMIC-FUNCTION("getObjectName":U IN hSDO ).
                IF NOT CAN-DO(cWdo,cSDO) THEN
                  ASSIGN cWdo = (IF cWdo > '' THEN cWdo + ',' ELSE '') + cSDO. 
              END.
            END.
          END.
        END.
      END.
    END.
    IF cWdo = "":U THEN ASSIGN cWdo = 'master':U.

    FOR EACH ttToolbarBand BY LOOKUP(ttToolbarBand.Alignment,'left,center,right') BY ttToolbarBand.sequence:
/*    {log "'MenuMain:' + ttToolbarBand.Band"}  */ 
      RUN doToolBand(ttToolbarBand.Band,1,cType,cObjectName,{ry/inc/lval.i HiddenActions},
        '"' + cTargetMenu + '" page="' + STRING(iPagenumber) + '"',TRUE,cWdo).
    END. 

    /* Panel - output into grid */
    IF lInPage OR glIsDynFrame OR ({ry/inc/lval.i ToolbarDrawDirection} = "vertical")
    THEN {&out} doMenu(gcPanel,'"panel"',cWdo) "</div>~n".
    ELSE gcMenues = gcMenues + doMenu(gcPanel,'"toolbar"',cWdo).
    
    ASSIGN
      gcMenues = gcMenues 
        + doMenu(gcBand,'"' + cTargetBand + '"',cWdo)
        + doMenu(gcMenu,'"' + cTargetMenu + '"',cWdo)
        + doMenu(gcHotkey,'"hotkey"',cWdo)
      gcPanel  = ''
      gcBand   = ''
      gcMenu   = ''
      gcHotkey = ''.
    IF glIsDynFrame THEN gcMenues = ''.  /* DynFrame has no menues */
    
    ASSIGN timeMenu = timeMenu + ETIME.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndefined) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndefined Procedure 
PROCEDURE doUndefined PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Generate HTML for Undefined / unknown widget 
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* Tooltip,{&htmlProps},label,{&htmlLabel},height-chars,width-chars,HtmlStyle,InitialValue */

  {log "'Unknown widget ' + gcId"}

  RETURN htmlLabel("label")
          + SUBSTITUTE('<input &1 style="&2;&3" &4 value="&5">'
            ,htmlProps('Tooltip',gcState)
            ,SUBSTITUTE('top:&1px;left:&2px;height:&3px;width:&4px;'
                     ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow + giFieldOffsetTop - 2)
                     ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)
                     ,INTEGER(DEC({ry/inc/lval.i height-chars}) * giPixelsPerRow)
                     ,INTEGER(DEC({ry/inc/lval.i width-chars}) * giPixelsPerColumn)
                     )
            ,{ry/inc/lval.i HtmlStyle}
            ,gcEvents
            ,HTML-ENCODE({ry/inc/lval.i InitialValue})
            ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doViewer Procedure 
PROCEDURE doViewer PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       ttSDORequiredFields is populated here to save having to run
                 determineSDOFieldsUsed.

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  
  DEFINE VARIABLE cName                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClassName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cID                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldState            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredHiddenFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerId              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisualization         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObjBuf                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQ                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDSIsASBO              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDSIsASBO              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lTableIOTarget         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWDO                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dInstanceId            AS DECIMAL    NO-UNDO.
  
  CREATE BUFFER hObjBuf FOR TABLE ghObjectBuffer.

  RUN getatt(STRING(ghObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
    '{&htmlLayout},DataSourceNames,ShowPopup').
  setLayout(false).

  /* Set viewer attributes. If the Viewer is not a TableIO target, then its 
     fields should not be enabled. Otherwise defer to EnabledFields attribute 
     to apply correct enabled state. */
     
  ASSIGN
    giMinTabIndex  = giMaxTabIndex
    gcViewerName   = ghObjectBuffer:BUFFER-FIELD('ObjectName'):BUFFER-VALUE
    dInstanceId    = ghObjectBuffer:BUFFER-FIELD('InstanceId'):BUFFER-VALUE
    cViewerId      = "DEC('" + STRING(dInstanceId) + "')"
    gcSDOName      = getSdoLink(gcViewerName)
    cDSIsASBO      =  getSavedDSProperty(gcLogicalObjectName, gcSDOName, 'isSBO':U)
    lDSIsASBO      =  (IF cDSIsASBO > "":U THEN LOGICAL(cDSIsASBO) ELSE NO)
    lTableIOTarget = CAN-DO(getLinkTypes(gcViewerName),'TableIO')                      
    cWDO           = gcSDOName
    glViewerShowPopup = ({ry/inc/lval.i ShowPopup} = "yes").
    
  IF (lDSIsASBO) THEN 
  DO:
    ASSIGN cDataSourceNames = {ry/inc/lval.i DataSourceNames} NO-ERROR.
    ASSIGN gcSboName = gcSDOName
           cSBOName = gcSDOName 
           gcSDOName = "":U
           cWDO = cDataSourceNames.
    IF ( cDataSourceNames > "":U ) THEN
        gcSDOName = (IF NUM-ENTRIES(cDataSourceNames, ",":U) = 1 THEN cDataSourceNames ELSE "":U).
  END.  
  ELSE
    ASSIGN gcSboName = "":U.
  
  /* There could be multiple instance of data sources for viewer hence the wdo has to be datasources  i.e 1-1 dynSBO  */
  {&OUT} '<div' htmlLayout('viewer') ' wdo="' cWDO '" objtype="viewer">~n<form name="_' gcViewerName '">'.


  
/***********************************************************************************/
/** Output the widgets                                                            **/
/***********************************************************************************/
  
  /* Loop through viewer objects.  The BY phrase is included to sort by object 
     class, such that DynLookup is processed first.  In this way linked field 
     references are recorded for later processing of the linked field itself. */
  cWhere  = "FOR EACH ":U + hObjBuf:NAME + " WHERE ":U
          + hObjBuf:NAME + ".ContainerInstanceId = " + cViewerId 
          + " BY LOOKUP(" + hObjBuf:NAME + ".ClassName, '":U + gcDynLookupClasses + "') DESCENDING":U 
          .
 /* {log "'where=' + cWhere"} */
  CREATE QUERY hQ.
  hQ:ADD-BUFFER(hObjBuf).
  glOk = hQ:QUERY-PREPARE(cWhere) NO-ERROR.
  IF NOT glOk OR ERROR-STATUS:ERROR THEN DO:
    {log "'Error preparing query.  ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1)"}
    RUN setMessage  (INPUT "** ERROR preparing query for loop through fields on viewer, where: ":U + 
      cWhere + ', ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    LEAVE.
  END.

  hQ:QUERY-OPEN().
  hQ:GET-FIRST().
  
  DO WHILE hObjBuf:AVAILABLE:
/***********************************************************************************/
/** Output the widgets                                                            **/
/***********************************************************************************/

   /********************************************************/ 
   /**   Get ID and initial state                         **/ 
   /********************************************************/ 
    DEFINE VARIABLE lEnabled         AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE lDataField       AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cEnabled         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cEnableField     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDisplayField    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInstanceName    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cWidgetType      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFieldName       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjectName      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cEventNames      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cEventActions    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFieldSecurity   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE i1               AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lSecurityReadOnly AS LOGICAL     NO-UNDO.

    ASSIGN 
      cInstanceName = TRIM(LC(hObjBuf:BUFFER-FIELD("ObjectName":U):BUFFER-VALUE))
      dInstanceId   = hObjBuf:BUFFER-FIELD("InstanceId":U):BUFFER-VALUE
      cClassName    = TRIM(LC(hObjBuf:BUFFER-FIELD("ClassName":U):BUFFER-VALUE))
      cWidgetType   = ''.

    /** Merge HTML events **/
    ASSIGN 
      gcEvents      = ''
      cEventNames   = hObjBuf:BUFFER-FIELD("EventNames":U):BUFFER-VALUE
      cEventActions = hObjBuf:BUFFER-FIELD("EventActions":U):BUFFER-VALUE.  
    DO i1 = 1 TO NUM-ENTRIES(cEventNames):
      IF ENTRY(i1,cEventNames) BEGINS "on" THEN
        gcEvents = gcEvents + ENTRY(i1,cEventNames) + '="' + ENTRY((i1 * 4) - 1,cEventActions,CHR(1)) + '" '.    
    END.

    /***********************************************************************/
    /** SmartDataFields - Requires different attributes than other fields **/
    /***********************************************************************/
    IF LOOKUP(cClassName, gcDynLookupClasses   ) > 0 THEN cWidgetType = 'dynLookup'.
    IF LOOKUP(cClassName, gcDynComboClasses    ) > 0 THEN cWidgetType = 'dynCombo'.
    IF cWidgetType > '' THEN DO:
      IF cWidgetType = 'dynLookup' THEN DO:
        RUN getatt(STRING(hObjBuf:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'', 
          'LocalField,FieldSecurity,ObjectName,EnableField,FieldName,DisplayField,DisplayedField,FieldToolTip,{&htmlProps},{&htmlLabel},HtmlStyle,width-chars,FieldLabel,keyField,ViewerLinkedFields,ViewerLinkedWidgets,ParentField,LogicalObjectName,LocalField,KeyDataType,BaseQueryString,QueryTables,RowsToBatch,BrowseFields,ParentFilterQuery,BrowseTitle,DisplayDataType,DisplayFormat').
      END.
      ELSE DO:
        RUN getatt(STRING(hObjBuf:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'', 
          'LocalField,FieldSecurity,EnableField,FieldName,DisplayField,DisplayedField,FieldTooltip,{&htmlProps},{&htmlLabel},HtmlStyle,width-chars,FieldLabel,keyField,height-chars,DescSubstitute,queryTables,ComboFlag,FlagValue,KeyFormat,KeyDataType,ParentField,ParentFilterQuery,baseQueryString').
      END.
      /* If the FieldName is blank then get the value form the ObjectName.
         This is required to support the V1.1 auto attach kind of lookups */
         


      ASSIGN
        lDataField  = ({ry/inc/lval.i LocalField} <> "yes") 
        cFieldName  = "." + LC({ry/inc/lval.i FieldName})
        cFieldName = ENTRY(NUM-ENTRIES(cFieldName,'.'),cFieldName,'.')
        cObjectName = "." + LC({ry/inc/lval.i ObjectName})
        cObjectName = ENTRY(NUM-ENTRIES(cObjectName,'.'),cObjectName,'.')
        gcID        = (IF lDataField AND gcSdoName > "" THEN gcSdoName + '.' ELSE '') 
                    + (IF cFieldName > "" THEN cFieldName ELSE cObjectName)
        cFieldSecurity   = {ry/inc/lval.i FieldSecurity}
        cEnableField     = {ry/inc/lval.i EnableField}
        cEnableField     = (IF cEnableField > "":U THEN cEnableField ELSE "YES")
        lEnabled         = (lTableIOTarget OR NOT lDataField) AND LOGICAL(cEnableField).

        {log "cWidgetType + '=>' + gcID"}
      /* process security attributes */
      IF ( processFieldSecurity(cInstanceName, cFieldSecurity,
                                     INPUT-OUTPUT cSecuredHiddenFields,
                                     OUTPUT lSecurityReadOnly)) THEN
      DO:
          IF (NOT lSecurityReadOnly) THEN
          DO:
              /* IF the field is not readonly then it must be hidden so skip the field */
              hQ:GET-NEXT().
              NEXT.              
          END.
          ELSE
              /* set the lEnabled state since the resulting behavior is the same */
              lEnabled = FALSE.
      END.

      ASSIGN gcState  = IF lEnabled THEN '' 
                        ELSE ' disable="true" disabled="true"':U.
                        
      ASSIGN cDisplayField = {ry/inc/lval.i DisplayField}
             cDisplayField = (IF cDisplayField > "":U THEN cDisplayField ELSE "YES").
             
      IF LOGICAL(cDisplayField) THEN 
      DO:
        RUN VALUE('do' + cWidgetType).
        {&OUT} RETURN-VALUE SKIP.
      END.
      hQ:GET-NEXT().
      NEXT.
    END.

    /****************************************************************************/
    /** Regular widgets - Fetching all possible attributes to avoid two fetches */          
    /****************************************************************************/
    RUN getatt(STRING(hObjBuf:BUFFER-FIELD('InstanceID'):BUFFER-VALUE),'',  
      'FieldSecurity,NAME,DisplayField,Enabled,Visible,VisualizationType,{&htmlProps},{&htmlLabel},height-chars,width-chars,HtmlStyle,InitialValue,ToolTip,Label,RADIO-BUTTONS,LIST-ITEM-PAIRS,LIST-ITEMS,DELIMITER,Horizontal,IMAGE-FILE,word-wrap,FLAT-BUTTON,CHECKED,ShowPopup,DATA-TYPE,multiple,FORMAT').
    IF ERROR-STATUS:ERROR THEN DO:
      {log "'FAILED ' + cInstanceName"} 
      hQ:GET-NEXT().
      NEXT.
    END.

    IF {ry/inc/lval.i DisplayField} = 'no' OR {ry/inc/lval.i Visible} = 'no' THEN DO:  /** Hide **/ 
      hQ:GET-NEXT().
      NEXT.
    END.

    /* If the Name is customersdo.Name - then leave it as is 
       this will happen if the viewer was built using SBO as opposed to SDO */
    ASSIGN
      lDataField = LOOKUP(cClassName, gcDataFieldClasses    ) > 0
      cName      = LC({ry/inc/lval.i NAME})
      gcId       = (IF NUM-ENTRIES(cName, ".":U) > 1 THEN cName ELSE LC(IF lDataField AND gcSdoName > "" THEN gcSdoName + '.' ELSE '') + cName)
      cEnabled   = {ry/inc/lval.i Enabled}
      cEnabled   = (IF cEnabled > "":U THEN cEnabled ELSE "YES")
      lEnabled   = (lTableIOTarget OR NOT lDataField) AND LOGICAL(cEnabled)
      cFieldSecurity   = {ry/inc/lval.i FieldSecurity}.

    /* process security attributes */
    IF ( processFieldSecurity(cInstanceName, cFieldSecurity,
                              INPUT-OUTPUT cSecuredHiddenFields,
                              OUTPUT lSecurityReadOnly)) THEN
    DO:
        IF (NOT lSecurityReadOnly) THEN
        DO:
            /* IF the field is not readonly then it must be hidden so skip the field */
            hQ:GET-NEXT().
            NEXT.              
        END.
        ELSE
            /* set the lEnabled state since the resulting behavior is the same */
            lEnabled = FALSE.
    END.
    
    /* Check if this field is a Dynamic Lookup LinkedWidget, then override gcID. */
    FIND FIRST ttLinkedField 
      WHERE ttLinkedField.cSDO    = gcSDOName AND
            ttLinkedField.cViewer = gcViewerName AND
            ttLinkedField.cWidget = gcID NO-ERROR.
    IF AVAILABLE ttLinkedField THEN
      gcID = LC(gcSDOName + '._':U + ttLinkedField.cLookup + ENTRY(2, ttLinkedField.cField, ".":U)).

    gcState = IF lEnabled THEN '' 
              ELSE ' disabled="true" disable="true"':U.

    
    CASE {ry/inc/lval.i VisualizationType}:
      WHEN "Button"     THEN RUN doButton.  
      WHEN "Text"       THEN RUN doText.  
      WHEN "Image"      THEN RUN doImage. 
      WHEN "Rectangle"  THEN RUN doRectangle.
      WHEN "Toggle-Box" THEN RUN doToggleBox.
      WHEN "Radio-Set"  THEN RUN doRadioSet.
      WHEN "Editor"     THEN RUN doEditor.
      WHEN "Fill-In"    THEN RUN doFillIn.
      WHEN "Selection-List" OR
      WHEN "Combo-Box"  THEN RUN doComboBox.
      OTHERWISE              RUN doUndefined.
    END CASE.
    
    {&OUT} RETURN-VALUE SKIP.
    hQ:GET-NEXT().
  END. 

  /* Save the SDO Field Security */
  saveDSSecurity(gcLogicalObjectName, gcSDOName, TRIM(cSecuredHiddenFields, ",")).

  hQ:QUERY-CLOSE().
  hObjBuf:BUFFER-RELEASE() NO-ERROR.
  DELETE OBJECT hObjBuf   NO-ERROR.
  DELETE OBJECT hQ      NO-ERROR.
  ASSIGN hQ = ?.
  {&OUT} '~n</form></div></div>~n'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchUI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchUI Procedure 
PROCEDURE fetchUI PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQ              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTreeSDO        AS CHARACTER NO-UNDO.
  
  ASSIGN
    gcRunAttribute = ''.
    gcSessionResultCodes = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                       INPUT "SessionResultCodes",
                                       INPUT NO).

  {log "'result codes:' + gcSessionResultCodes"}
  
  /* Just in case - use the default */
  IF gcSessionResultCodes = "":U OR gcSessionResultCodes = ? THEN 
    ASSIGN gcSessionResultCodes = "{&DEFAULT-RESULT-CODE}":U.
  
  {log "'Fetch UI from Repository for ':U + gcLogicalObjectName"}

  /* Clear cache in repository manager */
  RUN clearClientCache IN gshRepositoryManager.
  
  /* Retrieve outermost container object and it's children */
  RUN cacheRepositoryObject IN gshRepositoryManager 
          (INPUT gcLogicalObjectName 
          ,INPUT "PAGE:*"  /* = Instancename */
          ,INPUT gcRunAttribute
          ,INPUT gcSessionResultCodes
          ) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    {log "'Error Running cacheObjectOnClient API.  ErrorMsg: ':U + ERROR-STATUS:GET-MESSAGE(1)"}
    RUN setMessage  (INPUT "** ERROR Running cacheObjectOnClient API. ErrorMsg: ":U + ERROR-STATUS:GET-MESSAGE(1) + ', Program: ' + PROGRAM-NAME(1), INPUT 'ERR':u).
    RETURN.
  END.
  {log "'Repository fetch complete':U"}

  RUN returnCacheBuffers IN gshRepositoryManager 
         (OUTPUT ghObjectBuffer
         ,OUTPUT ghPageBuffer
         ,OUTPUT ghLinkBuffer
         ).

  /* Get the secured tokens */
  gcSecuredTokens = getSecurityTokens(gcLogicalObjectName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAtt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAtt Procedure 
PROCEDURE getAtt PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/


  DEFINE INPUT PARAMETER pcMaster      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcInstance    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcAttList     AS CHARACTER  NO-UNDO.

/** Fetch the object **/
  ASSIGN cAttNames  = pcAttList.

  RUN getInstanceProperties IN gshRepositoryManager (
        INPUT pcMaster
       ,INPUT pcInstance
       ,INPUT-OUTPUT cAttNames 
       ,OUTPUT cAttValues   ) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "ERROR:getInstanceProperties:" pcMaster '-' pcInstance '=' RETURN-VALUE '/' ERROR-STATUS:GET-MESSAGE(1).
    RETURN ERROR RETURN-VALUE + ERROR-STATUS:GET-MESSAGE(1).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSdoInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSdoInfo Procedure 
PROCEDURE getSdoInfo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This IP outputs the SDO definition details 
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcLogicalObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phSDO                  AS HANDLE     NO-UNDO.
  
  DEFINE OUTPUT PARAMETER pcFieldNames          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDataTypes           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEnabled             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcInitVals            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFromVals            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcToVals              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFormat              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFilter              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSorting             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLabels              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE c1                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllColProps        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColProps           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCols               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSavedFilters       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromVal            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupObj          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToVal              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateableCols     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i3                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFirst              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE rRowid              AS ROWID      NO-UNDO.
  DEFINE VARIABLE cDSLookupList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParam        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsLOB              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataDelimiter      AS CHARACTER  NO-UNDO.

  ASSIGN
    lFirst          = TRUE
    cCols           = getSDODataColumns(pcLogicalObjectName, phSDO, NO, YES)
    cUpdateableCols = getSDODataColumns(pcLogicalObjectName, phSDO, YES, YES)
    cAllColProps    = DYNAMIC-FUNCTION('columnProps':U IN phSDO, cCols, 'DataType,Initial,Label':U)
    cFilterKey      = pcLogicalObjectName + ".":U + pcSDOName + ".filter":U
    cSavedFilters   = TRIM(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, cFilterKey, NO),"|":U)
    cDataDelimiter  = getSavedDSDataDelimiter(pcLogicalObjectName,pcSDOName).
  
  /* message 'SDO=' + pcSDOName + '/' + pcLogicalObjectName. */
  /* {log "'SDO=' + pcSDOName + '/' + pcLogicalObjectName + '->' + string(valid-handle(phSDO))"} */
  /* {log "'Cols=' + cCols"}           */
  /* {log "'Updt=' + cUpdateableCols"} */

  /* Check Profile Manager for saved filter settings */
  IF cSavedFilters = "" THEN
    RUN getProfileData IN gshProfileManager 
      ("SDO":U,             /* Profile type code */
       "Attributes":U,      /* Profile code */
       cFilterKey,          /* Profile data key */
       "NO":U,              /* Get next record flag */
       INPUT-OUTPUT rRowid, /* Rowid of profile data */
       OUTPUT cSavedFilters) NO-ERROR.

  DO i = 1 TO NUM-ENTRIES(cCols):
    ASSIGN
      cFieldName = ENTRY(i, cCols)
      cColProps  = ENTRY(i, cAllColProps, CHR(3))
      cDataType  = ENTRY(2, cColProps, CHR(4))
      cDataType  = ENTRY(1 + LOOKUP(cDataType,"date,decimal,integer,logical":U),
                                              ",date,dec,int,log":U)
      cFromVal   = ""
      cToVal     = "".

    IF (cSavedFilters > "":U) THEN
    DO i1 = 1 TO NUM-ENTRIES(cSavedFilters, "|":U):
      cEntry = ENTRY(i1, cSavedFilters, "|":U).
      IF ENTRY(1, cEntry, " ":U) = cFieldName THEN 
      DO:
        IF ENTRY(2, cEntry, " ":U) = ">":U THEN
          cFromVal = ENTRY(3, cEntry, " ":U).
        ELSE IF ENTRY(2, cEntry, " ":U) = "<":U THEN
          cToVal = ENTRY(3, cEntry, " ":U).
      END.
    END.
  
    ASSIGN
      lIsLOB        = (IF ENTRY(2, cColProps, CHR(4)) = "CLOB":U OR ENTRY(2, cColProps, CHR(4)) = "BLOB" THEN YES ELSE NO)
      pcFieldNames  = pcFieldNames + (IF lFirst THEN "":U ELSE "|":U) + LC(cFieldName)
      pcEnabled     = pcEnabled + (IF lFirst THEN "":U ELSE "|":U) +
                       (IF LOOKUP(cFieldName, cUpdateableCols) <> 0 THEN 'y':U ELSE 'n':U)
      pcDataTypes   = pcDataTypes + (IF lFirst THEN "":U ELSE "|":U) + cDataType
      pcInitVals    = pcInitVals + (IF lFirst THEN "":U ELSE cDataDelimiter)
                                 + RIGHT-TRIM(ENTRY(3, cColProps, CHR(4)))
      pcFromVals    = pcFromVals + (IF lFirst THEN "":U ELSE "|":U) + cFromVal
      pcToVals      = pcToVals + (IF lFirst THEN "":U ELSE "|":U) + cToVal
      pcFormat      = pcFormat + "|":U
      pcFilter      = pcFilter + (IF lFirst THEN "":U ELSE "|":U) + (IF lIsLOB THEN 'n':U ELSE 'y':U)
      pcSorting     = pcSorting + (IF lFirst THEN "":U ELSE "|":U) + (IF lIsLOB THEN 'n':U ELSE 'y':U)
      pcLabels      = pcLabels + (IF lFirst THEN "":U ELSE "|":U) + ENTRY(4, cColProps, CHR(4))
      lFirst        = no.
  END.
  
 /* For Comments */
 Assign
   pcFieldNames  = pcFieldNames + (IF lFirst THEN "":U ELSE "|":U) + "_hascomments"
   pcEnabled     = pcEnabled + (IF lFirst THEN "":U ELSE "|":U) + "n":U
   pcDataTypes   = pcDataTypes + (IF lFirst THEN "":U ELSE "|":U) + "log"
   pcInitVals    = pcInitVals + (IF lFirst THEN "":U ELSE cDataDelimiter) + "no"
   pcFromVals    = pcFromVals + (IF lFirst THEN "":U ELSE "|":U) + "|"
   pcToVals      = pcToVals + (IF lFirst THEN "":U ELSE "|":U) + "|"
   pcFormat      = pcFormat + "|":U
   pcFilter      = pcFilter + (IF lFirst THEN "":U ELSE "|":U) + 'n':U
   pcSorting     = pcSorting + (IF lFirst THEN "":U ELSE "|":U) + 'n':U
   pcLabels      = pcLabels + (IF lFirst THEN "":U ELSE "|":U) + "Has Comments".
  /* This will provide the list of lookups to look for this SDO */
  ASSIGN cDSLookupList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           pcLogicalObjectName + ".":U + pcSDOName + ".lookup":U, NO).

  DO i1 = 1 TO NUM-ENTRIES(cDSLookupList, "|":U):
  
    cLookupParam = ENTRY(i1,cDSLookupList,'|':U).
    c1 = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                           cLookupParam, NO).
    
    IF (NUM-ENTRIES(c1, CHR(4)) < 14) THEN 
      NEXT.
      
    /* Get initial lookup display value */
    ASSIGN
      cFieldName    = LC(ENTRY(4, c1, CHR(4)))
      cLookupObj    = LC(ENTRY(8, c1, CHR(4)))
      pcFieldNames   = pcFieldNames + '|_':U + cLookupObj
      pcEnabled      = pcEnabled + (IF CAN-DO(cUpdateableCols, cFieldName) THEN '|y':U ELSE '|':U)
      c2            = c2 + "|":U 
    NO-ERROR.

    /* Get linked field display value */    
    cFields = ENTRY(7, c1, CHR(4)).
    IF cFields <> "" AND cFields <> ? THEN
    DO i3 = 1 TO NUM-ENTRIES(cFields):
      ASSIGN
        cLinkField   = LC(ENTRY(2, ENTRY(i3, cFields), ".":U))
        pcFieldNames  = pcFieldNames + '|_':U + cLookupObj + cLinkField
        pcEnabled     = pcEnabled  + '|':U
        c2           = c2 + '|':U
        NO-ERROR.
    END.
    ASSIGN pcInitVals = appendLookupData(pcLogicalObjectName, pcSDOName, cCols, pcInitVals, YES) NO-ERROR.
  END.

  ASSIGN 
    pcDataTypes  = pcDataTypes + c2
    pcFromVals   = pcFromVals + c2
    pcToVals     = pcToVals + c2
    pcFormat     = pcFormat + c2
    pcFilter     = pcFilter + c2
    pcSorting    = pcSorting + c2
    pcLabels     = pcLabels + c2.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTreeData Procedure 
PROCEDURE getTreeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParam AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE  cPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE  cBand AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE  c1    AS CHARACTER  NO-UNDO. 

  lognote('',ENTRY(4,pcParam,'.')).  
  CASE ENTRY(4,pcParam,'.'):
   WHEN 'mnu' THEN DO:    
    ASSIGN cBand = ENTRY(3,pcParam,'.').
    RUN getToolbarBandActions IN gshRepositoryManager
     (INPUT '',     /* toolbar */
      INPUT '',     /* pObjectName, */
      INPUT cBand,  /* List of bands */
      OUTPUT TABLE ttToolbarBand,
      OUTPUT TABLE ttObjectBand,
      OUTPUT TABLE ttBand,
      OUTPUT TABLE ttBandAction,
      OUTPUT TABLE ttAction,
      OUTPUT TABLE ttCategory)
        NO-ERROR.
    RUN doToolBand(cBand
                  ,1          /* level */
                  ,"treeview" /* type */
                  ,"treeview" /* objectname */
                  ,""         /* hidden actions */ 
                  ,""         /* No text for in-page */
                  ,TRUE       /* Don't skip */
                  ,""         /* No SDO relation */).
    lognote('','Menu='  + gcmenu).
    ASSIGN
      cPath   = getImagePath("ry/img/":U)
      gcMenu  = REPLACE(gcMenu,"ry/img/",cPath)
      gcJsRun = gcJsRun 
              + '~napp.dyntree.loadMenu('
              + ENTRY(2,pcParam,'.') + ',"' + gcMenu
              + '");'
      gcMenu  = "".
   END.    
   WHEN 'prg' THEN DO:    
    lognote('','Extract=' + ENTRY(3,pcParam,'.')).

    EMPTY TEMP-TABLE ttNode.
    RUN ry/app/rytreeprgp.p (ENTRY(3,pcParam,'.'),'',OUTPUT TABLE ttNode).
    FOR EACH ttNode NO-LOCK BY ttNode.node_code:
      ASSIGN c1 = c1 + (IF c1 > '' THEN '~n,"' ELSE '~n"') + getTreeString(BUFFER ttNode). 
    END.    
    ASSIGN gcJsRun = gcJsRun 
                   + '~napp.dyntree.loadProg('
                   + ENTRY(2,pcParam,'.')
                   + ',"' 
                   + ENTRY(3,pcParam,'.') 
                   + '",[' + c1 + ']);'.
   END.
   OTHERWISE DO:     
    gcJsRun = gcJsRun 
            + '~napp.dyntree.loadTree('
            + ENTRY(2,pcParam,'.') + ',"' + ENTRY(3,pcParam,'.')
            + '");'. 
   END.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-includeCSS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE includeCSS Procedure 
PROCEDURE includeCSS PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
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
PROCEDURE includeJS PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
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

&IF DEFINED(EXCLUDE-outputRedefinedSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputRedefinedSDO Procedure 
PROCEDURE outputRedefinedSDO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This IP outputs the new SDO definition to the DHTML client
  Parameters:  <none>
  Notes:       This is necessary in cases where the parent container defines 
               the SDO but the dependent container has lookup fields based 
               on the parent container SDO.

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcLogicalObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phSDO                  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cFinalSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldLabels        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTypes          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabled            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInitVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToVals             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilter             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSorting            AS CHARACTER  NO-UNDO.
  
  /* Check if the SDO definition needs to be sent to the client */
  IF NOT (glOutputSDODefinition) THEN 
    RETURN.
    
  cFinalSDOName = IF ( NUM-ENTRIES(pcSDOName, ".":U) > 1 ) 
                  THEN ENTRY(2, pcSDOName, ".":U) ELSE pcSDOName.


  RUN getSdoInfo(INPUT pcLogicalObjectName, INPUT pcSDOName, INPUT phSDO,
                 OUTPUT cFieldNames, OUTPUT cDataTypes, 
                 OUTPUT cEnabled, OUTPUT cInitVals, OUTPUT cFromVals, OUTPUT cToVals, 
                 OUTPUT cFormat, OUTPUT cFilter, OUTPUT cSorting, OUTPUT cFieldLabels).
                       
  {&OUT}
    "app._":U + cFinalSDOName + ".define(":U SKIP
    "~{fieldname     :'":U + cFieldNames + "'," SKIP
    "fieldlabel    :'":U + cFieldLabels + "'," SKIP
    "fieldvalidate :'":U + cDataTypes + "'," SKIP
    "fieldenabled  :'":U + cEnabled + "'," SKIP
    "initvals      :'":U + cInitVals + "'," SKIP
    "filtfrom      :'":U + cFromVals + "'," SKIP
    "filtto        :'":U + cToVals + "'," SKIP
    "fieldformat   :'":U + cFormat + "'," SKIP
    "fieldfilter   :'":U + cFilter + "'," SKIP
    "fieldsorting  :'":U + cSorting + "'," SKIP
    "sortdir       :'|0',":U SKIP
    "sortnum       :'|0'}); ":U SKIP.

  ASSIGN glOutputSDODefinition = FALSE.
  
  /* Resend the current batch of data */
  RUN processEvents(pcLogicalObjectName, pcSDOName + ".current":U, FALSE) NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputSDO Procedure 
PROCEDURE outputSDO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phSDO                  AS HANDLE     NO-UNDO.
  
  DEFINE INPUT PARAMETER pcAutoCommit           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcUpdateTarget         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcExport               AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcParentChildSupport   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSBOName              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFinalSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTypes          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabled            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInitVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromVals           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToVals             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilter             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSorting            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabels             AS CHARACTER  NO-UNDO.
  

  cFinalSDOName = IF ( NUM-ENTRIES(pcSDOName, ".":U) > 1 ) 
                  THEN ENTRY(2, pcSDOName, ".":U) ELSE pcSDOName.

  /* PSD cache is to be set to "on" unless the dynamic property "RefreshDataOnView" is set. */

  {&OUT}
    '<div class="wdo" objtype="wdo" cache="off"' + 
    ' id="':U + cFinalSDOName + '" name="':U + cFinalSDOName + 
    '" sbo="' + TRIM(LC(pcSBOName)) + '" commit="' + TRIM(pcAutoCommit) + 
    '" update="':U + pcUpdateTarget + '" ':U + pcParentChildSupport + pcExport SKIP.

  /* This section is being broken into a different IP so that this could be reused in lookup 
     append for passthru - i.e from IP outputRedefinedSDO */
  
  RUN getSdoInfo(INPUT gcLogicalObjectName, INPUT pcSDOName, INPUT phSDO,
                 OUTPUT cFieldNames, OUTPUT cDataTypes, 
                 OUTPUT cEnabled, OUTPUT cInitVals, OUTPUT cFromVals, OUTPUT cToVals, 
                 OUTPUT cFormat, OUTPUT cFilter, OUTPUT cSorting, OUTPUT cLabels).
  
  {&OUT}
    ' fields="':U + cFieldNames + '" ':U SKIP
    ' validate="':U + cDataTypes + '" ':U SKIP
    ' enabled="':U + cEnabled + '" ':U SKIP
    ' initvals="':U + cInitVals + '" ':U SKIP
    ' from="':U + cFromVals + '" ':U SKIP
    ' to="':U + cToVals + '" ':U SKIP
    ' format="':U + cFormat + '" ':U SKIP
    ' filter="':U + cFilter + '" ':U SKIP
    ' sorting="':U + cSorting + '" ':U SKIP
    ' labels="':U + cLabels + '">~n</div>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenData Procedure 
PROCEDURE screenData PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* Output HTTP Header */
  output-content-type ("text/html":U).

  {&OUT}
    gcHtmlHeader SKIP
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

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  IF get-value('do') > '' THEN
    RUN screenData.
  ELSE DO:
    /* Output HTTP Header */
    output-content-type ("text/html":U).
    {&OUT}
      gcHtmlHeader SKIP
      '<head>~n<link rel="stylesheet" type="text/css" href="../dhtml/ryapp.css" />~n':U
      '</head>~n':U 
      '~n<body><div id="wbo" objtype="wbo"></div>~n':U 
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
PROCEDURE screenEnd PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMimeCharset AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRet         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER    NO-UNDO.

  /* Check if the SDO definition needs to be resent to the client */
  IF (glOutputSDODefinition) THEN
    RUN outputRedefinedSDO( INPUT getPassThruSDOInfo(1), 
                            INPUT getPassThruSDOInfo(2), 
                            INPUT getDataSourceHandle(getPassThruSDOInfo(1), getPassThruSDOInfo(2), ?)).
    
  IF INDEX(gcRequestEvents,'.dyntree') > 0 AND gcJsRun > '' THEN 
    gcJsRun = gcJsRun + "~napp.dyntree.initialize();".
    
  FOR EACH ttClientAction EXCLUSIVE-LOCK:
    cRet = cRet + (IF cRet > "" THEN "  ,":U ELSE " app.main.actions(~n  [":U) 
           + '"':U + ttClientAction.ttAction + '"~n':U.
    DELETE ttClientAction.
  END.
  IF cRet > "" THEN
    cRet = cRet + " ]);~n":U.

  outputComboData().
  outputCommittedData().
  
  ouputConflictData().
 
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
    '<script language="javascript">~n'
    'if(parent.appcontrol) parent.appcontrol.setEnd();~n'
    '<~/script>~n'
    '~n</body>~n</html>':U SKIP.

  /* Flush the web stream, so control is passed back to the user immediately
     (so they don't have to wait for the rest of cleanup to be done. */
  PUT {&WEBSTREAM} CONTROL NULL(0).

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
PROCEDURE screenError PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       We also do a JavaScript alert, in case this is output to a 
               hidden frame.

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcErrorMsg AS CHARACTER NO-UNDO.

  {&OUT}       
    gcHtmlHeader SKIP
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
PROCEDURE screenUI PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Top layer for creating the screen UI
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTitle      AS CHARACTER  NO-UNDO INITIAL 'Dynamics'.
  DEFINE VARIABLE i1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cJavascript AS CHARACTER  NO-UNDO.
  
  IF get-value('lookup':U) BEGINS "DYN=":U AND gcBaseHref = "" THEN DO:
    gcBaseHref = SUBSTRING(ENTRY(1,get-value('lookup':U),'#'),5).
    IF gcBaseHref > '' THEN 
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
          INPUT "BaseHref",
          INPUT gcBaseHref,
          INPUT NO).
  END.
  ELSE gcBaseHref = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
          INPUT "BaseHref",
          INPUT NO).
  
  IF get-value('lookup':U) BEGINS "DYN=":U THEN DO:
    ASSIGN gcCssTheme = ENTRY(6,get-value('lookup':U),'#') NO-ERROR.
    IF gcCssTheme > '' THEN 
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
          INPUT "CssTheme",
          INPUT gcCssTheme,
          INPUT NO).
    /* {log "'CssTheme=' + gcCssTheme"} */
  END.
  
  /* Initialize variables for UI operations */
  ASSIGN gcViewerName = "".

  /** Repository fetch **/ 
  RUN fetchUI.


  /* Get container, so we can check for StyleSheetFile and/or JavaScriptFile
     attributes. */
  ghObjectBuffer:FIND-FIRST(" WHERE " + ghObjectBuffer:NAME + ".ObjectName = '":U + gcLogicalObjectName + "'" ).

  RUN getatt(gcLogicalObjectName,'',
    'WindowName,ContainerMode,StartPage,JavaScriptFile,StyleSheetFile,FolderType,RootNodeCode,AutoSort,RowsToBatch').

  ASSIGN
    gcMasterObjectId = "DEC('" + STRING(ghObjectBuffer:BUFFER-FIELD('InstanceId'):BUFFER-VALUE) + "')"
    glIsDynFrame     = CAN-DO(gcDynFrameClasses,ghObjectBuffer:BUFFER-FIELD('ClassName'):BUFFER-VALUE)
    cTitle           = {ry/inc/lval.i WindowName} WHEN NOT glIsDynFrame
    gcContainerMode  = {ry/inc/lval.i ContainerMode}
    i1               = INT({ry/inc/lval.i StartPage})
    cJavaScript      = {ry/inc/lval.i JavaScriptFile}
    gcStylesheet     = {ry/inc/lval.i StyleSheetFile}
    gcTreeRootNode   = {ry/inc/lval.i RootNodeCode}
    gcTreeAutoSort   = {ry/inc/lval.i AutoSort}
    gcTreeRowsToBatch = {ry/inc/lval.i RowsToBatch}
    gcFolderType     = {ry/inc/lval.i FolderType} 
      NO-ERROR.
  IF gcStyleSheet = ? OR gcStyleSheet = "" THEN gcStyleSheet = gcCssTheme.
  IF gcStyleSheet = ? OR gcStyleSheet = "" THEN gcStyleSheet = "../dhtml/ryapp.css":U.
  IF cJavaScript = ? THEN cJavaScript = "".
  IF i1 > 0 THEN gcPageProps = gcPageProps + 'startpage=' + STRING(i1).

  /* Output HTTP Header */
  output-content-type ("text/html":U).

  ASSIGN
    gcJS    = ''
    gcJsRun = ''
    cTitle  = (IF cTitle = ? THEN '' ELSE cTitle) /* + ' &#160; ' + FILL('_',120) */.

  {&OUT}
    gcHtmlHeader SKIP
    '<head>':U SKIP 
    '<script language="javascript">~n'
    'if(parent.appcontrol) parent.appcontrol.setStart();~n'
    '<~/script>~n'
    '<title>':U cTitle '</title>~n':U 
    '<meta name="Generator" content="Dynamics20" />~n':U
    . 
    
  IF gcBaseHref > '' THEN 
    {&out} '<base href="' ENTRY(1,gcBaseHref,'|') '" />~n'.

  RUN includeJS(cJavascript) NO-ERROR.  /** At the end **/

  /* The main stylesheet reference is output here for smooth screen drawing. */
  /* Output StyleSheet file reference(s) */
  DO i1 = 1 TO NUM-ENTRIES(gcStyleSheet):
    {&OUT}
      '<link rel="stylesheet" type="text/css" href="' + TRIM(ENTRY(i1,gcStyleSheet)) + '" />~n':U.
  END.
  {&OUT} '</head>':U SKIP.

  IF get-value('lookup':U) BEGINS "DYN=":U THEN
    RUN doClientMessages.

  {&OUT} '<body tabindex="-1" ' gcPageProps '>':U SKIP.

  /*   logNote('note',"Running Container":U).  */
  RUN doContainer.
  
  {&OUT}
    '<script language="javascript"><!--':U SKIP
    'function run(app)~{':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-doMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION doMenu Procedure 
FUNCTION doMenu RETURNS CHARACTER PRIVATE
  (INPUT cMenu AS CHARACTER, INPUT cTarget AS CHARACTER, INPUT cWdo AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/


  DEFINE VARIABLE cPath AS CHARACTER  NO-UNDO.
  cPath = getImagePath("ry/img/":U).
  IF cMenu > '' THEN RETURN '<div layout="' + LC({ry/inc/lval.i ToolbarDrawDirection})
      + '" id="menu" name="menu" wdo="' + cWdo + '" target=' + cTarget + ' ~n  menu="' 
      + REPLACE(cMenu,"ry/img/",cPath)
    + '"></div>~n'.
  RETURN "".   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formatValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatValue Procedure 
FUNCTION formatValue RETURNS CHARACTER PRIVATE
    ( INPUT pcValue AS CHARACTER,
      INPUT pcFormat AS CHARACTER,
      INPUT pcDataType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return format applied to a value
    Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  {log "'format:' + pcFormat + '/' + pcDataType + '=' + pcValue"}
  DEFINE VARIABLE cVal AS CHARACTER  NO-UNDO.
  IF pcFormat = "" OR pcFormat = ? THEN RETURN pcValue.
  ERROR-STATUS:ERROR = NO.

  CASE pcDataType:
    WHEN "character":U THEN
      cVal = RIGHT-TRIM(STRING(pcValue, pcFormat)) NO-ERROR.
    WHEN "date":U THEN
      cVal = STRING(DATE(pcValue), pcFormat) NO-ERROR.
&IF DEFINED(newdatatypes) &THEN
    WHEN "datetime":U THEN
      cVal = STRING(DATETIME(pcValue), pcFormat) NO-ERROR.
    WHEN "datetime-tz":U THEN
      cVal = STRING(DATETIME-TZ(pcValue), pcFormat) NO-ERROR.
&ENDIF      
    WHEN "decimal":U THEN
       cVal = STRING(DECIMAL(pcValue), pcFormat) NO-ERROR.
    WHEN "integer":U THEN
      cVal = STRING(INTEGER(pcValue), pcFormat) NO-ERROR.
    WHEN "logical":U THEN
      cVal = STRING(LOGICAL(pcValue), pcFormat) NO-ERROR.
    OTHERWISE 
      cVal = pcValue.
  END CASE.

  IF ERROR-STATUS:ERROR  THEN
    RETURN pcValue.
  ELSE
    RETURN cVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER PRIVATE
  ( pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Get the image file path
    Notes:

 Note! This is an internal API not intended for public use and is subject to change
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
FUNCTION getLinkTypes RETURNS CHARACTER PRIVATE
  (INPUT c1 AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRet AS CHARACTER NO-UNDO.
  
  FOR EACH ttLink WHERE (ttFrom = c1 OR ttTo = c1) AND ttType <> 'SDO':
      cRet = cRet + (IF cRet > '' THEN ',' ELSE '') + ttLink.ttType.
  END.

  RETURN cRet.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOForComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOForComments Procedure 
FUNCTION getSDOForComments RETURNS HANDLE
  (plPositionToRow AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function returns the SDO for the comments window.
    Notes:  This is called from the Logic procedure of the comments window.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowId             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityInfo        AS CHARACTER  NO-UNDO.

  ASSIGN cLogicalObjectName = get-value("LogicalObjectName")
         cSDOName           = get-value("ParentSDOName")
         cRowId             = get-value("RowId")
         hDataSource        = ?.

  IF cLogicalObjectName > "":U AND cSDOName > "":U  THEN
  DO:
    hDataSource = getDataSourceHandle(cLogicalObjectName, cSDOName, "").
    IF (cRowId > "":U AND plPositionToRow) THEN
      DYNAMIC-FUNCTION('findRowInCurrentBatch':U IN hDataSource, "RowObject.RowIdent", cRowId, "":U).
  END.
  RETURN hDataSource.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOLink Procedure 
FUNCTION getSDOLink RETURNS CHARACTER PRIVATE
  (INPUT cIn AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  
  IF CAN-FIND(ttLink WHERE ttLink.ttFrom = cIn AND ttLink.ttType = 'sdo') THEN DO:
    /* For SDOs you only want to find the parent SDO */
    FIND FIRST ttLink WHERE ttTo = cIn AND ttSDO = 'SDO' NO-ERROR.
    IF AVAILABLE ttLink THEN DO:
      cIn = ttFrom. /* Finding the SDO it goes from */
      FIND FIRST ttLink WHERE ttLink.ttType = 'SDO' AND ttLink.ttFrom = cIn.
      c1 = ttLink.ttSDO.
    END.
  END.
  ELSE DO:
    FOR EACH ttLink WHERE ttFrom = cIn OR ttTo = cIn AND ttSDO > '':
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
FUNCTION getSecurityTokens RETURNS CHARACTER PRIVATE
  ( pcLogicalObjectName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns the token securoty for the Object 
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
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

&IF DEFINED(EXCLUDE-getToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarSource Procedure 
FUNCTION getToolbarSource RETURNS CHARACTER PRIVATE
  ( pcTargetName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Given a toolbar target name this function will return the data source.
    Notes:  This will work if the Data Source is SBO
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLocalObjectBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cval               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cret               AS CHARACTER  NO-UNDO.

  ASSIGN cName = "DataSourceNames,UpdateTargetNames"
         cret = '':u.

  CREATE BUFFER hLocalObjectBuffer FOR TABLE ghObjectBuffer BUFFER-NAME 'ObjectBuffer'.
  hLocalObjectBuffer:FIND-FIRST(" WHERE ":U + hLocalObjectBuffer:NAME + ".ObjectName = '":U + ttLink.ttTo + "'":U ) NO-ERROR.
  IF hLocalObjectBuffer:AVAILABLE THEN 
  DO:
    RUN getInstanceProperties IN gshRepositoryManager (
      INPUT STRING(hLocalObjectBuffer:BUFFER-FIELD('InstanceID'):BUFFER-VALUE)
     ,INPUT ''
     ,INPUT-OUTPUT cName 
     ,OUTPUT cval   ) NO-ERROR.
  END.
  IF NUM-ENTRIES(cval, CHR(1)) > 0 THEN
  DO:
    cDataSourceNames = ENTRY(1,cval,CHR(1)).
    IF NUM-ENTRIES(cDataSourceNames, ",":U) = 1 THEN
      cret = cDataSourceNames.
  END.

  IF NUM-ENTRIES(cval, CHR(1)) > 1 AND cret = '':U THEN
  DO:
    cUpdateTargetNames = ENTRY(2,cval,CHR(1)).
    IF NUM-ENTRIES(cUpdateTargetNames, ",":U) = 1 THEN
       cret = cUpdateTargetNames.
  END.
  
  DELETE OBJECT hLocalObjectBuffer NO-ERROR.
  ASSIGN hLocalObjectBuffer = ?.

  RETURN cret.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeString Procedure 
FUNCTION getTreeString RETURNS CHARACTER PRIVATE
  (BUFFER bNode FOR ttNode):
/*------------------------------------------------------------------------------
  Purpose:  
  Notes:
------------------------------------------------------------------------------*/
/*
    ttTreeNode.tName     = LC(bNode.node_code)
    ttTreeNode.tParent   = cParent
    ttTreeNode.tType     = LC(bNode.data_source_type)
    ttTreeNode.tDS       = bNode.data_source
    ttTreeNode.tDSfilter = bNode.parent_node_filter 
    ttTreeNode.tLaunch   = LC(bNode.logical_object)
    ttTreeNode.tTextExpr = (IF bNode.data_source_type = "txt" 
                       THEN bNode.data_source 
                       ELSE bNode.node_text_label_expression)
    ttTreeNode.tTextFlds = LC(bNode.label_text_substitution_fields)
    ttTreeNode.tImg1     = bNode.image_file_name
    ttTreeNode.tImg2     = bNode.selected_image_file_name
    ttTreeNode.tStruct   = LC(bNode.parent_field + ',' + bNode.child_field)
    ttTreeNode.tForeign  = LC(bNode.foreign_fields)
    ttTreeNode.tLabel    = bNode.node_label
    cParent              = ttTreeNode.tName
*/
  RETURN     LC(bNode.node_code)
     + "|" + LC(bNode.parent_node_code)
     + "|" + LC(bNode.logical_object)
     + "|" + (IF bNode.data_source_type = "txt" 
              THEN bNode.data_source 
              ELSE bNode.node_text_label_expression)
     + "|" + LC(bNode.label_text_substitution_fields)
     + "|" + bNode.image_file_name
     + "|" + bNode.selected_image_file_name
     + "|" + LC(bNode.parent_field + "," + bNode.child_field)
     + "|" + LC(bNode.foreign_fields) 
     + "|" + LC(bNode.data_source)
     + "|" + bNode.node_label
     + "|" + LC(bNode.data_source_type) 
     + "||" + REPLACE(bNode.parent_node_filter,'"','') 
     + "|" + bNode.fields_to_store
     + "|" + REPLACE(REPLACE(bNode.private_data,"|",""),CHR(1),"|") /* Web use Pipe as delimiter */
     + '"'.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVal Procedure 
FUNCTION getVal RETURNS CHARACTER PRIVATE
  (INPUT c1 AS CHARACTER, INPUT c2 AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Returns c2 if c1 is blank or unknown
  Notes:
------------------------------------------------------------------------------*/

  RETURN IF c1 > '' THEN c1 ELSE c2.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlClass Procedure 
FUNCTION htmlClass RETURNS CHARACTER PRIVATE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cClass AS CHARACTER  NO-UNDO.
  ASSIGN cClass = {ry/inc/lval.i HtmlClass}.
  RETURN IF cClass > '' THEN cClass ELSE "field".   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlLabel Procedure 
FUNCTION htmlLabel RETURNS CHARACTER PRIVATE
  ( cLabelId AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose: Create the HTML label tag 
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  ASSIGN cLabel = ENTRY(LOOKUP(cLabelId,cAttNames) + 1,CHR(1) + cAttValues,CHR(1)) NO-ERROR. 
  IF cLabel > '' AND LOGICAL({ry/inc/lval.i LABELS}) THEN
    RETURN 
      SUBSTITUTE('<label style="top:&2px;left:0px;width:&3px;">&1:&&#160;</label>~n'
    ,cLabel
    ,INTEGER(DEC({ry/inc/lval.i row}) * giPixelsPerRow) + giFieldOffsetTop
    ,INTEGER(DEC({ry/inc/lval.i column}) * giPixelsPerColumn)).
  RETURN ''.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlLayout Procedure 
FUNCTION htmlLayout RETURNS CHARACTER PRIVATE
  (cObjectType AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:   Return standard layout definitions for view/browse and dynframe objects  
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHtmlClass AS CHARACTER  NO-UNDO.
  ASSIGN
    cHtmlClass    = {ry/inc/lval.i HtmlClass}
      NO-ERROR.
  
  /* Set included Javascriptfiles */
  RUN includeJS({ry/inc/lval.i JavaScriptFile}) NO-ERROR.
  RUN includeCSS({ry/inc/lval.i StyleSheetFile}) NO-ERROR.
  
  RETURN
    SUBSTITUTE(' class="&1" min="&2,&3" style="&4&5" id="&6" name="&7"'
      ,IF cHtmlClass > "" THEN cHtmlClass ELSE cObjectType
      ,INT(DEC({ry/inc/lval.i MinWidth}) * giPixelsPerColumn + giViewerOffsetWidth)
      ,INT(DEC({ry/inc/lval.i MinHeight}) * giPixelsPerRow + giViewerOffsetHeight)
      ,IF LOGICAL({ry/inc/lval.i HideOnInit}) THEN 'display:none;':U ELSE '' 
      ,{ry/inc/lval.i HtmlStyle} 
      ,jsTrim({ry/inc/lval.i ObjectName})
      ,jsTrim({ry/inc/lval.i LogicalObjectName})
      ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION htmlProps Procedure 
FUNCTION htmlProps RETURNS CHARACTER PRIVATE
  (cTipName AS CHAR, cState AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: HTML object generic properties: id, name, class, tooltip, taborder, etc 
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTooltip   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClass     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTab       AS CHARACTER  NO-UNDO.

  ASSIGN
    cClass  = {ry/inc/lval.i HtmlClass}
    cClass  = IF cClass > '' THEN cClass ELSE 'field'
    cToolTip    = {ry/inc/lval.i HELP}
    cTab    = STRING(tabIndex(INT({ry/inc/lval.i Order})))
      NO-ERROR.
  IF cToolTip = "":U OR cToolTip = ? THEN
    cToolTip = ENTRY(LOOKUP(cTipName,cAttNames) + 1,CHR(1) + cAttValues,CHR(1)).

  RETURN SUBSTITUTE(' id="&1" name="&1" class="&2" title="&3" &4'
    ,gcID
    /** Must give it correct initial state, especially for loose widgets **/
    ,cClass + (IF cState > '' THEN ' disable' ELSE ' enable') 
    ,cTooltip
    ,(IF cState > '' 
      THEN 'tabindex="-1" ' 
      ELSE 'tab="' + cTab + '" tabindex="' + cTab + '" ') 
      + cState 
    ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-jsTrim) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION jsTrim Procedure 
FUNCTION jsTrim RETURNS CHARACTER PRIVATE
  ( INPUT c1 AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Trims special characters for Javascript names  
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
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

&IF DEFINED(EXCLUDE-maxlength) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION maxlength Procedure 
FUNCTION maxlength RETURNS CHARACTER PRIVATE
  (INPUT cFormat AS CHARACTER, INPUT cDatatype AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
  Notes:
------------------------------------------------------------------------------*/
  IF cFormat > "" THEN
    CASE cDatatype:
      WHEN "logical" THEN
        RETURN 'maxlength="' + STRING(LENGTH(STRING(YES,cFormat))) + '" '.
      OTHERWISE
        RETURN 'maxlength="' + STRING(LENGTH(STRING("",cFormat))) + '" '.
    END.      
  ELSE    RETURN ''.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processFieldSecurity Procedure 
FUNCTION processFieldSecurity RETURNS LOGICAL PRIVATE
        (INPUT pcInstanceName AS CHARACTER,
     INPUT pcFieldSecurity AS CHARACTER, 
     INPUT-OUTPUT pcHiddenFields AS CHARACTER, 
     OUTPUT plIsReadonly AS LOGICAL ):
/*------------------------------------------------------------------------------
  Purpose:  Processes the security of the viewer fields
        Notes:  returns whether security fields where present and processed
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSecurityType AS CHARACTER  NO-UNDO.
    plIsReadOnly = FALSE.
    
    /* process security attributes */        
    ASSIGN cSecurityType = ENTRY(2, pcFieldSecurity) NO-ERROR.
    IF (NOT ERROR-STATUS:ERROR) THEN
    DO:
        IF (cSecurityType = 'Hidden':U) THEN
        DO:
                /* add this field to the the cSecuredHiddenFiled so that it can be 
                   disabled in the SDO.  No additional stuff needs to be done.  The
                   widget is actually not rendered. */
                pcHiddenFields = pcHiddenFields + ",":U + pcInstanceName.
                {log "'SecurityType: Hidden, InstanceName: ' + pcInstanceName"}
                RETURN TRUE.          
        END.
        ELSE IF (cSecurityType = 'Read Only':U OR cSecurityType = 'Read-Only':U ) THEN
        DO:
            /* set the output parameter plIsReadOnly to true */
            plIsReadOnly = TRUE.
            {log "'SecurityType: R-O, InstanceName: ' + pcInstanceName"}
            RETURN TRUE.
        END.
    END.    

    RETURN FALSE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveDynLookupInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDynLookupInfo Procedure 
FUNCTION saveDynLookupInfo RETURNS LOGICAL PRIVATE
  (INPUT pcLogicalObjectName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: This function will save the lookup info into the properties 
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  /* LogicalObjectName,KeyField,DisplayedField,KeyDataType,FieldName,BaseQueryString,QueryTables,ViewerLinkedFields,RowsToBatch,BrowseFields,ParentField,ParentFilterQuery,BrowseTitle,DisplayDataType */

  DEFINE VARIABLE cLookupInfo         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupInstance     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOParamName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOReal            AS CHARACTER  NO-UNDO.  /* pass-thru resolved */
  DEFINE VARIABLE cLookupObjParamName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParamName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSLookupList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSLookupObjList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLocalLookup        AS LOGICAL    NO-UNDO.

  /* If the FieldName is blank then get the value form the LogicalObjectName.
   This is required to support the V1.1 auto attach kind of lookups */
   
  ASSIGN
    lLocalLookup     = (IF NUM-ENTRIES(gcId, '.':U) > 1 THEN NO ELSE YES)
    cLookupField     = {ry/inc/lval.i FieldName}
    cLookupField     = (IF cLookupField = '':U OR cLookupField = ? THEN {ry/inc/lval.i LogicalObjectName} ELSE cLookupField)
    cLookupField     = ENTRY(NUM-ENTRIES(cLookupField,'.'),cLookupField,'.')
    cLookupInstance  = (IF NOT lLocalLookup THEN SUBSTRING(ENTRY(2,gcId,'.'),2) ELSE gcId)
    cLookupParamName = pcLogicalObjectName + ".":U + cLookupInstance + ".lookup":U
        cBrowseFields    = {ry/inc/lval.i BrowseFields}
        cDisplayedField  = {ry/inc/lval.i DisplayedField}
    .

  /* Make sure displayField is in the BrowseFields list*/
  IF LOOKUP(cDisplayedField, cBrowseFields) = 0 THEN ASSIGN
        cBrowseFields = cBrowseFields + "," + cDisplayedField.
  
  
  /* If master SDO has a lookup then resend the SDO definition to the client */
  IF (NOT lLocalLookup) THEN
  DO:
    IF (gcSdoName = 'master':U) THEN
      ASSIGN cSdoReal = getPassThruSDOInfo(2)
             glOutputSDODefinition = TRUE.
    ELSE
      ASSIGN cSdoReal = gcSdoName.
  END.
  ELSE
    ASSIGN cSdoReal = "wdo".

  /* Get the SDO lookup list to check if the lookup is already there, if not Save the lookup to the SDO list*/
  IF (cSdoReal > "":U) THEN
  DO:
    /* First save the list based on SDO and Lookup Object */
    cSDOParamName = pcLogicalObjectName + ".":U + cSdoReal + ".lookup":U.
    {log "'dl-save:' + cSDOParamName"}
    ASSIGN cDSLookupList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           cSDOParamName, NO).
    
    
    /* Save the list of lookups for this SDO */
    IF LOOKUP(cLookupParamName,cDSLookupList,'|') = 0 THEN
    DO:
      cDSLookupList = cDSLookupList + '|' + cLookupParamName.
      cDSLookupList = TRIM(cDSLookupList , "|":U).
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                          cSDOParamName, cDSLookupList, NO).
    END.
    
    /* Now save a list based on lookup obj */
    cLookupObjParamName = pcLogicalObjectName + ".":U + cLookupInstance + ".lookupObj":U.
    ASSIGN cDSLookupObjList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           cLookupObjParamName, NO).
    /* Save the list of lookups for this SDO */
    IF LOOKUP(cLookupParamName,cDSLookupObjList,'|') = 0 THEN
    DO:
      cDSLookupObjList = cDSLookupObjList + '|' + cLookupParamName.
      cDSLookupObjList = TRIM(cDSLookupObjList , "|":U).
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                          cLookupObjParamName, cDSLookupObjList, NO).

    END.
    
  END.
  
  cLookupInfo = {ry/inc/lval.i KeyField          } + CHR(4)
              + {ry/inc/lval.i DisplayedField    } + CHR(4)
              + {ry/inc/lval.i KeyDataType       } + CHR(4)
              +                cLookupInstance     + CHR(4)
              + {ry/inc/lval.i BaseQueryString   } + CHR(4)
              + {ry/inc/lval.i QueryTables       } + CHR(4)
              + {ry/inc/lval.i ViewerLinkedFields} + CHR(4)
              +                cLookupInstance     + CHR(4) 
              + {ry/inc/lval.i RowsToBatch       } + CHR(4)  
              +                cBrowseFields       + CHR(4)
              + {ry/inc/lval.i ParentField       } + CHR(4)  
              + {ry/inc/lval.i ParentFilterQuery } + CHR(4)
              + {ry/inc/lval.i BrowseTitle       } + CHR(4)
              + {ry/inc/lval.i DisplayDataType   }.

  /* Save this info for later retrieval */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                        cLookupParamName, cLookupInfo, NO).

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

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  gcImagePath = pcImagePath.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLayout Procedure 
FUNCTION setLayout RETURNS LOGICAL PRIVATE
    ( INPUT lToolbar AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Fixes old-format layout code
    Notes:

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/


  DEFINE VAR cLayout   AS CHARACTER NO-UNDO.
  DEFINE VAR iPage     AS INTEGER   NO-UNDO.

  ASSIGN 
    cLayout = {ry/inc/lval.i LayoutPosition}
    iPage   = ghObjectBuffer:BUFFER-FIELD('PageNumber'):BUFFER-VALUE
    . 
  
    /* Determine how to interpret the layout position for backwards compatibility */
    CASE gcLayoutCode:
      WHEN "01":U OR WHEN "05":U THEN
        cLayout = '111':U.
      WHEN "02":U OR WHEN "03":U THEN DO:
        CASE SUBSTRING(cLayout,1,1):
          WHEN "T":U THEN cLayout = '111':U.
          WHEN "C":U THEN cLayout = '121':U.
          WHEN "M":U THEN cLayout = '1':U + SUBSTRING(cLayout,2).
          WHEN "B":U THEN cLayout = '191':U.
        END CASE.   /* layout position */
      END.
      WHEN "04":U THEN DO:
        CASE SUBSTRING(cLayout,1,1):
          WHEN "L":U THEN cLayout = '111':U.
          WHEN "C":U THEN cLayout = '112':U.
          WHEN "R":U THEN cLayout = '113':U.
        END CASE.   /* layout position */
      END.
      OTHERWISE DO:
        CASE SUBSTRING(cLayout,1,1):
          WHEN "T":U THEN cLayout = '0':U + SUBSTRING(cLayout,2).
          WHEN "M":U THEN cLayout = '1':U + SUBSTRING(cLayout,2).
          WHEN "B":U THEN cLayout = '2':U + SUBSTRING(cLayout,2).
        END CASE.   /* layout position */
      END.
    END CASE.


    IF lToolbar AND iPage = 0 AND cLayout < "12" AND NOT glIsDynFrame THEN RETURN FALSE.
    {&out} 
       '~n<div class="layout'
       (IF iPage = 0 THEN '"' ELSE ' hide" page="' + STRING(iPage) + '"')
       ' pos="' SUBSTRING(cLayout,2) '">~n  '.

    RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabIndex) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tabIndex Procedure 
FUNCTION tabIndex RETURNS INTEGER PRIVATE
  ( INPUT i1 AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Set the TabIndex for the object 
    Notes:  

 Note! This is an internal API not intended for public use and is subject to change
------------------------------------------------------------------------------*/

  IF i1 < 1 THEN RETURN -1.
  i1 = giMinTabIndex + i1.
  IF i1 > giMaxTabIndex THEN giMaxTabIndex = i1.
  RETURN i1.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

