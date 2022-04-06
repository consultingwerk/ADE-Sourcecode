/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

Procedure: prohelp/_msgs.p

Syntax: RUN prohelp/_msgs.p.

Purpose: Support for interacting with the Progress Message and/or
         OS Message facility.

Description:

Author: Ravi-Chandar Ramalingam

*****************************************************************************/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}
{adecomm/adestds.i}


/******************************* Definitions *********************************/
DEFINE VARIABLE ffMsgNum AS INTEGER FORMAT ">>>>>" LABEL "&Message Number".
DEFINE VARIABLE eMessage AS CHARACTER
        VIEW-AS EDITOR
        SIZE-CHAR 75 BY &IF "{&WINDOW-SYSTEM}" <> "TTY"
                        &THEN 8 &ELSE 11 &ENDIF
        SCROLLBAR-V PFCOLOR 0.
DEFINE VARIABLE lvStatus AS LOGICAL NO-UNDO.
DEFINE VARIABLE whLabel AS WIDGET-HANDLE NO-UNDO.

DEFINE BUTTON bOk LABEL "OK" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON bHelp LABEL "&Help" {&STDPH_OKBTN}.
DEFINE BUTTON bViewMessage LABEL "&View Message"
        SIZE 16 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT. 

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
      &OTHER  = "space({&HM_DBTNG}) bViewMessage"
      &HELP   = "bHelp"}

   WITH FRAME frMessage SIDE-LABELS DEFAULT-BUTTON bOk 
        TITLE "Messages" VIEW-AS DIALOG-BOX.

ASSIGN FRAME frMessage:PARENT = ACTIVE-WINDOW NO-ERROR.

{prohelp/msgs.i}
/**************************** Internal Procedures ***************************/

PROCEDURE DisplayMessage.
DEFINE VARIABLE msg-num AS INTEGER.
DEFINE VARIABLE description AS CHARACTER.

IF (ffMsgNum:SCREEN-VALUE IN FRAME frMessage) <> "" THEN
DO: /* Valid Message */
  msg-num = INTEGER(ffMsgNum:SCREEN-VALUE IN FRAME frMessage).
  RUN GetMessageDescription(msg-num, OUTPUT description).

  IF description = ? OR description = "?" OR description = "" THEN
    ASSIGN description = "No information is available for this PROGRESS message.".
  
  ASSIGN 
    eMessage:SCREEN-VALUE IN FRAME frMessage = description.

  APPLY "ENTRY" TO ffMsgNum IN FRAME frMessage.
END. /* Valid Message */
END PROCEDURE.

/*************************** UserInterface Triggers **************************/
/* Help triggers */
ON CHOOSE OF bHelp IN FRAME frMessage OR HELP OF FRAME frMessage
  RUN adecomm/_kwhelp.p ( INPUT eMessage:HANDLE, 
                          INPUT "comm"    , 
                          INPUT {&Messages_Dlg_Box} ).

ON ENTRY OF ffMsgNum IN FRAME frMessage DO:
  ASSIGN FRAME frMessage:DEFAULT-BUTTON = bViewMessage:HANDLE NO-ERROR.
END.


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
ON RETURN OF ffMsgNum IN FRAME frMessage
DO:
  APPLY "CHOOSE" TO bViewMessage.
  RETURN NO-APPLY.
END.
&ENDIF

ON CHOOSE OF bViewMessage IN FRAME frMessage DO:
  IF ffMsgNum:SCREEN-VALUE <> "" THEN
    RUN DisplayMessage.
  ELSE
    MESSAGE "Please enter a message number and then choose ""View Message""."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK
              IN WINDOW CURRENT-WINDOW.
END.

/****************************** Main Loop ******************************/
DO ON ERROR UNDO,LEAVE  ON ENDKEY UNDO, LEAVE:

  ASSIGN eMessage:READ-ONLY = TRUE.

  /* Run time layout for button area. */
  {adecomm/okrun.i  
     &FRAME = "FRAME frMessage" 
     &BOX   = "rHeavyRule"
     &OK    = "bOK" 
     &OTHER = "bViewMessage"
     &HELP  = "bHelp"
  }

  ENABLE ffMsgNum eMessage bOk bViewMessage bHelp {&WHEN_HELP}
    WITH FRAME frMessage.

  WAIT-FOR CHOOSE OF bOk IN FRAME frMessage
    OR WINDOW-CLOSE OF FRAME frMessage
    OR GO OF FRAME frMessage FOCUS ffMsgNum.
END.
