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

/* rtvuspc.p
   Entry procedure for API to the AS/400 to work with user spaces for receiving
   an entry from the specified space
   
   Created June 30, 1997
   Donna L. McMann
   
   Modified: 06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                to _file finds.
   
*/

DEFINE INPUT        PARAMETER db-name     AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER uspc-name   AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER lib-name    AS CHARACTER NO-UNDO.    
DEFINE INPUT        PARAMETER start-pos   AS INTEGER   NO-UNDO.
DEFINE INPUT        PARAMETER data-length AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER data-val    AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER stat        AS INTEGER   NO-UNDO.

DEFINE VARIABLE apirtn      AS INTEGER                               NO-UNDO.

/* Verify database name and create alias as4dict, else return with error code -1 */

&IF "{&OPSYS}" <> "OS400" &THEN
    FIND _Db WHERE _Db._Db-name = db-name NO-LOCK NO-ERROR.
    IF AVAILABLE _Db THEN DO:
      IF CONNECTED(_Db._Db-name) THEN
         CREATE ALIAS as4dict FOR DATABASE VALUE(_Db-name).
    END.
    ELSE DO:
      FIND _Db WHERE _Db._Db-ADDR = db-name NO-LOCK NO-ERROR.   
      IF AVAILABLE _Db THEN DO:
        IF CONNECTED(_Db._Db-name) THEN
         CREATE ALIAS as4dict FOR DATABASE VALUE(_Db-name).
      END.
      ELSE DO:
        ASSIGN stat = -1.
        RETURN.
      END.
    END.

    FIND _File WHERE _File._Db-recid = RECID(_Db)
               AND _File._File-name = "qusrspc"
               AND  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
               NO-LOCK NO-ERROR.

    IF NOT AVAILABLE _File THEN DO:
      ASSIGN stat = -2.
      DELETE alias as4dict.
      RETURN.
    END.    
&ENDIF.
IF start-pos < 0 THEN DO:
  ASSIGN stat = -3.
  DELETE alias as4dict.
  RETURN.
END.
IF data-length > 2048 THEN DO:
  ASSIGN stat = -4.
  DELETE alias as4dict.
  RETURN.
END.
           
RUN as4dict/qusrspc.p (INPUT "R", INPUT uspc-name, INPUT lib-name, INPUT start-pos, 
                       INPUT data-length, INPUT-OUTPUT data-val, OUTPUT apirtn).

ASSIGN stat = apirtn.

DELETE alias as4dict.

RETURN.



