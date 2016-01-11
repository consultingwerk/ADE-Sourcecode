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
  File: afgetmtrnp.p

  Description:  get Multi Translations

  Purpose:      To retrieve multiple translations from the gsm_translation table, called
                from multiTranslation in Translation Manager.

  Parameters:   input all languages YES/NO
                input-output table of translations

  History:
  --------
  (v:010000)    Task:        6120   UserRef:    
                Date:   22/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        7405   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetmtrnp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

{af/app/aftttranslate.i}

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

DEFINE INPUT PARAMETER  plAllLanguages            AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttTranslate.

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
           AND gsm_translation.WIDGET_type = ttTranslate.cWidgetType
           AND gsm_translation.WIDGET_name = ttTranslate.cWidgetName
           AND gsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
         NO-ERROR.
  END.

  IF AVAILABLE gsm_translation THEN
  DO:
    ASSIGN
      ttTranslate.cOriginalLabel = gsm_translation.original_label
      ttTranslate.cOriginalTooltip = gsm_translation.original_tooltip
      ttTranslate.cTranslatedLabel = gsm_translation.translation_label
      ttTranslate.cTranslatedTooltip = gsm_translation.translation_tooltip
      .
    IF gsm_translation.OBJECT_filename = "":U THEN
      ASSIGN ttTranslate.lGlobal = YES.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
