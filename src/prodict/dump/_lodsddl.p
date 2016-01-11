/*********************************************************************
* Copyright (C) 2006-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
                          
/*history
   D. McMann   04/11/01 Added warning for SQL Table Updates ISSUE 310
   D. McMann   02/24/03 Added LOB Support
   D. McMann   09/22/03 Added check for object names not being keywords 20030618-015
   D. McMann   09/22/03 Added check for Progress df trying to be loaded into a foreign
                        data source. 20030815-039
   D. McMann   09/29/03 Added check for invalid data type 20030925-014
   S. Watt &
   K. McIntosh 05/13/04 Added support for loading collation tables for UTF-8
   F. Souza    07/09/04 Added data type abbreviations 20040430-023
   K. McIntosh 09/17/04 Increased number of elements of the error_text array to 60 
			      and moved Max Sequences message to 51. 20030619-003
   K. McIntosh 09/17/04 Backed out fix for bug number 20040910-010
   fernando    03/16/06 Handle case where error message was not displayed becasue
                        the block was not retried - 20060316-011
   fernando    05/25/06 Added support for large sequences
   fernando    08/21/06 Fixing load of collation into pre-10.1A db (20060413-001)
   moloney     09/22/06 Set initial value for TIME & TIMESTAMP columns mapped to CHARCTER and load w/out an initial value
   fernando    10/02/07 Error handling - OE00158774
   fernando    11/13/07 Check _initial value for sequences - OE00112332
   gih         11/27/07 Fix load of ICU rules - OE00129463
   fernando    07/18/08 Encryption support
   fernando    11/24/08 Handle clob field changes - OE00177533
   fernando    03/20/09 More enryption support
   fernando    04/13/09 Alternate buffer pool support
*/

{ prodict/dump/loaddefs.i NEW }
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

&IF DEFINED(SKP)
&THEN
  /* Don't do anything.  It's DEFINEd already */
&ELSE
   &SCOPED-DEFINE SKP SKIP
&ENDIF

DEFINE NEW SHARED TEMP-TABLE s_ttb_fake-cp
    FIELD   db-name     AS CHARACTER
    FIELD   db-recid    AS RECID.
    
DEFINE VARIABLE error_text AS CHARACTER EXTENT 70 NO-UNDO.
ASSIGN
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
  error_text[34] = "or PROUTIL for {&PRO_DISPLAY_NAME}. This .df file can't be loaded.":t72
  error_text[40] = "Errors occurred loading collation rules. Verify that definition":t72
  error_text[41] = "file is not corrupted.":t72
  error_text[43] = "Field-position and file-size don't match. File-size is too small.":t72
  error_text[44] = "Please use Dictionary to set the codepage for this database.":t72
  error_text[45] = "{&PRO_DISPLAY_NAME} keywords can not be object names.":t72
  error_text[46] = "CLOB data type must have CODEPAGE and COLLATION DEFINEd.":t72
  error_text[47] = "Unknown data type in field definition. ":t72
  error_text[50] = "" /* DO NOT USE.  If ierror is 50, then it's a warning */
  error_text[51] = "Maximum number of sequences has been reached.":t72
  error_text[52] = "Invalid Initial value":t25
  error_text[53] = "Value is too large":t25
  error_text[54] = "Invalid character in the Dump Name":t35
  error_text[55] = "Neither BLOB nor CLOB fields may have extents":t46
  error_text[56] = "Client error raised while loading definitions":t46
  error_text[57] = "The upper limit must be greater than the initial value":t54
  error_text[58] = "The lower limit must be less than the initial value":t51
  error_text[59] = "Invalid foreign data type for field":t35
  error_text[60] = "Invalid keyword for a non-OpenEdge database":t44
  error_text[61] = "" /* don't use - for encryption */
  error_text[62] = "Invalid keyword for this field type.":t36
  error_text[63] = "Cannot change object encryption policy until encrypted data has been updated":t76
  error_text[64] = "Invalid cipher name.":t20
  error_text[65] = "Missing or invalid settings for ENCRYPTION or CIPHER-NAME.":t58
  error_text[66] = "Cannot change codepage or collation of existing column":t54
  error_text[67] = "Missing or invalid settings for BUFFER-POOL.":t50
  error_text[68] = "Definitions for policies and attributes are loaded in a separate transaction.":t77
  error_text[69] = " Errors caused that transaction to rollback. Other definitions were committed.":t78
  error_text[70] = "" /* don't use - for buffer-pool */
.

&SCOPED-DEFINE WARN_MSG_SQLW 48

DEFINE VARIABLE warn_text AS CHARACTER EXTENT 50 NO-UNDO.
ASSIGN
  warn_text[23] = "Can't change Can-read or write, Mandatory, or Decimals of field in SQL table." 
  warn_text[24] = "Can't change case-sensitivity of ""&1""  because it is part of an index.":t72
  warn_text[25] = "Can't change Decimals of field ""&1"". Field type is not DECIMAL.":t72
  warn_text[26] = "Ignoring encryption setting which matches the current policy.":t68
  
  /* these three lines need to go together, so if you need to add new warnings, add them here, 
     and adjust the numbers below. Then change WARN_MSG_SQLW to point to the next warning ID */
  warn_text[48] = "SQL client cannot access fields having widths greater than 31995.  ":t72
  warn_text[49] = "The width of the field ""&1"" in the .df file is &2.  ":t72
  warn_text[50] = "Use the data dictionary Adjust Width Utility to correct width.":t72
  /* DON'T ADD MESSAGES HERE. See comment below */
.

/* This is going to be used to store the warning message after calling substitute so we don't
   change the warn_text variable */
DEFINE VARIABLE warn_message AS CHARACTER.

DEFINE NEW SHARED STREAM loaderr.

DEFINE VARIABLE dbload-e      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE hdr           AS INTEGER INIT 0      NO-UNDO.

DEFINE VARIABLE scrap         AS CHARACTER           NO-UNDO.

DEFINE VARIABLE cerror        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage      AS CHARACTER           NO-UNDO INIT "UNDEFINED".
DEFINE VARIABLE i             AS INTEGER             NO-UNDO.
DEFINE VARIABLE j             AS INTEGER             NO-UNDO.
DEFINE VARIABLE w             AS INTEGER             NO-UNDO.
DEFINE VARIABLE k             AS INTEGER             NO-UNDO.
DEFINE VARIABLE iobj          AS CHARACTER           NO-UNDO. /* d,t,f,i */
DEFINE VARIABLE inot          AS LOGICAL             NO-UNDO.
DEFINE VARIABLE inum          AS INTEGER             NO-UNDO.
DEFINE VARIABLE l_fld-stlen   AS INTEGER             NO-UNDO. /* foreign dbs... */
DEFINE VARIABLE l_fld-stoff   AS INTEGER             NO-UNDO. /* foreign dbs... */
DEFINE VARIABLE lvar          AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#         AS INTEGER             NO-UNDO.
DEFINE VARIABLE stopped       AS LOGICAL             NO-UNDO INIT TRUE.
DEFINE VARIABLE sav_dbnam     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_dbtyp     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_err       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_drec      AS RECID               NO-UNDO.
DEFINE VARIABLE xerror        AS LOGICAL             NO-UNDO. /* any error during process? */
DEFINE VARIABLE xwarn         AS LOGICAL             NO-UNDO. /* any warnings during process? */
DEFINE VARIABLE do-commit     AS LOGICAL             NO-UNDO.

/* collate/translate information */
DEFINE VARIABLE ct_version    AS CHARACTER           NO-UNDO.                /* version # */
DEFINE VARIABLE ct_changed    AS LOGICAL             NO-UNDO INIT no.  /* tables modified? */
DEFINE VARIABLE ix            AS INTEGER             NO-UNDO. /* for parsing version # */
DEFINE VARIABLE len           AS INTEGER             NO-UNDO. /* ditto */
DEFINE VARIABLE raw_val       AS RAW                 NO-UNDO.
DEFINE VARIABLE orig_vers     AS RAW                 NO-UNDO.
DEFINE VARIABLE rules         AS LONGCHAR            NO-UNDO.

DEFINE variable minimum-index AS INTEGER initial 0.
DEFINE variable new-number    AS INTEGER initial 0.
DEFINE VARIABLE hBuffer       AS HANDLE              NO-UNDO.

/* messages for frames working2 and backout. */
DEFINE VARIABLE msg1          AS CHARACTER           NO-UNDO FORMAT "x(53)":u.
DEFINE VARIABLE msg2          AS CHARACTER           NO-UNDO FORMAT "x(56)":u.
DEFINE VARIABLE msg3          AS CHARACTER           NO-UNDO FORMAT "x(12)":u.
DEFINE VARIABLE msg4          AS CHARACTER           NO-UNDO FORMAT "x(16)":u.
DEFINE VARIABLE msg5          AS CHARACTER           NO-UNDO FORMAT "x(40)":u.
DEFINE VARIABLE skipEPolicy   AS LOGICAL             NO-UNDO.
DEFINE VARIABLE encryptOpts   AS LOGICAL             NO-UNDO EXTENT 2.
DEFINE VARIABLE skipObjAttrs  AS LOGICAL             NO-UNDO.
DEFINE VARIABLE hasEncPol     AS LOGICAL             NO-UNDO.
DEFINE VARIABLE hasBufPool    AS LOGICAL             NO-UNDO.
DEFINE VARIABLE showedCommitMsg AS LOGICAL            NO-UNDO.
DEFINE VARIABLE got-error     AS LOGICAL            NO-UNDO.
DEFINE VARIABLE main_trans_success  AS LOGICAL            /*UNDO*/.

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
    KBLABEL("STOP") + " to terminate load process." FORMAT "x(70)" 
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

FORM
 msg5 VIEW-AS TEXT NO-LABELS WITH FRAME encryptlog ROW 7 CENTERED USE-TEXT.

/*=======================Internal Procedures===========================*/

PROCEDURE Put_Header:

 DEFINE INPUT        PARAMETER efile_nam AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER hdr_cnt   AS INTEGER    NO-UNDO.
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
   Show an error.  IF p_cmd = "prev" it means the
   error occurred when flushing data for the previous
   command and we no longer have the error command
   in ilin.  IF p_cmd = "curr", it means ilin still
   contains the command which caused the error.
   imod and iobj however, always pertain to the 
   error command.
------------------------------------------------------*/
PROCEDURE Show_Error:
  DEFINE INPUT PARAMETER p_cmd AS CHAR NO-UNDO.

  DEFINE VAR msg AS CHAR    NO-UNDO INIT "".
  DEFINE VAR ix  AS INTEGER NO-UNDO.

  IF ierror = 50 THEN DO:
    RUN Show_Warning (INPUT p_cmd).
    RETURN.
  END.
  
  IF imod = "sp":u THEN
      scrap = "load of file". /* special case for enryption / buffer-pool */
  ELSE
  scrap = (IF imod = "cp":u THEN "ADD/MODIFY":u
      ELSE IF imod = "a":u  THEN "ADD":u
      ELSE IF imod = "m":u  THEN "MODIFY":u
      ELSE IF imod = "r":u  THEN "RENAME":u
      ELSE IF imod = "d":u  THEN "DELETE":u
      ELSE IF imod = "e":u  THEN "":u
      ELSE "?":u)
    + " ":u
    + (IF     iobj begins "cp":u THEN "DATABASE ":u + 
               SUBSTRING(iobj,3,-1,"CHARACTER")
      ELSE IF iobj    =   "d":u  THEN "DATABASE ":u + 
               (IF wdbs._Db-name    = ? THEN "" ELSE wdbs._Db-name)
      ELSE IF iobj    =   "t":u  THEN "TABLE ":u    + 
               (IF wfil._File-name  = ? THEN "" ELSE wfil._File-name)
      ELSE IF iobj    =   "f":u  THEN "FIELD ":u    + 
               (IF wfld._Field-name = ? THEN "" ELSE wfld._Field-name)
      ELSE IF iobj    =   "i":u  THEN "INDEX ":u    + 
               (IF widx._Index-name = ? THEN "" ELSE widx._Index-name)
      ELSE IF iobj    =   "s":u  THEN "SEQUENCE ":u + 
               (IF wseq._Seq-Name   = ? THEN "" ELSE wseq._Seq-Name)
      ELSE "? ?":u).

  IF p_cmd = "curr" THEN DO:
     msg = "** Line " + STRING(ipos).
     DO ix = 1 to 9:
       msg = msg + (IF ilin[ix] <> ? THEN " " + ilin[ix] ELSE "").
     END.
  END.

  IF user_env[6] = "f"
   THEN DO:  /* output only to file */

    OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.
    IF  ierror <= 31
     OR ierror >  42 THEN DO:
      IF msg = ""
       THEN
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** Error during " scrap " **" SKIP(1)
         SUBSTITUTE(error_text[ierror],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
       ELSE
         PUT STREAM loaderr UNFORMATTED
         SKIP(1) "** Error during " scrap " **" SKIP(1)
         msg SKIP(1)
         SUBSTITUTE(error_text[ierror],
         ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
     END.  
    ELSE /* IF ierror <= 42
     THEN */ 
       PUT STREAM loaderr UNFORMATTED
       SKIP(1) "** Error during" scrap "**"           SKIP(1)
       error_text[ierror]                     {&SKP}
       error_text[ierror + 1]                 {&SKP} 
       error_text[ierror + 2].
    END.     /* output only to file */

   ELSE IF user_env[6] = "s" THEN DO: /* output only with alert-boxes */

    IF  ierror <= 31
     OR ierror >  42 THEN
      IF msg = ""
       THEN MESSAGE 
          "** Error during" scrap "**" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       ELSE MESSAGE 
          "** Error during" scrap "**" SKIP(1)
          msg SKIP(1) 
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ELSE /* IF ierror <= 42
     THEN */ MESSAGE
        "** Error during" scrap "**"           SKIP(1)
        error_text[ierror]                     {&SKP}
        error_text[ierror + 1]                 {&SKP} 
        error_text[ierror + 2] 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    END.     /* output only with alert-boxes */
    
   ELSE IF user_env[6] = "b" THEN DO:  /* output to both file and alert-boxes */
   OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    IF  ierror <= 31
     OR ierror >  42
     THEN DO:
      IF msg = ""
       THEN DO: MESSAGE
          "** Error during" scrap "**" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** Error during " scrap " **" SKIP(1)
          SUBSTITUTE(error_text[ierror],
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
        END.
       ELSE DO: MESSAGE
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
        END.
      END.
    ELSE /* IF ierror <= 42
     THEN */DO:
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
      END.

    END.     /* output to both file and alert-boxes */

  ASSIGN xerror = true.

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

  scrap = (IF imod = "cp":u THEN "ADD/MODIFY":u
      ELSE IF imod = "a":u  THEN "ADD":u
      ELSE IF imod = "m":u  THEN "MODIFY":u
      ELSE IF imod = "r":u  THEN "RENAME":u
      ELSE IF imod = "d":u  THEN "DELETE":u
      ELSE "?":u)
    + " ":u
    + (IF     iobj begins "cp":u THEN "DATABASE ":u + 
               SUBSTRING(iobj,3,-1,"CHARACTER")
      ELSE IF iobj    =   "d":u  THEN "DATABASE ":u + 
               (IF wdbs._Db-name    = ? THEN "" ELSE wdbs._Db-name)
      ELSE IF iobj    =   "t":u  THEN "TABLE ":u    + 
               (IF wfil._File-name  = ? THEN "" ELSE wfil._File-name)
      ELSE IF iobj    =   "f":u  THEN "FIELD ":u    + 
               (IF wfld._Field-name = ? THEN "" ELSE wfld._Field-name)
      ELSE IF iobj    =   "i":u  THEN "INDEX ":u    + 
               (IF widx._Index-name = ? THEN "" ELSE widx._Index-name)
      ELSE IF iobj    =   "s":u  THEN "SEQUENCE ":u + 
               (IF wseq._Seq-Name   = ? THEN "" ELSE wseq._Seq-Name)
      ELSE "? ?":u).
  IF user_env[6] = "f" THEN DO:
    OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    IF p_cmd = "curr" THEN DO:
      msg = "** Line " + STRING(ipos).
      DO ix = 1 to 9:
        msg = msg + (IF ilin[ix] <> ? THEN " " + ilin[ix] ELSE "").
      END.
    END.

    IF user_env[6] = "f" THEN DO:  /* output only to file */
      IF  iwarn < {&WARN_MSG_SQLW} THEN DO:
        IF msg = "" THEN
          PUT STREAM loaderr UNFORMATTED
             SKIP(1) "** " scrap " caused a warning **" SKIP(1)
             SUBSTITUTE(warn_message,
             ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
        ELSE
          PUT STREAM loaderr UNFORMATTED
             SKIP(1) "** " scrap " caused a warning **" SKIP(1)
             msg SKIP(1)
             SUBSTITUTE(warn_message,
             ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
      END.  
      ELSE /* IF iwarn >= {&WARN_MSG_SQLW} THEN */ 
        PUT STREAM loaderr UNFORMATTED
             SKIP(1) "** " scrap " caused a warning **"           SKIP(1)
             warn_text[iwarn]                     {&SKP}
             warn_message                         {&SKP} 
             warn_text[iwarn + 2].
    END.     /* output only to file */
  END.
  ELSE IF user_env[6] = "s" THEN DO: /* output only with alert-boxes */
    IF  iwarn < {&WARN_MSG_SQLW}  THEN
      IF msg = "" THEN 
         MESSAGE 
          "**" scrap "caused a warning **" SKIP(1)
          SUBSTITUTE(warn_message,
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      ELSE 
        MESSAGE 
          "**" scrap "caused a warning **" SKIP(1)
          msg SKIP(1) 
          SUBSTITUTE(warn_message,
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      ELSE /* IF iwarn >= {&WARN_MSG_SQLW} THEN */ 
        MESSAGE
          "**" scrap "caused a warning **"           SKIP(1)
          warn_text[iwarn]                     {&SKP}
          warn_message                         {&SKP} 
          warn_text[iwarn + 2] 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.

  END.     /* output only with alert-boxes */
  ELSE IF user_env[6] = "b" THEN DO:  /* output to both file and alert-boxes */
    OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

    IF  iwarn < {&WARN_MSG_SQLW} THEN DO:
      IF msg = "" THEN DO: 
        MESSAGE
          "**" scrap "caused a warning **" SKIP(1)
          SUBSTITUTE(warn_message,
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.

          PUT STREAM loaderr UNFORMATTED
          SKIP(1) "** " scrap " caused a warning **" SKIP(1)
          SUBSTITUTE(warn_message,
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
      END.
      ELSE DO: 
        MESSAGE
          "**" scrap "caused a warning **" SKIP(1)
          msg SKIP(1)
          SUBSTITUTE(warn_message,
          ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u))
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.

        PUT STREAM loaderr UNFORMATTED
              SKIP(1) "** " scrap " caused a warning **" SKIP(1)
              msg SKIP(1)
              SUBSTITUTE(warn_message,
              ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) SKIP(1).
      END.
    END.
    ELSE /* IF iwarn >= {&WARN_MSG_SQLW} THEN */ DO:
      MESSAGE
        "**" scrap "caused a warning **"           SKIP(1)
        warn_text[iwarn]                     {&SKP}
        warn_message                         {&SKP}
        warn_text[iwarn + 2]
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.

      PUT STREAM loaderr UNFORMATTED
        SKIP(1) "** " scrap " caused a warning **"           SKIP(1)
        warn_text[iwarn]                     {&SKP}
        warn_message                         {&SKP}
        warn_text[iwarn + 2] SKIP(1).
    END.

  END.     /* output to both file and alert-boxes */

  ASSIGN xwarn = true.
  
  OUTPUT STREAM loaderr CLOSE.

  ASSIGN warn_message = "".

END PROCEDURE. /* Show_Warnings */

/* Callback for errors when saving policies */
PROCEDURE secErrorCallback:
    DEFINE INPUT  PARAMETER pmsg      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER lContinue AS LOGICAL NO-UNDO.

    /* we always continue to load the policies, unless the user wants to
       stop at the first error.
    */
    IF user_env[4] BEGINS "y":u THEN
        lContinue = NO.
    ELSE
        lContinue = YES.

    RUN Show_Phase2_Error (INPUT pmsg, INPUT "e").
END.

/* Callback for errors when saving object attributes (buffer pool) */
PROCEDURE attrsErrorCallback:
    DEFINE INPUT  PARAMETER pmsg      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER lContinue AS LOGICAL NO-UNDO.

    /* we always continue to load the settings, unless the user wants to
       stop at the first error.
    */
    IF user_env[4] BEGINS "y":u THEN
        lContinue = NO.
    ELSE
        lContinue = YES.

    RUN Show_Phase2_Error (INPUT pmsg, INPUT "b").
END.

/* Handle errors during encryption policy / buffer pool save phase */
PROCEDURE Show_Phase2_Error:
  DEFINE INPUT PARAMETER p_msg  AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_cStr AS CHAR NO-UNDO.

  IF p_cStr = "e" THEN
      p_cStr = "encryption policy".
  ELSE IF p_cStr = "b" THEN
       p_cStr = "buffer pool".
  ELSE
      p_cStr = "encryption policies/buffer pool settings".

  IF user_env[6] = "f" THEN DO:
     OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.

     IF user_env[6] = "f" THEN DO:  /* output only to file */
        PUT STREAM loaderr UNFORMATTED
                   SKIP(1) "** Error loading " p_cStr " **"  
                   SKIP(1) p_msg {&SKP}.
     END.     /* output only to file */
  END. 
  ELSE IF user_env[6] = "s" THEN DO: /* output only with alert-boxes */
        IF p_msg BEGINS error_text[68] THEN
            MESSAGE p_msg
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ELSE
            MESSAGE "** Error loading " p_cStr " **"  
                    SKIP(1) p_msg
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.     /* output only with alert-boxes */
  ELSE IF user_env[6] = "b" THEN DO:  /* output to both file and alert-boxes */

        OUTPUT STREAM loaderr TO VALUE(dbload-e) APPEND.
        IF p_msg BEGINS error_text[68] THEN
            MESSAGE p_msg
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ELSE
            MESSAGE "** Error loading " p_cStr " **"  
                   SKIP(1) p_msg
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        PUT STREAM loaderr UNFORMATTED
                   SKIP(1) "** Error loading " p_cStr " **"  
                   SKIP(1) p_msg {&SKP}.

  END.     /* output to both file and alert-boxes */

  ASSIGN xerror = true.

  OUTPUT STREAM loaderr CLOSE.

END PROCEDURE. /* Show_Phase2_Error */

/*-----------------------------------------------------
   Load ICU RUles.
   
   Input Parameters:
      ct_version 
      xxxxxxx.
      
_Codepage
    _Cp-Name        Char    name 
    _Cp-Sequence        int     sequential number of codepage in this db.
    _Cp-Db-Recid        Recid       db recid.
    _Cp-Attr        Raw     codepage attributes (now 768 bytes)

Indexes:
    unique index on _Cp-DB-Recid + _Cp-Name
    unique index on _Cp-Sequence
      
      
_Collation
    _Coll-Name      Char    collation name
    _Coll-Sequence  int     sequential number of collation in this db?
                _Coll-cp        Int     _Cp-Sequence for this collation
    _Coll-Tran-Version  Int (byte)
    _Coll-Tran-Subtype  Int (byte)
    _Coll-Segment   Int     segment number
    _Coll-data      Raw     usually 512 bytes, could be multiple segs
    
Indexes:
    unique index on _Coll-cp + _Coll-Name + _Coll-Segment
    unique index on _Coll-Sequence
    
    then wdbs._Db-xl-name = iarg.
          when "COLLATION-NAME"               then wdbs._Db-coll-name = iar
------------------------------------------------------*/

PROCEDURE Load_Icu_Rules:

  DEFINE INPUT-OUTPUT PARAMETER longRules     AS INTEGER NO-UNDO.

  DEFINE VARIABLE lChanged      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lcRules       AS LONGCHAR NO-UNDO.
  DEFINE VARIABLE iCpSeq        AS INTEGER NO-UNDO.
  DEFINE VARIABLE iCollSeq      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iCollSegment  AS INTEGER init 1 NO-UNDO.
  DEFINE VARIABLE iLen          AS INTEGER NO-UNDO.
  DEFINE VARIABLE iOff          AS INTEGER NO-UNDO.
  DEFINE VARIABLE iShortOff     AS INTEGER init 69 NO-UNDO.
  DEFINE VARIABLE iRem          AS INTEGER NO-UNDO.
  DEFINE VARIABLE iPos          AS INTEGER NO-UNDO.
  DEFINE VARIABLE lpMptr        AS MEMPTR NO-UNDO.
  DEFINE VARIABLE lpToo         AS MEMPTR NO-UNDO.
  DEFINE VARIABLE iLength       AS INTEGER NO-UNDO.
  DEFINE VARIABLE iPosition     AS INTEGER init 1 NO-UNDO.
  DEFINE VARIABLE cInLine       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iReadPosition AS INTEGER NO-UNDO.

  IF cerror <> "no-convert" AND SESSION:CHARSET <> codepage THEN DO:
  INPUT CLOSE.
  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.

     REPEAT:
       IMPORT  UNFORMATTED cInLine.
       IF TRIM(cInLine) = "ICU-RULES" THEN LEAVE.
     END. /* repeat */
  END. /* IF cerror ... */

  lcRules = "".
  SET-SIZE(lpMptr) = IF longrules > 0 THEN longrules ELSE 300.
  FIX-CODEPAGE(lcRules) = "UTF-8".
  iPosition = 1.
  REPEAT:
    IMPORT  UNFORMATTED cInLine.
    IF TRIM(cInLine) = "END-RULES" THEN LEAVE.
    iLength = LENGTH(cInLine, "RAW").
    PUT-STRING(lpMptr, iPosition, iLength) = cInLine.
    iPosition = iPosition + iLength.
  END. /* repeat */
   
  IF longrules > 0 THEN
    COPY-LOB lpMptr TO lcRules NO-CONVERT NO-ERROR.
  ELSE DO:
    COPY-LOB lpMptr FOR (iPosition - 1) TO lpToo NO-ERROR.
    COPY-LOB lpToo TO lcRules NO-CONVERT NO-ERROR.
    SET-SIZE(lpToo) = 0.
  END.
    
      
  IF ERROR-STATUS:ERROR THEN DO:
    SET-SIZE(lpMptr) = 0.
    RETURN "Failed".
  END.

  IF longRules = 0 THEN lcRules = "".
  ELSE DO:
    FIND FIRST _Codepage WHERE _Cp-Name = wdbs._Db-xl-name AND _Cp-dbrecid = drec_db NO-ERROR.
    IF AVAILABLE _Codepage THEN DO:
      iCpSeq = _Codepage._Cp-sequence.
    END.
    ELSE DO:
      FIND LAST _Codepage USE-INDEX _Codepage-seq NO-ERROR.
      IF AVAILABLE _codepage THEN
        iCpSeq = _Codepage._Cp-sequence + 1.
      ELSE
        iCpSeq = 1.
      CREATE _Codepage.
      ASSIGN _Cp-name = wdbs._Db-xl-name
             _Cp-sequence = iCpSeq
             _Cp-dbrecid = drec_db NO-ERROR.

      IF ERROR-STATUS:ERROR THEN DO:
        SET-SIZE(lpMptr) = 0.
        RETURN "Failed".
      END.
    END.
    FIND FIRST _Collation WHERE wdbs._Db-coll-name = _Coll-name AND _Coll-cp = iCpSeq NO-ERROR.
    IF NOT AVAILABLE _Collation THEN DO:
 
      CREATE _Collation.

      ASSIGN _Coll-Name = wdbs._Db-coll-name
             _Coll-cp = iCpSeq
             _Coll-Tran-Version =   GETBYTE(wdbs._Db-collate[5],1) 
             _Coll-Tran-Subtype =  GETBYTE(wdbs._Db-collate[5],2)
             _Coll-Segment = iCollSegment NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN DO:
        SET-SIZE(lpMptr) = 0.
        RETURN "Failed".
      END.

      _Coll-data = wdbs._Db-collate[1] NO-ERROR.

      IF ERROR-STATUS:ERROR THEN DO:
        SET-SIZE(lpMptr) = 0.
        RETURN "Failed".
      END.

      PUT-BYTES(_Coll-data, 257) = wdbs._Db-collate[2].
 
      IF longRules > 0 THEN DO:
        iOff = 513.
        iRem = 30000 - iOff + 1.
        iLen = LENGTH( lcRules, "RAW" ).
        COPY-LOB lcRules TO lpMptr NO-CONVERT.
        IF iLen > iRem THEN DO:
          iPos = 1.
          DO WHILE iLen > 0 :
            lpToo = GET-BYTES( lpMptr, ipos, IF iLen > irem THEN irem ELSE iLen ).
            PUT-BYTES( _coll-data, IOFF)  = lpToo.
            iPos = iPos + iRem.
            iOff = 1. 
            iLen = iLen - iRem.
            iRem = 30000.
            IF iLen > 0 THEN DO:
              iCollSegment  = iCollSegment + 1.

              CREATE _Collation.
              ASSIGN _Coll-Name = wdbs._Db-coll-name
                     _Coll-cp = iCpSeq
                     _Coll-Tran-Version =  GET-BYTE(wdbs._Db-collate[5],1) 
                     _Coll-Tran-Subtype =  GET-BYTE(wdbs._Db-collate[5],2) 
                     _Coll-Segment = iCollSegment
                     _Coll-data = raw_val NO-ERROR.

              IF ERROR-STATUS:ERROR THEN DO:
                SET-SIZE(lpMptr) = 0.
                SET-SIZE(lpToo) = 0.
                RETURN "Failed".
              END.
            END. /*IF iLen > 0 THEN DO:*/

          END.  /* do while */
        END.  /* IF iLen > iRem */
        ELSE PUT-BYTES(_coll-data, iOff ) = lpMptr.

        SET-SIZE(lpMptr) = 0.
        SET-SIZE(lpToo) = 0.
                    
      END.  /* IF longRules */
    END.
  END.
   
  longRules =  LENGTH(lcRules, "RAW").

  lcRules = "".
  SET-SIZE(lpMptr) = 0.
   
  ct_changed = ct_changed OR lChanged.
  
  RETURN "".
END PROCEDURE.

/*-----------------------------------------------------
   Load one of the translation or collate tables.
   
   Input Parameter:
      p_Dbfield - the name of the database field to
                               load.
------------------------------------------------------*/
PROCEDURE Load_Tran_Collate_Tbl:

  DEFINE INPUT PARAMETER p_Dbfield AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_index   AS INTEGER NO-UNDO.

  DEFINE VARIABLE changed AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hParam  AS HANDLE NO-UNDO.

   IMPORT ilin.
   ipos = ipos + 1.

   ASSIGN hParam = BUFFER wdbs:HANDLE
          hParam = hParam:BUFFER-FIELD(p_dbfield).

   RUN prodict/dump/_lod_raw.i (INPUT ct_version, INPUT hParam, INPUT p_index, OUTPUT changed) 256.
   ct_changed = ct_changed OR changed.

   ilin[1] = ?.  /* so we do a new import the next time around */
  END.

  
/*-----------------------------------------------------
  Gets the utility set up so we can handle encryption 
  settings.
------------------------------------------------------*/
PROCEDURE checkEPolicy:
    DEFINE BUFFER myDb FOR _Db.

    IF VALID-OBJECT(dictEPolicy) THEN
       RETURN. /* all is well */

    FIND myDb WHERE RECID(myDb) = drec_db NO-LOCK.

    /* encryption only for OpenEdge dbs */
    IF myDb._Db-type NE "PROGRESS" THEN DO:
        ierror = 60.
        RETURN ERROR.
    END.
    ELSE IF skipEPolicy THEN DO:
        /* we will keep displaying the same message, if the user selected to
          ignore all errors 
        */
        ierror = 61.
        RETURN ERROR.
    END.

    /* we come here just once */
    skipEPolicy = YES.

    DO ON ERROR UNDO, LEAVE:
        dictEPolicy = NEW prodict.sec._sec-pol-util().

        CATCH ae AS PROGRESS.Lang.AppError:
            /* this gets set so we display the error message */
            ASSIGN error_text[61] = "Cannot load any encryption definitions." + "~n"
                            + ae:GetMessage(1)
                  ierror = 61.
            DELETE OBJECT ae.

            RETURN ERROR.
        END CATCH.
    END.
END.

/*-----------------------------------------------------
  Gets the utility set up so we can handle buffer pool 
  settings.
------------------------------------------------------*/
PROCEDURE checkObjAttrs:
    DEFINE BUFFER myDb FOR _Db.

    IF VALID-OBJECT(dictObjAttrs) THEN
       RETURN. /* all is well */

    FIND myDb WHERE RECID(myDb) = drec_db NO-LOCK.

    /* buffer-pool only for OpenEdge dbs */
    IF myDb._Db-type NE "PROGRESS" THEN DO:
        ierror = 60.
        RETURN ERROR.
    END.
    ELSE IF skipObjAttrs THEN DO:
        /* we will keep displaying the same message, if the user selected to
          ignore all errors 
        */
        ierror = 70.
        RETURN ERROR.
    END.

    /* we come here just once */
    skipObjAttrs = YES.

    DO ON ERROR UNDO, LEAVE:
        dictObjAttrs = NEW prodict.pro._obj-attrib-util().

        CATCH ae AS PROGRESS.Lang.AppError:
            /* this gets set so we display the error message */
            ASSIGN error_text[70] = "Cannot load any buffer-pool definitions." + "~n"
                            + ae:GetMessage(1)
                  ierror = 70.
            DELETE OBJECT ae.

            RETURN ERROR.
        END CATCH.
    END.
END.

/*-----------------------------------------------------
  save away encryption settings
------------------------------------------------------*/
PROCEDURE addEncryptionSetting.
    DEFINE INPUT PARAMETER objType AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER cKeywd  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER cValue  AS CHAR NO-UNDO.

    DEFINE VARIABLE cObjName AS CHAR    NO-UNDO.
    DEFINE VARIABLE objNum   AS INT     NO-UNDO.
    DEFINE VARIABLE cTmp     AS CHAR    NO-UNDO.
    DEFINE VARIABLE hasPrev  AS LOGICAL NO-UNDO.
    DEFINE BUFFER   b_File   FOR _File.

    IF objType = "table" THEN
        ASSIGN cObjName = wfil._File-name
               objNum = wfil._File-num. /* may be 0 if new table */
    ELSE DO:
        IF objType = "index" THEN DO:
            FIND b_File WHERE drec_file = RECID(b_File).
            ASSIGN cObjName = b_File._File-name + "." + widx._Index-name
                   objNum = widx._Idx-num. /* may be 0 if new indexx */
        END.
        ELSE DO: /* blob or clob */
            FIND b_File WHERE drec_file = RECID(b_File).
            ASSIGN cObjName = b_File._File-name + "." + wfld._Field-name
                   objNum = wfld._fld-stlen. /* may be area number if new field */
        END.
    END.

    IF cKeywd = "ENCRYPTION" OR cKeywd = "ENCRYPT" THEN DO:
       IF cValue = "NO" THEN DO:
           /* if we are changing the value, and there is a previous policy, this will
              not get loaded, so we will raise an error.
           */
           cValue = "".
           hasPrev = dictEPolicy:cacheObjForLoad(INPUT cObjName, INPUT objType,
                                                 INPUT objNum, INPUT-OUTPUT cValue).

           /* hasPrev is yes, if there is a previous policy version, and cipher is ? if the cipher is
             the same of the current policy (in this case, that encryption is already off)
           */
           IF cValue = ? THEN DO:
               ASSIGN ierror = 50
                      iwarn  = 26
                      warn_message = warn_text[26].
           END.
           ELSE IF hasPrev THEN DO:
               ierror = 63.
               RETURN ERROR.
           END.
           ELSE /* remember that there is a change to the policy*/
               ASSIGN hasEncPol = YES.
       END.
       ELSE DO:
           /* mark this so that we know whether they have an invalid .df, where they have
              a cipher without the encrypt keyword.
              Note that for 'encryption no' we can't have a cipher so we only do this
              here.
           */
           ASSIGN encryptOpts[1] = YES.
       END.
    END.
    ELSE DO:

       /* this signals that we found a cipher */
       ASSIGN  encryptOpts[2] = YES
               cValue = TRIM(cValue).

       /* check if it is a valid cipher */
       cTmp = dictEPolicy:CipherNames.
       IF cTmp = "" OR LOOKUP(cValue, cTmp) = 0 THEN DO:
           ierror = 64.
           RETURN ERROR.           
       END.                 

       /* if we are changing the value, and there is a previous policy, this will
          not get loaded, so we will raise an error.
       */
       hasPrev = dictEPolicy:cacheObjForLoad(INPUT cObjName, INPUT objType,
                                             INPUT objNum, INPUT-OUTPUT cValue).

       /* hasPrev is yes, if there is a previous policy version, and cipher is ? if the cipher is
         the same of the current policy.
       */
       IF cValue = ? THEN DO:
           ASSIGN ierror = 50
                  iwarn  = 26
                  warn_message = warn_text[26].
       END.
       ELSE IF hasPrev THEN DO:
           ierror = 63.
           RETURN ERROR.
       END.
       ELSE /* remember that there is a change to the policy*/
            ASSIGN hasEncPol = YES.
    END.
END.

/*-----------------------------------------------------
  save away buffer-pool settings
------------------------------------------------------*/
PROCEDURE addBufferPoolSetting.
    DEFINE INPUT PARAMETER objType AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER cKeywd  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER cValue  AS CHAR NO-UNDO.

    DEFINE VARIABLE cObjName AS CHAR    NO-UNDO.
    DEFINE VARIABLE objNum   AS INT     NO-UNDO.
    DEFINE VARIABLE cTmp     AS CHAR    NO-UNDO.
    DEFINE BUFFER   b_File   FOR _File.

    IF objType = "table" THEN
        ASSIGN cObjName = wfil._File-name
               objNum = wfil._File-num. /* may be 0 if new table */
    ELSE DO:
        IF objType = "index" THEN DO:
            FIND b_File WHERE drec_file = RECID(b_File).
            ASSIGN cObjName = b_File._File-name + "." + widx._Index-name
                   objNum = widx._Idx-num. /* may be 0 if new indexx */
        END.
        ELSE DO: /* blob or clob */
            FIND b_File WHERE drec_file = RECID(b_File).
            ASSIGN cObjName = b_File._File-name + "." + wfld._Field-name
                   objNum = wfld._fld-stlen. /* may be area number if new field */
        END.
    END.

    /* this signals that we found a cipher */
    ASSIGN cValue = TRIM(cValue).

    /* check if it is a valid pool name */
    cTmp = dictObjAttrs:BufferPoolNames.
    IF cTmp = "" OR LOOKUP(cValue, cTmp) = 0 THEN DO:
       ierror = 67.
       RETURN ERROR.           
    END.                 

    dictObjAttrs:cacheObjForLoad(INPUT cObjName, INPUT objType,
                                 INPUT objNum, INPUT-OUTPUT cValue).

    /* remember there is a change */
    ASSIGN hasBufPool = YES.
END.

/*==========================Mainline Code==============================*/

/* Fix problems which resulted when .rcode is run on Japanese DOS/WIN, 640x480
   while the .r-code was compiled/created with US fonts/Progress.ini
   Increase the frame size a little bit. 
*/
IF session:pixels-per-column = 6 AND session:width-pixels = 640 THEN
DO:
   FRAME working2:WIDTH-CHARS = FRAME working2:WIDTH-CHARS + msg1:column + 2.
   FRAME backout:WIDTH-CHARS = FRAME backout:WIDTH-CHARS + msg2:column + 2.
   FRAME errorlog:WIDTH-CHARS = FRAME errorlog:WIDTH-CHARS + msg3:column + dbload-e:column + msg4:column + 2.
  END.
       
ASSIGN
  cache_dirty = TRUE
  user_dbname = user_env[8]. /* for backwards compatibility with _lodsddl.p */

DO FOR _Db:
  FIND FIRST _Db
    WHERE _Db._Db-name = ( IF user_dbtype = "PROGRESS":u
                             THEN ?
                             ELSE user_dbname
                         )
    NO-ERROR.
  ASSIGN
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
  END.
  
/* Set up the name of the procedure to call to get stdtype info */
IF gate_dbtype <> "PROGRESS" THEN DO:
  {prodict/dictgate.i 
     &action=query 
     &dbtype=gate_dbtype 
     &dbrec =? 
     &output=scrap
     }
  gate_proc = "prodict/" + ENTRY(9,scrap) + "/_" + ENTRY(9,scrap) + "_typ.p".
  END.

ASSIGN dbload-e = LDBNAME("DICTDB") + ".e".

/* check if this is a 10.1B db at least, so that we complain about int64 and
   int64 values. If the 'Large Keys' feature is not known by this db, then this
   is a pre-101.B db 
*/
is-pre-101b-db = YES.

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

/* must be before assignment for codepage, since we assign it ourselves and not
  take the one from the trail. We want to check if the .df has settings for
  encryption policies (for encryption) so we can display errors that we can
  catch upfront, instead of waiting until we find the stuff which is at the
  end of the .df.
*/
{prodict/dump/lodtrail.i
  &entries = "IF lvar[i] BEGINS ""encpolicy=""
                 THEN hasEncPol = LOGICAL(SUBSTRING(lvar[i],11,-1,""character"")).
              IF lvar[i] BEGINS ""bufpool=""
                 THEN hasBufPool = LOGICAL(SUBSTRING(lvar[i],9,-1,""character""))."
  &file    = "user_env[2]"
  }  /* read trailer, sets variables: codepage and cerror */

ASSIGN codepage = IF user_env[10] = ""
                    THEN "UNDEFINED"
                    ELSE user_env[10]. /* set in _usrload.p */
IF codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? THEN
   ASSIGN cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".

IF cerror = ?
 THEN DO:  /* conversion needed but NOT possible */
  
  RUN adecomm/_setcurs.p ("").
  ASSIGN user_env[4] = "error". /* to signal error to _usrload */

  END.     /* conversion needed but NOT possible */

 ELSE DO FOR _Db, _file, _Field, _Index, _Index-field TRANSACTION:
          /* conversion not needed OR needed and possible */

  /* if an error happens at the end of the transaction, this will get
     undone (since it's an undo var) and we will know an error happened.
  */
  ASSIGN main_trans_success = YES.

  /* Call _setcurs.p before INPUT is set.  setcurs does a "PROCESS EVENTS"
     which in not legal if the input stream is a file. */
  SESSION:IMMEDIATE-DISPLAY = yes.
  RUN adecomm/_setcurs.p ("WAIT").

  IF cerror = "no-convert"
   THEN INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   ELSE INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
              CONVERT SOURCE codepage TARGET SESSION:CHARSET.

/* to cheat scoping mechanism * /
  IF FALSE THEN FIND NEXT _File.
  IF FALSE THEN FIND NEXT _Field.
  IF FALSE THEN FIND NEXT _Index. */
  IF FALSE THEN FIND NEXT wdbs.
  IF FALSE THEN FIND NEXT wfil.
  IF FALSE THEN FIND NEXT wfld.
  IF FALSE THEN FIND NEXT widx.
  IF FALSE THEN FIND NEXT wseq.
  
  FIND FIRST _Db WHERE RECID(_Db) = drec_db.
  
  DO ON STOP UNDO, LEAVE:

    /* if the .df is signaled as having encryption policies, we will try to
       get the object for loading the policies now, so that if there are
       any errors (such as encryption not enabled, not security db, 
       not local connection), we error out right away.
    */
    IF hasEncPol THEN DO:

       RUN checkEPolicy NO-ERROR.

       IF ierror > 0 AND NOT inoerror THEN DO:
         RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
         ASSIGN imod = "sp".
         RUN Show_Error ("curr").
         IF user_env[4] BEGINS "y":u AND NOT ierror = 50
          THEN DO:
           ASSIGN stopped = true.
           UNDO,LEAVE.
         END. 
       END.

       /* clear them */
       ASSIGN ierror = 0
              imod = ?
              hasEncPol = NO /* this has a new meaning now */.
    END.

    /* if the .df is signaled as having buffer-pool settings, we will try to
       get the object for loading the settings now, so that if there are
       any errors, we error out right away.
    */
    IF hasBufPool THEN DO:

       RUN checkObjAttrs NO-ERROR.

       IF ierror > 0 AND NOT inoerror THEN DO:
         RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
         ASSIGN imod = "sp".
         RUN Show_Error ("curr").
         IF user_env[4] BEGINS "y":u AND NOT ierror = 50
          THEN DO:
           ASSIGN stopped = true.
           UNDO,LEAVE.
         END. 
       END.

       /* clear them */
       ASSIGN ierror = 0
              imod = ?
              hasBufPool = NO /* this has a new meaning now */.
    END.
    
    /* when IMPORT hits the end, it generates ENDKEY.  This is how loop ends */
    load_loop:
    REPEAT ON ERROR UNDO,RETRY ON ENDKEY UNDO, LEAVE:

        /* 20060316-011  - we will not get back here for a retry, if the line we
         are processing is the left over of the previous line (see below where
         we move the tokens bcased on inum), in which case the client will not
         retry because there was no live io operation in that iteration of the
         block (such as the import statement, which we don't run when moving
         tokens that were left around). By explicitly adding the RETRY function
         here, we are guarantee to always retry when the code calls
         UNDO, RETRY.
      */
      IF RETRY THEN .

      IF ierror > 0 AND NOT inoerror THEN DO:
        RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
        RUN Show_Error ("curr").
        IF user_env[4] BEGINS "y":u AND NOT ierror = 50
         THEN DO:
          ASSIGN stopped = true.
          UNDO,LEAVE load_loop.
          END. 
        END.
      IF ierror > 0 AND ierror <> 50 THEN
        ASSIGN
          ierror = 0
          imod   = ?
          iobj   = ?.
      ELSE
        ASSIGN ierror = 0.
  
      /* Pop the top token off the top and move all the other tokens up one 
         so that ilin[1] is the next token to process.
      */
      IF ilin[1] <> ? THEN
        ASSIGN
            inum    = inum + (IF CAN-DO("OF,ON":u,ilin[inum + 1]) THEN 2 ELSE 0)
          ilin[1] = ilin[inum + 1]
          ilin[2] = ilin[inum + 2]
          ilin[3] = ilin[inum + 3]
          ilin[4] = ilin[inum + 4]
          ilin[5] = (IF inum + 5 > 9 THEN ? ELSE ilin[inum + 5])
          ilin[6] = (IF inum + 6 > 9 THEN ? ELSE ilin[inum + 6])
          ilin[7] = (IF inum + 7 > 9 THEN ? ELSE ilin[inum + 7])
          ilin[8] = (IF inum + 8 > 9 THEN ? ELSE ilin[inum + 8])
          ilin[9] = ?.

      /* If there's nothing of significant at the top of the array,
         read in the next line.  One token will go into each array element. 
      */
      DO WHILE ilin[1] BEGINS "#":u OR ilin[1] = "" OR ilin[1] = ?:
        ASSIGN
          ipos = ipos + 1
          ilin = ?.
        IMPORT ilin.
        END.
      inum = 0.
      ASSIGN stopped = true.
 
      IF CAN-DO(
        "ADD,CREATE,NEW,UPDATE,MODIFY,ALTER,CHANGE,DELETE,DROP,REMOVE,RENAME":u,
        ilin[1]) THEN DO:

        /* This is the start of a command - so copy the buffer values from 
             the last time through the loop into the database.
        */

        IF AVAILABLE wdbs AND imod <> ? THEN DO:
          RUN "prodict/dump/_lod_dbs.p".
          IF drec_db <> RECID(_Db)
            THEN FIND _Db WHERE RECID(_Db) = drec_db.
        END.
            
        IF AVAILABLE wfil AND imod <> ? THEN DO:
          IF wfil._For-type = ? AND user_dbtype <> "Progress" THEN DO:
            ASSIGN error_text[30] = substitute(error_text[30],_Db._Db-type)
                   ierror         = 30
                   user_env[4]    = "yes". /* to prevent 2. error-message at end */ 
          
            RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
            RUN Show_Error ("curr").
            IF do-commit THEN DO:
              MESSAGE "Unable to commit any updates since there is a type mismatch"
                  VIEW-AS ALERT-BOX WARNING.
              ASSIGN do-commit = FALSE.
            END.
            UNDO,LEAVE load_loop. /* no sense to continue */
          END.        /* table of foreign DB: type mismatch */       
          ELSE
            RUN "prodict/dump/_lod_fil.p".
        END.
         

        IF AVAILABLE wfld AND imod <> ? THEN DO:
          RUN "prodict/dump/_lod_fld.p"(INPUT-OUTPUT minimum-index).
        END.

        IF AVAILABLE widx
         AND imod <> ?
         THEN DO:
          RUN "prodict/dump/_lod_idx.p"(INPUT-OUTPUT minimum-index).
          END.

        IF AVAILABLE wseq
         AND imod <> ? THEN
            RUN "prodict/dump/_lod_seq.p".
 
        /* make sure we found both encryption and cipher settings (unless it was
          'encryption no', in which case we don't have a cipher).
        */
        IF encryptOpts[1] NE encryptOpts[2] THEN DO:
           ierror = 65.
        END.

        /* Error occurred when trying to save data from last command */
        IF ierror > 0 AND ierror <> 50 THEN DO:
          /* A client error occured and has been shown to the user.  They have
             selected to leave on first error so get out */
          IF ierror = 100 THEN UNDO,LEAVE load_loop.          
          RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
          RUN Show_Error ("prev").
          IF user_env[4] BEGINS "y":u THEN UNDO,LEAVE load_loop. 
          ierror = 0.
        END.
        ELSE IF ierror = 50 THEN DO:
         DO w = 1 TO NUM-ENTRIES(iwarnlst):
           ASSIGN iwarn = INTEGER(ENTRY(w, iwarnlst)).           
           IF iwarn = 23 THEN warn_text[23] = SUBSTITUTE(warn_text[23],wfld._Field-name,iarg).
           ELSE IF iwarn = 24 THEN warn_text[24] = SUBSTITUTE(warn_text[24],wfld._Field-name,iarg).
           ELSE IF iwarn = 25 THEN warn_text[25] = SUBSTITUTE(warn_text[25],wfld._Field-name,iarg).
           ELSE LEAVE.
           RUN Show_error ("prev").
         END.
         ASSIGN ierror = 0.
        END.
  
        /* delete temp file contents to start a new for this command */
        FOR EACH wdbs: DELETE wdbs. END.
        FOR EACH wfil: DELETE wfil. END.
        FOR EACH wfit: DELETE wfit. END.
        FOR EACH wfld: DELETE wfld. END.
        FOR EACH wflt: DELETE wflt. END.
        FOR EACH widx: DELETE widx. END.
        FOR EACH wixf: DELETE wixf. END.
        FOR EACH wseq: DELETE wseq. END.
  
        ASSIGN
          icomponent = 0
          iprimary   = FALSE
          inoerror   = FALSE
          imod       = ?
          iobj       = ?
          inum       = 3
          encryptOpts = NO.
    
          /* set the action mode */
        CASE ilin[1]:
          WHEN "ADD":u    OR WHEN "CREATE":u OR WHEN "NEW":u  THEN imod = "a":u.
          WHEN "UPDATE":u OR WHEN "MODIFY":u OR WHEN "ALTER":u OR WHEN "CHANGE":u
                                                            THEN imod = "m":u.
          WHEN "DELETE":u OR WHEN "DROP":u OR WHEN "REMOVE":u THEN imod = "d":u.
          WHEN "RENAME":u                                     THEN imod = "r":u.
          end case.
    
        /* set the object type */
        CASE ilin[2]:
          WHEN "DATABASE":u OR WHEN "CONNECT":u THEN iobj = "d":u.
          WHEN "FILE":u     OR WHEN "TABLE":u   THEN iobj = "t":u.
          WHEN "FIELD":u    OR WHEN "COLUMN":u  THEN iobj = "f":u.
          WHEN "INDEX":u    OR WHEN "KEY":u     THEN iobj = "i":u.
          WHEN "SEQUENCE":u                     THEN iobj = "s":u.
          end case.

        IF iobj = "t"
          AND ilin[4] = "TYPE"
          AND gate_dbtype <> ilin[5]
          THEN DO:  /* table of foreign DB: type mismatch */
          ASSIGN
            error_text[30] = substitute(error_text[30],_Db._Db-type)
            ierror         = 30
            user_env[4]    = "yes". /* to prevent 2. error-message at end */ 
          CREATE wfil. /* to be used in show-error */
          RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
          RUN Show_Error ("curr").
          UNDO,LEAVE load_loop. /* no sense to continue */
          END.        /* table of foreign DB: type mismatch */
        
       /* OE00176833
          we separate the following in its own sub-transaction because we may have 
          saved the changes for the previous object above, and in case there is an 
          error with the one we are about to process, we don't want to undo the 
          stuff done above. If the user chose to commit on errors, we would've lost
          the changes to that object too, which is not what we want to do.
       */
       ASSIGN got-error = YES.

       start_obj:
       DO ON ERROR UNDO, LEAVE:

        IF iobj = ? THEN DO:
          /* may be ADD [UNIQUE] [PRIMARY] [INACTIVE] INDEX name */
            IF CAN-DO("INDEX,KEY":u,ilin[3]) THEN
            ASSIGN
              iobj    = "i":u
              ilin[3] = ilin[4]  /* set name into slot 3 */
              ilin[4] = ilin[2]. /* move other opt[s] to end */
          ELSE
          IF CAN-DO("INDEX,KEY",ilin[4]) THEN
            ASSIGN
              iobj    = "i"
              ilin[4] = ilin[3]  /* move other opt[s] to end */
              ilin[3] = ilin[5]  /* set name into slot 3 */
              ilin[5] = ilin[2]. /* move other opt[s] to end */
          ELSE
          IF CAN-DO("INDEX,KEY",ilin[5]) THEN
            ASSIGN
              iobj    = "i"
              ilin[5] = ilin[3]  /* move other opt[s] to end */
              ilin[3] = ilin[6]  /* set name into slot 3 */
              ilin[6] = ilin[2]. /* move other opt[s] to end */
          END.
  
        /* complain */
        IF imod = ? THEN ierror = 1.  /* "Unknown action" */
        IF iobj = ? THEN ierror = 2.  /* "Unknown object" */
        IF ierror > 0 AND ierror <> 50 THEN UNDO,LEAVE start_obj.
  
        /* Reinitialize the buffers.  e.g., for add set the name of the
           object.  For modify, copy the existing record into the buffer.
           if working on a field or index, find the corresponding _File
           record as well.
        */    
        IF iobj = "d" THEN CREATE wdbs.
        IF iobj = "t" THEN CREATE wfil.
        IF iobj = "f" THEN CREATE wfld.
        IF iobj = "i" THEN CREATE widx.
        IF iobj = "s" THEN CREATE wseq.

        IF iobj = "d" THEN DO: /* start database action block */
          IF TERMINAL <> "" THEN 
            DISPLAY
              (IF ilin[3] = "?" THEN user_dbname ELSE ilin[3]) @ wdbs._Db-name
              "" @ wfil._File-name  "" @ wfld._Field-name
              "" @ widx._Index-name "" @ wseq._Seq-Name
              WITH FRAME working.
          IF imod = "a" THEN
            wdbs._Db-name = ilin[3].
          ELSE DO:
            IF ilin[3] = "?" THEN
              /* Comparing to the string value "?" fails whereas
                   comparing against the unknown value works.
              */
              FIND FIRST _Db WHERE _Db._Db-name = ? NO-ERROR.
            ELSE
              FIND FIRST _Db WHERE _Db._Db-name = ilin[3] NO-ERROR.
            IF NOT AVAILABLE _Db THEN DO:
              ASSIGN  wdbs._Db-name = ilin[3].
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,LEAVE start_obj.
              END.
              { prodict/dump/copy_dbs.i &from=_Db &to=wdbs }
            END.
          IF AVAILABLE _Db THEN drec_db = RECID(_Db).

          END. /* end database action block */
  
        IF iobj = "s" THEN DO: /* start sequence action block */
          IF TERMINAL <> "" THEN 
            DISPLAY 
              user_dbname @ wdbs._Db-name
              "" @ wfil._File-name  "" @ wfld._Field-name
              "" @ widx._Index-name ilin[3] @ wseq._Seq-Name
              WITH FRAME working.
          IF imod = "a" THEN DO:
            IF KEYWORD(ilin[3]) <> ? THEN DO:
              ASSIGN wseq._Seq-Name = ilin[3]
                     ierror = 45.
              UNDO, LEAVE start_obj.
            END.
            ELSE
              ASSIGN wseq._Seq-Name = ilin[3].
          END.          
          ELSE DO:
            FIND FIRST _Sequence WHERE _Sequence._Seq-Name = ilin[3] NO-ERROR.
            IF NOT AVAILABLE _Sequence THEN DO:    
              ASSIGN wseq._Seq-name = ilin[3].
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,LEAVE start_obj.             
            END.   
            IF imod = "r" THEN DO:
              IF KEYWORD(ilin[5]) <> ? THEN DO:
                ASSIGN wseq._Seq-Name = ilin[3]
                       ierror = 45.
                UNDO, LEAVE start_obj.
              END.
            END.
            { prodict/dump/copy_seq.i &from=_Sequence &to=wseq }
            END.
          END. /* end sequence action block */
  
        /* position _file record */
        IF (iobj = "d" OR iobj = "s") OR (imod = "a" AND iobj = "t") THEN .
        ELSE DO:
          scrap = ?.
          IF iobj = "t"                   THEN scrap = ilin[3].
          ELSE IF CAN-DO("OF,ON",ilin[4]) THEN scrap = ilin[5].
          ELSE IF CAN-DO("OF,ON",ilin[5]) THEN scrap = ilin[6].
          ELSE IF CAN-DO("OF,ON",ilin[6]) THEN scrap = ilin[7].
          ELSE IF CAN-DO("OF,ON",ilin[7]) THEN scrap = ilin[8].
          IF scrap = ? THEN .
          ELSE
          IF AVAILABLE _Db THEN DO:
            IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
              FIND _File OF _Db WHERE _File._File-name = scrap 
                                  AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
            ELSE 
              FIND _File OF _Db WHERE _File._File-name = scrap NO-ERROR.
          END.
          ELSE DO:
            IF INTEGER(DBVERSION(user_dbname)) > 8 THEN
               FIND FIRST _File WHERE _File._File-name = scrap 
                            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
            ELSE
               FIND FIRST _File WHERE _File._File-name = scrap NO-ERROR.
          END.  
       
          IF AVAILABLE _File AND NOT AVAILABLE _Db THEN DO:
            FIND _Db OF _File.
            drec_db = RECID(_Db).
            END.
          IF scrap <> ? AND AVAILABLE _File THEN drec_file = RECID(_File).              
          END.
  
        IF iobj = "t" THEN DO: /* start file action block */
          IF TERMINAL <> "" THEN 
            DISPLAY user_dbname @ wdbs._Db-name
                    ilin[3] @ wfil._File-name "" @ wfld._Field-name 
                    "" @ widx._Index-name "" @ wseq._Seq-Name
                      WITH FRAME working.
          IF imod = "a" THEN DO:
            IF KEYWORD(ilin[3]) <> ? THEN DO:
                ASSIGN wfil._File-name = ilin[3]
                       ierror = 45.
                UNDO, LEAVE start_obj.
            END.
            ELSE
                ASSIGN wfil._File-name = ilin[3].
          END.
          ELSE DO:
            IF NOT AVAILABLE _File THEN DO:
              ASSIGN wfil._File-name = ilin[3].
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,LEAVE start_obj.
            END.
            IF imod = "r" THEN DO:
              IF KEYWORD(ilin[5]) <> ? THEN DO:
                ASSIGN wfil._File-name = ilin[3] 
                       ierror = 45.
                UNDO, LEAVE start_obj.
              END.
            END.
            { prodict/dump/copy_fil.i &from=_File &to=wfil &all=true}

            FOR EACH _File-trig OF _File:
              CREATE wfit.
              { prodict/dump/copy_fit.i &from=_File-trig &to=wfit }
              END.
            END.
          END. /* end file action block */
  
        IF iobj = "f" THEN DO: /* start field action block */
          IF NOT AVAILABLE _File AND drec_file <> ? THEN
            FIND _File WHERE drec_file = RECID(_File) NO-ERROR.
          IF NOT AVAILABLE _File THEN DO:
            ierror = 5. /* "Try to modify &2 without file" */
            UNDO,LEAVE start_obj.
          END.
          ELSE IF AVAILABLE _File AND _file._File-name <> ilin[5] THEN
            FIND _file WHERE _file._file-name = ilin[5]
                          AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
          IF NOT AVAILABLE _File THEN DO:
            ierror = 5. /* "Try to modify &2 without file" */
            UNDO,LEAVE start_obj.
          END.
          IF TERMINAL <> "" THEN 
            DISPLAY _File._File-name @ wfil._File-name
                                 ilin[3] @ wfld._Field-name 
                                 "" @ widx._Index-name
                    WITH FRAME working.

          IF imod = "a" THEN DO:
            IF KEYWORD(ilin[3]) <> ? THEN DO:
                ASSIGN wfld._Field-name = ilin[3] 
                       ierror = 45.
                UNDO, LEAVE start_obj.
            END.
            ELSE
              ASSIGN wfld._Field-name = ilin[3]    
                     wfld._Initial    = "". /* to be checkable in _lod_fld */
          END.
          ELSE DO:
            FIND _Field OF _File WHERE _Field._Field-name = ilin[3] NO-ERROR.
            IF NOT AVAILABLE _Field THEN DO:
              ASSIGN wfld._Field-name = ilin[3].
              ierror = 3. /* "Try to modify unknown &2" */
              UNDO,LEAVE start_obj.
            END.
            IF imod = "r" THEN DO:
              IF KEYWORD(ilin[7]) <> ? THEN DO:
                ASSIGN wfld._Field-name = ilin[3] 
                       ierror = 45.
                UNDO, LEAVE start_obj.
              END.
            END.

            { prodict/dump/copy_fld.i &from=_Field &to=wfld &all=true}

            FOR EACH _Field-trig OF _Field:
              CREATE wflt.
              { prodict/dump/copy_flt.i &from=_Field-trig &to=wflt }
              END.
            END.
          END. /* end field action block */
  
          IF iobj = "i" THEN DO: /* start index action block */
            IF NOT AVAILABLE _File AND drec_file <> ? THEN
              FIND _File WHERE drec_file = RECID(_File) NO-ERROR.
            IF NOT AVAILABLE _File THEN DO:
              ierror = 5. /* "try to modify index w/o file" */
              UNDO,LEAVE start_obj.
            END.
            ELSE IF AVAILABLE _File THEN DO k = 4 TO 8:
              IF ilin[k] = "ON" THEN DO:
                IF _File._File-name <> ilin[k + 1] THEN DO:                  
                  FIND _File WHERE _File._file-name = ilin[k + 1] 
                               AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
                  ASSIGN k = 8.
                END.
              END.
            END.
            IF NOT AVAILABLE _File THEN DO:
              ierror = 5.  /* "Try to modify &2 without file" */
              UNDO,LEAVE start_obj.
            END.
         
            IF TERMINAL <> "" THEN 
              DISPLAY _File._File-name @ wfil._File-name
                                 "" @ wfld._Field-name
                    ilin[3] @ widx._Index-name 
                WITH FRAME working.

            IF imod = "a" THEN DO:
              IF KEYWORD(ilin[3]) <> ? THEN DO:
                ASSIGN widx._Index-name = ilin[3]
                       ierror = 45.
                UNDO, LEAVE start_obj.
              END.
              ELSE           
              ASSIGN widx._Index-name = ilin[3]
                     widx._Unique     = FALSE. /* different from schema default of TRUE */
            END.
            ELSE DO:
              FIND _Index OF _File WHERE _Index._Index-name = ilin[3] NO-ERROR.
              IF NOT AVAILABLE _Index THEN DO:
                ASSIGN widx._Index-name = ilin[3].
                ierror = 3. /* "Try to modify unknown &2" */
                UNDO,LEAVE start_obj.
              END.
              IF imod = "r" THEN DO:
                IF KEYWORD(ilin[5]) <> ? THEN DO:
                  ASSIGN widx._Index-name = ilin[3]
                         ierror = 45.
                  UNDO, LEAVE start_obj.
                END.
              END.

             { prodict/dump/copy_idx.i &from=_Index &to=widx }
           
            END.
          END. /* end index action block */
          ASSIGN got-error = NO.
        END.  /* start_obj block */

        IF got-error THEN
           NEXT load_loop.

      END. /* end of block handling action keyword */

    /* inot - is used for logical keywords that have no argument but where
              the keyword indicates the yes/no value of the field.
       inum - is the number of tokens (keyword plus arguments)  It is set to
              3 above when ilin[1] is the action word (e.g., ADD) and not
              one of the field values (e.g., DATA-TYPE Character)
       ikwd - is the keyword.
       iarg - is the field value.
    */
      IF inum <> 3 THEN
        ASSIGN
          ikwd   = ilin[1]
          iarg   = ilin[2]
          inot   = FALSE
          inum   = 2
          inot   = (ikwd BEGINS "NOT-")
          ikwd   = SUBSTRING(ikwd, IF inot THEN 5 ELSE 1, -1, "CHARACTER")
          inum   = (IF ikwd = "NO-ERROR"
                 OR (iobj = "t" AND CAN-DO("FROZEN,HIDDEN",ikwd))
                 OR (iobj = "f" AND CAN-DO("MAND*,NULL,NULL-A*,CASE-SENS*",ikwd))
                 OR (iobj = "i" AND CAN-DO("UNIQUE,INACTIVE,PRIMARY,WORD",ikwd))
                 THEN 1 ELSE 2)
          iarg   = (IF inum = 2 THEN iarg ELSE (IF inot THEN "no" ELSE "yes")).
  
    /* Load the value from the .df file into the appropriate field
       of the object we're working on.
    */
      IF inum = 3 THEN .
      ELSE IF ikwd = "NO-ERROR" THEN inoerror = TRUE.
      ELSE IF imod = "r" AND ilin[1] = "TO" THEN irename = ilin[2].

      ELSE IF iobj = "d" THEN DO: /*------------- DB-CASE ----------------------*/
  
        CASE ikwd:
          WHEN "DBNAME"  OR WHEN "ADDRESS"     THEN wdbs._Db-addr     = iarg.
          WHEN "PARAMS"  OR WHEN "COMM"        THEN wdbs._Db-comm     = iarg.
          WHEN "CONNECT" OR WHEN "DATABASE"    THEN wdbs._Db-name     = iarg.
          WHEN "TYPE"                          THEN wdbs._Db-type     = iarg.
          WHEN "DB-MISC11"                     THEN wdbs._Db-misc1[1] = INTEGER(iarg).
          WHEN "DB-MISC12"                     THEN wdbs._Db-misc1[2] = INTEGER(iarg).
          WHEN "DB-MISC13"                     THEN wdbs._Db-misc1[3] = INTEGER(iarg).
          WHEN "DB-MISC14"                     THEN wdbs._Db-misc1[4] = INTEGER(iarg).
          WHEN "DB-MISC15"                     THEN wdbs._Db-misc1[5] = INTEGER(iarg).
          WHEN "DB-MISC16"                     THEN wdbs._Db-misc1[6] = INTEGER(iarg).
          WHEN "DB-MISC17"                     THEN wdbs._Db-misc1[7] = INTEGER(iarg).
          WHEN "DB-MISC18"                     THEN wdbs._Db-misc1[8] = INTEGER(iarg).
          WHEN "DRIVER-NAME"                   THEN wdbs._Db-misc2[1] = iarg.
          WHEN "DRIVER-VERS"                   THEN wdbs._Db-misc2[2] = iarg.
          WHEN "ESCAPE-CHAR"                   THEN wdbs._Db-misc2[3] = iarg.
          WHEN "DRIVER-CHARS"                  THEN wdbs._Db-misc2[4] = iarg.
          WHEN "DBMS-VERSION"                  THEN wdbs._Db-misc2[5] = iarg.
          WHEN "DSRVR-VERSION"                 THEN wdbs._Db-misc2[6] = iarg.
          WHEN "PROGRESS-VERSION"              THEN wdbs._Db-misc2[7] = iarg.
          WHEN "DSRVR-MISC"                    THEN wdbs._Db-misc2[8] = iarg.
          WHEN "COLLATION-TRANSLATION-VERSION" THEN DO:
            /* Store the first part of the version e.g., 2.0 in collate[5].
               The whole version format is m.n-x
            */
            ASSIGN
                   ct_version = iarg
                   ix         = INDEX(ct_version, "-").
            orig_vers = wdbs._Db-collate[5].
            IF SUBSTR(ct_version, 1, ix - 1, "CHARACTER") >= "6.0" THEN DO:
              user_env[4] = "y". /* stop the load - db will be corrupted. */
              ierror = 27.
            END.
            ASSIGN
                   ix                             = INDEX(ct_version, ".")
                   wdbs._Db-collate[5]            = raw_val /* to replace ?, if there */
                   PUTBYTE(wdbs._Db-collate[5],1) = 
                            INTEGER(SUBSTR(ct_version, 1, ix - 1, "CHARACTER"))
                   ix                             = ix + 1
                   len                            = INDEX(ct_version, "-") - ix
                   PUTBYTE(wdbs._Db-collate[5],2) = 
                            INTEGER(SUBSTR(ct_version, ix, len, "CHARACTER")).
            IF orig_vers <> wdbs._Db-collate[5] THEN ct_changed = yes.
          END.
          WHEN     "TRANSLATION-NAME"   
           OR WHEN "CODEPAGE-NAME"            THEN wdbs._Db-xl-name = iarg.
          WHEN "COLLATION-NAME"               THEN wdbs._Db-coll-name = iarg.
          WHEN "INTERNAL-EXTERNAL-TRAN-TABLE" THEN 
                                           RUN Load_Tran_Collate_Tbl ("_Db-xlate", 1).
          WHEN "EXTERNAL-INTERNAL-TRAN-TABLE" THEN 
                                           RUN Load_Tran_Collate_Tbl ("_Db-xlate",2).
          WHEN "CASE-INSENSITIVE-SORT"        THEN
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate",1).
          WHEN "CASE-SENSITIVE-SORT"          THEN
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate",2).
          WHEN "UPPERCASE-MAP"                THEN 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate",3).
          WHEN "LOWERCASE-MAP"                THEN 
                                           RUN Load_Tran_Collate_Tbl ("_Db-collate",4).
          WHEN "ICU-RULES"                THEN
            IF SUBSTRING(ct_version,1,2) <> "5." THEN
              ASSIGN ierror = 4.
            ELSE DO:
              j = 0.
              DO i = 29 TO 32:
                j = j * 256 + GET-BYTE(wdbs._DB-collate[1],  i).
              END.
                                               
              RUN Load_Icu_Rules ( INPUT-OUTPUT j ) .
              IF RETURN-VALUE NE "" THEN ierror = 40.
              ELSE DO:
	        IF cerror = "no-convert" THEN 
		  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
	        ELSE 
	          INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
                          CONVERT SOURCE codepage TARGET SESSION:CHARSET.
                REPEAT:
                  IMPORT UNFORMATTED ILIN[1].
                  IF TRIM(ILIN[1]) = "END-RULES" THEN LEAVE.
                END.
                ILIN[1] = ?.
              END.

            END.
 
          OTHERWISE
            ASSIGN ierror = 4. /* "Unknown &2 keyword" */
          END CASE.
  
        END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "s" THEN DO: /*--------------------------------------------*/
  
        CASE ikwd:
          WHEN "SEQUENCE"       THEN wseq._Seq-Name = iarg.
          WHEN "INITIAL"        THEN do:
              /* this is just to catch an integer overflow */
              IF is-pre-101b-db THEN
                 ASSIGN wseq._Seq-Init = INT(IARG) NO-ERROR.
              ELSE
                 ASSIGN wseq._Seq-Init = INT64(IARG) NO-ERROR.

              IF ERROR-STATUS:ERROR THEN
                  ASSIGN ierror = 53.
              ELSE
                 ierror = 0.

          END.
          WHEN "INCREMENT"      THEN DO: 

              /* this is just to catch an integer overflow */
              IF is-pre-101b-db THEN
                 ASSIGN wseq._Seq-Incr = INT(IARG) NO-ERROR.
              ELSE
                 ASSIGN wseq._Seq-Incr = INT64(IARG) NO-ERROR.

              IF ERROR-STATUS:ERROR THEN
                  ASSIGN ierror = 53.
              ELSE
                 ierror = 0.

          END.
          WHEN "CYCLE-ON-LIMIT" THEN wseq._Cycle-Ok = (iarg = "yes").
          WHEN "MIN-VAL"        THEN DO: 
              /* this is just to catch an integer overflow */
              IF is-pre-101b-db THEN
                 ASSIGN wseq._Seq-Min = INT(IARG) NO-ERROR.
              ELSE
                 ASSIGN wseq._Seq-Min = INT64(IARG) NO-ERROR.

              IF ERROR-STATUS:ERROR THEN
                  ASSIGN ierror = 53.
              ELSE
                 ierror = 0.
          END.
          WHEN "MAX-VAL"        THEN DO:
              /* this is just to catch an integer overflow */
              IF is-pre-101b-db THEN
                 ASSIGN wseq._Seq-Max = INT(IARG) NO-ERROR.
              ELSE
                 ASSIGN wseq._Seq-Max = INT64(IARG) NO-ERROR.

              IF ERROR-STATUS:ERROR THEN
                  ASSIGN ierror = 53.
              ELSE
                 ierror = 0.
          END.
          WHEN "FOREIGN-NAME"   THEN wseq._Seq-Misc[1] = iarg.
          WHEN "FOREIGN-OWNER"  THEN wseq._Seq-Misc[2] = iarg.
          /* keywords for seq-misc elements 3-8 */ 
          WHEN "SEQ-MISC3"      THEN wseq._Seq-Misc[3] = iarg.
          WHEN "SEQ-MISC4"      THEN wseq._Seq-Misc[4] = iarg.
          WHEN "SEQ-MISC5"      THEN wseq._Seq-Misc[5] = iarg.
          WHEN "SEQ-MISC6"      THEN wseq._Seq-Misc[6] = iarg.
          WHEN "SEQ-MISC7"      THEN wseq._Seq-Misc[7] = iarg.
          WHEN "SEQ-MISC8"      THEN wseq._Seq-Misc[8] = iarg.

          OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
  
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "t" THEN DO: /*--------------------------------------------*/ 
        CASE ikwd:
          WHEN    "FILE"       
          OR WHEN "TABLE"          THEN wfil._File-name    = iarg.
          WHEN    "AREA"           THEN DO:
             ASSIGN iarg = ""
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
             FIND _AREA WHERE _Area._Area-name = iarg NO-LOCK NO-ERROR.
             IF AVAILABLE _Area THEN   
                 ASSIGN file-area-number   = _Area._Area-number.
             ELSE
                 ASSIGN ierror = 31.                
          END.           
          WHEN    "CAN-CREATE"
          OR WHEN "CAN-INSERT"     THEN wfil._Can-Create   = iarg.
          WHEN    "CAN-READ"
          OR WHEN "CAN-SELECT"     THEN wfil._Can-Read     = iarg.
          WHEN    "CAN-WRITE"
          OR WHEN "CAN-UPDATE"     THEN wfil._Can-Write    = iarg.
          WHEN    "CAN-DELETE"     THEN wfil._Can-Delete   = iarg.
          WHEN    "CAN-DUMP"       THEN wfil._Can-Dump     = iarg.
          WHEN    "CAN-LOAD"       THEN wfil._Can-Load     = iarg.
          WHEN    "TYPE"           THEN wfil._Db-lang      = LOOKUP(iarg,"SQL").
          WHEN    "LABEL"          THEN wfil._File-Label   = iarg.
          WHEN    "LABEL-SA"       THEN wfil._File-Label-SA = iarg. 
          WHEN    "DESCRIPTION"    THEN wfil._Desc         = iarg.
          WHEN    "VALEXP"         THEN wfil._Valexp       = TRIM(iarg).
          WHEN    "VALMSG"         THEN wfil._Valmsg       = iarg.
          WHEN    "VALMSG-SA"      THEN wfil._Valmsg-SA    = iarg.
          WHEN    "FROZEN"         THEN wfil._Frozen       = (iarg = 'yes').
          WHEN    "HIDDEN"         THEN wfil._Hidden       = (iarg = 'yes').
          WHEN    "DUMP-NAME"      THEN DO:
              /* check that there are no spaces in the dump name */
              IF INDEX(iarg, " ") > 0 THEN
                ASSIGN ierror = 54.
              ELSE
                wfil._Dump-name    = iarg.
          END.
          WHEN    "FOREIGN-FLAGS"  THEN wfil._For-Flag     = INTEGER(iarg).
          WHEN    "FOREIGN-FORMAT" THEN wfil._For-Format   = iarg.
          WHEN    "FOREIGN-GLOBAL" THEN wfil._For-Cnt1     = INTEGER(iarg).
          WHEN    "FOREIGN-ID"     THEN wfil._For-Id       = INTEGER(iarg).
          WHEN    "FOREIGN-LEVEL"  THEN wfil._Fil-misc1[4] = INTEGER(iarg).
          WHEN    "FOREIGN-LOCAL"  THEN wfil._For-Cnt2     = INTEGER(iarg).
          WHEN    "FOREIGN-MARK"   THEN wfil._For-Info     = iarg.
          WHEN    "FOREIGN-NAME"   THEN wfil._For-Name     = iarg.
          WHEN    "FOREIGN-NUMBER" THEN wfil._For-number   = INTEGER(iarg).
          WHEN    "FOREIGN-OWNER"  THEN wfil._For-Owner    = iarg.
          WHEN    "FOREIGN-SIZE"   THEN ASSIGN
                                        wfil._For-Size     = INTEGER(iarg).
          WHEN    "PROGRESS-RECID"  
          OR WHEN "FILE-MISC11"    THEN wfil._Fil-misc1[1] = INTEGER(iarg).
          WHEN    "FOREIGN-SPAN"   THEN wfil._Fil-misc1[2] = LOOKUP(iarg,"yes").
          WHEN    "FILE-MISC12"    THEN wfil._Fil-misc1[2] = INTEGER(iarg).
          WHEN    "INDEX-FREE-FLD"  
          OR WHEN "FILE-MISC13"    THEN wfil._Fil-misc1[3] = INTEGER(iarg).
          WHEN    "OVERLOAD-NR"     
          OR WHEN "RECID-COL-NO"     
          OR WHEN "FILE-MISC14"    THEN wfil._Fil-misc1[4] = INTEGER(iarg).
          WHEN    "FILE-MISC15"    THEN wfil._Fil-misc1[5] = INTEGER(iarg).
          WHEN    "FILE-MISC16"    THEN wfil._Fil-misc1[6] = INTEGER(iarg).
          WHEN    "FILE-MISC17"    THEN wfil._Fil-misc1[7] = INTEGER(iarg).
          WHEN    "FILE-MISC18"    THEN wfil._Fil-misc1[8] = INTEGER(iarg).
          WHEN    "FOREIGN-TYPE"   THEN wfil._For-Type     = iarg.
          WHEN    "QUALIFIER"       
          OR WHEN "FILE-MISC21"    THEN wfil._Fil-misc2[1] = iarg.
          WHEN    "HIDDEN-FLDS"     
          OR WHEN "FILE-MISC22"    THEN wfil._Fil-misc2[2] = iarg.
          WHEN    "RECID-FLD-NAME"  
          OR WHEN "FILE-MISC23"    THEN wfil._Fil-misc2[3] = iarg.
          WHEN    "FLD-NAMES-LIST"  
          OR WHEN "FILE-MISC24"    THEN wfil._Fil-misc2[4] = iarg.
          WHEN    "FILE-MISC25"    THEN wfil._Fil-misc2[5] = iarg.
          WHEN    "FILE-MISC26"    THEN wfil._Fil-misc2[6] = iarg.
          WHEN    "FILE-MISC27"    THEN wfil._Fil-misc2[7] = iarg.
          WHEN    "DB-LINK-NAME"    
          OR WHEN "FILE-MISC28"    THEN wfil._Fil-misc2[8] = iarg.
          WHEN    "FILE-TRIGGER"
          OR WHEN "TABLE-TRIGGER"  THEN DO:
                FIND FIRST wfit WHERE wfit._Event = iarg NO-ERROR.
                IF NOT AVAILABLE wfit THEN CREATE wfit.
                wfit._Event = ilin[2].
                CASE ilin[3]:
                  WHEN    "DELETE"
                  OR WHEN "DROP"
                  OR WHEN "REMOVE"      THEN wfit._Proc-Name = "!":u.
                  WHEN    "OVERRIDE"    THEN wfit._Override  = TRUE.
                  WHEN    "NO-OVERRIDE" THEN wfit._Override  = FALSE.
                  end case.
                IF ilin[4] = "PROCEDURE":u THEN wfit._Proc-Name = ilin[5].
                IF ilin[6] = "CRC" THEN wfit._Trig-CRC = 
                  (IF ilin[7] = ? THEN ? ELSE INTEGER(ilin[7])).
                ilin = ?.
                END.
          WHEN    "ENCRYPTION" 
          OR WHEN "ENCRYPT"
          OR WHEN "CIPHER-NAME" THEN DO:
              /* this will raise error if something is wrong */
              RUN checkEPolicy.
              RUN addEncryptionSetting("table", iKwd , iarg).
          END.
          WHEN "BUFFER-POOL" THEN DO:
              /* this will raise error if something is wrong */
              RUN checkObjAttrs.
              RUN addBufferPoolSetting("table", iKwd , iarg).
          END.
          OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.  
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "f" THEN DO: /*--------------------------------------------*/
  
        CASE ikwd:
          WHEN    "AS" OR WHEN "TYPE" THEN 
              ASSIGN wfld._Data-type = (IF iarg = "boolean" THEN "logical"
                               ELSE IF iarg = "dbkey"   THEN "recid" 
                               ELSE iarg).                     
          WHEN    "FIELD"     OR WHEN "COLUMN"      THEN wfld._Field-name = iarg.
          WHEN    "DESC"      OR WHEN "DESCRIPTION" THEN wfld._Desc = iarg.
          WHEN    "INITIAL"   OR WHEN "DEFAULT"     THEN DO:
              /* check for integer overflow */
              IF LOOKUP(wfld._Data-Type,"INT,INTEGER") > 0 THEN DO:
                  /* if this is a pre-101b db, just make sure initial
                     value for an integer is not too big. In theory,
                     this could not happen since a field needs to be int64
                     to overflow an integer, and we already prevent int64 from
                     loading into a pre-10.1B db, but just in case the .df
                     was manually changed.
                  */
                  IF is-pre-101b-db THEN DO:
                      /* this is just to catch an integer overflow */
                     ASSIGN ierror = INT(iarg) NO-ERROR.
                     IF ERROR-STATUS:ERROR THEN
                         ASSIGN ierror = 52.
                     ELSE
                         ierror = 0.
                  END.
              END.

              wfld._Initial = iarg.
          END.
          WHEN    "CAN-READ"  OR WHEN "CAN-SELECT"  THEN wfld._Can-Read = iarg.
          WHEN    "CAN-WRITE" OR WHEN "CAN-UPDATE"  THEN wfld._Can-Write = iarg.
          WHEN    "NULL" OR WHEN "NULL-ALLOWED" THEN wfld._Mandatory = (iarg = "no").
          WHEN    "SQL-WIDTH" OR WHEN "MAX-WIDTH" OR WHEN "LOB-BYTES" THEN DO:
	         wfld._Width = INTEGER(iarg).
             IF LOOKUP(wfld._Data-Type,"CHARACTER,CHAR,DECIMAL,DEC,RAW") > 0 OR
             wfld._Extent > 0 THEN
                IF INTEGER(iarg) > 31995 THEN
                   ASSIGN ierror = 50
		                  iwarn  = {&WARN_MSG_SQLW}
		                  warn_message = SUBSTITUTE(warn_text[{&WARN_MSG_SQLW} + 1],wfld._Field-name,iarg).
          END.
          WHEN "LOB-AREA" THEN DO:
            /* Area names can have space*/
            ASSIGN iarg = ""
                    j    = 2.
            _areafloop:
            DO WHILE TRUE:
              IF ilin[j] = ? OR ilin[j] = "" THEN DO:
                ASSIGN iarg = SUBSTRING(iarg, 1, (LENGTH(iarg) - 1))
                       ilin = "".
                LEAVE _areafloop.
              END.
              ELSE 
                ASSIGN iarg = iarg + ilin[j] + " "
                       j = j + 1.
            END.     
            FIND _AREA WHERE _Area._Area-name = iarg NO-LOCK NO-ERROR.
            IF AVAILABLE _Area THEN   
                 ASSIGN wfld._Fld-stlen   = _Area._Area-number.
             ELSE
                 ASSIGN ierror = 31. 
          END.
          WHEN    "CLOB-CODEPAGE"          THEN wfld._Charset = iarg.
          WHEN    "CLOB-COLLATION"         THEN wfld._Collation = iarg.
          WHEN    "CLOB-TYPE"              THEN wfld._Attributes1 = INTEGER(iarg).
          WHEN    "FORMAT"                 THEN wfld._Format = iarg.
          WHEN    "FORMAT-SA"              THEN wfld._Format-SA = iarg.
          WHEN    "LABEL"                  THEN wfld._Label = iarg.
          WHEN    "LABEL-SA"               THEN wfld._Label-SA = iarg.
          WHEN    "COLUMN-LABEL"           THEN wfld._Col-label = iarg.
          WHEN    "COLUMN-LABEL-SA"        THEN wfld._Col-label-SA = iarg.
          WHEN    "INITIAL-SA"             THEN wfld._Initial-SA = iarg.
          WHEN    "POSITION"               THEN wfld._Field-rpos = INTEGER(iarg).
          WHEN    "VALEXP"                 THEN wfld._Valexp = TRIM(iarg).
          WHEN    "VALMSG"                 THEN wfld._Valmsg = iarg.
          WHEN    "VALMSG-SA"              THEN wfld._Valmsg-SA = iarg.
          WHEN    "VIEW-AS"                THEN wfld._View-As = iarg.
          WHEN    "HELP"                   THEN wfld._Help = iarg.
          WHEN    "HELP-SA"                THEN wfld._Help-SA = iarg.
          WHEN    "EXTENT"                 THEN wfld._Extent = INTEGER(iarg).
          WHEN    "DECIMALS"               THEN DO:
              wfld._Decimals      = INTEGER(iarg).

              /*  20041202-001  allow .df to contain DECIMALS ? for any data type 
                 which is the default value for non-decimal fields anyway
              */
              IF wfld._Decimals <> ? AND wfld._Data-type <> "decimal" AND wfld._Data-type <> "dec" THEN
                  ASSIGN ierror = 50
                         iwarn  = 25
                         warn_message = SUBSTITUTE(warn_text[25],wfld._Field-name)
                         wfld._Decimals = ?.
          END.
          WHEN "LENGTH" 
          OR WHEN "SCALE"           THEN
          DO:
                  wfld._Decimals      = INTEGER(iarg).
          END.
          WHEN    "FOREIGN-BITS"           THEN wfld._Decimals      = INTEGER(iarg).
          WHEN    "ORDER"                  THEN wfld._Order         = INTEGER(iarg).
          WHEN    "MANDATORY"              THEN wfld._Mandatory     = (iarg = "yes").
          WHEN    "CASE-SENSITIVE"         THEN wfld._Fld-case      = (iarg = "yes").
          WHEN    "FOREIGN-ALLOCATED"      THEN wfld._For-Allocated = INTEGER(iarg).
          WHEN    "FOREIGN-CODE"           THEN wfld._For-Itype     = INTEGER(iarg).
          WHEN    "FOREIGN-ID"             THEN wfld._For-Id        = INTEGER(iarg).
          WHEN    "FOREIGN-MARK"           THEN . /* unused in V7 */
          WHEN    "FOREIGN-MAXIMUM"        THEN wfld._For-Maxsize   = INTEGER(iarg).
          WHEN    "FOREIGN-NAME"           THEN wfld._For-Name      = iarg.
          WHEN    "FOREIGN-POS"            THEN ASSIGN
                                                wfld._Fld-stoff     = INTEGER(iarg)
                                                l_Fld-stoff         = wfld._Fld-stoff.
          WHEN    "FOREIGN-RETRIEVE"       THEN wfld._For-retrieve  = (iarg = "yes").
          WHEN    "FOREIGN-SCALE"          THEN wfld._For-Scale     = INTEGER(iarg).
          WHEN    "FOREIGN-SEP"            THEN wfld._For-Separator = iarg.
          WHEN    "FOREIGN-SIZE"           THEN ASSIGN
                                                wfld._Fld-stlen     = INTEGER(iarg)
                                                l_Fld-stlen         = wfld._Fld-stlen.
          WHEN    "FOREIGN-SPACING"        THEN wfld._For-Spacing   = INTEGER(iarg).
          WHEN    "FOREIGN-TYPE"           THEN DO:

             IF wfld._Data-type = "character" AND wfld._Initial = ""
                AND (iarg = "time" OR iarg = "timestamp") THEN
                wfld._Initial = ?.
             wfld._For-Type = iarg.
          
             END.

          WHEN    "FOREIGN-XPOS"           THEN wfld._For-Xpos      = INTEGER(iarg).
          WHEN    "DSRVR-PRECISION"         
          OR WHEN "FIELD-MISC11"           THEN wfld._Fld-misc1[1]  = INTEGER(iarg).
          WHEN    "DSRVR-SCALE"                    
          OR WHEN "FIELD-MISC12"           THEN wfld._Fld-misc1[2]  = INTEGER(iarg).
          WHEN    "DSRVR-LENGTH"            
          OR WHEN "FIELD-MISC13"           THEN wfld._Fld-misc1[3]  = INTEGER(iarg).
          WHEN    "DSRVR-FLDMISC"            
          OR WHEN "FIELD-MISC14"           THEN wfld._Fld-misc1[4]  = INTEGER(iarg).
          WHEN    "DSRVR-SHADOW"            
          OR WHEN "FIELD-MISC15"           THEN wfld._Fld-misc1[5]  = INTEGER(iarg).
          WHEN    "FIELD-MISC16"           THEN wfld._Fld-misc1[6]  = INTEGER(iarg).
          WHEN    "FIELD-MISC17"           THEN wfld._Fld-misc1[7]  = INTEGER(iarg).
          WHEN    "FIELD-MISC18"           THEN wfld._Fld-misc1[8]  = INTEGER(iarg).
          WHEN    "FIELD-MISC21"  OR
          WHEN    "LOB-SIZE"              THEN wfld._Fld-misc2[1]  = iarg.
          WHEN    "SHADOW-COL"                    
          OR WHEN "FIELD-MISC22"           THEN wfld._Fld-misc2[2]  = iarg.
          WHEN    "QUOTED-NAME"                    
          OR WHEN "FIELD-MISC23"           THEN wfld._Fld-misc2[3]  = iarg.
          WHEN    "MISC-PROPERTIES"         
          OR WHEN "FIELD-MISC24"           THEN wfld._Fld-misc2[4]  = iarg.
          WHEN    "SHADOW-NAME"                    
          OR WHEN "FIELD-MISC25"           THEN wfld._Fld-misc2[5]  = iarg.
          WHEN    "FIELD-MISC26"           THEN wfld._Fld-misc2[6]  = iarg.
          WHEN    "FIELD-MISC27"           THEN wfld._Fld-misc2[7]  = iarg.
          WHEN    "FIELD-MISC28"           THEN wfld._Fld-misc2[8]  = iarg.
          WHEN    "FIELD-TRIGGER"          THEN DO:
                FIND FIRST wflt WHERE wflt._Event = iarg NO-ERROR.
                IF NOT AVAILABLE wflt THEN CREATE wflt.
                wflt._Event = ilin[2].
                CASE ilin[3]:
                  WHEN "DELETE" OR WHEN "DROP" OR WHEN "REMOVE" THEN
                                                wflt._Proc-Name = "!":u.
                  WHEN "OVERRIDE"    THEN wflt._Override = TRUE.
                  WHEN "NO-OVERRIDE" THEN wflt._Override = FALSE.
                  end case.
                IF ilin[4] = "PROCEDURE" THEN wflt._Proc-Name = ilin[5].
                IF ilin[6] = "CRC" THEN wflt._Trig-CRC = 
                  (IF ilin[7] = ? THEN ? ELSE INTEGER(ilin[7])).
                ilin = ?.
                END.
          WHEN    "ENCRYPTION" 
          OR WHEN "ENCRYPT" 
          OR WHEN "CIPHER-NAME" THEN DO:
              /* this will raise error if something is wrong */
              IF LOOKUP(wfld._Data-Type,"BLOB,CLOB") > 0 THEN DO:
                 RUN checkEPolicy.
                 RUN addEncryptionSetting(wfld._Data-Type, iKwd , iarg).
              END.
              ELSE DO:
                  /* invalid for other field types */
                  ierror = 62.
              END.
          END.
          WHEN "BUFFER-POOL" THEN DO:
              /* this will raise error if something is wrong */
              IF LOOKUP(wfld._Data-Type,"BLOB,CLOB") > 0 THEN DO:
                  RUN checkObjAttrs.
                  RUN addBufferPoolSetting(wfld._Data-Type, iKwd , iarg).
              END.
          END.
          OTHERWISE ierror = 4. /* "Unknown &2 keyword" */

        END CASE.
  
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "i" THEN DO: /*--------------------------------------------*/
  
        CASE ikwd:
          WHEN    "INDEX" OR WHEN "KEY" THEN widx._Index-Name = iarg.
          WHEN    "UNIQUE"              THEN widx._Unique     = (iarg = "yes").
          WHEN    "INACTIVE"            THEN widx._Active     = (iarg = "no").
          WHEN    "PRIMARY"             THEN iprimary         = TRUE.
          WHEN    "WORD"                THEN widx._Wordidx    = LOOKUP(iarg,"yes").
          WHEN    "INDEX-NUM"           THEN widx._Idx-num    = INTEGER(iarg).
          WHEN    "AREA"                THEN DO:
             ASSIGN iarg = ""
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
             FIND _AREA WHERE _Area._Area-name = iarg NO-LOCK NO-ERROR.
             IF AVAILABLE _Area THEN   
                 ASSIGN index-area-number   = _Area._Area-number.
             ELSE
                 ASSIGN ierror = 31.                
          END.                    
          WHEN    "FOREIGN-LEVEL"       THEN widx._I-misc1[1] = INTEGER(iarg).
          WHEN    "FOREIGN-NAME"        THEN widx._For-name   = iarg.
          WHEN    "FOREIGN-TYPE"        THEN widx._For-type   = iarg.
          WHEN    "RECID-INDEX"         THEN widx._I-misc2[1] = iarg.
          WHEN    "DESC" 
          OR WHEN "DESCRIPTION"         THEN widx._Desc = iarg.
          WHEN    "INDEX-FIELD"
          OR WHEN "KEY-FIELD"           THEN DO:
            IF ilin[2] = ? OR ilin[2] = "" THEN DO:
               ASSIGN ilin = ?.
               NEXT load_loop.
            END.
            FIND _Field WHERE _Field._File-recid = drec_file
                    AND _Field._Field-name = ilin[2] NO-ERROR.
                    
            IF imod <> "a":u THEN ierror = 12.
              /* "Cannot add index field to existing index" */
            IF NOT AVAILABLE _Field THEN ierror = 13.
              /* "Cannot find field to index" */
            IF ierror > 0 AND ierror <> 50 THEN UNDO,RETRY load_loop.
            CREATE wixf.
            ASSIGN
                  icomponent        = icomponent + 1
                  wixf._Index-Seq   = icomponent
                  wixf._Field-recid = RECID(_Field)
                  wixf._Ascending   = TRUE.
                IF ilin[3] BEGINS "DESC":u OR ilin[4] BEGINS "DESC":u
                  OR ilin[5] BEGINS "DESC":u THEN wixf._Ascending  = FALSE.
                IF ilin[3] BEGINS "ABBR":u OR ilin[4] BEGINS "ABBR":u
                  OR ilin[5] BEGINS "ABBR":u THEN wixf._Abbreviate = TRUE.
                IF ilin[3] BEGINS "UNSO":u OR ilin[4] BEGINS "UNSO":u
                  OR ilin[5] BEGINS "UNSO":u THEN wixf._Unsorted   = TRUE.
                ilin = ?.
                END.
          WHEN    "ENCRYPTION"
          OR WHEN "ENCRYPT"
          OR WHEN "CIPHER-NAME" THEN DO:
             /* this will raise error if something is wrong */
             RUN checkEPolicy.
             RUN addEncryptionSetting("index", iKwd , iarg).
          END.
          WHEN "BUFFER-POOL" THEN DO:
              /* this will raise error if something is wrong */
              RUN checkObjAttrs.
              RUN addBufferPoolSetting("index", iKwd , iarg).
          END.
          OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
  
      END. /*-------------------------------------------------------------------*/
    
      IF ierror > 0 AND ierror <> 50 THEN UNDO,RETRY load_loop.
      
      ASSIGN stopped = false.

      END.  /* end repeat load_loop*/
    END.  /* end stop */


  IF stopped THEN 
    RUN adecomm/_setcurs.p ("").
  
   ELSE DO:  /* all but last definition-set executed */
    IF do-commit OR (NOT (ierror > 0 AND user_env[4] BEGINS "y":u)) THEN
    finish: DO:

      ASSIGN stopped = TRUE.

      /* Copy any remaining buffer values to the database */
      RUN adecomm/_setcurs.p ("WAIT").

      IF AVAILABLE wdbs
       AND imod <> ?
       THEN DO:
        RUN "prodict/dump/_lod_dbs.p".
        IF drec_db <> RECID(_Db)
         THEN FIND _Db WHERE RECID(_Db) = drec_db.
        END.

      IF AVAILABLE wfil AND imod <> ? THEN 
         RUN "prodict/dump/_lod_fil.p".
         
      IF AVAILABLE wfld AND imod <> ? THEN 
         RUN "prodict/dump/_lod_fld.p"(INPUT-OUTPUT minimum-index).

      IF AVAILABLE widx
       AND imod <> ?
       THEN DO:
        RUN "prodict/dump/_lod_idx.p"(INPUT-OUTPUT minimum-index).
        END.

      IF AVAILABLE wseq
       AND imod <> ?
       THEN RUN "prodict/dump/_lod_seq.p".
   
      /* make sure we found both encryption and cipher settings (unless it was
        'encrypt no', in which case we don't have a cipher).
      */
      IF encryptOpts[1] NE encryptOpts[2] THEN DO:
         ierror = 65.
      END.
 
      RUN adecomm/_setcurs.p ("").

      /* Error occurred when trying to save data from last command? */
      IF ierror > 0 AND ierror <> 50 THEN DO:
        RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
        RUN Show_Error ("prev").
        IF user_env[4] BEGINS "y":u THEN LEAVE finish.
        END.
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
      IF ct_changed AND NOT xerror THEN 
         MESSAGE "The .df file just loaded contains translation or" SKIP
                 "collation tables that are different from the ones" SKIP
                 "that were already in the database." SKIP(1)
                       "You will not be able to use this database in any" SKIP
                       "way until you rebuild its indices."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.

      RUN adecomm/_setcurs.p ("WAIT").

      RUN "prodict/dump/_lodfini.p".

      ASSIGN stopped = false.
      END.   /* finish: */
    
    END.     /* all but last definition-set executed */

  /* Make sure we reset ourselves back to the current database. */
  IF sav_drec <> drec_db
    THEN ASSIGN
       user_dbname = sav_dbnam
       user_dbtype = sav_dbtyp
       drec_db     = sav_drec.

  INPUT CLOSE.
  HIDE MESSAGE NO-PAUSE.

  IF TERMINAL <> ""
   THEN DO:  /* TERMINAL <> "" */

    HIDE FRAME working NO-PAUSE.
    IF do-commit AND xerror THEN DO:      
      ASSIGN do-commit = FALSE
             showedCommitMsg = YES.
      MESSAGE "There have been errors encountered in the loading of this df and " SKIP
              "you have selected to commit the transaction anyway. " SKIP(1)
              "Are you sure you want to commit with missing information? " SKIP (1)
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE do-commit.
     
      IF NOT do-commit THEN 
        MESSAGE msg2 VIEW-AS ALERT-BOX ERROR.
      ELSE
        ASSIGN xerror = FALSE.
    END.
    ELSE IF NOT (xerror OR stopped OR xwarn) THEN DO:
      IF CURRENT-WINDOW:MESSAGE-AREA = yes 
       THEN MESSAGE msg1.
       ELSE DO:
         DISPLAY msg1 WITH FRAME working2.
         pause 10.
       END.
    END.
    ELSE IF CURRENT-WINDOW:MESSAGE-AREA = yes THEN
      IF user_env[19] = "" THEN DO:
          IF xerror OR stopped THEN 
          MESSAGE msg2 VIEW-AS ALERT-BOX ERROR.
          IF user_env[6] = "f" OR user_env[6] = "b" THEN
            MESSAGE msg3 dbload-e msg4 VIEW-AS ALERT-BOX INFORMATION.
      END.
      ELSE
      DO:
          /* 20041202-001
             don't display this if only warnings occurred 
          */
         IF xerror OR STOPPED THEN
            MESSAGE msg2.

         MESSAGE msg3 dbload-e msg4.

         PAUSE.
      END.
      
    END.     /* TERMINAL <> "" */

  IF (xerror OR stopped)
   THEN undo, leave.

  HIDE FRAME backout  NO-PAUSE.
  HIDE FRAME working2 NO-PAUSE.
  HIDE MESSAGE no-pause.
  
  RUN adecomm/_setcurs.p ("").

  SESSION:IMMEDIATE-DISPLAY = no.


  END.     /* conversion not needed OR needed and possible */

IF (xerror OR STOPPED OR NOT main_trans_success) THEN DO:


   ASSIGN user_path = "9=h,4=error,_usrload":u.

   /* OE00193991 - moved code below from _usrload.p */
   /* Fernando: 20020129-017 if there was a message from the client after the load process started, 
   search for error number 151 (defined as ERROR_ROLLBACK) and write to the error log file. The error
   would be the first entry in message queue ( _msg(1) ). 
   
   OE00193991 - Also check fo error 15262 (online schema error). Both errors only occurred
   if we stopped or main transaction failed 
   */
   IF  STOPPED OR NOT main_trans_success AND 
       (_msg(1) = {&ERROR_ROLLBACK} OR _msg(1) = 15262) THEN
   DO:
       IF (user_env[6] = "f" OR user_env[6] = "b") THEN
       DO:

           OUTPUT TO VALUE (LDBNAME("DICTDB") + ".e") APPEND.
           PUT UNFORMATTED TODAY " " STRING(TIME,"HH:MM") " : "
              "Load of " user_env[2] " into database " 
              LDBNAME("DICTDB") " was unsuccessful." SKIP " All the changes were backed out..." 
              SKIP " {&PRO_DISPLAY_NAME} error numbers (" _msg(1) ") " .
              IF _msg(1) NE 15262 AND _msg(2) > 0 THEN 
                   PUT UNFORMATTED "and (" _msg(2) ")." SKIP(1).
               ELSE PUT UNFORMATTED "."  SKIP(1) . 
           OUTPUT CLOSE.
       END.
   END.

END.
ELSE IF (VALID-OBJECT(dictEPolicy) AND NOT dictObjAttrCache AND hasEncPol) OR 
        (VALID-OBJECT(dictObjAttrs) AND NOT dictObjAttrCache AND hasBufPool) THEN DO:

    DO TRANSACTION ON ERROR UNDO, LEAVE:

        DEFINE VARIABLE cObjNameErr AS CHAR NO-UNDO.

        /* we only get here if there are policies to be saved and we have a
           valid encryption policy object, and when this isn't called from
           prodict/load_df.p.
        */
        DEFINE BUFFER my_Db FOR DICTDB._Db.
        
        ASSIGN STOPPED = YES
               msg5 = "".
        
        DO ON STOP UNDO, LEAVE:
            /* try to get the schema lock again as soon as possible since we lost it
               when the transaction above ended
            */
            FIND FIRST my_Db WHERE RECID(my_Db) = drec_db.
            
            IF VALID-OBJECT(dictEPolicy) AND hasEncPol THEN DO:
                /* Now we can try to save the policy records if there are any */
                /* We wait until here, so that we can start a new transaction. That is because
                   if there are new tables/blobs/indexes created, their object number won't
                   get assigned by core until the end of the transaction. So we can't
                   create the objects and the policies in the same transaction.
                */
                ASSIGN msg5 = "Saving encryption policies...".
                
                IF CURRENT-WINDOW:MESSAGE-AREA = yes THEN
                    MESSAGE msg5.
                ELSE
                    DISPLAY msg5 WITH FRAME encryptlog.
        
                msg5 = "".
            
                /* now we should be outside the main transaction. If not, new tables/index/fields
                   will not have been assigned with the object number.
                   We pass the handle of this procedure so that secErrorCallback gets called back
                   when an error happens.
                */
                encryptOpts[1] =  dictEPolicy:cacheSavePolicy(INPUT THIS-PROCEDURE,
                                                              OUTPUT cObjNameErr).
            
                IF NOT encryptOpts[1] THEN DO:
                   RUN Show_Phase2_Error ("Cannot enable encryption for " + cObjNameErr 
                                          + ". Make sure there is no "
                                          + "transaction active when the load process is initiated.",
                                          "e").
                END.
            END.

            /* if all is well so far, ot user selected to commit on error, check for buffer pool
               settings.
            */
            IF (do-commit OR NOT xerror) AND VALID-OBJECT(dictObjAttrs) AND hasBufPool THEN DO:

                ASSIGN msg5 = "Saving buffer pool settings...".
                
                IF CURRENT-WINDOW:MESSAGE-AREA = yes THEN
                    MESSAGE msg5.
                ELSE
                    DISPLAY msg5 WITH FRAME encryptlog.
        
                msg5 = "".
            
                /* now we should be outside the main transaction. If not, new tables/index/fields 
                   will not have been assigned with the object number.
                   We pass the handle of this procedure so that secErrorCallback gets called back
                   when an error happens.
                */
                IF NOT dictObjAttrs:cacheSaveSettings(INPUT THIS-PROCEDURE,
                                                      OUTPUT cObjNameErr) THEN DO:
                   RUN Show_Phase2_Error ("Cannot set buffer pool for " + cObjNameErr 
                                          + ". Make sure there is no "
                                          + "transaction active when the load process is initiated.",
                                          "b").
                END.
            END.

            STOPPED = NO.
        END. /* do on stop */
    
        IF TERMINAL <> "" THEN DO:

          IF do-commit AND xerror AND NOT stopped THEN DO:      
            IF NOT showedCommitMsg THEN DO:
                ASSIGN do-commit = FALSE.
                MESSAGE "The schema definitions were committed successfully but there" SKIP
                        "have been errors encountered during the second phase of the load" SKIP
                        "process (for encryption policies and/or buffer pool settings)" SKIP
                        "and you have selected to commit the transaction even with errors. " SKIP(1)
                        "Are you sure you want to commit the second phase with missing information? " SKIP (1)
                      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE do-commit.
            END.                                                                

            IF NOT do-commit THEN DO:
               RUN Show_Phase2_Error(error_text[68] + CHR(10) + error_text[69],"a").
            END.
            ELSE
              ASSIGN xerror = FALSE.
          END.
          ELSE IF (xerror OR stopped) AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN DO:
            IF user_env[19] = "" THEN DO:
                IF xerror OR stopped THEN DO:
                   RUN Show_Phase2_Error(error_text[68] + CHR(10) + error_text[69],"a").
                END.
                    
                IF user_env[6] = "f" OR user_env[6] = "b" THEN
                  MESSAGE msg3 dbload-e msg4 VIEW-AS ALERT-BOX INFORMATION.
            END.
            ELSE
            DO:
                /* 20041202-001
                   don't display this if only warnings occurred 
                */
               IF xerror OR STOPPED THEN
                  MESSAGE error_text[68] CHR(10) error_text[69].

               MESSAGE msg3 dbload-e msg4.

               PAUSE.
            END.
          END.
        END.     /* TERMINAL <> "" */

        IF (xerror OR stopped) THEN undo, leave.

        FINALLY: /* DO TRANS */
    
           HIDE FRAME encryptlog NO-PAUSE.
           HIDE MESSAGE no-pause.
    
        END FINALLY.

    END. /* DO TRANS */

    IF (xerror OR stopped)
     THEN ASSIGN user_path = "9=h,4=error_objattrs,_usrload":u.

END.

/* this only gets instantiated if there is some encryption setting in the .df.
   Unless the load was aborted, we only delete it if dictObjAttrCache is not set,
   which gets set by load_df.p.
*/
IF VALID-OBJECT(dictEPolicy) AND 
    ((xerror OR stopped) OR (NOT dictObjAttrCache))  THEN
  DELETE OBJECT dictEPolicy.

IF VALID-OBJECT(dictObjAttrs) AND 
    ((xerror OR stopped) OR (NOT dictObjAttrCache))  THEN
  DELETE OBJECT dictObjAttrs.

/* ASSIGN ? to all the _db-records, that have interims-value of
 * SESSION:CHARSET ASSIGNed to _db-xl-name, because they had no
 * codepage-name entry in the .df-file
 */
FOR EACH s_ttb_fake-cp:
  FIND FIRST _Db WHERE RECID(_Db) = s_ttb_fake-cp.db-recid.
  ASSIGN
    _db._db-xl-name = ?
    ierror          = 44
    imod            = "cp"
    iobj            = "cp" + _db._db-name.
  RUN Put_Header (INPUT dbload-e, INPUT-OUTPUT hdr).
  RUN Show_Error ("prev").
  delete s_ttb_fake-cp.
  END.

RETURN.

/*--------------------------------------------------------------------*/
