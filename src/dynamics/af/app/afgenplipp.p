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
  File: afgenplipp.p

  Description:  Object Generator PLIP

  Purpose:      Object Generator PLIP

  Parameters:   <none>

  History:
  --------
  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579:
                Added support for relative paths from RTB workspace modules.

  (v:010002)    Task:          18   UserRef:    
                Date:   02/18/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579:
                - Removed dependency on RTB variables.
                - Changed setScmTool procedure to check for PRIVATE-DATA = "SCMTool"  instead of the RTB procedure name.
                - Added cehck for VALID-HANDLE on scmValidate procedure

  (v:020000)    Task:          36   UserRef:    
                Date:   07/07/2003  Author:     Thomas Hansen

  Update Notes: Issue 11658:
                Fixed incorrect parameter calls to scmGetModuleDir.

  (v:030000)    Task:           8   UserRef:    
                Date:   09/30/2003  Author:     

  Update Notes: Issue 13068:
                Added missing ELSE statement in the retrieveHeaderInformation 
                procedure to prevent relative paths from ICFDB overwriting 
                SCM paths.
-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgenplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{ src/adm2/globals.i }
{ af/app/afgenretin.i }

DEFINE VARIABLE ghRepositoryDesignManager               AS HANDLE                   NO-UNDO.
DEFINE VARIABLE glCancelJob                             AS LOGICAL                  NO-UNDO.

DEFINE TEMP-TABLE ttHeaderInfo              NO-UNDO     RCODE-INFORMATION
    FIELD tType                 AS CHARACTER
    FIELD tName                 AS CHARACTER
    FIELD tIsRepository         AS LOGICAL
    FIELD tExtraInfo            AS CHARACTER
    FIELD tDisplayRecord        AS LOGICAL              INITIAL YES
    INDEX idxSort
        tType
        tName
        tDisplayRecord
    .

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }



/* Set and get the handle of the SCM Tool if it is running */
DEFINE VARIABLE ghScmTool AS HANDLE   NO-UNDO.

{src/adm2/inrepprmod.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getObjectInfoValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInfoValue Procedure 
FUNCTION getObjectInfoValue RETURNS CHARACTER
    ( INPUT pcObjectKey    AS CHARACTER,
      INPUT pcPData           AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logTheError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD logTheError Procedure 
FUNCTION logTheError RETURNS LOGICAL
    ( INPUT plRunSilent             AS LOGICAL,
      INPUT pcSection               AS CHARACTER,
      INPUT pcAction                AS CHARACTER,
      INPUT pcResult                AS CHARACTER,
      INPUT pcMessageType           AS CHARACTER,
      INPUT pcMessageText           AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScmToolHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setScmToolHandle Procedure 
FUNCTION setScmToolHandle RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 15.1
         WIDTH              = 51.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
    RETURN ERROR {aferrortxt.i 'AF' '19' '?' '?' "''" "'Repository Design Manager'"}.

/* EOF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cancelGeneration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelGeneration Procedure 
PROCEDURE cancelGeneration :
/*------------------------------------------------------------------------------
  Purpose:     Event to cancel the running job.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    ASSIGN glCancelJob = YES.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObjects Procedure 
PROCEDURE generateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER plRunSilent             AS LOGICAL          NO-UNDO.
  DEFINE INPUT  PARAMETER TABLE FOR ttInfoMaster.
  DEFINE INPUT  PARAMETER TABLE FOR ttInfoInstance.
  DEFINE OUTPUT PARAMETER TABLE FOR ttErrorLog.

  /* This code put into an include because the SE limits were exceeded. */
  {af/app/afgengenob.i}.

  IF NOT plRunSilent
  THEN
    EMPTY TEMP-TABLE ttErrorLog.

  RETURN.

END PROCEDURE.  /* generateObjects */

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

ASSIGN cDescription = "Dynamics Object Generator PLIP".

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

ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT "PRIVATE-DATA:SCMTool":U).

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

&IF DEFINED(EXCLUDE-retreivePathInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retreivePathInformation Procedure 
PROCEDURE retreivePathInformation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcFolderPath      AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT       PARAMETER pcErrorValue      AS CHARACTER    NO-UNDO.

  IF pcFolderPath = ?
  OR pcFolderPath = "":U
  THEN
    ASSIGN
      FILE-INFO:FILE-NAME  = ".":U.
  ELSE
    ASSIGN
      FILE-INFO:FILE-NAME = pcFolderPath.

  /* Make sure the directory is a valid (writable) directory. */
  IF FILE-INFO:FULL-PATHNAME = ?
  THEN
    ASSIGN
      pcErrorValue = "The directory does not exist.".
  ELSE
  IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0
  THEN
    ASSIGN
      pcErrorValue = "The directory is not a valid directory.".
  ELSE
  IF INDEX(FILE-INFO:FILE-TYPE,"W") = 0
  THEN
    ASSIGN
      pcErrorValue = "The directory is not a directory that can be written to.".
  ELSE
    ASSIGN
      pcErrorValue = "":U
      pcFolderPath = FILE-INFO:FULL-PATHNAME
      .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveBrowseData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveBrowseData Procedure 
PROCEDURE retrieveBrowseData :
/*------------------------------------------------------------------------------
  Purpose:     Creates data and TTs for the Object Generator.
  Parameters:  pcDataBasedOn       -
               pcDatabaseName      -
               pcProductModuleCode -
               phBrowseDataTable   -
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcDataBasedOn           AS CHARACTER        NO-UNDO.
  DEFINE INPUT  PARAMETER pcDatabaseName          AS CHARACTER        NO-UNDO.  
  DEFINE INPUT  PARAMETER pcProductModuleCode     AS CHARACTER        NO-UNDO.    
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phBrowseDataTable.

  DEFINE VARIABLE iEntryLoop                      AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cEntryValue                     AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE hTempTable                      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hTableBuffer                    AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hBufferDB                       AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hBufferFile                     AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hBufferField                    AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hQuery                          AS HANDLE           NO-UNDO.
  DEFINE VARIABLE cWidgetPoolName                 AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cQueryWhere                     AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cFieldQuery                     AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cDataObjectClasses              AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cClassName                      AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE iClassLoop                      AS INTEGER          NO-UNDO.

  DEFINE VARIABLE cProperties                     AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj                 AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj             AS DECIMAL          NO-UNDO.

  DEFINE VARIABLE hCustomizationManager           AS HANDLE           NO-UNDO.
  DEFINE VARIABLE cSessionResultCodes             AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cRunAttribute                   AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE hObjectBuffer                   AS HANDLE           NO-UNDO.
  DEFINE VARIABLE dSdoObjectObj                   AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer                AS HANDLE           NO-UNDO.
  DEFINE VARIABLE dRecordIdentifier               AS DECIMAL          NO-UNDO.

  IF pcDataBasedOn EQ "SCHEMA":U
  THEN DO:

    /* Create the temp-table */
    CREATE TEMP-TABLE hTempTable.

    hTempTable:ADD-NEW-FIELD("tTableName":U  ,"CHARACTER":U, 0, "x(35)":U, ?, ?, "Table name":U).
    hTempTable:ADD-NEW-FIELD("tTableEntity":U,"CHARACTER":U, 0, "x(20)":U, ?, ?, "Entity mnemonic":U).
    hTempTable:ADD-NEW-FIELD("tTableDBName":U,"CHARACTER":U, 0, "x(20)":U, ?, ?, "Database name":U).
    hTempTable:ADD-NEW-FIELD("tTableDump":U,"CHARACTER":U, 0, "x(20)":U, ?, ?, "?":U).
    hTempTable:ADD-NEW-FIELD("tTableDesc":U  ,"CHARACTER":U, 0, "x(72)":U, ?, ?, "Description":U). /* The 72 is also used in the assign */

    hTempTable:ADD-NEW-INDEX("idxTableName":U).
    hTempTable:ADD-INDEX-FIELD("idxTableName":U, "tTableName":U).

    hTempTable:ADD-NEW-INDEX("idxTableEntity":U).
    hTempTable:ADD-INDEX-FIELD("idxTableEntity":U, "tTableEntity":U).

    hTempTable:ADD-NEW-INDEX("idxTableDBName":U).
    hTempTable:ADD-INDEX-FIELD("idxTableDBName":U, "tTableDBName":U).

    hTempTable:ADD-NEW-INDEX("idxTableDesc":U).
    hTempTable:ADD-INDEX-FIELD("idxTableDesc":U, "tTableDesc":U).

    hTempTable:TEMP-TABLE-PREPARE("ttTables":U).

    ASSIGN
      hTableBuffer = hTempTable:DEFAULT-BUFFER-HANDLE.

    blkDatabase:
    DO iEntryLoop = 1 TO NUM-ENTRIES(pcDatabaseName,",":U):

      ASSIGN
        cEntryValue = ENTRY(iEntryLoop,pcDatabaseName,",":U).

      IF cEntryValue EQ "":U
      OR cEntryValue EQ "<None>":U
      THEN NEXT blkDatabase.

      /* Get the Data */
      /*IF LOOKUP(pcDatabaseName, DYNAMIC-FUNCTION("getServiceList":U IN THIS-PROCEDURE, INPUT "Database":U), CHR(3)) GT 0 THEN*/
      IF NOT CONNECTED(cEntryValue)
      THEN
        RETURN "Database " + cEntryValue + " is not connected.".

      ASSIGN
        hQuery = DYNAMIC-FUNCTION("getSchemaQueryHandle":U IN ghRepositoryDesignManager
                                                          ,INPUT  cEntryValue
                                                          ,INPUT  "*":U
                                                          ,OUTPUT cWidgetPoolName
                                                          ).
      IF VALID-HANDLE(hQuery)
      THEN DO:
        /* We replace the FOR EACH _Field query with a FOR FIRST _Field
           since we are only interested in the tables, not the fields. */
        ASSIGN
          cQueryWhere = hQuery:PREPARE-STRING
          cFieldQuery = ENTRY(3, cQueryWhere)
          cFieldQuery = REPLACE(cFieldQuery, " EACH ":U, " FIRST ":U)
          ENTRY(3, cQueryWhere) = cFieldQuery
          .
        hQuery:QUERY-PREPARE(cQueryWhere).

        /* The query buffer handles are, in order: _DB, _FILE, _FIELD */
        ASSIGN
          hBufferDB    = hQuery:GET-BUFFER-HANDLE(1)
          hBufferFile  = hQuery:GET-BUFFER-HANDLE(2)
          .

        hQuery:QUERY-OPEN().

        hQuery:GET-FIRST(NO-LOCK).

        DO WHILE hBufferFile:AVAILABLE:
          hTableBuffer:BUFFER-CREATE().

          FIND FIRST gsc_entity_mnemonic NO-LOCK
            WHERE gsc_entity_mnemonic.entity_mnemonic_description = STRING(hBufferFile:BUFFER-FIELD("_File-name":U):BUFFER-VALUE)
            AND   gsc_entity_mnemonic.entity_dbname               = LC(LDBNAME(cEntryValue))
            NO-ERROR.
          IF AVAILABLE gsc_entity_mnemonic
          THEN
            ASSIGN
              hTableBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE    = gsc_entity_mnemonic.entity_mnemonic_description
              hTableBuffer:BUFFER-FIELD("tTableEntity":U):BUFFER-VALUE  = gsc_entity_mnemonic.entity_mnemonic
              hTableBuffer:BUFFER-FIELD("tTableDBName":U):BUFFER-VALUE  = LC(gsc_entity_mnemonic.entity_dbname)
              hTableBuffer:BUFFER-FIELD("tTableDesc":U):BUFFER-VALUE    = SUBSTRING(gsc_entity_mnemonic.entity_narration,1,72)              
              hTableBuffer:BUFFER-FIELD("tTableDump":U):BUFFER-VALUE  = gsc_entity_mnemonic.entity_mnemonic
              .
          ELSE
            ASSIGN
              hTableBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE    = hBufferFile:BUFFER-FIELD("_File-name":U):BUFFER-VALUE
              hTableBuffer:BUFFER-FIELD("tTableEntity":U):BUFFER-VALUE  = "< Not Available >":U
              hTableBuffer:BUFFER-FIELD("tTableDBName":U):BUFFER-VALUE  = LC(LDBNAME(cEntryValue))
              hTableBuffer:BUFFER-FIELD("tTableDesc":U):BUFFER-VALUE    = SUBSTRING(hBufferFile:BUFFER-FIELD("_Desc":U):BUFFER-VALUE,1,72)
              hTableBuffer:BUFFER-FIELD("tTableDump":U):BUFFER-VALUE    = hBufferFile:BUFFER-FIELD("_Dump-name":U):BUFFER-VALUE
              .
          hTableBuffer:BUFFER-RELEASE().
          hQuery:GET-NEXT(NO-LOCK).
        END.    /* available files */
        hQuery:QUERY-CLOSE().

        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN
          hQuery = ?.

        DELETE WIDGET-POOL cWidgetPoolName.

      END.    /* valid query */

    END. /* iEntryLoop */

  END.    /* Schema */
  ELSE
  IF pcDataBasedOn EQ "REPOSITORY":U
  THEN DO:

    /* Create the temp-table */
    CREATE TEMP-TABLE hTempTable.

    hTempTable:ADD-NEW-FIELD("tObjectName":U      , "CHARACTER":U, 0, "x(35)":U, ?, ?, "Name":U).
    hTempTable:ADD-NEW-FIELD("tObjectClassName":U , "CHARACTER":U, 0, "x(20)":U, ?, ?, "Class":U).
    hTempTable:ADD-NEW-FIELD("tObjectModule":U    , "CHARACTER":U, 0, "x(20)":U, ?, ?, "Module":U).
    hTempTable:ADD-NEW-FIELD("tObjectDesc":U      , "CHARACTER":U, 0, "x(72)":U, ?, ?, "Description":U).

    hTempTable:ADD-NEW-INDEX("idxObjectName":U).
    hTempTable:ADD-INDEX-FIELD("idxObjectName":U, "tObjectName").

    hTempTable:ADD-NEW-INDEX("idxObjectClassName":U).
    hTempTable:ADD-INDEX-FIELD("idxObjectClassName":U, "tObjectClassName").

    hTempTable:ADD-NEW-INDEX("idxObjectModule":U).
    hTempTable:ADD-INDEX-FIELD("idxObjectModule":U, "tObjectModule").

    hTempTable:ADD-NEW-INDEX("idxObjectDesc":U).
    hTempTable:ADD-INDEX-FIELD("idxObjectDesc":U, "tObjectDesc").

    hTempTable:TEMP-TABLE-PREPARE("ttObjects":U).

    ASSIGN
      hTableBuffer = hTempTable:DEFAULT-BUFFER-HANDLE.

    /* The DynSDO class is a child of the SDO class, so retrieving the SDO class children will include the DynSDO class. */
    ASSIGN
      cDataObjectClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "SDO,DynSDO":U )
      cDataObjectClasses = REPLACE(cDataObjectClasses, CHR(3), ",").

    /* Make sure that the relevant classes exist in the Repository. */
    RUN createClassCache IN gshRepositoryManager ( INPUT cDataObjectClasses).

    cProperties         = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "currentUserObj,currentLanguageObj":U, INPUT YES).
    dCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3))) NO-ERROR.
    dCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) NO-ERROR.
    cRunAttribute       = "":U.

    hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U).
    IF VALID-HANDLE(hCustomizationManager)
    THEN
      ASSIGN
        cSessionResultCodes  = DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager).

    blkModule:
    DO iEntryLoop = 1 TO NUM-ENTRIES(pcProductModuleCode,",":U):

      ASSIGN
        cEntryValue = ENTRY(iEntryLoop,pcProductModuleCode,",":U).

      IF cEntryValue EQ "":U
      OR cEntryValue EQ "<None>":U
      THEN NEXT blkModule.

      /* Get the data */
      FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.product_module_code = cEntryValue
        NO-ERROR.
      IF NOT AVAILABLE gsc_product_module
      THEN DO:
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" cEntryValue}.
      END.    /* N/A prod mod */

      DO iClassLoop = 1 TO NUM-ENTRIES(cDataObjectClasses):

        /* The class is assumed to exist becauseby virtue of the fact that it exists in the class cache. */
        FIND FIRST gsc_object_type NO-LOCK
          WHERE gsc_object_type.object_type_code = ENTRY(iClassLoop, cDataObjectClasses)
          NO-ERROR.

        FOR EACH ryc_smartobject NO-LOCK
          WHERE ryc_smartobject.object_type_obj    = gsc_object_type.object_type_obj
          AND   ryc_smartObject.product_module_obj = gsc_product_module.product_module_obj
          :
          hTableBuffer:BUFFER-CREATE().
          ASSIGN
            hTableBuffer:BUFFER-FIELD("tObjectName":U):BUFFER-VALUE       = ryc_smartObject.object_filename
            hTableBuffer:BUFFER-FIELD("tObjectClassName":U):BUFFER-VALUE  = gsc_object_type.object_type_code
            hTableBuffer:BUFFER-FIELD("tObjectModule":U):BUFFER-VALUE     = gsc_product_module.product_module_code
            hTableBuffer:BUFFER-FIELD("tObjectDesc":U):BUFFER-VALUE       = ryc_smartObject.object_description
            .
          hTableBuffer:BUFFER-RELEASE().
        END.    /* each object */

      END.    /* data object loop */

    END. /* iEntryLoop */

  END. /* Repository */

  /* Decide what to return. */
  ASSIGN
    phBrowseDataTable = hTempTable.

  DELETE OBJECT hTempTable NO-ERROR.

  ASSIGN
    hTempTable = ?.

  RETURN.

END PROCEDURE.  /* retrieveBrowseData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveHeaderInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveHeaderInformation Procedure 
PROCEDURE retrieveHeaderInformation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttHeaderInfo.

    DEFINE VARIABLE cScmModulePath  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cPrMod          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iDatabaseLoop   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iProdModLoop    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.

    DO iDatabaseLoop = 1 TO NUM-DBS:
        CREATE ttHeaderInfo.
        ASSIGN ttHeaderInfo.tType         = "DATABASE":U
               ttHeaderInfo.tName         = LDBNAME(iDatabaseLoop)
               ttHeaderInfo.tIsRepository = CAN-DO("ICFDB,RTB,RVDB,TEMP-DB":U, ttHeaderInfo.tName)
               ttHeaderInfo.tExtraInfo    = "":U
               .
    END.    /* loop through DBs */

    FOR EACH gsc_product_module NO-LOCK:

        CREATE ttHeaderInfo.
        ASSIGN ttHeaderInfo.tType = "MODULE":U
               ttHeaderInfo.tName = gsc_product_module.product_module_code.

        /* If the SCM tool super procedure is running then use the relative paths from the SCM  
           modules instead of the ones from the Dynamics repository */
        IF VALID-HANDLE(ghScmTool) THEN
        DO:
           RUN scmGetModuleDir IN ghScmtool (INPUT gsc_product_module.product_module_code, 
                                             INPUT "":U, 
                                             OUTPUT cScmModulePath) NO-ERROR.
           ASSIGN 
              ttHeaderInfo.tExtraInfo = cScmModulePath + CHR(1) + gsc_product_module.product_module_description.
        END.
        ELSE
          ASSIGN 
              ttHeaderInfo.tExtraInfo = gsc_product_module.relative_path + CHR(1) + gsc_product_module.product_module_description.            

        /* Flag all the product modules as repostory modules. We will find the session filter set below and
           unflag the ones we are supposed to show for the current filter set */
        ttHeaderInfo.tIsRepository = TRUE.    
    END.    /* each product module */

    /* Apply the session's filter set to the product modules */
    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE "gsc_product_module":U BUFFER-NAME "gsc_product_module":U.

    cQuery = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM]":U.

    RUN processQueryStringFilterSets IN gshGenManager (INPUT  cQuery,
                                                       OUTPUT cQuery).

    /* Setup and prepare the query */
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    /* Step through the query if there is data */
    DO WHILE NOT hQuery:QUERY-OFF-END:
      /* Find the appropriate header record and flag it */
      FIND FIRST ttHeaderInfo
           WHERE ttHeaderInfo.tType = "MODULE":U
             AND ttHeaderInfo.tName = STRING(hBuffer:BUFFER-FIELD("product_module_code":U):BUFFER-VALUE).

      ttHeaderInfo.tIsRepository = FALSE.

      /* Find the next record */
      hQuery:GET-NEXT().
    END.

    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

    RETURN.
END PROCEDURE.  /* retrieveHeaderInformation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmValidate Procedure 
PROCEDURE scmValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcWorkspace        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER piTask             AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER pcProductModule    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDataObjectName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcProcedureName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSubType          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plOverwriteInTask  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lExistsInRtb              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExistsInWorkspace        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iWorkspaceVersion         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lWorkspaceCheckedOut      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersionTaskNumber        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLatestVersion            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectModule             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModulePath               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicFolder              AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghScmTool) THEN
    RETURN ERROR "The handle to the SCM tool is not valid. Validation cancelled.". 
    
  IF NUM-ENTRIES(pcProcedureName,"/":U) GT 0
  THEN
    ASSIGN
      cLogicFolder = ENTRY(NUM-ENTRIES(pcProcedureName, "/":U), pcProcedureName, "/":U).
  ELSE
  IF NUM-ENTRIES(pcProcedureName,"~\":U) GT 0
  THEN
    ASSIGN
      cLogicFolder = ENTRY(NUM-ENTRIES(pcProcedureName, "~\":U), pcProcedureName, "~\":U).

  RUN scmObjectExists IN ghScmTool
                     (INPUT  pcProcedureName
                     ,INPUT  pcWorkspace
                     ,OUTPUT lExistsInRtb
                     ,OUTPUT lExistsInWorkspace
                     ,OUTPUT iWorkspaceVersion
                     ,OUTPUT lWorkspaceCheckedOut
                     ,OUTPUT iVersionTaskNumber
                     ,OUTPUT iLatestVersion
                     ).

  IF lExistsInRtb
  THEN
    RUN scmGetObjectModule IN ghScmTool
                          (INPUT  pcWorkspace
                          ,INPUT  pcProcedureName
                          ,INPUT  pcSubType
                          ,OUTPUT cObjectModule
                          ,OUTPUT cModulePath
                          ).

  IF NOT lExistsInWorkspace
  THEN DO:

    IF lExistsInRtb
    THEN
      RETURN ERROR " The Object " + pcProcedureName + " exists in SCM Tool, but not in the selected workspace".

  END.
  ELSE DO:

    IF cObjectModule NE pcProductModule
    THEN
      RETURN ERROR " The Object " + pcProcedureName + " already exist in a different module than selected".

    IF cModulePath NE cLogicFolder
    THEN
      RETURN ERROR " The Object " + pcProcedureName + " already exist in a different directory than selected".

    IF lWorkspaceCheckedOut
    THEN DO:

      IF piTask EQ iVersionTaskNumber
      AND NOT plOverwriteInTask
      THEN
        RETURN ERROR " The Object " + pcProcedureName + " is checked out already and Logic overwrite flag is set to NO".

      IF piTask NE iVersionTaskNumber
      THEN
        RETURN ERROR " The Object " + pcProcedureName + " is checked out already in a different task".

    END.

  END.

  RETURN.

END PROCEDURE.  /* scmValidate */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getObjectInfoValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInfoValue Procedure 
FUNCTION getObjectInfoValue RETURNS CHARACTER
    ( INPUT pcObjectKey    AS CHARACTER,
      INPUT pcPData           AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValue              AS CHARACTER                    NO-UNDO.

  DEFINE BUFFER ttInfoInstance      FOR ttInfoInstance.

  FIND FIRST ttInfoInstance
    WHERE ttInfoInstance.tIKey    = pcObjectKey
    AND   ttInfoInstance.tIPData  = CAPS(pcObjectKey) + "-":U + pcPData
    NO-ERROR.
  IF AVAILABLE ttInfoInstance
  THEN
    ASSIGN
      cValue = ttInfoInstance.tIValue.
  ELSE
    ASSIGN
      cValue = ?.

  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logTheError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION logTheError Procedure 
FUNCTION logTheError RETURNS LOGICAL
    ( INPUT plRunSilent             AS LOGICAL,
      INPUT pcSection               AS CHARACTER,
      INPUT pcAction                AS CHARACTER,
      INPUT pcResult                AS CHARACTER,
      INPUT pcMessageType           AS CHARACTER,
      INPUT pcMessageText           AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates an error log entry 
    Notes:  * Error types: ERROR, INFORMATION
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNewButtonList          AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cNewTitle               AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog         AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay        AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE rErrorLog               AS RAW                      NO-UNDO.

  CREATE ttErrorLog.
  ASSIGN
    ttErrorLog.tSection         = pcSection
    ttErrorLog.tAction          = pcAction
    ttErrorLog.tResult          = pcResult
    ttErrorLog.tErrorType       = pcMessageType
    ttErrorLog.tDateLogged      = TODAY
    ttErrorLog.tTimeLogged      = TIME
    ttErrorLog.tMessageText     = pcMessageText
    ttErrorLog.tExpandedMessage = pcMessageText
    .
  /* We pass it through the formatting procedure to make the message human-readable. */
  /* This procedure also performs translations of the errors.                        */
  IF ttErrorLog.tErrorType EQ "ERROR":U
  THEN
    RUN afmessagep IN gshSessionManager
                           (INPUT  pcMessageText
                           ,INPUT  "":U
                           ,INPUT  "":U
                           ,OUTPUT ttErrorLog.tMessageText
                           ,OUTPUT ttErrorLog.tExpandedMessage
                           ,OUTPUT cNewButtonList
                           ,OUTPUT cNewTitle
                           ,OUTPUT lUpdateErrorLog
                           ,OUTPUT lSuppressDisplay
                           ) NO-ERROR.

  IF NOT plRunSilent
  THEN DO:

    /* Publish & Display */
    RAW-TRANSFER BUFFER ttErrorLog TO FIELD rErrorLog.

    PUBLISH "logObjectGeneratorMessage":U ( INPUT rErrorLog ).

  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScmToolHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setScmToolHandle Procedure 
FUNCTION setScmToolHandle RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hProcedure                  AS HANDLE               NO-UNDO.

  IF NOT VALID-HANDLE(ghScmTool)
  THEN DO:
     ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT "PRIVATE-DATA:SCMTool":U).
  END.    /* not valid SCM tool */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

