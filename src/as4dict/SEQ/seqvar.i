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

File: seqvar.i

Description:   
   Include file which defines the user interface components for the add
   sequence and edit sequence forms.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/20/92 
    Modified: DLM 01/02/95 Changed to work with PROGRESS/400 Data Dictionary
              DLM 05/08/96 Changed = MS-WINDOWS to BEGINS MS-WIN
----------------------------------------------------------------------------*/


Define {1} buffer b_Sequence for as4dict.p__Seq.

Define {1} frame newseq.    /* for adding a new sequence */
Define {1} frame seqprops.  /* sequence properties */

Define {1} var s_Seq_Limit like _Sequence._Seq-max NO-UNDO.
Define {1} var s_Seq_Cycle_OK as logical NO-UNDO.

/* This is the form for the seqprops and newseq windows. */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   {as4dict/SEQ/seqprop.f  
      &frame_phrase = "frame seqprops NO-BOX 
		       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 19
      &col2 = 21
   }
&ELSE /* Motif */
   {as4dict/SEQ/seqprop.f  
      &frame_phrase = "frame seqprops NO-BOX 
		       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 23
      &col2 = 25
   }
&ENDIF

{as4dict/SEQ/seqprop.f  
   &frame_phrase = "frame newseq view-as DIALOG-BOX TITLE ""Create Sequence""
      	       	    default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1 = 17
   &col2 = 19
}


