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
/*----------------------------------------------------------------------------

File: _fldsel.p

Description:
  Allows a user to select a database, a table, then a list of fields in that
  table.  The database is defaulted to whatever dictdb is pointing to at the
  time.

INPUT Parameters
p_Multi    - Should they be allowed to select multiple items.
p_DType    - The data type to screen for.  If this is ?, then don't screen.
                    Otherwise this must be either
                     "character"
                     "date"
                     "decimal"
                     "integer"
                     "logical"
                     "recid"
p_TT       - ? if temp-tables need to be included
             Otherwise a comma delitted list where each entry has the form:
             _like-db._like-table|_name
             The _like-db and _like-table are real database.table combinations
             and _name is either the name of the temp-table that is like
             _like-table or ? if it is the same.

INPUT-OUTPUT Parameters
p_Prefix   - Determines prefix options on output strings
                     ? - Don't show option
                     0 - none
                     1 - table
                     2 - database[.table]
p_DBName   - The name of the database the schema was picked from.  May
              may optionally be passed in to default the database.
p_TblName  - The name of the table selection.  Optional to pass in default.
p_FldNames - A comma list of selected fields.  Optional to pass in default.

OUTPUT Parameters
p_OK       - Did they press OK to get out?

Author: Ross Hunter

Date Created: 08/10/95 

Modification History:

----------------------------------------------------------------------------*/
/*Copyright (c) by PROGRESS SOFTWARE CORPORATION. 1992 - AllRights Reserved.*/

/* ADE Standards Include */
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{adecomm/getdbs.i &NEW="NEW"}
{af/sup/tt-brws.i "NEW"}

&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
   &global-define TCOL        22
   &global-define FCOL        44
   &global-define BCOL  66
&ELSE /* Windows or TTY */
   &global-define TCOL        20
   &global-define FCOL        40
   &global-define BCOL  61
&ENDIF

IF NOT initialized_adestds
   THEN RUN adecomm/_adeload.p.

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT        PARAMETER p_Multi    AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER p_DType    AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_TT       AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_Prefix   AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_DBName   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_TblName  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_FldName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER p_OK       AS LOGICAL   NO-UNDO INITIAL FALSE.

DEFINE VARIABLE h_fld_brws  AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_tbl_brws  AS HANDLE    NO-UNDO.
DEFINE VARIABLE new-proc    AS HANDLE    NO-UNDO.
DEFINE VARIABLE old-proc    AS HANDLE    NO-UNDO.
DEFINE VARIABLE v_TblID     AS RECID     NO-UNDO.
DEFINE VARIABLE v_access    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v_OldDictDb AS CHARACTER NO-UNDO INITIAL ?.  /* saved name of dictdb */
DEFINE VARIABLE repos       AS RECID     NO-UNDO INITIAL ?.
DEFINE VARIABLE tbl-col     AS DECIMAL   NO-UNDO INITIAL {&TCOL}.
DEFINE VARIABLE v_PfixLbl   AS CHARACTER NO-UNDO INITIAL "Prefix:". 
DEFINE VARIABLE v_Type      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE t_int       AS INTEGER   NO-UNDO.
DEFINE VARIABLE t_log       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE t_char      AS CHARACTER NO-UNDO.

DEFINE BUTTON b_ok       label "OK"       {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_cancel   label "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON b_Help     label "&Help"    {&STDPH_OKBTN}.
DEFINE BUTTON b_all_flds label "&Select All"    SIZE 15.00 BY 1.125.
DEFINE BUTTON b_no_flds  label "&Deselect All"  SIZE 15.00 BY 1.125.

DEFINE QUERY  db-browse FOR s_ttb_db.
DEFINE BROWSE db-browse QUERY db-browse NO-LOCK
       DISPLAY s_ttb_db.ldbnm FORMAT "X(40)"
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SIZE 16.5 BY 6.9 NO-LABELS.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FS_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM 
  SKIP( {&TFM_WID} )
  "Databases:"  AT 2        VIEW-AS TEXT
  "Tables:"     AT {&TCOL}  VIEW-AS TEXT
  "Fields:"     AT {&FCOL}  VIEW-AS TEXT 
  v_Type FORMAT "x(12)"     VIEW-AS TEXT NO-LABEL
  SKIP( {&VM_WID} )

  db-browse     AT 2
  SKIP( {&VM_WIDG} )

  p_Prefix      AT 2
                LABEL "&Prefix"
                             view-as radio-set horizontal SIZE 42 BY 1.1
                             radio-buttons "None",0,"Table",1,"Database.Table",2
  { adecomm/okform.i
        &BOX    ="FS_Btn_Box"
        &OK     ="b_OK"
        &CANCEL ="b_Cancel"
        &HELP   ="b_Help" 
  }

  b_all_flds    AT ROW-OF db-browse COL {&BCOL}
  SKIP( {&VM_WID} )

  b_no_flds     AT {&BCOL}

  with frame schemapk 
       side-labels title "Field Selector" 
       &IF "{&WINDOW-SYSTEM}" = "OSF/Motif":u &THEN WIDTH 81 &ENDIF
       view-as dialog-box
               DEFAULT-BUTTON b_OK
               CANCEL-BUTTON  b_Cancel.

ASSIGN FRAME schemapk:HIDDEN = TRUE
       FRAME schemapk:PARENT = active-window NO-ERROR.

/*-------------------------------Triggers------------------------------------*/

/*----- HELP -----*/
ON HELP OF FRAME schemapk OR CHOOSE of b_Help IN FRAME schemapk
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
                                               INPUT {&Field_Selection},
                                               INPUT ?).

/*-----WINDOW-CLOSE-----*/
ON WINDOW-CLOSE OF FRAME schemapk DO:
  APPLY "END-ERROR":U TO SELF.
END.

/*----- SELECTION of OK BUTTON or GO -----*/
ON GO OF FRAME schemapk DO:
  RUN load-private-data IN old-proc.

  DEFINE VARIABLE db   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tbl  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE flds AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fld  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cIdx  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iIdx  as integer no-undo.
  DEFINE VARIABLE prfx AS CHARACTER NO-UNDO.

  IF p_Prefix <> ? THEN p_Prefix = INPUT FRAME schemapk p_Prefix.

  ASSIGN db        = s_ttb_db.ldbnm
         tbl       = h_tbl_brws:PRIVATE-DATA
         flds      = h_fld_brws:PRIVATE-DATA
         p_ok      = TRUE
         p_DBName  = db
         p_TblName = IF p_Prefix = 2 THEN db + "." + tbl
                                     ELSE tbl
         p_FldName = ""
         prfx      = (IF p_Prefix = 0 THEN ""              ELSE
                      IF p_Prefix = 1 THEN tbl + "."       ELSE
                      IF p_Prefix = 2 THEN p_TblName + "." ELSE
                        /* NEVER HAPPENS */  "").

  DO t_int = 1 TO NUM-ENTRIES(flds):
    ASSIGN fld = prfx + ENTRY(t_int,flds)
           p_FldName = IF t_int = 1 THEN fld
                       ELSE (p_FldName + ",":U + fld).

    IF fld MATCHES ("*[*]*":u) THEN DO:
      ASSIGN
         fld  = TRIM(Fld)
         cIdx = SUBSTRING(Fld,INDEX(Fld,'[':u)   + 1,-1,"CHARACTER":u)
         cIdx = SUBSTRING(cIdx,INDEX(cIdx,'-':u) + 1,-1,"CHARACTER":u)
         cIdx = REPLACE(cIdx,"]":u,"")
         Fld  = SUBSTRING(Fld,1,INDEX(Fld,'[':u) - 1,"CHARACTER":u).

      IF (NOT p_Multi) THEN DO:
        RUN adecomm/_selindx.p (CAPS(fld), INTEGER (cIdx), OUTPUT iIdx).
        IF iIdx = 0 THEN RETURN NO-APPLY.
        ASSIGN ENTRY (t_int, p_FldName) = Fld + '[' + STRING (iIdx) + ']'.
      END.  /* Only one element */
      ELSE
      DO iIdx = 1 TO INTEGER (cIdx):
        IF iIdx = 1 THEN
            ASSIGN ENTRY (NUM-ENTRIES(p_FldName) , p_FldName) =
                        Fld + '[' + STRING (iIdx) + ']'.
        ELSE
            ASSIGN p_FldName =
                        p_FldName + ',' + Fld + '[' + STRING (iIdx) + ']'.
      END.  /* Expand the entire array */
    END.  /* If an array */
  END.  /* DO t_int 1 to NUM-ENTRIES */
END.  /* ON GO OF FRAME schemapk */


/*----- DEFAULT-ACTION of fld_browse -------*/
PROCEDURE field-browse-def-act.
  APPLY "GO" TO FRAME schemapk.
END.

/*----- SELECT ALL FIELDS BUTTON -----*/
ON CHOOSE OF b_all_flds IN FRAME schemapk RUN select-all IN old-proc.


/*----- DE-SELECT ALL FIELDS BUTTON -----*/
ON CHOOSE OF b_no_flds IN FRAME schemapk DO:
  t_log = h_fld_brws:DESELECT-ROWS().
END.


/*----- VALUE-CHANGED of DB LIST -----*/
ON VALUE-CHANGED OF db-browse IN FRAME schemapk DO:
  RUN load_tables (INPUT "":U).
END.

/*----- VALUE-CHANGED of TBL LIST ----- */    /*
on value-changed of v_PickTbl in frame schemapk do:
  IF /* v_PickDB:screen-value in frame schemapk = ? OR DRH */
     v_PickTbl:screen-value in frame schemapk = ? THEN DO:
    IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
    RETURN.
  END.

  /* get the id of the table they picked */
  v_TblID = ?.
  run adecomm/_gttblid.p (s_ttb_db.dbrcd,v_PickTbl:screen-value,OUTPUT v_TblID).

  /* if we could not find the id, we got a problem */
  if v_TblID = ? then do:
    RUN adecomm/_s-alert.p (input-output t_log,"information":u,"ok":u,
      SUBSTITUTE("Table &1 was not found.", INPUT v_PickTbl:screen-value)).
    RETURN NO-APPLY.  /* no read permission on fields */
  END.

  v_PickFld:list-items in frame schemapk = "".  /* clear the list first */
  RUN adecomm/_fldlist.p (v_PickFld:HANDLE in frame schemapk, v_TblID,
      Yes, "", p_DType, Yes, "", OUTPUT  v_access).
  IF NOT v_access then return NO-APPLY.  /* no read permission on fields */

  /*
  ** Try to set the default fields in this table.  t_char is the list
  ** of default items that appear in the list.
  */
  t_char = "".
  do t_int = 1 to num-entries(p_FldName):
    IF CAN-DO(v_PickFld:LIST-ITEMS,ENTRY(t_int,p_FldName)) THEN DO:
      t_char = t_char + ENTRY(t_int,p_FldName) + ",":u.
      if not p_Multi THEN leave. /* only add one if it is not a multi select */
    END.
  end.
  IF LENGTH(t_char,"CHARACTER":u) > 1 THEN
    ASSIGN
      SUBSTRING(t_char,LENGTH(t_char,"CHARACTER":u),1,"CHARACTER":u) = ""
      v_PickFld:SCREEN-VALUE = t_char.
  else
    /* just set selection to first field if there is one and if the user
       is NOT in multiselect mode (otherwise they will have to deselect
       that one). */
    if (v_PickFld:NUM-ITEMS > 0 AND v_PickFld:MULTIPLE eq no )
    then v_PickFld:screen-value = v_PickFld:ENTRY(1).
    else v_PickFld:screen-value = ?.
end.  */

/*----- DEFAULT-ACTION of FIELD LIST -----*/     /*
ON DEFAULT-ACTION OF v_PickFld DO:
   APPLY "GO" TO FRAME schemapk.
END.                                               */


/*----------------------------Mainline code----------------------------------*/

/* save the pointer to the current dictdb */
if connected("dictdb") then
v_olddictdb = ldbname("dictdb").

/* Make sure there is at least one database connected. */
IF NUM-DBS = 0 THEN
DO:
  ASSIGN t_log = NO.
  RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to select fields.",
      OUTPUT t_log).
  IF t_log <> TRUE THEN RETURN.
END.

ASSIGN b_all_flds:hidden in frame schemapk = NOT p_Multi
       b_no_flds:hidden in frame schemapk  = NOT p_Multi.


IF NOT p_Multi THEN DO:
  IF p_DType = ? THEN
    ASSIGN v_type:WIDTH = 1
           FRAME schemapk:WIDTH = FRAME schemapk:WIDTH - b_all_flds:WIDTH - 2.
  ELSE FRAME schemapk:WIDTH = v_type:COLUMN + v_type:WIDTH + 1.
END.

{ adecomm/okrun.i
    &FRAME  = "FRAME schemapk"
    &BOX    = "FS_Btn_Box"
    &OK     = "b_OK"
    &CANCEL = "b_Cancel"
    &HELP   = "b_Help"
}

/* Don't show prefix choice if ? */
IF p_Prefix = ? THEN p_Prefix:HIDDEN IN FRAME schemapk = TRUE.
                ELSE DISPLAY p_Prefix WITH FRAME schemapk.

/* Fill up the database selection list */
RUN adecomm/_getdbs.p.

/* Remove the TEMP-DB entry because it is only for creating temp-table
   Definitions */
FIND s_ttb_db WHERE s_ttb_db.ldbnm = "TEMP-DB":U NO-ERROR.
IF AVAILABLE s_ttb_db THEN DELETE s_ttb_db.

IF p_TT NE ? THEN DO:  /* Create psuedo db for temp-table definitions */
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
  /* It appears that no database has any tables.  This could be because
     the wrong database is currently dictdb.  Let make one attempt to fix
     this before giving up.                                              */
  db-search:
  REPEAT i = 1 TO NUM-DBS:
    IF LDBNAME("DICTDB") = LDBNAME(i) THEN LEAVE db-search.
    ELSE IF DBTYPE(i) <> "PROGRESS" THEN NEXT db-search.
    ELSE DO:  /* This is a possibility - make it  DICTDB and redo _getdbs */
       FOR EACH s_ttb_db WHERE s_ttb_db.ldbnm NE "Temp-Tables":U:
         DELETE s_ttb_db.
       END.  /* Delete loop */
       CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(i)).
       RUN adecomm/_getdbs.p.
       LEAVE db-search.
    END.  /* Else a possibility */
  END.  /* db-search: Repeat loop */
  FIND FIRST s_ttb_db WHERE NOT s_ttb_db.empty NO-ERROR.
  IF AVAILABLE s_ttb_db THEN repos = RECID(s_ttb_db).
  ELSE DO:  /* Give up */
    MESSAGE "No connected database has any tables." VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.  /* Else give up */
END.  /* Else try again */

OPEN QUERY db-browse FOR EACH s_ttb_db WHERE NOT s_ttb_db.empty.
t_log = db-browse:SET-REPOSITIONED-ROW(1,"CONDITIONAL":U).

/* Open table browse */
RUN load_tables (INPUT p_TblName).

/* show data type over field list if we're screening by data type */
v_Type = (if p_DType = ? then "" else "(" + p_DType + ")").
DISPLAY v_Type WITH FRAME schemapk.
FRAME schemapk:HIDDEN = FALSE.

ENABLE
  db-browse
  b_all_flds   when p_Multi
  b_no_flds    when p_Multi
  p_Prefix     when p_Prefix <> ?
  b_ok
  b_cancel 
  b_Help       {&WHEN_HELP}
  WITH FRAME schemapk.

/* See if we can select the default database */
IF repos NE ? THEN REPOSITION db-browse TO RECID repos.
ELSE t_log = db-browse:SELECT-ROW(1).


DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   WAIT-FOR CHOOSE OF b_ok IN FRAME schemapk OR
                  GO OF FRAME schemapk.
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

    /* if we could not find the id, we got a problem */
    IF s_ttb_db.dbrcd = ? THEN DO:
      t_log = FALSE.
      run adecomm/_s-alert.p
        (input-output t_log, "i", "ok",
        SUBSTITUTE("Database &1 was not found.", s_ttb_db.ldbnm)).
      IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
      RETURN.  /* no read permission on fields */
    END.

    /* Everything is in order, open the shared query for tbl-browse */
    RUN adecomm/_tfbrws.p PERSISTENT SET new-proc
           (INPUT FRAME schemapk:HANDLE,
            INPUT THIS-PROCEDURE,
            INPUT p_multi,
            INPUT db-browse:ROW,
            INPUT tbl-col,
            INPUT s_ttb_db.dbrcd,
            INPUT "BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE":U,
            INPUT ivalue,
            INPUT  p_DType,
            OUTPUT h_tbl_brws,
            OUTPUT h_fld_brws,
            OUTPUT v_access).
  END.  /* IF NOT TEMP-TABLES */
  ELSE DO:  /* Attempting to select from the temptables */
    /* User wants to select from defined temp tables.  Build temp table
       definitions needed to simulate tables and fields.               */

    /* First see if we have already built the temp-table info          */
    IF NOT CAN-FIND(FIRST tt-tbl) THEN DO:
      DO i = 1 TO NUM-ENTRIES(p_TT):
        CREATE tt-tbl.
        ASSIGN cur-ent         = ENTRY(i, p_TT)
               tt-tbl.tt-name = ENTRY(2, cur-ent, "|":U)
               r-table         = ENTRY(2, ENTRY(1, cur-ent, "|":U), ".":U).
        IF tt-tbl.tt-name = "?":U THEN tt-tbl.tt-name = r-table.
        CREATE ALIAS "DICTDB":U FOR
               DATABASE VALUE(SDBNAME(ENTRY(1, cur-ent, ".":U))).
        /* Build the field records for this table */       
        RUN adecomm/_bldfld.w (INPUT RECID(tt-tbl), INPUT r-table).
      END. /* Do i = 1 to num-entries(p_TT) */
    END.  /* If we haven't already built these records */

    /* The table and field tt records are made, browse them */ 
    RUN adecomm/_ttfbrws.p PERSISTENT SET new-proc
           (INPUT FRAME schemapk:HANDLE,
            INPUT THIS-PROCEDURE,
            INPUT p_multi,
            INPUT db-browse:ROW,
            INPUT tbl-col,
            INPUT s_ttb_db.dbrcd,
            INPUT ivalue,
            INPUT  p_DType,
            OUTPUT h_tbl_brws,
            OUTPUT h_fld_brws,
            OUTPUT v_access).
  END.  /* If selecting from temptables */

  IF NOT v_access THEN DO:
    IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
    IF VALID-HANDLE(new-proc) THEN DELETE PROCEDURE new-proc.
    RETURN.  /* No read permission on fields */
  END.
  IF VALID-HANDLE(old-proc) THEN DELETE PROCEDURE old-proc.
  old-proc = new-proc.
END.

