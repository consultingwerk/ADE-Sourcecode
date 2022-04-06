/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/_gat_atg.p

Description:
    
    To solve the fldpos-problem we delete all triggers and recreate
    them new. Thios gets done by prodict/ism/_ism_trg.p.
    There are some places in the GUI-Dict, where we need to do this
    for all tables of an _Db. That's what this routine does.
    
Input-Parameters:
    p_db-pname      physical db-name
    
Author: Tom Hutegger

History:
    hutegger    94/08/18    creation
    McMann      01/17/03  Add NO-LOCK statement to _Db find in support of on-line schema add
    
--------------------------------------------------------------------*/        
/*h-*/

define INPUT parameter p_db-name   as   CHARACTER.

find first _Db where _Db._Db-name = p_db-name NO-LOCK no-error.

if available _Db
 then for each _File of _Db WHERE (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"):

  RUN prodict/gate/_gat_trg.p (RECID(_File)).
  
  end.
  
/*------------------------------------------------------------------*/        
