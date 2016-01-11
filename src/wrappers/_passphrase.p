/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{ adecomm/adestds.i }
{ adecomm/commeng.i }

DEFINE OUTPUT PARAMETER pPassPhrase AS CHAR NO-UNDO.

DEFINE VARIABLE passphrase  AS CHAR FORMAT "x(300)" LABEL "Passphrase"
    VIEW-AS FILL-IN SIZE 30 BY 1.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
DEFINE RECTANGLE ok_box   {&STDPH_OKBOX}.
&ENDIF
DEFINE BUTTON ok_btn     LABEL "OK"     auto-go     {&STDPH_OKBTN}.
DEFINE BUTTON cancel_btn LABEL "Cancel" auto-endkey {&STDPH_OKBTN}.
DEFINE BUTTON help_btn   LABEL "&Help"              {&STDPH_OKBTN} 
TRIGGERS:
    ON "CHOOSE" DO:
       RUN adecomm/_adehelp.p (INPUT "comm", INPUT "CONTEXT", 
                               INPUT {&Connect_Database},
                               INPUT ?).
    END.
END TRIGGERS.

DEFINE FRAME passphrase_frame.

FORM
    skip({&TFM_WID})
    SPACE({&HFM_WID})  "Please enter the passphrase for the database" VIEW-AS TEXT
    skip({&TFM_WID})
    passphrase COLON 12 PASSWORD-FIELD
    { adecomm/okform.i 
          &BOX="ok_box" 
          &OK="ok_btn" 
          &CANCEL="cancel_btn" 
          &HELP="help_btn" 
    }
    WITH FRAME passphrase_frame CENTERED SIDE-LABELS ATTR-SPACE 
       DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn
       TITLE " Passphrase "
       VIEW-AS DIALOG-BOX.


{ adecomm/okrun.i 
      &FRAME="frame passphrase_frame" 
      &BOX="ok_box"
      &OK="ok_btn" 
      &CANCEL="cancel_btn"
      &HELP="help_btn"
}

ON HELP OF FRAME passphrase_frame ANYWHERE DO:
    APPLY "CHOOSE" TO help_btn.
END.


DO ON ENDKEY UNDO, LEAVE:

    UPDATE passphrase VALIDATE (TRIM(passphrase) NE "", "You must specify a valid passphrase.")
           ok_btn cancel_btn help_btn {&WHEN_HELP}
           WITH FRAME passphrase_frame view-as dialog-box.
END.

HIDE FRAME passphrase_frame.

/* set output value */
ASSIGN pPassPhrase = passphrase.
