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

/* _dmpuser.p   */

/*
in:  user_env[2] = Name of file to dump to.
     user_env[5] = "<internal defaults apply>" or "<target-code-page>"

History:
    hutegger    94/02/24    code-page - support and trailer-info added
    
*/
/*h-*/

{ prodict/user/uservar.i }

DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

IF NOT CAN-FIND(FIRST DICTDB._User) THEN DO:
   MESSAGE "There are no user records to dump." SKIP
      	   "The output file has not been modified."
      	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

IF  user_env[5] = ?
 OR user_env[5] = "" THEN assign user_env[5] = "<internal defaults apply>".

IF  user_env[5] = "<internal defaults apply>" 
 THEN OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
 ELSE OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP
            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].

FOR EACH DICTDB._User:
  EXPORT DICTDB._User.
END.

  {prodict/dump/dmptrail.i
    &entries      = " "
    &seek-stream  = "OUTPUT"
    &stream       = " "
    }  /* adds trailer with code-page-entrie to end of file */
    
OUTPUT CLOSE.
run adecomm/_setcurs.p ("").
MESSAGE "Dump of users completed." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.
