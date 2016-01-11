/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
&SCOPED-DEFINE InputTable gsm_object_menu_structure
&SCOPED-DEFINE ObjField object_menu_structure_obj
{db/icf/dfd/sitedataprocin.i
  &InputFile = "'gsmomout.d'"
  }

{db/icf/dfd/siteapplyrechdr.i}
  IF NOT CAN-FIND(FIRST gsm_menu_structure
                    WHERE gsm_menu_structure.menu_structure_obj = tt_{&InputTable}.menu_structure_obj) THEN
    RETURN.

  IF NOT CAN-FIND(FIRST ryc_smartobject
                    WHERE ryc_smartobject.smartobject_obj = tt_{&InputTable}.object_obj) THEN
    RETURN.

  IF tt_{&InputTable}.menu_item_obj <> 0.00 AND
     NOT CAN-FIND(FIRST gsm_menu_item
                    WHERE gsm_menu_item.menu_item_obj = tt_{&InputTable}.menu_item_obj) THEN
    RETURN.


  IF tt_{&InputTable}.instance_attribute_obj <> 0.00 AND
     NOT CAN-FIND(FIRST gsc_instance_attribute
                    WHERE gsc_instance_attribute.instance_attribute_obj = tt_{&InputTable}.instance_attribute_obj) THEN
    RETURN.


  /* Duplicate record */
  IF CAN-FIND(FIRST gsm_object_menu_structure 
                WHERE gsm_object_menu_structure.object_obj = tt_{&InputTable}.object_obj
                  AND gsm_object_menu_structure.menu_structure_obj = tt_{&InputTable}.menu_structure_obj
                  AND gsm_object_menu_structure.instance_attribute_obj = tt_{&InputTable}.instance_attribute_obj) THEN
    RETURN.


{db/icf/dfd/siteapplyrecftr.i}
