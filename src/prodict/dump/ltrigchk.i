/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: ltrigchk.i

Description:   
   Check to see if there are any create or write triggers for this table or 
   assign triggers for its fields and if so, see if this user has privileges 
   to dump/load with triggers disabled.

Input: The _File buffer has the _File record in it that we want to check.
 
Arguments:
   &OK - Set to true if either no triggers are found or user has privileges
      	 to dump load with triggers disabled.  Otherwise, set to false.

Author: Laura Stern

Date Created: 11/23/92 

----------------------------------------------------------------------------*/

Define var trig_found as logical NO-UNDO.

trig_found = no.
find _File-trig of _File where 
   _File-trig._Event = "CREATE" OR
   _File-trig._Event = "WRITE" NO-ERROR.
if AVAILABLE _File-trig then
   trig_found = yes.
else do:
   for each _Field of _File while NOT trig_found:
      find first _Field-trig of _Field NO-ERROR. /* ASSIGN is the only event */
      if AVAILABLE _Field-trig then
      	 trig_found = yes.
   end.
end.

if trig_found then
   {&OK} = CAN-DO(_File._Can-Load,USERID(user_dbname)).
else
   {&OK} = yes.


