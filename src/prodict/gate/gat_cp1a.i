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

File: prodict/gate/gat_cp1a.i

Description:
    
    Used for syb10; (in the future could be used for any DataServer type
    that allows setting of foreign db code page)
     
    Assigns the code-page to the _DB record and assigns the foreign name 
    of the code page to _DB-misc2[8]. 
     
Text-Parameters:
       {&incpname}   name if input code page        

Included-in
    _gat_cp1.p
    _usrschg.p

Author: Christine Semeniuk

History:
    Semeniuk    94/08/19    creation
    
--------------------------------------------------------------------*/        
        if {&incpname} = ? or {&incpname} = "<internal defaults apply>" then
        assign _Db._Db-xl-name = ?
               _Db._Db-misc2[8] = ?.
        else 
           if INDEX ({&incpname}, "/") > 0 then do: 
              assign _Db._Db-xl-name = SUBSTRING ({&incpname}, 1,
                              (INDEX ({&incpname}, "/") - 1))
                    _Db._Db-misc2[8] =  SUBSTRING ({&incpname},  
                              INDEX ({&incpname}, "/") + 1).
              if _Db._Db-misc2[8] = "" then _Db._Db-misc2[8] = ?.     
           end.  /* INDEX ({&incpname}, "/") > 0 */ 
        else
           assign _Db._Db-xl-name = {&incpname}
                  _Db._Db-misc2[8] = ?.      
      
/*------------------------------------------------------------------*/





