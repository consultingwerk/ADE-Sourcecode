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
   &Frame = the frame name, e.g., "frame newparm".


IMPORTANT: Do not change the b_Parm buffer.  All changes must be made to
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

Author: Donna McMann

Date Created: 05/04/99 

--------------------------------------------------------------------------*/


Define var type_idx  as integer  NO-UNDO.  /* index into datatypes list */
Define var junk      as logical  NO-UNDO. /* output parm we don't care about */
Define var fmt       as char     NO-UNDO.


s_Parm_DType = s_Parm_DType:screen-value in {&Frame}.
    
assign s_Parm_Gatetype = TRIM(SUBSTR(s_Parm_DType, 1, 21)) /* the long version */
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
  b_Parm._Fld-stdtype = INTEGER(ENTRY(type_idx, user_env[14]))
  b_Parm._Fld-stlen   = INTEGER(ENTRY(type_idx, user_env[13]))

  /* Set data types for save later and also so we can get the 
     format - the one piece of info we have not got in 
     user_env array. 
  */
  
  s_Parm_Gatetype = ENTRY(type_idx, user_env[12]). /* the short version */


/* Set the underlying progress type code whether we are dealing with
   Progress or other gateway. */
case s_Parm_Protype:
   when "Character" then s_Parm_Typecode = {&DTYPE_CHAR}.
   when "Logical"   then s_Parm_Typecode = {&DTYPE_LOG}.
   when "Integer"   then s_Parm_Typecode = {&DTYPE_INT}.
   when "Decimal"   then s_Parm_Typecode = {&DTYPE_DEC}.
end.

/* Set format default based on data type.  This will also set initial
   value if data type is logical. */
   
run as4dict/Parm/_dfltfmt.p 
   (INPUT b_Parm._Format:HANDLE in {&Frame},
    INPUT b_Parm._Initial:HANDLE in {&Frame},
    INPUT true). 

/* Set other defaults. Fld-Misc2[6] is the DDS Type for the 
   AS400.  Fld-stlen is the actual storage size. It is already
   set for Integer and Date, and just needs to be displayed.  
   For the remaining AS400 datatypes, this field needs to be derived 
   from the format, which happens on the LEAVE trigger of the 
   format field.  Initial  */     

{ as4dict/FLD/proxtype.i &prefix = "b_Parm" }

case s_Parm_Typecode:
   when {&DTYPE_CHAR} then
   do:                      
       assign 
         b_Parm._Initial:screen-value in {&Frame} = ""
         b_Parm._Fld-Misc2[6] = ddstype[dpos].     
      Run Set_stlen.            
      assign b_Parm._Decimals = 0.
         
   end.
   when {&DTYPE_LOG} then 
   do:
      assign 
       b_Parm._Initial:screen-value in {&Frame} = "no"                                               
       b_Parm._Fld-Misc2[6] = ddstype[dpos]      
       b_Parm._Decimals = 0.  
   end.
   when {&DTYPE_INT} then
   do: 
      assign
         b_Parm._Initial:screen-value in {&Frame} = "0"
         b_Parm._Fld-Misc2[6] = ddstype[dpos]         
         b_Parm._Decimals = 0.
  
   end.      	 
   when {&DTYPE_DEC} then
   do:     
      assign
         b_Parm._Initial:screen-value in {&Frame} = "0"
         b_Parm._Fld-Misc2[6] = ddstype[dpos].
         
      Run Set_stlen.
   end.   
   otherwise
      assign
	 b_Parm._Initial:screen-value in {&Frame} = ?.
end.

