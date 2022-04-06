/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: adecomm/_toollic.p

Description:

This file is part of the trio of toolmenu.i, toolrun.i, _toollic.p.  These
files together will build the standard tools menu used by all the
ADE applications.

Usage:

Include {adecomm/toolmenu.i} with your other menu defines. See toolmenu.i
for any arguments.

Include {adecomm/toolrun.i} after your menubar definition.  This file
should only be run once per menubar.  See toolrun.i for any arguments.

----------------------------------------------------------------------------*/

DEFINE VARIABLE locdwb AS CHARACTER NO-UNDO. /* Actuate WB location, or ? */
DEFINE VARIABLE locard AS CHARACTER NO-UNDO. /* Actuate RD location, or ? */

/*-----------------------------  DEFINE MENUS   -----------------------------*/

{ adecomm/toolmenu.i }

/*-----------------------------  DEFINE MENUS   -----------------------------*/

IF ade_licensed[1] = ? THEN DO:

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    IF SEARCH("_admin.p") <> ? OR SEARCH("_admin.r") <> ? THEN
        ade_licensed[{&ADMIN_IDX}] = {&INSTALLED}.
    ELSE
        ade_licensed[{&ADMIN_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    IF SEARCH("_dict.p") <> ? OR SEARCH("_dict.r") <> ? THEN
        ade_licensed[{&DICT_IDX}] = {&INSTALLED}.
    ELSE
        ade_licensed[{&DICT_IDX}] = {&NOT_AVAIL}.

    IF SEARCH("_edit.p") <> ? OR SEARCH("_edit.r") <> ? THEN
        ade_licensed[{&EDIT_IDX}] = {&INSTALLED}.
    ELSE
        ade_licensed[{&EDIT_IDX}] = {&NOT_AVAIL}.

    IF SEARCH("protools/_protool.p") <> ? OR
       SEARCH("protools/_protool.r") <> ? THEN
        ade_licensed[{&PTOOL_IDX}] = {&INSTALLED}.
    ELSE
        ade_licensed[{&PTOOL_IDX}] = {&NOT_AVAIL}.

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    IF GET-LICENSE("UIB") = 0 OR GET-LICENSE("Workshop") = 0 THEN DO:
      /* Either the traditional UIB or the traditional WebSpeed Workshop is
         licensed.  Has the AB been installed?                              */
        IF SEARCH("_ab.p") <> ? OR SEARCH("_ab.r") <> ? THEN
            ade_licensed[{&UIB_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&UIB_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&UIB_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    IF GET-LICENSE("RESULTS") = 0 THEN DO:
        IF SEARCH("results.p") <> ? OR SEARCH("results.r") <> ? THEN
            ade_licensed[{&RPT_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&RPT_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&RPT_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    /*Do not include Report Writer in version 10 and above*/
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    IF GET-LICENSE("REPORT-WRITER") = 0 AND 
       INTEGER(substring(PROVERSION,1,INDEX(PROVERSION,".":U) - 1)) < 10 THEN DO:
        IF SEARCH("_rbuild.p") <> ? OR SEARCH("_rbuild.r") <> ? THEN
            ade_licensed[{&RB_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&RB_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&RB_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    IF GET-LICENSE("TRANSLATION-MGR") = 0 THEN DO:
        IF SEARCH("_tran.p") <> ? OR SEARCH("_tran.r") <> ? THEN
            ade_licensed[{&TRAN_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&TRAN_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&TRAN_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    IF GET-LICENSE("VISUAL-TRANSLATOR") = 0 THEN DO:
        IF SEARCH("_vtran.p") <> ? OR SEARCH("_vtran.r") <> ? THEN
            ade_licensed[{&VTRAN_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&VTRAN_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&VTRAN_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    IF GET-LICENSE("COMPILER-TOOL") = 0 THEN DO:
        IF SEARCH("_comp.p") <> ? OR SEARCH("_comp.r") <> ? THEN
            ade_licensed[{&COMP_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&COMP_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&COMP_IDX}] = {&NOT_AVAIL}.

    IF GET-LICENSE("DEBUGGER") = 0 THEN DO:
        IF SEARCH("java/progress.jar") <> ? THEN
            ade_licensed[{&DBG_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&DBG_IDX}] = {&LICENSED}.
    END.
    ELSE
        ade_licensed[{&DBG_IDX}] = {&NOT_AVAIL}.
    
    IF GET-LICENSE("Workshop") = 0 THEN DO:
        IF SEARCH("adeweb/_abrunwb.p") <> ? 
        OR SEARCH("adeweb/_abrunwb.r") <> ? THEN
            ade_licensed[{&WTOOL_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&WTOOL_IDX}] = {&LICENSED}.
    END.
    ELSE
      ade_licensed[{&WTOOL_IDX}] = {&NOT_AVAIL}.

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
        RUN adecomm/_locdwb.p (OUTPUT locdwb).
        IF locdwb <> ? THEN
            ade_licensed[{&DWB_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&DWB_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
        RUN adecomm/_locard.p (OUTPUT locard).
        IF locard <> ? THEN
            ade_licensed[{&ARD_IDX}] = {&INSTALLED}.
        ELSE
            ade_licensed[{&ARD_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    IF SEARCH("auditing/_apmt.p") <> ? OR SEARCH("auditing/_apmt.r") <> ? THEN
        ade_licensed[{&APMT_IDX}] = {&INSTALLED}.
    ELSE
        ade_licensed[{&APMT_IDX}] = {&NOT_AVAIL}.
    &ENDIF

    &IF {&DEBUG} &THEN
    MESSAGE 
        "ADMIN" ade_licensed[{&ADMIN_IDX}] SKIP
        "DICT"  ade_licensed[{&DICT_IDX}]  SKIP
        "EDIT"  ade_licensed[{&EDIT_IDX}]  SKIP
        "UIB"   ade_licensed[{&UIB_IDX}]   SKIP
        "RPT"   ade_licensed[{&RPT_IDX}]   SKIP
        "RB"    ade_licensed[{&RB_IDX}]    SKIP
        "TRAN"  ade_licensed[{&TRAN_IDX}]  SKIP
        "VTRAN" ade_licensed[{&VTRAN_IDX}] SKIP
        "COMP"  ade_licensed[{&COMP_IDX}]  SKIP
        "DBG"   ade_licensed[{&DBG_IDX}]   SKIP
        "PTOOL" ade_licensed[{&PTOOL_IDX}] SKIP
        "WTOOL" ade_licensed[{&WTOOL_IDX}] SKIP
        "DWB"   ade_licensed[{&DWB_IDX}]   SKIP
        "ARD"   ade_licensed[{&ARD_IDX}]   SKIP
        "APMT"  ade_licensed[{&APMT_IDX}]   SKIP
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    &ENDIF
END.

