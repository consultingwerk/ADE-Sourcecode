/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Include file to change American style date strings to another
   style of date strings (_orig_dte_fmt)                         
   
   The input parameter {1} is a character string variable
   containing a date in mdy format, but this changes it to the
   format of _orig_dte_fmt                                     */

DEFINE VARIABLE tmp-date        AS DATE         NO-UNDO.
DEFINE VARIABLE tmp-datetime    AS DATETIME     NO-UNDO.
DEFINE VARIABLE tmp-datetime-tz AS DATETIME-TZ  NO-UNDO.

IF _F._DATA-TYPE = "DATE":U THEN DO:
  IF {1} = "?"  OR {1} = ? THEN {1} = "".
  ELSE ASSIGN SESSION:DATE-FORMAT = "mdy":U
              tmp-date            = DATE({1})
              SESSION:DATE-FORMAT = _orig_dte_fmt
              {1}                 = STRING(tmp-date).
END.
ELSE IF _F._DATA-TYPE = "DATETIME":U THEN DO:
  IF {1} = "?"  OR {1} = ? THEN {1} = "".
  ELSE ASSIGN SESSION:DATE-FORMAT = "mdy":U
              tmp-datetime        = DATETIME({1})
              SESSION:DATE-FORMAT = _orig_dte_fmt
              {1}                 = STRING(tmp-datetime).
END.
ELSE IF _F._DATA-TYPE = "DATETIME-TZ":U THEN DO:
  IF {1} = "?"  OR {1} = ? THEN {1} = "".
  ELSE ASSIGN SESSION:DATE-FORMAT = "mdy":U
              tmp-datetime-tz     = DATETIME-TZ({1})
              SESSION:DATE-FORMAT = _orig_dte_fmt
              {1}                 = STRING(tmp-datetime-tz).
END.
