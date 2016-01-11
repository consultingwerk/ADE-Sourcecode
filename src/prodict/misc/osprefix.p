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
