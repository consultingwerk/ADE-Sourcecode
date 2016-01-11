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

