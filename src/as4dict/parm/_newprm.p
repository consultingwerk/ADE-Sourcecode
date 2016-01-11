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

File: _newprm.p

Description:
   Add parameter procedure.

Author: Donna McMann

Date Created: 05/04/99 
     History: 09/09/99 D. McMann Added logic to check field name, assign
                       parameter as4-name to be PARM_#.
              09/06/02 D. McMann how the foreign name was being calculated has the
                       potential of having duplicate names changed to use p__file.num-flds.
                      
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/parm/parmvar.i shared}
{as4dict/capab.i}


Define var Last_Order as integer initial ?.
Define var Record_Id  as recid              NO-UNDO.  /* table record Id */
Define var Copy_Hit   as logical init false NO-UNDO.  /* Flag - was copy hit? */
Define var IsPro      as logical            NO-UNDO.  /* true if db is Prog. */
Define var copied     as logical            NO-UNDO.  
Define var added      as logical init no    NO-UNDO.
DEFINE VAR last-parm  AS LOGICAL INIT NO    NO-UNDO.


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

   Get the list of data types appropriate parameters
----------------------------------------------------------------------------*/
PROCEDURE SetDataTypes:

Define var types   as character NO-UNDO.
Define var num     as integer   NO-UNDO.
Define var as4type as character NO-UNDO.
Define var protype as character NO-UNDO.
 
  /* Compose a string to pass to list-items function where each entry
     is a data type that looks like "xxxx (yyyy)" where
     xxxx is the gateway type and yyyy is the progress type
     that it maps to.
  */
  

  ASSIGN types = ""
         as4type = "Character Alpha      ,Zoned numeric        ,Packed decimal      ,Pckd (even digits)   ,Short Integer        ,Long Integer         ,Logical              "
         protype = "Character,Decimal,Decimal,Decimal,Integer,Integer,Logical".
  do num = 1 to NUM-ENTRIES(as4type):
    types = types + (if num = 1 then "" else ",") +
            STRING(ENTRY(num, as4type), "x(21)") + 
      	     "(" + ENTRY(num, protype) + ")".
  end.
  num = num - 1.  /* undo terminating loop iteration */
                      
   s_lst_Parm_DType:list-items in frame newparm = types.
   s_lst_Parm_DType:inner-lines in frame newparm =  (if num <= 10 then num else 10).
end.


/*----------------------------------------------------------------------------
   SetDefaults

   Set default values based on the chosen data type.  Display all new values.
   
   When we get domains:
   Copy the values from an existing domain into the display variables for 
   the new field or domain.  Display all new values.

   Output
      s_Parm_Protype  - Progress data type string
      s_Parm_Typecode - The underlying integer data type (dtype field) 
      s_Parm_Gatetype - The gateway type
--------------------------------------------------------------------------*/
Procedure SetDefaults:

{  as4dict/parm/setdflts.i &Frame = "frame newparm"} 

 IF s_Parm_TypeCode = {&DTYPE_DEC} THEN
     ASSIGN b_parm._Fld-Misc1[5]:screen-value IN FRAME newparm = string(b_parm._fld-Misc1[5])
            b_parm._Decimals:screen-value IN FRAME newparm =  string(b_parm._Decimals).  
   ELSE
     ASSIGN b_parm._Fld-Misc1[5]:screen-value IN FRAME newparm = string(b_parm._fld-Stlen)
            b_parm._Decimals:screen-value IN FRAME newparm =  " ". 

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

   { as4dict/parm/as4stlen.i   &input_phrase = "input frame newparm" &prefix = "b_Parm" }
 
 end. /* Procedure Set_Stlen.  */
/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newparm    
  do:
    clear frame newparm all.
   apply "END-ERROR" to frame newparm.
end.

/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newparm
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD BUTTON or GO -----*/
on GO of frame newparm	/* or Create because it's auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var obj      as char    NO-UNDO.
   Define var ins_name as char    NO-UNDO.
   Define var ix       as integer NO-UNDO.
   Define var forname  as char    NO-UNDO.
   Define var p_name   as char    NO-UNDO.
   Define var okay     as logical NO-UNDO.
   Define var lngth    as integer NO-UNDO.
   Define var i        as integer NO-UNDO.
   
   obj = "parameter".

   run as4dict/_blnknam.p
      (INPUT b_Parm._Field-name:HANDLE in frame newparm,
       INPUT obj, OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").              
        
      IF b_Parm._Fld-stdtype = 35 THEN 
	ASSIGN b_Parm._Fld-Misc1[5] = 4.  
 
      ELSE IF b_Parm._Fld-stdtype = 36 THEN 
                ASSIGN b_Parm._Fld-Misc1[5] = 9.      

                    
      ASSIGN  b_Parm._File-recid = Record_Id 
	          b_Parm._Data-Type = s_Parm_Protype      	
              b_Parm._For-type = s_Parm_Gatetype
              b_Parm._Dtype = s_Parm_Typecode
     	      b_Parm._For-name = CAPS(p_name)
      	      input frame newparm b_Parm._Format
	          input frame newparm b_Parm._Field-Name
	          input frame newparm b_Parm._Initial	    
	          input frame newparm b_Parm._Order 
	          b_Parm._Fld-Misc2[2] = "Y"           
	          input frame newparm b_Parm._Desc       
	          b_Parm._File-number = s_ProcForNo
	          b_Parm._Can-Read = "*"
	          b_Parm._Can-Write = "*"
	          b_Parm._Fld-case = "N"
	          b_Parm._Mandatory = "N"
	          b_Parm._Fld-Misc2[5] = "B".
  
      /* Fill the As4-File and AS4-Library Fields from our selected table.  Must
           refind the file in case the user has selected copy field and table in
           buffer is not table we are working with.    */  
       find as4dict.p__File where as4dict.p__File._File-number = s_ProcForNo.
         IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0. 
        assign 
            b_Parm._AS4-File = as4dict.p__File._AS4-File
            b_Parm._AS4-Library = as4dict.p__File._AS4-Library   
            as4dict.p__File._Fil-Res1[8] = 1
            as4dict.p__file._numfld = as4dict.p__File._numfld + 1   
            b_parm._for-name = "PARM_" + STRING(as4dict.p__File._numfld).
    
        IF as4dict.p__File._numfld = 32 THEN DO:
          MESSAGE "Stored procedures can only have 32 parameters." SKIP
                  "Therefore, this will be last parameter to be created." SKIP
             VIEW-AS ALERT-BOX INFORMATION.
           ASSIGN last-parm = TRUE.
        END.

        IF SUBSTRING(as4dict.p__File._Fil-misc2[4],3,1) = "N" 
               AND b_Parm._Fld-misc2[2] = "Y" THEN
          ASSIGN SUBSTRING(as4dict.p__File._Fil-misc2[04],3,1) = "Y".  
            
        IF SUBSTRING(as4dict.p__File._Fil-misc2[5],1,1) <> "Y" THEN
          ASSIGN SUBSTRING(as4dict.p__File._fil-misc2[5],1,1) = "Y".                  

        IF b_Parm._Dtype = 0 THEN DO:
              case s_Parm_Protype:
                   when "Character" then s_Parm_Typecode = {&DTYPE_CHAR}.
                   when "Logical"   then s_Parm_Typecode = {&DTYPE_LOG}.
                   when "Integer"   then s_Parm_Typecode = {&DTYPE_INT}.
                   when "Decimal"   then s_Parm_Typecode = {&DTYPE_DEC}.
               end.
               ASSIGN b_Parm._Dtype = s_Parm_Typecode.
       end.    
       
      Last_Order = b_Parm._Order.
      
      IF s_Parm_Type:screen-value = "INPUT" THEN
        ASSIGN b_Parm._Fld-misc1[2] = 1.
      ELSE IF s_Parm_Type:screen-value = "OUTPUT" THEN
        ASSIGN b_Parm._Fld-misc1[2] = 3.
      ELSE
        ASSIGN b_Parm._Fld-misc1[2] = 2.    

      /* Add entry to appropriate list in the correct order */
      if s_CurrObj = {&OBJ_Parm} then
      	 run as4dict/parm/_ptinlst.p (INPUT b_Parm._Field-Name,
      	       	     	      	     INPUT b_Parm._Order).


      {as4dict/setdirty.i &Dirty = "true"}
      display "Parameter Created" @ s_Status with frame newparm.
      added = yes.                                       
      run adecomm/_setcurs.p ("").                   
      return.
   end.

   /* Will only get here if there's an error. */
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.
end.

/*----- LEAVE of NAME FIELD ----- */
on leave of b_Parm._Field-Name in frame newparm                
do:
   Define var okay     as logical.
   Define var name     as char.
   Define var aname    as char.
   Define var win      as widget-handle.

   win =  s_win_Parm.
   run as4dict/_leavnam.p (INPUT  b_Parm._Field-Name:screen-value IN FRAME newparm, 
                           INPUT win, 
                           INPUT b_Parm._Fld-number,
                           INPUT {&OBJ_PARM},
                           OUTPUT name, 
                           OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.   
end.


/*----- LEAVE of DATA TYPE FIELD -----*/
on U1 of s_Parm_DType in frame newparm, 
      	 s_lst_Parm_DType in frame newparm
do:   
   run SetDefaults.  /* sets s_Parm_Typecode */  

   IF s_Parm_TypeCode = {&DTYPE_DEC} THEN
     ASSIGN b_parm._Fld-Misc1[5]:screen-value IN FRAME newparm = string(b_parm._fld-Misc1[5])
            b_parm._Decimals:screen-value IN FRAME newparm = string(b_parm._Decimals).  
   ELSE
     ASSIGN b_parm._Fld-Misc1[5]:screen-value IN FRAME newparm = string(b_parm._fld-Stlen)
            b_parm._Decimals:screen-value IN FRAME newparm =  "".

end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Parm._Format in frame newparm 
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format.   */         
 
   run as4dict/parm/_dfltfmt.p   
      (INPUT b_Parm._Format:HANDLE in frame newparm,
       INPUT b_Parm._Initial:HANDLE in frame newparm,
       INPUT false).           
          
   /* Once there's a value in the format field, set the length 
      for character and decimal datatypes, which has to be based
      on the format.  Logical, Integer, and Date datatypes have
      been already in Set_Defaults. */          
   
   if ((s_Parm_TypeCode = {&DTYPE_CHAR}) or
      (s_Parm_TypeCode = {&DTYPE_DEC})) AND
      s_Parm_Typecode < 79 then  DO:           
     run Set_Stlen.  

     IF s_Parm_TypeCode = {&DTYPE_DEC} THEN
       ASSIGN b_parm._Fld-Misc1[5]:SCREEN-VALUE in frame newparm = string(b_parm._fld-Misc1[5])
              b_parm._Decimals:SCREEN-VALUE in frame newparm = string(b_parm._Decimals).  
     ELSE
        ASSIGN b_parm._Fld-Misc1[5]:SCREEN-VALUE in frame newparm = string(b_parm._fld-Stlen)
               b_parm._Decimals:screen-value in frame newparm =  "".
                                           
   END.
   if  (s_Parm_TypeCode = {&DTYPE_INT}) THEN DO:  
        run Set_Stlen.  
        ASSIGN b_Parm._Fld-Misc1[5]:SCREEN-VALUE in frame newparm = ""
               b_Parm._Decimals:SCREEN-VALUE in frame newparm = "".
   END.
        
   /* Validate that user has not entered a format which will result
      in a sync error for being zero length. */     
      
   if  b_Parm._Format:Screen-value = "0" then do:
        message "Value cannot be displayed using" b_Parm._Format:Screen-value SKIP
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
   END.     
end.         


/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Parm_Format in frame newparm
do:
   Define var fmt as char NO-UNDO.

   /* Allow user to pick a different format from examples */
   fmt = input frame newparm b_Parm._Format.
   run as4dict/FLD/_fldfmts.p (INPUT s_Parm_Typecode, INPUT-OUTPUT fmt).
   
   b_Parm._Format:SCREEN-VALUE in frame newparm = fmt.   
 
end.

/*----- HIT of COPY BUTTON -----*/
on choose of s_btn_Parm_Copy in frame newparm
do:
   /* Flag that copy was hit.  The add wait-for will break and we'll
      call the copy program from there.  We must do this so that pressing
      Done after copy will not undo the addition of the copied fields.
   */
   Copy_Hit = true.
end.


/*----- HELP -----*/
on HELP of frame newparm OR choose of s_btn_Help in frame newparm
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Create_Field_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var msg     as char NO-UNDO.
Define var copyproc as char NO-UNDO init "".
Define var copyparm as char NO-UNDO init "".

find as4dict.p__File where as4dict.p__File._File-number = s_ProcForNo.   
IF as4dict.p__File._numfld = 32 THEN DO:
    MESSAGE "Stored procedures can only have 32 parameters. " SKIP
            "Therefore, you can not create any more parameters " SKIP
            "for this procedure." SKIP
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.


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

/* Set dialog box title to show which table this field will belong to. */
frame newparm:title = "Create Parameter for Procedure " + s_CurrProc.

/* Set the record id of the procedure that this parameter will belong to. */

Record_Id =  s_ProcForNo.
IsPro = {as4dict/ispro.i}.

assign   
   s_btn_Parm_Copy:hidden in frame newparm = no    
   b_Parm._Order:hidden in frame newparm = no.
      
{as4dict/parm/dtwidth.i &Frame = "Frame newparm" &Only1 = "FALSE"}

/* Run time layout for button area.  This defines eff_frame_width 
   Since this is a shared frame we have to avoid doing this code 
   more than once.
*/
if frame newparm:private-data <> "alive" then
do:
   frame newparm:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newparm" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Parm._Desc:RETURN-INSERT in frame newparm = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame newparm = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Fill data type combo box based on the gateway */
run SetDataTypes.
{adecomm/cbdrop.i &Frame  = "frame newparm"
      	       	  &CBFill = "s_Parm_DType"
      	       	  &CBList = "s_lst_Parm_DType"
      	       	  &CBBtn  = "s_btn_Parm_DType"
     	       	  &CBInit = """"}

/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newparm.
s_btn_Done:label in frame newparm = "Cancel".

enable b_Parm._Field-Name  
       s_btn_Parm_Copy                    
       s_Parm_DType          
       s_btn_Parm_DType
       b_Parm._Format      
       s_btn_Parm_Format  
       s_Parm_type                     
       b_Parm._Initial
       b_Parm._Order 	         	       	     	      	              
       b_Parm._Desc
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newparm.

/* The rule is ENABLE effects the TAB order but x:SENSITIVE = yes does not. 
   Now readjust tab orders for stuff not in the ENABLE set but
   which may, in fact be sensitive at some point during this .p.
*/
assign
   s_Res = s_lst_Parm_DType:move-after-tab-item
      	       (s_btn_Parm_DType:handle in frame newparm) in frame newparm  	       
   .
   
/* Each add will be a subtransaction. */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.
   IF last-parm THEN LEAVE add_subtran.

   if added AND s_btn_Done:label in frame newparm <> "Close" then
      s_btn_Done:label in frame newparm = "Close".

   if Copy_Hit then
   do:
      /* This will copy fields and end the sub-transaction so that "Done" 
      	 will not undo it. */
      Copy_Hit = false.  /* reset flag */                                    

      run as4dict/parm/_prmcopy.p (INPUT-OUTPUT Last_Order,
      	       	     	      	 OUTPUT copyproc, OUTPUT copyparm,
      	       	     	      	 OUTPUT copied).  
   	       	     	      	 
      if copied then 
      do:
      	 display "Copy Completed" @ s_Status with frame newparm.
      	 added = yes.
      end.
   end.
   else do:          
    
      create b_Parm.
      ASSIGN  b_Parm._File-number = as4dict.p__file._File-number
	      b_Parm._Fld-number =  (as4dict.p__File._Fil-res1[5] + 1)        
             b_Parm._For-id =   b_Parm._Fld-number     
             as4dict.p__file._Fil-Res1[5] = (as4dict.p__file._Fil-Res1[5] + 1).

	      
      /* default  to a unique order # */

       find LAST as4dict.p__Field USE-INDEX p__FieldL0
	    where as4dict.p__Field._File-number = s_ProcForNo NO-ERROR.
        Last_Order = (if AVAILABLE as4dict.p__Field then 
	                    as4dict.p__Field._Order + 10 else 10).	


      if copyproc = "" then
      do:
      	 /* This is a brand new field */

	 b_Parm._Order = Last_Order.
    
	 /* Set defaults based on the current data type (either the first
	    in the list or whatever was chosen last time).
	 */
	 run SetDefaults.
    
      	 /* Display any remaining attributes */
	 display "" @ b_Parm._Field-Name /* blank instead of ? */
      	       	 s_Optional		 
		 b_Parm._Desc 
		 b_Parm._Order		     	 
		 with frame newparm.
      end.
      else do:                                  

      	 /* Set the field values based on a field chosen as a template
      	    in the Copy dialog box.
      	 */
      	 find as4dict.p__File where as4dict.p__File._File-name = copyproc.
      	 find as4dict.p__Field where as4dict.p__Field._File-number = as4dict.p__File._File-number
      	                         and as4dict.p__Field._Field-name = copyparm.  
      	                         
      	 assign
      	    b_Parm._Field-name = as4dict.p__Field._Field-name
      	    b_Parm._For-name   = as4dict.p__Field._For-name
      	    b_Parm._Data-type  = as4dict.p__Field._Data-type 
      	    b_Parm._Label = as4dict.p__Field._Label
      	    b_Parm._Label-SA = as4dict.p__Field._Label-SA
      	    b_Parm._Col-Label = as4dict.p__Field._Col-label
      	    b_Parm._Col-Label-SA = as4dict.p__Field._Col-Label-SA
      	    b_Parm._Valexp = as4dict.p__Field._Valexp
      	    b_Parm._Valmsg = as4dict.p__Field._Valmsg
      	    b_Parm._Valmsg-SA = as4dict.p__Field._Valmsg-SA
      	    b_Parm._View-as = as4dict.p__Field._View-as 
      	    b_Parm._Desc = as4dict.p__Field._Desc   
      	    b_Parm._Help = as4dict.p__Field._Help
      	    b_Parm._Help-SA = as4dict.p__Field._Help-SA
      	    b_Parm._dtype = as4dict.p__Field._dtype
      	    b_Parm._Format     = as4dict.p__Field._Format
      	    b_Parm._Format-SA = as4dict.p__Field._Format-SA
      	    b_Parm._Initial    = as4dict.p__Field._Initial 
      	    b_Parm._Initial-SA = as4dict.p__Field._Initial-SA
      	    b_Parm._Order    	= Last_Order
      	    b_Parm._Fld-stlen  = as4dict.p__Field._Fld-stlen         
      	    b_Parm._Fld-stdtype = as4dict.p__Field._Fld-stdtype  
      	    b_Parm._Fld-misc1[6] = as4dict.p__Field._Fld-misc1[6]
      	    b_Parm._Fld-misc2[6] = as4dict.p__Field._Fld-misc2[6]
           b_Parm._Fld-misc1[5] = as4dict.p__Field._Fld-misc1[5]
      	    b_Parm._For-type = as4dict.p__Field._For-type
      	    b_Parm._For-allocated = as4dict.p__Field._For-allocated
      	    b_Parm._Decimals = as4dict.p__Field._Decimals.

                /* This define variable and lookup must be done here so that when
                    setdefaults.i is run, the proper string is contained in s_Parm_Dtype
                    for the copied field that is being modified first */
                    
                  def var idxin as integer no-undo.
                  assign idxin = lookup(string(b_Parm._Fld-stdtype) ,user_env[14])
                                             s_Parm_DType = entry(idxin, user_env[11]).        

      	 assign            
      	    s_Parm_Protype = b_Parm._Data-type
	    s_Parm_Gatetype = b_Parm._For-type
	    s_Parm_Typecode = b_Parm._dtype.

         IF b_Parm._Dtype = 0 THEN DO:
            case s_Parm_Protype:
               when "Character" then s_Parm_Typecode = {&DTYPE_CHAR}.
               when "Logical"   then s_Parm_Typecode = {&DTYPE_LOG}.
               when "Integer"   then s_Parm_Typecode = {&DTYPE_INT}.
               when "Decimal"   then s_Parm_Typecode = {&DTYPE_DEC}.
             end.
             ASSIGN b_Parm._Dtype = s_Parm_Typecode.
         end.

      	 display
	    b_Parm._Field-name                   	    
      	    s_Parm_DType
      	    s_Optional
	    b_Parm._Format    	     
	    b_Parm._Initial   
	    b_Parm._Order  	   
	    b_Parm._Desc      	   
      	    with frame newparm.                                                      
    
      	 /* Reset the drop down value for data types */
      	 s_lst_Parm_DType:screen-value in frame newparm = CAPS(s_Parm_DType).

      	 /* Reset these for next loop iteration. */                  
      	 find as4dict.p__File where as4dict.p__File._File-number = s_ProcForNo.    
      	 assign
      	    copyproc = ""
      	    copyparm = "".
      end.

      wait-for choose of s_btn_OK in frame newparm,
      	       	     	 s_btn_Add in frame newparm,
      	       	     	 s_btn_Parm_Copy in frame newparm OR
      	       GO of frame newparm
      	       FOCUS b_Parm._Field-Name in frame newparm.

      /* Undo the create of b_Parm
      so that when we repeat we don't end up
	 with a bogus field with all unknown values. */
      if Copy_Hit then
	 undo add_subtran, next add_subtran.
   end.
end.

hide frame newparm. 
return.



