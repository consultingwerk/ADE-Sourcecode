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
/* Put an escape sequenve in front of meta-characters. */
DEFINE INPUT PARAMETER src AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER trgt AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER mss-escape AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ret-unknown AS LOGICAL NO-UNDO.

DEFINE VARIABLE strt AS INT INIT 1 NO-UNDO.
DEFINE VARIABLE ind AS INT NO-UNDO.
DEFINE VARIABLE escape-seq AS CHARACTER NO-UNDO.

/* Some drivers don't support % in the search pattern */
IF src = "%" OR ret-unknown THEN src = ?.

IF src = ? OR mss-escape = ? OR mss-escape = "" OR src = "%"
THEN DO:
  trgt = src.
  RETURN.
END.

escape-seq = mss-escape + "_".
REPEAT:
  ind = INDEX (SUBSTRING(src,strt), "_").

  IF ind = 0
    THEN LEAVE.

  SUBSTRING(src, ind + strt - 1, 1) = escape-seq.
  strt = strt + ind  + 1.
END.

escape-seq = mss-escape + "%".
strt = 1.
ind = 0.
REPEAT:
  ind = INDEX (SUBSTRING(src,strt), "%").

  IF ind = 0
    THEN LEAVE.

  SUBSTRING(src, ind + strt - 1, 1) = escape-seq.
  strt = strt + ind  + 1.
END.

trgt = src.

RETURN.



