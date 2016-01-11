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

File: prodict/ora/_ora_lk0.p

Description:
    creates the temporary _db-record for the links
    
Input-Parameters:  
    none
    
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    user_env[1]     db_comm-parameter

    
History:
    hutegger    94/09/11    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES

define        variable l_c            as character.
define        variable l_db-xl-name   as character.
define        variable l_db-comm      as character.
define        variable l_drec_db      like drec_db.
define        variable l_user_dbname  like user_dbname.

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


/* handle v6-oracle by calling other routines */
/* Oracle 6 is no longer supported in 8.2 of Progress
IF DBVERSION("DICTDBG") MATCHES "*6*"
 THEN do:
  assign user_path = ( if index (user_path,"compare") = 0
                        then "_ora6get,_ora6mak"
   &IF "{&WINDOW-SYSTEM}" = "TTY"
        &THEN           else "1=,_usrtget,9=pro,_ora6vrf,_ora6mak"
        &ELSE           else "1=,_guitget,9=pro,_ora6vrf,_ora6mak"
        &ENDIF
                     ).
  return.
  end.
************ Removed about code for 8.2 ********/  

/* delete eventually left-over records from earlier schema-pulls */
for each s_ttb_link: delete s_ttb_link. end.
for each gate-work:  delete gate-work.  end.
for each s_ttb_seq:  delete s_ttb_seq.  end.
for each s_ttb_tbl:  delete s_ttb_tbl.  end.
for each s_ttb_fld:  delete s_ttb_fld.  end.
for each s_ttb_idx:  delete s_ttb_idx.  end.
for each s_ttb_idf:  delete s_ttb_idf.  end.


/* initialize preselection-criteria and link for local db */  
create s_ttb_link.
assign
  s_name-hlp              = "*"
  s_owner-hlp             = "*"
  s_qual-hlp              = "*"
  s_type-hlp              = "*"
  s_level                 = 0
  s_master                = ""
  s_lnkname               = ""
  s_owner                 = s_owner-hlp
  s_name                  = s_name-hlp
  s_type                  = s_type-hlp
  s_qual                  = s_qual-hlp
  s_ttb_link.name         = s_lnkname
  s_ttb_link.level        = s_level
  s_ttb_link.srchd        = FALSE
  s_ttb_link.slctd        = TRUE
  s_ttb_link.master       = s_master.


/*------------------------------------------------------------------*/
