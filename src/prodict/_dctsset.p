/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/* called from _usrsget.p, used with _dctsget.p */
/* ----------------------------------------------------------------------
File:   prodict/_dctsset.p

Description:
    1. sets drec_db to the currently selected _Db-record and sets
       dict_rog for this db
    2. issues a message if db-type is not supported by the current
       executable
    3. Reads file-list into cache

Input Parameters:
    none
    
Output Parameters:
    none

history:
        95/07    hutegger   Prefixed _Db with DICTDB
        07/09/98 D. McMann  Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                            to _File Finds
        D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS
        fernando  06/12/06 Support for int64
---------------------------------------------------------------------- */
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE INPUT PARAMETER nam AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */

DEFINE VARIABLE istrans  AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */
DEFINE VARIABLE i        AS INTEGER NO-UNDO.
DEFINE VARIABLE l_hidden AS LOGICAL NO-UNDO.
DEFINE VARIABLE hBuffer  AS HANDLE  NO-UNDO.

/* ------------------------------------------------------------------- */

DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
  end.

/* --- Check to see if dictionary is called from within Fast Track --- */

DO i = 1 TO i + 1
  WHILE PROGRAM-NAME(i) <> ?
  AND   NOT fast_track:
  fast_track = ( "ft.p" 
               = SUBSTRING(PROGRAM-NAME(i)
                          ,MAXIMUM(1
                                  ,LENGTH(PROGRAM-NAME(i)) - 3
                                  )
                          ,-1
                          ,"character"
                          )
               ).
  end.


/* -------------------- set drec_db and dict_rog --------------------- */

find DICTDB._Db WHERE DICTDB._Db._Db-name = nam NO-LOCK.
assign
  drec_db  = RECID(DICTDB._Db)
  dict_rog = 
      istrans  /* cannot change dict if called from w/i a trans */
      OR PROGRESS = "Query"    /* or used with query product    */
      OR PROGRESS = "Run-Time" /* or used with run-time product */
      OR fast_track            /* or called from within Fast Track */
      OR CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")). /* or read-only DB */

/* (los 12/27/94) */
if NOT CAN-DO(DATASERVERS, DICTDB._Db._Db-type)
 then MESSAGE
    "This module does not support connections to this Data Server type."
    view-as alert-box.


/* check if this is a 10.1B db at least, so that we complain about int64 and
   int64 values. If the 'Large Keys' feature is not known by this db, then this
   is a pre-101.B db 
*/
ASSIGN  is-pre-101b-db = YES.

IF INTEGER(DBVERSION("DICTDB")) >= 10 THEN DO:
    /* use a dyn buffer since v9 db's don't have the feature tbl */
    CREATE BUFFER hBuffer FOR TABLE "DICTDB._Code-feature" NO-ERROR.
    IF VALID-HANDLE(hBuffer) THEN DO:
       hBuffer:FIND-FIRST('where _Codefeature_Name = "Large Keys"',NO-LOCK) NO-ERROR.
       IF hBuffer:AVAILABLE THEN
           is-pre-101b-db = NO.
       DELETE OBJECT hBuffer.
    END.

END.


/* -------------------- recreate file-list cache --------------------- */

find first DICTDB._File 
  where DICTDB._File._Db-recid  = drec_db 
  and   DICTDB._File._File-name = user_filename
  AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
   no-lock no-error.
assign l_hidden = ( available DICTDB._File
                    and DICTDB._File._Hidden = TRUE).

run prodict/_dctcach.p 
  ( INPUT l_hidden
  ).

/* ------------------------------------------------------------------- */

