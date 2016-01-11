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
/* connect.p */

DEFINE INPUT PARAMETER user-id          AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER password         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER app-server-info  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hDynUser AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPassword AS CHARACTER  NO-UNDO.
{aficfcheck.i}

IF lICFRunning THEN
DO:
  
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afdynuser.p":U, OUTPUT hDynUser) NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
     RETURN-VALUE <> "":U THEN
  DO:
    MESSAGE "UNABLE TO START USER VALIDATION ALGORITHM":U.
    RETURN ERROR "UNABLE TO START USER VALIDATION ALGORITHM":U.
  END.
  
  cPassword = DYNAMIC-FUNCTION("createPassword":U IN hDynUser, user-id).
  
  IF cPassword <> password THEN
  DO:
    MESSAGE "INVALID USER NAME (" + user-id + ") OR PASSWORD TO CONNECT TO APPSEVER":U.
    RETURN ERROR "INVALID USER NAME OR PASSWORD TO CONNECT TO APPSEVER":U.
  END.

END.

