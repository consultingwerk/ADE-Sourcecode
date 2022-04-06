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
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  File: cacheafter.p

  Description:  Cache information after login

  Purpose:      Cache information after login

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/06/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cacheafter.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{af/app/afttprofiledata.i}  /* Profile Cache    */
{af/app/afttsecurityctrl.i} /* Security Cache   */
{af/app/aftttranslation.i}  /* Translation data */

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
         HEIGHT             = 3.14
         WIDTH              = 40.
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
define input  parameter plCachedTranslationsOnly   as logical no-undo.

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
DEFINE OUTPUT PARAMETER pcSessionCustRefs          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcSessionResultCodes       AS CHARACTER  NO-UNDO.
define output parameter pcSecurityPropNames        as character no-undo.
define output parameter pcSecurityPropValues       as character no-undo.

DEFINE VARIABLE cPropertyList         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCustomizationManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLanguageCode         AS CHARACTER  NO-UNDO.

/* Check the user. This ensures that the users is a valid user,
   and also sets the various security properties correctly.
 */
RUN checkUser IN gshSecurityManager (INPUT  pcLoginName,
                                     INPUT  pcPassword,
                                     INPUT  pdCompanyObj,
                                     INPUT  pdLanguageObj,
                                     OUTPUT pdCurrentUserObj,
                                     OUTPUT pcCurrentUserName,
                                     OUTPUT pcCurrentUserEmail,
                                     OUTPUT pcCurrentOrganisationCode,
                                     OUTPUT pcCurrentOrganisationName,
                                     OUTPUT pcCurrentOrganisationShort,
                                     OUTPUT pcCurrentLanguageName,
                                     OUTPUT pcFailedReason).
                                     
IF pcFailedReason = "":U 
THEN DO:
    /* Set the user properties on the Appserver, note that these properties will be set client side as well */
    RUN af/app/afgetlngcp.p (INPUT pdLanguageObj, OUTPUT cLanguageCode).
    ASSIGN ptCurrentProcessDate = IF ptCurrentProcessDate = ? THEN TODAY ELSE ptCurrentProcessDate
           cPropertyList        = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow,CurrentLanguageCode":U
                                + ',CachedTranslationsOnly':u
           cValueList           = STRING(pdCurrentUserObj)   + CHR(3) 
                                + pcLoginName                + CHR(3) 
                                + pcCurrentUserName          + CHR(3) 
                                + pcCurrentUserEmail         + CHR(3) 
                                + STRING(pdCompanyObj)       + CHR(3) 
                                + pcCurrentOrganisationCode  + CHR(3) 
                                + pcCurrentOrganisationName  + CHR(3) 
                                + pcCurrentOrganisationShort + CHR(3) 
                                + STRING(pdLanguageObj)      + CHR(3) 
                                + pcCurrentLanguageName      + CHR(3) 
                                + STRING(ptCurrentProcessDate,pcDateFormat) + CHR(3) 
                                + pcCurrentLoginValues       + CHR(3) 
                                + pcDateFormat               + CHR(3) 
                                + pcLoginProc                + CHR(3)
                                + cLanguageCode + chr(3)
                                + string(plCachedTranslationsOnly).
  
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                       INPUT cPropertyList,
                                       INPUT cValueList,
                                       INPUT NO).

    /* Get profile data */
    
    RUN af/app/afbldclicp.p (INPUT "":U,
                             OUTPUT TABLE ttProfileData).    
    ASSIGN phProfileData = TEMP-TABLE ttProfileData:HANDLE.

    /* Get session security data */

    RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
    ASSIGN phSecurityData = TEMP-TABLE ttSecurityControl:HANDLE.
    
    /* Get translation data */    
    if plCachedTranslationsOnly then
        RUN afbldtrncp IN gshTranslationManager
                                 (INPUT pdLanguageObj,
                                 OUTPUT TABLE ttTranslation).    
    ASSIGN phTranslationData = TEMP-TABLE ttTranslation:HANDLE.

    /* Extract result code stuff */
    ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, "CustomizationManager":U).

    RUN rycusfapip IN hCustomizationManager (INPUT pcCustTypesPrioritised, OUTPUT pcTypeAPI) NO-ERROR.

    /* Get session result codes, note we're assuming blank session customisation references to start with.  *
     * Client side, if the cust references are not blank, another Appserver call will be made               *
     * to retrieve the information.  We unfortunately cannot build this list server side.                   */

    RUN rycusrr2rp IN hCustomizationManager
                            (INPUT        pcCustTypesPrioritised,
                             INPUT        pcTypeAPI,
                             INPUT-OUTPUT pcSessionCustRefs,
                             OUTPUT       pcSessionResultCodes) NO-ERROR.

    RUN resolveResultCodes IN gshRepositoryManager (INPUT NO, /* plDesignMode */ INPUT-OUTPUT pcSessionResultCodes) NO-ERROR.
    
    /* Now set the clientResultCodes property, so we know which result codes the client is running against. */
    IF VALID-HANDLE(hCustomizationManager) THEN
        RUN setClientResultCodes IN hCustomizationManager (INPUT pcSessionResultCodes,
                                                           INPUT NO).
    
    /* Now get the security properties, we're going to pass them back to the client as well. These
       values were set in the checkUser() call, but only on the server. If the client needs them,
       and it will for PGEN objects, then we want to avoid the A/S hit. Get them now and avoid Trubble (tm).
     */
    assign pcSecurityPropNames  = 'SecurityEnabled,SecurityGroups,SecurityModel,GSMFFSecurityExists,GSMTOSecurityExists,RYCSOSecurityExists,GSMMISecurityExists,GSMMSSecurityExists'
           pcSecurityPropValues = Dynamic-function('getPropertyList' IN gshSessionManager,
                                                   pcSecurityPropNames, Yes).                                                           
END.    /* no failure */

error-status:error = no.
return.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


