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
/* Copyright (C) 2000-2006 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
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

  (v:010009)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in various places.

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftrnmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraTranslationManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

{af/app/aftttranslation.i}
{src/adm2/tttranslate.i}

{af/sup2/afcheckerr.i &define-only = YES}

DEFINE VARIABLE gdCachedLanguageObj AS DECIMAL    NO-UNDO.

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
         HEIGHT             = 16.1
         WIDTH              = 47.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-afbldtrncp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afbldtrncp Procedure 
PROCEDURE afbldtrncp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEFINE INPUT PARAMETER  pdLanguageObj           AS DECIMAL  NO-UNDO.
      DEFINE OUTPUT PARAMETER TABLE FOR ttTranslation.

      &IF DEFINED(server-side) = 0 &THEN
        /* We need to pass the request to the Appserver */
        RUN af/app/aftrnbldtrncp.p ON gshAstraAppServer
          (INPUT pdLanguageObj,
           OUTPUT TABLE ttTranslation) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
      &ELSE 
        {af/app/aftrnbldtrncp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afgetmtrnp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afgetmtrnp Procedure 
PROCEDURE afgetmtrnp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  plAllLanguages  AS LOGICAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttTranslate.

    &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
      RUN af/app/aftrngetmtrnp.p ON gshAstraAppServer
        (INPUT plAllLanguages,
         INPUT-OUTPUT TABLE ttTranslate) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE 
      {af/app/aftrngetmtrnp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afgettranp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afgettranp Procedure 
PROCEDURE afgettranp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE        INPUT PARAMETER pdLanguageObj       AS DECIMAL   NO-UNDO.
    DEFINE        INPUT PARAMETER pcWidgetType        AS CHARACTER NO-UNDO.
    DEFINE        INPUT PARAMETER pcWidgetName        AS CHARACTER NO-UNDO.
    DEFINE        INPUT PARAMETER pcWidgetEntry       AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcObjectName        AS CHARACTER NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcOriginalLabel     AS CHARACTER NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcTranslatedLabel   AS CHARACTER NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcOriginalTooltip   AS CHARACTER NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcTranslatedTooltip AS CHARACTER NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
      RUN af/app/aftrngettranp.p ON gshAstraAppServer
        (INPUT pdLanguageObj,      
         INPUT pcWidgetType,       
         INPUT pcWidgetName,       
         INPUT pcWidgetEntry,      
         INPUT-OUTPUT pcObjectName,       
         OUTPUT pcOriginalLabel,    
         OUTPUT pcTranslatedLabel,  
         OUTPUT pcOriginalTooltip,  
         OUTPUT pcTranslatedTooltip) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
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
                 AND gsm_translation.WIDGET_type = '':u
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
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afupdmtrnp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afupdmtrnp Procedure 
PROCEDURE afupdmtrnp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

    &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
      RUN af/app/aftrnupdmtrnp.p ON gshAstraAppServer
        (INPUT TABLE ttTranslate) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE 
      {af/app/aftrnupdmtrnp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
IF gdCachedLanguageObj = pdLanguageObj THEN /* We DO have this language cached */
    RETURN.
ELSE
    ASSIGN gdCachedLanguageObj = pdLanguageObj. /* We're going to cache this language below */

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
  EMPTY TEMP-TABLE ttTranslation.

  /* see if translation enabled */
  DEFINE VARIABLE cTranslationEnabled               AS CHARACTER  NO-UNDO.
  cTranslationEnabled = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "translationEnabled":U,
                                   INPUT NO).
  IF cTranslationEnabled = "NO":U THEN RETURN.

  RUN afbldtrncp IN TARGET-PROCEDURE (INPUT pdLanguageObj,OUTPUT TABLE ttTranslation).  
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

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN RETURN.  /* not valid if on server */

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
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
  EMPTY TEMP-TABLE ttTranslation.
  ASSIGN gdCachedLanguageObj = 0.
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
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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
             AND ttTranslation.WIDGET_type = '':U    /* object filename and type blank for global */
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

  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */


  RUN afgettranp IN TARGET-PROCEDURE
                   ( INPUT pdLanguageObj,
                     INPUT pcWidgetType,
                     INPUT pcWidgetName,
                     INPUT pcWidgetEntry,
                     INPUT-OUTPUT pcObjectName,
                    OUTPUT pcOriginalLabel,
                    OUTPUT pcTranslatedLabel,
                    OUTPUT pcOriginalTooltip,
                    OUTPUT pcTranslatedTooltip).  

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

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
IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR plAllLanguages THEN
  ASSIGN lNotInCache = YES. /* if remote or all languages, must check DB */
ELSE
  ASSIGN lNotInCache = NO.  /* if local, assume all in cache until know different */

/* check client cache if not remote */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT plAllLanguages THEN
cache-loop:
FOR EACH ttTranslate:

  /* toolbar only supports global translations, sdf's only specific */
  IF ttTranslate.cObjectName = "rydyntoolt.w" THEN ASSIGN ttTranslate.lGlobal = YES.
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
  IF NOT AVAILABLE ttTranslation AND 
     NOT NUM-ENTRIES(ttTranslate.cObjectName,":":U) = 2 AND 
     ttTranslate.lGlobal = NO THEN
    FIND FIRST ttTranslation
         WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
           AND ttTranslation.OBJECT_filename = "":U
           AND ttTranslation.WIDGET_type = "":U
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

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT plAllLanguages THEN
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
    RUN afgetmtrnp IN TARGET-PROCEDURE (INPUT plAllLanguages,INPUT-OUTPUT TABLE ttTranslate).

/* update client cache */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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

END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

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

&IF DEFINED(EXCLUDE-receiveCacheClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheClient Procedure 
PROCEDURE receiveCacheClient :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttTranslation.
DEFINE INPUT PARAMETER pdLanguageObj AS DECIMAL    NO-UNDO.

ASSIGN gdCachedLanguageObj = pdLanguageObj.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateToolbar Procedure 
PROCEDURE translateToolbar :
/*------------------------------------------------------------------------------
  Purpose:     Translates an entire menu or toolbar's worth of actions (menu items).
  Parameters:  pcLanguageCode - this parameter is passed straight through to
                                the translateAction() API, and all validation is done
                                there. See the doc for that API for more details.      	
  		       phBuffer - A buffer of a table that contains translations. Typically
  		                  a temp-table, like the ttActionTranslation table defined
  		                  for the toolbar in adm2/ttacion.i
  Notes:       * This API acts as a wrapper for the translateAction() API, but
  			     it also bundles together a whole bunch of menu items so as to 
  			     avoid multiple AppServer calls and ensures that only one is made.
  			   - The phBuffer parameter doesn't strictly need to be an input-output 
  			     parameter, since a buffer simply refers to a place in memory, but
  			     has been made so to indicate that the buffer has been operated on
  			     and will be changeedd by this API.
------------------------------------------------------------------------------*/
    define input        parameter pcLanguageCode  as character             no-undo.
    define input-output parameter phBuffer        as handle                no-undo.
    
    define variable cReturnValue         as character                     no-undo.
    define variable lError               as logical                       no-undo.
    define variable lTranslationEnabled  as logical                       no-undo.
    
    /* Only do anything if translation is enabled. */
    lTranslationEnabled = logical(dynamic-function('getPropertyList' in gshSessionManager,
                                                   'TranslationEnabled', no) ) no-error.
    if lTranslationEnabled eq no then
    do:
        error-status:error = no.
        return.
    end.    /* translation not enabled */
    
    &if defined(server-side) = 0 &then
    define variable hTable            as handle                         no-undo.
    
    hTable = phBuffer:table-handle.
    run af/app/aftrntrmep.p on gshAstraAppserver (input        pcLanguageCode,
                                                  input-output table-handle hTable) no-error.
    if error-status:error or return-value ne '' then
        return error (if return-value eq '' then error-status:get-message(1) else return-value).
    &else
    define variable hQuery               as handle                        no-undo.
    define variable cItem                as character                     no-undo.
    define variable cLabel               as character                     no-undo.
    define variable cCaption             as character                     no-undo.
    define variable cTooltip             as character                     no-undo.
    define variable cAccelerator         as character                     no-undo.
    define variable cImage               as character                     no-undo.
    define variable cImageDown           as character                     no-undo.
    define variable cImageInsensitive    as character                     no-undo.
    define variable cImage2              as character                     no-undo.
    define variable cImage2Down          as character                     no-undo.
    define variable cImage2Insensitive   as character                     no-undo.
    
    create query hQuery.
    hQuery:set-buffers(phBuffer).
    hQuery:query-prepare('for each ' + phBuffer:name).
    hQuery:query-open().
    
    hQuery:get-first().
    do while phBuffer:available:
        cItem = phBuffer:buffer-field('Action'):buffer-value.
        
        run translateAction in gshTranslationManager ( input  pcLanguageCode,
                                                       input  cItem,
                                                       output cLabel,
                                                       output cCaption,
                                                       output cTooltip,
                                                       output cAccelerator,
                                                       output cImage,
                                                       output cImageDown,
                                                       output cImageInsensitive,
                                                       output cImage2,
                                                       output cImage2Down,
                                                       output cImage2Insensitive ) no-error.
        if error-status:error or return-value ne '' then
        do:
            lError = error-status:error.
            cReturnValue = return-value.            
            leave.
        end.    /* error */
        
        assign phBuffer:buffer-field('Name'):buffer-value = cLabel
               phBuffer:buffer-field('Caption'):buffer-value = cCaption
               phBuffer:buffer-field('Tooltip'):buffer-value = cTooltip
               phBuffer:buffer-field('Accelerator'):buffer-value = cAccelerator
               phBuffer:buffer-field('Image'):buffer-value = cImage
               phBuffer:buffer-field('ImageDown'):buffer-value = cImageDown
               phBuffer:buffer-field('ImageInsensitive'):buffer-value = cImageInsensitive
               phBuffer:buffer-field('Image2'):buffer-value = cImage2
               phBuffer:buffer-field('Image2Down'):buffer-value = cImage2Down
               phBuffer:buffer-field('Image2Insensitive'):buffer-value = cImage2Insensitive.
        
        hQuery:get-next().
    end.    /* available query */    
    hQuery:query-close().
    delete object hQuery no-error.
    hQuery = ?.
    &endif
    
    error-status:error = lError.
    return cReturnValue.
END PROCEDURE.    /* translateToolbar */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateAction Procedure 
PROCEDURE translateAction :
/*------------------------------------------------------------------------------
  Purpose:     Translates a single menu item (action)
  Parameters:  input  pcLanguageCode
               input  pcItem
               output pcLabel
               output pcCaption
               output pcTooltip
               output pcAccelerator
               output pcImage
               output pcImageDown
               output pcImageInsensitive
               output pcImage2
               output pcImage2Down
               output pcImage2Insensitive
  Notes:       * The unknown value for the return parameters means that they haven't 
                 been translated.
               * The language code parameter can must be either a value corresponding 
                 the the language_code field on the gsc_language table, or a string
                 consisting of 'OBJ|' + a decimal corresponding to the language_obj 
                 of the gsc_language table. 
               * The latter use is so that this API can be called from a client session,
                 which only stores the object ID of the current language in context.
------------------------------------------------------------------------------*/   
    define input  parameter pcLanguageCode       as character         no-undo.
    define input  parameter pcItem               as character         no-undo.
    define output parameter pcLabel              as character         no-undo.
    define output parameter pcCaption            as character         no-undo.
    define output parameter pcTooltip            as character         no-undo.
    define output parameter pcAccelerator        as character         no-undo.
    define output parameter pcImage              as character         no-undo.
    define output parameter pcImageDown          as character         no-undo.
    define output parameter pcImageInsensitive   as character         no-undo.
    define output parameter pcImage2             as character         no-undo.
    define output parameter pcImage2Down         as character         no-undo.
    define output parameter pcImage2Insensitive  as character         no-undo.
    
    define variable lTranslationEnabled          as logical           no-undo.
    
    /* Initialize return parameters. The unknown value means that
       there are no translations present.
     */
    assign pcLabel = ?
           pcCaption = ?
           pcTooltip = ?
           pcAccelerator = ?
           pcImage = ?
           pcImageDown = ?
           pcImageInsensitive = ?
           pcImage2 = ?
           pcImage2Down = ?
           pcImage2Insensitive = ?.    
    
    /* Only do anything if translation is enabled. */
    lTranslationEnabled = logical(dynamic-function('getPropertyList' in gshSessionManager,
                                                   'TranslationEnabled', no) ) no-error.
    if lTranslationEnabled eq no then
    do:
        error-status:error = no.
        return.
    end.    /* translation not enabled */
    
    &if defined(Server-Side) = 0 &then
    run af/app/aftrntrmip.p on gshAstraAppServer ( input  pcLanguageCode,
                                                   input  pcItem,
                                                   output pcLabel,
                                                   output pcCaption,
                                                   output pcTooltip,
                                                   output pcAccelerator,
                                                   output pcImage,
                                                   output pcImageDown,
                                                   output pcImageInsensitive,
                                                   output pcImage2,
                                                   output pcImage2Down,
                                                   output pcImage2Insensitive  ) no-error.
    if error-status:error or return-value ne '' then
        return error (if return-value eq '' then error-status:get-message(1) else return-value).
    &else
    define buffer gsclg        for gsc_language.
    define buffer gsmti        for gsm_translated_menu_item.
    define buffer gsmmi        for gsm_menu_item.
    
    /* Validate the input language code */
    if pcLanguageCode eq ? or pcLanguageCode eq '' then
        return error {aferrortxt.i 'AF' '1' 'gsclg' 'language_code' 'language'}.
    
    if pcLanguageCode begins 'OBJ|' then
    do:
        pcLanguageCode = replace(pcLanguageCode, 'OBJ|', '').
        find first gsclg where
                   gsclg.language_obj = decimal(pcLanguageCode)
                   no-lock no-error.
    end.    /* code begins 'OBJ' */
    else
        find first gsclg where
                   gsclg.language_code = pcLanguageCode
                   no-lock no-error.
    if not available gsclg then
        return error {aferrortxt.i 'AF' '5' 'gsclg' 'language_code' 'language' "'Language code: ' + pcLanguageCode"}.
    
    /* Validate the menu item */    
    if pcItem eq ? or pcItem eq '' then
        return error {aferrortxt.i 'AF' '1' 'gsmmi' 'menu_item_reference' '"menu item"'}.
    
    find first gsmmi where
               gsmmi.menu_item_reference = pcItem
               no-lock no-error.
    if not available gsmmi then
        return error {aferrortxt.i 'AF' '5' 'gsmmi' 'menu_item_reference' '"menu item"' "'Menu item: ' + pcItem"}.
    
    /* Check whether there are any translations for this language. */
    find first gsmti where
               gsmti.menu_item_obj = gsmmi.menu_item_obj and
               gsmti.language_obj = gsclg.language_obj
               no-lock no-error.
    /* If there are no translations available, then return gracefully. */
    if not available gsmti then
    do:
        error-status:error = no.
        return.
    end.    /* no translations */
    
    /* Now apply the translation(s). */
    
    /* If an image has been specified for the menu item, but not a picclip, we clear
       the picclip image from the menu item to ensure the translation image gets used.
       Picclip images always get preference, meaning the untranslated image would get
       used if we didn't clear it.
     */
    if gsmti.image1_up_filename ne '' and gsmti.image1_down_filename eq '' then
        pcImageDown = ''.
    
    if gsmti.image2_up_filename ne '' and gsmti.image2_down_filename eq '' then
        pcImage2Down = "":U.
            
    if gsmti.item_toolbar_label ne '' then
        pcLabel = gsmti.item_toolbar_label.
    
    if gsmti.menu_item_label ne '' then
        pcCaption = gsmti.menu_item_label.

    if gsmti.tooltip_text ne '' then
        pcTooltip = gsmti.tooltip_text.
            
    if gsmti.alternate_shortcut_key ne '' then   
        pcAccelerator = gsmti.alternate_shortcut_key.
            
    if gsmti.image1_up_filename ne '' then
        pcImage = gsmti.image1_up_filename.
            
    if gsmti.image1_down_filename ne '' then
        pcImageDown = gsmti.image1_down_filename.

    if gsmti.image1_insensitive_filename ne '' then
        pcImageInsensitive = gsmti.image1_insensitive_filename.
            
    if gsmti.image2_up_filename ne '' then
        pcImage2 = gsmti.image2_up_filename.
            
    if gsmti.image2_down_filename ne '' then
        pcImage2Down = gsmti.image2_down_filename.
    
    if gsmti.image2_insensitive_filename ne '' then
        pcImage2Insensitive = gsmti.image2_insensitive_filename.
    
    /* Check if we really want an image */
    assign pcImage = if pcImage eq 'NoImage' then '' else pcImage
           pcImageDown = if pcImageDown eq 'NoImage' then '' else pcImageDown
           pcImageInsensitive = if pcImageInsensitive eq 'NoImage' then '' else pcImageInsensitive
           pcImage2 = if pcImage2 eq 'NoImage' then '' else pcImage2
           pcImage2Down = if pcImage2Down eq 'NoImage' then '' else pcImage2Down
           pcImage2Insensitive = if pcImage2Insensitive eq 'NoImage' then '' else pcImage2Insensitive.
    &endif
    
    error-status:error = no.
    return.
END PROCEDURE.    /* translateAction */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateSingleObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateSingleObject Procedure 
PROCEDURE translateSingleObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Provides translated label(s) and tooltips(s) for a single object.
  Parameters:  pdLanguageObj   -
               pcObjectName    -
               pcWidgetName    -
               pcWidgetType    -
               piWidgetEntries -
               pcLabels        -
               pcTooltips      -
  Notes:       * This API is meant to be called from the Repository Object 
                 retrieval process. It is design to avoid the overhead of creating
                 table entries, performing translations and then reading through the
                 translations and applying them to the object being retrieved.
               * Default global search to NO.
               * This API assumes that the language obj passed in is valid.
------------------------------------------------------------------------------*/
    define input  parameter pdLanguageObj   as decimal              no-undo.
    define input  parameter pcObjectName    as character            no-undo.
    define input  parameter pcWidgetName    as character            no-undo.
    define input  parameter pcWidgetType    as character            no-undo.
    define input  parameter piWidgetEntries as integer              no-undo.
    define output parameter pcLabels        as character            no-undo.
    define output parameter pcTooltips      as character            no-undo.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    run af/app/aftrntrsop.p on gshAstraAppserver ( input  pdLanguageObj,
                                                   input  pcObjectName,
                                                   input  pcWidgetName,
                                                   input  pcWidgetType,
                                                   input  piWidgetEntries,
                                                   output pcLabels,
                                                   output pcTooltips          ) no-error.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    define variable lGlobal         as logical  initial YES     no-undo.
    define variable iWidgetEntry    as integer                  no-undo.
    
    /* Don't bother going any further if there are no translations set for this language.
     */
    if not can-find(first gsm_translation where gsm_translation.language_obj = pdLanguageObj) then
        return.
    
    /* The toolbar only supports global translations.
     *
     * This is supported by setting the object name to blank. This
     * emulates the global behaviour, and so we can set the global flag
     * to NO to avoid performing a second, unnecessary find first. 
     */
    IF pcObjectName eq "rydyntoolt.w" THEN
        ASSIGN lGlobal      = no
               pcObjectName = "":U.

    /* Most translations will have no piWidgetEntries.
     * Typically radio-set buttons and tabs (folder pages) will have multiple entries;
     * however, the widget types that have multiple entries are not limited to this.
     */    
    do iWidgetEntry = (IF pcWidgetType = "TAB":U OR 
                          pcWidgetType = "RADIO-SET":U OR
                          pcWidgetType = "DATAFIELD":U THEN 1 ELSE 0) to piWidgetEntries:
        FIND FIRST gsm_translation WHERE
                   gsm_translation.language_obj    = pdLanguageObj and
                   gsm_translation.object_filename = pcObjectName  and
                   gsm_translation.widget_type     = pcWidgetType  and
                   gsm_translation.widget_name     = pcWidgetName  and
                   gsm_translation.widget_entry    = iWidgetEntry
                   no-lock NO-ERROR.
        /* If we need to look for global stuff, do so now. */                   
        if not available gsm_translation and lGlobal then
            FIND FIRST gsm_translation WHERE
                       gsm_translation.language_obj    = pdLanguageObj and
                       gsm_translation.object_filename = "":U          and
                       gsm_translation.widget_type     = "":U          and
                       gsm_translation.widget_name     = pcWidgetName  and
                       gsm_translation.widget_entry    = iWidgetEntry
                       no-lock NO-ERROR.
        
        if available gsm_translation then
            assign pcLabels   = pcLabels   + chr(3) + gsm_translation.translation_label
                   pcTooltips = pcTooltips + chr(3) + gsm_translation.translation_tooltip.
        else
            assign pcLabels   = pcLabels   + chr(3) + "":U
                   pcTooltips = pcTooltips + chr(3) + "":U.
    end.    /* loop through widget entries */
    
    /* Get rid of leading delimiters. */
    assign pcLabels   = substring(pcLabels, 2)
           pcTooltips = substring(pcTooltips, 2).
    &endif  /* server-side */
    
    assign error-status:error = no.
    return.
END PROCEDURE.  /* translateSingleObject */

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

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR
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
  RUN multiTranslation IN TARGET-PROCEDURE (INPUT NO,INPUT-OUTPUT TABLE ttTranslate).

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

RUN afupdmtrnp IN TARGET-PROCEDURE (INPUT TABLE ttTranslate) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
  RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* get login language */
DEFINE VARIABLE dCurrentLanguageObj               AS DECIMAL    INITIAL 0 NO-UNDO.
dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "currentLanguageObj":U,
                                 INPUT NO)).

/* update client cache */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
translate-loop:
FOR EACH ttTranslate:
  IF ttTranslate.dLanguageObj = 0 THEN
    ASSIGN ttTranslate.dLanguageObj = dCurrentLanguageObj.

  IF ttTranslate.lGlobal THEN
      ASSIGN ttTranslate.cObjectName = "":U
             ttTranslate.cWidgetType = "":U.

  FIND FIRST ttTranslation
       WHERE ttTranslation.language_obj = ttTranslate.dLanguageObj
         AND ttTranslation.OBJECT_filename = ttTranslate.cObjectName
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
      ttTranslation.OBJECT_filename = ttTranslate.cObjectName
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

END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

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

  RUN getTranslation IN TARGET-PROCEDURE (INPUT pdLanguageObj,
                                          INPUT "":U,
                                          INPUT "TEXT":U,
                                          INPUT pcText,
                                          INPUT 0,
                                         OUTPUT cOriginalLabel,
                                         OUTPUT cTranslationLabel,
                                         OUTPUT cOriginalTooltip,
                                         OUTPUT cTranslationTooltip).

  IF cTranslationLabel <> "":U AND cTranslationLabel <> ? THEN
    RETURN cTranslationLabel.
  ELSE
    RETURN pcText.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

