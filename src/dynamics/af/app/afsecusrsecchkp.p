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
  File: afsecusrsecchkp.p

  Description:  userSecurityCheck AppServer Proxy

  Purpose:     This procedure checks a user's security allocation for the passed
               in company, and security option, according to the rules mentioned in
               the notes. The types of security checks that could be made are for
               access to tokens, fields, data, data ranges, menu items, etc. The type
               of security check is dependant on the entity mnemonic and obj passed in.

  Parameters:  pdUserObj                  The user being checked
               pdOrganisationObj          The company the user is logged into
               pcOwningEntityMnemonic     The security table being checked
               pdOwningObj                The security table object being checked
               plSecurityCleared          Returns YES if security checked is passed
               pcSecurityValue1           Returns any specific security data
               pcSecurityValue2           Returns any specific security data

  Notes:       See Astra Security Documentation for full information on the rules that
               apply to security checks for a user / company. 

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/30/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pdOrganisationObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcOwningEntityMnemonic      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pdOwningObj                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  plReturnValues              AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER plSecurityRestricted        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue1            AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue2            AS CHARACTER    NO-UNDO.

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsecusrsecchkp.p
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
         HEIGHT             = 25.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  RUN userSecurityCheck IN gshSecurityManager
    (INPUT  pdUserObj, 
     INPUT  pdOrganisationObj,
     INPUT  pcOwningEntityMnemonic,
     INPUT  pdOwningObj,
     INPUT  plReturnValues,
     OUTPUT plSecurityRestricted,
     OUTPUT pcSecurityValue1,
     OUTPUT pcSecurityValue2) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
      RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


