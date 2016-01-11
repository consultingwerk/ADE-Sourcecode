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
/* 
   Program: _undcomb.p
   Purpose: Undo combo box modifications  
   Base on: _undfill.p
   Author:  RPR 2/94
   Modified:
      06/11/99  TSM  Added support for editable combo-box
*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

DEFINE VARIABLE tmpstr AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i      AS INTEGER      NO-UNDO.
DEFINE VARIABLE lIsICFRunning AS LOGICAL    NO-UNDO.
   
{src/adm2/globals.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}


DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _F       WHERE RECID(_F)       eq _U._x-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.

ASSIGN lisICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.

ASSIGN _F._FRAME    = parent_U._HANDLE
       _L._WIN-TYPE = parent_L._WIN-TYPE.
IF NOT _L._WIN-TYPE THEN _L._HEIGHT = 1.

/* Instantiate combo-box.  */
IF _L._WIN-TYPE THEN DO:
  CREATE COMBO-BOX _U._HANDLE
       ASSIGN { adeuib/std_attr.i }
              WIDTH             = _L._WIDTH * _L._COL-MULT
        TRIGGERS:
              {adeuib/std_trig.i}
        END TRIGGERS.
   IF _U._SUBTYPE NE ? THEN _U._HANDLE:SUBTYPE = _U._SUBTYPE.
END.  /* if GUI */
ELSE DO:
  CREATE TEXT _U._HANDLE
       ASSIGN { adeuib/std_attr.i }
              WIDTH             = _L._WIDTH * _L._COL-MULT
        TRIGGERS:
              {adeuib/std_trig.i}
        END TRIGGERS.
END.  /* else do - TTY */

IF lIsICFRunning THEN DO:
  IF LOOKUP(_U._CLASS-NAME,  
            DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                             INPUT "DataField":U)) <> 0 THEN
     /* Attach the edit master popup */
    RUN createDataFieldPopup IN _h_uib (_U._HANDLE).
END.  /* If ICF is running */

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _L._WIN-TYPE THEN DO:
  ASSIGN _U._HANDLE:DATA-TYPE = _F._DATA-TYPE.
  /* Set the FORMAT, LIST-ITEMS and SCREEN-VALUE.
     Use the specified format if it exists (and it is valid). */
  IF _F._FORMAT ne ? THEN ASSIGN _U._HANDLE:FORMAT = _F._FORMAT NO-ERROR. 
  _F._FORMAT = _U._HANDLE:FORMAT.

  /* Set the height, if known. */
  IF _U._SUBTYPE = "SIMPLE":U AND _L._HEIGHT ne ? THEN 
    _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT. 
 
  /* Handle LIST-ITEM-PAIRS, if defined */
  IF _F._LIST-ITEM-PAIRS NE ? AND _F._LIST-ITEM-PAIRS NE "" THEN DO:
    /* In case the user did not enter commas at the end, add them for the widget */
    DO i = 1 to NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
      tmpstr = tmpstr + ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)) + 
       (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) AND 
        SUBSTRING(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),LENGTH(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))),1,"CHARACTER":U) <> _F._DELIMITER 
        THEN _F._DELIMITER ELSE "").
    END.
    ASSIGN _U._HANDLE:DELIMITER       = _F._DELIMITER. 
    ASSIGN _U._HANDLE:LIST-ITEM-PAIRS = tmpstr NO-ERROR.
  END.
  /* If there are List-Items, then set the list and value. */ 
  ELSE IF _F._LIST-ITEMS NE ? AND _F._LIST-ITEMS NE "" THEN
    ASSIGN  _U._HANDLE:DELIMITER  = CHR(10)
            _U._HANDLE:LIST-ITEMS = _F._LIST-ITEMS.
  
  /* Set an initial value */
  IF _U._HANDLE:LOOKUP(_F._INITIAL-DATA) = 0 THEN 
    _U._HANDLE:SCREEN-VALUE = _U._HANDLE:ENTRY(1) NO-ERROR.
  ELSE 
    _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.
END.  

ELSE RUN adeuib/_sim_lbl.p (_U._HANDLE).

/* Add a label to the current widget */
{ adeuib/addlabel.i }

/* NOTE: _showlbl.p runs onframe to guarantee that the object is within
   frame boundary. */
RUN adeuib/_showlbl.p (INPUT _U._HANDLE).

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &SECTION = "GEOMETRY"} .

{ adeuib/rstrtrg.i } /* Restore triggers */


