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

File: fdprop.i

Description:
   Set up the field/domain properties window so the user can view or modify
   the information on a field or domain.  Since this window is non-modal,
   we just do the set up here.  All triggers must be global.

   This is set up to work for both domains and fields so we don't have to
   maintain this code twice.

Argument:
   &Frame    = the frame name we are dealing with: either "frame fldprops"
      	       or "frame domprops".

   &ReadOnly = the read only flag to set.

Author: Laura Stern

Date Created: 02/05/92
    Modified: 01/95 To work with the PROGRESS/400 Data Dictionary
              05/15/98 D. McMann Added the ability for the user to change
                       any field provided the file has not been committed. 
              08/16/00 D. McMann Added Raw Data Type Support

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
/* Run time layout for button area. This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame fldprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Fld:width = s_win_Fld:width + 1
      frame fldprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "{&Frame}" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_Save" 
      &HELP  = "s_btn_Help"   
   }

   /* So Return doesn't hit default button in editor widget */
   b_Field._Desc:RETURN-INSERT in {&Frame} = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in {&Frame} = eff_frame_width - ({&HFM_WID} * 2).
end.

ispro = {as4dict/ispro.i}.

/* InView and InIndex and Order# aren't relevant for domains. Copy
   isn't relevant except for adding.
*/
assign
   item_hidden = (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_Fld_InIndex:hidden  in {&Frame} = item_hidden
   s_Fld_InView:hidden   in {&Frame} = item_hidden
   s_btn_Fld_Copy:hidden in {&Frame} = yes
   b_Field._Order:hidden in {&Frame} = item_hidden.

/* Get general field gateway capabilities */
run as4dict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* Read the current record data into the b_Field buffer. */
name = (if s_CurrObj = {&OBJ_FLD} then s_CurrFld else s_CurrDom).
record_id = (if s_CurrObj = {&OBJ_FLD} then s_TblRecId else s_DomRecId).    

find b_Field where b_Field._File-number = s_TblForNo
               and b_Field._Field-name = name.


/* Determine if this field participates in an index or view definition. */
if s_CurrObj = {&OBJ_FLD} then
do:
   s_Fld_InIndex = 
      can-find (FIRST as4dict.p__Idxfd where
                b_Field._File-number = as4dict.p__idxfd._File-number AND
                b_Field._Fld-number  = as4dict.p__idxfd._Fld-number).
   s_Fld_InView = can-find (FIRST as4dict.p__Vref where
      	       	     	    as4dict.p__Vref._Ref-Table = s_CurrTbl AND
      	       	     	    as4dict.p__Vref._Base-Col = b_Field._Field-name).
end.

if {&ReadOnly} = false then
   {&ReadOnly} = (s_DB_ReadOnly OR s_ReadOnly).

/* Initialize array flag.
   Set the original progress and gate types.  If user changes the data
   type, these will be updated.
*/
assign
   s_Fld_Array = (if b_Field._Extent > 0 then yes else no)      
   s_Fld_Var_Length = (if b_Field._For-Allocated  > 0 then yes else no)
   s_Fld_Protype = b_Field._Data-type
   s_Fld_Gatetype = b_Field._For-type
   change_type = (IF as4dict.p__File._Fil-Misc1[4] = 0 THEN YES ELSE NO)
   user_env[22] = (IF change_type THEN "change" ELSE "committed").
 
/* The _dtype is not set in the p__field files so set the indicator here */

IF s_fld_Protype = "character" then s_fld_Typecode = 1.
else  IF s_fld_Protype = "date" then s_fld_Typecode = 2.
else  IF s_fld_Protype = "logical" then s_fld_Typecode = 3.
else  IF s_fld_Protype = "integer" then s_fld_Typecode = 4.
else  IF s_fld_Protype = "decimal" then s_fld_Typecode = 5.
else  IF s_fld_Protype = "RAW" then s_fld_Typecode = 8.
else  IF s_fld_Protype = "RECID" then s_fld_Typecode = 7.

/* Make sensitivity/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run as4dict/FLD/_dtcust.p  (INPUT b_Field._Decimals:HANDLE in {&Frame}).

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

   type_ix = LOOKUP(s_Fld_Gatetype, user_env[12]).
   if ENTRY(type_ix, user_env[15]) <> s_Fld_Protype then
   do:
      dtype_search:
      do type_ix = type_ix + 1 to NUM-ENTRIES(user_env[14]) while
      	 INTEGER(ENTRY(type_ix, user_env[14])) = b_Field._Fld-stdtype:

      	 if ENTRY(type_ix, user_env[15]) = s_Fld_Protype then
      	    leave dtype_search.
      end.
   end.          

   /* Remember the current "gatetype (protype)" display value - used
      later to set selection.  
      Caution: Use user_env[15] value here instead of s_Fld_Protype just to 
      make sure we get the same case (upper/lower) as below so value set 
      in select-list works.
   */
   gate_type = ENTRY(type_ix, user_env[11]).  /* the long form */
   curr_type = STRING(gate_type, "x(21)") + "(" + 
      	       ENTRY(type_ix, user_env[15]) + ")".
end.

if change_type then do:
  Define var types as char    NO-UNDO.

   s_lst_Fld_DType:list-items in {&Frame} = "".  /* clear the list */
  
   {as4dict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "FALSE"}

   if IsPro then
      assign
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,RECID,RAW"
      	 num = 7.
   else do:
 
      types = "".
      do num = 1 to NUM-ENTRIES(user_env[11]) - 1:
      	 types = types + (if num = 1 then "" else ",") +
      	       	 STRING(ENTRY(num, user_env[11]), "x(21)") + 
      	       	 "(" + ENTRY(num, user_env[15]) + ")".
      end.
      num = num - 1.  /* undo terminating loop iteration */
   end.                
   
   s_lst_Fld_DType:list-items in frame fldprops = types.
   s_lst_Fld_DType:inner-lines in frame fldprops = 
      (if num <= 10 then num else 10).

      {adecomm/cbcdrop.i &Frame  = "{&Frame}"
		         &CBFill = "s_Fld_DType"
		         &CBList = "s_lst_Fld_DType"
		     	 &CBBtn  = "s_btn_Fld_DType"
		     	 &CBInit = "curr_type"}
   
end.

if NOT change_type then
do:
   /* Disable the data type fill-in and the combo box components since
      the data type is not modifiable.  Disable the var_length in case
      there are uncommitted files and it had been turned on for them */
   assign
      s_Fld_DType:sensitive in {&Frame} = false
      s_btn_Fld_DType:visible in {&Frame} = false 
      s_lst_Fld_DType:visible in {&Frame} = false
      s_Fld_Var_Length:sensitive in {&Frame} = false.

   if ispro then
      s_Fld_DType = s_Fld_Protype.
   else 
      s_Fld_DType = curr_type.
   s_Fld_DType:screen-value in {&Frame} = s_Fld_DType.

   /* Adjust the data type fill-in and list: font and width. */
   {as4dict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "TRUE"}
end.

/* Setup s_Fld_Null_Capable and s_Fld_Mandatory with the correct values from 
   their corresponding fields.  These were logicals in the schema, but there
   is no logical datatype on the AS/400, so they always have to be converted. */

   s_Fld_Null_Capable = 
         (if b_Field._Fld-misc2[2] = "Y" then yes else no).
   s_Fld_Mandatory = 
         (if b_Field._Mandatory = "Y" then yes else no).
   s_Fld_Case =
        (if b_Field._Fld-case = "Y"  and  b_Field._Fld-misc2[6] = "A" then yes else no).

/* Shared variables need to be assigned to current values so that if the user
   does not change fields the values will not be lost.
*/   
DO i = 1 to 8:
  ASSIGN fldmisc1[i] = b_Field._Fld-misc1[i]
         fldmisc2[i] = b_Field._Fld-misc2[i].
END.
 
assign dtype        = b_Field._Dtype
       forseparator = b_Field._For-separator
       fldstlen     = b_Field._Fld-stlen
       decimls      = b_Field._Decimals
       fldcase      = b_Field._Fld-case
       fldstdtype   = b_Field._Fld-stdtype
       fortype      = b_Field._For-type.
             
display  b_Field._Field-Name  
         b_Field._For-Name
         b_Field._Fld-Misc2[6]     /*  DDS Type  */
         b_Field._Format      b_Field._Label       
         b_Field._Col-label   s_Fld_Array
         b_Field._Initial     b_Field._Desc        
         b_Field._Help        s_Optional
         b_Field._Extent      
         b_Field._Fld-stlen
         b_Field._Order       when s_CurrObj = {&OBJ_FLD}
         s_Fld_Mandatory
         s_Fld_Case           
         s_Fld_Null_Capable          /* Null Capable Indicator */
         s_Fld_Var_length            /* Variable Length Indicator */   
         b_Field._For-allocated    
         s_Fld_InIndex             when s_CurrObj = {&Obj_FLD}
         s_Fld_InView  	      when s_CurrObj = {&Obj_FLD}
   with {&Frame}.      
 
 IF b_field._Fld-stoff <> 0 THEN
     assign fldstoff1 = b_field._Fld-stoff + 1.

 display  fldstoff1 @ b_Field._Fld-stoff with {&Frame}.
 
 IF b_field._Data-type <> "decimal" 
    then display "" @ b_field._Decimals with {&Frame}.
ELSE display b_Field._Decimals with {&Frame}.    

if {&ReadOnly} then
do:
   disable all except
	  s_btn_Fld_Triggers  
	  s_btn_Fld_Validation
	  s_btn_Fld_ViewAs
	  s_btn_Fld_StringAttrs
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with {&Frame}.

   enable s_btn_Fld_Triggers  
	  s_btn_Fld_Validation
	  s_btn_Fld_ViewAs
	  s_btn_Fld_StringAttrs
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with {&Frame}.                       

   apply "entry" to s_btn_Fld_Triggers in {&Frame}.
end.
else do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   IF as4dict.p__File._Fil-Misc1[4] = 0 AND NOT s_Fld_InIndex THEN
      ASSIGN change_ext = YES.
   ELSE
      ASSIGN change_ext = NO.  
   

   /* Desensitize explicitly in case they were enabled from a previous 
      iteration. */
   if NOT change_ext then
      assign
      	 s_Fld_Array:sensitive in {&Frame} = no
      	 b_Field._Extent:sensitive in {&Frame} = no.
 
   /* ENABLE effects the TAB order */
   enable b_Field._Field-Name                 
          b_Field._For-Name
      	  b_Field._Format
      	  s_btn_Fld_Format
      	  b_Field._Label
      	  b_Field._Col-label
      	  b_Field._Initial 
      	  b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
      	  s_Fld_Mandatory 
         s_Fld_Null_Capable    /* Null Capable Indicator */
      	  b_Field._Desc
      	  b_Field._Help   	                 	  
     	  s_Fld_Array        when change_ext      
      	  s_btn_Fld_Triggers
      	  s_btn_Fld_Validation
      	  s_btn_Fld_ViewAs
      	  s_btn_Fld_StringAttrs
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
     Enable s_Fld_DType	   
            s_btn_Fld_DType   
            with {&Frame}.
            
     if  b_Field._Fld-Misc2[6] = "A" THEN
       ASSIGN s_Fld_Case:sensitive in {&Frame} = TRUE 
              s_Fld_Var_Length:sensitive in {&Frame} = TRUE
              b_Field._For-allocated:sensitive in {&Frame} = FALSE
              s_Res = s_Fld_Case:move-after-tab-item 
		  (b_Field._Help:handle in {&Frame}) in {&Frame}
              s_Res = s_Fld_Var_Length:move-after-tab-item 
		  (s_Fld_Case:handle in {&Frame}) in {&Frame}.
     ELSE
       ASSIGN s_Fld_Case:sensitive in {&Frame} = FALSE
              s_Fld_Var_Length:sensitive in {&Frame} = FALSE
              b_Field._For-allocated:sensitive in {&Frame} = FALSE  

      s_Res = s_lst_Fld_DType:move-after-tab-item
             (s_btn_Fld_DType:handle in {&Frame}) in {&Frame}.
   END.		  
   assign
      b_Field._For-allocated:sensitive in {&Frame} = FALSE 
      s_Res = b_Field._Decimals:move-before-tab-item
		  (b_Field._Desc:handle in {&Frame}) in {&Frame}
		  
      /* do this one to be sure we have a stable anchor for fld-case */
 
      s_Res = s_Fld_DType:move-after-tab-item 
		  (b_Field._For-name:handle in {&Frame}) in {&Frame}.

      apply "entry" to b_Field._Field-Name in {&Frame}.
end.
 


