/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: fldvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main field editor window and its subsidiary dialog boxes.   
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/04/92
    Modified: 06/18/98 Change DTYPE_RAW from 6 to 8 DLM
              05/24/06 fernando Added support int64 datatype
              06/08/06 fernando Added s_btn_toint64
 
----------------------------------------------------------------------------*/


Define {1} buffer   b_Field for _Field. 
Define {1} frame newfld.    /* for create field dialog box */
Define {1} frame fldprops.  /* field properties */


/* The main field properties - mostly we user the record buffer. 
   Note: We can't use the data type or format field of the record buffer 
   as part of a combo box - combo triggers would have to have
   "Using buffer" phrase.  So create a variable for it.
*/
Define button  s_btn_Fld_DType IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_Fld_DType     as char format "x(32)" NO-UNDO.
Define {1} var s_lst_Fld_Dtype as char
   view-as SELECTION-LIST SINGLE  
   INNER-CHARS 32 INNER-LINES 9 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_toint64 LABEL "-> in&t64" {&STDPH_OKBTN}.

DEFINE BUTTON s_btn_lob_Area IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_lob_Area AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_lob_Area AS CHARACTER
      VIEW-AS SELECTION-LIST SINGLE
      INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_cp IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_clob_cp AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_clob_cp AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_col IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} VARIABLE s_clob_col AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE {1} VARIABLE s_lst_clob_col AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE {1} VARIABLE s_lob_size AS CHARACTER FORMAT "x(10)" INITIAL "100M" NO-UNDO.

Define button s_btn_Fld_Format LABEL "&Examples..." SIZE 15 by 1.125.

Define {1} var s_Fld_Array     as logical NO-UNDO.
Define {1} var s_Fld_InIndex   as logical NO-UNDO 
   format "Member of an Index: yes/Member of an Index: no". 
Define {1} var s_Fld_InView    as logical NO-UNDO
   format "Member of a View: yes/Member of a View: no". 

Define button s_btn_Fld_Copy   label "Copy Fiel&d..." SIZE 17 by 1.125.

Define button s_btn_Fld_Triggers    label "Tri&ggers..."     SIZE 17 by 1.125.
Define button s_btn_Fld_Validation  label "Valida&tion..."   SIZE 17 by 1.125.
Define button s_btn_Fld_ViewAs      label "Vie&w-As..."      SIZE 17 by 1.125.
Define button s_btn_Fld_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.125.
Define button s_btn_Fld_Gateway	  label "DataSer&ver..."   SIZE 17 by 1.125.

/* Variable and Frame definition for fields that are BLOBS */
Define button btn_Ok     label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
Define rectangle rect_Btns {&STDPH_OKBOX}.
Define button    btn_Help label "&Help" {&STDPH_OKBTN}.

/*Variable to hold size of LOB fields in bytes */
DEFINE {1} VARIABLE s_lob_wdth       AS DECIMAL            NO-UNDO.

/* This is the form for the field properties and new field windows.    
*/
{adedict/FLD/fldprop.f  
   &frame_phrase = "frame fldprops NO-BOX
		    default-button s_btn_OK cancel-button s_btn_Close"
   &apply_btn    = s_btn_Save
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		    s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
}

{adedict/FLD/fldprop.f  
   &frame_phrase = "frame newfld view-as dialog-box TITLE ""Create Field""
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
&global-define 	  DTYPE_BLOB       18
&global-define 	  DTYPE_CLOB       19 
&global-define 	  DTYPE_XLOB       20 
&global-define 	  DTYPE_DATETM     34
&global-define 	  DTYPE_DATETMTZ   40  
&global-define 	  DTYPE_INT64	   41

/* adjusting of the InView and InIndex fields */
do with frame fldprops:
  assign
    s_Fld_InIndex:x = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InIndex:width-pixels
    s_Fld_InView:x  = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InView:width-pixels.
  end.
do with frame newfld:
  assign
    s_Fld_InIndex:x = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InIndex:width-pixels
    s_Fld_InView:x  = s_btn_Fld_Gateway:x
                    + s_btn_Fld_Gateway:width-pixels
                    - s_Fld_InView:width-pixels.
  end.





