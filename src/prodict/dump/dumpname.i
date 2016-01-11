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

File: prodict/dump/dumpname.i

Description:
    checkes and eventually transformes a name into a valid unique 
    dumpname
    
Text-Parameters:
    none

Objects changed:
    nam         INPUT:  dump-name estimation
                OUTPUT: valid, unique dump-name
                    
Included in:
    prodict/dump/_lodname.p
    prodict/dump/_lod_fil.p
    

Author: Tom Hutegger

History:
    hutegger    94/05/23    creation
    Mario B     99/02/12    BUG 98-12-17-030 stop LC() on dumpname.  
    
--------------------------------------------------------------------*/
/*h-*/
/*--------------------------------------------------------------------
needs the following variables defined:

DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
--------------------------------------------------------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

  nam = SUBSTRING(nam,1,8,"character").
  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
 
    IF CAN-FIND(_File WHERE _File._Db-recid = drec_db
                        AND _Dump-name = nam  
              AND  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")) THEN
      ASSIGN pass = 1 /*ABSOLUTE(_File-num)*/
             nam  = SUBSTRING(nam + "-------"
                      ,1
                      ,8 - LENGTH(STRING(pass),"character")
                      ,"character"
                      )
                       + STRING(pass).

    DO pass = 1 TO 9999 WHILE 
        CAN-FIND(_File WHERE _File._Db-recid = drec_db
                         AND _Dump-name = nam
                         AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")):      
      ASSIGN nam = SUBSTRING(nam + "-------"
                   ,1
                   ,8 - LENGTH(STRING(pass),"character")
                   ,"character"
                   )
                   + STRING(pass).
    END.
  END.
  ELSE DO:
    IF CAN-FIND(_File WHERE _File._Db-recid = drec_db
                        AND _Dump-name = nam) THEN
      ASSIGN pass = 1 /*ABSOLUTE(_File-num)*/
             nam  = SUBSTRING(nam + "-------"
                      ,1
                      ,8 - LENGTH(STRING(pass),"character")
                      ,"character"
                      )
                       + STRING(pass).

    DO pass = 1 TO 9999 WHILE CAN-FIND(_File WHERE _File._Db-recid = drec_db
                                               AND _Dump-name = nam):      
      ASSIGN nam = SUBSTRING(nam + "-------"
                   ,1
                   ,8 - LENGTH(STRING(pass),"character")
                   ,"character"
                   )
                   + STRING(pass).
    END.
  END.

/*------------------------------------------------------------------*/
