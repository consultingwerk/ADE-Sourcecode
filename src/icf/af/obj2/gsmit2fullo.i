  FIELD menu_structure_code LIKE gsm_menu_structure.menu_structure_code VALIDATE  FORMAT "X(18)" LABEL "Band Code"~
  FIELD menu_structure_description LIKE gsm_menu_structure.menu_structure_description VALIDATE  LABEL "Band Description"~
  FIELD product_module_obj LIKE gsm_menu_structure.product_module_obj VALIDATE ~
  FIELD menu_structure_type LIKE gsm_menu_structure.menu_structure_type VALIDATE  LABEL "Band Type"~
  FIELD menu_item_obj LIKE gsm_menu_structure_item.menu_item_obj VALIDATE 
