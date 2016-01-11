/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/cmp_idx.i

Description:
    
    compares all attributes of an index

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
    mcmann   06/04/02   Added output to file logic
--------------------------------------------------------------------*/        
/*h-*/

    if not available DICTDB._Index
     then assign
       { prodict/gate/cmp_nav.i
              &object = "INDEX"
              &obj    = "idx"
              &objm   = "idx"
              }

     else do:  /* compare this Index */

     /* severe Differences in INTERNAL info
      *     index-number
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Index number:"
              &msgidx = "l_idx-msg[2]"
              &msgvar = "int"
              &ns     = "s_ttb_idx.pro_idx#"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._Idx-num"
              }

     /* Differences in RETAINABLE info
      *   PROGRESS name, unique, desription
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Name in {&PRO_DISPLAY_NAME}:"
              &msgidx = "l_idx-msg[4]"
              &msgvar = "reti"
              &ns     = "s_ttb_idx.pro_name"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._Index-Name"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Unique:"
              &msgidx = "l_idx-msg[5]"
              &msgvar = "reti"
              &ns     = "s_ttb_idx.pro_uniq"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._Unique"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Description:"
              &msgidx = "l_idx-msg[6]"
              &msgvar = "reti"
              &ns     = "s_ttb_idx.pro_desc"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._Desc"
              }

     /* MINOR Differences
      *     active, RECID-Usability
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Activ:"
              &msgidx = "l_idx-msg[3]"
              &msgvar = "min"
              &ns     = "s_ttb_idx.pro_actv"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._Active"
              }
      if DICTDB._index._I-misc2[1] begins "r"
       then do:
        if can-find(s_ttb_idx1
              where s_ttb_idx1.ttb_tbl   =  s_ttb_idx.ttb_tbl
              and   s_ttb_idx1.hlp_level <  s_ttb_idx.hlp_level)
         then assign
              l_min-msg = l_min-msg + "    INDEX "
                 + s_ttb_idx.ds_name + ": Usability for ROWID index:" 
                 + chr(10) + chr(9)
                 + l_msg[l_idx-msg[7]] + chr(10).
        end.
       else { prodict/gate/cmp_msg.i
              &attrbt = "Usability for ROWID index:"
              &msgidx = "l_idx-msg[8]"
              &msgvar = "min"
              &ns     = "s_ttb_idx.ds_msc21"
              &object = "INDEX"
              &o-name = "s_ttb_idx.ds_name"
              &sh     = "DICTDB._Index._I-misc2[1]"
              }

      end.     /* compare this Index */
 

/*------------------------------------------------------------------*/
