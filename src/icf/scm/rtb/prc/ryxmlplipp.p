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
  File: ryxmlplipp.p

  Description:  Repository XML APIs
  
  Purpose:      Repository XML APIs

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000097   UserRef:    
                Date:   02/05/2001  Author:     Anthony Swindells

  Update Notes: Created from Template rytemplipp.p

  (v:010004)    Task:    90000018   UserRef:    
                Date:   01/25/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

  (v:010005)    Task:    90000018   UserRef:    
                Date:   01/28/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

  (v:010006)    Task:    90000018   UserRef:    
                Date:   01/29/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

  (v:010007)    Task:    90000021   UserRef:    
                Date:   02/17/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryxmlplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010007

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName                         AS CHARACTER    NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{af/sup2/afrun2.i &Define-only = YES}

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wsroot       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num     AS INTEGER      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-propath      AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-userid       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-access       AS CHARACTER    NO-UNDO.

DEFINE VARIABLE ghScmTool                           AS HANDLE       NO-UNDO.

DEFINE TEMP-TABLE ttObject    NO-UNDO
       FIELD cWorkspace       AS CHARACTER
       FIELD cProductModule   AS CHARACTER
       FIELD cObjectName      AS CHARACTER
       INDEX idxMain          IS PRIMARY UNIQUE
              cObjectName
       INDEX idxFull          IS UNIQUE
              cWorkspace
              cProductModule
              cObjectName
       .

DEFINE TEMP-TABLE ttError     NO-UNDO
       FIELD cObjectName      AS CHARACTER
       FIELD cError           AS CHARACTER
       INDEX idxMain          IS PRIMARY
              cObjectName
              cError
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
         HEIGHT             = 12.62
         WIDTH              = 46.8.
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

&IF DEFINED(EXCLUDE-checkOutObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkOutObjects Procedure 
PROCEDURE checkOutObjects :
/*------------------------------------------------------------------------------
  Purpose:     To check-out objects specified.
  Parameters:  <none>
  Notes:       Done so that .ado files that have been regenerated get
               re-registered in the SCM tool.
------------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER TABLE     FOR ttObject.
  DEFINE INPUT        PARAMETER piTask    AS INTEGER    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER TABLE     FOR ttError.
  DEFINE       OUTPUT PARAMETER pcError   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cError                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSCMObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExistsInRtb1           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExistsInWorkspace1     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iWorkspaceVersion1      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lWorkspaceCheckedOut1   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersionTaskNumber1     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLatestVersion1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecid                  AS RECID      NO-UNDO.

  object-loop:
  FOR EACH ttObject:

    ASSIGN
      cSCMObjectName = ttObject.cObjectName.
    RUN scmADOExtAdd IN ghScmTool
                    (INPUT-OUTPUT cSCMObjectName).

    FIND FIRST gsc_object NO-LOCK
      WHERE gsc_object.object_filename = ttObject.cObjectName
      NO-ERROR.
    IF AVAILABLE gsc_object
    THEN DO:
      FIND FIRST gsc_object_type NO-LOCK
        WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj
        NO-ERROR.
      IF NOT AVAILABLE gsc_object_type
      THEN DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = cSCMObjectName
          ttError.cError      = cSCMObjectName +  "object type does not exist in ICFDB database"
          pcError             = "ERROR".
        NEXT object-loop.
      END.
    END.
    ELSE DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName +  "object does not exist in ICFDB database"
        pcError             = "ERROR".
      NEXT object-loop.
    END.

    RUN scmObjectExists IN ghScmTool
                       (INPUT  cSCMObjectName
                       ,INPUT  ttObject.cWorkspace
                       ,OUTPUT lExistsInRtb1
                       ,OUTPUT lExistsInWorkspace1
                       ,OUTPUT iWorkspaceVersion1
                       ,OUTPUT lWorkspaceCheckedOut1
                       ,OUTPUT iVersionTaskNumber1
                       ,OUTPUT iLatestVersion1
                       ).

    IF NOT lExistsInWorkspace1
    AND lExistsinRtb1
    THEN DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName +  " Object exists in SCM Tool, but not in the selected workspace"
        pcError             = "ERROR".
      NEXT object-loop.
    END.
    IF lExistsInWorkspace1
    AND lWorkspaceCheckedOut1
    AND piTask <> iVersionTaskNumber1
    THEN DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName + " Object is checked out already in a different task"
        pcError             = "ERROR".
      NEXT object-loop.
    END.

    IF NOT lExistsInWorkspace1
    THEN DO:
      RUN scmCreateObjectControl IN ghScmTool
                                (INPUT  cSCMObjectName
                                ,INPUT  "PCODE":U
                                ,INPUT  gsc_object_type.object_type_code
                                ,INPUT  ttObject.cProductModule
                                ,INPUT  gsc_object_type.object_type_code
                                ,INPUT  "00000"
                                ,INPUT  gsc_object.object_description
                                ,INPUT  "":U           /* options */
                                ,INPUT  piTask
                                ,INPUT  NO             /* no UI */
                                ,INPUT  "central":U    /* share status to use */
                                ,INPUT  YES            /* create physical file on disk */
                                ,INPUT  "":U           /* physical file template */
                                ,OUTPUT iRecid
                                ,OUTPUT cError
                                ).

      IF cError <> ""
      THEN DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = cSCMObjectName
          ttError.cError      = cSCMObjectName + " ":U + cError
          pcError             = "ERROR".
        NEXT object-loop.
      END.
    END.
    ELSE
    IF NOT lWorkspaceCheckedOut1
    THEN DO:
      RUN scmCheckoutObjectControl IN ghScmTool
                                  (INPUT "patch":U
                                  ,INPUT ttObject.cProductModule
                                  ,INPUT "PCODE":U
                                  ,INPUT cSCMObjectName
                                  ,INPUT piTask
                                  ,INPUT NO
                                  ,INPUT NO
                                  ,INPUT NO
                                  ,OUTPUT iRecid
                                  ,OUTPUT cError
                                  ).

      IF cError <> ""
      THEN DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = cSCMObjectName
          ttError.cError      = cSCMObjectName + " ":U + cError
          pcError             = "ERROR".
        NEXT object-loop.
      END.
    END.

  END.  /* object-loop */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dumpXMLforObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpXMLforObjects Procedure 
PROCEDURE dumpXMLforObjects :
/*------------------------------------------------------------------------------
  Purpose:     To dump XML data into .ado file for selected objects
  Parameters:  input temp-table of objects to dump data for
               output error message
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER TABLE       FOR ttObject.
  DEFINE INPUT-OUTPUT PARAMETER TABLE       FOR ttError.
  DEFINE       OUTPUT PARAMETER pcError     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDatasetCode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootDir                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLFileName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLRelativeName          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  object-loop:
  FOR EACH ttObject:

    ASSIGN
      hTable01      = ?
      hTable02      = ?
      cRootDir      = "":U
      cRelativePath = "":U
      .

    ASSIGN
      cDataSetCode = "RYCSO":U.

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = ttObject.cProductModule
      NO-ERROR.

    IF VALID-HANDLE(ghScmTool)
    THEN
      RUN scmGetWorkspaceRoot IN ghScmTool
                             (INPUT ttObject.cWorkspace
                             ,OUTPUT cRootDir).
    IF cRootDir <> "":U
    THEN
      ASSIGN
        cRootDir = cRootDir + "/":U.

    IF VALID-HANDLE(ghScmTool)
    AND AVAILABLE gsc_product_module
    THEN
      RUN scmGetModuleDir IN ghScmTool
                         (INPUT gsc_product_module.product_module_code
                         ,OUTPUT cRelativePath).
    IF cRelativePath = "":U
    AND AVAILABLE gsc_product_module
    THEN
      ASSIGN
        cRelativePath = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"/":U),"/":U).
    IF cRelativePath <> "":U
    THEN
      ASSIGN
        cRelativePath = cRelativePath + "/":U.

    ASSIGN
      cXMLFileName = ttObject.cObjectName.
    RUN scmADOExtReplace IN ghScmTool
                        (INPUT-OUTPUT cXMLFileName).
    ASSIGN
      cXMLRelativeName = cRelativePath + cXMLFileName.

    {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                      &IProc = 'writeDeploymentDataset'
                      &PList = "( INPUT cDataSetCode,~
                                  INPUT REPLACE(ttObject.cObjectName,'.ado':U,'':U),~
                                  INPUT cXMLRelativeName,~
                                  INPUT cRootDir,~
                                  INPUT YES,~
                                  INPUT YES,~
                                  INPUT TABLE-HANDLE hTable01,~
                                  INPUT TABLE-HANDLE hTable02,~
                                  OUTPUT pcError)"
                      &OnApp = 'no'
                      &Autokill = YES}

    IF pcError <> "":U
    THEN DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cXMLFileName
        ttError.cError      = pcError
        pcError             = "ERROR"
        .
      LEAVE object-loop.
    END.

  END. /* object loop */

  ERROR-STATUS:ERROR = NO.
  RETURN.

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

&IF DEFINED(EXCLUDE-loadXMLForObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadXMLForObjects Procedure 
PROCEDURE loadXMLForObjects :
/*------------------------------------------------------------------------------
  Purpose:     To load repository data from XML .ado file for selected objects
  Parameters:  input temp-table of objects to load data for
               output error message
  Notes:       This is the equivalent of assigning an object version into the
               repository. It uses the data in the .ado file and reloads it
               as the current version. If a new version of the object is required,
               the object should have been checked out prior to doing the load.
------------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER TABLE       FOR ttObject.
  DEFINE INPUT-OUTPUT PARAMETER TABLE       FOR ttError.
  DEFINE       OUTPUT PARAMETER pcError     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRootDir                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLFileName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLRelativeName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLFullName              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  object-loop:
  FOR EACH ttObject:

    ASSIGN
      hTable01      = ?
      hTable02      = ?
      cRootDir      = "":U
      cRelativePath = "":U
      .

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = ttObject.cProductModule
      NO-ERROR.

    IF VALID-HANDLE(ghScmTool)
    THEN
      RUN scmGetWorkspaceRoot IN ghScmTool
                             (INPUT ttObject.cWorkspace
                             ,OUTPUT cRootDir).
    IF cRootDir <> "":U
    THEN
      ASSIGN
        cRootDir = cRootDir + "/":U.

    IF VALID-HANDLE(ghScmTool)
    AND AVAILABLE gsc_product_module
    THEN
      RUN scmGetModuleDir IN ghScmTool
                         (INPUT gsc_product_module.product_module_code
                         ,OUTPUT cRelativePath).
    IF cRelativePath = "":U
    AND AVAILABLE gsc_product_module
    THEN
      ASSIGN
        cRelativePath = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"/":U),"/":U).
    IF cRelativePath <> "":U
    THEN
      ASSIGN
        cRelativePath = cRelativePath + "/":U.

    ASSIGN
      cXMLFileName = ttObject.cObjectName.
    RUN scmADOExtReplace IN ghScmTool
                        (INPUT-OUTPUT cXMLFileName).
    ASSIGN
      cXMLRelativeName = cRelativePath + cXMLFileName
      cXMLFullName     = cRootDir      + cXMLRelativeName.

    IF SEARCH(cXMLFullName) <> ?
    THEN DO:
      FILE-INFO:FILE-NAME = cXMLFullName.
      IF FILE-INFO:FILE-SIZE > 0
      THEN DO:

        /* recreate the actual data for this item version - from the XML file */
        {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                          &IProc = 'importDeploymentDataset'
                          &PList = "( INPUT cXMLRelativeName,~
                                      INPUT cRootDir,~
                                      INPUT '':U,~
                                      INPUT YES,~
                                      INPUT YES,~
                                      INPUT NO,~
                                      INPUT TABLE-HANDLE hTable01,~
                                      INPUT TABLE-HANDLE hTable02,~
                                      OUTPUT pcError)"
                          &OnApp = 'no'
                          &Autokill = YES}
        IF pcError <> "":U
        THEN DO:
          CREATE ttError.
          ASSIGN
            ttError.cObjectName = cXMLFileName
            ttError.cError      = pcError
            pcError             = "ERROR"
            .
          LEAVE object-loop.
        END.

      END.
    END.

  END. /* object loop */

  ERROR-STATUS:ERROR = NO.
  RETURN.

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

  ASSIGN
    cDescription = "Repository XML PLIP".

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

  /* Start SCM Integration PLIP */
  IF CONNECTED("RTB":U)
  THEN DO:
    {af/sup2/afrun2.i &PLIP = 'rtb/prc/afrtbprocp.p'
                      &IProc = ''
                      &OnApp = 'no'
                      &Autokill = NO}
    ASSIGN ghScmTool = hPlip.  
  END.
  
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

  IF VALID-HANDLE(ghScmTool)
  THEN RUN killPlip IN ghScmTool.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-synchRVData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchRVData Procedure 
PROCEDURE synchRVData :
/*------------------------------------------------------------------------------
  Purpose:     Synchronise Dynamics with SCM Tool using repository objects
  Parameters:  input temp-table of repository objects to fix
               output error temp-table and message
  Notes:       Called from XML dump/load procedures if selected
               For passed in objects, looks at SCM tool objects and synch
               Dynamics data with data in SCM tool.
               If object does not exist in RTB or not in Dynamics repository :
               a) Create object in the correct repository.
               If object IS NOT checked out in RTB:
               a) checkout record in RTB
               If object IS checked out in RTB:
               a) ensures product module on smartobject matches RTB product module

               /* OBJ-DEPENDENCY */
               PM 01/25/2002  Removed the repository object dependency
                              Warning if ryc_smartobject and gsc_object does not exist.
                              Should either or exist ? Update of product module has been made optional as well.

------------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER TABLE       FOR ttObject.
  DEFINE INPUT-OUTPUT PARAMETER TABLE       FOR ttError.
  DEFINE       OUTPUT PARAMETER pcError     AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bryc_smartobject              FOR ryc_smartobject.

  DEFINE VARIABLE dRTBModuleObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCurrentModuleObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cConfigurationType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFileName             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectExists               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjectExistsInWorkspace    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersionInWorkspace         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cModuleInWorkspace          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCheckedOutInWorkspace      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersionTaskNumber          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iHighestVersion             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectSummary              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectDescription          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectUpdNotes             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectPrevVersions         AS CHARACTER  NO-UNDO.

  ASSIGN
    cConfigurationType  = "RYCSO":U.

  object-loop:
  FOR EACH ttObject NO-LOCK
    BREAK BY ttObject.cWorkspace
          BY ttObject.cProductModule
          BY ttObject.cObjectName
    :

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = ttObject.cProductModule
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
      IF FIRST-OF(ttObject.cProductModule)
      THEN DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = "":U
          ttError.cError      = "Product module (" + TRIM(ttObject.cProductModule) + ") does not exist."
                              + " Integrity fix canceled for all objects in this product module."
          pcError             = "ERROR"
          .
      END.
      NEXT object-loop.
    END.

    /* see if object in repository table ryc_smartobject and if not, we can not do anything */
    /* OBJ-DEPENDENCY */
    /* Could this not just be gsc_object ? Does all SCM object have to exist as either ryc_smartobject or gsc_object
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = ttObject.cObjectName
      NO-ERROR.
    IF NOT AVAILABLE ryc_smartobject
    THEN NEXT object-loop.
    */

    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = ttObject.cObjectName
      NO-ERROR.
    IF NOT AVAILABLE ryc_smartobject
    THEN
    FIND FIRST gsc_object NO-LOCK
      WHERE gsc_object.object_filename = ttObject.cObjectName
      NO-ERROR.
    /*
    IF NOT AVAILABLE gsc_object
    THEN DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = "":U
        ttError.cError      = "Warning: Object (" + TRIM(ttObject.cObjectName) + ") does not exist in ICF Repository."
        pcError             = "ERROR"
        .
    END.
    */

    ASSIGN
      dCurrentModuleObj = gsc_product_module.product_module_obj
      cObjectFileName   = ttObject.cObjectName
      .

    /* get scm info to synch with */
    IF VALID-HANDLE(ghScmTool)
    THEN DO:

      RUN scmADOExtAdd      IN ghScmTool
                           (INPUT-OUTPUT cObjectFileName
                           ).

      RUN scmFullObjectInfo IN ghScmTool
                           (INPUT  cObjectFileName
                           ,INPUT  ttObject.cWorkspace
                           ,INPUT  0
                           ,OUTPUT lObjectExists
                           ,OUTPUT lObjectExistsInWorkspace
                           ,OUTPUT iVersionInWorkspace
                           ,OUTPUT cModuleInWorkspace
                           ,OUTPUT lCheckedOutInWorkspace
                           ,OUTPUT iVersionTaskNumber
                           ,OUTPUT iHighestVersion
                           ,OUTPUT cObjectSummary
                           ,OUTPUT cObjectDescription
                           ,OUTPUT cObjectUpdNotes
                           ,OUTPUT cObjectPrevVersions
                           ).

    END.

    /* Use RTB product module if object exists in RTB in workspace */
    IF lObjectExistsInWorkspace
    THEN DO:
      FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.product_module_code = cModuleInWorkspace
        NO-ERROR.
      IF NOT AVAILABLE gsc_product_module
      THEN DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = ttObject.cObjectName
          ttError.cError      = "RTB Product module (" + TRIM(cModuleInWorkspace) + ")does not exist in ICFDB."
          pcError             = "ERROR"
          .
        NEXT object-loop.
      END.
      ASSIGN
        dRTBModuleObj = gsc_product_module.product_module_obj.
    END.
    ELSE
      ASSIGN
        dRTBModuleObj = dCurrentModuleObj.

    TrnBlock:
    DO FOR bryc_smartobject TRANSACTION ON ERROR UNDO TrnBlock, LEAVE TrnBlock
    :

      /* If object does not exist in RTB, can't do much more */
      IF NOT lObjectExists
      THEN NEXT object-loop.

      /* workspace checkouts now ok, if checked out, fix product module on smartobject */
      IF lCheckedOutInWorkspace
      THEN DO:

        IF AVAILABLE ryc_smartobject /* OBJ-DEPENDENCY */ /* Added */
        AND dRTBModuleObj <> ryc_smartobject.product_module_obj
        THEN DO:
          FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
            WHERE bryc_smartobject.object_filename = ttObject.cObjectName
            NO-ERROR.
          ASSIGN
            bryc_smartobject.product_module_obj = dRTBModuleObj.
          VALIDATE bryc_smartobject NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U
          THEN DO:
              CREATE ttError.
              ASSIGN
                ttError.cObjectName = ttObject.cObjectName
                ttError.cError      = cMessageList
                pcError             = "ERROR"
                .
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
        END.

      END.

    END. /* TrnBlock */

    IF ERROR-STATUS:ERROR
    THEN DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = ttObject.cObjectName
        ttError.cError      = "Error occured in integrity fix for object " + TRIM(ttObject.cObjectName)
        pcError             = "ERROR"
        .
    END.

  END. /* EACH ttSmartobject*/

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

