/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: 1lstup.i

Description:
    Shift an item "up" one in a soingle select list.

Arguments:
   &pick_list_w - The list.
   &frame     - The frame of the pick list
   

Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/

{adecomm/lstdef1.i}

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
   * Update the data structure
   */
   
   {adecomm/lstup.i &choice       = lst_choice
                    &pick_list    = lst_pick_list
                    &choice_index = lst_index}

  /*
   * And now add the chosen item back into the list
   */
  ASSIGN       
    {&pick_list_w}:LIST-ITEMS IN FRAME {&frame} = lst_pick_list
      
    {&pick_list_w}:VALUE      IN FRAME {&frame} = lst_choice.
           
END.
