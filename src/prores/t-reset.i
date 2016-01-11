/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-reset.i - put language table back the way we found it */

IF qbf-langnow <> qbf-langwas AND qbf-langwas <> "" THEN DO:
  RUN VALUE("prores/reslang/t-" + SUBSTRING(qbf-langwas,4,1) + "-"
    + qbf-langset + ".p") (INTEGER(SUBSTRING(qbf-langwas,5))).
  qbf-langnow = qbf-langwas.
END.
