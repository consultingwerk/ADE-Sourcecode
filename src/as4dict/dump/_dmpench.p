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

/* _dmpench.p - phase 2 of incremental .df maker 

  as4dict  is the current database
  as4dict2 is the database to update

   The aim is to produce a database like as4dict.  So this .df file will be
   run against a old version database to create a database like as4dict.
   Created 12/26/00 D. McMann
*/

/*
as4dict  = new definitions

for each file:
  match up filename
  match up indexnames
  match up fieldnames
  handle differences
end.

match up:
  find object of same name.
  if found, leave.
  otherwise, make note and continue until all matched.
  if none left over, assume deletes.
  otherwise, ask if renamed.
  return.
end.
*/
/*
in:       user_env[2] = Name of file to dump to.
          user_env[5] = "<internal defaults apply>" or "<target-code-page>"
    
changes:  user_env[19]

History:  02/12/02 Fernando Corrected sequence logic
    
        
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ as4dict/dictvar.i SHARED }
{ as4dict/dump/dumpvar.i SHARED }
{ as4dict/dump/userpik.i }

define shared frame working.
{ as4dict/dump/as4dmpdf.f &FRAME = "working" }

DEFINE VARIABLE ans	AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE c	AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fil	AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fld	AS CHARACTER               NO-UNDO.
DEFINE VARIABLE idx	AS CHARACTER               NO-UNDO.
DEFINE VARIABLE seq	AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i	AS INTEGER                 NO-UNDO.
DEFINE VARIABLE j	AS INTEGER                 NO-UNDO.
DEFINE VARIABLE l	AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE stopped AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE inpri   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE tmp_Field-name AS CHARACTER        NO-UNDO.
DEFINE VARIABLE acode  AS CHARACTER                NO-UNDO.


/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /* 1*/ "(initializing)",
  /* 2*/ ?, /* see below */
  /* 3*/ ?
].

new_lang[2] = "The incremental definitions file will cause at least "
            + "one new unique index to be created. "
            + "If PROGRESS finds duplicate values while creating unique "
            + "indexes, it will UNDO THE ENTIRE TRANSACTION, causing "
            + "you to lose any other schema changes just made. Do you want to "
            + "create indexes that are marked as unique for this file?".

new_lang[3] = "The incremental definitions file will contain syntax that "
            + "will cause data to be lost from this file.  Do you want to "
            + "copy and save the file into a new library at load time? ".

FORM
  "" SKIP
  fil LABEL "TABLE"    	COLON 9 FORMAT "x(27)" SKIP
  fld LABEL "FIELD"  	COLON 9 FORMAT "x(27)" SKIP
  idx LABEL "INDEX"  	COLON 9 FORMAT "x(27)" SKIP
  seq LABEL "SEQ" 	COLON 9 FORMAT "x(27)" SKIP
  WITH FRAME seeking OVERLAY THREE-D
    SIDE-LABELS WIDTH 40 VIEW-AS DIALOG-BOX ROW 2 COLUMN 4 USE-TEXT
    TITLE "Scanning ".

COLOR DISPLAY MESSAGES fil fld idx seq WITH FRAME seeking.

FORM
  "" SKIP
  fil LABEL "TABLE"   	COLON 9 FORMAT "x(27)" SKIP
  fld LABEL "FIELD"  	COLON 9 FORMAT "x(27)" SKIP
  idx LABEL "INDEX"  	COLON 9 FORMAT "x(27)" SKIP
  seq LABEL "SEQ" 	COLON 9 FORMAT "x(27)" SKIP
  WITH FRAME wrking OVERLAY THREE-D
  SIDE-LABELS WIDTH 40 VIEW-AS DIALOG-BOX  ROW 2 COLUMN 44 USE-TEXT
    TITLE "Working on" .

COLOR DISPLAY MESSAGES fil fld idx seq WITH FRAME wrking.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/* Definitions */ /*-------------------------------------------------------*/

DEFINE VARIABLE ddl        AS CHARACTER EXTENT 50 NO-UNDO.
DEFINE VARIABLE iact       AS LOGICAL   INITIAL ? NO-UNDO.
DEFINE VARIABLE pri1       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE pri2       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cnt        AS INTEGER             NO-UNDO.
DEFINE VARIABLE tseq       AS INTEGER             NO-UNDO.
DEFINE VARIABLE cfile      AS LOGICAL   INITIAL ? NO-UNDO.
DEFINE VARIABLE newtblname AS CHARACTER           NO-UNDO.


DEFINE NEW SHARED STREAM ddl.

DEFINE WORKFILE missing NO-UNDO
  FIELD name AS CHARACTER INITIAL "".

DEFINE NEW SHARED WORKFILE table-list NO-UNDO
  FIELD t1-name AS CHARACTER INITIAL ""
  FIELD t2-name AS CHARACTER INITIAL ?.

DEFINE NEW SHARED WORKFILE field-list NO-UNDO
  FIELD f1-name AS CHARACTER INITIAL ""
  FIELD f2-name AS CHARACTER INITIAL ?.

DEFINE NEW SHARED WORKFILE seq-list NO-UNDO
  FIELD s1-name AS CHARACTER INITIAL ""
  FIELD s2-name AS CHARACTER INITIAL ?.

DEFINE WORKFILE index-list NO-UNDO
  FIELD i1-name AS CHARACTER INITIAL ""
  FIELD i1-comp AS CHARACTER INITIAL ""
  FIELD i2-name AS CHARACTER INITIAL ?
  FIELD i1-i2   AS LOGICAL.

DEFINE BUFFER index-alt FOR index-list.

DEFINE BUFFER old-field FOR as4dict.p__Field.
DEFINE BUFFER new-field FOR as4dict2.p__field.

DEFINE NEW SHARED TEMP-TABLE sc-table NO-UNDO
    FIELD lib-name AS CHARACTER
    FIELD fil-name AS CHARACTER
    FIELD act-code AS CHARACTER
    FIELD ftype    AS CHARACTER
    INDEX alf IS UNIQUE act-code lib-name fil-name.

DEFINE NEW SHARED TEMP-TABLE act-table NO-UNDO
    FIELD a-code AS CHARACTER
    FIELD l-name AS CHARACTER
    FIELD f-name AS CHARACTER
    FIELD aseq   AS INTEGER
    FIELD syntax AS CHARACTER
    FIELD atype  AS CHARACTER
    FIELD pfname AS CHARACTER
    INDEX action IS UNIQUE a-code f-name aseq
    INDEX delidx a-code pfname
    INDEX chkidx a-code l-name f-name atype.
 
    
/* Internal Procedures */ /*------------------------------------------------*/

/* if we are about to rename an index or add a new one, see if an index 
   with this name is in the list to be deleted.  If so, rename that one 
   so we don't get a name conflict.  It will be deleted later.
*/
PROCEDURE Check_Index_Conflict:
   DEFINE VAR tempname AS CHAR INITIAL "temp-we48z576-". /* meaningless goop */

   FIND FIRST index-alt WHERE NOT index-alt.i1-i2 AND /* to be deleted */
      	      index-alt.i1-name = index-list.i1-name NO-ERROR. 
   IF AVAILABLE index-alt THEN DO:
      ASSIGN cnt = cnt + 1
             tempname = tempname + STRING(cnt).             

      CREATE act-table.
      ASSIGN a-code = "r"
             atype = "i"
             l-name = as4dict.p__File._AS4-Library
             f-name = as4dict.p__File._File-name
             aseq = tseq
             tseq = tseq + 1
             syntax = 'RENAME INDEX "' + index-alt.i1-name + '" TO "' + tempname +
                       '" ON "' + as4dict.p__File._File-name + '"'
             index-alt.i1-name = tempname.
   END.
END.

PROCEDURE tmp-name:
   /* This procedure takes a field name and renames it to a unique
    * name so it can be deleted later. This is done in the instance
    * when a field has changed data-type or extent and is part of a
    * primary index. Since the index will not be deleted until later
    * on in the code. We will rename it and delete it later
    */
   DEFINE INPUT  PARAMETER fname   AS CHAR NO-UNDO.
   DEFINE OUTPUT PARAMETER newname AS CHAR NO-UNDO.

   DEFINE VARIABLE s AS INT NO-UNDO.

   DO s = 1 to 99:
     newname = "Z_" + substring(fname,1,28) + string(s,"99").
     FIND FIRST old-field WHERE as4dict.old-field._Field-name = newname
          NO-ERROR.
     IF NOT AVAILABLE(old-field) THEN DO:
       FIND FIRST new-field WHERE 
           new-field._Field-name = newname
           NO-ERROR.
       IF NOT AVAILABLE(new-field) THEN DO:
         FIND FIRST missing WHERE missing.name = newname NO-ERROR.
         IF NOT AVAILABLE(missing) THEN LEAVE. /* got it! */
       END.
     END.
   END. 
END PROCEDURE.   

PROCEDURE inprimary:
   /* Determines whether a field is part of an index */

   DEFINE INPUT PARAMETER rfield AS INTEGER        NO-UNDO. /*# of p__Field*/
   DEFINE INPUT PARAMETER rfldfil AS INTEGER       NO-UNDO.
   DEFINE OUTPUT PARAMETER prime AS LOG INITIAL no NO-UNDO. /*pri? y/n */
   
   FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._fld-number = rfield
                               AND as4dict.p__Idxfd._File-number = rfldfil:    
      ASSIGN prime = yes.
      LEAVE.
   END.
END PROCEDURE.

PROCEDURE dctquot:

   DEFINE INPUT  PARAMETER inline  AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER quotype AS CHARACTER            NO-UNDO.
   DEFINE OUTPUT PARAMETER outline AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE        VARIABLE  i       AS INTEGER              NO-UNDO.

   IF INDEX(inline,quotype) > 0 THEN
     DO i = 1 TO LENGTH(inline):
       outline = outline + (IF SUBSTRING(inline,i,1) = quotype
                 THEN quotype + quotype ELSE SUBSTRING(inline,i,1)).
     END.
   ELSE
     outline = inline.

   outline = (IF outline = ? THEN "?" ELSE quotype + outline + quotype).

END PROCEDURE.

/* ************************* mainline code ***************************************************/

IF  user_env[5] = "" 
 OR user_env[5] = ?  THEN assign user_env[5] = "<internal defaults apply>". 

IF  user_env[5] = "<internal defaults apply>" 
 THEN OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP
            NO-CONVERT.
 ELSE OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP
            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].

SESSION:IMMEDIATE-DISPLAY = yes.
DISPLAY new_lang[1] @ fil WITH FRAME seeking. /* initializing */
DISPLAY new_lang[1] @ fil WITH FRAME wrking. /* initializing */
run adecomm/_setcurs.p ("WAIT").
ASSIGN tseq = 1.
       dump_format = "AS400".

DO ON STOP UNDO, LEAVE:
  /* build missing file list for rename/delete determination */
  FOR EACH as4dict2.p__file WHERE as4dict2.p__File._For-flag = 0 NO-LOCK:
    FIND FIRST as4dict.p__File WHERE as4dict.p__File._File-name = as4dict2.p__file._File-name
	                             NO-LOCK NO-ERROR.
    DISPLAY as4dict2.p__file._File-name @ fil WITH FRAME seeking.
    IF AVAILABLE as4dict.p__File THEN NEXT.
    CREATE missing.
    missing.name = as4dict2.p__file._File-name.
  END.
  
  /* build list of new or renamed files */
  FOR EACH as4dict.p__File WHERE as4dict.p__File._For-flag = 0  NO-LOCK:
    FIND FIRST as4dict2.p__file WHERE as4dict2.p__file._File-name = as4dict.p__File._File-name NO-LOCK NO-ERROR.
    DISPLAY as4dict.p__File._File-name @ fil WITH FRAME seeking.
    CREATE table-list.
    table-list.t1-name = as4dict.p__File._File-name.
    IF AVAILABLE as4dict2.p__file THEN
      table-list.t2-name = as4dict2.p__file._File-name.
  END.
  
  /* look for matches for renamed files with user input.  A prompt 
     is given for each file that's not in as4dict but only when
     there is also a file in as4dict that's not in temp table.  The 2nd list
     is the potential values to rename to.
  */
  run adecomm/_setcurs.p ("").  /* while dmpisub is running */
  FOR EACH missing:
    DISPLAY missing.name @ fil WITH FRAME seeking.
    RUN "as4dict/dump/_dmpisub.p"
      (INPUT "t",INPUT-OUTPUT missing.name,OUTPUT ans).
    IF missing.name = ? THEN DELETE missing.
    IF ans = ? THEN DO:
      HIDE FRAME wrking NO-PAUSE.
      HIDE FRAME seeking NO-PAUSE.
      user_path = "".
      RETURN.
    END.
  END.
  run adecomm/_setcurs.p ("WAIT").
  
  /* handle deleted files */
  FOR EACH missing:
    FIND as4dict2.p__File WHERE as4dict2.p__File._File-name = missing.NAME NO-LOCK.
    FIND FIRST sc-table WHERE lib-name = as4dict2.p__File._As4-library
                          AND fil-name = as4dict2.p__File._AS4-File
                          AND act-code = "S" NO-ERROR.
    IF NOT AVAILABLE sc-table THEN DO:
      CREATE sc-table.
      ASSIGN act-code = "s"
             lib-name = as4dict2.p__File._As4-library
             fil-name = as4dict2.p__File._As4-file.
      IF as4dict2.p__File._For-info = "PROCEDURE" THEN
        ASSIGN ftype = "P".
      ELSE
        ASSIGN ftype    = "F".
    END.

    CREATE act-table.
    ASSIGN a-code = "d"
           atype = "t"
           f-name = missing.name
           aseq = tseq
           tseq = tseq + 1
           syntax = 'DROP TABLE "' + missing.NAME + '"' .
    DISPLAY missing.name @ fil WITH FRAME seeking.
    DISPLAY missing.name @ fil WITH FRAME wrking.
    DELETE missing.
  END.
  
  /* handle renamed files */
  FOR EACH table-list WHERE table-list.t1-name <> table-list.t2-name
                        AND table-list.t2-name <> ?:
    FIND as4dict2.p__File WHERE as4dict2.p__File._File-name = table-list.t2-name NO-LOCK.
    FIND FIRST sc-table WHERE lib-name = as4dict2.p__File._As4-library
                          AND fil-name = as4dict2.p__File._AS4-File
                          AND act-code = "S" NO-ERROR.
    IF NOT AVAILABLE sc-table THEN DO:
      CREATE sc-table.
      ASSIGN act-code = "s"
             lib-name = as4dict2.p__File._As4-library
             fil-name = as4dict2.p__File._As4-file.
      IF as4dict2.p__File._For-info = "PROCEDURE" THEN
          ASSIGN ftype = "P".
      ELSE
          ASSIGN ftype    = "F".
    END.

    CREATE act-table.
    ASSIGN a-code = "r"
           atype = "t"
           l-name = as4dict2.p__File._As4-library
           f-name = table-list.t2-name
           pfname = table-list.t1-name
           aseq = tseq
           tseq = tseq + 1
           syntax = 'RENAME TABLE "' + table-list.t2-name + '" TO "' +
                     table-list.t1-name + '"'.
    DISPLAY table-list.t1-name @ fil WITH FRAME seeking.
    DISPLAY table-list.t1-name @ fil WITH FRAME wrking.
  END.
  
 
  /* handle potentially altered files */
  FOR EACH table-list WHERE table-list.t2-name <> ?:
    DISPLAY table-list.t1-name @ fil "" @ fld "" @ idx WITH FRAME seeking.
    DISPLAY table-list.t1-name @ fil "" @ fld "" @ idx WITH FRAME wrking.
    FIND as4dict.p__File WHERE as4dict.p__File._File-name = table-list.t1-name NO-LOCK.
    FIND as4dict2.p__file WHERE as4dict2.p__file._File-name = table-list.t2-name NO-LOCK.
  
    /* clean out working storage */
    FOR EACH field-list:
      DELETE field-list.
    END.
    FOR EACH index-list:
      DELETE index-list.
    END.
  
    /* write out appropriate file definition changes */
    ASSIGN
      j      = 1
      ddl    = ""
      ddl[1] = 'UPDATE TABLE "' + as4dict.p__File._File-name + '"'.
    
    IF as4dict.p__file._Fil-Misc2[4] <> as4dict2.p__file._Fil-Misc2[4] THEN DO:
      RUN dctquot (as4dict.p__File._Fil-Misc2[4],'"',OUTPUT c).
      j = j + 1.
      ddl[j] = "  AS400-FLAGS " + c.
    END.  
    IF as4dict.p__file._Fil-Misc2[5] <> as4dict2.p__file._Fil-Misc2[5] THEN DO:
      RUN dctquot (as4dict.p__File._Fil-Misc2[5],'"',OUTPUT c).
      j = j + 1.
      ddl[j] = "  AS400-CI " + c.
    END.     
    IF as4dict.p__file._Fil-Misc2[6] <> as4dict2.p__file._Fil-Misc2[6] THEN DO:
      RUN dctquot (as4dict.p__File._Fil-Misc2[6],'"',OUTPUT c).
      j = j + 1.
      ddl[j] = "  AS400-VIRTUAL " + c.
    END.     
    RUN dctquot (as4dict.p__File._Can-Read,'"',OUTPUT c).
    IF as4dict.p__File._Can-read <> as4dict2.p__file._Can-read THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-READ " + c.
    RUN dctquot (as4dict.p__File._Can-Write,'"',OUTPUT c).
    IF as4dict.p__File._Can-write <> as4dict2.p__file._Can-write THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-WRITE " + c.
    RUN dctquot (as4dict.p__File._Can-Create,'"',OUTPUT c).
    IF as4dict.p__File._Can-create <> as4dict2.p__file._Can-create THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-CREATE " + c.
    RUN dctquot (as4dict.p__File._Can-Delete,'"',OUTPUT c).
    IF as4dict.p__File._Can-delete <> as4dict2.p__file._Can-delete THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-DELETE " + c.
    RUN dctquot (as4dict.p__File._Can-Dump,'"',OUTPUT c).
    IF as4dict.p__File._Can-Dump <> as4dict2.p__file._Can-Dump THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-DUMP " + c.
    RUN dctquot (as4dict.p__File._Can-Load,'"',OUTPUT c).
    IF as4dict.p__File._Can-Load <> as4dict2.p__file._Can-Load THEN ASSIGN
      j = j + 1
      ddl[j] = "  CAN-LOAD " + c.
    RUN dctquot (as4dict.p__File._Desc,'"',OUTPUT c).
    IF as4dict.p__File._Desc <> as4dict2.p__file._Desc THEN ASSIGN
      j = j + 1
      ddl[j] = "  DESCRIPTION " + c.
    RUN dctquot (as4dict.p__File._File-label,'"',OUTPUT c).
    IF as4dict.p__File._File-label <> as4dict2.p__file._File-label THEN ASSIGN
      j = j + 1
      ddl[j] = "  LABEL " + c.
    RUN dctquot (as4dict.p__File._File-label-SA,'"',OUTPUT c).
    IF as4dict.p__File._File-label-SA <> as4dict2.p__file._File-label-SA THEN ASSIGN
      j = j + 1
      ddl[j] = "  LABEL-SA " + c.
    RUN dctquot (as4dict.p__File._Valexp,'"',OUTPUT c).
    IF as4dict.p__File._Valexp <> as4dict2.p__file._Valexp THEN ASSIGN
      j = j + 1
      ddl[j] = "  VALEXP " + c.
    RUN dctquot (as4dict.p__File._Valmsg,'"',OUTPUT c).
    IF as4dict.p__File._Valmsg <> as4dict2.p__file._Valmsg THEN ASSIGN
      j = j + 1
      ddl[j] = "  VALMSG " + c.
    RUN dctquot (as4dict.p__File._Valmsg-SA,'"',OUTPUT c).
    IF as4dict.p__File._Valmsg-SA <> as4dict2.p__file._Valmsg-SA THEN ASSIGN
      j = j + 1
      ddl[j] = "  VALMSG-SA " + c.
    RUN dctquot (as4dict.p__File._Dump-name,'"',OUTPUT c).
    IF as4dict.p__File._Dump-name <> as4dict2.p__file._Dump-name THEN ASSIGN
      j = j + 1
      ddl[j] = "  DUMP-NAME " + c.
    IF as4dict.p__File._Frozen = "Y" THEN ASSIGN
      j = j + 1
      ddl[j] = "  FROZEN".
    IF as4dict.p__File._For-Info <>  as4dict2.p__File._For-Info THEN
      ASSIGN j = j + 1
             ddl[j] = "  PROCEDURE".
  
    /* deal with file triggers */
    /* 1st, find ones to be deleted */
    FOR EACH as4dict2.p__Trgfl WHERE as4dict2.p__Trgfl._File-number =
                                        as4dict2.p__file._File-number NO-LOCK:
      FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._File-number =
                                     as4dict.p__File._File-number
	                        AND as4dict.p__Trgfl._Event = as4dict2.p__Trgfl._Event NO-LOCK NO-ERROR.
      IF NOT AVAILABLE as4dict.p__Trgfl THEN DO:
        RUN dctquot (as4dict2.p__Trgfl._Event,'"',OUTPUT c).
	    j = j + 1.
	    ddl[j] = "  TABLE-TRIGGER " + c + " DELETE".
      END.
    END.
    /* now record updated or new ones */
    FOR EACH as4dict.p__Trgfl WHERE as4dict.p__Trgfl._File-number =
                                                as4dict.p__File._File-number NO-LOCK:
      FIND as4dict2.p__Trgfl WHERE as4dict2.p__Trgfl._File-number =
                                                 as4dict2.p__file._File-number
	                        AND as4dict2.p__Trgfl._Event = as4dict.p__Trgfl._Event NO-LOCK NO-ERROR.
      IF AVAILABLE as4dict2.p__Trgfl AND 
   	  as4dict2.p__Trgfl._Override = as4dict.p__Trgfl._Override AND
	  as4dict2.p__Trgfl._Proc-name = as4dict.p__Trgfl._Proc-name AND
	  as4dict2.p__Trgfl._Trig-CRC = as4dict.p__Trgfl._Trig-CRC THEN
	  NEXT.
	
      RUN dctquot (as4dict.p__Trgfl._Event,'"',OUTPUT c).
      j = j + 1.
      ddl[j] = "  TABLE-TRIGGER " + c +
	       (IF as4dict.p__Trgfl._Override = "Y" THEN " OVERRIDE " 
					       ELSE " NO-OVERRIDE ").
      RUN dctquot (as4dict.p__Trgfl._Proc-name,'"',OUTPUT c).
      ddl[j] = ddl[j] + "PROCEDURE " + c + " CRC """ 
	       + (IF as4dict.p__Trgfl._Trig-CRC = ? 
		  THEN "?" ELSE STRING(as4dict.p__Trgfl._Trig-CRC))
	       + """".
    END.
  
    /* don't write out ddl[1] if j = 1 (i.e., we only have table header) */
    IF j > 1 THEN DO i = 1 TO j + 1:
      IF ddl[i] = "" THEN.  /* this puts an extra skip after the last one */
	  ELSE DO:
        CREATE act-table.
        ASSIGN a-code = "m"
               l-name = as4dict.p__File._As4-library
               f-name = as4dict.p__File._file-name
               aseq = tseq
               tseq = tseq + 1
               syntax = ddl[i]
               ddl[i] = "".
      END.
      FIND FIRST sc-table WHERE lib-name = as4dict2.p__File._As4-library
                            AND fil-name = as4dict2.p__File._AS4-File
                            AND act-code = "S" NO-ERROR.
      IF NOT AVAILABLE sc-table THEN DO:
        CREATE sc-table.
        ASSIGN act-code = "s"
               lib-name = as4dict2.p__File._As4-library
               fil-name = as4dict2.p__File._As4-file.
        IF as4dict2.p__File._For-info = "PROCEDURE" THEN
          ASSIGN ftype = "P".
        ELSE
          ASSIGN ftype    = "F".             
      END.
    END.

    /* build missing field list for rename/delete determination */
    FOR EACH as4dict2.p__field WHERE as4dict2.p__field._File-number =
                                        as4dict2.p__file._File-number 
                                 AND as4dict2.p__field._fld-misc2[5] <> "A" NO-LOCK       
                                  BY as4dict2.p__field._fld-number:
      FIND FIRST as4dict.p__Field WHERE as4dict.p__Field._File-number =
                                            as4dict.p__File._File-number
	                              AND as4dict.p__Field._Field-name = as4dict2.p__field._Field-name NO-LOCK NO-ERROR.
      DISPLAY as4dict2.p__field._Field-name @ fld WITH FRAME seeking.
      IF AVAILABLE as4dict.p__Field THEN NEXT.
      CREATE missing.
      missing.name = as4dict2.p__field._Field-name.
    END.
  
    /* build field rename list */
    FOR EACH as4dict.p__Field WHERE as4dict.p__Field._File-number =
                                        as4dict.p__File._File-number
                                AND as4dict.p__Field._Fld-misc2[5] <> "A" NO-LOCK
                                 BY as4dict.p__Field._fld-number:
      FIND FIRST as4dict2.p__field WHERE as4dict2.p__field._File-number =
                                           as4dict2.p__file._File-number
	                              AND as4dict2.p__field._Field-name = 
	                                    as4dict.p__Field._Field-name NO-LOCK NO-ERROR.
      DISPLAY as4dict.p__Field._Field-name @ fld WITH FRAME seeking.
      CREATE field-list.
      field-list.f1-name = as4dict.p__Field._Field-name.
      IF AVAILABLE as4dict2.p__field THEN
	field-list.f2-name = as4dict2.p__field._Field-name.
    END.
  
    /* look for matches for renamed fields with user input.  A prompt 
       is given for each field that's not in as4dict but only when
       there is also a field in as4dict that's not in temp table.  The 2nd list
       is the potential values to rename to.
    */
    run adecomm/_setcurs.p ("").

    user_env[19] = as4dict.p__File._File-name. /* this is a hack */
    FOR EACH missing:
      DISPLAY missing.name @ fld WITH FRAME seeking.
      RUN "as4dict/dump/_dmpisub.p"
	(INPUT "f",INPUT-OUTPUT missing.name,OUTPUT ans).

      IF missing.name = ? THEN DELETE missing.
      IF ans = ? THEN DO:
	HIDE FRAME wrking NO-PAUSE.
	HIDE FRAME seeking NO-PAUSE.
	user_path = "".
	RETURN.
      END.
    END.
    run adecomm/_setcurs.p ("WAIT").
  
    /* We use to handle deleted fields here but now it's done after
       index stuff.  See below.
     */
  
    /* handle renamed fields */
    ans = FALSE.
    FOR EACH field-list WHERE field-list.f1-name <> field-list.f2-name
	                      AND field-list.f2-name <> ?:     
      DISPLAY field-list.f1-name @ fld WITH FRAME wrking.
      CREATE act-table.
      ASSIGN a-code = "r"
             atype = "f"
             l-name = as4dict.p__File._As4-library
             f-name = as4dict.p__File._File-name
             aseq = tseq
             tseq = tseq + 1
             syntax = 'RENAME FIELD "' + field-list.f2-name + '" OF "' +
                       as4dict.p__File._File-name + '" TO "' + field-list.f1-name + '"'.      
    END.
  
    /* handle new or potentially altered fields */
    FOR EACH field-list:
      FIND FIRST as4dict.p__Field WHERE as4dict.p__Field._File-number =
                                           as4dict.p__File._File-number
	                             AND as4dict.p__Field._Field-name = 
	                                    field-list.f1-name NO-LOCK.
      FIND FIRST as4dict2.p__field WHERE as4dict2.p__field._File-number =
                                           as4dict2.p__file._File-number
	                              AND as4dict2.p__field._Field-name = 
	                                    field-list.f2-name NO-LOCK NO-ERROR.
      DISPLAY field-list.f1-name @ fld WITH FRAME wrking.

      l = AVAILABLE as4dict2.p__field.

      IF l AND (as4dict.p__Field._Data-type <> as4dict2.p__field._Data-type
	        OR  as4dict.p__Field._Extent <> as4dict2.p__field._Extent 
            OR  as4dict.p__field._Fld-stdtype <> as4dict2.p__field._Fld-stdtype
            OR as4dict.p__field._Fld-stlen < as4dict2.p__field._fld-stlen 
            OR (as4dict.p__Field._Fld-stlen > as4dict2.p__Field._Fld-stlen 
                   AND as4dict.p__Field._Extent > 0)
            OR as4dict.p__field._For-Allocated <> as4dict2.p__field._For-Allocated 
            OR as4dict.p__field._For-Maxsize <> as4dict2.p__field._For-Maxsize 
            OR as4dict.p__field._Fld-Misc2[2] <> as4dict2.p__field._Fld-Misc2[2]) THEN DO:
     
        /* If field is part of a primary index, we cannot simply drop it.
         * instead, we will rename it to something else, and delete it
         * later, after the indexes are processed.
         */

        RUN inprimary (INPUT as4dict.p__Field._fld-number, 
                       INPUT as4dict.p__Field._File-number,
                       OUTPUT inpri).
        IF inpri THEN DO: /* field is part of primary index, don't DROP*/
          RUN tmp-name (INPUT as4dict.p__Field._Field-name, OUTPUT tmp_Field-name).
          CREATE act-table.
          ASSIGN a-code = "r"
                 atype = "f"
                 l-name = as4dict.p__File._As4-library
                 f-name = as4dict.p__File._file-name
                 aseq = tseq
                 syntax = 'RENAME FIELD "' + as4dict.p__Field._Field-name +
	                      '" OF "' + as4dict.p__File._File-name + '" TO "' +
                           tmp_Field-name + '"' 
                 tseq = tseq + 1.

          CREATE missing. 
          ASSIGN missing.name = tmp_Field-name. /*record name to 'DROP' later*/
        END.
        ELSE  DO:            /* is not in a primary index, we can DROP it now */
          FIND FIRST sc-table WHERE lib-name = as4dict2.p__File._As4-library
                                AND fil-name = as4dict2.p__File._AS4-File
                                AND act-code = "c"
                                NO-ERROR.
          IF NOT AVAILABLE sc-table THEN DO:
	        ASSIGN cfile = TRUE.
            RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT cfile,?,?,new_lang[3]).
            IF cfile THEN DO:
              CREATE sc-table.
              ASSIGN act-code = "c"
                     lib-name = as4dict2.p__File._As4-library
                     fil-name = as4dict2.p__File._As4-file.
              IF as4dict2.p__File._For-info = "PROCEDURE" THEN
                ASSIGN ftype = "P".
              ELSE
                ASSIGN ftype    = "F".
            END.
          END.
          CREATE act-table.
          ASSIGN a-code = "d"
                 atype = "f"
                 l-name = as4dict.p__File._As4-library
                 f-name = as4dict.p__File._file-name
                 aseq = tseq
                 syntax = 'DROP FIELD "' + as4dict.p__Field._Field-name +
	                      '" OF "' + as4dict.p__File._File-name + '"'
                 tseq = tseq + 1.
        END.
	    RELEASE as4dict2.p__field.
	    l = FALSE.
      END.
  
      /* If l is true we're updating otherwise we're adding */
      ASSIGN ddl = ""
               j = 1.
       /*fernando:  20020205-028 changed the if length(2) 
       to output "" to keep consistent with the current schema". Not sure why this
       condition was put in place, but we could simply add the value coming from c, 
       and take the condition off. The ? is being put by ELSE condition */
	    ddl[j] = (IF l THEN "UPDATE" ELSE "ADD")
	             + ' FIELD "' + as4dict.p__Field._Field-name
	             + '" OF "' + as4dict.p__File._File-name + '"'
	             + (IF l THEN "" ELSE " AS " + as4dict.p__Field._Data-type).
        IF NOT l OR as4dict.p__Field._Desc <> as4dict2.p__field._Desc THEN DO:
          IF l AND (as4dict.p__Field._Desc = ? OR as4dict.p__Field._Desc = "") THEN.
          ELSE DO:         
            RUN dctquot (as4dict.p__Field._Desc,'"',OUTPUT c). 
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  DESCRIPTION " + '""' ELSE "  DESCRIPTION " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Format <> as4dict2.p__field._Format THEN DO:          
          RUN dctquot (as4dict.p__Field._Format,'"',OUTPUT c).
          ASSIGN j = j + 1
            ddl[j] = (IF length(c) = 2 THEN "  FORMAT " + '""' ELSE "  FORMAT " + c). 
        END. 
        IF NOT l OR as4dict.p__Field._Format-SA <> as4dict2.p__field._Format-SA THEN DO:
          IF NOT l AND (as4dict.p__Field._Format-SA = ? OR as4dict.p__Field._Format-SA = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Format-SA,'"',OUTPUT c).              
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  FORMAT-SA " + '""' ELSE "  FORMAT-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Initial <> as4dict2.p__field._Initial THEN DO:
          IF NOT l AND (as4dict.p__Field._Initial = ? OR as4dict.p__Field._Initial = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Initial,'"',OUTPUT c). 
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  INITIAL " + '""' ELSE "  INITIAL " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Initial-SA <> as4dict2.p__field._Initial-SA THEN DO:
          IF NOT l AND (as4dict.p__Field._Initial-SA = ? OR as4dict.p__Field._Initial-sa = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Initial-SA,'"',OUTPUT c).
            ASSIGN j = j + 1
	          ddl[j] = (IF length(c) = 2 THEN "  INITIAL-SA " + '""' ELSE "  INITIAL-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Help <> as4dict2.p__field._Help THEN DO:
          IF NOT l AND (as4dict.p__Field._Help = ? OR as4dict.p__Field._Help = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Help,'"',OUTPUT c).    
            ASSIGN j = j + 1
	           ddl[j] = (IF length(c) = 2 THEN "  HELP " + '""' ELSE "  HELP " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Help-SA <> as4dict2.p__field._Help-SA THEN DO: 
          IF NOT l AND (as4dict.p__Field._Help-SA = ? OR as4dict.p__Field._Help-SA = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Help-SA,'"',OUTPUT c).
            ASSIGN j = j + 1
	          ddl[j] = (IF length(c) = 2 THEN "  HELP-SA " + '""' ELSE "  HELP-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Label <> as4dict2.p__field._Label THEN DO:
          IF NOT l AND (as4dict.p__Field._Label = ? OR as4dict.p__Field._Label = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Label,'"',OUTPUT c).    
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  LABEL " + '""' ELSE "  LABEL " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Label-SA <> as4dict2.p__field._Label-SA THEN DO:
          IF NOT l AND (as4dict.p__Field._Label-SA = ? OR as4dict.p__Field._Label-SA = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Label-SA,'"',OUTPUT c).    
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  LABEL-SA " + '""' ELSE "  LABEL-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Col-label <> as4dict2.p__field._Col-label THEN DO:
          IF NOT l AND (as4dict.p__Field._Col-label = ? OR as4dict.p__Field._Col-label = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Col-label,'"',OUTPUT c).    
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  COLUMN-LABEL " + '""' ELSE "  COLUMN-LABEL " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Col-label-SA <> as4dict2.p__field._Col-label-SA THEN DO:
          IF NOT l AND (as4dict.p__Field._Col-label-SA = ? OR as4dict.p__Field._Col-label-SA = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Col-label-SA,'"',OUTPUT c).
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  COLUMN-LABEL-SA " + '""' ELSE "  COLUMN-LABEL-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Can-read <> as4dict2.p__field._Can-read THEN DO:
          IF NOT l AND (as4dict.p__Field._Can-read = ? OR as4dict.p__Field._Can-read = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Can-Read,'"',OUTPUT c).      
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  CAN-READ " + '""' ELSE "  CAN-READ " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Can-write <> as4dict2.p__field._Can-write THEN DO:
          IF NOT l AND (as4dict.p__Field._Can-write = ? OR as4dict.p__Field._Can-write = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Can-Write,'"',OUTPUT c).
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  CAN-WRITE " + '""' ELSE "  CAN-WRITE " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Valexp <> as4dict2.p__field._Valexp THEN DO:
          IF NOT l AND (as4dict.p__Field._Valexp = ? OR as4dict.p__Field._Valexp = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Valexp,'"',OUTPUT c).      
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  VALEXP " + '""' ELSE "  VALEXP " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Valmsg <> as4dict2.p__field._Valmsg THEN DO:
          IF NOT l AND (as4dict.p__Field._Valmsg = ? OR as4dict.p__Field._valmsg = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Valmsg,'"',OUTPUT c).
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  VALMSG " + '""' ELSE "  VALMSG " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._Valmsg-SA <> as4dict2.p__field._Valmsg-SA THEN DO:
          IF NOT l AND (as4dict.p__Field._Valmsg-SA = ? OR as4dict.p__Field._Valmsg-SA = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Valmsg-SA,'"',OUTPUT c).      
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  VALMSG-SA " + '""' ELSE "  VALMSG-SA " + c).
          END.
        END.
        IF NOT l OR as4dict.p__Field._View-as <> as4dict2.p__field._View-as THEN DO:
          IF NOT l AND (as4dict.p__Field._View-as = ? OR as4dict.p__Field._View-as = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._View-as,'"',OUTPUT c).          
            ASSIGN j = j + 1
              ddl[j] = (IF length(c) = 2 THEN "  VIEW-AS ?" ELSE "  VIEW-AS " + c).
          END.
        END.
        IF NOT l  THEN DO: 
          IF as4dict.p__Field._Extent = 0 THEN.
          ELSE 
            ASSIGN  j = j + 1
                 ddl[j] = "  EXTENT " + STRING(as4dict.p__Field._Extent).     
        END.
        IF NOT l OR as4dict.p__Field._Decimals <> as4dict2.p__field._Decimals THEN DO: 
          IF as4dict.p__Field._Decimals = 0 THEN.
          ELSE
            ASSIGN j = j + 1
              ddl[j] = "  DECIMALS " + STRING(as4dict.p__Field._Decimals).
        END.
        IF NOT l OR as4dict.p__Field._Order <> as4dict2.p__field._Order THEN 
          ASSIGN j = j + 1
	      ddl[j] = "  ORDER " + STRING(as4dict.p__Field._Order).

        IF NOT l OR as4dict.p__Field._Mandatory <> as4dict2.p__field._Mandatory THEN
	      ASSIGN j = j + 1
                 ddl[j] = (IF as4dict.p__Field._Mandatory = "Y"
		            THEN "  MANDATORY" ELSE "").
        IF NOT l OR as4dict.p__Field._Fld-Misc2[2] <> as4dict2.p__field._Fld-Misc2[2] THEN
          IF as4dict.p__Field._Fld-Misc2[2] = "Y" THEN
            ASSIGN j = j + 1
              ddl[j] = "  NULL-CAPABLE".	    
        IF NOT l OR as4dict.p__Field._Fld-case <> as4dict2.p__field._Fld-case THEN
	      IF as4dict.p__Field._Fld-case = "Y" THEN
            ASSIGN j = j + 1
              ddl[j] = "  CASE-SENSITIVE".
  
        IF NOT l OR as4dict.p__Field._Fld-misc1[2] <> as4dict2.p__Field._Fld-misc1[2] THEN DO:
          IF as4dict.p__Field._Fld-misc1[2] = 1 THEN
            ASSIGN j = j + 1
              ddl[j] = "  INPUT ".
          ELSE IF as4dict.p__Field._Fld-misc1[2] = 2 THEN
            ASSIGN j = j + 1
              ddl[j] = "  INPUT/OUTPUT ".
          ELSE IF as4dict.p__Field._Fld-misc1[2] = 3 THEN
            ASSIGN j = j + 1
              ddl[j] = "  OUTPUT ".
        END.
        IF NOT l OR as4dict.p__Field._Fld-misc2[5] <> as4dict2.p__field._fld-misc2[5] THEN DO:
          IF NOT l AND (as4dict.p__Field._Fld-misc2[5] = ? OR as4dict.p__Field._Fld-misc2[5] = "") THEN.
          ELSE DO:
            RUN dctquot (as4dict.p__Field._Fld-misc2[5],'"',OUTPUT c).
            ASSIGN j = j + 1
              ddl[j] = "  FLD-USAGE-TYPE " + c.
          END.
        END.
        IF  NOT l OR as4dict.p__Field._Fld-misc2[6] <> as4dict2.p__field._fld-misc2[6] THEN DO:
          RUN dctquot (as4dict.p__Field._Fld-misc2[6],'"',OUTPUT c).
          ASSIGN j = j + 1
            ddl[j] = "  DDS-TYPE " + c.
        END.
        IF  NOT l  THEN
          ASSIGN j = j + 1
            ddl[j] = "  FLD-STDTYPE " + STRING(as4dict.p__field._fld-stdtype).
        IF NOT l OR as4dict.p__field._Fld-stlen > as4dict2.p__field._fld-stlen THEN
          ASSIGN j = j + 1
            ddl[j] = "  FLD-STLEN "  + STRING(as4dict.p__field._Fld-stlen).
        IF NOT l THEN DO:
          IF as4dict.p__Field._For-allocated = 0 THEN.
          ELSE
            ASSIGN j = j + 1
              ddl[j] = "  FOREIGN-ALLOCATED "  + STRING(as4dict.p__field._For-Allocated).
        END.
        IF NOT l THEN DO:
          IF as4dict.p__Field._For-Maxsize = 0 THEN.
          ELSE 
            ASSIGN j = j + 1
              ddl[j] = "  FOREIGN-MAXIMUM " + STRING((as4dict.p__field._For-Maxsize - 2)).
        END.      
        IF NOT l OR as4dict.p__field._For-Type <> as4dict2.p__field._For-Type THEN DO:
          RUN dctquot (as4dict.p__Field._For-type,'"',OUTPUT c).
          ASSIGN j = j + 1
            ddl[j] = "  AS400-TYPE "  + c.
        END.
        IF NOT l OR as4dict.p__Field._Fld-misc1[5] <> as4dict2.p__Field._Fld-misc1[5] THEN DO:
          IF as4dict.p__Field._Fld-misc1[5] = 0 THEN.
          ELSE
            ASSIGN j = j + 1
              ddl[j] = "  MAX-GLYPHS "  + STRING(as4dict.p__Field._Fld-misc1[5]).
        END.
        
        /* deal with field triggers */
      /* 1st, find ones to be deleted if field is being updated */

      IF l THEN
      FOR EACH as4dict2.p__Trgfd WHERE as4dict2.p__Trgfd._File-number = as4dict2.p__field._File-number
	                               AND as4dict2.p__Trgfd._Fld-number =  as4dict2.p__field._Fld-number NO-LOCK:
	    FIND as4dict.p__Trgfd WHERE as4dict.p__Trgfd._File-number = as4dict.p__Field._File-number
	                            AND as4dict.p__Trgfd._Fld-number =  as4dict.p__Field._Fld-number
	                            AND as4dict.p__Trgfd._Event = as4dict2.p__Trgfd._Event 
      	                        NO-LOCK NO-ERROR.
	    IF NOT AVAILABLE as4dict.p__Trgfd THEN DO:
	      RUN dctquot (as4dict2.p__Trgfd._Event,'"',OUTPUT c).
	      j = j + 1.
	      ddl[j] = "  FIELD-TRIGGER " + c + " DELETE".
	    END.
	  END.
      /* now record updated or new ones */
      FOR EACH as4dict.p__Trgfd WHERE as4dict.p__Trgfd._File-number = as4dict.p__Field._File-number
	                             AND as4dict.p__Trgfd._Fld-number =   as4dict.p__Field._Fld-number NO-LOCK:
	    FIND as4dict2.p__Trgfd WHERE as4dict2.p__Trgfd._File-number = as4dict2.p__field._File-number
	                             AND as4dict2.p__Trgfd._Fld-number =  as4dict2.p__field._Fld-number 
	                             AND as4dict2.p__Trgfd._Event = as4dict.p__Trgfd._Event 
	                             NO-LOCK NO-ERROR.
	    IF AVAILABLE as4dict2.p__Trgfd AND 
	      as4dict2.p__Trgfd._Override = as4dict.p__Trgfd._Override AND
	      as4dict2.p__Trgfd._Proc-name = as4dict.p__Trgfd._Proc-name AND
	      as4dict2.p__Trgfd._Trig-CRC = as4dict.p__Trgfd._Trig-CRC THEN NEXT.
	  
	    RUN dctquot (as4dict.p__Trgfd._Event,'"',OUTPUT c).
	    j = j + 1. 
	    ddl[j] = "  FIELD-TRIGGER " + c +
	               (IF as4dict.p__Trgfd._Override = "Y" THEN " OVERRIDE " 
						  ELSE " NO-OVERRIDE ").
	    RUN dctquot (as4dict.p__Trgfd._Proc-name,'"',OUTPUT c).
	    ddl[j] = ddl[j] + "PROCEDURE " + c + " CRC """ 
		         + (IF as4dict.p__Trgfd._Trig-CRC = ? 
		         THEN "?" ELSE STRING(as4dict.p__Trgfd._Trig-CRC))
                 + """".
      END. 
      ASSIGN acode = "".
      /* don't write out header or anything unless there's values to output */
      IF j > 1 THEN DO i = 1 TO j:
	    IF i = 1 THEN DO:

          IF TRIM(SUBSTRING(ddl[1],1,2)) BEGINS "DR" THEN DO:
            CREATE act-table.
            ASSIGN a-code = "d"
                   l-name = as4dict.p__File._As4-library
                   f-name = as4dict.p__File._file-name
                   atype = "F"
                   aseq = tseq
                   tseq = tseq + 1
                   syntax = ddl[i]
                   acode = a-code.
          END.
          ELSE IF TRIM(SUBSTRING(ddl[1],1,2)) BEGINS "UP" THEN DO:
            CREATE act-table.
            ASSIGN a-code = "m"
                   l-name = as4dict.p__File._As4-library
                   f-name = as4dict.p__File._file-name
                   atype = "F"
                   aseq = tseq
                   tseq = tseq + 1
                   syntax = ddl[i]
                   ddl[i] = ""
                   acode = a-code.
          END.
          ELSE IF TRIM(SUBSTRING(ddl[1],1,2)) BEGINS "AD" THEN DO:
            CREATE act-table.
            ASSIGN a-code = "a"
                   l-name = as4dict.p__File._As4-library
                   f-name = as4dict.p__File._file-name
                   atype = "F"
                   aseq = tseq
                   tseq = tseq + 1
                   syntax = ddl[i]
                   acode = a-code.
          END.
          ELSE IF TRIM(SUBSTRING(ddl[1],1,2)) BEGINS "RE" THEN DO:
            CREATE act-table.
            ASSIGN a-code = "r"
                   l-name = as4dict.p__File._As4-library
                   f-name = as4dict.p__File._file-name
                   atype = "F"
                   aseq = tseq
                   tseq = tseq + 1
                   syntax = ddl[i]
                   acode = a-code.
          END.
        END.
        ELSE DO:
          CREATE act-table.
          ASSIGN a-code = acode
                 l-name = as4dict.p__File._As4-library
                 f-name = as4dict.p__File._file-name
                 atype = "F"
                 aseq = tseq
                 tseq = tseq + 1
                 syntax = ddl[i]
                 ddl[i] = "".
        END.
      END.
    END.	 /* end FOR EACH field-list */  
  
    /* note that there is no user interface for resolving renamed
    indexes.  this is because we can completely match indexes by their
    component lists, which are invariant once the index is created.  */
    ASSIGN
      pri1 = ""
      pri2 = "".
  
    /* build index component match list */
    FOR EACH as4dict2.p__Index WHERE as4dict2.p__Index._File-number =  as4dict2.p__file._File-number NO-LOCK:
      DISPLAY as4dict2.p__Index._Index-name @ idx WITH FRAME seeking.
      c = STRING(as4dict2.p__Index._Unique,"u/a")
	      + (IF as4dict2.p__Index._Wordidx = 1 THEN "w" ELSE "f").
      FOR EACH as4dict2.p__Idxfd WHERE as4dict2.p__Idxfd._Idx-num = as4dict2.p__Index._Idx-num
                      AND as4dict2.p__Idxfd._File-number = as4dict2.p__Index._File-number NO-LOCK:
	    FIND as4dict2.p__field WHERE as4dict2.p__field._File-number = as4dict2.p__Index._File-number 
	                AND as4dict2.p__field._Fld-number = as4dict2.p__Idxfd._Fld-number NO-LOCK.
	    FIND FIRST field-list WHERE field-list.f2-name = as4dict2.p__field._Field-name NO-ERROR.
        
	    ASSIGN c = c + ","
	               + as4dict2.p__Idxfd._Ascending
	               + as4dict2.p__Idxfd._Abbreviate
	               + STRING(as4dict2.p__field._dtype)
	               + (IF AVAILABLE field-list THEN field-list.f2-name ELSE "*").
      END.

      CREATE index-list.
      ASSIGN index-list.i1-name = as4dict2.p__Index._Index-name
	         index-list.i1-comp = c
	         index-list.i1-i2   = FALSE.
      IF as4dict2.p__file._Prime-Index = as4dict2.p__Index._Idx-num THEN pri2 = as4dict2.p__Index._Index-name.
    END.
  
    FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number NO-LOCK:
      DISPLAY as4dict.p__Index._Index-name @ idx WITH FRAME seeking.
      c = STRING(as4dict.p__Index._Unique,"u/a")
	+ (IF as4dict.p__Index._Wordidx = 1 THEN "w" ELSE "f").
      FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
                                  AND as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number NO-LOCK:
	    FIND as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__Index._File-number
	                           AND as4dict.p__Field._Fld-number = as4dict.p__Idxfd._Fld-number NO-LOCK.
	    ASSIGN C = c + "," + as4dict.p__Idxfd._Ascending + as4dict.p__Idxfd._Abbreviate
	                 + STRING(as4dict.p__Field._dtype) + as4dict.p__Field._Field-name.
      END.

      CREATE index-list.
      ASSIGN index-list.i1-name = as4dict.p__Index._Index-name
	         index-list.i1-comp = c
	         index-list.i1-i2   = TRUE.
      IF as4dict.p__File._Prime-Index = as4dict.p__Index._Idx-num THEN 
          pri1 = as4dict.p__Index._Index-name.
    END.
  
    /* find all unchanged or renamed indexes by comparing idx comp lists */
    FOR EACH index-list WHERE index-list.i1-i2:
      DISPLAY index-list.i2-name @ idx WITH FRAME seeking.
      FIND FIRST index-alt WHERE NOT index-alt.i1-i2
	           AND index-list.i1-comp = index-alt.i1-comp NO-ERROR.
      IF NOT AVAILABLE index-alt THEN NEXT.
     
      ASSIGN index-list.i2-name = index-alt.i1-name.
      DELETE index-alt.
    END.

    /* Now all index-list records where i1-i2 is false represent
       indexes in db2 that will not be renamed, therefore they will
       be deleted.   
    */

    /* check deactivation on unchanged indexes */
    FOR EACH index-list WHERE index-list.i1-name = index-list.i2-name:

      FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
	                       AND as4dict.p__Index._Index-name = index-list.i1-name NO-LOCK.
      FIND as4dict2.p__Index WHERE as4dict2.p__Index._File-number = as4dict2.p__file._File-number
                               AND as4dict2.p__Index._Index-name = index-list.i2-name NO-LOCK.
      
      DISPLAY as4dict.p__Index._Index-name @ idx WITH FRAME wrking.
      IF as4dict.p__Index._Active = "N" AND as4dict2.p__Index._Active = "Y" THEN DO:
          CREATE act-table.
          ASSIGN a-code = "m"
                 atype = "I"
                 l-name = as4dict2.p__Index._As4-library
                 f-name = as4dict2.p__Index._Index-name
                 aseq = tseq
                 pfname = as4dict2.p__file._File-name
                 tseq = tseq + 1
                 syntax = 'UPDATE INACTIVE INDEX "' + as4dict.p__Index._Index-name +
	                      '" OF "' + as4dict.p__File._File-name + '"'.
      END.	
      DELETE index-list.
    END.
  
    /* handle renamed indexes */
    ans = FALSE.
    FOR EACH index-list WHERE index-list.i2-name <> ?:
      FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
	                       AND as4dict.p__Index._Index-name = index-list.i1-name NO-LOCK.
      FIND as4dict2.p__Index WHERE as4dict2.p__Index._File-number = as4dict2.p__file._File-number
	                         AND as4dict2.p__Index._Index-name = index-list.i2-name NO-LOCK.

      ans = TRUE.
      DISPLAY index-list.i1-name @ idx WITH FRAME wrking.

      RUN Check_Index_Conflict.
      CREATE act-table.
      ASSIGN a-code = "r"
             l-name = as4dict.p__Index._As4-library
             f-name = as4dict.p__Index._Index-name
             atype = "I"
             aseq = tseq
             pfname = as4dict.p__file._File-name
             tseq = tseq + 1
             syntax = 'RENAME INDEX "' + index-list.i2-name + '" TO "' +
                       index-list.i1-name + '" ON "' + as4dict.p__File._File-name + '"'.

      IF as4dict.p__Index._Active = "N" AND as4dict2.p__Index._Active = "Y" THEN DO:
        CREATE act-table.
        ASSIGN a-code = "m"
               atype = "I"
               l-name = as4dict.p__File._As4-library
               f-name = as4dict.p__Index._Index-name
               aseq = tseq
               pfname = as4dict.p__file._File-name
               tseq = tseq + 1
               syntax = 'UPDATE INACTIVE INDEX "' + as4dict.p__Index._Index-name +
	                    '" OF "' + as4dict.p__File._File-name + '"'.
      END.
      DELETE index-list.
    END.
  
    /* check if unique indexes to be created as unique*/
    FOR EACH index-list WHERE index-list.i1-i2,
      EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
                              AND as4dict.p__Index._Index-name = index-list.i1-name
                              AND as4dict.p__Index._Unique = "Y"
                              AND as4dict.p__Index._Active = "Y" NO-LOCK:
      iact = TRUE.

      DISPLAY as4dict.p__Index._Index-name @ idx WITH FRAME seeking.
      RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT iact,?,?,new_lang[2]).
      LEAVE. /* we only need to ask once */
    END.

    /* handle new indexes */
    FOR EACH index-list WHERE index-list.i1-i2,
        EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
                                AND as4dict.p__Index._Index-name = index-list.i1-name NO-LOCK:
      
      ASSIGN ddl = ""
               j = 1.

      DISPLAY as4dict.p__Index._Index-name @ idx WITH FRAME wrking.
       
      /*RUN Check_Index_Conflict. */
      CREATE act-table.
      ASSIGN a-code = "a"
             l-name = as4dict.p__Index._As4-library
             f-name = as4dict.p__Index._Index-name
             atype = "I"
             aseq = tseq
             pfname = as4dict.p__file._File-name
             tseq = tseq + 1
             syntax = "ADD " + 'INDEX "' + as4dict.p__Index._Index-Name + '" ON "' +
                        as4dict.p__File._File-name + '"'.
        
      IF as4dict.p__file._Prime-Index = as4dict.p__Index._Idx-num AND
        NOT CAN-FIND(FIRST act-table WHERE a-code = "p"
                                       AND atype = "I"
                                       AND l-name = as4dict.p__File._As4-library
                                       AND f-name = as4dict.p__Index._Index-name)
        THEN
          ASSIGN ddl[j] = "  PRIMARY" 
                        j = j + 1.
      IF as4dict.p__Index._Unique = "Y"  AND iact = TRUE THEN 
        ASSIGN ddl[j] = "  UNIQUE" 
                      j = j + 1.
      IF as4dict.p__Index._Wordidx = 1 THEN 
        ASSIGN ddl[j] = "  WORD" 
                    j = j + 1.
      IF as4dict.p__Index._For-Type <> ? AND  as4dict.p__Index._For-Type <> "" THEN
        ASSIGN ddl[j] = "  FORMAT-NAME " + as4dict.p__Index._For-Type
                    j = j + 1.
      IF as4dict.p__Index._As4-File <> ? AND as4dict.p__Index._As4-File <> "" THEN
        ASSIGN ddl[j] = "  AS400-FILE " + as4dict.p__Index._As4-File 
                    j = j + 1.        
      IF as4dict.p__Index._I-misc2[4] <> ? AND as4dict.p__index._I-misc2[4] <> "" THEN 
        ASSIGN ddl[j] = "  AS400-FLAGS " + as4dict.p__Index._I-misc2[4]
                    j = j + 1.

      FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
                                  AND as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number NO-LOCK
                               BREAK BY as4dict.p__Idxfd._Index-seq:

        FIND as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__Index._File-number
                                AND as4dict.p__Field._Fld-number = as4dict.p__Idxfd._Fld-number NO-LOCK.	                         
        ASSIGN ddl[j] = '  INDEX-FIELD "' + as4dict.p__Field._Field-Name + '" ' +
	               (IF as4dict.p__Idxfd._Ascending = "Y" THEN "ASCENDING" ELSE "DESCENDING") +
	               (IF as4dict.p__Idxfd._Abbreviate = "Y" THEN " ABBREVIATED" ELSE "") +
	               (IF as4dict.p__Idxfd._Unsorted = "Y"  THEN " UNSORTED"    ELSE "")
               j = j + 1.        
      END.
      IF j > 1 THEN DO i = 1 TO j:

        CREATE act-table.
        ASSIGN a-code = "a"
               l-name = as4dict.p__Index._As4-library
               f-name = as4dict.p__index._index-name
               atype = "I"
               aseq = tseq
               pfname = as4dict.p__file._File-name
               tseq = tseq + 1
               syntax = ddl[i].
      END.
    END.
    
    ans = FALSE.
    FOR EACH index-list WHERE NOT index-list.i1-i2:
      ans = TRUE.
      IF index-list.i1-name <> ? THEN
        DISPLAY index-list.i1-name @ idx WITH FRAME wrking.

      FIND FIRST act-table WHERE a-code = "r"
                             AND atype = "t"
                             AND f-name = as4dict2.p__File._File-name NO-ERROR.

      IF AVAILABLE act-table THEN 
        ASSIGN newtblname = act-table.pfname.
      ELSE
        ASSIGN newtblname = ?.

      IF index-list.i1-name <> "default" AND NOT index-list.i1-name BEGINS "temp-we48z576-" THEN DO:     
        FIND as4dict2.p__index WHERE as4dict2.p__Index._File-number = as4dict2.p__File._File-number
                                AND as4dict2.p__Index._Index-name = index-list.i1-name NO-LOCK.

        
        CREATE act-table.
        ASSIGN a-code = "d"
               atype  = "I"
               l-name = as4dict2.p__Index._As4-library
               f-name = as4dict2.p__Index._Index-name
               aseq   = tseq
               pfname = as4dict2.p__file._File-name
               tseq = tseq + 1
              syntax = 'DROP INDEX "' + index-list.i1-name + '" ON "' +
                            (IF newtblname <> ? THEN newtblname ELSE as4dict2.p__File._File-name) + '"'.
      END.
      ELSE IF index-list.i1-name BEGINS "temp-we48z576-" THEN DO:
        CREATE act-table.
        ASSIGN a-code = "d"
               atype  = "I"
               l-name = as4dict2.p__file._As4-library
               f-name = index-list.i1-name
               aseq   = tseq
               pfname = as4dict2.p__file._File-name
               tseq = tseq + 1
               syntax = 'DROP INDEX "' + index-list.i1-name + '" ON "' +
                            (IF newtblname <> ? THEN newtblname ELSE as4dict2.p__File._File-name) + '"'.
      END.
      DELETE index-list.
    END.                        

    RELEASE as4dict.p__Index.  
        /* set primary index */

    IF as4dict.p__File._Prime-Index <> ? THEN DO:
     
      FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
                              AND as4dict.p__Index._Idx-num = as4dict.p__File._Prime-Index
                              NO-LOCK NO-ERROR.

      IF AVAILABLE as4dict.p__Index AND pri1 <> pri2  THEN DO:
        CREATE act-table.
        ASSIGN a-code = "p"
                atype = "I"
               l-name = as4dict.p__File._As4-library
               f-name = as4dict.p__Index._Index-name
                 aseq = tseq
                 tseq = tseq + 1
               syntax = 'UPDATE PRIMARY INDEX "' + as4dict.p__Index._Index-name + '" ON "' +
                         as4dict.p__File._File-name + '"'.
      END.
    END.
    /* handle deleted fields.  
       Do this after index deletes since fields cannot be dropped when they 
       belong to a primary index.  This is not done for fields that were 
       dropped but replaced with another field (different data type or extent) 
       but with the same name.  This still has to be done above so we can add 
       the new field without conflict.
    */
    FIND FIRST missing NO-ERROR.
    ans = FALSE.
    FOR EACH missing:
      DISPLAY missing.name @ fld WITH FRAME wrking.
      IF ans = FALSE THEN DO: /* ask only once per file */
        FIND FIRST sc-table WHERE lib-name = as4dict2.p__File._As4-library
                              AND fil-name = as4dict2.p__File._AS4-File
                              AND act-code = "C"
                              NO-ERROR.
        IF NOT AVAILABLE sc-table THEN DO:
	      ASSIGN cfile = FALSE.
          RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT cfile,?,?,new_lang[3]).
          IF cfile THEN DO:
            CREATE sc-table.
            ASSIGN act-code = "c"
                   lib-name = as4dict2.p__File._As4-library
                   fil-name = as4dict2.p__File._As4-File.
            IF as4dict2.p__File._For-info = "PROCEDURE" THEN
              ASSIGN ftype = "P".
            ELSE
              ASSIGN ftype    = "F".
          END.
          ASSIGN ans = TRUE.
        END.
      END.
      CREATE act-table.
      ASSIGN a-code = "d"
             atype = "F"
             l-name = as4dict2.p__File._As4-library
             f-name = as4dict2.p__File._file-name
             aseq = tseq
             tseq = tseq + 1
             syntax = 'DROP FIELD "' +  missing.NAME + '" OF "' + 
                      as4dict.p__File._File-name + '"'.
      DELETE missing.
    END.
  
  
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      HIDE MESSAGE.
    END.
  END.  /* end FOR EACH potentially altered file */
  
  DISPLAY "" @ fil "" @ fld "" @ idx WITH FRAME seeking.
  DISPLAY "" @ fil "" @ fld "" @ idx WITH FRAME wrking.

  /* build missing sequence list for rename/delete determination */
  FOR EACH as4dict2.p__Seq NO-LOCK:
    FIND FIRST as4dict.p__Seq
      WHERE as4dict.p__Seq._Seq-name = as4dict2.p__Seq._Seq-name NO-LOCK NO-ERROR.
    DISPLAY as4dict2.p__Seq._Seq-name @ seq WITH FRAME seeking.
    IF AVAILABLE as4dict.p__Seq THEN NEXT.
    CREATE missing.
    missing.name = as4dict2.p__Seq._Seq-name.
  END.
  
  /* build list of new or renamed sequences */
  FOR EACH as4dict.p__Seq NO-LOCK:
    FIND FIRST as4dict2.p__Seq 
      WHERE as4dict2.p__Seq._Seq-name = as4dict.p__Seq._Seq-name NO-LOCK NO-ERROR.
    DISPLAY as4dict.p__Seq._Seq-name @ seq WITH FRAME seeking.
    CREATE seq-list.
    ASSIGN seq-list.s1-name = as4dict.p__Seq._Seq-name.
    IF AVAILABLE as4dict2.p__Seq THEN
      seq-list.s2-name = as4dict2.p__Seq._Seq-name. /*fernando: 20020205-009 */
  END.
  
  /* look for matches for renamed sequences with user input.  A prompt 
     is given for each seq that's not in as4dict but only when
     there is also a seq in as4dict that's not in temp table.  The 2nd list
     is the potential values to rename to.
  */
  run adecomm/_setcurs.p ("").

  FOR EACH missing:
    DISPLAY missing.name @ seq WITH FRAME seeking.
    RUN "as4dict/dump/_dmpisub.p"
      (INPUT "s",INPUT-OUTPUT missing.name,OUTPUT ans).
    IF missing.name = ? THEN DELETE missing.
    IF ans = ? THEN DO:
      HIDE FRAME wrking NO-PAUSE.
      HIDE FRAME seeking NO-PAUSE.
      user_path = "".
      RETURN.
    END.
  END.
  run adecomm/_setcurs.p ("WAIT").

  /* handle deleted sequences */
  ans = FALSE.
  FOR EACH missing:
    ans = TRUE.
    FIND as4dict2.p__Seq WHERE as4dict2.p__seq._seq-name = missing.NAME NO-LOCK NO-ERROR.
    CREATE act-table.
    ASSIGN a-code = "d"
           atype = "S"
           l-name = "sequence"
           f-name = as4dict2.p__seq._seq-name
           pfname = as4dict2.p__seq._seq-name
           aseq = tseq
           tseq = tseq + 1
           syntax = 'DROP SEQUENCE "' + missing.NAME + '"'.
    DISPLAY missing.name @ seq WITH FRAME seeking.
    DISPLAY missing.name @ seq WITH FRAME wrking.
    DELETE missing.
  END.

  /* handle renamed sequences */
  ans = FALSE.
  FOR EACH seq-list WHERE seq-list.s1-name <> seq-list.s2-name
                      AND seq-list.s2-name <> ?:
    /*fernando: 20020205-009 needs to find sequences in the database*/
    FIND FIRST as4dict.p__seq WHERE as4dict.p__seq._seq-name = seq-list.s1-name NO-LOCK NO-ERROR.
    CREATE act-table.
    ASSIGN a-code = "r"
           atype = "S"
           l-name = "sequence"
           f-name = as4dict.p__seq._seq-name
           pfname = as4dict.p__seq._seq-name
           aseq = tseq
           tseq = tseq + 1
           syntax = 'RENAME SEQUENCE "' + seq-list.s2-name + '" TO "' +
                     seq-list.s1-name + '"'.
    DISPLAY seq-list.s1-name @ seq WITH FRAME seeking.
    DISPLAY seq-list.s1-name @ seq WITH FRAME wrking.
  END.

  
  /* handle new or potentially altered sequences.  
     We can't use dumpdefs here like we do with files because it wasn't 
     made to handle individual sequences - it would dump them all.
     Some day!
  */

  FOR EACH seq-list:
    DISPLAY seq-list.s1-name @ seq WITH FRAME seeking.
    
    FIND as4dict.p__Seq WHERE as4dict.p__Seq._Seq-name = seq-list.s1-name NO-LOCK.
    FIND as4dict2.p__Seq WHERE as4dict2.p__Seq._Seq-name = seq-list.s2-name NO-LOCK NO-ERROR.
    
    DISPLAY seq-list.s1-name @ seq WITH FRAME wrking.
  
    /* If l is true we're updateing otherwise we're adding */
    l = AVAILABLE as4dict2.p__Seq.
  
    /* write out appropriate seq definition changes */
    ASSIGN
      j      = 1
      ddl    = ""
      ddl[1] = (IF l THEN "UPDATE" ELSE "ADD")
	       + ' SEQUENCE "' + as4dict.p__Seq._Seq-name + '"'.
      IF NOT l OR as4dict.p__Seq._Seq-init <> as4dict2.p__Seq._Seq-init THEN 
	ASSIGN
	  j = j + 1
	  ddl[j] = "  INITIAL " + (IF as4dict.p__Seq._Seq-init = ? THEN "?"
		   ELSE STRING(as4dict.p__Seq._Seq-init)).
      IF NOT l OR 
      	 as4dict.p__Seq._Seq-incr <> as4dict2.p__Seq._Seq-incr THEN 
	ASSIGN
	  j = j + 1
	  ddl[j] = "  INCREMENT " + (IF as4dict.p__Seq._Seq-incr = ? THEN "?" 
		   ELSE STRING(as4dict.p__Seq._Seq-incr)).
      IF NOT l OR 
      	 as4dict.p__Seq._Cycle-OK <> as4dict2.p__Seq._Cycle-OK THEN 
	ASSIGN
	  j = j + 1
	  ddl[j] = "  CYCLE-ON-LIMIT " + 
		   (IF as4dict.p__Seq._Cycle-OK = "Y" THEN "yes" ELSE "no").
      IF NOT l OR as4dict.p__Seq._Seq-min <> as4dict2.p__Seq._Seq-min THEN 
	ASSIGN
	  j = j + 1
	  ddl[j] = "  MIN-VAL " + (IF as4dict.p__Seq._Seq-min = ? THEN "?" 
		   ELSE STRING(as4dict.p__Seq._Seq-min)).
      IF NOT l OR as4dict.p__Seq._Seq-max <> as4dict2.p__Seq._Seq-max THEN 
	ASSIGN
	  j = j + 1
	  ddl[j] = "  MAX-VAL " + (IF as4dict.p__Seq._Seq-max = ? THEN "?" 
		   ELSE STRING(as4dict.p__Seq._Seq-max)).
  
      /* don't write out ddl[1] if j = 1 (i.e., we only have seq header) */
    IF j > 1 THEN DO i = 1 TO j + 1:
	  CREATE act-table.
      ASSIGN a-code = (IF l THEN "m" ELSE "a")
             l-name = "sequence"
             f-name = as4dict.p__seq._seq-name
             pfname = as4dict.p__seq._seq-name
             atype = "s"
             aseq = tseq
             tseq = tseq + 1
             syntax = ddl[i].	    
	END.
  END.  /* end FOR EACH new or potentially altered sequence */

  DISPLAY "" @ seq WITH FRAME seeking.
  DISPLAY "" @ seq WITH FRAME wrking.

  RUN create-delta.
  stopped = false.
END. /* on stop */
  
IF stopped THEN
   MESSAGE "Dump terminated."
      	   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
ELSE
   MESSAGE "Dump completed."
      	   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

HIDE FRAME wrking NO-PAUSE.
HIDE FRAME seeking NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
run adecomm/_setcurs.p ("").
RETURN.


PROCEDURE create-delta:
  DEFINE VARIABLE otpt AS LOGICAL INITIAL FALSE NO-UNDO.

  /* Start as4delta.df file  */
  PUT STREAM ddl UNFORMATTED "ENHANCED START" SKIP.
  PUT STREAM ddl UNFORMATTED "ENHANCED GETPID" SKIP.
  
  FOR EACH sc-table WHERE act-code = "S" BREAK BY lib-name:
    IF FIRST-OF(lib-name) THEN 
      PUT STREAM ddl UNFORMATTED "ENHANCED SRTSAVE " + '"' + sc-table.lib-name + '"' SKIP.
    FIND as4dict2.p__File WHERE as4dict2.p__File._AS4-File = sc-table.fil-name
                            AND as4dict2.p__File._AS4-Library = sc-table.lib-name
                            NO-LOCK.
    FOR EACH as4dict2.p__Index WHERE as4dict2.p__Index._File-number = as4dict2.p__File._File-number NO-LOCK:
      /* Don't give the physical file key to be saved */
      IF as4dict2.p__File._Fil-misc1[7] = as4dict2.p__Index._Idx-num THEN NEXT.
      PUT STREAM ddl UNFORMATTED 'SAVE OBJECT "' + as4dict2.p__Index._AS4-File + '" "' + 
             as4dict2.p__Index._As4-Library + '"' + (IF as4dict2.p__Index._Wordidx = 0 THEN ' "*FILE"' 
                                                     ELSE ' "*USRIDX"') SKIP.
    END.
    PUT STREAM ddl UNFORMATTED 'SAVE OBJECT "' + sc-table.fil-name + '" "' + sc-table.lib-name + '"'.
    IF ftype = "F" OR ftype = "L" THEN PUT STREAM ddl UNFORMATTED ' "*FILE"'.
    ELSE IF ftype = "P" THEN PUT STREAM ddl UNFORMATTED ' "*PGM"'.
    PUT STREAM ddl UNFORMATTED "" SKIP.
    IF LAST-OF(lib-name) THEN 
      PUT STREAM ddl UNFORMATTED "ENHANCED ENDSAVE " + '"' + sc-table.lib-name + '"' SKIP.
  END.
  PUT STREAM ddl UNFORMATTED "" SKIP(1).

  FOR EACH sc-table WHERE act-code = "c":
   PUT STREAM ddl UNFORMATTED 'COPY OBJECT "' + sc-table.fil-name + '" "' + sc-table.lib-name + '"'.
   IF ftype = "F" OR ftype = "L" THEN PUT STREAM ddl UNFORMATTED ' "*FILE"'.
   ELSE IF ftype = "P" THEN PUT STREAM ddl UNFORMATTED ' "*PGM"'.
   PUT STREAM ddl UNFORMATTED "" SKIP.
  END.
  PUT STREAM ddl UNFORMATTED "" SKIP(1).
 
  PUT STREAM ddl UNFORMATTED "DBA START" SKIP(1).
  
  FOR EACH act-table WHERE a-code = "r" 
                       AND atype = "T":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "r" 
                       AND atype = "F":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "r" 
                       AND atype = "I":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "r" 
                       AND atype = "s":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.
  
  IF otpt THEN DO:
    PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED "DBA COMMIT" SKIP(1).
    ASSIGN otpt = FALSE.
  END.

  FOR EACH act-table WHERE a-code = "d"
                       AND atype = "i":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "d"
                       AND atype = "F":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "d"
                       AND atype = "t"
                       BY pfname:
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "d" 
                       AND atype = "s":
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  IF otpt THEN DO:
    PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED "DBA COMMIT" SKIP(1).
    ASSIGN otpt = FALSE.
  END.

  FOR EACH act-table WHERE a-code = "a" 
                         AND atype = "F":
    IF syntax BEGINS "ADD" THEN
      PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "a" 
                       AND atype = "I":
                         
    IF syntax BEGINS "ADD" THEN
      PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "p":
     PUT STREAM ddl UNFORMATTED syntax SKIP.    
     DELETE act-table.
     IF NOT otpt THEN
       ASSIGN otpt = TRUE.
  END.

  FOR EACH act-table WHERE a-code = "a" 
                       AND atype = "s":
    IF syntax BEGINS "ADD" THEN
      PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED syntax SKIP.    
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  IF otpt THEN DO:
    PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED "DBA COMMIT" SKIP(1).
    ASSIGN otpt = FALSE.
  END.

  FOR EACH act-table WHERE a-code = "m":
    IF syntax BEGINS "U" THEN
      PUT STREAM ddl UNFORMATTED "" SKIP(1).
    IF syntax <> "" THEN
      PUT STREAM ddl UNFORMATTED syntax SKIP.      
    DELETE act-table.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.

  IF otpt THEN DO:
    PUT STREAM ddl UNFORMATTED "" SKIP(1).
    PUT STREAM ddl UNFORMATTED "DBA COMMIT" SKIP(1).
    ASSIGN otpt = FALSE.
  END.

   /* dump newly created files */
  FOR EACH table-list WHERE table-list.t2-name = ?:
    FIND as4dict.p__File WHERE as4dict.p__File._File-name = table-list.t1-name NO-LOCK.
    DISPLAY as4dict.p__File._File-name @ fil WITH FRAME seeking.
    RUN "as4dict/dump/_dmpdefs.p" ("t", as4dict.p__File._File-number).
    HIDE FRAME working.
    DISPLAY as4dict.p__File._File-name @ fil WITH FRAME wrking.
    DELETE table-list.
    IF NOT otpt THEN
      ASSIGN otpt = TRUE.
  END.
  
  IF otpt THEN DO:
    PUT STREAM ddl UNFORMATTED " " SKIP.
    PUT STREAM ddl UNFORMATTED "DBA COMMIT" SKIP.
  END.

  PUT STREAM ddl UNFORMATTED "DBA END" SKIP.
  PUT STREAM ddl UNFORMATTED "ENHANCED COMMIT" SKIP.
  PUT STREAM ddl UNFORMATTED "ENHANCED END" SKIP(1).

  /* Create trailer with new keyword as4delta */
  PUT STREAM ddl UNFORMATTED "." SKIP.  
  i = SEEK(ddl).  
  PUT STREAM ddl UNFORMATTED "PSC" SKIP.  
  PUT STREAM ddl UNFORMATTED "AS4DELTA" SKIP.
  PUT STREAM ddl UNFORMATTED "cpstream=" 
      ( if user_env[5] = "<internal defaults apply>" then "UNDEFINED"
       else user_env[5] )  SKIP.   
  PUT STREAM ddl UNFORMATTED "." SKIP
      STRING(i,"9999999999") SKIP. /* adds trailer with code-page-entrie to end of file */

END PROCEDURE.







