/*********************************************************************
* Copyright (C) 2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

file: prodict/gate/_gat_cmp.p

Description:
    compares PROGRESS objects with the foreign objects, according
    to the available info per DataServer, cretaes a report 
    (-> gate-work.gate-edit), and calls guigget again to let the user
    choose, which objects he wants to re-create or delete
    
    <DS>_get.p gets a list of all pullable objects from the foreign DB
    <DS>_pul.p pulled over the definition from the foreign side
    gat_cmp.p  compared the existing definitions with the pulled info
    gat_cro.p  replaces the existing definitions with the pulled info
               or creates the new object if it didn't already exist

    Create <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Update <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Verify <DS> Schema: <DS>_get.p <DS>_pul.p gat_cmp.p gat_cro.p

    General Idea:
    1. Step: for each foreign object compare it with PROGRESS image
    2. Step: for each object in the PROGRESS-image check for existance
        on the foreign side

    format of created report:
      +---------------------------------------------------------+
      |  Object: <name>          <foreign-specification>        |
      |                                                         |
      |      [ *** ShemaHolder Update recommendet *** ]         |
      |                                                         |
      |  Mismatches:                                            |
      |      {T|S|F|I|IF|T} <name>: <attribute>: <message>      |
      |              SH: <value>     NS: <value>                |
      |  Informations:                                          |
      |      {T|S|F|I|IF|T} <name>: <attribute>: <message>      |
      |              SH: <value>     NS: <value>                |
      +---------------------------------------------------------+
    (foreign-specification:=
        ORACLE  : <user>.<name>{@<link>}
        SYB,ODBC: {<qualifier>.}<user>.<name>
    )

Input:
    &DS_DEBUG   DEBUG to protocol the creation
                ""    to turn off protocol
    gate-work   contains names of all objects to be created/updated
    s_ttb_tbl   Table information from foreign schema
    s_ttb_fld   Field information from foreign schema
    s_ttb_idx   Index information from foreign schema
    s_ttb_idf   Index-Field information from foreign schema

Output:
    gate-work   contains names of all objects to be created/updated
                gate-edit contains report of verify
                gate-flag = YES, if differences found
                gate-flag = NO,  if object doesn't exist anymore
                    on foreign side, or definitions don't differ

Unchanged:
    &DS_DEBUG   DEBUG to protocol the creation
                ""    to turn off protocol
    s_ttb_tbl   Table information from foreign schema
    s_ttb_fld   Field information from foreign schema
    s_ttb_idx   Index information from foreign schema
    s_ttb_idf   Index-Field information from foreign schema

History:
    hutegger    03/95   creation
    D. McMann   04/06/00 Added Unicode datatypes for MSS and a check
                         for Procedures for ODBC so they don't show
                         up as orphan files.
    D. McMann   06/04/02 Added output to file logic
    D. McMann   08/08/02 Eliminated any sequences whose name begins "$" - Peer Direct
    fernando    10/13/06 Use UPPER in the query when comparing owner and foreign name
                         for MSS and ODBC
    fernando    06/11/07 Unicode support for ORACLE
    fernando    04/08/08 Datetime support for ORACLE
--------------------------------------------------------------------*/

&SCOPED-DEFINE xxDS_DEBUG                   DEBUG
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

define variable l_canned         as logical   no-undo.
define variable l_crt-msg        as character no-undo. /* critcl diffs */
define variable l_dict-msg       as character no-undo.
define variable l_int-msg        as character no-undo. /* internl diffs */
define variable l_int-msg-txt    as character no-undo. /* title-txt     */
define variable l_min-msg        as character no-undo. /* internl diffs */
define variable l_min-msg-txt    as character no-undo. /* title-txt    */
define variable l_no-diff        as character no-undo initial
          "     No differences were detected.".
define variable l_no-diff1       as character no-undo initial
          "     All objects in {&PRO_DISPLAY_NAME} image exist also on the &1 side.".
define variable l_ret-msg-txt    as character no-undo. /* title-txt    */
DEFINE VARIABLE l_ret-msg        AS CHARACTER NO-UNDO. /* retainables  */
DEFINE VARIABLE l_ret2-msg       AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_reti-msg       AS CHARACTER NO-UNDO.
define variable l_sev-msg-txt    as character no-undo. /* title-txt    */
define variable l_sev-msg        as character no-undo. /* severe diffs */
define variable l_shupd-msg      as character no-undo.
DEFINE VARIABLE dif-found        AS LOGICAL INITIAL FALSE NO-UNDO.

define variable l_seq-msg        as integer   no-undo extent  4 initial
    [ 2,1,1,10 ].
define variable l_tbl-msg        as integer   no-undo extent 12 initial
    [ 3,1,1,1,1,1,1,1,1,1,1,11 ].
define variable l_fld-msg        as integer   no-undo extent 25 initial
    [ 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,15 ].
define variable l_idx-msg        as integer   no-undo extent 12 initial
    [ 5,1,1,1,1,1,6,7,8,13,14,16 ].
define variable l_idf-msg        as integer   no-undo extent  5 initial
    [ 9,1,1,1,17 ].
define variable l_msg            as character no-undo extent 20 initial
    [
/*        ....,....1....,....2....,....3....,....4....,....5....,....6 */
/*  1 */ "",  /* intentional empty! no additional message needed */
/*  2 */ "This Sequence doesn't exist in the {&PRO_DISPLAY_NAME} image.",
/*  3 */ "This Object doesn't exist in the {&PRO_DISPLAY_NAME} image.",
/*  4 */ "This Field doesn't exist in the {&PRO_DISPLAY_NAME} image.",
/*  5 */ "This Index doesn't exist in the {&PRO_DISPLAY_NAME} image.",
/*  6 */ "There is an index, that would fit better as ROWID index.",
/*  7 */ "(Flags: ""a"": optimal  ""u"": user-selectable """" not usable)",
/*  8 */ "The Primary Index doesn't exist anymore on the &1 side.",
/*  9 */ "This Index-Field doesn't exist in the {&PRO_DISPLAY_NAME} image.",
/* 10 */ "The definition of this Sequence didn't get compared with the &1 DB.",
/* 11 */ "The definition of this Table didn't get compared with the &1 DB.",
/* 12 */ "This Field doesn't exist in the &1 DB anymore.",
/* 13 */ "This Index doesn't exist in the &1 DB anymore.",
/* 14 */ "This Index exists in the {&PRO_DISPLAY_NAME} image, but not in the &1 DB.",
/* 15 */ "There's no {&PRO_DISPLAY_NAME}-Field for the TIME portion of the ORACLE DATE-field.",
/* 16 */ "This index exists only on the {&PRO_DISPLAY_NAME} side.",
/* 17 */ "This field is missing as component of this index.",
/* 18 */ " &1 .",
/* 19 */ " &1 .",
/* 20 */ " &1 ."
/*        ....,....1....,....2....,....3....,....4....,....5....,....6 */
    ]. /* &1 gest substituted with the external name of the DB-type */


define variable batch_mode	 as logical.
define variable edbtyp           as character no-undo. /*db-type ext frmt*/
define variable l_char-types     as character no-undo.
define variable l_chda-types     as character no-undo.
define variable l_date-types     as character no-undo.
define variable l_dcml-types     as character no-undo.
define variable l_deil-types     as character no-undo.
define variable l_dein-types     as character no-undo.
define variable l_header1        as character format "x(78)".
define variable l_header2        as character format "x(78)".
define variable l_intg-types     as character no-undo.
define variable l_logi-types     as character no-undo.
define variable msg              as character no-undo   EXTENT 6.
define variable odbtyp           as character no-undo. /* ODBC db-types */
DEFINE VARIABLE is_as400         AS LOGICAL   NO-UNDO.

define buffer   gate-work1       for gate-work.
define buffer   s_ttb_idx1       for s_ttb_idx.

DEFINE STREAM comp_e.
DEFINE VARIABLE dbcomp_e AS CHARACTER NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/

FORM
                                                    SKIP(1)
  msg[1]   FORMAT "x(29)" LABEL "Table"  colon 8 
    "->"
    msg[2] FORMAT "x(25)" LABEL "Table"             SKIP(1)

  WITH FRAME ds_make ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
  TITLE " Comparing " + edbtyp + " Definition " USE-TEXT 
    VIEW-AS DIALOG-BOX THREE-D.

/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/
      
/*---------------------  Internal Procedures  ----------------------*/

procedure error_handling:

  define INPUT PARAMETER error-nr         as INTEGER.
  define INPUT PARAMETER param1           as CHARACTER.
  define INPUT PARAMETER param2           as CHARACTER.

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
            SUBSTITUTE(l_msg[error-nr],param1,param2)  skip.
  output stream s_stm_errors close.
 
  end PROCEDURE.  /* error_handling */

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/


RUN adecomm/_setcurs.p ("WAIT").

/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/
/**/ message "gate/_gat_cmp.p." view-as alert-box.
/**/
/**/ run error_handling(18, "*****----- gat_cmp.p!!! -----*****" ,"").
/**/
/**/  if s_1st-error = false
/**/   then do:
/**/    assign s_1st-error = true.
/**/    output stream s_stm_errors to ds_upd.e.
/**/    output stream s_stm_errors close.
/**/    end.
/**/  output stream s_stm_errors to ds_upd.e append.
/**/  for each gate-work no-lock: 
/**/    display stream s_stm_errors
/**/      gate-work.gate-name gate-work.gate-flag
/**/      RECID(gate-work) gate-work.ttb-recid
/**/      with width 140. 
/**/    end.
/**/  for each s_ttb_seq: 
/**/    display stream s_stm_errors
/**/      s_ttb_seq.pro_name s_ttb_seq.ds_name
/**/      RECID(s_ttb_seq) s_ttb_seq.ds_spcl s_ttb_seq.pro_recid
/**/      with width 140. 
/**/    end.
/**/  for each DICTDB._Sequence
/**/    where DICTDB._Sequence._Db-Recid    = drec_db
          AND NOT DICTDB._Sequence._Seq-name BEGINS "$":
/**/    display stream s_stm_errors
/**/      DICTDB._Sequence._Seq-Name 
/**/      DICTDB._Sequence._Seq-misc[8] format "x(20)".
/**/    end.
/**/  for each s_ttb_tbl: 
/**/    display stream s_stm_errors
/**/      s_ttb_tbl.pro_name  s_ttb_tbl.ds_name
/**/      s_ttb_tbl.pro_recid s_ttb_tbl.ds_type
/**/      RECID(s_ttb_tbl) s_ttb_tbl.ds_spcl
/**/      with width 140. 
/**/    end.
/**/  for each s_ttb_fld: 
/**/    display stream s_stm_errors
/**/      s_ttb_fld.pro_name s_ttb_fld.ds_name
/**/      s_ttb_fld.pro_type s_ttb_fld.ds_type
/**/      s_ttb_fld.pro_frmt s_ttb_fld.ds_shdn
/**/      s_ttb_fld.ttb_tbl
/**/      with width 140. 
/**/    end.
/**/  for each s_ttb_idx: display stream s_stm_errors s_ttb_idx with width 140. end.
/**/  for each s_ttb_idf: display stream s_stm_errors s_ttb_idf with width 140. end.
/**/  output stream s_stm_errors close.
/**/
/**/  &ENDIF

assign
  batch_mode    = SESSION:BATCH-MODE
  dbcomp_e      = LDBNAME("DICTDBG") + ".vfy"
  edbtyp        = {adecomm/ds_type.i
                     &direction = "itoe"
                     &from-type = "user_dbtype"
                  }
  odbtyp        = {adecomm/ds_type.i
                     &direction = "ODBC"
                     &from-type = "odbtyp"
                  }
  l_dict-msg    = "          *** Use Dictionary to delete Tables from {&PRO_DISPLAY_NAME} image. ***" 
                + chr(10) + chr(10) + "Orphan-Tables:" + chr(10)
  l_msg[8]      = SUBSTITUTE(l_msg[8],edbtyp)
  l_msg[10]     = SUBSTITUTE(l_msg[10],edbtyp)
  l_msg[11]     = SUBSTITUTE(l_msg[11],edbtyp)
  l_msg[12]     = SUBSTITUTE(l_msg[12],edbtyp)
  l_msg[13]     = SUBSTITUTE(l_msg[13],edbtyp)
  l_msg[14]     = SUBSTITUTE(l_msg[14],edbtyp)
  l_msg[18]     = SUBSTITUTE(l_msg[18],edbtyp)
  l_msg[19]     = SUBSTITUTE(l_msg[19],edbtyp)
  l_msg[20]     = SUBSTITUTE(l_msg[20],edbtyp)
  l_no-diff1    = SUBSTITUTE(l_no-diff1,edbtyp)
  l_shupd-msg   = "          *** Schema-holder update recommended. ***" 
                + chr(10)
  l_int-msg-txt = chr(10)
                + "Differences in internally needed information were detected."
                + chr(10)
  l_min-msg-txt = chr(10)
                + "Minor differences were detected."
                + chr(10)
  l_ret-msg-txt = chr(10)
                + "Differences in retainable information were detected."
                + chr(10)
                + "These values can be modified by the Dictionary."
                + chr(10)
                + "The schema-holder update utility does not change them."
                + chr(10)
                + "Please use the Data Dictionary if you want to adjust them."
                + chr(10)
  l_sev-msg-txt = chr(10)
                + "Severe differences were detected."
                + chr(10).

IF NOT batch_mode then assign SESSION:IMMEDIATE-DISPLAY = yes.

if can-do(odbtyp,user_dbtype)
 then assign
    l_char-types = "LONGVARBINARY,LONGVARCHAR,CHAR,VARCHAR,BINARY,VARBINARY,TIME,NCHAR,NVARCHAR,NTEXT,TEXT,UNIQUEID"
    l_chda-types = "TIMESTAMP"
    l_date-types = "DATE"
    l_dcml-types = ""
    l_dein-types = "DECIMAL,NUMERIC,DOUBLE,FLOAT,REAL,BIGINT"
    l_deil-types = "INTEGER,SMALLINT,TINYINT"
    l_intg-types = ""
    l_logi-types = "BIT".
else if user_dbtype = "ORACLE"
   then assign
    l_char-types = "CHAR,VARCHAR,VARCHAR2,ROWID,LONG,RAW,LONGRAW,NCHAR,NVARCHAR2"
    l_chda-types = "TIMESTAMP,TIMESTAMP_LOCAL"
    l_date-types = "DATE"
    l_dcml-types = "FLOAT"
    l_dein-types = ""
    l_deil-types = "NUMBER"
    l_intg-types = "TIME"
    l_logi-types = "LOGICAL".
 else assign
    l_char-types = "CHAR,BINARY,IMAGE,SYSNAME,TEXT,TIMESTAMP,VARCHAR,VARBINARY"
    l_chda-types = ""
    l_date-types = "DATETIME,DATETIMEN,DATETIME4"
    l_dcml-types = "MONEY,MONEYN,MONEY4,REAL,FLOAT,FLOATN"
    l_dein-types = ""
    l_deil-types = ""
    l_intg-types = "INT,INTN,SMALLINT,TIME,TIME4,TINYINT"
    l_logi-types = "BIT".


/*------------------------------------------------------------------*/        
/*-------------------- 1.Step: <DS> -> PROGRESS --------------------*/
/*------------------------------------------------------------------*/        

if SESSION:BATCH-MODE and logfile_open
 then put unformatted  "Verifying objects" skip(1).

/*---------------------------- Sequences ---------------------------*/  

for each gate-work where gate-work.gate-slct = TRUE
                     and gate-work.gate-type = "SEQUENCE":

  assign l_min-msg           = ""
         l_int-msg           = ""
         l_ret-msg           = ""
         l_sev-msg           = ""
         gate-work.gate-flag = FALSE.
    
  find first s_ttb_seq where RECID(s_ttb_seq) = gate-work.ttb-recid no-error.
  if not available s_ttb_seq then do:
    if SESSION:BATCH-MODE and logfile_open then 
        PUT UNFORMATTED "SEQUENCE"                at 10
                        gate-work.gate-name       at 25
                        "s_ttb_seq NOT FOUND !!!" at 60 skip.
    run error_handling(14, gate-work.gate-name ,"").
    next.
  end.
  
  if TERMINAL <> "" and NOT batch_mode then 
    DISPLAY s_ttb_seq.ds_name  @ msg[1]
            s_ttb_seq.pro_name @ msg[2]
      WITH FRAME ds_make.
 
  if s_ttb_seq.pro_recid = ? then do:
    if user_dbtype = "ORACLE"
      then find first DICTDB._Sequence
          where DICTDB._Sequence._Db-Recid    = drec_db
            and DICTDB._Sequence._Seq-Name    = s_ttb_seq.pro_name
            and DICTDB._Sequence._Seq-misc[8] = s_ttb_seq.ds_spcl no-error.
    else if can-do(odbtyp,user_dbtype)
      then find first DICTDB._Sequence
        where DICTDB._Sequence._Db-Recid    = drec_db
          and DICTDB._Sequence._Seq-Name    = s_ttb_seq.pro_name
          and DICTDB._Sequence._Seq-misc[8] = s_ttb_seq.ds_spcl no-error.
    
    if available DICTDB._Sequence THEN
      ASSIGN s_ttb_seq.pro_recid = RECID(DICTDB._Sequence).
  end.
  else find first DICTDB._Sequence where RECID(DICTDB._Sequence) = s_ttb_seq.pro_recid
                                     AND NOT DICTDB._Sequence._Seq-name BEGINS "$"
                   no-error.
  if not available DICTDB._Sequence THEN
    ASSIGN
      { prodict/gate/cmp_nav.i
            &object = "SEQUENCE"
            &obj    = "seq"
            &objm   = "seq"
            }
  else do:
      { prodict/gate/cmp_msg.i
            &attrbt = "Name in {&PRO_DISPLAY_NAME}:"
            &msgidx = "l_seq-msg[2]"
            &msgvar = "min"
            &ns     = "s_ttb_seq.pro_name"
            &object = "SEQUENCE"
            &o-name = "s_ttb_seq.ds_name"
            &sh     = "DICTDB._Sequence._Seq-Name"
            }
      if can-do(odbtyp,user_dbtype) THEN
        { prodict/gate/cmp_msg.i
            &attrbt = "Special Name:"
            &msgidx = "l_seq-msg[3]"
            &msgvar = "sev"
            &ns     = "s_ttb_seq.ds_spcl"
            &object = "SEQUENCE"
            &o-name = "s_ttb_seq.ds_name"
            &sh     = "DICTDB._Sequence._Seq-Misc[3]"
            }
  end.
    
   { prodict/gate/cmp_sum.i
      &object = "seq"
      }

end. /* for each gate-work "SEQUENCE" */


/*------------------------------ Tables ----------------------------*/  

for each gate-work where gate-work.gate-slct = TRUE:

  if  gate-work.gate-type = "SEQUENCE"
   or gate-work.gate-type = "PROGRESS" then next.

  assign
    l_min-msg           = ""
    l_int-msg           = ""
    l_ret-msg           = ""
    l_ret2-msg          = ""
    l_reti-msg          = ""
    l_sev-msg           = ""
    gate-work.gate-flag = FALSE
    gate-work.gate-edit = "".
    
  for each s_ttb_tbl
    where recid(gate-work) = s_ttb_tbl.gate-work:
  
  if TERMINAL <> "" and NOT batch_mode
   then DISPLAY 
      s_ttb_tbl.ds_name  @ msg[1]
      s_ttb_tbl.pro_name @ msg[2]
      WITH FRAME ds_make.

  if s_ttb_tbl.pro_recid <> ?
   then find first DICTDB._File
        where RECID(DICTDB._File)        = s_ttb_tbl.pro_recid
        no-error.
  else if user_dbtype = "ORACLE"
   then find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and   DICTDB._File._For-name     = s_ttb_tbl.ds_name
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        and   DICTDB._File._Fil-misc2[8] = s_ttb_tbl.ds_spcl
        no-error.
  else if can-do(odbtyp,user_dbtype)
   then find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and   UPPER(DICTDB._File._For-name)  = UPPER(s_ttb_tbl.ds_name)
        and   UPPER(DICTDB._File._For-owner) = UPPER(s_ttb_tbl.ds_user)
        and   DICTDB._File._Fil-misc2[1] = s_ttb_tbl.ds_spcl
        no-error.
   else find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and   DICTDB._File._For-name     = s_ttb_tbl.ds_name
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        no-error.
  
  { prodict/gate/cmp_tbl.i }
      

/*---------------------------- FIELDS ------------------------------*/

  for each s_ttb_fld
    where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):
    IF s_ttb_fld.ds_name BEGINS "SYS_NC" AND user_dbtype = "ORACLE" THEN NEXT.
    find first DICTDB._Field of _File 
      where DICTDB._Field._For-Name = s_ttb_fld.ds_name
      and   DICTDB._Field._For-Type = s_ttb_fld.ds_type
      no-error.
    if not available DICTDB._Field
     then find first DICTDB._Field of _File 
      where DICTDB._Field._For-Name = s_ttb_fld.ds_name
      no-error.

    IF NOT AVAILABLE DICTDB._Field AND user_dbtype NE "ORACLE" THEN DO:
        find first DICTDB._Field of _File 
          where UPPER(DICTDB._Field._For-Name) = UPPER(s_ttb_fld.ds_name)
          and   UPPER(DICTDB._Field._For-Type) = UPPER(s_ttb_fld.ds_type)
          no-error.
        if not available DICTDB._Field
         then find first DICTDB._Field of _File 
          where UPPER(DICTDB._Field._For-Name) = UPPER(s_ttb_fld.ds_name)
          no-error.

    END.


    /* Oracle splits up the foreign date-fields into two PROGRESS-fields
     * one of foreign type DATE and one of foreign type TIME. Protoora
     * however, deletes the TIME field, to make the schemaholder similar
     * to the original PROGRESS-DB.
     * So if we try to find the TIME DICTDB._Field and find the DATE one
     * we give an according message and go-on with the next field
     */
    if   s_ttb_fld.ds_type        = "TIME"
     and user_dbtype              = "ORACLE"
     and available DICTDB._Field
     and (DICTDB._Field._For-Type  = "DATE" OR
          CAN-FIND (first DICTDB._Field of _File WHERE 
                     DICTDB._Field._For-Name = s_ttb_fld.ds_name AND
                     DICTDB._Field._For-Type NE "TIME" AND
                     DICTDB._Field._Data-Type BEGINS "datetime"))
     then do:
        IF DICTDB._Field._For-Type  = "DATE" THEN DO:
            /* if the field type is character or datetime, then it's ok to
               skip this check. So just issue msg when it's date in the schema 
               holder.
            */
            IF DICTDB._Field._Data-Type  = "DATE" THEN
              assign
                l_min-msg = l_min-msg + "    FIELD "
                          + s_ttb_fld.ds_name + ": " + chr(10) + chr(9)
                          + l_msg[l_fld-msg[25]]               + chr(10).
        END.
        ELSE DO:
            /* we must have gotten here because we found a time field,
               but the data type is actually not date on schema holder,
               that is, it's datetime, so can't have time portion.
            */
            assign
              l_sev-msg = l_sev-msg + "    FIELD "
                        + s_ttb_fld.pro_name + ": " + chr(10) + chr(9)
                        + "Time portion found for datetime field in the schema."  + chr(10).
        END.
      end.

     else do:
      { prodict/gate/cmp_fld.i }
      end.
    
    end.     /* for each s_ttb_fld */
  

/*----------------------------- INDEXES ------------------------------*/

  for each s_ttb_idx
    where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
    
    if user_dbtype = "SYB"
     then do:
      find first DICTDB._Index of DICTDB._File
        where DICTDB._Index._For-name = s_ttb_idx.ds_name
                                   + STRING(s_ttb_idx.pro_Idx#)
        no-error.
      if not available DICTDB._Index
       then find first DICTDB._Index of DICTDB._File
        where DICTDB._Index._For-name = s_ttb_idx.ds_name
                                   + STRING(DICTDB._Index._idx-num)
        no-error.
      end.
     else find first DICTDB._Index of DICTDB._File
      where DICTDB._Index._For-name = s_ttb_idx.ds_name
      no-error.

     if not available DICTDB._Index AND user_dbtype NE "ORACLE" THEN DO:
        find first DICTDB._Index of DICTDB._File
              where UPPER(DICTDB._Index._For-name) = UPPER(s_ttb_idx.ds_name)
              no-error.
     END.
     
    { prodict/gate/cmp_idx.i }


/*-------------------------- INDEX-FIELDS --------------------------*/

    for each s_ttb_idf
      where s_ttb_idf.ttb_idx = RECID(s_ttb_idx):
     
      find first s_ttb_fld
        where RECID(s_ttb_fld) = s_ttb_idf.ttb_fld.
        
      if s_ttb_fld.fld_recid = ?
       then do:
        IF  user_dbtype = "ORACLE" THEN
            find first DICTDB._Field of DICTDB._File
              where DICTDB._Field._For-name = s_ttb_fld.ds_name
              and   DICTDB._Field._For-Type = s_ttb_fld.ds_type
              no-error.
        ELSE
            find first DICTDB._Field of DICTDB._File
                  where UPPER(DICTDB._Field._For-name) = UPPER(s_ttb_fld.ds_name)
                  and   UPPER(DICTDB._Field._For-Type) = UPPER(s_ttb_fld.ds_type)
                  no-error.

        if not available DICTDB._Field
         THEN DO:
            IF  user_dbtype = "ORACLE" THEN
             find first DICTDB._Field of DICTDB._File
                  where DICTDB._Field._For-name = s_ttb_fld.ds_name
                  no-error.
            ELSE
                find first DICTDB._Field of DICTDB._File
                     where UPPER(DICTDB._Field._For-name) = UPPER(s_ttb_fld.ds_name)
                     no-error.
        END.
        end.
       else find first DICTDB._Field /* of DICTDB._File */
          where RECID(DICTDB._Field) = s_ttb_fld.fld_recid
          no-error.

      if available DICTDB._Field
       then find first DICTDB._Index-field of DICTDB._Index
        where DICTDB._Index-field._Field-recid = RECID(DICTDB._Field)
        no-error.

      if   s_ttb_fld.ds_type        = "TIME"
       and user_dbtype              = "ORACLE"
       and available DICTDB._Field
       and DICTDB._Field._For-Type  = "DATE"
       then assign
        l_min-msg = l_min-msg + "    INDEX-FIELD "
                  + s_ttb_idx.ds_name + "/" 
                  + s_ttb_fld.ds_name + ": " + chr(10) + chr(9)
                  + l_msg[l_idf-msg[5]]                + chr(10).

       else do:
        { prodict/gate/cmp_idf.i }
        end.


      end.   /* for each s_ttb_idf */
    
    end.   /* for each s_ttb_idx */


/*---------------- CHECK INDEXES IN OTHER DIRECTION ----------------*/

  for each DICTDB._Index of DICTDB._File:
    IF DICTDB._File._For-type = "VIEW" THEN NEXT.
    if   DICTDB._Index._For-name <> ? and DICTDB._Index._For-name <> "" then do:
      find first s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl) no-error.
    
       if not available s_ttb_idx THEN     
         IF INDEX("_V##", DICTDB._Index._For-name) = 0 THEN    
           ASSIGN l_min-msg = l_min-msg + "    INDEX "
                  + DICTDB._Index._index-name + ": " + chr(10) + chr(9)
                  + l_msg[l_idx-msg[12]]             + chr(10).
     
    end.
  end.
    
/*------------------------- PRIMARY-INDEX --------------------------*/

  find first DICTDB._Index of DICTDB._File
    where RECID(DICTDB._Index) = DICTDB._File._Prime-Index
    no-lock no-error.
  if available DICTDB._Index then do:
    if user_dbtype = "SYB" then do:
      find first s_ttb_idx
        where s_ttb_idx.ttb_tbl        = RECID(s_ttb_tbl)
        and   s_ttb_idx.ds_name
          + STRING(s_ttb_idx.pro_Idx#) = DICTDB._Index._For-name
        no-error.
      if not available s_ttb_idx
       then find first s_ttb_idx
        where s_ttb_idx.ttb_tbl            = RECID(s_ttb_tbl)
        and   s_ttb_idx.ds_name 
          + STRING(DICTDB._Index._idx-num) = DICTDB._Index._For-name
        no-error.
    end.
    else find first s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
               and s_ttb_idx.ds_name = DICTDB._Index._For-name no-error.

    IF user_dbtype NE "ORACLE" THEN DO:
        find first s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
               and UPPER(s_ttb_idx.ds_name) = UPPER(DICTDB._Index._For-name) no-error.
    END.

    if not available s_ttb_idx AND DICTDB._File._For-type <> "VIEW"
     then assign  /* primary index doesn't exist anymore */
       l_sev-msg = l_sev-msg + "    INDEX "
                 + DICTDB._Index._For-name + ": " + chr(10)
                 + chr(9) +  l_msg[l_idx-msg[9]]  + chr(10).

    end.

  { prodict/gate/cmp_sum.i
    &object = "tbl"
    }
   

    end.  /* for each s_ttb_tbl of gate-work */
    

  end. /* for each gate-work */


/*------------------------------------------------------------------*/        
/*-------------------- 2.Step: PROGRESS -> <DS> --------------------*/
/*------------------------------------------------------------------*/        

/* If the user selected all objects to be compared, we add a agte-work
 * record with type = "PROGRESS", to indicate, that all foreign objects
 * are contained in the s_ttb-tables. So all objects in the PROGRESS-
 * image, for which we can't find a counterpart in the foreign schema
 * we generate a warning
 */

for each gate-work
  where gate-work.gate-slct = TRUE
  and   gate-work.gate-type = "PROGRESS":
  
  assign
    l_min-msg = ""
    l_int-msg = ""
    l_ret-msg = ""
    l_ret2-msg = ""
    l_reti-msg = ""
    l_sev-msg = "".
    
  for each DICTDB._File
    where DICTDB._File._Db-Recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"):
    
  /*------- skip the objects the user didn't want to compare -------*/
    if user_dbtype = "ORACLE"
     then do:  /* ORACLE */

      /* 0. skip system-tables */
      if  DICTDB._File._File-name begins "oracle7_"
       or DICTDB._File._File-name begins "oracle6_"
       or lookup(DICTDB._File._File-name,{prodict/ora/ora_sys.i}) <> 0
       then next.

      /* 1. skip non-selected links */
      find first s_ttb_link
        where s_ttb_link.master 
            + s_ttb_link.name = ( if DICTDB._File._Fil-misc2[8] = ?
                                    then ""
                                    else DICTDB._File._Fil-misc2[8]
                                )
        and   s_ttb_link.slctd                    = FALSE
        no-error.

      if available s_ttb_link then next. /* user chose to not check this link */

      /* 2. skip non-pre-selected objects */
      find first s_ttb_link
        where s_ttb_link.master 
            + s_ttb_link.name = ( if DICTDB._File._Fil-misc2[8] = ?
                                    then ""
                                    else DICTDB._File._Fil-misc2[8]
                                )
        and   s_ttb_link.slctd                    = TRUE
        no-error.

      if NOT ( available s_ttb_link
       and DICTDB._File._For-name  matches s_ttb_link.presel-n
       and DICTDB._File._For-type  matches s_ttb_link.presel-t
       and ( LC(DICTDB._File._For-owner) matches LC(s_ttb_link.presel-o)
          or    DICTDB._File._For-owner     =    ""
           )
             )
       then next. /* object not within preselection criteria */

      /* 3. skip non-selected objects */
      if DICTDB._File._For-Owner = ""
       then find first gate-work1 
        where gate-work1.gate-edit matches "*:" + DICTDB._File._For-name
                                          + ":" + DICTDB._File._For-Type
        no-error.  
       else find first gate-work1
        where gate-work1.gate-name = DICTDB._File._For-name
        and   gate-work1.gate-type = DICTDB._File._For-Type
        and   gate-work1.gate-user = DICTDB._File._For-Owner
        and   gate-work1.gate-qual = DICTDB._File._Fil-misc2[8]
        no-error.  

      end.     /* ORACLE */

    else if can-do(odbtyp,user_dbtype)
     then do:  /* ODBC */

      /* 0. skip system-tables */
      if  lookup(DICTDB._File._File-name,{prodict/odb/odb_sys.i}) <> 0
       then next.

      IF DICTDB._File._For-type = "PROCEDURE" THEN NEXT.

      /* 1. skip non-pre-selected objects */
      if NOT ( DICTDB._File._For-name     matches s_name
           and DICTDB._File._For-type     matches s_type
           and DICTDB._File._For-owner    matches s_owner
           and DICTDB._File._Fil-misc2[1] matches s_qual
             )
       then next. /* object not within preselection criteria */
       
      /* 2. skip non-selected objects */
      find first gate-work1
        where gate-work1.gate-name = DICTDB._File._For-name
        and   gate-work1.gate-type = DICTDB._File._For-Type
        and   gate-work1.gate-user = DICTDB._File._For-Owner
        and   gate-work1.gate-qual = ( if DICTDB._File._Fil-misc2[1] = ?
                                        then ""
                                        else DICTDB._File._Fil-misc2[1]
                                     )
        no-error.  

      end.     /* ODBC */

     else do:  /* SYBASE */

      /* 1. skip non-pre-selected objects */
      if NOT ( DICTDB._File._For-name     matches s_name
           and DICTDB._File._For-type     matches s_type
           and DICTDB._File._For-owner    matches s_owner
             )
       then next. /* object not within preselection criteria */
       
      /* 2. skip non-selected objects */
      find first gate-work1
        where gate-work1.gate-name = DICTDB._File._For-name
        and   gate-work1.gate-type = DICTDB._File._For-Type
        and   gate-work1.gate-user = DICTDB._File._For-Owner
        no-error.  

      end.     /* SYBASE */

    if available gate-work1
     and gate-work1.gate-flg2 = false
     and gate-work1.gate-edit = ""
     then next.     /* user chose to not compare this object */

  /*--------- skip all system-tables, pseudo-objects, ... ----------*/
    if  ( can-do(odbtyp,user_dbtype) 
       and ( LOOKUP(DICTDB._File._For-type,"GENERIC-BUFFER,STABLE") <> 0
         or  DICTDB._File._File-name begins "SQL"
         or  LOOKUP(DICTDB._File._File-name,"CloseAllProcs,GetFieldIds,"
                   + "GetFieldIds_buffer,GetInfo,GetInfo_Buffer,"
                   + "SEND-SQL-STATEMENT,SendInfo")      <> 0
        )  )
     or ( user_dbtype = "ORACLE"
       and ( LOOKUP(DICTDB._File._File-Name,"PROC-TEXT-BUFFER,"
                   + "SEND-SQL-STATEMENT")    <> 0
         or  DICTDB._File._File-name begins "oracle"
        )  )
     then next.  /* system-table or pseudo-object */
     
  /*--------- check for existence of object on foreign side --------*/

  /* a) does object exist on the foreign side */
    if user_dbtype = "ORACLE"
     then find first s_ttb_tbl
      where s_ttb_tbl.ds_name = DICTDB._File._For-name
      and   s_ttb_tbl.ds_user = DICTDB._File._For-owner
      and   s_ttb_tbl.ds_spcl = DICTDB._File._Fil-misc2[8]
      no-error.
     else find first s_ttb_tbl
      where s_ttb_tbl.ds_name = DICTDB._File._For-name
      and   s_ttb_tbl.ds_user = DICTDB._File._For-owner
      and   s_ttb_tbl.ds_spcl = DICTDB._File._Fil-misc2[1]
      no-error.
    if not available s_ttb_tbl
     then assign
       l_sev-msg = l_sev-msg                + chr(9)
                 + string(DICTDB._File._File-name,"x(20)")
                 + ": "                     + chr(9)
                 + l_msg[l_tbl-msg[12]]     + chr(10).

     else do:  /* object exists */

  /* b) do all its fields exist on the foreign side */
      for each DICTDB._Field of DICTDB._File
        where DICTDB._Field._For-name > ""
        no-lock:
        find first s_ttb_fld
          where s_ttb_fld.ds_name = DICTDB._Field._For-Name
          and   s_ttb_fld.ds_type = DICTDB._Field._For-Type
          no-error.
        if not available s_ttb_fld
         then assign
           l_min-msg = l_min-msg + chr(9) + "Field "
                     + DICTDB._Field._For-name + ": " + chr(10)
                     + chr(9) + chr(9)
                     + l_msg[l_fld-msg[24]]           + chr(10).
        end.  /* for each DICTDB._Field */
    
  /* c) do all its Indexes exist on the foreign side */
      for each DICTDB._Index of DICTDB._File
        where DICTDB._Index._For-name > ""
        no-lock:

        if user_dbtype = "SYB" then do:
          find first s_ttb_idx
            where s_ttb_idx.ttb_tbl       =  RECID(s_ttb_tbl)
            and   s_ttb_idx.ds_name
             + STRING(s_ttb_idx.pro_Idx#) =  DICTDB._Index._For-name
            no-error.
          if not available s_ttb_idx
           then find first s_ttb_idx
            where s_ttb_idx.ttb_tbl           =  RECID(s_ttb_tbl)
            and   s_ttb_idx.ds_name
             + STRING(DICTDB._Index._idx-num) = DICTDB._Index._For-name
            no-error.
         end.
         else find first s_ttb_idx
          where s_ttb_idx.ttb_tbl =  RECID(s_ttb_tbl)
          and   s_ttb_idx.ds_name =  DICTDB._Index._For-name
          no-error.
     
        if not available s_ttb_idx
         then assign
           l_min-msg = l_min-msg + chr(9) + "Index "
                     + DICTDB._Index._For-name + ": " + chr(10)
                     + chr(9) + chr(9)
                     + l_msg[l_idx-msg[10]]      + chr(10).
        end.  /* for each DICTDB._Index */
    
      end.     /* object exists */

    end.  /* for each DICTDB._File */

  if   l_sev-msg = "" and l_crt-msg = "" and l_min-msg = "" then 
    ASSIGN gate-work.gate-edit = gate-work.gate-name + " " 
                                 + gate-work.gate-user + gate-work.gate-type 
                                 + gate-work.gate-qual + chr(10) + chr(10)
                                 + l_no-diff1
           gate-work.gate-flag = FALSE.
  else do:

     IF NOT s_outf THEN
       assign gate-work.gate-edit = ( if l_sev-msg <> ""
                                then l_dict-msg + l_sev-msg
                                else ""
                              )
                            + ( if l_crt-msg <> ""
                                then "  Orphan Fields/Indexes:" + chr(10) + l_crt-msg
                                else ""
                              )
                            + ( if l_min-msg <> ""
                                then "  Orphan Fields/Indexes:" + chr(10) + l_min-msg
                                else ""
                              )
             gate-work.gate-flag = TRUE.
      ELSE DO:
        OUTPUT STREAM comp_e TO VALUE(dbcomp_e) APPEND.
        IF l_sev-msg <> "" THEN DO:
          PUT STREAM comp_e UNFORMATTED l_dict-msg l_sev-msg SKIP.
          ASSIGN dif-found = TRUE.
        END.
        IF l_crt-msg <> "" THEN DO:
          PUT STREAM comp_e UNFORMATTED "  Orphan Fields/Indexes: " SKIP l_crt-msg SKIP.
          ASSIGN dif-found = TRUE.
        END.
        IF l_min-msg <> "" THEN DO:
          PUT STREAM comp_e UNFORMATTED "  Orphan Fields/Indexes:" SKIP l_min-msg SKIP.
          ASSIGN dif-found = TRUE.
        END.
        OUTPUT STREAM comp_e CLOSE.
        ASSIGN gate-work.gate-flag = TRUE.                         
      END.
   END.
  end. /* for each gate-work "PROGRESS" */


/*------------------------------------------------------------------*/        
/*---------------------- 3. Step: UI clean up ----------------------*/
/*------------------------------------------------------------------*/        

if NOT batch_mode
 then SESSION:IMMEDIATE-DISPLAY = no.

RUN adecomm/_setcurs.p ("").

if NOT batch_mode
 then HIDE FRAME ds_make NO-PAUSE.


/*------------------------------------------------------------------*/        
/*-------------------- 4. Step: tell user diffs --------------------*/
/*------------------------------------------------------------------*/        

if user_env[25] begins "AUTO" 
 then do:   /*========= automatically select all possible tables =======*/

    assign
      l_header1 = fill(" ",integer(5 - length(edbtyp,"character") / 2))
                + "Results of comparison of the {&PRO_DISPLAY_NAME} image with the " 
                + edbtyp + " DB's schema"
      l_header2 = ( if user_dbtype = "ORACLE"
                      then "" /*ORACLE-DB transparent -> no info avlbl*/
                      else "SH-Name="     + SDBNAME("DICTDBG")   + " "
                         + "Image-Name="  + LDBNAME("DICTDBG")   + " "
                         + "DSQUERY="     + OS-GETENV("DSQUERY") + " "
                         + "Physcl-Name=" + PDBNAME("DICTDBG")
                  )
      l_header2 = fill(" ",integer(38 - length(l_header2,"character") / 2))
                + l_header2.

    run prodict/misc/_prt_rpt.p
      ( INPUT "prodict/gate/_gat_rpt.p",
        INPUT l_header1,
        INPUT l_header2,
        INPUT "guigget",
        INPUT "s"
      ).
  end.      /*========= automatically select all possible tables =======*/

 else do:   /*=========== let user select the tables he wants ==========*/
  IF s_outf = FALSE THEN DO:

    IF user_dbtype = "ODBC" THEN DO:
        FIND FIRST DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db NO-ERROR.
        IF AVAILABLE DICTDB._Db THEN
            is_as400 = INDEX(DICTDB._Db._Db-misc2[5],"AS/400") > 0.
    END.

    RUN "prodict/gui/_guigge1.p" (INPUT edbtyp, INPUT "Compare", is_as400).
    assign l_canned = (if RETURN-VALUE = "cancel" then yes else no).
  END.
  ELSE DO:
    IF dif-found THEN
      MESSAGE "A report of differences has been created in your working directory.  " SKIP
              "See file  " dbcomp_e "  for results." SKIP 
              VIEW-AS ALERT-BOX TITLE "Verify Table Results".
    ELSE
      MESSAGE l_no-diff VIEW-AS ALERT-BOX TITLE "Verify Table Results".
    l_canned = YES.
  END.
 end.     /*=========== let user select the tables he wants ==========*/

if l_canned 
 then assign
   user_path = ( if user_dbtype = "ORACLE"
                  then "_ora_lkx"
                  else ""
               ).
for each gate-work
  where gate-work.gate-flag = FALSE
  or    l_canned = TRUE:
  assign gate-work.gate-slct = FALSE.
  end.

/* clear out variable in case user does again */
ASSIGN s_outf = FALSE.

RETURN.

/*------------------------------------------------------------------*/        
