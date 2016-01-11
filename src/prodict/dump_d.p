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

/* file-name may be either a specific file or ALL */
/* 
File:   prodict/dump_d.p

IN:
    file-name                : "ALL" or "<file-name>"
    dot-d-dir                : directory relativ to working-directory
    code-page                : ?, "", "<code-page>"
    
History
    mcmann      10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
    mcmann      00/08/14 Changed _db-name to DICTDB for dbversion 20000810035
    mcmann      98/07/13 Added _Owner for _File finds
    laurief     97/12    Removed RMS,CISAM code
    kkelley         95/08    Multi-db with multiple tables
    hutegger    95/01    multi-db support
    hutegger    94/02    code-page support

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
  
*/

  
DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER code-page AS CHARACTER NO-UNDO.

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }

DEFINE VARIABLE c           AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_db-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_for-type  AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_int       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_list      AS CHARACTER NO-UNDO.
DEFINE VARIABLE save_ab     AS LOGICAL   NO-UNDO.

define temp-table ttb_dump
        field db        as character
        field tbl       as character
        index upi is primary unique db tbl.
        
if      code-page = ?  
 then assign code-page = "<internal defaults apply>".
 else do:
  if code-page = "" then assign code-page = SESSION:STREAM.
  else if codepage-convert("a",code-page,SESSION:CHARSET) = ?
                    then assign code-page = SESSION:STREAM.
  if codepage-convert("a",code-page,SESSION:CHARSET) = ?
                    then assign code-page = "<internal defaults apply>".
  end.
  
assign
  save_ab                   = SESSION:APPL-ALERT-BOXES
  SESSION:APPL-ALERT-BOXES  = NO.
  c                         = "".


/****** 1. step: create temp-table from input file-list ***********/

if file-name = "ALL"
 then do:  /* dump ALL files of ALL dbs */
  for each DICTDB._DB NO-LOCK:
    create ttb_dump.
    assign
      ttb_dump.db  = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                        THEN LDBNAME("DICTDB")
                        ELSE DICTDB._DB._Db-name
                     )
      ttb_dump.tbl = "ALL".
    end.    
  end.     /* dump ALL fiels of ALL dbs */
  
 else do:  /* dump SOME files of SOME dbs */
 
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
    
  end.     /* dump SOME files of SOME dbs */


/****** 2. step: load in all files according to temp-table ******/
  
for each DICTDB._Db NO-LOCK:

  assign
    l_db-name   = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                     THEN LDBNAME("DICTDB")
                     ELSE _DB._DB-name
                  )
    user_env[1] = ""
    l_for-type  = ( if CAN-DO("PROGRESS",DICTDB._DB._DB-Type) 
                     THEN ?
                     ELSE "TABLE,VIEW"
                  ).
/* to generate the list of tables of this _db-record to be dumped and
 * assign it to user_env[1] we
 * a) try to use all tables WITHOUT db-specifyer
 */
  for each ttb_dump
    where ttb_dump.db = ""
    while user_env[1] <> ",all":
    if ttb_dump.tbl <> "all"
     then do:
       IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
          find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                     AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                     no-lock no-error.
       ELSE
          find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                     no-lock no-error.                           
      if available DICTDB._File
       and ( can-do(l_for-type,DICTDB._File._For-type)
       or    l_for-type = ? )
       then assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
      end.
     else assign user_env[1] = ",all".
    end.

/* b) try to use all tables WITH db-specifyer */
  for each ttb_dump
    where ttb_dump.db = l_db-name
    while user_env[1] <> ",all":
    if ttb_dump.tbl <> "all"
     then do:
       IF INTEGER(DBVERSION("DICTDB")) > 8 THEN     
          find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                    AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                    no-lock no-error.
        ELSE
          find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                    no-lock no-error.                            
      if available DICTDB._File
       and ( can-do(l_for-type,DICTDB._File._For-type)
       or    l_for-type = ? )
       then assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
      end.
     else assign user_env[1] = ",all".
    end.
    
/* c) if either "all" or "all of this db" then we take every file
 *    of the current _Db
 */

  IF user_env[1] = ",all"
   then do:  /* all files of this _Db */
    assign user_env[1] = "".
    for each DICTDB._File
      WHERE DICTDB._File._File-number > 0
      AND   DICTDB._File._Db-recid = RECID(_Db)
      AND   NOT DICTDB._File._Hidden
      BY    DICTDB._File._File-name:
      
      IF INTEGER(DBVERSION("DICTDB")) > 8 
        AND DICTDB._File._Tbl-Type <> "V"     
        AND (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN") 
           THEN NEXT.
              
      if l_for-type = ?
       or can-do(l_for-type,DICTDB._File._For-type)
       then assign user_env[1] = user_env[1] + "," + DICTDB._File._File-name.
      END.
    assign user_env[1] = substring(user_env[1],2,-1,"character").
    END.     /* all files of this _Db */
   else assign
    user_env[1] = substring(user_env[1],2,-1,"character").
   
  /* is there something to dump in this _db? */
  if user_env[1] = "" then next.
  
  /* where to put the dump? */
  IF   INDEX(user_env[1],",") = 0
   then do:  /* ev. get dump-name */
    if  dot-d-dir matches "*/"
     or dot-d-dir = ""
     then user_env[2] = dot-d-dir.
     else user_env[2] = dot-d-dir + "/".
   IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
      FIND _File OF _Db WHERE _File._File-name = user_env[1]
                          AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
   ELSE
      FIND _File OF _Db WHERE _File._File-name = user_env[1].
                          
    assign
      user_env[2] = ( if  dot-d-dir matches "*" + "/"
                       or dot-d-dir = ""
                       then dot-d-dir
                       else dot-d-dir + "/"
                     ) + SUBSTRING
                     (      ( if _Dump-name = ?
                                  THEN _File-name 
                                  ELSE _Dump-name
                            ), 1, 8, "character"
                     ) + ".d".
    END.     /* ev. get dump-name */
   else assign
    user_env[2] = ( if  dot-d-dir matches "*" + "/"
                     or dot-d-dir = ""
                     then dot-d-dir
                     else dot-d-dir + "/"
                  ).
  
/* remaining needed assignments */
  assign
    user_env[3] = "" /* "MAP <name>" or "NO-MAP" OR "" */
    user_env[4] = ""
    user_env[5] = code-page
    user_env[6] = "no-alert-boxes"
    drec_db     = RECID(_Db)
    user_dbname = if _Db._Db-name = ? THEN LDBNAME("DICTDB")
                                      ELSE _Db._Db-Name
    user_dbtype = if _Db._Db-name = ? THEN DBTYPE("DICTDB")
                                      ELSE _Db._Db-Type
/*    user_dbname = LDBNAME("DICTDB") */
/*    user_dbtype = DBTYPE("DICTDB")  */.

  /* Indicate "y"es to disable triggers for dump of all files */
  assign
    user_env[4] = substring(fill(",y",num-entries(user_env[1]))
                           ,2
                           ,-1
                           ,"character"
                           ).

  RUN "prodict/dump/_dmpdata.p".

  END.    /* all _Db's */


SESSION:APPL-ALERT-BOXES = save_ab.
RETURN.



