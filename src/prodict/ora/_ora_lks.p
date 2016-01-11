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

File: prodict/ora/_ora_lks.p       THIS ROUTINE GETS CALLED ONLY ONCE!

Description:
    let the user SELECT the objects whose definitions are to be pulled
    this routine gets called only once (and not once per link!)
    
Input-Parameters:  
    none
                                                
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias for current link
    s_ldbname   logical name of the link-db (= physical name)
    s_ttb_link  local and distributed DBs
    gate-work   objects in DBs
    
History:
    hutegger    94/10/18    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER

define variable canned          as logical   no-undo.
define variable edbtyp          as character no-undo.
define variable i               as integer   no-undo. 
define variable l_rep-presel    as logical   no-undo init TRUE. 

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

SESSION:IMMEDIATE-display = no.
assign edbtyp = "ORACLE".

repeat while TRUE:

  presel: DO:

  {prodict/gate/gat_get.i
    &block     = "presel "
    &clean-up  = "_ora_lkx"
    &end       = "end. "
    &gate-flag = "NOT gate-work.gate-name begins ""Oracle_"""
    &special1  = "for each gate-work
                    where gate-work.gate-slct = TRUE
                    and   gate-work.gate-qual = ?:
                    assign gate-work.gate-qual = ""<Local DB>"".
                    end.
                 "
    &special2  = "for each gate-work
                    where gate-work.gate-slct  = TRUE
                    and   gate-work.gate-qual  = ""<Local DB>"":
                    assign gate-work.gate-qual = ?.
                    end.
                 "
    &where     = "not gate-work.gate-user begins ""SYS"""
    } /* message and leave */
  
  leave.
  end.

if l_rep-presel = TRUE
 then do:  /* repeat preselection */
  assign
    i         = 0
    s_level   = 0
    s_lnkname = ""
    s_master  = ""
    user_path = "*C,_ora_lkc,_ora_lkl".
  for each s_ttb_link
    where s_ttb_link.slctd  = TRUE:
    assign
      i                = i + 1
      s_ttb_link.srchd = FALSE.
    end.
  if i > 1
   then do:
    if connected(s_ldbname)
     then disconnect value(s_ldbname) /*no-error*/.
    do transaction:
      find first DICTDB._Db
        where DICTDB._Db._Db-name = s_ldbname
        and   DICTDB._Db._Db-type = "ORACLE".
      assign DICTDB._Db._Db-misc2[8] = ?.
      end.     /* transaction */
    end.

  end.     /* repeat preselection */
 
/*------------------------------------------------------------------*/
