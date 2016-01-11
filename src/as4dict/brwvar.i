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

File: brwvar.i

Description:   
   Include file which defines the user interface components in the browse
   window of the dictionary.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 01/28/92 
     Modified: DLM 01/02/95 Modified to work with Progress/400 Data Dictionary
               DLM 05/08/96 Changed = MS-WINOWS to BEGINS MS-WIN
               DLM 03/30/99 Added stored procedure support

----------------------------------------------------------------------------*/

Define {1} frame browse.

/* Toggling icons for selecting which object type is current. */
Define image s_icn_Dbs    FILE "adeicon/db-u".
Define image s_icn_Tbls   FILE "adeicon/table-u".
Define image s_icn_Proc   FILE "adeicon/asproc-u". 
Define image s_icn_Seqs   FILE "adeicon/seq-u".
Define image s_icn_Flds   FILE "adeicon/flds-u".
Define image s_icn_Idxs   FILE "adeicon/index-u". 
Define image s_icn_Parm   FILE "adeicon/asparm-u".    

/* Radio Set to know if user wants to do schema changes */
Define {1} var s_mod_chg  as character initial "Read Only" NO-UNDO.

/* Labels for toggling icons */
Define {1} var s_DbLbl   as char NO-UNDO init "Database".
Define {1} var s_TblLbl  as char NO-UNDO init "Table".
Define {1} var s_ProcLbl as char NO-UNDO init "Procedure". 
Define {1} var s_SeqLbl  as char NO-UNDO init "Sequence".
Define {1} var s_FldLbl  as char NO-UNDO init "Field".
Define {1} var s_IdxLbl  as char NO-UNDO init "Index".    
Define {1} var s_ParmLbl as char NO-UNDO init "Parameter".


/* Label for each level of object to indicate what is being displayed. */
Define {1} var s_DbLbl2  as char NO-UNDO init " Databases".
Define {1} var s_Lvl1Lbl as char NO-UNDO.
Define {1} var s_Lvl2Lbl as char NO-UNDO.

/* Fill-in fields for searching through selection lists */
Define {1} var s_DbFill   as char NO-UNDO.
Define {1} var s_TblFill  as char NO-UNDO.
Define {1} var s_ProcFill as char NO-UNDO. 
Define {1} var s_SeqFill  as char NO-UNDO.
Define {1} var s_FldFill  as char NO-UNDO.
Define {1} var s_IdxFill  as char NO-UNDO.
Define {1} var s_ParmFill as char NO-UNDO.

/* Selection Lists for the lists of database objects. The view-as and size
   specifications are in the form (in browse.f) so that all formatting is
   done in one place.
*/
Define {1} var s_lst_Dbs  as char NO-UNDO.
Define {1} var s_lst_Tbls as char NO-UNDO.
Define {1} var s_lst_Proc as char NO-UNDO. 
Define {1} var s_lst_Seqs as char NO-UNDO.
Define {1} var s_lst_Flds as char NO-UNDO.
Define {1} var s_lst_Idxs as char NO-UNDO.
Define {1} var s_lst_Parm as char NO-UNDO.

/* Action buttons to perform Create, Modify and Delete operations. The
   labels on these will change depending on the current object.  So
   for example, it s_btn_Create might say "Create Table" or "Create Index".
*/
Define button s_btn_Create SIZE 24 by 1.
Define button s_btn_Props  SIZE 24 by 1.
Define button s_btn_Delete SIZE 24 by 1.

/* Status line variable */
Define {1} var s_Browse_Stat as char NO-UNDO.
 
{as4dict/browse.f}







