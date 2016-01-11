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

File: prodict/gate/gat_puli.i

Description:
    
    creates new s_ttb_idx record
        
Text-Parameters:
    &for-idx-name    name of the name-field (for example:
                     sybase_objects.name + STRING(indn))
    &for-idx-nam2    ev. 2 possible name of the name-field (for example:
                     sybase_objects.name + STRING(w_index.pro_idx-num))
    &for-obj-name    name of the name-field (sybase_objects.name, ...)
    &idx-uniq-cond   condition to make this index unique
                     for example: "(DICTDBG.Syabse_keys.type = 1)"
    &frame           name of the display-frame (for example: syb_mak, ...)

Output-Parameters:
    none
    
Included in:
    odb/_odb_pul.p
    ora/_ora_pul.p
    syb/syb_pulp.i

History:
    hutegger    95/03   creation (derived from gate/gat_mdi2.i)
    mcmann  06/30/99 Change how to determine what index name should be.
    
--------------------------------------------------------------------*/        
/*h-*/

    assign user_env[1] = TRIM({&for-idx-name}).
    IF INDEX(user_env[1],"##") > 0 THEN
     ASSIGN i = INDEX(user_env[1], "##") + 2.
    ELSE IF INDEX(user_env[1],"__") > 0 THEN
     ASSIGN i = INDEX(user_env[1], "__") + 2.  
    ELSE
      i = 1.   
    
    user_env[1]        = substring(user_env[1],i,-1,"character").

    RUN prodict/gate/_gat_fnm.p
          (INPUT        "INDEX",
           INPUT        RECID(s_ttb_tbl),
           INPUT-OUTPUT user_env[1]
          ).

    if TERMINAL <> "" and NOT batch-mode
     then DISPLAY
        TRIM({&for-idx-name})   @ msg[5]
        user_env[1]             @ msg[6]
        with frame ds_make.

    create s_ttb_idx.

    assign
      s_ttb_idx.pro_name = user_env[1]
      s_ttb_idx.ttb_tbl  = RECID(s_ttb_tbl)
      s_ttb_idx.pro_uniq = ( {&idx-uniq-cond} )
      s_ttb_idx.ds_name  = TRIM({&for-idx-name})
      s_ttb_idx.pro_idx# = indn
      s_ttb_idx.pro_actv = TRUE
      indn               = indn + 1.

    if    unique-prime = FALSE
      and ( indn       = 2
      or    {&idx-uniq-cond} )
      then assign 
        s_ttb_idx.pro_prim = TRUE
        unique-prime       = ( {&idx-uniq-cond} ).

/*------------------------------------------------------------------*/


