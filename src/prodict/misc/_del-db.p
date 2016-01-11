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

/* Procedure prodict/misc/_del-db.p
   Created:  12/07/99 D. McMann
   Procedure to clean up schema holder when the ProToxxx has failed
   and the user is returned to the original screen to fix whatever
   was wrong.
   
   Used by prodict/ora/protoora.p
           prodict/odb/protoodb.p
           
*/   

DEFINE INPUT PARAMETER fdb_dbname AS CHARACTER.
DEFINE INPUT PARAMETER sh_dbname  AS CHARACTER.
DEFINE INPUT PARAMETER pro_dbname   AS CHARACTER.

  FIND DICTDB._db where DICTDB._db._db-name = LDBNAME(fdb_dbname) EXCLUSIVE-LOCK.
  IF AVAILABLE _Db THEN DO:
    IF CONNECTED (_Db._Db-name) THEN
      DISCONNECT VALUE(_Db._Db-name).
      
    FOR EACH _File OF _Db EXCLUSIVE-LOCK:
       FOR EACH _Index OF _File EXCLUSIVE-LOCK:
         FOR EACH _index-field OF _Index EXCLUSIVE-LOCK:
             DELETE _Index-field.
         END.
         DELETE _index.
       END.
       FOR EACH _FIELD OF _File EXCLUSIVE-LOCK:
         DELETE _Field.
       END.
       DELETE _File.
    END.
    FOR EACH _SEQUENCE OF _Db EXCLUSIVE-LOCK:
      DELETE _Sequence.
    END.
    DELETE _Db. 
    DISCONNECT VALUE(sh_dbname).
    CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).
  END.
 
