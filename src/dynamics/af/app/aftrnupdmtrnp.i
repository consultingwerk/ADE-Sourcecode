&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: aftrnupdmtrnp.i

  Description:  afupdmtrnp structured include

  Purpose:      afupdmtrnp structured include

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
         HEIGHT             = 19.86
         WIDTH              = 48.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        DEFINE BUFFER bgsm_translation FOR gsm_translation.
        DEFINE BUFFER gsm_translation  FOR gsm_translation.

        trn-block:
        DO FOR bgsm_translation TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
        
          translate-loop:
          FOR EACH ttTranslate:
            IF NOT ttTranslate.lExtractedGlobal THEN
                FIND FIRST bgsm_translation EXCLUSIVE-LOCK
                     WHERE bgsm_translation.source_language_obj = ttTranslate.dSourceLanguageObj
                       AND bgsm_translation.language_obj = ttTranslate.dLanguageObj
                       AND bgsm_translation.OBJECT_filename = ttTranslate.cObjectName
                       AND bgsm_translation.WIDGET_type = ttTranslate.cWidgetType
                       AND bgsm_translation.WIDGET_name = ttTranslate.cWidgetName
                       AND bgsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
                     NO-ERROR.
            ELSE
                FIND FIRST bgsm_translation EXCLUSIVE-LOCK
                     WHERE bgsm_translation.source_language_obj = ttTranslate.dSourceLanguageObj
                       AND bgsm_translation.language_obj = ttTranslate.dLanguageObj
                       AND bgsm_translation.OBJECT_filename = "":U
                       AND bgsm_translation.WIDGET_type = "":U
                       AND bgsm_translation.WIDGET_name = ttTranslate.cWidgetName
                       AND bgsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
                     NO-ERROR.

            IF AVAILABLE bgsm_translation THEN
            DO:
              IF ttTranslate.lDelete = YES OR 
                 (ttTranslate.cTranslatedLabel = "":U AND ttTranslate.cTranslatedTooltip = "":U) THEN
              DO:
                DELETE bgsm_translation NO-ERROR.
                IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
                NEXT translate-loop.
              END.

              /* If we've changed from a global to a non-global, we must make sure we're not going to create *
               * a duplicate. */
              IF ttTranslate.lGlobal THEN
                  ASSIGN ttTranslate.cObjectName = "":U
                         ttTranslate.cWidgetType = "":U.

              IF ttTranslate.lExtractedGlobal <> ttTranslate.lGlobal 
              THEN DO:
                  FIND gsm_Translation EXCLUSIVE-LOCK
                       WHERE gsm_translation.source_language_obj = ttTranslate.dSourceLanguageObj
                         AND gsm_translation.language_obj = ttTranslate.dLanguageObj
                         AND gsm_translation.OBJECT_filename = ttTranslate.cObjectName
                         AND gsm_translation.WIDGET_type = ttTranslate.cWidgetType
                         AND gsm_translation.WIDGET_name = ttTranslate.cWidgetName
                         AND gsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
                       NO-ERROR.
                  IF AVAILABLE gsm_Translation THEN
                      DELETE gsm_Translation.
              END.
            END.
            ELSE
                IF ttTranslate.lGlobal THEN
                    ASSIGN ttTranslate.cObjectName = "":U
                           ttTranslate.cWidgetType = "":U.

            ERROR-STATUS:ERROR = NO.  /* clear error status */
        
            IF ttTranslate.lDelete = YES OR 
               (ttTranslate.cTranslatedLabel = "":U AND ttTranslate.cTranslatedTooltip = "":U) THEN NEXT translate-loop.
        
            IF NOT AVAILABLE bgsm_translation THEN
            DO:
              CREATE bgsm_translation NO-ERROR.
              IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
              ASSIGN
                bgsm_translation.source_language_obj = ttTranslate.dSourceLanguageObj
                bgsm_translation.language_obj = ttTranslate.dLanguageObj
                bgsm_translation.WIDGET_name = ttTranslate.cWidgetName
                bgsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
                .      
            END.
            ASSIGN
              bgsm_translation.OBJECT_filename = ttTranslate.cObjectName
              bgsm_translation.WIDGET_type = ttTranslate.cWidgetType
              bgsm_translation.original_label = ttTranslate.cOriginalLabel
              bgsm_translation.original_tooltip = ttTranslate.cOriginalTooltip
              bgsm_translation.translation_label = ttTranslate.cTranslatedLabel
              bgsm_translation.translation_tooltip = ttTranslate.cTranslatedTooltip
              .
            VALIDATE bgsm_translation NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        
          END. /* translate-loop */
        
        END.  /* trn-block */
        {af/sup2/afcheckerr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


