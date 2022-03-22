/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-set.i - swap in correct language table for local needs */

qbf-langwas = (IF qbf-langwas = "" THEN qbf-langnow ELSE qbf-langwas).
IF qbf-langnow <> qbf-langset + "{&mod}{&set}" THEN
  RUN VALUE("prores/reslang/t-{&mod}-" + qbf-langset + ".p") ({&set}).
qbf-langnow = qbf-langset + "{&mod}{&set}".
