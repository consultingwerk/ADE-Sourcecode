/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _lodname.p - assigns unique dump-names to file w/o them
 
 History:  _Db recid was not being used in finds added drec_db vairable
           which is used thoughout the dictionary.  D. McMann  05/26/00
 */

DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.

DEFINE SHARED VARIABLE drec_db AS RECID  NO-UNDO.

/* when pulling oracle schema we could have two db's with the same
 * table-name (distributed dbs...). We result in one table named
 * <name> and the other named <name>-1. To make sure, their dump-names
 * are corresponding, we first try to assing the dump-names to the
 * tables with _fil-misc2[8] = ? (:= local-db). In the second-step we
 * assign dump-names to all the rest (:= distributed db's when ORACLE,
 * or do-never-loop for non-oracle-db's)
 */
 

FOR EACH _File
  WHERE   _Dump-name    =    ?
    AND  _db-recid = drec_db
  AND NOT _File-name  BEGINS "_"
  AND     _Fil-misc2[8] =    ?:
    
    IF INTEGER(DBVERSION("DICTDB")) > 8 
      AND(_File._Owner<> "PUB" AND _File._Owner <>"_FOREIGN") THEN NEXT.
      
    assign nam = _File-name.
    {prodict/dump/dumpname.i}
    assign _Dump-name = nam.

END.

FOR EACH _File
  WHERE   _Dump-name    =    ?
    AND _db-recid = drec_db
  AND NOT _File-name  BEGINS "_"
  BY      _Fil-misc2[8]:

    IF INTEGER(DBVERSION("DICTDB")) > 8 
      AND (_File._Owner<> "PUB" AND _File._Owner <>"_FOREIGN") THEN NEXT.
      
    assign nam = _File-name.
    {prodict/dump/dumpname.i}
    assign _Dump-name = nam.

END.

RETURN.


