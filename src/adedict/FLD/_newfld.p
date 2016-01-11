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

File: _newfld.p

Description:
   Display and handle the add field boxes and then add
   the field if the user presses OK.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 07/10/98 Added _Owner check for _File.
              12/11/98 Check for duplicate order numbers, warn and prevent.
              05/01/00 DLM Added _owner to find that was missed 20000428020
              10/01/02 DLM Changed check for SQL tables.
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}


Define var Last_Order as integer init ?. /* YES-UNDO*//* to set _Order field */
Define var Record_Id  as recid 	     	    NO-UNDO.  /* table record Id */
Define var Copy_Hit   as logical init false NO-UNDO.  /* Flag - was copy hit? */
Define var IsPro      as logical       	    NO-UNDO.  /* true if db is Prog. */
Define var copied     as logical            NO-UNDO.  
Define var added      as logical init no    NO-UNDO.
Define var odbtyp     as character          NO-UNDO.
Define var isodbc     as logical init no    NO-UNDO.

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


/*===========================Internal Procedures=============================*/


/*----------------------------------------------------------------------------
   SetDataTypes

   Get the list of data types appropriate for the current gateway.  For
   non-progress types, also get default information associated with that
   type and just store it so we can set defaults when we need to.
----------------------------------------------------------------------------*/
PROCEDURE SetDataTypes:

Define var types as char    NO-UNDO.
Define var num 	 as integer NO-UNDO.

   if IsPro then
      assign
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,RAW,RECID"
      	 num = 7.
   else do:
      /* Compose a string to pass to list-items function where each entry
      	 is a data type that looks like "xxxx (yyyy)" where
      	 xxxx is the gateway type and yyyy is the progress type
      	 that it maps to.
      */
      types = "".
      do num = 1 to NUM-ENTRIES(user_env[11]) - 1:
      	 types = types + (if num = 1 then "" else ",") +
      	       	 STRING(ENTRY(num, user_env[11]), "x(21)") + 
      	       	 "(" + ENTRY(num, user_env[15]) + ")".
      end.
      num = num - 1.  /* undo terminating loop iteration */
   end.
   
   s_lst_Fld_DType:list-items in frame newfld = types.
   s_lst_Fld_DType:inner-lines in frame newfld = 
      (if num <= 10 then num else 10).
end.


/*----------------------------------------------------------------------------
   SetDefaults

   Set default values based on the chosen data type.  Display all new values.
   
   When we get domains:
   Copy the values from an existing domain into the display variables for 
   the new field or domain.  Display all new values.

   Output
      s_Fld_Protype  - Progress data type string
      s_Fld_Typecode - The underlying integer data type (dtype field) 
      s_Fld_Gatetype - The gateway type
----------------------------------------------------------------------------*/
Procedure SetDefaults:

{adedict/FLD/setdflts.i &Frame = "frame newfld"} 

end.


/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newfld
   apply "END-ERROR" to frame newfld.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newfld
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD BUTTON or GO -----*/
on GO of frame newfld	/* or Create because it's auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var obj      as char 	  NO-UNDO.
   Define var ins_name as char    NO-UNDO.
   Define var ix       as integer NO-UNDO.

   obj = (if s_CurrObj = {&OBJ_FLD} then "field" else "domain").

   run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT obj, OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.

   /* Set some gateway defaults in case they haven't been set yet */
   run adedict/FLD/_dfltgat.p (FALSE).

   /* Do some gateways related validation */
   run adedict/FLD/_valgate.p.
   if RETURN-VALUE = "error" then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").

      /* NOTE: the data type variables s_Fld_Protype/Gatetype etc. have
      	 been set from the trigger on change of data type.  b_Field._stdtype
      	 has also been set.
      */

      assign
	 b_Field._File-recid = Record_Id
	 b_Field._Data-Type = s_Fld_Protype
      	 b_Field._For-type = s_Fld_Gatetype
      	 input frame newfld b_Field._Format
	 input frame newfld b_Field._Field-Name
	 input frame newfld b_Field._Initial
	 input frame newfld b_Field._Label
	 input frame newfld b_Field._Col-label
	 input frame newfld b_Field._Mandatory
	 input frame newfld b_Field._Decimals
	 input frame newfld b_Field._Fld-case
	 input frame newfld b_Field._Extent
	 input frame newfld b_Field._Order
	 input frame newfld b_Field._Help
	 input frame newfld b_Field._Desc.
   
      /* For certain gateways we store the character length in the _Decimals
	 field to support certain SQL operations.
      */
      if (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND 
	  INDEX(s_Fld_Capab, {&CAPAB_CHAR_LEN_IN_DEC}) <> 0) then
	 b_Field._Decimals = b_Field._Fld-stlen.

      Last_Order = b_Field._Order.

      /* Add entry to appropriate list in the correct order */
      if s_CurrObj = {&OBJ_FLD} then
      	 run adedict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).     

      {adedict/setdirty.i &Dirty = "true"}
      display "Field Created" @ s_Status with frame newfld.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* Will only get here if there's an error. */
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.
end.


/*----- LEAVE of DATA TYPE FIELD -----*/

on /*leave*/ U1 of s_Fld_DType in frame newfld, 
      	       	   s_lst_Fld_DType in frame newfld
do:
   /* See if type changed first.  If user had changed format or initial 
      value, for example, we don't want to clobber with defaults if we 
      don't have to. (* - los 12/27/94)
   */
   if s_Fld_DType <> s_Fld_DType:screen-value in frame newfld then
     run SetDefaults.  /* sets s_Fld_Typecode */
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame newfld 
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
   run adedict/FLD/_dfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame newfld,
       INPUT b_Field._Initial:HANDLE in frame newfld,
       INPUT 0,
       INPUT false). 
end.


/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame newfld
do:
   Define var fmt as char NO-UNDO.

   /* Allow user to pick a different format from examples */
   fmt = input frame newfld b_Field._Format.
   run adedict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame newfld = fmt.
end.


/*----- VALUE-CHANGED of ARRAY TOGGLE -----*/
on value-changed of s_Fld_Array in frame newfld
do:
   if SELF:screen-value = "yes" then
   do:
      b_Field._Extent:sensitive in frame newfld = true.
      b_Field._Extent:screen-value = "1".  /* default to non-zero value */
      apply "entry" to b_Field._Extent in frame newfld.
   end.
   else 
      assign
      	 b_Field._Extent:sensitive in frame newfld = false
      	 b_Field._Extent:screen-value in frame newfld = "0".
end.


/*----- HIT of COPY BUTTON -----*/
on choose of s_btn_Fld_Copy in frame newfld
do:
   if INDEX(s_Fld_Capab, {&CAPAB_COPY}) = 0 THEN
        IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
                _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
        do:
            message "You may not copy fields for this database type."
      	         view-as ALERT-BOX ERROR buttons OK.
            return NO-APPLY.
        end.  
   /* Flag that copy was hit.  The add wait-for will break and we'll
      call the copy program from there.  We must do this so that pressing
      Done after copy will not undo the addition of the copied fields.
   */
   Copy_Hit = true.
end.


/*----- HIT of VIEW-AS BUTTON -----*/
on choose of s_btn_Fld_ViewAs in frame newfld
do:
   Define var no_name as logical NO-UNDO.
   Define var mod     as logical NO-UNDO.

   {adedict/forceval.i}  /* force leave trigger to fire */

   run adedict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run adecomm/_viewas.p (INPUT s_Fld_ReadOnly, INPUT s_Fld_Typecode,
      	       	     	  INPUT s_Fld_ProType, 
      	       	     	  INPUT-OUTPUT b_Field._View-as, OUTPUT mod).
end.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame newfld
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) THEN
         LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			INT(b_Field._Order:SCREEN-VALUE IN FRAME newfld) AND
			_Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
	 TRIM(b_Field._Order:SCREEN-VALUE IN FRAME newfld) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME newfld = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.

/*----- HELP -----*/
on HELP of frame newfld OR choose of s_btn_Help in frame newfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Field_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var msg     as char NO-UNDO.
Define var copytbl as char NO-UNDO init "".
Define var copyfld as char NO-UNDO init "".

find _File WHERE _File._File-name =  "_Field"
             AND _File._Owner = "PUB"
             NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   if s_CurrObj = {&OBJ_FLD} then
      msg = "create fields.".
   else
      msg = "create domains.".
   message s_NoPrivMsg msg view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

find _File where RECID(_File) = s_TblRecId.
msg = "".
if _File._Db-lang >= {&TBLTYP_SQL} then
   msg = "This is a PROGRESS/SQL table.  Use ALTER TABLE/ADD COLUMN.".
else if _File._Frozen then  
   msg = "This table is frozen and cannot be modified.".
if msg <> "" then
do:
   message msg view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get ODBC types in case this is an ODBC db */
odbtyp = { adecomm/ds_type.i
           &direction = "ODBC"
           &from-type = "odbtyp"}.
           
/* See if this db is an ODBC db */      
IF CAN-DO(odbtyp, s_DbCache_Type[s_DbCache_ix]) THEN ASSIGN isodbc = yes.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).

/* allow add if ODBC BUFFER table */
if INDEX(s_Fld_Capab, {&CAPAB_ADD}) = 0 THEN
    IF NOT (isodbc AND _file._For-Type = "BUFFER" AND
            _File._For-Owner = ? AND _File._For-Name = "NONAME") THEN
    do:
        message "You may not add a field definition for this database type."
            view-as ALERT-BOX ERROR buttons OK.
        return.
    end.    


/* Set dialog box title to show which table this field will belong to. */
frame newfld:title = "Create Field for Table " + s_CurrTbl.

/* Set the record id of the table that this field will belong to or of the
   domain table which means this field is really a domain. */
if s_CurrObj = {&OBJ_FLD} then
   Record_Id =  s_TblRecId.
else
   Record_Id = s_DomRecId.

IsPro = {adedict/ispro.i}.

/* InIndex and InView aren't relevant on "add", Order# isn't relevant 
   for domains, copy is only used in create not props.
*/
assign
   s_Fld_InIndex:hidden  in frame newfld = yes
   s_Fld_InView:hidden   in frame newfld = yes
   s_btn_Fld_Copy:hidden in frame newfld = no
   b_Field._Order:hidden in frame newfld =
      (if s_CurrObj = {&OBJ_DOM} then yes else no)
   s_btn_Fld_Gateway:sensitive in frame newfld = 
      (if IsPro then no else yes).

/* Adjust the data type fill-in and list: font and width. */
{adedict/FLD/dtwidth.i &Frame = "Frame newfld" &Only1 = "FALSE"}

/* Run time layout for button area.  This defines eff_frame_width 
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame newfld:private-data <> "alive" then
do:
   frame newfld:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newfld" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Field._Desc:RETURN-INSERT in frame newfld = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame newfld = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Fill data type combo box based on the gateway */
run SetDataTypes.
{adecomm/cbdrop.i &Frame  = "frame newfld"
      	       	  &CBFill = "s_Fld_DType"
      	       	  &CBList = "s_lst_Fld_DType"
      	       	  &CBBtn  = "s_btn_Fld_DType"
     	       	  &CBInit = """"}

/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newfld.
s_btn_Done:label in frame newfld = "Cancel".

enable b_Field._Field-Name  
       s_btn_Fld_Copy
       s_Fld_DType          
       s_btn_Fld_DType
       b_Field._Format      
       s_btn_Fld_Format     
       b_Field._Label  	    
       b_Field._Col-label   
       b_Field._Initial
       b_Field._Order 	    when s_CurrObj = {&OBJ_FLD} 
       b_Field._Desc
       b_Field._Help
       b_Field._Mandatory   when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	       > 0 
       b_Field._Fld-case    /* this may be disabled later */
       s_Fld_Array
       s_btn_Fld_Triggers
       s_btn_Fld_Validation
       s_btn_Fld_ViewAs
       s_btn_Fld_StringAttrs
       s_btn_Fld_Gateway    when NOT IsPro
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newfld.

/* The rule is ENABLE effects the TAB order but x:SENSITIVE = yes does not. 
   Now readjust tab orders for stuff not in the ENABLE set but
   which may, in fact be sensitive at some point during this .p.
*/
assign
   s_Res = s_lst_Fld_DType:move-after-tab-item
      	       (s_btn_Fld_DType:handle in frame newfld) in frame newfld
   s_Res = b_Field._Decimals:move-before-tab-item
      	       (b_Field._Desc:handle in frame newfld) in frame newfld
   s_Res = b_Field._Fld-case:move-before-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   s_Res = b_Field._Extent:move-after-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld
   .
   
/* Each add will be a subtransaction. */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newfld <> "Close" then
      s_btn_Done:label in frame newfld = "Close".

   if Copy_Hit then
   do:
      /* This will copy fields and end the sub-transaction so that "Done" 
      	 will not undo it. */
      Copy_Hit = false.  /* reset flag */
      run adedict/FLD/_fldcopy.p (INPUT-OUTPUT Last_Order,
      	       	     	      	 OUTPUT copytbl, OUTPUT copyfld,
      	       	     	      	 OUTPUT copied).
      if copied then 
      do:
      	 display "Copy Completed" @ s_Status with frame newfld.
      	 added = yes.
      end.
   end.
   else do:
      create b_Field.

      /* default a unique order # */
      if Last_Order = ? then
      do:
	 find LAST _Field USE-INDEX _Field-Position 
	    where _Field._File-recid = Record_Id NO-ERROR.
	 Last_Order = (if AVAILABLE _Field then _Field._Order + 10 else 10).
      end.
      else
	 Last_Order = Last_Order + 10.

      if copytbl = "" then
      do:
      	 /* This is a brand new field */

	 b_Field._Order = Last_Order.
    
	 /* Set defaults based on the current data type (either the first
	    in the list or whatever was chosen last time).
	 */
	 run SetDefaults.
    
	 /* Reset some other default values */
	 assign
	    s_Fld_Array = false
	    b_Field._Extent:screen-value in frame newfld  = "0"
	    b_Field._Extent:sensitive in frame newfld = no
	    b_Field._Fld-case:screen-value in frame newfld = "no".

      	 /* Display any remaining attributes */
	 display "" @ b_Field._Field-Name /* blank instead of ? */
      	       	 s_Optional
		 b_Field._Label
		 b_Field._Col-label
		 b_Field._Mandatory
		 b_Field._Help
		 b_Field._Desc 
		 b_Field._Order
		 s_Fld_Array
		 with frame newfld.
      end.
      else do:  
      	 /* Set the field values based on a field chosen as a template
      	    in the Copy dialog box.
      	 */
      	 find _File where _File._Db-recid = s_DbRecId AND
      	       	     	  _File._File-name = copytbl AND
                         ( _File._Owner = "PUB"  OR _File._Owner = "FOREIGN").
      	 find _Field of _File where _Field._Field-name = copyfld.
      	 assign
      	    b_Field._Field-name = _Field._Field-name
      	    b_Field._Data-type  = _Field._Data-type
      	    b_Field._Format     = _Field._Format
      	    b_Field._Initial    = _Field._Initial
      	    b_Field._Order    	= Last_Order.
      	 {prodict/dump/copy_fld.i &from=_Field &to=b_Field &all=false}

      	 assign
      	    s_Fld_DType = b_Field._Data-Type
      	    s_Fld_Array = (if b_Field._Extent > 0 then yes else no)
      	    s_Fld_Protype = b_Field._Data-type
	    s_Fld_Gatetype = b_Field._For-type
	    s_Fld_Typecode = _Field._dtype.

      	 /* Make sensitive/label adjustments to fld-case and _Decimals based
      	    on data type chosen. */
      	    run adedict/FLD/_dtcust.p 
      	       (INPUT b_Field._Fld-case:HANDLE in frame newfld,
      	       	INPUT b_Field._Decimals:HANDLE in frame newfld).

      	 display
	    b_Field._Field-name
      	    s_Fld_DType
      	    s_Optional
	    b_Field._Format    
	    b_Field._Label     
	    b_Field._Col-label 
	    b_Field._Initial   

	    b_Field._Order     
	    b_Field._Fld-case 	 when s_Fld_Typecode = {&DTYPE_CHARACTER}
	    b_Field._Decimals  	 when s_Fld_Typecode = {&DTYPE_DECIMAL}
	    b_Field._Mandatory 
      	    s_Fld_Array
	    b_Field._Extent      when b_Field._Extent > 0
	    b_Field._Desc      
	    b_Field._Help      
      	    with frame newfld.

      	 /* Reset the drop down value for data types */
      	 s_lst_Fld_DType:screen-value in frame newfld = CAPS(s_Fld_DType).

      	 /* Reset these for next loop iteration. */
      	 assign
      	    copytbl = ""
      	    copyfld = "".
      end.

      wait-for choose of s_btn_OK in frame newfld,
      	       	     	 s_btn_Add in frame newfld,
      	       	     	 s_btn_Fld_Copy in frame newfld OR
      	       GO of frame newfld
      	       FOCUS b_Field._Field-Name in frame newfld.

      /* Undo the create of b_Field so that when we repeat we don't end up
	 with a bogus field with all unknown values. */
      if Copy_Hit then
	 undo add_subtran, next add_subtran.
   end.
end.

hide frame newfld. 
return.





