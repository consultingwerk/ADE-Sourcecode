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

File: procvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main procedure editor window.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Donna McMann

Date Created: 04/01/99
----------------------------------------------------------------------------*/

Define {1} buffer   b_Proc          for  as4dict.p__file.


/* The main table properties - mostly we user the record buffer. */
Define var s_AS400_Proc_name as char                    NO-UNDO.
Define var s_AS400_Libr_name  as char                    NO-UNDO.

Define {1} frame newproc.    /* for create procedure dialog box */
Define {1} frame prcprops.   /* procedure properties */

{as4dict/prc/procprop.f  
      &frame_phrase = "frame prcprops NO-BOX 
		       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 18
      &col2 = 20
      &colbtn = 10
   }

{as4dict/prc/procprop.f  
   &frame_phrase = "frame newproc view-as DIALOG-BOX TITLE ""Create Procedure"" 
      	       	   default-button s_btn_OK cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1 = 18
   &col2 = 20
   &colbtn = 4
}



