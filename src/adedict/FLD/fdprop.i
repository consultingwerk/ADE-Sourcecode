/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
    Modified: 04/01/98 D. McMann Added display of _field-rpos
              01/31/03 D. McMann Added support for Blobs
              08/26/03 D. McMann Display of updated LOB fields 20030826-013

----------------------------------------------------------------------------*/


{adedict/capab.i}

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

ispro = {adedict/ispro.i}.

/* InView and InIndex and Order# aren't relevant for domains. Copy
   isn't relevant except for adding.
*/
assign
   item_hidden = (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_Fld_InIndex:hidden  in {&Frame} = item_hidden
   s_Fld_InView:hidden   in {&Frame} = item_hidden
   s_btn_Fld_Copy:hidden in {&Frame} = yes
   b_Field._Order:hidden in {&Frame} = item_hidden
   s_btn_Fld_Gateway:sensitive in {&Frame} = NOT ispro.

ASSIGN s_lob_size:HIDDEN IN {&FRAME} = YES
       s_lob_Area:HIDDEN IN {&FRAME} = YES
       s_btn_lob_Area:HIDDEN IN {&FRAME} = YES
       s_clob_cp:HIDDEN IN {&FRAME} = YES
       s_clob_col:HIDDEN IN {&FRAME} = YES
       s_btn_clob_cp:HIDDEN IN {&FRAME} = YES
       s_btn_clob_col:HIDDEN IN {&FRAME} = YES
       s_lst_lob_Area:HIDDEN IN {&FRAME} = YES
       s_lst_clob_cp :HIDDEN IN {&FRAME} = YES
       s_lst_clob_col:HIDDEN IN {&FRAME} = YES.

/* Get general field gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* Read the current record data into the b_Field buffer. */
name = (if s_CurrObj = {&OBJ_FLD} then s_CurrFld else s_CurrDom).
record_id = (if s_CurrObj = {&OBJ_FLD} then s_TblRecId else s_DomRecId).
                                                             
find b_Field where b_Field._File-recid = record_id AND
       	       	   b_Field._Field-Name = name.

/* Determine if this field participates in an index or view definition. */
if s_CurrObj = {&OBJ_FLD} then
do:
   s_Fld_InIndex = can-find (FIRST _Index-field OF b_Field).
   s_Fld_InView = can-find (FIRST _View-ref where
      	       	     	    _View-ref._Ref-Table = s_CurrTbl AND
      	       	     	    _View-ref._Base-Col = b_Field._Field-name).
end.

if {&ReadOnly} = false then
   {&ReadOnly} = (s_DB_ReadOnly OR s_ReadOnly).

/* Initialize array flag.
   Set the original progress and gate types.  If user changes the data
   type, these will be updated.
*/
assign
   s_Fld_Array = (if b_Field._Extent > 0 then yes else no)
   s_Fld_Protype = b_Field._Data-type
   s_Fld_Gatetype = b_Field._For-type
   s_Fld_Typecode = b_Field._dtype 
   change_type = no.


/* Make sensitivity/label adjustments to fld-case and _Decimals based
   on data type chosen. */
run adedict/FLD/_dtcust.p (INPUT b_Field._Fld-case:HANDLE in {&Frame},
      	       	     	   INPUT b_Field._Decimals:HANDLE in {&Frame}).

/* for clob/blob fields, we hide the format and decimals and show some other specific
   fields.  For clob fields only, we hide label and col-label to show codepage and collation
   information
*/
IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR b_field._dtype = {&DTYPE_CLOB}) THEN DO:
   ASSIGN s_lob_size:HIDDEN IN {&FRAME} = NO
          s_lob_Area:HIDDEN IN {&FRAME} = NO
          b_Field._Decimals:HIDDEN IN {&FRAME} = YES
          b_Field._Format:HIDDEN IN {&FRAME} = YES
          s_btn_Fld_Format:HIDDEN IN {&FRAME} = YES.

  IF b_field._dtype = {&DTYPE_CLOB} THEN
     ASSIGN s_clob_cp:HIDDEN IN {&FRAME} = NO
            s_clob_col:HIDDEN IN {&FRAME} = NO
            b_Field._Label:HIDDEN IN {&FRAME} = YES
            b_Field._Col-label:HIDDEN IN {&FRAME} = YES.
  ELSE
     ASSIGN s_clob_cp:HIDDEN IN {&FRAME} = YES
            s_clob_col:HIDDEN IN {&FRAME} = YES
            b_Field._Label:HIDDEN IN {&FRAME} = NO
            b_Field._Col-label:HIDDEN IN {&FRAME} = NO.
END.
ELSE
   ASSIGN s_lob_size:HIDDEN IN {&FRAME} = YES
          s_lob_Area:HIDDEN IN {&FRAME} = YES
          b_Field._Decimals:HIDDEN IN {&FRAME} = NO
          b_Field._Format:HIDDEN IN {&FRAME} = NO
          s_btn_Fld_Format:HIDDEN IN {&FRAME} = NO.
   

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

   /* The following is for Oracle backward compatability and for backends
      like ODBC:
      The old ora_typ scheme for numbers was 3 entries where gatetype/protype 
      were "Number/Decimal, Number/Integer, Number/Logical".  Now there are 
      actually separate gateway data types, 5 altogether: "Number/Decimal, 
      Decimal/Decimal Float/Decimal Integer/Integer, Logical/Logical.  
      Unfortunately, the old combo (e.g., Number/integer) still exists 
      in oracle databases and this does not match any current ora_typ table 
      combination.  So this code is to find the correct entry.  Match the 
      one with the same data type code # as "Number" but with the correct 
      progress type.  All these entries should be contiguous.
      There is also the case (currently only for odb) where the user can
      associate different progress types with the same gate type.  So
      as with the Oracle case, there are multiple entries where the data
      type code is the same (and in this case the gateway type is also
      the same) but the progress type is different.
   */
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

if INDEX(s_Fld_Capab, {&CAPAB_CHANGE_DATA_TYPE}) <> 0 then
do:
   /* type_ix is based on For-Type and I know that Progress doesn't allow changing of 
      data types so I know this is valid here.  Get the data type family.
   */
   family = ENTRY(type_ix, user_env[16]).

   if family <> "0" then
   do:
      assign
      	 change_type = yes
      	 s_lst_Fld_DType:list-items in {&Frame} = "".  /* clear the list */
     
      /* Look through the families - find the matching ones and add the
      	 corresponding data type to the combo list. 
      */
      do num = 1 to NUM-ENTRIES(user_env[16]):
      	 if family = ENTRY(num, user_env[16]) then
      	 do:
      	    /* The list entry has the format: "gatetype (pro type)". */
      	    assign
      	       gate_type = ENTRY(num, user_env[11])
      	       pro_type = ENTRY(num, user_env[15])
	       s_Res = s_lst_Fld_DType:add-last(STRING(gate_type, "x(21)") + 
      	       	     	      	              "(" + pro_type + ")")
      	       	       in {&Frame}.
      	 end.
      end.
	 
      num = s_lst_Fld_DType:num-items in frame fldprops.
      s_lst_Fld_DType:inner-lines in frame fldprops = 
      	 (if num <= 10 then num else 10).

      /* Adjust the data type fill-in and list: font and width. Have
      	 to do this before cbdrop which positions the drop button 
      */
      {adedict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "FALSE"}

      /* cbtdrop.i is included in edittrig.i because of non-modal-ness. */
      {adecomm/cbcdrop.i &Frame  = "{&Frame}"
		         &CBFill = "s_Fld_DType"
		         &CBList = "s_lst_Fld_DType"
		     	 &CBBtn  = "s_btn_Fld_DType"
		     	 &CBInit = "curr_type"}
   end.
end.

if NOT change_type then
do:
   /* Disable the data type fill-in and the combo box components since
      the data type is not modifiable. */
   assign
      s_Fld_DType:sensitive in {&Frame} = false
      s_btn_Fld_DType:visible in {&Frame} = false 
      s_lst_Fld_DType:visible in {&Frame} = false.

   if ispro then
      s_Fld_DType = s_Fld_Protype.
   else 
      s_Fld_DType = curr_type.
   s_Fld_DType:screen-value in {&Frame} = s_Fld_DType.

   /* Adjust the data type fill-in and list: font and width. */
   {adedict/FLD/dtwidth.i &Frame = "{&Frame}" &Only1 = "TRUE"}
end.

/* get some specific info for LOBs */
IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:

    /* Find the storage object so that we can see which area the lob is stored
       in and then find the area to display the name to the user if record has
       been committed.  Else find area using number in _fld-stlen 
       _Fld-stlen holds the object number once the field is created by the Progress client 
    */
    IF b_field._Field-rpos <> ? THEN DO: /* if the field was commited */
        FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                             AND _Storageobject._Object-type = 3
                             AND _Storageobject._Object-number = b_Field._Fld-stlen
                             NO-LOCK.
        FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
   END.
   ELSE
       FIND _Area WHERE _Area._Area-number =  b_Field._Fld-stlen NO-LOCK.

  ASSIGN s_lob_size = b_Field._Fld-Misc2[1]
         s_lob_wdth = b_Field._Width
         s_lob_Area  = _Area._Area-name.
  
  RELEASE _Area.
  RELEASE _storageobject.

  /* specific codepage/collation information for CLOBs */
  IF b_field._dtype = {&DTYPE_CLOB} THEN
     ASSIGN s_clob_cp = b_Field._Charset
            s_clob_col = b_Field._Collation.
END.

display  b_Field._Field-Name  b_Field._Mandatory
      	 b_Field._Format      
         b_Field._Label       WHEN b_field._dtype <> {&DTYPE_CLOB}
         b_Field._Col-label   WHEN b_field._dtype <> {&DTYPE_CLOB}
         s_Fld_Array
      	 b_Field._Initial     b_Field._Desc        
      	 b_Field._Help        s_Optional
      	 b_Field._Extent
         b_Field._Field-rpos
      	 b_Field._Order       when s_CurrObj = {&OBJ_FLD}
      	 b_Field._Decimals    when b_Field._dtype = {&DTYPE_DECIMAL}
      	 b_Field._Fld-case    when b_Field._dtype = {&DTYPE_CHARACTER} OR b_field._Dtype = {&DTYPE_CLOB}
      	 s_Fld_InIndex        when s_CurrObj = {&Obj_FLD}
      	 s_Fld_InView  	      when s_CurrObj = {&Obj_FLD}
   with {&Frame}.

IF b_Field._Dtype = {&DTYPE_BLOB} AND NOT ispro  THEN
    DISPLAY b_field._Fld-case WITH {&Frame}.

IF ispro AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
    DISPLAY s_lob_area s_lob_size WITH {&Frame}.
    
    ASSIGN b_Field._Format:HIDDEN IN {&Frame} = TRUE
           s_btn_Fld_Format:HIDDEN IN {&FRAME} = YES .
    
    IF b_field._dtype = {&DTYPE_CLOB} THEN
       DISPLAY s_clob_cp s_clob_col WITH {&Frame}.
END.


if {&ReadOnly} then
do:
   IF (b_Field._Dtype = {&DTYPE_BLOB} OR b_Field._Dtype = {&DTYPE_CLOB}) AND ispro THEN DO:
       DISABLE ALL WITH {&Frame}.
       ENABLE s_btn_close s_btn_Prev s_btn_Next WITH {&Frame} .
       APPLY "entry" TO s_btn_close IN {&Frame}.     
   END.
   ELSE DO:
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
	   s_btn_Fld_Gateway       WHEN NOT ispro
	   s_btn_Close
	   s_btn_Prev
	   s_btn_Next
	   s_btn_Help
	   with {&Frame}.
   END.
end.
else do:
   find _File of b_field no-lock no-error.
   change_ext = (  b_Field._Extent > 0
            AND  (
                  ( INDEX(s_Fld_Capab, {&CAPAB_CHANGE_EXTENT}) <> 0
            AND     NOT s_Fld_InIndex
                  )
            OR    ( available _File
            AND     CAN-DO("PROCEDURE,FUNCTION,BUFFER",_File._For-type)
            AND     s_DbCache_Type[s_DbCache_ix] = "ORACLE"
                  )
                 )
                ).
   release _File.
   /* Desensitize explicitly in case they were enabled from a previous 
      iteration. */
   if NOT change_ext then
      assign
      	 s_Fld_Array:sensitive in {&Frame} = no
      	 b_Field._Extent:sensitive in {&Frame} = no.

   IF (b_Field._Dtype = {&DTYPE_BLOB} OR b_Field._Dtype = {&DTYPE_CLOB}) AND ispro THEN DO:
       
       DISABLE ALL EXCEPT 
              b_Field._Field-Name 
              b_Field._Order
              s_lob_size
              b_Field._Desc
       WITH {&Frame}.

       ENABLE b_Field._Field-Name 
              b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
              b_Field._Desc
              s_lob_size
              b_field._Fld-case WHEN b_Field._Dtype = {&DTYPE_CLOB}
              s_btn_OK
              s_btn_Save
              s_btn_Close
              s_btn_Prev
              s_btn_Next
              s_btn_Help
              with {&Frame}.

       /* adjust s_lob_size tab order */
       ASSIGN s_Res = s_lob_size:move-after-tab-item
              (b_Field._Order:handle in {&Frame}) in {&Frame}.

       IF b_Field._Dtype = {&DTYPE_CLOB} THEN DO:
          IF b_field._Fld-case:SCREEN-VALUE IN {&Frame} <> STRING(b_Field._Fld-case) THEN
             ASSIGN b_field._Fld-case:SCREEN-VALUE IN {&Frame} = STRING(b_Field._Fld-case).
       END.

       APPLY "entry" to b_Field._Field-Name in {&Frame}.

   END.
   ELSE IF b_field._Dtype = {&DTYPE_BLOB} THEN DO:
     DISABLE all except
        s_btn_Close
	    s_btn_Prev
	    s_btn_Next
	    s_btn_Help
	  with {&Frame}.

     ENABLE b_Field._Field-Name 
            b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
            b_Field._Desc
            s_btn_Fld_Gateway  WHEN NOT ispro
            s_btn_OK
      	    s_btn_Save
            s_btn_Close
            s_btn_Prev
            s_btn_Next
            s_btn_Help
            with {&Frame}.
     APPLY "entry" to b_Field._Field-Name in {&Frame}.
   END.
   ELSE DO:
    
    IF b_field._dtype <> {&DTYPE_BLOB} AND b_field._dtype <> {&DTYPE_CLOB} THEN DO:
   /* ENABLE effects the TAB order */
     enable b_Field._Field-Name 
            s_Fld_DType	     when change_type 
      	  s_btn_Fld_DType    when change_type
      	  b_Field._Format 
      	  s_btn_Fld_Format
      	  b_Field._Label
      	  b_Field._Col-label
      	  b_Field._Initial
      	  b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
      	  b_Field._Desc
      	  b_Field._Help
      	  b_Field._Mandatory when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	 > 0 
      	  s_Fld_Array        when change_ext
      	  b_Field._Extent    when change_ext 
      	  s_btn_Fld_Triggers
      	  s_btn_Fld_Validation
      	  s_btn_Fld_ViewAs
      	  s_btn_Fld_StringAttrs
      	  s_btn_Fld_Gateway  when NOT ispro
      	  s_btn_OK
      	  s_btn_Save
      	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
      	  with {&Frame}.

    END.
    ELSE DO:
        enable b_Field._Field-Name 
               s_Fld_DType	     when change_type 
             b_Field._Order     when s_CurrObj = {&OBJ_FLD} 
             s_lob_size
             b_Field._Desc
             s_btn_OK
             s_btn_Save
             s_btn_Close
             s_btn_Prev
             s_btn_Next
             s_btn_Help
             with {&Frame}.

    END.

   /* Now readjust tab orders for stuff not in the ENABLE list but
      which may in fact be sensitive.
   */
   if change_type then
      s_Res = s_lst_Fld_DType:move-after-tab-item
		  (s_btn_Fld_DType:handle in {&Frame}) in {&Frame}.
   assign
      s_Res = b_Field._Decimals:move-before-tab-item
		  (b_Field._Desc:handle in {&Frame}) in {&Frame}
      /* do this one to be sure we have a stable anchor for fld-case */
      s_Res = b_Field._Mandatory:move-after-tab-item 
		  (b_Field._Help:handle in {&Frame}) in {&Frame}
      s_Res = b_Field._Fld-case:move-after-tab-item
		  (b_Field._Mandatory:handle in {&Frame}) in {&Frame}
      .

   apply "entry" to b_Field._Field-Name in {&Frame}.
   END.
end.
