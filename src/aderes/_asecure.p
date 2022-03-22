/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _asecure.p
*
*   Core Results security GUI.
*/

&GLOBAL-DEFINE WIN95-BTN YES
&Scoped-define FRAME-NAME    securityDialog

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/t-define.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }
{ aderes/_fdefs.i }

/* Create a temporary list. The real values aren't updated until the user
   hits ok.  */
DEFINE TEMP-TABLE tempList
  FIELD id           AS CHARACTER
  FIELD allowedUsers AS CHARACTER
  FIELD microHelp    AS CHARACTER
  .

DEFINE VARIABLE ans             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lastId          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dirty           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE sx              AS LOGICAL   NO-UNDO.

DEFINE VARIABLE fList AS CHARACTER
  VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  INNER-LINES {&ADM_IL_FLIST} INNER-CHARS {&ADM_IC_FLIST} NO-UNDO.

DEFINE VARIABLE security AS CHARACTER
  VIEW-AS EDITOR
  SIZE {&ADM_W_SFILL} BY {&ADM_IL_FLIST}
  MAX-CHARS {&ADM_LIMIT_CHARS}
  NO-UNDO.

DEFINE VARIABLE microHelp AS CHARACTER NO-UNDO
  FORMAT "X(50)":u
  LABEL "Description".

DEFINE VARIABLE fTitle AS CHARACTER NO-UNDO FORMAT "X({&ADM_IC_FLIST})":u.
DEFINE VARIABLE sTitle AS CHARACTER NO-UNDO FORMAT "X({&ADM_W_SFILL})":u.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})

  fTitle AT {&ADM_X_START} VIEW-AS TEXT NO-LABEL

  sTitle AT ROW-OF fTitle
    COLUMN-OF fTitle + {&ADM_H_FLIST_OFF}
    VIEW-AS TEXT NO-LABEL
  SKIP({&VM_WID})

  fList AT {&ADM_X_START} NO-LABEL

  security AT ROW-OF fList
    COLUMN-OF fList + {&ADM_H_FLIST_OFF}
    NO-LABEL {&STDPH_FILL}
  SKIP({&VM_WID})

  microHelp AT ROW-OF fList + {&ADM_P_FLIST}
    COLUMN-OF fList
    VIEW-AS TEXT
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Feature Security":L.

ON DEFAULT-ACTION OF fList IN FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO security.

ON VALUE-CHANGED OF fList DO:
  FIND FIRST tempList WHERE tempList.id = fList:SCREEN-VALUE.

  /* Change the screen value to what the user wants to see */
  ASSIGN
    security:SCREEN-VALUE  = tempList.allowedUsers.
    microHelp:SCREEN-VALUE = tempList.microHelp.
  .
END.

ON ENTRY OF security IN FRAME {&FRAME-NAME} DO:
  lastId = fList:SCREEN-VALUE.

  IF lastId = "" THEN DO:
    FIND FIRST tempList.
    lastId = tempList.id.
  END.
END.

ON ALT-F OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO fList IN FRAME {&FRAME-NAME}.

ON ALT-U OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO security IN FRAME {&FRAME-NAME}.

ON GO OF FRAME {&FRAME-NAME} DO:
  IF dirty = FALSE THEN RETURN.

  RUN adecomm/_setcurs.p("WAIT":u).

  FOR EACH tempList:
    RUN adeshar/_msetu.p({&resId},tempList.id,tempList.allowedUsers,OUTPUT sx).
  END.

  ASSIGN
    _configDirty = TRUE
    _featDirty = TRUE
    .

  RUN aderes/_afwrite.p (0).
  RUN aderes/_awrite.p (0).
END.

ON LEAVE OF security DO:
  /* Change the values, including the save_permission, in case the user 
   * needs it. */
  dirty = TRUE.

  /* Find the record to be updated. */
  FIND FIRST tempList WHERE tempList.id = lastId.
  tempList.allowedUsers = security:SCREEN-VALUE.
END.

/*------------------------------- Main Code Block ---------------------------*/

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

/* Handle the runtime layout needs */
security:HEIGHT-PIXELS = fList:Height-PIXELS.

{ aderes/_arest.i 
  &FRAME   = "FRAME {&FRAME-NAME}"
  &HELP-NO = {&Security_Dlg_Box} }

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

RUN initGui.

ASSIGN
  fList:SENSITIVE             = TRUE
  security:SENSITIVE          = TRUE
  fTitle:SENSITIVE            = TRUE
  sTitle:SENSITIVE            = TRUE
  fTitle:SCREEN-VALUE         = "&Features:"
  sTitle:SCREEN-VALUE         = "&User List:"
  FRAME {&FRAME-NAME}:HIDDEN  = FALSE.

RUN adecomm/_setcurs.p("").

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE initGui :
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE features AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE fName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE junk     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE junkl    AS LOGICAL   NO-UNDO.

    /* Initialize the temporary stuff as well as the selection list. */
    RUN adeshar/_mgetfl.p({&resId}, TRUE, OUTPUT features).

    DO ix = 1 TO NUM-ENTRIES(features):
      CREATE tempList.
  
      ASSIGN
        fName       = ENTRY(ix, features)
        ans         = fList:ADD-LAST(fName)
        tempList.id = fName
        .
  
      RUN adeshar/_mgetu.p({&resId}, fName, OUTPUT tempList.allowedUsers, 
                           OUTPUT sx).
  
      RUN adeshar/_mgetf.p({&resId}, fName,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT junk,
                           OUTPUT tempList.microHelp,
                           OUTPUT junk,
                           OUTPUT junkl,
                           OUTPUT sx).
    END.
  
    FIND FIRST tempList.
    ASSIGN
      security:SCREEN-VALUE  = tempList.allowedUsers
      fList:SCREEN-VALUE     = fList:ENTRY(1)
      microHelp:SCREEN-VALUE = tempList.microHelp
      .
  
  END.
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _asecure.p -  end of file */

