
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _mfldlst.p

Description:
   Fill a selection list with fields from MULTIPLE tables.  The fields
   will be ordered either either alphabetically or by order #.

Input Parameters:
   p_List   - Handle of the selection list widget to add to.
   p_TblList- A comma list of database.table names.
   p_TT     - ? if no temp-tables need to be included.
              Otherwise a comma delimitted list where each entry has the form:
              _like-db._like-table|_name
              The _like-db and _like-table are real database.table combinations
              and _name is either the name of the temp-table that is like
              _like-table or ? if it is the same.
   p_Alpha  - true if order should be alphabetical, false if we want to
      	      order by the _Order value of the field.
   p_Items  - String of items to place in the selection list.  If this
              is blank _mfldlst.p will select an appropriate default.
              IF one table being selected THEN
                just field name
              ELSE IF all tables in one database THEN
                tablename.fieldname
              ELSE
                dbname.tablename.fieldname

  p_ExpandExtent - true if the array extents are to be expanded

  p_Callback - Pass on to _mfldlist as the name of the program to run 
              for security puposes or pass "" to blow this off.

Output Parameters:
   p_Stat   - Set to true if list is retrieved (even if there were no fields
      	      this is successful).  Set to false, if user doesn't have access
      	      to fields.

Author: Warren Bare

Date Created: 08/03/92

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List      AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_TblList   AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_TT        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Alpha     AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER p_Items     AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_expandExt AS INTEGER       NO-UNDO.
DEFINE INPUT  PARAMETER p_CallBack  AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat      AS LOGICAL       NO-UNDO.

DEFINE VARIABLE cTTName      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cType        AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i            AS INTEGER              NO-UNDO.
DEFINE VARIABLE iNumItems    AS INTEGER              NO-UNDO.
DEFINE VARIABLE iNumTT       AS INTEGER              NO-UNDO.
DEFINE VARIABLE use-table    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v_Tblname    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v_TmpName    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v_ListCnt    AS INTEGER              NO-UNDO.
DEFINE VARIABLE v_LDBNames   AS CHARACTER EXTENT 50  NO-UNDO.
DEFINE VARIABLE v_TblIDs     AS RECID     EXTENT 50  NO-UNDO.
DEFINE VARIABLE v_ThisDBID   AS RECID                NO-UNDO.
DEFINE VARIABLE v_ThisDBName AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v_LastDBName AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v_MultiDB    AS LOGICAL              NO-UNDO.
DEFINE VARIABLE v_OldDictdb  AS CHARACTER            NO-UNDO.

v_olddictdb = ldbname("DICTDB":u).

/*
** First we loop through the databases.  We need to see if they are all in
** the same db.  If they are, then by default, we will not show the dbname
** in the selection list we build.
*/

DO v_ListCnt = 1 TO MINIMUM(50,NUM-ENTRIES(p_TblList)):
  v_TmpName = ENTRY(v_ListCnt,p_TblList).

  /* If they did not pass a dbname, find the db this tbl is in */
  IF NUM-ENTRIES(v_TmpName,".":u) = 1 THEN DO:
    v_TblName  = v_TmpName.
    /* Perhaps a buffer name */
    BUFFER-SEARCH-BLOCK:
    REPEAT i = 1 TO NUM-ENTRIES(p_TT):
      IF v_TblName = ENTRY(2, ENTRY(i,p_TT), "|":U) THEN DO:
        ASSIGN v_ThisDBName = ENTRY(1, ENTRY(i ,p_TT), ".":U)
               v_TblName    = ENTRY(2, ENTRY(1, ENTRY(i, p_TT), "|":U),
                                             ".":U).
        LEAVE BUFFER-SEARCH-BLOCK.
      END.  /* Found the buffer */
    END.  /* REPEAT */
    RUN adecomm/_gttbldb.p (v_TblName, OUTPUT v_ThisDBName,
                            OUTPUT v_ThisDBID, OUTPUT v_TblIDs[v_ListCnt]).
  END.
  ELSE DO:
    IF v_TmpName BEGINS "Temp-Tables.":U THEN DO:
      /* This entry of p_TblList is a temp-table.  Replace it with the 
         "real" db info for these id info lookups                       */
      SEARCH-BLOCK:
      REPEAT i = 1 TO NUM-ENTRIES(p_TT):
        IF ENTRY(2, v_TmpName, ".":U) = ENTRY(2, ENTRY(i,p_TT), "|":U) OR
          (ENTRY(2, v_TmpName, ".":U) = ENTRY(2, ENTRY(1, ENTRY(i,p_TT), "|":U),
                                                 ".":U) AND
                 ENTRY(2, ENTRY(i,p_TT), "|":U) = "?") THEN DO:
          ASSIGN v_ThisDBName = ENTRY(1, ENTRY(i ,p_TT), ".":U)
                 v_TblName    = ENTRY(2, ENTRY(1, ENTRY(i, p_TT), "|":U),
                                          ".":U).
          LEAVE SEARCH-BLOCK.
        END. /* IF found it */
      END. /* SEARCH-BLOCK REPEAT i = 1 TO NUM-ENTRIES */
    END. /* IF a temp-table */
    
    ELSE DO: /* Normal situation */
      ASSIGN v_ThisDBName = ENTRY(1,ENTRY(v_ListCnt,p_TblList),".":u)
             v_TblName    = ENTRY(2,ENTRY(v_ListCnt,p_TblList),".":u).
    END.  /* Normal situation */
    
    RUN adecomm/_getdbid.p (v_ThisDBName, OUTPUT v_ThisDBID).
    IF v_ThisDBID = ? THEN NEXT.
    RUN adecomm/_gttblid.p (v_ThisDBID, v_TblName, OUTPUT v_TblIDs[v_ListCnt]).
  END.

  IF v_TblIDs[v_ListCnt] = ? THEN NEXT.
  IF v_ListCnt > 1 AND v_LastDBName NE v_ThisDBName THEN
    v_MultiDB = yes.

  ASSIGN v_LDBNames[v_ListCnt] = LDBNAME("DICTDB":u)
         v_LastDBName = v_ThisDBName.
END.  /* End loop through p_TblList */

/* If they want default items, what should they be? */
IF p_Items = ""  THEN DO:
  IF NUM-ENTRIES(p_TblList) = 1 THEN
    p_Items = "1":u.
  ELSE
  IF NOT v_MultiDB THEN
    p_Items = "2":u.
  ELSE
    p_Items = "3":u.
END.

/* If they want default items, what should they be? */
ELSE IF p_Items = "4":u  THEN DO:
  IF num-dbs = 1 AND NUM-ENTRIES(p_TblList) = 1 THEN
    p_Items = "1":u.
  ELSE
  IF num-dbs = 1 THEN
    p_Items = "2":u.
  ELSE
    p_Items = "3":u.
END.

DO v_ListCnt = 1 to MINIMUM(50,NUM-ENTRIES(p_TblList)):
  IF v_TblIDs[v_ListCnt] = ? THEN NEXT.

  CREATE ALIAS DICTDB FOR DATABASE VALUE(v_LDBNames[v_ListCnt]).
  IF ENTRY(v_ListCnt,p_TblList) BEGINS "Temp-Tables":U THEN
    use-table = ENTRY(2, ENTRY(1, ENTRY(v_ListCnt, p_TblList), "|":U),
                         ".":U).
  ELSE use-table = ?.

  /* We need to store the number of items before adding additional fields
     to the list in order to change the DB Name to Temp-Table (if necessary)
     below for this table only */
  iNumItems = p_List:NUM-ITEMS.

  /* now add the fields for this table to the list */
  RUN adecomm/_getflst.p(p_List,
                         v_TblIDs[v_ListCnt],
                         use-table,
                         p_Alpha,
                         p_Items,
                         ?,
                         p_ExpandExt,
                         p_CallBack,
                         OUTPUT p_Stat).
  
  IF use-table NE ? AND p_items = "3" THEN DO:
    DO i = iNumItems + 1 TO p_List:NUM-ITEMS:
      REPEAT iNumTT = 1 TO NUM-ENTRIES(p_TT):
        /* p_TT is in the format of dbname.tablename|temp-tablename|type
           where type is "T" for temp-table or "B" for buffer */        
        ASSIGN cTTName = ENTRY(2, ENTRY(iNumTT, p_TT), "|":U)
               cType   = ENTRY(3, ENTRY(iNumTT, p_TT), "|":U).
        /* If this is a buffer then we don't want to replace the db table name with "Temp-Tables",
           we want to replace it with nothing so that only the buffer name and field name
           display on the Available Fields list */
        IF ENTRY(2, p_List:ENTRY(i), ".":U) = cTTName THEN DO:
          /* prepend dbname with blank for replace to avoid replacing table and fields */  
          IF cType = "B":U THEN
            p_List:REPLACE(REPLACE(" " + p_List:ENTRY(i), " " + v_LDBNames[v_ListCnt] + ".":U, ""), i).
          ELSE 
            p_List:REPLACE(REPLACE(" " + p_List:ENTRY(i)," " + v_LDBNames[v_ListCnt], "Temp-Tables":U), i).
        END.  /* if list item = temp-table name */                                                                                       
      END.  /* REPEAT - for each temp-table defined */
    END. /* For each item */
  END.  /* If working with a temp-table and fully qualified */
END.

IF v_Olddictdb NE ? THEN
  CREATE ALIAS DICTDB FOR DATABASE VALUE(v_OldDictDb).

/* _mfldlst.p - end of file */

