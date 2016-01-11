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
/*----------------------------------------------------------------------------

File: _chklbls.p

Description:
    For the fields to be drawn via DB-FIELDS, this routine adjusts
    _frmx to allow for the longest label if the user has clicked too
    close to the left side of the frame.

Input Paramaters:
    font - font of the frame the fields are being drawn into (_L._FONT)

Output Paramaters:
    none      

Author: Gerry Seidl

Date Created: 1995

----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER ffont AS INTEGER NO-UNDO. /* frame font */

/* checks to see if fields have enough room on the left (x) by looking at
 * the fields' label and calculating it's length in that font. If the user
 * clicked too far to the left side of the frame, this routine will move
 * that x location over enough to accomodate the largest label in the
 * field list selected by the user - GFS 3/13/95 */
DEFINE VARIABLE i           AS INTEGER NO-UNDO.
DEFINE VARIABLE w           AS INTEGER NO-UNDO.
DEFINE VARIABLE lblToCheck  AS CHAR    NO-UNDO.
DEFINE VARIABLE num_ent     AS INTEGER NO-UNDO.
DEFINE VARIABLE hDataObject AS HANDLE  NO-UNDO.
DEFINE VARIABLE fl-name     AS CHAR    NO-UNDO.
DEFINE VARIABLE fld-name    AS CHAR    NO-UNDO.
DEFINE VARIABLE ret-msg     AS CHAR    NO-UNDO.

ASSIGN num_ent = NUM-ENTRIES(_fld_names).
DO i = 1 TO num_ent:
  /* Do we have at least table.field? jep-code */
  IF NUM-ENTRIES(_fld_names, ".":U) > 1 THEN
  DO:
      fl-name  = ENTRY(1,ENTRY(i,_fld_names),".":U).
      fld-name = ENTRY(1,ENTRY(2, entry(i,_fld_names),".":U),"[":U).
  END.
  ELSE /* SmartData Object names may be field1,field2, etc and no table. jep-code */
  DO:
      fl-name  = "".
      fld-name  = ENTRY(i,_fld_names).
  END.

  IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
    FIND dictdb._file WHERE _file-name = fl-name AND
                      LOOKUP(_OWNER,"PUB,_FOREIGN") > 0 NO-ERROR.  
  ELSE
    FIND dictdb._file WHERE _file-name = fl-name NO-ERROR.

  IF NOT AVAILABLE dictdb._file THEN DO:
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P)
                   AND   _TT._NAME = fl-name NO-ERROR.
    IF AVAILABLE _TT THEN
    DO:
      IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
        FIND dictdb._file WHERE _file-name = _TT._LIKE-TABLE  AND
                                LOOKUP(_OWNER,"PUB,_FOREIGN":U) > 0 NO-ERROR.
      ELSE
        FIND dictdb._file WHERE _file-name = _TT._LIKE-TABLE NO-ERROR.
      /* If not avail, but the Temp-Table is type "D", then its a data object
         temp-table, so go get the label info from the data object. jep-code 03/04/98 */
      IF NOT AVAILABLE dictdb._file AND _TT._TABLE-TYPE = "D" THEN
      DO:
          hDataObject = DYNAMIC-FUNC("get-proc-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT).
          IF NOT VALID-HANDLE(hDataObject) THEN NEXT.
          lblToCheck = DYNAMIC-FUNC("columnLabel" IN hDataObject, fld-name).
          IF (lblToCheck <> "") AND (lblToCheck <> ?) THEN RUN calcFrmx.
          NEXT.
      END.
    END.
  END.
  IF AVAILABLE dictdb._file THEN DO:
    FIND dictdb._field OF dictdb._file WHERE _field-name = fld-name.
    IF _field._label NE "" AND _field._label NE ? THEN 
      ASSIGN lblToCheck = _field._label.
    ELSE DO:
      IF _field._col-label NE "" AND _field._label NE ? THEN
        ASSIGN lblToCheck = _field._col-label.
      ELSE lblToCheck = _field-name.
    END.
    RUN calcFrmx.
  END.  /* If we found the file */
END.
IF AVAILABLE _P THEN
  ret-msg = DYNAMIC-FUNC("shutdown-proc" IN _h_func_lib, INPUT _P._DATA-OBJECT).

PROCEDURE calcFrmx.

      ASSIGN lblToCheck = lblToCheck + ":  ".
      IF ffont <> ? THEN
        ASSIGN w = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(lblToCheck,ffont).
      ELSE ASSIGN w = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(lblToCheck).
      IF _frmx < w THEN ASSIGN _frmx = w.

END PROCEDURE.
