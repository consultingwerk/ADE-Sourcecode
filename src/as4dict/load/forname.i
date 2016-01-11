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

/* as4dict/load/forname.i
   Donna L. McMann
   September 30, 1997

   Include to verify that an underscore is not present in the _For-Format   
   when RPG/400 length names are to be generated.
   
*/

lngth = LENGTH(nam).

do i = 1 to lngth:
    if asc(substring(nam,i,1)) = 95  THEN
         assign nam = substring(nam, 1, i - 1) + substring(nam,i + 1).   
end.     

/* Make sure we don't have a duplicate out there.  */

IF CAN-FIND(FIRST as4dict.p__File WHERE as4dict.p__File._For-Format = nam) THEN
  ASSIGN pass = 1
         nam  = SUBSTRING(nam,1,8 - LENGTH(STRING(pass))).
 

DO pass = 2 TO 9999 WHILE 
  CAN-FIND(FIRST as4dict.p__File WHERE as4dict.p__File._For-Format = nam):
     ASSIGN pass = 1
            nam  = SUBSTRING(nam,1,8 - LENGTH(STRING(pass))).
END.




