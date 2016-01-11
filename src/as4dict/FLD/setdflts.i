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

File: setdflts.i

Description:
   Set default values based on the chosen data type.

Arguments:
   &Frame = the frame name, e.g., "frame newtbl".


IMPORTANT: Do not change the b_Field buffer.  All changes must be made to
   widgets directly or to temporary variables.  Otherwise our SAVE strategy
   is messed up.

/* Reminder: Here's what's in user_env:

      user_env[11] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[14] - list of gateway type codes (_Fld-stdtype).
      user_env[15] - list of progress types that map to gateway types
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
      user_env[17] - the default-format per foreign data-type.
*/

Author: Laura Stern

Date Created: 09/24/92 
     History: 08/16/00 D. McMann Added Raw Data Type Support

--------------------------------------------------------------------------*/


Define var type_idx  as integer  NO-UNDO.  /* index into datatypes list */
Define var junk      as logical  NO-UNDO. /* output parm we don't care about */
Define var fmt       as char     NO-UNDO.

s_Fld_DType = s_Fld_DType:screen-value in {&Frame}.

if {as4dict/ispro.i} then
   assign
      s_Fld_Protype = s_Fld_DType
      s_Fld_Gatetype = ?.
else  do: 
   /* Set gateway defaults including, the progress data type that
      the gateway type maps to.  See description of user_env at 
      top of file.
   */
    
   assign
      /* Use s_Fld_Gatetype temporarily to find the correct
      	 user_env entry.  It will be reset below.  We can't just
      	 do a lookup of s_Fld_DType in the data type select list
      	 to get the index because for properties the select list
      	 may not have the full complement of types.
      */

      s_Fld_Gatetype = TRIM(SUBSTR(s_Fld_DType, 1, 21)) /* the long version */
      type_idx = LOOKUP(s_Fld_Gatetype, user_env[11])
      s_Fld_Protype = TRIM(SUBSTR(s_Fld_DType, 23))
      /* Remove the trailing parenthesis */
      s_Fld_Protype = SUBSTR(s_Fld_Protype,1,LENGTH(s_Fld_Protype) - 1).

   /* Make sure we have the right user_env entry.  There may be more than
      one with this gate type description.  Find the one where the pro
      type matches as well.
   */
   do while ENTRY(type_idx, user_env[15]) <> s_Fld_Protype:
      type_idx = type_idx + 1.
   end.

   assign
      /* Set foreign type code and length from cached gateway info. */
      b_Field._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14]))
      b_Field._Fld-stlen   = INTEGER(ENTRY(type_idx, user_env[13]))

      /* Set data types for save later and also so we can get the 
   	 format - the one piece of info we have not got in 
   	 user_env array. 
      */
      s_Fld_Gatetype = ENTRY(type_idx, user_env[12]). /* the short version */
end.

/* Set the underlying progress type code whether we are dealing with
   Progress or other gateway. */
case s_Fld_Protype:
   when "Character" then s_Fld_Typecode = {&DTYPE_CHARACTER}.
   when "Date"	    then s_Fld_Typecode = {&DTYPE_DATE}.
   when "Logical"   then s_Fld_Typecode = {&DTYPE_LOGICAL}.
   when "Integer"   then s_Fld_Typecode = {&DTYPE_INTEGER}.
   when "Decimal"   then s_Fld_Typecode = {&DTYPE_DECIMAL}.
   when "RECID"	    then s_Fld_Typecode = {&DTYPE_RECID}.
   WHEN "RAW"       THEN s_Fld_Typecode = {&DTYPE_RAW}.
end.

/* Set format default based on data type.  This will also set initial
   value if data type is logical. */
run as4dict/FLD/_dfltfmt.p 
   (INPUT b_Field._Format:HANDLE in {&Frame},
    INPUT b_Field._Initial:HANDLE in {&Frame},
    INPUT true). 

/* Make visibility/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run as4dict/FLD/_dtcust.p (INPUT b_Field._Decimals:HANDLE in {&Frame}).

/* Set other defaults. Fld-Misc2[6] is the DDS Type for the 
   AS400.  Fld-stlen is the actual storage size. It is already
   set for Raw, Integer and Date, and just needs to be displayed.  
   For the remaining AS400 datatypes, this field needs to be derived 
   from the format, which happens on the LEAVE trigger of the 
   format field.  Initial  */     

{ as4dict/FLD/proxtype.i &prefix = "b_Field" }

case s_Fld_Typecode:
   when {&DTYPE_CHARACTER} OR WHEN {&DTYPE_RAW} then
   do:                      
       assign 
         b_Field._Initial:screen-value in {&Frame} = ""
         b_Field._Fld-Misc2[6] = ddstype[dpos]
         b_Field._Fld-Misc2[6]:screen-value in {&Frame} = ddstype[dpos].     
      Run Set_stlen.            
      assign
         b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen)    
         b_Field._Decimals = 0
         b_Field._Decimals:screen-value in {&Frame} = "0".
   end.
   when {&DTYPE_LOGICAL} then 
   do:
      assign                                                
       b_Field._Fld-Misc2[6] = ddstype[dpos]
       b_Field._Fld-Misc2[6]:screen-value in {&Frame} = ddstype[dpos]
       b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen)
       b_Field._Decimals = 0
       b_Field._Decimals:screen-value in {&Frame} = "0".  
   end.
   when {&DTYPE_INTEGER} then
   do: 
      assign
         b_Field._Initial:screen-value in {&Frame} = "0"
         b_Field._Fld-Misc2[6] = ddstype[dpos]
         b_Field._Fld-Misc2[6]:screen-value in {&Frame} = ddstype[dpos]
         b_Field._Fld-stlen:screen-value = string(b_Field._Fld-stlen)
         b_Field._Decimals = 0
         b_Field._Decimals:screen-value in {&Frame} = "0".
      if s_Fld_Gatetype = "Bits" then
      	 b_Field._Decimals:screen-value in {&Frame} = "0".  
   end.      	 
   when {&DTYPE_DECIMAL} then
   do:     
      assign
         b_Field._Initial:screen-value in {&Frame} = "0"
         b_Field._Fld-Misc2[6] = ddstype[dpos]
         b_Field._Fld-Misc2[6]:screen-value in {&Frame} = ddstype[dpos].
      Run Set_stlen.
      assign
         b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen)
         b_Field._Decimals:screen-value = string(b_field._Decimals).
   end.
   when {&DTYPE_DATE} then  
   do:
      assign                         
         b_Field._Fld-Misc2[6] = ddstype[dpos]
         b_Field._Fld-Misc2[6]:screen-value in {&Frame} = ddstype[dpos]
         b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen)
         b_Field._Decimals = 0
         b_Field._Decimals:screen-value in {&Frame} = "0". 
   end.
   otherwise
      assign
	 b_Field._Initial:screen-value in {&Frame} = ?.
end.
