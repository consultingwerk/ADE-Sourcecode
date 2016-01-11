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

{ prodict/dump/loaddefs.i }
{ prodict/dictvar.i }

DEFINE VARIABLE i AS INTEGER NO-UNDO.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
  FIND FIRST _File WHERE _File._Dump-name = ?
                     AND NOT _File._File-name BEGINS "_" 
                     AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
ELSE
  FIND FIRST _File WHERE _File._Dump-name = ?
                     AND NOT _File._File-name BEGINS "_".
                                          
IF AVAILABLE _File THEN DO TRANSACTION:
  HIDE MESSAGE NO-PAUSE.
  IF TERMINAL <> "" AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN
     MESSAGE "Assigning Dump-names".
  RUN "prodict/dump/_lodname.p".
END.

IF dblangcache <> "" THEN DO TRANSACTION:
  HIDE MESSAGE NO-PAUSE.
  IF TERMINAL <> "" AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN
     MESSAGE "Marking SQL tables".
  DO i = 1 TO NUM-ENTRIES(dblangcache):
    FIND _File WHERE RECID(_File) = INTEGER(ENTRY(i,dblangcache)) NO-ERROR.
    IF AVAILABLE _File AND _File._Db-lang = 0 THEN _File._Db-lang = 1.
  END.
END.

IF frozencache <> "" THEN DO TRANSACTION:
  HIDE MESSAGE NO-PAUSE.
  IF TERMINAL <> "" AND CURRENT-WINDOW:MESSAGE-AREA = yes THEN
     MESSAGE "Marking FROZEN tables".
  DO i = 1 TO NUM-ENTRIES(frozencache):
    FIND _File WHERE RECID(_File) = INTEGER(ENTRY(i,frozencache)) NO-ERROR.
    IF AVAILABLE _File AND NOT _File._Frozen THEN _File._Frozen = TRUE.
  END.
END.

HIDE MESSAGE NO-PAUSE.
RETURN.
