/***********************************************************************
* Copyright (C) 2009-2022 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
{ adecomm/adestds.i }
{ adecomm/commeng.i }

DEFINE INPUT  PARAMETER pPass_Phrase AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pPin         AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pPassPhrase  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pPinValue    AS CHARACTER NO-UNDO.

DEFINE VARIABLE passphrase  AS CHARACTER FORMAT "x(300)" LABEL "Passphrase"
    VIEW-AS FILL-IN SIZE 30 BY 1.
DEFINE VARIABLE pin  AS CHARACTER FORMAT "x(300)" LABEL "Pin"
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
DEFINE FRAME pin_frame.
DEFINE FRAME pass_pin_frame.

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

FORM
    skip({&TFM_WID})
    SPACE({&HFM_WID})  "Please enter the pin for the database" VIEW-AS TEXT
    skip({&TFM_WID})
    pin COLON 5 PASSWORD-FIELD
    { adecomm/okform.i 
          &BOX="ok_box" 
          &OK="ok_btn" 
          &CANCEL="cancel_btn" 
          &HELP="help_btn" 
    }
    WITH FRAME pin_frame CENTERED SIDE-LABELS ATTR-SPACE 
       DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn
       TITLE " Enter Keystore Pin "
       VIEW-AS DIALOG-BOX.
       
{ adecomm/okrun.i 
      &FRAME="frame pin_frame" 
      &BOX="ok_box"
      &OK="ok_btn" 
      &CANCEL="cancel_btn"
      &HELP="help_btn"
}

FORM
    skip({&TFM_WID})
    SPACE({&HFM_WID})  "Please enter the passphrase and pin for the database" VIEW-AS TEXT
    skip({&TFM_WID})
    passphrase COLON 12 PASSWORD-FIELD
    skip({&TFM_WID})
    pin COLON 12 PASSWORD-FIELD
    { adecomm/okform.i 
          &BOX="ok_box" 
          &OK="ok_btn" 
          &CANCEL="cancel_btn" 
          &HELP="help_btn" 
    }
    WITH FRAME pass_pin_frame CENTERED SIDE-LABELS ATTR-SPACE 
       DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn
       TITLE " Enter Keystore Passphrase and Pin "
       VIEW-AS DIALOG-BOX.


{ adecomm/okrun.i 
      &FRAME="frame pass_pin_frame" 
      &BOX="ok_box"
      &OK="ok_btn" 
      &CANCEL="cancel_btn"
      &HELP="help_btn"
}

ON HELP OF FRAME passphrase_frame ANYWHERE DO:
    APPLY "CHOOSE" TO help_btn.
END.
ON HELP OF FRAME pin_frame ANYWHERE DO:
    APPLY "CHOOSE" TO help_btn.
END.
ON HELP OF FRAME pass_pin_frame ANYWHERE DO:
    APPLY "CHOOSE" TO help_btn.
END.

ASSIGN passphrase = ""
       pin        = "".

DO ON ENDKEY UNDO, LEAVE:

    IF pPass_Phrase AND pPin THEN
      UPDATE passphrase VALIDATE (TRIM(passphrase) NE "", "You must specify a valid passphrase.")
             pin VALIDATE (TRIM(pin) NE "", "You must specify a valid pin.")
             ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME pass_pin_frame view-as dialog-box.
    ELSE IF pPin THEN
      UPDATE pin VALIDATE (TRIM(pin) NE "", "You must specify a valid pin.")
             ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME pin_frame view-as dialog-box.
    ELSE
      UPDATE passphrase VALIDATE (TRIM(passphrase) NE "", "You must specify a valid passphrase.")
             ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME passphrase_frame view-as dialog-box.
END.

HIDE FRAME pin_frame.
HIDE FRAME passphrase_frame.
HIDE FRAME pass_pin_frame.

/* set output value */
ASSIGN pPassPhrase = passphrase
       pPinValue   = pin.
