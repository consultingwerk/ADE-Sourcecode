/*********************************************************************
* Copyright (C) 2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/_ctestr.p

Description:
    Generates Migration and Ranking report 

Text-Parameters:
    s_rank_rep  report file name.

Included in:
   prodict/mss/protoms1.p

History:
    Anil Shukla  05/29/13   Created
--------------------------------------------------------------------*/



&SCOPED-DEFINE xxDS_DEBUG                   DEBUG /**/
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i }

/* ----------------------------- DEFINES -----------------------------*/
DEFINE INPUT PARAMETER outfile as CHARACTER no-undo.

DEFINE stream s_rank_rep.
DEFINE  VARIABLE i1 AS INTEGER INITIAL 0.
DEFINE  VARIABLE VAR1 AS LOGICAL INITIAL FALSE.
DEFINE  VARIABLE lcompatible AS LOGICAL  INITIAL FALSE. 
DEFINE  VARIABLE l-INFOR AS LOGICAL INITIAL FALSE.
DEFINE  VARIABLE tmp_str AS CHARACTER NO-UNDO.

OUTPUT stream s_rank_rep to VALUE(outfile). 

/* dump "Migration" screen options for reference */
PUT STREAM s_rank_rep UNFORMATTED SKIP "     Migration window selections     Date:" NOW SKIP.
PUT STREAM s_rank_rep UNFORMATTED "--------------------------------------------------------------  " SKIP.

PUT STREAM s_rank_rep UNFORMATTED "Original OpenEdge Database:     " pro_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Connect Parameters for OpenEdge:" pro_conparms SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Name of Schema Holder Database: " osh_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Logical Database Name:          " mss_pdbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "ODBC Data Source Name:          " mss_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Username:                       " mss_username SKIP.
PUT STREAM s_rank_rep UNFORMATTED "User's Password:                ***** " SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Connect Parameters:             " mss_conparms SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Maximum Varchar Length:         " long-length SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Codepage:   " mss_codepage SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Collation:  " mss_collname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Insensitive:" mss_incasesen SKIP(1).

IF loadsql THEN PUT STREAM s_rank_rep UNFORMATTED "(X) " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) " .
PUT STREAM s_rank_rep UNFORMATTED "Load SQL       ".
IF genrep THEN PUT STREAM s_rank_rep UNFORMATTED "(X) " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) " .
PUT STREAM s_rank_rep UNFORMATTED "Generate Rank Report" SKIP.
IF movedata THEN PUT STREAM s_rank_rep UNFORMATTED "(X) " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) " .
PUT STREAM s_rank_rep UNFORMATTED "Move Data" SKIP.
PUT STREAM s_rank_rep UNFORMATTED "--------------------------------------------------------------  " SKIP(2).

/* dump "Advanced" screen options for reference */
PUT STREAM s_rank_rep UNFORMATTED SKIP "  ********* Advanced window selections *********  " SKIP.

IF (UPPER(ENTRY(1,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "(X) " .
ELSE PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "( ) " .
PUT STREAM s_rank_rep UNFORMATTED "Migrate Constraints" SKIP.

PUT STREAM s_rank_rep UNFORMATTED "-------------------------------------------------------------  " SKIP.
IF (UPPER(ENTRY(2,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED  "(X) ".
ELSE PUT STREAM s_rank_rep UNFORMATTED  "( ) ".
PUT STREAM s_rank_rep UNFORMATTED "Try Primary for ROWID    ".

IF (UPPER(ENTRY(3,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED "(X) " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) " .
PUT STREAM s_rank_rep UNFORMATTED "Maintain RECID compatibility" SKIP.

IF user_env[27] = ?  OR user_env[27] = "" THEN ASSIGN lcompatible = true.
ELSE IF num-entries(user_env[27]) > 1 THEN
     assign lcompatible = ( entry(1,user_env[27]) BEGINS "y"
              or entry(1,user_env[27]) = "" ).
else assign lcompatible = (user_env[27] BEGINS "y").

IF lcompatible THEN DO:
  IF ( (NUM-ENTRIES(user_env[27]) >= 2) AND ENTRY(2,user_env[27]) EQ "1" ) THEN
    PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "Create RECID Field using  (X) Trigger   ( ) Computed Column" SKIP.
  ELSE 
    PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "Create RECID Field using  ( ) Trigger   (X) Computed Column" SKIP.
  IF NUM-ENTRIES(user_env[27]) >= 3 THEN DO:
    IF ((ENTRY(3,user_env[27]) EQ "D" ) OR (ENTRY(3,user_env[27]) EQ "P") ) THEN DO:
       PUT STREAM s_rank_rep UNFORMATTED "  (X) For " .
       IF (ENTRY(3,user_env[27]) EQ "D" ) THEN 
         PUT STREAM s_rank_rep UNFORMATTED "   (X) ROWID   ( ) Prime ROWID " SKIP.
       ELSE
         PUT STREAM s_rank_rep UNFORMATTED "   ( ) ROWID   (X) Prime ROWID " SKIP.
       PUT STREAM s_rank_rep UNFORMATTED "  ( ) For ROWID Uniqueness" SKIP. 
    END.
    ELSE DO:
       PUT STREAM s_rank_rep UNFORMATTED "  ( ) For  ( ) ROWID   ( ) Prime ROWID " SKIP.
       PUT STREAM s_rank_rep UNFORMATTED "  (X) For ROWID Uniqueness" SKIP. 
    END.
  END.
END. 

IF NUM-ENTRIES(user_env[36]) >= 4 AND (UPPER(ENTRY(4,user_env[36])) EQ "Y" ) THEN DO: 
  PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "(X) Select Best ROWID Index"  SKIP.
  PUT STREAM s_rank_rep UNFORMATTED "    USING     " .
  IF ENTRY(5,user_env[36]) EQ "1" THEN
     PUT STREAM s_rank_rep UNFORMATTED "(X) OE Schema  ( ) Foreign Schema" SKIP.
  ELSE
     PUT STREAM s_rank_rep UNFORMATTED "( ) OE Schema  (X) Foreign Schema" SKIP.
END.

PUT STREAM s_rank_rep UNFORMATTED "--------------------------------------------------------------  " SKIP.
IF user_env[12]  = "datetime" THEN PUT STREAM s_rank_rep UNFORMATTED "(X) Map to MSS 'Datetime' Type".
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) Map to MSS 'Datetime' Type".

IF UPPER(user_env[21]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "    (X) Create Shadow Column" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "    ( ) Create Shadow Column" SKIP.

IF NUM-ENTRIES(user_env[25]) >= 2 AND (UPPER(ENTRY(2,user_env[25])) EQ "Y" ) THEN 
     PUT STREAM s_rank_rep UNFORMATTED "(X) Use revised sequence Generator" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) Use revised sequence Generator" SKIP.

PUT STREAM s_rank_rep UNFORMATTED "--------------------------------------------------------------  " SKIP.
IF user_env[11]  = "nvarchar" THEN PUT STREAM s_rank_rep UNFORMATTED "(X) Use Unicode Types".
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) Use Unicode Types".
IF UPPER(user_env[35]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "      (X) Expand Width(utf-8)" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "      ( ) Expand Width(utf-8)" SKIP.
IF UPPER(user_env[33]) = "Y" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "For field widths use  (X) Width  ( ) ABL Format" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "For field widths use  ( ) Width  (X) ABL Format" SKIP.
PUT STREAM s_rank_rep UNFORMATTED "--------------------------------------------------------------  " SKIP.
IF UPPER(user_env[38]) = "1" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "Apply Uniqueness as: (X) Index Attributes  ( ) Constraints" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "Apply Uniqueness as: ( ) Index Attributes  (X) Constraints" SKIP.

IF UPPER(user_env[7]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "(X) Include Default" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "( ) Include Default" SKIP.

IF UPPER(user_env[39]) = "1" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "Apply Defaults as: (X) Field Attributes  ( ) Constraints" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "Apply Defaults as: ( ) Field Attributes  (X) Constraints" SKIP.

PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "  ********* ******************************** *********  " SKIP.
/* end of "Advanced" screen options */
IF OS-GETENV("OE_INFOR_OPTS") <> ? 
THEN DO:
     tmp_str = OS-GETENV("OE_INFOR_OPTS").

     IF tmp_str BEGINS "Y" THEN
      ASSIGN l-INFOR = TRUE.
END.
IF l-INFOR THEN DO : 

PUT STREAM s_rank_rep UNFORMATTED SKIP(2) "************* Ranking Information ************ *********  " SKIP.

IF ((NUM-ENTRIES(user_env[42]) >= 2) AND
    UPPER(ENTRY(2,user_env[42])) = "L" ) THEN 
  PUT STREAM s_rank_rep UNFORMATTED "   Ranking Happened using Legacy ranking Algorithm." SKIP.
ELSE 
  PUT STREAM s_rank_rep UNFORMATTED "   Ranking Happened using NEW ranking Algorithm." SKIP.


FOR EACH DICTDB._File WHERE NOT DICTDB._FILE._Hidden AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"):
PUT STREAM s_rank_rep UNFORMATTED SKIP(2)"    =========================================================    " SKIP.

  IF NOT CAN-FIND( FIRST DICTDB._INDEX WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND 
             DICTDB._Index._Index-name <> "default" ) THEN
     assign i1 = 0. 
  ELSE assign i1 = DICTDB._FILE._Prime-index.

      PUT STREAM s_rank_rep UNFORMATTED "Table Name: " UPPER(DICTDB._FILE._File-name) FORMAT "x(15)" 
        "Prime Index ID:" i1 SKIP 
      "MISC1[1] :" DICTDB._FILE._Fil-misc1[1] FORMAT   "->>9"
      "              Misc1[2]:" DICTDB._FILE._Fil-misc1[2] FORMAT   "->>9" SKIP
      "MISC2[4] :" DICTDB._FILE._Fil-misc2[4] FORMAT "x(15)"
      "   MISC2[5]:" DICTDB._FILE._Fil-misc2[5]  FORMAT "x(25)" SKIP
       "MISC1[5] :" DICTDB._FILE._Fil-misc1[5] FORMAT   "->>9"
    .
  IF DICTDB._FILE._Fil-misc1[1] > 0 THEN
      PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "This table has PROGRESS_RECID column as ROWID" SKIP(1). 
  ELSE IF DICTDB._File._Fil-misc1[2] > 0 THEN
      PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "Index Serial# " DICTDB._FILE._Fil-misc1[2] FORMAT   "->>9" 
          " Selected as ROWID candidate." SKIP(1). 
  ELSE
      PUT STREAM s_rank_rep UNFORMATTED  SKIP(1) "      ******  NO ROWID Designated  ****** " SKIP(1). 

FIND FIRST DICTDB._INDEX WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND DICTDB._Index._Index-name <> "default" NO-ERROR. 
IF AVAILABLE DICTDB._INDEX THEN DO: 

   PUT STREAM s_rank_rep UNFORMATTED SKIP "-----------   ALL INDEXES of table " UPPER(DICTDB._FILE._File-name) FORMAT "x(15)" "----------------------" SKIP.

   PUT STREAM s_rank_rep UNFORMATTED 
       "Index Sr#  Unique  Index-recid      Index Name          Column#  Ranking+" SKIP.
   PUT STREAM s_rank_rep UNFORMATTED "------------------------------------------------------------------------" SKIP.

   FOR EACH DICTDB._Index WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND  
                                DICTDB._Index._Index-name <> "default" BY DICTDB._Index._idx-num:
       ASSIGN VAR1 =  DICTDB._Index._Unique.
       PUT STREAM s_rank_rep UNFORMATTED 
           DICTDB._INDEX._idx-num FORMAT   "->>>>>9" "    " VAR1  FORMAT "yes/no" "   " RECID(DICTDB._INDEX) FORMAT   "->>>>>9" 
           "            " DICTDB._INDEX._Index-name  FORMAT "x(20)" "  " DICTDB._INDEX._num-comp FORMAT   "->>9" "    " 
           DICTDB._INDEX._I-misc2[1] FORMAT "x(5)" .
       IF substring(DICTDB._INDEX._I-misc2[1],1,1) EQ "r" THEN
          PUT STREAM s_rank_rep UNFORMATTED "- Auto selected ROWID.".
       PUT STREAM s_rank_rep UNFORMATTED SKIP.
   END.
   PUT STREAM s_rank_rep UNFORMATTED " +Ranking - a:Automatically Selectable, u:User-definable, x:Non-V7.3 compatible, v:Uniqueness Enforced." SKIP.
   PUT STREAM s_rank_rep UNFORMATTED " +Ranking - n:Uniqueness missing, m:Mandatory missing, c-RECID compatible index." SKIP(2).
END.

 FIND FIRST s_ttb_tbl WHERE s_ttb_tbl.tmp_recid = RECID(DICTDB._FILE) NO-ERROR.
 IF AVAILABLE s_ttb_tbl THEN DO: /* Print description and clean up temp table. */
    PUT STREAM s_rank_rep UNFORMATTED s_ttb_tbl.rank_desc SKIP.
    DELETE s_ttb_tbl.
 END. 
  
END.
END.
PUT STREAM s_rank_rep UNFORMATTED SKIP(2)"++++++++++ END OF REPORT ++++++++++ " NOW SKIP.

OUTPUT STREAM s_rank_rep CLOSE.
