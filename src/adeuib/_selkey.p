&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r6
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    f_key
&Scoped-define FRAME-NAME     f_key
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_key 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _selkey.p

  Description: Asks the user to click any key. 

  Input Parameters:
      <none>

  Output Parameters:
      key_choice - The LABEL or FUNCTION of the last-key.

  Author: Wm.T.Wood

  Created: 04/15/93 -  4:26 pm

-----------------------------------------------------------------------------*/
/*             This .W file was created with the Progress UIB.               */
/*---------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN TRUE

/* Parameters Definitions ---                                                */
DEFINE OUTPUT PARAMETER  key_choice AS CHAR NO-UNDO INITIAL "".

/* Include Files. */
{adecomm/adestds.i}            /* Standard Definitions                       */
{adeuib/uibhlp.i}     	       /* Help pre-processor directives              */

/* Local Variable Definitions ---                                            */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Define a dialog box                                                  */

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12      SIZE {&W_OKBTN} BY {&H_OKBTN}.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12  LIKE btn_ok.
DEFINE BUTTON btn_help   LABEL "Help":C12    LIKE btn_ok.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE h AS WIDGET NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE last_fnctn AS CHARACTER LABEL "Key Function" FORMAT "X(38)" 
     VIEW-AS FILL-IN NATIVE SIZE 38 BY 1 {&STDPH_FILL} NO-UNDO.

DEFINE VARIABLE last_label LIKE last_fnctn LABEL "Key Label".
DEFINE VARIABLE event_name LIKE last_fnctn LABEL "Event Name".

DEFINE VARIABLE rslt_type AS INTEGER LABEL "Use"
     VIEW-AS RADIO-SET HORIZONTAL  
     RADIO-BUTTONS 
	"Key Function",1,
	"Key Label",0     NO-UNDO.

/* Definitions of the frame widgets                                     */
DEFINE FRAME f_key
     SKIP({&TFM_WID})
     event_name COLON 15 SKIP({&VM_WIDG}) SPACE({&HFM_WID})
     " Options" VIEW-AS TEXT {&STDPH_SDIV} SKIP ({&VM_WID})
     rslt_type COLON 15
     last_fnctn COLON 15 SKIP({&VM_WID})
     last_label COLON 15 SKIP({&VM_WIDG})

     "Press any key for keyboard event label and function." AT 3 VIEW-AS TEXT

     {adecomm/okform.i
      &BOX    = "rect_btns"
      &STATUS = "no"
      &OK     = "btn_ok"
      &CANCEL = "btn_cancel"
      &HELP   = "btn_help"}

    WITH VIEW-AS DIALOG-BOX SIDE-LABELS TITLE "Keyboard Event".

 
&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* ASSIGN RUN TIME ATTRIBUTES                                           */
/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME f_key" 
   &BOX   = "rect_btns"
   &OK    = "btn_ok" 
   &HELP  = "btn_help"
}

/* Widen the Window Options */
ASSIGN h = event_name:NEXT-SIBLING
       h:WIDTH = eff_frame_width - h:COL - {&HFM_WID} + 1.

/* Define temporary widget handle for run-time attributes               */
DEFINE VARIABLE tmp_handle  AS WIDGET-HANDLE NO-UNDO.

ASSIGN    /* DIALOG-BOX f_key  Attributes */
       FRAME f_key:VISIBLE          = FALSE.

/*  TEXT _LBL-last_fnctn 0 0 "last_fnctn"  */
/*  TEXT TEXT-1 1.52 3 "Return Key:"  */
/*  TEXT TEXT-2 1.52 17 "Last Event:"  */
/*  TEXT _LBL-last_label 0 0 "last_label"  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_key 
/* ----------------------------------------------------------- */
/*                     My Favorite Triggers.                   */
/* ----------------------------------------------------------- */

/* Help triggers */
ON CHOOSE OF btn_help IN FRAME f_key
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Keyboard_Events_Dlg_Box}, ? ).

ON VALUE-CHANGED OF rslt_type DO:
  IF SELF:SCREEN-VALUE = "0" THEN event_name = last_label.
  ELSE event_name = last_fnctn.
  IF event_name  = "?" THEN DO:
    MESSAGE "'?' is an illegal value for a trigger event in the UIB."
         VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY event_name VIEW-AS TEXT WITH FRAME {&FRAME-NAME}.
END.

/* Click ok to accept value */
ON CHOOSE OF btn_ok DO:
  key_choice = event_name.
  APPLY "WINDOW-CLOSE":U TO FRAME f_key.
END.

/* ANY-KEY in any valid field object changes the users choice */
ON ANY-KEY OF btn_ok, btn_cancel, btn_help, rslt_type DO:
  ASSIGN btn_ok:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
         last_label = LAST-EVENT:LABEL
         last_fnctn = LAST-EVENT:FUNCTION.

  /* Fill in empty functions */
  IF last_fnctn = "" THEN last_fnctn = last_label.

  /* Update Event Name */
  IF rslt_type:SCREEN-VALUE = "0" THEN event_name = last_label.
  ELSE event_name = last_fnctn.
  IF event_name  = "?" THEN DO:
    MESSAGE "'?' is an illegal value for a trigger event in the UIB."
         VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY event_name VIEW-AS TEXT last_label VIEW-AS TEXT
	last_fnctn VIEW-AS TEXT WITH FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */

/* Now enable the interface and wait for the exit condition. */
RUN enable_UI.
key_choice = "". /* Unless the user overrides this */
WAIT-FOR WINDOW-CLOSE OF FRAME f_key OR CHOOSE OF btn_cancel FOCUS btn_cancel.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_key _DEFAULT-ENABLE
PROCEDURE enable_UI .
  /* ----------------------------*/
  /* Default Enabling Procedure  */
  /* ----------------------------*/
  ENABLE ALL EXCEPT btn_ok WITH FRAME f_key.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME 


&UNDEFINE WINDOW-NAME
