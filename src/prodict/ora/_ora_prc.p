/*********************************************************************
* Copyright (C) 2019 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

file: prodict/ora/_ora_prc.p

description:
    pulls schemainfo of procedure, FUNCTIONS and PACKAGES
    In difference to the other objects, these objects don't have
    indizes and triggers. However it is (at the moment) still possible
    to enter some of these, so we also try to retain it, just like 
    with the other objects.

Input:
    p_typevar   foreign type
    p_namevar   foreign name of base-object
    p_namevar-s foreign name of synonym (= p_namevar, if obj not synonym)
    p_progvar   progress-name
    p_spclvar   link-name

Output:
    p_gate-work recid of parent gate-work
    p_ttb_tbl   if only one procedure or function
                    then recid of s_ttb_tbl record
                    else  UNKNOWN
    s_ttb_tbl   table-information of all objects
    s_ttb_fld   field-information of all objects
    s_ttb_idx   index-information of all objects
    s_ttb_idf   index-field-information of all objects

History:
    hutegger    96/05   nameing-problem with packages, by checking wether
                        the _File already exists, and if so, use its
                        file-name instead of generating a new one
    hutegger    95/03   created out of _ora_fun.p
    mcmann    09/30/02  Added THREE-D to frame to match the rest of the
                        utility.
	fernando   06/11/07  Unicode and clob support
	hjivani	  24/04/19	Procedure without parameter is handled seperately
						starting from oraversion >=12
--------------------------------------------------------------------*/

/*--------------------------------------------------------------------
comments from prodict/ora/_ora_fun.p:

History:
    hutegger    95/01/26    changed schmea-triggers to internal procs
    hutegger    94/07/28    reworked
    marceau     94/07/20    prototype

--------------------------------------------------------------------*/
/*h-*/

define INPUT  parameter p_typevar                as integer.
define INPUT  parameter p_namevar                as character.
define INPUT  parameter p_namevar-s              as character.
define INPUT  parameter p_uservar                as character.
define INPUT  parameter p_progvar                as character.
define INPUT  parameter p_spclvar                as character.
define INPUT  parameter p_gate-work              as recid.
define OUTPUT parameter p_ttb_tbl                as RECID NO-UNDO.

&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

{ prodict/user/uservar.i }
{ prodict/ora/ora_ctl.i 8 }

define variable batch_mode          as logical   no-undo.
define variable dtyp                as integer   no-undo.
define variable fnam                as character no-undo.
define variable i                   as integer   no-undo.
define variable j                   as integer   no-undo.
define variable l_char-types        as character no-undo.
define variable l_chrw-types        as character no-undo.
define variable l_date-types        as character no-undo.
define variable l_dcml              as integer   no-undo.
define variable l_dcml-types        as character no-undo.
define variable l_dt                as character no-undo.
define variable l_floa-types        as character no-undo.
define variable l_frmt              as character no-undo.
define variable l_i###-types        as character no-undo.
define variable l_i##d-types        as character no-undo.
define variable l_i##l-types        as character no-undo.
define variable l_i#dl-types        as character no-undo.
define variable l_init              as character no-undo.
define variable l_logi-types        as character no-undo.
define variable l_prec              as integer   no-undo.
define variable l_time-types        as character no-undo.
define variable l_tmst-types        as character no-undo.
define variable l_scale             as integer   no-undo.
define variable msg                 as character no-undo EXTENT 6.
define variable nexts               as integer   no-undo.
define variable ntyp                as character no-undo.
define variable onum                as integer   no-undo.
define variable overld              as integer   no-undo.
define variable over-name           as character no-undo.
define variable pkgnm               as character no-undo.
define variable pnam                as character no-undo.
define variable rid                 as recid     no-undo.
define variable stoff               as integer   no-undo.
define variable tnam                as character no-undo.
DEFINE VARIABLE tdbtype         AS CHARACTER NO-UNDO.
DEFINE VARIABLE oraversion      AS INTEGER   NO-UNDO.

define buffer over_file         for DICTDB._File.
define buffer ds_columns        for DICTDBG.oracle_arguments.
define buffer ds_comments       for DICTDBG.oracle_comment.
define buffer ds_procedures     for DICTDBG.oracle_procinfo.

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/

FORM
                                                    SKIP(1)
  msg[1] FORMAT "x(25)" LABEL "Package"    colon 10 
  "->" 
  msg[2] FORMAT "x(25)" LABEL "  Package"           SKIP 
  msg[3] FORMAT "x(25)" LABEL "Procedure"  colon 10 
  "->"
  msg[4] FORMAT "x(25)" LABEL "Procedure"           SKIP
  msg[5] FORMAT "x(25)" LABEL "Argument"   colon 10
  "->"
  msg[6] FORMAT "x(25)" LABEL " Argument"           SKIP(1)
 with frame ds_make 
  ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
  TITLE " Loading ORACLE Definitions " + p_spclvar THREE-D USE-TEXT.
  
/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/

define variable o-name        as character no-undo. /* local forgn-name */
define variable o-prog        as character no-undo. /* local table-name */
define variable o-type        as character no-undo. /* local forgn-type */
define variable o-pckg        as character no-undo. /* local package-id */
define variable reuse         as integer   no-undo. /* Whether to reuse the s_ttb_tbl*/
/*------------------------------------------------------------------*/
procedure error_handling:

define INPUT PARAMETER error-nr         as INTEGER.
define INPUT PARAMETER param1           as cHARACTER.
define INPUT PARAMETER param2           as cHARACTER.

define       variable  err-msg as character extent 5 initial [
/*  1 */ "WARNING: Field not found for Index-Field (Object#: &1 Field#: &2).",
/*  2 */ "ERROR: Table &1 has unsupported data types.",
/*  3 */ "       Skipping this table...",
/*  4 */ "WARNING: Index &1 has too many components; Accepting only first 16.",
/*  5 */ " &1 &2 " /* intentionally left blank for div. error-messages */
    ].
    
    if param1 = ? then assign param1 = "".
    if param2 = ? then assign param2 = "".
    
    if s_1st-error = false
     then do:
      assign s_1st-error = true.
      output stream s_stm_errors to ds_upd.e.
      output stream s_stm_errors close.
      end.
    output stream s_stm_errors to ds_upd.e append.
    PUT stream s_stm_errors unformatted
              SUBSTITUTE(err-msg[error-nr],param1,param2)  skip.
    output stream s_stm_errors close.
  
    end.  /* error_handling */


/*------------------------------------------------------------------*/
pause 0 no-message. /* needed for protoora to avoid "press spacebar..." */
assign
  batch_mode   = SESSION:BATCH-MODE.

find first DICTDBG.oracle_users
  where DICTDBG.oracle_users.name = p_uservar
  no-lock.

FOR EACH DICTDBG.oracle_objects
  where DICTDBG.oracle_objects.name   = p_namevar
    and   DICTDBG.oracle_objects.owner# = DICTDBG.oracle_users.user#
  no-lock:

  IF DICTDBG.oracle_objects.type = p_typevar THEN LEAVE.
END.
  
/* 20041223-004 
   if this an empty package, with nothing in it, don't bother adding it to the schema, just return 
*/
find first DICTDB._Db
    where DICTDB._Db._Db-name = LDBNAME("DICTDBG")
    and   DICTDB._Db._Db-type = "ORACLE".
ASSIGN oraversion = INTEGER(DICTDB._Db._Db-misc1[3]).

/* just make sure the info in the schema holder isn't invalid */
IF oraversion > 8 THEN DO:
   RUN prodict/ora/_get_oraver.p (OUTPUT oraversion).
   /* if something went wrong that we could not get the version, just keep the value
      from the schema holder
   */
   IF oraversion = 0 THEN
       oraversion = INTEGER(DICTDB._Db._Db-misc1[3]). 
END.

onum = DICTDBG.oracle_objects.obj#.
p_ttb_tbl = 0.
reuse = 0.

IF p_typevar = 9 THEN DO:

    IF oraversion >= 12 THEN DO:
        FOR EACH ds_procedures
            WHERE ds_procedures.obj#=onum NO-LOCK:
    
            FIND FIRST ds_columns 
                WHERE ds_columns.obj# = ds_procedures.obj# 
                AND ds_columns.procedure$ = ds_procedures.PROCEDURENAME
                AND ds_columns.overload# = ds_procedures.overload# NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE ds_columns THEN DO:
                /*When a procedure is in procedureinfo table and not in arguemnt$ */
                /*this is to handle the case when there is proc without parameter inside package*/
                
                assign
                    overld = ds_procedures.overload#
                    o-name = ds_procedures.PROCEDURENAME
                    o-prog = o-name
                           + ( if overld > 0 
                                then "#" + STRING (overld, "999") 
                               else ""
                             )
                    o-type = "PROCEDURE"        /*Only a procedure can be without any parameter*/
                    o-pckg = p_namevar-s.
        
                find first DICTDB._File
                    where DICTDB._File._db-recid     = drec_db
                    and   DICTDB._File._fil-misc2[1] = o-pckg
                    and   DICTDB._File._for-name     = o-name
                    and   DICTDB._File._for-type     = o-type
                    and ( overld = 0
                           or DICTDB._File._file-name matches "*#" + STRING (overld, "999")
                        )
                    no-lock no-error.
        
                if not available DICTDB._File
                then do:
                    RUN prodict/gate/_gat_fnm.p 
                        ( INPUT        "TABLE",
                          INPUT        drec_db,
                          INPUT-OUTPUT o-prog
                        ).
                end.
                else assign
                    o-prog = DICTDB._File._file-name.
                
                /***** adjust screen-protocol *****/
                if TERMINAL <> "" and not batch_mode 
                then display
                  o-pckg @ msg[1] o-pckg @ msg[2]
                  o-name @ msg[3] o-prog @ msg[4] 
                  ""     @ msg[5] ""     @ msg[6]
                  with frame ds_make.
          
                /***** create s_ttb_tbl record *****/
                create s_ttb_tbl.
        
                if p_ttb_tbl = 0 then p_ttb_tbl = integer(RECID(s_ttb_tbl)).
                else p_ttb_tbl = ? .
        
                assign
                  s_ttb_tbl.gate-work    = p_gate-work
                  s_ttb_tbl.ds_msc21     = o-pckg
                  s_ttb_tbl.pro_name     = o-prog
                  s_ttb_tbl.ds_name      = o-name
                  s_ttb_tbl.ds_spcl      = ( if p_spclvar = ""
                                             then ?
                                             else p_spclvar
                                           )
                  s_ttb_tbl.ds_type      = o-type
                  s_ttb_tbl.ds_user      = p_uservar
                  stoff                  = 1
                  rid                    = RECID (s_ttb_tbl).
            
            END.
        END.
    END.
	
/* If there is no more procedure/function than exit. */
    FIND FIRST ds_columns WHERE ds_columns.obj# = DICTDBG.oracle_objects.obj# NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ds_columns THEN
        RETURN.
END.


assign
  l_char-types  = "CHAR,VARCHAR,VARCHAR2,ROWID,NCHAR,NVARCHAR2"
  l_chrw-types  = "LONG,RAW,LONGRAW,CLOB,NCLOB,BLOB"
  l_date-types  = "DATE"
  l_dcml-types  = ""
  l_floa-types  = "FLOAT"
  l_i#dl-types  = "NUMBER,CURSOR"
  l_i##d-types  = ""
  l_i##l-types  = ""
  l_i###-types  = "TIME"
  l_logi-types  = "LOGICAL"
/*l_time-types  = ""*/
  l_tmst-types  = "TIMESTAMP,TIMESTAMP_LOCAL,TIMESTAMP_TZ".

/*------------------------------------------------------------------*/

/********************************************************************/
/*          create PROGRESS-objects using the ORACLE-infos          */
/********************************************************************/


/*****----------------------------------------------------------*****/
/*****-------------- handle _file - entry/entries --------------*****/
/*****----------------------------------------------------------*****/

if p_typevar = 9
 then assign 
  o-name = p_namevar-s + "..."
  o-pckg = p_namevar-s
  o-prog = p_progvar + "..."
  o-type = ENTRY(p_typevar + 1,oobjects).
 else assign 
  o-name = p_namevar-s
  o-pckg = ""
  o-prog = p_progvar
  o-type = ENTRY(p_typevar + 1,oobjects).
    
/***** screen-protocol *****/
  if TERMINAL <> "" and not batch_mode 
   then display
      o-pckg @ msg[1] o-pckg @ msg[2]
      o-name @ msg[3] o-prog @ msg[4] 
      ""     @ msg[5] ""     @ msg[6]
      with frame ds_make.
     
/***** create s_ttb_tbl record *****/
  create s_ttb_tbl.
  assign
    p_ttb_tbl              = ( if p_ttb_tbl <> 0
                               then ?
                               else integer(RECID(s_ttb_tbl))
                             )
    s_ttb_tbl.gate-work    = p_gate-work
    s_ttb_tbl.pro_name     = o-prog
    s_ttb_tbl.ds_msc21     = o-pckg
    s_ttb_tbl.ds_spcl      = ( if p_spclvar = ""
                                 then ?
                                 else p_spclvar
                             )
    s_ttb_tbl.ds_name      = o-name
    s_ttb_tbl.ds_user      = p_uservar
    s_ttb_tbl.ds_type      = o-type
    stoff                  = 1
    rid                    = RECID (s_ttb_tbl).

if p_typevar = 9 then reuse = 1.

/* for each "item" of that object:                  */
/*      procedure$ = name of that item              */
/*      overload#  = overload-instance of that item */
/*      sequence#  = 0: procedure                   */
/*                   1: function                    */
/*                  >1: parameters                  */
/*      position   = 0 for function; else procedure */
/*      type#      = 251: this parameter is array   */
/*                   x   parameter - data-type      */
_crtloop:
for each ds_columns
  fields( obj# procedure$ overload# sequence# type# position argument
          level# in_out default$ default# length_ charsetform)
  where ds_columns.obj# = onum
  no-lock
  by ds_columns.procedure$
  by ds_columns.overload#
  by ds_columns.sequence#
  /*transaction*/: /* 20040309-029 moved the transaction to code below*/


/*****----------------------------------------------------------*****/
/*****-------------- adjust s_ttb_tbl for packages -------------*****/
/*****----------------------------------------------------------*****/

  if ds_columns.sequence# <= 1
   then DO:  /* object = { package, procedure, function } */
    
    /* generate the right table-, package- and type-names */
    if p_typevar = 9
     then DO:  /* object = package */
      assign
        overld = ds_columns.overload#
        o-name = ds_columns.procedure$
        o-prog = o-name
               + ( if overld > 0 
                    then "#" + STRING (overld, "999") 
                    else ""
                 )
        o-type = ( if ds_columns.position = 0
                    then "FUNCTION"
                    else "PROCEDURE"
                 ).

      find first DICTDB._File
        where DICTDB._File._db-recid     = drec_db
        and   DICTDB._File._fil-misc2[1] = o-pckg
        and   DICTDB._File._for-name     = o-name
        and   DICTDB._File._for-type     = o-type
        and ( overld = 0
           or DICTDB._File._file-name matches "*#" + STRING (overld, "999")
            )
        no-lock no-error.

      if not available DICTDB._File
       then do:
        RUN prodict/gate/_gat_fnm.p 
          ( INPUT        "TABLE",
            INPUT        drec_db,
            INPUT-OUTPUT o-prog
          ).
        end.
       else assign
        o-prog = DICTDB._File._file-name.


    /***** adjust screen-protocol *****/
      if TERMINAL <> "" and not batch_mode 
       then display
          o-pckg @ msg[1] o-pckg @ msg[2]
          o-name @ msg[3] o-prog @ msg[4] 
          ""     @ msg[5] ""     @ msg[6]
          with frame ds_make.
      
    /***** create/adjust s_ttb_tbl record *****/
      if reuse = 1
       then do: /* use previously created s_ttb_tbl-record */
        assign
          reuse = -1
          p_ttb_tbl              = ( if p_ttb_tbl = RECID(s_ttb_tbl)
                                     then RECID(s_ttb_tbl)
                                     else ?
                                    )
          s_ttb_tbl.pro_name     = o-prog
          s_ttb_tbl.ds_name      = o-name
          s_ttb_tbl.ds_type      = o-type
          stoff                  = 1
          rid                    = RECID (s_ttb_tbl).
        end.     /* use previously created s_ttb_tbl-record */
        
       else do:  /* next proc/func in package -> create new s_ttb_tbl */
        create s_ttb_tbl.
        assign
          p_ttb_tbl              = ?
          s_ttb_tbl.gate-work    = p_gate-work
          s_ttb_tbl.ds_msc21     = o-pckg
          s_ttb_tbl.pro_name     = o-prog
          s_ttb_tbl.ds_name      = o-name
          s_ttb_tbl.ds_spcl      = ( if p_spclvar = ""
                                       then ?
                                       else p_spclvar
                                   )
          s_ttb_tbl.ds_type      = o-type
          s_ttb_tbl.ds_user      = p_uservar
          stoff                  = 1
          rid                    = RECID (s_ttb_tbl).
        end.     /* next proc/func in package -> create new s_ttb_tbl */

      end.     /* object = package */

    if ds_columns.sequence# < 1 
     then NEXT. /* procedure has no return-value */

    end.     /* object = { package, procedure, function } */


/*****----------------------------------------------------------*****/
/*****------------- handle _field - entry/entries --------------*****/
/*****----------------------------------------------------------*****/

  if ds_columns.type# = 251 
   then do:         /* 251: this field is an array, and the   */
    assign          /*      next argument holds the data-type */
      nexts  = 2    /* arbitruary */
      o-name = ds_columns.argument.
    NEXT.
    end.
  else if ds_columns.level# = 0
   then assign nexts = 0.
/* else: this is the actual field, use nexts from previous field */

  { prodict/ora/ora_typ.i 
    &procedure = "YES"
    }
  
  assign 
    pnam  = ( if ds_columns.argument <> ?
               then ds_columns.argument 
               else ds_columns.procedure$
            )
    pnam  = ( if  pnam = ?
                or ds_columns.level# > 0
                then o-name
                else pnam
            )
    fnam  = pnam.
  
  /* NCHAR and NVARCHAR2 (Unicode Types) are only supported as such
     with Oracle 9 and up, otherwise, they will be treated as character
  */
  IF (l_dt = "NVARCHAR2" OR l_dt = "NCHAR") AND oraversion < 9 THEN DO:
      IF l_dt = "NVARCHAR2" THEN
          l_dt = "VARCHAR2".
      ELSE
          l_dt = "CHAR".
  END.  

  RUN prodict/gate/_gat_fnm.p
    ( INPUT        "FIELD",
      INPUT        rid,
      INPUT-OUTPUT pnam
    ).

  if not batch_mode then
    display
      fnam     @ msg[5]
      pnam     @ msg[6]
     with frame ds_make.
  
  find first ds_comments
    where ds_comments.obj# = ds_columns.obj#
    and   ds_comments.col# = ds_columns.sequence#
    no-lock no-error.
  
  assign
    dtyp    = LOOKUP(l_dt,user_env[12])
    l_init  = ?
    ntyp    = ( if dtyp > 0
                  then ENTRY(dtyp,user_env[15])
                  else "character"
              )
    l_dcml  = 0
    l_frmt  = "?".
  
  /*20040309-029
    Define the transaction here so if the code in gate/gat_pul2.i undoes
    the transaction, it only undoes the creation of this record. Everything else
    can remain the same.
  */
  DO TRANSACTION:
  
  CREATE s_ttb_fld.
  assign
    s_ttb_fld.pro_desc    = ( if not available ds_comments
                                or ds_comments.comment$ = ?
                                then ""
                                else ds_comments.comment$
                            )
    s_ttb_fld.pro_extnt   = nexts
    s_ttb_fld.pro_name    = pnam
    s_ttb_fld.ttb_tbl     = rid
    s_ttb_fld.ds_stoff    = stoff
    s_ttb_fld.ds_name     = fnam
    s_ttb_fld.ds_type     = l_dt
    s_ttb_fld.pro_init    = ds_columns.default$
    s_ttb_fld.pro_mand    = ( ds_columns.default# = ? )
    s_ttb_fld.pro_order   = ds_columns.sequence# * 10 + 1000
    s_ttb_fld.ds_prec     = ?
    s_ttb_fld.ds_scale    = ?
    s_ttb_fld.ds_lngth    = ( if ds_columns.length_ > 0
                                then ds_columns.length_
                                else 15
                            )
    s_ttb_fld.ds_itype    = ds_columns.type#.

  {prodict/gate/gat_pul2.i
    &undo      = "next"
    }

  /* this is just for ORACLE 9 and above */
  IF oraversion > 8 THEN
     ASSIGN s_ttb_fld.ds_msc25 = (IF ds_columns.charsetform = 2 THEN '1' ELSE ?).

  /* fix the format for logical if it is an empty string */
  IF CAN-DO(l_logi-types,s_ttb_fld.ds_type) THEN
      IF s_ttb_fld.pro_frmt = ""  THEN
         s_ttb_fld.pro_frmt = "yes/no".

/* NOTE: ds_prec gets used differently with ORACLE procedures and
 *       functions
 */
  assign
    s_ttb_fld.ds_prec     = ( if ds_columns.in_out = ?
                                then 1 
                                else ds_columns.in_out + 1
                            ).
/*
  { prodict/ora/ora_mak1.i
    &data-type = "c"
    &file-name = "oracle_arguments"
    &undo      = "LEAVE"
    }
*/
    
  if s_ttb_fld.ds_prec = 2
   then assign s_ttb_fld.pro_mand = no.  /* output only argument */  

  /* Mark pseudo-function-argument that represent the return value */

  if   o-type               = "FUNCTION" 
   and ds_columns.sequence# = 1
   then s_ttb_fld.ds_prec = s_ttb_fld.ds_prec + 8.

  assign stoff = stoff + (if nexts > 0 then nexts else 1).

  END. /* end transaction */

  end.     /* for each ds_columns */

  
if not batch_mode then
    hide frame ds_make no-pause.

RETURN.

/*------------------------------------------------------------------*/
