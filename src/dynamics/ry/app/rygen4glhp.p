&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rygen4glhp.p

  Description:  4GL Generation Hook Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/15/2004  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rygen4glhp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

{src/adm2/globals.i}
{af/app/afdatatypi.i}
/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ry/app/rydefrescd.i}

&scoped-define deprecated-attributes MasterFile
&scoped-define exclude-from-prop-list Height-Chars,Width-Chars,Row,Column,Order,Name,ObjectName,Height,Width,VisualizationType,(&deprecated-attributes}
&scoped-define dynamic-web-attributes JavaScriptFile,JavaSCriptObject,HtmlClass,HtmlStyle

/* Toolbar and menu item definitions */
{src/adm2/ttaction.i}

/* This TT is LIKE ttActionTranslation as defined in ttaction.i.
   However, we can't use LIKE because this temp-table will inherit
   the indexes from that temp-table, which include a unique index
   that this code violates when translating more than one language.
 */
define temp-table ttTranslatedAction no-undo
    field LanguageCode      as character
    field Action            as character
    field Name              as character    initial ?
    field Caption           as character    initial ?
    field Tooltip           as character    initial ?
    field Accelerator       as character    initial ?
    field Image             as character    initial ?
    field ImageDown         as character    initial ?
    field ImageInsensitive  as character    initial ?
    field Image2            as character    initial ?
    field Image2Down        as character    initial ?
    field Image2Insensitive as character    initial ?
    index idxLanguageAction as unique  
        LanguageCode
        Action.

{src/adm2/tttoolbar.i}

/* Treeview node definitions */
{src/adm2/treettdef.i}

/* Dynamic viewer internal temp-tables. */
{ry/app/rydynviewi.i}

define temp-table ttProperty         no-undo
    field PropertyName        as character
    field PropertyValue       as character
    field PropertyOwner       as character
    field UseInList           as logical    initial no
    field ForceSet            as logical
    field DataType            as character
    index idxName as unique
        PropertyName
        PropertyOwner
    index idxInList
        PropertyOwner
        UseInList
    index idxSet
        PropertyOwner
        ForceSet.
        
define temp-table ttEvent        no-undo
    field EventName         as character    /* ie VALUE-CHANGED */
    field InstanceName      as character
    field ActionType        as character    /* RUN or PUBLISH */
    field ActionTarget      as character    /* Procedure in which event runs. */
    field EventParameter    as character
    field EventAction       as character    /* procedure to run or event to publish */
    index idxName as unique
        EventName
        InstanceName.
    
define temp-table ttInstance        no-undo
    field InstanceName        as character
    field Order               as integer
    field ObjectName          as character
    field PageReference       as character
    field ClassName           as character
    field InstanceType        as character    /* Sdf,Widget,etc. Used by various viewer loops. */
    field CleanName           as character    /* 'clean' instancename - <32 chars, no funky chars. can be used as a variable */
    index idxName as unique
        InstanceName
    index idxType
        InstanceType
    index idxOrder
        Order
    index idxCleanName
        CleanName.
    
define temp-table ttPage            no-undo
    field PageNumber        as integer
    field PageLabel         as character
    field PageReference     as character
    field PageLayoutCode    as character
    field PageToken         as character
    index idxPage
        PageNumber
    index idxReference as unique
        PageReference.
        
define temp-table ttLink        no-undo
    field LinkName           as character
    field SourceInstanceName as character
    field TargetInstanceName as character
    field SourcePageRef      as character
    field TargetPageRef      as character
    index idxLink    as unique
        LinkName
        SourceInstanceName
        TargetInstanceName
    .        

DEFINE TEMP-TABLE ttBandToExtract NO-UNDO
    FIELD parent_menu_structure_code AS CHARACTER
    FIELD menu_structure_type        AS CHARACTER    
    FIELD menu_structure_obj         AS DECIMAL
    FIELD menu_structure_code        AS CHARACTER
    FIELD extract_sequence           AS INTEGER
    FIELD disabled                   AS LOGICAL
    FIELD under_development          AS LOGICAL
    FIELD menu_item_obj              AS DECIMAL
    FIELD control_spacing            AS INTEGER
    FIELD control_padding            AS INTEGER
    INDEX idx0 IS PRIMARY extract_sequence
    INDEX idx1 menu_structure_obj.

define temp-table ttWidgetHandle no-undo
    field WidgetType as character
    field WidgetHandle as handle
    index idxType     as unique
        WidgetType.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-processLoop-instanceProperties-Set) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-instanceProperties-Set Procedure
FUNCTION processLoop-instanceProperties-Set RETURNS LOGICAL 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-instanceProperties-Assign) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-instanceProperties-Assign Procedure
FUNCTION processLoop-instanceProperties-Assign RETURNS LOGICAL 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenuTranslations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildMenuTranslations Procedure 
FUNCTION buildMenuTranslations RETURNS LOGICAL private ( /*no parameters */ ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildObjectMenuTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildObjectMenuTables Procedure 
FUNCTION buildObjectMenuTables RETURNS LOGICAL PRIVATE
    ( input pdSmartObjectObj        as decimal,
      input pcResultCode            as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildToolbarMenuTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildToolbarMenuTables Procedure 
FUNCTION buildToolbarMenuTables RETURNS LOGICAL PRIVATE
    ( input pdSmartObjectObj        as decimal,
      input pcResultCode            as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createActionRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createActionRecord Procedure 
FUNCTION createActionRecord RETURNS LOGICAL PRIVATE
        ( input pdMenuItemObj as decimal ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyGenerator Procedure 
FUNCTION destroyGenerator RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findAttributeValue Procedure 
FUNCTION findAttributeValue RETURNS CHARACTER
    ( input pcAttributeLabel     as character,
      input pcObjectName         as character   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInConstructor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD generateSuperInConstructor Procedure 
FUNCTION generateSuperInConstructor RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInline) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD generateSuperInline Procedure 
FUNCTION generateSuperInline RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD generateSuperInProperty Procedure 
FUNCTION generateSuperInProperty RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInitPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitPages Procedure 
FUNCTION getInitPages RETURNS CHARACTER
    ( input pcCurrentPageRef        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceCleanName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceCleanName Procedure 
FUNCTION getInstanceCleanName RETURNS CHARACTER PRIVATE
        ( input pcInstanceName as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceHandleName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceHandleName Procedure 
FUNCTION getInstanceHandleName RETURNS CHARACTER
    ( input pcInstanceName    as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStartPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStartPage Procedure 
FUNCTION getStartPage RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToken-OutputFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToken-OutputFilename Procedure 
FUNCTION getToken-OutputFilename RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetHandle Procedure 
FUNCTION getWidgetHandle RETURNS HANDLE PRIVATE
        ( input pcWidgetType     as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeGenerator Procedure 
FUNCTION initializeGenerator RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTokenValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeTokenValues Procedure 
FUNCTION initializeTokenValues RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initialObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initialObjectSecured Procedure 
FUNCTION initialObjectSecured RETURNS LOGICAL
        ( input pcObjectName        as character  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initialObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initialObjectTranslated Procedure 
FUNCTION initialObjectTranslated RETURNS LOGICAL
        ( input pcObjectName        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceIsVisual) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD instanceIsVisual Procedure 
FUNCTION instanceIsVisual RETURNS LOGICAL
  ( input pcClassName        as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listContainerMenuItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD listContainerMenuItems Procedure 
FUNCTION listContainerMenuItems RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listContainerMenuStructures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD listContainerMenuStructures Procedure 
FUNCTION listContainerMenuStructures RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateObjectTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateObjectTables Procedure 
FUNCTION populateObjectTables RETURNS LOGICAL PRIVATE
        ( input pcObjectName        as character        ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateViewerInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateViewerInstances Procedure 
FUNCTION populateViewerInstances RETURNS LOGICAL PRIVATE
        ( input plCustomizationsExist    as logical,
          input pcResultCodeObj          as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-AddLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-AddLinks Procedure 
FUNCTION processLoop-AddLinks RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createContainerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createContainerObjects Procedure 
FUNCTION processLoop-createContainerObjects RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createContainerPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createContainerPage Procedure 
FUNCTION processLoop-createContainerPage RETURNS LOGICAL
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Action) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-Action Procedure 
FUNCTION processLoop-createMenu-Action RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Band) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-Band Procedure 
FUNCTION processLoop-createMenu-Band RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-BandAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-BandAction Procedure 
FUNCTION processLoop-createMenu-BandAction RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Category) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-Category Procedure 
FUNCTION processLoop-createMenu-Category RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-ObjectBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-ObjectBand Procedure 
FUNCTION processLoop-createMenu-ObjectBand RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-ToolbarBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenu-ToolbarBand Procedure 
FUNCTION processLoop-createMenu-ToolbarBand RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenuField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createMenuField Procedure 
FUNCTION processLoop-createMenuField RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createTreeviewNodeField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createTreeviewNodeField Procedure 
FUNCTION processLoop-createTreeviewNodeField RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createTreeviewNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createTreeviewNodes Procedure 
FUNCTION processLoop-createTreeviewNodes RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerDisplayObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createViewerDisplayObjects Procedure 
FUNCTION processLoop-createViewerDisplayObjects RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createViewerObjects Procedure 
FUNCTION processLoop-createViewerObjects RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createViewerWidgets Procedure 
FUNCTION processLoop-createViewerWidgets RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createWidgetAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-createWidgetAttributes Procedure 
FUNCTION processLoop-createWidgetAttributes RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-listContainerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-listContainerObjects Procedure 
FUNCTION processLoop-listContainerObjects RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-objectProperties-Assign) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-objectProperties-Assign Procedure 
FUNCTION processLoop-objectProperties-Assign RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-ObjectProperties-Set) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-ObjectProperties-Set Procedure 
FUNCTION processLoop-ObjectProperties-Set RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateBrowser Procedure 
FUNCTION processLoop-translateBrowser RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateMenuItem Procedure 
FUNCTION processLoop-translateMenuItem RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateRowObject Procedure 
FUNCTION processLoop-translateRowObject RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateSDO Procedure 
FUNCTION processLoop-translateSDO RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateToolbar Procedure 
FUNCTION processLoop-translateToolbar RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateViewer Procedure 
FUNCTION processLoop-translateViewer RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateViewerItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateViewerItem Procedure 
FUNCTION processLoop-translateViewerItem RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-translateWindow Procedure 
FUNCTION processLoop-translateWindow RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-viewerInstanceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processLoop-viewerInstanceEvents Procedure 
FUNCTION processLoop-viewerInstanceEvents RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SubClassOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SubClassOf Procedure 
FUNCTION SubClassOf RETURNS LOGICAL
        ( input pcClassName        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transmogrifyPropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD transmogrifyPropertyValue Procedure 
FUNCTION transmogrifyPropertyValue RETURNS CHARACTER
    (     input pcDataType         as character,
          input pcPropertyValue    as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetCanSet Procedure 
FUNCTION widgetCanSet RETURNS CHARACTER
    ( input pcWidgetType       as character,
      input pcAttribute        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSetDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetCanSetDataType Procedure 
FUNCTION widgetCanSetDataType RETURNS LOGICAL
        ( input pcWidgetType       as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSetFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetCanSetFormat Procedure 
FUNCTION widgetCanSetFormat RETURNS LOGICAL
        ( input pcWidgetType       as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIsImage Procedure 
FUNCTION widgetIsImage RETURNS LOGICAL
        ( input pcWidgetType        as character ) FORWARD.

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
   Other Settings: CODE-ONLY
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */
&IF DEFINED(EXCLUDE-processLoop-instanceProperties-Set) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-instanceProperties-Set Procedure
FUNCTION processLoop-instanceProperties-Set RETURNS LOGICAL 
	(  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Loops through the settable properties for the instance being 
           generated to generate the property setter.
    Notes:
------------------------------------------------------------------------------*/
    define variable cInstanceName as character no-undo.
    def buffer ttProperty for ttProperty.
        
    cInstanceName = dynamic-function('getTokenValue':u in target-procedure, 'InstanceName').
    
    for each ttProperty where
             ttProperty.PropertyOwner = cInstanceName and
             ttProperty.UseInList = yes and
             ttProperty.ForceSet = Yes
             by ttProperty.PropertyName:

        dynamic-function('setTokenValue' in target-procedure,
                         'PropertyValue',
                         dynamic-function('transmogrifyPropertyValue' in target-procedure,
                                          ttProperty.DataType,
                                          ttProperty.PropertyValue)).
        
        dynamic-function('setTokenValue' in target-procedure,        
                         'PropertyName', ttProperty.PropertyName).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* property list. */
        
    return true.
END FUNCTION.    /* processLoop-instanceProperties-Set */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-processLoop-instanceProperties-Assign) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-instanceProperties-Assign Procedure
FUNCTION processLoop-instanceProperties-Assign RETURNS LOGICAL 
	(  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Loops through the assignable properties for the instance being 
           generated to generate the property setter.
    Notes:
------------------------------------------------------------------------------*/
    define variable cInstanceName as character no-undo.
    def buffer ttProperty for ttProperty.
        
    cInstanceName = dynamic-function('getTokenValue':u in target-procedure, 'InstanceName').
    
    for each ttProperty where
             ttProperty.PropertyOwner = cInstanceName and
             ttProperty.UseInList = yes and
             ttProperty.ForceSet = no
             by ttProperty.PropertyName:

        dynamic-function('setTokenValue' in target-procedure,
                         'PropertyValue',
                         dynamic-function('transmogrifyPropertyValue' in target-procedure,
                                          ttProperty.DataType,
                                          ttProperty.PropertyValue)).
        
        dynamic-function('setTokenValue' in target-procedure,        
                         'PropertyName', ttProperty.PropertyName).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* property list. */
        
    return true.
END FUNCTION.    /* processLoop-instanceProperties-Assign */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenuTranslations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildMenuTranslations Procedure 
FUNCTION buildMenuTranslations RETURNS LOGICAL private ( /*no parameters */ ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Builds menu item translation tables for a given object.
    Notes: - Translations are built here because we need to know if there are 
             any translated menu items when determining the initial 
             ObjectTranslated state.
------------------------------------------------------------------------------*/
    define variable cGenerateLanguages            as character            no-undo.
    define variable cLabel                        as character            no-undo.
    define variable cCaption                      as character            no-undo.
    define variable cTooltip                      as character            no-undo.
    define variable cAccelerator                  as character            no-undo.
    define variable cImage                        as character            no-undo.
    define variable cImageDown                    as character            no-undo.
    define variable cImageInsensitive             as character            no-undo.
    define variable cImage2                       as character            no-undo.
    define variable cImage2Down                   as character            no-undo.
    define variable cImage2Insensitive            as character            no-undo.
    
    define buffer gsclg        for gsc_language.
    define buffer gsmti        for gsm_translated_menu_item.    
    
    empty temp-table ttTranslatedAction.
    
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
    
    for each gsclg no-lock,
       first gsmti where
             gsmti.language_obj = gsclg.language_obj
             no-lock:
        
        if not can-do(cGenerateLanguages, gsclg.language_code) then
            next.
        
        for each ttAction:
            create ttTranslatedAction.
            buffer-copy ttAction to ttTranslatedAction                    
                assign ttTranslatedAction.LanguageCode = gsclg.language_code.
            
            run translateAction in gshTranslationManager ( input  gsclg.language_code,
                                                           input  ttAction.Action,
                                                           output cLabel,
                                                           output cCaption,
                                                           output cTooltip,
                                                           output cAccelerator,
                                                           output cImage,
                                                           output cImageDown,
                                                           output cImageInsensitive,
                                                           output cImage2,
                                                           output cImage2Down,
                                                           output cImage2Insensitive ) no-error.
            
            /* The unknown value signifies that there is no translation for the field. */
            if cLabel ne ? then ttTranslatedAction.Name = cLabel.
            if cCaption ne ? then ttTranslatedAction.Caption = cCaption.
            if cTooltip ne ? then ttTranslatedAction.Tooltip = cTooltip.
            if cAccelerator ne ? then ttTranslatedAction.Accelerator = cAccelerator.
            if cImage ne ? then ttTranslatedAction.Image = cImage.
            if cImageDown ne ? then ttTranslatedAction.ImageDown = cImageDown.
            if cImageInsensitive ne ? then ttTranslatedAction.ImageInsensitive = cImageInsensitive.
            if cImage2 ne ? then ttTranslatedAction.Image2 = cImage2.
            if cImage2Down ne ? then ttTranslatedAction.Image2Down = cImage2Down.
            if cImage2Insensitive ne ? then ttTranslatedAction.Image2Insensitive = cImage2Insensitive.
        end.    /* each action */
    end.    /* each language */
    
    error-status:error = no.
    return true.    
end function.    /* buildMenuTranslations */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildObjectMenuTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildObjectMenuTables Procedure 
FUNCTION buildObjectMenuTables RETURNS LOGICAL PRIVATE
    ( input pdSmartObjectObj        as decimal,
      input pcResultCode            as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Builds object menu tables for a given object.
    Notes:
------------------------------------------------------------------------------*/
    define variable iSequence            as integer                    no-undo.
    define variable iRunAttributeLoop    as integer                    no-undo.
    define variable cObjectRunAttributes as character                  no-undo.
    define variable cRunAttribute        as character                  no-undo.
    define variable lBandHasActions      as logical                    no-undo.
    define variable cMenuStructureItem   as character                  no-undo.
    define variable cChildMenuStructure  as character                  no-undo.
    
    define buffer rycso            for ryc_smartobject.
    define buffer gsmom            for gsm_object_menu_structure.
    define buffer gsmms            for gsm_menu_structure.
    define buffer bGsmms           for gsm_menu_structure.
    define buffer gsmit            for gsm_menu_structure_item.
    define buffer gscia            for gsc_instance_attribute.
    define buffer bttBandToExtract FOR ttBandToExtract.
        
    find rycso where rycso.smartobject_obj = pdSmartObjectObj no-lock no-error.
    if available rycso then 
    DO:
        FOR EACH gsmom WHERE
                 gsmom.object_obj = rycso.smartobject_obj
                 NO-LOCK,
           FIRST gsmms WHERE 
                 gsmms.menu_structure_obj = gsmom.menu_structure_obj
                 no-lock:
                     
            find gscia where
                 gscia.instance_attribute_obj = gsmom.instance_attribute_obj
                 no-lock no-error.
            if available gscia then
                cRunAttribute = gscia.attribute_code.
            else
                cRunAttribute = ''.
            
            IF NOT CAN-FIND(FIRST ttObjectBand WHERE 
                                  ttObjectBand.Band       = gsmms.menu_structure_code and                                  
                                  ttObjectBand.ObjectName = rycso.object_filename and
                                  ttObjectBand.RunAttribute = cRunAttribute         ) THEN 
            DO:
                /* We need to extract the band */
                IF NOT CAN-FIND(FIRST ttBandToExtract WHERE
                                      ttBandToExtract.menu_structure_obj = gsmms.menu_structure_obj) THEN
                DO:
                    CREATE ttBandToExtract.
                    BUFFER-COPY gsmms
                             TO ttBandToExtract
                         ASSIGN iSequence = iSequence + 1
                                ttBandToExtract.extract_sequence = iSequence.
                END.    /* no bandtoextract */
                
                /* Link the band to the object */
                CREATE ttObjectBand.
                ASSIGN ttObjectBand.ObjectName    = rycso.object_filename
                       ttObjectBand.RunAttribute  = cRunAttribute
                       ttObjectBand.Band          = gsmms.menu_structure_code
                       ttObjectBand.Sequence      = gsmom.menu_structure_sequence
                       ttObjectBand.InsertSubmenu = gsmom.insert_submenu.
                       ttObjectBand.ResultCode    = pcResultCode.
            END.        /* no object band */
        END.    /* each objectmenu */
                              
        band-extract-blk:
        FOR EACH ttBandToExtract
                 BY ttBandToExtract.extract_sequence:
                        
            FIND ttBand WHERE ttBand.Band = ttBandToExtract.menu_structure_code NO-ERROR.
        
            /* If the band has not been extracted yet, do so. If it has, we don't have to do anything.
               The relationship between the parent of this band and itself will already have been stored
               when the parent was extracted.
             */
            IF NOT AVAILABLE ttBand THEN 
            DO:
                /* We use lBandHasActions to check if we should create the band record
                   later (only if the band has actions). cMenuStructureItem is used to
                   check if an action has been linked directly to a band.
                 */
                ASSIGN lBandHasActions    = NO
                       cMenuStructureItem = "":U.
            
                /* Do we have an action assigned directly to the structure?
                   If so, extract it and link it. */
                IF ttBandToExtract.menu_item_obj ne 0 THEN 
                ACTION-BLOCK: 
                DO:
                    FIND ttAction WHERE ttAction.menu_item_obj = ttBandToExtract.menu_item_obj NO-ERROR.
                                    
                    /* If we haven't extracted the action yet, do so */
                    IF NOT AVAILABLE ttAction THEN 
                    do:
                        /* Because we reuse this code, and we want to keep it inline, we use an include.
                           The include will check if the action has already been extracted, and create it
                           if it hasn't.
                         */
                        if not {fnarg createActionRecord ttBandToExtract.menu_item_obj} THEN
                            LEAVE ACTION-BLOCK.
                    END.    /* n/a ttaction */
                    ASSIGN cMenuStructureItem = ttAction.Action
                           lBandHasActions    = YES.
                END.    /* action-block: */
                        
                /* Now extract all the menu items for this menu structure */
                structure-item-blk:
                FOR EACH gsmit WHERE 
                         gsmit.menu_structure_obj = ttBandToExtract.menu_structure_obj
                         no-lock:
                                             
                    /* If this band has child bands, create a ttBandToExtract record for each child       *
                     * band to extract.  We populate the cChildMenuStructure so we can create a           *
                     * ttBandAction record between the band currently being processed and the child band. */
                    IF gsmit.child_menu_structure_obj ne 0 THEN 
                    DO:
                        find bgsmms where
                             bgsmms.menu_structure_obj = gsmit.child_menu_structure_obj
                             no-lock no-error.
                        
                        IF AVAILABLE bgsmms THEN 
                        DO:
                            cChildMenuStructure = bgsmms.menu_structure_code.
                                                        
                            IF NOT CAN-FIND(FIRST ttBandToExtract WHERE 
                                                  ttBandToExtract.menu_structure_obj = gsmit.child_menu_structure_obj) THEN 
                            DO:    
                                /* We create these records to take care of recursive menu structures. */
                                CREATE bttBandToExtract.
                                BUFFER-COPY bgsmms TO bttBandToExtract
                                    ASSIGN iSequence = iSequence + 1
                                           bttBandToExtract.extract_sequence = iSequence
                                           bttBandToExtract.parent_menu_structure_code = ttBandToExtract.menu_structure_code.
                            END.    /* no band-to-extract */
                        END.    /* avialable menu struct */
                    END.    /* structure-item-blk: */
                    ELSE
                        cChildMenuStructure = "":U.
                                
                    /* Extract menu items for this band */
                    IF gsmit.menu_item_obj ne 0 THEN 
                    DO:
                        FIND ttAction WHERE 
                             ttAction.menu_item_obj = gsmit.menu_item_obj
                             NO-ERROR.
                                                
                        /* If we haven't extracted the action yet, do so */
                        IF NOT AVAILABLE ttAction THEN 
                        DO:
                            if NOT {fnarg createActionRecord gsmit.menu_item_obj} THEN
                                NEXT structure-item-blk.                                                                           
                        END.        /* n/a action */
                            
                        /* Store the relationship between the band and action */
                        create ttBandAction.
                        ASSIGN ttBandAction.band      = ttBandToExtract.menu_structure_code
                               ttBandAction.childband = cChildMenuStructure
                               ttBandAction.action    = ttAction.Action
                               ttBandAction.sequence  = gsmit.menu_item_sequence
                               lBandHasActions        = YES.
                    END.    /* get the items for menu */
                END.    /* structure-item-blk:  */
                    
                /* If we could find actions for this band, create the band. */
                IF lBandHasActions THEN 
                DO:
                    CREATE ttBand.
                    ASSIGN ttBand.BandLabelAction = cMenuStructureItem /* Only if a menu_item_obj has been assigned on the structure directly */
                           ttBand.Band            = ttBandToExtract.menu_structure_code
                           ttBand.BandType        = ttBandToExtract.menu_structure_type
                           ttBand.ButtonSpacing   = ttBandToExtract.control_spacing
                           ttBand.ButtonPadding   = ttBandToExtract.control_padding.
                END.    /* band has actions */
                ELSE
                /* We aren't creating the band, but we might already have stored a relationship between it and
                   a parent band.  Make sure we don't have any "limbo" relationships.
                 */
                FOR EACH ttBandAction WHERE 
                         ttBandAction.childBand = ttBandToExtract.menu_structure_code:
                             
                    /* If an action was linked directly to the band, just clear the childBand link,
                       else delete the record.
                     */
                    IF ttBandAction.action eq "":U THEN
                        DELETE ttBandAction.
                    ELSE
                        ASSIGN ttBandAction.childBand = "":U.
                END.    /* each band action, no actions on band */
            END.    /* n/a band */
        END.    /* band-extract-blk: */
    END.    /* available object */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* buildObjectMenuTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildToolbarMenuTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildToolbarMenuTables Procedure 
FUNCTION buildToolbarMenuTables RETURNS LOGICAL PRIVATE
    ( input pdSmartObjectObj        as decimal,
      input pcResultCode            as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Builds toolbar menus for a given object.
    Notes:
------------------------------------------------------------------------------*/
    define variable iSequence            as integer                    no-undo.
    define variable lBandHasActions      as logical                    no-undo.
    define variable cMenuStructureItem   as character                  no-undo.
    define variable cChildMenuStructure  as character                  no-undo.
    
    define buffer rycso            for ryc_smartobject.
    define buffer gsmtm            for gsm_toolbar_menu_structure.
    define buffer gsmms            for gsm_menu_structure.
    define buffer bGsmms           for gsm_menu_structure.
    define buffer gsmit            for gsm_menu_structure_item.
    define buffer bttBandToExtract FOR ttBandToExtract.
        
    find rycso where rycso.smartobject_obj = pdSmartObjectObj no-lock no-error.
    if available rycso then 
    DO:
        FOR EACH gsmtm WHERE
                 gsmtm.object_obj = rycso.smartobject_obj
                 NO-LOCK,
           FIRST gsmms WHERE 
                 gsmms.menu_structure_obj = gsmtm.menu_structure_obj
                 no-lock:

            IF NOT CAN-FIND(FIRST ttToolbarBand WHERE 
                                  ttToolbarBand.Band       = gsmms.menu_structure_code and
                                  ttToolbarBand.ToolbarName = rycso.object_filename) THEN 
            DO:
                /* We need to extract the band */
                IF NOT CAN-FIND(FIRST ttBandToExtract WHERE
                                      ttBandToExtract.menu_structure_obj = gsmms.menu_structure_obj) THEN
                DO:
                    CREATE ttBandToExtract.
                    BUFFER-COPY gsmms
                             TO ttBandToExtract
                         ASSIGN iSequence = iSequence + 1
                                ttBandToExtract.extract_sequence = iSequence.
                END.    /* no bandtoextract */

                /* Link the band to the toolbar */
                CREATE ttToolbarBand.
                ASSIGN ttToolbarBand.ToolbarName = rycso.object_filename
                       ttToolbarBand.Sequence    = gsmtm.menu_structure_sequence
                       ttToolbarBand.Band        = gsmms.menu_structure_code
                       ttToolbarBand.Alignment   = gsmtm.menu_structure_alignment
                       ttToolbarBand.InsertRule  = gsmtm.insert_rule
                       ttToolbarBand.RowPosition = gsmtm.menu_structure_row
                       ttToolbarBand.Spacing     = gsmtm.menu_structure_spacing
                       ttToolbarBand.ResultCode  = pcResultCode.
            END.        /* no object band */
        END.    /* each toolbar menu */
        
        band-extract-blk:
        FOR EACH ttBandToExtract
                 BY ttBandToExtract.extract_sequence:
                        
            FIND ttBand WHERE ttBand.Band = ttBandToExtract.menu_structure_code NO-ERROR.
        
            /* If the band has not been extracted yet, do so. If it has, we don't have to do anything.
               The relationship between the parent of this band and itself will already have been stored
               when the parent was extracted.
             */
            IF NOT AVAILABLE ttBand THEN 
            DO:
                /* We use lBandHasActions to check if we should create the band record
                   later (only if the band has actions). cMenuStructureItem is used to
                   check if an action has been linked directly to a band.
                 */
                ASSIGN lBandHasActions    = NO
                       cMenuStructureItem = "":U.
            
                /* Do we have an action assigned directly to the structure?
                   If so, extract it and link it. */
                IF ttBandToExtract.menu_item_obj ne 0 THEN 
                ACTION-BLOCK: 
                DO:
                    FIND ttAction WHERE ttAction.menu_item_obj = ttBandToExtract.menu_item_obj NO-ERROR.
                                    
                    /* If we haven't extracted the action yet, do so */
                    IF NOT AVAILABLE ttAction THEN 
                    do:
                        /* Because we reuse this code, and we want to keep it inline, we use an include.
                           The include will check if the action has already been extracted, and create it
                           if it hasn't.
                         */
                        if not {fnarg createActionRecord ttBandToExtract.menu_item_obj} THEN
                            LEAVE ACTION-BLOCK.
                    END.    /* n/a ttaction */
                    ASSIGN cMenuStructureItem = ttAction.Action
                           lBandHasActions    = YES.
                END.    /* action-block: */
                        
                /* Now extract all the menu items for this menu structure */
                structure-item-blk:
                FOR EACH gsmit WHERE 
                         gsmit.menu_structure_obj = ttBandToExtract.menu_structure_obj
                         no-lock:
                                         
                    /* If this band has child bands, create a ttBandToExtract record for each child       *
                     * band to extract.  We populate the cChildMenuStructure so we can create a           *
                     * ttBandAction record between the band currently being processed and the child band. */
                    IF gsmit.child_menu_structure_obj ne 0 THEN 
                    DO:
                        FIND bgsmms WHERe
                             bgsmms.menu_structure_obj = gsmit.child_menu_structure_obj
                             NO-LOCK NO-ERROR.
                                                     
                        IF AVAILABLE bgsmms THEN 
                        DO:
                            cChildMenuStructure = bgsmms.menu_structure_code.
                                                        
                            IF NOT CAN-FIND(FIRST ttBandToExtract WHERE 
                                                  ttBandToExtract.menu_structure_obj = gsmit.child_menu_structure_obj) THEN 
                            DO:    
                                /* We create these records to take care of recursive menu structures. */
                                CREATE bttBandToExtract.
                                BUFFER-COPY bgsmms TO bttBandToExtract
                                    ASSIGN iSequence = iSequence + 1
                                           bttBandToExtract.extract_sequence = iSequence
                                           bttBandToExtract.parent_menu_structure_code = ttBandToExtract.menu_structure_code.
                            END.    /* no band-to-extract */
                        END.    /* avialable menu struct */
                    END.    /* structure-item-blk: */
                    ELSE
                        cChildMenuStructure = "":U.
                                
                    /* Extract menu items for this band */
                    IF gsmit.menu_item_obj ne 0 THEN 
                    DO:
                        FIND ttAction WHERE 
                             ttAction.menu_item_obj = gsmit.menu_item_obj
                             NO-ERROR.
                                                
                        /* If we haven't extracted the action yet, do so */
                        IF NOT AVAILABLE ttAction THEN 
                        DO:
                            if NOT {fnarg createActionRecord gsmit.menu_item_obj} THEN
                                NEXT structure-item-blk.                                                                           
                        END.        /* n/a action */
                            
                        /* Store the relationship between the band and action */
                        create ttBandAction.
                        ASSIGN ttBandAction.band      = ttBandToExtract.menu_structure_code
                               ttBandAction.childband = cChildMenuStructure
                               ttBandAction.action    = ttAction.Action
                               ttBandAction.sequence  = gsmit.menu_item_sequence
                               lBandHasActions        = YES.
                    END.    /* get the items for menu */
                END.    /* structure-item-blk:  */
                
                /* If we could find actions for this band, create the band. */
                IF lBandHasActions THEN 
                DO:
                    CREATE ttBand.
                    ASSIGN ttBand.BandLabelAction = cMenuStructureItem /* Only if a menu_item_obj has been assigned on the structure directly */
                           ttBand.Band            = ttBandToExtract.menu_structure_code
                           ttBand.BandType        = ttBandToExtract.menu_structure_type
                           ttBand.ButtonSpacing   = ttBandToExtract.control_spacing
                           ttBand.ButtonPadding   = ttBandToExtract.control_padding.
                END.    /* band has actions */
                ELSE
                /* We aren't creating the band, but we might already have stored a relationship between it and
                   a parent band.  Make sure we don't have any "limbo" relationships.
                 */
                FOR EACH ttBandAction WHERE 
                         ttBandAction.childBand = ttBandToExtract.menu_structure_code:
                             
                    /* If an action was linked directly to the band, just clear the childBand link,
                       else delete the record.
                     */
                    IF ttBandAction.action eq "":U THEN
                        DELETE ttBandAction.
                    ELSE
                        ASSIGN ttBandAction.childBand = "":U.
                END.    /* each band action, no actions on band */
            END.    /* n/a band */
        END.    /* band-extract-blk: */
    END.    /* available object */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* buildToolbarMenuTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createActionRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createActionRecord Procedure 
FUNCTION createActionRecord RETURNS LOGICAL PRIVATE
        ( input pdMenuItemObj as decimal ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Creates action records for toolbar and/or object menus
    Notes:
------------------------------------------------------------------------------*/
    define variable lPersistent           as logical                  no-undo.
    define variable cLogicalObject        as character                no-undo.
    define variable cRequiredDbList       as character                no-undo.
    define variable cAttribute            as character                no-undo.
    
    define buffer rycso        for ryc_smartobject.
    define buffer parent_gscic for gsc_item_category.
    define buffer gscic        for gsc_item_category.
    define buffer gsmmi        for gsm_menu_item.
    define buffer gscia        for gsc_instance_attribute.
    
    find gsmmi where gsmmi.menu_item_obj = pdMenuItemObj no-lock no-error.
    /* Conditions to skip creation of this action for */
    if not available gsmmi or
       (gsmmi.disabled and gsmmi.hide_if_disabled) then
        return false.       
        
    IF gsmmi.item_select_type eq 'Launch':U THEN 
    rycso-fetch-blk: 
    DO:     
        /* Now find the detail of the container we want to launch */
        FIND rycso WHERE rycso.smartobject_obj = gsmmi.object_obj NO-LOCK NO-ERROR.    
        IF NOT AVAILABLE rycso THEN
            RETURN false.
            
        ASSIGN lPersistent     = rycso.run_persistent
               cLogicalObject  = rycso.object_filename
               cRequiredDbList = rycso.required_db_list
               cAttribute      = "":U.
        
        /* If the action has an instance attribute - read it and save it */      
        IF gsmmi.instance_attribute_obj gt 0 THEN 
        DO:
            FIND gscia WHERE gscia.instance_attribute_obj = gsmmi.instance_attribute_obj NO-LOCK NO-ERROR.
            IF AVAILABLE gscia THEN
                ASSIGN cAttribute = gscia.attribute_code.
        END.        /* has an attribute */
    END.    /* rycso-fetch-blk: */
    ELSE
        ASSIGN lPersistent     = NO
               cLogicalObject  = "":U
               cRequiredDBList = "":U
               cAttribute      = "":U.
    
    /* Create the action and assign values */
    CREATE ttAction.           
    ASSIGN ttAction.menu_item_obj      = gsmmi.menu_item_obj
           ttAction.Action             = gsmmi.menu_item_reference
           ttAction.Name               = gsmmi.item_toolbar_label
           ttAction.Caption            = gsmmi.menu_item_label
           ttAction.Tooltip            = gsmmi.tooltip_text
           ttAction.SubstituteProperty = gsmmi.substitute_text_property
           ttAction.Image              = gsmmi.image1_up_filename
           ttAction.ImageDown          = gsmmi.image1_down_filename
           ttAction.ImageInsensitive   = gsmmi.image1_insensitive_filename 
           ttAction.Image2             = gsmmi.image2_up_filename
           ttAction.Image2Down         = gsmmi.image2_down_filename
           ttAction.Image2Insensitive  = gsmmi.image2_insensitive_filename 
           ttAction.Accelerator        = gsmmi.shortcut_key
           ttAction.Description        = gsmmi.menu_item_description
           ttAction.SecurityToken      = gsmmi.security_token
           ttAction.EnableRule         = gsmmi.enable_rule      
           ttAction.DisableRule        = gsmmi.disable_rule      
           ttAction.HideRule           = gsmmi.hide_rule     
           ttAction.ImageAlternateRule = gsmmi.image_alternate_rule
           ttAction.Link               = gsmmi.item_link 
           ttAction.RunParameter       = gsmmi.item_select_parameter
           ttAction.Type               = gsmmi.item_select_type
           ttAction.ControlType        = gsmmi.item_control_type
           ttAction.InitCode           = gsmmi.item_menu_drop  
           ttAction.createEvent        = gsmmi.on_create_publish_event 
           ttAction.OnChoose           = gsmmi.item_select_action      
           ttAction.SystemOwned        = gsmmi.system_owned
           ttAction.PhysicalObjectName = ''         /* The rendering procedure will resolve */
           ttAction.LogicalObjectName  = cLogicalObject
           ttAction.RunAttribute       = cAttribute
           ttAction.RunPersistent      = lPersistent
           ttAction.DbRequiredList     = cRequiredDBList
           ttAction.Disabled           = gsmmi.disabled.
    
    /* If the action is linked to an item category, create an item category record. */
    IF gsmmi.item_category_obj ne 0 THEN 
    DO:
        FIND ttCategory WHERE 
             ttCategory.item_category_obj = gsmmi.item_category_obj
             NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE ttCategory THEN 
        DO:
            FIND gscic WHERE gscic.item_category_obj = gsmmi.item_category_obj no-lock NO-ERROR.    
            IF AVAILABLE gscic THEN 
            DO:
                CREATE ttCategory.
                ASSIGN ttCategory.item_category_obj = gsmmi.item_category_obj
                       ttCategory.Category    = gscic.item_category_label
                       ttCategory.Link        = gscic.item_link
                       ttCategory.systemowned = gscic.system_owned
                       ttAction.Category      = ttCategory.Category
                       ttAction.Link          = IF ttAction.Link eq '':U THEN ttCategory.Link
                                                ELSE ttAction.Link.
                
                IF gscic.parent_item_category_obj ne 0 THEN 
                DO:
                    FIND parent_gscic WHERE
                         parent_gscic.item_category_obj = gscic.parent_item_category_obj
                         NO-LOCK NO-ERROR.
                    IF AVAILABLE parent_gscic THEN
                        ASSIGN ttCategory.ParentCategory = parent_gscic.item_category_label.
                END.        /* avail parent item category */
            END.    /* avail item category*/
        END.
        ELSE
            ASSIGN ttAction.Category = ttCategory.Category
                   ttAction.Link     = IF ttAction.Link eq '':U THEN ttCategory.Link
                                       ELSE ttAction.Link.
    END.    /* there is a item category */

    error-status:error = no.
    return true.
END FUNCTION.    /* createActionRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyGenerator Procedure 
FUNCTION destroyGenerator RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Override of shutdown event.
    Notes: 
------------------------------------------------------------------------------*/
    define variable lSuper        as logical    initial ? no-undo.
    
    /* don't want memory leaks */
    for each ttWidgetHandle:
        delete object ttWidgetHandle.WidgetHandle no-error.
        delete ttWidgetHandle.
    end.    /* each widget handle */
    
    /* run up the stack of hook procedures, if any. */
    lSuper = super() no-error.
    if lSuper eq ? then
        lSuper = yes.
    
    /* reset the numeric and date formats back to the original from
       American. */
    session:date-format = dynamic-function('getTokenValue' in target-procedure, 'Session_DateFormat').
    session:set-numeric-format(dynamic-function('getTokenValue' in target-procedure, 'Session_NumericSeparator'),
                               dynamic-function('getTokenValue' in target-procedure, 'Session_DecimalPoint')).    
    
    error-status:error = no.
    return lSuper.
END FUNCTION.    /* destroyGenerator */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findAttributeValue Procedure 
FUNCTION findAttributeValue RETURNS CHARACTER
    ( input pcAttributeLabel     as character,
      input pcObjectName         as character   ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Returns an attribute value from either the master object or class.
    Notes:
------------------------------------------------------------------------------*/
    define variable cAttributeValue            as character            no-undo.
    define variable cResultCodes               as character            no-undo.
    define variable cResultCode                as character            no-undo.
    define variable iResultCodeLoop            as integer              no-undo.
    define variable lFoundAttributeValue       as logical              no-undo.
    
    define buffer ryccr        for ryc_customization_result.
    define buffer rycav        for ryc_attribute_value.
    define buffer rycat        for ryc_attribute.
    define buffer gscot        for gsc_object_type.
    define buffer rycso        for ryc_smartobject.
    
    cResultCodes = dynamic-function('getTokenValue' in target-procedure, 'GenerateResultCodes').
    lFoundAttributeValue = no.
    
    RESULT-CODE-LOOP:
    do iResultCodeLoop = 1 to num-entries(cResultCodes) while not lFoundAttributeValue:
        
        cResultCode = entry(iResultCodeLoop, cResultCodes).
        
        find ryccr where ryccr.customization_result_code = cResultCode no-lock no-error.
        if not available ryccr and cResultCode ne '{&default-result-code}' then
            next.
        
        find rycso where
             rycso.object_filename = pcObjectName and
             rycso.customization_result_obj = (if available ryccr then ryccr.customization_result_obj else 0)
         no-lock no-error.
        if available rycso then
        do:
            /* Find the object type in case we need to look at the class. */
            if not available gscot then
                find gscot where
                     gscot.object_type_obj = rycso.object_type_obj
                     no-lock no-error.
            
            find first rycav where
                       rycav.object_type_obj = rycso.object_type_obj and
                       rycav.smartobject_obj = rycso.smartobject_obj and
                       rycav.object_instance_obj = 0 and
                       rycav.render_type_obj = 0 and
                       rycav.attribute_label = pcAttributeLabel
                       no-lock no-error.
            
            if available rycav then
            do:
                find rycat where rycat.attribute_label = rycav.attribute_label no-lock no-error.
                CASE rycat.data_type:
                    WHEN {&DECIMAL-DATA-TYPE} THEN cAttributeValue = string(rycav.decimal_value).
                    WHEN {&INTEGER-DATA-TYPE} THEN cAttributeValue = STRING(rycav.integer_value).
                    WHEN {&DATE-DATA-TYPE}    THEN cAttributeValue = STRING(rycav.date_value).
                    WHEN {&RAW-DATA-TYPE}     THEN cAttributeValue = STRING(rycav.raw_value).
                    WHEN {&LOGICAL-DATA-TYPE} THEN cAttributeValue = STRING(rycav.logical_value).
                    OTHERWISE cAttributeValue = rycav.character_value.
                END CASE.   /* data type */
                
                lFoundAttributeValue = yes.
            end.    /* available rycav */
        end.    /* available object */
    end.    /* RESULT-CODE-LOOP: result code loop */
    
    /* No attribute against the object? Then look at the class */
    if not lFoundAttributeValue then
        run getClassProperties in gshRepositoryManager (input        gscot.object_type_code,        
                                                        input-output pcAttributeLabel,
                                                              output cAttributeValue    ).    
    
    error-status:error = no.
    return cAttributeValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInConstructor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION generateSuperInConstructor Procedure 
FUNCTION generateSuperInConstructor RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns an indication of whether the super procedures must be generated
           into the newInstance() constructor nor not.
    Notes: 
------------------------------------------------------------------------------*/
    define variable lGenerateInConstructor        as logical            no-undo.
    define variable cGenerateOption               as character          no-undo.
    
    cGenerateOption = dynamic-function('getTokenValue' in target-procedure,
                                       'GenerateSuperLocation').
    
    /* Default to generating into constructor. */
    if cGenerateOption eq '' or
       cGenerateOption eq ? or
       not can-do('Property,Inline', cGenerateOption) then
        lGenerateInConstructor = yes.
    else
        lGenerateInConstructor = no.
    
    error-status:error = no.
    return lGenerateInConstructor.
END FUNCTION.    /* generateSuperInConstructor */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInline) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION generateSuperInline Procedure 
FUNCTION generateSuperInline RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns an indication of whether the super procedures must be generated
           into the body of the generated obejct or not.
    Notes: * Always returns false. For the time being, this functionality is
                 disabled.
------------------------------------------------------------------------------*/    
    define variable cGenerateOption         as character          no-undo.
    
    cGenerateOption = dynamic-function('getTokenValue' in target-procedure,
                                       'GenerateSuperLocation').
    
    error-status:error = no.
    /*return (cGenerateOption eq 'Inline').*/
    return false.
END FUNCTION.    /* generateSuperInline */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateSuperInProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION generateSuperInProperty Procedure 
FUNCTION generateSuperInProperty RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    define variable cGenerateOption         as character          no-undo.
    
    cGenerateOption = dynamic-function('getTokenValue' in target-procedure,
                                       'GenerateSuperLocation').
    
    error-status:error = no.
    return (cGenerateOption eq 'Property').
END FUNCTION.    /* generateSuperInProperty */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInitPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitPages Procedure 
FUNCTION getInitPages RETURNS CHARACTER
    ( input pcCurrentPageRef        as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Gets a list of pages to initialise for the specified page.
    Notes:
------------------------------------------------------------------------------*/
    define variable cInitPages            as character                no-undo.
    define variable cInitialPageList      as character                no-undo.
    define variable cInstanceName         as character                no-undo.
    define variable cObjectName           as character                no-undo.
    define variable lCreateProperty       as logical                  no-undo.
    define variable lInitPage             as logical     extent 100   no-undo.
    define variable iLoop                 as integer                  no-undo.
    define variable iNumberOfPages        as integer                  no-undo.
    
    define buffer lbLink    for ttLink.
    define buffer lbPage    for ttPage.
    
    /* Look upstream for All links except Update */
    for each ttLink where
             ttLink.TargetPageRef = pcCurrentPageRef and
             ttLink.LinkName <> 'Update',
       first lbPage where
             lbPage.PageReference = ttLink.SourcePageRef:
        
        /* Don't add this page or page zero. page zero has
           already been started.
         */
        if lbPage.PageReference eq pcCurrentPageRef or
           lbPage.PageReference eq 'Page0' then
            next.
        
        /* Add it to the list */
        if not can-do(cInitPages, string(lbPage.PageNumber)) then
            cInitPages = cInitPages + ",":U + string(lbPage.PageNumber).
    end.    /* upstream for Non-UpdateLinks */
    
    /* Look downstream for any Update links. */
    for each ttLink where
             ttLink.LinkName = 'Update' and
             ttLink.SourcePageRef = pcCurrentPageRef,
       first lbPage where
             lbPage.PageReference = ttLink.TargetPageRef:
        
        /* Don't add this page or page zero. page zero has
           already been started.
         */        
        if lbPage.PageReference eq pcCurrentPageRef or
           lbPage.PageReference eq 'Page0' then
            next.
        
        /* Add it to the list */
        if not can-do(cInitPages, string(lbPage.PageNumber)) then
            cInitPages = cInitPages + ",":U + string(lbPage.PageNumber).
    end.    /* Downstream for Update links */
    
    /* If this is page 0, then also look at the pages defined by
       the InitialPageList property.
     */
    if pcCurrentPageRef eq 'Page0' then
    do:
        cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
        
        find first ttProperty where
                   ttProperty.PropertyName = 'InitialPageList' and
                   ttProperty.PropertyOwner = cObjectName
                   no-error.
        if available ttProperty then
            cInitialPageList = ttProperty.PropertyValue.
        else
            cInitialPageList = dynamic-function('findAttributeValue' in target-procedure,
                                                'InitialPageList', cObjectName).
        if cInitialPageList eq ? then
            cInitialPageList = ''.
         
        case cInitialPageList:
            when '*' then
            do:
                cInitialPageList = ''.
                for each ttPage by ttPage.PageNumber:
                    cInitialPageList = cInitialPageList + ',' + string(ttPage.PageNumber).
                end.    /* each page */
                cInitialPageList = left-trim(cInitialPageList, ',').
            end.    /* '*' */
            when '' then
            do:
                cInitialPageList = '0'.
                /* At this stage, there */
                find ttProperty where
                     ttProperty.PropertyName = 'StartPage' and
                     ttProperty.PropertyOwner = cObjectName
                     no-error.
                if available ttProperty then
                    cInitialPageList = cInitialPageList + ',' + ttProperty.PropertyValue.
            end.    /* '' */
        end case.    /* initial value */
        
        lCreateProperty = not available ttProperty.
                
        /* If there is no initial page list property, make sure one is set. */
        if lCreateProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyName = 'InitialPageList'
                   ttProperty.PropertyOwner = cObjectName
                   ttProperty.PropertyValue = cInitialPageList
                   ttProperty.UseInList = no
                   ttProperty.ForceSet = no
                   ttProperty.DataType = 'Character'
                   .
        end.    /* no property available */
        
        /* Add the InitialPageList to the list of pages to init. */
        do iLoop = 1 to num-entries(cInitialPageList):
            if not can-do(cInitPages, entry(iLoop, cInitialPageList)) then
                cInitPages = cInitPages + ',' + entry(iLoop, cInitialPageList).
        end.    /* loop through initial pages */
    end.    /* page 0 */
    cInitPages = left-trim(cInitPages, ',').
    
    /* page 0 is never init'ed from any page. 
     */
    if cInitPages eq '0' then
        cInitPages = ''.
    
    /* Make pages init in numerical order. */
    assign lInitPage = no
           iNumberOfPages = num-entries(cInitPages).
    if iNumberOfPages gt 1 then
    do:
        /* Store the ordered list.
           we need to add 1 to the extent because page 0 may be
           in this list.
         */        
        do iLoop = 1 to iNumberOfPages:
            lInitPage[integer(entry(iLoop, cInitPages)) + 1] = yes.
        end.    /* loop through initPages */
            
        /* rebuild the initpages list. the loop goes from 
           2 (which equates to page 1) since we don't want to 
           add page 0 to this list.
         */
        cInitPages = ''.
        do iLoop = 2 to extent(lInitPage) while iNumberOfPages gt 0:
            if lInitPage[iLoop] then
                assign cInitPages = cInitPages + ',' + string(iLoop - 1)
                       iNumberOfPages = iNumberOfPages - 1.
        end.    /* loop through */
        cInitPages = left-trim(cInitPages, ',').
    end.    /* more than on page being init'ed. */
    
    error-status:error = no.
    return cInitPages.
END FUNCTION.    /* getInitPages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceCleanName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceCleanName Procedure 
FUNCTION getInstanceCleanName RETURNS CHARACTER PRIVATE
        ( input pcInstanceName as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Returns a widget handle name (not a value!) based on the instance
           name passed in.
    Notes: * periods (.) are stripped out
           * parentheses are removed
           * right parents (')') are replaced by a dash '-'.
           * spaces are replaced by a dash '-'
           * angle brackets are stripped out
           * quotes are removed (singel and double)
           * anything that would prevent the output of this function from
             being used as a variable or procedure name is removed.
           * 'h_' is prepended           
           * Name should be <= 32 chars           
           * If a name conflict is found, then a counter is appended
------------------------------------------------------------------------------*/
    define variable iCnt            as integer no-undo.
    
    define buffer lbInstance for ttInstance.
    
    if pcInstanceName eq 'This-Procedure' then
        pcInstanceName = 'Target-Procedure'.
    else
    do:
        assign pcInstanceName = replace(pcInstanceName, '.':u, '':u)
               pcInstanceName = replace(pcInstanceName, ')':u, '':u)
               pcInstanceName = replace(pcInstanceName, '<':u, '':u)
               pcInstanceName = replace(pcInstanceName, '>':u, '':u)
               pcInstanceName = replace(pcInstanceName, '"':u, '':u)
               pcInstanceName = replace(pcInstanceName, "'":u, '':u)
               pcInstanceName = replace(pcInstanceName, '=':u, '':u)
               pcInstanceName = replace(pcInstanceName, '?':u, '':u)
               pcInstanceName = replace(pcInstanceName, '|':u, '':u)
               pcInstanceName = replace(pcInstanceName, ':':u, '':u)
               pcInstanceName = replace(pcInstanceName, '/':u, '':u)
               pcInstanceName = replace(pcInstanceName, '!':u, '':u)
               pcInstanceName = replace(pcInstanceName, '@':u, '':u)
               pcInstanceName = replace(pcInstanceName, '^':u, '':u)
               pcInstanceName = replace(pcInstanceName, '+':u, '':u)
               pcInstanceName = replace(pcInstanceName, '*':u, '':u)

               pcInstanceName = replace(pcInstanceName, ' ':u, '-':u)
               pcInstanceName = replace(pcInstanceName, '(':u, '-':u)

               pcInstanceName = 'h_' + pcInstanceName.
    
        /* Get rid of double dashes */
        repeat while index(pcInstanceName, '--':u) gt 0:
            pcInstanceName = replace(pcInstanceName, '--':u, '-':u).
        end.
        
        /* We're limited to 32 chars for variable names. Instance
           names are unique, so we need to make sure that the new
           'clean' name is also unique. */
        pcInstanceName = substring(pcInstanceName, 1, 32).
        iCnt = 1.
        find first lbInstance where
                   lbInstance.CleanName = pcInstanceName
                   no-error.
        repeat while available lbInstance:
            pcInstanceName = substring(pcInstanceName, 1, 30) + '-':u + string(iCnt).
            iCnt = iCnt + 1.
            find first lbInstance where
                       lbInstance.CleanName = pcInstanceName
                       no-error.
        end.    /* repeat */
    end.    /* a specific name */
    
    error-status:error = no.
    return pcInstanceName.
END FUNCTION.    /* getInstanceCleanName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceHandleName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceHandleName Procedure 
FUNCTION getInstanceHandleName RETURNS CHARACTER
    ( input pcInstanceName    as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns a widget handle name (not a value!) based on the instance
           name passed in.
    Notes: * This name is build in getInstanceCleanName().
------------------------------------------------------------------------------*/
    define buffer lbInstance for ttInstance.
    find first lbInstance where
               lbInstance.InstanceName = pcInstanceName
               no-error.
    
    error-status:error = no.
    return (if available lbInstance then lbInstance.CleanName else pcInstanceName).
END FUNCTION.    /* getInstanceHandleName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStartPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStartPage Procedure 
FUNCTION getStartPage RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns the start page for a container object.  
    Notes:
------------------------------------------------------------------------------*/
    define variable iStartPage                    as integer            no-undo.
    define variable iLoop                         as integer            no-undo.
    define variable cInitialPageList              as character          no-undo.
    define variable cObjectName                   as character          no-undo.
    define variable lCreateProperty               as logical            no-undo.
    define variable lMultiPageContainer           as logical            no-undo.
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    
    /* If we are on page 0, and a start page other than page 0 has been specified, ensure 
       it is a valid page. If not, set the StartPage to page 0.
       Also make sure that if there is an initial page list, that the StartPage 
       is part of that list.
     */
    find first ttPage where ttPage.PageNumber > 0 no-error.
    lMultiPageContainer = available ttPage.
    
    find ttProperty where
         ttProperty.PropertyName = 'StartPage' and
         ttProperty.PropertyOwner = cObjectName
         no-error.
    if available ttProperty then
        iStartPage = integer(ttProperty.PropertyValue).
    else
    if lMultiPageContainer then
        iStartPage = integer(dynamic-function('findAttributeValue' in target-procedure,
                                              'StartPage', cObjectName)) no-error.
    
    lCreateProperty = not available(ttProperty).
    
    if lMultiPageContainer then
    do:
        /* Make sure that we are working with a valid value. */
        if iStartPage eq ? or iStartPage lt 0 then
            iStartPage = 0.
        /* By now there should be a property record with the
           InitialPageList, resolved from '*' if necessary.
         */
        find ttProperty where
             ttProperty.PropertyName = 'InitialPageList' and
             ttProperty.PropertyOwner = cObjectName
             no-error.
        if available ttProperty then
            cInitialPageList = ttProperty.PropertyValue.
    
        /* If there is an initial page list set, we must be sure that the
           start page is in that initial list. If not, we set the start page to 
           the first available page in the that list.
         */
        if cInitialPageList eq '' then
            find ttPage where ttPage.PageNumber = iStartPage no-error.
        else
        do:
            /* only do check if start page non-zero */
            if iStartPage ne 0 and can-do(cInitialPageList, string(iStartPage)) then
            do:
                find ttPage where ttPage.PageNumber = iStartPage no-error.
                /* If the record is not available here, it means that there is something
                   wrong with the StartPage property. We now need to find a page that is
                   in the InitialPageList property.
                 */
                if not available ttPage then
                do iLoop = 1 to num-entries(cInitialPageList)
                   while not available ttPage:
                    iStartPage = integer(entry(iLoop, cInitialPageList)) no-error.
                    find ttPage where ttPage.PageNumber = iStartPage no-error.
                end.    /* INITIAL-PAGE-LOOP: no page */
            end.    /* start page non-zero */
        end.    /* there are initial pages set */        
        
        /* If there still is no record available, then we start at the first available page.
           At this stage we just need to make sure that we start with any page. 
         */
        if not available ttPage or iStartPage eq 0 then
            find first ttPage where
                       ttPage.PageNumber > 0
                       no-error.
        if available ttPage then
            iStartPage = ttPage.PageNumber.
    end.    /* multi-page container */
    else
        /* No-page containers can only have 0 as a start page. */
        iStartPage = 0.
        
    /* If there is no initial page list property, make sure one is set. */
    if lCreateProperty then
    do:
        create ttProperty.
        assign ttProperty.PropertyName = 'StartPage'
               ttProperty.PropertyOwner = cObjectName
               ttProperty.UseInList = no
               ttProperty.ForceSet = no
               ttProperty.DataType = 'Integer'.
    end.    /* no property available */
    else
        find ttProperty where
             ttProperty.PropertyOwner = cObjectName and
             ttProperty.PropertyName = 'StartPage'.
    
    /* update the property */
    ttProperty.PropertyValue = string(iStartPage).
    
    error-status:error = no.    
    return ttProperty.PropertyValue.
END FUNCTION.    /* getStartPage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToken-OutputFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToken-OutputFilename Procedure 
FUNCTION getToken-OutputFilename RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
 Purpose: Returns the value of the OutputFilename token. This is the location where
          the generated object will be written.
   Notes: 
------------------------------------------------------------------------------*/    
    define variable cOutputFilename         as character                no-undo.
    define variable cObjectName             as character                no-undo.
    define variable cObjectExtension        as character                no-undo.
    define variable cObjectPath             as character                no-undo.
    define variable cOutputRoot             as character                no-undo.
    define variable cResultCodes            as character                no-undo.
    define variable lCustomizationsExist    as logical                  no-undo.
        
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    cObjectExtension = dynamic-function('getTokenValue' in target-procedure, 'ObjectExtension').
    /* Default to pgen extension */
    if cObjectExtension eq ? then
        cObjectExtension = 'pgen'.
    
    assign cObjectPath = dynamic-function('getTokenValue' in target-procedure, 'ObjectPath')
           cObjectPath = replace(cObjectPath, '~\', '/')
           cObjectPath = right-trim(cObjectPath, '/').
    if cObjectPath eq ? then
        cObjectPath = ''.
    
    assign cOutputRoot = dynamic-function('getTokenValue' in target-procedure, 'GenerateFileRoot')
           cOutputRoot = replace(cOutputRoot, '~\', '/')
           cOutputRoot = right-trim(cOutputRoot, '/').
    if cOutputRoot eq ? then
        cOutputRoot = '.'.
    
    lCustomizationsExist = logical(dynamic-function('getTokenValue' in target-procedure,
                                                    'CustomizationsExist')) no-error.
    
    /* err on the side of caution. rather make sure that
       we create an extra file than we create a default file
       containing customisations.
     */
    if lCustomizationsExist eq ? then
        lCustomizationsExist = yes.
    
    /* Make sure that the directory exists */
    cOutputRoot = cOutputRoot
                + (if cObjectPath eq '' then '' else ('/' + cObjectPath)).
    
    file-info:file-name = cOutputRoot.
    if file-info:full-pathname eq ? then
        dynamic-function('createFolder' in target-procedure, cOutputRoot).
    
    /* If objects are generated with result codes specified, and the 
       object being generated has one or more customisation for those result codes,
       then the filename needs to include the result codes. If there are no 
       customisations that apply to the object, then the filename does not
       need the result codes in the name.
     */
    if lCustomizationsExist then
        assign cResultCodes = dynamic-function('getTokenValue' in target-procedure,
                                               'GenerateResultCodes')
               cObjectName = cObjectName + '_' + replace(cResultCodes, ',', '_').
    
    cOutputFilename = cOutputRoot + '/' + cObjectName + '.' + cObjectExtension.
    
    return cOutputFilename.
end function.    /* getToken-OutputFilename */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetHandle Procedure 
FUNCTION getWidgetHandle RETURNS HANDLE PRIVATE
        ( input pcWidgetType     as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Returns a widget handle based on the widget type passed in.
    Notes: * widget handles created need to be cleaned up. This procedure cleans
             them up when closing down the generator.
------------------------------------------------------------------------------*/        
    define buffer lbWidgetHandle    for ttWidgetHandle.
    
    find lbWidgetHandle where lbWidgetHandle.WIdgetType = pcWidgetType no-error.
    if not available lbWidgetHandle then
    do:
        create lbWidgetHandle.
        lbWidgetHandle.WidgetType = pcWidgetType.
    end.    /* n/a widget handle */
    
    if not valid-handle(lbWidgetHandle.WidgetHandle) or
       lbWidgetHandle.WidgetHandle:type ne pcWidgetType then
        create value(lbWidgetHandle.WidgetType) lbWidgetHandle.WidgetHandle no-error.
    
    return lbWidgetHandle.WidgetHandle.
END FUNCTION.    /* getWidgetHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeGenerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeGenerator Procedure 
FUNCTION initializeGenerator RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    define variable lOk            as logical       initial ? no-undo.
    
    empty temp-table ttPage.
    empty temp-table ttInstance.
    empty temp-table ttLink.
    empty temp-table ttProperty.
    empty temp-table ttNode.
    empty temp-table ttAction.
    empty temp-table ttBand.
    empty temp-table ttBandAction.
    empty temp-table ttToolbarBand.
    empty temp-table ttObjectBand.
    empty temp-table ttCategory.
    empty temp-table ttBandToExtract.
    empty temp-table ttTranslatedAction.
    
    lOk = super() no-error.
    if lOk eq ? then
        lOk = yes.
    
    /* We want to write out code in American format, since the 4Gl compiler
       can deal with the conversion to other formats quite nicely.
     */
    dynamic-function('setTokenValue' in target-procedure,
                     'Session_DateFormat', session:date-format).
    session:date-format = 'mdy'.                         
    
    dynamic-function('setTokenValue' in target-procedure,
                     'Session_NumericSeparator', session:numeric-separator).     
    
    dynamic-function('setTokenValue' in target-procedure,
                     'Session_DecimalPoint', session:numeric-decimal-point).
                         
    session:numeric-format = 'American'.    

    error-status:error = no.        
    return lOk.
END FUNCTION.    /* initializeGenerator */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeTokenValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeTokenValues Procedure 
FUNCTION initializeTokenValues RETURNS LOGICAL
    ():
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Override of the generation process. Happens before anything else
            happens in the generation process.
    Notes:
------------------------------------------------------------------------------*/
    define variable cObjectName             as character                no-undo.
    define variable cSuperProcedureMode     as character                no-undo.
    define variable cPhysicalName           as character                no-undo.
    define variable iPos                    as integer                  no-undo.
    define variable lFrameObject            as logical                  no-undo.
    
    define buffer gscot         for gsc_object_type.
    define buffer rycso         for ryc_smartobject.
    define buffer gstrv         for gst_record_version.
    define buffer rycla         for ryc_layout.
    
    
    /* Object Stuff */
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').    
    
    find rycso where
         rycso.object_filename = cObjectName and
         rycso.customization_result_obj = 0
         no-lock no-error.
    if not available rycso then
    do:
        iPos = index(cObjectName, '.').
        cObjectName = substring(cObjectName, 1, iPos - 1).
        
        find rycso where
             rycso.object_filename = cObjectName and
             rycso.customization_result_obj = 0
             no-lock no-error.
        dynamic-function('setTokenValue' in target-procedure,
                         'ObjectName', cObjectName).
    end.    /* no object name available with extension */
    
    if available rycso then
    do:
        find gscot where gscot.object_type_obj = rycso.object_type_obj no-lock.
        dynamic-function('setTokenValue' in target-procedure,
                         'ClassName', gscot.object_type_code).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'ObjectDescription', rycso.object_description).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'ObjectPath', rycso.object_path).
        
        find gstrv where
             gstrv.entity_mnemonic = "RYCSO":U and
             gstrv.key_field_value = STRING(rycso.smartobject_obj)
             no-lock no-error.
        if available gstrv then
            dynamic-function('setTokenValue' in target-procedure,                    
                             'ObjectVersion', string(gstrv.version_number_seq)).
        
        /* Create Page,Instance,Link,Property records.
           Don't create any of these records before running this function, 
           since populateObjectTables empties the temp-tables before 
           doing anything else.
         */
        dynamic-function('populateObjectTables' in target-procedure, cObjectName).
    end.    /* available rycso */

    if available gscot and
       dynamic-function('classIsA' in gshRepositoryManager,
                        gscot.object_type_code, 'Container') then
    do:
        find rycla where rycla.layout_obj = rycso.layout_obj no-lock no-error.
        
        create ttProperty.
        assign ttProperty.PropertyName = 'Page0LayoutManager'
               ttProperty.PropertyOwner = cObjectName
               ttProperty.ForceSet = no
               ttProperty.UseInList = yes
               ttProperty.PropertyValue = (IF AVAILABLE rycla THEN rycla.layout_code ELSE "00":U)
               ttProperty.DataType = 'Character'.
    end.    /* container objects */
    
    /* Get any treeview nodes */
    if available gscot and
       dynamic-function('classIsA' in gshRepositoryManager,
                        gscot.object_type_code, 'DynTree') then
    do:
        find ttProperty where
             ttProperty.PropertyOwner = cObjectName and
             ttProperty.PropertyName = 'RootNodeCode'
             no-error.
        if available ttProperty then             
            run ry/app/rytrenodep.p on gshAstraAppServer ( input  ttProperty.PropertyValue,
                                                           /* doesn't matter what we use here, we'll replace it later. */
                                                           input  target-procedure,    
                                                           output table ttNode append ).
    end.    /* DynTree */
    
    /* Tell the template that this is a frame, else it may
       create a new window.
     */
    if available gscot and
       dynamic-function('classIsA' in gshRepositoryManager,
                        gscot.object_type_code, 'DynFrame') then
        lFrameObject = yes.                        
    else
        lFrameObject = no.
        
    dynamic-function('setTokenValue' in target-procedure,
                     'RenderAsFrame', string(lFrameObject)).
    
    /* SuperProcedure */
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'SuperProcedure'
         no-error.
    if available ttProperty and
       ttProperty.PropertyValue ne ? and
       ttProperty.PropertyValue ne '' then
    do:
        ttProperty.PropertyValue = ttProperty.PropertyValue
                                 + dynamic-function("deriveSuperProcedures":U in gshRepositoryManager,
                                                      input ttProperty.PropertyValue, input 0 ).
        ttProperty.PropertyValue =  trim(ttProperty.PropertyValue, ',').
        dynamic-function('setTokenValue' in target-procedure,
                 'ObjectSuperProcedure', ttProperty.PropertyValue).
        
        find ttProperty where
             ttProperty.PropertyOwner = cObjectName and
             ttProperty.PropertyName = 'SuperProcedureMode'
             no-error.
        if available ttProperty and
           ttProperty.PropertyValue ne ? and
           ttProperty.PropertyValue ne '' then
            cSuperProcedureMode = ttProperty.PropertyValue.
        else
            cSuperProcedureMode = 'Stateless'.
        
        dynamic-function('setTokenValue' in target-procedure,
                 'ObjectSuperProcedureMode', cSuperProcedureMode).
    end.    /* available property */
    else
    do:
        dynamic-function('setTokenValue' in target-procedure,
                 'ObjectSuperProcedure', '').
        dynamic-function('setTokenValue' in target-procedure,
                 'ObjectSuperProcedureMode', ''). 
    end.    /* no property found */
    
    /* Size */
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'MinHeight'
         no-error.
    if available ttProperty then
        dynamic-function('setTokenValue' in target-procedure,
                         'ObjectHeight', ttProperty.PropertyValue).

    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'MinWidth'
         no-error.
    if available ttProperty then
        dynamic-function('setTokenValue' in target-procedure,
                         'ObjectWidth', ttProperty.PropertyValue).
    
    /* Other stuff */
    dynamic-function('setTokenValue' in target-procedure,
                     'StandardHeaderComment', 'ry/tem/temstdhdr.p').
    dynamic-function('setTokenValue' in target-procedure,
                     'ObjectExtension', 'pgen').
    
    /* Set the physical object name explicitly, since the output
       filename may be in a path that has spaces in it.
     */
    cPhysicalName = dynamic-function('getTokenValue' in target-procedure, 'OutputFilename').
    dynamic-function('setTokenValue' in target-procedure,
                     'PhysicalObjectName',
                     dynamic-function('transmogrifyPropertyValue' in target-procedure,
                                      'Character',
                                      cPhysicalName)).
    
    
    /* run up the stack of hook procedures. */
    super() no-error.
    
    error-status:error = no.
    return true.
END FUNCTION.    /* initializeTokenValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initialObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initialObjectSecured Procedure 
FUNCTION initialObjectSecured RETURNS LOGICAL
        ( input pcObjectName        as character  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Determines whether the ObjectSecured flag is set to true or false.   
           this depends on whether we generate security inline or not.
    Notes:
------------------------------------------------------------------------------*/
    define variable lGenerateSecurity        as logical              no-undo.
    
    lGenerateSecurity = logical(dynamic-function('getTokenValue' in target-procedure,
                                                 'GenerateSecurity')) no-error.
    
    error-status:error = no.
    return (lGenerateSecurity ne no).
END FUNCTION.    /* initialObjectSecured */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initialObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initialObjectTranslated Procedure 
FUNCTION initialObjectTranslated RETURNS LOGICAL
        ( input pcObjectName        as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns whether the ObjectTranslated flag should be set to true in
           the adm-ObjectProperties-Assign function.
    Notes:  - If translations are not generated, return false. 
            - If not all lanaguages are being generated, then check whether there 
              are translations in the languages that are NOT being translated. If
              so, then return false and make sure that the value of ObjectTranslated
              is being set in the translate-<Language> call.
            - If all languages are being generated then return true, since all translation
              information is contained in the generated file. This means that if there
              is no translate-<Language> call there is no translation for that language,
              and we don't need to do any more, and if there is a translate-<Language> 
              call, the translation will be done by that call. Either way, we know that
              this file contains all of the translation work to be done.
            - Check for both widget and menu translations.                       
------------------------------------------------------------------------------*/
    define variable lTranslated                as logical                no-undo.
    define variable cLanguages                 as character              no-undo.
    define variable lGenerateTranslation       as logical                no-undo.
    
    define buffer gsclg        for gsc_language.
    define buffer gsmtr        for gsm_translation.
    define buffer gsmti        for gsm_translated_menu_item.
    
    lTranslated = no.
    lGenerateTranslation = logical(dynamic-function('getTokenValue' in target-procedure,
                                                    'GenerateTranslations')) no-error.
    
    /* If translations are to be generated, the check if there are actually any
       translations. If there are no translations, then we can mark the object 
       as already translated (a bit counter-intuitive, but this means that we don't
       even attempt to translate the object). If there are translations, the translate-<Lang>
       procedure will set the ObjectTranslated property to true when it is run.
     */
    if lGenerateTranslation then
    do:
        lTranslated = yes.
        cLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
        /* If all languages are selected, then we know that we can set ObjectTranslated to yes
           since complete information about the translations will be contained in the generated
           file.
         */
        if cLanguages ne '*' then
        do:
            for each gsmtr where
                     gsmtr.object_filename = pcObjectName
                     no-lock,
               first gsclg where
                     gsclg.language_obj = gsmtr.language_obj
                     no-lock
                     break by gsmtr.language_obj:
                if first-of(gsmtr.language_obj) then
                do:
                    if not can-do(cLanguages, gsclg.language_code) then
                    do:
                        lTranslated = no.
                        leave.
                    end.    /* found translation not for this language */
                end.    /* first-of language */
            end.    /* translations for an object */
            
            /* Look for menu item translations. There will only be
               translated action temp-table records if any translations
               exist.
             */
            if lTranslated then
            for each gsmti where
                     gsmti.language_obj = gsclg.language_obj
                     no-lock,
               first gsclg where
                     gsclg.language_obj = gsmti.language_obj
                     no-lock
                     break by gsmti.language_obj:
                if first-of(gsmti.language_ob) then
                do:
                    if not can-do(cLanguages, gsclg.language_code) then
                    do:
                        lTranslated = no.
                        leave.
                    end.    /* found translation not for this language */
                end.    /* first-of language */
            end.    /* each language */
        end.    /* not all languages */
    end.    /* generate translations */
    
    error-status:error = no.
    return lTranslated.
END FUNCTION.    /* initialObjectTranslated */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceIsVisual) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION instanceIsVisual Procedure 
FUNCTION instanceIsVisual RETURNS LOGICAL
  ( input pcClassName        as character ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Determines whether a class inherits from the visual class
    Notes:  
------------------------------------------------------------------------------*/
    define variable lIsA        as logical                            no-undo.
    
    lIsa = dynamic-function('classIsA' in gshRepositoryManager,
                            pcClassName, 'Visual').
    
    return lIsA.
END FUNCTION.    /* instanceIsVisual */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listContainerMenuItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION listContainerMenuItems Procedure 
FUNCTION listContainerMenuItems RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns a CSV list of menu items for an object
    Notes:  
------------------------------------------------------------------------------*/
    define variable cMenuItems                as character            no-undo.
    
    for each ttAction:
        cMenuItems = cMenuItems + ',' + ttAction.Action.
    end.    /* each action */
    cMenuItems = left-trim(cMenuItems, ',').
    
    error-status:error = no.
    return cMenuItems.
END FUNCTION.    /* listContainerMenuItems */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listContainerMenuStructures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION listContainerMenuStructures Procedure 
FUNCTION listContainerMenuStructures RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns a CSV list of menu structures for an object
    Notes:  
------------------------------------------------------------------------------*/
    define variable cMenuStructures            as character            no-undo.
    
    for each ttBand:
        cMenuStructures = cMenuStructures + ','
                        + ttBand.Band.
    end.    /* loop through bands */
    cMenuStructures = left-trim(cMenuStructures, ',').
    
    error-status:error = no.
    return cMenuStructures.
END FUNCTION.    /* listContainerMenuStructures */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateObjectTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateObjectTables Procedure 
FUNCTION populateObjectTables RETURNS LOGICAL PRIVATE
        ( input pcObjectName        as character        ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Populates the generation procedure's internal set of temp-tables used
           to generate the output.
    Notes:
------------------------------------------------------------------------------*/
    define variable cClassName                 as character               no-undo.
    define variable cResultCode                as character               no-undo.
    define variable cResultCodes               as character               no-undo.    
    define variable cSourceInstance            as character               no-undo.
    define variable cTargetInstance            as character               no-undo.
    define variable cResultCodeObj             as character               no-undo.
    define variable iResultCodeLoop            as integer                 no-undo.
    define variable lObjectIsViewer            as logical                 no-undo.
    define variable lCustomizationsExist       as logical                 no-undo.
    define variable lGenerateTranslations      as logical                 no-undo.
    
    define buffer ryccr            for ryc_customization_result.
    define buffer rycso            for ryc_smartobject.
    define buffer rycpa            for ryc_page.
    define buffer rycoi            for ryc_object_instance.
    define buffer rycoi_target     for ryc_object_instance.
    define buffer rycso_instance   for ryc_smartobject.
    define buffer rycsm            for ryc_smartlink.
    define buffer rycav            for ryc_attribute_value.
    define buffer rycat            for ryc_attribute.
    define buffer rycue            for ryc_ui_event.
    define buffer gscot            for gsc_object_type.
    define buffer rycla            for ryc_layout.
    define buffer gsmom            for gsm_object_menu_structure.
    
    cResultCodes = dynamic-function('getTokenValue' in target-procedure, 'GenerateResultCodes').
    
    /* Make sure the result codes are nicely formed. they should have the default result
       code in the string, at the very least. */    
    run resolveResultCodes in gshRepositoryManager (input Yes, input-output cResultCodes).
    
    /* Set the property again, in case the result codes have changed as 
       a result of the above call. */
    dynamic-function('setTokenValue' in target-procedure,
                     'GenerateResultCodes', cResultCodes).
    
    lCustomizationsExist = no.    
    lObjectIsViewer = dynamic-function('subClassOf' in target-procedure, 'Viewer').
    
    /* Loop through result codes and get information about the master object
       and contained instances. */
    do iResultCodeLoop = 1 to num-entries(cResultCodes):
        cResultCode = entry(iResultCodeLoop, cResultCodes).
        
        find ryccr where ryccr.customization_result_code = cResultCode no-lock no-error.
        if not available ryccr and cResultCode ne '{&default-result-code}' then
            next.
        
        /* Keep the result code obj's to avoid having to find them again. */
        if lObjectIsViewer then
            cResultCodeObj = cResultCodeObj + '|'
                           + string((if available ryccr then ryccr.customization_result_obj else 0)).
        
        find rycso where
             rycso.object_filename = pcObjectName and
             rycso.customization_result_obj = (if available ryccr then ryccr.customization_result_obj else 0)
             no-lock no-error.
        if available rycso then
        do:
            if rycso.customization_result_obj ne 0 then
                lCustomizationsExist = yes.
            
            find ttPage where ttPage.PageReference = 'Page0' no-error.
            if not available ttPage then
            do:
                /* Page 0 first */
                create ttPage.
                assign ttPage.PageReference = 'Page0'
                       ttPage.PageNumber = 0
                       ttPage.PageLabel = 'Page 0'.
            end.    /* create page 0 */
            
            /* Get the instances on page 0 (not on any specific page) */
            for each rycoi where
                     rycoi.container_smartobject_obj = rycso.smartobject_obj and
                     rycoi.page_obj = 0
                     no-lock,
               first rycso_instance where
                     rycso_instance.smartobject_obj = rycoi.smartobject_obj
                     no-lock:
                         
                find ttInstance where
                     ttInstance.InstanceName = rycoi.instance_name
                     no-error.
                
                if not available ttInstance then
                do:
                    find gscot where
                         gscot.object_type_obj = rycso_instance.object_type_obj
                         no-lock no-error.                         
                    
                    create ttInstance.
                    assign ttInstance.InstanceName = rycoi.instance_name
                           ttInstance.PageReference = "Page0"
                           ttInstance.Order = rycoi.object_sequence
                           ttInstance.ObjectName = rycso_instance.object_filename
                           ttInstance.ClassName = gscot.object_type_code.
                    ttInstance.CleanName = {fnarg getInstanceCleanName ttInstance.InstanceName}.
                    
                    create ttProperty.
                    assign ttProperty.PropertyName = 'LayoutPosition'
                           ttProperty.PropertyOwner = ttInstance.InstanceName
                           ttProperty.ForceSet = no
                           ttProperty.UseInList = yes
                           ttProperty.PropertyValue = rycoi.layout_position
                           ttProperty.DataType = 'Character'.
                    
                    /* The Physical object name attribute here is used to determine
                       the rendering procedure in certain cases. */
                    create ttProperty.
                    assign ttProperty.PropertyName = 'PhysicalObjectName'
                           ttProperty.PropertyOwner = ttInstance.InstanceName
                           ttProperty.ForceSet = no
                           ttProperty.UseInList = no
                           ttProperty.DataType = 'Character'.
                    if rycso_instance.static_object then
                        ttProperty.PropertyValue = dynamic-function('getObjectPathedName' in gshRepositoryManager,
                                                           rycso_instance.smartobject_obj).
                    else
                        ttProperty.PropertyValue = ''.
                        
                    /* Name or ObjectName. This is used to store the
                       instance name for use by the ADM. */
                    if dynamic-function('classHasAttribute' in gshRepositoryManager,
                                        gscot.object_type_code, 'Name', no) then
                    do:
                        create ttProperty.
                        assign ttProperty.PropertyName = 'Name'
                               ttProperty.PropertyOwner = ttInstance.InstanceName
                               ttProperty.ForceSet = no
                               ttProperty.UseInList = yes
                               ttProperty.PropertyValue = ttInstance.InstanceName
                               ttProperty.DataType = 'Character'.
                    end.    /* Has NAME attribute */
                    
                    if dynamic-function('classHasAttribute' in gshRepositoryManager,
                                        gscot.object_type_code, 'ObjectName', no) then
                    do:
                        create ttProperty.
                        assign ttProperty.PropertyName = 'ObjectName'
                               ttProperty.PropertyOwner = ttInstance.InstanceName
                               ttProperty.ForceSet = no
                               ttProperty.UseInList = no    /* OE00187820 */
                               ttProperty.PropertyValue = ttInstance.InstanceName
                               ttProperty.DataType = 'Character'.
                    end.    /* Has ObjectName attribute */
                end.    /* no instance record */
                
                /* Instance Properties */
                for each rycav where
                         rycav.object_type_obj = rycso_instance.object_type_obj and
                         rycav.smartobject_obj = rycso_instance.smartobject_obj and
                         rycav.object_instance_obj = rycoi.object_instance_obj  and
                         rycav.applies_at_runtime = yes
                         no-lock,
                   first rycat where
                         rycat.attribute_label = rycav.attribute_label and
                         rycat.design_only = no and
                         rycat.derived_value = no
                         no-lock:
                    
                    /* Skip certain deprecated attributes */
                    if can-do('{&deprecated-attributes}', rycat.attribute_label) then                        
                        next.
                        
                    if can-find(ttProperty where
                                ttProperty.PropertyName = rycat.attribute_label and
                                ttProperty.PropertyOwner = rycoi.instance_name) then
                        next.
                        
                    /* There may be cases where properties are 'left over' from
                       earlier releases (they may not have been cleaned up properly).
                       We don't want to use them at all, since the ADMProps temp-tables 
                       will be all messed up. We can use the RepositoryManager API since
                       the code we're generating is for RUNTIME use. */
                    if not dynamic-function('classHasAttribute' in gshRepositoryManager,
                                            ttInstance.ClassName, rycat.attribute_label, no) then
                        next.
                    
                    create ttProperty.
                    assign ttProperty.PropertyName = rycat.attribute_label
                           ttProperty.PropertyOwner = rycoi.instance_name
                           ttProperty.ForceSet = can-do(rycat.override_type, 'Set')
                          /* we want to turn these properties into a list to pass in to constructObject */
                           ttProperty.UseInList = not can-do('{&exclude-from-prop-list}', rycat.attribute_label).
                    
                    case rycat.data_type:
                        when {&DECIMAL-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.decimal_value)
                                   ttProperty.DataType = 'Decimal'.
                        when {&INTEGER-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.integer_value)
                                   ttProperty.DataType = 'Integer'.
                        when {&DATE-DATA-TYPE}    then
                            assign ttProperty.PropertyValue = string(rycav.date_value)
                                   ttProperty.DataType = 'Date'.
                        when {&RAW-DATA-TYPE}     then
                            assign ttProperty.PropertyValue = string(rycav.raw_value)
                                   ttProperty.DataType = 'Character'.
                        when {&LOGICAL-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.logical_value)
                                   ttProperty.DataType = 'Logical'.
                        otherwise
                            /* replace carriage returns with spaces */
                            assign ttProperty.PropertyValue = replace(rycav.character_value, '~n', ' ')                            
                                   ttProperty.DataType = 'Character'.
                    end case.   /* data type */
                end.    /* each instance attribute value */
                
                /* Instance Events */
                for each rycue where
                         rycue.object_type_obj = rycso_instance.object_type_obj and
                         rycue.smartobject_obj = rycso_instance.smartobject_obj and
                         rycue.object_instance_obj = rycoi.object_instance_obj  and
                         rycue.event_disabled      = no and
                         rycue.container_smartobject_obj = rycoi.container_smartobject_obj and
                         rycue.event_action       <> "":U
                         no-lock:

                    if not can-find(ttEvent where
                                    ttEvent.EventName = rycue.event_name and
                                    ttEvent.InstanceName = ttInstance.InstanceName) then
                    do:
                        create ttEvent.
                        assign ttEvent.EventName = rycue.event_name
                               ttEvent.InstanceName = ttInstance.InstanceName
                               ttEvent.ActionType = rycue.action_type
                               ttEvent.ActionTarget = rycue.action_target
                               ttEvent.EventParameter = rycue.event_parameter
                               ttEvent.EventAction = rycue.event_action.
                    end.    /* no event */
                end.    /* ui events */
            end.    /* page 0 */
            
            /* now all pages */
            for each rycpa where
                     rycpa.container_smartobject_obj = rycso.smartobject_obj
                     no-lock:
                if not can-find(ttPage where
                                ttPage.PageReference = rycpa.page_reference) then
                do:
                    find rycla where rycla.layout_obj = rycpa.layout_obj no-lock no-error.
                    
                    create ttPage.
                    assign ttPage.PageReference = rycpa.page_reference
                           ttPage.PageNumber = rycpa.page_sequence
                           ttPage.PageLabel = rycpa.page_label
                           ttPage.PageLayoutCode = (if available rycla then rycla.layout_code else '00')
                           ttPage.PageToken = rycpa.security_token.
                end.    /* no page record */
                
                for each rycoi where
                         rycoi.container_smartobject_obj = rycpa.container_smartobject_obj and
                         rycoi.page_obj = rycpa.page_obj
                         no-lock,
                   first rycso_instance where
                         rycso_instance.smartobject_obj = rycoi.smartobject_obj
                         no-lock:
                             
                    find ttInstance where
                         ttInstance.InstanceName = rycoi.instance_name
                         no-error.
                    
                    if not available ttInstance then
                    do:
                        find gscot where
                             gscot.object_type_obj = rycso_instance.object_type_obj
                             no-lock no-error.                         
                        
                        create ttInstance.
                        assign ttInstance.InstanceName = rycoi.instance_name
                               ttInstance.PageReference = rycpa.page_reference
                               ttInstance.Order = rycoi.object_sequence
                               ttInstance.ObjectName = rycso_instance.object_filename
                               ttInstance.ClassName  = gscot.object_type_code.
                        ttInstance.CleanName = {fnarg getInstanceCleanName ttInstance.InstanceName}.
                        
                        create ttProperty.
                        assign ttProperty.PropertyName = 'LayoutPosition'
                               ttProperty.PropertyOwner = ttInstance.InstanceName
                               ttProperty.ForceSet = no
                               ttProperty.UseInList = yes
                               ttProperty.PropertyValue = rycoi.layout_position
                               ttProperty.DataType = 'Character'.
                        
                        /* The Physical object name attribute here is used to determine
                           the rendering procedure in certain cases. 
                         */
                        create ttProperty.
                        assign ttProperty.PropertyName = 'PhysicalObjectName'
                               ttProperty.PropertyOwner = ttInstance.InstanceName
                               ttProperty.ForceSet = no
                               ttProperty.UseInList = no
                               ttProperty.DataType = 'Character'.
                        if rycso_instance.static_object then
                            ttProperty.PropertyValue = dynamic-function('getObjectPathedName' in gshRepositoryManager,
                                                               rycso_instance.smartobject_obj).
                        else
                            ttProperty.PropertyValue = ''.
                        
                        /* Name or ObjectName. This is used to store the
                           instance name for use by the ADM. */
                        if dynamic-function('classHasAttribute' in gshRepositoryManager,
                                            gscot.object_type_code, 'Name', no) then
                        do:
                            create ttProperty.
                            assign ttProperty.PropertyName = 'Name'
                                   ttProperty.PropertyOwner = ttInstance.InstanceName
                                   ttProperty.ForceSet = no
                                   ttProperty.UseInList = yes
                                   ttProperty.PropertyValue = ttInstance.InstanceName
                                   ttProperty.DataType = 'Character'.
                        end.    /* Has NAME attribute */
                        
                        if dynamic-function('classHasAttribute' in gshRepositoryManager,
                                            gscot.object_type_code, 'ObjectName', no) then
                        do:
                            create ttProperty.
                            assign ttProperty.PropertyName = 'ObjectName'
                                   ttProperty.PropertyOwner = ttInstance.InstanceName
                                   ttProperty.ForceSet = no
                                   ttProperty.UseInList = yes
                                   ttProperty.PropertyValue = ttInstance.InstanceName
                                   ttProperty.DataType = 'Character'.
                        end.    /* Has ObjectName attribute */                        
                    end.    /* no instance record */
                    
                    /* Instance Properties */
                    for each rycav where
                             rycav.object_type_obj = rycso_instance.object_type_obj and
                             rycav.smartobject_obj = rycso_instance.smartobject_obj and
                             rycav.object_instance_obj = rycoi.object_instance_obj  and
                             rycav.applies_at_runtime = yes
                             no-lock,
                       first rycat where
                             rycat.attribute_label = rycav.attribute_label and
                             rycat.design_only = no and
                             rycat.derived_value = no
                             no-lock:
                        
                        /* Skip certain deprecated attributes */
                        if can-do('{&deprecated-attributes}', rycat.attribute_label) then                        
                            next.
                        
                        if can-find(ttProperty where
                                    ttProperty.PropertyName = rycat.attribute_label and
                                    ttProperty.PropertyOwner = rycoi.instance_name) then
                            next.
                        
                        /* There may be cases where properties are 'left over' from
	                       earlier releases (they may not have been cleaned up properly).
	                       We don't want to use them at all, since the ADMProps temp-tables 
	                       will be all messed up. We can use the RepositoryManager API since
	                       the code we're generating is for RUNTIME use. */
                        if not dynamic-function('classHasAttribute' in gshRepositoryManager,
                                                ttInstance.ClassName, rycat.attribute_label, no) then
                            next.

                        create ttProperty.
                        assign ttProperty.PropertyName = rycat.attribute_label
                               ttProperty.PropertyOwner = rycoi.instance_name
                               ttProperty.ForceSet = can-do(rycat.override_type, 'Set')
                              /* we want to turn these properties into a list to pass in to constructObject */
                               ttProperty.UseInList = not can-do('{&exclude-from-prop-list}', rycat.attribute_label).
                        
                        case rycat.data_type:
                            when {&DECIMAL-DATA-TYPE} then
                                assign ttProperty.PropertyValue = string(rycav.decimal_value)
                                       ttProperty.DataType = 'Decimal'.
                            when {&INTEGER-DATA-TYPE} then
                                assign ttProperty.PropertyValue = string(rycav.integer_value)
                                       ttProperty.DataType = 'Integer'.
                            when {&DATE-DATA-TYPE}    then
                                assign ttProperty.PropertyValue = string(rycav.date_value)
                                       ttProperty.DataType = 'Date'.
                            when {&RAW-DATA-TYPE}     then
                                assign ttProperty.PropertyValue = string(rycav.raw_value)
                                       ttProperty.DataType = 'Character'.
                            when {&LOGICAL-DATA-TYPE} then
                                assign ttProperty.PropertyValue = string(rycav.logical_value)
                                       ttProperty.DataType = 'Logical'.
                            otherwise
                                /* replace carriage returns with spaces */                            
                                assign ttProperty.PropertyValue = replace(rycav.character_value, '~n', ' ')
                                       ttProperty.DataType = 'Character'.
                        end case.   /* data type */
                    end.    /* each instance attribute value */

                    /* Instance Events */
                    for each rycue where
                             rycue.object_type_obj = rycso_instance.object_type_obj and
                             rycue.smartobject_obj = rycso_instance.smartobject_obj and
                             rycue.object_instance_obj = rycoi.object_instance_obj  and
                             rycue.event_disabled      = no and
                             rycue.container_smartobject_obj = rycoi.container_smartobject_obj and
                             rycue.event_action       <> "":U
                             no-lock:
                        if not can-find(ttEvent where
                                        ttEvent.EventName = rycue.event_name and
                                        ttEvent.InstanceName = rycoi.instance_name) then
                        do:
                            create ttEvent.
                            assign ttEvent.EventName = rycue.event_name
                                   ttEvent.InstanceName = ttInstance.InstanceName
                                   ttEvent.ActionType = rycue.action_type
                                   ttEvent.ActionTarget = rycue.action_target
                                   ttEvent.EventParameter = rycue.event_parameter
                                   ttEvent.EventAction = rycue.event_action.
                        end.    /* no event */
                    end.    /* ui events */
                end.    /* each instance */
            end.    /* each page */
            
            for each rycsm where
                     rycsm.container_smartobject_obj = rycso.smartobject_obj
                     no-lock:
                find rycoi where
                     rycoi.object_instance_obj = rycsm.source_object_instance_obj
                     no-lock no-error.
                cSourceInstance = (if available rycoi then rycoi.instance_name else 'This-Procedure').                         
                
                find rycoi_target where
                     rycoi_target.object_instance_obj = rycsm.target_object_instance_obj
                     no-lock no-error.
                cTargetInstance = (if available rycoi_target then rycoi_target.instance_name else 'This-Procedure').                         
                
                if not can-find(ttLink where
                                ttLink.LinkName = rycsm.link_name and
                                ttLink.SourceInstanceName = cSourceInstance and
                                ttLink.TargetInstanceName = cTargetInstance  ) then
                do:
                    create ttLink.
                    assign ttLink.LinkName = rycsm.link_name
                           ttLink.SourceInstanceName = cSourceInstance
                           ttLink.TargetInstanceName = cTargetInstance.
                    
                    find ttInstance where
                         ttInstance.InstanceName = ttLink.SourceInstanceName
                         no-error.
                    ttLink.SourcePageRef = (if available ttInstance then ttInstance.PageReference else 'Page0').
                    
                    find ttInstance where
                         ttInstance.InstanceName = ttLink.TargetInstanceName
                         no-error.
                    ttLink.TargetPageRef = (if available ttInstance then ttInstance.PageReference else 'Page0').
                end.    /* link not created */
            end.    /* each link */
                        
            /* Properties for the object itself */
            cClassName = dynamic-function('getTokenValue' in target-procedure, 'ClassName').
            for each rycav where
                     rycav.object_type_obj = rycso.object_type_obj and
                     rycav.smartobject_obj = rycso.smartobject_obj and
                     rycav.object_instance_obj = 0                 and
                     rycav.applies_at_runtime = yes
                     no-lock,
               first rycat where
                     rycat.attribute_label = rycav.attribute_label and
                     rycat.design_only = no and
                     rycat.derived_value = no
                     no-lock:
                
                /* There may be cases where properties are 'left over' from
                   earlier releases (they may not have been cleaned up properly).
                   We don't want to use them at all, since the ADMProps temp-tables 
                   will be all messed up. We can use the RepositoryManager API since
                   the code we're generating is for RUNTIME use. */
                if not dynamic-function('classHasAttribute' in gshRepositoryManager,
                                        cClassName, rycat.attribute_label, no) then
                    next.

                /* Skip certain deprecated attributes */
                if can-do('{&deprecated-attributes}', rycat.attribute_label) then                        
                    next.
                
                if can-find(ttProperty where
                            ttProperty.PropertyName = rycat.attribute_label and
                            ttProperty.PropertyOwner = pcObjectName) then
                    next.
                
                create ttProperty.
                assign ttProperty.PropertyName = rycat.attribute_label
                       ttProperty.PropertyOwner = pcObjectName
                       ttProperty.ForceSet = can-do(rycat.override_type, 'Set')
                       ttProperty.UseInList = no.
                
                case rycat.data_type:
                    when {&DECIMAL-DATA-TYPE} then
                        assign ttProperty.PropertyValue = string(rycav.decimal_value)
                               ttProperty.DataType = 'Decimal'.
                    when {&INTEGER-DATA-TYPE} then
                        assign ttProperty.PropertyValue = string(rycav.integer_value)
                               ttProperty.DataType = 'Integer'.
                    when {&DATE-DATA-TYPE}    then
                        assign ttProperty.PropertyValue = string(rycav.date_value)
                               ttProperty.DataType = 'Date'.
                    when {&RAW-DATA-TYPE}     then
                        assign ttProperty.PropertyValue = string(rycav.raw_value)
                               ttProperty.DataType = 'Character'.
                    when {&LOGICAL-DATA-TYPE} then
                        assign ttProperty.PropertyValue = string(rycav.logical_value)
                               ttProperty.DataType = 'Logical'.
                    otherwise
                        /* replace carriage returns with spaces */
                        assign ttProperty.DataType = 'Character'
                               ttProperty.PropertyValue = replace(rycav.character_value, '~n', ' ').
                end case.   /* data type */
            end.    /* each master attribute value */
            
            if can-find(first gsmom where gsmom.object_obj = rycso.smartobject_obj) then
                dynamic-function('setTokenValue' in target-procedure,
                                 'ObjectHasMenu', 'Yes').
            
            dynamic-function('buildObjectMenuTables' in target-procedure,
                             rycso.smartobject_obj, cResultCode).
            
            dynamic-function('buildToolbarMenuTables' in target-procedure,
                             rycso.smartobject_obj, cResultCode).
        end.    /* available rycso */
    end.    /* result code loop, master object, instances, links, master properties  */

    lGenerateTranslations = logical(dynamic-function('getTokenValue' in target-procedure,
                                                     'GenerateTranslations')) no-error.
    
    if can-find(first ttAction) and lGenerateTranslations then
        dynamic-function('buildMenuTranslations' in target-procedure).
    
    if lObjectIsViewer then
        assign cResultCodeObj = left-trim(cResultCodeObj, '|')
               lCustomizationsExist = dynamic-function('populateViewerInstances' in target-procedure,
                                                       lCustomizationsExist, cResultCodeObj).
    
    /* Store whether customizations exist */
    dynamic-function('setTokenValue' in target-procedure,
                     'CustomizationsExist', String(lCustomizationsExist)).                                     
    
    error-status:error = no.
    return true.
END FUNCTION.    /* populateObjectTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateViewerInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateViewerInstances Procedure 
FUNCTION populateViewerInstances RETURNS LOGICAL PRIVATE
        ( input plCustomizationsExist    as logical,
          input pcResultCodeObj          as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Get master and class properties/events for viewer widgets only.
    Notes: - We need to get master & class propertyies for widgets because they
             are not procedure-based (like all other ADM2 objects) and thus they 
             don't have an ADMProps temp-table which has the master and class 
             properties populated from the newInstance() API.
------------------------------------------------------------------------------*/
    define variable lInstanceIsSdf            as logical                no-undo.
    define variable lObjectHasListItemProp    as logical                no-undo.
    define variable iInstanceResultCodeLoop   as integer                no-undo.
    define variable iPropertyLoop             as integer                no-undo.
    define variable cPropertyNames            as character              no-undo.
    define variable cPropertyValues           as character              no-undo.
    define variable dResultCodeObj            as decimal                no-undo.
    define variable hClassBuffer              as handle                 no-undo.
    define variable hBufferField              as handle                 no-undo.
    
    define buffer rycoi            for ryc_object_instance.
    define buffer rycso            for ryc_smartobject.    
    define buffer rycav            for ryc_attribute_value.
    define buffer rycat            for ryc_attribute.
    define buffer rycue            for ryc_ui_event.
    
    for each ttInstance:    
        /* Set the InstanceType value; only relevant for viewers. */
        lInstanceIsSdf = dynamic-function('ClassIsA' in gshRepositoryManager,
                                          ttInstance.ClassName, 'Field' ) or
                         dynamic-function('ClassIsA' in gshRepositoryManager,
                                          ttInstance.ClassName, 'Procedure' ).
        
        if lInstanceIsSdf then
            ttInstance.InstanceType = 'Sdf'.
        else
            ttInstance.InstanceType = 'Widget'.
        
        /* Viewer widgets only. Since viewer widgets are not procedure-based,
           we need to get all the relevant property values and write them into 
           the viewer's adm-create-objects code.
         */
        if ttInstance.InstanceType ne 'Sdf' then
        do:
            /* Determine whether there is a LIST-ITEMS or LIST-ITEM-PAIRS
               property stored against instance of the object. We use this 
               information to determine whether to use the LIST-ITEM*
               property from the class. If either of the properties exists 
               on either the instance or master, then we don't care about
               the class property.
             */
            lObjectHasListItemProp = (can-find (first ttProperty where
                                                      ttProperty.PropertyName begins 'List-Item':u and 
                                                      ttProperty.PropertyOwner = ttInstance.InstanceName)).
            
            /* loop through all the result codes for the contained */
            do iInstanceResultCodeLoop = 1 to num-entries(pcResultCodeObj, '|'):
                dResultCodeObj = decimal(entry(iInstanceResultCodeLoop, pcResultCodeObj, '|')) no-error.
        
                find rycso where
                     rycso.object_filename = ttInstance.ObjectName and
                     rycso.customization_result_obj = dResultCodeObj
                     no-lock no-error.
                
                if not available rycso then
                    next.
                
                if dResultCodeObj ne 0 then
                    plCustomizationsExist = yes.
                
                /* Master property values */
                for each rycav where
                         rycav.object_type_obj = rycso.object_type_obj and
                         rycav.smartobject_obj = rycso.smartobject_obj and
                         rycav.object_instance_obj = 0 
                         no-lock,
                   first rycat where
                         rycat.attribute_label = rycav.attribute_label and
                         rycat.design_only = no and
                         rycat.derived_value = no
                         no-lock:
                    
                    /* There may be cases where properties are 'left over' from
	                   earlier releases (they may not have been cleaned up properly).
	                   We don't want to use them at all, since the ADMProps temp-tables 
	                   will be all messed up. We can use the RepositoryManager API since
	                   the code we're generating is for RUNTIME use. */
                    if not dynamic-function('classHasAttribute' in gshRepositoryManager,
                                            ttInstance.ClassName, rycat.attribute_label, no) then
                        next.

                    /* Skip certain deprecated attributes */
                    if can-do('{&deprecated-attributes}', rycat.attribute_label) then                        
                        next.
                                                                                
                    if rycat.runtime_only then
                        next.
                    
                    if can-find(ttProperty where
                                ttProperty.PropertyName = rycat.attribute_label and
                                ttProperty.PropertyOwner = ttInstance.InstanceName) then
                        next.
                                        
                    create ttProperty.
                    assign ttProperty.PropertyName = rycat.attribute_label
                           ttProperty.PropertyOwner = ttInstance.InstanceName
                           ttProperty.ForceSet = can-do(rycat.override_type, 'Set')
                          /* we want to turn these properties into a list to pass in to constructObject */
                           ttProperty.UseInList = not can-do('{&exclude-from-prop-list}', rycat.attribute_label).
                            
                    case rycat.data_type:
                        when {&DECIMAL-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.decimal_value)
                                   ttProperty.DataType = 'Decimal'.
                        when {&INTEGER-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.integer_value)
                                   ttProperty.DataType = 'Integer'.
                        when {&DATE-DATA-TYPE}    then
                            assign ttProperty.PropertyValue = string(rycav.date_value)
                                   ttProperty.DataType = 'Date'.
                        when {&RAW-DATA-TYPE}     then
                            assign ttProperty.PropertyValue = string(rycav.raw_value)
                                   ttProperty.DataType = 'Character'.
                        when {&LOGICAL-DATA-TYPE} then
                            assign ttProperty.PropertyValue = string(rycav.logical_value)
                                   ttProperty.DataType = 'Logical'.
                        otherwise
                            /* replace carriage returns with spaces */                        
                            assign ttProperty.PropertyValue = replace(rycav.character_value, '~n', ' ')
                                   ttProperty.DataType = 'Character'.
                    end case.   /* data type */   
                    
                    if ttProperty.PropertyName begins 'List-Item':u and
                       not lObjectHasListItemProp then
                        lObjectHasListItemProp = yes.
                end.    /* each master attribute value */
                
                /* Master Events */
                for each rycue where
                         rycue.object_type_obj = rycso.object_type_obj and
                         rycue.smartobject_obj = rycso.smartobject_obj and
                         rycue.object_instance_obj = 0 and
                         rycue.event_disabled      = no and
                         rycue.container_smartobject_obj = 0 and
                         rycue.event_action       <> "":U
                         no-lock:

                    if not can-find(ttEvent where
                                    ttEvent.EventName = rycue.event_name and
                                    ttEvent.InstanceName = ttInstance.InstanceName) then
                    do:
                        create ttEvent.
                        assign ttEvent.EventName = rycue.event_name
                               ttEvent.InstanceName = ttInstance.InstanceName
                               ttEvent.ActionType = rycue.action_type
                               ttEvent.ActionTarget = rycue.action_target
                               ttEvent.EventParameter = rycue.event_parameter
                               ttEvent.EventAction = rycue.event_action.
                    end.    /* no event */
                end.    /* ui events */                         
            end.    /* result code loop, instance properties */
            
            /* Get the class property values after all possible master values have
               been retrieved.
               
               We're jumping through hoops a little here because of the problems
               with add-new-field and the :initial property, as outlined in the
               getClassProperties() API in the Repository Manager.
             */
            hClassBuffer = dynamic-function('getCacheClassBuffer' in gshRepositoryManager,
                                            ttInstance.ClassName).
            hClassBuffer = hClassBuffer:buffer-field('ClassBufferHandle'):buffer-value.
            
            cPropertyNames = '*'.
            run getClassProperties in gshRepositoryManager (input        ttInstance.ClassName,
                                                            input-output cPropertyNames,
                                                                  output cPropertyValues ).
            do iPropertyLoop = 1 to num-entries(cPropertyNames):                            
                if can-find(ttProperty where
                            ttProperty.PropertyName = entry(iPropertyLoop, cPropertyNames) and
                            ttProperty.PropertyOwner = ttInstance.InstanceName) then
                    next.
                
                /* If either a LIST-ITEMS or LIST-ITEM-PAIRS property already exists on the 
                   master or instance, then don't use either of these properties from the class. */
                if entry(iPropertyLoop, cPropertyNames) begins 'List-Item':u and
                   lObjectHasListItemProp then
                    next.
                
                hBufferField = hClassBuffer:buffer-field(entry(iPropertyLoop, cPropertyNames)) no-error.
                if valid-handle(hBufferField) then
                do:
                    create ttProperty.
                    assign ttProperty.PropertyName = entry(iPropertyLoop, cPropertyNames)
                           ttProperty.PropertyOwner = ttInstance.InstanceName
                           ttProperty.PropertyValue = entry(iPropertyLoop, cPropertyValues, chr(1))
                           ttProperty.DataType = hBufferField:data-type.
                end.    /* valid buffer field */
            end.    /* class property loop */      
        end.    /* instance is a widget */
        else
        do:
            /* SDFs need a FieldName property for mapping to the SDO column. */
            if not can-find(ttProperty where
                            ttProperty.PropertyOwner = ttInstance.InstanceName and
                            ttProperty.PropertyName = 'FieldName' ) then
            do:
                create ttProperty.
                assign ttProperty.PropertyName = 'FieldName'
                       ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyValue =  ttInstance.InstanceName
                       ttProperty.DataType = 'Character'
                       ttProperty.UseInList = yes.
            end.    /* no FieldName property. */
        end.    /* instance is a SDF */
    end.    /* each instance */
    
    error-status:error = no.
    return plCustomizationsExist.
END FUNCTION.    /* populateViewerInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-AddLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-AddLinks Procedure 
FUNCTION processLoop-AddLinks RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Adds addLink() calls to a container.
    Notes:
------------------------------------------------------------------------------*/
    define variable cPageReference            as character            no-undo.
    
    cPageReference = dynamic-function('getTokenValue' in target-procedure,
                                  'CurrentPageReference').
    
    /* for all links, except Update links, create the
       links that have their Targets on this page. For
       Update links, create links that have their source
       on this page.
     */
    for each ttLink where
             ttLink.LinkName <> 'Update' and
             ttLink.TargetPageRef = cPageReference:
                         
        dynamic-function('setTokenValue' in target-procedure,
                         'LinkName', ttLink.LinkName).
        dynamic-function('setTokenValue' in target-procedure,
                         'SourceInstanceName', ttLink.SourceInstanceName).
        dynamic-function('setTokenValue' in target-procedure,
                         'TargetInstanceName', ttLink.TargetInstanceName).
                      
        dynamic-function('processLoopIteration' in target-procedure).             
    end.    /* each non-Update link */    
    
    for each ttLink where
             ttLink.LinkName = 'Update' and
             ttLink.SourcePageRef = cPageReference:
        
        dynamic-function('setTokenValue' in target-procedure,
                         'LinkName', ttLink.LinkName).
        dynamic-function('setTokenValue' in target-procedure,
                         'SourceInstanceName', ttLink.SourceInstanceName).
        dynamic-function('setTokenValue' in target-procedure,
                         'TargetInstanceName', ttLink.TargetInstanceName).
        
        dynamic-function('processLoopIteration' in target-procedure).             
    end.    /* each non-Update link */    
        
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-AddLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createContainerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createContainerObjects Procedure 
FUNCTION processLoop-createContainerObjects RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Adds the constructObject() calls to adm-create-objects for a container.
    Notes: 
------------------------------------------------------------------------------*/
    define variable lThinRendering        as logical                      no-undo.
    define variable lDbAware              as logical                      no-undo.
    define variable lResizable            as logical                      no-undo.
    define variable cValue                as character                    no-undo.
    define variable cPageReference        as character                    no-undo.
    
    /* Determine the rendering procedure name */
    lThinRendering = logical(dynamic-function('getTokenValue' in target-procedure,
                                              'GenerateThinRendering')) no-error.
    if lThinRendering eq ? then
        lThinRendering  = no.

    cPageReference = dynamic-function('getTokenValue' in target-procedure,
                                      'CurrentPageReference').

    for each ttInstance where
             ttInstance.PageReference = cPageReference
             by ttInstance.Order:
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceName', ttInstance.InstanceName).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceObjectName', ttInstance.ObjectName).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceClass', ttInstance.ClassName).
        
        /* DbAware is added to the rendering procedure */
        find ttProperty where
             ttProperty.PropertyName = 'DbAware' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if available ttProperty then
            cValue = ttProperty.PropertyValue.
        else
            cValue = dynamic-function('findAttributeValue' in target-procedure,
                                      'DbAware', ttInstance.ObjectName).
        
        lDbAware = logical(cValue) no-error.
        
        /* Find a rendering procedure. */
        cValue = ''.
        if lThinRendering then
        do:
            /* InstanceRenderingProcedure */
            find ttProperty where
                 ttProperty.PropertyName = 'ThinRenderingProcedure' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = dynamic-function('findAttributeValue' in target-procedure,
                                          'ThinRenderingProcedure', ttInstance.ObjectName).
        end.    /* thin rendering */
        
        if cValue eq '' or cValue eq ? then
        do:            
            /* InstanceRenderingProcedure */
            find ttProperty where
                 ttProperty.PropertyName = 'RenderingProcedure' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = dynamic-function('findAttributeValue' in target-procedure,
                                          'RenderingProcedure', ttInstance.ObjectName).
        end.    /* find renderingprocedure */
        
        /* Some (static mainly) objects may use PhysicalObjectName 
           instead of RenderingProcedure */
        if cValue eq '' or cValue eq ? then
        do:
            find ttProperty where
                 ttProperty.PropertyName = 'PhysicalObjectName' and                            
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
        end.    /* look for physical object */
        
        if lDbAware eq yes then
            cValue = cValue + chr(3) + 'DBAWARE'.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceRenderingProcedure', cValue).

        /* Previously, we built a list. Now we generated {set}s individually.
           However, we must pass in LogicalObjectName so that pgen'ed objects
           are run. */
        cValue = 'LogicalObjectName' + chr(4) + ttInstance.ObjectName.
        
        /* OE00187820: ObjectName is required for setting the InstanceNames property on the container.
           Since we now always set ObjectName here (pass in to constructObject), there's no need
           to have it in the instance setters. */
        find ttProperty where
             ttProperty.PropertyOwner = ttInstance.InstanceName and
             ttProperty.PropertyName = 'ObjectName'
             no-error.
        if available ttProperty then
            cValue = cValue + chr(3) + 'ObjectName' + chr(4) + ttProperty.PropertyValue.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceInstanceProperties',
                         quoter(cValue)).
                    
        /* Row */        
        find ttProperty where
             ttProperty.PropertyName = 'Row' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if available ttProperty then
            cValue = ttProperty.PropertyValue.
        else
            cValue = string(1).            
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceRow', cValue).
        
        /* Column */        
        find ttProperty where
             ttProperty.PropertyName = 'Column' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if available ttProperty then
            cValue = ttProperty.PropertyValue.
        else
            cValue = string(1).            
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceColumn', cValue).
        
        if not lDbAware then
        do:
            /* Is object resizable? */
            find ttProperty where
                 ttProperty.PropertyName = 'ResizeHorizontal' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                lResizable = logical(ttProperty.PropertyValue).
            else
                lResizable = logical(dynamic-function('findAttributeValue' in target-procedure,
                                                          'ResizeHorizontal', ttInstance.ObjectName)) no-error.
    
            if not lResizable then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'ResizeVertical' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    lResizable = logical(ttProperty.PropertyValue).
                else
                    lResizable = logical(dynamic-function('findAttributeValue' in target-procedure,
                                                          'ResizeVertical', ttInstance.ObjectName)) no-error.
            end.    /* not horizontally resiable */
        end.    /* not dbaware */
        else
            lResizable = no.
                    
        if lResizable then         
        do:
            /* Height */        
            find ttProperty where
                 ttProperty.PropertyName = 'MinHeight' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = string(1).            
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceHeight', cValue).
            
            /* Width */
            find ttProperty where
                 ttProperty.PropertyName = 'MinWidth' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = string(1).
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceWidth', cValue).
        end.    /* object is resiable */        
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceResizable', string(lResizable)).
        
        /* process the template */        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* instance by order */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-CreateContainerObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createContainerPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createContainerPage Procedure 
FUNCTION processLoop-createContainerPage RETURNS LOGICAL
    (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Creates pages.
    Notes:
------------------------------------------------------------------------------*/
    define variable cPageLabels            as character                no-undo.
    define variable cPageLayouts           as character                no-undo.
    define variable cInitOtherPages        as character                no-undo.
    define variable cRequiredPages         as character                no-undo.
    define variable cObjectName            as character                no-undo.
    define variable iPageNumber            as integer                  no-undo.
    define variable cPageTokens            as character no-undo.

    repeat preselect each ttPage by ttPage.PageNumber:
        find next ttPage.
        
        if ttPage.PageReference ne 'Page0' then
            assign cPageLabels = cPageLabels + '|':u + ttPage.PageLabel
                   cPageLayouts = cPageLayouts + '|':u + ttPage.PageLayoutCode
                   cPageTokens = cPageTokens + '|':u + replace(ttPage.PageToken, '&':u, '':u).
        
        /* The RequiredPages property needs to be populated,
           the RUN initPages ... call in adm-create-objects means
           that we can skip using the RequiredPages property in 
           containr.p to start related pages.           
         */
        cRequiredPages = cRequiredPages + '|?'.
        
        /* Get the page numbers contiguous. */
        ttPage.PageNumber = iPageNumber.
        iPageNumber = iPageNumber + 1.
    end.    /* page number */
    
    assign cPageLayouts = left-trim(cPageLayouts, '|')
           cPageLabels = left-trim(cPageLabels, '|')
           cPageTokens = left-trim(cPageTokens, '|':u).
    
    /* The folder object is always the Page-Source for the procedure. */
    find first ttLink where
               ttLink.TargetInstanceName = 'This-Procedure' and
               ttLink.LinkName = 'Page'
               no-error.
    dynamic-function('setTokenValue' in target-procedure,
                     'WindowHasFolder', string(available ttLink)).
    if available ttLink then
    do:
        find ttProperty where
             ttProperty.PropertyOwner = ttLink.SourceInstanceName and
             ttProperty.PropertyName = 'FolderLabels'
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttLink.SourceInstanceName
                   ttProperty.PropertyName = 'FolderLabels'
                   ttProperty.UseInList = yes
                   ttProperty.DataType = 'Character'.
        end.    /* n/a property */
        ttProperty.PropertyValue = cPageLabels.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'FolderInstanceName', ttLink.SourceInstanceName).
        
    end.    /* folder instance */
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName'). 
    
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'RequiredPages'
         no-error.
    if not available ttProperty then
    do:
        create ttProperty.
        assign ttProperty.PropertyOwner = cObjectName
               ttProperty.PropertyName = 'RequiredPages'
               ttProperty.UseInList = yes
               ttProperty.DataType = 'Character'.
    end.    /* n/a property */
    ttProperty.PropertyValue = left-trim(cRequiredPages, '|').
            
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'PageLayoutInfo'
         no-error.
    if not available ttProperty then
    do:
        create ttProperty.
        assign ttProperty.PropertyOwner = cObjectName
               ttProperty.PropertyName = 'PageLayoutInfo'
               ttProperty.UseInList = yes
               ttProperty.DataType = 'Character'.                       
    end.    /* n/a property */
    ttProperty.PropertyValue = cPageLayouts.
    
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'PageTokens':u
         no-error.
    if not available ttProperty then
    do:
        create ttProperty.
        assign ttProperty.PropertyOwner = cObjectName
               ttProperty.PropertyName = 'PageTokens':u
               ttProperty.UseInList = yes
               ttProperty.DataType = 'Character'.
    end.    /* n/a property */
    ttProperty.PropertyValue = cPageTokens.
    
    /* do a separate loop so that the page labels are built correctly. */    
    for each ttPage by ttPage.PageNumber:    
            dynamic-function('setTokenValue' in target-procedure,
                         'CurrentPage', string(ttPage.PageNumber)).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'CurrentPageReference', ttPage.PageReference).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* each page */
            
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createContainerPage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Action) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-Action Procedure 
FUNCTION processLoop-createMenu-Action RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Creates menu action records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields                as character        no-undo.
    define buffer emptyAction    for ttAction.
    
    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'Action').
    
    create emptyAction.
    for each ttAction:
        if ttAction.Action eq '' then
                next.
        
        buffer-compare ttAction to emptyAction
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuAction', ttAction.Action).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttAction))).
       
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each action */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-Action  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Band) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-Band Procedure 
FUNCTION processLoop-createMenu-Band RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Creates menu band records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields        as character                no-undo.
    
    define buffer emptyBand    for ttBand.
    
    dynamic-function('setTokenValue' in target-procedure,    
                     'MenuTableName', 'Band').
    
    create emptyBand.                     
    for each ttBand:
        if ttBand.Band eq '' THEN
            next.
            
        buffer-compare ttBand to emptyBand
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuBand', ttBand.Band).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttBand))).
       
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each band */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-Band */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-BandAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-BandAction Procedure 
FUNCTION processLoop-createMenu-BandAction RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Creates manu band action records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields        as character                no-undo.
    
    define buffer emptyBandAction     for ttBandAction.
    
    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'BandAction').
    
    create emptyBandAction.                     
    FOR EACH ttBandAction:
            if ttBandAction.Band eq '' AND ttBandAction.Sequence eq 0 THEN
                        next.
      
        buffer-compare ttBandAction to emptyBandAction
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
    
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuAction', ttBandAction.Action).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttBandAction))).
        
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each band */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-BandAction */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-Category) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-Category Procedure 
FUNCTION processLoop-createMenu-Category RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Create menu categroy records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields        as character                no-undo.
    
    define buffer emptyCategory    for ttCategory.

    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'Category').
    
    create emptyCategory.
    FOR EACH ttCategory:
        if ttCategory.Category eq '' then
                    next.
        buffer-compare ttCategory to emptyCategory
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
    
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuCategory', ttCategory.Category).

        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttCategory))).
        
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each band */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-Category */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-ObjectBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-ObjectBand Procedure 
FUNCTION processLoop-createMenu-ObjectBand RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Creates menu object band records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields        as character                no-undo.
    
    define buffer emptyObjectBand for ttObjectBand.

    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'ObjectBand').
    
    create emptyObjectBand.
    FOR EACH ttObjectBand:
        if ttObjectBand.Band eq '' AND ttObjectBand.ObjectName eq '' THEN
                    NEXT.
        buffer-compare ttObjectBand to emptyObjectBand
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuBand', ttObjectBand.Band).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttObjectBand))).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuRunAttribute', ttObjectBand.RunAttribute).
        
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each band */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-ObjectBand */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenu-ToolbarBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenu-ToolbarBand Procedure 
FUNCTION processLoop-createMenu-ToolbarBand RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Creates toolbar band records
    Notes:
------------------------------------------------------------------------------*/
    define variable cChangedFields        as character                no-undo.
    
    define buffer emptyToolbarBand for ttToolbarBand.

    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'ToolbarBand').
    
    create emptyToolbarBand.
    for each ttToolbarBand:
        if ttToolbarBand.Band eq '' and ttToolbarBand.ToolbarName eq '' then
            next.
        buffer-compare ttToolbarBand to emptyToolbarBand
            save result in cChangedFields.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuChangedFields', cChangedFields).
    
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuBand', ttToolbarBand.Band).
                  
        dynamic-function('setTokenValue' in target-procedure,
                         'MenuTableRowid', string(rowid(ttToolbarBand))).
        
        dynamic-function('processLoopIteration' in target-procedure).   
    end.    /* each band */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenu-ToolbarBand */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createMenuField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createMenuField Procedure 
FUNCTION processLoop-createMenuField RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Create the individual lines for menu records. Typically used by all
            processLoop-createMenu-* loops.
    Notes:
------------------------------------------------------------------------------*/
    define variable cMenuTable        as character                    no-undo.
    define variable cChangedFields    as character                    no-undo.
    define variable cValue            as character                    no-undo.
    define variable cRowid            as character                    no-undo.    
    define variable hBuffer           as handle                       no-undo.
    define variable iLoop             as integer                      no-undo.
    define variable hField            as handle                       no-undo.
           
    cMenuTable = dynamic-function('getTokenValue' in target-procedure, 'MenuTableName').
    cChangedFields = dynamic-function('getTokenValue' in target-procedure, 'MenuChangedFields').    
    cRowid = dynamic-function('getTokenValue' in target-procedure, 'MenuTableRowid').
        
    case cMenuTable:
        when 'Action' then hBuffer = buffer ttAction:handle.
        when 'BandAction' then hBuffer = buffer ttBandAction:handle.
        when 'Band' then hBuffer = buffer ttBand:handle.
        when 'ObjectBand' then hBuffer = buffer ttObjectBand:handle.
        when 'ToolbarBand' then hBuffer = buffer ttToolbarBand:handle.
        when 'Category' then hBuffer = buffer ttCategory:handle.
        when 'TranslatedAction' then hBuffer = buffer ttTranslatedAction:handle.            
        otherwise hBuffer = ?.
    end case.    /* menu table */
    
    if valid-handle(hBuffer) then
    do:
        /* Using the FIND-FIRST() method with ROWIDs causes
           GPFs in Progres v9.1E.
                hBuffer:find-first('where rowid(' + hBuffer:name + ') = to-rowid("' + cRowid + '")') no-error.
        */
        hBuffer:find-by-rowid(to-rowid(cRowid)) no-error.
        
        do iLoop =  1 to num-entries(cChangedFields):
            hField = hBuffer:buffer-field(entry(iLoop, cChangedFields)).
            
            dynamic-function('setTokenValue' in target-procedure,
                             'MenuFieldName', hField:name).
            if hField:data-type eq 'Character' then
                cValue = quoter(hField:buffer-value).
            else
                cValue = string(hField:buffer-value).
            
            dynamic-function('setTokenValue' in target-procedure,
                             'MenuFieldValue', cValue).
            
            dynamic-function('processLoopIteration' in target-procedure).
        end.    /* changed fields */
    end.    /* valid buffer */
        
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createMenuField  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createTreeviewNodeField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createTreeviewNodeField Procedure 
FUNCTION processLoop-createTreeviewNodeField RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Builds indicidual field assignments for the ttNode table.  
    Notes:
------------------------------------------------------------------------------*/
    define variable cRowid            as character                no-undo.
    define variable cValue            as character                no-undo.
    define variable iLoop             as integer                  no-undo.
    define variable hBuffer           as handle                   no-undo.
    define variable hField            as handle                   no-undo.    
    
    cRowid = dynamic-function('getTokenValue' in target-procedure,
                              'NodeTableRowid').
    find ttNode where rowid(ttNode) = to-rowid(cRowid) no-error.
    hBuffer = buffer ttNode:handle.
    
    do iLoop =  1 to hBuffer:num-fields:
        hField = hBuffer:buffer-field(iLoop).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'NodeFieldName', hField:name).
        
        if hField:data-type eq 'Character' then
            cValue = quoter(hField:buffer-value).
        else
            cValue = string(hField:buffer-value).
        
        if hField:name eq 'hTargetProcedure' then
            cValue = 'Target-Procedure'.                
        
        dynamic-function('setTokenValue' in target-procedure,
                         'NodeFieldValue', cValue).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* buffer fields */
    
    error-status:error = no.
    return true.
END FUNCTION.     /* processLoop-createTreeviewNodeField */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createTreeviewNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createTreeviewNodes Procedure 
FUNCTION processLoop-createTreeviewNodes RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose: Builds node definitions for a treeview
    Notes:
------------------------------------------------------------------------------*/
    for each ttNode:
        dynamic-function('setTokenValue' in target-procedure,
                         'NodeTableRowid', string(rowid(ttNode))).
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* each node */            
            
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createTreeviewNodes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerDisplayObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createViewerDisplayObjects Procedure 
FUNCTION processLoop-createViewerDisplayObjects RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Creates the displayObjects API for viewers.
    Notes:
------------------------------------------------------------------------------*/
    define variable cValue                as character                no-undo.
    define variable lVisible              as logical                  no-undo.
    define variable lLocalField           as logical                  no-undo.
    define variable hWidget               as handle                   no-undo.
        
    for each ttInstance by ttInstance.Order:

        /* Only generate displayObejcts for visible objects */
        find ttProperty where
             ttProperty.PropertyName = 'Visible' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if available ttProperty then
            cValue = ttProperty.PropertyValue.
        else
            cValue = 'Yes'.
        
        lVisible = logical(cValue) no-error.
        if lVisible eq ? then
            lVisible = yes.
            
        if not lVisible then
            next.
        
        /* Only generate displayObjects for instances with an initial value */
        find ttProperty where
             ttProperty.PropertyName = 'InitialValue' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if ttProperty.PropertyValue eq '' or ttProperty.PropertyValue eq ? then
            next.            

        /* Escape quotes in the initial value. */
        cValue = replace(ttProperty.PropertyValue, "'", "~~'").
        cValue = replace(ttProperty.PropertyValue, '"', '~~"').

        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceInitialValue', cValue).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceName', ttInstance.InstanceName).
        
        if ttInstance.InstanceType eq 'Sdf' then
        do:
            /* LocalField? */
            find ttProperty where
                 ttProperty.PropertyName = 'LocalField' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = dynamic-function('findAttributeValue' in target-procedure,
                                          'LocalField', ttInstance.ObjectName).
                                          
            lLocalField = logical(cValue) no-error.
            if lLocalField eq ? then
                lLocalField = no.   

            if not lLocalField then
                next.
            
            dynamic-function('setTokenValue' in target-procedure, 'InstanceIsSdf', 'Yes').
            dynamic-function('setTokenValue' in target-procedure, 'InstanceIsWidget', 'No').
        end.
        else
        do:
            /* Skip displayObjects for VIEW-AS TEXT or TEXT widgets.
	           Their InitialValue is displayed as part of their construction.
	           One reason for doing this is that, for TEXT widgets, the InitialValue
	           may be translated. displayObjects runs after translate-<Lang> so will
	           overwrite any translations. And we don't want that. */
            if ttInstance.InstanceType eq 'TEXT':u then
                next.
            
            hWidget = dynamic-function('getWidgetHandle' in target-procedure, ttInstance.InstanceType).
            
            if valid-handle(hWidget) and not can-set(hWidget, 'Screen-Value') then
                next.
            
            /* LocalField? */
            find ttProperty where
                 ttProperty.PropertyName = 'TableName' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if ttProperty.PropertyValue ne '' then
                next.
            
            dynamic-function('setTokenValue' in target-procedure, 'InstanceIsSdf', 'No').
            dynamic-function('setTokenValue' in target-procedure, 'InstanceIsWidget', 'Yes').            
        end.    /* not sdf */
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* each instance */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createViewerDisplayObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createViewerObjects Procedure 
FUNCTION processLoop-createViewerObjects RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Manages the creation of objects on a viewer (SDFs and widgets)
    Notes: * Basically writes the adm-create-objects procedure, which is
                 a set of "RUN adm-create-<InstanceName> ... " calls. These
                 are build in createViewerWidgets
------------------------------------------------------------------------------*/        
    /* The instances must be created in order, which determines the tab order. */
    for each ttInstance by ttInstance.Order:
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceName', ttInstance.InstanceName).
        
        /* Write the code */
        dynamic-function('processLoopIteration' in target-procedure).          
    end.    /* instance */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createViewerObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createViewerWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createViewerWidgets Procedure 
FUNCTION processLoop-createViewerWidgets RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Creates the widgets on a viewer
    Notes:
------------------------------------------------------------------------------*/
    /* Move all code into an include, because of AppBuilder limits. */
    {ry/inc/rypgencvwi.i}
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createViewerWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-createWidgetAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-createWidgetAttributes Procedure 
FUNCTION processLoop-createWidgetAttributes RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Creates widget attributes for a viewer's widgets
    Notes: 
------------------------------------------------------------------------------*/
    define variable cWidgetType            as character                no-undo.
    define variable cInstanceName          as character                no-undo.
    define variable cExcludeProperties     as character                no-undo.
    define variable cPropertyValue         as character                no-undo.
    define variable hWidgetHandle          as handle                   no-undo.
    define variable dPropertyValue         as decimal                  no-undo.
    
    define buffer lbProperty        for ttProperty.
    
    cWidgetType = dynamic-function('getTokenValue' in target-procedure, 'InstanceType').
    cInstanceName = dynamic-function('getTokenValue' in target-procedure, 'InstanceName').
    cExcludeProperties = dynamic-function('getTokenValue' in target-procedure, 'InstanceExcludeProperties').
        
    hWidgetHandle = dynamic-function('getWidgetHandle' in target-procedure, cWidgetType).
    for each ttProperty where
             ttProperty.PropertyOwner = cInstanceName:
        
        /* skip those properties we've already dealt with. */             
        if can-do(cExcludeProperties, ttProperty.PropertyName) then
            next.             
        if can-set(hWidgetHandle, ttProperty.PropertyName) then
        do:
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceAttributeName', ttProperty.PropertyName).
            
            /* Only use one of LIST-ITEMS or LIST-ITEM-PAIRS */
            if ttProperty.PropertyName begins 'List-Item' then
            do:
                /* List-Item-Pairs needs more than just a blank or
                   unknown value.
                 */
                if (trim(ttProperty.PropertyValue) eq '' or ttProperty.PropertyValue eq ?) and
                   ttProperty.PropertyName eq 'List-Item-Pairs' then
                do:
                    /* this property is useless, get rid of it */
                    delete ttProperty.
                    next.
                end.    /* skip empty list-item-pairs */
                else
                do:
                    /* Look for the other property. So if this is
                       LIST-ITEMS then look for LIST-ITEM-PAIRS, and
                       vice versa.
                     */
                    find lbProperty where
                         lbProperty.PropertyName begins 'List-Item' and
                         lbProperty.PropertyOwner = cInstanceName and
                         rowid(lbProperty) ne rowid(ttProperty)
                         no-error.
                    
                    /* only do something if the other can be found.
                       if there's only one LIST-ITEM* property, then
                       we'll use that one, regardless.
                     */
                    if available lbProperty then
                    do:
                        /* Keep the non-empty one. Delete the other. */
                        if ttProperty.PropertyValue eq ? or
                           trim(ttProperty.PropertyValue) eq '':u then
                        do:
                            delete ttProperty.
                            next.
                        end.
                        else
                            delete lbProperty.
                    end.    /* no property */
                end.    /* there is a List-Item* value*/
            end.    /* list item property */
            
            /* The Inner-Lines property of an editor widget should
               not be written out if it is 0 or the unknown value.
             */
            if cWidgetType eq 'Editor' then
            do:
                /* Remove a zero-value Inner-Lines property. */
                if ttProperty.PropertyName eq 'Inner-Lines' then
                do:
                    dPropertyValue = decimal(ttProperty.PropertyValue) no-error.
                    
                    if dPropertyValue eq 0 or dPropertyValue eq ? then
                    do:
                        delete ttProperty.
                        next.
                    end.    /* delete inner lines */
                end.    /* Inner-Lines property is zero or ? */
            end.    /* editor widget */
            
            cPropertyValue = ttProperty.PropertyValue.
            
            if ttProperty.DataType eq 'Character' then
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceAttributeValue', quoter(cPropertyValue)).
            else
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceAttributeValue', cPropertyValue).
            
            dynamic-function('processLoopIteration' in target-procedure).
        end.    /* attribute is settable */
    end.    /* each property */
    
    /* Widget handles are cleaned up by destroyGenerator */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-createWidgetAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-listContainerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-listContainerObjects Procedure 
FUNCTION processLoop-listContainerObjects RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Lists the instances of a container.
    Notes:
------------------------------------------------------------------------------*/
    for each ttInstance:
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceName', ttInstance.InstanceName).
        dynamic-function('processLoopIteration' in target-procedure).                         
    end.    /* each instance */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-ListContainerObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-objectProperties-Assign) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-objectProperties-Assign Procedure 
FUNCTION processLoop-objectProperties-Assign RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Loops through the assignable properties for the object being 
                   generated to generate the property setter.
    Notes:
------------------------------------------------------------------------------*/
    define variable cObjectName            as character                no-undo.
    define variable lSdf                   as logical                  no-undo.
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    
    /* If the object is an SDF, then we need to exclude certain
       properties (like ROW, COLUMN etc) from the property list.
     */
    lSdf = dynamic-function('subClassOf' in target-procedure, 'Field').
    if not lSdf then
        lSdf = dynamic-function('subClassOf' in target-procedure, 'Procedure').
    
    /* Now add the properties to the output file */
    for each ttProperty where
             ttProperty.PropertyOwner = cObjectName and
             ttProperty.ForceSet = no
             by ttProperty.PropertyName:
        
        /* Skip the SuperProcedure* attributes, since they are handled
           individually. */
        if ttProperty.PropertyName begins 'SuperProcedure' then
            next.
        
        /* Skip the web-specific attributes */
        if can-do('{&dynamic-web-attributes}', ttProperty.PropertyName) then
            next.
        
        /* Don't set the visual information for SDFs. This needs to be set by the 
           SDF's container (i.e. the viewer) on an instance. Things like ROW have
           no meaning for the SDF outside the context of a container. */
        if lSdf and can-do('{&exclude-from-prop-list}', ttProperty.PropertyName) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'PropertyValue',
                         dynamic-function('transmogrifyPropertyValue' in target-procedure,
                                          ttProperty.DataType,
                                          ttProperty.PropertyValue)).
        
        dynamic-function('setTokenValue' in target-procedure,        
                         'PropertyName', ttProperty.PropertyName).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* each property */
    
    return true.
END FUNCTION.    /* processLoop-ObjectProperties-Assign */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-ObjectProperties-Set) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-ObjectProperties-Set Procedure 
FUNCTION processLoop-ObjectProperties-Set RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Loops through the set properties for the object being 
           generated to generate the property setter.
    Notes:
------------------------------------------------------------------------------*/
    define variable cObjectName            as character                no-undo.    
    define variable lSdf                   as logical                  no-undo.
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
            
    /* If the object is an SDF, then we need to exclude certain
       properties (like ROW, COLUMN etc) from the property list.
     */
    lSdf = dynamic-function('subClassOf' in target-procedure, 'Field').
    if not lSdf then
        lSdf = dynamic-function('subClassOf' in target-procedure, 'Procedure').
    
    /* Now add the properties to the output file */
    for each ttProperty where
             ttProperty.PropertyOwner = cObjectName and
             ttProperty.ForceSet = yes
             by ttProperty.PropertyName:
        
        /* Skip the SuperProcedure* attributes, since they are handled
           individually. */
        if ttProperty.PropertyName begins 'SuperProcedure' then
            next.
                 
        /* Skip the web-specific attributes */         
        if can-do('{&dynamic-web-attributes}', ttProperty.PropertyName) then
            next.
                    
        /* Don't set the visual information for SDFs. This needs to be set by the 
           SDF's container (i.e. the viewer) on an instance. Things like ROW have
           no meaning for the SDF outside the context of a container. */
        if lSdf and can-do('{&exclude-from-prop-list}', ttProperty.PropertyName) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'PropertyName', ttProperty.PropertyName).
                         
        dynamic-function('setTokenValue' in target-procedure,
                         'PropertyValue',
                         dynamic-function('transmogrifyPropertyValue' in target-procedure,
                                          ttProperty.DataType,
                                          ttProperty.PropertyValue)).
        
        dynamic-function('processLoopIteration' in target-procedure).
    end.    /* each property */
    
    return true.
END FUNCTION.    /* processLoop-ObjectProperties-Set*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateBrowser Procedure 
FUNCTION processLoop-translateBrowser RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Loop to translate browser columns
    Notes: 
------------------------------------------------------------------------------*/
    define variable cObjectName             as character                no-undo.
    define variable cLanguageCode           as character                no-undo.
    define variable cDisplayedFields        as character                no-undo.
    define variable cOriginalLabels         as character                no-undo.
    define variable cEntry                  as character                no-undo.
    define variable cLabel                  as character                no-undo.
    define variable cTooltip                as character                no-undo.
    define variable cGenerateLanguages      as character                no-undo.
    define variable iLoop                   as integer                  no-undo.
    define variable lLabelTranslated        as logical                  no-undo.
    
    define buffer gsclg        for gsc_language.
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
    
    /* We can only translate browser labels if the DisplayFields property has been set. */
    find ttProperty where
         ttProperty.PropertyOwner = cObjectName and
         ttProperty.PropertyName = 'DisplayedFields'
         no-error.
    if available ttProperty and
       ttProperty.PropertyValue ne ? and
       ttProperty.PropertyValue ne '' then
    do:
        cDisplayedFields = ttProperty.PropertyValue.
        
        for each gsclg no-lock:
            
            if not can-do(cGenerateLanguages, gsclg.language_code) then
                next.
            /* Look for translations for this language, for a browse. Don't look for
               a specific object name, since this excludes global translations.
             */
            if can-find(first gsm_translation where
                              gsm_translation.language_obj = gsclg.language_obj and
                              gsm_translation.widget_type = 'Browse' ) then
            do:
                dynamic-function('setTokenValue' in target-procedure, 
                                 'LanguageCode', gsclg.language_code).
                
                cOriginalLabels = ''.
                find ttProperty where
                     ttProperty.PropertyOwner = cObjectName and
                     ttProperty.PropertyName = 'BrowseColumnLabels'
                     no-error.
                if available ttProperty then
                    cOriginalLabels = ttProperty.PropertyValue.
                
                if cOriginalLabels eq '' or cOriginalLabels eq ? then
                    assign cOriginalLabels = fill('?' + chr(5), num-entries(cDisplayedFields) - 1)
                           cOriginalLabels = cOriginalLabels + '?'.
                
                lLabelTranslated = no.
                do iLoop = 1 to num-entries(cDisplayedFields):
                    run translateSingleObject in gshTranslationManager (gsclg.language_obj,
                                                                        cObjectName,
                                                                        entry(iLoop, cDisplayedFields),
                                                                        'Browse',
                                                                        0,
                                                                        output cLabel,
                                                                        output cTooltip ).
                    
                    if cLabel ne '' and cLabel ne ? then
                        assign lLabelTranslated = yes
                               entry(iLoop, cOriginallabels, chr(5)) = cLabel.
                end.    /* loop through displayed fields */
                
                if lLabelTranslated then
                do:
                    dynamic-function('setTokenValue' in target-procedure, 
                                     'LabelAttribute', 'BrowseColumnLabels').
                                     
                    cOriginalLabels = replace(cOriginalLabels, "'", "~~'").
                    cOriginalLabels = replace(cOriginalLabels, '"', '~~"').
                    
                    dynamic-function('setTokenValue' in target-procedure,
                                     'TranslatedLabel', cOriginalLabels).
                    dynamic-function('processLoopIteration' in target-procedure).
                end.    /* translated the label */                   
            end.    /* there is a translation for the browser in this language */
        end.    /* each language */
    end.    /* there are DisplayedFields */       
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateBrowser */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateMenuItem Procedure 
FUNCTION processLoop-translateMenuItem RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Translation of menu items
    Notes:
------------------------------------------------------------------------------*/    
    define variable cLanguageCode        as character                no-undo.
    define variable cChangedFields       as character                no-undo.
    
    define buffer ttTranslatedAction   for ttTranslatedAction.
        
    /* Menu translations only take place against the ttTranslatedAction temp-table,
       so set this value once only for the translations.
     */
    dynamic-function('setTokenValue' in target-procedure,
                     'MenuTableName', 'TranslatedAction').
    cLanguageCode = dynamic-function('getTokenValue' in target-procedure, 'LanguageCode').
    
    for each ttTranslatedAction where
             ttTranslatedAction.LanguageCode = cLanguageCode,
       first ttAction where
             ttAction.Action = ttTranslatedAction.Action:
        cChangedFields = ''. 
        
        buffer-compare ttAction to ttTranslatedAction save result in cChangedFields.
        
        if cChangedFields ne '' then
        do:
            dynamic-function('setTokenValue' in target-procedure,
                             'MenuChangedFields', cChangedFields).
            
            dynamic-function('setTokenValue' in target-procedure,
                             'MenuAction', ttTranslatedAction.Action).
            
            dynamic-function('setTokenValue' in target-procedure,
                             'MenuTableRowid', string(rowid(ttTranslatedAction))).
            
            dynamic-function('processLoopIteration' in target-procedure).
        end.    /* there are translations */                      
    end.    /* each translation */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateMenuItem */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateRowObject Procedure 
FUNCTION processLoop-translateRowObject RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Translation of SDO row object columns.
    Notes:
------------------------------------------------------------------------------*/
    define variable cTables                as character                no-undo.
    define variable cAllColumns            as character                no-undo.
    define variable cColumns               as character                no-undo.
    define variable cCurrentLanguage       as character                no-undo.
    define variable cTranslatedTooltips    as character                no-undo.
    define variable cTranslatedLabels      as character                no-undo.
    define variable cEntry                 as character                no-undo.
    define variable iTableLoop             as integer                  no-undo.
    define variable iColumnLoop            as integer                  no-undo.
        
    define buffer gsclg    for gsc_language.
    
    cTables = dynamic-function('getTokenValue' in target-procedure, 'SDOTables').
    cAllColumns = dynamic-function('getTokenValue' in target-procedure, 'SDOColumns').
    cCurrentLanguage = dynamic-function('getTokenValue' in target-procedure, 'LanguageCode').
    
    find gsclg where gsclg.language_code = cCurrentLanguage no-lock no-error.
    
    if available gsclg then
    do:
        do iTableLoop = 1 to num-entries(cTables):
            cColumns = entry(iTableLoop, cAllColumns, {&adm-tabledelimiter}).
            do iColumnLoop = 1 to num-entries(cColumns):
                dynamic-function('setTokenValue' in target-procedure,
                                 'ColumnName', entry(iColumnLoop, cColumns) ).
                
                run translateSingleObject in gshTranslationManager
                            ( input  gsclg.language_obj,
                              input  entry(iTableLoop, cTables),
                              input  entry(iColumnLoop, cColumns),
                              input  'Datafield',
                              input  2,    /* Column and Column Label */
                              output cTranslatedLabels,
                              output cTranslatedTooltips).
                           
                if num-entries(cTranslatedLabels, CHR(3)) eq 2 then
                do:
                    cEntry = ENTRY(1, cTranslatedLabels, CHR(3)).
                    dynamic-function('setTokenValue' in target-procedure,
                                     'HasTranslatedLabel', string(cEntry gt '')).
                                     
                    IF cEntry > "":U THEN
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedLabel', cEntry).
                    
                    cEntry = ENTRY(2, cTranslatedLabels, CHR(3)).
                    dynamic-function('setTokenValue' in target-procedure,
                                     'HasTranslatedColumnLabel', string(cEntry gt '')).
                                     
                    IF cEntry > "":U THEN
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedColumnLabel', cEntry).
                    
                    dynamic-function('processLoopIteration' in target-procedure).
                end.    /* there are translations */
                else
                do:
                    dynamic-function('setTokenValue' in target-procedure,
                                     'HasTranslatedLabel', 'No').
                    dynamic-function('setTokenValue' in target-procedure,
                                     'HasTranslatedColumnLabel', 'No').
                end.    /* no translations */
            end.    /* column loop */
        end.    /* table loop */
    end.    /* available language */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateRowObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateSDO Procedure 
FUNCTION processLoop-translateSDO RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Builds translations for SDOs.
    Notes: * SDOs cannot be customised; ignore customisation.
------------------------------------------------------------------------------*/
    define variable cObjectName            as character                    no-undo.
    define variable cTables                as character                    no-undo.
    define variable cGenerateLanguages     as character                    no-undo.
    define variable cLanguages             as character                    no-undo.
    define variable cAllColumns            as character                    no-undo.    
    define variable iTableLoop             as integer                      no-undo.
            
    define buffer gsclg    for gsc_language.
    define buffer gsmtr    for gsm_translation.
    define buffer rycav    for ryc_attribute_value.
    define buffer rycso    for ryc_smartobject.
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
    
    find rycso where
         rycso.object_filename = cObjectName and
         rycso.customization_result_obj = 0
         no-lock no-error.
    if available rycso then
    do:
        find first rycav where
                   rycav.object_type_obj = rycso.object_type_obj and
                   rycav.smartobject_obj = rycso.smartobject_obj and
                   rycav.object_instance_obj = 0 and
                   rycav.render_type_obj = 0 and
                   rycav.attribute_label = 'Tables'
                   no-lock no-error.
        /* We can only do something if there are tables available. */
        if available rycav then
        do:
            cTables = rycav.character_value.            
            /* keep these for later use in processLoop-translateRowObject */
            dynamic-function('setTokenValue' in target-procedure,
                             'SDOTables', cTables).
            
            find first rycav where
                       rycav.object_type_obj = rycso.object_type_obj and
                       rycav.smartobject_obj = rycso.smartobject_obj and
                       rycav.object_instance_obj = 0 and
                       rycav.render_type_obj = 0 and
                       rycav.attribute_label = 'DataColumnsByTable'
                       no-lock no-error.                        
            /* keep these for later use in processLoop-translateRowObject */
            dynamic-function('setTokenValue' in target-procedure,
                             'SDOColumns', rycav.character_value).
            
            do iTableLoop = 1 to num-entries(cTables):
                for each gsmtr where
                         gsmtr.object_filename = entry(iTableLoop, cTables)
                         no-lock,
                   first gsclg where
                         gsclg.language_obj = gsmtr.language_obj
                         no-lock:
                    /* Only generate translations for those languages specified
                       by the generation options.
                     */
                    if can-do(cGenerateLanguages, gsclg.language_code) then
                    do:
                        cLanguages = cLanguages
                                   + (if not can-do(cLanguages, gsclg.language_code) then
                                           (',' + gsclg.language_code)
                                      else '').
                    end.    /* we should generate translations for these languages */
                end.    /* each translation for the table */
            end.    /* TABLE-LOOP: loop through tables */
        end.    /* there is a Tables attribute */
    end.    /* available rycso  */
    
    cLanguages = trim(cLanguages, ',').
    do iTableLoop = 1 to num-entries(cLanguages):
        dynamic-function('setTokenValue' in target-procedure,
                         'LanguageCode', entry(iTableLoop, cLanguages)).
        dynamic-function('processLoopIteration' in target-procedure).
    end.
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateSDO */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateToolbar Procedure 
FUNCTION processLoop-translateToolbar RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Builds translations for toolbars
    Notes:
------------------------------------------------------------------------------*/
    define variable cGenerateLanguages        as character            no-undo.
    
    define buffer gsclg        for gsc_language.
        
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').    
    
    /* Always write the adm-translate-* procedure even if there are no actual 
       translations. This is so that we can set the ObjectTranslated property
       to YES and indicate to the renderer that there's no need to even attempt
       to translate the actions.
     */
    for each gsclg no-lock:
        if not can-do(cGenerateLanguages, gsclg.language_code) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'LanguageCode', gsclg.language_code).
        
        dynamic-function('processLoopIteration' in target-procedure).                             
    end.    /* each language */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateToolbar */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateViewer Procedure 
FUNCTION processLoop-translateViewer RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Builds translations for viewers.
    Notes:
------------------------------------------------------------------------------*/
    define variable cGenerateLanguages        as character            no-undo.
    define variable cObjectName               as character            no-undo.
    define variable lTranslated               as logical              no-undo.
    
    define buffer gsclg        for gsc_language.
    define buffer gsmtr        for gsm_translation.
    
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    
    /* Look for any translations for this language. We don't look for
       the specific object since this means that we ignore any
       global translations. */    
    for each gsclg no-lock,
       first gsmtr where
             gsmtr.language_obj = gsclg.language_obj
             no-lock:
        
        if not can-do(cGenerateLanguages, gsclg.language_code) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'LanguageCode', gsclg.language_code).
        
        dynamic-function('processLoopIteration' in target-procedure).                             
    end.    /* each language */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-translateViewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateViewerItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateViewerItem Procedure 
FUNCTION processLoop-translateViewerItem RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: bulds translations for viewer instances (SDFs and widgets).
    Notes:
------------------------------------------------------------------------------*/
    define variable cLanguageCode        as character                no-undo.
    define variable cContainerName       as character                no-undo.
    define variable cObjectName          as character                no-undo.
    define variable cWidgetType          as character                no-undo.
    define variable cWidgetName          as character                no-undo.
    define variable cValue               as character                no-undo.
    define variable cLabel               as character                no-undo.
    define variable cTooltip             as character                no-undo.
    define variable cOriginalLabel       as character                no-undo.
    define variable cOriginalTooltip     as character                no-undo.
    define variable cEntry               as character                no-undo.
    define variable cDelimiter           as character                no-undo.
    define variable iWidgetEntries       as integer                  no-undo.
    define variable iLoop                as integer                  no-undo.
    define variable lFindTranslations    as logical                  no-undo.
    define variable lLabelTranslated     as logical                  no-undo.
    define variable lTooltipTranslated   as logical                  no-undo.
    define variable lDataTranslated      as logical                  no-undo.    

    define buffer gsclg    for gsc_language.
    
    cLanguageCode = dynamic-function('getTokenValue' in target-procedure, 'LanguageCode').
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    
    find gsclg where gsclg.language_code = cLanguageCode no-lock no-error.
    
    for each ttInstance by ttInstance.Order:
        assign cContainerName = cObjectName
               iWidgetEntries = 0
               lFindTranslations = no
               cWidgetName = ttInstance.InstanceName
               cWidgetType = ttInstance.InstanceType
               cDelimiter = ','
               cOriginalLabel = ''
               cOriginalTooltip = ''.
        
        /* First figure out whether we there is a chance of any translations,
           and set some of the preliminary settings.
         */
        case ttInstance.InstanceType:
            when 'Radio-Set' then
            do:
                find ttProperty where
                     ttProperty.PropertyOwner = ttInstance.InstanceName and
                     ttProperty.PropertyName = 'Radio-Buttons'
                     no-error.
                if available ttProperty then
                do:
                    assign lFindTranslations = yes
                           cOriginalLabel = ttProperty.PropertyValue.
                    
                    find ttProperty where
                         ttProperty.PropertyOwner = ttInstance.InstanceName and
                         ttProperty.PropertyName = 'Delimiter'
                         no-error.
                    if available ttProperty then
                        cDelimiter = ttProperty.PropertyValue.
                    
                    /* There are only half as many items in the combo as there
                       are entries in the List-Item-Pairs property, since half
                       are labels and half are values.
                     */
                    iWidgetEntries = 0.5 * num-entries(cOriginalLabel, cDelimiter).
                end.    /* Radio buttons found */
                
                find ttProperty where
                     ttProperty.PropertyOwner = ttInstance.InstanceName and
                     ttProperty.PropertyName = 'Tooltip'
                     no-error.
                if available ttProperty then
                    assign cOriginalTooltip = ttProperty.PropertyValue
                           lFindTranslations = yes.
                else
                    cOriginalTooltip = ''.
            end.    /* radio set */
            when 'Text' then
            do:
                /* Only FILL-IN VIEW-AS TEXT can be translated */
                if dynamic-function('classIsA' in gshRepositoryManager,
                                    ttInstance.ClassName, 'DynFillIn') then
                    lFindTranslations = yes.
            end.    /* test */
            when 'Combo-Box' then
            do:
                /* The label and tooltip can always be translated. If the
                   combo-box stores data as list item pairs, then we need
                   to translate that data too. The translation routine knows 
                   to attempt the translation because of the widget entries
                   value (it will be 0 for List-Item combos).                   
                 */
                lFindTranslations = yes.
                
                /* Determine whether to translate the list-item-pairs. */
                find ttProperty where
                     ttProperty.PropertyOwner = ttInstance.InstanceName and
                     ttProperty.PropertyName = 'List-Item-Pairs'
                     no-error.
                if available ttProperty and
                   ttProperty.PropertyValue ne ? and
                   ttProperty.PropertyValue ne '' then
                do:
                    cOriginalLabel = ttProperty.PropertyValue.
                    
                    find ttProperty where
                         ttProperty.PropertyOwner = ttInstance.InstanceName and
                         ttProperty.PropertyName = 'Delimiter'
                         no-error.
                    if available ttProperty then
                        cDelimiter = ttProperty.PropertyValue.
                    
                    /* There are only half as many items in the combo as there
                       are entries in the List-Item-Pairs property, since half
                       are labels and half are values.
                     */
                    iWidgetEntries = 0.5 * num-entries(cOriginalLabel, cDelimiter).
                end.    /* property available */
            end.    /* combo box. */
            when 'Sdf' then
            do:
                if dynamic-function('ClassIsA' in gshRepositoryManager,
                                    ttInstance.ClassName, 'DynLookup') then
                    assign cWidgetType = 'Fill-In'
                           cWidgetName = 'fiLookup'
                           cContainerName = cObjectName + ':' + ttInstance.InstanceName
                           lFindTranslations = yes.
                else
                if dynamic-function('ClassIsA' in gshRepositoryManager,
                                    ttInstance.ClassName, 'DynCombo') then
                    assign cWidgetType = 'Combo-Box'
                           cWidgetName = 'fiCombo'
                           cContainerName = cObjectName + ':' + ttInstance.InstanceName
                           lFindTranslations = yes.                                        
            end.    /* sdf */
            when 'Fill-In' or
            when 'Button' or
            when 'Editor' or
            when 'Toggle-Box' or
            when 'Selection-List' then
                lFindTranslations = yes.
        end case.    /* widget type */
        
        /* Now try to do the translations. */
        if lFindTranslations then
        do:
            /* initialize variables */
            assign lLabelTranslated = no
                   lTooltipTranslated = no
                   lDataTranslated = no.
            
            /* get the translations */
            run translateSingleObject in gshTranslationManager ( gsclg.language_obj,
                                                                 cContainerName,
                                                                 cWidgetName,
                                                                 cWidgetType,
                                                                 iWidgetEntries,
                                                                 output cLabel,
                                                                 output cTooltip ) no-error.
        
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceName', ttInstance.InstanceName).
            
            /* Determine the instance type */
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceIsWidget', string(ttInstance.InstanceType ne 'Sdf')).
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceIsSdf', string(ttInstance.InstanceType eq 'Sdf')).
                             
            /* Escape any quotes for translated labels and tooltips */
                assign cLabel = replace(cLabel, "'", "~~'")
                       cLabel = replace(cLabel, '"', '~~"')
                       cTooltip = replace(cTooltip, "'", "~~'")
                       cTooltip = replace(cTooltip, '"', '~~"').
            
            case ttInstance.InstanceType:              
                when 'Radio-Set' then
                do:                    
                    /* Radio-sets can only have their radio-buttons translated,
                       and not their labels. */                    
                    lDataTranslated = (cLabel ne '' and cLabel ne ?).
                    
                    if lDataTranslated then
                    do:
                        lDataTranslated = no.
                        /* Loop through the translated labels, and overlay them on the 
                           original Radio-Buttons property value. */
                        do iLoop = 1 to num-entries(cLabel, chr(3)):
                            cEntry = entry(iLoop, cLabel, chr(3)).
                            /* if not translated then skip */
                            if cEntry eq '' then
                                next.
                            
                            entry(iLoop * 2 - 1, cOriginalLabel, cDelimiter) = cEntry.
                            lDataTranslated = yes.
                        end.    /* loop through labels */
                        
                        if lDataTranslated then
                        do:
                            dynamic-function('setTokenValue' in target-procedure,
                                             'TranslatedDataAttribute', 'Radio-Buttons').
                            
                            dynamic-function('setTokenValue' in target-procedure,
                                             'TranslatedData', cOriginalLabel).
                        end.    /* there are translations */
                    end.    /* data translated */
                    
                    /* Tooltip translations allowed. */
                    /* The value of the tooltip will be blank when
                       there is not translation.
                                           
                       When translating radio-sets, only take the first available
                       translation tooltip.    */
                    /* trim all separator characters, since
                       we trying to find the first available 
                       tooltip. */
                    assign cTooltip = trim(cTooltip, chr(3))
                           cTooltip = entry(1, cTooltip, chr(3)).
                    lTooltipTranslated = (cTooltip ne '' and cTooltip ne ?).
                    
                    if lTooltipTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TooltipAttribute', 'Tooltip').
                        
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedTooltip',  cTooltip).
                    end.    /* tooltip translated */
                end.    /* radio set */
                when 'Text' then
                do:
                    /* Text widgets don't have their labels translated,
                       they have their Screen-Value translated (the data).
                       And also the tooltip. */
                    lDataTranslated = cLabel ne '' and cLabel ne ?.                    
                    if lDataTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedDataAttribute', 'Screen-Value').
                        
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedData', cLabel).
                    end.    /* data translated */
                                        
                    lTooltipTranslated = cTooltip ne '' and cTooltip ne ?.
                    if lTooltipTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TooltipAttribute', 'Tooltip').
                        
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedTooltip', cTooltip).
                    end.    /* tooltip translated */                                         
                end.    /* text */
                when 'Combo-Box' then
                do:
                    /* Combo-boxes support the translations of labels,
                       tooltips and data.                     
                                       
                       For a combo, we receive the translated label as entry 1 in the list.
                       Apply it here before we proceed with the translated combo items. */
                    cEntry = entry(1, cLabel, chr(3)).
                    lLabelTranslated = (cEntry ne '' and cEntry ne ?).
                    if lLabelTranslated then
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedLabel', cEntry).
                    
                    /* Remove the label portion from the translated string. */
                    entry(1, cLabel, chr(3)) = ''.
                    cLabel = substring(cLabel, 2).
                                        
                    /* Now translate the tooltips. */
                    cEntry = entry(1, cTooltip, chr(3)).
                    lTooltipTranslated = (cEntry ne '' and cEntry ne ?).
                    if lTooltipTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TooltipAttribute', 'Tooltip').
                        
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedTooltip', cEntry).
                    end.    /* label translated */
                                        
                    /* the remainder of the list item string consists of 
                       list-item-pairs label translations. */
                    lDataTranslated = (cLabel ne '' and cLabel ne ?).
                    if lDataTranslated then
                    do:
                        lDataTranslated = no.
                        /* Loop through the translated labels, and overlay them on the 
                           original List-Item-Pairs property value. */
                        do iLoop = 1 to num-entries(cLabel, chr(3)):
                            cEntry = entry(iLoop, cLabel, chr(3)).
                            /* if not translated then skip */
                            if cEntry eq '' then
                                next.
                            
                            entry(iLoop * 2 - 1, cOriginalLabel, cDelimiter) = cEntry.
                            lDataTranslated = yes.
                        end.    /* loop through labels */
                        
                        if lDataTranslated then
                        do:
                            dynamic-function('setTokenValue' in target-procedure,
                                             'TranslatedDataAttribute', 'List-Item-Pairs').
                        
                            dynamic-function('setTokenValue' in target-procedure,
                                             'TranslatedData', cOriginalLabel).
                        end.    /* there are translations */
                    end.    /* label translated */                    
                end.    /* combo box. */
                when 'Fill-In' or
                when 'Button' or
                when 'Editor' or
                when 'Toggle-Box' or
                when 'Selection-List' or
                when  'Sdf' then
                do:
                    lLabelTranslated = (cLabel ne '' and cLabel ne ?).
                    
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabelTranslated', string(lLabelTranslated)).
                    
                    if lLabelTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'LabelAttribute', 'Label').
                    
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedLabel', cLabel).                                                                            
                    end.    /* label translated */
                    
                    lTooltipTranslated = cTooltip ne '' and cTooltip ne ?.
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceTooltipTranslated', string(lTooltipTranslated)).
                    
                    if lTooltipTranslated then
                    do:
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TooltipAttribute', 'Tooltip').
                        
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedTooltip', cTooltip).
                    end.    /* tooltip translated */
                end.    /* others */
            end case.    /* widget type */
            
            /* If there are no label translations, and then look for
               any entity translations. */
            if not lLabelTranslated and
               can-do('Combo-Box,Fill-In,Button,Editor,Toggle-Box,Selection-List', ttinstance.InstanceType) then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'TableName' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                
                /* Entity translations are only applicable to DataFields. */
                if (available ttProperty and ttProperty.PropertyValue ne '') and
                   num-entries(ttInstance.ObjectName, '.') ge 2 then
                do:
                    cContainerName = entry(1, ttInstance.ObjectName, '.').
                    cWidgetName = entry(2, ttInstance.ObjectName, '.').
                    cWidgetType = 'DataField'.
                    
                    run translateSingleObject IN gshTranslationManager (gsclg.language_obj,
                                                                        cContainerName,
                                                                        cWidgetName,
                                                                        cWidgetType,
                                                                        1,    /* Labels only */
                                                                        output cLabel,
                                                                        output cTooltip ) no-error.
                    
                    lLabelTranslated = (cLabel ne '' and cLabel ne ?).
                    if lLabelTranslated then
                        dynamic-function('setTokenValue' in target-procedure,
                                         'TranslatedLabel', cLabel).
                    /* Leave the tooltip as is. */
                end.    /* instance is a datafield. */
            end.    /* label not yet translated */
            
            /* Only bother if something's been translated */
            if lLabelTranslated or lTooltipTranslated or lDataTranslated then
            do:
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceLabelTranslated', string(lLabelTranslated)).
                
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceTooltipTranslated', string(lTooltipTranslated)).
                
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceDataTranslated', string(lDataTranslated)).
                
                dynamic-function('processLoopIteration' in target-procedure).
            end.    /* something's been translated */
        end.    /* need to perform translations */
    end.    /* each instance */
        
    error-status:error = no.
    return true.
END FUNCTION.     /* processLoop-translateViewerItem */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-translateWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-translateWindow Procedure 
FUNCTION processLoop-translateWindow RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Translations for window containers.
    Notes:
------------------------------------------------------------------------------*/
    define variable cGenerateLanguages        as character            no-undo.
    define variable cObjectName               as character            no-undo.
    define variable cLabels                   as character            no-undo.
    define variable cTooltips                 as character            no-undo.
    define variable cPageLabels               as character            no-undo.
    define variable iNumberOfPages            as integer              no-undo.
    define variable iLoop                     as integer              no-undo.
    define variable lTranslated               as logical              no-undo.
    
    define buffer gsclg        for gsc_language.
    define buffer gsmtr        for gsm_translation.
    
    cGenerateLanguages = dynamic-function('getTokenValue' in target-procedure, 'GenerateLanguages').
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
    
    iNumberOfPages = 0.
    cPageLabels = ''.
    /* Ignore page 0 */
    for each ttPage where
             ttPage.PageNumber >= 1:
        iNumberOfPages = iNumberOfPages + 1.
        cPageLabels = cPageLabels + '|' + ttPage.PageLabel.
    end.    /* number of pages */
    cPageLabels = left-trim(cPageLabels, '|').
    
    /* Look for any translations for this language. We don't look for
       the specific object since this means that we ignore any
       global translations.
     */    
    for each gsclg no-lock,
       first gsmtr where
             gsmtr.language_obj = gsclg.language_obj
             no-lock:
        if not can-do(cGenerateLanguages, gsclg.language_code) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'LanguageCode', gsclg.language_code).
                    
        lTranslated = no.        
        /* translate page labels */            
        if iNumberOfPages gt 0 then
        do:
            run translateSingleObject in gshTranslationManager (input  gsclg.language_obj,
                                                                input  cObjectName,
                                                                input  'Tab',    /* pcWidgetName */
                                                                input  'Tab',    /* pcWidgetType */
                                                                input  iNumberOfPages,    /* piWidgetEntries */
                                                                output cLabels,
                                                                output cTooltips ) no-error.
            do iLoop = 1 to num-entries(cLabels, chr(3)):
                if entry(iLoop, cLabels, chr(3)) ne '' then
                    assign entry(iLoop, cPageLabels, '|') = entry(iLoop, cLabels, chr(3))
                           lTranslated = yes.
            end.    /* loop through translations */
        end.    /* there are pages */
        
        dynamic-function('setTokenValue' in target-procedure,
                         'TranslatedFolderLabels', string(lTranslated)).
        if lTranslated then
        do:
            cPageLabels = replace(cPageLabels, "'", "~~'").
            cPageLabels = replace(cPageLabels, '"', '~~"').
            dynamic-function('setTokenValue' in target-procedure, 'FolderLabels', cPageLabels).
        end.
        /* Translate the window title */
        lTranslated = no.
        run translateSingleObject in gshTranslationManager (input  gsclg.language_obj,
                                                            input  cObjectName,
                                                            input  'Title',    /* pcWidgetName */
                                                            input  'Title',    /* pcWidgetType */
                                                            input  0,     /* piWidgetEntries */
                                                            output cLabels,
                                                            output cTooltips ) no-error.
        lTranslated = (cLabels ne '').
        
        dynamic-function('setTokenValue' in target-procedure,
                         'TranslatedWindowName', string(lTranslated)).
        if lTranslated then
        do:
            cLabels = replace(cLabels, "'", "~~'").
            cLabels = replace(cLabels, '"', '~~"').
            dynamic-function('setTokenValue' in target-procedure, 'WindowTitle', cLabels).
        end.
        dynamic-function('processLoopIteration' in target-procedure).                             
    end.    /* each language */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* translateWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLoop-viewerInstanceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processLoop-viewerInstanceEvents Procedure 
FUNCTION processLoop-viewerInstanceEvents RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Viewer widget UI events
    Notes:
------------------------------------------------------------------------------*/
    define variable hWidget                as handle                    no-undo.
    define variable cInstanceName          as character                 no-undo.
    define variable cWIdgetType            as character                 no-undo.
    
    cInstanceName = dynamic-function('getTokenValue' in target-procedure, 'InstanceName').
    cWIdgetType = dynamic-function('getTokenValue' in target-procedure, 'InstanceType').
    
    hWidget = dynamic-function('getWidgetHandle' in target-procedure, cWIdgetType).        
    
    for each ttEvent where
             ttEvent.InstanceName = cInstanceName:
        
        if valid-handle(hWidget) and
           not valid-event(hWidget, ttEvent.EventName) then
            next.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'EventName', ttEvent.EventName).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'EventActionType', quoter(ttEvent.ActionType)).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'EventEventAction', quoter(ttEvent.EventAction)).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'EventActionTarget', quoter(ttEvent.ActionTarget)).
                         
        dynamic-function('setTokenValue' in target-procedure,
                         'EventEventParameter', quoter(ttEvent.EventParameter)).
        
        dynamic-function('processLoopIteration' in target-procedure).                                 
    end.    /* each event */
    
    error-status:error = no.
    return true.
END FUNCTION.    /* processLoop-viewerInstanceEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SubClassOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SubClassOf Procedure 
FUNCTION SubClassOf RETURNS LOGICAL
        ( input pcClassName        as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Determines whether the object generated is a sub-class of a specified
                   class
    Notes:
------------------------------------------------------------------------------*/
    define variable cCurrentClass        as character                no-undo.
    
    cCurrentClass = dynamic-function('getTokenValue' in target-procedure, 'ClassName').
    
    error-status:error = no.
    return dynamic-function('ClassIsA' in gshRepositoryManager, cCurrentClass, pcClassName).
END FUNCTION.    /* SubClassOf */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transmogrifyPropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION transmogrifyPropertyValue Procedure 
FUNCTION transmogrifyPropertyValue RETURNS CHARACTER
    (     input pcDataType         as character,
          input pcPropertyValue    as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Ensures that the property values are written to the generated
           file OK.
    Notes: - This will only be called from the processLoop-objectProperties
             functions, since it only applies to master properties that
             are being set in adm-assignObjectProperties().
------------------------------------------------------------------------------*/
    define variable iPos             as integer                        no-undo.
    define variable tDummy           as date                           no-undo.
    
    case pcDataType:
        when 'Date' then
        do:
            /* Dates need to be in MM/DD/YYYY format */
            tDummy = date(pcPropertyValue) no-error.
            if tDummy ne ? then
                pcPropertyValue = string(month(tDummy)) + '/'
                                + string(day(tDummy)) + '/'
                                + string(year(tDummy), '9999').
        end.    /* Date */
        when 'Decimal' or when 'Integer' OR WHEN 'INT64' then
        do:
            /* Numbers should be always dumped in American format. We can
               simply remove the numeric thousands separator. the decimal point
               must be a period (.) though.
             */
            if session:numeric-format ne 'American' then
                    assign pcPropertyValue = replace(pcPropertyValue, session:numeric-separator, '')
                           pcPropertyValue = replace(pcPropertyValue, session:numeric-decimal-point, '.').
        end.    /* Decimal/Integer */
        when 'Character' then
        do:
            /* Semicolons can do some funky stuff in combination with
               certain other characters. Make sure that we escape these
               with a tilde so that we get the behaviour we expect. */
            if index(pcPropertyValue, ';') gt 0 then
            do:
                /* The ;? string in an attribute may cause problems when compiling.
                   the compiler translates this string into a tilde. */
                pcPropertyValue = replace(pcPropertyValue, ';?', '~~;?').
                
                /* Make sure that the last semi-colon in a string is escaped,
                   since ;' (semi-colon + single quote) is a reserved character 
                   set to the compiler and is translated to a backtick. Make sure
                   that this doesn't happen. */
                if ( pcPropertyValue eq ';' or
                     substring(pcPropertyValue, length(pcPropertyValue), 1) = ';')  then
                do:
                    if pcPropertyValue eq ';' then
                        pcPropertyValue = '~~;'.
                    else
                        assign pcPropertyValue = substring(pcPropertyValue, 1, length(pcPropertyValue) - 1)
                               pcPropertyValue = pcPropertyValue + '~~;'.
                end.    /* last character is ;  */
            end.    /* there's a semi-colon in here somewhere */
            
            /* Escape all single quotes in the data. */
            iPos = index(pcPropertyValue, "'").
            if iPos gt 0 then
                pcPropertyValue = replace(pcPropertyValue, "'", "~~~~'").
                
            /* are there any quotes? */        
            iPos = index(pcPropertyValue, '"').

            /* If there's a space in the value, add quotes
               around the character. also, if there are quotes 
               somewhere inside the string, run it through quoter.
             */
            if index(pcPropertyValue, ' ') gt 0 then
                pcPropertyValue = quoter(pcPropertyValue).
            else
            /* if there are no spaces in the string, but there are quotes,
               we need to manually 'quoter' them (quoter doesn't, for some reason).
               this is so that the string passed in to the set has the literal 
               quotes, which is how it is stored in the reposotory.           
             */
            if iPos gt 0 then
                pcPropertyValue = replace(pcPropertyValue, '"', '""').
            
            /* Add single quotes on the outside so that the {set} 
               function handles the string properly.
             */
            pcPropertyValue = "'" + pcPropertyValue + "'".         
        end.    /* character */
    end case.    /* data type */
        
    error-status:error = no.
    return pcPropertyValue.
END FUNCTION.    /* transmogrifyPropertyValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetCanSet Procedure 
FUNCTION widgetCanSet RETURNS CHARACTER
    ( input pcWidgetType       as character,
      input pcAttribute        as character ):
/*------------------------------------------------------------------------------
  Purpose:  Determines whether a widget can set an attribute
    Notes: * Since the generator only allows one parameter, input
             parameter has the format:
                 WidgetType , Attribute
------------------------------------------------------------------------------*/    
    define variable hWidget            as handle                     no-undo.
    
    /* Return no if the input data is bad */
    if pcWidgetType eq '' or pcWidgetType eq ? or
       pcAttribute eq '' or pcAttribute eq ? then
        return string(no).
        
    hWidget = dynamic-function('getWidgetHandle' in target-procedure,
                               pcWidgetType).
    
    /* No widget available? No setting allowed. */
    if not valid-handle(hWidget) then
        return string(no).
    
    /* Widget handles are cleaned up when the generator is 
       shut down.
     */
    
    return string(can-set(hWidget, pcAttribute)).
END FUNCTION.    /* widgetCanSet */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSetDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetCanSetDataType Procedure 
FUNCTION widgetCanSetDataType RETURNS LOGICAL
        ( input pcWidgetType       as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Determines whether the Data-Type attribute can be set for a particular
                   widget type.  
        Notes:
------------------------------------------------------------------------------*/
    error-status:error = no.
    return dynamic-function('widgetCanSet' in target-procedure,
                            pcWidgetType, 'Data-Type').
END FUNCTION.    /* widgetCanSetDataType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetCanSetFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetCanSetFormat Procedure 
FUNCTION widgetCanSetFormat RETURNS LOGICAL
        ( input pcWidgetType       as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Determines whether the Format attribute can be set for a particular
                   widget type. 
        Notes:
------------------------------------------------------------------------------*/
    error-status:error = no.
    return dynamic-function('widgetCanSet' in target-procedure,
                            pcWidgetType, 'Format').
END FUNCTION.    /* widgetCanSetFormat */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIsImage Procedure 
FUNCTION widgetIsImage RETURNS LOGICAL
        ( input pcWidgetType        as character ):
/*------------------------------------------------------------------------------
  Purpose:  Determines whether the widget is an image.
        Notes:
------------------------------------------------------------------------------*/
    error-status:error = no.
    return (pcWidgetType eq 'Image').
END FUNCTION.    /* widgetIsImage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

