/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: idxvar.i

Description:   
   Include file which defines the user interface components and related data
   for the add index dialog box.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created:  04/22/92 
     History:  03/26/98 D. McMann Added support for Areas
               06/08/06 fernando  Support for large keys
----------------------------------------------------------------------------*/
Define {1} frame newidx.    /* new index dialog box */
Define {1} frame idxprops.  /* index properties */

	   
/* The variables needed for both add and properties - we also use the 
   b_Index record buffer. */
Define {1} var s_Idx_Primary as logical NO-UNDO.
Define {1} var s_Idx_Abbrev  as logical NO-UNDO.
Define {1} var s_Idx_Word    as logical NO-UNDO.  
Define {1} var s_lst_IdxFlds as char    NO-UNDO. 
Define {1} var index-area-number as integer format ">>>9" INIT 6 NO-UNDO.

/* variables used for Area name select for creating new indexes */
Define {1} var idx-area-name as character format "x(32)" NO-UNDO.
Define button  s_btn_Idx_Area IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_lst_Idx_Area as char view-as  SELECTION-LIST SINGLE   
   INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.



/* Variables needed for the add index dialog only. */
Define {1} var s_lst_IdxFldChoice as char NO-UNDO.

Define button s_btn_IdxFldAdd label "&Add >>"     SIZE 15 by 1.125.
Define button s_btn_IdxFldRmv label "<< &Remove"  SIZE 15 by 1.125.
Define button s_btn_IdxFldDwn label "Move &Down"  SIZE 15 by 1.125.
Define button s_btn_IdxFldUp  label "Move &Up"    SIZE 15 by 1.125.

Define {1} var s_IdxFld_AscDesc as char NO-UNDO
   view-as radio-set horizontal
   radio-buttons "A&scending", "A", "D&escending", "D".

/* Variables needed for index properties only. */
Define {1} var s_txt_List_Labels as char NO-UNDO extent 2.
Define {1} var ActRec as logical no-undo view-as toggle-box.
DEFINE {1} VAR s_msg AS CHAR NO-UNDO.

/* These are the forms for the index properties and new index windows. */
{adedict/IDX/idxprop.f "{1}"}
{adedict/IDX/newidx.f}



