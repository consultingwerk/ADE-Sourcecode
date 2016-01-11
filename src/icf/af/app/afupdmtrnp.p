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
  File: afupdmtrnp.p

  Description:  Update multiple translations

  Purpose:      Update multiple translations, called from updateTranslation in Translation
                Manager.

  Parameters:   input table of translations

  History:
  --------
  (v:010000)    Task:        7405   UserRef:    
                Date:   29/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

  (v:010001)    Task:        7440   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: translation business logic

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afupdmtrnp.p
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

DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

DEFINE BUFFER bgsm_translation FOR gsm_translation.

trn-block:
DO FOR bgsm_translation TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  translate-loop:
  FOR EACH ttTranslate:

    FIND FIRST bgsm_translation EXCLUSIVE-LOCK
         WHERE bgsm_translation.language_obj = ttTranslate.dLanguageObj
           AND bgsm_translation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
           AND bgsm_translation.WIDGET_type = ttTranslate.cWidgetType
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
    END.

    ERROR-STATUS:ERROR = NO.  /* clear error status */    

    IF ttTranslate.lDelete = YES OR 
       (ttTranslate.cTranslatedLabel = "":U AND ttTranslate.cTranslatedTooltip = "":U) THEN NEXT translate-loop.

    IF NOT AVAILABLE bgsm_translation THEN
    DO:
      CREATE bgsm_translation NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      ASSIGN
        bgsm_translation.language_obj = ttTranslate.dLanguageObj
        bgsm_translation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
        bgsm_translation.WIDGET_type = ttTranslate.cWidgetType
        bgsm_translation.WIDGET_name = ttTranslate.cWidgetName
        bgsm_translation.WIDGET_entry = ttTranslate.iWidgetEntry
        .      
    END.
    ASSIGN
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


