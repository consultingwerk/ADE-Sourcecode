/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _preproc.p

Description:
    Generates the preprocessor section in a .w file. 

Input Parameters:  
    p_proc-id    = Context id of the current procedure
    p_status     = used to check status of _U records
    skip_queries = IF DEFINED, don't write out queries.

Output Parameters:
   <None>

Author: Wm.T.Wood [from adeuib/_gendefs.p by D. Ross Hunter]
Created: 1/13/97
Updated: 2/13/98 adams Modified for Skywalker

---------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p_proc-id AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_status  AS CHAR    NO-UNDO.

/* Include files */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeuib/property.i }    /* Object Property TEMP-TABLE                     */
{ adeweb/genshar.i}      /* Shared variable definitions                    */
{ adeuib/triggers.i }

DEFINE SHARED STREAM P_4GL.
DEFINE BUFFER x_U  FOR _U.

DEFINE VARIABLE tmp_string     AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE debug FALSE

/* ************************************************************************* */
/*                                                                           */
/*                         PREPROCESSOR DEFINITIONS                          */
/*                                                                           */
/* ************************************************************************* */

/* Find the current procedure that we are creating definitions for. */
FIND _P WHERE RECID(_P) eq p_proc-id.

PUT STREAM P_4GL UNFORMATTED
  "&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK ":U SKIP.
    
/* Define the frames for this window                                         */
PUT STREAM P_4GL UNFORMATTED SKIP (1)
  "/* ********************  Preprocessor Definitions  ******************** */":U
  SKIP(1).

/* Put out Procedure-Type for .p and .w files (not for .i's) */
IF _P._TYPE ne "" AND _P._file-type <> "i":U THEN
 PUT STREAM P_4GL UNFORMATTED 
   "&SCOPED-DEFINE PROCEDURE-TYPE ":U _P._TYPE SKIP (1).

IF _P._html-file ne "":U THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&SCOPED-DEFINE WEB-FILE ":U _P._html-file SKIP (1).

/* List the designated Frame-Name and First Browse */
FIND FIRST x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._TYPE          eq "FRAME":U
                 AND x_U._STATUS BEGINS u_status USE-INDEX _NAME NO-ERROR.
IF AVAILABLE x_U THEN DO:
  ASSIGN frame_name_f = x_U._NAME.
  PUT STREAM P_4GL UNFORMATTED
    "/* Default preprocessor names */":U  SKIP 
    "&SCOPED-DEFINE FRAME-NAME " frame_name_f SKIP.
END.

/* Write out QUERY-NAME. This will get written out even if a query
   exists without a table list. */
FIND FIRST x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._TYPE          eq "QUERY":U
                 AND x_U._STATUS BEGINS u_status USE-INDEX _NAME NO-ERROR.
IF AVAILABLE x_U THEN PUT STREAM P_4GL UNFORMATTED
  "&SCOPED-DEFINE QUERY-NAME " x_U._NAME SKIP.
PUT STREAM P_4GL UNFORMATTED SKIP(1).

/* Frame, Query & Browser preprocessor variables (eg. User &FIELDS-IN-QUERY) */
FOR EACH _U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND _U._TYPE        eq "QUERY":U
                 AND _U._STATUS      eq u_status USE-INDEX _OUTPUT:
  /* Find the _Q records for use in put_query_preproc_vars.
     (If there are any preprocessor variables.) */
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  FIND _Q WHERE RECID(_Q) eq _C._q-recid.
  /* Only put out the section if it has some tables, or some contained 
     browse frames */
  IF _Q._TblList ne "" OR 
    CAN-FIND (FIRST _TRG WHERE _TRG._wRECID eq RECID(_U) 
                           AND _TRG._tEVENT eq "OPEN_QUERY":U
                           AND _TRG._STATUS ne "DELETED":U) THEN DO:
    ASSIGN tmp_string = "/* Definitions for ":U + _U._TYPE + " ":U + _U._NAME
           tmp_string = tmp_string + 
                        FILL(" ":U,MAXIMUM(1,72 - LENGTH(tmp_string,"RAW":U))) +
                        "*/":U.
    PUT STREAM P_4GL UNFORMATTED SKIP tmp_string SKIP.
    RUN put_query_preproc_vars.
  END. 
END.

/* Window preprocessor variables (eg. User &LIST-1) */
IF CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE) THEN
  RUN put_win_preproc_vars.

/* Close the section. */
PUT STREAM P_4GL UNFORMATTED "&ANALYZE-RESUME":U SKIP(2). 

/* * * * * * * * * * * * * * Internal Procedures * * * * * * * * * * * * * * */

/* Build a simple list of tables from a 4gl query */
PROCEDURE build_table_list:
  DEFINE INPUT  PARAMETER iquery    AS CHARACTER     NO-UNDO.
  DEFINE INPUT  PARAMETER delmtr    AS CHARACTER     NO-UNDO.
  DEFINE INPUT  PARAMETER qualify   AS LOGICAL       NO-UNDO.
  DEFINE OUTPUT PARAMETER otbls     AS CHARACTER     NO-UNDO.
  
  DEFINE VARIABLE db_name           AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE ix                AS INTEGER       NO-UNDO.
  DEFINE VARIABLE tmptbl            AS CHARACTER     NO-UNDO.
  
  ASSIGN iquery  = REPLACE(REPLACE(REPLACE(TRIM(iquery),CHR(13)," "),
                                   CHR(10), " "), "~~", " ").
  /* condense spaces */
  DO WHILE otbls NE iquery:
    ASSIGN otbls  = iquery
           iquery = REPLACE(iquery, "  ":U, " ").
  END.
  otbls = "".                     
  DO WHILE ix < NUM-ENTRIES(iquery," ":U):
    ix = ix + 1.
    IF CAN-DO("EACH,FIRST,LAST,CURRENT,NEXT,PREV",ENTRY(ix, iquery, " ":U))
    THEN DO: /* Next token is a table name */
      IF (ix > 1 AND ENTRY(ix - 1, iquery, " ":U) NE "GET":U)
          OR ix = 1 THEN DO:  /* GET NEXT or GET PREV is followed by query-name */
        ASSIGN ix       = ix + 1
               db_name = TRIM(ENTRY(ix, iquery, " ":U),",.":U)
               tmptbl  = (IF NUM-ENTRIES(db_name,".":U) = 1 AND qualify
                          THEN ldbname(1) + "." + db_name ELSE db_name). 
        IF LOOKUP(tmptbl,otbls,delmtr) = 0 THEN otbls   = otbls + delmtr + tmptbl.
      END.
    END. /* Next token is a table name */
  END.  /* While ix < number of entries */
  ASSIGN otbls = TRIM(otbls,delmtr).
END PROCEDURE. /* build_table_list */
   
/* Put out the query preprocessor variables --
   For each browser, frame (or dialog-box) write:
	 Scope-define FIELDS-IN-QUERY-NAME <some vars>
	 Scope-define OPEN-BROWSERS-IN-QUERY-NAME queries
	 Scope-define OPEN-QUERY-NAME query
	 Scope-define FIRST-TABLE-IN-QUERY-NAME <some tables>
	 Scope-define TABLES-IN-QUERY-NAME <some tables>
   The current _U and _C records point to the current frame.
*/
PROCEDURE put_query_preproc_vars:
  DEFINE VARIABLE tables_in_query  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE enabled-tables   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_cnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmp_cnt2         AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE tmp_code         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_code2        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_line         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_line2        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_item         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cur-ent          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db_name          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TuneOpts         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE jj               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE n-ent            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE per-pos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qt               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tc               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE token            AS CHARACTER NO-UNDO.

  DEFINE BUFFER ipU for _U.
  DEFINE BUFFER ipQ for _Q.
  
  /* Create a comma-delimeted list of tables in the default query (based on
     _C._TblList which has the form "db.table,db.table2 OF db.table,db.table2
     WHERE db.table etc).  So we want only the first ENTRY of each element
     of the list. */
     
  /* First see if the query is freeform.  If so use the _TRG record to determine
     the tables in the query, otherwise use _Q._TblList                       */
  FIND _TRG WHERE _TRG._wRECID eq RECID(_U) 
              AND _TRG._tEVENT eq "OPEN_QUERY":U NO-ERROR.
  IF AVAILABLE _TRG THEN 
    RUN build_table_list (_TRG._tCODE, " ":U, NO, OUTPUT tables_in_query).
  ELSE 
    tables_in_query = _Q._TblList.
    
  DO ix = 1 TO NUM-ENTRIES(tables_in_query):
    ENTRY(ix,tables_in_query) = ENTRY (1,TRIM(ENTRY(ix,tables_in_query)), " ":U).
  END.
  
  /* Now put out the Open Query and related TABLE  names (if there is one) */
  FIND _TRG WHERE _TRG._wRECID eq RECID(_U)
              AND _TRG._tEVENT eq "OPEN_QUERY":U NO-ERROR.
              
  IF AVAILABLE _TRG THEN DO:
    PUT STREAM P_4GL UNFORMATTED 
      "&SCOPED-DEFINE SELF-NAME ":U + _U._NAME SKIP.
    ASSIGN tmp_item = RIGHT-TRIM(_TRG._tCODE).
    
    DO ix = 1 TO NUM-ENTRIES(tmp_item,CHR(10)):
      /* Remove white space at end of each line */
      ENTRY(ix,tmp_item,CHR(10)) = RIGHT-TRIM(ENTRY(ix,tmp_item,CHR(10))).
    END.
    ASSIGN _TRG._tCODE = tmp_item
           tmp_item    = REPLACE(REPLACE(RIGHT-TRIM(tmp_item,".:":U),CHR(10)," ":U),
                              ",":U,", ~~":U + CHR(10) + FILL(" ":U,6)).
    /* IF we had a freeform qury (from _code) then load _Q._TblList FROM tmp_item */
    RUN build_table_list (tmp_item, ",":U, NO, OUTPUT _Q._TblList). 
  END. 
  ELSE IF _Q._TblList ne "" THEN DO:
    RUN adeshar/_coddflt.p ("_OPEN-QUERY":U, RECID(_U), OUTPUT tmp_item).

    /* If there are any query-tining options prepare them for output */
    IF tmp_item NE "" THEN 
      ASSIGN TuneOpts = REPLACE(REPLACE(TRIM(_Q._TuneOptions),CHR(13),""),
                       CHR(10)," ~~":U + CHR(10) + "              ":U)
             /* Add Tuning Options to the Open Query line. */
             tmp_item = tmp_item +
                  (IF TuneOpts NE "" THEN " QUERY-TUNING (":U + TuneOpts + ")":U
                                     ELSE "").
  END.      
  
  /* Add a new-line between OPEN QUERY statements. */
  IF tmp_item NE "" THEN 
    PUT STREAM P_4GL UNFORMATTED 
       "&SCOPED-DEFINE OPEN-QUERY-":U + _U._NAME + " ":U +
       (IF tmp_item BEGINS "OPEN QUERY":U THEN
             tmp_item
        ELSE IF (tmp_item BEGINS "FOR EACH":U OR
                 tmp_item BEGINS "FOR FIRST":U OR
                 tmp_item BEGINS "FOR LAST":U) THEN 
             "OPEN QUERY ":U + _U._NAME + " ":U + tmp_item
        ELSE IF (tmp_item BEGINS "EACH":U OR
                 tmp_item BEGINS "FIRST":U OR
                 tmp_item BEGINS "LAST":U) THEN 
             "OPEN QUERY ":U + _U._NAME
             + (IF LOOKUP ("Preselect":U, _Q._OptionList, " ":U) eq 0
                THEN " FOR ":U ELSE " PRESELECT ":U )
             + tmp_item
        ELSE tmp_item) + ".":U SKIP.
  
  /* Now put the TABLES-IN-QUERY.  */
  RUN put_tbllist (_Q._TblList, 
                   FALSE, /* Not SHARED */
                   "TABLES-IN-QUERY-":U + _U._NAME,
                   "&1-TABLE-IN-QUERY-":U + _U._NAME, 
                   1,  /* Only put the first table. */
                   " ":U /* Space delimited */ ).
		     
  /* Skip a line before next section */
  PUT STREAM P_4GL UNFORMATTED SKIP(1).
END. /* put_query_preproc_vars */

/* put_tbllist: Put out the contents of pc_TblList variable.  Note that the
   list can beof the form
       sports.Customer,sports.Order OF sports.Customer.
   A bunch of preprocessor variables are created:
       p_tables_var -- all tables
       p_ith_var -- ith table in the list. (up to pi_max)
            This variable has the form "&1-ENABLED-TABLE".  The &1 is replaced with
            FIRST, SECOND, THIRD (up to 3 variables).
   Note:
       pl_shared -- the tables are shared, so replace "." with "_"
		    [i.e. sports.customer becomes buffer sports_customer]
*/
PROCEDURE put_tbllist:
  DEFINE INPUT PARAMETER pc_tbllist  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pl_shared   AS LOGICAL   NO-UNDO.
  DEFINE INPUT PARAMETER p_table_var AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_ith_var   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_imax      AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER p_delim     AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cnt       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmp_code  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE more_code AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp_item  AS CHARACTER NO-UNDO.

  /* Do we need this section at all */
  cnt = NUM-ENTRIES(pc_TblList).
  IF cnt > 0 THEN DO:    
    /* we only support up to 3 items so far. */
    IF p_imax > 3 THEN 
      p_imax = 3.                         
    tmp_code = "&SCOPED-DEFINE ":u + p_table_var + " ":u.
    
    DO ix = 1 TO cnt:
      tmp_item = ENTRY(1,TRIM(ENTRY(ix,pc_TblList)), " ":u).
      IF NUM-ENTRIES(tmp_item,".") > 1 AND _suppress_dbname THEN
        tmp_item = ENTRY(2,tmp_item,".":U).
      IF pl_shared THEN
        tmp_item = (IF _suppress_dbname THEN tmp_item + "_":U
			        ELSE REPLACE(tmp_item,".":U,"_":U)).
      IF ix <= p_imax THEN
        more_code = more_code + "&SCOPED-DEFINE ":U
          + SUBSTITUTE(p_ith_var, ENTRY(ix,
          "FIRST,SECOND,THIRD,FOURTH,FIFTH,SIXTH,SEVENTH,EIGHTH,NINTH,TENTH":U)) 
          + " ":U + tmp_item + CHR(10).
      IF LENGTH(tmp_code + tmp_item, "RAW":U) > 75 THEN DO:
        PUT STREAM P_4GL UNFORMATTED tmp_code "~~":U SKIP.
        tmp_code = "".
      END.
      tmp_code = tmp_code + tmp_item + (IF ix < cnt THEN p_delim ELSE "").
    END.
    /* Finish putting out the line. */
    IF tmp_code ne "" THEN 
      PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.    
    /* Put out the additional code for NTH-enabled-table. */
    IF more_code ne "" THEN 
      PUT STREAM P_4GL UNFORMATTED more_code.    
  END.
END PROCEDURE.

/* Put out the window preprocessor variables --
   For each window (or dialog-box) write:
	 SCOPED-DEFINE ENABLED-FIELDS    <some db-fields>
	 SCOPED-DEFINE ENABLED-OBJECTS   <some non-db objects>
	 SCOPED-DEFINE DISPLAYED-FIELDS  <some db-fields>
	 SCOPED-DEFINE DISPLAYED-OBJECTS <some non-db objects>
	 SCOPED-DEFINE DISPLAY <some vars>
	 SCOPED-DEFINE LIST-1  <some vars>
	 SCOPED-DEFINE LIST-2  <some vars>
	 SCOPED-DEFINE LIST-3  <some vars>
  _h_win points to the current window/dialog-box.
*/
PROCEDURE put_win_preproc_vars:
  &IF {&MaxUserLists} ne 6 &THEN
  &MESSAGE [_gen4gl.p] *** FIX NOW *** User-List not being generated correctly (wood)
  &ENDIF   
  &Scope MaxLists 10
  /*  The extent of all these arrays should be MaxUserLists + 4  */
  DEFINE VARIABLE tmp_code       AS CHAR    NO-UNDO EXTENT {&MaxLists}.
  DEFINE VARIABLE tmp_line       AS CHAR    NO-UNDO EXTENT {&MaxLists}.
  DEFINE VARIABLE enabled-tables AS CHAR    NO-UNDO.
  DEFINE VARIABLE emptyList      AS LOGICAL NO-UNDO EXTENT {&MaxLists} INITIAL YES.
  DEFINE VARIABLE frm-recid      AS RECID   NO-UNDO.
  DEFINE VARIABLE name           AS CHAR    NO-UNDO.
  DEFINE VARIABLE add2list       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE ix             AS INTEGER NO-UNDO.
  DEFINE VARIABLE list-cnt       AS INTEGER NO-UNDO.
  DEFINE VARIABLE tblname        AS CHAR    NO-UNDO.
  DEFINE VARIABLE widg2display   AS CHAR    NO-UNDO.
  DEFINE VARIABLE widg2enable    AS CHAR    NO-UNDO.

  DEFINE BUFFER ipU for _U.

  /* Find the RECID of the first frame */
  IF frame_name_f ne "" THEN DO:
    FIND ipU WHERE ipU._WINDOW-HANDLE eq _P._WINDOW-HANDLE
               AND ipU._NAME          eq frame_name_f 
               AND ipU._TYPE          eq "FRAME":U
               AND ipU._STATUS BEGINS u_status.
    frm-recid = RECID(ipU).
  END.
  
  /* Find the widgets that can be ENABLEd or DISPLAYed (i.e. that have these on their
     property sheet */
  FIND _prop WHERE _prop._NAME eq "DISPLAY":U NO-ERROR.
  
  IF NOT AVAILABLE _prop THEN RETURN.  /* Called from Freeze frame */
  widg2display = _prop._WIDGETS.
  FIND _prop WHERE _prop._NAME eq "ENABLE":U.
  widg2enable = _prop._WIDGETS.
  
  /* Create an alphabetic list of variables in each of the user defined
     lists of variables */ 
  DO ix = 1 TO {&MaxUserLists}:
    tmp_line[ix] = "&SCOPED-DEFINE ":U + ENTRY(ix, _P._LISTS) + " ":U.
  END.
  ASSIGN tmp_line[{&MaxUserLists} + 1] = "&SCOPED-DEFINE ENABLED-FIELDS ":U
         tmp_line[{&MaxUserLists} + 2] = "&SCOPED-DEFINE ENABLED-OBJECTS ":U
         tmp_line[{&MaxUserLists} + 3] = "&SCOPED-DEFINE DISPLAYED-FIELDS ":U
         tmp_line[{&MaxUserLists} + 4] = "&SCOPED-DEFINE DISPLAYED-OBJECTS ":U
         .
 
  /* If there is no frame, then don't bother with Enabled/Displayed Fields and
     Objects */
  list-cnt =  (IF frame_name_f ne "" THEN {&MaxLists} ELSE {&MaxUserLists}).

  /* Look for all variables in the window that have the list checked. */
  FOR EACH ipU WHERE ipU._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND ipU._STATUS        ne "DELETED":U 
                  BY ipU._NAME:
    name = { adeweb/name_u.i &U_BUFFER = "ipU" } .
    
    DO ix = 1 TO list-cnt:
      /* Add the variable to the line if it has LIST-i checked, or if it is
         in the first-frame, and has ENABLE or DISPLAY, and the widget is the
         right "type". */
      IF ix le {&MaxUserLists} THEN
        add2list = ipU._User-List[ix].
      ELSE IF ix eq {&MaxUserLists} + 1 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND 
                    ipU._ENABLE AND (ipU._DBNAME ne ?) AND
                    CAN-DO(widg2enable, ipU._TYPE).
      ELSE IF ix eq {&MaxUserLists} + 2 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND 
                    ipU._ENABLE AND (ipU._DBNAME eq ?) AND
                    CAN-DO(widg2enable, ipU._TYPE).
      ELSE IF ix eq {&MaxUserLists} + 3 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND  
                    ipU._DISPLAY AND (ipU._DBNAME ne ?) AND
                    CAN-DO(widg2enable, ipU._TYPE).
      ELSE 
        add2list = (ipU._parent-recid eq frm-recid) AND 
                    ipU._DISPLAY AND (ipU._DBNAME eq ?) AND
                    CAN-DO(widg2display, ipU._TYPE).
                    
      IF add2list THEN DO:
        emptyList[ix] = NO.
        
        /* Add the name to the existing line (unless that line is full,
           in which case, skip to the next line */             
        IF LENGTH(tmp_line [ix] + name, "CHARACTER":U) > 75 THEN
          ASSIGN
            tmp_code[ix] = tmp_code[ix] + tmp_line[ix] + "~~":U + CHR(10)
            tmp_line[ix] = "".
        tmp_line[ix] = tmp_line[ix] + name + " ":U.

        /* Add to the ENABLED-TABLES list */
        IF ix = {&MaxUserLists} + 1 AND NUM-ENTRIES(name,".":U) > 1 THEN DO:
          tblname = ENTRY(1,name,".":U) +
                   (IF NUM-ENTRIES(name,".":U) = 3 THEN
	                ".":U + ENTRY(2,name,".":U) ELSE "":U).

          IF enabled-tables = "" THEN 
            enabled-tables = tblname.
          ELSE IF NOT CAN-DO(enabled-tables, tblname) THEN
            enabled-tables = enabled-tables + ",":U + tblname.
        END.  /* populate enabled-tables */
      END. /* IF in UserList */
    END. /* DO... */
  END. /* FOR EACH ipU */ 
  
  /* Add any remaining line into the code, and output it. */
  DO ix = 1 TO {&MaxLists}:
    IF tmp_line[ix] ne "" THEN 
      tmp_code[ix] = tmp_code[ix] + tmp_line[ix].
  END.
  
  /* Write Standard Lists - Note: there is no ENABLE or DISABLE if there
     is no frame */
  IF frame_name_f ne "" AND 
    ((emptyList[{&MaxUserLists} + 1] eq NO) OR 
     (emptyList[{&MaxUserLists} + 2] eq NO) OR
     (emptyList[{&MaxUserLists} + 3] eq NO) OR 
     (emptyList[{&MaxUserLists} + 4] eq NO)) THEN DO:
     
    PUT STREAM P_4GL UNFORMATTED SKIP
      "/* Standard List Definitions                                            */":U
      SKIP.
      
    DO ix = {&MaxUserLists} + 1 TO {&MaxLists}:
      IF NOT emptyList[ix] THEN DO:
        PUT STREAM P_4GL UNFORMATTED tmp_code[ix] SKIP.
        IF ix = {&MaxUserLists} + 1 THEN DO:
          IF enabled-tables NE "" THEN
            RUN put_tbllist (enabled-tables, FALSE, "ENABLED-TABLES":U, 
                             "&1-ENABLED-TABLE", 10, " ":U).
        END.  /* If enabled fields */
      END.  /* IF NOT emptylist */
    END.
    PUT STREAM P_4GL UNFORMATTED SKIP(1).
  END. 
  
  /* Write Custom Lists */ 
  PUT STREAM P_4GL UNFORMATTED SKIP
    "/* Custom List Definitions                                              */":U
    SKIP "/* ":U _P._LISTS FILL(" ":U,68 - LENGTH(_P._LISTS,"RAW":U)) " */":U SKIP.
    
  DO ix = 1 TO {&MaxUserLists}:
    IF NOT emptyList[ix] THEN 
      PUT STREAM P_4GL UNFORMATTED tmp_code[ix] SKIP.
  END.
  
END PROCEDURE. /* put_win_preproc_vars */

/* _preproc.p - end of file */
