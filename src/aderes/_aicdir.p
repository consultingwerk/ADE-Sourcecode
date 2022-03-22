/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _aicdir.p
*
*    Decides where the "default" icon directory is.
*/

DEFINE OUTPUT PARAMETER iconDir AS CHARACTER NO-UNDO.

DEFINE VARIABLE iconName AS CHARACTER NO-UNDO.

ASSIGN
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  FILE-INFO:FILENAME = "adeicon\progress.ico":u
  iconName           = "progress.ico":u
  &ELSE
  FILE-INFO:FILENAME = "adeicon/progress.xpm":u
  iconName           = "progress.xpm":u
  &ENDIF

  iconDir = SUBSTRING(FILE-INFO:PATHNAME, 1,
              INDEX(FILE-INFO:PATHNAME, iconName) - 1,"CHARACTER":u)
  .

IF (iconDir = ?) THEN iconDir = "".

/* _aicdir.p - end of file */

