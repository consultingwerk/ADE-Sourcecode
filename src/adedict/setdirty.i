/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: setdirty.i

Description:
   Set s_DictDirty to the given value.  If dict is dirty, enable the undo
   and commit menu options.  Otherwise, gray them.
 
Arguments
   &Dirty - true/false.

Author: Laura Stern

Date Created: 03/27/92

----------------------------------------------------------------------------*/

do:
   s_DictDirty = {&Dirty}.

   MENU-ITEM mi_Undo:sensitive in MENU s_mnu_Edit = {&Dirty}.
   MENU-ITEM mi_Commit:sensitive in MENU s_mnu_Edit = {&Dirty}.
end.

