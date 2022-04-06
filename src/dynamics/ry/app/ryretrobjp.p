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
/*---------------------------------------------------------------------------------
  File: ryretrobjp.p

  Description:  Repository Object Retrieval Procedure

  Purpose:      Repository Object Retrieval Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   0           UserRef:    
                Date:   dd/mm/yyyy  Author:     

  Update Notes: 

  (v:010001)    Task:           0   UserRef:    
                Date:   08/29/2002  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryretrobjp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{ src/adm2/globals.i  }

DEFINE INPUT  PARAMETER pcLogicalObjectName             AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER pdUserObj                       AS DECIMAL              NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode                    AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER pdLanguageObj                   AS DECIMAL              NO-UNDO.
DEFINE INPUT  PARAMETER pcRunAttribute                  AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER plDesignMode                    AS LOGICAL              NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phObjectsToFetchBuffer.

/* Temp-table definitions for object tables, which take into account customisation */
{ ry/app/ryobjretri.i }

/* Inlude containing the data types in integer form. */
{ af/app/afdatatypi.i }

/** These are attributes whose values must be taken from the underllying 
 *  field to which the SDF is auto-attached. Entries which have an = in them
 *  denote mapped fields: the attribute name on the left is the mapped to the
 *  attribute name on the right in the SDF.
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE AUTO-ATTACH-KEEP-ATTRIBS FieldName,WidgetName=FieldName,Name=FieldName,ROW,COLUMN,Order,InitialValue,ENABLED=EnableField,DisplayField,TableName,Name=ObjectName,ObjectName

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

&SCOPED-DEFINE DBAWARE-OBJECT-TYPES SDO,SBO,DynSDO

/* Preprocessors which resolve the STORED-AT values into the values stored
 * in the field.                                                          */
{ ry/inc/ryattstori.i }

/** We do not get the contained instances for these classes, since all of
 *  the contained information can be derived from the attributes for the 
 *  object itself, rather that relying on the contained instances to do so.
 *  ----------------------------------------------------------------------- **/
DEFINE VARIABLE gcClassIgnoreContainedInstances             AS CHARACTER        NO-UNDO
    INITIAL "SDO,DynBrow":U.

/** The TT stores the names of the objects to retrieve. Treeview obejcts and
 *  contained containers will have thier names placed in this TT for later
 *  retrieval.
 *
 *  This TT is used by retrieveAllObjects().
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttObjectsToFetch      NO-UNDO
    FIELD tLogicalObjectName        AS CHARACTER
    FIELD tObjectRetrieved          AS LOGICAL          INITIAL NO
    INDEX idxMain
        tLogicalObjectName
    INDEX ixdCreated
        tObjectRetrieved
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addObjectProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addObjectProcedures Procedure 
FUNCTION addObjectProcedures RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT phAttributeBuffer   AS HANDLE,
      INPUT plStaticObject      AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cascadeAttributes Procedure 
FUNCTION cascadeAttributes RETURNS LOGICAL
    ( INPUT pdFromIdentifier        AS DECIMAL,
      INPUT pdToIdentifier          AS DECIMAL,
      INPUT phAttributeBuffer       AS HANDLE       )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cascadeUiEvents Procedure 
FUNCTION cascadeUiEvents RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pdFromIdentifier        AS DECIMAL,
      INPUT pdToIdentifier          AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanupBuildObjectRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanupBuildObjectRecords Procedure 
FUNCTION cleanupBuildObjectRecords RETURNS LOGICAL
    ( INPUT pcResultCode        AS CHARACTER,
      INPUT pcOldResultCode     AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createAttributeValues Procedure 
FUNCTION createAttributeValues RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER,
      INPUT pdRecordIdentifier          AS DECIMAL,
      INPUT phClassAttributeBuffer      AS HANDLE,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createUiEvents Procedure 
FUNCTION createUiEvents RETURNS LOGICAL
    ( INPUT pdRecordIdentifier          AS DECIMAL,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findTreeObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findTreeObjects Procedure 
FUNCTION findTreeObjects RETURNS LOGICAL
    ( INPUT pcParentNodeCode        AS CHARACTER,
      INPUT pdParentNodeObj         AS DECIMAL     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ignoreContainedInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ignoreContainedInstances Procedure 
FUNCTION ignoreContainedInstances RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcInheritsFromClasses   AS CHARACTER )  FORWARD.

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
         HEIGHT             = 17.29
         WIDTH              = 48.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */        
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageBuffer                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageInstanceBuffer         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hLinkBuffer                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hUiEventBuffer              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSessionParam               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSetCiciAlready             AS CHARACTER            NO-UNDO.

    DEFINE BUFFER unfetchedObjectsToFetch   FOR ttObjectsToFetch.

    /* Make sure that there's a unique value for the TT object IDs. */
    IF gsdTempUniqueId EQ 0 OR gsdTempUniqueId EQ ? THEN
        RUN seedTempUniqueID IN gshSessionManager.
    
    /* Get any updates and/or overrides from the Session param table.
     * The parameter used to check for updates is purely internal. It should only be set
     * by this procedure. "CiCi" = "ClassIgnoreContainedInstances"                      */
    ASSIGN cSetCiciAlready = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                              INPUT "CiciSetAlready":U).

    ASSIGN cSessionParam = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                            INPUT "ClassIgnoreContainedInstances":U).

    /* We only want to set this parameter once, otherwise the parameter will grow and grow. */
    IF cSetCiciAlready NE "YES":U THEN
    DO:
        IF cSessionParam EQ ? THEN
            ASSIGN cSessionParam = "":U.

        /* Get rid of the hard-coded stuff.
         * Do this to prevent the hard-coded classes being added continually.
         * The method used prevents having to loop through all of the stored values. */
        ASSIGN cSessionParam = REPLACE(cSessionParam, gcClassIgnoreContainedInstances, "":U).

        /* Now add the hard-coded stuff and make sure that we get rid of any extra commas. */
        ASSIGN gcClassIgnoreContainedInstances = gcClassIgnoreContainedInstances + ",":U + cSessionParam
               gcClassIgnoreContainedInstances = REPLACE(gcClassIgnoreContainedInstances, ",,":U, ",":U)
               gcClassIgnoreContainedInstances = TRIM(gcClassIgnoreContainedInstances, ",":U).

        /* Set the complete list of session parameters. */
        DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                         INPUT "ClassIgnoreContainedInstances":U,
                         INPUT gcClassIgnoreContainedInstances    ).

        /* Remember that we've done this. */
        DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                         INPUT "CiciSetAlready":U,
                         INPUT STRING(YES)          ).
    END.    /* there are values stored. */
    ELSE
        ASSIGN gcClassIgnoreContainedInstances = cSessionParam.
    
    /* Ensure that we always attempt to retrieve the  default object(s) */
    RUN resolveResultCodes IN gshRepositoryManager ( INPUT plDesignMode, INPUT-OUTPUT pcResultCode ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
    /* There are a set of build_Object* tempo-tables which are used to construct the 
     * objects to be returned. Once the object has been constructed as it should be,
     * then the contents are returned and will be used to populate the cache_Object* 
     * temp-tables.                                                                  */

    /* Create a record for the requested object. */
    CREATE unfetchedObjectsToFetch.
    ASSIGN unfetchedObjectsToFetch.tLogicalObjectName = pcLogicalObjectName.

    /** Fetch any unfetched objects. There will be at least one of these, the
     *  pcLogicalObjectName object.
     *  We get into this loop because we may fetch objects that themselves require
     *  subsidiary objects to be fetched. We repeat here until there are no more
     *  objects requiring retrieval.
     *  ----------------------------------------------------------------------- **/
    FIND FIRST unfetchedObjectsToFetch WHERE
               unfetchedObjectsToFetch.tObjectRetrieved = NO
               NO-ERROR.

    DO WHILE AVAILABLE unfetchedObjectsToFetch:
        FOR EACH ttObjectsToFetch WHERE
                 ttObjectsToFetch .tObjectRetrieved = NO:
            /* Set the fetched flag to YES. If this fetch fails, then we are going
             * to bomb this retrieval anyway so we don't really care. We must set this
             * value here because the retrieveAllResults() call may itself create objects
             * for retrieval.                                                            */
            ASSIGN ttObjectsToFetch.tObjectRetrieved = YES.

            RUN retrieveAllResults IN TARGET-PROCEDURE (INPUT ttObjectsToFetch.tLogicalObjectName,
                                                        INPUT pcResultCode,
                                                        INPUT plDesignMode          ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* each ttobjects to fetch */

        /* Check if there are any more unfetched objects. */
        FIND FIRST unfetchedObjectsToFetch WHERE
                   unfetchedObjectsToFetch.tObjectRetrieved = NO
                   NO-ERROR.
    END.    /* unfetched objects */

    /* In design mode we deal with an object per result code, and not
     * consolidations of result codes. We also want the unsecured, untranslated 
     * object.                                                                  */
    IF NOT plDesignMode THEN
    DO:
        RUN customizeObjectByResult IN TARGET-PROCEDURE (INPUT pcLogicalObjectName, INPUT pcResultCode) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* Runtime mode */

    /* Set the remaining key values. We need to do this to
     * make sure that the cache is populated properly.    
     * The records that are in this temp-table are those that need
     * to go into the cache. Customisaton has already been 
     * applied to them, if necessary.                             */
    FOR EACH build_Object:        
        ASSIGN build_Object.tUserObj      = pdUserObj
               build_Object.tRunAttribute = pcRunAttribute
               build_Object.tLanguageObj  = pdLanguageObj.
    END.    /* each buildObject */

    /* Now put the objects that we have retrieved into the cache.
     * No values are passed in for the attribute table names or
     * attribute buffer handles since the class attribute temp-tables
     * do not differ from those stored in the ttClass table.          */

    /* We store things in the cache at this point since we do not want to
     * have to re-fetch objects which have already been retrieved. For instance
     * the dynamic viewer's validateClassData procedure launches an SDO which
     * we will already have retrieved above. We do not want to have to 
     * retrieve this again.                                                    */
    ASSIGN hObjectBuffer       = BUFFER build_Object:HANDLE
           hPageBuffer         = BUFFER build_ObjectPage:HANDLE
           hPageInstanceBuffer = BUFFER build_ObjectPageInstance:HANDLE           
           hLinkBuffer         = BUFFER build_ObjectLink:HANDLE
           hUiEventBuffer      = BUFFER build_ObjectUiEvent:HANDLE.

    RUN putObjectInCache IN gshRepositoryManager ( INPUT hObjectBuffer,
                                                   INPUT hPageBuffer,
                                                   INPUT hPageInstanceBuffer,
                                                   INPUT hLinkBuffer,
                                                   INPUT hUiEventBuffer,
                                                   INPUT "":U,                              /* pcAttributeTableNames*/
                                                   INPUT "":U                   ) NO-ERROR. /* pcAttributeBufferHandles */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
    IF NOT plDesignMode THEN
    DO:
        /* Translations and security are done on a per-user basis. 
         * Any other customisations, like popups, are also handled here. */
        RUN customizeObjectByOther IN TARGET-PROCEDURE (INPUT pcLogicalObjectName,
                                                        INPUT pcResultCode,
                                                        INPUT pdUserObj,
                                                        INPUT pcRunAttribute,
                                                        INPUT pdLanguageObj            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* not in design mode */

    /* Return this handle so that an AppServer request knows which records to return to 
     * the client-side cache. If this request is made locally - not across an AppServer, 
     * then this is not necessary and we don't return the handle.                        */
    IF PROGRAM-NAME(2) BEGINS "serverFetchObject":U THEN
        ASSIGN phObjectsToFetchBuffer = TEMP-TABLE ttObjectsToFetch:HANDLE.
    ELSE
        ASSIGN phObjectsToFetchBuffer = ?.

    ASSIGN hObjectBuffer       = ?
           hPageBuffer         = ?
           hPageInstanceBuffer = ?
           hLinkBuffer         = ?
           hUiEventBuffer      = ?
           NO-ERROR.

    RETURN.
/* EOF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-autoAttachSdf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autoAttachSdf Procedure 
PROCEDURE autoAttachSdf :
/*------------------------------------------------------------------------------
  Purpose:     Auto attaches a SmartDataFIeld (dynamic or static) to a field.
  Parameters:  pcSdfFilename      -
               pdRecordIdentifier -
               pdResultObj        -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcSdfFilename        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdRecordIdentifier   AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdResultObj          AS DECIMAL              NO-UNDO.

    DEFINE VARIABLE hField                      AS HANDLE  EXTENT 5     NO-UNDO.
    DEFINE VARIABLE hOldClassAttributeBuffer    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cFieldName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSourceFieldName            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTargetFieldName            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lHasSuperProcedureAttribute AS LOGICAL              NO-UNDO.

    DEFINE BUFFER build_Object          FOR build_Object.
    DEFINE BUFFER rycso                 FOR ryc_smartObject.
    DEFINE BUFFER rycso_SDO             FOR ryc_smartObject.
    DEFINE BUFFER rycso_super           FOR ryc_smartObject.
    DEFINE BUFFER rycso_render          FOR ryc_smartObject.
    DEFINE BUFFER gscot                 FOR gsc_object_type.

    FIND FIRST build_Object WHERE build_Object.tRecordIdentifier = pdRecordIdentifier.
    
    IF CAN-FIND(FIRST rycso WHERE
                      rycso.object_filename          = pcSdfFileName AND
                      rycso.customization_result_obj = pdResultObj      ) THEN
        FIND FIRST rycso WHERE
                   rycso.object_filename          = pcSdfFileName AND
                   rycso.customization_result_obj = pdResultObj
                   NO-LOCK NO-ERROR.
    ELSE
        FIND FIRST rycso WHERE
                   rycso.object_filename          = pcSdfFileName AND
                   rycso.customization_result_obj = 0
                   NO-LOCK NO-ERROR.

    IF NOT AVAILABLE rycso THEN
        RETURN ERROR {aferrortxt.i 'RY' '01' 'rycso' 'object_filename' pcSdfFileName pdResultObj}.

    FIND FIRST gsc_product_module WHERE
               gsc_product_module.product_module_obj = rycso.product_module_obj
               NO-LOCK NO-ERROR.
    

    /** We need to find the attributes for the AutoAttached SDF and poiint the 
     *  build_Object.tClassBufferHandle and tClassTableName at the new 
     *  class.
     *  ----------------------------------------------------------------------- **/
    /* Store the handle of the existing buffer. */
    ASSIGN hOldClassAttributeBuffer = build_Object.tClassBufferHandle.

    FIND FIRST gscot WHERE gscot.object_type_obj = rycso.object_type_obj NO-LOCK NO-ERROR.
    /* Check if the class has been cached already. If not, then create the class in the cache. */
    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT gscot.object_type_code).
    /* We can't do much of there are no attributes. */
    IF NOT hClassCacheBuffer:AVAILABLE THEN
        RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' "'Cached Class ' + gscot.object_type_code "}.

    /* Associate the SDF attribute buffer with the object in place of the original. */
    ASSIGN hAttributeBuffer                  = hClassCacheBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE
           build_Object.tClassName           = gscot.object_type_code
           build_Object.tClassTableName      = hAttributeBuffer:NAME
           build_Object.tClassBufferHandle   = hAttributeBuffer
           build_Object.tInheritsFromClasses = hAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U):INITIAL
           build_Object.tProductModuleCode   = gsc_product_module.product_module_code
           .
    ASSIGN lHasSuperProcedureAttribute = VALID-HANDLE(hAttributeBuffer:BUFFER-FIELD("customSuperProc":U)) NO-ERROR.

    /* Get rid of UI events.
     * UI events are encapsulated by the SDF and so there is no need for UI events
     * for these.                                                                  */
    FOR EACH build_ObjectUiEvent WHERE build_ObjectUiEvent.tRecordIdentifier = pdRecordIdentifier:
        DELETE build_ObjectUiEvent.
    END.    /* UI events */

    /* Create UI events for the SDF. */
    DYNAMIC-FUNCTION("createUiEvents":U,
                     INPUT pdRecordIdentifier,
                     INPUT build_Object.tClassTableName,
                     INPUT rycso.object_type_obj,
                     INPUT rycso.smartObject_obj,
                     INPUT 0,
                     INPUT 0                    ).

    /* Get the new attributes and UI events */
    DYNAMIC-FUNCTION("createAttributeValues":U,
                     INPUT rycso.object_filename,
                     INPUT pdRecordIdentifier,
                     INPUT hAttributeBuffer,
                     INPUT rycso.object_type_obj,
                     INPUT rycso.smartObject_obj,
                     INPUT 0,
                     INPUT 0                     ).

    /* Find the old and new attribute records to be able to keep certain attributes. */
    hOldClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hOldClassAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(build_Object.tRecordIdentifier)) NO-ERROR.
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(build_Object.tRecordIdentifier)) NO-ERROR.

    /* Replace all attribute values with initial values, except those in AUTO-ATTACH-KEEP-ATTRIBS */
    DO iFieldLoop = 1 TO NUM-ENTRIES("{&AUTO-ATTACH-KEEP-ATTRIBS}":U):
        ASSIGN cFieldName = ENTRY(iFieldLoop, "{&AUTO-ATTACH-KEEP-ATTRIBS}":U).

        IF NUM-ENTRIES(cFieldName, "=":U) EQ 2 THEN
            ASSIGN cSourceFieldName = ENTRY(1, cFieldName, "=":U)
                   cTargetFieldName = ENTRY(2, cFieldName, "=":U).
        ELSE
            ASSIGN cSourceFieldName = cFieldName
                   cTargetFieldName = cFieldName.

        ASSIGN hField[1] = hOldClassAttributeBuffer:BUFFER-FIELD(cSourceFieldName)
               hField[2] = hAttributeBuffer:BUFFER-FIELD(cTargetFieldName)
               NO-ERROR.
        IF VALID-HANDLE(hField[1]) AND VALID-HANDLE(hField[2]) THEN
            ASSIGN hField[2]:BUFFER-VALUE = hField[1]:BUFFER-VALUE.
    END.    /* keep these attributes */

    /* Delete the old attribute record, since we will use the new one. */
    hOldClassAttributeBuffer:BUFFER-DELETE().
    hOldClassAttributeBuffer:BUFFER-RELEASE().

    /* Resolve the procedures that are stored as attributes into 
     * relatively pathed values in the build_Object table.        */
    DYNAMIC-FUNCTION("addObjectProcedures":U IN TARGET-PROCEDURE,
                     INPUT build_Object.tRecordIdentifier,
                     INPUT hAttributeBuffer,
                     INPUT rycso.static_object ).

    /* Update the SDO fields. */
    ASSIGN build_Object.tSdoSmartObjectObj = rycso.sdo_smartObject_obj
           build_Object.tSdoPathedFilename = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                              INPUT rycso.sdo_smartObject_obj).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* autoAttachSdf */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-customizeObjectByOther) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE customizeObjectByOther Procedure 
PROCEDURE customizeObjectByOther :
/*------------------------------------------------------------------------------
  Purpose:     Performs other customisations on the specified objects, such as 
               security, translations and any other customisations.
  Parameters:  pcLogicalObjectName -
               pcResultCode        -
               pdUserObj           -
               pcRunAttribute      -
               pdLanguageObj       -
  Notes:       * This procedure will typically run on the server.
               * Any recursive calls must be made by the validateClassData() 
                 call made here. Those calls will ensure that the instances
                 are correct.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE cReturnValue                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectsDone                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hSourceBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassObject                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.

    DEFINE BUFFER build_Object              FOR build_Object.
    
    /* Each Class has a different set of actions to perform.
     * We only use the build_Object records here to determine what objects to perform the 
     * validateClassData procedure on.
     *
     * Don't include instances here. They will be catered for by their containers. So
     * the viewer instances on a container will be handled by the validateClassData()
     * that is run in rydyncntcp.p                                                         */
    FOR EACH build_Object WHERE build_Object.tContainerRecordIdentifier EQ 0 :

        ASSIGN hClassObject = DYNAMIC-FUNCTION("launchClassObject":U IN gshRepositoryManager, INPUT build_Object.tClassName).

        IF VALID-HANDLE(hClassObject) AND LOOKUP("validateClassData":U, hClassObject:INTERNAL-ENTRIES) GT 0 THEN
        DO:
            RUN validateClassData IN hClassObject ( INPUT build_Object.tLogicalObjectName,
                                                    INPUT pcResultCode,
                                                    INPUT pdUserObj,
                                                    INPUT pcRunAttribute,
                                                    INPUT pdLanguageObj ,
                                                    INPUT 0                     ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* can run validateClassData(). */
    END.    /* each build_Object */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* customizeObjectByOther */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-customizeObjectByResult) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE customizeObjectByResult Procedure 
PROCEDURE customizeObjectByResult :
/*------------------------------------------------------------------------------
  Purpose:     Performs various user customisations to an object and
               it's contained objects. 
  Parameters:  pcLogicalObjectName -
               pcResultCode        -
  Notes:       * The result code is an set of result codes which are ordered in 
                 descreasing order of priority.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName      AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE iResultLoop                     AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iFieldLoop                      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iWhereStoredOnTarget            AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iWhereStoredOnCustomisation     AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iWhereConstant                  AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier               AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dContainerRecordIdentifier      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dOldContainerRecordIdentifier   AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE cResultCode                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cProcessedResultCodes           AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cOldResultCode                  AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE hCacheObjectBuffer              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hTargetBuffer                   AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer               AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE cWhereStored                    AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE dSourceObjectInstanceObj        AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dTargetObjectInstanceObj        AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE cFolderLabels                   AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE hStoreFolderClass               AS HANDLE           NO-UNDO.

    DEFINE BUFFER lbObject              FOR build_Object.
    DEFINE BUFFER lb2Object             FOR build_Object.
    DEFINE BUFFER link_Object           FOR build_Object.
    DEFINE BUFFER lbObjectUiEvent       FOR build_ObjectUiEvent.
    DEFINE BUFFER lbObjectPage          FOR build_ObjectPage.
    DEFINE BUFFER lbObjectLink          FOR build_ObjectLink.

    /* Get rid of any blank entries. */
    ASSIGN pcResultCode = TRIM(pcResultCode, ",":U).

    /** If there is only one result code in the string, then we add a dummy value 
     *  so that we create a new set of result code records. This is to avoid issues
     *  when adding objects to the cache where the same object may be requested with
     *  different run attributes (say). The object will not be placed in the cache
     *  since the tRecordIdentifiers are the same (putObjectInCache in the RepositoryManager).
     *  ----------------------------------------------------------------------- **/
    IF NUM-ENTRIES(pcResultCode) <= 1 THEN
        ASSIGN cOldResultCode = pcResultCode
               pcResultCode   = pcResultCode + ",DUMMY-RESULT-CODE-FOR-CACHING":U.

    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT ?).

    /* We are going to return customised obejcts which are both MASTER objects
     * and CONTAINER objects. We are also going to return customised objects which
     * DataAware.     
     *
     * We look through the list of all master objects retrieved. These
     * are the objects we need to apply customisation to.
     * This means that the result code we use here is irrelavant, so we use the 
     * DEFAULT-RESULT-CODE  since we know that this is guaranteed to exist.     */
    fe-blk:
    FOR EACH ttObjectsToFetch,
        EACH lb2Object WHERE
             lb2Object.tLogicalObjectName = ttObjectsToFetch.tLogicalObjectName AND
             lb2Object.tResultCode        = "{&DEFAULT-RESULT-CODE}":U          AND
             lb2Object.tUserObj           = 0 AND 
             lb2Object.tObjectInstanceObj = 0:

        /* First create the record to be returned. */
        CREATE build_Object.
        BUFFER-COPY lb2Object
             EXCEPT tClassName tClassTableName tClassBufferHandle tRecordIdentifier tContainerRecordIdentifier
                 TO build_Object
             ASSIGN gsdTempUniqueId                = gsdTempUniqueId + 1
                    dContainerRecordIdentifier      = gsdTempUniqueId
                    build_Object.tResultCode        = pcResultCode
                    build_Object.tRecordIdentifier  = dContainerRecordIdentifier
                    build_Object.tClassName         = lb2Object.tClassName
                    build_Object.tClassTableName    = lb2Object.tClassTableName
                    build_Object.tClassBufferHandle = lb2Object.tClassBufferHandle
                    cProcessedResultCodes           = "":U
                    cFolderLabels                   = FILL("|":U, 100) /* Make provision for a 100 tabs */
                    hStoreFolderClass               = ?.

        /* Attributes */
        build_Object.tClassBufferHandle:BUFFER-CREATE().
        ASSIGN build_Object.tClassBufferHandle:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = build_Object.tRecordIdentifier.
        build_Object.tClassBufferHandle:BUFFER-RELEASE().

        /* Loop backwards to get the most important modifications last, so that they
         * override all others.                                                     */
        do-blk:
        DO iResultLoop = NUM-ENTRIES(pcResultCode) TO 1 BY -1:
            ASSIGN cResultCode = ENTRY(iResultLoop, pcResultCode).

            /* Only apply each customisation once. */
            IF CAN-DO(cProcessedResultCodes, cResultCode) THEN NEXT.

            /* If there are no customisations, skip. */
            IF CAN-DO("{&NO-RESULT-CODE},":U, cResultCode) THEN NEXT.

            ASSIGN cProcessedResultCodes = cProcessedResultCodes + cResultCode + ",":U.

            /* Update the container with any customisations. */
            FIND FIRST lbObject WHERE
                       lbObject.tContainerObjectName = lb2Object.tLogicalObjectName AND
                       lbObject.tLogicalObjectName   = lb2Object.tLogicalObjectName AND
                       lbObject.tResultCode          = cResultCode                  AND
                       lbObject.tUserObj             = 0
                       NO-ERROR.
            /* There may not be a customised record for this particular result code. */
            IF NOT AVAILABLE lbObject THEN
                NEXT do-blk.

            /* We need to know the this to be able to retrieve all of the contained information. */
            ASSIGN dOldContainerRecordIdentifier = lbObject.tRecordIdentifier.

            /* Move any links on this container to the build container we're going to return to the client */

            FOR EACH lbObjectLink
               WHERE lbObjectLink.tRecordIdentifier = dOldContainerRecordIdentifier.
                ASSIGN lbObjectLink.tRecordIdentifier = dContainerRecordIdentifier.
            END.

            /* Get the container cache_Object. */
            FIND FIRST build_object WHERE build_Object.tRecordIdentifier = dContainerRecordIdentifier.
            BUFFER-COPY lbObject EXCEPT tRecordIdentifier tResultCode TO build_Object.

            /* We need to create a buffer handle here since we don't know which table we are working with at the moment. */
            CREATE BUFFER hTargetBuffer FOR TABLE build_Object.tClassBufferHandle BUFFER-NAME "targetBuffer":U.
            lbObject.tClassBufferHandle:FIND-FIRST(" WHERE ":U + lbObject.tClassBufferHandle:NAME + ".tRecordIdentifier = " + QUOTER(lbObject.tRecordIdentifier)).
            hTargetBuffer:FIND-FIRST(" WHERE ":U + hTargetBuffer:NAME + ".tRecordIdentifier = " + QUOTER(build_Object.tRecordIdentifier)).

            /* For multiple result codes, overlay them over each other to get one object.  We work from the session      * 
             * last result code to the first.  As we go, we update our object attributes if the user has set them        *
             * to different values than the class default.  This is tricky, because an attribute could be set for a      *
             * master object, it's instance on a container, and then the container could be customised and the attribute *
             * set for that instance as well.  To keep track of where an attribute has been set, and whether we should   *
             * use it, we use the whereStored field.  The attribute with the deepest level will be used. (1 -> 15)       */


            /* If this is the first time this loop is run, then copy the contents of the attributes 
             * to the new buffer. This will ensure that all the values are set corectly, and can be 
             * overridden.                                                                            */
            IF iResultLoop EQ NUM-ENTRIES(pcResultCode) OR NUM-ENTRIES(cOldResultCode) EQ 1 THEN
                hTargetBuffer:BUFFER-COPY(lbObject.tClassBufferHandle, "tRecordIdentifier":U).            
            ELSE
                do-blk:
                DO iFieldLoop = 1 TO hTargetBuffer:NUM-FIELDS:
                    /* Skip the system fields like tWhereStored, tRecordIdentifier etc. */
                    IF CAN-DO(lbObject.tClassBufferHandle:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE, STRING(iFieldLoop) ) THEN
                        NEXT do-blk.

                    ASSIGN iWhereStoredOnCustomisation = INTEGER(ENTRY(iFieldLoop, lbObject.tClassBufferHandle:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE)) NO-ERROR.
                    IF iWhereStoredOnCustomisation = 1 THEN NEXT do-blk. /* Attribute still set to the class default, skip it */
                    ASSIGN iWhereStoredOnTarget = INTEGER(ENTRY(iFieldLoop, hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE)) NO-ERROR.

                    /* If we're processing a customisation, and this attribute's value has not already been set by another customisation,   *
                     * in which case iWhereStoredOnCustomisation will be > 8 already, and this attribute has been overwritten at the master *
                     * or master instance level, then we're going to use this attribute, and we need to add 8 to it's stored where level to *
                     * indicate it was set from a customisation. ({&STORED-AT-CUSTOMIZATION} = 8)                                           */
                    IF cResultCode NE "{&DEFAULT-RESULT-CODE}":U
                    AND iWhereStoredOnCustomisation LT {&STORED-AT-CUSTOMIZATION} /* If this is a customised attribute, don't add {&STORED-AT-CUSTOMIZATION} again */
                    AND (iWhereStoredOnCustomisation = ({&STORED-AT-CLASS} + {&STORED-AT-MASTER}) 
                      OR iWhereStoredOnCustomisation = ({&STORED-AT-CLASS} + {&STORED-AT-INSTANCE})) THEN /* Attribute set at Master or Instance */
                            ASSIGN iWhereStoredOnCustomisation = iWhereStoredOnCustomisation + {&STORED-AT-CUSTOMIZATION}.

                    /* If the attribute has been customised for this result code, and it has not been customised on a higher level, copy it */

                    IF iWhereStoredOnCustomisation >= iWhereStoredOnTarget THEN /* If the level is deeper on the customisation, use it */
                        ASSIGN cWhereStored                                              = hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE
                               ENTRY(iFieldLoop, cWhereStored)                           = STRING(iWhereStoredOnCustomisation)
                               hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE = cWhereStored
                               hTargetBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE       = lbObject.tClassBufferHandle:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE.
                END.    /* loop through fields */

            hTargetBuffer:BUFFER-RELEASE().

            /* Clean this up. */
            DELETE OBJECT hTargetBuffer.

            /* UI Events. */
            FOR EACH lbObjectUiEvent WHERE lbObjectUiEvent.tRecordIdentifier = lb2Object.tRecordIdentifier:
                FIND FIRST build_ObjectUiEvent WHERE
                           build_ObjectUiEvent.tRecordIdentifier = build_Object.tRecordIdentifier AND
                           build_ObjectUiEvent.tEventName        = lbObjectUiEvent.tEventName
                           NO-ERROR.
                IF NOT AVAILABLE build_ObjectUiEvent 
                THEN DO:
                    CREATE build_ObjectUiEvent.
                    BUFFER-COPY lbObjectUiEvent EXCEPT tRecordIdentifier TO build_ObjectUiEvent
                        ASSIGN build_ObjectUiEvent.tRecordIdentifier = build_Object.tRecordIdentifier .
                END.
            END. /* UI events */
            
            /* Now cycle through all the objects on the container, and merge the all result codes extracted */
            FOR EACH lbObject WHERE lbObject.tContainerRecordIdentifier = dOldContainerRecordIdentifier:

                FIND FIRST build_Object WHERE
                           build_Object.tContainerRecordIdentifier = dContainerRecordIdentifier  AND
                           build_Object.tLogicalObjectName         = lbObject.tLogicalObjectName AND
                           build_Object.tObjectInstanceName        = lbObject.tObjectInstanceName
                           NO-ERROR.

                IF NOT AVAILABLE build_Object THEN
                DO:
                    CREATE build_Object.
                    BUFFER-COPY lbObject EXCEPT tContainerRecordIdentifier tRecordIdentifier tResultCode TO build_Object.
                    ASSIGN gsdTempUniqueId                         = gsdTempUniqueId + 1
                           dRecordIdentifier                       = gsdTempUniqueId
                           build_Object.tResultCode                = pcResultCode
                           build_Object.tRecordIdentifier          = dRecordIdentifier
                           build_Object.tContainerRecordIdentifier = dContainerRecordIdentifier
                           build_Object.tClassBufferHandle         = lbObject.tClassBufferHandle.

                    /* Remember to populate the where stored field with default values */
                    build_Object.tClassBufferHandle:BUFFER-CREATE().
                    ASSIGN build_Object.tClassBufferHandle:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = build_Object.tRecordIdentifier
                           build_Object.tClassBufferHandle:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE      = FILL("{&STORED-AT-CLASS},":U, build_Object.tClassBufferHandle:NUM-FIELDS)
                           build_Object.tClassBufferHandle:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE      = RIGHT-TRIM(build_Object.tClassBufferHandle:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE, ",":U).
                    build_Object.tClassBufferHandle:BUFFER-RELEASE().
                END.    /* n/a build object. */
                ELSE DO:
                    ASSIGN build_Object.tPageNumber     = lbObject.tPageNumber
                           build_Object.tLayoutPosition = lbObject.tLayoutPosition.
                    
                    /* This instance has already been created, it exists on more than one customisation.                  *
                     * We're not going to create it again, but we need to point the links at the already created instance */
                    FOR EACH lbObjectLink
                       WHERE lbObjectLink.tRecordIdentifier        = dContainerRecordIdentifier /* We've already reassigned in the code above */
                         AND lbObjectLink.tSourceObjectInstanceObj = lbObject.tObjectInstanceObj:

                         ASSIGN lbObjectLink.tSourceObjectInstanceObj = build_Object.tObjectInstanceObj.
                    END.
                    FOR EACH lbObjectLink
                       WHERE lbObjectLink.tRecordIdentifier        = dContainerRecordIdentifier /* We've already reassigned in the code above */
                         AND lbObjectLink.tTargetObjectInstanceObj = lbObject.tObjectInstanceObj:

                         ASSIGN lbObjectLink.tTargetObjectInstanceObj = build_Object.tObjectInstanceObj.
                    END.
                END.

                /* Attributes */
                /* We need to create a buffer handle here since we don't know which table we are working with at the moment. */
                CREATE BUFFER hTargetBuffer FOR TABLE build_Object.tClassBufferHandle BUFFER-NAME "targetBuffer":U.
                lbObject.tClassBufferHandle:FIND-FIRST(" WHERE ":U + lbObject.tClassBufferHandle:NAME + ".tRecordIdentifier = " + QUOTER(lbObject.tRecordIdentifier)).
                hTargetBuffer:FIND-FIRST(" WHERE ":U + hTargetBuffer:NAME + ".tRecordIdentifier = " + QUOTER(build_Object.tRecordIdentifier)).

                /* For multiple result codes, overlay them over each other to get one object.  We work from the session      * 
                 * last result code to the first.  As we go, we update our object attributes if the user has set them        *
                 * to different values than the class default.  This is tricky, because an attribute could be set for a      *
                 * master object, it's instance on a container, and then the container could be customised and the attribute *
                 * set for that instance as well.  To keep track of where an attribute has been set, and whether we should   *
                 * use it, we use the whereStored field.  The attribute with the deepest level will be used. (1 -> 15)       */

                /* If this is the first time this loop is run, then copy the contents of the attributes 
                 * to the new buffer. This will ensure that all the values are set corectly, and can be 
                 * overridden.                                                                            */
                IF iResultLoop EQ NUM-ENTRIES(pcResultCode) OR NUM-ENTRIES(cOldResultCode) EQ 1 THEN
                    hTargetBuffer:BUFFER-COPY(lbObject.tClassBufferHandle, "tRecordIdentifier":U).                
                ELSE
                    do-blk:
                    DO iFieldLoop = 1 TO hTargetBuffer:NUM-FIELDS:
                        /* The folderLabels attribute is rebuilt for the customised container.  We store the class handle, for  *
                         * use after the merged container has been constructed.  You'll see the cFolderLabels variable is built *
                         * in the page loop below, this is what we're going to set this attribute to.  Don't process it here at all. */

                        /* Skip the system fields like tWhereStored, tRecordIdentifier etc. */
                        IF CAN-DO(lbObject.tClassBufferHandle:BUFFER-FIELD("tSystemList":U):BUFFER-VALUE, STRING(iFieldLoop) ) THEN
                            NEXT do-blk.

                        ASSIGN iWhereStoredOnCustomisation = INTEGER(ENTRY(iFieldLoop, lbObject.tClassBufferHandle:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE)) NO-ERROR.
                        IF iWhereStoredOnCustomisation = 1 THEN NEXT do-blk. /* Attribute still set to the class default, skip it */
                        ASSIGN iWhereStoredOnTarget = INTEGER(ENTRY(iFieldLoop, hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE)) NO-ERROR.

                        /* If we're processing a customisation, and this attribute's value has not already been set by another customisation,   *
                         * in which case iWhereStoredOnCustomisation will be > 8 already, and this attribute has been overwritten at the master *
                         * or master instance level, then we're going to use this attribute, and we need to add 8 to it's stored where level to *
                         * indicate it was set from a customisation. ({&STORED-AT-CUSTOMIZATION} = 8)                                           */
    
                        IF cResultCode NE "{&DEFAULT-RESULT-CODE}":U
                        AND iWhereStoredOnCustomisation LT {&STORED-AT-CUSTOMIZATION} /* If this is a customised attribute, don't add {&STORED-AT-CUSTOMIZATION} again */
                        AND (iWhereStoredOnCustomisation = ({&STORED-AT-CLASS} + {&STORED-AT-MASTER}) 
                          OR iWhereStoredOnCustomisation = ({&STORED-AT-CLASS} + {&STORED-AT-INSTANCE})) THEN /* Attribute set at Master or Instance */
                                ASSIGN iWhereStoredOnCustomisation = iWhereStoredOnCustomisation + {&STORED-AT-CUSTOMIZATION}.
    
                        /* If the attribute has been customised for this result code, and it has not been customised on a higher level, copy it */

                        IF iWhereStoredOnCustomisation >= iWhereStoredOnTarget THEN /* If the level is deeper on the customisation, use it */
                            ASSIGN cWhereStored                                              = hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE
                                   ENTRY(iFieldLoop, cWhereStored)                           = STRING(iWhereStoredOnCustomisation)
                                   hTargetBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE = cWhereStored
                                   hTargetBuffer:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE       = lbObject.tClassBufferHandle:BUFFER-FIELD(iFieldLoop):BUFFER-VALUE.
                    END.    /* loop through fields */

                hTargetBuffer:BUFFER-RELEASE().

                /* Clean this up. */
                DELETE OBJECT hTargetBuffer.

                /* UI Events.
                 * UI events are like attributes - they can apply to instances, too. */
                FOR EACH lbObjectUiEvent WHERE lbObjectUiEvent.tRecordIdentifier = lbObject.tRecordIdentifier:
                    FIND FIRST build_ObjectUiEvent WHERE
                               build_ObjectUiEvent.tRecordIdentifier = build_Object.tRecordIdentifier AND
                               build_ObjectUiEvent.tEventName        = lbObjectUiEvent.tEventName
                               NO-ERROR.
                    IF NOT AVAILABLE build_ObjectUiEvent 
                    THEN DO:
                        CREATE build_ObjectUiEvent.
                        BUFFER-COPY lbObjectUiEvent EXCEPT tRecordIdentifier TO build_ObjectUiEvent
                            ASSIGN build_ObjectUiEvent.tRecordIdentifier = build_Object.tRecordIdentifier.
                    END.
                END.    /* UI events */
            END.    /* each contained object */

            /* Pages */
            FOR EACH lbObjectPage WHERE lbObjectPage.tRecordIdentifier = dOldContainerRecordIdentifier:

                FIND FIRST build_ObjectPage WHERE
                           build_ObjectPage.tPageReference    = lbObjectPage.tPageReference AND
                           build_ObjectPage.tRecordIdentifier = dContainerRecordIdentifier 
                           NO-ERROR.

                IF NOT AVAILABLE build_ObjectPage 
                THEN DO:
                    CREATE build_ObjectPage.
                    BUFFER-COPY lbObjectPage EXCEPT tRecordIdentifier TO build_ObjectPage
                        ASSIGN build_ObjectPage.tRecordIdentifier = dContainerRecordIdentifier.

                    IF build_ObjectPage.tPageNumber <> 0 THEN
                        ASSIGN ENTRY(build_ObjectPage.tPageNumber, cFolderLabels, "|":U) = build_ObjectPage.tPageLabel.
                END.
                ELSE DO:
                    BUFFER-COPY lbObjectPage EXCEPT tRecordIdentifier TO build_ObjectPage.

                    IF build_ObjectPage.tPageNumber <> 0 THEN
                        ENTRY(build_ObjectPage.tPageNumber, cFolderLabels, "|":U) = lbObjectPage.tPageLabel.
                END.
            END.    /* Pages */
        END.    /* loop through result codes */
        
        /* Sort our pages nicely, to fill any holes that may have been caused by gaps in the page numbers */

        ASSIGN iResultLoop = 0. /* We're going to use this variable as our counter */
        fe-blk:
        FOR EACH build_ObjectPage
           WHERE build_ObjectPage.tRecordIdentifier = dContainerRecordIdentifier
              BY build_ObjectPage.tPageNumber:

            IF build_ObjectPage.tPageNumber = iResultLoop 
            THEN DO:
                ASSIGN iResultLoop = iResultLoop + 1.
                NEXT fe-blk.
            END.

            /* Move all objects to their new, renumbered page */
            FOR EACH build_Object
               WHERE build_Object.tContainerRecordIdentifier = dContainerRecordIdentifier
                 AND build_Object.tPageNumber                = build_ObjectPage.tPageNumber:

                ASSIGN build_Object.tPageNumber = iResultLoop.
            END.

            /* Renumber the page */
            ASSIGN ENTRY(iResultLoop, cFolderLabels, "|":U) = ENTRY(build_ObjectPage.tPageNumber, cFolderLabels, "|":U)
                   ENTRY(build_ObjectPage.tPageNumber, cFolderLabels, "|":U) = "":U
                   build_ObjectPage.tPageNumber = iResultLoop
                   iResultLoop                  = iResultLoop + 1.
        END.

        /* Go and set the folderLabels attribute */
        ASSIGN cFolderLabels = RIGHT-TRIM(cFolderLabels, "|":U).
        IF cFolderLabels <> "":U THEN
        fe-blk:
        FOR EACH build_object WHERE 
                 build_Object.tContainerRecordIdentifier = dContainerRecordIdentifier AND
                 CAN-DO(build_Object.tInheritsFromClasses, "SmartFolder":U)              :
            ASSIGN hStoreFolderClass = build_object.tClassBufferHandle:BUFFER-FIELD("FolderLabels":U) NO-ERROR.

            /* If we could find the folderLabels attribute in the class, we're going to assign it */
            IF NOT VALID-HANDLE(hStoreFolderClass) THEN
                NEXT fe-blk.

            build_Object.tClassBufferHandle:FIND-FIRST(" WHERE ":U + build_Object.tClassBufferHandle:NAME
                                                       + ".tRecordIdentifier = ":U + QUOTER(build_object.tRecordIdentifier)).

            ASSIGN hStoreFolderClass:BUFFER-VALUE = cFolderLabels.
        END.    /* there are folder labels */
    END.    /* each lb2Object with unresolved result codes */

    /* Remove any duplicate links, we may have overlaid the same link for multiple result codes */
    FOR EACH build_ObjectLink WHERE lbObjectLink.tRecordIdentifier = dContainerRecordIdentifier:
        IF CAN-FIND(FIRST lbObjectLink
                    WHERE lbObjectLink.tRecordIdentifier        = dContainerRecordIdentifier
                      AND lbObjectLink.tSourceObjectInstanceObj = build_ObjectLink.tSourceObjectInstanceObj 
                      AND lbObjectLink.tTargetObjectInstanceObj = build_ObjectLink.tSourceObjectInstanceObj 
                      AND lbObjectLink.tLinkName                = build_ObjectLink.tLinkName
                      AND ROWID(lbObjectLink)                  <> ROWID(build_ObjectLink)) THEN
            DELETE build_ObjectLink.
    END.
    
    /* Get rid of extra records */
    DYNAMIC-FUNCTION("cleanupBuildObjectRecords":U IN TARGET-PROCEDURE,
                     INPUT pcResultCode,
                     INPUT cOldResultCode ).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* customizeObjectByResult */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveAllResults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveAllResults Procedure 
PROCEDURE retrieveAllResults :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves all objects in the ttObjectsToFetch table.
  Parameters:  pcResultCode -
               plDesignMode -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName      AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plDesignMode             AS LOGICAL          NO-UNDO.
    
    DEFINE VARIABLE iResultLoop                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cResultCode                 AS CHARACTER            NO-UNDO.

    /* Retrieve all of the objects for all result codes.
     * customizeObjectByResult will produce an object that corresponds to the 
     * combination of result codes.                                           */    
    DO iResultLoop = 1 TO NUM-ENTRIES(pcResultCode):       
        ASSIGN cResultCode = ENTRY(iResultLoop, pcResultCode).

        /* We can skip the blank result code, because we have already
         * made sure that the DEFAULT result code is included.        */
        IF cResultCode EQ "":U THEN NEXT.

        RUN retrieveResultObject ( INPUT pcLogicalObjectName,
                                   INPUT cResultCode,
                                   INPUT plDesignMode        ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* loop through result codes */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveAllResults */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveContainedInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveContainedInstances Procedure 
PROCEDURE retrieveContainedInstances :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves a master object and all its contained objects, in both
               master and instance form, for a given result code.
  Parameters:  pdContainerSmartObjectObj   -
               pcContainerObjectName       -
               pcResultCode                -
               pdContainerRecordIdentifier -
               pdResultObj                 -
               plDesignMode                -
  Notes:       * The user is not relevant here. User customisations are performed
                 elsewhere in the retrieval process.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdContainerSmartObjectObj    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcContainerObjectName        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerRecordIdentifier  AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdResultObj                  AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER plDesignMode                 AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE  EXTENT 5     NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dMasterRecordIdentifier     AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cSdfFileName                AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ryc_smartObject       FOR ryc_smartobject.
    DEFINE BUFFER rycso                 FOR ryc_smartobject.
    DEFINE BUFFER rycso_super           FOR ryc_smartobject.
    DEFINE BUFFER rycso_SDO             FOR ryc_smartobject.
    DEFINE BUFFER gsc_object_type       FOR gsc_object_type.
    DEFINE BUFFER gscot                 FOR gsc_object_type.
    DEFINE BUFFER build_Object          FOR build_Object.
    DEFINE BUFFER parent_Object         FOR build_Object.
    DEFINE BUFFER lbObject              FOR build_Object.
    DEFINE BUFFER parent_smartobject    FOR ryc_smartobject.
    DEFINE BUFFER parent_object_type    FOR gsc_object_type.

    /* Loop through all the contained object instances, picking up the master and the object type at the 
     * same time. */
    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK,
       FIRST ryc_smartObject WHERE
             ryc_smartObject.smartobject_obj = ryc_object_instance.smartobject_obj AND
             ryc_smartObject.DISABLED        = NO
             NO-LOCK,
       FIRST gsc_object_type WHERE
             gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
             NO-LOCK:

        /* Check if the class has been cached already. If not, then create the class in the cache. */
        ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT gsc_object_type.object_type_code).

        /* We can't do much of there are no attributes. */
        IF NOT hClassCacheBuffer:AVAILABLE THEN
            RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' "'Cached Class ' + gsc_object_type.object_type_code "}.

        ASSIGN hAttributeBuffer = hClassCacheBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.

        /** We retrieve the information for the master of this instance because
         *  we need to cascade the attribute values, UI events, and other inherited information
         *  from the master object to the object instance.
         *  Cache the master object.
         *  ----------------------------------------------------------------------- **/
        RUN retrieveMasterObject IN TARGET-PROCEDURE ( INPUT ryc_smartObject.smartObject_obj,
                                                       INPUT plDesignMode,
                                                       INPUT "":U                            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        FIND FIRST lbObject WHERE lbObject.tRecordIdentifier = ryc_smartObject.smartObject_obj NO-ERROR.
        ASSIGN dMasterRecordIdentifier = lbObject.tRecordIdentifier.

        /* Once we have created the Master record, we can create an object instance record. *
         * As can be seen by the fact that a BUFFER-COPY statement is used, only a few      *
         * fields' values change.                                                           */
        
        /* The CAN-FIND check was introduced here seeing that we could have two of the same container objects  *
         * (Dynamic Viewers for instance) on a container acting as different instances. They will both contain *
         * the same object instances (fields), which will of course have the same object_instance_obj - which  *
         * forms the tRecordIdentifier (a unique index on build_Object).                                       */
        IF NOT CAN-FIND(FIRST build_Object
                        WHERE build_Object.tRecordIdentifier = ryc_object_instance.object_instance_obj) THEN
        DO:
          CREATE build_Object.
          BUFFER-COPY lbObject EXCEPT tRecordIdentifier 
              TO build_Object
              ASSIGN build_Object.tContainerObjectName       = pcContainerObjectName
                     build_Object.tRecordIdentifier          = ryc_object_instance.object_instance_obj
                     build_Object.tMasterRecordIdentifier    = dMasterRecordIdentifier
                     dRecordIdentifier                       = build_Object.tRecordIdentifier
                     build_Object.tContainerRecordIdentifier = pdContainerRecordIdentifier
                     build_Object.tLayoutPosition            = ryc_object_instance.layout_position
                     build_Object.tObjectInstanceObj         = ryc_object_instance.object_instance_obj
                     build_Object.tObjectInstanceName        = ryc_object_instance.instance_name
                     build_Object.tObjectInstanceDescription = ryc_object_instance.instance_description
                     .
        END.
        ELSE
          /* If the build_Object already existed and it was not created above, find it as it will be used further down in the procedure */
          FIND FIRST build_Object
               WHERE build_Object.tRecordIdentifier = ryc_object_instance.object_instance_obj.

        /* Cascade master attributes to the instance.
         * createAttributeValues will overwrite those
         * attribute which exist on the instance.       */
        DYNAMIC-FUNCTION("cascadeAttributes":U IN TARGET-PROCEDURE,
                         INPUT dMasterRecordIdentifier,
                         INPUT dRecordIdentifier,
                         INPUT hAttributeBuffer       ).

        DYNAMIC-FUNCTION("createAttributeValues":U IN TARGET-PROCEDURE,
                         INPUT ryc_smartObject.object_filename,
                         INPUT dRecordIdentifier,
                         INPUT hAttributeBuffer,
                         INPUT gsc_object_type.object_type_obj,
                         INPUT ryc_smartObject.smartObject_obj,
                         INPUT ryc_object_instance.object_instance_obj,
                         INPUT pdContainerSmartObjectObj                ).

        /* Cascade master UI Events to the instance.
         * createUiEvents will overwrite those
         * IUI events which exist on the instance.       */
        DYNAMIC-FUNCTION("cascadeUiEvents":U IN TARGET-PROCEDURE,
                         INPUT gsc_object_type.object_type_code,
                         INPUT dMasterRecordIdentifier,     /* from ID */
                         INPUT dRecordIdentifier            /* to ID */     ).

        DYNAMIC-FUNCTION("createUiEvents":U IN TARGET-PROCEDURE,
                         INPUT dRecordIdentifier,
                         INPUT build_Object.tClassName,
                         INPUT gsc_object_type.object_type_obj,
                         INPUT ryc_smartObject.smartObject_obj,
                         INPUT ryc_object_instance.object_instance_obj,
                         INPUT pdContainerSmartObjectObj                ).

        /* Find the attribute buffer record. */
        build_Object.tClassBufferHandle:FIND-FIRST(" WHERE ":U + build_Object.tClassBufferHandle:NAME
                                                   + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)) NO-ERROR.
        /** Set up the default layout positions. 
         *  ----------------------------------------------------------------------- **/
        IF build_Object.tLayoutPosition EQ "":U THEN
        DO:
            /* Deal with defaults */
            IF build_Object.tClassName MATCHES "*TOOLBAR*":U THEN
                ASSIGN build_Object.tLayoutPosition = "TOP":U.
            ELSE
            IF build_Object.tClassName MATCHES "*BROWSE*":U THEN
                ASSIGN build_Object.tLayoutPosition = "BOTTOM":U.
            ELSE
            DO:
                FIND FIRST parent_Object WHERE
                           parent_Object.tSmartObjectObj = pdContainerSmartObjectObj
                           NO-ERROR.
                FIND build_ObjectPage WHERE
                     build_ObjectPage.tRecordIdentifier = parent_Object.tRecordIdentifier AND
                     build_ObjectPage.tPageNumber       = 0
                     NO-ERROR.

                IF AVAILABLE build_ObjectPage AND build_ObjectPage.tLayoutCode EQ "06":U THEN
                    ASSIGN build_Object.tLayoutPosition = "M21":U.
                ELSE
                    ASSIGN build_Object.tLayoutPosition = "Centre":U.
            END.    /* not one of the above classes */
        END.    /* layout position is empty */

        /** Set instantiation order
         *  ----------------------------------------------------------------------- **/
        /* Start DB aware (dataobjects) before other visual objects. */
        CASE build_Object.tClassName:
            WHEN "SmartToolbar":U THEN
                IF build_Object.tLayoutPosition BEGINS "TOP":U THEN
                    ASSIGN build_Object.tInstanceOrder = 2.
                ELSE
                    ASSIGN build_Object.tInstanceOrder = 3.
            WHEN "SmartFolder":U THEN
                ASSIGN build_Object.tInstanceOrder = 4.
            OTHERWISE
                IF build_Object.tDbAware THEN
                    ASSIGN build_Object.tInstanceOrder = 1.
                ELSE
                DO:
                    FIND FIRST parent_Object WHERE
                               parent_Object.tSmartObjectObj = pdContainerSmartObjectObj
                               NO-ERROR.
                    IF CAN-DO(parent_Object.tInheritsFromClasses, "Viewer":U) THEN
                    DO:
                        ASSIGN hField[1] = build_Object.tClassBufferHandle:BUFFER-FIELD("Order":U) NO-ERROR.
                        IF VALID-HANDLE(hField[1]) THEN
                            ASSIGN build_Object.tInstanceOrder = hField[1]:BUFFER-VALUE NO-ERROR.
                    END.    /* is a viewer field */
                    ELSE
                        ASSIGN build_Object.tInstanceOrder = 99.
                END.    /* otherwise */
        END CASE.   /* class name */

        /** Page and page instance details.
         *  ----------------------------------------------------------------------- **/
        IF  ryc_object_instance.page_obj <> 0 
        AND ryc_object_instance.page_obj <> ? THEN
        DO:
            FIND FIRST build_ObjectPage WHERE
                       build_ObjectPage.tPageObj = ryc_object_instance.page_obj
                       NO-ERROR.

            /* Update page number onto object instance and instance layout if required */
            ASSIGN build_Object.tPageNumber = build_ObjectPage.tPageNumber.

            /* Add page to layout if not there already */
            IF NOT CAN-DO("06":U, build_ObjectPage.tLayoutCode) AND
               build_Object.tPageNumber                  GT 0   AND
               NUM-ENTRIES(build_Object.tLayoutPosition) EQ 1   THEN
                ASSIGN build_Object.tLayoutPosition = build_Object.tLayoutPosition + ",":U + TRIM(STRING(build_Object.tPageNumber)).
        END.    /* page objects */
        
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME
                                    + ".tRecordIdentifier = ":U + QUOTER(build_Object.tRecordIdentifier)) NO-ERROR.

        /** Set the NAME and ObjectName attributes (if they exist) to the value of the
         *  object instance name. For object instances inheriting from the Field class,
         *  set the instance name temporarily to the value of the FieldName. This is to avoid
         *  problems with dynamic viewers that have been converted from static viewers.
         *  ----------------------------------------------------------------------- **/
        IF CAN-DO(build_Object.tInheritsFromClasses, "Field":U) THEN
        DO:
            ASSIGN hField[1] = hAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.

            /* Don't set to blank or null. If this value is empty later on, we
             * will make sure that there is a valid unique value in it.         */            
            IF VALID-HANDLE(hField[1])                                        AND
               hField[1]:BUFFER-VALUE NE "":U AND hField[1]:BUFFER-VALUE NE ? THEN
                ASSIGN build_Object.tObjectInstanceName = hField[1]:BUFFER-VALUE.
        END.    /* SDFs */

        ASSIGN hField[1] = hAttributeBuffer:BUFFER-FIELD("ObjectName":U) NO-ERROR.
        IF VALID-HANDLE(hField[1]) THEN
            ASSIGN hField[1]:BUFFER-VALUE = build_Object.tObjectInstanceName.

        ASSIGN hField[1] = hAttributeBuffer:BUFFER-FIELD("NAME":U) NO-ERROR.
        IF VALID-HANDLE(hField[1]) THEN
            ASSIGN hField[1]:BUFFER-VALUE = build_Object.tObjectInstanceName.
        
        /* If the object instance has an attribute of "VisualizationType" and
         * this has a value which is not "SmartDataField" and the "SDFFileName"
         * attribute has a value, then the SmartDataField referenced in the attribute
         * value is to be used.
         *
         * All of the existing attribute values and UI events for this obejct instance 
         * will be deleted, and the attribute values and UI events for the SDF will
         * be used. The SDF becomes a temporary object instance for the dynamic viewer. */

        /* Separate assign statements in case the first one fails.
         * That way the second one will still execute.            */
        ASSIGN hField[1] = hAttributeBuffer:BUFFER-FIELD("SdfFileName":U) NO-ERROR.
        ASSIGN hField[2] = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U) NO-ERROR.

        IF hAttributeBuffer:AVAILABLE                   AND
           VALID-HANDLE(hField[1])                      AND
           VALID-HANDLE(hField[2])                      AND
           hField[1]:BUFFER-VALUE NE "":U               AND
           hField[2]:BUFFER-VALUE NE "SmartDataField":U THEN
        DO:
            ASSIGN cSdfFileName = hField[1]:BUFFER-VALUE.
            RUN autoAttachSdf IN TARGET-PROCEDURE ( INPUT cSdfFileName,
                                                    INPUT build_Object.tRecordIdentifier,
                                                    INPUT pdResultObj ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* Auto attach SDF */

        /* Flag container objects to be able to retrieve the contained instances */
        IF plDesignMode EQ YES OR
           ( lbObject.tInstanceIsAContainer EQ YES AND
             ryc_smartObject.static_object  EQ NO  AND
             DYNAMIC-FUNCTION("ignoreContainedInstances":U IN TARGET-PROCEDURE,
                              INPUT lbObject.tClassName,
                              INPUT lbObject.tInheritsFromClasses ) EQ NO      ) THEN
        DO:
            IF NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = ryc_smartObject.object_filename) THEN
            DO:
                CREATE ttObjectsToFetch.
                ASSIGN ttObjectsToFetch.tLogicalObjectName = ryc_smartObject.object_filename.
            END.    /* not in table yet. */
        END.    /* retrieve contained objects */

        /* If, after all of the above, the tObjectInstanceName is still blank, then we need
         * to populate it with a unique value. This is because the code in customizeObjectByResult
         * uses the tObjectInstanceName in its decision of what is customised, etc.                 */
        IF build_Object.tObjectInstanceName EQ "":U OR build_Object.tObjectInstanceName EQ ? THEN
            ASSIGN build_Object.tObjectInstanceName = STRING(build_Object.tObjectInstanceObj).
    END.    /* Object instances */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveContainedInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveMasterObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveMasterObject Procedure 
PROCEDURE retrieveMasterObject :
/*------------------------------------------------------------------------------
  Purpose:     Caches all information fgor a master object, excepting the contained
               instance information.
  Parameters:  pdSmartObjectObj    -
               plDesignMode        -
               pcLogicalObjectName -
  Notes:       * The plLogicalObjectName parameter is needed for cases when a 
                 static object has been requested, particularly for objects where
                 the object extension is stored in the obect_extension field. It 
                 is possible to request such objects using either the unextended name
                 (abc) or the extended name (abc.p). In both cases the correct object
                 will be retrieved from the Repository, because of the code that 
                 splits out the extension. If the object is requested both with
                 and without an extension, the object will be cached twice. It is 
                 not possible to know (on the client side) that abc and abc.p are the
                 same object without resorting to guesswork.
               * The plLogicalObjectName parameter will only contain a value when 
                 this procedure is called from retrieveResultObject.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdSmartObjectObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER plDesignMode             AS LOGICAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicalObjectName      AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE lHasSuperProcedureAttribute     AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lContainerIsTreeview            AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer               AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hField                          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE cResultCode                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL          NO-UNDO.

    DEFINE BUFFER rycso_master      FOR ryc_smartObject.
    DEFINE BUFFER rycso_super       FOR ryc_smartObject.
    DEFINE BUFFER rycso_render      FOR ryc_smartObject.
    DEFINE BUFFER rycso_SDO         FOR ryc_smartObject.
    DEFINE BUFFER ryccr             FOR ryc_customization_result.
    DEFINE BUFFER build_Object      FOR build_Object.
    DEFINE BUFFER build_ObjectPage  FOR build_ObjectPage.
    DEFINE BUFFER build_ObjectLink  FOR build_ObjectLink.

    /* Don't try to creaate the master again. */
    FIND FIRST build_Object WHERE build_Object.tRecordIdentifier = pdSmartObjectObj NO-ERROR.
    
    IF AVAILABLE build_Object THEN
        RETURN.

    /* Find the Master record. */
    FIND FIRST rycso_master WHERE
               rycso_master.smartObject_obj = pdSmartObjectObj
               NO-LOCK.

    FIND FIRST ryccr WHERE
               ryccr.customization_result_obj = rycso_master.customization_result_obj
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryccr THEN
        ASSIGN cResultCode = ryccr.customization_result_code.
    ELSE
        ASSIGN cResultCode = "{&DEFAULT-RESULT-CODE}":U.

    FIND gsc_object_type WHERE
         gsc_object_type.object_type_obj = rycso_master.object_type_obj
         NO-LOCK NO-ERROR.

    FIND FIRST gsc_product_module WHERE
               gsc_product_module.product_module_obj = rycso_master.product_module_obj
               NO-LOCK NO-ERROR.

    /* Get the handle for the attributes of this object. */
    /* Check if the class has been cached already. If not, then create the class in the cache. */
    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, INPUT gsc_object_type.object_type_code).
    /* We can't do much of there are no attributes. */
    IF NOT hClassCacheBuffer:AVAILABLE THEN
        RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' "'Cached Class ' + gsc_object_type.object_type_code "}.

    /* Get the handle to the buffer of the dynamic temp-table for this class.
     * Certain classes also have a CustomSuperProc attribute in addition to
     * having the super procedure stored on the object itself.               */
    ASSIGN hAttributeBuffer            = hClassCacheBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE
           lHasSuperProcedureAttribute = VALID-HANDLE(hAttributeBuffer:BUFFER-FIELD("customSuperProc":U))
           NO-ERROR.

    /* Create Container object. */
    CREATE build_Object.
    ASSIGN build_Object.tLogicalObjectName         = (IF pcLogicalObjectName EQ "":U THEN rycso_master.object_filename ELSE pcLogicalObjectName)
           build_Object.tUserObj                   = 0
           build_Object.tResultCode                = cResultCode
           build_Object.tLanguageObj               = 0
           build_Object.tRecordIdentifier          = rycso_master.smartObject_obj
           build_Object.tContainerRecordIdentifier = 0
           build_Object.tMasterRecordIdentifier    = build_Object.tRecordIdentifier
           build_Object.tClassName                 = gsc_object_type.object_type_code
           build_Object.tClassTableName            = hAttributeBuffer:NAME
           build_Object.tClassBufferHandle         = hAttributeBuffer
           build_Object.tContainerObjectName       = build_Object.tLogicalObjectName
           build_Object.tInstanceIsAContainer      = CAN-FIND(FIRST ryc_object_instance WHERE ryc_object_instance.container_smartObject_obj = rycso_master.smartObject_obj) OR
                                                     CAN-FIND(FIRST ryc_page WHERE ryc_page.container_smartObject_obj = rycso_master.smartObject_obj)
           build_Object.tObjectInstanceName        = rycso_master.object_filename
           build_Object.tObjectInstanceDescription = rycso_master.object_description
           build_Object.tDbAware                   = CAN-DO("{&DBAWARE-OBJECT-TYPES}":U, gsc_object_type.object_type_code)
           build_Object.tLayoutPosition            = "":U        /* This is the master, so no layout */
           build_Object.tDestroyCustomSuper        = YES         /* seems like a good idea to kill off the super proc when done. */
           build_Object.tInstanceOrder             = 0
           build_Object.tPageNumber                = 0
           build_Object.tSmartObjectObj            = rycso_master.smartObject_obj
           build_Object.tInheritsFromClasses       = hClassCacheBuffer:BUFFER-FIELD("inheritsFromClasses":U):BUFFER-VALUE
           build_Object.tProductModuleCode         = gsc_product_module.product_module_code
           build_Object.tObjectIsRunnable          = rycso_master.object_is_runnable
           lContainerIsTreeview                    = CAN-DO(build_Object.tInheritsFromClasses, "DynTree":U).

    /* Add Attributes for master object. */
    DYNAMIC-FUNCTION("createAttributeValues":U,
                     INPUT rycso_master.object_filename,
                     INPUT build_Object.tRecordIdentifier,
                     INPUT hAttributeBuffer,
                     INPUT gsc_object_type.object_type_obj,
                     INPUT rycso_master.smartObject_obj,
                     INPUT 0,
                     INPUT 0                               ).

    /* Cascade UI events from class to master */
    DYNAMIC-FUNCTION("cascadeUiEvents":U,
                     INPUT gsc_object_type.object_type_code,
                     INPUT 0,                               /* from ID (class) */
                     INPUT build_Object.tRecordIdentifier   /* to ID (master) */     ).

    /* Master UI Events */
    DYNAMIC-FUNCTION("createUiEvents":U,
                     INPUT build_Object.tRecordIdentifier,
                     INPUT build_Object.tClassName,
                     INPUT gsc_object_type.object_type_obj,
                     INPUT rycso_master.smartObject_obj,
                     INPUT 0,
                     INPUT 0                               ).

    /* Resolve the procedures that are stored as attributes into 
     * relatively pathed values in the build_Object table.        */
    DYNAMIC-FUNCTION("addObjectProcedures":U IN TARGET-PROCEDURE,
                     INPUT build_Object.tRecordIdentifier,
                     INPUT hAttributeBuffer,
                     INPUT rycso_master.static_object ).

    /* Find the master object's attributes here. */
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(build_Object.tRecordIdentifier) ) NO-ERROR.
    
    /** Set the NAME and ObjectName attributes (if they exist) to the value of the
     *  object instance name. For master objects,  the instance name is the same as
     *  object name.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("ObjectName":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN hField:BUFFER-VALUE = build_Object.tObjectInstanceName.

    ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("NAME":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
        ASSIGN hField:BUFFER-VALUE = build_Object.tObjectInstanceName.

    /* Get the list of treeview objects. */
    IF lContainerIsTreeview AND NOT plDesignMode THEN
        DYNAMIC-FUNCTION("findTreeObjects":U, INPUT hAttributeBuffer:BUFFER-FIELD("RootNodeCode":U):BUFFER-VALUE, INPUT 0).
    
    /* Design-time SDO details */
    ASSIGN build_Object.tSdoSmartObjectObj = rycso_master.sdo_smartObject_obj
           build_Object.tSdoPathedFilename = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager, INPUT rycso_master.sdo_smartObject_obj).

    IF plDesignMode THEN
    DO:
        FIND FIRST rycso_SDO WHERE
                   rycso_SDO.smartObject_obj = rycso_master.sdo_smartObject_obj
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycso_SDO THEN
        DO:
            /* Get the Design time SDO and put in the cache. */
            IF NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = rycso_SDO.object_filename) THEN
            DO:
                CREATE ttObjectsToFetch.
                ASSIGN ttObjectsToFetch.tLogicalObjectName = rycso_SDO.object_filename.
            END.    /* Design Time */
        END.    /* Design time SDO */
    END.    /* design mode only. */
    
    /* Get the information that is associated with the master object, except the contained objects. */
    IF build_Object.tInstanceIsAContainer THEN
    DO:   
        /** Pages and Page Layouts 
         *  We create these ObjectPage* records first since this information may be used
         *  in the retrieveContainedInstances procedure.
         *  ----------------------------------------------------------------------- **/
        /* Page 0 */
        FIND FIRST ryc_layout WHERE
                   ryc_layout.layout_obj = rycso_master.layout_obj
                   NO-LOCK NO-ERROR.
        CREATE build_ObjectPage.
        ASSIGN build_ObjectPage.tRecordIdentifier = build_Object.tRecordIdentifier
               build_ObjectPage.tPageNumber       = 0
               build_ObjectPage.tPageReference    = "":U
               build_ObjectPage.tPageLabel        = "Page Zero"
               build_ObjectPage.tLayoutCode       = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
               build_ObjectPage.tPageInitialized  = NO
               build_ObjectPage.tPageObj          = 0
               build_ObjectPage.tSecurityToken    = "":U
               .
        FOR EACH ryc_page WHERE
                 ryc_page.container_smartobject_obj = rycso_master.smartobject_obj
                 NO-LOCK
                 BY ryc_page.page_sequence:

            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_obj = ryc_page.layout_obj
                       NO-LOCK NO-ERROR.
                       
            CREATE build_ObjectPage.
            ASSIGN build_ObjectPage.tRecordIdentifier = build_Object.tRecordIdentifier
                   build_ObjectPage.tPageNumber       = ryc_page.page_sequence
                   build_ObjectPage.tPageReference    = ryc_page.page_reference
                   build_ObjectPage.tPageLabel        = ryc_page.page_label
                   build_ObjectPage.tLayoutCode       = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
                   build_ObjectPage.tPageInitialized  = NO
                   build_ObjectPage.tPageObj          = ryc_page.page_obj
                   build_ObjectPage.tSecurityToken    = ryc_page.security_token
                   .
        END.    /* pages */

        /** SmartLinks
         *  ----------------------------------------------------------------------- **/
        FOR EACH ryc_smartlink WHERE
                 ryc_smartlink.container_smartobject_obj = rycso_master.smartobject_obj
                 NO-LOCK:
            CREATE build_ObjectLink.
            ASSIGN build_ObjectLink.tRecordIdentifier        = build_Object.tRecordIdentifier
                   build_ObjectLink.tSourceObjectInstanceObj = ryc_smartlink.source_object_instance_obj
                   build_ObjectLink.tTargetObjectInstanceObj = ryc_smartlink.target_object_instance_obj
                   build_ObjectLink.tLinkName                = ryc_smartlink.link_name
                   build_ObjectLink.tLinkCreated             = NO
                   .
        END.    /* SmartLinks */
    END.    /* This is a container */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveMasterObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveResultObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveResultObject Procedure 
PROCEDURE retrieveResultObject :
/*------------------------------------------------------------------------------
  Purpose:     Creates object records for the object requested, as well as any
               contained object instances and their master objects.
  Parameters:  pcLogicalObjectName -
               pcResultCode        -
               plDesignMode        -                     
  Notes:       * This procedure should only ever run with a DB-aware connection.
               * User level customisations are performed elsewhere.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName      AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER plDesignMode             AS LOGICAL          NO-UNDO.    

    DEFINE VARIABLE dResultObj              AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cRootFile               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cRootFileExt            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectExt              AS CHARACTER                NO-UNDO.

    DEFINE BUFFER rycso_requested       FOR ryc_smartObject.
    DEFINE BUFFER build_Object          FOR build_Object.

    /* Ensure that the customisation result exists, if this is not for the 
     * default result code.                                                */
    IF pcResultCode NE "":U AND pcResultCode NE "{&DEFAULT-RESULT-CODE}":U THEN
    DO:
        FIND FIRST ryc_customization_result WHERE
                   ryc_customization_result.customization_result_code = pcResultCode
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_customization_result THEN
            RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' pcResultCode}.
        ELSE
            ASSIGN dResultObj = ryc_customization_result.customization_result_obj.
    END.    /* non default result code */

    /* First try to find the object, using the name as passed in.
     * Don't search for the extension here. This will enable us to retrieve the
     * correct object in cases where the extension is stored in the extension field
     * and the request is made without the extension. Because of the unique indexes
     * on the ryc_smartObject table the object_filename field must be unique - without
     * taking the object_extension into cognisance.
     * The above is only value for objects with extensions. Dynamic objects will be 
     * correctly fetched by the first FIND FIRST.                                      */
    FIND FIRST rycso_requested WHERE
               rycso_requested.object_filename          = pcLogicalObjectName AND
               rycso_requested.customization_result_obj = dResultObj
               NO-LOCK NO-ERROR.

    IF NOT AVAILABLE rycso_requested THEN
    DO:
        /* Strip the name apart, and use the pices to find the obejct. */
        RUN extractRootFile IN gshRepositoryManager (INPUT pcLogicalObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        /* Figure out what the extension is. */
        ASSIGN cObjectExt = TRIM(REPLACE(cRootFileExt, (cRootFile + ".":U), "":U)).

        /* If there is a root file with an extension, first try and find the object name using this.
         * We perform this check only if the root filename differs from the pcLogicalObjectName. It
         * shouldn't, but it is theoretically possible for the pcLogicalObjectName to contain a pathed
         * filename.                                                                                  */
        IF cRootFileExt NE "":U AND pcLogicalObjectName NE cRootFileExt THEN
            FIND FIRST rycso_requested WHERE
                       rycso_requested.object_filename          = cRootFileExt AND
                       rycso_requested.customization_result_obj = dResultObj
                       NO-LOCK NO-ERROR.

        /* Now try to find the object using the separate extension. */
        IF NOT AVAILABLE rycso_requested AND cObjectExt NE "":U THEN
            FIND FIRST rycso_requested WHERE
                       rycso_requested.object_filename          = cRootFile  AND
                       rycso_requested.customization_result_obj = dResultObj AND
                       rycso_requested.object_extension         = cObjectExt
                       NO-LOCK NO-ERROR.
    END.    /* n/a requested */

    IF NOT AVAILABLE(rycso_requested) THEN
    DO:
        /* There is no guarantee that there are customisations for any given object.
         * We do need to check for the existence of the default object, though.    */
        IF pcResultCode EQ "{&DEFAULT-RESULT-CODE}":U THEN
            RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' pcLogicalObjectName}.
        ELSE
            RETURN.
    END.    /* n/a smartobject */

    /** Cache the requested object itself.
     *  ----------------------------------------------------------------------- **/
    RUN retrieveMasterObject IN TARGET-PROCEDURE( INPUT rycso_requested.smartObject_obj,
                                                  INPUT plDesignMode,
                                                  INPUT pcLogicalObjectName             ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /* The build_Object record should be available here. */
    FIND FIRST build_Object WHERE build_Object.tRecordIdentifier = rycso_requested.smartObject_obj NO-ERROR.

    /* Get contained instances */
    IF build_Object.tInstanceIsAContainer AND
       ( plDesignMode EQ YES OR
         DYNAMIC-FUNCTION("ignoreContainedInstances":U,
                          INPUT build_Object.tClassName,
                          INPUT build_Object.tInheritsFromClasses ) EQ NO  )      THEN
    DO:
        RUN retrieveContainedInstances IN TARGET-PROCEDURE ( INPUT rycso_requested.smartObject_obj,
                                                             INPUT pcLogicalObjectName,
                                                             INPUT pcResultCode,
                                                             INPUT build_Object.tRecordIdentifier,
                                                             INPUT dResultObj,
                                                             INPUT plDesignMode                     ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* a container and non-static object. */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* retrieveResultObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addObjectProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addObjectProcedures Procedure 
FUNCTION addObjectProcedures RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT phAttributeBuffer   AS HANDLE,
      INPUT plStaticObject      AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Resolves the procedures that are stored as attribute values into
            relatively pathed values in the build_Object temp-table.
    Notes:  * Supported attributes/field names:
              RenderingProcedure -> tObjectPathedFilename
              SuperProcedure     -> tCustomSuperProcedure
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hField                          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE lHasCustomSuperProcAttribute    AS LOGICAL          NO-UNDO.
    
    DEFINE BUFFER rycso_render      FOR ryc_smartObject.
    DEFINE BUFFER rycso_super       FOR ryc_smartObject.
    DEFINE BUFFER build_Object      FOR build_Object.

    /* Refind the current build_Object record. We have a separate buffer
     * defined for this so that we don't have problems with the record scope
     * in this funciton's calling procedures.                               */
    FIND FIRST build_Object WHERE build_Object.tRecordIdentifier = pdInstanceId.

    /* Find the master object's attributes here. */
    phAttributeBuffer:FIND-FIRST(" WHERE ":U + phAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

    /* Historically, DynLokups and DynCombos used an attribute called "CustomSuperProc" to
     * store their super procedures. This functionality was replaced by the "SuperProcedure"
     * attribute, but the DynLookups and DynCOmbos still use this attribute.                 */
    ASSIGN hField = phAttributeBuffer:BUFFER-FIELD("CustomSuperProc":U) NO-ERROR.
    ASSIGN lHasCustomSuperProcAttribute = VALID-HANDLE(hField).
    
    /** The rendering procedure (physical object) is stored in the RenderingProcedure
     *  attribute as an object_filename. It needs to be taken from the attributes
     *  and turned into a relatively pathed filename.
     *  ----------------------------------------------------------------------- **/
    IF NOT plStaticObject THEN
    DO:
        ASSIGN hField = phAttributeBuffer:BUFFER-FIELD("RenderingProcedure":U) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
            ASSIGN build_Object.tObjectPathedFilename = hField:BUFFER-VALUE.
    END.    /* not a static object */

    IF build_Object.tObjectPathedFilename EQ ? THEN
        ASSIGN build_Object.tObjectPathedFilename = "":U.

    /* Get an object id for the procedure. If this is a static object, or 
     * the rendering attribute could not be found, then we use the master object iteself. */
    IF build_Object.tObjectPathedFilename NE "":U THEN
        ASSIGN dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                  INPUT build_Object.tObjectPathedFilename, INPUT 0 /* customisation result */ ).
    ELSE
        ASSIGN dSmartObjectObj = build_Object.tSmartObjectObj.
        /* rycso_master.smartObject_obj. */

    /* Now resolve the object id into a relatively pathed filename.
     * We do a find on this record because we want to add this record to the 
     * ttObjectsToFetch table. If we didn't need to do that, we could simply call
     * getObjectPathedName() with the object id.                                 */
    FIND FIRST rycso_render WHERE
               rycso_render.smartObject_obj = dSmartObjectObj
               NO-LOCK NO-ERROR.
    IF AVAILABLE rycso_render THEN
    DO:
        ASSIGN build_Object.tObjectPathedFilename = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                                     INPUT rycso_render.smartObject_obj ).
        /* Retrieve the super procedure information as well. */
        IF NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = rycso_render.object_filename) THEN
        DO:
            CREATE ttObjectsToFetch.
            ASSIGN ttObjectsToFetch.tLogicalObjectName = rycso_render.object_filename.
        END.    /* need to get the rendering procedure. */
    END.    /* available RenderingProcedure procedure. */

    /** Super Procedure Details.
     *  Only update the super procedure if there is a super procedure at the master
     *  level. If the value of the SuperProcedure attribute has been inherited from
     *  the class level, then we set the value at the master to blank.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hField = phAttributeBuffer:BUFFER-FIELD("SuperProcedure":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
    DO:
        /* If the SuperProcedure attribute has been stored at the Class level, then we ignore 
         * it since the class loader procedure (loadClass in the Repository Manager) will take
         * care of launching these super procedures.                                            */
        IF DYNAMIC-FUNCTION("getWhereStoredLevel":U IN gshRepositoryManager, INPUT phAttributeBuffer, INPUT hField) EQ "CLASS":U THEN
            ASSIGN build_Object.tCustomSuperProcedure = "":U.
        ELSE
            ASSIGN build_Object.tCustomSuperProcedure = hField:BUFFER-VALUE.

        /* Get an object id for the procedure. If this is a static object, or 
         * the SuperProcedure attribute could not be found, then we use the master object iteself. */
        IF build_Object.tCustomSuperProcedure NE "":U AND build_Object.tCustomSuperProcedure NE ? THEN
            ASSIGN dSmartObjectObj = DYNAMIC-FUNCTION("getSmartObjectObj":U IN gshRepositoryManager,
                                                      INPUT build_Object.tCustomSuperProcedure, INPUT 0 /* customisation result */ ).
        ELSE
            ASSIGN dSmartObjectObj = 0.

        /* Now resolve the object id into a relatively pathed filename. */
        FIND FIRST rycso_super WHERE
                   rycso_super.smartObject_obj = dSmartObjectObj
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycso_super THEN
        DO:
            ASSIGN build_Object.tCustomSuperProcedure = DYNAMIC-FUNCTION("getObjectPathedName":U IN gshRepositoryManager,
                                                                         INPUT rycso_super.smartObject_obj).
    
            /* SmartDataFields need the super procedure in attribute form. */
            IF lHasCustomSuperProcAttribute THEN
            DO:
                phAttributeBuffer:FIND-FIRST(" WHERE ":U + phAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.
                ASSIGN phAttributeBuffer:BUFFER-FIELD("customSuperProc":U):BUFFER-VALUE = build_Object.tCustomSuperProcedure.
            END.    /* update super proc attribute. */
    
            /* Retrieve the super procedure information as well. */
            IF NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = rycso_super.object_filename) THEN
            DO:
                CREATE ttObjectsToFetch.
                ASSIGN ttObjectsToFetch.tLogicalObjectName = rycso_super.object_filename.
            END.    /* need to get the super. */
        END.    /* super procedure exists */
    END.    /* valid SuperProcedure attribute */

    RETURN TRUE.
END FUNCTION.   /* addObjectProcedures */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cascadeAttributes Procedure 
FUNCTION cascadeAttributes RETURNS LOGICAL
    ( INPUT pdFromIdentifier        AS DECIMAL,
      INPUT pdToIdentifier          AS DECIMAL,
      INPUT phAttributeBuffer       AS HANDLE       ) :
/*------------------------------------------------------------------------------
  Purpose:  Cascades the attribute values from one record to another.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hTargetBuffer           AS HANDLE                  NO-UNDO.

    CREATE BUFFER hTargetBuffer FOR TABLE phAttributeBuffer BUFFER-NAME phAttributeBuffer:NAME.

    phAttributeBuffer:FIND-FIRST(" WHERE ":U + phAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdFromIdentifier) ) NO-ERROR.

    IF phAttributeBuffer:AVAILABLE THEN
    DO:
        hTargetBuffer:FIND-FIRST(" WHERE ":U + hTargetBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdToIdentifier) ) NO-ERROR.

        IF NOT hTargetBuffer:AVAILABLE THEN
        DO:
            hTargetBuffer:BUFFER-CREATE().
            hTargetBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = pdToIdentifier.
        END.    /* n/a */

        hTargetBuffer:BUFFER-COPY(phAttributeBuffer, "tRecordIdentifier":U) NO-ERROR.
        hTargetBuffer:BUFFER-RELEASE().
    END.    /* available source record */  

    DELETE OBJECT hTargetBuffer NO-ERROR.
    ASSIGN hTargetBuffer = ?.

    RETURN TRUE.
END FUNCTION.   /* cascadeAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cascadeUiEvents Procedure 
FUNCTION cascadeUiEvents RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pdFromIdentifier        AS DECIMAL,
      INPUT pdToIdentifier          AS DECIMAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  Cascades the attribute values from one record to another.
    Notes:  
------------------------------------------------------------------------------*/     
    DEFINE BUFFER parent_ObjectUiEvent      FOR build_ObjectUiEvent.
    
    FOR EACH parent_ObjectUiEvent WHERE
             parent_ObjectUiEvent.tClassName        = pcClassName     AND
             parent_ObjectUiEvent.tRecordIdentifier = pdFromIdentifier   :
        
        FIND FIRST build_ObjectUiEvent WHERE
                   build_ObjectUiEvent.tClassName        = pcClassName                    AND
                   build_ObjectUiEvent.tRecordIdentifier = pdToIdentifier                 AND
                   build_ObjectUiEvent.tEventName        = parent_ObjectUiEvent.tEventName
                   NO-ERROR.
        IF NOT AVAILABLE build_ObjectUiEvent THEN
            CREATE build_ObjectUiEvent.

        BUFFER-COPY parent_ObjectUiEvent
                EXCEPT tRecordIdentifier
            TO build_ObjectUiEvent
                ASSIGN build_ObjectUiEvent.tRecordIdentifier = pdToIdentifier.
    END.    /* master records */
    
    RETURN TRUE.
END FUNCTION.   /* cascadeUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanupBuildObjectRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanupBuildObjectRecords Procedure 
FUNCTION cleanupBuildObjectRecords RETURNS LOGICAL
    ( INPUT pcResultCode        AS CHARACTER,
      INPUT pcOldResultCode     AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Cleans up the contents of the BUILD_OBJECT temp-tables so that only 
            the records that correspond to the result code are returned.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCacheObjectBuffer              AS HANDLE               NO-UNDO.

    DEFINE BUFFER lbObject      FOR build_Object.

    /** Once we have merged all of the customisations, we delete all the build_Object
     *  records which are not relevant. At the end of this we should only have one set
     *  of build_Object* records.
     *  ----------------------------------------------------------------------- **/
    FOR EACH build_Object WHERE build_Object.tResultCode <> pcResultCode:
        /* ObjectPage */
        FOR EACH build_ObjectPage WHERE build_ObjectPage.tRecordIdentifier = build_Object.tRecordIdentifier:
            DELETE build_ObjectPage.
        END.    /* Build_ObjectPage */

        /* ObjectLink */
        FOR EACH build_ObjectLink WHERE build_ObjectLink.tRecordIdentifier = build_Object.tRecordIdentifier:
            DELETE build_ObjectLink.
        END.    /* Build_ObjectLink */
    
        /* ObjectUiEvent */
        FOR EACH build_ObjectUiEvent WHERE build_ObjectUiEvent.tRecordIdentifier = build_Object.tRecordIdentifier:
            DELETE build_ObjectUiEvent.
        END.    /* Build_ObjectUiEvent */

        /* Delete the attribute value records */
        build_Object.tClassBufferHandle:FIND-FIRST(" WHERE ":U + build_Object.tClassBufferHandle:NAME + ".tRecordIdentifier = " + QUOTER(build_Object.tRecordIdentifier) + " ":U) NO-ERROR.
        IF build_Object.tClassBufferHandle:AVAILABLE THEN
        DO:
            /* Check if the object is in the cache. If it is, then we don't delete the attributes
             * for that object. 
             *
             * When running with -E (European numeric format) there may arise a situation, particularly
             * when using the AppBuilder, where an object is retrieved in both run-time and design-time modes.
             * Because the AppBuilder switches between American numeric format and the session's
             * numeric format, there may be issues with the way that some of the obejcts are requested,
             * particularly with the UserObj, since this is stored as a string by the login function. This 
             * will be stored as the session's numeric format (seeing that it is a decimal). While the session
             * has the same numeric format, all if fine, but as soon as the numeric format is dynamically changed, 
             * problems will result because session proeprties are stored as string values.
             * This check ensures that the relevant attributes are not deleted from the cache.
             *
             * See http://icf.possenet.org/issues/show_bug.cgi?id=7449 for details of this.
             */
            ASSIGN hCacheObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT build_Object.tRecordIdentifier).

            IF NOT hCacheObjectBuffer:AVAILABLE THEN
                build_Object.tClassBufferHandle:BUFFER-DELETE().

            build_Object.tClassBufferHandle:BUFFER-RELEASE().
        END.    /* available record in the attribute TT. */

        DELETE build_Object.
    END.    /* delete all  build_Objects which are not customised fully. */
    
    IF pcOldResultCode NE "":U THEN
    DO:
        FOR EACH build_Object WHERE build_Object.tResultCode = pcResultCode:
            ASSIGN build_Object.tResultCode = pcOldResultCode.
        END.    /* each build-object */
        ASSIGN pcResultCode = pcOldResultCode.
    END.    /* Old result code not "" */

    /* Update the tMasterRecordIdentifier ID on each object. */
    FOR EACH build_Object WHERE
             build_Object.tUserObj    = 0        AND
             build_Object.tResultCode = pcResultCode:
        FIND FIRST lbObject WHERE
                   lbObject.tLogicalObjectName   = build_Object.tLogicalObjectName AND
                   lbObject.tObjectInstanceObj   = 0                               AND
                   lbObject.tUserObj             = build_Object.tUserObj           AND
                   lbObject.tResultCode          = build_Object.tResultCode
                   NO-ERROR.
        IF AVAILABLE lbObject THEN
            ASSIGN build_Object.tMasterRecordIdentifier = lbObject.tRecordIdentifier.
    END.    /* update tRecordIdentifier. */

    RETURN TRUE.
END FUNCTION.   /* cleanupBuildObjectRecords */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createAttributeValues Procedure 
FUNCTION createAttributeValues RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER,
      INPUT pdRecordIdentifier          AS DECIMAL,
      INPUT phClassAttributeBuffer      AS HANDLE,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates entries in the relevant attribute table
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDataType                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iCurrentLevel               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iWhereStored                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iWhereConstant              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCurrentAttributeEntry      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cWhereStoredList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWhereConstantList          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    
    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER rym_data_version          FOR rym_data_version.

    /* Determine where these attributes are stored.
     * We don't use this API to populate the attribute table for the class, so 
     * only MASTER and INSTNANCE levels are populated here. The class is set in
     * createClassCache.                                                        */
    IF pdObjectInstanceObj NE 0 THEN
        ASSIGN iCurrentLevel = {&STORED-AT-INSTANCE}.
    ELSE
        ASSIGN iCurrentLevel = {&STORED-AT-MASTER}.
        
    phClassAttributeBuffer:FIND-FIRST(" WHERE ":U + phClassAttributeBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdRecordIdentifier)) NO-ERROR.

    IF NOT phClassAttributeBuffer:AVAILABLE THEN
    DO:
        phClassAttributeBuffer:BUFFER-CREATE().
        ASSIGN phClassAttributeBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = pdRecordIdentifier.

        ASSIGN cWhereStoredList   = phClassAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE
               cWhereConstantList = phClassAttributeBuffer:BUFFER-FIELD("tWhereConstant":U):BUFFER-VALUE
               .
        ASSIGN hField = phClassAttributeBuffer:BUFFER-FIELD("LogicalObjectName":U) NO-ERROR.

        IF VALID-HANDLE(hField) THEN
        DO:
            ASSIGN hField:BUFFER-VALUE = pcLogicalObjectName.
            ASSIGN iCurrentAttributeEntry = hField:POSITION - 1
                   iWhereStored           = INTEGER(ENTRY(iCurrentAttributeEntry, cWhereStoredList))
                   iWhereStored           = iWhereStored + iCurrentLevel
                   NO-ERROR.
            ENTRY(iCurrentAttributeEntry, cWhereStoredList) = STRING(iWhereStored) NO-ERROR.
        END.    /* valid field handle */
    END.    /* n/a record */
    ELSE
        ASSIGN cWhereStoredList   = phClassAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE
               cWhereConstantList = phClassAttributeBuffer:BUFFER-FIELD("tWhereConstant":U):BUFFER-VALUE
               .
    IF NOT phClassAttributeBuffer:AVAILABLE THEN RETURN FALSE.

    /* LogicalVersion */
    ASSIGN hField = phClassAttributeBuffer:BUFFER-FIELD("LogicalVersion":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
    DO:
        FIND FIRST rym_data_version WHERE
                   rym_data_version.related_entity_key      = pcLogicalObjectName AND
                   rym_data_version.related_entity_mnemonic = "RYCSO":U
                   NO-LOCK NO-ERROR.
    
        IF AVAILABLE rym_data_version THEN
        DO:
            ASSIGN hField:BUFFER-VALUE = STRING(rym_data_version.data_version_number, "999999":U) NO-ERROR.
            /* Set the relevant level where this attribute is stored. */
            ASSIGN iCurrentAttributeEntry = hField:POSITION - 1
                   iWhereStored           = INTEGER(ENTRY(iCurrentAttributeEntry, cWhereStoredList))
                   iWhereStored           = iWhereStored + iCurrentLevel
                   NO-ERROR.
            ENTRY(iCurrentAttributeEntry, cWhereStoredList) = STRING(iWhereStored) NO-ERROR.
        END.    /* avail data version */
    END.    /* valid LogicalVersion field */

    FOR EACH ryc_attribute_value WHERE
             ryc_attribute_value.object_type_obj           = pdObjectTypeObj           AND
             ryc_attribute_value.smartobject_obj           = pdSmartObjectObj          AND
             ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj       AND
             ryc_attribute_value.container_smartobject_obj = pdContainerSmartObjectObj 
             NO-LOCK:
        ASSIGN hField = phClassAttributeBuffer:BUFFER-FIELD(ryc_attribute_value.attribute_label) NO-ERROR.

        IF VALID-HANDLE(hField) THEN
        DO:
            ASSIGN cDataType = hField:DATA-TYPE.
            CASE cDataType:              
                WHEN "DECIMAL":U THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.decimal_value.
                WHEN "INTEGER":U THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.integer_value.
                WHEN "DATE":U    THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.date_value.
                WHEN "RAW":U     THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.raw_value.
                WHEN "LOGICAL":U THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.logical_value.
                WHEN "RECID":U   THEN ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.integer_value.
                OTHERWISE             ASSIGN hField:BUFFER-VALUE = ryc_attribute_value.character_value.
            END CASE.   /* data type */

            /* Set the relevant level where this attribute is stored.
             * We build a sum of all levels where this attribute is stored.
             * A unique value is created depending on where the value is stored. */

            /** The :POSITION attribute seems to offset the true position by +1. As a 
             *  temporary measure, remove that offset. (V91D1B)
             *  ----------------------------------------------------------------------- **/
            ASSIGN iCurrentAttributeEntry = hField:POSITION - 1
                   iWhereStored           = INTEGER(ENTRY(iCurrentAttributeEntry, cWhereStoredList))
                   iWhereStored           = iWhereStored + iCurrentLevel
                   NO-ERROR.
            ENTRY(iCurrentAttributeEntry, cWhereStoredList) = STRING(iWhereStored) NO-ERROR.

            IF ryc_attribute_value.constant_value THEN
                ASSIGN iWhereConstant         = INTEGER(ENTRY(iCurrentAttributeEntry, cWhereConstantList))
                       iWhereConstant         = iWhereConstant + iCurrentLevel
                       NO-ERROR.
            ENTRY(iCurrentAttributeEntry, cWhereConstantList) = STRING(iWhereConstant) NO-ERROR.
        END.    /* exists in the class and is not a derived value. */
    END.    /* attribute values of the object instance. */

    ASSIGN phClassAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE   = cWhereStoredList
           phClassAttributeBuffer:BUFFER-FIELD("tWhereConstant":U):BUFFER-VALUE = cWhereConstantList
           .
    phClassAttributeBuffer:BUFFER-RELEASE().

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN TRUE.
END FUNCTION.   /* createAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createUiEvents Procedure 
FUNCTION createUiEvents RETURNS LOGICAL
    ( INPUT pdRecordIdentifier          AS DECIMAL,
      INPUT pcClassName                 AS CHARACTER,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates entries in the UI Event table.
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE BUFFER ryc_ui_event          FOR ryc_ui_event.
    
    FOR EACH ryc_ui_event WHERE
             ryc_ui_event.object_type_obj           = pdObjectTypeObj           AND
             ryc_ui_event.smartobject_obj           = pdSmartObjectObj          AND
             ryc_ui_event.object_instance_obj       = pdObjectInstanceObj       AND
             ryc_ui_event.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK:

        FIND FIRST build_ObjectUiEvent WHERE
                   build_ObjectUiEvent.tRecordIdentifier = pdRecordIdentifier           AND
                   build_ObjectUiEvent.tClassName        = pcClassName                  AND
                   build_ObjectUiEvent.tEventName        = ryc_ui_event.event_name
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE build_ObjectUiEvent THEN
        DO:
            CREATE build_ObjectUiEvent.
            ASSIGN build_ObjectUiEvent.tRecordIdentifier = pdRecordIdentifier
                   build_ObjectUiEvent.tClassName        = pcClassName
                   build_ObjectUiEvent.tEventName        = ryc_ui_event.event_name
                   .
        END.    /* create instance record. */

        ASSIGN build_ObjectUiEvent.tActionType     = ryc_ui_event.action_type
               build_ObjectUiEvent.tActionTarget   = ryc_ui_event.action_target
               build_ObjectUiEvent.tEventAction    = ryc_ui_event.event_action
               build_ObjectUiEvent.tEventParameter = ryc_ui_event.event_parameter
               build_ObjectUiEvent.tEventDisabled  = ryc_ui_event.event_disabled
               .
    END.    /* each UI event */    
               
    RETURN TRUE.
END FUNCTION.   /* createUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findTreeObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findTreeObjects Procedure 
FUNCTION findTreeObjects RETURNS LOGICAL
    ( INPUT pcParentNodeCode        AS CHARACTER,
      INPUT pdParentNodeObj         AS DECIMAL     ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the logical object names of all the nodes for a particular  
            dynamic treeview.
    Notes:  * If the ParentNodeCode is passed in, we assume that this is the top level.
            * We need to make sure that each object only goes into the list once.
-----------------------------------------------------------------------------*/

    /* Top Level */
    IF pcParentNodeCode NE "":U THEN
    DO:
        FIND FIRST gsm_node WHERE
                   gsm_node.node_code = pcParentNodeCode
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gsm_node THEN
            RETURN TRUE.

        IF gsm_node.data_source_type                                                                   EQ "SDO":U AND 
           NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = gsm_node.data_source ) THEN
        DO:
            CREATE ttObjectsToFetch.
            ASSIGN ttObjectsToFetch.tLogicalObjectName = gsm_node.data_source.
        END.    /* Data Source */

        IF gsm_node.primary_sdo                                                                           NE "":U AND
           NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = gsm_node.primary_sdo ) THEN
        DO:
            CREATE ttObjectsToFetch.
            ASSIGN ttObjectsToFetch.tLogicalObjectName = gsm_node.primary_sdo.
        END.    /* primary SDO */

        ASSIGN pdParentNodeObj = gsm_node.node_obj.
    END.    /* top level. */

    FOR EACH gsm_node WHERE
             gsm_node.parent_node_obj = pdParentNodeObj
             NO-LOCK:
        IF gsm_node.data_source_type                                                                   EQ "SDO":U AND 
           NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = gsm_node.data_source ) THEN
        DO:
            CREATE ttObjectsToFetch.
            ASSIGN ttObjectsToFetch.tLogicalObjectName = gsm_node.data_source.
        END.    /* Data Source */

        IF gsm_node.primary_sdo                                                                           NE "":U AND
           NOT CAN-FIND(FIRST ttObjectsToFetch WHERE ttObjectsToFetch.tLogicalObjectName = gsm_node.primary_sdo ) THEN
        DO:
            CREATE ttObjectsToFetch.
            ASSIGN ttObjectsToFetch.tLogicalObjectName = gsm_node.primary_sdo.
        END.    /* primary SDO */

        DYNAMIC-FUNCTION("findTreeObjects":U IN TARGET-PROCEDURE, INPUT  "":U, INPUT gsm_node.node_obj).
    END.    /* each node */

    RETURN TRUE.
END FUNCTION.   /* findTreeObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ignoreContainedInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ignoreContainedInstances Procedure 
FUNCTION ignoreContainedInstances RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcInheritsFromClasses   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether the current class, or one of the classes it
            inherits from, must ignore the retrieval of the contained instances.
    Notes:  * There will typically be fewer entries in the preprocessor than in
              inherits from parameter, so it is quicker to loop through the pre-
              processor.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIgnoreLoop             AS INTEGER                  NO-UNDO.

    DO iIgnoreLoop = 1 TO NUM-ENTRIES(gcClassIgnoreContainedInstances):
        IF CAN-DO(pcInheritsFromClasses, ENTRY(iIgnoreLoop, gcClassIgnoreContainedInstances)) OR
           CAN-DO(pcClassName,           ENTRY(iIgnoreLoop, gcClassIgnoreContainedInstances)) THEN
            RETURN YES.
    END.    /* Ignore loop */

    RETURN NO.
END FUNCTION.   /* ignoreContainedInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

