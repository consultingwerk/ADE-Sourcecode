/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

