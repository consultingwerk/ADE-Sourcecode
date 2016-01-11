  FIELD disabled LIKE gsm_menu_item.disabled VALIDATE ~
  FIELD disable_rule LIKE gsm_menu_item.disable_rule VALIDATE ~
  FIELD enable_rule LIKE gsm_menu_item.enable_rule VALIDATE ~
  FIELD hide_if_disabled LIKE gsm_menu_item.hide_if_disabled VALIDATE ~
  FIELD hide_rule LIKE gsm_menu_item.hide_rule VALIDATE ~
  FIELD image1_down_filename LIKE gsm_menu_item.image1_down_filename VALIDATE ~
  FIELD image1_insensitive_filename LIKE gsm_menu_item.image1_insensitive_filename VALIDATE ~
  FIELD image1_up_filename LIKE gsm_menu_item.image1_up_filename VALIDATE ~
  FIELD image2_down_filename LIKE gsm_menu_item.image2_down_filename VALIDATE ~
  FIELD image2_insensitive_filename LIKE gsm_menu_item.image2_insensitive_filename VALIDATE ~
  FIELD image2_up_filename LIKE gsm_menu_item.image2_up_filename VALIDATE ~
  FIELD instance_attribute_obj LIKE gsm_menu_item.instance_attribute_obj VALIDATE ~
  FIELD item_category_obj LIKE gsm_menu_item.item_category_obj VALIDATE ~
  FIELD item_control_style LIKE gsm_menu_item.item_control_style VALIDATE  LABEL "Style"~
  FIELD item_control_type LIKE gsm_menu_item.item_control_type VALIDATE  FORMAT "X(12)" LABEL "Item Type*"~
  FIELD item_link LIKE gsm_menu_item.item_link VALIDATE ~
  FIELD item_menu_drop LIKE gsm_menu_item.item_menu_drop VALIDATE  LABEL "Menu Drop Function"~
  FIELD item_select_action LIKE gsm_menu_item.item_select_action VALIDATE ~
  FIELD item_select_parameter LIKE gsm_menu_item.item_select_parameter VALIDATE  LABEL "Parameter"~
  FIELD item_select_type LIKE gsm_menu_item.item_select_type VALIDATE  LABEL "Action Type"~
  FIELD item_toolbar_label LIKE gsm_menu_item.item_toolbar_label VALIDATE  LABEL "Toolbar Label"~
  FIELD menu_item_description LIKE gsm_menu_item.menu_item_description VALIDATE  LABEL "Description*"~
  FIELD menu_item_label LIKE gsm_menu_item.menu_item_label VALIDATE  LABEL "Menu Label*"~
  FIELD menu_item_obj LIKE gsm_menu_item.menu_item_obj VALIDATE ~
  FIELD menu_item_reference LIKE gsm_menu_item.menu_item_reference VALIDATE  LABEL "Item Reference*"~
  FIELD object_obj LIKE gsm_menu_item.object_obj VALIDATE ~
  FIELD on_create_publish_event LIKE gsm_menu_item.on_create_publish_event VALIDATE  LABEL "Create Event"~
  FIELD product_module_obj LIKE gsm_menu_item.product_module_obj VALIDATE ~
  FIELD propagate_links LIKE gsm_menu_item.propagate_links VALIDATE ~
  FIELD security_token LIKE gsm_menu_item.security_token VALIDATE ~
  FIELD shortcut_key LIKE gsm_menu_item.shortcut_key VALIDATE ~
  FIELD substitute_text_property LIKE gsm_menu_item.substitute_text_property VALIDATE  LABEL "Label Substitute"~
  FIELD system_owned LIKE gsm_menu_item.system_owned VALIDATE ~
  FIELD toggle_menu_item LIKE gsm_menu_item.toggle_menu_item VALIDATE ~
  FIELD tooltip_text LIKE gsm_menu_item.tooltip_text VALIDATE  LABEL "Tooltip"~
  FIELD under_development LIKE gsm_menu_item.under_development VALIDATE  LABEL "Under Devel."~
  FIELD image_alternate_rule LIKE gsm_menu_item.image_alternate_rule VALIDATE  LABEL "Alternate Image rule"~
  FIELD item_narration LIKE gsm_menu_item.item_narration VALIDATE ~
  FIELD source_language_obj LIKE gsm_menu_item.source_language_obj VALIDATE ~
  FIELD language_code LIKE gsc_language.language_code VALIDATE ~
  FIELD language_name LIKE gsc_language.language_name VALIDATE 
