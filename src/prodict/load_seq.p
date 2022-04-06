/**********************************************************************
* Copyright (C) 2000,2006-2007 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/* load_seq.p - load _Sequence file from _Seqvals.d and set w/ CURRENT-VALUE

   History: Mario B  01/27/99  Created
            D. McMann 08/08/02 Eliminated any sequences whose name begins "$" - Peer Direct
            fernando  09/21/06 Eliminated use of user_env from generated pcode - 20060921-032
            fernando  07/23/07 Support for 64-bit sequences
   
*/

&SCOPED-DEFINE ErrFile load_seq.e

{ prodict/dictvar.i NEW}
{ prodict/user/uservar.i NEW}

DEFINE NEW SHARED STREAM s_err.

DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.

DEFINE VARIABLE cerror    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage  AS CHARACTER           NO-UNDO init "UNDEFINED".
DEFINE VARIABLE i         AS INTEGER             NO-UNDO.
DEFINE VARIABLE lvar      AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#     AS INTEGER             NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE err-file  AS CHARACTER           NO-UNDO.

FIND DICTDB._Db NO-LOCK NO-ERROR.
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
FIND FIRST DICTDB._File OF DICTDB._Db WHERE
   DICTDB._File._Db-recid     = RECID(DICTDB._Db) AND
   DICTDB._File._Owner = "PUB" OR
   DICTDB._File._Owner = "_FOREIGN"
NO-LOCK NO-ERROR.
ELSE 
FIND FIRST DICTDB._File of DICTDB._Db WHERE
     DICTDB._File._Db-recid = RECID(DICTDB._Db)
NO-LOCK NO-ERROR.

ASSIGN 
  dot-d-dir                 = ( if dot-d-dir matches "*" + "/"
                                or dot-d-dir matches "*" + ".d"
                                or dot-d-dir    =    ""
                                then dot-d-dir 
                                else dot-d-dir + "/"
                              )
 
  drec_db     = RECID(_Db)
  user_dbname = if _Db._Db-name = ? THEN LDBNAME("DICTDB")
                                    ELSE _Db._Db-Name
  user_dbtype = if _Db._Db-name = ? THEN DBTYPE("DICTDB")
                                    ELSE _Db._Db-Type
  err-file    = IF file-name matches "*.d" THEN
                   substring(file-name, 1, r-index(file-name, ".d")) + "e"
		ELSE
		   "{&ErrFile}".
		      
/* This effectively tests for the existence of the directory, creates it if  *
 * it doesn't exist, aborts if it can't create it.                           */
OS-CREATE-DIR VALUE(dot-d-dir). 
IF OS-ERROR <> 0 THEN
DO:
   PUT UNFORMATTED "Input directory " + dot-d-dir + " doesn't exist." SKIP.
   RETURN ERROR.
END.

/* Get rid of any previous error files if they exist */
OS-DELETE VALUE(dot-d-dir + err-file).

/* Test for existence of file */
IF SEARCH(dot-d-dir + file-name) = ? THEN
DO:
  OUTPUT STREAM s_err TO VALUE(dot-d-dir + err-file).
  PUT STREAM s_err UNFORMATTED "File " + file-name + " doesn't exist." SKIP.
  OUTPUT STREAM s_err CLOSE.
  RETURN ERROR. 
END.

user_env[2] = dot-d-dir + file-name. 
RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(tmpfile) NO-MAP NO-ECHO NO-MAP.

PUT UNFORMATTED
  'DEFINE INPUT PARAMETER fName     AS CHARACTER.' SKIP
  'DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER.' SKIP
  'DEFINE INPUT PARAMETER errorFile AS CHARACTER.' SKIP
  'DEFINE SHARED STREAM s_err.' SKIP
  'DEFINE VARIABLE seqname   AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE seqnumber AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE seqvalue  AS INT64     NO-UNDO.' SKIP
  'REPEAT:' SKIP
  '  IMPORT seqnumber seqname seqvalue NO-ERROR.' SKIP
  '  IF ERROR-STATUS:ERROR THEN DO:' SKIP
  '     OUTPUT STREAM s_err TO VALUE(dot-d-dir + "/" + errorFile) APPEND.' SKIP 
  '     PUT STREAM s_err UNFORMATTED "Error loading value for " seqname ": "' SKIP
  '         ERROR-STATUS:GET-MESSAGE(1) SKIP.' SKIP
  '     OUTPUT STREAM s_err CLOSE.' SKIP
  '  END.' SKIP
  '  IF INDEX(seqname,".") = 0 THEN seqname = "' LDBNAME(user_dbname)
    '." + seqname.' SKIP
  '  CASE seqname:' SKIP.
FOR EACH _Sequence WHERE _Sequence._Db-recid = drec_db 
                     AND NOT _Sequence._Seq-name BEGINS "$" NO-LOCK:
  PUT UNFORMATTED 
    '    WHEN "' LDBNAME(user_dbname) '.' _Sequence._Seq-Name '" THEN DO:' SKIP
    '      CURRENT-VALUE(' _Sequence._Seq-Name ',' LDBNAME(user_dbname)
      ') = seqvalue NO-ERROR.' SKIP
      '     IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 1 THEN DO:' SKIP
      '       OUTPUT STREAM s_err TO VALUE(dot-d-dir + "/" + errorFile) APPEND.' SKIP 
      '       PUT STREAM s_err UNFORMATTED "Error loading value for ' _Sequence._Seq-Name ': "' SKIP
      '         ERROR-STATUS:GET-MESSAGE(1) SKIP.' SKIP
      '       OUTPUT STREAM s_err CLOSE.' SKIP
      '     END.' SKIP
      SKIP
      'END.' SKIP.
END.
PUT UNFORMATTED
  '    OTHERWISE DO:' SKIP
  '       OUTPUT STREAM s_err TO VALUE(dot-d-dir + "/" + errorFile) APPEND.' SKIP 
  '       PUT STREAM s_err UNFORMATTED fName " had a value of " SKIP' SKIP 
  '           seqvalue " for " seqname SKIP' SKIP
  '           "but no sequence was found with a matching name." SKIP(1).' SKIP
  '       OUTPUT STREAM s_err CLOSE.' SKIP
  '    END.' SKIP
  '  END CASE.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.
OUTPUT CLOSE.

{prodict/dump/lodtrail.i
  &file    = user_env[2]
  &entries = " " 
  }  /* read trailer, sets variables: codepage and cerror */

IF codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? THEN
   ASSIGN cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".

IF cerror = ? THEN
DO:  /* conversion needed but NOT possible */
  OS-DELETE VALUE(tmpfile).
  OUTPUT STREAM s_err TO VALUE(dot-d-dir + err-file) APPEND.
  PUT UNFORMATTED "Codepage conversion error. Sequence values NOT loaded.".
  OUTPUT STREAM s_err CLOSE.
END.     /* conversion needed but NOT possible */
ELSE DO:  /* conversion not needed OR needed and possible */  

  if cerror = "no-convert"
   then INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
               CONVERT SOURCE codepage TARGET SESSION:CHARSET.

  RUN VALUE(tmpfile) (INPUT user_env[2], INPUT dot-d-dir, INPUT err-file).

  INPUT CLOSE.

  OS-DELETE VALUE(tmpfile). 

END.     /* conversion not needed OR needed and possible */

RETURN.
