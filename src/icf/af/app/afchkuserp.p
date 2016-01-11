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
  File: afchkuserp.p

  Description:  Authenticates passed in user / company

  Purpose:      Authenticates passed in user / company
                This procedure does not cache as we always want the very
                latest information, i.e. how many times they have failed
                to enter the correct password.
                The following checks are made on the user details entered:
                1. We check if this is a valid user and if not, we return an
                error stating that an invalid login name or password was specified.
                2. We check if the account has been disabled, and return an
                error if it has.
                3. We check the category of user and see if this category of
                user has been disabled - returning an error if so.
                4. If in AstraGen, we check the login company specified is a
                valid login company. We then check if the user has access to the
                login company, and if not, return an errr.
                5. If in AstraGen, we also check whether the user has restricted
                access to any login companies. If they have restricted access to

  Parameters:   input user login name
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

  History:
  --------
  (v:010000)    Task:        6018   UserRef:    
                Date:   14/06/2000  Author:     Anthony Swindells

  Update Notes: Write login window

  (v:010001)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: locking issues

  (v:010002)    Task:    90000031   UserRef:    
                Date:   22/03/2001  Author:     Anthony Swindells

  Update Notes: removal of Astra 1

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Logic changes due to new security allocations methos
  

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afchkuserp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */


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

DEFINE VARIABLE lSecurityRestricted                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityValue1                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSecurityValue2                       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iPasswordMaxRetries                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cDefaultHelpFile                      AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 13.95
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER bgsm_user FOR gsm_user.

/* 1st check user is valid */
FIND FIRST gsm_user NO-LOCK
     WHERE gsm_user.USER_login_name = pcLoginName
     NO-ERROR.

IF NOT AVAILABLE gsm_user THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
  RETURN.
END.

/* see if account / categort disabled */
IF gsm_user.DISABLED THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User account is disabled, contact System Administrator'"}.
  RETURN.
END.

FIND FIRST gsm_user_category NO-LOCK
     WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
     NO-ERROR.
IF AVAILABLE gsm_user_category AND gsm_user_category.DISABLED THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User category is disabled, contact System Administrator'"}.
  RETURN.
END.

/* check user has access to login company specified */
IF pdCompanyObj <> 0 THEN
DO:
  FIND FIRST gsm_login_company NO-LOCK
       WHERE gsm_login_company.login_company_obj = pdCompanyObj
       NO-ERROR.
END.

IF pdCompanyObj <> 0 AND AVAILABLE gsm_login_company THEN
DO:

    lSecurityRestricted = YES.
    RUN userSecurityCheck IN gshSecurityManager (INPUT gsm_user.USER_obj,
                                                 INPUT 0,
                                                 INPUT "gsmlg":U,              /* login company FLA */
                                                 INPUT gsm_login_company.login_company_obj,
                                                 INPUT NO,                     /* Return security values - NO */
                                                 OUTPUT lSecurityRestricted,   /* Restricted yes/no ? */
                                                 OUTPUT cSecurityValue1,       /* clearance value 1 */
                                                 OUTPUT cSecurityValue2).      /* clearance value 2 */
    IF lSecurityRestricted THEN
    DO:
       ASSIGN
          pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User specified does not have access to selected company'"}.
       RETURN.
    END.

END.
ELSE
DO:
    /* ensure ok to login with empty company - i.e. ensure no company restrictions exist */

    IF pdCompanyObj = 0 AND
      CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.user_obj = gsm_user.USER_obj
                 AND gsm_user_allocation.login_organisation_obj = 0
                 AND gsm_user_allocation.owning_entity_mnemonic = "gsmlg":U) THEN
    DO:
      ASSIGN
        pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'A specific login company must be specified for this user'"}.
      RETURN.
    END.

    lSecurityRestricted = NO.
END.




/* should check multi-user login now - but will do later as aflock mechanism will
   not work for Appservers 
*/

/* now check password entered is valid - if user has a password set-up */

/* check max. retries allowed for password */
IF LENGTH(gsm_user.USER_password) > 0 THEN
  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control THEN
  ASSIGN
    iPasswordMaxRetries = gsc_security_control.password_max_retries.
ELSE
  ASSIGN
    iPasswordMaxRetries = 0.

ASSIGN pcError = "":U.
IF LENGTH(gsm_user.USER_password) > 0 AND pcPassword <> gsm_user.user_password THEN
trn-block:
DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.

  FIND FIRST bgsm_user EXCLUSIVE-LOCK 
       WHERE bgsm_user.user_obj = gsm_user.user_obj
       NO-ERROR.
  IF NOT AVAILABLE bgsm_user THEN
    UNDO trn-block, LEAVE trn-block.
  ASSIGN
    bgsm_user.password_fail_count = bgsm_user.password_fail_count + 1
    bgsm_user.password_fail_date = TODAY
    bgsm_user.password_fail_time = TIME.
  IF iPasswordMaxRetries > 0 AND bgsm_user.password_fail_count > iPasswordMaxRetries THEN
    ASSIGN
      bgsm_user.disabled = YES
      bgsm_user.password_fail_count = 0
      pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Maximum password retries exceeded, user account has been disabled'"}
      .
  VALIDATE bgsm_user NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    UNDO trn-block, LEAVE trn-block.
END.
IF pcError <> "":U THEN RETURN.

/* if get here, all is ok, so update user details */
trn-block2:
DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block2, LEAVE trn-block2:

  FIND FIRST bgsm_user EXCLUSIVE-LOCK 
       WHERE bgsm_user.user_obj = gsm_user.user_obj
       NO-ERROR.

  IF NOT AVAILABLE bgsm_user THEN
    UNDO trn-block2, LEAVE trn-block2.
  ASSIGN
    bgsm_user.password_fail_count = 0
    bgsm_user.password_fail_date = ?
    bgsm_user.password_fail_time = 0
    bgsm_user.last_login_date = TODAY 
    bgsm_user.last_login_time = TIME
    bgsm_user.disabled = NO.

  VALIDATE bgsm_user NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    UNDO trn-block2, LEAVE trn-block2.
END.

/* finally check if password expired and if so, return "expired" in error to indicate
   to caller that password must be changed.
*/
IF gsm_user.password_preexpired OR
   (gsm_user.password_expiry_date <> ? AND
    gsm_user.password_expiry_date < TODAY) OR
   (gsm_user.password_expiry_date = TODAY AND
    gsm_user.password_expiry_time <= TIME) THEN
  ASSIGN pcError = "expired":U.

/* pass back rest of details */  
IF pdLanguageObj <> 0 THEN 
DO:
  FIND FIRST gsc_language NO-LOCK
       WHERE gsc_language.LANGUAGE_obj = pdLanguageObj
       NO-ERROR.
END.
ASSIGN
  pdUserObj = gsm_user.USER_obj
  pcUserName = gsm_user.USER_full_name
  pcUserEmail = gsm_user.USER_email_address
  .
IF AVAILABLE gsm_login_company THEN
  ASSIGN
    pcOrganisationCode = gsm_login_company.login_company_code
    pcOrganisationName = gsm_login_company.login_company_name
    pcOrganisationShort = gsm_login_company.login_company_short_name
    . 
IF AVAILABLE gsc_language THEN
  ASSIGN
    pcLanguageName = gsc_language.LANGUAGE_name.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


