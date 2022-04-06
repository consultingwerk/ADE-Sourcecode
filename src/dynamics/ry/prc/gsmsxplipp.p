&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
  File: gsmsxplipp.p

  Description:  PLIP for gsm_scm_xref

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:          49   UserRef:    
                Date:   06/20/2003  Author:     Thomas Hansen

  Update Notes: Created PLIP tro contain data generation logic for gsm_scm_xref table.

  (v:020000)    Task:          49   UserRef:    
                Date:   09/15/2003  Author:     Thomas Hansen

  Update Notes: 

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmsxplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE ghScmTool AS HANDLE   NO-UNDO.

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
         HEIGHT             = 13.81
         WIDTH              = 58.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generateScmXrefData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateScmXrefData Procedure 
PROCEDURE generateScmXrefData :
/*------------------------------------------------------------------------------
  Purpose:   Auto generate data for the gsm-scm_xref table base on the 
             passed in SCM and Owning entity data.
  Parameters:   pcScmToolObj - the scm_tool_obj value of the SCM tool. 
                pcEntity     - The code for the entity to generate data for
                plOverWrite - Overwrite existing data ? 
                phMessageHandle - Handle for the messaging widget to display results in 
                pcError - output error messages. 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcScmToolObj        AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcEntity            AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOverWrite         AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER plSetUnknown        AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER phMessageHandle     AS HANDLE     NO-UNDO.

DEFINE OUTPUT PARAMETER pcError             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cScmProductModuleCode       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProductModuleCode          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempScmProductModuleCode   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cScmObjectTypeCode          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectTypeCode             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cScmProductModuleList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cScmObjectTypeList          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cClassParents               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBaseClass                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cExcludeClasses             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lShowMessages               AS LOGICAL    NO-UNDO.

IF NOT VALID-HANDLE(phMessageHandle) THEN
  lShowMessages = FALSE.
ELSE 
  lShowMessages = TRUE.

FIND FIRST gsc_scm_tool WHERE gsc_scm_tool.scm_tool_obj = pcScmToolObj NO-LOCK NO-ERROR. 
IF NOT AVAILABLE gsc_scm_tool THEN 
DO:
  ASSIGN pcError = "SCM Tool could not be found.":U. 
  IF lShowMessages THEN
    phMessageHandle:INSERT-STRING(pcError + CHR(10)).  
  RETURN.  
END.

IF lShowMessages THEN
  phMessageHandle:INSERT-STRING('Generation of SCM Xref data started for:' + CHR(10) + 
                                'SCM Tool      : ' + gsc_scm_tool.scm_tool_code + CHR(10) + 
                                'Owning Entity : ' + pcEntity + CHR(10) + 
                                'Overwrite Existing Data : ' + STRING(plOverWrite) + CHR(10)).  
  
/* Section for creating object type data */

/* The following list of classes do not have direct links to object types in SCM as they are base or parents object types 
   for groups of object types */
ASSIGN 
  cExcludeClasses = "Base,AppServer,Visual,Container,Messaging,MsgHandler,Query,Visual,Data,SmartQuery,Consumer,Producer,Smart,FieldWidget,DataVisual,Field,Toolbar,Panel,DataContainer,Select,Browser,B2B,Router,Lookup,WebVisual,Viewer,Folder,TreeView,DynContainer".
  
IF gsc_scm_tool.scm_tool_code = "RTB":U THEN
DO:
  IF INDEX(pcEntity, "GSCOT") > 0  THEN
  DO:
    IF NOT VALID-HANDLE(ghScmTool) THEN
    DO:
       IF lShowMessages THEN
         phMessageHandle:INSERT-STRING("SCM tool not available." + CHR(10)).  
       
       RETURN.
    END. /* IF NOT VALID-HANDLE(ghScmTool) */
    ELSE    
      cScmObjectTypeList = DYNAMIC-FUNCTION('scmGetObjectTypeList' IN ghScmTool).
      
    FOR EACH gsc_object_type NO-LOCK:
       ASSIGN cObjectTypeCode    = gsc_object_type.object_type_code.
       IF LOOKUP(cObjectTypeCode, cExcludeClasses) > 0 THEN
        NEXT.

       FIND FIRST gsm_scm_xref WHERE gsm_scm_xref.scm_tool_obj           = gsc_scm_tool.scm_tool_obj AND
                                     gsm_scm_xref.owning_reference       = REPLACE(STRING(gsc_object_type.object_type_obj), 
                                                                                   SESSION:NUMERIC-DECIMAL-POINT, ".":U) AND
                                     gsm_scm_xref.owning_entity_mnemonic = "GSCOT":U NO-LOCK NO-ERROR.             

       /* Display the data in the status editor */
       IF AVAILABLE gsm_scm_xref THEN
       DO:
         IF lShowMessages THEN
           phMessageHandle:INSERT-STRING("Xref exists for " + cObjectTypeCode + " with SCM foreign key : " + gsm_scm_xref.scm_foreign_key + ".":U + CHR(10)).                                         
       END.
       ELSE
       DO:
         /* If we have a direct match with the SCM data, then create a new gsm_scm_xref record for using this data */
         
         /* If the object_type_code is an extension of a base class and this has been done as part of a conversion, 
           there will be _SITE_ in the object_type_code - we need to find out which class this object type extends
           as this is the object type we are really looking for
         */
         IF cObjectTypeCode MATCHES "*_SITE_*":U THEN
         DO:
            /* Get the class hierachy for this object type to find the correct object type to try and match in SCM */
            cClassParents = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT cObjectTypeCode). 
            /* Display the object hierachy in the staus editor */
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Object Type " + cObjectTypeCode + " hierachy : " + cClassParents + CHR(10)).
            /* Find the first parent class that is not extended with _SITE_ - in case there are mutliple cases of extended classes */
            DO WHILE NOT lBaseClass:
              ASSIGN 
                cClassParents   = TRIM(REPLACE(cClassParents, cObjectTypeCode, "":U))
                cObjectTypeCode = ENTRY(NUM-ENTRIES(cClassParents), cClassParents).
                
              IF cObjectTypeCode MATCHES "*_SITE_*":U THEN
                lBaseClass = FALSE. 
              ELSE DO:
                ASSIGN lBaseClass = TRUE.                 
                IF lShowMessages THEN
                  phMessageHandle:INSERT-STRING("Parent object type " + cObjectTypeCode + " will be used for SCM Xref generation." + CHR(10)).              
              END.
            END.         
         END.
         
         /* Check if we have a match with the object type and the code subtype in SCM. If there is a match, we assume this to be the correct link. 
         
            If there is no match, then we create the gsm_scm_xref record with an *unkown* value for the scm_foreign_key. 
            The user will then have ot udpate this manually. 
         */
         IF LOOKUP(cObjectTypeCode, cScmObjectTypeList) > 0 THEN
         DO:
            CREATE gsm_scm_xref NO-ERROR.              
            ASSIGN gsm_scm_xref.scm_tool_obj            = gsc_scm_tool.scm_tool_obj
                   gsm_scm_xref.owning_entity_mnemonic  = "GSCOT":U
                   gsm_scm_xref.scm_foreign_key         = cObjectTypeCode
                   gsm_scm_xref.owning_obj              = gsc_object_type.OBJECT_type_obj
                   gsm_scm_xref.owning_reference        = REPLACE(STRING(gsc_object_type.object_type_obj), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
            
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Created Xref record for Object Type " + gsc_object_type.object_type_code + " with SCM foreign key : " + cObjectTypeCode + CHR(10)).         
         END.
         /* If we do not have matching SCM data, then we need to raise an error, or create the data with an *unknown* value for the scm_foreign_key */
         ELSE       
         DO:
            IF plSetUnknown THEN
            DO:
              CREATE gsm_scm_xref NO-ERROR.                
              ASSIGN gsm_scm_xref.scm_tool_obj            = gsc_scm_tool.scm_tool_obj
                     gsm_scm_xref.owning_entity_mnemonic  = "GSCOT":U
                     gsm_scm_xref.scm_foreign_key         = "*unknown*":U
                     gsm_scm_xref.owning_obj              = gsc_object_type.OBJECT_type_obj
                     gsm_scm_xref.owning_reference        = REPLACE(STRING(gsc_object_type.object_type_obj), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
              
              IF lShowMessages THEN
                phMessageHandle:INSERT-STRING("Created Xref record for Object Type " + gsc_object_type.object_type_code + " with SCM foreign key : " + gsm_scm_xref.scm_foreign_key + CHR(10)).                     
            END.
            ELSE 
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Code Subtype matching Object Type " + cObjectTypeCode + " not found in SCM." + CHR(10)).              
         END. /* ELSE DO ...*/
       END.       
    END.  
  END.
  
  IF INDEX(pcEntity, "GSCPM") > 0  THEN
  DO:
  
    IF NOT VALID-HANDLE(ghScmTool) THEN
    DO:
       IF lShowMessages THEN
         phMessageHandle:INSERT-STRING("SCM tool not available." + CHR(10)).  
       
       RETURN.
    END. /* IF NOT VALID-HANDLE(ghScmTool) */
    ELSE 
      cScmProductModuleList = DYNAMIC-FUNCTION('scmGetModuleList' IN ghScmTool).
    
    FOR EACH gsc_product_module NO-LOCK: 
       ASSIGN cScmProductModuleCode = gsc_product_module.product_module_code
              cProductModuleCode    = gsc_product_module.product_module_code. 
              
       IF VALID-HANDLE(ghScmTool) THEN DO:
         ASSIGN cTempScmProductModuleCode = cScmProductModuleCode. 
         RUN scmSitePrefixDel IN ghScmTool (INPUT-OUTPUT cScmProductModuleCode).   
       END.
               
       IF lShowMessages THEN
         phMessageHandle:INSERT-STRING("Searching for : " + cScmProductModuleCode + CHR(10)).  
         
       IF INDEX(cScmProductModuleList, cTempScmProductModuleCode) > 0 THEN
       DO:
          FIND FIRST gsm_scm_xref WHERE gsm_scm_xref.scm_tool_obj           = gsc_scm_tool.scm_tool_obj AND
                                        gsm_scm_xref.scm_foreign_key        = cProductModuleCode AND 
                                        gsm_scm_xref.owning_reference       = REPLACE(STRING(gsc_product_module.product_module_obj),
                                                                                      SESSION:NUMERIC-DECIMAL-POINT, ".":U) AND
                                        gsm_scm_xref.owning_entity_mnemonic = "GSCPM":U NO-LOCK NO-ERROR. 
                                        
          /* Check to see if we have gsm_scm_xef data where the names of the product modules do not match */
          IF NOT AVAILABLE gsm_scm_xref THEN
          DO:
            FIND FIRST gsm_scm_xref WHERE gsm_scm_xref.scm_tool_obj           = gsc_scm_tool.scm_tool_obj AND
                                          gsm_scm_xref.owning_reference       = REPLACE(STRING(gsc_product_module.product_module_obj),
                                                                                        SESSION:NUMERIC-DECIMAL-POINT, ".":U) AND
                                          gsm_scm_xref.owning_entity_mnemonic = "GSCPM":U NO-LOCK NO-ERROR.             
          END.
          /* Display the data in the status editor */
          IF AVAILABLE gsm_scm_xref THEN
          DO:
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Xref record found for " + cProductModuleCode + " with SCM foreign key : " + cScmProductModuleCode + ".":U + CHR(10)).                                         
          END.
          ELSE                              
          IF NOT AVAILABLE gsm_scm_xref OR 
            (AVAILABLE gsm_scm_xref AND plOverWrite) THEN 
          DO:        
            IF NOT AVAILABLE gsm_scm_xref THEN
            CREATE gsm_scm_xref NO-ERROR. 
            
            ASSIGN gsm_scm_xref.scm_tool_obj            = gsc_scm_tool.scm_tool_obj
                   gsm_scm_xref.scm_foreign_key         = cProductModuleCode
                   gsm_scm_xref.owning_reference        = REPLACE(STRING(gsc_product_module.product_module_obj), SESSION:NUMERIC-DECIMAL-POINT, ".":U)
                   gsm_scm_xref.owning_obj              = gsc_product_module.product_module_obj
                   gsm_scm_xref.owning_entity_mnemonic  = "GSCPM":U.       
            
            VALIDATE gsm_scm_xref. 
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
              phMessageHandle:INSERT-STRING("Error: " + RETURN-VALUE + CHR(10)).
            ELSE   
                   
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Created Xref record for " + cProductModuleCode + " with SCM foreign key : " + cScmProductModuleCode + CHR(10)).                   
          END.
          ELSE
            IF lShowMessages THEN
              phMessageHandle:INSERT-STRING("Xref record for " + cProductModuleCode + " with SCM foreign key : " + cScmProductModuleCode + " exists already." + CHR(10)).                             
       END.
       ELSE 
       DO:
          IF lShowMessages THEN
            phMessageHandle:INSERT-STRING("Product Module for  " + cProductModuleCode + " not found in SCM." + CHR(10)).                                 
       END.        
    END.  /* FOR EACH gsc_product_module */
  END. /* IF INDEX(pcEntity, "GSCPM") > 0 */
END. /* IF gsc_scm_tool.scm_tool_code = "RTB":U */

IF lShowMessages THEN
  phMessageHandle:INSERT-STRING(CHR(10) + 'Generation of SCM Xref data completed.' + CHR(10)).  

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

ASSIGN cDescription = "SCM Xref PLIP".

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

  ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR.

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

