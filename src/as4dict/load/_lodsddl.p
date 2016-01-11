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

/* _lodsddl.p - load .df schema definitions file */

/*
in:  user_env[2] = filename of .df file
     user_env[4] = abort on first error
     user_env[8] = target database name
     user_env[10] = codepage [either from file or user input]
     user_env[27] = Errors to File, yes/no
     user_env[28] = Errors to Screen, yes/no
*/
/* 
History:
    hutegger    94/05/06    added backout frame, changed behaviour after
                            error, so "Load Completed" doesn't come up
                            changed error-message for wrong codepage and
                            proc show-error to use 3 lines for one error
                            if error-number > 30
    hutegger    94/05/06    index can have 3 attributes before the 
                            keyword "INDEX" therfore the keyword on can 
                            be not just in slots 4 and 6 but also in slots
                            5 and 7 - I added these options
    gfs         94/06/24    Removed lodtrail.i support, codepage now comes
                            in user_env[10]. (bug 94-04-28-032)               
                                                                                                                    
                             
     mcmann    95/03/23 Copied prodict/dump/_lodsddl.p into as4dict/load
                                          and modified to load Progress df into DB2/400 p__xxxx files
                                          to create the DB2/400 database.
                                          
     mcmann    96/03/21 Added logic to find file when update field without
                        update file is encountered.  Bug 96-02-01-036

     mcmann    97/07/15 Added logic to find file when update index without
                        having update file first.  Bug 97-07-15-008
     mcmann    97/08/07 Added new DBA command for word indexes.
     
     mcmann    09/11/97 Added assignment null capable field _fld-misc2[2] when
                        AS/400 format and not specifically noted as null capable

     mcmann    11/25/97 Added code to ignor AREA keyword
     
     mcmann    01/12/98 Added code to ignor POSITION keyword

     mcmann    06/03/98 Changed how p__file is found for rename of index
                        98-03-19-001
     mcmann    11/30/98 Moved p__db find 98-08-21-022
     mcmann    01/27/99 Added code to recognize SQL-WIDTH
     mcmann    09/08/99 Added stored procedure support
     mcmann    05/18/00 Added support for new keyword MAX-GLYPHS
     mcmann    02/15/01 Added check for enhanced incremental df
     mcmann    02/12/02 Changes message 50
     mcmann    04/12/02 Added conversion of replication trigger names
          
*/                            

{ as4dict/dictvar.i  shared}
{ as4dict/menu.i shared}
{ as4dict/load/loaddefs.i NEW }


DEFINE VARIABLE error_text AS CHARACTER EXTENT 51 NO-UNDO.
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
  error_text[26] = "Unable to create word index objects, index not loaded.":t72
  error_text[27] = "Incompatible translation table version - Load will be terminated":t72
  error_text[28] = "Load will be terminated":t72
  error_text[29] = "Load unsuccessful - backing out":t72           
  error_text[30] = "Table-type must be AS400 or Progress - Load will be terminated":t72                                                     
  error_text[31] = "CODEPAGE-NAME in the df-file is different from the db's current":t63
  error_text[32] = "codepage. To change the codepage use the Admin-Tool for DataServers":t67
  error_text[33] = "or PROUTIL for PROGRESS. This .df-file can't be loaded.":t55 
 
  
/*  The following errors do not cause the load to back everything out */       
  error_text[43] = "AS400 Field Name already exists in file, field not added. ":t72
  error_text[44] = "Index size too large, index not created. ":t72
  error_text[45] = "Word Index not supported, index not created. ":t72
  error_text[46] = "Field without format can not calculate storage length.":t72
  error_text[47] = "Datatype not supported for AS/400, Field not loaded.":t72
  error_text[48] = "Cannot &1 Read-Only object &3":t72
  error_text[49] = "Only format changed, field in index and max length was exceeded":t67
  error_text[50] = "Field length can not be made smaller, only format changed.":t67 
  error_text[51] = "Extent Field, only format changed, do drop and add to change length.":t67
    .
  
DEFINE VARIABLE scrap       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cerror      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage    AS CHARACTER           NO-UNDO init "UNDEFINED".
DEFINE VARIABLE i   	    AS INTEGER             NO-UNDO.
DEFINE VARIABLE iobj	    AS CHARACTER           NO-UNDO. /* d,t,f,i */
DEFINE VARIABLE inot	    AS LOGICAL             NO-UNDO.
DEFINE VARIABLE inum	    AS INTEGER             NO-UNDO.
DEFINE VARIABLE lvar        AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#       AS INTEGER             NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL             NO-UNDO init true.
DEFINE VARIABLE sav_dbnam   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sav_drec    AS RECID               NO-UNDO.
DEFINE VARIABLE xerror      AS LOGICAL             NO-UNDO. /* any error during process */
DEFINE VARIABLE Table_stat  AS INTEGER             NO-UNDO INIT 0.

/* collate/translate information */
DEFINE VARIABLE ct_version AS CHARACTER NO-UNDO.      	  /* version # */
DEFINE VARIABLE ct_changed AS LOGICAL   NO-UNDO INIT no.  /* tables modified? */
DEFINE VARIABLE ix         AS INTEGER   NO-UNDO. /* for parsing version # */
DEFINE VARIABLE len        AS INTEGER   NO-UNDO. /* ditto */
DEFINE VARIABLE raw_val    AS RAW       NO-UNDO.

FORM
  wdbs._Db-name    LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  wfil._File-name  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  wfld._Field-name LABEL "Field"    COLON 11 FORMAT "x(32)":u SKIP
  widx._Index-name LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  wseq._Seq-Name   LABEL "Sequence" COLON 11 FORMAT "x(32)":u SKIP
  HEADER 
    " Creating DB2/400 Definitions. Press " +
    KBLABEL("STOP") + " to terminate load." format "x(70)" 
  WITH FRAME working OVERLAY THREE-D VIEW-AS DIALOG-BOX
  ROW 4 CENTERED USE-TEXT SIDE-LABELS.

COLOR DISPLAY MESSAGES
  wdbs._Db-name wfil._File-name wfld._Field-name
  widx._Index-name wseq._Seq-Name
  WITH FRAME working.

FORM
   "Phase 1 of Load completed.  Working.  Please wait ..."
   WITH FRAME working2 OVERLAY THREE-D CENTERED BGCOLOR 8 USE-TEXT.

FORM
   "Error occured during load. Backing out - Please wait ..."
   WITH FRAME backout OVERLAY THREE-D CENTERED BGCOLOR 8 USE-TEXT.


/*=========================Internal Procedures=============================*/

/*-----------------------------------------------------
   Show an error.  If p_cmd = "prev" it means the
   error occurred when flushing data for the previous
   command and we no longer have the error command
   in ilin.  If p_cmd = "curr", it means ilin still
   contains the command which caused the error.
   imod and iobj however, always pertain to the 
   error command.
------------------------------------------------------*/
PROCEDURE Show_Error:

  DEFINE INPUT PARAMETER p_cmd AS CHAR NO-UNDO.

  DEFINE VAR msg AS CHAR    NO-UNDO INIT "".
  DEFINE VAR ix  AS INTEGER NO-UNDO.

  scrap = (IF imod = "a":u THEN "ADD":u
      ELSE IF imod = "m":u THEN "MODIFY":u
      ELSE IF imod = "r":u THEN "RENAME":u
      ELSE IF imod = "d":u THEN "DELETE":u
      ELSE "?":u)
    + " ":u
    + (IF     iobj = "d":u THEN "DATABASE ":u + 
      	 (IF wdbs._Db-name = ? THEN "" ELSE wdbs._Db-name)
      ELSE IF iobj = "t":u THEN "TABLE ":u    + 
      	 (IF wfil._File-name = ? THEN "" ELSE wfil._File-name)
      ELSE IF iobj = "f":u THEN "FIELD ":u    + 
      	 (IF wfld._Field-name = ? THEN "" ELSE wfld._Field-name)
      ELSE IF iobj = "i":u THEN "INDEX ":u    + 
      	 (IF widx._Index-name = ? THEN "" ELSE widx._Index-name)
      ELSE IF iobj = "s":u THEN "SEQUENCE ":u + 
      	 (IF wseq._Seq-Name = ? THEN "" ELSE wseq._Seq-Name)
      ELSE "? ?":u).

  IF first_error AND User_Env[27] BEGINS "y" THEN DO:
      RUN Open_Stream.
      first_error = false.
  END.

  IF p_cmd = "curr" THEN DO:
    msg = "** Line " + STRING(ipos).
    DO ix = 1 to 9:
      msg = msg + (IF ilin[ix] <> ? THEN " " + ilin[ix] ELSE "").
    END.
  END.
  
   IF ierror <= 30 OR ierror > 42 THEN DO:

     IF msg = "" THEN DO:
       IF User_Env[28] BEGINS "y" OR ierror <= 30 THEN
            MESSAGE 
              "** Error during" scrap "**" SKIP(1)
              SUBSTITUTE(error_text[ierror],
              ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      /* User chose Errors to File, put the error to the file */
        IF User_Env[27] BEGINS "Y" THEN 
            PUT STREAM loaderrs UNFORMATTED SKIP(1) "** Error during " scrap " **" SKIP
               SUBSTITUTE(error_text[ierror],
               ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)).
   
       END.
       ELSE DO:  
         IF User_Env[28] BEGINS "y" OR ierror <= 30 THEN
           MESSAGE  "** Error during" scrap "**" SKIP(1)
              msg SKIP(1) 
              SUBSTITUTE(error_text[ierror],
              ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)) 
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

         IF User_Env[27] BEGINS "y" THEN 
            PUT STREAM loaderrs UNFORMATTED SKIP "** Error during " scrap " **" SKIP
                    msg SKIP
                    SUBSTITUTE(error_text[ierror],
                    ENTRY(1,scrap," ":u),ENTRY(2,scrap," ":u),ENTRY(3,scrap," ":u)).
       END.    
  END.  /* End ierror <= 30 OR > 42  */

  ELSE if ierror <= 42 
   THEN DO:
      MESSAGE
         "** Error during" scrap "**"             SKIP(1)
          error_text[ierror]                     skip
          error_text[ierror + 1]                 skip 
          error_text[ierror + 2] 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      IF User_Env[27] BEGINS "y" THEN 
         PUT STREAM loaderrs UNFORMATTED SKIP "** Error during " scrap " **" SKIP
            error_text[ierror]                     skip
            error_text[ierror + 1]                 skip 
            error_text[ierror + 2].
    END.  /* ierror <= 42  */                      

  RUN adecomm/_setcurs.p ("WAIT").

 /* No need to back everything out for errors over 42 */
  ASSIGN xerror = (IF ierror > 42 THEN false ELSE true).
  ASSIGN diag_errs = (IF ierror > 42 THEN true ELSE false).
 END.

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

   RUN as4dict/load/_lod_raw.i (INPUT ct_version, OUTPUT changed)
           	     	      	p_Dbfield 256 RECID(wdbs).
   ct_changed = ct_changed OR changed.

   ilin[1] = ?.  /* so we do a new import the next time around */
end.
/* ------------------------------------------------------------- */

/*============================Mainline Code================================*/

ASSIGN
  cache_dirty = TRUE
  user_dbname = user_env[8]. /* for backwards compatibility with _lodsddl.p */           
 
ASSIGN
  drec_db      = 1
  drec_file    = ?
  sav_dbnam    = user_dbname
  sav_drec     = drec_db
  ierror       = 0
  ilin         = ?
  ipos         = 0
  gate_dbtype  = user_dbtype
  gate_proc    = "".

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

/* to cheat scoping mechanism */
IF FALSE THEN FIND NEXT as4dict.p__File.
IF FALSE THEN FIND NEXT as4dict.p__Field.
IF FALSE THEN FIND NEXT as4dict.p__Index.
IF FALSE THEN FIND NEXT wdbs.
IF FALSE THEN FIND NEXT wfil.
IF FALSE THEN FIND NEXT wfld.
IF FALSE THEN FIND NEXT widx.
IF FALSE THEN FIND NEXT wseq.
 

ASSIGN codepage = if user_env[10] = ""
                    then "UNDEFINED"
                    else user_env[10]. /* set in _usrload.p */
IF codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? THEN
   ASSIGN cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".

IF cerror = ?
 THEN DO:  /* conversion needed but NOT possible */

  run adecomm/_setcurs.p ("").
  MESSAGE "Definitions NOT loaded." 
       	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 

 END.     /* conversion needed but NOT possible */

 ELSE DO:  /* conversion not needed OR needed and possible */

  if cerror = "no-convert"
   then INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
               CONVERT SOURCE codepage TARGET SESSION:CHARSET.

  SESSION:IMMEDIATE-DISPLAY = yes.
  run adecomm/_setcurs.p ("WAIT").
  
  FIND FIRST as4dict.p__db NO-LOCK.
  
  DO ON STOP UNDO, LEAVE:
    /* When IMPORT hits the end, it generates ENDKEY.  This is how loop ends */
    
    load_loop:
    REPEAT ON ERROR UNDO,RETRY ON ENDKEY UNDO, LEAVE:
  
      IF ierror > 0 AND NOT inoerror THEN DO:
        IF table_stat < 2 THEN 
            RUN Show_Error ("curr").
        IF user_env[4] BEGINS "y":u THEN UNDO,LEAVE load_loop. 
      END.
      
      IF ierror > 0 THEN
        ASSIGN
	  ierror = 0
	  imod   = ?
	  iobj   = ?.
  
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
        ASSIGN ipos = ipos + 1
	           ilin = ?.
        IMPORT ilin.
      END.
      inum = 0.
 
      IF ilin[1] = "ENHANCED" THEN DO:
        MESSAGE "The definition file you have selected is an AS/400 Incremental" SKIP(1)
                "and can not be loaded using this utility." SKIP(1)
                "Use the Load AS/400 Incremental DF utility." SKIP(1)
                VIEW-AS ALERT-BOX ERROR.
        ASSIGN user_env[35] = "error".
        RETURN.
      END.
      IF CAN-DO(
        "ADD,CREATE,NEW,UPDATE,MODIFY,ALTER,CHANGE,DELETE,DROP,REMOVE,RENAME":u,
        ilin[1]) THEN DO:
        /* This is the start of a command - so copy the buffer values from 
  	   the last time through the loop into the database.
        
           No work needs to be done for as4dict.p__db record removed dump/_lod_dbs.p
           logic  
         */           

      /* If there was a problem with the table, (not found or read-only)
         there is no point in going through the load programs.        */ 
        IF table_stat = 0 THEN DO:
           IF AVAILABLE wfil THEN RUN "as4dict/load/_lod_fil.p".             
           IF AVAILABLE wfld THEN RUN "as4dict/load/_lod_fld.p".
           IF AVAILABLE widx THEN RUN "as4dict/load/_lod_idx.p".
           IF AVAILABLE wseq THEN RUN "as4dict/load/_lod_seq.p".
        END.
        
        /* Error occurred when trying to save data from last command */
        IF ierror > 0 THEN DO:
	  RUN Show_Error ("prev").
	  IF user_env[4] BEGINS "y":u AND xerror THEN UNDO,LEAVE load_loop. 
	  ierror = 0.
        END.
  
        /* delete temp file contents to start anew for this command */
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
	  inum       = 3.
    
          /* set the action mode */
        CASE ilin[1]:
	  WHEN "ADD":u    OR WHEN "CREATE":u OR WHEN "NEW":u  THEN imod = "a":u.
	  WHEN "UPDATE":u OR WHEN "MODIFY":u OR WHEN "ALTER":u OR WHEN "CHANGE":u
							    THEN imod = "m":u.
	  WHEN "DELETE":u OR WHEN "DROP":u OR WHEN "REMOVE":u THEN imod = "d":u.
	  WHEN "RENAME":u                                     THEN imod = "r":u.
        END CASE.
    
        /* set the object type */
        CASE ilin[2]:
	  WHEN "DATABASE":u OR WHEN "CONNECT":u THEN iobj = "d":u.
	  WHEN "FILE":u     OR WHEN "TABLE":u   THEN iobj = "t":u.
	  WHEN "FIELD":u    OR WHEN "COLUMN":u  THEN iobj = "f":u.
	  WHEN "INDEX":u    OR WHEN "KEY":u     THEN iobj = "i":u.
	  WHEN "SEQUENCE":u                     THEN iobj = "s":u.
        END CASE.                 
        
        IF iobj = "t" AND ilin[4] = "TYPE" THEN  /* Something other than Progress */
           IF ilin[5] <> "AS400" AND ilin[5] <> "PROGRESS" THEN DO:  /* table of foreign DB: type mismatch */
              ASSIGN
                error_text[30] = substitute(error_text[30],gate_dbtype)
                ierror         = 30
                user_env[4]    = "yes". /* to prevent 2. error-message at end */ 
              CREATE wfil. /* to be used in show-error */
              RUN Show_Error ("curr").
              UNDO,LEAVE load_loop. /* no sense to continue */
            END.        /* table of foreign DB: type mismatch */
           ELSE
            ASSIGN as400_type = (IF ilin[5] = "AS400" THEN yes ELSE no).
          
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
        IF ierror > 0 THEN UNDO,RETRY load_loop.
  
        /* Reinitialize the buffers.  e.g., for add set the name of the
	   object.  For modify, copy the existing record into the buffer.
	   If working on a field or index, find the corresponding _File
	   record as well.
        */                                  
  
 /*       IF iobj = "d" THEN CREATE wdbs. */
        IF iobj = "t" THEN CREATE wfil.
        IF iobj = "f" THEN CREATE wfld.
        IF iobj = "i" THEN CREATE widx.
        IF iobj = "s" THEN CREATE wseq.

        IF iobj = "d" THEN DO: /* start database action block */      

	      
	  /* SINCE THE P__DB RECORD IS CREATED WHEN THE USER
	       CREATES THE PROGRESS/400 DATABASE, WE DO NOT WANT
	       TO PERFORM ANY DB WORK AND THE ABOVE WILL ALLOW US TO
	       IGNOR THE DATABASE NAME THAT IS LOADED BUT USE WHATEVER
	       AS4DICT IS SET TO.
                  */
	  
        END. /* end database action block */
 
      IF iobj = "s" THEN DO: /* start sequence action block */
	  IF TERMINAL <> "" THEN 
	    DISPLAY 
	      user_dbname @ wdbs._Db-name
	      "" @ wfil._File-name  "" @ wfld._Field-name
	      "" @ widx._Index-name ilin[3] @ wseq._Seq-Name
	      WITH FRAME working.
	  IF imod = "a" THEN
	    wseq._Seq-Name = ilin[3].
	  ELSE DO:
	    FIND FIRST as4dict.p__Seq WHERE as4dict.p__Seq._Seq-Name = ilin[3] NO-ERROR.
	    IF NOT AVAILABLE as4dict.p__Seq THEN DO:                       
	      ierror = 3. /* "Try to modify unknown &2" */
	      UNDO,RETRY load_loop.             
	    END.                      
	    { prodict/dump/copy_seq.i &from=as4dict.p__Seq &to=wseq }
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
	  ELSE DO:           
	    IF AVAILABLE as4dict.p__Db THEN
	      FIND FIRST as4dict.p__File WHERE TRIM(as4dict.p__File._File-name) = scrap NO-ERROR.
           END.
	    IF AVAILABLE as4dict.p__File AND NOT AVAILABLE as4dict.p__Db THEN DO:
	      FIND FIRST as4dict.p__Db.
	      drec_db = RECID(as4dict.p__Db).
	    END.
           IF NOT AVAILABLE as4dict.p__File THEN
             FIND FIRST as4dict.p__File WHERE TRIM(as4dict.p__File._File-name) = scrap NO-ERROR.
           IF scrap <> ? AND AVAILABLE as4dict.p__File THEN drec_file = RECID(as4dict.p__File).	                
        END.
  
        IF iobj = "t" THEN DO: /* start file action block */
          Table_stat = 0.
	  IF TERMINAL <> "" THEN 
	    DISPLAY user_dbname @ wdbs._Db-name
		    ilin[3] @ wfil._File-name "" @ wfld._Field-name 
		    "" @ widx._Index-name "" @ wseq._Seq-Name
	  	    WITH FRAME working.
	  IF imod = "a" THEN 
	       wfil._File-name = ilin[3].  
	  ELSE DO:
	    IF NOT AVAILABLE as4dict.p__File THEN DO:
              table_stat = 1.
	      ierror = 3. /* "Try to modify unknown &2" */
	      UNDO,RETRY load_loop.
	    END.  
	    table_stat = 0.
	    { as4dict/load/copy_fil.i &from= as4dict.p__File &to=wfil &all=true}
            /* Check for read-only file if not adding */
            IF SUBSTRING(as4dict.p__file._Fil-Misc2[4],8,1) = "Y" THEN DO:  
                  ierror = 48. /* Unable to modify - object is read only */
                  table_stat = 1.
                  UNDO,RETRY load_loop.
                END.                                    
	    FOR EACH as4dict.p__trgfl WHERE as4dict.p__Trgfl._File-number = as4dict.p__File._File-number:
	      CREATE wfit.
	      { as4dict/load/copy_fit.i &from= as4dict.p__trgfl &to=wfit }
	    END.
	  END.
        END. /* end file action block */
  
        IF iobj = "f" THEN DO: /* start field action block */     
         IF pfilenumber = 0 THEN DO:             
           FIND as4dict.p__file WHERE as4dict.p__File._File-name = ilin[5] NO-ERROR.
           IF AVAILABLE as4dict.p__File THEN
             ASSIGN pfilenumber =  as4dict.p__File._File-number.
         END.    
         IF pfilenumber <> 0 THEN
	   FIND as4dict.p__File WHERE as4dict.p__File._File-number = pfilenumber NO-ERROR.
	   IF AVAILABLE as4dict.p__file AND as4dict.p__file._File-name <> ilin[5] THEN DO:
	       FIND as4dict.p__file WHERE as4dict.p__File._File-name = ilin[5] NO-ERROR.
               IF AVAILABLE as4dict.p__File THEN
                 ASSIGN pfilenumber =  as4dict.p__File._File-number.
           END.      	        
           IF NOT AVAILABLE as4dict.p__File THEN DO:
               IF table_stat > 0 THEN table_stat = 2.
 	       ierror = 5. /* "Try to modify &2 without file" */
	       UNDO,RETRY load_loop.
            END.                           
            IF TERMINAL <> "" THEN 
	       DISPLAY as4dict.p__File._File-name @ wfil._File-name
      	       	    ilin[3] @ wfld._Field-name 
      	       	    "" @ widx._Index-name
		    WITH FRAME working.
		    
              IF imod = "a" THEN
	  ASSIGN
	      wfld._Field-name = ilin[3]    
              wfld._Initial    = "". /* to be checkable in _lod_fld */
          ELSE DO:

	  FIND as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__File._File-number
                 AND TRIM(as4dict.p__Field._Field-name) = ilin[3] NO-ERROR.
 
 	  IF NOT AVAILABLE as4dict.p__Field THEN DO:
              IF table_stat > 0 THEN table_stat = 2.
	      ierror = 3. /* "Try to modify unknown &2" */
	      UNDO,RETRY load_loop.
	  END.
	  { as4dict/load/copy_fld.i &from= as4dict.p__Field &to=wfld &all=true}
	  FOR EACH as4dict.p__Trgfd  WHERE as4dict.p__trgfd._file-number = as4dict.p__Field._File-number
                                       AND as4dict.p__Trgfd._Fld-number = as4dict.p__Field._Fld-number:
	      CREATE wflt.
	      { as4dict/load/copy_flt.i &from=as4dict.p__Trgfd &to=wflt }
	  END.
               END.
        END. /* end field action block */
  
        IF iobj = "i" THEN DO: /* start index action block */

	  IF pfilenumber = 0 THEN DO:             
           FIND as4dict.p__file WHERE as4dict.p__File._File-name = ilin[5] NO-ERROR.
           IF AVAILABLE as4dict.p__File THEN
             ASSIGN pfilenumber =  as4dict.p__File._File-number.
           ELSE DO:
             FIND as4dict.p__File WHERE as4dict.p__File._File-name = ilin[7] NO-ERROR.
             IF AVAILABLE as4dict.p__File THEN
               ASSIGN pfilenumber =  as4dict.p__File._File-number.
           END.  
         END.    
         ELSE IF pfilenumber <> 0 THEN
	     FIND as4dict.p__File WHERE as4dict.p__File._File-number = pfilenumber NO-ERROR.
	     
	  IF AVAILABLE as4dict.p__file AND as4dict.p__file._File-name <> scrap THEN DO:
	     FIND as4dict.p__file WHERE as4dict.p__File._File-name = scrap NO-ERROR.
            IF AVAILABLE as4dict.p__File THEN
               ASSIGN pfilenumber =  as4dict.p__File._File-number.
         END. 
	  IF NOT AVAILABLE as4dict.p__File THEN DO:
           IF table_stat > 0 THEN table_stat = 2.
           ierror = 5. /* "try to modify index w/o file" */            
	    UNDO,RETRY load_loop.  
	  END.
	  IF TERMINAL <> "" THEN 
	    DISPLAY as4dict.p__File._File-name @ wfil._File-name
      	         	  "" @ wfld._Field-name
	            ilin[3] @ widx._Index-name 
	        WITH FRAME working.
	  IF imod = "a" THEN
	    ASSIGN
	      widx._Index-name = ilin[3]
	      widx._Unique     =  "N". /* different from schema default of TRUE */
	  ELSE DO:
	    FIND as4dict.p__Index WHERE TRIM(as4dict.p__Index._Index-name) = ilin[3] 
	         AND as4dict.p__Index._file-number = as4dict.p__file._file-number NO-ERROR.
	    IF NOT AVAILABLE as4dict.p__Index and imod <> "d" THEN DO:
              IF table_stat > 0 THEN table_stat = 2.
              ierror = 3. /* "Try to modify unknown &2" */
	      UNDO,RETRY load_loop.
             END.
            ELSE 
               IF AVAILABLE (as4dict.p__index) THEN DO:
                  IF SUBSTRING(as4dict.p__Index._I-Misc2[4],8,1) = "Y" THEN DO:  
                    ierror = 48. /* Unable to modify - object is read only */
                    UNDO,RETRY load_loop.
                   END.                                    
               { as4dict/load/copy_idx.i &from= as4dict.p__Index &to=widx }
  	       FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                            AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num:
	        CREATE wixf.
	         { as4dict/load/copy_ixf.i &from=as4dict.p__Idxfd &to=wixf }
	       END.
	     END.  /* P__index record available */
	  END. /* imod <> "a" */
        END. /* end index action block */
  
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
	  ikwd = ilin[1]
	  iarg = ilin[2]
	  inot = FALSE
	  inum = 2
	  inot = (ikwd BEGINS "NOT-")
	  ikwd = SUBSTRING(ikwd,IF inot THEN 5 ELSE 1)
	  inum = (IF ikwd = "NO-ERROR"
	       OR (iobj = "t" AND CAN-DO("FROZEN,HIDDEN",ikwd))
	       OR (iobj = "f" AND CAN-DO("MAND*,NULL*,NULL-A*,CASE-SENS*",ikwd))
	       OR (iobj = "i" AND CAN-DO("UNIQUE,INACTIVE,PRIMARY,WORD",ikwd))
	       THEN 1 ELSE 2)
	  iarg = (IF inum = 2 THEN iarg ELSE (IF inot THEN "no" ELSE "yes")).
 
    /* Load the value from the .df file into the appropriate field
       of the object we're working on.
    */
      IF inum = 3 THEN .
      ELSE IF ikwd = "NO-ERROR" THEN inoerror = TRUE.
      ELSE IF imod = "r" AND ilin[1] = "TO" THEN irename = ilin[2].
      ELSE IF iobj = "d" THEN DO: /*--------------------------------------------*/               
      
     /* Remove case statement because it deals with _db record which we
         do not want to work with.
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
   
      	    ASSIGN
      	      ct_version = iarg
      	      ix = INDEX(ct_version, "-").
      	    IF SUBSTR(ct_version, 1, ix - 1) >= "3.0" THEN DO:
      	      user_env[4] = "y". /* stop the load - db will be corrupted. */
      	      ierror = 27.
      	    END.
      	    ASSIGN
      	      ix = INDEX(ct_version, ".")
      	      wdbs._Db-collate[5] = raw_val /* to replace ?, if there */
      	      PUTBYTE(wdbs._Db-collate[5],1) = 
      	        INTEGER(SUBSTR(ct_version, 1, ix - 1))
      	      ix = ix + 1
      	      len = INDEX(ct_version, "-") - ix
      	      PUTBYTE(wdbs._Db-collate[5],2) = 
      	        INTEGER(SUBSTR(ct_version, ix, len)).
      	  END.
	  WHEN     "TRANSLATION-NAME"   
	   OR WHEN "CODEPAGE-NAME"            THEN wdbs._Db-xl-name = iarg.
	  WHEN "COLLATION-NAME"               THEN wdbs._Db-coll-name = iarg.
	  WHEN "INTERNAL-EXTERNAL-TRAN-TABLE" THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-xlate[1]").
	  WHEN "EXTERNAL-INTERNAL-TRAN-TABLE" THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-xlate[2]").
	  WHEN "CASE-INSENSITIVE-SORT"        THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-collate[1]").
	  WHEN "CASE-SENSITIVE-SORT"          THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-collate[2]").
	  WHEN "UPPERCASE-MAP"                THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-collate[3]").
	  WHEN "LOWERCASE-MAP"                THEN 
	   RUN Load_Tran_Collate_Tbl ("_Db-collate[4]").
	  OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
             */
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "s" THEN DO: /*--------------------------------------------*/
  
        CASE ikwd:
	  WHEN "SEQUENCE"       THEN wseq._Seq-Name = iarg.
	  WHEN "INITIAL"        THEN wseq._Seq-Init = INTEGER(iarg).
	  WHEN "INCREMENT"      THEN wseq._Seq-Incr = INTEGER(iarg).
	  WHEN "CYCLE-ON-LIMIT" THEN wseq._Cycle-Ok = ( IF iarg = "yes" then "Y"
	                                                                   ELSE "N").
	  WHEN "MIN-VAL"        THEN wseq._Seq-Min  = INTEGER(iarg).
	  WHEN "MAX-VAL"        THEN wseq._Seq-Max  = INTEGER(iarg).
	  WHEN "FOREIGN-NAME"   THEN wseq._Seq-Misc[1] = iarg.
	  WHEN "FOREIGN-OWNER"  THEN wseq._Seq-Misc[2] = iarg.
	  OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END.
  
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "t" THEN DO: /*--------------------------------------------*/
         Table_name = wfil._file-name.
         CASE ikwd:
	  WHEN "FILE"       OR WHEN "TABLE"      THEN wfil._File-name = iarg.
	  WHEN "AREA"  THEN. /* Ignor for DB2/400 */
	  WHEN    "CAN-CREATE" OR WHEN "CAN-INSERT" THEN wfil._Can-Create = iarg.
	  WHEN    "CAN-READ"   OR WHEN "CAN-SELECT" THEN wfil._Can-Read = iarg.
	  WHEN    "CAN-WRITE"  OR WHEN "CAN-UPDATE" THEN wfil._Can-Write = iarg.
	  WHEN    "CAN-DELETE"     THEN wfil._Can-Delete = iarg.
	  WHEN    "CAN-DUMP"       THEN wfil._Can-Dump = iarg.
	  WHEN    "CAN-LOAD"       THEN wfil._Can-Load = iarg.
	  WHEN    "TYPE"           THEN wfil._Db-lang = LOOKUP(iarg,"SQL").
	  WHEN    "LABEL"          THEN wfil._File-Label = iarg.
	  WHEN    "LABEL-SA"       THEN wfil._File-Label-SA = iarg. 
	  WHEN    "DESCRIPTION"    THEN DO: 
	      IF LENGTH(iarg) < 51 OR iarg = ? THEN wfil._Desc = iarg.
	      ELSE DO:
 	        ASSIGN wfil._Desc = SUBSTRING(iarg,1,50)
 	             lfld = "Desc"
                     Entity_name = wfil._File-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).
                END.
            END.
	  WHEN    "VALEXP"         THEN DO:
	      IF LENGTH(TRIM(iarg)) < 257 OR iarg = ? THEN wfil._Valexp = TRIM(iarg).
              ELSE DO:
                 ASSIGN lfld = "Valexp"
                     Entity_name = wfil._File-name.
                     RUN Error_Log (INPUT 1, INPUT iobj).
                 END.
            END.
	  WHEN    "VALMSG"         THEN DO:
	      IF LENGTH(TRIM(iarg)) < 129 OR iarg = ? THEN wfil._Valmsg = iarg.             
              ELSE DO:
	         ASSIGN wfil._Valmsg = SUBSTRING(iarg,1,128)
	             lfld = "Valmsg"	                 
                     Entity_name = wfil._File-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).   
                 END.
            END.
	  WHEN    "VALMSG-SA"      THEN wfil._Valmsg-SA = iarg.
	  WHEN    "FROZEN"         THEN wfil._Frozen = (IF iarg = 'yes' THEN "Y" ELSE "N").
	  WHEN    "HIDDEN"         THEN wfil._Hidden = (IF iarg = 'yes' THEN "Y" ELSE "N").
	  WHEN    "DUMP-NAME"      THEN wfil._Dump-name = iarg.
  /* New AS400 Format Fields */
    WHEN    "AS400-FILE"     THEN wfil._As4-File = iarg.
	  WHEN    "FLD-NAMES-LIST" OR WHEN    "AS400-FLAGS"    THEN wfil._Fil-Misc2[4] = iarg.
    WHEN    "FORMAT-NAME"    THEN wfil._For-Format = iarg.
    WHEN    "PROCEDURE"      THEN wfil._For-Info = "PROCEDURE".
  /* End AS400 New Format Fields */

 	  WHEN    "FOREIGN-FLAGS"  THEN wfil._For-Flag = INTEGER(iarg).
  /* Not used or generated fields, don't overwrite. */
	  WHEN    "FOREIGN-FORMAT" THEN . /* wfil._For-Format = iarg */
	  WHEN    "FOREIGN-GLOBAL" THEN . /* wfil._For-Cnt1 = */
	  WHEN    "FOREIGN-ID"     THEN . /* wfil._For-Id = INTEGER(iarg) */
          WHEN    "FOREIGN-LEVEL"  THEN . /* wfil._Fil-misc1[4] = INTEGER(iarg) */
	  WHEN    "FOREIGN-LOCAL"  THEN . /* wfil._For-Cnt2 = INTEGER(iarg) */
	  WHEN    "FOREIGN-MARK"   THEN . /* wfil._For-Info = INTEGER(iarg) */
	  WHEN    "FOREIGN-NAME"   THEN . /* wfil._For-Name = iarg */
	  WHEN    "FOREIGN-NUMBER" THEN . /* wfil._For-number = INTEGER(iarg) */
	  WHEN    "FOREIGN-OWNER"  THEN . /* wfil._For-Owner = iarg */
 	  WHEN    "FOREIGN-SIZE"   THEN . /* wfil._For-Size = INTEGER(iarg) */
	  WHEN    "FOREIGN-TYPE"   THEN . /* wfil._For-Type = iarg */
 	  WHEN    "PROGRESS-RECID"  
	  OR WHEN "FILE-MISC11"    THEN . /* wfil._Fil-misc1[1] = INTEGER(iarg) */
	  WHEN    "FOREIGN-SPAN"    
	  OR WHEN "FILE-MISC12"    THEN . /* wfil._Fil-misc1[2] = INTEGER(iarg) */
	  WHEN    "INDEX-FREE-FLD"  
	  OR WHEN "FILE-MISC13"    THEN . /* wfil._Fil-misc1[3] = INTEGER(iarg) */
	  WHEN     "OVERLOAD-NR"     
	  OR WHEN "FILE-MISC14"    THEN . /* wfil._Fil-misc1[4] = INTEGER(iarg) */
	  WHEN    "FILE-MISC15"    THEN . /* wfil._Fil-misc1[5] = INTEGER(iarg) */
	  WHEN    "FILE-MISC16"    THEN . /* wfil._Fil-misc1[6] = INTEGER(iarg) */
	  WHEN    "FILE-MISC17"    THEN . /* wfil._Fil-misc1[7] = INTEGER(iarg) */
	  WHEN    "FILE-MISC18"    THEN . /* wfil._Fil-misc1[8] = INTEGER(iarg) */
	  WHEN    "QUALIFIER"       
	  OR WHEN "FILE-MISC21"    THEN . /* wfil._Fil-misc2[1] = iarg */
	  WHEN    "HIDDEN-FLDS"     
	  OR WHEN "FILE-MISC22"    THEN . /* wfil._Fil-misc2[2] = iarg */
	  WHEN    "RECID-FLD-NAME"  
	  OR WHEN "FILE-MISC23"    THEN . /* wfil._Fil-misc2[3] = iarg */
	  WHEN "FILE-MISC24"       THEN . /* wfil._Fil-misc2[4] = iarg */
	  WHEN    "FILE-MISC25"    THEN wfil._Fil-misc2[5] = iarg.
	  WHEN    "FILE-MISC26"    THEN . /* wfil._Fil-misc2[6] = iarg */
	  WHEN    "FILE-MISC27"    THEN . /* wfil._Fil-misc2[7] = iarg */
	  WHEN    "DB-LINK-NAME"    
	  OR WHEN "FILE-MISC28"    THEN . /* wfil._Fil-misc2[8] = iarg */
	  WHEN    "FILE-TRIGGER" OR WHEN "TABLE-TRIGGER" THEN DO:
	    FIND FIRST wfit WHERE wfit._Event = iarg NO-ERROR.
	    IF NOT AVAILABLE wfit THEN CREATE wfit.
        CASE ilin[2]:
            WHEN "REPLICATION-CREATE" THEN wfit._Event = "RCREAT".
            WHEN "REPLICATION-DELETE" THEN wfit._Event = "RDELET".
            WHEN "REPLICATION-WRITE" THEN wfit._Event = "RWRITE".
            OTHERWISE wfit._Event = ilin[2].
        END CASE.
	    CASE ilin[3]:
	      WHEN "DELETE" OR WHEN "DROP" OR WHEN "REMOVE" THEN
				    wfit._Proc-Name = "!":u.
	      WHEN "OVERRIDE"    THEN wfit._Override = "Y".
	      WHEN "NO-OVERRIDE" THEN wfit._Override = "N".
	    END CASE.
	    IF ilin[4] = "PROCEDURE":u THEN wfit._Proc-Name = ilin[5].
	    IF ilin[6] = "CRC" THEN wfit._Trig-CRC = 
	      (IF ilin[7] = ? THEN ? ELSE INTEGER(ilin[7])).
	    ilin = ?.
	  END.
	  OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
  
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "f" THEN DO: /*--------------------------------------------*/
             
        CASE ikwd:
	  WHEN    "AS" OR WHEN "TYPE" THEN
	    wfld._Data-type = (IF     iarg = "boolean" THEN "logical"
			    ELSE IF iarg = "dbkey"   THEN "recid" ELSE iarg).
	  WHEN    "FIELD"     OR WHEN "COLUMN"      THEN wfld._Field-name = iarg.
	  WHEN    "DESC"      OR WHEN "DESCRIPTION" THEN DO: 
	      IF LENGTH(iarg) < 51 OR iarg = ?  THEN wfld._Desc = iarg.
	      ELSE DO:
 	        ASSIGN wfld._Desc = SUBSTRING(iarg,1,50)
 	             lfld = "Desc"
                     Entity_name = wfld._Field-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).
                END.
          END.
          WHEN "POSITION" THEN .
          WHEN "SQL-WIDTH" THEN .
	  WHEN    "INITIAL"   OR WHEN "DEFAULT"     THEN wfld._Initial = iarg.
	  WHEN    "CAN-READ"  OR WHEN "CAN-SELECT"  THEN wfld._Can-Read = iarg.
	  WHEN    "CAN-WRITE" OR WHEN "CAN-UPDATE"  THEN wfld._Can-Write = iarg.
	  WHEN    "NULL" OR WHEN "NULL-ALLOWED" THEN 
	           wfld._Fld-Misc2[2] = (IF iarg = "no" then "N" else "Y").
	  WHEN    "FORMAT"                 THEN wfld._Format = iarg.
	  WHEN    "FORMAT-SA"              THEN wfld._Format-SA = iarg.
	  WHEN    "LABEL"                  THEN wfld._Label = iarg.
	  WHEN    "LABEL-SA"               THEN wfld._Label-SA = iarg.
	  WHEN    "COLUMN-LABEL"           THEN wfld._Col-label = iarg.
	  WHEN    "COLUMN-LABEL-SA"        THEN wfld._Col-label-SA = iarg.
	  WHEN    "INITIAL-SA"             THEN wfld._Initial-SA = iarg.
	  WHEN    "VALEXP"                 THEN DO:
	      IF LENGTH(TRIM(iarg)) < 257 OR iarg = ? THEN wfld._Valexp = TRIM(iarg).
              ELSE DO:
                 ASSIGN lfld = "Valexp"
                     Entity_name = wfld._Field-name.
                     RUN Error_Log (INPUT 1, INPUT iobj).
                 END.
            END.
	  WHEN    "VALMSG"                 THEN DO: 
	      IF LENGTH(TRIM(iarg)) < 129 OR iarg = ? THEN wfld._Valmsg = TRIM(iarg).             
              ELSE DO:
	         ASSIGN wfld._Valmsg = SUBSTRING(iarg,1,128)
	             lfld = "Valmsg"	                 
                     Entity_name = wfld._Field-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).  
                 END.
            END.
	  WHEN    "VALMSG-SA"              THEN wfld._Valmsg-SA = iarg.
	  WHEN    "VIEW-AS"                THEN DO: 
             IF LENGTH(TRIM(iarg)) < 129 OR iarg = ? THEN wfld._View-As = TRIM(iarg).
	       ELSE DO:
                 ASSIGN lfld = "View-As"
                     Entity_name = wfld._Field-name.
                     RUN Error_Log (INPUT 1, INPUT iobj).
               END.
            END.
	  WHEN    "HELP"                   THEN DO: 
	      IF LENGTH(TRIM(iarg)) < 129 OR iarg = ?  THEN wfld._Help = TRIM(iarg).
	      ELSE DO:
                ASSIGN lfld = "Help"
                     wfld._Help = SUBSTRING(iarg,1,128)
                     Entity_name = wfld._Field-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).
               END.
            END.
          WHEN    "HELP-SA"                THEN wfld._Help-SA = iarg.
	  WHEN    "EXTENT"                 
	        THEN wfld._Extent = (IF iarg <> ? THEN INTEGER(iarg) ELSE 0).
	  WHEN    "DECIMALS" 
	  OR WHEN "LENGTH" 
	  OR WHEN "SCALE" 
	  OR WHEN "FOREIGN-BITS"           THEN
	      wfld._Decimals = (IF iarg <> ? THEN INTEGER(iarg) ELSE 0).
	  WHEN    "ORDER"                  THEN wfld._Order         = INTEGER(iarg).
	  WHEN    "MANDATORY"              THEN wfld._Mandatory = 
	                  (IF iarg = "no" THEN "N" else "Y").
	  WHEN    "CASE-SENSITIVE"         THEN wfld._Fld-case      = 
	                  (IF iarg = "no" THEN "N" else "Y").  

/*  AS400 New Format Fields  */
    WHEN    "INPUT"                  THEN wfld._Fld-misc1[2] = 1.
    WHEN    "OUTPUT"                 THEN wfld._Fld-misc1[2] = 3.
    WHEN    "INPUT/OUTPUT"           THEN wfld._Fld-Misc1[2] = 2.
    WHEN    "FLD-USAGE-TYPE"         THEN wfld._Fld-misc2[5]  = iarg.
    WHEN    "DDS-TYPE"               THEN wfld._Fld-misc2[6]  = iarg.
    WHEN    "CASEI-FIELD"            THEN wfld._Fld-misc2[8]  = "Y".
    WHEN    "FLD-STDTYPE"            THEN wfld._Fld-stdtype   = INTEGER(iarg).
    WHEN    "FLD-STLEN"  OR WHEN "FOREIGN-SIZE"  THEN wfld._Fld-stlen = INTEGER(iarg).
    WHEN    "FOREIGN-ALLOCATED"      THEN wfld._For-Allocated = INTEGER(iarg).
    WHEN    "FOREIGN-MAXIMUM"        THEN wfld._For-Maxsize   = INTEGER(iarg).
    WHEN    "FOREIGN-NAME"           THEN wfld._For-Name      = iarg.
    WHEN    "AS400-TYPE"
	  OR WHEN "FOREIGN-TYPE"           THEN wfld._For-Type      = iarg.
    WHEN    "NULL-CAPABLE"           THEN 
                wfld._Fld-Misc2[2] = (IF iarg = "no" THEN "N" else "Y").
    WHEN    "SHADOW-COL"	            
	  OR WHEN "FIELD-MISC22"           THEN wfld._Fld-misc2[2]  = iarg.
    WHEN    "MAX-GLYPHS"               THEN wfld._Fld-misc1[5]  = INTEGER(iarg).
/*  End As400 New Format Fields */
/*  Handle keyword but allow appropriate values to to generated */
	  WHEN "FOREIGN-POS"               THEN . /* wfld._Fld-stoff  */
	  WHEN    "FOREIGN-CODE"           THEN . /* wfld._For-Itype  */
	  WHEN    "FOREIGN-ID"             THEN . /* wfld._For-Id  */
	  WHEN    "FOREIGN-MARK"           THEN . /* unused in V7 */
	  WHEN    "FOREIGN-RETRIEVE"       THEN wfld._For-retrieve  = (IF iarg = "yes" THEN "Y" ELSE "N").
	  WHEN    "FOREIGN-SCALE"          THEN wfld._For-Scale     = INTEGER(iarg).
	  WHEN    "FOREIGN-SEP"            THEN wfld._For-Separator = iarg.
	  WHEN    "FOREIGN-SPACING"        THEN wfld._For-Spacing   = INTEGER(iarg).
	  WHEN    "FOREIGN-XPOS"           THEN . /* wfld._For-Xpos      = */
	  WHEN    "DSRVR-PRECISION"         
	  OR WHEN "FIELD-MISC11"           THEN . /* wfld._Fld-misc1[1]  = */
	  WHEN    "DSRVR-SCALE"	            
	  OR WHEN "FIELD-MISC12"           THEN . /* wfld._Fld-misc1[2]  = */
	  WHEN    "DSRVR-LENGTH"	    
	  OR WHEN "FIELD-MISC13"           THEN . /* wfld._Fld-misc1[3]  = */
	  WHEN    "DSRVR-FLDMISC"	    
	  OR WHEN "FIELD-MISC14"           THEN . /* wfld._Fld-misc1[4]  = */
	  WHEN    "DSRVR-SHADOW"	    
	  OR WHEN "FIELD-MISC15"           THEN . /* wfld._Fld-misc1[5]  = INTEGER(iarg) */
	  WHEN    "FIELD-MISC16"           THEN wfld._Fld-misc1[6]  = INTEGER(iarg).
	  WHEN    "FIELD-MISC17"           THEN . /* wfld._Fld-misc1[7]  = INTEGER(iarg) */
	  WHEN    "FIELD-MISC18"           THEN . /* wfld._Fld-misc1[8]  = INTEGER(iarg) */
	  WHEN    "FIELD-MISC21"           THEN . /* wfld._Fld-misc2[1]  = iarg. */
	  WHEN    "QUOTED-NAME"	            
	  OR WHEN "FIELD-MISC23"           THEN . /* wfld._Fld-misc2[3]  = iarg. */
	  WHEN    "MISC-PROPERTIES"         
	  OR WHEN "FIELD-MISC24"           THEN . /* wfld._Fld-misc2[4]  = iarg. */
	  WHEN    "SHADOW-NAME"	            
	  OR WHEN "FIELD-MISC25"           THEN . /* wfld._Fld-misc2[5]  = iarg. */
	  WHEN    "FIELD-MISC26"           THEN . /* wfld._Fld-misc2[6]  = iarg. */
	  WHEN    "FIELD-MISC27"           THEN . /* wfld._Fld-misc2[7]  = iarg. */
	  WHEN    "FIELD-MISC28"           THEN . /* wfld._Fld-misc2[8]  = iarg. */
	  WHEN    "FIELD-TRIGGER"          THEN DO:
	    FIND FIRST wflt WHERE wflt._Event = iarg NO-ERROR.
	    IF NOT AVAILABLE wflt THEN CREATE wflt.
	    wflt._Event = ilin[2].
	    CASE ilin[3]:
	      WHEN "DELETE" OR WHEN "DROP" OR WHEN "REMOVE" THEN
				    wflt._Proc-Name = "!":u.
	      WHEN "OVERRIDE"    THEN wflt._Override = "Y".
	      WHEN "NO-OVERRIDE" THEN wflt._Override = "N".
	    END CASE.
	    IF ilin[4] = "PROCEDURE" THEN wflt._Proc-Name = ilin[5].
	    if ilin[6] = "CRC" THEN wflt._Trig-CRC = 
	      (IF ilin[7] = ? THEN ? ELSE INTEGER(ilin[7])).
	    ilin = ?.
	  END.
	  OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
        
        /* if _For-name is assigned we have an AS400 format df.  Make sure
           that the null capable value is set before going to field procedure
        */   
        IF wfld._For-name <> "" AND wfld._For-name <> ? THEN DO:
          IF wfld._Fld-misc2[2] = "" OR wfld._Fld-misc2[2] = ? THEN
             ASSIGN wfld._Fld-misc2[2] = "N".
        END.     
      END. /*-------------------------------------------------------------------*/
      ELSE IF iobj = "i" THEN DO: /*--------------------------------------------*/

        CASE ikwd:
	  WHEN "INDEX" OR WHEN "KEY" THEN widx._Index-Name = iarg.
	  WHEN "AREA"                THEN. /* Ignor for DB2/400 */	  
	  WHEN "UNIQUE"              THEN widx._Unique = "Y".
	  WHEN "INACTIVE"            THEN widx._Active = "N".
	  WHEN "PRIMARY"             THEN iprimary = TRUE.
	  WHEN "WORD"                THEN widx._Wordidx = 1. 
	  WHEN "INDEX-NUM"           THEN . /* widx._Idx-num = INTEGER(iarg) */
/* As400 New Format Fields */
          WHEN "FOREIGN-TYPE"
          OR WHEN "FORMAT-NAME"      THEN widx._For-type = iarg.
          WHEN "AS400-FILE"          THEN widx._As4-File = iarg.
          WHEN "AS400-FLAGS"         THEN widx._I-Misc2[4] = iarg.
/* End As400 New Format */
          WHEN "FOREIGN-LEVEL"       THEN . /* widx._I-misc1[1] = INTEGER(iarg).*/
	  WHEN "FOREIGN-NAME"        THEN . /* widx._For-name = iarg.*/
	  WHEN "RECID-INDEX"         THEN . /* widx._I-misc2[1] = iarg.*/
	  WHEN "DESC" OR WHEN "DESCRIPTION" THEN DO:
	      IF LENGTH(iarg) < 51 THEN widx._Desc = iarg.
	      ELSE DO:
 	        ASSIGN widx._Desc = SUBSTRING(iarg,1,50)
 	             lfld = "Desc"
                     Entity_name = widx._Index-name.
                     RUN Error_Log (INPUT 2, INPUT iobj).
                END.
            END.
	  WHEN "INDEX-FIELD" OR WHEN "KEY-FIELD" THEN DO:
	    FIND as4dict.p__Field
	      WHERE as4dict.p__Field._File-number = pfilenumber
	        AND TRIM(as4dict.p__Field._Field-name) = ilin[2] NO-ERROR.
	    IF imod <> "a":u THEN ierror = 12.
	      /* "Cannot add index field to existing index" */
	    IF NOT AVAILABLE as4dict.p__Field THEN ierror = 13. /* "Cannot find field to index" */
	    IF ierror > 0 THEN UNDO,RETRY load_loop.	     
	    CREATE wixf.
	    ASSIGN
	      icomponent        = icomponent + 1
	      wixf._Index-Seq   = icomponent
	      wixf._Field-recid = RECID(as4dict.p__Field)    
	      wixf._Fld-number = as4dict.p__Field._Fld-number
	      wixf._Ascending   = "Y".
	    IF ilin[3] BEGINS "DESC":u OR ilin[4] BEGINS "DESC":u
	      OR ilin[5] BEGINS "DESC":u THEN wixf._Ascending  = "N".
	    IF ilin[3] BEGINS "ABBR":u OR ilin[4] BEGINS "ABBR":u
	      OR ilin[5] BEGINS "ABBR":u THEN wixf._Abbreviate = "Y".
	    IF ilin[3] BEGINS "UNSO":u OR ilin[4] BEGINS "UNSO":u
	      OR ilin[5] BEGINS "UNSO":u THEN . /* wixf._Unsorted   = "Y" */
	    ilin = ?.
           END.
	  OTHERWISE ierror = 4. /* "Unknown &2 keyword" */
        END CASE.
  
      END. /*-------------------------------------------------------------------*/
      IF ierror > 0 THEN UNDO,RETRY load_loop.

    END.  /* end repeat load_loop*/

    stopped = false.
  END.  /* end stop */

  IF stopped 
   THEN DO:
      run adecomm/_setcurs.p ("").
      MESSAGE "Load terminated."
        	   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
   ELSE DO:  /* all but last definition-set executed */
    IF NOT (ierror > 0 AND user_env[4] BEGINS "y":u) THEN
    finish: DO:
      /* Copy any remaining buffer values to the database */
      run adecomm/_setcurs.p ("WAIT").
      IF AVAILABLE wfil THEN RUN "as4dict/load/_lod_fil.p".
      IF AVAILABLE wfld THEN RUN "as4dict/load/_lod_fld.p".
      IF AVAILABLE widx THEN RUN "as4dict/load/_lod_idx.p".
      IF AVAILABLE wseq THEN RUN "as4dict/load/_lod_seq.p".
      run adecomm/_setcurs.p ("").

      /* Error occurred when trying to save data from last command? */
      IF ierror > 0 THEN DO:
        RUN Show_Error ("prev").                
        IF user_env[4] BEGINS "y":u THEN LEAVE finish.
      END.
  
      IF ct_changed THEN 
         /*MESSAGE "The .df file just loaded contains translation or" SKIP
	       "collation tables that are different from the ones" SKIP
	       "that were already in the database." SKIP(1)
	       "You must rebuild your indices in order to ensure" SKIP
	       "data integrity." SKIP(1)
      	       "The tables will not take effect until you disconnect" SKIP
      	       "from the database and reconnect."*/
         MESSAGE "The .df file just loaded contains translation or" SKIP
	         "collation tables that are different from the ones" SKIP
	         "that were already in the database." SKIP(1)
      	         "You will not be able to use this database in any" SKIP
      	         "way until you rebuild its indices."
	       VIEW-AS ALERT-BOX WARNING BUTTONS OK.

      run adecomm/_setcurs.p ("WAIT").

      RUN "as4dict/load/_lodfini.p".
    END.   /* finish: */
    
  END.     /* all but last definition-set executed */

  /* Make sure we reset ourselves back to the current database. */
  IF sav_drec <> drec_db
    THEN ASSIGN
       user_dbname = sav_dbnam
       drec_db     = sav_drec.

  INPUT CLOSE.
  HIDE MESSAGE NO-PAUSE.

  IF TERMINAL <> ""
   THEN DO:  /* TERMINAL <> "" */
    HIDE FRAME working NO-PAUSE.
    IF NOT (xerror OR stopped) 
     THEN DO:
      IF CURRENT-WINDOW:MESSAGE-AREA = yes 
       THEN MESSAGE "Phase 1 of Load completed.  Working.  Please wait ...".
       ELSE VIEW FRAME working2.
          /* CISAM renumbers the _Fieldpos everytime a field gets added,*/
          /* deleted or it's name changed. Triggers are also referenced */
          /* by fieldpos, so we gotta run that program                  */
          /*  if user_dbtype = "CISAM"                                  */
          /* THEN FOR EACH _File                                        */
          /*   WHERE _File._DB-recid = drec_db:                         */
          /*   RUN prodict/ism/_ism_trg.p (RECID(_File)).               */
          /*   END.                                                     */
      END.
    ELSE DO:
      ASSIGN dba_cmd = "ROLLBACK"
             user_env[35] = "error".
      RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
      { as4dict/setdirty.i &dirty = "false" }
      IF CURRENT-WINDOW:MESSAGE-AREA = yes
        THEN MESSAGE "Error occured during load. Backing out - Please wait ...".
      ELSE 
         VIEW FRAME backout.
     END.
   END.     /* TERMINAL <> "" */

  IF xerror  
     THEN assign user_path = "*R":u.
  PAUSE 2 NO-MESSAGE. /* to make sure message doesn't flash by too fast */
  HIDE FRAME backout  NO-PAUSE.
  HIDE FRAME working2 NO-PAUSE.
  HIDE message no-pause.

  /* Close Error File if we had one */
  IF User_env[27] BEGINS "y" THEN OUTPUT CLOSE.
 
  IF NOT User_Env[28] BEGINS "y" AND diag_errs THEN 
     IF User_env[27] BEGINS "y" THEN 
       MESSAGE "Error(s) occurred during the load process which"
               "were not displayed to the screen. Some definitions"
               "may not have been loaded. Check error file " fil-e
               " in your working directory"
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     ELSE
       MESSAGE "Error(s) occurred during the load process which"
               "were not displayed to the screen. Some definitions"
               "may not have been loaded. " 
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                  
  run adecomm/_setcurs.p ("").

  SESSION:IMMEDIATE-DISPLAY = no.

  END.     /* conversion not needed OR needed and possible */

RETURN.






