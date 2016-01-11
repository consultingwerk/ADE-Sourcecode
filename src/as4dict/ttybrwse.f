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
/* Progress Lex Converter 7.1A->7.1B Version 1.17 */

/*----------------------------------------------------------------------------

File: browse.f

Description:   
   This file contains the form for the browse frame of the dictionary
   as well as the frame for the icon palette.
 
Author: Laura Stern

Date Created: 01/28/92 

----------------------------------------------------------------------------*/
/*Copyright (c) by PROGRESS SOFTWARE CORPORATION. 1992 - AllRights Reserved.*/


/* Form for browse window */
Form
   SKIP({&TFM_WID})

   s_icn_Dbs         at  2
   s_icn_Tbls        at 20 SPACE({&HM_BTNG})
   s_icn_Seqs                       

   s_icn_Flds        at 58 SPACE({&HM_BTNG})
   s_icn_Idxs       
                   
    s_mod_chg VIEW-AS RADIO-SET 
         RADIO-BUTTONS "Read Only", "Read Only", "Modify Schema", "Modify Schema"  
         AT 75
   SKIP
   
   s_DbLbl           at  2  NO-LABEL format "x(11)" view-as TEXT
   s_TblLbl          at 20  NO-LABEL format "x(9)"  view-as TEXT
   s_SeqLbl    /*      at row-of s_TblLbl col-of s_icn_Seqs   */
                            NO-LABEL format "x(11)" view-as TEXT
   s_FldLbl          at 58  NO-LABEL format "x(9)"  view-as TEXT
   s_IdxLbl       /*   at row-of s_FldLbl col-of s_icn_Idxs  */
   			    NO-LABEL format "x(9)"  view-as TEXT
   SKIP
   

   SKIP({&VM_WIDG})

   s_DbLbl2          at  2  NO-LABEL format "x(15)" view-as TEXT {&STDPH_SDIV}
   s_Lvl1Lbl         at 20  NO-LABEL format "x(34)" view-as TEXT {&STDPH_SDIV}
   s_Lvl2Lbl         at 57  NO-LABEL format "x(34)" view-as TEXT {&STDPH_SDIV}

   SKIP(.2)

   s_DbFill          at  2           format "x(11)" {&STDPH_FILL}
                                     view-as FILL-IN size 15 by 1
   s_TblFill         at 20           format "x(32)" {&STDPH_FILL}
                                     view-as FILL-IN size 34 by 1
   s_SeqFill         at row-of s_TblFill col-of s_TblFill 
                                     format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 34 by 1
   s_FldFill         at 57           format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 34 by 1
   s_IdxFill         at row-of s_FldFill col-of s_FldFill 
                                     format "x(32)"	{&STDPH_FILL}
                                     view-as FILL-IN size 34 by 1

   SKIP(.1)                                     

   s_lst_Dbs         at 2            view-as SELECTION-LIST SINGLE 
                                     size 15 by 5.5 
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Tbls        at 20           view-as SELECTION-LIST SINGLE 
                                     size 34 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Seqs        at row-of s_lst_Tbls col-of s_lst_tbls
                                     view-as SELECTION-LIST SINGLE 
                                     size 34 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Flds        at 57           view-as SELECTION-LIST SINGLE 
                                     size 34 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
   s_lst_Idxs        at row-of s_lst_Flds col-of s_lst_Flds
                                     view-as SELECTION-LIST SINGLE 
                                     size 34 by 5.5
                                     SCROLLBAR-V SCROLLBAR-H
                            SPACE(1) 
   SKIP({&VM_WIDG}) 

   s_btn_Create      at 10  SPACE({&HM_BTN})
   s_btn_Props              SPACE({&HM_BTN})
   s_btn_Delete           

   SKIP(.2)
   s_Browse_Stat     at  2  NO-LABEL format "x(70)" view-as TEXT 
                           
   with frame browse NO-LABELS NO-BOX SCROLLABLE.


/*-------------------------------------------------------------------------

  This was the spacing when we had 3 icons across - tables, domains, seq.-
  in case we re-instate domains some day.

   s_icn_Tbls        at 20
   s_icn_Doms        at 32     
   s_icn_Seqs        at 44       

   SKIP
   
   s_TblLbl          at 20  NO-LABEL format "x(6)" view-as TEXT
   s_DomLbl          at 33  NO-LABEL format "x(5)" view-as TEXT
   s_SeqLbl          at 43  NO-LABEL format "x(9)" view-as TEXT
-----------------------------------------------------------------------*/


