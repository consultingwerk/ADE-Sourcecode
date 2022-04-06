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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsetpdatp.p

  Description:  Set user profile data

  Purpose:      Set user profile data
                Procedure to update user profile data to database for logged
                in user.
                This procedure supports the setting of multiple profile data to
                a single value / deleting multiple profile data, simply by leaving
                certain of the input parameters blank indicating all.
                If a rowid is passed in then the record to set will be found using the
                rowid rather than the individual profile fields. Obviously the record
                must already exist in this case to be set in this way. The rowid will
                be the rowid of the database record. Also note that
                passing in a rowid will take precendence over any other input paramaters.
                If save flag is set to session, then store session id in context id
                field, otherwise leave the field blank to indicate permanent value.
                If delete flag is set to YES, then the data value will be deleted from
                the database.

  Parameters:   input profile type code
                input profile code (blank = all)
                input profile data key (blank = all)
                input rowid of profile data (if known)
                input profile data value
                input delete flag (YES = delete profile data)
                input save flag (SES = Session only, PER = Permanent)

  History:
  --------
  (v:010000)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager and Translation Manager / update supporting
                files

  (v:010001)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: locking issues

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsetpdatp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  prRowid                       AS ROWID      NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataValue            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFlag                  AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcSaveFlag                    AS CHARACTER  NO-UNDO.

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

  DEFINE VARIABLE cUserObj                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dUserObj                  AS DECIMAL INITIAL 0 NO-UNDO.

  cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO).
  ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

  DEFINE VARIABLE cError                                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextId                            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dStartCodeObj                         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dEndCodeObj                           AS DECIMAL    NO-UNDO.

  IF pcSaveFlag = "PER":U THEN
    ASSIGN cContextId = "":U.
  ELSE
    ASSIGN cContextId = gscSessionID.

  DEFINE BUFFER bgsm_profile_data FOR gsm_profile_data.

  IF dUserObj > 0 THEN
  trn-block:
  DO FOR bgsm_profile_data TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
    /* If rowid passed in, data must exist to be updated / deleted and session only setting ignored */
    IF prRowid <> ? THEN
    DO:
      FIND FIRST bgsm_profile_data EXCLUSIVE-LOCK
           WHERE ROWID(bgsm_profile_data) = prRowid
           NO-ERROR.  
      IF AVAILABLE bgsm_profile_data AND bgsm_profile_data.USER_obj = dUserObj THEN
      DO:
        IF plDeleteFlag THEN
        DO:
          DELETE bgsm_profile_data NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        ELSE
        DO:
          ASSIGN
            bgsm_profile_data.profile_data_value = pcProfileDataValue.
          VALIDATE bgsm_profile_data NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
      END.
      RETURN.
    END.

    FIND FIRST gsc_profile_type NO-LOCK
         WHERE gsc_profile_type.profile_type_code = pcProfileTypeCode
         NO-ERROR.
    IF NOT AVAILABLE gsc_profile_type THEN
    DO:
      ASSIGN cError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user profile data'" "'an invalid profile type was specified'"}.
      UNDO trn-block, LEAVE trn-block.
    END.

    IF pcProfileCode <> "":U THEN
    DO:
      FIND FIRST gsc_profile_code NO-LOCK
           WHERE gsc_profile_code.profile_code = pcProfileCode
           NO-ERROR.
      IF NOT AVAILABLE gsc_profile_code THEN
      DO:
        ASSIGN cError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user profile data'" "'an invalid profile code was specified'"}.
        UNDO trn-block, LEAVE trn-block.
      END.
    END.
    IF AVAILABLE gsc_profile_code THEN
      ASSIGN
        dStartCodeObj = gsc_profile_code.profile_code_obj
        dEndCodeObj = gsc_profile_code.profile_code_obj
        .
    ELSE
      ASSIGN
        dStartCodeObj = -99999999999999999999
        dEndCodeObj = 99999999999999999999
        .

    /* if wildcards passed in, then just update existing records for appropriate session / permanent setting */
    IF pcProfileCode = "":U OR pcProfileDataKey = "":U THEN
    DO:
      FOR EACH bgsm_profile_data EXCLUSIVE-LOCK
         WHERE bgsm_profile_data.USER_obj = dUserObj
           AND bgsm_profile_data.profile_type_obj = gsc_profile_type.profile_type_obj
           AND bgsm_profile_data.profile_code_obj >= dStartCodeObj
           AND bgsm_profile_data.profile_code_obj <= dEndCodeObj
           AND bgsm_profile_data.profile_data_key BEGINS pcProfileDataKey
           AND bgsm_profile_data.CONTEXT_id = cContextId:

        IF plDeleteFlag THEN
        DO:
          DELETE bgsm_profile_data NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        ELSE
        DO:
          ASSIGN
            bgsm_profile_data.profile_data_value = pcProfileDataValue.
          VALIDATE bgsm_profile_data NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
      END.
      RETURN.
    END.  /* wildcard update */

    /* If get here, we are setting a specific value and if it does not exist, we should create it */
    FIND FIRST bgsm_profile_data EXCLUSIVE-LOCK
         WHERE bgsm_profile_data.USER_obj = dUserObj
           AND bgsm_profile_data.profile_type_obj = gsc_profile_type.profile_type_obj
           AND bgsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
           AND bgsm_profile_data.profile_data_key = pcProfileDataKey
           AND bgsm_profile_data.CONTEXT_id = cContextId
         NO-ERROR.

    IF NOT AVAILABLE bgsm_profile_data AND NOT plDeleteFlag THEN
    DO:
      CREATE bgsm_profile_data NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.

      ASSIGN
        bgsm_profile_data.USER_obj = dUserObj
        bgsm_profile_data.profile_type_obj = gsc_profile_type.profile_type_obj
        bgsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
        bgsm_profile_data.profile_data_key = pcProfileDataKey
        bgsm_profile_data.CONTEXT_id = cContextId
        .
    END.

    IF AVAILABLE bgsm_profile_data AND plDeleteFlag THEN
    DO:
      DELETE bgsm_profile_data NO-ERROR.      
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
    END.
    ELSE IF AVAILABLE bgsm_profile_data THEN
    DO:
      ASSIGN
        bgsm_profile_data.profile_data_value = pcProfileDataValue.
      VALIDATE bgsm_profile_data NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
    END.

  END. /* trn-block */

  IF cError <> "":U THEN
    RETURN ERROR cError.
  ELSE
  DO:
    {af/sup2/afcheckerr.i}
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


