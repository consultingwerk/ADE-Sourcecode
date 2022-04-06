&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: rymenuitmc.i

  Description:  Include file used by rygetitemp.p and rygetmensp.p to create action
                records from the gsm_menu_item table.  Include created to keep code
                inline.

  Purpose:      Include file used by rygetitemp.p and rygetmensp.p to create action
                records from the gsm_menu_item table.  Include created to keep code 
                inline.

  Parameters:   NA

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/09/2003  Author:     Neil Bell

  Update Notes: Created file.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

&IF DEFINED(MENU-ITEM-OBJ) = 0 &THEN
&MESSAGE rymenuitmc.i - The MENU-ITEM-OBJ include argument needs to be specified.
&ENDIF

&IF DEFINED(UNDO-PHRASE) = 0 &THEN
&MESSAGE rymenuitmc.i - The UNDO-PHRASE include argument needs to be specified.
&ENDIF

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
         HEIGHT             = 8
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
FIND gsm_menu_item NO-LOCK
     WHERE gsm_menu_item.menu_item_obj = {&MENU-ITEM-OBJ}
     NO-ERROR.

/* Conditions to skip creation of this action for */
IF NOT AVAILABLE gsm_menu_item
OR (gsm_menu_item.DISABLED
    AND gsm_menu_item.hide_if_disabled) 
OR (gsm_menu_item.item_control_type = 'action':U 
    AND gsm_menu_item.under_development
    AND NOT plDevelopmentUser) THEN
  {&UNDO-PHRASE}.

/* Check action security */
ASSIGN lSecured = NO
       cContainerName = "":U.

IF plGSMMISecurityExists THEN 
DO:
    RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                                 INPUT pdOrganisationObj,
                                                 INPUT "GSMMI":U,
                                                 INPUT gsm_menu_item.menu_item_obj,
                                                 INPUT NO,
                                                 OUTPUT lSecured,
                                                 OUTPUT cSecurityDummyValue,
                                                 OUTPUT cSecurityDummyValue).
    IF lSecured
    AND gsm_menu_item.hide_if_disabled THEN
        {&UNDO-PHRASE}.
END.
ELSE
    /* If no action security exists, the administrator hasn't allocated any to this user. *
     * In a grant model, this means the item is secured.  In a revoke model, it isn't. */
    IF pcSecurityModel = "Grant":U
    AND plSecurityEnabled THEN
        IF gsm_menu_item.hide_if_disabled THEN
            {&UNDO-PHRASE}.
        ELSE
            ASSIGN lSecured = YES.

/* If the action is not secured, and it's of type "Launch", retrieve container info. */
IF NOT lSecured
AND gsm_menu_item.item_select_type = 'Launch':U THEN 
rycso-fetch-blk: 
DO:

    /* Is the container we're going to launch secured? */
    IF plRYCSOSecurityExists THEN 
    DO:
        ASSIGN dContainerObjectObj = gsm_menu_item.object_obj.
        RUN objectSecurityCheck IN gshSecurityManager (INPUT-OUTPUT cContainerName, /* Will always be blank, we don't know what it is */
                                                       INPUT-OUTPUT dContainerObjectObj,
                                                       OUTPUT lSecured).

        IF lSecured
        AND gsm_menu_item.hide_if_disabled THEN
            {&UNDO-PHRASE}.
    END.
    ELSE
        /* If no container security exists, the administrator hasn't allocated any to this user. *
         * In a grant model, this means the container is secured.  In a revoke model, it isn't.  */
        IF pcSecurityModel = "Grant":U
        AND plSecurityEnabled THEN 
        DO:
            IF gsm_menu_item.hide_if_disabled THEN
                {&UNDO-PHRASE}.
            ELSE
                ASSIGN lSecured = YES.
        END.

    IF lSecured THEN 
    DO:
        ASSIGN lPersistent     = NO
               cLogicalObject  = "":U
               cRequiredDBList = "":U
               cAttribute      = "":U.
        LEAVE rycso-fetch-blk.
    END.

    /* Now find the detail of the container we want to launch */
    FIND ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.smartobject_obj = gsm_menu_item.object_obj
         NO-ERROR.

    IF NOT AVAILABLE ryc_smartobject THEN
        {&UNDO-PHRASE}.

    ASSIGN lPersistent     = ryc_smartobject.run_persistent
           cLogicalObject  = ryc_smartobject.object_filename
           cRequiredDbList = ryc_smartobject.required_db_list
           cAttribute      = "":U.

    /* If the action has an instance attribute - read it and save it */      
    IF gsm_menu_item.instance_attribute_obj > 0 THEN 
    DO:
        FIND gsc_instance_attribute NO-LOCK
             WHERE gsc_instance_attribute.instance_attribute_obj = gsm_menu_item.instance_attribute_obj
             NO-ERROR.

        IF AVAILABLE gsc_instance_attribute THEN
            ASSIGN cAttribute = gsc_instance_attribute.attribute_code.
    END.
END.
ELSE
    ASSIGN lPersistent     = NO
           cLogicalObject  = "":U
           cRequiredDBList = "":U
           cAttribute      = "":U.

/* Create the action and assign values */
CREATE ttAction.           
ASSIGN ttAction.menu_item_obj      = gsm_menu_item.menu_item_obj
       ttAction.Action             = gsm_menu_item.menu_item_reference
       ttAction.Name               = gsm_menu_item.item_toolbar_label
       ttAction.Caption            = gsm_menu_item.menu_item_label
       ttAction.Tooltip            = gsm_menu_item.tooltip_text
       ttAction.SubstituteProperty = gsm_menu_item.substitute_text_property
       ttAction.Image              = gsm_menu_item.image1_up_filename
       ttAction.ImageDown          = gsm_menu_item.image1_down_filename
       ttAction.ImageInsensitive   = gsm_menu_item.image1_insensitive_filename 
       ttAction.Image2             = gsm_menu_item.image2_up_filename
       ttAction.Image2Down         = gsm_menu_item.image2_down_filename
       ttAction.Image2Insensitive  = gsm_menu_item.image2_insensitive_filename 
       ttAction.Accelerator        = gsm_menu_item.shortcut_key
       ttAction.Description        = gsm_menu_item.menu_item_description
       ttAction.SecurityToken      = gsm_menu_item.security_token
       ttAction.EnableRule         = gsm_menu_item.enable_rule      
       ttAction.DisableRule        = gsm_menu_item.disable_rule      
       ttAction.HideRule           = gsm_menu_item.hide_rule     
       ttAction.ImageAlternateRule = gsm_menu_item.image_alternate_rule
       ttAction.Link               = gsm_menu_item.item_link 
       ttAction.RunParameter       = gsm_menu_item.item_select_parameter
       ttAction.Type               = gsm_menu_item.item_select_type
       ttAction.ControlType        = gsm_menu_item.item_control_type
       ttAction.InitCode           = gsm_menu_item.item_menu_drop  
       ttAction.createEvent        = gsm_menu_item.on_create_publish_event 
       ttAction.OnChoose           = gsm_menu_item.item_select_action      
       ttAction.SystemOwned        = gsm_menu_item.system_owned
       ttAction.PhysicalObjectName = "":U /* The render will resolve */
       ttAction.LogicalObjectName  = cLogicalObject
       ttAction.RunAttribute       = cAttribute
       ttAction.RunPersistent      = lPersistent
       ttAction.DbRequiredList     = cRequiredDBList
       ttAction.DISABLED           = IF lSecured THEN YES 
                                     ELSE gsm_menu_item.disabled.

/* Translate the action if necessary. */
IF  plTranslationEnabled 
THEN DO:
    /* Determine which language we're going to translate to. */
    ASSIGN dTransLanguageObj = canFindTranslation(gsm_menu_item.menu_item_obj,pdLoginLanguageObj).

    IF  dTransLanguageObj <> 0
    AND dTransLanguageObj <> ?
    THEN DO:
        FIND gsm_translated_menu_item NO-LOCK
             WHERE gsm_translated_menu_item.menu_item_obj = gsm_menu_item.menu_item_obj
               AND gsm_translated_menu_item.language_obj  = dTransLanguageObj
             NO-ERROR.

        IF AVAILABLE gsm_translated_menu_item 
        THEN DO:
            /* If an image has been specified for the menu item, but not a picclip, we clear   *
             * the picclip image from the menu item to ensure the translation image gets used. *
             * Picclip images always get preference, meaning the untranslated image would get  *
             * used if we didn't clear it.                                                     */
            IF  gsm_translated_menu_item.image1_up_filename <> "":U
            AND gsm_translated_menu_item.image1_down_filename = "":U THEN
                ASSIGN ttAction.ImageDown = "":U.
    
            IF  gsm_translated_menu_item.image2_up_filename <> "":U
            AND gsm_translated_menu_item.image2_down_filename = "":U THEN
                ASSIGN ttAction.Image2Down = "":U.
    
            ASSIGN ttAction.Name              = IF gsm_translated_menu_item.item_toolbar_label          <> "":U THEN gsm_translated_menu_item.item_toolbar_label          ELSE ttAction.Name 
                   ttAction.Caption           = IF gsm_translated_menu_item.menu_item_label             <> "":U THEN gsm_translated_menu_item.menu_item_label             ELSE ttAction.Caption 
                   ttAction.Tooltip           = IF gsm_translated_menu_item.tooltip_text                <> "":U THEN gsm_translated_menu_item.tooltip_text                ELSE ttAction.Tooltip 
                   ttAction.Accelerator       = IF gsm_translated_menu_item.alternate_shortcut_key      <> "":U THEN gsm_translated_menu_item.alternate_shortcut_key      ELSE ttAction.Accelerator
                   ttAction.Image             = IF gsm_translated_menu_item.image1_up_filename          <> "":U THEN gsm_translated_menu_item.image1_up_filename          ELSE ttAction.Image
                   ttAction.ImageDown         = IF gsm_translated_menu_item.image1_down_filename        <> "":U THEN gsm_translated_menu_item.image1_down_filename        ELSE ttAction.ImageDown
                   ttAction.ImageInsensitive  = IF gsm_translated_menu_item.image1_insensitive_filename <> "":U THEN gsm_translated_menu_item.image1_insensitive_filename ELSE ttAction.ImageInsensitive
                   ttAction.Image2            = IF gsm_translated_menu_item.image2_up_filename          <> "":U THEN gsm_translated_menu_item.image2_up_filename          ELSE ttAction.Image2
                   ttAction.Image2Down        = IF gsm_translated_menu_item.image2_down_filename        <> "":U THEN gsm_translated_menu_item.image2_down_filename        ELSE ttAction.Image2Down
                   ttAction.Image2Insensitive = IF gsm_translated_menu_item.image2_insensitive_filename <> "":U THEN gsm_translated_menu_item.image2_insensitive_filename ELSE ttAction.Image2Insensitive
                   /* Check if we really want an image */
                   ttAction.Image             = IF ttAction.Image             = "NOIMAGE":U THEN "":U ELSE ttAction.Image
                   ttAction.ImageDown         = IF ttAction.ImageDown         = "NOIMAGE":U THEN "":U ELSE ttAction.ImageDown
                   ttAction.ImageInsensitive  = IF ttAction.ImageInsensitive  = "NOIMAGE":U THEN "":U ELSE ttAction.ImageInsensitive
                   ttAction.Image2            = IF ttAction.Image2            = "NOIMAGE":U THEN "":U ELSE ttAction.Image2
                   ttAction.Image2Down        = IF ttAction.Image2Down        = "NOIMAGE":U THEN "":U ELSE ttAction.Image2Down
                   ttAction.Image2Insensitive = IF ttAction.Image2Insensitive = "NOIMAGE":U THEN "":U ELSE ttAction.Image2Insensitive.
        END.
    END.    
END.

/* If the action is linked to an item category, create an item category record. */
IF gsm_menu_item.item_category_obj <> 0 THEN 
DO:
    FIND ttCategory 
         WHERE ttCategory.item_category_obj = gsm_menu_item.item_category_obj
         NO-ERROR.

    IF NOT AVAILABLE ttCategory THEN 
    DO:
        FIND gsc_item_category NO-LOCK
             WHERE gsc_item_category.item_category_obj = gsm_menu_item.item_category_obj 
             NO-ERROR.

        IF AVAILABLE gsc_item_category THEN 
        DO:
            CREATE ttCategory.
            ASSIGN ttCategory.Category    = gsc_item_category.item_category_label
                   ttCategory.Link        = gsc_item_category.item_link
                   ttCategory.systemowned = gsc_item_category.system_owned
                   ttAction.Category      = ttCategory.Category
                   ttAction.Link          = IF ttAction.Link = '':U 
                                            THEN ttCategory.Link
                                            ELSE ttAction.Link.

            IF gsc_item_category.parent_item_category_obj <> 0 THEN 
            DO:
                FIND parent_item_category NO-LOCK 
                     WHERE parent_item_category.item_category_obj = gsc_item_category.parent_item_category_obj 
                     NO-ERROR.
                IF AVAILABLE parent_item_category THEN
                    ASSIGN ttCategory.ParentCategory = parent_item_category.item_category_label.
            END.
        END.
    END.
    ELSE
        ASSIGN ttAction.Category = ttCategory.Category
               ttAction.Link     = IF ttAction.Link = '':U 
                                   THEN ttCategory.Link
                                   ELSE ttAction.Link.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


