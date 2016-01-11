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
