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

File: _undo.p

Description:
    Go to the last undoable action in the _action history, and undo it.
    We also set the Save-state for the window where an action has been undone.

Input Parameters:
   <none>
Output Parameters:
   <none>
Return Value:
   <none>

Notes: 
  (i)  When we undo-delete, we need to check all fields that are again added
       to a frame rebuild the default query.  This new query may not be the 
       same as the one that was there when the fields were deleted.  If we
       ever "undo" all actions (including adding fields) then we may want
       to revisit this.
        
Author: Wm.T.Wood

Date Created: September, 1993

----------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}     /* Universal widget definitions         */
{adeuib/layout.i}      /* Multi-layout temp-table definitions  */
{adeuib/sharvars.i}    /* Major shared variables               */
{adeuib/_undo.i}       /* Temp Table containing action history */

/* ===================================================================== */
/*                       Local Variable Definitions                      */
/* ===================================================================== */
DEFINE VAR startSequenceNumber AS INTEGER NO-UNDO.
DEFINE VAR endSequenceNumber   AS INTEGER NO-UNDO.
DEFINE VAR i                   AS INTEGER NO-UNDO.
DEFINE VAR j                   AS INTEGER NO-UNDO.  
DEFINE VAR l_UndoDelete        AS LOGICAL NO-UNDO.

DEFINE BUFFER dup_U  FOR _U.
DEFINE BUFFER m_L    FOR _L.
DEFINE BUFFER sync_L FOR _L.

/* Temp-Tables: Create records of all fields that are added to frames. */
DEFINE TEMP-TABLE tt NO-UNDO
    FIELD rFrame AS RECID
    FIELD lUndoFrame AS LOGICAL
    FIELD cFields AS CHAR
    INDEX rFrame IS UNIQUE PRIMARY rFrame.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* ===================================================================== */
/*                        Start of Executable Code                       */
/* ===================================================================== */
FIND LAST _action NO-ERROR.
IF (NOT AVAILABLE _action) THEN RETURN.  /* This should not happen */

endSequenceNumber = _action._seq-num.
startSequenceNumber = INTEGER(_action._data).

DO i = endSequenceNumber TO startSequenceNumber BY -1:
  FIND _action WHERE _action._seq-num = i.
  IF _action._operation BEGINS "Start" OR
     _action._operation BEGINS "End" THEN DO:
    DELETE _action.
  END.
  ELSE DO:   /* Process each widget that makes up this undo operation */
    FIND _U WHERE RECID(_U) = _action._u-recid.
    IF _U._SUBTYPE NE "LABEL" THEN
      FIND _L WHERE RECID(_L) = _U._lo-recid.
    _h_win = _action._window-handle.
    CASE _action._operation:
      WHEN "DELETE" THEN DO:  
        /* If this is the first time an UNDO DELETE is encountered, then
           deselect any selected widgets before proceeding. */
        IF l_UndoDelete eq NO THEN DO: 
          l_UndoDelete = YES.
          RUN deselect_all IN _h_UIB (?,?).
        END.
        /* Check to see if this is a custom layout.  If it is then just "un-hide" */
        /* the widget.                                                            */
        IF _U._LAYOUT-NAME NE "Master Layout" THEN DO:
           IF _U._SUBTYPE NE "LABEL" THEN
             ASSIGN _U._HANDLE:HIDDEN      = FALSE
                    _L._REMOVE-FROM-LAYOUT = FALSE
                    _U._STATUS             = "NORMAL":U.
           IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER",_U._TYPE) THEN 
             RUN adeuib/_showlbl.p (_U._HANDLE).
        END.  /* An alternative layout */
        ELSE DO:  /* Normal Undo */
          /* See if there is another widget with the same name and parent.
             This will stop us from undoing the delete */
          FIND dup_U WHERE dup_U._NAME   eq _U._NAME
                       AND dup_U._TABLE  eq _U._TABLE
                       AND dup_U._DBNAME eq _U._DBNAME
                       AND dup_U._parent-recid  eq _U._parent-recid
                       AND dup_U._status ne "DELETED":U
                  NO-ERROR.
          IF AVAILABLE dup_U THEN
            MESSAGE "~"Undo Delete~" is trying to recreate"
               (IF _U._TABLE ne ? 
               THEN "Database Field " +
                     _U._DBNAME + "." + _U._TABLE + "." + _U._NAME + "."
               ELSE _U._TYPE + " " + _U._NAME + ".")  {&SKP}
               "There is already an object with this name.  After you " {&SKP}
               "undelete this object, you must resolve the naming conflict." 
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
          CASE _U._TYPE:
	    WHEN "BUTTON" THEN RUN adeuib/_undbutt.p(_action._u-recid).
	    WHEN "COMBO-BOX" THEN RUN adeuib/_undcomb.p(_action._u-recid).
	    WHEN "EDITOR" THEN RUN adeuib/_undedit.p(_action._u-recid).
	    WHEN "RECTANGLE" THEN RUN adeuib/_undrect.p(_action._u-recid).
	    WHEN "IMAGE" THEN RUN adeuib/_undimag.p(_action._u-recid).
	    WHEN "QUERY" THEN RUN adeuib/_undqry.p(_action._u-recid).
	    WHEN "SLIDER" THEN RUN adeuib/_undslid.p(_action._u-recid).
	    WHEN "TEXT" THEN /* Don't Undo (redraw) Labels */
	      IF _U._SUBTYPE NE "LABEL" THEN
		RUN adeuib/_undtext.p(_action._u-recid).
	    WHEN "SELECTION-LIST" THEN RUN adeuib/_undsele.p(_action._u-recid).
	    WHEN "FILL-IN" THEN RUN adeuib/_undfill.p(_action._u-recid).
	    WHEN "TOGGLE-BOX" THEN RUN adeuib/_undtogg.p(_action._u-recid).
	    WHEN "RADIO-SET" THEN RUN adeuib/_undradi.p(_action._u-recid).
	    WHEN "FRAME" THEN RUN adeuib/_undfram.p(_action._u-recid).
	    WHEN "BROWSE" THEN RUN adeuib/_undbrow.p(_action._u-recid).
	    WHEN "{&WT-Control}" THEN DO:
	      RUN adeuib/_undcont.p(_action._u-recid).
              /* Delete the temporary OCX binary file */
              FIND _F WHERE RECID(_F) eq _U._x-recid.               
              IF AVAILABLE _F AND _F._VBX-BINARY <> ? THEN
                OS-DELETE VALUE(SEARCH(ENTRY(1, _F._VBX-BINARY))).
            END.                     
	    WHEN "SmartObject" THEN RUN adeuib/_undsmar.p(_action._u-recid).
	    OTHERWISE MESSAGE _U._TYPE + " currently not supported."
	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	  END CASE.
          /* Note that undsmar.p might have failed (for example, 
          if the SmartObject file was not found). */
          IF AVAILABLE (_U) THEN DO:
            _U._STATUS = "NORMAL".
            /* If there is a POP-UP create the popups */
            IF _U._POPUP-RECID NE ?
              THEN RUN adeuib/_undmenu.p ( _U._POPUP-RECID, _U._HANDLE ).
         
          /* Update the Dynamic Property Sheet if Dynamics is running */
         IF VALID-HANDLE(_h_menubar_proc) THEN
           RUN PropUndoWidget IN _h_menubar_proc 
                  (INPUT IF _U._TABLE > "" 
                         THEN _U._TABLE + "." + _U._NAME
                         ELSE _U._NAME,
                   INPUT _U._HANDLE) NO-ERROR.

            /* If we have undone the delete of a db.table.field, then keep a
  	     record of this so that we can modify the frame's query.
  	     Important: See note (i) above. */
          IF _U._TABLE ne ? THEN DO:
  	      FIND tt WHERE tt.rFrame eq _U._parent-recid NO-ERROR.
  	      IF NOT AVAILABLE tt THEN DO:
  	        CREATE tt.
  	        tt.rFrame = _U._parent-recid.
  	      END.
  	      IF LENGTH(tt.cFields, "raw") > 0 
  	      THEN  tt.cFields = tt.cFields + ",":U.
  	      tt.cFields = tt.cFields + 
  	                   _U._DBNAME + ".":U + _U._TABLE + ".":U + _U._NAME.
  	    END.
  	    /* Otherwise, if we are undoing a FRAME, note this in the tt record
  	       because we don't want to rebuild the query in this case */
  	    ELSE IF _U._TYPE eq "FRAME":U THEN DO:
  	      FIND tt WHERE tt.rFrame eq RECID(_U) NO-ERROR.
  	      IF NOT AVAILABLE tt THEN DO:
  	        CREATE tt.
  	        tt.rFrame = RECID(_U).
  	      END.
  	      /* Note that this frame was also undeleted */
  	      tt.lUndoFrame = YES.
  	    END.
  	  END. /* IF AVAILABLE (_U)... */
	END. /* A normal undelete */
      END. /* DELETE */

      WHEN "MOVE" OR WHEN "ALIGN" OR WHEN "TAPIT" THEN DO:
        RUN adeuib/_undomov.p(_action._u-recid, _action._data).
        IF _U._SUBTYPE NE "LABEL" THEN DO:
	  IF _action._other_Ls NE "" THEN DO:
	    DO j = 1 TO NUM-ENTRIES(_action._other_Ls) - 1:
	      FIND sync_L WHERE RECID(sync_L) = INTEGER(ENTRY(j,_action._other_Ls)).
	      ASSIGN sync_L._COL = DECIMAL(TRIM(ENTRY(1, _action._data,"|":U)))
	             sync_L._ROW = DECIMAL(TRIM(ENTRY(2, _action._data,"|":U)))
	             sync_L._CUSTOM-POSITION = FALSE.
	    END.
	  END.
	  ELSE IF _L._LO-NAME NE "Master Layout" THEN DO:
	    FIND m_L WHERE m_L._u-recid = _L._u-recid AND
	                   m_L._LO-NAME = "Master Layout".
	    IF m_L._ROW >= _L._ROW - .05 AND m_L._ROW <= _L._ROW + .05 AND
	       m_L._COL >= _L._COL - .05 AND m_L._COL <= _L._COL + .05 THEN
	      _L._CUSTOM-POSITION = FALSE.
	  END.
	END.  /* Not a label */
      END.
      
      WHEN "RESIZE" THEN DO:
        RUN adeuib/_undosiz.p(_action._u-recid, _action._data).
        IF NOT _cur_win_type AND _U._TYPE = "BUTTON" THEN
          RUN adeuib/_sim_lbl.p (_U._HANDLE).
        IF _U._SUBTYPE NE "LABEL" THEN DO:
          IF _action._other_Ls NE "" THEN DO:
            DO j = 1 TO NUM-ENTRIES(_action._other_Ls) - 1:
              FIND sync_L WHERE RECID(sync_L) = INTEGER(ENTRY(j,_action._other_Ls)).
              ASSIGN sync_L._COL    = DECIMAL(TRIM(ENTRY(1, _action._data,"|":U)))
                     sync_L._ROW    = DECIMAL(TRIM(ENTRY(2, _action._data,"|":U)))
                     sync_L._WIDTH  = DECIMAL(TRIM(ENTRY(3, _action._data,"|":U)))
                     sync_L._HEIGHT = DECIMAL(TRIM(ENTRY(4, _action._data,"|":U)))
                     sync_L._CUSTOM-SIZE = FALSE.
            END.
          END.
          ELSE IF _L._LO-NAME NE "Master Layout" THEN DO:
            FIND m_L WHERE m_L._u-recid = _L._u-recid AND
                           m_L._LO-NAME = "Master Layout".
            IF m_L._WIDTH >= _L._WIDTH - .05   AND m_L._WIDTH <= _L._WIDTH + .05 AND
              m_L._HEIGHT >= _L._HEIGHT - .05 AND m_L._HEIGHT <= _L._HEIGHT + .05 AND
              m_L._VIRTUAL-WIDTH >= _L._VIRTUAL-WIDTH  - .05 AND
              m_L._VIRTUAL-WIDTH <= _L._VIRTUAL-WIDTH  + .05 AND
              m_L._VIRTUAL-HEIGHT >= _L._VIRTUAL-HEIGHT - .05 AND 
              m_L._VIRTUAL-HEIGHT <= _L._VIRTUAL-HEIGHT + .05 THEN
              _L._CUSTOM-SIZE = FALSE.
          END.
        END.
      END.
      OTHERWISE MESSAGE _action._operation + " not processed."
	         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END CASE.
    DELETE _action.
  END.  /* ELSE DO */
END. /* DO loop */

/* Rebuild any queries for any frames where we have undeleted database fields
   (and where the frame was NOT undeleted itself). See note (i) above. */
FOR EACH tt WHERE tt.lUndoFrame eq NO AND LENGTH(tt.cFields) > 0:
   FIND _U WHERE RECID(_U) eq tt.rFrame.
   RUN adeuib/_vrfyqry.p ( _U._HANDLE, "ADD-FIELDS":U, tt.cFields).
END.

/* set the window-saved state to false, we just finished undo object(s) */
/* NOTE: Currently, the core-level does not allow selections from
     different windows.  If this is changed, only one window will get its
     window-saved state marked right and so we may not query the user to
     save their changes.  If the change does happen, we would want to
     move this code into the loop above.  This will affect performance as
     we will be setting the window saved state for each object, even when
     it may not be needed. */
IF startSequenceNumber NE endSequenceNumber
THEN RUN adeuib/_winsave.p(_h_win, FALSE).
