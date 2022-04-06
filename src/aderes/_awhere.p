/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _awhere.p
*
*    Defines the GUI and semantics for the admins' "global" WHERE
*    per table feature.
*/

&GLOBAL-DEFINE WIN95-BTN YES
&SCOPED-DEFINE FRAME-NAME whereDialog

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ adecomm/cbvar.i "NEW SHARED" }
{ adeshar/quryshar.i "NEW GLOBAL" }
{ adecomm/tt-brws.i "NEW"}
{ adeuib/brwscols.i "NEW" } /* for query builder compatibility */
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER repaint AS LOGICAL NO-UNDO.

/* for query builder compatibility */
DEFINE NEW SHARED VARIABLE _query-u-rec AS RECID NO-UNDO. 

DEFINE VARIABLE tableName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE ans            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lookAhead      AS CHARACTER NO-UNDO.
DEFINE VARIABLE currentTableId AS INTEGER   NO-UNDO.
DEFINE VARIABLE dirty          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cancelled      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE tempWhere
  FIELD tableId     AS INTEGER
  FIELD restriction AS CHARACTER
  FIELD created     AS LOGICAL
  FIELD deleted     AS LOGICAL
  .

DEFINE VARIABLE baseTableList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-LINES {&ADM_IL_LLIST} INNER-CHARS {&ADM_IC_SLIST} NO-UNDO.

DEFINE BUTTON whereBut
  LABEL "&Edit...":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE VARIABLE whereText AS CHARACTER
  VIEW-AS EDITOR SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SIZE 48 BY 5 MAX-CHARS {&ADM_LIMIT_CHARS} NO-UNDO.

{ aderes/_asbar.i }

DEFINE VARIABLE tTitle AS CHARACTER FORMAT "X({&ADM_W_SLIST})".
DEFINE VARIABLE sTitle AS CHARACTER NO-UNDO FORMAT "X({&ADM_W_SFILL})".

FORM
  SKIP({&TFM_WID})

  tTitle AT {&ADM_X_START} VIEW-AS TEXT NO-LABEL
  
  sTitle AT ROW-OF tTitle COLUMN-OF tTitle + {&ADM_H_SLIST_OFF}
    VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  baseTableList AT {&ADM_X_START} NO-LABEL

  whereText AT ROW-OF baseTableList COLUMN-OF baseTableList + {&ADM_H_SLIST_OFF}
    NO-LABEL

  whereBut AT ROW-OF baseTableList + {&ADM_R_SLIST} COLUMN-OF whereText
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  SCROLLABLE TITLE "Table Data Selection":L.

ON default-action OF baseTableList DO:
  APPLY "VALUE-CHANGED":u TO baseTableList.
  APPLY "CHOOSE":u TO whereBut.
END.

ON VALUE-CHANGED OF baseTableList IN FRAME {&FRAME-NAME} DO:
  /* Add the bloody database name back in! */
  tableName = IF NOT qbf-hidedb THEN baseTableList:SCREEN-VALUE
              ELSE ENTRY(1, qbf-dbs) + ".":u + baseTableList:SCREEN-VALUE.

  /* We have the table name, we need the id */
  {&FIND_TABLE_BY_NAME} tableName.

  currentTableId = qbf-rel-buf.tid.

  FIND FIRST tempWhere WHERE tempWhere.tableId = currentTableId
    AND tempWhere.deleted = FALSE NO-ERROR.
  whereText:SCREEN-VALUE = IF NOT AVAILABLE tempWhere THEN ""
                           ELSE tempWhere.restriction.
END.

ON CHOOSE OF whereBut IN FRAME {&FRAME-NAME} DO:
  RUN editWhere.
  APPLY "ENTRY":u TO qbf-ok.
END.

ON ALT-B OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO baseTableList IN FRAME {&FRAME-NAME}.

ON ALT-D OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO whereText     IN FRAME {&FRAME-NAME}.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF dirty = FALSE THEN RETURN.

  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Make the changes permanent */
  FOR EACH tempWhere:

    /*
     * If the created bit is on then the WHERE was newly added.  If the 
     * deleted bit is set then the WHERE was "deleted" during this editing 
     * session.  If they are both on then just ignore it.  Otherwise, just 
     * change the text.
     */
    IF (tempWhere.created = TRUE) AND (tempWhere.deleted = TRUE) THEN NEXT.

    IF tempWhere.created = TRUE THEN DO:
      CREATE _tableWhere.
      ASSIGN
        _tableWhere._tableId = tempWhere.tableId
        _tableWhere._text    = tempWhere.restriction
        .
    END.
    ELSE DO:
      FIND FIRST _tableWhere
        WHERE _tableWhere._tableId = tempWhere.tableId NO-ERROR.

      /*
      * If the WHERE clause is gone, set the text to "". That
      * will make everything right when stuff is synched up.
      * The records will be deleted later.
      */
      _tableWhere._text = IF tempWhere.deleted = TRUE THEN ""
                          ELSE tempWhere.restriction.
    END.
  END.

  /*
   * Load the current values of the admin where clause into the
   * qbf-where. qbf-where is used by code generation.
   */

  RUN synchAdminWhere.
  RUN removeEmptyWheres.

  /* Now remove the deleted table where records. */
  FOR EACH tempWhere WHERE tempWhere.deleted = TRUE:
    FIND FIRST _tableWhere 
      WHERE _tableWhere._tableId = tempWhere.tableId NO-ERROR.
    IF AVAILABLE _tableWhere THEN
      DELETE _tableWhere.
  END.

  /* Write out the changes */
  ASSIGN
    _configDirty = TRUE
    repaint      = TRUE
    .

  RUN aderes/_awrite.p (0).
  RUN adecomm/_setcurs.p ("").
END.

/*------------------------------- Main code block --------------------------- */

FRAME {&FRAME-NAME}:HIDDEN = YES.

/*
 * The edit button is at the bottom, even with the bottom of the
 * base table list
 */
whereBut:Y = (baseTableList:Y + baseTableList:HEIGHT-PIXELS)
           - whereBut:HEIGHT-PIXELS.

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Table_Restrictions_Dlg_Box} }

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

RUN initTemp.

ASSIGN
  tTitle:SCREEN-VALUE         = "&Base Table:"
  sTitle:SCREEN-VALUE         = "&Data Selection:"
  whereBut:SENSITIVE          = TRUE
  whereText:READ-ONLY         = TRUE
  baseTableList:SENSITIVE     = TRUE
  whereText:SENSITIVE         = TRUE
  .

RUN initGui.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ------------------------------------------------------------------------- */
PROCEDURE initGui:
  /* Purpose: To setup the selection list and set button states */

  ASSIGN
    lookAhead                                         = ""
    baseTableList:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
    whereText:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = ""
    .

  /* Walk the join array to get table names */
  FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:

    /* Strip the database name */
    tableName = qbf-rel-buf.tname.

    IF qbf-hidedb THEN
      tableName = SUBSTRING(tableName,INDEX(tableName,".":u) + 1,-1,
                            "CHARACTER":u).
  
    /* Add the name to table list */
    ans = baseTableList:ADD-LAST(tableName) IN FRAME {&FRAME-NAME}. 
  END.

  /* Setup the first item as the current relation */
  ASSIGN
    tableName = baseTableList:ENTRY(1) IN FRAME {&FRAME-NAME}
    baseTableList:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tableName
    .

  APPLY "VALUE-CHANGED":u TO baseTableList.
END PROCEDURE.

/* -------------------------------------------------------------------- */
PROCEDURE initTemp:
  /* Purpose: To setup the temporary data structures. */

  /* Populate the workspace */
  FOR EACH _tableWhere:

    CREATE tempWhere.
    ASSIGN
      tempWhere.tableId     = _tableWhere._tableId
      tempWhere.restriction = _tableWhere._text
      tempWhere.created     = FALSE
      tempWhere.deleted     = FALSE
      .
  END.
END PROCEDURE.

/* -------------------------------------------------------------------- */
PROCEDURE editWhere :
  DEFINE VARIABLE qbf-s       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE saveWhere   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dirtyWhere  AS LOGICAL   NO-UNDO INITIAL FALSE.
  
  /* The display of the editor can take a bit. Turn on the watch cursor. */
  RUN adecomm/_setcurs.p ("WAIT":u).

  /*
  * Set up the tables involved. Get the text version of the join type.
  * It is needed to detirmine direction of the join text.
  */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      _FldList  = ""
      _JoinCode[1] = ""
      .
  
    /*
    * Set up the vars needed by the query builder. For the building of the
    * where clause attached to a table we only need the first slot in
    * the _Where array. When we edit there is only one table that is
    * part of the list, the currentTable.
    */
  
    FIND FIRST tempWhere WHERE tempWhere.tableId = currentTableId
      AND tempWhere.deleted = FALSE NO-ERROR.
    saveWhere = IF AVAILABLE tempWhere THEN tempWhere.restriction ELSE "".
  
    ASSIGN
      _Where[1] = saveWhere
      _TblList  = baseTableList:SCREEN-VALUE
      _TblList  = REPLACE ( _TblList, ",":u, {&Sep1})
      .
    RUN alias_to_tbname  (_TblList, TRUE, OUTPUT _AliasList).

    RUN adeshar/_query.p ("",                    /* browser-name */
                          FALSE,                 /* suppress_dbname */
                          "Results_Where_Admin", /* application */
                          "Where",               /* pcValidStates */
                          NO,                    /* plVisitFields */
                          YES,                   /* auto_check */
                          OUTPUT cancelled).

    IF cancelled THEN RETURN.

    _TblList = REPLACE (_TblList, {&Sep1}, ",":u).

    /*
    * Add the WHERE restriction, if it has changed. The status of the
    * record was determined before the call to the Query Builder.
    *
    *    record             _Where               action
    *
    *    no record          ?                    everything's fine
    *    no record          value                add a record
    *    record             ?                    delete the record
    *    record             value                change the restriction
    */

    qbf-s = saveWhere.
    IF NOT AVAILABLE tempWhere 
      AND (_Where[1] <> ?) AND (_Where[1] <> "") THEN DO:

      /* Create a record */
      CREATE tempWhere.
      ASSIGN
        dirtyWhere            = TRUE
        tempWhere.tableId     = currentTableId
        tempWhere.created     = TRUE
        tempWhere.restriction = _Where[1]
        qbf-s                 = tempWhere.restriction
        .
    END.
    ELSE DO:
      dirtyWhere = TRUE.
      IF (_Where[1] <> ?) AND (_Where[1] <> "") THEN
        ASSIGN
          tempWhere.restriction = _Where[1]
          tempWhere.deleted     = FALSE
          qbf-s                 = tempWhere.restriction
          .
      ELSE IF AVAILABLE tempWhere THEN
        ASSIGN
          tempWhere.deleted = TRUE
          qbf-s             = ""
          .
    END.

    /* Change the screen values */
    IF dirtyWhere THEN
      ASSIGN
        whereText:SCREEN-VALUE = qbf-s
        dirty                  = TRUE
        .
  END.
END PROCEDURE.

{ aderes/p-where.i }
&UNDEFINE FRAME-NAME

/* _awhere.p - end of file */

