&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: aftrnbldtrncp.i

  Description:  afbldtrncp structured include

  Purpose:      afbldtrncp structured include

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   07/31/2003  Author:     Bruce S Gruenbaum

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
         HEIGHT             = 18.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    EMPTY TEMP-TABLE ttTranslation.
  
    /* 1st see if translation enabled */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_security_control OR
       (AVAILABLE gsc_security_control AND gsc_security_control.translation_enabled = NO) THEN
      RETURN.
  
    IF pdLanguageObj <> 0 THEN
    FOR EACH gsm_translation NO-LOCK
       WHERE gsm_translation.language_obj = pdLanguageObj:
      CREATE ttTranslation.
      BUFFER-COPY gsm_translation TO ttTranslation.
    END.
    ELSE
    FOR EACH gsm_translation NO-LOCK:
      CREATE ttTranslation.
      BUFFER-COPY gsm_translation TO ttTranslation.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


