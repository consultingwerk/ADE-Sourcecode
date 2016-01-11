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

/* Extract a value marked with prefix and postfix and the source without    */
/* the value.					     			    */
/* Used to get column properties:					    
   P - progress recid.
   S - shadow column (case insensitive).
   I - Invisible columne
   N - Unupdatable column.
*/

DEFINE INPUT PARAM src-string AS char NO-UNDO.
DEFINE INPUT PARAM prefix AS char NO-UNDO.
DEFINE INPUT PARAM postfix AS char NO-UNDO.
DEFINE OUTPUT PARAM val-string AS char NO-UNDO.
DEFINE OUTPUT PARAM delta-string AS char NO-UNDO.

DEFINE VAR s AS char NO-UNDO.
DEFINE VAR prefix-len AS int NO-UNDO.
DEFINE VAR postfix-len AS int NO-UNDO.
DEFINE VAR val-len AS int NO-UNDO.
DEFINE VAR i AS int NO-UNDO.

ASSIGN
  prefix-len = LENGTH(prefix)
  postfix-len = LENGTH(postfix)
  val-string = ""
  delta-string = ""
  i = 1.                          


REPEAT:
  s = SUBSTRING(src-string, i).
  IF s BEGINS prefix THEN DO:
    ASSIGN
    val-len = LENGTH(s) - prefix-len -  postfix-len
    val-string = SUBSTRING(s, prefix-len + 1, val-len)
    delta-string = IF (i > 1) THEN SUBSTRING(src-string, 1, i - 1)
		   ELSE "".
    LEAVE.                             
  END. /* DO */

  i = i + 1.
END. /* REPEAT */

