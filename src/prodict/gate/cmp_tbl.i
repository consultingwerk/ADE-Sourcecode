/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/cmp_tbl.i

Description:
    
    compares all attributes of a table

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

  if not available DICTDB._File
   then do:
    assign
      { prodict/gate/cmp_nav.i
              &object = "TABLE"
              &obj    = "tbl"
              &objm   = "tbl"
              }
    { prodict/gate/cmp_sum.i
        &object = "tbl"
        }
    NEXT.
    end.

   else do:  /* compare this File */
     /* SEVERE Differences
      *     Foreign Type, Package-Name
      */
    { prodict/gate/cmp_msg.i
            &attrbt = "Foreign Type:"
            &msgidx = "l_tbl-msg[3]"
            &msgvar = "sev"
            &ns     = "s_ttb_tbl.ds_type"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._For-Type"
            }
    if user_dbtype = "ORACLE"
     then { prodict/gate/cmp_msg.i
            &attrbt = "Package Name:"
            &msgidx = "l_tbl-msg[4]"
            &msgvar = "sev"
            &ns     = "s_ttb_tbl.ds_msc21"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc2[1]"
            }
     /* severe Differences in INTERNAL info
      *     Hidden fields, Field-names list, Index-free field, 
      *     RECID-Field-name
      */
    { prodict/gate/cmp_msg.i
            &attrbt = "Hidden fields:"
            &msgidx = "l_tbl-msg[5]"
            &msgvar = "int"
            &ns     = "s_ttb_tbl.ds_msc22"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc2[2]"
            }
    { prodict/gate/cmp_msg.i
            &attrbt = "Field-names list:"
            &msgidx = "l_tbl-msg[6]"
            &msgvar = "int"
            &ns     = "s_ttb_tbl.ds_msc24"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc2[4]"
            }
    { prodict/gate/cmp_msg.i
            &attrbt = "Index-free field:"
            &msgidx = "l_tbl-msg[7]"
            &msgvar = "int"
            &ns     = "s_ttb_tbl.ds_msc13"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[3]"
            }
    { prodict/gate/cmp_msg.i
            &attrbt = "RECID-field-name:"
            &msgidx = "l_tbl-msg[10]"
            &msgvar = "int"
            &ns     = "s_ttb_tbl.ds_msc23"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc2[3]"
            }

     /* Differences in RETAINABLE info
      *     PROGRESS Name, ROWID-Index, Description
      */
    { prodict/gate/cmp_msg.i
            &attrbt = "Name in {&PRO_DISPLAY_NAME}:"
            &msgidx = "l_tbl-msg[2]"
            &msgvar = "ret"
            &ns     = "s_ttb_tbl.pro_name"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._File-Name"
            }
    /*                                                      ORA    others
     *                                                     [1]/[4] [1]/[4]
     * s_ttb_tbl.ds_recid > 0 -> progress_recid             # / ?   # / ?
     *                    = 0 -> use nativ rowid            ? /-#   # / ?
     *                    < 0 -> normal column for recid    ? /-#   # / ?
     */
    if user_dbtype = "ORACLE"
     then do:
      if s_ttb_tbl.ds_recid <= 0
       then do:
        { prodict/gate/cmp_msg.i
            &attrbt = "Progress_Recid:"
            &msgidx = "l_tbl-msg[8]"
            &msgvar = "ret"
            &ns     = "integer(?)"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[1]"
            }
        { prodict/gate/cmp_msg.i
            &attrbt = "RECID-index:"
            &msgidx = "l_tbl-msg[8]"
            &msgvar = "ret"
            &ns     = "(0 - s_ttb_tbl.ds_recid)"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[4]"
            }
        end.
       else do:
        { prodict/gate/cmp_msg.i
            &attrbt = "Progress_Recid:"
            &msgidx = "l_tbl-msg[8]"
            &msgvar = "ret"
            &ns     = "s_ttb_tbl.ds_recid"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[1]"
            }
        { prodict/gate/cmp_msg.i
            &attrbt = "RECID-index:"
            &msgidx = "l_tbl-msg[8]"
            &msgvar = "ret"
            &ns     = "integer(?)"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[4]"
            }
        end.
      end.
     else do:
      { prodict/gate/cmp_msg.i
            &attrbt = "RECID-index:"
            &msgidx = "l_tbl-msg[8]"
            &msgvar = "ret"
            &ns     = "s_ttb_tbl.ds_recid"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[1]"
            }
      end.
    { prodict/gate/cmp_msg.i
            &attrbt = "ROWID-index:"
            &msgidx = "l_tbl-msg[9]"
            &msgvar = "ret"
            &ns     = "s_ttb_tbl.ds_rowid"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Fil-Misc1[2]"
            }
    IF NOT user_dbtype = "MSS" THEN
    { prodict/gate/cmp_msg.i
            &attrbt = "Description:"
            &msgidx = "l_tbl-msg[11]"
            &msgvar = "ret"
            &ns     = "s_ttb_tbl.pro_desc"
            &object = "TABLE"
            &o-name = "s_ttb_tbl.ds_name"
            &sh     = "DICTDB._File._Desc"
            }

    end.     /* compare this File */
      

/*------------------------------------------------------------------*/
