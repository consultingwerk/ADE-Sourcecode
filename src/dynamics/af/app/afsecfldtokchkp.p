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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Destroy on next read */
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
  File: afsecfldtokchkp.p

  Description:  fieldAndTokenSecurityCheck Server Proxy

  Purpose:      fieldAndTokenSecurityCheck Server Proxy

  Parameters:   pcObjectName         - current program object for security check                            
                pcAttributeCode      - current instance attribute posted to program                         
                plCheckFieldSecurity - Extract field security?                                              
                plCheckTokenSecurity - Extract token security?                                              
                pcFieldSecurity      - comma delimited list of secured fields, each with 2 entries.         
                                       Entry 1 = table.fieldname,                                           
                                       Entry 2 = hidden/read-only                                           
                pcTokenSecurity      - security options as comma delimited list of security tokens          
                                       user does not have security clearance for, currently used in toolbar 
                                       panel views to disable buttons and folder windows to disable         
                                       folder pages, etc.                                                   
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/22/2003  Author:     NA Bell

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode      AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plCheckFieldSecurity AS LOGICAL      NO-UNDO. 
  DEFINE INPUT  PARAMETER plCheckTokenSecurity AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldSecurity      AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTokenSecurity      AS CHARACTER    NO-UNDO.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsecfldtokchkp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
         HEIGHT             = 4.86
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
RUN fieldAndTokenSecurityCheck IN gshSecurityManager
  (INPUT pcObjectName,
   INPUT pcAttributeCode,
   INPUT plCheckFieldSecurity,
   INPUT plCheckTokenSecurity,
   OUTPUT pcFieldSecurity,
   OUTPUT pcTokenSecurity) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
    RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                    ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


