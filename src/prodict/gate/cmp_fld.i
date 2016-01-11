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

File: prodict/gate/cmp_fld.i

Description:
    
    compares all attributes of a field

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
    mcmann    08/21/01  Removed check on ORDER
    mcmann   06/04/02   Added output to file logic
--------------------------------------------------------------------*/        
/*h-*/

    if not available DICTDB._Field
     then assign
       { prodict/gate/cmp_nav.i
              &object = "FIELD"
              &obj    = "fld"
              &objm   = "fld"
              }

     else do:  /* compare this field */

     /* SEVERE Differences
      *     Extent, shadow-column-name
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Extent:"
              &msgidx = "l_fld-msg[4]"
              &msgvar = "sev"
              &ns     = "s_ttb_fld.pro_extnt"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Extent"
              }
      if can-do(odbtyp,user_dbtype)
       then do:
        { prodict/gate/cmp_msg.i
              &attrbt = "Shadow-column name:"
              &msgidx = "l_fld-msg[14]"
              &msgvar = "sev"
              &ns     = "s_ttb_fld.ds_shdn"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc2[5]"
              }
        end.
       else { prodict/gate/cmp_msg.i
              &attrbt = "Shadow-column name:"
              &msgidx = "l_fld-msg[15]"
              &msgvar = "sev"
              &ns     = "s_ttb_fld.ds_shdn"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc2[2]"
              }
      
     /* severe Differences in INTERNAL info
      *     offset, precision, scale, length, shadow-column-number,
      *     quoted-name, misc properties
      */
      { prodict/gate/cmp_msg.i
              &attrbt = "Foreign offset:"
              &msgidx = "l_fld-msg[7]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_stoff"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-stoff"
              }
      if can-do(odbtyp + ",ORACLE",user_dbtype)
       then { prodict/gate/cmp_msg.i
              &attrbt = "Precision:"
              &msgidx = "l_fld-msg[9]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_prec"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc1[1]"
              }
      if can-do(odbtyp + ",ORACLE",user_dbtype)
       then { prodict/gate/cmp_msg.i
              &attrbt = "Scale:"
              &msgidx = "l_fld-msg[10]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_scale"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc1[2]"
              }
      if can-do(odbtyp + ",ORACLE",user_dbtype)
       then { prodict/gate/cmp_msg.i
              &attrbt = "Length:"
              &msgidx = "l_fld-msg[11]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_lngth"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc1[3]"
              }
      if can-do(odbtyp + ",ORACLE",user_dbtype)
       then { prodict/gate/cmp_msg.i
              &attrbt = "Radix:"
              &msgidx = "l_fld-msg[12]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_radix"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc1[4]"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Shadow-column number:"
              &msgidx = "l_fld-msg[13]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_shd#"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc1[5]"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Quoted name:"
              &msgidx = "l_fld-msg[16]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_msc23"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc2[3]"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Misc Properties:"
              &msgidx = "l_fld-msg[17]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_msc24"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-misc2[4]"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Foreign data-type:"
              &msgidx = "l_fld-msg[5]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_type"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._For-Type"
              }
      { prodict/gate/cmp_msg.i
              &attrbt = "Foreign data-type number:"
              &msgidx = "l_fld-msg[6]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_stdtype"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-stdtype"
              }
      if can-do(odbtyp + ",ORACLE",user_dbtype)
       then { prodict/gate/cmp_msg.i
              &attrbt = "Foreign data-type integer:"
              &msgidx = "l_fld-msg[6]"
              &msgvar = "int"
              &ns     = "s_ttb_fld.ds_itype"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._For-Itype"
              }
     

     /* Differences in RETAINABLE info
      *     Case, Mandatory, description, progress-name
      *     PROGRESS data-type, initial-value, decimals and format
      */
     if s_ttb_fld.pro_case = TRUE
       then { prodict/gate/cmp_msg.i
              &attrbt = "Case-Sensitivity:"
              &msgidx = "l_fld-msg[2]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_case"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Fld-Case" 
              }
      if s_ttb_fld.pro_mand = TRUE
       then { prodict/gate/cmp_msg.i
              &attrbt = "Mandatory:"
              &msgidx = "l_fld-msg[3]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_mand"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Mandatory"
              }
 
      { prodict/gate/cmp_msg.i
              &attrbt = "Name in PROGRESS:"
              &msgidx = "l_fld-msg[22]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_name"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Field-Name"
              } 
     { prodict/gate/cmp_msg.i
              &attrbt = "Description:"
              &msgidx = "l_fld-msg[23]"
              &msgvar = "ret2"
              &ns     = "s_ttb_fld.pro_desc"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Desc" 
              } 
      
    if NOT (
       (   can-do(l_char-types + l_chda-types               ,s_ttb_fld.ds_type) 
       AND can-do("character"              ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_chda-types                              ,s_ttb_fld.ds_type) 
       AND can-do("character,date"         ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_chda-types + l_date-types               ,s_ttb_fld.ds_type) 
       AND can-do("date"                   ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_dcml-types + l_deil-types + l_dein-types,s_ttb_fld.ds_type) 
       AND can-do("decimal"                ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_deil-types                              ,s_ttb_fld.ds_type) 
       AND can-do("decimal,integer,logical",DICTDB._Field._Data-type) )
       OR
       (   can-do(l_deil-types + l_dein-types               ,s_ttb_fld.ds_type) 
       AND can-do("decimal,integer"        ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_deil-types + l_dein-types + l_intg-types,s_ttb_fld.ds_type) 
       AND can-do("integer"                ,DICTDB._Field._Data-type) )
       OR
       (   can-do(l_deil-types + l_logi-types               ,s_ttb_fld.ds_type) 
       AND can-do("logical"                ,DICTDB._Field._Data-type) )
         )
       then do:  /* new data-type not compatible with old one */
        { prodict/gate/cmp_msg.i
              &attrbt = "PROGRESS Data-type:"
              &msgidx = "l_fld-msg[18]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_type"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Data-Type"
              }
        { prodict/gate/cmp_msg.i
              &attrbt = "Initial-value:"
              &msgidx = "l_fld-msg[19]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_init"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Initial"
              }
        { prodict/gate/cmp_msg.i
              &attrbt = "Decimals:"
              &msgidx = "l_fld-msg[20]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_dcml"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Decimal"
              }
        if s_ttb_fld.pro_frmt <> ""
         then { prodict/gate/cmp_msg.i
              &attrbt = "PROGRESS Format:"
              &msgidx = "l_fld-msg[21]"
              &msgvar = "ret"
              &ns     = "s_ttb_fld.pro_frmt"
              &object = "FIELD"
              &o-name = "s_ttb_fld.ds_name"
              &sh     = "DICTDB._Field._Format"
              } 
        end.  /* new data-type not compatible with old one */ 

      end.     /* compare this field */


/*------------------------------------------------------------------*/
