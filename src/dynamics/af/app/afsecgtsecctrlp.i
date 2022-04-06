&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: afsecgtsecctrlp.i

  Description:  getSecurityControl structured include

  Purpose:      getSecurityControl structured include

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   07/30/2003  Author:     Bruce S Gruenbaum

  Update Notes: Move osm- modules to af- modules

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
         HEIGHT             = 20.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL INITIAL 0 NO-UNDO.

  EMPTY TEMP-TABLE ttSecurityControl.
  
  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
  
  IF AVAILABLE gsc_security_control 
  THEN DO:  
      ASSIGN dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           INPUT "currentLanguageObj":U,
                                           INPUT NO)) NO-ERROR.
      CREATE ttSecurityControl.
      BUFFER-COPY gsc_security_control TO ttSecurityControl.

      /* Check if a default help file exists for specific language */      
      FIND FIRST gsm_help NO-LOCK
           WHERE gsm_help.language_obj            = dCurrentLanguageObj
             AND gsm_help.help_container_filename = "":U
             AND gsm_help.help_object_filename    = "":U
             AND gsm_help.help_fieldname          = "":U
           NO-ERROR.
  
      IF AVAILABLE gsm_help THEN
          ASSIGN ttSecurityControl.default_help_filename = gsm_help.help_filename.
      ELSE
          IF ttSecurityControl.default_help_filename = "":U
          OR ttSecurityControl.default_help_filename = ? THEN
              ASSIGN ttSecurityControl.default_help_filename = "prohelp/icabeng.hlp":U.

      FIND FIRST ttSecurityControl NO-ERROR.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


