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
   Display and handle the add field or add domain dialog boxes and then add
   the field or domain if the user presses OK.

Author: Laura Stern

Date Created: 02/05/92 
     Modified: 01/15/95 to work with the PROGRESS/400 Data Dictionary 
               Donna McMann
     Modified: 10/12/95 to add check of as/400 field name for duplicates    
               12/18/95 D. McMann for updating _fld-misc1[5] to fix bug.    
               03/22/96 D McMann Changed null capable to default to yes
                                and removed mutual exclusion with mandatory.
                                Also added validation for format = 0 length.
               07/25/96 D. McMann Added assignment of _Fil-misc2[5][1] = Y
                                for last maintained in ADE.     
               08/19/96 D. McMann  Changed modify button to copy label, col-label,
                                   help, desc, view-as, valexp, valmsg, and all
                                   SA fields.  These fields were not copied before.
                                   Bug 96-08-13-014   
               10/07/97 D. McMann Added assignment of _fld-misc1[5] and decimals
                                   bug 97-10-06-006   
               08/16/00 D. McMann Added Raw Data Type Support     
               08/24/01 D. McMann Removed variable length and extent from RAW                                           
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/capab.i}


Define var Last_Order as integer init ?. /* YES-UNDO*//* to set _Order field */
Define var Record_Id  as recid 	     	    NO-UNDO.  /* table record Id */
Define var Copy_Hit   as logical init false NO-UNDO.  /* Flag - was copy hit? */
Define var IsPro      as logical       	    NO-UNDO.  /* true if db is Prog. */
Define var copied     as logical            NO-UNDO.  
Define var added      as logical init no    NO-UNDO.

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
      	 types = "CHARACTER,DATE,DECIMAL,INTEGER,LOGICAL,RECID,RAW"
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
--------------------------------------------------------------------------*/
Procedure SetDefaults:

{  as4dict/FLD/setdflts.i &Frame = "frame newfld"} 

end.

/*------------------------------------------------------------------------
Procedure Set_Stlen.

This procedure is only called (by Procedure SetDefaults) to set the 
storage length (Fld-stlen) for character and decimal datatypes.  Fld-stlen 
is already set for the logical, integer, and date datatypes.  
-------------------------------------------------------------------------*/

PROCEDURE Set_Stlen:

   define var frmt as character NO-UNDO.
   define var lngth as integer.                     

   { as4dict/FLD/as4stlen.i   &input_phrase = "input frame newfld" &prefix = "b_field" }
 
 end. /* Procedure Set_Stlen.  */
/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newfld    
  do:
    clear frame newfld all.
   apply "END-ERROR" to frame newfld.
end.

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

   run as4dict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT obj, OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.           

    if can-find(as4dict.p__Field where as4dict.p__Field._AS4-file = as4dict.p__File._AS4-File
                                                          and as4dict.p__Field._AS4-Library = as4dict.p__File._AS4-Library
                                                          and as4dict.p__Field._For-name = input frame newfld b_Field._For-name)
    then do:
        message "A field already exists with entered AS/400 Fld Name."
            view-as alert-box Error button Ok.
        s_ok_hit = no.
        return NO-APPLY.
  END.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").              
        
      IF b_field._Fld-stdtype = 35 THEN 
	ASSIGN b_field._Fld-Misc1[5] = 4.  
 
      ELSE IF b_field._Fld-stdtype = 36 THEN 
                ASSIGN b_field._Fld-Misc1[5] = 9.      

                    
      assign
	 b_Field._File-recid = Record_Id 
	 b_Field._Data-Type = s_Fld_Protype      	
     b_Field._For-type = s_Fld_Gatetype
     b_Field._Dtype = s_Fld_Typecode
     b_Field._For-name = CAPS(input frame newfld b_Field._For-name)
     input frame newfld b_Field._Format
	 input frame newfld b_Field._Field-Name
	 input frame newfld b_Field._Initial
	 input frame newfld b_Field._Label
	 input frame newfld b_Field._Col-label
	 b_Field._Mandatory = 
	     if input frame newfld s_Fld_Mandatory then "Y" else "N"
	 input frame newfld b_Field._Decimals
	 input frame newfld b_Field._Extent   
	 input frame newfld b_Field._Order 
	 b_Field._Fld-Misc2[2] =            /* Null capable */
  	     (if input frame newfld s_Fld_Null_Capable then "Y" else "N")

     input frame newfld b_Field._For-allocated     
	 input frame newfld b_Field._Help
	 input frame newfld b_Field._Desc       
	 b_Field._File-number = s_TblForNo
	 b_Field._Can-Read = "*"
	 b_Field._Can-Write = "*".

	 If b_Field._Extent > 0 then assign b_Field._Fld-Misc2[5] = "P".
	 else assign b_Field._Fld-Misc2[5] = "B".
         
     if s_fld_typecode = {&Dtype_Date} AND
            b_Field._Fld-Misc1[3] = 0 THEN
              RUN set_stlen.       
                                                      	
	 if s_Fld_case:sensitive then 
	    assign b_Field._Fld-case = 
	       if input frame newfld s_Fld_case then "Y" else "N".
	 ELSE
       ASSIGN b_Field._Fld-case = "N".

	  /* If variable length then assign max-size   The _Fld-misc1[6] is assigned
	      here because the client code looks to see if this field has a value to
	      know if variable length.  */     
          IF input frame newfld s_Fld_Var_Length THEN
            ASSIGN b_Field._For-maxsize = (b_Field._Fld-stlen + 2)
                             b_Field._Fld-Misc1[6] = 1.
            
      /* Fill the As4-File and AS4-Library Fields from our selected table.  Must
           refind the file in case the user has selected copy field and table in
           buffer is not table we are working with.    */  
       find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.
         IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0. 
        assign 
            b_Field._AS4-File = as4dict.p__File._AS4-File
            b_Field._AS4-Library = as4dict.p__File._AS4-Library   
            as4dict.p__File._Fil-Res1[8] = 1
            as4dict.p__file._numfld = as4dict.p__File._numfld + 1.   
        
        IF SUBSTRING(as4dict.p__File._Fil-misc2[4],3,1) = "N" 
               AND b_Field._Fld-misc2[2] = "Y" THEN
          ASSIGN SUBSTRING(as4dict.p__File._Fil-misc2[04],3,1) = "Y".  
            
        IF SUBSTRING(as4dict.p__File._Fil-misc2[5],1,1) <> "Y" THEN
          ASSIGN SUBSTRING(as4dict.p__File._fil-misc2[5],1,1) = "Y".
          
        IF SUBSTRING(as4dict.p__file._Fil-misc2[5],2,1) = "6" THEN.
         ELSE DO:
            IF b_Field._For-type = "cstring"  and substring(as4dict.p__File._Fil-misc2[5],2,1) = ""
                THEN  ASSIGN SUBSTRING(as4dict.p__File._Fil-misc2[5],2,1) = "6".
            ELSE IF b_Field._Fld-Case = "N" and substring(as4dict.p__File._Fil-misc2[5],2,1) = ""THEN
                ASSIGN SUBSTRING(as4dict.p__File._Fil-misc2[5],2,1) = "7".    
         END.

        IF b_Field._Dtype = 0 THEN DO:
              case s_Fld_Protype:
                   when "Character" then s_Fld_Typecode = {&DTYPE_CHARACTER}.
                   when "Date"	    then s_Fld_Typecode = {&DTYPE_DATE}.
                   when "Logical"   then s_Fld_Typecode = {&DTYPE_LOGICAL}.
                   when "Integer"   then s_Fld_Typecode = {&DTYPE_INTEGER}.
                   when "Decimal"   then s_Fld_Typecode = {&DTYPE_DECIMAL}.
                   when "RECID"	    then s_Fld_Typecode = {&DTYPE_RECID}.
                   WHEN "RAW"       THEN s_Fld_Typecode = {&DTYPE_RAW}.
               end.
               ASSIGN b_Field._Dtype = s_Fld_Typecode.
       end.    
     
      Last_Order = b_Field._Order.

      /* Add entry to appropriate list in the correct order */
      if s_CurrObj = {&OBJ_FLD} then
      	 run as4dict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).


      {as4dict/setdirty.i &Dirty = "true"}
      display "Field Created" @ s_Status with frame newfld.
      added = yes.         
      /* get ready for next field for mandatory and null capable */         
      assign s_Fld_Mandatory = false
             s_Fld_Null_Capable = true
             s_Fld_Var_Length = false.        
           
      display s_fld_mandatory s_fld_null_capable s_fld_var_length
        with frame newfld.
                    
      enable
            s_Fld_Mandatory   when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	       > 0 
            s_Fld_Null_Capable with frame newfld.
      run adecomm/_setcurs.p ("").                   
      return.
   end.

   /* Will only get here if there's an error. */
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.
end.


/*----- LEAVE of DATA TYPE FIELD -----*/
/* FIX - Use U1 until we get cascading triggers because of combo box */
on /*leave*/ U1 of s_Fld_DType in frame newfld, 
      	       	   s_lst_Fld_DType in frame newfld
do:
   /* Look at the data type the user chose.  This will always be the
      name of a domain.  From that, get the domain and copy values from it
      as defaults for the new field or domain.  The values will be
      displayed.
   */
   run SetDefaults.  /* sets s_Fld_Typecode */  
   b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen).
   b_Field._Decimals:screen-value = string(b_field._Decimals). 
   disable b_Field._Fld-stlen with frame newfld.   

   IF b_Field._Fld-stdtype = 41 THEN 
      MESSAGE "Case Insensitive Key String has been maintained for"
               "compatibility with Version 6.  Using this data type in"
               "Version 7 will disable selection by server.  Use"
               "alternate sequence tables instead.  " SKIP
         VIEW-AS ALERT-BOX INFORMATION BUTTON OK.
       
    ELSE IF b_Field._Fld-stdtype = 40 THEN
     MESSAGE "The DDS hexadecimal data type is not supported."
             "This data type will be mapped to an ALPHA/CHARACTER data type."   SKIP
       VIEW-AS ALERT-BOX INFORMATION BUTTON OK.
                                                                               
   IF (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND b_Field._Fld-stdtype < 79) THEN 
      ENABLE s_fld_case s_Fld_Array s_fld_var_length b_Field._For-allocated with frame newfld.
   ELSE IF s_Fld_TypeCode = {&DTYPE_RAW} THEN  
     DISABLE  s_Fld_case s_Fld_var_length b_Field._For-allocated 
              s_Fld_Array WITH FRAME newfld.     
   ELSE DO:
     DISABLE  s_fld_case s_fld_var_length b_Field._For-allocated with frame newfld.  
     ENABLE s_fld_array WITH FRAME newfld.
   END.
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame newfld 
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format.   */         
 
   run as4dict/FLD/_dfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame newfld,
       INPUT b_Field._Initial:HANDLE in frame newfld,
       INPUT false).           
         
   /* Once there's a value in the format field, set the length 
      for character and decimal datatypes, which has to be based
      on the format.  Logical, Integer, and Date datatypes have
      been already in Set_Defaults. */          
   
   if (s_Fld_TypeCode = {&DTYPE_CHARACTER} or
       s_Fld_TypeCode = {&DTYPE_DECIMAL}) AND
      s_Fld_Typecode < 79 THEN DO:         
  
      run Set_Stlen.    
      b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen).
      b_Field._Decimals:screen-value = string(b_field._Decimals). 
       
   end. 

   IF (s_Fld_TypeCode = {&DTYPE_RAW}) THEN DO:
      run Set_Stlen.    
      b_Field._Fld-stlen:screen-value = string(b_field._fld-stlen).
      b_Field._Decimals:screen-value = string(b_field._Decimals). 
   END.
   if  (s_Fld_TypeCode = {&DTYPE_INTEGER}) or
       (s_Fld_TypeCode = {&DTYPE_DATE}) then
        run Set_Stlen.                         
        
   /* Validate that user has not entered a format which will result
      in a sync error for being zero length. */     
      
   if b_field._Fld-stlen:screen-value = "0" OR 
      b_field._Format:Screen-value = "0" then do:
        message "Value cannot be displayed using" b_field._Format:Screen-value SKIP
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
   END.                  
end.         


/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame newfld
do:
   Define var fmt as char NO-UNDO.

   /* Allow user to pick a different format from examples */
   fmt = input frame newfld b_Field._Format.
   run as4dict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame newfld = fmt.   
 
end.
/*-----ON CHOOSE OF VARIABLE LENGTH--------*/        
on value-changed of s_fld_var_length in frame newfld
do:
    IF SELF:screen-value = "yes" then
    do:
       b_Field._For-allocated:sensitive in frame newfld = true.
       b_Field._For-allocated:screen-value = "1".
       apply "entry" to b_Field._For-allocated in frame newfld.
     end.
     else
        assign b_field._For-allocated:sensitive in frame newfld = false
               b_field._For-allocated:screen-value in frame newfld = "0".
end.                       

/* ---VERIFY VARIABLE LENGTH------*/
 on leave of b_Field._For-allocated in frame newfld
 do:
    IF input frame newfld b_Field._For-allocated >= input frame newfld b_Field._Fld-stlen
        then do:
            MESSAGE  " Allocated length must be less than field length." SKIP
            VIEW-AS ALERT-BOX ERROR BUTTON OK.
           return NO-APPLY.
      end.
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
/*   if INDEX(s_Fld_Capab, {&CAPAB_COPY}) = 0 and s_DBCache_Type[s_DbCache_ix] <> "AS400" then
   do:
      message "You may not copy fields for this database type."
      	 view-as ALERT-BOX ERROR buttons OK.
      return NO-APPLY.
   end.       */

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

   {as4dict/forceval.i}  /* force leave trigger to fire */

   run as4dict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame newfld,
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.                        
   
   run adecomm/_viewas.p (INPUT s_Fld_ReadOnly, INPUT s_Fld_Typecode,
      	       	     	  INPUT s_Fld_ProType, 
      	       	     	  INPUT-OUTPUT b_Field._View-as, OUTPUT mod).
end.


/*----- HELP -----*/
on HELP of frame newfld OR choose of s_btn_Help in frame newfld
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Create_Field_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var msg     as char NO-UNDO.
Define var copytbl as char NO-UNDO init "".
Define var copyfld as char NO-UNDO init "".

find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.    

IF  SUBSTRING(as4dict.p__File._Fil-misc2[4],8,1) = "Y"  THEN DO:    
      if as4dict.p__file._For-flag = 1 then msg = "Limited logical virtual table can't be modified".
     else if as4dict.p__file._For-flag = 2 then msg = "Multi record virtual table can't be modified".
     else if as4dict.p__file._For-flag = 3 then msg = "Joined logical virtual table can't be modified".
     else if as4dict.p__file._For-flag = 4 then msg = "Program described virtual table can't be modified".
     else if as4dict.p__file._For-flag = 5 then msg = "Multi record program described virtual can't be modified".
     else msg = "Read only file, can't be modified via client". 
  
     message msg  SKIP view-as ALERT-BOX ERROR buttons OK.
     return.
end.            

dba_cmd = "RESERVE".
RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__File._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     
	  
IF dba_return <> 1 AND dba_return <> 12 THEN DO:
    RUN as4dict/_dbamsgs.p.
     return.
end.  

msg = "".
if as4dict.p__File._Db-lang = {&TBLTYP_SQL} then
   msg = "This is a PROGRESS/SQL table.  Use ALTER TABLE/ADD COLUMN.".
else if as4dict.p__File._Frozen = "Y" then  
   msg = "This file is frozen and cannot be modified.".
if msg <> "" then
do:
   message msg view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get gateway capabilities */         

run as4dict/_capab.p (INPUT {&CAPAB_FLD}, OUTPUT s_Fld_Capab).
if INDEX(s_Fld_Capab, {&CAPAB_ADD}) = 0 and s_DBCache_Type[s_DbCache_ix] <> "AS400" then
do:
   message "You may not add a field definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Set dialog box title to show which table this field will belong to. */
frame newfld:title = "Create Field for AS400 Table " + s_CurrTbl.

/* Set the record id of the table that this field will belong to or of the
   domain table which means this field is really a domain. */
if s_CurrObj = {&OBJ_FLD} then
   Record_Id =  s_TblForNo.
else
   Record_Id = s_DomRecId.    

IsPro = {as4dict/ispro.i}.

/* In Index and InView aren't relevant on "add", Order# isn't relevant 
   for domains, copy is only used in create not props.
*/
assign
   s_Fld_InIndex:hidden  in frame newfld = yes
   s_Fld_InView:hidden   in frame newfld = yes
   s_btn_Fld_Copy:hidden in frame newfld = no 
   s_Fld_Null_Capable = no
   s_Fld_Var_Length = no
   b_Field._Order:hidden in frame newfld =
      (if s_CurrObj = {&OBJ_DOM} then yes else no).

/* Adjust the data type fill-in and list: font and width. */
{as4dict/FLD/dtwidth.i &Frame = "Frame newfld" &Only1 = "FALSE"}

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
               b_Field._For-Name
               s_Fld_DType          
               s_btn_Fld_DType
               b_Field._Format      
               s_btn_Fld_Format     
               b_Field._Label  	    
               b_Field._Col-label   
               b_Field._Initial
               b_Field._Order 	    when s_CurrObj = {&OBJ_FLD}         
               s_Fld_Mandatory   when INDEX(s_Fld_Capab, {&CAPAB_CHANGE_MANDATORY}) 
      	       	     	      	       > 0 
               s_Fld_Null_Capable    /* Stored in For-Retrieve */      	       	     	      	              
               b_Field._Desc
                b_Field._Help
 
                s_Fld_Case            /* this may be disabled later */    
                s_Fld_Var_Length      /* Stored in Fld-misc2[4] */          
                 s_Fld_Array
 
               s_btn_Fld_Triggers
               s_btn_Fld_Validation
               s_btn_Fld_ViewAs
               s_btn_Fld_StringAttrs
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
   s_Res = s_Fld_case:move-before-tab-item
      	       (s_Fld_Var_Length:handle in frame newfld) in frame newfld
   s_Res = b_Field._Extent:move-after-tab-item
      	       (s_Fld_Array:handle in frame newfld) in frame newfld     
   s_Res = b_Field._For-allocated:move-after-tab-item
                        (s_Fld_Var_length:handle in frame newfld) in frame newfld   	       
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

      run as4dict/FLD/_fldcopy.p (INPUT-OUTPUT Last_Order,
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
      ASSIGN  b_Field._File-number = as4dict.p__file._File-number
	          b_Field._Fld-number =  (as4dict.p__File._Fil-res1[5] + 1)        
              b_Field._For-id =   b_Field._Fld-number     
              as4dict.p__file._Fil-Res1[5] = (as4dict.p__file._Fil-Res1[5] + 1).

	      
      /* default  to a unique order # */

       find LAST as4dict.p__Field USE-INDEX p__FieldL0
	    where as4dict.p__Field._File-number = s_TblForNo NO-ERROR.
        Last_Order = (if AVAILABLE as4dict.p__Field then 
	                    as4dict.p__Field._Order + 10 else 10).	


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
	    s_fld_null_capable = true
	    s_fld_mandatory = false
	    s_fld_var_length = FALSE        
	    s_Fld_Null_Capable:SCREEN-VALUE in frame newfld = "yes"
	    s_fld_Mandatory:screen-value in frame newfld = "no" 
	    s_Fld_Var_Length:screen-value in frame newfld = "no"
	    b_Field._Extent:screen-value in frame newfld  = "0"
	    b_Field._Extent:sensitive in frame newfld = no
	    s_Fld_case:screen-value in frame newfld = "no"
	    b_Field._For-allocated:screen-value in frame newfld = "0"
	    b_Field._For-allocated:sensitive in frame newfld = no.

      	 /* Display any remaining attributes */
	 display "" @ b_Field._Field-Name /* blank instead of ? */
                 "" @ b_Field._For-Name
      	       	 s_Optional
		 b_Field._Label
		 b_Field._Col-label
		 b_Field._Help
		 b_Field._Desc 
		 b_Field._Order	
	     	 b_Field._Fld-stoff
         	 b_Field._Fld-stlen
	         s_Fld_Array 
		 s_Fld_Var_Length 
		 with frame newfld.
      end.
      else do:                                  

      	 /* Set the field values based on a field chosen as a template
      	    in the Copy dialog box.
      	 */
      	 find as4dict.p__File where as4dict.p__File._File-name = copytbl.
      	 find as4dict.p__Field where as4dict.p__Field._File-number = as4dict.p__File._File-number
      	                         and as4dict.p__Field._Field-name = copyfld.  
      	                         
      	 assign
      	    b_Field._Field-name = as4dict.p__Field._Field-name
      	    b_Field._For-name   = as4dict.p__Field._For-name
      	    b_Field._Data-type  = as4dict.p__Field._Data-type 
      	    b_Field._Label = as4dict.p__Field._Label
      	    b_Field._Label-SA = as4dict.p__Field._Label-SA
      	    b_Field._Col-Label = as4dict.p__Field._Col-label
      	    b_Field._Col-Label-SA = as4dict.p__Field._Col-Label-SA
      	    b_Field._Valexp = as4dict.p__Field._Valexp
      	    b_Field._Valmsg = as4dict.p__Field._Valmsg
      	    b_Field._Valmsg-SA = as4dict.p__Field._Valmsg-SA
      	    b_Field._View-as = as4dict.p__Field._View-as 
      	    b_Field._Desc = as4dict.p__Field._Desc   
      	    b_Field._Help = as4dict.p__Field._Help
      	    b_Field._Help-SA = as4dict.p__Field._Help-SA
      	    b_Field._dtype = as4dict.p__Field._dtype
      	    b_Field._Format     = as4dict.p__Field._Format
      	    b_Field._Format-SA = as4dict.p__Field._Format-SA
      	    b_Field._Initial    = as4dict.p__Field._Initial 
      	    b_Field._Initial-SA = as4dict.p__Field._Initial-SA
      	    b_Field._Order    	= Last_Order
      	    b_Field._Fld-stlen  = as4dict.p__Field._Fld-stlen         
      	    b_Field._Fld-stdtype = as4dict.p__Field._Fld-stdtype  
      	    b_Field._Fld-misc1[6] = as4dict.p__Field._Fld-misc1[6]
      	    b_Field._Fld-misc2[6] = as4dict.p__Field._Fld-misc2[6]
           b_Field._Fld-misc1[5] = as4dict.p__Field._Fld-misc1[5]
      	    b_Field._For-type = as4dict.p__Field._For-type
      	    b_Field._For-allocated = as4dict.p__Field._For-allocated
      	    b_Field._Decimals = as4dict.p__Field._Decimals.

                /* This define variable and lookup must be done here so that when
                    setdefaults.i is run, the proper string is contained in s_Fld_Dtype
                    for the copied field that is being modified first */
                    
                  def var idxin as integer no-undo.
                  assign idxin = lookup(string(b_Field._Fld-stdtype) ,user_env[14])
                                             s_Fld_DType = entry(idxin, user_env[11]).        

      	 assign
            s_Fld_Array = (if b_Field._Extent > 0 then yes else no)   
      	    s_Fld_Var_Length = (if b_Field._Fld-misc2[4] = "Y" then yes else no)
      	    s_Fld_Protype = b_Field._Data-type
	    s_Fld_Gatetype = b_Field._For-type
	    s_Fld_Typecode = b_Field._dtype.

         IF b_Field._Dtype = 0 THEN DO:
            case s_Fld_Protype:
               when "Character" then s_Fld_Typecode = {&DTYPE_CHARACTER}.
               when "Date"	    then s_Fld_Typecode = {&DTYPE_DATE}.
               when "Logical"   then s_Fld_Typecode = {&DTYPE_LOGICAL}.
               when "Integer"   then s_Fld_Typecode = {&DTYPE_INTEGER}.
               when "Decimal"   then s_Fld_Typecode = {&DTYPE_DECIMAL}.
               when "RECID"	    then s_Fld_Typecode = {&DTYPE_RECID}.
               when "RAW"	    then s_Fld_Typecode = {&DTYPE_RAW}.
             end.
             ASSIGN b_Field._Dtype = s_Fld_Typecode.
         end.

      	 /* Make sensitive/label adjustments to fld-case and _Decimals based
      	    on data type chosen. */
      	    run as4dict/FLD/_dtcust.p 
      	       	(INPUT b_Field._Decimals:HANDLE in frame newfld).
 
     display
	    b_Field._Field-name                   
	    b_Field._For-name
      	    s_Fld_DType
      	    s_Optional
	    b_Field._Format    
	    b_Field._Label     
	    b_Field._Col-label 
	    b_Field._Initial   
	    b_Field._Order  
	    s_Fld_case 	         when s_Fld_Typecode = {&DTYPE_CHARACTER}
	    b_Field._Decimals  	 when s_Fld_Typecode = {&DTYPE_DECIMAL}
	    s_Fld_Mandatory 
      	    s_Fld_Array
	    b_Field._Extent      when b_Field._Extent > 0
            b_Field._Fld-stoff
      	    b_Field._Fld-stlen
	    b_Field._Desc      
	    b_Field._Help                                
	    s_Fld_Null_Capable   /*  Null Field Indicator */
	    s_Fld_Var_Length     /* Variable Length Indicator */      
	    b_Field._For-allocated   
	    b_Field._Fld-Misc2[6]
      	    with frame newfld.                                                      
    
      	 /* Reset the drop down value for data types */
      	 s_lst_Fld_DType:screen-value in frame newfld = CAPS(s_Fld_DType).

      	 /* Reset these for next loop iteration. */                  
      	 find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.    
      	 assign
      	    copytbl = ""
      	    copyfld = "".
      end.
      IF s_Fld_Typecode = {&DTYPE_CHARACTER} THEN
        ASSIGN s_Fld_var_Length:SENSITIVE IN FRAME newfld = YES
                 b_Field._For-allocated:SENSITIVE IN FRAME newfld = YES
                 s_Fld_Case:SENSITIVE IN FRAME newfld = YES.
      ELSE
        ASSIGN s_Fld_var_Length:SENSITIVE IN FRAME newfld = NO
               b_Field._For-allocated:SENSITIVE IN FRAME newfld = NO
               s_Fld_Case:SENSITIVE IN FRAME newfld = NO.

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

