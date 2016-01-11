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

  File: _qbuild.p

  Description:
    Takes a frame handle and rebuilds the _Q._4GLQury based on the table list,
    sort criteria, JoinCodes and Where clauses.
                    

  Input Parameters:
    pr_x-recid      - the recid of the _Q record
    suppress_dbname - TRUE if we want query NOT to show the dbname.

  Output Parameters:
      <none>

  Author: Wm.T.Wood

  Created: 01/17/94
                      
  Modified:
    5/28/96 wood -- Add support for SORTBY-PHRASE option
-----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pr_x-recid      AS RECID   NO-UNDO.
DEFINE INPUT PARAMETER suppress_dbname AS LOGICAL NO-UNDO.  
DEFINE INPUT PARAMETER iXternalCnt AS INTEGER NO-UNDO.

DEFINE VAR sort_phrase AS CHAR NO-UNDO.
{adeuib/uniwidg.i}
{adeuib/sharvars.i}

/* Standard End-of-line character */
&Scoped-define EOL  CHR(10)

/* Get the current _C record for the frame */
FIND _Q WHERE RECID(_Q) eq pr_x-recid.  

/* Get the sort-by phrase. */ 
RUN BuildSort (OUTPUT sort_phrase).  

/* This is a UIB wrapper for the adeshar/_qbuild.i */ 
{ adeshar/qbuild.i 
    &4GLQury    = "_Q._4GLQury"
    &TblList    = "_Q._TblList"
    &JoinCode   = "_Q._JoinCode"
    &Where      = "_Q._Where"
    &SortBy     = "sort_phrase"
    &use_dbname = "(NOT suppress_dbname)"
    &OptionList = "_Q._OptionList"
    &TblOptList = "_Q._TblOptList" 
    &Sep1       = ""","""  
    &ExtTbls    =  "iXternalCnt" 
    &Mode       = "TRUE"  
    &Preprocess = "TRUE"
    }

/* -------------------------------------------------------------*/
/*                    Internal Procedures                       */
/* -------------------------------------------------------------*/

/* Start with _Q_OrdList and build an expression of the form
 *    "    BY db.tbl.fld1 DECENDING
 *           BY db.tbl.fld2. "
 */
PROCEDURE BuildSort.
  DEFINE OUTPUT PARAMETER cSortBy   AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDir   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i      AS INTEGER NO-UNDO.

 /* If the OptionList includes the SORTBY-PHRASE, then this indicates using a
    a preprocessor variable. */
  IF LOOKUP("SORTBY-PHRASE":U, _Q._OptionList, " ":U) > 0 
  THEN cSortBy = "~~~{&SORTBY-PHRASE}":U.
  ELSE DO:
    /* These seperators are used in _Q_OrdList */
    &Scop Sep1 ","
    &Scop Sep2 "|"
  
    /* Since the sort field may have commas in it (for calculated fields)
       change all occurances of "|yes," and "|no," to "|yesCHR(3)" and
       "|noCHR(3)"                                                      */
    ASSIGN _Q._OrdList = REPLACE(REPLACE(_Q._OrdList, "|yes," ,"|yes" + CHR(3)),
                                               "|no," ,"|no" + CHR(3))
           cSortBy     = "".
    DO i = 1 TO NUM-ENTRIES(_Q._OrdList, CHR(3)):
      /* Indent each line of the "BY" phrase */
      cSortBy = cSortBy + FILL(" ":U, 5 + i).
  
      /* Get the i-th field.  The second element of the cField determines
         the sort direction.  The first element if DB.TABLE.FIELD.  */
      ASSIGN cField = ENTRY (i, _Q._OrdList, CHR(3))
             cDir   = IF ENTRY(2, cField, {&Sep2}) eq "yes":U
                        THEN "" ELSE " DESCENDING"
             cField = ENTRY(1, cField, {&Sep2}) .
      IF suppress_dbname AND NUM-ENTRIES(cField,".":U) = 3 AND
         INDEX(cField,"(":U) = 0 AND INDEX(cField," ":U) = 0  OR
         CAN-DO(_tt_log_name, ENTRY(1, cField, ".":U)) THEN 
        cField = ENTRY(2,cField,".":U) + ".":U + ENTRY(3,cField,".":U).
  
      /* Build the line. */
      cSortBy  =  cSortBy + "BY " + cField + cDir + {&EOL}.
    END.
    ASSIGN _Q._OrdList = REPLACE(_Q._OrdList, CHR(3), ",":U).
  END.       
END PROCEDURE.
