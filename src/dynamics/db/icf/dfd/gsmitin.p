&SCOPED-DEFINE InputTable gsm_menu_structure_item
&SCOPED-DEFINE ObjField menu_structure_item_obj

{db/icf/dfd/sitedataprocin.i
  &InputFile = "'gsmitout.d'"
  }



{db/icf/dfd/siteapplyrechdr.i}

  
  IF NOT CAN-FIND(FIRST gsm_menu_structure
                    WHERE gsm_menu_structure.menu_structure_obj = tt_{&InputTable}.menu_structure_obj) THEN
    RETURN.


  IF tt_{&InputTable}.menu_item_obj <> 0.00 AND
     NOT CAN-FIND(FIRST gsm_menu_item
                    WHERE gsm_menu_item.menu_item_obj = tt_{&InputTable}.menu_item_obj) THEN
    RETURN.


  IF tt_{&InputTable}.child_menu_structure_obj <> 0.00 AND
     NOT CAN-FIND(FIRST gsm_menu_structure
                    WHERE gsm_menu_structure.menu_structure_obj = tt_{&InputTable}.child_menu_structure_obj) THEN
    RETURN.

  /* Duplicate record */
  IF CAN-FIND(FIRST gsm_menu_structure_item 
                WHERE gsm_menu_structure_item.menu_structure_obj = tt_{&InputTable}.menu_structure_obj
                  AND gsm_menu_structure_item.menu_item_sequence = tt_{&InputTable}.menu_item_sequence) THEN
    RETURN.

{db/icf/dfd/siteapplyrecftr.i}
