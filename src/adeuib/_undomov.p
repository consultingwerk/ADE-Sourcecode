/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER cvData AS CHARACTER NO-UNDO.
DEFINE VARIABLE whObject AS WIDGET-HANDLE NO-UNDO.

FIND _U WHERE RECID(_U) = uRecId.
FIND _L WHERE RECID(_L) = _U._lo-recid.

ASSIGN whObject            = _U._HANDLE
       whObject:VISIBLE    = FALSE
       _L._COL             = DECIMAL(TRIM(ENTRY(1, cvData,"|":U)))
       _L._ROW             = DECIMAL(TRIM(ENTRY(2, cvData,"|":U)))
       whObject:COLUMN     = ((_L._COL - 1) * _L._COL-MULT) + 1 
       whObject:ROW        = ((_L._ROW - 1) * _L._ROW-MULT) + 1 
       whObject:VISIBLE    = TRUE.

IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",_U._TYPE) THEN RUN adeuib/_showlbl.p(whObject).

/* Make sure that the object is internally ie. in the temp-table and
   externally have the same marked selected state.  If this is not true,
   the undo stack gets corrupted. */
IF whObject:SELECTED NE _U._SELECTEDib THEN
  ASSIGN whObject:SELECTED = _U._SELECTEDib.
