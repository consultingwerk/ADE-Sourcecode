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

  (v:010001)    Task:          11   UserRef:    
                Date:   02/10/2003  Author:     Thomas Hansen

  Update Notes: Issue 7098: Error 129 using XML export tool
                Added call to setFileDetails in the XML API to make sure the 
                directories for the .ado files exists - before writing the .ado 
                file.

  (v:010002)    Task:          18   UserRef:    
                Date:   02/16/2003  Author:     Thomas Hansen

  Update Notes: Fix path issues with non -scm code

  (v:020000)    Task:          30   UserRef:    
                Date:   03/24/2003  Author:     Thomas Hansen

  Update Notes: Issue 6121 : XML Export creates .w with XML contentent
                
                - Added check to see if file parts are missing - if they are, warn the user and cancel export of object.

  (v:030000)    Task:          49   UserRef:    
                Date:   06/15/2003  Author:     Thomas Hansen

  Update Notes: Issue xxx:
                Updated with changes to scmGetModuleDir API.

  (v:030001)    Task:          49   UserRef:    
                Date:   07/01/2003  Author:     Thomas Hansen

  Update Notes: Issue 11566:
                Fixed issues with RTB site number different from 000.

------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryxmlplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    030001

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName                         AS CHARACTER    NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{af/sup2/afrun2.i &Define-only = YES}

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
{rtb/inc/afrtbglobs.i}

DEFINE VARIABLE ghScmTool                           AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghGscddXml                          AS HANDLE       NO-UNDO.

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
             cError.

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
         HEIGHT             = 23.91
         WIDTH              = 64.6.
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

  DEFINE INPUT        PARAMETER TABLE         FOR ttObject.
  DEFINE INPUT        PARAMETER piTask        AS INTEGER    NO-UNDO.
  DEFINE INPUT        PARAMETER plCreateFile  AS LOGICAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER TABLE         FOR ttError.
  DEFINE       OUTPUT PARAMETER pcError       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cError                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSCMObjectName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExistsInRtb1               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExistsInWorkspace1         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iWorkspaceVersion1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lWorkspaceCheckedOut1       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersionTaskNumber1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLatestVersion1             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRecid                      AS RECID      NO-UNDO.

  DEFINE VARIABLE cTempObjectName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectExt              AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cProductModuleCode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmProductModuleCode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dproductModuleObj           AS DECIMAL    NO-UNDO.
  
  object-loop:
  FOR EACH ttObject:

    /* Determine correct object filename */
    ASSIGN
      cTempObjectName  = ttObject.cObjectName
      cTempObjectExt   = "":U.

    IF NUM-ENTRIES(ttObject.cObjectName,".":U) > 1 THEN
      ASSIGN
        cTempObjectExt  = ENTRY(NUM-ENTRIES(ttObject.cObjectName,".":U),ttObject.cObjectName,".":U)
        cTempObjectName = REPLACE(cTempObjectName,"." + cTempObjectExt,"":U).
        
    /* As we have the object_filename from the ryc_smartobject table when the */
    /* ttObject temp-table was built, we should be able to find the object    */
    /* directly with the cObjectName field                                    */       
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = ttObject.cObjectName
      NO-ERROR.
      
    IF NOT AVAILABLE ryc_smartobject THEN        
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename  = cTempObjectName
      AND   ryc_smartobject.object_extension = cTempObjectExt
      NO-ERROR.
      
    IF NOT AVAILABLE ryc_smartobject THEN
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename
          + (IF ryc_smartobject.object_extension <> "" THEN "." ELSE "")
          + ryc_smartobject.object_extension
          = ttObject.cObjectName
      NO-ERROR.

    IF AVAILABLE ryc_smartobject THEN 
    DO:
      ASSIGN
        cSCMObjectName = ryc_smartobject.object_filename
                       + (IF ryc_smartobject.object_extension <> "" THEN "." ELSE "")
                       + ryc_smartobject.object_extension.

      FIND FIRST gsc_object_type NO-LOCK
        WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj
        NO-ERROR.
        
      IF NOT AVAILABLE gsc_object_type THEN 
      DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = cSCMObjectName
          ttError.cError      = cSCMObjectName +  " Object type does not exist in ICFDB database"
          pcError             = "ERROR".
        NEXT object-loop.
      END. /*IF NOT AVAILABLE gsc_object_type ... */
    END. /*IF AVAILABLE ryc_smartobject ... */
    ELSE 
    DO:
      ASSIGN cSCMObjectName = ttObject.cObjectName.
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName +  " does not exist in ICFDB database"
        pcError             = "ERROR".
      NEXT object-loop.
    END.

    RUN scmADOExtAdd IN ghScmTool (INPUT-OUTPUT cSCMObjectName).

    RUN scmObjectExists IN ghScmTool
                       (INPUT  cSCMObjectName,
                        INPUT  ttObject.cWorkspace,
                        OUTPUT lExistsInRtb1,
                        OUTPUT lExistsInWorkspace1,
                        OUTPUT iWorkspaceVersion1,
                        OUTPUT lWorkspaceCheckedOut1,
                        OUTPUT iVersionTaskNumber1,
                        OUTPUT iLatestVersion1).

    IF NOT lExistsInWorkspace1 AND 
           lExistsinRtb1 THEN 
    DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName +  " exists in SCM Tool, but not in the selected workspace"
        pcError             = "ERROR".
      NEXT object-loop.
    END.
    IF lExistsInWorkspace1 AND 
       lWorkspaceCheckedOut1 AND 
       piTask <> iVersionTaskNumber1 THEN 
    DO:
      CREATE ttError.
      ASSIGN
        ttError.cObjectName = cSCMObjectName
        ttError.cError      = cSCMObjectName + " Object is checked out already in a different task"
        pcError             = "ERROR".
      NEXT object-loop.
    END.

    IF NOT lExistsInWorkspace1 THEN 
    DO:
      /* Check to see which product module in the SCM tool we should be creating this object in.  */
      IF ttObject.cProductModule <> "":U THEN    
      DO:
        RUN scmCreateObjectControl IN ghScmTool
                                  (INPUT  cSCMObjectName,
                                   INPUT  "PCODE":U,
                                   INPUT  gsc_object_type.object_type_code,
                                   INPUT  ttObject.cProductModule,
                                   INPUT  gsc_object_type.object_type_code,
                                   INPUT  "00000",
                                   INPUT  ryc_smartobject.object_description,
                                   INPUT  "":U,           /* options */
                                   INPUT  piTask,
                                   INPUT  NO,             /* no UI */
                                   INPUT  "central":U,    /* share status to use */
                                   INPUT  plCreateFile,   /* create physical file on disk */
                                   INPUT  "":U,           /* physical file template */
                                   OUTPUT iRecid,
                                   OUTPUT cError).
        IF cError <> "" THEN 
        DO:
          CREATE ttError.
          ASSIGN
            ttError.cObjectName = cSCMObjectName
            ttError.cError      = cSCMObjectName + " ":U + cError
            pcError             = "ERROR".
          NEXT object-loop.
        END.
      END.
    END.
    ELSE
    IF NOT lWorkspaceCheckedOut1 THEN 
    DO:
      IF ttObject.cProductModule NE "":U THEN
      DO:
        RUN scmGetScmXref IN ghScmTool (INPUT "RTB":U, 
                            INPUT "GSCPM":U,
                            INPUT ttObject.cProductModule, 
                            INPUT 0,
                            OUTPUT cScmProductModuleCode, 
                            OUTPUT cError).     
                          
        IF cScmProductModuleCode = "":U THEN
        DO:
          cError = "SCM Product module for " + ttObject.cProductModule + " not found in Xref table":U.
          RETURN.  
        END.
        ELSE
        /* Add the site prefix so that we are using the correct product module in RTB, which 
          requires prefixes to be used */
        RUN scmSitePrefixAdd IN ghScmTool (INPUT-OUTPUT cScmProductModuleCode).                 
      END.          
      
      RUN scmCheckoutObjectControl IN ghScmTool
                                  (INPUT "patch":U,
                                   INPUT cScmProductModuleCode,
                                   INPUT "PCODE":U,
                                   INPUT cSCMObjectName,
                                   INPUT piTask,
                                   INPUT NO,
                                   INPUT NO,
                                   INPUT NO,
                                   OUTPUT iRecid,
                                   OUTPUT cError).
      IF cError <> "":U THEN 
      DO:
        CREATE ttError.
        ASSIGN
          ttError.cObjectName = cSCMObjectName
          ttError.cError      = cSCMObjectName + " ":U + cError
          pcError             = "ERROR".
        NEXT object-loop.
      END.
    END. /* IF NOT lWorkspaceCheckedOut1 ...  */
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

  DEFINE VARIABLE cScmObjectName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSmartObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectExt            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectSubType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lScmObjectMissing         AS LOGICAL    NO-UNDO.  

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(ghScmTool) THEN 
    RETURN ERROR "SCM Tool handle not valid!".  
  
  object-loop:
  FOR EACH ttObject:

    ASSIGN
      hTable01      = ?
      hTable02      = ?
      cRootDir      = "":U
      cRelativePath = "":U
      lScmObjectMissing = NO
      pcError = "".

    ASSIGN cDataSetCode = "RYCSO":U.

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = ttObject.cProductModule
      NO-ERROR.

    IF VALID-HANDLE(ghScmTool) THEN
      RUN scmGetWorkspaceRoot IN ghScmTool 
                             (INPUT ttObject.cWorkspace,
                              OUTPUT cRootDir).
    IF cRootDir <> "":U THEN
      ASSIGN cRootDir = cRootDir + "/":U.

    IF VALID-HANDLE(ghScmTool)
    AND AVAILABLE gsc_product_module THEN
      RUN scmGetModuleDir IN ghScmTool
                         (INPUT gsc_product_module.product_module_code,
                          INPUT "":U,
                          OUTPUT cRelativePath).
                          
    IF cRelativePath = "":U
    AND AVAILABLE gsc_product_module THEN
      ASSIGN cRelativePath = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"/":U),"/":U).
    IF cRelativePath <> "":U THEN
      ASSIGN cRelativePath = cRelativePath + "/":U.
        
    ASSIGN cXMLFileName = ttObject.cObjectName.
    IF VALID-HANDLE(ghScmTool) THEN
    RUN scmADOExtReplace IN ghScmTool (INPUT-OUTPUT cXMLFileName).
    ASSIGN cXMLRelativeName = cRelativePath + cXMLFileName.

    /* Determine correct object filename */
    ASSIGN
      cTempObjectName  = ttObject.cObjectName
      cTempObjectExt   = "":U.

    /* Only if there is an extension and it is longer than 2 characters do we want to strip it down - 
       otherwise we will run into problems with datafields being exported*/
    IF NUM-ENTRIES(ttObject.cObjectName,".":U) > 1 AND 
       LENGTH(ENTRY(2, ttObject.cObjectName, ".":U)) <= 2 THEN
      ASSIGN
        cTempObjectExt  = ENTRY(NUM-ENTRIES(ttObject.cObjectName,".":U),ttObject.cObjectName,".":U)
        cTempObjectName = REPLACE(cTempObjectName,"." + cTempObjectExt,"":U).

    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename  = cTempObjectName
      AND   ryc_smartobject.object_extension = cTempObjectExt
      NO-ERROR.
      
    IF NOT AVAILABLE ryc_smartobject THEN
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename  = cTempObjectName
      NO-ERROR.
      
    IF NOT AVAILABLE ryc_smartobject THEN
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename
          + (IF ryc_smartobject.object_extension <> "" THEN "." ELSE "")
          + ryc_smartobject.object_extension
          = ttObject.cObjectName
      NO-ERROR.
      
    IF NOT AVAILABLE ryc_smartobject THEN
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = ttObject.cObjectName
      NO-ERROR.

    IF AVAILABLE ryc_smartobject THEN
      ASSIGN
        cScmObjectName   = ryc_smartobject.object_filename
                         + (IF ryc_smartobject.object_extension <> "" THEN "." ELSE "")
                         + ryc_smartobject.object_extension
        cSmartObjectName = ryc_smartobject.object_filename.
    ELSE
      ASSIGN
        cScmObjectName   = ttObject.cObjectName
        cSmartObjectName = "":U.

    RUN scmADOExtAdd IN ghScmTool
                    (INPUT-OUTPUT cScmObjectName).
    
    RUN scmObjectSubType IN ghScmTool
                        (INPUT  ttObject.cWorkspace,
                         INPUT  cScmObjectName,
                         OUTPUT cObjectSubType).

    IF LOOKUP(cObjectSubType,"LSmartObject,DataDump":U) > 0
    AND cSmartObjectName = "":U THEN 
      RETURN.

    IF cSmartObjectName = "":U THEN
      ASSIGN cSmartObjectName = ttObject.cObjectName.

    ASSIGN cSmartObjectName = REPLACE(cSmartObjectName,".ado":U,"":U).
    /* Determine correct object filename */
    
    /* If the cXMLFileName and cScmObjectName are different, then we 
       need to check if the object file exists on disk. If it doesn't
       there is something wrong and we need to raise an error. */
    IF cXMLFileName <> cScmObjectName THEN
    DO:
      FILE-INFO:FILE-NAME = cRelativePath + cScmObjectName.
      IF FILE-INFO:FULL-PATHNAME = "":U OR
         FILE-INFO:FULL-PATHNAME = ? THEN
      ASSIGN
        pcError = "The object file " + cRelativePath + cScmObjectName + " could not be found." + "~n":U + "~n":U +  
                  "XML Export of object " + cSmartObjectName + " aborted!"
        lScmObjectMissing = YES.
    END.
    
    IF NOT lScmObjectMissing THEN
    DO:
      /* Make sure that the directory structure the .ado file is to be written to exists. */    
      IF NOT VALID-HANDLE(ghGscddXml) THEN DO:
        {launch.i &PLIP = 'af/app/gscddxmlp.p'
                          &IProc = ''
                          &OnApp = 'no'
                          &Autokill = NO} 
                          
        ASSIGN ghGscddXml = hPlip.    
      END.                       
  
      IF VALID-HANDLE(ghGscddXml) THEN 
        cXMLRelativeName = DYNAMIC-FUNCTION('setFileDetails':U IN ghGscddXml, INPUT cXMLRelativeName, INPUT cRootDir, INPUT cRootDir, OUTPUT cRootDir).
      
      {launch.i &PLIP = 'af/app/gscddxmlp.p'
                        &IProc = 'writeDeploymentDataset'
                        &PList = "( INPUT cDataSetCode,~
                                    INPUT cSmartObjectName,~
                                    INPUT cXMLRelativeName,~
                                    INPUT cRootDir,~
                                    INPUT YES,~
                                    INPUT YES,~
                                    INPUT TABLE-HANDLE hTable01,~
                                    INPUT TABLE-HANDLE hTable02,~
                                    OUTPUT pcError)"
                        &OnApp = 'no'
                        &Autokill = NO}    
    END.

    IF pcError <> "":U THEN 
    DO:
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

  DEFINE VARIABLE cSmartObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectExt            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectSubType            AS CHARACTER  NO-UNDO.

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
                             (INPUT ttObject.cWorkspace,
                              OUTPUT cRootDir).
    IF cRootDir <> "":U
    THEN
      ASSIGN
        cRootDir = cRootDir + "/":U.

    IF VALID-HANDLE(ghScmTool)
    AND AVAILABLE gsc_product_module
    THEN
      RUN scmGetModuleDir IN ghScmTool
                         (INPUT gsc_product_module.product_module_code,
                          INPUT "":U,
                          OUTPUT cRelativePath).
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
                          &Autokill = NO}
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

  ASSIGN 
    ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR
    .
  
  {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                    &IProc = ''
                    &OnApp = 'no'
                    &Autokill = NO}
  ASSIGN
    ghGscddXml = hPlip.

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
  IF VALID-HANDLE(ghGscddXml)
  THEN
    RUN killPlip IN ghGscddXml.

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
                              Warning if ryc_smartobject and ryc_smartobject does not exist.
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
    /* Could this not just be ryc_smartobject ? Does all SCM object have to exist as either ryc_smartobject or ryc_smartobject
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
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = ttObject.cObjectName
      NO-ERROR.
    /*
    IF NOT AVAILABLE ryc_smartobject
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

      RUN scmADOExtAdd IN ghScmTool (INPUT-OUTPUT cObjectFileName).

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

