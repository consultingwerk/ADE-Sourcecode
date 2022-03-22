/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*****************************************************************************

Procedure: prohelp/_rcntmsg.p

Syntax:
    RUN prohelp/_rcntmsg.p.

Purpose:          
    To display the Progress compiler messages that a user encountered in a
    session.

Description:

Author: Ravi-Chandar Ramalingam
******************************************************************************/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}
{adecomm/adestds.i}

/******************************* Definitions *********************************/
DEFINE VARIABLE ffMsgNum AS INTEGER FORMAT ">>>>>" LABEL "Message Number".
DEFINE VARIABLE eMessage AS CHARACTER
	VIEW-AS EDITOR
        SIZE-CHAR 75 BY &IF "{&WINDOW-SYSTEM}" <> "TTY"
                        &THEN 8 &ELSE 11 &ENDIF
        SCROLLBAR-V PFCOLOR 0.
DEFINE VARIABLE whLabel AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE message-counter AS INTEGER INITIAL 1.
DEFINE VARIABLE message-number AS INTEGER INITIAL 0.

DEFINE BUTTON bOk   LABEL "OK"        {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON bNext LABEL "&Next"     SIZE 15 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
DEFINE BUTTON bPrev LABEL "&Previous" SIZE 15 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
DEFINE BUTTON bHelp LABEL "&Help"     {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rHeavyRule {&STDPH_OKBOX}.
&ENDIF

FORM
   SKIP({&TFM_WID})
   ffMsgNum VIEW-AS FILL-IN {&STDPH_FILL} {&AT_OKBOX} SKIP({&VM_WIDG})
   eMessage VIEW-AS EDITOR NO-LABEL {&AT_OKBOX}
   &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
   SKIP({&VM_WIDG})
   "To display PROGRESS 4GL Help, highlight a keyword and press Help."
   VIEW-AS TEXT {&AT_OKBOX}
   &ENDIF

   {adecomm/okform.i
      &BOX    = "rHeavyRule"
      &STATUS = "no"
      &OK     = "bOk"
      &OTHER  = "space({&HM_DBTNG}) bPrev space({&HM_DBTN}) bNext"
      &HELP   = "bHelp" }

   WITH FRAME frMessage SIDE-LABELS DEFAULT-BUTTON bOk
        TITLE "Recent Messages" VIEW-AS DIALOG-BOX.

ASSIGN FRAME frMessage:PARENT = ACTIVE-WINDOW NO-ERROR.

{prohelp/msgs.i}

/**************************** Internal Procedures ***************************/
PROCEDURE DisplayMessage.
  DEFINE INPUT PARAMETER msg-num AS INTEGER.
  DEFINE VARIABLE description AS CHARACTER.

  RUN GetMessageDescription(msg-num, OUTPUT description).
  DO WITH FRAME frMessage:
    IF description = ? OR description = "?" OR description = "" THEN
      description = "No information is available for this PROGRESS message.".
    ASSIGN ffMsgNum:SCREEN-VALUE = STRING(msg-num)
	   eMessage:SCREEN-VALUE = description.
    /* Prev Button */
    IF (_msg(message-counter + 1) > 0)
    THEN ASSIGN bPrev:SENSITIVE = TRUE.
    ELSE ASSIGN bPrev:SENSITIVE = FALSE.

    /* Next Button */
    IF message-counter > 1
    THEN ASSIGN bNext:SENSITIVE = TRUE.
    ELSE ASSIGN bNext:SENSITIVE = FALSE.
  END. /* DO WITH FRAME */
END PROCEDURE.

/*************************** UserInterface Triggers **************************/
/* Help triggers */
ON CHOOSE OF bHelp IN FRAME frMessage OR HELP OF FRAME frMessage
  RUN adecomm/_kwhelp.p ( INPUT eMessage:HANDLE, 
                          INPUT "comm"    , 
                          INPUT {&Recent_Msgs_Dlg_Box} ).

ON CHOOSE OF bNext IN FRAME frMessage
DO:
  message-counter = message-counter - 1.
  message-number = _msg(message-counter).
  if message-number > 0 THEN
    RUN DisplayMessage(message-number).
END.

ON CHOOSE OF bPrev IN FRAME frMessage
DO:
  message-counter = message-counter + 1.
  message-number = _msg(message-counter).
  if message-number > 0 THEN
    RUN DisplayMessage(message-number).
END.

/****************************** Main Loop ******************************/
DO ON ERROR UNDO,LEAVE  ON ENDKEY UNDO, LEAVE:

  ASSIGN eMessage:READ-ONLY = TRUE
         eMessage:PFCOLOR   = 0
	 ffMsgNum:SCREEN-VALUE = ""
	 ffMsgNum:PFCOLOR   = 0
         message-number     = _msg(message-counter).

  /* Run time layout for button area. */
  {adecomm/okrun.i  
     &FRAME = "FRAME frMessage" 
     &BOX   = "rHeavyRule"
     &OK    = "bOK"
     &OTHER = "bNext bPrev"
     &HELP  = "bHelp"
  }

  ENABLE ALL EXCEPT ffMsgNum bHelp WITH FRAME frMessage.
  ENABLE bHelp {&WHEN_HELP} WITH FRAME frMessage.

  if message-number > 0 THEN
    RUN DisplayMessage(message-number).
  ELSE DO:
    ASSIGN eMessage:SCREEN-VALUE = "There are no messages to display."
           bNext:SENSITIVE = FALSE
	   bPrev:SENSITIVE = FALSE.
  END.

  WAIT-FOR CHOOSE OF bOk IN FRAME frMessage
    OR WINDOW-CLOSE OF FRAME frMessage
    OR GO OF FRAME frMessage FOCUS bOk.
END.
