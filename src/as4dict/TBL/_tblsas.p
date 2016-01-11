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

File: _tblsas.p -table string attributes dialog box

Description:   
   Display and handle the dialog box for specifying string attributes
   for a table.

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 04/05/93 

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{as4dict/TBL/tblvar.i shared}
{as4dict/menu.i shared}

Define var retval as char NO-UNDO init "". /* return value */

FORM
   SKIP({&TFM_WID})
   "String attribute options are:"      at 2 view-as TEXT SKIP
   "T, R, L, C, U and # of characters." at 2 view-as TEXT 
   SKIP({&VM_WIDG})

   b_File._File-Label-SA  colon 22 label "&Label" {&STDPH_FILL} 
   SKIP({&VM_WID})

   b_File._Valmsg-SA	  colon 22 label "&Validation Message" {&STDPH_FILL}
   SKIP({&VM_WID})

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   
   with frame tbl_string_attrs
   SIDE-LABELS 
   DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
   view-as DIALOG-BOX TITLE "Table String Attributes".


/*--------------------------------Triggers-----------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame tbl_string_attrs
   apply "END-ERROR" to frame tbl_string_attrs.


/*---- GO or OK -----*/
on GO of frame tbl_string_attrs
do:
   DO ON ERROR UNDO, LEAVE:
      assign 
	 b_File._File-Label-SA
	 b_File._Valmsg-SA     
	 b_File._Fil-Misc1[1] = b_File._Fil-Misc1[1] + 1
	 b_File._Fil-Res1[8] = 1.
        IF b_File._Fil-res1[7] < 0 then assign b_File._Fil-res1[7] = 0. 
      if NOT s_Adding then
      	 {as4dict/setdirty.i &Dirty = "true"}.
      retval = "mod".
      return.
   END.

   /* error occurred */
   apply "entry" to b_File._File-Label-SA in frame tbl_string_attrs.
   return no-apply.  
end.


/*----- HELP -----*/
on HELP of frame tbl_string_attrs OR 
   choose of s_btn_Help in frame tbl_string_attrs
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", 
      	       	     	     {&AS4_Table_String_Attributes_Dlg_Box}, ?).


/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame tbl_string_attrs" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   /* Do the actual field assignment in GO trigger instead of using 
      update so that if an error occurs, the dialog won't flash.
   */

   display (if b_File._File-Label-SA = ? then "" else b_File._File-Label-SA)
      	       @ b_File._File-Label-SA
      	   (if b_File._Valmsg-SA = ? then "" else b_File._Valmsg-SA) 
      	       @ b_File._Valmsg-SA
      	   with frame tbl_string_attrs.

   enable b_File._File-Label-SA   when NOT s_Tbl_ReadOnly
	  b_File._Valmsg-SA	  when NOT s_Tbl_ReadOnly
      	  s_btn_OK  	      	  when NOT s_Tbl_ReadOnly
      	  s_btn_Cancel
      	  s_btn_Help
      	  with frame tbl_string_attrs.

   wait-for choose of s_btn_OK in frame tbl_string_attrs OR 
      	    GO of frame tbl_string_attrs
      	    focus b_File._File-Label-SA.
end.

hide frame tbl_string_attrs.
return retval.

