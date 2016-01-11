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

File: prodict/user/_usrinf3.p

Description:
    gets collation- and codepage-name of current DB
    
Input-Parameters:
    p_currdb        name of current DB
        
Output-Parameters:
    p_collname      collation-name of current db
    p_codepage      codepage-name of current db
    
    
History:
    hutegger    94/06/13    creation
    McMann      10/17/03  Add NO-LOCK statement to _Db find in support of on-line schema add
    
--------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_currdbn  AS character.
DEFINE INPUT  PARAMETER p_currdbt  AS character.
DEFINE OUTPUT PARAMETER p_codepage AS character.
DEFINE OUTPUT PARAMETER p_collname AS character.

/*------------------------------------------------------------------*/

if p_currdbt = "PROGRESS"
  then find first DICTDB._db where DICTDB._db._db-name = ?         NO-LOCK no-error.         
  else find first DICTDB._db where DICTDB._db._db-name = p_currdbn NO-LOCK no-error.         
if available DICTDB._Db
  then assign 
    p_codepage = DICTDB._Db._Db-xl-name
    p_collname = DICTDB._Db._Db-coll-name.               
  else assign 
    p_codepage = ""
    p_collname = "".               


/*------------------------------------------------------------------*/
