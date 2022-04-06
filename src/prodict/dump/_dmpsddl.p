/*********************************************************************
* Copyright (C) 2006-2011,2013,2016 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/* _dmpsddl.p - dump data definitions */

/*
in:  user_env[1]   = containing comma-separated list of filenames in
                     current database, *only* if user_filename = "SOME".
                     But it may be in user_longchar, if list was too big.
     user_env[2]   = Name of file to dump to.
     user_env[5]   = "<internal defaults apply>" or "<target-code-page>"
                     (only for "d"!)   /* hutegger 94/02 */
     user_env[6]   = "no-alert-boxes" or something else
     user_env[9]   = "d" - dump defs 
      	       	     	 - if user selected a specific table: translates into
      	       	     	   "t" for dumpdefs.
      	       	     	 - if user selected ALL: translates into "d","s"
      	       	     	   and "t" for dumpdefs where "d" will output both
      	       	     	   auto connect and collation info.
                     "a" - auto connect 
      	       	     "c" - collation info
                     "s" - sequences.
     user_env[25]  = "AUTO" or ""
     user_env[26]  = "y" or "n" yes/no to dump field Field._Field-rpos (POSITION)
     user_filename = "ALL"        all files of a schema
                     "SOME"       some of the files of the first schema
                     "SOME MORE"  some of the files of a following schema
                     "ONE"        one file of the first schema
                     "ONE MORE"   one file of a following schema
out: user_filename = if user_env[25] = "AUTO", then comma-separated list
                     which can have encpolicy and/or bufpool if encryption
                     policies and/or alternate buffer pool settings were
                     dumped.

When dumping automatically all definitions of all schemas, the .df-file 
should contain only one trailer - at the very   end. Therefor the batch-
program passes "AUTO" to suppress the trailer for the 1. to 
n-1. db.
"" symbolizes the default-behaviour (:= generate trailer).

History:
    hutegger    02/24/94    code-page - support and trailer-info added
    hutegger    06/09/94    batch-automatism
    hutegger    01/24/95    single-files in multiple schemas
    Mario B     03/15/99    Added user_env[26] for dump _Field._Field-rpos
    D. McMann   09/12/02    Changed where check for owner is done 20020912-009
    D. McMann   09/30/02    Added check for SQL92 tables.
    D. McMann   10/03/02    Added USE-INDEX for On-line schema add
    fernando    03/14/06    Handle case with too many tables selected - bug 20050930-006.        
    fernando    09/27/06    Added check for sql-92 tables with unsupported ABL prop - 20060324-001
    fernando    06/19/07    Support for large files
    fernando    07/18/08    Support for encryption
    fernando    04/08/09    Support for alternate buffer pool    
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/fhidden.i}
{prodict/sec/sec-pol.i}

DEFINE VARIABLE Dbs         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE file_len    AS INTEGER      NO-UNDO.
DEFINE VARIABLE Seqs        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL      NO-UNDO init true.
DEFINE VARIABLE hBuffer2 AS HANDLE NO-UNDO.

DEFINE VARIABLE numCount  AS INTEGER      NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER      NO-UNDO.
DEFINE VARIABLE ilast     AS INTEGER      NO-UNDO.
DEFINE VARIABLE has_lchar AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c         AS CHARACTER.
DEFINE VARIABLE dumpPol   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE dumpAltBuf AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE myEPolicy  AS prodict.sec._sec-pol-util    NO-UNDO.
DEFINE VARIABLE myObjAttrs AS prodict.pro._obj-attrib-util NO-UNDO.
DEFINE VARIABLE brk        AS LOGICAL INITIAL NO NO-UNDO.
DEFINE NEW SHARED STREAM ddl.
DEFINE NEW SHARED VARIABLE df-con  AS CHARACTER EXTENT 7    NO-UNDO.
DEFINE NEW SHARED VARIABLE dfseq  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE NEW SHARED TEMP-TABLE df-info NO-UNDO
    FIELD df-seq  AS INTEGER
    FIELD df-line AS CHARACTER
    FIELD df-tbl  AS CHARACTER
    FIELD df-fld  AS CHARACTER
    INDEX rt-line IS PRIMARY df-seq.
    
/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

FORM
  Dbs 	       	    LABEL "Database"  COLON 11 FORMAT "x(32)" SKIP
  DICTDB._File._File-name  LABEL "Table"     COLON 11 FORMAT "x(32)" SKIP
  Seqs 	       	    LABEL "Sequence"  COLON 11 FORMAT "x(32)" SKIP
  HEADER 
    "Dumping Definitions.  Press " +
     KBLABEL("STOP") + " to terminate the dump process." format "x(70)"
  WITH FRAME working 
  ROW 4 CENTERED SIDE-LABELS ATTR-SPACE USE-TEXT &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D TITLE "Dump Data Definitions" &ENDIF.

if  user_env[6] NE "dump-silent" THEN 
  COLOR DISPLAY MESSAGES
    DICTDB._File._File-name Dbs Seqs
    WITH FRAME working.

if TERMINAL <> "" and user_env[6] NE "dump-silent"
 then DISPLAY
    ""   @ Dbs
    ""	 @ DICTDB._File._File-name
    ""   @ Seqs
    WITH FRAME working.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

if TERMINAL <> "" 
 then run adecomm/_setcurs.p ("WAIT").

if  user_env[5] = " "
 OR user_env[5] = ? 
 then assign user_env[5] = "<internal defaults apply>".
 
if user_env[5] = "<internal defaults apply>"
 then OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
 else OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP
             CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].

assign SESSION:IMMEDIATE-DISPLAY = yes.

DO ON STOP UNDO, LEAVE:
  if user_env[9] = "a" then DO:
    if TERMINAL <> "" and user_env[6] NE "dump-silent"  then 
      DISPLAY "(Auto-Connect)" @ Dbs WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("a",drec_db,user_env[26]).
    end.
  else if user_env[9] = "c" then DO:
    if TERMINAL <> "" and user_env[6] NE "dump-silent" then 
      DISPLAY user_dbname + " (Collate)" @ Dbs WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("c",drec_db, user_env[26]).
    end.
  else if user_env[9] = "s"  and user_env[6] NE "dump-silent" then DO:
    if TERMINAL <> "" then 
      DISPLAY user_dbname @ Dbs 
      	"ALL" @ Seqs 
      	WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("s",drec_db,user_env[26]).
    end.
  else do:
    /* check if caller stored list in user_longchar, which happens when list is too big
       to fit into user_env[1].
    */
    IF user_longchar <> "" AND user_longchar <> ? THEN DO:
       /* this means that the list of table was too big to fit into user_env[1].
          We will keep a count of the number of entries so that we loop through them
          in batches .
       */
       ASSIGN numCount = NUM-ENTRIES(user_longchar)
              has_lchar = TRUE.
    END.
    ELSE 
       ASSIGN numCount = 1. /* just need 1 iteration in this case */

    ASSIGN ilast = 0
           c = user_env[1].

       
   FIND _Db WHERE RECID(_Db) = drec_db NO-LOCK.
  
   IF _Db._Db-type = "PROGRESS" THEN DO ON ERROR UNDO, LEAVE:

        CREATE BUFFER hBuffer2 FOR TABLE "DICTDB._database-feature" NO-ERROR.
        IF VALID-HANDLE(hBuffer2) THEN DO:
          hBuffer2:FIND-FIRST("WHERE _database-feature._dbfeature_name = ~'encryption~'",
                             NO-LOCK) NO-ERROR.
	  IF hBuffer2:AVAILABLE AND hBuffer2::_dbfeature_enabled EQ "1" THEN 
                myEPolicy = NEW prodict.sec._sec-pol-util(). 
          ELSE 
                hBuffer2:BUFFER-RELEASE().
          
          DELETE OBJECT hBuffer2 NO-ERROR.
        END.

        CATCH ae AS PROGRESS.Lang.AppError:
           /* if encryption is not enabled, then we silently ignore this */
            IF ae:GetMessageNum(1) NE 14889 THEN 
            DO:
               cMsg =  "The dump file will not contain any encryption definitions for the objects." + "~n" + 
                         ae:GetMessage(1).
                          
               if user_env[6] eq "dump-silent" THEN 
                   undo, throw new Progress.Lang.AppError(cmsg). 
               else IF user_env[6] = "no-alert-boxes" THEN
                   MESSAGE cmsg.
               ELSE
                   MESSAGE cmsg  
                        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
            END.

            DELETE OBJECT ae.
        END CATCH.
    END.
    
    IF _Db._Db-type = "PROGRESS" THEN DO ON ERROR UNDO, LEAVE:
        myObjAttrs = NEW prodict.pro._obj-attrib-util().

        CATCH ae AS PROGRESS.Lang.AppError:
           /* if db doesn't support alternate buffer pools, then we silently ignore this */
            IF ae:GetMessageNum(1) NE 4634 THEN DO:
                
                cMsg =  "The dump file will not contain any buffer pool definitions for the objects." + "~n" + 
                         ae:GetMessage(1).
                if user_env[6] eq "dump-silent" THEN 
                     undo, throw new Progress.Lang.AppError(cmsg).
                ELSE IF user_env[6] = "no-alert-boxes" THEN
                     MESSAGE  cMSG.
                ELSE
                     MESSAGE  cMsg 
                        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
            END.
            DELETE OBJECT ae.
        END CATCH.
    END.

    DO WHILE (ilast < numCount):

      IF has_lchar AND user_filename begins "SOME" THEN DO:
         /* we will go through this as many times as needed to process
            all the selected entries. Can't put longchar in WHERE clause,
            so need to break it down in chunks  .
         */
         c = "".

         DO ix = iLast + 1 TO numCount:
            brk = NO.     
            IF c = "" THEN
                c = entry(ix,user_longchar) NO-ERROR.
            ELSE
            DO:
               IF LENGTH(c + "," + entry(ix,user_longchar)) > 2400 THEN 
                  ASSIGN brk = YES.
               ELSE    
                  ASSIGN c = c + "," + 
                                 entry(ix,user_longchar) no-error.
            END.                    
            IF ERROR-STATUS:ERROR OR brk THEN DO:
                ASSIGN ix = ix - 1.
                LEAVE. /* process what we'got so far */
            END.
           
         end.
         
         /* remember the last one we processed, so we continue from where we left off */
         ASSIGN ilast = ix.

      END.
      ELSE
         /* in this case, we don't need another iteration */
         ASSIGN ilast = numCount. 

      FOR EACH DICTDB._File
      WHERE DICTDB._File._Db-recid = drec_db
        AND ( if user_filename = "ALL"
              then (IF NOT fHidden THEN NOT DICTDB._File._Hidden
	      	    	    	   ELSE DICTDB._File._File-Number > 0 )
             else if user_filename begins "SOME" 
                  THEN CAN-DO(c, DICTDB._File._File-name)
                  ELSE RECID(DICTDB._File) = drec_file
           )
        USE-INDEX _File-name
      BREAK BY DICTDB._File._File-name:

      if   FIRST(DICTDB._File._File-name) 
       then do:  /* first _file of this _db */

        if  user_filename = "ALL"
         or user_filename = "SOME MORE"
         or user_filename = "ONE MORE"
         then do:  /* we need db-token */
          if TERMINAL <> "" and user_env[6] NE "dump-silent" then
             DISPLAY "ALL" @ Dbs
              WITH FRAME working.
          RUN "prodict/dump/_dmpdefs.p" ("d",drec_db,user_env[26]).
          end.     /* we need db-token */
  
        if user_filename = "ALL"
         then do:  /* "all" to dump */
          if TERMINAL <> "" and user_env[6] NE "dump-silent" then
              DISPLAY
              user_dbname @ Dbs
      	      "ALL"       @ Seqs
      	      WITH FRAME working.
          RUN "prodict/dump/_dmpdefs.p" ("s",drec_db,user_env[26]).
          end.     /* "all" to dump */
        
        end.     /* first _file of this _db */
        
      else
        if TERMINAL <> "" and user_env[6] NE "dump-silent" then 
          DISPLAY user_dbname @ Dbs
      	    WITH FRAME working.

     /* This check has to be done after the FIRST-OF statment if SQL92
        tables are also in the database 20020912-009*/         
      IF INTEGER(DBVERSION("DICTDB")) > 8         
        AND (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN")
          THEN NEXT.

      /* Do not dump SQL92 tables */
      IF DICTDB._File._Db-lang > 1 THEN NEXT.

      /* 20060324-001
         Now due to the unified schema for sql92, we will get through
         for PUB tables but we can't dump tables with constraints 
         or non-ABL data types. Primary constraint (_Has-Pcnstrs) 
         is fine.
      */
      IF DICTDB._File._Has-Ccnstrs = "Y" 
         OR DICTDB._File._Has-Fcnstrs = "Y"
         OR DICTDB._File._Has-Ucnstrs = "Y"  THEN
         NEXT.

      /* check if any of the non-ABL data types are used in any of the columns */
      FIND FIRST DICTDB._Field OF DICTDB._File WHERE
           CAN-DO("short,byte,fixchar,fixraw,time,double,float":U,
                  DICTDB._Field._Data-type) NO-LOCK NO-ERROR.
      IF AVAILABLE DICTDB._Field THEN
          NEXT.

      if TERMINAL <> "" and user_env[6] NE "dump-silent" then 
        DISPLAY DICTDB._File._File-name WITH FRAME working.
      RUN "prodict/dump/_dmpdefs.p" ("t",RECID(DICTDB._File),user_env[26]).

      /* let's cache the encryption info in a temp-table */
      /* and the object attributes - for alt buffer pool settings */
      /* Skip multi-tennat objects since they have buffer pool per tenant */
      IF  (DICTDB._File._File-Attributes[1] = false )  and (DICTDB._File._File-Attributes[3] = false)
      and (VALID-OBJECT(myEPolicy) OR VALID-OBJECT(myObjAttrs)) THEN 
      DO:
         
         IF VALID-OBJECT(myEPolicy) THEN
             myEPolicy:getPolicyVersions(DICTDB._File._File-Number, 
                                         DICTDB._File._File-Name, 
                                         "Table", 
                                         OUTPUT DATASET dsObjAttrs BY-REFERENCE).

         IF VALID-OBJECT(myObjAttrs) THEN
            myObjAttrs:getObjectAttributes(DICTDB._File._File-Number, 
                                           DICTDB._File._File-Name, 
                                           "Table", 
                                           OUTPUT DATASET dsObjAttrs BY-REFERENCE).

         FOR EACH DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Dtype = 18 /* blob*/ OR
             DICTDB._Field._Dtype = 19 /* clob */ NO-LOCK:
             IF VALID-OBJECT(myEPolicy) THEN
                 myEPolicy:getPolicyVersions(DICTDB._Field._fld-stlen, 
                                             DICTDB._File._File-Name + "." + DICTDB._Field._Field-Name, 
                                             DICTDB._Field._Data-type, 
                                             OUTPUT DATASET dsObjAttrs BY-REFERENCE).
             IF VALID-OBJECT(myObjAttrs) THEN
                 myObjAttrs:getObjectAttributes(DICTDB._Field._fld-stlen, 
                                                DICTDB._File._File-Name + "." + DICTDB._Field._Field-Name, 
                                                DICTDB._Field._Data-type, 
                                                OUTPUT DATASET dsObjAttrs BY-REFERENCE).
         END.

         FOR EACH DICTDB._Index OF DICTDB._File NO-LOCK:
             IF VALID-OBJECT(myEPolicy) THEN
                 myEPolicy:getPolicyVersions(DICTDB._Index._Idx-num, 
                                             DICTDB._File._File-Name + "." + DICTDB._Index._Index-name, 
                                             "Index", 
                                             OUTPUT DATASET dsObjAttrs BY-REFERENCE).
             IF VALID-OBJECT(myObjAttrs) THEN
                 myObjAttrs:getObjectAttributes(DICTDB._Index._Idx-num, 
                                                DICTDB._File._File-Name + "." + DICTDB._Index._Index-name, 
                                                "Index", 
                                                OUTPUT DATASET dsObjAttrs BY-REFERENCE).
         END.
      END.
      end. /* for each _file */

    END. /* while */
  END.

  /* if encryption not enabled and not assigned to alternate buffer pool,
     don't care about them.
  */
  FOR EACH ttObjAttrs WHERE ttObjAttrs.obj-cipher = "" AND 
      ttObjAttrs.obj-buf-pool = 'Primary':
      DELETE ttObjAttrs.
  END.

  /* now for every object that has a valid not-null cipher and/or
     is assigned to the alternate buffer pool, dump it */
  FOR EACH ttObjAttrs:
      /* syntax is 
        obj-name;obj-type;cipher,value;[buffer-pool,value]
         
        where obj-type is TABLE,INDEX or FIELD 
        cipher or buffer-pool may be an empty string but not both
      */
      ASSIGN c = ttObjAttrs.obj-name + ";".
      IF ttObjAttrs.obj-type = "blob" OR ttObjAttrs.obj-type = "clob" THEN
          ASSIGN c = c + "FIELD".
      ELSE
          ASSIGN c = c + ttObjAttrs.obj-type.

      IF ttObjAttrs.obj-cipher NE "" THEN DO:
          ASSIGN dumpPol = YES
                  c = c + ";cipher," + ttObjAttrs.obj-cipher.
      END.
  
      IF ttObjAttrs.obj-buf-pool NE "Primary" THEN DO:
          dumpAltBuf = YES.
          ASSIGN c = c + ";buffer-pool," + ttObjAttrs.obj-buf-pool.
      END.

      RUN "prodict/dump/_dmpdefs.p" ("o",0, c).
  END.

  FOR EACH df-info:  
    IF SUBSTRING(df-line,1,1) <> " " THEN
      PUT STREAM ddl UNFORMATTED " " SKIP.
    PUT STREAM ddl UNFORMATTED df-line SKIP.
  END.
  if user_env[25] <> "AUTO"
   then do:  /* no other _db-schema will follow -> trailer */
      {prodict/dump/dmptrail.i
        &entries      = "IF dumpPol THEN PUT STREAM ddl UNFORMATTED
                      ""encpolicy=yes"" SKIP.
                        IF dumpAltBuf THEN PUT STREAM ddl UNFORMATTED
                        ""bufpool=yes"" SKIP."
        &seek-stream  = "ddl"
        &stream       = "stream ddl"
        }  /* adds trailer with code-page-entry to end of file */
   end.    /* no other _db-schema will follow -> trailer */  
   ELSE DO:
       /* in this case, the caller dumps the trailer info, so we pass
          the values for encpolicy and bufpool back.
       */
       user_filename = "".

       IF dumpPol THEN
          ASSIGN user_filename = 'encpolicy'.

       IF dumpAltBuf THEN
          ASSIGN user_filename = user_filename 
                   + (IF user_filename = '' THEN "" ELSE ",") 
                   + 'bufpool'.
   END.

  stopped = false.
  end. 

file_len = SEEK(ddl).
OUTPUT STREAM ddl CLOSE.

SESSION:IMMEDIATE-DISPLAY = no.
if TERMINAL <> "" and user_env[6] NE "dump-silent" then 
  run adecomm/_setcurs.p ("").

if user_env[6] = "no-alert-boxes" or user_env[6] = "dump-silent" then
do:  /* output WITHOUT alert-box */

  if stopped then DO:
      cMsg = "Dump terminated.".
      if user_env[6] eq "dump-silent" THEN 
            undo, throw new Progress.Lang.AppError(cMsg). 
      else 
           MESSAGE cMsg.
   end.
   else do:
    if file_len < 3 
     then do:  /* the file is empty - nothing to dump */

      OS-DELETE VALUE(user_env[2]). 
      if TERMINAL <> "" then do:
          
          cMsg =  "There were no " +  
             (if user_env[9] = "a" then "auto-connect records" else
              if user_env[9] = "s" then "sequence definitions" else
                               "data definitions"     ) + 
                               " to dump." + "~n" +
                               "The output file has been deleted.".
               
          if user_env[6] EQ "dump-silent" THEN  
             undo, throw new Progress.Lang.AppError(cMsg).
          else
             MESSAGE cMsg.
	   end.   
      end.
    else 
      if TERMINAL <> ""  then do:
          cMsg = "Dump of definitions completed.".
        if user_env[6] EQ "dump-silent" THEN  
            undo, throw new Progress.Lang.AppError(cMsg).
        else
            MESSAGE cMsg.
      end.       
  end.  
  
end.      /* output WITHOUT alert-box */

 else do:  /* output WITH alert-box */

  if stopped then do:
      if user_env[6] EQ "dump-silent" THEN  
             undo, throw new Progress.Lang.AppError("Dump terminated."). 
      else    
         MESSAGE "Dump terminated."
      	   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      end.
   else do:
    if file_len < 3 
     then do:  /* the file is empty - nothing to dump */

      OS-DELETE VALUE(user_env[2]). 
      if TERMINAL <> "" then do:
           cMsg =  "There were no " +  
             (if user_env[9] = "a" then "auto-connect records" else
              if user_env[9] = "s" then "sequence definitions" else
                               "data definitions"     ) + 
                               " to dump." + "~n" +
                               "The output file has been deleted.".
               
          if user_env[6] EQ "dump-silent" THEN  
             undo, throw new Progress.Lang.AppError(cMsg).
          else
             MESSAGE cMsg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       end.
      end. 
    else if TERMINAL <> "" then do:
        cMsg = "Dump of definitions completed.". 
        if user_env[6] EQ "dump-silent" THEN  
            undo, throw new Progress.Lang.AppError(cMsg).
        else
            MESSAGE cMsg 
	         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
	    end.     
    end.
  
  end.     /* output WITH alert-box */

if TERMINAL <> "" and user_env[6] NE "dump-silent" then
  HIDE FRAME working NO-PAUSE.

IF SESSION:CPINTERNAL NE "undefined":U THEN
   ASSIGN user_longchar = "".

IF VALID-OBJECT(myEPolicy) THEN
    DELETE OBJECT myEPolicy.

IF VALID-OBJECT(myObjAttrs) THEN
    DELETE OBJECT myObjAttrs.

RETURN.



