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
/* s-quote.p - does several types of quoting */

/*
type 1:
  qbf-i = input string to be quoted
  qbf-t = ?
  qbf-o = output quoted string
This returns the string with any quotes, backslashes, left-braces or
tildas quoted with the tilde, and also converts any characters with an
ascii value of <32 or >126 into their tilde-octal number form.
Used because non-Americans want to use those characters in 4GL source
(used for national characters).

type 2:
  qbf-i = input string to be quoted
  qbf-t = quote character (e.g. ' or " )
  qbf-o = output quoted string
This will double any occurrence of qbf-t within qbf-i.  It will also
add qbf-t to each end of qbf-i.  If qbf-i is ?, qbf-o will be a quoted
question mark.
*/

DEFINE INPUT  PARAMETER qbf-i AS CHARACTER            NO-UNDO. /*inline*/
DEFINE INPUT  PARAMETER qbf-t AS CHARACTER            NO-UNDO. /*quotype*/
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL "" NO-UNDO. /*outline*/

DEFINE        VARIABLE  qbf-j AS INTEGER              NO-UNDO.
DEFINE        VARIABLE  qbf-p AS INTEGER              NO-UNDO.

IF qbf-t = ? THEN DO:

  qbf-o = qbf-i.
  DO qbf-p = 1 TO LENGTH(qbf-o):
    qbf-j = ASC(SUBSTRING(qbf-o,qbf-p,1)).
    /* 34=quote 92=backslash 123=left-brace 126=tilde */
    IF qbf-j = 34 OR qbf-j = 92 OR qbf-j = 123 OR qbf-j = 126 THEN
      ASSIGN
        SUBSTRING(qbf-o,qbf-p,1) = "~~" + SUBSTRING(qbf-o,qbf-p,1)
        qbf-p = qbf-p + 1.
    ELSE
    IF qbf-j < 32 OR qbf-j > 126 THEN
      /* Convert asc-code to octal code */
      ASSIGN
        qbf-i = STRING(TRUNCATE(qbf-j / 64,0),"9")
        qbf-j = qbf-j - INTEGER(TRUNCATE(qbf-j / 64,0)) * 64
        SUBSTRING(qbf-o,qbf-p,1) = "~~" + qbf-i
          + STRING(TRUNCATE(qbf-j / 8,0) * 10 + (qbf-j MODULO 8),"99")
        qbf-p = qbf-p + 1.
  END.

END.
ELSE DO:

  IF INDEX(qbf-i,qbf-t) > 0 THEN
    DO qbf-j = 1 TO LENGTH(qbf-i):
      qbf-o = qbf-o + (IF SUBSTRING(qbf-i,qbf-j,1) = qbf-t
              THEN qbf-t + qbf-t ELSE SUBSTRING(qbf-i,qbf-j,1)).
    END.
  ELSE
    qbf-o = qbf-i.
  qbf-o = (IF qbf-o = ? THEN "?" ELSE qbf-t + qbf-o + qbf-t).

END.

RETURN.
