/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: 2lstdn.i

Description:
    Shift an item "down" one in a "shadow" select list situation. This
    code assumes that both lists have the same number of entries and
    are already in proper order.
    
    The function including this file must also include 2lstdef.i

Arguments:
   &pick_list_w   - The list.
   &shadow_list_w - The shadow of the list.
   &frame         - The frame of the pick list

Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/

IF {&pick_list_w}:SCREEN-VALUE IN FRAME {&frame} <> ? THEN DO:
  /* Find the entry in the list */
  ASSIGN
    lst_choice      = {&pick_list_w}:SCREEN-VALUE IN FRAME {&frame}
    lst_pick_list   = {&pick_list_w}:LIST-ITEMS IN FRAME {&frame}
    lst_index       = LOOKUP(ENTRY(1,lst_choice,CHR(3)),lst_pick_list,CHR(3))
    lst2_orig_index = lst_index
    lst2_pick_list  = {&shadow_list_w}:LIST-ITEMS IN FRAME {&frame}.

  /*
   * Update the shadow list. First build a second choice list
   * based on the first choice list. First get the name of the
   * choice, then gets its location in its data structure, then
   * get the corresponding element from the shadow's datastructure
   */
  
  DO lst2_index = 1 TO NUM-ENTRIES(lst_choice,CHR(3)):
    lst2_shadow = lst2_shadow +
      ENTRY(LOOKUP(ENTRY(lst2_index,lst_choice,CHR(3)),lst_pick_list,CHR(3)),
            lst2_pick_list,CHR(3)).

    IF lst2_index <> NUM-ENTRIES(lst_choice,CHR(3)) THEN
      lst2_shadow = lst2_shadow + CHR(3).
  END.

  /* Update the data structure for the list that has the selection */
  {adecomm/lstdn.i &choice       = lst_choice
                   &pick_list    = lst_pick_list
                   &choice_index = lst_index}

  /* And now add the chosen item back into the list */
  ASSIGN       
    {&pick_list_w}:LIST-ITEMS IN FRAME {&frame}   = lst_pick_list      
    {&pick_list_w}:SCREEN-VALUE IN FRAME {&frame} = lst_choice.
  
  /* Go change the data structure */
  {adecomm/lstdn.i &choice       = lst2_shadow
                   &pick_list    = lst2_pick_list
                   &choice_index = lst2_orig_index}

  /* And now update the shadow.  */
  ASSIGN       
    {&shadow_list_w}:LIST-ITEMS IN FRAME {&frame}   = lst2_pick_list      
    {&shadow_list_w}:SCREEN-VALUE IN FRAME {&frame} = lst2_shadow.
       
END.

/* 2lstdn.i - end of file */

