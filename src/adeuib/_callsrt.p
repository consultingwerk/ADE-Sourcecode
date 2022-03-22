/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _callsrt.p

Description:
   This code will bring up the Progress Query Builder Sort Screen.

Input Parameters:
    p_TblList - List of Tables

Input-Output Parameters:  
    p_OrdList - List of Options                    

Output Parameters:  
    p_OK - User pressed OK.                    
   
Author: Wm.T.Wood   

Date Created: 11/20/92   

----Testing Code:-----------------------------------------------------------
    DEF VAR p_OrdList AS CHARACTER NO-UNDO.
    DEF VAR p_OK      AS LOGICAL NO-UNDO INITIAL yes.   
    DO WHILE p_OK:
      RUN adeuib/_callsrt.p ("sports.customer,sports.order", 
                             INPUT-OUTPUT p_OrdList, OUTPUT p_OK).
      MESSAGE REPLACE(p_OrdList, ",":U, CHR(10)) VIEW-AS ALERT-BOX.
    END.
----------------------------------------------------------------------------*/
DEFINE INPUT         PARAMETER p_TblList AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER p_OrdList AS CHARACTER NO-UNDO.
DEFINE       OUTPUT  PARAMETER p_OK      AS LOGICAL NO-UNDO.

{adeuib/sharvars.i } 
{adeshar/quryshar.i "NEW GLOBAL" }

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/********************** In Line Code Section ********************/

DEFINE VARIABLE v_TblNum       AS INTEGER                           NO-UNDO.
DEFINE VARIABLE iCnt           AS INTEGER                           NO-UNDO.
DEFINE VARIABLE lSingleTable   AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE lSingleDB      AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE cTempLine      AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTempWord      AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE lDummy         AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE pressed_Cancel AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE ftype          AS CHARACTER                         NO-UNDO.

/* Make sure there is at least one database connected (and that
   DICTDB is defined). */
IF NUM-DBS = 0 THEN DO:
  RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to edit Sort phrases." ,
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

/* Initialize the shared query variables */
ASSIGN _JoinCode    = ""
       _Where       = ""
       _TblList     = p_TblList  
       _OrdList     = p_OrdList
       _optionlist  = ""
       _TuneOptions = ""
       _TblOptList  = ""
       .    

/* UPDATE FROM _Q TEMP FILE */
/* Are we dealing with multiple tables and databases in the List of Tables? 
   (NOTE: If there is a NON-PROGRESS database, we will have NUM-DBS = 1, but there
   will be a Schema Holder Database in addition to the Logical Database.  We want to 
   treat this condition as multiple databases even though NUM-DBS is 1.) */
ASSIGN lSingleTable = (NUM-ENTRIES(_TblList) eq 1)
       lSingleDB    = (NUM-DBS eq 1 AND NOT CAN-FIND (_Db where _Db._Db-type NE "PROGRESS"))
       .
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
        IF (NUM-ENTRIES (cTempWord, ".") = 2) THEN
          ENTRY (iCnt, cTempLine, " ") = ENTRY (2, cTempWord, ".").
      END.
    END.
    ENTRY (v_TblNum, _TblList) = cTempLine.
  END.  
END.

/* Use Sep1 for the seperator inside the Query Builder */
ASSIGN _TblList   = REPLACE ( _TblList,  ",", {&Sep1}) .
   
/* Now table the DB name and/or table name out of the _OrdList (i.e. sort
   information).  Note that items in OrdList are of the form "db.tbl.fld|no" */
iCnt = NUM-ENTRIES (_OrdList).     
DO v_TblNum = 1 TO iCnt:   
  /* If we have a single table, then _OrdList only needs to reference the Field
     (i.e. the last entry in cTempWord). If we have only one Database, 
     then _OrdList need not reference the database.  
     [NOTE: Taking ENTRY(3, "db.tbl.fld|no", "." will get the "|no" part.]
   */
  IF lSingleTable THEN 
    ENTRY(v_TblNum,_OrdList) = ENTRY (3, ENTRY(v_TblNum,_OrdList), ".":U).
  ELSE IF lSingleDB THEN
    ENTRY(v_TblNum,_OrdList) = ENTRY (2,ENTRY(v_TblNum,_OrdList),".":U) + 
                               ".":U + ENTRY (3,ENTRY(v_TblNum,_OrdList),".":U).  
END.

/* Use Sep1/Sep2 for the seperator inside Query Builder. */
ASSIGN  _OrdList  = REPLACE (_OrdList, ",":U, {&Sep1})
        _OrdList  = REPLACE (_OrdList, "|":U, {&Sep2})
        . 

RUN adeshar/_query.p ("",    /* Browser name to be editted. */
                     _suppress_dbname, 
                     "AB", 
                     "Sort", /* Valid Options. */
                     FALSE,  /* Don't force visit to FIELDS dialog */
                     FALSE,  /* Don't automatically check Syntax*/
                     OUTPUT pressed_Cancel).

/* Store the results (unless the user Cancelled out of the Query Builder */
IF NOT pressed_Cancel THEN DO:       
  /* Pressed OK. */
  p_OK = yes.

  /* For each Item in p_OrdList: add in the db.table name, if necessary */
  ASSIGN p_OrdList = _OrdList.
  DO v_TblNum = 1 TO NUM-ENTRIES (p_OrdList, {&Sep1}):
    ASSIGN cTempLine = ENTRY(v_TblNum, p_OrdList, {&Sep1})
           iCnt      = NUM-ENTRIES (cTempLine, ".").
    /* If the orderlist is of the form "field|yes", then we have only one
       table and we can add in the p_TblList. */      
    IF iCnt eq 1 and INDEX(cTempLine,"(":U) = 0 AND INDEX(cTempLine," ":U) = 0 THEN 
      ENTRY(v_TblNum, p_OrdList, {&Sep1}) =
             ENTRY(1, p_TblList) + ".":U + cTempLine.
    ELSE IF iCnt eq 2 and INDEX(cTempLine,"(":U) = 0 AND 
            INDEX(cTempLine," ":U) = 0 THEN 
      ENTRY(v_TblNum, p_OrdList, {&Sep1}) = LDBNAME (1) + ".":U + cTempLine.    
  END. 
  
  /* Change back the seperators. */
  ASSIGN p_OrdList     = REPLACE (p_OrdList, {&Sep1}, ",")
         p_OrdList     = REPLACE (p_OrdList, {&Sep2}, "|").
END. /* IF NOT pCancelButton */
