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

File: _undradi.p

Description: Undelete a RADIO-SET widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

DEFINE VARIABLE lIsICFRunning AS LOGICAL    NO-UNDO.
   
{src/adm2/globals.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VARIABLE ldummy     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
DEFINE VARIABLE radio-btns AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp-label  AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp-value  AS CHARACTER NO-UNDO.
DEFINE VARIABLE val-pos    AS INTEGER   NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _F       WHERE RECID(_F)       eq _U._x-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.

ASSIGN _F._FRAME    = parent_U._HANDLE
       _L._WIN-TYPE = parent_L._WIN-TYPE.

ASSIGN lisICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.

/* NOTE: we simulate a Radio-set with an editor in TTY mode EXCEPT under
   MS-Windows, where we use the GUI representation. */
CREATE VALUE(IF _L._WIN-TYPE OR SESSION:WINDOW-SYSTEM BEGINS "MS-WIN"
             THEN "RADIO-SET":U ELSE "EDITOR":U)  _U._HANDLE
    ASSIGN { adeuib/std_attr.i &SIZE-CHAR = YES }       
      TRIGGERS:
           { adeuib/std_trig.i }
      END TRIGGERS.

IF lIsICFRunning THEN DO:
  IF LOOKUP(_U._CLASS-NAME,  
            DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                             INPUT "DataField":U)) <> 0 THEN
    /* Attach the edit master popup */
    RUN createDataFieldPopup IN _h_uib (_U._HANDLE).
END.  /* If ICF is running */

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

IF _L._WIN-TYPE OR SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
  RUN adeuib/_rbtns.p( _F._LIST-ITEMS, _F._DATA-TYPE, _F._DELIMITER, OUTPUT radio-btns).
  ASSIGN _U._HANDLE:HORIZONTAL    = _F._HORIZONTAL
         _U._HANDLE:EXPAND        = _F._EXPAND
         _U._HANDLE:DELIMITER     = _F._DELIMITER
         _U._HANDLE:RADIO-BUTTONS = radio-btns
         tmp-value                = IF _F._DATA-TYPE = "CHARACTER"
                                    THEN "~"" + _F._INITIAL-DATA + "~""
                                    ELSE _F._INITIAL-DATA
         val-pos                  = LOOKUP(tmp-value,radio-btns).
         
  /* Restore commas in labels before realization */
  DO i = 1 TO NUM-ENTRIES(radio-btns, _F._DELIMITER) BY 2:
    tmp-label = ENTRY(i,radio-btns, _F._DELIMITER).
    IF INDEX(tmp-label,
             IF _F._DELIMITER = CHR(3) THEN CHR(5) ELSE CHR(3)) > 0 THEN
      ldummy = _U._HANDLE:REPLACE(REPLACE(tmp-label,
             IF _F._DELIMITER = CHR(3) THEN CHR(5) ELSE CHR(3),_F._DELIMITER),"":U,
                          tmp-label).                    
  END.

  IF val-pos = 0 AND CAN-DO("INTEGER,DECIMAL":U,_F._DATA-TYPE) THEN DO:
    SRCH-BLK:
    REPEAT i = 2 TO NUM-ENTRIES(radio-btns) BY 2:
      IF (_F._DATA-TYPE = "INTEGER":U AND
        INTEGER(ENTRY(i,radio-btns)) = INTEGER(_F._INITIAL-DATA))
      OR (_F._DATA-TYPE = "DECIMAL":U AND
        DECIMAL(ENTRY(i,radio-btns)) = DECIMAL(_F._INITIAL-DATA))
      THEN DO:
        ASSIGN tmp-value = ENTRY(i,radio-btns)
               val-pos   = i.
        LEAVE SRCH-BLK.
      END.
    END.  /* DO 2 to num-entries */
  END.  /* if int or dec */
  IF val-pos > 0 AND val-pos MOD 2 = 0 THEN _U._HANDLE:SCREEN-VALUE = tmp-value.
END.
ELSE DO:
  /* The TTY simulation is done in a READ-ONLY, no-scrollbar editor */
  ASSIGN _U._HANDLE:WORD-WRAP            = NO
         _U._HANDLE:SCROLLBAR-HORIZONTAL = NO
         _U._HANDLE:SCROLLBAR-VERTICAL   = NO
         _U._HANDLE:READ-ONLY            = YES.
  RUN adeuib/_ttyradi.p (_U._HANDLE, _F._HORIZONTAL, _F._LIST-ITEMS).
END.

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_F._FRAME"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = _L._REMOVE-FROM-LAYOUT}
     
IF NOT _L._NO-LABELS THEN DO:  /* Note: we allow labels for dynamic radio-sets */
  /* Add a label to the current widget */
  { adeuib/addlabel.i }

  /* NOTE: _showlbl.p runs onframe to guarantee that the object is within
     frame boundary. */
  RUN adeuib/_showlbl.p (INPUT _U._HANDLE).
END.  /* If NOT no-label */

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

{ adeuib/rstrtrg.i } /* Restore triggers */

