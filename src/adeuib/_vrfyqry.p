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

  File: _vrfyqry.p

  Description:
    This takes a frame and verifies that the default query is correct.  
    We can test for different modes:
      a) ADD-FIELDS add a LIST of fields
      b) REMOVE-FIELDS check that removing a list of fields shouldn't change
         the default query.
                    

  Input Parameters:
    pwFrame - the handle of the frame to test (use _h_frame if ?).
    pcMode  - Mode "ADD-FIELDS"
                   "REMOVE-SELECTED-FIELDS"
    pcList  - [Optional] A list that can contain some other information.
              For pcMode
                 "ADD-FIELDS" - pcList is a comma-delimeted list of 
                                db.tables.field to add. 

  Output Parameters:
      <none>
      
  Notes: Remember that _Q._TblList has comma-seperated entries of the form:
         "DB.TABLE", "DB.TABLE1 OF DB.TABLE" OR  "DB.TABLE2 WHERE DB.TABLE ..."

  Author: Wm.T.Wood

  Created: 01/17/94
 
-----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pwFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER pcMode  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcList  AS CHAR NO-UNDO.

/* Standard Shared Variables */
{ adeuib/sharvars.i }
{ adeuib/uniwidg.i }
{ adeuib/brwscols.i }
{ adeuib/advice.i }   /* Definitions for the advisor */
{ adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */
{ adeuib/triggers.i}

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "~r" + &ENDIF CHR(10)
/* Local Variables */
DEFINE VAR cError_list      AS CHAR     NO-UNDO.
DEFINE VAR db_table         AS CHAR     NO-UNDO.
DEFINE VAR order_list       AS CHAR     NO-UNDO.
DEFINE VAR table_list       AS CHAR     NO-UNDO.
DEFINE VAR db_name          AS CHAR     NO-UNDO.
DEFINE VAR cEdit_query      AS CHAR     NO-UNDO INITIAL "no".
DEFINE VAR lRebuild_query   AS LOGICAL  NO-UNDO.
DEFINE VAR fld_name         AS CHAR     NO-UNDO.
DEFINE VAR tbl_name         AS CHAR     NO-UNDO.
DEFINE VAR i                AS INTEGER  NO-UNDO.
DEFINE VAR j                AS INTEGER  NO-UNDO.
DEFINE VAR tables_in_query  AS CHAR     NO-UNDO.

/* Local Buffers */
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_C FOR _C.
DEFINE BUFFER x_Q FOR _Q.

/* Temp-Tables */
DEFINE TEMP-TABLE tt NO-UNDO
    FIELD _DBNAME LIKE _U._DBNAME
    FIELD _TABLE  LIKE _U._TABLE
    INDEX db_tbl IS UNIQUE PRIMARY _DBNAME _TABLE.

/* If the frame was not specified, then use _h_frame. 
   Find the _P record for the current procedure. */
IF pwFrame eq ? THEN pwFrame = _h_frame.
FIND _U WHERE _U._HANDLE eq pwFrame.
IF _U._WINDOW-HANDLE = ? THEN _U._WINDOW-HANDLE = _h_win.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.

/* Return if this is a freeform query */
IF CAN-FIND(FIRST _TRG WHERE _TRG._wRECID = RECID(_U) AND
                             _TRG._tEVENT = "OPEN_QUERY":U) THEN RETURN.
                             
/* Do we need to check ADD-FIELDS at all? */
CASE _P._add-fields:

  WHEN "NEITHER" THEN DO: /* Do nothing */ END.
  
  WHEN "EXTERNAL-TABLES" THEN DO:
    /* Add/Remove tables to/from the Procedures external tables */  
    
    /* Do the appropriate action */
    lRebuild_query = NO.
    CASE pcMode:
      WHEN "REMOVE-SELECTED-FIELDS":U THEN RUN remove_selected_from_xTblList.
      WHEN "ADD-FIELDS":U THEN RUN add_field_list_to_xTblList.
      OTHERWISE MESSAGE "Invalid Parameter passed to _vrfyqry.p:" pcMode SKIP
                        "This is an ADE/UIB bug resulting from a 4GL coding error."
                        VIEW-AS ALERT-BOX ERROR.
    END CASE.  
  END. /* External-tables */
  
  WHEN "FRAME-QUERY" THEN DO:
    /* Get the rest of the frame information */
    FIND _C WHERE RECID(_C) eq _U._x-recid.
    FIND _Q WHERE RECID(_Q) eq _C._q-recid.
    tables_in_query = _Q._TblList.
    /* Create a comma-delimited list of tables in the default query (based on
       _Q._TblList which has the form "db.table,db.table2 OF db.table,db.table2
       WHERE db.table etc).  So we want only the first ENTRY of each element
       of the list. */
    DO i = 1 TO NUM-ENTRIES(tables_in_query):
      ENTRY(i,tables_in_query) = ENTRY (1, TRIM(ENTRY(i,tables_in_query)), " ":U).
    END.
  
    /* Do the appropriate action */
    lRebuild_query = NO.
    CASE pcMode:
      WHEN "REMOVE-SELECTED-FIELDS":U THEN RUN remove_selected_from_query.
      WHEN "ADD-FIELDS":U 
        THEN DO:
          /* Only add fields if the user doesn't want to keep the query empty. */
          IF LOOKUP("KEEP-EMPTY":U, _Q._OptionList, " ":U) eq 0 
          THEN RUN add_field_list_to_query.
        END.
      OTHERWISE MESSAGE "Invalid Parameter passed to _vrfyqry.p:" pcMode SKIP
                        "This is an ADE/UIB bug resulting from a 4GL coding error."
                        VIEW-AS ALERT-BOX ERROR.
    END CASE.
    
    /* Rebuild the 4GL query if anything has changed, or allow the user to 
       edit it directly (after giving an error message). */
    IF cEdit_query eq ? 
    THEN DO:
      IF {&NA-Edit-Query-vrfyqry} THEN cEdit_query = "no".
      ELSE DO:
        cEdit_query = "yes".
        RUN adeuib/_advisor.w (
        /* Text */        INPUT "Could not create default join for table" +
                                 (IF NUM-ENTRIES(cError_List,CHR(10)) > 1 
                                   THEN "s:" ELSE ":") + CHR(10) + cError_List +
                                   CHR(10) + CHR(10) + 
                                 "You should edit the query for " +
                                  (IF _U._TYPE eq "FRAME":U THEN "frame " ELSE "") + 
                                  _U._NAME + ".",
        /* Options */     INPUT "Edit. Fix the query now.,yes," +
                                "Cancel. Fix the query later.,no",  
        /* Toggle Box */  INPUT TRUE,
        /* Help Tool  */  INPUT "AB",
        /* Context    */  INPUT {&Advisor_No_Join},
        /* Choice     */  INPUT-OUTPUT cEdit_query,
        /* Never Again */ OUTPUT {&NA-Edit-Query-vrfyqry} )  .
      END.
    END.
    
    IF cEdit_query eq "yes"       THEN DO:
      RUN adeuib/_callqry.p ("_U":U, RECID(_U), "QUERY-ONLY":U).
      RUN adeuib/_qbuild.p (RECID(_Q), _suppress_dbname, 1).
    End.
    ELSE IF lRebuild_query THEN RUN adeuib/_qbuild.p (RECID(_Q), _suppress_dbname, 1).
  END. /* ...FRAME-QUERY... */
  
END CASE.

/* **************************************************************************
                            Internal Procedures
   ************************************************************************** */
                            

/* * * * * * * * * * * * * *
 * add_field_list_to_query:
 *
 * Check that the table mentioned in each entry of pcList is also in the default 
 * query for the frame 
 */
PROCEDURE add_field_list_to_query:
  DEF VAR cJoinPartner  AS CHAR NO-UNDO.
  DEF VAR lJoinable     AS LOGICAL NO-UNDO.
  DEF VAR tables_ext2query AS CHAR     NO-UNDO.

  /*  Find the eXternal Tables to the Frame Query. */
  RUN adeuib/_tbllist.p (INPUT  RECID(_U),
                         INPUT  FALSE, /* Don't include self */ 
                         OUTPUT tables_ext2query).

  /* First, create a list of database tables that already exist on the frame
     (and that are not in the list to be added).  We don't want to automatically
     adjust the frame query if a field is already on the frame */
  FOR EACH x_U WHERE x_U._STATUS eq "NORMAL":U
                 AND x_U._parent-recid eq RECID(_U)
                 AND x_U._DBNAME ne ?:
    IF LOOKUP(x_U._DBNAME + ".":U + x_U._TABLE + ".":U + x_U._NAME, pcList) eq 0
    THEN DO:
      FIND tt WHERE tt._DBNAME eq x_U._DBNAME AND tt._TABLE eq x_U._TABLE 
           NO-ERROR.
      IF NOT AVAILABLE tt THEN DO:
        CREATE tt.
        ASSIGN tt._DBNAME = x_U._DBNAME
               tt._TABLE  = x_U._TABLE.
      END.
    END.           
  END.
  
  /* Remember that there can also be BROWSEs in the frame that reference 
     tables.  We also don't want to automatically add tables to the frame
     query that are found in browse queries. */
  FOR EACH x_U WHERE x_U._STATUS eq "NORMAL"
                 AND x_U._parent-recid eq RECID(_U)
                 AND x_U._TYPE eq "BROWSE":U:
    FIND x_C WHERE RECID(x_C) eq x_U._x-recid.
    FIND x_Q WHERE RECID(x_Q) eq x_C._q-recid.
    DO i = 1 TO NUM-ENTRIES (x_Q._TblList):
      /* Each item in TblList has the form (table [OF|WHERE table2]). */
      /* Look for table2 in the tt list. */
      ASSIGN db_table = ENTRY(i, x_Q._TblList)     /* i.e. "db.tbl OF ..." */
             db_table = ENTRY(1, db_table, " ":U)  /* i.e. "db.tbl"        */
             tbl_name = ENTRY(2, db_table, ".")    /* i.e. just "tbl"      */
             db_name  = ENTRY(1, db_table, ".")    /* i.e. just "db"       */
             .
      /* Record any "new" items in the temp-table. */
      FIND tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name NO-ERROR.
      IF NOT AVAILABLE tt THEN DO:
        CREATE tt.
        ASSIGN tt._DBNAME = db_name
               tt._TABLE  = tbl_name.
      END.
    END. /* DO i... */            
  END. /* FOR EACH..."BROWSE"... */
  
  DO i = 1 to NUM-ENTRIES(pcList):
    ASSIGN fld_name = ENTRY(i,pcList)
           db_name =  ENTRY(1,fld_name,".":U)
           tbl_name = ENTRY(2,fld_name,".":U)
           db_table = db_name + ".":U + tbl_name
           .
    /* Is this db.table already in the frame query or in its external tables? 
       (Or is it already represented in the frame -- look at the tt record?) */ 
    IF NOT CAN-DO (tables_in_query, db_table) AND
       NOT CAN-DO (tables_ext2query, db_table) AND
       NOT CAN-FIND (tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name)
    THEN DO:
      lRebuild_query = YES .
      IF tables_in_query eq "":U 
      THEN ASSIGN tables_in_query = db_table
                  _Q._TblList     = db_table
                  .
      ELSE DO:
        FIND-JOIN-BLOCK:
        DO j = 1 TO NUM-ENTRIES (tables_in_query) :
          cJoinPartner = ENTRY (1, ENTRY (j, tables_in_query), " ":U).
          RUN IsJoinable.ip (db_table, cJoinPartner, OUTPUT lJoinable).
          IF lJoinable THEN LEAVE FIND-JOIN-BLOCK.
        END. /* FIND-JOIN-BLOCK */
        /* Add the Table */
        ASSIGN tables_in_query = tables_in_query + ",":U + db_table
               _Q._TblList     = _Q._TblList + ",":U + db_table
               .
        /* Add the Join information */
        IF lJoinable 
        THEN _Q._TblList = _Q._TblList + " OF ":U + cJoinPartner.
        ELSE ASSIGN
               _Q._TblList = _Q._TblList + " WHERE ":U + 
                             ENTRY(1,tables_in_query) + " ...":U 
               /* Note that the query needs editing and create a
                  Line-Feed delimited list of names of "problem" tables. */
               cEdit_query = ?
               cError_list = (IF cError_list ne "":U 
                              THEN cError_list + CHR(10)  ELSE "":U) +
                             "     ":U + db_table.
      END.
    END.
  END.
END PROCEDURE.

/* * * * * * * * * * * * * * *
 * add_field_list_to_xTblList:
 *
 * Check that the table mentioned in each entry of pcList is also in the
 * list _P._xTblList
 */
PROCEDURE add_field_list_to_xTblList:

  /* First, create a list of database tables that already exist in this Window
     (and that are not in the list to be added).  We don't want to automatically
     adjust the xTblList if a field is already on the frame */
  FOR EACH x_U WHERE x_U._STATUS eq "NORMAL":U
                 AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._DBNAME ne ?:
    IF LOOKUP(x_U._DBNAME + ".":U + x_U._TABLE + ".":U + x_U._NAME, pcList) eq 0
    THEN DO:
      FIND tt WHERE tt._DBNAME eq x_U._DBNAME AND tt._TABLE eq x_U._TABLE 
           NO-ERROR.
      IF NOT AVAILABLE tt THEN DO:
        CREATE tt.
        ASSIGN tt._DBNAME = x_U._DBNAME
               tt._TABLE  = x_U._TABLE.
      END.
    END.           
  END.
  
  /* Remember that there can also be BROWSEs in the frame that reference 
     tables.  We also don't want to automatically add tables to the frame
     query that are found in browse queries. */
  FOR EACH x_U WHERE x_U._STATUS eq "NORMAL"
                 AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._TYPE eq "BROWSE":U:
    FIND x_C WHERE RECID(x_C) eq x_U._x-recid.
    FIND x_Q WHERE RECID(x_Q) eq x_C._q-recid.
    DO i = 1 TO NUM-ENTRIES (x_Q._TblList):
      /* Each item in TblList has the form (table [OF|WHERE table2]). */
      /* Look for table2 in the tt list. */
      ASSIGN db_table = ENTRY(i, x_Q._TblList)     /* i.e. "db.tbl OF ..." */
             db_table = ENTRY(1, db_table, " ":U)  /* i.e. "db.tbl"        */
             tbl_name = ENTRY(2, db_table, ".")    /* i.e. just "tbl"      */
             db_name  = ENTRY(1, db_table, ".")    /* i.e. just "db"       */
             .
      /* Record any "new" items in the temp-table. */
      FIND tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name NO-ERROR.
      IF NOT AVAILABLE tt THEN DO:
        CREATE tt.
        ASSIGN tt._DBNAME = db_name
               tt._TABLE  = tbl_name.
      END.
    END. /* DO i... */            
  END. /* FOR EACH..."BROWSE"... */
  
  DO i = 1 to NUM-ENTRIES(pcList):
    ASSIGN fld_name = ENTRY(i,pcList)
           db_name =  ENTRY(1,fld_name,".":U)
           tbl_name = ENTRY(2,fld_name,".":U)
           db_table = db_name + ".":U + tbl_name
           .
    /* Is this db.table already in the table list (Or is it already 
       represented in the window -- look at the tt record?) */ 
    IF NOT CAN-DO(_P._xTblList, db_table) AND
       NOT CAN-FIND(tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name)
    THEN DO:
      IF _P._xTblList eq "":U 
      THEN _P._xTblList = db_table.
      ELSE _P._xTblList = _P._xTblList + ",":U + db_table.
    END.
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose: Check to see if two tables are Joinable.  Technically
           this is a wrapper for j_test which must be
           called twice for thw two possible join directions.
  Input  : cTable1, cTable2- The two tables to test.  
           These must be of the form db.table.
  Output : lJoinable - true if tables can be joined
-------------------------------------------------------------*/
PROCEDURE IsJoinable.ip:
  DEFINE INPUT        PARAMETER cTable1   AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER cTable2   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT       PARAMETER lJoinable AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE real-tbl1 AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE real-tbl2 AS CHARACTER               NO-UNDO.

  ASSIGN real-tbl1 = cTable1   /* Initialize to input params */
         real-tbl2 = cTable2.
         
  /* _j-test assumes that two QBF aliases exist */
  IF ENTRY(1,cTable1,".":U) NE "TEMP-TABLES":U THEN
    CREATE ALIAS "QBF$1" FOR DATABASE VALUE(SDBNAME(ENTRY(1,cTable1,".":U))).
  ELSE DO:
    FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                   _TT._NAME    = ENTRY(2,cTable1,".":U) NO-ERROR.
    IF NOT AVAILABLE _TT THEN
      FIND _TT WHERE _TT._p-recid  = RECID(_P) AND
                   _TT._LIKE-TABLE = ENTRY(2,cTable1,".":U).
    real-tbl1 = _TT._LIKE-DB + "." + ENTRY(2,cTable1,".":U).
    CREATE ALIAS "QBF$1" FOR DATABASE VALUE(SDBNAME(_TT._LIKE-DB)).
  END.

  IF ENTRY(1,cTable2,".":U) NE "TEMP-TABLES":U THEN
    CREATE ALIAS "QBF$2" FOR DATABASE VALUE(SDBNAME(ENTRY(1,cTable2,".":U))).
  ELSE DO:
    FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                   _TT._NAME    = ENTRY(2,cTable2,".":U) NO-ERROR.
    IF NOT AVAILABLE _TT THEN
      FIND _TT WHERE _TT._p-recid  = RECID(_P) AND
                   _TT._LIKE-TABLE = ENTRY(2,cTable2,".":U).
    real-tbl2 = _TT._LIKE-DB + "." + ENTRY(2,cTable2,".":U).
    CREATE ALIAS "QBF$2" FOR DATABASE VALUE(SDBNAME(_TT._LIKE-DB)).
  END.
 
  /* Now run the join test */
  RUN adecomm/_j-test.p (real-tbl1, real-tbl2, OUTPUT lJoinable).

  IF NOT lJoinable 
  THEN RUN adecomm/_j-test.p (real-tbl2,real-tbl1, OUTPUT lJoinable).
END.

/* * * * * * * * * * * * * * * *
 * remove_selected_from_query:
 *
 * Remove all fields that are selected in pwFrame from the query.  To do this:
 *  a) find a list of tables used in the selected objects.
 *  b) remove tables from the list that are not used in other, not-selected,
 *     fields
 */
PROCEDURE remove_selected_from_query:
  DEF VAR tbl_count AS INTEGER   NO-UNDO.
  DEF VAR cDefDB    AS CHARACTER NO-UNDO.
  
  /* Create a list of db.tables that are in selected field */
  FOR EACH x_U WHERE x_U._SELECTEDib
                 AND x_U._parent-recid eq RECID(_U)
                 AND x_U._STATUS eq "NORMAL":U
                 AND x_U._TABLE ne ?:
    IF cDefDB = "":U THEN cDefDB = X_U._DBNAME.
    FIND tt WHERE tt._DBNAME eq x_U._DBNAME AND tt._TABLE eq x_U._TABLE NO-ERROR.
    IF NOT AVAILABLE tt THEN DO:
      CREATE tt.
      ASSIGN tt._DBNAME = x_U._DBNAME
             tt._TABLE  = x_U._TABLE.
    END.
  END.
  /* Are any of these tables used by fields that are not selected.  If so,
     remove them from the list of Tables to Remove from the Query. */
  FOR EACH tt:
    IF CAN-FIND(FIRST x_U WHERE x_U._SELECTEDib NE YES
                            AND x_U._STATUS eq "NORMAL":U
                            AND x_U._parent-recid eq RECID(_U)
                            AND x_U._TABLE  eq tt._TABLE
                            AND x_U._DBNAME eq tt._DBNAME)
    THEN DELETE tt.
  END.
  /* Are any of these tables used by browsers that are not selected.  If so,
     remove them from the list of Tables to Remove from the Query. */
  FOR EACH x_U WHERE x_U._TYPE eq "BROWSE":U  
                 AND x_U._SELECTEDib NE YES
                 AND x_U._STATUS eq "NORMAL":U
                 AND x_U._parent-recid eq RECID(_U):
     FIND x_C WHERE RECID(x_C) eq x_U._x-recid.
     FIND x_Q WHERE RECID(x_Q) eq x_C._q-recid.
     DO i = 1 TO NUM-ENTRIES(x_Q._TblList):
       /* Each item in TblList has the form (table [OF|WHERE table2]). */
       /* Look for table2 in the tt list. */
       db_table = ENTRY(i, x_Q._TblList).
       IF NUM-ENTRIES(db_table," ") > 2 THEN DO:
         ASSIGN db_table = ENTRY(3,db_table," ")
                db_name  = ENTRY(1,db_table,".":U)
                tbl_name = ENTRY(2,db_table,".":U).
         FIND tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name NO-ERROR.
         IF AVAILABLE tt THEN DO:
           /* If the browse has a column referencing the table then add the
              table to the browses table list, else remove the of clause. */
           IF CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U) AND
                                       _BC._DBNAME  = tt._DBNAME AND
                                       _BC._TABLE   = tt._TABLE) THEN
             ASSIGN x_Q._TblList = tt._DBNAME + ".":U + tt._TABLE + ",":U + x_Q._TblList
                    i = i + 1.
           ELSE ENTRY(i, x_Q._TblList) = ENTRY(1, ENTRY(i, x_Q._TblList), " ":U). 
         END.
       END. /* IF db_table has a table2... */         
     END. /* For each db_table... */
     RUN adeuib/_qbuild.p (RECID(x_Q), _suppress_dbname, 0).
  END. /* For each browser in the frame... */
  
  /* Remove each of the remaining tt records from the default query */
  ASSIGN tbl_count = 0
         table_list  = "":U
         order_list  = "":U.
  DO i = 1 TO NUM-ENTRIES (tables_in_query):
    ASSIGN db_table = ENTRY(i, tables_in_query).
    IF NUM-ENTRIES(db_table,".":U) > 1 THEN
      ASSIGN db_name  = ENTRY(1,db_table,".":U)
             tbl_name = ENTRY(2,db_table,".":U)
             .
    ELSE ASSIGN db_name = cDefDB
                tbl_name = ENTRY(1,db_table,".":U).

    /* Is db_table in the query?  If so, skip over it.  If not, copy the
       current entry in the _Q record into the next position */
    IF CAN-FIND(tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name)
    THEN DO:
      /* Check all the Sort-By variables in OrdList to see if they begin
         with the "db.table.".  If so, remove them. */
      ASSIGN lRebuild_query = YES 
             order_list = "":U
             db_table = db_table + ".":U.
      DO j = 1 TO NUM-ENTRIES(_Q._OrdList):
        IF NOT (ENTRY(j,_Q._OrdList) BEGINS db_table) THEN DO:
          IF order_list eq "":U THEN order_list = ENTRY(j,_Q._OrdList).
          ELSE order_list = order_list + ",":U + ENTRY(j,_Q._OrdList).
        END.
      END.
      _Q._OrdList = order_list.
    END.
    ELSE DO:
      tbl_count = tbl_count + 1.
      /* Rebuild the list of tables */
      IF table_list eq "":U THEN table_list = db_table.
      ELSE table_list = table_list + ",":U + ENTRY(i,_Q._TblList).
      /* Move the JoinCode and Where clauses to the new spot */
      ASSIGN _Q._JoinCode[tbl_count] = _Q._JoinCode[i]
             _Q._Where[tbl_count]    = _Q._Where[i].
    END.
  END.
  /* Copy the new table list into the _Q record.  Zero out the array elements
     in _JoinCode and _Where that are no longer used. */
  IF lRebuild_query THEN DO:
    _Q._TblList = table_list.
    DO i = tbl_count + 1 TO NUM-ENTRIES (tables_in_query):
      ASSIGN _Q._JoinCode[i] = ?
             _Q._Where[i]    = ?.
    END.
  END.
END PROCEDURE.

/* * * * * * * * * * * * * * * *
 * remove_selected_from_xTblList
 *
 * Remove all fields that are selected in pwFrame from the xTblList.
 * To do this:
 *  a) find a list of tables used in the selected objects.
 *  b) remove tables from the list that are not used in other, 
 *     not-selected, fields or queries anywhere in the window.
 */
PROCEDURE remove_selected_from_xTblList:
  DEF VAR tbl_count AS INTEGER NO-UNDO.
  
  /* Create a list of db.tables that are in selected field .*/
  FOR EACH x_U WHERE x_U._SELECTEDib
                 AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE 
                 AND x_U._STATUS eq "NORMAL":U
                 AND x_U._TABLE ne ?:
    FIND tt WHERE tt._DBNAME eq x_U._DBNAME AND tt._TABLE eq x_U._TABLE NO-ERROR.
    IF NOT AVAILABLE tt THEN DO:
      CREATE tt.
      ASSIGN tt._DBNAME = x_U._DBNAME
             tt._TABLE  = x_U._TABLE.
    END.
  END.
  /* Are any of these tables used by fields that are not selected.  If so,
     remove them from the list of Tables to Remove. */
  FOR EACH tt:
    IF CAN-FIND(FIRST x_U WHERE x_U._SELECTEDib NE YES
                            AND x_U._STATUS eq "NORMAL":U
                            AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                            AND x_U._TABLE  eq tt._TABLE
                            AND x_U._DBNAME eq tt._DBNAME)
    THEN DELETE tt.
  END.
  /* Are any of these tables used by browsers that are not selected.  If so,
     remove them from the list of Tables to Remove. */
  FOR EACH x_U WHERE x_U._TYPE eq "BROWSE":U  
                 AND x_U._SELECTEDib NE YES
                 AND x_U._STATUS eq "NORMAL":U
                 AND x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE :
     FIND x_C WHERE RECID(x_C) eq x_U._x-recid.
     FIND x_Q WHERE RECID(x_Q) eq x_C._q-recid.
     DO i = 1 TO NUM-ENTRIES(x_Q._TblList):
       /* Each item in TblList has the form (table [OF|WHERE table2]). */
       /* Look for table2 in the tt list. */
       db_table = ENTRY(i, x_Q._TblList).
       IF NUM-ENTRIES(db_table," ") > 2 THEN DO:
         ASSIGN db_table = ENTRY(3,db_table," ")
                db_name  = ENTRY(1,db_table,".":U)
                tbl_name = ENTRY(2,db_table,".":U).
         FIND tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name NO-ERROR.
         IF AVAILABLE tt THEN DELETE tt.            
       END. /* IF db_table has a table2... */         
     END. /* For each db_table... */
  END. /* For each browser in the frame... */

  /* Remove each of the remaining tt records from the default query */
  ASSIGN tbl_count = 0
         table_list  = "":U
         order_list  = "":U.
  DO i = 1 TO NUM-ENTRIES (_P._xTblList):
    ASSIGN db_table = ENTRY(i, _P._xTblList)
           db_name  = ENTRY(1,db_table,".":U)
           tbl_name = ENTRY(2,db_table,".":U)
           .
    /* Is db_table in the list of tables to remove?  If not, copy
       it into the output list.  Otherwise skip over it. */
    IF NOT CAN-FIND(tt WHERE tt._DBNAME eq db_name AND tt._TABLE eq tbl_name)
    THEN DO:
      tbl_count = tbl_count + 1.
      /* Rebuild the list of tables */
      IF table_list eq "":U THEN table_list = db_table.
      ELSE table_list = table_list + ",":U + db_table.
    END.
  END.   
  /* Now save the new value for external tables */
  _P._xTblList = table_list.
END PROCEDURE.


