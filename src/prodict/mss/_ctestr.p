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

{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i }
&SCOPED-DEFINE NOTTCACHE 1
&SCOPED-DEFINE xxDS_DEBUG                 DEBUG
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE NOTTCACHE


/* ----------------------------- DEFINES -----------------------------*/
DEFINE INPUT PARAMETER outfile as CHARACTER no-undo.

DEFINE stream s_rank_rep.
DEFINE  VARIABLE i1 AS INTEGER INITIAL 0.
DEFINE  VARIABLE linewdth AS INTEGER INITIAL 132.
DEFINE  VARIABLE lcompatible AS LOGICAL  INITIAL FALSE. 
DEFINE  VARIABLE tmp_str AS CHARACTER NO-UNDO.
DEFINE  VARIABLE disptext AS CHARACTER NO-UNDO.
DEFINE  VARIABLE myline AS CHARACTER NO-UNDO.
DEFINE  VARIABLE sumtxt AS CHARACTER NO-UNDO INITIAL " ".


/* PROCEDURE: Print-Description
 */
PROCEDURE Print-Description: /* Interpret and Print value in s_ttb_tbl.rank_desc */

DEFINE  VARIABLE loop AS INTEGER INITIAL 0.
DEFINE  VARIABLE linewdth AS INTEGER INITIAL 128.
DEFINE  VARIABLE i AS INTEGER INITIAL 0.

DEFINE  VARIABLE i1 AS INTEGER NO-UNDO INITIAL 1.
DEFINE  VARIABLE i2 AS INTEGER NO-UNDO INITIAL 1.
DEFINE  VARIABLE i3 AS INTEGER NO-UNDO.

DEFINE  VARIABLE j AS INTEGER INITIAL 0.
DEFINE  VARIABLE k AS INTEGER INITIAL 0.
DEFINE  VARIABLE l AS INTEGER INITIAL 1.
DEFINE  VARIABLE m AS INTEGER INITIAL 0.
DEFINE  VARIABLE tagtxt AS CHARACTER NO-UNDO.
DEFINE  VARIABLE textbuffer AS CHARACTER NO-UNDO.
DEFINE  VARIABLE from-string AS CHARACTER NO-UNDO.

   Assign disptext = "".
   DO loop = 1 TO NUM-ENTRIES(s_ttb_tbl.rank_desc,":"): 
     IF ENTRY(loop,s_ttb_tbl.rank_desc,":") EQ "" THEN NEXT.
     assign m = m + 1.
     assign tagtxt = ENTRY(loop,s_ttb_tbl.rank_desc,":").
     assign i = NUM-ENTRIES(ENTRY(loop,s_ttb_tbl.rank_desc,":"),"|").
     IF i > 1 THEN DO:
         assign i = i - 1.
         assign textbuffer = DescArray[LOOKUP(ENTRY(1,tagtxt,"|"),kwlist)].
         DO j = 1 to i:
           assign from-string = "%" + STRING(j).
           assign k = j + 1.
           assign textbuffer = REPLACE (textbuffer, from-string,ENTRY(k,tagtxt,"|")). 
         END.
      END.
      ELSE assign textbuffer = DescArray[LOOKUP(ENTRY(loop,s_ttb_tbl.rank_desc,":"),kwlist)].
      disptext = disptext + chr(10) + STRING(m) + ".  ".
      IF LENGTH(textbuffer) > linewdth THEN DO:
         ASSIGN  i3 = linewdth
	         i2 = 1
		 i1 = 1.
	 REPEAT:
            ASSIGN i2 = R-INDEX(textbuffer," ",i3).
            IF i3 > LENGTH(textbuffer)  THEN LEAVE. 
	    disptext = disptext + trim(SUBSTRING(textbuffer,i1, i2 - i1)) + chr(10) + FILL(" ", 4 - LENGTH(STRING(m))).
            i3 = i2 + linewdth.
            i1 = i2.
         END. 
         disptext = disptext + trim(substring(textbuffer,i1,length(textbuffer))).
      END.
      ELSE disptext = disptext + textbuffer.
   END. 
PUT STREAM s_rank_rep UNFORMATTED disptext SKIP.
RETURN.
END PROCEDURE.

/*======================== Mainline =================================== */

OUTPUT stream s_rank_rep to VALUE(outfile). 
assign disptext = "".
assign myline = CHR(10) + FILL("_",80) + CHR(10).

/* dump "Migration" screen options for reference */
PUT STREAM s_rank_rep UNFORMATTED SKIP "     Migration window selections     Date:" NOW .
PUT STREAM s_rank_rep UNFORMATTED myline SKIP. 

PUT STREAM s_rank_rep UNFORMATTED "Original OpenEdge Database:     " pro_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Connect Parameters for OpenEdge:" pro_conparms SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Name of Schema Holder Database: " osh_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Logical Database Name:          " mss_pdbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "ODBC Data Source Name:          " mss_dbname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Username:                       " mss_username SKIP.
PUT STREAM s_rank_rep UNFORMATTED "User's Password:                ***** " SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Connect Parameters:             " mss_conparms SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Maximum Varchar Length:         " long-length SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Codepage:                       " mss_codepage SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Collation:                      " mss_collname SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Insensitive:                    " mss_incasesen SKIP.
PUT STREAM s_rank_rep UNFORMATTED "Rank Report Level:              ".
 CASE genreplvl:
      WHEN 0 THEN assign disptext = "No Ranking Logging.".
      WHEN 1 THEN assign disptext = "Summary Ranking.".
      WHEN 2 OR WHEN 3 THEN assign disptext = "Itemized Ranking.".
      OTHERWISE 
         assign disptext = "Itemized Ranking.".
 END CASE.
PUT STREAM s_rank_rep UNFORMATTED disptext SKIP(1).

IF loadsql THEN PUT STREAM s_rank_rep UNFORMATTED "[X] " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] " .
PUT STREAM s_rank_rep UNFORMATTED "Load SQL       ".

IF movedata THEN PUT STREAM s_rank_rep UNFORMATTED "[X] " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] " .
PUT STREAM s_rank_rep UNFORMATTED "Move Data" .
PUT STREAM s_rank_rep UNFORMATTED myline . 

/* dump "Advanced" screen options for reference */
PUT STREAM s_rank_rep UNFORMATTED SKIP "  ********* Advanced window selections *********  " SKIP.

IF (UPPER(ENTRY(1,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "[X] " .
ELSE PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "[ ] " .
PUT STREAM s_rank_rep UNFORMATTED "Migrate Constraints" .

PUT STREAM s_rank_rep UNFORMATTED myline .
IF (UPPER(ENTRY(2,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED  "[X] ".
ELSE PUT STREAM s_rank_rep UNFORMATTED  "[ ] ".
PUT STREAM s_rank_rep UNFORMATTED "Try Primary for ROWID    ".

IF (UPPER(ENTRY(3,user_env[36])) = "Y") THEN PUT STREAM s_rank_rep UNFORMATTED "[X] " .
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] " .
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
       PUT STREAM s_rank_rep UNFORMATTED "  [X] For " .
       IF (ENTRY(3,user_env[27]) EQ "D" ) THEN 
         PUT STREAM s_rank_rep UNFORMATTED "   (X) ROWID   ( ) Prime ROWID " SKIP.
       ELSE
         PUT STREAM s_rank_rep UNFORMATTED "   ( ) ROWID   (X) Prime ROWID " SKIP.
       PUT STREAM s_rank_rep UNFORMATTED "  [ ] For ROWID Uniqueness" SKIP. 
    END.
    ELSE DO:
       PUT STREAM s_rank_rep UNFORMATTED "  [ ] For  ( ) ROWID   ( ) Prime ROWID " SKIP.
       PUT STREAM s_rank_rep UNFORMATTED "  [X] For ROWID Uniqueness" SKIP. 
    END.
  END.
END. 

IF NUM-ENTRIES(user_env[36]) >= 4 AND (UPPER(ENTRY(4,user_env[36])) EQ "Y" ) THEN DO: 
  PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "[X] Select Best ROWID Index"  SKIP.
  PUT STREAM s_rank_rep UNFORMATTED "    USING     " .
  IF ENTRY(5,user_env[36]) EQ "1" THEN
     PUT STREAM s_rank_rep UNFORMATTED "(X) OE Schema  ( ) Foreign Schema" .
  ELSE
     PUT STREAM s_rank_rep UNFORMATTED "( ) OE Schema  (X) Foreign Schema" .
END.

PUT STREAM s_rank_rep UNFORMATTED myline. 
IF user_env[12]  = "datetime" THEN PUT STREAM s_rank_rep UNFORMATTED "[X] Map to MSS 'Datetime' Type".
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] Map to MSS 'Datetime' Type".

IF UPPER(user_env[21]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "    [X] Create Shadow Column" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "    [ ] Create Shadow Column" SKIP.

IF NUM-ENTRIES(user_env[25]) >= 2 AND (UPPER(ENTRY(2,user_env[25])) EQ "Y" ) THEN 
     PUT STREAM s_rank_rep UNFORMATTED "[X] Use revised sequence Generator" .
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] Use revised sequence Generator" .

PUT STREAM s_rank_rep UNFORMATTED myline. 
IF user_env[11]  = "nvarchar" THEN PUT STREAM s_rank_rep UNFORMATTED "[X] Use Unicode Types".
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] Use Unicode Types".
IF UPPER(user_env[35]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "      [X] Expand Width(utf-8)" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "      [ ] Expand Width(utf-8)" SKIP.
IF UPPER(user_env[33]) = "Y" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "For field widths use  (X) Width  ( ) ABL Format" .
ELSE PUT STREAM s_rank_rep UNFORMATTED "For field widths use  ( ) Width  (X) ABL Format" .
IF lExpand THEN PUT STREAM s_rank_rep UNFORMATTED "   [X] Expand x(8) to 30".
ELSE PUT STREAM s_rank_rep UNFORMATTED "   [ ] Expand x(8) to 30" .

PUT STREAM s_rank_rep UNFORMATTED myline .
IF UPPER(user_env[38]) = "1" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "Apply Uniqueness as: (X) Index Attributes  ( ) Constraints" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "Apply Uniqueness as: ( ) Index Attributes  (X) Constraints" SKIP.

IF UPPER(user_env[7]) = "Y" THEN PUT STREAM s_rank_rep UNFORMATTED "(X) Include Default" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "[ ] Include Default" SKIP.

IF UPPER(user_env[39]) = "1" THEN 
   PUT STREAM s_rank_rep UNFORMATTED "Apply Defaults as: (X) Field Attributes  ( ) Constraints" SKIP.
ELSE PUT STREAM s_rank_rep UNFORMATTED "Apply Defaults as: ( ) Field Attributes  (X) Constraints" SKIP.

PUT STREAM s_rank_rep UNFORMATTED SKIP(1) "  ********* ******************************** *********  " SKIP.
/* end of "Advanced" screen options */

IF genreplvl > 0 THEN DO : 
    PUT STREAM s_rank_rep UNFORMATTED SKIP(2) "************* Ranking Information ************ *********  ".
      CASE genreplvl:
      WHEN 1 THEN assign disptext = CHR(10) + "    Report ranking level is set to - 1: Summary Ranking." + CHR(10).
      WHEN 2 THEN assign disptext = CHR(10) + "    Report ranking level is set to - 2: Itemized Ranking." + CHR(10).
      WHEN 3 THEN assign disptext = CHR(10) + "    Report ranking level is set to - 3: Itemized Ranking." + CHR(10).
      WHEN 4 THEN assign disptext = CHR(10) + "    Report ranking level is set to - 4: Itemized Ranking. - With schema info" + CHR(10).
      OTHERWISE DO:
         assign disptext = CHR(10) + "    WARNING: Report level specified is Invalid. Adjusting it to - 2: Summary Ranking" + CHR(10).
	 assign genreplvl = 2.
        END.
      END CASE.
  PUT STREAM s_rank_rep UNFORMATTED disptext.
  
  IF ((NUM-ENTRIES(user_env[42]) >= 2) AND
       UPPER(ENTRY(2,user_env[42])) = "L" ) THEN 
    PUT STREAM s_rank_rep UNFORMATTED "   Ranking Happened using Legacy ranking Algorithm." SKIP.
  ELSE PUT STREAM s_rank_rep UNFORMATTED "   Ranking Happened using NEW ranking Algorithm." SKIP.

  IF genreplvl > 1 THEN DO: 
     Assign disptext = CHR(10) + "Index list Ranking column indicators:" + CHR(10) +  
                       " +Ranking - a:Automatically Selectable, u:User-definable," +
                       "x:Non-V7.3 compatible, v:Uniqueness Enforced." + CHR(10) + 
                       " +Ranking - n:Uniqueness missing, m:Mandatory missing," +
                       " c-RECID compatible index.".
     PUT STREAM s_rank_rep UNFORMATTED disptext.
  END.

  FOR EACH DICTDB._File WHERE NOT DICTDB._FILE._Hidden AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN"):
    assign disptext = " ".

    PUT STREAM s_rank_rep UNFORMATTED SKIP(2) "    =========================================================    " SKIP.

    IF NOT CAN-FIND( FIRST DICTDB._INDEX WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND 
             DICTDB._Index._Index-name <> "default" ) THEN
       assign i1 = 0. 
    ELSE assign i1 = DICTDB._FILE._Prime-index.

    assign disptext = disptext + "Table Name: " + UPPER(DICTDB._FILE._File-name) + 
                     FILL(" ", 15 - LENGTH(DICTDB._FILE._File-name)) + FILL(" ",5) +  
                    "Prime Index ID:" + STRING(i1) + CHR(10). 
    IF genreplvl > 3 THEN   		    
       Assign disptext = disptext + " MISC1[1]: " + 
                       ( IF DICTDB._FILE._Fil-misc1[1] <> ? THEN STRING(DICTDB._FILE._Fil-misc1[1]) ELSE " ") + FILL(" ",10) +
                       " Misc1[2]:" + (IF DICTDB._FILE._Fil-misc1[2] <> ? THEN STRING(DICTDB._FILE._Fil-misc1[2])  ELSE "  ") + CHR(10) +
                       " MISC2[4]:" + (IF DICTDB._FILE._Fil-misc2[4] <> ? THEN DICTDB._FILE._Fil-misc2[4]  ELSE "        ") + FILL(" ",5) + 
                       " MISC2[5]:" + (IF DICTDB._FILE._Fil-misc2[5] <> ? THEN DICTDB._FILE._Fil-misc2[5] ELSE "   ") + CHR(10) +
                       " MISC1[5]:" + (IF DICTDB._FILE._Fil-misc1[5] <> ? THEN  STRING(DICTDB._FILE._Fil-misc1[5]) ELSE " ") + CHR(10).
    assign sumtxt = "Summary (" .
    IF DICTDB._FILE._Fil-misc1[1] > 0 THEN
       Assign disptext = disptext + "This table has PROGRESS_RECID column as ROWID" + CHR(10). 
    ELSE IF DICTDB._File._Fil-misc1[2] > 0 THEN DO:
      Assign disptext = disptext + CHR(10) + "ROWID Index designation: Serial# " + STRING(DICTDB._FILE._Fil-misc1[2]) + CHR(10).
      FIND FIRST DICTDB._INDEX WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND 
                                     DICTDB._INDEX._idx-num = DICTDB._FILE._Fil-misc1[2] NO-ERROR.
      IF AVAILABLE DICTDB._INDEX THEN DO:
         assign sumtxt = sumtxt + "SELECTED ROWID".
         IF INDEX(DICTDB._INDEX._I-misc2[1],"c") <> 0 THEN
	    assign sumtxt = sumtxt + "/RECID".
         assign sumtxt = sumtxt + " IS:""" + DICTDB._Index._Index-name + """):".

      END.
    END.	  
    ELSE DO:
       Assign disptext = disptext + "      ******  NO ROWID Designated  ****** " + CHR(10). 
       assign sumtxt = sumtxt + "UNSELECTED):".
    END.
    PUT STREAM s_rank_rep UNFORMATTED SKIP disptext.

    IF genreplvl > 1 THEN DO:
       FIND FIRST DICTDB._INDEX WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND DICTDB._Index._Index-name <> "default" NO-ERROR. 
       IF AVAILABLE DICTDB._INDEX THEN DO: 
          Assign disptext = "-----------   ALL INDEXES of table " + UPPER(DICTDB._FILE._File-name) + "  ----------------------" + CHR(10).
          Assign disptext = disptext + "Index Sr#  Unique  Index-recid    Index Name          Column#  Ranking+" .
          PUT STREAM s_rank_rep UNFORMATTED disptext.
          PUT STREAM s_rank_rep UNFORMATTED myline .

          FOR EACH DICTDB._Index WHERE DICTDB._INDEX._File-recid = RECID(DICTDB._FILE) AND  
                                DICTDB._Index._Index-name <> "default" BY DICTDB._Index._idx-num:
       
             ASSIGN disptext =  FILL(" ",5 - LENGTH(STRING(DICTDB._INDEX._idx-num))) + STRING(DICTDB._INDEX._idx-num) + FILL(" ",6).
             IF   DICTDB._Index._Unique THEN ASSIGN disptext = disptext + "yes" + FILL(" ",5).
             ELSE ASSIGN disptext = disptext + "no" + FILL(" ",6). 
       
             assign disptext = disptext + FILL (" ", 11 - LENGTH(STRING(RECID(DICTDB._INDEX)))) + STRING(RECID(DICTDB._INDEX)) + FILL(" ",4) +
                               DICTDB._INDEX._Index-name  + FILL (" ", 15 - LENGTH(DICTDB._INDEX._Index-name)) + FILL(" ",2) +   
			       FILL (" ", 6 - LENGTH(STRING(DICTDB._INDEX._num-comp))) + STRING(DICTDB._INDEX._num-comp) + FILL(" ",6) +  
                               DICTDB._INDEX._I-misc2[1].
             IF substring(DICTDB._INDEX._I-misc2[1],1,1) EQ "r" THEN
                assign disptext = disptext + "- Designated ROWID.".

	     PUT STREAM s_rank_rep UNFORMATTED disptext SKIP.
          END.
       END.
    END.
    FIND FIRST s_ttb_tbl WHERE s_ttb_tbl.tmp_recid = RECID(DICTDB._FILE) NO-ERROR.
    IF AVAILABLE s_ttb_tbl THEN DO: /* Print description and clean up temp table. */
       PUT STREAM s_rank_rep UNFORMATTED SKIP(1) sumtxt .
       RUN Print-Description.
       DELETE s_ttb_tbl.
    END.
 END.
END.
PUT STREAM s_rank_rep UNFORMATTED SKIP(2)"++++++++++ END OF REPORT ++++++++++ " NOW SKIP.
OUTPUT STREAM s_rank_rep CLOSE.
