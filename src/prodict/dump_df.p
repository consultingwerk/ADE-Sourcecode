/*********************************************************************
* Copyright (C) 2007,2009,2011,2016,2017 by Progress Software        *
* Corporation. All rights reserved.  Prior versions of this work may *
* contain portions contributed by participants of Possenet.          *
*                                                                    *
*********************************************************************/


/*--------------------------------------------------------------------   

File: prodict/dump_df.p

Description:
    This routine dumps the definition of all schemas in the first 
    Schema-Holder - all other schema-holders are ignored
    
    This was changed to that callers can call it persistently, so
    that we provide support for setting other settings that were
    not available before, such as the RCODE-POSITION. We can't change
    the signature of this for backward compatibility reasons, so
    we are providing another way for setting it. See Other-settings
    for the new settings that can be set. Each one of them can be
    set by calling the corresponding setter internal procedure.
    
    NOTE that this can still be called as a regular procedure, in
    which case we will run it as previously with no change in behavior.

Input-Parameters:
    file-name                : "ALL" or "<file-name> [,<filename>] ..."
    df-file-name             : Name of file to dump to
    code-page                : ?, "", "<code-page>"
    
Other-settings:    
    rcode-position           : yes or no
    
History
    fernando  05/14/09  Support for encryption/alternate buffer pool
    fernando  10/12/06  Allow this to be called persistently
    fernando  03/14/06  Handle case with too many tables selected - bug 20050930-006.    
    McMann    10/17/03  Add NO-LOCK statement to _Db find in support of on-line schema add
    McMann    02/10/03  Added USER-INDEX _file-name for On-line schema add
    Mario B   99/03/15  Default user_env[26] to "y" for dump _Field._Field-rpos
    mcmann    98/07/13  Added _Owner to _file finds
    laurief     97/12   Removed RMS,CISAM code
    hutegger    95/01   single-files in multiple schemas
    hutegger    94/04   multiple schema/db support (DataServers)
    hutegger    94/02   code-page support
    
Multi-DB-Support:
    the syntax of file-name is:
           [ <DB>. ] <tbl>             [ <DB>. ] <tbl>
        {  ---------------  }  [ , {  ---------------  } ] ...
             <DB>."ALL"                  <DB>."ALL"
    {   -----------------------------------------------------------  }
                        "ALL"

Code-page - support:
    code-page = ?             : no-conversion
    code-page = ""            : default conversion (SESSION:STREAM)
    code-page = "<code-page>" : convert to <code-page>

    if not convertable to code-page try to convert to SESSION:STREAM
    if still not convertable don't convert at all

Example:

This is an example on how to call this proc persistently to set the
newly added options:


DEF VAR h AS HANDLE NO-UNDO.
RUN prodict/dump_df.p PERSISTENT SET h 
    (INPUT file-name, INPUT df-file-name, INPUT code-page).
RUN IncludeRcodePosition IN h (NO). /* this is optional */
RUN doDump IN h.
DELETE PROCEDURE h.

FOR OE Architect: CR# OE00198400

This is an example on how to call this proc persistently to set the
newly added option of silent dump and to catch any errors:
    
routine-level on error undo, throw.
define variable h as handle no-undo.

run prodict/dump_df.p PERSISTENT SET h ("customer,order","C:\OpenEdge\WRK\110\dump12.df",?).
run setSilent in h(yes).
run doDump in h.
delete procedure h. 

catch e as Progress.Lang.AppError :
    message e:ReturnValue
    view-as  alert-box .  
end catch.
  
  
--------------------------------------------------------------------*/        
using Progress.Lang.*.
routine-level on error undo, throw.


/*h-*/


/*----------------------------  DEFINES  ---------------------------*/

DEFINE INPUT PARAMETER file-name    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER df-file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER code-page    AS CHARACTER NO-UNDO.

/* This is the new setting that can be set by calling the provided setter
   internal procedures, if this is called persistently. Otherwise, the
   behavior remains the same as previous versions, with the same default
   value.
*/
DEFINE VARIABLE rcode-position      AS LOGICAL   NO-UNDO INIT YES.
DEFINE VARIABLE dumpPol             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dumpAltBuf          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE setdmpSilent        AS LOGICAL   NO-UNDO INIT NO.

{ prodict/user/uservar.i NEW }
{ prodict/dictvar.i NEW }


DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_first-db    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_int         AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_item        AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_list        AS CHARACTER NO-UNDO.
DEFINE VARIABLE save_ab       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_dmp-files   AS CHARACTER NO-UNDO format "x(256)":u
    INITIAL ["_file,_field,_index,_index-field,_file-trig,_field-trig" ].
DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

define temp-table ttb_dump
        field db        as character
        field tbl       as character
        index upi is primary unique db tbl.
        
DEFINE STREAM   ddl.

/*--------------------------- INTERNAL PROCS  --------------------------*/

PROCEDURE setFileName:
    DEFINE INPUT PARAMETER pfile-name AS CHAR NO-UNDO.
    ASSIGN file-name = pfile-name.
END.


PROCEDURE setDfFileName:
    DEFINE INPUT PARAMETER pdf-file-name AS CHAR NO-UNDO.
    ASSIGN df-file-name = pdf-file-name.
END.


PROCEDURE setCodePage:
    DEFINE INPUT PARAMETER pcodepage AS CHAR NO-UNDO.
    ASSIGN code-page = pcodepage.
END.


PROCEDURE IncludeRcodePosition:
    DEFINE INPUT PARAMETER prcode-position AS LOGICAL NO-UNDO.
    ASSIGN rcode-position = prcode-position.
END.

PROCEDURE SetSilent:
    DEFINE INPUT PARAMETER setsilent AS LOGICAL NO-UNDO.
    ASSIGN setdmpSilent = setsilent.
END.

/* This is the meat of this procedure */
PROCEDURE doDump:
    DEFINE VARIABLE l_tmp-file    AS CHARACTER NO-UNDO format "x(256)":u.
    DEFINE VARIABLE l_db-name     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_for-type    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMsg          AS CHARACTER NO-UNDO.
    
    IF df-file-name = ? THEN 
    DO on error undo, throw:
        cMsg = "ERROR: You must specify the .df file name".
        if setdmpSilent then 
        do: 
            undo, throw new AppError(cMsg).
        end.
        else do:   
            MESSAGE cMsg.
            RETURN.
        end.
    END.

    /* make sure table is empty */
    EMPTY TEMP-TABLE ttb_dump NO-ERROR.

    /* make sure these are clear */
    ASSIGN user_env = ""
           user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").
    
    if      code-page = ?  
     then assign code-page = "<internal defaults apply>".
     else do:
      if code-page = "" then assign code-page = SESSION:STREAM.
      else if codepage-convert("a":u,code-page,SESSION:CHARSET) = ?
                        then assign code-page = SESSION:STREAM.
      if codepage-convert("a":u,code-page,SESSION:CHARSET) = ?
                        then assign code-page = "<internal defaults apply>".
      end.
      
                               
    /* dump/_dmpsddl.p dumps into a file without append-option       */
    /* -> a) dump definitions into temporary file                    */
    /*    b) concatenate these to the file according input-parameter */
    
    /* get a unique name, delete ev. existing source-file */
    RUN adecomm/_tmpfile.p (l_tmp-file, ".df", OUTPUT l_tmp-file). 
    if search(df-file-name) <> ? then OS-DELETE value(df-file-name).
      
    assign
      l_first-db               = TRUE
      save_ab                  = SESSION:APPL-ALERT-BOXES
      SESSION:APPL-ALERT-BOXES = NO
      user_env[25]             = "AUTO"
      user_env[26]             = (IF rcode-position THEN "y" ELSE "n").  
    
                           
    /****** 1. step: create temp-table from input file-list ***********/
    
    if file-name = "ALL" then 
    do:  /* dump ALL file-definitions of ALL dbs */
        for each DICTDB._DB NO-LOCK:
            create ttb_dump.
            assign
               ttb_dump.db  = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                                THEN LDBNAME("DICTDB")
                                ELSE DICTDB._DB._Db-name
                               )
               ttb_dump.tbl = "*ALL*".
        end.    
     end.     /* dump ALL file-definitions of ALL dbs */
      
     else do:  /* dump SOME file-definitions of SOME dbs */
     
      assign l_list = file-name.
      repeat i = 1 to num-entries(l_list):
        create ttb_dump.
        assign
          l_item = entry(i,l_list)
          l_int  = index(l_item,".").
        if l_int = 0
         then assign
          ttb_dump.db  = ""
          ttb_dump.tbl = l_item.
         else assign
          ttb_dump.db  = substring(l_item,1,l_int - 1,"character")
          ttb_dump.tbl = substring(l_item,l_int + 1, -1,"character").
        end.
        
      end.     /* dump SOME file-definitions of SOME dbs */
    
    /****** 2. step: dump definitions according to temp-table ******/
      
    for each DICTDB._DB NO-LOCK
      by DICTDB._Db._Db-name DESCENDING : /* all schemas of current
                                          * schema-holder beginning with
                                          * the PROGRESS-DB
                                          */
                                 
      /* check run-time read-privileges */
      FOR EACH DICTDB._File
        WHERE DICTDB._File._File-name begins "_":
        IF  INDEX(l_dmp-files,DICTDB._File._File-name) = 0 
         OR CAN-DO(DICTDB._File._Can-read,USERID("DICTDB")) 
         THEN NEXT.
        if setdmpSilent then 
        do: 
            undo, throw new AppError("You do not have permission to dump table definitions.").
        end.
        ELSE         
        MESSAGE "You do not have permission to dump table definitions.".
        NEXT.
      END.
    
      assign
        l_db-name   = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                         THEN LDBNAME("DICTDB")
                         ELSE DICTDB._DB._DB-name
                      )
        user_env[1] = ""
        user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
        l_for-type  = ( if CAN-DO("PROGRESS",DICTDB._DB._DB-Type)
                         THEN ?
                         ELSE "TABLE,VIEW"
                      ).
    /* to generate the list of tables of this _db-record to be dumped and
     * assign it to user_longchar we
     * a) try to use all tables WITHOUT db-specifyer
     */
      for each ttb_dump
        where ttb_dump.db = ""
        while user_env[1] <> ",all":
        if ttb_dump.tbl <> "*ALL*"
         then do:
          FOR EACH DICTDB._File of DICTDB._Db
            where DICTDB._File._File-name = ttb_dump.tbl
            USE-INDEX _File-name no-lock:
            
            IF INTEGER(DBVERSION("DICTDB")) > 8
               AND DICTDB._File._Tbl-Type = "V"
               AND (DICTDB._File._Owner <> "PUB" OR DICTDB._File._Owner <> "_FOREIGN")  
               THEN NEXT.
            ELSE
             LEAVE.     
          END.     
          if available DICTDB._File
           and ( can-do(l_for-type,DICTDB._File._For-type)
           or    l_for-type = ? )
           then do:
              IF isCpUndefined THEN
                 user_env[1] = user_env[1] + "," + ttb_dump.tbl.
              ELSE
                 user_longchar = user_longchar + "," + ttb_dump.tbl.

             drec_file   = RECID(DICTDB._File).
          END.
          end.
         else assign user_env[1] = ",all".
        end.
    
    /* b) try to use all tables WITH db-specifier */
      for each ttb_dump
        where ttb_dump.db = l_db-name
        while user_env[1] <> ",all":
        if ttb_dump.tbl <> "*ALL*"
         then do:
          FOR EACH DICTDB._File of DICTDB._Db
            where DICTDB._File._File-name = ttb_dump.tbl
            USE-INDEX _File-name no-lock:
            
            IF INTEGER(DBVERSION("DICTDB")) > 8
               AND DICTDB._File._Tbl-Type = "V"
               AND (DICTDB._File._Owner <> "PUB" OR DICTDB._File._Owner <> "_FOREIGN")  
               THEN NEXT.
            ELSE
               LEAVE.
          END.          
          if available DICTDB._File
           and ( can-do(l_for-type,DICTDB._File._For-type)
           or    l_for-type = ? )
           then do:
              IF isCpUndefined THEN
                 user_env[1] = user_env[1] + "," + ttb_dump.tbl.
              ELSE
                 user_longchar = user_longchar + "," + ttb_dump.tbl.

             drec_file   = RECID(DICTDB._File).
           END.
          end.
         else assign user_env[1] = ",all".
        end.
        
    /* c) if either "all" or "all of this db" then we take every file
     *    of the current _Db
     */
    
      IF user_env[1] = ",all"
       then do:  /* all files of this _Db */
        assign user_env[1] = "".
        IF NOT isCpUndefined THEN
           assign user_longchar = "".

        for each DICTDB._File
          WHERE DICTDB._File._File-number > 0
          AND   DICTDB._File._Db-recid = RECID(DICTDB._Db)
          AND   NOT DICTDB._File._Hidden
          USE-INDEX _File-name
          BY    DICTDB._File._File-name:
    
            IF INTEGER(DBVERSION("DICTDB")) > 8
               AND DICTDB._File._Tbl-Type = "V"
               AND (DICTDB._File._Owner <> "PUB" OR DICTDB._File._Owner <> "_FOREIGN")  
               THEN NEXT.
               
          if l_for-type = ?
           or can-do(l_for-type,DICTDB._File._For-type)
           then do:
              IF isCpUndefined THEN
                 assign user_env[1] = user_env[1] + "," + DICTDB._File._File-name.
              ELSE
                 assign user_longchar = user_longchar + "," + DICTDB._File._File-name.
          END.
        END.
        IF isCpUndefined THEN
            assign user_env[1] = substring(user_env[1],2,-1,"character").
        ELSE
            assign user_longchar = substring(user_longchar,2,-1,"character").
        END.     /* all files of this _Db */
      else do:

         IF isCpUndefined THEN
            user_env[1] = substring(user_env[1],2,-1,"character").
         ELSE
            user_longchar = substring(user_longchar,2,-1,"character").
      END.
       
      /* is there something to dump in this _db? */
      if NOT isCpUndefined AND user_longchar = "" then next.
      if     isCpUndefined AND user_env[1] = ""   then next.
      
      /* remaining needed assignments */
      ASSIGN
        user_dbname   = l_db-name
        user_dbtype   = l_for-type
        drec_db       = RECID(_Db)
        user_env[2]   = l_tmp-file
        user_env[5]   = code-page
        user_env[6]   = if setdmpSilent then "dump-silent" else "no-alert-boxes"
        user_env[9]   = "d"
        user_filename = ( if file-name = "ALL"
                           then "ALL"
                          else if index((IF isCpUndefined THEN user_env[1] ELSE user_longchar),",") = 0
                           then "ONE"  + string(l_first-db,"/ MORE")
                           else "SOME" + string(l_first-db,"/ MORE")
                        ).
      IF NOT isCpUndefined THEN DO:
          /* see if we can put user_longchar into user_env[1] */
          ASSIGN user_env[1] = user_longchar NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
             /* ok to use user_env[1] */
             ASSIGN user_longchar = "". 
          ELSE
             ASSIGN user_env[1] = "".
      END.

      DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        RUN "prodict/dump/_dmpsddl.p".

        IF LOOKUP("encpolicy", user_filename) > 0 THEN
           dumpPol = YES.

        IF LOOKUP("bufpool", user_filename) > 0 THEN
           dumpAltBuf = YES.
      END.
      
      OS-APPEND value(l_tmp-file) VALUE(df-file-name).
      
      assign l_first-db = FALSE.
      
      END.         /* all schemas of current schema-holder */
    
    OS-DELETE value(l_tmp-file).
    
    OUTPUT STREAM ddl TO VALUE(df-file-name) APPEND.
          {prodict/dump/dmptrail.i
            &entries = "IF dumpPol THEN PUT STREAM ddl UNFORMATTED
                        ""encpolicy=yes"" SKIP.
                        IF dumpAltBuf THEN PUT STREAM ddl UNFORMATTED
                        ""bufpool=yes"" SKIP."            
            &seek-stream  = "ddl"
            &stream       = "stream ddl"
            }  /* adds trailer with code-page-entrie to end of file */
    OUTPUT STREAM ddl CLOSE.
    
    assign SESSION:APPL-ALERT-BOXES = save_ab.
  
END PROCEDURE.


/*---------------------------  MAIN-CODE  --------------------------*/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

/* if not running persistenty, go ahead and dump the definitions */
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doDump.

