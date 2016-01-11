/*********************************************************************
* Copyright (C) 2006,2012 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
file:   prodict/mss/_mss_pul.p

description:
    pulls schemainfo of all objects contained in gate-work into
    the temp-tables

    <DS>_get.p gets a list of all pullable objects from the foreign DB
    <DS>_pul.p pulled over the definition from the foreign side
    gat_cmp.p  compared the existing definitions with the pulled info
    gat_cro.p  replaces the existing definitions with the pulled info
               or creates the new object if it didn't already exist

    Create <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Update <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Verify <DS> Schema: <DS>_get.p <DS>_pul.p gat_cmp.p gat_cro.p

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

History:
    03/31/00 D. McMann Created from _odb_pul.p
    10/25/00 D. McMann Added " to Progress_Recid name since names are now quoted.
    11/20/00 Recid index causing meta schema mismatches correct for index name. #147
    04/18/01 Added check for stored procedure parameter @RETURN_VALUE new for SQL Server 2000
    10/16/01 D. McMann Added logic for fields that begin with progress_
    04/02/02 D. McMann Added logic to increase counter after ident field
    07/01/02 D. McMann Added logic to set pro_case to false if case-insentive code page.
                       20020701-004
    12/09/02 D. McMann Added logic to see if an index component is desc.
    01/08/03 D. McMann Added DICTDBG to send-sql call
    04/17/03 D. McMann Changed error msg for skipping table instead of fields
    04/23/03 D. McMann Added logic to check sequence names - support on-line schema
    10/17/03 D. McMann Add NO-LOCK statement to _Db find in support of on-line schema add
    02/28/06 fernando  Skip table valued tables - 20060120-003
    04/17/06 fernando  Unicode support
    07/19/06 fernando  Unicode support - restrict to MSS 2005
    08/24/06 fernando  Add warning about non utf-8 codepage and unicode columns - 20060802-024
    10/06/06 fernando  Check object name in case it has underscore - 20031205-003
    08/10/07 fernando  Removed UI restriction for Unicode support    
    02/22/08 fernando  Support for datetime
    02/23/09 Nagaraju  to handle timestamp field properly
    03/16/09 knavneet  datetime-tz support for MSS
    04/28/09 knavneet  BLOB support for MSS (OE00178319)
    05/22/09 sgarg     ROWGUID support for MSS
    09/23/09 Nagaraju  Computed column implementation for RECID support
    10/29/09 Nagaraju  To update new format for version string
    02/23/10 Nagaraju  to avoid computed_column check if MSS vers 2000 or earlier
    09/16/10 knavneet  CR - OE00198360
    06/21/11 kmayur    added support for constraint pull - OE00195067    
    02/27/13 sdash     Implementation of independent Batch Pull.
*/

&SCOPED-DEFINE xxDS_DEBUG                   DEBUG /**/
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

{ prodict/user/uservar.i }
{ prodict/gate/odb_ctl.i  }

define BUFFER   hlp-work         FOR  gate-work.
define BUFFER   A_col            FOR  DICTDBG.SQLColumns_buffer.
define BUFFER   P_col            FOR  DICTDBG.SQLProcCols_buffer.
define BUFFER   S_col            FOR  DICTDBG.SQLSpecialColumns_buffer.

define variable A_proc_handle    as integer.
define variable P_proc_handle    as integer.
define variable S_proc_handle    as integer.
define variable C_proc_handle    as integer.

define variable array_name 	     as character no-undo. 
define variable batch-mode	     as logical.
define variable bug1             as logical no-undo.
define variable bug4             as logical no-undo.
define variable bug7             as logical no-undo.
define variable bug8             as logical no-undo.
define variable bug19            as logical no-undo.
define variable bug22            as logical no-undo.
define variable bug28            as logical no-undo.
define variable bug29            as logical no-undo.
define variable bug34            as logical no-undo.
define variable char-type	     as logical no-undo. 
define variable column_available as logical no-undo. 
define variable comp-name  	     as character no-undo.
define variable temp-comp-name   as character no-undo.
define variable comp-ind         as integer   no-undo.
define variable comp-num         as integer   no-undo.
define variable doextent         as logical   no-undo. 
define variable dot1             as character no-undo.
define variable dot2             as character no-undo.
define variable dtyp             as integer   no-undo.
define variable edbtyp           as character no-undo. /* db-type external format */
define variable escp             as character no-undo.
define variable field-position   as integer   no-undo.
define variable fld-name-1   	 as character no-undo.
define variable fld-prior        as integer   no-undo.
define variable fld-properties   as character no-undo.
define variable fld-remark       as character no-undo.
define variable fnam             as character no-undo.
define variable format_len       as integer   no-undo.
define variable format_len1      as integer   no-undo.
define variable full_table_name  as character no-undo.
define variable has_id_ix        as logical   no-undo.
define variable i     	         as integer   no-undo.
define variable indn             as integer   no-undo.
define variable keycp 	         as integer   no-undo.
define variable l_char-types     as character no-undo.
define variable l_chrw-types     as character no-undo.
define variable l_date-types     as character no-undo.
define variable l_dcml           as integer   no-undo.
define variable l_dcml-types     as character no-undo.
define variable l_dt             as character no-undo.
define variable l_tmp            as character no-undo.
define variable l_floa-types     as character no-undo.
define variable l_frmt           as character no-undo.
define variable l_i###-types     as character no-undo.
define variable l_i##d-types     as character no-undo.
define variable l_i##l-types     as character no-undo.
define variable l_i#dl-types     as character no-undo.
define variable l_logi-types     as character no-undo.
define variable l_prec 	         as integer   no-undo.
define variable l_time-types     as character no-undo.
define variable l_tmst-types     as character no-undo.
define variable l_init           as character no-undo. 
define variable l_matrix         as character no-undo initial
            "a,ax,ax,ax,u,ux,ux,ux".
define variable m1               as integer   no-undo.
define variable m2               as integer   no-undo. 
define variable msg              as character no-undo   EXTENT 6.
define variable namevar          as character no-undo case-sensitive.
define variable namevar-1   	 as character no-undo case-sensitive.
define variable newf  	         as logical   no-undo. /* new file definition */
define variable ntyp  	         as character no-undo.
define variable numeric-type	 as logical   no-undo. 
define variable oldf  	         as logical   no-undo. /* old file definition */
define variable pnam             as character no-undo.
define variable prev-prior       as integer   no-undo.
define variable progvar          as character no-undo.
define variable quote            as character no-undo.
define variable r                AS RECID     no-undo.
define variable scrap            as logical   no-undo.
define variable shadow_col_name  as character no-undo.
define variable shadow_col       as integer   no-undo. 
define variable spclvar          as character no-undo.
define variable spclvar-1   	 as character no-undo.
define variable table_comment    as character no-undo.
define variable table_name  	 as character no-undo case-sensitive.
define variable table_user  	 as character no-undo.
define variable table_user_1  	 as character no-undo.
define variable table-properties as character no-undo.
define variable table_spcl       as character no-undo.
define variable table_spcl_1     as character no-undo.
define variable table_type  	 as character no-undo.
define variable temp1            as integer   no-undo.
define variable temp2            as integer   no-undo.
define variable typevar          as character no-undo.
define variable typevar-1   	 as character no-undo.
define variable unique-prime     as logical   no-undo. /* upi already found */
define variable uservar          as character no-undo.
define variable uservar-1   	 as character no-undo.
define variable vfmt1            as character no-undo.
define variable spcl_len         as integer   no-undo.
define variable user_len         as integer   no-undo.
define variable table_len        as integer   no-undo.
define variable dq_index         as integer   no-undo.
DEFINE VARIABLE stph1            AS INTEGER   NO-UNDO.
DEFINE VARIABLE stph2            AS INTEGER   NO-UNDO.
DEFINE VARIABLE dfth1            AS INTEGER   NO-UNDO.
DEFINE VARIABLE isasc            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE idxidn           AS INTEGER   NO-UNDO.
DEFINE VARIABLE tblname          AS CHARACTER NO-UNDO.
DEFINE VARIABLE sqlstate         AS CHARACTER NO-UNDO.
DEFINE VARIABLE s                AS CHARACTER NO-UNDO.
DEFINE VARIABLE tdbtype          AS CHARACTER NO-UNDO.
DEFINE VARIABLE itype            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE has_recid_idx    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tmp_str          AS CHARACTER NO-UNDO.
DEFINE VARIABLE isUnicodeType    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE warn_tablename   AS CHARACTER NO-UNDO.
DEFINE VARIABLE warn_codepage    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE esc-idx1         AS INTEGER   NO-UNDO.
DEFINE VARIABLE esc-idx2         AS INTEGER   NO-UNDO.
DEFINE VARIABLE ch1              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ch2              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE isFileStream     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE change-dict-ver  AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE VARIABLE ds_srvr_vers     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ds_clnt_vers     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE foreign_dbms_version    AS INTEGER   NO-UNDO.
DEFINE VARIABLE isOutput         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rowid_idx_name   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ClustAsROWID     AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE uniquifyAddon    AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE mssselBestRowidIdx  AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE useLegacyRanking AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE found            AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE err_sp           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err_sp_flag      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE mssrecidCompat   AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE mapmssdatetime   AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE callerid         AS INTEGER    NO-UNDO INITIAL 2.
DEFINE VARIABLE Coninfosql       AS CHARACTER  NO-UNDO.


define TEMP-TABLE column-id
          FIELD col-name         as character case-sensitive
          FIELD col-id           as integer
          INDEX upi        IS UNIQUE PRIMARY col-name.

/*------------------------------------------------------------------*/

/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/
FORM
                                                    SKIP(1)
  msg[1]   FORMAT "x(29)" LABEL "Table"  colon 8 
    "->"
    msg[2] FORMAT "x(25)" LABEL "Table"             SKIP
  msg[3]   FORMAT "x(29)" LABEL "Column" colon 8 
    "->"
    msg[4] FORMAT "x(25)" LABEL "Field"             SKIP
  msg[5]   FORMAT "x(29)" LABEL "Key"    colon 8 
    "->"
    msg[6] FORMAT "x(25)" LABEL "Index"             SKIP (1)
/*  SKIP(1) */
  with ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  TITLE " Loading " + edbtyp + " Definition " USE-TEXT
  frame ds_make.

/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/


/*------------------------------------------------------------------*/
FUNCTION isComputed RETURNS LOGICAL (INPUT t1 AS CHAR, INPUT c1 AS CHAR):
DEFINE VARIABLE isComputeCol     AS LOGICAL   NO-UNDO.

/* OE00198360  - For MSS 7 and below, computed column is not supported
    For MSS 2000 - computed column info is got from 'syscolumns' table
    For MSS 2005 and above - computed column info is got from 'sys.columns' table */

          IF (foreign_dbms_version < 8) THEN  
              RETURN FALSE. 
          ELSE IF (foreign_dbms_version = 8) THEN
              assign sqlstate = "SELECT iscomputed FROM syscolumns where name = '" + c1 +
                            "' and id = (OBJECT_ID('" + t1 + "'))".
          ELSE
              assign sqlstate = "SELECT is_computed FROM sys.columns where name = '" + c1 +
                            "' and object_id = (OBJECT_ID('" + t1 + "'))".

          RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlstate ).

          IF ERROR-STATUS:ERROR THEN. /*Don't do anything inital value already set to unknown */
          ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
              /* if no-error and have messages, we failed to run it (must be MSS 2000),
                 so we just close it and will return FALSE.
              */
              CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
          END.
          ELSE DO:
            FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:
                ASSIGN isComputeCol = LOGICAL(INTEGER(proc-text)). /* convert to atoi to logical */
            END.
            CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
          END.

RETURN isComputeCol.
END FUNCTION.

procedure error_handling:

define INPUT PARAMETER error-nr         as INTEGER.
define INPUT PARAMETER param1           as CHARACTER.
define INPUT PARAMETER param2           as CHARACTER.

define       variable  err-msg as character extent 10 initial [
/*  1 */ "WARNING: Column &1 is hidden; it cannot be an index component",
/*  2 */ "ERROR: Table &1 has unsupported data types.",
/*  3 */ "       Skipping this table...",
/*  4 */ " &1 &2 ", /* intentionally left blank for div. error-messages */
/*  5 */ "WARNING: No index for the RECID &1 field of table &2",
/*  6 */ "WARNING: The Driver sends wrong data about indexes, they cant be build automatically",
/*  7 */ "WARNING: Table &1 has Unicode data type, which is supported only with MS SQL Server 2005 and up",
/*  8 */ "WARNING: Table &1 has Unicode data types and the schema holder's codepage is not utf-8.",
/*  9 */ "It is recommended that you set the codepage to utf-8 in this case to avoid data loss!",
/* 10 */ " "
    ].

    if param1 = ? then assign param1 = "".
    if param2 = ? then assign param2 = "".
    
    if s_1st-error = false
     then do:
      assign s_1st-error = TRUE
             user_env[34] = "true".
      output stream s_stm_errors to ds_upd.e.
      output stream s_stm_errors close.
      end.
    output stream s_stm_errors to ds_upd.e append.
    PUT stream s_stm_errors unformatted
              SUBSTITUTE(err-msg[error-nr],param1,param2)  skip.
    PUT STREAM s_stm_errors UNFORMATTED "" SKIP.

    output stream s_stm_errors close.
end.  /* error_handling */

/*------------------------------------------------------------------*/
/* Get the list of components of: "FUNC1(f1,N)+FUNC2(f2)+f3 as:     */
/* f1+f2+f3. retunr ? for errors.                                   */
PROCEDURE extract_comp_names:
define INPUT  PARAMETER src             as character no-undo.
define OUTPUT PARAMETER trgt            as character no-undo.

define variable left_par                as integer   no-undo.
define variable right_par               as integer   no-undo.
define variable begin_replace           as integer   no-undo.
define variable to_replace              as integer   no-undo.
define variable comma                   as integer   no-undo.
define variable fld_delim               as integer   no-undo.
define variable fld_len                 as integer   no-undo.
define variable fld_name                as character no-undo.
define variable blnk                    as integer   no-undo.

IF INDEX(src, "(") = 0
 then do:
  trgt = src.
  RETURN.
  end.

REPEAT:
  left_par = INDEX(src, "(").
  if left_par = 0 then LEAVE.
  right_par = INDEX(src, ")").
 
  if right_par = 0
   then do:
    trgt = ?. 
    RETURN.
    end.
 
  assign
    begin_replace = R-INDEX( SUBSTRING(src, 1, left_par, "raw"), "+") + 1
    comma = INDEX(src, ",").
 
  if right_par = 0
   then do:
    trgt = ?.
    RETURN.
    end.
 
  assign
    fld_delim  = ( if (right_par < comma OR comma = 0)
                     then right_par
                     else comma
                 )
    fld_len    = fld_delim - left_par - 1
    fld_name   = SUBSTRING(src, left_par + 1, fld_len, "character")
    blnk       = INDEX(fld_name, " ")
    fld_name   = ( if blnk = 0
                     then fld_name 
                     else TRIM(fld_name)
                 )
    to_replace = right_par - begin_replace + 1
    SUBSTRING(src, begin_replace, to_replace, "character") = fld_name.
  
  end.   /* repeat */
 
assign trgt = src.
RETURN.
 
end PROCEDURE.

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

assign
  batch-mode   = SESSION:BATCH-MODE
  edbtyp       = {adecomm/ds_type.i
                   &direction = "itoe"
                   &from-type = "user_dbtype"
                   }
  l_char-types = "CHAR,VARCHAR,BINARY,VARBINARY,NCHAR,NVARCHAR,ROWGUID"
  l_chrw-types = "LONGVARBINARY,LONGVARCHAR,NLONGVARCHAR,TIME"
  l_date-types = "DATE"
  l_dcml-types = "DECIMAL,NUMERIC"
  l_floa-types = "DOUBLE,FLOAT,REAL"
  l_i###-types = ""
  l_i##d-types = "BIGINT"
  l_i##l-types = ""
  l_i#dl-types = "INTEGER,SMALLINT,TINYINT"
  l_logi-types = "BIT"
  l_time-types = ""
  l_tmst-types = "TIMESTAMP,TIMESTAMP-TZ"
  .

IF NUM-ENTRIES(user_env[25]) = 12
   THEN ASSIGN
     s_datetime = LOGICAL(ENTRY(6,user_env[25]))
     s_primary = LOGICAL(ENTRY(7,user_env[25]))
     s_lob = LOGICAL(ENTRY(8,user_env[25]))
     s_blobtype = LOGICAL(ENTRY(9,user_env[25]))
     s_clobtype = LOGICAL(ENTRY(10,user_env[25]))
     ClustAsROWID = LOGICAL(ENTRY(11,user_env[25]))
     s_best = INTEGER(ENTRY(12,user_env[25])).


IF NOT batch-mode then assign SESSION:IMMEDIATE-DISPLAY = yes.

RUN adecomm/_setcurs.p ("WAIT").

IF user_env[37] = "PP" THEN DO:
    assign ClustAsROWID = TRUE.
    ASSIGN mssselBestRowidIdx = (ENTRY(4,user_env[36]) = "y").
    ASSIGN s_best = (IF mssselBestRowidIdx THEN  INTEGER(ENTRY(5,user_env[36])) ELSE 0 ).
    ASSIGN mssrecidCompat = (ENTRY(3,user_env[36]) = "y").
    if user_env[12] = "datetime" then mapmssdatetime = TRUE.
    else  mapmssdatetime = FALSE.

    IF ((NUM-ENTRIES(user_env[42]) >= 2) AND
        UPPER(ENTRY(2,user_env[42])) <> "L" ) THEN
      assign useLegacyRanking = FALSE.
END.
ELSE DO:
    assign ClustAsROWID = s_primary.
          /* s_best = 1 (OE Schema )
                    = 2 (Foreign Schema)
           */
    assign mssrecidCompat = s_recidcompat
           mapmssdatetime = s_datetime.
    IF s_primary OR s_recidcompat THEN assign useLegacyRanking = FALSE.
    /* Indicate to runtime that this is an independent PULL */
    DO TRANS:
     RUN STORED-PROC DICTDBG.SendInfo ("msspul-init").
    END.
END.

assign
  cache_dirty = TRUE
  user_env    = "" /* yes this is destructive, but we need the -l space */
  l_dt        = ?
  l_tmp       = (if s_datetime then "datetime_default" else ?).

if s_lob then do:
  assign l_tmp = (if s_datetime then l_tmp + ",lob_default" else ",lob_default").

  if s_clobtype and s_blobtype then 
    assign l_tmp = l_tmp + ",clob_default,blob_default" .
  else if s_clobtype and not s_blobtype then 
    assign l_tmp =  l_tmp + ",clob_default" .
  else if s_blobtype and not s_clobtype then 
    assign l_tmp =  l_tmp + ",blob_default" .
end.

RUN prodict/mss/_mss_typ.p
  ( INPUT-OUTPUT i,
    INPUT-OUTPUT i,
    INPUT-OUTPUT l_tmp,
    INPUT-OUTPUT l_dt,
    OUTPUT       l_dt
    ). /* fills user_env[11..17] with datatype-info */
/* Get the name of the foreign dbms and set the foreign_dbms name */
    define variable foreign_dbms            as character no-undo.

    RUN STORED-PROC DICTDBG.GetInfo (0).
    for each DICTDBG.GetInfo_buffer:
       assign foreign_dbms = ( DICTDBG.GetInfo_buffer.dbms_name )
              foreign_dbms_version = INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2))
              ds_clnt_vers = DICTDBG.GetInfo_buffer.prgrs_clnt
              ds_srvr_vers = DICTDBG.GetInfo_buffer.prgrs_srvr.
    end.

    CLOSE STORED-PROC DICTDBG.GetInfo.

find DICTDB._Db where RECID(_Db) = drec_db NO-LOCK.

/* Create a procedure for pulling constraints */
RUN prodict/mss/procbfrpul.p.

assign
  bug1  = can-do(_Db._Db-misc2[4], "1")
  bug4  = can-do(_Db._Db-misc2[4], "4")
  bug7  = can-do(_Db._Db-misc2[4], "7")
  bug8  = can-do(_Db._Db-misc2[4], "8")
  bug19 = can-do(_Db._Db-misc2[4], "19")
  bug22 = can-do(_Db._Db-misc2[4], "22")
  bug28 = can-do(_Db._Db-misc2[4], "28")
  bug29 = can-do(_Db._Db-misc2[4], "29")
  bug34 = can-do(_Db._Db-misc2[4], "34")
  quote = SUBSTRING(_Db._Db-misc2[3],2,1, "character")
  quote = ( if (quote = " " OR bug7)
                then ""
                else quote
          )
  escp  = SUBSTRING(_Db._Db-misc2[3],1,1, "character")
  escp  = ( if (escp = " ")
                then ""
                else escp
          ).

if bug22 then RUN error_handling(6, "", "").
if bug34 then escp = "".

/*---------------------------- MAIN-LOOP ---------------------------*/
/* just in case some garbage left over */
for each s_ttb_tbl: delete s_ttb_tbl. end.
for each s_ttb_fld: delete s_ttb_fld. end.
for each s_ttb_idx: delete s_ttb_idx. end.
for each s_ttb_idf: delete s_ttb_idf. end.
for each s_ttb_con: delete s_ttb_con. end.

_crtloop:
for each gate-work
  where gate-work.gate-slct = TRUE:
  
  /* Skip pseudo-entry, which is needed to signal, if user wants to 
   * compare not just <DS> -> PROGRESS, but also the other direction
   */
  if gate-work.gate-type = "PROGRESS" then next.

   /* This is for MS SQL 7 causing GPF when schema tables are pulled */
  IF gate-work.gate-user = "INFORMATION_SCHEMA" THEN
    NEXT.
  

  assign
    has_id_ix          = no
    namevar   = ( if      gate-work.gate-type = "BUFFER"
                   then "_" + gate-work.gate-type /* coud be lower-case */
                      + "_" + gate-work.gate-name
                  else if gate-work.gate-type <> "SEQUENCE"
                   then            gate-work.gate-name
                  else if asc(substring(gate-work.gate-type,1,1,"character")) = 115
		    then LC(gate-work.gate-seqpre) + gate-work.gate-name
                  else gate-work.gate-seqpre + gate-work.gate-name
                )
    typevar   = ( if gate-work.gate-type = "BUFFER"
                   then "VIEW"
                   else ENTRY(LOOKUP(gate-work.gate-type,pobjects),sobjects)
                )
    uservar   = gate-work.gate-user
    progvar   = gate-work.gate-prog
    spclvar   = ( if  gate-work.gate-qual = ""
                   then "%"
                   else gate-work.gate-qual
                ).
    
  if batch-mode and logfile_open
   then put STREAM logfile unformatted
     gate-work.gate-type at 16
     gate-work.gate-user at 32
     gate-work.gate-name at 45 skip.

  RUN  prodict/mss/mss_fix.p (spclvar, OUTPUT spclvar-1, escp, bug1).
  RUN  prodict/mss/mss_fix.p (uservar, OUTPUT uservar-1, escp, bug8).
  RUN  prodict/mss/mss_fix.p (namevar, OUTPUT namevar-1, escp, no).
  RUN  prodict/mss/mss_fix.p (typevar, OUTPUT typevar-1, escp, no).
  assign typevar-1 = "'" + typevar-1 + "'". 
  
  IF gate-work.gate-type <> "PROCEDURE" THEN DO:
  
    /*-------------------------- SEQUENCES -----------------------------*/
 
    IF ( gate-work.gate-type = "SEQUENCE" )  
    THEN DO:  /* gate-work.gate-type = "SEQUENCE" */

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

 IF ( gate-seqpre = "_SEQT_REV_" OR gate-seqpre = "_SEQT_" ) THEN DO: 

      create s_ttb_seq.
      assign
        gate-work.ttb-recid = RECID(s_ttb_seq)
        s_ttb_seq.ds_name   = namevar /* used to be progvar, but:
                                     * progvar could be <> namevar
                                     * in case of name-collisions */
        s_ttb_seq.ds_user   = uservar
        s_ttb_seq.ds_spcl   = uservar + ","
                          + ( if asc(substring(gate-work.gate-type
                                              ,1
                                              ,1
                                              ,"character"
                                    )         )  =  115
                                then "_seqp_"
                                else "_SEQP_" 
                            )
                          + substr(namevar,7,-1,"character") + ","
			  + "@op" + "," + "@val" + ","
        s_ttb_seq.gate-work = RECID(gate-work)
        s_ttb_seq.pro_name  = progvar.

     END.
      ELSE DO: 
          FIND s_ttb_ntvseq where TRIM(s_ttb_ntvseq.seqname) = trim(namevar)  
                       AND  trim(s_ttb_ntvseq.schname) = trim(uservar) NO-LOCK NO-ERROR. 
          DO i = 1 TO 9999 WHILE can-find(FIRST s_ttb_seq where s_ttb_seq.pro_name = progvar):
             progvar = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") + STRING(- i).
      	  end.

          create s_ttb_seq.
            ASSIGN
            gate-work.ttb-recid     = RECID(s_ttb_seq)
            s_ttb_seq.ds_attr64     = true
            s_ttb_seq.fdbname       = s_ttb_ntvseq.fdbname
            s_ttb_seq.ds_user       = s_ttb_ntvseq.schname
            s_ttb_seq.ds_type       = s_ttb_ntvseq.seqtype
            s_ttb_seq.ds_name       = s_ttb_ntvseq.seqname
    	    s_ttb_seq.ds_datatype   = s_ttb_ntvseq.datatype
	    s_ttb_seq.ds_prec       = s_ttb_ntvseq.precision
	    s_ttb_seq.ds_scale      = s_ttb_ntvseq.scale
            s_ttb_seq.ds_init       = s_ttb_ntvseq.startvalue
            s_ttb_seq.ds_min        = s_ttb_ntvseq.minvalue
            s_ttb_seq.ds_max        = s_ttb_ntvseq.maxvalue
	                             /* ( if s_ttb_ntvseq.maxvalue > (IF is-pre-101b-db THEN 2147483647 ELSE 9223372036854775807)
                                      then ? else s_ttb_ntvseq.maxvalue ) */
            s_ttb_seq.ds_incr       = s_ttb_ntvseq.increment
            s_ttb_seq.ds_cycle      = s_ttb_ntvseq.iscycle 
	    s_ttb_seq.ds_cache      = s_ttb_ntvseq.cachesize
            s_ttb_seq.gate-work     = RECID(gate-work)
            s_ttb_seq.ds_spcl       = s_ttb_seq.fdbname + "," + s_ttb_seq.ds_name + "," + "@op" + "," + "@val" + ","
            s_ttb_seq.ds_natspcl    = s_ttb_seq.fdbname + "," + s_ttb_seq.ds_name + "," + "@op" + "," + "@val" + ","  + s_ttb_seq.ds_user + ","
	    s_ttb_seq.pro_name      = progvar.
   END. 

	if TERMINAL <> "" and NOT batch-mode
        then DISPLAY 
          namevar @ msg[1]   ""   @ msg[4]
          progvar @ msg[2]   ""   @ msg[5]
          ""      @ msg[3]   ""   @ msg[6]
          with frame ds_make.

     NEXT.
  end.  /* gate-work.gate-type = "SEQUENCE" */


    /*---------------------------- TABLES ------------------------------*/

    RUN STORED-PROC DICTDBG.GetInfo (0).
    for each DICTDBG.GetInfo_buffer:
      assign doextent = ( DICTDBG.GetInfo_buffer.do_extent = "Y" ).
    end.
    CLOSE STORED-PROC DICTDBG.GetInfo.

    RUN STORED-PROC DICTDBG.SQLTables
                 (spclvar-1, uservar-1, namevar-1, typevar-1).
    for each DICTDBG.SQLTables_buffer:

      /* 20031205-003
         If the table name has underscore (_), we may get records for
         different tables, since '_' may be a search pattern depending on
         the driver settings/version. So we need to filter out anything
         that is not the table we are looking for.
      */
      IF TRIM(DICTDBG.SQLTables_buffer.name) NE ? AND 
         trim(namevar-1) NE TRIM(DICTDBG.SQLTables_buffer.name) THEN
         NEXT.

      assign
        table_name = ( if TRIM(DICTDBG.SQLTables_buffer.name) = ?
                        then "%"
                        else TRIM(DICTDBG.SQLTables_buffer.name)
                   )
        table_spcl = ( if TRIM(DICTDBG.SQLTables_buffer.qualifier) = ?
                        then "%"
                        else TRIM(DICTDBG.SQLTables_buffer.qualifier)
                   )
        table_type = ( if TRIM(DICTDBG.SQLTables_buffer.type) = ?
                        then "%"
                        else TRIM(DICTDBG.SQLTables_buffer.type)
                   )
        table_user = ( if TRIM(DICTDBG.SQLTables_buffer.owner) = ?
                        then "%"
                        else TRIM(DICTDBG.SQLTables_buffer.owner)
                   ).

    end.

    CLOSE STORED-PROC DICTDBG.SQLTables.

    create s_ttb_tbl.

    assign
      gate-work.ttb-recid = RECID(s_ttb_tbl)
      s_ttb_tbl.ds_name   = table_name
      s_ttb_tbl.ds_recid  = 0
      s_ttb_tbl.ds_spcl   = ( if (table_spcl = "%" OR bug1) 
                             then ?
                             else table_spcl
                          )
      s_ttb_tbl.ds_type   =  gate-work.gate-type
      s_ttb_tbl.ds_user   = ( if table_user = "%" or bug28
                             then ?
                             else table_user 
                          )
      s_ttb_tbl.gate-work = RECID(gate-work)
      s_ttb_tbl.pro_desc  = ( if table_comment <> ""
                             then table_comment 
                             else s_ttb_tbl.pro_desc
                          )                               
      s_ttb_tbl.pro_name  = gate-work.gate-prog.
 
    if TERMINAL <> "" and NOT batch-mode
    then DISPLAY
      namevar @ msg[1]  "" @ msg[4]
      progvar @ msg[2]  "" @ msg[5]
      ""      @ msg[3]  "" @ msg[6]
      with frame ds_make.

    /* there is a bug in the ODBC-Driver. The stored-procedure GetFieldIds
     * chokes on Tables with no fields. We know that SysGams doesn't have
     * any fields, so we end the processing for SysGams right here. In case
     * this bug gets fixed by the ODBC-Driver supplier, we can just remove 
     * this comment plus the next statment.         (hutegger 95/05)
    */


    if gate-work.gate-name = "sysgams" then NEXT.
  
    /*---------------------------- FIELDS ------------------------------*/

    assign
    /* Get the ordinal number of fields in the table.		*/
      table_spcl_1 = ( if (spclvar-1 = "%" or spclvar-1 = ?)
                            then ""
                            else spclvar
                        )
      spcl_len         = length(table_spcl_1)
 
      table_user_1     = ( if (uservar-1 = "%" or uservar-1 = ?)
                            then ""
                            else uservar
                        )
      user_len         = length(table_user_1)


      dot1              = ( if table_spcl_1 = ""
                            then ""
                            else ( if bug34 
                                     then ":"
                                     else "."
                                 )
                        )

      dot2              = ( if (table_spcl_1 <> "" OR table_user_1 <> "")
                            then "."
                            else ""
                        )
      table_len          = length(table_name)

      full_table_name   = table_spcl_1 + dot1
		      + table_user_1 + dot2 + table_name
      shadow_col        = -1
      array_name        = "".

    /* 20000 is just an arbitrary # since we dont have a _file-number yet.*/
    RUN STORED-PROC DICTDBG.GetFieldIds 
                (s_ttb_tbl.pro_name, full_table_name, 20000, spcl_len,
                 user_len, table_len).

    assign i = 1.
    _loop:
    for each DICTDBG.GetFieldIds_buffer:

      IF DICTDBG.GetFieldIds_buffer.field-name BEGINS '_PROGRESS_RECID' OR
         DICTDBG.GetFieldIds_buffer.field-name BEGINS '_PROGRESS_ROWID' OR
         DICTDBG.GetFieldIds_buffer.field-name BEGINS 'PROGRESS_RECID' OR
         DICTDBG.GetFieldIds_buffer.field-name BEGINS 'PROGRESS_ROWID' THEN DO: 

         IF s_ttb_tbl.ds_recid = 0 THEN DO:
         IF (NOT DICTDBG.GetFieldIds_buffer.field-name BEGINS 'PROGRESS_RECID_UNIQUE') OR
             mssrecidCompat THEN s_ttb_tbl.ds_recid = i.
           ASSIGN s_ttb_tbl.ds_msc23 = DICTDBG.GetFieldIds_buffer.field-name.
           IF isComputed(full_table_name, DICTDBG.GetFieldIds_buffer.field-name) THEN DO:
             IF s_ttb_tbl.ds_msc22 = ? THEN 
               ASSIGN s_ttb_tbl.ds_msc22 = "".
             ASSIGN s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22 + string(i) + ",".
             /* If PROGRESS_RECID column uses computed column feature, then */
             /* check if the dictionary version in _db-misc2[7] is version, i.e 'odbc-dict-ver' */
             /* and modify the dictionary version to 'odbc-dict-ver-new' */
             IF NOT change-dict-ver AND INDEX(_Db._Db-misc2[7], odbc-dict-ver) <> 0 THEN 
               change-dict-ver = TRUE.
           END.
           i = i + 1.
         END.
         ELSE IF SUBSTRING(DICTDBG.GetFieldIds_buffer.field-name,
              (LENGTH(DICTDBG.GetFieldIds_buffer.field-name) - 6)) = "_IDENT_"
           THEN DO:
           IF s_ttb_tbl.ds_msc22 = ? THEN 
             ASSIGN s_ttb_tbl.ds_msc22 = "".
           ASSIGN s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22 + string(i) + ","
                  i = i + 1.
        END.
         ELSE IF SUBSTRING(DICTDBG.GetFieldIds_buffer.field-name,
              (LENGTH(DICTDBG.GetFieldIds_buffer.field-name) - 4)) = "_ALT_"
            /* OE00211239 : The logic to identify the PROGRES_RECID as 
            * "computed column" is based on the SQL function COLUMNPROPERTY 
            * which returns false for a computed column in SQL view, hence 
            * we end up not putting RPOGRESS_RECID  column in the comma 
            * separated list of FILMISC2,2. Since function isComputed(..) 
            * always return false for computed column in case of VIEW  
            * and there is no other mechanism/interface to determine if a 
            * column is computed in a SQL view, The idea is that if column 
            * PROGRESS_RECID_ALT is present in a view due to virtue of 
            * computed column PROGRESS_RECID functionality then we would 
            * refresh the comma separated list of PROGRESS_RECID columns 
            * by appending the PROGRESS_RECID field position in the existing 
            * list. 
	    */  
           THEN do:
           IF s_ttb_tbl.ds_type NE "VIEW"
              THEN DO:   
                IF s_ttb_tbl.ds_msc22 = ? THEN 
                ASSIGN s_ttb_tbl.ds_msc22 = "".
                ASSIGN s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22 + string(i) + ","
                i = i + 1.
              END.
              ELSE DO:
                IF s_ttb_tbl.ds_msc22 = ? THEN 
                ASSIGN s_ttb_tbl.ds_msc22 = "".
                ASSIGN s_ttb_tbl.ds_msc22 = string(s_ttb_tbl.ds_recid) + "," 
                       + s_ttb_tbl.ds_msc22 + string(i) + ","
                i = i + 1.
              END.
          END.
        NEXT _loop.
      END.  
      CREATE column-id.
      assign
        column-id.col-name = TRIM(DICTDBG.GetFieldIds_buffer.field-name)
        column-id.col-id   = i
        i                  = i + 1.

        /* Shave the quotes off.                                          */
      if (LENGTH(quote, "character") = 1) AND SUBSTRING(column-id.col-name,1,1) = quote
       then assign
         column-id.col-name = SUBSTRING(column-id.col-name
                                 ,2
                                 ,LENGTH(column-id.col-name, "character") - 2
                                 , "character"
                                 ).

    end.  /*  for each DICTDBG.GetFieldIds_buffer */

    /* if there are any doubled-up quotes, replace them with one quote */
    dq_index = index(column-id.col-name, CHR(34) + CHR(34) ).
    REPEAT WHILE dq_index > 0:
         ASSIGN 
           SUBSTRING(column-id.col-name, dq_index, 2, "character") = CHR(34)
           dq_index = index(column-id.col-name, CHR(34) + CHR(34)). 
    END.

    CLOSE STORED-PROC DICTDBG.GetFieldIds.
    RUN  prodict/mss/mss_fix.p (table_spcl, OUTPUT spclvar-1, escp, bug1).
    RUN  prodict/mss/mss_fix.p (table_user, OUTPUT uservar-1, escp, bug8).
    RUN  prodict/mss/mss_fix.p (table_name, OUTPUT namevar-1, escp, no).
    RUN STORED-PROC DICTDBG.SQLColumns (spclvar-1, uservar-1, namevar-1, ?).

    assign field-position = 0
           warn_tablename = ?.

    for each DICTDBG.SQLColumns_buffer:

      /* 20031205-003
         If the table name has underscore (_), we may get records for
         different tables, since '_' may be a search pattern depending on
         the driver settings/version. So we need to filter out anything
         that is not from the table we want.
       */
      IF TRIM(namevar-1) NE TRIM(DICTDBG.SQLColumns_buffer.name) THEN
         NEXT.

      IF DICTDBG.SQLColumns_buffer.column-name begins "PROGRESS_RECID" 
       THEN DO:

         IF DICTDBG.SQLColumns_buffer.data-type = 4 /* int */ 
          THEN
            s_ttb_tbl.ds_msc15 = 1.
         IF DICTDBG.SQLColumns_buffer.data-type = -5 /* bigint */
          THEN
            s_ttb_tbl.ds_msc15 = 2.
      END.

      find first column-id
         where column-id.col-name = TRIM(DICTDBG.SQLColumns_buffer.column-name) NO-ERROR.

      IF NOT AVAILABLE column-id THEN NEXT.     
      assign field-position = column-id.col-id.
      
      assign
        fld-remark     = DICTDBG.SQLColumns_buffer.remarks
        fld-properties = "".
     

      if can-do (fld-properties, "P")
        then assign
          s_ttb_tbl.ds_recid = field-position
          s_ttb_tbl.ds_msc23 = TRIM(DICTDBG.SQLColumns_buffer.column-name). 

      if can-do (fld-properties, "S") OR 
        DICTDBG.SQLColumns_buffer.column-name BEGINS "_S#_"
         then do:
        assign
          shadow_col      = field-position
          shadow_col_name = ( if LENGTH(quote, "character") = 1
                               then quote + column-id.col-name + quote
                               else column-id.col-name
                          ).

        NEXT.
      end.

      if can-do (fld-properties, "N") then do:
        if s_ttb_tbl.ds_msc22 = ?
           then assign s_ttb_tbl.ds_msc22 = "".
        assign s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22
				        + STRING(field-position) + ",".
      end.

      if can-do (fld-properties, "I") then NEXT.

      if   LENGTH (array_name, "character") >    0 
              and TRIM(DICTDBG.SQLColumns_buffer.column-name) BEGINS array_name
              then NEXT.

      do:
        { prodict/mss/mss_typ.i DICTDBG.SQLColumns_buffer.data-type  bug29 }
        ASSIGN m1 = 0.
               isUnicodeType = (DICTDBG.SQLColumns_buffer.data-type <= -8 
                                AND DICTDBG.SQLColumns_buffer.data-type >= -10).

        IF l_dt <> "UNDEFINED" THEN DO:
           IF isUnicodeType THEN DO:
              /* if any of the types below are returned as unicode types, this is not the
                 right driver and we won't support it.
              */
              IF CAN-DO("date,time,datetime2,datetimeoffset", trim(DICTDBG.SQLColumns_buffer.type-name)) THEN
                  l_dt = "UNDEFINED".
           END.
           ELSE IF foreign_dbms_version > 9 THEN DO:
               /* don't support these types either - new in MSS 2008. 
                  (foreign_dbms_version = 10). If using an unsupported driver, 
                  they came through as varbinary, so we have to block them here.
               */
               IF CAN-DO("GEOMETRY,GEOGRAPHY", trim(DICTDBG.SQLColumns_buffer.type-name)) THEN
                   l_dt = "UNDEFINED".
            END.
        END.

        IF l_dt = "UNDEFINED" THEN DO:

          RUN error_handling
            ( 2, 
              s_ttb_tbl.ds_name, "" 
            ).
          RUN error_handling ( 3, "", "" ).

          FOR EACH s_ttb_fld WHERE s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):
            DELETE s_ttb_fld.
          END.
          DELETE s_ttb_tbl.
          CLOSE STORED-PROC DICTDBG.SQLColumns.
          FOR EACH column-id:
            DELETE column-id.
          END.
          NEXT _crtloop.
        END.
        /* if not SQL Server 2005 and up, give warning message on Unicode data types -8,-9,-10 */
        ELSE IF foreign_dbms_version < 9 AND isUnicodeType THEN DO:
            /* display message only once per table */
            IF warn_tablename NE s_ttb_tbl.ds_name THEN DO:
               ASSIGN warn_tablename = s_ttb_tbl.ds_name.
               /* WARNING: Table &1 has Unicode data type, which is supported only with MS SQL Server 2005 and up */
               RUN error_handling(7, s_ttb_tbl.ds_name, "").
            END.
        END.
        ELSE IF isUnicodeType THEN DO:
            IF DICTDB._Db._Db-xl-name NE "utf-8" AND NOT warn_codepage THEN DO:
               /* warn the user about the codepage mismatch */
               RUN error_handling(8, s_ttb_tbl.ds_name, "").
               RUN error_handling(9, "", "").
               ASSIGN warn_codepage = TRUE.
            END.
        END.

        if TRIM(DICTDBG.SQLColumns_buffer.column-name) MATCHES "*##1"
          and doextent then do:  /* Collect array elements & determine extent */

	      ASSIGN    m1         = 1
	                i          = LENGTH (TRIM(DICTDBG.SQLColumns_buffer.column-name), "character") - 1
	                array_name = SUBSTR (TRIM(DICTDBG.SQLColumns_buffer.column-name), 1, i, "character").

          RUN  prodict/mss/mss_fix.p
                 (table_spcl, OUTPUT spclvar-1,  escp, bug1).
          RUN  prodict/mss/mss_fix.p 
                (table_user,  OUTPUT uservar-1, escp, bug8).
          RUN  prodict/mss/mss_fix.p                              
                (table_name,  OUTPUT namevar-1,  escp, no).


          RUN STORED-PROC DICTDBG.SQLColumns A_proc_handle = PROC-HANDLE
		       (spclvar-1, uservar-1, namevar-1, ?).

	      for each A_col where PROC-HANDLE = A_proc_handle:

           /* 20031205-003
              If the table name has underscore (_), we may get records for
              different tables, since '_' may be a search pattern depending on
              the driver settings/version. So we need to filter out anything
              that is not from the table we want.
           */
           IF TRIM(namevar-1) NE TRIM(A_col.name) THEN
              NEXT.

	        if NOT A_col.column-name BEGINS array_name then NEXT.
	        assign m2 = INTEGER (SUBSTR (A_col.column-name
	                              , i + 1
	                              , LENGTH (A_col.column-name
	                                       , "character") - i
	                              , "character"
	                       )      ).
	        if m2 > m1 then assign m1 = m2.

	      end. /* EACH A_col */
	  
	      CLOSE STORED-PROC DICTDBG.SQLColumns where PROC-HANDLE = A_proc_handle.

        end. /* Collect array elements & determine extent */

        { prodict/mss/mss_pul.i 
           &data-type    = "l_dt"
           &order-offset = "4000"  /* make sure we go well beyond the end */
           &extent       = "m1"
        }

      end. /* DO */

      /* OE00162531: adding identity fields to non-updatable list */
      /* OE00181255: adding timestamp fields to non-updatable list */
      /* OE00183878: adding ROWGUID fields to non-updatable list */
      if DICTDBG.SQLColumns_buffer.column-name BEGINS "PROGRESS_RECID"
      then .
      else if ((s_ttb_fld.ds_msc24 EQ "identity") OR 
               (s_ttb_fld.ds_msc24 EQ "timestamp") OR
               (s_ttb_fld.ds_type = "ROWGUID") OR 
               isComputed(full_table_name, DICTDBG.SQLColumns_buffer.column-name)) THEN DO:
        if s_ttb_tbl.ds_msc22 = ? then 
           assign s_ttb_tbl.ds_msc22 = "".
        s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22 + string(s_ttb_fld.ds_stoff) + ",".
      end.

      if shadow_col > 0 then 
        assign s_ttb_fld.pro_case = FALSE  
               s_ttb_fld.ds_shd#  = shadow_col
               s_ttb_fld.ds_shdn  = shadow_col_name
               shadow_col         = -1
               shadow_col_name    = ? .
      ELSE IF DICTDB._Db._Db-Misc1[1] = 1 THEN
          ASSIGN s_ttb_fld.pro_case = FALSE.

    end.      /* for each SQLColumns_buffer */
    
    CLOSE STORED-PROC DICTDBG.SQLColumns.			
				    
    /*----------------------------- INDEXES ------------------------------*/

    RUN  prodict/mss/mss_fix.p (table_spcl, OUTPUT spclvar-1, ?, bug1).
    RUN  prodict/mss/mss_fix.p (table_user, OUTPUT uservar-1, ?, bug8).
    RUN  prodict/mss/mss_fix.p (table_name, OUTPUT namevar-1, ?, no).

    RUN STORED-PROC DICTDBG.SQLStatistics(spclvar-1, uservar-1, namevar-1).
 
    assign
      indn         = 1
      unique-prime = NO
      has_recid_idx = NO
      rowid_idx_name = ?.

    for each DICTDBG.SQLStatistics_buffer:
      IF DICTDBG.SQLStatistics_buffer.index-name BEGINS 'PKCE_' THEN NEXT.   
      /* Eliminate recid index and recid field */
      IF DICTDBG.SQLStatistics_buffer.index-name MATCHES '*progress_recid*' OR
         DICTDBG.SQLStatistics_buffer.Column-name MATCHES '*prgs_recid*' OR      
         DICTDBG.SQLStatistics_buffer.Column-name MATCHES '*progress_recid*'  THEN DO:
          /* just remember if we've found the index for the recid field */
          IF DICTDBG.SQLStatistics_buffer.index-name MATCHES '*progress_recid*' THEN DO:
             ASSIGN has_recid_idx = YES.
             IF DICTDBG.SQLStatistics_buffer.index-name MATCHES '*progress_recid' 
                AND DICTDBG.SQLStatistics_buffer.non-unique = 1 THEN 
                    rowid_idx_name = DICTDBG.SQLStatistics_buffer.index-name. 
          END.
          ELSE DO:
             /* flag proxy_key for surrogate key present in an index.
              * If the flag is ON, the the index cannot serve as 
              * RECID compatible index.
              */ 
             IF useLegacyRanking <> TRUE THEN DO:
                IF DICTDBG.SQLStatistics_buffer.Column-name MATCHES 
                                                 '*progress_recid*' THEN
                   /* ASSIGN s_ttb_idx.ds_msc21 = "v". */ /*force uniqueness*/
                   ASSIGN s_ttb_idx.proxy_key = TRUE.
             END.
          END.
          NEXT.
      END.
.
      /* Skip TBALE statistics.						*/
      if DICTDBG.SQLStatistics_buffer.type = 0 OR bug22 then NEXT. 
      
      assign comp-name   = DICTDBG.SQLStatistics_buffer.Column-name.

      if bug4 then do:
        RUN extract_comp_names 
          ( INPUT  comp-name,
            OUTPUT temp-comp-name
          ).
        RUN prodict/mss/mss_qe.p
          ( INPUT-OUTPUT temp-comp-name,
            OUTPUT comp-num
           ).
        assign comp-name = temp-comp-name.
      end.
      else assign comp-num = 1.

      REPEAT comp-ind = 1 to comp-num:

        find first s_ttb_fld 
          where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
            and   s_ttb_fld.ds_name = TRIM(ENTRY(comp-ind, comp-name)) 
          no-lock no-error.
        if NOT available s_ttb_fld then do:  /*  NOT available s_ttb_fld */

           find first column-id 
            where column-id.col-name = TRIM(ENTRY(comp-ind, comp-name))
    	     no-error.

           find first s_ttb_fld
            where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
              and   s_ttb_fld.ds_shd# = column-id.col-id
    	       no-lock no-error.

    	   IF NOT available s_ttb_fld then do: 
    	     /* If not PROGRESS RECID field - complain. */
	     if s_ttb_tbl.ds_recid <> column-id.col-id
	       then RUN error_handling(1, comp-name, "").
               /*WARNING: Column &1 is hidden; it cannot be an index component*/
	     else if DICTDBG.SQLStatistics_buffer.seq-in-index = 1
	              and (DICTDBG.SQLStatistics_buffer.non-unique = 0 OR bug19)
	         then	has_id_ix = yes. /* progress_recid has a unique index */
    	     NEXT.
	   end.        
        end.     /*  NOT available where s_ttb_fld */

        if NOT available s_ttb_idx
           OR s_ttb_idx.ds_name <> TRIM(DICTDBG.SQLStatistics_buffer.index-name)
           OR s_ttb_idx.ttb_tbl <> RECID(s_ttb_tbl)
              then do:  /* index non-existent -> create new index */

           if TERMINAL <> "" and NOT batch-mode
            then DISPLAY
                TRIM(DICTDBG.SQLStatistics_buffer.name) @ msg[5] 
                user_env[1]                             @ msg[6]
                with frame ds_make.

           {prodict/gate/gat_puli.i
              &for-idx-name = "SQLStatistics_buffer.index-name"
              &for-idx-nam2 = "SQLStatistics_buffer.index-name"
              &for-obj-name = "SQLStatistics_buffer.index-name"
              &frame        = "ds_make"
              &idx-uniq-cond = "(bug19
                          OR DICTDBG.SQLStatistics_buffer.non-unique = 0)"
            }                                  /* try to recreate index */

           ASSIGN s_ttb_idx.ds_idx_typ = SQLStatistics_buffer.type.
        end.     /* index non-existent -> create new index */


     /*-------------------------- INDEX-FIELDS --------------------------*/

        CREATE s_ttb_idf.
        ASSIGN s_ttb_idf.pro_abbr  = FALSE
               s_ttb_idf.pro_order = ( if bug4 and comp-num > 1
                                       then comp-ind
                                       else DICTDBG.SQLStatistics_buffer.seq-in-index
                                     )
               s_ttb_idf.ttb_fld   = RECID(s_ttb_fld)
               s_ttb_idf.ttb_idx   = RECID(s_ttb_idx).
       
        /* Setup the sql statement to determine is a descending index only versions aboove V7 SQL Server */
        ASSIGN tblname = TRIM(DICTDBG.SQLStatistics_buffer.OWNER) + "." + trim(DICTDBG.SQLStatistics_buffer.NAME)
               sqlstate =  "select indid from sysindexes where id = (OBJECT_ID('" + tblname + "')) and name = '" +
                             DICTDBG.SQLStatistics_buffer.index-name + "'". 
        
        /* Get the id number of the index*/
        RUN STORED-PROC DICTDBG.send-sql-statement stph1 = PROC-HANDLE  NO-ERROR ( sqlstate ).

        IF ERROR-STATUS:ERROR THEN DO: /* V7 MS SQL Server can't do this so suppress error and just set isasc = true*/
          ASSIGN isasc = TRUE.        
        END.
        ELSE DO:
          FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = stph1:
            ASSIGN idxidn = INTEGER(proc-text).
          END.
          CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = stph1.

          /* Get the property of the column to see if it is descending */
          ASSIGN sqlstate = "select indexkey_property(OBJECT_ID('" + tblname + "'), " + STRING(idxidn) + ", " + 
                             STRING(DICTDBG.SQLStatistics_buffer.seq-in-index) + ", 'IsDescending')".
          RUN STORED-PROC DICTDBG.send-sql-statement stph2 = PROC-HANDLE NO-ERROR ( sqlstate ).
          IF ERROR-STATUS:ERROR THEN DO: /* V7 MS SQL Server can't do this so suppress error and just set isasc = true*/
            ASSIGN isasc = TRUE.             
          END.
          ELSE DO:
            FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = stph2:
              IF INTEGER(SUBSTRING(proc-text,1,1)) > 0 THEN
                 ASSIGN isasc = FALSE.
              ELSE
                 ASSIGN isasc = TRUE.
            END.
            CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = stph2.
          END.
        END.
        ASSIGN  s_ttb_idf.pro_asc   = isasc.
      end.   /* REPEAT comp-ind = 1 to comp-num */
    
    end.   /* for each DICTDBG.SQLStatistics_buffer */
  
    CLOSE STORED-PROC DICTDBG.SQLStatistics.

    /*-------------------------- SQLSpecialColumns ------------*/
    find first s_ttb_idx 
                where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl) NO-ERROR.
    IF s_best = 2 AND AVAILABLE s_ttb_idx THEN               
    DO:
       FOR EACH s_ttb_splfld: DELETE s_ttb_splfld. END.
       RUN STORED-PROC DICTDBG.SQLSpecialColumns(spclvar-1, uservar-1, namevar-1).
        /* first argument - identifierType = 1 (SQL_BEST_ROWID)
           Fifth argument - Scope =0 (SQL_SCOPE_CURROW)
           Sixth argument - Nullable =0(SQL_NO_NULLS)
        */

       for each DICTDBG.SQLSpecialColumns_buffer:
           CREATE s_ttb_splfld.
           ASSIGN s_ttb_splfld.name  = DICTDBG.SQLSpecialColumns_buffer.Column-name.
       end.    /* for each DICTDBG.SQLSpecialColumns_buffer */

       CLOSE STORED-PROC DICTDBG.SQLSpecialColumns.

     IF CAN-FIND(FIRST s_ttb_splfld) THEN DO:
       for each s_ttb_idx
                where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
         assign found = true.
         for each s_ttb_splfld:
            find first s_ttb_fld
                  where s_ttb_fld.ds_name = s_ttb_splfld.name AND
                        s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl) NO-ERROR.
             
             IF NOT AVAILABLE s_ttb_fld THEN               
             DO:
              assign found = false.
              LEAVE. 
             END.

             find first s_ttb_idf 
                  where s_ttb_idf.ttb_fld = RECID(s_ttb_fld) AND
                        s_ttb_idf.ttb_idx = RECID(s_ttb_idx) NO-ERROR.
             IF NOT AVAILABLE s_ttb_idf THEN               
             DO:
              assign found = false.
              LEAVE. 
             END.
         END.
         IF found THEN LEAVE.
       END.
       if found THEN ASSIGN s_ttb_idx.ds_idx_typ = 2.
     END. /*  CAN-FIND(FIRST s_ttb_splfld)  */
    end.
/*-------------------------- SQLSpecialColumns -----End-------*/

    /* If there is a progress_recid without an index then we gently complain */
    if s_ttb_tbl.ds_recid > 0 AND NOT has_recid_idx /*and not has_id_ix*/ THEN DO:
       FIND FIRST s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl) NO-ERROR.
       IF NOT AVAILABLE s_ttb_idx 
        then do:
           RUN error_handling(5, s_ttb_tbl.ds_msc23, table_name).
       END.
                      /* "WARNING: No index for the RECID &1 field table &2". */
    END.

    /*------- Find a Field which doesn't participate in an index. ------*/

    assign
      s_ttb_tbl.ds_msc13 = ?
      prev-prior         = 0.
    
    for each s_ttb_fld
      where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):

       find first s_ttb_idf 
           where s_ttb_idf.ttb_fld = RECID(s_ttb_fld)
           no-error.
       ASSIGN itype = TRUE.

       if NOT available s_ttb_idf
          and ( s_ttb_tbl.ds_msc22 = ? 
           or    NOT can-do(s_ttb_tbl.ds_msc22,STRING(s_ttb_fld.ds_stoff))
               ) then do:  /* field is possible candidate */

           /*  20040513-022 Don't allow timestamp, text and image fields
               to be selected - set itype to FALSE.
           */
          case s_ttb_fld.ds_type:
	     when "CHAR"          then fld-prior = 4. 
	     when "NUMERIC"       then fld-prior = 3. 
	     when "DECIMAL"       then fld-prior = 3. 
	     when "INTEGER"       then fld-prior = 5. 
	     when "SMALLINT"      then fld-prior = 5. 
	     when "FLOAT"         then fld-prior = 3. 
	     when "REAL"          then fld-prior = 3. 
	     when "DOUBLE"        then fld-prior = 3. 
	     when "VARCHAR"       then fld-prior = 2. 
	     when "LONGVARCHAR"   then itype = FALSE. 
	     when "DATE"          then fld-prior = 5. 
	     when "TIME"          then fld-prior = 5. 
	     when "TIMESTAMP"     then fld-prior = 3. 
	     when "VARBINARY"     then itype = FALSE. 
	     when "LONGVARBINARY" then itype = FALSE. 
	     when "BINARY"        then itype = FALSE. 
	     when "BIGINT"        then fld-prior = 3. 
	     when "TINYINT"       then fld-prior = 5. 
	     when "BIT"           then fld-prior = 5. 
	     OTHERWISE                 fld-prior = 1.
          end case.
          if fld-prior > prev-prior AND itype THEN
            assign
       	         prev-prior         = fld-prior
                 s_ttb_tbl.ds_msc13 = s_ttb_fld.ds_stoff.
       end.     /* field is possible candidate */

    end.  /* for each s_ttb_fld */
    
    /* OE00195067 BEGIN */
    /*----------------------------- Constraints ------------------------------*/

        DEFINE VARIABLE tt-handle1 AS HANDLE.
        tt-handle1 = TEMP-TABLE s_ttb_con:HANDLE.
     
        RUN  prodict/mss/mss_fix.p (table_name, OUTPUT namevar-1, ?, no).
        RUN STORED-PROC DICTDBG._Constraint_Info LOAD-RESULT-INTO tt-handle1 ( namevar-1).

        FOR EACH s_ttb_con WHERE tab_name = namevar-1:
          IF const_name MATCHES "*DF__*" THEN NEXT. 
           IF INDEX(const_name,"##") > 0 
           THEN ASSIGN i = INDEX(const_name, "##") + 2.
           ELSE i = 1.       
             const_name        = substring(const_name,i,-1,"character").
            
           IF INDEX(par_key,"##") > 0 
           THEN ASSIGN i = INDEX(par_key, "##") + 2.
           ELSE i = 1.       
            par_key        = substring(par_key,i,-1,"character"). 
        END.

     /* OE00195067 END */  

    /*--------------------------- RECID-INDEX ----------------------------*/

    /* in Version 7.3 we needed a mandatory integer-field with a unique index
     * on it, to be used for RECID-functionality. Now we are able to use any
     * index, as long as it is unique.
     * In order to grant as much compatibility with previous versions as
     * possible, we now put both the old and the new version's info into
     * the required places. As long as there are indexes of "level" 0 or 4
     * selected, the schema can be used with a V7.3-client.
     * If another index gets selected, we put a message into the error-file
     * The new rules are:
     *    Level  Data-Types                andatory  unique   #(comp) misc2[1]
     *      1    integer only                 yes   &  yes  &   =1      a
     *      2    anything except date|float   yes   &  yes  &   =1      ax
     *      3    anything except float        yes   &  yes  &   =1      ax
     *      4    anything                     yes   &  yes  &   =1      ax
     *      5    integer only                 no    |  no   |   >1      u
     *      6    anything except date|float   no    |  no   |   >1      ux
     *      7    anything except float        no    |  no   |   >1      ux
     *      8    anything except date|float   no    |  no   |   >1      ux
     * a/u := automatically-selectable/user-definable
     * x   := NON V7.3-compatible
     * ( float can't be used for "="; date has some restrictions too )
    */
    if  s_ttb_tbl.ds_recid <= 0
      or s_ttb_tbl.ds_recid  = ?
      then do:  /* no progress_recid -> check indexes for ROWID usability */

         ASSIGN s_ttb_tbl.tmp_recid = RECID(s_ttb_tbl).
         IF useLegacyRanking THEN
            RUN prodict/mss/_clrank.p ( INPUT       s_best,
                                         INPUT        RECID(s_ttb_tbl),
                                         INPUT        ClustAsROWID
                                      ).
         ELSE
            RUN prodict/mss/_cnrank.p ( INPUT       s_best,
                                         INPUT        RECID(s_ttb_tbl),
                                         INPUT        uniquifyAddon,
                                         INPUT        mssrecidCompat,
                                         INPUT        mapmssdatetime,
                                         INPUT        callerid  /* 1-progress ranking , 2-pulled SH ranking */
                                      ).

          /* OE00164266 - set the PROGRESS_RECID size if it is an integer */
          find first s_ttb_fld
           where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
             and   ABSOLUTE(s_ttb_fld.ds_stoff) = ABSOLUTE(s_ttb_tbl.ds_recid)
    	      no-lock no-error.
          IF available s_ttb_fld then do: 
            if s_ttb_fld.ds_type = "INTEGER"
             then
               s_ttb_tbl.ds_msc15 = 1. /* RECID is 4 byte */
            if s_ttb_fld.ds_type = "BIGINT"
             then
               s_ttb_tbl.ds_msc15 = 2. /* RECID is 8 byte */
          END.
    end.     /* no progress_recid -> check indexes for ROWID usability */

    /* PROGRESS-RECID-field -> reset recid-info of all indexes */
    if has_id_ix then 
    for each s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
       assign s_ttb_idx.ds_msc21 = ?.
    end.
      
    for each column-id:
      delete column-id.
    end.

   /* FORCESEEK Implementation- Passing non-unique ROWID name in _Fil-misc2[5] */
   IF foreign_dbms_version GE 10 THEN DO:
   
   /* In case _Fil-misc1[1] contains a value greater than 0, we can safely assume 
   PROGRESS_RECID index is being used for ROWID- assign "progress_recid"  to
   _Fil-misc2[4] since we do not have any index# information for PROGRESS_RECID.
   In case _Fil-misc1[1] contains ? and_Fil-misc1[2] contains a value greater 
   than 0, we can be sure that _Fil-misc1[2] contains the Index number found 
   by dictionary that is unique which is used as RECID when PROGRESS_RECID
   is not generated- We will store this index name in _Fil-misc2[5]      */

   IF s_ttb_tbl.ds_recid NE ? and s_ttb_tbl.ds_recid GT 0 and has_recid_idx and rowid_idx_name NE ? THEN
        assign s_ttb_tbl.ds_msc25 =  rowid_idx_name. 
   ELSE
        assign s_ttb_tbl.ds_msc25 = ?.

   IF s_ttb_tbl.ds_rowid GT 0 and s_ttb_tbl.ds_rowid NE ? and s_ttb_tbl.ds_recid EQ 0  THEN DO:
       for each s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl): 
          if s_ttb_idx.pro_idx# = s_ttb_tbl.ds_rowid and s_ttb_idx.pro_uniq EQ FALSE THEN
             assign s_ttb_tbl.ds_msc25 = s_ttb_idx.ds_name.
          else 
             assign s_ttb_tbl.ds_msc25 = ?.
       END.
    END. /* if s_ttb_tbl.ds_rowid GT 0 and s_ttb_tbl.ds_rowid NE ? and s_ttb_tbl.ds_recid EQ 0 */
   END. /* End of IF foreign_dbms_version GE 10*/

  end. /* if <> procedure */
  ELSE DO:
  /******************************  Stored Procedure Records ****************/
     RUN STORED-PROC DICTDBG.SQLProcedures
                 (spclvar-1, uservar-1, namevar-1).
  

     for each DICTDBG.SQLProcs_buffer:

        /* 20031205-003
           If the proc name has underscore (_), we may get records for
           different procedures since '_' may be a search pattern depending on
           the driver settings/version. So we need to filter out anything
           that is not the procedure we are looking for.
        */
        IF TRIM(DICTDBG.SQLProcs_buffer.name) NE ? AND 
           /* if it has ";0" or ";1" at the end, don't use it to compare proc name */
           trim(namevar-1) NE SUBSTRING(TRIM(DICTDBG.SQLProcs_buffer.name),1,LENGTH(trim(namevar-1))) THEN
           NEXT.

        assign table_name = ( if TRIM(DICTDBG.SQLProcs_buffer.name) = ?
                              then "%"
                              else TRIM(DICTDBG.SQLProcs_buffer.name)
                             )
               table_spcl = ( if TRIM(DICTDBG.SQLProcs_buffer.qualifier) = ?
                              then "%"
                              else TRIM(DICTDBG.SQLProcs_buffer.qualifier)
                             )
               table_user = ( if TRIM(DICTDBG.SQLProcs_buffer.owner) = ?
                              then "%"
                              else TRIM(DICTDBG.SQLProcs_buffer.owner)
                             ).

     end.

     CLOSE STORED-PROC DICTDBG.SQLProcedures.

     /* this can happen if this is a table valued function */
     IF table_name = ? OR table_name = "" OR 
        substring(table_name,(length(table_name) - 1)) = ";0" THEN 
        NEXT.

     IF substring(table_name,(length(table_name) - 1)) = ";1" THEN
        ASSIGN table_name = substring(table_name,1,(length(table_name) - 2)).
     create s_ttb_tbl.
     ASSIGN gate-work.ttb-recid = RECID(s_ttb_tbl)
            s_ttb_tbl.ds_name   = table_name
            s_ttb_tbl.ds_recid  = 0
            s_ttb_tbl.ds_msc13 = 1
            s_ttb_tbl.ds_spcl   = ( if (table_spcl = "%" OR bug1) 
                                   then ?
                                   else table_spcl
                                   )
            s_ttb_tbl.ds_type   =  gate-work.gate-type
            s_ttb_tbl.ds_user   = ( if table_user = "%" or bug28
                                    then ?
                                    else table_user 
                                   )
            s_ttb_tbl.gate-work = RECID(gate-work)
            s_ttb_tbl.pro_desc  = ( if table_comment <> ""
                                    then table_comment 
                                    else s_ttb_tbl.pro_desc
                                   )                               
            s_ttb_tbl.pro_name  = gate-work.gate-prog.
 
     if TERMINAL <> "" and NOT batch-mode then 
       DISPLAY
            namevar @ msg[1]  "" @ msg[4]
            progvar @ msg[2]  "" @ msg[5]
            ""      @ msg[3]  "" @ msg[6]
       with frame ds_make.
  
     /*---------------------------- Parameters ------------------------------*/
      /* Get the ordinal number of parameters in the procedure.		*/
     assign table_spcl_1 = ( if (spclvar-1 = "%" or spclvar-1 = ?)
                            then ""
                            else spclvar
                            )
            spcl_len     = length(table_spcl_1)
 
            table_user_1 = ( if (uservar-1 = "%" or uservar-1 = ?)
                             then ""
                             else uservar
                            )
            user_len     = length(table_user_1)
            dot1         = ( if foreign_dbms = "Informix"
                             then ":"
                             else "."
                            )
            dot2         = ( if (table_spcl_1 <> "" OR table_user_1 <> "")
                             then "."
                             else ""
                           )
            table_len    = length(table_name)
            full_table_name   = table_spcl_1 + dot1
	 	             + table_user_1 + dot2 + table_name
            shadow_col        = -1
            array_name        = "".

     RUN prodict/mss/mss_fix.p (table_spcl, OUTPUT spclvar-1, escp, bug1).
     RUN prodict/mss/mss_fix.p (table_user, OUTPUT uservar-1, escp, bug8).
     RUN prodict/mss/mss_fix.p (table_name, OUTPUT namevar-1, escp, no).

     RUN STORED-PROC DICTDBG.SQLProcColumns (spclvar-1, uservar-1, namevar-1, ?).

     assign field-position = 0.
     assign err_sp_flag = FALSE.

     _col-loop:
     for each DICTDBG.SQLProcCols_buffer:

        /* 20031205-003
           If the proc name has underscore (_), we may get records for
           different procedures since '_' may be a search pattern depending on
           the driver settings/version. So we need to filter out anything
           that is not the procedure we are looking for.
        */
        /* if it has ";0" or ";1" at the end, don't use it to compare proc name */
        IF trim(namevar-1) NE SUBSTRING(TRIM(DICTDBG.SQLProcCols_buffer.name),1,LENGTH(trim(namevar-1))) THEN
           NEXT.

        assign field-position = field-position + 1
               fld-remark     = DICTDBG.SQLProcCols_buffer.remarks
               fld-properties = "".
    
        IF CAPS(DICTDBG.SQLProcCols_buffer.Column-name) = "RETURN_VALUE" 
          OR CAPS(DICTDBG.SQLProcCols_buffer.Column-name) = "@RETURN_VALUE"  THEN DO:
            assign field-position = field-position - 1.
            NEXT _col-loop.
        end.    
        if can-do (fld-properties, "P") then 
           assign s_ttb_tbl.ds_recid = field-position
                  s_ttb_tbl.ds_msc23 = TRIM(DICTDBG.SQLProcCols_buffer.column-name). 

        if can-do (fld-properties, "S") then do:
           assign shadow_col      = field-position
                  shadow_col_name = ( if LENGTH(quote, "character") = 1
                                      then quote + column-id.col-name + quote
                                      else column-id.col-name
                                     ).

           NEXT.
        end.

        if can-do (fld-properties, "N") then do:
           if s_ttb_tbl.ds_msc22 = ? then 
              assign s_ttb_tbl.ds_msc22 = "".
           assign s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22
	  			        + STRING(field-position) + ",".
        end.

        if can-do (fld-properties, "I") then NEXT.

        if LENGTH (array_name, "character")              >    0 
            and TRIM(DICTDBG.SQLProcCols_buffer.column-name) BEGINS array_name
            then NEXT.

        do:

           { prodict/mss/mss_typ.i DICTDBG.SQLProcCols_buffer.data-type  bug29 }
           ASSIGN m1 = 0.

           IF l_dt = "UNDEFINED" THEN DO:
              RUN error_handling
                ( 2, 
                  s_ttb_tbl.ds_name, "" 
                ).
              RUN error_handling ( 3, "", "" ).
    
              FOR EACH s_ttb_fld WHERE s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):
                DELETE s_ttb_fld.
              END.
              DELETE s_ttb_tbl.
              CLOSE STORED-PROC DICTDBG.SQLProcColumns.
              FOR EACH column-id:
                DELETE column-id.
              END.
              NEXT _crtloop.
           END.

           if TRIM(DICTDBG.SQLProcCols_buffer.column-name) MATCHES "*##1"
                 and doextent then do:  /* Collect array elements & determine extent */

	      assign
	         m1         = 1
	         i          = LENGTH (TRIM(DICTDBG.SQLProcCols_buffer.column-name), "character") - 1
	         array_name = SUBSTR (TRIM(DICTDBG.SQLProcCols_buffer.column-name), 1, i, "character").

             RUN  prodict/mss/mss_fix.p
                 (table_spcl, OUTPUT spclvar-1,  escp, bug1).
             RUN  prodict/mss/mss_fix.p 
                 (table_user,  OUTPUT uservar-1, escp, bug8).
             RUN  prodict/mss/mss_fix.p 
                 (table_name,  OUTPUT namevar-1,  escp, no).


             RUN STORED-PROC DICTDBG.SQLProcColumns P_proc_handle = PROC-HANDLE
		       (spclvar-1, uservar-1, namevar-1, ?).

	     for each P_col where PROC-HANDLE = P_proc_handle:

            /* 20031205-003
               If the proc name has underscore (_), we may get records for
               different procedures since '_' may be a search pattern depending on
               the driver settings/version. So we need to filter out anything
               that is not the procedure we are looking for.
            */
            /* if it has ";0" or ";1" at the end, don't use it to compare proc name */
            IF trim(namevar-1) NE SUBSTRING(TRIM(P_col.name),1,LENGTH(trim(namevar-1))) THEN
               NEXT.

	        if NOT P_col.column-name BEGINS array_name then NEXT.
	        assign m2 = INTEGER (SUBSTR (P_col.column-name
	                              , i + 1
	                              , LENGTH (P_col.column-name
	                              , "character") - i
	                              , "character"
	                                )      ).
	        if m2 > m1 then assign m1 = m2.

	     end. /* EACH P_col */
	  
	     CLOSE STORED-PROC DICTDBG.SQLProcColumns where PROC-HANDLE = P_proc_handle.

           end. /* Collect array elements & determine extent */

           { prodict/mss/mss_pulp.i 
               &data-type    = "l_dt"
               &order-offset = "4000"  /* make sure we go well beyond the end */
               &extent       = "m1"
            }

        end. /* DO */

        if   shadow_col > 0 then 
           assign s_ttb_fld.pro_case = FALSE  
                  s_ttb_fld.ds_shd#  = shadow_col
                  s_ttb_fld.ds_shdn  = shadow_col_name
                  shadow_col         = -1
                  shadow_col_name    = ? .
        ELSE IF DICTDB._Db._Db-misc1[1] = 1 THEN
            ASSIGN s_ttb_fld.pro_case = FALSE.

     end.      /* for each SQLProcCols_buffer */
    
     CLOSE STORED-PROC DICTDBG.SQLProcColumns.

   END. /* = PROCEDURE */  
end. /* end gate-work */

if change-dict-ver THEN do:
  find DICTDB._Db where RECID(_Db) = drec_db EXCLUSIVE-LOCK.
  /* update with new version information(of dictionary, client and server) received */
  DICTDB._Db._Db-misc2[7] = "Dictionary Ver #:" +  odbc-dict-ver-new
                          + ",Client Ver #:"
                          + ds_clnt_vers
                          + ",Server Ver #:"
                          + ds_srvr_vers
                          + ",".
end.

Coninfosql = "IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = '_Constraint_Info') ".
Coninfosql = Coninfosql + "BEGIN ".
Coninfosql = Coninfosql + "DROP Procedure _Constraint_Info ".
Coninfosql = Coninfosql + "END ".
RUN STORED-PROC DICTDBG.send-sql-statement C_proc_handle = PROC-HANDLE NO-ERROR (Coninfosql).
IF ERROR-STATUS:ERROR THEN .
ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = C_proc_handle.
    END.
    ELSE DO:
      CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = C_proc_handle.
    END.

IF NOT batch-mode
 then SESSION:IMMEDIATE-DISPLAY = no.
RUN adecomm/_setcurs.p ("").

IF NOT batch-mode
 then HIDE FRAME ds_make NO-PAUSE.

 /* Indicate to runtime that this is an independent PULL */
 DO TRANS:
   RUN STORED-PROC DICTDBG.SendInfo ("msspul-end").
 END.

RETURN.




