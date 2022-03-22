/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _minsize.p

Description:
    Computes the minimun size of a widget based on its contents.
    (This should be called for Windows, Frames, and Dialog-boxes).
    The minimum size is computed for the named layout.
    
    NOTE: we compute the minimum size of a SCROLLABLE frame as the
    minimum VIRTUAL-SIZE, because the minimum size is 0 x 0.  
    
    NOTE: we also count in the size of any BORDER that exists
    on the parent frame.
    
Input Parameters:
    p_Urecid - RECID of the container object
    pc_layout - Name of the layout.  If this is ? then we use the
                current layout.

Output Parameters:
    p_min-hgt - Minimum width (in PPU)
    p_min-wth - Minimum width (in PPU)

Author:  Wm.T.Wood

Date Created: July 1995

Modified: 
  
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_Urecid  AS RECID NO-UNDO.
DEFINE INPUT  PARAMETER pc_layout AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_min-hgt AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER p_min-wth AS DECIMAL NO-UNDO.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}

/* ===================================================================== */
/*                     LOCAL VARIABLES Definitions                       */
/* ===================================================================== */ 
DEFINE VAR test-wth AS DECIMAL NO-UNDO.
DEFINE VAR test-hgt AS DECIMAL NO-UNDO.

DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_L FOR _L.

FIND _U WHERE RECID(_U) eq p_Urecid.

/* Actually, everything can have a very small size except for DIALOG-BOXes
   and frames. */
ASSIGN p_min-hgt = 0
       p_min-wth = 0.
IF CAN-DO ("FRAME,DIALOG-BOX":U, _U._TYPE)
THEN DO:
  /* Find the current layout. */
  IF pc_layout eq ? THEN DO:
    FIND _L WHERE RECID(_L) eq _U._lo-recid. 
    pc_layout = _L._LO-NAME. 
  END.
  ELSE FIND _L WHERE _L._u-recid eq RECID(_U)
                 AND _L._LO-NAME eq pc_layout.
  
  /* Loop though all the children. */
  FOR EACH x_U WHERE x_U._parent-recid eq p_Urecid
                 AND x_U._STATUS ne "DELETED", 
      EACH x_L WHERE x_L._u-recid eq RECID(x_U)
                 AND x_L._LO-NAME eq pc_layout: 
     /* Find the lower/right corner of the widget. */  
     ASSIGN test-wth = x_L._COL - 1.0 + x_L._WIDTH 
            test-hgt = x_L._ROW - 1.0 + x_L._HEIGHT.
     IF test-wth > p_min-wth THEN p_min-wth = test-wth.
     IF test-hgt > p_min-hgt THEN p_min-hgt = test-hgt.
  END. 
  /* Add in any border on the frame. */
  IF _U._TYPE eq "DIALOG-BOX" OR _U._HANDLE:SCROLLABLE eq no THEN DO:
    ASSIGN
      p_min-wth = p_min-wth +
        ((_U._HANDLE:BORDER-LEFT + _U._HANDLE:BORDER-RIGHT) / _L._COL-MULT)
      p_min-hgt = p_min-hgt +
        ((_U._HANDLE:BORDER-TOP + _U._HANDLE:BORDER-BOTTOM) / _L._ROW-MULT) 
      .
  END.      
  END.      
