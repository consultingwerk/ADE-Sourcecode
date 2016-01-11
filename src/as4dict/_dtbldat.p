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

File: _dtbldat.p

Description:
   Display detailed table,  field and index information to
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId  - Id of the _Db record for this database.
   p_Tbl   - The name of the table to report on - or ALL for all tables.
   p_Order - Order for field display, "a"- alphabetical or "o" - by order#.

Author: Laura Stern

Date Created: 10/09/92

Modified on 6/7/94 by GFS - 94-05-09-001 - Added NO-LOCKs
            02/09/95 by D McMann to work with PROGRESS/400 Data Dictionary   
            12/18/95 by D. McMann to change _Fld-stoff to _fld-stoff + 1.  
            10/24/96 by D. McMann Added logic to show hidden files 96-10-18-020
            09/29/97 by D. McMann Added logic to display word index flag
            04/06/99 by D. McMann Added stored procedure support

----------------------------------------------------------------------------*/
{as4dict/dictvar.i shared}

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Order AS CHAR  NO-UNDO.

DEFINE BUFFER   bField FOR as4dict.p__Field.
DEFINE BUFFER   bFile  FOR as4dict.p__File.

DEFINE SHARED STREAM rpt.

DEFINE VARIABLE line        AS CHAR                    NO-UNDO.
DEFINE VARIABLE name        AS CHAR                    NO-UNDO.
DEFINE VARIABLE descrip     AS CHAR    INITIAL ""      NO-UNDO.
DEFINE VARIABLE flags       AS CHAR		          NO-UNDO.
DEFINE VARIABLE idx_primary AS LOGICAL		   NO-UNDO.
DEFINE VARIABLE check_crc   AS LOGICAL		   NO-UNDO.
DEFINE VARIABLE word_idx    AS LOGICAL		   NO-UNDO.
DEFINE VARIABLE temp 	    AS CHAR                      NO-UNDO. 
DEFINE VARIABLE ascdec      AS CHAR FORMAT "x(1)"       NO-UNDO.
DEFINE VARIABLE typelen     AS CHAR                     NO-UNDO. 
DEFINE VARIABLE asflags     AS CHAR                     NO-UNDO.     
DEFINE VARIABLE pname      AS CHAR                      NO-UNDO.    
DEFINE VARIABLE ronote      AS CHAR                     NO-UNDO.
DEFINE VARIABLE fldstoff1   AS  INTEGER                 NO-UNDO.
DEFINE VARIABLE trig-event  AS CHARACTER                NO-UNDO.

DEFINE VAR lbls AS CHAR EXTENT 14 NO-UNDO INITIAL
   [ /* 1 */ "  AS/400 Name: ",
     /* 2 */ "  Record Size: ",
     /* 3 */ "        Label: ",
     /* 4 */ "    Col-Label: ",
     /* 5 */ "  Description: ",
     /* 6 */ "         Help: ",
     /* 7 */ "      Val-Msg: ",
     /* 8 */ "      Val-Exp: ", 
     /* 9 */ "** Field Name: ",
     /*10 */ "** Index Name: ",
     /*11 */ "               ",
     /*12 */ ""               ,
     /*13*/ "  Format Name: ",  
     /*14*/ " Virtual Type: "
   ].

&GLOBAL-DEFINE LBL_OWNER      1
&GLOBAL-DEFINE LBL_RECSIZE    2
&GLOBAL-DEFINE LBL_LABEL      3
&GLOBAL-DEFINE LBL_COLLABEL   4
&GLOBAL-DEFINE LBL_DESC       5
&GLOBAL-DEFINE LBL_HELP       6
&GLOBAL-DEFINE LBL_VALMSG     7
&GLOBAL-DEFINE LBL_VALEXP     8
&GLOBAL-DEFINE LBL_FLDNAME    9
&GLOBAL-DEFINE LBL_IDXNAME    10
&GLOBAL-DEFINE LBL_EMPTY      11
&GLOBAL-DEFINE LBL_NONE       12   
&GLOBAL-DEFINE LBL_FNAME    13    
&GLOBAL-DEFINE LBL_VTYPE      14

DEFINE VAR separators AS CHAR EXTENT 7 NO-UNDO INITIAL 
[
  "=========================================================================",
  "============================= FIELD SUMMARY =============================", 
  "============================= INDEX SUMMARY =============================",
  "============================= FIELD DETAILS =============================",
  "============================= Table: ",
  "============================= SEQUENCES =================================",
  "============================= AS/400 FIELD DETAILS ======================"
].

&GLOBAL-DEFINE SEP_NEXTTBL    1
&GLOBAL-DEFINE SEP_SUMFIELD   2
&GLOBAL-DEFINE SEP_SUMINDEX   3
&GLOBAL-DEFINE SEP_DETFIELD   4
&GLOBAL-DEFINE SEP_TBLNAME    5
&GLOBAL-DEFINE SEP_SEQUENCE   6   
&GLOBAL-DEFINE SEP_AS4FLDTL   7

&GLOBAL-DEFINE SEP_TBLEND " " + STRING(separators[{&SEP_NEXTTBL}], ~
      	       	     	  SUBSTITUTE("x(&1)", 35 - LENGTH(bFile._File-name)))


/*=================================Forms===================================*/

/* For general long text strings.  line is formatted as appropriate. */
FORM
   line FORMAT "x(77)" NO-LABEL
   WITH FRAME rptline NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   bFile._File-name       FORMAT "x(29)"   COLUMN-LABEL "Table!Name"
   bFile._Dump-name  FORMAT "x(8)"      COLUMN-LABEL "Dump!Name"
   flags                             FORMAT "x(5)"      COLUMN-LABEL "Table!Flags"        
   bFile._File-label        FORMAT "x(19)"    COLUMN-LABEL "Table!Label"
   bFile._numfld            FORMAT ">>>>9"  COLUMN-LABEL "Field!Count"
   bFile._numkey          FORMAT ">>>>9"  COLUMN-LABEL "Index!Count" 
   WITH FRAME sumtable NO-ATTR-SPACE USE-TEXT STREAM-IO DOWN.

FORM
   trig-event                    AT 8  FORMAT "x(18)"  COLUMN-LABEL "Trigger Event"
   as4dict.p__Trgfl._Proc-name         FORMAT "x(20)"  COLUMN-LABEL "Trigger Procedure"
   as4dict.p__Trgfl._Override          FORMAT "yes/no" COLUMN-LABEL "Overridable?"
   check_crc                           FORMAT "yes/no" COLUMN-LABEL "Check CRC?"
   WITH FRAME tbltrigs NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   bField._Order      FORMAT ">>>>9" COLUMN-LABEL "Order"
   bField._Field-name FORMAT "x(25)" COLUMN-LABEL "Field Name"
   bField._Data-type  FORMAT "x(9)" COLUMN-LABEL "Data Type"
   flags              FORMAT "x(4)"  COLUMN-LABEL "Flags"
   bField._Format     FORMAT "x(17)" COLUMN-LABEL "Format"
   bField._Initial    FORMAT "x(10)" COLUMN-LABEL "Initial"
   WITH FRAME sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.    
  
FORM
  bField._Field-name FORMAT "x(30)"  COLUMN-LABEL "Field Name"
  bField._Label      FORMAT "x(22)"  COLUMN-LABEL "Label"
  bField._Col-label  FORMAT "x(22)"  COLUMN-LABEL "Column Label"
  WITH FRAME fieldlbls NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.    
  
FORM
   pname                        FORMAT "x(25)" COLUMN-LABEL "Progress Name"
   bField._For-name   FORMAT "x(10)" COLUMN-LABEL "AS/400 Name"
   typelen            FORMAT "x(11)" COLUMN-LABEL "Type/Length"   
   asflags            FORMAT "x(4)"  COLUMN-LABEL "Flags"
   fldstoff1  FORMAT ">>>>>9" COLUMN-LABEL "Offset"
   bField._Fld-stlen  FORMAT ">>>>>9" COLUMN-LABEL "Bytes"
   WITH FRAME as4sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.   


FORM
   as4dict.p__Trgfd._Event	 AT 8  FORMAT "x(13)"  COLUMN-LABEL "Trigger Event"
   as4dict.p__Trgfd._Proc-name      FORMAT "x(20)"  COLUMN-LABEL "Trigger Procedure"
   as4dict.p__Trgfd._Override       FORMAT "yes/no" COLUMN-LABEL "Overridable?"
   check_crc         	       FORMAT "yes/no" COLUMN-LABEL "Check CRC?"
   WITH FRAME fldtrigs NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  flags                   FORMAT "x(5)"  COLUMN-LABEL "Flags"
  as4dict.p__Index._Index-name      FORMAT "x(32)" COLUMN-LABEL "Index Name"
  as4dict.p__Index._Num-comp        FORMAT ">>9"   COLUMN-LABEL "Cnt"
  ascdec                                           COLUMN-LABEL "Fi" SPACE(0)
  as4dict.p__Field._Field-name      FORMAT "x(31)" COLUMN-LABEL "eld Name"
  WITH FRAME sumindex NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) bFile._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*==========================Internal Procedures==============================*/

/*--------------------------------------------------------------
   Display a line of the report, splitting it apart if it is 
   longer than will fit and making sure to split on a delimiter
   (blank) boundary.  Don't display it if it's blank.

   Input Parameter:
      p_Str   - The string to display
      p_Label - Label to display on the first line
      p_null  - display even if p_Str is null else do nothing.
----------------------------------------------------------------*/
PROCEDURE Display_Value:

&GLOBAL-DEFINE TEXTLEN	60  /* 77 - Max length of label */

   DEFINE INPUT PARAMETER p_Str   AS CHAR    NO-UNDO.
   DEFINE INPUT PARAMETER p_Label AS CHAR    NO-UNDO.
   DEFINE INPUT PARAMETER p_null  AS LOGICAL NO-UNDO.
   
   DEFINE VARIABLE val  AS CHAR    NO-UNDO.
   DEFINE VARIABLE ix   AS INTEGER NO-UNDO.
   DEFINE VARIABLE frst AS LOGICAL NO-UNDO INIT yes.

   IF NOT p_null AND p_Str = "" THEN RETURN.

   DO WHILE LENGTH(p_Str) > {&TEXTLEN}:
      /* Find the last delimiter within the length of text that will fit. */
      ASSIGN
      	 ix = R-INDEX(SUBSTR(p_Str,1,{&TEXTLEN}), " ")
      	 ix = (IF ix = 0 THEN {&TEXTLEN} ELSE ix)
      	 val = SUBSTR(p_Str,1,ix - 1)  	     /* everything up to that */
      	 p_Str = TRIM(SUBSTR(p_Str,ix + 1)). /* reset to remainder */

      DISPLAY STREAM rpt 
      	 (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + val @ line
      	 WITH FRAME rptline.
      DOWN STREAM rpt WITH FRAME rptline.
      frst = no.
   END.
   DISPLAY STREAM rpt 
      (IF frst THEN p_Label ELSE lbls[{&LBL_EMPTY}]) + p_Str @ line
      WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
END.


/*--------------------------------------------------------------------
   Display the data for one record of the field summary report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Summary_Rec:

   DISPLAY STREAM rpt
      bField._Order
      bField._Field-name
  
      /* data type */
      SUBSTRING(bField._Data-type,1,4)
        + (IF bField._Data-type <> "Decimal" OR bField._Decimals = ? THEN ""
          ELSE "-" + STRING(bField._Decimals))
        + (IF bField._Extent = 0 THEN ""
          ELSE "[" + STRING(bField._Extent) + "]")
        @ bField._Data-type
  
      /* flags */
      (   (IF bField._Fld-case = "Y"  AND bField._Data-type = "character" THEN "c" ELSE "")
        + (IF CAN-FIND(FIRST as4dict.p__Idxfd where as4dict.p__Idxfd._File-number = bfile._File-number 
                                        and as4dict.p__Idxfd._fld-number = bfield._Fld-number)                         
          THEN "i" ELSE "")
        + (IF bField._Mandatory = "Y" THEN "m" ELSE "")
        + (IF CAN-FIND(FIRST as4dict.p__Vref
          WHERE as4dict.p__Vref._Ref-Table = bFile._File-name
          AND as4dict.p__Vref._Base-col = bField._Field-name)
          THEN "v" ELSE "")
      ) @ flags

      bField._Format
      bField._Initial
      WITH FRAME sumfield.
   DOWN STREAM rpt WITH FRAME sumfield.
END.

/*--------------------------------------------------------------------
   Display the AS400 data for one record of the field summary report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_AS4_Fld_Summary_Rec:
  define var frmt as character.
  define var lngth as integer.   
  define var pos as integer.                          
  define var dec_point as integer.
  define var all_digits as integer. 
  define var dec_digits as integer.    
 
        
  assign frmt = bfield._Format.

  if bField._Fld-Misc2[6] <> "A" then do:     

    IF bField._For-type = "Packede" THEN   
           typelen = (substring(bField._Fld-Misc2[6],1,1) + "    "
                          + STRING(bField._fld-stlen * 2) + "," + STRING(bField._decimals)).
     ELSE IF bField._for-type = "Packed" THEN   
           typelen = (substring(bField._Fld-Misc2[6],1,1) + "    "
                          + STRING((bField._fld-stlen * 2) - 1) + "," 
                           +   STRING(bField._decimals)).
    ELSE DO:  
      lngth = LENGTH(frmt, "character").
      all_digits = 0.
      dec_digits = 0.
    
      /* First, count all the digits in the format. */
      Do pos = 1 to lngth:
        if (SUBSTRING(frmt, pos, 1) = ">") OR 
           (SUBSTRING(frmt, pos, 1) = "9")
            then all_digits = all_digits + 1.          
      End.
                           
      /* Then count the digits to the right of the decimal point. */
      assign dec_point = INDEX(frmt, ".").
      if dec_point > 0 then do:
        do pos = dec_point to lngth:
          if (SUBSTRING(frmt, pos, 1) = "9") 
             then dec_digits = dec_digits + 1.
        end. 
      end.        
      assign typelen = (substring(bField._Fld-Misc2[6],1,1) + "    " + string(all_digits)).  
    
      IF dec_digits > 0 then 
        assign typelen = (typelen + "," + string(dec_digits)). 
          
    end.
  end.
  else      
      assign typelen = substring(bField._Fld-misc2[6],1,1) + "    " + string(bField._fld-stlen) .
      
      ASSIGN  fldstoff1 = (1 + bField._Fld-stoff).  
 
   DISPLAY STREAM rpt
      pname
      bField._For-name
      typelen
      
  
      /* flags */
      (   (IF bField._Fld-Misc2[2] = "Y" THEN "n" ELSE "")
        + (IF bField._For-Maxsize > 0 THEN "v" ELSE "")     
        + (IF bField._Fld-Misc2[5] = "A" THEN "A" ELSE "")
      ) @ asflags

       fldstoff1 
      bField._Fld-stlen
      WITH FRAME as4sumfield.  
      
   DOWN STREAM rpt WITH FRAME as4sumfield.
END.

/*--------------------------------------------------------------------
   Display the data for one record of the field label report which
   is in table format.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Labels:

   DISPLAY STREAM rpt
      bField._Field-name
      bField._Label
      bField._Col-label
      WITH FRAME fieldlbls.  	 
   DOWN STREAM rpt WITH FRAME fieldlbls.
END.


/*--------------------------------------------------------------------
   Display the data for field in the detail report.  This includes
   stuff that didn't fit in the summary tables.
--------------------------------------------------------------------*/
PROCEDURE Display_Fld_Detail_Rec:
   DEFINE VAR any_vals AS LOGICAL NO-UNDO.
   DEFINE VAR any_trig AS LOGICAL NO-UNDO.

   any_vals = (IF (bField._Desc = ?   OR bField._Desc = "")   AND
      	       	  (bField._Help = ?   OR bField._Help = "")   AND
      	       	  (bField._Valmsg = ? OR bField._Valmsg = "") AND
      	       	  (bField._Valexp = ? OR bField._Valexp = "") 
      	       THEN no else yes).
   any_trig = (IF CAN-FIND(FIRST as4dict.p__Trgfd where 
                     as4dict.p__Trgfd._File-number = bField._File-number 
                     and as4dict.p__Trgfd._Fld-number = bField._Fld-number)
                      THEN yes else no).

   IF any_vals OR any_trig THEN
      RUN Display_Value (bField._Field-name, lbls[{&LBL_FLDNAME}], no).

   IF any_vals THEN 
   DO:
      if bField._Desc <> ? THEN DO:
	 temp = REPLACE(bField._Desc, CHR(10), " "). /* remove carriage rtrns */
	 RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
      END.
      if bField._Help <> ? THEN
	 RUN Display_Value (bField._Help, lbls[{&LBL_HELP}], no).
      if bField._Valmsg <> ? THEN
	 RUN Display_Value (bField._Valmsg, lbls[{&LBL_VALMSG}], no).
      if bField._Valexp <> ? THEN
	 RUN Display_Value (bField._Valexp, lbls[{&LBL_VALEXP}], no).

      DOWN STREAM rpt 1 WITH FRAME rptline.
   END.

   /*----- Field triggers -----*/
   FOR EACH as4dict.p__Trgfd WHERE as4dict.p__Trgfd._File-number = bfile._File-number 
                                                                  AND as4dict.p__Trgfd._Fld-number = bField._Fld-number
                                                                  NO-LOCK:
      DISPLAY STREAM rpt 
      	 as4dict.p__Trgfd._Event
      	 as4dict.p__Trgfd._Proc-name
      	 as4dict.p__Trgfd._Override
      	 (IF as4dict.p__Trgfd._Trig-Crc <> 0 AND as4dict.p__Trgfd._Trig-Crc <> ?
      	    THEN yes ELSE no) @ check_crc
      	 WITH FRAME fldtrigs.
      DOWN STREAM rpt WITH FRAME fldtrigs.
   END.

   IF any_trig THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.
END.


/*===========================Mainline code=================================*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.
FIND as4dict.p__Db NO-LOCK.

/* Summary table data */
IF p_Tbl = "ALL" THEN DO:
   line = STRING("Table Name","x(15)") + "Description".
   DISPLAY STREAM rpt line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   line = FILL ("-", 76).
   DISPLAY STREAM rpt line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.

   FOR EACH bFile NO-LOCK WHERE (IF NOT s_Show_Hidden_Tbls THEN bFile._Hidden = "N"
                                 ELSE bFile._File-number > 0)
		             BY bFile._File-name:
      IF bFile._For-info = "PROCEDURE" THEN NEXT.		             
      temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
      RUN Display_Value (temp, 
      	       	     	 STRING(SUBSTR(bFile._File-name,1,14), "x(15)"),
      	       	     	 yes).
   END.
END.
 
FOR EACH bFile NO-LOCK WHERE(IF p_Tbl = "ALL" THEN (IF NOT s_Show_Hidden_Tbls THEN bFile._Hidden = "N"
                             ELSE bFile._File-number > 0)
      	       	     	     ELSE bFile._File-name = p_Tbl)
      	       BY bFile._File-name:
    IF bFile._For-info = "PROCEDURE" THEN NEXT.
    IF p_Tbl = "ALL" THEN
      DISPLAY bFile._File-name WITH FRAME working_on.

   /*----- Table information -----*/

   /* Table separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.  
   IF p_Tbl = "ALL" THEN page stream rpt.
   DISPLAY STREAM rpt separators[{&SEP_NEXTTBL}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_TBLNAME}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   
   flags = STRING("", "x(14)") + 
      	   "Table Flags: ""f"" = frozen, ""s"" = a SQL table".
   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Table info */      
   ASSIGN
      flags = (IF bFile._Db-lang = 1 THEN "s" ELSE "")
      flags = (flags + IF bFile._Frozen = "Y" THEN "f" ELSE "").

   DISPLAY STREAM rpt
      bFile._File-name
      bFile._Dump-name  
      bFile._File-label
      flags
      bFile._numkey  
      bFile._numfld
      WITH FRAME sumtable.

   IF (bFile._Desc <> ? AND bFile._Desc <> "" AND p_Tbl <> "ALL") OR
      (bFile._For-Owner <> ? AND bFile._For-Owner <> "") OR
      (bFile._For-Size <> ?) THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.

   IF bFile._Desc <> ? AND p_Tbl <> "ALL" THEN DO:
      temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
      RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
   END.
   if bFile._For-Name <> ? THEN
      RUN Display_Value (bFile._For-Name, lbls[{&LBL_OWNER}], no).    
   IF bFile._For-Format <> ? THEN
      RUN Display_Value(bFile._For-Format, lbls[{&LBL_FNAME}], no).
   if bFile._For-Size <> ? THEN
      RUN Display_Value (STRING(bFile._For-Size), lbls[{&LBL_RECSIZE}], no).
    if bFile._For-Flag > 0 THEN DO:
       if bFile._For-flag = 1 then ronote = "Limited logical".
       else if bFile._For-flag = 2 then ronote = "Multi record".
       else if bFile._For-flag = 3 then ronote = "Joined logical".
       else if bFile._For-flag = 4 then ronote = "Program described".
       else if bFile._For-flag = 5 then ronote = "Multi record program described".
       else ronote = "Virtual file/table".
        RUN Display_Value(ronote,lbls[{&LBL_VTYPE}],no).
    end.
        
   IF CAN-FIND(FIRST as4dict.p__Trgfl where as4dict.p__Trgfl._File-number = bfile._File-number) THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.

   /*----- Table triggers -----*/
   FOR EACH as4dict.p__Trgfl where 
         as4dict.p__Trgfl._File-number = bfile._File-number NO-LOCK:
      IF as4dict.p__Trgfl._Event = "RCREAT" THEN
        ASSIGN trig-event = "REPLICATION CREATE".
      ELSE IF as4dict.p__Trgfl._Event = "RWRITE" THEN
        ASSIGN trig-event = "REPLICATION WRITE".
      ELSE IF as4dict.p__Trgfl._Event = "RDELET" THEN
        ASSIGN trig-event = "REPLICATION DELETE".
      ELSE
        ASSIGN trig-event = as4dict.p__Trgfl._Event.
     
      DISPLAY STREAM rpt 
      	 trig-event
      	 as4dict.p__Trgfl._Proc-name
      	 as4dict.p__Trgfl._Override
      	 (IF as4dict.p__Trgfl._Trig-Crc <> 0 AND as4dict.p__Trgfl._Trig-Crc <> ?
      	    THEN yes ELSE no) @ check_crc
      	 WITH FRAME tbltrigs.
      DOWN STREAM rpt WITH FRAME tbltrigs.
   END.

   /*----- Field summary -----*/

   /* Field separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_SUMFIELD}] @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   flags = "Flags: <c>ase sensitive, <i>ndex component, <m>andatory, " +
           "<v>iew component".
   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Field info */
   IF p_Order = "a" THEN
      FOR EACH bField WHERE bField._File-number = bFile._File-number
           NO-LOCK USE-INDEX p__Field:  
               IF bField._Fld-Misc2[5] = "A" THEN NEXT.
	 RUN Display_Fld_Summary_Rec. 
      END.
   ELSE
      FOR EACH bField WHERE bField._File-number = bFile._File-number
           NO-LOCK USE-INDEX p__Fieldl0:    
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.        
              RUN Display_Fld_Summary_Rec.
      END.

   DOWN STREAM rpt 1 WITH FRAME rptline.


   /* Labels and Col labels */
   IF p_Order = "a" THEN
      FOR EACH bField WHERE bField._File-number = bFile._File-number
           NO-LOCK USE-INDEX p__Field:   
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.           
      	 RUN Display_Fld_Labels.
      END.
   ELSE
      FOR EACH bField WHERE bField._File-number = bFile._File-number
           NO-LOCK USE-INDEX p__Fieldl0:       
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.           
      	 RUN Display_Fld_Labels.
      END.
  /* AS400 Field Summary Info */
  
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_AS4FLDTL}] @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.
   
   flags = "Flags = (A)S/400 field only, (v)ariable length, (n)ull capable".

   DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
   DOWN STREAM rpt 2 WITH FRAME rptline.

   /* Field info */
   IF p_Order = "a" THEN
      FOR EACH bField where bField._File-number =
           bFile._File-number NO-LOCK USE-INDEX p__Field:    
               IF bField._Extent > 0 THEN NEXT.           
              IF bField._Fld-Misc1[8] = 1  AND bField._Fld-Misc2[5] = "A" THEN DO:
                 FIND as4dict.p__Field WHERE as4dict.p__field._file-number = bField._File-number
                                                                   AND as4dict.p__Field._Order = bField._Fld-misc1[7] 
                                                                   AND as4dict.p__Field._Extent > 0
                                                                   NO-LOCK.
                  ASSIGN pname = as4dict.p__Field._Field-name.
               END.
               ELSE IF bField._Fld-Misc2[5] = "A" THEN ASSIGN pname = "".
               ELSE ASSIGN pname = bField._Field-name.                    
               RUN  Display_AS4_Fld_Summary_Rec.
      END.
      ELSE               
      FOR EACH bField  where bField._File-number = bFile._File-number   NO-LOCK
                                                     by bField._fld-stoff :   
              IF bField._Extent > 0 THEN NEXT.           
              IF bField._Fld-Misc1[8] = 1  AND bField._Fld-Misc2[5] = "A" THEN DO:
                 FIND as4dict.p__Field WHERE as4dict.p__field._file-number = bField._File-number
                                                                   AND as4dict.p__Field._Order = bField._Fld-misc1[7]    
                                                                    AND as4dict.p__Field._Extent > 0
                                                                   NO-LOCK.
                  ASSIGN pname = as4dict.p__Field._Field-name.
               END.
               ELSE IF bField._Fld-Misc2[5] = "A" THEN ASSIGN pname = "".
               ELSE ASSIGN pname = bField._Field-name.                    
	 RUN  Display_AS4_Fld_Summary_Rec.
      END.               


   DOWN STREAM rpt 1 WITH FRAME rptline.


   /*----- Index Summary -----*/

   /* Index separator and flags */
   DOWN STREAM rpt 2 WITH FRAME rptline.
   IF CAN-FIND(FIRST as4dict.p__Index WHERE 
                   as4dict.p__Index._File-number = bfile._File-number) THEN DO:
      DISPLAY STREAM rpt separators[{&SEP_SUMINDEX}] @ line WITH FRAME rptline.
      DOWN STREAM rpt 2 WITH FRAME rptline.

      flags = "Flags: <p>rimary, <u>nique, <w>ord, <a>bbreviated, <i>nactive, " +
      	   "(+)asc, (-)desc".
      DISPLAY STREAM rpt flags @ line WITH FRAME rptline.
      DOWN STREAM rpt 2 WITH FRAME rptline.
   END.
   /* Index info */
   FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = bfile._File-number 
    NO-LOCK BREAK BY as4dict.p__Index._Index-name:    
 
      FIND LAST as4dict.p__Idxfd where as4dict.p__Idxfd._File-number = bfile._File-number
                           and as4dict.p__Idxfd._Idx-num =  as4dict.p__Index._Idx-num
                            NO-LOCK NO-ERROR.
      flags = 
      	 ( (IF bFile._Prime-index = as4dict.p__Index._Idx-num 
	       THEN "p" ELSE "")
	   + (IF as4dict.p__Index._Unique = "Y"   
	       THEN "u" ELSE "")
	   + (IF as4dict.p__Index._Active = "N"
	       THEN "i" ELSE "") 
	   + (IF as4dict.p__Index._Wordidx = 1
	       THEN "w" ELSE "") 
	   + (IF AVAILABLE as4dict.p__Idxfd AND
	         as4dict.p__Idxfd._Abbreviate = "Y"
	        THEN "a" ELSE "")).
	       
      
      DISPLAY STREAM rpt
      	  flags
	  as4dict.p__Index._Index-name
      	  as4dict.p__Index._Num-comp
      	  WITH FRAME sumindex.
      _idxfdloop:
     FOR EACH as4dict.p__Idxfd 
                    WHERE as4dict.p__Idxfd._File-number = bfile._file-number
                      AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num,
          EACH as4dict.p__Field where as4dict.p__Field._File-number = bfile._File-number
                        AND as4dict.p__field._Fld-number = as4dict.p__Idxfd._Fld-number NO-LOCK: 

         IF as4dict.p__Idxfd._If-Misc2[8] = "Y" THEN NEXT _idxfdloop.
         IF as4dict.p__Idxfd._Ascending = "Y" then assign ascdec = "+".
         else assign ascdec = "-".
         
	 DISPLAY STREAM rpt
	    as4dict.p__field._Field-name
	    ascdec
	    WITH FRAME sumindex.
	DOWN STREAM rpt WITH FRAME sumindex.
      END.
   
     /* Put an extra line in between each index. */
     IF LAST-OF(as4dict.p__Index._Index-name) THEN 
        DOWN STREAM rpt 1 WITH FRAME sumindex.
   END.

   /*----- Index descriptions -----*/
   FOR EACH as4dict.p__Index where as4dict.p__Index._File-number =
          bfile._File-number NO-LOCK:
      IF as4dict.p__Index._Desc <> ? AND as4dict.p__Index._Desc <> "" THEN DO:
         RUN Display_Value (as4dict.p__Index._Index-Name, lbls[{&LBL_IDXNAME}], no).
         temp = REPLACE(as4dict.p__Index._Desc, CHR(10), " ").
         RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
      END.
   END.
   
   /*----- Field details -----*/
     /* Detail separator */
     DOWN STREAM rpt 2 WITH FRAME rptline.
     DISPLAY STREAM rpt separators[{&SEP_DETFIELD}] @ line WITH FRAME rptline.
     DOWN STREAM rpt 2 WITH FRAME rptline.
     
     /* More field info */
     IF p_Order = "a" THEN
        FOR EACH bField where bfield._File-number = bfile._File-number
            NO-LOCK USE-INDEX p__Field:   
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.            
	   RUN Display_Fld_Detail_Rec. 
        END.
     ELSE
        FOR EACH bField where bfield._File-number = bfile._File-number
           NO-LOCK USE-INDEX p__Fieldl0:    
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.           
	      RUN Display_Fld_Detail_Rec.
        END.
   
END.

IF p_Tbl = "ALL" AND CAN-FIND(FIRST as4dict.p__Seq) THEN
DO:
   DISPLAY "Sequences" @ bFile._File-name WITH FRAME working_on.
   DOWN STREAM rpt 2 WITH FRAME rptline.
   DISPLAY STREAM rpt separators[{&SEP_SEQUENCE}] @ line WITH FRAME rptline.
   DOWN STREAM rpt WITH FRAME rptline.
   RUN as4dict/_qseqdat.p (INPUT p_DbId).

   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.
 
RETURN "".




