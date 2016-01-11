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

File: _proserr.p

Description:
    Prints out an error message for the errors that come from OS
    functions.

Input Parameters: 
    
	n	 The number
        filename The file.
        verb     The verb to be added to the message. It should
                 be in the past tense. Ex "deleted"
        extra    Any additional text you want to display with the error.
    
Output Parameters:
   
	none

Author: D. Lee

Date Created: 1993

----------------------------------------------------------------------------*/

define input parameter error_num  as integer.
define input parameter filename   as character.
define input parameter verb       as character.
define input parameter extra_text as character.

define variable l1 as character.
define variable l2 as character.

/*
 * Build the base of the error message.
 */

l1 = filename + " cannot be " + verb + ".".

/*
 * Don't print out anything if there is no error
 */

case error_num:

	when  0 then return.
	when  1 then l2 = "You are not the owner of the file.".
        when  2 then l2 = "There is no such file or directory.".
        when  3 then l2 = "There is an interrupted system call.".
        when  4 then l2 = "There is an I/O error.".
	when  5 then l2 = "There is a bad file number.".
        when  6 then l2 = "There are no more processes.".
        when  7 then l2 = "There is not enough core memory.".
        when  8 then l2 = "Permission has been denied.".
        when  9 then l2 = "There is a bad address.".
	when 10 then l2 = "The file already exisl2.".
        when 11 then l2 = "There is no such device.".
        when 12 then l2 = "It is not a directory.".
        when 13 then l2 = "It is a directory.".
        when 14 then l2 = "There is a file table overflow.".
        when 15 then l2 = "There are too many files open.".
        when 16 then l2 = "The file is too large.".
        when 17 then l2 = "The is no space left on the device.".
        when 18 then l2 = "The directory is not empty.".
        otherwise 
		l2 = "Unmapped error number: " + string(error_num,"ddd"). 
end case.

message l1 skip l2 skip extra_text  view-as alert-box warning buttons ok.

