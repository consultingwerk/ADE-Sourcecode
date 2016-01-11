/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

file: prodict/gate/gat_pul.i

description:
    pulls schemainfo of all objects contained in gate-work into
    the temp-tables

    <DS>_get.p gets a list of all pullable objects from the foreign DB
    <DS>_pul.p pulled over the definition from the foreign side
    gat_cmp.p  compared the existing definitions with the pulled info
    gat_cro.p  replaces the existing definitions with the pulled info
               or creates the new object if it didn't already exist

    create <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Update <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Verify <DS> Schema: <DS>_get.p <DS>_pul.p gat_cmp.p gat_cro.p

Text-Parameters:
    &buffer
    &col-fields     additional fields for the fields-phrase for
                    ds_columns
    &colid          ds-field containing the Column-Id
    &comment        ds-field containing the comment-text
    &dbtyp          {"ora"|"syb"}
    &db-type        {"oracle"|"sybase"}
    &ds_recid       phrase for the ds_recid field (db-field, constant,
                    variable ...)
    &for-idx-name   name of the name-field (for example:
                    sybase_objects.name + STRING(indn))
    &for-idx-nam2   ev. 2 possible name of the name-field (for example:
                    sybase_objects.name + STRING(w_index.pro_idx-num))
    &for-obj-name   name of the name-field (sybase_objects.name, ...)
    &idx-fields     additional fields for the fields-phrase for
                    ds_indexes
    &idx-tbl-break  break by phrase for ds_objects of ds_indexes
    &idx-uniq-cond  condition for uniqueness of an index 
    &idx-where      condition for ds_indexes 
    &idxid          ds-field containing the Index-Id
    &init           phrase for initial field
    &length         ds-field containing the length
    &mand           condition for mandatory-field
    &msc23          "{&msc23}"
    &name           ds-field containing the name
    &objid          ds-field containing the Object-Id
    &precision      ds-field containing the Precision
    &radix          ds-field containing the Radix
    &scale          ds-field containing the Scale
    &type           ds-field containing the type
    &typvar         type-name if NOT buffer
    &typvar-b       type-name if buffer
    &usrid          ds-field containing the user-id 
    &usrid-t        ds_objects-field containing the user-id
    
Input:
    &DS_DEBUG   DEBUG to protocol the creation
                ""    to turn off protocol
    gate-work   shared temp-table that contains all the objects to pull

Output:
    s_ttb_tbl   table-information of all objects
    s_ttb_fld   field-information of all objects
    s_ttb_idx   index-information of all objects
    s_ttb_idf   index-field-information of all objects
    s_ttb_seq   sequence-information of all objects

Included in:
    ora/_ora_pul.p
    syb/syb_getp.i

History:
    hutegger    95/03   created out of ora67mak.i and syb_makp.i
    mcmann      02/22/99  Added check for progress recid 
    mcmann      11/15/99  Removed adding of time to index and checking for
                          progress recid index name = table name
    mcmann      03/20/01  Added decending index support for 8i Oracle
    mcmann      04/11/01  Added closed stored proc for send sql 
    mcmann      07/05/01  Added DICTDBG on stored proc finds
    mcmann      07/08/02  DESC index fixes 20020702013,20020703006, 20020622001
    mcmann      07/10/02  Support for UPPER function indexes
    mcmann      07/18/02  20020718-043 shadow col fields being marked sensitive
    mcmann      09/30/02  Added logic for synonmyns of procedures in packages
    mcmann      05/13/03  Removed CLOB and CFILE from Oracle information
    mcmann      11/05/03  Removed check on index name = table name 20031105-020
    fernando    06/12/06  Support for large sequences
    fernando    06/11/07  Unicode and clob support
    fernando    04/07/08  Datetime support for ORACLE
    ashukla     07/08/08  LDAP support (CR#OE00172458)
    knavneet    08/14/08  OE00170417 - Quoting object names if it has special chars.
    kmayur      06/21/11  Added support for Oracle constraint pull - OE00195067
*/

/*
relevant header-comments from syb_mak.p:
----------------------------------------

History
    hutegger    95/01/26    changed schmea-triggers to internal procs
    hutegger    94/11/02    creation
*/
/*h-*/

/*    &DS_DEBUG   DEBUG to protocol the creation    */
/*                ""    to turn off protocol        */
&SCOPED-DEFINE DS_DEBUG   XXDEBUG

&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/{&dbtyp}/{&dbtyp}_ctl.i 7 }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

&IF "{&db-type}" = "sybase"
 &THEN 
&GLOBAL-DEFINE shdw-prefix U##
  define variable l_keycp       as integer   no-undo. 
  define variable l_keyid       as integer   no-undo. 
  define variable typevar       as character no-undo.
&ELSEIF "{&db-type}" = "oracle"
 &THEN 
&GLOBAL-DEFINE shdw-prefix U##
  define variable typevar       as integer   no-undo.

DEFINE TEMP-TABLE ds-field-attributes
       FIELD f_name AS CHAR
       FIELD f_length AS INT
       INDEX f_name f_name.

DEFINE VARIABLE tth         AS HANDLE NO-UNDO.

 &ELSE  /* ODBC */ 
&GLOBAL-DEFINE shdw-prefix _S#_
 &ENDIF
define variable array_name      as character no-undo. 
define variable batch-mode      as logical   no-undo initial false. 
define variable dtyp            as integer   no-undo.
define variable fnam            as character no-undo.
define variable i               as integer   no-undo.
define variable indn            as integer   no-undo.
define variable l_char-types    as character no-undo.
define variable l_chrw-types    as character no-undo.
define variable l_date-types    as character no-undo.
define variable l_dcml          as integer   no-undo.
define variable l_dcml-types    as character no-undo.
define variable l_dt            as character no-undo.
define variable l_fld-descr     as character no-undo.
define variable l_fld-msc24     as character no-undo init ?.
define variable l_fld-pos       as integer   no-undo.
define variable l_floa-types    as character no-undo.
define variable l_frmt          as character no-undo.
define variable l_i#dl-types    as character no-undo.
define variable l_i##d-types    as character no-undo.
define variable l_i##l-types    as character no-undo.
define variable l_i###-types    as character no-undo.
define variable l_init          as character no-undo. 
define variable l_link          as character no-undo.
define variable l_logi-types    as character no-undo.
define variable l_prec          as integer   no-undo.
define variable l_scale         as integer   no-undo.
define variable l_time-types    as character no-undo.
define variable l_tmst-types    as character no-undo.
define variable m1              as integer   no-undo.
define variable m2              as integer   no-undo. 
define variable msg             as character no-undo   EXTENT 8.
define variable namevar         as character no-undo {&case-sensitive}.
define variable namevar-s       as character no-undo. /* synonym */
define variable ntyp            as character no-undo.
define variable onum            as integer   no-undo.
define variable pnam            as character no-undo.
define variable progvar         as character no-undo.
DEFINE VARIABLE s               AS CHARACTER NO-UNDO.
DEFINE VARIABLE tdbtype         AS CHARACTER NO-UNDO.
DEFINE VARIABLE oraversion      AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_tmp           AS CHARACTER NO-UNDO INIT ?.

/*define variable shadow_col    as character no-undo.*/
define variable spclvar         as character no-undo.
define variable typevar-s       as character no-undo. /* synonym */
define variable unique-prime    as logical   no-undo. /* upi already found */
define variable uservar         as character no-undo.


/* define variables for getting real field for function indexes*/
DEFINE VARIABLE didx-name       AS CHARACTER              NO-UNDO.
DEFINE VARIABLE didx-pos        AS INTEGER FORMAT "99999" NO-UNDO.
DEFINE VARIABLE didx-col#       AS INTEGER                NO-UNDO.
DEFINE VARIABLE col-num         AS INTEGER                NO-UNDO.
DEFINE VARIABLE dsname          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE isasc           AS LOGICAL                NO-UNDO.
DEFINE VARIABLE upperfld        AS LOGICAL                NO-UNDO.
DEFINE VARIABLE col-property	AS INTEGER                NO-UNDO.
DEFINE VARIABLE nls_upp         AS CHARACTER              NO-UNDO.

/* OE00170417 */
FUNCTION scanSplCharacter RETURN INTEGER (INPUT name as CHARACTER)  FORWARD.
/*------------------------------------------------------------------*/

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/

form
                                                        skip(1)
  msg[1]        format "x(25)" label "Table"    colon 11 
        "->"
        msg[2]  format "x(25)" label "Table"            skip
  msg[3]        format "x(25)" label "Column"   colon 11 
        "->"
        msg[4]  format "x(25)" label "Field"            skip
  msg[5]        format "x(25)" label "Key"      colon 11 
        "->"
        msg[6]  format "x(25)" label "Index"            skip
  msg[7]        format "x(25)" label "Sequence" colon 11 
        "->"
        msg[8]  format "x(25)" label "Sequence"         skip
  skip(1)
 with row 4 centered THREE-D
  overlay side-labels attr-space
&IF "{&db-type}" = "sybase"
 &THEN 
  title " Loading SYBASE Definitions " use-text
 &ELSE 
  title " Loading ORACLE Definitions " + l_link use-text
 &ENDIF
  frame ds_make.
  
/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/


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
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

/*------------------------ INITIALIZATIONS -------------------------*/

RUN adecomm/_setcurs.p ("WAIT").

/** / message "gat_pul.i DS_DEBUG {&DS_DEBUG} " view-as alert-box. / **/

/**/ &IF "{&DS_DEBUG} " = "DEBUG"
/**/ &THEN
/**/  message "gat_pul.i" view-as alert-box.
/**/  run error_handling(5, "*****----- BEGIN gat_pul.i!!! -----*****" ,"").
/**/
/**/  output stream s_stm_errors to gate-work.d.
/**/  for each gate-work no-lock: 
/**/    display stream s_stm_errors gate-work with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/    output to s_ttb_link.d3.
/**/    for each s_ttb_link:
/**/      display
/**/        slctd srchd level
/**/        "*" + master + "*" + s_ttb_link.name + "*" format "x(20)"
/**/        with side-labels frame a.
/**/      for each gate-work
/**/        where gate-work.gate-qual = ( if s_ttb_link.master + s_ttb_link.name = ""
/**/                            then ?
/**/                            else s_ttb_link.master + s_ttb_link.name
/**/                                    ):
/**/        display
/**/          gate-slct label "slct"
/**/          gate-flag label "flg"
/**/          gate-name format "x(20)"
/**/          gate-prog format "x(20)"
/**/          gate-qual format "x(20)"
/**/          gate-type format "x(9)"
/**/          gate-user format "x(9)"
/**/          with down frame b width 100.
/**/        end.  /* for each gate-work */
/**/      end.  /* for each s_ttb_link */
/**/    output close.
/**/ &ENDIF
/**/

&IF "{&db-type}" = "oracle"
 &THEN 
  
  find first s_ttb_link
    where s_ttb_link.slctd  = TRUE /*actually redundant, but what the heck...*/
    and   s_ttb_link.level  = s_level
    and   s_ttb_link.master = s_master
    and   s_ttb_link.name   = s_lnkname
    no-error.
  if not available s_ttb_link
   then do:  /* should actually never happen */
    assign user_path = "*C,_ora_lkx". /* clean-up */
    leave.
    end.     /* should actually never happen */

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
 &ENDIF
  
assign
  cache_dirty      = TRUE
  l_dt             = ?
  batch-mode       = SESSION:BATCH-MODE
&IF "{&db-type}" = "sybase"
 &THEN
  l_char-types     = "CHAR,BINARY,IMAGE,SYSNAME,TEXT,TIMESTAMP,VARCHAR,VARBINARY"
  l_chrw-types     = " "
  l_date-types     = "DATETIME,DATETIMEN,DATETIME4"
  l_dcml-types     = "MONEY,MONEYN,MONEY4,REAL,FLOAT,FLOATN"
  l_floa-types     = ""
  l_i#dl-types     = ""
  l_i##d-types     = ""
  l_i##l-types     = ""
  l_i###-types     = "INT,INTN,SMALLINT,TIME,TIME4,TINYINT"
  l_logi-types     = "BIT"
/*l_time-types     = "" */
  l_tmst-types     = ""
  user_env         = "". /* yes this is destructive, but we need the -l space */
&ELSEIF "{&db-type}" = "oracle"
 &THEN 
  l_char-types     = "CHAR,VARCHAR,VARCHAR2,ROWID,NVARCHAR2,NCHAR"
  l_chrw-types     = "LONG,RAW,LONGRAW,BLOB,BFILE,CLOB,NCLOB"
  l_date-types     = "DATE"
  l_dcml-types     = "NUMBER"
  l_floa-types     = "FLOAT"
  l_i#dl-types     = ""
  l_i##d-types     = ""
  l_i##l-types     = ""
  l_i###-types     = "TIME"
  l_logi-types     = "LOGICAL"
  l_tmst-types     = "TIMESTAMP,TIMESTAMP_LOCAL,TIMESTAMP_TZ"
  l_link           = user_env[25]
  user_env         = "" /* yes this is destructive, but we need the -l space */
  user_env[25]     = l_link
  l_link           = s_ttb_link.master + s_ttb_link.name
  tdbtype          = "ora"
  s_ttb_link.srchd = TRUE.
 &ENDIF
  

if NOT batch-mode 
 then do:
  assign SESSION:IMMEDIATE-DISPLAY = yes.
  view frame ds_make.
  end.

&IF "{&db-type}" = "oracle" &THEN
  /* this is for supporting datetime as default for an ORACLE date field */
  ASSIGN l_tmp  = (if s_datetime then "datetime_default" else ?).
&ENDIF

RUN prodict/{&dbtyp}/_{&dbtyp}_typ.p
  ( INPUT-OUTPUT i,
    INPUT-OUTPUT i,
    INPUT-OUTPUT l_tmp,
    INPUT-OUTPUT l_dt,
    OUTPUT       l_dt
    ). /* fills user_env[11..17] with datatype-info */



/*---------------------------- MAIN-LOOP ---------------------------*/
_crtloop:
for each gate-work
  where gate-work.gate-slct = TRUE:
 
  /* Skip pseudo-entry, which is needed to signal, if user wants to 
   * compare not just <DS> -> PROGRESS, but also the other direction
   */
  if gate-work.gate-type = "PROGRESS" then next.

  &if "{&db-type}" = "oracle" &then
  /* skip ORACLE-entries for remote-db if current db is the local one
   * and vice versa
   */
    assign
      spclvar = ( if gate-work.gate-type = "SYNONYM"
                  and num-entries(gate-work.gate-edit,":") = 4
                  then entry(4,gate-work.gate-edit,":")
                else if gate-work.gate-qual <> ?
                  then gate-work.gate-qual
                  else  ""
              ).
    if l_link <> spclvar
     then next.
  &endif

  assign
    namevar   = ( if gate-work.gate-type = "SYNONYM"
                   then entry(2,gate-work.gate-edit,":")
                   else gate-work.gate-name
                )
    namevar   = TRIM( if gate-work.gate-type = "BUFFER"
                   then {&buffer} + gate-work.gate-type
                      + "_"       + namevar
                   else             namevar
                )
    namevar-s = ( if gate-work.gate-type = "SYNONYM"
                   then gate-work.gate-name
                   else namevar
                )                   /* name of the synonym */
    typevar-s = ( if gate-work.gate-type = "SYNONYM"
                   then entry(3,gate-work.gate-edit,":")
                   else gate-work.gate-type
                )
    typevar   = ( if typevar-s = "BUFFER"
                   then {&typvar-b}
                        /*       "VIEW"                             |
                         *       LOOKUP("VIEW" ,oobjects) - 1       */
                   else {&typvar}
                        /* ENTRY(LOOKUP(typevar-s,pobjects),sobjects) |
                         *       LOOKUP(typevar-s,oobjects) - 1       */
                )
    uservar   = ( if gate-work.gate-type = "SYNONYM"
                   then entry(1,gate-work.gate-edit,":")
                   else gate-work.gate-user
                )
    progvar   = gate-work.gate-prog
    spclvar   = gate-work.gate-qual
    .

  if SESSION:BATCH-MODE and logfile_open
   then put STREAM logfile unformatted
    gate-work.gate-type at 16
    gate-work.gate-user at 32
    gate-work.gate-name at 45 skip.

  FOR first ds_users
    where ds_users.name = uservar
    no-lock.
    /* to leave the record in scope after leaving this block */
    LEAVE.
  END.

  case typevar-s:

/*-------------------------- SEQUENCES -----------------------------*/

    when    "SEQUENCE" then do:

      if TERMINAL <> "" and NOT batch-mode
       then DISPLAY 
          ""      @ msg[1]   ""       @ msg[5]
          ""      @ msg[2]   ""       @ msg[6]
          ""      @ msg[3]   namevar  @ msg[7]
          ""      @ msg[4]   progvar  @ msg[8]
          with frame ds_make.

      ASSIGN s = progvar.
      IF SESSION:SCHEMA-CHANGE = "new objects"  THEN 
      DO i = 1 TO 9999 WHILE can-find(FIRST s_ttb_seq
                       where s_ttb_seq.pro_name = progvar)
                       OR CAN-FIND(FIRST DICTDB._Sequence
                       WHERE DICTDB._Sequence._db-recid = drec_db
                         AND DICTDB._Sequence._Seq-name = progvar
                         AND DICTDB._Sequence._Seq-misc[2] <> uservar ) :
        progvar = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") 
                  + STRING(- i).
      end.
     
       create s_ttb_seq.

      &if "{&db-type}" = "oracle" &then
        for each ds_objects where ds_objects.name = namevar
                              and ds_objects.{&usrid-t}  = ds_users.{&usrid}
                              no-lock:
            if ds_objects.type = typevar then leave.
        end.

        if not available ds_objects then next.

        FIND first ds_sequences where ds_sequences.obj#  = ds_objects.obj#
          NO-LOCK.
  

        assign
          s_ttb_seq.ds_incr  =   ds_sequences.increment$
          s_ttb_seq.ds_max   = ( if ds_sequences.maxvalue > (IF is-pre-101b-db THEN 2147483647 ELSE 9223372036854775807)
                                    then ?
                                    else ds_sequences.maxvalue
                               )
          s_ttb_seq.ds_min   =   ds_sequences.minvalue
          s_ttb_seq.ds_cycle = ( ds_sequences.increment$ = 1 )
          .
      &endif

      if gate-work.gate-type = "SYNONYM"
       then assign
        gate-work.ttb-recid = RECID(s_ttb_seq)
        s_ttb_seq.ds_name   = namevar-s
        s_ttb_seq.ds_user   = ""
        s_ttb_seq.ds_spcl   = spclvar
        s_ttb_seq.gate-work = RECID(gate-work)
        s_ttb_seq.pro_name  = progvar.
       else assign
        gate-work.ttb-recid = RECID(s_ttb_seq)
        s_ttb_seq.ds_name   = namevar /* used to be progvar, but:
                                       * progvar could be <> namevar
                                       * in case of name-collisions */
        s_ttb_seq.ds_user   = uservar
        s_ttb_seq.ds_spcl   = spclvar
        s_ttb_seq.gate-work = RECID(gate-work)
        s_ttb_seq.pro_name  = progvar.

      NEXT.
    end.

/*--------------------------- PROCEDURES ---------------------------*/

    when    "PROCEDURE"
    or when "FUNCTION"
    or when "PACKAGE" then do:
      if user_dbtype = "ORACLE"
       then do:
        RUN prodict/ora/_ora_prc.p
          (INPUT  typevar,
           INPUT  namevar,
           INPUT  namevar-s,
           INPUT  uservar,
           INPUT  progvar,
           INPUT  spclvar,
           INPUT  RECID(gate-work),
           OUTPUT gate-work.ttb-recid
          ).
        /* synonym    : namevar   = name of base-object
         *              namevar-s = name of synonym
         * non-synonym: namevar   = namevar-s = name of object
         */
        if   gate-work.gate-type = "SYNONYM"
         then do:  /* adjust synonym-object(s) */

          if gate-work.ttb-recid = ?
           then do:  /* package */
            for each s_ttb_tbl
              where s_ttb_tbl.ds_msc21 = namevar:
              assign
                s_ttb_tbl.ds_msc21 = namevar-s
                s_ttb_tbl.ds_user  = "".
              end.     /* for each s_ttb_tbl */
            end.     /* package */
           ELSE IF typevar = 9 THEN DO: /* synonym for package but a procedure */
             find first s_ttb_tbl
              where recid(s_ttb_tbl) = gate-work.ttb-recid
              no-error.
             if available s_ttb_tbl then 
                 ASSIGN s_ttb_tbl.ds_msc21 = namevar-s 
                        s_ttb_tbl.ds_user = "".              
           END.
           else do:  /* procedure or function */
            find first s_ttb_tbl
              where recid(s_ttb_tbl) = gate-work.ttb-recid
              no-error.
           if available s_ttb_tbl
             then assign
              s_ttb_tbl.ds_name = namevar-s
              s_ttb_tbl.ds_user = "".
            end.     /* procedure of function */

          end.     /* adjust synonym-object */

        NEXT.
        end.
      else if user_dbtype <> "SYBASE"
       then NEXT.
    end.

  end case.
    

/*----------------------------- TABLES -----------------------------*/

  /* remaining typevars values: "TABLE", "VIEW", "BUFFER" */

  if TERMINAL <> "" and NOT batch-mode
   then DISPLAY
      namevar @ msg[1]  "" @ msg[5]
      progvar @ msg[2]  "" @ msg[6]
      ""      @ msg[3]  "" @ msg[7]
      ""      @ msg[4]  "" @ msg[8]
      with frame ds_make.

  for each ds_objects
    where ds_objects.name        = namevar
  /*  and   ds_objects.type        = typevar */
    and   ds_objects.{&usrid-t}  = ds_users.{&usrid}
    no-lock:
    
    if ds_objects.type = typevar then leave.
  end.  

  if not available ds_objects
   then next.

  assign
    onum = ds_objects.{&objid}.

  find first ds_comments
    where ds_comments.{&objid} = onum
    and   ds_comments.{&colid} = {&colid-t-cmnt}
    no-lock no-error.

  create s_ttb_tbl.

  assign
    gate-work.ttb-recid = RECID(s_ttb_tbl)
    s_ttb_tbl.ds_name   = namevar
    s_ttb_tbl.ds_recid  = 0
    s_ttb_tbl.ds_spcl   = spclvar
    s_ttb_tbl.ds_type   = typevar-s
    s_ttb_tbl.ds_user   = uservar
    s_ttb_tbl.gate-work = RECID(gate-work)
    s_ttb_tbl.pro_desc  = ( if available ds_comments
                             then ds_comments.{&comment}
                             else s_ttb_tbl.pro_desc
                          )                               
    s_ttb_tbl.pro_name  = progvar.
    
  /*s_ttb_tbl._Dump-name fields all assigned at end of procedure*/
  /*s_ttb_tbl._Prime-Index*/ /* this field is assigned later */


/*---------------------------- FIELDS ------------------------------*/

  assign
 /* shadow_col = "" */
    array_name = "".

  &IF "{&db-type}" = "oracle"
   &THEN
      /* this is only used for ORACLE */
      EMPTY TEMP-TABLE ds-field-attributes NO-ERROR.
      /* reset this since we use inside the loop below to know when run stored-proc */
      ASSIGN tth = ?.
  &ENDIF

  for each ds_columns
    fields ({&objid} {&colid} name {&type} {&col-fields})
    where ds_columns.{&objid} = onum
    no-lock
    by    ds_columns.{&colid}:

  if (NOT ds_columns.name begins "PROGRESS_RECID_UNIQUE" ) AND
       (ds_columns.name begins "PROGRESS_RECID" OR 
        ds_columns.name begins "_PROGRESS_RECID" OR
        ds_columns.name begins "_PROGRESS_ROWID" ) then do:
      IF s_ttb_tbl.ds_recid = 0 THEN 
        assign s_ttb_tbl.ds_recid = ds_columns.{&colid}.
      NEXT.
    end.
  
    if   length(array_name,"character")  >   0
     and ds_columns.name BEGINS array_name
     then NEXT.

    if ds_columns.name BEGINS "U##"
     then do:
/*      assign shadow_col = string(ds_columns.{&colid}). */
      NEXT.
    end.

  &IF "{&db-type}" = "sybase"
   &THEN
    if ds_columns.name <> "timestamp"
     then do:
   &ENDIF
    
      { prodict/{&dbtyp}/{&dbtyp}_typ.i }
      assign m1 = 0.

  
  &IF "{&db-type}" = "oracle"
   &THEN

      IF oraversion < 9 THEN DO:
          /* NCHAR and NVARCHAR2 (Unicode Types) are only supported as such
             with Oracle 9 and up, otherwise, they will be treated as character.
            NCLOB continues to be unsupported in pre-Oracle 9.
          */
          IF (l_dt = "NVARCHAR2" OR l_dt = "NCHAR" OR l_dt = "NCLOB") THEN DO:
              IF l_dt = "NCLOB" THEN
                 l_dt = "UNDEFINED".
              ELSE 
                  l_dt = (IF l_dt = "NVARCHAR2" THEN "VARCHAR2" ELSE "CHAR").
          END.
      END.
      ELSE DO:
        IF tth = ? AND INDEX(l_dt,"CHAR") > 0 THEN DO:

            /* instead of adding a new table to the metaschema, let's just get the info we want for
            character fields. If this somehow fails, we just won't get it and that's fine
            since the RUN below has no-error. 
            */
            ASSIGN tth = TEMP-TABLE ds-field-attributes:HANDLE.

            RUN STORED-PROC DICTDBG.send-sql-statement LOAD-RESULT-INTO tth NO-ERROR
                            ("select name,nvl(spare3,0) from sys.col$ where obj# = "
                              + string(onum)).
        END.

      END.

      find first ds_comments
        where ds_comments.{&objid} = onum
        and   ds_comments.{&colid} = ds_columns.{&colid}
        no-lock no-error.
    
      assign l_fld-descr = ( if available ds_comments 
                                then ds_comments.{&comment}
                                else ""
                           ).

      if ds_columns.name MATCHES "*##1"
       then do:  /* collect array elements & determine extent */

        assign
          m1          = 1
          i           = length(ds_columns.name,"character") - 1
          array_name  = substring(ds_columns.name, 1, i,"character").

        for each ds_columns-2
          fields(name)
          where ds_columns-2.{&objid} = onum
          no-lock
          by    ds_columns-2.{&colid}:

  	     if NOT ds_columns-2.name BEGINS array_name
  	     then NEXT.  /* can't do in where */
	               /* since array_name may have an '_' in it. */

	    assign
	      m2 = INTEGER(substr(ds_columns-2.name,i + 1,-1,"character"))
	      m1 = ( if m2 > m1
	            then m2
	            else m1
	         ).

        end. /* for each ds_columns-2 */

      end.     /* collect array elements & determine extent */
  &ENDIF

  assign
        l_fld-pos = ( IF (ds_columns.{&colid} > 0 AND NOT ( "{&db-type}" = "oracle" AND 
                                                 ds_columns.NAME BEGINS "SYS_NC" )) THEN
                          ds_columns.{&colid}
                      ELSE (INTEGER(SUBSTRING(ds_columns.NAME, 7, 5))) * -1) .


      { prodict/gate/gat_pulf.i 
        &extent       = "m1"
        &init         = "{&init}"
        &length       = "{&Length}"
        &mand         = "{&mand}"
        &msc23        = "{&msc23}"
        &name         = "{&name}"
        &order-offset = "0"
        &precision    = "{&Precision}"
        &radix        = "{&Radix}"
        &scale        = "{&Scale}"
        }

   /*   if gate-work.gate-type = "BUFFER"
       then 
    */   
       ASSIGN s_ttb_fld.ds_itype = ds_columns.{&type}.

      &IF "{&db-type}" = "oracle" &THEN
          /* for ORACLE 9 and above, ds_msc25 will be "1" if this is a column
             of Unicode data type 
          */
          IF oraversion > 8 THEN
             ASSIGN s_ttb_fld.ds_msc25 = (IF ds_columns.charsetform = 2 THEN '1' ELSE ?).

          /* let's try to fix format for field that may gave been defined with character semantics */
          IF s_ttb_fld.pro_type = "character" THEN DO:
              FIND ds-field-attributes WHERE ds-field-attributes.f_name = ds_columns.name NO-ERROR.
              IF AVAILABLE ds-field-attributes AND
                 ds-field-attributes.f_length > 0 AND {&Length} NE ds-field-attributes.f_length THEN DO:
                 ASSIGN s_ttb_fld.pro_frmt  = "x(" + STRING(min(320,max(1,ds-field-attributes.f_length))) + ")"
                        /* we save away the character semantics size of the field */
                        s_ttb_fld.ds_allocated = ds-field-attributes.f_length.
              END.
          END.
      &ENDIF

      FOR first ds_columns-2
        where ds_columns-2.{&objid} = onum
        and   ds_columns-2.name  = "{&shdw-prefix}" + ds_columns.name
        no-lock.
      END.
      if available ds_columns-2
       then assign
        s_ttb_fld.ds_shd#  = ds_columns-2.{&colid}
        s_ttb_fld.ds_shdn  = string(s_ttb_fld.ds_shd#)
        s_ttb_fld.pro_case = FALSE
        .

  &IF "{&db-type}" = "sybase"
   &THEN 

      end.   /* each ds_columns */
    end.   /* each ds_columns */

  for each ds_columns 
    where  ds_columns.id = onum
    and   (ds_columns.type = 61
    or     ds_columns.type = 111
    or     ds_columns.type = 58)
    no-lock:
    assign
      l_fld-pos = ds_columns.{&colid}
      l_dt      = ( if    ds_columns.type = 58 
                     or ( ds_columns.type = 111
                     and  ds_columns.syb_length = 4 )
                     then "TIME4" 
                     else "TIME"
                   ).
    { prodict/gate/gat_pulf.i 
        &extent       = "m1"
        &init         = "{&init}"
        &length       = "{&Length}"
        &mand         = "{&mand}"
        &msc23        = "{&msc23}"
        &name         = "{&name}"
        &order-offset = "5"
        &precision    = "{&Precision}"
        &radix        = "{&Radix}"
        &scale        = "{&Scale}"
        }

  &ELSEIF "{&db-type}" = "oracle"
   &THEN 

    /* if not verify and defaulting to datetime, skip this */
    if l_dt = "DATE" AND (s_vrfy OR NOT s_datetime)
     then do:  /* Add time fields */
      assign l_dt = "TIME".
      { prodict/gate/gat_pulf.i 
        &extent       = "m1"
        &init         = "{&init}"
        &length       = "{&Length}"
        &mand         = "{&mand}"
        &msc23        = "{&msc23}"
        &name         = "{&name}"
        &order-offset = "5"
        &precision    = "{&Precision}"
        &radix        = "{&Radix}"
        &scale        = "{&Scale}"
        }
      end.     /* Add time fields */
   &ENDIF
   
    end.   /* each ds_columns */
   
/*---------------------------- CONSTRAINTS -----------------------------*/

   FOR EACH ds_cons WHERE ds_cons.OBJ# = onum:
     FIND FIRST ds_constraint WHERE ds_constraint.CON# = ds_cons.CON# no-lock no-error. 
    
     FOR EACH ds_cons-fld WHERE ds_cons-fld.CON# = ds_cons.CON#:
      
       FOR EACH ds_columns
       WHERE ds_columns.{&objid} = onum AND ds_columns.{&colid} = ds_cons-fld.COL#:
    
       CREATE s_ttb_con.
       ASSIGN tab_name   = namevar
           col_name   = ds_columns.NAME
           const_name = ds_constraint.name
           par_key_num= ds_cons.RCON#
           expre      = ds_cons.condition
           index_num  = ds_cons.enabled.
       IF ds_cons.TYPE# = 1 
           THEN cons_type = "C".
       ELSE IF ds_cons.TYPE# = 2
           THEN cons_type = "PRIMARY KEY".         
       ELSE IF ds_cons.TYPE# = 3
           THEN cons_type = "UNIQUE".
       ELSE IF ds_cons.TYPE# = 4
           THEN cons_type = "FOREIGN KEY".    
       IF par_key_num <> ? THEN
           FIND FIRST ds_constraint-2 WHERE ds_constraint-2.CON# = par_key_num NO-LOCK NO-ERROR.
             IF AVAILABLE ds_constraint-2 THEN ASSIGN par_key = ds_constraint-2.NAME.
           FIND FIRST ds_objects WHERE ds_objects.OBJ# = index_num NO-LOCK NO-ERROR.
             IF AVAILABLE ds_objects 
             THEN DO:  
             assign user_env[1] = TRIM(ds_objects.NAME).
             IF INDEX(user_env[1],"##") > 0 THEN
                  ASSIGN i = INDEX(user_env[1], "##") + 2.
             ELSE IF INDEX(user_env[1],"__") > 0 THEN
                  ASSIGN i = INDEX(user_env[1], "__") + 2.  
             ELSE
                  i = 1.   
    
             user_env[1]        = substring(user_env[1],i,-1,"character").
             ASSIGN index_name = user_env[1].
             END.     
       END.
     END.   
   END.  
   
/*---------------------------- INDEXES -----------------------------*/

  assign 
    indn         = 1
    unique-prime = no.

  for each ds_indexes
      fields({&idx-fields})
      where ds_indexes.{&idxid} = onum
      {&idx-where} NO-LOCK:
    FOR each ds_objects-2
      fields({&objid} name)
      where ds_objects-2.{&objid} = ds_indexes.{&objid}     
      NO-LOCK {&idx-tbl-break}:
  
    /* skip PROGRESS_RECID index */
      if ds_objects-2.name MATCHES "*##progress_recid" OR
         ds_objects-2.name MATCHES "*##_PROGRESS_RECID" OR
         ds_objects-2.name MATCHES "*##_PROGRESS_ROWID" 
         then NEXT.

      /* OE00210415: Modified the code to remove the restriction of pulling index object name begins with "SYS_" for oracle dataserver */
       if ds_objects-2.NAME BEGINS "SYS_" AND NOT "{&db-type}" = "oracle"  THEN NEXT. 


      {prodict/gate/gat_puli.i
        &for-idx-name = "{&for-idx-name}"
        &for-idx-nam2 = "{&for-idx-nam2}"
        &for-obj-name = "{&for-obj-name}"
        &frame        = "ds_make"
        &idx-uniq-cond = "{&idx-uniq-cond}"
      }                                  /* try to recreate index */



/*-------------------------- INDEX-FIELDS --------------------------*/

      &IF "{&db-type}" = "sybase" &THEN 
        repeat l_keycp = 1 to 8:

          if l_keycp = 1 THEN l_keyid = ds_indexes.key1.
          else if l_keycp = 2 THEN l_keyid = ds_indexes.key2.
          else if l_keycp = 3 THEN l_keyid = ds_indexes.key3.
          else if l_keycp = 4 THEN l_keyid = ds_indexes.key4.
          else if l_keycp = 5 THEN l_keyid = ds_indexes.key5.
          else if l_keycp = 6 THEN l_keyid = ds_indexes.key6.
          else if l_keycp = 7 THEN l_keyid = ds_indexes.key7.
          else if l_keycp = 8 THEN l_keyid = ds_indexes.key8.

          if l_keyid <> ? then do: /* index-component */
            find first s_ttb_fld where s_ttb_fld.ttb_tbl  = RECID(s_ttb_tbl)
                                   and s_ttb_fld.ds_stoff = l_keyid
                                   no-error.

            if not available s_ttb_fld then do:  /* was PROGRESS_RECID or shadow column */
                   /* Try to find 'real' column           */
              find first s_ttb_fld where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
                                     and s_ttb_fld.ds_shd# = l_keyid
                                     no-error.
              if not available s_ttb_fld then next.
            end.     /* was PROGRESS_RECID or shadow column */
                   /* Try to find 'real' column           */
                   
            create s_ttb_idf.
            ASSIGN s_ttb_idf.pro_abbr  = FALSE
                   s_ttb_idf.pro_asc   = TRUE
                   s_ttb_idf.pro_order = l_keycp
                   s_ttb_idf.ttb_fld   = RECID(s_ttb_fld)
                   s_ttb_idf.ttb_idx   = RECID(s_ttb_idx).

          end.     /* index-component */
        
        end.     /* repeat l_keycp = 1 to 8 */
    
      &ELSEIF "{&db-type}" = "oracle" &THEN 
        assign nls_upp = user_env[40].
        assign i = 0.   /* i := number of date-time fields */
        for each ds_idx-cols fields({&objid} {&colid} pos#)
           where ds_idx-cols.{&objid} = ds_indexes.{&objid}
           no-lock
           by ds_idx-cols.pos# /*{&colid}*//**/:

          if i + ds_idx-cols.pos# > 16 then do:  /* too many index-fields */
            run error_handling(4, 
                               string(s_ttb_idx.ds_name), 
                               string(ds_idx-cols.{&colid})
                              ).
            next.
          end.     /* too many index-fields */    

          if s_ttb_tbl.ds_recid = ds_idx-cols.{&colid} AND
             s_ttb_tbl.ds_recid <> 0  then next.  /* progress_recid */

          IF ds_idx-cols.{&colid} = 0 THEN DO: 
            RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE
                ( "select pos#, intcol# from sys.icol$ where obj# = " + string(ds_indexes.{&objid}) ).
            FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = h1:
              ASSIGN didx-pos =  INTEGER(SUBSTRING(proc-text, 1 ,25)) .
              IF didx-pos = ds_idx-cols.pos# THEN DO:
                ASSIGN didx-col# = INTEGER(SUBSTRING(proc-text, 26 ,25))
                       col-num = didx-col#.
                find first s_ttb_fld where s_ttb_fld.ttb_tbl =  RECID(s_ttb_tbl)
                                 and s_ttb_fld.ds_stoff =  (didx-col# * -1)
                                 and s_ttb_fld.ds_stdtype <> 7 * 4096 /* not of type TIME */
                                 no-error.

                IF AVAILABLE s_ttb_fld THEN DO:
                  ASSIGN dsname = s_ttb_fld.defaultname.
                  FIND FIRST DICTDBG.oracle_columns WHERE DICTDBG.oracle_columns.obj# = onum
                                                     AND DICTDBG.oracle_columns.NAME = s_ttb_fld.ds_name NO-ERROR.
                  IF AVAILABLE DICTDBG.oracle_columns  and nls_upp = "y" THEN
		     ASSIGN upperfld = (IF DICTDBG.oracle_columns.default$  BEGINS "NLS_UPPER" THEN TRUE
                                       ELSE FALSE).        
		  ELSE
		      ASSIGN upperfld = (IF DICTDBG.oracle_columns.default$  BEGINS "UPPER" THEN TRUE
                                       ELSE FALSE).

                  find first s_ttb_fld where s_ttb_fld.ttb_tbl =  RECID(s_ttb_tbl)
                                 and s_ttb_fld.ds_name =  dsname
                                 and s_ttb_fld.ds_stdtype <> 7 * 4096 /* not of type TIME */
                                 no-error.
                  IF AVAILABLE s_ttb_fld THEN 
                    ASSIGN didx-col# = s_ttb_fld.ds_stoff.      

                END.
                LEAVE.
              END.
            END.
            CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h1.

            RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE
              ( "select property from sys.col$ where obj# = " + STRING(onum) + " and intcol# = " + STRING(col-num) ).
            FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = h1:
              col-property = INTEGER(TRIM(proc-text)).
              IF col-property = ? THEN
                col-property = 0.
              IF col-property >= 131072 AND GET-BITS(col-property, 18, 1) = 1 THEN
                ASSIGN isasc = FALSE.
              ELSE
                ASSIGN isasc = TRUE.
            END.
            CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h1.
          END.
          ELSE
            ASSIGN didx-col# = ds_idx-cols.{&colid}
                  isasc = TRUE
                  upperfld = FALSE.

          find first s_ttb_fld where s_ttb_fld.ttb_tbl =  RECID(s_ttb_tbl)
                                 and s_ttb_fld.ds_stoff =  didx-col#
                                 and s_ttb_fld.ds_stdtype <> 7 * 4096 /* not of type TIME */
                                 no-error.

          if not available s_ttb_fld then 
            find first s_ttb_fld where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
                                   and s_ttb_fld.ds_stoff = didx-col#
                                   no-error.
          if not available s_ttb_fld then 
            find first s_ttb_fld /* shadow-col */
                where s_ttb_fld.ttb_tbl    =  RECID(s_ttb_tbl)
                  and s_ttb_fld.ds_shd#    =  didx-col#
                  no-error.

          if not available s_ttb_fld then do:
            run error_handling(1, 
                               string(s_ttb_idx.ds_name), 
                               string(ds_idx-cols.{&colid})
                               ).
            next.
          end.

          create s_ttb_idf.
          ASSIGN s_ttb_idf.pro_abbr  = FALSE
                 s_ttb_idf.pro_asc   =isasc
                 s_ttb_idf.pro_order = ds_idx-cols.pos# + i
                 s_ttb_idf.ttb_fld   = RECID(s_ttb_fld)
                 s_ttb_idf.ttb_idx   = RECID(s_ttb_idx).

          IF s_ttb_fld.pro_type = "character" THEN
                 s_ttb_fld.pro_case  = (IF s_ttb_fld.pro_case THEN NOT upperfld
                                        ELSE s_ttb_fld.pro_case).   

        end.   /* for each ds_idx-cols */
    
        /* 20050203-022 - if we got here and the index has no fields, this could be the
           progress_recid index. If the table name is longer than 14 characters, upon
           migration, we define the table name as the index name (we don't add the
           ##progress_recid suffix). Therefore, if the index name matches the table name,
           delete it now just in case the user defined an index named the table name,
           so we don't screw up when running the adjust schema, by assigning the wrong
           foreign index name.
        */
        FIND FIRST s_ttb_idf WHERE s_ttb_idf.ttb_idx = RECID(s_ttb_idx) NO-ERROR.
        IF NOT AVAILABLE s_ttb_idf THEN DO:
            /* if the table name matches the index, and the index had no real fields,
               just delete it now
            */
            IF s_ttb_idx.ds_name = s_ttb_tbl.ds_name THEN DO:
                DELETE s_ttb_idx.
            END.
        END.    
      &ENDIF
  
    end. /* for ech ds_objects-2*/
  END.  /* for each ds_indexes */

&IF "{&db-type}" = "sybase"
 &THEN 

/*--------------- MANDATORY OF UNIQUE-INDEX COMPONENTS ---------------*/

/* check if all fields, part of unique-index, are mandatory and
 * eventually set mandatory to true
 */
  for each s_ttb_idx
    where s_ttb_idx.ttb_tbl  = RECID(s_ttb_tbl)
    and   s_ttb_idx.pro_uniq = TRUE:
    for each s_ttb_idf
      where s_ttb_idf.ttb_idx = RECID(s_ttb_idx):
      find first s_ttb_fld
        where /* s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
        and   */ RECID(s_ttb_fld)  = s_ttb_idf.ttb_fld
        no-error.
      if available s_ttb_fld
       and s_ttb_fld.pro_mand = FALSE
       then assign s_ttb_fld.pro_mand = TRUE.
      end.     /* for each s_ttb_idf */
    end.     /* for each s_ttb_idx */

&ELSEIF "{&db-type}" = "oracle"
 &THEN 

/*--------------------------- RECID-INDEX ----------------------------*/

/* We are looking for a mandatory integer-field with an unique index.
 * if the field isn't mandatory and/or its precision, scale is out of
 * range and/or the index isn't unique, then the field/index is only
 * user-selectable (= Level 2). That means, he ahs to make sure, that
 * his application provides the adaquate checks for what ever the schema
 * isn't restrictive enough.
 * Otherwise the field/index is automatically selectable (= Level 1).
 */
 
  if  s_ttb_tbl.ds_recid <= 0
   or s_ttb_tbl.ds_recid  = ?
   then do:  /* no progress_recid -> check indexes for ROWID usability */
    
    /* check all indexes and calculate their usability-level */
    for each s_ttb_idx
      where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
   /* and   s_ttb_idx.ds_name <> ""*/ :
    
      find first s_ttb_idf 
        where s_ttb_idf.ttb_idx = RECID(s_ttb_idx)
        no-error.
      if not available s_ttb_idf then NEXT.

      find first s_ttb_fld 
        where RECID(s_ttb_fld) = s_ttb_idf.ttb_fld.
      find next s_ttb_idf 
        where s_ttb_idf.ttb_idx = RECID(s_ttb_idx)
        no-error.
      if not available s_ttb_fld            /* no components at all   */
       or available s_ttb_idf               /* more than 1 components */
       or s_ttb_fld.ds_type <> "NUMBER" then NEXT. /* wrong data-type */
       
      /* index has for-name & only one numeric field -> user-selectable */
      assign
        s_ttb_idx.ds_msc21   = "u"
        s_ttb_idx.hlp_fstoff = s_ttb_fld.ds_stoff.

      if  s_ttb_idx.pro_uniq = FALSE
       or s_ttb_fld.pro_mand = FALSE then NEXT.
      
      find first ds_columns
        where ds_columns.{&objid} = onum
        and   ds_columns.name     = s_ttb_fld.ds_name
        no-lock no-error.
      if   NOT AVAILABLE ds_columns
       or  {&precision} >= 10
       or  {&scale}     >   0
       then NEXT.  /* not automatically selectable */
      
      /* index is automatically selectable */
      assign s_ttb_idx.ds_msc21 = "a".

      end. /* for each s_ttb_idx */

    /* select first "a" index */
    find first s_ttb_idx
      where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
      and s_ttb_idx.ds_msc21 = "a"
      no-error.
    if available s_ttb_idx
     then assign
        s_ttb_idx.ds_msc21 = "ra" 
        s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff * -1
        s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
     else assign
        s_ttb_tbl.ds_recid = ?
        s_ttb_tbl.ds_rowid = ?.
     
    end.     /* no progress_recid -> check indexes for ROWID usability */

  /* PROGRESS-RECID-field -> reset recid-info of all indexes */
   else for each s_ttb_idx
      where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
      assign s_ttb_idx.ds_msc21 = ?.
      end.

 &ENDIF


/* as last step we have to replace the synonyms' names and users */ 
  if gate-work.gate-type = "SYNONYM"
   then assign
     s_ttb_tbl.ds_name = namevar-s
     s_ttb_tbl.ds_user = "".


  end. /* for each gate-work */


&IF "{&db-type}" = "oracle"
 &THEN 

/* OE00170417:Quoting objects when they have special character *
 * CR#OE00170689: Quoting user when they have special char slash *
*/
for each s_ttb_tbl:
   if scanSplCharacter(s_ttb_tbl.ds_name) = 1 then
      s_ttb_tbl.ds_name = QUOTER(s_ttb_tbl.ds_name).
   if (INDEX(s_ttb_tbl.ds_user,'~\') > 0) then
      s_ttb_tbl.ds_user = QUOTER(s_ttb_tbl.ds_user).

   if s_ttb_tbl.ds_msc21 ne "" AND s_ttb_tbl.ds_msc21 ne ? and 
     LOOKUP(s_ttb_tbl.ds_msc21,"PROCEDURE,FUNCTION,PACKAGE") > 0 THEN DO:
           if scanSplCharacter(s_ttb_tbl.ds_msc21) = 1 then 
               s_ttb_tbl.ds_msc21 =QUOTER(s_ttb_tbl.ds_name).
           if (INDEX(s_ttb_tbl.ds_user,'~\') > 0) then
               s_ttb_tbl.ds_user =QUOTER(s_ttb_tbl.ds_user).
   end.
end.
 
for each s_ttb_fld:
   if scanSplCharacter(s_ttb_fld.ds_name) = 1 then
      s_ttb_fld.ds_name = QUOTER(s_ttb_fld.ds_name).
end.
 
for each s_ttb_idx:
   if scanSplCharacter(s_ttb_idx.ds_name) = 1 then
      s_ttb_idx.ds_name = QUOTER(s_ttb_idx.ds_name).
end.

for each s_ttb_seq:
   if scanSplCharacter(s_ttb_seq.ds_name) = 1 then
      s_ttb_seq.ds_name = QUOTER(s_ttb_seq.ds_name).
   if (INDEX(s_ttb_seq.ds_user,'~\') > 0) then
      s_ttb_seq.ds_user = QUOTER(s_ttb_seq.ds_user).
end.
/* END of Quoting code for OE00170417 / CR#OE00170689 */

/*--------------------- PREPARE FOR NEXT LINK  ---------------------*/

/* we are done with this link, lets do the next one (srchd = false)
 * if there aren't anymore, we continue to the next step, wich is pulling the
 * object-names into the gate-work temp-table
 */

find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.srchd  = FALSE
  no-lock no-error.
if not available s_ttb_link
 then      /* done with pulling objects             */
           /*   -> ev. compare and/or transfer them */
  assign user_path = "*C,"
                   + ( if user_env[25] = "compare"
                         then "_gat_cmp,"
                         else ""
                     )
                   + "_gat_cro,_ora_lkx". /* clean-up */

 else do:  /* pull objects from next selected link */

  assign
    s_level   = s_ttb_link.level
    s_master  = s_ttb_link.master
    s_lnkname = s_ttb_link.name.

  if connected(s_ldbname)
   then disconnect value(s_ldbname) /*no-error*/.

  do transaction:
    find first DICTDB._Db
      where DICTDB._Db._Db-name = s_ldbname
      and   DICTDB._Db._Db-type = "ORACLE".
    assign DICTDB._Db._Db-misc2[8] = s_master + s_ttb_link.name.
    end.     /* transaction */

  assign  user_path = "*C,_ora_lkc,_ora_pul".

  end.     /* pull objects from next selected link */
&ENDIF

  
/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/
/**/ message "gat_pul.i:  &ds_debug: {&DS_DEBUG}" view-as alert-box.
/**/
/**/ run error_handling(5, "*****----- END gat_pul.i!!! -----*****" ,"").
/**/
/**/  output stream s_stm_errors to gate-work.d.
/**/  for each gate-work no-lock: 
/**/    display stream s_stm_errors gate-work with stream-io width 255.
/**/    display  stream s_stm_errors gate-work.gate-edit format "x(30)".
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_tbl.d.
/**/  for each s_ttb_tbl no-lock: 
/**/    display stream s_stm_errors  
/**/      s_ttb_tbl.ds_msc13      format "zzzz9-"
/**/      s_ttb_tbl.ds_msc21      format "x(15)"
/**/      s_ttb_tbl.ds_msc22      format "x(15)"
/**/      s_ttb_tbl.ds_msc23      format "x(15)"
/**/      s_ttb_tbl.ds_msc24      format "x(15)"
/**/      s_ttb_tbl.ds_name       format "x(15)" skip
/**/      s_ttb_tbl.ds_recid      format "zzzz9-"
/**/      s_ttb_tbl.ds_rowid      format "zzzz9-"
/**/      s_ttb_tbl.ds_spcl       format "x(15)"
/**/      s_ttb_tbl.ds_type       format "x(15)"
/**/      s_ttb_tbl.ds_user       format "x(15)"
/**/      s_ttb_tbl.gate-work     format "zzzz9-"
/**/      s_ttb_tbl.pro_desc      format "x(15)" skip
/**/      s_ttb_tbl.pro_name      format "x(15)"
/**/      s_ttb_tbl.pro_prime-idx format "x(15)"
/**/      s_ttb_tbl.pro_recid     format "zzzz9-"
/**/      with stream-io width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_fld.d.
/**/  for each s_ttb_fld no-lock: 
/**/    display stream s_stm_errors 
/**/     RECID(s_ttb_fld) format "zzzzzz9" label "RECID"
/**/     s_ttb_fld.pro_name s_ttb_fld.ttb_tbl  s_ttb_fld.pro_type
/**/     s_ttb_fld.ds_prec  format "zzz9-" label "m11"
/**/     s_ttb_fld.ds_scale format "zzz9-" label "m12"
/**/     s_ttb_fld.ds_lngth format "zzz9-" label "m13"
/**/     s_ttb_fld.ds_radix format "zzz9-" label "m14"
/**/     s_ttb_fld.ds_msc23 s_ttb_fld.ds_msc24
/**/     s_ttb_fld.ds_shdn  s_ttb_fld.ds_shd# format "zzz9-" label "sh#"
/**/     s_ttb_fld.ds_name  s_ttb_fld.ds_stoff s_ttb_fld.ds_type
/**/     s_ttb_fld.ds_stdtype format "zzzz9-" label "std"
/**/     with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_fl1.d.
/**/  for each s_ttb_fld no-lock: 
/**/    display stream s_stm_errors 
/**/     RECID(s_ttb_fld) format "zzzzzz9" label "RECID"
/**/     s_ttb_fld.pro_name  s_ttb_fld.ttb_tbl   s_ttb_fld.pro_case
/**/     s_ttb_fld.pro_dcml  s_ttb_fld.pro_desc  s_ttb_fld.pro_extnt
/**/     s_ttb_fld.pro_frmt  s_ttb_fld.pro_init  s_ttb_fld.pro_mand
/**/     s_ttb_fld.pro_order s_ttb_fld.pro_type
/**/     with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_idx.d.
/**/  for each s_ttb_idx no-lock: 
/**/    display stream s_stm_errors 
/**/     RECID(s_ttb_idx)     format "zzzzzz9" label "RECID"
/**/     s_ttb_idx.pro_name s_ttb_idx.ttb_tbl 
/**/     s_ttb_idx.pro_prim s_ttb_idx.pro_actv 
/**/     s_ttb_idx.pro_uniq    
/**/     s_ttb_idx.pro_idx#   format "zzz9-"    label "ix#"
/**/     s_ttb_idx.ds_name    s_ttb_idx.ds_msc21
/**/     s_ttb_idx.hlp_dtype  format "zzzz9-"  label "dty#"
/**/     s_ttb_idx.hlp_fld#   format "zzz9-"    label "fld#"
/**/     s_ttb_idx.hlp_fstoff format "zzz9-"    label "fst#"
/**/     s_ttb_idx.hlp_level  format "9"       label "L"
/**/     s_ttb_idx.hlp_mand   s_ttb_idx.hlp_msc23  
/**/     with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_idf.d.
/**/  for each s_ttb_idf no-lock: 
/**/    display stream s_stm_errors s_ttb_idf. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_seq.d.
/**/  for each s_ttb_seq no-lock: 
/**/    display stream s_stm_errors s_ttb_seq except s_ttb_seq.ds_max. 
/**/    display stream s_stm_errors s_ttb_seq.ds_max format "-z,zzz,zzz,zz9". 
/**/    end.
/**/  output stream s_stm_errors close.
/**/
/**/ message "gat_pul.i: end of debug-output" skip "wait"
/**/    view-as alert-box.
/** / assign
/**/   user_path = ""
/**/   s_1st-error = FALSE.
/ **/
/**/  &ENDIF

if NOT batch-mode
 then SESSION:IMMEDIATE-DISPLAY = no.

RUN adecomm/_setcurs.p ("").

if NOT batch-mode
 then HIDE FRAME ds_make NO-PAUSE.

 &SCOPED-DEFINE SPL_CHAR_SUPPORTED 32
/* Function : scanSplCharacter
   Purpose  : Scan if there is any special character
   Input    : string to be scanned
   RETURN   : 1 if there is a special character found else 0 */
/* OE00170417 */
/* NOTE: In oracle if an object name has to have a character that's not
alpha-numeric, underscore, # or $ then we need to quote it while creating
it in Oracle and also quote it while referring to such objects in any SQL.
On the contrary if an object name is created without quotes in Oracle 
(like most names that are alpha-numeric ) then quoting them will give error */

FUNCTION scanSplCharacter RETURN INTEGER
 (INPUT name as CHARACTER):
DEFINE VARIABLE splchar AS CHARACTER EXTENT {&SPL_CHAR_SUPPORTED} INIT [
    '/',      /* 1  */
    '~\',     /* 2  */
    ' ',      /* 3  */
    '	',    /* 4  */ /* tab character*/
    '!',      /* 5  */
    '@',      /* 6  */
    '%',      /* 7  */
    '&',      /* 8  */
    '*',      /* 9  */
    '(',      /* 10 */
    ')',      /* 11 */
    '-',      /* 12 */
    '+',      /* 13 */
    '=',      /* 14 */
    '~{',     /* 15 */
    '~}',     /* 16 */
    '~[',     /* 17 */
    '~]',     /* 18 */
    '|',      /* 19 */
    ':',      /* 20 */
    ';',      /* 21 */
    '~"',     /* 22 */
    '~'',     /* 23 */
    '<',      /* 24 */
    ',',      /* 25 */
    '>',      /* 26 */
    '.',      /* 27 */
    '?',      /* 28 */
    '`',      /* 29 */
    '~~',     /* 30 */
    '^'       /* 31 */
/* Last element is a LINE FEED */
    ].
splchar[{&SPL_CHAR_SUPPORTED}] = STRING(CHR(10)). /*LINE FEED */

  DEFINE VARIABLE i AS INTEGER NO-UNDO INIT 0.
  REPEAT i = 1 TO {&SPL_CHAR_SUPPORTED}:
    IF INDEX(name, splchar[i]) > 0 THEN
     RETURN 1.
  END.
  RETURN 0.
END FUNCTION.


RETURN.

/*------------------------------------------------------------------*/

