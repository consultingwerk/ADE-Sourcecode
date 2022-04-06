&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: afcalcpopd.w

  Description: Calculator pop-up

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(uib_is_running) <> 0 &THEN
  DEFINE VARIABLE ip_handle AS HANDLE NO-UNDO.
&ELSE
  DEFINE INPUT PARAMETER ip_handle AS HANDLE NO-UNDO.
&ENDIF

{src/adm2/globals.i}

/* Local Variable Definitions ---                                       */

  DEFINE VARIABLE lv_answer    AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE lv_display   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_operation AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFirstTime   AS LOGICAL   NO-UNDO   INIT YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bu_bk RECT-1 bu_7 bu_8 bu_9 bu_di bu_cl bu_4 ~
bu_5 bu_6 bu_mu bu_pr bu_1 bu_2 bu_3 bu_mi bu_1x bu_0 bu_pm bu_pt bu_pl ~
bu_eq bu_ok bu_cn 
&Scoped-Define DISPLAYED-OBJECTS fi_value 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatValue Dialog-Frame 
FUNCTION formatValue RETURNS CHARACTER
  (INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_0 
     LABEL "0" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_1 
     LABEL "1" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_1x 
     LABEL "1/x" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_2 
     LABEL "2" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_3 
     LABEL "3" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_4 
     LABEL "4" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_5 
     LABEL "5" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_6 
     LABEL "6" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_7 
     LABEL "7" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_8 
     LABEL "8" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_9 
     LABEL "9" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_bk 
     LABEL "<-" 
     SIZE 6.4 BY .95.

DEFINE BUTTON bu_cl 
     LABEL "C" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_cn AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bu_di 
     LABEL "/" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_eq 
     LABEL "=" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_mi 
     LABEL "-" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_mu 
     LABEL "*" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_ok AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON bu_pl 
     LABEL "+" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_pm 
     LABEL "+~\-" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_pr 
     LABEL "%" 
     SIZE 6.4 BY 1.52.

DEFINE BUTTON bu_pt 
     LABEL "." 
     SIZE 6.4 BY 1.52.

DEFINE VARIABLE fi_value AS DECIMAL FORMAT "->,>>>,>>>,>>>,>>>,>>9.99<<<<<<<<":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 29.4 BY 1
     BGCOLOR 0 FGCOLOR 10  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.4 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fi_value AT ROW 1 COL 1 NO-LABEL
     bu_bk AT ROW 1 COL 31
     bu_7 AT ROW 2.43 COL 2
     bu_8 AT ROW 2.43 COL 9
     bu_9 AT ROW 2.43 COL 16
     bu_di AT ROW 2.43 COL 23
     bu_cl AT ROW 2.43 COL 31
     bu_4 AT ROW 4.1 COL 2
     bu_5 AT ROW 4.1 COL 9
     bu_6 AT ROW 4.1 COL 16
     bu_mu AT ROW 4.1 COL 23
     bu_pr AT ROW 4.1 COL 31
     bu_1 AT ROW 5.76 COL 2
     bu_2 AT ROW 5.76 COL 9
     bu_3 AT ROW 5.76 COL 16
     bu_mi AT ROW 5.76 COL 23
     bu_1x AT ROW 5.76 COL 31
     bu_0 AT ROW 7.43 COL 2
     bu_pm AT ROW 7.43 COL 9
     bu_pt AT ROW 7.43 COL 16
     bu_pl AT ROW 7.43 COL 23
     bu_eq AT ROW 7.43 COL 31
     bu_ok AT ROW 9.38 COL 6.2
     bu_cn AT ROW 9.38 COL 18.8
     RECT-1 AT ROW 2.19 COL 1
     SPACE(7.39) SKIP(1.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Calculator"
         DEFAULT-BUTTON bu_ok CANCEL-BUTTON bu_cn.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi_value IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi_value:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Calculator */
DO:
  DEFINE VARIABLE cCurrentValue AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(ip_handle) AND CAN-QUERY(ip_handle,"screen-value":U) THEN
  DO:
    DEFINE VARIABLE dValue AS DECIMAL INITIAL 0 NO-UNDO.
    ASSIGN dValue = DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}) NO-ERROR.      
    ASSIGN 
       cCurrentValue         = ip_handle:SCREEN-VALUE
       ip_handle:SCREEN-VALUE = STRING(dValue) NO-ERROR.
    IF ERROR-STATUS:GET-MESSAGE(1) > '' THEN
    DO:
      cError = ERROR-STATUS:GET-MESSAGE(1).
      ip_handle:SCREEN-VALUE = cCurrentValue NO-ERROR.

      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                    {aferrortxt.i 'AF' '150' '' '' fi_value:SCREEN-VALUE ip_handle:FORMAT}.

      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERROR":U,
                                             INPUT "OK",
                                             INPUT "OK",
                                             INPUT ?,
                                             INPUT "Error",
                                             INPUT TRUE,
                                             INPUT THIS-PROCEDURE,
                                             OUTPUT cButton).
      RETURN NO-APPLY.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Calculator */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_0 Dialog-Frame
ON CHOOSE OF bu_0 IN FRAME Dialog-Frame /* 0 */
,bu_1,bu_2,bu_3,bu_4,bu_5,bu_6,bu_7,bu_8,bu_9
DO:    
    IF DECIMAL({fnarg formatValue "lv_display + SELF:LABEL"}) GT 99999999999999 
    THEN DO:
      BELL.
      RETURN NO-APPLY.
    END.  
    
    IF lFirstTime THEN 
      ASSIGN lv_display = Self:LABEL.
    ELSE
      ASSIGN lv_display = lv_display + SELF:LABEL.     
     
    ASSIGN lFirstTime = NO.

    DISPLAY 
        DECIMAL({fnarg formatValue lv_display}) @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_1x
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_1x Dialog-Frame
ON CHOOSE OF bu_1x IN FRAME Dialog-Frame /* 1/x */
DO:
    ASSIGN
      lv_display = STRING(1 / DECIMAL({fnarg formatValue lv_display})).

    DISPLAY
        DECIMAL({fnarg formatValue lv_display}) @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_bk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_bk Dialog-Frame
ON CHOOSE OF bu_bk IN FRAME Dialog-Frame /* <- */
DO:
    ASSIGN
        lv_display = SUBSTRING(lv_display,1,LENGTH(lv_display) - 1 ).

    DISPLAY
        DECIMAL({fnarg formatValue lv_display}) @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_cl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_cl Dialog-Frame
ON CHOOSE OF bu_cl IN FRAME Dialog-Frame /* C */
DO:
    ASSIGN
        lv_display = "":U
        lv_answer  = 0.
    DISPLAY
        lv_answer @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_cn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_cn Dialog-Frame
ON CHOOSE OF bu_cn IN FRAME Dialog-Frame /* Cancel */
DO:
  ASSIGN fi_value:SCREEN-VALUE = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_eq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_eq Dialog-Frame
ON CHOOSE OF bu_eq IN FRAME Dialog-Frame /* = */
,bu_pl,bu_mi,bu_mu,bu_di
DO:
    RUN mip-calculate IN THIS-PROCEDURE(SELF:NAME).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_ok Dialog-Frame
ON CHOOSE OF bu_ok IN FRAME Dialog-Frame /* OK */
DO:
    APPLY "choose" TO bu_eq.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_pm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_pm Dialog-Frame
ON CHOOSE OF bu_pm IN FRAME Dialog-Frame /* +\- */
DO:
    ASSIGN
        fi_value:SCREEN-VALUE = STRING(DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}) * -1)
        lv_display            = fi_value:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_pr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_pr Dialog-Frame
ON CHOOSE OF bu_pr IN FRAME Dialog-Frame /* % */
DO:
    ASSIGN
        lv_display = STRING(lv_answer * DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}) / 100).

    DISPLAY
        DECIMAL({fnarg formatValue lv_display}) @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_pt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_pt Dialog-Frame
ON CHOOSE OF bu_pt IN FRAME Dialog-Frame /* . */
DO:
   IF lFirstTime THEN 
   DO:
     lv_display = "0" + SESSION:NUMERIC-DECIMAL-POINT .
     DISPLAY
         DECIMAL({fnarg formatValue lv_display}) @ fi_value 
         WITH FRAME {&FRAME-NAME} NO-ERROR.
   END.    
   ELSE IF INDEX(lv_display,SESSION:NUMERIC-DECIMAL-POINT) = 0 
   THEN DO:
        ASSIGN
            lv_display = lv_display + SELF:LABEL.
            
        DISPLAY
            DECIMAL({fnarg formatValue lv_display}) @ fi_value 
            WITH FRAME {&FRAME-NAME} NO-ERROR.
   END.
   lFirstTime = No.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */


FRAME {&FRAME-NAME}:PRIVATE-DATA = "nolookups".

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

IF SESSION:NUMERIC-DECIMAL-POINT = ",":U THEN
DO:
  bu_pt:LABEL = ",":U.
END.

ON ANY-PRINTABLE ANYWHERE DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE KEYLABEL(LASTKEY):
          WHEN "0" THEN APPLY "choose" TO bu_0.
          WHEN "1" THEN APPLY "choose" TO bu_1.
          WHEN "2" THEN APPLY "choose" TO bu_2.
          WHEN "3" THEN APPLY "choose" TO bu_3.
          WHEN "4" THEN APPLY "choose" TO bu_4.
          WHEN "5" THEN APPLY "choose" TO bu_5.
          WHEN "6" THEN APPLY "choose" TO bu_6.
          WHEN "7" THEN APPLY "choose" TO bu_7.
          WHEN "8" THEN APPLY "choose" TO bu_8.
          WHEN "9" THEN APPLY "choose" TO bu_9.
          WHEN "c" THEN APPLY "choose" TO bu_cl.
          WHEN "x" THEN APPLY "choose" TO bu_1x.
          WHEN "%" THEN APPLY "choose" TO bu_pr. 
          WHEN "\" THEN APPLY "choose" TO bu_pm.
          WHEN "," THEN APPLY "choose" TO bu_pt.
          WHEN "." THEN APPLY "choose" TO bu_pt.
          WHEN "=" THEN APPLY "choose" TO bu_eq. 
          WHEN "+" THEN APPLY "choose" TO bu_pl.
          WHEN "-" THEN APPLY "choose" TO bu_mi.  
          WHEN "*" THEN APPLY "choose" TO bu_mu.
          WHEN "/" THEN APPLY "choose" TO bu_di.
          OTHERWISE BELL.  
        END CASE.
    END.
END.

ON BACKSPACE ANYWHERE DO:
    DO WITH FRAME {&FRAME-NAME}:
        APPLY "choose" TO bu_bk.
    END.    
END.

ON RETURN ANYWHERE DO:
    DO WITH FRAME {&FRAME-NAME}:
        APPLY "choose" TO bu_ok.
    END.
END.


/* position dialog */
DEFINE VARIABLE hParentFrame  AS HANDLE     NO-UNDO. /* This is the parent fill-in's frame */
DEFINE VARIABLE hParentWindow AS HANDLE     NO-UNDO. /* This is the parent fill-in's window */
DEFINE VARIABLE hParent       AS HANDLE     NO-UNDO. /* This is the calculator's window */
DEFINE VARIABLE dRow          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dCol          AS DECIMAL    NO-UNDO.

ASSIGN hParent = FRAME {&FRAME-NAME}:PARENT.

/* Calculate where the calculator should be */

IF VALID-HANDLE(ip_handle) THEN /* Position with field */
  ASSIGN hParentFrame   = ip_handle:FRAME
         hParentWindow  = hParentFrame:PARENT
         dcol           = MAXIMUM(1,hParentWindow:COL + hParentFrame:COL + ip_handle:COL + ip_handle:WIDTH - 5)
         drow           = MAXIMUM(1,hParentWindow:ROW + hParentFrame:ROW + ip_handle:ROW).
ELSE /* Centre widget on display */
  ASSIGN drow = MAXIMUM(1,(SESSION:HEIGHT - FRAME {&FRAME-NAME}:HEIGHT) / 2)
              - hParent:ROW
         dcol = MAXIMUM(1,(SESSION:WIDTH - FRAME {&FRAME-NAME}:WIDTH) / 2)
              - hParent:COLUMN.

/* Position the calculator on where we determined it should be */

ASSIGN FRAME {&FRAME-NAME}:ROW    = drow
       FRAME {&FRAME-NAME}:COLUMN = dcol.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    
   /* This makes no sense... sybnchronization moved to GO trigger  
      Now make sure the calculator and parent field formats are synched 
     IF VALID-HANDLE(ip_handle) AND CAN-QUERY(ip_handle, "FORMAT":U) THEN
         ASSIGN fi_value:FORMAT = ip_handle:FORMAT NO-ERROR.
    */

    RUN enable_UI.
    IF VALID-HANDLE(ip_handle) AND CAN-QUERY(ip_handle,"screen-value":U) THEN
    DO WITH FRAME {&FRAME-NAME}:
      DEFINE VARIABLE dValue AS DECIMAL INITIAL 0 NO-UNDO.
      ASSIGN dValue = DECIMAL({fnarg formatValue ip_handle:SCREEN-VALUE}) NO-ERROR.      
      DISPLAY dValue @ fi_value.
      lv_display = fi_value:SCREEN-VALUE.
    END.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi_value 
      WITH FRAME Dialog-Frame.
  ENABLE bu_bk RECT-1 bu_7 bu_8 bu_9 bu_di bu_cl bu_4 bu_5 bu_6 bu_mu bu_pr 
         bu_1 bu_2 bu_3 bu_mi bu_1x bu_0 bu_pm bu_pt bu_pl bu_eq bu_ok bu_cn 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-calculate Dialog-Frame 
PROCEDURE mip-calculate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_operation AS CHARACTER NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        CASE lv_operation:
          WHEN "bu_pl" THEN lv_answer = lv_answer + DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}).
          WHEN "bu_mi" THEN lv_answer = lv_answer - DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}).
          WHEN "bu_mu" THEN lv_answer = lv_answer * DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}).
          WHEN "bu_di" THEN lv_answer = lv_answer / DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}).
          OTHERWISE lv_answer = DECIMAL({fnarg formatValue fi_value:SCREEN-VALUE}).
        END CASE.
    END.

    ASSIGN
        lv_display = ""
        lv_operation = ip_operation.
        
   DISPLAY
        lv_answer @ fi_value 
        WITH FRAME {&FRAME-NAME} NO-ERROR.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatValue Dialog-Frame 
FUNCTION formatValue RETURNS CHARACTER
  (INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount              AS INTEGER                NO-UNDO.
  DEFINE VARIABLE cFormattedValue     AS CHARACTER INITIAL  ""  NO-UNDO.
  DEFINE VARIABLE cSingleCharacter    AS CHARACTER INITIAL  ""  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
  
    DO iCount = 1 TO LENGTH(pcValue):
    
      ASSIGN cSingleCharacter = SUBSTRING(pcValue, iCount, 1) NO-ERROR.
      
      IF cSingleCharacter >= "0":U AND cSingleCharacter <= "9":U
      OR cSingleCharacter  = SESSION:NUMERIC-DECIMAL-POINT
      OR cSingleCharacter  = '-':U
      THEN
        ASSIGN cFormattedValue = cFormattedValue + cSingleCharacter.                              
                               
    END.
    
  END.
  
  RETURN cFormattedValue.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

