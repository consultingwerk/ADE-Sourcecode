/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _mstate.p
*
*    Callback function provided to the menu system.
*    This function is called anytime the UI needs
*    to know if a menu/toolbar needs to be sensitive or toggled.
*
*    The name of this function is provided to the menu system
*    at init time.
*
*    This function doesn't explicitly worry about security. Currently,
*    the design of RESULTS does not allow a menu feature or menu item
*    to be created if the user doesn't have permission to use the
*    RESULTS feature. If there's no menu item then there's no way to
*    get to here!
*
*    After this function determines the state of the item, we give
*    the admin a chance to decide if the state is correct. This allows
*    our VARs the ability to write their own code that affects the
*    state of Core Results features.
*
*    Note: Try not to be "menu centric" when thinking about availability.
*    Any feature could be added to a toolbar, and the toolbar can be
*    visible at any time. One cannot bank on the menu sensitivity of a
*    submenu to keep a feature unavailable. For example, the "Fields"
*    feature (Add/Remove Fields) is hung off the Fields menu. The Fields
*    submenu is dithered on state, but the Fields feature wasn't. But
*    one couldn't get to the Feidls feature becuase the subemnu was disabled.
*    This works fine until one considers toolbars. If someone adds the
*    Fields feature to the toolbar, it must be disabled when Results has no
*    active query.
*
* Input Parameters
*
*    handle     The handle of the menu item that is in question.
*    feature    The menu feature id of the menu item
*    prvData    The private data for the menu item. Not used here.
*
* Output Parameters
*
*    isAvail    True if the menu item should be sensitive.
*    isChecked  True if the menu item should be toggle. This is meaningless
*               for menu items that are not toggles.
*/

{ aderes/e-define.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/s-define.i }
{ aderes/s-system.i }
{ aderes/_fdefs.i }

DEFINE INPUT        PARAMETER appId       AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER featureList AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER prvHandle   AS HANDLE    NO-UNDO.
DEFINE INPUT        PARAMETER prvData     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER sensList    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER toggList    AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i        AS INTEGER   NO-UNDO.
DEFINE VARIABLE aUser        AS CHARACTER NO-UNDO.
DEFINE VARIABLE adminDefined AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-s        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE isAvail      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE isChecked    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-j        AS INTEGER   NO-UNDO.
DEFINE VARIABLE featureId    AS CHARACTER NO-UNDO.

FIND FIRST qbf-esys.
FIND FIRST qbf-lsys.
FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

DO qbf-j = 1 TO NUM-ENTRIES(featureList):
  featureId = ENTRY(qbf-j, featureList).

  /* Although featureIds can be in any menu, we'll group them by the
  * "default" setup.  */
  CASE featureId:

  /* first handle the menus in the menubar */

  WHEN {&rltablemenu} THEN isAvail = qbf-module <> ?.
  WHEN {&rlfieldmenu} THEN isAvail = qbf-module <> ?.
  WHEN {&rldata}      THEN isAvail = qbf-module <> ?.
  WHEN {&rloptions}   THEN isAvail = qbf-module <> ?.
  WHEN {&rlviewmenu}  THEN isAvail = qbf-module <> ?.
  WHEN {&rlusers}     THEN isAvail = TRUE.
  WHEN {&rlhelp }     THEN isAvail = TRUE.

  /* View Features */

  WHEN {&rfNewBrowseView} THEN isAvail = TRUE.
  WHEN {&rfNewReportView} THEN isAvail = TRUE.
  WHEN {&rfNewFormView}   THEN isAvail = TRUE.
  WHEN {&rfNewLabelView}  THEN isAvail = TRUE.
  WHEN {&rfNewExportView} THEN isAvail = TRUE.

  WHEN {&rfBrowseView}    THEN isAvail = CAN-DO("r,f,l,e",qbf-module).
  WHEN {&rfReportView}    THEN isAvail = CAN-DO("b,f,l,e",qbf-module).
  WHEN {&rfFormView}      THEN isAvail = CAN-DO("b,r,l,e",qbf-module).
  WHEN {&rfLabelView}     THEN isAvail = CAN-DO("b,r,f,e",qbf-module).
  WHEN {&rfExportView}    THEN isAvail = CAN-DO("b,r,f,l",qbf-module).
  WHEN {&rfToolBar}       THEN ASSIGN isAvail = TRUE
                                      isChecked = lGlbToolbar.
  WHEN {&rfStatusLine}    THEN ASSIGN isAvail = TRUE
                                      isChecked = lGlbStatus.

  /* File Features */

  WHEN {&rfFileOpen} THEN isAvail = _qdReadable.
  WHEN {&rfFileSave} THEN DO:
    isAvail       = FALSE.
    IF qbf-module <> ? THEN DO:
    
      /* Only allow save if the user has permission to use the
       * directories for saving */
      isAvail = TRUE.

      IF qbf-qdfile <> qbf-qdhome THEN 
        isAvail = IF qbf-qdfile = qbf-qdpubl THEN (_rPublic AND _wPublic)
                  ELSE (_rOther AND _wOther).

      /* If the user doesn't have write permission to the
       * the directory file then don't make this item available.  */
      IF NOT _qdWritable THEN
        isAvail = FALSE.
    END.
  END.
  WHEN {&rfFileSaveAs}   THEN isAvail = qbf-module <> ?.
  WHEN {&rfFileClose}    THEN isAvail = qbf-module <> ?.

  /*
  * Delete File is allowed anytime, as long as the user
  * has permission to delete the public and/or other query
  * directories.
  */
  WHEN {&rfFileDelete} THEN DO:
    isAvail = TRUE.

    IF qbf-qdfile <> qbf-qdhome THEN 
      isAvail = IF qbf-qdfile = qbf-qdpubl THEN (_rPublic AND _wPublic)
                ELSE (_rOther AND _wOther).
  END.
  WHEN {&rfGenerate}     THEN isAvail = qbf-module <> ?.
  WHEN {&rfPrintPreview} THEN 
    CASE qbf-module:
      WHEN "r":u OR WHEN "e":u THEN isAvail = TRUE.
      WHEN "l":u               THEN RUN label_field.
    END CASE.

/* Printer Features (sub-menu). */

WHEN {&rfPrintSubMenu} THEN isAvail = CAN-DO("r,l,e":u, qbf-module).
WHEN {&rfPrintPrinter} OR
  WHEN {&rfPrintPrinterNoBox} OR
  WHEN {&rfPrintClip} OR
  WHEN {&rfPrintFile} THEN

  CASE qbf-module:
    /* Allow a report to be generated if there are fields and the
     * number of columns is less than 640. */
    WHEN "r":u THEN isAvail = (NOT((qbf-tables <> "")
                               AND (qbf-rcn[1] = "")
                               AND (qbf-rsys.qbf-width > 640))).
  
    WHEN "l":u THEN RUN label_field.
    WHEN "e":u THEN isAvail = (qbf-rcn[1] <> "").
  
    OTHERWISE isAvail = FALSE.
  END CASE.

/* Administration submenu */

WHEN {&rfAdminRelations}    THEN isAvail = qbf-module = ? AND qbf-rel-tbl# > 0.
WHEN {&rfAdminTableAlias}   THEN isAvail = qbf-module = ? AND qbf-rel-tbl# > 0.
WHEN {&rfAdminWhere}        THEN isAvail = TRUE AND qbf-rel-tbl# > 0.
WHEN {&rfAdminRebuild}      THEN isAvail = qbf-module = ?.
WHEN {&rfAdminReset}        THEN isAvail = qbf-module = ?.
WHEN {&rfAdminPerm}         THEN isAvail = TRUE.

/* Table Features */

WHEN {&rfTable} THEN isAvail = qbf-module <> ?.
WHEN {&rfJoin}  THEN isAvail = CAN-DO("b,r,f,e":u, qbf-module)
                                 AND NUM-ENTRIES(qbf-tables) > 1.

/* Field Features */

WHEN {&rfFields}        THEN isAvail = qbf-module <> ?.
WHEN {&rfTotals}        THEN isAvail = qbf-module = "r":u.
/*WHEN {&rfCalcSubMenu}   THEN isAvail = qbf-module <> "l":u.*/
WHEN {&rfFieldProps}    THEN DO:
  IF qbf-module <> "l":u AND qbf-rc# > 0 THEN isAvail = TRUE.
  ELSE IF qbf-module = "l":u THEN RUN calc_field.
END.

/* Calculated Field Features (sub-menu) */

WHEN {&rfPercentTotal}  THEN isAvail = CAN-DO("r,e":u,qbf-module).
WHEN {&rfRunningTotal}  THEN isAvail = CAN-DO("r,e":u,qbf-module).
WHEN {&rfCounter}       THEN isAvail = CAN-DO("r,e":u,qbf-module).
WHEN {&rfArray}         THEN isAvail = qbf-module = "r":u.
WHEN {&rfLookup}        THEN isAvail = CAN-DO("r,f,e":u,qbf-module).
/*WHEN {&rfMath}          THEN isAvail = CAN-DO("b,r,f,e":u,qbf-module). */
/*WHEN {&rfStringFunc}    THEN isAvail = CAN-DO("b,r,f,e":u,qbf-module). */
/*WHEN {&rfNumericFunc}   THEN isAvail = CAN-DO("b,r,f,e":u,qbf-module). */
/*WHEN {&rfDateFunc}      THEN isAvail = CAN-DO("b,r,f,e":u,qbf-module). */
/*WHEN {&rfLogicalFunc}   THEN isAvail = CAN-DO("b,r,f,e":u,qbf-module). */

/* Data Features */

WHEN {&rfSelection}     THEN isAvail = qbf-module <> ?.
WHEN {&rfReAsk}         THEN isAvail = CAN-DO("f,b":u, qbf-module)
  AND CAN-FIND(FIRST qbf-where WHERE INDEX(qbf-wcls, "true") > 0).
WHEN {&rfSortordering}  THEN isAvail = qbf-module <> ?.
WHEN {&rfGovernor}      THEN isAvail = CAN-DO("r,l,e",qbf-module).

/* Option Features */

WHEN {&rfInformation}       THEN isAvail = qbf-module <> ?.
WHEN {&rfHeadersandFooters} THEN isAvail = qbf-module = "r":u.
WHEN {&rfMasterDetail}      THEN isAvail = CAN-DO("r,f,b":u,qbf-module) 
  AND NUM-ENTRIES(qbf-tables) > 1.
WHEN {&rfFrameProps}        THEN isAvail = CAN-DO("f,b":u,qbf-module).
WHEN {&rfTotalsOnly}        THEN isAvail = CAN-DO("r,e":u,qbf-module).
WHEN {&rfStandardReport}    THEN isAvail = qbf-module = "r":u.
WHEN {&rfCustomReport}      THEN isAvail = qbf-module = "r":u.
WHEN {&rfPageBreak}         THEN isAvail = qbf-module = "r":u.
WHEN {&rfStandardLabel}     THEN isAvail = qbf-module = "l":u.
WHEN {&rfCustomLabel}       THEN isAvail = qbf-module = "l":u.
WHEN {&rfStandardExport}    THEN isAvail = qbf-module = "e":u.

/* Export Features */

WHEN {&rfExportSubMenu} OR
  WHEN {&rfRecordStart} OR
  WHEN {&rfRecordEnd}       THEN isAvail = qbf-module = "e":u 
    AND NOT CAN-DO("dif,dif-dasn,progress,sylk":u,qbf-esys.qbf-type).
WHEN {&rfOutputHeader}      THEN ASSIGN isAvail = qbf-module = "e":u 
  AND NOT CAN-DO("dif,dif-dasn,progress,sylk":u,qbf-esys.qbf-type)
                                        isChecked = qbf-esys.qbf-headers.
WHEN {&rfFixedWidth}        THEN ASSIGN isAvail = qbf-module = "e":u
  AND NOT CAN-DO("dif,dif-dasn,progress,sylk":u,qbf-esys.qbf-type)
                                        isChecked = qbf-esys.qbf-fixed.

OTHERWISE isAvail   = TRUE.
END.

/* Now turn the values into text for the return trip home */
ASSIGN
  ENTRY(qbf-j, sensList) = IF isAvail   = TRUE THEN "true" ELSE "false"
  ENTRY(qbf-j, toggList) = IF isChecked = TRUE THEN "true" ELSE "false"
  .

END.

/*
* Give the AP a crack at the current state of things. Let them at the
* internal data structures. If they enable something we've shut down
* then that's their problem. We used not to allow the admin to change
* the state of a feature, if the value was false. But for performance,
* to save precious function calls, we don't do that anymore.
*/

IF _menuCheck =  ? OR _menuCheck = "" THEN RETURN.

hook:
DO ON STOP UNDO hook, RETRY hook:
  IF RETRY THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-s,"error":u,"ok":u,
      SUBSTITUTE("There is a problem with &1.  &2 cannot find the sensitivity state for Admin defined features.",_menuCheck,qbf-product)).

    _menuCheck = ?.
    RETURN.
  END.

  RUN VALUE(_menuCheck) (featureList, INPUT-OUTPUT sensList,
                         INPUT-OUTPUT toggList).
END.

/* ---------------------------------------------------------------------- */
PROCEDURE calc_field:
  /* figure out if there are any calc fields available */
  DO qbf-i = 1 TO qbf-rc#:
    IF CAN-DO("s,d,n,l",ENTRY(1,qbf-rcc[qbf-i])) THEN DO:
      isAvail = TRUE.
      LEAVE.
    END.
  END.
END PROCEDURE.

/* ---------------------------------------------------------------------- */
PROCEDURE label_field:
  /* figure out if there is any label text available */
  DO qbf-i = EXTENT(qbf-l-text) TO 1 BY -1 WHILE qbf-l-text[qbf-i] = "":
  END.

  isAvail = (qbf-i <> 0).
END PROCEDURE.

/* _mstate.p - end of file */

