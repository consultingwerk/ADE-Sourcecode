/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*******************************************************************************
    Procedure : _dlgrecm.p

    Purpose   : Dialog box to record user keystrokes for menu accelerator keys.

    Syntax    : RUN adecomm/_dlgrecm.p ( INPUT p_Menu_Item , 
					 INPUT-OUTPUT p_Accelerator) .

    Date      : 12.02.92

    Author    : John Palazzo
*******************************************************************************/

DEFINE INPUT PARAMETER p_Menu_Item AS CHAR FORMAT "x(30)" 
					LABEL "Menu Item".
DEFINE INPUT-OUTPUT PARAMETER p_Accelerator AS CHAR FORMAT "x(30)"
					LABEL "Accelerator Key".
/* ADE Stanards Include */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Help Context */
{ adecomm/commeng.i }

DEFINE VAR Menu_Item AS CHAR.
DEFINE VAR Accelerator AS CHAR.
DEFINE VAR ok_pressed as logical.
DEFINE VAR i as integer.
DEFINE VAR Recording AS LOGICAL INIT TRUE.

DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
    
DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Record  LABEL "&Record"
    SIZE 14 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
    
DEFINE BUTTON btn_Retry  LABEL "Re&try"
    {&STDPH_OKBTN}.

DEFINE BUTTON btn_Help  LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE RA_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    

FORM
  SKIP( {&TFM_WID} )
  "Press the keys you want to assign as the Accelerator Key." 
    {&AT_OKBOX} VIEW-AS TEXT
  SKIP( {&VM_WIDG} )
  p_Menu_Item    COLON 18 VIEW-AS TEXT 
  SKIP( {&VM_WIDG} )
  p_Accelerator  COLON 18 {&STDPH_FILL}
    { adecomm/okform.i
        &BOX    ="RA_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Record"
        &HELP   ="btn_Help" 
    }
  WITH FRAME Record_Accels SIDE-LABELS 
       VIEW-AS DIALOG-BOX TITLE "Record Menu Accelerator" 
               DEFAULT-BUTTON btn_OK 
               CANCEL-BUTTON btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME Record_Accels"
        &BOX    = "RA_Btn_Box"
        &OK     = "btn_OK"
        &HELP   = "btn_Help"
    }

/*------------------- UI Triggers -------------------*/
ON HELP OF FRAME Record_Accels ANYWHERE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" , 
        INPUT "CONTEXT" , INPUT {&Record_Menu_Accelerators} , INPUT ? ).

ON CHOOSE OF btn_Help IN FRAME Record_Accels
DO:
    IF ( Recording = TRUE )
    THEN DO:
        RUN StopRecording.
        APPLY "ENTRY" TO btn_Help.
    END.

    RUN adecomm/_adehelp.p
      ( INPUT "comm" , 
        INPUT "CONTEXT" , INPUT {&Record_Menu_Accelerators} , INPUT ? ).
END.

ON GO OF FRAME Record_Accels
DO:
    ASSIGN ok_pressed    = true
           p_Accelerator = p_Accelerator:SCREEN-VALUE
    . /* END ASSIGN */
END.

ON WINDOW-CLOSE OF FRAME Record_Accels 
   OR CHOOSE OF btn_Cancel IN FRAME Record_Accels
DO:
  ASSIGN ok_pressed    = ?
         p_Menu_Item   = Menu_Item
         p_Accelerator = Accelerator
  . /* END ASSIGN */
END.

ON "CHOOSE" OF btn_Record IN FRAME Record_Accels
DO:
    IF ( Recording = FALSE )
        THEN RUN StartRecording.
        ELSE DO:
            RUN StopRecording.
            APPLY "ENTRY" TO btn_Cancel.
        END.
END.

/*
ON LEAVE OF p_Accelerator IN FRAME Record_Accels
DO:
    RUN StopRecording.
END.
*/
  
ON ANY-KEY OF p_Accelerator IN FRAME Record_Accels
DO:
  DO ON STOP UNDO, LEAVE:
      IF CAN-DO("ENTER,RETURN,TAB" , LAST-EVENT:FUNCTION )
         OR CAN-DO("ENTER,RETURN,CTRL-TAB,TAB,SHIFT-TAB" , LAST-EVENT:LABEL)
      THEN DO:
          MESSAGE LAST-EVENT:LABEL SKIP
                  "Invalid Accelerator Key." SKIP(1)
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO SELF.
          RETURN NO-APPLY.
      END.
      
      ASSIGN p_Accelerator:SCREEN-VALUE = LAST-EVENT:LABEL .
      RUN StopRecording.
 
      APPLY "ENTRY" TO btn_OK.
      RETURN NO-APPLY.
  END.
  
END.

PROCEDURE StartRecording.
    ASSIGN Recording = TRUE
           btn_Record:LABEL IN FRAME Record_Accels = "Stop Record"
           p_Accelerator:SENSITIVE IN FRAME Record_Accels = TRUE
    . /* END ASSIGN */
    APPLY "ENTRY" TO p_Accelerator IN FRAME Record_Accels.
END PROCEDURE.


PROCEDURE StopRecording.
    ASSIGN Recording = FALSE
           btn_Record:LABEL IN FRAME Record_Accels = "&Record"
           p_Accelerator:SENSITIVE IN FRAME Record_Accels = FALSE
    . /* END ASSIGN */
END PROCEDURE.

/*------------------- MAIN -------------------*/
DO ON STOP UNDO, LEAVE :
    
    IF RETRY
    THEN DO:
        p_Accelerator = Accelerator.
        LEAVE.
    END.
    
    /* Run-Time Frame Layout */
    ASSIGN btn_Help:COLUMN IN FRAME Record_Accels = ( FRAME Record_Accels:WIDTH - btn_Help:WIDTH IN FRAME Record_Accels ) - 2.

    ASSIGN Menu_Item   = p_Menu_Item
           Accelerator = p_Accelerator.

    DISPLAY p_Menu_Item p_Accelerator WITH FRAME Record_Accels.
    ENABLE ALL WITH FRAME Record_Accels.
    RUN StartRecording.
    
    UPDATE p_Accelerator
           GO-ON ( GO,WINDOW-CLOSE )
           WITH FRAME Record_Accels .
  
  /*   
    WAIT-FOR GO,WINDOW-CLOSE OF FRAME Record_Accels 
             FOCUS p_Accelerator.
  */
    
END. /* Main */
