/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undbutt.p

Description: Undelete a BUTTON widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VARIABLE ldummy AS LOGICAL NO-UNDO.

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
IF NOT _L._WIN-TYPE THEN _L._HEIGHT = 1.

CREATE VALUE (IF _L._WIN-TYPE THEN "BUTTON" ELSE "TEXT") _U._HANDLE
    ASSIGN 
           {adeuib/std_attr.i}
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

/* Change button style depending if it is DEFAULT in GUI-mode. */
IF _L._WIN-TYPE AND _F._DEFAULT THEN _U._HANDLE:DEFAULT = yes.

/* Set Widget Size and LABEL.  WIDTH and HEIGHT could be unknown, in which case
   we don't reset the default size returned by the system. */
IF _L._WIN-TYPE THEN DO: /* GUI Mode */
  ASSIGN _U._HANDLE:LABEL       = _U._LABEL
         _U._HANDLE:AUTO-RESIZE = FALSE.
  IF _L._WIDTH ne ?  THEN _U._HANDLE:WIDTH = _L._WIDTH * _L._COL-MULT.
  IF _L._HEIGHT ne ? THEN _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT.
END.
ELSE DO:  /* TTY Mode Emulation - Simulate the label. */
  RUN adeuib/_sim_lbl.p (_U._HANDLE).
END.

/* Add the images (before setting the button visible), and only on GUI windows. */
IF _L._WIN-TYPE THEN DO:
  IF _F._IMAGE-FILE = ?  
  THEN _F._IMAGE-FILE = "".
  ELSE ldummy = _U._HANDLE:LOAD-IMAGE-UP(_F._IMAGE-FILE).

  /* We do not "need" to load the INSENSITIVE image because the UIB will never show
     it. However, having a DOWN image does affect the drawing of button 3-D 
     borders under MS-WINDOWS, so we need to do that */
  IF _F._IMAGE-DOWN-FILE = ? THEN _F._IMAGE-DOWN-FILE = "".
  ELSE ldummy = _U._HANDLE:LOAD-IMAGE-DOWN(_F._IMAGE-DOWN-FILE).
  IF _F._IMAGE-INSENSITIVE-FILE = ? THEN _F._IMAGE-INSENSITIVE-FILE = "".
  /* don't worry about insensitive image...
   *ELSE ldummy = _U._HANDLE:LOAD-IMAGE-INSENSITVE(_F._IMAGE-INSENSITIVE-FILE).
   */ 
END. /* IF gui ... */

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_F._FRAME"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHIDDEN      = _L._REMOVE-FROM-LAYOUT}
 
/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &SECTION = "GEOMETRY"} .


{ adeuib/rstrtrg.i } /* Restore triggers */
