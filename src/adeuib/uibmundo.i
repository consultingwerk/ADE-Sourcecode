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

File: uibmundo.i

Description:
   The internal procedures of the main routine of the UIB 
     - UNDO procedures
     - Cut procedures
     - Paste procedure

Input Parameters:
   <None> 
Output Parameters:
   <None>

Author: Ravi-Chander Ramalingam

Date Created: 1993

----------------------------------------------------------------------------*/
/* ======================================================================= */
/*                       Support for Undo                                  */
/* ======================================================================= */

/* Look at the Action History and delete records that have just a Start
   and an End defined.  This situation occurs when we cut objects */

PROCEDURE ActionHistoryCheck.
  DEFINE VARIABLE start AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
  DEFINE BUFFER t_action FOR _action.
  ACTION-BLOCK:
  FOR EACH _action:
    IF _action._operation BEGINS "Start" THEN DO:
       ASSIGN start = _action._seq-num
              cnt   = 0.
    END. /* START ACTION RECORD */
    ELSE IF _action._operation BEGINS "End" THEN DO:
      IF cnt = 0 THEN DO:
        DELETE _action. /* delete the end record */
        FIND t_action WHERE t_action._seq-num = start NO-ERROR.
        IF AVAILABLE t_action  
        THEN DELETE t_action. /* delete the start record */
        ELSE DO:
          RUN ResetActionRecords ("ActionHistoryCheck":U).
          LEAVE ACTION-BLOCK.
        END.
      END.
    END. /* END ACTION RECORD */
    ELSE DO:
      cnt = cnt + 1.
    END. /* ACTION RECORD */
  END.  /* FOR EACH */

  /* If we have purged any records, update the menu to be right */
  FIND LAST _action NO-ERROR.
  IF AVAILABLE _action THEN
    RUN UpdateUndoMenu( "&Undo " + SUBSTRING(_action._operation, 4) ).
  ELSE RUN DisableUndoMenu.
END PROCEDURE. 


PROCEDURE CutSelected.
  /* Delete selected FRAME and DIALOG-BOX first. */
  RUN CutSelectedComposite.

  /* Now delete all other selected field-level widgets. */
  FOR EACH _U WHERE _U._SELECTEDib:
    FOR EACH _action WHERE _action._u-recid = RECID(_U):
      DELETE _action.
    END.
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT yes /* Trash */ ).
  END.  /* For each selected widget */

  RUN ActionHistoryCheck.

  /* Have we CUT the current widget? */
  RUN del_cur_widg_check.
END.  /* PROCEDURE CutSelected */


PROCEDURE CutSelectedComposite.
  DEFINE BUFFER t_U FOR _U.

  /* DIALOG-BOX deletes are NOT UNDOABLE, so delete them first. */
  RUN DeleteDialogBoxes.

  /* FRAME deletes ARE UNDOABLE, so create _action records for them. */  
  FOR EACH _U WHERE _U._SELECTEDib AND CAN-DO("FRAME", _U._TYPE):
    FOR EACH t_U WHERE t_U._parent-recid = RECID(_U):
      FOR EACH _action WHERE _action._u-recid = RECID(t_U):
        DELETE _action.
      END.
    END. /* Process child widgets */
    FOR EACH _action WHERE _action._u-recid = RECID(_U):
       DELETE _action.
    END. /* Process FRAME */
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* trash */ ).
  END.
END.

PROCEDURE DisableUndoMenu.
  ASSIGN _undo-menu-item:LABEL     = "&Undo"
	 _undo-menu-item:SENSITIVE = FALSE.
END.

/*
  This procedure is called when a problem has been encountered in the
  contents of the _action temp-table.  This procedure:
    a) puts up a message explaining the problem.
    b) deletes ALL records that are in the _action temp-table 
  Notes:  It is up to the calling program to reset the UNDO menu item.
*/ 
PROCEDURE ResetActionRecords:
  DEF INPUT PARAMETER msg-header AS CHAR NO-UNDO.
  MESSAGE msg-header + ": UNDO history is confused." SKIP
          "The UNDO function will be cleared."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  FOR EACH _action:
    DELETE _action.
  END.    
END.

/*
  This procedure deletes all records that are in the _action temp-table which
  are from the window or dialog-box that is being closed/deleted.
  NOTE: If the StartDelete to EndDelete records contains records that are
  from several windows, the undo leaves the unaffected records unpurged.
*/ 
PROCEDURE PurgeActionRecords.
  DEFINE INPUT PARAMETER win-handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE start AS INTEGER NO-UNDO.
  DEFINE VARIABLE endseq AS INTEGER NO-UNDO.
  DEFINE VARIABLE del-cnt AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
  DEFINE BUFFER t_action FOR _action.

  ACTION-BLOCK:
  FOR EACH _action:
    IF _action._operation BEGINS "Start" THEN DO:
       ASSIGN start   = _action._seq-num
              del-cnt = 0
              cnt     = 0.
    END. /* START ACTION RECORD */
    ELSE IF _action._operation BEGINS "End" THEN DO:
      IF del-cnt = cnt THEN DO:
        DELETE _action. /* delete the end record */
        FIND t_action WHERE t_action._seq-num = start NO-ERROR.
        IF AVAILABLE t_action
        THEN DELETE t_action. /* delete the start record */
        ELSE DO:
          RUN ResetActionRecords ("PurgeActionRecords":U).
          LEAVE ACTION-BLOCK.
        END.
      END.
    END. /* END ACTION RECORD */
    ELSE DO:
       IF _action._window-handle = win-handle THEN DO:
         DELETE _action.
         del-cnt = del-cnt + 1.
       END.
       cnt = cnt + 1.
    END. /* ACTION RECORD */
  END.  /* FOR EACH */

  /* If we have purged any records, update the menu to be right */
  FIND LAST _action NO-ERROR.
  IF AVAILABLE _action THEN
    RUN UpdateUndoMenu( "&Undo " + SUBSTRING(_action._operation, 4) ).
  ELSE RUN DisableUndoMenu.
END PROCEDURE. 


PROCEDURE UpdateUndoMenu.
  DEFINE INPUT PARAMETER cvMenuLabel AS CHARACTER.

  ASSIGN _undo-menu-item:LABEL     = cvMenuLabel
	 _undo-menu-item:SENSITIVE = TRUE.
END.
