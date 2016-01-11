/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* These PROCEDURES are shared by another file that implements the recreation
   of FRAME's when you change the NO-BOX/NO-TITLE attributes. So, please do
   not include other PROCEDURES in this file unless it needs to be used by this
   other file.
*/

/*
   Deletion of DIALOG-BOX widgets is not an UNDOABLE operation.  So
   process it separately.
*/
PROCEDURE DeleteDialogBoxes.
  DEFINE BUFFER t_U FOR _U.

  FOR EACH _U WHERE _U._SELECTEDib AND CAN-DO("DIALOG-BOX", _U._TYPE):
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT FALSE /* No trash */ ).
  END.
END.

/*
   This procedure deletes composite objects first, ie DIALOG-BOX and FRAMES.
*/
PROCEDURE DeleteSelectedComposite.
  /* FRAME deletes ARE UNDOABLE, so create _action records for them. */  
  FOR EACH _U WHERE _U._SELECTEDib AND CAN-DO("FRAME,DIALOG-BOX", _U._TYPE):
    RUN DeleteFrameContents.ip (INPUT RECID(_U)).  /* Need for recursive frames
                                                      owning frames             */
 &IF DEFINED(OEIDESERVICE_I) <> 0 &THEN             
    if OEIDEIsRunning then                          
       run CallWidgetEvent in _h_uib(input recid(_U),"DELETE").
  &endif                                          
  END. /* FOR FRAME or Dialog-BOX */
END.  /* DeleteSelectedComposite */

PROCEDURE DeleteFrameContents.ip.
  DEFINE INPUT PARAMETER frame_rec AS RECID                      NO-UNDO.
  DEFINE BUFFER t_U FOR _U.

  FOR EACH t_U WHERE t_U._parent-recid = frame_rec
                 AND t_U._STATUS <> "DELETED":
    IF t_U._TYPE = "FRAME":U THEN RUN DeleteFrameContents.ip (INPUT RECID(t_U)).
    ELSE DO:
      /* Do not put menus on the UNDO stack */
      IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU", t_U._TYPE) THEN DO:
        CREATE _action.
        ASSIGN _action._seq-num       = _undo-seq-num
               _action._operation     = "Delete"
               _action._u-recid       = RECID(t_U)
               _action._window-handle = _h_win
               _action._widget-handle = t_U._HANDLE
               _undo-seq-num          = _undo-seq-num + 1.
      END.
    END.  /* For non frame children of the frame */ 
  END. /* FOR CHILD WIDGETS OF A FRAME */

  CREATE _action.  /* For the FRAME itself */
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Delete"
         _action._u-recid       = frame_rec
         _action._window-handle = _h_win
         _undo-seq-num          = _undo-seq-num + 1.
  /* THIS IS WHERE THE WIDGETS GET DELETED */
  RUN adeuib/_delet_u.p (INPUT frame_rec, INPUT FALSE /* No trash */ ).
END. /* DeleteFrameContents.ip */
