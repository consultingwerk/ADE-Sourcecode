/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* this splits the filename prefix from the basename */

DEFINE INPUT  PARAMETER filename AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER fiprefix AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER basename AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
basename = filename.

IF CAN-DO("MSDOS,WIN32,UNIX",OPSYS) THEN DO:
  i = INDEX(basename,":").
  DO WHILE i > 0:
    ASSIGN
      basename = SUBSTRING(basename,i + 1)
      i        = INDEX(basename,":").
  END.
END.

IF CAN-DO("MSDOS,WIN32,UNIX",OPSYS) THEN DO:
  i = MAXIMUM(INDEX(basename,"~\"),INDEX(basename,"/")).
  DO WHILE i > 0:
    ASSIGN
      basename = SUBSTRING(basename,i + 1)
      i        = MAXIMUM(INDEX(basename,"~\"),INDEX(basename,"/")).
  END.
END.

fiprefix = SUBSTRING(filename,1,LENGTH(filename) - LENGTH(basename)).
RETURN.
