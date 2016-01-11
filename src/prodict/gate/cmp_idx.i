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
              &attrbt = "Name in PROGRESS:"
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
