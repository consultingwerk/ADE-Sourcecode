/*********************************************************************
* Copyright (C) 2005-2009 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* odb_get - finder for Odbc tables */

/*

OUTPUT:
    gate-work records for found objects

INPUT:
    user_env[25]    "{AUTO},<name>,<owner>,<type>,<qualifier>"
                        for autmatically select all or bringing up the 
                            selection-dialog-box, Initial-values for
                            pre-selection-criterias    
                            
History:  DLM 01/28/98 Added call for stored procedures.
          DLM 09/03/98 Added display as dialog box for gui
          DLM 07/14/99 Added check for _SEQP_ procedure to skip
          DLM 11/18/99 Added assignement of DBMS Type to Db_Misc2[8]
          DLM 10/01/01 Added logic not to pull system tables or overloaded procedures
                       for DB2.
          DLM 09/17/03 Added logic to know if coming from ProToODB to only pull back
                       what was pushed.              
          KSM 04/13/04 Comparing SQLTables_buffer.OWNER to user_library unless it's
                       blank.                                        
          KSM 03/04/05 Added conditions to prevent loading SYS* tables 20050214-028
          KSM 03/21/05 Added more conditions to prevent loading system tables 20041220-005
          DJM 11/11/05 Added schema holder version control linked to the client
     fernando 09/28/06 For DB2, use P_BUFFER_ for pseudo-buffers instead of _BUFFER_ - 20060425-009
     knavneet 02/21/07 For AS400, defining another frame frm_as400 & uppercasing s_owner 
     knavneet 07/24/07 While checking the driver name we read the 1st ENTRY from _Db-misc2[1] as it may have Library name appended to it for DB2/400 
     knavneet 08/22/07 For DB2/400, if Db-misc2[1] has no 2nd entry, s_owner is assigned the default Collection specified in DSN reading from registry 
     fernando 05/27/08 Fixing code that looks for existing stored-proc - OE00130417
     fernando 09/24/08 Allow synonyms to be pulled - OE00175227     
     rkumar   12/10/08 fixed OE00178256 for iSeries Access ODBC driver    
     nagaraju 10/21/09 Support for computed column RECID in MSSDS - OE00186593 
*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/gate/odb_ctl.i }
{ prodict/odb/odbvar.i }
&UNDEFINE DATASERVER

DEFINE VARIABLE bug1                AS LOGICAL   NO-UNDO.
DEFINE VARIABLE escp                AS CHARACTER NO-UNDO.
DEFINE VARIABLE c	            AS CHARACTER NO-UNDO.
DEFINE VARIABLE edbtyp              AS CHARACTER NO-UNDO. /* db-type external format */
DEFINE VARIABLE hint	            AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i	            AS INTEGER   NO-UNDO.
DEFINE VARIABLE j	            AS INTEGER   NO-UNDO.
DEFINE VARIABLE found	            AS INTEGER   NO-UNDO.
DEFINE VARIABLE efound	            AS INTEGER   NO-UNDO.
DEFINE VARIABLE l	            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lim	            AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE odbtyp              AS CHARACTER NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE redraw	            AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE rpos1	            AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos2	            AS CHARACTER NO-UNDO.
DEFINE VARIABLE rpos3	            AS CHARACTER NO-UNDO.
DEFINE VARIABLE xld	            AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE canned	            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE inc_qual            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE driver-prefix	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE sqltables-type	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE sqltables-name	    AS CHARACTER NO-UNDO case-sensitive.
DEFINE VARIABLE SQLProcedures-name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE object-type	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_client-qual       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_name_f	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_owner_f	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_qual_f	    AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_rep-presel        AS logical   NO-UNDO.
DEFINE VARIABLE escape_char         AS CHARACTER NO-UNDO.
DEFINE VARIABLE quote_char          AS CHARACTER NO-UNDO.
DEFINE VARIABLE fromproto           AS LOGICAL NO-UNDO.

DEFINE VARIABLE sh_parsbuf          AS CHARACTER NO-UNDO.
DEFINE VARIABLE sh_ver              AS INTEGER NO-UNDO.
DEFINE VARIABLE sh_min_ver          AS INTEGER NO-UNDO.
DEFINE VARIABLE sh_max_ver          AS INTEGER NO-UNDO.
DEFINE VARIABLE is_db2              AS LOGICAL NO-UNDO.
DEFINE VARIABLE is_as400            AS LOGICAL NO-UNDO.
DEFINE VARIABLE default_lib         AS CHARACTER NO-UNDO INITIAL "*".
DEFINE VARIABLE def_libraries       AS CHARACTER INITIAL ""    NO-UNDO. /* OE00179889 */

&IF "{&OPSYS}" NE "UNIX" &THEN
  DEFINE VARIABLE dsn_name            AS CHARACTER NO-UNDO.
  FUNCTION getRegEntry RETURN CHARACTER (INPUT dsnName as CHARACTER, keyName AS CHARACTER) FORWARD.
&ENDIF

/*
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  DEFINE VARIABLE lab-qual AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-user AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pat-qual AS CHARACTER NO-UNDO.
&ENDIF
*/

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
DEFINE INPUT PARAMETER odb-escape AS CHARACTER NO-UNDO.

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

IF odb-escape = ? or odb-escape = " " THEN odb-escape = "".

escape-seq = odb-escape + "_".
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


escape-seq = odb-escape + "%".
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
  odbtyp      = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "user_dbtype"
                  }
  err-msg[1] = SUBSTITUTE(err-msg[1],edbtyp)
  err-msg[2] = SUBSTITUTE(err-msg[2],edbtyp)
  s_wildcard  = FALSE.
  .

IF INDEX(odbtyp,user_dbtype) = 0
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

DO TRANSACTION on error undo, leave on stop undo, leave:
RUN STORED-PROC DICTDBG.CloseAllProcs.
FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.
/* Please Note: In the event that we cover DB2 drivers on a UNIX platform:
   The DataDirect ODBC driver on the UNIX platform has a corresponding location in the
   ODBC.INI file the connection string attribute "Collection" (COL=<value>) and
   AlternateID (AID=<value>) where these values can be extracted.
   Also Note: The registry keys & values for SQL qualifier are specific to DataDirect drivers.
   The process for obtaining the appropriate qualifier may change if access to DB2 native
   drivers through the ODBC DataServer is considered in the future */
 /* OE00178256- In case of iSeries Access ODBC driver, the registry entry with the key 
    "DefaultLibraries" specifies the iSeries libraries to add to the server job's library list
    The libraries are delimited by commas or spaces, and *USRLIBL may be used as a 
    place holder for the server job's current library list. */
 /* OE00179889- iSeries driver: Default library is genrated based on the following rules:
    If any value is provided for SQL Default Library, then a space-separated list is created 
    in the registry, irrespective of spaces or commas separating the library list.
    If no value is provided for SQL Default Library, then first character is comma and then a 
    space-separated list is created in registry irrespective of presence of spaces or commas 
    separating the libaries in the library list.  */



RUN STORED-PROC DICTDBG.GetInfo (0).
  for each DICTDBG.GetInfo_buffer:
    is_as400 = (INDEX(UPPER(DICTDBG.GetInfo_buffer.dbms_name), "AS/400") > 0) OR 
               (INDEX(UPPER(DICTDBG.GetInfo_buffer.dbms_name), "DB2/400") > 0) .
    if is_as400 THEN
    DO:  
      if NUM-ENTRIES(DICTDB._Db._DB-misc2[1]) > 1 THEN 
        s_owner = ENTRY(2,DICTDB._Db._DB-misc2[1]).   
      else if (NUM-ENTRIES(DICTDB._Db._DB-misc2[1]) = 1) THEN 
      DO:
        &IF "{&OPSYS}" NE "UNIX" &THEN
          ASSIGN dsn_name    = DICTDB._Db._Db-addr.
	  IF INDEX(getRegEntry(dsn_name,"Driver"),"cwbodbc.dll") EQ 0 THEN 
		 default_lib = (IF getRegEntry(dsn_name,"AlternateID") <> ? THEN
                   getRegEntry(dsn_name,"AlternateID")
                 ELSE (IF getRegEntry(dsn_name,"Collection") <> ? THEN
                   getRegEntry(dsn_name,"Collection")
                 ELSE (IF getRegEntry(dsn_name,"LogOnID") <> ? THEN
                   getRegEntry(dsn_name,"LogOnID")
		 ELSE "*" ))).
	  ELSE DO:
		ASSIGN def_libraries = getRegEntry(dsn_name,"DefaultLibraries").
		default_lib = (IF def_libraries <> ? AND index(def_libraries,",") EQ 1 THEN
		   SUBSTRING(def_libraries,2,index(def_libraries," ") - 1) 
		 ELSE (IF def_libraries <> ? AND index(def_libraries," ") GE 0 THEN
		   SUBSTRING(def_libraries,1,index(def_libraries," ") - 1) 
		 ELSE (IF def_libraries EQ ? AND getRegEntry(dsn_name,"UserID") <> ? THEN 
                   getRegEntry(dsn_name,"UserID")
		 ELSE "*"))).  
	  END. 
        &ENDIF
         s_owner = default_lib.
      END. /* END DO: */
    END. /* END DO: */
    else
        s_owner = "*".
   end. /* END for-each */ 
CLOSE STORED-PROC DICTDBG.GetInfo.
END.

if is_as400 then
DO:
{prodict/gate/presel.i
  &block  = "presel"
  &frame  = "frm_as400"
  &link   = """ """
  &master = """ """
  }
END.
else
DO:
{prodict/gate/presel.i
  &block  = "presel"
  &frame  = "frm_ntoq"
  &link   = """ """
  &master = """ """
  }
END.
s_owner = UPPER(s_owner).

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

/*  This was checking for each individual dll that is certified.  Too many 
    complaints/bugs logged against the warning message.

    IF NOT CAN-DO(odbc-certify-list, DICTDBG.GetInfo_buffer.driver_name)
     THEN MESSAGE "The" DICTDBG.GetInfo_buffer.driver_name
      "driver was not tested and approved by PROGRESS Software."
      VIEW-AS ALERT-BOX TITLE "Warning".
*/

    IF DICTDB._Db._Db-misc2[1] = ?
     THEN DO:

        IF (LENGTH(DICTDBG.GetInfo_buffer.escape_char,"character") < 1)
            THEN  escape_char = " ".
            ELSE  escape_char = DICTDBG.GetInfo_buffer.escape_char .
        IF (LENGTH(DICTDBG.GetInfo_buffer.quote_char,"character") < 1)
            THEN  quote_char = " ".
            ELSE  quote_char = DICTDBG.GetInfo_buffer.quote_char.

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

      /* If client version is formatted w/"sh_min", the client is OpenEdge 10.1A or greater 
       * which knows about the dictionary version number.  The current format of _DB-misc2[7]
       * conforms to the following sample:
       *
       * "Dictionary Ver#: 1.000.000; Client Ver#: 101.00,(sh_min=1,sh_max=2); Server Ver#: 101.00; Schema Holder Ver#: 1"
       *
       */

      IF INDEX(DICTDBG.GetInfo_buffer.prgrs_clnt, ",(sh_min=") <> 0 THEN
        DICTDB._Db._Db-misc2[7] = DICTDB._Db._Db-misc2[7] + " Schema Holder Ver#: ".

      REPEAT i = 1 TO 80:
        IF   ( CAN-DO(odbc-bug-list[i], driver-prefix)
         OR    CAN-DO(odbc-bug-list[i], "ALL") )
         AND NOT CAN-DO(odbc-bug-excld[i], driver-prefix)
         THEN ASSIGN
           DICTDB._Db._Db-misc2[4] = DICTDB._Db._Db-misc2[4]
                                   + string(i) + "," .
        END. /* REPEAT */

      END. /* DICTDB._Db._Db-misc2[1] = ? DO */

    ELSE IF ENTRY(1,DICTDB._Db._Db-misc2[1]) <> DICTDBG.GetInfo_buffer.driver_name
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

    /** Perform a schema holder version check and assignment if needed **/      

    found = INDEX(DICTDBG.GetInfo_buffer.prgrs_clnt, ",(sh_min="). 
    IF found <> 0 THEN DO:
         
      sh_parsbuf = SUBSTRING(DICTDBG.GetInfo_buffer.prgrs_clnt, found + 1).
      found = INDEX(sh_parsbuf, "sh_min=").

      found = found + LENGTH("sh_min=").
      efound = INDEX(sh_parsbuf, ",").
      IF efound > 0 AND efound > found THEN
        sh_min_ver = INTEGER(SUBSTRING(sh_parsbuf, found, efound - found)).

      sh_parsbuf = SUBSTRING(sh_parsbuf, efound + 1).
      found = INDEX(sh_parsbuf, "sh_max=").

      IF found <> 0 THEN DO:
        found = found + LENGTH("sh_max=").
        efound = INDEX(sh_parsbuf, ");").
        IF efound > 0 AND efound > found THEN
          sh_max_ver = INTEGER(SUBSTRING(sh_parsbuf, found, efound  - found)).
      END.
    END.

    /* This code won't (and shouldn't) set the schema holder version on 
     * schema holders create prior to the "version 101A" client set for
     * 10.0B04 and 10.1A.
     */

    found = INDEX(DICTDB._Db._Db-misc2[7], " Schema Holder Ver#: ").
    IF found <> 0 THEN DO:
      found = found + LENGTH(" Schema Holder Ver#: ") - 1.

      /* There is no specified schema holder version number yet */
      IF found = LENGTH(DICTDB._Db._Db-misc2[7]) THEN
        ASSIGN
          DICTDB._Db._Db-misc2[7] = DICTDB._Db._Db-misc2[7] + STRING(sh_min_ver).

      ELSE DO: /* Analyze schema holder value */

        sh_ver = INTEGER(SUBSTRING(DICTDB._Db._Db-misc2[7], found)).

        /* Catch old dictionaries, built by old clients, that are incompatible with 
         * this client.
         */

        IF sh_ver < sh_min_ver THEN DO:
 
          RUN adecomm/_setcurs.p ("").
          MESSAGE
            "The Schema Holder was created with an older version" SKIP
            "of OpenEdge than is supported by this client." SKIP
            "Please recreate your Schema Holder with this newer client."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RUN adecomm/_setcurs.p ("WAIT").
          CLOSE STORED-PROC DICTDBG.GetInfo.
          RETURN.
          END.

        /* Catch new dictionaries, built by new client, that are incompatible with 
         * this older client.
         */ 

        IF sh_ver > sh_max_ver THEN DO:
 
          RUN adecomm/_setcurs.p ("").
          MESSAGE
            "The Schema Holder was created with a newer version" SKIP
            "of OpenEdge than is supported by this client." SKIP
            "Please recreate your Schema Holder with this back revision" SKIP
            "client or use a newer OpenEdge client with this schema holder." SKIP
            "NOTE: Recreation with a back revision client may cause newer" SKIP
            "features to be dropped.  Please refer to release notes"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RUN adecomm/_setcurs.p ("WAIT").
          CLOSE STORED-PROC DICTDBG.GetInfo.
          RETURN.
          END.

        END. /* else of if found = LENGTH(DICTDB._Db._Db-misc2[7]) */
      END. /* if found <> 0 */
    
    END.  /* FOR EACH DICTDBG.GetInfo_buffer */
    
  CLOSE STORED-PROC DICTDBG.GetInfo.

/*------------------------------------------------------------------*/
/*                        pull in schema-info                       */
/*------------------------------------------------------------------*/
  IF user_env[25] = "AUTOM" THEN 
     ASSIGN user_env[25] = "AUTO"
            fromproto = TRUE.
  ELSE
     ASSIGN fromproto = FALSE.

  ASSIGN
    is_db2 = INDEX(UPPER(_Db._Db-misc2[8]), "DB2") > 0
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
.
  IF l_client-qual THEN DO:
      /* 
         DB2/400 may take a long time to pull definitions when owner is left as ?.
         So if it's DB2 db and no wildcard was specified for the owner, pass it 
         instead to speed up the process of pulling the object name.
      */
      IF NOT is_db2 OR INDEX(s_owner,"*") > 0 OR INDEX(s_owner, "?") > 0 THEN
         l_owner_f = ?. /* non db2 db or wildcard specified, pass ? */
      
      IF fromproto AND is_db2 AND user_library NE "" THEN
          l_owner_f = user_library. /* library name from DB2/400 */
  
      RUN STORED-PROC DICTDBG.SQLTables (?, l_owner_f, ?, "TABLE,VIEW,SYNONYM").
  END.
  ELSE 
      RUN STORED-PROC DICTDBG.SQLTables 
                  (l_qual_f, l_owner_f, l_name_f, "TABLE,VIEW,SYNONYM").

  FOR EACH DICTDBG.SQLTables_buffer:
   /* If fromproto then only pull in what we pushed */ 
   IF fromproto AND 
     TRIM(CAPS(DICTDBG.SQLTables_buffer.OWNER)) <> 
     TRIM(CAPS(IF user_library NE "" THEN 
                 user_library ELSE odb_username)) THEN NEXT.

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
    /* 20060425-009
       for DB2, we look for P_BUFFER, since the object name can't start with _ 
    */
    AND NOT (is_db2 AND 
             TRIM(DICTDBG.SQLTables_buffer.name)      BEGINS "p_buffer_"
             AND s_type                               MATCHES "buffer"
            )
    AND NOT (is_db2 AND TRIM(DICTDBG.SQLTables_buffer.name) MATCHES "p_buffer_"
                                                            + s_name )
    THEN NEXT.
    ELSE IF TRIM(DICTDBG.SQLTables_buffer.owner) = "SYSIBM" OR
            TRIM(DICTDBG.SQLTables_buffer.owner) = "SYSCAT" OR
            TRIM(DICTDBG.SQLTables_buffer.owner) = "SYSSTAT" OR
            TRIM(DICTDBG.SQLTables_buffer.owner) = "SYSFUN"  THEN
               NEXT.
    ELSE IF TRIM(DICTDBG.SQLTables_buffer.name) = "SYSCHKCST" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSCOLUMNS" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSCST" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSCSTCOL" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSCSTDEP" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSINDEXES" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSKEYS" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSKEYCST" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSPACKAGE" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSREFCST" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTABLES" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTABLEDEP" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTRIGCOL" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTRIGDEP" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTRIGGERS" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSTRIGUPD" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSVIEWDEP" OR
            TRIM(DICTDBG.SQLTables_buffer.name) = "SYSVIEWS" OR
            TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "QIDCT" THEN
               NEXT.
    ELSE DO: 
        /* Check if there is a match with unknown value for
         * in SQLTables_buffer.  This can happen in PODBC. 
         */
         
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
                          AND (LC(sqltables-name) BEGINS "_buffer_" 
                               /* 20060425-009 - for DB2, look for P_BUFFER */
                               OR (is_db2 AND LC(sqltables-name) BEGINS "p_buffer_"))
                            )
                          THEN (IF LC(sqltables-name) BEGINS "_buffer_" 
                                THEN substring(sqltables-name,2,6,"character")
                                ELSE substring(sqltables-name,3,6,"character"))
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
                               THEN (IF LC(sqltables-name) BEGINS "_buffer_" 
                                     THEN SUBSTRING(sqltables-name,9,-1,"character")
                                     /* 20060425-009 - for DB2, look for P_BUFFER */
                                     ELSE SUBSTRING(sqltables-name,10,-1,"character"))
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
    IF l_client-qual THEN DO:
        /* 
           DB2/400 may take a long time to pull definitions when owner is left as ?.
           So if it's DB2 db and no wildcard was specified for the owner, pass it 
           instead to speed up the process of pulling the object name.
        */
        IF NOT is_db2 OR INDEX(s_owner,"*") > 0 OR INDEX(s_owner, "?") > 0 THEN
           l_owner_f = ?. /* non db2 db or wildcard specified, pass ? */
        
        IF fromproto AND is_db2 AND user_library NE "" THEN
            l_owner_f = user_library. /* library name from DB2/400 */
         
       RUN STORED-PROC DICTDBG.SQLProcedures (?, l_owner_f, ?).
    END.
   ELSE RUN STORED-PROC DICTDBG.SQLProcedures (l_qual_f, l_owner_f, l_name_f).

  FOR EACH DICTDBG.SQLProcs_Buffer:
   /* If fromproto then only pull in what we pushed */ 
   IF fromproto AND 
     TRIM(CAPS(DICTDBG.SQLProcs_buffer.OWNER)) <> 
     TRIM(CAPS(IF user_library NE "" THEN 
                 user_library ELSE odb_username)) THEN NEXT.

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
    /* 20060425-009 - for DB2, look for P_BUFFER */
    AND NOT (is_db2 AND TRIM(DICTDBG.SQLProcs_Buffer.name) BEGINS  "p_buffer_" )
    AND NOT (is_db2 AND TRIM(DICTDBG.SQLProcs_Buffer.name) MATCHES "p_buffer_"
                                                             + s_name)
    THEN NEXT.
    ELSE DO: 
        /* Check if there is a match with unknown value for
         * in SQLProcs_Buffer.  This can happen in PODBC. 
         */
         
        IF TRIM(DICTDBG.SQLProcs_Buffer.name)  = ? THEN 
            IF  NOT ( (s_name = ?) OR (s_name = "*") )  THEN NEXT.
            
        IF TRIM(DICTDBG.SQLProcs_Buffer.owner) = ? THEN
            IF NOT ( (s_owner = ?) OR (s_owner = "*") ) THEN NEXT.
            
        IF TRIM(DICTDBG.SQLProcs_Buffer.qual)  = ? THEN 
            IF NOT ( (s_qual = ?) OR (s_qual = "*") )   THEN NEXT.
 
            
    END. /* ELSE DO */    

    IF DICTDBG.SQLProcs_Buffer.name BEGINS "_SEQP_" THEN NEXT.

    IF TRIM(DICTDBG.SQLProcs_buffer.owner) = "SYSIBM" OR
       TRIM(DICTDBG.SQLProcs_buffer.owner) = "SYSCAT" OR
       TRIM(DICTDBG.SQLProcs_buffer.owner) = "SYSSTAT" OR
       TRIM(DICTDBG.SQLProcs_buffer.owner) = "SYSFUN" THEN NEXT.

    /* DB2 allows overloading of procedures which the DataServer does not support */
    FIND FIRST gate-work WHERE gate-work.gate-name = DICTDBG.SQLProcs_Buffer.name
        NO-LOCK NO-ERROR.
    IF AVAILABLE gate-work THEN NEXT.
 
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

HIDE FRAME gate_wait no-pause.

{prodict/gate/gat_get.i
  &block     = "presel"
  &cleanup   = " "
  &end       = "end."
  &gate-flag = "YES"
  &special1  = " "
  &special2  = " "
  &as400-flag = "is_as400"
  &where     = "gate-work.gate-type <> ""STABLE"""
  }

&IF "{&OPSYS}" NE "UNIX" &THEN

&SCOPED-DEFINE KEY_PATH "ODBC~\ODBC.INI~\"

/* Function : getRegEntry
   Purpose  : To read from WindowsRegistry
   Input    : DSN name as charcter & Key as Character
   Output   : Value read from registry as character */

FUNCTION getRegEntry RETURN CHARACTER
 (INPUT dsnName as CHARACTER, keyName AS CHARACTER):
  DEFINE VARIABLE keyData AS CHARACTER NO-UNDO INIT ?.

  /* Look for User DSN first */
   LOAD "SOFTWARE" BASE-KEY "HKEY_CURRENT_USER".
   USE "SOFTWARE".
   GET-KEY-VALUE SECTION {&KEY_PATH} + dsnName
   KEY keyName
   VALUE keyData.
   UNLOAD "SOFTWARE".

  /* Look for System DSN, if User DSN not found */
  IF keyData EQ ? THEN DO:
   LOAD "SOFTWARE" BASE-KEY "HKEY_LOCAL_MACHINE".
   USE "SOFTWARE".
   GET-KEY-VALUE SECTION {&KEY_PATH} + dsnName
   KEY keyName
   VALUE keyData.
   UNLOAD "SOFTWARE".
  END.

  RETURN keyData.
END FUNCTION.
&ENDIF
