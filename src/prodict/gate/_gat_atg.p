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
