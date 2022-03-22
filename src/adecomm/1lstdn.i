/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: lstdn1.i

Description:
    Shift an item "down" one in a select list.

Arguments:
   &pick_list_w - The list.
   &frame       - The frame of the pick list
   
Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/

{adecomm/lst1def.i}

IF {&pick_list_w}:VALUE IN FRAME {&frame} <> ? THEN
  DO:

  /*
   * Find the entry in the list
   */
  ASSIGN
    lst_choice    = {&pick_list_w}:VALUE IN FRAME {&frame}
    lst_pick_list = {&pick_list_w}:LIST-ITEMS IN FRAME {&frame}
    lst_index     = LOOKUP(ENTRY(1, lst_choice), lst_pick_list).
  /*
   * Pull out the selected string from its current slot
   */ 
 
 DO lst_i = 1 TO NUM-ENTRIES(lst_choice):

    ASSIGN
    ENTRY(LOOKUP(ENTRY(lst_i, lst_choice), lst_pick_list), lst_pick_list) = "":u
      lst_pick_list = REPLACE(lst_pick_list,",,":u,",":u).

  END.

  /*
   * And now add the chosen item back into the list
   */
  ASSIGN
    lst_pick_list = TRIM(lst_pick_list,",":u)
    lst_index = MINIMUM(lst_index ,NUM-ENTRIES(lst_pick_list)).
    
    IF lst_index = 0 THEN
      lst_pick_list = lst_choice.
    ELSE
      ENTRY(lst_value_index, lst_pick_list) =
              ENTRY(lst_index, lst_pick_list) + ",":u + lst_choice.
    
    ASSIGN         
      {&pick_list_w}:LIST-ITEMS IN FRAME {&frame} = lst_pick_list     
      {&pick_list_w}:VALUE      IN FRAME {&frame} = lst_choice.
           
END.
