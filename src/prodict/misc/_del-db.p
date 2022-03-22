/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
 
