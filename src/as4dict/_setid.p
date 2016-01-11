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


File: _setid.p

Description:
   Set p_Id to the recid of the _File record for the current table (if 
   p_ObjType is TBL) or to the _File record that domains are associated with
   (if p_ObjType is DOM).

Input Parameter:
   p_ObjType - the type of object (DB or TBL or DOM)

Output Parameter:
   p_Id - The place to store the record Id 

Author: Laura Stern

Date Created: 02/07/92 

     Modified to work with PROGRESS/400 Data Dictionary 
     
     06/26/97 D. McMann Changed for logical db name problem 97-06-06-029
     05/04/99 D. McMann Added stored procedure support
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}

Define input parameter p_ObjType as integer.
Define output parameter p_Id as recid.


if p_ObjType = {&OBJ_DB} then
do: 
   find _db where _db._db-name = Ldbname("as4dict") no-error.
   if available _db then assign p_Id = RECID(_db).
   else assign p_Id = ?.
end.
ELSE IF p_ObjType = {&OBJ_TBL} then DO:
  find as4dict.p__File where as4dict.p__File._File-name = s_CurrTbl NO-ERROR.      
      	       	       
/* Save the recid of p__file. Also, save the _for-number into a global to
    be used in lieu of s_TBLRecId.  */

   If available as4dict.p__file then  
     ASSIGN p_Id = RECID(as4dict.p__File)
            s_TblForNo = as4dict.p__file._For-number.           
end.
ELSE IF p_ObjType = {&OBJ_PROC} then DO:
  find as4dict.p__File where as4dict.p__File._File-name = s_CurrProc NO-ERROR.      
      	       	       
/* Save the recid of p__file. Also, save the _for-number into a global to
    be used in lieu of s_TBLRecId.  */

   If available as4dict.p__file then  
     ASSIGN p_Id = RECID(as4dict.p__File)
            s_ProcForNo = as4dict.p__file._For-number.           
end.


