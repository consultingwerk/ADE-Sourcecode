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

