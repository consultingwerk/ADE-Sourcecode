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

/* _dmpbulk.p - Make .fd file for _proutil -C bulkload 

   D. McMann 04/09/03 Added logic for LOB Directory

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE STREAM bulk.

IF TERMINAL <> "" THEN 
  run adecomm/_setcurs.p ("WAIT").
OUTPUT STREAM bulk TO VALUE(user_env[2]) NO-MAP.

PUT STREAM bulk UNFORMATTED
  "# Database:  " PDBNAME("DICTDB") SKIP
  "# Date/Time: " STRING(YEAR(TODAY),"9999")
    "/" STRING(MONTH(TODAY),"99")
    "/" STRING(DAY(TODAY),"99")
    "-" STRING(TIME,"HH:MM:SS") SKIP.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
  FOR EACH _File
    WHERE _File._Db-recid = drec_db
      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
      AND (IF user_filename = "ALL" THEN
            _File._File-number > 0 AND
             _File._Tbl-Type <> "V"
           ELSE
            IF user_filename = "SOME" THEN
              CAN-DO(user_env[1],_File._File-name)
            ELSE
             RECID(_File) = drec_file)
    BREAK BY _File._File-num:

    HIDE MESSAGE NO-PAUSE.
    IF TERMINAL <> "" THEN MESSAGE "Working on" _File._File-name.
    IF CAN-FIND(FIRST _Field OF _File WHERE _Field._Data-type = "BLOB" OR
                                            _Field._Data-type = "CLOB") THEN
      PUT STREAM bulk UNFORMATTED
        _File._File-name " "
        (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".d "
        (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".e "
        user_env[30]
        SKIP.
    ELSE
       PUT STREAM bulk UNFORMATTED
        _File._File-name " "
        (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".d "
        (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".e"
        SKIP.


    FOR EACH _Field OF _File BY _Field._Order:
      IF _sys-field OR _Data-type = "recid" THEN NEXT.
      PUT STREAM bulk UNFORMATTED "  " _Field-name SKIP.
    END.

    IF NOT LAST(_File._File-num) THEN
      PUT STREAM bulk UNFORMATTED "." SKIP.

END. /* for each _file in V9 */
ELSE  
   FOR EACH _File
    WHERE _File._Db-recid = drec_db
      AND (IF user_filename = "ALL" THEN
            _File._File-number > 0 AND
             _File._Tbl-Type <> "V"
           ELSE
            IF user_filename = "SOME" THEN
              CAN-DO(user_env[1],_File._File-name)
            ELSE
             RECID(_File) = drec_file)
    BREAK BY _File._File-num:

    HIDE MESSAGE NO-PAUSE.
    IF TERMINAL <> "" THEN MESSAGE "Working on" _File._File-name.

    PUT STREAM bulk UNFORMATTED
      _File._File-name " "
      (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".d "
      (IF _File._Dump-name = ? THEN _File._File-name ELSE _File._Dump-name) ".e"
      SKIP.

    FOR EACH _Field OF _File BY _Field._Order:
      IF _sys-field OR _Data-type = "recid" THEN NEXT.
      PUT STREAM bulk UNFORMATTED "  " _Field-name SKIP.
    END.

    IF NOT LAST(_File._File-num) THEN
      PUT STREAM bulk UNFORMATTED "." SKIP.

  END. /* for each _file in version < 9 */


PUT STREAM bulk UNFORMATTED "# end-of-file" SKIP.
OUTPUT STREAM bulk CLOSE.
IF TERMINAL <> "" THEN 
  run adecomm/_setcurs.p ("").

IF TERMINAL <> "" THEN
  MESSAGE "Making of bulk load description file completed."
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

RETURN.
