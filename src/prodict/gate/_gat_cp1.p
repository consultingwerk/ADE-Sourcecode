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

File: prodict/gate/_gat_cp1.i

Description:
    
    assignes the new code-page to the _Db-record; and, to ensure
    the changes in the initial-values, assigns "" to them in every
    field 
            
Input-Parameters:
    none

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    user_env[5]     code-page                            if new-value
    
Author: Tom Hutegger

History:
    hutegger    94/04/21    creation
    mcmann      00/03/00    Changed frame definition and added pause 2 for
                            use to be able to see message.
    
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

form
  " Applying the changes to the schema holder. " skip
  "                            Please wait ... "
  with overlay centered row 5
  frame msg VIEW-AS DIALOG-BOX THREE-D.
  
/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

find _Db
  where _Db._Db-name = user_dbname
  no-error.
if not available _Db 
 then do:  /* */
  /* should actually never be */
  end.     /* */

 else do:  /* _db available */
  
  run adecomm/_setcurs.p ("WAIT").
  assign SESSION:IMMEDIATE-DISPLAY = yes.
  view frame msg.

  if ( _DB._Db-type = "SYB10" or _DB._Db-type = "MSSQLSRV")
    then do:
        { prodict/gate/gat_cp1a.i 
              &incpname = "user_env[5]" }
    end.
  else assign _Db._Db-xl-name = user_env[5].

  if  _Db._Db-xl-name =  ?
   or _Db._Db-xl-name = "?"
   then do:
    find first _File of _Db 
      WHERE (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") no-error.
    if available _File
     then find first _Field of _File no-error.
    if available _Field
     then assign _Field._Initial = _Field._Initial + "".
    end.
   else for each _File of _Db:
    for each _Field of _File:
      assign _Field._initial = _Field._initial + "".
      end.
    end.
  PAUSE 2 NO-MESSAGE.  
  hide frame msg no-pause.
  run adecomm/_setcurs.p ("").
  
  end.     /* _db available */
      
/*------------------------------------------------------------------*/













