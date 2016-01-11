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
/*
* _amenu.p
*
*   Defines the menu editor dialog box
*/

&GLOBAL-DEFINE WIN95-BTN YES
&Scoped-define FRAME-NAME     menuDialog

{ aderes/_fdefs.i }
{ adecomm/cbvar.i "NEW SHARED" }
{ aderes/s-system.i }
{ adeshar/_mnudefs.i }
{ aderes/s-menu.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

DEFINE VARIABLE res       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dirty     AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE VARIABLE junk      AS CHARACTER NO-UNDO.
DEFINE VARIABLE aList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE xhandle   AS HANDLE    NO-UNDO.
DEFINE VARIABLE fTitle    AS CHARACTER NO-UNDO FORMAT "X({&ADM_IC_FLIST})":u.
DEFINE VARIABLE mTitle    AS CHARACTER NO-UNDO FORMAT "X({&ADM_IC_FLIST})":u.
DEFINE VARIABLE iTitle    AS CHARACTER NO-UNDO FORMAT "X({&ADM_IC_FLIST})":u.

DEFINE VARIABLE microHelp AS CHARACTER NO-UNDO
  FORMAT "X(50)":u
  LABEL "Description".

&Scoped-define FRAME-NAME     menuDialog

DEFINE BUTTON addBut
  LABEL "&Add":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE BUTTON delBut
  LABEL "&Remove":L
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

DEFINE VARIABLE fList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-CHARS {&ADM_IC_FLIST} INNER-LINES 12 NO-UNDO.

DEFINE VARIABLE iFill AS CHARACTER FORMAT "X(100)":u
  VIEW-AS FILL-IN
  SIZE {&ADM_IC_FLIST} BY {&ADM_H_BUTTON} NO-UNDO.

DEFINE VARIABLE iList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-CHARS {&ADM_IC_FLIST} INNER-LINES 4 NO-UNDO.

DEFINE VARIABLE mList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-CHARS {&ADM_IC_FLIST} INNER-LINES 3 NO-UNDO.

{ aderes/_asbar.i }

/* ************************  Frame Definitions  *********************** */

FORM
  SKIP({&TFM_WID})

  fTitle AT {&ADM_X_START} 
    VIEW-AS TEXT NO-LABEL

  mTitle AT ROW-OF fTitle
    COLUMN-OF fTitle + {&ADM_H_FLIST_OFF}
    VIEW-AS TEXT NO-LABEL

  fList AT {&ADM_X_START} NO-LABEL

  mList AT ROW-OF fList 
    COLUMN-OF fList + {&ADM_H_FLIST_OFF}
    NO-LABEL

  /* The defaults don't provide enough spacing between the
     two stacked menu lists ...  */
  iTitle AT ROW-OF mList + 3.25
    COLUMN-OF mList 
    VIEW-AS TEXT NO-LABEL

  iFill AT ROW-OF mList + 4 
    COLUMN-OF mList
    NO-LABEL {&STDPH_FILL}

  iList AT ROW-OF mList + 5 
    COLUMN-OF mList 
    NO-LABEL

  addBut AT ROW-OF iFill
    COLUMN-OF iFill + {&ADM_H_FLIST_OFF}

  delBut AT ROW-OF addBut + {&ADM_V_GAP}
    COLUMN-OF addBut

  microHelp AT ROW-OF fList + 9
    COLUMN-OF fList
    VIEW-AS TEXT

  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME menuDialog
  VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee SCROLLABLE
  TITLE "Menu Layout":L.

ON GO OF FRAME menuDialog DO: /* Menu Editor */
  /* This is the one button that can't be put into .i file. Since we're sharing
   * the interface there may be other things on the screen that have to be 
   * dealt with when we close.  Only do the work if there have been changes. */
  IF dirty = TRUE THEN DO:
    /*
     * In RESULTS, the end user will not have access to this feature.
     * Therefore the .mnu file isn't needed. However, we do need to
     * write out the current state of the admin's menu.
    */

    HIDE FRAME {&FRAME-NAME}.

    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Updating Menus...":t72).

    RUN adecomm/_setcurs.p ("WAIT":u).

    RUN adeshar/_mupdatm.p ({&resId}).
    _uiDirty = TRUE.

    RUN adecomm/_statdsp.p (wGlbStatus, 1, "").

    RUN aderes/_amwrite.p (0).

    /*
     * Force a recheck of the menubar. When something is added
     * to a menu, the menu is made sensitive. So we have to make
     ** sure we return the menubar to the proper state.
    */
    RUN adeshar/_mcheckm.p({&resId}, OUTPUT res).
  END.
END.

ON ALT-F OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO fList IN FRAME {&FRAME-NAME}.

ON ALT-M OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO mList IN FRAME {&FRAME-NAME}.

ON ALT-I OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO iFill IN FRAME {&FRAME-NAME}.

/*--------------------------- Main code block ----------------------------*/

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

/* Finish up the help, sullivan bar and any other standards */
{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Menu_Editor_Res_Dlg_Box}}

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

{ adeshar/_mnu.i   
  &frme         = {&FRAME-NAME}
  &appId        = "{&resId}":u
  &menuList     = mList
  &itemFill     = iFill
  &itemList     = iList
  &featureList  = fList
  &addButton    = addBut
  &delButton    = delBut
  &menuBar      = _menuBar
  &microHelp    = microHelp
  &dirty        = dirty}

ASSIGN
  mList:SENSITIVE             = TRUE
  iList:SENSITIVE             = TRUE
  iFill:SENSITIVE             = TRUE
  fList:SENSITIVE             = TRUE
  fTitle:SCREEN-VALUE         = "&Features:"
  mTitle:SCREEN-VALUE         = "&Menus:"
  iTitle:SCREEN-VALUE         = "Menu &Items:"
  microHelp:SCREEN-VALUE      = ""
  .

RUN figureButtonState.
RUN guiReset.

/*
* Runtime layout needed because we have to use inner-char stuff. Line
* up the bottoms of the item list with the feature list.
*/

ASSIGN
  iList:Y                    = (fList:Y + fList:HEIGHT-PIXELS) 
                             - iList:HEIGHT-PIXELS
  iFill:WIDTH-PIXELS         = iList:WIDTH-PIXELS
  iFill:Y                    = iList:Y - (iFill:HEIGHT-PIXELS + 3)
  iTitle:Y                   = iFill:Y - (iTitle:HEIGHT-PIXELS + 3)
  FRAME {&FRAME-NAME}:HIDDEN = FALSE
  .
RUN adecomm/_setcurs.p("").

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE guiReset :
  /* Now prime the GUI. Get the current state of the menus and fill the
     selection lists */
  RUN adeshar/_mgetfl.p({&resId}, TRUE, OUTPUT aList).
  ASSIGN
    xhandle = fList:HANDLE IN FRAME menuDialog
    res     = xhandle:ADD-LAST(aList).

  RUN adeshar/_mgetml.p({&resId}, OUTPUT aList).
  ASSIGN
    xhandle            = mList:HANDLE IN FRAME menuDialog
    res                = xhandle:ADD-LAST(aList)

    /* Initialize the current selection */
    mList:SCREEN-VALUE = ENTRY(1,aList)
    .

  /* Get the items attached to the menu. */
  APPLY "CHOOSE":u TO mList.
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _amenu.p - end of file */

