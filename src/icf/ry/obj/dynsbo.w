&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sbo _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sbo _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sbo 
/*---------------------------------------------------------------------------------
  File: dynsbo.w

  Description:  Dymanic SBO proxy

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/10/2003  Author:     

  Update Notes: Created from Template rysttasboo.w

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

&scop object-name       dynsbo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


{src/adm2/globals.i}

DEFINE VARIABLE gcLogicalObjectName         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcCurrentObjectName         AS CHARACTER            NO-UNDO.

/* Define the container_* tables that local control the object. */
{ ry/app/ryobjretri.i &CONTAINER-TABLES=YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBusinessObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-CONTAINER VIRTUAL

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Update-Target,Navigation-Target,Commit-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF




/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addAllLinks sbo  _DB-REQUIRED
FUNCTION addAllLinks RETURNS LOGICAL
    ( /* No parameters */   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildContainerTables sbo 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName sbo  _DB-REQUIRED
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBusinessObject
   Allow: Smart
   Container Links: Data-Target,Data-Source,Update-Target,Navigation-Target,Commit-Target
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
  CREATE WINDOW sbo ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 59.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sbo 
/* ************************* Included-Libraries *********************** */

{src/adm2/sbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sbo
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sbo 


/* ***************************  Main Block  *************************** */
  {set QueryObject YES}.
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects sbo 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hObjectProcedure        AS HANDLE                   NO-UNDO.
DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE hSuper                  AS HANDLE                   NO-UNDO.
DEFINE VARIABLE iSuperCnt               AS INTEGER                  NO-UNDO.
DEFINE VARIABLE cSuper                  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
DEFINE VARIABLE dContRecId              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hQuery1                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDataTargets            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataTarget             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSdoForeignFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cASDivision             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAttrBuffer             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAttrList               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCreated                AS LOGICAL    NO-UNDO.

    {get ObjectsCreated lCreated}.
    IF lCreated THEN RETURN.  /* Contained objects have been created */

    {get LogicalObjectName gcLogicalObjectName}.
    IF gcLogicalObjectName = "" OR gcLogicalObjectName = ? THEN
      RETURN.  /* we don't know how to create objects w/out Logical Name */

    DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT gcLogicalObjectName,
                     INPUT "",
                     INPUT "",
                     INPUT NO       ).
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
    /* we need the master SBO object */
    hObjectBuffer:FIND-FIRST("WHERE ":U + hObjectBuffer:NAME + ".tLogicalObjectName = '" + gcLogicalObjectName + "'"
                             + "AND ":U + hObjectBuffer:NAME + ".tContainerRecordIdentifier = 0").
    ASSIGN
      dContRecId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
      hAttrBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

    hAttrBuffer:FIND-FIRST(" WHERE ":U + hAttrBuffer:NAME + ".tRecordIdentifier = " + QUOTER(dContRecId)).
    /* When run as a CLIENT or with a local DB connection the SBO exists as an instance */
    /* within a container. The parent container sets the SBO's properties accordingly. */
    /*On the SERVER side, the SBO must manage itself by getting the Master Object property */
    /* values and setting them on itself */
    {get ASDivision cASDivision}.
    IF cASDivision = "SERVER" THEN DO:
      DEFINE VARIABLE cMasterList AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.

      cMasterList = hAttrBuffer:BUFFER-FIELD('tMasterList'):BUFFER-VALUE NO-ERROR.
      DO iEntry = 1 TO NUM-ENTRIES(cMasterList):
        hField = hAttrBuffer:BUFFER-FIELD(INTEGER(ENTRY(iEntry, cMasterList))).
        cAttrList = cAttrList 
                        + (IF cAttrList = "":U THEN "":U ELSE CHR(3))
                        + hField:NAME + CHR(4) 
                        + (IF hField:BUFFER-VALUE EQ ? THEN "?":U ELSE STRING(hField:BUFFER-VALUE)).
      END.
      /* Due to a bug, tMasterList is empty. So, temporarily set the required attributes here */
      {set DataLogicProcedure STRING(hAttrBuffer:BUFFER-FIELD('DataLogicProcedure':U):BUFFER-VALUE)}.
    END.
   
    /* build the local container_* tables based on this SBO's RecordID */
    DYNAMIC-FUNCTION("buildContainerTables":U, dContRecId).

    /* Store the list of settable attributes. */
    IF hAttrBuffer:AVAILABLE THEN
      FOR EACH container_Object WHERE
               container_Object.tContainerRecordIdentifier = dContRecId      AND
               container_Object.tTargetProcedure           = TARGET-PROCEDURE 
               NO-LOCK
               BY container_Object.tInstanceOrder:
  
        ASSIGN gcCurrentObjectName = "InstanceID=":U + STRING(container_Object.tRecordIdentifier) 
                                     + CHR(1) + container_Object.tLogicalObjectName.
        RUN constructObject ( INPUT  (container_Object.tObjectPathedFilename + 
                                      (IF container_Object.tDbAware THEN CHR(3) + "DBAWARE" ELSE "":U)),
                              INPUT  ?,  /* non-visual */
                              INPUT  "LaunchLogicalName":U + CHR(4) + container_Object.tLogicalObjectName
                                     + CHR(3) + container_Object.tAttributeList,
                              OUTPUT hObjectProcedure                   ).
        /* Keep ordered list of objects constructed on container */
        IF VALID-HANDLE(hObjectProcedure) THEN
          container_Object.tObjectInstanceHandle = hObjectProcedure.
        ELSE
          container_Object.tObjectInstanceHandle =  ?.
  
        IF VALID-HANDLE(hObjectProcedure) AND container_Object.tCustomSuperProcedure NE "":U THEN
        DO:
            { launch.i
                &PLIP        = container_Object.tCustomSuperProcedure
                &OnApp       = 'NO'
                &Iproc       = ''
                &NewInstance = YES
            }
            IF VALID-HANDLE(hPlip) THEN
            DO:
                hObjectProcedure:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
                ASSIGN container_Object.tCustomSuperHandle  = hPlip.
            END.    /* custom super created OK */
        END.    /* object created ok, and super exists. */
  
      END.    /* objects on a page. */
    
    /* Get the container object and assign the super procedure to the temp table field tCustomSuperHandle */
    FOR EACH container_Object WHERE
             container_Object.tContainerRecordIdentifier = 0      AND
             container_Object.tTargetProcedure           = TARGET-PROCEDURE 
             NO-LOCK:
       
       IF container_object.tCustomSuperProcedure > "" THEN
         DO iSuperCnt = 1 TO NUM-ENTRIES(TARGET-PROCEDURE:SUPER-PROCEDURES):
            hSuper = WIDGET-HANDLE(ENTRY(iSuperCnt,TARGET-PROCEDURE:SUPER-PROCEDURES)) NO-ERROR.
            IF VALID-HANDLE(hSuper) THEN
            DO:
               IF REPLACE(hSuper:FILE-NAME,"~\":U,"/") = REPLACE(container_Object.tCustomSuperProcedure,"~\":U,"/") THEN
               DO:
                 ASSIGN container_Object.tCustomSuperHandle  = hSuper.
                 LEAVE.
               END.
            END.
         END.
    END.

    DYNAMIC-FUNCTION("addAllLinks":U).

    RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sbo  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addAllLinks sbo  _DB-REQUIRED
FUNCTION addAllLinks RETURNS LOGICAL
    ( /* No parameters */   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hSourceObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTargetObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    DEFINE BUFFER source_Object         FOR container_Object.
    DEFINE BUFFER target_Object         FOR container_Object.
    DEFINE BUFFER container_Link        FOR container_Link.

    FOR EACH container_Link WHERE
             container_Link.tTargetProcedure = TARGET-PROCEDURE AND
             container_Link.tLinkCreated     = NO                    :

        FIND FIRST source_Object WHERE
                   source_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   source_Object.tObjectInstanceObj = container_Link.tSourceObjectInstanceObj
                   NO-ERROR.

        FIND FIRST target_Object WHERE
                   target_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   target_Object.tObjectInstanceObj = container_Link.tTargetObjectInstanceObj
                   NO-ERROR.

        ASSIGN hSourceObject = ( IF AVAILABLE source_Object AND container_Link.tSourceObjectInstanceObj GT 0 THEN 
                                    source_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).
        ASSIGN hTargetObject = ( IF AVAILABLE target_Object  AND container_Link.tTargetObjectInstanceObj GT 0 THEN 
                                    target_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).
        IF VALID-HANDLE(hSourceObject) AND VALID-HANDLE(hTargetObject) AND hSourceObject NE hTargetObject THEN
        DO:
            RUN addLink (hSourceObject, container_Link.tLinkName, hTargetObject) NO-ERROR.            
            ASSIGN container_Link.tLinkCreated = YES.
        END.    /* valid souirce and target */
    END.    /* each link */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildContainerTables sbo 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates information which will be used by this container to construct
            objects on the container.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hLinkBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerObject        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerLink          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dInstanceInstanceId     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cASDivision             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQuery1                 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hQuery2                 AS HANDLE     NO-UNDO.
    
    EMPTY TEMP-TABLE container_Object.
    EMPTY TEMP-TABLE container_Link.

    ASSIGN hContainerObject = BUFFER container_Object:HANDLE
           hContainerLink   = BUFFER container_Link:HANDLE
           hObjectBuffer = DYNAMIC-FUNCT("getCacheObjectBuffer":U IN gshRepositoryManager, 
                                         INPUT pdInstanceId)
           hLinkBuffer   = DYNAMIC-FUNCT("getCacheLinkBuffer":U IN gshRepositoryManager).

    CREATE QUERY hQuery1.

    hQuery1:SET-BUFFERS(hObjectBuffer).
    hQuery1:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerRecordIdentifier = " 
                           + QUOTER(pdInstanceId) + " OR ":U 
                           + hObjectBuffer:NAME + ".tRecordIdentifier = "          
                           + QUOTER(pdInstanceId) ).
    hQuery1:QUERY-OPEN().
    hQuery1:GET-FIRST().
    DO WHILE hObjectBuffer:AVAILABLE:
        hContainerObject:BUFFER-CREATE().
        hContainerObject:BUFFER-COPY(hObjectBuffer).

        ASSIGN dInstanceInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               hAttributeBuffer    = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME 
                                    + ".tRecordIdentifier = ":U + QUOTER(dInstanceInstanceId) ).

        /* Store the list of settable attributes. */
        ASSIGN hContainerObject:BUFFER-FIELD("tAttributeList":U):BUFFER-VALUE = 
                        DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager,
                                         INPUT hAttributeBuffer,
                                         INPUT dInstanceInstanceId).
        /* Store all of the attributes in RAW format */
        hAttributeBuffer:RAW-TRANSFER(TRUE, hContainerObject:BUFFER-FIELD("tRawAttributes":U)).

        ASSIGN hContainerObject:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.

        hContainerObject:BUFFER-RELEASE().
        hQuery1:GET-NEXT().
    END.    /* available buffer */

/*     {get ASDivision cASDivision}.          */
/*     IF cASDivision <> "SERVER":U THEN DO:  */
      CREATE QUERY hQuery2.
      hQuery2:SET-BUFFERS(hLinkBuffer).
      hQuery2:QUERY-PREPARE(" FOR EACH ":U + hLinkBuffer:NAME + " WHERE ":U 
                            + hLinkBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ).
      hQuery2:QUERY-OPEN().
      hQuery2:GET-FIRST().
      DO WHILE hLinkBuffer:AVAILABLE:
          hContainerLink:BUFFER-CREATE().
          hContainerLink:BUFFER-COPY(hLinkBuffer).
          ASSIGN hContainerLink:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.
          hContainerLink:BUFFER-RELEASE().
  
          hQuery2:GET-NEXT().
      END.    /* available link */
      DELETE OBJECT hQuery2 NO-ERROR.
/*     END.  */

    DELETE OBJECT hQuery1 NO-ERROR.

    RETURN TRUE.
END FUNCTION.   /* buildContainerTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName sbo  _DB-REQUIRED
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

  RETURN gcCurrentObjectName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

