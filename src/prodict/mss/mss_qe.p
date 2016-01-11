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
/* Workaround for Q+E ODBC drivers - Create a comma seperated index comp list */

DEFINE INPUT-OUTPUT PARAM crnt AS CHAR.
DEFINE OUTPUT PARAM numcomp AS INT.

DEFINE VAR separ as int.
DEFINE VAR parrent AS int.
DEFINE VAR str-patt AS int.
DEFINE VAR ind AS int.
DEFINE VAR endlp AS logical.

IF crnt = ? THEN DO:
  numcomp = 0.
  RETURN.
END.

ind = 0.
endlp = no.
DO WHILE  NOT endlp AND crnt <> "":
  separ = INDEX(crnt, "+").
  ind = ind + 1.

  IF separ = 0 THEN DO:
    endlp = yes.
    NEXT. 
  END.
  SUBSTRING(crnt, separ, 1) = ",".

END.
numcomp = ind.

