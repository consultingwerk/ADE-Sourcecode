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
  File: contrcache.p

  Description:  Gets all data to launch container

  Purpose:      This procedure is run on the Appserver to fetch all the necessary data to launch
                a container.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cachecontr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* Profile table */
{af/app/afttprofiledata.i}

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/ttaction.i}

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/tttoolbar.i}

/* Defines result codes */

{ry/app/rydefrescd.i}
{ry/app/ryobjretri.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 13.48
         WIDTH              = 53.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT-OUTPUT PARAMETER         plGetObjectDetail       AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER         plGetTokenSecurity      AS LOGICAL   NO-UNDO. /* Redundant */
DEFINE INPUT-OUTPUT PARAMETER         plGetFieldSecurity      AS LOGICAL   NO-UNDO. /* Redundant */
DEFINE INPUT-OUTPUT PARAMETER         plGetToolbars           AS LOGICAL   NO-UNDO. /* Redundant */

DEFINE INPUT PARAMETER pcLogicalObjectName     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcAttributeCode         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdUserObj               AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode            AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdLanguageObj           AS DECIMAL   NO-UNDO.
DEFINE INPUT PARAMETER plReturnEntireContainer AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plDesignMode            AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER pcToolbar               AS CHARACTER NO-UNDO. /* Not used */
DEFINE INPUT PARAMETER pcObjectList            AS CHARACTER NO-UNDO. 
DEFINE INPUT PARAMETER pcBandList              AS CHARACTER NO-UNDO. /* Not used */
DEFINE INPUT PARAMETER pdOrganisationObj       AS DECIMAL   NO-UNDO.

DEFINE OUTPUT PARAMETER pcTokenSecurityString  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldSecurityString  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phObjectTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageInstanceTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phLinkTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phUIEventTable.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable01.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable02.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable03.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable04.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable05.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable06.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable07.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable08.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable09.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable10.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable11.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable12.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable13.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable14.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable15.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable16.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable17.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable18.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable19.

DEFINE OUTPUT PARAMETER TABLE-HANDLE phttStoreToolbarsCached.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheToolbarBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheObjectBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheBand.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheBandAction.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheAction.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phttCacheCategory.

DEFINE VARIABLE phClassAttributeTable20 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable21 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable22 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable23 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable24 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable25 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable26 AS HANDLE NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE-HANDLE phProfileTable.
DEFINE OUTPUT PARAMETER plContainerSecured AS LOGICAL       NO-UNDO.

DEFINE VARIABLE dSmartObjectObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iCnt             AS INTEGER    NO-UNDO.

DEFINE BUFFER ryc_smartobject        FOR ryc_smartobject.
DEFINE BUFFER bttStoreToolbarsCached FOR ttStoreToolbarsCached.
DEFINE BUFFER bttCacheToolbarBand    FOR ttCacheToolbarBand.
DEFINE BUFFER bttCacheObjectBand     FOR ttCacheObjectBand.
DEFINE BUFFER bttCacheBand           FOR ttCacheBand.
DEFINE BUFFER bttCacheBandAction     FOR ttCacheBandAction.
DEFINE BUFFER bttCacheAction         FOR ttCacheAction.
DEFINE BUFFER bttCacheCategory       FOR ttCacheCategory.

/* Make sure we have a valid repository object */
FIND ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.object_filename          = pcLogicalObjectName
       AND ryc_smartobject.customization_result_obj = 0
     NO-ERROR.

/* Remove the file extension, if we have one.  This could happen when a physical file name is passed in as the logical object name */
IF NOT AVAILABLE ryc_smartobject
THEN DO:
    IF NUM-ENTRIES(pcLogicalObjectName, ".":U) > 1
    THEN DO:
        ASSIGN pcLogicalObjectName = SUBSTRING(pcLogicalObjectName, 1, R-INDEX(pcLogicalObjectName, ".":U) - 1).

        FIND ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.object_filename          = pcLogicalObjectName
               AND ryc_smartobject.customization_result_obj = 0
             NO-ERROR.
    END.

    IF NOT AVAILABLE ryc_smartobject 
    THEN DO:
        ASSIGN plGetObjectDetail = NO.
        RETURN. /* Something wrong, don't cache, leave to the standard APIs to sort out */
    END.
END.

/* Check if the container is secured.  If so, we don't even bother extracting information. We just return the plContainerSecured flag as YES. */
ASSIGN dSmartObjectObj = ryc_smartobject.smartobject_obj. /* We have to use this variable because the parameters below are INPUT-OUTPUT */

RUN objectSecurityCheck IN gshSecurityManager (INPUT-OUTPUT pcLogicalObjectName,
                                               INPUT-OUTPUT dSmartObjectObj,
                                               OUTPUT       plContainerSecured).
IF plContainerSecured = YES 
THEN DO:
    ASSIGN plGetObjectDetail = NO.
    RETURN.
END.

/* Fetch the repository data we need to render the container */
RUN serverFetchObject IN gshRepositoryManager 
        (INPUT pcLogicalObjectName,
         INPUT pdUserObj,
         INPUT pcResultCode,
         INPUT pdLanguageObj,
         INPUT pcAttributeCode,
         INPUT plDesignMode,
         OUTPUT TABLE-HANDLE phObjectTable,
         OUTPUT TABLE-HANDLE phPageTable,
         OUTPUT TABLE-HANDLE phPageInstanceTable,
         OUTPUT TABLE-HANDLE phLinkTable,
         OUTPUT TABLE-HANDLE phUIEventTable,
         OUTPUT TABLE-HANDLE phClassAttributeTable01,
         OUTPUT TABLE-HANDLE phClassAttributeTable02,
         OUTPUT TABLE-HANDLE phClassAttributeTable03,
         OUTPUT TABLE-HANDLE phClassAttributeTable04,
         OUTPUT TABLE-HANDLE phClassAttributeTable05,
         OUTPUT TABLE-HANDLE phClassAttributeTable06,
         OUTPUT TABLE-HANDLE phClassAttributeTable07,
         OUTPUT TABLE-HANDLE phClassAttributeTable08,
         OUTPUT TABLE-HANDLE phClassAttributeTable09,
         OUTPUT TABLE-HANDLE phClassAttributeTable10,
         OUTPUT TABLE-HANDLE phClassAttributeTable11,
         OUTPUT TABLE-HANDLE phClassAttributeTable12,
         OUTPUT TABLE-HANDLE phClassAttributeTable13,
         OUTPUT TABLE-HANDLE phClassAttributeTable14,
         OUTPUT TABLE-HANDLE phClassAttributeTable15,
         OUTPUT TABLE-HANDLE phClassAttributeTable16,
         OUTPUT TABLE-HANDLE phClassAttributeTable17,
         OUTPUT TABLE-HANDLE phClassAttributeTable18,
         OUTPUT TABLE-HANDLE phClassAttributeTable19,
         OUTPUT TABLE-HANDLE phClassAttributeTable20,
         OUTPUT TABLE-HANDLE phClassAttributeTable21,
         OUTPUT TABLE-HANDLE phClassAttributeTable22,
         OUTPUT TABLE-HANDLE phClassAttributeTable23,
         OUTPUT TABLE-HANDLE phClassAttributeTable24,
         OUTPUT TABLE-HANDLE phClassAttributeTable25,
         OUTPUT TABLE-HANDLE phClassAttributeTable26
        ).
/* If we have more than 19 classes on our container, the client is going to have to fetch them. */
IF VALID-HANDLE(phClassAttributeTable20) 
THEN DO:
    DELETE OBJECT phObjectTable       NO-ERROR.               
    DELETE OBJECT phPageTable         NO-ERROR.
    DELETE OBJECT phPageInstanceTable NO-ERROR.
    DELETE OBJECT phLinkTable         NO-ERROR.
    DELETE OBJECT phUIEventTable      NO-ERROR.

    DELETE OBJECT phClassAttributeTable01 NO-ERROR.
    DELETE OBJECT phClassAttributeTable02 NO-ERROR.
    DELETE OBJECT phClassAttributeTable03 NO-ERROR.
    DELETE OBJECT phClassAttributeTable04 NO-ERROR.
    DELETE OBJECT phClassAttributeTable05 NO-ERROR.
    DELETE OBJECT phClassAttributeTable06 NO-ERROR.
    DELETE OBJECT phClassAttributeTable07 NO-ERROR.
    DELETE OBJECT phClassAttributeTable08 NO-ERROR.
    DELETE OBJECT phClassAttributeTable09 NO-ERROR.
    DELETE OBJECT phClassAttributeTable10 NO-ERROR.
    DELETE OBJECT phClassAttributeTable11 NO-ERROR.
    DELETE OBJECT phClassAttributeTable12 NO-ERROR.
    DELETE OBJECT phClassAttributeTable13 NO-ERROR.
    DELETE OBJECT phClassAttributeTable14 NO-ERROR.
    DELETE OBJECT phClassAttributeTable15 NO-ERROR.
    DELETE OBJECT phClassAttributeTable16 NO-ERROR.
    DELETE OBJECT phClassAttributeTable17 NO-ERROR.
    DELETE OBJECT phClassAttributeTable18 NO-ERROR.
    DELETE OBJECT phClassAttributeTable19 NO-ERROR.
    DELETE OBJECT phClassAttributeTable20 NO-ERROR.
    DELETE OBJECT phClassAttributeTable21 NO-ERROR.
    DELETE OBJECT phClassAttributeTable22 NO-ERROR.
    DELETE OBJECT phClassAttributeTable23 NO-ERROR.
    DELETE OBJECT phClassAttributeTable24 NO-ERROR.
    DELETE OBJECT phClassAttributeTable25 NO-ERROR.
    DELETE OBJECT phClassAttributeTable26 NO-ERROR.

    ASSIGN plGetObjectDetail = NO.
    RETURN.
END.

RUN makeHandleTT (INPUT TABLE-HANDLE phObjectTable). /* We don't want to work with the TABLE-HANDLE, but rather with the static cache_object table */

/* We have the container info, now get the security stuff for the container, and the objects on it. */
RUN fetchSecurity (INPUT pcLogicalObjectName,
                   INPUT pcAttributeCode).

/* These lists will have been built in fetchSecurity, make sure they're nice and clean */
ASSIGN pcTokenSecurityString = RIGHT-TRIM(pcTokenSecurityString, CHR(27))
       pcFieldSecurityString = RIGHT-TRIM(pcFieldSecurityString, CHR(27)).

/* Fetch profile data and toolbars */
DEFINE VARIABLE cProfileTypes AS CHARACTER  NO-UNDO INITIAL "Browser,SDO".
DEFINE VARIABLE cProfileCodes AS CHARACTER  NO-UNDO INITIAL "Columns,Sorting".

FOR EACH cache_object:
    /* Every browser we launch may have some profile data associated with it.  We need to extract the profile information when we extract
     * the container.  Currently, we extract profile data for:
     * Browser,Columns - If the user has moved the columns on the browser and saved it, we need the columns in the same order next time.
     * SDO,Sorting     - If the user has sorted on certain columns and saved them, we need the same sort order next time. 
     */
    IF LOOKUP("browser":U, cache_object.tInheritsFromClasses) > 0
    THEN DO iCnt = 1 TO 2:
        CREATE ttProfileData.
        ASSIGN ttProfileData.profile_type_obj = ? /* Don't violate unique index */
               ttProfileData.profile_code_obj = ? /* Don't violate unique index */
               ttProfileData.cProfileType     = ENTRY(iCnt, cProfileTypes)
               ttProfileData.cProfileCode     = ENTRY(iCnt, cProfileCodes)
               /* We're going to concatenate the container name and browse name to give us the profile data key */
               ttProfileData.profile_data_key = cache_object.tContainerObjectName + cache_object.tLogicalObjectName
               ttProfileData.user_obj         = pdUserObj.
    END.
    ELSE
        /* Extract the toolbars, use class SmartToolbar and all its child classes */
        IF LOOKUP("smartToolbar":U, cache_object.tInheritsFromClasses) > 0 THEN
            RUN fetchToolbars (INPUT cache_object.tLogicalObjectName,   /* Toolbar name */
                               INPUT cache_object.tContainerObjectName, /* Toolbar(s) container */
                               INPUT "":U,
                               INPUT pdUserObj,
                               INPUT pdOrganisationObj).
END.

IF CAN-FIND(FIRST ttProfileData) 
THEN DO:
    RUN populateProfileCache IN gshProfileManager (INPUT-OUTPUT TABLE ttProfileData). /* This procedure takes the 'templates' we've created, and populates them with the actual profile settings */
    ASSIGN phProfileTable = TEMP-TABLE ttProfileData:HANDLE.
END.

/* Toolbars extracted, now buffer-copy the whole lot into one set of records for the whole container. *
 * We need to do this, don't remove.                                                                  */
IF NOT CAN-FIND(FIRST ttStoreToolbarsCached
                WHERE ttStoreToolbarsCached.cToolbarName       = "":U
                  AND ttStoreToolbarsCached.cLogicalObjectName = pcLogicalObjectName
                  AND ttStoreToolbarsCached.cBand              = pcBandList)
THEN DO:
    CREATE ttStoreToolbarsCached.
    ASSIGN ttStoreToolbarsCached.cToolbarName       = "":U
           ttStoreToolbarsCached.cLogicalObjectName = pcLogicalObjectName
           ttStoreToolbarsCached.cBand              = pcBandList.

    FOR EACH ttCacheToolbarBand
       WHERE ttCacheToolbarBand.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheToolbarBand.cToolbarName      <> "":U:
        CREATE bttCacheToolbarBand.
        BUFFER-COPY ttCacheToolbarBand TO bttCacheToolbarBand ASSIGN bttCacheToolbarBand.cToolbarName = "":U.
    END.
    FOR EACH ttCacheObjectBand
       WHERE ttCacheObjectBand.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheObjectBand.cToolbarName      <> "":U:
        IF NOT CAN-FIND(FIRST bttCacheObjectBand
                        WHERE bttCacheObjectBand.objectName         = ttCacheObjectBand.objectName  
                          AND bttCacheObjectBand.runAttribute       = ttCacheObjectBand.runAttribute
                          AND bttCacheObjectBand.ResultCode         = ttCacheObjectBand.ResultCode  
                          AND bttCacheObjectBand.Sequence           = ttCacheObjectBand.Sequence
                          AND bttCacheObjectBand.cLogicalObjectName = pcLogicalObjectName
                          AND bttCacheObjectBand.cToolbarName       = "":U)
        THEN DO:
            CREATE bttCacheObjectBand.
            BUFFER-COPY ttCacheObjectBand TO bttCacheObjectBand ASSIGN bttCacheObjectBand.cToolbarName = "":U.
        END.
    END.
    FOR EACH ttCacheBand
       WHERE ttCacheBand.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheBand.cToolbarName      <> "":U:
        CREATE bttCacheBand.
        BUFFER-COPY ttCacheBand TO bttCacheBand ASSIGN bttCacheBand.cToolbarName = "":U.
    END.
    FOR EACH ttCacheBandAction
       WHERE ttCacheBandAction.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheBandAction.cToolbarName      <> "":U:
        IF NOT CAN-FIND(FIRST bttCacheBandAction
                        WHERE bttCacheBandAction.Band               = ttCacheBandAction.Band
                          AND bttCacheBandAction.Sequence           = ttCacheBandAction.Sequence
                          AND bttCacheBandAction.ProcedureHandle    = ttCacheBandAction.ProcedureHandle
                          AND bttCacheBandAction.cLogicalObjectName = pcLogicalObjectName
                          AND bttCacheBandAction.cToolbarName       = "":U)
        THEN DO:
            CREATE bttCacheBandAction.
            BUFFER-COPY ttCacheBandAction TO bttCacheBandAction ASSIGN bttCacheBandAction.cToolbarName = "":U.
        END.
    END.
    FOR EACH ttCacheAction
       WHERE ttCacheAction.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheAction.cToolbarName      <> "":U:
        CREATE bttCacheAction.
        BUFFER-COPY ttCacheAction TO bttCacheAction ASSIGN bttCacheAction.cToolbarName = "":U.
    END.
    FOR EACH ttCacheCategory
       WHERE ttCacheCategory.cLogicalObjectName = pcLogicalObjectName
         AND ttCacheCategory.cToolbarName      <> "":U:
        CREATE bttCacheCategory.
        BUFFER-COPY ttCacheCategory TO bttCacheCategory ASSIGN bttCacheCategory.cToolbarName = "":U.
    END.
END.

ASSIGN phttStoreToolbarsCached = TEMP-TABLE ttStoreToolbarsCached:HANDLE
       phttCacheToolbarBand    = TEMP-TABLE ttCacheToolbarBand:HANDLE
       phttCacheObjectBand     = TEMP-TABLE ttCacheObjectBand:HANDLE
       phttCacheBand           = TEMP-TABLE ttCacheBand:HANDLE
       phttCacheBandAction     = TEMP-TABLE ttCacheBandAction:HANDLE
       phttCacheAction         = TEMP-TABLE ttCacheAction:HANDLE
       phttCacheCategory       = TEMP-TABLE ttCacheCategory:HANDLE
       ERROR-STATUS:ERROR      = NO.
RETURN "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fetchSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchSecurity Procedure 
PROCEDURE fetchSecurity :
/*------------------------------------------------------------------------------
  Purpose:     Recursive procedure.  Will fetch security for the passed in object,
               and all objects contained in it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode     AS CHARACTER  NO-UNDO.

DEFINE BUFFER cache_object    FOR cache_object.
DEFINE BUFFER instance_object FOR cache_object.

DEFINE VARIABLE cSecurity       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hClass          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAttributeField AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSDFName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lObjectSecured  AS LOGICAL    NO-UNDO.

/* If the object has been secured already, don't get its security again. */
FIND FIRST cache_object 
     WHERE cache_object.tLogicalObjectName = pcLogicalObjectName
     NO-ERROR.

IF AVAILABLE cache_object 
THEN then-blk: DO:
    ASSIGN hClass = cache_object.tClassBufferHandle.
    IF NOT VALID-HANDLE(hClass) THEN
        LEAVE then-blk.

    ASSIGN hAttributeField = hClass:BUFFER-FIELD("objectSecured":U) NO-ERROR.
    IF VALID-HANDLE(hAttributeField) 
    THEN DO:
        hClass:FIND-FIRST("WHERE tRecordIdentifier = ":U + QUOTER(cache_object.tRecordIdentifier)) NO-ERROR.
        IF hClass:AVAILABLE THEN
            ASSIGN lObjectSecured = hAttributeField:BUFFER-VALUE.
    END.

    /* Field security */
    IF lObjectSecured = NO 
    /* The classes below do not resolve field security, so do it here. */
    OR CAN-DO(cache_object.tInheritsFromClasses, "DynFold":U)
    OR CAN-DO(cache_object.tInheritsFromClasses, "DynDialog":U)
    OR CAN-DO(cache_object.tInheritsFromClasses, "DynObjc":U)
    OR CAN-DO(cache_object.tInheritsFromClasses, "DynMenc":U)
    OR CAN-DO(cache_object.tInheritsFromClasses, "DynTree":U) THEN
        IF INDEX(pcFieldSecurityString, pcLogicalObjectName) = 0 
        THEN DO:
            RUN fieldSecurityGet IN gshSecurityManager (INPUT ?,
                                                        INPUT pcLogicalObjectName,
                                                        INPUT pcAttributeCode,
                                                        OUTPUT cSecurity).
            ASSIGN pcFieldSecurityString = pcFieldSecurityString + pcLogicalObjectName + CHR(4) + cSecurity + CHR(27).
        END.

    /* Token security */
    IF lObjectSecured = NO THEN
        IF INDEX(pcTokenSecurityString, pcLogicalObjectName) = 0
        THEN DO:
            RUN tokenSecurityGet IN gshSecurityManager (INPUT ?,
                                                        INPUT pcLogicalObjectName,
                                                        INPUT pcAttributeCode,
                                                        OUTPUT cSecurity).
            ASSIGN pcTokenSecurityString = pcTokenSecurityString + pcLogicalObjectName + CHR(4) + cSecurity + CHR(27).
        END.
END.

/* Check security for objects on the container: browsers, viewers, toolbars, lookups etc. */
ff-blk:
FOR EACH instance_object NO-LOCK
   WHERE instance_object.tContainerObjectName = pcLogicalObjectName:

    IF instance_object.tLogicalObjectName = instance_object.tContainerObjectName THEN /* We only want instances, this is a master */
        NEXT ff-blk.

    IF LOOKUP("DataField":U, instance_object.tInheritsFromClasses)  > 0
    OR LOOKUP("DynCombo":U,  instance_object.tInheritsFromClasses)  > 0
    OR LOOKUP("DynLookup":U,  instance_object.tInheritsFromClasses) > 0
    THEN DO:
        /* We have to check if this field has a lookup or combo attached to it. *
         * If it does, we must get the security for it.                         */
        FIND FIRST cache_object 
             WHERE cache_object.tContainerObjectName = pcLogicalObjectName
               AND cache_object.tLogicalObjectName   = instance_object.tLogicalObjectName
             NO-ERROR.

        IF AVAILABLE cache_object 
        THEN DO:
            ASSIGN hClass = cache_object.tClassBufferHandle.
            IF NOT VALID-HANDLE(hClass) THEN
                NEXT ff-blk.
    
            ASSIGN hAttributeField = hClass:BUFFER-FIELD("sdfFilename":U).
            IF NOT VALID-HANDLE(hAttributeField) THEN
                NEXT ff-blk.
    
            hClass:FIND-FIRST("WHERE tRecordIdentifier = ":U + QUOTER(cache_object.tRecordIdentifier)) NO-ERROR.
            IF NOT hClass:AVAILABLE THEN
                NEXT ff-blk.
    
            ASSIGN cSDFName = hAttributeField:BUFFER-VALUE.
            IF cSDFName <> "":U
            THEN DO:
                /* If the security has already been fetched, don't do it again */
                IF INDEX(pcFieldSecurityString, cSDFName) <> 0 THEN
                    NEXT ff-blk.

                /* We don't check token security for SDFs */
                RUN fieldSecurityGet IN gshSecurityManager (INPUT ?,
                                                            INPUT cSDFName,
                                                            INPUT pcAttributeCode,
                                                            OUTPUT cSecurity).
                ASSIGN pcFieldSecurityString = pcFieldSecurityString + cSDFName + CHR(4) + cSecurity + CHR(27).
            END.
        END.
    END.
    ELSE
        /* We only extract security for subclasses of 'Visual' */
        IF LOOKUP("visual":U, instance_object.tInheritsFromClasses) > 0 THEN
            RUN fetchSecurity (INPUT instance_object.tLogicalObjectName,
                               INPUT pcAttributeCode).
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchToolbars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchToolbars Procedure 
PROCEDURE fetchToolbars :
/*------------------------------------------------------------------------------
  Purpose:     Fetches toolbars
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcToolbar           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcBandList          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pdUserObj           AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdOrganisationObj   AS DECIMAL    NO-UNDO.

/* Empty the toolbar temp-tables */

EMPTY TEMP-TABLE ttToolbarBand.
EMPTY TEMP-TABLE ttObjectBand.
EMPTY TEMP-TABLE ttBand.
EMPTY TEMP-TABLE ttBandAction.
EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

/* It could be that a toolbar is reused multiple times on a container.  If so, retrieve it only once */
IF CAN-FIND(FIRST ttStoreToolbarsCached
            WHERE ttStoreToolbarsCached.cToolbarName       = pcToolbar
              AND ttStoreToolbarsCached.cLogicalObjectName = pcLogicalObjectName
              AND ttStoreToolbarsCached.cBand              = pcBandList) THEN
    RETURN.

RUN ry/app/rygetmensp.p (INPUT pcToolbar,                       /* Toolbar, blank for all */
                         INPUT pcLogicalObjectName,             /* List of objects, in this case only the container */
                         INPUT pcBandList,                      /* Band, blank for all */
                         INPUT pdUserObj,
                         INPUT pdOrganisationObj,
                         OUTPUT TABLE ttToolbarBand,
                         OUTPUT TABLE ttObjectBand,
                         OUTPUT TABLE ttBand,
                         OUTPUT TABLE ttBandAction,
                         OUTPUT TABLE ttAction,
                         OUTPUT TABLE ttCategory).

CREATE ttStoreToolbarsCached.
ASSIGN ttStoreToolbarsCached.cToolbarName       = pcToolbar
       ttStoreToolbarsCached.cLogicalObjectName = pcLogicalObjectName
       ttStoreToolbarsCached.cBand              = pcBandList.

FOR EACH ttToolbarBand:
    CREATE ttCacheToolbarBand.
    BUFFER-COPY ttToolbarBand TO ttCacheToolbarBand
        ASSIGN ttCacheToolbarBand.cToolbarName       = pcToolbar
               ttCacheToolbarBand.cLogicalObjectName = pcLogicalObjectName
               ttCacheToolbarBand.cBand              = pcBandList.
END.

FOR EACH ttObjectBand:
    CREATE ttCacheObjectBand.
    BUFFER-COPY ttObjectBand TO ttCacheObjectBand
        ASSIGN ttCacheObjectBand.cToolbarName       = pcToolbar
               ttCacheObjectBand.cLogicalObjectName = pcLogicalObjectName
               ttCacheObjectBand.cBand              = pcBandList.
END.

FOR EACH ttBand:
    CREATE ttCacheBand.
    BUFFER-COPY ttBand TO ttCacheBand
        ASSIGN ttCacheBand.cToolbarName       = pcToolbar
               ttCacheBand.cLogicalObjectName = pcLogicalObjectName
               ttCacheBand.cBand              = pcBandList.
END.

FOR EACH ttBandAction:
    CREATE ttCacheBandAction.
    BUFFER-COPY ttBandAction TO ttCacheBandAction
        ASSIGN ttCacheBandAction.cToolbarName       = pcToolbar
               ttCacheBandAction.cLogicalObjectName = pcLogicalObjectName
               ttCacheBandAction.cBand              = pcBandList.
END.

FOR EACH ttAction:
    CREATE ttCacheAction.
    BUFFER-COPY ttAction TO ttCacheAction
        ASSIGN ttCacheAction.cToolbarName       = pcToolbar
               ttCacheAction.cLogicalObjectName = pcLogicalObjectName
               ttCacheAction.cBand              = pcBandList.
END.

FOR EACH ttCategory:
    CREATE ttCacheCategory.
    BUFFER-COPY ttCategory TO ttCacheCategory
        ASSIGN ttCacheCategory.cToolbarName       = pcToolbar
               ttCacheCategory.cLogicalObjectName = pcLogicalObjectName
               ttCacheCategory.cBand              = pcBandList.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-makeHandleTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeHandleTT Procedure 
PROCEDURE makeHandleTT :
/*------------------------------------------------------------------------------
  Purpose:     We don't want to work with a TABLE-HANDLE, so we pass the 
               TABLE-HANDLE into here, which will move it into cache_object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR cache_object.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

