/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _chklblsdb.p

Description:
    For the db fields fields to be drawn via DB-FIELDS, this routine adjusts
    _frmx to allow for the longest label if the user has clicked too
    close to the left side of the frame.

Input Paramaters:
    font - font of the frame the fields are being drawn into (_L._FONT)

Output Paramaters:
    none      

Author: Marcelo Ferrante

Date Created: 10/16/2007

Notes: This file was created for the fix of OE00119743 "Cannot create SDV 
       w/ include without db connection".
       This file only handles cases where db fields (no data-source is pressent)
       are dropped in the objects. See the _chklbls.p description in order to get more
       information.
----------------------------------------------------------------------------*/

{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER ffont AS INTEGER NO-UNDO. /* frame font */

/* checks to see if fields have enough room on the left (x) by looking at
 * the fields' label and calculating it's length in that font. If the user
 * clicked too far to the left side of the frame, this routine will move
 * that x location over enough to accomodate the largest label in the
 * field list selected by the user - GFS 3/13/95 */
DEFINE VARIABLE iField      AS INTEGER NO-UNDO.
DEFINE VARIABLE iWidth      AS INTEGER NO-UNDO.
DEFINE VARIABLE cLblToCheck AS CHAR    NO-UNDO.
DEFINE VARIABLE iFields     AS INTEGER NO-UNDO.
DEFINE VARIABLE cTableName  AS CHAR    NO-UNDO.
DEFINE VARIABLE cFieldName  AS CHAR    NO-UNDO.
DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.

DEFINE BUFFER b_P FOR _P.

ASSIGN iFields = NUM-ENTRIES(_fld_names).
DO iField = 1 TO iFields:
  ASSIGN cField = ENTRY(iFields,_fld_names).
  /* Do we have at least table.field? jep-code */
  IF NUM-ENTRIES(_fld_names, ".":U) > 1 THEN
      ASSIGN cTableName = ENTRY(1, cField, ".":U)
             cFieldName = ENTRY(1,ENTRY(2, cField,".":U),"[":U).
  ELSE
      ASSIGN cTableName  = ""
             cFieldName  = cField.

  FIND dictdb._file WHERE _file-name = cTableName AND
                    LOOKUP(_OWNER,"PUB,_FOREIGN") > 0 NO-ERROR.  

  IF NOT AVAILABLE dictdb._file THEN
  DO:
    FIND b_P WHERE b_P._WINDOW-HANDLE = _h_win.
    FIND FIRST _TT WHERE _TT._p-recid = RECID(b_P)
                   AND   _TT._NAME = cTableName NO-ERROR.
    IF AVAILABLE _TT THEN
       FIND dictdb._file WHERE _file-name = _TT._LIKE-TABLE  AND
                         LOOKUP(_OWNER,"PUB,_FOREIGN":U) > 0 NO-ERROR.
  END. /*IF NOT AVAILABLE dictdb._file THEN*/

  IF AVAILABLE dictdb._file THEN
  DO:
    FIND dictdb._field OF dictdb._file WHERE _field-name = cFieldName.
    IF _field._label NE "" AND _field._label NE ? THEN 
      ASSIGN cLblToCheck = _field._label.
    ELSE DO:
      IF _field._col-label NE "" AND _field._label NE ? THEN
        ASSIGN cLblToCheck = _field._col-label.
      ELSE cLblToCheck = _field-name.
    END.
    RUN calcFrmx.
  END.  /*IF AVAILABLE dictdb._file THEN */
END. /*DO i = 1 TO iFields:*/

PROCEDURE calcFrmx.
      ASSIGN cLblToCheck = cLblToCheck + ":  ".
      IF ffont <> ? THEN
        ASSIGN iWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLblToCheck, ffont).
      ELSE ASSIGN iWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLblToCheck).
      IF _frmx < iWidth THEN
          ASSIGN _frmx = iWidth.
END PROCEDURE.
