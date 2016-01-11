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

File: _fldgate.p

Description:   
   Display and handle the field gateway information dialog box.

Input Parameter:
   p_ReadOnly - The read only flag to check (could be for flds or domains).

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 02/28/92
     History: 07/19/00 D. McMann Added MSS Help
              03/26/01 D. McMann Added format for display of _Fld-misc1[1]
              05/15/01 D. McMann Changed which field was displayed for ODBC

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_ReadOnly as logical NO-UNDO.

Define var db_type as char NO-UNDO.
Define var edbtyp  as char NO-UNDO.
Define var odbtyp  as char NO-UNDO.
Define var proc    as char NO-UNDO.
Define var retval  as char NO-UNDO init "". /* return value */


/*=================================Forms==================================*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 15 {&STDPH_FILL}
   
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame isamfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame isamfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 15 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame ctosfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame ctosfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	LABEL "&Position" FORMAT ">>>>9" colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	LABEL "&Length"   FORMAT ">>>>9" colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-spacing	LABEL "&Array spacing"           colon 16 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-scale	LABEL "&Scaling factor"          colon 16 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame rmsfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rmsfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Position"  	       colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-scale	   LABEL "&Scaling factor"     colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._For-id         LABEL "Field &Id"           colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame rdbfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rdbfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"      colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame oraclefld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame oraclefld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name" colon 19 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"     colon 19 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame sybasefld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame sybasefld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._Fld-stoff	   LABEL "&Position"  	colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stlen	   LABEL "&Length"    	colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._fld-misc2[6]   LABEL "DDS Type"  	colon 15 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame as400fld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE db_type + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame as400fld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}
/*--------------------------------------------------------------------*/

form
   SKIP({&TFM_WID})
   b_Field._For-name       LABEL "Native Field &Name"  colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-stoff	   LABEL "&Column Number"      colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-Misc1[2]	   LABEL "&Scale"  	       colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Field._Fld-misc1[1]   LABEL "&Precision"  FORMAT ">>>>>>>>>9"
    	       colon 20 {&STDPH_FILL}
   SKIP({&VM_WID})
  
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame odbfld
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS
        TITLE edbtyp + " Specific Fields"
        view-as DIALOG-BOX.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame odbfld" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}


/*=================================Triggers==================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame isamfld
   apply "END-ERROR" to frame isamfld.

on window-close of frame ctosfld
   apply "END-ERROR" to frame ctosfld.

on window-close of frame rmsfld
   apply "END-ERROR" to frame rmsfld.

on window-close of frame rdbfld
   apply "END-ERROR" to frame rdbfld.

on window-close of frame oraclefld
   apply "END-ERROR" to frame oraclefld.

on window-close of frame sybasefld
   apply "END-ERROR" to frame sybasefld.

on window-close of frame as400fld
   apply "END-ERROR" to frame as400fld.

on window-close of frame odbfld
   apply "END-ERROR" to frame odbfld.


/*----- HIT of OK BUTTON or GO -----*/
On GO of frame isamfld 	/* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame isamfld b_Field._For-spacing,
       INPUT input frame isamfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame isamfld b_Field._Fld-stoff,
       INPUT input frame isamfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame rmsfld /* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame rmsfld b_Field._For-spacing,
       INPUT input frame rmsfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame rmsfld b_Field._Fld-stoff,
       INPUT input frame rmsfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame rdbfld /* or OK because of AUTO-GO */
do:
   run Validate_Offset 
      (INPUT input frame rdbfld b_Field._Fld-stoff,
       INPUT 0).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.

On GO of frame ctosfld	/* or OK because of AUTO-GO */
do:
   run Validate_Spacing 
      (INPUT input frame ctosfld b_Field._For-spacing,
       INPUT input frame ctosfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.

   run Validate_Offset 
      (INPUT input frame ctosfld b_Field._Fld-stoff,
       INPUT input frame ctosfld b_Field._Fld-stlen).
   if RETURN-VALUE = "error" then return NO-APPLY.
end.


/*----- LEAVE of SCALE -----*/
On leave of b_Field._For-scale in frame rmsfld
do:
   run Validate_Scale (INPUT input frame rmsfld b_Field._For-scale).
   if RETURN-VALUE = "error" then 
      return NO-APPLY.
end.

On leave of b_Field._For-scale in frame rdbfld
do:
   run Validate_Scale (INPUT input frame rdbfld b_Field._For-scale).
   if RETURN-VALUE = "error" then 
      return NO-APPLY.
end.


/*----- HELP -----*/
on HELP of frame isamfld OR choose of s_btn_Help in frame isamfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&CISAM_Specific_Flds__Dlg_Box}, ?).

on HELP of frame ctosfld OR choose of s_btn_Help in frame ctosfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame rmsfld OR choose of s_btn_Help in frame rmsfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame rdbfld OR choose of s_btn_Help in frame rdbfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Gateways_Dlg_Box}, ?).

on HELP of frame oraclefld OR choose of s_btn_Help in frame oraclefld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&ORACLE_Specific_Flds__Dlg_Box}, ?).

on HELP of frame sybasefld OR choose of s_btn_Help in frame sybasefld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&SYBASE_Specific_Flds_Dlg_Box}, ?).

on HELP of frame as400fld OR choose of s_btn_Help in frame as400fld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&AS400_Specific_Flds__Dlg_Box}, ?).

on HELP of frame odbfld OR choose of s_btn_Help in frame odbfld DO:
  IF db_type = "MSS" THEN
    RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&MSS_Specific_Flds_Dlg_Box}, ?).
  ELSE
    RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&ODBC_Specific_Flds_Dlg_Box}, ?).
END.


/*==========================Internal Procedures==============================*/

/*-----------------------------------------------------------------------
   Validate the _Spacing value.

   Input Parameters:
      p_Spacing - the spacing value
      p_Length - the length value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Spacing:

Define INPUT PARAMETER p_Spacing as integer NO-UNDO.
Define INPUT PARAMETER p_Length  as integer NO-UNDO.

   if      b_field._extent > 1
     and ( p_Spacing < p_Length
     or    p_Spacing = ?        )
     then do:
       message "Spacing must be greater than or equal to field length."
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
       return "error".
     end.
     else
       return "ok".
end.


/*-----------------------------------------------------------------------
   Validate the _Scale value.

   Input Parameters:
      p_Scale - the scale value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Scale:

Define INPUT PARAMETER p_Scale as integer NO-UNDO.

   if ( p_Scale <= -10 OR p_Scale >= 50 )
    AND CAN-DO( "Scaled Ubyte,Scaled Uword,"
              + "Scaled Ulong word,Scaled Uquad word"
              , trim(substring(INPUT FRAME fldprops s_Fld_DType,1,20,"character"))
              )
    then do:
     message "Scale must be between -10 and +50 for Scaled Unsigned types."
             view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.

   else if p_Scale <= -127 OR p_Scale >= 127
    then do:
      message "Scale must be between -127 and +127."
               view-as ALERT-BOX ERROR
      	       buttons OK.
      return "error".
     end.
    else return "ok".

end.


/*-----------------------------------------------------------------------
   Validate the Offset value.

   Input Parameters:
      p_Offset - the field offset value
      p_Length - the length value

   Returns:
      "error" or "ok"
-----------------------------------------------------------------------*/
Procedure Validate_Offset:

Define INPUT PARAMETER p_Offset as integer NO-UNDO.
Define INPUT PARAMETER p_Length as integer NO-UNDO.

   find _File where RECID(_File) = s_TblRecId.
   if p_Offset + p_Length > _File._For-Size then 
   do:
      message "The field offset plus the length cannot" SKIP
      	      "be greater than the record size of"
      	       STRING(_File._For-Size) + "."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.
   return "ok".
end.


/*----------------------------------------------------------------------*/
Procedure ISAM_Fld:  /* For CISAM and NETISAM */

Define var modifiable as logical NO-UNDO.
Define var ext        as integer NO-UNDO.
Define var ix         as integer NO-UNDO.

   modifiable = (if NOT s_Adding AND s_Fld_InIndex then no else yes).
   ix = LOOKUP(s_Fld_Gatetype, user_env[12]).

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      with frame isamfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
      	 update s_btn_Cancel s_btn_Help with frame isamfld.
      else do:
      	 ext = (if s_Adding then input frame newfld b_Field._Extent
      	       	     	    else input frame fldprops b_Field._Extent).
      	 set b_Field._Fld-stoff    when modifiable
	     b_Field._Fld-stlen    when modifiable
      	     b_Field._For-spacing  when ext > 0
      	     s_btn_OK 
      	     s_btn_Cancel
      	     s_btn_Help
	     with frame isamfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if modifiable OR ext > 0 then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure CTOSISAM_Fld:

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff 
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      	   with frame ctosfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame ctosfld.
      else do:
	 set  b_Field._Fld-stoff    when s_Adding
	      b_Field._Fld-stlen    when s_Adding AND b_Field._Fld-stlen > 0
	      b_Field._For-spacing  when b_Field._Extent > 0
	      s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame ctosfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if s_Adding OR b_Field._Extent > 0 then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure RMS_Fld:

Define var modifiable as logical NO-UNDO.

   modifiable = (if s_Adding then true else
      	         if NOT s_Fld_InIndex then true else
      	       	 false).

   run adedict/FLD/_dfltgat.p(FALSE).

   display b_Field._Fld-stoff
      	   b_Field._Fld-stlen
      	   b_Field._For-spacing
      	   b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL}
      with frame rmsfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame rmsfld.
      else do:
	 set b_Field._Fld-stoff    when modifiable
	     b_Field._Fld-stlen    when modifiable AND b_Field._Fld-stlen = 0
	     b_Field._For-spacing  when b_Field._Extent > 0
	     b_Field._For-scale    when s_Fld_Typecode = {&DTYPE_DECIMAL}
	     s_btn_OK 
	     s_btn_Cancel
      	     s_btn_Help
	     with frame rmsfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 if (modifiable OR b_Field._Extent > 0 OR 
      	     s_Fld_Typecode = {&DTYPE_DECIMAL}) then
      	    retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure RDB_Fld:

   display b_Field._For-name 
      	   b_Field._Fld-stoff
      	   b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL} AND
      	       	     	           s_Fld_Gatetype <> "quad"
      	       	     	      /* all scaled types + float & double */
      	   b_Field._for-id 
      	   with frame rdbfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame rdbfld.
      else do:
	 set  b_Field._Fld-stoff 
	      b_Field._For-scale when s_Fld_Typecode = {&DTYPE_DECIMAL} AND
      	       	     	              s_Fld_Gatetype <> "quad"
      	       	     	      	 /* all scaled types + float & double */
	      s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame rdbfld.

      	 if NOT s_Adding then
      	    {adedict/setdirty.i &Dirty = "true"}.
      	 retval = "mod".
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure ORACLE_Fld:

   display b_Field._For-name 
      	   b_field._Fld-stoff 
      	   with frame oraclefld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame oraclefld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame oraclefld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure SYBASE_Fld:

   display b_Field._For-name 
      	   b_field._Fld-stoff 
      	   with frame sybasefld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame sybasefld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame sybasefld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure AS400_Fld:

   display b_Field._Fld-stoff 
      	   b_Field._Fld-stlen 
           b_Field._fld-misc2[6]
      with frame as400fld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame as400fld.
      else do:
	 set  s_btn_OK 
	      s_btn_Cancel
      	      s_btn_Help
	      with frame as400fld.
      end.
   end.
end.


/*----------------------------------------------------------------------*/
Procedure ODB_Fld:

   display b_Field._For-name 
      	   b_Field._Fld-stoff 
      	   b_Field._Fld-Misc1[2]
      	   b_Field._Fld-misc1[1]      	  
      	   with frame odbfld.

   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_ReadOnly then
	 update s_btn_Cancel s_btn_Help with frame odbfld.
      else do:
	    set s_btn_OK 
	        s_btn_Cancel
      	    s_btn_Help
	        with frame odbfld.
      end.
   end.
end.


/*==============================Mainline Code================================*/

/* Run the appropriate routine, based on the gateway. */
assign
  db_type = s_DbCache_Type[s_DbCache_ix]
  edbtyp  = {adecomm/ds_type.i
               &direction = "itoe"
               &from-type = "db_type"
               }
  odbtyp  = {adecomm/ds_type.i
               &direction = "ODBC"
               &from-type = "db_type"
               }.

case (db_type):
   when "CISAM" OR
   when "NETISAM" then
      proc = "ISAM_Fld".
   when "CTOSISAM" then
      proc = "CTOSISAM_Fld".
   when "RDB" then
      proc = "RDB_Fld".
   when "RMS" then
      proc = "RMS_Fld".
   when "ORACLE" then
      proc = "ORACLE_Fld".
   when "SYBASE" then
      proc = "SYBASE_Fld".
   when "AS400" then
      proc = "AS400_Fld".
   otherwise
      proc = ( if can-do(odbtyp,db_type)
                 then "ODB_Fld"
                 else ""
                 ).
end.

if proc <> "" then run VALUE(proc).
return retval.




