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

File: _lva4nam.p

Description:
   The name field of a create dialog or property window has been "left".
   Check the name to see if it's allright.

   Note: This is a separate .p instead of an internal procedure in edittrig.i
   in order to make edittrig.i smaller.  

Input Parameters:
   p_OrigName - If editing, this was the original name before we sensitive it
      	        for edit.  If adding, this is ignored.
   p_Win      - If editing the window to parent any alert boxes to.  If
      	        adding this is ignored.

Output Parameters:
   p_Name     - Set to the new name value.
   p_Okay     - Set to yes as name is changed if not valid for AS/400
 
Author: Donna McMann

Date Created: 04/24/95
     History: 05/24/00 Added check for blank name.

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}

Define INPUT  PARAMETER p_OrigName  as char    	      NO-UNDO.
Define INPUT  PARAMETER p_Win  	    as widget-handle  NO-UNDO.
Define OUTPUT PARAMETER p_Name 	    as char 	      NO-UNDO.
Define OUTPUT PARAMETER p_Okay 	    as logical 	      NO-UNDO.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.

p_Name = TRIM (SELF:screen-value).        
p_Okay = yes.
IF LENGTH(p_Name) = 0 OR p_name = "?" THEN DO:
  message "Please enter a value for the name." SKIP
      	  "It may not be left blank or unknown."
      	      view-as ALERT-BOX ERROR buttons OK.
  ASSIGN p_Okay = FALSE.
  RETURN.
END.
if NOT s_Adding then
do:
   /* If editing and the name hasn't been changed from what it started 
      as, do nothing. */ 
   if CAPS(p_OrigName) = CAPS(p_Name) then
      return.

   /* To parent any alert boxes properly.  Since add is modal, we know 
      it's parent is still correct. */
   current-window = p_Win.
end.

/* Make sure the name is a valid for  AS400 */   
assign lngth = LENGTH(p_Name).        
IF lngth > 10 THEN lngth = 10.

do i = 1 to lngth:
  if i = 1 then do:
    if (asc(substring(p_Name,i,1)) >= 64 AND  asc(substring(p_Name,i,1)) <= 90)  OR
         (asc(substring(p_Name,i,1)) >= 97 AND asc(substring(p_Name,i,1)) <= 122)  OR
         (asc(substring(p_Name,i,1)) >= 35 AND asc(substring(p_Name,i,1)) <= 36)  THEN.
         else
           assign p_Name = "A" + substring(p_Name,2).
   end.
   else do:
     if (asc(substring(p_Name,i,1)) >= 64 AND asc(substring(p_Name,i,1)) <= 90)  OR
         (asc(substring(p_Name,i,1)) >= 97 AND asc(substring(p_Name,i,1)) <= 122)  OR
         (asc(substring(p_Name,i,1)) >= 35 AND asc(substring(p_Name,i,1)) <= 36)  OR   
         (asc(substring(p_Name,i,1)) >= 48 AND asc(substring(p_Name,i,1)) <= 57)  OR
         (asc(substring(p_Name,i,1)) = 44) OR
         (asc(substring(p_Name,i,1)) = 46  AND user_env[35] <> "format") THEN.
         else
         assign p_Name = substring(p_Name, 1, i - 1) + "_" + substring(p_Name,i + 1).
     end.    
 end.     

SELF:screen-value =     CAPS(p_Name).  /* Reset the trimmed value */





