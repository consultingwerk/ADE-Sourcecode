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
* _arships.p
*
*    Defines the GUI to build the relationship between tables.
*/

&GLOBAL-DEFINE WIN95-BTN YES
&SCOPED-DEFINE FRAME-NAME relationshipDialog

{ aderes/s-system.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/j-define.i }
{ adecomm/cbvar.i "NEW SHARED" }
{ adeshar/quryshar.i NEW GLOBAL}
{ adecomm/tt-brws.i "NEW"}
{ adeuib/brwscols.i NEW } /* for query builder compatibility */
{ aderes/_jbkjoin.i }
{ aderes/s-alias.i }
{ aderes/reshlp.i }

/* for query builder compatibility */
DEFINE NEW SHARED VARIABLE _query-u-rec AS RECID NO-UNDO. 

DEFINE VARIABLE ans                AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-i              AS INTEGER   NO-UNDO.
DEFINE VARIABLE cJunk              AS CHARACTER NO-UNDO.
DEFINE VARIABLE currentTableTid    AS INTEGER   NO-UNDO.
DEFINE VARIABLE dirty              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE joinTypeShort      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lookAhead          AS CHARACTER NO-UNDO.
DEFINE VARIABLE tempWhereCount     AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE tempRel NO-UNDO /* patterned after qbf-rel-tt */
  FIELD tid     AS INTEGER      /* table index */
  FIELD tname   AS CHARACTER    /* table name */
  FIELD rels    AS CHARACTER    /* relationships */
  INDEX tidix   IS UNIQUE tid
  INDEX tnameix IS UNIQUE tname.

DEFINE BUFFER tempBuf FOR tempRel.

DEFINE TEMP-TABLE tempJoinWhere NO-UNDO /* patterned after qbf-rel-whr */
  FIELD wid     AS INTEGER    /* WHERE clause index */
  FIELD jwhere  AS CHARACTER  /* WHERE clause */
  INDEX widix   IS UNIQUE wid.

/* For accessing tempJoinWhere table join WHERE clause */
&GLOBAL-DEFINE FIND_JOIN_BY_ID    FIND tempJoinWhere WHERE tempJoinWhere.wid =

DEFINE VARIABLE baseTableList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-LINES 5 INNER-CHARS {&ADM_IC_SLIST} SORT NO-UNDO.

DEFINE BUTTON createBut
  LABEL "&Add >>"
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE BUTTON deleteBut
  LABEL "<< &Remove"
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE BUTTON editBut
  LABEL "&Edit..."
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE VARIABLE joinText AS CHARACTER
  VIEW-AS EDITOR
  SIZE {&ADM_W_SLIST_SBS} BY 3
  SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
  MAX-CHARS {&ADM_LIMIT_CHARS} NO-UNDO.

DEFINE VARIABLE relationList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SORT INNER-LINES 13 INNER-CHARS {&ADM_IC_SLIST} NO-UNDO.

DEFINE VARIABLE tableList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SORT INNER-LINES 5 INNER-CHARS {&ADM_IC_SLIST} NO-UNDO.

{ aderes/_asbar.i }

DEFINE VARIABLE tTitle AS CHARACTER FORMAT "X({&ADM_W_SLIST})":u.
DEFINE VARIABLE aTitle AS CHARACTER FORMAT "X({&ADM_W_SLIST})":u.
DEFINE VARIABLE rTitle AS CHARACTER FORMAT "X({&ADM_W_SLIST})":u.
DEFINE VARIABLE jTitle AS CHARACTER FORMAT "X({&ADM_W_SLIST_SBS})":u.

FORM
  SKIP({&TFM_WID})

  tTitle AT 2 VIEW-AS TEXT NO-LABEL

  rTitle AT ROW-OF tTitle
    COLUMN-OF tTitle + {&ADM_H_SLIST_SBS}
    VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  baseTableList AT 2 NO-LABEL
  SKIP(1)

  aTitle AT 2 
    VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  tableList AT {&ADM_X_START} NO-LABEL

  createBut AT ROW-OF aTitle
    COLUMN-OF tableList + {&ADM_H_SLIST_OFF}

  deleteBut AT ROW-OF createBut + {&ADM_V_GAP}
    COLUMN-OF createBut

  editBut AT ROW-OF deleteBut + {&ADM_V_GAP}
    COLUMN-OF createBut

  relationList AT ROW-OF baseTableList
    COLUMN-OF baseTableList + {&ADM_H_SLIST_SBS} NO-LABEL
  SKIP(.5)

  jTitle AT 2 
    VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  joinText AT 2 NO-LABEL

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Table Relationships".

ON VALUE-CHANGED, DEFAULT-ACTION OF baseTableList IN FRAME {&FRAME-NAME}
  RUN changeRelations (baseTableList:SCREEN-VALUE).

ON CHOOSE OF createBut IN FRAME {&FRAME-NAME}
  RUN addRelation (tableList:SCREEN-VALUE).

ON CHOOSE OF deleteBut IN FRAME {&FRAME-NAME}
  RUN removeRelation (relationList:SCREEN-VALUE,TRUE).

ON CHOOSE OF editBut IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE cancelled AS LOGICAL NO-UNDO.

  RUN editRelationship (relationList:SCREEN-VALUE, FALSE, OUTPUT cancelled).
END.

ON DEFAULT-ACTION OF relationList IN FRAME {&FRAME-NAME}
  RUN removeRelation (relationList:SCREEN-VALUE,TRUE).

ON VALUE-CHANGED OF relationList IN FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO relationList.

ON ENTRY OF relationList IN FRAME {&FRAME-NAME} DO:
  tableList:SCREEN-VALUE = "".

  RUN setRelated (relationList:SCREEN-VALUE).
  RUN figureButtonState.
END.

ON DEFAULT-ACTION OF tableList IN FRAME {&FRAME-NAME}
  RUN addRelation (tableList:SCREEN-VALUE).

ON ENTRY OF tableList, baseTableList IN FRAME {&FRAME-NAME} DO:
  ASSIGN
    joinText:SCREEN-VALUE     = ""
    relationList:SCREEN-VALUE = ""
    .
  RUN figureButtonState.
END.

ON VALUE-CHANGED OF tableList IN FRAME {&FRAME-NAME}
  RUN figureButtonState.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF dirty = FALSE THEN RETURN.
  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Make the changes permanent */
  FOR EACH tempRel:
    {&FIND_TABLE_BY_ID} tempRel.tid.
    qbf-rel-buf.rels = tempRel.rels.
  END.

  FOR EACH tempJoinWhere:
    {&FIND_WHERE_BY_ID} tempJoinWhere.wid NO-ERROR.
    IF NOT AVAILABLE qbf-rel-whr THEN DO:
      CREATE qbf-rel-whr.
      qbf-rel-whr.wid = tempJoinWhere.wid.
    END.
    qbf-rel-whr.jwhere = tempJoinWhere.jwhere.
  END.

  ASSIGN
    qbf-rel-whr# = tempWhereCount
    _configDirty = TRUE
    qbf-dirty    = TRUE
    .

  RUN aderes/_awrite.p (0).
END.

ON ALT-B OF FRAME {&FRAME-NAME}
   APPLY "ENTRY":u TO baseTableList IN FRAME {&FRAME-NAME}.

ON ALT-V OF FRAME {&FRAME-NAME}
   APPLY "ENTRY":u TO tableList IN FRAME {&FRAME-NAME}.

ON ALT-T OF FRAME {&FRAME-NAME}
   APPLY "ENTRY":u TO relationList IN FRAME {&FRAME-NAME}.

ON ALT-L OF FRAME {&FRAME-NAME}
   APPLY "ENTRY":u TO joinText IN FRAME {&FRAME-NAME}.

/*------------------------------ Main code block -------------------------*/

FRAME {&FRAME-NAME}:HIDDEN = YES.

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Relationship_Editor_Dlg_Box} }

/* Manage the cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

RUN initTemp.

ASSIGN
  tTitle:SCREEN-VALUE         = "&Base Table:"
  aTitle:SCREEN-VALUE         = "A&vailable To Be Related:"
  jTitle:SCREEN-VALUE         = "Re&lationship:"
  rTitle:SCREEN-VALUE         = "Related &To:"
  joinText:READ-ONLY          = TRUE
  baseTableList:SENSITIVE     = TRUE
  tableList:SENSITIVE         = TRUE
  relationList:SENSITIVE      = TRUE
  createBut:SENSITIVE         = TRUE
  deleteBut:SENSITIVE         = TRUE
  editBut:SENSITIVE           = TRUE
  joinText:SENSITIVE          = TRUE
  .

RUN initGui.

/* Run time layout */
ASSIGN
  tableList:Y                = (relationList:Y + relationList:HEIGHT-PIXELS)
                             - tableList:HEIGHT-PIXELS
  aTitle:Y                   = tableList:Y - (aTitle:HEIGHT-PIXELS + 3)
  FRAME {&FRAME-NAME}:HIDDEN = FALSE.

RUN adecomm/_setcurs.p ("").

DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE addRelation:
  /* To add the supplied tableName to the base table's list of relations. */
  DEFINE INPUT PARAMETER tableName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ofAble           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE joinIndex        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinType         AS CHARACTER NO-UNDO INITIAL "<":u.
  DEFINE VARIABLE joinWhere        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE newJoinBase      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE newJoinTable     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinList         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sortedList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fullTableName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tempName1        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tempName2        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE realTid          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE fullTableIndex   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE fullJoinName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fullJoinIndex    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cancelled        AS LOGICAL   NO-UNDO.
  
  /*
   * Is the relationship between the table "OfAble". If it is then
   * assume the default relationship and then go figure out the
   * join type.
   *
   * If not "OfAble" then bring up the editor, we need the join-where
   * to define the relationship
   *
   * j-test requires fully qualifed name and both sides of the relationship
   * may need to be tested.
   */
  
  ASSIGN
    dirty         = TRUE
    fullJoinName  = tableName
    fullTableName = baseTableList:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    tempName1     = fullTableName
    tempName2     = fullJoinName
    .
  
  FIND tempRel WHERE tempRel.tname = fullJoinName.
  fullJoinIndex  = tempRel.tid.
  
  FIND tempRel WHERE tempRel.tname = fullTableName.
  fullTableIndex = tempRel.tid.
  
  /*
   * Check the metadata of the deferenced name (in case of aliases) to see
   * if the tables can be naturally joined
   */
  RUN alias_to_tbname (fullTableName,TRUE,OUTPUT tempName1).
  RUN alias_to_tbname (fullJoinName,TRUE,OUTPUT tempName2).
  RUN adecomm/_j-test.p (tempName1,tempName2,OUTPUT ofAble).
  
  IF NOT ofAble THEN
    RUN adecomm/_j-test.p (tempName2,tempName1,OUTPUT ofAble).
 
  /*
   * Update the data structure, and it has to be kept sorted. Many
   * other parts of the code rely on the list be sorted by table id.
   *
   * First, find the index for the new table, then add the join type,
   * finally, add any join-where info.
   *
   * Create the new join, add it to the end of the list, then sort it. 
   */
  ASSIGN
    newJoinBase  = joinType + STRING(fullJoinIndex)
    newJoinTable = joinType + STRING(fullTableIndex)
    .
  
  /*
   * If the new relation is not ofable then add the ":" syntax. Build this 
   * info now, so that the edit code doesn't have to worry about this newly 
   * added thing. To the edit code, this relationship will be old news.
   */
  IF NOT ofAble THEN DO:
    tempWhereCount = tempWhereCount + 1.
    {&FIND_JOIN_BY_ID} tempWhereCount NO-ERROR.
    IF NOT AVAILABLE tempJoinWhere THEN DO:
      CREATE tempJoinWhere.
      tempJoinWhere.wid = tempWhereCount.
    END.
    
    ASSIGN
      tempJoinWhere.jwhere = ""
      newJoinBase          = newJoinBase + ":":u + STRING(tempWhereCount)
      newJoinTable         = newJoinTable + ":":u + STRING(tempWhereCount)
      .
  END.
  
  /* Build the list for both tables. Relations are added to both tables. */
  FIND tempRel WHERE tempRel.tname = fullTableName.
  
  joinList = tempRel.rels + ",":u + newJoinBase.
  
  RUN aderes/_jsort1.p (joinList,OUTPUT sortedList).
  
  tempRel.rels = sortedList.
  
  FIND tempRel WHERE tempRel.tname = fullJoinName.
  
  ans = FALSE.
  
  /*
   * By default, add trys to create the relationship both ways. So check
   * to see if this table is already related to the other table.
   */
  DO qbf-i = 2 TO NUM-ENTRIES(tempRel.rels):
    RUN breakJoinInfo (ENTRY(qbf-i,tempRel.rels),OUTPUT joinIndex,
                       OUTPUT cJunk,OUTPUT joinTypeShort,OUTPUT joinWhere).
  
    /* Stop as soon as we find a match */
    IF (fullTableIndex = joinIndex) THEN DO:
      ans = TRUE.
      LEAVE.
    END.
  END.
  
  IF ans = FALSE THEN DO:
    joinList = tempRel.rels + ",":u + newJoinTable.
  
    RUN aderes/_jsort1.p (joinList,OUTPUT sortedList).
  
    tempRel.rels = sortedList.
  END.
 
  IF NOT ofAble THEN DO:
    RUN editRelationship (tableName,TRUE,OUTPUT cancelled).
 
    IF (_JoinCode[2] = ? OR _JoinCode[2] = "") OR cancelled THEN DO:
      RUN removeRelation (tableName,FALSE).
    
      RETURN.
    END.
  END.
  
  /* Remove the selection from the table list and add to the relation list. */
  ASSIGN
    qbf-i = tableList:LOOKUP(tableName)
    ans   = tableList:DELETE(tableName) IN FRAME {&FRAME-NAME}
    ans   = relationList:ADD-LAST(tableName) IN FRAME {&FRAME-NAME}
    .
  
  IF qbf-i > tableList:NUM-ITEMS THEN
    qbf-i = qbf-i - 1.
  
  tableList:SCREEN-VALUE = IF qbf-i = 0 THEN "" ELSE tableList:ENTRY(qbf-i).
  
  RUN figureButtonState.
END PROCEDURE.
  
/* ----------------------------------------------------------- */
PROCEDURE changeRelations:
  DEFINE INPUT PARAMETER newTable AS CHARACTER NO-UNDO.

  DEFINE VARIABLE joinList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tableName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinIndex     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinType      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinWhere     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE newItem       AS CHARACTER NO-UNDO.
  
  /* Don't do any work that we don't have to do. */
  FIND tempRel WHERE tempRel.tname = newTable.
  IF (currentTableTid = tempRel.tid) THEN RETURN.

  ASSIGN
    currentTableTid                                  = tempRel.tid
    joinList                                         = tempRel.rels
    tableList:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = ""
    tableList:LIST-ITEMS IN FRAME {&FRAME-NAME}      = ""
    relationList:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
    relationList:LIST-ITEMS IN FRAME {&FRAME-NAME}   = ""

    /*
    * Copy all the tables into the available list and then
    * remove any names that are already a relation and put
    * those into the other list
    */
    ans = tableList:ADD-LAST(baseTableList:LIST-ITEMS IN FRAME {&FRAME-NAME})
                             IN FRAME {&FRAME-NAME}
    .

  /* "Self joins" are handled through "synonyms" (table aliases). Remove
   * the current table from the table list. */
  ans = tableList:DELETE(tempRel.tname) IN FRAME {&FRAME-NAME}.
  
  IF NUM-ENTRIES(joinList) > 0 THEN DO:
    DO qbf-i = 2 TO NUM-ENTRIES(joinList):
      /*
      * For each item in the joinList, get the index, use that to get the
      * name from the temp table and then remove the table from the
      * tableSelectionList. The form is >nnnn: (worse case)
      */
      RUN breakJoinInfo (ENTRY(qbf-i,joinList),OUTPUT joinIndex,OUTPUT joinType,
                         OUTPUT joinTypeShort,OUTPUT joinWhere).

      /*
      * OK, we've got the character string versionof the index. Go off
      * and get the corresponding name. Remove it from one list as move
      * into the other. And, a table may not be in our list if the user
      * doesn't have permission to see all the tables. Although this
      * is not recomended behavior, it could happen.
      */

      FIND tempRel WHERE tempRel.tid = joinIndex NO-ERROR.
      IF NOT AVAILABLE tempRel THEN NEXT.
  
      ASSIGN
        tableName = tempRel.tname
        ans       = tableList:DELETE(tableName) IN FRAME {&FRAME-NAME}
        ans       = relationList:ADD-LAST(tableName) IN FRAME {&FRAME-NAME}.
      .
  
    END.
  END.
  ELSE
    joinText:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  
  /* Set the current value of the tableList to the first table in the list */
  
  IF tableList:NUM-ITEMS > 0 THEN
    tableList:SCREEN-VALUE = tableList:ENTRY(1).
  
  RUN figureButtonState.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE figureButtonState:
  /* Purpose: To properly set the availibility of the buttons */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      createBut:SENSITIVE = (tableList:SCREEN-VALUE <> ?)
      deleteBut:SENSITIVE = (relationList:SCREEN-VALUE <> ?)
      editBut:SENSITIVE   = (relationList:SCREEN-VALUE <> ?)
      .
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE figureJoinText:
  /* Purpose: To build the text needed for the join text. Allow 2 versions to 
              be built. What the user sees and what the query builder needs.

    joinWhere If 0 then OF
              If -1 then WHERE that hasn't been completely defined
              If > 0 then WHERE that has been defined
  */

  DEFINE INPUT  PARAMETER whichVersion AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER joinWhere    AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER firstName    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER secondName   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER textLine     AS CHARACTER NO-UNDO.

  DEFINE VARIABLE opString  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE endString AS CHARACTER NO-UNDO.

  opString = IF joinWhere > 0 THEN " WHERE ":u ELSE " OF ":u.

  CASE whichVersion:
    WHEN "query":u THEN
      /* The query version is used when building the data structures
         to send over to the query builder. */
      endString = IF joinWhere <> 0 THEN " ...":u ELSE "".

    OTHERWISE
      /* The standard text is used for viewing most OF join clause. If
         it gets too big then end with ellipses.  */
      IF joinWhere > 0 THEN DO:
        {&FIND_JOIN_BY_ID} joinWhere NO-ERROR.

        IF AVAILABLE tempJoinWhere THEN DO:
          IF tempJoinWhere.jwhere = "" THEN RETURN.
          ASSIGN
            endString  = " ":u + tempJoinWhere.jwhere
            secondName = ""
            .
        END.
      END.
  END CASE.

  textLine = firstName + opString + secondName + endString.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE initGui:
  /* Purpose: To setup the selection list and set button states */

  DEFINE VARIABLE tableName AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lookAhead                  = ""
      currentTableTid            = 0
      baseTableList:SCREEN-VALUE = ""
      tableList:SCREEN-VALUE     = ""
      tableList:LIST-ITEMS       = ""
      relationList:SCREEN-VALUE  = ""
      relationList:LIST-ITEMS    = ""
      joinText:SCREEN-VALUE      = ""
      .
  
    /* Walk the join array to get table names */
    FOR EACH tempRel USE-INDEX tnameix:
      ASSIGN
        tableName = tempRel.tname
        ans       = baseTableList:ADD-LAST(tableName) /* Add to table list */
        .
    END.
  
    /* Setup the first item as the current relation */
    ASSIGN
      tableName                  = baseTableList:ENTRY(1)
      baseTableList:SCREEN-VALUE = tableName
      .
  
    APPLY "VALUE-CHANGED":u TO baseTableList.
  
    /*
    * THe last thing changeRelations does is figure out the button
    * state. As long as that function does it, then don't call
    * figureButtonState here
    */
  
    /* Now do any run time layout.  */
    joinText:WIDTH-PIXELS = (relationList:X + relationList:WIDTH-PIXELS)
                          - joinText:X.
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE initTemp:
  /* Purpose: To setup the temporary data structures */

  /* Cleanup up the existing temporary data */
  FOR EACH tempRel:
    DELETE tempRel.
  END.

  /* Populate the workspace */
  FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee:
    CREATE tempRel.
    ASSIGN
      tempRel.tid   = qbf-rel-buf.tid
      tempRel.tname = qbf-rel-buf.tname
      tempRel.rels  = qbf-rel-buf.rels
      .
  END.

  tempWhereCount = qbf-rel-whr#.

  FOR EACH qbf-rel-whr:
    CREATE tempJoinWhere.
    ASSIGN
      tempjoinWhere.wid    = qbf-rel-whr.wid
      tempJoinWhere.jwhere = qbf-rel-whr.jwhere.
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE removeRelation:
  /* Purpose: Remove a relation from the screen and from the internal 
              structures. */
  DEFINE INPUT PARAMETER relation AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fixGUI   AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE oldIndex  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tempList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinIndex AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinWhere AS INTEGER   NO-UNDO.
  DEFINE VARIABLE jx        AS INTEGER   NO-UNDO.

  dirty = TRUE.

  IF fixGUI THEN 
    ASSIGN
      /* Get the item out of the relation list */
      jx    = relationList:LOOKUP(relation) IN FRAME {&FRAME-NAME}
      ans   = relationList:DELETE(relation) IN FRAME {&FRAME-NAME}
    
      /*
      * Add it back to the tableList and then remove the entry from the
      * joinList for the active table.
      */
      ans   = tableList:ADD-LAST(relation) IN FRAME {&FRAME-NAME}
      .
  
  /*
  * We need to know the index of the table that is being removed from
  * relationship list of the current table.
  */
  
  FIND tempRel WHERE tempRel.tname = relation.
  
  ASSIGN
    oldIndex = tempRel.tid
    tempList = ""
    .
  
  /* Get the record for the current table. */
  FIND tempRel WHERE tempRel.tid = currentTableTid.
  
  /* Walk through the join list and remove the old relation */
  DO qbf-i = 2 TO NUM-ENTRIES(tempRel.rels):
    RUN breakJoinInfo (ENTRY(qbf-i,tempRel.rels),OUTPUT joinIndex,
                       OUTPUT joinType,OUTPUT joinTypeShort,OUTPUT joinWhere).

    IF joinIndex = oldIndex THEN DO:
      /*
       * This is the relationship that is going away. Don't add it to the 
       * list.  If this is a custom relationship then remove the text from 
       * the array. Mainly this is for a fastload write. We don't want to
       * save obsolete information.
       */
      IF joinWhere > 0 THEN DO:
        {&FIND_JOIN_BY_ID} joinWhere. 

        tempJoinWhere.jwhere = "".
      END.
      NEXT.
    END.
  
    tempList = tempList + ",":u + ENTRY(qbf-i,tempRel.rels).
  END.
  
  /* Reset the list */
  tempRel.rels = tempList.
 
  IF fixGUI THEN DO: 
    /* Make the list have a current selection. Much nicer for the user */
    IF jx > relationList:NUM-ITEMS THEN 
      jx = jx - 1.
  
    relationList:SCREEN-VALUE = IF jx = 0 THEN "" ELSE relationList:ENTRY(jx).

    RUN setRelated (relationList:SCREEN-VALUE).

    RUN figureButtonState.
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE setRelated:
  /* Purpose: To display the various parts of the relation */

  DEFINE INPUT PARAMETER tableName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE joinList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinIndex  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinType   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinWhere  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE story      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE otherTid   AS INTEGER   NO-UNDO.
  
  /*
  * If the table name is empty, then there is nothing
  * in the related tables. Reset the join and where widgets
  */
  DO WITH FRAME {&FRAME-NAME}:
    IF tableName = ? THEN
      joinText:SCREEN-VALUE = "".
  
    ELSE DO:
      /*
      * Figure out and retrieve the relationship info from the base table.
      * We are trying to figure get information about the relationship
      * of the new table as it relates to the base table.
      */
  
      FIND tempRel WHERE tempRel.tname = tableName NO-ERROR.
      otherTid = tempRel.tid.
  
      /* Switch context back to the basetable */
      FIND tempRel WHERE tempRel.tid = currentTableTid.
  
      joinList = tempRel.rels.
  
      /* Find the right join element in the list of joins for the table */
      DO qbf-i = 2 TO NUM-ENTRIES(joinList):
        RUN breakJoinInfo (ENTRY(qbf-i,joinList),OUTPUT joinIndex,
                           OUTPUT joinType,OUTPUT joinTypeShort,
                           OUTPUT joinWhere).
  
        IF (otherTid = joinIndex) THEN LEAVE.
      END.
  
      /*
      * There is something in the join-where text if relationship
      * contains a ":". Otherwise, just write out table OF table2
      */
      RUN figureJoinText ("standard":u, joinWhere, tableName, tempRel.tname,
                          OUTPUT story).
  
      joinText:SCREEN-VALUE = story.
    END.
  END.
END PROCEDURE. /* setRelated */

/* ----------------------------------------------------------- */
PROCEDURE editRelationship:
  DEFINE INPUT  PARAMETER otherName AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER whereOnly AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER cancelled AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE tableName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE joinIndex   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE joinWhere   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE oldJoin     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sx          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE otherIndex  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE otherTabNum AS INTEGER   NO-UNDO.
  DEFINE VARIABLE thisJoin    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE story       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dirtyJoin   AS LOGICAL   NO-UNDO. 

  /*
   * Set up the tables involved. Get the text version of the join type.
   * It is needed to determine direction of the join text.
   */
  RUN adecomm/_setcurs.p ("WAIT":u).
  
  DO WITH FRAME {&FRAME-NAME}:

    /*
     * Get the other tableid. Do a FIND, to make sure that the
     * correct record is being used.
     */
    FIND tempRel WHERE tempRel.tname = otherName.
    otherTabNum = tempRel.tid.

    /*
     * The edits are based on the current table, not the other
     * table. Set the proper record. For example, if the user
     * is currently on customer, and want to add "Item" to
     * "Customer's" list then currentTableTid is the tid of
     * "Customer", the varaible tableNmae and joinList are from
     * "Customer". "Other" variables are for "Item"
     */
    FIND tempRel WHERE tempRel.tid = currentTableTid.
  
    ASSIGN
      _FldList     = ""
      _JoinCode[2] = ""
      joinList     = tempRel.rels
      tableName    = tempRel.tname
    .
    IF _fieldCheck <> ? THEN _CallBack = _fieldCheck.
  
    /*
    * Walk through the join list to find the other table, as well
    * finding out if there is any join-where for this relationship.
    */
    DO qbf-i = 2 TO NUM-ENTRIES(joinList):
      RUN breakJoinInfo (ENTRY(qbf-i,joinList),OUTPUT joinIndex,OUTPUT sx,
                         OUTPUT joinTypeShort,OUTPUT joinWhere).
  
      /* Stop as soon as we find a match */
      IF (otherTabNum = joinIndex) THEN LEAVE.
    END.
  
    otherIndex = qbf-i.
    RUN figureJoinText ("query":u,joinWhere,otherName,tableName,OUTPUT story).

    ASSIGN
      _TblList = tableName + ",":u + story
      _TblList = REPLACE (_TblList,",":u,{&Sep1})
      .
  
    /*
     * See if this name is an alias. If it is then give the reference table
     * name to the query editor.
     */
    RUN alias_to_tbname (otherName,TRUE,OUTPUT sx).

    IF sx = otherName THEN
      sx = "".
    _AliasList = sx.
  
    RUN alias_to_tbname (tableName,TRUE,OUTPUT sx).

    IF sx = tableName THEN
      sx = "".
    _AliasList = _AliasList + ",,":u + sx.

    /* If neither table is an alias then send an empty alias list */
    IF (ENTRY(1,_AliasList) = "" AND ENTRY(3,_AliasList) = "") THEN
      _AliasList = "".
  
    /* If this is a customized join, then load in the text of the join clause */
    IF joinWhere > 0 THEN DO:
      {&FIND_JOIN_BY_ID} joinWhere.

      ASSIGN
        _JoinCode[2] = tempJoinWhere.jwhere
        oldJoin      = _JoinCode[2].
    END.

    RUN adeshar/_query.p ("",                /* browser-name */
                          FALSE,             /* suppress_dbname */
                          "Results_Join":u,  /* application */
                          "Join":u,          /* pcValidStates */
                          NO,                /* plVisitFields */
                          YES,               /* auto_check */
                          OUTPUT cancelled).

    IF (joinWhere = 0 AND (_JoinCode[2] = ? OR _JoinCode[2] = ""))
      OR cancelled THEN RETURN.

    ASSIGN
      _JoinCode[2] = (IF _JoinCode[2] = ? THEN "" ELSE _JoinCode[2])
      _TblList     = REPLACE (_TblList, {&Sep1}, ",":u).
  
    /*
     * Update the data structures. The _Joincode is an array, one element for
     * each table. Our data structure is an array of existing join-wheres.
     * That's why there's the number after the : in the join relationship.
     * It is the array index.
     * 
     * There are 2 cases that deal with:
     *
     *     OF ->    OF     joinWhere is 0 and entry 2 has OF
     *     OF ->    WHERE  joinWhere is 0 and entry 2 has WHERE
     *     WHERE -> WHERE  joinWhere >  0 and entry 2 has WHERE
     *                     This code will update, even if the contents haven't
     *                     changed
     *     WHERE - > OF    joinWhere > 0 and entry 2 has OF
     *     WHERE - > OF    joinWhere > 0 and entry 2 has WHERE and
     *                     _JoinCode[2] = ?
     */

    IF (joinWhere = 0) AND (INDEX(ENTRY(2,_TblList)," WHERE ":u) > 0) THEN 
    DO:
  
      /*
       * The join has been customized, where it was a standard join or no 
       * join before. Add a new entry into the WHERE array. Then update
       * the join relation.
       */
      ASSIGN
        dirtyJoin                  = TRUE
        tempWhereCount             = tempWhereCount + 1
        .

      {&FIND_JOIN_BY_ID} tempWhereCount NO-ERROR.
      IF NOT AVAILABLE tempJoinWhere THEN DO:
        CREATE tempJoinWhere.
        tempJoinWhere.wid = tempWhereCount.
      END.
      tempJoinWhere.jwhere         = _JoinCode[2].
  
      /*
      * Tack on the WHERE clause onto the existing relationship
      * information. Then we don't have to recreate the entire
      * relationship.
      */
      ASSIGN
        thisJoin                   = ENTRY(otherIndex,joinList)
                                   + ":":u + STRING(tempWhereCount)
        ENTRY(otherIndex,joinList) = thisJoin
        tempRel.rels               = joinList
        qbf-i                      = tempWhereCount
        .
    END.
    IF    (joinWhere > 0)
      AND (INDEX(ENTRY(2,_TblList)," WHERE ":u) > 0)
      AND (_JoinCode[2] <> ?) THEN DO:
  
      /*
       * The value of the customized join has been changed. Update the 
       * proper join-where array element. The join relation does not have 
       * to be updated.
       */
      {&FIND_JOIN_BY_ID} joinWhere.

      ASSIGN
        dirtyJoin            = TRUE
        tempJoinWhere.jwhere = _JoinCode[2]
        qbf-i                = tempWhereCount.

      IF oldJoin > "" AND _JoinCode[2] = "" THEN
        APPLY "CHOOSE":u TO deleteBut. 
    END.
  
    IF   ((joinWhere > 0) AND (INDEX(ENTRY(2,_TblList)," OF ":u) > 0))
      OR ((joinWhere > 0) AND (INDEX(ENTRY(2,_TblList)," WHERE ":u) > 0)
      AND (_JoinCode[2] = ?)) THEN DO:
      /*
       * The customized join has reverted back to an OF. The join-where 
       * array element will be cleaned out but not reused. Update the join 
       * relation
       */

      {&FIND_JOIN_BY_ID} joinWhere.

      ASSIGN
        qbf-i                      = 0
        dirtyJoin                  = TRUE
        tempJoinWhere.jwhere       = ""
        thisJoin                   = ENTRY(otherIndex,joinList) 
                                   + ":":u + STRING(tempWhereCount)
        thisJoin                   = SUBSTRING(ENTRY(otherIndex,joinList),1,
                                     INDEX(thisJoin,":":u) - 1,"CHARACTER":u)
        ENTRY(otherIndex,joinList) = thisJoin
        tempRel.rels               = joinList
        . 
    END.

    /* Change the screen value */
    
    IF NOT (oldJoin = "" AND _JoinCode[2] = "")
      AND dirtyJoin THEN DO:
      /*
       * If the user made any changes to the join or to the where
       * then update the GUI
       */
      RUN figureJoinText ("standard":u,qbf-i,otherName,tableName,OUTPUT story).
  
      ASSIGN
        joinText:SCREEN-VALUE = story
        dirty                 = TRUE
        .
    END.
  END.
END PROCEDURE. /* editRelationship */

/* { aderes/s-alias.i } */

&UNDEFINE FRAME-NAME

/* _arships.p - end of file */

