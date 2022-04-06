/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dmpbulk.p - Make .fd file for _proutil -C bulkload 

   D. McMann 04/09/03 Added logic for LOB Directory
   fernando  12/12/07 Handle large list of tables.

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.
DEFINE VARIABLE i             AS INT     NO-UNDO.
DEFINE VARIABLE j             AS INT     NO-UNDO.
DEFINE VARIABLE l             AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttNames NO-UNDO
    FIELD NAME AS CHAR
    INDEX NAME NAME.

DEFINE STREAM bulk.

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

/* copy items from the list of tables to work with to temp-table */
/* this is to handle a long list of table names */
IF user_filename = "SOME" THEN DO:
    IF NOT isCpUndefined AND user_env[1] = "" THEN DO:
        ASSIGN l = YES
               j = NUM-ENTRIES(user_longchar).
    END.
    ELSE
        j = NUM-ENTRIES(user_env[1]).
    
    REPEAT i = 1 TO j.
        CREATE ttNames.
        ttNames.NAME = (IF l THEN ENTRY(i,user_longchar) ELSE ENTRY(i,user_env[1])).
        RELEASE ttNames.
    END.
END.

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
            IF user_filename NE "SOME" THEN
               RECID(_File) = drec_file
            ELSE TRUE )
    BREAK BY _File._File-num:

    /* check if this is not a table we want. Can't use LONGCHAR in where clause
       or CAN-DO. That's why I am using a temp-table here.
    */
    IF user_filename = "SOME" AND 
       NOT CAN-FIND(FIRST ttNames WHERE ttNames.NAME = _File._File-name) THEN 
       NEXT.

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

ASSIGN user_env[1] = "".
IF NOT isCpUndefined THEN
    user_longchar = "".

PUT STREAM bulk UNFORMATTED "# end-of-file" SKIP.
OUTPUT STREAM bulk CLOSE.
IF TERMINAL <> "" THEN 
  run adecomm/_setcurs.p ("").

IF TERMINAL <> "" THEN
  MESSAGE "Making of bulk load description file completed."
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

RETURN.
