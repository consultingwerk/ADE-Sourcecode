/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_find.i
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's find include file
Background:   Include file for locating translation or glossary
              records (see comments in vt/_find.w).
Called By:    vt/_find.w
*/

RUN adecomm/_setcurs.p ("WAIT":U).

IF IgnoreSpaces:CHECKED THEN DO:
  IF MatchCase:CHECKED THEN DO:
    IF UseWildCards:CHECKED
      THEN FIND {3} {1} WHERE TRIM({1}.{2}) MATCHES TRIM(tValCS) NO-LOCK NO-ERROR.
      ELSE FIND {3} {1} WHERE COMPARE(TRIM({1}.{2}), "=":U, TRIM(tValCS), "CASE-SENSITIVE":U)
                        NO-LOCK NO-ERROR.
  END.
  ELSE DO: /* Not Case sensitive */
    IF UseWildCards:CHECKED
      THEN FIND {3} {1} WHERE TRIM({1}.{2}) MATCHES TRIM(FindValue) NO-LOCK NO-ERROR.
      ELSE FIND {3} {1} WHERE COMPARE(TRIM({1}.{2}), "=":U, TRIM(FindValue), "CAPS":U)
                        NO-LOCK NO-ERROR.
  END.
END.  /* IF ignore spaces */
ELSE DO: /* Don't ignore spaces */
  IF MatchCase:CHECKED THEN DO:
    IF UseWildCards:CHECKED
      THEN FIND {3} {1} WHERE {1}.{2} MATCHES tValCS NO-LOCK NO-ERROR.
      ELSE FIND {3} {1} WHERE COMPARE({1}.{2}, "=":U, tValCS, "CASE-SENSITIVE":U)
                        NO-LOCK NO-ERROR.
  END.
  ELSE DO: /* Not Case sensitive */
    IF UseWildCards:CHECKED
      THEN FIND {3} {1} WHERE ({1}.{4} BEGINS FindValueBegins)
                          AND ({1}.{2} MATCHES FindValue)
                        NO-LOCK NO-ERROR.
      ELSE FIND {3} {1} WHERE ({1}.{4} BEGINS FindValueBegins)
                          AND (COMPARE({1}.{2}, "=":U, FindValue, "CAPS":U))
                        NO-LOCK NO-ERROR.
  END.
END.  /* Don't ignore spaces */

RUN adecomm/_setcurs.p ("":U).
