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

File: _dprcdat.p

Description:
   Display detailed procedure and paramater information to
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId  - Id of the _Db record for this database.
   p_Tbl   - The name of the procedure to report on - or ALL for all procedures.
   p_Order - Order for parameter display, "a"- alphabetical or "o" - by order#.

Author: Donna McMann

Date Created: 05/25/99
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

DEFINE VAR lbls AS CHAR EXTENT 4 NO-UNDO INITIAL
   [ /* 1 */ "  AS/400 Name: ",
     /* 2 */ "Progress Name: ",    
     /* 3 */ "  Description: ",      
     /* 4 */ "** Parameter Name: "         
   ].

&GLOBAL-DEFINE LBL_OWNER      1
&GLOBAL-DEFINE LBL_PROGNAME   2
&GLOBAL-DEFINE LBL_DESC       3
&GLOBAL-DEFINE LBL_PARMNAME   4

DEFINE VAR separators AS CHAR EXTENT 4 NO-UNDO INITIAL 
[
  "=========================================================================", 
  "============================= PARAMETERS ================================",
  "============================= Procedure: ",
  "======================= AS/400 PARAMETER DETAILS ======================"
].

&GLOBAL-DEFINE SEP_NEXTTBL    1
&GLOBAL-DEFINE SEP_PARMS      2
&GLOBAL-DEFINE SEP_Procedure  3
&GLOBAL-DEFINE SEP_AS4PARM    4

&GLOBAL-DEFINE SEP_TBLEND " " + STRING(separators[{&SEP_NEXTTBL}], ~
      	       	     	  SUBSTITUTE("x(&1)", 35 - LENGTH(bFile._File-name)))


/*=================================Forms===================================*/

/* For general long text strings.  line is formatted as appropriate. */
FORM
   line FORMAT "x(77)" NO-LABEL
   WITH FRAME rptline NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.

FORM
   bFile._File-name       FORMAT "x(29)"   COLUMN-LABEL "Procedure!Name"
   bFile._numfld            FORMAT ">>>>9"  COLUMN-LABEL "Parameter!Count"
   WITH FRAME sumtable NO-ATTR-SPACE USE-TEXT STREAM-IO DOWN.

FORM
   bField._Order      FORMAT ">>>>9" COLUMN-LABEL "Order"
   bField._Field-name FORMAT "x(25)" COLUMN-LABEL "Parameter Name"
   bField._Data-type  FORMAT "x(9)" COLUMN-LABEL "Data!Type"
   flags              FORMAT "x(12)"  COLUMN-LABEL "Flags"
   bField._Format     FORMAT "x(14)" COLUMN-LABEL "Format"
   bField._Initial    FORMAT "x(7)" COLUMN-LABEL "Initial"
   WITH FRAME sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.    
 
FORM
   pname                        FORMAT "x(25)" COLUMN-LABEL "Progress Name"
   bField._For-name   FORMAT "x(10)" COLUMN-LABEL "AS/400 Name"
   typelen            FORMAT "x(11)" COLUMN-LABEL "Type/Length"         
   WITH FRAME as4sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.   

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
    ASSIGN ix = R-INDEX(SUBSTR(p_Str,1,{&TEXTLEN}), " ")
           ix = (IF ix = 0 THEN {&TEXTLEN} ELSE ix)
           val = SUBSTR(p_Str,1,ix - 1)  	     /* everything up to that */
           p_Str = TRIM(SUBSTR(p_Str,ix + 1)). /* reset to remainder */

    DISPLAY STREAM rpt 
      (IF frst THEN p_Label ELSE "" ) val @ line
    WITH FRAME rptline.
    
    DOWN STREAM rpt WITH FRAME rptline.
    frst = no.
  END.
  DISPLAY STREAM rpt 
    (IF frst THEN p_Label ELSE "") + p_Str @ line
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
     (   (IF bField._Fld-Misc1[2] = 1 THEN "Input"
          ELSE IF bField._Fld-Misc1[2] = 2 THEN "Input-Output"
          ELSE "Output")
        
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
    assign typelen = substring(bField._Fld-misc2[6],1,1) + "    " + 
                     string(bField._fld-stlen) .
       
 
  DISPLAY STREAM rpt
      pname
      bField._For-name
      typelen        
      bField._Fld-stlen
      WITH FRAME as4sumfield.  
      
  DOWN STREAM rpt WITH FRAME as4sumfield.
END.


/*===========================Mainline code=================================*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.

/* Summary procedure data */
IF p_Tbl = "ALL" THEN DO:
  line = STRING("Procedure Name","x(15)") + "Description".
  DISPLAY STREAM rpt line WITH FRAME rptline.
  DOWN STREAM rpt WITH FRAME rptline.
  line = FILL ("-", 14) + " " + FILL ("-", 50).
  DISPLAY STREAM rpt line WITH FRAME rptline.
  DOWN STREAM rpt WITH FRAME rptline.

  FOR EACH bFile NO-LOCK WHERE bFile._For-Info = "Procedure"
		             BY bFile._File-name:
      		             
    temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
    RUN Display_Value
        (temp, 
        STRING(SUBSTR(bFile._File-name,1,14), "x(15)"),
        yes).
  END.
END.
 
FOR EACH bFile NO-LOCK WHERE(IF p_Tbl = "ALL" THEN bFile._FOR-Info = "PROCEDURE"
      	       	     	     ELSE bFile._File-name = p_Tbl)
      	       BY bFile._File-name:
    
  IF p_Tbl = "ALL" THEN
    DISPLAY bFile._File-name WITH FRAME working_on.

   /*----- Table information -----*/

   /* Table separator and flags */
  DOWN STREAM rpt 2 WITH FRAME rptline.  
  IF p_Tbl = "ALL" THEN page stream rpt.

  DISPLAY STREAM rpt separators[{&SEP_PROCEDURE}] + bFile._File-name + 
      {&SEP_TBLEND} @ line WITH FRAME rptline.
  DOWN STREAM rpt WITH FRAME rptline.   

  DISPLAY STREAM rpt
      bFile._File-name       
      bFile._numfld
      WITH FRAME sumtable.

  IF (bFile._Desc <> ? AND bFile._Desc <> "" AND p_Tbl <> "ALL") THEN
      DOWN STREAM rpt 1 WITH FRAME rptline.

  IF bFile._Desc <> ? AND p_Tbl <> "ALL" THEN DO:
    temp = REPLACE(bFile._Desc, CHR(10), " "). /* remove carriage rtrns */
    RUN Display_Value (temp, lbls[{&LBL_DESC}], no).
  END.   
  
   /* Parameter info */
  IF p_Order = "a" THEN
  FOR EACH bField WHERE bField._File-number = bFile._File-number
         NO-LOCK USE-INDEX p__Field:  
               
    RUN Display_Fld_Summary_Rec. 
  END.
  ELSE
  FOR EACH bField WHERE bField._File-number = bFile._File-number
           NO-LOCK USE-INDEX p__Fieldl0:                          
    RUN Display_Fld_Summary_Rec.
  END.

  DOWN STREAM rpt 1 WITH FRAME rptline.
END. 
RETURN "".




