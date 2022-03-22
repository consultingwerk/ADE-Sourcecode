/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _undrect.p

Description: Undelete's a rectangle widget.

Input Parameters: uRecId - RecID of object of interest.

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

CREATE RECTANGLE _U._HANDLE
    ASSIGN {adeuib/std_attr.i &NO-FONT   = YES
                              &SIZE-CHAR = YES }       
           EDGE-PIXELS   = _L._EDGE-PIXELS
           FILLED        = _L._FILLED
           GROUP-BOX     = _L._GROUP-BOX
           ROUNDED       = _L._ROUNDED
      TRIGGERS:
        {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_F._FRAME"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = _L._REMOVE-FROM-LAYOUT}

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

{ adeuib/rstrtrg.i } /* Restore triggers */
