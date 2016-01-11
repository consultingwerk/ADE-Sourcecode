&SCOPED-DEFINE InputTable gsm_menu_structure_item
&SCOPED-DEFINE ObjField menu_structure_item_obj

/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
