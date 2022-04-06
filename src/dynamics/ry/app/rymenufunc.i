&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : rymenufunc.i
    Purpose     : Extract bands and actions from the icf database.

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{src/adm2/globals.i}  
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

DEFINE TEMP-TABLE ttBandToExtract NO-UNDO
    FIELD parent_menu_structure_code AS CHARACTER
    FIELD menu_structure_type        AS CHARACTER    
    FIELD menu_structure_obj         AS DECIMAL
    FIELD menu_structure_code        AS CHARACTER
    FIELD extract_sequence           AS INTEGER
    FIELD disabled                   AS LOGICAL
    FIELD under_development          AS LOGICAL
    FIELD menu_item_obj              AS DECIMAL
    FIELD control_spacing            AS INTEGER
    FIELD control_padding            AS INTEGER
    INDEX idx0 IS PRIMARY extract_sequence
    INDEX idx1 menu_structure_obj.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildAction Include 
FUNCTION buildAction RETURNS CHARACTER
  ( pdObj     AS DEC,
    pdUserObj AS DEC,
    pdOrganisationObj AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildBand Include 
FUNCTION buildBand RETURNS LOGICAL
  ( pcBand    AS CHARACTER,
    plTopOnly AS LOG,
    pdUserObj AS DEC,
    pdOrganisationObj AS DEC) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindTranslation Include 
FUNCTION canFindTranslation RETURNS DECIMAL
  ( pdMenuItemObj       AS DECIMAL,
    pdLoginLanguageObj  AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createAction Include 
FUNCTION createAction RETURNS CHARACTER
  (pdObj AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractBand Include 
PROCEDURE extractBand :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will extract the toolbar band passed in.
  Parameters:  pcBand - The name of the band to extract
               plDevelopmentUser - Is the user currently logged in a development user?
               plSecurityEnabled - Is security enabled for this session?
               pcSecurityModel - The security model we're running against, either "Grant" or "Revoke"
               plGSMMSSecurityExists - Does any menu structure security applicable to this user exist?
               plGSMMISecurityExists - Does any menu item security applicable to this user exist?
               plRYCSOSecurityExists - Does any object security applicable to this user exist?
               plTranslationEnabled - Is translation enabled for this session?
               pdLoginLanguageObj - The language the user logged in for.
               pdUserObj - The user_obj of the currently logged in user.
               pdOrganisationObj - The organisation the user logged in for.
  Notes:       Have a look at the main block of ry/app/rygetmensp.p to see how these parameters
               are populated.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcBand                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plDevelopmentUser     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plSecurityEnabled     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER pcSecurityModel       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plGSMMSSecurityExists AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plGSMMISecurityExists AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plRYCSOSecurityExists AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plTranslationEnabled  AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER pdLoginLanguageObj    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdUserObj             AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdOrganisationObj     AS DECIMAL    NO-UNDO.

/* NOTE, some of these buffer and variable definitions are used in {ry/app/rymenuitmc.i} */
DEFINE BUFFER ttBandToExtract            FOR ttBandToExtract.
DEFINE BUFFER bttBandToExtract           FOR ttBandToExtract.
DEFINE BUFFER ryc_smartobject            FOR ryc_smartobject.
DEFINE BUFFER gsc_instance_attribute     FOR gsc_instance_attribute.
DEFINE BUFFER gsm_menu_structure         FOR gsm_menu_structure.
DEFINE BUFFER bgsm_menu_structure        FOR gsm_menu_structure.
DEFINE BUFFER gsm_menu_structure_item    FOR gsm_menu_structure_item.
DEFINE BUFFER gsm_menu_item              FOR gsm_menu_item.
DEFINE BUFFER gsc_item_category          FOR gsc_item_category.
DEFINE BUFFER parent_item_category       FOR gsc_item_category.
DEFINE BUFFER gsm_translated_menu_item   FOR gsm_translated_menu_item.

DEFINE VARIABLE cLogicalObject      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttribute          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRequiredDBList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lPersistent         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iSequence           AS INTEGER    NO-UNDO.
DEFINE VARIABLE lBandHasActions     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityDummyValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSecured            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMenuStructureItem  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChildMenuStructure AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dContainerObjectObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTransLanguageObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cContainerName      AS CHARACTER  NO-UNDO.

FIND gsm_menu_structure NO-LOCK
     WHERE gsm_menu_structure.menu_structure_code = pcBand
     NO-ERROR.

IF NOT AVAILABLE gsm_menu_structure THEN
    RETURN.

/* We need to extract the band, so create a ttBandToExtract record */
EMPTY TEMP-TABLE ttBandToExtract.

CREATE ttBandToExtract.
BUFFER-COPY gsm_menu_structure
         TO ttBandToExtract
     ASSIGN iSequence = iSequence + 1
            ttBandToExtract.extract_sequence = iSequence.

/* We've got all the toolbars/menus linked to the object.  Now extract all the structures and     *
 * menu items applicable to the object recursively.  Instead of using a recursive procedure, we   *
 * use the ttBandToExtract temp-table to store parent-child relationships.                        *
 * As we find child bands linked to parent bands, we'll create a ttBandToExtract record,          *
 * which will result in us extracting the child band next time through the loop.                  */
band-extract-blk:
FOR EACH ttBandToExtract
      BY ttBandToExtract.extract_sequence:

    FIND ttBand
         WHERE ttBand.band = ttBandToExtract.menu_structure_code
         NO-ERROR.

    /* If the band has not been extracted yet, do so. If it has, we don't have to do anything.   *
     * The relationship between the parent of this band and itself will already have been stored *
     * when the parent was extracted.                                                            */
    IF NOT AVAILABLE ttBand
    THEN DO:
        /* Conditions to skip the creation of this band */
        IF ttBandToExtract.DISABLED
        OR (ttBandToExtract.under_development
        AND NOT plDevelopmentUser) THEN
            NEXT band-extract-blk.
    
        /* Check menu structure security */
        IF plGSMMSSecurityExists
        THEN DO:
            RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                                         INPUT pdOrganisationObj,
                                                         INPUT "GSMMS":U,
                                                         INPUT ttBandToExtract.menu_structure_obj,
                                                         INPUT NO,
                                                         OUTPUT lSecured,
                                                         OUTPUT cSecurityDummyValue,
                                                         OUTPUT cSecurityDummyValue).
            IF lSecured THEN
                NEXT band-extract-blk.
        END.
        ELSE
            /* If no structure security exists, the administrator hasn't allocated any to this user. *
             * In a grant model, this means the structure is secured.  In a revoke model, it isn't.  */
            IF plSecurityEnabled
            AND pcSecurityModel = "Grant":U THEN
                NEXT band-extract-blk.

        /* We use lBandHasActions to check if we should create the band record later (only if the band has actions). *
         * cMenuStructureItem is used to check if an action has been linked directly to a band.                      */
        ASSIGN lBandHasActions    = NO
               cMenuStructureItem = "":U.

        /* Do we have an action assigned directly to the structure? *
         * If so, extract it and link it.                           */
        IF ttBandToExtract.menu_item_obj <> 0
        THEN then-blk: DO:
            FIND ttAction
                 WHERE ttAction.menu_item_obj = ttBandToExtract.menu_item_obj
                 NO-ERROR.

            /* If we haven't extracted the action yet, do so */
            IF NOT AVAILABLE ttAction
            THEN DO:
               /* Because we reuse this code, and we want to keep it inline, we use an include.  *
                * The include will check if the action has already been extracted, and create it *
                * if it hasn't. */
                {ry/app/rymenuitmc.i &MENU-ITEM-OBJ = ttBandToExtract.menu_item_obj
                                     &UNDO-PHRASE   = "LEAVE then-blk"}
            END.
            ASSIGN cMenuStructureItem = ttAction.Action
                   lBandHasActions    = YES.
        END.

        /* Now extract all the menu items for this menu structure */
        structure-item-blk:
        FOR EACH gsm_menu_structure_item NO-LOCK
           WHERE gsm_menu_structure_item.menu_structure_obj = ttBandToExtract.menu_structure_obj:

           /* If this band has child bands, create a ttBandToExtract record for each child       *
            * band to extract.  We populate the cChildMenuStructure so we can create a           *
            * ttBandAction record between the band currently being processed and the child band. */
           IF gsm_menu_structure_item.child_menu_structure_obj <> 0
           THEN DO:
               FIND bgsm_menu_structure NO-LOCK
                    WHERE bgsm_menu_structure.menu_structure_obj = gsm_menu_structure_item.child_menu_structure_obj
                    NO-ERROR.

               IF AVAILABLE bgsm_menu_structure 
               THEN DO:
                   ASSIGN cChildMenuStructure = bgsm_menu_structure.menu_structure_code.

                   /* We create these records to take care of recursive menu structures. */
                   CREATE bttBandToExtract.
                   BUFFER-COPY bgsm_menu_structure
                            TO bttBandToExtract
                        ASSIGN iSequence = iSequence + 1
                               bttBandToExtract.extract_sequence = iSequence
                               bttBandToExtract.parent_menu_structure_code = ttBandToExtract.menu_structure_code.
               END.
           END.
           ELSE
               ASSIGN cChildMenuStructure = "":U.

           /* Extract menu items for this band */
           IF gsm_menu_structure_item.menu_item_obj <> 0
           THEN DO:
               FIND ttAction
                    WHERE ttAction.menu_item_obj = gsm_menu_structure_item.menu_item_obj
                    NO-ERROR.

               /* If we haven't extracted the action yet, do so */
               IF NOT AVAILABLE ttAction
               THEN DO:
                   /* Because we reuse this code, and we want to keep it inline, we use an include.  *
                    * The include will check if the action has already been extracted, and create it *
                    * if it hasn't. */
                   {
                    ry/app/rymenuitmc.i &MENU-ITEM-OBJ = gsm_menu_structure_item.menu_item_obj
                                        &UNDO-PHRASE   = "NEXT structure-item-blk"
                   }
               END.

               /* Store the relationship between the band and action */
               CREATE ttBandAction.
               ASSIGN ttBandAction.band      = ttBandToExtract.menu_structure_code
                      ttBandAction.childband = cChildMenuStructure
                      ttBandAction.action    = ttAction.Action
                      ttBandAction.sequence  = gsm_menu_structure_item.menu_item_sequence
                      lBandHasActions        = YES.
           END.
        END.

        /* If we could find actions for this band, create the band. */
        IF lBandHasActions
        THEN DO:
            CREATE ttBand.
            ASSIGN ttBand.BandLabelAction = cMenuStructureItem /* Only if a menu_item_obj has been assigned on the structure directly */
                   ttBand.Band            = ttBandToExtract.menu_structure_code
                   ttBand.BandType        = ttBandToExtract.menu_structure_type
                   ttBand.ButtonSpacing   = ttBandToExtract.control_spacing
                   ttBand.ButtonPadding   = ttBandToExtract.control_padding.
        END.
        ELSE
            /* We aren't creating the band, but we might already have stored a relationship between it and *
             * a parent band.  Make sure we don't have any "limbo" relationships.                          */
            FOR EACH ttBandAction
               WHERE ttBandAction.childBand = ttBandToExtract.menu_structure_code:

                /* If an action was linked directly to the band, just clear the childBand link, *
                 * else delete the record. */
                IF ttBandAction.action = "":U THEN
                    DELETE ttBandAction.
                ELSE
                    ASSIGN ttBandAction.childBand = "":U.
            END.
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractBandsAndActions Include 
PROCEDURE extractBandsAndActions :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will extract toolbar bands or object specific bands
               for an object.  It will extract the information into the ADM2 
               bands and actions tables, which are then used by the ADM2 toolbar
               renderer.
  Parameters:  pcObjectName - The name of the object to extract bands for
               pdCustomizationResultObj - If we're extracting for objects of a specific result 
                                          code, the customisation_result_obj
               pcResultCode - If we're extracting for objects of a specific result code, the 
                              result code
               pcExtractingForProcType 
                      - "toolbar" to extact toolbar bands
                      - "container" to extract object specific bands
               pcRunAttribute - The run attribute of the object we're extracting for
               plDevelopmentUser - Is the user currently logged in a development user?
               plSecurityEnabled - Is security enabled for this session?
               pcSecurityModel - The security model we're running against, either "Grant" or "Revoke"
               plGSMMSSecurityExists - Does any menu structure security applicable to this user exist?
               plGSMMISecurityExists - Does any menu item security applicable to this user exist?
               plRYCSOSecurityExists - Does any object security applicable to this user exist?
               plTranslationEnabled - Is translation enabled for this session?
               pdLoginLanguageObj - The language the user logged in for.
               pdUserObj - The user_obj of the currently logged in user.
               pdOrganisationObj - The organisation the user logged in for.
  Notes:       Have a look at the main block of ry/app/rygetmensp.p to see how these parameters
               are populated.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pdCustomizationResultObj AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcExtractingForProcType  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute           AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER plDevelopmentUser        AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plSecurityEnabled        AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSecurityModel          AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER plGSMMSSecurityExists    AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plGSMMISecurityExists    AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plRYCSOSecurityExists    AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plTranslationEnabled     AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdLoginLanguageObj       AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj                AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdOrganisationObj        AS DECIMAL    NO-UNDO.

    /* NOTE, some of these buffer and variable definitions are used in {ry/app/rymenuitmc.i} */
    DEFINE BUFFER ttBandToExtract            FOR ttBandToExtract.
    DEFINE BUFFER bttBandToExtract           FOR ttBandToExtract.
    DEFINE BUFFER ryc_smartobject            FOR ryc_smartobject.
    DEFINE BUFFER bInstanceAttribute         FOR gsc_instance_attribute.
    DEFINE BUFFER gsm_object_menu_structure  FOR gsm_object_menu_structure.
    DEFINE BUFFER gsm_toolbar_menu_structure FOR gsm_toolbar_menu_structure.
    DEFINE BUFFER gsm_menu_structure         FOR gsm_menu_structure.
    DEFINE BUFFER bgsm_menu_structure        FOR gsm_menu_structure.
    DEFINE BUFFER gsm_menu_structure_item    FOR gsm_menu_structure_item.
    DEFINE BUFFER gsm_menu_item              FOR gsm_menu_item.
    DEFINE BUFFER gsc_item_category          FOR gsc_item_category.
    DEFINE BUFFER parent_item_category       FOR gsc_item_category.
    DEFINE BUFFER gsm_translated_menu_item   FOR gsm_translated_menu_item.

    DEFINE VARIABLE cLogicalObject      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAttribute          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRequiredDBList     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lPersistent         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iSequence           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lBandHasActions     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSecurityDummyValue AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSecured            AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cMenuStructureItem  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cChildMenuStructure AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dContainerObjectObj AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTransLanguageObj   AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cContainerName      AS CHARACTER  NO-UNDO.

    /* Find the object we're extracting bands for */
    FIND ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.object_filename          = pcObjectName
           AND ryc_smartobject.customization_result_obj = pdCustomizationResultObj
         NO-ERROR.
    
    IF NOT AVAILABLE ryc_smartobject THEN
        RETURN.

    EMPTY TEMP-TABLE ttBandToExtract.

    /* Find the bands linked to this object/toolbar. */
    CASE pcExtractingForProcType:
        WHEN "container":U THEN 
        DO:
            /* If we only want to extract bands for a certain run attribute, find the attribute_obj so we 
               can check and skip bands if they don't apply. Find it here so we only FIND once. */
            IF pcRunAttribute > "" THEN
                FIND bInstanceAttribute NO-LOCK
                     WHERE bInstanceAttribute.attribute_code = pcRunAttribute 
                     NO-ERROR.

            object-band-block:
            FOR EACH gsm_object_menu_structure NO-LOCK
               WHERE gsm_object_menu_structure.object_obj = ryc_smartobject.smartobject_obj,
               FIRST gsm_menu_structure NO-LOCK
               WHERE gsm_menu_structure.menu_structure_obj = gsm_object_menu_structure.menu_structure_obj:

                /* If this band has a runattribute, skip it unless we are 
                   extracting for this runattribute. */
                IF gsm_object_menu_structure.instance_attribute_obj <> 0 THEN
                DO:
                  /* no runattribute */
                  IF pcRunAttribute = "" 
                  /* invalid runattribute */
                  OR (NOT AVAILABLE bInstanceAttribute AND pcRunAttribute <> '') 
                  /* another runattribute */
                  OR (AVAILABLE bInstanceAttribute AND bInstanceAttribute.instance_attribute_obj <> gsm_object_menu_structure.instance_attribute_obj) THEN
                    NEXT object-band-block. /* ---- NEXT -----------------> */
                END.

                /* We need to extract the band */
                IF NOT CAN-FIND(FIRST ttBandToExtract
                                WHERE ttBandToExtract.menu_structure_obj = gsm_menu_structure.menu_structure_obj) THEN 
                DO:
                    CREATE ttBandToExtract.
                    BUFFER-COPY gsm_menu_structure
                             TO ttBandToExtract
                         ASSIGN iSequence = iSequence + 1
                                ttBandToExtract.extract_sequence = iSequence.
                END.

                /* Link the band to the object  
                   Runattribute is part of unique index so set it to unknown 
                   if requesting an invalid runattribute. This avoids clash 
                   with clients (adm2/toolbar.p) that appends this to existing 
                   objectbands, which already may include this with a blank 
                   runattribute. (NOTE: The client need to deal with this) */
                CREATE ttObjectBand.
                ASSIGN ttObjectBand.ObjectName    = ryc_smartobject.object_filename
                       ttObjectBand.RunAttribute  = (IF AVAIL bInstanceAttribute 
                                                     THEN bInstanceAttribute.attribute_code
                                                     ELSE IF pcrunattribute <> '' THEN ?
                                                     ELSE '')
                       ttObjectBand.Band          = gsm_menu_structure.menu_structure_code
                       ttObjectBand.Sequence      = gsm_object_menu_structure.menu_structure_sequence
                       ttObjectBand.InsertSubmenu = gsm_object_menu_structure.insert_submenu.
                       ttObjectBand.ResultCode    = pcResultCode.
            END.
        END.

        WHEN "toolbar":U THEN
            toolbar-band-block:
            FOR EACH gsm_toolbar_menu_structure NO-LOCK
               WHERE gsm_toolbar_menu_structure.object_obj = ryc_smartobject.smartobject_obj,
               FIRST gsm_menu_structure NO-LOCK
               WHERE gsm_menu_structure.menu_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj:

                IF NOT CAN-FIND(FIRST ttToolbarBand
                                WHERE ttToolbarBand.Band        = gsm_menu_structure.menu_structure_code
                                  AND ttToolbarBand.toolbarName = ryc_smartobject.object_filename) THEN 
                DO:
                    /* We need to extract the band */
                    IF NOT CAN-FIND(FIRST ttBandToExtract
                                    WHERE ttBandToExtract.menu_structure_obj = gsm_menu_structure.menu_structure_obj) THEN 
                    DO:
                        CREATE ttBandToExtract.
                        BUFFER-COPY gsm_menu_structure
                                 TO ttBandToExtract
                             ASSIGN iSequence = iSequence + 1
                                    ttBandToExtract.extract_sequence = iSequence.
                    END.
    
                    /* Link the band to the toolbar */
                    CREATE ttToolbarBand.
                    ASSIGN ttToolbarBand.ToolbarName = ryc_smartobject.object_filename
                           ttToolbarBand.Sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
                           ttToolbarBand.Band        = gsm_menu_structure.menu_structure_code
                           ttToolbarBand.Alignment   = gsm_toolbar_menu_structure.menu_structure_alignment
                           ttToolbarBand.InsertRule  = gsm_toolbar_menu_structure.insert_rule
                           ttToolbarBand.RowPosition = gsm_toolbar_menu_structure.menu_structure_row
                           ttToolbarBand.Spacing     = gsm_toolbar_menu_structure.menu_structure_spacing
                           ttToolbarBand.ResultCode  = pcResultCode.
                END.
            END.
    END CASE.

    band-extract-blk:
    FOR EACH ttBandToExtract
          BY ttBandToExtract.extract_sequence:

        FIND ttBand
             WHERE ttBand.band = ttBandToExtract.menu_structure_code
             NO-ERROR.

        /* If the band has not been extracted yet, do so. If it has, we don't have to do anything.   *
         * The relationship between the parent of this band and itself will already have been stored *
         * when the parent was extracted.                                                            */
        IF NOT AVAILABLE ttBand THEN 
        DO:
            /* Conditions to skip the creation of this band */
            IF ttBandToExtract.DISABLED
            OR (ttBandToExtract.under_development AND NOT plDevelopmentUser) THEN
                NEXT band-extract-blk.
        
            /* Check menu structure security */
            IF plGSMMSSecurityExists THEN 
            DO:
                RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                                             INPUT pdOrganisationObj,
                                                             INPUT "GSMMS":U,
                                                             INPUT ttBandToExtract.menu_structure_obj,
                                                             INPUT NO,
                                                             OUTPUT lSecured,
                                                             OUTPUT cSecurityDummyValue,
                                                             OUTPUT cSecurityDummyValue).
                IF lSecured THEN
                    NEXT band-extract-blk.
            END.
            ELSE
                /* If no structure security exists, the administrator hasn't allocated any to this user. *
                 * In a grant model, this means the structure is secured.  In a revoke model, it isn't.  */
                IF plSecurityEnabled
                AND pcSecurityModel = "Grant":U THEN
                    NEXT band-extract-blk.

            /* We use lBandHasActions to check if we should create the band record later (only if the band has actions). *
             * cMenuStructureItem is used to check if an action has been linked directly to a band.                      */
            ASSIGN lBandHasActions    = NO
                   cMenuStructureItem = "":U.
    
            /* Do we have an action assigned directly to the structure? *
             * If so, extract it and link it. */
            IF ttBandToExtract.menu_item_obj <> 0 THEN 
            action-block: 
            DO:
                FIND ttAction
                     WHERE ttAction.menu_item_obj = ttBandToExtract.menu_item_obj
                     NO-ERROR.
    
                /* If we haven't extracted the action yet, do so */
                IF NOT AVAILABLE ttAction THEN 
                DO:
                   /* Because we reuse this code, and we want to keep it inline, we use an include.  *
                    * The include will check if the action has already been extracted, and create it *
                    * if it hasn't. */
                    {
                     ry/app/rymenuitmc.i &MENU-ITEM-OBJ = ttBandToExtract.menu_item_obj
                                         &UNDO-PHRASE   = "LEAVE action-block"
                    }
                END.
                ASSIGN cMenuStructureItem = ttAction.Action
                       lBandHasActions    = YES.
            END.

            /* Now extract all the menu items for this menu structure */
            structure-item-blk:
            FOR EACH gsm_menu_structure_item NO-LOCK
               WHERE gsm_menu_structure_item.menu_structure_obj = ttBandToExtract.menu_structure_obj:

               /* If this band has child bands, create a ttBandToExtract record for each child       *
                * band to extract.  We populate the cChildMenuStructure so we can create a           *
                * ttBandAction record between the band currently being processed and the child band. */
               IF gsm_menu_structure_item.child_menu_structure_obj <> 0 THEN 
               DO:
                   FIND bgsm_menu_structure NO-LOCK
                        WHERE bgsm_menu_structure.menu_structure_obj = gsm_menu_structure_item.child_menu_structure_obj
                        NO-ERROR.

                   IF AVAILABLE bgsm_menu_structure THEN 
                   DO:
                       ASSIGN cChildMenuStructure = bgsm_menu_structure.menu_structure_code.

                       IF NOT CAN-FIND(FIRST ttBandToExtract
                                       WHERE ttBandToExtract.menu_structure_obj = gsm_menu_structure_item.child_menu_structure_obj) THEN 
                       DO:    
                           /* We create these records to take care of recursive menu structures. */
                           CREATE bttBandToExtract.
                           BUFFER-COPY bgsm_menu_structure
                                    TO bttBandToExtract
                                ASSIGN iSequence = iSequence + 1
                                       bttBandToExtract.extract_sequence = iSequence
                                       bttBandToExtract.parent_menu_structure_code = ttBandToExtract.menu_structure_code.
                       END.
                   END.
               END.
               ELSE
                   ASSIGN cChildMenuStructure = "":U.

               /* Extract menu items for this band */
               IF gsm_menu_structure_item.menu_item_obj <> 0 THEN 
               DO:
                   FIND ttAction
                        WHERE ttAction.menu_item_obj = gsm_menu_structure_item.menu_item_obj
                        NO-ERROR.

                   /* If we haven't extracted the action yet, do so */
                   IF NOT AVAILABLE ttAction THEN 
                   DO:
                       /* Because we reuse this code, and we want to keep it inline, we use an include.  *
                        * The include will check if the action has already been extracted, and create it *
                        * if it hasn't. */
                       {
                        ry/app/rymenuitmc.i &MENU-ITEM-OBJ = gsm_menu_structure_item.menu_item_obj
                                            &UNDO-PHRASE   = "NEXT structure-item-blk"
                       }
                   END.

                   /* Store the relationship between the band and action */
                   CREATE ttBandAction.
                   ASSIGN ttBandAction.band      = ttBandToExtract.menu_structure_code
                          ttBandAction.childband = cChildMenuStructure
                          ttBandAction.action    = ttAction.Action
                          ttBandAction.sequence  = gsm_menu_structure_item.menu_item_sequence
                          lBandHasActions        = YES.
               END.
            END.

            /* If we could find actions for this band, create the band. */
            IF lBandHasActions THEN 
            DO:
                CREATE ttBand.
                ASSIGN ttBand.BandLabelAction = cMenuStructureItem /* Only if a menu_item_obj has been assigned on the structure directly */
                       ttBand.Band            = ttBandToExtract.menu_structure_code
                       ttBand.BandType        = ttBandToExtract.menu_structure_type
                       ttBand.ButtonSpacing   = ttBandToExtract.control_spacing
                       ttBand.ButtonPadding   = ttBandToExtract.control_padding.
            END.
            ELSE
                /* We aren't creating the band, but we might already have stored a relationship between it and *
                 * a parent band.  Make sure we don't have any "limbo" relationships. */
                FOR EACH ttBandAction
                   WHERE ttBandAction.childBand = ttBandToExtract.menu_structure_code:

                    /* If an action was linked directly to the band, just clear the childBand link, *
                     * else delete the record. */
                    IF ttBandAction.action = "":U THEN
                        DELETE ttBandAction.
                    ELSE
                        ASSIGN ttBandAction.childBand = "":U.
                END.
        END.
    END.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildAction Include 
FUNCTION buildAction RETURNS CHARACTER
  ( pdObj     AS DEC,
    pdUserObj AS DEC,
    pdOrganisationObj AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/    
   DEFINE BUFFER bMenuItem              FOR gsm_menu_item.
   DEFINE BUFFER bLogObject             FOR ryc_smartobject.
   DEFINE BUFFER bPhyObject             FOR ryc_smartobject.
   DEFINE BUFFER gsc_instance_attribute FOR gsc_instance_attribute.

   DEFINE VARIABLE lDisabled       AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cSecurityValue1 AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSecurityValue2 AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cRequiredDbList AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lPersistent     AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cLogicalObject  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAttribute      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE dObjectObj      AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dSmartObjectObj AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dClassObj       AS DECIMAL    NO-UNDO.

   /* get user so we know if they are a developer or not. If they are not a developer,
     then menu items under development will not be included in the cache for building*/

   FIND bMenuItem NO-LOCK
        WHERE bMenuItem.menu_item_obj = pdobj NO-ERROR.

   IF AVAIL bMenuItem THEN
   DO:
     FIND FIRST ttAction 
          WHERE ttAction.Action = bMenuItem.menu_item_reference NO-ERROR.

     IF NOT AVAIL ttAction THEN
     DO:
         /* Default security cleared to whether disabled or not */
         ASSIGN lDisabled = bMenuItem.DISABLED.

       /* if disabled and hide if disabled set and not a submenu, then
        * just ignore menu option. */
       IF bMenuItem.item_control_type = 'ACTION':U THEN 
       DO:
           IF NOT lDisabled THEN
              ASSIGN lDisabled = (bMenuItem.under_development 
                                  AND CAN-FIND(FIRST gsm_user 
                                               WHERE gsm_user.user_obj = pdUserObj 
                                                 AND gsm_user.development_user = NO)).

           IF lDisabled AND bMenuItem.hide_if_disabled THEN RETURN '':U. 
       END. /* ACTION item control type */
 
       /* Check if the item has been secured */
       IF lDisabled = NO THEN
       DO:         
         RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                                      INPUT pdOrganisationObj,
                                                      INPUT "gsmmi":U,
                                                      INPUT bMenuItem.menu_item_obj,
                                                      INPUT NO,
                                                      OUTPUT lDisabled,
                                                      OUTPUT cSecurityValue1,
                                                      OUTPUT cSecurityValue2).

         /* If the menu item is not secured, check if the container launched by the item is secured */
         IF  lDisabled = NO
         AND bMenuItem.object_obj <> 0
         AND bMenuItem.object_obj <> ? 
         THEN DO:
             ASSIGN cObjectName = "":U                  /* We don't know what the object name is */
                    dObjectObj  = bMenuItem.object_obj. /* Because this parameter is INPUT-OUTPUT in the call below, rather use a variable */
             RUN objectSecurityCheck IN gshSecurityManager (INPUT-OUTPUT cObjectName,
                                                            INPUT-OUTPUT dObjectObj,
                                                            OUTPUT lDisabled).
         END.

         /* if not passed security and hide if didabled set and not a submenu, then
           just ignore menu option. */
         IF lDisabled AND bMenuItem.hide_if_disabled THEN RETURN '':U. 
       END.

       IF bMenuItem.item_select_type = 'Launch':U 
       THEN DO:                                                /* find physical / logical object names */
          ASSIGN 
            cRequiredDbList = "":U
            lPersistent = YES
            cLogicalObject = "":U.

          FIND FIRST blogObject NO-LOCK
               WHERE blogObject.smartobject_obj = bMenuItem.object_obj
               NO-ERROR.
          
          IF AVAILABLE blogObject THEN 
          DO:
                ASSIGN cLogicalObject  = blogObject.object_filename
                   cRequiredDbList = blogObject.required_db_list.
            
            /* if menu item has an instance attribute - read it and save it */      
            IF bMenuItem.instance_attribute_obj > 0 THEN 
            DO:
              FIND FIRST gsc_instance_attribute NO-LOCK
                 WHERE gsc_instance_attribute.instance_attribute_obj = bMenuItem.instance_attribute_obj
                 NO-ERROR.
              IF AVAILABLE gsc_instance_attribute 
              THEN DO:
                  ASSIGN cAttribute = gsc_instance_attribute.attribute_code.
                  RELEASE gsc_instance_attribute.
              END.
            END.
            
            ASSIGN lDisabled   = IF lDisabled
                                 THEN lDisabled
                                 ELSE blogObject.Disabled
                   lPersistent = blogObject.run_persistent.
          END. /* avail bLogObject*/
          ELSE
              lDisabled = YES.
          
          IF lDisabled AND bMenuItem.hide_if_disabled THEN RETURN '':U.
       END. /* launch */
       ELSE
          ASSIGN cLogicalObject = "":U.

       createAction(bMenuItem.menu_item_obj).
       ASSIGN
          ttAction.RunAttribute       = cAttribute
          ttAction.Disabled           = lDisabled
          ttAction.PhysicalObjectName = "":U    /* this will be resolved by the rendering procedure */
          ttAction.LogicalObjectName  = cLogicalObject
          ttAction.RunPersistent      = lPersistent
          ttAction.DbRequiredList     = RIGHT-TRIM(cRequiredDBList,',':U).
    END. /* not avail ttAction */
    RETURN ttaction.Action.   /* Function return value. */
  END. /* avail bMenuItem */ 
  
  RETURN "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildBand Include 
FUNCTION buildBand RETURNS LOGICAL
  ( pcBand    AS CHARACTER,
    plTopOnly AS LOG,
    pdUserObj AS DEC,
    pdOrganisationObj AS DEC):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bMenuStruct      FOR gsm_menu_structure.
  DEFINE BUFFER bChildMenu       FOR gsm_menu_structure.
  DEFINE BUFFER bMenuStructItem  FOR gsm_menu_structure_item.
  DEFINE BUFFER bMenuItem        FOR gsm_menu_item.

  DEFINE VARIABLE cSecurityValue1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecurityValue2 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBuildSuccess   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRestricted     AS LOGICAL    NO-UNDO.

  /* already loaded */
  IF CAN-FIND(FIRST ttBand WHERE ttBand.Band = pcBand) THEN 
     RETURN TRUE.
  
  FIND bMenuStruct WHERE bMenuStruct.menu_structure_code = pcBand NO-LOCK 
       NO-ERROR.
  
  IF NOT AVAIL bMenuStruct THEN 
     RETURN FALSE.
  
  /* get user so we know if they are a developer or not. If they are not a developer, *
   * then menu items under development will not be included in the cache for building */

  IF bMenuStruct.under_development THEN
      IF CAN-FIND(FIRST gsm_user
                  WHERE gsm_user.user_obj         = pdUserObj
                    AND gsm_user.development_user = NO) THEN
        RETURN FALSE.
    
  /* check if user has security clearance for menu structure */

  RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                               INPUT pdOrganisationObj,
                                               INPUT "gsmms":U,
                                               INPUT bMenuStruct.menu_structure_obj,
                                               INPUT  NO,
                                               OUTPUT lRestricted,
                                               OUTPUT cSecurityValue1,
                                               OUTPUT cSecurityValue2).

  IF lRestricted THEN RETURN FALSE.

  CREATE ttBand.
  ASSIGN 
    ttBand.BandLabelAction = (IF bMenuStruct.menu_item_obj <> 0 
                              THEN createAction(bMenuStruct.menu_item_obj) 
                              ELSE '')
    ttBand.Band            = bMenuStruct.menu_structure_code
    ttBand.BandType        = bMenuStruct.menu_structure_type
    ttBand.ButtonSpacing   = bMenuStruct.control_spacing
    ttBand.ButtonPadding   = bMenuStruct.control_padding.

  FOR EACH bMenuStructItem NO-LOCK
     WHERE bMenuStructItem.menu_structure_obj = bMenuStruct.menu_structure_obj
        BY bMenuStructItem.menu_item_sequence:
    FIND bMenuItem NO-LOCK
       WHERE bMenuItem.menu_item_obj = bMenuStructItem.menu_item_obj NO-ERROR.

    IF AVAIL bMenuItem THEN
    DO:
      IF buildAction(bMenuItem.menu_item_Obj,
                     pdUserObj,
                     pdOrganisationObj)  = '':U THEN
         NEXT.
    END.

    IF bMenuStructItem.child_menu_structure_obj <> 0 THEN
    DO:
      FIND bChildMenu NO-LOCK
           WHERE bChildMenu.menu_structure_obj = bMenuStructItem.child_menu_structure_obj NO-ERROR.
      
      IF AVAIL bChildMenu THEN 
         lBuildSuccess = buildBand(bChildMenu.menu_structure_code,
                                   plTopOnly,
                                   pdUserObj,
                                   pdOrganisationObj).
      ELSE RELEASE bChildMenu.
    END.
    
    /* If a child menu is available and the build of the band failed (which 
       would happen if there are security restrictions on the band for the user)
       then a band action should not be created.  If there is no child menu
       available then a band action should always be created because 
       this code has built the band and security restrictions were checked
       up above and there were none. */
    IF (AVAIL bChildMenu AND lBuildSuccess) OR (NOT AVAIL bChildMenu) THEN DO:
      CREATE ttBandAction.
      ASSIGN 
        ttBandAction.Band      = bMenuStruct.menu_structure_code
        ttBandAction.Action    = (IF AVAIL bMenuItem 
                                  THEN bMenuItem.menu_item_reference
                                  ELSE '':U)
        ttBandAction.ChildBand = (IF AVAIL bChildMenu 
                                  THEN bChildMenu.menu_structure_code
                                  ELSE '':U)
        ttBandAction.Sequence  =  bMenuStructItem.menu_item_sequence.
    END.  /* if child menu and build worked or no child menu */

  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindTranslation Include 
FUNCTION canFindTranslation RETURNS DECIMAL
  ( pdMenuItemObj       AS DECIMAL,
    pdLoginLanguageObj  AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will attempt to a find a translated menu item record
            in the following order of the user's language:
            1. The User's Login Language
            2. The User's Default Language set up in user control
            3. The system default language
            4. The user's Source language
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dCurrentUserObj     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dUserSourceLanguage AS DECIMAL    NO-UNDO.
    
  DEFINE BUFFER gsm_user           FOR gsm_user.
  DEFINE BUFFER gsc_global_control FOR gsc_global_control.

  /* If we can't find any translations for this menu item, don't even bother further */

  IF NOT CAN-FIND(FIRST gsm_translated_menu_item
                  WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj) THEN
      RETURN DECIMAL(0).

  /* 1 */
  IF pdLoginLanguageObj <> 0 AND
     CAN-FIND(FIRST gsm_translated_menu_item
              WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj
                AND gsm_translated_menu_item.language_obj  = pdLoginLanguageObj) THEN
    RETURN pdLoginLanguageObj.

  /* 2 */
  dCurrentUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                              INPUT "CurrentUserObj":U,
                                              INPUT NO)) NO-ERROR.
  FIND FIRST gsm_user
       WHERE gsm_user.user_obj = dCurrentUserObj
       NO-LOCK NO-ERROR.

  IF AVAILABLE gsm_user
  AND gsm_user.language_obj <> 0
  AND CAN-FIND(FIRST gsm_translated_menu_item
               WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj
                 AND gsm_translated_menu_item.language_obj  = gsm_user.language_obj) THEN
      RETURN gsm_user.language_obj.

  /* 3 */
  FIND FIRST gsc_global_control NO-LOCK NO-ERROR.

  IF AVAILABLE gsc_global_control
  AND gsc_global_control.default_language_obj <> 0
  AND CAN-FIND(FIRST gsm_translated_menu_item
               WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj
                 AND gsm_translated_menu_item.language_obj  = gsc_global_control.default_language_obj) THEN
      RETURN gsc_global_control.default_language_obj.

  /* 4 */
  RUN getUserSourceLanguage IN gshGenManager (INPUT dCurrentUserObj, OUTPUT dUserSourceLanguage).

  IF dUserSourceLanguage <> 0 AND 
     CAN-FIND(FIRST gsm_translated_menu_item
              WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj
                AND gsm_translated_menu_item.language_obj  = dUserSourceLanguage) THEN
    RETURN dUserSourceLanguage.

  RETURN DECIMAL(0).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createAction Include 
FUNCTION createAction RETURNS CHARACTER
  (pdObj AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Create a ttAction record from a gsm_menu_item record 
    Notes: This has been separated in order to add random ttActions
        -  a ttCategory record is also added if needed.
        -  Launch data is NOT added as this is also used to decide 
           availability and is handled in buildAction.                            
------------------------------------------------------------------------------*/
 DEFINE BUFFER bMenuItem        FOR gsm_menu_item.
 DEFINE BUFFER bCategory        FOR gsc_item_category.
 DEFINE BUFFER bParentCategory  FOR gsc_item_category.

 DEFINE BUFFER gsm_translated_menu_item FOR gsm_translated_menu_item.

 DEFINE VARIABLE dTransLanguageObj AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dLoginLanguageObj AS DECIMAL    NO-UNDO.
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

 FIND bMenuItem NO-LOCK
   WHERE bMenuItem.menu_item_obj = pdObj NO-ERROR.
 
IF NOT AVAIL bMenuItem THEN
   RETURN '':U.
 
FIND ttAction WHERE ttAction.Action = bMenuItem.menu_item_reference NO-ERROR.
IF NOT AVAIL ttAction THEN
DO:
  CREATE ttAction.
  ASSIGN ttAction.Action            = bMenuItem.menu_item_reference
        ttAction.Name               = bMenuItem.item_toolbar_label
        ttAction.Caption            = bMenuItem.menu_item_label
        ttAction.Tooltip            = bMenuItem.tooltip_text
        ttAction.SubstituteProperty = bMenuItem.substitute_text_property
        ttAction.Image              = bMenuItem.image1_up_filename
        ttAction.ImageDown          = bMenuItem.image1_down_filename
        ttAction.ImageInsensitive   = bMenuItem.image1_insensitive_filename 
        ttAction.Image2             = bMenuItem.image2_up_filename
        ttAction.Image2Down         = bMenuItem.image2_down_filename
        ttAction.Image2Insensitive  = bMenuItem.image2_insensitive_filename 
        ttAction.Accelerator        = bMenuItem.shortcut_key
        ttAction.Description        = bMenuItem.menu_item_description
        ttAction.SecurityToken      = bMenuItem.security_token
        ttAction.EnableRule         = bMenuItem.enable_rule      
        ttAction.DisableRule        = bMenuItem.disable_rule      
        ttAction.HideRule           = bMenuItem.hide_rule     
        ttAction.ImageAlternateRule = bMenuItem.image_alternate_rule
        ttAction.Link               = bMenuItem.item_link 
        ttAction.RunParameter       = bMenuItem.item_select_parameter
        ttAction.Type               = bMenuItem.item_select_type
        ttAction.ControlType        = bMenuItem.item_control_type
        ttAction.InitCode           = bMenuItem.item_menu_drop  
        ttAction.createEvent        = bMenuItem.on_create_publish_event 
        ttAction.OnChoose           = bMenuItem.item_select_action      
        ttAction.SystemOwned        = bMenuItem.system_owned
        .        
  
  /* Get the current login language */
  dLoginLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "CurrentLanguageObj":U,
                                                INPUT NO)) NO-ERROR.
  dTransLanguageObj = canFindTranslation(bMenuItem.menu_item_obj,dLoginLanguageObj).
  IF dTransLanguageObj <> 0 AND
     dTransLanguageObj <> ? THEN DO:
    /* Initialize return parameters. The unknown value means that
       there are no translations present.
     */
    assign cLabel = ?
           cCaption = ?
           cTooltip = ?
           cAccelerator = ?
           cImage = ?
           cImageDown = ?
           cImageInsensitive = ?
           cImage2 = ?
           cImage2Down = ?
           cImage2Insensitive = ?.    
    
    run translateAction in gshTranslationManager ( input  'OBJ|' + string(dTransLanguageObj),
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
    
    /* Ignore any errors and revert back to using the design language values. */
    
    /* The unknown value signifies that there is no translation for the field. */
    if cItem ne ? then ttAction.Name = cItem.
    if cCaption ne ? then ttAction.Caption = cCaption.
    if cTooltip ne ? then ttAction.Tooltip = cTooltip.
    if cAccelerator ne ? then ttAction.Accelerator = cAccelerator.
    if cImage ne ? then ttAction.Image = cImage.
    if cImageDown ne ? then ttAction.ImageDown = cImageDown.
    if cImageInsensitive ne ? then ttAction.ImageInsensitive = cImageInsensitive.
    if cImage2 ne ? then ttAction.Image2 = cImage2.
    if cImage2Down ne ? then ttAction.Image2Down = cImage2Down.
    if cImage2Insensitive ne ? then ttAction.Image2Insensitive = cImage2Insensitive.
  END.
  
  IF bMenuItem.item_category_obj <> 0 THEN
  DO:
    FIND bCategory NO-LOCK
        WHERE bCategory.item_category_obj = bMenuItem.item_category_obj NO-ERROR.
    IF AVAIL bCategory THEN 
    DO:
      IF NOT CAN-FIND(FIRST ttCategory 
                     WHERE ttCategory.Category = bCategory.item_category_label) THEN
      DO:
        CREATE ttCategory.
        ASSIGN ttCategory.Category    = bCategory.item_category_label
               ttCategory.Link        = bCategory.item_link
               ttCategory.systemowned = bCategory.system_owned.
        IF bCategory.parent_item_category_obj <> 0 THEN
        DO:
          FIND bParentCategory NO-LOCK 
               WHERE bParentCategory.item_category_obj = bCategory.parent_item_category_obj NO-ERROR.
          IF AVAIL bParentCategory THEN
             ttCategory.ParentCategory    = bParentCategory.item_category_label.
        END.
      END.
      ASSIGN   /* Ensure we always have link at the action */ 
        ttAction.Category = bCategory.item_category_label
        ttAction.Link     = IF ttAction.Link = '':U 
                            THEN bCategory.item_link
                            ELSE ttAction.Link.
    END.
  END.
END. /* not avail*/
RETURN ttAction.Action.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

