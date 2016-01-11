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
   History:  DLM 09/03/98  New ProToOdb already connects to Progress
                           database.  I added a check so connect would
                           not issue an error
*/                           


DEFINE INPUT PARAMETER mss-name     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-name     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-conparms AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_edbtype  AS CHARACTER NO-UNDO.

DEFINE VARIABLE connted AS LOGICAL INITIAL FALSE.

/* connect up the databases to work with ------------------------------------*/

DELETE ALIAS DICTDB2.

IF NOT CONNECTED (pro-name) THEN DO:
  CONNECT VALUE(pro-name) -ld DICTDB2 VALUE (pro-conparms) -1.
  ASSIGN connted = TRUE.
END.  

ELSE
  CREATE ALIAS DICTDB2 FOR DATABASE VALUE(pro-name).  

RUN prodict/mss/_mss_fix.p (p_edbtype).

IF connted THEN
  DISCONNECT DICTDB2.
ELSE
  DELETE ALIAS DICTDB2.
    
RETURN.

