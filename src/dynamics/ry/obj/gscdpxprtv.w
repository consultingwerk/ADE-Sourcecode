&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscdpxprtv.w

  Description:  Deployment Package Import/ExportView

  Purpose:      Deployment Package Import/ExportView

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/21/2001  Author:     

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscdpxprtv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource           AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gcAction                    AS CHARACTER                NO-UNDO.

DEFINE TEMP-TABLE ttPackageDeployment   NO-UNDO         RCODE-INFORMATION
    FIELD tFullPackageFileName          AS CHARACTER
    FIELD tPackageCode                  AS CHARACTER
    FIELD tPackageObj                   AS DECIMAL
    FIELD tOriginatingSite              AS INTEGER
    FIELD tDeploymentNumber             AS INTEGER
    FIELD tDeploymentDescription        AS CHARACTER
    FIELD tLoadAfterDeployment          AS DECIMAL
    FIELD tBaselineDeployment           AS LOGICAL
    FIELD tManualRecordSelected         AS LOGICAL
    FIELD tClearModifiedStatus          AS LOGICAL
    FIELD tIncludeDeletedRecords        AS LOGICAL
    FIELD tOverwriteAllData             AS LOGICAL
    FIELD tErrorFileName                AS CHARACTER
    FIELD tBasePath                     AS CHARACTER
    .

DEFINE TEMP-TABLE ttDeployDataSet       NO-UNDO         RCODE-INFORMATION
    FIELD dataset_code          LIKE gsc_deploy_dataset.dataset_code
    FIELD dataset_description   LIKE gsc_deploy_dataset.dataset_description FORMAT "X(30)"
    FIELD source_code_data      LIKE gsc_deploy_dataset.source_code_data COLUMN-LABEL "Source!Code"
    FIELD deploy_full_data      LIKE gsc_deploy_dataset.deploy_full_data COLUMN-LABEL "Deploy!Full Data"
    FIELD lInclude              AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include"
    FIELD lClearDMS             AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Clear Data!Modified"
    FIELD lIncludeDeleted       AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include!Deleted"
    FIELD lOverwrite            AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Overwrite!Existing"
    FIELD lFilePerRecord        AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "File Per!Record"
    FIELD default_ado_filename  LIKE gsc_deploy_dataset.default_ado_filename FORMAT "X(30)":U COLUMN-LABEL "File name"    
    INDEX pudx IS UNIQUE PRIMARY
        dataset_code
    .

DEFINE TEMP-TABLE ttDataSetEntity       NO-UNDO         RCODE-INFORMATION
    FIELD entity_sequence        LIKE gsc_dataset_entity.entity_sequence
    FIELD entity_mnemonic        LIKE gsc_dataset_entity.entity_mnemonic
    FIELD cTableName             AS CHARACTER FORMAT "X(30)" COLUMN-LABEL "Table Name"
    FIELD delete_related_records LIKE gsc_dataset_entity.delete_related_records COLUMN-LABEL "Delete!Related"
    FIELD overwrite_records      LIKE gsc_dataset_entity.overwrite_records      COLUMN-LABEL "Overwrite"
    FIELD keep_own_site_data     LIKE gsc_dataset_entity.keep_own_site_data     COLUMN-LABEL "Keep Own!Site Data"
    FIELD deploy_full_data       LIKE gsc_deploy_dataset.deploy_full_data       COLUMN-LABEL "Deploy!Full Data"
    FIELD lInclude               AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include"
    FIELD lClearDMS              AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Clear Data!Modified"
    FIELD lIncludeDeleted        AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include!Deleted"
    FIELD dataset_code           LIKE gsc_deploy_dataset.dataset_code
    INDEX pudx IS UNIQUE PRIMARY
        dataset_code
        entity_sequence
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buOpen buCreate fiPackageObj ~
fiDeploymentNumber fiLabelDescription edDeploymentDescription ~
toBaselineDeployment toManualRecordSelection toClearModifiedStatus ~
toIncludeDeletedRecords toOverwriteAllRecords fiPackageFile fiErrorFile ~
buOpenFolder fiBasePath 
&Scoped-Define DISPLAYED-OBJECTS fiFullPackageFile fiPackageDescription ~
fiOriginatingSite fiDeploymentNumber fiDateCreated fiTimeCreated ~
fiLabelDescription edDeploymentDescription toBaselineDeployment ~
toManualRecordSelection toClearModifiedStatus toIncludeDeletedRecords ~
toOverwriteAllRecords fiPackageFile fiErrorFile fiBasePath 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetAction sObject 
FUNCTION GetAction RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetCurrentPackageObj sObject 
FUNCTION GetCurrentPackageObj RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetDirectory sObject 
FUNCTION GetDirectory RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetErrorFileName sObject 
FUNCTION GetErrorFileName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetFullPackageFileName sObject 
FUNCTION GetFullPackageFileName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetNextDeploymentNumber sObject 
FUNCTION GetNextDeploymentNumber RETURNS INTEGER
    ( INPUT pcPackageCode       AS CHARACTER,
      INPUT piSiteNumber        AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetPackageFileName sObject 
FUNCTION GetPackageFileName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hLookupLoadAfter AS HANDLE NO-UNDO.
DEFINE VARIABLE hLookupPackage AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCreate 
     IMAGE-UP FILE "adeicon\new.bmp":U
     LABEL "&Create" 
     SIZE 4.2 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOpen 
     IMAGE-UP FILE "ry/img/afopen.gif":U
     LABEL "&Open..." 
     SIZE 4.2 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOpenFolder 
     LABEL "..." 
     SIZE 4.2 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE edDeploymentDescription AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 73.6 BY 2.67 NO-UNDO.

DEFINE VARIABLE fiBasePath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Base Path" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE fiDateCreated AS DATE FORMAT "99/99/9999":U 
     LABEL "Date Created" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiDeploymentNumber AS INTEGER FORMAT "->>>>>>>9":U INITIAL 0 
     LABEL "Deployment Number" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiErrorFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Error File" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE fiFullPackageFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Package File" 
     VIEW-AS FILL-IN 
     SIZE 65.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabelDescription AS CHARACTER FORMAT "X(5)":U 
     LABEL "Deployment Description" 
     VIEW-AS FILL-IN 
     SIZE 2.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiOriginatingSite AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Originating Site" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiPackageDescription AS CHARACTER FORMAT "X(70)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiPackageFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Package File" 
     VIEW-AS FILL-IN 
     SIZE 26.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiPackageObj AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE fiTimeCreated AS CHARACTER FORMAT "X(256)":U 
     LABEL "Time Created" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE toBaselineDeployment AS LOGICAL INITIAL no 
     LABEL "Baseline Deployment" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.4 BY .81 NO-UNDO.

DEFINE VARIABLE toClearModifiedStatus AS LOGICAL INITIAL no 
     LABEL "Clear Data Modified Status" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.2 BY .81 NO-UNDO.

DEFINE VARIABLE toIncludeDeletedRecords AS LOGICAL INITIAL no 
     LABEL "Include Deleted Records" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.4 BY .81 NO-UNDO.

DEFINE VARIABLE toManualRecordSelection AS LOGICAL INITIAL no 
     LABEL "Manual Record Selection" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE toOverwriteAllRecords AS LOGICAL INITIAL no 
     LABEL "Overwrite All Data (Even If Locally Modified)" 
     VIEW-AS TOGGLE-BOX
     SIZE 54.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buOpen AT ROW 1.05 COL 95.8
     buCreate AT ROW 1.05 COL 100
     fiFullPackageFile AT ROW 1.1 COL 28 COLON-ALIGNED
     fiPackageDescription AT ROW 2.14 COL 53.4 COLON-ALIGNED NO-LABEL
     fiOriginatingSite AT ROW 3.19 COL 28 COLON-ALIGNED
     fiPackageObj AT ROW 3.29 COL 53.8 COLON-ALIGNED NO-LABEL
     fiDeploymentNumber AT ROW 4.19 COL 28 COLON-ALIGNED
     fiDateCreated AT ROW 5.19 COL 28 COLON-ALIGNED
     fiTimeCreated AT ROW 6.24 COL 28 COLON-ALIGNED
     fiLabelDescription AT ROW 7.29 COL 28 COLON-ALIGNED
     edDeploymentDescription AT ROW 7.29 COL 30 NO-LABEL
     toBaselineDeployment AT ROW 11.43 COL 30
     toManualRecordSelection AT ROW 12.33 COL 33.8
     toClearModifiedStatus AT ROW 13.33 COL 30
     toIncludeDeletedRecords AT ROW 14.29 COL 30
     toOverwriteAllRecords AT ROW 15.24 COL 30
     fiPackageFile AT ROW 16.19 COL 28 COLON-ALIGNED
     fiErrorFile AT ROW 17.29 COL 28 COLON-ALIGNED
     buOpenFolder AT ROW 18.24 COL 84.2
     fiBasePath AT ROW 18.33 COL 28 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic,Smart
   Container Links: 
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 18.38
         WIDTH              = 103.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       edDeploymentDescription:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN fiDateCreated IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiDateCreated:PRIVATE-DATA IN FRAME frMain     = 
                "ShowPopup,No".

/* SETTINGS FOR FILL-IN fiFullPackageFile IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiOriginatingSite IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPackageDescription IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPackageObj IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       fiPackageObj:HIDDEN IN FRAME frMain           = TRUE
       fiPackageObj:PRIVATE-DATA IN FRAME frMain     = 
                "ShowPopup,No".

/* SETTINGS FOR FILL-IN fiTimeCreated IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buCreate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCreate sObject
ON CHOOSE OF buCreate IN FRAME frMain /* Create */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN CreateExportFile.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOpen sObject
ON CHOOSE OF buOpen IN FRAME frMain /* Open... */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN GetImportFile.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOpenFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOpenFolder sObject
ON CHOOSE OF buOpenFolder IN FRAME frMain /* ... */
DO:
    DEFINE VARIABLE cFolderName         AS CHARACTER            NO-UNDO.
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN GetFolder ( INPUT "Select the base path for the package dataset import or export.", OUTPUT cFolderName).
    ASSIGN fiBasePath:SCREEN-VALUE = DYNAMIC-FUNCTION("ValidateFileName":U IN ghContainerSource, INPUT cFolderName) NO-ERROR.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPackageFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPackageFile sObject
ON VALUE-CHANGED OF fiPackageFile IN FRAME frMain /* Package File */
, fiBasePath
DO:
    ASSIGN fiFullPackageFile:SCREEN-VALUE = fiBasePath:SCREEN-VALUE + "/":U + fiPackageFile:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toBaselineDeployment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toBaselineDeployment sObject
ON VALUE-CHANGED OF toBaselineDeployment IN FRAME frMain /* Baseline Deployment */
DO:
    IF SELF:CHECKED THEN
        ASSIGN toManualRecordSelection:CHECKED   = NO
               toManualRecordSelection:SENSITIVE = NO
               .
    ELSE
        ASSIGN toManualRecordSelection:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toManualRecordSelection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toManualRecordSelection sObject
ON VALUE-CHANGED OF toManualRecordSelection IN FRAME frMain /* Manual Record Selection */
DO:
    IF SELF:CHECKED                    AND
       gcAction EQ "EXPORT":U          AND
       VALID-HANDLE(ghContainerSource) THEN
            DYNAMIC-FUNCTION("EnablePagesInFolder":U IN ghContainerSource, INPUT "3":U).
    ELSE
    IF VALID-HANDLE(ghContainerSource) THEN
            DYNAMIC-FUNCTION("DisablePagesInFolder":U IN ghContainerSource, INPUT "3":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_deploy_package.package_codeKeyFieldgsc_deploy_package.deploy_package_objFieldLabelPackageFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_deploy_package NO-LOCKQueryTablesgsc_deploy_packageBrowseFieldsgsc_deploy_package.package_code,gsc_deploy_package.package_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(10),X(70)RowsToBatch200BrowseTitleLookup Deployment PackagesViewerLinkedFieldsgsc_deploy_package.deploy_package_obj,gsc_deploy_package.package_descriptionLinkedFieldDataTypesdecimal,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(70)ViewerLinkedWidgetsfiPackageObj,fiPackageDescriptionColumnLabelsColumnFormatSDFFileNamelookupDeployPackageSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldName<Local-1>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLookupPackage ).
       RUN repositionObject IN hLookupPackage ( 2.14 , 30.00 ) NO-ERROR.
       RUN resizeObject IN hLookupPackage ( 1.00 , 25.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgst_deployment.deployment_numberKeyFieldgst_deployment.deployment_numberFieldLabelLoad afterFieldTooltipPress F4 for LookupKeyFormat->>>>>>>9KeyDatatypeintegerDisplayFormat->>>>>>>9DisplayDatatypeintegerBaseQueryStringFOR EACH gsc_deploy_package
                     NO-LOCK,
                     EACH gst_deployment WHERE
                     gst_deployment.deploy_package_obj = gsc_deploy_package.deploy_package_obj
                     NO-LOCKQueryTablesgsc_deploy_package,gst_deploymentBrowseFieldsgst_deployment.deployment_number,gst_deployment.deployment_description,gst_deployment.deployment_date,gst_deployment.deployment_time,gst_deployment.originating_site_numberBrowseFieldDataTypesinteger,character,date,integer,integerBrowseFieldFormats->>>>>>>9,X(500),99/99/9999,>>>>9,->>>>>>>9RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiDecimal,fiOriginatingSite,fiDeploymentNumberParentFilterQuerygsc_deploy_package.deploy_package_obj = decimal(~'&1~') AND
                     gst_deployment.originating_site_number = integer(~'&2~') AND
                     gst_deployment.deployment_number <= integer(~'&3~')MaintenanceObjectMaintenanceSDOFieldName<Local-2>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLookupLoadAfter ).
       RUN repositionObject IN hLookupLoadAfter ( 10.00 , 30.00 ) NO-ERROR.
       RUN resizeObject IN hLookupLoadAfter ( 1.00 , 25.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hLookupPackage ,
             fiFullPackageFile:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hLookupLoadAfter ,
             edDeploymentDescription:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateExportFile sObject 
PROCEDURE CreateExportFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iSiteNumber             AS INTEGER                  NO-UNDO.

    RUN SetViewerState (INPUT "Export":U).

    RUN GetSiteNumber IN gshGenManager ( OUTPUT iSiteNumber ).

    ASSIGN fiOriginatingSite:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(iSiteNumber)
           FILE-INFO:FILE-NAME                                   = ".":U
           fiBasePath:SCREEN-VALUE                               = REPLACE(FILE-INFO:FULL-PATHNAME, "~\":U, "/":U)
           toClearModifiedStatus:CHECKED                         = (iSiteNumber EQ 90)
           NO-ERROR.
    APPLY "VALUE-CHANGED":U TO fiBasePath IN FRAME {&FRAME-NAME}.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder sObject 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER ipTitle         AS CHARACTER                NO-UNDO.
    DEFINE OUTPUT PARAMETER opPath          AS CHARACTER                NO-UNDO.

    DEFINE VARIABLE lhServer       AS COM-HANDLE                         NO-UNDO.
    DEFINE VARIABLE lhFolder       AS COM-HANDLE                         NO-UNDO.
    DEFINE VARIABLE lhParent       AS COM-HANDLE                         NO-UNDO.
    DEFINE VARIABLE lvFolder       AS CHARACTER                          NO-UNDO.
    DEFINE VARIABLE lvCount        AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE hFrame         AS HANDLE                             NO-UNDO.
    DEFINE VARIABLE hWin           AS HANDLE                             NO-UNDO.

    ASSIGN hFrame = FRAME {&FRAME-NAME}:HANDLE
           hWin   = hFrame:WINDOW
           .
    CREATE 'Shell.Application' lhServer NO-ERROR.

    IF NOT ERROR-STATUS:ERROR THEN
    DO:
        ASSIGN lhFolder = lhServer:BrowseForFolder(hWin:HWND,ipTitle,0).
    
        IF VALID-HANDLE(lhFolder) THEN
        DO:
            ASSIGN lvFolder = lhFolder:Title
                   lhParent = lhFolder:ParentFolder
                   lvCount  = 0
                   .
            REPEAT:
                IF lvCount >= lhParent:Items:Count THEN
                DO:
                    ASSIGN opPath = "":U.
                    LEAVE.
                END.
                ELSE
                IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                DO:
                    ASSIGN opPath = lhParent:Items:Item(lvCount):Path.
                    LEAVE.
                END.
                ASSIGN lvCount = lvCount + 1.
            END.
        END.
        ELSE
            ASSIGN opPath = "":U. 
            
        RELEASE OBJECT lhParent NO-ERROR.
        RELEASE OBJECT lhFolder NO-ERROR.
        RELEASE OBJECT lhServer NO-ERROR.
        
       ASSIGN lhParent = ?
              lhFolder = ?
              lhServer = ?
              .       
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetImportFile sObject 
PROCEDURE GetImportFile :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves a file to import, and sets this viewer's state.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cImportFileName         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lOK                     AS LOGICAL                  NO-UNDO.
    
    RUN SetViewerState (INPUT "Import":U).

    SYSTEM-DIALOG GET-FILE  cImportFileName
        TITLE "Select Deployment Package File to Import ..."
        FILTERS "Deployment Package Files (*.pdo)" "*.pdo",
                "Application Data Object Files (*.ado)" "*.ado",
                "XML Files (*.xml)" "*.xml",
                "All Files (*.*)" "*.*"
        MUST-EXIST
        USE-FILENAME
        UPDATE lOK
        .

    IF NOT lOK THEN
    DO:
        RUN SetViewerState ( INPUT "INIT":U).
        RETURN ERROR.
    END.    /* not lOK */

    ASSIGN fiFullPackageFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = REPLACE(cImportFileName, "~\":U, "/":U)
           NO-ERROR.

    /* Get the temp-tables from the import file. */
    /*
    { launch.i
        &PLIP         = 'af/app/gscddxmlp.p'
        &IProc        = 'ProcessPackageFile'
        &PList        = "( INPUT fiFullPackageFile:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                           OUTPUT TABLE ttDeployDataset,
                           OUTPUT TABLE ttDataSetEntity                                )"
        &AutoKill     = YES        
    }
    */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetPackageDeployBuffer sObject 
PROCEDURE GetPackageDeployBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns a temp-table buffer of the package deploy
  Parameters:  phBuffer -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phBuffer            AS HANDLE               NO-UNDO. 

    DO WITH FRAME {&FRAME-NAME}:
        EMPTY TEMP-TABLE ttPackageDeployment.
    
        CREATE ttPackageDeployment.
        ASSIGN ttPackageDeployment.tFullPackageFileName   = fiFullPackageFile:SCREEN-VALUE
               ttPackageDeployment.tPackageCode           = DYNAMIC-FUNCTION("getDataValue":U IN hLookupPackage)
               ttPackageDeployment.tPackageObj            = fiPackageObj:INPUT-VALUE
               ttPackageDeployment.tOriginatingSite       = fiOriginatingSite:INPUT-VALUE
               ttPackageDeployment.tDeploymentNumber      = fiDeploymentNumber:INPUT-VALUE
               ttPackageDeployment.tDeploymentDescription = REPLACE(edDeploymentDescription:SCREEN-VALUE, "~n":U, "":U)
               ttPackageDeployment.tLoadAfterDeployment   = DYNAMIC-FUNCTION("getDataValue":U IN hLookupLoadAfter)
               ttPackageDeployment.tBaselineDeployment    = toBaselineDeployment:CHECKED
               ttPackageDeployment.tManualRecordSelected  = toManualRecordSelection:CHECKED
               ttPackageDeployment.tClearModifiedStatus   = toClearModifiedStatus:CHECKED
               ttPackageDeployment.tIncludeDeletedRecords = toIncludeDeletedRecords:CHECKED
               ttPackageDeployment.tOverwriteAllData      = toOverwriteAllRecords:CHECKED
               ttPackageDeployment.tErrorFileName         = fiErrorFile:SCREEN-VALUE
               ttPackageDeployment.tBasePath              = fiBasePath:SCREEN-VALUE
               phBuffer                                   = BUFFER ttPackageDeployment:HANDLE
               .
    END.    /* with frame ... */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTables sObject 
PROCEDURE GetTables :
/*------------------------------------------------------------------------------
  Purpose:     Returns tables for use by an import process.
  Parameters:  ttDeployDataSet -
               ttDataSetEntity -
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE OUTPUT PARAMETER TABLE FOR ttDeployDataSet.
    DEFINE OUTPUT PARAMETER TABLE FOR ttDataSetEntity.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    {get ContainerSource ghContainerSource}.

    RUN SUPER.

    SUBSCRIBE TO "LookupComplete":U IN THIS-PROCEDURE.

    fiLabelDescription:MOVE-TO-BOTTOM() IN FRAME {&FRAME-NAME}.
    RUN SetViewerState ( INPUT "INIT":U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupComplete sObject 
PROCEDURE LookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Event procedure performed when the lookup fields is left.
  Parameters:  pcFieldList        -
               pcFoundDataValues  -
               pcKeyFieldValue    -
               pcScreenValue      -
               pcSavedScreenValue -
               plBrowseUsed       -
               phLookup           -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcFieldList          AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcFoundDataValues    AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcKeyFieldValue      AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcScreenValue        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcSavedScreenValue   AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plBrowseUsed         AS LOGICAL              NO-UNDO.
    DEFINE INPUT PARAMETER phLookup             AS HANDLE               NO-UNDO.

    IF phLookup EQ hLookupPackage THEN
    DO WITH FRAME {&FRAME-NAME}:
        /* Set the deployment number. */
        ASSIGN fiDeploymentNumber:SCREEN-VALUE = STRING(DYNAMIC-FUNCTION("getNextDeploymentNumber":U,
                                                                         INPUT pcKeyFieldValue,
                                                                         INPUT fiOriginatingSite:INPUT-VALUE)).

        /* Set the default package files */
        IF fiPackageFile:SCREEN-VALUE EQ "":U THEN
        ASSIGN fiPackageFile:SCREEN-VALUE = pcScreenValue + fiDeploymentNumber:SCREEN-VALUE + ".pdo":U
               fiErrorFile:SCREEN-VALUE   = REPLACE(fiPackageFile:SCREEN-VALUE, ".pdo":U, ".edp":U)
               .
        APPLY "VALUE-CHANGED":U TO fiPackageFile IN FRAME {&FRAME-NAME}.
    END.    /* Package */
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetViewerState sObject 
PROCEDURE SetViewerState :
/*------------------------------------------------------------------------------
  Purpose:     Sets the state of the viewer, depending on the action performed.
  Parameters:  pcAction: IMPORT, EXPORT, INIT
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcAction             AS CHARACTER            NO-UNDO.

    ASSIGN gcAction = pcAction.

    /* Disable everything. Then enable selectively. */
    RUN DisableObject.

    /* Manually disable the lookups, since the local SDF were not completely 
     * implemented at the time of writing.                                   */
    RUN DisableField IN hLookupPackage.
    RUN DisableField IN hLookupLoadAfter.

    /* Disable pages 2 and 3. */
    IF VALID-HANDLE(ghContainerSource) THEN
        DYNAMIC-FUNCTION("DisablePagesInFolder":U IN ghContainerSource, INPUT "2,3":U).

    CASE pcAction:
        WHEN "IMPORT":U THEN
        DO WITH FRAME {&FRAME-NAME}:
            IF VALID-HANDLE(ghContainerSource) THEN
                DYNAMIC-FUNCTION("EnablePagesInFolder":U IN ghContainerSource, INPUT "2":U).
            ASSIGN toClearModifiedStatus:SENSITIVE   = YES
                   toIncludeDeletedRecords:SENSITIVE = YES
                   toOverwriteAllRecords:SENSITIVE   = YES
                   .
            
        END.    /*import */
        WHEN "EXPORT":U THEN
        DO:
            IF VALID-HANDLE(ghContainerSource) THEN
                DYNAMIC-FUNCTION("EnablePagesInFolder":U IN ghContainerSource, INPUT "2":U).

            RUN EnableField IN hLookupPackage.
            RUN EnableField IN hLookupLoadAfter.

            ASSIGN edDeploymentDescription:SENSITIVE = YES
                   toBaselineDeployment:SENSITIVE    = YES
                   toManualRecordSelection:SENSITIVE = YES
                   fiPackageFile:SENSITIVE           = YES
                   fiErrorFile:SENSITIVE             = YES
                   fiBasePath:SENSITIVE              = YES
                   toClearModifiedStatus:SENSITIVE   = YES
                   toIncludeDeletedRecords:SENSITIVE = YES
                   toOverwriteAllRecords:SENSITIVE   = YES
                   buOpenFolder:SENSITIVE            = YES
                   .            
        END.    /* export */
        WHEN "INIT":U THEN
        DO WITH FRAME {&FRAME-NAME}:        
            ASSIGN buOpen:SENSITIVE   = YES
                   buCreate:SENSITIVE = YES
                   .
        END.    /* INIT */
    END CASE.   /* ACTION */

    IF VALID-HANDLE(ghContainerSource) THEN
        DYNAMIC-FUNCTION("SetAction":U IN ghContainerSource, INPUT pcAction).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetAction sObject 
FUNCTION GetAction RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current action to a caller.
    Notes:  * IMPORt, EXPORT, INIT
------------------------------------------------------------------------------*/
    RETURN gcAction.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetCurrentPackageObj sObject 
FUNCTION GetCurrentPackageObj RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object number of the current package.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiPackageObj:INPUT-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetDirectory sObject 
FUNCTION GetDirectory RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the base path to a caller.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiBasePath:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetErrorFileName sObject 
FUNCTION GetErrorFileName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the error file name to a caller.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiErrorFile:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetFullPackageFileName sObject 
FUNCTION GetFullPackageFileName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the package file name to a caller.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiFullPackageFile:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetNextDeploymentNumber sObject 
FUNCTION GetNextDeploymentNumber RETURNS INTEGER
    ( INPUT pcPackageCode       AS CHARACTER,
      INPUT piSiteNumber        AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the next available deployment number for a deploy package  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iDeploymentNumber           AS INTEGER              NO-UNDO.

    DEFINE BUFFER gsc_deploy_package        FOR gsc_deploy_package.
    DEFINE BUFFER gst_deployment            FOR gst_deployment.

    FOR EACH gsc_deploy_package WHERE
             gsc_deploy_package.package_code = pcPackageCode
             NO-LOCK,
        EACH gst_deployment WHERE
             gst_deployment.deploy_package_obj      = gsc_deploy_package.deploy_package_obj AND
             gst_deployment.originating_site_number = piSiteNumber
             NO-LOCK
             BY gst_deployment.deployment_number DESCENDING:
        ASSIGN iDeploymentNumber = gst_deployment.deployment_number.
        LEAVE.
    END.  /* each package deploy. */

    RETURN (iDeploymentNumber + 1).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetPackageFileName sObject 
FUNCTION GetPackageFileName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the package file name to a caller.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiPackageFile:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

