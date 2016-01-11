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

File: forceval.i

Description:
   This is to enforce validation when the user hits a default button
   (other than an AUTO-GO button) by hitting RETURN or "presses" a button
   by using it's keyboard accelerator.  In these cases, Progress does
   not generate any LEAVE events, so we have to do it ourselves.

Author: Laura Stern

Date Created: 05/25/92 
----------------------------------------------------------------------------*/


s_Widget = focus:handle.
if s_Widget <> SELF:handle then 
do:
   s_Valid = yes.
   apply "LEAVE" to s_Widget.
   if NOT s_Valid then
      return NO-APPLY.
end.
