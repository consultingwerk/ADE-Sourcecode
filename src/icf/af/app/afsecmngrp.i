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
FIELD cObjectName                     AS CHARACTER
FIELD dObjectObj                      AS DECIMAL
INDEX key1 AS UNIQUE PRIMARY cObjectName 
INDEX key2 dObjectObj
.

{af/app/afttsecurityctrl.i}

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

RUN getSecurityControl (OUTPUT TABLE ttSecurityControl).
FIND FIRST ttSecurityControl NO-ERROR.
IF NOT AVAILABLE ttSecurityControl OR ttSecurityControl.translation_enabled = YES THEN
DO: /* set translation enabled property to true */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT "YES":U,
                                   INPUT NO).
END.
ELSE
DO: /* set translation enabled property to false */ 
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT "NO":U,
                                   INPUT NO).
END.
/* Need to empty temp table so that it re-caches after user login so that
   the default user info is reset */
EMPTY TEMP-TABLE ttSecurityControl.

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
IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
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
               fields, each with 2 entries. Entry 1 = table.fieldname,
               Entry 2 = hidden / view

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions               AS CHARACTER    NO-UNDO.

  ASSIGN
      pcSecurityOptions = "":U
      .

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    FIND FIRST ttFieldSecurityCheck
         WHERE ttFieldSecurityCheck.cObjectName = pcObjectName
           AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
         NO-ERROR.
    IF AVAILABLE ttFieldSecurityCheck THEN
    DO:
      ASSIGN
        pcSecurityOptions = ttFieldSecurityCheck.cSecurityOptions
        .
      RETURN.        
    END.
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttFieldSecurityCheck.
    ASSIGN
      ttFieldSecurityCheck.cObjectName = pcObjectName
      ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
      ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

RETURN.
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

IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR NOT CAN-FIND(FIRST ttSecurityControl) THEN
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


  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    plSecurityRestricted = 
        (IF pdObjectObj NE 0.0 THEN
            CAN-FIND(FIRST ttObjectSecurityCheck
                     WHERE ttObjectSecurityCheck.dObjectObj    = pdObjectObj)
         ELSE
         IF pcObjectName EQ "":U THEN
             CAN-FIND(FIRST ttObjectSecurityCheck
                      WHERE ttObjectSecurityCheck.cObjectName  = pcObjectName)
         ELSE
             FALSE).
    RETURN.        
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

  &IF DEFINED(server-side) <> 0 &THEN
    RUN afobjschkp (INPUT-OUTPUT  pcObjectName,
                    INPUT-OUTPUT  pdObjectObj,
                    OUTPUT        plSecurityRestricted).  
  &ELSE
    RUN af/app/afobjschkp.p ON gshAstraAppserver (INPUT-OUTPUT  pcObjectName,
                                                  INPUT-OUTPUT  pdObjectObj,
                                                  OUTPUT        plSecurityRestricted).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttObjectSecurityCheck.
    ASSIGN
      ttObjectSecurityCheck.cObjectName      = pcObjectName
      ttObjectSecurityCheck.dObjectObj       = pdObjectObj
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
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
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttRangeSecurityCheck.
    ASSIGN
      ttRangeSecurityCheck.cRangeCode = pcRangeCode
      ttRangeSecurityCheck.cObjectName = pcObjectName
      ttRangeSecurityCheck.cAttributeCode = pcAttributeCode
      ttRangeSecurityCheck.cRangeFrom = pcRangeFrom
      ttRangeSecurityCheck.cRangeTo = pcRangeTo
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

RETURN.
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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
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
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttTableSecurityCheck.
    ASSIGN
      ttTableSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
      ttTableSecurityCheck.cEntityFieldName = pcEntityFieldName
      ttTableSecurityCheck.cValidValues = pcValidValues
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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

  DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions               AS CHARACTER    NO-UNDO.

  ASSIGN
      pcSecurityOptions = "":U
      .

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    FIND FIRST ttTokenSecurityCheck
         WHERE ttTokenSecurityCheck.cObjectName = pcObjectName
           AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
         NO-ERROR.
    IF AVAILABLE ttTokenSecurityCheck THEN
    DO:
      ASSIGN
        pcSecurityOptions = ttTokenSecurityCheck.cSecurityOptions
        .
      RETURN.        
    END.
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttTokenSecurityCheck.
    ASSIGN
      ttTokenSecurityCheck.cObjectName = pcObjectName
      ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
      ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions
      .
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

RETURN.
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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
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
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

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
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
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
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

