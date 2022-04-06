&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Security - Actions - Allocation Viewer"
*/
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
  File: secacselbvsupr.p

  Description:  Security - Actions - Allocation Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/12/2003  Author:     

  Update Notes: Created from Template view
  rkamboj 11/30/2012 User was able to modify users data for unauthorized company. 

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

&scop object-name       secacselbvsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghNonSecBrowse    AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Browse */
DEFINE VARIABLE ghSecBrowse       AS HANDLE     NO-UNDO. /* Handle to Secured Data Browse */
DEFINE VARIABLE ghNonSecQuery     AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Query */
DEFINE VARIABLE ghSecQuery        AS HANDLE     NO-UNDO. /* Handle to Secured Data Query */
DEFINE VARIABLE ghNonSecTable     AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Table */
DEFINE VARIABLE ghSecTable        AS HANDLE     NO-UNDO. /* Handle to Secured Data Table */
DEFINE VARIABLE ghNonSecBuffer    AS HANDLE     NO-UNDO. /* Handle to Non Secured Data Table Buffer */
DEFINE VARIABLE ghSecBuffer       AS HANDLE     NO-UNDO. /* Handle to Secured Data Table Buffer */
DEFINE VARIABLE gcNonSecLastRowId AS CHARACTER  NO-UNDO. /* List of Last returned RowIds for Non Secured Data */
DEFINE VARIABLE gcSecLastRowId    AS CHARACTER  NO-UNDO. /* List of Last returned RowIds for Secured Data */
DEFINE VARIABLE glNonSecQryComp   AS LOGICAL    NO-UNDO. /* Query Comple check for Non Secured Secured Data */
DEFINE VARIABLE glSecQryComp      AS LOGICAL    NO-UNDO. /* Query Comple check for Secured Secured Data */

DEFINE VARIABLE gdLastSetWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdLastSetHeight   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glDataSecurity    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glUserDataSec     AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gdUserObj         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdCompanyObj      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE giRowsToBatch     AS INTEGER    NO-UNDO.

DEFINE VARIABLE ghFilterViewer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcFilterData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glFieldSecurity   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glRangeSecurity   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSecTypeCol      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRangeFromCol    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRangeToCol      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSecuredCol      AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcEntity          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEntityName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEntityObjField  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcGrantRevoke     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glRevoke          AS LOGICAL    NO-UNDO.

/* PLIP definitions */
{dynlaunch.i &define-only = YES }

DEFINE TEMP-TABLE ttFilterData NO-UNDO
  FIELD cFieldLabel AS CHARACTER FORMAT "X(35)":U
  FIELD cFromValue  AS CHARACTER FORMAT "X(35)":U
  FIELD cToValue    AS CHARACTER FORMAT "X(35)":U
  FIELD cFormat     AS CHARACTER FORMAT "X(15)":U
  FIELD cDataType   AS CHARACTER FORMAT "X(10)":U
  FIELD cTableName  AS CHARACTER
  FIELD cFieldName  AS CHARACTER
  FIELD iFieldOrder AS INTEGER
  INDEX idx1        AS PRIMARY iFieldOrder
  INDEX idx2        AS UNIQUE cTableName cFieldName.


{af/app/afsecttdef.i}

DEFINE TEMP-TABLE ttDeletedAllocations NO-UNDO
  FIELD dOwningObj AS DECIMAL
  INDEX idx1       AS PRIMARY UNIQUE dOwningObj.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 22
         WIDTH              = 58.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addAll Procedure 
PROCEDURE addAll :
/*------------------------------------------------------------------------------
  Purpose:     Copy all records from Non Secured Data browse to Secured Data
               Browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(ghNonSecQuery) THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /* First - we need to ensure we get all the records back from
     the database to select all */
  RUN browseEnd IN TARGET-PROCEDURE (INPUT "NONSEC":U).

  ghNonSecQuery:GET-FIRST().
  DO WHILE ghNonSecBuffer:AVAILABLE:
    ghSecBuffer:BUFFER-CREATE().
    ghSecBuffer:BUFFER-COPY(ghNonSecBuffer).
    ghNonSecBuffer:BUFFER-DELETE().
    ghNonSecQuery:GET-NEXT().
  END.

  ghNonSecQuery:QUERY-CLOSE().
  ghSecQuery:QUERY-CLOSE().
  ghNonSecQuery:QUERY-OPEN().
  ghSecQuery:QUERY-OPEN().
  ghSecQuery:REPOSITION-TO-ROW(1) NO-ERROR.
  disableWidget("buAddAll":U).
  enableWidget("buRemoveAll":U).

  RUN setButtonState IN TARGET-PROCEDURE (INPUT "NONSEC":U).
  RUN setButtonState IN TARGET-PROCEDURE (INPUT "SEC":U).
  SESSION:SET-WAIT-STATE("":U).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSelected Procedure 
PROCEDURE addSelected :
/*------------------------------------------------------------------------------
  Purpose:     Copy Select Non Secured records to the Secured Data Browser
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  IF NOT VALID-HANDLE(ghNonSecBrowse) THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  DO iLoop = 1 TO ghNonSecBrowse:NUM-SELECTED-ROWS:
    ghNonSecBrowse:FETCH-SELECTED-ROW(iLoop).
    IF ghNonSecBuffer:AVAILABLE THEN DO:
      ghSecBuffer:BUFFER-CREATE().
      ghSecBuffer:BUFFER-COPY(ghNonSecBuffer).
      ghNonSecBuffer:BUFFER-DELETE().
    END.
  END.
  
  ghNonSecQuery:QUERY-CLOSE().
  ghSecQuery:QUERY-CLOSE().
  ghNonSecQuery:QUERY-OPEN().
  ghSecQuery:QUERY-OPEN().
  ghSecQuery:REPOSITION-TO-ROW(1) NO-ERROR.
  
  ghNonSecQuery:GET-FIRST() NO-ERROR.
  IF ghNonSecBuffer:AVAILABLE THEN
    enableWidget("buAddAll":U).
  ELSE
    disableWidget("buAddAll":U).

  ghSecQuery:GET-FIRST() NO-ERROR.
  IF ghSecBuffer:AVAILABLE THEN
    enableWidget("buRemoveAll":U).
  ELSE
    disableWidget("buRemoveAll":U).

  RUN setButtonState IN TARGET-PROCEDURE (INPUT "NONSEC":U).
  RUN setButtonState IN TARGET-PROCEDURE (INPUT "SEC":U).
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFieldSecurity Procedure 
PROCEDURE applyFieldSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSecurityType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecured        AS CHARACTER  NO-UNDO.

  IF NOT glFieldSecurity AND 
     NOT glRangeSecurity AND 
     NOT glUserDataSec THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  IF glFieldSecurity THEN DO:
    cSecurityType = widgetValue("raFieldSecType":U).
    CASE cSecurityType:
      WHEN "READONLY":U THEN
        cSecurityType = "Read Only":U.
      WHEN "HIDDEN":U THEN
        cSecurityType = "Hidden":U.
      OTHERWISE
        cSecurityType = "Full Access":U.
    END CASE.
    /* If a record is available in browser */
    DO iLoop = 1 TO ghSecBrowse:NUM-SELECTED-ROWS:
      ghSecBrowse:FETCH-SELECTED-ROW(iLoop).
      IF ghSecBuffer:AVAILABLE THEN DO:
        ghSecBuffer:BUFFER-FIELD("cSecurityType":U):BUFFER-VALUE = cSecurityType.
        ghSecTypeCol:SCREEN-VALUE = cSecurityType.
      END.
    END.
  END.
  
  IF glRangeSecurity THEN DO:
    cFromValue = widgetValue("fiRangeFrom":U).
    cToValue   = widgetValue("fiRangeTo":U).
    /* If a record is available in browser */
    DO iLoop = 1 TO ghSecBrowse:NUM-SELECTED-ROWS:
      ghSecBrowse:FETCH-SELECTED-ROW(iLoop).
      IF ghSecBuffer:AVAILABLE THEN DO:
        ghSecBuffer:BUFFER-FIELD("cFromValue":U):BUFFER-VALUE = cFromValue.
        ghRangeFromCol:SCREEN-VALUE = cFromValue.
        ghSecBuffer:BUFFER-FIELD("cToValue":U):BUFFER-VALUE = cToValue.
        ghRangeToCol:SCREEN-VALUE = cToValue.
      END.
    END.
  END.
  
  IF glUserDataSec THEN DO:
      cSecured = widgetValue("raFieldSecType":U).
      /* If a record is available in browser */
      DO iLoop = 1 TO ghSecBrowse:NUM-SELECTED-ROWS:
        ghSecBrowse:FETCH-SELECTED-ROW(iLoop).
        IF ghSecBuffer:AVAILABLE 
        THEN DO:
            ghSecBuffer:BUFFER-FIELD("cSecured":U):BUFFER-VALUE = (cSecured = "YES":U).
            ghSecuredCol:SCREEN-VALUE = cSecured.
        END.
      END.
  END.

  ghSecBrowse:FETCH-SELECTED-ROW(1).
  
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFilters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilters Procedure 
PROCEDURE applyFilters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttFilterData.

  DEFINE VARIABLE cFilterFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterValues               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterTypes                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperators            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBaseQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityMnemonic             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserID                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoginCompany               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHighChar                   AS CHARACTER  NO-UNDO.

  cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).

  /* Process each record in ttLookupFilt and construct delimited strings of field name, datatypes, operators,
     and data values for filter 'from' and 'to' criteria in order to send as parameters to newQueryString function call below */
  filter-loop:
  FOR EACH ttFilterData:
    IF ttFilterData.cFromValue = "":U AND ttFilterData.cToValue = "":U THEN NEXT filter-loop.

    IF ttFilterData.cFromValue <> "":U THEN
    DO:
      ASSIGN
        iLoop = iLoop + 1
        cFilterFields = cFilterFields +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        (IF ttFilterData.cTableName <> "":U THEN ttFilterData.cTableName + ".":U ELSE "":U) + ttFilterData.cFieldName
        cFilterTypes = cFilterTypes +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        ttFilterData.cDataType
        cFilterOperators = cFilterOperators +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        ">=":U
        cFilterValues = cFilterValues +
                        (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                        ttFilterData.cFromValue
        .
    END. /* IF ttFilterData.cFromValue <> "":U */

    IF ttFilterData.cToValue <> "":U THEN
    DO:
      ASSIGN
        iLoop = iLoop + 1
        cFilterFields = cFilterFields +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        (IF ttFilterData.cTableName <> "":U THEN ttFilterData.cTableName + ".":U ELSE "":U) + ttFilterData.cFieldName
        cFilterTypes = cFilterTypes +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        ttFilterData.cDataType
        cFilterOperators = cFilterOperators +
                        (IF iLoop = 1 THEN "":U ELSE ",":U) +
                        "<=":U
        cFilterValues = cFilterValues +
                        (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                        ttFilterData.cToValue
        .
        IF ttFilterData.cDataType = "Character":U THEN cFilterValues = cFilterValues + cHighChar.
    END. /* IF ttFilterData.cToValue <> "":U */

  END. /* FOR EACH ttFilterData */

  ASSIGN gcNonSecLastRowId = ?.
  IF cFilterFields <> "":U THEN
    ASSIGN gcFilterData = cFilterFields + CHR(4) + 
                          cFilterValues + CHR(4) + 
                          cFilterTypes  + CHR(4) +
                          cFilterOperators.
  ELSE 
    gcFilterData = "":U.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  {launch.i      &PLIP  = 'af/app/secgetdata.p'
                 &IPROC = 'getSecurityData'
                 &onApp = 'yes'
                 &PLIST = "(INPUT  gdUserObj,
                            INPUT  gdCompanyObj,
                            INPUT  gcEntity,
                            INPUT  FALSE,
                            INPUT  glDataSecurity,
                            INPUT  giRowsToBatch,
                            INPUT  FALSE,
                            INPUT  ?,
                            INPUT  gcFilterData,
                            OUTPUT gcNonSecLastRowId,
                            OUTPUT glNonSecQryComp,
                            OUTPUT TABLE-HANDLE ghNonSecTable)"
                 &Define-only = NO
                 &autokill = YES}

  IF ghNonSecQuery:IS-OPEN THEN ghNonSecQuery:QUERY-CLOSE().
  
  /* Now that we applied the filter, we need to check for records that is on
     the Secured side, but wasn't commited yet - this will ensure that we
     do not create duplicates on the Secured side */
  RUN removeDuplicates IN TARGET-PROCEDURE.
  ghNonSecQuery:QUERY-OPEN().
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-browseEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEnd Procedure 
PROCEDURE browseEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcBrowseCode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iOldRows AS INTEGER    NO-UNDO.
  ASSIGN iOldRows      = giRowsToBatch
         giRowsToBatch = 1000000.

  RUN browseOffEnd IN TARGET-PROCEDURE (INPUT pcBrowseCode).
  giRowsToBatch = iOldRows.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-browseOffEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseOffEnd Procedure 
PROCEDURE browseOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcBrowseCode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE rLastRowId AS ROWID      NO-UNDO.
  
  IF pcBrowseCode = "NONSEC":U THEN DO:
    IF glNonSecQryComp THEN
      RETURN.
    rLastRowid = ?.
    IF VALID-HANDLE(ghNonSecQuery) THEN DO:
      ghNonSecQuery:GET-LAST() NO-ERROR.
      IF ghNonSecBuffer:AVAILABLE THEN
        rLastRowid = ghNonSecBuffer:ROWID.
    END.
    /* Could not use dynlaunch.i since we cannot have the APPEND attribute on
       the OUTPUT TABLE-HANDLE parameter */
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {launch.i      &PLIP  = 'af/app/secgetdata.p'
                   &IPROC = 'getSecurityData'
                   &onApp = 'yes'
                   &PLIST = "(INPUT  gdUserObj,
                              INPUT  gdCompanyObj,
                              INPUT  gcEntity,
                              INPUT  FALSE,
                              INPUT  glDataSecurity,
                              INPUT  giRowsToBatch,
                              INPUT  FALSE,
                              INPUT  gcNonSecLastRowId,
                              INPUT  gcFilterData,
                              OUTPUT gcNonSecLastRowId,
                              OUTPUT glNonSecQryComp,
                              OUTPUT TABLE-HANDLE ghNonSecTable APPEND)"
                   &Define-only = NO
                   &autokill = YES}

    IF ghNonSecQuery:IS-OPEN THEN ghNonSecQuery:QUERY-CLOSE().
    
    ghNonSecQuery:QUERY-OPEN().
    IF rLastRowid <> ? THEN
      ghNonSecQuery:REPOSITION-TO-ROWID(rLastRowid) NO-ERROR.
    SESSION:SET-WAIT-STATE("":U).
  END.
  ELSE DO:
    IF glSecQryComp THEN
      RETURN.
    rLastRowid = ?.
    IF VALID-HANDLE(ghNonSecQuery) THEN DO:
      ghNonSecQuery:GET-LAST() NO-ERROR.
      IF ghNonSecBuffer:AVAILABLE THEN
        rLastRowid = ghNonSecBuffer:ROWID.
    END.
    /* Could not use dynlaunch.i since we cannot have the APPEND attribute on
       the OUTPUT TABLE-HANDLE parameter */
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {launch.i      &PLIP  = 'af/app/secgetdata.p'
                   &IPROC = 'getSecurityData'
                   &onApp = 'yes'
                   &PLIST = "(INPUT  gdUserObj,
                              INPUT  gdCompanyObj,
                              INPUT  gcEntity,
                              INPUT  TRUE, /* Secured data */
                              INPUT  glDataSecurity,
                              INPUT  giRowsToBatch,
                              INPUT  FALSE,
                              INPUT  gcSecLastRowId,
                              INPUT  gcFilterData,
                              OUTPUT gcSecLastRowId,
                              OUTPUT glSecQryComp,
                              OUTPUT TABLE-HANDLE ghSecTable APPEND)"
                   &Define-only = NO
                   &autokill = YES}

    IF ghSecQuery:IS-OPEN THEN ghSecQuery:QUERY-CLOSE().
    
    ghSecQuery:QUERY-OPEN().
    
    RUN buildAllocList IN TARGET-PROCEDURE (INPUT TRUE, INPUT rLastRowid).
    
    IF rLastRowid <> ? THEN
      ghSecQuery:REPOSITION-TO-ROWID(rLastRowid) NO-ERROR.
    SESSION:SET-WAIT-STATE("":U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAllocList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildAllocList Procedure 
PROCEDURE buildAllocList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will build a temp-table containing all the records
               that were allocations before we started to make changes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plClearTT AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER prRowId   AS ROWID      NO-UNDO.

  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop  AS INTEGER    NO-UNDO.

  IF plClearTT THEN
    EMPTY TEMP-TABLE ttDeletedAllocations.

  IF NOT VALID-HANDLE(ghSecQuery) THEN
    RETURN.
    
  IF prRowId <> ? THEN DO:
    ghSecQuery:REPOSITION-TO-ROWID(prRowId) NO-ERROR.
    ghSecQuery:GET-NEXT().
  END.
  ELSE
    ghSecQuery:GET-FIRST().

  hField = ghSecBuffer:BUFFER-FIELD("dSecurity_structure_obj":U) NO-ERROR.
  IF NOT VALID-HANDLE(hField) THEN DO:
    DO iLoop = 1 TO ghSecBuffer:NUM-FIELDS:
      IF INDEX(ghSecBuffer:BUFFER-FIELD(iLoop):NAME,gcEntityObjField) > 0 THEN DO:
        hField = ghSecBuffer:BUFFER-FIELD(iLoop).
        LEAVE.
      END.
    END.
  END.

  IF NOT VALID-HANDLE(hField) THEN DO:
    MESSAGE "Can't get Key field for Secured Data Buffer" SKIP
            ghSecBuffer:BUFFER-FIELD(1):NAME.
    RETURN.
  END.
  
  DO WHILE ghSecBuffer:AVAILABLE:
    FIND FIRST ttDeletedAllocations
         WHERE ttDeletedAllocations.dOwningObj = hField:BUFFER-VALUE
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttDeletedAllocations THEN DO:
      CREATE ttDeletedAllocations.
      ASSIGN ttDeletedAllocations.dOwningObj = hField:BUFFER-VALUE.
    END.
    ghSecQuery:GET-NEXT().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseButton Procedure 
PROCEDURE chooseButton :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcButton AS CHARACTER  NO-UNDO.
    
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  {get ContainerSource hContainerSource}.
  
  PUBLISH "DataChanged":U FROM hContainerSource.

  CASE pcButton:
    WHEN "Add":U THEN
      RUN addSelected IN TARGET-PROCEDURE.
    WHEN "AddAll":U THEN
      RUN addAll IN TARGET-PROCEDURE.
    WHEN "Remove":U THEN
      RUN RemoveSelected IN TARGET-PROCEDURE.
    WHEN "RemoveAll":U THEN
      RUN RemoveAll IN TARGET-PROCEDURE.
    WHEN "Apply":U THEN
      RUN applyFieldSecurity IN TARGET-PROCEDURE.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-companyAllocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE companyAllocation Procedure 
PROCEDURE companyAllocation :
/*------------------------------------------------------------------------------
  Purpose:     When published it tels us that we are assigning login companies
               to groups.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  
  {get ContainerSource hContainer}.

  IF VALID-HANDLE(ghNonSecBrowse) THEN
    ghNonSecBrowse:TITLE = "Available Login Companies".
  
  IF VALID-HANDLE(ghSecBrowse) THEN
    ghSecBrowse:TITLE = "Applies to Login Companies".

  ghSecBuffer:FIND-FIRST() NO-ERROR.
  IF NOT ghSecBuffer:AVAILABLE THEN
    PUBLISH "allSelected":U FROM hContainer (INPUT TRUE).
  ELSE
    PUBLISH "allSelected":U FROM hContainer (INPUT FALSE).
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNonSecBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createNonSecBrowse Procedure 
PROCEDURE createNonSecBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Create the browse for the Non Secured Data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hButton                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldChars               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldChars               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSortColumn               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSortBy                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  /* Construct query for dynamic temp table */
  CREATE QUERY ghNonSecQuery.
  ghNonSecQuery:ADD-BUFFER(ghNonSecBuffer).

  {get ContainerHandle hFrame}.
  hButton = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAdd":U, "ALL":U).

  CREATE BROWSE ghNonSecBrowse
     ASSIGN FRAME            = hFrame
            ROW              = 1
            COL              = 1
            WIDTH-CHARS      = hButton:COL - 1.5
            HEIGHT-CHARS     = hFrame:HEIGHT-CHARS - ghNonSecBrowse:ROW + .8
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = TRUE
            READ-ONLY        = FALSE
            MULTIPLE         = TRUE
            QUERY            = ghNonSecQuery
            TITLE            = "Available " + gcEntityName
      /* Set procedures to handle browser events */
      TRIGGERS:
        ON END
           PERSISTENT RUN browseEnd      IN TARGET-PROCEDURE (INPUT "NONSEC":U).
        ON OFF-END
           PERSISTENT RUN browseOffEnd   IN TARGET-PROCEDURE (INPUT "NONSEC":U).
        ON START-SEARCH
           PERSISTENT RUN startSearch    IN TARGET-PROCEDURE (INPUT "NONSEC":U).
        ON MOUSE-SELECT-CLICK,
           VALUE-CHANGED,
           SELECTION
           PERSISTENT RUN setButtonState IN TARGET-PROCEDURE (INPUT "NONSEC":U).
      END TRIGGERS.
  
  /* Hide the dynamic browser while it is being constructed */
  ASSIGN
     ghNonSecBrowse:VISIBLE   = NO
     ghNonSecBrowse:SENSITIVE = NO.

  cFieldList = "":U.
  DO iLoop = 1 TO ghNonSecBuffer:NUM-FIELDS:
    hCurField = ghNonSecBuffer:BUFFER-FIELD(iLoop).
    /* Do not include any _obj fields in browser */
    IF INDEX(hCurField:NAME,"_obj":U) > 0 AND
       SUBSTRING(hCurField:NAME,LENGTH(hCurField:NAME) - 3,4) = "_obj":U THEN
      NEXT.                                      
    /* This field has no meaning for data without security */
    IF hCurField:NAME = "cSecurityType":U OR
       hCurField:NAME = "cFromValue":U OR 
       hCurField:NAME = "cToValue":U OR 
       hCurField:NAME = "cSecured":U THEN
      NEXT.

    cFieldList = IF cFieldList = "":U THEN hCurField:NAME 
                                      ELSE cFieldList + ",":U + hCurField:NAME.
  END.
  
  /* Check if we are allocating structures */
  IF LOOKUP("cProdMod":U,cFieldList) > 0 THEN
    ASSIGN cFieldList          = REPLACE(cFieldList,",cProdMod":U,"":U)
           ENTRY(2,cFieldList) = "cProdMod,":U + ENTRY(2,cFieldList).
  IF LOOKUP("cObject":U,cFieldList) > 0 THEN
    ASSIGN cFieldList          = REPLACE(cFieldList,",cObject":U,"":U)
           ENTRY(3,cFieldList) = "cObject,":U + ENTRY(3,cFieldList).
  IF LOOKUP("cInstanceAttr":U,cFieldList) > 0 THEN
    ASSIGN cFieldList          = REPLACE(cFieldList,",cInstanceAttr":U,"":U)
           ENTRY(4,cFieldList) = "cInstanceAttr,":U + ENTRY(4,cFieldList).
  
  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO NUM-ENTRIES(cFieldList):
    hCurField = ghNonSecBuffer:BUFFER-FIELD(ENTRY(iLoop,cFieldList)).
    IF hSortColumn = ? OR
       NOT VALID-HANDLE(hSortColumn) THEN
      hSortColumn = hCurField.

    ASSIGN hCurField:VALIDATE-EXPRESSION = "".

    /* Check that Character format is never bigger than x(50) */
    IF hCurField:DATA-TYPE = "CHARACTER":U THEN DO:
      ASSIGN cFieldChars = TRIM(hCurField:FORMAT,"x(":U)
             cFieldChars = RIGHT-TRIM(cFieldChars,")":U).
      ASSIGN iFieldChars = INTEGER(cFieldChars) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        IF iFieldChars > 50 THEN
          ASSIGN hCurField:FORMAT = "x(50)":U.
      ERROR-STATUS:ERROR = FALSE.
    END.
    hField = ghNonSecBrowse:ADD-LIKE-COLUMN(hCurField).
    /* Make sure the first column isn't to wide, otherwise the user
       will not see the other fields scrolling */
    IF iLoop = 1 AND
       hField:DATA-TYPE = "CHARACTER":U AND
       iFieldChars >= 35 THEN
    hField:WIDTH = 30.
  END. /* DO iLoop = 1 TO ghNonSecBuffer:NUM-FIELDS */

  /* Lock first column of dynamic browser */
  ghNonSecBrowse:NUM-LOCKED-COLUMNS = 1. 

  /* Set query initial sort on col 1 */
  IF VALID-HANDLE(hSortColumn) THEN
    ASSIGN cSortBy = (IF hSortColumn:TABLE <> ? THEN
                         hSortColumn:TABLE + '.':U + hSortColumn:NAME
                      ELSE hSortColumn:NAME).

  /* Build query string */
  ASSIGN cQuery = "FOR EACH ":U + ghNonSecBuffer:NAME + " NO-LOCK":U.
  IF cSortBy <> "":U THEN
    cQuery = cQuery + " BY " + cSortBy.
  ghNonSecQuery:QUERY-PREPARE(cQuery).


  /* Open the query for the browser */
  ghNonSecQuery:QUERY-OPEN().

  /* Show the browser */
  ASSIGN
     ghNonSecBrowse:VISIBLE   = YES
     ghNonSecBrowse:SENSITIVE = YES.

  /*
  /* Reposition to first record in browser */
  IF NUM-ENTRIES(ttQueryParams.cFirstResultRow,";":U) > 1 THEN
     ASSIGN cRowIdent = ENTRY(2, ttQueryParams.cFirstResultRow,";":U).
  RUN repositionBrowse IN TARGET-PROCEDURE (INPUT cRowIdent).
  */
  IF VALID-HANDLE(ghNonSecBrowse) THEN
     APPLY "ENTRY":U TO ghNonSecBrowse.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSecBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createSecBrowse Procedure 
PROCEDURE createSecBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Create the browse for the Secured Data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hButton                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldChars               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldChars               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSortColumn               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSortBy                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRect                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iFieldCnt                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSetWidthSmall            AS LOGICAL    NO-UNDO.

  /* Construct query for dynamic temp table */
  CREATE QUERY ghSecQuery.
  ghSecQuery:ADD-BUFFER(ghSecBuffer).

  {get ContainerHandle hFrame}.
  hButton = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAdd":U, "ALL":U).
  hRect   = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"rFieldRect":U, "ALL":U).

  CREATE BROWSE ghSecBrowse
     ASSIGN FRAME            = hFrame
            ROW              = 1
            COL              = hButton:COL + hButton:WIDTH + .5
            WIDTH-CHARS      = hFrame:WIDTH - (hButton:COL + hButton:WIDTH + .5)
            HEIGHT-CHARS     = (IF (glFieldSecurity OR glRangeSecurity OR glUserDataSec) THEN (hRect:ROW - .2) ELSE hFrame:HEIGHT-CHARS) - ghSecBrowse:ROW + 1
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = TRUE
            READ-ONLY        = FALSE
            MULTIPLE         = TRUE
            QUERY            = ghSecQuery
            TITLE            = IF glUserDataSec
                               THEN "User specific allocations - " + gcEntityName
                               ELSE gcGrantRevoke + " ":U + gcEntityName
      /* Set procedures to handle browser events */
      TRIGGERS:
        ON END
           PERSISTENT RUN browseEnd      IN TARGET-PROCEDURE (INPUT "SEC":U).
        ON OFF-END
           PERSISTENT RUN browseOffEnd   IN TARGET-PROCEDURE (INPUT "SEC":U).
        ON ROW-LEAVE
           PERSISTENT RUN rowLeave       IN TARGET-PROCEDURE.
        ON START-SEARCH
           PERSISTENT RUN startSearch    IN TARGET-PROCEDURE (INPUT "SEC":U).
        ON MOUSE-SELECT-CLICK,
           VALUE-CHANGED,
           SELECTION
           PERSISTENT RUN setButtonState IN TARGET-PROCEDURE (INPUT "SEC":U).
      END TRIGGERS.

  /* Hide the dynamic browser while it is being constructed */
  ASSIGN
     ghSecBrowse:VISIBLE   = NO
     ghSecBrowse:SENSITIVE = NO.

  cFieldList = "":U.
  DO iLoop = 1 TO ghNonSecBuffer:NUM-FIELDS:
    hCurField = ghNonSecBuffer:BUFFER-FIELD(iLoop).
    /* Do not include any _obj fields in browser */
    IF INDEX(hCurField:NAME,"_obj":U) > 0 AND
       SUBSTRING(hCurField:NAME,LENGTH(hCurField:NAME) - 3,4) = "_obj":U THEN
      NEXT.
    cFieldList = IF cFieldList = "":U THEN hCurField:NAME 
                                      ELSE cFieldList + ",":U + hCurField:NAME.
  END.

  /* Move important fields to the left hand columns */
  IF LOOKUP("cProdMod":U,cFieldList) > 0 
  THEN DO:
      ASSIGN cFieldList          = REPLACE(cFieldList,",cProdMod":U,"":U)
             ENTRY(2,cFieldList) = "cProdMod,":U + ENTRY(2,cFieldList)
             cFieldList          = REPLACE(cFieldList,",cObject":U,"":U)
             ENTRY(3,cFieldList) = "cObject,":U + ENTRY(3,cFieldList)
             cFieldList          = REPLACE(cFieldList,",cInstanceAttr":U,"":U)
             ENTRY(4,cFieldList) = "cInstanceAttr,":U + ENTRY(4,cFieldList)
             iFieldCnt           = 5.

      IF LOOKUP("cSecurityType":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cSecurityType":U,"":U)
                 ENTRY(iFieldCnt,cFieldList) = "cSecurityType,":U + ENTRY(iFieldCnt,cFieldList)
                 iFieldCnt                   = iFieldCnt + 1.
      IF LOOKUP("cFromValue":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cFromValue":U,"":U)
                 ENTRY(iFieldCnt,cFieldList) = "cFromValue,":U + ENTRY(iFieldCnt,cFieldList)
                 iFieldCnt                   = iFieldCnt + 1.
      IF LOOKUP("cToValue":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cToValue":U,"":U)
                 ENTRY(iFieldCnt,cFieldList) = "cToValue,":U + ENTRY(iFieldCnt,cFieldList)
                 iFieldCnt                   = iFieldCnt + 1.
  END.
  ELSE
      IF LOOKUP("cSecured":U,cFieldList) > 0 THEN
          ASSIGN cFieldList                  = REPLACE(cFieldList,",cSecured":U,"":U)
                 ENTRY(3,cFieldList)         = "cSecured,":U + ENTRY(3,cFieldList).

  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO NUM-ENTRIES(cFieldList):
    hCurField = ghSecBuffer:BUFFER-FIELD(ENTRY(iLoop,cFieldList)).
    IF hSortColumn = ? OR
       NOT VALID-HANDLE(hSortColumn) THEN
      hSortColumn = hCurField.

    ASSIGN hCurField:VALIDATE-EXPRESSION = "".

    /* Check that Character format is never bigger than x(50) */
    IF hCurField:DATA-TYPE = "CHARACTER":U THEN DO:
      ASSIGN cFieldChars = TRIM(hCurField:FORMAT,"x(":U)
             cFieldChars = RIGHT-TRIM(cFieldChars,")":U).
      ASSIGN iFieldChars = INTEGER(cFieldChars) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
          ASSIGN lSetWidthSmall = iFieldChars > 50.
      ERROR-STATUS:ERROR = FALSE.
    END.
    hField = ghSecBrowse:ADD-LIKE-COLUMN(hCurField).

    /* Enable Security Type Field */
    IF hField:NAME = "cSecurityType":U OR
       hField:NAME = "cFromValue":U OR 
       hField:NAME = "cToValue":U OR
       hField:NAME = "cSecured":U 
    THEN DO:
      ASSIGN hField:READ-ONLY = FALSE.
      CASE hField:NAME:
        WHEN "cSecurityType":U THEN
          ghSecTypeCol = hField.
        WHEN "cFromValue":U THEN
          ghRangeFromCol = hField.
        WHEN "cToValue":U THEN
          ghRangeToCol = hField.
        WHEN "cSecured":U THEN
          ghSecuredCol = hField.
      END CASE.
      IF VALID-HANDLE(ghSecTypeCol) THEN
        ON ANY-PRINTABLE OF ghSecTypeCol PERSISTENT RUN setScreenValue IN TARGET-PROCEDURE.
      IF VALID-HANDLE(ghRangeFromCol) THEN
        ON VALUE-CHANGED OF ghRangeFromCol PERSISTENT RUN setScreenValue IN TARGET-PROCEDURE.
      IF VALID-HANDLE(ghRangeToCol) THEN
        ON VALUE-CHANGED OF ghRangeToCol PERSISTENT RUN setScreenValue IN TARGET-PROCEDURE.
      IF VALID-HANDLE(ghSecuredCol) THEN
        ON VALUE-CHANGED OF ghSecuredCol PERSISTENT RUN setScreenValue IN TARGET-PROCEDURE.
    END.
    IF lSetWidthSmall = YES THEN
        ASSIGN hField:WIDTH = 30.

    /* Make sure the first column isn't to wide, otherwise the user
       will not see the other fields scrolling */
    IF iLoop = 1 AND
       hField:WIDTH <> 30 AND
       hField:DATA-TYPE = "CHARACTER":U AND
       iFieldChars >= 35 THEN
    hField:WIDTH = 30.
  END. /* DO iLoop = 1 TO ghSecBuffer:NUM-FIELDS */

  /* Lock first column of dynamic browser */
  ghSecBrowse:NUM-LOCKED-COLUMNS = 1.

  /* Set query initial sort on col 1 */
  IF VALID-HANDLE(hSortColumn) THEN
    ASSIGN cSortBy = (IF hSortColumn:TABLE <> ? THEN
                         hSortColumn:TABLE + '.':U + hSortColumn:NAME
                      ELSE hSortColumn:NAME).

  /* Build query string */
  ASSIGN cQuery = "FOR EACH ":U + ghSecBuffer:NAME.
  IF cSortBy <> "":U THEN
    cQuery = cQuery + " BY " + cSortBy.
  ghSecQuery:QUERY-PREPARE(cQuery).


  /* Open the query for the browser */
  ghSecQuery:QUERY-OPEN().

  /* Show the browser */
  ASSIGN
     ghSecBrowse:VISIBLE   = YES
     ghSecBrowse:SENSITIVE = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghNonSecBrowse) THEN
    DELETE OBJECT ghNonSecBrowse.
  IF VALID-HANDLE(ghNonSecQuery) THEN
    DELETE OBJECT ghNonSecQuery.
  IF VALID-HANDLE(ghNonSecTable) THEN
    DELETE OBJECT ghNonSecTable.

  IF VALID-HANDLE(ghSecBrowse) THEN
    DELETE OBJECT ghSecBrowse.
  IF VALID-HANDLE(ghSecQuery) THEN
    DELETE OBJECT ghSecQuery.
  IF VALID-HANDLE(ghSecTable) THEN
    DELETE OBJECT ghSecTable.

  /* Published by Security Control */
  UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "securityModelUpdated":U IN gshSecurityManager.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSecurityModel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.

  {set hideOnInit TRUE}.

  {get containerSource hContainerSource}.

  ghFilterViewer = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "SecFilter-target":U)).

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "confirmExit":U IN TARGET-PROCEDURE.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateSecurity":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "companyAllocation":U IN hContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "securityModelUpdated":U IN gshSecurityManager. /* Published by Security Control */

  RUN SUPER.
  
  cSecurityModel = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "SecurityModel":U, INPUT YES).

  IF cSecurityModel = "":U OR
     cSecurityModel = ? OR
     cSecurityModel = "REVOKE":U THEN
    ASSIGN gcGrantRevoke = "Restricted"
           glRevoke      = TRUE.
  ELSE
    ASSIGN gcGrantRevoke = "Granted"
           glRevoke      = FALSE.
  
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buAddAll":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buRemoveAll":U).

  /* Disable extra widgets for Field Security */
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
  
  /* Disable extra widgets for Range Security */
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  
  /* Hide extra widgets for Field Security */
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).

  /* Hide extra widgets for Range Security */
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  
  PUBLISH "InitializationDone":U FROM hContainerSource.

  RUN viewObject IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQueryDetail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQueryDetail Procedure 
PROCEDURE refreshQueryDetail :

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCompanyObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntity        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plDataSecurity  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToBatch   AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dLoginUser          AS DECIMAL    NO-UNDO.
  define variable lSecurityRestricted as logical no-undo.
  define variable cSecurityValue1     as character no-undo.
  define variable cSecurityValue2     as character no-undo.
  define variable cButtonPressed      as character no-undo.
  
  IF pcEntity = "":U OR 
     pcEntity = ? THEN
    RETURN.
    
  dLoginUser        = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj":U,
                                                INPUT NO)) NO-ERROR.
                          
  /* if user has access to selected user then check if user has
  access to selected company */                                              
  if pdCompanyObj <> 0 then 
  do: 
     RUN userSecurityCheck IN gshSecurityManager (INPUT dLoginUser,
                                                  INPUT 0,                      /* All companies */
                                                  INPUT "gsmlg":U,              /* login company FLA */
                                                  pdCompanyObj,
                                                  INPUT NO,                     /* Return security values - NO */
                                                  OUTPUT lSecurityRestricted,   /* Restricted yes/no ? */
                                                  OUTPUT cSecurityValue1,       /* clearance value 1 */
                                                  OUTPUT cSecurityValue2).      /* clearance value 2 */    
     IF lSecurityRestricted THEN 
     DO:
       run showMessages in gshSessionManager ({errortxt.i 'AF' '40' '?' '?' '"User does not have access to selected login company"'},
                                              'INF',
                                              '&Ok',
                                              '&Ok',
                                              '&Ok',
                                              '',
                                              Yes,
                                              ?,
                                              output cButtonPressed) no-error.
       RETURN.
     END.
   end.                                 

  IF VALID-HANDLE(ghNonSecBrowse) THEN
    DELETE OBJECT ghNonSecBrowse.
  IF VALID-HANDLE(ghNonSecQuery) THEN
    DELETE OBJECT ghNonSecQuery.
  IF VALID-HANDLE(ghSecBrowse) THEN
    DELETE OBJECT ghSecBrowse.
  IF VALID-HANDLE(ghSecQuery) THEN
    DELETE OBJECT ghSecQuery.
  IF VALID-HANDLE(ghNonSecTable) THEN
    DELETE OBJECT ghNonSecTable.
  IF VALID-HANDLE(ghSecTable) THEN
    DELETE OBJECT ghSecTable.

  ASSIGN gdUserObj     = pdUserObj    
         gdCompanyObj  = pdCompanyObj 
         giRowsToBatch = piRowsToBatch
         gcEntity      = pcEntity
         gcEntityName  = pcEntityName.

  ASSIGN glRangeSecurity = FALSE
         glFieldSecurity = FALSE
         glUserDataSec   = FALSE.

  /* Check for Field Security */
  IF pcEntity = "GSMFF":U THEN
    glFieldSecurity = TRUE.
    
  /* Check for Range Security */
  IF pcEntity = "GSMRA":U THEN
    glRangeSecurity = TRUE.
  
  glDataSecurity = plDataSecurity.

  /* Hour glass ON */
  SESSION:SET-WAIT-STATE("general":U).

  ERROR-STATUS:ERROR = FALSE.

  /* Go and fetch the data */
  {
   launch.i &PLIP  = 'af/app/secgetdata.p'
            &IPROC = 'getSecurityDataAll'
            &onApp = 'yes'
            &PLIST = "(INPUT pdUserObj,
                       INPUT pdCompanyObj,
                       INPUT pcEntity,
                       INPUT glDataSecurity,
                       INPUT piRowsToBatch,
                       INPUT FALSE,
                       INPUT gcFilterData,
                       OUTPUT gcNonSecLastRowID,
                       OUTPUT gcSecLastRowId,
                       OUTPUT glNonSecQryComp,  
                       OUTPUT glSecQryComp,
                       OUTPUT TABLE-HANDLE ghNonSecTable,
                       OUTPUT TABLE-HANDLE ghSecTable)"
            &Define-only = NO
            &autokill = YES
  }

  IF ERROR-STATUS:ERROR 
  OR RETURN-VALUE <> "":U 
  THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    cMessageList = RETURN-VALUE.
    IF cMessageList <> "":U THEN
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).

    RETURN.
  END.

  ASSIGN gcEntityObjField = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager, 
                                             INPUT (IF gcEntity = "GSMGA":U THEN "GSMLG":U ELSE gcEntity)).

  /* This should never be, but just in case it is - this is checked in
     the getSecurityData procedure in af/app/secgetdata.p */
  IF gcEntityObjField = "":U OR gcEntityObjField = ? THEN
    RETURN.
  
  /* If we can find field cSecured in the temp-table buffer, we know we're allocating data security at user level. *
   * The field will be there because users can specify a YES/NO when the object is secured.                        */   
  ASSIGN glUserDataSec = VALID-HANDLE(ghSecTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("cSecured":U)) NO-ERROR.

  IF VALID-HANDLE(ghNonSecBrowse) THEN
    DELETE OBJECT ghNonSecBrowse.
  IF VALID-HANDLE(ghSecBrowse) THEN
    DELETE OBJECT ghSecBrowse.
  
  IF VALID-HANDLE(ghNonSecQuery) THEN
    DELETE OBJECT ghNonSecQuery.
  IF VALID-HANDLE(ghSecQuery) THEN
    DELETE OBJECT ghSecQuery.
  
  IF VALID-HANDLE(ghNonSecTable) THEN
    ASSIGN ghNonSecBuffer = ghNonSecTable:DEFAULT-BUFFER-HANDLE.
  
  IF VALID-HANDLE(ghSecTable) THEN
    ASSIGN ghSecBuffer = ghSecTable:DEFAULT-BUFFER-HANDLE.

  RUN createNonSecBrowse IN TARGET-PROCEDURE.
  RUN createSecBrowse IN TARGET-PROCEDURE.
    
  RUN buildAllocList IN TARGET-PROCEDURE (INPUT TRUE, INPUT ?).

  IF VALID-HANDLE(ghFilterViewer) THEN
    RUN buildFilter IN ghFilterViewer (INPUT ghNonSecBuffer).
  
  {get ContainerSource hContainerSource}.
  {get PageSource hFolderHandle hContainerSource}.

  /* Enable second Tab Page */
  RUN enableFolderPage IN hFolderHandle (INPUT 2).

  DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiStartLabel":U).
  DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
  DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buAddAll":U).
  DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
  DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buRemoveAll":U).

  IF glFieldSecurity THEN DO:
    RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  END.
  
  IF glRangeSecurity THEN DO:
    RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
  END.
  
  IF glUserDataSec THEN DO:
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"raFieldSecType":U, "ALL":U)
             hWidget:RADIO-BUTTONS = IF glRevoke 
                                     THEN "Revoke access,YES,Not secured,NO":U
                                     ELSE "Grant access,NO,No access,YES":U
             hWidget:WIDTH         = 25
             hWidget:TOOLTIP       = "Select the type of security to apply to the selected object(s)"
             hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiFieldName":U, "ALL":U).
      RUN setLabel IN TARGET-PROCEDURE (INPUT hWidget, INPUT "Object":U).

      RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  END.

  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buAddAll":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
  DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buRemoveAll":U).

  /* Set the default button state */
  IF VALID-HANDLE(ghNonSecBuffer) THEN DO:
    ghNonSecBuffer:FIND-FIRST() NO-ERROR.
    IF ghNonSecBuffer:AVAILABLE THEN
      DYNAMIC-FUNCTION("enableWidget":U IN TARGET-PROCEDURE, INPUT "buAddAll":U).
  END.
  IF VALID-HANDLE(ghSecBuffer)THEN DO:
    ghSecBuffer:FIND-FIRST() NO-ERROR.
    IF ghSecBuffer:AVAILABLE THEN
      DYNAMIC-FUNCTION("enableWidget":U IN TARGET-PROCEDURE, INPUT "buRemoveAll":U).
  END.

  /* We could have display fields for the browser.  Force a 'value-changed' to make sure the fields display the info for the correct record */
  IF VALID-HANDLE(ghSecBrowse)
  THEN DO:
      ghSecBrowse:SELECT-ROW(1) NO-ERROR.
      APPLY "value-changed":U TO ghSecBrowse.
      ghSecBrowse:SELECT-ROW(1) NO-ERROR.
  END.

  /* Hour glass OFF */
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeAll Procedure 
PROCEDURE removeAll :
/*------------------------------------------------------------------------------
  Purpose:     Copy all records from Secured Data browse to Non Secured Data
               Browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(ghSecQuery) THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /* First - we need to ensure we get all the records back from
     the database to select all */
  RUN browseEnd IN TARGET-PROCEDURE (INPUT "SEC":U).

  ghSecQuery:GET-FIRST().
  DO WHILE ghSecBuffer:AVAILABLE:
    ghNonSecBuffer:BUFFER-CREATE().
    ghNonSecBuffer:BUFFER-COPY(ghSecBuffer).
    ghSecBuffer:BUFFER-DELETE().
    ghSecQuery:GET-NEXT().
  END.

  ghSecQuery:QUERY-CLOSE().
  ghNonSecQuery:QUERY-CLOSE().
  ghSecQuery:QUERY-OPEN().
  ghNonSecQuery:QUERY-OPEN().
  ghNonSecQuery:REPOSITION-TO-ROW(1) NO-ERROR.
  disableWidget("buRemoveAll":U).
  enableWidget("buAddAll":U).
  
  assignWidgetValue("fiFieldName":U,"":U).

  RUN setButtonState IN TARGET-PROCEDURE (INPUT "NONSEC":U).
  RUN setButtonState IN TARGET-PROCEDURE (INPUT "SEC":U).
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDuplicates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDuplicates Procedure 
PROCEDURE removeDuplicates :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE     NO-UNDO.

  /* Check if this check is required */
  IF NOT ghSecQuery:NUM-RESULTS > 0 THEN
    RETURN.

  /* Get Key Field Handle */
  hField = ghSecBuffer:BUFFER-FIELD("dSecurity_structure_obj":U) NO-ERROR.
  IF NOT VALID-HANDLE(hField) THEN DO:
    DO iLoop = 1 TO ghSecBuffer:NUM-FIELDS:
      IF INDEX(ghSecBuffer:BUFFER-FIELD(iLoop):NAME,gcEntityObjField) > 0 THEN DO:
        hField = ghSecBuffer:BUFFER-FIELD(iLoop).
        LEAVE.
      END.
    END.
  END.

  /* This should never happen - just in case :-) */
  IF NOT VALID-HANDLE(hField) THEN
    RETURN.


  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(ghSecBuffer).

  hQuery:QUERY-PREPARE("FOR EACH ":U + ghSecBuffer:NAME + " NO-LOCK":U).
  hQuery:QUERY-OPEN().
  
  hQuery:GET-FIRST().
  DO WHILE ghSecBuffer:AVAILABLE:
    ghNonSecBuffer:FIND-FIRST("WHERE ":U + ghNonSecBuffer:NAME + ".":U + hField:NAME + " = ":U + QUOTER(hField:BUFFER-VALUE)) NO-ERROR.
    IF ghNonSecBuffer:AVAILABLE THEN
      ghNonSecBuffer:BUFFER-DELETE().
    hQuery:GET-NEXT().
  END.

  hQuery:QUERY-CLOSE().

  IF VALID-HANDLE(hQuery) THEN
    DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSelected Procedure 
PROCEDURE removeSelected :
/*------------------------------------------------------------------------------
  Purpose:     Copy Select Secured records to the Non Secured Data Browser
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  IF NOT VALID-HANDLE(ghSecBrowse) THEN
    RETURN.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  DO iLoop = 1 TO ghSecBrowse:NUM-SELECTED-ROWS:
    ghSecBrowse:FETCH-SELECTED-ROW(iLoop).
    IF ghSecBuffer:AVAILABLE THEN DO:
      ghNonSecBuffer:BUFFER-CREATE().
      ghNonSecBuffer:BUFFER-COPY(ghSecBuffer).
      ghSecBuffer:BUFFER-DELETE().
    END.
  END.
  
  ghNonSecQuery:QUERY-CLOSE().
  ghSecQuery:QUERY-CLOSE().
  ghNonSecQuery:QUERY-OPEN().
  ghSecQuery:QUERY-OPEN().
  ghNonSecQuery:REPOSITION-TO-ROW(1) NO-ERROR.

  ghNonSecQuery:GET-FIRST() NO-ERROR.
  IF ghNonSecBuffer:AVAILABLE THEN
    enableWidget("buAddAll":U).
  ELSE
    disableWidget("buAddAll":U).

  ghSecQuery:GET-FIRST() NO-ERROR.
  IF ghSecBuffer:AVAILABLE THEN
    enableWidget("buRemoveAll":U).
  ELSE
    disableWidget("buRemoveAll":U).

  RUN setButtonState IN TARGET-PROCEDURE (INPUT "NONSEC":U).
  RUN setButtonState IN TARGET-PROCEDURE (INPUT "SEC":U).
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionBrowse Procedure 
PROCEDURE repositionBrowse :
/*------------------------------------------------------------------------------
  Purpose:     To position the dynamic browser at specified record
  Parameters:  input string storing a rowIdent value
  Notes:
------------------------------------------------------------------------------*/
/*
    DEFINE INPUT PARAMETER pcRowIdent               AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE hRowQuery                       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lOk                             AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE rRowid                          AS ROWID      NO-UNDO.

    /* Create query and assign the buffer of the dynamic temp table used in the browser query */
    CREATE QUERY hRowQuery.
    lOK = hRowQuery:SET-BUFFERS(ghBuffer).

    /* Prepare query string to return records relating to the rowIdent parameter value - should only be one */
    IF lOK THEN
       lOK = hRowQuery:QUERY-PREPARE
               ('FOR EACH RowObject WHERE RowObject.RowIdent BEGINS "':U + pcRowIdent + '"':U).

    /* Open query and get first record */
    lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN
       lOK = hRowQuery:GET-FIRST().

    /* If record found the reposition the query of the dynamic browser to that record */
    IF ghBuffer:AVAILABLE THEN
    DO:
       rRowid  = ghBuffer:ROWID.
       lOK    = ghQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
    END.

    /* Clean up local query object */
    DELETE WIDGET hRowQuery.
    ASSIGN hRowQuery = ?.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Override procedure to add NO-ERROR to assignment of COL and ROW
               due to unexplained errors.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdRow AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCol AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.


  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    ASSIGN hContainer:ROW = pdRow
           hContainer:COL = pdCol NO-ERROR.
  ERROR-STATUS:ERROR = FALSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

  {get ContainerHandle hFrame}.
          
  ASSIGN gdLastSetWidth  = pdWidth
         gdLastSetHeight = pdHeight.
  
  IF NOT VALID-HANDLE(hFrame) THEN
    RETURN.
                       
  IF pdWidth <= 0 OR
    pdHeight <= 0 THEN 
    RETURN.

  IF pdWidth < hFrame:WIDTH OR 
     pdHeight < hFrame:HEIGHT THEN DO:
    /* Move All Widgets and then the frame */
    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE.
  END.
  ELSE DO:
    /* Move the frame and then the widgets */
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:WIDTH          = pdWidth
           hFrame:HEIGHT         = pdHeight
           hFrame:VIRTUAL-WIDTH  = pdWidth
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE.
    RUN resizeWidgets IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
  END.

  /* If the browse is HIDDEN, hide fields too */
  IF NOT VALID-HANDLE(ghSecBrowse)
  OR ghSecBrowse:HIDDEN
  OR NOT ghSecBrowse:VISIBLE
  THEN DO:
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buAddAll":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buRemoveAll":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
      RETURN.
  END.

  IF glFieldSecurity THEN DO:
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  END.
  
  IF glRangeSecurity THEN DO:
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
    DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
  END.
  
  IF glUserDataSec THEN DO:
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
      DYNAMIC-FUNCTION("viewWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
      DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  END.

  IF NOT glFieldSecurity AND 
     NOT glRangeSecurity AND
     NOT glUserDataSec THEN DO:
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "buApply":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "rFieldRect":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "raFieldSecType":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiFieldName":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeFrom":U).
    DYNAMIC-FUNCTION("hideWidget":U IN TARGET-PROCEDURE, INPUT "fiRangeTo":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWidgets Procedure 
PROCEDURE resizeWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hButton   AS HANDLE     NO-UNDO EXTENT 5.
  DEFINE VARIABLE dCentre   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLabel    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dLabelRow AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLabelCol AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hRect     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFldLabel AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRadioSet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFRngFrom AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLRngFrom AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFRngTo   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLRngTo   AS HANDLE     NO-UNDO.

  hButton[1] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAdd":U, "ALL":U).
  hButton[2] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buAddAll":U, "ALL":U).
  hButton[3] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buRemove":U, "ALL":U).
  hButton[4] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buRemoveAll":U, "ALL":U).
  hButton[5] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buApply":U, "ALL":U).
  hLabel     = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiStartLabel":U, "ALL":U).
  
  hRect      = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"rFieldRect":U, "ALL":U).
  hField     = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiFieldName":U, "ALL":U).
  hRadioSet  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"raFieldSecType":U, "ALL":U).

  hFRngFrom  = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiRangeFrom":U, "ALL":U).
  hFRngTo    = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"fiRangeTo":U, "ALL":U).

  IF VALID-HANDLE(hField) THEN
    hFldLabel = hField:SIDE-LABEL-HANDLE.
  
  IF VALID-HANDLE(hFRngFrom) THEN
    hLRngFrom = hFRngFrom:SIDE-LABEL-HANDLE.

  IF VALID-HANDLE(hFRngTo) THEN
    hLRngTo = hFRngTo:SIDE-LABEL-HANDLE.
  
  IF NOT VALID-HANDLE(hButton[1]) THEN 
    RETURN.
  
  /* Width Changes */
  ASSIGN dCentre   = pdWidth / 2
         dLabelRow = (pdHeight / 2) + 1
         dLabelCol = (pdWidth - hLabel:WIDTH) / 2.
  
  ASSIGN hButton[1]:COL = dCentre - (hButton[1]:WIDTH / 2)
         hButton[2]:COL = hButton[1]:COL
         hButton[3]:COL = hButton[1]:COL
         hButton[4]:COL = hButton[1]:COL
         hLabel:COL     = dLabelCol NO-ERROR.
  IF VALID-HANDLE(ghNonSecBrowse) AND 
     VALID-HANDLE(ghSecBrowse) THEN
    ASSIGN ghNonSecBrowse:WIDTH = hButton[1]:COL - 1.5
           ghSecBrowse:WIDTH    = pdWidth - (hButton[1]:COL + hButton[1]:WIDTH + .5)
           ghSecBrowse:COL      = hButton[1]:COL + hButton[1]:WIDTH + .5
           hRect:COL            = ghSecBrowse:COL
           hRect:WIDTH          = ghSecBrowse:WIDTH
           hFldLabel:COL        = hRect:COL + .3
           hField:COL           = hFldLabel:COL + hFldLabel:WIDTH
           hField:WIDTH         = (hRect:COL + hRect:WIDTH) - hField:COL - .4
           hRadioSet:COL        = hField:COL
           hButton[5]:COL       = (hRect:COL + hRect:WIDTH) - hButton[5]:WIDTH - .4
           hLRngFrom:COL        = hRect:COL + .3
           hFRngFrom:COL        = hLRngFrom:COL + hLRngFrom:WIDTH
           hFRngFrom:WIDTH      = (hRect:COL + hRect:WIDTH) - hField:COL - .4
           hFRngTo:COL          = hFRngFrom:COL
           hLRngTo:COL          = hFRngTo:COL - hLRngTo:WIDTH
           hFRngTo:WIDTH        = hFRngFrom:WIDTH
           NO-ERROR.
  
  /* Height Changes */
  dCentre = ((pdHeight - 4.71) / 2) + 1. /* 4.71 = Height of buttons plus .05 space between them */
  ASSIGN hButton[1]:ROW = dCentre
         hButton[2]:ROW = hButton[1]:ROW + hButton[2]:HEIGHT + .05
         hButton[3]:ROW = hButton[2]:ROW + hButton[3]:HEIGHT + .05
         hButton[4]:ROW = hButton[3]:ROW + hButton[4]:HEIGHT + .05
         hLabel:ROW     = dLabelRow
         hRect:ROW      = pdHeight - hRect:HEIGHT + 1
         hField:ROW     = hRect:ROW + .1
         hRadioSet:ROW  = hField:ROW + hField:HEIGHT + .05
         hButton[5]:ROW = hRadioSet:ROW + hRadioSet:HEIGHT - hButton[5]:HEIGHT
         hFldLabel:ROW  = hField:ROW
         hFRngFrom:ROW  = hRect:ROW + .1
         hLRngFrom:ROW  = hFRngFrom:ROW
         hFRngTo:ROW    = hFRngFrom:ROW + hFRngFrom:HEIGHT + .05
         hLRngTo:ROW    = hFRngTo:ROW
         NO-ERROR.
  IF VALID-HANDLE(ghNonSecBrowse) AND 
     VALID-HANDLE(ghSecBrowse) THEN
    ASSIGN ghNonSecBrowse:HEIGHT = pdHeight - ghNonSecBrowse:ROW + .8
           ghSecBrowse:HEIGHT    = (IF (glFieldSecurity OR glRangeSecurity OR glUserDataSec) THEN ((hRect:ROW - .2) - ghSecBrowse:ROW) ELSE ghNonSecBrowse:HEIGHT)
           NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowLeave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave Procedure 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Assign screen value of current column to temp table buffer
               Assign logical restriction in the case of Data Ranges if
               from and to values have been modified.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRestrictedColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValueFromField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValueToField        AS HANDLE    NO-UNDO.


  /* if current record in browse has been modified */
  IF ghSecBrowse:CURRENT-ROW-MODIFIED THEN
  DO:
     /* for each column in the browse */
     REPEAT iLoop = 1 TO ghSecBrowse:NUM-COLUMNS:

        /* Get handle to column and corresponding temp table buffer field */
        hColumn = ghSecBrowse:GET-BROWSE-COLUMN(iLoop).
        hField  = hColumn:BUFFER-FIELD.

        /* If modified then assign column screen value to corresponding temp table buffer field */
        IF hColumn:MODIFIED AND VALID-HANDLE(hField)THEN
           hField:BUFFER-VALUE = hColumn:SCREEN-VALUE NO-ERROR.
     END. /* REPEAT */
  END. /* IF ghBrowse:CURRENT-ROW-MODIFIED */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-securityModelUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE securityModelUpdated Procedure 
PROCEDURE securityModelUpdated :
/*------------------------------------------------------------------------------
  Purpose:     When the security model is changed from a grant to a revoke or
               vice versa, objects are notified.  Security Control publishes
               this event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSecurityModel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWidget        AS HANDLE     NO-UNDO.

  /* Make sure our allocated browser labels are correct and update the global securityModel variable */
  ASSIGN cSecurityModel = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "SecurityModel":U, INPUT YES).

  IF cSecurityModel = "":U 
  OR cSecurityModel = ? 
  OR cSecurityModel = "REVOKE":U THEN
      ASSIGN gcGrantRevoke = "Restricted"
             glRevoke      = TRUE.
  ELSE
      ASSIGN gcGrantRevoke = "Granted"
             glRevoke      = FALSE.

  IF glUserDataSec
  THEN DO:
      IF VALID-HANDLE(ghSecBrowse) THEN
          ASSIGN ghSecBrowse:TITLE = "User specific allocations - " + gcEntityName.

      /* Set the radio set labels */
      ASSIGN hWidget = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"raFieldSecType":U, "ALL":U)
             hWidget:RADIO-BUTTONS = IF glRevoke 
                                     THEN "Revoke access,YES,Not secured,NO":U
                                     ELSE "Grant access,NO,No access,YES":U.
  END.
  ELSE
      IF VALID-HANDLE(ghSecBrowse) THEN
          ASSIGN ghSecBrowse:TITLE = gcGrantRevoke + " ":U + gcEntityName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setButtonState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtonState Procedure 
PROCEDURE setButtonState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcBrowseCode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSecurityType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecured      AS CHARACTER  NO-UNDO.

  IF pcBrowseCode = "NONSEC":U AND
     VALID-HANDLE(ghNonSecBrowse) AND
     VALID-HANDLE(ghNonSecQuery) THEN DO:
    lOk = ghNonSecBrowse:SCROLL-TO-SELECTED-ROW(1) NO-ERROR.
    
    IF lOK THEN
      DYNAMIC-FUNCTION("enableWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
    ELSE
      DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buAdd":U).
    ERROR-STATUS:ERROR = FALSE.
  END.

  IF pcBrowseCode = "SEC":U AND
     VALID-HANDLE(ghSecBrowse) AND
     VALID-HANDLE(ghSecQuery) THEN DO:
    /* Field Security Widgets */
    assignWidgetValue("fiFieldName":U,"").
    disableWidget("raFieldSecType":U).
    disableWidget("buApply":U).
    /* Range Security Widgets */
    disableWidget("fiRangeFrom":U).
    disableWidget("fiRangeTo":U).
    
    IF ghSecBrowse:NUM-SELECTED-ROWS > 0 THEN
      DYNAMIC-FUNCTION("enableWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
    ELSE
      DYNAMIC-FUNCTION("disableWidget":U IN TARGET-PROCEDURE, INPUT "buRemove":U).
    
    /* Additional functionality for fields */
    IF glFieldSecurity THEN DO:
      IF ghSecBrowse:NUM-SELECTED-ROWS > 1 THEN
        assignWidgetValue("fiFieldName":U,"All Selected Fields").
      ELSE DO:
        IF ghSecBuffer:AVAILABLE AND 
           ghSecBrowse:NUM-SELECTED-ROWS = 1 THEN DO:
          assignWidgetValue("fiFieldName":U,ghSecBuffer:BUFFER-FIELD("gsm_field__field_name":U):BUFFER-VALUE).
          cSecurityType = ghSecBuffer:BUFFER-FIELD("cSecurityType":U):BUFFER-VALUE.
          CASE cSecurityType:
            WHEN "Read Only":U THEN
              assignWidgetValue("raFieldSecType":U,"READONLY":U).
            WHEN "Hidden":U THEN
              assignWidgetValue("raFieldSecType":U,"HIDDEN":U).
            OTHERWISE 
              assignWidgetValue("raFieldSecType":U,"FULL":U).
          END CASE.
        END.
      END.

      IF ghSecBrowse:NUM-SELECTED-ROWS > 0 AND
         ghSecBuffer:AVAILABLE THEN DO:
        enableWidget("raFieldSecType":U).
        enableWidget("buApply":U).
      END.
    END.
    /* field security end */
    
    /* Additional functionality for ranges */
    IF glRangeSecurity THEN DO:
      IF ghSecBuffer:AVAILABLE AND 
         ghSecBrowse:NUM-SELECTED-ROWS = 1 THEN DO:
        assignWidgetValue("fiRangeFrom":U,ghSecBuffer:BUFFER-FIELD("cFromValue":U):BUFFER-VALUE).
        assignWidgetValue("fiRangeTo":U,ghSecBuffer:BUFFER-FIELD("cToValue":U):BUFFER-VALUE).
      END.
      ELSE DO:
        assignWidgetValue("fiRangeFrom":U,"":U).
        assignWidgetValue("fiRangeTo":U,"":U).
      END.

      IF ghSecBrowse:NUM-SELECTED-ROWS > 0 AND
         ghSecBuffer:AVAILABLE THEN DO:
        hideWidget("fiFieldName":U).
        viewWidget("fiRangeFrom":U).
        viewWidget("fiRangeTo":U).
        enableWidget("fiRangeFrom":U).
        enableWidget("fiRangeTo":U).
        enableWidget("buApply":U).
      END.
    END.
    /* range security end */
  
    /* Additional functionality for user data security */
    IF glUserDataSec 
    THEN DO:
        IF ghSecBrowse:NUM-SELECTED-ROWS > 1 THEN
            assignWidgetValue("fiFieldName":U,"All Selected Objects").
        ELSE DO:
            IF  ghSecBuffer:AVAILABLE 
            AND ghSecBrowse:NUM-SELECTED-ROWS = 1 
            THEN DO:
                assignWidgetValue("fiFieldName":U,ghSecBrowse:FIRST-COLUMN:SCREEN-VALUE).
                cSecured = STRING(ghSecBuffer:BUFFER-FIELD("cSecured":U):BUFFER-VALUE).
                assignWidgetValue("raFieldSecType":U,cSecured).
            END.
        END.

        IF  ghSecBrowse:NUM-SELECTED-ROWS > 0 
        AND ghSecBuffer:AVAILABLE 
        THEN DO:
            enableWidget("raFieldSecType":U).
            enableWidget("buApply":U).
        END.
    END.
    /* user data security end */
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLabel Procedure 
PROCEDURE setLabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER hFieldHandle AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER cLabel       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.

ASSIGN hLabel              = hFieldHandle:SIDE-LABEL-HANDLE
       hLabel:SCREEN-VALUE = "":U /* Set the label to blank */
       hLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLabel + ": ":U, hFieldHandle:FONT)
       hLabel:X            = hFieldHandle:X - hLabel:WIDTH-PIXELS
       hLabel:SCREEN-VALUE = cLabel + ": ":U
       ERROR-STATUS:ERROR  = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValue Procedure 
PROCEDURE setScreenValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets screen values for columns in the browser for given UI events
               Also sets modified state
  Parameters:  <none>
  Notes:       For logical columns, the user may mouse-double-click to toggle YES and NO,
               or type 'Y' or 'N'.
               For character columns in the case where security type is Fields,
               specific screen values are set when the user types 'F','R', or 'H'.
               For character columns in the case where security type is Data Ranges,
               just the update state is set.
               This approach needs rework as there is a lot of specific hard-coding.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCurrentField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCurrentColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDescColumn          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRecordSecLevel      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hContainerSource     AS HANDLE    NO-UNDO.

  IF NOT glFieldSecurity AND 
     NOT glRangeSecurity AND 
     ghSecBrowse:CURRENT-COLUMN:DATA-TYPE <> "LOGICAL":U THEN /* Data security at user level allows the user to enter a YES/NO secured flag */
    RETURN.

  {get containerSource hContainerSource}.

  /* If a record is available in browser */
  IF ghSecBuffer:AVAILABLE THEN
  DO:     
     PUBLISH "DataChanged":U FROM hContainerSource.
     /* Get handle and data type of current column and handle of corresponding buffer field in the temp table */
     ASSIGN hCurrentColumn      = ghSecBrowse:CURRENT-COLUMN
            cDataType           = hCurrentColumn:DATA-TYPE
            hCurrentField       = hCurrentColumn:BUFFER-FIELD.

     /* If the current column in the browser is of a character data type */
     IF cDataType EQ "CHARACTER":U AND glFieldSecurity THEN
     DO:
       /* Process 'F','R' and 'H' key presses */
       CASE LAST-EVENT:FUNCTION:
           WHEN 'F' THEN DO:
             hCurrentColumn:SCREEN-VALUE = "Full Access".
             assignWidgetValue("raFieldSecType":U,"FULL":U).
           END.
           WHEN 'R' THEN DO:
             hCurrentColumn:SCREEN-VALUE = "Read Only".
             assignWidgetValue("raFieldSecType":U,"READONLY":U).
           END.
           WHEN 'H' THEN DO:
             hCurrentColumn:SCREEN-VALUE = "Hidden".
             assignWidgetValue("raFieldSecType":U,"HIDDEN":U).
           END.
       END CASE.
       
       /* Assign screen value to temp table buffer */
       hCurrentField:BUFFER-VALUE = hCurrentColumn:SCREEN-VALUE.
       RETURN NO-APPLY.
     END.
     /* If the current column in the browser is of a character data type */
     IF cDataType EQ "CHARACTER":U AND glRangeSecurity THEN
     DO:
       CASE hCurrentColumn:NAME:
         WHEN "cFromValue":U THEN DO:
           assignWidgetValue("fiRangeFrom":U,hCurrentColumn:SCREEN-VALUE).
         END.
         WHEN "cToValue":U THEN
           assignWidgetValue("fiRangeTo":U,hCurrentColumn:SCREEN-VALUE).
       END CASE.
       
       /* Assign screen value to temp table buffer */
       hCurrentField:BUFFER-VALUE = hCurrentColumn:SCREEN-VALUE.
       /*RETURN NO-APPLY.*/
     END.

     /* Data security at user level allows the user to enter a YES/NO secured flag */
     IF cDataType = "LOGICAL":U AND glUserDataSec 
     THEN DO:
         ASSIGN hCurrentField:BUFFER-VALUE   = hCurrentColumn:SCREEN-VALUE
                hCurrentColumn:CURSOR-OFFSET = 1.
         assignWidgetValue("raFieldSecType":U,hCurrentColumn:SCREEN-VALUE).
     END.
   END. /* IF ghSecBuffer:AVAILABLE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startSearch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch Procedure 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcBrowseCode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  IF pcBrowseCode = "NONSEC":U THEN
    ASSIGN hBrowse = ghNonSecBrowse
           hBuffer = ghNonSecBuffer
           hQuery  = ghNonSecQuery.
  ELSE
    ASSIGN hBrowse = ghSecBrowse
           hBuffer = ghSecBuffer
           hQuery  = ghSecQuery.

  /* Get handle to current column and save current position in browser */
  ASSIGN
      hColumn = hBrowse:CURRENT-COLUMN
      rRow    = hBuffer:ROWID.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn ) THEN
  DO:
      /* Construct sort string */
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                     ELSE hColumn:NAME).
      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "FOR EACH ":U + hBuffer:NAME + " NO-LOCK BY ":U + cSortBy.

      IF hQuery:IS-OPEN THEN
          hQuery:QUERY-CLOSE().
      hQuery:QUERY-PREPARE(cQuery).
      hQuery:QUERY-OPEN().

      /* If new result set contains data, then reposition to the record in the browser saved in rRow */
      IF hQuery:NUM-RESULTS > 0 THEN
      DO:
          hQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          hBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO hBrowse.
      END.
  END.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateSecurity Procedure 
PROCEDURE updateSecurity :
/*------------------------------------------------------------------------------
  Purpose:     Save the actual security allocation
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFromValue        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToValue          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSecType          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSecured          AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  EMPTY TEMP-TABLE ttUpdatedAllocations.
  
  ghSecBuffer:FIND-FIRST() NO-ERROR.

  /* All security allocations were deleted */
  IF NOT ghSecBuffer:AVAILABLE 
  THEN DO:
    CREATE ttUpdatedAllocations.
    ASSIGN ttUpdatedAllocations.owning_entity_mnemonic = gcEntity
           ttUpdatedAllocations.lDeleteAll             = TRUE.
  END.
  
  /* Get Key Field Handle */
  hField = ghSecBuffer:BUFFER-FIELD("dSecurity_structure_obj":U) NO-ERROR.
  IF NOT VALID-HANDLE(hField) THEN DO:
    DO iLoop = 1 TO ghSecBuffer:NUM-FIELDS:
      IF INDEX(ghSecBuffer:BUFFER-FIELD(iLoop):NAME,gcEntityObjField) > 0 THEN DO:
        hField = ghSecBuffer:BUFFER-FIELD(iLoop).
        LEAVE.
      END.
    END.
  END.

  /* This should never happen - just in case :-) */
  IF NOT VALID-HANDLE(hField) THEN DO:
    MESSAGE "Can't get Key field for Secured Data Buffer" SKIP
            ghSecBuffer:BUFFER-FIELD(1):NAME.
    RETURN.
  END.

  hFromValue = ghSecBuffer:BUFFER-FIELD("cFromValue":U) NO-ERROR.
  hToValue   = ghSecBuffer:BUFFER-FIELD("cToValue":U) NO-ERROR.
  hSecType   = ghSecBuffer:BUFFER-FIELD("cSecurityType":U) NO-ERROR.
  hSecured   = ghSecBuffer:BUFFER-FIELD("cSecured":U) NO-ERROR.

  /* Check if we deleted any allocations */
  IF CAN-FIND(FIRST ttDeletedAllocations) THEN DO:
    FOR EACH ttDeletedAllocations:
      ghSecBuffer:FIND-FIRST("WHERE ":U + ghSecBuffer:NAME + ".":U + hField:NAME + " = ":U + QUOTER(DECIMAL(ttDeletedAllocations.dOwningObj))) NO-ERROR.
      /* Mark for deletion */
      IF NOT ghSecBuffer:AVAILABLE THEN DO:
        CREATE ttUpdatedAllocations.
        ASSIGN ttUpdatedAllocations.owning_entity_mnemonic = gcEntity
               ttUpdatedAllocations.owning_obj             = ttDeletedAllocations.dOwningObj
               ttUpdatedAllocations.lDelete                = TRUE
               ttUpdatedAllocations.lDeleteAll             = FALSE.
      END.
    END.
  END. 

  IF VALID-HANDLE(ghSecQuery) 
  THEN DO:
    ghSecQuery:GET-FIRST().
    DO WHILE ghSecBuffer:AVAILABLE :
      CREATE ttUpdatedAllocations.
      ASSIGN ttUpdatedAllocations.owning_entity_mnemonic = gcEntity
             ttUpdatedAllocations.owning_obj             = hField:BUFFER-VALUE
             ttUpdatedAllocations.lDelete                = FALSE
             ttUpdatedAllocations.lDeleteAll             = FALSE
             ttUpdatedAllocations.user_allocation_value1 = IF VALID-HANDLE(hFromValue) 
                                                           THEN hFromValue:BUFFER-VALUE 
                                                           ELSE IF VALID-HANDLE(hSecType) 
                                                                THEN hSecType:BUFFER-VALUE 
                                                                ELSE IF VALID-HANDLE(hSecured) 
                                                                     THEN STRING(hSecured:BUFFER-VALUE)
                                                                     ELSE "":U
             ttUpdatedAllocations.user_allocation_value2 = IF VALID-HANDLE(hToValue) 
                                                           THEN hToValue:BUFFER-VALUE 
                                                           ELSE "":U
             ttUpdatedAllocations.lUpdateValue1AndValue2 = TRUE.
      ghSecQuery:GET-NEXT().
    END.
  END.

  IF CAN-FIND(FIRST ttUpdatedAllocations) THEN DO:
    /* Go and save the data */
    RUN updateUserAllocations IN gshSecurityManager (INPUT gdUserObj,
                                                     INPUT gdCompanyObj,
                                                     INPUT TABLE ttUpdatedAllocations).
    IF ERROR-STATUS:ERROR OR
       RETURN-VALUE <> "":U THEN DO:
      cMessageList = RETURN-VALUE.
      IF cMessageList <> "":U THEN DO:
        RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Error Saving Security Allocations",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        SESSION:SET-WAIT-STATE("":U).
        RETURN.
      END.
    END.
  END.
  
  RUN clearClientCache IN gshSecurityManager.

  {get ContainerSource hContainerSource}.
  PUBLISH "resetSecurity":U FROM hContainerSource.

  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  RUN SUPER.

  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
    RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).
  {get ContainerSource hContainerSource}.

  PUBLISH "viewAllocationObject" FROM hContainerSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Override this procedure, otherwise we will be prompted to save the
            data on leave.
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

