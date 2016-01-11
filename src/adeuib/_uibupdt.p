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

File: _uibupdt.p

Description:
    Takes a list of Context ID's, and copies the value of selected attributes
    from the object to the underlying Universal Widget Record. 
    
Input Parameters:
    pc_list - list of Context ID's, or "SELECTED".
    pc_attr - attributes to update 
                ROW
                COLUMN
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: August 1995
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pc_list AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pc_attr AS CHAR NO-UNDO.

DEF VAR hAttrEd AS HANDLE NO-UNDO.
DEF VAR j       AS INTEGER NO-UNDO.

{adeuib/uniwidg.i}   /* Universal widget definition                         */
{adeuib/layout.i}    /* Layout temp-table definition                        */
{adeuib/sharvars.i}  /* Shared variables                                    */

IF pc_list eq "SELECTED":U THEN DO:
  FOR EACH _U WHERE _U._SELECTEDib AND _U._STATUS ne "DELETED":U,
      EACH _L WHERE RECID(_L) eq _U._lo-recid:
    RUN read-attributes.
  END.
END.
ELSE DO: 
  DO j = 1 TO NUM-ENTRIES(pc_list):
    FIND _U WHERE RECID(_U) eq INTEGER(ENTRY(j, pc_list)).
    FIND _L WHERE RECID(_L) eq _U._lo-recid.
    RUN read-attributes.
  END.
END.

/* If we updated any geometry, then tell the Group Property sheet to update. */
RUN get-attribute IN _h_UIB ("Attribute-Window-Handle":U).
ASSIGN hAttrEd = WIDGET-HANDLE(RETURN-VALUE) NO-ERROR.   
IF VALID-HANDLE(hAttrEd) AND
   (CAN-DO (pc_attr, "COLUMN":U) OR CAN-DO(pc_list, "ROW":U) OR
    CAN-DO (pc_attr, "WIDTH":U) OR CAN-DO(pc_list, "HEIGHT":U))
THEN RUN show-geometry IN hAttrEd NO-ERROR.
/* FONT needs to update all attributes. */
IF VALID-HANDLE(hAttrEd) AND CAN-DO (pc_attr, "FONT":U)
THEN RUN show-attributes IN hAttrEd NO-ERROR.

/* *********************** Internal Procedures ***************************** */

/* Reads the attribute for the current _U and _L record. */
PROCEDURE read-attributes:     
  DEF VAR cnt AS INTEGER NO-UNDO.
  DEF VAR i   AS INTEGER NO-UNDO.
   
  /* Process each attribute. */           
  cnt = NUM-ENTRIES (pc_attr).
  DO i = 1 TO cnt:
    CASE ENTRY(i, pc_attr):    
    
      WHEN "COLUMN":U THEN DO:
        _L._COL = ((_U._HANDLE:COLUMN - 1.0) / _L._COL-MULT ) + 1.0.
        IF _L._WIN-TYPE eq NO THEN _L._COL = INTEGER(_L._COL).
      END.
      WHEN "WIDTH":U THEN DO:  
        _L._WIDTH = (_U._HANDLE:WIDTH-CHARS / _L._COL-MULT).
        IF _L._WIN-TYPE eq NO THEN _L._WIDTH = INTEGER (_L._WIDTH).
      END.
      WHEN "ROW":U THEN DO:
        _L._ROW = ((_U._HANDLE:ROW - 1.0) / _L._ROW-MULT ) + 1.0.
        IF _L._WIN-TYPE eq NO THEN _L._ROW = INTEGER(_L._ROW).
      END.
      WHEN "HEIGHT":U THEN DO:  
        _L._HEIGHT= (_U._HANDLE:HEIGHT-CHARS / _L._ROW-MULT).
        IF _L._WIN-TYPE eq NO THEN _L._HEIGHT = INTEGER (_L._HEIGHT).
      END.
      
      WHEN "BGCOLOR":U THEN _L._BGCOLOR = _U._HANDLE:BGCOLOR.
      WHEN "FGCOLOR":U THEN _L._FGCOLOR = _U._HANDLE:FGCOLOR.
      WHEN "FONT":U THEN _L._FONT = _U._HANDLE:FONT.
      
    END CASE.
  END.      
  
  /* If we change the position of any widget with a label, then
     make sure the label moves as well. */
  IF CAN-DO ("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U, _U._TYPE) AND
     (CAN-DO (pc_attr, "ROW":U) OR
      CAN-DO (pc_attr, "COLUMN":U))
  THEN RUN adeuib/_showlbl.p (_U._HANDLE).

END PROCEDURE.
