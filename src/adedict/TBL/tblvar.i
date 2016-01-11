/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: tblvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main table editor window.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 03/06/92 
    Modified: 01/19/98 Added variable s_Tbl_Area to hold character value of
                       either the _ianum or N/A for dataserer
                       tables.
              03/26/98 Added variables necessary to create selection list
                       of available areas
----------------------------------------------------------------------------*/


Define {1} buffer   b_File          for  DICTDB._File. 

Define {1} frame newtbl.    /* for create table dialog box */
Define {1} frame tblprops.  /* table properties */

/* The main table properties - mostly we user the record buffer. */
Define {1} var s_Tbl_Type     as char  format "x(20)"   NO-UNDO. 
Define {1} var s_Tbl_IdxCnt   as integer format ">>>9"  NO-UNDO.

Define {1} var file-area-number as integer format ">>>9" init 6 NO-UNDO.

Define button s_btn_Tbl_Triggers    label "Tri&ggers..."     SIZE 17 by 1.125.
Define button s_btn_Tbl_Validation  label "Valida&tion..."   SIZE 17 by 1.125.
Define button s_btn_Tbl_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.125.
Define button s_btn_Tbl_ds          label "DataSer&ver..."   SIZE 17 by 1.125.

Define button  s_btn_File_Area IMAGE-UP FILE "btn-down-arrow".
Define {1} var s_Tbl_Area     as char  format "x(32)"  NO-UNDO.
Define {1} var s_lst_File_Area as char view-as  SELECTION-LIST SINGLE   
   INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

/* These are the forms for the table properties and new table windows. */
&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   {adedict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &ds_btn     = "SPACE({&HM_BTN}) s_btn_Tbl_ds"
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1       = 18
      &col2       = 20
      &colbtn     = 4.5
   }
&ELSE /* motif */
   {adedict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &ds_btn     = "SPACE({&HM_BTN}) s_btn_Tbl_ds"
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1       = 20
      &col2       = 22
      &colbtn     = 2
   }
   
&ENDIF

{adedict/TBL/tblprop.f  
   &frame_phrase = "frame newtbl view-as DIALOG-BOX TITLE ""Create Table"" 
                default-button s_btn_OK cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &ds_btn     = "   "
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1       = 18
   &col2       = 20
   &colbtn     = 4
}

/* Symbolic constants */

/* for file number (_File-Number) values. */
&global-define   TBLNUM_FASTTRK_START   -29
&global-define   TBLNUM_FASTTRK_END     -7

define variable odbtyp   as character no-undo.

assign
  odbtyp = {adecomm/ds_type.i
              &direction = "odbc"
              &from-type = "odbtyp"
           }.
/*----------------------------------------------------------------*/
