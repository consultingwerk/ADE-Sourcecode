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

/* _ora_md3 - returns list of Oracle OBJ$ in gate-work */

/*
This is used primarily for the Progress automated test
scripts, but it was reasoned that it is useful enough in
general to leave in the /prodict directory for future use.
*/

{ prodict/dictvar.i    }
{ prodict/ora/oravar.i }
{ prodict/user/uservar.i }

{prodict/gate/gatework.i
  &new        = " "
  &options    = "initial ""*"" "
  &SelVarType = "VARIABLE l"
  } /* Defines WORKFILE: gate-work */

DEFINE VARIABLE object-type AS CHARACTER NO-UNDO. 
DEFINE VARIABLE object-prog AS CHARACTER NO-UNDO. 

FOR EACH DICTDBG.oracle_objects NO-LOCK,
  EACH DICTDBG.oracle_users
    WHERE DICTDBG.oracle_users.user# = DICTDBG.oracle_objects.owner# NO-LOCK
    BY DICTDBG.oracle_users.name BY DICTDBG.oracle_objects.name:


  /*
  ** Skip objects that we didn't create and/or don't own.
  */ 

   IF (DICTDBG.oracle_objects.type <> 2 AND
       DICTDBG.oracle_objects.type <> 6 AND
       DICTDBG.oracle_objects.type <> 7 AND
       DICTDBG.oracle_objects.type <> 8 AND
       DICTDBG.oracle_objects.type <> 9) 
     THEN NEXT.
 
  IF DICTDBG.oracle_users.name <> CAPS(ora_username) THEN
      NEXT. 

  /* Skip sequence generators created for compatible oracle tables */

  IF DICTDBG.oracle_objects.name MATCHES "*_SEQ" THEN
    NEXT.

  IF DICTDBG.oracle_objects.type = 2 OR 
     DICTDBG.oracle_objects.type = 7 OR
     DICTDBG.oracle_objects.type = 8 OR
     DICTDBG.oracle_objects.type = 9 THEN
      object-type = "TABLE".
  ELSE 
      object-type = "SEQUENCE".

  object-prog = DICTDBG.oracle_objects.name.
  RUN prodict/gate/_gat_xlt.p (TRUE,drec_db,INPUT-OUTPUT object-prog).

  create gate-work. 

  ASSIGN
      gate-work.gate-type = object-type
      gate-work.gate-name = DICTDBG.oracle_objects.name
      gate-work.gate-qual = ?
      gate-work.gate-user = DICTDBG.oracle_users.name
      gate-work.gate-prog = object-prog. 

END.

RETURN.
