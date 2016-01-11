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
  File: aftrnmngrp.i

  Description:  Astra Translation Manager Code

  Purpose:      The Astra Translation Manager is a standard procedure encapsulating all
                User Interface translation code.
                This include file contains the common code for both the server and client
                Translation Manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   05/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager and Translation Manager / update supporting
                files

  (v:010002)    Task:        6010   UserRef:    
                Date:   15/06/2000  Author:     Anthony Swindells

  Update Notes: add multi-translate

  (v:010003)    Task:        6120   UserRef:    
                Date:   22/06/2000  Author:     Anthony Swindells

  Update Notes: Reduce Appserver Requests in Managers / login

  (v:010004)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers

  (v:010005)    Task:        7405   UserRef:    
                Date:   29/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

  (v:010006)    Task:        7440   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: translation business logic

  (v:010008)    Task:        7485   UserRef:    
                Date:   05/01/2001  Author:     Anthony Swindells

  Update Notes: translation fix

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftrnmngrp.i
&scop object-version    010001

/* Astra object identifying preprocessor */
&global-define astraTranslationManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */


{af/app/aftttranslation.i}
{af/app/aftttranslate.i}

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

&IF DEFINED(EXCLUDE-translatePhrase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD translatePhrase Procedure 
FUNCTION translatePhrase RETURNS CHARACTER
  ( INPUT pcText AS CHARACTER,
    INPUT pdLanguageObj AS DECIMAL )  FORWARD.

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
         HEIGHT             = 5.76
         WIDTH              = 53.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
  PROCEDURE afbldtrncp:         {af/app/afbldtrncp.p}     END PROCEDURE.
  PROCEDURE afgettranp:         {af/app/afgettranp.p}     END PROCEDURE.
  PROCEDURE afgetmtrnp:         {af/app/afgetmtrnp.p}     END PROCEDURE.
  PROCEDURE afupdmtrnp:         {af/app/afupdmtrnp.p}     END PROCEDURE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildClientCache Procedure 
PROCEDURE buildClientCache :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to load local client cache temp-table for the current
               logged in language or all languages if 0 passed in.
  Parameters:  input language obj or 0 for all
  Notes:       Clear out temp-table first to be sure.
               This is run at application start-up for maximum performance when
               a language is specified (if one is).
               At some later stage we may decide not to load data until it is
               first accessed, so the other routines must not assume the data
               is there and must be able to maintain the data.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdLanguageObj           AS DECIMAL  NO-UNDO.

IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
DO:
  EMPTY TEMP-TABLE ttTranslation.

  /* see if translation enabled */
  DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
  cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT NO).
  IF cTranslationEnabled = "NO":U THEN RETURN.

  &IF DEFINED(server-side) <> 0 &THEN
    RUN afbldtrncp (INPUT pdLanguageObj,
                    OUTPUT TABLE ttTranslation).  
  &ELSE
    RUN af/app/afbldtrncp.p ON gshAstraAppserver (INPUT pdLanguageObj,
                                                  OUTPUT TABLE ttTranslation).
  &ENDIF

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildWidgetTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildWidgetTable Procedure 
PROCEDURE buildWidgetTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure builds a temp-table of widgets that may require
               translation by walking the widget tree for the given frame
               handle. It does not actually do the translation. This 
               temp-table must then be passed to the translateWidgetTable
               procedure for subsequent translation.
               If the window handle is known and passed in, then an entry will be
               created in the temp-table for window translation.
               If the object name is passed in as blank, then only translations for
               all objects will be retrieved.
  Parameters:  input object name (path will be stripped if passed in) (blank=all)
               input language object number or 0 for login language
               input window handle (CURRENT-WINDOW) if title translation required
               input frame handle (FRAME {&FRAME-NAME}:HANDLE)
               output table of widgets for translation
  Notes:       This procedure is only valid if running on the client, as the
               frame handle will not be valid on the server.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdLanguageObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  phWindow                    AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER  phFrame                     AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttTranslate.

DEFINE VARIABLE hWidgetGroup              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnFields             AS CHARACTER  NO-UNDO.

EMPTY TEMP-TABLE ttTranslate.

IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN RETURN.  /* not valid if on server */

/* see if translation enabled */
DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "translationEnabled":U,
                                 INPUT NO).
IF cTranslationEnabled = "NO":U THEN RETURN.

ASSIGN        
  cObjectName = LC(TRIM(REPLACE(pcObjectName,"~\":U,"/":U)))
  cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1)
  .

/* if frame valid - get widgets on frame */
IF VALID-HANDLE(phFrame) THEN
DO:

  ASSIGN
      hwidgetGroup = phFrame:HANDLE
      hwidgetGroup = hwidgetGroup:FIRST-CHILD
      hWidget = hwidgetGroup:FIRST-CHILD.

  widget-walk:
  REPEAT WHILE VALID-HANDLE (hWidget):

    IF LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,slider,toggle-box":U) > 0 THEN
    DO:
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = pdLanguageObj
        ttTranslate.cObjectName = cObjectName
        ttTranslate.lGlobal = NO
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = hWidget:TYPE
        ttTranslate.cWidgetName = IF hWidget:TYPE = "TEXT":U THEN hWidget:SCREEN-VALUE ELSE
                                  (IF CAN-QUERY(hWidget, "LABEL":U) THEN hWidget:LABEL ELSE hWidget:NAME)
        ttTranslate.hWidgetHandle = hWidget:HANDLE
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = IF hWidget:TYPE = "TEXT":U THEN hWidget:SCREEN-VALUE ELSE 
                                     (IF NOT CAN-QUERY(hWidget,"LABELS":U) OR (CAN-QUERY(hWidget,"LABELS":U) AND hWidget:LABELS) THEN hWidget:LABEL ELSE "":U)    
        ttTranslate.cTranslatedLabel = "":U  
        ttTranslate.cOriginalTooltip = hWidget:TOOLTIP  
        ttTranslate.cTranslatedTooltip = "":U
        . 
    END.

    IF hWidget:TYPE = "RADIO-SET":U THEN
    DO iLoop = 1 TO NUM-ENTRIES(hWidget:RADIO-BUTTONS) BY 2:
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = pdLanguageObj
        ttTranslate.cObjectName = cObjectName
        ttTranslate.lGlobal = (IF cObjectName <> "":U THEN NO ELSE YES)
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = hWidget:TYPE
        ttTranslate.cWidgetName = IF CAN-QUERY(hWidget, "LABEL":U) THEN hWidget:LABEL ELSE hWidget:NAME
        ttTranslate.hWidgetHandle = hWidget:HANDLE
        ttTranslate.iWidgetEntry = ((iLoop + 1) / 2)
        ttTranslate.cOriginalLabel = ENTRY(INTEGER((iLoop + 1) / 2), hWidget:RADIO-BUTTONS)    
        ttTranslate.cTranslatedLabel = "":U  
        ttTranslate.cOriginalTooltip = hWidget:TOOLTIP  
        ttTranslate.cTranslatedTooltip = "":U
        .  
    END.

    IF hWidget:TYPE = "BROWSE":U THEN
    DO:
      ASSIGN
        hColumn = hWidget:FIRST-COLUMN
        NO-ERROR.

      DO iLoop = 1 TO hWidget:NUM-COLUMNS:
        CREATE ttTranslate.
        ASSIGN
          ttTranslate.dLanguageObj = pdLanguageObj
          ttTranslate.cObjectName = cObjectName
          ttTranslate.lGlobal = (IF cObjectName <> "":U THEN NO ELSE YES)
          ttTranslate.lDelete = NO
          ttTranslate.cWidgetType = hWidget:TYPE
          ttTranslate.cWidgetName = hColumn:LABEL
          ttTranslate.hWidgetHandle = phWindow
          ttTranslate.iWidgetEntry = 0
          ttTranslate.cOriginalLabel = hColumn:LABEL    
          ttTranslate.cTranslatedLabel = "":U  
          ttTranslate.cOriginalTooltip = hColumn:TOOLTIP  
          ttTranslate.cTranslatedTooltip = "":U
          .  
        ASSIGN hColumn = hColumn:NEXT-COLUMN.
      END.

    END.

    ASSIGN hWidget = hWidget:NEXT-SIBLING.
  END. /* widget-walk */

END.  /* valid-handle(phframe) */

/* if window handle valid, add entry for window title translation */
IF VALID-HANDLE(phWindow) THEN
DO:
  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = pdLanguageObj
    ttTranslate.cObjectName = cObjectName
    ttTranslate.lGlobal = (IF cObjectName <> "":U THEN NO ELSE YES)
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "TITLE":U
    ttTranslate.cWidgetName = "TITLE":U
    ttTranslate.hWidgetHandle = phWindow
    ttTranslate.iWidgetEntry = 0
    ttTranslate.cOriginalLabel = phWindow:TITLE    
    ttTranslate.cTranslatedLabel = "":U  
    ttTranslate.cOriginalTooltip = "":U  
    ttTranslate.cTranslatedTooltip = "":U
    .  
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearClientCache Procedure 
PROCEDURE clearClientCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-table to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               language maintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               language translation settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
DO:
  EMPTY TEMP-TABLE ttTranslation.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTranslation Procedure 
PROCEDURE getTranslation :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks if any translations exist for the passed in
               details.

  Parameters:  input language object number or 0 for login language      
               input object name translation for or blank for all   
               input widget type       
               input widget name (LABEL) or if type text, text to translate
               input widget entry (used for radio-sets, etc.)
               output original untranslated label
               output translated label
               output original untranslated tooltip
               output translated tooltip

  Notes:       If language not passed in, uses login language if specified.
               If object passed in as a specific object, we first look for a 
               translation for the specific object and if none exists, we look for
               a translation for all objects (blank object name).
               The widget type passed in could be title, browse, fill-in, radio-set,
               text, button, toggle-box, combo-box, slider, editor, etc.
               A special widget type and widget name of "title" for both is a special
               case for window title translation.
               A special widget type of "browse" is used and widget name of the column
               label for browse column label translation.
               For text translations, the tooltip translations are ignored.

               If the property cachedTranslationsOnly is set to YES in the session
               manager and running client side, then even if the translation is not found
               in the cache, the database is not checked.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pdLanguageObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetType                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcWidgetEntry                   AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOriginalLabel                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTranslatedLabel               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOriginalTooltip               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTranslatedTooltip             AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.

  /* see if translation enabled */
  DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
  cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT NO).
  IF cTranslationEnabled = "NO":U THEN RETURN.

  /* use login language if not passed in */
  IF pdLanguageObj = 0 THEN
  DO:
    cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                     INPUT "currentLanguageObj":U,
                                     INPUT NO).
    pdLanguageObj = DECIMAL(cPropertyList) NO-ERROR.
  END.

  /* If client side, check local cache to see if already found and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    FIND FIRST ttTranslation
         WHERE ttTranslation.language_obj = pdLanguageObj
           AND ttTranslation.OBJECT_filename = pcObjectName
           AND ttTranslation.WIDGET_type = pcWidgetType
           AND ttTranslation.WIDGET_name = pcWidgetName
           AND ttTranslation.WIDGET_entry = pcWidgetEntry
         NO-ERROR.
    IF NOT AVAILABLE ttTranslation AND pcWidgetType <> "TITLE":U THEN
      FIND FIRST ttTranslation
           WHERE ttTranslation.language_obj = pdLanguageObj
             AND ttTranslation.OBJECT_filename = "":U
             AND ttTranslation.WIDGET_type = pcWidgetType
             AND ttTranslation.WIDGET_name = pcWidgetName
             AND ttTranslation.WIDGET_entry = pcWidgetEntry
           NO-ERROR.
    IF AVAILABLE ttTranslation THEN
    DO:
      ASSIGN
        pcOriginalLabel = ttTranslation.original_label
        pcOriginalTooltip = ttTranslation.original_tooltip
        pcTranslatedLabel = ttTranslation.translation_label
        pcTranslatedTooltip = ttTranslation.translation_tooltip
        .
      RETURN.        
    END.

    /* see whether caching translations only, and if we are, do not check for translation
       server side as well
    */
    DEFINE VARIABLE cCacheTranslations            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lCacheTranslations            AS LOGICAL    INITIAL YES NO-UNDO.
    cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                     INPUT "cachedTranslationsOnly":U,
                                     INPUT NO).
    lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.
    IF lCacheTranslations THEN RETURN.

  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */


  &IF DEFINED(server-side) <> 0 &THEN
    RUN afgettranp (INPUT pdLanguageObj,
                    INPUT pcWidgetType,
                    INPUT pcWidgetName,
                    INPUT pcWidgetEntry,
                    INPUT-OUTPUT pcObjectName,
                    OUTPUT pcOriginalLabel,
                    OUTPUT pcTranslatedLabel,
                    OUTPUT pcOriginalTooltip,
                    OUTPUT pcTranslatedTooltip).  
  &ELSE
    RUN af/app/afgettranp.p ON gshAstraAppserver (INPUT pdLanguageObj,
                                                  INPUT pcWidgetType,
                                                  INPUT pcWidgetName,
                                                  INPUT pcWidgetEntry,
                                                  INPUT-OUTPUT pcObjectName,
                                                  OUTPUT pcOriginalLabel,
                                                  OUTPUT pcTranslatedLabel,
                                                  OUTPUT pcOriginalTooltip,
                                                  OUTPUT pcTranslatedTooltip).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
    CREATE ttTranslation.
    ASSIGN
      ttTranslation.language_obj = pdLanguageObj
      ttTranslation.OBJECT_filename = pcObjectName
      ttTranslation.WIDGET_type = pcWidgetType
      ttTranslation.WIDGET_name = pcWidgetName
      ttTranslation.WIDGET_entry = pcWidgetEntry
      ttTranslation.original_label = pcOriginalLabel
      ttTranslation.original_tooltip = pcOriginalTooltip
      ttTranslation.translation_label = pcTranslatedLabel
      ttTranslation.translation_tooltip = pcTranslatedTooltip
      .
    RELEASE ttTranslation.
  END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-multiTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE multiTranslation Procedure 
PROCEDURE multiTranslation :
/*------------------------------------------------------------------------------
  Purpose:     To perform multiple translations in one pass and store the results
               of the translations in a temp-table for subsequent use by the
               caller.
  Parameters:  input all languages YES/NO
               input-output table of translations
  Notes:       This is very useful for passing in all widgets on a window and
               having them translated in one pass. The temp-table contains the
               widget type and handle, so using the translated values is a 
               simple process.
               If all languages is passed in as YES, then extra records will
               be created in the temp-table for each language available. The 
               temp table must initially contain entries with a language obj
               of 0. These will be deleted following translation into each
               language.
               The all languages option only works by accessing the DB - it will 
               not use cached information. This is because it would have to go
               to the server anyway to get the list of languages.
               Dynamic toolbars only support global translations
               Window titles and tabs only support specific object translations
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  plAllLanguages            AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttTranslate.

/* see if translation enabled */
DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lNotInCache                       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dCurrentLanguageObj               AS DECIMAL    INITIAL 0 NO-UNDO.

cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "translationEnabled":U,
                                 INPUT NO).
IF cTranslationEnabled = "NO":U THEN RETURN.

/* get login language */
dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "currentLanguageObj":U,
                                 INPUT NO)).

/* set flag whether need to check database YES/NO */
IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR plAllLanguages THEN
  ASSIGN lNotInCache = YES. /* if remote or all languages, must check DB */
ELSE
  ASSIGN lNotInCache = NO.  /* if local, assume all in cache until know different */

/* check client cache if not remote */
IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) AND NOT plAllLanguages THEN
cache-loop:
FOR EACH ttTranslate:

  /* toolbar only supports global translations, window title and tabs and sdf's only specific */
  IF ttTranslate.cObjectName = "rydyntoolt.w" THEN ASSIGN ttTranslate.lGlobal = YES.
  IF ttTranslate.cWidgetType = "TITLE":U THEN ASSIGN ttTranslate.lGlobal = NO.
  IF ttTranslate.cWidgetType = "TAB":U THEN ASSIGN ttTranslate.lGlobal = NO.
  IF NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 THEN ASSIGN ttTranslate.lGlobal = NO. /* SDF */

  IF ttTranslate.dLanguageObj = 0 THEN
    ASSIGN
      ttTranslate.dLanguageObj = dCurrentLanguageObj.

  FIND FIRST ttTranslation
       WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
         AND ttTranslation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
         AND ttTranslation.WIDGET_type = ttTranslate.cWidgetType
         AND ttTranslation.WIDGET_name = ttTranslate.cWidgetName
         AND ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
       NO-ERROR.
  /* If tried specific and not found, try global */
  IF NOT AVAILABLE ttTranslation AND ttTranslate.cWidgetType <> "TITLE":U AND ttTranslate.cWidgetType <> "TAB":U AND NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 AND ttTranslate.lGlobal = NO THEN
    FIND FIRST ttTranslation
         WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
           AND ttTranslation.OBJECT_filename = "":U
           AND ttTranslation.WIDGET_type = ttTranslate.cWidgetType
           AND ttTranslation.WIDGET_name = ttTranslate.cWidgetName
           AND ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
         NO-ERROR.
  IF AVAILABLE ttTranslation THEN
  DO:
    ASSIGN
      ttTranslate.cOriginalLabel = ttTranslation.original_label
      ttTranslate.cOriginalTooltip = ttTranslation.original_tooltip
      ttTranslate.cTranslatedLabel = ttTranslation.translation_label
      ttTranslate.cTranslatedTooltip = ttTranslation.translation_tooltip
      ttTranslate.cObjectName = ttTranslation.OBJECT_filename
      .
    IF ttTranslation.OBJECT_filename = "":U THEN
      ASSIGN ttTranslate.lGlobal = YES.
  END.
  ELSE ASSIGN lNotInCache = YES.

END.  /* cache-loop */

IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) AND NOT plAllLanguages THEN
DO:
  /* see whether caching translations only, and if we are, do not check for translation
     server side as well
  */
  DEFINE VARIABLE cCacheTranslations            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCacheTranslations            AS LOGICAL    INITIAL YES NO-UNDO.
  cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "cachedTranslationsOnly":U,
                                   INPUT NO).
  lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.
  IF lCacheTranslations THEN RETURN.
END.

/* check database for translations */
IF lNotInCache THEN
DO:
  &IF DEFINED(server-side) <> 0 &THEN
    RUN afgetmtrnp (INPUT plAllLanguages,
                    INPUT-OUTPUT TABLE ttTranslate).
  &ELSE
    RUN af/app/afgetmtrnp.p ON gshAstraAppserver (INPUT plAllLanguages,
                                                  INPUT-OUTPUT TABLE ttTranslate).
  &ENDIF
END.

/* update client cache */
IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
FOR EACH ttTranslate:

  /* toolbar only supports global translations, window title and tabs and sdf's only specific */
  IF ttTranslate.cObjectName = "rydyntoolt.w" THEN ASSIGN ttTranslate.lGlobal = YES.
  IF ttTranslate.cWidgetType = "TITLE":U THEN ASSIGN ttTranslate.lGlobal = NO.
  IF ttTranslate.cWidgetType = "TAB":U THEN ASSIGN ttTranslate.lGlobal = NO.
  IF NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 THEN ASSIGN ttTranslate.lGlobal = NO. /* SDF */

  FIND FIRST ttTranslation
       WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
         AND ttTranslation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
         AND ttTranslation.WIDGET_type = ttTranslate.cWidgetType
         AND ttTranslation.WIDGET_name = ttTranslate.cWidgetName
         AND ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
       NO-ERROR.
  IF NOT AVAILABLE ttTranslation THEN
  DO:
    CREATE ttTranslation.
    ASSIGN
      ttTranslation.language_obj = ttTranslate.dLanguageObj
      ttTranslation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
      ttTranslation.WIDGET_type = ttTranslate.cWidgetType
      ttTranslation.WIDGET_name = ttTranslate.cWidgetName
      ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
      .      
  END.
  ASSIGN
    ttTranslation.original_label = ttTranslate.cOriginalLabel
    ttTranslation.original_tooltip = ttTranslate.cOriginalTooltip
    ttTranslation.translation_label = ttTranslate.cTranslatedLabel
    ttTranslation.translation_tooltip = ttTranslate.cTranslatedTooltip
    .
  RELEASE ttTranslation.

END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateWidgetTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateWidgetTable Procedure 
PROCEDURE translateWidgetTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure uses the temp-table of widgets for translation as
               built by the buildWidgetTable procedure and actually does the
               translations using the multiTranslation procedure (if not already
               done).
  Parameters:  input already translated flag YES/NO
               input translation language object number to use (0 for login language)
               input table of widgets to apply translation for.
  Notes:       This procedure is only valid if running on the client, as the
               handles will not be valid on the server.
               The already translated flag allows the multitranslation procedure
               to be run prior so that all languages could be translated in one
               pass if required. 
               The table of widgets could therefore contain entries for each 
               language. We use the entries for the passed in language, or the
               login language.
               Note that the temp-table could just have entries for one language
               with a language obj of 0 denoting the login language.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER plTranslated               AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER pdLanguageObj              AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttTranslate.                                                       

IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR
   NOT CAN-FIND(FIRST ttTranslate) THEN RETURN.  /* not valid if on server */

/* see if translation enabled */
DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "translationEnabled":U,
                                 INPUT NO).
IF cTranslationEnabled = "NO":U THEN RETURN.

DEFINE VARIABLE cRadioButtons AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyList AS CHARACTER NO-UNDO.

/* use login language if not passed in */
IF pdLanguageObj = 0 THEN
DO:
  cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "currentLanguageObj":U,
                                   INPUT NO).
  pdLanguageObj = DECIMAL(cPropertyList) NO-ERROR.
END.


/* do translations */
IF NOT plTranslated THEN
  RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                 INPUT-OUTPUT TABLE ttTranslate).
/* Fix entries in ttTranslate with no language */
FOR EACH ttTranslate
   WHERE ttTranslate.dLanguageObj = 0:
  ASSIGN ttTranslate.dLanguageObj = pdLanguageObj.
END.

FOR EACH ttTranslate
   WHERE ttTranslate.dLanguageObj = pdLanguageObj:

  CASE ttTranslate.cWidgetType:
    WHEN "TITLE":U THEN
    DO:
      IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        ttTranslate.hWidgetHandle:TITLE = ttTranslate.cTranslatedLabel.
    END.
    WHEN "RADIO-SET":U THEN
    DO:
      IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
      DO:
        ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS.
        ENTRY(ttTranslate.iWidgetEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.
        ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cRadioButtons.
      END.

      IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        ASSIGN
          ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
    END.
    WHEN "TEXT":U THEN
    DO:
      IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
      DO:
        ASSIGN
          ttTranslate.hWidgetHandle:SCREEN-VALUE = ttTranslate.cTranslatedLabel.
      END.

      IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        ASSIGN
          ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
    END.
    OTHERWISE
    DO:
      IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
      DO:
        IF NOT CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) OR
           (CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) AND ttTranslate.hWidgetHandle:LABELS) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
      END.

      IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        ASSIGN
          ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
    END.
  END CASE.

  IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND CAN-QUERY(ttTranslate.hWidgetHandle,"MODIFIED":U) THEN
    ASSIGN ttTranslate.hWidgetHandle:MODIFIED = FALSE.

END. /* FOR EACH ttTranslate */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTranslations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTranslations Procedure 
PROCEDURE updateTranslations :
/*------------------------------------------------------------------------------
  Purpose:     To update translations to DB and client cache if appropriate
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

&IF DEFINED(server-side) <> 0 &THEN
  RUN afupdmtrnp (INPUT TABLE ttTranslate).
&ELSE
  RUN af/app/afupdmtrnp.p ON gshAstraAppserver (INPUT TABLE ttTranslate).
&ENDIF

{af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */

/* get login language */
DEFINE VARIABLE dCurrentLanguageObj               AS DECIMAL    INITIAL 0 NO-UNDO.
dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "currentLanguageObj":U,
                                 INPUT NO)).

/* update client cache */
IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
translate-loop:
FOR EACH ttTranslate:
  IF ttTranslate.dLanguageObj = 0 THEN
    ASSIGN ttTranslate.dLanguageObj = dCurrentLanguageObj.
  FIND FIRST ttTranslation
       WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
         AND ttTranslation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
         AND ttTranslation.WIDGET_type = ttTranslate.cWidgetType
         AND ttTranslation.WIDGET_name = ttTranslate.cWidgetName
         AND ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
       NO-ERROR.

  IF AVAILABLE ttTranslation THEN
  DO:
    IF ttTranslate.lDelete = YES OR 
       (ttTranslate.cTranslatedLabel = "":U AND ttTranslate.cTranslatedTooltip = "":U) THEN
    DO:
      DELETE ttTranslation.
      NEXT translate-loop.
    END.
  END.

  IF ttTranslate.lDelete = YES OR 
     (ttTranslate.cTranslatedLabel = "":U AND ttTranslate.cTranslatedTooltip = "":U) THEN NEXT translate-loop.

  IF NOT AVAILABLE ttTranslation THEN
  DO:
    CREATE ttTranslation.
    ASSIGN
      ttTranslation.language_obj = ttTranslate.dLanguageObj
      ttTranslation.OBJECT_filename = (IF ttTranslate.lGlobal = NO THEN ttTranslate.cObjectName ELSE "":U)
      ttTranslation.WIDGET_type = ttTranslate.cWidgetType
      ttTranslation.WIDGET_name = ttTranslate.cWidgetName
      ttTranslation.WIDGET_entry = ttTranslate.iWidgetEntry
      .      
  END.
  ASSIGN
    ttTranslation.original_label = ttTranslate.cOriginalLabel
    ttTranslation.original_tooltip = ttTranslate.cOriginalTooltip
    ttTranslation.translation_label = ttTranslate.cTranslatedLabel
    ttTranslation.translation_tooltip = ttTranslate.cTranslatedTooltip
    .
  RELEASE ttTranslation.

END. /* NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

ASSIGN dCurrentLanguageObj = dCurrentLanguageObj NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-translatePhrase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION translatePhrase Procedure 
FUNCTION translatePhrase RETURNS CHARACTER
  ( INPUT pcText AS CHARACTER,
    INPUT pdLanguageObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: To translate a text phrase into the given language
    Notes: Returns translated text. If translation not found, simply returns
           original text passed in.
           If language not passed in, defaults to login language
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalLabel                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTranslationLabel             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalTooltip              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTranslationTooltip           AS CHARACTER  NO-UNDO.

  /* see if translation enabled */
  DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
  cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT NO).
  IF cTranslationEnabled = "NO":U THEN RETURN pcText.

  IF pdLanguageObj = 0 THEN
  DO:
    cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                     INPUT "currentLanguageObj":U,
                                     INPUT NO).
    pdLanguageObj = DECIMAL(cPropertyList) NO-ERROR.
  END.

  RUN getTranslation IN gshTranslationManager (INPUT pdLanguageObj,
                                               INPUT "":U,
                                               INPUT "TEXT":U,
                                               INPUT pcText,
                                               INPUT 0,
                                               OUTPUT cOriginalLabel,
                                               OUTPUT cTranslationLabel,
                                               OUTPUT cOriginalTooltip,
                                               OUTPUT cTranslationTooltip
                                               ).

  IF cTranslationLabel <> "":U AND cTranslationLabel <> ? THEN
    RETURN cTranslationLabel.
  ELSE
    RETURN pcText.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

