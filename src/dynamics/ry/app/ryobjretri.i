&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: ryobjretri.i

  Description:  Repository Object Retrieval Include

  Purpose:      Repository Object Retrieval Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/08/2002  Author:     

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* This include should default to defining the TTs used for retrieval purposes. */
&IF DEFINED(CONTAINER-TABLES) EQ 0 AND DEFINED(RETRIEVAL-TABLES) EQ 0 &THEN
    &GLOBAL-DEFINE RETRIEVAL-TABLES YES
    &GLOBAL-DEFINE CONTAINER-TABLES NO
&ENDIF

&IF {&RETRIEVAL-TABLES} &THEN
/* This temp-table stores the names of all the classes (object types) and their associated
   temp-table names and handles to the default buffers of the temp-tables that have been
   created to store each class' default attributes. A seperate temp-table is defined for each class, containg a
   seperate field for every attribute in the class, plus some extra control fields
   The table for each class is called "cache_" + the class name, e.g. "cache_dynview".
   This table is updated in the function createClassCacheRecord in the reposistory manager, which is
   called from the createClassCache procedure which caches the attribute values for an object type.
*/
DEFINE TEMP-TABLE ttClass           NO-UNDO
    FIELD ClassName                 AS CHARACTER        /* The name of the class, e.g. dynview */
    FIELD ClassTableName            AS CHARACTER        /* The name of the class' temp-table, e.g. cache_dynview */
    FIELD ClassBufferHandle         AS HANDLE           /* Handle to the dynamic temp-table's buffer */
    FIELD ClassObjectName           AS CHARACTER        /*  */
    FIELD InheritsFromClasses       AS CHARACTER        /* Stores the class names of all classes that this class inherits from */
    FIELD SuperProcedures           AS CHARACTER        /* Stores the pathed super procedures for this class, and only this class. */
    FIELD SuperProcedureModes       AS CHARACTER        /* Stores super procedures mode 'STATELESS' or 'STATEFUL'  */
    FIELD SuperHandles              AS CHARACTER        /* Stores the started super procedure handles for this class, and only this class. */
    FIELD InstanceBufferHandle      AS HANDLE           /* Stores the started instances. */
   INDEX idxMain
        ClassName
    INDEX idxTableName      AS PRIMARY UNIQUE
        ClassTableName
    .

DEFINE TEMP-TABLE cache_Object NO-UNDO     RCODE-INFORMATION
    FIELD tLogicalObjectName                AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Logical Object Name"
    FIELD tUserObj                          AS DECIMAL   FORMAT ">,>>>,>>>,>>9.999999-" COLUMN-LABEL "User Obj"
    FIELD tResultCode                       AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Result Code"        /* can be a set of result codes */
    FIELD tRunAttribute                     AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Run Attribute"
    FIELD tLanguageObj                      AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Language Obj"
    FIELD tRecordIdentifier                 AS DECIMAL   FORMAT ">,>>>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Record Id"
    FIELD tContainerRecordIdentifier        AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Container Record Id"       /* The tRecordIdentifier of the cache_Object record which act as a container to this record. */
    FIELD tMasterRecordIdentifier           AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Master Record Id"       /* This is the recordIdentifier of the cacne_Object record which is the Master of this instnce. */
    FIELD tClassName                        AS CHARACTER FORMAT "X(35)" COLUMN-LABEL "Class Name"
    FIELD tClassTableName                   AS CHARACTER FORMAT "X(35)" COLUMN-LABEL "Class Table Name"
    FIELD tClassBufferHandle                AS HANDLE                   COLUMN-LABEL "Class Buffer Handle"   /* Buffer handle which points to the TT containing the attributes for this object.*/
    FIELD tContainerObjectName              AS CHARACTER FORMAT "X(70)" COLUMN-LABEL "Container Name"
    FIELD tInstanceIsAContainer             AS LOGICAL                  COLUMN-LABEL "Container"
    FIELD tObjectPathedFilename             AS CHARACTER FORMAT "X(70)" COLUMN-LABEL "Pathed Filename"
    FIELD tObjectInstanceObj                AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Object Instance Obj"
    FIELD tObjectInstanceName               AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Object Instance Name"
    FIELD tObjectInstanceDescription        AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Object Instance Description"

    FIELD tDbAware                          AS LOGICAL                  COLUMN-LABEL "DB Aware"
    FIELD tLayoutPosition                   AS CHARACTER FORMAT "x(10)" COLUMN-LABEL "Layout Position"
    FIELD tCustomSuperProcedure             AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Super Procedure"
    FIELD tDestroyCustomSuper               AS LOGICAL                  COLUMN-LABEL "Destroy Super"
    FIELD tInstanceOrder                    AS INTEGER                  COLUMN-LABEL "Instance Order"
    FIELD tPageNumber                       AS INTEGER                  COLUMN-LABEL "Page Number"
    FIELD tSmartObjectObj                   AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Smartobject Obj"
    FIELD tSdoSmartObjectObj                AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "SDO Smartobject Obj"       /* the design-time SDO which is associated with an Object. */
    FIELD tSdoPathedFilename                AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "SDO Pathed Filename"
    FIELD tInheritsFromClasses              AS CHARACTER FORMAT "x(70)" COLUMN-LABEL "Inherits From Classes"       /* Stored the class names of all classes that this class inherits from */
    FIELD tProductModuleCode                AS CHARACTER
    FIELD tObjectIsRunnable                 AS LOGICAL     INITIAL NO
    /* Fields for security */
    FIELD tSecuredReadOnly                  AS LOGICAL INITIAL NO
    FIELD tSecuredHidden                    AS LOGICAL INITIAL NO
    FIELD tSecuredDisabled                  AS LOGICAL INITIAL NO
    FIELD tObjectTranslated                 AS LOGICAL INITIAL NO
    INDEX idxContainedObjects
        tContainerObjectName
        tLogicalObjectName  
        tResultCode         
        tUserObj            
    INDEX udxRecordIdent            AS PRIMARY UNIQUE
        tRecordIdentifier
    INDEX idxCustomisation
        tResultCode
        tUserObj
        tObjectInstanceObj
        tLogicalObjectName
        /* Add unique ID to avoid PSC eror 1422 (IZ 6735) */
        tRecordIdentifier
    INDEX idxContainerRecordIdentifier
        tContainerRecordIdentifier
    INDEX idxFindInCache        /* used in cacheObjectOnClient() */
        tLogicalObjectName
        tUserObj
        tResultCode
        tRunAttribute
        tLanguageObj
        tObjectInstanceObj
    .

DEFINE TEMP-TABLE cache_ObjectPage NO-UNDO RCODE-INFORMATION
    FIELD tRecordIdentifier         AS DECIMAL   FORMAT ">,>>>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Record Identifier"
    FIELD tPageNumber               AS INTEGER   FORMAT ">>9"                    COLUMN-LABEL "Page Number"
    FIELD tPageReference            AS CHARACTER FORMAT "x(28)"                  COLUMN-LABEL "Page Reference"
    FIELD tPageLabel                AS CHARACTER FORMAT "X(46)"                  COLUMN-LABEL "Page Label"
    FIELD tLayoutCode               AS CHARACTER FORMAT "X(27)"                  COLUMN-LABEL "Layout Code"
    FIELD tPageInitialized          AS LOGICAL   INITIAL NO                      COLUMN-LABEL "Page Initialized"
    /* for finding this record from the page object instance. */
    FIELD tPageObj                  AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Page Obj"
    FIELD tSecurityToken            AS CHARACTER FORMAT "x(46)"                  COLUMN-LABEL "Security Token"
    INDEX idxMain
        tRecordIdentifier
    INDEX idxPage
        tPageObj
    INDEX idxSequence           AS PRIMARY
        tPageNumber
        tRecordIdentifier
    INDEX idxReference
        tPageReference
        tRecordIdentifier
    .

DEFINE TEMP-TABLE cache_ObjectPageInstance          NO-UNDO     RCODE-INFORMATION
    FIELD tRecordIdentifier         AS DECIMAL   FORMAT ">,>>>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Record Identifier"
    FIELD tPageNumber               AS INTEGER   FORMAT ">>9"                    COLUMN-LABEL "Page Number"
    FIELD tObjectInstanceObj        AS DECIMAL   FORMAT ">>,>>>,>>>,>>9.999999-" COLUMN-LABEL "Object Instance Obj"
    FIELD tObjectInstanceHandle     AS HANDLE                                    COLUMN-LABEL "Object Instance Handle"
    FIELD tObjectInstanceName       AS CHARACTER FORMAT "X(46)"                  COLUMN-LABEL "Object Instance Name"
    FIELD tObjectTypeCode           AS CHARACTER FORMAT "X(46)"                  COLUMN-LABEL "Class Code"
    FIELD tLayoutPosition           AS CHARACTER FORMAT "X(10)"                  COLUMN-LABEL "Layout Position"
    INDEX idxMain
        tRecordIdentifier
    INDEX idxPage
        tPageNumber
        tLayoutPosition
    INDEX idxName
        tObjectInstanceName
    .

DEFINE TEMP-TABLE cache_ObjectLink                  NO-UNDO     RCODE-INFORMATION
    FIELD tRecordIdentifier         AS DECIMAL
    FIELD tSourceObjectInstanceObj  AS DECIMAL
    FIELD tTargetObjectInstanceObj  AS DECIMAL
    FIELD tLinkName                 AS CHARACTER FORMAT "x(35)" COLUMN-LABEL "Link Name"
    FIELD tLinkCreated              AS LOGICAL      INITIAL NO
    INDEX idxMain
          tRecordIdentifier
          tSourceObjectInstanceObj
          tTargetObjectInstanceObj
          tLinkName
    .

/* This temp-table is initially used internally in the repository manager to store the list of UI events for a 
   particular object type (class). It is used in buildDenormalisedAttributes. It is built up to
   contain all UI events in the complete class hierarchy, dealing with the fact that
   object types can inherit from other object types. The full class is resolved into this temp-table. The UI
   event is only stored at the first (lowest) level it is found in when dealing with a hierarchy.
   For the master set of UI events for a class, the class name is temporarily set to "buildDenormalisedAttributes"
   and then set to the correct class, and the record identifier is set to 0.
*/
DEFINE TEMP-TABLE cache_ObjectUiEvent               NO-UNDO     RCODE-INFORMATION
    FIELD tClassName                     AS CHARACTER FORMAT "x(15)":U COLUMN-LABEL "Class Name"   /* for master class = "buildDenormalisedAttributes" temporarily, then actual class name */
    FIELD tRecordIdentifier              AS DECIMAL       /* identifier for table within class name, 0 for master set */
    FIELD tEventName                     LIKE ryc_ui_event.event_name
    FIELD tActionType                    LIKE ryc_ui_event.action_type
    FIELD tActionTarget                  LIKE ryc_ui_event.action_target
    FIELD tEventAction                   LIKE ryc_ui_event.event_action 
    FIELD tEventParameter                LIKE ryc_ui_event.event_parameter 
    FIELD tEventDisabled                 LIKE ryc_ui_event.event_disabled
    INDEX idxMain           AS PRIMARY  /* Use to find instances of an object. */
        tRecordIdentifier
        tEventName
        tClassName
    INDEX idxClass
        tClassName
        tRecordIdentifier
    INDEX idxEvent
        tEventName
        tRecordIdentifier
    .

/* Temp-table used for working with buffer handles.*/

/**  This Temp-table is functionally obselete and will be deleted in the near 
 *   future. It will be made obselete as soon as all dependencies are removed.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE cache_BufferCache                 NO-UNDO     RCODE-INFORMATION
    FIELD tBufferHandle             AS HANDLE
    FIELD tBufferName               AS CHARACTER
    FIELD tIsClassAttributeTable    AS LOGICAL
    INDEX idxBufferHandle
        tBufferHandle
        tIsClassAttributeTable
    INDEX idxBufferName
        tBufferName
        tIsClassAttributeTable
    .

/* These temp-tables are used to construct the objects to be returned in serverFetchObject.
 * Once the object has been constructed as it should be, then the contents are returned and
 * will be used to populate the cache_Object* temp-tables.                                 */
DEFINE TEMP-TABLE build_Object              LIKE cache_Object.
DEFINE TEMP-TABLE build_ObjectPage          LIKE cache_ObjectPage.
DEFINE TEMP-TABLE build_ObjectPageInstance  LIKE cache_ObjectPageInstance.
DEFINE TEMP-TABLE build_ObjectLink          LIKE cache_ObjectLink.
DEFINE TEMP-TABLE build_ObjectUiEvent       LIKE cache_ObjectUiEvent.
&ENDIF  /* RETRIEVAL-TABLES */

&IF {&CONTAINER-TABLES} &THEN
/** The tables below will be used by the Dynamics Containers to store the
 *  object information within themselves.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE container_Object              NO-UNDO
    FIELD tTargetProcedure                  AS HANDLE
    FIELD tLogicalObjectName                AS CHARACTER
    FIELD tClassName                        AS CHARACTER
    FIELD tRecordIdentifier                 AS DECIMAL
    FIELD tContainerRecordIdentifier        AS DECIMAL
    FIELD tMasterRecordIdentifier           AS DECIMAL
    FIELD tClassTableName                   AS CHARACTER
    FIELD tClassBufferHandle                AS HANDLE
    FIELD tObjectInstanceHandle             AS HANDLE
    FIELD tObjectInstanceObj                AS DECIMAL
    FIELD tObjectPathedFilename             AS CHARACTER
    FIELD tDbAware                          AS LOGICAL
    FIELD tLayoutPosition                   AS CHARACTER
    FIELD tCustomSuperProcedure             AS CHARACTER
    FIELD tCustomSuperHandle                AS HANDLE
    FIELD tDestroyCustomSuper               AS LOGICAL
    FIELD tInstanceOrder                    AS INTEGER
    FIELD tPageNumber                       AS INTEGER
    FIELD tRawAttributes                    AS RAW
    FIELD tObjectIsRunnable                 AS LOGICAL
    /* The fields below are specifically for use by containers (frames and/or windows) */
    FIELD tContainerHandles                 AS CHARACTER
    FIELD tObjectHandles                    AS CHARACTER
    FIELD tToolbarHandles                   AS CHARACTER
    FIELD tPageLinkList                     AS CHARACTER
    FIELD tResizeOnPage                     AS INTEGER
    INDEX idxTargetProcedure
        tTargetProcedure
    INDEX idxInstances
        tTargetProcedure
        tContainerRecordIdentifier
    INDEX idxSuper
        tTargetProcedure
        tDestroyCustomSuper        
    .

DEFINE TEMP-TABLE container_Page        NO-UNDO
    FIELD tTargetProcedure          AS HANDLE
    FIELD tRecordIdentifier         AS DECIMAL
    FIELD tPageNumber               AS INTEGER
    FIELD tLayoutCode               AS CHARACTER
    FIELD tPageLabel                AS CHARACTER
    FIELD tPageInitialized          AS LOGICAL
    INDEX idxTargetProcedure
        tTargetProcedure
        tPageNumber
    INDEX idxRecordIdentifier
        tRecordIdentifier
    .

DEFINE TEMP-TABLE container_Link        NO-UNDO
    FIELD tTargetProcedure          AS HANDLE
    FIELD tSourceObjectInstanceObj  AS DECIMAL
    FIELD tTargetObjectInstanceObj  AS DECIMAL
    FIELD tLinkName                 AS CHARACTER
    FIELD tLinkCreated              AS LOGICAL      INITIAL NO
    INDEX idxMain
        tTargetProcedure
        tLinkCreated
    .
&ENDIF  /* CONTAINER-TABLES */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 23.14
         WIDTH              = 56.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


