&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: ryrtbplipp.p

  Description:  ICF Versioning Utility PLIP
  
  Purpose:      ICF Versioning Utility PLIP

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6514   UserRef:    9.1B
                Date:   01/11/2000  Author:     Pieter Meyer

  Update Notes: AppServer and Client code copy procedures

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrtbplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

DEFINE STREAM sMain.
DEFINE STREAM sOut1.
DEFINE STREAM sOut2.

DEFINE TEMP-TABLE ttWTable     NO-UNDO
            FIELD tfWdbname    AS CHARACTER
            FIELD tfWtablename AS CHARACTER
            FIELD tfWdumpname  AS CHARACTER
            FIELD tfWtrigger   AS CHARACTER FORMAT "X(40)":U EXTENT 10
            INDEX tiWmain      IS PRIMARY UNIQUE
                    tfWdbname
                    tfWtablename
                    .

DEFINE TEMP-TABLE ttDeploy      NO-UNDO
            FIELD tfDobject     AS CHARACTER
            INDEX tiDmain       IS PRIMARY
                    tfDobject
                    .

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
         HEIGHT             = 26.43
         WIDTH              = 59.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-BuildDeployed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildDeployed Procedure 
PROCEDURE BuildDeployed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        DEFINE TEMP-TABLE ttDeploy  NO-UNDO
                    FIELD ttDobject     AS CHARACTER
                    FIELD ttDversion    AS CHARACTER
                    FIELD ttDrelease    AS CHARACTER
                    INDEX itDobject     IS PRIMARY
                            ttDobject
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDeployDirectory  AS CHARACTER    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDeploy.

    DEFINE VARIABLE cExtensions AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cBatchFile  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOutputFile AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFileName   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.

    /* Write batch file to do a directory listing of all files in the directory specified */
    ASSIGN
        cBatchFile      = SESSION:TEMP-DIRECTORY + "dir.bat":U
        cOutputFile     = SESSION:TEMP-DIRECTORY + "dir.log":U
        cDeployDirectory = LC(TRIM(REPLACE(cDeployDirectory,"/":U,"\":U)))
        cExtensions     = "p,w,ado":U
        .

    OUTPUT STREAM sMain TO VALUE(cBatchFile).
    DO iLoop = 1 TO NUM-ENTRIES(cExtensions):
        PUT STREAM sMain UNFORMATTED
            "dir /b/l/on/s ":U
            cDeployDirectory
            "\*.":U
            ENTRY(iLoop, cExtensions)
            (IF iLoop = 1 THEN " > ":U ELSE " >> ":U)
            cOutputFile
            SKIP.
    END.
    OUTPUT STREAM sMain CLOSE.

    /* Execute batch file */
    OS-COMMAND SILENT VALUE(cBatchFile).

    /* Check result */
    IF SEARCH(cOutputFile) <> ?
    THEN DO:
        INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
        REPEAT:
            IMPORT STREAM sMain UNFORMATTED
                cFileName.
            FIND FIRST ttDeploy NO-LOCK
                WHERE ttDeploy.tfDobject = cFileName
                NO-ERROR.
            IF NOT AVAILABLE ttDeploy
            THEN DO:
                CREATE ttDeploy.
                ASSIGN
                    ttDeploy.tfDobject = LC(TRIM(cFileName))
                    .
            END.
            ASSIGN
                ttDeploy.tfDobject = REPLACE(ttDeploy.tfDobject,cDeployDirectory,"":U)
                ttDeploy.tfDobject = REPLACE(ttDeploy.tfDobject,"~\":U,"~/":U)
                ttDeploy.tfDobject = TRIM(ttDeploy.tfDobject,"~/":U)
                .
        END.
        INPUT STREAM sMain CLOSE.
    END.

    /* Delete temp files */
    OS-DELETE VALUE(cBatchFile).
    OS-DELETE VALUE(cOutputFile). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildTable Procedure 
PROCEDURE BuildTable :
/*------------------------------------------------------------------------------
  Purpose:     Populates the ttFileField table with data from the _file and _field tables.
  Parameters:  <none>
  Notes:       
    RUN BuildTrigger  (INPUT 'FOR EACH ':U + cDatabaseName + '._file NO-LOCK WHERE NOT _file-name BEGINS "_":U ':U
                                 + ',EACH ':U + cDatabaseName + '._file-trig OF ':U + cDatabaseName + '._file':U
                         ,INPUT cDatabaseName
                         ,INPUT '_file,_file-trig':U
                         ,INPUT '_file._file-name,_file-trig._event':U
                         ,INPUT-OUTPUT TABLE ttWTable
                         ).
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER cDatabaseName AS CHARACTER    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE cQueryLine      AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cWidgetPool     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTable    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hFilename       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDumpname       AS HANDLE       NO-UNDO.

    ASSIGN
        cWidgetPool = "lWidgets"
        cQueryLine  = 'FOR EACH '   + TRIM(cDatabaseName) + '._file NO-LOCK '
                    + ' WHERE NOT ' + TRIM(cDatabaseName) + '._file._file-name BEGINS "_" '
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number > 0'
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number < 32768 '
        .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.

    CREATE BUFFER hBufferTable
           FOR TABLE      TRIM(cDatabaseName) + "._file":U
           IN WIDGET-POOL cWidgetPool.
    IF NOT hQuery:ADD-BUFFER(hBufferTable)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error setting buffers for dynamic query".
    END.

    IF NOT hQuery:QUERY-PREPARE(cQueryLine)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error preparing dynamic query".
    END.
    IF NOT hQuery:QUERY-OPEN
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error opening dynamic query".
    END.

    IF NOT hQuery:REPOSITION-TO-ROW(1)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error re-positioning dynamic query".
    END.

    /* Retrieve the Field Values */
    REPEAT:

        IF NOT hQuery:GET-NEXT
        THEN LEAVE.

        ASSIGN
            hFilename  = hBufferTable:BUFFER-FIELD("_file-name")
            hDumpname  = hBufferTable:BUFFER-FIELD("_dump-name")
            .

        FIND FIRST ttWTable EXCLUSIVE-LOCK
            WHERE ttWTable.tfWdbname    = hBufferTable:DBNAME
            AND   ttWTable.tfWtablename = LC(TRIM(hFilename:STRING-VALUE))
            NO-ERROR.
        IF NOT AVAILABLE ttWTable
        THEN DO:
            CREATE ttWTable.
            ASSIGN
                ttWTable.tfWdbname    = hBufferTable:DBNAME
                ttWTable.tfWtablename = LC(TRIM(hFilename:STRING-VALUE))
                .
        END.
        ASSIGN
            ttWTable.tfWdumpname  = LC(TRIM(hDumpname:STRING-VALUE))
            .

    END.

    /* Release the Buffers for the tables */
    hBufferTable:BUFFER-RELEASE.
    DELETE OBJECT hBufferTable.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildTrigger Procedure 
PROCEDURE BuildTrigger :
/*------------------------------------------------------------------------------
  Purpose:     Populates the ttFileField table with data from the _file and _field tables.
  Parameters:  <none>
  Notes:       
    RUN BuildTrigger  (INPUT 'FOR EACH ':U + cDatabaseName + '._file NO-LOCK WHERE NOT _file-name BEGINS "_":U ':U
                                 + ',EACH ':U + cDatabaseName + '._file-trig OF ':U + cDatabaseName + '._file':U
                         ,INPUT cDatabaseName
                         ,INPUT '_file,_file-trig':U
                         ,INPUT '_file._file-name,_file-trig._event':U
                         ,INPUT-OUTPUT TABLE ttWTable
                         ).
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER cDatabaseName AS CHARACTER    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE cQueryLine      AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cWidgetPool     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTable    AS HANDLE       NO-UNDO EXTENT 2.
    DEFINE VARIABLE hFilename       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDumpname       AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hEventname      AS HANDLE       NO-UNDO.

    ASSIGN
        cWidgetPool = "lWidgets"
        cQueryLine  = 'FOR EACH '   + TRIM(cDatabaseName) + '._file NO-LOCK '
                    + ' WHERE NOT ' + TRIM(cDatabaseName) + '._file._file-name BEGINS "_" '
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number > 0'
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number < 32768 '
                    + ',EACH ':U    + TRIM(cDatabaseName) + '._file-trig OF ':U
                                    + TRIM(cDatabaseName) + '._file':U
        .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.

    CREATE BUFFER hBufferTable[1]
           FOR TABLE      TRIM(cDatabaseName) + "._file":U
           IN WIDGET-POOL cWidgetPool.
    IF NOT hQuery:ADD-BUFFER(hBufferTable[1])
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error setting buffers for dynamic query".
    END.

    CREATE BUFFER hBufferTable[2]
           FOR TABLE      TRIM(cDatabaseName) + "._file-trig":U
           IN WIDGET-POOL cWidgetPool.
    IF NOT hQuery:ADD-BUFFER(hBufferTable[2])
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error setting buffers for dynamic query".
    END.

    IF NOT hQuery:QUERY-PREPARE(cQueryLine)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error preparing dynamic query".
    END.
    IF NOT hQuery:QUERY-OPEN
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error opening dynamic query".
    END.

    IF NOT hQuery:REPOSITION-TO-ROW(1)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error re-positioning dynamic query".
    END.

    /* Retrieve the Field Values */
    REPEAT:

        IF NOT hQuery:GET-NEXT
        THEN LEAVE.

        ASSIGN
            hFilename  = hBufferTable[1]:BUFFER-FIELD("_file-name")
            hDumpname  = hBufferTable[1]:BUFFER-FIELD("_dump-name")
            hEventname = hBufferTable[2]:BUFFER-FIELD("_event")
            .

        FIND FIRST ttWTable EXCLUSIVE-LOCK
            WHERE ttWTable.tfWdbname    = hBufferTable[1]:DBNAME
            AND   ttWTable.tfWtablename = LC(TRIM(hFilename:STRING-VALUE))
            NO-ERROR.
        IF NOT AVAILABLE ttWTable
        THEN DO:
            CREATE ttWTable.
            ASSIGN
                ttWTable.tfWdbname    = hBufferTable[1]:DBNAME
                ttWTable.tfWtablename = LC(TRIM(hFilename:STRING-VALUE))
                ttWTable.tfWdumpname  = LC(TRIM(hDumpname:STRING-VALUE))
                .
        END.

        IF hEventname:STRING-VALUE  = "CREATE":U                THEN ASSIGN ttWTable.tfWtrigger[1] = TRIM(hEventname:STRING-VALUE).
        IF hEventname:STRING-VALUE  = "WRITE":U                 THEN ASSIGN ttWTable.tfWtrigger[2] = TRIM(hEventname:STRING-VALUE).
        IF hEventname:STRING-VALUE  = "DELETE":U                THEN ASSIGN ttWTable.tfWtrigger[3] = TRIM(hEventname:STRING-VALUE).
        IF hEventname:STRING-VALUE  = "REPLICATION-CREATE":U    THEN ASSIGN ttWTable.tfWtrigger[4] = TRIM(hEventname:STRING-VALUE).
        IF hEventname:STRING-VALUE  = "REPLICATION-WRITE":U     THEN ASSIGN ttWTable.tfWtrigger[5] = TRIM(hEventname:STRING-VALUE).
        IF hEventname:STRING-VALUE  = "REPLICATION-DELETE":U    THEN ASSIGN ttWTable.tfWtrigger[6] = TRIM(hEventname:STRING-VALUE).

    END.

    /* Release the Buffers for the tables */
    hBufferTable[1]:BUFFER-RELEASE.
    DELETE OBJECT hBufferTable[1].

    hBufferTable[2]:BUFFER-RELEASE.
    DELETE OBJECT hBufferTable[2].

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeployRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeployRepository Procedure 
PROCEDURE DeployRepository :
/*------------------------------------------------------------------------------
  Purpose:     TO create the dump of repository data for all logical objects
               and the parameters for any physical objects
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  lDeployRepository   AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  lFullRepository     AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  lDeployRepoVersion  AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  lNewBasline         AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  cDeployWorkspace    AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER  cDeployDirectoy     AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER  cDeployLicence      AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER cErrorValue         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cTrgDirectory       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRYTriggers         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRVTriggers         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cDirCreateOsError   AS CHARACTER    NO-UNDO.

    EMPTY TEMP-TABLE ttDeploy.
    EMPTY TEMP-TABLE ttWTable.

    ASSIGN
        cTrgDirectory   = SESSION:TEMP-DIR
        cTrgDirectory   = REPLACE(cTrgDirectory,"~\":U,"~/":U)
        cTrgDirectory   = cTrgDirectory + IF SUBSTRING(cTrgDirectory,LENGTH(cTrgDirectory),1) = "~/":U THEN "~/":U ELSE "":U
        cRYTriggers     = cTrgDirectory + "miprytrgop.p":U
        cRVTriggers     = cTrgDirectory + "miprvtrgop.p":U
        .

    RUN BuildDeployed (INPUT cDeployDirectoy
                      ,INPUT-OUTPUT TABLE ttDeploy).

    IF lDeployRepository
    THEN DO:
        RUN BuildTable    (INPUT "ICFDB":U
                          ,INPUT-OUTPUT TABLE ttWTable).
        RUN OutputTrigger (INPUT "ICFDB":U
                          ,INPUT cRYTriggers
                          ,INPUT TABLE ttWTable).
        RUN VALUE(cRYTriggers).
    END.

    IF lDeployRepoVersion
    THEN DO:
        RUN BuildTable    (INPUT "RVDB":U
                          ,INPUT-OUTPUT TABLE ttWTable).
        RUN OutputTrigger (INPUT "RVDB":U
                          ,INPUT cRVTriggers
                          ,INPUT TABLE ttWTable).
        RUN VALUE(cRVTriggers).
    END.

    IF lDeployRepository
    THEN
        RUN ExportRYData  (INPUT cDeployDirectoy
                          ,INPUT TABLE ttWTable
                          ,INPUT TABLE ttDeploy).

    IF  lDeployRepoVersion
    AND cDeployLicence = "P":U
    THEN
        RUN ExportRVData (INPUT cDeployWorkspace
                         ,INPUT cDeployDirectoy
                         ,INPUT TABLE ttWTable).

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExportRVData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRVData Procedure 
PROCEDURE ExportRVData :
/*------------------------------------------------------------------------------
  Purpose:     Export ALL Static Data Tables
  Parameters:  <none>
  Notes:       Smart Data Tables to IMPORT
                rvm_workspace
                rvm_workspace_module
                rvt_workspace_checkout
                rvm_workspace_item
                    rvt_item_version
                        rvm_configuration_item
                            rvc_configuration_type
                rvt_deleted_item
                rvt_action_underway

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDeployWSpaceId      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER cDeployDirectory     AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE cExportWorkspace            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportWorkspaceModule      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportWorkspaceCheckout    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportWorkspaceItem        AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportItemVersion          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportConfigurationItem    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportConfigurationType    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportDeletedItem          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportActionUnderway       AS CHARACTER    NO-UNDO.

    ASSIGN
        cDeployDirectory = LC(TRIM(REPLACE(cDeployDirectory,"~\":U,"~/":U))).

    FOR EACH ttWTable NO-LOCK
        WHERE ttWTable.tfWdbname = "RVDB":U
        :
        CASE ttWTable.tfWtablename :
            WHEN "rvm_workspace":U          THEN ASSIGN cExportWorkspace            = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_workspace_module":U   THEN ASSIGN cExportWorkspaceModule      = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_workspace_checkout":U THEN ASSIGN cExportWorkspaceCheckout    = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_workspace_item":U     THEN ASSIGN cExportWorkspaceItem        = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_item_version":U       THEN ASSIGN cExportItemVersion          = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_configuration_item":U THEN ASSIGN cExportConfigurationItem    = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvc_configuration_type":U THEN ASSIGN cExportConfigurationType    = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_deleted_item":U       THEN ASSIGN cExportDeletedItem          = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_action_underway":U    THEN ASSIGN cExportActionUnderway       = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
        END CASE.
    END.

    OS-DELETE VALUE(cExportWorkspace).
    OS-DELETE VALUE(cExportWorkspaceModule).
    OS-DELETE VALUE(cExportWorkspaceCheckout).
    OS-DELETE VALUE(cExportWorkspaceItem).
    OS-DELETE VALUE(cExportItemVersion).
    OS-DELETE VALUE(cExportConfigurationItem).
    OS-DELETE VALUE(cExportConfigurationType).
    OS-DELETE VALUE(cExportDeletedItem).
    OS-DELETE VALUE(cExportActionUnderway).

    IF cExportWorkspace <> "":U
    THEN DO:
        FOR EACH rvm_workspace NO-LOCK
            WHERE rvm_workspace.workspace_code = cDeployWSpaceId
            :

            /* "rvm_workspace":U */ 
            OUTPUT STREAM sMain TO VALUE(cExportWorkspace) APPEND.
            EXPORT STREAM sMain rvm_workspace.
            OUTPUT STREAM sMain CLOSE.

            /* "rvm_workspace_module":U */ 
            IF cExportWorkspaceModule <> "":U
            THEN DO:
                OUTPUT STREAM sMain TO VALUE(cExportWorkspaceModule) APPEND.
                FOR EACH rvm_workspace_module NO-LOCK
                    WHERE rvm_workspace_module.workspace_obj = rvm_workspace.workspace_obj
                    :
                    EXPORT STREAM sMain rvm_workspace_module.
                END.
                OUTPUT STREAM sMain CLOSE.
            END. /* "rvm_workspace_module":U */ 

            /* "rvt_workspace_checkout":U */ 
            IF cExportWorkspaceCheckout <> "":U
            THEN DO:
                OUTPUT STREAM sMain TO VALUE(cExportWorkspaceCheckout) APPEND.
                FOR EACH rvt_workspace_checkout NO-LOCK
                    WHERE rvt_workspace_checkout.workspace_obj = rvm_workspace.workspace_obj
                    :
                    EXPORT STREAM sMain rvt_workspace_checkout.
                END.
                OUTPUT STREAM sMain CLOSE.
            END. /* "rvt_workspace_checkout":U */

            /* "rvm_workspace_item":U */ 
            IF cExportWorkspaceItem <> "":U
            THEN DO:
                FOR EACH rvm_workspace_item NO-LOCK
                    WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
                    :

                    OUTPUT STREAM sMain TO VALUE(cExportWorkspaceItem) APPEND.
                    EXPORT STREAM sMain rvm_workspace_item.
                    OUTPUT STREAM sMain CLOSE.

                    /* "rvt_item_version":U */ 
                    IF cExportItemVersion <> "":U
                    THEN DO:

                        OUTPUT STREAM sMain TO VALUE(cExportItemVersion) APPEND.

                        FOR EACH rvt_item_version NO-LOCK
                            WHERE rvt_item_version.configuration_type  = rvm_workspace_item.configuration_type
                            AND   rvt_item_version.scm_object_name     = rvm_workspace_item.scm_object_name
                            AND   rvt_item_version.item_version_number = rvm_workspace_item.item_version_number
                            :

                            EXPORT STREAM sMain rvt_item_version.

                            /* "rvm_configuration_item":U */ 
                            IF cExportConfigurationItem <> "":U
                            THEN DO:

                                OUTPUT STREAM sOut1 TO VALUE(cExportConfigurationItem) APPEND.

                                FOR EACH rvm_configuration_item NO-LOCK
                                    WHERE rvm_configuration_item.configuration_type  =  rvt_item_version.configuration_type
                                    AND   rvm_configuration_item.scm_object_name     =  rvt_item_version.scm_object_name
                                    :

                                    EXPORT STREAM sOut1 rvm_configuration_item.

                                    /* "rvc_configuration_type":U */ 
                                    IF cExportConfigurationType <> "":U
                                    THEN DO:
                                        OUTPUT STREAM sOut2 TO VALUE(cExportConfigurationType) APPEND.
                                        FOR EACH rvc_configuration_type NO-LOCK
                                            WHERE rvc_configuration_type.configuration_type  =  rvm_configuration_item.configuration_type
                                            :
                                            EXPORT STREAM sOut2 rvc_configuration_type.
                                        END.
                                        OUTPUT STREAM sOut2 CLOSE.
                                    END. /* "rvc_configuration_type":U */ 

                                END. /* "rvm_configuration_item":U */ 

                                OUTPUT STREAM sOut1 CLOSE.

                            END. /* "rvm_configuration_item":U */ 

                        END. /* "rvt_item_version":U */

                        OUTPUT STREAM sMain CLOSE.

                    END. /* IF cExportItemVersion <> "":U */

                END. /* "rvm_workspace_item":U */

            END. /* IF cExportWorkspaceItem <> "":U */

            /* "rvt_deleted_item":U */ 
            IF cExportDeletedItem <> "":U
            THEN DO:
                OUTPUT STREAM sMain TO VALUE(cExportDeletedItem) APPEND.
                FOR EACH rvt_deleted_item NO-LOCK
                    WHERE rvt_deleted_item.workspace_obj = rvm_workspace.workspace_obj
                    :
                    EXPORT STREAM sMain rvt_deleted_item.
                END.
                OUTPUT STREAM sMain CLOSE.
            END. /* "rvt_deleted_item":U */ 

        END. /* "rvm_worksspace":U */

    END. /* IF cExportWorkspace <> "":U */

    /* "rvt_action_underway":U */ 
    IF cExportActionUnderway <> "":U
    THEN DO:
        OUTPUT STREAM sMain TO VALUE(cExportActionUnderway) APPEND.
        FOR EACH rvt_action_underway NO-LOCK
            :
            EXPORT STREAM sMain rvt_action_underway.
        END.
        OUTPUT STREAM sMain CLOSE.
    END. /* "rvt_action_underway":U */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExportRYData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRYData Procedure 
PROCEDURE ExportRYData :
/*------------------------------------------------------------------------------
  Purpose:     Export changed Smart Data object Data Tables
  Parameters:  <none>
  Notes:       Smart Data Tables to export
                ryc_smartobject
                    ryc_object_instance
                    ryc_page
                        ryc_page_object
                    ryc_smartlink
                    ryc_smartobject_field
                    ryc_custom_ui_trigger
                    ryc_attribute_value
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDeployDirectory  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttWTable.
    DEFINE INPUT PARAMETER TABLE FOR ttDeploy.

    DEFINE VARIABLE cExportSmartObject      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportObjectInstance   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportPage             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportPageObject       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportSmartLink        AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportSmartObjectField AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportCustomUiTrigger  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cExportAttributeValue   AS CHARACTER    NO-UNDO.

    ASSIGN
        cDeployDirectory = LC(TRIM(REPLACE(cDeployDirectory,"~\":U,"~/":U))).

    FOR EACH ttWTable NO-LOCK
        WHERE ttWTable.tfWdbname = "ICFDB":U
        :
        CASE ttWTable.tfWtablename :
            WHEN "ryc_smartobject":U       THEN ASSIGN cExportSmartObject      = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_object_instance":U   THEN ASSIGN cExportObjectInstance   = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_page":U              THEN ASSIGN cExportPage             = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_page_object":U       THEN ASSIGN cExportPageObject       = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_smartlink":U         THEN ASSIGN cExportSmartLink        = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_smartobject_field":U THEN ASSIGN cExportSmartObjectField = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_custom_ui_trigger":U THEN ASSIGN cExportCustomUiTrigger  = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_attribute_value":U   THEN ASSIGN cExportAttributeValue   = cDeployDirectory + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
        END CASE.
    END.

    FOR EACH ttDeploy
        NO-LOCK:

        /* 1st action to export smartobject itself */
        FIND FIRST ryc_smartobject NO-LOCK
            WHERE ryc_smartobject.OBJECT_filename = REPLACE(ttDeploy.tfDobject,".ado":U,"":U)
            NO-ERROR.
        IF NOT AVAILABLE ryc_smartobject
        THEN NEXT.

        IF cExportSmartObject <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportSmartObject) APPEND.
            EXPORT STREAM sOut1
                ryc_smartobject.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        /* actions to create related tables */ 
        IF cExportObjectInstance <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportObjectInstance) APPEND.
            FOR EACH ryc_object_instance NO-LOCK
                WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_object_instance.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        IF cExportPage <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportPage) APPEND.
            FOR EACH ryc_page NO-LOCK
                WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_page.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        IF cExportPageObject <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportPageObject) APPEND.
            FOR EACH ryc_page_object NO-LOCK
                WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_page_object.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        IF cExportSmartLink <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportSmartLink) APPEND.
            FOR EACH ryc_smartlink NO-LOCK
                WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_smartlink.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        IF cExportSmartObjectField <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportSmartObjectField) APPEND.
            FOR EACH ryc_smartobject_field NO-LOCK
                WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_smartobject_field.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        IF cExportCustomUiTrigger <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportCustomUiTrigger) APPEND.
            FOR EACH ryc_custom_ui_trigger NO-LOCK
                WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_custom_ui_trigger.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

        /* For attribute values - not supporting collections for now */
        /* Also this should do attributes for smartobject and instances for a container */
        IF cExportAttributeValue <> "":U
        THEN DO:
            OUTPUT STREAM sOut1 TO VALUE(cExportAttributeValue) APPEND.
            FOR EACH ryc_attribute_value NO-LOCK
                WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj
                :
                EXPORT STREAM sOut1
                    ryc_attribute_value.
            END.
            OUTPUT STREAM sOut1 CLOSE.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ImportRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportRepository Procedure 
PROCEDURE ImportRepository :
/*------------------------------------------------------------------------------
  Purpose:     TO create the load of repository data for all logical objects
               and the parameters for any physical objects
  Parameters:  rRtbSite       : STRING value of RECID of the rtb_site  table
  / Meaning :  rRtbDeploy     : STRING value of RECID of the rtb_deploy table
               output error message text if any.
  Notes:       
        rtb_site
            rtb_site.site-code
            rtb_site.wspace-id
        rtb_deploy
            rtb_deploy.site-code
            rtb_deploy.wspace-id
            rtb_deploy.deploy-sequence
            rtb_deploy.deploy-status
            rtb_deploy.release-num
            rtb_deploy.directory
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  lImportRepository   AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  lImportRepoVersion  AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER  cDeployDir          AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER cErrorValue         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cTrgDirectory               AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRYTriggers                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRVTriggers                 AS CHARACTER    NO-UNDO.

    ASSIGN
        cTrgDirectory = SESSION:TEMP-DIR
        cTrgDirectory = REPLACE(cTrgDirectory,"~\":U,"~/":U)
        cTrgDirectory = cTrgDirectory + IF SUBSTRING(cTrgDirectory,LENGTH(cTrgDirectory),1) = "~/":U THEN "~/":U ELSE "":U
        cRYTriggers   = cTrgDirectory + "miprytrgop.p":U
        cRVTriggers   = cTrgDirectory + "miprvtrgop.p":U
        cDeployDir    = REPLACE(cDeployDir,"~\":U,"~/":U)
        cDeployDir    = TRIM(cDeployDir,"~/":U)
        cDeployDir    = TRIM(cDeployDir,"icf_dbdata":U)
        cDeployDir    = TRIM(cDeployDir,"~/":U) + "~/":U + "icf_dbdata":U + "~/":U
        .

    /* REPOSITORY DATA */
    EMPTY TEMP-TABLE ttWTable.

    IF lImportRepository = YES
    THEN DO:
        /* Run the program to build the list of objects exported for this deployment */
        RUN BuildTable    (INPUT "ICFDB":U
                          ,INPUT-OUTPUT TABLE ttWTable).
        RUN OutputTrigger (INPUT "ICFDB":U
                          ,INPUT cRYTriggers
                          ,INPUT TABLE ttWTable).
        RUN VALUE(cRYTriggers).
    END.

    IF lImportRepoVersion = YES
    THEN DO:
        /* Run the program to build the list of objects exported for this deployment */
        RUN BuildTable    (INPUT "RVDB":U
                          ,INPUT-OUTPUT TABLE ttWTable).
        RUN OutputTrigger (INPUT "RVDB":U
                          ,INPUT cRVTriggers
                          ,INPUT TABLE ttWTable).
        RUN VALUE(cRVTriggers).
    END.

    IF lImportRepository = YES
    THEN DO:
        /* Run the program to run through the list of objects and exported the ICFDB entries for this deployment */
        RUN ImportRYData (INPUT cDeployDir
                         ,INPUT TABLE ttWTable).
    END.

    IF lImportRepoVersion = YES
    THEN DO:
        /* REPOSITORY VERSION DATA */
        /* Run the program to run through the list of objects and exported the ICFDB entries for this deployment */
        RUN ImportRVData (INPUT TABLE ttWTable).
    END.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ImportRVData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportRVData Procedure 
PROCEDURE ImportRVData :
/*------------------------------------------------------------------------------
  Purpose:     IMPORT changed Smart Data object Data Tables
  Parameters:  <none>
  Notes:       Smart Data Tables to IMPORT
                rvm_workspace
                rvm_workspace_item
                rvm_workspace_module
                rvt_workspace_checkout
                rvt_deleted_item
                rvt_item_version
                rvm_configuration_item
                rvc_configuration_type
                rvt_action_underway
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  cDeployDir  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE cInputWorkspace         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputWorkspaceItem     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputWorkspaceModule   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputWorkspaceCheckout AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputDeletedItem       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputItemVersion       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputConfigurationItem AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputConfigurationType AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputActionUnderway    AS CHARACTER    NO-UNDO.

    FOR EACH ttWTable NO-LOCK:
        CASE ttWTable.tfWtablename :
            WHEN "rvm_workspace":U          THEN ASSIGN cInputWorkspace         = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_workspace_item":U     THEN ASSIGN cInputWorkspaceItem     = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_workspace_module":U   THEN ASSIGN cInputWorkspaceModule   = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_workspace_checkout":U THEN ASSIGN cInputWorkspaceCheckout = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_deleted_item":U       THEN ASSIGN cInputDeletedItem       = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_item_version":U       THEN ASSIGN cInputItemVersion       = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvm_configuration_item":U THEN ASSIGN cInputConfigurationItem = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvc_configuration_type":U THEN ASSIGN cInputConfigurationType = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "rvt_action_underway":U    THEN ASSIGN cInputActionUnderway    = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
        END CASE.
    END.

/* rvm_workspace */
    IF cInputWorkspace <> "":U
    AND SEARCH(cInputWorkspace) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputWorkspace).
        REPEAT:
          IMPORT STREAM sOut1
              rvm_workspace
              NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvm_workspace_item */
    /* actions to create related tables */ 
    IF cInputWorkspaceItem <> "":U
    AND SEARCH(cInputWorkspaceItem) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputWorkspaceItem).
        REPEAT:
            IMPORT STREAM sOut1
                rvm_workspace_item
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvm_workspace_module */
    IF cInputWorkspaceModule <> "":U
    AND SEARCH(cInputWorkspaceModule) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputWorkspaceModule).
        REPEAT:
            IMPORT STREAM sOut1
                rvm_workspace_module
                NO-ERROR.

        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvt_workspace_checkout */
    IF cInputWorkspaceCheckout <> "":U
    AND SEARCH(cInputWorkspaceCheckout) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputWorkspaceCheckout).
        REPEAT:
            IMPORT STREAM sOut1
                rvt_workspace_checkout
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvt_deleted_item */
    IF cInputDeletedItem <> "":U
    AND SEARCH(cInputDeletedItem) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputDeletedItem).
        REPEAT:
            IMPORT STREAM sOut1
                rvt_deleted_item
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvt_item_version */
    IF cInputItemVersion <> "":U
    AND SEARCH(cInputItemVersion) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputItemVersion).
        REPEAT:
            IMPORT STREAM sOut1
                rvt_item_version
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvm_configuration_item */
    IF cInputConfigurationItem <> "":U
    AND SEARCH(cInputConfigurationItem) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputConfigurationItem).
        REPEAT:
            IMPORT STREAM sOut1
                rvm_configuration_item
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvc_configuration_type */
    /* For attribute values - not supporting collections for now */
    /* Also this should do attributes for smartobject and instances for a container */
    IF cInputConfigurationType <> "":U
    AND SEARCH(cInputConfigurationType) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputConfigurationType).
        REPEAT:
            IMPORT STREAM sOut1
                rvc_configuration_type
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* rvt_action_underway */
    IF cInputActionUnderway <> "":U
    AND SEARCH(cInputActionUnderway) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputActionUnderway).
        REPEAT:
            IMPORT STREAM sOut1
                rvt_action_underway
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ImportRYData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportRYData Procedure 
PROCEDURE ImportRYData :
/*------------------------------------------------------------------------------
  Purpose:     IMPORT changed Smart Data object Data Tables
  Parameters:  <none>
  Notes:       Smart Data Tables to IMPORT
                ryc_smartobject
                    ryc_object_instance
                    ryc_page
                        ryc_page_object
                    ryc_smartlink
                    ryc_smartobject_field
                    ryc_custom_ui_trigger
                    ryc_attribute_value
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  cDeployDir  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE cInputSmartObject      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputObjectInstance   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputPage             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputPageObject       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputSmartLink        AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputSmartObjectField AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputCustomUiTrigger  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cInputAttributeValue   AS CHARACTER    NO-UNDO.

    FOR EACH ttWTable NO-LOCK:
        CASE ttWTable.tfWtablename :
            WHEN "ryc_smartobject":U       THEN ASSIGN cInputSmartObject      = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_object_instance":U   THEN ASSIGN cInputObjectInstance   = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_page":U              THEN ASSIGN cInputPage             = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_page_object":U       THEN ASSIGN cInputPageObject       = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_smartlink":U         THEN ASSIGN cInputSmartLink        = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_smartobject_field":U THEN ASSIGN cInputSmartObjectField = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_custom_ui_trigger":U THEN ASSIGN cInputCustomUiTrigger  = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
            WHEN "ryc_attribute_value":U   THEN ASSIGN cInputAttributeValue   = cDeployDir + (IF ttWTable.tfWdumpname <> "":U THEN ttWTable.tfWdumpname ELSE ttWTable.tfWtablename) + ".d":U.
        END CASE.
    END.

/* ryc_smartobject */
    IF cInputSmartObject <> "":U
    AND SEARCH(cInputSmartObject) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputSmartObject).
        REPEAT:
          IMPORT STREAM sOut1
              ryc_smartobject
              NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_object_instance */
    /* actions to create related tables */ 
    IF cInputObjectInstance <> "":U
    AND SEARCH(cInputObjectInstance) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputObjectInstance).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_object_instance
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_page */
    IF cInputPage <> "":U
    AND SEARCH(cInputPage) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputPage).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_page
                NO-ERROR.

        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_page_object */
    IF cInputPageObject <> "":U
    AND SEARCH(cInputPageObject) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputPageObject).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_page_object
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_smartlink */
    IF cInputSmartLink <> "":U
    AND SEARCH(cInputSmartLink) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputSmartLink).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_smartlink
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_smartobject_field */
    IF cInputSmartObjectField <> "":U
    AND SEARCH(cInputSmartObjectField) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputSmartObjectField).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_smartobject_field
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_custom_ui_trigger */
    IF cInputCustomUiTrigger <> "":U
    AND SEARCH(cInputCustomUiTrigger) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputCustomUiTrigger).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_custom_ui_trigger
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

/* ryc_attribute_value */
    /* For attribute values - not supporting collections for now */
    /* Also this should do attributes for smartobject and instances for a container */
    IF cInputAttributeValue <> "":U
    AND SEARCH(cInputAttributeValue) <> ?
    THEN DO:
        INPUT STREAM sOut1 FROM VALUE(cInputAttributeValue).
        REPEAT:
            IMPORT STREAM sOut1
                ryc_attribute_value
                NO-ERROR.
        END.
        INPUT STREAM sOut1 CLOSE.
    END.

END PROCEDURE.

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

ASSIGN cDescription = "Versioning PLIP".

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

&IF DEFINED(EXCLUDE-OutputTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutputTrigger Procedure 
PROCEDURE OutputTrigger :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDatabaseName    AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER cOutputFile      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttWTable.

    DEFINE VARIABLE iLoop                   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cTriggerList            AS CHARACTER    NO-UNDO.

    OUTPUT STREAM sMain TO VALUE(cOutputFile).

    FOR EACH ttWTable NO-LOCK
        WHERE ttWTable.tfWdbname = cDatabaseName
        BREAK BY ttWTable.tfWdbname
              BY ttWTable.tfWtablename
        :

        IF FIRST-OF(ttWTable.tfWdbname)
        THEN
            PUT STREAM sMain UNFORMATTED
                SKIP " "
                SKIP "~/* TRIGGERS FOR DB : ":U + ttWTable.tfWdbname + "*~/":U
                SKIP " "
                .

        PUT STREAM sMain UNFORMATTED SKIP 'DISABLE TRIGGERS FOR DUMP OF ' TRIM(ttWTable.tfWdbname) '.':U TRIM(ttWTable.tfWtablename) '.':U.
        PUT STREAM sMain UNFORMATTED SKIP 'DISABLE TRIGGERS FOR LOAD OF ' TRIM(ttWTable.tfWdbname) '.':U TRIM(ttWTable.tfWtablename) '.':U.

        PUT STREAM sMain UNFORMATTED SKIP ' '.

    END.

    OUTPUT STREAM sMain CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

