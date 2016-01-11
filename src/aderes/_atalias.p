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
/*
* _atalias.p
*
*    Manages table aliases
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/_fdefs.i }
{ aderes/s-system.i }
{ adecomm/adestds.i }
{ aderes/j-define.i }
{ aderes/s-define.i }
{ aderes/_alayout.i }
{ adeshar/_mnudefs.i }
{ aderes/reshlp.i }
{ aderes/_jbkjoin.i }

&Scoped-define FRAME-NAME aliasDialog

/*
* This temp table will combine the information found in Results features
* as well as the information stored in the menu feature. This because
* they share the same name. By doing this, we can still have OK/CANCEL
*/

DEFINE TEMP-TABLE tempRel NO-UNDO
  FIELD tid      AS INTEGER      /* table index */
  FIELD tname    AS CHARACTER    /* table name */
  FIELD rels     AS CHARACTER    /* relationships */
  FIELD crc      AS CHARACTER    /* Cyclic Redundancy Check */
  FIELD sid      AS INTEGER
  FIELD cansee   AS LOGICAL
  FIELD deleted  AS LOGICAL
  FIELD created  AS LOGICAL
  FIELD dirty    AS LOGICAL
  FIELD copyRel  AS LOGICAL
  FIELD selfJoin AS LOGICAL
  INDEX tidix   IS UNIQUE tid
  INDEX tnameix IS UNIQUE tname.

DEFINE BUFFER tempBuf FOR tempRel.

DEFINE VARIABLE aliasName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE aList         AS CHARACTER NO-UNDO.
DEFINE VARIABLE aTitle        AS CHARACTER NO-UNDO.
DEFINE VARIABLE copyRelations AS LOGICAL   NO-UNDO.
DEFINE VARIABLE currentTid    AS INTEGER   NO-UNDO INITIAL ?.
DEFINE VARIABLE dName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lRet          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE newAlias      AS CHARACTER NO-UNDO.
DEFINE VARIABLE nTitle        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i         AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE selfJoin      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tcount        AS INTEGER   NO-UNDO.
DEFINE VARIABLE tName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE tList         AS CHARACTER NO-UNDO.
DEFINE VARIABLE tTitle        AS CHARACTER NO-UNDO.

DEFINE BUTTON addBut LABEL "&Add":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.
DEFINE BUTTON deleteBut LABEL "&Remove":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE RECTANGLE rect1 EDGE-PIXELS 1 SIZE 5 BY .6.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})

  nTitle AT {&ADM_X_START} 
    FORMAT "X({&ADM_IC_FLIST})":u  
    VIEW-AS TEXT NO-LABEL

  /* The attributes are to the right, but with a gap */
  aTitle AT ROW-OF nTitle
    &if "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &then
    COLUMN-OF nTitle + 42.5
    &else
    COLUMN-OF nTitle + 44
    &endif
    FORMAT "X({&ADM_IC_FLIST})":u  
    VIEW-AS TEXT NO-LABEL

  SKIP({&VM_WID})

  aliasName AT {&ADM_X_START} {&STDPH_FILL} NO-LABEL
    FORMAT "X(65)":U
    VIEW-AS FILL-IN SIZE {&ADM_IC_FLIST} BY {&ADM_H_BUTTON}
  
  tTitle AT ROW-OF aliasName + 1.4 COLUMN-OF aliasName
    FORMAT "X({&ADM_IC_FLIST})":u  
    VIEW-AS TEXT NO-LABEL

  tList AT ROW-OF tTitle + .8 COLUMN-OF tTitle NO-LABEL
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
    INNER-LINES {&ADM_IL_SLIST} INNER-CHARS {&ADM_IC_SLIST}

  selfJoin AT ROW-OF tList + {&ADM_P_SLIST} COLUMN-OF tList
    LABEL "R&elate Alias to Table"
    VIEW-AS TOGGLE-BOX SIZE {&ADM_IC_FLIST} BY {&ADM_H_BUTTON}

  copyRelations AT ROW-OF selfJoin + {&ADM_V_GAP} COLUMN-OF tList
    LABEL "&Copy Relationships"
    VIEW-AS TOGGLE-BOX SIZE {&ADM_IC_FLIST} BY {&ADM_H_BUTTON}

  addBut AT ROW-OF tList + .33 COLUMN-OF aliasName + {&ADM_H_SLIST_OFF}

  deleteBut AT ROW-OF addBut + {&ADM_V_GAP} COLUMN-OF AddBut

  aList AT ROW-OF aliasName COLUMN-OF aTitle NO-LABEL
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
    INNER-LINES 9 INNER-CHARS {&ADM_IC_SLIST}

  rect1 AT ROW-OF copyRelations COLUMN 2
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS NO-UNDERLINE THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Table Aliases":L.

ON VALUE-CHANGED OF tList
  RUN figureButtonState.

ON CHOOSE OF addBut OR DEFAULT-ACTION OF tList DO:
  IF aliasName:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
 
  /* Has user exceeded 32 character table name length? -dma */
  ASSIGN 
    qbf-i    = R-INDEX(aliasName:SCREEN-VALUE,".":u)
    newAlias = IF qbf-i = ? THEN aliasName:SCREEN-VALUE ELSE
                 SUBSTRING(aliasName:SCREEN-VALUE,qbf-i + 1,-1,"CHARACTER":u)
    .

  IF LENGTH(newAlias,"CHARACTER":u) > 32 THEN DO:
    MESSAGE "The alias name cannot exceed 32 characters."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  /*
   * Make sure that the name provided by the user gets qualified. A table
   * alias belongs to the database of the table that is aliased.
   */
  IF NUM-ENTRIES(aliasName:SCREEN-VALUE, ".":u) = 1 THEN DO:
    RUN adecomm/_valname(aliasName:SCREEN-VALUE, FALSE, OUTPUT lRet).
    IF lRet = FALSE THEN RETURN.

    ASSIGN
      dName                  = ENTRY(1, tList:SCREEN-VALUE, ".":u)
      aliasName:SCREEN-VALUE = dName + ".":u + aliasName:SCREEN-VALUE
      .
  END.
  ELSE DO:

    /* The user qualified alias name.  See if the name is legal */
    ASSIGN
      dName = ENTRY(1, aliasName:SCREEN-VALUE, ".":u).
      tName = ENTRY(2, aliasName:SCREEN-VALUE, ".":u).

    RUN adecomm/_valname (tName, FALSE, OUTPUT lRet).
    IF lRet = FALSE THEN RETURN.

    IF LOOKUP(dName, qbf-dbs) = 0 THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet,"information":u,"ok":u,
        SUBSTITUTE("&1 does not reference an attached database. Select another name.",aliasName:SCREEN-VALUE)).

      RETURN.
    END.

    /*
    * Now make sure that the database name given in the alias name
    * matches the name found in the reference table. Just want to avoid
    * confusion if the user is working with multiple databases
    */
    IF dName <> ENTRY(1, tList:SCREEN-VALUE, ".":u) THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet,"information":u,"ok":u,
        SUBSTITUTE("&1 does not refer to the same database as &2.  Select another name.",
        aliasName:SCREEN-VALUE,tList:SCREEN-VALUE)).

      RETURN.
    END.
  END.

  /*
  * Make sure that the alias is a new one. That is, the last entry in the
  * table for this name has to be deleted. A user can add the same name
  * after the name has been deleted. If we didn't make this check then
  * the user could not readd the feature withou first "OK" out of the
  * interface and coming back in. Also, once the thing is deleted, it is
  * removed from the selection list. So the user thinks the name is available.
  */
  tName = ENTRY(2, aliasName:SCREEN-VALUE, ".":u).

  FIND LAST tempRel WHERE ENTRY(2, tempRel.tname, ".":u) = tName NO-ERROR.

  IF AVAILABLE tempRel AND tempRel.deleted = FALSE THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet,"error":u,"ok":u,
      SUBSTITUTE("&1 is an existing alias name.  Select another name.",
      tempRel.tname)).

    RETURN NO-APPLY.
  END.

  /*
  * Make sure that we're not playing with an existing database name.
  * That would be very bad!
  */
  {&FIND_TABLE_BY_NAME} aliasName:SCREEN-VALUE NO-ERROR.

  IF AVAILABLE qbf-rel-buf THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet,"error":u,"ok":u,
      SUBSTITUTE("&1 is an existing table name.  Select another name.",
      aliasName:SCREEN-VALUE)).      

    RETURN.
  END.

  /*
  * Take the table alias name and add it into the the temporary list.
  * When the user hits OK the information will be added to the permanent
  * data structures. This indirection allows CANCEL to work, since the
  * temp table is no-undo.
  */

  /* Find the largest id issued to date. */
  tcount = tcount + 1.

  {&FIND_TABLE_BY_NAME} tList:SCREEN-VALUE.

  /*
  * If there's already a tempRel out there (the user created and then
  * deleted the alias) then use the slot. Override the existing definition
  */
  IF NOT AVAILABLE tempRel THEN
    CREATE tempRel.

  ASSIGN
    lRet                  = aList:ADD-LAST(aliasName:SCREEN-VALUE)
    aList:SCREEN-VALUE   = aliasName:SCREEN-VALUE
    tempRel.tid          = tcount
    tempRel.tname        = aliasName:SCREEN-VALUE
    tempRel.rels         = ""
    tempRel.crc          = qbf-rel-buf.crc
    tempRel.cansee       = TRUE
    tempRel.sid          = qbf-rel-buf.tid
    tempRel.dirty        = TRUE
    tempRel.created      = TRUE
    tempRel.deleted      = FALSE
    tempRel.copyRel      = (copyRelations:SCREEN-VALUE = "yes":u)
    tempRel.selfJoin     = (selfJoin:SCREEN-VALUE = "yes":u)
    currentTid           = tempRel.tid
    .

  RUN figureButtonState.
END.

ON VALUE-CHANGED OF aList IN FRAME {&FRAME-NAME}
  RUN changeToAlias(aList:SCREEN-VALUE).

ON CHOOSE OF deleteBut OR default-action OF aList DO:
  DEFINE VARIABLE i AS INTEGER NO-UNDO.

  /*
  * Find the last record with the name. Eventually, we'll want to support
  * the case where the user deletes and then adds using the same name. Since
  * the tempRel is a delta list of changes, the deleted item will still
  * be in the tempTable.
  */
  FIND LAST tempRel WHERE tempRel.tname = aList:SCREEN-VALUE.

  /*
  * It is ok to "delete" the item. Update the GUI and flag the change. We don't
  * remove the item from the temp list. The temp table is a list of deltas
  * to the real datastructure. THis is the operation to be done on the
  * real feature list. If we deleted the record now, then the corresponding
  * item in the real data structure would not get deleted.
  */
  ASSIGN
    tempRel.dirty   = TRUE
    tempRel.deleted = TRUE
    i               = aList:LOOKUP(aList:SCREEN-VALUE)

    /*
    * If this is the last item, then select the new last item.
    * If there is nothing then select nothing, otherwise choose the
    * next item.
    */

    lRet = aList:DELETE(aList:SCREEN-VALUE)
    .

  IF i > aList:NUM-ITEMS THEN
    i = i - 1.

  IF i = 0 THEN
  ASSIGN
    aliasName:SCREEN-VALUE = ""
    tList:SCREEN-VALUE     = tList:ENTRY(1)
    currentTid             = ?
    .
  ELSE DO:
    aList:SCREEN-VALUE = aList:ENTRY(i).

    RUN changeToAlias(aList:SCREEN-VALUE).
  END.

  RUN figureButtonState.
END.

ON GO OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_setcurs.p("WAIT":u).
  RUN saveChanges.
END.


ON ALT-N OF FRAME {&FRAME-NAME}  
  APPLY "ENTRY":u TO aliasName IN FRAME {&FRAME-NAME}.

ON ALT-T OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO tList IN FRAME {&FRAME-NAME}.

ON ALT-L OF FRAME {&FRAME-NAME} 
  APPLY "ENTRY":u TO aList IN FRAME {&FRAME-NAME}.


/*------------------------- Main Code Block ----------------------- */

/* Perform any runtime layout. */

ASSIGN
  FRAME {&FRAME-NAME}:HIDDEN = TRUE
  aliasName:WIDTH-PIXELS     = tList:WIDTH-PIXELS
  tList:Y                    = (aList:Y + aList:HEIGHT-PIXELS) 
                             - tList:HEIGHT-PIXELS
  tTitle:Y                   = tList:Y - (tTitle:HEIGHT-PIXELS + 3)
  .

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help }

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Table_Alias_Dlg_Box} }

ASSIGN
  aTitle:SCREEN-VALUE         = "A&liases:"
  nTitle:SCREEN-VALUE         = "&Name:"
  tTitle:SCREEN-VALUE         = "&Tables:"
  aList:SENSITIVE             = TRUE
  addBut:SENSITIVE            = TRUE
  aliasName:SENSITIVE         = TRUE
  tList:SENSITIVE             = TRUE
  copyRelations:SENSITIVE     = TRUE
  copyRelations:SCREEN-VALUE  = "yes":u
  selfJoin:SENSITIVE          = TRUE
  selfJoin:SCREEN-VALUE       = "yes":u
  rect1:HIDDEN                = TRUE
  .

RUN initGui.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

RUN adecomm/_setcurs.p ("").

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE initGui:
  DO WITH FRAME {&FRAME-NAME}:
    FIND LAST qbf-rel-tt USE-INDEX tidix NO-ERROR.
    IF AVAILABLE qbf-rel-tt THEN tcount = qbf-rel-tt.tid.

    /* Load the two selection lists. */
    FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee:
      IF (qbf-rel-buf.sid <> ?) THEN DO:

        CREATE tempRel.
        ASSIGN
          lRet              = aList:ADD-LAST(qbf-rel-buf.tname)
          tempRel.tid      = qbf-rel-buf.tid
          tempRel.tname    = qbf-rel-buf.tname
          tempRel.rels     = qbf-rel-buf.rels
          tempRel.cansee   = qbf-rel-buf.cansee
          tempRel.sid      = qbf-rel-buf.sid
          tempRel.dirty    = FALSE
          tempRel.created  = FALSE
          tempRel.deleted  = FALSE
          .
      END.
      ELSE

      /* The current record is not a table alias and can be seen by this user */
        lRet = tList:ADD-LAST(qbf-rel-buf.tname).
    END.

    /* Take the first item on the list and set the GUI.  */
    FIND FIRST tempRel NO-ERROR.

    IF AVAILABLE tempRel THEN DO:
      RUN changeToAlias(tempRel.tname).
      aList:SCREEN-VALUE = tempRel.tname.
      RUN figureButtonState.
    END.
    ELSE DO:
      tList:SCREEN-VALUE = tList:ENTRY(1).
      RUN figureButtonState.
      APPLY "ENTRY":u TO aliasName.
    END.
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE changeToAlias:
  DEFINE INPUT PARAMETER aName AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    /*
    * Find the table that is attached to this alias. Its a two step
    * process. Get the id from our data strcture and then look it up
    * in the real list, the tempoaray structure only holds aliases, not
    * real tables!
    */

    /* Don't do any work if we don't have to */
    FIND FIRST tempRel WHERE tempRel.tname = aName.
    IF currentTid = tempRel.tid THEN RETURN.

    {&FIND_TABLE_BY_ID} tempRel.sid.

    ASSIGN
      aliasName:SCREEN-VALUE  = aName
      tList:SCREEN-VALUE      = qbf-rel-buf.tname
      currentTid              = tempRel.tid
      .

    RUN adecomm/_scroll.p(tList:HANDLE, tList:SCREEN-VALUE).
  END.

  RUN figureButtonState.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE figureButtonState:
  DO WITH FRAME {&FRAME-NAME}:
    deleteBut:SENSITIVE = (currentTid <> ?).
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE saveChanges:
  DEFINE VARIABLE dirty         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE j             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinIndex     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinType      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisJoin      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinTypeShort AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinWhere     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tempList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tid           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lookAhead     AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    /*
    * Walk through the temp list and see what is in there and what
    * has changed. Go through twice. The first time for deletes and
    * then for adds. The reason is that the deletes have to complete
    * on qbf-rel-tt before the add, so that only the proper relationships
    * are copied.
    */
    FOR EACH tempRel WHERE tempRel.dirty = TRUE:
      /*
      * If the user created and deleted a feature in the same
      * sitting its a noop
      */
      IF tempRel.deleted = TRUE AND tempRel.created = TRUE THEN NEXT.

      IF tempRel.deleted = TRUE THEN DO:
  
        /*
        * Delete the table alias after removing the relationship
        * from all of the related tables.
        */
        joinList = tempRel.rels.
  
        /*
          * Remove the relationships and where clauses from the
          * related tables. The where caluse just fall out. The index
          * into the where table will be lost, so it will never be
          * written out. THe array slot will not be available during
          * this session.
        */
    
        DO i = 2 TO NUM-ENTRIES(joinList):
          RUN breakJoinInfo(ENTRY(i, joinList),
            OUTPUT joinIndex,
            OUTPUT joinType,
            OUTPUT joinTypeShort,
            OUTPUT joinWhere).

          IF joinIndex = ? THEN NEXT.
  
          /*
          * Brute force to rebuild the list. Since multiple aliases
          * can be deleted in one transaction it is possible that
          * some of local temp table records have already been
          * deleted. THe local alias record could have ids pointing
          * deleted alias record out in qbf-rel-buf
          */
  
          {&FIND_TABLE2_BY_ID} joinIndex NO-ERROR.
          IF NOT AVAILABLE qbf-rel-buf2 THEN NEXT.
  
          tempList = "".

          DO j = 2 TO NUM-ENTRIES(qbf-rel-buf2.rels):
            RUN breakJoinInfo(ENTRY(j, qbf-rel-buf2.rels),
                OUTPUT tid,
                OUTPUT joinType,
                OUTPUT joinTypeShort,
                OUTPUT joinWhere).
  
  
            IF tid = tempRel.tid THEN NEXT.
  
            tempList = tempList + ",":u + ENTRY(j, qbf-rel-buf2.rels).
          END.
  
          qbf-rel-buf2.rels = tempList.
        END.

        /* Delete the corresponsing WHERE clause. */
        FIND FIRST qbf-where
          WHERE qbf-where.qbf-wtbl = tempRel.tid NO-ERROR.
        IF AVAILABLE qbf-where THEN DELETE qbf-where.
  
        /* Delete the corresponsing WHERE clause. */
        FIND FIRST _tableWhere
          WHERE _tableWhere._tableId = tempRel.tid NO-ERROR.
        IF AVAILABLE _tableWhere THEN DELETE _tableWhere.
  
        /* Delete the alias */
        {&FIND_TABLE_BY_ID} tempRel.tid.
        DELETE qbf-rel-buf.
  
        ASSIGN
          dirty        = TRUE
          _flagRebuild = TRUE
          .
      END.
    END.

    /* Now add in any new aliases */
    FOR EACH tempRel :
      IF tempRel.dirty = FALSE THEN NEXT.
  
      /*
      * If the user created and deleted a feature in the same
      * sitting its a noop
      */
      IF tempRel.deleted = TRUE AND tempRel.created = TRUE THEN NEXT.
  
      IF tempRel.created = TRUE THEN DO:     
        RUN aderes/_atalrel.p(FALSE,
                              tempRel.tName,
                              tempRel.tid,
                              tempRel.sid,
                              tempRel.copyRel,
                              tempRel.selfJoin,
                              output tempRel.rels).
        /* Create an alias. */
        CREATE qbf-rel-tt.
  
        ASSIGN
          dirty = TRUE
          qbf-rel-tt.tid    = tempRel.tid
          qbf-rel-tt.tname  = tempRel.tname
          qbf-rel-tt.rels   = tempRel.rels
          qbf-rel-tt.crc    = tempRel.crc   
          qbf-rel-tt.cansee = tempRel.cansee
          qbf-rel-tt.sid    = tempRel.sid
          qbf-rel-tbl#      = qbf-rel-tbl# + 1
          .
      END.
    END. /* FOR EACH tempRel */
  END. /* DO WITH FRAME */
  
  /* Now write out the admin feature definition file. */
  IF dirty = TRUE THEN DO:
    _configDirty = TRUE.
  
    /*
    * To avoid a bug, always write out the config file in this
    * situation. If they aren't then an app rebuild may not
    * reset the alias properly. THis happens because app rebuild
    * relies on the configuration file when rebuilding aliases,
    * not the intertanl data structures.
    */
    RUN aderes/_awrite.p(2).
  END.
END PROCEDURE.
  
&UNDEFINE FRAME-NAME
  
/* _atalias.p - end of file */
  

  
  
  
  
  

  

