/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

