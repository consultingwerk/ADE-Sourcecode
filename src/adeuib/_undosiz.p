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
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER cvData AS CHARACTER NO-UNDO. /* X,Y,WIDTH,HEIGHT */
DEFINE VARIABLE whObject AS WIDGET-HANDLE NO-UNDO.

FIND _U WHERE RECID(_U) = uRecId.
FIND _L WHERE RECID(_L) = _U._lo-recid.

ASSIGN whObject                  = _U._HANDLE
       whObject:HIDDEN           = TRUE
       _L._COL                   = DECIMAL(TRIM(ENTRY(1, cvData,"|":U)))
       _L._ROW                   = DECIMAL(TRIM(ENTRY(2, cvData,"|":U)))
       _L._WIDTH                 = DECIMAL(TRIM(ENTRY(3, cvData,"|":U)))
       _L._HEIGHT                = DECIMAL(TRIM(ENTRY(4, cvData,"|":U)))
       whObject:COL              = ((_L._COL - 1) * _L._COL-MULT) + 1 
       whObject:ROW              = ((_L._ROW - 1) * _L._ROW-MULT) + 1 
       whObject:WIDTH            = _L._WIDTH * _L._COL-MULT
       whObject:HEIGHT           = _L._HEIGHT * _L._ROW-MULT
       .

/* If a SmartObject has been resized.  Make sure that the widget knows about
   the new size (so that it can respond to the size change).   We do this
   by sending the Object the "set-size" method. This is done in the
   "_setsize" procedure which also resizes our visualizations. */
IF _U._TYPE eq "SmartObject":U THEN
  RUN adeuib/_setsize.p (uRecID, _L._HEIGHT * _L._ROW-MULT, 
                                 _L._WIDTH * _L._COL-MULT).
ELSE IF CAN-DO("FILL-IN,COMBO-BOX", _U._TYPE) THEN 
  RUN adeuib/_showlbl.p(whObject).  

/* Show the recently hidden object. */
whObject:HIDDEN = FALSE. 

/* Make sure that the object is internally ie. in the temp-table and
   externally have the same marked selected state.  If this is not true,
   the undo stack gets corrupted.  Also, hiding and viewing the widget
   will cause the selection markings on the widget to be lost. */

IF whObject:SELECTED NE _U._SELECTEDib THEN ASSIGN whObject:SELECTED = _U._SELECTEDib.
