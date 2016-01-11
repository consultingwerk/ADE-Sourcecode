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

/* as4recon.p */

/* This file is run from _as4_sync.p when a code page change has occurred
   during synchronization.  It asks the user if they want to reconnect
   to the database that was disconnected.
   
   Created 01/24/95 D McMann
   
*/
  
DEFINE VARIABLE answer AS LOGICAL INITIAL FALSE NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

find _db where _db._Db-name = user_env[35] NO-ERROR.

IF AVAILABLE _db AND NOT CONNECTED(_Db._Db-name) THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
 
  MESSAGE _Db._Db-name "was disconnected because the " SKIP
          "code page changed during synchronization. " SKIP
          "Do you want to re-connected? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
  IF answer THEN DO:
    MESSAGE
      'Connecting to "' + _Db._Db-name  + '"'.
    run adecomm/_setcurs.p ("WAIT").
    CONNECT VALUE(_db._Db-name) -dt VALUE(_db._Db-type) VALUE(_db._Db-comm) NO-ERROR.

    PAUSE 1 NO-MESSAGE.  /* to avoid having the message flash to fast */  
    { prodict/user/usercon.i '' @ user_filename }
    RUN adecomm/_setcurs.p ("").
    HIDE MESSAGE NO-PAUSE.
  END.
  ELSE DO:   
    ASSIGN user_env[1] = "get".   
    RUN prodict/gui/_guisget.p.
  END.
END.
 
