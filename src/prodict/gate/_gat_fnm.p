/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

file: gate/_gat_fnm.p 

description:
    find unique name for foreign object

input:
    p_object    {"SEQUENCE"|"TABLE"|"FIELD"|"INDEX"}
    p_offile    recid of the s_ttb_tbl-record parenting this field
    
Output:
    p_obj-name  unique and purified for PROGRESS-use p_obj-name

called by:
    gate/gat_pul.i

history:
    95/06   hutegger    assimilated gat_xlt.p
    95/04   hutegger    created (derived from gat_nam.p)
    98/11   mcmann      Added check for length of name not greater than 32
    
--------------------------------------------------------------------*/
/*h-*/

define input        parameter p_object    as character no-undo.
define input        parameter p_offile    as recid     no-undo.
define input-output parameter p_obj-name  as character no-undo.

define variable c       as character no-undo.
define variable i       as integer   no-undo.
define variable ind     as integer   no-undo.
define variable endlp   as logical   no-undo.
define variable s       as character no-undo.
define variable ch      as character no-undo.
define variable l_abc   as character no-undo init
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".

&SCOPED-DEFINE xxDS_DEBUG                   DEBUG
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/gate/gatework.i  
    &new        = "  "
    &selvartype = "variable l"
    &options    = "initial ""*"" "
    }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

/* this translates a foreign field name into a native field name which
   is guaranteed not to be currently in use in this file */

/*------------------------------------------------------------------*/

/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/ message "_gat_fnm.p: creating dbug-output" view-as alert-box.
/**/ output to gat_fnm.lst append.
/**/ display "*************************************************" no-label
/**/   p_object p_offile p_obj-name with side-labels.
/**/ for each s_ttb_tbl:
/**/   display s_ttb_tbl.pro_name format "x(20)" 
/**/     s_ttb_tbl.ds_name        format "x(20)" 
/**/     s_ttb_tbl.ds_msc21       format "x(20)".
/**/   end.
/**/ for each DICTDB._File where DICTDB._File._db-recid  = p_offile
                             AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"):
/**/   display DICTDB._File._File-name  format "x(20)" 
/**/     DICTDB._File._For-name         format "x(20)" 
/**/     DICTDB._File._Fil-misc2[1]     format "x(20)".
/**/   end.
/**/ for each DICTDB._View:
/**/   display DICTDB._View._View-name.
/**/   end.
/**/ for each s_ttb_fld:
/**/   display s_ttb_fld.ttb_tbl s_ttb_fld.ds_name s_ttb_fld.pro_name.
/**/   end.
/**/ for each s_ttb_idx:
/**/   display s_ttb_idx.ttb_tbl s_ttb_idx.ds_name s_ttb_idx.pro_name.
/**/   end.
/**/ output close.
/**/ &ENDIF

assign 
  c     = p_obj-name
  endlp = no
  ind   = 1.

/* get rid of <qual>. from <qual>.<owner>.<object>
 * or <owner> from <owner>.<object>
 */

/* Object is never qualified. 
if ( p_object = "SEQUENCE"
 or  p_object = "TABLE"
 or  p_object = "INDEX"
   )
 and index(c,".") <> 0
 then assign
  c = substring(c,index(c,".") + 1, -1, "character").
*/

/* get rid of <owner>. from <qual>.<owner>.<object>
 * no-op for <owner>.<object>
 */

/* Object is never qualified. 
if ( p_object = "SEQUENCE"
 or  p_object = "TABLE"
 or  p_object = "INDEX"
   )
 and index(c,".") <> 0
 then assign
  c = substring(c,index(c,".") + 1, -1, "character").
*/

/* get rid of prefix of index-names (usually <table>##<index>)
 */
if p_object = "INDEX"
 and index(c,"##") <> 0
 then assign
  c = substring(c,index(c,"##") + 2, -1, "character").


/* make sure 1. character of name is correct */
/* old version; replaced because of asian names which endup as ""
 * do while INDEX(l_abc,SUBSTRING(c,1,1, "character")) = 0 
 *   and c <> "":
 *   assign c = SUBSTRING(c,2,-1,"character").
 *   end.
 */
if INDEX(l_abc,SUBSTRING(c,1,1, "character")) = 0 
 then assign c = "z" + c.


/* make sure rest of name is correct */
do while NOT endlp:
  
  assign ch = SUBSTRING(c, ind, 1, "character").
  
  IF LENGTH(ch, "character") = 0 OR ch = ?
   then do:
    endlp = yes.
    NEXT.
    end. 
  
  IF INDEX("#$%&-_0123456789" + l_abc, ch) <= 0
   then SUBSTRING(c, ind, 1, "character") = "_".

  assign ind = ind + 1.
  
  end.

/* make sure name is not "" */
assign
  c = (IF c = "" then "noname" else c) /* avoid 0-len names */
  s = c.
 
/* Progress limitation is 32 characters so make sure name is no longer */  
IF LENGTH(c) > 32 THEN
  ASSIGN c = SUBSTRING(c,1,32).
  
/* make sure we didn't endup with a keyword.
 * We do this though this doesn't work with runtime-licenses...
 */
IF KEYWORD(c) <> ?
 then assign SUBSTRING(c,MINIMUM(32,LENGTH(c,"character") + 1),-1,"character") = "_".


/* now the  name is purified to be usable for PROGRESS
 * last step: make it a unique name
 */
 
/* The unique index for _Sequence doesn't contain _Db-recid as component,
 * which makes it necessary to have a unique name across ALL schemas of
 * SchemaHolder. Since we plan to change this, I just comment out the
 * db-reference
 */
/* With V8 we have a unique-index on Sequenxces with _Db-reference. So
 * I decommented the _db-reference from the where-clause. (hutegger 95/08)
 */ 
if      p_object = "SEQUENCE"
 then do i = 1 TO 9999
  while can-find(FIRST s_ttb_seq
                 where s_ttb_seq.pro_name = c)
  or    can-find(first DICTDB._Sequence
                 where DICTDB._Sequence._db-recid = p_offile 
                 and   DICTDB._Sequence._Seq-name = c):
  c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") 
    + STRING(- i).
  end.
if      p_object = "TABLE"
 then do i = 1 TO 9999
  while can-find(FIRST s_ttb_tbl
                 where s_ttb_tbl.pro_name = c)
  or    can-find(first DICTDB._File
                 where DICTDB._File._db-recid  = p_offile 
                 and   DICTDB._File._File-name = c
                 and (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"))
  or    can-find(first DICTDB._View
                 where /*DICTDB._View._db-recid  = p_offile 
                 and  */ DICTDB._View._View-name = c):
  c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") 
    + STRING(- i).
  end.
else if p_object = "INDEX"
 then do i = 1 TO 9999
  while can-find(FIRST s_ttb_idx
                 where s_ttb_idx.ttb_tbl  = p_offile 
                 and   s_ttb_idx.pro_name = c):
  c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") 
    + STRING(- i).
  end.
else if p_object = "FIELD"
 then do i = 1 TO 9999
  while can-find(FIRST s_ttb_fld
                 where s_ttb_fld.ttb_tbl  = p_offile 
                 and   s_ttb_fld.pro_name = c):
  c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") 
    + STRING(- i).
  end.

assign p_obj-name = c.

/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/ output to gat_fnm.lst append.
/**/ display p_object p_offile p_obj-name
/**/   "*****************************" no-label
/**/   with side-labels.
/**/ output close.
/**/ message "_gat_fnm.p: creating dbug-output done" view-as alert-box.
/**/ &ENDIF

/*------------------------------------------------------------------*/

