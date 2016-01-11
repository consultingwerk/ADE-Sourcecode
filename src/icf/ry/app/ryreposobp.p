&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*---------------------------------------------------------------------------------
  File: ryreposobp.p

  Description:  Object Generation PLIP
  
  Purpose:      Object Generation PLIP

  Parameters:   <none>

  History:
  --------
  August 2001 -- created from ry/app/rywizogenp.p for the ICF
  September 10,2001 -- jrs -- modified storeTableFields to remove the Viewer
     attributes Font, BGColor, FGColor, LabelFont, and LabelBGColor from those
     given default initial values for DataFields.
     
  Modified: 11/02/2001        Mark Davies (MIP)
            Replaced properties/attributes for FrameMinHeightChars and FrameMinWidthChars with MinHeight and MinWidth

  Modified: 11/07/2001        John Palazzo (Progress)
            IZ 2342 : MRU List doesn't work with dynamic objects.
            Fix     : Added function openRyObjectAB as part of fix.
  
  Modified: 11/26/2001        Mark Davies (MIP)
            IZ #3234 - getObjectInfo API code incorrect
            
  Modified: 02/14/2002        Mark Davies (MIP)
            IZ #3939 - Error generating SmartDataFields after loading new data
--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

/* make this an ADE tool so that a reset session does not kill it. Killing this
   causes issues with appbuilder integration
*/
{adecomm/_adetool.i}  /* Mark this file as an ADE Tool                  */

&scop object-name       ryreposobp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}
{checkerr.i &define-only = YES}

DEFINE TEMP-TABLE ttSDO       NO-UNDO
    FIELD cSDOName                AS CHARACTER
    FIELD iPageNumber             AS INTEGER
    FIELD cBrowserName            AS CHARACTER
    FIELD cParentSDO              AS CHARACTER
    FIELD dSDOSmartObject         AS DECIMAL
    FIELD dSDOObjectInstance      AS DECIMAL
    FIELD lForeignFields          AS LOGICAL
    FIELD lOneToOne               AS LOGICAL
    FIELD lContainer              AS LOGICAL 
    FIELD lCommit                 AS LOGICAL
    INDEX key1 cSDOName
    INDEX key2 iPageNumber cSDOName.

DEFINE TEMP-TABLE ttViewer    NO-UNDO
    FIELD cViewerName             AS CHARACTER
    FIELD cSDOName                AS CHARACTER
    FIELD lPrimary                AS LOGICAL
    FIELD lLinkToSDO              AS LOGICAL
    FIELD dViewerSmartObject      AS DECIMAL
    FIELD dViewerObjectInstance   AS DECIMAL
    INDEX key1 cViewerName cSDOName lPrimary
    INDEX key2 cSDOName cViewerName lPrimary
    .

DEFINE TEMP-TABLE ttBrowser   NO-UNDO
    FIELD cBrowserName            AS CHARACTER
    FIELD cSDOName                AS CHARACTER
    FIELD lToolbarRequired        AS LOGICAL
    FIELD dBrowserSmartObject     AS DECIMAL
    FIELD dBrowserObjectInstance  AS DECIMAL
    INDEX key1 cBrowserName cSDOName
    INDEX key2 cSDOName cBrowserName
    .

DEFINE TEMP-TABLE ttPage      NO-UNDO
    FIELD iPageNumber             AS INTEGER
    FIELD dPageObj                AS DECIMAL
    INDEX key1 iPageNumber
    .

/* New temp-table to hold values describing all the objects in a layout. */
{ry/app/ryreposlay.i}

/* this is object temptable for original window -- in case user tries
 * to change it
 */
DEFINE TEMP-TABLE ttORigObject NO-UNDO
    FIELD LayoutPosition         AS CHARACTER
    FIELD LayoutObjectType       AS CHARACTER
    FIELD LayoutTemplateObj      AS LOGICAL
    FIELD LayoutAttributeLabels  AS CHARACTER
    FIELD LayoutAttributeValues  AS CHARACTER
    FIELD LayoutInstance         AS CHARACTER.

    /* This temp-table is used by updateContainer to map template
       instances to actual instances for a window being created. */
DEFINE TEMP-TABLE ttInstance NO-UNDO
    FIELD TemplateInstanceID AS DECIMAL
    FIELD NewInstanceID      AS DECIMAL.

DEFINE TEMP-TABLE ttObject NO-UNDO
    FIELD ObjectName        AS CHARACTER
    FIELD ObjectDescription AS CHARACTER.

DEFINE TEMP-TABLE ttLbObject NO-UNDO
    FIELD ObjectName            AS CHARACTER
    FIELD TemplateObject        AS LOGICAL
    FIELD InstanceObjId         AS DECIMAL
    FIELD POSITION              AS CHARACTER
    FIELD objectType            AS CHARACTER
    FIELD objectDescription     AS CHARACTER
    FIELD productmodule         AS CHARACTER
    FIELD tObjectInstanceObj    AS DECIMAL          /* Used for setting properties */
    FIELD tAttributeLabels      AS CHARACTER        /* Used for setting properties */
    FIELD tAttributeValues      AS CHARACTER        /* Used for setting properties */
    .

DEFINE TEMP-TABLE ttLbLink NO-UNDO
    FIELD linkName   AS CHARACTER
    FIELD linkSource AS CHARACTER
    FIELD linkTarget AS CHARACTER.


/*  Holds the value of the current product module for the AppBuilder. String is 
    in the form "pm_Code // pm_Description". See function productModuleList for 
    details. IZ 3195  */
DEFINE VARIABLE gCurrentProductModule AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-attributeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD attributeObj Procedure 
FUNCTION attributeObj RETURNS DECIMAL
  ( INPUT pcAttributeName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentProductModule Procedure 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  ( /* */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkNames Procedure 
FUNCTION getLinkNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkTypeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkTypeObj Procedure 
FUNCTION linkTypeObj RETURNS DECIMAL
  ( INPUT pcSmartLinkType AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectAlreadyExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ObjectAlreadyExists Procedure 
FUNCTION ObjectAlreadyExists RETURNS LOGICAL
    ( INPUT pcObjectFilename        AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectTypeCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ObjectTypeCode Procedure 
FUNCTION ObjectTypeCode RETURNS CHARACTER
  ( INPUT pObjectTypeObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectTypeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ObjectTypeObj Procedure 
FUNCTION ObjectTypeObj RETURNS DECIMAL
  ( INPUT pcObjectType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openRyObjectAB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openRyObjectAB Procedure 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-productModuleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD productModuleList Procedure 
FUNCTION productModuleList RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-productModuleNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD productModuleNames Procedure 
FUNCTION productModuleNames RETURNS CHARACTER
    ( INPUT plDisplayRepository     AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentProductModule Procedure 
FUNCTION setCurrentProductModule RETURNS CHARACTER
  ( INPUT pm AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-smartObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD smartObjectNames Procedure 
FUNCTION smartObjectNames RETURNS CHARACTER
  ( INPUT pcPartialName AS CHARACTER,
    INPUT pcType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-smartobjectObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD smartobjectObj Procedure 
FUNCTION smartobjectObj RETURNS DECIMAL

      ( INPUT pcSmartObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-staticObjectTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD staticObjectTypes Procedure 
FUNCTION staticObjectTypes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-templateObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD templateObjectName Procedure 
FUNCTION templateObjectName RETURNS CHARACTER
  ( INPUT pcObjectType AS CHARACTER )  FORWARD.

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
         HEIGHT             = 21.52
         WIDTH              = 53.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addSDOsToPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSDOsToPage Procedure 
PROCEDURE addSDOsToPage :
/*------------------------------------------------------------------------------
  Purpose:     Put SDO's on page - once
  Parameters:  input object name
               input container object number
               output error text if any
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdContainer                  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSequence                           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSDOInstance                        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSource                             AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bttSDO FOR ttSDO.

  ASSIGN pcErrorText = "":U.
  
  /* create all SDO instances - each SDO only once on 1st page referenced */
  ASSIGN iSequence = 99.  /* to avoid compatibility issues with old version of program */
  /* We have created an SDO to represent the ObjectController .. 
     so make sure we don't create an instance for it.  */
  FOR EACH ttSDO WHERE ttSDO.cSDOName <> '':U BY ttSDO.iPageNumber:
    ASSIGN iSequence = iSequence + 1.
    
    FIND FIRST ttPage WHERE ttPage.iPageNumber = ttSDO.iPageNumber.
    
    RUN updateObjectInstance (INPUT pcObjectName,
                              INPUT pdContainer,
                              INPUT ttSDO.cSDOName + (IF ttSDO.cBrowserName <> "":U THEN (CHR(3) + ttSDO.cBrowserName) ELSE "":U),
                              INPUT ",":U + STRING(ttSDO.iPageNumber),
                              INPUT "sdo":U,
                              OUTPUT dSmartObject,
                              OUTPUT dObjectType,
                              OUTPUT dSDOInstance).
    ASSIGN
      ttSDO.dSDOSmartObject = dSmartObject
      ttSDO.dSDOObjectInstance = dSDOInstance
      .
    /* and add to appropriate page */
    RUN updatePageObject(INPUT pdContainer,
                         INPUT ttSDO.dSDOObjectInstance,
                         INPUT ttPage.dPageObj,
                         INPUT iSequence).    
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.
  END.
  
  /* Create links for SDO's with foreign fields */
  FOR EACH ttSDO WHERE ttSDO.lForeignFields = YES:

    IF ttSDO.cParentSDO <> "":U THEN
      FIND FIRST bttSDO
           WHERE bttSDO.cSDOName = ttSDO.cParentSDO
           NO-ERROR.
    IF ttSDO.cParentSDO <> "":U AND AVAILABLE bttSDO THEN
      ASSIGN dSource = bttSDO.dSDOObjectInstance.
    ELSE
      ASSIGN dSource = 0.
    
    /* create links from container for pass-thru if sdo has foreign fields */  
    RUN updateLink (INPUT "Data":U,
                    INPUT "":U,
                    INPUT pdContainer,
                    INPUT dSource,
                    INPUT ttSDO.dSDOObjectInstance).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.

    RUN updateLink (INPUT "ToggleData":U,
                    INPUT "":U,
                    INPUT pdContainer,
                    INPUT dSource,
                    INPUT ttSDO.dSDOObjectInstance).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPageTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageTables Procedure 
PROCEDURE buildPageTables :
/*------------------------------------------------------------------------------
  Purpose:     Build temp-tables used for folder generation
  Parameters:  input folder wizard object number
               output table of sdo info on container
               output table of viewer info on container
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdFoldObj                AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttSDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttViewer.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE cViewerSDOList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowserSDOList                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSDO                            AS CHARACTER  NO-UNDO.

EMPTY TEMP-TABLE ttSDO.
EMPTY TEMP-TABLE ttViewer.
EMPTY TEMP-TABLE ttBrowser.

FIND FIRST brym_wizard_fold NO-LOCK WHERE brym_wizard_fold.wizard_fold_obj = pdFoldObj
     NO-ERROR.

FOR EACH rym_wizard_fold_page NO-LOCK
   WHERE rym_wizard_fold_page.wizard_fold_obj = pdFoldObj
      BY PAGE_number:

  /* Is the SDO there already ?
     NOTE: we also create a ttSDO when sdoname = '', which represents the SDO/SBO
     passed from the object container, we use this to store info for which 
     pass-thru links to create. */
  FIND FIRST ttSDO
       WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
       NO-ERROR.
  IF NOT AVAILABLE ttSDO THEN
  DO:
    CREATE ttSDO.
    ASSIGN
      ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
      ttSDO.iPageNumber = rym_wizard_fold_page.PAGE_number
      ttSDO.lForeignFields = rym_wizard_fold_page.sdo_foreign_fields <> "":U
      ttSDO.cParentSDO = rym_wizard_fold_page.parent_sdo_object_name
      ttSDO.dSDOSmartObject = 0
      ttSDO.dSDOObjectInstance = 0        
      .
  END.
  IF ttSDO.lForeignFields = NO AND rym_wizard_fold_page.sdo_foreign_fields <> "":U THEN
    ASSIGN ttSDO.lForeignFields = YES.
  IF ttSDO.cBrowserName = "":U AND rym_wizard_fold_page.browser_object_name <> "":U THEN
    ASSIGN ttSDO.cBrowserName = rym_wizard_fold_page.browser_object_name.
  

  /* Found a viewer */
  IF rym_wizard_fold_page.viewer_object_name <> "":U THEN
  DO:
    FIND FIRST ttViewer
         WHERE ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
         NO-ERROR.
    IF NOT AVAILABLE ttViewer THEN
    DO:
      CREATE ttViewer.
      ASSIGN
        ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
        ttViewer.dViewerSmartObject = 0
        ttViewer.dViewerObjectInstance = 0        
        ttViewer.lPrimary = rym_wizard_fold_page.primary_viewer
        ttViewer.lLinkToSDO = rym_wizard_fold_page.link_viewer_to_sdo
        .
    END.
    IF ttViewer.cSDOName = "":U AND rym_wizard_fold_page.sdo_object_name <> "":U THEN
      ASSIGN ttViewer.cSDOName = rym_wizard_fold_page.sdo_object_name.
    IF ttViewer.lPrimary = NO AND rym_wizard_fold_page.primary_viewer = YES THEN
      ASSIGN ttViewer.lPrimary = YES.
  
    IF ttViewer.cSDOName <> "":U AND 
       LOOKUP(ttViewer.cSDOName, cViewerSDOList) = 0 THEN
      ASSIGN
        cViewerSDOList = cViewerSDOList + (IF cViewerSDOList <> "":U THEN ",":U ELSE "":U) +
                         ttViewer.cSDOName
        .
    ASSIGN
      /* We know we have a Container (SBO) if any of the viewers defines UpdateTargetNames */
      ttSDO.lContainer    = ttSDO.lContainer OR rym_wizard_fold_page.viewer_update_target_names <> '':U
      /* We know it's a one-to-one if there's more than one of them OR the user has 'forced'       
       GroupAssign link between viewers, (a special case of viewer_link_name ) */   
      ttSDO.lOneToOne     = ttSDO.lOneToOne  
                            OR  brym_wizard_fold.viewer_link_name = 'GroupAssign':U
                            OR NUM-ENTRIES(rym_wizard_fold_page.viewer_update_target_names) > 1
      /* We currently only use commit if it's a container and NOT onetoOne, 
         we keep it as separate info just to simplify a future independent change of this.. */ 
      ttSDO.lCommit       = ttSDO.lContainer AND NOT ttSDO.lOneToOne.
  END.

  /* Found a browser */
  IF rym_wizard_fold_page.browser_object_name <> "":U THEN
  DO:
    FIND FIRST ttBrowser
         WHERE ttBrowser.cBrowserName = rym_wizard_fold_page.browser_object_name
         NO-ERROR.
    IF NOT AVAILABLE ttBrowser THEN
    DO:
      CREATE ttBrowser.
      ASSIGN
        ttBrowser.cBrowserName = rym_wizard_fold_page.Browser_object_name
        ttBrowser.lToolbarRequired = NO
        ttBrowser.dBrowserSmartObject = 0
        ttBrowser.dBrowserObjectInstance = 0        
        .
    END.
    IF ttBrowser.cSDOName = "":U AND rym_wizard_fold_page.sdo_object_name <> "":U THEN
      ASSIGN ttBrowser.cSDOName = rym_wizard_fold_page.sdo_object_name.
  
    IF ttBrowser.cSDOName <> "":U AND 
       LOOKUP(ttBrowser.cSDOName, cBrowserSDOList) = 0 THEN
      ASSIGN
        cBrowserSDOList = cBrowserSDOList + (IF cBrowserSDOList <> "":U THEN ",":U ELSE "":U) +
                         ttBrowser.cSDOName
        .
  END.
      
END.

/* Check if browsers linked to sdo have foreign fields if not set yet */
FOR EACH ttSDO
   WHERE ttSDO.lForeignFields = NO AND ttSDO.cBrowserName <> "":U:
   
  FIND FIRST rym_wizard_brow NO-LOCK
       WHERE rym_wizard_brow.OBJECT_name = ttSDO.cBrowserName
       NO-ERROR.
  IF AVAILABLE rym_wizard_brow
     AND rym_wizard_brow.sdo_foreign_fields <> "":U THEN
    ASSIGN ttSDO.lForeignFields = YES.
END.

/* check at least 1 and only 1 primary viewer per SDO */
DO iLoop = 1 TO NUM-ENTRIES(cViewerSDOList):
  ASSIGN cSDO = ENTRY(iLoop, cViewerSDOList).

  /* ensure only 1 primary viewer per sdo */
  IF NOT CAN-FIND(ttViewer WHERE ttViewer.cSDOName = cSDO
                             AND ttViewer.lPrimary = YES) THEN
  FOR EACH ttViewer
     WHERE ttViewer.cSDOName = cSDO
       AND ttViewer.lPrimary = YES:
    ASSIGN ttViewer.lPrimary = NO.
  END.

  /* ensure 1 primary viewer per sdo */
  IF NOT CAN-FIND(FIRST ttViewer
                  WHERE ttViewer.cSDOName = cSDO
                    AND ttViewer.lPrimary = YES) THEN
  DO:
    FIND FIRST ttViewer
         WHERE ttViewer.cSDOName = cSDO
         NO-ERROR.
    IF AVAILABLE ttViewer THEN ASSIGN ttViewer.lPrimary = YES.
  END.

END.

/* See if browser has a viewer linked to sdo and if not, set browser
   to require a toolbar
*/
FOR EACH ttBrowser:
/*   IF NOT CAN-FIND(FIRST ttViewer                                     */
/*                   WHERE ttViewer.cSDOName = ttBrowser.cSDOName) THEN */
    ASSIGN ttBrowser.lToolbarRequired = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObject Procedure 
PROCEDURE deleteObject :
/*------------------------------------------------------------------------------
  Purpose:     Delete all data for object first - before re-generating
  Parameters:  input object name
               output error text if any
  Notes:       Does not delete the gsc_object or ryc_smartobject records
               as this may cause issues due to the fact we need to retain their
               object numbers.
               It does however delete all the following records
               ryc_page information
               ryc_page_object information
               ryc_object_instance information
               ryc_smartlink information
               ryc_attribute_value information for smartobject and instances
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_page FOR ryc_page.
DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

tran-block:
DO FOR bryc_page, bryc_object_instance, bryc_attribute_value, bryc_smartobject
       TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block: 

  FIND FIRST bryc_smartobject NO-LOCK
       WHERE bryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE bryc_smartobject THEN RETURN.
  
  /* Object exists, delete all instances, which will also zap instance attributes and links */
  FOR EACH bryc_object_instance EXCLUSIVE-LOCK
     WHERE bryc_object_instance.container_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* zap any page records which will also zap page object records */
  FOR EACH bryc_page EXCLUSIVE-LOCK
     WHERE bryc_page.container_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* Finally zap object attributes */
  FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
     WHERE bryc_attribute_value.PRIMARY_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

END.  /* tran-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObjectInstance Procedure 
PROCEDURE deleteObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     Delete an object instance, which will also delete its attribute values.
               Intended for example to delete a DataField instance that is no longer 
               contained in a Viewer. 
  Parameters:  INPUT container name
               INPUT object name
               OUTPUT error text if any
  
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER  pcContainerName             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER  pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE dContainer AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObject    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dInstance  AS DECIMAL    NO-UNDO.

tran-block:
DO FOR bryc_object_instance, bryc_attribute_value
       TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block: 
  /* First find the smartobject record for the Object to be deleted and the
     Container it's being deleted from. We'll use these to locate the instance itself. */
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN RETURN.
  dObject = ryc_smartobject.smartobject_obj.
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = pcContainerName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN RETURN.
  dContainer = ryc_smartobject.smartobject_obj.

  /* Object exists, delete all instances, which will also zap instance attributes and links */
  FIND bryc_object_instance EXCLUSIVE-LOCK
     WHERE bryc_object_instance.container_smartobject_obj = dContainer AND
           bryc_object_instance.smartobject_obj = dObject NO-ERROR.
    IF AVAILABLE bryc_object_instance THEN 
    DO:
        dInstance = bryc_object_instance.OBJECT_instance_obj.
        DELETE bryc_object_instance NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}    
        pcErrorText = cMessageList.
        IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
    END.

  /* Finally zap object attributes */
  FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
     WHERE bryc_attribute_value.PRIMARY_smartobject_obj = 
             dInstance:
    DELETE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

END.  /* tran-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchAttributeValue Procedure 
PROCEDURE fetchAttributeValue :
/*------------------------------------------------------------------------------
  Purpose:    returns a single requested attribute value of an object or
              type. 
  Parameters:  INPUT pdSmartobject -- object ID of the object. This can be
               a Smartobject, an objectInstance, or an objectType. 
               The attribute value for the object at that level are returned.
               INPUT pcAttrLabel -- name of the attribute
               OUTPUT pcAttrValue -- attribute value as CHAR
               
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pdSmartobject AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttrLabel   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcAttrValue   AS CHARACTER  NO-UNDO.

/* The object ID passed in may be for an object type, smartobject, or instance.
   Simply try until we find it. */
FIND gsc_object_type WHERE gsc_object_type.object_type_obj =
    pdSmartobject NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
    FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj =
      pdSmartObject NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_smartobject THEN
    DO:
        FIND ryc_object_instance WHERE ryc_object_instance.object_instance_obj =
          pdSmartobject NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_object_instance THEN
            RETURN  {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
                  "'object ID'" pdSmartobject}.
    END.   /* END DO IF searching instance */
END.       /* END DO IF searching smartobject */

/* Now we have the object ID, from wherever. Find the attribute value
   for it.  */

IF AVAILABLE gsc_object_type THEN
    /* Returning attribute for an object type. */
    FIND ryc_attribute_value WHERE 
         ryc_attribute_value.object_type_obj = gsc_object_type.object_type_obj AND
         ryc_attribute_value.object_instance_obj = 0 AND 
         ryc_attribute_value.smartobject_obj = 0 AND
         ryc_attribute_value.attribute_label = pcAttrLabel NO-LOCK NO-ERROR.
ELSE IF AVAILABLE ryc_smartobject THEN
    /* Returning attribute value for a smartobject. */
    FIND ryc_attribute_value WHERE 
         ryc_attribute_value.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
         ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj AND 
         ryc_attribute_value.OBJECT_instance_obj = 0 AND
         ryc_attribute_value.attribute_label = pcAttrLabel NO-LOCK NO-ERROR.
ELSE DO:
    /* If nothing else there will be an instance record. */
    FIND ryc_smartobject WHERE 
         ryc_smartobject.smartobject_obj =
           ryc_object_instance.smartobject_obj NO-LOCK.
    FIND ryc_attribute_value WHERE    
          ryc_attribute_value.OBJECT_type_obj = 
            ryc_smartobject.OBJECT_type_obj AND
          ryc_attribute_value.object_instance_obj =
            ryc_object_instance.object_instance_obj AND
          ryc_attribute_value.smartobject_obj =
            ryc_object_instance.smartobject_obj AND
          ryc_attribute_value.attribute_label = pcAttrLabel NO-LOCK NO-ERROR.              
END.     /* END FIND attribute_value for instance. */

    ASSIGN pcAttrValue = (IF AVAILABLE ryc_attribute_value THEN
                              DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                               INPUT ryc_attribute_value.attribute_type_TLA,
                                               INPUT ryc_attribute_value.attribute_value     ) 
                          ELSE ?).
RETURN.
                                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchAttributeValues Procedure 
PROCEDURE fetchAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:    returns a list of the attribute names and values of an object or
              type. 
  Parameters:  INPUT pdSmartobject -- object ID of the object. This can be
               a Smartobject, an objectInstance, or an objectType. 
               The attribute values for the object at that level are returned.
               OUTPUT pcAttrList -- list of attributes and their values
               in the standard format, with CHR(3) as a delimiter between
               name/value pairs and CHR(4) as a delimiter between name and value.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pdSmartobject AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcAttrList    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cAttrNames  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttrValues AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttrList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iIndex      AS INTEGER    NO-UNDO.

/* The object ID passed in may be for an object type, smartobject, or instance.
   Simply try until we find it. */
FIND gsc_object_type WHERE gsc_object_type.object_type_obj =
    pdSmartobject NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
    FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj =
      pdSmartObject NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_smartobject THEN
    DO:
        FIND ryc_object_instance WHERE ryc_object_instance.object_instance_obj =
          pdSmartobject NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_object_instance THEN
            RETURN  {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
                  "'object ID'" pdSmartobject}.
    END.   /* END DO IF searching instance */
END.       /* END DO IF searching smartobject */

/* Now we have the object ID, from wherever. Assemble all the attribute values
   for it. Note that for consistency, we read the actual attribute value
   records to do this, even though in the case of the object_instance we
   could just return the attribute_list field, which should be the same. First we 
   build up the right intermediate lists of names and values. */


IF AVAILABLE gsc_object_type THEN
    /* Returning attributes for an object type. */
    FOR EACH ryc_attribute_value WHERE 
         ryc_attribute_value.object_type_obj = gsc_object_type.object_type_obj AND
         ryc_attribute_value.object_instance_obj = 0 AND 
         ryc_attribute_value.smartobject_obj = 0 NO-LOCK:
          ASSIGN cAttrNames = cAttrNames + ",":U + ryc_attribute_value.attribute_label
                 cAttrValues = cAttrValues + CHR(4) + DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                                       INPUT ryc_attribute_value.attribute_type_TLA,
                                                                       INPUT ryc_attribute_value.attribute_value).
    END.   /* END FOR EACH attribute_value for object_type */
ELSE IF AVAILABLE ryc_smartobject THEN
    FOR EACH ryc_attribute_value WHERE 
         ryc_attribute_value.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj AND
         ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj AND 
         ryc_attribute_value.OBJECT_instance_obj = 0:
          ASSIGN cAttrNames = cAttrNames + ",":U + ryc_attribute_value.attribute_label
                 cAttrValues = cAttrValues + CHR(4) + DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                                       INPUT ryc_attribute_value.attribute_type_TLA,
                                                                       INPUT ryc_attribute_value.attribute_value).
    END.     /* END FOR EACH attribute_value for smartobject */
ELSE DO:
     /* If nothing else there will be an instance record. */
     FIND ryc_smartobject WHERE   /* we need the object_type_obj */
         ryc_smartobject.smartobject_obj =
           ryc_object_instance.smartobject_obj NO-LOCK.
    FOR EACH ryc_attribute_value WHERE    
          ryc_attribute_value.OBJECT_type_obj = 
            ryc_smartobject.OBJECT_type_obj AND
          ryc_attribute_value.object_instance_obj =
            ryc_object_instance.object_instance_obj AND
          ryc_attribute_value.smartobject_obj =
            ryc_object_instance.smartobject_obj:
              ASSIGN cAttrNames = cAttrNames + ",":U + ryc_attribute_value.attribute_label
                 cAttrValues = cAttrValues + CHR(4) + DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                                       INPUT ryc_attribute_value.attribute_type_TLA,
                                                                       INPUT ryc_attribute_value.attribute_value).
         END.     /* END FOR EACH attribute_value for instance. */
END.              /* END DO for object instance */

/* Now we've got the attribute names and values. Put them together in the final format. */

DO iIndex = 2 TO NUM-ENTRIES(cAttrNames):  /* "2" because there's an empty first entry from the loop. */
    pcAttrList = pcAttrList + (IF pcAttrList = "":U THEN "":U ELSE CHR(3)) +
        ENTRY(iIndex, cAttrNames) + CHR(4) + ENTRY(iIndex, cAttrValues, CHR(4)).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLayoutObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLayoutObjects Procedure 
PROCEDURE fetchLayoutObjects :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a Layout name and returns a temp-table with the
               types, layout positions, and current attribute values of
               all of the template objects in the layout.
  Parameters:  INPUT pcLayoutName
               OUTPUT ttLayoutObject
  Notes:       This procedure is used to furnish the User Interface with the
               information it needs to prompt for actual SmartObjects to use
               in place of the template placeholder objects, and to display
               and permit modifications to the property values of each object.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcLayoutName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttLayoutObject.

    DEFINE BUFFER tmpl_smo         FOR ryc_smartobject.
    DEFINE BUFFER tmpl_instance    FOR ryc_object_instance.
    DEFINE BUFFER tmpl_object_type FOR gsc_object_type.
    DEFINE BUFFER tmpl_attr_value  FOR ryc_attribute_value.
    DEFINE BUFFER tmpl_link        FOR ryc_smartlink.

    DEFINE VARIABLE dLayout     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cAttrLabels AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAttrValues AS CHARACTER  NO-UNDO.

    EMPTY TEMP-TABLE ttLayoutObject.
    /* First locate the smartobject record for the layout. */
    FIND tmpl_smo WHERE OBJECT_filename = pcLayoutName NO-ERROR.
    IF NOT AVAILABLE tmpl_smo THEN
    DO:
      RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
          "'Object Filename'" pcLayoutName}.   
    END.
    ELSE ASSIGN dLayout = tmpl_smo.smartobject_obj.

    /* Next loop through all of its Instance objects to find those that
       are template objects. */
    FOR EACH tmpl_instance 
        WHERE tmpl_instance.container_smartobject_obj =
              tmpl_smo.smartobject_obj:
        FIND tmpl_smo WHERE tmpl_smo.smartobject_obj = 
             tmpl_instance.smartobject_obj.
        /* Populate the Temp-Table with types, positions, and
           attribute lists of template objects. */
        FIND tmpl_object_type WHERE tmpl_object_type.OBJECT_type_obj =
            tmpl_smo.object_type_obj.   /* To get the Object Type Name */
        /* Build up the names and values of all attrs. in the template */
        ASSIGN cAttrLabels = "":U
               cAttrValues = "":U.
        FOR EACH tmpl_attr_value WHERE 
            tmpl_attr_value.OBJECT_type_obj =
                tmpl_object_type.OBJECT_type_obj AND
            tmpl_attr_value.smartobject_obj =
                tmpl_smo.smartobject_obj AND
            tmpl_attr_value.OBJECT_instance_obj =
                tmpl_instance.OBJECT_instance_obj:
                cAttrLabels = cAttrLabels +
                    (IF cAttrLabels = "" THEN "" ELSE ",") +
                      tmpl_attr_value.attribute_label.
                cAttrValues = cAttrValues +
                    (IF cAttrValues = "" THEN "" ELSE CHR(3)) +
                      DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                        INPUT tmpl_attr_value.attribute_type_TLA,
                                        INPUT tmpl_attr_value.attribute_value).
        END.   /* END FOR EACH attr_value */
        

        /* Now create a temp-table record to describe this object, to
           be passed back to the caller. */
        CREATE ttLayoutObject.
       
        ASSIGN ttLayoutObject.LayoutPosition = 
                  tmpl_instance.layout_position
               ttLayoutObject.LayoutObjectType =
                  tmpl_object_type.OBJECT_type_code
               ttLayoutObject.LayoutTemplateObj =
                  tmpl_smo.template_smartobject
            /* Taj: added objectname because object might not be a
             * template -- it could be a real instance in the layout
             */
               ttLayoutObject.LayoutInstance = tmpl_smo.OBJECT_filename  /* taj  */
               ttLayoutObject.LayoutAttributeLabels = cAttrLabels
               ttLayoutObject.LayoutAttributeValues = cAttrValues.
               
         /* taj: look at links and signal which sdos are data targets */
         /* so caller can prompt for foreign fields */
         FOR EACH tmpl_link WHERE
           tmpl_link.container_smartobject_obj = dLayout 
             AND tmpl_link.target_object_instance_obj 
                  = tmpl_instance.OBJECT_instance_obj 
             AND tmpl_link.link_name = "Data":U
             AND tmpl_instance.layout_position BEGINS "SDO":U:
                 ASSIGN ttLayoutObject.LayoutPosition = ttLayoutObject.LayoutPosition + "Target":U.
         END. /* for each tmpl_link*/
                      
    END.       /* END FOR EACH tmpl_instance */
    
    RETURN.    /* Send the LayoutObject table back to the caller. */
                                                                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchObjectNames Procedure 
PROCEDURE fetchObjectNames :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of matching names for a possible partial SmartObject 
            name. The main purpose is to allow auto-completion for the window-
            builder tool and others like it, pending availability of the other
            dynamic components to enable a fully dynamic layout window to be built.
Parameters: pcPartialName AS CHARACTER; possible incomplete object name
            pcObjectType AS CHARACTER; smartobject type
            OUTPUT ttObject temp-table with Objectname and ObjectDescriptions fields.
    Notes:  The is really intended as a stop-gap until the modified dynamic lookup,
            dynamic viewer, etc. are available.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPartialName           AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectType            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttObject.

DEFINE VARIABLE cObjectNames AS CHARACTER  NO-UNDO.

FIND gsc_object_type WHERE gsc_object_type.OBJECT_type_code = pcObjectType 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
                  "'object type'" pcObjectType}.

  FOR EACH ryc_smartobject WHERE 
      ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj AND
        ryc_smartobject.OBJECT_filename BEGINS pcPartialName:
      FIND gsc_object WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj.

      CREATE ttObject.
      ASSIGN ttObject.ObjectName        = ryc_smartobject.OBJECT_filename
             ttObject.ObjectDescription = gsc_object.OBJECT_description.
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateFolderPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateFolderPages Procedure 
PROCEDURE generateFolderPages :
/*------------------------------------------------------------------------------
  Purpose:     Generate folder wizard pages
  Parameters:  input folder object name
               input container object number
               input container toolbar instance object number
               output error message text if any
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcObjectName                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pdContainer                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdContainerToolbarInstance   AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerToolbarInstance              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserToolbarInstance             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserInstance                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDOInstance                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iSequence                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

EMPTY TEMP-TABLE ttPage.

ASSIGN
  pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_fold TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  FIND FIRST brym_wizard_fold NO-LOCK
       WHERE brym_wizard_fold.OBJECT_name = pcObjectName
       NO-ERROR.

  RUN buildPageTables (INPUT brym_wizard_fold.wizard_fold_obj,
                       OUTPUT TABLE ttSDO,
                       OUTPUT TABLE ttViewer).

  FOR EACH rym_wizard_fold_page NO-LOCK
     WHERE rym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
        BY rym_wizard_fold_page.PAGE_number:

    ASSIGN cLayout = rym_wizard_fold_page.PAGE_layout.
    IF cLayout = "":U THEN
      ASSIGN cLayout = brym_wizard_fold.PAGE_layout.
    IF cLayout = "":U THEN 
      ASSIGN cLayout = "Top/Multi/Bottom":U.
    
    RUN updatePage (INPUT pdContainer,
                    INPUT rym_wizard_fold_page.PAGE_number,
                    INPUT rym_wizard_fold_page.PAGE_label,
                    INPUT cLayout).   
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.

  /* Add SDO's */
  RUN addSDOsToPage (INPUT pcObjectName,
                     INPUT pdContainer,
                     OUTPUT pcErrorText).
  IF pcErrorText <> "":U THEN DO: UNDO tran-block, LEAVE tran-block. END.
  
  ASSIGN iSequence = 199.
  page-loop:
  FOR EACH rym_wizard_fold_page NO-LOCK
     WHERE rym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
        BY rym_wizard_fold_page.PAGE_number:

    FIND FIRST ttPage WHERE ttPage.iPageNumber = rym_wizard_fold_page.PAGE_number.

    /* create object instances on page */
    IF LENGTH(rym_wizard_fold_page.browser_object_name) > 0 THEN
    DO: /* browser on page */
      /* Add browser */
      RUN updateObjectInstance (INPUT pcObjectName,
                                INPUT pdContainer,
                                INPUT rym_wizard_fold_page.browser_object_name,
                                INPUT "centre2,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                INPUT "brow":U,
                                OUTPUT dSmartObject,
                                OUTPUT dObjectType,
                                OUTPUT dBrowserInstance).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
    
      /* Force all fields in browser to disabled for now, 
         also set DataSourceNames, which indicates the SDO query when linked to an SBO */
      ASSIGN
        cAttributeLabels = "EnabledFields,DataSourceNames":U
                         
        cAttributeValues = "":U + CHR(3)
                         + rym_wizard_fold_page.query_sdo_name 
        .
      RUN updateAttributeValues (INPUT dObjectType,
                                 INPUT dSmartObject,
                                 INPUT pdContainer,
                                 INPUT dBrowserInstance,
                                 INPUT cAttributeLabels,
                                 INPUT cAttributeValues).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* update browser temp-table */
      FIND FIRST ttBrowser 
           WHERE ttBrowser.cBrowserName = rym_wizard_fold_page.Browser_object_name
           NO-ERROR.
      IF NOT AVAILABLE ttBrowser THEN
      DO:
        ASSIGN pcErrorText = "Browser not found in temp table: " + rym_wizard_fold_page.browser_object_name.
        UNDO tran-block, LEAVE tran-block.
      END.
      ASSIGN
        ttBrowser.dBrowserSmartObject = dSmartObject
        ttBrowser.dBrowserObjectInstance = dBrowserInstance
        .

      /* Add toolbar on Browser page if required */
      IF ttBrowser.lToolbarRequired = YES AND ttBrowser.cSDOName <> "":U THEN
      DO:
        RUN updateObjectInstance (INPUT pcObjectName,
                                  INPUT pdContainer,
                                  INPUT "rydyntoolt.w":U,
                                  INPUT "bottom,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                  INPUT "tool":U,
                                  OUTPUT dSmartObject,
                                  OUTPUT dObjectType,
                                  OUTPUT dBrowserToolbarInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        ASSIGN
          cAttributeLabels = "ToolbarBands,EdgePixels,ToolbarParentMenu,ToolbarAutoSize":U
          cAttributeValues = "browsetableio,browsesearch,browsefunction":U + CHR(3)
                           + "1":U + CHR(3) 
                           + rym_wizard_fold_page.browser_toolbar_parent_menu + CHR(3) 
                           + "no":U.
      
        RUN updateAttributeValues (INPUT dObjectType,
                                   INPUT dSmartObject,
                                   INPUT pdContainer,
                                   INPUT dBrowserToolbarInstance,
                                   INPUT cAttributeLabels,
                                   INPUT cAttributeValues).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      
        ASSIGN iSequence = iSequence + 1.
        RUN updatePageObject(INPUT pdContainer,
                             INPUT dBrowserToolbarInstance,
                             INPUT ttPage.dPageObj,
                             INPUT iSequence).    
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
      ELSE ASSIGN dBrowserToolbarInstance = 0.
      
      /* Add links for browser, from browser sdo and toolbar? */
      FIND FIRST ttSDO 
           WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
           NO-ERROR.
      
      IF AVAILABLE ttSDO THEN
      DO:
        RUN updateLink (INPUT "data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttSDO.dSDOObjectInstance,
                        INPUT dBrowserInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        IF dBrowserToolbarInstance <> 0 THEN
        DO:
          RUN updateLink (INPUT "navigation":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dBrowserToolbarInstance,
                          INPUT ttSDO.dSDOObjectInstance).
          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
          RUN updateLink (INPUT "update":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dBrowserInstance,
                          INPUT ttSDO.dSDOObjectInstance).
          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        END.
      END.

      IF dBrowserToolbarInstance <> 0 THEN
      DO:
        RUN updateLink (INPUT "toolbar":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dBrowserToolbarInstance,
                        INPUT dBrowserInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
    
      /* Add page object records */
      ASSIGN iSequence = iSequence + 1.
      RUN updatePageObject(INPUT pdContainer,
                           INPUT dBrowserInstance,
                           INPUT ttPage.dPageObj,
                           INPUT iSequence).    
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
    END. /* browser on page */

    IF LENGTH(rym_wizard_fold_page.viewer_object_name) > 0 THEN
    DO: /* viewer on page */
      /* add viewer */
      RUN updateObjectInstance (INPUT pcObjectName,
                                INPUT pdContainer,
                                INPUT rym_wizard_fold_page.viewer_object_name,
                                INPUT "centre1,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                INPUT "view":U,
                                OUTPUT dSmartObject,
                                OUTPUT dObjectType,
                                OUTPUT dViewerInstance).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      
      ASSIGN
        cAttributeLabels = "DataSourceNames,UpdateTargetNames":U
        cAttributeValues =  rym_wizard_fold_page.viewer_data_source_names + CHR(3) 
                            + rym_wizard_fold_page.viewer_update_target_names. 

      RUN updateAttributeValues (INPUT dObjectType,
                                 INPUT dSmartObject,
                                 INPUT pdContainer,
                                 INPUT dViewerInstance,
                                 INPUT cAttributeLabels,
                                 INPUT cAttributeValues).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* update viewer temp-table */
      FIND FIRST ttViewer 
           WHERE ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
           NO-ERROR.
      IF NOT AVAILABLE ttViewer THEN
      DO:
        ASSIGN pcErrorText = "Viewer not found in temp table: " + rym_wizard_fold_page.viewer_object_name.
        UNDO tran-block, LEAVE tran-block.
      END.
      ASSIGN
        ttViewer.dViewerSmartObject = dSmartObject
        ttViewer.dViewerObjectInstance = dViewerInstance
        .
      
      /* Add toolbar on viewer page if required; Primary viewer OR an SBO that 
         is not for one-to-one update */
      IF ttViewer.cSDOName <> "":U
      AND (ttViewer.lPrimary 
           /* this check may look exactly as lCommit, but is really independent
              of commit or not  */
           OR (AVAIL ttSDO AND ttSDO.lContainer AND NOT ttSDO.lOneToOne)) THEN
      DO:
        RUN updateObjectInstance (INPUT pcObjectName,
                                  INPUT pdContainer,
                                  INPUT "rydyntoolt.w":U,
                                  INPUT "top,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                  INPUT "tool":U,
                                  OUTPUT dSmartObject,
                                  OUTPUT dObjectType,
                                  OUTPUT dViewerToolbarInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      
        ASSIGN
          cAttributeLabels = "ToolbarBands,ToolbarParentMenu,ToolbarAutoSize":U
                             /* Add commit if required (ONLY for primary viewer) */ 
          cAttributeValues = "adm2Navigation,folder2tableio":U + (IF AVAIL ttSDO AND ttSDO.lCommit AND ttViewer.lPrimary
                                                                  THEN ',adm2Transaction':U
                                                                  ELSE '':U) + CHR(3) 
                              + rym_wizard_fold_page.viewer_toolbar_parent_menu + CHR(3)
                              + "no":U
          .
        RUN updateAttributeValues (INPUT dObjectType,
                                   INPUT dSmartObject,
                                   INPUT pdContainer,
                                   INPUT dViewerToolbarInstance,
                                   INPUT cAttributeLabels,
                                   INPUT cAttributeValues).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      
        ASSIGN iSequence = iSequence + 1.
        RUN updatePageObject(INPUT pdContainer,
                             INPUT dViewerToolbarInstance,
                             INPUT ttPage.dPageObj,
                             INPUT iSequence).    
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
      ELSE ASSIGN dViewerToolbarInstance = 0.

      /* Add viewer page object record */
      ASSIGN iSequence = iSequence + 1.
      RUN updatePageObject(INPUT pdContainer,
                           INPUT ttViewer.dViewerObjectInstance,
                           INPUT ttPage.dPageObj,
                           INPUT iSequence).    
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* Add viewer related links */
      
      /* Find viewer linked SDO if applicable */
      FIND FIRST ttSDO
             WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
             NO-ERROR.
      
      IF dViewerToolbarInstance <> 0 THEN
      DO:
        RUN updateLink (INPUT "TableIO":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dViewerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        
        RUN updateLink (INPUT "Toolbar":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dViewerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        
        IF AVAILABLE ttSDO AND ttSDO.dSDOObjectInstance <> 0 THEN
        DO:
          RUN updateLink (INPUT "Navigation":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dViewerToolbarInstance,
                          INPUT ttSDO.dSDOObjectInstance).
          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
          IF ttSDO.lCommit THEN
          DO:
            RUN updateLink (INPUT "Commit":U,
                            INPUT "":U,
                            INPUT pdContainer,
                            INPUT dViewerToolbarInstance,
                            INPUT ttSDO.dSDOObjectInstance).
           
            IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
          END. /* commit */       
        END.
      END.

      IF AVAILABLE ttSDO AND ttSDO.dSDOObjectInstance <> 0 AND NOT (ttViewer.lLinkToSDO = NO) THEN
      DO:
        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT ttSDO.dSDOObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        RUN updateLink (INPUT "Data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttSDO.dSDOObjectInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
                  
      IF ttViewer.lPrimary = YES AND ttViewer.cSDOName = "":U THEN
      DO:
        RUN updateLink (INPUT "TableIO":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT pdContainerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.        
      END.

      IF brym_wizard_fold.no_sdo = NO AND ttViewer.lPrimary = YES AND ttViewer.cSDOName = "":U THEN
      DO:
        RUN updateLink (INPUT "Data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT 0,
                        INPUT  ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        RUN updateLink (INPUT "ToggleData":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT 0,
                        INPUT  ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT 0).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
    END. /* viewer on page */
    
  END.  /* page-loop */

  RUN updateViewerLinks (INPUT pdContainer,
                         INPUT brym_wizard_fold.viewer_link_name). 

  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateFolderWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateFolderWindow Procedure 
PROCEDURE generateFolderWindow :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a folder window object based on
               information in the Folder Window Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerToolbarInstance           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN
  pcErrorText = "":U
  .

tran-block:
DO FOR brym_wizard_fold TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_fold EXCLUSIVE-LOCK
       WHERE brym_wizard_fold.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_fold THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Folder Window'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "fold":U,
                           INPUT brym_wizard_fold.product_module_code,
                           INPUT brym_wizard_fold.OBJECT_name,
                           INPUT brym_wizard_fold.OBJECT_description,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT brym_wizard_fold.PAGE_layout,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'WindowName,ContainerMode',
                             INPUT brym_wizard_fold.WINDOW_title + CHR(3) + brym_wizard_fold.DEFAULT_mode).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Add Folder */  
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "afspfoldrw.w":U,
                            INPUT "":U,
                            INPUT "fold":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dFolderInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Add top container toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "rydyntoolt.w":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dContainerToolbarInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.


  /* Now add folder page information */
  RUN generateFolderPages (INPUT pcObjectName,
                           INPUT dContainer,
                           INPUT dContainerToolbarInstance,
                           OUTPUT pcErrorText).
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

  /* We need to find the SDO record created to store infor for the Pass-thru object controller
     SDO to see if we need to add the commit band */ 
  FIND FIRST ttSDO WHERE ttSDO.cSDOName = '':U NO-ERROR. 

  ASSIGN
    cAttributeLabels = "ToolbarBands":U
    cAttributeValues = (IF brym_wizard_fold.no_sdo = YES THEN
                           "txtAction,AstraWindow,AstraHelp,AstraAbout,AstraMenuExit,AstraFile":U
                        ELSE
                           "Adm2Navigation,txttableio,Foldertableio,folderfunction,AstraFile,AstraHelp,AstraWindow,AstraAbout,AstraMenuExit":U
                            + IF AVAIL ttSDO AND ttSDO.lCommit 
                              THEN ",":U + "adm2Transaction":U
                              ELSE "":U )
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dContainerToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.


  IF AVAIL ttSDO AND ttSDO.lCommit THEN
  DO:
     RUN updateLink (INPUT "Commit":U,
                     INPUT "":U,
                     INPUT dContainer,
                     INPUT dContainerToolbarInstance,
                     INPUT 0).
     IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.

  /* Set-up standard folder links */
  RUN updateLink (INPUT "page":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dFolderInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  RUN updateLink (INPUT "toolbar":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  RUN updateLink (INPUT "navigation":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.


  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_fold.generated_date = TODAY
    brym_wizard_fold.generated_time = TIME
    .
  VALIDATE brym_wizard_fold NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateMenuController) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateMenuController Procedure 
PROCEDURE generateMenuController :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a menu controller object based on
               information in the Menu Controller Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_menc FOR rym_wizard_menc.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dToolbarInstance                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dStatusbarInstance                  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_menc TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_menc EXCLUSIVE-LOCK
       WHERE brym_wizard_menc.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_menc THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Menu Controller'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "menc":U,
                           INPUT brym_wizard_menc.product_module_code,
                           INPUT brym_wizard_menc.OBJECT_name,
                           INPUT brym_wizard_menc.OBJECT_description,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT "Top/Center/Bottom":U,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'WindowName',
                             INPUT brym_wizard_menc.WINDOW_title).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Now add object instances to container - a menu controller has a toolbar
     at the top and a statusbar viewer at the bottom
  */
  
  /* Add toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "rydyntoolt.w":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dToolbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  ASSIGN
    cAttributeLabels = "ToolbarBands":U
    cAttributeValues = "AstraFile,AstraWindows,DynamicMenu,MenuFunction,AstraSystem,AstraWindow,AstraView,AstraHelp,AstraAbout,AstraIconExit":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Add status bar viewer */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "rystatusbv.w":U,
                            INPUT "bottom":U,
                            INPUT "view":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dStatusbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Add links */
  RUN updateLink (INPUT "toolbar":U,          /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dToolbarInstance,     /* from instance, 0 = container */
                  INPUT 0).                   /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.
                                              
  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_menc.generated_date = TODAY
    brym_wizard_menc.generated_time = TIME
    .
  VALIDATE brym_wizard_menc NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLayoutLinks Procedure 
PROCEDURE getLayoutLinks :
/*------------------------------------------------------------------------------
  Purpose:     pass back a temp-table representing all the links in this 
               page layout. The temp-table will consist of a linkname and the
               positions of the source and target instance objects. Positions
               are unique so this is sufficient.
  
  Parameters:  input -- the object_filename of the page layout object
               output -- temp-table of links for this layout object
  Notes:       position is unique. this routine is used in conjunction with
               getlayoutobjects to get more information about the instances.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcLayoutName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttlbLink.

    DEFINE VARIABLE dlayout        AS DECIMAL NO-UNDO.
    DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
    DEFINE BUFFER bryc_smartlink   FOR ryc_smartlink.
    DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
    

    EMPTY TEMP-TABLE ttlbLink.

    /* First locate the smartobject record for the page layout container. */
    FIND bryc_smartobject WHERE OBJECT_filename = pcLayoutName NO-ERROR.
    IF NOT AVAILABLE bryc_smartobject THEN
    DO:
      RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
          "'Object Filename'" pcLayoutName}.   
    END.
    ELSE ASSIGN dLayout = bryc_smartobject.smartobject_obj.

    /* for each link of the container */
    FOR EACH bryc_smartlink WHERE bryc_smartlink.container_smartobject_obj =
        bryc_smartobject.smartobject_obj:
        CREATE ttlblink.
        ASSIGN ttlblink.linkname = bryc_smartlink.link_name.

        /* find source object name */
        IF bryc_smartlink.SOURCE_object_instance_obj NE 0 THEN DO:
        
          FIND FIRST bryc_object_instance
            WHERE bryc_object_instance.container_smartobject_obj = dlayout
            AND   bryc_object_instance.OBJECT_instance_obj =
                  bryc_smartlink.SOURCE_object_instance_obj.
        
          ASSIGN ttlblink.linksource = bryc_object_instance.layout_position.
        END.
        ELSE ASSIGN ttlblink.linksource = "<container>":U.

        /* find target object name */
        IF bryc_smartlink.target_object_instance_obj NE 0 THEN DO:
        
          FIND FIRST bryc_object_instance
            WHERE bryc_object_instance.container_smartobject_obj = dlayout
            AND   bryc_object_instance.OBJECT_instance_obj =
                  bryc_smartlink.target_object_instance_obj.
        
          ASSIGN ttlblink.linktarget = bryc_object_instance.layout_position.
        END.
        ELSE ASSIGN ttlblink.linktarget = "<container>":U.

    END. /* end for each bryc_smartlink*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLayoutObjects Procedure 
PROCEDURE getLayoutObjects :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a Layout name and returns a temp-table with the
               types, layout positions, and current attribute values of
               all of the template objects in the layout.
  Parameters:  INPUT pcLayoutName
               OUTPUT ttLayoutObject
  Notes:       This procedure is used to furnish the User Interface with the
               information it needs to prompt for actual SmartObjects to use
               in place of the template placeholder objects, and to display
               and permit modifications to the property values of each object.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcLayoutName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttlbObject.

    DEFINE BUFFER tmpl_smo         FOR ryc_smartobject.
    DEFINE BUFFER tmpl_instance    FOR ryc_object_instance.
    DEFINE BUFFER tmpl_object_type FOR gsc_object_type.
    DEFINE BUFFER tmpl_attr_value  FOR ryc_attribute_value.
    DEFINE BUFFER tmpl_link        FOR ryc_smartlink.
    DEFINE BUFFER tmpl_product_mod FOR gsc_product_module.
    DEFINE BUFFER tmpl_gsc_object  FOR gsc_object.

    DEFINE VARIABLE dLayout     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cAttrLabels AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAttrValues AS CHARACTER  NO-UNDO.

    EMPTY TEMP-TABLE ttlbobject.
    /* First locate the smartobject record for the layout. */
    FIND tmpl_smo WHERE OBJECT_filename = pcLayoutName NO-ERROR.
    IF NOT AVAILABLE tmpl_smo THEN
    DO:
      RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
          "'Object Filename'" pcLayoutName}.   
    END.
    ELSE ASSIGN dLayout = tmpl_smo.smartobject_obj.

    /* Next loop through all of its Instance objects to find those that
       are template objects. */
    FOR EACH tmpl_instance 
        WHERE tmpl_instance.container_smartobject_obj =
              tmpl_smo.smartobject_obj:
        FIND tmpl_smo WHERE tmpl_smo.smartobject_obj = 
             tmpl_instance.smartobject_obj.
        /* Populate the Temp-Table with types, positions, and
           other info of template objects. */
        FIND tmpl_object_type WHERE tmpl_object_type.OBJECT_type_obj =
            tmpl_smo.object_type_obj.   /* To get the Object Type Name */
        FIND tmpl_product_mod WHERE tmpl_product_mod.product_module_obj =
            tmpl_smo.product_module_obj.
        FIND tmpl_gsc_object WHERE tmpl_gsc_object.object_obj =
            tmpl_smo.object_obj.
        

        /* Now create a temp-table record to describe this object, to
           be passed back to the caller. */
        CREATE ttlbobject.
       
        ASSIGN 
               ttlbobject.Position              = tmpl_instance.layout_position
               ttlbobject.ObjectType            = tmpl_object_type.OBJECT_type_code
               ttlbobject.TemplateObj           = tmpl_smo.template_smartobject
               ttlbobject.ObjectName            = tmpl_smo.OBJECT_filename
               ttlbobject.InstanceObjId         = tmpl_instance.smartobject_obj
               ttlbobject.ObjectDescription     = tmpl_gsc_object.OBJECT_description
               ttlbobject.ProductModule         = tmpl_product_mod.product_module_code
               ttlbObject.tObjectInstanceObj    = tmpl_instance.object_instance_obj
               .
    END.       /* END FOR EACH tmpl_instance */
    
    RETURN.    /* Send the LayoutObject table back to the caller. */
                                                                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectInfo Procedure 
PROCEDURE getObjectInfo :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Object ID of a SmartObject given the name as INPUT.
            Also returns object type, whether a template or not and product
            module code.
  Returns:  SmartObject obj id (decimal)
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcSmartObjectName AS CHARACTER.
    DEFINE OUTPUT PARAMETER pdSmobj           AS DECIMAL.
    DEFINE OUTPUT PARAMETER pcObjectType      AS CHARACTER.
    DEFINE OUTPUT PARAMETER plIsTemplate      AS LOGICAL.
    DEFINE OUTPUT PARAMETER pcDescription     AS CHARACTER.
    DEFINE OUTPUT PARAMETER pcModCode         AS CHARACTER.
    DEFINE OUTPUT PARAMETER pcRelative        AS CHARACTER.
  /* initialize*/
  ASSIGN
      pcObjectType = ?
      plIsTemplate = ?
      pcModCode = ?
      pcRelative = ?
      pcDescription = ?
      pdsmobj = ?
      .
  FIND ryc_smartobject WHERE ryc_smartobject.object_filename = 
      pcSmartObjectName NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_smartobject THEN DO:
      ASSIGN pdsmobj = ryc_smartobject.smartobject_obj.

      /* get the product module code */
      FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_obj
          = ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_product_module 
          THEN ASSIGN pcModCode = gsc_product_module.product_module_code
                      pcRelative = gsc_product_module.relative_path.
     
      /* get the object type and whether or not it is a template object */
      FIND FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = 
          ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object_type THEN
            ASSIGN  pcObjectType = gsc_object_type.object_type_code
                    plIsTemplate = ryc_smartobject.template_smartobject
                    .
      /* get description info */
      FIND FIRST gsc_object WHERE gsc_object.object_obj = 
          ryc_smartObject.object_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object THEN 
          ASSIGN pcDescription = gsc_object.object_description.
     
      
  END. /* if avail ryc_sm */
  



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectNames Procedure 
PROCEDURE getObjectNames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPartialName           AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER piNumObjects            AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttObject.

DEFINE VARIABLE cObjectNames AS CHARACTER  NO-UNDO.

ASSIGN piNumObjects = 0.
EMPTY TEMP-TABLE ttObject.

  /*before building list of objects that begin with pcPartialName 
    make sure there isn't an exact match -- if there is then just return
    with that one object */
  FIND FIRST ryc_smartobject WHERE ryc_smartObject.OBJECT_filename = pcPartialName NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_smartobject THEN DO:
    FIND gsc_object WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj NO-ERROR.
      IF AVAILABLE gsc_object THEN DO:
      
        CREATE ttObject.
        ASSIGN ttObject.ObjectName        = ryc_smartobject.OBJECT_filename
               ttObject.ObjectDescription = gsc_object.OBJECT_description
               piNumObjects = piNumObjects + 1.
      END. 
    RETURN.
  END.

  /* if no exact matches, then return list of those that begin */
  FOR EACH ryc_smartobject WHERE 
      ryc_smartobject.OBJECT_filename BEGINS pcPartialName:
      
     
      FIND gsc_object WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj NO-ERROR.
      IF AVAILABLE gsc_object THEN DO:
      
        CREATE ttObject.
        ASSIGN ttObject.ObjectName        = ryc_smartobject.OBJECT_filename
               ttObject.ObjectDescription = gsc_object.OBJECT_description
               piNumObjects = piNumObjects + 1.
      END. 
  END.
  
  RETURN.
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

ASSIGN cDescription = "Wizard forward engineer".

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

&IF DEFINED(EXCLUDE-storeAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeAttribute Procedure 
PROCEDURE storeAttribute :
/*------------------------------------------------------------------------------
  Purpose:    Creates a new attribute record in the repository
              or updates an existing one.
              Can also be used to create new attribute groups and types. 
  Parameters:  INPUT pcAttributeName AS CHARACTER -- the name of the
                   attribute, group, or type to be created or updated.
               INPUT pcAttributeType AS CHARACTER -- Type_TLA for an attribute
               INPUT pcDescription   AS CHARACTER -- attribute_narrative or
                   attribute_type_description or attribute_group_narrative.
               INPUT pcFieldNames    AS CHARACTER -- additional stuff to set,
                 as a comma-separated list; can include:
                   AttributeGroup ("defaults" by default),
                   EditProgram (for new types),
                   SystemOwned
               INPUT pcFieldValues   AS CHARACTER -- CHR(3) list of corresponding
                   values for stuff to set
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcAttributeName         AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcAttributeType         AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcDescription           AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldNames            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcFieldValues           AS CHARACTER        NO-UNDO.
    
    DEFINE BUFFER bryc_attribute       FOR ryc_attribute.
    DEFINE BUFFER bryc_attribute_type  FOR ryc_attribute_type.
    DEFINE BUFFER bryc_attribute_group FOR ryc_attribute_group.
    
    DEFINE VARIABLE iIndex               AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cFieldName           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldValue          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cGroupName           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSystemOwned         AS LOGICAL    NO-UNDO INIT ?.
    DEFINE VARIABLE cEditProgram         AS CHARACTER  NO-UNDO.
    
    DO iIndex = 1 TO NUM-ENTRIES(pcFieldNames):
        ASSIGN cFieldName  = ENTRY(iIndex, pcFieldNames)
               cFieldValue = ENTRY(iIndex, pcFieldValues).
        CASE cFieldName:
            WHEN "GroupName":U THEN
                cGroupName = cFieldValue.
            WHEN "SystemOwned":U THEN
                lSystemOwned = IF cFieldValue = "Yes":U OR cFieldValue = "True":U
                THEN TRUE ELSE FALSE.
            WHEN "EditProgram":U THEN
                cEditProgram = cFieldValue.
        END CASE.
    END.  /* END DO iIndex on pcFieldNames */
    
    IF (pcAttributeName = "":U OR pcAttributeName = ?) AND 
       (pcAttributeType = "":U OR pcAttributeType = ?) THEN
    DO:
        /* Create a new group in the special case that the Name and Type 
           are not passed in. */
        group-block:
        DO FOR bryc_attribute_group TRANSACTION 
            ON ERROR UNDO group-block, LEAVE group-block:
        
            FIND bryc_attribute_group WHERE 
                bryc_attribute_group.attribute_group_name =
                  cGroupName EXCLUSIVE-LOCK NO-ERROR.    /* Does it already exist? */
            
            IF NOT AVAILABLE bryc_attribute_group THEN
            DO:
              CREATE bryc_attribute_group NO-ERROR.
              {af/sup2/afcheckerr.i &no-return = YES}
              IF cMessageList <> "":U THEN UNDO group-block, LEAVE group-block.
              ASSIGN
                bryc_attribute_group.attribute_group_name = cGroupName.
            END.   /* Create if not already there. */
        
            IF pcDescription NE "":U AND pcDescription NE ? THEN
                bryc_attribute_group.attribute_group_narrative = pcDescription.
            
            VALIDATE bryc_attribute_group NO-ERROR.  
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN UNDO group-block, LEAVE group-block.
          
        END. /* group-block */
    END.     /* END DO IF creating a new group */
    
    ELSE IF (pcAttributeName = "":U OR pcAttributeName = ?) THEN
    DO:
        /* Create a new type in the special case that the Name is not passed in. */
        type-block:
        DO FOR bryc_attribute_type TRANSACTION 
            ON ERROR UNDO type-block, LEAVE type-block:
        
            FIND bryc_attribute_type WHERE bryc_attribute_type.attribute_type_tla =
                pcAttributeType EXCLUSIVE-LOCK NO-ERROR.  /* Does it already exist? */
            
            IF NOT AVAILABLE bryc_attribute_type THEN
            DO:
              CREATE bryc_attribute_type NO-ERROR.
              {af/sup2/afcheckerr.i &no-return = YES}
              IF cMessageList <> "":U THEN UNDO type-block, LEAVE type-block.
              ASSIGN
                bryc_attribute_type.attribute_type_tla = pcAttributeType.
            END.   /* Create if not already there. */
        
            IF pcDescription NE "":U AND pcDescription NE ? THEN
                bryc_attribute_type.attribute_type_description = pcDescription.
            IF cEditProgram NE "":U THEN
                bryc_attribute_type.edit_program = cEditProgram.
            
            VALIDATE bryc_attribute_type NO-ERROR.  
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN UNDO type-block, LEAVE type-block.
          
        END. /* type-block */
    END.     /* END DO IF creating a new type */
    
    ELSE DO:
        /* Create a new attribute if the name is passed in. */
        attr-block:
        DO FOR bryc_attribute TRANSACTION 
            ON ERROR UNDO attr-block, LEAVE attr-block:
        
            FIND bryc_attribute WHERE bryc_attribute.attribute_label =
                pcAttributeName EXCLUSIVE-LOCK NO-ERROR.  /* Does it already exist? */
            
            IF NOT AVAILABLE bryc_attribute THEN
            DO:
              CREATE bryc_attribute NO-ERROR.
              {af/sup2/afcheckerr.i &no-return = YES}
              IF cMessageList <> "":U THEN UNDO attr-block, LEAVE attr-block.
              ASSIGN
                bryc_attribute.attribute_label     = pcAttributeName
                bryc_attribute.attribute_type_tla  = pcAttributeType 
                bryc_attribute.system_owned        = NO.  /* default */
              IF pcAttributeType NE "":U AND pcAttributeType NE ? THEN
                   bryc_attribute.attribute_type_tla  = pcAttributeType.
              IF cGroupName NE "":U THEN
              DO:
                FIND ryc_attribute_group WHERE 
                    ryc_attribute_group.attribute_group_name = cGroupName
                       NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ryc_attribute_group THEN
                    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
                      "'Attribute Group Name'" cGroupName}.
              END.  /* Check Group Name if specified. */
              ELSE FIND ryc_attribute_group WHERE  /* default is "Defaults" */
                    ryc_attribute_group.attribute_group_name = "Defaults":U NO-LOCK.
                bryc_attribute.attribute_group_obj = 
                    ryc_attribute_group.attribute_group_obj.
            END.   /* Create if not already there. */
        
            /* Update other fields if their values have been specified. */
            IF lSystemOwned NE ? THEN
                 bryc_attribute.system_owned        = lSystemOwned.
            IF pcDescription NE "":U AND pcDescription NE ? THEN
                 bryc_attribute.attribute_narrative = pcDescription.
            
            VALIDATE bryc_attribute NO-ERROR.  
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN UNDO attr-block, LEAVE attr-block.
          
        END. /* attr-block */
    END.     /* END DO IF creating a new attribute */
    
    RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeAttributeValues Procedure 
PROCEDURE storeAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to update attribute values for an object type, a
               smartobject, or an object instance.
  Parameters:  input object type object number (optional if smartobject is there)
               input smartobject object number (optional)
               input container smartobject object number (optional)
               input object instance object number (optional)
               input comma delimited list of attribute labels
               input CHR(3) delimited list of corresponding attribute values
  Notes:       If only an object type is passed in, then the attribute values
               will be set for the object type.
               If an object type and smartobject are passed in but no container
               and object instance, then the smartobject attribute values will be
               updated.
               If a container object instance is passed in then the object instance
               attribute values will be updated.
               The attribute value record should first be created if it does not
               yet exist.
               This procedure does not deal with attribute collections and simply
               sets the collect_attribute_value_obj equal to the attribute_value_obj
               when creating a new attribute, and the sequence to 0.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdObjectType                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdSmartObject                 AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer                   AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdInstance                    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeLabels             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeValues             AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE iLoop                                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAttributeLabel                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValue                       AS CHARACTER  NO-UNDO.
ASSIGN cMessageList = "":U.

IF pdObjectType = 0 THEN
DO:
    FIND ryc_smartobject WHERE 
        ryc_smartobject.smartobject_obj = pdSmartObject NO-LOCK NO-ERROR.
    IF NOT AVAILABLE (ryc_smartobject) THEN
        RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
            "'SmartObject ID'" pdSmartObject}.
    ELSE pdObjectType = ryc_smartobject.object_type_obj.
END.  /* END DO IF pdObjectType = 0 */

/* In case run from rycsomainw.w */
ON FIND OF ryc_attribute OVERRIDE DO: END.

trn-block:
DO FOR bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  DO iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels):
    ASSIGN
      cAttributeLabel = ENTRY(iLoop, pcAttributeLabels)
      cAttributeValue = ENTRY(iLoop, pcAttributeValues, CHR(3))
      .

    FIND FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = cAttributeLabel
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
    DO:
      ASSIGN cMessageList = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Attribute Label'" cAttributeLabel}.
      UNDO trn-block, LEAVE trn-block.      
    END.

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.OBJECT_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.attribute_label = cAttributeLabel
         NO-ERROR.
    
    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      
      ASSIGN
        bryc_attribute_value.OBJECT_type_obj = pdObjectType
        bryc_attribute_value.smartobject_obj = pdSmartObject
        bryc_attribute_value.container_smartobject_obj = pdContainer
        bryc_attribute_value.object_instance_obj = pdInstance
        bryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        bryc_attribute_value.attribute_group_obj = ryc_attribute.attribute_group_obj
        bryc_attribute_value.attribute_type_tla = ryc_attribute.attribute_type_tla
        bryc_attribute_value.constant_value = NO
        .        
      IF bryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.container_smartobject_obj.
      ELSE
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.smartobject_obj.
    END.

    ASSIGN
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.attribute_value = cAttributeValue
      bryc_attribute_value.inheritted_value = NO
      NO-ERROR.
    
    VALIDATE bryc_attribute_value NO-ERROR.  
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      
  END. /* iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels): */

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeBrowser Procedure 
PROCEDURE storeBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to generate a dynamic browser object based on
               information passed in.
  Parameters:  input object name
               input pcFieldNames -- list of browser pcFieldNames
               input pcFieldValues -- list of browser field values
               output structured error message text (if failed)
  Notes:       This new version of what was generateBrowser does not
               use the wizard_brow table.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcFieldNames                AS CHAR       NO-UNDO.
DEFINE INPUT PARAMETER  pcFieldValues               AS CHAR       NO-UNDO.          
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dBrowser                            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cProdModuleCode                     AS CHAR       NO-UNDO.
DEFINE VARIABLE cObjectName                         AS CHAR       NO-UNDO.
DEFINE VARIABLE cObjectDesc                         AS CHAR       NO-UNDO.
DEFINE VARIABLE cCustomSuperProc                    AS CHAR       NO-UNDO.
DEFINE VARIABLE cLaunchContainer                    AS CHAR       NO-UNDO.
DEFINE VARIABLE cSelectedFields                     AS CHAR       NO-UNDO.
DEFINE VARIABLE cSDOName                            AS CHAR       NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIndex                              AS INTEGER    NO-UNDO.          
ASSIGN pcErrorText = "":U.

tran-block:
DO TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

    RUN deleteObject (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
    
        /*iIndex is used to make sure the lookup doesn't fail and 
          return a zero which causes a run time error onthe entry function */

       iIndex = LOOKUP("productmodulecode",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cProdModuleCode =  ENTRY(iIndex, pcFieldValues,CHR(2)).

       iIndex = LOOKUP("ObjectName",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cObjectName = ENTRY(iIndex, pcFieldValues,CHR(2)).

       iIndex = LOOKUP("ObjectDescription",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cObjectDesc =  ENTRY(iIndex, pcFieldValues,CHR(2)).

       iIndex = LOOKUP("CustomSuperProcedure",pcFieldNames, CHR(2)).
       IF iIndex > 0 THEN
       cCustomSuperProc =  ENTRY(iIndex, pcFieldValues,CHR(2)).

       iIndex =  LOOKUP("LaunchContainer",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cLaunchContainer =  ENTRY(iIndex, pcFieldValues,CHR(2)).

       iIndex = LOOKUP("SelectedFields",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cSelectedFields =   ENTRY(iIndex, pcFieldValues,CHR(2)).
       
       iIndex = LOOKUP("SDOName",pcFieldNames,CHR(2)).
       IF iIndex > 0 THEN
       cSDOName =   ENTRY(iIndex, pcFieldValues,CHR(2)).


    /* create / update gsc_object and ryc_smartobject records */
    RUN storeObject (INPUT "dynbrow",
                     INPUT cProdModuleCode,
                    INPUT cObjectName,
                    INPUT cObjectDesc,
                    INPUT "CustomSuperProcedure,SDONAME":U,
                    INPUT cCustomSuperProc + CHR(3) + cSDONAME,
                    OUTPUT dBrowser).
  
    IF RETURN-VALUE <> "":U THEN DO:
        ASSIGN pcErrorText = RETURN-VALUE.
        UNDO tran-block, LEAVE tran-block. 
    END.

  /* Assign browser attribute values */
  ASSIGN
    cAttributeLabels = "FolderWindowToLaunch":U
    cAttributeValues = cLaunchContainer 
    cEnabledFields = ""
    cDisplayedFields = ""
    .

  DO iLoop = 1 TO NUM-ENTRIES(cSelectedFields, CHR(3)):
      /* Fields which are Obejct ID fields must not be displayed in the browse. */


    ASSIGN
      cEntry = ENTRY(iLoop, cSelectedFields, CHR(3)).
    
    IF NUM-ENTRIES(cEntry, CHR(4)) = 3 THEN
    DO:
        
      ASSIGN
        cDisplayedFields = cDisplayedFields + 
                           (IF cDisplayedFields <> "":U THEN ",":U ELSE "":U) +
                           ENTRY(2, cEntry, CHR(4)).

      IF ENTRY(3, cEntry, CHR(4)) = "YES":U THEN
      DO:
        ASSIGN
          cEnabledFields = cEnabledFields + 
                           (IF cEnabledFields <> "":U THEN ",":U ELSE "":U) +
                         ENTRY(2, cEntry, CHR(4)).
        
      END.
    END.
  END.

  ASSIGN
    cAttributeLabels = cAttributeLabels + ",DisplayedFields,EnabledFields":U
    cAttributeValues = cAttributeValues + CHR(3) + cDisplayedFields +
                                          CHR(3) + cEnabledFields
    .
  
  /* Update attribute values */
  RUN storeAttributeValues (INPUT 0,
                           INPUT dBrowser,
                           INPUT 0,
                           INPUT 0,
                           INPUT cAttributeLabels,
                           INPUT cAttributeValues).
  
  IF RETURN-VALUE <> "":U THEN DO:
      ASSIGN pcErrorText = RETURN-VALUE.
      UNDO tran-block, LEAVE tran-block. 
  END.

END. /* tran-block */

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeContainer Procedure 
PROCEDURE storeContainer :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a temp-table with object names and attributes and
               creates all of the instance records for the container, along
               with attribute value records.
  Parameters:  INPUT pcLayoutName -- the name of the Layout the Container 
                  is based on
               INPUT dContainer -- the Object ID of the new Container
                  SmartObject record that has just been created from the layout
               INPUT TABLE ttLayoutObject -- this holds Instance names and attrs
  Notes:       The Object and SmartObject records for the new Container have
                   already been created when this procedure is called; that's
                   where the dContainer comes from. The names of specific
                   objects to be used in place of template objects has been
                   filled in, and the attribute arguments hold any changes to
                   the default attribute values.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcLayoutName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdContainer  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttLayoutObject.

 DEFINE BUFFER tmpl_smo FOR ryc_smartobject.
 DEFINE BUFFER tmpl_instance FOR ryc_object_instance.
 DEFINE BUFFER tmpl_object_type FOR gsc_object_type.
 DEFINE BUFFER tmpl_attr_value FOR ryc_attribute_value.
 DEFINE BUFFER inst_smo FOR ryc_smartobject.
 DEFINE BUFFER tmpl_link FOR ryc_smartlink.
 DEFINE BUFFER inst_link FOR ryc_smartlink.

 DEFINE VARIABLE dLayout      AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cAttrLabels  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAttrValues  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dSmartObject AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dInstance    AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cErrorText   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dLinkSource  AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dLinkTarget  AS DECIMAL    NO-UNDO.

 /* First locate the smartobject record for the layout. */
 FIND tmpl_smo WHERE OBJECT_filename = pcLayoutName NO-ERROR.
 IF NOT AVAILABLE tmpl_smo THEN
 DO:
   RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 
       "'Object Filename'" pcLayoutName}.   
 END.
 ELSE ASSIGN dLayout = tmpl_smo.smartobject_obj.

 tran-block:
 DO TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:
     /* Next loop through the temp-table to get instances to create. */
     FOR EACH ttLayoutObject:
         /* Locate the template instance for that layout position. */
         FIND tmpl_instance 
         WHERE tmpl_instance.container_smartobject_obj =
                 tmpl_smo.smartobject_obj AND 
               tmpl_instance.layout_position =
                 ttLayoutObject.LayoutPosition.
         IF ttLayoutObject.LayoutInstance = "":U THEN
         DO:
             /* If the instance hasn't been set by the caller, it's
                because this isn't a template object, so just retrieve
                the object name from the template's smartobject. */
             FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj =
                 tmpl_instance.smartobject_obj.
             ttLayoutObject.LayoutInstance = ryc_smartobject.OBJECT_filename.
         END.

         RUN storeObjectInstance 
             (INPUT pdContainer,                    /* new Container ID */
              INPUT ttLayoutObject.LayoutInstance,  /* SmartObject name to use */
              INPUT ttLayoutObject.LayoutPosition,
              OUTPUT dSmartObject,                  /* SmartObject ID */
              OUTPUT dInstance).                    /* newly created Instance ID */
         
         IF RETURN-VALUE NE "":U THEN
         DO:
             ASSIGN cErrorText = RETURN-VALUE.
             UNDO tran-block, LEAVE tran-block.
         END.

         /* Log an entry in a temp-table that maps the template instance
            to the new instance created, so we can map links later on. */
         CREATE ttInstance.
         ASSIGN ttInstance.TemplateInstanceID = 
                    tmpl_instance.OBJECT_instance_obj
                ttInstance.NewInstanceID = dInstance.

         /* NB: We want to make sure we don't needlessly re-update all the
            default values; the calle rshould check that only labels and values
            are passed in that reflect values that have actually been changed. */
         
         IF ttLayoutObject.LayoutAttributeLabels NE "":U THEN
           RUN storeAttributeValues
             (INPUT 0,
              INPUT dSmartObject,
              INPUT pdContainer,
              INPUT dInstance,
              INPUT ttLayoutObject.LayoutAttributeLabels,
              INPUT ttLayoutObject.LayoutAttributeValues).

     END.       /* END FOR EACH ttLayoutObject */

     /* Translate the template records into new link records, mapping
        template instance ID to the instance ID for this container. */
     FOR EACH tmpl_link WHERE
        tmpl_link.container_smartobject_obj = dLayout:
        /* First map the template source and target object IDs to the actual IDs
            in the instance table. */
        IF tmpl_link.source_object_instance_obj <> 0 THEN
        DO:
            FIND ttInstance WHERE
                ttInstance.TemplateInstanceID = 
                  tmpl_link.source_object_instance_obj.
            dLinkSource = ttInstance.NewInstanceID.
        END.
        ELSE dLinkSource = 0.

        IF tmpl_link.target_object_instance_obj <> 0 then
        DO:
            FIND ttInstance WHERE
                ttInstance.TemplateInstanceID = tmpl_link.target_object_instance_obj.
            dLinkTarget = ttInstance.NewInstanceID.
        END.
        ELSE dLinkTarget = 0.

        /* CREATE a new smartlink record using the ttInstance table
           and the container object_instance ID to map the template
           source and target Object IDs to those for the new record. */
        CREATE inst_link.  /* ryc_smartlink */
        ASSIGN inst_link.container_smartobject_obj = pdContainer
               inst_link.smartlink_type_obj = tmpl_link.smartlink_type_obj
               inst_link.link_name = tmpl_link.link_name
               inst_link.source_object_instance_obj = dLinkSource
               inst_link.target_object_instance_obj = dLinkTarget.

    END.  /* END FOR EACH smartlink */
 END.   /* END TRANSACTION block */

 RETURN cErrorText.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeLink Procedure 
PROCEDURE storeLink :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to add/update a smartlink between 2 objects
  Parameters:  input link name
               input container object number
               input source instance object number or 0 for container
               input target instance object number or 0 for container
  Notes:       For non user defined links the link name must exist in the 
               smartlink type table. For user defined links, we look in the
               smartlink type table for a link name equal to the user defined
               link name specified, and the actual link name is not validated.
               If the source or target are passed in as 0, then it is a link
               to or from the container. 
               This procedure can also be used to create a new link type. 
               In this case the Container ID is passed as 0.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcLinkName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdSource                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdTarget                  AS DECIMAL    NO-UNDO.

DEFINE BUFFER bryc_smartlink FOR ryc_smartlink.
DEFINE BUFFER bryc_smartlink_type FOR ryc_smartlink_type.

ASSIGN cMessageList = "":U.

/* Check to see if the caller wants to define a new link type. */
IF pdContainer = 0 THEN
DO:
    /* create new smartlink type*/
    type-block:
    DO FOR bryc_smartlink_type TRANSACTION ON ERROR 
        UNDO type-block, LEAVE type-block:
      CREATE bryc_smartlink_type NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO type-block, LEAVE type-block.
      ASSIGN
        bryc_smartlink_type.link_name = pcLinkName
        /* NB: is this really used? There's even a type in the name... */
        bryc_smartlink_type.used_defined_link = NO /* "used" [sic] = user */
        bryc_smartlink_type.system_owned = NO.
        .    
      VALIDATE bryc_smartlink_type NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO type-block, LEAVE type-block.
    
    END. /* type-block */
    IF cMessageList <> "":U THEN RETURN cMessageList.
    ELSE RETURN.
END. /* END DO IF New Link Type -- Source and Target = 0 */

/* Here's the standard code to create a new link:
   validate link name specified */
FIND FIRST ryc_smartlink_type NO-LOCK
       WHERE ryc_smartlink_type.link_name = pcLinkName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartlink_type THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Link Name'" pcLinkName}.      
  END.


/* link specified is valid, see if link already exists. */
FIND FIRST ryc_smartlink NO-LOCK
     WHERE ryc_smartlink.container_smartobject_obj = pdContainer
       AND ryc_smartlink.link_name = ryc_smartlink_type.link_name
       AND ryc_smartlink.source_object_instance_obj = pdSource
       AND ryc_smartlink.target_object_instance_obj = pdTarget
     NO-ERROR.
IF AVAILABLE ryc_smartlink THEN RETURN.

/* create new smartlink */
trn-block:
DO FOR bryc_smartlink TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
  CREATE bryc_smartlink NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  ASSIGN
    bryc_smartlink.container_smartobject_obj = pdContainer
    bryc_smartlink.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj
    bryc_smartlink.link_name = ryc_smartlink_type.link_name
    bryc_smartlink.source_object_instance_obj = pdSource
    bryc_smartlink.target_object_instance_obj = pdTarget
    .    
  VALIDATE bryc_smartlink NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeObject Procedure 
PROCEDURE storeObject :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update ASDB gsc_object and RYDB
               ryc_smartobject records for dynamic or static object passed in.
  Parameters:  input object type (menc, objc, fold, view, brow)
               input product module code
               input object name
               input object description
               INPUT attrnames -- comma-separated list
               INPUT attr values -- CHR(3)-delimited list to allow for the 
                  chance that a value may contain a comma or other special value
               output object number of smartobject created / updated
               output object type object number
  Notes:       Attribute values are cascaded down onto new smartobjects from the
               object type by the replication write trigger of the smartobject
               coded in rycsoreplw.i
               Despite this we copy them down again and update them, in case
               used delete object first option.
               Errors are passed back in return value.
               Based on updateDynamicObject and updateStaticObject
                  of rywizogenp.p.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectType        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProductModuleCode AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectDescription AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcAttrNames         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcAttrValues        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject       AS DECIMAL    NO-UNDO.

DEFINE BUFFER gsc_object            FOR gsc_object.
DEFINE BUFFER gsc_object_type       FOR gsc_object_type.
DEFINE BUFFER bgsc_object           FOR gsc_object.
DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.
DEFINE BUFFER ryc_attribute_group   FOR ryc_attribute_group.
DEFINE BUFFER ryc_attribute_value   FOR ryc_attribute_value.
DEFINE BUFFER gsc_product_module    FOR gsc_product_module.
DEFINE BUFFER ryc_layout            FOR ryc_layout.
DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.

DEFINE VARIABLE lContainer      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lHasExtension   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPhysicalObject AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dPhysicalObject AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dObjectType     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProductModule  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLayout         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dLayout         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDO            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cSDOName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSuper          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lTemplate       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iIndex          AS INTEGER    NO-UNDO.
DEFINE VARIABLE lStaticObject   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRequiredDBList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRunPersistent  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTooltipText    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSmartObject    AS LOGICAL    NO-UNDO INIT YES.
DEFINE VARIABLE cAttrName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttrValue      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectExt      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectFilename AS CHARACTER  NO-UNDO.


cTooltipText = pcObjectDescription.    /* default to Object Desc */

DO iIndex = 1 TO NUM-ENTRIES(pcAttrNames):
    ASSIGN cAttrName  = ENTRY(iIndex, pcAttrNames)
           cAttrValue = ENTRY(iIndex, pcAttrValues, CHR(3)).
    CASE cAttrName:
        WHEN "SDOName":U THEN
            cSDOName = cAttrValue.
        WHEN "Template":U THEN
            lTemplate = IF cAttrValue = "YES":U OR cAttrValue = "TRUE":U THEN
                TRUE ELSE FALSE. 
        WHEN "CustomSuperProcedure":U THEN
            cSuper = cAttrValue.
        WHEN "StaticObject":U THEN
            lStaticObject = IF cAttrValue = "YES":U OR cAttrValue = "TRUE":U THEN
                TRUE ELSE FALSE.
        WHEN "ObjectPath":U THEN
            cObjectPath = cAttrValue.
        WHEN "RequiredDBList":U THEN
            cRequiredDBList = cAttrValue.
        WHEN "TooltipText":U THEN
            cTooltipText = cAttrValue.
        WHEN "RunPersistent":U THEN
            lRunPersistent = IF cAttrValue = "YES":U OR cAttrValue = "TRUE":U THEN
                TRUE ELSE FALSE.
        WHEN "SmartObject":U THEN   /* Allow creation of ryc_smartobject to be */
            lSmartObject = IF cAttrValue = "YES":U OR cAttrValue = "TRUE":U THEN
                TRUE ELSE FALSE.      /* skipped for non-SmartObjects */
    END CASE.
END.   /* END DO iIndex */

ASSIGN cMessageList = "":U.

/* NB: There probably shouldn't be any differences between these; they're all
   dynwind, but for starters I'm recognizing dynobjc and dynfold for testing*/

/* Always assume that there is an extension, unless otherwise specified. */
ASSIGN lHasExtension = YES.

IF LOOKUP(pcObjectType,"DynObjc,DynWind,DynFold,DynMenc") NE 0 THEN
    ASSIGN lContainer = YES
           cPhysicalObject = "rydyncontw.w":U
           cLayout = "Relative":U.
ELSE IF pcObjectType = "dynbrow":U THEN
    ASSIGN lContainer = NO    /* Correct value for browsers */
           cPhysicalObject = "rydynbrowb.w":U 
           cLayout = "":U.
ELSE IF pcObjectType = "dynview":U THEN
    ASSIGN lContainer = NO    /* Correct value for viewers */
           cPhysicalObject = "rydynviewv.w":U 
           cLayout = "":U.
ELSE IF pcObjectType = "DataField":U THEN
    ASSIGN lContainer      = NO
           cPhysicalObject = "":U 
           cLayout         = "":U
           lHasExtension   = NO
           .
ELSE IF pcObjectType = "SDO":U THEN
    ASSIGN lContainer = NO    
           cPhysicalObject = "":U 
           cLayout = "":U.
ELSE IF lStaticObject THEN 
    ASSIGN lContainer = NO    /* for static objects */
           cPhysicalObject = pcObjectName 
           cLayout = "":U.
ELSE RETURN {af/sup2/aferrortxt.i 'RY' '5' '?' '?' pcObjectType}.

/* find product module for object */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModuleCode
     NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.   
END.
ELSE ASSIGN dProductModule = gsc_product_module.product_module_obj.

/* Find layout if required */
IF cLayout <> "":U THEN
DO:
  FIND FIRST ryc_layout NO-LOCK
       WHERE ryc_layout.layout_name = cLayout
       NO-ERROR.
  IF NOT AVAILABLE ryc_layout THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" cLayout}.   
  END.
END.
IF cLayout <> "":U AND AVAILABLE ryc_layout THEN
  ASSIGN dLayout = ryc_layout.layout_obj.
ELSE
  ASSIGN dLayout = 0.

/* Check if there is an object Extension */
IF lHasExtension THEN
DO:
    IF NUM-ENTRIES(cPhysicalObject, ".":U) > 1 THEN
        ASSIGN cObjectExt      = ENTRY(NUM-ENTRIES(cPhysicalObject, ".":U), cPhysicalObject, ".":U)
               cObjectFileName = REPLACE(cPhysicalObject, (".":U + cObjectExt), "":U)
               .
    ELSE
      ASSIGN cObjectExt      = "":U
             cObjectFileName = cPhysicalObject
             .
END.
ELSE
  ASSIGN cObjectExt      = "":U
         cObjectFileName = cPhysicalObject
         .

/* find corresponding physical object */
FIND FIRST gsc_object NO-LOCK
     WHERE gsc_object.Object_filename = cPhysicalObject
     NO-ERROR.
/* If not available then check gsc_object with separated file extension if any*/
IF NOT AVAILABLE gsc_object AND cObjectExt <> "" THEN
   FIND FIRST gsc_object NO-LOCK
        WHERE gsc_object.Object_filename = cObjectFileName AND
              gsc_object.Object_Extension = cObjectExt NO-ERROR.

IF NOT AVAILABLE gsc_object THEN
    dPhysicalObject = 0.
ELSE ASSIGN dPhysicalObject = gsc_object.object_obj.

/* find object type for object */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = pcObjectType NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Object Type'" pcObjectType}.
END.   
ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.

/* Find SDO name if passed in (viewers / browsers) */
IF cSDOName <> "":U THEN
DO:
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = cSDOName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
  DO:
    IF NUM-ENTRIES(cSDOName,".":U) > 1 THEN
    DO:
      FIND FIRST ryc_smartobject NO-LOCK
           WHERE ryc_smartobject.OBJECT_filename = ENTRY(1,cSDOName,".":U)
           NO-ERROR.
    END.
    IF NOT AVAILABLE ryc_smartobject THEN
      RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" cSDOName}.  
  END.
  ASSIGN dSDO = ryc_smartobject.smartobject_obj.
END.
ELSE ASSIGN dSDO = 0.

trn-block:
DO FOR bgsc_object, bryc_smartobject, bryc_attribute_value 
    TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

    /* find existing object record / create new one */

    /* Check if there is an object extension for the object we are creating. */
    IF lHasExtension THEN
    DO:
        IF NUM-ENTRIES(pcObjectName, ".":U) > 1 THEN
            ASSIGN cObjectExt      = ENTRY(NUM-ENTRIES(pcObjectName, ".":U), pcObjectName, ".":U)
                   cObjectFileName = REPLACE(pcObjectName, (".":U + cObjectExt), "":U)
                   .
        ELSE
            ASSIGN cObjectExt      = "":U
                   cObjectFileName = pcObjectName
                   .
    END.
    ELSE
        ASSIGN cObjectExt      = "":U
               cObjectFileName = pcObjectName
               .
  FIND FIRST bgsc_object EXCLUSIVE-LOCK
       WHERE bgsc_object.Object_filename = pcObjectName NO-ERROR.
  IF NOT AVAILABLE bgsc_object AND cObjectExt <> "" THEN
     FIND FIRST bgsc_object EXCLUSIVE-LOCK
          WHERE bgsc_object.Object_filename = cObjectFileName AND
                bgsc_object.Object_Extension = cObjectExt NO-ERROR.

  IF NOT AVAILABLE bgsc_object THEN
  DO:
    CREATE bgsc_object NO-ERROR.
    {afcheckerr.i &no-return = YES}
    
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    
    ASSIGN
      bgsc_object.object_filename = (IF cObjectExt <> "" THEN cObjectFileName ELSE pcObjectName)
      bgsc_object.Object_Extension = cObjectExt
      bgsc_object.DISABLED = NO     
      NO-ERROR.
    {afcheckerr.i &no-return = YES}
  END.

  /* Update object details */
  ASSIGN
    bgsc_object.object_description = pcObjectDescription 
    bgsc_object.logical_object = (IF pcObjectType = "DataField":U THEN NO ELSE NOT lStaticObject )
    bgsc_object.generic_object = NO
    bgsc_object.container_object = lContainer
    bgsc_object.object_path = cObjectPath
    bgsc_object.object_type_obj = dObjectType
    bgsc_object.physical_object_obj = dPhysicalObject
    bgsc_object.product_module_obj = dProductModule
    bgsc_object.required_db_list = cRequiredDBList
    bgsc_object.runnable_from_menu = lContainer  
    bgsc_object.run_persistent = lRunPersistent
    bgsc_object.run_when = "ANY":U
    bgsc_object.security_object_obj = bgsc_object.object_obj
    bgsc_object.toolbar_image_filename = "":U
    bgsc_object.toolbar_multi_media_obj = 0
    bgsc_object.tooltip_text = cTooltipText
    NO-ERROR.
   {afcheckerr.i &no-return = YES}

  VALIDATE bgsc_object NO-ERROR.
  {afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  /* Find/create SmartObject record */
  FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.OBJECT_filename = bgsc_object.object_filename /* use same filename as gsc_object */
       NO-ERROR.
  
  IF NOT AVAILABLE bryc_smartobject THEN
  DO:
    CREATE bryc_smartobject NO-ERROR.
    
    {afcheckerr.i &no-return = YES}
       
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_smartobject.object_filename = bgsc_object.object_filename /* use same filename as gsc_object */
      bryc_smartobject.system_owned = NO
      bryc_smartobject.shutdown_message_text = "":U
      bryc_smartobject.template_smartobject = lTemplate
      NO-ERROR.
    {afcheckerr.i &no-return = YES}
  END.

  /* Update rest of details */  
  ASSIGN
    bryc_smartobject.static_object = (IF pcObjectType = "DataField":U THEN NO ELSE lStaticObject)
    bryc_smartobject.product_module_obj = dProductModule
    bryc_smartobject.layout_obj = dLayout
    bryc_smartobject.object_obj = bgsc_object.OBJECT_obj
    bryc_smartobject.object_type_obj = dObjectType
    bryc_smartobject.sdo_smartobject_obj = dSDO
    bryc_smartobject.custom_super_procedure = cSuper
    NO-ERROR.  
    {afcheckerr.i &no-return = YES}
  
  VALIDATE bryc_smartobject NO-ERROR.
  {afcheckerr.i &no-return = YES}
      
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  pdSmartObject = bryc_smartobject.smartobject_obj.
    

  /* now cascade attribute values down off object type, updating them if they
     already exist. This is done only for dynamic objects.
  */
IF NOT lStaticObject THEN
  attribute-loop:
  FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = dObjectType
        AND ryc_attribute_value.smartobject_obj           = 0
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = dObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = 0
           AND bryc_attribute_value.container_smartobject_obj = 0
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.

    FIND FIRST ryc_attribute_group WHERE
               ryc_attribute_group.attribute_group_obj = ryc_attribute_value.attribute_group_obj
               NO-LOCK.

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = dObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = 0
      bryc_attribute_value.container_smartobject_obj = 0
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdSmartObject
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
      NO-ERROR.
      {afcheckerr.i &no-return = YES}

    VALIDATE bryc_attribute_value NO-ERROR.
    {afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    
  END. /* attribute-loop */
    
END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeObjectInstance Procedure 
PROCEDURE storeObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object instance on a container
  Parameters:  input container object number
               input object filename of object on container (must exist)
                     nb: for sdo, object name is sdo + chr(3) + browser
               input layout position of object on container, e.g. top;
                IF this value begins "Absolute", then that layout type is
                followed by the Row, Column, Width, and Height in chars
                (CHR(3)-delimited to allow for comma in European decimal format)
                     
               output object number of object on container
               output object type object number of object on container
               output instance object number of object on container
               
  Notes:       If object already exists on container, the instance and its
               attribute values will be updated accordingly, otherwise the
               instance will be created.
               We determine whether the object exists based on the objects layout
               position, as an object can exist on a container multiple times. This
               means that the layout position must always be different for every
               object on a container for this to work.
               We must also manually cascade smartobject attribute values down
               onto new object instance if creating a new instance.
               procedure based on updateObjectInstance of rywizogenp.p.
               
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdContainer                 AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayoutPosition            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdInstance                  AS DECIMAL    NO-UNDO.

DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dColumn                             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRow                                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidth                              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dHeight                             AS DECIMAL    NO-UNDO.

ASSIGN cMessageList = "":U.

/* Capture absolute position. */
IF ENTRY(1, pcLayoutPosition, CHR(3)) = "Absolute":U THEN
    ASSIGN dRow    = DECIMAL(ENTRY(2, pcLayoutPosition, CHR(3)))
           dColumn = DECIMAL(ENTRY(3, pcLayoutPosition, CHR(3)))
           dWidth  = DECIMAL(ENTRY(4, pcLayoutPosition, CHR(3)))
           dHeight = DECIMAL(ENTRY(5, pcLayoutPosition, CHR(3)))
           pcLayoutPosition = "Absolute":U.

/* 1st find smartobject to put on page - this must already exist */
FIND FIRST ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.OBJECT_filename = pcObjectName
     NO-ERROR.

IF NOT AVAILABLE ryc_smartobject THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SmartObject'" pcObjectName}. 
END.

DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

/* update object instance and instance attribute values */
trn-block:
DO FOR bryc_object_instance, bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_object_instance EXCLUSIVE-LOCK
       WHERE bryc_object_instance.container_smartobject_obj = pdContainer
         AND bryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
         AND bryc_object_instance.layout_position = pcLayoutPosition
       NO-ERROR.
  
  IF NOT AVAILABLE bryc_object_instance THEN
  DO:
    CREATE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_object_instance.container_smartobject_obj = pdContainer
      bryc_object_instance.smartobject_obj  = ryc_smartobject.smartobject_obj
      bryc_object_instance.layout_position = pcLayoutPosition
      bryc_object_instance.instance_height = dHeight
      bryc_object_instance.instance_width = dWidth
      bryc_object_instance.instance_x = dColumn
      bryc_object_instance.instance_y = dRow
      bryc_object_instance.system_owned = NO
      .
    VALIDATE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.

  /* Set-up return values (NB: object type no longer returned) */
  ASSIGN
    pdSmartObject = ryc_smartobject.smartobject_obj
    dObjectType = ryc_smartobject.OBJECT_type_obj
    pdInstance = bryc_object_instance.OBJECT_instance_obj
    .

  /* now cascade attribute values down off smartobject onto instance - this will not
     override any customisations, i.e attributes that already exist but the inherrited
     value is set to NO
  */
  attribute-loop:
  FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = dObjectType
        AND ryc_attribute_value.smartobject_obj           = pdSmartObject
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = dObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = dObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = pdInstance
      bryc_attribute_value.container_smartobject_obj = pdContainer
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdContainer
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
      .
/* NB: TEST CODE---- */
    IF NOT CAN-FIND(ryc_attribute WHERE ryc_attribute.attribute_label =
                    bryc_attribute_value.attribute_label) THEN
        MESSAGE "No attribute for: " bryc_attribute_value.attribute_label.

    VALIDATE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    
  END. /* attribute-loop */

END. /* trn-block */

IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeObjectType Procedure 
PROCEDURE storeObjectType :
/*------------------------------------------------------------------------------
  Purpose:     Create a new gsc_object_type or update an existing one.
  Parameters:  pcObjectType AS CHAR -- Object type code
               pcDescription AS CHAR -- object type desc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectType  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcDescription AS CHARACTER  NO-UNDO.

    DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

    trn-block:
    DO FOR bgsc_object_type TRANSACTION 
        ON ERROR UNDO trn-block, LEAVE trn-block:
    
        FIND bgsc_object_type WHERE 
            bgsc_object_type.OBJECT_type_code =
              pcObjectType EXCLUSIVE-LOCK NO-ERROR.  /* Does it already exist? */
        
        IF NOT AVAILABLE bgsc_object_type THEN
        DO:
          CREATE bgsc_object_type NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
          ASSIGN
            bgsc_object_type.OBJECT_type_code = pcObjectType.
        END.   /* Create if not already there. */
    
        IF pcDescription NE "":U AND pcDescription NE ? THEN
            bgsc_object_type.OBJECT_type_description = pcDescription.
        
        VALIDATE bgsc_object_type NO-ERROR.  
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      
    END. /* trn-block */

    RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storePage Procedure 
PROCEDURE storePage :
/*------------------------------------------------------------------------------
  Purpose:     Create the repository record for a page, to be followed by calls
               to storePageObject for each instance on the page.
  Parameters:  INPUT pdContainer -- Container object id
               INPUT pcLayoutName 
               INPUT pcPageLabel
               INPUT piPageNum -- page sequence
               INPUT pcAttrLabels -- miscellaneous values to set, includes
                   EnableOnCreate, EnableOnModify, EnableOnView
               INPUT pcAttrValues -- CHR(3)-delimited list of values of those
                    attributes.
               OUTPUT pdPage -- page id
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pdContainer          AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcLayoutName         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPageLabel          AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER piPageNum            AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttrLabels         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttrValues         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdPage               AS DECIMAL    NO-UNDO.

DEFINE VARIABLE iAttr                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cValue                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lValue                       AS LOGICAL    NO-UNDO.

/* 1st find layout for the page - this must already exist */
FIND FIRST ryc_layout NO-LOCK
     WHERE ryc_layout.layout_name = pcLayoutName
     NO-ERROR.

IF NOT AVAILABLE ryc_layout THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" pcLayoutName}. 
END.

DEFINE BUFFER bryc_page FOR ryc_page.

/* update page record */
trn-block:
DO FOR bryc_page TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_page EXCLUSIVE-LOCK
       WHERE bryc_page.container_smartobject_obj = pdContainer AND
             bryc_page.PAGE_sequence = piPageNum NO-ERROR.
  
  IF NOT AVAILABLE bryc_page THEN
  DO:
    CREATE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page.container_smartobject_obj = pdContainer
      bryc_page.layout_obj = ryc_layout.layout_obj
      bryc_page.PAGE_sequence = piPageNum.
    VALIDATE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.   /* END DO IF NOT AVAILABLE Page */

  bryc_page.layout_obj = ryc_layout.layout_obj.
  IF pcAttrLabels NE "":U THEN
  DO iAttr = 1 TO NUM-ENTRIES(pcAttrLabels):
      cValue = ENTRY(iAttr, pcAttrValues, CHR(3)).
      lValue = IF cValue = "YES":U OR cValue = "TRUE":U THEN 
          TRUE ELSE FALSE.
      CASE ENTRY(iAttr, pcAttrLabels):
          WHEN "EnableOnCreate":U THEN
              ryc_page.ENABLE_on_create = lValue.
          WHEN "EnableOnModify":U THEN
              ryc_page.ENABLE_on_modify = lValue.
          WHEN "EnableOnView":U THEN
              ryc_page.ENABLE_on_view = lValue.
      END CASE.
  END.         /* END DO iAttr */
END.           /* END TRANSACTION */
  
pdPage = ryc_page.PAGE_obj.

  RETURN cMessageList.
                                      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storePageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storePageObject Procedure 
PROCEDURE storePageObject :
/*------------------------------------------------------------------------------
  Purpose:     Create the repository record for a page object which is the
               instance of an object on the page.
  Parameters:  INPUT pdContainer -- Container object id, returned by storeObject
               INPUT pdPage -- Page object id (returned by storePage) 
               INPUT pdInstance -- Object Instance ID, returned by 
                  storeObjectInstance
               INPUT piPageSequence -- page sequence is I believe always 1
               
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pdContainer          AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdPage               AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdInstance           AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER piPageSequence       AS INTEGER    NO-UNDO.

DEFINE BUFFER bryc_page_object FOR ryc_page_object.

/* update page object record */
trn-block:
DO FOR bryc_page_object TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_page_object EXCLUSIVE-LOCK
       WHERE bryc_page_object.container_smartobject_obj = pdContainer AND
             bryc_page_object.PAGE_obj = pdPage AND
             bryc_page_object.PAGE_object_sequence = piPageSequence NO-ERROR.
  
  IF NOT AVAILABLE bryc_page_object THEN
  DO:
    CREATE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page_object.container_smartobject_obj = pdContainer
      bryc_page_object.PAGE_obj = pdPage
      bryc_page_object.PAGE_object_sequence = piPageSequence
      bryc_page_object.OBJECT_instance_obj = pdInstance.
    VALIDATE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.   /* END DO IF NOT AVAILABLE Page_Object */

END.           /* END TRANSACTION */
  
  RETURN cMessageList.
                                      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeTableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeTableFields Procedure 
PROCEDURE storeTableFields :
/*------------------------------------------------------------------------------
  Purpose:     procedure to create DataField records for a table.
  Parameters:  pcDataBaseName AS CHAR
               pcTableName    AS CHAR
               pcProductModule AS CHAR
  Notes:       This procedure will first create supporting repository records 
               for DataFields if they are not already there, including
               the DataField Object Type, WidgetAttributes group,
               and attribute records for new attributes.
               It then creates a DataField smartobject for each field in the
               table, and assigns all of its attributes.               
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcDataBaseName          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcTableName             AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModule         AS CHARACTER        NO-UNDO.
    
    DEFINE VARIABLE hDbBuffer                   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFileBuffer                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cWhere                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSchemaName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDbBufferName               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFileBufferName             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldBufferName            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldList                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttrList                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttr                       AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iIndex                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE dDataField                  AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dDataFieldType              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cAttrValues                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cExtraAttrs                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFullAttrList               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDataFieldName              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iExtent                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iMaxExtent                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cTypeTla                    AS CHARACTER            NO-UNDO.

    DEFINE BUFFER bryc_attribute FOR ryc_attribute.

    /* This is the list of the _Field fields for the table for which we will
     * retrieve values and define attribute_values for the DataField.       */
    ASSIGN cFieldList = "_Field-Name,_Label,_Col-Label,_Format,_Help,_Mandatory,_Order,_View-As,_Initial,_Data-Type":U.

    /* And this is the list of the corresponding object attributes for which
     * we'll create values.                                                 */
    ASSIGN cAttrList = "FieldName,Label,ColumnLabel,Format,Help,Mandatory,FieldOrder,VisualizationType,InitialValue,Data-Type":U.

    /* And this is the list of additional attributes that we'll create from
     * here if they don't already exist, but which we don't create values for
     * for the DataField; they're used only in SDOs or Viewers. Make sure
     * this list ends with a comma so it is properly concatenated with the
     * AttrList.                                                            */
    ASSIGN cExtraAttrs = "DataSource,Row,Column,Width-Chars,Height-Chars,NoLabel,Enabled,":U
                       + "ShowPopup,MinWidth,MinHeight,DataSource,Font,Row,Column,Width-Chars,":U
                       + "Height-Chars,Enabled,LabelFont,NoLabel,DisplayField,Visible,":U
                       + "DataBaseName,TableName,LabelFgColor,LabelBgColor":U
                       .
    /* Open a query for all the _Field records for the _File that was passed in. */

    /* If the logical object name and the schema name differ, then we assume that we are working with 
     * a DataServer. If the schema and logical names are the same, we are dealing with a native 
     * Progress DB.                                                                                   */
    ASSIGN cSchemaName = SDBNAME(pcDataBaseName).

    IF cSchemaName EQ pcDataBaseName THEN
        ASSIGN cDbBufferName    = pcDataBaseName + "._Db":U
               cFileBufferName  = pcDataBaseName + "._File":U
               cFieldBufferName = pcDataBaseName + "._Field":U
               cWhere           = "FOR EACH ":U + cDbBufferName + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                +   cFileBufferName + "._File-name = '":U + pcTableName + "' ":U
                                + " NO-LOCK, ":U
                                + " EACH ":U + cFieldBufferName + " WHERE ":U
                                +   cFieldBufferName + "._File-recid = RECID(_File) ":U
                                + " NO-LOCK ":U.
    ELSE
        ASSIGN cDbBufferName    = cSchemaName + "._Db":U
               cFileBufferName  = cSchemaName + "._File":U
               cFieldBufferName = cSchemaName + "._Field":U
               cWhere           = " FOR EACH ":U + cDbBufferName + " WHERE ":U
                                +   cDbBufferName + "._Db-Name = '" + pcDataBaseName + "' ":U
                                + " NO-LOCK, ":U
                                + " EACH " + cFileBufferName + " WHERE ":U
                                +   cFileBufferName + "._Db-recid  = RECID(_Db) AND ":U
                                +   cFileBufferName + "._File-name = '":U + pcTableName + "' ":U
                                + " NO-LOCK, ":U
                                + " EACH ":U + cFieldBufferName + " WHERE ":U
                                +  cFieldBufferName + "._File-recid = RECID(_File) ":U
                                + " NO-LOCK ":U.

    CREATE BUFFER hDbBuffer    FOR TABLE cDbBufferName.
    CREATE BUFFER hFileBuffer  FOR TABLE cFileBufferName.
    CREATE BUFFER hFieldBuffer FOR TABLE cFieldBufferName.

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hDbBuffer, hFileBuffer, hFieldBuffer).
    hQuery:QUERY-PREPARE(cWhere).

    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST(NO-LOCK).

    IF NOT hDbBuffer:AVAILABLE THEN
        RETURN {aferrortxt.i 'AF' '5' '?' '?' "'Table Name'" pcTableName}.

    /* Add to the list of attributes derived from _Field values the ones that
     * are assigned values from the parameters to the procedure. */
    ASSIGN cFullAttrList  = cAttrList + ",":U + cExtraAttrs
           /* Get the object type id */
           dDataFieldType = ObjectTypeObj('DataField':U)
           .
    /* create the new attribute group */
    RUN storeAttribute ( INPUT "":U,           /* Blank name & Type means create a group */
                         INPUT "":U,
                         INPUT 'Attributes for Data Fields':U,    /* desc */
                         INPUT 'GroupName':U,
                         INPUT 'WidgetAttributes':U).
    IF RETURN-VALUE NE "":U THEN RETURN RETURN-VALUE.

    /* If the DataField object type doesn't exist yet, then we presume
     * that none of the attributes for widgets, or the widget attribute
     * group, have been created either, so we do them all here.        */
    DO iIndex = 1 TO NUM-ENTRIES(cFullAttrList):
        ASSIGN cAttr    = ENTRY(iIndex, cFullAttrList)
               cTypeTla = "CHR":U.

        IF NOT CAN-FIND(FIRST bryc_attribute
                        WHERE bryc_attribute.attribute_label = cAttr
                        AND   bryc_attribute.attribute_type_tla = "CHR":U) THEN DO:
          FIND FIRST bryc_attribute
               WHERE bryc_attribute.attribute_label = cAttr
               NO-LOCK NO-ERROR.
          IF AVAILABLE bryc_attribute THEN
            cTypeTla = bryc_attribute.attribute_type_tla.
        END.
        RUN storeAttribute ( INPUT cAttr,          /* Attribute name */
                             INPUT cTypeTla,   /* attribute type */
                             INPUT 'WidgetAttributes ':U + cAttr,    /* desc */
                             INPUT "GroupName":U,            /* set attribute_group */
                             INPUT "WidgetAttributes":U).
        IF RETURN-VALUE NE "":U THEN RETURN  RETURN-VALUE.
    END.     /* END DO iIndex -- for each attribute name */
    /* Now create attribute_value records with default values for the new 
     * DataField Object Type. If any changes are made to the list
     * of attributes, list list of defaults needs to be modified as well.  */
    ASSIGN cAttrValues   = FILL(CHR(3), NUM-ENTRIES(cFullAttrList) - 1)
           cFullAttrList = TRIM(cFullAttrList, ",":U)
           .
    /* For each field in the table, create a DataField --smartobject and object */
    DO WHILE hFieldBuffer:AVAILABLE:
        ASSIGN 
          hField     = hFieldBuffer:BUFFER-FIELD("_Field-Name":U)
          cFieldName = hField:BUFFER-VALUE
          hField     = hFieldBuffer:BUFFER-FIELD("_Extent":U)
          iExtent    = INTEGER(hField:BUFFER-VALUE).

        IF iExtent = 0 THEN iMaxExtent = 1. ELSE iMaxExtent = iExtent.

        DO iLoop = 1 TO iMAxExtent:

          IF iExtent <> 0 THEN
            ASSIGN
              cDataFieldName = SUBSTITUTE("&1[&2]",cFieldname,STRING(iLoop)).
          ELSE
            ASSIGN
              cDataFieldName = cFieldname.

          RUN storeObject  ( INPUT 'DataField':U,                      /* object type  */
                             INPUT pcProductModule,                    /* product module */
                             INPUT pcTableName + ".":U + cDataFieldName,   /* Object Name = fieldname */
                             INPUT "DataField for ":U + pcTableName + ".":U + cDataFieldName,   /* Desc */
                             INPUT "RunPersistent":U,                  /* Run persistent = no */
                             INPUT "NO":U,
                             OUTPUT dDataField).                       /* DataField SmartObject ID */
          IF RETURN-VALUE NE "":U THEN RETURN  RETURN-VALUE.
  
          /* Now create attribute_value records for the new DataField.
           * Always use a FILL-IN as Visualization Type.               */
          DO iIndex = 1 TO NUM-ENTRIES(cFieldList):
              ASSIGN hField = hFieldBuffer:BUFFER-FIELD(ENTRY(iIndex, cFieldList)).
              ASSIGN ENTRY(LOOKUP(ENTRY(LOOKUP(hField:NAME, cFieldList), cAttrList), cFullAttrList), cAttrValues, CHR(3)) = TRIM(hField:STRING-VALUE)
                     NO-ERROR.
  
              IF hField:NAME EQ "_Data-type":U THEN
              DO:
                  IF LOOKUP(TRIM(hField:STRING-VALUE), "DATE,INTEGER,DECIMAL":U) GT 0 THEN
                      ASSIGN ENTRY(LOOKUP("ShowPopup":U, cFullAttrList), cAttrValues, CHR(3)) = STRING(YES) NO-ERROR.
                  ELSE
                      ASSIGN ENTRY(LOOKUP("ShowPopup":U, cFullAttrList), cAttrValues, CHR(3)) = STRING(NO) NO-ERROR.
              END.    /* data type */
          END.    /* END DO iIndex -- for each of the _Field names */
  
          /* Add other attribute values, where possible */
          ASSIGN ENTRY(LOOKUP("DataBaseName":U, cFullAttrList),      cAttrValues, CHR(3)) = pcDataBaseName
                 ENTRY(LOOKUP("TableName":U, cFullAttrList),         cAttrValues, CHR(3)) = pcTableName
                 ENTRY(LOOKUP("Font":U, cFullAttrList),              cAttrValues, CHR(3)) = "?":U
                 ENTRY(LOOKUP("LabelFont":U, cFullAttrList),         cAttrValues, CHR(3)) = "?":U
                 ENTRY(LOOKUP("LabelBgColor":U, cFullAttrList),      cAttrValues, CHR(3)) = "?":U
                 ENTRY(LOOKUP("LabelFgColor":U, cFullAttrList),      cAttrValues, CHR(3)) = "?":U
                 ENTRY(LOOKUP("Height-Chars":U, cFullAttrList),      cAttrValues, CHR(3)) = STRING(1)
                 ENTRY(LOOKUP("Visible":U, cFullAttrList),           cAttrValues, CHR(3)) = STRING(YES)
                 ENTRY(LOOKUP("VisualizationType":U, cFullAttrList), cAttrValues, CHR(3)) = "FILL-IN":U
                 
                 cAttrValues = TRIM(cAttrValues, CHR(3))
                 NO-ERROR.       
          RUN storeAttributeValues ( INPUT dDataFieldType,      /* Object Type */
                                     INPUT dDataField,          /* DataField smartobject */
                                     INPUT 0,                   /* No container */
                                     INPUT 0,                   /* No instance */
                                     INPUT cFullAttrList,       /* Attribute labels (names) */
                                     INPUT cAttrValues).        /* Values for those attributes */
          IF RETURN-VALUE NE "":U THEN RETURN RETURN-VALUE.
        END.
        hQuery:GET-NEXT(NO-LOCK).
    END.        /* END DO WHILE Field AVAILABLE */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeViewer Procedure 
PROCEDURE storeViewer :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a dynamic viewer object based on
               information in the viewer Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       Based on partially completed generateViewer in rywizogenp.p.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_view FOR rym_wizard_view.

DEFINE VARIABLE dViewer                             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cEnabledFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_view TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_view EXCLUSIVE-LOCK
       WHERE brym_wizard_view.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_view THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'viewer'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObject (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN storeObject (INPUT brym_wizard_view.product_module_code,
                   INPUT brym_wizard_view.OBJECT_name,
                   INPUT brym_wizard_view.OBJECT_description,
                   INPUT "CustomerSuperProcedure=":U + 
                             brym_wizard_view.custom_super_procedure,
                   OUTPUT dViewer).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Assign viewer attribute values */
  ASSIGN
    cEnabledFields = ""
    cDisplayedFields = ""
    .

  DO iLoop = 1 TO NUM-ENTRIES(brym_wizard_view.SELECTED_fields, CHR(3)):
    ASSIGN
      cEntry = ENTRY(iLoop, brym_wizard_view.SELECTED_fields, CHR(3)).
    IF NUM-ENTRIES(cEntry, CHR(4)) = 3 THEN
    DO:
      ASSIGN
        cDisplayedFields = cDisplayedFields + 
                           (IF cDisplayedFields <> "":U THEN ",":U ELSE "":U) +
                           ENTRY(2, cEntry, CHR(4)).
      IF ENTRY(3, cEntry, CHR(4)) = "YES":U THEN
      DO:
        ASSIGN
          cEnabledFields = cEnabledFields + 
                           (IF cEnabledFields <> "":U THEN ",":U ELSE "":U) +
                           ENTRY(2, cEntry, CHR(4)).
      END.
    END.
  END.

  ASSIGN
    cAttributeLabels = "WindowTitleField,DisplayedFields,EnabledFields":U
    cAttributeValues = brym_wizard_view.window_title_field + CHR(3) + cDisplayedFields + CHR(3) + cEnabledFields
    .
    
  /* Update attribute values */
  RUN storeAttributeValues (INPUT 0,
                             INPUT dViewer,
                             INPUT 0,
                             INPUT 0,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_view.generated_date = TODAY
    brym_wizard_view.generated_time = TIME
    .
  VALIDATE brym_wizard_view NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePage Procedure 
PROCEDURE updatePage :
/*------------------------------------------------------------------------------
  Purpose:     To add/update a container page
  Parameters:  input container object number
               input page number
               input page label
               input layout name
               output page object number
  Notes:       This routine assumes the security token to be the same as the
               page label. It also assumes all pages will be enabled in create,
               view and modify mode for now.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdContainer                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  piPageNumber                    AS INTEGER    NO-UNDO.
DEFINE INPUT PARAMETER  pcPageLabel                     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayout                        AS CHARACTER  NO-UNDO.

/* validate layout specified */
FIND FIRST ryc_layout NO-LOCK
     WHERE ryc_layout.layout_name = pcLayout
     NO-ERROR.
IF NOT AVAILABLE ryc_layout THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" pcLayout}.      
END.

DEFINE BUFFER bryc_page FOR ryc_page.

ASSIGN cMessageList = "":U.

trn-block:
DO FOR bryc_page TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_page EXCLUSIVE-LOCK
       WHERE bryc_page.container_smartobject_obj = pdContainer
         AND bryc_page.PAGE_sequence = piPageNumber
       NO-ERROR.

  IF NOT AVAILABLE bryc_page THEN
  DO:
    CREATE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page.container_smartobject_obj = pdContainer
      bryc_page.PAGE_sequence = piPageNumber
      bryc_page.enable_on_create = YES
      bryc_page.enable_on_modify = YES
      bryc_page.enable_on_view = YES
      .
  END.

  ASSIGN
    bryc_page.page_label = pcPageLabel
    bryc_page.security_token = pcPageLabel
    bryc_page.layout_obj = ryc_layout.layout_obj 
    .
  VALIDATE bryc_page NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  FIND FIRST ttPage
       WHERE ttPage.iPageNumber = piPageNumber
       NO-ERROR.
  IF NOT AVAILABLE ttPage THEN
  DO:
    CREATE ttPage.
    ASSIGN ttPage.iPageNumber = piPageNumber.
  END.
  ASSIGN
    ttPage.dPageObj = bryc_page.PAGE_obj.
  
END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageObject Procedure 
PROCEDURE updatePageObject :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object instance on a container page
  Parameters:  input container object number
               input object instance object number
               input page object number
               input page object sequence
  Notes:       If the object sequence number already exists on the page, then
               only the object appearing in the sequence will be updated.
               Also, delete instance off container if exists with another
               sequence - for now we are assuming that an object instance can
               only appear once on a folder window.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdContainer                    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdInstance                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdPage                         AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER piObjectSequence               AS INTEGER    NO-UNDO.

DEFINE BUFFER bryc_page_object FOR ryc_page_object.

ASSIGN cMessageList = "":U.

trn-block:
DO FOR bryc_page_object TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* Zap object from container - in cased moved page or sequence */
  FOR EACH bryc_page_object EXCLUSIVE-LOCK
     WHERE bryc_page_object.container_smartobject_obj = pdContainer
       AND bryc_page_object.object_instance_obj = pdInstance:
    DELETE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.

  FIND FIRST bryc_page_object EXCLUSIVE-LOCK
       WHERE bryc_page_object.container_smartobject_obj = pdContainer
         AND bryc_page_object.PAGE_obj = pdPage
         AND bryc_page_object.PAGE_object_sequence = piObjectSequence
       NO-ERROR.

  IF NOT AVAILABLE bryc_page_object THEN
  DO:
    CREATE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page_object.container_smartobject_obj = pdContainer
      bryc_page_object.PAGE_obj = pdPage
      bryc_page_object.PAGE_object_sequence = piObjectSequence
      .
  END.

  ASSIGN
    bryc_page_object.object_instance_obj = pdInstance
    .
  VALIDATE bryc_page_object NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  
END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateStaticObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateStaticObject Procedure 
PROCEDURE updateStaticObject :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update ASDB gsc_object and RYDB
               ryc_smartobject records for static object passed in.
  Parameters:  input object type (valid gsc_object_type)
               input container flag YES/NO
               input object name
               input product module code
               input object path
               input object description
               input required DB list
               input sdo name if required (pass in correct object name for sdo, without extension if stored without extension)
               output object number of smartobject created / updated
               output object type object number
  Notes:       Attribute values are cascaded down onto new smartobjects from the
               object type by the replication write trigger of the smartobject
               coded in rycsoreplw.i
               Errors are passed back in return value.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plContainer                 AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProductModuleCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectPath                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectDescription         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcRequiredDBList            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSDOName                   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.

DEFINE BUFFER bgsc_object FOR gsc_object.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

DEFINE VARIABLE cPhysicalObject                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProductModule                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDO                                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cObjectExt             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectFilename        AS CHARACTER  NO-UNDO.

ASSIGN cMessageList = "":U.

/* find product module for object */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModuleCode
     NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.   
END.
ELSE ASSIGN dProductModule = gsc_product_module.product_module_obj.

/* find object type for object */
FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = pcObjectType
     NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Object Type'" pcObjectType}.   
END.
ELSE ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.


/* Find SDO name if passed in (viewers / browsers) */
IF pcSDOName <> "":U THEN
DO:
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = pcSDOName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
  DO:
    IF NUM-ENTRIES(pcSDOName,".":U) > 1 THEN
    DO:
      FIND FIRST ryc_smartobject NO-LOCK
           WHERE ryc_smartobject.OBJECT_filename = ENTRY(1,pcSDOName,".":U)
           NO-ERROR.
    END.
    IF NOT AVAILABLE ryc_smartobject THEN
      RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSDOName}.  
  END.
  ASSIGN dSDO = ryc_smartobject.smartobject_obj.
END.
ELSE ASSIGN dSDO = 0.

trn-block:
DO FOR bgsc_object, bryc_smartobject TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
  /* Check if there is an object Extension */
  IF R-INDEX(pcObjectName,".") > 0 THEN DO:
     cObjectExt = ENTRY(NUM-ENTRIES(pcObjectName,"."),pcObjectName,".").
     cObjectFileName = REPLACE(pcObjectName,("." + cObjectExt),"").
  END.
  ELSE DO:
     cObjectExt = "".
     cObjectFileName = pcObjectName.
  END.
  /* find existing ASDB object / create new one */
  FIND FIRST bgsc_object EXCLUSIVE-LOCK
       WHERE bgsc_object.Object_filename = pcObjectName NO-ERROR.
  /* If not available then check gsc_object with separated file extension if any*/
  IF NOT AVAILABLE bgsc_object AND cObjectExt <> "" THEN
     FIND FIRST bgsc_object EXCLUSIVE-LOCK
          WHERE bgsc_object.Object_filename = cObjectFileName AND
                bgsc_object.Object_Extension = cObjectExt NO-ERROR.

  IF NOT AVAILABLE bgsc_object THEN
  DO:
    CREATE bgsc_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    
    ASSIGN
      bgsc_object.object_filename = (IF cObjectExt <> "" THEN cObjectFileName ELSE pcObjectName)
      bgsc_object.Object_Extension = cObjectExt
      bgsc_object.DISABLED = NO
      .      
  END.

  /* Update ASDB object details */
  ASSIGN
    bgsc_object.object_description = pcObjectDescription 
    bgsc_object.logical_object = NO
    bgsc_object.generic_object = NO
    bgsc_object.container_object = plContainer
    bgsc_object.object_path = pcObjectPath
    bgsc_object.object_type_obj = dObjectType
    bgsc_object.physical_object_obj = 0
    bgsc_object.product_module_obj = dProductModule
    bgsc_object.required_db_list = pcRequiredDBList
    bgsc_object.runnable_from_menu = plContainer  
    bgsc_object.run_persistent = YES
    bgsc_object.run_when = "ANY":U
    bgsc_object.security_object_obj = bgsc_object.object_obj
    bgsc_object.toolbar_image_filename = "":U
    bgsc_object.toolbar_multi_media_obj = 0
    bgsc_object.tooltip_text = "":U
    .
  VALIDATE bgsc_object NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  /* Find/create RYDB repository object */
  FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.OBJECT_filename = bgsc_object.object_filename /* use same filename as gsc_object */
       NO-ERROR.
  
  IF NOT AVAILABLE bryc_smartobject THEN
  DO:
    CREATE bryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_smartobject.object_filename = bgsc_object.object_filename /* use same filename as gsc_object */
      bryc_smartobject.custom_super_procedure = "":U
      bryc_smartobject.system_owned = NO
      bryc_smartobject.shutdown_message_text = "":U
      bryc_smartobject.template_smartobject = NO
      .      
  END.

  /* Update rest of details */
  ASSIGN
    bryc_smartobject.static_object = YES
    bryc_smartobject.product_module_obj = dProductModule
    bryc_smartobject.layout_obj = 0
    bryc_smartobject.object_obj = bgsc_object.OBJECT_obj
    bryc_smartobject.object_type_obj = dObjectType
    bryc_smartobject.sdo_smartobject_obj = dSDO
    .  
  VALIDATE bryc_smartobject NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    pdSmartObject = bryc_smartobject.smartobject_obj
    pdObjectType = dObjectType
    .

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateViewerLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateViewerLinks Procedure 
PROCEDURE updateViewerLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdContainer AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcLinkName  AS CHARACTER  NO-UNDO.

  /* Finally add data and group assign links and user links between viewers */
  DEFINE BUFFER bttViewer FOR ttViewer.
  DEFINE BUFFER bttSDO FOR ttSDO.
  
  FOR EACH ttViewer 
      WHERE ttViewer.lPrimary = YES:
    
    /* The non primary viewers need to link to the primary viewer's SDO as 
       data source and possibly update-target */ 
    FIND FIRST bttSDO 
         WHERE bttSDO.cSDOName = ttViewer.cSDOName NO-ERROR. 

    FOR EACH bttViewer 
        WHERE bttViewer.cSDOName = ttViewer.cSDOName
        AND   bttViewer.lPrimary = NO:
         
      RUN updateLink (INPUT "Data":U,
                      INPUT "":U,
                      INPUT pdContainer,
                      INPUT IF AVAIL bttSDO THEN bttSDO.dSDOObjectInstance ELSE 0,
                      INPUT bttViewer.dViewerObjectInstance).
      IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
            
      /* If this is a regular SmartObject or an SBO that updates OneTOOne SDOs then 
          use groupAssign */ 
      IF NOT bttSDO.lContainer OR bttSDO.lOneToOne THEN
      DO:
        RUN updateLink (INPUT "GroupAssign":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT bttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.
      ELSE DO:
        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT bttViewer.dViewerObjectInstance,
                        INPUT IF AVAIL bttSDO THEN bttSDO.dSDOObjectInstance ELSE 0).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.

      /* A viewer link name of 'GroupAssign' indicates SBO one-to-one across 
         pages in order to update the SDOs in a one-to-one and has been used to 
         set the lsssss flag on ttSDO */
      IF pcLinkName  <> "":U AND pcLinkName <> 'GroupAssign':U THEN
      DO:
        RUN updateLink (INPUT pcLinkName,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT bttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.
    END.  /* for each bttViewer (child of ttViewer and primary = no) */ 
  END. /* for ttViewer where lPrimary*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-attributeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION attributeObj Procedure 
FUNCTION attributeObj RETURNS DECIMAL
  ( INPUT pcAttributeName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Object ID of an Attribute given the name as INPUT
  Returns:  Attribute obj id (decimal)
------------------------------------------------------------------------------*/

  FIND ryc_attribute WHERE ryc_attribute.attribute_label = 
      pcAttributeName NO-LOCK NO-ERROR.
  RETURN IF AVAILABLE ryc_attribute THEN
      ryc_attribute.attribute_obj ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentProductModule Procedure 
FUNCTION getCurrentProductModule RETURNS CHARACTER
  ( /* */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the current product module for the AppBuilder.
    Notes:  See function productModuleList for details on the value.
------------------------------------------------------------------------------*/

  RETURN gCurrentProductModule.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkNames Procedure 
FUNCTION getLinkNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cList AS CHARACTER NO-UNDO.
cList = "":U.
FOR EACH ryc_smartlink_type
         NO-LOCK:
    cList = IF cList EQ "":U THEN link_name
            ELSE cList + ",":U + link_name.
END.

RETURN cList.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkTypeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkTypeObj Procedure 
FUNCTION linkTypeObj RETURNS DECIMAL
  ( INPUT pcSmartLinkType AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Object ID of a SmartLinkType given the name as INPUT
  Returns:  SmartLinkType obj id (decimal)
------------------------------------------------------------------------------*/

  FIND ryc_smartlink_type WHERE ryc_smartlink_type.link_name = 
      pcSmartLinkType NO-LOCK NO-ERROR.
  RETURN IF AVAILABLE ryc_smartlink_type THEN
      ryc_smartlink_type.smartlink_type_obj ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectAlreadyExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ObjectAlreadyExists Procedure 
FUNCTION ObjectAlreadyExists RETURNS LOGICAL
    ( INPUT pcObjectFilename        AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whetehr an object with the specified filename already exists
            in the Repository.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE BUFFER rycso         FOR ryc_smartObject.

    RETURN CAN-FIND(rycso WHERE rycso.object_filename = pcObjectFilename).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectTypeCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ObjectTypeCode Procedure 
FUNCTION ObjectTypeCode RETURNS CHARACTER
  ( INPUT pObjectTypeObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Given an object type obj, return the object type code.
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE cObjectTypeCode AS CHARACTER  NO-UNDO.

DO ON STOP UNDO, LEAVE:
    FIND gsc_object_type WHERE gsc_object_type.object_type_obj = pObjectTypeObj
        NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object_type THEN
        ASSIGN cObjectTypeCode = gsc_object_type.object_type_code.
    ELSE
        ASSIGN cObjectTypeCode = ?.

    RETURN cObjectTypeCode.
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ObjectTypeObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ObjectTypeObj Procedure 
FUNCTION ObjectTypeObj RETURNS DECIMAL
  ( INPUT pcObjectType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


  FIND gsc_object_type WHERE gsc_object_type.OBJECT_type_code = 
      pcObjectType NO-LOCK NO-ERROR.
  RETURN IF AVAILABLE gsc_object_type THEN
      gsc_object_type.object_type_obj ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openRyObjectAB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openRyObjectAB Procedure 
FUNCTION openRyObjectAB RETURNS LOGICAL
  ( INPUT pObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates an "OPEN" _RyObject record for the AppBuilder to use in
            opening a repository object for editing.
    Notes:  IZ 2342
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cError    AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE hRyObject AS HANDLE         NO-UNDO.
    
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY:
        IF NOT RETRY THEN
        DO:
            RUN ry/obj/ryobjectab.w PERSISTENT SET hRyObject.
            RUN getRyObject IN hRyObject
                (INPUT-OUTPUT pObjectName, OUTPUT cError).
        END.
        ELSE
        DO:
            ASSIGN cError = "Cannot open requested object.".
        END.
    END.

    RETURN (cError = "").   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-productModuleList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION productModuleList Procedure 
FUNCTION productModuleList RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns list of Product Module Codes and their Descriptions for use
            in Product Module combo-boxes. IZ 3195.
    Notes:  String returned is a comma-delimited list of code/description items
            of the form " pm_code // pm_description". The DispRepos General
            setting to show or not show Repository Modules is automatically
            applied.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPMList               AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE lDisplayRepository    AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE rRowid                AS ROWID                        NO-UNDO.
    DEFINE VARIABLE cProfileData          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPMDesc               AS CHARACTER                    NO-UNDO.
    
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN lDisplayRepository = (cProfileData EQ "YES":U).
    FOR EACH gsc_product_module NO-LOCK:
        /* Display Repository-owned product modules only if the relevant flag is set.
         * Checking for these based on the code is a temporary measure.              */
        IF NOT lDisplayRepository AND
           ( gsc_product_module.product_module_code BEGINS "RY":U  OR
             gsc_product_module.product_module_code BEGINS "RV":U  OR
             gsc_product_module.product_module_code BEGINS "ICF":U OR
             gsc_product_module.product_module_code BEGINS "AF":U  OR
             gsc_product_module.product_module_code BEGINS "GS":U  OR
             gsc_product_module.product_module_code BEGINS "AS":U  OR
             gsc_product_module.product_module_code BEGINS "RTB":U   ) THEN
            NEXT.
    
        ASSIGN cPMDesc = (IF gsc_product_module.product_module_description <> ?
                          THEN gsc_product_module.product_module_description
                          ELSE "") NO-ERROR.
                          
        ASSIGN cPMList = cPMList + (IF cPMList EQ "":U THEN "":U ELSE ",":U)
                         + gsc_product_module.product_module_code + ' // ':U + cPMDesc NO-ERROR.
    END.    /* each product module */
    
    RETURN cPMList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-productModuleNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION productModuleNames Procedure 
FUNCTION productModuleNames RETURNS CHARACTER
    ( INPUT plDisplayRepository     AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cObjectNames        AS CHARACTER                    NO-UNDO.

    FOR EACH gsc_product_module NO-LOCK:
        /* Display Repository-owned product modules only if the relevant flag is set.
         * Checking for these based on the code is a temporary measure.              */
        IF NOT plDisplayRepository AND
           ( gsc_product_module.product_module_code BEGINS "RY":U  OR
             gsc_product_module.product_module_code BEGINS "RV":U  OR
             gsc_product_module.product_module_code BEGINS "ICF":U OR
             gsc_product_module.product_module_code BEGINS "AF":U  OR
             gsc_product_module.product_module_code BEGINS "GS":U  OR
             gsc_product_module.product_module_code BEGINS "AS":U  OR
             gsc_product_module.product_module_code BEGINS "RTB":U   ) THEN
            NEXT.

        ASSIGN cObjectNames = cObjectNames + (IF cObjectNames EQ "":U THEN "":U ELSE ",":U)
                            + gsc_product_module.product_module_code.
    END.    /* each produt module */

    RETURN cObjectNames.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentProductModule Procedure 
FUNCTION setCurrentProductModule RETURNS CHARACTER
  ( INPUT pm AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the current product module for the AppBuilder.
    Notes:  See function productModuleList for details on the value.
------------------------------------------------------------------------------*/
  
    ASSIGN gCurrentProductModule = pm.

    RETURN gCurrentProductModule.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-smartObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION smartObjectNames Procedure 
FUNCTION smartObjectNames RETURNS CHARACTER
  ( INPUT pcPartialName AS CHARACTER,
    INPUT pcType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of matching names for a possible partial SmartObject 
            name. The main purpose is to allow auto-completion for the window-
            builder tool and others like it, pending availability of the other
            dynamic components to enable a fully dynamic layout window to be built.
   Returns: CHARACTER -- a list of SmartObjects that BEGIN with what was passed in;
            blank ("") if none, or the one matching value if there is one,
            or a comma-separated list of values if there's more than one.
    Notes:  The is really intended as a stop-gap until the modified dynamic lookup,
            dynamic viewer, etc. are available.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cObjectNames AS CHARACTER  NO-UNDO.

  FOR EACH ryc_smartobject WHERE ryc_smartobject.OBJECT_filename BEGINS pcPartialName
           NO-LOCK :
     FIND gsc_object_type WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj NO-LOCK NO-ERROR.
     IF AVAILABLE gsc_object_type THEN
         IF gsc_object_type.OBJECT_type_code = pcType THEN
           cObjectNames = cObjectNames + (IF cObjectNames = "":U THEN "":U ELSE ",":U) +
             ryc_smartobject.OBJECT_filename.
  END.
  RETURN cObjectNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-smartobjectObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION smartobjectObj Procedure 
FUNCTION smartobjectObj RETURNS DECIMAL

      ( INPUT pcSmartObjectName AS CHARACTER) :
    /*------------------------------------------------------------------------------
      Purpose:  Returns the Object ID of a SmartObject given the name as INPUT
      Returns:  SmartObject obj id (decimal)
    ------------------------------------------------------------------------------*/

      FIND ryc_smartobject WHERE ryc_smartobject.OBJECT_filename = 
          pcSmartObjectName NO-LOCK NO-ERROR.
      RETURN IF AVAILABLE ryc_smartobject THEN
          ryc_smartobject.smartobject_obj ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-staticObjectTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION staticObjectTypes Procedure 
FUNCTION staticObjectTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE clist AS CHARACTER NO-UNDO.

ASSIGN clist = "":U.
FOR EACH icfdb.gsc_object_type
      WHERE icfdb.gsc_object_type.object_type_code BEGINS "static":U
      OR icfdb.gsc_object_type.object_type_code BEGINS "SDO":U NO-LOCK:

        clist = clist + 
            (IF clist = "":U THEN "":U ELSE ",":U) +
            gsc_object_type.OBJECT_type_code.
         
END.
  RETURN cList.
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-templateObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION templateObjectName Procedure 
FUNCTION templateObjectName RETURNS CHARACTER
  ( INPUT pcObjectType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes an object type and locates the template smartobject record for
            that type, returning its name.
   Params:  INPUT pcObjectType -- this must be an object_type_code in 
            gsc_object_type.
    Notes:  This function is used for example in the layout template builder, to
            take the name of a generic placeholder object type and furnish the 
            name of the dummy template object of that type to pass to 
            updateObjectInstance.
------------------------------------------------------------------------------*/

  FIND gsc_object_type WHERE 
      gsc_object_type.Object_type_code = pcObjectType 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gsc_object_type THEN
      RETURN "":U.
  FIND FIRST ryc_smartobject WHERE      /* Note: Should only be one of these */
      ryc_smartobject.object_type_obj = gsc_object_type.Object_type_obj AND
      ryc_smartobject.template_smartobject 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
      RETURN "":U.

  RETURN ryc_smartobject.Object_filename.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

