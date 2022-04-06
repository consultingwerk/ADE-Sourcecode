/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: tblbrws.i

Description:
   Browse the tables for a given database. This .i is included in both
   _tblbrws.p and _tfbrws.p  The only reason is that browses can't be
   resized at run time.

Arguments:
   &HGHT       - Height of the browse
   &WDTH       - Width of the browse
   &FLDS       - "YES" if selecting fields, "NO" if just tables.  {&FLDS} is
                 used to turn on/off gobs of code at compile time.
   
Input Parameters: (for the calling programs)
   p_dlg       - Frame handle needed to parent the frame created in this 
                 procedure.
   parent-proc - Handle of the calling dialog so that we can run its
                 internal procedures (methods).
   p_multi     - Logical: True if multiple items can be returned.
   p_rw        - The row of the browse within its parent (p_dlg).
   p_tc        - The column of the brwose within its parent (p_dlg).
   p_DbId      - The recid of the _Db record which corresponds to the
                 database that we want the tables from.
   p_Filters   - Comma delimited character string with with things (like
                 Sybase Buffers) that should be filtered out.
   in-value    - Comma delimited list of tables to select initially
   p_DType     - ? if not a specific Datatype
             
Output Parameters:
   h_tbl_brws - Handle of table browse created in this routine.
   h_fld_brws - Handle of field browse created in this routine. (Turned on by
                 the {&FLDS} preprocessor.
   p_Stat     - Set to true if list is retrieved (even if there were no tables
      	         this is successful).  Set to false, if user doesn't have access
      	         to tables.

Author: Ross Hunter

Date Created: 08/08/95 

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_dlg       AS HANDLE          NO-UNDO.
DEFINE INPUT  PARAMETER parent_proc AS HANDLE          NO-UNDO.
DEFINE INPUT  PARAMETER p_multi     AS LOGICAL         NO-UNDO.
DEFINE INPUT  PARAMETER p_rw        AS DECIMAL         NO-UNDO.
DEFINE INPUT  PARAMETER p_tc        AS DECIMAL         NO-UNDO.
DEFINE INPUT  PARAMETER p_DbId      AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_filters   AS CHARACTER       NO-UNDO.
DEFINE INPUT  PARAMETER in-value    AS CHARACTER       NO-UNDO.

/* ----------------------------------------------------------------- */
/*                        FOR FIELDS ONLY                            */
/* ----------------------------------------------------------------- */
&IF "{&FLDS}" = "YES" &THEN
DEFINE INPUT  PARAMETER p_DType     AS CHARACTER       NO-UNDO.
&ENDIF            /* End of fields only input parameter definitions  */

DEFINE OUTPUT PARAMETER h_tbl_brws  AS HANDLE          NO-UNDO.

/* ----------------------------------------------------------------- */
/*                        FOR FIELDS ONLY                            */
/* ----------------------------------------------------------------- */
/* just for syntax check ... */
&if "{&wdth)}" = "" and "{&hght}" = "" &then
  &scop hght 10
  &scop wdth  50
&endif    

&IF "{&FLDS}" = "YES" &THEN
DEFINE OUTPUT PARAMETER h_fld_brws  AS HANDLE          NO-UNDO.
&ENDIF           /* End of fields only output parameter definitions  */

DEFINE OUTPUT PARAMETER p_Stat 	    AS LOGICAL         NO-UNDO.


DEFINE QUERY  tbl-browse-m FOR DICTDB._FILE SCROLLING.
DEFINE BROWSE tbl-browse-m QUERY tbl-browse-m NO-LOCK
       DISPLAY DICTDB._FILE._FILE-NAME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING MULTIPLE
         SIZE {&WDTH} BY {&HGHT} NO-LABELS.
DEFINE QUERY  tbl-browse-s FOR DICTDB._FILE SCROLLING.
DEFINE BROWSE tbl-browse-s QUERY tbl-browse-s NO-LOCK
       DISPLAY DICTDB._FILE._FILE-NAME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SINGLE
         SIZE {&WDTH} BY {&HGHT} NO-LABELS.

DEFINE VARIABLE cur-rec    AS RECID     NO-UNDO.
DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
DEFINE VARIABLE multi-tbl  AS LOGICAL   NO-UNDO.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
  FIND DICTDB._File WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                 DICTDB._FILE._FILE-NAME = "_File":u NO-LOCK.
ELSE
  FIND DICTDB._FILE WHERE DICTDB._FILE._FILE-NAME = "_File":U NO-LOCK.

IF NOT CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":u)) THEN DO:
  MESSAGE "You do not have permission to see any table information."
    VIEW-AS ALERT-BOX ERROR buttons OK.
  p_Stat = FALSE.
  RETURN.
END.                                            

DEFINE FRAME frm-m
  tbl-browse-m
  WITH 1 DOWN NO-BOX OVERLAY THREE-D AT ROW 2 COLUMN 17.

DEFINE FRAME frm-s
  tbl-browse-s
  WITH 1 DOWN NO-BOX OVERLAY THREE-D AT ROW 2 COLUMN 17.

multi-tbl = p_multi.
IF "{&FLDS}" = "YES" THEN multi-tbl = FALSE.

IF multi-tbl THEN  
  ASSIGN FRAME frm-m:FRAME  = p_dlg
         FRAME frm-m:ROW    = p_rw
         FRAME frm-m:COLUMN = p_tc
         p_Stat             = FRAME frm-m:MOVE-TO-TOP()
         FRAME frm-m:HIDDEN = NO
         h_tbl_brws         = tbl-browse-m:HANDLE.
ELSE
  ASSIGN FRAME frm-s:FRAME  = p_dlg
         FRAME frm-s:ROW    = p_rw
         FRAME frm-s:COLUMN = p_tc
         p_Stat             = FRAME frm-s:MOVE-TO-TOP()
         FRAME frm-s:HIDDEN = NO
         h_tbl_brws         = tbl-browse-s:HANDLE.

/* ----------------------------------------------------------------- */
/*                        FOR TABLES ONLY                            */
/* ----------------------------------------------------------------- */
&IF "{&FLDS}" = "NO" &THEN
ON DEFAULT-ACTION OF tbl-browse-m OR DEFAULT-ACTION OF tbl-browse-s DO:
  RUN table-browse-def-act IN parent_proc.
END.
&ENDIF                             /* End of For tables only trigger */

/* Find each file in this database.  Remember, if the progress Db is 
   acting as a schema holder, files for more than one database may 
   exist in this one physical database.  */
RUN adecomm/_setcurs.p ("WAIT":u).

FIND DICTDB._DB WHERE RECID(DICTDB._DB) = p_DBID NO-LOCK.
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  IF multi-tbl THEN 
    OPEN QUERY tbl-browse-m FOR EACH DICTDB._FILE NO-LOCK 
       WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
             CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":U)) AND
             NOT DICTDB._FILE._HIDDEN AND
             (DICTDB._FILE._FOR-TYPE = ? OR
              NOT CAN-DO(p_filters,DICTDB._File._FOR-TYPE)) BY DICTDB._File._FILE-NAME.
  ELSE
    OPEN QUERY tbl-browse-s FOR EACH DICTDB._FILE NO-LOCK 
       WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
             CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":U)) AND
             NOT DICTDB._FILE._HIDDEN AND
             (DICTDB._FILE._FOR-TYPE = ? OR
              NOT CAN-DO(p_filters,DICTDB._File._FOR-TYPE)) BY DICTDB._File._FILE-NAME.
END.  /* If DB > 8 */
ELSE DO:
  IF multi-tbl THEN 
    OPEN QUERY tbl-browse-m FOR EACH DICTDB._FILE NO-LOCK 
       WHERE CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":U)) AND
             NOT DICTDB._FILE._HIDDEN AND
             (DICTDB._FILE._FOR-TYPE = ? OR
              NOT CAN-DO(p_filters,_File._FOR-TYPE)) BY DICTDB._File._FILE-NAME.
  ELSE
    OPEN QUERY tbl-browse-s FOR EACH DICTDB._FILE NO-LOCK 
       WHERE CAN-DO(DICTDB._File._Can-Read, USERID("DICTDB":U)) AND
             NOT DICTDB._FILE._HIDDEN AND
             (DICTDB._File._FOR-TYPE = ? OR
              NOT CAN-DO(p_filters,DICTDB._File._FOR-TYPE)) BY DICTDB._File._FILE-NAME.

END.

IF NUM-ENTRIES(in-value) > 0 THEN DO:  /* SELECT these tables in the browse */
  DO i = 1 TO NUM-ENTRIES(in-value):
    IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
      FIND DICTDB._FILE NO-LOCK
               WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                     CAN-DO(DICTDB._FILE._Can-Read, USERID("DICTDB":U)) AND
                            NOT DICTDB._FILE._HIDDEN AND
                            (DICTDB._FILE._FOR-TYPE = ? OR
                             NOT CAN-DO(p_filters,_File._FOR-TYPE)) AND
                             DICTDB._FILE._FILE-NAME = ENTRY(i,in-value) NO-ERROR.
    ELSE
      FIND DICTDB._FILE NO-LOCK
               WHERE CAN-DO(DICTDB._FILE._Can-Read, USERID("DICTDB":U)) AND
                            NOT DICTDB._FILE._HIDDEN AND
                            (DICTDB._FILE._FOR-TYPE = ? OR
                             NOT CAN-DO(p_filters,_File._FOR-TYPE)) AND
                             DICTDB._FILE._FILE-NAME = ENTRY(i,in-value) NO-ERROR.
    IF AVAILABLE DICTDB._FILE THEN DO:
      cur-rec = RECID(DICTDB._FILE).
      IF multi-tbl THEN REPOSITION tbl-browse-m TO RECID cur-rec.
      ELSE REPOSITION tbl-browse-s TO RECID cur-rec.
      p_Stat = h_tbl_brws:SELECT-FOCUSED-ROW().
    END.
  END.
  /* Now reposition to the first one */
  ASSIGN p_Stat  = h_tbl_brws:SET-REPOSITIONED-ROW(1,"CONDITIONAL").
  /* Sometimes with multiple db's the wrong DB is selected */
  IF h_tbl_brws:NUM-SELECTED-ROWS > 0 THEN DO:
    ASSIGN p_Stat  = h_tbl_brws:FETCH-SELECTED-ROW(1)
           cur-rec = RECID(DICTDB._FILE).
    IF multi-tbl THEN REPOSITION tbl-browse-m TO RECID cur-rec.
    ELSE REPOSITION tbl-browse-s TO RECID cur-rec.
  END. /* If there are any selected rows. */
END.           

RUN adecomm/_setcurs.p ("").
IF multi-tbl THEN ENABLE tbl-browse-m WITH FRAME frm-m.
ELSE ENABLE tbl-browse-s WITH FRAME frm-s.


/* ----------------------------------------------------------------- */
/*                        FOR FIELDS ONLY                            */
/* ----------------------------------------------------------------- */ 

&IF "{&FLDS}" = "YES" &THEN          /* A fields browse is necessary */

DEFINE TEMP-TABLE tbl-fld NO-UNDO
  FIELD fld-nm AS CHARACTER FORMAT "X(40)"
  INDEX fld-nm IS PRIMARY UNIQUE fld-nm.
  
DEFINE QUERY  fld-browse-m FOR tbl-fld SCROLLING.
DEFINE BROWSE fld-browse-m QUERY fld-browse-m
       DISPLAY tbl-fld.fld-nm
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING MULTIPLE
         SIZE {&WDTH} BY {&HGHT} NO-LABELS.
DEFINE QUERY  fld-browse-s FOR tbl-fld SCROLLING.
DEFINE BROWSE fld-browse-s QUERY fld-browse-s
       DISPLAY tbl-fld.fld-nm
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SINGLE
         SIZE {&WDTH} BY {&HGHT} NO-LABELS.

DEFINE VARIABLE cur-fld    AS RECID     NO-UNDO.

DEFINE FRAME ffrm-m
  fld-browse-m
  WITH 1 DOWN NO-BOX OVERLAY THREE-D AT ROW 2 COLUMN 30.

DEFINE FRAME ffrm-s
  fld-browse-s
  WITH 1 DOWN NO-BOX OVERLAY THREE-D AT ROW 2 COLUMN 30.

IF p_multi THEN  
  ASSIGN FRAME ffrm-m:FRAME  = p_dlg
         FRAME ffrm-m:ROW    = p_rw
         FRAME ffrm-m:COLUMN = p_tc + 20
         p_Stat             = FRAME ffrm-m:MOVE-TO-TOP()
         FRAME ffrm-m:HIDDEN = NO
         h_fld_brws         = fld-browse-m:HANDLE.
ELSE
  ASSIGN FRAME ffrm-s:FRAME  = p_dlg
         FRAME ffrm-s:ROW    = p_rw
         FRAME ffrm-s:COLUMN = p_tc + 20
         p_Stat             = FRAME ffrm-s:MOVE-TO-TOP()
         FRAME ffrm-s:HIDDEN = NO
         h_fld_brws         = fld-browse-s:HANDLE.

ON DEFAULT-ACTION OF fld-browse-m OR DEFAULT-ACTION OF fld-browse-s DO:
  RUN field-browse-def-act IN parent_proc.
END.

ON VALUE-CHANGED OF tbl-browse-s DO:
  FOR EACH tbl-fld:
    DELETE tbl-fld.
  END.
  cur-rec = RECID(DICTDB._FILE).
  run open_fld_browse.
END. 

/* Find each fields of this file in this database.  Remember, if the
   progress Db is acting as a schema holder, files for more than one
   database may exist in this one physical database.  */
RUN adecomm/_setcurs.p ("WAIT":u).

IF NOT AVAILABLE DICTDB._FILE THEN DO:
  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
    IF cur-rec NE ? THEN
       FIND DICTDB._FILE NO-LOCK WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                RECID(DICTDB._FILE) = cur-rec NO-ERROR.
    IF NOT AVAILABLE DICTDB._FILE THEN
      FIND FIRST DICTDB._FILE NO-LOCK 
         WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
               CAN-DO(DICTDB._FILE._Can-Read, USERID("DICTDB":U)) AND
               NOT DICTDB._FILE._HIDDEN AND
               (DICTDB._FILE._FOR-TYPE = ? OR
                NOT CAN-DO(p_filters,_File._FOR-TYPE)).
  END.
  ELSE DO: /* DBVERSION = 8 */
    IF cur-rec NE ? THEN
       FIND DICTDB._FILE NO-LOCK WHERE RECID(DICTDB._FILE) = cur-rec NO-ERROR.
    IF NOT AVAILABLE DICTDB._FILE THEN
      FIND FIRST DICTDB._FILE NO-LOCK 
         WHERE CAN-DO(DICTDB._FILE._Can-Read, USERID("DICTDB":U)) AND
               NOT DICTDB._FILE._HIDDEN AND
               (DICTDB._FILE._FOR-TYPE = ? OR
                NOT CAN-DO(p_filters,_File._FOR-TYPE)).
  END.
END.

RUN open_fld_browse.

RUN adecomm/_setcurs.p ("").
IF p_multi THEN ENABLE fld-browse-m WITH FRAME ffrm-m.
ELSE ENABLE fld-browse-s WITH FRAME ffrm-s.

&ENDIF     /* End of Fields only setup */

p_Stat = TRUE.


PROCEDURE load-private-data:
  DEFINE VAR i AS INTEGER NO-UNDO.

  /* Load table browse */
  DO i = 1 TO h_tbl_brws:NUM-SELECTED-ROWS:
    ASSIGN p_Stat = h_tbl_brws:FETCH-SELECTED-ROW(i)
           h_tbl_brws:PRIVATE-DATA = (IF i = 1
                                      THEN DICTDB._FILE._FILE-NAME
                                      ELSE (h_tbl_brws:PRIVATE-DATA +
                                           ",":U + DICTDB._FILE._FILE-NAME)).
  END.
  
  &IF "{&FLDS}" = "YES" &THEN
    /* Load field browse */
    DO i = 1 TO h_fld_brws:NUM-SELECTED-ROWS:
      ASSIGN p_Stat = h_fld_brws:FETCH-SELECTED-ROW(i)
             h_fld_brws:PRIVATE-DATA = (IF i = 1
                                        THEN tbl-fld.fld-nm
                                        ELSE (h_fld_brws:PRIVATE-DATA +
                                             ",":U + tbl-fld.fld-nm)).
    END.
  &ENDIF
END.

/* ----------------------------------------------------------------- */
/*                        FOR FIELDS ONLY                            */
/* ----------------------------------------------------------------- */
&IF "{&FLDS}" = "YES" &THEN   /* Procedures necessary only for
                                 Field selection version       */
                                 
PROCEDURE open_fld_browse.
  IF p_DType = ? THEN DO:
    FOR EACH _FIELD OF DICTDB._FILE NO-LOCK
             WHERE CAN-DO(_Field._Can-Read, USERID("DICTDB":U)):
      CREATE tbl-fld.
      ASSIGN tbl-fld.fld-nm = _FIELD._FIELD-NAME + 
                              IF _FIELD._EXTENT > 1 THEN "[1-" + 
                                       TRIM(STRING(_FIELD._EXTENT)) + "]"
                              ELSE "".
    END.
  END. /* Select all fields */
  
  ELSE DO:
    FOR EACH _FIELD OF DICTDB._FILE NO-LOCK
             WHERE _Field._DATA-TYPE = p_DType AND
                   CAN-DO(_Field._Can-Read, USERID("DICTDB":U)):
      CREATE tbl-fld.
      ASSIGN tbl-fld.fld-nm = _FIELD._FIELD-NAME + 
                              IF _FIELD._EXTENT > 1 THEN "[1-" + 
                                       TRIM(STRING(_FIELD._EXTENT)) + "]"
                              ELSE "".
    END.
  END. /* Only select the correct data-type */
  IF p_multi THEN 
    OPEN QUERY fld-browse-m FOR EACH tbl-fld.
  ELSE
    OPEN QUERY fld-browse-s FOR EACH tbl-fld.
END.

PROCEDURE select-all:
  DEFINE VAR tmp-rec AS RECID   NO-UNDO.
  DEFINE VAR t_log   AS LOGICAL NO-UNDO.

  IF NOT p_multi THEN RETURN.  /* Safety check */
    
  h_fld_brws:REFRESHABLE = FALSE.  /* Stop any flashing */
  /* Save current position */
  cur-fld = IF AVAILABLE tbl-fld THEN RECID(tbl-fld) ELSE ? .

  /* Initialize the loop with first field */
  FIND FIRST tbl-fld NO-ERROR.
  IF AVAILABLE tbl-fld THEN tmp-rec = RECID(tbl-fld).
  ELSE tmp-rec = ?.
  
  rpt-blk:        /* Loop through records to select all */
  REPEAT ON END-KEY UNDO, LEAVE:
    IF tmp-rec ne ? THEN DO:
      REPOSITION fld-browse-m TO RECID tmp-rec.
      ASSIGN t_log = h_fld_brws:SELECT-FOCUSED-ROW().
      FIND NEXT tbl-fld NO-ERROR.
      IF AVAILABLE tbl-fld THEN tmp-rec = RECID(tbl-fld).
      ELSE tmp-rec = ?.
    END.
    ELSE LEAVE rpt-blk.
  END. /* REPEAT */

  /* Reposition back to where it was */
  IF cur-fld = ? THEN DO:
    FIND FIRST tbl-fld NO-ERROR.
    IF AVAILABLE tbl-fld THEN cur-fld = RECID(tbl-fld).
  END.
  IF cur-fld NE ? THEN REPOSITION fld-browse-m TO RECID cur-fld.

  h_fld_brws:REFRESHABLE = TRUE.
END.

&ENDIF     /* End of Field related procedures */

/* tblbrws.i - end of file */


