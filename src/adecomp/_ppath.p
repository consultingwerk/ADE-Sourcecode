/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------------

  File: _ppath.p
    
  Syntax      : RUN adecomp/_ppath.p 
                      ( INPUT-OUTPUT p_Items_Selected ,
                        OUTPUT       p_Return_Status   ) .

  Description:  PROPATH Dialog box for Application Compiler Tool.

                Displays a list of the Progress PROPATH Directories. The user
                can select one or more and the directories selected are
                passed back to the calling routine.

  Input Parameters:
      <none>

  Input-Output Parameters:
      p_Items_Selected   :  Comma-delimited list of PROAPTH directory names
                            selected by user.

  Output Parameters:
      p_Return_Status    : Returns YES if user pressed OK; ? if user pressed
                           Cancel.
  Author: John Palazzo

  Created: 03/93

-----------------------------------------------------------------------------*/

/* Define Parameters. */
DEFINE INPUT-OUTPUT PARAMETER p_Items_Selected AS CHAR    INIT ? NO-UNDO.
DEFINE OUTPUT       PARAMETER p_Return_Status  AS LOGICAL INIT ? NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN YES
/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
    THEN RUN adecomm/_adeload.p.

/* Help Context Definitions. */
{ adecomp/comphelp.i }

/* Program-wide variables. */
DEFINE VAR Counter     AS INTEGER.
DEFINE VAR Temp_Status AS LOGICAL .

/* Definitions of the Dialog box field level widgets            */
DEFINE VARIABLE SELECT-1 AS CHARACTER 
                VIEW-AS SELECTION-LIST MULTIPLE NO-DRAG 
                        SIZE 73 BY 7 SCROLLBAR-V.

DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.
    
DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Help  LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE PP_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME DIALOG-2
    SKIP( {&TFM_WID} )
    "PROPATH Directories to Add to Compile List:" 
        {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
    SELECT-1 {&AT_OKBOX} NO-LABEL
    { adecomm/okform.i
        &BOX    ="PP_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  =" "
        &HELP   ="btn_Help" 
    }
    WITH OVERLAY NO-LABELS TITLE "PROPATH Selection"
        VIEW-AS DIALOG-BOX 
        DEFAULT-BUTTON btn_OK
        CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DIALOG-2"
        &BOX    = "PP_Btn_Box"
        &OK     = "btn_OK"
        &CANCEL = "btn_Cancel"
        &HELP   = "btn_Help"
    }

/******************************************************************/
/*                     UI TRIGGERS                                */
/******************************************************************/

ON HELP OF FRAME DIALOG-2 ANYWHERE
DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p
        ( INPUT "comp" ,
          INPUT "CONTEXT" , 
          INPUT {&Propath_Dialog_Box} , INPUT ? ).
  END.    
END.

ON CHOOSE OF btn_Help IN FRAME DIALOG-2
DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p
        ( INPUT "comp" ,
          INPUT "CONTEXT" , 
          INPUT {&Propath_Dialog_Box} , INPUT ? ).
  END.    
END.

ON DEFAULT-ACTION OF SELECT-1 IN FRAME DIALOG-2
  APPLY "GO" TO FRAME DIALOG-2.

ON GO OF FRAME DIALOG-2
DO:
    DO ON STOP UNDO, LEAVE:
        RUN PressedOK.
    END.
END.

ON WINDOW-CLOSE OF FRAME DIALOG-2
   OR CHOOSE OF btn_Cancel IN FRAME DIALOG-2
DO:
    DO ON STOP UNDO, LEAVE:
        RUN PressedCancel.
    END.
END.

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

PROCEDURE PressedOK.
    p_Return_Status = YES .
    p_Items_Selected = SELECT-1:SCREEN-VALUE IN FRAME DIALOG-2.
END.

PROCEDURE PressedCancel.
    p_Return_Status  = ? .
    p_Items_Selected = ?.
END.
 
/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */
/* MAIN */
DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:

  ASSIGN
      FRAME DIALOG-2:WIDTH  = FRAME DIALOG-2:WIDTH  + 1.0
      FRAME DIALOG-2:HEIGHT = FRAME DIALOG-2:HEIGHT + 0.3
  . /* END ASSIGN. */
  
  DO Counter = 1 TO NUM-ENTRIES( PROPATH ) :
    IF ( ENTRY( Counter , PROPATH ) <> "" )
    THEN Temp_Status = SELECT-1:ADD-LAST( ENTRY( Counter , PROPATH ) )
                       IN FRAME DIALOG-2.
    ELSE 
	IF ( OPSYS = "VMS" ) THEN 
		Temp_Status = SELECT-1:ADD-LAST("[]") IN FRAME DIALOG-2.
	ELSE
		Temp_Status = SELECT-1:ADD-LAST(".") IN FRAME DIALOG-2.
  END.

  DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    /* Now enable the interface and wait for the exit condition. */
    ENABLE ALL EXCEPT btn_Help WITH FRAME DIALOG-2.
    ENABLE btn_Help {&WHEN_HELP} WITH FRAME DIALOG-2.
    UPDATE SELECT-1
           GO-ON( WINDOW-CLOSE )
           WITH FRAME DIALOG-2.
  END.
       
END. /* MAIN */


