&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : rymenufunc.i
    Purpose     :

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
   DEFINE VARIABLE cPhysicalObject AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cFullPath       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAttribute      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE dObjectObj      AS DECIMAL    NO-UNDO.

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
            cLogicalObject = "":U
            cPhysicalObject = "":U.

          FIND FIRST blogObject NO-LOCK
               WHERE blogObject.smartobject_obj = bMenuItem.object_obj
               NO-ERROR.
          
          IF AVAILABLE blogObject THEN
          DO:
            IF blogObject.static_object = NO THEN
              FIND FIRST bphyObject NO-LOCK
                   WHERE bphyObject.smartobject_obj = blogObject.physical_smartobject_obj
                   NO-ERROR.

            IF AVAILABLE bphyObject AND blogObject.static_object = NO THEN
              ASSIGN
                cLogicalObject  = blogObject.OBJECT_filename
                cPhysicalObject = bphyObject.OBJECT_filename
                cFullPath       = LC(TRIM(REPLACE(bphyObject.object_path,"~\":U,"/":U)))
                cRequiredDbList = blogObject.required_db_list
                cRequiredDbList = cRequiredDbList 
                                  + (IF cRequiredDbList <> "":U 
                                     AND bphyObject.required_db_list <> "":U 
                                     THEN ",":U ELSE "":U)
                                  +  bphyObject.required_db_list
                .
            ELSE 
              ASSIGN
                cLogicalObject  = "":U
                cPhysicalObject = blogObject.OBJECT_filename
                cFullPath       = LC(TRIM(REPLACE(blogObject.object_path,"~\":U,"/":U)))
                cRequiredDbList = blogObject.required_db_list
                .
            IF cPhysicalObject <> "":U THEN
            DO:
              ASSIGN
                cFullPath = cFullPath 
                            +  (IF LENGTH(cFullPath) > 0 
                                AND SUBSTRING(cFullPath,LENGTH(cFullPath)) <> "/":U 
                                THEN "/":U 
                                ELSE "":U)
                            + LC(TRIM(cPhysicalObject))
                cPhysicalObject = cFullPath .
              IF blogObject.object_extension > "" and cPhysicalObject > "" and NUM-ENTRIES(cPhysicalObject,".") = 1 THEN 
                 cPhysicalObject =  cPhysicalObject + "." + blogObject.object_extension .

            END.
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

            IF AVAILABLE bphyObject AND bphyObject.Disabled THEN
              ASSIGN lDisabled = YES.    
            IF blogObject.Disabled THEN
              ASSIGN lDisabled = YES.
            
            IF AVAILABLE bphyObject AND NOT bphyObject.RUN_persistent THEN
              ASSIGN lPersistent = NO.    
            IF NOT blogObject.RUN_persistent THEN
              ASSIGN lPersistent = NO.  

          END. /* avail bLogObject*/
          ELSE
              lDisabled = YES.
          
          IF lDisabled AND bMenuItem.hide_if_disabled THEN RETURN '':U.
       END. /* launch */
       ELSE
          ASSIGN
            cLogicalObject = "":U
            cPhysicalObject = "":U.

       createAction(bMenuItem.menu_item_obj).
       ASSIGN
          ttAction.RunAttribute       = cAttribute
          ttAction.Disabled           = lDisabled
          ttAction.PhysicalObjectName = cPhysicalObject
          ttAction.LogicalObjectName  = cLogicalObject
          ttAction.RunPersistent      = lPersistent
          ttAction.DbRequiredList     = RIGHT-TRIM(cRequiredDBList,',':U)
       .
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
  /* If the login language is not the same as the menu item's source language
     then we will attempt to try and find a translated menu item */
  IF dLoginLanguageObj <> bMenuItem.source_language_obj THEN DO:
    dTransLanguageObj = canFindTranslation(bMenuItem.menu_item_obj,dLoginLanguageObj).
    IF dTransLanguageObj <> 0 AND
       dTransLanguageObj <> ? THEN DO:
      FIND FIRST gsm_translated_menu_item
           WHERE gsm_translated_menu_item.menu_item_obj = bMenuItem.menu_item_obj
           AND   gsm_translated_menu_item.language_obj  = dTransLanguageObj
           NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_translated_menu_item THEN DO:
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

