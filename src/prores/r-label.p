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
/* r-label.p - how big is this thing, really? */

/*
qbf-b = column-label
qbf-f = format
qbf-t = datatype
qbf-l = actual width of field
qbf-h = height of label in lines
*/

DEFINE INPUT  PARAMETER qbf-b AS CHARACTER         NO-UNDO.
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER         NO-UNDO.
DEFINE INPUT  PARAMETER qbf-t AS INTEGER           NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-l AS INTEGER INITIAL 1 NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-h AS INTEGER INITIAL 1 NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

ASSIGN
  qbf-c = qbf-b
  qbf-i = INDEX(qbf-b,"!!").
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-c,qbf-i,2) = "/"
    qbf-i = INDEX(qbf-c,"!!").
END.
qbf-i = INDEX(qbf-c,"!").
IF qbf-i = 0 THEN qbf-l = LENGTH(qbf-c).
DO WHILE qbf-i > 0:
  ASSIGN
    qbf-h = qbf-h + 1
    qbf-l = MAXIMUM(qbf-l,qbf-i - 1)
    qbf-c = SUBSTRING(qbf-c,qbf-i + 1)
    qbf-i = INDEX(qbf-c,"!").
  IF qbf-i = 0 THEN qbf-l = MAXIMUM(qbf-l,LENGTH(qbf-c)).
END.

qbf-l = MAXIMUM(qbf-l,{ prores/s-size.i &type=qbf-t &format=qbf-f }).

RETURN.
