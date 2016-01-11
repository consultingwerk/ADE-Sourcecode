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

/* _lodfini.p - finish up .df load process */

{ as4dict/dictvar.i }
{ as4dict/load/loaddefs.i }


DEFINE VARIABLE i AS INTEGER NO-UNDO.

FIND FIRST as4dict.p__File WHERE as4dict.p__File._Dump-name = ?
  AND NOT as4dict.p__File._File-name BEGINS "_" NO-ERROR.
IF AVAILABLE as4dict.p__File THEN DO TRANSACTION:
  HIDE MESSAGE NO-PAUSE.
  IF TERMINAL <> "" AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN
     MESSAGE "Assigning Dump-names".
  RUN "as4dict/load/_lodname.p".
END.

IF frozencache <> "" THEN DO TRANSACTION:
  HIDE MESSAGE NO-PAUSE.
  IF TERMINAL <> "" AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN
     MESSAGE "Marking FROZEN tables".
  DO i = 1 TO NUM-ENTRIES(frozencache):
    FIND as4dict.p__File WHERE RECID(as4dict.p__File) = INTEGER(ENTRY(i,frozencache)) NO-ERROR.
    IF AVAILABLE as4dict.p__File AND as4dict.p__File._Frozen = "N" THEN 
       assign as4dict.p__File._Frozen = "Y".
  END.
END.

HIDE MESSAGE NO-PAUSE.
RETURN.
