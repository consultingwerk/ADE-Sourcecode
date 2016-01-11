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
/* -----------------------------------------------------------------------
  qbuild.i:  Create a 4GL query based on
     &TblLIst  - A &SEP delimited lIst of tables each elements of the
                 form "table" or "table2 OF table" or "table3 WHERE table ..."
     &JoinCode   - A CHAR array containing JOi_qbiN information
     &Where      - A CHAR array of WHERE expressions.
     &SortBy     - A CHAR string or variable containing the BY phrase.
     &OptionList - A CHAR string that contains options:  The expected options
                   are INDEXED-REPOSITION, NO-LOCK, SHARE-LOCK, EXCLUSIVE-LOCK
                   (and KEEP-EMPTY)
     &TblOptList - A CHAR string that contain a comma delimitted list of query
                   option each entry can contain Fields Used (oposite of All Fields),
                   LAST or FIRST (alternatives to EACH), or OUTER (opposite of INNER).
     &Sep1       - the delimiter character in &TblList 
     &ExtTbls    - iXternalCnt (the count of external tables)
     &Mode       - False for access within the QB, True if origin is UIB's qbuild.p
     &Preprocess - TRUE if you want to add a tilde to proprocessor expressions
                   (You need this if you want to include the query IN a
                    preprocessor like (&OPEN-QUERY)
     &EOL        - Line seperation character to use in &4GLQury
     &use_dbname - IF FALSE then don't use the DBNAME in the generated query
   Output:
     &4GLQury  - A query of the form 
                 " EACH table1 WHERE condition lock-type,
                       EACH table2 OF table1 WHERE condition2 lock-type"
   Used by:
      Workshop: importing code and validating queries (in workshop/_qbuild.p)
      Query Builder: rebuilding query after each change in tables
     
   Created: Wm. T. Wood 2/20/97 [from adeshar/qbuild.i]
  ------------------------------------------------------------------------- */
  
  /* "Local" variables (use _qbi extension to prevent naming conflicts */
  DEFINE var cLine_qbi         AS CHAR NO-UNDO.
  DEFINE var lWhere_qbi        AS LOG  NO-UNDO.
  DEFINE VAR i_qbi             AS INT  NO-UNDO.
  DEFINE VAR query_options_qbi AS CHAR NO-UNDO.
  DEFINE VAR i-xtrn            AS INT  NO-UNDO.
  DEFINE VAR TblOptEnt         AS CHAR NO-UNDO.
  
  /*
  ** Note: QB is suppose to work with several parallel arrays so that you have
  ** have where and join code for each table (i.e. table1 should have where1 and
  ** no join1, table2 should have where2 and join2 [table2=table1].   However it
  ** didn't always work this way.  Instead, the joins were synchronized with the
  ** table and where arrays (i.e. table1 has where1 and join1). In v7.3A, the
  ** joins were constructed for table2 thru table-n but taking lagging 1 (i.e. 
  ** table2's join came from join1, table3's join came from join2). Table1, btw,
  ** never had to worry about joins because they never had the 'OF' or 'WHERE' keywords
  ** in their composition so the join code was never attempted (if it had it would have
  ** resulted in an array subscript of 0).
  */

  ASSIGN cLine_qbi        = "":U.

 /* 
  * Create the option list: i.e. look for LOCK type in the &OptionList.  
  */
 IF LOOKUP ("SHARE-LOCK":U, {&OptionList}, " ":U) > 0 THEN 
   query_options_qbi = " SHARE-LOCK":U.
 ELSE IF LOOKUP ("EXCLUSIVE-LOCK":U, {&OptionList}, " ":U) > 0 THEN 
   query_options_qbi = " EXCLUSIVE-LOCK":U.
 ELSE IF LOOKUP ("NO-LOCK":U, {&OptionList}, " ":U) > 0 THEN
   query_options_qbi = " NO-LOCK":U .
 ELSE 
   query_options_qbi = " SHARE-LOCK":U.  /* this is the best default */
 
  /*
  ** Check for blank lines and delete them if there are any.
  */
  DO i_qbi = 1 TO NUM-ENTRIES ({&TblList}, {&Sep1}):
      ASSIGN
        cLine_qbi = REPLACE ({&Where} [i_qbi] , CHR (10), " ":U)
        cLine_qbi = REPLACE (cLine_qbi , CHR (13), " ":U)
        cLine_qbi = REPLACE (cLine_qbi , " ", "":U).
 
      IF (cLine_qbi = "":U) AND ({&Where} [i_qbi] <> "":U) THEN
      ASSIGN
        {&Where} [i_qbi] = REPLACE ({&Where} [i_qbi] , CHR (10), " ":U)
        {&Where} [i_qbi] = REPLACE ({&Where} [i_qbi] , CHR (13), " ":U)
        {&Where} [i_qbi] = REPLACE ({&Where} [i_qbi] , " ", "":U).
 
  END.
  
  {&4GLQury} = "".  /* Start with nothing and rebuild from scratch */
  IF NUM-ENTRIES ({&TblList}, {&Sep1}) > 0 THEN DO:
    DO i_qbi = 1 TO NUM-ENTRIES ({&TblList}, {&Sep1}):
      cLine_qbi = ENTRY (i_qbi, {&TblList}, {&Sep1}).

      /* Do not include "external" tables. */
      IF NUM-ENTRIES(cLine_qbi," ") eq 1 OR 
         CAN-DO("OF,WHERE":U, ENTRY(2,cLine_qbi," ")) THEN DO:

        /* Close the previous line (if it exists). */
        IF {&4GLQury} ne "" 
        THEN {&4GLQury} = {&4GLQury} + 
                          query_options_qbi +
                          "," +
                          {&EOL} + "      ":U.

        /*
        ** if the line ends with ... then there should be a join attached so
        ** rebuild the line based on the join.  If there is no join specified
        ** in JoinCode, then just say "WHERE TRUE"
        */
        IF (ENTRY ( NUM-ENTRIES (cLine_qbi, " ":U), cLine_qbi, " ":U) eq "...") 
        THEN ASSIGN 
               lWhere_qbi = TRUE
               /* If the JoinCode is incomplete, just say TRUE. */
               cLine_qbi = ENTRY (1, cLine_qbi, " ":U) + " WHERE ":U + 
                           IF ({&JoinCode} [i_qbi] eq "") OR 
                              ({&JoinCode} [i_qbi] eq ?) 
                           THEN "TRUE /* Join to " + ENTRY(3, cLine_qbi," ":U) + 
                                " incomplete */":U 
                           ELSE {&JoinCode} [i_qbi].
        ELSE DO:
          /* If we need to add a KEY-PHRASE to the first table, then do it. */
          IF i_qbi eq 1 AND LOOKUP("KEY-PHRASE":U, {&OptionList}, " ":U) > 1 
          THEN ASSIGN cLine_qbi  = cLine_qbi + " WHERE " 
                                 + (IF {&Preprocess} THEN "~~":U ELSE "":U)
                                 + "~{&KEY-PHRASE}"
                      lWhere_qbi = YES.
          ELSE ASSIGN cLine_qbi  = ENTRY (i_qbi, {&TblList}, {&Sep1})
                      lWhere_qbi = FALSE.  
        END.

        /*
        ** if there is only one data base then fully qualify.  Watch out for the
        **  TABLE WHERE TRUE and TABLE WHERE ~{&KEY-PHRASE} cases
        **  where we don't want to expand.
        */
        IF (NUM-ENTRIES (ENTRY (1, cLine_qbi, " ":U), ".":U) eq 1) AND
           {&use_dbname}
        THEN DO:
          ENTRY (1, cLine_qbi, " ":U) = LDBNAME (1) + ".":U + ENTRY (1, cLine_qbi, " ":U).
          IF (NUM-ENTRIES (cLine_qbi, " ":U) >= 3) AND
             (ENTRY (3,  cLine_qbi, " ":U) ne "TRUE":U) AND 
             (ENTRY (3,  cLine_qbi, " ":U) ne "~{&KEY-PHRASE}":U)
          THEN ENTRY (3, cLine_qbi, " ":U) = LDBNAME (1) + ".":U + ENTRY (3, cLine_qbi, " ":U).
        END.
        
        /* Add the current line to the query. */
        IF {&TblOptList} NE "" THEN
          ASSIGN i-xtrn     = i_qbi - {&ExtTbls}
                 TblOptEnt  = ENTRY(i-xtrn, {&TblOptList})
                 {&4GLQury} = {&4GLQury} +
                              (IF INDEX(TblOptEnt,"FIRST":U) > 0 THEN "FIRST ":U ELSE
                               IF INDEX(TblOptEnt,"LAST":U) > 0 THEN "LAST ":U ELSE
                                                  "EACH ":U) + cLine_qbi.
        ELSE {&4GLQury} = {&4GLQury} + "EACH ":U + cLine_qbi.
        
        IF ({&Where} [i_qbi] <> "":U) AND 
           ({&Where} [i_qbi] <> ?) THEN DO:
          IF (lWhere_qbi) THEN 
            {&4GLQury} = {&4GLQury} + {&EOL} + "      AND ":U + {&Where} [i_qbi].
          ELSE 
            {&4GLQury} = {&4GLQury} + {&EOL} + "      WHERE ":U + {&Where} [i_qbi].
        END.
        IF INDEX(TblOptEnt,"OUTER":U) > 0 THEN
          {&4GLQury} = {&4GLQury} + " OUTER-JOIN":U.
      END.
    END. /* DO i_qbi = 1 to... */
   
    /* Finish the current line (i.e. add lock type) */
     {&4GLQury} = {&4GLQury} + query_options_qbi.
   
    /* Add the SortBy phrase. */    
    IF {&SortBy} ne "" 
    THEN {&4GLQury} =  {&4GLQury} + {&EOL} + "    ":U + TRIM ({&SortBy}).
 
    /* INDEXED-REPOSITIONED only works if ONE table */
    IF LOOKUP("INDEXED-REPOSITION":U, {&OptionList}, " ":U) > 0 AND 
       NUM-ENTRIES ({&TblList}, {&Sep1}) = 1 
    THEN {&4GLQury} = {&4GLQury} + " INDEXED-REPOSITION":U.
  END. /* NUM-ENTRIES > 0 */
