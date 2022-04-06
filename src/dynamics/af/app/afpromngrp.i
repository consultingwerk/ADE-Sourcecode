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
  File: afpromngrp.i

  Description:  Astra Profile Manager Code

  Purpose:      The Astra Profile Manager is a standard procedure encapsulating all
                user profile access supported by the framework. User profile data
                includes things such as window positions and sizes, browser filter
                settings, report filter settings, system wide information such as
                tooltips enabled, etc.
                All of these settings are stored by user and may be saved permanently
                in the database for consistency between client sessions. Data may also
                be stored just for the current session.
                This include file contains the common code for both the server and client
                Profile Manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   31/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager

  (v:010003)    Task:        6030   UserRef:    
                Date:   19/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

  (v:010004)    Task:        6092   UserRef:    
                Date:   20/06/2000  Author:     Robin Roos

  Update Notes: Correct infinite recursion in afproclntp.p

  (v:010005)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers

  (v:010006)    Task:        6179   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: Write Preferences Window
                  
  (v:010007)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in main block.

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afpromngrp.i
&scop object-version    000000


/* Astra object identifying preprocessor */
&global-define astraProfileManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

{af/app/afttprofiledata.i}

/* define variables used by error checking include, scoped to whole procedure */
{af/sup2/afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getProfileTTHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProfileTTHandle Procedure 
FUNCTION getProfileTTHandle RETURNS HANDLE FORWARD.

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
         HEIGHT             = 27.76
         WIDTH              = 78.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* the procedures below left as is -- see afgetpdatp_disabled and
   afsetpdatp_disabled procedures */
&IF DEFINED(server-side) <> 0 &THEN
  PROCEDURE afbldclicp:         {af/app/afbldclicp.p}     END PROCEDURE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-afchkpdexp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afchkpdexp Procedure 
PROCEDURE afchkpdexp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pcProfileTypeCode             AS CHARACTER  NO-UNDO.
    DEFINE  INPUT PARAMETER pcProfileCode                 AS CHARACTER  NO-UNDO.
    DEFINE  INPUT PARAMETER pcProfileDataKey              AS CHARACTER  NO-UNDO.
    DEFINE  INPUT PARAMETER plCheckPermanentOnly          AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plExists                      AS LOGICAL    NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afprochkpedxp.p ON gshAstraAppServer
          (INPUT    pcProfileTypeCode,   
           INPUT    pcProfileCode,       
           INPUT    pcProfileDataKey,    
           INPUT    plCheckPermanentOnly,
           OUTPUT   plExists) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
            RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                            ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
          DEFINE VARIABLE cUserObj                  AS CHARACTER  NO-UNDO.
          DEFINE VARIABLE dUserObj                  AS DECIMAL INITIAL 0 NO-UNDO.
        
          ASSIGN plExists = NO.
        
          cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                             INPUT "currentUserObj":U,
                                                             INPUT NO).
          ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.
        
          IF dUserObj > 0 THEN
          findloop:
          FOR EACH gsc_profile_type NO-LOCK
             WHERE gsc_profile_type.profile_type_code BEGINS pcProfileTypeCode,
              EACH gsc_profile_code NO-LOCK
             WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj
               AND gsc_profile_code.profile_code BEGINS pcProfileCode,
              EACH gsm_profile_data NO-LOCK
             WHERE gsm_profile_data.USER_obj = dUserObj
               AND gsm_profile_data.profile_type_obj = gsc_profile_type.profile_type_obj
               AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
               AND gsm_profile_data.profile_data_key BEGINS pcProfileDataKey:
        
            IF plCheckPermanentOnly AND gsm_profile_data.CONTEXT_id <> "":U THEN NEXT findloop.
        
            /* found one so leave */  
            ASSIGN plExists = YES.
            LEAVE findloop.
          END.
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afdelsprop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afdelsprop Procedure 
PROCEDURE afdelsprop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(server-side) = 0 &THEN
        RUN af/app/afprodelspropp.p ON gshAstraAppServer NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
            RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                            ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE BUFFER bgsm_profile_data FOR gsm_profile_data.
        
        IF SESSION:REMOTE THEN
        trn-block:
        DO FOR bgsm_profile_data TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
          FOR EACH bgsm_profile_data EXCLUSIVE-LOCK
             WHERE bgsm_profile_data.CONTEXT_id = SESSION:SERVER-CONNECTION-ID:
            DELETE bgsm_profile_data NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          END.
        END.
        ELSE
        IF SESSION:CLIENT-TYPE = "WEBSPEED":U THEN
        trn-block:
        DO FOR bgsm_profile_data TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
          FOR EACH bgsm_profile_data EXCLUSIVE-LOCK
             WHERE bgsm_profile_data.CONTEXT_id = gscSessionId:
            DELETE bgsm_profile_data NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          END.
        END.
        {af/sup2/afcheckerr.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afgetpdatp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afgetpdatp Procedure 
PROCEDURE afgetpdatp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER        pcProfileTypeCode       AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER        pcProfileCode           AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER        pcProfileDataKey        AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER        plNextRecordFlag        AS LOGICAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER prRowid                 AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER       pcProfileDataValue      AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER       pcContextId             AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER       pdUserObj               AS DECIMAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER       pdProfileTypeObj        AS DECIMAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER       pdProfileCodeObj        AS DECIMAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER       plServerProfileType     AS LOGICAL    NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afprogetpdatp.p ON gshAstraAppServer
        (INPUT        pcProfileTypeCode,    
         INPUT        pcProfileCode,        
         INPUT        pcProfileDataKey,     
         INPUT        plNextRecordFlag,     
         INPUT-OUTPUT prRowid,            
         OUTPUT       pcProfileDataValue, 
         OUTPUT       pcContextId,        
         OUTPUT       pdUserObj,          
         OUTPUT       pdProfileTypeObj,   
         OUTPUT       pdProfileCodeObj,   
         OUTPUT       plServerProfileType) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE BUFFER bgsc_profile_type     FOR gsc_profile_type.
        DEFINE BUFFER bgsc_profile_code     FOR gsc_profile_code.
        DEFINE BUFFER bgsm_profile_data     FOR gsm_profile_data.

        DEFINE VARIABLE cUserObj                              AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE dUserObj                              AS DECIMAL INITIAL 0 NO-UNDO.

        
        cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                           INPUT "currentUserObj":U,
                                                           INPUT NO).
        ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.
        
        IF prRowid <> ? THEN
        FIND FIRST bgsm_profile_data NO-LOCK
             WHERE ROWID(bgsm_profile_data) = prRowid
             NO-ERROR.
        IF prRowid = ? OR NOT AVAILABLE bgsm_profile_data OR bgsm_profile_data.user_obj <> dUserObj THEN
        DO:
          FIND FIRST bgsc_profile_type NO-LOCK
               WHERE bgsc_profile_type.profile_type_code = pcProfileTypeCode
               NO-ERROR.
          IF AVAILABLE bgsc_profile_type THEN
            FIND FIRST bgsc_profile_code NO-LOCK                 
                 WHERE bgsc_profile_code.profile_code = pcProfileCode
                 NO-ERROR.
          IF NOT AVAILABLE bgsc_profile_code THEN
          DO:
            ASSIGN
              prRowid = ?
              pcProfileDataValue = "":U
              .
            RETURN.
          END.
        
          FIND FIRST bgsm_profile_data NO-LOCK
               WHERE bgsm_profile_data.profile_type_obj = bgsc_profile_code.profile_type_obj
                 AND bgsm_profile_data.profile_code_obj = bgsc_profile_code.profile_code_obj
                 AND bgsm_profile_data.profile_data_key = pcProfileDataKey
                 AND bgsm_profile_data.USER_obj = dUserObj
                 AND bgsm_profile_data.CONTEXT_id = gscSessionId
               NO-ERROR.
        
          IF NOT AVAILABLE bgsm_profile_data THEN
            FIND FIRST bgsm_profile_data NO-LOCK
                 WHERE bgsm_profile_data.profile_type_obj = bgsc_profile_code.profile_type_obj
                   AND bgsm_profile_data.profile_code_obj = bgsc_profile_code.profile_code_obj
                   AND bgsm_profile_data.profile_data_key = pcProfileDataKey
                   AND bgsm_profile_data.USER_obj = dUserObj
                   AND bgsm_profile_data.CONTEXT_id = "":U
                 NO-ERROR.
        END.
        
        IF AVAILABLE bgsm_profile_data AND plNextRecordFlag THEN
          FIND NEXT bgsm_profile_data NO-LOCK
               WHERE bgsm_profile_data.profile_type_obj = bgsc_profile_code.profile_type_obj
                 AND bgsm_profile_data.profile_code_obj = bgsc_profile_code.profile_code_obj
                 AND bgsm_profile_data.USER_obj = dUserObj
               NO-ERROR.
        
        IF NOT AVAILABLE bgsm_profile_data THEN
        DO:
          ASSIGN
            prRowid = ?
            pcProfileDataValue = "":U
            .
        END.
        ELSE
        DO:
          ASSIGN
            prRowid             = ROWID(bgsm_profile_data)
            pcProfileDataValue  = bgsm_profile_data.profile_data_value
            pcContextId         = bgsm_profile_data.CONTEXT_id
            pdUserObj           = bgsm_profile_data.USER_obj
            pdProfileTypeObj    = bgsm_profile_data.profile_type_obj
            pdProfileCodeObj    = bgsm_profile_data.profile_code_obj
            plServerProfileType = bgsc_profile_type.SERVER_profile_type
            .
        END.
    &ENDIF    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afsetpdatp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afsetpdatp Procedure 
PROCEDURE afsetpdatp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER  prRowid                       AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER  pcProfileDataValue            AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER  plDeleteFlag                  AS LOGICAL    NO-UNDO.
    DEFINE INPUT PARAMETER  pcSaveFlag                    AS CHARACTER  NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afprosetpdatp.p ON gshAstraAppServer
        (INPUT pcProfileTypeCode, 
         INPUT pcProfileCode,     
         INPUT pcProfileDataKey,  
         INPUT prRowid,           
         INPUT pcProfileDataValue,
         INPUT plDeleteFlag,      
         INPUT pcSaveFlag) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    &ELSE
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
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afupdcadbp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afupdcadbp Procedure 
PROCEDURE afupdcadbp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pcProfileTypeCodes            AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttProfileData.

    /* only cause appserver hit / update if profile data exists. The profile data
       may be empty when the login window calls this API as it is called during
       an initial login and a relogon, and during an initial login there will be
       no profile data yet - see aftemlognw.w for details.
    */
    IF CAN-FIND(FIRST ttProfileData) THEN
    DO:

      &IF DEFINED(server-side) = 0 &THEN
      
        RUN af/app/afproupdcadbp.p ON gshAstraAppServer
          (INPUT              pcProfileTypeCodes,   
           INPUT-OUTPUT TABLE ttProfileData) NO-ERROR.
        
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
            RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                            ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
      &ELSE
         {af/app/afproupdcadbp.i}
      &ENDIF
    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildClientCache Procedure 
PROCEDURE buildClientCache :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to load local client cache temp-table for the current
               logged in user - just permanent data where context id = blank
               Also, only load into the cache data for profiles that are client
               side only data (i.e. server profile type = NO).
  Parameters:  input comma delimited list of specific profile type codes (blank = all)
  Notes:       Clear out temp-table first to be sure.
               This is run at application start-up for maximum performance.
               At some later stage we may decide not to load data until it is
               first accessed, so the other routines must not assume the data
               is there and must be able to maintain the data.
               Beware this procedure can not be run again as it will clear out
               the existing temp-table.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcProfileTypeCodes            AS CHARACTER  NO-UNDO.

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
    EMPTY TEMP-TABLE ttProfileData.
    RUN afbldclicp IN TARGET-PROCEDURE (INPUT pcProfileTypeCodes,OUTPUT TABLE ttProfileData).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkProfileDataExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkProfileDataExists Procedure 
PROCEDURE checkProfileDataExists :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to check whether profile data exists for the current
               logged in user for the specified profile type / code / key.
               This procedure supports the passing of partial information, e.g.
               only the profile type, the type and code, etc.
  Parameters:  input profile type code
               input profile code
               input profile data key
               input check permanent data only flag YES/NO, default = YES
               input check client cache only YES/NO, default = NO
               output exists flag YES/NO
  Notes:       If the permanent data only flag is set to NO, then if any database
               entries exist for the session only, this will also return TRUE.
               If the check client only cache is set to YES then this procedure 
               will only check the temp-table rather than also checking the
               database as well.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plCheckPermanentOnly          AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  plCheckCacheOnly              AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plExists                      AS LOGICAL    NO-UNDO.

ASSIGN plExists = NO.

/* check client cache 1st if not remote */
IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) = NO THEN
DO:
  IF plCheckPermanentOnly THEN
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode BEGINS pcProfileTypeCode
           AND ttProfileData.cProfileCode BEGINS pcProfileCode
           AND ttProfileData.profile_data_key BEGINS pcProfileDataKey
           AND ttProfileData.CONTEXT_id = "":U
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.
  ELSE
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode BEGINS pcProfileTypeCode
           AND ttProfileData.cProfileCode BEGINS pcProfileCode
           AND ttProfileData.profile_data_key BEGINS pcProfileDataKey
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.
  IF AVAILABLE ttProfileData AND ttProfileData.caction <> "DEL":U THEN
    ASSIGN plExists = YES.
END.

IF plCheckCacheOnly OR plExists THEN RETURN.

/* check database to see if profile data exists */
RUN afchkpdexp IN TARGET-PROCEDURE 
                  (INPUT pcProfileTypeCode,
                   INPUT pcProfileCode,
                   INPUT pcProfileDataKey,
                   INPUT plCheckPermanentOnly,
                  OUTPUT plExists).  
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
               maintennance programs have been run that change profile data.
               The procedure avoids having to log off and start a new session in 
               order to use the new profile data settings.
  Parameters:  <none>
  Notes:       Any changes made within the session not already committed to the
               database will be lost.
------------------------------------------------------------------------------*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
  EMPTY TEMP-TABLE ttProfileData.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteSessionProfile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteSessionProfile Procedure 
PROCEDURE deleteSessionProfile :
/*------------------------------------------------------------------------------
  Purpose:     deletion of session profile data, run from as_disconnect when client
               disconnects from agent.
  Parameters:  <none>
  Notes:       Zap any remaining user profile session only database entries, i.e.
               entries with a context_id <> "":U.
               This must use the actual SESSION:SERVER-CONNECTION-ID and not the
               gscSessionId as the gscSessionId may have been set to null by the
               time this runs.
------------------------------------------------------------------------------*/

    RUN afdelsprop IN TARGET-PROCEDURE.  

    {af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProfileData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData Procedure 
PROCEDURE getProfileData :
/*------------------------------------------------------------------------------
  Purpose:     To return profile data value for specified profile for current
               user / current session.
  Parameters:  input profile type code
               input profile code
               input profile data key
               input next flag (YES = get next value)
               input-output rowid of profile data
               output profile data value
  Notes:       First looks in client cache if running client side. If not found,
               looks in database.
               Must always check for session data first, then permanent data.
               If a rowid is passed in, then this will be used to find the record.
               The rowid will be the rowid of the temp-table if this is a client only
               profile type, otherwise it is the rowid of the database record. To 
               determine this we must also have the profile type passed in with 
               the rowid. Also note that passing in a rowid will take precendence 
               over any other input paramaters.
               If the next flag is set to yes, then a FIND NEXT will be done to
               retrieve the record after the record passed in.
               The rowid of the the temp-table will be returned if cached on the
               client, otherwise the rowid of the database record will be returned.
               The rowid is useful when reading through sets of profile data using
               the next functionality.
------------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plNextRecordFlag              AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  prRowid                AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER pcProfileDataValue            AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cContextId                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dUserObj                              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProfileTypeObj                       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProfileCodeObj                       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lServerProfileType                    AS LOGICAL   NO-UNDO.

/* check client cache 1st if not remote */
IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) = NO THEN
DO:
  IF prRowid <> ? THEN
    FIND FIRST ttProfileData
         WHERE ROWID(ttProfileData) = prRowid
         NO-ERROR.
  IF prRowid = ? OR NOT AVAILABLE ttProfileData THEN
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
           AND ttProfileData.cProfileCode = pcProfileCode
           AND ttProfileData.profile_data_key = pcProfileDataKey
           AND ttProfileData.CONTEXT_id = gscSessionId
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.
  IF NOT AVAILABLE ttProfileData THEN
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
           AND ttProfileData.cProfileCode = pcProfileCode
           AND ttProfileData.profile_data_key = pcProfileDataKey
           AND ttProfileData.CONTEXT_id = "":U
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.

  IF AVAILABLE ttProfileData AND plNextRecordFlag THEN
    FIND NEXT ttProfileData
        WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
          AND ttProfileData.cProfileCode = pcProfileCode
          AND ttProfileData.caction <> "DEL":U
        NO-ERROR.

  IF AVAILABLE ttProfileData AND ttProfileData.caction <> "DEL":U THEN
  DO:
    ASSIGN
      prRowid = ROWID(ttProfileData)
      pcProfileDataValue = ttProfileData.profile_data_value
      cContextId = ttProfileData.context_Id
      .

    RETURN.
  END.
END.

DEFINE VARIABLE lClientCache                          AS LOGICAL    NO-UNDO.

/* see if any cached data exists for this profile type. If it does, then the profile data
   must only be got from the cache, as this profile type must be a client side only profile
*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND CAN-FIND(FIRST ttProfileData
                                   WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode) THEN
  ASSIGN lClientCache = YES.
ELSE  
  ASSIGN lClientCache = NO.

/* if running client side and could not find any cached data for this profile type,
   then try and build the cache for this profile type now, then check again.
   Beware we must always run the external procedure for the build client cache to
   ensure our existing temp-table does not get emptied inadvertantly as the procedure
   afbldclicp.p does an empty temp-table first.
   Because we run it externally and have set the output parameter to append, then
   we will be safe and will simply add any new cached data to the existing temp-table.
   This will only be required if not fully building the cache at login time.
*/   
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND lClientCache = NO THEN
DO:
  RUN af/app/afbldclicp.p ON gshAstraAppserver (INPUT pcProfileTypeCode,
                                                OUTPUT TABLE ttProfileData APPEND).
END.

/* now check again - for the last time 
   Note: even if no user data exists, at least one record will have been created for
   the user for each profile code in the type, if it is a profile type that should be cached.
*/  
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND CAN-FIND(FIRST ttProfileData
                                   WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode) THEN
  ASSIGN lClientCache = YES.
ELSE  
  ASSIGN lClientCache = NO.

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND lClientCache = YES THEN 
DO:
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
           AND ttProfileData.cProfileCode = pcProfileCode
           AND ttProfileData.profile_data_key = pcProfileDataKey
           AND ttProfileData.CONTEXT_id = gscSessionId
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.
  IF NOT AVAILABLE ttProfileData THEN
    FIND FIRST ttProfileData
         WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
           AND ttProfileData.cProfileCode = pcProfileCode
           AND ttProfileData.profile_data_key = pcProfileDataKey
           AND ttProfileData.CONTEXT_id = "":U
           AND ttProfileData.caction <> "DEL":U
         NO-ERROR.

  IF AVAILABLE ttProfileData AND plNextRecordFlag THEN
    FIND NEXT ttProfileData
        WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
          AND ttProfileData.cProfileCode = pcProfileCode
          AND ttProfileData.caction <> "DEL":U
        NO-ERROR.

  IF AVAILABLE ttProfileData AND ttProfileData.caction <> "DEL":U THEN
  DO:
    ASSIGN
      prRowid = ROWID(ttProfileData)
      pcProfileDataValue = ttProfileData.profile_data_value
      cContextId = ttProfileData.context_Id
      .

    RETURN.
  END.  

  RETURN.

END.

/* check database to see if profile data exists */
&IF DEFINED(server-side) <> 0 &THEN
  RUN afgetpdatp (INPUT pcProfileTypeCode,
                  INPUT pcProfileCode,
                  INPUT pcProfileDataKey,
                  INPUT plNextRecordFlag,
                  INPUT-OUTPUT prRowid,
                  OUTPUT pcProfileDataValue,
                  OUTPUT cContextId,
                  OUTPUT dUserObj,
                  OUTPUT dProfileTypeObj,
                  OUTPUT dProfileCodeObj,
                  OUTPUT lServerProfileType).  
&ELSE
  RUN af/app/afgetpdatp.p ON gshAstraAppserver (INPUT pcProfileTypeCode,
                                                INPUT pcProfileCode,
                                                INPUT pcProfileDataKey,
                                                INPUT plNextRecordFlag,
                                                INPUT-OUTPUT prRowid,
                                                OUTPUT pcProfileDataValue,
                                                OUTPUT cContextId,
                                                OUTPUT dUserObj,
                                                OUTPUT dProfileTypeObj,
                                                OUTPUT dProfileCodeObj,
                                                OUTPUT lServerProfileType).
&ENDIF

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on correct close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
    RUN updateCacheToDb IN TARGET-PROCEDURE (INPUT "":U). /* update cache to Database */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateProfileCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateProfileCache Procedure 
PROCEDURE populateProfileCache :
/*------------------------------------------------------------------------------
  Purpose:     This procedure takes a previously populated set of profiling
               records, and populates them wiht the profile information set on
               the database.
  Parameters:  <none>
  Notes:       This procedure is only meant to run on the server, and is currently
               called by cachecontr.p, which only runs when an Appserver is connected.              
               It is also worth noting that the ttProfileData temp-table in this procedure
               is not going to correspond to the client side profile cache.  The table will
               only contain the records we want to populate with information.  
               The table we receive must have the following fields populated:
               cProfileTypeCode
               cProfileCode
               profile_data_key
               cAction
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttProfileData.

&IF DEFINED(server-side) <> 0 &THEN

/* Cycle through all the profile records sent, and populate them.  Note that if we can not find profile information,                       *
 * we still return the profile record.  This is so we don't keep on hitting the Appserver because we can't find profile info in the cache. */

fe-blk:
FOR EACH ttProfileData:
    FOR FIRST gsc_profile_type NO-LOCK
        WHERE gsc_profile_type.profile_type_code = ttProfileData.cProfileTypeCode,
        FIRST gsc_profile_code NO-LOCK
        WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj
          AND gsc_profile_code.profile_code     = ttProfileData.cProfileCode:

        /* We're returning client profile data.  If this profile type applies to the server only, skip. */
        IF gsc_profile_type.server_profile_type = YES
        AND (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
        THEN DO:
            DELETE ttProfileData.
            NEXT fe-blk.
        END.

        FIND FIRST gsm_profile_data NO-LOCK
             WHERE gsm_profile_data.user_obj         = ttProfileData.user_obj
               AND gsm_profile_data.profile_type_obj = gsc_profile_code.profile_type_obj
               AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
               AND gsm_profile_data.profile_data_key = ttProfileData.profile_data_key
             NO-ERROR.

        IF AVAILABLE gsm_profile_data THEN
            BUFFER-COPY gsm_profile_data TO ttProfileData.
        ELSE
            ASSIGN ttProfileData.profile_type_obj = gsc_profile_type.profile_type_obj
                   ttProfileData.profile_code_obj = gsc_profile_code.profile_code_obj.

        ASSIGN ttProfileData.cAction = "NON":U. /* If this profile data is updated on the client, this flag will be reset */
    END.
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveProfileCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveProfileCache Procedure 
PROCEDURE receiveProfileCache :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows the profile cache to be supplemented from
               an external source.  It is used to receive profile cache from the
               login process and is also used when a container is launched.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttProfileData APPEND.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setProfileData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProfileData Procedure 
PROCEDURE setProfileData :
/*------------------------------------------------------------------------------
  Purpose:     To set profile data value for specified profile for current
               user / current session.
  Parameters:  input profile type code 
               input profile code (blank = all)
               input profile data key (blank = all)
               input rowid of profile data (if known)
               input profile data value
               input delete flag (YES = delete profile data)
               input save flag (SES = Session only, PER = Permanent)
  Notes:       This procedure supports the setting of multiple profile data to
               a single value / deleting multiple profile data, simply by leaving
               certain of the input parameters blank indicating all.
               If a rowid is passed in then the record to set will be found using the
               rowid rather than the individual profile fields. Obviously the record
               must already exist in this case to be set in this way. The rowid will
               be the rowid of the temp-table if this is a client only profile type,
               otherwise it is the rowid of the database record. To determine this we
               must also have the profile type passed in with the rowid. Also note that
               passing in a rowid will take precendence over any other input paramaters.
               If running on client, and profile type is client only, then
               update client cache with new data value. Database will be updated
               at session end or manually at some stage using updateCacheToDb.
               Note that to update the client cache, the build cache external procedure
               must be run to fully build the temp-table with entries for this profile
               type for the current user, as entries are either updated fully into the
               cache or fully into the database. This behaviour also ensures a record
               exists for the user for every profile code in the profile type, so when
               creating new records in the cache we have all the info we require, e.g. the
               object numbers.
               If not on client or profile type is also server, then update
               database straight away with new profile data value.
               If save flag is set to session, then store session id in context id
               field, otherwise leave the field blank to indicate permanent value.
               If delete flag is set to YES, then the data value will be marked
               for deletion in the temp-table if client caching is valid, or else 
               will be deleted from the database table directly.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  prRowid                       AS ROWID      NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataValue            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFlag                  AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcSaveFlag                    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lUpdateCache        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cContextId          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lAnonymousActivated AS LOGICAL    NO-UNDO.

DEFINE BUFFER bttProfileData FOR ttProfileData.

/* If we're dealing with an anonymous user session, we don't want to save ANY profile data permanently. */
ASSIGN lAnonymousActivated = (DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "allow_anonymous_login":U) = "YES":U) NO-ERROR.
IF lAnonymousActivated = YES THEN
    ASSIGN pcSaveFlag = "SES":U.

IF pcSaveFlag = "PER":U THEN
  ASSIGN cContextId = "":U.
ELSE
  ASSIGN cContextId = gscSessionID.

/* see if any cached data exists for this profile type. If it does, then the profile data
   must only be set in the cache, as this profile type must be a client side only profile
*/

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND CAN-FIND(FIRST ttProfileData
                                   WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode) THEN
    ASSIGN lUpdateCache = YES.
ELSE
    ASSIGN lUpdateCache = NO.

/* if running client side and could not find any cached data for this profile type,
   then try and build the cache for this profile type now, then check again.
   Beware we must always run the external procedure for the build client cache to
   ensure our existing temp-table does not get emptied inadvertantly as the procedure
   afbldclicp.p does an empty temp-table first.
   [Because we run it externally and have set the output parameter to append, then
   we will be safe and will simply add any new cached data to the existing temp-table.
   This will only be required if not fully building the cache at login time.]
*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND lUpdateCache = NO THEN
DO:
  RUN af/app/afbldclicp.p ON gshAstraAppserver (INPUT pcProfileTypeCode,
                                                OUTPUT TABLE ttProfileData APPEND).
END.

/* now check again - for the last time
   Note: even if no user data exists, at least one record will have been created for
   the user for each profile code in the type, if it is a profile type that should be cached.
*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND CAN-FIND(FIRST ttProfileData
                                   WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode) THEN
  ASSIGN lUpdateCache = YES.
ELSE
  ASSIGN lUpdateCache = NO.

IF lUpdateCache THEN
DO: /* only work with client cache */

  /* If rowid passed in, data must exist to be updated / deleted and session only setting ignored */
  IF prRowid <> ? THEN
  DO:
    FIND FIRST ttProfileData
         WHERE ROWID(ttProfileData) = prRowid
         NO-ERROR.

    IF AVAILABLE ttProfileData THEN
    DO:
      /* We need to avoid a sticky situation here.  We can only have one record saved permanently and one session for the same keys.     *
       * If we can find another record with the same keys to be saved the same way, we HAVE to delete it to avoid confusion.             *
       * IOW if we're saving some profile data for the local session, and we can find another record with the same data for the session, *
       * delete the other record.                                                                                                        */
      IF CAN-FIND(FIRST bttProfileData
                  WHERE bttProfileData.profile_type_obj = ttProfileData.profile_type_obj
                    AND bttProfileData.profile_code_obj = ttProfileData.profile_code_obj 
                    AND bttProfileData.profile_data_key = ttProfileData.profile_data_key
                    AND bttProfileData.context_id       = cContextId
                    AND bttProfileData.user_obj         = ttProfileData.user_obj
                    AND ROWID(bttProfileData)          <> ROWID(ttProfileData)) 
      THEN DO:
          FIND FIRST bttProfileData
               WHERE bttProfileData.profile_type_obj = ttProfileData.profile_type_obj
                 AND bttProfileData.profile_code_obj = ttProfileData.profile_code_obj 
                 AND bttProfileData.profile_data_key = ttProfileData.profile_data_key
                 AND bttProfileData.context_id       = cContextId
                 AND bttProfileData.user_obj         = ttProfileData.user_obj
                 AND ROWID(bttProfileData)          <> ROWID(ttProfileData)
               NO-ERROR.       
          DELETE bttProfileData NO-ERROR.
      END.

      IF plDeleteFlag THEN
          ASSIGN ttProfileData.cAction    = "DEL":U
                 ttProfileData.context_id = cContextId.
      ELSE
          ASSIGN ttProfileData.profile_data_value = pcProfileDataValue
                 ttProfileData.cAction    = "MOD":U
                 ttProfileData.context_id = cContextId.
    END.
    RETURN.
  END.

  /* if wildcards passed in, then just update existing records for appropriate session / permanent setting */
  IF pcProfileCode = "":U OR pcProfileDataKey = "":U THEN
  DO:
    FOR EACH ttProfileData
       WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
         AND ttProfileData.cProfileCode BEGINS pcProfileCode
         AND ttProfileData.profile_data_key BEGINS pcProfileDataKey
         AND ttProfileData.CONTEXT_id = cContextId:

      IF plDeleteFlag THEN
        ASSIGN
          ttProfileData.cAction = "DEL":U
          ttProfileData.context_id = cContextId.
      ELSE
        ASSIGN
          ttProfileData.profile_data_value = pcProfileDataValue
          ttProfileData.cAction = "MOD":U
          ttProfileData.context_id = cContextId.
    END.
    RETURN.
  END.  /* wildcard update */

  /* If get here, we are setting a specific value and if it does not exist, we should create it */
  FIND FIRST ttProfileData
       WHERE ttProfileData.cProfileTypeCode = pcProfileTypeCode
         AND ttProfileData.cProfileCode     = pcProfileCode
         AND ttProfileData.profile_data_key = pcProfileDataKey
         AND ttProfileData.CONTEXT_id       = cContextId
       NO-ERROR.

  IF NOT AVAILABLE ttProfileData AND NOT plDeleteFlag 
  THEN DO:    
      FIND FIRST bttProfileData
           WHERE bttProfileData.cProfileTypeCode = pcProfileTypeCode
             AND bttProfileData.cProfileCode     = pcProfileCode
           NO-ERROR.

      IF AVAILABLE bttProfileData 
      THEN DO:
          CREATE ttProfileData.
          BUFFER-COPY bttProfileData TO ttProfileData
          ASSIGN ttProfileData.profile_data_key = pcProfileDataKey
                 ttProfileData.CONTEXT_id       = cContextId
                 ttProfileData.cAction          = "ADD":U
                 ttProfileData.profile_data_obj = 0.
      END.
  END.
  ELSE
      ASSIGN ttProfileData.cAction = (IF plDeleteFlag THEN "DEL":U ELSE "MOD":U).

  IF AVAILABLE ttProfileData AND NOT plDeleteFlag THEN
    ASSIGN ttProfileData.CONTEXT_id         = cContextId
           ttProfileData.profile_data_value = pcProfileDataValue.

END.  /* update cache */
ELSE
DO: /* update database */
  /* Clear the ERROR-STATUS */
  ERROR-STATUS:ERROR = FALSE.

  &IF DEFINED(server-side) <> 0 &THEN
    RUN afsetpdatp (INPUT pcProfileTypeCode,
                    INPUT pcProfileCode,
                    INPUT pcProfileDataKey,
                    INPUT prRowid,
                    INPUT pcProfileDataValue,
                    INPUT plDeleteFlag,
                    INPUT pcSaveFlag).
  &ELSE
    RUN af/app/afsetpdatp.p ON gshAstraAppserver (INPUT pcProfileTypeCode,
                                                  INPUT pcProfileCode,
                                                  INPUT pcProfileDataKey,
                                                  INPUT prRowid,
                                                  INPUT pcProfileDataValue,
                                                  INPUT plDeleteFlag,
                                                  INPUT pcSaveFlag).
  &ENDIF
  {af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */
END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateCacheToDb) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCacheToDb Procedure 
PROCEDURE updateCacheToDb :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will update the modified details from the client
               cache temp-table into the database, and reset the action flag
               on the updated temp-tables to NON to ensure they are not
               updated again.
  Parameters:  input comma delimited list of specific profile type codes (blank = all)
  Notes:       This procedure is run when the session ends via plipshutdown, but may
               also be run manually at any stage to reflect maintenance changes.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcProfileTypeCodes            AS CHARACTER  NO-UNDO.

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:

    RUN afupdcadbp IN TARGET-PROCEDURE (INPUT pcProfileTypeCodes,INPUT-OUTPUT TABLE ttProfileData).  
        
    {af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getProfileTTHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProfileTTHandle Procedure 
FUNCTION getProfileTTHandle RETURNS HANDLE:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/  

  RETURN TEMP-TABLE ttProfileData:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

