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
/*

Procedure:    adetran/vt/_k-mucon.p
Author:       Ross Hunter
Created:      6/3/99
Updated:      
Purpose:      Connect a kit database in multi-user mode and
              resets the alias for Visual Translator.
              Note: uses the shared variable KitDB to get the 
              file name of the kit to be connected.
Called By:    vt/_main.p
*/

DEFINE INPUT  PARAMETER Host          AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER Service       AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER UsrID         AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER Passwrd       AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER ConParms      AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER ErrorStatus   AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE SHARED VARIABLE KitDB AS CHARACTER                     NO-UNDO. 
DEFINE VARIABLE Args         AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE BaseName     AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE DirName      AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE ThisDB       AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE ThisLDB      AS CHARACTER                     NO-UNDO. 
DEFINE VARIABLE ThisMessage  AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE Result       AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE extension    AS CHARACTER                     NO-UNDO.

RUN adecomm/_osprefx.p (KitDB, OUTPUT DirName, OUTPUT BaseName).
ASSIGN BaseName = TRIM(BaseName).
RUN adecomm/_osfext.p (INPUT BaseName, OUTPUT Extension).
ASSIGN ThisDB  = BaseName
       ThisLDB = SUBSTRING(BaseName,1,
                           LENGTH(BaseName,"CHARACTER":U) -
                           LENGTH(Extension,"CHARACTER":U),"CHARACTER":U).

RetryLoop:
DO ON ERROR UNDO RetryLoop, LEAVE RetryLoop. 
  IF NOT CONNECTED(ThisLDB) THEN DO:
    Args = "'" + KitDB + "' -ld '" + ThisLDB + "'" +
           (IF Host     NE "" THEN " -H " + Host     ELSE "") +
           (IF Service  NE "" THEN " -S " + Service  ELSE "") +
           (IF UsrID    NE "" THEN " -U " + UsrID    ELSE "") +
           (IF PassWrd  NE "" THEN " -P " + PassWrd  ELSE "") +
           (IF ConParms NE "" THEN " " + ConParms    ELSE "").

    CONNECT VALUE(Args) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      ThisMessage = ERROR-STATUS:GET-MESSAGE(1).
      RUN adecomm/_s-alert.p (INPUT-OUTPUT Result, "w*":u, "ok":u, ThisMessage).
      RETURN.     
    END.  /* IF there was an error */
  END.  /* IF NOT Already connected */
END.  /* RetryLoop: DO ON ERROR */

DELETE ALIAS Kit.
CREATE ALIAS Kit FOR DATABASE VALUE(ThisLDB) NO-ERROR.  

IF ERROR-STATUS:ERROR THEN DO:
  ThisMessage = ERROR-STATUS:GET-MESSAGE(1).
  RUN adecomm/_s-alert.p (INPUT-OUTPUT Result, "w*":u, "ok":u, ThisMessage).
  ErrorStatus = error-status:error.
END.  /* IF there was an error */
ELSE ASSIGN ErrorStatus = FALSE
            KitDB       = ThisLDB.



