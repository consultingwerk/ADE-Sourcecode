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
/* oqryproc.i
 * used by pm/_pmprocs.w
 *         pm/_subset.w
 * PARAMETERS:
 *     &WildCardExp		WildCardExp
 *     &Lock                    NO-LOCK
 *     &QueryName		ProcsBrowser
 *     &DbTable                 xlatedb.XL_Procedure
 *     &DbFileFldName           xlatedb.XL_Procedure.FileName
 *     &AndWhereClause          AND xlatedb.XL_Procedure.Filename = "x"
 *     &OrWhereClause           OR xlatdb.XL_Procedure.Filename = "y"
 *     &ByStatement             BY xlatedb.XL_Procedure.FileName
 */

DEFINE VARIABLE cLookupExpr       AS CHARACTER    EXTENT 4          NO-UNDO. 
DEFINE VARIABLE tmpWildCardExpr   AS CHARACTER                      NO-UNDO. 
 
/*REMOVE
MESSAGE 
 "WildCardExp={&WildCardExp}" SKIP
 "Lock={&Lock}" SKIP
 "QueryName={&QueryName}" SKIP
 "DbTable={&DbTable}" SKIP
 "DbFileFldName={&DbFileFldName}" SKIP
 "OrWhereClause={&OrWhereClause}" SKIP
 "AndWhereClause={&AndWhereClause}" SKIP
 "ByStatement={&ByStatement}" SKIP(2)
VIEW-AS ALERT-BOX.
REMOVE*/


 /* Need to replace . with ~~. for matching true . */
 ASSIGN tmpWildCardExpr = 
    REPLACE({&WildCardExp},".":U,"~~.":U). 

  /* Common Case 1: retrieve both *.p and *.w code  */
  IF {&WildCardExp} = "*.p,*.w":U THEN DO:      
     OPEN QUERY {&QueryName}  
       FOR EACH {&DbTable} {&Lock} 
         WHERE ((   {&DbFileFldName} MATCHES "*~~.p":U 
                OR {&DbFileFldName} MATCHES "*~~.w":U) 
                {&AndWhereClause}) 
            {&OrWhereClause} 
         {&ByStatement}.     
  END. 
  /* Common case 2: retrieve anything *.* */ 
  ELSE if {&WildCardExp} = "*.*":U THEN DO: 
    OPEN QUERY {&QueryName} FOR EACH {&DbTable} {&Lock} 
      WHERE (TRUE  
             {&AndWhereClause}) 
            {&OrWhereClause} 
         {&ByStatement}.     
  END. 
  
  /* Last chance case, parse upto 4 entries */
  ELSE DO: 
    CASE NUM-ENTRIES({&WildCardExp}): 
      WHEN 1 THEN DO: 
        OPEN QUERY {&QueryName} FOR EACH {&DbTable} {&Lock} 
             WHERE ({&DbFileFldName} MATCHES 
                     REPLACE(tmpWildCardExpr, "?":U , ".":U) 
                    {&AndWhereClause}) 
                   {&OrWhereClause} 
               {&ByStatement}.     
      END. 

      WHEN 2 THEN DO: 
         ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) 
                cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U).  
         OPEN QUERY {&QueryName} FOR EACH {&DbTable} {&Lock} 
             WHERE ((   {&DbFileFldName} MATCHES cLookupExpr[1] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[2]) 
                    {&AndWhereClause}) 
                     {&OrWhereClause} 
            {&ByStatement}.     
      END. 
      WHEN 3 THEN DO: 
         ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) 
                cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U) 
                cLookupExpr[3] = REPLACE(ENTRY(3,tmpWildCardExpr), "?":U, ".":U). 
         OPEN QUERY {&QueryName} FOR EACH {&DbTable} {&Lock} 
             WHERE ((   {&DbFileFldName} MATCHES cLookupExpr[1] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[2] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[3]) 
                     {&AndWhereClause}) 
                     {&OrWhereClause} 
            {&ByStatement}.     
      END. 
      WHEN 4 THEN DO: 
         ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) 
                cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U)  
                cLookupExpr[3] = REPLACE(ENTRY(3,tmpWildCardExpr), "?":U, ".":U) 
                cLookupExpr[4] = REPLACE(ENTRY(4,tmpWildCardExpr), "?":U, ".":U). 
         OPEN QUERY {&QueryName} FOR EACH {&DbTable} {&Lock} 
             WHERE ((  {&DbFileFldName} MATCHES cLookupExpr[1] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[2] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[3] 
                     OR {&DbFileFldName} MATCHES cLookupExpr[4]) 
                     {&AndWhereClause}) 
                     {&OrWhereClause} 
            {&ByStatement}.     
      END. 
    
    END.  /* CASE */ 
  END.  /* Last chance case */ 
