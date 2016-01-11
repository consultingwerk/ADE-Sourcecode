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
  File: afchngpwdp.p

  Description:  Change a users password

  Purpose:      Change a users password
                This procedure first checks the passed in user is valid and
                not disabled (either on user record or user category record).
                The procedure first validates the old password is correct
                similar to the checkUser procedure and returns an error if not.
                Providing the old password is OK, the new password is then
                validated according to the rules set up on the system / user
                record. It checks password minimum length, the password history if
                enabled, etc.
                If all is ok, the new password is saved for the user and appropriate
                user details updated. IF the password was expired, the expiry details
                are reset.

  Parameters:   input user object number if known
                input user login name if known
                input old password (encoded unless blank)
                input new password (encoded unless blank)
                input password expired flag
                input number of password characters entered in new password
                output failure reason (standard Astra formatted error)

  History:
  --------
  (v:010000)    Task:        6018   UserRef:    
                Date:   14/06/2000  Author:     Anthony Swindells

  Update Notes: Write login window

  (v:010001)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: fix locking issues

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afchngpwdp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcLoginName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcOldPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcNewPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plExpired                     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  piLength                      AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iPasswordMaxRetries                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPasswordHistoryLifeTime              AS INTEGER    NO-UNDO.
DEFINE VARIABLE pcText                                AS CHARACTER  NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.38
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF pdUserObj <> 0 THEN
  FIND FIRST gsm_user NO-LOCK
       WHERE gsm_user.USER_obj = pdUserObj
       NO-ERROR.
ELSE IF pcLoginName <> "":U THEN
  FIND FIRST gsm_user NO-LOCK
       WHERE gsm_user.USER_login_name = pcLoginName
       NO-ERROR.

IF NOT AVAILABLE gsm_user THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user specified is invalid'"}.
  RETURN.
END.

/* see if account / categort disabled */
IF gsm_user.DISABLED THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user account is disabled, contact System Administrator'"}.
  RETURN.
END.

FIND FIRST gsm_user_category NO-LOCK
     WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
     NO-ERROR.
IF AVAILABLE gsm_user_category AND gsm_user_category.DISABLED THEN
DO:
  ASSIGN
    pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user category is disabled, contact System Administrator'"}.
  RETURN.
END.

/* check max. retries allowed for password */
IF LENGTH(gsm_user.USER_password) > 0 THEN
  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control THEN
  ASSIGN
    iPasswordMaxRetries = gsc_security_control.password_max_retries
    iPasswordHistoryLifeTime = gsc_security_control.password_history_life_time
    .
ELSE
  ASSIGN
    iPasswordMaxRetries = 0
    iPasswordHistoryLifeTime = 0
    .

ASSIGN pcError = "":U.

DEFINE BUFFER bgsm_user FOR gsm_user.

/* check old password if necessary */
IF pcOldPassword <> gsm_user.user_password THEN
trn-block:
DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'Invalid existing user password specified'"}.

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

/* If get here - old password is ok so update user details */
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

/* now validate new password */
IF gsm_user.password_minimum_length > 0 AND
    piLength < gsm_user.password_minimum_length THEN
DO:
  ASSIGN pcText = "password must be at least " + STRING(gsm_user.password_minimum_length) + " characters":U.
  ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" pcText}.
  RETURN.
END.

IF gsm_user.user_password =  pcNewPassword THEN
DO:
  ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'you cannot use the same password'"}.
  RETURN.
END.

IF gsm_user.check_password_history = YES AND LENGTH(pcNewPassword) > 0 AND
    CAN-FIND(FIRST gst_password_history
             WHERE gst_password_history.user_obj = gsm_user.user_obj
               AND gst_password_history.password_change_date >= (TODAY - iPasswordHistoryLifeTime)
               AND gst_password_history.old_password = pcNewPassword) THEN
DO:             
  ASSIGN pcText = "the same password cannot be used within " + (IF iPasswordHistoryLifeTime > 0 THEN STRING(iPasswordHistoryLifeTime) ELSE "unlimited":U) + " days":U.
  ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" pcText}.
  RETURN.
END.

/* check if password unique */
IF AVAILABLE ttSecurityControl AND ttSecurityControl.force_unique_password = YES THEN
DO:
  IF piLength = 0 OR /* Don't allow blanks if unique is enforced */
              CAN-FIND(FIRST bgsm_user
              WHERE ENCODE(bgsm_user.user_password) = pcNewPassword
                AND bgsm_user.user_obj <> gsm_user.user_obj) THEN 
    DO:         
      ASSIGN pcError = {af/sup2/aferrortxt.i 'GS' '11'}.
      RETURN.
    END.
END.    

/* if get here - we can actually update the user with the new password */
trn-block3:
DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block3, LEAVE trn-block3:

  FIND FIRST bgsm_user EXCLUSIVE-LOCK
       WHERE bgsm_user.user_obj = gsm_user.user_obj
       NO-ERROR.
  IF NOT AVAILABLE bgsm_user THEN
  DO:
    ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'user record is not available'"}.
    UNDO trn-block3, LEAVE trn-block3.
  END.
  ASSIGN
    bgsm_user.user_password = pcNewPassword
    .

  IF plExpired THEN
  DO:
    bgsm_user.password_preexpired = NO.
    bgsm_user.password_expiry_date = bgsm_user.password_expiry_date + 
      (IF bgsm_user.password_expiry_days > 0 THEN bgsm_user.password_expiry_days ELSE 30).              
  END.

  VALIDATE bgsm_user NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    ASSIGN pcError = RETURN-VALUE.
    UNDO trn-block3, LEAVE trn-block3.
  END.
END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


