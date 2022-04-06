/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/******************************************************************************
* 
*
*   PROGRAM: login.i
*
*   PROGRAM SUMMARY:
*       Frame for the login window.  Used by login.p and prostart.p.
*
*   RUN/CALL SYNTAX:
*       { login.i }
*
*   PARAMETERS/ARGUMENTS LIST:
*       None
*
*******************************************************************************/
{ adecomm/adestds.i }
{ adecomm/commeng.i }

DEFINE {1} SHARED VARIABLE currentdb AS CHAR VIEW-AS TEXT FORMAT "x(32)" NO-UNDO.

DEFINE {1} SHARED VARIABLE id        AS CHAR FORMAT "x(255)" view-as fill-in size 50 by 1 LABEL "User id" 
    {&STDPH_FILLIN}.
DEFINE {1} SHARED VARIABLE domain    AS CHAR FORMAT "x(255)" view-as fill-in size 50 by 1 LABEL "Domain" 
    {&STDPH_FILLIN}.

DEFINE {1} SHARED VARIABLE password  AS CHAR FORMAT "x(255)" view-as fill-in size 50 by 1 LABEL "Password"
    {&STDPH_FILLIN}.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
DEFINE RECTANGLE ok_box   {&STDPH_OKBOX}.
&ENDIF
DEFINE BUTTON ok_btn     LABEL "OK"     auto-go     {&STDPH_OKBTN}.
DEFINE BUTTON cancel_btn LABEL "Cancel" auto-endkey {&STDPH_OKBTN}.
DEFINE BUTTON help_btn   LABEL "&Help"              {&STDPH_OKBTN} 
TRIGGERS:
    ON "CHOOSE" DO:
        RUN adecomm/_adehelp.p ("comm", "CONTEXT", {&Login_Window}, ?).
    END.
END TRIGGERS.

DEFINE {1} SHARED FRAME login_frame.
DEFINE {1} SHARED FRAME logindb_frame.
 
FORM
    skip({&TFM_WID})
    SPACE({&HFM_WID}) "Please enter User id, Password and Domain for" VIEW-AS TEXT
    SKIP
    SPACE({&HFM_WID}) "database:" VIEW-AS TEXT 
    currentdb NO-LABEL
    SKIP({&VM_WIDG})
    id       COLON 12 
    SKIP({&VM_WID})
    password COLON 12 PASSWORD-FIELD
    SKIP({&VM_WID})
    domain   COLON 12 
    { adecomm/okform.i 
          &BOX="ok_box" 
          &OK="ok_btn" 
          &CANCEL="cancel_btn" 
          &HELP="help_btn" 
    }
    WITH FRAME login_frame CENTERED SIDE-LABELS ATTR-SPACE 
       DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn
       &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           ROW 2 TITLE " Login"
       &ELSE
           NO-BOX
       &ENDIF
    .

FORM
    skip({&TFM_WID})
    SPACE({&HFM_WID}) "Please enter a User Id and Password for" VIEW-AS TEXT
    SKIP
    SPACE({&HFM_WID}) "database:" VIEW-AS TEXT 
    currentdb NO-LABEL
    SKIP({&VM_WIDG})
    id       COLON 12 
    SKIP({&VM_WIDG})
    password COLON 12 PASSWORD-FIELD
    SKIP({&VM_WID})
    domain       COLON 12 
    { adecomm/okform.i 
          &BOX="ok_box" 
          &OK="ok_btn" 
          &CANCEL="cancel_btn" 
          &HELP="help_btn" 
    }
    WITH FRAME logindb_frame CENTERED SIDE-LABELS ATTR-SPACE 
       DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn
       ROW 2 TITLE " Login"
       VIEW-AS DIALOG-BOX
    .

&IF "{1}" = "NEW" &THEN
{ adecomm/okrun.i 
      &FRAME="frame login_frame" 
      &BOX="ok_box"
      &OK="ok_btn"
      &CANCEL="cancel_btn" 
      &HELP="help_btn"
}

{ adecomm/okrun.i 
      &FRAME="frame logindb_frame" 
      &BOX="ok_box"
      &OK="ok_btn" 
      &CANCEL="cancel_btn"
      &HELP="help_btn"
}
&ENDIF

ON HELP OF FRAME login_frame ANYWHERE DO:
    APPLY "CHOOSE" TO help_btn.
END.
