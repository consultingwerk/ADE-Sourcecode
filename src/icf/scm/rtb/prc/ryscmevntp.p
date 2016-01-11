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
  File: ryscmevntp.p

  Description:  

  Purpose:

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000021   UserRef:    
                Date:   02/15/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

  (v:010001)    Task:    90000024   UserRef:    
                Date:   02/20/2002  Author:     Dynamics Admin User

  Update Notes: 

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryscmevntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{launch.i &Define-only = YES}

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
         HEIGHT             = 18.29
         WIDTH              = 68.6.
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

&IF DEFINED(EXCLUDE-createProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProductModule Procedure 
PROCEDURE createProductModule :
/*------------------------------------------------------------------------------
  Purpose:     To create a new product module
  Parameters:  input product module code
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcModule             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProductCode                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductDesc                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDesc                 AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsc_product                  FOR gsc_product.
  DEFINE BUFFER bgsc_product_module           FOR gsc_product_module.

  RUN scmGetModuleDetails (INPUT  pcModule
                          ,OUTPUT cProductCode
                          ,OUTPUT cProductDesc
                          ,OUTPUT cModuleDesc
                          ).

  IF cModuleDesc = "":U
  THEN
    ASSIGN
      cModuleDesc = pcModule.
  IF cProductCode = "":U
  AND LENGTH(pcModule) > 2
  THEN
    ASSIGN
      cProductCode = SUBSTRING(pcModule,1,2).
  IF cProductDesc = "":U
  THEN
    ASSIGN
      cProductDesc = cProductCode.

  DO FOR bgsc_product_module, bgsc_product:

    FIND FIRST bgsc_product NO-LOCK
      WHERE bgsc_product.product_code = cProductCode
      NO-ERROR.
    IF NOT AVAILABLE bgsc_product
    THEN DO:
      CREATE bgsc_product NO-ERROR.
      ASSIGN
        bgsc_product.product_code         = cProductCode
        bgsc_product.product_description  = cProductDesc
        .
      VALIDATE bgsc_product NO-ERROR.      
    END.

    CREATE bgsc_product_module NO-ERROR.
    ASSIGN
      bgsc_product_module.product_obj                 = bgsc_product.product_obj
      bgsc_product_module.product_module_code         = pcModule
      bgsc_product_module.product_module_description  = cModuleDesc
      .    
    VALIDATE bgsc_product_module NO-ERROR.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableAssignReplication) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableAssignReplication Procedure 
PROCEDURE disableAssignReplication :
/*------------------------------------------------------------------------------
  Purpose:     To create a record in the assignment action under table indicating
               that an assignment of data for this data item is in progress, and
               therefore ensuring that replication triggers do not fire to create
               a version history of this.
  Parameters:  input action table FLA
               input action scm object name
               output rowid of created record
               output error message text if any
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_scm_object_name        AS CHARACTER  NO-UNDO.

  RUN setActionUnderway IN gshSessionManager
                       (INPUT "SCM":U
                       ,INPUT "ASS":U
                       ,INPUT STRING(ip_scm_object_name)
                       ,INPUT "RYCSO":U
                       ,INPUT "":U
                       ).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableAssignReplication) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableAssignReplication Procedure 
PROCEDURE enableAssignReplication :
/*------------------------------------------------------------------------------
  Purpose:     To remove an action underway record which was created during
               the assignment of data into a workspace by the
               disableAssignReplication procedure.
  Parameters:  input rowid of action underway table
  Notes:       Ignore any errors if this does not exist anymore.
               Also, the deletion really can not fail in anyway so this code
               does not contain standard error handling, etc.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_scm_object_name        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lDeletionUnderway                 AS LOGICAL    NO-UNDO.

  RUN getActionUnderway IN gshSessionManager
                       (INPUT "SCM":U
                       ,INPUT "ASS":U
                       ,INPUT STRING(ip_scm_object_name)
                       ,INPUT "RYCSO":U
                       ,INPUT "":U
                       ,INPUT  YES
                       ,OUTPUT lDeletionUnderway).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getXMLFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLFilename Procedure 
PROCEDURE getXMLFilename :
/*------------------------------------------------------------------------------
  Purpose:     To return full filename for XML file if it exists in
               current workspace, else returns an empty string, plus return
               relative xml filename.
  Parameters:  input product module object number
               input object name with no path
               output relative path to XML Filename
               output full path to xml file if found
  Notes:       XML File must exist in the propath to get its full path.
               Assumes .ado extension for xml file.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pdProductModule   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRelativeXMLFile AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFullXMLFile     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.

  ASSIGN
    cRelativePath = "":U.

  RUN scmGetModuleDir (INPUT pdProductModule
                      ,OUTPUT cRelativePath
                      ).

  IF cRelativePath <> "":U
  THEN
    ASSIGN cRelativePath = cRelativePath + "/":U.

  ASSIGN
    pcRelativeXMLFile = pcObjectName.
  RUN scmADOExtReplace (INPUT-OUTPUT pcRelativeXMLFile).
  RUN scmADOExtAdd (INPUT-OUTPUT pcRelativeXMLFile).
  ASSIGN
    pcRelativeXMLFile = cRelativePath + pcRelativeXMLFile.

  ASSIGN
    pcFullXMLFile = SEARCH(pcRelativeXMLFile).

  IF pcFullXMLFile = ?
  THEN DO:

    ASSIGN
      pcFullXMLFile = "":U.

  END.
  ELSE DO:

    /* Added check yo ensure file is not 0 size */
    FILE-INFO:FILENAME = pcFullXMLFile.
    IF FILE-INFO:FILE-SIZE = 0
    THEN
      ASSIGN
        pcFullXMLFile = "":U.
    ELSE
      ASSIGN
        pcFullXMLFile = REPLACE(pcFullXMLFile,"~\":U,"~/":U).

  END.

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
    cDescription = "Dynamics Versioning Utility PLIP".

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

  /* If SCM database is connected, start SCM Integration PLIP */
  IF CONNECTED("RTB":U)
  THEN DO:

    DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

    ASSIGN
      cProcName   = "rtb/prc/afrtbprocp.p":U
      hProcHandle = SESSION:FIRST-PROCEDURE.

  /* handle:FILE-NAME    = "rtb/prc/afrtbprocp.p":U */
  /* handle:PRIVATE-DATA = "afrtbprocp.p":U         */
    DO WHILE VALID-HANDLE(hProcHandle)
    AND hProcHandle:FILE-NAME <> cProcName
    :
      hProcHandle = hProcHandle:NEXT-SIBLING.
    END.

    IF NOT VALID-HANDLE(hProcHandle)
    THEN
      RUN VALUE(cProcName) PERSISTENT SET hProcHandle.

    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProcHandle, SEARCH-TARGET).

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

  DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hValidHanldles              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName      = "afrtbprocp.p":U
    hValidHanldles = SESSION:FIRST-PROCEDURE.

  /* handle:FILE-NAME    = "rtb/prc/afrtbprocp.p":U */
  /* handle:PRIVATE-DATA = "afrtbprocp.p":U         */
  DO WHILE VALID-HANDLE(hValidHanldles)
  AND NOT (VALID-HANDLE(hProcHandle))
  :

    IF hValidHanldles:PRIVATE-DATA = cProcName
    THEN
      ASSIGN
        hProcHandle = hValidHanldles.

    ASSIGN
      hValidHanldles = hValidHanldles:NEXT-SIBLING.

  END.

  IF VALID-HANDLE(hProcHandle)
  THEN
    RUN killPlip IN hProcHandle.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookAssignObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookAssignObject Procedure 
PROCEDURE scmHookAssignObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to assign an object in the 
               Dynamics Repository Database that correponds to the object being assigned
               in the SCM tool. Doing this will load the XML file.
               This procedure will be called from the SCM tool just after
               the object is assigned in the SCM Repository. If anything
               fails in this procedure we will have a synchronisation problem.

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being assigned
               input  Object type being assigned
               input  Object product module being assigned into
               input  Object version being assigned
               output Error Message if it failed

  Notes:       All validation was done in before assign hook to try and eliminate
               the chance of this failing.
               The assignment of an object into a workspace, requires that
               we must recreate the data the object relates to in the database,
               using the XML File.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_version       AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRootDirXMLFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  ASSIGN
    hTable01 = ?
    hTable02 = ?
    .

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* get full path to xml file if it exists and relative path */
  RUN getXMLFilename (INPUT  ip_product_module
                     ,INPUT  ip_object_name
                     ,OUTPUT cRelativeXMLFile
                     ,OUTPUT cFullXMLFile
                     ).

  ASSIGN
    op_error = "":U.

  IF cFullXMLFile <> "":U
  THEN DO:

    ASSIGN
      cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"").

    /* recreate the actual data for this item version - from the XML file */
    {launch.i &PLIP = 'af/app/gscddxmlp.p'
              &IProc = 'importDeploymentDataset'
              &PList = "(INPUT cRelativeXMLFile~
                        ,INPUT cRootDirXMLFile~
                        ,INPUT '':U~
                        ,INPUT YES~
                        ,INPUT YES~
                        ,INPUT NO~
                        ,INPUT TABLE-HANDLE hTable01~
                        ,INPUT TABLE-HANDLE hTable02~
                        ,OUTPUT op_error )"
              &OnApp = 'no'
              &Autokill = YES}

  END.

  IF op_error <> "":U
  THEN RETURN.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCheckInObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCheckInObject Procedure 
PROCEDURE scmHookCheckInObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to ensure the object in the 
               repository database correponds to the object being checked-in
               in the SCM tool.
               This procedure will be called from the SCM tool just prior to
               the object being checked-in into the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the check in also.

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being checked in
               output Error Message if it failed
  
  Notes:       When a logical object is checked in, we must also generate the .ado xml file
               containing the data source code for the object version.
               If the check in into the SCM tool fails, we will not know, so we
               must warn of errors in this procedure.

               Modified this hook to deal with objects with .ado xml parts that
               do not yet exist in the repository. This would be the case for
               objects loaded externally via a module load for example. In this
               case we must actually use the existing .ado to recreate the
               repository data.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_full_object_name             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectHasDataPart              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lImportedObject                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cConfigurationType              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_continue AS LOGICAL INITIAL NO NO-UNDO.

  DEFINE VARIABLE lSkipObjectDump    AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPDUMP":U
                         ,INPUT  ip_task_number
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lSkipObjectDump).

  ASSIGN
    lv_full_object_name = ip_object_name
    ip_object_name      = REPLACE(ip_object_name,".ado":U,"":U)
    lObjectHasDataPart  = NO
    NO-ERROR.

  RUN scmObjectHasData (INPUT  ip_workspace
                       ,INPUT  lv_full_object_name
                       ,OUTPUT lObjectHasDataPart
                       ,OUTPUT cProductModule
                       ).

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = cProductModule
    NO-ERROR.
  IF NOT AVAILABLE gsc_product_module
  THEN DO:
    ASSIGN
      op_error = "Error checking in object: " + ip_object_name
               + " into workspace: "          + ip_workspace
               + ". Product Module: "         + cProductModule
               + " does not exist in ICFDB database".
    RETURN.
  END.

  /* Item exists in workspace and is checked out, or it is an imported object - check it in */
  ASSIGN
    op_error = "":U.

  /* Generate/update .ado XML File */
  IF lObjectHasDataPart
  AND NOT lSkipObjectDump
  THEN DO:
    RUN updateXMLFile (INPUT  ip_workspace
                      ,INPUT  gsc_product_module.product_module_obj
                      ,INPUT  "RYCSO"
                      ,INPUT  lv_full_object_name
                      ,OUTPUT op_error
                      ).
    IF op_error <> "":U
    THEN RETURN.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCreateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCreateObject Procedure 
PROCEDURE scmHookCreateObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to ensure it is valid to create
               the object in the SCM repository.
               This procedure will be called from the SCM tool just after
               an object has been created in the SCM Repository.
               If anything fails in this procedure, an error message will be returned,
               but the object has already been created in the SCM tool,
               the user must manually fix things.

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being created
               output Error Message if it failed

  Notes:       Objects can only be created in the SCM tool providing a
               corresponding object exists in the repository database in.
               As mentioned above, we can only inform the user of the problem and
               ask them to sort it out as the object creation cannot be cancelled.
               The reason for this is the hook is from the after object add rather
               than before object add, as we do not know whether it is a logical
               object in the before hook (we are not given the subtype).
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lExistsInRtb                    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExistsInWorkspace              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iWorkspaceVersion               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWorkspaceModule                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lWorkspaceCheckedOut            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersioninTask                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLatestVersion                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectSummary                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectDescription              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectUpdNotes                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrevVersions                   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cWorkspaceModuleRTB             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectType                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDir                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrNames                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrValues                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectNumber                   AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hObjApi                         AS HANDLE   NO-UNDO.

  DEFINE VARIABLE lv_full_object_name             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectHasDataPart              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProductModule                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRootDirXMLFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                        AS HANDLE     NO-UNDO.

  ASSIGN
    hTable01 = ?
    hTable02 = ?
    .

  ASSIGN
    lv_full_object_name = ip_object_name
    ip_object_name      = REPLACE(ip_object_name,".ado":U,"":U)
    lObjectHasDataPart  = NO
    NO-ERROR.

  RUN scmFullObjectInfo (INPUT  lv_full_object_name
                        ,INPUT  ip_workspace
                        ,INPUT  ip_task_number
                        ,OUTPUT lExistsInRtb
                        ,OUTPUT lExistsInWorkspace
                        ,OUTPUT iWorkspaceVersion
                        ,OUTPUT cWorkspaceModule
                        ,OUTPUT lWorkspaceCheckedOut
                        ,OUTPUT iVersioninTask
                        ,OUTPUT iLatestVersion
                        ,OUTPUT cObjectSummary
                        ,OUTPUT cObjectDescription
                        ,OUTPUT cObjectUpdNotes
                        ,OUTPUT cPrevVersions
                        ).
  ASSIGN
    cWorkspaceModuleRTB = cWorkspaceModule.
  RUN scmSitePrefixAdd (INPUT-OUTPUT cWorkspaceModuleRTB).
  RUN scmGetModuleDir  (INPUT  cWorkspaceModuleRTB
                       ,OUTPUT cModuleDir
                       ).

  RUN scmObjectSubType (INPUT  ip_workspace
                       ,INPUT  lv_full_object_name
                       ,OUTPUT cObjectType /* Actual SubType and not ObjectType of PCODE */
                       ).

  IF SEARCH("ry/app/ryreposobp.p":U) <> ?
  OR SEARCH("ry/app/ryreposobp.r":U) <> ?
  THEN
    RUN ry/app/ryreposobp.p PERSISTENT SET hObjApi.
  ELSE
    ASSIGN
      hObjApi = ?.

  IF VALID-HANDLE(hObjApi)
  THEN DO:

    ASSIGN
      cAttrNames  = "ObjectPath,StaticObject":U
      cAttrValues = cModuleDir + CHR(3) + "yes":U + CHR(3)
      .

    RUN storeObject IN hObjApi 
                   (INPUT  cObjectType
                   ,INPUT  cWorkspaceModule
                   ,INPUT  ip_object_name
                   ,INPUT  cObjectDescription
                   ,INPUT  cAttrNames
                   ,INPUT  cAttrValues
                   ,OUTPUT dObjectNumber
                   ).

  END.
  ELSE DO:

    ASSIGN
      op_error = "Error deleting object: " + ip_object_name
               + " in workspace: "         + ip_workspace
               + ". The Repository Object Maintenance Procedure (ry/app/ryreposobp.p) could not be launched.".

  END.

  RUN scmObjectHasData (INPUT  ip_workspace
                       ,INPUT  lv_full_object_name
                       ,OUTPUT lObjectHasDataPart
                       ,OUTPUT cProductModule
                       ).

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = cProductModule
    NO-ERROR.

  /* get full path to xml file if it exists and relative path */
  RUN getXMLFilename (INPUT  gsc_product_module.product_module_obj
                     ,INPUT  ip_object_name
                     ,OUTPUT cRelativeXMLFile
                     ,OUTPUT cFullXMLFile
                     ).

  ASSIGN
    op_error = "":U.

  IF cFullXMLFile <> "":U
  THEN DO:

    ASSIGN
      cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"").

    /* recreate the actual data for this item version - from the XML file */
    {launch.i &PLIP = 'af/app/gscddxmlp.p'
              &IProc = 'importDeploymentDataset'
              &PList = "(INPUT cRelativeXMLFile~
                        ,INPUT cRootDirXMLFile~
                        ,INPUT '':U~
                        ,INPUT YES~
                        ,INPUT YES~
                        ,INPUT NO~
                        ,INPUT TABLE-HANDLE hTable01~
                        ,INPUT TABLE-HANDLE hTable02~
                        ,OUTPUT op_error )"
              &OnApp = 'no'
              &Autokill = YES}

  END.

  IF op_error <> "":U
  THEN RETURN.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookDeleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookDeleteObject Procedure 
PROCEDURE scmHookDeleteObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to delete an object from the 
               repository database that correponds to the object being deleted
               in the SCM tool, plus the data the object relates to.
               This procedure will be called from the SCM tool just prior to
               an object being deleted from the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the deletion also.

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being deleted
               output Error Message if it failed
  
  Notes:       The actual data the object relates to must be deleted.
               This is correct as if a checked out object is deleted,
               then it should be as if it never existed.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hRepositoryObject               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFound                          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  IF SEARCH("af/obj2/gscobful2o.w":U) <> ?
  OR SEARCH("af/obj2/gscobful2o.r":U) <> ?
  THEN
    RUN af/obj2/gscobful2o.w PERSISTENT SET hRepositoryObject.
  ELSE
    ASSIGN
      hRepositoryObject = ?.

  IF VALID-HANDLE(hRepositoryObject)
  THEN DO:

    /* Set the SDO RowsToBatch = 1 */
    DYNAMIC-FUNCTION("setRowsToBatch" IN hRepositoryObject, 1) NO-ERROR.

    DYNAMIC-FUNCTION("setRebuildOnRepos" IN hRepositoryObject, "YES") NO-ERROR.

    /* Initialize the SDO for object maintenace */
    RUN initializeObject IN hRepositoryObject NO-ERROR.

    /* Find the record in the SDO for object maintenace */
    lFound = DYNAMIC-FUNCTION('findRowWhere' IN hRepositoryObject , 'object_filename' , ip_object_name, '=' ).

    IF lFound
    THEN DO:
      DYNAMIC-FUNCTION('deleteRow' IN hRepositoryObject , ? ).
      op_error = DYNAMIC-FUNCTION('fetchMessages':U IN hRepositoryObject).
    END.

    RUN destroyObject IN hRepositoryObject.

    IF VALID-HANDLE(hRepositoryObject)
    THEN DELETE OBJECT hRepositoryObject.
    ASSIGN hRepositoryObject = ?.

    IF op_error <> "":U
    THEN RETURN.

  END.
  ELSE DO:

    ASSIGN
      op_error = "Error deleting object: " + ip_object_name
               + " in workspace: "         + ip_workspace
               + ". The Object Maintenance SDO (af/obj2/gscobful2o.w) could not be launched.".

  END.

  IF op_error <> "":U
  THEN RETURN.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookMoveModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookMoveModule Procedure 
PROCEDURE scmHookMoveModule :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to deal with the situation where
               an object is moved to a new product module in the scm tool.
               It is fired from the creat-cv hook, after the object has been fully
               moved to the new module. For this reason, we do not get the
               chance to do anything about the move - i.e. prevent it. 
               
               We do however have a hook from create-cv-before that runs
               hookMoveModuleBefore which performs checks, etc.
               so the chance of something failing should be small.
               The biggest issue would be if the new module did not exist
               - but we could also create it here.

               This hooks is like a check-out hook but with a difference - it also
               changes the product module. After the hook, the new object version in
               the new module will be left checked out.
               
               We should then update the product module on the actual data item
               (without replication triggers).

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being moved
               input  new product module
               input  new version
               output Error Message if it failed
  
  Notes:       See above.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_product_module   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_object_version   AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE BUFFER b_gsc_product_module    FOR gsc_product_module.
  DEFINE BUFFER b_ryc_smartobject       FOR ryc_smartobject.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find the correct existing configuration item for the object being moved, i.e.
     the correct product module and object version */
  FIND FIRST b_ryc_smartobject NO-LOCK
    WHERE b_ryc_smartobject.object_filename = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE b_ryc_smartobject
  THEN DO:
    op_error = "Error moving object: " + ip_object_name
             + " Object does not exist".
  END.

  IF ip_new_product_module <> "":U
  THEN
    RUN scmSitePrefixDel (INPUT-OUTPUT ip_new_product_module).

  /* If new product module not in ICFDB - create it with defaults */
  IF NOT CAN-FIND(FIRST gsc_product_module
                  WHERE gsc_product_module.product_module_code = ip_new_product_module)
  THEN
    RUN createProductModule (INPUT ip_new_product_module).                

  /* Find new product module */
  FIND FIRST b_gsc_product_module NO-LOCK
    WHERE b_gsc_product_module.product_module_code = ip_new_product_module
    NO-ERROR.
  IF NOT AVAILABLE b_gsc_product_module
  THEN DO:
    op_error = "Error moving object: " + ip_object_name
             + ". Product Module: "    + ip_new_product_module
             + " does not exist in ICFDB database".
  END.
  ELSE DO:
    RUN disableAssignReplication (INPUT ip_object_name).

    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
      WHERE ryc_smartobject.object_filename = ip_object_name
      NO-ERROR.
    IF AVAILABLE ryc_smartobject
    THEN
      ASSIGN
        ryc_smartobject.product_module_obj = b_gsc_product_module.product_module_obj.

    FIND FIRST gsc_object EXCLUSIVE-LOCK
      WHERE gsc_object.object_filename = ip_object_name
      NO-ERROR.
    IF AVAILABLE gsc_object
    THEN
      ASSIGN
        gsc_object.product_module_obj = b_gsc_product_module.product_module_obj.

  END.

  RUN enableAssignReplication (INPUT ip_object_name).

  ASSIGN
    op_error = "":U.

  RUN updateXMLFile (INPUT  ip_workspace
                    ,INPUT  b_gsc_product_module.product_module_obj
                    ,INPUT  "RYCSO"
                    ,INPUT  ip_object_name
                    ,OUTPUT op_error
                    ).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateXMLFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateXMLFile Procedure 
PROCEDURE updateXMLFile :
/*------------------------------------------------------------------------------
  Purpose:     To update .ado XML File
  Parameters:  input workspace object number
               input product module object number for object
               input configuration type
               input full object name with no path (including .ado if any)
               output error text if any
  Notes:       

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pdModuleObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER  pcConfigType      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcError           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProductModule            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDatasetCode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootDir                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLFileName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLRelativeName          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  ASSIGN
    hTable01      = ?
    hTable02      = ?
    cRootDir      = "":U
    cRelativePath = "":U
    cDatasetCode = "RYCSO":U
    .

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_obj = pdModuleObj
    NO-ERROR.

  RUN scmGetWorkspaceRoot (INPUT ip_workspace
                          ,OUTPUT cRootDir
                          ).
  IF cRootDir <> "":U
  THEN
    ASSIGN cRootDir = TRIM(cRootDir,"/":U) + "/":U.

  IF AVAILABLE gsc_product_module
  THEN DO: 
    ASSIGN
      cProductModule = gsc_product_module.product_module_code.
    RUN scmSitePrefixAdd (INPUT-OUTPUT cProductModule).
    RUN scmGetModuleDir  (INPUT cProductModule
                         ,OUTPUT cRelativePath).
  END.
  IF cRelativePath <> "":U
  THEN
    ASSIGN cRelativePath = TRIM(cRelativePath,"/":U) + "/":U.

  ASSIGN
    cXMLFileName = pcObjectName.
  RUN scmADOExtReplace (INPUT-OUTPUT cXMLFileName).

  ASSIGN
    cXMLFileName     = SUBSTRING(pcObjectName,1,R-INDEX(pcObjectName,".":U)) + "ado":U
    cXMLRelativeName = cRelativePath + cXMLFileName.

  {launch.i &PLIP = 'af/app/gscddxmlp.p'
            &IProc = 'writeDeploymentDataset'
            &PList = "(INPUT cDataSetCode~
                      ,INPUT REPLACE(pcObjectName,'.ado':U,'':U)~
                      ,INPUT cXMLRelativeName~
                      ,INPUT cRootDir~
                      ,INPUT YES~
                      ,INPUT YES~
                      ,INPUT TABLE-HANDLE hTable01~
                      ,INPUT TABLE-HANDLE hTable02~
                      ,OUTPUT pcError)"
            &OnApp = 'no'
            &Autokill = YES}

  /* Check if the file exist and if the file is not 0 size */
  IF SEARCH(cXMLRelativeName) <> ?
  THEN DO:
    FILE-INFO:FILENAME = SEARCH(cXMLRelativeName).
    IF FILE-INFO:FILE-SIZE = 0
    THEN DO:
      OUTPUT TO VALUE(SEARCH(cXMLRelativeName)).
      DISPLAY "/* ICF-SCM-XML : Dynamics Dynamic Object */":U.
      OUTPUT CLOSE.  
    END.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

