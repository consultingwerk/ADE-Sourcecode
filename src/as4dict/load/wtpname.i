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

/*--------------------------------------------------------------------

File: as4dict/load/wtpname.i

Description:
    checkes and eventually transformes a name into a valid unique 
    as4-name
    
Text-Parameters:
    none

Objects changed:
    nam         INPUT:  as4-name estimation
                OUTPUT: valid, unique as4-name
                    
Included in:
    as4dict/load/_lodnfil.p
    

Author: Donna McMann

    mcmann      95/12/01    Modified as4name.i for DB2/400 V7 Utilities
    mcmann      97/10/01    Added logic for RPG/400 Length Names
    
--------------------------------------------------------------------*/

/*--------------------------------------------------------------------
needs the following variables defined:

DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.
--------------------------------------------------------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* Make sure the name is a valid for  AS400 */   

assign lngth = LENGTH(nam). 
if lngth > 10 THEN lngth = 10.  

do i = 1 to lngth:
  if i = 1 then do:
    if (asc(substring(nam,i,1)) >= 64 AND  asc(substring(nam,i,1)) <= 90)  OR
         (asc(substring(nam,i,1)) >= 97 AND asc(substring(nam,i,1)) <= 122)  OR
         (asc(substring(nam,i,1)) >= 35 AND asc(substring(nam,i,1)) <= 36)  THEN.
         else
           assign nam = "A" + substring(nam,2).
   end.
   else do:
     if (asc(substring(nam,i,1)) >= 64 AND asc(substring(nam,i,1)) <= 90)  OR
         (asc(substring(nam,i,1)) >= 97 AND asc(substring(nam,i,1)) <= 122)  OR
         (asc(substring(nam,i,1)) >= 35 AND asc(substring(nam,i,1)) <= 36)  OR   
         (asc(substring(nam,i,1)) >= 48 AND asc(substring(nam,i,1)) <= 57)  OR
         (asc(substring(nam,i,1)) = 44) OR
         (asc(substring(nam,i,1)) = 46) THEN.
         else
         assign nam = substring(nam, 1, i - 1) + "_" + substring(nam,i + 1).
     end.    
 end.     

/* before checking make sure that if RPG/400 name, get rid of underscores */
IF user_env[29] = "yes" THEN DO:
   do i = 1 to lngth:
      if asc(substring(nam,i,1)) = 95  THEN
           assign nam = substring(nam, 1, i - 1) + substring(nam,i + 1).   
   end.  
   IF LENGTH(nam) > 8 THEN 
     ASSIGN lngth = 8
            nam = substring(nam,1,8).
   ELSE         
     ASSIGN lngth = LENGTH(nam). 

  /* Make sure we don't have a duplicate out there.  */
   IF (CAN-FIND(wtp__File WHERE wtp__File._AS4-File = nam) OR 
       CAN-FIND(wtp__Index WHERE wtp__Index._As4-File = nam)) THEN DO:
      ASSIGN pass = 1
             nam  = SUBSTRING(nam,1,lngth - LENGTH(STRING(pass)))
                     + STRING(pass).
   END.

   DO pass = 2 TO 9999 WHILE 
            CAN-FIND(wtp__File WHERE wtp__File._AS4-File = nam) OR
            CAN-FIND(wtp__Index WHERE wtp__Index._As4-File = nam):
                 
       ASSIGN nam = SUBSTRING(nam,1,lngth - LENGTH(STRING(pass)))
                   + STRING(pass).
   END.
END.
ELSE DO:
   IF (CAN-FIND(wtp__File WHERE wtp__File._AS4-File = nam) OR 
       CAN-FIND(wtp__Index WHERE wtp__Index._As4-File = nam)) THEN DO:
    ASSIGN
      pass = 1
      nam  = SUBSTRING(nam + "_______",1,10 - LENGTH(STRING(pass)))
           + STRING(pass).
    END.

  DO pass = 2 TO 9999 WHILE 
            CAN-FIND(wtp__File WHERE wtp__File._AS4-File = nam) OR
            CAN-FIND(wtp__Index WHERE wtp__Index._As4-File = nam):
                 
    ASSIGN nam = SUBSTRING(nam + "_______",1,10 - LENGTH(STRING(pass)))
               + STRING(pass).
  END.
END.

/*------------------------------------------------------------------*/



