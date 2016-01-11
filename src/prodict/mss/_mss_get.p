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

DEFINE BUFFER gate-buff FOR gate-work.
DEFINE stream s_stm_errors.

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

/* delete eventually left-over records from earlier schema-pulls */
for each gate-work: delete gate-work. end.
for each s_ttb_seq: delete s_ttb_seq. end.
for each s_ttb_tbl: delete s_ttb_tbl. end.
for each s_ttb_fld: delete s_ttb_fld. end.
for each s_ttb_idx: delete s_ttb_idx. end.
for each s_ttb_idf: delete s_ttb_idf. end.


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
        DICTDB._Db._Db-misc2[7] = "Dictionary Ver#: " +  odbc-dict-ver
  		                          + " Client Ver#: "
  		                          + DICTDBG.GetInfo_buffer.prgrs_clnt
  		                          + " Server Ver# "
  		                          + DICTDBG.GetInfo_buffer.prgrs_srvr
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

    FIND DICTDB._File
      WHERE DICTDB._File._Db-recid     = drec_db
      AND   DICTDB._File._For-name     = sqltables-name
      AND   DICTDB._File._For-owner    = TRIM(DICTDBG.SQLTables_buffer.owner)
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
                              ELSE IF object-type = "SEQUENCE"
                               THEN SUBSTRING(sqltables-name,7,-1,"character")
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

    ASSIGN
      SQLProcedures-name = TRIM(DICTDBG.SQLProcs_Buffer.name)
      object-type    = "PROCEDURE".

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
      IF substring(gate-work.gate-name,(length(gate-work.gate-name) - 1)) = ";1" THEN
        ASSIGN gate-work.gate-name = substring(gate-work.gate-name,1,(length(gate-work.gate-name) - 2)).
    END.   /* FOR EACH DICTDBG.SQLProcs_Buffer */

  CLOSE STORED-PROC DICTDBG.SQLProcedures.

  END. /* DO TRANSACTION */

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

/*------------------------------------------------------------------*/



