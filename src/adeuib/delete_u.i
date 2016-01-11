/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

File: delete_u.i

Description:
   Include file that deletes the widgets for the current _U record.
   [Called from wind-close, dialog-close, delselected.]
   
   This routine deletes frame level widgets and their children and
   selects the _U record as DELETED and not selected.  It also deletes
   windows with their popup-menus and menubars (but not children).
   
Input Parameters:
   &TRASH  -  True if objects are to be truely deleted, else select the objects
              as being deleted. 

	This &TRASH parameter was implemented by Ross Hunter on March 12,
	1993.  I am concerned that we will want to undo it someday, when
	we allow undoing of window and dialog box deletion.  In general,
	I don't like destroying information.  On the other hand, it is nice
	to "clean-up" and not keep unwanted temp-table records around.
	Currently delete_u.i is invoked from 7 places in uibmproc.i and
	uibmtrig.i.  These places are:
	   In uibmproc.i:                                           &TRASH
		1) In DeleteDialogBoxes to delete a dialog box			TRUE
		2) In DeleteSelectedComposite to delete frames			FALSE
		3) In delselected to delete to delete selected objects	FALSE
		4) In dialog-close to close a dialog box				TRUE
		5) In wind-close to close a window						TRUE
	   In uibmtrig.i:
		6) In CHOOSE OF MENU-ITEM mi_close to close a window	TRUE
		7) In CHOOSE OF MENU-ITEM mi_cut to cut objects			TRUE

Output Parameters:
   <None>

Note:  This routine should never be called when _U is a LABEL.  (this is because
       it will also delete the linked fill-in without also deleting the triggers
       on the fill-in.).
       
Author: D. Ross Hunter,  Wm.T.Wood

Created: 12/11/92
Updated: 12/9/97 adams added WebSpeed support
         03/12/98 SLK ADM1 and ADM2 syntax
         03/26/98 SLK Deleted _BC records for a SmartData
         07/24/98 HD  Delete _BC for any query (HTML report and detail) 
                      If query run adeweb/_unmapal.p.
                      RUN DeleteObject in the handle of the treeview.
                      Do not publish "ab_objectdeleted", as this fires off
                      the call to ALL open treeviews.
         07/24/98 HD  use index _x-recid in for each x_u, because name 
                      may change when unmappng a query.      
         08/09/00 JEP Do not delete treeview object when its an HTML Field
                      and its a non-TRASH (temporary) delete.
         09/30/01 JEP IZ 1520 _U record error when adding activex to window.
                      Fix: Clear stale com-handle (_COM-HANDLE = ?).
  
  Notes:
----------------------------------------------------------------------------*/
DEFINE BUFFER x_U    FOR _U.
DEFINE BUFFER x_L    FOR _L.
DEFINE BUFFER xlbl_U FOR _U.
DEFINE BUFFER xlbl_L FOR _L.
DEFINE BUFFER x_F    FOR _F.
DEFINE BUFFER x_P    FOR _P.

DEFINE VARIABLE admVersion      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE h_temp_parent   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSO_popup_menu  AS WIDGET-HANDLE NO-UNDO.

FIND x_P WHERE x_P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.

/* Delete all children of a frame .  (Don't delete LABELS here.  
   Do labels when we do FILL-INs).  NOTE that we use an index which
   is NOT the PRIMARY one.  The PRIMARY index is HANDLE, and this
   routine will delete all widgets, making x_U._HANDLE = ? (and
   causing x_U to appear twice in the FOR EACH). 
   Don't use NAME because if one of the objects is a query in a HTML object
   it will be unmapped which changes the name. 
   _x-recid is the only index that don't change 
   */
IF CAN-DO("FRAME,WINDOW,DIALOG-BOX,QUERY", _U._TYPE) THEN DO:
  FOR EACH x_U WHERE x_U._PARENT-RECID = RECID(_U) 
                 AND RECID(x_U)       NE RECID(_U)
                 AND NOT (x_U._TYPE eq "TEXT":U AND x_U._SUBTYPE eq "LABEL":U)
               USE-INDEX _x-recid:

    /* Recursively delete SmartObjects or Frames that are children of this 
       object.  Delete all "Field level" widgets in line. */
    IF CAN-DO("Frame,SmartObject,QUERY":U, x_U._TYPE) 
    THEN RUN adeuib/_delet_u.p (INPUT RECID(x_U), INPUT {&TRASH}).
    ELSE DO:
      FIND _F WHERE RECID(_F) = x_U._x-recid NO-ERROR.
      IF NOT AVAILABLE _F THEN 
        FIND _C WHERE RECID(_C) = x_U._x-recid NO-ERROR.
      IF AVAILABLE _F OR AVAILABLE _C THEN DO: /* Not a Menu */
        FOR EACH _TRG WHERE _TRG._wRECID = RECID(x_U):
          IF {&TRASH} THEN DELETE _TRG.
          ELSE ASSIGN _TRG._STATUS = "DELETED".
        END.
        
        /* Check to see if object has a menu        */
        IF x_U._POPUP-RECID NE ?
        THEN RUN adeuib/_delmenu.p (x_U._POPUP-RECID, "DELETED", {&TRASH} ).
          
        /* Remove fill-in labels */
        IF x_U._l-recid ne ? THEN DO:
          FIND xlbl_U WHERE RECID(xlbl_U) = x_U._l-recid.
          IF xlbl_U._STATUS NE "DELETED" AND VALID-HANDLE(xlbl_U._HANDLE)
            THEN DELETE WIDGET xlbl_U._HANDLE.
          IF {&TRASH} THEN DO:
            FIND x_F WHERE RECID(x_F) = xlbl_U._x-recid.
            DELETE x_F.
            FOR EACH xlbl_L WHERE xlbl_L._u-recid = RECID(xlbl_U):
              DELETE xlbl_L.
            END.
            DELETE xlbl_U.
          END.
          ELSE DO:
            ASSIGN xlbl_U._HANDLE        = ?
                   xlbl_U._SELECTEDib    = FALSE
                   xlbl_U._STATUS        = "DELETED"
                   xlbl_U._WINDOW-HANDLE = ?.
            VALIDATE xlbl_U.
          END.
        END.
        
        /* Delete the x_U widget */
        IF x_U._STATUS NE "DELETED" AND VALID-HANDLE(x_U._HANDLE) THEN DO:
           IF VALID-HANDLE(x_U._PROC-HANDLE) THEN
             RUN destroyObject IN x_U._PROC-HANDLE.
           ELSE
             DELETE WIDGET x_U._HANDLE.
        END.

        /* Mark the _U record as deleted (or just Trash it). */	 
        IF {&TRASH} THEN DO:
          IF AVAILABLE _F THEN DO:
          
            /* If there is a OCX binary associated with this record then
             * delete it.
             */

            IF OPSYS = "WIN32":u AND (_F._VBX-BINARY <> ?)
            THEN OS-DELETE VALUE(SEARCH(ENTRY(1, _F._VBX-BINARY))).
          
            DELETE _F.
          END.
          ELSE IF AVAILABLE _C THEN DELETE _C.
          FOR EACH x_L WHERE x_L._u-recid = RECID(x_U):
            DELETE x_L.
          END.
          FOR EACH _BC WHERE _BC._x-recid = RECID(x_U):
            FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
              DELETE _TRG.
            END.
            DELETE _BC.
          END.
          /* Delete any WEB-related temp-table records for this widget. */
          FIND _HTM WHERE _HTM._U-RECID = RECID(x_U) NO-ERROR.
          IF AVAILABLE _HTM THEN DELETE _HTM.
          
          DELETE x_U.
        END.
        ELSE DO:
          ASSIGN x_U._STATUS        = "DELETED"
                 x_U._SELECTEDib    = FALSE
                 x_U._HANDLE        = ?
                 x_U._WINDOW-HANDLE = ?
                 x_U._COM-HANDLE    = ?.
          VALIDATE x_U.
        END.
      END. /* If not a menu (not available _F or _C) */
    END. /* If NOT Frame or SmartObject */
  END.  /* For each child of a Frame or Dialog-box */

  /* Remember the dialog box window (parent). */
  IF _U._TYPE = "DIALOG-BOX" 
  THEN h_temp_parent = _U._HANDLE:PARENT.
  ELSE h_temp_parent = ?.
END. /* FRAME,DIALOG-BOX,WINDOW */

/* First delete its triggers */
FOR EACH _TRG WHERE _TRG._wRECID = RECID(_U):
  IF _TRG._tSECTION EQ "_XFTR" THEN DO:
    FIND _XFTR WHERE RECID(_XFTR) = _TRG._xRECID NO-ERROR.
    IF _XFTR._DESTROY NE ? THEN
    DO ON STOP UNDO, LEAVE: 
      RUN VALUE(_XFTR._DESTROY) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.
    IF _TRG._tSPECIAL EQ "_INLINE" AND {&TRASH} THEN DELETE _XFTR.
  END.

  /* Delete freeform query code nodes in the treeview. (hdd) */
  /* Fixes bugs 19990506-025 (hdd) and 19991004-024 (jep). */
  IF CAN-DO("_OPEN-QUERY,_DISPLAY-FIELDS":U, _TRG._tSPECIAL)
     AND _TRG._STATUS <> "DELETED":U
     AND AVAILABLE X_P
     AND VALID-HANDLE(X_P._tv-proc) THEN
  DO:
    RUN deleteCodeNode IN X_P._tv-proc (_TRG._tSection, RECID(_U), _TRG._tEvent).
  END.

  IF {&TRASH} THEN DELETE _TRG.
  ELSE  ASSIGN _TRG._STATUS = "DELETED".
END. 

/* Delete any linked widgets (usually FILL-INs and their LABELS) .       */
/* Sometimes labels are not visible. Only select the ones that are seen. */
/** */
/* Also, the linked _U might not point to a real widget (because we cast */
/* a fill-in to an editor, and we don't support labels on editors).  So  */
/* only delete the widget if it exists [wood 10/93 (Metamorph hack)]     */
IF _U._l-recid ne ? THEN DO:
  FIND xlbl_U WHERE RECID(xlbl_U) = _U._l-recid.
  IF VALID-HANDLE (xlbl_U._HANDLE) THEN DELETE WIDGET xlbl_U._HANDLE.
  IF {&TRASH} THEN DO:
    FIND x_F WHERE RECID(x_F) = xlbl_U._x-recid.
    FOR EACH xlbl_L WHERE xlbl_L._u-recid = RECID(xlbl_U):
      DELETE xlbl_L.
    END.
    DELETE x_F.
    DELETE xlbl_U.
  END.
  ELSE DO:
    ASSIGN xlbl_U._HANDLE        = ?
           xlbl_U._SELECTEDib    = FALSE
           xlbl_U._STATUS        = "DELETED"
           xlbl_U._WINDOW-HANDLE = ?.
    VALIDATE xlbl_U.
  END.
END.

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 Get the extension (_S, _C or _F) record for the object and delete it. */

IF _U._TYPE ne "SmartObject":U THEN DO:
  FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
  IF NOT AVAILABLE _C THEN 
    FIND _F WHERE RECID(_F) = _U._x-recid.
  ELSE DO:
    /* Delete a window's menubar */
    IF _C._menu-recid NE ?
    THEN RUN adeuib/_delmenu.p (_C._menu-recid, "DELETED", {&TRASH}).
  END.

  /* Check to see if object has a popup menu and delete it. */
  IF _U._POPUP-RECID NE ?
  THEN RUN adeuib/_delmenu.p (_U._POPUP-RECID, "DELETED", {&TRASH}).
  
  /* Unmap all tables in query */
  IF NOT {&TRASH} AND _U._TYPE = "QUERY":U AND _U._TYPE <> "SmartDataObject":U THEN
  DO: 
    /* This file is only available and needed if webspeed is installed 
      ( NO-ERROR will still give error). */
    IF SEARCH('adeweb/_unmapal.r') <> ? OR SEARCH('adeweb/_unmapal.p') <> ? THEN
      RUN adeweb/_unmapal.p(RECID(_U),"QUERY":U).
  END. 
  /* Delete the widget (and the dialog/window if necessary) */
  IF VALID-HANDLE(_U._HANDLE) THEN DO:
    IF VALID-HANDLE(_U._PROC-HANDLE) THEN
       RUN destroyObject IN _U._PROC-HANDLE.
    ELSE
       DELETE WIDGET _U._HANDLE.
    _U._HANDLE = ?.
    VALIDATE _U.
  END.
  
  IF h_temp_parent <> ? AND  VALID-HANDLE(h_temp_parent)
  THEN DELETE WIDGET h_temp_parent.
         
END.
ELSE DO:  /* 'destroy' SmartObjects instead of deleting them. */

  /* We will use _S record later. */
  FIND _S WHERE RECID(_S) = _U._x-recid.
  
  /* Has the SmartObject already been deleted? */
  IF _U._STATUS ne "DELETED" THEN DO:   
    IF VALID-HANDLE(_U._HANDLE) THEN DO:
      /* Find the dyamic popup-menu we created on the frame. The
         handle won't be valid if the object was never created. */       
      hSO_popup_menu = _U._HANDLE:POPUP-MENU.
      IF VALID-HANDLE(hSO_popup_menu) THEN DELETE WIDGET hSO_popup_menu.  
      /* Find the dyamic popup-menu we created on the affordance.  Delete it
         and the affordance.  NOTE: on the off chance that the SmartObject 
         itself deleted the affordance, check to make sure the affordance is
         still valid. */       
      IF VALID-HANDLE(_S._affordance-handle) THEN DO:
        hSO_popup_menu = _S._affordance-handle:POPUP-MENU.
        IF VALID-HANDLE(hSO_popup_menu) THEN DELETE WIDGET hSO_popup_menu.  
        DELETE WIDGET _S._affordance-handle.
      END.    
    END. /* IF VALID-HANDLE (_U._HANDLE)... */
    
    /* Is it a valid object, or just a place holder? */
    IF _S._valid-object THEN DO:
      /* Determine the adm version */
      {adeuib/admver.i _S._HANDLE admVersion}
     
      IF admVersion LT "ADM2":U THEN
      DO:
         /* Save the current settings.  We will need this if we have to 
            undelete it later. */
         RUN get-attribute-list IN _S._HANDLE (OUTPUT _S._settings) NO-ERROR.
         /* Destroy the SmartObject */
         RUN dispatch IN _S._HANDLE ("destroy") NO-ERROR.
      END. /* ADM1 */
      ELSE
      DO:
         /* Save the current settings.  We will need this if we have to 
            undelete it later. */
         _S._settings = DYNAMIC-FUNCTION("instancePropertyList":U IN _S._HANDLE,"":U) NO-ERROR.
         /* Destroy the SmartObject */
         RUN destroyObject IN _S._HANDLE NO-ERROR.
      END. /* > ADM1 */
   
      /* Did this fail to destroy the procedure?  If so, try to
         manually delete it.  [NOTE: a SmO that is active in the UIB
         could try to delete itself.  The Object won't actually go away.
         This is one case where DESTROY won't work.  Ultimately, it will. */
      IF VALID-HANDLE (_S._HANDLE) THEN DO:
        DELETE PROCEDURE _S._HANDLE.
        _S._HANDLE = ?.
        VALIDATE _S.
      END. /* VALID-HANDLE (_S._HANDLE) */                   
    END. /* IF a valid-object... */

    /* Note that some Code-only SmartObjects have a dynamic realization
       that must also be deleted. (Note: hide any remaining "orphan"
       static widgets left over once the object is deleted.) */ 
    IF VALID-HANDLE(_U._HANDLE) THEN DO:
      /* There is a core but that causes selected frames to leave
         a dummy rectangle when they are deleted -- so unselect it .
         (GUI #95-03-07-022 Selected Frames Does not hide selection) */
      IF _U._HANDLE:SELECTED THEN _U._HANDLE:SELECTED = NO.
      /* Now delete */
      IF _U._HANDLE:DYNAMIC THEN DO:
        DELETE WIDGET _U._HANDLE.
        _U._HANDLE = ?.
        VALIDATE _U.
      END.
      ELSE _U._HANDLE:HIDDEN = YES.
    END.
  END. /*  SmartObject in not DELETED */
END. /* Type eq SmartObject */ 

/* Just deleted the widget now select it as deleted internally. */
IF {&TRASH} THEN
DO:
  /* Get rid of associated record */
  IF AVAILABLE _F AND RECID(_F) eq _U._x-recid THEN DO:
  
    /* If there is a OCX binary associated with this record then
     * delete it
     */
    IF OPSYS = "WIN32":u AND (_F._VBX-BINARY <> ?)
    THEN OS-DELETE VALUE(SEARCH(ENTRY(1, _F._VBX-BINARY))).
          
    DELETE _F.
  END.
  ELSE IF AVAILABLE _S AND RECID(_S) eq _U._x-recid THEN DO:   
    /* SmartObject -- delete associated links as well */
    DELETE _S.
    /* Delete any ADM Links which references this _U */
    FOR EACH _admlinks WHERE _admlinks._link-source = STRING(RECID(_U)) OR
                             _admlinks._link-dest   = STRING(RECID(_U)):
      DELETE _admlinks.
    END. 
  END. /* AVAILABLE _S (SmartObject) */
  ELSE IF AVAILABLE _C AND RECID(_C) eq _U._x-recid THEN DO:
    /* Container -- Delete _Q if available */
    IF _C._q-recid ne ? THEN DO:
      FIND _Q WHERE RECID(_Q) eq _C._q-recid.
      IF AVAILABLE _Q THEN DELETE _Q.
    END.
    DELETE _C. 
  END. /* AVAILABLE _C (Frame, Dialog, or Window) */
  /* Get rid of layout records */
  FOR EACH _L WHERE _L._u-recid = RECID(_U):
    DELETE _L.
  END.
  /* Delete any browse-columns if _U is a BROWSE widget 
   *                                 or a SmartData object */
  IF  _U._TYPE = "BROWSE":U OR 
      _U._TYPE = "QUERY":U       
      /*  AND _U._SUBTYPE = "SmartDataObject":U)*/ THEN
  DO:
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
      FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
        DELETE _TRG.
      END.
      DELETE _BC.
    END.
  END.  /* If it is a Browse or SmartData */
  
  
  /* Delete any WEB-related temp-table records for this widget. */
  FIND _HTM WHERE _HTM._U-RECID = RECID(_U) NO-ERROR.
  IF AVAILABLE _HTM THEN DELETE _HTM.
  
  /* Make sure the _selectedib is set to false, to avoid errors when
     treeview calls changewidg when it moves focus to another node.*/
  
  ASSIGN _U._STATUS        = "DELETED"
         _U._SELECTEDib    = FALSE
         _U._HANDLE        = ?
         _U._WINDOW-HANDLE = ?
         _U._COM-HANDLE    = ?.
  
  /* Tell the tree view that a _U has been deleted. 
     Do this AFTER _selectedib is set to false, to avoid errors when
     treeview calls changewidg when it moves focus to another node. */
  IF AVAILABLE X_P AND VALID-HANDLE(X_P._tv-proc) THEN
    RUN DeleteObject IN X_P._tv-proc (RECID(_U)).
  
  /*
  PUBLISH "ab_objectdeleted":U (RECID(_U)).
  */

  /* Now get rid of the Universal widget record */
  DELETE _U.
END. /* IF {&TRASH} */
ELSE /* IF NOT {&TRASH} */
DO:
   /* If we aren't TRASHing the object, we probably want to recreate from the
      AB temp-tables. */
   ASSIGN _U._STATUS        = "DELETED"
          _U._SELECTEDib    = FALSE
          _U._HANDLE        = ?
          _U._WINDOW-HANDLE = ?
          _U._COM-HANDLE    = ?.
   VALIDATE _U.
  
  /* Tell the tree view that a _U has been deleted. 
     Do this AFTER _selectedib is set to false, to avoid errors when
     treeview calls changewidg when it moves focus to another node. */
  IF AVAILABLE X_P AND VALID-HANDLE(X_P._tv-proc) THEN
  DO:
     /* Check if the object is an HTML Mapping Field. If so, we don't need to 
     remove it from the Treeview display. This call would typically come as part 
     of a _recreat.p call, such as when changing an HTML Field's data type or 
     initial value from its Property Sheet. The call would come in as TRASH = 
     FALSE. Since nothing about the field in the Treeview object has changed and 
     the object is being recreated anyways, we don't remove the object. Doing 
     so leads to problems recreating the field with the _und* calls. The calls 
     don't handle the undo delete (recreate) of objects displayed in a Treeview. 
     Further, HTML Fields were never intended to be deleted anyways. Note that 
     when TRASHing the object (see the DeleteObject call a few lines above here) 
     we always remove the Treeview object.   -jep 08/09/2000 */
     FIND _HTM WHERE _HTM._U-recid = RECID(_U) NO-ERROR.
     IF NOT AVAILABLE _HTM THEN
       RUN DeleteObject IN X_P._tv-proc (RECID(_U)).
  END.
  /*
  PUBLISH "ab_objectdeleted":U (RECID(_U)).
  */ 
END. /* IF NOT {&TRASH} */

/* delete_u.i - end of file */
