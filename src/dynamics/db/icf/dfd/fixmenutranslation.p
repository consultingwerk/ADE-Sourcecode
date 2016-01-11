/* This noddy will remove all the existing translations created for
   menu item/actions on a container and add these to the new
   translated menu item table and then remove these records
   from the normal translation table
   
   This noddy should be run after the load of all delta (.df) files
   
   08/13/2002 Mark Davies (MIP) */

DISABLE TRIGGERS FOR LOAD OF gsm_translation.                  
DISABLE TRIGGERS FOR DUMP OF gsm_translation.

DEFINE VARIABLE dToolbarTypeObj AS DECIMAL    NO-UNDO.

FIND FIRST gsc_object_type 
     WHERE gsc_object_type.object_type_code = "SmartToolBar":U
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_object_type THEN
  RETURN.
ELSE 
  dToolbarTypeObj = gsc_object_type.object_type_obj.

FOR EACH gsm_translation
    EXCLUSIVE-LOCK:
  /* First see if it is a toolbar object */
  FIND FIRST ryc_smartobject
       WHERE ryc_smartobject.object_filename = gsm_translation.object_filename
       AND   ryc_smartobject.object_type_obj = dToolbarTypeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_smartobject THEN DO:
    FIND FIRST gsm_menu_item
         WHERE gsm_menu_item.menu_item_reference = gsm_translation.widget_name 
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_menu_item THEN DO:
      /* Now we have a valid menu item 
         Try and see if there is an existing translation
         for this item in the translated menu item table */
      IF NOT CAN-FIND(FIRST gsm_translated_menu_item
                      WHERE gsm_translated_menu_item.menu_item_obj       = gsm_menu_item.menu_item_obj
                      AND   gsm_translated_menu_item.language_obj        = gsm_translation.language_obj
                      AND   gsm_translated_menu_item.source_language_obj = gsm_translation.source_language_obj 
                      NO-LOCK) THEN DO:
        /* If there isn't a translated menu item for this item we need to add one
           and delete this record from the normal translations */
        CREATE gsm_translated_menu_item.
        ASSIGN gsm_translated_menu_item.menu_item_obj       = gsm_menu_item.menu_item_obj        
               gsm_translated_menu_item.language_obj        = gsm_translation.language_obj       
               gsm_translated_menu_item.source_language_obj = gsm_translation.source_language_obj
               gsm_translated_menu_item.menu_item_label     = gsm_translation.translation_label
               gsm_translated_menu_item.tooltip_text        = gsm_translation.translation_tooltip.
      END.
      /* Now, if it wasn't added we added it and now we need to get
         rid of the nornal translated record to avoid confusion 
         and duplication */
      DELETE gsm_translation.
    END. /* AVAILABLE gsm_menu_item */
  END. /* AVAILABLE ryc_smartobject */
END. /* gsm_translation */

