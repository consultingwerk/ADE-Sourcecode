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
File: udfltfmt.p

*/
{as4dict/dictvar.i shared}
{adecomm/cbvar.i shared}
{as4dict/uivar.i shared}
{as4dict/parm/parmvar.i shared}
{as4dict/FLD/uptfld.i } 

Define INPUT PARAMETER p_Format  as widget-handle     NO-UNDO.
Define INPUT PARAMETER p_Initial as widget-handle     NO-UNDO.
Define INPUT PARAMETER p_Default as logical           NO-UNDO.

Define var io1 as integer  NO-UNDO.  
Define var io2 as integer  NO-UNDO.
Define var formt as char     NO-UNDO.
Define var type_idx  as integer  NO-UNDO.  /* index into datatypes list */
Define var junk      as logical  NO-UNDO. /* output parm we don't care about */
Define var fmt       as char     NO-UNDO.
define var frmt as character NO-UNDO.
define var lngth as integer. 
define var pos as integer.                          
define var dec_point as integer.
define var all_digits as integer.  
define var dec_nbr as decimal.
define var int_nbr as integer.    
define var add_even as integer initial 0.
define var oldsdtype like as4dict.p_Field._Fld-stdtype NO-UNDO.

ASSIGN formt = p_Format:screen-value
       s_Parm_DType = s_Parm_DType:screen-value in frame Parmprops.
    
assign
  s_Parm_Gatetype = TRIM(SUBSTR(s_Parm_DType, 1, 21)) /* the long version */
  type_idx = LOOKUP(s_Parm_Gatetype, user_env[11])
  s_Parm_Protype = TRIM(SUBSTR(s_Parm_DType, 23))
  /* Remove the trailing parenthesis */
  s_Parm_Protype = SUBSTR(s_Parm_Protype,1,LENGTH(s_Parm_Protype) - 1).

   /* Make sure we have the right user_env entry.  There may be more than
      one with this gate type description.  Find the one where the pro
      type matches as well.
   */
do while ENTRY(type_idx, user_env[15]) <> s_Parm_Protype:
  type_idx = type_idx + 1.
end.

assign
     /* Set foreign type code and length from cached gateway info. */
      Fldstdtype = INTEGER(ENTRY(type_idx, user_env[14]))
      Fldstlen   = INTEGER(ENTRY(type_idx, user_env[13]))

      /* Set data types for save later and also so we can get the 
   	 format - the one piece of info we have not got in 
   	 user_env array. 
      */
      s_Parm_Gatetype = ENTRY(type_idx, user_env[12]) /* the short version */
      fortype = s_Parm_Gatetype.      


/* Set the underlying progress type code whether we are dealing with
   Progress or other gateway. */
case s_Parm_Protype:
   when "Character" then s_Parm_Typecode = {&DTYPE_CHAR}.
   when "Date"	     then s_Parm_Typecode = {&DTYPE_DAT}.
   when "Logical"   then s_Parm_Typecode = {&DTYPE_LOG}.
   when "Integer"   then s_Parm_Typecode = {&DTYPE_INT}.
   when "Decimal"   then s_Parm_Typecode = {&DTYPE_DEC}.
   when "RECID"     then s_Parm_Typecode = {&DTYPE_REC}.
end.
/* Set other defaults. Parm-Misc2[6] is the DDS Type for the 
   AS400.  Parm-stlen is the actual storage size save off current setting
   assign new check proxtype then put back so user can cancel without
   problems */     
   
 assign oldsdtype = b_Parm._Fld-stdtype
        b_Parm._Fld-stdtype = Fldstdtype.
{ as4dict/FLD/proxtype.i &prefix = "b_Parm" }
assign b_Parm._Fld-stdtype = oldsdtype.

 IF user_env[35] = "DTF" THEN 
   ASSIGN frmt =  dftfmt[dpos]
          b_Parm._Format:screen-value in frame Parmprops = frmt.
 ELSE
   ASSIGN frmt = b_Parm._Format:screen-value in frame Parmprops.  

case s_Parm_Typecode:
   when {&DTYPE_CHAR} then
   do: 
       assign 
         b_Parm._Initial:screen-value in frame Parmprops = ""
         Forseparator = ""
         Fldmisc1[3] = 0
         Fldmisc1[5] = 0
         FldMisc2[6] = ddstype[dpos]         
         dtype = {&DTYPE_CHAR}.     
                  
         define var left_paren as integer.
         define var right_paren as integer.
         define var i as integer.
         define var nbrchar as integer.    
         
         lngth = LENGTH(frmt, "character").  
          
         if index(frmt, "(") > 1 THEN DO:
             left_paren = INDEX(frmt, "(").
             right_paren = INDEX(frmt, ")").
             lngth = right_paren - (left_paren + 1).
             assign Fldstlen =  INTEGER(SUBSTRING(frmt, left_paren + 1, lngth)).  
       
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
                    ASSIGN Fldstlen = nbrchar.
                ELSE
                    ASSIGN fldstlen = lngth.    
          END.                            
   end.
   when {&DTYPE_LOG} then 
   do:
      assign 
        Fldcase = ""
        Fldmisc1[3] = 0
        Fldmisc1[5] = 0 
        Forseparator = ""                                                    
        FldMisc2[6] = ddstype[dpos]
        Decimls = 0        
        dtype = {&DTYPE_LOG}.  
   end.
   when {&DTYPE_INT} then
   do: 
      assign
         Fldcase = ""
         Fldmisc1[3] = 0
         Forseparator = ""         
         FldMisc2[6] = ddstype[dpos]         
         Decimls = 0
         dtype = {&DTYPE_INT}. 
         FldMisc1[5] = (IF Fldstdtype = 35 THEN 4 ELSE 9).         	  
   end.      	 
   when {&DTYPE_DEC} then
   do:     
      assign
         b_Parm._Initial:screen-value in frame parmprops = "0"
         fldcase = ""
         Fldmisc1[3] = 0
         Forseparator = ""
         FldMisc2[6] = ddstype[dpos]         
         dtype = {&DTYPE_DEC}.          

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
         IF Fldstdtype = 33 OR Fldstdtype = 34 OR
              Fldstdtype = 42 THEN DO:          
              /* Assign decimal before changing to max if necessary */              
             ASSIGN Decimls =   (IF dec_point > 0 then 
                                ((all_digits + 1) - dec_point)
                                  else 0 ) .       
            IF Decimls > 31 THEN
                ASSIGN Decimls = 31.   
                                
            IF all_digits <= 31 THEN
                ASSIGN FldMisc1[5] = all_digits.                                                    
            ELSE
                ASSIGN FldMisc1[5] = 31.        
                          
         end.
         ELSE IF Fldstdtype = 37 THEN DO:               
              /* Assign decimals before changing to max if necessary */
             ASSIGN Decimls =   (IF dec_point > 0 then 
                                ( (all_digits + 1) - dec_point )
                                     else 0 ) .       
            IF Decimls > 9 THEN
                ASSIGN Decimls = 9.   
                                         
            IF all_digits <= 9 THEN
                ASSIGN FldMisc1[5] = all_digits.                                                    
            ELSE
                ASSIGN FldMisc1[5] = 9. 
         end.                   
        ELSE IF Fldstdtype = 38 THEN DO:     
              /* Assign decimals before changing to max if necessary */
             ASSIGN Decimls =   (IF dec_point > 0 then 
                                         ((all_digits + 1) - dec_point)
                                            else 0 ) .       
            IF Decimls > 17 THEN
                ASSIGN Decimls = 17.   
                                        
            IF all_digits <= 17 THEN
                ASSIGN FldMisc1[5] = all_digits.                                                    
            ELSE
                ASSIGN FldMisc1[5] = 17.                                
         end.                   

         /* Determine if all_digits is an even or odd number and data type packed 
             or packed even should be changed. */         
         IF Fldstdtype = 34 OR fldstdtype = 42 THEN DO:
            IF all_digits MODULO 2 = 0  THEN 
                ASSIGN  Fldstdtype = 42                      
                        Fortype = "Packede"  
                       add_even = 1.   
            ELSE 
                 ASSIGN  Fldstdtype = 34
                         Fortype = "Packed".  
         END.
           
         /* If not a zoned number then divide all digits by 2.  */ 
         IF Fldstdtype <> 33  THEN     
            assign all_digits = (all_digits / 2) + add_even.                                                                                       
         
         /* Verify that floats are not assigned a length. */  
         IF  Fldstdtype < 37 OR Fldstdtype > 38 THEN                           
 
   end.
   otherwise
      assign
	 b_Parm._Initial:screen-value in frame Parmprops = ?.
end.
 
      
IF s_Parm_Typecode = {&DTYPE_LOG} then 
   IF frmt = "yes/no" then
      p_Initial:screen-value = "no".
   ELSE IF frmt = "true/false" then
      p_Initial:screen-value = "false".
   ELSE
      p_Initial:screen-value = SUBSTR(formt, 1, INDEX(formt, "/") - 1).
        

 







