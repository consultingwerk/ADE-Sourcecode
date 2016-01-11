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


