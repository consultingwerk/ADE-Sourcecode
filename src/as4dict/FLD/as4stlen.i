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

File: as4stlen.i

Description:
   Include to calculate the storage length (_Fld-stlen) for characters and
   decimals.  Also assigns the actual number of characters to _fld-Misc1[6].
   
Author: Donna McMann          

Arguments:  &input phrase  - from _newfld naming input frame name
                   &prefix - buffer b_field or as4dict.p__field.

Date Created: 02/95
    Modified: 06/27/95 N. Horn to make into an include so fld/_newfld.p and  
                             load/_lod_fld.p can use the same logic.
              10/12/95 D. McMann corrected algorithm for calculating character
                       length.  
              03/19/96 D.McMann corrected algorithm for calculating character
                       length AGAIN and added date separator and _fld-misc1[3]
                       assignment.  
              03/28/96 D. McMann character algorithm changed.  
              08/16/00 D. McMann Added Raw Data Type Support  
              03/09/01 D. McMann Added 16 bits to length of RAW field            
----------------------------------------------------------------------------*/



   /* Get the format to figure out the length */

   assign frmt = {&input_phrase} {&prefix}._format.

   case s_Fld_Typecode: 
      when {&DTYPE_CHARACTER}  then do:      
          IF {&prefix}._Fld-stdtype > 78 THEN LEAVE.    
           
          define var left_paren as integer.
          define var right_paren as integer.
          define var i as integer.
          define var nbrchar as integer.    
          
          lngth = LENGTH(frmt, "character").  
           
          if index(frmt, "(") > 1 THEN DO:
             left_paren = INDEX(frmt, "(").
             right_paren = INDEX(frmt, ")").
             lngth = right_paren - (left_paren + 1).
             assign {&prefix}._Fld-stlen =  INTEGER(SUBSTRING(frmt, left_paren + 1, lngth)).  
          END.  
          ELSE DO:           
               DO i = 1 to lngth:        
                   IF SUBSTRING(frmt,i,1) = "9" OR
                        SUBSTRING(frmt,i,1) = "N" OR   
                        SUBSTRING(frmt,i,1) = "A" OR    
                        SUBSTRING(frmt,i,1) = "x" OR
                        SUBSTRING(frmt,i,1) = "!"   THEN
                   ASSIGN nbrchar = nbrchar + 1.
                END.         
                IF nbrchar > 0 THEN
                    ASSIGN {&prefix}._Fld-stlen = nbrchar.
                ELSE
                    ASSIGN {&prefix}._fld-stlen = lngth.    
          END.                            
      END. /* When Dtype character */           
      WHEN {&DTYPE_RAW} THEN DO:

         lngth = LENGTH(frmt, "character").  
           
          if index(frmt, "(") > 1 THEN DO:
             left_paren = INDEX(frmt, "(").
             right_paren = INDEX(frmt, ")").
             lngth = right_paren - (left_paren + 1).
             assign {&prefix}._Fld-stlen =  INTEGER(SUBSTRING(frmt, left_paren + 1, lngth)) + 16.  
          END.  
          ELSE DO:           
               DO i = 1 to lngth:        
                   IF SUBSTRING(frmt,i,1) = "9" OR
                        SUBSTRING(frmt,i,1) = "N" OR   
                        SUBSTRING(frmt,i,1) = "A" OR    
                        SUBSTRING(frmt,i,1) = "x" OR
                        SUBSTRING(frmt,i,1) = "!"   THEN
                   ASSIGN nbrchar = nbrchar + 1.
                END.         
                IF nbrchar > 0 THEN
                    ASSIGN {&prefix}._Fld-stlen = nbrchar + 16.
                ELSE
                    ASSIGN {&prefix}._fld-stlen = lngth + 16.   

          END.                            
      END.
      when {&DTYPE_DECIMAL} then
      do:     
         define var pos as integer.                          
         define var dec_point as integer.
         define var all_digits as integer.  
         define var dec_nbr as decimal.
         define var int_nbr as integer.    
         define var add_even as integer initial 0.
        
         lngth = LENGTH(frmt, "character").
         all_digits = 0. 
         dec_point = 0.

        /* First, count all the digits in the format. */
         Do pos = 1 to lngth:
            if (SUBSTRING(frmt, pos, 1) = ">") OR 
                (SUBSTRING(frmt, pos, 1) = "<") OR  
                (SUBSTRING(frmt, pos, 1) = "*") OR  
                (SUBSTRING(frmt, pos, 1) = "z") OR 
                (SUBSTRING(frmt, pos, 1) = "Z") OR
               (SUBSTRING(frmt, pos, 1) = "9")
                  then all_digits = all_digits + 1.   
             else if (SUBSTRING(frmt,pos,1)) = "." 
                   then dec_point = all_digits + 1.            
         End.             
  
         /* AS/400 restriction on zoned(33) and packed(34 & 42) is maximum 31 digits 
             sfloat(37) is 9 and lfloat(38) is 17 */           
         IF {&prefix}._Fld-stdtype = 33 OR {&prefix}._Fld-stdtype = 34 OR
              {&prefix}._Fld-stdtype = 42 THEN DO:          
              /* Assign decimal before changing to max if necessary */              
             ASSIGN {&prefix}._Decimal =   (IF dec_point > 0 then 
                                                ((all_digits + 1) - dec_point)
                                                                      else 0 ) .       
            IF {&prefix}._Decimal > 31 THEN
                ASSIGN {&prefix}._Decimal = 31.   
                                
            IF all_digits <= 31 THEN
                ASSIGN {&prefix}._Fld-Misc1[5] = all_digits.                                                    
            ELSE
                ASSIGN {&prefix}._Fld-Misc1[5] = 31.        
                          
         end.
         ELSE IF {&prefix}._Fld-stdtype = 37 THEN DO:               
              /* Assign decimals before changing to max if necessary */
             ASSIGN {&prefix}._Decimal =   (IF dec_point > 0 then 
                                                                       ( (all_digits + 1) - dec_point )
                                                                       else 0 ) .       
            IF {&prefix}._Decimal > 9 THEN
                ASSIGN {&prefix}._Decimal = 9.   
                                         
            IF all_digits <= 9 THEN
                ASSIGN {&prefix}._Fld-Misc1[5] = all_digits.                                                    
            ELSE
                ASSIGN {&prefix}._Fld-Misc1[5] = 9. 
         end.                   
        ELSE IF {&prefix}._Fld-stdtype = 38 THEN DO:     
              /* Assign decimals before changing to max if necessary */
             ASSIGN {&prefix}._Decimal =   (IF dec_point > 0 then 
                                                                        ((all_digits + 1) - dec_point)
                                                                       else 0 ) .       
            IF {&prefix}._Decimal > 17 THEN
                ASSIGN {&prefix}._Decimal = 17.   
                                        
            IF all_digits <= 17 THEN
                ASSIGN {&prefix}._Fld-Misc1[5] = all_digits.                                                    
            ELSE
                ASSIGN {&prefix}._Fld-Misc1[5] = 17.                                
         end.                   

         /* Determine if all_digits is an even or odd number and data type packed 
             or packed even should be changed. */         
         IF {&prefix}._Fld-stdtype = 34 OR {&prefix}._fld-stdtype = 42 THEN DO:
            IF all_digits MODULO 2 = 0  THEN 
                ASSIGN  {&prefix}._Fld-stdtype = 42                      
                                   {&prefix}._For-type = "Packede"  
                                   add_even = 1.   
            ELSE 
                 ASSIGN  {&prefix}._Fld-stdtype = 34
                                   {&prefix}._For-type = "Packed".  
         END.
           
         /* If not a zoned number then divide all digits by 2.  */ 
         IF {&prefix}._Fld-stdtype <> 33  THEN     
            assign all_digits = (all_digits / 2) + add_even.                                                                                       
         
         /* Verify that floats are not assigned a length. */  
         IF  {&prefix}._Fld-stdtype < 37 OR {&prefix}._Fld-stdtype > 38 THEN                           
               ASSIGN  {&prefix}._Fld-stlen = all_digits.
             

                                                                         
      end.  /* When Dtype decimal */         
      
      when {&DTYPE_INTEGER} then
      do:     

         lngth = LENGTH(frmt, "character").
         all_digits = 0.

        /* Count all the digits in the format. */
         Do pos = 1 to lngth:
            if (SUBSTRING(frmt, pos, 1) = ">") OR 
               (SUBSTRING(frmt, pos, 1) = "9") OR
               (SUBSTRING(frmt, pos, 1) = "z")  OR 
               (SUBSTRING(frmt, pos, 1) = "Z") OR  
               (SUBSTRING(frmt, pos, 1) = "*") OR
               (SUBSTRING(frmt, pos, 1) = "<")
                  then all_digits = all_digits + 1.         
         End.   
         IF {&prefix}._Fld-stdtype = 35 THEN 
	ASSIGN {&prefix}._Fld-Misc1[5] = 4.  
 
         ELSE IF {&prefix}._Fld-stdtype = 36 THEN 
                ASSIGN {&prefix}._Fld-Misc1[5] = 9.  

                            
      end. /* When dtype is integer */ 
      when {&DTYPE_DATE} then
      do:           
        DEFINE VARIABLE seppos  AS INTEGER  INITIAL 0 NO-UNDO.
        
        IF INDEX(frmt,".") > 0 THEN ASSIGN seppos = INDEX(frmt,".").
        ELSE IF INDEX(frmt,"/") > 0 THEN ASSIGN seppos = INDEX(frmt,"/").
        ELSE IF INDEX(frmt,"-") > 0 THEN ASSIGN seppos = INDEX(frmt,"-").     
                
        IF seppos = 0 THEN
          ASSIGN {&prefix}._fld-misc1[3] = ASC("/")
                 {&prefix}._For-Separator = "/".
        ELSE 
          ASSIGN {&prefix}._fld-misc1[3] = ASC(SUBSTRING(frmt,seppos,1))
                 {&prefix}._For-Separator = SUBSTRING(frmt,seppos,1). 
      end.  /* When dtype is date */                   
    end.  /* case Dtype  */     
