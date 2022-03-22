/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: user-s.i  (table string attributes dialog box)

Description:   
   Display and handle the dialog box for specifying string attributes
   for a table.

Author: Laura Stern

Date Created: 04/05/93 

----------------------------------------------------------------------------*/

FORM
   SKIP(1)
   "String attribute options are:"      at 2 view-as TEXT   SKIP
   "T, R, L, C, U and # of characters." at 2 view-as TEXT   SKIP({&VM_WIDG})

   wfil._File-Label-SA	colon 20 label "Label"    	    SKIP(0.1)
   wfil._Valmsg-SA	colon 20 label "Validation Message" SPACE(1)
   {prodict/user/userbtns.i}
   with frame tbl_string_attrs
   SIDE-LABELS DEFAULT-BUTTON btn_OK
   view-as DIALOG-BOX TITLE "Table String Attributes".

/* Adjust the position of the ok and cancel buttons */
{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME tbl_string_attrs"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}
   

Procedure Tbl_String_Attrs:
   do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF wfil._File-Label-SA = ? THEN wfil._File-Label-SA = "".
      IF wfil._Valmsg-SA = ? THEN wfil._Valmsg-SA = "".

      update wfil._File-Label-SA when romode = 0
	     wfil._Valmsg-SA	 when romode = 0
	     btn_OK  	      	 when romode = 0
	     btn_Cancel
	     with frame tbl_string_attrs.
   end.
   
   hide frame tbl_string_attrs.
end.



