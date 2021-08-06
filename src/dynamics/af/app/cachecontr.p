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
         HEIGHT             = 3.33
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT-OUTPUT PARAMETER         plGetObjectDetail       AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER         plGetTokenSecurity      AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER         plGetFieldSecurity      AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER         plGetToolbars           AS LOGICAL   NO-UNDO.

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

DEFINE OUTPUT PARAMETER TABLE-HANDLE phProfileTable.
DEFINE OUTPUT PARAMETER plContainerSecured AS LOGICAL       NO-UNDO.

/* Due to a limit on the number of TABLE-HANDLEs we can send across the Appserver, we're not going to send these. *
 * This shouldn't be a problem, as a container shouldn't contain more than 20 different classes (object types).   */

DEFINE VARIABLE phClassAttributeTable20 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable21 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable22 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable23 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable24 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable25 AS HANDLE NO-UNDO.
DEFINE VARIABLE phClassAttributeTable26 AS HANDLE NO-UNDO.

DEFINE VARIABLE dSmartObjectObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dResultObj      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iCnt            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iClassCnt       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cClassChildren  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTokenSecurity  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldSecurity  AS CHARACTER  NO-UNDO.

DEFINE BUFFER ryc_smartobject          FOR ryc_smartobject.
DEFINE BUFFER bryc_smartobject         FOR ryc_smartobject.
DEFINE BUFFER gsc_object_type          FOR gsc_object_type.
DEFINE BUFFER ryc_object_instance      FOR ryc_object_instance.

/* Make sure we have a valid repository object */

FIND ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.object_filename          = pcLogicalObjectName
       AND ryc_smartobject.customization_result_obj = 0
     NO-ERROR.

/* Remove the file extension, if we have one.  This could happen when a physical file name is passed in as the logical object name */

IF NOT AVAILABLE ryc_smartobject 
AND NUM-ENTRIES(pcLogicalObjectName, ".":U) > 1 
THEN DO:
    ASSIGN pcLogicalObjectName = SUBSTRING(pcLogicalObjectName, 1, R-INDEX(pcLogicalObjectName, ".":U) - 1).

    FIND ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename          = pcLogicalObjectName
           AND ryc_smartobject.customization_result_obj = 0
         NO-ERROR.
END.

IF NOT AVAILABLE ryc_smartobject 
THEN DO:
    ASSIGN plGetObjectDetail  = NO
           plGetTokenSecurity = NO
           plGetFieldSecurity = NO
           plGetToolbars      = NO.
    RETURN. /* Something wrong, don't cache, leave to the standard APIs to sort out */
END.

/* Check if the container is secured.  If so, we don't even bother extracting information. We just return the plContainerSecured flag as YES. */

ASSIGN dSmartObjectObj = ryc_smartobject.smartobject_obj. /* We have to use this variable because the parameters below are INPUT-OUTPUT */

RUN afobjschkp IN gshSecurityManager (INPUT-OUTPUT pcLogicalObjectName,
                                      INPUT-OUTPUT dSmartObjectObj,
                                      OUTPUT       plContainerSecured).  
IF plContainerSecured = YES 
THEN DO:
    ASSIGN plGetObjectDetail  = NO
           plGetTokenSecurity = NO
           plGetFieldSecurity = NO
           plGetToolbars      = NO.
    RETURN.
END.

/* Fetch the repository data we need to render the container */
IF plGetObjectDetail = YES 
THEN fetch-object-blk: DO:
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
    /* We can only return 19 TABLE-HANDLEs.  If there are more than 19, the client is going to have to fetch the object */
    IF VALID-HANDLE(phClassAttributeTable20) OR VALID-HANDLE(phClassAttributeTable21) OR VALID-HANDLE(phClassAttributeTable22)
    OR VALID-HANDLE(phClassAttributeTable23) OR VALID-HANDLE(phClassAttributeTable24) OR VALID-HANDLE(phClassAttributeTable25) THEN
        ASSIGN phObjectTable           = ?
               phPageTable             = ?
               phPageInstanceTable     = ?
               phLinkTable             = ?
               phUIEventTable          = ?
               phClassAttributeTable01 = ? phClassAttributeTable02 = ? phClassAttributeTable03 = ? phClassAttributeTable04 = ?
               phClassAttributeTable05 = ? phClassAttributeTable06 = ? phClassAttributeTable07 = ? phClassAttributeTable08 = ?
               phClassAttributeTable09 = ? phClassAttributeTable10 = ? phClassAttributeTable11 = ? phClassAttributeTable12 = ?
               phClassAttributeTable13 = ? phClassAttributeTable14 = ? phClassAttributeTable15 = ? phClassAttributeTable16 = ?
               phClassAttributeTable17 = ? phClassAttributeTable18 = ? phClassAttributeTable19 = ? phClassAttributeTable20 = ?
               phClassAttributeTable21 = ? phClassAttributeTable22 = ? phClassAttributeTable23 = ? phClassAttributeTable24 = ?
               phClassAttributeTable25 = ? phClassAttributeTable26 = ? 
               plGetObjectDetail       = NO.
END.

/* We have the container info, now get the security stuff for the container, and the objects on it */

IF plGetTokenSecurity = YES
OR plGetFieldSecurity = YES
THEN DO:
    /* Container Security */
    IF plGetTokenSecurity = YES 
    THEN DO:
        RUN aftokschkp IN gshSecurityManager (INPUT pcLogicalObjectName,
                                              INPUT pcAttributeCode,
                                              OUTPUT cTokenSecurity).
        ASSIGN pcTokenSecurityString = pcTokenSecurityString + pcLogicalObjectName + CHR(4) + cTokenSecurity + CHR(27).
    END.

    IF plGetFieldSecurity = YES 
    THEN DO:
        RUN affldschkp IN gshSecurityManager (INPUT pcLogicalObjectName,
                                              INPUT pcAttributeCode,
                                              OUTPUT cFieldSecurity).
        ASSIGN pcFieldSecurityString = pcFieldSecurityString + pcLogicalObjectName + CHR(4) + cFieldSecurity + CHR(27).
    END.

    /* Objects on container security, browsers and viewers */

    ASSIGN cClassChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "browser,viewer":U)
           cClassChildren = REPLACE(cClassChildren, CHR(3), ",":U).

    DO iClassCnt = 1 TO NUM-ENTRIES(cClassChildren):

        ff-blk:
        FOR FIRST gsc_object_type NO-LOCK
            WHERE gsc_object_type.object_type_code = ENTRY(iClassCnt, cClassChildren),
             EACH ryc_object_instance NO-LOCK
            WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
            FIRST bryc_smartobject NO-LOCK
            WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
              AND bryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:

            IF plGetTokenSecurity = YES 
            THEN DO:
                RUN aftokschkp IN gshSecurityManager (INPUT bryc_smartobject.object_filename,
                                                      INPUT pcAttributeCode,
                                                      OUTPUT cTokenSecurity).
                ASSIGN pcTokenSecurityString = pcTokenSecurityString + bryc_smartobject.object_filename + CHR(4) + cTokenSecurity + CHR(27).
            END.

            IF plGetFieldSecurity = YES 
            THEN DO:
                RUN affldschkp IN gshSecurityManager (INPUT bryc_smartobject.object_filename,
                                                      INPUT pcAttributeCode,
                                                      OUTPUT cFieldSecurity).
                ASSIGN pcFieldSecurityString = pcFieldSecurityString + bryc_smartobject.object_filename + CHR(4) + cFieldSecurity + CHR(27).
            END.
        END.
    END.

    ASSIGN pcTokenSecurityString = RIGHT-TRIM(pcTokenSecurityString, CHR(27))
           pcFieldSecurityString = RIGHT-TRIM(pcFieldSecurityString, CHR(27)).
END.

/* Get the profile information for the container and the objects on it */

EMPTY TEMP-TABLE ttProfileData.

/* The variables below are a hardcoded list of profile codes to retrieve. When we need to extract more profile info, we'll update these */

DEFINE VARIABLE cProfileTypes    AS CHARACTER  NO-UNDO INITIAL "Browser,SDO".
DEFINE VARIABLE cProfileCodes    AS CHARACTER  NO-UNDO INITIAL "Columns,Sorting".
DEFINE VARIABLE cProfileDataKeys AS CHARACTER  NO-UNDO INITIAL ",". /* Explanation below of why these are blank */

DO iCnt = 1 TO NUM-ENTRIES(cProfileTypes):

    IF ENTRY(iCnt, cProfileTypes) = "Browser":U
    OR ENTRY(iCnt, cProfileTypes) = "SDO":U
    THEN DO:
        /* For these profile types, we're going to concatenate the container name and browse name to give use the profile data key */
        ASSIGN cClassChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "browser":U). /* We're not going to have objects of type 'browser', only browser children */

        DO iClassCnt = 1 TO NUM-ENTRIES(cClassChildren):
            FOR FIRST gsc_object_type NO-LOCK
                WHERE gsc_object_type.object_type_code = ENTRY(iClassCnt, cClassChildren),
                 EACH ryc_object_instance NO-LOCK
                WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
                FIRST bryc_smartobject NO-LOCK
                WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
                  AND bryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:
                
                CREATE ttProfileData.
                ASSIGN ttProfileData.profile_type_obj = ? /* Don't violate unique index */
                       ttProfileData.profile_code_obj = ? /* Don't violate unique index */
                       ttProfileData.cProfileType     = ENTRY(iCnt, cProfileTypes)
                       ttProfileData.cProfileCode     = ENTRY(iCnt, cProfileCodes)
                       ttProfileData.profile_data_key = ryc_smartobject.object_filename + bryc_smartobject.object_filename
                       ttProfileData.user_obj         = pdUserObj
                       ttProfileData.context_id       = gscSessionId.                
            END.
        END.
    END.
    ELSE DO:
        CREATE ttProfileData.
        ASSIGN ttProfileData.profile_type_obj = ? /* Don't violate unique index */
               ttProfileData.profile_code_obj = ? /* Don't violate unique index */
               ttProfileData.cProfileType     = ENTRY(iCnt, cProfileTypes)
               ttProfileData.cProfileCode     = ENTRY(iCnt, cProfileCodes)
               ttProfileData.profile_data_key = ENTRY(iCnt, cProfileDataKeys)
               ttProfileData.user_obj         = pdUserObj
               ttProfileData.context_id       = gscSessionId.
    END.
END.

IF CAN-FIND(FIRST ttProfileData) 
THEN DO:
    RUN populateProfileCache IN gshProfileManager (INPUT-OUTPUT TABLE ttProfileData). /* This procedure takes the 'templates' we've created, and populates them with the actual profile settings */
    ASSIGN phProfileTable = TEMP-TABLE ttProfileData:HANDLE.
END.

/* Get the container menus */

IF plGetToolbars = YES
THEN DO:
    /* Extract the toolbars, use class SmartToolbar and all its child classes */

    ASSIGN cClassChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SmartToolbar":U).

    DO iClassCnt = 1 TO NUM-ENTRIES(cClassChildren):

        FOR FIRST gsc_object_type NO-LOCK
            WHERE gsc_object_type.object_type_code = ENTRY(iClassCnt, cClassChildren),
             EACH ryc_object_instance NO-LOCK
            WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,
            FIRST bryc_smartobject NO-LOCK
            WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
              AND bryc_smartobject.object_type_obj = gsc_object_type.object_type_obj:

            RUN fetchToolbars (INPUT bryc_smartobject.object_filename, /* Toolbar name */
                               INPUT pcLogicalObjectName,              /* Toolbar(s) container */
                               INPUT "":U,
                               INPUT pdUserObj,
                               INPUT pdOrganisationObj).
        END.
    END.

    /* Now buffer-copy the whole lot into one set of records for the whole container.  We need to do this, don't remove. */

    DEFINE BUFFER bttStoreToolbarsCached FOR ttStoreToolbarsCached.
    DEFINE BUFFER bttCacheToolbarBand    FOR ttCacheToolbarBand.
    DEFINE BUFFER bttCacheObjectBand     FOR ttCacheObjectBand.
    DEFINE BUFFER bttCacheBand           FOR ttCacheBand.
    DEFINE BUFFER bttCacheBandAction     FOR ttCacheBandAction.
    DEFINE BUFFER bttCacheAction         FOR ttCacheAction.
    DEFINE BUFFER bttCacheCategory       FOR ttCacheCategory.

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

&IF DEFINED(EXCLUDE-fetchToolbars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchToolbars Procedure 
PROCEDURE fetchToolbars :
/*------------------------------------------------------------------------------
  Purpose:     Fetches toolbars
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcToolbar           AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcBandList          AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdUserObj           AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdOrganisationObj   AS DECIMAL    NO-UNDO.

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
                         OUTPUT TABLE ttCategory
                        ).

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

