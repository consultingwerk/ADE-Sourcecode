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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsecmngrp.i

  Description:  Astra Security Manager Code

  Purpose:      The Astra Security Manager is a standard procedure encapsulating all user
                security checks supported by the Astra framework, including token
                checks, field security, data security, menu security, etc.
                The Security Manager is not used to maintain security settings, it is merely
                for performing security checks.
                This include file contains the common code for both the server and client
                security manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        6018   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Add new procedure to security manager to retrieve security control data as a
                temp-table.

  (v:010003)    Task:        6067   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Security Mods. Get product module rather than pass in product module.

  (v:010004)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers

  (v:010005)    Task:        6983   UserRef:    6970
                Date:   31/10/2000  Author:     Marcia Bouwman

  Update Notes: Create a new procedure which returns a comma delimited list of login
                organisations which a user has access to.

  (v:010006)    Task:        6970   UserRef:    
                Date:   02/11/2000  Author:     Marcia Bouwman

  Update Notes: changes made in gs-dev are not compiling

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: New security check for objects

  (v:010200)    Task:    90000156   UserRef:    
                Date:   26/05/2001  Author:     Phil Magnay

  Update Notes: test
                  
  (v:010300)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in main block + various
                procedures.

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsecmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraSecurityManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

/* temp tables for local client cache of information */
DEFINE TEMP-TABLE ttUserSecurityCheck NO-UNDO
FIELD dUserObj                        AS DECIMAL
FIELD dOrganisationObj                AS DECIMAL
FIELD cOwningEntityMnemonic           AS CHARACTER
FIELD dOwningObj                      AS DECIMAL
FIELD lSecurityCleared                AS LOGICAL
FIELD CSecurityValue1                 AS CHARACTER
FIELD CSecurityValue2                 AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY dUserObj dOrganisationObj cOwningEntityMnemonic dOwningObj
.

DEFINE TEMP-TABLE ttFieldSecurityCheck NO-UNDO
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cSecurityOptions                AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttTokenSecurityCheck NO-UNDO
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cSecurityOptions                AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttTableSecurityCheck NO-UNDO
FIELD cOwningEntityMnemonic           AS CHARACTER
FIELD cEntityFieldName                AS CHARACTER
FIELD cValidValues                    AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cOwningEntityMnemonic cEntityFieldName cValidValues
.
DEFINE TEMP-TABLE ttRangeSecurityCheck NO-UNDO
FIELD cRangeCode                      AS CHARACTER
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cRangeFrom                      AS CHARACTER
FIELD cRangeTo                        AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cRangeCode cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttObjectSecurityCheck NO-UNDO
FIELD cObjectName AS CHARACTER
FIELD dObjectObj  AS DECIMAL
FIELD lRestricted AS LOGICAL
INDEX key1 AS UNIQUE PRIMARY cObjectName 
INDEX key2 dObjectObj
.

{af/app/afttsecurityctrl.i}
{dynlaunch.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-areFieldsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areFieldsCached Procedure 
FUNCTION areFieldsCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-areTokensCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areTokensCached Procedure 
FUNCTION areTokensCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.19
         WIDTH              = 57.8.
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
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* This functionality has been moved to the session manager login cache call for the client. */
&IF DEFINED(server-side) <> 0 &THEN
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
    RUN getSecurityControl (OUTPUT TABLE ttSecurityControl).

    FIND FIRST ttSecurityControl NO-ERROR.

    IF NOT AVAILABLE ttSecurityControl OR ttSecurityControl.translation_enabled = YES 
    THEN DO: /* set translation enabled property to true */
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "translationEnabled":U,
                                             INPUT "YES":U,
                                             INPUT NO).
    END.
    ELSE DO: /* set translation enabled property to false */ 
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "translationEnabled":U,
                                             INPUT "NO":U,
                                             INPUT NO).
    END.

    /* Need to empty temp table so that it re-caches after user login so that the default user info is reset */

    EMPTY TEMP-TABLE ttSecurityControl.
END.
&ENDIF

&IF DEFINED(server-side) <> 0 &THEN
  PROCEDURE afusrschkp:         {af/app/afusrschkp.p}     END PROCEDURE.
  PROCEDURE affldschkp:         {af/app/affldschkp.p}     END PROCEDURE.
  PROCEDURE aftabschkp:         {af/app/aftabschkp.p}     END PROCEDURE.
  PROCEDURE aftokschkp:         {af/app/aftokschkp.p}     END PROCEDURE.
  PROCEDURE afranschkp:         {af/app/afranschkp.p}     END PROCEDURE.
  PROCEDURE afgetseccp:         {af/app/afgetseccp.p}     END PROCEDURE.
  PROCEDURE afchngpwdp:         {af/app/afchngpwdp.p}     END PROCEDURE.
  PROCEDURE afchkuserp:         {af/app/afchkuserp.p}     END PROCEDURE.
  PROCEDURE afusrlgnop:         {af/app/afusrlgnop.p}     END PROCEDURE.
  PROCEDURE afobjschkp:         {af/app/afobjschkp.p}     END PROCEDURE.
&ENDIF

/* Listen for the clearing of the Repository cache. If the repository cache is cleared, then we need
 * to signal the Security cache that it is also to be refreshed.                                        */
SUBSCRIBE TO "repositoryCacheCleared" ANYWHERE RUN-PROCEDURE "clearClientCache":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-changePassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePassword Procedure 
PROCEDURE changePassword :
/*------------------------------------------------------------------------------
  Purpose:     To change a users password, doing all relevant checks in password
               history, etc.
  Parameters:  input user object number if known
               input user login name if known
               input old password (encoded)
               input new password (encoded)
               input password expired flag
               input number of password characters entered in new password
               output failure reason (standard Astra formatted error)
  Notes:       This procedure first checks the passed in user is valid and
               not disabled (either on user record or user category record).
               The procedure first validates the old password is correct
               similar to the checkUser procedure and returns an error if not.
               Providing the old password is OK, the new password is then 
               validated according to the rules set up on the system / user
               record. It checks password minimum length, the password history if
               enabled, etc.
               If all is ok, the new password is saved for the user and appropriate
               user details updated. If the password was expired, the expiry details
               are reset.

------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcLoginName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcOldPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcNewPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plExpired                     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  piLength                      AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                       AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) <> 0 &THEN
  RUN afchngpwdp (INPUT pdUserObj,
                  INPUT pcLoginName,
                  INPUT pcOldPassword,
                  INPUT pcNewPassword,
                  INPUT plExpired,
                  INPUT piLength,
                  OUTPUT pcError).  
&ELSE
  RUN af/app/afchngpwdp.p ON gshAstraAppserver (INPUT pdUserObj,
                                                INPUT pcLoginName,
                                                INPUT pcOldPassword,
                                                INPUT pcNewPassword,
                                                INPUT plExpired,
                                                INPUT piLength,
                                                OUTPUT pcError).
&ENDIF

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkUser Procedure 
PROCEDURE checkUser :
/*------------------------------------------------------------------------------
  Purpose:     This procedure authenticates passed in user / company, etc.
  Parameters:  input user login name
               input encoded user password
               input login company obj specified
               input language obj specified
               output login user object number
               output user full name
               output user email
               output organisation code
               output organisation name
               output organisation short name
               output language name
               output failure reason (standard Astra formatted error)
  Notes:       This procedure does not cache as we always want the very
               latest information, i.e. how many times they have failed
               to enter the correct password.
               The following checks are made on the user details entered:
               1. We check if this is a valid user and if not, we return an
               error stating that an invalid login name was specified.
               2. We check if the account has been disabled, and return an
               error if it has.
               3. We check the category of user and see if this category of
               user has been disabled - returning an error if so.
               4. If in AstraGen, we check the login company specified is a
               valid login company. We then check if the user has access to the
               login company, and if not, return an errr.
               5. If in AstraGen, we also check whether the user has restricted
               access to any login companies. If they have restricted access to
               any companies at all, then they must log into the system with a 
               valid company and the <none> option is not available to them. This
               is very useful when letting external clients into your application
               to prevent them seeing other clients information.
               6. If multi-user checking is enabled, we see if the user is already
               logged in and prevent login if so.
               7. We then check the password entered is valid for the user if indeed
               a password was entered. If the password is not valid, then the fail
               count is updated on the user record, and if this exceeds the maximum
               retries, the account will be additionally disabled and the retries
               reset back to 0.
               8. If a valid password is entered, the fail count should be reset, and
               the login details updated on the user.
               9. If the user password has expired, then we need to return this fact
               back to the login window so that it can prompt for a new password
               before proceeding with the login. If this fails, the login will be
               aborted.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcLoginName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcPassword                    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdCompanyObj                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdLanguageObj                 AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcUserName                    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcUserEmail                   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationCode            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationName            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationShort           AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcLanguageName                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                       AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) <> 0 &THEN
  RUN afchkuserp (INPUT pcLoginName,
                  INPUT pcPassword,
                  INPUT pdCompanyObj,
                  INPUT pdLanguageObj,
                  OUTPUT pdUserObj,
                  OUTPUT pcUserName,
                  OUTPUT pcUserEmail,
                  OUTPUT pcOrganisationCode,
                  OUTPUT pcOrganisationName,
                  OUTPUT pcOrganisationShort,
                  OUTPUT pcLanguageName,
                  OUTPUT pcError).  
&ELSE
  RUN af/app/afchkuserp.p ON gshAstraAppserver (INPUT pcLoginName,
                                                INPUT pcPassword,
                                                INPUT pdCompanyObj,
                                                INPUT pdLanguageObj,
                                                OUTPUT pdUserObj,
                                                OUTPUT pcUserName,
                                                OUTPUT pcUserEmail,
                                                OUTPUT pcOrganisationCode,
                                                OUTPUT pcOrganisationName,
                                                OUTPUT pcOrganisationShort,
                                                OUTPUT pcLanguageName,
                                                OUTPUT pcError).
&ENDIF

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearClientCache Procedure 
PROCEDURE clearClientCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               security maintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               security settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
  EMPTY TEMP-TABLE ttUserSecurityCheck.
  EMPTY TEMP-TABLE ttFieldSecurityCheck.
  EMPTY TEMP-TABLE ttTokenSecurityCheck.
  EMPTY TEMP-TABLE ttRangeSecurityCheck.
  EMPTY TEMP-TABLE ttTableSecurityCheck.
  EMPTY TEMP-TABLE ttSecurityControl.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldSecurityCheck Procedure 
PROCEDURE fieldSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for fields permitted
               access to.
  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of secured
               fields, each with 2 entries. 
               Entry 1 = table.fieldname,
               Entry 2 = hidden/read-only
  Notes:       See Dynamics Security Documentation for full information.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions               AS CHARACTER    NO-UNDO.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttFieldSecurityCheck
           WHERE ttFieldSecurityCheck.cObjectName = pcObjectName
             AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
           NO-ERROR.

      IF AVAILABLE ttFieldSecurityCheck 
      THEN DO:
          ASSIGN pcSecurityOptions = ttFieldSecurityCheck.cSecurityOptions.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) <> 0 &THEN
      RUN affldschkp (INPUT pcObjectName,
                      INPUT pcAttributeCode,
                      OUTPUT pcSecurityOptions).  
  &ELSE
      RUN af/app/affldschkp.p ON gshAstraAppserver (INPUT pcObjectName,
                                                    INPUT pcAttributeCode,
                                                    OUTPUT pcSecurityOptions).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttFieldSecurityCheck.
      ASSIGN ttFieldSecurityCheck.cObjectName = pcObjectName
             ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
             ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityGet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldSecurityGet Procedure 
PROCEDURE fieldSecurityGet :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check fields secured for the passed in object.
               If a valid procedure handle is passed in, and the object has been secured
               by the repository manager already, the security stored in the object
               will be used.  If we can't find the security in the object, we'll fetch
               the applicable security from the db/Appserver and return it (by running
               the fieldSecurityCheck procedure).
  Parameters:  phObject          - The handle to the object being checked.  This parameter
                                   is optional.  If not specified, a standard security check
                                   will be done using the object name.
               pcObjectName      - The name of the object being checked. (Mandatory)
               pcAttributeCode   - The attribute code of the object being checked. (Mandatory)
               pcSecurityOptions - The list of secured fields.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject          AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER    NO-UNDO.

DEFINE BUFFER ttFieldSecurityCheck FOR ttFieldSecurityCheck.

DEFINE VARIABLE lObjectSecured AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurity      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCnt           AS INTEGER    NO-UNDO.

IF (pcObjectName = "" OR pcObjectName = ?)
AND VALID-HANDLE(phObject)
THEN DO:
    {get logicalObjectName pcObjectName phObject}.
END.

/* Always check the cache first */
FIND FIRST ttFieldSecurityCheck
     WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
       AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.

IF AVAILABLE ttFieldSecurityCheck 
THEN DO:
    ASSIGN pcSecurityOptions = ttFieldSecurityCheck.cSecurityOptions.
    RETURN.
END.

/* Has the object been secured?  No use in trying to get security from it if it hasn't... */
IF VALID-HANDLE(phObject)
THEN then-blk: DO:
    {get objectSecured lObjectSecured phObject}.
    
    IF lObjectSecured 
    THEN DO:
        {get FieldSecurity cSecurity phObject}.
        IF cSecurity = "":U
        OR cSecurity = ? THEN
            LEAVE then-blk.

        /* Browsers have their list of fields in the displayedFields property */
        {get ObjectType cObjectType phObject}.
        CASE cObjectType:
            WHEN "smartDataBrowser":U THEN
                IF LOOKUP("getDisplayedFields":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
                    {get displayedFields cFields phObject}.

            OTHERWISE
                IF LOOKUP("allFieldNames":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
                    {get allFieldNames cFields phObject}.
        END CASE.
        IF cFields = "":U
        OR cFields = ? 
        OR NUM-ENTRIES(cFields) <> NUM-ENTRIES(cSecurity) THEN
            LEAVE then-blk.

        /* We've got the list of fields and the list of security, now merge them into one list */
        DO iCnt = 1 TO NUM-ENTRIES(cFields):
            ASSIGN pcSecurityOptions = pcSecurityOptions + ",":U + ENTRY(iCnt, cFields) + "," + ENTRY(iCnt, cSecurity).
        END.
        ASSIGN pcSecurityOptions = SUBSTRING(pcSecurityOptions, 2) NO-ERROR.

        /* Add the security to the security manager cache. */
        CREATE ttFieldSecurityCheck.
        ASSIGN ttFieldSecurityCheck.cObjectName      = pcObjectName
               ttFieldSecurityCheck.cAttributeCode   = pcAttributeCode
               ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions.
        RETURN.
    END.
END.

/* If we can't find the name of the object we're trying to extract security for, return. */
IF pcObjectName = ?
OR pcObjectName = "":U THEN
    RETURN.

/* If we get here, the object hasn't been secured yet.  We're going to have to get security from the database/Appserver. */
RUN fieldSecurityCheck (INPUT pcObjectName,
                        INPUT pcAttributeCode,
                        OUTPUT pcSecurityOptions).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFieldSecurity Procedure 
PROCEDURE getFieldSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows you to pass in a list of CHR(1) seperated 
               field names. It will then return a comma seperated list of how 
               the fields are secured.  Entry 1 in the field list will correspond 
               to entry 1 in the 'how secured' list, and so on...
  Parameters:  pcFieldList    - The fields to check
               pcSecurityList - The list of security
  Notes:       This API has been written to check field security for audit trails 
               specifically, as we cannot determine which object or container
               the field was updated from.  We'll check if the field has been 
               secured anywhere, and apply the most restrictive security if set
               up.  Rather safe than sorry...
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFieldList    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityList AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    /* We need to pass the request to the Appserver */
    {
     dynlaunch.i &PLIP              = "'SecurityManager'"
                 &iProc             = "'getFieldSecurity'"
                 &compileStaticCall = NO
                 &mode1  = INPUT  &parm1  = pcFieldList    &dataType1  = CHARACTER
                 &mode2  = OUTPUT &parm2  = pcSecurityList &dataType2  = CHARACTER
    }
    IF lRunErrorStatus = YES THEN
        ASSIGN pcSecurityList = "":U.
&ELSE
    DEFINE VARIABLE iFieldCnt           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cProperties         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUserObj            AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dOrganisationObj    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lSecurityRestricted AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSecurityValue1     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecurityValue2     AS CHARACTER  NO-UNDO.

    DEFINE BUFFER gsm_field              FOR gsm_field.
    DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
    DEFINE BUFFER gsc_security_control   FOR gsc_security_control.

    /* First, initialize the security list by ensuring it has the same number of *
     * entries as the field list                                                 */
    ASSIGN pcSecurityList = FILL(",":U, NUM-ENTRIES(pcFieldList, CHR(1)) - 1).

    /* If security is disabled, return */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_security_control OR gsc_security_control.security_enabled = NO THEN
        RETURN.

    /* Find out who the user is and which company he's logged into */
    ASSIGN cProperties      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "currentUserObj,currentOrganisationObj":U, INPUT YES)
           dUserObj         = DECIMAL(ENTRY(1, cProperties, CHR(3)))
           dOrganisationObj = DECIMAL(ENTRY(2, cProperties, CHR(3)))
           NO-ERROR.

    /* Cycle through the fields sent, and check for security against them */    
    do-blk:
    DO iFieldCnt = 1 TO NUM-ENTRIES(pcFieldList, CHR(1)):

        FIND gsm_field NO-LOCK
             WHERE gsm_field.field_name = ENTRY(iFieldCnt, pcFieldList, CHR(1))
             NO-ERROR.

        IF NOT AVAILABLE gsm_field THEN
            NEXT do-blk.

        FOR EACH gsm_security_structure NO-LOCK
           WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U
             AND gsm_security_structure.owning_obj             = gsm_field.field_obj:

            /* Check if any security has been set applicable to this user */
            RUN afusrschkp (INPUT  dUserObj,
                            INPUT  dOrganisationObj,
                            INPUT  "GSMSS":U,
                            INPUT  gsm_security_structure.security_structure_obj,
                            INPUT  YES, /* Return Values? */
                            OUTPUT lSecurityRestricted,
                            OUTPUT cSecurityValue1,
                            OUTPUT cSecurityValue2).

            /* We're dealing with fields, so securityValue1 should contain how the field is secured */

            IF  lSecurityRestricted = YES 
            AND cSecurityValue1 <> "":U                             /* must be HIDDEN or READ ONLY then */
            AND ENTRY(iFieldCnt, pcSecurityList) <> "HIDDEN":U THEN /* If HIDDEN, leave it that way (most restrictive) */
                ASSIGN ENTRY(iFieldCnt, pcSecurityList) = cSecurityValue1 NO-ERROR.
        END.
    END.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMandatoryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMandatoryTables Procedure 
PROCEDURE getMandatoryTables :
/*------------------------------------------------------------------------------
  Purpose:     A field is passed to this procedure, it will then run through the
               connected databases, and determine on which tables the specified
               field is mandatory.  If running Appserver, it will then run itself
               on the Appserver, to determine mandatory tables for databases connected
               to the Appserver.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER        pcFieldName AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcTableList AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iCnt       AS INTEGER    NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFile      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFilename  AS HANDLE     NO-UNDO.

/* First, check if the specified field is mandatory on any table in any connected db */

IF NUM-DBS <> 0 
THEN DO iCnt = 1 TO NUM-DBS:

    CREATE BUFFER hField FOR TABLE LDBNAME(iCnt) + "._field":U.
    CREATE BUFFER hFile  FOR TABLE LDBNAME(iCnt) + "._file":U.

    ASSIGN hFilename = hFile:BUFFER-FIELD("_file-name":U).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hField,hFile).
    hQuery:QUERY-PREPARE("FOR EACH ":U + LDBNAME(iCnt) + "." + hField:NAME + " NO-LOCK":U
                         + " WHERE ":U + LDBNAME(iCnt) + "." + hField:NAME + "._field-name = '":U + pcFieldName + "'":U
                         +   " AND ":U + LDBNAME(iCnt) + "." + hField:NAME + "._mandatory  = YES,":U
                         + " FIRST ":U + LDBNAME(iCnt) + "." + hFile:NAME  + " NO-LOCK OF ":U + LDBNAME(iCnt) + "." + hField:NAME
                        ).
    hQuery:QUERY-OPEN().

    /* Cycle through all mandatory fields with the name supplied */

    hQuery:GET-FIRST().
    DO WHILE hField:AVAILABLE:

        IF LOOKUP(LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE, pcTableList) = 0
        OR LOOKUP(LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE, pcTableList) = ? THEN
            ASSIGN pcTableList = pcTableList + ",":U + LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE. /* dbname - tablename */

        hQuery:GET-NEXT().
    END.

    hQuery:QUERY-CLOSE().

    DELETE OBJECT hField NO-ERROR.
    DELETE OBJECT hFile  NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.

    ASSIGN hQuery    = ?
           hField    = ?
           hFile     = ?
           hFileName = ?.
END.
IF SUBSTRING(pcTableList,1,1) = ",":U THEN
    ASSIGN pcTableList = SUBSTRING(pcTableList,2).

&IF DEFINED(Client-Side) <> 0 &THEN
/* If we're client side, we've checked all db connections on the client, now check connected dbs on the Appserver */
{
 dynlaunch.i &PLIP              = "'SecurityManager'"
             &iProc             = "'getMandatoryTables'"
             &compileStaticCall = NO
             &mode1  = INPUT        &parm1  = pcFieldName &dataType1  = CHARACTER
             &mode2  = INPUT-OUTPUT &parm2  = pcTableList &dataType2  = CHARACTER
}
IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityControl Procedure 
PROCEDURE getSecurityControl :
/*------------------------------------------------------------------------------
  Purpose:     To return the security control details in the form of a temp-table.
  Parameters:  output table containing single security control record
  Notes:       If the temp-table is empty, then it first goes to the appserver
               to read the details and populate the temp-table. If any of the
               security control,settings are changed in a session, the clear
               cache procedure could be run and then this procedure will pick up
               the new details.
               On the server, we must always access the database to get the
               information.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttSecurityControl.

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  &IF DEFINED(server-side) <> 0 &THEN
    RUN afgetseccp (OUTPUT TABLE ttSecurityControl).  
  &ELSE
    RUN af/app/afgetseccp.p ON gshAstraAppserver (OUTPUT TABLE ttSecurityControl).
  &ENDIF
END.
FIND FIRST ttSecurityControl NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectSecurityCheck Procedure 
PROCEDURE objectSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for objects permitted
               to run.

  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of security tokens
               user does not have security clearance for, currently used in toolbar
               panel views to disable buttons and folder windows to disable
               folder pages, etc.

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER  pdObjectObj                     AS DECIMAL      NO-UNDO.
  DEFINE OUTPUT       PARAMETER  plSecurityRestricted            AS LOGICAL      NO-UNDO.

  IF pcObjectName = ? THEN ASSIGN pcObjectName = "":U.
  IF pdObjectObj  = ? THEN ASSIGN pdObjectObj  = 0.

  /* If we're on the client, check the cache first.  Server side we don't have a cache. */

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      /* Find on the object name */
      FIND ttObjectSecurityCheck
           WHERE ttObjectSecurityCheck.cObjectName = pcObjectName
           NO-ERROR.

      /* Find on the object obj */
      IF NOT AVAILABLE ttObjectSecurityCheck THEN
          FIND ttObjectSecurityCheck
               WHERE ttObjectSecurityCheck.dObjectObj = pdObjectObj
               NO-ERROR.
    
      IF AVAILABLE ttObjectSecurityCheck 
      THEN DO:
          ASSIGN plSecurityRestricted = ttObjectSecurityCheck.lRestricted
                 ERROR-STATUS:ERROR   = NO.
          RETURN "":U.
      END.
  END.

  /* Run afobjschkp to retrieve object security */

  &IF DEFINED(server-side) <> 0 &THEN
  RUN afobjschkp (INPUT-OUTPUT  pcObjectName,
                  INPUT-OUTPUT  pdObjectObj,
                  OUTPUT        plSecurityRestricted).  
  &ELSE
  RUN af/app/afobjschkp.p ON gshAstraAppserver (INPUT-OUTPUT  pcObjectName, /* We'll get ryc_smartobject.object_filename back */
                                                INPUT-OUTPUT  pdObjectObj,  /* We'll get ryc_smartobject.smartobject_obj back */
                                                OUTPUT        plSecurityRestricted).
  &ENDIF

  /* If we're client side, add the result to the cache. */

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      IF  pcObjectName <> "":U
      AND pdObjectObj <> 0 
      THEN DO:
          /* We have to check for the record in the cache because pcObjectName in could differ from pcObjectName out */
          IF NOT CAN-FIND(FIRST ttObjectSecurityCheck
                          WHERE ttObjectSecurityCheck.cObjectName = pcObjectName
                            AND ttObjectSecurityCheck.dObjectObj  = pdObjectObj) 
          THEN DO:
              CREATE ttObjectSecurityCheck.
              ASSIGN ttObjectSecurityCheck.cObjectName = pcObjectName
                     ttObjectSecurityCheck.dObjectObj  = pdObjectObj
                     ttObjectSecurityCheck.lRestricted = plSecurityRestricted.
          END.
      END.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rangeSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rangeSecurityCheck Procedure 
PROCEDURE rangeSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for the passed in range
               code.

  Parameters:   input range code to check user security clearance for
                input current program object for security check
                input instance attribute posted to program
                output from value permitted for user, "" = all
                output to value permitted for user, "" = all

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcRangeCode                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeFrom                     AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeTo                       AS CHARACTER    NO-UNDO.

  ASSIGN
      pcRangeFrom = "":U
      pcRangeTo = "":U
      .

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    FIND FIRST ttRangeSecurityCheck
         WHERE ttRangeSecurityCheck.cRangeCode = pcRangeCode
           AND ttRangeSecurityCheck.cObjectName = pcObjectName
           AND ttRangeSecurityCheck.cAttributeCode = pcAttributeCode
         NO-ERROR.
    IF AVAILABLE ttRangeSecurityCheck THEN
    DO:
      ASSIGN
        pcRangeFrom = ttRangeSecurityCheck.cRangeFrom
        pcRangeTo = ttRangeSecurityCheck.cRangeTo
        .
      RETURN.        
    END.
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

  &IF DEFINED(server-side) <> 0 &THEN
    RUN afranschkp (INPUT pcRangeCode,
                    INPUT pcObjectName,
                    INPUT pcAttributeCode,
                    OUTPUT pcRangeFrom,
                    OUTPUT pcRangeTo).  
  &ELSE
    RUN af/app/afranschkp.p ON gshAstraAppserver (INPUT pcRangeCode,
                                                  INPUT pcObjectName,
                                                  INPUT pcAttributeCode,
                                                  OUTPUT pcRangeFrom,
                                                  OUTPUT pcRangeTo).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    CREATE ttRangeSecurityCheck.
    ASSIGN
      ttRangeSecurityCheck.cRangeCode = pcRangeCode
      ttRangeSecurityCheck.cObjectName = pcObjectName
      ttRangeSecurityCheck.cAttributeCode = pcAttributeCode
      ttRangeSecurityCheck.cRangeFrom = pcRangeFrom
      ttRangeSecurityCheck.cRangeTo = pcRangeTo
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheFldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheFldSecurity Procedure 
PROCEDURE receiveCacheFldSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows external procedures to supplement the security
               cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSecurityOptions AS CHARACTER  NO-UNDO.
DEFINE BUFFER ttFieldSecurityCheck FOR ttFieldSecurityCheck.
FIND FIRST ttFieldSecurityCheck
     WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
       AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.
IF NOT AVAILABLE ttFieldSecurityCheck 
THEN DO:
    CREATE ttFieldSecurityCheck.
    ASSIGN ttFieldSecurityCheck.cObjectName      = pcObjectName
           ttFieldSecurityCheck.cAttributeCode   = pcAttributeCode.
END.
ASSIGN ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions
       ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheSessionSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheSessionSecurity Procedure 
PROCEDURE receiveCacheSessionSecurity :
/*------------------------------------------------------------------------------
  Purpose:     Receives the initial session security cache
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttSecurityControl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheTokSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheTokSecurity Procedure 
PROCEDURE receiveCacheTokSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows external procedures to supplement the security
               cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSecurityOptions AS CHARACTER  NO-UNDO.
DEFINE BUFFER ttTokenSecurityCheck FOR ttTokenSecurityCheck.
FIND FIRST ttTokenSecurityCheck
     WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
       AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.
IF NOT AVAILABLE ttTokenSecurityCheck 
THEN DO:
    CREATE ttTokenSecurityCheck.
    ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
           ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode.
END.
ASSIGN ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions
       ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableSecurityCheck Procedure 
PROCEDURE tableSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for table field values
               permitted access to.

  Parameters:  Input table FLA to check user security clearance for
               Input field name with no table prefix
               Output comma seperated list of valid values, "" = all

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcOwningEntityMnemonic          AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcEntityFieldName               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcValidValues                   AS CHARACTER    NO-UNDO.

  ASSIGN
      pcValidValues = "":U
      .

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    FIND FIRST ttTableSecurityCheck
         WHERE ttTableSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
           AND ttTableSecurityCheck.cEntityFieldName = pcEntityFieldName
         NO-ERROR.
    IF AVAILABLE ttTableSecurityCheck THEN
    DO:
      ASSIGN
        pcValidValues = ttTableSecurityCheck.cValidValues
        .
      RETURN.        
    END.
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

  &IF DEFINED(server-side) <> 0 &THEN
    RUN aftabschkp (INPUT pcOwningEntityMnemonic,
                    INPUT pcEntityFieldName,
                    OUTPUT pcValidValues).  
  &ELSE
    RUN af/app/aftabschkp.p ON gshAstraAppserver (INPUT pcOwningEntityMnemonic,
                                                  INPUT pcEntityFieldName,
                                                  OUTPUT pcValidValues).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    CREATE ttTableSecurityCheck.
    ASSIGN
      ttTableSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
      ttTableSecurityCheck.cEntityFieldName = pcEntityFieldName
      ttTableSecurityCheck.cValidValues = pcValidValues
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tokenSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tokenSecurityCheck Procedure 
PROCEDURE tokenSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for tokens permitted
               access to.

  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of security tokens
               user does not have security clearance for, currently used in toolbar
               panel views to disable buttons and folder windows to disable
               folder pages, etc.

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER NO-UNDO.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttTokenSecurityCheck
           WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
             AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
           NO-ERROR.

      IF AVAILABLE ttTokenSecurityCheck 
      THEN DO:
          ASSIGN pcSecurityOptions = ttTokenSecurityCheck.cSecurityOptions.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) <> 0 &THEN
      RUN aftokschkp (INPUT pcObjectName,
                      INPUT pcAttributeCode,
                      OUTPUT pcSecurityOptions).  
  &ELSE
      RUN af/app/aftokschkp.p ON gshAstraAppserver (INPUT pcObjectName,
                                                    INPUT pcAttributeCode,
                                                    OUTPUT pcSecurityOptions).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttTokenSecurityCheck.
      ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
             ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode
             ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tokenSecurityGet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tokenSecurityGet Procedure 
PROCEDURE tokenSecurityGet :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check tokens secured for the passed in object.
               If a valid procedure handle is passed in, and the object has been secured
               by the repository manager already, the security stored in the object
               will be used.  If we can't find the security in the object, we'll fetch
               the applicable security from the db/Appserver and return it (by running
               the tokenSecurityCheck procedure).
  Parameters:  phObject          - The handle to the object being checked.  This parameter
                                   is optional.  If not specified, a standard security check
                                   will be done using the object name.
               pcObjectName      - The name of the object being checked. (Mandatory)
               pcAttributeCode   - The attribute code of the object being checked. (Mandatory)
               pcSecurityOptions - The list of secured fields.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject          AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER    NO-UNDO.

DEFINE BUFFER ttTokenSecurityCheck FOR ttTokenSecurityCheck.

DEFINE VARIABLE lObjectSecured AS LOGICAL    NO-UNDO.

/* Always check the cache first */
FIND FIRST ttTokenSecurityCheck
     WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
       AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.

IF AVAILABLE ttTokenSecurityCheck 
THEN DO:
    ASSIGN pcSecurityOptions = ttTokenSecurityCheck.cSecurityOptions.
    RETURN.
END.

/* Has the object been secured?  No use in trying to get security from it if it hasn't... */
IF VALID-HANDLE(phObject)
THEN DO:
    {get objectSecured lObjectSecured phObject}.
    IF lObjectSecured
    THEN DO:
        {get SecuredTokens pcSecurityOptions phObject}.

        /* Add the security to the security manager cache if its not in yet. */
        CREATE ttTokenSecurityCheck.
        ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
               ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode
               ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions.
        RETURN.
    END.
END.

/* If we get here, the object hasn't been secured yet.  We're going to have to get security from the database/Appserver. */
RUN tokenSecurityCheck (INPUT pcObjectName,
                        INPUT pcAttributeCode,
                        OUTPUT pcSecurityOptions).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userLoginOrganisations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE userLoginOrganisations Procedure 
PROCEDURE userLoginOrganisations :
/*------------------------------------------------------------------------------
  Purpose:     To check which Organisations a user has access to.
  Parameters:  Input the User Obj
               Output a comma delimited list of list pairs i.e. 
               organisation obj, name of organisation, organisation obj, name of organisation etc. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOrganisations             AS CHARACTER    NO-UNDO.


    &IF DEFINED(server-side) <> 0 &THEN
        RUN afusrlgnop (INPUT  pdUserObj,
                        OUTPUT pcOrganisations).
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
        RUN af/app/afusrlgnop.p ON gshAstraAppserver  (INPUT  pdUserObj,
                                                       OUTPUT pcOrganisations).
    &ENDIF

    IF SUBSTRING(pcOrganisations,LENGTH(pcOrganisations)) = ","  THEN
        ASSIGN pcOrganisations = SUBSTRING(pcOrganisations,1,(LENGTH(pcOrganisations) - 1)).


RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE userSecurityCheck Procedure 
PROCEDURE userSecurityCheck :
/*------------------------------------------------------------------------------
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
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pdOrganisationObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcOwningEntityMnemonic      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pdOwningObj                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  plReturnValues              AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER plSecurityRestricted        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue1            AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue2            AS CHARACTER    NO-UNDO.


  ASSIGN
      plSecurityRestricted = YES
      pcSecurityValue1 = "":U
      pcSecurityValue2 = "":U
      .

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    FIND FIRST ttUserSecurityCheck
         WHERE ttUserSecurityCheck.dUserObj = pdUserObj
           AND ttUserSecurityCheck.dOrganisationObj = pdOrganisationObj
           AND ttUserSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
           AND ttUserSecurityCheck.dOwningObj = pdOwningObj
         NO-ERROR.
    IF AVAILABLE ttUserSecurityCheck THEN
    DO:
      ASSIGN
        plSecurityRestricted = NOT ttUserSecurityCheck.lSecurityCleared
        pcSecurityValue1     = ttUserSecurityCheck.cSecurityValue1
        pcSecurityValue2     = ttUserSecurityCheck.cSecurityValue2
        .
      RETURN.        
    END.
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

  &IF DEFINED(server-side) <> 0 &THEN
    RUN afusrschkp (INPUT pdUserObj,
                    INPUT pdOrganisationObj,
                    INPUT pcOwningEntityMnemonic,
                    INPUT pdOwningObj,
                    INPUT  plReturnValues,
                    OUTPUT plSecurityRestricted,
                    OUTPUT pcSecurityValue1,
                    OUTPUT pcSecurityValue2).  
  &ELSE
    RUN af/app/afusrschkp.p ON gshAstraAppserver (INPUT pdUserObj,
                                                  INPUT pdOrganisationObj,
                                                  INPUT pcOwningEntityMnemonic,
                                                  INPUT pdOwningObj,
                                                  INPUT  plReturnValues,
                                                  OUTPUT plSecurityRestricted,
                                                  OUTPUT pcSecurityValue1,
                                                  OUTPUT pcSecurityValue2).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  DO:
    CREATE ttUserSecurityCheck.
    ASSIGN
      ttUserSecurityCheck.dUserObj = pdUserObj
      ttUserSecurityCheck.dOrganisationObj = pdOrganisationObj
      ttUserSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
      ttUserSecurityCheck.dOwningObj = pdOwningObj
      ttUserSecurityCheck.lSecurityCleared = NOT plSecurityRestricted
      ttUserSecurityCheck.cSecurityValue1 = pcSecurityValue1
      ttUserSecurityCheck.cSecurityValue2 = pcSecurityValue2
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-areFieldsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areFieldsCached Procedure 
FUNCTION areFieldsCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates if security fields for a specific object have been cached.
    Notes:  
------------------------------------------------------------------------------*/
RETURN CAN-FIND(FIRST ttFieldSecurityCheck
                WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
                  AND ttFieldSecurityCheck.cAttributeCode = pcRunAttribute).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-areTokensCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areTokensCached Procedure 
FUNCTION areTokensCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates if security tokens for a specific object have been cached.
    Notes:  
------------------------------------------------------------------------------*/
RETURN CAN-FIND(FIRST ttTokenSecurityCheck
                WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
                  AND ttTokenSecurityCheck.cAttributeCode = pcRunAttribute).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

