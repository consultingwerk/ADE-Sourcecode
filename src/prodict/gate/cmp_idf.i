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

/*--------------------------------------------------------------------

File: prodict/gate/cmp_idf.i

Description:
    
    compares all attributes of an index-Field

    ( only reason for extracting this part from gat_cmp.p is to make
      the code easier to find things )

        
Text-Parameters:
    none

Output-Parameters:
    none
    
Included in:
    gate/_gat_cmp.p

History:
    hutegger    95/03   creation
    
--------------------------------------------------------------------*/        
/*h-*/

    if not available DICTDB._Index-Field
     then assign
       { prodict/gate/cmp_nav.i
              &object = "INDEX-FIELD"
              &obj    = "idx"
              &objm   = "idf"
              &plus   = " + ""/"" + s_ttb_fld.ds_name"
              }

     else do:  /* compare this Index-Field */

     /* SEVERE Differences
      *     Ascending, Order
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Ascending:"
              &msgidx = "l_idf-msg[2]"
              &msgvar = "sev"
              &ns     = "s_ttb_idf.pro_asc"
              &object = "INDEX-FIELD"
              &o-name = "s_ttb_idx.ds_name + ""/"" + s_ttb_fld.ds_name"
              &sh     = "DICTDB._Index-Field._Ascending"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Order:"
              &msgidx = "l_idf-msg[3]"
              &msgvar = "sev"
              &ns     = "s_ttb_idf.pro_order"
              &object = "INDEX-FIELD"
              &o-name = "s_ttb_idx.ds_name + ""/"" + s_ttb_fld.ds_name"
              &sh     = "DICTDB._Index-Field._Index-Seq"
              }

     /* MINOR Differences
      *   Abbreviated
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Abbreviated:"
              &msgidx = "l_idf-msg[4]"
              &msgvar = "min"
              &ns     = "s_ttb_idf.pro_abbr"
              &object = "INDEX-FIELD"
              &o-name = "s_ttb_idx.ds_name + ""/"" + s_ttb_fld.ds_name"
              &sh     = "DICTDB._Index-Field._Abbreviate"
              }

      end.     /* compare this Index-Field */


/*------------------------------------------------------------------*/
