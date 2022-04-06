/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _qflddat.p

Description:
   Display _Field information for the quick field report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId  - Id of the _Db record for this database.
   p_Tbl   - The name of the table whose fields we're showing or "ALL"
   p_Order - "a" for alphabetical order or "o" for _Order order. 

Author: Tony Lavinio, Laura Stern

Date Created: 10/02/92

Modifed on 05/31/95 gfs Allow display of hidden tables (not meta-schema).
           06/14/94 gfs Added NO-LOCKs on file accesses.
           05/10/00 DLM Added check of _owner.
           08/25/03 D. McMann Update report for 10.0A
----------------------------------------------------------------------------*/
{ prodict/fhidden.i }

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Order AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE BUFFER   bField FOR _Field.
DEFINE BUFFER   bFile  FOR _File.
DEFINE VARIABLE flags  AS  CHARACTER    NO-UNDO.

FORM
   bFile._File-name  LABEL "Table"
   SKIP
   WITH FRAME tblhdr USE-TEXT STREAM-IO SIDE-LABELS.      

FORM
   bField._Field-name FORMAT "x(27)" COLUMN-LABEL "Field Name"
   bField._Data-type  FORMAT "x(10)" COLUMN-LABEL "Data Type"
   flags              FORMAT "x(3)"  COLUMN-LABEL "Flg"
   bField._Format     FORMAT "x(32)" COLUMN-LABEL "Format"
   WITH FRAME shofield STREAM-IO
   DOWN USE-TEXT.

FORM
  SKIP(1) 
  SPACE(3) bFile._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*=========================Internal Procedures==========================*/

/*---------------------------------------
   Display the data for the record
   in the bField buffer.
---------------------------------------*/
PROCEDURE Display_Rec:
  DEFINE VARIABLE dspdt   AS CHARACTER NO-UNDO.
  
   IF bField._Data-type = "DATETIME" THEN
     ASSIGN dspdt = "datetm".
   ELSE IF bField._Data-type = "DATETIME-TZ" THEN
     ASSIGN dspdt = "datetm-tz".
   ELSE IF bField._Data-type = "INT64" THEN
     ASSIGN dspdt = "I64".
   ELSE 
     ASSIGN dspdt = SUBSTRING(bField._Data-type,1,4,"CHARACTER":u).
   
   IF bField._Data-type <> "Decimal" OR bField._Decimals = ? THEN.
   ELSE 
     ASSIGN dspdt = dspdt + "-" + STRING(bField._Decimals).

   IF bField._Extent > 0 THEN
     ASSIGN dspdt = dspdt + "[" + STRING(bField._Extent) + "]".


   DISPLAY STREAM rpt
      bField._Field-name
      dspdt @ bField._Data-type
  
      /* flags */
      (   (IF bField._Fld-case THEN "c" ELSE "")
        + (IF CAN-FIND(FIRST _Index-field OF bField)
          THEN "i" ELSE "")
        + (IF bField._Mandatory THEN "m" ELSE "")       
      ) @ flags

      bField._Format
      WITH FRAME shofield.
   DOWN STREAM rpt WITH FRAME shofield.
END.


/*============================Mainline Code=============================*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH bFile NO-LOCK WHERE bFile._Db-recid = p_DbId AND
               	     (IF p_Tbl = "ALL" THEN (IF NOT fHidden THEN NOT bFile._Hidden ELSE bFile._File-Number > 0)
      	       	     	               ELSE bFile._File-name = p_Tbl)
      	       BY bFile._File-name:
  IF INTEGER(DBVERSION("DICTDB")) > 8 AND
      (bFile._Owner <> "PUB" AND bFile._Owner <> "_FOREIGN") THEN NEXT.
   PAGE STREAM rpt.

   IF p_Tbl = "ALL" THEN
      DISPLAY bFile._File-name WITH FRAME working_on.

   DISPLAY STREAM rpt bFile._File-name WITH FRAME tblhdr.
   
   if INDEX(p_Order, "a") > 0 THEN
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Name:
	 RUN Display_Rec. 
      END.
   ELSE
      FOR EACH bField OF bFile NO-LOCK USE-INDEX _Field-Position:
	 RUN Display_Rec.
      END.
END.


IF p_Tbl = "ALL" THEN
DO:
   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.


