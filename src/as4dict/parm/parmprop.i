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

File: parmprop.i

Description:
   Set up the parameters properties window so the user can view or modify
   the information. 
   
Argument:
   &Frame    = the frame name we are dealing with: either "frame fldprops"
      	       or "frame domprops".

   &ReadOnly = the read only flag to set.

Author: Donna McMann
Date Created: 05/11/99
     History: 09/08/99 Added decimal and length display
    
----------------------------------------------------------------------------*/


{as4dict/capab.i}


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


/*----------------------------Mainline code----------------------------------*/

Define var item_hidden  as logical NO-UNDO.
Define var name      	as char    NO-UNDO.
Define var record_id 	as recid   NO-UNDO.
Define var ispro     	as logical NO-UNDO. /* Is it a progress db? */
Define var junk         as logical NO-UNDO. /* for irrelevant output parm */
Define var gate_type    as char    NO-UNDO. /* gateway data type string */
Define var pro_type    	as char    NO-UNDO. /* Progress data type string */
Define var curr_type    as char    NO-UNDO. /* current "gate (pro)" value */
Define var family       as char    NO-UNDO. /* Data type family */ 
Define var type_ix      as integer NO-UNDO. /* Index of data type in list */
Define var num 	     	as integer NO-UNDO. /* Used for a loop index */
Define var len 	     	as integer NO-UNDO. /* Length of data type string */
Define var change_type  as logical NO-UNDO. /* Can user change data type? */
Define var change_ext   as logical NO-UNDO. /* Can user change extent? */
Define var i            as integer NO-UNDO.
Define var as4type      as character NO-UNDO.
Define var protype      as character NO-UNDO.


/* Run time layout for button area. This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if {&Frame}:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Parm:width = s_win_Parm:width + 1
      {&Frame}:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "{&Frame}" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_Save" 
      &HELP  = "s_btn_Help"   
   }

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in {&Frame} = eff_frame_width - ({&HFM_WID} * 2).
end.

ispro = {as4dict/ispro.i}.

assign      
   s_btn_Parm_Copy:hidden in {&Frame} = yes
   b_Parm._Order:hidden in {&Frame} = no.

/* Read the current record data into the b_Parm buffer. */
name = s_CurrParm.
record_id = s_ProcRecId.    

find b_Parm where b_Parm._File-number = s_ProcForNo
               and b_Parm._Field-name = name.

if {&ReadOnly} = false then
   {&ReadOnly} = (s_DB_ReadOnly OR s_ReadOnly).

/* Initialize array flag.
   Set the original progress and gate types.  If user changes the data
   type, these will be updated.
*/
assign   
   s_Parm_Protype = b_Parm._Data-type
   s_Parm_Gatetype = b_Parm._For-type
   change_type = NO
   user_env[22] = (IF change_type THEN "change" ELSE "committed").

IF b_Parm._Fld-misc1[2] = 1 THEN
  ASSIGN s_Parm_type = "INPUT".
ELSE IF b_Parm._Fld-misc1[2] = 2 THEN
  ASSIGN s_Parm_type = "Input-output".
ELSE
  ASSIGN s_Parm_type = "Output".  
  
/* The _dtype is not set in the p__field files so set the indicator here */

IF s_Parm_Protype = "character" then s_Parm_Typecode = 1.
else  IF s_Parm_Protype = "date" then s_Parm_Typecode = 2.
else  IF s_Parm_Protype = "logical" then s_Parm_Typecode = 3.
else  IF s_Parm_Protype = "integer" then s_Parm_Typecode = 4.
else  IF s_Parm_Protype = "decimal" then s_Parm_Typecode = 5.
else  IF s_Parm_Protype = "RAW" then s_Parm_Typecode = 8.
else  IF s_Parm_Protype = "RECID" then s_Parm_Typecode = 7.

/* The CHANGE_DATA_TYPE capability indicates if any types are changeable
   from any other.  Even then, certain types cannot be changed.  We can only
   change between types of the same data type family.  If the family is
   0, then the type is an orphan and cannot be modified.

   First determine the user_env entry that matches the current type and
   compose the select list value "gatetype (protype)" - if non-progress.
*/
if NOT ispro then
do:
   /* Find the entry in the table which matches the current gatetype type */

   type_ix = LOOKUP(s_Parm_Gatetype, user_env[12]).
   if ENTRY(type_ix, user_env[15]) <> s_Parm_Protype then
   do:
      dtype_search:
      do type_ix = type_ix + 1 to NUM-ENTRIES(user_env[14]) while
      	 INTEGER(ENTRY(type_ix, user_env[14])) = b_Parm._Fld-stdtype:

      	 if ENTRY(type_ix, user_env[15]) = s_Parm_Protype then
      	    leave dtype_search.
      end.
   end.          

   /* Remember the current "gatetype (protype)" display value - used
      later to set selection.  
      Caution: Use user_env[15] value here instead of s_Parm_Protype just to 
      make sure we get the same case (upper/lower) as below so value set 
      in select-list works.
   */
   gate_type = ENTRY(type_ix, user_env[11]).  /* the long form */
   curr_type = STRING(gate_type, "x(21)") + "(" + 
      	       ENTRY(type_ix, user_env[15]) + ")".
end.

if change_type then do:
  Define var types as char    NO-UNDO.

   s_lst_Parm_DType:list-items in {&Frame} = "".  /* clear the list */
  
   {as4dict/parm/dtwidth.i &Frame = "{&Frame}" &Only1 = "FALSE"}

   if IsPro then
      assign
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,RECID"
      	 num = 6.
   else do:
     ASSIGN types = ""
         as4type = "Character Alpha      ,Zoned numeric        ,Packed decimal      ,Pckd (even digits)   ,Short Integer        ,Long Integer         ,Logical              "
         protype = "Character,Decimal,Decimal,Decimal,Integer,Integer,Logical".
     do num = 1 to NUM-ENTRIES(as4type):
       types = types + (if num = 1 then "" else ",") +
              STRING(ENTRY(num, as4type), "x(21)") + 
      	       "(" + ENTRY(num, protype) + ")".
     end.
     num = 7.  /* undo terminating loop iteration */
   end.                
             
   
   s_lst_Parm_DType:list-items in frame parmprops = types.
   s_lst_Parm_DType:inner-lines in frame parmprops = 
      (if num <= 10 then num else 10).

      {adecomm/cbcdrop.i &Frame  = "{&Frame}"
		         &CBFill = "s_Parm_DType"
		         &CBList = "s_lst_Parm_DType"
		     	 &CBBtn  = "s_btn_Parm_DType"
		     	 &CBInit = "curr_type"}
   
end.

if NOT change_type then
do:
   /* Disable the data type fill-in and the combo box components since
      the data type is not modifiable.  Disable the var_length in case
      there are uncommitted files and it had been turned on for them */
   assign
      s_Parm_DType:sensitive in {&Frame} = false
      s_btn_Parm_DType:visible in {&Frame} = false 
      s_lst_Parm_DType:visible in {&Frame} = false.

   if ispro then
      s_Parm_DType = s_Parm_Protype.
   else 
      s_Parm_DType = curr_type.
   s_Parm_DType:screen-value in {&Frame} = s_Parm_DType.

   /* Adjust the data type fill-in and list: font and width. */
   {as4dict/parm/dtwidth.i &Frame = "{&Frame}" &Only1 = "TRUE"}
end.

/* Shared variables need to be assigned to current values so that if the user
   does not change fields the values will not be lost.
*/   
DO i = 1 to 8:
  ASSIGN fldmisc1[i] = b_Parm._Fld-misc1[i]
         fldmisc2[i] = b_Parm._Fld-misc2[i].
END.
 
assign dtype        = b_Parm._Dtype
       forseparator = b_Parm._For-separator
       fldstlen     = b_Parm._Fld-stlen
       decimls      = b_Parm._Decimals
       fldcase      = b_Parm._Fld-case
       fldstdtype   = b_Parm._Fld-stdtype
       fortype      = b_Parm._For-type.
             
display  b_Parm._Field-Name 
         s_Optional 
         b_Parm._Format 
         s_Parm_type          
         b_Parm._Decimals 
         b_Parm._Initial 
         b_Parm._Desc                 
         b_Parm._Order                
   with {&Frame}.      
 
 IF b_Parm._Fld-Misc1[5] <> 0 THEN
     DISPLAY  b_Parm._Fld-Misc1[5] with {&Frame}. 
 ELSE DO:
     DISPLAY  b_Parm._Fld-Misc1[5] with {&Frame}. 
     ASSIGN b_Parm._Fld-MISC1[5]:SCREEN-VALUE = STRING( b_Parm._Fld-stlen).
 END.

 assign fldstoff1 = b_Parm._Fld-stoff + 1.     
  
if {&ReadOnly} then
do:
   disable all except	  
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with {&Frame}.

   enable s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with {&Frame}.                       

   apply "entry" to s_btn_Close in {&Frame}.
end.
else do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
 
   /* ENABLE effects the TAB order */
   enable b_Parm._Field-Name                 
          
      	  b_Parm._Format
      	  s_btn_Parm_Format 
      	  s_Parm_type     	  
      	  b_Parm._Initial 
      	  b_Parm._Order            	  
      	  b_Parm._Desc      	  
      	  s_btn_OK
      	  s_btn_Save
      	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
      	  with {&Frame}.

   /* Now readjust tab orders for stuff not in the ENABLE list but
      which may in fact be sensitive.
   */
   if change_type then do:
     Enable s_Parm_DType	   
            s_btn_Parm_DType   
            with {&Frame}.
 
      s_Res = s_lst_Parm_DType:move-after-tab-item
             (s_btn_Parm_DType:handle in {&Frame}) in {&Frame}.
   END.		     
		  
      /* do this one to be sure we have a stable anchor for fld-case */
 
      s_Res = s_Parm_DType:move-after-tab-item 
		  (b_Parm._Field-name:handle in {&Frame}) in {&Frame}.
      apply "entry" to b_Parm._Field-name in {&Frame}.
end.
 




