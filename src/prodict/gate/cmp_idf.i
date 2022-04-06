/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
