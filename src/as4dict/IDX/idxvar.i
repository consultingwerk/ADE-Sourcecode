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

File: idxvar.i

Description:   
   Include file which defines the user interface components and related data
   for the add index dialog box.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 04/22/92 
    D. McMann Modified to work with the PROGRESS/400 Data Dictionary
    06/26/97 D. McMann Added word index support

----------------------------------------------------------------------------*/


Define {1} buffer b_Index for as4dict.p__Index. 

Define {1} frame newidx.    /* new index dialog box */
Define {1} frame idxprops.  /* index properties */

/* The variables needed for both add and properties - we also use the 
   b_Index record buffer. */
Define {1} var s_Idx_Primary as logical NO-UNDO.
Define {1} var s_Idx_Abbrev  as logical NO-UNDO.
Define {1} var s_Idx_Unique  as logical NO-UNDO.
Define {1} var s_Idx_Word    as logical NO-UNDO.
Define {1} var s_Idx_Active  as logical NO-UNDO.
Define {1} var s_lst_IdxFlds as char    NO-UNDO. 
Define {1} var word_size     as integer NO-UNDO.



/* Variables needed for the add index dialog only. */
Define {1} var s_lst_IdxFldChoice as char NO-UNDO.

Define button s_btn_IdxFldAdd label "&Add >>"     SIZE 12 by 1.
Define button s_btn_IdxFldRmv label "<< &Remove"  SIZE 12 by 1.
Define button s_btn_IdxFldDwn label "&Move Down"  SIZE 12 by 1.
Define button s_btn_IdxFldUp  label "Move &Up"    SIZE 12 by 1.

Define {1} var s_IdxFld_AscDesc as char NO-UNDO
   view-as radio-set horizontal
   radio-buttons "Ascending", "A", "Descending", "D".

/* Variables needed for index properties only. */
Define {1} var s_txt_List_Labels as char NO-UNDO extent 2.
Define {1} var ActRec as logical no-undo view-as toggle-box.
Define {1} var wordsize      as char format "x(14)" NO-UNDO.

/* These are the forms for the index properties and new index windows. */

{as4dict/IDX/idxprop.f}
{as4dict/IDX/newidx.f}

 
