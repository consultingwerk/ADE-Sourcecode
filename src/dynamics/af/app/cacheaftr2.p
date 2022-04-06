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
  File: cacheaftr2.p

  Description:  Post caching appserver bundler

  Purpose:      Bundles all post login appserver calls into one appserver hit.  This procedure
                will call cacheafter.p and then make a few additional appserver hits
                of its own.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/13/2003  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cacheaftr2.p
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
         HEIGHT             = 6.29
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE INPUT  PARAMETER pcLoginName                AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcPassword                 AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pdCompanyObj               AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER pdLanguageObj              AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER ptCurrentProcessDate       AS DATE      NO-UNDO.
DEFINE INPUT  PARAMETER pcDateFormat               AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcCurrentLoginValues       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcLoginProc                AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcCustTypesPrioritised     AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE-HANDLE phSecurityData.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phProfileData.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTranslationData.
DEFINE OUTPUT PARAMETER pdCurrentUserObj           AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserName          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserEmail         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationCode  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationShort AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentLanguageName      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFailedReason             AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcTypeAPI                  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSessionCustRefs          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSessionResultCodes       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityProperties       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityPropValues       AS CHARACTER NO-UNDO.

{af/app/afttsecurityctrl.i}
{af/app/aftttranslation.i}
{af/app/afttprofiledata.i}

/* Run cacheafter.p, which does all the work */
RUN af/app/cacheafter.p ON gshAstraAppserver (INPUT pcLoginName,
                                              INPUT pcPassword,
                                              INPUT pdCompanyObj,
                                              INPUT pdLanguageObj,
                                              INPUT ptCurrentProcessDate,
                                              INPUT pcDateFormat,
                                              INPUT pcCurrentLoginValues,
                                              INPUT pcLoginProc,
                                              INPUT pcCustTypesPrioritised,

                                              OUTPUT TABLE-HANDLE phSecurityData,
                                              OUTPUT TABLE-HANDLE phProfileData,
                                              OUTPUT TABLE-HANDLE phTranslationData,
                                              OUTPUT pdCurrentUserObj,
                                              OUTPUT pcCurrentUserName,
                                              OUTPUT pcCurrentUserEmail,
                                              OUTPUT pcCurrentOrganisationCode,
                                              OUTPUT pcCurrentOrganisationName,
                                              OUTPUT pcCurrentOrganisationShort,
                                              OUTPUT pcCurrentLanguageName,
                                              OUTPUT pcFailedReason,
                                              OUTPUT pcTypeAPI,
                                              OUTPUT pcSessionCustRefs,
                                              OUTPUT pcSessionResultCodes).

/* Now get the security properties, we're going to pass them back to the client as well */
ASSIGN pcSecurityProperties = "SecurityEnabled,SecurityGroups,SecurityModel,GSMFFSecurityExists,GSMTOSecurityExists,RYCSOSecurityExists,GSMMISecurityExists,GSMMSSecurityExists":U
       pcSecurityPropValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT pcSecurityProperties, INPUT YES).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


