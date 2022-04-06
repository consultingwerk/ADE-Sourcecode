&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File:         afproupdcadbp.i

  Description:  afupdcadbp Included code

  Purpose:      afupdcadbp Included code

  Parameters:

  History:
  --------
  (v:010000)    Task:               UserRef:    
                Date:   07/24/2003  Author:     Bruce S Gruenbaum

  

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 25
         WIDTH              = 62.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEFINE BUFFER bgsm_profile_data FOR gsm_profile_data.
  
  trn-block:
  DO FOR bgsm_profile_data TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
  
    profiletypeloop:
    FOR EACH ttProfileData
       WHERE ttProfileData.cAction <> "NON":U
         AND ttProfileData.CONTEXT_id = "":U:
  
      IF pcProfileTypeCodes <> "":U AND
         LOOKUP(ttProfileData.cProfileTypeCode, pcProfileTypeCodes) = 0 THEN
        NEXT profiletypeloop.
  
      FIND FIRST bgsm_profile_data EXCLUSIVE-LOCK
           WHERE bgsm_profile_data.user_obj = ttProfileData.user_obj
             AND bgsm_profile_data.profile_type_obj = ttProfileData.profile_type_obj
             AND bgsm_profile_data.profile_code_obj = ttProfileData.profile_code_obj
             AND bgsm_profile_data.profile_data_key = ttProfileData.profile_data_key
             AND bgsm_profile_data.context_id = ttProfileData.context_id
           NO-ERROR.
      IF NOT AVAILABLE bgsm_profile_data AND ttProfileData.cAction <> "DEL":U THEN
      DO:
        CREATE bgsm_profile_data NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      END.
  
      IF AVAILABLE bgsm_profile_data AND ttProfileData.cAction <> "DEL":U THEN
      DO:
        ASSIGN
          bgsm_profile_data.user_obj = ttProfileData.user_obj
          bgsm_profile_data.profile_type_obj = ttProfileData.profile_type_obj
          bgsm_profile_data.profile_code_obj = ttProfileData.profile_code_obj
          bgsm_profile_data.profile_data_key = ttProfileData.profile_data_key
          bgsm_profile_data.context_id = ttProfileData.context_id               
          bgsm_profile_data.profile_data_value = ttProfileData.profile_data_value
          .
        VALIDATE bgsm_profile_data NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      END.
  
      IF AVAILABLE bgsm_profile_data AND ttProfileData.cAction = "DEL":U THEN
      DO:
        DELETE bgsm_profile_data NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      END.
  
      /* Finally update temp-table action. */
      IF ttProfileData.cAction = "DEL":U THEN
        DELETE ttProfileData.
      ELSE
        ASSIGN ttProfileData.cAction = "NON":U.
  
    END.
  
  END.  /* trn-block*/
  {af/sup2/afcheckerr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


