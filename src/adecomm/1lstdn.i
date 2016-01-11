/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
