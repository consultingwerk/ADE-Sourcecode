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

Modifed on 06/14/94 by Gerry Seidl. Added NO-LOCKs on file accesses. 
Modified on 02/13/95 by D McMann to work with Progress/400 Data Dictionary  
Modified on 12/18/95 by D. McMann to add 1 to _Fld-stoff.
            04/06/99 D. McMann added stored procedure support
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Order AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.

DEFINE BUFFER   bField FOR as4dict.p__Field.
DEFINE BUFFER   bFile  FOR as4dict.p__File.

DEFINE VARIABLE flags      AS CHARACTER    NO-UNDO.  
DEFINE VARIABLE as4info AS CHARACTER    NO-UNDO.
DEFINE VARIABLE typelen AS CHARACTER   NO-UNDO.     
DEFINE VARIABLE asflags AS CHARACTER   NO-UNDO.    
DEFINE VARIABLE spline   AS CHARACTER   NO-UNDO.         
DEFINE VARIABLE pname  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fldstoff1 AS INTEGER       NO-UNDO.
FORM 
   spline SKIP (1)
   WITH FRAME spacer USE-TEXT STREAM-IO NO-LABELS.
   
FORM
   "  Table:  " bFile._File-name  SKIP
   "Library: "  bFile._AS4-Library SKIP
   WITH FRAME tblhdr USE-TEXT STREAM-IO NO-LABELS.      

FORM
   bField._Order      FORMAT ">>>>9" COLUMN-LABEL "Order"
   bField._Field-name FORMAT "x(31)" COLUMN-LABEL "Field Name"
   bField._Data-type  FORMAT "x(12)" COLUMN-LABEL "Data Type"
   flags              FORMAT "x(4)"  COLUMN-LABEL "Flags"
   bField._Format     FORMAT "x(19)" COLUMN-LABEL "Format"   
   WITH FRAME shofield STREAM-IO
   DOWN USE-TEXT.

 FORM
   pname                       FORMAT "x(25)" COLUMN-LABEL "Progress Name"
   bField._For-name   FORMAT "x(10)" COLUMN-LABEL "AS/400 Name"
   typelen            FORMAT "x(11)" COLUMN-LABEL "Type/Length"   
   asflags            FORMAT "x(4)"  COLUMN-LABEL "Flags"
   fldstoff1  FORMAT ">>>>>9" COLUMN-LABEL "Offset"
   bField._Fld-stlen  FORMAT ">>>>>9" COLUMN-LABEL "Bytes"
   WITH FRAME as4sumfield NO-ATTR-SPACE DOWN NO-BOX USE-TEXT STREAM-IO.   

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
      (   (IF bField._Fld-case = "Y" THEN "c" ELSE "")
        + (IF CAN-FIND(FIRST as4dict.p__Idxfd 
                 where as4dict.p__Idxfd._File-number = bField._File-number 
                   and as4dict.p__Idxfd._Fld-number = bField._Fld-number)
          THEN "i" ELSE "")
        + (IF bField._Mandatory = "Y" THEN "m" ELSE "")
        + (IF CAN-FIND(FIRST as4dict.p__Vref
          WHERE as4dict.p__Vref._Ref-Table = bFile._File-name
          AND as4dict.p__Vref._Base-col = bField._Field-name)
          THEN "v" ELSE "")
      ) @ flags

      bField._Format 
      WITH FRAME shofield.
   DOWN STREAM rpt WITH FRAME shofield.
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
  else do:          
  /* Use _fld-stlen which was calculated at time of create */   
   ASSIGN   typelen = substring(bField._Fld-misc2[6],1,1) + "    " 
                                  + STRING(bField._Fld-stlen).   
 
  end.         
   ASSIGN fldstoff1 = (1 + bField._Fld-stoff).
   
   DISPLAY STREAM rpt
      pname
      bField._For-name
      typelen
      
  
      /* flags */
      (   (IF bField._For-Retrieve = "Y" THEN "n" ELSE "")
        + (IF bField._For-Maxsize > 0 THEN "v" ELSE "") 
        + (IF bField._Fld-Misc2[5] = "A" THEN "A" ELSE "")   
        + (IF bField._Fld-Misc1[7] <> 0 AND bField._Fld-Misc2[5] <> "A" THEN "C" ELSE "")
      ) @ asflags

     fldstoff1
      bField._Fld-stlen
      WITH FRAME as4sumfield.  
      
   DOWN STREAM rpt WITH FRAME as4sumfield.
END.


/*============================Mainline Code=============================*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH bFile NO-LOCK WHERE 
               	     (IF p_Tbl = "ALL" THEN bFile._Hidden = "N"
      	       	     	               ELSE bFile._File-name = p_Tbl)
      	       BY bFile._File-name:
   IF bFile._For-Info = "PROCEDURE" THEN NEXT.
   IF p_Tbl = "ALL" THEN
      DISPLAY bFile._File-name WITH FRAME working_on.

   DISPLAY STREAM rpt bFile._File-name  bFile._AS4-Library WITH FRAME tblhdr.        
   DISPLAY STREAM rpt  "PROGRESS Field Summary" @ spline WITH FRAME spacer.  
   
   if INDEX(p_Order, "a") > 0 THEN DO:
      FOR EACH bField where bField._File-number = bFile._File-number 
              NO-LOCK USE-INDEX p__Field:   
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.
	 RUN Display_Rec.        
      END.                               
                         
      DISPLAY STREAM rpt  "AS/400 Field Summary" @ spline WITH FRAME spacer.
      
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
   END.
   ELSE DO:
      FOR EACH bField  where bField._File-number =
           bFile._File-number NO-LOCK USE-INDEX p__Fieldl0: 
              IF bField._Fld-Misc2[5] = "A" THEN NEXT.           
	 RUN Display_Rec.        
      END.                                  
               
      DISPLAY STREAM rpt "AS/400 Field Summary" @ spline WITH FRAME spacer.
      
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
      DISPLAY STREAM rpt "AS/400 Flags =  (A)S/400 only field, (n)ull capable, (v)ariable allocated, "
          @ spline WITH FRAME spacer.   
  END.
END.                                    

IF p_Tbl = "ALL" THEN
DO:
   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.



