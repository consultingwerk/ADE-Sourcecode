/*********************************************************************
* Copyright (C) 2006-2009 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
file:   prodict/odb/_odb_pul.p

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
    hutegger    95/03   acreated out of odb_mak.p
    D. McMann  09/03/98 Added view as dialog box for gui
    D. McMann  03/02/99 Added support for progress recid and shadow col skipping
    D. McMann  07/14/99 Added check for INFORMATION_SCHEMA as owner (HHHHH)
    D. McMann  08/29/00 Added check for Informix "__1" to get extents created properly
                        19991231-006
    D. McMann 10/01/01 Added logic not to pull system tables or overloaded procedures
                       for DB2.
    D. McMann 10/16/01 Added logic for fields that begin with progress_   
    D. McMann 10/08/02 Added logic for shadow columns and arrays for MS Access                      
    D. McMann 04/23/03 Added logic to check sequence names - support on-line schema
    K. McIntosh 03/04/05 Changed error handling to reject loading a table if one of its 
                         fields are of an unsupported data-type 20050215-011
    D. Slutz 08/10/05 Added extent_char 20050531-001
    D. Moloney 11/11/05 Added schema holder version processing variables 20050531-001
    fernando   01/04/06 Message added for 20050531-001 should be a warning
	                    and should not come up during migration - 20051230-006.
    fernando   09/28/06 For DB2, use P_BUFFER_ for pseudo-buffers instead of 
                        _BUFFER_ - 20060425-009
    fernando   10/06/06 Check object name in case it has underscore - 20031205-003                        
    knavneet   07/25/07 For DB2/400, append Library name to _Db-misc2[1]
    rkumar     12/10/08 Fixed OE00178256 For iSeries Access ODBC driver 
    rkumar     05/05/09 Added RECID support for ODBC DataServer- OE00177721
    rkumar     10/15/09 Sybase DataServer- added COMMIT statement- OE00164101
*/

/*
relevant header-comments from odb_mak.p:
----------------------------------------

NOTE: there are a couple of bugs that various ODBC-driver have. The
complete list and description of the bugs can be found in odb_ctl.i

History
    mcmann      99/02/22    Added check for progress recid field
    mcmann      98/01/28    Added code for stored procedures
    hutegger    95/01/26    changed schmea-triggers to internal procs
    radams      94/05/10    don't display in batch mode.
    hutegger    94/05/03    trigger-handling
*/
/*h-*/

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

define variable A_proc_handle    as integer.
define variable P_proc_handle    as integer.

define variable array_name 	 as character no-undo. 
define variable batch-mode	 as logical.
define variable bug1             as logical no-undo.
define variable bug4             as logical no-undo.
define variable bug7             as logical no-undo.
define variable bug8             as logical no-undo.
define variable bug19            as logical no-undo.
define variable bug22            as logical no-undo.
define variable bug28            as logical no-undo.
define variable bug29            as logical no-undo.
define variable bug34            as logical no-undo.

define variable char-type	 as logical no-undo. 
define variable column_available as logical no-undo. 
define variable comp-name  	 as character no-undo.
define variable temp-comp-name   as character no-undo.
define variable comp-ind         as integer   no-undo.
define variable comp-num         as integer   no-undo.
define variable doextent         as logical   no-undo. 
define variable dot1  	 	 as character no-undo.
define variable dot2  	 	 as character no-undo.
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
define variable m1	   	 as integer   no-undo.
define variable m2	   	 as integer   no-undo. 
define variable msg              as character no-undo   EXTENT 6.
define variable namevar   	 as character no-undo case-sensitive.
define variable namevar-1   	 as character no-undo case-sensitive.
define variable newf  	         as logical   no-undo. /* new file definition */
define variable ntyp  	         as character no-undo.
define variable numeric-type	 as logical   no-undo. 
define variable oldf  	         as logical   no-undo. /* old file definition */
define variable pnam             as character no-undo.
define variable extent_char      as character no-undo.
define variable prev-prior       as integer   no-undo.
define variable progvar   	 as character no-undo.
define variable quote            as character no-undo.
define variable r                AS RECID     no-undo.
define variable scrap            as logical   no-undo.
define variable shadow_col_name  as character no-undo.
define variable shadow_col 	 as integer   no-undo. 
define variable spclvar   	 as character no-undo.
define variable spclvar-1   	 as character no-undo.
define variable table_comment    as character no-undo.
define variable table_name  	 as character no-undo case-sensitive.
define variable table_user  	 as character no-undo.
define variable table_user_1  	 as character no-undo.
define variable table-properties as character no-undo.
define variable table_spcl       as character no-undo.
define variable table_spcl_1     as character no-undo.
define variable table_type  	 as character no-undo.
define variable temp1	   	 as integer   no-undo.
define variable temp2	   	 as integer   no-undo.
define variable typevar   	 as character no-undo.
define variable typevar-1   	 as character no-undo.
define variable unique-prime     as logical   no-undo. /* upi already found */
define variable uservar   	 as character no-undo.
define variable uservar-1   	 as character no-undo.
define variable vfmt1            as character no-undo.

define variable spcl_len	 as integer   no-undo.
define variable user_len	 as integer   no-undo.
define variable table_len	 as integer   no-undo.
define variable dq_index         as integer   no-undo.
DEFINE VARIABLE s                AS CHARACTER NO-UNDO.
DEFINE VARIABLE tdbtype          AS CHARACTER NO-UNDO.  
DEFINE VARIABLE found            AS INTEGER   NO-UNDO.
DEFINE VARIABLE efound           AS INTEGER   NO-UNDO.
DEFINE VARIABLE sh_ver           AS INTEGER   NO-UNDO.
DEFINE VARIABLE sh_max_ver       AS INTEGER   NO-UNDO.
DEFINE VARIABLE clnt_vers        AS CHARACTER NO-UNDO.
DEFINE VARIABLE odb_perform_mode AS CHARACTER NO-UNDO.
DEFINE VARIABLE is_db2           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is_as400         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tblrem_sql       AS CHARACTER NO-UNDO.
DEFINE VARIABLE dfth             AS INTEGER   NO-UNDO.
DEFINE VARIABLE h                AS INTEGER   NO-UNDO INIT ?. 
DEFINE VARIABLE ret_ok           AS LOGICAL   NO-UNDO INIT YES. 

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

  with ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  TITLE " Loading " + edbtyp + " Definition " USE-TEXT
  frame ds_make.

/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/


/*------------------------------------------------------------------*/
procedure error_handling:

define INPUT PARAMETER error-nr         as INTEGER.
define INPUT PARAMETER param1           as CHARACTER.
define INPUT PARAMETER param2           as CHARACTER.

define       variable  err-msg as character extent 6 initial [
/*  1 */ "WARNING: Column &1 is hidden; it cannot be an index component",
/*  2 */ "ERROR: Table &1 has unsupported data types.",
/*  3 */ "       Skipping this table...",
/*  4 */ " &1 &2 ", /* intentionally left blank for div. error-messages */
/*  5 */ "WARNING: No index for the RECID &1 field",
/*  6 */ "WARNING: The Driver sends wrong data about indexes, they cant be build automatically"
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
  l_char-types = "CHAR,VARCHAR,BINARY,VARBINARY"
  l_chrw-types = "LONGVARBINARY,LONGVARCHAR,TIME"
  l_date-types = "DATE"
  l_dcml-types = "DECIMAL,NUMERIC"
  l_floa-types = "DOUBLE,FLOAT,REAL"
  l_i###-types = ""
  l_i##d-types = "BIGINT"
  l_i##l-types = ""
  l_i#dl-types = "INTEGER,SMALLINT,TINYINT"
  l_logi-types = "BIT"
  l_time-types = ""
  l_tmst-types = "TIMESTAMP"
  .
  
IF NOT batch-mode then assign SESSION:IMMEDIATE-DISPLAY = yes.

RUN adecomm/_setcurs.p ("WAIT").

/* 20051230-006 */
IF user_env[25] BEGINS "AUTO" THEN
    ASSIGN odb_perform_mode = "M". /* migration */
ELSE IF user_env[25] = "add" THEN
    ASSIGN odb_perform_mode = "C". /* create schema */
ELSE IF user_env[25] = "upd" THEN
    ASSIGN odb_perform_mode = "U". /* update schema */

assign
  cache_dirty = TRUE
  user_env    = "" /* yes this is destructive, but we need the -l space */
  l_dt        = ?.

RUN prodict/odb/_odb_typ.p
  ( INPUT-OUTPUT i,
    INPUT-OUTPUT i,
    INPUT-OUTPUT l_dt,
    INPUT-OUTPUT l_dt,
    OUTPUT       l_dt
    ). /* fills user_env[11..17] with datatype-info */

/* Get the name of the foreign dbms and set the foreign_dbms name */
    define variable foreign_dbms            as character no-undo.

    RUN STORED-PROC DICTDBG.GetInfo (0).
    for each DICTDBG.GetInfo_buffer:
       assign foreign_dbms = ( DICTDBG.GetInfo_buffer.dbms_name )
              is_as400 = INDEX(UPPER(DICTDBG.GetInfo_buffer.dbms_name),"AS/400") > 0 OR 
                         INDEX(UPPER(DICTDBG.GetInfo_buffer.dbms_name),"DB2/400") > 0.  
    end.

    CLOSE STORED-PROC DICTDBG.GetInfo.

find DICTDB._Db where RECID(_Db) = drec_db.

/* If we have an Informix db, we need to set bug34 flag for the separator
   character.  We can't set it earlier (like in odb_ctl.i) as there are lots
   of Informix drivers now - too many to try to keep in the list. */

IF (foreign_dbms = "Informix") THEN
   ASSIGN
      DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4] + "34" + ",".
/* For db2/400, if _db-misc2[1] has no 2nd entry append the library name to it else
   update the 2nd entry with the new value */
IF is_as400 AND s_owner <> "*" AND s_owner <> "" THEN 
DO:
   IF NUM-ENTRIES(DICTDB._Db._Db-misc2[1]) = 1 THEN
     ASSIGN
      DICTDB._Db._Db-misc2[1] = DICTDB._Db._Db-misc2[1] + "," + UPPER(s_owner).
   ELSE 
     ASSIGN
      ENTRY(2,DICTDB._Db._Db-misc2[1]) = UPPER(s_owner).
END.
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

/* OE00164101- only for Sybase datasource
             - running an explicit COMMIT SQL because pseudo   
               stored-procs cannot be run in a transaction */
IF (INDEX(_Db._Db-misc2[5], "SQL Server") <> 0) THEN DO:
        RUN STORED-PROC DICTDBG.send-sql-statement
           h = PROC-HANDLE NO-ERROR ("COMMIT ").
        assign ret_ok  = NOT ERROR-STATUS:ERROR.
        if ret_ok then  
          CLOSE STORED-PROC DICTDBG.send-sql-statement where PROC-HANDLE = h .
        else 
          run error_handling(4,"COMMIT","","error"). 
END. 

/*---------------------------- MAIN-LOOP ---------------------------*/
ASSIGN is_db2 = INDEX(UPPER(_Db._Db-misc2[8]), "DB2") > 0.

/* just in case some garbage left over */
for each s_ttb_tbl: delete s_ttb_tbl. end.
for each s_ttb_fld: delete s_ttb_fld. end.
for each s_ttb_idx: delete s_ttb_idx. end.
for each s_ttb_idf: delete s_ttb_idf. end.

_crtloop:
for each gate-work
  where gate-work.gate-slct = TRUE:
  
  /* Skip pseudo-entry, which is needed to signal, if user wants to 
   * compare not just <DS> -> PROGRESS, but also the other direction
   */
  if gate-work.gate-type = "PROGRESS" then next.

   /* This is for MS SQL 7 causing GPF when schema tables are pulled */
  IF gate-work.gate-user = "INFORMATION_SCHEMA" THEN NEXT.
  
  /* Eliminate system tables for DB2 */
  IF gate-work.gate-user = "SYSIBM" OR
     gate-work.gate-user = "SYSCAT" OR
     gate-work.gate-user = "SYSSTAT" OR
     gate-work.gate-user = "SYSFUN" THEN NEXT.

  assign
    has_id_ix          = no
    namevar   = ( if      gate-work.gate-type = "BUFFER"
                   /* 20060425-009 - for DB2, look for P_BUFFER */
                   then (IF is_db2 THEN "P_" ELSE "_")
                      + gate-work.gate-type /* coud be lower-case */
                      + "_" + gate-work.gate-name
                  else if gate-work.gate-type <> "SEQUENCE"
                   then            gate-work.gate-name
                  else if asc(substring(gate-work.gate-type,1,1,"character")) = 115
                   then "_seqt_" + gate-work.gate-name
                   else "_SEQT_" + gate-work.gate-name
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
    
  if SESSION:BATCH-MODE and logfile_open
   then put unformatted
     gate-work.gate-type at 10
     gate-work.gate-name at 25 skip.


  RUN  prodict/odb/odb_fix.p (spclvar, OUTPUT spclvar-1, escp, bug1).
  RUN  prodict/odb/odb_fix.p (uservar, OUTPUT uservar-1, escp, bug8).
  RUN  prodict/odb/odb_fix.p (namevar, OUTPUT namevar-1, escp, no).
  RUN  prodict/odb/odb_fix.p (typevar, OUTPUT typevar-1, escp, no).
  assign typevar-1 = "'" + typevar-1 + "'". 
  
  IF gate-work.gate-type <> "PROCEDURE" THEN DO:
  
    /*-------------------------- SEQUENCES -----------------------------*/

    if gate-work.gate-type = "SEQUENCE"
        then do:  /* gate-work.gate-type = "SEQUENCE" */

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
      assign
        gate-work.ttb-recid = RECID(s_ttb_seq)
        s_ttb_seq.ds_name   = namevar 
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

      if TERMINAL <> "" and NOT batch-mode
        then DISPLAY 
          namevar @ msg[1]   ""   @ msg[4]
          progvar @ msg[2]   ""   @ msg[5]
          ""      @ msg[3]   ""   @ msg[6]
          with frame ds_make.

      NEXT.

    end.     /* gate-work.gate-type = "SEQUENCE" */


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

      if DICTDBG.SQLTables_buffer.Remark MATCHES
                                "*(vendor(PROGRESS),product(PODBC)*"
          then RUN prodict/odb/odb_fprp.p 
            ( INPUT  DICTDBG.SQLTables_buffer.Remark,
              INPUT  "--*(vendor(PROGRESS),product(PODBC)",
              INPUT  "--*)",
              OUTPUT table-properties,
              OUTPUT table_comment
            ).

      /* SEND-SQL to get table remarks from SYSTABLES catalog table */
      IF is_as400 THEN DO:
          ASSIGN tblrem_sql = "select table_text from qsys2.systables where " + 
                              " table_name  = '" + DICTDBG.SQLTables_buffer.NAME +
                              "' and table_schema = '" + DICTDBG.SQLTables_buffer.OWNER +
                              "' ".
          RUN STORED-PROC DICTDBG.send-sql-statement dfth = PROC-HANDLE NO-ERROR ( tblrem_sql ).

          IF ERROR-STATUS:ERROR THEN ASSIGN table_comment = ?. 
          ELSE DO:
              FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth:
                  ASSIGN table_comment = proc-text.
              END.
          CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth.
          END.

          IF table_comment <> ? THEN 
             ASSIGN table_comment = TRIM(TRIM(TRIM(table_comment),"'")).
      END. /* End of is_as400 block to fetch table_text from SYSTABLES */
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
     * any fields, so we end the processing for SysGams right here. 
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
          ASSIGN s_ttb_tbl.ds_recid = i
                 s_ttb_tbl.ds_msc23 = DICTDBG.GetFieldIds_buffer.field-name.
          IF is_as400 THEN ASSIGN s_ttb_tbl.ds_msc22 = string(i) + ",".
          ASSIGN i = i + 1.
        END. /* s_ttb_tbl.ds_recid = 0 */
         ELSE IF SUBSTRING(DICTDBG.GetFieldIds_buffer.field-name,
              (LENGTH(DICTDBG.GetFieldIds_buffer.field-name) - 6)) = "_IDENT_"
           THEN DO: /* OE00135573 fixed along with RECID implementation */
             IF is_as400 THEN 
                    assign s_ttb_tbl.ds_msc22 = s_ttb_tbl.ds_msc22 + "," + string(i) + ",".
             ELSE 
                    assign s_ttb_tbl.ds_msc22 = string(i) + ",".
           ASSIGN i = i + 1.
         END.
                   
        NEXT _loop.
      END.  
 
      CREATE column-id.
      assign
        column-id.col-name = TRIM(DICTDBG.GetFieldIds_buffer.field-name)
        column-id.col-id   = i
        i                  = i + 1.

        /* Shave the quotes off.                                          */
      if (LENGTH(quote, "character") = 1) AND SUBSTRING(column-id.col-name,1,1) = quote THEN
        ASSIGN column-id.col-name = SUBSTRING(column-id.col-name
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
    RUN  prodict/odb/odb_fix.p (table_spcl, OUTPUT spclvar-1, escp, bug1).
    RUN  prodict/odb/odb_fix.p (table_user, OUTPUT uservar-1, escp, bug8).
    RUN  prodict/odb/odb_fix.p (table_name, OUTPUT namevar-1, escp, no).
    RUN STORED-PROC DICTDBG.SQLColumns (spclvar-1, uservar-1, namevar-1, ?).

    assign field-position = 0.

    for each DICTDBG.SQLColumns_buffer:

     /* 20031205-003
        If the table name has underscore (_), we may get records for
        different tables, since '_' may be a search pattern depending on
        the driver settings/version. So we need to filter out anything
        that is not from the table we want.
     */
     IF TRIM(namevar-1) NE TRIM(DICTDBG.SQLColumns_buffer.name) THEN
        NEXT.

      IF DICTDBG.SQLColumns_buffer.column-name begins "PROGRESS_RECID" OR
         DICTDBG.SQLColumns_buffer.column-name begins "_PROGRESS_RECID" OR
         DICTDBG.SQLColumns_buffer.column-name begins "_PROGRESS_ROWID"
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
      if DICTDBG.SQLColumns_buffer.remarks MATCHES
                                    "*(vendor(PROGRESS),product(PODBC)*" 
       then RUN prodict/odb/odb_fprp.p 
            ( INPUT  DICTDBG.SQLColumns_buffer.remarks,
              INPUT  "--*(vendor(PROGRESS),product(PODBC)",
              INPUT  "--*)",
              OUTPUT fld-properties,
              OUTPUT fld-remark
              ).

      if can-do (fld-properties, "P")
        then assign
          s_ttb_tbl.ds_recid = field-position
          s_ttb_tbl.ds_msc23 = TRIM(DICTDBG.SQLColumns_buffer.column-name). 

      if can-do (fld-properties, "S") OR 
        DICTDBG.SQLColumns_buffer.column-name BEGINS "_S#_" OR
        DICTDBG.SQLColumns_Buffer.column-name BEGINS "U##" OR
        DICTDBG.SQLColumns_Buffer.column-name BEGINS "U__" then do:
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

        assign
          l_dt  = { prodict/odb/odb_typ.i DICTDBG.SQLColumns_buffer.data-type  bug29 }
          m1 = 0.

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
          NEXT.
        END.

        if (TRIM(DICTDBG.SQLColumns_buffer.column-name) MATCHES "*##1" OR
            (TRIM(DICTDBG.SQLColumns_buffer.column-name) MATCHES "*__1" ))
          and doextent then do:  /* Collect array elements & determine extent */

	  assign
	    m1         = 1
	    i          = LENGTH (TRIM(DICTDBG.SQLColumns_buffer.column-name), "character") - 1
	    array_name = SUBSTR (TRIM(DICTDBG.SQLColumns_buffer.column-name), 1, i, "character").

          RUN  prodict/odb/odb_fix.p
                 (table_spcl, OUTPUT spclvar-1,  escp, bug1).
          RUN  prodict/odb/odb_fix.p 
                (table_user,  OUTPUT uservar-1, escp, bug8).
          RUN  prodict/odb/odb_fix.p 
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

        { prodict/odb/odb_pul.i 
           &data-type    = "l_dt"
           &order-offset = "4000"  /* make sure we go well beyond the end */
           &extent       = "m1"
        }

      end. /* DO */

      if shadow_col > 0 then 
        assign s_ttb_fld.pro_case = FALSE  
               s_ttb_fld.ds_shd#  = shadow_col
               s_ttb_fld.ds_shdn  = shadow_col_name
               shadow_col         = -1
               shadow_col_name    = ? .

    end.      /* for each SQLColumns_buffer */
    
    CLOSE STORED-PROC DICTDBG.SQLColumns.			
				    
    /*----------------------------- INDEXES ------------------------------*/

    RUN  prodict/odb/odb_fix.p (table_spcl, OUTPUT spclvar-1, ?, bug1).
    RUN  prodict/odb/odb_fix.p (table_user, OUTPUT uservar-1, ?, bug8).
    RUN  prodict/odb/odb_fix.p (table_name, OUTPUT namevar-1, ?, no).

    RUN STORED-PROC DICTDBG.SQLStatistics(spclvar-1, uservar-1, namevar-1).
 
    assign
      indn         = 1
      unique-prime = NO.

    for each DICTDBG.SQLStatistics_buffer:

      /* Skip TBALE statistics.						*/
      if DICTDBG.SQLStatistics_buffer.type = 0 OR bug22 then NEXT. 
      
      IF DICTDBG.SQLStatistics_buffer.Column-name BEGINS '_PROGRESS_RECID' OR
         DICTDBG.SQLStatistics_buffer.Column-name BEGINS '_PROGRESS_ROWID' OR
         DICTDBG.SQLStatistics_buffer.Column-name BEGINS 'PROGRESS_RECID' OR
         DICTDBG.SQLStatistics_buffer.Column-name BEGINS 'PROGRESS_ROWID' THEN NEXT.
         
      assign 
        comp-name   = DICTDBG.SQLStatistics_buffer.Column-name.

      if bug4 then do:
        RUN extract_comp_names 
          ( INPUT  comp-name,
            OUTPUT temp-comp-name
          ).
        RUN prodict/odb/odb_qe.p
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

        end.     /* index non-existent -> create new index */


     /*-------------------------- INDEX-FIELDS --------------------------*/

        CREATE s_ttb_idf.
          assign
             s_ttb_idf.pro_abbr  = FALSE
             s_ttb_idf.pro_asc   = TRIM(DICTDBG.SQLStatistics_buffer.collation) <> "D" 
             s_ttb_idf.pro_order = ( if bug4 and comp-num > 1
            			        then comp-ind
        			        else DICTDBG.SQLStatistics_buffer.seq-in-index
        		             )
             s_ttb_idf.ttb_fld   = RECID(s_ttb_fld)
             s_ttb_idf.ttb_idx   = RECID(s_ttb_idx).

      end.   /* REPEAT comp-ind = 1 to comp-num */
    
    end.   /* for each DICTDBG.SQLStatistics_buffer */
  
    CLOSE STORED-PROC DICTDBG.SQLStatistics.

    /* If there is a progress_recid without an index then we gently complain */
    if s_ttb_tbl.ds_recid > 0 /*and not has_id_ix*/ THEN DO:
       FIND FIRST s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl) NO-ERROR.
       IF NOT AVAILABLE s_ttb_idx 
        then RUN error_handling(5, s_ttb_tbl.ds_msc23, "").
                      /* "WARNING: No index for the RECID &1 field". */
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

       if NOT available s_ttb_idf
          and ( s_ttb_tbl.ds_msc22 = ? 
           or    NOT can-do(s_ttb_tbl.ds_msc22,STRING(s_ttb_fld.ds_stoff))
               ) then do:  /* field is possible candidate */
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
	     when "LONGVARCHAR"   then fld-prior = 1. 
	     when "DATE"          then fld-prior = 5. 
	     when "TIME"          then fld-prior = 5. 
	     when "TIMESTAMP"     then fld-prior = 3. 
	     when "VARBINARY"     then fld-prior = 2. 
	     when "LONGVARBINARY" then fld-prior = 1. 
	     when "BINARY"        then fld-prior = 2. 
	     when "BIGINT"        then fld-prior = 3. 
	     when "TINYINT"       then fld-prior = 5. 
	     when "BIT"           then fld-prior = 5. 
	     OTHERWISE                 fld-prior = 1.
          end case.
          if fld-prior > prev-prior then 
            assign
       	         prev-prior         = fld-prior
                 s_ttb_tbl.ds_msc13 = s_ttb_fld.ds_stoff.
       end.     /* field is possible candidate */

    end.  /* for each s_ttb_fld */
  

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
    
       /* check all indexes and calculate their usability-level */
       for each s_ttb_idx
          where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
    
         for each s_ttb_idf 
            where s_ttb_idf.ttb_idx = RECID(s_ttb_idx):

           find first s_ttb_fld 
              where RECID(s_ttb_fld) = s_ttb_idf.ttb_fld.
           assign
              s_ttb_idx.hlp_fld#   = s_ttb_idx.hlp_fld# + 1
              s_ttb_idx.hlp_dtype# = maximum(s_ttb_idx.hlp_dtype#,
                          integer(string((s_ttb_fld.ds_type <> "integer"),"1/0")),
                          integer(string((s_ttb_fld.pro_type = "date"   ),"2/0")),
                          integer(string((s_ttb_fld.ds_type  = "float"  ),"3/0")) 
                                     )
              s_ttb_idx.hlp_mand   = s_ttb_idx.hlp_mand and s_ttb_fld.pro_mand
              s_ttb_idx.hlp_fstoff = s_ttb_fld.ds_stoff * -1
              s_ttb_idx.hlp_msc23  = ( if s_ttb_fld.ds_msc23 <> ?
                                      then s_ttb_fld.ds_msc23 
                                      else s_ttb_fld.ds_name
                                      ).
                                 
         end.  /* for each s_ttb_idfs of s_ttb_idx */

         assign
            s_ttb_idx.hlp_dtype# = ( if ( s_ttb_idx.hlp_dtype# = 0
                                    and s_ttb_idx.hlp_fld#   > 1 )
                                    then 1
                                    else s_ttb_idx.hlp_dtype#
                                    )
            s_ttb_idx.hlp_level  = ( if ( s_ttb_idx.hlp_mand = TRUE 
                                    and s_ttb_idx.pro_uniq = TRUE )
                                    then 1
                                    else 5
                                    ) 
                                    + s_ttb_idx.hlp_dtype#.

       end. /* for each s_ttb_idx */

       /* assign correct i-misc2[1]-values and select index */
       for each s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
             break by s_ttb_idx.hlp_slctd descending
                   by s_ttb_idx.hlp_level:

          if s_ttb_idx.hlp_slctd   /* previousely selected RowID index */
               and s_ttb_idx.hlp_level <> 0
               and s_ttb_idx.hlp_level <> 4
               then do: /* select it but schema NOT compatible with V7.3 anymore*/
             assign
                s_ttb_idx.ds_msc21 = "r" 
                                     + entry(s_ttb_idx.hlp_level,l_matrix)
                s_ttb_tbl.ds_recid = ?
                s_ttb_tbl.ds_msc23 = ?
                s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          end.    /* select it but schema NOT compatible with V7.3 anymore*/
          else if first(s_ttb_idx.hlp_slctd)
                 and s_ttb_idx.hlp_level <= 4
                 then assign /* select this index */
                    s_ttb_idx.ds_msc21 = "ra"
                    s_ttb_tbl.ds_recid = s_ttb_idx.hlp_fstoff
                    s_ttb_tbl.ds_msc23 = s_ttb_idx.hlp_msc23
                    s_ttb_tbl.ds_rowid = s_ttb_idx.pro_idx#.
          else assign
              s_ttb_idx.ds_msc21 = entry(s_ttb_idx.hlp_level,l_matrix).

          /* OE00164266 - set the PROGRESS_RECID size if it is an integer */
          find first s_ttb_fld
           where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl)
             and  ABSOLUTE(s_ttb_fld.ds_stoff) = ABSOLUTE(s_ttb_tbl.ds_recid)
    	      no-lock no-error.
          IF available s_ttb_fld then do: 
            if s_ttb_fld.ds_type = "INTEGER"
             then
               s_ttb_tbl.ds_msc15 = 1. /* RECID is 4 byte */
            if s_ttb_fld.ds_type = "BIGINT"
             then
               s_ttb_tbl.ds_msc15 = 2. /* RECID is 8 byte */
          END.

       end.     /* for each s_ttb_idx */
    end.     /* no progress_recid -> check indexes for ROWID usability */

    /* PROGRESS-RECID-field -> reset recid-info of all indexes */
    if has_id_ix then 
    for each s_ttb_idx where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl):
       assign s_ttb_idx.ds_msc21 = ?.
    end.
      
    for each column-id:
      delete column-id.
    end.
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

     RUN prodict/odb/odb_fix.p (table_spcl, OUTPUT spclvar-1, escp, bug1).
     RUN prodict/odb/odb_fix.p (table_user, OUTPUT uservar-1, escp, bug8).
     RUN prodict/odb/odb_fix.p (table_name, OUTPUT namevar-1, escp, no).

     RUN STORED-PROC DICTDBG.SQLProcColumns (spclvar-1, uservar-1, namevar-1, ?).

     assign field-position = 0.
     
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
       
        IF CAPS(DICTDBG.SQLProcCols_buffer.Column-name) = "RETURN_VALUE" THEN DO:
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

           assign
             l_dt  = { prodict/odb/odb_typ.i DICTDBG.SQLProcCols_buffer.data-type  bug29 }
             m1 = 0.

           if (TRIM(DICTDBG.SQLProcCols_buffer.column-name) MATCHES "*##1" OR
            (TRIM(DICTDBG.SQLProcCols_buffer.column-name) MATCHES "*__1" AND foreign_dbms = "Informix"))
                 and doextent then do:  /* Collect array elements & determine extent */

	      assign
	         m1         = 1
	         i          = LENGTH (TRIM(DICTDBG.SQLProcCols_buffer.column-name), "character") - 1
	         array_name = SUBSTR (TRIM(DICTDBG.SQLProcCols_buffer.column-name), 1, i, "character").

             RUN  prodict/odb/odb_fix.p
                 (table_spcl, OUTPUT spclvar-1,  escp, bug1).
             RUN  prodict/odb/odb_fix.p 
                 (table_user,  OUTPUT uservar-1, escp, bug8).
             RUN  prodict/odb/odb_fix.p 
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

           { prodict/odb/odb_pulp.i 
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

     end.      /* for each SQLProcCols_buffer */
    
     CLOSE STORED-PROC DICTDBG.SQLProcColumns.

   END. /* = PROCEDURE */  
end. /* end gate-work */

/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/
/**/ message "odb_pul.i: DS_DEBUG turned on!" view-as alert-box.
/**/
/**/ run error_handling(4, "*****----- END odb_pul.p!!! -----*****" ,"").
/**/
/**/  output stream s_stm_errors to gate-work.d.
/**/  for each hlp-work no-lock: 
/**/    display stream s_stm_errors hlp-work with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_tbl.d.
/**/  for each s_ttb_tbl no-lock: 
/**/    display stream s_stm_errors s_ttb_tbl with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/  output stream s_stm_errors to s_ttb_fld.d.
/**/  for each s_ttb_fld no-lock: 
/**/    display stream s_stm_errors 
/**/     RECID(s_ttb_fld) format "zzzzzz9" label "RECID"
/**/     s_ttb_fld.pro_name s_ttb_fld.ttb_tbl  s_ttb_fld.pro_type
/**/     s_ttb_fld.ds_prec  format "zz9-" label "prc"
/**/     s_ttb_fld.ds_scale format "zz9-" label "scl"
/**/     s_ttb_fld.ds_lngth format "zz9-" label "lng"
/**/     s_ttb_fld.ds_radix format "zz9-" label "rdx"
/**/     s_ttb_fld.ds_msc23 s_ttb_fld.ds_msc24
/**/     s_ttb_fld.ds_shdn  s_ttb_fld.ds_shd# format "zz9-" label "sh#"
/**/     s_ttb_fld.ds_name  s_ttb_fld.ds_stoff s_ttb_fld.ds_type
/**/     s_ttb_fld.ds_stdtype format "zz9-" label "std"
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
/**/     s_ttb_idx.pro_idx#   format "zz9-"    label "ix#"
/**/     s_ttb_idx.ds_name    s_ttb_idx.ds_msc21
/**/     s_ttb_idx.hlp_dtype  format "zz9-"    label "dty#"
/**/     s_ttb_idx.hlp_fld#   format "zz9-"    label "fld#"
/**/     s_ttb_idx.hlp_fstoff format "zz9-"    label "fst#"
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
/**/    display stream s_stm_errors s_ttb_seq. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/
/**/  &ENDIF

IF NOT batch-mode
 then SESSION:IMMEDIATE-DISPLAY = no.

RUN adecomm/_setcurs.p ("").

IF NOT batch-mode
 then HIDE FRAME ds_make NO-PAUSE.

RETURN.




