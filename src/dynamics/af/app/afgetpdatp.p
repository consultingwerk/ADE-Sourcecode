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
  File: afgetpdatp.p

  Description:  Get User Profile Data from Database

  Purpose:      Get User Profile Data from Database
                Called from getProfileData
                Must always check for session data first, then permanent data.
                If a rowid is passed in, then this will be used to find the record.
                If the next flag is set to yes, then a FIND NEXT will be done to
                retrieve the record after the record passed in.

  Parameters:   input profile type code
                input profile code
                input profile data key
                input get next record flag YES/NO
                input-output rowid of record found or ? if not found
                output profile data value if found
                output context id if found session data else blank if found permanent data
                output user object number of profile data found
                output profile type object number of profile data found
                output profile code object number of profile data found
                output flag for server profile type YES/NO

  History:
  --------
  (v:010000)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager and Translation Manager / update supporting
                files

  (v:010002)    Task:        6030   UserRef:    
                Date:   20/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetpdatp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

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

DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plNextRecordFlag              AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER prRowid                 AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER pcProfileDataValue            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcContextId                   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdProfileTypeObj              AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdProfileCodeObj              AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plServerProfileType           AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cUserObj                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dUserObj                              AS DECIMAL INITIAL 0 NO-UNDO.

cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "currentUserObj":U,
                                                   INPUT NO).
ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

IF prRowid <> ? THEN
FIND FIRST gsm_profile_data NO-LOCK
     WHERE ROWID(gsm_profile_data) = prRowid
     NO-ERROR.
IF prRowid = ? OR NOT AVAILABLE gsm_profile_data OR gsm_profile_data.user_obj <> dUserObj THEN
DO:
  FIND FIRST gsc_profile_type NO-LOCK
       WHERE gsc_profile_type.profile_type_code = pcProfileTypeCode
       NO-ERROR.
  IF AVAILABLE gsc_profile_type THEN
    FIND FIRST gsc_profile_code NO-LOCK                 
         WHERE gsc_profile_code.profile_code = pcProfileCode
         NO-ERROR.
  IF NOT AVAILABLE gsc_profile_code THEN
  DO:
    ASSIGN
      prRowid = ?
      pcProfileDataValue = "":U
      .
    RETURN.
  END.

  FIND FIRST gsm_profile_data NO-LOCK
       WHERE gsm_profile_data.profile_type_obj = gsc_profile_code.profile_type_obj
         AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
         AND gsm_profile_data.profile_data_key = pcProfileDataKey
         AND gsm_profile_data.USER_obj = dUserObj
         AND gsm_profile_data.CONTEXT_id = gscSessionId
       NO-ERROR.

  IF NOT AVAILABLE gsm_profile_data THEN
    FIND FIRST gsm_profile_data NO-LOCK
         WHERE gsm_profile_data.profile_type_obj = gsc_profile_code.profile_type_obj
           AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
           AND gsm_profile_data.profile_data_key = pcProfileDataKey
           AND gsm_profile_data.USER_obj = dUserObj
           AND gsm_profile_data.CONTEXT_id = "":U
         NO-ERROR.
END.

IF AVAILABLE gsm_profile_data AND plNextRecordFlag THEN
  FIND NEXT gsm_profile_data NO-LOCK
       WHERE gsm_profile_data.profile_type_obj = gsc_profile_code.profile_type_obj
         AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
         AND gsm_profile_data.USER_obj = dUserObj
       NO-ERROR.

IF NOT AVAILABLE gsm_profile_data THEN
DO:
  ASSIGN
    prRowid = ?
    pcProfileDataValue = "":U
    .
END.
ELSE
DO:
  ASSIGN
    prRowid             = ROWID(gsm_profile_data)
    pcProfileDataValue  = gsm_profile_data.profile_data_value
    pcContextId         = gsm_profile_data.CONTEXT_id
    pdUserObj           = gsm_profile_data.USER_obj
    pdProfileTypeObj    = gsm_profile_data.profile_type_obj
    pdProfileCodeObj    = gsm_profile_data.profile_code_obj
    plServerProfileType = gsc_profile_type.SERVER_profile_type
    .
END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


