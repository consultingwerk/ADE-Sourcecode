/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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





