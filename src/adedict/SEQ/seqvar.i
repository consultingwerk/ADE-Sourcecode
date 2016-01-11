/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: seqvar.i

Description:   
   Include file which defines the user interface components for the add
   sequence and edit sequence forms.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/20/92 
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/


Define {1} buffer b_Sequence  for DICTDB._Sequence.

Define {1} frame newseq.    /* for adding a new sequence */
Define {1} frame seqprops.  /* sequence properties */
Define {1} var s_Seq_Type     as   char                      NO-UNDO. 
Define {1} var s_Seq_Limit    like DICTDB._Sequence._Seq-max NO-UNDO.
DEFINE {1} VAR s_Large_Seq_info    AS CHAR                   NO-UNDO.
DEFINE {1} VAR s_Seq_Current_Value AS CHAR                   NO-UNDO.

/* This is the form for the seqprops and newseq windows. */
&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   {adedict/SEQ/seqprop.f  
      &frame_phrase = "frame seqprops NO-BOX 
       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 19
      &col2 = 21
      &prop = 1
   }
&ENDIF

{adedict/SEQ/seqprop.f  
   &frame_phrase = "frame newseq view-as DIALOG-BOX TITLE ""Create Sequence""
                 default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1 = 19
   &col2 = 21
}



