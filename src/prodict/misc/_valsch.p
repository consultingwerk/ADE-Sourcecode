/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _valsch.p

Description:
   Validates DataServer selections for a schema holder for delta.df
   and the logical database selected within the schema holder.

Input Parameters:
   ds_shname    - Schema holder database name
   ds_dbname    - Logical database name in schema holder database
   user-dbtype  - Logical database type
   shdb-id      - RECID of schema holder database
   dictdb-id    - RECID of DICTDB/DICTDB2 database
   errcode      - Reason code for failure. 

Author: David Moloney

Date Created: 05/08/13

----------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER ds_alias    AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER ds_shname   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ds_dbname   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER user-dbtype AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER shdb-id     AS RECID     NO-UNDO.
DEFINE OUTPUT       PARAMETER dictdb-id   AS RECID     NO-UNDO.
DEFINE OUTPUT       PARAMETER errcode     AS INTEGER   NO-UNDO.

DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
DEFINE VARIABLE hBuf          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQ            AS HANDLE    NO-UNDO.
DEFINE VARIABLE idfld         AS HANDLE    NO-UNDO.

shdb-id = ?.
dictdb-id = ?.
errcode = 0.

/* DICTDB/DICTDB2 references not always known to caller, so running dynamic db requests */ 

CREATE BUFFER hBuf FOR TABLE ds_alias + "._Db". 

/* RECID of compare database */
IF ds_shname <> ? THEN DO:
  IF ds_shname = SDBNAME(ds_alias) THEN DO:
    IF VALID-HANDLE(hBuf) THEN 
      hBuf:FIND-FIRST('WHERE ' + ds_alias + '._Db._Db-type = ' + QUOTER("PROGRESS"), NO-LOCK) NO-ERROR.
    IF hBuf:AVAILABLE THEN
      shdb-id = hBuf:RECID.
  END.
  ELSE
    errcode = 1. /* Schema holder database not set properly */
END.

CREATE QUERY hQ.
hQ:SET-BUFFERS(hBuf).

IF user-dbtype = "" THEN DO:

  hQ:QUERY-PREPARE("FOR EACH " + ds_alias + "._Db WHERE " + ds_alias + "._Db._Db-type <> " + QUOTER("PROGRESS")).
  hQ:QUERY-OPEN().

  REPEAT:
    hQ:GET-NEXT().
    IF hQ:QUERY-OFF-END THEN LEAVE.
    IF ds_dbname = "" THEN DO:
      ds_dbname = hBuf:BUFFER-FIELD("_Db-name"):BUFFER-VALUE().
      user-dbtype = hBuf:BUFFER-FIELD("_Db-type"):BUFFER-VALUE().
    END.
    ELSE DO: /* If there are more than one non-progress dbs */
      ds_dbname = "". /* Reset to empty */
      user-dbtype = "". 
      errcode = 3.
    END.
  END.
  IF user-dbtype = "" AND errcode = 0 THEN
    user-dbtype = "PROGRESS". /* Revert back to PROGRESS if there were no non-progress logical dbs */

  hQ:QUERY-CLOSE().
END.

IF user-dbtype = "" OR CAPS(ds_dbname) = CAPS("<none>") THEN 
  user-dbtype = "PROGRESS". /* With no foreign schemas, revert to original Progress schema incremental dump */
ELSE DO:

  hQ:QUERY-PREPARE("FOR EACH " + ds_alias + "._Db WHERE " + ds_alias + "._Db._Db-type = " + QUOTER(user-dbtype)).
  hQ:QUERY-OPEN().

  REPEAT:
    hQ:GET-NEXT().
    IF hQ:QUERY-OFF-END THEN LEAVE.
    IF hBuf:BUFFER-FIELD("_Db-name"):BUFFER-VALUE() = ds_dbname THEN DO:
      IF ds_shname <> SDBNAME(ds_dbname) THEN DO: /* Sanity check */
        errcode = 2. /* Logical schema is attached to wrong schema holder */
        RETURN.
      END.
      ELSE 
        dictdb-id = hBuf:RECID.
    END.
  END.
  hQ:QUERY-CLOSE().

END.

if dictdb-id = ? AND CAPS(ds_dbname) <> CAPS("<none>") THEN errcode = 4.

DELETE OBJECT hQ.

hBuf:BUFFER-RELEASE().
DELETE OBJECT hBuf.
