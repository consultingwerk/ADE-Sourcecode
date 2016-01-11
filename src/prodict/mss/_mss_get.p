/*********************************************************************
* Copyright (C) 2006,2008,2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* mss_get - finder for MSS tables */

/*

OUTPUT:
    gate-work records for found objects

INPUT:
    user_env[25]    "{AUTO},<name>,<owner>,<type>,<qualifier>"
                        for autmatically select all or bringing up the 
                            selection-dialog-box, Initial-values for
                            pre-selection-criterias    
                            
History: Copied _odb_get.p for MS Sql Server 7 DataServer
         04/24/00 Added logic not to support older versions D. McMann
         02/28/06 Always skip table valued functions and skip system objects
                  when running proto utility - 20060120-003 - fernando
         05/20/08 Adding code for revised sequence genrator in MSS DataServers                                          
         05/27/08 Fixing code that looks for existing stored-proc - OE00130417
         04/06/09 Changed for batch mode migration
         10/20/09 support for computed columns in MSSDS for PROGRESS_RECID - OE00186593
*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/gate/odb_ctl.i }
&UNDEFINE DATASERVER

DEFINE VARIABLE bug1             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE escp             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c	         AS CHARACTER NO-UNDO.
DEFINE VARIABLE edbtyp           AS CHARACTER NO-UNDO. /* db-type external format */
DEFINE VARIABLE hint	         AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i	         AS INTEGER   NO-UNDO.
DEFINE VARIABLE j	         AS INTEGER   NO-UNDO.
DEFINE VARIABLE l	         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lim	         AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE msstyp           AS CHARACTER NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE redraw	         AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE rpos1	         AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos2	         AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos3	         AS CHARACTER NO-UNDO.
DEFINE VARIABLE xld	         AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE canned	         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE inc_qual         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE driver-prefix	 AS CHARACTER NO-UNDO.
DEFINE VARIABLE sqltables-type	 AS CHARACTER NO-UNDO.
DEFINE VARIABLE sqltables-name	 AS CHARACTER NO-UNDO case-sensitive.
DEFINE VARIABLE SQLProcedures-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE object-type	 AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_client-qual    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_name_f	 AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE l_owner_f	 AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE l_qual_f	 AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VARIABLE l_rep-presel     AS logical   NO-UNDO.
DEFINE VARIABLE escape_char      AS CHARACTER NO-UNDO.
DEFINE VARIABLE quote_char       AS CHARACTER NO-UNDO.
DEFINE VARIABLE fromProto        AS LOGICAL   NO-UNDO INIT NO.
DEFINE VARIABLE sqltables-seqpre AS CHARACTER NO-UNDO. /* sequence prefix- new sequence generator */

DEFINE BUFFER gate-buff FOR gate-work.
DEFINE stream s_stm_errors.

DEFINE VARIABLE SeqHdl AS HANDLE.
DEFINE VARIABLE sqlstr AS CHAR.
DEFINE VARIABLE owner AS CHAR.
SeqHdl=TEMP-TABLE s_ttb_ntvseq:HANDLE.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE err-msg AS CHARACTER NO-UNDO EXTENT 4 INITIAL [
  /* 1*/ "You have not selected an &1 database.",
  /* 2*/ "  Please wait while information is gathered from the &1 schema ",
  /* 3*/ "" /* unused */ , 
  /* 4*/ "" /* unused */
    /*      ....+....1....+....2....+....3....+....4....+....5....+....6 */
].

FORM SKIP(1)
  err-msg[2]       AT  3 NO-LABEL           FORMAT "x(70)"     SKIP(1)
  hint              AT 10 LABEL "(Searching" FORMAT "x(32)" ")" SKIP(1)
 WITH FRAME gate_wait 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  ROW 6 CENTERED SIDE-LABELS NO-ATTR-SPACE.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*------------------------------------------------------------------*/
/*------------------------------------------------------------------*/
/*------------------------------------------------------------------*/
PROCEDURE fix_the_wild_cards:
/* Put an escape sequenve in front of meta-characters. */
DEFINE INPUT PARAMETER src AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER trgt AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER mss-escape AS CHARACTER NO-UNDO.

DEFINE VARIABLE strt AS INT INIT 1 NO-UNDO.
DEFINE VARIABLE ind AS INT NO-UNDO.
DEFINE VARIABLE escape-seq AS CHARACTER NO-UNDO.


DEFINE VAR orig1  AS CHARACTER init "~~*" NO-UNDO.
DEFINE VAR orig2  AS CHARACTER init "~~." NO-UNDO.
DEFINE VAR orig3  AS CHARACTER init "*" NO-UNDO.
DEFINE VAR orig4  AS CHARACTER init "." NO-UNDO.
DEFINE VAR trgt1  AS CHARACTER init "*" NO-UNDO.
DEFINE VAR trgt2  AS CHARACTER init "." NO-UNDO.
DEFINE VAR trgt3  AS CHARACTER init "%" NO-UNDO.
DEFINE VAR trgt4  AS CHARACTER init "_" NO-UNDO.
IF src = ? 
THEN DO:
  trgt = src.
  RETURN.
END.

IF mss-escape = ? or mss-escape = " " THEN mss-escape = "".

escape-seq = mss-escape + "_".
strt = 1.
ind = 0.
REPEAT:
  IF escape-seq = "_" THEN LEAVE.
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), "_").

  IF ind = 0
    THEN LEAVE.

  SUBSTRING(src, ind + strt - 1, 1,"character") = escape-seq.
  strt = strt + ind  + 1.
END.


escape-seq = mss-escape + "%".
strt = 1.
ind = 0.
REPEAT:
  IF escape-seq = "%" THEN LEAVE.
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), "%").
 
  IF ind = 0
    THEN LEAVE.
 
  SUBSTRING(src, ind + strt - 1, 1,"character") = escape-seq.
  strt = strt + ind  + 1.
END.
 
strt = 1.
ind = 0.
REPEAT:
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), orig3).
 
  IF ind = 0
    THEN LEAVE.
 
  IF strt + ind > 2 AND SUBSTRING(src, strt + ind - 2, 1,"character") = "~~" THEN DO:
    strt = strt + ind.
    NEXT.
  END.
    
  SUBSTRING(src, ind + strt - 1, 1 ,"character") = trgt3.
  strt = strt + ind.
END.
 
strt = 1.
ind = 0.
REPEAT:
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), orig4).
 
  IF ind = 0
    THEN LEAVE.
     
  IF strt + ind > 2 AND SUBSTRING(src, strt + ind - 2, 1,"character") = "~~"
   THEN DO:
    strt = strt + ind.
    NEXT.
  END.
      
  SUBSTRING(src, ind + strt - 1, 1,"character") = trgt4  .
  strt = strt + ind.
END.
 
strt = 1.
ind = 0.
REPEAT:
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), orig1).
 
  IF ind = 0
    THEN LEAVE.
 
  SUBSTRING(src, ind + strt - 1, 2,"character") = trgt1.
  strt = strt + ind.
END.

strt = 1. 
ind = 0.
REPEAT: 
  ind = INDEX (SUBSTRING(src,strt,-1,"character"), orig2). 
  
  IF ind = 0 
    THEN LEAVE. 
  
  SUBSTRING(src, ind + strt - 1, 2,"character") = trgt2. 
  strt = strt + ind. 
END. 


trgt = src.
 
RETURN.
END PROCEDURE.


/*------------------------------------------------------------------*/
/*--------------------------- MAIN-BLOCK ---------------------------*/
/*------------------------------------------------------------------*/

ASSIGN
  SESSION:IMMEDIATE-DISPLAY = yes
  edbtyp      = {adecomm/ds_type.i
                  &direction = "itoe"
                  &from-type = "user_dbtype"
                  }
  msstyp      = {adecomm/ds_type.i
                  &direction = "MSS"
                  &from-type = "user_dbtype"
                  }
  err-msg[1] = SUBSTITUTE(err-msg[1],edbtyp)
  err-msg[2] = SUBSTITUTE(err-msg[2],edbtyp)
  s_wildcard  = FALSE.
  .

  
IF INDEX(msstyp,user_dbtype) = 0
 THEN DO:
  MESSAGE err-msg[1] /* not odbc */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
  END.

/* check if we are automatically selecting all */
IF user_env[25] BEGINS "AUTO" THEN
   fromProto = YES.

/* delete eventually left-over records from earlier schema-pulls */
for each gate-work: delete gate-work. end.
for each s_ttb_seq: delete s_ttb_seq. end.
for each s_ttb_tbl: delete s_ttb_tbl. end.
for each s_ttb_fld: delete s_ttb_fld. end.
for each s_ttb_idx: delete s_ttb_idx. end.
for each s_ttb_idf: delete s_ttb_idf. end.
for each s_ttb_con: delete s_ttb_con. end.
for each s_ttb_ntvseq: delete s_ttb_ntvseq. end.

/*------------------------------------------------------------------*/
/*                        get driver-bug-info                       */
/*------------------------------------------------------------------*/

assign
  l_rep-presel = TRUE.

presel:  
repeat while l_rep-presel:   /* end for this repeat is in nogatwrk.i */

{prodict/gate/presel.i
  &block  = "presel"
  &frame  = "frm_ntoq"
  &link   = """ """
  &master = """ """
  }


/* if either no qualifier-support from the server (BUG24), or no    */
/* wildcard-support from the server (BUG23) but wildcards contained */
/* in the variables we have to do the selection on the client-side  */
FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.

IF NOT SESSION:BATCH-MODE THEN DO:
    PAUSE 0.
    DISPLAY err-msg[2] WITH FRAME gate_wait.
END. 

SESSION:IMMEDIATE-DISPLAY = yes.
RUN adecomm/_setcurs.p ("WAIT").

DO TRANSACTION on error undo, leave on stop undo, leave:

  RUN STORED-PROC DICTDBG.CloseAllProcs.
  FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.

  RUN STORED-PROC DICTDBG.GetInfo (0).

  FOR EACH DICTDBG.GetInfo_buffer:


    IF DICTDB._Db._Db-misc2[1] = ?
     THEN DO:       
        IF (LENGTH(DICTDBG.GetInfo_buffer.escape_char,"character") < 1)
            THEN  escape_char = " ".
            ELSE  escape_char = DICTDBG.GetInfo_buffer.escape_char .
        IF (LENGTH(DICTDBG.GetInfo_buffer.quote_char,"character") < 1)
            THEN  quote_char = " ".
            ELSE  quote_char = DICTDBG.GetInfo_buffer.quote_char.
    
       IF INTEGER(SUBSTRING(DICTDBG.GetInfo_buffer.dbms_version,1,2)) < 7 THEN DO:         
         MESSAGE "The DataServer for MS SQL Server was designed to work with Versions 7 " SKIP
            "and above.  You have tried to connect to a prior version of MS SQL Server. " SKIP
            "The DataServer for ODBC supports that version and must be used to perform " SKIP
            "this function. " SKIP(1)
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           ASSIGN user_path = "*N,35=wrg-ver,_usrsdel,1=sys,_usrsget".
         &ELSE
           ASSIGN user_path = "*N,35=wrg-ver,_usrsdel,1=sys,_guisget".
         &ENDIF           
         RETURN. 
       END.
       
      ASSIGN
        DICTDB._Db._Db-misc2[1] = DICTDBG.GetInfo_buffer.driver_name
        DICTDB._Db._Db-misc2[2] = DICTDBG.GetInfo_buffer.driver_version
        DICTDB._Db._Db-misc2[3] = escape_char + quote_char
        DICTDB._Db._Db-misc2[5] = DICTDBG.GetInfo_buffer.dbms_name + " " 
  			        + DICTDBG.GetInfo_buffer.dbms_version 
        DICTDB._Db._Db-misc2[6] = DICTDBG.GetInfo_buffer.odbc_version
        DICTDB._Db._Db-misc2[7] = "Dictionary Ver #:" +  odbc-dict-ver
  		                          + ",Client Ver #:"
  		                          + DICTDBG.GetInfo_buffer.prgrs_clnt
  		                          + ",Server Ver #:"
  		                          + DICTDBG.GetInfo_buffer.prgrs_srvr
  		                          + ","
        DICTDB._Db._Db-misc2[8] = DICTDBG.GetInfo_buffer.dbms_name
        driver-prefix    = ( IF DICTDB._Db._Db-misc2[1] BEGINS "QE"
                              THEN SUBSTRING(DICTDB._Db._Db-misc2[1]
                                      ,1
                                      ,LENGTH(DICTDB._Db._Db-misc2[1]
                                              ,"character") - 6
                                      ,"character")
  		              ELSE DICTDB._Db._Db-misc2[1]
  		           )
        DICTDB._Db._Db-misc2[4] = "".
        
      REPEAT i = 1 TO 80:
        IF   ( CAN-DO(odbc-bug-list[i], driver-prefix)
         OR    CAN-DO(odbc-bug-list[i], "ALL") )
         AND NOT CAN-DO(odbc-bug-excld[i], driver-prefix)
         THEN ASSIGN
           DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
        END. /* REPEAT */

      END. /* DICTDB._Db._Db-misc2[1] = ? DO */
    
    ELSE IF DICTDB._Db._Db-misc2[1] <> DICTDBG.GetInfo_buffer.driver_name
     THEN DO:
      RUN adecomm/_setcurs.p ("").
      MESSAGE
	    "The Schema Holder was not created with the ODBC driver you have"
	    "connected with." SKIP
	    "You may experience problems with this connection."
	    SKIP(1)
	    "Schema Holder: "  DICTDB._Db._Db-misc2[1] SKIP
	    "Current driver: " DICTDBG.GetInfo_buffer.driver_name
	    SKIP(1)
	    "Please consider recreating your schema holder using the current"
	    "ODBC driver."
	    VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      RUN adecomm/_setcurs.p ("WAIT").
      END.

    
    END.  /* FOR EACH DICTDBG.GetInfo_buffer */
    
  CLOSE STORED-PROC DICTDBG.GetInfo.

/*------------------------------------------------------------------*/
/*                        pull in schema-info                       */
/*------------------------------------------------------------------*/

  ASSIGN
    l_client-qual = ( CAN-DO(DICTDB._Db._Db-misc2[4], "24") /* no qualifier-sprt */
                OR  ( CAN-DO(DICTDB._Db._Db-misc2[4], "23") /* no wildcard-sprt */
                AND   ( INDEX(s_name + s_owner + s_qual + s_type,"*") <> 0
                OR      INDEX(s_name + s_owner + s_qual + s_type,"?") <> 0
                      )                   /* but wildcards in the vars */
                    )
                  )
    bug1     = LOOKUP("1",DICTDB._Db._Db-misc2[4]) <> 0. 

  /* Refresh the bug info we just calculated.				*/
  RUN STORED-PROC DICTDBG.SendInfo (DICTDB._Db._Db-misc2[4]).
  CLOSE STORED-PROC DICTDBG.SendInfo.

  escp  = SUBSTRING(DICTDB._Db._Db-misc2[3],1,1,"character").
  escp  = IF (escp = " ") THEN "" ELSE escp.
  RUN fix_the_wild_cards(INPUT s_qual, OUTPUT l_qual_f, INPUT escp).
  RUN fix_the_wild_cards(INPUT s_owner, OUTPUT l_owner_f, INPUT escp).
  RUN fix_the_wild_cards(INPUT s_name, OUTPUT l_name_f, INPUT escp).
 IF l_client-qual
   THEN RUN STORED-PROC DICTDBG.SQLTables (?, ?, ?, ?).
   ELSE  RUN STORED-PROC DICTDBG.SQLTables (l_qual_f, l_owner_f, l_name_f, ?).

  FOR EACH DICTDBG.SQLTables_buffer:

   IF NOT CAN-DO(odballowed,TRIM(DICTDBG.SQLTables_buffer.type)) THEN NEXT.

   /* A table for sequence implementation.				*/
   IF TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "_SEQP_" THEN NEXT.

   /* if from migration utility, don't need to pull system objects */
   IF fromProto AND UPPER(TRIM(DICTDBG.SQLTables_buffer.owner)) = "SYS" THEN
      NEXT.

   /* if from migration utility, don't need to pull INFORMATION_SCHEMA objects */
   IF fromProto AND UPPER(TRIM(DICTDBG.SQLTables_buffer.owner)) = "INFORMATION_SCHEMA" THEN
      NEXT.

   /* if object is _SEQT_REV_SEQTMGR (management table for new MSS sequences)
      we dont pull it into the schema, so ignoring it- OE157473 */
   IF DICTDBG.SQLTables_buffer.name BEGINS "_SEQT_REV_SEQTMGR" THEN NEXT.

   /* selection to be done on the client-side */
   /* This IF catches all matches except where one or both  
    * operands have the unknown value. These are caught in the
    * ELSE block.
    */
   IF   l_client-qual
    AND ( NOT TRIM(DICTDBG.SQLTables_buffer.name)      MATCHES s_name
    OR    NOT TRIM(DICTDBG.SQLTables_buffer.owner)     MATCHES s_owner
    OR    NOT TRIM(DICTDBG.SQLTables_buffer.qualifier) MATCHES s_qual
    OR    NOT TRIM(DICTDBG.SQLTables_buffer.type)      MATCHES s_type
        )
    AND NOT ( TRIM(DICTDBG.SQLTables_buffer.name)      BEGINS "_buffer_"
    AND       s_type                                   MATCHES "buffer"
            )
    AND NOT TRIM(DICTDBG.SQLTables_buffer.name)        MATCHES "_buffer_"
                                                             + s_name
    THEN NEXT.
    ELSE DO: 
        /* Check if there is a match with unknown value for
         * in SQLTables_buffer.  This can happen in PODBC. 
         */
        IF s_owner-hlp BEGINS "%%%" AND SUBSTRING(s_owner-hlp,4) <> "sa" AND
         TRIM(DICTDBG.SQLTables_Buffer.owner) <> substring(s_owner-hlp,4) THEN NEXT.


        IF TRIM(DICTDBG.SQLTables_buffer.name)  = ? THEN 
            IF  NOT ( (s_name = ?) OR (s_name = "*") )  THEN NEXT.
            
        IF TRIM(DICTDBG.SQLTables_buffer.owner) = ? THEN
            IF NOT ( (s_owner = ?) OR (s_owner = "*") ) THEN NEXT.
            
        IF TRIM(DICTDBG.SQLTables_buffer.qual)  = ? THEN 
            IF NOT ( (s_qual = ?) OR (s_qual = "*") )   THEN NEXT.
            
        IF TRIM(DICTDBG.SQLTables_buffer.type)  = ?  THEN 
            IF NOT ( (s_type = ?) OR (s_type = "*") )   THEN NEXT.
            
    END. /* ELSE DO */                                            
    
    ASSIGN
      sqltables-type = TRIM(DICTDBG.SQLTables_buffer.type)
      sqltables-name = TRIM(DICTDBG.SQLTables_buffer.name)
      object-type    = ( IF (    sqltables-type    =    "VIEW" 
                          AND LC(sqltables-name) BEGINS "_buffer_"
                            )
                          THEN substring(sqltables-name,2,6,"character")
                         ELSE IF NOT ( sqltables-type = "TABLE" 
                          AND sqltables-name BEGINS "_SEQT_" )
                          THEN ENTRY(LOOKUP(sqltables-type ,sobjects),pobjects)
                         ELSE IF asc(substring(sqltables-name,2,1,"character")) = 115
                          THEN "sequence"
                          ELSE "SEQUENCE"
                       ).

    /* new sequence generator implementation for MSS DataServers */ 
	    IF (sqltables-type = "TABLE") THEN DO:
		IF (sqltables-name BEGINS "_SEQT_REV_")
		   THEN sqltables-seqpre = "_SEQT_REV_".
	        ELSE IF (sqltables-name BEGINS "_SEQT_") 
		   THEN sqltables-seqpre = "_SEQT_". 
	    END.

    FIND DICTDB._File
      WHERE DICTDB._File._Db-recid     = drec_db
      AND   UPPER(DICTDB._File._For-name)  = UPPER(sqltables-name)
      AND   UPPER(DICTDB._File._For-owner) = UPPER(TRIM(DICTDBG.SQLTables_buffer.owner))
      AND ( bug1
      OR    DICTDB._File._FIl-misc2[1] = TRIM(DICTDBG.SQLTables_buffer.qualifier)
          )
      NO-ERROR.

    /* to prevent schemaholder-tables from beeing updated        */
    /*                                          <hutegger> 94/06 */
    IF available DICTDB._File
     AND DICTDB._File._file-name begins "SQLTables" THEN NEXT.
    
    /* skip objects that are not yet contained in the schema-holder */
    if not available DICTDB._File
     and s_vrfy = TRUE then NEXT.

    IF NOT SESSION:BATCH-MODE THEN 
        DISPLAY 
          TRIM(DICTDBG.SQLTables_buffer.name) @ hint 
          WITH FRAME gate_wait.

    CREATE gate-work.
    ASSIGN
      lim = lim + 1
      gate-work.gate-type = TRIM(STRING((AVAILABLE DICTDB._File 
                                    AND DICTDB._File._Frozen),"FROZEN:/"
                                  ))
                            + object-type

      gate-work.gate-name = ( IF object-type = "BUFFER"
                               THEN SUBSTRING(sqltables-name,9,-1,"character")
                              ELSE IF (object-type = "SEQUENCE" AND sqltables-seqpre = "_SEQT_") 
			        THEN SUBSTRING(sqltables-name,7,-1,"character")
			      ELSE IF (object-type = "SEQUENCE" AND sqltables-seqpre = "_SEQT_REV_")
                                THEN SUBSTRING(sqltables-name,11,-1,"character")
			      ELSE sqltables-name
                            )

      gate-work.gate-qual = ( IF DICTDBG.SQLTables_buffer.qualifier = ?
  			       THEN "" 
  			       ELSE TRIM(DICTDBG.SQLTables_buffer.qualifier)
                            )
      gate-work.gate-user = TRIM(DICTDBG.SQLTables_buffer.owner)
      gate-work.gate-prog = ( IF AVAILABLE DICTDB._File
                               THEN DICTDB._File._File-name 
                               ELSE ?
                            ).

     /* assigning gate-work.gate-seqpre value to either "_SEQT_REV_" or "_SEQT_" )- OE157473 */
	IF (object-type = "SEQUENCE") THEN DO:
	  IF (sqltables-seqpre = "_SEQT_REV_")
		THEN gate-work.gate-seqpre  = "_SEQT_REV_".
	  IF (sqltables-seqpre = "_SEQT_")
		THEN gate-work.gate-seqpre  = "_SEQT_". 
	END.

    END.   /* FOR EACH DICTDBG.SQLTables_buffer */

  CLOSE STORED-PROC DICTDBG.SQLTables.
    IF l_client-qual
   THEN RUN STORED-PROC DICTDBG.SQLProcedures (?, ?, ?).
   ELSE RUN STORED-PROC DICTDBG.SQLProcedures (l_qual_f, l_owner_f, l_name_f).

  FOR EACH DICTDBG.SQLProcs_Buffer:

   /* This IF catches all matches except where one or both  
    * operands have the unknown value. These are caught in the
    * ELSE block.
    */
   IF   l_client-qual
    AND ( NOT TRIM(DICTDBG.SQLProcs_Buffer.name)      MATCHES s_name
    OR    NOT TRIM(DICTDBG.SQLProcs_Buffer.owner)     MATCHES s_owner
    OR    NOT TRIM(DICTDBG.SQLProcs_Buffer.qualifier) MATCHES s_qual
        )
    AND NOT ( TRIM(DICTDBG.SQLProcs_Buffer.name)      BEGINS "_buffer_" )
    AND NOT TRIM(DICTDBG.SQLProcs_Buffer.name)        MATCHES "_buffer_"
                                                             + s_name
    THEN NEXT.
    ELSE DO: 
        /* Check if there is a match with unknown value for
         * in SQLProcs_Buffer.  This can happen in PODBC. 
         */
        IF s_owner-hlp BEGINS "%%%" AND SUBSTRING(s_owner-hlp,4) <> "sa" AND
         TRIM(DICTDBG.SQLProcs_Buffer.owner) <> substring(s_owner-hlp,4) THEN NEXT.

        IF TRIM(DICTDBG.SQLProcs_Buffer.name)  = ? THEN 
            IF  NOT ( (s_name = ?) OR (s_name = "*") )  THEN NEXT.
            
        IF TRIM(DICTDBG.SQLProcs_Buffer.owner) = ? THEN
            IF NOT ( (s_owner = ?) OR (s_owner = "*") ) THEN NEXT.
            
        IF TRIM(DICTDBG.SQLProcs_Buffer.qual)  = ? THEN 
            IF NOT ( (s_qual = ?) OR (s_qual = "*") )   THEN NEXT.
 
            
    END. /* ELSE DO */    

    IF DICTDBG.SQLProcs_Buffer.name BEGINS "_SEQP_" THEN
        NEXT.
    
    IF DICTDBG.SQLProcs_Buffer.name BEGINS "_Constraint_Info" THEN
        NEXT.
    /* if from migration utility, don't need to pull system objects */
    IF fromProto AND UPPER(TRIM(DICTDBG.SQLProcs_Buffer.owner)) = "SYS" THEN
        NEXT.

    /* if from migration utility, don't need to pull INFORMATION_SCHEMA objects */
    IF fromProto AND UPPER(TRIM(DICTDBG.SQLProcs_Buffer.owner)) = "INFORMATION_SCHEMA" THEN
        NEXT.

    /* skip table valued functions */
    IF substring(DICTDBG.SQLProcs_Buffer.name,(length(DICTDBG.SQLProcs_Buffer.name) - 1)) = ";0" THEN
       NEXT.

    ASSIGN
      SQLProcedures-name = TRIM(DICTDBG.SQLProcs_Buffer.name)
      object-type    = "PROCEDURE".

    /* OE00130417 - remove this now so we can lool for the correct name in the schema,
       when checking if it already exists
    */
    IF substring(SQLProcedures-name,(length(SQLProcedures-name) - 1)) = ";1" THEN
       ASSIGN SQLProcedures-name = substring(SQLProcedures-name,1,(length(SQLProcedures-name) - 2)).

    FIND DICTDB._File
      WHERE DICTDB._File._Db-recid     = drec_db
      AND   DICTDB._File._For-name     = SQLProcedures-name
      AND   DICTDB._File._For-owner    = TRIM(DICTDBG.SQLProcs_Buffer.owner)
      AND ( bug1
      OR    DICTDB._File._FIl-misc2[1] = TRIM(DICTDBG.SQLProcs_Buffer.qualifier)
          )
      NO-ERROR.

    /* to prevent schemaholder-tables from beeing updated        */
    /*                                          <hutegger> 94/06 */
    IF available DICTDB._File
     AND DICTDB._File._file-name begins "SQLProcedures" THEN NEXT.
    
    /* skip objects that are not yet contained in the schema-holder */
    if not available DICTDB._File
     and s_vrfy = TRUE then NEXT.

    IF NOT SESSION:BATCH-MODE THEN 
        DISPLAY 
          TRIM(DICTDBG.SQLProcs_Buffer.name) @ hint 
          WITH FRAME gate_wait.


    CREATE gate-work.
     ASSIGN
      lim = lim + 1
      gate-work.gate-type = TRIM(STRING((AVAILABLE DICTDB._File 
                                    AND DICTDB._File._Frozen),"FROZEN:/"
                                  ))
                            + object-type

      gate-work.gate-name =  SQLProcedures-name
      gate-work.gate-qual = ( IF DICTDBG.SQLProcs_Buffer.qualifier = ?
  			       THEN "" 
  			       ELSE TRIM(DICTDBG.SQLProcs_Buffer.qualifier)
                            )
      gate-work.gate-user = TRIM(DICTDBG.SQLProcs_Buffer.owner)
      gate-work.gate-prog = ( IF AVAILABLE DICTDB._File
                               THEN DICTDB._File._File-name 
                               ELSE ?
                            ).
    END.   /* FOR EACH DICTDBG.SQLProcs_Buffer */

  CLOSE STORED-PROC DICTDBG.SQLProcedures.

  END. /* DO TRANSACTION */

/*-------------------------- NATIVE SEQUENCES -----------------------------*/

  IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 11 THEN
     hasNativeSeqSupport = YES.
  
 IF ( nativeseq = TRUE OR user_env[37] = "IP" ) AND hasNativeSeqSupport = TRUE THEN DO:
   FIND DICTDB._Db where _Db-name  = LDBNAME("DICTDBG") AND _Db-type = 'MSS' NO-ERROR.
       IF AVAILABLE DICTDB._Db THEN DO:
            IF user_env[25] BEGINS "AUTO" THEN 
                  ASSIGN owner = "%" . 
            ELSE 
                  ASSIGN owner = l_owner_f /* s_owner */.

             ASSIGN sqlstr = "SELECT CAST(DB_NAME() AS VARCHAR (20)),
                                     CAST (T0.SEQUENCE_SCHEMA AS VARCHAR (20)), T2.TYPE, 
                                     CAST (T0.SEQUENCE_NAME AS VARCHAR (50)),
                                     CAST( T0.DATA_TYPE AS VARCHAR (20)),
                                     T0.NUMERIC_PRECISION, T0.NUMERIC_SCALE, 
                                     CAST(T0.START_VALUE AS BIGINT), 
                                     CAST(T0.MINIMUM_VALUE AS BIGINT), 
                                     CAST(T0. MAXIMUM_VALUE AS BIGINT), 
                                     CAST(T0.INCREMENT AS BIGINT), 
                                     T0.CYCLE_OPTION, T2.CACHE_SIZE
                             FROM
                                     INFORMATION_SCHEMA.SEQUENCES AS T0
                                     INNER JOIN sys.schemas AS T1 ON T1.NAME = T0.SEQUENCE_SCHEMA
                                     INNER JOIN sys.sequences AS T2 ON T1.schema_id = T2.schema_id 
                                                                          AND T0.SEQUENCE_NAME = T2.NAME
                             WHERE
                                     T2.type = 'SO' AND 
                                     T0.SEQUENCE_CATALOG LIKE  '" + l_qual_f /* owner */ +
                                     "' AND T0.SEQUENCE_SCHEMA LIKE '" + l_owner_f + "'" .

             RUN STORED-PROC DICTDBG.send-sql-statement LOAD-RESULT-INTO SeqHdl NO-ERROR (sqlstr). 

             FOR EACH gate-work where gate-type = "SEQUENCE":
              /* native seq and rev/old seq of same name if exist in MS SQL,
               * native seq will take precedence. rev/old will not be pulled 
               * in the schema holder 
               */
              FIND s_ttb_ntvseq WHERE  s_ttb_ntvseq.seqname = gate-work.gate-name NO-LOCK NO-ERROR.
                 IF AVAILABLE s_ttb_ntvseq /* gate-work */ THEN DO: 
                   DELETE gate-work.
                 END. 
             END. 

              FOR EACH s_ttb_ntvseq: 
                CREATE gate-work.
                   ASSIGN
                      lim = lim + 1

                      gate-work.gate-type = "SEQUENCE"
                      gate-work.gate-name = s_ttb_ntvseq.seqname
                      gate-work.gate-qual = s_ttb_ntvseq.fdbname
                      gate-work.gate-user = s_ttb_ntvseq.schname
                      gate-work.gate-prog = s_ttb_ntvseq.seqname
                   /* gate-work.gate-prog = gate-work.gate-prog = ( IF AVAILABLE DICTDB._File
                               THEN DICTDB._File._File-name 
                               ELSE ? )*/ .
              END.

       END. /* End of AVAILABLE DICTDB._Db */
END. /* End of Nativeseq */

/*--------------------------------END NATIVE SEQUENCES--------------------------*/

IF NOT SESSION:BATCH-MODE THEN
   HIDE FRAME gate_wait no-pause.

{prodict/gate/gat_get.i
  &block     = "presel"
  &cleanup   = " "
  &end       = "end."
  &gate-flag = "YES"
  &special1  = " "
  &special2  = " "
  &where     = "gate-work.gate-type <> ""STABLE"""
  }





