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

File: fldvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main field editor window and its subsidiary dialog boxes.
   Since domains and fields are essentially the same, this is used for
   domains as well.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/04/92 
    Modified: 06/18/98 Changed DTYPE_RAW from 6 to 8 D. McMann
----------------------------------------------------------------------------*/

Define {1} buffer   b_Field for as4dict.p__field. 

Define {1} frame newfld.    /* for create field/domain dialog box */
Define {1} frame fldprops.  /* field properties */

/* The main field properties - mostly we user the record buffer. 
   Note: We can't use the data type or format field of the record buffer 
   as part of a combo box - combo triggers would have to have
   "Using buffer" phrase.  So create a variable for it.
*/
Define button  s_btn_Fld_DType IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_Fld_DType     as char format "x(32)" NO-UNDO.
Define {1} var s_Fld_Var_Length as Logical NO-UNDO.  
Define {1} var s_Fld_Null_Capable as Logical NO-UNDO.
Define {1} var s_Fld_Mandatory as logical NO-UNDO.
Define {1} var s_Fld_Case as logical NO-UNDO.    
Define {1} var s_lst_Fld_Dtype as char
   view-as SELECTION-LIST SINGLE  
   INNER-CHARS 32 INNER-LINES 7 SCROLLBAR-VERTICAL.
   
Define button s_btn_Fld_Format LABEL "&Examples..." SIZE 15 by 1.

Define {1} var s_Fld_Array     as logical NO-UNDO.
Define {1} var s_Fld_InIndex   as logical NO-UNDO 
   format "Member of an Index: yes/Member of an Index: no". 
Define {1} var s_Fld_InView    as logical NO-UNDO
   format "Member of a View: yes/Member of a View: no". 

Define button s_btn_Fld_Copy   label "&Copy Field..." SIZE 17 by 1.

Define button s_btn_Fld_Triggers    label "&Triggers..."     SIZE 17 by 1.
Define button s_btn_Fld_Validation  label "&Validation..."   SIZE 17 by 1.
Define button s_btn_Fld_ViewAs      label "Vie&w-As..."      SIZE 17 by 1.
Define button s_btn_Fld_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.
Define button s_btn_Fld_Gateway	    label "&DataServer..."   SIZE 17 by 1.


{as4dict/FLD/fldprop.f  
   &frame_phrase = "frame fldprops NO-BOX
		    default-button s_btn_OK cancel-button s_btn_Close"
   &apply_btn    = s_btn_Save
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		    s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
}

{as4dict/FLD/fldprop.f  
   &frame_phrase = "frame newfld view-as DIALOG-BOX TITLE ""Create Field""
      	       	    default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn    = s_btn_Add
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Done"
}


/* Variables to save data type info. */
Define {1} var s_Fld_Gatetype as char  	 NO-UNDO.  /* gate dtype short string */
Define {1} var s_Fld_Protype  as char  	 NO-UNDO.  /* pro dtype string */
Define {1} var s_Fld_Typecode as integer NO-UNDO.  /* Data type integer code */	

/* Field capabilities to handle gateways properly. */
Define {1} var s_Fld_Capab as char NO-UNDO.

/* Symbolic constants for dtype values. */
&global-define 	  DTYPE_CHARACTER   1
&global-define 	  DTYPE_DATE  	    2
&global-define 	  DTYPE_LOGICAL     3
&global-define 	  DTYPE_INTEGER	    4
&global-define 	  DTYPE_DECIMAL	    5
&global-define 	  DTYPE_RAW   	    8
&global-define 	  DTYPE_RECID 	    7







