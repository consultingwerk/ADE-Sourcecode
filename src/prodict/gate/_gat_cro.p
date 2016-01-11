/*********************************************************************
* Copyright (C) 2006-2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

file: prodict/gate/_gat_cro.p

Description:
    creates PROGRESS object according to the foreign info contained
    in the temp-tables, ev. deleting the object first, if it already
    exists, while retaining the PROGRESS-only info of the object to
    use if when re-creating it
    
    <DS>_get.p gets a list of all pullable objects from the foreign DB
    <DS>_pul.p pulled over the definition from the foreign side
    gat_cmp.p  compared the existing definitions with the pulled info
    gat_cro.p  replaces the existing definitions with the pulled info
               or creates the new object if it didn't already exist

    Create <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Update <DS> Schema: <DS>_get.p <DS>_pul.p gat_cro.p
    Verify <DS> Schema: <DS>_get.p <DS>_pul.p gat_cmp.p gat_cro.p

Input:
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
    s_ttb_tbl   Table information from foreign schema
    s_ttb_fld   Field information from foreign schema
    s_ttb_idx   Index information from foreign schema
    s_ttb_idf   Index-Field information from foreign schema

History:
    hutegger    03/95   creation (derived from ds_vrf.p)
    mcmann      11/24/97 Added stream logfile to put statements
    mcmann      02/22/99 Added check for unique index for primary
    mcmann      06/10/99 Added assignment of _Fld-Misc2[2] for nullable
    mcmann      01/26/00 Fixed error message that was being displayed
                         when reassigning field triggers.
    mcmann      04/04/00 Added check for user_env[34] to see if s_1st-eror was set earlier.
    mcmann      05/26/00 Added check for MSS for nullable capable.
    mcmann      07/13/00 Added check for gate-work.gate-edit being empty
    mcmann      06/12/01 Added assignment of Format and Initial values from w_field if available.
    mcmann      06/18/01 Added check of _db-misc1[1] for case
    mcmann      07/08/02 DESC index fixes 20020702013,20020703006, 20020622001
    mcmann      07/10/02 Added check for _index record with no _index-fields - function indexes
    mcmann      10/10/02 Added logic to see data type change.
    mcmann      06/02/03 Removed CLOB and CFILE as valid data type
    mcmann      11/06/03 Swap assignment of Primary index 20031105-020
    slutz       08/10/05 Added s_ttb_fld.ds_msc26 20050531-001
    fernando    04/19/06 Fixing output of message
    fernando    05/26/06 Added support for int64
    fernando    06/11/07 Unicode and clob support   
    fernando    02/14/08 Support for datetime 
    fernando    08/18/08 Check foreign dtype when updating field - OE00168850
    knavneet    08/19/08 Quoting object names if it has special chars - OE00170417
    fernando    05/29/09 MSS support for blob
    kmayur      06/21/11 Support for constraint migration- OE00190567
    sdash       10/11/12 _File-Label added to left Table Label intact - OE00225208
--------------------------------------------------------------------*/


/*    &DS_DEBUG   DEBUG to protocol the creation    */
/*                ""    to turn off protocol        */
&SCOPED-DEFINE xxDS_DEBUG                   DEBUG

&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

define variable batch_mode	 as logical.
define variable edbtyp           as character no-undo. /* db-type external format */
define variable has_id_ix        as logical   no-undo.
define variable i                as integer   no-undo.
define variable indn             as integer   no-undo.
define variable l_char-types     as character no-undo.
define variable l_chda-types     as character no-undo.
define variable l_date-types     as character no-undo.
define variable l_dcml-types     as character no-undo.
define variable l_deil-types     as character no-undo.
define variable l_dein-types     as character no-undo.
define variable l_ds_recid       as integer   no-undo.
define variable l_extnt-char     as character no-undo initial "##".
define variable l_intg-types     as character no-undo.
define variable l_logi-types     as character no-undo.
define variable l_order-max      as integer   no-undo.
define variable l_pro_recid      as integer   no-undo.
define variable msg              as character no-undo   EXTENT 6.
define variable odbtyp           as character no-undo. /* ODBC db-types */
define variable oldf  	         as logical   no-undo. /* old file definition */
define variable scrap            as logical   no-undo.
define variable def-ianum        as integer initial 6 no-undo.
DEFINE VARIABLE fld-dif          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE for_name         AS CHARACTER NO-UNDO. /* OE00170417 */
DEFINE VARIABLE other-seq-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE is_as400db       AS LOGICAL NO-UNDO.
DEFINE VARIABLE num              AS INTEGER NO-UNDO.
DEFINE VARIABLE const_name1   AS CHARACTER NO-UNDO.

/*------------------------------------------------------------------*/
/* These variables/workfile are so we can save the Progress-only
   portion of the DataServer definitions when rebuilding. */
   
define variable idx_Desc         as character no-undo. /*_Desc   */
define variable tab_Can-Crea     as character no-undo. /*_Can-Create */
define variable tab_Can-Dele     as character no-undo. /*_Can-Delete */
define variable tab_Can-Read     as character no-undo. /*_Can-Read */
define variable tab_Can-Writ     as character no-undo. /*_Can-Write */
define variable tab_Desc         as character no-undo. /*_Desc        */
define variable tab_Dump-nam     as character no-undo. /*_Dump-name */
define variable tab_Hidden       as logical   no-undo. /*_Hidden */
define variable tab_PIForNum     as integer   no-undo. /*_Prime-Index */
define variable tab_PrimeIdx     as character no-undo. /*_Prime-Index */
define variable tab_recidNew     as character no-undo. /*_Recid-Index */
define variable tab_recidOld     as character no-undo. /*_Recid-Index */
define variable tab_RIfstoff     as integer   no-undo. /*_Recid-Index */
define variable tab_RIidx#       as integer   no-undo. /*_Recid-Index */
define variable tab_RILevel      as integer   no-undo. /*_Recid-Index */
define variable tab_RImsc23      as character no-undo. /*_Recid-Index */
define variable tab_Valexp       as character no-undo. /*_Valexp */
define variable tab_Valmsg       as character no-undo. /*_Valmsg */
define variable tab_File-Label   as character no-undo. /*_File-Label */

define TEMP-TABLE w_field no-undo
            field ds_name             as character case-sensitive
            field ds_type             as character
            field pro_Can-Read        as character
            field pro_Can-Writ        as character
            field pro_Col-lbl         as character
            field pro_Decimals        as integer
            field pro_Desc            as character
            field pro_Fld-case        as logical
            field pro_Format          as character
            field pro_Help            as character
            field pro_Initial         as character
            field pro_Label           as character
            field pro_Mandatory       as logical
            field pro_Name            as character
            field pro_Order           as integer
            field pro_type            as character
            field pro_Valexp          as character
            field pro_Valmsg          as character
            index upi        IS UNIQUE PRIMARY ds_name ds_type
            index order      is unique         pro_order.

define temp-table w_index NO-UNDO
            field     pro_Active       like DICTDB._index._Active        
            field     pro_Desc         like DICTDB._index._Desc        
            field     pro_For-Name     like DICTDB._index._For-Name         
            field     pro_idx-num      like DICTDB._index._idx-num     
            field     pro_Index-Name   like DICTDB._index._Index-Name  
            field     pro_Unique       like DICTDB._index._Unique      
            field     pro_Wordidx      like DICTDB._index._Wordidx     
            INDEX upi        IS UNIQUE PRIMARY pro_idx-num
            INDEX for-name                     pro_For-Name.

define temp-table w_index-field NO-UNDO
        field     pro_Abbreviate   like DICTDB._index-field._Abbreviate  
        field     pro_Ascending    like DICTDB._index-field._Ascending   
        field     pro_For-name     like DICTDB._field._For-name 
        field     pro_For-type     like DICTDB._field._For-type      
        field     pro_idx-num      like DICTDB._index._idx-num 
        field     pro_Index-Seq    like DICTDB._index-field._Index-Seq   
        field     pro_Unsorted     like DICTDB._index-field._Unsorted 
        INDEX upi        IS UNIQUE PRIMARY pro_idx-num
                                           pro_For-name
                                           pro_For-type.   

define temp-table y_Tmp-File-Trig
        field     y_Event          like DICTDB._File-Trig._Event
        field     y_Proc-name      like DICTDB._File-Trig._Proc-Name
        field     y_Override       like DICTDB._File-Trig._Override
        field     y_Trig-Crc       like DICTDB._File-Trig._Trig-Crc.
        
define temp-table y_Tmp-Field-Trig
        field     y_Event          like DICTDB._Field-Trig._Event
        field     y_Proc-name      like DICTDB._Field-Trig._Proc-Name
        field     y_Override       like DICTDB._Field-Trig._Override
        field     y_Trig-Crc       like DICTDB._Field-Trig._Trig-Crc
        field     y_Field-Name     like DICTDB._Field._field-Name.
        
define buffer   l_ttb_idx        FOR  s_ttb_idx.


/* LANGUAGE DEPENDENCIES START */ /*--------------------------------*/

define variable err-msg     as character format "x(40)" extent 19
      initial [
/*  1 */ "WARNING: Column &1 is hidden; it cannot be an index component",
/*  2 */ "WARNING: No index for the RECID &1 field",
/*  3 */ "WARNING: No possible RECID-Index found for table &1 (Owner: &2)",
/*  4 */ "WARNING: The Driver sends wrong data about indexes, they cant be build automatically",
/*  5 */ "WARNING: The previously selected index for ROWID functionality for table",
/*  6 */ "WARNING: &1 might be not the optimal index for ROWID functionality.",
/*  7 */ "Use Dictionary to check correctness.",
/*  8 */ "ERROR: TempTable-record for &1 not found.",
/*  9 */ "&1 ",  /* un-used - except debugging messages /**/ */
/* 10 */ "WARNING: The table &1 is frozen. It did not get updated.",
/* 11 */ "DETACHED FILE-TRIGGER   :",
/* 12 */ "DETACHED FIELD-TRIGGER  :",
/* 13 */ "REASSIGNED FILE-TRIGGER :",
/* 14 */ "REASSIGNED FIELD-TRIGGER:",
/* 15 */ "doesn't exist anymore! Trigger cannot be reassigned!",
/* 16 */ "Please check errors, warnings and messages in the file ""ds_upd.e""!",
/* 17 */ "WARNING: Index name changed from &1 to &2!",
/* 18 */ "WARNING: Index &1 changed from UNIQUE to NON-UNIQUE - change not reflected!",
/* 19 */ "Wait, or press any key to continue ..."
              ].     

FORM
                                                    SKIP(1)
  msg[1]   FORMAT "x(29)" LABEL "Object" colon 8 
    "->"
    msg[2] FORMAT "x(25)" LABEL "Object"            SKIP(1)
/** /
  msg[3]   FORMAT "x(29)" LABEL "Column" colon 8 
    "->"
    msg[4] FORMAT "x(25)" LABEL "Field"             SKIP
  msg[5]   FORMAT "x(29)" LABEL "Key"    colon 8 
    "->"
    msg[6] FORMAT "x(25)" LABEL "Index"             SKIP (1)
/ **/
  WITH FRAME ds_make ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED VIEW-AS DIALOG-BOX THREE-D
  TITLE " Transferring " + edbtyp + " Definition " USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*----------------------------------*/
      
/*---------------------  Internal Procedures  ----------------------*/
PROCEDURE delete-file.

/* in case there is no field in the first table */
  if s_1st-error = false
   then do:        
    find first DICTDB._File-Trig  of DICTDB._File no-lock no-error.
    find first DICTDB._Field-Trig of DICTDB._File no-lock no-error.
    if  available DICTDB._File-Trig
     or available DICTDB._Field-Trig
     then do:  /* delete ev. old error.files & set "errors = occured" */
      assign s_1st-error = true.
      output stream s_stm_errors to ds_upd.e.
      output stream s_stm_errors close.
      end.
    end.
                 
  for each DICTDB._File-Trig of DICTDB._File exclusive-lock:

    output stream s_stm_errors to ds_upd.e append.
    put stream s_stm_errors 
      err-msg[11]              format "x(26)"
      DICTDB._File._File-Name  format "x(64)"
      DICTDB._File-Trig._Event format "x(15)" 
      DICTDB._File-Trig._Proc-Name skip.
    output stream s_stm_errors close.

    create y_Tmp-File-Trig.
    assign
      y_Tmp-File-Trig.y_Event     = DICTDB._File-Trig._Event
      y_Tmp-File-Trig.y_Proc-name = DICTDB._File-Trig._Proc-Name
      y_Tmp-File-Trig.y_Override  = DICTDB._File-Trig._Override
      y_Tmp-File-Trig.y_Trig-Crc  = DICTDB._File-Trig._Trig-Crc.
    delete DICTDB._File-Trig.

    end.

  delete DICTDB._File.

  end PROCEDURE.  /* delete-file */

/*------------------------------------------------------------------*/        
      
PROCEDURE delete-field.

/* on delete of DICTDB._Field do:*/

  if s_1st-error = false
   then do:        
    find first DICTDB._File-Trig  of DICTDB._File no-lock no-error.
    find first DICTDB._Field-Trig of DICTDB._File no-lock no-error.
    if  available DICTDB._File-Trig
     or available DICTDB._Field-Trig
     then do:  /* delete ev. old error.files & set "errors = occured" */
      assign s_1st-error = true.
      output stream s_stm_errors to ds_upd.e.
      output stream s_stm_errors close.
      end.
    end.
                 
  for each DICTDB._Field-Trig of DICTDB._Field exclusive-lock:

    output stream s_stm_errors to ds_upd.e append.
    put stream s_stm_errors 
      err-msg[12]               format "x(26)" 
      DICTDB._File._File-Name 
      DICTDB._Field._Field-Name 
      DICTDB._Field-Trig._Event format "x(15)" 
      DICTDB._Field-Trig._Proc-Name skip.
    output stream s_stm_errors close.

    create y_Tmp-Field-Trig.
    assign
      y_Tmp-Field-Trig.y_Event      = DICTDB._Field-Trig._Event
      y_Tmp-Field-Trig.y_Proc-name  = DICTDB._Field-Trig._Proc-Name
      y_Tmp-Field-Trig.y_Override   = DICTDB._Field-Trig._Override
      y_Tmp-Field-Trig.y_Trig-Crc   = DICTDB._Field-Trig._Trig-Crc
      y_Tmp-Field-Trig.y_Field-name = DICTDB._Field._Field-Name.

    delete DICTDB._Field-Trig.

    end.

  delete DICTDB._Field.

  end PROCEDURE.  /* delete-field */

/*------------------------------------------------------------------*/        
      
PROCEDURE create-file.

  define input parameter p_table-name as character.
  
  create DICTDB._File.
  
  for each y_Tmp-File-Trig:     

    output stream s_stm_errors to ds_upd.e append.
    put stream s_stm_errors 
      err-msg[13]           format "x(26)" 
      p_table-name          format "x(64)"
      y_Tmp-File-Trig.y_Event format "x(15)" 
      y_Tmp-File-Trig.y_Proc-Name skip.
    output stream s_stm_errors close.

    create DICTDB._File-Trig.
    assign 
      DICTDB._File-Trig._File-Recid  = RECID(_File)
      DICTDB._File-Trig._Event       = y_Tmp-File-Trig.y_Event
      DICTDB._File-Trig._Proc-Name   = y_Tmp-File-Trig.y_Proc-name 
      DICTDB._File-Trig._Override    = y_Tmp-File-Trig.y_Override  
      DICTDB._File-Trig._Trig-Crc    = ?
                                    /* y_Tmp-File-Trig.y_Trig-Crc */ 
      .
    delete y_Tmp-File-Trig.

    end.        /* create all file-triggers for this file */

  end PROCEDURE.  /* create-file */

      
/*------------------------------------------------------------------*/        
      
Procedure Field-Triggers:

  if CAN-FIND(first y_Tmp-Field-Trig)
   then do:     /* there are field-triggers */
    
    for each y_Tmp-Field-Trig:
      
      find first DICTDB._Field of DICTDB._File
        where DICTDB._Field._Field-Name = y_Tmp-Field-Trig.y_Field-Name
        no-lock no-error.
        
      if not available DICTDB._Field    /* in case a field got dropped or */
       then do:                         /* its name got changed */

        output stream s_stm_errors to ds_upd.e append.
        put stream s_stm_errors 
          err-msg[15]                    format "x(26)" 
          DICTDB._File._File-Name 
          y_Tmp-Field-Trig.y_Field-Name  
          y_Tmp-Field-Trig.y_Event       format "x(15)" 
          y_Tmp-Field-Trig.y_Proc-Name skip.
        output stream s_stm_errors close.

        end.
       else do:  /* found field to reconnect trigger */ 

        output stream s_stm_errors to ds_upd.e append.
        put stream s_stm_errors 
          err-msg[14]                    format "x(26)" 
          DICTDB._File._File-Name 
          y_Tmp-Field-Trig.y_Field-Name 
          y_Tmp-Field-Trig.y_Event      format "x(15)" 
          y_Tmp-Field-Trig.y_Proc-Name skip.
        output stream s_stm_errors close.

        create DICTDB._Field-Trig.
        assign 
          DICTDB._Field-Trig._Field-Recid = RECID(_Field)
          DICTDB._Field-Trig._File-Recid  = RECID(_File)
          DICTDB._Field-Trig._Event       = y_Tmp-Field-Trig.y_Event
          DICTDB._Field-Trig._Proc-Name   = y_Tmp-Field-Trig.y_Proc-name 
          DICTDB._Field-Trig._Override    = y_Tmp-Field-Trig.y_Override  
          DICTDB._Field-Trig._Trig-Crc    = ?
                                         /* y_Tmp-Field-Trig.y_Trig-Crc */
          . 

        end.    /* found field to reconnect trigger */

      delete y_Tmp-Field-Trig.
            
      end.      /* create all field-triggers for this file */
      
    end.        /* there are field-triggers */
  
  end PROCEDURE.  /* Field-Triggers */

/*------------------------------------------------------------------*/        

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
            SUBSTITUTE(err-msg[error-nr],param1,param2)  skip.
  output stream s_stm_errors close.
 
  end PROCEDURE.  /* error_handling */

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

/* Having problems with ds_upd.e being overwritten when set below this leverl */
IF user_env[34] = "true" THEN ASSIGN s_1st-error = TRUE.

FIND DICTDB._Db WHERE RECID(_Db) = drec_db NO-LOCK.

assign
  batch_mode = SESSION:BATCH-MODE
  cache_dirty = TRUE
  edbtyp     = {adecomm/ds_type.i
                 &direction = "itoe"
                 &from-type = "user_dbtype"
                 }
  odbtyp      = {adecomm/ds_type.i
                    &direction = "ODBC"
                    &from-type = "odbtyp"
                }
  .
  
ASSIGN is_as400db = INDEX(DICTDB._Db._Db-misc2[5],"AS/400") > 0 OR
                  INDEX(DICTDB._Db._Db-misc2[5],"DB2/400") > 0.

IF NOT batch_mode then assign SESSION:IMMEDIATE-DISPLAY = yes.

RUN adecomm/_setcurs.p ("WAIT").

if can-do(odbtyp,user_dbtype)
 then assign
    l_char-types = "LONGVARBINARY,LONGVARCHAR,CHAR,VARCHAR,BINARY,VARBINARY,TIME,NVARCHAR,NCHAR,ROWGUID"
    l_chda-types = "TIMESTAMP"
    l_date-types = "DATE"
    l_dcml-types = ""
    l_dein-types = "DECIMAL,NUMERIC,DOUBLE,FLOAT,REAL,BIGINT"
    l_deil-types = "INTEGER,SMALLINT,TINYINT"
    l_intg-types = ""
    l_logi-types = "BIT".
else if user_dbtype = "ORACLE"
   then assign
    l_char-types = "CHAR,VARCHAR,VARCHAR2,ROWID,LONG,RAW,LONGRAW,BLOB,BFILE,NCHAR,NVARCHAR2,CLOB,NCLOB"
    l_chda-types = "DATE,TIMESTAMP,TIMESTAMP_LOCAL,TIMESTAMP_TZ"
    l_date-types = ""
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
/*---------------------------- MAIN-LOOP ---------------------------*/
/*------------------------------------------------------------------*/  

/*---------------------------- Sequences ---------------------------*/  

for each gate-work
  where gate-work.gate-slct = TRUE:
  if not
   (    gate-work.gate-type = "SEQUENCE"
   or ( gate-work.gate-type = "SYNONYM"
        and gate-work.gate-edit <> ""
        and  entry(3,gate-work.gate-edit,":") = "SEQUENCE"
   )  )
   then next.  /* neither sequence nor synonym for a sequence */

  find first s_ttb_seq
    where RECID(s_ttb_seq) = gate-work.ttb-recid
    no-error.
  if not available s_ttb_seq
   then do:
    if SESSION:BATCH-MODE and logfile_open
     then put stream logfile unformatted
       "SEQUENCE"               at 10
       gate-work.gate-name      at 25
       "NO s_ttb_seq FOUND !!!" at 60 skip.
    run error_handling(8, gate-work.gate-name ,"").
    next.
    end.
  
  if TERMINAL <> "" and NOT batch_mode
   then DISPLAY 
      s_ttb_seq.ds_name  @ msg[1]
      s_ttb_seq.pro_name @ msg[2]
      WITH FRAME ds_make.


  if SESSION:BATCH-MODE and logfile_open
   then put stream logfile unformatted  "SEQUENCE" at 15 (s_ttb_seq.ds_user + "." + s_ttb_seq.ds_name) at 30.

  if s_ttb_seq.pro_recid = ?
   then do:  /* s_ttb_seq.pro_recid = ? */

    if user_dbtype = "ORACLE" then
      DO:
      ASSIGN for_name = s_ttb_seq.ds_name.
      IF for_name begins '"' then /* OE00170417: string may be quoted */
        ASSIGN for_name = TRIM(s_ttb_seq.ds_name,'"').
      find first DICTDB._Sequence
      where DICTDB._Sequence._Db-Recid    = drec_db
      and ( DICTDB._Sequence._Seq-Misc[1] = s_ttb_seq.ds_name 
           OR DICTDB._Sequence._Seq-Misc[1]  = for_name) /* OE00170417: string may be quoted */
      and   DICTDB._Sequence._Seq-Misc[2] = s_ttb_seq.ds_user
      and   DICTDB._Sequence._Seq-misc[8] = s_ttb_seq.ds_spcl
      no-error.
     END.
    else if can-do(odbtyp,user_dbtype) then DO:
      find first DICTDB._Sequence
        where DICTDB._Sequence._Db-Recid    = drec_db
        and   DICTDB._Sequence._Seq-Misc[1] = s_ttb_seq.ds_name
        and   DICTDB._Sequence._Seq-Misc[2] = s_ttb_seq.ds_user
        no-error.
      /* OE00170189- code executed only for MSS dbtype */
      if user_dbtype = "MSS" THEN DO:
        if not available DICTDB._Sequence then DO:
          assign other-seq-name = "".
	  IF (s_ttb_seq.ds_name BEGINS "_SEQT_REV_" and s_ttb_seq.ds_name NE "_SEQT_REV_SEQTMGR" )
		   THEN assign other-seq-name = "_SEQT_" + SUBSTRING(s_ttb_seq.ds_name,11,-1,"character").
	  ELSE IF (s_ttb_seq.ds_name BEGINS "_SEQT_") 
		   THEN assign other-seq-name = "_SEQT_REV_" + SUBSTRING(s_ttb_seq.ds_name,7,-1,"character"). 
	  find first DICTDB._Sequence
            where DICTDB._Sequence._Db-recid     = drec_db
	    and   DICTDB._Sequence._Seq-Misc[1]  = other-seq-name 
            and   DICTDB._Sequence._Seq-misc[2]  = s_ttb_seq.ds_user
            no-error.
        end. 
      end.
    end.

    if not available DICTDB._Sequence
     then find first DICTDB._Sequence
      where DICTDB._Sequence._Seq-name     = s_ttb_seq.pro_name
      and   DICTDB._Sequence._Db-recid     = drec_db
      and   DICTDB._Sequence._Seq-misc[2]  = "%TEMPORARY%"
      no-error.

    end.     /* s_ttb_seq.pro_recid = ? */

   else find first DICTDB._Sequence
    where RECID(DICTDB._Sequence) = s_ttb_seq.pro_recid
    no-error.

  if not available DICTDB._Sequence
   then do:  
    if SESSION:BATCH-MODE and logfile_open
     then put stream logfile unformatted  "NEW" at 60 skip.

    create DICTDB._Sequence.
    assign
      DICTDB._Sequence._Db-Recid    = drec_db
      DICTDB._Sequence._Seq-Name    = s_ttb_seq.pro_name.
    end.
   else if SESSION:BATCH-MODE and logfile_open
     then put stream logfile unformatted skip.
  
   assign
     DICTDB._Sequence._Seq-Incr    = s_ttb_seq.ds_incr
     DICTDB._Sequence._Seq-Init    = s_ttb_seq.ds_min
     DICTDB._Sequence._Seq-Max     = s_ttb_seq.ds_max
     DICTDB._Sequence._Seq-Min     = s_ttb_seq.ds_min
     DICTDB._Sequence._Cycle-ok    = s_ttb_seq.ds_cycle
     DICTDB._Sequence._Seq-Misc[1] = s_ttb_seq.ds_name
     DICTDB._Sequence._Seq-Misc[2] = s_ttb_seq.ds_user
     DICTDB._Sequence._Seq-misc[3] = ( if can-do(odbtyp,user_dbtype)
                                        then s_ttb_seq.ds_spcl
                                        else DICTDB._Sequence._Seq-misc[3]
                                     )
     DICTDB._Sequence._Seq-misc[8] = ( if user_dbtype = "ORACLE"
                                        then s_ttb_seq.ds_spcl
                                        else DICTDB._Sequence._Seq-misc[8]
                                     ).
END.

/*------------------------------ Tables ----------------------------*/  

for each gate-work
  where gate-work.gate-slct = TRUE:

  if  gate-work.gate-type = "SEQUENCE" 
   or gate-work.gate-type = "PROGRESS" then next.
  
  for each s_ttb_tbl
    where recid(gate-work) = s_ttb_tbl.gate-work:

    /* just in case some garbage left over */
    for each w_field:       delete w_field.         end.
    for each w_index:       delete w_index.         end.
    for each w_index-field: delete w_index-field.   end.

    if TERMINAL <> "" and NOT batch_mode
     then DISPLAY 
        s_ttb_tbl.ds_name  @ msg[1]
        s_ttb_tbl.pro_name @ msg[2]
        WITH FRAME ds_make.

    if SESSION:BATCH-MODE and logfile_open
     then put stream logfile unformatted
       s_ttb_tbl.ds_type at 15 
       (s_ttb_tbl.ds_user + "." + s_ttb_tbl.ds_name) at 30.

    if s_ttb_tbl.pro_recid <> ?
     then find first DICTDB._File
        where RECID(DICTDB._File)        = s_ttb_tbl.pro_recid
        no-error.
    else if user_dbtype = "ORACLE"
     and s_ttb_tbl.ds_msc21 <> ?
     and s_ttb_tbl.ds_msc21 <> "" then
      DO:
        ASSIGN for_name = s_ttb_tbl.ds_name.
        IF for_name begins '"' then /* OE00170417: string may be quoted */
           ASSIGN for_name = TRIM(s_ttb_tbl.ds_name,'"').
        find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and ( DICTDB._File._For-name     = s_ttb_tbl.ds_name
              OR DICTDB._File._For-name  = for_name )/* OE00170417:string may be quoted*/
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        and   DICTDB._File._Fil-misc2[8] = s_ttb_tbl.ds_spcl
        and   DICTDB._File._Fil-misc2[1] = s_ttb_tbl.ds_msc21
        no-error.
     END.
    else if user_dbtype = "ORACLE" then
     DO:
        ASSIGN for_name = s_ttb_tbl.ds_name.
        IF for_name begins '"' then /* OE00170417: string may be quoted */
           ASSIGN for_name = TRIM(s_ttb_tbl.ds_name,'"').
        find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and ( DICTDB._File._For-name     = s_ttb_tbl.ds_name
              OR DICTDB._File._For-name  = for_name )/* OE00170417:string may be quoted*/
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        and   DICTDB._File._Fil-misc2[8] = s_ttb_tbl.ds_spcl
        no-error.
     END.
    else if can-do(odbtyp,user_dbtype)
     then find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and   DICTDB._File._For-name     = s_ttb_tbl.ds_name
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        and   DICTDB._File._Fil-misc2[1] = s_ttb_tbl.ds_spcl
        no-error.
     else find first DICTDB._File
        where DICTDB._File._Db-Recid     = drec_db
        and   DICTDB._File._For-name     = s_ttb_tbl.ds_name
        and   DICTDB._File._For-owner    = s_ttb_tbl.ds_user
        no-error.
    assign
      oldf         = available DICTDB._File
      tab_recidNew = ""
      tab_recidOld = "".

  
    assign tab_PrimeIdx = ?.


/*---------------------- SAVE CURRENT VALUES -----------------------*/

    if oldf
     then do:  /* retain all file, index and field-information */

      if DICTDB._File._Frozen = TRUE
       then do:
        run error_handling(10, DICTDB._File._File-name, "").
        next.
        end.
    
      for each DICTDB._Constraint of  DICTDB._File:
         for each DICTDB._Constraint-Keys WHERE DICTDB._Constraint-Keys._Con-Recid  = RECID(DICTDB._constraint):
           delete DICTDB._Constraint-Keys.
         end.  
         delete DICTDB._Constraint.
      end.

      for each DICTDB._Index of DICTDB._File:     /*---- Indexes -----*/
      
        for each DICTDB._Index-field of DICTDB._Index:
          find first DICTDB._Field of DICTDB._Index-field.
          create w_index-field.
          assign
            w_index-field.pro_Abbreviate = DICTDB._index-field._Abbreviate
            w_index-field.pro_Ascending  = DICTDB._index-field._Ascending
            w_index-field.pro_For-name   = DICTDB._field._For-name
            w_index-field.pro_For-type   = DICTDB._field._For-type
            w_index-field.pro_idx-num    = DICTDB._index._idx-num   
            w_index-field.pro_Index-Seq  = DICTDB._index-field._Index-Seq
            w_index-field.pro_Unsorted   = DICTDB._index-field._Unsorted.
          delete DICTDB._Index-field.
          end.  /* for each DICTDB._Index-Field */
          
        if DICTDB._File._Prime-Index = RECID(DICTDB._Index) 
         then assign
          tab_PrimeIdx = DICTDB._Index._Index-name
          tab_PIForNum = DICTDB._index._idx-num.
        create w_index.
        assign
          w_index.pro_active     = DICTDB._index._active  
          w_index.pro_Desc       = DICTDB._index._Desc  
          w_index.pro_For-Name   = DICTDB._index._For-Name  
          w_index.pro_idx-num    = DICTDB._index._idx-num  
          w_index.pro_Index-Name = DICTDB._index._Index-Name  
          w_index.pro_WordIdx    = DICTDB._index._WordIdx  
          w_index.pro_Unique     = DICTDB._index._Unique
          tab_recidOld           = ( if DICTDB._index._I-misc2[1] begins "r"
                                      then DICTDB._index._For-Name
                                    else tab_recidOld
                                 ). 
        delete DICTDB._Index.
        
        end.  /* for each DICTDB._Index */
   
      for each DICTDB._Field OF DICTDB._File:     /*----- fields -----*/
          ASSIGN fld-dif = FALSE.
          CREATE w_field.
          assign
            w_field.ds_Name      = DICTDB._Field._For-name
            w_field.ds_Type      = DICTDB._Field._For-type
            w_field.pro_Can-Read = DICTDB._Field._Can-Read
            w_field.pro_Can-Writ = DICTDB._Field._Can-Write
            w_field.pro_Col-lbl  = DICTDB._Field._Col-label
            w_field.pro_Decimals = DICTDB._Field._Decimals
            w_field.pro_Desc     = DICTDB._Field._Desc
            w_field.pro_type     = DICTDB._Field._Data-type
            w_field.pro_fld-case = DICTDB._Field._Fld-case
            w_field.pro_Format   = DICTDB._Field._Format
            w_field.pro_Help     = DICTDB._Field._Help
            w_field.pro_Initial  = DICTDB._Field._Initial
            w_field.pro_Label    = DICTDB._Field._Label
            w_field.pro_Name     = DICTDB._Field._Field-name
            w_field.pro_Order    = DICTDB._Field._Order
            w_field.pro_Valexp   = DICTDB._Field._Valexp
            w_field.pro_Valmsg   = DICTDB._Field._Valmsg.

        RUN delete-field.
        end.   /* for each DICTDB._Field OF DICTDB._File */
      
      assign
/*      tab_name     = DICTDB._File._File-name  */
        tab_Can-Crea = DICTDB._File._Can-Create
        tab_Can-Dele = DICTDB._File._Can-Delete
        tab_Can-Read = DICTDB._File._Can-Read
        tab_Can-Writ = DICTDB._File._Can-Write
        tab_Desc     = DICTDB._File._Desc
        tab_Dump-nam = DICTDB._File._Dump-name
        tab_Hidden   = DICTDB._File._Hidden
        tab_Valexp   = DICTDB._File._Valexp
        tab_Valmsg   = DICTDB._File._Valmsg
        tab_File-Label = DICTDB._File._File-Label.
	
      RUN delete-file.

      end.     /* retain all file, index and field-information */

/*--------------------------- CREATION -----------------------------*/

    RUN create-file (INPUT s_ttb_tbl.pro_name).
/*                                                      ORA    others
 *                                                     pro/ds  pro/ds
 * s_ttb_tbl.ds_recid > 0 -> progress_recid             # / ?   # / ?
 *                    = 0 -> use nativ rowid            ? /-#   # / ?
 *                    < 0 -> normal column for recid    ? /-#   # / ?
 */
 
    assign
      l_pro_recid                = ( if     user_dbtype         = "ORACLE"
                                        and s_ttb_tbl.ds_recid <= 0
                                        then ? /* no progress_recid */
                                        else s_ttb_tbl.ds_recid
                                   )
      l_ds_recid                 = ( if l_pro_recid = ?
                                        then s_ttb_tbl.ds_recid * -1
                                        else ?
                                   )
      DICTDB._File._File-Name    = s_ttb_tbl.pro_name
      DICTDB._File._Desc         = s_ttb_tbl.pro_desc
      DICTDB._File._Db-recid     = drec_db
      DICTDB._File._ianum        = def-ianum
      DICTDB._File._Fil-misc1[1] = l_pro_recid /* might change */
      DICTDB._File._Fil-misc1[2] = s_ttb_tbl.ds_rowid /* might change */
      DICTDB._File._Fil-misc1[3] = s_ttb_tbl.ds_msc13
      DICTDB._File._Fil-misc1[4] = l_ds_recid
      DICTDB._File._Fil-misc2[1] = ( if can-do(odbtyp,user_dbtype)
                                      then s_ttb_tbl.ds_spcl /* qualifier */
                                      else s_ttb_tbl.ds_msc21
                                   )
      DICTDB._File._Fil-misc2[2] = s_ttb_tbl.ds_msc22
      DICTDB._File._Fil-misc2[3] = s_ttb_tbl.ds_msc23 /* might change */
      DICTDB._File._Fil-misc2[4] = s_ttb_tbl.ds_msc24
      DICTDB._File._Fil-misc2[5] = s_ttb_tbl.ds_msc25 /* FORCESEEK */
      DICTDB._File._Fil-misc2[8] = ( if can-do("ORACLE",user_dbtype)
                                      then s_ttb_tbl.ds_spcl /* db-link */
                                      else DICTDB._File._Fil-misc2[8]
                                   )
      DICTDB._File._For-type     = s_ttb_tbl.ds_type
      DICTDB._File._For-owner    = s_ttb_tbl.ds_user
      DICTDB._File._For-name     = s_ttb_tbl.ds_name.
      DICTDB._File._Fil-misc1[5] = s_ttb_tbl.ds_msc15.
      DICTDB._File._Fil-misc1[6] = s_ttb_tbl.ds_msc16. /* RECID Indicator */
    if oldf
     then assign
      DICTDB._File._Can-Create   = tab_Can-Crea
      DICTDB._File._Can-Read     = tab_Can-Read
      DICTDB._File._Can-Write    = tab_Can-Writ
      DICTDB._File._Can-Delete   = tab_Can-Dele
      DICTDB._File._Desc         = ( if   tab_Desc <> ""
                                      and tab_Desc <> ?
                                      then tab_Desc
                                      else DICTDB._File._Desc
                                   )
      DICTDB._File._Valexp       = tab_Valexp
      DICTDB._File._Valmsg       = tab_Valmsg
      DICTDB._File._Hidden       = tab_Hidden
      DICTDB._File._Dump-name    = tab_Dump-nam
      DICTDB._File._File-Label   = tab_File-Label.
      


/*---------------------------- FIELDS ------------------------------*/
    
    find last w_field where w_field.pro_order > 0 no-error.
    if available w_field
     then assign l_order-max = w_field.pro_order + 10.
     else assign l_order-max = 0.

    for each s_ttb_fld where s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):
      IF s_ttb_fld.ds_name BEGINS "SYS_NC" THEN NEXT.
      /* if the main-part of date-field is of type character we don't
       * need the time-part, so we skip it... Same for datetime/tz.
       */
      IF lookup(s_ttb_fld.ds_type,l_chda-types) <> 0
           and s_ttb_fld.pro_type  =  "integer"
           and can-find( w_field where w_field.ds_name  = s_ttb_fld.ds_name
                                   and (w_field.pro_type = "character"  OR
                                        w_field.pro_type BEGINS "datetime"))
       then next.

      /* we need to find the w_field by name PLUS type because of
       * date-time fields....
       */
      if lookup(s_ttb_fld.ds_type,l_chda-types) <> 0
       then find first w_field where w_field.ds_name = s_ttb_fld.ds_name
                                 and lookup(w_field.ds_type,"character,date,datetime,datetime-tz") <> 0 no-error.
      else find first w_field where w_field.ds_name = s_ttb_fld.ds_name
                                and w_field.ds_type = s_ttb_fld.ds_type no-error.
      if not available w_field then 
        find first w_field where w_field.ds_name = s_ttb_fld.ds_name no-error.

      /* OE00170417: name may be quoted for ORACLE */
      if not available w_field and user_dbtype = "ORACLE" and s_ttb_fld.ds_name begins '"' then 
         find first w_field where w_field.ds_name = TRIM(s_ttb_fld.ds_name,'"') no-error.

      if available w_field and w_field.ds_type begins "date"
                           and s_ttb_fld.pro_type = "integer" THEN DO:
         IF w_field.pro_type = "date" THEN
            release w_field.
         ELSE IF w_field.pro_type BEGINS "datetime" THEN
             /* don't need time portion if mapping to datetime/tz */
             NEXT.
      END.

      IF AVAILABLE w_field  THEN do:
          IF w_field.pro_type = "character" AND w_Field.pro_type <> s_ttb_fld.pro_type THEN
          DO:
              /* for MSS, character/blob are supported mappings for varbinary */
              IF user_dbtype NE "MSS" OR s_ttb_fld.pro_type NE "BLOB" THEN
                 ASSIGN fld-dif = TRUE.
          END.
          ELSE IF s_ttb_fld.pro_type = "character" AND w_Field.pro_type <> s_ttb_fld.pro_type THEN DO:
              /* for MSS, character/blob are supported mappings for varbinary */
              IF user_dbtype NE "MSS" OR w_Field.pro_type NE "BLOB" THEN
                 ASSIGN fld-dif = TRUE.
          END.
          /* OE00168850 - check for foreign type change for timestamp */
          ELSE IF (LOOKUP(w_field.ds_type,"date,timestamp") <> 0 OR
                   LOOKUP(s_ttb_fld.ds_type,"date,timestamp") <> 0)
                   AND s_ttb_fld.ds_type <> w_field.ds_Type THEN
               ASSIGN fld-dif = TRUE.

      END.
          
      IF NOT AVAILABLE w_field AND s_ttb_fld.pro_type = "date" then
          ASSIGN s_ttb_fld.pro_frmt = "99/99/99".

      CREATE DICTDB._Field.
      ASSIGN DICTDB._Field._Desc   = ( if available w_field
                                          and w_field.pro_desc <> ""
                                          and w_field.pro_desc <> ?
                                          then w_field.pro_desc
                                          else s_ttb_fld.pro_desc
                                      )
        DICTDB._Field._Data-type   = ( IF AVAILABLE w_field AND NOT fld-dif THEN w_field.pro_type
                                        ELSE s_ttb_fld.pro_type
                                      )
        DICTDB._Field._Extent       = s_ttb_fld.pro_extnt
        DICTDB._Field._Field-Name   = ( if available w_field
                                          then w_field.pro_name
                                          else s_ttb_fld.pro_name
                                      )
        DICTDB._Field._File-recid   = RECID(DICTDB._File)
        DICTDB._Field._Fld-Case     = s_ttb_fld.pro_case
        DICTDB._Field._Fld-misc1[1] = s_ttb_fld.ds_prec
        DICTDB._Field._Fld-misc1[2] = s_ttb_fld.ds_scale
        DICTDB._Field._Fld-misc1[3] = s_ttb_fld.ds_lngth
        DICTDB._Field._Fld-misc1[4] = s_ttb_fld.ds_radix
        DICTDB._Field._Fld-misc1[5] = s_ttb_fld.ds_shd#
        DICTDB._Field._Fld-misc1[7] = s_ttb_fld.ds_msc17
        DICTDB._Field._Fld-misc2[2] = ( if user_dbtype = "ORACLE"
                                        then s_ttb_fld.ds_shdn
                                        else DICTDB._Field._Fld-misc2[2]
                                      )
        DICTDB._Field._Fld-misc2[3] = s_ttb_fld.ds_msc23
        DICTDB._Field._Fld-misc2[4] = s_ttb_fld.ds_msc24
        DICTDB._Field._Fld-misc2[5] = ( if can-do(odbtyp,user_dbtype)
                                        then s_ttb_fld.ds_shdn
                                        else IF user_dbtype = "ORACLE" 
                                            THEN s_ttb_fld.ds_msc25 
                                            ELSE DICTDB._Field._Fld-misc2[5]
                                      )
        DICTDB._Field._Fld-misc2[6] = s_ttb_fld.ds_msc26
        DICTDB._Field._Fld-stoff    = s_ttb_fld.ds_stoff
        DICTDB._Field._Fld-stdtype  = s_ttb_fld.ds_stdtype
        DICTDB._Field._For-Itype    = s_ttb_fld.ds_Itype
        DICTDB._Field._For-Name     = s_ttb_fld.ds_name
        DICTDB._Field._For-type     = s_ttb_fld.ds_type
        DICTDB._Field._For-Allocated = ( if user_dbtype = "ORACLE"
                                         THEN s_ttb_fld.ds_allocated
                                         ELSE DICTDB._Field._For-Allocated
                                       )
        DICTDB._Field._Mandatory    = s_ttb_fld.pro_mand
        DICTDB._Field._Decimals     = s_ttb_fld.pro_dcml
        DICTDB._Field._Order        = ( if available w_field
                                         then w_field.pro_order
                                         else l_order-max 
                                            + s_ttb_fld.pro_order
                                      )       
        DICTDB._Field._Format       = ( IF AVAILABLE w_field AND NOT fld-dif THEN w_field.pro_format 
                                        ELSE s_ttb_fld.pro_frmt
                                      )
        DICTDB._Field._Initial      = ( IF DICTDB._Field._Data-type = "CLOB" THEN ? /* TEMPORARY */
                                        ELSE IF AVAILABLE w_field AND NOT fld-dif THEN w_field.pro_init
                                        ELSE s_ttb_fld.pro_init
                                      )
        s_ttb_fld.fld_recid         = RECID(DICTDB._Field).
     
      IF user_dbtype = "ODBC" OR user_dbtype = "MSS" THEN DO:
        IF DICTDB._Field._Mandatory THEN
          ASSIGN DICTDB._Field._Fld-Misc2[2] = "N".
        ELSE
          ASSIGN DICTDB._Field._Fld-Misc2[2] = "Y".
      END.

      if (user_dbtype = "ODBC" AND is_as400db) THEN
       ASSIGN
        DICTDB._Field._Label   = ( if available w_field
                                          and w_field.pro_Label <> ""
                                          and w_field.pro_Label <> ?
                                          then w_field.pro_Label
                                          else s_ttb_fld.pro_desc
                                      )
        DICTDB._Field._Col-Label   = ( if available w_field
                                          and w_field.pro_Col-lbl <> ""
                                          and w_field.pro_Col-lbl <> ?
                                          then w_field.pro_Col-lbl
                                          else s_ttb_fld.pro_desc
                                      ).

      IF user_dbtype = "MSS" AND DICTDB._Db._Db-misc1[1] = 1 
                             AND DICTDB._Field._Data-type = "character" THEN
        ASSIGN DICTDB._Field._Fld-Case  = FALSE.
                                                        
      IF user_dbtype = "ORACLE" THEN DO:
        CASE DICTDB._Field._Data-type:
          WHEN "CHARACTER" THEN DO:
            IF DICTDB._Field._For-type = "ROWID" THEN
               DO:
                 ASSIGN DICTDB._Field._Can-Write = ""
                        DICTDB._Field._For-Maxsize = 18.
               END.
            IF DICTDB._Field._For-type = "Char" OR
               DICTDB._Field._For-type = "VarChar" OR
               DICTDB._Field._For-type = "VarChar2" 
                OR DICTDB._Field._For-type = "NChar" 
                 OR DICTDB._Field._For-type = "NVarChar2"  THEN
                 ASSIGN DICTDB._Field._For-Maxsize = DICTDB._Field._Fld-Misc1[3].
          END.
          WHEN "INTEGER" OR WHEN "LOGICAL" THEN DO:
            IF DICTDB._Field._For-type = "NUMBER" OR
               DICTDB._Field._For-type = "LOGICAL" THEN
                 ASSIGN DICTDB._Field._For-Maxsize = 10.
          END.       
          WHEN "DECIMAL" THEN DO:
            IF DICTDB._Field._For-type = "DECIMAL" THEN DO:
              IF DICTDB._Field._Fld-misc1[2] <> 0 OR DICTDB._Field._Fld-misc1[2] <> ?
                THEN ASSIGN DICTDB._Field._For-Maxsize = DICTDB._Field._Fld-misc1[1] + 1.
            END.
            ELSE
                ASSIGN DICTDB._Field._For-Maxsize = DICTDB._Field._Fld-misc1[1].
          END.
          WHEN "INT64" THEN DO:
              IF DICTDB._Field._For-type = "NUMBER" THEN
                 ASSIGN DICTDB._Field._For-Maxsize = 19.
          END.
          WHEN "RAW" THEN 
            IF DICTDB._Field._For-type = "RAW" THEN
              ASSIGN DICTDB._Field._For-Maxsize = DICTDB._Field._Fld-misc1[1].
          WHEN "CLOB" THEN DO:
                ASSIGN DICTDB._Field._Charset = DICTDB._Db._Db-xl-name
                    DICTDB._Field._Collation = (IF DICTDB._DB._Db-coll-name <> ? THEN DICTDB._DB._Db-coll-name
                                                ELSE SESSION:CPCOLL)
                    DICTDB._Field._Attributes1 = 1. /* should always be 1 (i.e dbcodepage) */
            END.
        END CASE.      
      END.

      if available w_field then do:            
        if (
         (   can-do(l_char-types + "," + l_chda-types               ,s_ttb_fld.ds_type)
         AND can-do("character"              ,w_field.pro_type) )
         OR
         (   can-do(l_chda-types                                    ,s_ttb_fld.ds_type) 
         AND can-do("character,date,datetime,datetime-tz",w_field.pro_type) )
         OR
         (   can-do(l_chda-types + "," + l_date-types               ,s_ttb_fld.ds_type) 
         AND can-do("date"                   ,w_field.pro_type) )
         OR
         (   can-do(l_dcml-types + "," + l_deil-types + "," + l_dein-types,s_ttb_fld.ds_type) 
         AND can-do("decimal"                ,w_field.pro_type) )
         OR
         (   can-do(l_deil-types                                    ,s_ttb_fld.ds_type) 
         AND can-do("decimal,integer,logical",w_field.pro_type) )
         OR
         (   can-do(l_deil-types + "," + l_dein-types               ,s_ttb_fld.ds_type) 
         AND can-do("decimal,integer"        ,w_field.pro_type) )
         OR
         (   can-do(l_deil-types + "," + l_dein-types + "," + l_intg-types,s_ttb_fld.ds_type) 
         AND can-do("integer"                ,w_field.pro_type) )
         OR
         (   can-do(l_deil-types + "," + l_logi-types               ,s_ttb_fld.ds_type) 
         AND can-do("logical"                ,w_field.pro_type) )
            )
         then ASSIGN DICTDB._Field._Decimals  = w_field.pro_decimals.

        assign
          DICTDB._Field._Can-Read  = w_field.pro_Can-Read
          DICTDB._Field._Can-Write = w_field.pro_Can-Writ
          DICTDB._Field._Col-label = w_field.pro_Col-lbl
          DICTDB._Field._Fld-case  = DICTDB._Field._Fld-case
                                  or ( DICTDB._Field._Data-type = "character" 
                                         AND w_field.pro_Fld-case )
                  /* could change lateron!
                   * In case there's a shadow-column for this field
                   * _Fld-case will get set to FALSE in _odb_mak.p
                   */
          DICTDB._Field._Help      = w_field.pro_Help
          DICTDB._Field._Label     = w_field.pro_Label
          DICTDB._Field._Mandatory = ( DICTDB._Field._Mandatory
                                         OR w_field.pro_Mandatory )
          DICTDB._Field._Valexp    = w_field.pro_Valexp
          DICTDB._Field._Valmsg    = w_field.pro_Valmsg.
      
        end.  /* available w_field */

      end.  /* for each s_ttb_fld */

/* since we keep adding fields to the end of the file, the order-numbers
 * will increase pretty high, so we reorder the new added fields in a
 * way that garanties to have just 10 as spacing
 */
    find last DICTDB._Field of DICTDB._File
      where DICTDB._Field._Order >= l_order-max
      no-lock no-error.
    if available DICTDB._Field
     and l_order-max > 0
     then do:  /* renumber new fields */

      /* calculate the number to shift new fields back */
      assign
        i    = DICTDB._Field._Order + 10 - l_order-max
        indn = 10.
      for each DICTDB._Field of DICTDB._File
        where DICTDB._Field._Order >= l_order-max:
        assign indn = indn + 10.
        end.
      assign i = max(i, indn).

      if indn > 20
       then do:  /* more than one new fields */

        /* move new-fields back, to generate enough free space */
        for each DICTDB._Field of DICTDB._File
          where DICTDB._Field._Order >= l_order-max
          and   DICTDB._Field._Order < i + l_order-max:
          assign
            DICTDB._Field._Order = i + DICTDB._Field._Order.
          end.

        /* move new-fields forward, giving them their new, real number */
        assign indn = 0.
        for each DICTDB._Field of DICTDB._File
          where DICTDB._Field._Order > i + l_order-max:
          assign
            DICTDB._Field._Order = l_order-max + indn
            indn                 = indn + 10.
          end.

        end.     /* more than one new fields */

       else do:  /* only one new fields */
        find first DICTDB._Field of DICTDB._File
          where DICTDB._Field._Order >= l_order-max.
        assign
          DICTDB._Field._Order = l_order-max + 10.
        end.     /* only one new fields */
        
      end.     /* renumber new fields */


/*----------------------------- INDEXES ------------------------------*/

    for each s_ttb_idx
      where s_ttb_idx.ttb_tbl = RECID(s_ttb_tbl)
      by    s_ttb_idx.ds_name:

      IF (user_dbtype = "MSS" OR user_dbtype = "ODBC") AND
        ds_name MATCHES "*progress_recid*"  THEN
       NEXT.

      if user_dbtype = "SYB"
       then do:
        find first w_index
          where w_index.pro_for-name = s_ttb_idx.ds_name
                                     + STRING(s_ttb_idx.pro_Idx#)
          no-error.
        if not available w_index
         then find first w_index
          where w_index.pro_for-name = s_ttb_idx.ds_name
                                     + STRING(w_index.pro_idx-num)
          no-error.
        end.
       else find first w_index
        where w_index.pro_for-name = s_ttb_idx.ds_name
        no-error.

      /* OE00170417 name may be quoted for ORACLE */
      if not available w_index and user_dbtype = "ORACLE" and s_ttb_idx.ds_name begins '"' then 
          find first w_index  where w_index.pro_for-name = TRIM(s_ttb_idx.ds_name,'"')  no-error.

    /* We have two index-lists with each unique names within itself.
     * However, these two list are connected by foreign-name and not by 
     * PROGRESS-name!
     * When creating the indexes we go thru all s_ttb-idx but give the 
     * index the name of the w_index (we want to retain as much as
     * possible).
     * There are two possible problem-cases:
     * a) we don't find a corresponding w_index record, however
     *    there is another one with this progress-name
     * b) we do find the corresponding w_index record, but another
     *    s_ttb_idx uses the w_index's progress name
     * in both cases we have to switch the names
     */
      if not available w_index
       then do:  /* check if s_ttb_idx.pro_name is used in other w_index */
     
        assign i = 1.
        find first w_index
          where w_index.pro_index-name = s_ttb_idx.pro_name
          no-error.
        repeat while available w_index:  /* potential problem */

        /* find corresponding l_ttb_idx */
          if user_dbtype = "SYB"
           then do:
            find first l_ttb_idx
              where l_ttb_idx.ds_name 
                  + STRING(s_ttb_idx.pro_Idx#) = w_index.pro_for-name
              no-error.
            if not available l_ttb_idx
             then find first l_ttb_idx
              where l_ttb_idx.ds_name 
                  + STRING(w_index.pro_idx-num) = w_index.pro_for-name
              no-error.
            end.
           else find first l_ttb_idx
              where l_ttb_idx.ds_name  = w_index.pro_for-name
              no-error.

        /* ev. switch progress-names */
          if available l_ttb_idx
           then do:  /* switch names */
            assign
              user_env[1]        = l_ttb_idx.pro_name
              /* w_index.pro_index-name := s_ttb_idx.pro_name */
              s_ttb_idx.pro_name = ? 
              l_ttb_idx.pro_name = w_index.pro_index-name
              s_ttb_idx.pro_name = user_env[1].
          /* another potential names-collision? */
            find first w_index
              where w_index.pro_index-name = s_ttb_idx.pro_name
              no-error.
            end.     /* switch names */

          else if w_index.pro_For-name = ?
           then do:  /* user-defined index exists -> change name */
            assign
             s_ttb_idx.pro_name = ( if i > 9
                                     then substring
                                      (s_ttb_idx.pro_name
                                      ,1
                                      ,length(s_ttb_idx.pro_name
                                             ,"character"
                                             ) - 3
                                      ,"character"
                                      ) + string(0 - i,"-99")
                                    else if i > 1
                                     then substring
                                      (s_ttb_idx.pro_name
                                      ,1
                                      ,length(s_ttb_idx.pro_name
                                             ,"character"
                                             ) - 2
                                      ,"character"
                                      ) + string(0 - i,"-9")
                                     else s_ttb_idx.pro_name
                                        + string(0 - i,"-9")
                                    )
             i = i + 1.
          /* another potential names-collision? */
            find first w_index
              where w_index.pro_index-name = s_ttb_idx.pro_name
              no-error.
            end.     /* user-defined index exists -> change name */

           else release w_index.

          end.     /* repeat while available w_index:  potential problem */
        
        end.     /* check if s_ttb_idx.pro_name is used in other w_index */

       else do:  /* check if w_index' name gets used by another s_ttb_idx */

        find first l_ttb_idx
          where l_ttb_idx.ttb_tbl  = RECID(s_ttb_tbl)
          and   l_ttb_idx.pro_name = w_index.pro_index-name
          and   RECID(l_ttb_idx)  <> RECID(s_ttb_idx)
          no-error.

        if available l_ttb_idx
         then assign 
           user_env[1]        = s_ttb_idx.pro_name
           /* w_index.pro_index-name := l_ttb_idx.pro_name */
           l_ttb_idx.pro_name = ? 
           s_ttb_idx.pro_name = w_index.pro_index-name
           l_ttb_idx.pro_name = user_env[1].

        end.     /* check if w_index' name gets used by another s_ttb_idx */

      create DICTDB._Index.
      assign
        DICTDB._Index._Index-Name = ( if available w_index
                                       then w_index.pro_index-name
                                       else s_ttb_idx.pro_name
                                    )
        DICTDB._Index._File-recid = RECID(DICTDB._File)
        DICTDB._Index._ianum      = def-ianum
        DICTDB._Index._Unique     = ( s_ttb_idx.pro_uniq
                                       or  ( AVAILABLE w_index 
                                       and   w_index.pro_unique )
                                    )
        DICTDB._Index._For-name   = s_ttb_idx.ds_name 
                                  + ( if user_dbtype = "SYB"
                                        then string(s_ttb_idx.pro_Idx#)
                                        else ""
                                    )
        DICTDB._Index._Idx-num    = s_ttb_idx.pro_idx#
        DICTDB._Index._Active     = s_ttb_idx.pro_actv
        DICTDB._Index._Desc       = ( if available w_index
                                       then w_index.pro_Desc
                                       else ""
                                    )
        DICTDB._Index._I-misc2[1] = s_ttb_idx.ds_msc21.

      if s_ttb_idx.ds_msc21 begins "r" then do:
       assign  tab_recidNew = s_ttb_idx.ds_name.
         /* OE00170417: name may be quoted for ORACLE */
         if user_dbtype = "ORACLE" and tab_recidNew begins '"' then do:
            if QUOTER(tab_recidOld) = tab_recidNew then
              tab_recidOld = QUOTER(tab_recidOld).
         end.
      end.



      if available w_index
       then do:  /* available w_index */
        
        /* give warning if name changed or uniqueness weirdness */
        if DICTDB._Index._Index-name <> w_index.pro_index-name
         then run error_handling
                ( INPUT 17,
                  INPUT DICTDB._Index._Index-name,
                  INPUT w_index.pro_index-name
                  ).
        if w_index.pro_unique       /* index used to be unique but is */
         and not s_ttb_idx.pro_uniq /* in foreign schema not anymore  */
         then do:
          run error_handling
                ( INPUT 18,
                  INPUT DICTDB._Index._Index-name,
                  INPUT string(w_index.pro_unique)
                  ).
          run error_handling(7, "", "").
          end.
        
        /* save index specifications */
        if w_index.pro_for-name = tab_recidOld
         then assign
           tab_RILevel  = s_ttb_idx.hlp_level
           tab_RIfstoff = s_ttb_idx.hlp_fstoff
           tab_RIidx#   = s_ttb_idx.pro_idx#
           tab_RImsc23  = s_ttb_idx.hlp_msc23.
        
        /* delete this w_index record */
        for each w_index-field
          where  w_index-field.pro_idx-num = w_index.pro_idx-num:
          DELETE w_index-field.
          end.
        DELETE w_index.  
        end.     /* available w_index */
 
/*-------------------------- INDEX-FIELDS --------------------------*/

      for each s_ttb_idf
        where s_ttb_idf.ttb_idx = RECID(s_ttb_idx):
      
        find first s_ttb_fld
          where RECID(s_ttb_fld) = s_ttb_idf.ttb_fld NO-ERROR.
        find first DICTDB._Field
          where RECID(DICTDB._Field) = s_ttb_fld.fld_recid NO-ERROR.
        IF NOT AVAILABLE DICTDB._Field AND s_ttb_fld.ds_name BEGINS "SYS_NC" THEN DO:

          FIND FIRST DICTDB._Field WHERE DICTDB._Field._File-recid = DICTDB._Index._File-recid
                                     AND DICTDB._Field._Field-name = s_ttb_fld.defaultname NO-ERROR.
        END.
        
        IF AVAILABLE DICTDB._Field THEN DO:
          CREATE DICTDB._Index-field.
          assign
            DICTDB._Index-Field._Ascending   = s_ttb_idf.pro_asc
            DICTDB._Index-Field._Abbreviate  = s_ttb_idf.pro_abbr
            DICTDB._Index-Field._Field-recid = RECID(DICTDB._Field)
            DICTDB._Index-Field._Index-recid = RECID(DICTDB._Index)
            DICTDB._Index-Field._Index-Seq   = s_ttb_idf.pro_order.
        END.
       end.   /* for each s_ttb_idf */

      end.   /* for each s_ttb_idx */
  

/*--------------------------- RECID-INDEX ----------------------------*/

    if  ( DICTDB._File._Fil-misc1[1] <= 0
     or   DICTDB._File._Fil-misc1[1]  = ? )
     and NOT can-do("PROCEDURE,BUFFER",DICTDB._File._For-Type)
     then do:  /* no progress_recid & RECID-Index needed
                *     -> check indexes for ROWID usability
                */   
    /* if there was a previously selected index, we reselect it. However
     * the foreign schema might have changed, so we give a warning, if
     * there is another index, which might fit better (i.e. has a lower
     * value in s_ttb_idx.level)
     */
    
      if tab_recidOld <> ""
       then do:  /* there was a previously selected index */

        if tab_recidOld <> tab_recidNew
         then do:  /* deselect new index, re-select old one */ 

          find first DICTDB._Index of DICTDB._File
            where DICTDB._Index._I-misc2[1] begins "r"
            no-error.
          if available DICTDB._Index
           then assign
            DICTDB._Index._I-misc2[1] = substring
                                        (DICTDB._Index._I-misc2[1]
                                        ,2
                                        ,-1
                                        ,"character"
                                        ).

          find first DICTDB._Index of DICTDB._File
            where DICTDB._Index._For-name = tab_recidOld
            no-error.
          if available DICTDB._Index
           then assign
            DICTDB._Index._I-misc2[1]  = "r" + DICTDB._Index._I-misc2[1]
            DICTDB._File._Fil-misc1[1] = tab_RIfstoff
            DICTDB._File._Fil-misc1[2] = tab_RIidx#
            DICTDB._File._Fil-misc2[3] = tab_RImsc23
            tab_recidNew               = tab_recidOld.

          end.     /* deselect new index, re-select old one */ 

        end.     /* there was a previously selected index */

      if  tab_recidNew <> ""
       then do:  /* found index to be selected */
        find first s_ttb_idx
          where s_ttb_idx.ttb_tbl   = RECID(s_ttb_tbl)
          and   s_ttb_idx.hlp_level < tab_RILevel
          and   s_ttb_idx.ds_name  <> tab_recidNew
          no-error.
        if available s_ttb_idx
         then do:  /* ev. message if prev. selected idx <> optimal */
          RUN error_handling(5, "", "").
          RUN error_handling(6, s_ttb_tbl.pro_name, "").
          end.     /* ev. message if prev. selected idx <> optimal */
        end.     /* found index to be selected */
      
       else do:  /* found no index to be selected */

        RUN error_handling
          ( INPUT 3,
            INPUT DICTDB._File._File-name,
            INPUT DICTDB._File._For-Owner
          ).
        end.    /* found no index to be selected */
          
      end.     /* no progress_recid  & RECID-Index needed
                *     -> check indexes for ROWID usability
                */
               

  /* message if no recid-index found */
    if has_id_ix /* PROGRESS-RECID-field -> reset recid-info of all indexes */
     then for each DICTDB._Index of DICTDB._File:
        assign DICTDB._Index._I-misc2[1] = ?.
        end.         /* PROGRESS-RECID-field -> reset recid-info of all indexes */
    
    /* now attempt to set primary index to same index it used to use */   
    if oldf and tab_PrimeIdx <> ? then do:
      find first DICTDB._Index OF DICTDB._File
        where DICTDB._Index._Index-name = tab_PrimeIdx no-error.
      if available DICTDB._Index then
        DICTDB._File._Prime-Index = RECID(DICTDB._Index).
    end.
    run Field-Triggers. /* reassign field-triggers */


  /* delete all left-over, old, "foreign" indexes */
    for each w_index
      where w_index.pro_for-name <> ""
      AND   w_index.pro_for-name <> ?:
      for each w_index-field
        where  w_index-field.pro_idx-num = w_index.pro_idx-num:
        DELETE w_index-field.
        end.
      DELETE w_index.  
      end.


/*----------------------- USER-DEFINED-INDEX -------------------------*/

  /* find last used index-number */
    find last DICTDB._Index
      where DICTDB._Index._Idx-num > 0
      no-error.
    assign indn = ( if available DICTDB._Index
                      then DICTDB._Index._idx-num + 1
                      else 1
                  ).
                
  /* try to recreate all old, "USER-defined" indexes */
    for each w_index:

      assign scrap = true.
      for each w_index-field
        where  w_index-field.pro_idx-num = w_index.pro_idx-num
        while scrap = true:
        find first DICTDB._field of DICTDB._File
          where DICTDB._field._for-name = w_index-field.pro_for-name
          and   DICTDB._field._for-type = w_index-field.pro_for-type
          no-lock no-error.
        if not available DICTDB._field then assign scrap = false.
        end.
      
      if NOT scrap  
       then for each w_index-field  /* index not valid anymore */
        where  w_index-field.pro_idx-num = w_index.pro_idx-num: 
        delete w_index-field.
        end.

       else do:  /* retain index */

        assign user_env[1] = w_index.pro_index-name.
      RUN "prodict/gate/_gat_xlt.p"
            (FALSE,RECID(DICTDB._File),INPUT-OUTPUT user_env[1]).

        if user_env[1] <> w_index.pro_index-name
         then do:

          if s_1st-error = false
           then do:
            assign s_1st-error = true.
            output stream s_stm_errors to ds_upd.e.
            output stream s_stm_errors close.
            end.

          output stream s_stm_errors to ds_upd.e append.
          put stream s_stm_errors unformatted
            "Index name changed from " 
            w_index.pro_index-name " to " user_env[1]   skip.
          output stream s_stm_errors close.

          end.                            
         
        create DICTDB._Index.
        assign
          DICTDB._Index._Index-Name = user_env[1]
          DICTDB._Index._File-recid = RECID(DICTDB._File)
          DICTDB._Index._Unique     = w_index.pro_unique
          DICTDB._Index._For-name   = ""
          DICTDB._Index._Idx-num    = indn
          DICTDB._Index._Active     = w_index.pro_active
          DICTDB._Index._WordIdx    = w_index.pro_WordIdx
          DICTDB._Index._Desc       = w_index.pro_Desc
          indn                      = indn + 1
          i                         = 1.

        if tab_PIForNum = w_index.pro_idx-num
          then assign DICTDB._File._Prime-Index = RECID(DICTDB._Index).
     
        for each w_index-field  
          where  w_index-field.pro_idx-num = w_index.pro_idx-num: 
        
          find first DICTDB._field of DICTDB._File
            where DICTDB._field._for-name = w_index-field.pro_for-name
            and   DICTDB._field._for-type = w_index-field.pro_for-type
            no-lock no-error.
          create DICTDB._Index-field.
          assign
            DICTDB._Index-Field._Index-recid = RECID(DICTDB._Index)
            DICTDB._Index-Field._Index-Seq   = i
            DICTDB._Index-Field._Field-recid = RECID(DICTDB._Field)
            DICTDB._Index-Field._Ascending   = w_index-field.pro_Ascending
            DICTDB._Index-Field._Abbreviate  = w_index-field.pro_Abbreviate
            DICTDB._Index-Field._Unsorted    = w_index-field.pro_Unsorted
            i                            = i + 1.
          delete w_index-field.

          end.     /* for each w_index-field */
       
        end.     /* retain index */
       
      delete w_index.  
    
     end.  /* for each w_index */
        
     if user_dbtype = "ORACLE" THEN DO:
      /* if we get any errors on function index and no fields are created delete index */
       FOR EACH DICTDB._Index WHERE DICTDB._Index._File-recid = RECID(DICTDB._File):
         IF CAN-FIND(FIRST DICTDB._Index-field OF DICTDB._Index) THEN NEXT.
         ELSE
           DELETE DICTDB._Index.
       END.
     END.
      /* Make sure primary is unique if possible. */

    IF NOT oldf THEN DO:
      IF DICTDB._File._Prime-Index <> ? THEN 
        FIND DICTDB._Index WHERE RECID(DICTDB._Index) = DICTDB._File._Prime-Index NO-ERROR.        
      IF AVAILABLE DICTDB._Index AND DICTDB._Index._Unique = FALSE THEN DO:      
        FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Unique = TRUE NO-ERROR.
        IF AVAILABLE DICTDB._Index THEN
          ASSIGN DICTDB._File._Prime-Index = RECID(DICTDB._Index).
      END.
    END.    
  end.  /* for each s_ttb_tbl of gate-work */
    
end. /* for each gate-work */

if NOT batch_mode
 then SESSION:IMMEDIATE-DISPLAY = no.

RUN adecomm/_setcurs.p ("").

find first DICTDB._File
  where DICTDB._File._Dump-name      =     ?
  and   NOT DICTDB._File._File-name BEGINS "_"
  no-error.
if available DICTDB._File then RUN "prodict/dump/_lodname.p".

if NOT batch_mode
 then HIDE FRAME ds_make NO-PAUSE.

if s_1st-error = true
 then do:   /* there are warnings or messages */
       
    if NOT batch_mode THEN DO:
    
        &IF "{&WINDOW-SYSTEM}" = "TTY" 
         &THEN 
          message err-msg[16]. 
         &ELSE
          message err-msg[16] view-as alert-box warning buttons ok.
         &ENDIF         
    END.
    ELSE IF logfile_open THEN
        PUT STREAM logfile UNFORMATTED " " SKIP err-msg[16] SKIP(2).

  end.      /* there are warnings or messages */

/* to make sure the next update starts a new ds_upd.e-file, reset flag 
assign s_1st-error = false.
*/

/*----------------------- CONSTRAINT -------------------------*/
/* OE00195067 BEGIN */
DEFINE BUFFER   CON_DICTDB         FOR DICTDB._Constraint.
DEFINE BUFFER   FIL_DICTDB         FOR DICTDB._File.
IF user_dbtype = "MSS" OR user_dbtype = "ORACLE" THEN DO:
num = 0.
FOR EACH DICTDB._Constraint WHERE DICTDB._Constraint._Db-Recid = drec_db:
    IF DICTDB._Constraint._Con-Num > num 
     THEN ASSIGN num = DICTDB._Constraint._Con-Num. 
END.
 FOR EACH DICTDB._FIle WHERE DICTDB._FIle._Db-Recid = drec_db:
   FOR EACH s_ttb_con WHERE tab_name = DICTDB._File._File-Name:
   IF user_dbtype = "MSS" AND
        (const_name MATCHES "*progress_recid*"  OR const_name MATCHES "*DF__*") THEN
       NEXT.
     
      num = num + 1.
      IF cons_type = "D" OR cons_type = "C"
      THEN DO:
        FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-Name = col_name NO-LOCK NO-ERROR.  
        CREATE DICTDB._constraint.
        ASSIGN        
        DICTDB._constraint._db-recid    = drec_db
        DICTDB._constraint._con-name    = const_name
        DICTDB._constraint._for-name    = const_name
        DICTDB._constraint._con-expr    = expre
        DICTDB._constraint._con-num     = num
        DICTDB._constraint._Field-Recid = RECID(DICTDB._Field)
        DICTDB._constraint._File-Recid  = RECID(DICTDB._FIle).
        
        IF cons_type = "D" THEN
          ASSIGN DICTDB._constraint._con-type = "D".
        ELSE IF cons_type = "C" THEN
          ASSIGN DICTDB._constraint._con-type = "C".
      END.
      ELSE IF cons_type = "PRIMARY KEY"
      THEN DO:
        IF oldf THEN DO:
             FIND FIRST DICTDB._Index OF DICTDB._File
                     WHERE DICTDB._Index._Index-Name = const_name NO-LOCK NO-ERROR.
             IF NOT AVAILABLE (DICTDB._Index) THEN DO:
                 const_name1  =  replace(const_name,"_","-") .
             END.
             ELSE DO:
               const_name1  = const_name.
             END.
         END.
         ELSE DO:
           const_name1  = const_name.
         END.
      
        IF NOT CAN-FIND (FIRST DICTDB._constraint OF DICTDB._File WHERE DICTDB._constraint._Con-Type = "P")
        THEN DO:
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = index_name NO-LOCK NO-ERROR.
          IF NOT AVAILABLE (DICTDB._Index) THEN
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = "z" + const_name1 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE (DICTDB._Index) THEN 
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = const_name1 NO-LOCK NO-ERROR.
          
          CREATE DICTDB._constraint.
          ASSIGN        
          DICTDB._constraint._db-recid    = drec_db       
          DICTDB._constraint._con-name    = const_name1
          DICTDB._constraint._for-name    = const_name1
          DICTDB._constraint._Index-Recid = RECID(DICTDB._Index)
          DICTDB._constraint._File-Recid  = RECID(DICTDB._FIle)
          DICTDB._constraint._con-num     = num
          DICTDB._constraint._con-type    = "P".
        END.
      END.
      ELSE IF cons_type = "CLUSTERED"
      THEN DO:
        IF oldf THEN DO:
             FIND FIRST DICTDB._Index OF DICTDB._File
                     WHERE DICTDB._Index._Index-Name = const_name NO-LOCK NO-ERROR.
             IF NOT AVAILABLE (DICTDB._Index) THEN DO:
                 const_name1  =  replace(const_name,"_","-") .
             END.
             ELSE DO:
               const_name1  = const_name.
             END.
         END.
         ELSE DO:
           const_name1  = const_name.
         END.
      
        IF NOT CAN-FIND (FIRST DICTDB._constraint OF DICTDB._File WHERE DICTDB._constraint._Con-Type = "M")
        THEN DO:
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = "z" + const_name1 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE (DICTDB._Index) then FIND FIRST DICTDB._Index OF DICTDB._File
                                                         WHERE DICTDB._Index._Index-Name = const_name1 NO-LOCK NO-ERROR.
          CREATE DICTDB._constraint.
          ASSIGN        
          DICTDB._constraint._db-recid    = drec_db       
          DICTDB._constraint._con-name    = const_name1
          DICTDB._constraint._for-name    = const_name1
          DICTDB._constraint._Index-Recid = RECID(DICTDB._Index)
          DICTDB._constraint._File-Recid  = RECID(DICTDB._FIle)
          DICTDB._constraint._con-num     = num
          DICTDB._constraint._con-type    = "M".
        END.
      END.
      ELSE IF cons_type = "UNIQUE"
      THEN DO:
        IF NOT CAN-FIND (FIRST DICTDB._constraint OF DICTDB._File WHERE (DICTDB._constraint._Con-Type = "U" 
                                             AND DICTDB._constraint._Con-Name =const_name))
        THEN DO:
          FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = index_name NO-LOCK NO-ERROR.
          IF NOT AVAILABLE (DICTDB._Index) THEN
             FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = "z" + const_name NO-LOCK NO-ERROR.
          IF NOT AVAILABLE (DICTDB._Index) THEN
             FIND FIRST DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._Index-Name = const_name NO-LOCK NO-ERROR.
          CREATE DICTDB._constraint.
          ASSIGN       
          DICTDB._constraint._db-recid   = drec_db        
          DICTDB._constraint._con-name   = const_name
          DICTDB._constraint._for-name   = const_name
          DICTDB._constraint._Index-Recid = RECID(DICTDB._Index)
          DICTDB._constraint._File-Recid  = RECID(DICTDB._FIle)
          DICTDB._constraint._con-num    = num
          DICTDB._constraint._con-type = "U".
        END.
      END.
   END.        
    
    FOR EACH DICTDB._constraint OF DICTDB._File WHERE DICTDB._constraint._con-type = "P":
      FIND FIRST CON_DICTDB OF DICTDB._File WHERE CON_DICTDB._con-type = "M" 
                                              AND CON_DICTDB._Con-Name = DICTDB._constraint._Con-Name EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE (CON_DICTDB)
        THEN DO:
           ASSIGN DICTDB._constraint._con-type = "PC".
           DELETE CON_DICTDB.
        END.   
    END.
  END.   /* FOR EACH DICTDB._FIle */

  FOR EACH DICTDB._FIle WHERE DICTDB._FIle._Db-Recid = drec_db:
     FOR EACH s_ttb_con WHERE tab_name = DICTDB._File._File-Name AND cons_type = "FOREIGN KEY":
      IF NOT CAN-FIND (FIRST DICTDB._constraint OF DICTDB._File WHERE (DICTDB._constraint._Con-Type = "F" 
                                            AND DICTDB._constraint._Con-Name =const_name))
        THEN DO:                                    
          num = num + 1.
          FIND FIRST CON_DICTDB WHERE CON_DICTDB._con-name= par_key AND CON_DICTDB._Db-Recid = drec_db NO-LOCK NO-ERROR.
          IF AVAILABLE(CON_DICTDB)
          THEN DO:            
             CREATE DICTDB._constraint.
             ASSIGN       
             DICTDB._constraint._db-recid   = drec_db 
             DICTDB._constraint._con-type   = "F"
             DICTDB._constraint._con-name   = const_name
             DICTDB._constraint._for-name   = const_name
             DICTDB._constraint._File-Recid = RECID(DICTDB._FIle)
             DICTDB._constraint._con-num    = num
             DICTDB._constraint._Index-Parent-Recid = CON_DICTDB._Index-Recid.
         END.
         ELSE DO:
           FIND FIRST FIL_DICTDB WHERE FIL_DICTDB._File-Name = par_tab AND FIL_DICTDB._Db-Recid = drec_db NO-LOCK NO-ERROR.
            IF AVAILABLE(FIL_DICTDB) THEN DO:
              FIND FIRST DICTDB._Index OF FIL_DICTDB WHERE DICTDB._Index._Index-Name = par_key NO-LOCK NO-ERROR.
              IF AVAILABLE(DICTDB._Index) 
              THEN DO:
               CREATE DICTDB._constraint.              
                 ASSIGN       
                 DICTDB._constraint._db-recid   = drec_db 
                 DICTDB._constraint._con-type   = "F"
                 DICTDB._constraint._con-name   = const_name
                 DICTDB._constraint._for-name   = const_name
                 DICTDB._constraint._File-Recid = RECID(DICTDB._FIle)
                 DICTDB._constraint._con-num    = num
                 DICTDB._constraint._Index-Parent-Recid = RECID(DICTDB._Index).
              END. 
            END.              
         END.
       END.  
    END.  /* FOR EACH s_ttb_con  */   
   FOR EACH DICTDB._constraint OF DICTDB._File WHERE DICTDB._constraint._con-type = "F":
      FOR EACH s_ttb_con WHERE tab_name = DICTDB._File._File-Name:
         
         IF const_name = DICTDB._constraint._con-name AND DICTDB._constraint._Index-Recid = 0
         THEN DO:  
         FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Field-Name = col_name NO-LOCK NO-ERROR.
         IF NOT AVAILABLE (DICTDB._Field) THEN  
                          FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._For-Name = col_name.
         CREATE DICTDB._constraint-Keys.
         ASSIGN                   
               DICTDB._constraint-Keys._Con-Recid   = RECID(DICTDB._constraint)
               DICTDB._constraint-Keys._Field-Recid = RECID(DICTDB._Field).
         END.
       END.
    END.
  END.  
END.    /* IF user_dbtype ="MSS" */
RETURN.

/*------------------------------------------------------------------*/        



