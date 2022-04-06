/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: addlabel.i

Description:
    Creates a label to go with a fill-in, combo-box, or any other variable 
    label.

Assumptions:
     _U and _F are assumed to point to the widget that has the label.
     
     label_U and label_F are defined here as buffers for the label record.
     (If they don't exist, then they are created).
     
     The widget _U._HANDLE is assumed to exist.

Output Parameters:  <none>

Author: Wm.T.Wood

Date Created: February 12, 1994

----------------------------------------------------------------------------*/


DEFINE BUFFER label_U FOR _U.
DEFINE BUFFER label_F FOR _F.

/* get the label's _U and _F records */
FIND label_U WHERE RECID(label_U) = _U._l-recid NO-ERROR.
IF AVAILABLE label_U
THEN DO:
  FIND label_F WHERE RECID(label_F) = label_U._x-recid.
  label_F._FRAME = _F._FRAME.
END.
ELSE DO:
  /* Create the label record. */
  CREATE label_U.
  CREATE label_F.

  ASSIGN _U._l-recid            = RECID(label_U)
         label_U._l-recid       = RECID(_U)
         label_U._x-recid       = RECID(label_F)
         label_U._parent-recid  = _U._PARENT-RECID
         label_F._FRAME         = _F._FRAME
         label_U._SUBTYPE       = "LABEL"
         label_U._NAME          = "_LBL-" + _U._NAME
         label_U._TYPE          = "TEXT"
         .
END.

/*
   Label instantiation:
    NOTE: The screen-value and format for the label are are set in _showlbl.p.
*/
CREATE TEXT label_U._HANDLE
       ASSIGN FRAME           = label_F._FRAME
              BGCOLOR         = ?    /* Never explicitly inherit frame atts. */
              FGCOLOR         = ?
              FONT            = ?
              AUTO-RESIZE     = TRUE
       TRIGGERS:
          {adeuib/lbl_trig.i}
       END TRIGGERS.
/* Assign widget handles -- connect this label to the actual U widget. */
ASSIGN label_U._PARENT              = label_U._HANDLE:PARENT 
       label_U._WINDOW-HANDLE       = _U._WINDOW-HANDLE 
       _U._HANDLE:SIDE-LABEL-HANDLE = label_U._HANDLE
       .
 
