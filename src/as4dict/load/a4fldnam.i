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

File: _A4Fldnam.i

Description:  Validate AS/400 Field Name in the Load process.  This is 
      the same validation as the the Progress/400 Dictionary, so changes
      should be made in both places.

Modified 10/21/97 Changed to handle RPG Length Names DLM
------------------------------------------------------------------------------*/      


/* Make sure the name is a valid for  AS400 */   
assign nlngth = LENGTH(A4FldNam).        
IF nlngth > 10 THEN 
    ASSIGN nlngth = 10
           A4FldNam = SUBSTRING(A4FldNam,1,10).

do j = 1 to nlngth:
  if j = 1 then do:
    if (asc(substring(A4FldNam,j,1)) >= 64 AND  asc(substring(A4FldNam,j,1)) <= 90)  OR
         (asc(substring(A4FldNam,j,1)) >= 97 AND asc(substring(A4FldNam,j,1)) <= 122)  OR
         (asc(substring(A4FldNam,j,1)) >= 35 AND asc(substring(A4FldNam,j,1)) <= 36)  THEN.
         else
           assign A4FldNam = "A" + substring(A4FldNam,2).
   end.
   else do:
     if (asc(substring(A4FldNam,j,1)) >= 64 AND asc(substring(A4FldNam,j,1)) <= 90)  OR
         (asc(substring(A4FldNam,j,1)) >= 97 AND asc(substring(A4FldNam,j,1)) <= 122)  OR
         (asc(substring(A4FldNam,j,1)) >= 35 AND asc(substring(A4FldNam,j,1)) <= 36)  OR   
         (asc(substring(A4FldNam,j,1)) >= 48 AND asc(substring(A4FldNam,j,1)) <= 57)  OR
         (asc(substring(A4FldNam,j,1)) = 44) OR
         (asc(substring(A4FldNam,j,1)) = 46) THEN.
         else
         assign A4FldNam = substring(A4FldNam, 1, j - 1) + "_" + substring(A4FldNam,j + 1).
     end.    
 end.     
IF user_env[29] = "yes" then do:
   do j = 1 to nlngth:
      if asc(substring(A4FldNam,j,1)) = 95  THEN
           assign A4FldNam = substring(A4FldNam, 1, j - 1) + substring(A4FldNam,j + 1).   
   end.  
   IF LENGTH(A4FldNam) > 6 THEN
    ASSIGN nlngth = 6
           A4FldNam = SUBSTRING(A4FldNam,1,6). 
   ELSE
     ASSIGN nlngth = LENGTH(A4FldNam).
END.     

 /* Check for duplicate Field Name  */
 if imod = "a" then do:
 
   if can-find(as4dict.p__field where as4dict.p__field._As4-file = As4filename
              and as4dict.p__field._As4-library = as4dict.p__File._AS4-Library
              and as4dict.p__field._For-Name = A4Fldnam) then do:

/* If we generated the field name, just generate a different one.  If the
   user supplied it, notified them that the name is different.  */
      if generated_name then do:
        if user_env[29] = "no" THEN DO:
           ASSIGN pass = 1
                  A4Fldnam = SUBSTRING(A4Fldnam + "_______",1,10 - LENGTH(STRING(pass)))
                             + STRING(pass).
 
           DO pass = 2 TO 9999 
            WHILE can-find(as4dict.p__field where as4dict.p__field._As4-file = as4dict.p__file._As4-file 
                                        and as4dict.p__field._As4-library = as4dict.p__File._AS4-Library                  
                                        and as4dict.p__field._For-Name = A4Fldnam):
                    
                  ASSIGN A4Fldnam = SUBSTRING(A4Fldnam + "_______",1,10 - LENGTH(STRING(pass)))
                                    + STRING(pass).
           end.
        end.
        else do:
           ASSIGN pass = 1
                  A4Fldnam = SUBSTRING(A4Fldnam,1,nlngth - LENGTH(STRING(pass)))
                             + STRING(pass).
 
           DO pass = 2 TO 9999 
            WHILE can-find(as4dict.p__field where as4dict.p__field._As4-file = as4dict.p__file._As4-file 
                                        and as4dict.p__field._As4-library = as4dict.p__File._AS4-Library                  
                                        and as4dict.p__field._For-Name = A4Fldnam):
                    
              ASSIGN A4Fldnam = SUBSTRING(A4Fldnam ,1,nlngth - LENGTH(STRING(pass)))
                                    + STRING(pass).
           end.
        end.             
     end.
     else
        ierror = 43. /* "AS400 Field Name already exists in File" */         
   end.  /* if can-find */
 end.  /* if imod = "a"  */


