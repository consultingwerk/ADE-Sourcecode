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

/* dumpv5df - Data Dictionary dump definitions module */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE STREAM chg.

run adecomm/_setcurs.p ("WAIT").
OUTPUT STREAM chg TO VALUE(user_env[2]) NO-ECHO NO-MAP.

FOR EACH _File
  WHERE _File._Db-recid = drec_db
   AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
   AND (
     IF user_filename = "ALL" THEN
       _File._File-number > 0
     ELSE
     IF user_filename = "SOME" THEN
       CAN-DO(user_env[1],_File._File-name)
     ELSE
       RECID(_File) = drec_file)
  BREAK BY _File._File-num:

  EXPORT STREAM chg "NEW-FILE   "
    _File-Name _Can-Create _Can-Read _Can-Write _Can-Delete
    SUBSTRING(_File._Desc,1,72)
    SUBSTRING(_File._Valexp,1,72)
    _Valmsg _Frozen _Hidden _Db-lang _Dump-name.

  FOR EACH _Field OF _File BY _Field-rpos:
    EXPORT STREAM chg "NEW-FIELD  "
      _Field-Name _Data-Type _Decimals _Format _Initial _Label _Mandatory
      _Order _Field._Can-Read _Field._Can-Write _Extent _Valexp _Valmsg
      _Help _Field._Desc _Col-label _Fld-case.
  END.
  PUT STREAM chg UNFORMATTED "." SKIP.

  FOR EACH _Index OF _File:
    /* dont print the default index */
    IF _File._dft-pk AND _File._Prime-Index = RECID(_Index) THEN NEXT.
    EXPORT STREAM chg "NEW-INDEX  " _Index-Name _Unique _active.
    FOR EACH _Index-Field OF _Index:
      FIND _Field OF _Index-Field.
      EXPORT STREAM chg "INDEX-FIELD"
        _Index-Seq _Field-Name _Ascending _Abbreviate.
    END.
    PUT STREAM chg UNFORMATTED "." SKIP.
  END.
  PUT STREAM chg UNFORMATTED "." SKIP.

  IF NOT _File._dft-pk THEN DO:
    FIND _Index WHERE _File._Prime-Index = RECID(_Index).
    EXPORT STREAM chg "PRIMARY    " _Index-Name.
  END.
  PUT STREAM chg UNFORMATTED "." SKIP.

END. /* for each file ... */

OUTPUT STREAM chg CLOSE.
run adecomm/_setcurs.p ("").
MESSAGE "Dump Completed." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.
