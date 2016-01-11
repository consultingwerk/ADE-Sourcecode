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

  (v:010005)    Task:    90000048   UserRef:    
                Date:   12/04/2002  Author:     Dynamics Administration User

  Update Notes: 

  (v:010002)    Task:          13   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 8713:
                Fixed errors with call to insertObjectMaster in scmHookCreateObject.

  (v:010003)    Task:          20   UserRef:    
                Date:   03/06/2003  Author:     Thomas Hansen

  Update Notes: Issue 8696:
                Fix issues with loading of .ado files in Module Load.
                
                - Added support for creating missing ICFDB objects when moving objects between modules.
                
                This will only be triggered if the object expects a .ado file.
                
                This also works for objects when they are checked out to get them created in ICFDB.

  (v:010004)    Task:          26   UserRef:    
                Date:   03/11/2003  Author:     Thomas Hansen

  Update Notes: Issue 7361:
                - Changed code to longer longer auto create product module if it is missing in ICFDB. This must be created by the user beforehand.
                
                Also added checks for the product module in RTB to also exist in ICFDB - if it doesn't, then cancel the following operations :
                - creation of objects
                - check in of objects
                
                - Fixed issue from previous checking where empty .ado files were being created if the user selects NO to create objects in ICFDB.
                
                - Added code to check for valid .ado files on disk on check in of objects and ask user to load the XML file to get it registered in ICFDB before check-in.

  (v:020000)    Task:          31   UserRef:    
                Date:   03/25/2003  Author:     Thomas Hansen

  Update Notes: Issue 9648 :
                - Updated search for objects in getRepoObjectName to match search in repository API.
                
                Issue xxx :
                - Added check for existing product module to prevent create if the product module does not exist in ICFDB.

  (v:020001)    Task:          36   UserRef:    
                Date:   04/06/2003  Author:     Thomas Hansen

  Update Notes: Issue 9648:
                - Fixed regression in finding of objects in ICFDB.

---------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryscmevntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    020001

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName                     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cIgnoreCodeSubTypeList          AS CHARACTER  NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

/* /* Set the list of Code Subtypes to ignore for .ado file handling */ */
/* ASSIGN cIgnoreCodeSubTypeList = "LSmartObject":U.                    */

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{launch.i &Define-only = YES}

/* Temp-tables use in conjunction with fetchObject. Used in at least generateSDOInstances. */
{ ry/app/ryobjretri.i }

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

DEFINE VARIABLE ghRepositoryDesignManager   AS HANDLE   NO-UNDO.

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
         HEIGHT             = 28.95
         WIDTH              = 63.4.
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
                       (INPUT "SCM":U,
                        INPUT "ASS":U,
                        INPUT STRING(ip_scm_object_name),
                        INPUT "RYCSO":U,
                        INPUT "":U).
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
                       (INPUT "SCM":U, 
                        INPUT "ASS":U,
                        INPUT STRING(ip_scm_object_name),
                        INPUT "RYCSO":U,
                        INPUT "":U,
                        INPUT  YES,
                        OUTPUT lDeletionUnderway).
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepoObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRepoObjectName Procedure 
PROCEDURE getRepoObjectName :
/*------------------------------------------------------------------------------
  Purpose: get the ICFDb name of the object being passed in    
  
  Parameters:  INPUT  pcObjectName     - The name of the object to find in ICFDB
               OUTPUT pcRepoObjectname - The ICFDB object_filename of the object.
               
  Notes:       There are some cases where the name of the object in the 
               SCM tool and the ICFDB database are different. This is often 
               the case with objects where the extension is stored as part of the 
               object_extension field and not the object_filename field, or if 
               the object is dynamic and therefore has no extension in Dynamics
               but has an .ado extension in SCM.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcRepoObjectName      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTempObjectName                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempObjectExt                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectFileName                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER b_ryc_smartobject FOR ryc_smartobject.

  IF pcObjectName = "":U THEN 
    RETURN.
  
  ASSIGN
    cTempObjectName = pcObjectname
    cTempObjectExt  = "":U
    pcObjectName  = REPLACE(pcObjectname,".ado":U,"":U)
    NO-ERROR.

  /* Before we work out the extension, see if we have an object with the 
     exact name that is being passed in. If we do, then we do not need to 
     do any further processing. */
  
  FIND FIRST b_ryc_smartobject NO-LOCK
  WHERE b_ryc_smartobject.object_filename  = pcObjectname NO-ERROR.        
  
  IF NOT AVAILABLE b_ryc_smartobject THEN
  DO:
    IF NUM-ENTRIES(cTempObjectName,".":U) > 1 THEN
      ASSIGN
        cTempObjectExt  = ENTRY(NUM-ENTRIES(cTempObjectName,".":U),cTempObjectName,".":U)
        cTempObjectName = REPLACE(cTempObjectName,"." + cTempObjectExt,"":U).
    
    /* Find the correct existing configuration item for the object being moved, */
    /* i.e. the correct product module and object version                       */
      
    /* If the extension is not blank, then search for the object name by using the base object */
    /* name and the extension.                                                                 */
    
    IF cTempObjectExt = "":U THEN 
    DO:
      /* If the extension is blank, then we only have the object name to search with. 
        This will work for objects without extensions (dynamic objects mostly) and 
        also for objects where the extension is included in the object_filename. */
      FIND FIRST b_ryc_smartobject NO-LOCK
        WHERE b_ryc_smartobject.object_filename = pcObjectname
        NO-ERROR.      
    END.
    ELSE
    IF cTempObjectExt <> "":U THEN
    DO:
      FIND FIRST b_ryc_smartobject NO-LOCK
        WHERE b_ryc_smartobject.object_filename  = cTempObjectName AND   
              b_ryc_smartobject.object_extension = cTempObjectExt NO-ERROR.    
    END.  
  END.
  
  /* Pass back the correct file name and extensions */
  IF AVAILABLE b_ryc_smartobject THEN
  ASSIGN pcRepoObjectName = b_ryc_smartobject.object_filename.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepoProductModuleObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRepoProductModuleObj Procedure 
PROCEDURE getRepoProductModuleObj :
/*------------------------------------------------------------------------------
  Purpose:     Get the ICFDB product module based on a passed in product 
               module code
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProductModuleCode   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pdProductModuleObj    AS DECIMAL    NO-UNDO. 
  DEFINE OUTPUT PARAMETER pcModuleRelativePath  AS CHARACTER  NO-UNDO.  
  DEFINE OUTPUT PARAMETER pcError               AS CHARACTER  NO-UNDO.
    
  RUN scmSitePrefixDel (INPUT-OUTPUT pcProductModuleCode).
  
  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = pcProductModuleCode 
    NO-ERROR.
  IF NOT AVAILABLE gsc_product_module THEN 
  DO:
  /* As the product module does not exist, we should reurn an error to the user about this 
     and stop processing  */
    ASSIGN 
      pcError = "Product Module: "    + pcProductModuleCode + " does not exist in ICFDB database"
      pdProductModuleObj = 0.
    RETURN pcError.
  END.
  ELSE 
  ASSIGN 
    pcError              = "":U
    pdProductModuleObj   = gsc_product_module.product_module_obj
    pcModuleRelativePath = gsc_product_module.relative_path.
        
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
  DEFINE VARIABLE cRootDir                  AS CHARACTER  NO-UNDO.

  ASSIGN cRelativePath = "":U.

  RUN scmGetModuleDir (INPUT pdProductModule,
                       OUTPUT cRelativePath).
                       
  IF cRelativePath <> "":U
  THEN
    ASSIGN cRelativePath = cRelativePath + "/":U.

  ASSIGN pcRelativeXMLFile = pcObjectName.
    
  RUN scmADOExtReplace (INPUT-OUTPUT pcRelativeXMLFile).
  RUN scmADOExtAdd     (INPUT-OUTPUT pcRelativeXMLFile).
  
  ASSIGN pcRelativeXMLFile = cRelativePath + pcRelativeXMLFile.
  
  /* Get the root directory for the workspace.*/    
  RUN scmGetWorkspaceRoot (INPUT "":U, 
                           OUTPUT cRootDir). 
                           
  IF cRootDir <> "":U THEN
  ASSIGN pcFullXMLFile = SEARCH(cRootDir + "/":U + pcRelativeXMLFile).
  ELSE  
  ASSIGN pcFullXMLFile = SEARCH(pcRelativeXMLFile).

  IF pcFullXMLFile = ? THEN 
    ASSIGN pcFullXMLFile = "":U.
  ELSE
    ASSIGN pcFullXMLFile = REPLACE(pcFullXMLFile,"~\":U,"~/":U). 
  
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

    DO WHILE VALID-HANDLE(hProcHandle)
    AND hProcHandle:FILE-NAME <> cProcName
    :
      hProcHandle = hProcHandle:NEXT-SIBLING.
    END.

    IF NOT VALID-HANDLE(hProcHandle)
    THEN DO:
      RUN VALUE(cProcName) PERSISTENT SET hProcHandle.
      ASSIGN 
        hProcHandle:PRIVATE-DATA = "SCMTool"
        .     
    END.

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
    cProcName      = "SCMTool":U
    hValidHanldles = SESSION:FIRST-PROCEDURE.

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
    hTable02 = ?.

  ASSIGN ip_object_name = REPLACE(ip_object_name,".ado":U,"":U) NO-ERROR.

  /* get full path to xml file if it exists and relative path */
  RUN getXMLFilename (INPUT  ip_product_module,
                      INPUT  ip_object_name,
                      OUTPUT cRelativeXMLFile,
                      OUTPUT cFullXMLFile).
                     
  ASSIGN op_error = "":U.

  IF cFullXMLFile <> "":U THEN 
  DO:
    ASSIGN FILE-INFO:FILENAME = cFullXMLFile. 
    
    /* Check if the file is bigger than 0 - if not then we cannot load 
       and we should stop. 
    */
    IF FILE-INFO:FILE-SIZE = 0 THEN
    DO:
      ASSIGN op_error = "XML file with invalid size found." + "~n":U + 
                        "The file " + cFullXMLFile + " cannot be loaded.".
      RETURN.                  
    END.
    
    ASSIGN cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"":U).

    /* re-create the actual data for this item version - from the XML file */
    {launch.i &PLIP = 'af/app/gscddxmlp.p'
              &IProc = 'importDeploymentDataset'
              &PList = "(INPUT cRelativeXMLFile,~
                         INPUT cRootDirXMLFile,~
                         INPUT '':U,~
                         INPUT YES,~
                         INPUT YES,~
                         INPUT NO,~
                         INPUT TABLE-HANDLE hTable01,~
                         INPUT TABLE-HANDLE hTable02,~
                         OUTPUT op_error )"
              &OnApp = 'no'
              &Autokill = YES}
              
     IF op_error = "":U THEN
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
     DO:
        IF RETURN-VALUE <> "":U THEN
        ASSIGN op_error = RETURN-VALUE. 
     END.
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

  DEFINE VARIABLE cFullObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectHasDataPart              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lImportedObject                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cConfigurationType              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule                  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lTaskComplete                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSkipObjectDump                 AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cRepoObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewObjectCreated               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCreateObject                   AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE lRepoObjectExists               AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cRootDirXMLFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuestion                       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCodeSubType                    AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE dProductModuleObj               AS DECIMAL    NO-UNDO. 
  DEFINE VARIABLE cRelativePath                   AS CHARACTER  NO-UNDO.  
  
  DEFINE VARIABLE hTable01                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                        AS HANDLE     NO-UNDO.

  /* Make sure the object should exist in the ICFDb database, and 
     that it really does exist in the database as well. 
   */
  ASSIGN cFullObjectName     = ip_object_name
         lObjectHasDataPart  = NO
         NO-ERROR.

  RUN scmObjectHasData (INPUT  ip_workspace,
                        INPUT  cFullObjectName,
                        OUTPUT lObjectHasDataPart,
                        OUTPUT cProductModule).
                        
  IF NOT lObjectHasDataPart THEN 
    RETURN. /* There is not .ado file part for the object, so we are not interested in the rest of the processing */ 
  ELSE
  DO:  
  /* The code commented out below has not yet been implemented ! */
/*     /* First check if the object is of an object type that does not need to be */
/*        registered in ICFDB */                                                  */
/*     RUN scmObjectSubType(INPUT ip_workspace,                                   */
/*                          INPUT ip_object_name,                                 */
/*                          OUTPUT cCodeSubType).                                 */
/*                                                                                */
/*     /* If the object belongs to a code subtype that should not have            */
/*        automated .ado processing, return */                                    */
/*     IF LOOKUP(cCodeSubType, cIgnoreCodeSubTypeList) > 0 THEN                   */
/*     RETURN.                                                                    */
    
    /* get full path to xml file if it exists and relative path. There are a number of 
      places where where we may need this later.  */
    RUN getXMLFilename (INPUT  cProductModule,
                        INPUT  ip_object_name, /* The ICFDB name of the object */ 
                        OUTPUT cRelativeXMLFile,
                        OUTPUT cFullXMLFile).
                         
    RUN getRepoObjectName (INPUT  ip_object_name, 
                           OUTPUT cRepoObjectName).   
    
    IF cRepoObjectName = "":U THEN DO:         
      ASSIGN lRepoObjectExists = NO.
      /* If the object is not in the repository, but we have a valid .ado file on disk, we should 
         try and load this to create the data. If not, then we will try and create the object instead.
      */
            
      IF cFullXMLFile <> "":U THEN
      ASSIGN FILE-INFO:FILE-NAME = cFullXMLFile. 
      IF FILE-INFO:FILE-SIZE > 0 THEN      
      DO:
        /* The XML file exists and it is bigger than 0 bytes (this is checked in the getXMLFilename procedure. 
           Ask the user if the want to load it */
        ASSIGN cQuestion = "There is a .ado file for the object on disk and the object " + ip_object_name + " does not exist in the ICFDB database." + "~n":U + "~n":U +  
                           "Do you want to load the .ado file to create the object in the ICFDB repository?".
                       
        IF VALID-HANDLE(gshSessionManager) THEN
        DO:
          RUN askQuestion IN gshSessionManager (INPUT        cQuestion,
                                                INPUT        "&Yes,&No,&Cancel":U,    /* button list */
                                                INPUT        "&Yes":U,           /* default button */ 
                                                INPUT        "&No":U,       /* cancel button */
                                                INPUT        "":U,             /* window title */
                                                INPUT        "":U,      /* data type of question */ 
                                                INPUT        "":U,          /* format mask for question */ 
                                                INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                      OUTPUT cButton). /* button pressed */
          
          IF cButton = "&Yes":U THEN
          DO:
            IF cFullXMLFile <> "":U
            THEN DO:        
              ASSIGN cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"").
          
              /* recreate the actual data for this item version - from the XML file */
               {launch.i &PLIP = 'af/app/gscddxmlp.p'
                         &IProc = 'importDeploymentDataset'
                         &PList = "(INPUT cRelativeXMLFile,~
                                    INPUT cRootDirXMLFile,~
                                    INPUT '':U,~
                                    INPUT YES,~
                                    INPUT YES,~
                                    INPUT NO,~
                                    INPUT TABLE-HANDLE hTable01,~
                                    INPUT TABLE-HANDLE hTable02,~
                                    OUTPUT op_error )"
                        &OnApp = 'no'
                        &Autokill = YES}                  
               IF op_error <> "":U OR
                  ERROR-STATUS:ERROR OR 
                  RETURN-VALUE <> "":U THEN
                  ASSIGN op_error = IF op_error <> "":U THEN op_error + CHR(10) + RETURN-VALUE ELSE RETURN-VALUE.              
                ELSE
                  ASSIGN op_error = "":U.
                                           
                RETURN.
            END.        
          END. /* IF cButton = "&Yes":U ... */        
          ELSE IF cButton = "&Cancel":U THEN
          DO:
            ASSIGN op_error = "Check-in cancelled by user.".
            RETURN.
          END.
          
        END. /* IF VALID-HANDLE(gshSessionManager) ... */
      END. /* IF cFullXMLFile <> "":U ... */
      ELSE 
      
      /* If the object is not in the repository, ask the user if they want to create it, if not, 
         show an error and cancel the check-in. */

      /* Try and create the objecct in the iCFDB database instead. */
      IF VALID-HANDLE(gshSessionManager) THEN
      DO:
        ASSIGN lNewObjectCreated = FALSE. 
        
        RUN askQuestion IN gshSessionManager (INPUT        "The object " + ip_object_name + " is not registered in the Dynamics repository. Do you want to create the object in Dynamics ? ",    /* message to display */
                                              INPUT        "&Yes,&No,&Cancel":U,    /* button list */
                                              INPUT        "&Yes":U,           /* default button */ 
                                              INPUT        "&No":U,       /* cancel button */
                                              INPUT        "":U,             /* window title */
                                              INPUT        "":U,      /* data type of question */ 
                                              INPUT        "":U,          /* format mask for question */ 
                                              INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                    OUTPUT cButton           /* button pressed */
                                              ).
        IF cButton = "&Yes":U THEN 
        DO:
          /* Remember to disable the replication triggers before creating a new object */
          RUN disableAssignReplication (INPUT ip_object_name).
    
          /* Create the object in the ICFDB database - as it seems to 
             be missing from here. We can call the scmHookCreateObject 
             procedure here - as it's only function is to create objects
             in the ICFDB database. 
             
             It is important that the replication triggers have been disabled 
             before this is run though.
          */     
          RUN scmHookCreateObject (INPUT ip_workspace, 
                                   INPUT ip_task_number, 
                                   INPUT ip_user_id, 
                                   INPUT ip_object_name, 
                                   OUTPUT op_error).
          IF op_error <> "":U THEN
             RETURN.
          ELSE 
            ASSIGN 
              lNewObjectCreated = TRUE
              lRepoObjectExists = YES. 
        END. /* IF cButton = "&Yes":U...*/
        ELSE IF cButton = "&Cancel":U THEN 
        DO:
          ASSIGN op_error = "Check-in cancelled by user". 
          RETURN.
        END.
      END. /* IF VALID-HANDLE(gshSessionManager) ...*/
    END. /*IF cRepoObjectName = "":U  */      
    ELSE 
    ASSIGN lRepoObjectExists = TRUE. 
    
    /* IF we get to here, we have an object, and we want to continue processing */
    ASSIGN lSkipObjectDump = NO.
    
    IF VALID-HANDLE(gshSessionManager) THEN 
    DO:
      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "SCM":U, 
                            INPUT  "TASKCOMP":U,
                            INPUT  ip_task_number,
                            INPUT  "":U,
                            INPUT  "":U,
                            INPUT  NO,
                            OUTPUT lTaskComplete).
  
      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "SCM":U,
                            INPUT  "SKIPDUMPYES":U,
                            INPUT  (IF lTaskComplete THEN STRING(ip_task_number) ELSE ip_object_name),
                            INPUT  "":U,
                            INPUT  "":U,
                            INPUT  NO,
                            OUTPUT lSkipObjectDump).
    END.
  
    ASSIGN op_error = "":U.
    
    IF lRepoObjectExists THEN
    DO:
      RUN getRepoProductModuleobj (INPUT  cProductModule, 
                                   OUTPUT dProductModuleObj, 
                                   OUTPUT cRelativePath,
                                   OUTPUT op_error).
                                   
      IF op_error <> "":U THEN
      DO:
        /* As the product module does not exist, we should reurn an error to the user about this 
           and stop processing  */
        ASSIGN op_error = "Error checking in object: " + cRepoObjectName + ".":U + "~n":U + 
                          op_error.
        RETURN.
      END.
      ELSE 
      DO:      
        /* Item exists in workspace and is checked out, or it is an imported object - check it in */
        /* Generate/update .ado XML File */
        IF NOT lSkipObjectDump THEN 
        DO:
          RUN updateXMLFile (INPUT  ip_workspace,
                             INPUT  dProductModuleObj,
                             INPUT  "RYCSO":U,
                             INPUT  cFullObjectName,
                             OUTPUT op_error).
          IF op_error <> "":U
          THEN 
            RETURN.
        END.
      END.
    END.    
  END. /* IF lObjectHasDataPart ... */
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

  DEFINE VARIABLE hRepositoryDesignManager        AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cFullObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmObjectName                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRepoObjectName                 AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lObjectHasDataPart              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProductModuleCode              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRootDirXMLFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableHandle                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lActionUnderWay                 AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE lSkipObjectLoad                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dProductModuleObj               AS DECIMAL    NO-UNDO.  
  DEFINE VARIABLE cRelativePath                   AS CHARACTER  NO-UNDO.  
  
  ASSIGN
    hTable01 = ?
    hTable02 = ?
    hTablehandle = ?.

  ASSIGN
    cFullObjectName = ip_object_name
    ip_object_name      = REPLACE(ip_object_name,".ado":U,"":U)
    lObjectHasDataPart  = NO
    NO-ERROR.
  
  RUN scmFullObjectInfo (INPUT  cFullObjectName,
                         INPUT  ip_workspace,
                         INPUT  ip_task_number,
                         OUTPUT lExistsInRtb,
                         OUTPUT lExistsInWorkspace,
                         OUTPUT iWorkspaceVersion,
                         OUTPUT cWorkspaceModule,
                         OUTPUT lWorkspaceCheckedOut,
                         OUTPUT iVersioninTask,
                         OUTPUT iLatestVersion,
                         OUTPUT cObjectSummary,
                         OUTPUT cObjectDescription,
                         OUTPUT cObjectUpdNotes,
                         OUTPUT cPrevVersions).
                         
  ASSIGN cWorkspaceModuleRTB = cWorkspaceModule.
  
  RUN scmSitePrefixAdd (INPUT-OUTPUT cWorkspaceModuleRTB).
  RUN scmGetModuleDir  (INPUT  cWorkspaceModuleRTB,
                        OUTPUT cModuleDir).

  /* Check if the object should have a .ado file part - if not, then 
     there is no point in processing the object in the repository */
  RUN scmObjectHasData (INPUT  ip_workspace,
                        INPUT  cFullObjectName,
                        OUTPUT lObjectHasDataPart,
                        OUTPUT cProductModuleCode).    
           
  IF NOT lObjectHasDataPart THEN
    RETURN.
  
  RUN getRepoProductModuleobj (INPUT cProductModuleCode, 
                               OUTPUT dProductModuleObj, 
                               OUTPUT cRelativePath,
                               OUTPUT op_error).
  IF op_error <> "":U THEN
  DO:
    /* As the product module does not exist, we should reurn an error to the user about this 
       and stop processing  */
    ASSIGN op_error = "Error creating object: " + ip_object_name + ".":U + "~n":U + 
                      op_error.
    RETURN.
  END.
  
  ASSIGN lSkipObjectLoad = NO.
  
  IF VALID-HANDLE(gshSessionManager) THEN 
  DO:
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "SKIPLOADYES":U,
                          INPUT  cWorkspaceModuleRTB,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lSkipObjectLoad).
    
    /* Also check to see if there is a SKIPLOADNO actionUnderWay record.
       If there is, then we need to make sure that it is only the load of 
       the .ado file that is going to be done, and not a prior creation of the 
       object in ICFDB. This will prevent problems with the object not loading 
       correctly from Module Load when a .ado file is being used to register objects. 
    */
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "SKIPLOADNO":U,
                          INPUT  cWorkspaceModuleRTB,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lActionUnderWay).
                         
    IF lActionUnderWay THEN
      ASSIGN lSkipObjectLoad = NO.  
  END.
                         
  RUN scmObjectSubType (INPUT  ip_workspace,
                        INPUT  cFullObjectName,
                        OUTPUT cObjectType). /* Actual SubType and not ObjectType of PCODE */
                           
  /* Check if we have an object in the repository already. If we do, then we 
     have to create the object with the extension in the file name - if this doe snot 
     exist already. 
     
     We have to be careful not to get into a situation where we end up updating 
     an existing object - with a DIFFERENT extension - with the new object properties. 
  */
  RUN getRepoObjectName (INPUT  cFullObjectname, 
                         OUTPUT cRepoObjectname).
                         
  /*     If the object name does exist in ICFDB, we must create the new object with the */
  /*     extension in the object_filename - as this ensures uniqueness in the the name. */
  
  ASSIGN hRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF NOT VALID-HANDLE(hRepositoryDesignManager) THEN 
  DO:
    op_error = {aferrortxt.i 'AF' '19' '?' '?' "''" "'Repository Design Manager'"}.
    RETURN.
  END.

  IF VALID-HANDLE(hRepositoryDesignManager) THEN 
  DO:  
    /* Only create the object from scratch if the .ado file is not going to be loaded.*/
    IF NOT lSkipObjectLoad THEN
    DO:    
      RUN insertObjectMaster IN hRepositoryDesignManager
                             ( INPUT  ip_object_name,             /* pcObjectName         */
                               INPUT  "{&DEFAULT-RESULT-CODE}",   /* pcResultCode         */
                               INPUT  cWorkspaceModule,           /* pcProductModuleCode  */
                               INPUT  cObjectType,                /* pcObjectTypeCode     */
                               INPUT  cObjectDescription,         /* pcObjectDescription  */
                               INPUT  cModuleDir,                 /* pcObjectPath         */
                               INPUT  "":U,                       /* pcSdoObjectName      */
                               INPUT  "":U,                       /* pcSuperProcedureName */
                               INPUT  NO,                         /* plIsTemplate         */
                               INPUT  YES,                        /* plIsStatic           */
                               INPUT  "":U,                       /* pcPhysicalObjectName */
                               INPUT  NO,                         /* plRunPersistent      */
                               INPUT  "":U,                       /* pcTooltipText        */
                               INPUT  "":U,                       /* pcRequiredDBList     */
                               INPUT  "":U,                       /* pcLayoutCode         */
                               INPUT  ?,
                               INPUT  TABLE-HANDLE hTableHandle,
                               OUTPUT dObjectNumber                  ) NO-ERROR.
      IF ERROR-STATUS:ERROR OR 
         RETURN-VALUE <> "":U THEN 
      DO:       
         IF RETURN-VALUE <> "":U THEN
            ASSIGN op_error = RETURN-VALUE. 
         ELSE 
            ASSIGN op_error = ERROR-STATUS:GET-MESSAGE(1). 
      END.   
      IF op_error <> "":U THEN 
        RETURN.
    END. /* IF NOT lSkipObjectLoad THEN */ 
  END. /* IF VALID-HANDLE(hRepositoryDesignManager) ...*/
  ELSE 
  DO:
    ASSIGN
      op_error = "Error creating object: " + ip_object_name
               + " in workspace: "         + ip_workspace
               + ". The Repository Design Manager (ry/app/rydesclntp.p) is not running.".
    RETURN.           
  END.

  /* get full path to xml file if it exists and relative path */
  RUN getXMLFilename (INPUT  dProductModuleObj,
                      INPUT  ip_object_name,
                      OUTPUT cRelativeXMLFile,
                      OUTPUT cFullXMLFile).
                      
  ASSIGN op_error = "":U.

  /* Make sure we have a valid XML file and that it is not size 0 */
  IF cFullXMLFile <> "":U THEN 
  ASSIGN FILE-INFO:FILE-NAME = cFullXMLFile. 
  IF FILE-INFO:FILE-SIZE > 0
  AND NOT lSkipObjectLoad
  THEN DO:

    ASSIGN
      cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"").

    /* recreate the actual data for this item version - from the XML file */
    {launch.i &PLIP = 'af/app/gscddxmlp.p'
              &IProc = 'importDeploymentDataset'
              &PList = "(INPUT cRelativeXMLFile,~
                         INPUT cRootDirXMLFile,~
                         INPUT '':U,~
                         INPUT YES,~
                         INPUT YES,~
                         INPUT NO,~
                         INPUT TABLE-HANDLE hTable01,~
                         INPUT TABLE-HANDLE hTable02,~
                         OUTPUT op_error )"
              &OnApp = 'no'
              &Autokill = YES}
    IF op_error = "":U THEN
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN DO:
       IF RETURN-VALUE <> "":U THEN 
        ASSIGN op_error = RETURN-VALUE.         
    END.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.                                  
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

  DEFINE VARIABLE lSkipObjectDel                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRepoObjectName                 AS CHARACTER  NO-UNDO.
  
  ASSIGN lSkipObjectDel = NO.
  
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "SKIPDEL":U,
                          INPUT  ip_object_name,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lSkipObjectDel).

  IF lSkipObjectDel THEN 
  DO:
    ASSIGN op_error = "":U.
    RETURN.
  END.

  RUN getRepoObjectName (INPUT  ip_object_name, 
                         OUTPUT cRepoObjectName).          
                                          
  ASSIGN ip_object_name = REPLACE(ip_object_name,".ado":U,"":U) 
    NO-ERROR.

  ASSIGN
    ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF VALID-HANDLE(ghRepositoryDesignManager) THEN 
  DO:
    RUN removeObject IN ghRepositoryDesignManager 
                    (INPUT cRepoObjectname,  /* pcSdoObjectName */
                     INPUT "":U)              /* pcResultCode    */
                     NO-ERROR.

  END.  /* We have the handle of the Repository Design Manager */
  IF ERROR-STATUS:ERROR OR 
     RETURN-VALUE <> "":U
  THEN 
  DO:
    ASSIGN
      op_error = "Error deleting object: " + ip_object_name + 
                 " in workspace: "         + ip_workspace + ". " + "~n":U + 
                 RETURN-VALUE.
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
  
               This hook will also be used to force a create of objects 
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ip_new_product_module   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ip_new_object_version   AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE BUFFER b_ryc_smartobject                 FOR ryc_smartobject.
  
  DEFINE VARIABLE cRepoObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFileName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer                         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectHasDataPart              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNewObjectCreated               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCheckOut                       AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cProductModule                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCodeSubType                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dProductModuleObj               AS DECIMAL    NO-UNDO.  
    
  /* Check if we are checking the object out - this can be seen by the 
     input parameter ip_new_product_module bveing blank.  */
 IF ip_new_product_module = "":U THEN
  ASSIGN lCheckOut = YES.
  
  /* Check if the object should have a .ado file part - if not, then 
     there is no plint in processing the object in the repository */
  RUN scmObjectHasData (INPUT  ip_workspace,
                        INPUT  ip_object_name,
                        OUTPUT lObjectHasDataPart,
                        OUTPUT cProductModule).    
  
  /* If we are not expecting a .ado file (which means the object is not in the Dynamics
     repository, then the rest of this procedure is not necessary */
  IF NOT lObjectHasDataPart THEN 
    RETURN. 
    
  RUN getRepoObjectName (INPUT ip_object_name, 
                         OUTPUT cRepoObjectName).                         
  
  IF cRepoObjectName = "":U THEN 
  DO:
    ASSIGN cObjectFileName = "":U.
      
/*     /* First check if the object is of an object type that does not need to be */
/*        registered in ICFDB */                                                  */
/*     RUN scmObjectSubType(INPUT ip_workspace,                                   */
/*                          INPUT ip_object_name,                                 */
/*                          OUTPUT cCodeSubType).                                 */
/*                                                                                */
/*     /* If the object belongs to a code subtype that should not have            */
/*        automated .ado processing, return */                                    */
/*     IF LOOKUP(cCodeSubType, cIgnoreCodeSubTypeList) > 0 THEN                   */
/*     RETURN.                                                                    */
      
    /* Try and create the objecct in the iCFDB database instead. */
    IF VALID-HANDLE(gshSessionManager) THEN
    DO:
      RUN askQuestion IN gshSessionManager (INPUT        "The object " + ip_object_name + " is not registered in the Dynamics repository. Do you want to create the object in Dynamics ? ",    /* message to display */
                                            INPUT        "&Yes,&No":U,    /* button list */
                                            INPUT        "&Yes":U,           /* default button */ 
                                            INPUT        "&No":U,       /* cancel button */
                                            INPUT        "":U,             /* window title */
                                            INPUT        "":U,      /* data type of question */ 
                                            INPUT        "":U,          /* format mask for question */ 
                                            INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                                  OUTPUT cButton           /* button pressed */
                                            ).
      IF cButton = "&Yes":U THEN 
      DO:
        /* Remember to disable the replication triggers before creating a new object */
        RUN disableAssignReplication (INPUT ip_object_name).
  
        /* Create the object in the ICFDB database - as it seems to 
           be missing from here. We can call the scmHookCreateObject 
           procedure here - as it's only function is to create objects
           in the ICFDB database. 
           
           It is important that the replication triggers have been disabled 
           before this is run though.
        */     
        RUN scmHookCreateObject (INPUT ip_workspace, 
                                 INPUT ip_task_number, 
                                 INPUT ip_user_id, 
                                 INPUT ip_object_name, 
                                 OUTPUT op_error).
        IF op_error <> "":U THEN
           RETURN.
        ELSE 
          lNewObjectCreated = TRUE.   
      END.
      ELSE 
        /* We are not interested in getting the object created in the ICFDB and 
           therefore not interested in the rest of the processing - so return.
        */
        RETURN.    
    END.
  END. /*IF cRepoObjectName = "":U  */

  /* As we have just created a new object, then we need 
     to re-find the repository object name before we can continue */
  IF cRepoObjectName = "":U THEN
    RUN getRepoObjectName (INPUT ip_object_name, 
                           OUTPUT cRepoObjectName).                         

  ASSIGN cObjectFileName = cRepoObjectname.

  /* Check if we are changing product modules. If not, then we may just 
    be using this hook to create objects in the ICFDB database and get 
    the XML file updated.
  */
  IF ip_new_product_module <> "":U THEN
  DO:    
    RUN getRepoProductModuleobj (INPUT  ip_new_product_module, 
                                 OUTPUT dProductModuleObj, 
                                 OUTPUT cRelativePath,
                                 OUTPUT op_error) NO-ERROR.
    
    IF op_error <> "":U THEN
    DO:
      /* As the product module does not exist, we should reurn an error to the user about this 
         and stop processing  */
      ASSIGN op_error = "Error moving object: " + ip_object_name + ".":U + "~n":U + 
                        op_error.
      RETURN.
    END.
    ELSE DO:
      IF NOT lNewObjectCreated THEN 
        /* We will have disabled the triggers already during the creation in the code above */
        RUN disableAssignReplication (INPUT ip_object_name).
    
      FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
        WHERE ryc_smartobject.object_filename = cObjectFileName
        NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN
        ASSIGN ryc_smartobject.product_module_obj = dProductModuleObj. 
          
      /* Only if the object is a static object do we need to set the path */
      IF ryc_smartobject.static_object THEN
        ASSIGN ryc_smartobject.object_path = cRelativePath.
    END.  
  END.

  /* If we are not moving modules, then the module name has not been passed in - so we 
     need to find it and get the gsc_product_module record in the ICFDB database before 
     we can continue. 
   */
  IF dProductModuleObj = 0 THEN
  DO:
     RUN scmGetObjectModule (INPUT ip_workspace,
                             INPUT ip_object_name, 
                             INPUT "":U, 
                             OUTPUT cProductModule, 
                             OUTPUT cRelativePath).
                             
    RUN getRepoProductModuleobj (INPUT cProductModule, 
                                 OUTPUT dProductModuleObj, 
                                 OUTPUT cRelativePath,
                                 OUTPUT op_error) NO-ERROR.
  END.                              
  
/*   If we are not checking an object out OR if a new object has been created in */
/*   ICFDB, then update the .ado file.                                           */
  IF NOT lCheckOut OR 
         lNewObjectCreated THEN
  RUN updateXMLFile (INPUT  ip_workspace,
                     INPUT  dProductModuleObj,
                     INPUT  "RYCSO":U,
                     INPUT  ip_object_name,
                     OUTPUT op_error) NO-ERROR.

  IF op_error <> "":U THEN
    RETURN. 
    
  ASSIGN ERROR-STATUS:ERROR = NO. 
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

  DEFINE VARIABLE cScmObjectName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSmartObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempObjectExt            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectSubType            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  ASSIGN
    hTable01      = ?
    hTable02      = ?
    cRootDir      = "":U
    cRelativePath = "":U
    cDatasetCode = "RYCSO":U.

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_obj = pdModuleObj
    NO-ERROR.

  IF AVAILABLE gsc_product_module THEN 
  DO: 
    ASSIGN cProductModule = gsc_product_module.product_module_code.
    
    RUN scmSitePrefixAdd (INPUT-OUTPUT cProductModule).
    RUN scmGetModuleDir  (INPUT cProductModule,
                          OUTPUT cRelativePath).
  END.

  IF cRelativePath <> "":U THEN
    ASSIGN cRelativePath = TRIM(cRelativePath,"/":U) + "/":U.
  
  RUN scmGetWorkspaceRoot (INPUT ip_workspace, 
                           OUTPUT cRootDir).
  IF cRootDir <> "":U THEN 
    ASSIGN cRootDir = TRIM(cRootDir,"/":U) + "/":U.

  ASSIGN cXMLFileName = pcObjectName.
  
  RUN scmADOExtReplace (INPUT-OUTPUT cXMLFileName).

  ASSIGN
    cXMLFileName     = SUBSTRING(pcObjectName,1,R-INDEX(pcObjectName,".":U)) + "ado":U
    cXMLRelativeName = cRelativePath + cXMLFileName.

  ASSIGN
    cTempObjectName   = pcObjectName
    cTempObjectExt    = "":U.

  IF NUM-ENTRIES(pcObjectName,".":U) > 1 THEN
    ASSIGN
      cTempObjectExt  = ENTRY(NUM-ENTRIES(pcObjectName,".":U),pcObjectName,".":U)
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
          + ryc_smartobject.object_extension = pcObjectName
      NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename  = pcObjectName
    NO-ERROR.

  IF AVAILABLE ryc_smartobject THEN
    ASSIGN
      cScmObjectName   = ryc_smartobject.object_filename
                       + (IF ryc_smartobject.object_extension <> "" THEN "." ELSE "")
                       + ryc_smartobject.object_extension
      cSmartObjectName = ryc_smartobject.object_filename.
  ELSE
    ASSIGN
      cScmObjectName   = pcObjectName
      cSmartObjectName = "":U.

  RUN scmADOExtAdd (INPUT-OUTPUT cScmObjectName).
  RUN scmObjectSubType(INPUT  ip_workspace,
                       INPUT  cScmObjectName,
                       OUTPUT cObjectSubType).

  IF LOOKUP(cObjectSubType,"LSmartObject,DataDump":U) > 0
  AND cSmartObjectName = "":U
  THEN 
    RETURN.

  IF cSmartobjectName = "":U THEN
    ASSIGN cSmartobjectName  = pcObjectName.

  ASSIGN cSmartobjectName = REPLACE(cSmartobjectName,".ado":U,"":U).

  {launch.i &PLIP     = 'af/app/gscddxmlp.p'
            &IProc    = 'writeDeploymentDataset'
            &PList    = "(INPUT cDataSetCode,~
                         INPUT cSmartobjectName,~
                         INPUT cXMLRelativeName,~
                         INPUT cRootDir,~
                         INPUT YES,~
                         INPUT YES,~
                         INPUT TABLE-HANDLE hTable01,~
                         INPUT TABLE-HANDLE hTable02,~
                         OUTPUT pcError)"
            &OnApp    = 'no'
            &Autokill = YES
            }
  IF pcError = "":U THEN
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN DO:
     IF RETURN-VALUE <> "":U THEN 
      ASSIGN pcError = RETURN-VALUE. 
  END.

  /* Check if the file exist and if the file is not 0 size */
  IF SEARCH(cXMLRelativeName) <> ? THEN 
  DO:
    FILE-INFO:FILENAME = SEARCH(cXMLRelativeName).
    IF FILE-INFO:FILE-SIZE = 0 THEN 
    DO:
      OUTPUT TO VALUE(SEARCH(cXMLRelativeName)).
      DISPLAY "/* ICF-SCM-XML : Dynamic Object */":U.
      OUTPUT CLOSE.  
    END.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

