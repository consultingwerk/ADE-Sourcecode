&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : 
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
&GLOBAL-DEFINE VALID-CONTAINERS               DynFold,DynMenc,DynObjc,DynFrame
&GLOBAL-DEFINE VALID-DATA-CONTAINERS          DynSBO
&GLOBAL-DEFINE VALID-VISIBLE-OBJECT-TYPES     DynBrow,DynView,SmartFolder,SmartPanel,SmartToolbar,SmartViewer,StaticSDV,StaticSO,SmartFrame,DynFrame
/* replaced by call to getDataSourceClasses in design manager 
&GLOBAL-DEFINE VALID-NON-VISIBLE-OBJECT-TYPES DataQuery,SBO
*/ 

DEFINE VARIABLE giCounter AS INTEGER  NO-UNDO.

&IF DEFINED(define-only) = 0 &THEN
  DEFINE TEMP-TABLE ttSmartLink NO-UNDO  RCODE-INFORMATION
    FIELD d_smartlink_obj               AS DECIMAL
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD d_smartlink_type_obj          AS DECIMAL
    FIELD c_link_name                   AS CHARACTER  COLUMN-LABEL "Link name"  FORMAT "x(28)":U
    FIELD d_source_object_instance_obj  AS DECIMAL
    FIELD d_target_object_instance_obj  AS DECIMAL
    FIELD c_action                      AS CHARACTER
    .
  
  DEFINE TEMP-TABLE ttPage NO-UNDO RCODE-INFORMATION
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD d_page_obj                    AS DECIMAL
    FIELD d_layout_obj                  AS DECIMAL
    FIELD i_page_sequence               AS INTEGER   COLUMN-LABEL "Page seq."      FORMAT ">9":U
    FIELD c_page_label                  AS CHARACTER COLUMN-LABEL "Page label"     FORMAT "x(28)":U
    FIELD c_security_token              AS CHARACTER COLUMN-LABEL "Security token" FORMAT "x(28)":U
    FIELD c_page_reference              AS CHARACTER
    FIELD c_plain_label                 AS CHARACTER
    FIELD l_enable_on_create            AS LOGICAL
    FIELD l_enable_on_modify            AS LOGICAL
    FIELD l_enable_on_view              AS LOGICAL
    FIELD c_action                      AS CHARACTER
    FIELD i_original_page_sequence      AS INTEGER
    INDEX idxSequence d_customization_result_obj
                      i_page_sequence
    .
  
  DEFINE TEMP-TABLE ttPageObject  NO-UNDO RCODE-INFORMATION
    FIELD d_page_object_obj             AS DECIMAL
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD d_page_obj                    AS DECIMAL
    FIELD i_page_object_sequence        AS INTEGER
    FIELD d_object_instance_obj         AS DECIMAL
    FIELD c_action                      AS CHARACTER
    .
  
  DEFINE TEMP-TABLE ttObjectInstance NO-UNDO RCODE-INFORMATION
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD d_object_instance_obj         AS DECIMAL
    FIELD d_smartobject_obj             AS DECIMAL
    FIELD c_instance_description        AS CHARACTER COLUMN-LABEL "Instance description"  FORMAT "x(35)":U
    FIELD c_instance_name               AS CHARACTER COLUMN-LABEL "Instance name"         FORMAT "x(35)":U
    FIELD l_system_owned                AS LOGICAL
    FIELD c_layout_position             AS CHARACTER
    FIELD i_row                         AS INTEGER   COLUMN-LABEL "R"                     FORMAT "9":U   /* Only used in rygridobjv.w */
    FIELD i_column                      AS INTEGER   COLUMN-LABEL "C"                     FORMAT "9":U   /* Only used in rygridobjv.w */
    FIELD i_page                        AS INTEGER   COLUMN-LABEL "Pg."                   FORMAT ">9":U  /* Only used in rygridobjv.w */
    FIELD c_lcr                         AS CHARACTER COLUMN-LABEL "Align"                 FORMAT "X":U   /* Only used in rygridobjv.w */
    FIELD d_page_obj                    AS DECIMAL
    FIELD i_object_sequence             AS INTEGER
    FIELD l_resize_horizontal           AS LOGICAL   /* Attribute value maintained on-screen */
    FIELD l_resize_vertical             AS LOGICAL   /* Attribute value maintained on-screen */
    FIELD c_foreign_fields              AS CHARACTER /* Attribute value maintained on-screen */
    FIELD c_action                      AS CHARACTER
    FIELD d_object_type_obj             AS DECIMAL   /* Used for information purposes only */
    FIELD c_smartobject_filename        AS CHARACTER /* Used for information purposes only */
    FIELD d_custom_smartobject_obj      AS DECIMAL   /* Used for information purposes only */
    FIELD l_visible_object              AS LOGICAL   COLUMN-LABEL "Visible"              FORMAT "Yes/No":U
    .
  
  DEFINE TEMP-TABLE ttSmartObject NO-UNDO RCODE-INFORMATION
    FIELD c_object_description          AS CHARACTER
    FIELD d_smartobject_obj             AS DECIMAL
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD d_layout_obj                  AS DECIMAL
    FIELD d_object_type_obj             AS DECIMAL
    FIELD d_object_obj                  AS DECIMAL
    FIELD c_object_filename             AS CHARACTER COLUMN-LABEL "Filename":U FORMAT "x(35)":U
    FIELD d_product_module_obj          AS DECIMAL
    FIELD l_static_object               AS LOGICAL
    FIELD c_custom_super_procedure      AS CHARACTER
    FIELD d_custom_smartobject_obj      AS DECIMAL
    FIELD l_system_owned                AS LOGICAL
    FIELD c_shutdown_message_text       AS CHARACTER
    FIELD d_sdo_smartobject_obj         AS DECIMAL
    FIELD l_template_smartobject        AS LOGICAL
    FIELD c_template_object_name        AS CHARACTER /* Attribute value maintained on-screen */
    FIELD c_action                      AS CHARACTER /*  */
    .

  DEFINE TEMP-TABLE ttAttributeValue NO-UNDO RCODE-INFORMATION
    FIELD d_attribute_value_obj         AS DECIMAL
    FIELD d_object_type_obj             AS DECIMAL
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_smartobject_obj             AS DECIMAL
    FIELD d_object_instance_obj         AS DECIMAL
    FIELD l_constant_value              AS LOGICAL
    FIELD c_attribute_label             AS CHARACTER
    FIELD c_character_value             AS CHARACTER
    FIELD i_integer_value               AS INTEGER
    FIELD t_date_value                  AS DATE
    FIELD d_decimal_value               AS DECIMAL
    FIELD l_logical_value               AS LOGICAL
    FIELD r_raw_value                   AS RAW
    FIELD d_primary_smartobject_obj     AS DECIMAL
    FIELD i_data_type                   AS INTEGER
    FIELD c_customization_result_code   AS CHARACTER
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD c_action                      AS CHARACTER
    FIELD l_master_attribute            AS LOGICAL
    .

  DEFINE TEMP-TABLE ttUiEvent NO-UNDO RCODE-INFORMATION
    FIELD d_ui_event_obj                AS DECIMAL
    FIELD d_object_type_obj             AS DECIMAL
    FIELD d_container_smartobject_obj   AS DECIMAL
    FIELD d_smartobject_obj             AS DECIMAL
    FIELD d_object_instance_obj         AS DECIMAL
    FIELD c_event_name                  AS CHARACTER
    FIELD l_constant_value              AS LOGICAL
    FIELD c_action_type                 AS CHARACTER
    FIELD c_action_target               AS CHARACTER
    FIELD c_event_action                AS CHARACTER
    FIELD c_event_parameter             AS CHARACTER
    FIELD l_event_disabled              AS LOGICAL
    FIELD d_primary_smartobject_obj     AS DECIMAL
    FIELD c_customization_result_code   AS CHARACTER
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD c_action                      AS CHARACTER
    FIELD l_master_event                AS LOGICAL
    .
  
  /* 'Base' data temp-table defnition */
  
  DEFINE TEMP-TABLE ttObjectType NO-UNDO RCODE-INFORMATION
    FIELD c_object_type_code            AS CHARACTER COLUMN-LABEL "Object type" FORMAT "x(15)":U
    FIELD d_object_type_obj             AS DECIMAL
    .
    
  DEFINE TEMP-TABLE ttSupportedLink NO-UNDO RCODE-INFORMATION
    FIELD d_object_type_obj             AS DECIMAL
    FIELD d_smartlink_type_obj          AS DECIMAL
    FIELD l_link_source                 AS LOGICAL
    FIELD l_link_target                 AS LOGICAL
    .
  
  DEFINE TEMP-TABLE ttSmartLinkType NO-UNDO RCODE-INFORMATION
    FIELD d_smartlink_type_obj          AS DECIMAL
    FIELD c_link_name                   AS CHARACTER
    FIELD l_user_defined_link           AS LOGICAL
    .

  DEFINE TEMP-TABLE ttObjectMenuStructure NO-UNDO RCODE-INFORMATION
    FIELD d_object_obj                  AS DECIMAL
    FIELD d_menu_structure_obj          AS DECIMAL
    FIELD d_instance_attribute_obj      AS DECIMAL
    FIELD d_object_menu_structure_obj   AS DECIMAL
    FIELD d_menu_item_obj               AS DECIMAL
    FIELD l_insert_submenu              AS LOGICAL   COLUMN-LABEL "Insert submenu":U   FORMAT "Yes/No":U
    FIELD i_menu_structure_sequence     AS INTEGER
    FIELD c_menu_structure_description  AS CHARACTER COLUMN-LABEL "Description":U      FORMAT "x(35)":U
    FIELD c_menu_structure_code         AS CHARACTER COLUMN-LABEL "Code":U             FORMAT "x(28)":U
    FIELD c_attribute_code              AS CHARACTER COLUMN-LABEL "Attribute code":U   FORMAT "x(35)":U
    FIELD c_menu_item_label             AS CHARACTER COLUMN-LABEL "Label":U            FORMAT "x(28)":U
    FIELD c_item_placeholder_label      AS CHARACTER COLUMN-LABEL "Item placeholder":U FORMAT "x(28)":U
    FIELD d_customization_result_obj    AS DECIMAL
    FIELD c_action                      AS CHARACTER
    INDEX idxCustomization
          d_customization_result_obj
          i_menu_structure_sequence.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTemporaryObj Include 
FUNCTION getTemporaryObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isVisibleObjectType Include 
FUNCTION isVisibleObjectType RETURNS LOGICAL
  (pcObjectTypeCode AS CHARACTER)  FORWARD.

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
         HEIGHT             = 5.57
         WIDTH              = 54.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTemporaryObj Include 
FUNCTION getTemporaryObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dTemporaryObj AS DECIMAL    NO-UNDO.
  
  ASSIGN
      giCounter     = giCounter + 1
      dTemporaryObj = (RANDOM(2, 17) * ETIME * -1) + giCounter.
  
  RETURN dTemporaryObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isVisibleObjectType Include 
FUNCTION isVisibleObjectType RETURNS LOGICAL
  (pcObjectTypeCode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClasses            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDesignManager      AS HANDLE     NO-UNDO.

  ASSIGN 
    hDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U IN TARGET-PROCEDURE, 
                                      "RepositoryDesignManager":U)
    cClasses       = DYNAMIC-FUNCTION('getDataSourceClasses':U IN hDesignManager).
  
  RETURN LOOKUP(pcObjectTypeCode, cClasses) = 0. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

