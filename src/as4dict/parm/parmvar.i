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

File: parmvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main parameter editor window and its subsidiary dialog boxes.
   
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Donna McMann

Date Created: 05/04/99
     History: 09/29/99 Changed size of s_btn_Parm_Copy DLM

----------------------------------------------------------------------------*/

Define {1} buffer   b_parm for as4dict.p__field. 
Define {1} frame newparm.    /* for create parameter dialog box */
Define {1} frame parmprops.  /* parameter properties */


Define {1} var s_Parm_DType     as char format "x(32)"  NO-UNDO.  
Define {1} var s_Parm_Type      as char initial "Input" NO-UNDO. 
Define {1} var s_lst_Parm_Dtype as char
   view-as SELECTION-LIST SINGLE  
   INNER-CHARS 32 INNER-LINES 7 SCROLLBAR-VERTICAL.

Define button s_btn_Parm_DType IMAGE-UP FILE "btn-down-arrow".   
Define button s_btn_Parm_Format LABEL "&Examples..." SIZE 15 by 1.
Define button s_btn_Parm_Copy   label "&Copy Parameter..." SIZE 19 by 1.

/* This is the form for the field properties, new field and new
   domain windows. newfld is used for both fields and domains.  We
   can use the same frame for "new" because only one will be displayed
   at a given time - not the case for properties.
*/
{as4dict/parm/parmprop.f  
   &frame_phrase = "frame Parmprops NO-BOX
		    default-button s_btn_OK cancel-button s_btn_Close"
   &apply_btn    = s_btn_Save
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		    s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
}

{as4dict/parm/parmprop.f  
   &frame_phrase = "frame newParm view-as DIALOG-BOX TITLE ""Create Field""
      	       	    default-button s_btn_Add cancel-button s_btn_Done"
   &apply_btn    = s_btn_Add
   &other_btns   = "SPACE({&HM_DBTN}) s_btn_Done"
}

/* Variables to save data type info. */
Define {1} var s_Parm_Gatetype as char  	 NO-UNDO.  /* gate dtype short string */
Define {1} var s_Parm_Protype  as char  	 NO-UNDO.  /* pro dtype string */
Define {1} var s_Parm_Typecode as integer     NO-UNDO.  /* Data type integer code */	

/* Symbolic constants for dtype values of parameters. */
&global-define DTYPE_CHAR   1
&global-define DTYPE_DAT    2
&global-define DTYPE_LOG    3
&global-define DTYPE_INT    4
&global-define DTYPE_DEC    5
&global-define DTYPE_RA     8
&global-define DTYPE_REC    7











