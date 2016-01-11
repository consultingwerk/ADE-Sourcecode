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

/* _loduser.p - load _User file records */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE cerror    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage  AS CHARACTER           NO-UNDO init "UNDEFINED".
DEFINE VARIABLE errbyte   AS INTEGER             NO-UNDO.
DEFINE VARIABLE errline   AS INTEGER             NO-UNDO.
DEFINE VARIABLE errs      AS INTEGER             NO-UNDO.
DEFINE VARIABLE fil-e     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE i         AS INTEGER             NO-UNDO.
DEFINE VARIABLE lvar      AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#     AS INTEGER             NO-UNDO.
DEFINE VARIABLE nxtstop   AS INTEGER             NO-UNDO.
DEFINE VARIABLE recs      AS INTEGER.             /*UNDO*/

IF NOT user_env[2] MATCHES "*~.d"
 THEN DO:
  MESSAGE "File name containing User information must end in ~".d~"."
      	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
  END.

fil-e = SUBSTRING(user_env[2],1,LENGTH(user_env[2]) - 1) + "e".

run adecomm/_setcurs.p ("WAIT").

/***** Don't need this right now...
{prodict/dump/lodtrail.i
  &file    = "user_env[2]"
  &entries = " " 
  }  /* read trailer, sets variables: codepage and cerror */
*/

ASSIGN codepage = user_env[10]. /* codepage set in _usrload.p */
IF codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? THEN
     ASSIGN cerror  = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".

IF cerror = ?
 THEN DO:  /* conversion needed but NOT possible */

  OS-DELETE VALUE(fil-e).
  run adecomm/_setcurs.p ("").
  MESSAGE "_User information NOT loaded." 
       	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 

  END.     /* conversion needed but NOT possible */

 ELSE DO:  /* conversion not needed OR needed and possible */

  OUTPUT TO VALUE(fil-e) NO-ECHO.
  if cerror = "no-convert"
   then INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
               CONVERT SOURCE codepage TARGET SESSION:CHARSET.

  REPEAT FOR DICTDB._User ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF RETRY
     THEN DO:
      errs = errs + 1.
      PUT UNFORMATTED
        ">> ERROR READING LINE #" errline " (OFFSET=" errbyte ")" SKIP
        "** Tolerable load error rate is: 0%." SKIP
        "** Loading table _User is aborted." SKIP.
      LEAVE.
      END.
    CREATE _User.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.
    IMPORT _User.
    END. /* end repeat */

  INPUT CLOSE.
  OUTPUT CLOSE.
  run adecomm/_setcurs.p ("").
  
  IF errs = 0
   THEN DO:
    OS-DELETE VALUE(fil-e).
    MESSAGE "User information loaded successfully." SKIP
        	  recs "records read."
        	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
   ELSE DO:
    MESSAGE errs "error(s) in loading User information." SKIP
        	  "Error listing contained in file" fil-e SKIP
          	  recs "records read."
        	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

  END.     /* conversion not needed OR needed and possible */

RETURN.


