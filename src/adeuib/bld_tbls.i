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

Date Modified: 01/14/2003  Issue 3635.  

---------------------------------------------------------------------------- */

/* Build a simple list of tables from a 4gl query */
PROCEDURE build_table_list:
DEFINE INPUT  PARAMETER pcQuery        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pcdelmtr       AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER plqualify      AS LOGICAL       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcotbls  AS CHARACTER     NO-UNDO.

DEFINE VARIABLE db_name           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE ctmptbl           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRecid            AS RECID      NO-UNDO.
DEFINE VARIABLE cTmpString        AS CHARACTER  NO-UNDO.

ASSIGN pcQuery     = REPLACE(REPLACE(REPLACE(TRIM(pcQuery),CHR(13)," "),
                                 CHR(10), " "), "~~", " ")
       pcotbls      = ""
       i          = 0.
/* condense spaces */
DO WHILE cTmpString NE pcQuery:
  ASSIGN cTmpString  = pcQuery
         pcQuery = REPLACE(pcQuery, "  ":U, " ").
END.

DO WHILE i < NUM-ENTRIES(pcQuery," ":U):
  ASSIGN i       = i + 1
         cEntry  = ENTRY(i, pcQuery, " ":U).
  IF CAN-DO("EACH,FIRST,LAST,CURRENT,NEXT,PREV",cEntry)
  THEN DO: /* Next token is a table name */
    IF (i > 1 AND ENTRY(i - 1, pcQuery, " ":U) NE "GET":U)
        OR i = 1 THEN 
    DO:  /* GET NEXT or GET PREV is followed by query-name */
      ASSIGN i         = i + 1
             cFullName = TRIM(ENTRY(i, pcQuery, " ":U),",.":U).
      IF NUM-ENTRIES(cFullName,".") = 1 AND plqualify  THEN 
      DO:  /* Get the db name from the specified table name */
         RUN adecomm/_gttbldb.p (INPUT cFullName, OUTPUT db_name, 
                                 OUTPUT rRecid, OUTPUT rRecid).
         ASSIGN ctmptbl =  db_name + "." + cFullName.
      END.
      ELSE IF NUM-ENTRIES(cFullName,".") = 2 AND NOT plqualify THEN
         ASSIGN ctmptbl = ENTRY(2,cFullname,".").
      ELSE 
         ASSIGN ctmptbl = cFullName.

      IF LOOKUP(ctmptbl,pcotbls,pcdelmtr) = 0 THEN 
         pcotbls   = pcotbls + pcdelmtr + ctmptbl.
    END.
  END. /* Next token is a table name */
END.  /* While i < number of entries */
ASSIGN pcotbls = TRIM(pcotbls,pcdelmtr).

END PROCEDURE. /* build_table_list */


