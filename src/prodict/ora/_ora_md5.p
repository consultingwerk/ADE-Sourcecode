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

/* Procedure prodict/ora/_ora_md5.p

   Modified 11/12/97 DLM Removed DISCONNECT of Progress Database.
   
*/   


DEFINE INPUT PARAMETER ora-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

/* connect up the databases to work with ------------------------------------*/

DELETE ALIAS DICTDB2.

IF NOT CONNECTED(pro-name) THEN
  CONNECT VALUE(pro-name)-1 -ld DICTDB2 NO-ERROR.
ELSE
   CREATE ALIAS DICTDB2 FOR DATABASE VALUE(pro-name).  

RUN prodict/ora/_ora_fix.p.

RETURN.
