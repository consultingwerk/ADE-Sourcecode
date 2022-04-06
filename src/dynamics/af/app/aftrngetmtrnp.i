&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: aftrngetmtrnp.i

  Description:  afgetmtrnp structured include

  Purpose:      afgetmtrnp structured include

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

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
         HEIGHT             = 21.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEFINE BUFFER bttTranslate FOR ttTranslate.
  
  DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj           AS DECIMAL    INITIAL 0 NO-UNDO.
  DEFINE VARIABLE cCurrentLanguageName          AS CHARACTER  NO-UNDO.
  
  /* IF all languages, sort out temp-table to have an entry for each language */
  IF plAllLanguages THEN
  FOR EACH ttTranslate
     WHERE ttTranslate.dLanguageObj = 0:
  
    FOR EACH gsc_language NO-LOCK:
      CREATE bttTranslate.
      BUFFER-COPY ttTranslate TO bttTranslate
        ASSIGN
          bttTranslate.dLanguageObj = gsc_language.LANGUAGE_obj
          bttTranslate.cLanguageName = gsc_language.LANGUAGE_name
          .    
      RELEASE bttTranslate.
    END.
  END.
  IF plAllLanguages THEN
  FOR EACH ttTranslate
     WHERE ttTranslate.dLanguageObj = 0:
    DELETE ttTranslate.
  END.
  
  /* get login language */
  cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "currentLanguageObj,currentLanguageName":U,
                                   INPUT NO).
  dCurrentLanguageObj = DECIMAL(ENTRY(1, cPropertyList, CHR(3))) NO-ERROR.
  cCurrentLanguageName = ENTRY(2, cPropertyList, CHR(3)) NO-ERROR.
  
  /* now do translations */
  FOR EACH ttTranslate:
  
    /* toolbar only supports global translations, window title and tabs and sdf's only specific */
    IF ttTranslate.cObjectName = "rydyntoolt.w" THEN ASSIGN ttTranslate.lGlobal = YES.
    IF ttTranslate.cWidgetType = "TITLE":U THEN ASSIGN ttTranslate.lGlobal = NO.
    IF ttTranslate.cWidgetType = "TAB":U THEN ASSIGN ttTranslate.lGlobal = NO.
    IF NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 THEN ASSIGN ttTranslate.lGlobal = NO. 
  
    IF ttTranslate.dLanguageObj = 0 THEN
      ASSIGN
        ttTranslate.dLanguageObj = dCurrentLanguageObj
        ttTranslate.cLanguageName = cCurrentLanguageName
        . 
    IF ttTranslate.dLanguageObj <> 0 AND ttTranslate.cLanguageName = "":U THEN
    DO:
      FIND FIRST gsc_language NO-LOCK
           WHERE gsc_language.LANGUAGE_obj = ttTranslate.dLanguageObj
           NO-ERROR.
      IF AVAILABLE gsc_language THEN ASSIGN ttTranslate.cLanguageName = gsc_language.LANGUAGE_name.
    END.
  
    FIND FIRST gsm_translation NO-LOCK
         WHERE gsm_translation.language_obj = ttTranslate.dLanguageObj
           AND gsm_translation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
           AND gsm_translation.WIDGET_type = ttTranslate.cWidgetType
           AND gsm_translation.WIDGET_name = ttTranslate.cWidgetName
           AND gsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
         NO-ERROR.
  
    IF NOT AVAILABLE gsm_translation AND 
      ttTranslate.cWidgetType <> "TITLE":U AND
      ttTranslate.cWidgetType <> "TAB":U AND
      ttTranslate.lGlobal = NO AND
      NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 THEN
    DO:
      FIND FIRST gsm_translation NO-LOCK
           WHERE gsm_translation.language_obj = ttTranslate.dLanguageObj
             AND gsm_translation.OBJECT_filename = "":U
             AND gsm_translation.WIDGET_type = "":U
             AND gsm_translation.WIDGET_name = ttTranslate.cWidgetName
             AND gsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
           NO-ERROR.
    END.
  
    IF AVAILABLE gsm_translation THEN
    DO:
      ASSIGN
        ttTranslate.dSourceLanguage = gsm_translation.source_language_obj
        ttTranslate.cOriginalLabel = gsm_translation.original_label
        ttTranslate.cOriginalTooltip = gsm_translation.original_tooltip
        ttTranslate.cTranslatedLabel = gsm_translation.translation_label
        ttTranslate.cTranslatedTooltip = gsm_translation.translation_tooltip
        .
      IF gsm_translation.OBJECT_filename = "":U THEN
        ASSIGN ttTranslate.lGlobal = YES
               ttTranslate.lExtractedGlobal = YES.
    END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


