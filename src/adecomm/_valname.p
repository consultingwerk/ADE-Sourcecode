/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: valname.p

Description:
   Check to see that a name entered by the user is a valid PROGRESS 
   identifier.
 
Input Parameter:
   p_name      	  - The name to check
   p_allow_blanks - True if name can be blank or unknown.  Often we want
      	       	    to allow this so the user can TAB to the cancel button,
      	       	    for example.  However, if the field is defaulted to
      	       	    start with, the user must intentionally blank it out.  
      	       	    If he does so, we will flag it as an error.

Ouput Parameter:
   p_okay - Set to True if name is valid.

Author: Tony Lavinio, Laura Stern

Date Created: ? 

----------------------------------------------------------------------------*/

define input  parameter p_name 	       as char NO-UNDO.
define input  parameter p_allow_blanks as logical NO-UNDO.
define output parameter p_okay         as logical NO-UNDO.

define var i as integer NO-UNDO.

if p_name = "" OR p_name = ? OR p_name = "?" then
do:
   if p_allow_blanks then
      p_okay = true.
   else do:
      p_okay = false.
      message "Please enter a value for the name." SKIP
      	      "It may not be left blank or unknown."
      	      view-as ALERT-BOX ERROR buttons OK.
   end.
   return.
end.

p_okay = false.
IF LENGTH(p_name,"RAW":U) > 32 then
   message "This name is too long." SKIP
      	   "Please enter a name that has 32 characters or less."
      	    view-as ALERT-BOX ERROR buttons OK.

else if SUBSTRING(p_name,1,1,"CHARACTER":u) < "A":u OR 
        SUBSTRING(p_name,1,1,"CHARACTER":u) > "Z":u THEN
   message "A valid PROGRESS identifier must start with a letter." SKIP
      	   "Please enter another name."
      	    view-as ALERT-BOX ERROR buttons OK.

else if KEYWORD(p_name) <> ? then
   message "This name is a PROGRESS keyword." SKIP
      	   "Please enter another name."
      	    view-as ALERT-BOX ERROR buttons OK.

else do:
   p_okay = true.
   do i = 2 to LENGTH(p_name,"RAW":u) while p_okay:
      p_okay = INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ",
		     SUBSTRING(p_name,i,1,"CHARACTER":u)) > 0.
   end.
   if NOT p_okay then
      message "This name contains at least one invalid character: " + 
      	      SUBSTRING(p_name,i - 1,1,"CHARACTER":u)  SKIP
      	      "Please enter another name."
      	       view-as ALERT-BOX ERROR buttons OK.
end.



