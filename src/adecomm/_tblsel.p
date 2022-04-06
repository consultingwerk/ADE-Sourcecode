/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: tblsel.p

Description:
  This is just like _fldsel.p except it only allows the user
  to pick tables.

INPUT Parameters
p_Multi    - Should they be allowed to select multiple items.
p_TT       - ? if temp-tables need to be included
             Otherwise a comma delitted list where each entry has the form:
             _like-db._like-table|_name
             The _like-db and _like-table are real database.table combinations
             and _name is either the name of the temp-table that is like
             _like-table or ? if it is the same.


INPUT-OUTPUT Parameters
p_DBName   - The name of the database the schema was picked from.  May
             may optionally be passed in to default the database.
p_TblNames - The name of the table selection.  Optional to pass in default.

OUTPUT Parameters
p_OK       - Did they press OK to get out?

Author: Ross Hunter
Created: 08/08/95 
Updated: 01/06/99 adams Selected Databases selection-list item should default 
                        to first item in the list.

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* Standard layout stuff, colors etc. */
{adecomm/getdbs.i &NEW="NEW"}
{adecomm/tt-brws.i "NEW"}

DEFINE INPUT        PARAMETER p_Multi    AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER p_TT       AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_DBName   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_TblNames AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER p_OK       AS LOGICAL   NO-UNDO INITIAL FALSE.

&global-define TCOL   26
&global-define FWidth 54

DEFINE VAR h_tbl_brws   AS HANDLE  NO-UNDO.
DEFINE VAR new-proc     AS HANDLE  NO-UNDO.  
DEFINE VAR old-proc     AS HANDLE  NO-UNDO.
DEFINE VAR v_dbid       AS RECID   NO-UNDO.
DEFINE VAR v_access     AS LOGICAL NO-UNDO.
DEFINE VAR v_OldDictDb  AS CHAR    NO-UNDO INITIAL ?.  /* saved name of dictdb */
DEFINE VAR repos        AS RECID   NO-UNDO INITIAL ?. 
DEFINE VAR tbl-col      AS DECIMAL NO-UNDO INITIAL {&TCOL}.

DEFINE VAR t_int        AS INTEGER NO-UNDO.
DEFINE VAR t_log        AS LOGICAL NO-UNDO.
DEFINE VAR t_char       AS CHAR    NO-UNDO.

DEFINE BUTTON b_ok      LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_cancel  LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON b_Help    LABEL "&Help"   {&STDPH_OKBTN}.
DEFINE VARIABLE wintitle AS CHARACTER NO-UNDO INIT "Table Selector".
DEFINE QUERY  db-browse FOR s_ttb_db.
DEFINE BROWSE db-browse QUERY db-browse NO-LOCK
       DISPLAY s_ttb_db.ldbnm FORMAT "X(40)"
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SIZE 20.5 BY 6.9 NO-LABELS.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
   DEFINE RECTANGLE rect_Btn_Box {&STDPH_OKBOX}.
&ENDIF


FORM 
   SKIP({&TFM_WID})
  "Databases:"  AT 3       view-as TEXT
  "Tables:"     AT {&TCOL} view-as TEXT 
   SKIP({&VM_WID})

  db-browse      AT 3
  
  { adecomm/okform.i
      &BOX    ="rect_Btn_Box"
      &OK     ="b_OK"
      &CANCEL ="b_Cancel"
      &HELP   ="b_Help" 
  }
  with frame schemapk 
      
      &if DEFINED(IDE-IS-RUNNING) = 0  &then 
       view-as dialog-box title wintitle
      &else
      no-box three-d 
      &endif 
      no-labels  default-button b_OK cancel-button b_Cancel WIDTH {&FWidth}.

FRAME schemapk:HIDDEN = TRUE.

{adeuib/ide/dialoginit.i "FRAME schemapk:handle"}
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
   dialogService:View().
&endif
/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame schemapk DO:
   DELETE PROCEDURE old-proc.
   APPLY "END-ERROR" TO FRAME schemapk.
END.

/*----- SELECTION of OK BUTTON or GO -----*/
ON GO OF FRAME schemapk DO:   /* or OK btn 'cause its auto-go */
  RUN load-private-data IN old-proc.
  ASSIGN p_ok       = true
         p_DBName   = s_ttb_db.ldbnm 
         p_TblNames = h_tbl_brws:PRIVATE-DATA.
end.

/*----- VALUE-CHANGED DB LIST -----*/
ON VALUE-CHANGED OF db-browse IN FRAME schemapk DO:
    RUN load_tables (INPUT "":U).
END.


/*----- DEFAULT-ACTION of tbl_browse -----*/
PROCEDURE table-browse-def-act.
   apply "GO" to frame schemapk.
END.


/*----- HELP -----*/
on HELP of frame schemapk OR choose of b_Help in frame schemapk
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
                             INPUT {&Table_Selection},
                             INPUT ?).


/*----------------------------Mainline code----------------------------------*/

{ adecomm/okrun.i
    &FRAME  = "FRAME schemapk"
    &BOX    = "rect_Btn_Box"
    &OK     = "b_OK"
    &HELP   = "b_Help"
}

/* save the pointer to the current dictdb */
if connected("dictdb") then
v_olddictdb = ldbname("dictdb").

/* Fill up the database selection list */
RUN adecomm/_getdbs.p.

/*  Unless this is called from the _ttmaint.w procedure, remove the
    temp-db record because it is used for defining 
    temp-tables not for selecting from them                         */
IF p_TT NE "_ttmaint.w" THEN DO:
  FIND s_ttb_db WHERE s_ttb_db.ldbnm = "TEMP-DB":U NO-ERROR.
  IF AVAILABLE s_ttb_db THEN DELETE s_ttb_db.
END.
ELSE DO:
  /* If it is being called from _ttmaint.w don't let the user use an
     actual database named "TEMP-TABLES".   */
  FIND s_ttb_db WHERE s_ttb_db.ldbnm = "TEMP-TABLES":U NO-ERROR.
  IF AVAILABLE s_ttb_db THEN DO:
    MESSAGE 'You have a database with a logical name of "TEMP-TABLES".' SKIP
            'Since "TEMP-TABLES" is reserved as the logical name of' SKIP
            'the virtual database containing temp-tables, it will be' SKIP
            'ignored as a source of temp-table definitions.  To use' SKIP
            'the tables in this database as temp-table definitions,' SKIP
            'disconnect and reconnect giving the database the logical' SKIP
            'name "TEMP-DB".' VIEW-AS ALERT-BOX WARNING.
    DELETE s_ttb_db.
  END.
END.

/* If there are temp-tables defined then let the user choose from them 
   unless this is being called from _ttmaint.w                        */
IF p_TT NE ? AND p_TT NE "_ttmaint.w" THEN DO:
  /* Create psuedo db for temp-table definitions */
  CREATE s_ttb_db.
  ASSIGN s_ttb_db.ldbnm = "Temp-Tables":U
         s_ttb_db.sdbnm = s_ttb_db.ldbnm
         s_ttb_db.dbnr  = 99999
         s_ttb_db.empty = FALSE.
END.

FIND s_ttb_db WHERE s_ttb_db.ldbnm = p_DBName NO-ERROR.
IF NOT AVAILABLE s_ttb_db OR s_ttb_db.empty THEN
  FIND FIRST s_ttb_db WHERE NOT s_ttb_db.empty NO-ERROR.
IF AVAILABLE s_ttb_db THEN repos = RECID(s_ttb_db).     
ELSE DO:
  MESSAGE "No connected database has any tables." VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

OPEN QUERY db-browse FOR EACH s_ttb_db WHERE NOT s_ttb_db.empty.
t_log = db-browse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":U).

/* Reposition to the database "Temp-Table", if any. This addresses the
   situation in which the user is connected to a physical database and has 
   defined a database "temp-table" and wants to see the temp-table tables 
   first.  See "Create psuedo db for temp-table definitions" above.
   (bug 98-11-30-056) */
IF repos NE ? THEN DO:
  FIND s_ttb_db WHERE s_ttb_db.ldbnm = p_DBName NO-ERROR.
  IF NOT AVAILABLE s_ttb_db OR s_ttb_db.empty THEN
    FIND FIRST s_ttb_db WHERE NOT s_ttb_db.empty NO-ERROR.
END.
  
/* Open table browse */
RUN load_tables (INPUT p_TblNames).

ENABLE db-browse
       b_ok
       b_cancel
       b_Help
  with frame schemapk.

FRAME schemapk:HIDDEN = FALSE.
&scoped-define CANCEL-EVENT U2
{adeuib/ide/dialogstart.i b_ok b_cancel wintitle}
/* Select initial db */
IF repos NE ? THEN REPOSITION db-browse TO RECID repos.
ELSE t_log = db-browse:SELECT-ROW(1).

DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR CHOOSE OF b_ok IN FRAME schemapk 
              OR GO OF FRAME schemapk.
    &ELSE
        WAIT-FOR "choose" of b_ok in frame schemapk 
              or "u2" of this-procedure
              or GO OF FRAME schemapk.       
        if cancelDialog THEN UNDO, LEAVE.  
    &endif
   
END.

HIDE FRAME schemapk.
IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
RETURN.
 
/**********************************************************************/
/*                      Internal Procedures                           */
/**********************************************************************/

PROCEDURE load_tables:
 /* ------------------------------------------------------------
    RUN load_tables.
    
    Populate shared browse tbl-browse based on fields from the db pointed
    to by repos.  Initially select the tables based on the valueof ivalue,
    or if ivalue is "" then pick the first table in tbl-browse for single 
    select lists and no table for multiselect lists.
    ------------------------------------------------------------ */
  DEFINE INPUT PARAMETER ivalue  AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE cur-ent AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE r-table AS CHARACTER                           NO-UNDO.

  IF s_ttb_db.sdbnm NE "Temp-Tables":U THEN DO:
    IF LDBNAME("DICTDB":U) NE s_ttb_db.sdbnm THEN
      CREATE ALIAS DICTDB FOR DATABASE VALUE(s_ttb_db.sdbnm).
    
    RUN adecomm/_getdbid.p (INPUT s_ttb_db.ldbnm, OUTPUT v_DBID).

    /* if we could not find the id, we got a problem */
    IF v_DBID = ? THEN DO:
      t_log = FALSE.
      run adecomm/_s-alert.p
        (input-output t_log, "i", "ok",
        SUBSTITUTE("Database &1 was not found.", s_ttb_db.ldbnm)).
      IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
      RETURN.  /* no read permission on fields */
    END.

    /* Everything is in order, open the shared query for tbl-browse */
    RUN adecomm/_tblbrws.p PERSISTENT SET new-proc
           (INPUT FRAME schemapk:HANDLE,
            INPUT THIS-PROCEDURE,
            INPUT p_multi,
            INPUT db-browse:ROW,
            INPUT tbl-col,
            INPUT v_DBId,
            INPUT "BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE":U,
            INPUT ivalue,
            OUTPUT h_tbl_brws,
           OUTPUT v_access).
  END.  /* If not a picking from a temp-table */
  ELSE DO:
     /* User wants to select from defined temp tables.  Build temp table
        definitions needed to simulate tables and fields.               */
     
     /* First see if we have already built the temp-table info          */
     IF NOT CAN-FIND(FIRST _tt-tbl) THEN DO:
       DO i = 1 TO NUM-ENTRIES(p_TT):
         CREATE _tt-tbl.
         ASSIGN cur-ent         = ENTRY(i, p_TT)
                _tt-tbl.tt-name = ENTRY(2, cur-ent, "|":U)
                r-table         = ENTRY(2, ENTRY(1, cur-ent, "|":U), ".":U).
         IF _tt-tbl.tt-name = "?":U THEN _tt-tbl.tt-name = r-table.
         CREATE ALIAS "DICTDB":U FOR
                DATABASE VALUE(SDBNAME(ENTRY(1, cur-ent, ".":U))).
         /* Build the field records for this table */       
         RUN adecomm/_bldfld.w (INPUT RECID(_tt-tbl), INPUT r-table).
       END. /* Do i = 1 to num-entries(p_TT) */
     END.  /* If we haven't already built these records */

     /* The table and field tt records are made, browse them */ 
     RUN adecomm/_ttblbrs.p PERSISTENT SET new-proc
           (INPUT FRAME schemapk:HANDLE,
            INPUT THIS-PROCEDURE,
            INPUT p_multi,
            INPUT db-browse:ROW,
            INPUT tbl-col,
            INPUT v_DBId,
            INPUT ivalue,
            OUTPUT h_tbl_brws,
            OUTPUT v_access).
  END. /* Else picking from a temp-table */
          
  IF NOT v_access THEN DO:
    IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
    IF VALID-HANDLE(new-proc) THEN DELETE PROCEDURE new-proc.
    RETURN.  /* No read permission on fields */
  END.
  IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
  old-proc = new-proc.
END.
