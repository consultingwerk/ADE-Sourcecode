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

/* File:_as4_del.p

Description:
    This procedure deletes a DB2/400 DataServer Schema from the
    client.

History:
     Created  01/25/95  D. McMann
     Modified 03/19/96  D. McMann fixing bugs 95-12-21-026 and 96-01-31-025
                        added _usrsget to user_path when redo.
*/


/*===========================  Main Line Code  ===========================*/
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }


SESSION:IMMEDIATE-DISPLAY = TRUE.

DEFINE VARIABLE answer AS LOGICAL INITIAL FALSE NO-UNDO.     
DEFINE VARIABLE dbhold  AS CHARACTER NO-UNDO.

FIND _db where _db._db-name = user_dbname.                         

IF _Db._Db-misc1[8] <> 7 THEN DO:
     MESSAGE "This utility can only be used against a V7 Server."
        VIEW-AS ALERT-BOX ERROR BUTTON OK.
      ASSIGN user_path = "".
 END.
        
ASSIGN dbhold = _Db._Db-name + "?".
IF user_env[1] =  "redo" THEN   answer = true.
 ELSE   MESSAGE "Are you sure you want to delete DB2/400 " SKIP
        "DataServer schema for"  dbhold SKIP
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer. 

/*  Database must be disconnect in order to delete _db record */
IF answer AND CONNECTED(user_dbname) THEN 
   DISCONNECT VALUE(_Db._Db-name).

     
IF answer THEN DO:   
  run adecomm/_setcurs.p ("WAIT").
  RUN as4dict/as4deldb.p.    
  run adecomm/_setcurs.p ("").  
END.
