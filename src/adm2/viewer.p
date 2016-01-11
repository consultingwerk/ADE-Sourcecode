&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : viewer.p
    Purpose     : Super procedure for PDO SmartViewer objects

    Syntax      : adm2/viewer.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell viewattr.i that this is the Super procedure. */
   &SCOP ADMSuper viewer.p

  {src/adm2/custom/viewerexclcustom.i}
  
  /* Combo temp-table */
  {src/adm2/ttcombo.i}

  /* Lookup temp-table */
  {src/adm2/ttlookup.i}
  /* Dynamic Combo temp-table */
  {src/adm2/ttdcombo.i}
  
  /* NOTE: IN 9.1B beta, this is needed to provide SBO routines
     with the proper calling procedure. */
  DEFINE VARIABLE ghTargetProcedure AS HANDLE NO-UNDO.
  DEFINE VARIABLE glUseNewAPI       AS LOGICAL    NO-UNDO.

  /* Create copies of the lookup and combo temp tables */
  DEFINE TEMP-TABLE ttLookupCopy LIKE ttLookup.
  DEFINE TEMP-TABLE ttDComboCopy LIKE ttDCombo.

  /* Global handle for SDF Cacghe Manager */
  DEFINE VARIABLE ghSDFCacheManager   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE glIsDynamicsRunning AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-firstVisibleInGroup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstVisibleInGroup Procedure 
FUNCTION firstVisibleInGroup RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataFieldMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataFieldMapping Procedure 
FUNCTION getDataFieldMapping RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeepChildPositions Procedure 
FUNCTION getKeepChildPositions RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowPopup Procedure 
FUNCTION getShowPopup RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeepChildPositions Procedure 
FUNCTION setKeepChildPositions RETURNS LOGICAL
        ( INPUT plKeepChildPositions AS LOGICAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowPopup Procedure 
FUNCTION setShowPopup RETURNS LOGICAL
        ( input plShowPopup    as logical ) FORWARD.

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
         HEIGHT             = 17.91
         WIDTH              = 56.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  /* Clear out lookup/combo query temp-table */
  EMPTY TEMP-TABLE ttLookup.   
  EMPTY TEMP-TABLE ttDCombo.

  glIsDynamicsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN TARGET-PROCEDURE) = YES NO-ERROR.

  glUseNewAPI = YES.
  IF glIsDynamicsRunning THEN
    glUseNewAPI = NOT (DYNAMIC-FUNCTION('getSessionParam':U IN TARGET-PROCEDURE,
                                        'keep_old_field_api':U) = 'YES':U).

  /* Get handle to SDF Cache Manager */
  IF glUseNewAPI THEN
  DO:
    ghSDFCacheManager = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(ghSDFCacheManager) AND 
      NOT INDEX(REPLACE(ghSDFCacheManager:FILE-NAME, "~\", "/"), "adm2/lookupfield.":U) > 0:
      ghSDFCacheManager = ghSDFCacheManager:NEXT-SIBLING.
    END.
    IF NOT VALID-HANDLE(ghSDFCacheManager) THEN
      RUN adm2/lookupfield.p PERSISTENT SET ghSDFCacheManager.
  END.
  ELSE IF glIsDynamicsRunning THEN
    ghSDFCacheManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "SDFCacheManager":U) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Gets initial values, enables fields, and allows entry of
               values for a new record.     
  Parameters:  <none>
  Notes:       addRow creates the RowObject temp-table record  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hUpdateTarget      AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTarget            AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cFields            AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cColValues         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hGaSource          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cUpdateNames       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLargeColumns      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cColumn            AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iField             AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iPos               AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lNoQual            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cSourceNames       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hFocus             AS HANDLE     NO-UNDO.

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
            /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           
      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
        /* READ  (Progress' implicit focus setting and the browser's implicit 
                  reposition is problematic ):
        This apply is important (used to be at end of this procedure.) 
        - An addRow causes child-sdo viewers to disable. 
        - If the child had focus the disabling will force focus somewhere else. 
        - If somewhere else is a browser of the same SDO then Progress will 
          do an implicit reposition.. during the add process.  
        Although the viewer is protected against the SDO not pointing to the new 
        row, other logic may fail. A known case was bug 00005931-000 where 
        updateQueryPosition would publish wrong state due to availability 
        and Add became enabled on child toolbars */
        RUN applyEntry IN TARGET-PROCEDURE (?).
        /* applying here causes highlighting to be lost during the process,
           so we deal with this at the end  */
        hFocus = FOCUS.
      
        /* 'getUpdateTargetNames' is overriden to include the UpdateTargetNames */
        /* of all GA-related components. Here we *only* want the value of */
        /* THIS (TARGET-PROCEDURE) object. This really should be implemented */
        /* as 2 different properties... */
        &SCOPED-DEFINE xpUpdateTargetNames
        {get UpdateTargetNames cUpdateNames}.
        &UNDEFINE xpUpdateTargetNames
        
        {get DisplayedFields cFields}.
        IF cUpdateNames > "" AND NUM-ENTRIES(cUpdateNames) = 1 THEN
        DO iField = 1 TO NUM-ENTRIES(cFields):
          IF index(entry(iField,cFields), '.':U) = 0 THEN
            entry(iField,cFields) = cUpdateNames + '.':U + entry(iField,cFields) .
        END.
        
        /* addRow cannot return LargeColumns so replace the name with SKIP */
        {get LargeColumns cLargeColumns hUpdateTarget}.  
        lNoQual = INDEX(cFields,'.':U) = 0.
        IF lNoQual THEN
          {get DataSourceNames cSourceNames} NO-ERROR.   
        DO iField = 1 TO NUM-ENTRIES(cLargeColumns):
          ASSIGN
            cColumn = ENTRY(iField,cLargeColumns)
            iPos    = LOOKUP(cColumn,cFields).  
          IF NUM-ENTRIES(cColumn,".":U) > 1 
          AND iPos = 0 
          AND lNoQual 
          AND NUM-ENTRIES(cSourceNames) = 1 
          AND ENTRY(1,cColumn,".":U) = cSourceNames THEN
            iPos = LOOKUP(ENTRY(2,cColumn,".":U),cFields).  
          IF iPos > 0 THEN
            ENTRY(iPos,cFields) = 'SKIP':U.
        END.
        ghTargetProcedure = TARGET-PROCEDURE.
        cColValues = DYNAMIC-FUNCTION("addRow":U IN hUpdateTarget, cFields). 
        ghTargetProcedure = ?.
        RUN displayFields IN TARGET-PROCEDURE(cColValues). 
      END.
      ELSE DO:
        {get GroupAssignSource hGaSource}.
        IF VALID-HANDLE(hGaSource) THEN
           RUN DisplayRecord IN TARGET-PROCEDURE. 
      END.
      
      PUBLISH 'addRecord':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
      
      /* For dynamic combos who are a parent to another dynamic combo
         we need to force a valueChange to ensure that the child combos
         are refreshed */
      IF glUseNewApi = FALSE THEN  
      FOR EACH  ttDCombo
          WHERE ttDCombo.hViewer = TARGET-PROCEDURE
          NO-LOCK:
        RUN valueChanged IN ttDCombo.hWidget.
      END.
      
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').
  
      /* We've moved the apply entry before the call to addrow. 
         (see above)          
         This causes the highlight to disappear, so use set-selection 
         to achieve old behavior. (another applyEntry call would cause 
         entry triggers firing twice, which may not be appreciated..) 
         NOTE: hFocus is only set if updatesource and points to a widget 
         in first visible object in ga-link */  
      IF VALID-HANDLE(hFocus) 
      AND FOCUS = hFocus  /* Only if same as applied above */ 
      AND FOCUS:SENSITIVE /* avoid non-sensitive read-only=false widgets..*/ 
      AND CAN-QUERY(hFocus,'SET-SELECTION':U) 
      AND CAN-QUERY(hFocus,'SCREEN-VALUE':U) 
      AND LENGTH(hFocus:SCREEN-VALUE) >= 1 THEN 
        hFocus:SET-SELECTION(1,LENGTH(hFocus:SCREEN-VALUE) + 1).

      RETURN.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry Procedure 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
   Purpose:  Applies "ENTRY" to the first enabled and visible object 
Parameters:  INPUT pcField AS CHARACTER -- optional fieldname; if specified,
             (if this parameter is not blank or unknown), then
             the frame field of that name will be positioned to. 
     Notes:  Overridden to apply entry to first in groupAssignTarget if 
             this object is hidden and top of GA link and fieldname = ? or ''. 
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcField AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hObject   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hGaSource AS HANDLE     NO-UNDO.

 hObject = TARGET-PROCEDURE. 

 IF pcField = ? OR pcField = '' THEN
 DO:
   {get GroupAssignSource hGaSource}.
   IF NOT VALID-HANDLE(hGaSource) THEN
     hObject = {fn firstVisibleInGroup}.
 END.

 IF hObject = TARGET-PROCEDURE THEN
   RUN SUPER(pcField).

 /* firstvisibleingroup above returns ? if all objects in group is hidden. 
    In which case there is no need to go further since apply 'entry' is ignored
    on hidden widgets. */
 ELSE IF VALID-HANDLE(hObject) THEN
   RUN applyEntry IN hObject (pcField).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDataRequest Procedure 
PROCEDURE buildDataRequest :
/*------------------------------------------------------------------------------
  Purpose:  Receives a request for data request info from a data source and
            republishes it to contained top-only datavieews to collect 
            DataView request info, specifically position info as these contained
            DataViews are expected to be datasources for SDFs.
          - This overrides the container's implementation in order to 
            pass on the viewer entity. 
  Parameters: see data.p version for detailed explanation of parameters
       phOwner        -  
       pcDataSource   - Data source entity name in the case this request is from
                        a data source. 
                        This means that foreignfields need to be collected.
       pcViewerSource - Viewer's data source entity name in the case 
                        this request is passed through a viewer. 
                        This means that this object probably has a link to an 
                        SDF and position info need to be collected. The object
                        may still be a child of another object on the viewer so 
                        foreignfields are also collected. 
                        
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcOwner         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataSource    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcViewerSource  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcRequests       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcBatchSizes     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcContext        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDatasetSources AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntities       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntityNames    AS CHARACTER  NO-UNDO.

  PUBLISH "buildDataRequest":U FROM TARGET-PROCEDURE
                               (INPUT pcOwner,
                                INPUT '',
                                INPUT pcDataSource, /* viewer source */
                                INPUT-OUTPUT pcRequests,                               
                                INPUT-OUTPUT pcDataTables,
                                INPUT-OUTPUT pcQueries,
                                INPUT-OUTPUT pcBatchSizes,
                                INPUT-OUTPUT pcForeignFields,
                                INPUT-OUTPUT pcPositionFields,
                                INPUT-OUTPUT pcContext,
                                INPUT-OUTPUT pcDatasetSources,
                                INPUT-OUTPUT pcEntities,
                                INPUT-OUTPUT pcEntityNames).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cancels the add, copy or update operation for the current row.
  Parameters:  <none>
  Notes:       cancelRecord in datavis.p (invoked by RUN SUPER) actually 
               cancels the update and for an add or copy, deletes the temp-table 
               record.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hGaSource AS HANDLE  NO-UNDO.

  RUN SUPER.  
  IF RETURN-VALUE EQ "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 
  
  PUBLISH 'cancelRecord':U FROM TARGET-PROCEDURE. /* Intended for GroupAssign */
  
  /* apply entry ? will reach first visible Ga target if this is hidden,
     so only call in top gasource */ 
  {get GroupAssignSource hGaSource}.
  IF NOT VALID-HANDLE(hGaSource) THEN
    RUN applyEntry IN TARGET-PROCEDURE (?).  

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Copy a row    
  Parameters:  <none>
  Notes:       copyRow creates the RowObject temp-table record  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFields            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cColValues         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hGaSource          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cUpdateNames       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLargeColumns      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cColumn            AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iField             AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iPos               AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lNoQual            AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE cSourceNames       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE hFocus             AS HANDLE      NO-UNDO.

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
     
      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           
      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
        /* See comment in the similar addRow about this */      
        RUN applyEntry IN TARGET-PROCEDURE (?).
        /* applying here causes highlighting to be lost during the process,
           so we deal with this at the end  */
        hFocus = FOCUS.

        &SCOPED-DEFINE xpUpdateTargetNames
        {get UpdateTargetNames cUpdateNames}.
        &UNDEFINE xpUpdateTargetNames
        
        {get DisplayedFields cFields}.
        IF NUM-ENTRIES(cUpdateNames) = 1 THEN 
        DO iField = 1 TO NUM-ENTRIES(cFields):
          IF index(entry(iField,cFields), '.':U) = 0 THEN
             entry(iField,cFields) = cUpdateNames + '.':U + entry(iField,cFields) .
        END.
        
        /* copyRow cannot return LargeColumns so replace the name with SKIP */
       {get LargeColumns cLargeColumns hUpdateTarget}.
       lNoQual = INDEX(cFields,'.':U) = 0.
       IF lNoQual THEN
         {get DataSourceNames cSourceNames} NO-ERROR.   
       DO iField = 1 TO NUM-ENTRIES(cLargeColumns):
         ASSIGN
           cColumn = ENTRY(iField,cLargeColumns)
           iPos    = LOOKUP(cColumn,cFields).  
         IF NUM-ENTRIES(cColumn,".":U) > 1 
         AND iPos = 0 
         AND lNoQual 
         AND NUM-ENTRIES(cSourceNames) = 1 
         AND ENTRY(1,cColumn,".":U) = cSourceNames THEN
           iPos = LOOKUP(ENTRY(2,cColumn,".":U),cFields).  
         IF iPos > 0 THEN
           ENTRY(iPos,cFields) = 'SKIP':U.
       END.

        ghTargetProcedure = TARGET-PROCEDURE.
        cColValues = DYNAMIC-FUNCTION("copyRow":U IN hUpdateTarget, cFields). 
        IF cColValues = ? THEN
        DO:
          {set NewRecord "NO"}.
          {fn showDataMessages}.
          RETURN "ADM-ERROR":U.
        END.

        ghTargetProcedure = ?.
        RUN displayFields IN TARGET-PROCEDURE(cColValues). 
      END.
      ELSE DO:
        {get GroupAssignSource hGaSource}.
        IF VALID-HANDLE(hGaSource) THEN
           RUN DisplayRecord IN TARGET-PROCEDURE. 
      END.
      
      PUBLISH 'copyRecord':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
      
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').
      
      /* We've moved the apply entry before the call to addrow. 
         (see above)          
         This causes the highlight to disappear, so use set-selection 
         to achieve old behavior. (another applyEntry call would cause 
         entry triggers firing twice, which may not be appreciated..) 
         NOTE: hFocus is only set if updatesource and points to a widget 
         in first visible object in ga-link */  
      IF VALID-HANDLE(hFocus) 
      AND FOCUS = hFocus  /* Only if same as applied above */ 
      AND FOCUS:SENSITIVE /* avoid non-sensitive read-only=false widgets..*/ 
      AND CAN-QUERY(hFocus,'SET-SELECTION':U) 
      AND CAN-QUERY(hFocus,'SCREEN-VALUE':U) 
      AND LENGTH(hFocus:SCREEN-VALUE) >= 1 THEN 
        hFocus:SET-SELECTION(1,LENGTH(hFocus:SCREEN-VALUE) + 1).
      
    RETURN.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Build list properties for contained objects/widgets
  Parameters:  <none>
  Notes:       Calls createDataSource in SDFs if necessary.
------------------------------------------------------------------------------*/   
  DEFINE VARIABLE hFrame             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargets           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetFrames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFrame             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledHandles    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjHdls    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLookup            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateTargetSet   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDFDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDFDataSourceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDisplay           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lEnable            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLocal             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iDisplay           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnable            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLocal             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChildFrame        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataFieldMapping  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iMap               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSourceType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO               AS LOGICAL    NO-UNDO.

  RUN SUPER.
                                          
  {get AllFieldHandles cAllFieldhandles}.
    
  IF cAllFieldHandles = '' THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataSource hDataSource}
    {get ContainerTarget cTargets}
    {get DisplayedFields cDisplayedFields}
    {get EnabledObjFlds cEnabledObjFlds}
    {get EnabledFields cEnabledFields}
    {get ContainerHandle hFrame}
    {get DataFieldMapping cDataFieldMapping}
     .
    &UNDEFINE xp-assign
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get ObjectType cSourceType hDataSource}.
      lSBO = (cSourceType = 'SmartBusinessObject':U).

      /*  If SBO call addTarget 
          (it will set the mapping between the objects and most importantly 
           set UpdateTargetNames and DataSourcenames if not defined) */
      IF lSBO THEN
      DO:
        RUN addDataTarget IN hDataSource (TARGET-PROCEDURE). 
        IF RETURN-VALUE = 'adm-error':U THEN
          RETURN.
        &SCOPED-DEFINE xp-assign
        {get DataSourceNames cDataSourceNames}
        {get UpdateTargetNames cUpdateTargetNames}
        .
        &UNDEFINE xp-assign     
      END. /* lSBO */
    END. /* valid(datasource) */
    
    /* Build list of frames and fieldnames for identification in widgetloop */
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):  
      hTarget    = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
      &SCOPED-DEFINE xp-assign 
      {get ContainerHandle hChildFrame hTarget}
      {get ObjectType cObjectType hTarget}
      .
      &UNDEFINE xp-assign 
      IF cObjectType = 'SmartDataField':U OR cObjectType = 'SmartLOBField':U THEN
        cTargetFrames = cTargetFrames + ',':U + STRING(hChildFrame). 
      ELSE /* keep list in synch with cTargets
         (blank is avoided as list is trimmed after loop) */
        cTargetFrames = cTargetFrames + ',' + '?'.
  
    END. /* containerTarget loop */
  
    ASSIGN
      cTargetFrames    = LEFT-TRIM(cTargetFrames,',':U)
      cTargetNames     = LEFT-TRIM(cTargetNames,',':U)
      hField           = hFrame:FIRST-CHILD:FIRST-CHILD
      /* The order of the lists of handles must match the order of the 
         DisplayedField and EnabledField properties, so initialise with the 
         current number of entries */
      cEnabledHandles  = FILL(",":U, NUM-ENTRIES(cEnabledFields)   - 1)
      cFieldHandles    = FILL(",":U, NUM-ENTRIES(cDisplayedFields) - 1)
      cEnabledObjHdls  = FILL(",":U, NUM-ENTRIES(cEnabledObjFlds) - 1)
      .

    /* widgetloop */
    DO WHILE VALID-HANDLE(hField): 
      ASSIGN 
        cFieldName  = ''
        cTable      = '' 
        lEnable     = FALSE
        lDisplay    = FALSE
        lLocal      = FALSE.
  
      IF hField:TYPE = 'FRAME':U THEN
      DO:
        iLookup = LOOKUP(STRING(hField),cTargetFrames).
        IF iLookup > 0 THEN
        DO:
          hTarget    = WIDGET-HANDLE(ENTRY(iLookup,cTargets)).
          &SCOPED-DEFINE xp-assign
          {get FieldName  cFieldName hTarget}
          {get DisplayField lDisplay hTarget}
          {get EnableField lEnable hTarget}
          {get LocalField  lLocal hTarget}
          {get DataSource hSDFDataSource hTarget}
           .
          &UNDEFINE xp-assign
          IF NOT VALID-HANDLE(hSDFDataSource) THEN
          DO:
            /*  no-error as Datasourcename is currently not implemented 
                in all SDF classes */         
            cSDFDataSourceName = ''.
            {get DataSourceName cSDFDataSourceName hTarget} NO-ERROR.
            /* if sourcename and no valid source then createdatasource here 
               so that it can be included in the initial datarequest*/
            IF cSDFDataSourceName > '' THEN
              {fn createDataSource hTarget} NO-ERROR.
          END.   /* not valid  hSDFDataSource*/

          IF NUM-ENTRIES(cFieldName,'.') > 1 THEN
            cTable = ENTRY(1,cFieldName,'.').

          IF lLocal then
          DO:
            /* Only add the SDF to the list of enabled objects if it is,
               in fact, meant to be enabled. */           
            if lEnable then
              ASSIGN 
                cEnabledObjFlds = cEnabledObjFlds 
                                + (IF cEnabledObjFlds = '' THEN '' ELSE ',':U) 
                                + cFieldName 
                cEnabledObjHdls = cEnabledObjHdls 
                                + (IF cEnabledObjHdls = '' THEN '' ELSE ',':U) 
                                + STRING(hTarget). 
          END.    /* local sdf */
          ELSE DO:
            IF lDisplay THEN
              ASSIGN 
                cDisplayedFields = cDisplayedFields
                                 + (IF cDisplayedFields = '' THEN '' ELSE ',':U) 
                                 + cFieldName 
                cFieldHandles    = cFieldHandles  
                                 + (IF cFieldHandles = '' THEN '' ELSE ',':U) 
                                 + STRING(hTarget). 
            IF lEnable THEN
            DO:
              /* add to list (unless SBO and not in updateTargetNames) */          
              IF NOT lSBO OR cTable = '' OR LOOKUP(cTable,cUpdateTargetNames) > 0 THEN        
                ASSIGN 
                  cEnabledFields  = cEnabledFields 
                                  + (IF cEnabledFields = '' THEN '' ELSE ',':U) 
                                  + cFieldName 
                  cEnabledHandles = cEnabledHandles 
                                  + (IF cEnabledHandles = '' THEN '' ELSE ',':U) 
                                  + STRING(hTarget). 
            END. /* lenable */
          END.
        END.
      END.    /* FRAME widget (ie SDF) */
      ELSE
      DO:
        IF hField:TYPE = 'EDITOR':U THEN
          ASSIGN
            hField:SENSITIVE = TRUE
            hField:READ-ONLY = TRUE. 
        
        /* Check if widget is mapped to a datafield 
          (currently used for static longchar - datasource clob mapping) */ 
        iMap = LOOKUP(hField:NAME,cDataFieldMapping).
        IF iMap > 0 THEN
          ASSIGN
            cFieldName = ENTRY(iMap + 1,cDataFieldMapping)
            cTable     = ENTRY(1,cFieldName,'.')
            /* important for logic below that removes SBO objects from Enablelist  */
            cTable     = IF cTable = 'RowObject':U THEN '' ELSE cTable
            cFieldName = IF cTable = '':U THEN ENTRY(2,cFieldName,'.')
                                          ELSE cFieldName.
        ELSE 
          ASSIGN
            cTable     = (IF CAN-QUERY(hField,"TABLE":U) AND hField:TABLE <> 'RowObject':U 
                          THEN hField:TABLE 
                          ELSE '')
            cFieldName = IF cTable > ''  
                         THEN cTable + "." + hField:NAME 
                         ELSE hField:NAME. 
     
        ASSIGN
          iDisplay   = LOOKUP(cFieldName, cDisplayedFields)
          iEnable    = LOOKUP(cFieldName, cEnabledFields)
          iLocal     = LOOKUP(cFieldName, cEnabledObjFlds).

        IF iDisplay > 0 THEN
          ENTRY(iDisplay, cFieldHandles) = STRING(hField).
        IF iEnable > 0 THEN
        DO:
          ENTRY(iEnable, cEnabledHandles) = STRING(hField).
          
          /* Remove from enabled lists if table qualified and SBO target,
             but not in updateTargetNames */
          IF lSBO AND cTable > '' AND LOOKUP(cTable,cUpdateTargetNames) = 0 THEN        
            ASSIGN
              cEnabledFields =  DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                 iEnable,cEnabledFields,',')
              cEnabledHandles = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                 iEnable,cEnabledHandles,',').
        END.
        IF iLocal > 0 THEN
        DO:
          IF LOOKUP(hField:TYPE,"FILL-IN,RADIO-SET,EDITOR,COMBO-BOX,SELECTION-LIST,SLIDER,TOGGLE-BOX,BROWSE,BUTTON":U) > 0 THEN 
            ENTRY(iLocal, cEnabledObjHdls) = STRING(hField).
          ELSE
            ASSIGN
              cEnabledObjFlds =  DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                         iLocal,cEnabledObjFlds,',')
              cEnabledObjHdls = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                         iLocal,cEnabledObjHdls,',').
        END.
        hTarget = hField.
      END.

      /* Anonymous widgets are not allowed (labels) */
      IF cFieldName > '' THEN
        ASSIGN
          /* V10 will have qualified names here shortname is for v9 */
          cAllFieldNames   = cAllFieldnames + ',' + cFieldName 
          cAllFieldHandles = cAllFieldHandles + ',' + STRING(hTarget). 
  
      hField = hField:NEXT-SIBLING.
    END. /* do while */   
    
    ASSIGN
      cAllFieldNames     = TRIM(cAllFieldNames,",")
      cAllFieldHandles   = TRIM(cAllFieldHandles,",")
      cUpdateTargetNames = TRIM(cUpdateTargetNames,",")
      cDataSourceNames   = TRIM(cDataSourceNames,",").
   
  /* Store the properties */
    &SCOPED-DEFINE xp-assign
    {set DisplayedFields cDisplayedFields}
    {set FieldHandles cFieldHandles}
    {set EnabledFields cEnabledFields}
    {set EnabledHandles cEnabledHandles}
    {set EnabledObjFlds cEnabledObjFlds}
    {set EnabledObjHdls cEnabledObjHdls}
    {set AllFieldHandles cAllFieldHandles}
    {set AllFieldNames cAllFieldNames}
    {set UpdateTargetNames cUpdateTargetNames}
    {set DataSourceNames cDataSourceNames}
    .
    &UNDEFINE xp-assign
  END.

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Added this override procedure to remove any Dynamic Lookup and
               Dynamic Combo temp-table records for the viewer being destroyed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH  ttDCombo
      WHERE ttDCombo.hViewer = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttDCombo.
  END.

  FOR EACH ttLookup
      WHERE ttLookup.hViewer = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
  DELETE ttLookup.
  END.
  
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Disables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor).
  Parameters:  INPUT pcFieldType AS CHARACTER -- 'All' or 'Create'
  Notes:       At present at least, this takes an argument which may be
               "All" or "Create" to allow, e.g., cancelRecord to disable just
               ADM-CREATE-FIELDS.
               "Create" is currently not supported. 
               When a frame field is a SmartObject itself (for example, a 
               SmartField), disableField is run in the SmartObject to disable
               it.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEnableFields  AS CHARACTER NO-UNDO. /* Field handles. */
  DEFINE VARIABLE cEnableObjects AS CHARACTER NO-UNDO. /* Object handles */
  DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cObjectsToDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized   AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldsEnabled lEnabled}.
  {get ObjectInitialized lInitialized}
  .
  &UNDEFINE xp-assign
 
 /* Bail out if not initialized yet, as the Enabled* properties may not 
    be properly set yet. initializeObject calls this if necessary 
    (SDFs currently add themselves to the lists. There are logic to remove 
    fields from the list for one-to-one SBOs in initializeObject) */
  IF NOT lInitialized THEN 
    RETURN.

  IF lEnabled THEN
  DO:  
      /* CreateFields not yet supported
       IF pcFieldType = "Create":U THEN     /* Disable just Create-only fields */
        {get CreateHandles cEnableFields}.
      ELSE 
      */
      IF pcFieldType = "All":U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get EnabledHandles cEnableFields}
        {get EnabledObjHdls cEnableObjects}
        {get EnabledObjFldsToDisable cObjectsToDisable}.
        &UNDEFINE xp-assign
        /* {get CreateHandles cCreateFields}.
           IF cCreateFields NE "":U THEN
             cEnableFields = cEnableFields + ",":U + cCreateFields.*/
      END. /* pcfieldtype =  'all' */
      
      DO iField = 1 TO NUM-ENTRIES(cEnableFields):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
         /* "Frame Field" May be a SmartObject procedure handle */
         IF hField:TYPE = "PROCEDURE":U THEN
           RUN disableField IN hField NO-ERROR.
         ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
         DO:
           IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
             hField:READ-ONLY = yes.  
           ELSE hField:SENSITIVE = no.     
           DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                             hField, NO).
         END.  /* END DO NOT HIDDEN */
      END.     /* END DO iField     */
      
      /* Disable no db fields */
      IF cObjectsToDisable <> '(none)':U THEN
      DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
         IF hField:TYPE = "PROCEDURE":U THEN 
           cName = {fn getFieldName hField} NO-ERROR.
         ELSE 
           cName = hField:NAME.  
          
         IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
         DO:
           /* "Frame Field" May be a SmartObject procedure handle */
           IF hField:TYPE = "PROCEDURE":U THEN
             RUN disableField IN hField NO-ERROR.
           ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
           DO:
             IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
               hField:READ-ONLY = yes.  
             ELSE hField:SENSITIVE = no.   
             DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                               hField, NO).
           END.  /* END DO NOT HIDDEN */
         END.
      END.     /* END DO iField     */
      
      {set fieldsEnabled no}.
  END.
  
  RUN SUPER(pcFieldType).
   
  /* In case there's a GroupAssign */
  PUBLISH 'disableFields':U FROM TARGET-PROCEDURE (pcFieldType).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFieldList Procedure 
PROCEDURE displayFieldList :
/*------------------------------------------------------------------------------
   Purpose: Display a list of fields from a source and/or from a list of values.       
Parameters:  pcFieldList  - List of fields to display.
             pcFromSource - List of fields that should get their value from 
                            the passed or default datasource .
                            Special values:
                            - Blank = default, read large column values from source
                            - (All) - read all values from source
                            - (None) - don't read any data from source
                            - (Large) - large .. default...
             phDataSource   - Datasource for the fields specified in pcFromSource.
                            ? - use the viewer's datasource for source fields. 
                            passing the viewer's datasource will clear the 
                            fields if no record is available.   
             pcColValues  - Chr(1) separated list of values to display if not 
                            display from source.
                            ? - Clear all fields if datasource not specified.
                            
     Notes:  The passed fields must be in the viewer's displayedFields.
             This could possibly be changed, so this could serve as a generic 
             display also for local fields.
           - setDataValue is not called in SDFs if the passed datasource is 
             different from the source. Interdependencies between SDFs are 
             handled by their datasources, causing valuechange in dependant 
             SDFs, which may end up here on their own .   
           - LOB SDFs are currently not displayed from here if the viewer's 
             datasource is used. (they currently subscribe to dispalyField,
             which is published from displayFields.) 
           - all handle  - disp values from passed source if avail
           - all ?       - disp values from source if avail
           - none handle values - disp values if avail
           - none ? values - disp values 
           - none ? ? - clear values 
           - none handle ?  - clear values            
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldList  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFromSource AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phDataSource AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcColValues  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFieldHandles    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeColumns    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSecPos          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lClear           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lPosition        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSecured         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSourceNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryPosition   AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldHandles cFieldHandles}
  {get DisplayedFields cDisplayedFields}
  {get AllFieldNames cAllFieldNames}
  {get FieldSecurity cSecuredFields}
  {get DataSource hDataSource}
  {get DataSourceNames cDataSourceNames}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(phDataSource) THEN
  DO:
    {get LargeColumns cLargeColumns phDataSource}.
    {get QueryPosition cQueryPosition phDataSource}.
    lClear = cQueryPosition BEGINS 'NoRecordAvail':U. 
    IF phDataSource <> hDataSource THEN
      lPosition = TRUE.
  END.
  ELSE DO:
    ASSIGN
      phDataSource = hDataSource
      lClear       = (pcColValues = ?).
    /* implicit sanity check for logic below to work with no source
       (we only call source if pcFromSource has values) */
    IF NOT VALID-HANDLE(phDataSource) THEN
      pcFromSource = '':U.
  END.

  CASE pcFromSource:
    WHEN '(Large)':U OR WHEN '' OR WHEN ? THEN
      pcFromSource = cLargeColumns.
    WHEN '(All)':U THEN
      pcFromSource = cDisplayedFields.
    WHEN '(None)':U THEN
      pcFromSource = '':U.
  END.
 
  DO iField = 1 TO NUM-ENTRIES(pcFieldList):
    ASSIGN
      cFieldName = ENTRY(iField,pcFieldList)    
      iFieldPos  = LOOKUP(cFieldName,cDisplayedFields)
      /* The field may be a SmartObject procedure handle. */
      hField  = WIDGET-HANDLE(ENTRY(iFieldPos,cFieldHandles))
    .
    /* As of 10.1a01 we don't rely on allfieldnames for the main loop 
      logic due to the fact that the viewer histroically always have used
      displayedFields for display and other logic, so we use a second 
      lookup for security. (allfield* is newer, but reliably synchronized, so  
      this may/can change (see aslo notes)*/
    IF cSecuredFields > '':U THEN
      ASSIGN
        iSecPos  = LOOKUP(cFieldName,cAllFieldNames)
        lSecured = NUM-ENTRIES(cSecuredFields) >= iSecPos 
                   AND ENTRY(iSecPos,cSecuredFields) = "Hidden":U.
    ELSE 
      lSecured = NO.
     
    IF NOT lSecured THEN
    DO:
      IF NOT lClear THEN
      DO: 
        /* Qualify field name if necessary  */
        IF INDEX(pcFromSource,".") > 0 AND INDEX(cFieldName,".") = 0 THEN
          cFieldName = cDataSourceNames + "." + cFieldName.
   
          /* LargeColumns in SDFs handles its data on the displayfield event */
        IF hField:TYPE = 'PROCEDURE':U AND CAN-DO(cLargeColumns,cFieldName) THEN
        DO:

          IF lPosition THEN
            RUN displayField IN hField.         
          NEXT.
        END.

        /**** BEGIN: get value ***/
        /* If not DisplayFromSource get the value from the parameter 
          (This is intentionally done before checks for LargeColumns or longchar
           since we currently support passing data in parameter also to 
           large columns by specifying a list of fields or '(none)' 
           in the DisplayFromSource property... ) */         
        IF NOT CAN-DO(pcFromSource,cFieldName) THEN 
          cValue = RIGHT-TRIM(ENTRY(iField, pcColValues, CHR(1))).
        
        /** else get the value from the SDO... unless this is a longchar widget
            in which case it is assigned directly below.. 
            Note: cDisplayFromSource is set to blank above if no valid-handle
                  so no sanity check is needed here  */        
        ELSE IF hField:TYPE = 'PROCEDURE':U OR hField:DATA-TYPE <> 'LONGCHAR':U THEN
          cValue = {fnarg columnValue cFieldName phDataSource}.        
        ELSE  
          cValue     = '':U. /* cValue is not used when longchar, but just in case... */
        /**** END get value ***/
        /*** BEGIN display value ***/
        IF hField:TYPE = 'PROCEDURE':U THEN 
        DO:
         /* Do not set if position (see notes)
            Also do not set the value for Dynamic Combos 
            - they get data thru publish displayfield in displayfields   */  

          IF NOT lPosition 
          AND LOOKUP("dynamicCombo":U,hField:INTERNAL-ENTRIES) = 0 THEN 
            {set DataValue cValue hField}.
        END.
        ELSE 
        IF hField:DATA-TYPE <> 'LONGCHAR':U 
        /* allow a longchar to also get the value from the parameter
           if not in the list of field to display from source...  
          (It would be in the list if (large) or (all), but if a list of 
           fieldnames is explicitly defined it may not be included. 
           Whether this is a nice feature or a just a problem 
           waiting to happen is debatable............)  */       
        OR NOT CAN-DO(pcFromSource,cFieldName) THEN
        DO:
           /* multiple selection lists appends screen-value, so reset it */
          IF hField:TYPE = "SELECTION-LIST":U AND hField:MULTIPLE THEN
             hField:SCREEN-VALUE = "":U.

          /* A combo with blank in list-items needs screen-value = space */         
          IF hField:TYPE = "COMBO-BOX":U AND cValue = "":U THEN
            cValue = " ":U.
          /* (toggle boxes need special treatment as they do not handle 
             'no' or 'yes' with non-default format)  */
          IF hField:TYPE = "TOGGLE-BOX":U THEN
            hField:SCREEN-VALUE = IF cValue = "yes":U THEN
                                     ENTRY(1,hField:FORMAT,"/":U)
                                  ELSE
                                     ENTRY(2,hField:FORMAT,"/":U)
                                  NO-ERROR.
          ELSE
            hField:SCREEN-VALUE = cValue NO-ERROR.
          
          /* Deal with "Supported" bad behaviors. For various reasons some
             errors have been ignored in old versions of this method. 
             It is necessary to continue to forgive these cases. */ 
          IF ERROR-STATUS:GET-MESSAGE(1) > '' THEN
          DO:
            IF hField:TYPE = 'TOGGLE-BOX':U AND ERROR-STATUS:GET-NUMBER(1) = 4058 
            AND cValue = '?':U THEN
              hField:CHECKED = FALSE.
            ELSE IF hField:TYPE = 'COMBO-BOX':U AND ERROR-STATUS:GET-NUMBER(1) = 4058
            AND cValue = ''  THEN
            DO:
              /*(Blank value in combo do not give error messages due to the need
                 to deal specifically with blank as valid value in the LIST-*. 
                 Customer code may rely on the previous implementation that 
                 also was silent when the LIST- does not have a blank entry) 
               Note that NO behavior is supported for this!! */
            END.
            /* Otherwise keep behavior as if NO-ERROR was not used.. 
               Everyone is better off with explicit error when data cannot be 
               displayed properly.. Silent forgiveness in this area is bad, 
               But as the exceptions above indicates also habit forming and 
               difficult to get rid of..   */  
            ELSE
              MESSAGE  
                ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.
          END.
        END.
        /* if longchar and DisplayFromSource get the longchar from sdo
           Note: cDisplayFromSource is set to blank above if no valid-handle
                 so no sanity check is needed here  */               
        ELSE
          hField:SCREEN-VALUE = {fnarg columnLongCharValue cFieldName phDataSource}.
          /*** END display value ***/
      END.
        /* lClear */
      ELSE DO:
        IF hField:TYPE = 'PROCEDURE':U THEN
          RUN clearField IN hField.

        /* Clear the combo box  */
        ELSE IF hField:TYPE = "COMBO-BOX":U THEN
          {fnarg clearCombo hField}.
       /* logical defaults to no (also radio-sets)
          (toggle boxes need special treatment as they do not handle 
           screen-value = 'no' with non default format)  */
        ELSE IF hField:TYPE = "TOGGLE-BOX":U THEN
          hField:CHECKED = FALSE.
        ELSE IF hField:DATA-TYPE = "LOGICAL":U THEN 
          hField:SCREEN-VALUE = 'NO':U.
        /* radio-set show first button */
        ELSE IF hField:TYPE = "RADIO-SET":U THEN
          hField:SCREEN-VALUE = ENTRY(2,hField:RADIO-BUTTONS) NO-ERROR. 
        ELSE  
          hField:SCREEN-VALUE = "".
      END. /* no data */  
      IF hField:TYPE <> 'PROCEDURE':U THEN
        hField:MODIFIED = NO.  
      ELSE 
       {set DataModified NO hField}.  
    END. /* if not secured and hidden  */     
    ELSE IF hField:TYPE = 'PROCEDURE':U THEN
    DO:
      {set Secured TRUE hField} NO-ERROR.
      RUN hideObject IN hField NO-ERROR.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     "Displays" the current row values by moving them to the frame's
               screen-values.
  Parameters:  INPUT pcColValues AS CHARACTER -- CHR(1) - delimited list of the
               BUFFER-VALUEs of the requested columns; the first entry in the
               list is the RowIdent code.
  Notes:       When a frame field is a SmartObject (for example, a SmartField), 
               setDataValue is invoked in the SmartObject to set its value.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iValue             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowIdent          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldPos          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSecuredEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hGASource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayFromSource AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjFldsToDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRefreshDataFields AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayValues     AS CHARACTER  NO-UNDO.
 
  /* Used for Dynamic Combos */
  DEFINE VARIABLE cWidgetNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetValues AS CHARACTER  NO-UNDO.

  /* Field Security Check */
  DEFINE VARIABLE cAllFieldNames   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.

  /* Used for RowUserProp - Row User Property functions */
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cRowUserProp       AS CHARACTER      NO-UNDO.                                                             
  DEFINE VARIABLE cRowUserPropName   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cQualifier         AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE iPropLoop          AS INTEGER        NO-UNDO.
   
  &SCOPED-DEFINE xp-assign
  {get FieldSecurity cSecuredFields}
  {get GroupAssignSource hGASource}
  {get InternalDisplayFromSource cDisplayFromSource}
  {get DisplayedFields cDisplayedFields}
  .
  &UNDEFINE xp-assign
 
  /* Save off the row number, which is always the first value returned
     and remove it in the parameter to displayfieldList . */
  ASSIGN
    cRowIdent      = ENTRY(1, pcColValues, CHR(1))
    cDisplayValues = IF pcColValues = ? 
                     THEN ?
                          /* add chr(1) at end to avoid error if single value 
                            or blank (not really supported, but did not give
                            an error here before..)*/
                     ELSE SUBSTRING(pcColValues,INDEX(pcColValues + CHR(1),CHR(1)) + 1).
      
  {set RowIdent cRowIdent}.

  RUN displayfieldList IN TARGET-PROCEDURE 
                      (cDisplayedFields,
                       cDisplayFromSource,
                       ?, /* use datasource for data, but not to check 
                             availability. (clear screen if displayValues = ? )*/
                       cDisplayValues).
                        
    /* Handle Autocomments and combo/lookups if using repository  */
  IF {fn getUseRepository} THEN 
  DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) AND NOT VALID-HANDLE(hGASource) THEN 
    DO:
      IF {fnarg instanceOf 'SBO':U hDataSource} THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get DataSourceNames cDataSourceNames}
        {get UpdateTargetNames cUpdateTargetNames}.
        &UNDEFINE xp-assign
        IF NUM-ENTRIES(cDataSourceNames) = 1 THEN
          cQualifier = cDataSourceNames.
        ELSE IF NUM-ENTRIES(cUpdateTargetNames) = 1 THEN
          cQualifier = cUpdateTargetNames.
      END.  /* if datasource is SBO */
      cRowUserPropName = IF cQualifier > '':U THEN cQualifier + '.RowUserProp':U
                         ELSE 'RowUserProp':U.
      cRowUserProp = {fnarg columnValue cRowUserPropName hDataSource} NO-ERROR.
      DO iPropLoop = 1 TO NUM-ENTRIES(cRowUserProp,CHR(4)):
        IF ENTRY( 1 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) ) = 'gsmcmauto':U THEN 
          MESSAGE ENTRY( 2 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) )
          VIEW-AS ALERT-BOX INFORMATION TITLE "Comment(s) for Record".
      END.
    END.
    
    /* If pcColValues = ? (norecordavail) and we have a valid data source
       then combos and lookups do not ned to be refreshed unless some of the
       non data source fields are specified as always enabled  */
    IF pcColValues = ? AND VALID-HANDLE(hDataSource) THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get EnabledObjFlds cEnabledObjFlds}
      {get EnabledObjFldsToDisable cEnabledObjFldsToDisable}
      .
      &UNDEFINE xp-assign
      
      lRefreshDataFields = 
        IF cEnabledObjFlds = ''                       THEN FALSE
        ELSE IF cEnabledObjFldsToDisable = '(all)':U  THEN FALSE
        ELSE IF cEnabledObjFldsToDisable = '(none)':U THEN TRUE
        ELSE NUM-ENTRIES(cEnabledObjFldsToDisable) < NUM-ENTRIES(cEnabledObjFlds).
    END.  /* pcColValues = ? and valid DataSource */
    ELSE /* else (Rec avail or no data source (viewer used as filter etc..) */
      lRefreshDataFields = TRUE.
    IF lRefreshDataFields THEN
    DO:
      IF glUseNewAPI THEN
        RUN retrieveFieldData IN TARGET-PROCEDURE.
      ELSE DO:
        /* get lookup queries for specific data value and redisplay data */
        PUBLISH "getLookupQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttLookup).
        PUBLISH "getComboQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttDCombo).
        
        IF CAN-FIND(FIRST ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE) THEN
          RUN stripLookupFields IN TARGET-PROCEDURE NO-ERROR.
    
        IF VALID-HANDLE(gshAstraAppserver) THEN 
        DO:
          IF (CAN-FIND(FIRST ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE 
                                      AND   ttLookup.lRefreshQuery = TRUE) 
              OR
              CAN-FIND(FIRST ttDCombo WHERE ttDCombo.hViewer = TARGET-PROCEDURE)) THEN 
          DO:
            
            /* create copies and pass those to the server. This will at least 
               reduce data over to the AppServer if there are other lookups or 
               combo records for other viewers */
            FOR EACH ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE:
              CREATE ttLookupCopy.
              BUFFER-COPY ttLookup TO ttLookupCopy.
              DELETE ttLookup.
            END.
            /* now move the combo records */
            FOR EACH ttDCombo WHERE ttDCombo.hViewer = TARGET-PROCEDURE:
              CREATE ttDComboCopy.
              BUFFER-COPY ttDCombo TO ttDComboCopy.
              DELETE ttDCombo.
            END.

            ASSIGN 
              cWidgetNames  = REPLACE(cDisplayedFields,",":U,CHR(3))
              cWidgetValues = REPLACE(cDisplayValues,CHR(1),CHR(3)).
      
            /* backwards compabitility requires blank instead of unknown,
                pre and append chr(3) for first and last value, 
                loop in case of successive values), 
                substring (not trim) in case of blank */
            DO WHILE INDEX(CHR(3) + cWidgetValues + CHR(3),CHR(3) + '?':U + CHR(3)) > 0:
              ASSIGN 
                cWidgetValues = REPLACE(CHR(3) + cWidgetValues + CHR(3),
                                        CHR(3) + '?':U + CHR(3),
                                        CHR(3) + CHR(3))
                cWidgetValues = SUBSTR(cWidgetValues,2,LENGTH(cWidgetValues) - 2).
        
            END.
        
            /* blank secured fields */
            IF cSecuredFields <> "":U AND cWidgetValues > '' THEN
            DO:
              {get AllFieldNames cAllFieldNames}.
              DO iValue =  1 TO NUM-ENTRIES(cSecuredFields):
                IF ENTRY(iValue,cSecuredFields) = "Hidden":U THEN
                  ASSIGN 
                    cFieldName = ENTRY(iValue,cAllFieldNames)
                    iFieldPos =  LOOKUP(cFieldName,cDisplayedFields)
                    ENTRY(iFieldPos,cWidgetValues,CHR(3))  = '':U.
              END.
            END.
    
            /* If the SDF Cache manager is running, get the data from there */
            IF VALID-HANDLE(ghSDFCacheManager) THEN
              RUN retrieveSDFCache IN ghSDFCacheManager (INPUT-OUTPUT TABLE ttLookupCopy,
                                                         INPUT-OUTPUT TABLE ttDComboCopy,
                                                         INPUT cWidgetNames,
                                                         INPUT cWidgetValues,
                                                         INPUT TARGET-PROCEDURE).
            ELSE /* Get data from server */
              RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookupCopy,
                                                        INPUT-OUTPUT TABLE ttDComboCopy,
                                                        INPUT cWidgetNames,
                                                        INPUT cWidgetValues,
                                                        INPUT TARGET-PROCEDURE).
            
            /* Now we need to move the records back to the original temp-tables.
               First move the lookup records */
            FOR EACH ttLookupCopy:
              CREATE ttLookup.
              BUFFER-COPY ttLookupCopy TO ttLookup.
            END.
              /* now move the combo records */
            FOR EACH ttDComboCopy:
              CREATE ttDCombo.
              BUFFER-COPY ttDComboCopy TO ttDCombo.
            END.
          
            /* Now clear the temp-tables */
            EMPTY TEMP-TABLE ttLookupCopy.
            EMPTY TEMP-TABLE ttDComboCopy.
            
          END. /* can-find lookup with refresh or combo for this viewer */  
        END. /* valid-handle(gshAstraAppsrver) */
        
        /* Display Lookup query/Combo results */    
        PUBLISH "displayLookup":U FROM TARGET-PROCEDURE (INPUT TABLE ttLookup).
        PUBLISH "displayCombo":U  FROM TARGET-PROCEDURE (INPUT TABLE ttDCombo).
      END.
    END. /* lRefreshFields */
  END. /* if pcColValues = ? and useRepository */

  RUN updateTitle IN TARGET-PROCEDURE.

  RUN rowDisplay IN TARGET-PROCEDURE NO-ERROR. /* Custom display checks. */
  
  /* publish displayField if record avail ( pcColValues <> ? ) 
     clearField is being run in all SDFs above if no record avail*/
  IF pcColValues <> ? OR lRefreshDataFields THEN
    PUBLISH 'displayField':U FROM TARGET-PROCEDURE.  

  RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayRelationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRelationFields Procedure 
PROCEDURE displayRelationFields :
/*------------------------------------------------------------------------------
  Purpose: Display fields for relation     
  Parameters:  fieldname of SDF that manages relation
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDisplayedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFieldSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumn            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelationFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyfield          AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DisplayedFields cDisplayedFields}
  {get FieldHandles cFieldHandles}
  .
  &UNDEFINE xp-assign

  hField = WIDGET-HANDLE(ENTRY(LOOKUP(pcFieldName,cDisplayedFields),cFieldHandles))
           NO-ERROR.
  IF VALID-HANDLE(hField) THEN
  DO:
    {get DataSource hFieldSource hField}.
    IF VALID-HANDLE(hFieldSource) THEN
    DO:
      {get DataTable cDataTable hFieldSource}.
      IF cDataTable <> 'RowObject':U AND cDataTable > '' THEN
      DO:
        {get KeyField cKeyField hField}.
        {get DataColumns cDataColumns hFieldSource}.
     
        /* Displayfields decides the order */
        DO iColumn = 1 TO NUM-ENTRIES(cDisplayedFields):
          cColumn = ENTRY(iColumn,cDisplayedFields).
          IF LOOKUP(cColumn,cDataColumns) > 0 AND ENTRY(1,cColumn,'.') = cDataTable THEN
            cRelationFields = cRelationFields
                            + ','
                            + cColumn. 

        END.
        cRelationFields = LEFT-TRIM(cRelationFields,',').
        IF cRelationFields > '' THEN
        DO:
          IF {fnarg columnValue cKeyField hFieldSource} = {fn getDataValue hField} THEN 
            RUN displayfieldList IN TARGET-PROCEDURE 
                  (cRelationFields,
                   '(ALL)':U,
                   hFieldSource, 
                   '').
          ELSE /* clear fields */
            RUN displayfieldList IN TARGET-PROCEDURE 
                 (cRelationFields,
                  '(NONE)':U,
                  ?,
                  ?).

        END.
      END.
    END.
  END.
    
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Enables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor.
  Parameters:  <none>
  Notes:       When the frame field is a SmartObject (for example, a 
               SmartField), enableField is run in the SmartObject.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnableFields  AS CHARACTER NO-UNDO.  /* Field handles. */
  DEFINE VARIABLE cEnableObjects AS CHARACTER NO-UNDO. /* Object handles */
  DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cState         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewRecord     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdateTarget  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGASource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrameHandle   AS HANDLE    NO-UNDO.
  
  /* Field Security Check */
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObjectsToDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldsEnabled lEnabled}
  {get GroupAssignSource hGASource}
  {get AllFieldHandles cAllFieldHandles}
  /* Get Secured Fields */
  {get FieldSecurity cSecuredFields}
  {get ObjectInitialized lInitialized}
  .
  &UNDEFINE xp-assign
  
  /* Bail out if not initialized yet, as the Enabled* properties may not 
    be properly set yet. initializeObject calls this if necessary 
    (SDFs currently add themselves to the lists. There are logic to remove 
    fields from the list for one-to-one SBOs in initializeObject) */
  IF NOT lInitialized THEN 
    RETURN.

  /* Check the record state in the GA source to avoid timing problems
     when this method is called from queryPosition.
     The NewRecord value is not even propagated to GroupAssign-Target(s). */
  IF VALID-HANDLE(hGASource) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get RecordState cState hGASource}
    {get NewRecord cNewRecord hGASource}
    {get UpdateTarget cUpdateTarget hGaSource}.
    &UNDEFINE xp-assign
  END.
  ELSE
  DO:
    &SCOPED-DEFINE xp-assign
    {get RecordState cState}
    {get NewRecord cNewRecord}
    {get UpdateTarget cUpdateTarget}.
    &UNDEFINE xp-assign
  END.
  
  IF  (NOT lEnabled) 
  AND (cUpdateTarget NE "":U) 
  AND (cState = "RecordAvailable":U OR cNewRecord NE "No":U) THEN     
  DO:  
    &SCOPED-DEFINE xp-assign
    {get EnabledHandles cEnableFields}
    {get EnabledObjHdls cEnableObjects}
    {get EnabledObjFldsToDisable cObjectsToDisable}.
    &UNDEFINE xp-assign
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
      ASSIGN 
        hField    = WIDGET-HANDLE(ENTRY(iField, cEnableFields))      
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
      
      IF VALID-HANDLE(hField) THEN 
      DO:
        /* "Frame Field" May be a SmartObject procedure handle */
        IF hField:TYPE = "PROCEDURE":U THEN 
        DO:
          IF ((iFieldPos <> 0 
               AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
               AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
              OR iFieldPos = 0) 
             OR cSecuredFields = "":U THEN 
            /* Check Security */
            RUN enableField IN hField NO-ERROR.
          ELSE DO:  
            IF ENTRY(iFieldPos,cSecuredFields) = "Hidden":U THEN
              RUN hideObject IN hField NO-ERROR.
            ELSE 
              RUN disableField IN hField NO-ERROR.
          END.  /* else do - secured */
        END.  /* If Handle type is PROCEDURE */
        ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
        DO:
           /* Check Security */
          IF ((iFieldPos <> 0 
               AND NUM-ENTRIES(cSecuredFields) >= iFieldPos
               AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
              OR iFieldPos = 0) 
             OR cSecuredFields = "":U THEN 
          DO:
            hField:SENSITIVE = YES.
            IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
              hField:READ-ONLY = NO.     
            /* don't enable if read-only (can-query is ok as only fields can 
               have popups) */
            IF CAN-QUERY(hField,'read-only':U) AND NOT hField:READ-ONLY THEN
              DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                                hField, YES). 
            
         END.  /* IF security check succeeds */
        END.  /* If the field is not hidden */
      END.  /* If hField is a valid handle */
    END.  /* Looping through the fields */
    /* Enable no db fields */
    IF cObjectsToDisable <> '(none)':U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
      hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).      
      IF hField:TYPE = "PROCEDURE":U THEN 
        cName = {fn getFieldName hField} NO-ERROR.
      ELSE 
        cName = hField:NAME.  
      IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
      DO:      
        iFieldPos = 0.
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).     
        IF VALID-HANDLE(hField) THEN DO:  
          /* "Frame Field" May be a SmartObject procedure handle */
          IF hField:TYPE = "PROCEDURE":U THEN 
          DO:          
            IF ((iFieldPos <> 0 
                 AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
                 AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
                OR iFieldPos = 0) 
               OR cSecuredFields = "":U THEN /* Check Security */
              RUN enableField IN hField NO-ERROR.
            ELSE DO:
              IF ENTRY(iFieldPos,cSecuredFields) = "Hidden":U THEN
                RUN hideObject IN hField NO-ERROR.
              ELSE 
                RUN disableField IN hField NO-ERROR.
            END.
          END.
          ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
          DO:
            /* Check Security */
            IF ((iFieldPos <> 0 
                 AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
                 AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
                OR iFieldPos = 0) 
               OR cSecuredFields = "":U THEN 
            DO:
              hField:SENSITIVE = YES.
              IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
                hField:READ-ONLY = NO.
             /* don't enable if read-only (can-query is ok as only fields can 
                have popups) */
              IF CAN-QUERY(hField,'read-only':U) AND NOT hField:READ-ONLY THEN
                DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                                  hField, YES). 
            END.  /* If security check succeeds */
          END.  /* If the field isn't hidden */
        END.  /* IF it is a valid field */
      END.
    END.  /* Do for all enabled objects */

    /* If the list of enabled field handles isn't set, it may because this
       object hasn't been fully initialized yet. So don't set the enabled
       flag because we may be through here again. */
    IF cEnableFields NE "":U THEN
      {set FieldsEnabled yes}.
  END.
  ELSE /* Ensure that SDF fields is disabled if no record available */
  IF (NOT lEnabled) AND (cUpdateTarget NE "":U) AND (cState = "NoRecordAvailable":U) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledHandles cEnableFields}
    {get EnabledObjHdls cEnableObjects}
    {get EnabledObjFldsToDisable cObjectsToDisable}
     .
    &UNDEFINE xp-assign
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
      ASSIGN
        hField    = WIDGET-HANDLE(ENTRY(iField, cEnableFields))       
        iFieldPos = 0
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
       
      IF VALID-HANDLE(hField) THEN 
      DO:
        /* "Frame Field" May be a SmartObject procedure handle */
        IF hField:TYPE = "PROCEDURE":U THEN
          RUN disableField IN hField NO-ERROR.
        ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
        DO:
          IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
            hField:READ-ONLY = yes.  
          ELSE 
            hField:SENSITIVE = NO.   
          DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                           hField, NO). 
        END.  /* END DO NOT HIDDEN */
      END.  /* If hField is valid */
    END.     /* END DO iField     */
    
    IF cObjectsToDisable <> '(none)':U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
      hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
      IF hField:TYPE = "PROCEDURE":U THEN 
        cName = {fn getFieldName hField} NO-ERROR.
      ELSE 
        cName = hField:NAME.  
      IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
      DO:   
        ASSIGN 
          iFieldPos = 0
          iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
        
        IF VALID-HANDLE(hField) THEN 
        DO:
          /* "Frame Field" May be a SmartObject procedure handle */
          IF hField:TYPE = "PROCEDURE":U THEN
            RUN disableField IN hField NO-ERROR.
          ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
          DO:
            IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
              hField:READ-ONLY = YES.  
            ELSE 
              hField:SENSITIVE = NO.  
            DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                              hField, NO).
          END.  /* END DO NOT HIDDEN */
        END.  /* If a valid handle */
      END.
    END.  /* END DO iField     */
  END.  /* Disbling SDF if not data available */ 
  RUN SUPER.

  PUBLISH 'enableFields':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchChildFieldData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchChildFieldData Procedure 
PROCEDURE fetchChildFieldData :
/*------------------------------------------------------------------------------
  Purpose:  Retrieve and refresh data for child SDF's of specified parent
Parameters: pcParent - Parent name 
                     - blank = fields with no parent
                     - ?     = all
  Notes:    Handles only combos  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcParent AS CHARACTER  NO-UNDO.
              
  RUN notifyFields IN ghSDFCacheManager ('Fetch':U,
                                         TARGET-PROCEDURE,
                                         pcParent).  
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code specific to SmartDataViewers. 
  Parameters:  <none>
  Notes:       Reads through list of enabled and displayed fields and
               gets their handles to store in FieldHandles and EnabledHandles
               properties.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cEnabledFields     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
 DEFINE VARIABLE lSaveSource        AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE hGaSource          AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cGaMode            AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iField             AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cUIBMode           AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cNewRecord         AS CHARACTER NO-UNDO.
 
 RUN SUPER.   /* Invoke the standard behavior first. */

 IF RETURN-VALUE = "ADM-ERROR":U THEN 
   RETURN "ADM-ERROR":U.      

 &SCOPED-DEFINE xp-assign
 {get EnabledFields cEnabledFields}
 {get UIBMode cUIBMode}.
 &UNDEFINE xp-assign
 
 /* UIBmode gives errors because handles for SDFs is not added */ 
 IF (cUIBMode BEGINS 'Design':U) THEN
 DO:
   /* If there are NO enabled fields, don't let the viewer be an */
   /* Update-Source or TableIO-Target. */
   IF cEnabledFields = "":U THEN
   DO:
       RUN modifyListProperty IN TARGET-PROCEDURE
           (TARGET-PROCEDURE, "REMOVE":U,"SupportedLinks":U,"Update-Source":U).
       RUN modifyListProperty IN TARGET-PROCEDURE
           (TARGET-PROCEDURE, "REMOVE":U,"SupportedLinks":U,"TableIO-Target":U).
   END.   /* END DO cEnabled "" */

   RETURN.
 END.

 {get GroupAssignSource hGASOurce}.
 
 RUN dataAvailable IN TARGET-PROCEDURE (?). /* See if there's a rec waiting. */
  
  /* Is this a GaTarget, if so get SaveSOurce, FieldsEnabled and NewRecord from the 
     GA source so we can find out whether we should be enabled (further down) or 
     display the current record 
     (if the GASource is in "Add" or "Copy" mode already */
 IF VALID-HANDLE(hGaSource) THEN
 DO:
   {get ObjectMode cGaMode hGaSource}.
    /* The NewRecord is only set at the tableioTarget yet, 
        so check through a potential GroupAssingSource link chain. */ 
   DO WHILE VALID-HANDLE(hGASource):
     &SCOPED-DEFINE xp-assign
     {get NewRecord cNewRecord hGASource}
     {get GroupAssignSource hGASource hGASource}.
     &UNDEFINE xp-assign
   END.
    /* synchronize the NewRecord value with our GA-Source */
   {set NewRecord cNewRecord}.

   IF cNewRecord <> "NO":U THEN
      RUN displayRecord IN TARGET-PROCEDURE.
 END.
 ELSE
   {get SaveSource lSaveSource}.
  
  /* If we have NO tableio-source (?) or a Tableio-Source in Save mode 
     OR if our groupAssign-source is not in view mode the target also should be,
    (that would have been the case if this GAtarget had been initialized) */  
 IF (cGaMode > '':U AND cGaMode <> "view":U)
 OR NOT (lSaveSource = FALSE) THEN
   RUN enableFields IN TARGET-PROCEDURE.
  
 ELSE 
 DO:
   {set FieldsEnabled YES}.
   RUN disableFields IN TARGET-PROCEDURE ('ALL':U).
 END.         /* END ELSE DO IF not enableFields */
  
  /* Activate GroupAssignSource link (LinkstateHandler overrides ADD and 
    deactives the link to avoid events like enablefields to be published 
    from GaSource before initalize.
    Reget the handle..  used in loop until invalid above! */
 {get GroupAssignSource hGASOurce}.
 IF VALID-HANDLE(hGaSource) THEN
   RUN linkStateHandler IN TARGET-PROCEDURE ('Active':U,
                                              hGaSource,
                                              'GroupAssignSource':U).
   
 /* Ensure only has entries for this viewer */
 EMPTY TEMP-TABLE ttComboData.
  
  /* gather all master combo queries */
 PUBLISH "getComboQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttComboData).  

  /* build combo list-item pairs */
 IF VALID-HANDLE(gshAstraAppserver) AND CAN-FIND(FIRST ttComboData) THEN
   RUN adm2/cobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
  
  /* populate all master combos */          
  PUBLISH "buildCombo":U FROM TARGET-PROCEDURE (INPUT TABLE ttComboData).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when a GroupAssignTarget becomes
               "active" (normally when it's viewed) or "inactive" (Hidden).
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
               The event is republished up the groupAssignSource and
               the DataSource     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  PUBLISH 'linkState':U FROM TARGET-PROCEDURE (pcState). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose: Override to synchronize GATargets 
  Parameters: pcstate -
                add,remove,inactive,active
              phObject - object to link to 
              pcLink   - Linkname (data-source)      
  Notes:   The SDO only calls this with 'inactive' when all data targets
           that have a GaSOurce is hidden, using the getGroupAssingHidden
           read-only property.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lGaTargetInit     AS LOGICAL    NO-UNDO INIT ?.
  DEFINE VARIABLE cInactiveLinks    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceEvents AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.

  /* An uninitialized GroupAssignTarget starts up with deactive 
     groupAssign-source link in order to not receive events like enableFields 
     and disableFields before initialized. (customer overrides with SDF handle
     references) The link is activated in initializeObject     
    (Performance is EXTREMELY crucial here so only retrieve ObjectInitialized 
     if required, lGaTargetInit is defined init ?.. 
     the code further below has the normal if.. else.. structure) */   
  IF pcLink = 'GroupAssignSource':U AND pcState = 'Add':U THEN
    {get ObjectInitialized lGaTargetInit}.
  
  /* non init GaTarget start with deactive GaSource (See comments above)
    (DEF is INIT ?)*/
  IF lGaTargetInit = FALSE THEN 
    DYNAMIC-FUNCTION('modifyInactiveLinks':U IN TARGET-PROCEDURE,
                     'ADD':U,pcLink,phObject). 
  
  ELSE DO: /*(all cases except Non-initialized GaTarget)*/
    
     /* data links are deactive on add an activated on init..... 
        but we subscribed to buildDataRequest (see below after super)
        so we make sure to unsubscribe when the link is activated 
        (could alternatively have removed the event from DataSourceEvents
         while super is called ) */      
    IF pcLink = 'DataSource':U AND pcState = 'ACTIVE':U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get DataSourceEvents cDataSourceEvents}
      {get ObjectInitialized lInitialized}
      .
      &UNDEFINE xp-assign
      
      IF NOT lInitialized 
      AND LOOKUP('buildDataRequest':U,cDataSourceEvents) > 0 THEN 
        UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'buildDataRequest':U IN phObject.
    END.

    RUN SUPER(pcState,phObject,pcLink).
    
    IF pcLink = 'DataSource':U THEN
    DO:
      IF pcState = 'ADD':U THEN
      DO:
        /* Use NO-ERROR as SBO do not yet support this 
          (could also be passThru link to container). */
        {set FetchAutoComment TRUE phObject} NO-ERROR.

        /* data links are deactive on add an activated on init..... 
           The viewer do, however, need to subscribe to buildDataRequest
           before initialization in order to include SDF SDOs in the request 
           We unsubscribe on active (see before super)*/ 
        &SCOPED-DEFINE xp-assign
        {get DataSourceEvents cDataSourceEvents}
        {get ObjectInitialized lInitialized}
        .
        &UNDEFINE xp-assign
        IF NOT lInitialized 
        AND LOOKUP('buildDataRequest':U,cDataSourceEvents) > 0
        AND DYNAMIC-FUNCTION("isLinkInactive":U IN TARGET-PROCEDURE,
                                  'DataSource':U,phObject) THEN
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'buildDataRequest':U IN phObject.
      END.

      IF CAN-DO('ACTIVE,INACTIVE':U,pcState) THEN
      DO:
        {get GroupAssignTarget cTargets}.
        DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
          RUN LinkStateHandler IN hTarget(pcState,phObject,pcLink).
        END.
      END.
    END.
  END. /* else (all cases except Non-initialized GaTarget) */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-locateWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE locateWidget Procedure 
PROCEDURE locateWidget :
/*------------------------------------------------------------------------------
  Purpose:     Locates a widget and retuns its handle and the handle of its
               TARGET-PROCEDURE
  Parameters:  pcWidget AS CHARACTER
               phWidget AS HANDLE
               phTarget AS HANDLE
  Notes:       Contains code to locate a widget specific to viewers's when 
               the qualifier is 'Browse'
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

DEFINE VARIABLE cDataTargets  AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cObjectType   AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cQualifier    AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hDataTarget   AS HANDLE     NO-UNDO. 
DEFINE VARIABLE iDataTargets  AS INTEGER    NO-UNDO.
DEFINE VARIABLE lBrowsed      AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE cFields       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lNoQual       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cSourceNames  AS CHARACTER   NO-UNDO.

  IF NUM-ENTRIES(pcWidget, '.':U) > 1 AND ENTRY(1, pcWidget, '.':U) = 'Browse':U THEN
  DO:
    cField = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                               INPUT 1,
                               INPUT pcWidget,
                               INPUT '.':U). 
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get DataQueryBrowsed lBrowsed hDataSource}.
      /* If the qualifier is Browse and the data source does not have a
         browser data target, then there is no need to search further. */
      IF cQualifier BEGINS 'Browse':U AND NOT lBrowsed THEN RETURN.

      {get DataTarget cDataTargets hDataSource}.
      DO iDataTargets = 1 TO NUM-ENTRIES(cDataTargets):
        ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iDataTargets, cDataTargets)) NO-ERROR.
        IF VALID-HANDLE(hDataTarget) AND hDataTarget NE TARGET-PROCEDURE THEN
        DO:
         {get ObjectType cObjectType hDataTarget}.
         IF cObjectType = 'SmartDataBrowser':U THEN
           ASSIGN 
             phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hDataTarget,
                                          INPUT cField, INPUT 'DATA':U)
             phTarget = hDataTarget NO-ERROR.
           IF phWidget NE ? THEN RETURN.
        END.  /* if valid data target */
      END.  /* do iLoop to number data targets */
    END.  /* if valid data source */
  END.  /* if browser qualifier */
  ELSE DO:
      {get DisplayedFields cFields}.
      lNoQual = INDEX(cFields,'.':U) = 0.
      IF lNoQual THEN
         {get DataSourceNames cSourceNames} NO-ERROR.   
      IF NUM-ENTRIES(pcWidget,".":U) > 1 
      AND LOOKUP(pcWidget,cFields) = 0
      AND lNoQual 
      AND NUM-ENTRIES(cSourceNames) = 1 
      AND ENTRY(1,pcWidget,".":U) = cSourceNames THEN
        pcWidget = ENTRY(2,pcWidget,".":U).

      RUN SUPER (INPUT pcWidget, OUTPUT phWidget, OUTPUT phTarget).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveFieldData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveFieldData Procedure 
PROCEDURE retrieveFieldData :
/*------------------------------------------------------------------------------
  Purpose:    Retrieve data for all instances of class lookupfield that need 
              new data.    
  Parameters:  <none>
  Notes:      The prepare will mark SDFs that have query changes to 
              be refreshed by retrievedata. 
           -  The data is not displayed, the caller (f.ex. displayFields)
              will publish 'displayField' to which the SDF subscribes after 
              this call. 
------------------------------------------------------------------------------*/
  PUBLISH "prepareField":U FROM TARGET-PROCEDURE.
  RUN retrieveData IN ghSDFCacheManager (TARGET-PROCEDURE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stripLookupFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stripLookupFields Procedure 
PROCEDURE stripLookupFields :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check all the lookups in the current viewer
               and try to get the displayed fields and linked field values from
               it's data source before attempting to fetch the data from the 
               query on the server.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDataLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTablesInQ           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSources         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMappedFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedWidgets AS CHARACTER  NO-UNDO.
  {get DataSource hDataSource}.
  
  /* If we don't have a valid Data Source then leave */
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN.

  /* Get a list of tables in the Data Source */
  cTablesInQ = DYNAMIC-FUNCTION("getTables":U IN hDataSource) NO-ERROR.
  
  cDataSources = "":U.
  /* Check if our Data Source is an SBO */
  IF cTablesInQ = ? OR
     cTablesInQ = "?":U THEN DO:
    DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
    {get ContainerSource hContainer}.
    cDataSources = DYNAMIC-FUNCTION("getContainedDataObjects":U IN hDataSource).
  END.
  ELSE
    cDataSources = STRING(hDataSource).

  DO iDataLoop = 1 TO NUM-ENTRIES(cDataSources):
    hDataSource = WIDGET-HANDLE(ENTRY(iDataLoop,cDataSources)).
    IF NOT VALID-HANDLE(hDataSource) THEN
      NEXT.
    
    /* Get a list of tables in the Data Source */
    cTablesInQ = DYNAMIC-FUNCTION("getTables":U IN hDataSource) NO-ERROR.
    /* We need to do this to ensure that we do not think that the
     fields available in the data source is available for our 
     lookup since the data source might be the exact same table
     as the table the lookup is using - e.g. Object type maint with
     a lookup on object type of extends_object_type_obj would result
     in the lookup thinking it's got the object type of the extends_objec_type
     lookup */

    FOR EACH  ttLookup
        WHERE ttLookup.hViewer = TARGET-PROCEDURE
        EXCLUSIVE-LOCK: /* This is for the sake of consistency */
      
      ASSIGN ttLookup.lRefreshQuery    = FALSE
             ttLookup.cFoundDataValues = "":U.
      
      /* First check if we have the MappedField property specified */
      cMappedFields = DYNAMIC-FUNCTION("getMappedFields":U IN ttLookup.hWidget) NO-ERROR.
      
      IF ERROR-STATUS:ERROR OR 
         cMappedFields = ? OR
         cMappedFields = "?":U THEN
        cMappedFields = "":U NO-ERROR.
      IF cMappedFields <> "":U THEN
      DO:
        /* The field list has the following order:
           1. Key Field,
           2. Displayed Field,
           3. Linked Fields */
        /* The MappedFields propery will also always include the displayed field
           and is marked as <Displayed Field> */
        
        /* Let's first set the value of the KeyField */
        cValue = DYNAMIC-FUNCTION("getDataValue":U IN ttLookup.hWidget) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          cValue = "":U.
        ttLookup.cFoundDataValues = cValue.

        /* Now we will get the displayed field's value */
        cField = ENTRY(LOOKUP("<Displayed Field>",cMappedFields) - 1,cMappedFields) NO-ERROR.
        IF ERROR-STATUS:ERROR OR
           cField = "":U OR
           cField = ?    OR
           cField = "?" THEN
          ASSIGN cField = "":U
                 cValue = ?.
        IF cField <> "":U THEN
          cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
        
        /* The field could not be found in the Data Source */
        IF cValue = ? THEN
        DO:
          ttLookup.lRefreshQuery = TRUE.
          RETURN.
        END.
        
        /* Add the displayed field's value */
        ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                    CHR(1) + cValue.
        /* First check if we need to get more data - possible linked fields */
        IF NUM-ENTRIES(RIGHT-TRIM(ttLookup.cFieldList,",":U)) <= 2 THEN 
        DO:
          ttLookup.lRefreshQuery = FALSE.
          RETURN.
        END.
        
        cViewerLinkedWidgets = DYNAMIC-FUNCTION("getViewerLinkedWidgets":U IN ttLookup.hWidget) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          cViewerLinkedWidgets = "":U.

        /* If we don't have linked widgets but we have more than just 2 fields
           in the field list then our data is corrupt - rather get out here 
           and let the normal process continue as normal */
        IF cViewerLinkedWidgets = "":U THEN
        DO:
          ttLookup.lRefreshQuery = TRUE.
          RETURN.
        END.
        /* We are working on the assumtion that ViewerLinkedFields and
           ViewerLinkedWidgets are in the same order */
        DO iLoop = 3 TO NUM-ENTRIES(ttLookup.cFieldList):
          cWidgetName = ENTRY(iLoop - 2,cViewerLinkedWidgets) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Get the Data Source field */
          cField = ENTRY(LOOKUP(cWidgetName,cMappedFields) - 1,cMappedFields) NO-ERROR.
          IF ERROR-STATUS:ERROR OR
             cField = "":U OR 
             cField = "?":U OR 
             cField = ? THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Get the Data Source field value */
          IF cField <> "":U THEN
            cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.

          /* The field could not be found in the Data Source */
          IF cValue = ? THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Add the field's value */
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      CHR(1) + cValue.
        END.
      END. /* MappedFields specified */
      ELSE
      DO:
        /* If we do not have mapped fields specified - do the asumption */
        cFieldName = IF NUM-ENTRIES(ttLookup.cWidgetName,".":U) > 1 THEN ENTRY(2,ttLookup.cWidgetName,".":U) ELSE ttLookup.cWidgetName.
        FIELD_LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
          ASSIGN cField = ENTRY(iLoop,ttLookup.cFieldList).
          IF cField = "":U THEN
            NEXT FIELD_LOOP.
          IF NUM-ENTRIES(cField,".":U) > 1 THEN DO:
            IF ENTRY(1,cField,".":U) = ENTRY(1,cTablesInQ) AND 
               NUM-ENTRIES(cDataSources) = 1 THEN DO:
              ttLookup.lRefreshQuery = TRUE.
              RETURN.
            END.
          END.
    
          /* Check if the field we are looking for is infact from the table used 
             in the lookup */
          IF NUM-ENTRIES(cField,".":U) > 1 AND iDataLoop = 1 THEN 
          DO:
            IF DYNAMIC-FUNCTION("columnTable":U IN hDataSource,ENTRY(2,cField,".")) = ENTRY(1,cTablesInQ) AND
               cFieldName <> ENTRY(2,cField,".") AND
               NUM-ENTRIES(cDataSources) = iDataLoop THEN DO:
              ttLookup.lRefreshQuery = TRUE.
              RETURN.
            END.
          END.
    
          /* First try to get the value of the field with the table name joined */
          cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
          /* If the failed, then try to get the value for the field name only */
          IF ERROR-STATUS:ERROR OR 
             cValue = ? OR cValue = "?":U THEN DO:
            cField = IF NUM-ENTRIES(cField,".":U) > 1 THEN ENTRY(2,cField,".":U) ELSE cField.
            cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
          END.
          IF cValue = ? OR cValue = "?":U THEN
            ASSIGN cValue = "":U
                   ttLookup.lRefreshQuery = TRUE.
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                                      cValue.
        END. /* iLoop */
      END. /* Not MappedFields */
    END. /* FOR EACH  ttLookup */
  END. /* iDataLoop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateDynComboTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDynComboTable Procedure 
PROCEDURE updateDynComboTable :
/*------------------------------------------------------------------------------
  Purpose:  Copy the passed buffer to the dyn combo table     
  Parameters:  phComboBuffer - buffer with same fields as ttDCombo
  Notes:   This is used by the combo class to synchronize the viewer class. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phComboBuffer AS HANDLE.

  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProc   AS HANDLE     NO-UNDO.

  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(phCombobuffer).
  hQuery:QUERY-PREPARE('for each ':U + phComboBuffer:NAME). 
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST.
  hProc = phComboBuffer:BUFFER-FIELD('hWidget':U).
  
  DO WHILE phCombobuffer:AVAIL:
     FIND ttDCombo WHERE ttDcombo.hWidget = hProc:BUFFER-VALUE NO-ERROR.
     IF AVAIL ttDcombo THEN
       TEMP-TABLE ttDCombo:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(phComboBuffer).
     hQuery:GET-NEXT.
  END.

  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state messages for updates
  Parameters:  pcState AS CHARACTER -- update state: 
               'UpdateBegin',
               'UpdateComplete'
               'Update' 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.

  CASE pcState:
    WHEN 'UpdateBegin':U THEN 
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        /* In case enable fails for some reason.*/
        (IF RETURN-VALUE = "ADM-ERROR":U THEN 'UpdateComplete':U
           ELSE 'Update':U).   /* Tell others (Data Object, Nav Panel) */
    END.
    OTHERWISE RUN SUPER(INPUT pcState).  /* Let datavis deal with it. */
  END CASE.
  
  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewRecord Procedure 
PROCEDURE viewRecord :
/*------------------------------------------------------------------------------
  Purpose:  Set object in viewMode    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN disableFields IN TARGET-PROCEDURE.
  PUBLISH 'updateState':U FROM TARGET-PROCEDURE ("view").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-firstVisibleInGroup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstVisibleInGroup Procedure 
FUNCTION firstVisibleInGroup RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the first visible object of all GA-linked objects, starting 
           from the object that this is called in.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets AS CHAR       NO-UNDO.
  DEFINE VARIABLE iTarget  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lhidden  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hObject  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectHidden lHidden}
  {get GroupAssignTarget cTargets}
  .
  &UNDEFINE xp-assign
  
  IF NOT lHidden THEN
    RETURN TARGET-PROCEDURE.

  /* Check if any GA sibling before us is visible */
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).      
    hObject = {fn firstVisibleInGroup hTarget}.
    IF VALID-HANDLE(hObject) THEN
      RETURN hObject.
  END.
  
  RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataFieldMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataFieldMapping Procedure 
FUNCTION getDataFieldMapping RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a comma separated list of widget name and datafield name \
           pairs, used to define the mapping between LONGCHAR widgets and
           CLOB data-source fields.  
    Notes: NOT defined as a normal property since it rarely has any data.  
           The adm-datafield-mapping is ONLY defined in static viewers that 
           defines a LONGCHAR in the frame to edit/view a CLOB field.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping AS CHARACTER  NO-UNDO.
  
  /* defined in static viewers that has LONGCHAR editors mapped to CLOB 
     datafields */ 
  IF CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES,"adm-datafield-mapping":U) THEN
    RETURN {fn adm-datafield-mapping}.
  ELSE 
    RETURN ''.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeepChildPositions Procedure 
FUNCTION getKeepChildPositions RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lKeepChildPositions             AS LOGICAL          NO-UNDO.

    {get KeepChildPositions lKeepChildPositions}.

    RETURN lKeepChildPositions.
END FUNCTION.   /* getKeepChildPositions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowPopup Procedure 
FUNCTION getShowPopup RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    define variable lShowPopup             as logical                no-undo.
    
    {get ShowPopup lShowPopup}.
    
    error-status:error = no.
    return lShowPopup.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Needed by SBO routines to provide the actual caller object handle.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:  Return handle of named widget within this object  
     Notes:  This override is for viewer to allow a request with no qualifer
            find a field when the fieldnames are qualified.  
 Parameter: pcfield           
            pcSearchMode 
             ALL - searches datafields and local fields (if it doesn't find 
                                                        datafield)
             DATA - searches datafields only
             LOCAL - searches local field only
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSource          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSource          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER    NO-UNDO.

  hField = SUPER(pcField,pcSearchMode).

  /* if the unqualifed field was not found we check if it could be one 
     of the SBO-qualifed fields */ 
  IF NOT VALID-HANDLE(hField) 
  AND NUM-ENTRIES(pcField,'.':U) = 1
  AND LOOKUP(pcSearchMode, 'ALL,DATA':U) > 0 THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DisplayedFields cFieldNames}
    {get FieldHandles cFieldHandles}
    {get DataSourceNames cDataSourceNames}
     .
    &UNDEFINE xp-assign
    IF INDEX(cFieldNames,'.':U) > 0 THEN
    DO:
      /* remove datasourcename qualifier */
      DO iSource = 1 TO NUM-ENTRIES(cDataSourceNames):
        ASSIGN
          cSource = ENTRY(iSource,cDataSourceNames)
          /* ensure 'order' does not replace 'purchaseorder'.. */ 
          cFieldNames = LEFT-TRIM(
                        REPLACE("," + cFieldNames,"," + cSource + ".",","),
                        ',').
      END.
      iFieldPos = LOOKUP(pcField, cFieldNames).
      IF iFieldPos NE 0 AND NUM-ENTRIES(cFieldHandles) >= iFieldPos THEN 
        hField = WIDGET-HANDLE(ENTRY(iFieldPos, cFieldHandles)).  
    END.
  END.
    
  RETURN hField.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeepChildPositions Procedure 
FUNCTION setKeepChildPositions RETURNS LOGICAL
        ( INPUT plKeepChildPositions AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    {set KeepChildPositions plKeepChildPositions}.
    RETURN TRUE.
END FUNCTION.   /* setKeepChildPositions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowPopup Procedure 
FUNCTION setShowPopup RETURNS LOGICAL
        ( input plShowPopup    as logical ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    {set ShowPopup plShowPopup}.
    
    error-status:error = no.
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

