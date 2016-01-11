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
* _atool.p
*
*   The toolbar editor.
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/_fdefs.i   }
{ aderes/s-menu.i   }
{ aderes/s-system.i }
{ adecomm/cbvar.i " NEW SHARED" }
{ adeshar/_mnudefs.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i}
{ aderes/reshlp.i }

&GLOBAL-DEFINE FRAME-NAME toolBarEdit

DEFINE NEW SHARED VARIABLE tbfListHandle AS HANDLE NO-UNDO.

DEFINE VARIABLE added         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dirty         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE fList         AS CHARACTER NO-UNDO. /* feature list */
DEFINE VARIABLE fTitle        AS CHARACTER FORMAT "X({&ADM_IC_FLIST})":u.
DEFINE VARIABLE hdl           AS HANDLE    NO-UNDO.
DEFINE VARIABLE iTitle        AS CHARACTER FORMAT "X(20)":u.
DEFINE VARIABLE microHelp     AS CHARACTER FORMAT "X(60)":u
  LABEL "Description".
  
DEFINE BUTTON AddBut LABEL "&Add"
  SIZE {&ADM_W_BUTTON} BY {&H_OKBTN}.

DEFINE BUTTON DelBut LABEL "&Remove"
  SIZE {&ADM_W_BUTTON} BY {&H_OKBTN}.

/* Use 35 by 33 to support smaller Windows 95 toolbar images. jep 7/30/97 */
DEFINE BUTTON UpImageBut LABEL "" NO-FOCUS FLAT-BUTTON
  SIZE-PIXELS /* 35 BY 33 */ {&mnuIconSize} BY {&mnuIconSize}. 

{ aderes/_asbar.i }

DEFINE RECTANGLE rect1 SIZE-CHARS 25 BY 1 NO-FILL.

FORM
  /* Do not start with the standard margin! The top of this dialog
   * box is reserved for copies of the current tool bar buttons. */
  fTitle AT ROW 3.5
    COLUMN 2 VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  fList AT 2 NO-LABEL
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
    INNER-CHARS 30 INNER-LINES 10 

  rect1 AT 1 /* reposition later */
  
  iTitle AT ROW-OF fTitle COLUMN-OF fList + 42
    VIEW-AS TEXT NO-LABEL

  UpImageBut AT ROW 1 COL 1 

  AddBut AT ROW-OF fList COLUMN-OF fList + 50
    
  DelBut AT ROW-OF AddBut + {&ADM_V_GAP} COLUMN-OF AddBut
  SKIP(6)
  
  microHelp AT 2
    VIEW-AS TEXT

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME} VIEW-AS DIALOG-BOX SIDE-LABELS
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  SCROLLABLE TITLE "Tool Bar Layout".

ON GO OF FRAME {&FRAME-NAME} DO:
  IF dirty = TRUE THEN DO:

    RUN adecomm/_setcurs.p ("WAIT":u).
    HIDE FRAME {&FRAME-NAME}.

    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Updating Tool Bar...":t72).
    RUN adeshar/_mupdatt.p ({&resId}).
    RUN _tFinishEdit.
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "").

    /* Write out the menu definitions. */
    _uiDirty = TRUE.
    RUN aderes/_amwrite.p (0).

    /*
     * The update of the menu system creates, but does not display
     * newly created buttons. If the toolbar is active then
     * lets enable all the widgets in the toolbar frame. That
     * will get the new buttons.
     */
    IF FRAME fToolbar:VISIBLE = TRUE THEN
      ENABLE ALL WITH FRAME fToolbar.
  END.
END.

ON ENDKEY OF FRAME {&FRAME-NAME} DO:
  /* Drop the frame, so the user doesn't see the buttons deleted. */
  HIDE FRAME {&FRAME-NAME}.
  RUN _tFinishEdit.
END.

ON ALT-F OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO fList IN FRAME {&FRAME-NAME}.

ON ALT-U OF FRAME {&FRAME-NAME}
  APPLY "CHOOSE":u TO UpImageBut   IN FRAME {&FRAME-NAME}.

/*--------------------------------- Main Block ------------------------------ */

/* Keep everything from coming up bit by bit ... */
ASSIGN
  FRAME {&FRAME-NAME}:HIDDEN = TRUE
  FRAME {&FRAME-NAME}:WIDTH-PIXELS = ({&mnuiconsize} * 14)
                                   + ({&mnuiconoffset} * 13) + 7
  AddBut:COL            = FRAME {&FRAME-NAME}:WIDTH - AddBut:WIDTH - 2
  DelBut:COL            = AddBut:COL
  .

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Toolbar_Editor_Dlg_Box}}

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

/* Retrieve the "default" icon dir */
IF _iconPath = "" THEN
  RUN aderes/_aicdir.p (OUTPUT _iconPath).

/* Make the interface artifacts visible, runtime layout, etc. */
ASSIGN
  fTitle:SCREEN-VALUE   = "&Features:"
  iTitle:SCREEN-VALUE   = "Image:"
  fList:SENSITIVE       = TRUE
  rect1:ROW             = fList:ROW
  /*
  rect1:COL             = ((AddBut:COL 
                          - (fList:COL + fList:WIDTH) - rect1:WIDTH) / 2)
                          + (fList:COL + fList:WIDTH) 
  */
  rect1:COL             = fList:COL + fList:WIDTH + 1
  rect1:HEIGHT          = fList:HEIGHT
  rect1:WIDTH           = AddBut:COL - rect1:COL - 1
  
  iTitle:ROW            = fTitle:ROW
  iTitle:COL            = rect1:COL
  
  UpImageBut:COL        = rect1:COL + (rect1:WIDTH / 2) - (UpImageBut:WIDTH / 2)
  UpImageBut:ROW        = rect1:ROW + (rect1:HEIGHT / 2) - (UpImageBut:HEIGHT / 2)
  microHelp:ROW         = fList:ROW + fList:HEIGHT + .5
  hdl                   = microHelp:SIDE-LABEL-HANDLE
  hdl:ROW               = microHelp:ROW
  .

/* Provide the semantics for the editor */
{ adeshar/_mnutb.i 
  &frme          = {&FRAME-NAME}
  &appId         = "{&resId}"
  &toolbarId     = "{&restoolbar}"
  &y             = {&mnuIconY}
  &featureList   = fList
  &addButton     = addBut
  &delButton     = delBut
  &microHelp     = microHelp
  &dirty         = dirty
  &iconDir       = _iconPath
  &upImageBut    = upImageBut}

tbfListHandle = fList:HANDLE.

RUN _tFigureButtonState ("start":u).
RUN guiReset.
RUN _tInitEdit.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

RUN adecomm/_setcurs.p("").

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE guiReset:
  /* load feature list */

  DEFINE VARIABLE aList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf-s   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE xHandle AS HANDLE    NO-UNDO.

  RUN adeshar/_mgetfl.p ({&resID},TRUE,OUTPUT aList).
  ASSIGN
    xHandle  = fList:HANDLE IN FRAME {&FRAME-NAME}
    qbf-s    = xHandle:ADD-LAST(aList)
    .
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _atool.p - end of file */

