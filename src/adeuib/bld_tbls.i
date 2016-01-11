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

File: bld_tbls.i

Description:
    Include file contains an internal procedure named build_table_list which
    generates a list of tables from a freeform open query expression.
    This is included in _genpro2.i which is included in _gen4gl.p, _gendefs.p
    and _qikcomp.p and also _prpsdo.p.
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1999

Date Modified:

---------------------------------------------------------------------------- */
/* ************************************************************************* */
/*                                                                           */
/*     COMMON PROCEDURES FOR DEFINING VIEW-AS SUPPORT, COLOR and FONT        */
/*                                                                           */
/* ************************************************************************* */



/* Build a simple list of tables from a 4gl query */
PROCEDURE build_table_list:
DEFINE INPUT  PARAMETER iquery    AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER delmtr    AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER qualify   AS LOGICAL       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER otbls     AS CHARACTER     NO-UNDO.

DEFINE VARIABLE db_name           AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER       NO-UNDO.
DEFINE VARIABLE tmptbl            AS CHARACTER     NO-UNDO.
DEFINE VARIABLE origDbName        AS CHARACTER     NO-UNDO.

origDbName = LDBNAME(1).                        /* IZ 448: take the first db for the dbname */ 
IF (INDEX(otbls,".":U) > 0)                     /* like always BUT if there is a    */
    THEN origDbName = ENTRY(1,otbls,".":U).     /* better choice then use it  */
  
ASSIGN iquery  = REPLACE(REPLACE(REPLACE(TRIM(iquery),CHR(13)," "),
                                 CHR(10), " "), "~~", " ")
       i       = 0
       otbls   = "".
/* condense spaces */
DO WHILE otbls NE iquery:
  ASSIGN otbls  = iquery
         iquery = REPLACE(iquery, "  ":U, " ").
END.
otbls = "".                     
DO WHILE i < NUM-ENTRIES(iquery," ":U):
  i = i + 1.
  IF CAN-DO("EACH,FIRST,LAST,CURRENT,NEXT,PREV",ENTRY(i, iquery, " ":U))
  THEN DO: /* Next token is a table name */
    IF (i > 1 AND ENTRY(i - 1, iquery, " ":U) NE "GET":U)
        OR i = 1 THEN DO:  /* GET NEXT or GET PREV is followed by query-name */
      ASSIGN i       = i + 1
             db_name = TRIM(ENTRY(i, iquery, " ":U),",.":U)
             tmptbl  = (IF NUM-ENTRIES(db_name,".":U) = 1 AND qualify 
                        THEN  origDbName + "." + db_name
                        ELSE db_name). 
      IF LOOKUP(tmptbl,otbls,delmtr) = 0 THEN otbls   = otbls + delmtr + tmptbl.
    END.
  END. /* Next token is a table name */
END.  /* While i < number of entries */
ASSIGN otbls = TRIM(otbls,delmtr).

END PROCEDURE. /* build_table_list */


