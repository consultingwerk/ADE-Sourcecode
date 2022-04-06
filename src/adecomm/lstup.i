/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: lstup.i

Description:
    Generic include to shift an item "up" one in an array that represents
    a select list. This include does not directly access the widget.

Arguments:

   &choice       - The current selection
   &pick_list    - The pick list
   &choice_index - The index postion of the users choice 

Author: David Lee

Date Created: 03/04/93
-----------------------------------------------------------------------------*/

DO:
  /* Pull out the selected string from its current slot */ 

    {&pick_list} = {&pick_list} + CHR(3).

  DO lstup_i = 1 TO NUM-ENTRIES({&choice},CHR(3)):
    ASSIGN
    ENTRY(LOOKUP(ENTRY(lstup_i,{&choice},CHR(3)),{&pick_list},CHR(3)), 
      {&pick_list},CHR(3)) = ""
     {&pick_list} = TRIM(REPLACE({&pick_list},CHR(3) + CHR(3),CHR(3))).
  END.
 
  /* Did we leave CHR(3) hanging off list? If so, trash it */
  IF ASC(SUBSTRING({&pick_list},
    LENGTH({&pick_list},"CHARACTER":u),1,"CHARACTER":u)) = 3 THEN
     {&pick_list} = SUBSTRING({&pick_list},1,
                     LENGTH({&pick_list},"CHARACTER":u) - 1,"CHARACTER":u).

  /* And now add the chosen item back into the list */
  ASSIGN
    {&choice_index} = MAXIMUM({&choice_index} - 1, 1)
    ENTRY({&choice_index},{&pick_list},CHR(3)) =
          {&choice} + (IF {&pick_list} = "" THEN "" ELSE CHR(3) 
                       + ENTRY({&choice_index},{&pick_list},CHR(3))).

END.

/* lstup.i - end of file */

