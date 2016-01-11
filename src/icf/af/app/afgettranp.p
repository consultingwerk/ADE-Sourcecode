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
  File: afgettranp.p

  Description:  get Translation

  Purpose:      To retrieve a translation from the gsm_translation table, called
                from getTranslation in Translation Manager.

  Parameters:   input language object number or 0 for login language
                input widget type
                input widget name or if type text, text to translate
                input widget entry (used for radio-sets, etc.)
                input-output object name translation for or blank for all
                output original untranslated label
                output translated label
                output original untranslated tooltip
                output translated tooltip

  History:
  --------
  (v:010000)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6010   UserRef:    
                Date:   15/06/2000  Author:     Anthony Swindells

  Update Notes: fix nolock

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgettranp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


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


  DEFINE INPUT PARAMETER  pdLanguageObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetType                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetEntry                   AS INTEGER      NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER  pcObjectName             AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOriginalLabel                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTranslatedLabel               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOriginalTooltip               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTranslatedTooltip             AS CHARACTER    NO-UNDO.

  FIND FIRST gsm_translation NO-LOCK
       WHERE gsm_translation.language_obj = pdLanguageObj
         AND gsm_translation.OBJECT_filename = pcObjectName
         AND gsm_translation.WIDGET_type = pcWidgetType
         AND gsm_translation.WIDGET_name = pcWidgetName
         AND gsm_translation.WIDGET_entry = pcWidgetEntry
       NO-ERROR.

  IF NOT AVAILABLE gsm_translation AND pcWidgetType <> "TITLE":U THEN
  DO:
    FIND FIRST gsm_translation NO-LOCK
         WHERE gsm_translation.language_obj = pdLanguageObj
           AND gsm_translation.OBJECT_filename = "":U
           AND gsm_translation.WIDGET_type = pcWidgetType
           AND gsm_translation.WIDGET_name = pcWidgetName
           AND gsm_translation.WIDGET_entry = pcWidgetEntry
         NO-ERROR.
    /* if found for blank file, store this fact in cache */
    IF AVAILABLE gsm_translation THEN ASSIGN pcObjectName = "":U.
  END.

  IF AVAILABLE gsm_translation THEN
    ASSIGN
      pcOriginalLabel = gsm_translation.original_label
      pcOriginalTooltip = gsm_translation.original_tooltip
      pcTranslatedLabel = gsm_translation.translation_label
      pcTranslatedTooltip = gsm_translation.translation_tooltip
      .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


