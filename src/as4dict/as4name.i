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

DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.

UPDATE aname.
assign lngth = LENGTH(aname).
do i = 1 to lngth:
  if i = 1 then do:
    if (asc(substring(aname,i,1)) >= 64 AND  asc(substring(aname,i,1)) <= 90)  OR
         (asc(substring(aname,i,1)) >= 97 AND asc(substring(aname,i,1)) <= 122)  OR
         (asc(substring(aname,i,1)) >= 35 AND asc(substring(aname,i,1)) <= 36)  THEN.
         else
           assign aname = "A" + substring(aname,2).
   end.
   else do:
     if (asc(substring(aname,i,1)) >= 64 AND asc(substring(aname,i,1)) <= 90)  OR
         (asc(substring(aname,i,1)) >= 97 AND asc(substring(aname,i,1)) <= 122)  OR
         (asc(substring(aname,i,1)) >= 35 AND asc(substring(aname,i,1)) <= 36)  OR
         (asc(substring(aname,i,1)) = 44) OR
         (asc(substring(aname,i,1)) = 46) THEN.
         else
         assign aname = substring(aname, 1, i - 1) + "_" + substring(aname,i + 1).
     end.    
 end.     
 display aname.
