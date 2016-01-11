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
