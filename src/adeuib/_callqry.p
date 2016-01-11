/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _callqry.p

Description:
   This code will bring up the dialog box frame that allows the developer
   to define the files and their query relationships used in a browse.

Input Parameters:
    prRECID - RECID of _U record 
    pcMode - Mode of operation (A comma delimitted string)
                 ?, "" or "NORMAL"   -- Edit only
                 "QUERY-ONLY"        -- don't show "Fields" option
                 "CHECK-FIELDS"      -- Don't OK dialog until fields have
                                          been entered
                 "NO-FREEFORM-QUERY" -- Don't enable the freeform query button.
                       
   
Author: Greg O'Connor

Date Created: 11/20/92   

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER rec-type        AS CHARACTER                  NO-UNDO.
DEFINE INPUT PARAMETER prRECID         AS RECID                      NO-UNDO.
DEFINE INPUT PARAMETER pcMode          AS CHARACTER                  NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/sharvars.i}
{adecomm/adefext.i}
{adeshar/quryshar.i "NEW GLOBAL"}
{adecomm/tt-brws.i "NEW"}

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/********************** In Line Code Section ********************/

DEFINE VARIABLE v_TblNum       AS INTEGER                           NO-UNDO.
DEFINE VARIABLE DBNm           AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE DBid           AS RECID                             NO-UNDO.
DEFINE VARIABLE iCnt           AS INTEGER                           NO-UNDO.
DEFINE VARIABLE iXternalCnt    AS INTEGER                           NO-UNDO.     
DEFINE VARIABLE lMode          AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE lSingleTable   AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE lSingleDB      AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE TblId          AS RECID                             NO-UNDO.
DEFINE VARIABLE cTempExtTbls   AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTempLine      AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTempWord      AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cValidStates   AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE lDummy         AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE lCheckFields   AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE pressed_Cancel AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE answer         AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE ftype          AS CHARACTER                         NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_C FOR _C.
DEFINE BUFFER parent_Q FOR _Q.

/* Make sure there is at least one database connected (and that
   DICTDB is defined). */
IF NUM-DBS = 0 THEN DO:
  RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to create a query." ,
      OUTPUT lDummy).
  IF lDummy = NO THEN RETURN.
END.
/* Now check for DICTDB - it is ? if it is not defined. */
IF LDBNAME("DICTDB":U) eq ? 
THEN CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(1)).

/* Set correct dictdb */
DO iCnt = 1 TO NUM-DBS:
  IF DBTYPE(iCnt) = "PROGRESS":U THEN DO:
    CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(iCnt)).
  END.
END.

IF rec-type = "_U":U THEN DO:
  /* FIND the Universal Widget Records for the BROWSE or FRAME                */
  FIND _U WHERE RECID(_U)  = prRECID.
  FIND _C WHERE RECID(_C)  = _U._x-recid.
  FIND _Q WHERE RECID(_Q)  = _C._q-recid.
END.
ELSE DO:  /* Error - Note at one time we supported a Procedure Query associated
             with a _P record (wood). */
  MESSAGE "[{&FILE-NAME}]" SKIP
          "Unexpected record-type:" rec-type SKIP
          "Cannot find associated query."
          VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

/* Populate _tt-tbl and _tt-fld records if necessary */
FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
/* Omit D and W types-- those are used to track temp-table info for
   SmartDataViewer and Web-Objects by AB and not meant to be exposed to
   user here. jep-code 4/22/98 */
IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                        AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE)) THEN
DO:
  FOR EACH _TT WHERE _TT._p-recid = RECID(_P)
                 AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE):
    CREATE _tt-tbl.
    ASSIGN _tt-tbl.tt-name    = IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME
           _tt-tbl.like-db    = _TT._LIKE-DB
           _tt-tbl.like-table = _TT._LIKE-TABLE
           _tt-tbl.table-type = _TT._TABLE-TYPE.
    CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(SDBNAME(_TT._LIKE-DB)).
    /* Build the field records for this table */       
    RUN adecomm/_bldfld.w (INPUT RECID(_tt-tbl), INPUT _TT._LIKE-TABLE).
  END. /* FOR EACH _TT */
  
END. /* IF There are any _TT records */


ASSIGN _JoinCode    = ""
       _Where       = ""
       _TblList     = _Q._TblList 
       _optionlist  = ""
       _TuneOptions = _Q._TuneOptions
       _TblOptList  = _Q._TblOptList.    
 
/* If this is a BROWSE or a FRAME, get the list of eXternal Tables 
   (defined in the query for the FRAME containing the browse or frame).  
   - - - - - - - - - - - - - - - NOTE - - - - - - - - - - - - - - 
   It is possible that the external tables can set a record buffer for the
   same items as internally set.  (This might happen if the FRAME query were
   modified to include a table from the BROWSE, or if a BROWSE were imported
   into the UIB.  The Query Builder cannot handle this case.  So don't 
   include duplicated tables in the list of external tables. 
   [This code can be removed if the QB is re-written (wood 7/27/94) ]
 */
                                                              
/* Create a temporary list of tables in the browse or frame query. Each entry in
   the _TblList is of the form "db.table [OF|WHERE db.tbl2]". */
cTempLine = _TblList.
DO v_TblNum = 1 TO NUM-ENTRIES (cTempLine):
  ENTRY(v_TblNum, cTempLine) = ENTRY(1, ENTRY(v_TblNum, cTempLine), " ":U).
END.

/* Get the list of external tables for this query record. */
RUN adeuib/_tbllist.p (INPUT RECID(_U), INPUT FALSE, OUTPUT cTempExtTbls).
 
/* Add each table in the external list (in cTempExtTbls) as an external item
   in _TblList if it is not in cTempLine (the list of tables in the current BROWSE
   or FRAME).  Check the list backwards and add it to the front of _TblList because
   we want to maintain the order in parent_Q._TblList. */
iXternalCnt = 0.
DO v_TblNum = NUM-ENTRIES(cTempExtTbls) TO 1 BY -1:
  cTempWord = ENTRY(v_TblNum, cTempExtTbls).
  IF NOT CAN-DO (cTempLine, cTempWord) THEN DO:
    IF _TblList = "" 
    THEN _TblList = cTempWord + " <external>":U.
    ELSE _TblList = cTempWord + " <external>,":U + _TblList.
    iXternalCnt = iXternalCnt + 1.
  END.
END.
/* Necessary for _BC records and freeform queries. */
_query-u-rec = RECID(_U).  

/* UPDATE FROM _Q TEMP FILE */
/* Are we dealing with multiple tables and databases in the List of Tables? 
   (NOTE: If there is a NON-PROGRESS database, we will have NUM-DBS = 1, but there
   will be a Schema Holder Database in addition to the Logical Database.  We want to 
   treat this condition as multiple databases even though NUM-DBS is 1.) */
ASSIGN lSingleTable = (NUM-ENTRIES(_TblList) eq 1)
       lSingleDB    = (NUM-DBS eq 1 AND NOT CAN-FIND(_Db where _Db._Db-type NE "PROGRESS"))
       .
/* Perhaps we have a TEMP-TABLES virtual DB */
IF lSingleDB AND NOT lSingleTable AND
   INDEX(_TblList,"TEMP-TABLES":U) > 0 THEN DO:
  /* We know at least one table is from TEMP-TABLES, is there any table that isn't? */
  DO v_TblNum = 1 TO NUM-ENTRIES (_TblList):
    cTempLine = ENTRY(v_TblNum, _TblList).
    IF ENTRY(1,cTempLine,".":U) NE "TEMP-TABLES":U THEN lSingleDB = FALSE.
  END. /* DO scan thrugh the table-list */
END.

/* IF we have a single Database, then remove the DB name from the Table List */
IF lSingleDB THEN DO:
  DO v_TblNum = 1 TO NUM-ENTRIES (_TblList) :
    cTempLine = ENTRY (v_TblNum, _TblList).

    /* An entry in _TblList can be of the form "TABLE" or "TABLE OF OTHER-TABLE" or
       "TABLE WHERE OTHER-TABLE ...".  For the TABLE or OTHER-TABLE, we want to strip
       out and database reference (eg "DB.TABLE" becomes "TABLE").  */
    DO iCnt = 1 TO NUM-ENTRIES (cTempLine, " "):
      IF (iCnt = 1 OR iCnt = 3) THEN DO:
        cTempWord = ENTRY (iCnt, cTempLine, " ").
        IF (NUM-ENTRIES (cTempWord, ".") = 2) THEN DO:
          IF ENTRY(1,cTempWord,".") NE "Temp-Tables":U THEN
            ENTRY (iCnt, cTempLine, " ") = ENTRY (2, cTempWord, ".").
        END.
      END.
    END.
    ENTRY (v_TblNum, _TblList) = cTempLine.
  END.  
END.

/* Use Sep1 for the seperator inside the Query Builder */
ASSIGN _TblList   = REPLACE ( _TblList,  ",", {&Sep1}) .
   
/* Now table the DB name and/or table name out of the _OrdList (i.e. sort
   information).  Note that items in OrdList are of the form "db.tbl.fld|no" */
ASSIGN _OrdList = _Q._OrdList
       iCnt     = NUM-ENTRIES (_OrdList).     
DO v_TblNum = 1 TO iCnt:   
  /* If we have a single table, then _OrdList only needs to reference the Field
     (i.e. the last entry in cTempWord). If we have only one Database, 
     then _OrdList need not reference the database.  
     [NOTE: Taking ENTRY(3, "db.tbl.fld|no", "." will get the "|no" part.]
   */
  IF lSingleTable THEN 
    ENTRY(v_TblNum,_OrdList) = ENTRY (NUM-ENTRIES(ENTRY(v_TblNum,_OrdList), "."), ENTRY(v_TblNum,_OrdList), ".":U).
  ELSE IF lSingleDB THEN
    ENTRY(v_TblNum,_OrdList) = ENTRY (NUM-ENTRIES(ENTRY(v_TblNum,_OrdList), ".") - 1, ENTRY(v_TblNum,_OrdList),".":U) + 
                               ".":U + ENTRY (NUM-ENTRIES(ENTRY(v_TblNum,_OrdList), "."), ENTRY(v_TblNum,_OrdList),".":U).  
END.

/* Use Sep1/Sep2 for the seperator inside Query Builder. */
ASSIGN  _OrdList  = REPLACE (_OrdList, ",":U, {&Sep1})
        _OrdList  = REPLACE (_OrdList, "|":U, {&Sep2})
        . 

/* Copy the _Q record query Where/Join into shared variables for Query Builder */
DO v_TblNum = 1 TO ({&MaxTbl} - iXternalCnt):
  ASSIGN _JoinCode[v_TblNum + iXternalCnt] = _Q._JoinCode[v_TblNum] 
         _Where[v_TblNum + iXternalCnt]    = _Q._Where[v_TblNum].
END. 

ASSIGN _Optionlist = _Q._Optionlist. /* set up the lock type and index repos */
     
/* * * * * * * * * * * * **  Run Query Builder.  * * * * * * * * * * * */
/* Convert the pcMode into appropriate Query Builder parameters.       */
ASSIGN lCheckFields    = CAN-DO(pcMode,"CHECK-FIELDS":U ) 
       cValidStates    = "Table,Join,Where,Sort,Options" 
                         + (IF CAN-DO(pcMode,"QUERY-ONLY":U)
                            THEN "":U ELSE ",Fields")
       _freeFormEnable = NOT CAN-DO(pcMODE,"NO-FREEFORM-QUERY":U).

RUN adeshar/_query.p ("", _suppress_dbname, "{&UIB_SHORT_NAME}", 
                     cValidStates, lCheckFields, _auto_check, 
                     OUTPUT pressed_Cancel).
                    
/* useful debug messages - please leave in
 message
         "right out of query.p" skip
          "t=" _TblList skip "o=" _ordlist skip
          "x=" iXternalCnt skip fill("=",80) skip (1.5)
           "t=" entry(1,_tbllist,{&sep1}) skip "j=" _joincode[1] skip "w=" _where[1] skip(1.5) 
           "t=" entry(2,_tbllist,{&sep1}) skip "j=" _joincode[2] skip "w=" _where[2] skip(1.5) 
           "t=" entry(3,_tbllist,{&sep1}) skip "j=" _joincode[3] skip "w=" _where[3] skip(1.5) 
        view-as alert-box. 
*/
/* Store the results (unless the user Cancelled out of the Query Builder */
IF NOT pressed_Cancel THEN DO:                  
  IF (_U._TYPE eq "BROWSE":U)
     OR
     (_U._TYPE eq "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U)
    THEN DO:
    /* Make sure that all _BC records have tables that haven't been removed */
    /* For efficiency make a comma delimitted string of valid tables */
    cTempLine = "".
    DO iCnt = 1 TO NUM-ENTRIES(_TblList,{&SEP1}):
      cTempLine = cTempLine + "," + ENTRY(1,ENTRY(iCnt,_TblList,{&SEP1})," ").
    END.
      
    FOR EACH _BC WHERE _BC._x-recid = _query-u-rec:
      IF _BC._DBNAME NE "_<CALC>":U AND NOT CAN-DO(cTempLine,_BC._TABLE) AND
         NOT CAN-DO(cTempLine,_BC._DBNAME + "." + _BC._TABLE) THEN DO:
        FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
          DELETE _TRG.
        END.
        DELETE _BC.
      END.  /* IF Table has been removed */
    END.
  END.  /* IF a BROWSE */

  /* Strip the External tables out of _TblList */
  IF iXternalCnt > 0 THEN DO:
    iCnt = 0.
    /* Look for the nth seperator */
    DO v_TblNum = 1 TO iXternalCnt:
      iCnt = INDEX(_TblList,{&Sep1},iCnt + 1).
    END.
    IF iCnt > 0 THEN _TblList = SUBSTRING(_TblList, iCnt + 1).
    ELSE _TblList = "".  /* TblList contains only iXternalCnt entries */
  END.
  

  /* If the user emptied the query, ask if they want to keep the query this way. */
  IF CAN-DO ("DIALOG-BOX,FRAME":U, _U._TYPE) THEN DO:
    ftype = (IF _U._TYPE BEGINS "F":U THEN "frame" ELSE "dialog-box").
  
    /* Was the query emptied? */
    IF NUM-ENTRIES (_Q._TblList) > 0 AND _TblList eq "" THEN DO:
      MESSAGE "You have removed all tables from the" ftype "query." {&SKP}
              "Would you like to turn off the automatic maintenance" {&SKP}
              "of the query when database fields are added to the" ftype + "?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
      IF answer eq YES AND LOOKUP ("KEEP-EMPTY":U, _OptionList, " ":U) eq 0
      THEN _OptionList = (IF _OptionList eq "" THEN "" ELSE _OptionList + " ") +
                          "KEEP-EMPTY":U.
    END. /* Query was emptied. */

    /* Was a KEEP-EMPTY query filled? */
    IF _TblList ne "":U AND LOOKUP ("KEEP-EMPTY":U, _Q._OptionList, " ":U) ne 0
    THEN DO:
      MESSAGE "You have added tables to the" ftype "query." {&SKP}
              "Automatic maintenance of the query when database" {&SKP}
              "fields are added to the" ftype "has been turned on."
              VIEW-AS ALERT-BOX INFORMATION.
      /* Remove KEEP-EMPTY from the options.  Also remove any unnecessary
         white-space. */
      ASSIGN _OptionList = REPLACE(_OptionList, "KEEP-EMPTY":U, "":U)
             _OptionList = TRIM(REPLACE(_OptionList, "  ":U, " ":U))
             .
    END. /* Query filled */
  END. /* Frame or Dialog-box */


  /* Copy Tables and Order back into the _Q record */
  ASSIGN  _Q._TblList     = REPLACE (_TblList, {&Sep1}, ",")
          _Q._OptionList  = _Optionlist
          _Q._TuneOptions = _TuneOptions
          _Q._TblOptList  = _TblOptList.

  /* For each Table in _TblList: add in the database name, if necessary */
  DO v_TblNum = 1 TO NUM-ENTRIES (_Q._TblList):

    cTempLine = ENTRY (v_TblNum, _Q._TblList).

    DO iCnt = 1 TO NUM-ENTRIES (cTempLine, " "):
      /* _TblList has three forms:  "TABLE"  "TABLE OF OTHER-TABLE" or 
         "TABLE WHERE OTHER-TABLE..." */
      IF (iCnt = 1 OR iCnt = 3) THEN DO:
        cTempWord = ENTRY (iCnt, cTempLine, " ").
        IF (NUM-ENTRIES (cTempWord, ".") = 1) THEN DO:
          /* This is an attempt to fully qualify the table with the DB name. 
             Unfortunately there is no way to tell for sure that the database
             attached is the correct one (given the current architecture of the
             Query Builder, so at a minimum we will make sure that at least it
             will compile. */
          IF LDBNAME("DICTDB") = LDBNAME(1) AND /* Most likely case here */
             CAN-FIND(FIRST _FILE WHERE _FILE._FILE-NAME = cTempWord) THEN
            ENTRY (iCnt, cTempLine, " ") = LDBNAME (1) + ".":U + cTempWord.
          ELSE DO:  /* Search for the first DB that has cTempWord as a table */
            RUN adecomm/_gttbldb.p (INPUT cTempWord,
                                    OUTPUT DBNm,
                                    OUTPUT DBid,
                                    OUTPUT TblId).
            IF DBNm NE "" THEN
                ENTRY (iCnt, cTempLine, " ") = LDBNAME (DBNm) + ".":U + cTempWord.
          END.  /* Do a search */
        END.  /* If only have a table name */
      END.  /* If we only have a non-qualified table name */
    END.  /* If icnt is 1 or 3 */
    ENTRY (v_TblNum, _Q._TblList) = cTempLine.
  END.  /* Scanning the tokens of cTempLine */

  DO v_TblNum = (iXternalCnt + 1) TO EXTENT (_Where): 
    ASSIGN _Q._JoinCode[v_TblNum - iXternalCnt] = _JoinCode [v_TblNum]
           _Q._Where[v_TblNum - iXternalCnt]    = _Where [v_TblNum]. 
  END.  

  /* For each Item in _Q._OrdList: add in the db.table name, if necessary */
  ASSIGN _Q._OrdList = _OrdList.
  DO v_TblNum = 1 TO NUM-ENTRIES (_Q._OrdList, {&Sep1}):
    ASSIGN cTempLine = ENTRY(v_TblNum, _Q._OrdList, {&Sep1})
           iCnt      = NUM-ENTRIES (cTempLine, ".").
    /* If the orderlist is of the form "field|yes", then we have only one
       table and we can add in the _Q._TblList. */      
    IF iCnt eq 1 and INDEX(cTempLine,"(":U) = 0 AND INDEX(cTempLine," ":U) = 0 THEN 
      ENTRY(v_TblNum, _Q._OrdList, {&Sep1}) =
             ENTRY(1, _Q._TblList) + ".":U + cTempLine.
    ELSE IF iCnt eq 2 and INDEX(cTempLine,"(":U) = 0 AND 
            INDEX(cTempLine," ":U) = 0 THEN 
      ENTRY(v_TblNum, _Q._OrdList, {&Sep1}) = LDBNAME (1) + ".":U + cTempLine.    
  END. 

  ASSIGN _Q._OrdList     = REPLACE (_Q._OrdList, {&Sep1}, ",")
         _Q._OrdList     = REPLACE (_Q._OrdList, {&Sep2}, "|").

/* useful debug message - please leave in ...   
     message 
          "just before qbuild" skip
          "t=" _TblList skip "o=" _ordlist skip
          "x=" iXternalCnt skip fill("=",80) skip (1.5)
           "t=" entry(1,_tbllist,{&sep1}) skip "j=" _joincode[1] skip "w=" _where[1] skip(1.5) 
           "t=" entry(2,_tbllist,{&sep1}) skip "j=" _joincode[2] skip "w=" _where[2] skip(1.5) 
           "t=" entry(3,_tbllist,{&sep1}) skip "j=" _joincode[3] skip "w=" _where[3] skip(1.5) 
        view-as alert-box.  
*/
  /* Now rebuild the query based on all the data in the _Q record. */   
  RUN adeuib/_qbuild.p (RECID(_Q), _suppress_dbname, 0).

  /* Note that the procedure needs to be saved. */
  RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
  
  /* _TblList should never be unknown.  Check for this --- If anyone gets this
     message, it is a mistake. */
  IF _TblList eq ? THEN MESSAGE "_TblList is " _TblList "(This is an ADE/UIB bug)".   
END. /* IF NOT pCancelButton */
