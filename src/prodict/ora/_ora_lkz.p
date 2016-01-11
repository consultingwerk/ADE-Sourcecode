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

File: prodict/ora/_ora_lkz.p

Description:
    creates the temporary _db-record for the links
    
Input-Parameters:  
    none
    
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    none

    
History:
    hutegger    94/09/11    creation
    mcmann      97/11/12    Added view-as dialog-box for non tty clients
    mcmann      98/11/13    Added assignment of _Db-misc1[3] = Original _db-misc1[3]
                            or if ? then default to 7.
    mcmann      07/03/01    Removed delete of files from z-ora db link record
                            20010626-017                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

define        variable l_c            as character.
define        variable l_db-xl-name   as character.
define        variable l_db-comm      as character.
define        variable l_db-misc13    AS INTEGER.

&UNDEFINE DATASERVER

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

display
  " "                                                               skip
  "  Creating z_ora_links to be used for ORACLE distributed DBs.  " skip
  " "
  with centered row 5 frame msg 
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box 
    three-d &ENDIF.

find first DICTDB._Db
  where DICTDB._Db._Db-name = ldbname("DICTDBG")
  and   DICTDB._Db._Db-type = "ORACLE"
  no-lock no-error.
if not available DICTDB._Db
 then do: /* should never happen otherwise we wouldn't be here ... */
  message "could not find ORACLE-schemaholder" view-as alert-box.
  hide frame msg no-pause.
  assign user_path = "".
  RETURN.
  end.
 
 
assign
  l_db-comm    = DICTDB._Db._Db-comm
  l_db-xl-name = DICTDB._Db._Db-xl-name
  s_ldbname    = "z_ora_links"
  s_ldbconct   = s_ldbname + " -RO -U ""*" + _Db._Db-name + """"
  l_db-misc13  = DICTDB._Db._Db-Misc1[3].
  
IF l_db-misc13 = 0 OR l_db-misc13 = ? THEN
    ASSIGN l_db-misc13 = 7.


find first DICTDB._Db
  where DICTDB._Db._db-name = s_ldbname
  no-error.
if available DICTDB._Db
 then do:  /* z_ora_links _db exists */
  if RECID(DICTDB._Db) = drec_db
   then do:
    message
      """z_ora_links"" can't get used as logical name for an ORACLE DB"
      view-as alert-box.
    hide frame msg no-pause.
    assign user_path = "".
    LEAVE.
    end.
    
  else if DICTDB._Db._Db-type <> "ORACLE"
   then do:  /* non-ORACLE z_ora_links _db */
      message 
        "PROGRESS creates a temporary _Db-record called ""z_ora_links"" to "
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        "access distributed DBs. There is currently a _Db-record named "
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        """z_ora_links"" in your DB."
                                                                    skip(1)
        "Please give this schema a different logical name and then"
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        "choose this function again."
       view-as alert-box.

      hide frame msg no-pause.
      assign user_path = "".
      LEAVE.
    end.     /* non-ORACLE z_ora_links _db */
   
   else do:  /* reusable or error-message */
   
    
    { prodict/dictgate.i 
        &action = "can-reuse"
        &dbtype = "DICTDB._Db._Db-type"
        &dbrec  = "RECID(DICTDB._Db)"
        &output = "l_c"
    }  /* can-reuse = can-remove */

    if l_c <> "ok"
     then do:  /* z_ora_links _db NOT useable */
      message 
        "PROGRESS creates a temporary _Db-record called ""z_ora_links"" to "
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        "access distributed DBs. There is currently a _Db-record named "
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        """z_ora_links"" in your DB."
                                                                    skip(1)
        "Please give this schema a different logical name and then"
        &IF "{&window-system}" = "OSF/MOTIF" &THEN skip &ENDIF
        "choose this function again."
        view-as alert-box.
        
      hide frame msg no-pause.
      assign user_path = "".
      LEAVE.
      end.     /* z_ora_links _db NOT useable */

    end.     /* reusable or error-message */

  end.     /* z_ora_links _db exists */

 else do:  /* create new z_ora_links _db */
  create DICTDB._Db.
  assign
    DICTDB._Db._Db-slave    = TRUE
    DICTDB._Db._Db-type     = "ORACLE"
    DICTDB._Db._Db-addr     = ""
    DICTDB._Db._Db-name     = s_ldbname
    DICTDB._Db._Db-misc1[3] = l_db-misc13
    DICTDB._Db._Db-comm     = l_db-comm
    DICTDB._Db._Db-xl-name  = l_db-xl-name.
 
  { prodict/dictgate.i 
      &action = "add"
      &dbtype = "DICTDB._Db._Db-type"
      &dbrec  = "RECID(DICTDB._Db)"
      &output = "l_c"
      }
  end. /* create new z_ora_links _db */
hide frame msg no-pause.

/*------------------------------------------------------------------*/

