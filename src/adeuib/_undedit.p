/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undedit.p

Description: Undelete a EDITOR widget.

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
 
CREATE EDITOR _U._HANDLE
    ASSIGN { adeuib/std_attr.i &SIZE-CHAR = YES }       
           SCROLLBAR-H   = _F._SCROLLBAR-H
           SCROLLBAR-V   = _U._SCROLLBAR-V
           READ-ONLY   = TRUE  /* User can't edit in design mode */
           BOX         = (IF _L._NO-BOX THEN FALSE ELSE TRUE)
      TRIGGERS:
           { adeuib/std_trig.i }
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

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_F._FRAME"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = _L._REMOVE-FROM-LAYOUT}

IF NOT _L._NO-LABELS THEN DO:  /* Note: we allow labels for dynamic editors */
  /* Add a label to the current widget */
  { adeuib/addlabel.i }

  /* NOTE: _showlbl.p runs onframe to guarantee that the object is within
     frame boundary. */
  RUN adeuib/_showlbl.p (INPUT _U._HANDLE).
END.  /* If NOT no-label */

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

/* For tty mode: modify the widget to simulate a Character Terminal */
IF NOT _L._WIN-TYPE THEN
  RUN adeuib/_ttyedit.p (_U._HANDLE, _F._SCROLLBAR-H, _U._SCROLLBAR-V).

{ adeuib/rstrtrg.i } /* Restore triggers */
IF _F._INITIAL-DATA NE "" THEN
  _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.
