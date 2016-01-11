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

File: _blnknam.p

Description:
   Determine if the name of an object is blank or ?. 

Input Parameters:
   p_Widget - The handle to the widget holding the name to check.
   p_Obj    - String denoting the object type that this name belongs to
      	      (e.g., "table").
   
Output Parameters:
   p_Blank  - Set to true if name is blank or ?.
 
Author: Laura Stern

Date Created: 07/10/92 

----------------------------------------------------------------------------*/

Define INPUT  PARAMETER p_Widget as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Obj    as char       	  NO-UNDO.
Define OUTPUT PARAMETER p_Blank  as logical  	  NO-UNDO.

Define var name as char NO-UNDO.

p_Obj = p_Obj + ".".
name = p_Widget:screen-value.

if name = "" OR name = "?" then
do:
   message "Please enter a name for this" p_Obj
   	    view-as ALERT-BOX ERROR buttons OK.
   p_Blank = true.

   /* Set focus there so the user can enter a name */
   apply "entry" to p_Widget. 
end.
else
   p_Blank = false.
