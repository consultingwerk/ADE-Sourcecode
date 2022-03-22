/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dtrigchk.i

Description:   
   Check to see if there are any find triggers for this table and
   if so, see if this user has privileges to dump/load with triggers 
   disabled.

Input: The _File buffer has the _File record in it that we want to check.
 
Arguments:
   &OK - Set to true if no FIND trigger is found or user has privileges
      	 to dump load with triggers disabled.  Otherwise, set to false.

Author: Laura Stern

Date Created: 11/23/92 

----------------------------------------------------------------------------*/


find _File-trig of _File where _File-trig._Event = "FIND" NO-ERROR.
if AVAILABLE _File-trig then
   {&OK} = CAN-DO(_File._Can-Dump,USERID(user_dbname)).
else
   {&OK} = yes.

