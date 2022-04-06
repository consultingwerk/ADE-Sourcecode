/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _selindx.p

  Description: 
      Ask the user for the index of a array.

  Input Parameters:
      pi_array   -  the name of the array.
      pi_extent  -  the extent of the array.

  Output Parameters:
      p_index - the selected index (? if nothing chosen or user cancels)
  
  Author: Wm. T. Wood

  Created: 4/28/93
-----------------------------------------------------------------------------*/
/*             This .W file was created with the Progress UIB.               */
/*---------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{adecomm/commeng.i}   /* Help pre-processor directives                       */

/* Define Parameters. */
DEFINE INPUT  PARAMETER  pi_array     AS CHAR            NO-UNDO.
DEFINE INPUT  PARAMETER  pi_extent    AS INTEGER         NO-UNDO.
DEFINE OUTPUT PARAMETER  p_index      AS INTEGER         NO-UNDO.

/* _UIB-CODE-BLOCK-END */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE choice AS INTEGER NO-UNDO {&STDPH_FILL}
   FORMAT ">,>>9" LABEL "Choose Index".

DEFINE VARIABLE comment AS CHAR FORMAT "X(45)" NO-UNDO.
&IF {&OKBOX} &THEN
DEFINE RECTANGLE RECT-1 {&STDPH_OKBOX}.
&ENDIF
 
DEFINE BUTTON b_ok AUTO-GO LABEL "OK" {&STDPH_OKBTN}.

DEFINE BUTTON b_cancel AUTO-ENDKEY LABEL "Cancel"  {&STDPH_OKBTN}.

DEFINE BUTTON b_help  LABEL "&Help" {&STDPH_OKBTN}.

/* Definitions of the frame widgets                                     */
DEFINE FRAME f_index
     SKIP ({&TFM_WID}) SPACE({&HFM_WID})
     comment NO-LABEL VIEW-AS TEXT
     choice  COLON 25
     { adecomm/okform.i 
       &BOX    = RECT-1
       &OK     = b_ok
       &CANCEL = b_cancel
       &HELP   = b_help }
    WITH VIEW-AS DIALOG-BOX  SIDE-LABELS TITLE "Choose Index"
         DEFAULT-BUTTON b_ok.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_index 

/* Standard run-time layout */
{ adecomm/okrun.i 
       &FRAME  = "FRAME f_index"
       &BOX    = RECT-1
       &OK     = b_ok
       &CANCEL = b_cancel
       &HELP   = b_help }

/* Standard UIB stuff for dialog boxes - including WINDOW-CLOSE = END-ERROR  */

&Global-define SKP ""

PAUSE 0 BEFORE-HIDE.

/* WINDOW-CLOSE event will issue END-ERROR to the frame      */
ON WINDOW-CLOSE OF FRAME f_index APPLY "END-ERROR":U TO SELF.

/* ----------------------------------------------------------- */
/*                        TRIGGERS                             */
/* ----------------------------------------------------------- */

/* Standard Help Trigger */
ON CHOOSE OF b_help IN FRAME f_index OR HELP OF FRAME f_index
   RUN adecomm/_adehelp.p ( "comm", "CONTEXT", {&Choose_Index_Dlg_Box}, ? ).

/* Exit gracefully - Note that b_ok is AUTO-GO */
ON GO OF FRAME f_index DO:
  ASSIGN choice.
  IF choice < 1 or choice > pi_extent THEN DO:
    MESSAGE "The array index must be between 1 and" 
            TRIM(STRING(pi_extent,">>>,>>9."))
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN  NO-APPLY.
  END.
  ELSE p_index = choice. 
END.
   
/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */
ASSIGN choice  = 1
       comment = pi_array + " is an array with extent " +
                 TRIM(STRING(pi_extent,">>>,>>9.")).
DISPLAY comment VIEW-AS TEXT
        choice
   WITH FRAME f_index.

UPDATE choice b_ok b_cancel b_help WITH FRAME f_index.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

