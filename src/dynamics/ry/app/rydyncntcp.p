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
  File: rydyncntcp.p

  Description:  Dynamics Container Class Object Proc

  Purpose:      Dynamics Container Class Object Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/21/2002  Author:     Peter Judge

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydyncntcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

/* temp-table for translations */
{ af/app/aftttranslate.i }

DEFINE VARIABLE ghQuery                 AS HANDLE   EXTENT 20           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getNextQueryOrdinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextQueryOrdinal Procedure 
FUNCTION getNextQueryOrdinal RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replicateContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replicateContainer Procedure 
FUNCTION replicateContainer RETURNS LOGICAL
    ( INPUT phObjectBuffer              AS HANDLE,
      INPUT pdOldContainerInstanceId    AS DECIMAL,
      INPUT pdNewContainerInstanceId    AS DECIMAL  )  FORWARD.

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
         HEIGHT             = 22.38
         WIDTH              = 82.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* Make sure that there's a unique value for the TT object IDs. */
IF gsdTempUniqueId EQ 0 OR gsdTempUniqueId EQ ? THEN
    RUN seedTempUniqueID IN gshSessionManager.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

ASSIGN cDescription = "Dynamics Container Class Object Procedure".

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

&IF DEFINED(EXCLUDE-validateClassData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateClassData Procedure 
PROCEDURE validateClassData :
/*------------------------------------------------------------------------------
  Purpose:     Performs certain customisations for objects belonging to the
               Container classes.
  Parameters:  phObjectBuffer      -
               pcLogicalObjectName -
               pcResultCode        -
               pdUserObj           -
               pcRunAttribute      -
               pdLanguageObj       -
               pdInstanceId        -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId                 AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE lTranslationEnabled             AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE hObjectQuery                    AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hField                          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hContainerAttributeBuffer       AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hFolderAttributeBuffer          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hPageBuffer                     AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hClassBuffer                    AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hClassObject                    AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hObjectBuffer                   AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLocalPageBuffer                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE dObjectObj                      AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dFolderRecordIdentifier         AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE dMasterInstanceId               AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE cWindowName                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cSecuredTokens                  AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cTranslationEnabled             AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cPageLabels                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cTabLabel                       AS CHARACTER        NO-UNDO.  
    DEFINE VARIABLE cTabEnabled                     AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cPageToken                      AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE iLoop                           AS INTEGER          NO-UNDO.
    

    /* Finds the relevant record. We know that this is available at this stage, since we have just performed this
     * action is the caller. */
    IF pdInstanceId EQ 0 THEN
        /* This call has the (intentional) side-effect of repositioning the cache object to this record. */
        DYNAMIC-FUNCTION("isObjectCached":U IN gshRepositoryManager,
                         INPUT pcLogicalObjectName,
                         INPUT pdUserObj,
                         INPUT pcResultCode,
                         INPUT pcRunAttribute,
                         INPUT pdLanguageObj,
                         INPUT NO               ).      /* if we are here then we are never in design mode */

    ASSIGN hObjectBuffer      = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId)
           pdInstanceId       = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           dMasterInstanceId  = hObjectBuffer:BUFFER-FIELD("tMasterRecordIdentifier":U):BUFFER-VALUE
           .
    /* Replicate this container if needed */
    IF dMasterInstanceId NE pdInstanceId THEN
    DO:
        /* Create instances-of-instances */
        DYNAMIC-FUNCTION("replicateContainer":U,
                         INPUT hObjectBuffer,
                         INPUT dMasterInstanceId,       /* Find the children using the MasterRecordIdentifier */
                         INPUT pdInstanceId        ).   /* New Instances created with the current RecordIdentifier as ContainerRI */

        /* Once these records are created, we need to find the new versions. */
        hObjectBuffer:FIND-FIRST(" WHERE ":U + hObjectBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.
    END.    /* this is an instance, and not a master container. This is probably be a DynFrame */

    ASSIGN hContainerAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

    ASSIGN cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                  INPUT "translationEnabled":U,
                                                  INPUT NO).
    ASSIGN lTranslationEnabled = LOGICAL(cTranslationEnabled) NO-ERROR.
    IF lTranslationEnabled EQ ? THEN
        ASSIGN lTranslationEnabled = YES.

    EMPTY TEMP-TABLE ttTranslate.

    /* For folder tabs */
    RUN tokenSecurityGet IN gshSecurityManager (INPUT ?, 
                                                INPUT pcLogicalObjectName,
                                                INPUT pcRunAttribute,
                                                OUTPUT cSecuredTokens).


    hContainerAttributeBuffer:FIND-FIRST(" WHERE ":U + hContainerAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.
    ASSIGN hField      = hContainerAttributeBuffer:BUFFER-FIELD("WindowName":U)
           cWindowName = hField:BUFFER-VALUE
           NO-ERROR.

    /** Set the ObjectSecured and ObjectTranslated properties to yes. We do this 
     *  to prevent the translation and security checks from happening more than
     *  once.  Set the TokenSecurity attribute as well for use client side.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hContainerAttributeBuffer:BUFFER-FIELD("ObjectTranslated":U):BUFFER-VALUE = YES
           hContainerAttributeBuffer:BUFFER-FIELD("ObjectSecured":U):BUFFER-VALUE    = YES
           hContainerAttributeBuffer:BUFFER-FIELD("SecuredTokens":U):BUFFER-VALUE    = cSecuredTokens
           NO-ERROR.
    IF VALID-HANDLE(hField) THEN
    DO:
        CREATE ttTranslate.
        ASSIGN ttTranslate.dLanguageObj       = 0
               ttTranslate.cObjectName        = pcLogicalObjectName
               ttTranslate.lGlobal            = NO
               ttTranslate.lDelete            = NO
               ttTranslate.cWidgetType        = "TITLE":U
               ttTranslate.cWidgetName        = "TITLE":U
               ttTranslate.hWidgetHandle      = ?
               ttTranslate.iWidgetEntry       = 0
               ttTranslate.cOriginalLabel     = cWindowName
               ttTranslate.cTranslatedLabel   = "":U
               ttTranslate.cOriginalTooltip   = "":U
               ttTranslate.cTranslatedTooltip = "":U
               .
    END.    /* valid field */

    /* This function retrieves the next query from a pool of them. */
    ASSIGN hObjectQuery = DYNAMIC-FUNCTION("getQueryHandle":U IN TARGET-PROCEDURE).

    /* Use a separate buffer to avoid issues with buffer scope etc. */
    CREATE BUFFER hLocalObjectBuffer FOR TABLE hObjectBuffer BUFFER-NAME "local_cache_Object":U.

    hObjectQuery:SET-BUFFERS(hLocalObjectBuffer).
    hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                           + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId)  + " AND ":U
                           + hLocalObjectBuffer:NAME + ".tResultCode                = " + QUOTER(pcResultCode)  + " AND ":U
                           + hLocalObjectBuffer:NAME + ".tUserObj                   = " + QUOTER(pdUserObj)     + " AND ":U
                           + hLocalObjectBuffer:NAME + ".tRunAttribute              = " + QUOTER(pcRunAttribute)+ " AND ":U
                           + hLocalObjectBuffer:NAME + ".tLanguageObj               = " + QUOTER(pdLanguageObj) + " NO-LOCK ":U ).

    hObjectQuery:QUERY-OPEN().
    hObjectQuery:GET-FIRST().

    DO WHILE hLocalObjectBuffer:AVAILABLE:
        /** We are going to perform translations on the Tab labels, as well as 
         *  security.
         *  ----------------------------------------------------------------------- **/
        IF CAN-DO(hLocalObjectBuffer:BUFFER-FIELD("tInheritsFromClasses":U):BUFFER-VALUE, "SmartFolder":U) THEN
        DO:
            ASSIGN hFolderAttributeBuffer  = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                   dFolderRecordIdentifier = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
                   .
            hFolderAttributeBuffer:FIND-FIRST(" WHERE ":U + hFolderAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dFolderRecordIdentifier) ).

            ASSIGN hField = hFolderAttributeBuffer:BUFFER-FIELD("FolderLabels":U) NO-ERROR.

            IF VALID-HANDLE(hField) THEN
            DO:
                ASSIGN cPageLabels = hFolderAttributeBuffer:BUFFER-FIELD("FolderLabels":U):BUFFER-VALUE.

                DO iLoop = 1 TO NUM-ENTRIES(cPageLabels, "|":U):
                    ASSIGN cTabLabel = ENTRY(iLoop, cPageLabels, "|":U).

                    /* Translations */
                    CREATE ttTranslate.
                    ASSIGN ttTranslate.dLanguageObj       = 0
                           ttTranslate.cObjectName        = pcLogicalObjectName
                           ttTranslate.lGlobal            = NO
                           ttTranslate.lDelete            = NO
                           ttTranslate.cWidgetType        = "TAB":U
                           ttTranslate.cWidgetName        = "TAB":U
                           ttTranslate.hWidgetHandle      = ?
                           ttTranslate.iWidgetEntry       = iLoop
                           ttTranslate.cOriginalLabel     = cTabLabel
                           ttTranslate.cTranslatedLabel   = "":U
                           ttTranslate.cOriginalTooltip   = "":U
                           ttTranslate.cTranslatedTooltip = "":U
                           .
                END.    /* loop through page labels */
            END.    /* Folder Labels available */
        END.    /* SmartFolder */

        /** Also perform any further Class-related actions by running validateClassData
         *  --------------------------------------------------------------------------- **/

        ASSIGN hClassObject = DYNAMIC-FUNCTION("launchClassObject":U IN gshRepositoryManager,
                                               INPUT hLocalObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE ).
        IF VALID-HANDLE(hClassObject) AND LOOKUP("validateClassData":U, hClassObject:INTERNAL-ENTRIES) GT 0 THEN
        DO:
            /* Pass in all parameters anyway, but the tRecordIdentifier is going to be used to find the correct record. */
            RUN validateClassData IN hClassObject ( INPUT hLocalObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE,
                                                    INPUT pcResultCode,
                                                    INPUT pdUserObj,
                                                    INPUT pcRunAttribute,
                                                    INPUT pdLanguageObj,
                                                    INPUT hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE ) NO-ERROR.
        END.    /* can run validateClassData(). */

        hObjectQuery:GET-NEXT().
    END.    /* available object buffer */
    hObjectQuery:QUERY-CLOSE().


    /** Security 
     *  ----------------------------------------------------------------------- **/
    ASSIGN hField = hFolderAttributeBuffer:BUFFER-FIELD("TabEnabled":U) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
    DO:
        ASSIGN cTabEnabled = hField:BUFFER-VALUE.
        IF NUM-ENTRIES(cTabEnabled, "|":U) NE NUM-ENTRIES(cPageLabels, "|":U) THEN
            ASSIGN cTabEnabled = FILL("yes|":U, NUM-ENTRIES(cPageLabels, "|":U))
                   cTabEnabled = RIGHT-TRIM(cTabEnabled, "|":U)
                   .
    END.    /* valid TabEnabled */

    ASSIGN hPageBuffer = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager).

    CREATE BUFFER hLocalPageBuffer FOR TABLE hPageBuffer BUFFER-NAME "localPage":U.

    hObjectQuery:SET-BUFFERS(hLocalPageBuffer).
    hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + hLocalPageBuffer:NAME + " WHERE ":U
                               + hLocalPageBuffer:NAME + ".tRecordIdentifier = " + QUOTER(pdInstanceId) ).

    hObjectQuery:QUERY-OPEN().

    hObjectQuery:GET-FIRST().
    DO WHILE hLocalPageBuffer:AVAILABLE:
        ASSIGN cPageToken = hLocalPageBuffer:BUFFER-FIELD("tSecurityToken":U):BUFFER-VALUE.

        /* Security */
        IF cPageToken                                             NE "":U AND
           cPageToken                                             NE ?    AND
           ( CAN-DO(cSecuredTokens, cPageToken)                      OR
             CAN-DO(cSecuredTokens, REPLACE(cPageToken, "&":U, "":U))   ) THEN
            ENTRY(LOOKUP(hLocalPageBuffer:BUFFER-FIELD("tPageLabel":U):BUFFER-VALUE, cPageLabels, "|":U),cTabEnabled, "|":U) = STRING(NO).

        hObjectQuery:GET-NEXT().
    END.    /* page available */
    hObjectQuery:QUERY-CLOSE().

    /* Clean up. */
    DELETE OBJECT hLocalPageBuffer NO-ERROR.
    ASSIGN hLocalPageBuffer = ?.

    /** Apply the translations.
     *  ----------------------------------------------------------------------- **/    
    IF lTranslationEnabled THEN
        RUN multiTranslation IN gshTranslationManager ( INPUT NO, INPUT-OUTPUT TABLE ttTranslate ).

    FOR EACH ttTranslate WHERE ttTranslate.cObjectName = pcLogicalObjectName:
        /* Set the translated tab labels */
        IF ttTranslate.cWidgetType EQ "TAB":U THEN
        DO:
            IF ttTranslate.cOriginalLabel   NE ttTranslate.cTranslatedLabel AND
               ttTranslate.cTranslatedLabel NE "":U                         AND
               ttTranslate.cTranslatedLabel NE ?                            AND
               ttTranslate.cTranslatedLabel NE "?":U                        THEN
                ENTRY(ttTranslate.iWidgetEntry, cPageLabels, "|":U) = ttTranslate.cTranslatedLabel.
            ELSE
                ENTRY(ttTranslate.iWidgetEntry, cPageLabels, "|":U) = ttTranslate.cOriginalLabel.
        END.    /* TAB */
        ELSE
        DO:
            hContainerAttributeBuffer:FIND-FIRST(" WHERE ":U + hContainerAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

            /* Title */
            IF ttTranslate.cWidgetName EQ "TITLE" THEN
            DO:
                IF ttTranslate.cOriginalLabel   NE ttTranslate.cTranslatedLabel AND
                   ttTranslate.cTranslatedLabel NE "":U                         AND
                   ttTranslate.cTranslatedLabel NE ?                            AND
                   ttTranslate.cTranslatedLabel NE "?":U                        THEN
                    ASSIGN hContainerAttributeBuffer:BUFFER-FIELD("WindowName":U):BUFFER-VALUE = ttTranslate.cTranslatedLabel.
                ELSE
                    ASSIGN hContainerAttributeBuffer:BUFFER-FIELD("WindowName":U):BUFFER-VALUE = ttTranslate.cOriginalLabel.
            END.    /* Title */
        END.    /* container */
    END.    /* each translation */

    /** Folder stuff 
     *  ----------------------------------------------------------------------- **/
    hLocalObjectBuffer:FIND-FIRST(" WHERE ":U + hLocalObjectBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dFolderRecordIdentifier) ) NO-ERROR.
    IF hLocalObjectBuffer:AVAILABLE THEN
    DO:
        ASSIGN hFolderAttributeBuffer = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

        hFolderAttributeBuffer:FIND-FIRST(" WHERE ":U + hFolderAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dFolderRecordIdentifier) ).

        ASSIGN hFolderAttributeBuffer:BUFFER-FIELD("TabEnabled":U):BUFFER-VALUE   = cTabEnabled
               hFolderAttributeBuffer:BUFFER-FIELD("FolderLabels":U):BUFFER-VALUE = cPageLabels
               NO-ERROR.
    END.    /* available SmartFolder object */

    /* Delete the buffer we have just created. */
    DELETE OBJECT hLocalObjectBuffer NO-ERROR.
    ASSIGN hLocalObjectBuffer        = ?
           hField                    = ?
           hContainerAttributeBuffer = ?
           hFolderAttributeBuffer    = ?
           .
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* validateClassData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getNextQueryOrdinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextQueryOrdinal Procedure 
FUNCTION getNextQueryOrdinal RETURNS INTEGER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ordinal or the next query available for use.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNextQueryOrdinal           AS INTEGER              NO-UNDO.

    DO iNextQueryOrdinal = 1 TO EXTENT(ghQuery):
        IF NOT VALID-HANDLE(ghQuery[iNextQueryOrdinal]) THEN
            LEAVE.
        IF VALID-HANDLE(ghQuery[iNextQueryOrdinal]) AND
           ghQuery[iNextQueryOrdinal]:IS-OPEN EQ NO THEN
            LEAVE.
    END.    /* iNextQueryOrdinal */

    RETURN iNextQueryOrdinal.
END FUNCTION.   /* getNextQueryOrdinal */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of a valid query that has not yet been opened.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal               AS INTEGER              NO-UNDO.

    ASSIGN iQueryOrdinal = DYNAMIC-FUNCTION("getNextQueryOrdinal":U IN TARGET-PROCEDURE).

    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal].

    ASSIGN hQuery = ghQuery[iQueryOrdinal].

    RETURN hQuery.
END FUNCTION.   /* getQueryHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replicateContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replicateContainer Procedure 
FUNCTION replicateContainer RETURNS LOGICAL
    ( INPUT phObjectBuffer              AS HANDLE,
      INPUT pdOldContainerInstanceId    AS DECIMAL,
      INPUT pdNewContainerInstanceId    AS DECIMAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Replicates one container object to another.
    Notes:  Effectively makes container objects an instance of an instance.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hUiEventBuffer                  AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicateUiEventBuffer         AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicateAttributeBuffer       AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer              AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicateObjectBuffer          AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hLinkBuffer                     AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicateLinkBuffer            AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hPageBuffer                     AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicatePageBuffer            AS HANDLE           NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal                   AS INTEGER          NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal2                  AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dInstanceId                     AS DECIMAL          NO-UNDO.    
    DEFINE VARIABLE dObjectInstanceId               AS DECIMAL          NO-UNDO.

    ASSIGN hUiEventBuffer = DYNAMIC-FUNCTION("getCacheUiEventBuffer":U IN gshRepositoryManager)
           hPageBuffer    = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager)
           hLinkBuffer    = DYNAMIC-FUNCTION("getCacheLinkBuffer":U IN gshRepositoryManager)
           .
    /* Create buffers to use to create the new objects. */
    CREATE BUFFER hLocalObjectBuffer        FOR TABLE phObjectBuffer    BUFFER-NAME "localObject":U.
    CREATE BUFFER hReplicateObjectBuffer    FOR TABLE phObjectBuffer    BUFFER-NAME "replicateObject":U.
    CREATE BUFFER hReplicateUiEventBuffer   FOR TABLE hUiEventBuffer    BUFFER-NAME "replicateUiEvent":U.
    CREATE BUFFER hReplicateLinkBuffer      FOR TABLE hLinkBuffer       BUFFER-NAME "replicateLink":U.
    CREATE BUFFER hReplicatePageBuffer      FOR TABLE hPageBuffer       BUFFER-NAME "replicatePage":U.

    /* Get the handle of a query to use. */
    ASSIGN iQueryOrdinal = DYNAMIC-FUNCTION("getNextQueryOrdinal":U IN TARGET-PROCEDURE).
    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal].

    /* Create the object records. */
    ghQuery[iQueryOrdinal]:SET-BUFFERS(hLocalObjectBuffer).
    ghQuery[iQueryOrdinal]:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                                         + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(pdOldContainerInstanceId) ).
    ghQuery[iQueryOrdinal]:QUERY-OPEN().

    /* Query for UI events. We should only get the ordinal value after the previous query has been opened. */
    ASSIGN iQueryOrdinal2 = DYNAMIC-FUNCTION("getNextQueryOrdinal":U IN TARGET-PROCEDURE).
    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal2]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal2].

    ghQuery[iQueryOrdinal]:GET-FIRST().
    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN gsdTempUniqueId   = gsdTempUniqueId + 1
               dInstanceId       = gsdTempUniqueId
               dObjectInstanceId = hLocalObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               hAttributeBuffer  = hLocalObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               .
        hReplicateObjectBuffer:BUFFER-CREATE().
        hReplicateObjectBuffer:BUFFER-COPY(hLocalObjectBuffer, "tRecordIdentifier,tContainerRecordIdentifier":U).
        ASSIGN hReplicateObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE          = dInstanceId
               hReplicateObjectBuffer:BUFFER-FIELD("tContainerRecordIdentifier":U):BUFFER-VALUE = pdNewContainerInstanceId
               .
        hReplicateObjectBuffer:BUFFER-RELEASE().

        /* Create the attribute record. */
        CREATE BUFFER hReplicateAttributeBuffer FOR TABLE hAttributeBuffer  BUFFER-NAME "replicateAttribute":U.

        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dObjectInstanceId) ).        
        
        hReplicateAttributeBuffer:BUFFER-CREATE().
        hReplicateAttributeBuffer:BUFFER-COPY(hAttributeBuffer, "tRecordIdentifier":U).
        ASSIGN hReplicateAttributeBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = dInstanceId.
        hReplicateAttributeBuffer:BUFFER-RELEASE().

        DELETE OBJECT hReplicateAttributeBuffer NO-ERROR.
        ASSIGN hReplicateAttributeBuffer = ?.

        /* Create UI Events records */
        ghQuery[iQueryOrdinal2]:SET-BUFFERS(hUiEventBuffer).
        ghQuery[iQueryOrdinal2]:QUERY-PREPARE(" FOR EACH ":U + hUiEventBuffer:NAME + " WHERE ":U
                                              + hUiEventBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dObjectInstanceId) ).
        ghQuery[iQueryOrdinal2]:QUERY-OPEN().

        ghQuery[iQueryOrdinal2]:GET-FIRST().
        DO WHILE hUiEventBuffer:AVAILABLE:
            hReplicateUiEventBuffer:BUFFER-CREATE().
            hReplicateUiEventBuffer:BUFFER-COPY(hUiEventBuffer, "tRecordIdentifier":U).
            hReplicateUiEventBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = dInstanceId.
            hReplicateUiEventBuffer:BUFFER-RELEASE().

            ghQuery[iQueryOrdinal2]:GET-NEXT().
        END.    /* available UI events */
        ghQuery[iQueryOrdinal2]:QUERY-CLOSE().

        /* Next Object record. */
        ghQuery[iQueryOrdinal]:GET-NEXT().
    END.    /* available UI events */
    ghQuery[iQueryOrdinal]:QUERY-CLOSE().

    /* Create Link records */
    ghQuery[iQueryOrdinal]:SET-BUFFERS(hLinkBuffer).
    ghQuery[iQueryOrdinal]:QUERY-PREPARE(" FOR EACH ":U + hLinkBuffer:NAME + " WHERE ":U
                           + hLinkBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdOldContainerInstanceId) ).
    ghQuery[iQueryOrdinal]:QUERY-OPEN().

    ghQuery[iQueryOrdinal]:GET-FIRST().
    DO WHILE hLinkBuffer:AVAILABLE:
        hReplicateLinkBuffer:BUFFER-CREATE().
        hReplicateLinkBuffer:BUFFER-COPY(hLinkBuffer, "tRecordIdentifier":U).
        hReplicateLinkBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = pdNewContainerInstanceId.
        hReplicateLinkBuffer:BUFFER-RELEASE().

        ghQuery[iQueryOrdinal]:GET-NEXT().
    END.    /* available UI events */
    ghQuery[iQueryOrdinal]:QUERY-CLOSE().

    /* Create Page records */
    ghQuery[iQueryOrdinal]:SET-BUFFERS(hPageBuffer).
    ghQuery[iQueryOrdinal]:QUERY-PREPARE(" FOR EACH ":U + hPageBuffer:NAME + " WHERE ":U
                           + hPageBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdOldContainerInstanceId) ).
    ghQuery[iQueryOrdinal]:QUERY-OPEN().

    ghQuery[iQueryOrdinal]:GET-FIRST().
    DO WHILE hPageBuffer:AVAILABLE:
        hReplicatePageBuffer:BUFFER-CREATE().
        hReplicatePageBuffer:BUFFER-COPY(hPageBuffer, "tRecordIdentifier":U).
        hReplicatePageBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = pdNewContainerInstanceId.
        hReplicatePageBuffer:BUFFER-RELEASE().

        ghQuery[iQueryOrdinal]:GET-NEXT().
    END.    /* available UI events */
    ghQuery[iQueryOrdinal]:QUERY-CLOSE().

    /* Clean up objects */
    DELETE OBJECT hReplicateUiEventBuffer   NO-ERROR.
    DELETE OBJECT hReplicateLinkBuffer      NO-ERROR.
    DELETE OBJECT hReplicatePageBuffer      NO-ERROR.
    DELETE OBJECT hReplicateAttributeBuffer NO-ERROR.
    DELETE OBJECT hReplicateObjectBuffer    NO-ERROR.
    DELETE OBJECT hLocalObjectBuffer        NO-ERROR.

    ASSIGN hLocalObjectBuffer        = ?
           hReplicateObjectBuffer    = ?
           hReplicateUiEventBuffer   = ?
           hReplicateAttributeBuffer = ?
           hReplicateLinkBuffer      = ?
           hReplicatePageBuffer      = ?
           .
    RETURN TRUE.
END FUNCTION.   /* replicateContainer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

