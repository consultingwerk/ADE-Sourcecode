/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undsele.p

Description: Undelete a SELECTION-LIST widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
   
{src/adm2/globals.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VARIABLE ldummy AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tmpstr AS CHARACTER NO-UNDO.
DEFINE VARIABLE i      AS INTEGER   NO-UNDO.

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

CREATE SELECTION-LIST _U._HANDLE
    ASSIGN { adeuib/std_attr.i }       
           DELIMITER     = (IF _F._LIST-ITEM-PAIRS NE ? AND
                               _F._LIST-ITEM-PAIRS NE "":U THEN "," ELSE CHR(10)) /* This allows commas in list-items */
           SCROLLBAR-H   = _F._SCROLLBAR-H
           SCROLLBAR-V   = _U._SCROLLBAR-V
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

IF _DynamicsIsRunning THEN DO:
  IF LOOKUP(_U._CLASS-NAME,  
            DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                             INPUT "DataField":U)) <> 0 THEN
    /* Attach the edit master popup */
    RUN createDataFieldPopup IN _h_uib (_U._HANDLE).
END.  /* If ICF is running */

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

/* Set Widget Size .  WIDTH and HEIGHT could be unknown, in which case
   we don't reset the default size returned by the system. */
IF _L._WIDTH  ne ? THEN _U._HANDLE:WIDTH  = _L._WIDTH * _L._COL-MULT.
IF _L._HEIGHT ne ? THEN _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT.

/* Set the LIST-ITEMS or LIST-ITEM-PAIRS */
IF _F._LIST-ITEMS NE ? AND _F._LIST-ITEMS NE "" THEN
  ldummy = _U._HANDLE:ADD-LAST(_F._LIST-ITEMS).
ELSE IF _F._LIST-ITEM-PAIRS NE ? AND _F._LIST-ITEM-PAIRS NE "" THEN DO:
  /* In case the user did not enter commas at the end, add them for the widget */
  DO i = 1 to NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
    tmpstr = tmpstr + ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)) + 
     (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) AND 
      SUBSTRING(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),LENGTH(ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))),1,"CHARACTER":U) <> ",":U 
      THEN ",":U ELSE "").
  END.
  ASSIGN  _U._HANDLE:LIST-ITEM-PAIRS = tmpstr NO-ERROR.
END.
  
/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_F._FRAME"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = _L._REMOVE-FROM-LAYOUT}


IF NOT _L._NO-LABELS THEN DO:  /* Note: we allow labels for dynamic selection lists */
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

/* Set an initial value */
IF _U._HANDLE:LOOKUP(_F._INITIAL-DATA) = 0 THEN 
  _U._HANDLE:SCREEN-VALUE = _U._HANDLE:ENTRY(1) NO-ERROR.
ELSE 
  _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.


