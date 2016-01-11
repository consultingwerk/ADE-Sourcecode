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
  File: _jfind.p

  Description: 
    Finds all implied OF-join relationships and stores in a temp-table.  If
    this temp-table is empty when this program is run, then it is rebuilt.
    This program is called once by web/objects/web-disp.p to initialize the
    table join temp-table and later by the Query Builder to request table
    join information for select tables.

  Use this URL for testing  
  http://starbuck/cgi-bin/nhorn.sh/workshop/_dbinfo.w?command=getAutoJoin&table=Sports.customer
   
  Input Parameters:  
    pTable   - base table for which OF-joins are needed.  If this is 
               non-blank, all tables and their join fields are returned for
               this base table.

  Output Parameters: 
    pTblList - comma-separated list of OF-joinable tables 
                                and join fields of the format
                                
       table1(field1,field2,..,fieldn)|table2(field1,field2,..,fieldn)

  Author: D.M.Adams

  Created: April 1997

  Modifications:    

----------------------------------------------------------------------------*/

{ src/web/method/cgidefs.i }         
{ workshop/j-define.i }               /* Shared table join temp-table        */
{ workshop/j-find.i NEW }             

DEFINE INPUT  PARAMETER pTable   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pTblList AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-1  AS CHARACTER NO-UNDO. /* first filename */
DEFINE VARIABLE qbf-2  AS CHARACTER NO-UNDO. /* second filename */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* generic scrap */
DEFINE VARIABLE qbf-g  AS INTEGER   NO-UNDO. /* used for gap in shell sorts */
DEFINE VARIABLE qbf-h  AS INTEGER   NO-UNDO. /* mostly, hi bound of something */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-l  AS INTEGER   NO-UNDO. /* mostly, low bound of something */
DEFINE VARIABLE qbf-o  AS CHARACTER NO-UNDO. /* holding place during sorting */
DEFINE VARIABLE qbf-s  AS INTEGER   NO-UNDO. /* est size of array in bytes */

/* Build table join temp-table if it's empty */
IF NOT CAN-FIND(FIRST qbf-rel-buf) THEN DO:
  /*--------------------------------------------------------------------------*/
  /* Grab list of databases with metaschema */
  DO qbf-i = 1 TO NUM-DBS:
    IF DBTYPE(qbf-i) = "PROGRESS":u THEN DO:
      qbf-pro-dbs = qbf-pro-dbs + (IF qbf-pro-dbs = "" THEN "" ELSE ",":u) + 
                      LDBNAME(qbf-i).
                  
      /* Build a list of all tables in all PROGRESS databases */
      CREATE ALIAS "QBF$1":u FOR DATABASE VALUE(LDBNAME(qbf-i)).
      RUN workshop/_jgenlst.p (LDBNAME(qbf-i)).
    END.
  END.

  /* Does pTable exist?  If not then raise error */
  IF pTable <> "" THEN DO:
    {&FIND_TABLE_BY_NAME} pTable NO-ERROR.
    IF NOT AVAILABLE qbf-rel-buf THEN DO:
      pTblList = "ERROR: " + ptable + " is an invalid db.table name.".
      RETURN.
    END.
  END.
  
  /*--------------------------------------------------------------------------*/
  /* Plow through unique indexes for each database */
  
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-pro-dbs):
    CREATE ALIAS "QBF$1":u FOR DATABASE VALUE(ENTRY(qbf-i,qbf-pro-dbs)).
    RUN workshop/_jfind1.p.
  END.
  
  /*--------------------------------------------------------------------------*/
  /* Now purge duplicates recorded in qbf-purge */
  
  DO qbf-s = 1 TO NUM-ENTRIES(qbf-purge):
    ASSIGN
      qbf-l = INTEGER(ENTRY(1,ENTRY(qbf-s,qbf-purge),"-":u))
      qbf-h = INTEGER(ENTRY(2,ENTRY(qbf-s,qbf-purge),"-":u)).
      
    {&FIND_TABLE_BY_ID} qbf-h.
    {&FIND_TABLE2_BY_ID} qbf-l.
    
    ASSIGN
      qbf-1 = qbf-rel-buf.rels + ",":u
      qbf-2 = qbf-rel-buf2.rels + ",":u
      qbf-i = INDEX(qbf-1,"<":u + STRING(qbf-l) + ",":u)
      qbf-j = INDEX(qbf-2,"<":u + STRING(qbf-h) + ",":u).
  
    IF qbf-i = 0 THEN qbf-i = INDEX(qbf-1,">":u + STRING(qbf-l) + ",":u).
    IF qbf-j = 0 THEN qbf-j = INDEX(qbf-2,">":u + STRING(qbf-h) + ",":u).
  
    IF qbf-i = 0 THEN qbf-i = INDEX(qbf-1,"=":u + STRING(qbf-l) + ",":u).
    IF qbf-j = 0 THEN qbf-j = INDEX(qbf-2,"=":u + STRING(qbf-h) + ",":u).
  
    IF qbf-i > 0 THEN
      SUBSTRING(qbf-rel-buf.rels,qbf-i - 1,
        LENGTH(STRING(qbf-l),"CHARACTER":u) + 2,"CHARACTER":u) = "".
    
    IF qbf-j > 0 THEN
      SUBSTRING(qbf-rel-buf2.rels,qbf-j - 1,
        LENGTH(STRING(qbf-h),"CHARACTER":u) + 2,"CHARACTER":u) = "".
  END.
  
  /*--------------------------------------------------------------------------*/
  /* Now sort */
  
  FOR EACH qbf-rel-buf:
    IF NUM-ENTRIES(qbf-rel-buf.rels) < 3 THEN NEXT.
  
    ASSIGN
      qbf-o = SUBSTRING(qbf-rel-buf.rels,
                INDEX(qbf-rel-buf.rels,",":u) + 1,-1,"CHARACTER":u)
      qbf-g = TRUNCATE(NUM-ENTRIES(qbf-o) / 2,0). /* shell sort */
    DO WHILE qbf-g > 0:
      DO qbf-i = qbf-g TO NUM-ENTRIES(qbf-o):
        qbf-j = qbf-i - qbf-g.
        DO WHILE qbf-j > 0:
          ASSIGN
            qbf-1 = SUBSTRING(ENTRY(qbf-j,qbf-o),2,-1,"CHARACTER":u)
            qbf-2 = SUBSTRING(ENTRY(qbf-j + qbf-g,qbf-o),2,-1,"CHARACTER":u).
          IF INDEX(qbf-1,":":u) > 0 THEN
            qbf-1 = SUBSTRING(qbf-1,1,INDEX(qbf-1,":":u) - 1,"CHARACTER":u).
          IF INDEX(qbf-2,":":u) > 0 THEN
            qbf-2 = SUBSTRING(qbf-2,1,INDEX(qbf-2,":":u) - 1,"CHARACTER":u).
          IF INTEGER(qbf-1) < INTEGER(qbf-2) THEN LEAVE.
          ASSIGN
            qbf-c                      = ENTRY(qbf-j,qbf-o)
            ENTRY(qbf-j,qbf-o)         = ENTRY(qbf-j + qbf-g,qbf-o)
            ENTRY(qbf-j + qbf-g,qbf-o) = qbf-c
            qbf-j                      = qbf-j - qbf-g.
        END.
      END.
      qbf-g = TRUNCATE(qbf-g / 2,0).
    END.
  
    qbf-rel-buf.rels = ",":u + qbf-o.
  END.
END.
  
/* Return comma-separated list of joined tables if requested */
IF pTable <> "" THEN DO:
  {&FIND_TABLE_BY_NAME} pTable.
  
  DO qbf-i = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
    qbf-j = INTEGER(TRIM(ENTRY(qbf-i,qbf-rel-buf.rels),"=<>*":U)).
  
    IF STRING(qbf-j) <> "" THEN DO:
      {&FIND_TABLE2_BY_ID} qbf-j.
      pTblList = pTblList 
               + (IF pTblList = "" THEN "" ELSE CHR(10))
               + qbf-rel-buf.tname + ",":U
               + qbf-rel-buf2.tname + "(":U 
               + ENTRY(qbf-i,qbf-rel-buf.joinfld,CHR(3)) + ")":U.
    END.
  END.
END.

/* _jfind.p - end of file */

