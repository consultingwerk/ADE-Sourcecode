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

/* _dctname.p - returns TRUE if name is valid PROGRESS identifier */

DEFINE        VARIABLE  i    AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER name AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER okay AS LOGICAL   NO-UNDO.

okay = LENGTH(name) >= 1 AND LENGTH(name) <= 32
       AND SUBSTRING(name,1,1) >= "A"
       AND SUBSTRING(name,1,1) <= "Z"
       AND KEYWORD(name) = ?.
DO i = 2 TO LENGTH(name) WHILE okay:
  okay = INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ",
         SUBSTRING(name,i,1)) > 0.
END.

RETURN.
