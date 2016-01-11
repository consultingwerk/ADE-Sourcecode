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

   &choice       - THe current selection
   &pick_list    - The list.
   &choice_index - The index position of the user's choice
   
Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/

DO:
  /* Pull out the selected string from its current slot */ 
  DO lstup_i = 1 TO NUM-ENTRIES({&choice},CHR(3)):
    ASSIGN
      ENTRY(LOOKUP(ENTRY(lstup_i,{&choice},CHR(3)),{&pick_list},CHR(3)),
        {&pick_list},CHR(3)) = ""
      {&pick_list} = REPLACE({&pick_list},CHR(3) + CHR(3),CHR(3)).
  END.

  /* And now add the chosen item back into the list */
  ASSIGN
    {&pick_list} = TRIM({&pick_list},CHR(3))
    {&choice_index} = MINIMUM({&choice_index},NUM-ENTRIES({&pick_list},CHR(3))).
    
    IF {&choice_index} = 0 THEN
      {&pick_list} = {&choice}.
    ELSE
      ENTRY({&choice_index},{&pick_list},CHR(3)) =
        ENTRY({&choice_index},{&pick_list},CHR(3)) + CHR(3) + {&choice}.
END.

/* lstdn.i - end of file */

