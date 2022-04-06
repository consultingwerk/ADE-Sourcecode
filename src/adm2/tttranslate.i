&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: tttranslate.i

  Description:  Multi-Translation temp-table

  Purpose:      Multi-Translation temp-table

  Parameters:   <none>

  History:
  --------
  Modified: 05/07/2002 - Mark Davies (MIP)
            Added field for Source Language obj
  
-----------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       tttranslate.i
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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
         HEIGHT             = 5.62
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ttTranslate) = 0 &THEN
  DEFINE TEMP-TABLE ttTranslate NO-UNDO RCODE-INFORMATION
  FIELD dLanguageObj        AS DECIMAL                                                  /* language object or 0 for login language */
  FIELD dSourceLanguageObj  AS DECIMAL                                                  /* language object or 0 for login language */
  FIELD cLanguageName       AS CHARACTER FORMAT "X(20)":U LABEL "Language":U            /* language name if known */
  FIELD cObjectName         AS CHARACTER FORMAT "X(40)":U LABEL "Object name":U         /* object name or blank for all */
  FIELD lGlobal             AS LOGICAL   FORMAT "YES/NO":U LABEL "Global":U             /* yes = global translation, no = specific object (if not blank) */
  FIELD lExtractedGlobal    AS LOGICAL                                                 /* Maintenance impossible without this flag */
  FIELD cWidgetType         AS CHARACTER FORMAT "X(20)":U LABEL "Widget type":U         /* widget type, e.g. text, button, etc. */
  FIELD cWidgetName         AS CHARACTER FORMAT "X(40)":U LABEL "Widget name":U         /* widget name or if type is text, text to translate */
  FIELD hWidgetHandle       AS HANDLE                                                   /* handle of widget if known / required */
  FIELD iWidgetEntry        AS INTEGER   FORMAT ">>>9":U  LABEL "Element":U             /* widget entry, used for radio-sets, etc. */
  FIELD lDelete             AS LOGICAL   FORMAT "YES/NO":U LABEL "Delete":U             /* yes = global translation, no = specific object (if not blank) */
  FIELD cTranslatedLabel    AS CHARACTER FORMAT "X(60)":U LABEL "Translated label":U    /* translated label */
  FIELD cOriginalLabel      AS CHARACTER FORMAT "X(60)":U LABEL "Original label":U      /* original untranslated label */
  FIELD cTranslatedTooltip  AS CHARACTER FORMAT "X(70)":U LABEL "Translated tooltip":U  /* translated tooltip */
  FIELD cOriginalTooltip    AS CHARACTER FORMAT "X(70)":U LABEL "Original tooltip":U    /* original untranslated tooltip */
  INDEX key1 AS UNIQUE PRIMARY dLanguageObj cObjectName cWidgetType cWidgetName hWidgetHandle iWidgetEntry
  INDEX key2 cLanguageName cObjectName cWidgetType cWidgetName iWidgetEntry
  INDEX key3 cObjectName cWidgetType cWidgetName iWidgetEntry
  INDEX key4 cWidgetName iWidgetEntry cObjectName cWidgetType
  .
  &GLOBAL-DEFINE ttTranslate
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


