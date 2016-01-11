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
/*history
   D. McMann 04/11/01 Added warning for SQL Table Updates ISSUE 310


*/

{ prodict/dump/loaddefs.i NEW }
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

&IF DEFINED(SKP)
&THEN
  /* Don't do anything.  It's defined already */
&ELSE
   &SCOPED-DEFINE SKP SKIP
&ENDIF

define new shared temp-table s_ttb_fake-cp
    field   db-name     as character
    field   db-recid    as recid.
    
DEFINE VARIABLE error_text AS CHARACTER EXTENT 50 NO-UNDO.
assign
  error_text[ 1] = "Unknown action":t72
  error_text[ 2] = "Unknown object":t72
  error_text[ 3] = "Try to modify unknown &2":t72
  error_text[ 4] = "Unknown &2 keyword":t72
  error_text[ 5] = "Try to modify &2 without table":t72
  error_text[ 6] = "Cannot change dbtype":t72
  error_text[ 7] = "&2 already exists with name &3":t72
  error_text[ 8] = "Field being deleted is part of primary index":t72
  error_text[ 9] = "Index already deleted":t72
  error_text[10] = "Cannot change datatype of existing field":t72
  error_text[11] = "Cannot change extent of existing field":t72
  error_text[12] = "Cannot add index field to existing index":t72
  error_text[13] = "Cannot find field to index":t72
  error_text[14] = "Cannot alter field from frozen table":t72
  error_text[15] = "Use SQL ALTER TABLE to change field":t72
  error_text[16] = "Cannot &1 frozen table &3":t72
  error_text[17] = "Use SQL DROP TABLE to remove &3":t72
  error_text[18] = "Cannot rename SQL table":t72
  error_text[19] = "VIEW exists with name &3":t72
  error_text[20] = "Cannot &1 &2 referenced in SQL view":t72
  error_text[21] = "Cannot delete database with tables":t72
  error_text[22] = "Cannot remove last non-word index":t72
  error_text[23] = "Invalid table attribute":t72
  error_text[24] = "Invalid collate/translate table format":t72
  error_text[25] = "Invalid PROGRESS-recid column":t72
  error_text[26] = "Invalid Shadow column":t72
  error_text[27] = "Incompatible translation table version - Load will be terminated":t72
  error_text[28] = "Load will be terminated":t72
  error_text[29] = "Load unsuccessful - backing out":t72
  error_text[30] = "Table-type mismatch. Current database-type is &1":t72 /* ^F: [30] */
                  /*....+....1....+....2....+....3....+....4....+....5....+....6....+....7..*/
  error_text[31] = "AREA NAME either not found in database or not type d (data).":t72
  error_text[32] = "CODEPAGE-NAME in the .df file is different from the db's current":t72
  error_text[33] = "codepage. To change the latter use the AdminTool for DataServers":t72
  error_text[34] = "or PROUTIL for PROGRESS. This .df file can't be loaded.":t72
  error_text[43] = "Field-position and file-size don't match. File-size is too small.":t72
  error_text[44] = "Please use Dictionary to set the codepage for this database.":t72
  error_text[50] = "" /* DO NOT USE.  If ierror is 50, then it's a warning */
.

DEFINE VARIABLE warn_text AS CHARACTER EXTENT 50 NO-UNDO.
ASSIGN
  warn_text[23] = "Can't change Can-read or write, Mandatory, or Decimals of field in SQL table." 
  warn_text[24] = "Can't change case-sensitivity of ""&1""  because it is part of an index.":t72
  warn_text[25] = "SQL client cannot access fields having widths greater than 31995.  ":t72
  warn_text[26] = "The width of the field ""&1"" in the .df file is &2.  ":t72
  warn_text[27] = "Use data dictionary Adjust SQL width utility to correct width.":t72
.

DEFINE NEW SHARED STREAM loaderr.
DEFINE VARIABLE dbload-e AS CHARACTER NO-UNDO.
DEFINE VARIABLE hdr         AS INTEGER INIT 0 NO-UNDO.

DEFINE VARIABLE scrap       AS CHARACTER NO-UNDO.

DEFINE VARIABLE cerror      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage    AS CHARACTER           NO-UNDO init "UNDEFINED".
DEFINE VARIABLE i           AS INTEGER             NO-UNDO.
DEFINE VARIABLE j           AS INTEGER             NO-UNDO.
DEFINE VARIABLE w           AS INTEGER             NO-UNDO.
DEFINE VARIABLE k           AS INTEGER             NO-UNDO.
DEFINE VARIABLE iobj        AS CHARACTER           NO-UNDO. /* d,t,f,i */
DEFINE VARIABLE inot        AS LOGICAL             NO-UNDO.
DEFINE VARIABLE inum        AS INTEGER             NO-UNDO.
DEFINE VARIABLE l_fld-stlen AS INTEGER             NO-UNDO. /* foreign dbs... */
DEFINE VARIABLE l_fld-stoff AS INTEGER             NO-UNDO. /* foreign dbs... */
DEFINE VARIABLE lvar        AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#       AS INTEGER             NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL             NO-UNDO init true.
DEFINE VARIABLE sav_dbnam   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_dbtyp   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_err     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_drec    AS RECID               NO-UNDO.
DEFINE VARIABLE xerror      AS LOGICAL             NO-UNDO. /* any error during process? */
DEFINE VARIABLE xwarn       AS LOGICAL             NO-UNDO. /* any warnings during process? */
DEFINE VARIABLE do-commit   AS LOGICAL             NO-UNDO.

/* collate/translate information */
DEFINE VARIABLE ct_version AS CHARACTER NO-UNDO.                /* version # */
DEFINE VARIABLE ct_changed AS LOGICAL   NO-UNDO INIT no.  /* tables modified? */
DEFINE VARIABLE ix         AS INTEGER   NO-UNDO. /* for parsing version # */
DEFINE VARIABLE len        AS INTEGER   NO-UNDO. /* ditto */
DEFINE VARIABLE raw_val    AS RAW       NO-UNDO.
DEFINE VARIABLE orig_vers  AS RAW       NO-UNDO.

define variable minimum-index as integer initial 0.
define variable new-number    as integer initial 0.
 
/* messages for frames working2 and backout. */
DEFINE VARIABLE msg1       AS CHARACTER NO-UNDO FORMAT "x(53)":u.
DEFINE VARIABLE msg2       AS CHARACTER NO-UNDO FORMAT "x(56)":u.
DEFINE VARIABLE msg3       AS CHARACTER NO-UNDO FORMAT "x(12)":u.
DEFINE VARIABLE msg4       AS CHARACTER NO-UNDO FORMAT "x(16)":u.
msg1="Phase 1 of Load completed.  Working.  Please wait ...".
msg2="Error occured during load.  Press OK to back out transaction.".
msg3="Please check".
msg4="for load errors and/or warnings.".

FORM
  wdbs._Db-name    LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  wfil._File-name  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  wfld._Field-name LABEL "Field"    COLON 11 FORMAT "x(32)":u SKIP
  widx._Index-name LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  wseq._Seq-Name   LABEL "Sequence" COLON 11 FORMAT "x(32)":u SKIP
  HEADER 
    " Loading Definitions.  Press " +
    KBLABEL("STOP") + " to terminate load process." format "x(70)" 
  WITH FRAME working 
  ROW 4 CENTERED USE-TEXT SIDE-LABELS ATTR-SPACE &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D TITLE "Load Data Definitions" &ENDIF.

COLOR DISPLAY MESSAGES
  wdbs._Db-name wfil._File-name wfld._Field-name
  widx._Index-name wseq._Seq-Name
  WITH FRAME working.

FORM
  msg1 VIEW-AS TEXT NO-LABELS WITH FRAME working2 CENTERED USE-TEXT. 

FORM
  msg2 VIEW-AS TEXT NO-LABELS WITH FRAME backout CENTERED USE-TEXT.

FORM
 msg3 dbload-e msg4 VIEW-AS TEXT NO-LABELS WITH FRAME errorlog CENTERED USE-TEXT.

/*=======================Internal Procedures===========================*/

PROCEDURE Put_Header:

 DEFINE INPUT PARAMETER efile_nam AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER hdr_cnt AS INTEGER NO-UNDO.
 IF hdr_cnt = 0 THEN DO:
   IF user_env[6] = "f" OR user_env[6] = "b" THEN DO:
     OUTPUT STREAM loaderr TO VALUE(efile_nam) APPEND.
     PUT STREAM loaderr UNFORMATTED SKIP(2)
     "The following errors and/or warnings occurred while loading " user_env[2] SKIP
     "into database " LDBNAME("DICTDB") " on " TODAY " at " STRING(TIME,"HH:MM")
 "." SKIP(1).
     hdr_cnt = 1.
     OUTPUT STREAM loaderr CLOSE.
   END.
 END.

END. /* PROCEDURE Put_Header */

/*-----------------------------------------------------
   Show an error.  if p_cmd = "prev" it means the
   error occurred when flushing data for the previous
   command and we no longer have the error command
   in ilin.  if p_cmd = "curr", it means ilin still
   contains the command which caused the error.
   imod and iobj however, always pertain to the 
   error command.
------------------------------------------------------*/
PROCEDURE Show_Error:
  DEFINE INPUT PARAMETER p_cmd AS CHAR NO-UNDO.

  DEFINE VAR msg AS CHAR    NO-UNDO INIT "".
  DEFINE VAR ix  AS INTEGER NO-UNDO.

  IF ierror = 50 THEN
  DO:
     RUN Show_Warning (INPUT p_cmd).
     RETURN.
  END.
  
  scrap = (if imod = "cp":u then "ADD/MODIFY":u
      else if imod = "a":u  then "ADD":u
      else if imod = "m":u  then "MODIFY":u
      else if imod = "r":u  then "RENAME":u
      else if imod = "d":u  then "DELETE":u
      else "?":u)
    + " ":u
    + (if     iobj begins "cp":u then "DATABASE ":u + 
               substring(iobj,3,-1,"character")
      else if iobj    =   "d":u  then "DATABASE ":u + 
               (if wdbs._Db-name    = ? then "" else wdbs._Db-name)
      else if iobj    =   "t":u  then "TABLE ":u    + 
               (if wfil._File-name  = ? then "" else wfil._File-name)
      else if iobj    =   "f":u  then "FIELD ":u    + 
               (if wfld._Field-name = ? then "" else wfld._Field-name)
      else if iobj    =   "i":u  then "INDEX ":u    + 
               (if widx._Index-name = ? then "" else widx._Index-name)
      else if iobj    =   "s":u  then "SEQUENCE ":u + 
               (if wseq._Seq-Name   = ? then "" else wseq._Seq-Name)
      else "? ?":u).
  IF user_env[6] = "f" THEN DO:
  OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

  if p_cmd = "curr" then DO:
    msg = "** Line " + STRING(ipos).
    DO ix = 1 to 9:
      msg = msg + (if ilin[ix] <> ? then " " + ilin[ix] else "").
      end.
    end.

  if user_env[6] = "f"
   then do:  /* output only to file */
    if  ierror <= 31
     OR ierror >  42 then DO:
      if msg = ""
       then
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** Error during " scrap " **" SKIP(1)
         SUBSTITUTE(error_text[ierror],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
       else
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** Error during " scrap " **" SKIP(1)
         msg SKIP(1)
         SUBSTITUTE(error_text[ierror],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
     END.  
    else /* if ierror <= 42
     then */ 
       PUT STREAM loaderr UNFORMATTED
       SKIP(1) "** Error during" scrap "**"           SKIP(1)
       error_text[ierror]                     {&SKP}
       error_text[ierror + 1]                 {&SKP} 
       error_text[ierror + 2].
    end.     /* output only to file */
   END.

   else if user_env[6] = "s" then do: /* output only with alert-boxes */

    if  ierror <= 31
     OR ierror >  42 then
      if msg = ""
       then MESSAGE 
          "** Error during" scrap "**" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       else MESSAGE 
          "** Error during" scrap "**" SKIP(1)
          msg SKIP(1) 
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    else /* if ierror <= 42
     then */ MESSAGE
        "** Error during" scrap "**"           SKIP(1)
        error_text[ierror]                     {&SKP}
        error_text[ierror + 1]                 {&SKP} 
        error_text[ierror + 2] 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    end.     /* output only with alert-boxes */
    
   else if user_env[6] = "b" then do:  /* output to both file and alert-boxes */
  OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    if  ierror <= 31
     OR ierror >  42
     then DO:
      if msg = ""
       then do: MESSAGE
          "** Error during" scrap "**" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** Error during " scrap " **" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1
).
        end.
       else do: MESSAGE
          "** Error during" scrap "**" SKIP(1)
          msg SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** Error during " scrap " **" SKIP(1)
          msg SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1
).
        end.
      end.
    else /* if ierror <= 42
     then */do:
        MESSAGE
        "** Error during" scrap "**"           SKIP(1)
        error_text[ierror]                     {&SKP}
        error_text[ierror + 1]                 {&SKP}
        error_text[ierror + 2]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        PUT STREAM loaderr UNFORMATTED
        SKIP(1) "** Error during " scrap " **"           SKIP(1)
        error_text[ierror]                     {&SKP}
        error_text[ierror + 1]                 {&SKP}
        error_text[ierror + 2] SKIP(1).
      end.

    end.     /* output to both file and alert-boxes */

  assign xerror = true.

  OUTPUT STREAM loaderr CLOSE.

END PROCEDURE. /* Show_Error */

/* Show warning */
/* CAUTION:::::::::::::::::::::::::::::::::::::::::::::::::::::::
 * This procedure is nearly identical to Show_Error.  Be careful to modify
 * the correct one or both as necessary.
 */
PROCEDURE Show_Warning:
  DEFINE INPUT PARAMETER p_cmd AS CHAR NO-UNDO.

  DEFINE VAR msg AS CHAR    NO-UNDO INIT "".
  DEFINE VAR ix  AS INTEGER NO-UNDO.

  scrap = (if imod = "cp":u then "ADD/MODIFY":u
      else if imod = "a":u  then "ADD":u
      else if imod = "m":u  then "MODIFY":u
      else if imod = "r":u  then "RENAME":u
      else if imod = "d":u  then "DELETE":u
      else "?":u)
    + " ":u
    + (if     iobj begins "cp":u then "DATABASE ":u + 
               substring(iobj,3,-1,"character")
      else if iobj    =   "d":u  then "DATABASE ":u + 
               (if wdbs._Db-name    = ? then "" else wdbs._Db-name)
      else if iobj    =   "t":u  then "TABLE ":u    + 
               (if wfil._File-name  = ? then "" else wfil._File-name)
      else if iobj    =   "f":u  then "FIELD ":u    + 
               (if wfld._Field-name = ? then "" else wfld._Field-name)
      else if iobj    =   "i":u  then "INDEX ":u    + 
               (if widx._Index-name = ? then "" else widx._Index-name)
      else if iobj    =   "s":u  then "SEQUENCE ":u + 
               (if wseq._Seq-Name   = ? then "" else wseq._Seq-Name)
      else "? ?":u).
  IF user_env[6] = "f" THEN DO:
  OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

  if p_cmd = "curr" then DO:
    msg = "** Line " + STRING(ipos).
    DO ix = 1 to 9:
      msg = msg + (if ilin[ix] <> ? then " " + ilin[ix] else "").
      end.
    end.

  if user_env[6] = "f"
   then do:  /* output only to file */
    if  iwarn <= 24 then DO:
      if msg = ""
       then
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** " scrap " caused a warning **" SKIP(1)
         SUBSTITUTE(warn_text[iwarn],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
       else
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** " scrap " caused a warning **" SKIP(1)
         msg SKIP(1)
         SUBSTITUTE(warn_text[iwarn],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
     END.  
    else /* if iwarn >= 25
     then */ 
       PUT STREAM loaderr UNFORMATTED
       SKIP(1) "** " scrap " caused a warning **"           SKIP(1)
       warn_text[iwarn]                     {&SKP}
       warn_text[iwarn + 1]                 {&SKP} 
       warn_text[iwarn + 2].
    end.     /* output only to file */
   END.

   else if user_env[6] = "s" then do: /* output only with alert-boxes */

    if  iwarn <= 24  then
      if msg = ""
       then MESSAGE 
          "**" scrap "caused a warning **" SKIP(1)
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
       else MESSAGE 
          "**" scrap "caused a warning **" SKIP(1)
          msg SKIP(1) 
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    else /* if iwarn >= 25
     then */ MESSAGE
        "**" scrap "caused a warning **"           SKIP(1)
        warn_text[iwarn]                     {&SKP}
        warn_text[iwarn + 1]                 {&SKP} 
        warn_text[iwarn + 2] 
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.

    end.     /* output only with alert-boxes */
    
   else if user_env[6] = "b" then do:  /* output to both file and alert-boxes */
  OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    if  iwarn <= 24
     then DO:
      if msg = ""
       then do: MESSAGE
          "**" scrap "caused a warning **" SKIP(1)
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** " scrap " caused a warning **" SKIP(1)
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1
).
        end.
       else do: MESSAGE
          "**" scrap "caused a warning **" SKIP(1)
          msg SKIP(1)
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** " scrap " caused a warning **" SKIP(1)
          msg SKIP(1)
          SUBSTITUTE(warn_text[iwarn],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1
).
        end.
      end.
    else /* if iwarn >= 25
     then */do:
        MESSAGE
        "**" scrap "caused a warning **"           SKIP(1)
        warn_text[iwarn]                     {&SKP}
        warn_text[iwarn + 1]                 {&SKP}
        warn_text[iwarn + 2]
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.

        PUT STREAM loaderr UNFORMATTED
        SKIP(1) "** " scrap " caused a warning **"           SKIP(1)
        warn_text[iwarn]                     {&SKP}
        warn_text[iwarn + 1]                 {&SKP}
        warn_text[iwarn + 2] SKIP(1).
      end.

    end.     /* output to both file and alert-boxes */

  assign xwarn = true.
  
  OUTPUT STREAM loaderr CLOSE.

END PROCEDURE. /* Show_Warnings */

/*-----------------------------------------------------
   Load one of the translation or collate tables.
   
   Input Parameter:
      p_Dbfield - the name of the database field to
                               load.
------------------------------------------------------*/
PROCEDURE Load_Tran_Collate_Tbl:

  DEFINE INPUT PARAMETER p_Dbfield AS CHAR NO-UNDO.

  DEFINE VARIABLE changed AS LOGICAL NO-UNDO.

   IMPORT ilin.
   ipos = ipos + 1.

   RUN prodict/dump/_lod_raw.i (INPUT ct_version, OUTPUT changed)
                                              p_Dbfield 256 RECID(wdbs).
   ct_changed = ct_changed OR changed.

   ilin[1] = ?.  /* so we do a new import the next time around */
  end.


/*==========================Mainline Code==============================*/

/* Fix problems which resulted when .rcode is run on Japanese DOS/WIN, 640x480
   while the .r-code was compiled/created with US fonts/Progress.ini
   Increase the frame size a little bit. 
*/
if session:pixels-per-column = 6 AND session:width-pixels = 640 then
DO:
   FRAME working2:WIDTH-CHARS = FRAME working2:WIDTH-CHARS + msg1:column + 2.
   FRAME backout:WIDTH-CHARS = FRAME backout:WIDTH-CHARS + msg2:column + 2.
   FRAME errorlog:WIDTH-CHARS = FRAME errorlog:WIDTH-CHARS + msg3:column + dbload-e:column + msg4:column + 2.
  end.
       
assign
  cache_dirty = TRUE
  user_dbname = user_env[8]. /* for backwards compatibility with _lodsddl.p */

do for _Db:
  find first _Db
    where _Db._Db-name = ( if user_dbtype = "PROGRESS":u
                             then ?
                             else user_dbname
                         )
    NO-ERROR.
  assign
    drec_db      = RECID(_Db)
    drec_file    = ?
    sav_dbnam    = user_dbname
    sav_dbtyp    = user_dbtype
    sav_drec     = drec_db
    ierror       = 0
    ilin         = ?
    ipos         = 0
    gate_dbtype  = user_dbtype
    gate_proc    = ""
    do-commit    = (IF user_env[15] = "yes" THEN TRUE ELSE FALSE).
  end.
  
/* Set up the name of the procedure to call to get stdtype info */
if gate_dbtype <> "PROGRESS" then DO:
  {prodict/dictgate.i 
     &action=query 
     &dbtype=gate_dbtype 
     &dbrec =? 
     &output=scrap
     }
  gate_proc = "prodict/" + ENTRY(9,scrap) + "/_" + ENTRY(9,scrap) + "_typ.p".
  end.

ASSIGN dbload-e = LDBNAME("DICTDB") + ".e".

/***** Don't need this right now...
{prodict/dump/lodtrail.i
  &entries = " "
  &file    = "user_env[2]"
  }  /* read trailer, sets variables: codepage and cerror */
*/
assign codepage = if user_env[10] = ""
                    then "UNDEFINED"
                    else user_env[10]. /* set in _usrload.p */
if codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? then
   assign cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
else assign cerror = "no-convert".

if cerror = ?
 then DO:  /* conversion needed but NOT possible */

  RUN adecomm/_setcurs.p ("").
  assign user_env[4] = "error". /* to signal error to _usrload */

  end.     /* conversion needed but NOT possible */

 else do for _Db, _file, _Field, _Index, _Index-field transaction:
          /* conversion not needed OR needed and possible */

  /* Call _setcurs.p before INPUT is set.  setcurs does a "PROCESS EVENTS"
     which in not legal if the input stream is a file. */
  SESSION:IMMEDIATE-DISPLAY = yes.
  RUN adecomm/_setcurs.p ("WAIT").

  if cerror = "no-convert"
   then INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
              CONVERT SOURCE codepage TARGET SESSION:CHARSET.

/* to cheat scoping mechanism * /
  if FALSE then FIND NEXT _File.
  if FALSE then FIND NEXT _Field.
  if FALSE then FIND NEXT _Index. */
  if FALSE then FIND NEXT wdbs.
  if FALSE then FIND NEXT wfil.
  if FALSE then FIND NEXT wfld.
  if FALSE then FIND NEXT widx.
  if FALSE then FIND NEXT wseq.
  
  find first _Db where RECID(_Db) = drec_db.
  
  DO ON STOP UNDO, LEAVE:

    /* when IMPORT hits the end, it generates ENDKEY.  This is how loop ends */
    load_loop:
    REPEAT ON ERROR UNDO,RETRY ON ENDKEY UNDO, LEAVE:
  
      if ierror > 0 AND NOT inoerror then DO:
        RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
        RUN Show_Error ("curr").
        if user_env[4] BEGINS "y":u AND NOT ierror = 50
         then do:
          assign stopped = true.
          UNDO,LEAVE load_loop.
          end. 
        end.
      if ierror > 0 AND ierror <> 50 then
        assign
          ierror = 0
          imod   = ?
          iobj   = ?.
      ELSE
        ASSIGN ierror = 0.
  
      /* Pop the top token off the top and move all the other tokens up one 
         so that ilin[1] is the next token to process.
      */
      if ilin[1] <> ? then
        assign
            inum    = inum + (if CAN-DO("OF,ON":u,ilin[inum + 1]) then 2 else 0)
          ilin[1] = ilin[inum + 1]
          ilin[2] = ilin[inum + 2]
          ilin[3] = ilin[inum + 3]
          ilin[4] = ilin[inum + 4]
          ilin[5] = (if inum + 5 > 9 then ? else ilin[inum + 5])
          ilin[6] = (if inum + 6 > 9 then ? else ilin[inum + 6])
          ilin[7] = (if inum + 7 > 9 then ? else ilin[inum + 7])
          ilin[8] = (if inum + 8 > 9 then ? else ilin[inum + 8])
          ilin[9] = ?.
  
      /* if there's nothing of significant at the top of the array,
         read in the next line.  One token will go into each array element. 
      */
      DO WHILE ilin[1] BEGINS "#":u OR ilin[1] = "" OR ilin[1] = ?:
        assign
          ipos = ipos + 1
          ilin = ?.
        IMPORT ilin.
        end.
      inum = 0.
      assign stopped = true.
 
      if CAN-DO(
        "ADD,CREATE,NEW,UPDATE,MODifY,ALTER,CHANGE,DELETE,DROP,REMOVE,RENAME":u,
        ilin[1]) then DO:

        /* This is the start of a command - so copy the buffer values from 
             the last time through the loop into the database.
        */

        if available wdbs
         and imod <> ?
         then DO:
          RUN "prodict/dump/_lod_dbs.p".
          if drec_db <> RECID(_Db)
            then FIND _Db where RECID(_Db) = drec_db.
          end.
            
        if available wfil
         and imod <> ?
         then do:
          RUN "prodict/dump/_lod_fil.p".
          end.

        if available wfld and imod <> ? 
        then do:
          RUN "prodict/dump/_lod_fld.p"(INPUT-OUTPUT minimum-index).
        end.

        if available widx
         and imod <> ?
         then do:
          RUN "prodict/dump/_lod_idx.p"(INPUT-OUTPUT minimum-index).
          end.

        if available wseq
         and imod <> ?
         then RUN "prodict/dump/_lod_seq.p".
 
        /* Error occurred when trying to save data from last command */
        if ierror > 0 AND ierror <> 50 then DO:
          RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
          RUN Show_Error ("prev").
          if user_env[4] BEGINS "y":u then UNDO,LEAVE load_loop. 
          ierror = 0.
        end.
        ELSE IF ierror = 50 THEN DO:
         DO w = 1 TO NUM-ENTRIES(iwarnlst):
           ASSIGN iwarn = INTEGER(ENTRY(w, iwarnlst)).           
           IF iwarn = 23 THEN warn_text[23] = SUBSTITUTE(warn_text[23],wfld._Field-name,iarg).
           ELSE IF iwarn = 24 THEN warn_text[24] = SUBSTITUTE(warn_text[24],wfld._Field-name,iarg).
           ELSE LEAVE.
           RUN Show_error ("prev").
         END.
         ASSIGN ierror = 0.
        END.
  
        /* delete temp file contents to start anew for this command */
        for each wdbs: DELETE wdbs. end.
        for each wfil: DELETE wfil. end.
        for each wfit: DELETE wfit. end.
        for each wfld: DELETE wfld. end.
        for each wflt: DELETE wflt. end.
        for each widx: DELETE widx. end.
        for each wixf: DELETE wixf. end.
        for each wseq: DELETE wseq. end.
  
        assign
          icomponent = 0
          iprimary   = FALSE
          inoerror   = FALSE
          imod       = ?
          iobj       = ?
          inum       = 3.
    
          /* set the action mode */
        CASE ilin[1]:
          when "ADD":u    or when "CREATE":u or when "NEW":u  then imod = "a":u.
          when "UPDATE":u or when "MODifY":u or when "ALTER":u or when "CHANGE":u
                                                            then imod = "m":u.
          when "DELETE":u or when "DROP":u or when "REMOVE":u then imod = "d":u.
          when "RENAME":u                                     then imod = "r":u.
          end case.
    
        /* set the object type */
        CASE ilin[2]:
          when "DATABASE":u or when "CONNECT":u then iobj = "d":u.
          when "FILE":u     or when "TABLE":u   then iobj = "t":u.
          when "FIELD":u    or when "COLUMN":u  then iobj = "f":u.
          when "INDEX":u    or when "KEY":u     then iobj = "i":u.
          when "SEQUENCE":u                     then iobj = "s":u.
          end case.
        if iobj = "t"
          AND ilin[4] = "TYPE"
          AND gate_dbtype <> ilin[5]
          then DO:  /* table of foreign DB: type mismatch */
          assign
            error_text[30] = substitute(error_text[30],_Db._Db-type)
            ierror         = 30
            user_env[4]    = "yes". /* to prevent 2. error-message at end */ 
          CREATE wfil. /* to be used in show-error */
          RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
          RUN Show_Error ("curr").
          UNDO,LEAVE load_loop. /* no sense to continue */
          end.        /* table of foreign DB: type mismatch */
        
        if iobj = ? then DO:
          /* may be ADD [UNIQUE] [PRIMARY] [INACTIVE] INDEX name */
            if CAN-DO("INDEX,KEY":u,ilin[3]) then
            assign
              iobj    = "i":u
              ilin[3] = ilin[4]  /* set name into slot 3 */
              ilin[4] = ilin[2]. /* move other opt[s] to end */
          else
          if CAN-DO("INDEX,KEY",ilin[4]) then
            assign
              iobj    = "i"
              ilin[4] = ilin[3]  /* move other opt[s] to end */
              ilin[3] = ilin[5]  /* set name into slot 3 */
              ilin[5] = ilin[2]. /* move other opt[s] to end */
          else
          if CAN-DO("INDEX,KEY",ilin[5]) then
            assign
              iobj    = "i"
              ilin[5] = ilin[3]  /* move other opt[s] to end */
              ilin[3] = ilin[6]  /* set name into slot 3 */
              ilin[6] = ilin[2]. /* move other opt[s] to end */
          end.
  
        /* complain */
        if imod = ? then ierror = 1.  /* "Unknown action" */
        if iobj = ? then ierror = 2.  /* "Unknown object" */
        if ierror > 0 AND ierror <> 50 then UNDO,RETRY load_loop.
  
        /* Reinitialize the buffers.  e.g., for add set the name of the
           object.  For modify, copy the existing record into the buffer.
           if working on a field or index, find the corresponding _File
           record as well.
        */    
        if iobj = "d" then CREATE wdbs.
        if iobj = "t" then CREATE wfil.
        if iobj = "f" then CREATE wfld.
        if iobj = "i" then CREATE widx.
        if iobj = "s" then CREATE wseq.

        if iobj = "d" then DO: /* start database action block */
          if TERMINAL <> "" then 
            display
              (if ilin[3] = "?" then user_dbname else ilin[3]) @ wdbs._Db-name
              "" @ wfil._File-name  "" @ wfld._Field-name
              "" @ widx._Index-name "" @ wseq._Seq-Name
              WITH FRAME working.
          if imod = "a" then
            wdbs._Db-name = ilin[3].
          else DO:
            if ilin[3] = "?" then
              /* Comparing to the string value "?" fails whereas
                   comparing against the unknown value works.
              */
              find first _Db where _Db._Db-name = ? NO-ERROR.
            else
              find first _Db where _Db._Db-name = ilin[3] NO-ERROR.
            if NOT available _Db then DO:
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,RETRY load_loop.
              end.
              { prodict/dump/copy_dbs.i &from=_Db &to=wdbs }
            end.
          if available _Db then drec_db = RECID(_Db).

          end. /* end database action block */
  
        if iobj = "s" then DO: /* start sequence action block */
          if TERMINAL <> "" then 
            display 
              user_dbname @ wdbs._Db-name
              "" @ wfil._File-name  "" @ wfld._Field-name
              "" @ widx._Index-name ilin[3] @ wseq._Seq-Name
              WITH FRAME working.
          if imod = "a" then
            wseq._Seq-Name = ilin[3].
          else DO:
            find first _Sequence where _Sequence._Seq-Name = ilin[3] NO-ERROR.
            if NOT available _Sequence then DO:                       
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,RETRY load_loop.             
              end.                      
            { prodict/dump/copy_seq.i &from=_Sequence &to=wseq }
            end.
          end. /* end sequence action block */
  
        /* position _file record */
        if (iobj = "d" OR iobj = "s") OR (imod = "a" AND iobj = "t") then .
        else DO:
          scrap = ?.
          if iobj = "t"                   then scrap = ilin[3].
          else if CAN-DO("OF,ON",ilin[4]) then scrap = ilin[5].
          else if CAN-DO("OF,ON",ilin[5]) then scrap = ilin[6].
          else if CAN-DO("OF,ON",ilin[6]) then scrap = ilin[7].
          else if CAN-DO("OF,ON",ilin[7]) then scrap = ilin[8].
          if scrap = ? then .
          else
          if available _Db then DO:
            IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
              FIND _File OF _Db where _File._File-name = scrap 
                                  and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
            ELSE 
              FIND _File OF _Db where _File._File-name = scrap NO-ERROR.
          END.
          else DO:
            IF INTEGER(DBVERSION(user_dbname)) > 8 THEN
               FIND FIRST _File where _File._File-name = scrap 
                            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
            ELSE
               FIND FIRST _File where _File._File-name = scrap NO-ERROR.
          END.  
       
          if available _File AND NOT available _Db then DO:
            FIND _Db OF _File.
            drec_db = RECID(_Db).
            end.
          if scrap <> ? AND available _File then drec_file = RECID(_File).              
          end.
  
        if iobj = "t" then DO: /* start file action block */
          if TERMINAL <> "" then 
            display user_dbname @ wdbs._Db-name
                    ilin[3] @ wfil._File-name "" @ wfld._Field-name 
                    "" @ widx._Index-name "" @ wseq._Seq-Name
                      WITH FRAME working.
          if imod = "a" then
            wfil._File-name = ilin[3].
          else DO:
            if NOT available _File then DO:
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,RETRY load_loop.
              end.
            { prodict/dump/copy_fil.i &from=_File &to=wfil &all=true}
            for each _File-trig OF _File:
              CREATE wfit.
              { prodict/dump/copy_fit.i &from=_File-trig &to=wfit }
              end.
            end.
          end. /* end file action block */
  
        if iobj = "f" then DO: /* start field action block */
          if NOT available _File AND drec_file <> ? then
            FIND _File where drec_file = RECID(_File) NO-ERROR.
          if NOT available _File then DO:
            ierror = 5. /* "Try to modify &2 without file" */
            UNDO,RETRY load_loop.
          end.
          ELSE IF AVAILABLE _File AND _file._File-name <> ilin[5] THEN
            FIND _file WHERE _file._file-name = ilin[5]
                          AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
          if NOT available _File then DO:
            ierror = 5. /* "Try to modify &2 without file" */
            UNDO,RETRY load_loop.
          end.
          if TERMINAL <> "" then 
            display _File._File-name @ wfil._File-name
                                 ilin[3] @ wfld._Field-name 
                                 "" @ widx._Index-name
                    WITH FRAME working.
          if imod = "a" then
            assign
              wfld._Field-name = ilin[3]    
              wfld._Initial    = "". /* to be checkable in _lod_fld */
          else DO:
            FIND _Field OF _File where _Field._Field-name = ilin[3] NO-ERROR.
            if NOT available _Field then DO:
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,RETRY load_loop.
              end.
            { prodict/dump/copy_fld.i &from=_Field &to=wfld &all=true}
            for each _Field-trig OF _Field:
              CREATE wflt.
              { prodict/dump/copy_flt.i &from=_Field-trig &to=wflt }
              end.
            end.
          end. /* end field action block */
  
          if iobj = "i" then DO: /* start index action block */
            if NOT available _File AND drec_file <> ? then
              FIND _File where drec_file = RECID(_File) NO-ERROR.
            if NOT available _File then DO:
              ierror = 5. /* "try to modify index w/o file" */
              UNDO,RETRY load_loop.
            end.
            ELSE IF AVAILABLE _File THEN DO k = 4 TO 8:
              IF ilin[k] = "ON" THEN DO:
                IF _File._File-name <> ilin[k + 1] THEN DO:                  
                  FIND _File WHERE _File._file-name = ilin[k + 1] 
                               AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
                  ASSIGN k = 8.
                END.
              END.
            END.
            if NOT available _File then DO:
              ierror = 5.  /* "Try to modify &2 without file" */
              UNDO,RETRY load_loop.
            END.
         
            if TERMINAL <> "" then 
              display _File._File-name @ wfil._File-name
                                 "" @ wfld._Field-name
                    ilin[3] @ widx._Index-name 
                WITH FRAME working.
            if imod = "a" then
            assign
              widx._Index-name = ilin[3]
              widx._Unique     = FALSE. /* different from schema default of TRUE */
          else DO:
            FIND _Index OF _File where _Index._Index-name = ilin[3] NO-ERROR.
            if NOT available _Index then DO:
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,RETRY load_loop.
              end.
            { prodict/dump/copy_idx.i &from=_Index &to=widx }
            /*
            for each _Index-field OF _Index:
              CREATE wixf.
              { prodict/dump/copy_ixf.i &from=_Index-field &to=wixf }
              end.
          */
            end.
          end. /* end index action block */
  
        end. /* end of block handling action keyword */
  
    /* inot - is used for logical keywords that have no argument but where
              the keyword indicates the yes/no value of the field.
       inum - is the number of tokens (keyword plus arguments)  It is set to
              3 above when ilin[1] is the action word (e.g., ADD) and not
              one of the field values (e.g., DATA-TYPE Character)
       ikwd - is the keyword.
       iarg - is the field value.
    */
      if inum <> 3 then
        assign
          ikwd = ilin[1]
          iarg = ilin[2]
          inot = FALSE
          inum = 2
          inot = (ikwd BEGINS "NOT-")
          ikwd = SUBSTRING(ikwd, if inot then 5 else 1, -1, "character")
          inum = (if ikwd = "NO-ERROR"
               OR (iobj = "t" AND CAN-DO("FROZEN,HIDDEN",ikwd))
               OR (iobj = "f" AND CAN-DO("MAND*,NULL,NULL-A*,CASE-SENS*",ikwd))
               OR (iobj = "i" AND CAN-DO("UNIQUE,INACTIVE,PRIMARY,WORD",ikwd))
               then 1 else 2)
          iarg = (if inum = 2 then iarg else (if inot then "no" else "yes")).
  
    /* Load the value from the .df file into the appropriate field
       of the object we're working on.
    */
      if inum = 3 then .
      else if ikwd = "NO-ERROR" then inoerror = TRUE.
      else if imod = "r" AND ilin[1] = "TO" then irename = ilin[2].

      else if iobj = "d" then DO: /*------------- DB-CASE ----------------------*/
  
        CASE ikwd:
          when "DBNAME"  or when "ADDRESS"     then wdbs._Db-addr     = iarg.
          when "PARAMS"  or when "COMM"        then wdbs._Db-comm     = iarg.
          when "CONNECT" or when "DATABASE"    then wdbs._Db-name     = iarg.
          when "TYPE"                          then wdbs._Db-type     = iarg.
          when "DB-MISC11"                     then wdbs._Db-misc1[1] = INTEGER(iarg).
          when "DB-MISC12"                     then wdbs._Db-misc1[2] = INTEGER(iarg).
          when "DB-MISC13"                     then wdbs._Db-misc1[3] = INTEGER(iarg).
          when "DB-MISC14"                     then wdbs._Db-misc1[4] = INTEGER(iarg).
          when "DB-MISC15"                     then wdbs._Db-misc1[5] = INTEGER(iarg).
          when "DB-MISC16"                     then wdbs._Db-misc1[6] = INTEGER(iarg).
          when "DB-MISC17"                     then wdbs._Db-misc1[7] = INTEGER(iarg).
          when "DB-MISC18"                     then wdbs._Db-misc1[8] = INTEGER(iarg).
          when "DRIVER-NAME"                   then wdbs._Db-misc2[1] = iarg.
          when "DRIVER-VERS"                   then wdbs._Db-misc2[2] = iarg.
          when "ESCAPE-CHAR"                   then wdbs._Db-misc2[3] = iarg.
          when "DRIVER-CHARS"                  then wdbs._Db-misc2[4] = iarg.
          when "DBMS-VERSION"                  then wdbs._Db-misc2[5] = iarg.
          when "DSRVR-VERSION"                 then wdbs._Db-misc2[6] = iarg.
          when "PROGRESS-VERSION"              then wdbs._Db-misc2[7] = iarg.
          when "DSRVR-MISC"                    then wdbs._Db-misc2[8] = iarg.
          when "COLLATION-TRANSLATION-VERSION" then DO:
                /* Store the first part of the version e.g., 2.0 in collate[5].
                   The whole version format is m.n-x
                */
                  assign
                    ct_version = iarg
                    ix = INDEX(ct_version, "-").
                    orig_vers = wdbs._Db-collate[5].
                  if SUBSTR(ct_version, 1, ix - 1, "character") >= "5.0" then DO:
                    user_env[4] = "y". /* stop the load - db will be corrupted. */
                    ierror = 27.
                    end.
                  assign
                    ix = INDEX(ct_version, ".")
                    wdbs._Db-collate[5] = raw_val /* to replace ?, if there */
                    PUTBYTE(wdbs._Db-collate[5],1) = 
                      INTEGER(SUBSTR(ct_version, 1, ix - 1, "character"))
                    ix = ix + 1
                    len = INDEX(ct_version, "-") - ix
                    PUTBYTE(wdbs._Db-collate[5],2) = 
                      INTEGER(SUBSTR(ct_version, ix, len, "character")).
                  if orig_vers <> wdbs._Db-collate[5] then ct_changed = yes.
                  end.
          when     "TRANSLATION-NAME"   
           or when "CODEPAGE-NAME"            then wdbs._Db-xl-name = iarg.
          when "COLLATION-NAME"               then wdbs._Db-coll-name = iarg.
          when "INTERNAL-EXTERNAL-TRAN-TABLE" then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-xlate[1]").
          when "EXTERNAL-INTERNAL-TRAN-TABLE" then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-xlate[2]").
          when "CASE-INSENSITIVE-SORT"        then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate[1]").
          when "CASE-SENSITIVE-SORT"          then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate[2]").
          when "UPPERCASE-MAP"                then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate[3]").
          when "LOWERCASE-MAP"                then 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate[4]").
          otherwise assign ierror = 4. /* "Unknown &2 keyword" */
          end case.
  
        end. /*-------------------------------------------------------------------*/
      else if iobj = "s" then DO: /*--------------------------------------------*/
  
        CASE ikwd:
          when "SEQUENCE"       then wseq._Seq-Name = iarg.
          when "INITIAL"        then wseq._Seq-Init = INTEGER(iarg).
          when "INCREMENT"      then wseq._Seq-Incr = INTEGER(iarg).
          when "CYCLE-ON-LIMIT" then wseq._Cycle-Ok = (iarg = "yes").
          when "MIN-VAL"        then wseq._Seq-Min  = INTEGER(iarg).
          when "MAX-VAL"        then wseq._Seq-Max  = INTEGER(iarg).
          when "FOREIGN-NAME"   then wseq._Seq-Misc[1] = iarg.
          when "FOREIGN-OWNER"  then wseq._Seq-Misc[2] = iarg.
          /* keywords for seq-misc elements 3-8 */ 
          when "SEQ-MISC3"      then wseq._Seq-Misc[3] = iarg.
          when "SEQ-MISC4"      then wseq._Seq-Misc[4] = iarg.
          when "SEQ-MISC5"      then wseq._Seq-Misc[5] = iarg.
          when "SEQ-MISC6"      then wseq._Seq-Misc[6] = iarg.
          when "SEQ-MISC7"      then wseq._Seq-Misc[7] = iarg.
          when "SEQ-MISC8"      then wseq._Seq-Misc[8] = iarg.

          otherwise assign ierror = 4. /* "Unknown &2 keyword" */
          end.
  
        end. /*-------------------------------------------------------------------*/
      else if iobj = "t" then DO: /*--------------------------------------------*/ 
        CASE ikwd:
          when    "FILE"       
          or when "TABLE"          then wfil._File-name    = iarg.
          when    "AREA"           then DO:
             assign iarg = ""
                    j    = 2.
             _areatloop:
             DO WHILE TRUE:
               IF ilin[j] = ? OR ilin[j] = "" THEN DO:
                 ASSIGN iarg = SUBSTRING(iarg, 1, (LENGTH(iarg) - 1))
                        ilin = "".
                 LEAVE _areatloop.
               END.
               ELSE 
                 ASSIGN iarg = iarg + ilin[j] + " "
                        j = j + 1.
             END.           
             FIND _AREA where _Area._Area-name = iarg NO-LOCK NO-ERROR.
             IF AVAILABLE _Area THEN   
                 ASSIGN file-area-number   = _Area._Area-number.
             ELSE
                 ASSIGN ierror = 31.                
          end.           
          when    "CAN-CREATE"
          or when "CAN-INSERT"     then wfil._Can-Create   = iarg.
          when    "CAN-READ"
          or when "CAN-SELECT"     then wfil._Can-Read     = iarg.
          when    "CAN-WRITE"
          or when "CAN-UPDATE"     then wfil._Can-Write    = iarg.
          when    "CAN-DELETE"     then wfil._Can-Delete   = iarg.
          when    "CAN-DUMP"       then wfil._Can-Dump     = iarg.
          when    "CAN-LOAD"       then wfil._Can-Load     = iarg.
          when    "TYPE"           then wfil._Db-lang      = LOOKUP(iarg,"SQL").
          when    "LABEL"          then wfil._File-Label   = iarg.
          when    "LABEL-SA"       then wfil._File-Label-SA = iarg. 
          when    "DESCRIPTION"    then wfil._Desc         = iarg.
          when    "VALEXP"         then wfil._Valexp       = TRIM(iarg).
          when    "VALMSG"         then wfil._Valmsg       = iarg.
          when    "VALMSG-SA"      then wfil._Valmsg-SA    = iarg.
          when    "FROZEN"         then wfil._Frozen       = (iarg = 'yes').
          when    "HIDDEN"         then wfil._Hidden       = (iarg = 'yes').
          when    "DUMP-NAME"      then wfil._Dump-name    = iarg.
          when    "FOREIGN-FLAGS"  then wfil._For-Flag     = INTEGER(iarg).
          when    "FOREIGN-FORMAT" then wfil._For-Format   = iarg.
          when    "FOREIGN-GLOBAL" then wfil._For-Cnt1     = INTEGER(iarg).
          when    "FOREIGN-ID"     then wfil._For-Id       = INTEGER(iarg).
          when    "FOREIGN-LEVEL"  then wfil._Fil-misc1[4] = INTEGER(iarg).
          when    "FOREIGN-LOCAL"  then wfil._For-Cnt2     = INTEGER(iarg).
          when    "FOREIGN-MARK"   then wfil._For-Info     = iarg.
          when    "FOREIGN-NAME"   then wfil._For-Name     = iarg.
          when    "FOREIGN-NUMBER" then wfil._For-number   = INTEGER(iarg).
          when    "FOREIGN-OWNER"  then wfil._For-Owner    = iarg.
          when    "FOREIGN-SIZE"   then assign
                                        wfil._For-Size     = INTEGER(iarg).
          when    "PROGRESS-RECID"  
          or when "FILE-MISC11"    then wfil._Fil-misc1[1] = INTEGER(iarg).
          when    "FOREIGN-SPAN"   then wfil._Fil-misc1[2] = LOOKUP(iarg,"yes").
          when    "FILE-MISC12"    then wfil._Fil-misc1[2] = INTEGER(iarg).
          when    "INDEX-FREE-FLD"  
          or when "FILE-MISC13"    then wfil._Fil-misc1[3] = INTEGER(iarg).
          when    "OVERLOAD-NR"     
          or when "RECID-COL-NO"     
          or when "FILE-MISC14"    then wfil._Fil-misc1[4] = INTEGER(iarg).
          when    "FILE-MISC15"    then wfil._Fil-misc1[5] = INTEGER(iarg).
          when    "FILE-MISC16"    then wfil._Fil-misc1[6] = INTEGER(iarg).
          when    "FILE-MISC17"    then wfil._Fil-misc1[7] = INTEGER(iarg).
          when    "FILE-MISC18"    then wfil._Fil-misc1[8] = INTEGER(iarg).
          when    "FOREIGN-TYPE"   then wfil._For-Type     = iarg.
          when    "QUALifIER"       
          or when "FILE-MISC21"    then wfil._Fil-misc2[1] = iarg.
          when    "HIDDEN-FLDS"     
          or when "FILE-MISC22"    then wfil._Fil-misc2[2] = iarg.
          when    "RECID-FLD-NAME"  
          or when "FILE-MISC23"    then wfil._Fil-misc2[3] = iarg.
          when    "FLD-NAMES-LIST"  
          or when "FILE-MISC24"    then wfil._Fil-misc2[4] = iarg.
          when    "FILE-MISC25"    then wfil._Fil-misc2[5] = iarg.
          when    "FILE-MISC26"    then wfil._Fil-misc2[6] = iarg.
          when    "FILE-MISC27"    then wfil._Fil-misc2[7] = iarg.
          when    "DB-LINK-NAME"    
          or when "FILE-MISC28"    then wfil._Fil-misc2[8] = iarg.
          when    "FILE-TRIGGER"
          or when "TABLE-TRIGGER"  then DO:
                find first wfit where wfit._Event = iarg NO-ERROR.
                if NOT available wfit then CREATE wfit.
                wfit._Event = ilin[2].
                CASE ilin[3]:
                  when    "DELETE"
                  or when "DROP"
                  or when "REMOVE"      then wfit._Proc-Name = "!":u.
                  when    "OVERRIDE"    then wfit._Override  = TRUE.
                  when    "NO-OVERRIDE" then wfit._Override  = FALSE.
                  end case.
                if ilin[4] = "PROCEDURE":u then wfit._Proc-Name = ilin[5].
                if ilin[6] = "CRC" then wfit._Trig-CRC = 
                  (if ilin[7] = ? then ? else INTEGER(ilin[7])).
                ilin = ?.
                end.
          otherwise assign ierror = 4. /* "Unknown &2 keyword" */
          end case.  
        end. /*-------------------------------------------------------------------*/
      else if iobj = "f" then DO: /*--------------------------------------------*/
  
        CASE ikwd:
          when    "AS" or when "TYPE" then
            wfld._Data-type = (if     iarg = "boolean" then "logical"
                            else if iarg = "dbkey"   then "recid" else iarg).
          when    "FIELD"     or when "COLUMN"      then wfld._Field-name = iarg.
          when    "DESC"      or when "DESCRIPTION" then wfld._Desc = iarg.
          when    "INITIAL"   or when "DEFAULT"     then wfld._Initial = iarg.
          when    "CAN-READ"  or when "CAN-SELECT"  then wfld._Can-Read = iarg.
          when    "CAN-WRITE" or when "CAN-UPDATE"  then wfld._Can-Write = iarg.
          when    "NULL" or when "NULL-ALLOWED" then wfld._Mandatory = (iarg = "no").
          when    "SQL-WIDTH" then
	  DO:
	     wfld._Width = INTEGER(iarg).
             IF LOOKUP(wfld._Data-Type,"character,decimal,raw") > 0 OR
             wfld._Extent > 0 THEN
                IF INTEGER(iarg) > 31995 THEN
                   ASSIGN
                      ierror = 50
		      iwarn  = 25
		      warn_text[26] =
		      SUBSTITUTE(warn_text[26],wfld._Field-name,iarg).
          END.
          when    "FORMAT"                 then wfld._Format = iarg.
          when    "FORMAT-SA"              then wfld._Format-SA = iarg.
          when    "LABEL"                  then wfld._Label = iarg.
          when    "LABEL-SA"               then wfld._Label-SA = iarg.
          when    "COLUMN-LABEL"           then wfld._Col-label = iarg.
          when    "COLUMN-LABEL-SA"        then wfld._Col-label-SA = iarg.
          when    "INITIAL-SA"             then wfld._Initial-SA = iarg.
          when    "POSITION"               then wfld._Field-rpos = INTEGER(iarg).
          when    "VALEXP"                 then wfld._Valexp = TRIM(iarg).
          when    "VALMSG"                 then wfld._Valmsg = iarg.
          when    "VALMSG-SA"              then wfld._Valmsg-SA = iarg.
          when    "VIEW-AS"                then wfld._View-As = iarg.
          when    "HELP"                   then wfld._Help = iarg.
          when    "HELP-SA"                then wfld._Help-SA = iarg.
          when    "EXTENT"                 then wfld._Extent = INTEGER(iarg).
          when    "DECIMALS" 
          or when "LENGTH" 
          or when "SCALE" 
          or when "FOREIGN-BITS"           then wfld._Decimals      = INTEGER(iarg).
          when    "ORDER"                  then wfld._Order         = INTEGER(iarg).
          when    "MANDATORY"              then wfld._Mandatory     = (iarg = "yes").
          when    "CASE-SENSITIVE"         then wfld._Fld-case      = (iarg = "yes").
          when    "FOREIGN-ALLOCATED"      then wfld._For-Allocated = INTEGER(iarg).
          when    "FOREIGN-CODE"           then wfld._For-Itype     = INTEGER(iarg).
          when    "FOREIGN-ID"             then wfld._For-Id        = INTEGER(iarg).
          when    "FOREIGN-MARK"           then . /* unused in V7 */
          when    "FOREIGN-MAXIMUM"        then wfld._For-Maxsize   = INTEGER(iarg).
          when    "FOREIGN-NAME"           then wfld._For-Name      = iarg.
          when    "FOREIGN-POS"            then assign
                                                wfld._Fld-stoff     = INTEGER(iarg)
                                                l_Fld-stoff         = wfld._Fld-stoff.
          when    "FOREIGN-RETRIEVE"       then wfld._For-retrieve  = (iarg = "yes").
          when    "FOREIGN-SCALE"          then wfld._For-Scale     = INTEGER(iarg).
          when    "FOREIGN-SEP"            then wfld._For-Separator = iarg.
          when    "FOREIGN-SIZE"           then assign
                                                wfld._Fld-stlen     = INTEGER(iarg)
                                                l_Fld-stlen         = wfld._Fld-stlen.
          when    "FOREIGN-SPACING"        then wfld._For-Spacing   = INTEGER(iarg).
          when    "FOREIGN-TYPE"           then wfld._For-Type      = iarg.
          when    "FOREIGN-XPOS"           then wfld._For-Xpos      = INTEGER(iarg).
          when    "DSRVR-PRECISION"         
          or when "FIELD-MISC11"           then wfld._Fld-misc1[1]  = INTEGER(iarg).
          when    "DSRVR-SCALE"                    
          or when "FIELD-MISC12"           then wfld._Fld-misc1[2]  = INTEGER(iarg).
          when    "DSRVR-LENGTH"            
          or when "FIELD-MISC13"           then wfld._Fld-misc1[3]  = INTEGER(iarg).
          when    "DSRVR-FLDMISC"            
          or when "FIELD-MISC14"           then wfld._Fld-misc1[4]  = INTEGER(iarg).
          when    "DSRVR-SHADOW"            
          or when "FIELD-MISC15"           then wfld._Fld-misc1[5]  = INTEGER(iarg).
          when    "FIELD-MISC16"           then wfld._Fld-misc1[6]  = INTEGER(iarg).
          when    "FIELD-MISC17"           then wfld._Fld-misc1[7]  = INTEGER(iarg).
          when    "FIELD-MISC18"           then wfld._Fld-misc1[8]  = INTEGER(iarg).
          when    "FIELD-MISC21"           then wfld._Fld-misc2[1]  = iarg.
          when    "SHADOW-COL"                    
          or when "FIELD-MISC22"           then wfld._Fld-misc2[2]  = iarg.
          when    "QUOTED-NAME"                    
          or when "FIELD-MISC23"           then wfld._Fld-misc2[3]  = iarg.
          when    "MISC-PROPERTIES"         
          or when "FIELD-MISC24"           then wfld._Fld-misc2[4]  = iarg.
          when    "SHADOW-NAME"                    
          or when "FIELD-MISC25"           then wfld._Fld-misc2[5]  = iarg.
          when    "FIELD-MISC26"           then wfld._Fld-misc2[6]  = iarg.
          when    "FIELD-MISC27"           then wfld._Fld-misc2[7]  = iarg.
          when    "FIELD-MISC28"           then wfld._Fld-misc2[8]  = iarg.
          when    "FIELD-TRIGGER"          then DO:
                find first wflt where wflt._Event = iarg NO-ERROR.
                if NOT available wflt then CREATE wflt.
                wflt._Event = ilin[2].
                CASE ilin[3]:
                  when "DELETE" or when "DROP" or when "REMOVE" then
                                                wflt._Proc-Name = "!":u.
                  when "OVERRIDE"    then wflt._Override = TRUE.
                  when "NO-OVERRIDE" then wflt._Override = FALSE.
                  end case.
                if ilin[4] = "PROCEDURE" then wflt._Proc-Name = ilin[5].
                if ilin[6] = "CRC" then wflt._Trig-CRC = 
                  (if ilin[7] = ? then ? else INTEGER(ilin[7])).
                ilin = ?.
                end.
          otherwise assign ierror = 4. /* "Unknown &2 keyword" */
          end case.
  
        end. /*-------------------------------------------------------------------*/
      else if iobj = "i" then DO: /*--------------------------------------------*/
  
        CASE ikwd:
          when    "INDEX" or when "KEY" then widx._Index-Name = iarg.
          when    "UNIQUE"              then widx._Unique     = (iarg = "yes").
          when    "INACTIVE"            then widx._Active     = (iarg = "no").
          when    "PRIMARY"             then iprimary         = TRUE.
          when    "WORD"                then widx._Wordidx    = LOOKUP(iarg,"yes").
          when    "INDEX-NUM"           then widx._Idx-num    = INTEGER(iarg).
          when    "AREA"                then DO:
             assign iarg = ""
                    j    = 2.
             _areailoop:
             DO WHILE TRUE:
               IF ilin[j] = ? OR ilin[j] = "" THEN DO:
                 ASSIGN iarg = SUBSTRING(iarg, 1, (LENGTH(iarg) - 1))
                        ilin = "".
                 LEAVE _areailoop.
               END.
               ELSE 
                 ASSIGN iarg = iarg + ilin[j] + " "
                        j = j + 1.
             END.           
             FIND _AREA where _Area._Area-name = iarg NO-LOCK NO-ERROR.
             IF AVAILABLE _Area THEN   
                 ASSIGN index-area-number   = _Area._Area-number.
             ELSE
                 ASSIGN ierror = 31.                
          end.                    
          when    "FOREIGN-LEVEL"       then widx._I-misc1[1] = INTEGER(iarg).
          when    "FOREIGN-NAME"        then widx._For-name   = iarg.
          when    "FOREIGN-TYPE"        then widx._For-type   = iarg.
          when    "RECID-INDEX"         then widx._I-misc2[1] = iarg.
          when    "DESC" 
          or when "DESCRIPTION"         then widx._Desc = iarg.
          when    "INDEX-FIELD"
          or when "KEY-FIELD"           then DO:
            IF ilin[2] = ? or ilin[2] = "" THEN DO:
               ASSIGN ilin = ?.
               NEXT load_loop.
            END.
            FIND _Field where _Field._File-recid = drec_file
                    AND _Field._Field-name = ilin[2] NO-ERROR.
                    
            if imod <> "a":u then ierror = 12.
              /* "Cannot add index field to existing index" */
            if NOT available _Field then ierror = 13.
              /* "Cannot find field to index" */
            if ierror > 0 AND ierror <> 50 then UNDO,RETRY load_loop.
            CREATE wixf.
            assign
                  icomponent        = icomponent + 1
                  wixf._Index-Seq   = icomponent
                  wixf._Field-recid = RECID(_Field)
                  wixf._Ascending   = TRUE.
                if ilin[3] BEGINS "DESC":u OR ilin[4] BEGINS "DESC":u
                  OR ilin[5] BEGINS "DESC":u then wixf._Ascending  = FALSE.
                if ilin[3] BEGINS "ABBR":u OR ilin[4] BEGINS "ABBR":u
                  OR ilin[5] BEGINS "ABBR":u then wixf._Abbreviate = TRUE.
                if ilin[3] BEGINS "UNSO":u OR ilin[4] BEGINS "UNSO":u
                  OR ilin[5] BEGINS "UNSO":u then wixf._Unsorted   = TRUE.
                ilin = ?.
                end.
          otherwise assign ierror = 4. /* "Unknown &2 keyword" */
          end case.
  
        end. /*-------------------------------------------------------------------*/
      if ierror > 0 AND ierror <> 50 then UNDO,RETRY load_loop.
    
      assign stopped = false.

      end.  /* end repeat load_loop*/

    end.  /* end stop */


  if stopped 
   then DO:
      RUN adecomm/_setcurs.p ("").
      MESSAGE "Load terminated."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      end.
   else DO:  /* all but last definition-set executed */
    if do-commit OR (NOT (ierror > 0 AND user_env[4] BEGINS "y":u)) then
    finish: DO:
      /* Copy any remaining buffer values to the database */
      RUN adecomm/_setcurs.p ("WAIT").

      if available wdbs
       and imod <> ?
       then DO:
        RUN "prodict/dump/_lod_dbs.p".
        if drec_db <> RECID(_Db)
         then FIND _Db where RECID(_Db) = drec_db.
        end.

      if available wfil
       and imod <> ?
       then RUN "prodict/dump/_lod_fil.p".

      if available wfld
       and imod <> ?
       then DO:
          RUN "prodict/dump/_lod_fld.p"(INPUT-OUTPUT minimum-index).
        end.

      if available widx
       and imod <> ?
       then do:
        RUN "prodict/dump/_lod_idx.p"(INPUT-OUTPUT minimum-index).
        end.

      if available wseq
       and imod <> ?
       then RUN "prodict/dump/_lod_seq.p".
   

      RUN adecomm/_setcurs.p ("").

      /* Error occurred when trying to save data from last command? */
      if ierror > 0 AND ierror <> 50 then DO:
        RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
        RUN Show_Error ("prev").
        if user_env[4] BEGINS "y":u then LEAVE finish.
        end.
       ELSE IF ierror = 50 THEN DO:
         DO w = 1 TO NUM-ENTRIES(iwarnlst):
           ASSIGN iwarn = INTEGER(ENTRY(w, iwarnlst)).
           IF iwarn = 23 THEN warn_text[23] = SUBSTITUTE(warn_text[23],wfld._Field-name,iarg).
           ELSE IF iwarn = 24 THEN warn_text[24] = SUBSTITUTE(warn_text[24],wfld._Field-name,iarg).
           ELSE LEAVE.
           RUN Show_error ("prev").
         END.          
         ASSIGN ierror = 0.
      END.
      if ct_changed AND NOT xerror then 
         MESSAGE "The .df file just loaded contains translation or" SKIP
                 "collation tables that are different from the ones" SKIP
                 "that were already in the database." SKIP(1)
                       "You will not be able to use this database in any" SKIP
                       "way until you rebuild its indices."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.

      RUN adecomm/_setcurs.p ("WAIT").

      RUN "prodict/dump/_lodfini.p".
      end.   /* finish: */
    
    end.     /* all but last definition-set executed */

  /* Make sure we reset ourselves back to the current database. */
  if sav_drec <> drec_db
    then assign
       user_dbname = sav_dbnam
       user_dbtype = sav_dbtyp
       drec_db     = sav_drec.

  INPUT CLOSE.
  HIDE MESSAGE NO-PAUSE.

  if TERMINAL <> ""
   then DO:  /* TERMINAL <> "" */

    HIDE FRAME working NO-PAUSE.
    IF do-commit AND xerror THEN DO:      
      ASSIGN do-commit = FALSE.
      MESSAGE "There have been errors encountered in the loading of this df and " SKIP
              "you have selected to commit the transaction anyway. " SKIP(1)
              "Are you sure you want to commit with missing information? " SKIP (1)
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE do-commit.
     
      IF NOT do-commit THEN 
        MESSAGE msg2 VIEW-AS ALERT-BOX ERROR.
      ELSE
        ASSIGN xerror = FALSE.
    END.
    ELSE if NOT (xerror OR stopped or xwarn) then DO:
      if CURRENT-WINDOW:MESSAGE-AREA = yes 
       then MESSAGE msg1.
       else do:
         display msg1 WITH FRAME working2.
         pause 10.
       END.
    end.
    else if CURRENT-WINDOW:MESSAGE-AREA = yes then
      IF user_env[19] = "" THEN do:
          IF xerror or stopped THEN 
          MESSAGE msg2 VIEW-AS ALERT-BOX ERROR.
          if user_env[6] = "f" or user_env[6] = "b" then
            MESSAGE msg3 dbload-e msg4 VIEW-AS ALERT-BOX INFORMATION.
      end.
      ELSE
      DO:
         MESSAGE msg2.
         PAUSE.
      END.
      
    end.     /* TERMINAL <> "" */

  if (xerror OR stopped)
   then undo, leave.

  HIDE FRAME backout  NO-PAUSE.
  HIDE FRAME working2 NO-PAUSE.
  HIDE MESSAGE no-pause.
  
  RUN adecomm/_setcurs.p ("").

  SESSION:IMMEDIATE-DISPLAY = no.


  end.     /* conversion not needed OR needed and possible */


if (xerror OR stopped)
 then assign user_path = "9=h,4=error,_usrload":u.

/* assign ? to all the _db-records, that have interims-value of
 * SESSION:CHARSET assigned to _db-xl-name, because they had no
 * codepage-name entry in the .df-file
 */
for each s_ttb_fake-cp:
  find first _Db where RECID(_Db) = s_ttb_fake-cp.db-recid.
  assign
    _db._db-xl-name = ?
    ierror          = 44
    imod            = "cp"
    iobj            = "cp" + _db._db-name.
  RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
  RUN Show_Error ("prev").
  delete s_ttb_fake-cp.
  end.

RETURN.

/*--------------------------------------------------------------------*/


