&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE iSiteOldSequence1ICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSequence1RV  AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSequence2ICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSequence2RV  AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSessionIDICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSessionIDRV  AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lUpdateSequence iSiteSequence1ICF buOK ~
buCancel RECT-6 
&Scoped-Define DISPLAYED-OBJECTS iSiteNumberICF iSiteNumberRV ~
cSiteSequenceICF cSiteSequenceRV lUpdateSequence iSiteSequence1ICF ~
iSiteSequence1RV iSiteSequence2ICF iSiteSequence2RV iSiteSessionIDICF ~
iSiteSessionIDRV 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 20 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Set" 
     SIZE 20 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cSiteDivisionICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site Division" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteDivisionRV AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteReverseICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site Reverse" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteReverseRV AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteSequenceICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site Sequence" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteSequenceRV AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteNumberICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site Number" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteNumberRV AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence1ICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site Sequence 1" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence1RV AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence2ICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site Sequence 2" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence2RV AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSessionIDICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Session ID" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSessionIDRV AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.4 BY 11.14.

DEFINE VARIABLE lUpdateSequence AS LOGICAL INITIAL no 
     LABEL "Update Sequence Values" 
     VIEW-AS TOGGLE-BOX
     SIZE 42 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     iSiteNumberICF AT ROW 2.91 COL 18.8 COLON-ALIGNED
     iSiteNumberRV AT ROW 2.91 COL 40.8 COLON-ALIGNED NO-LABEL
     cSiteReverseICF AT ROW 7.29 COL 18.6 COLON-ALIGNED
     cSiteReverseRV AT ROW 7.29 COL 40.6 COLON-ALIGNED NO-LABEL
     cSiteDivisionICF AT ROW 8.71 COL 18.6 COLON-ALIGNED
     cSiteDivisionRV AT ROW 8.71 COL 40.6 COLON-ALIGNED NO-LABEL
     cSiteSequenceICF AT ROW 4.33 COL 18.6 COLON-ALIGNED
     cSiteSequenceRV AT ROW 4.33 COL 40.6 COLON-ALIGNED NO-LABEL
     lUpdateSequence AT ROW 5.57 COL 20.8
     iSiteSequence1ICF AT ROW 6.57 COL 18.6 COLON-ALIGNED
     iSiteSequence1RV AT ROW 6.52 COL 40.6 COLON-ALIGNED NO-LABEL
     iSiteSequence2ICF AT ROW 8 COL 18.6 COLON-ALIGNED
     iSiteSequence2RV AT ROW 7.95 COL 40.6 COLON-ALIGNED NO-LABEL
     iSiteSessionIDICF AT ROW 9.43 COL 18.6 COLON-ALIGNED
     iSiteSessionIDRV AT ROW 9.38 COL 40.6 COLON-ALIGNED NO-LABEL
     buOK AT ROW 10.86 COL 20.8
     buCancel AT ROW 10.91 COL 42.8
     RECT-6 AT ROW 1.29 COL 2.6
     "ICFDB" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 1.95 COL 20.8
     "RVDB (if connected)" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 1.95 COL 43.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.4 BY 11.81
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Set Site Number"
         HEIGHT             = 11.81
         WIDTH              = 65.4
         MAX-HEIGHT         = 47.86
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 47.86
         VIRTUAL-WIDTH      = 256
         MAX-BUTTON         = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */
/* SETTINGS FOR FILL-IN cSiteDivisionICF IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteDivisionICF:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSiteDivisionRV IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteDivisionRV:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSiteReverseICF IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteReverseICF:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSiteReverseRV IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteReverseRV:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSiteSequenceICF IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cSiteSequenceRV IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteNumberICF IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteNumberRV IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSequence1RV IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSequence2ICF IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSequence2RV IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSessionIDICF IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSessionIDRV IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Set Site Number */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Set Site Number */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Set_Site_Number_Dialog_Box}  , "":U).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Exit */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Set */
DO:

  ASSIGN
    iSiteNumberICF
    iSiteSequence1ICF
    iSiteSequence2ICF
    iSiteSessionIDICF
    iSiteNumberRV
    iSiteSequence1RV
    iSiteSequence2RV
    iSiteSessionIDRV
    .

  RUN setSequence.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUpdateSequence
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUpdateSequence C-Win
ON VALUE-CHANGED OF lUpdateSequence IN FRAME DEFAULT-FRAME /* Update Sequence Values */
DO:

  ASSIGN
    lUpdateSequence
    .

  RUN displaySequence.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN getSequence.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displaySequence C-Win 
PROCEDURE displaySequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    IF lUpdateSequence
    THEN
      ASSIGN
        iSiteSequence1ICF:SENSITIVE = YES   iSiteSequence1ICF:READ-ONLY = NO
        iSiteSequence2ICF:SENSITIVE = YES   iSiteSequence2ICF:READ-ONLY = NO
        iSiteSessionIDICF:SENSITIVE = YES   iSiteSessionIDICF:READ-ONLY = NO
        iSiteSequence1RV:SENSITIVE  = YES   iSiteSequence1RV:READ-ONLY  = NO
        iSiteSequence2RV:SENSITIVE  = YES   iSiteSequence2RV:READ-ONLY  = NO
        iSiteSessionIDRV:SENSITIVE  = YES   iSiteSessionIDRV:READ-ONLY  = NO
        .
    ELSE
      ASSIGN
        iSiteSequence1ICF:SENSITIVE = NO    iSiteSequence1ICF:READ-ONLY = YES
        iSiteSequence2ICF:SENSITIVE = NO    iSiteSequence2ICF:READ-ONLY = YES
        iSiteSessionIDICF:SENSITIVE = NO    iSiteSessionIDICF:READ-ONLY = YES
        iSiteSequence1RV:SENSITIVE  = NO    iSiteSequence1RV:READ-ONLY  = YES
        iSiteSequence2RV:SENSITIVE  = NO    iSiteSequence2RV:READ-ONLY  = YES
        iSiteSessionIDRV:SENSITIVE  = NO    iSiteSessionIDRV:READ-ONLY  = YES
        .

    ASSIGN
      lUpdateSequence:SCREEN-VALUE = STRING(lUpdateSequence)
      .

    DISPLAY
      iSiteSequence1ICF
      iSiteSequence2ICF
      iSiteSessionIDICF
      iSiteSequence1RV
      iSiteSequence2RV
      iSiteSessionIDRV
      .
    
    IF NOT CONNECTED("RVDB":U) THEN
      ASSIGN
        iSiteSequence1RV:SENSITIVE  = NO    iSiteSequence1RV:READ-ONLY  = YES
        iSiteSequence2RV:SENSITIVE  = NO    iSiteSequence2RV:READ-ONLY  = YES
        iSiteSessionIDRV:SENSITIVE  = NO    iSiteSessionIDRV:READ-ONLY  = YES
        iSiteNumberRV:SENSITIVE  = NO       iSiteNumberRV:READ-ONLY  = YES
        .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY iSiteNumberICF iSiteNumberRV cSiteSequenceICF cSiteSequenceRV 
          lUpdateSequence iSiteSequence1ICF iSiteSequence1RV iSiteSequence2ICF 
          iSiteSequence2RV iSiteSessionIDICF iSiteSessionIDRV 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE lUpdateSequence iSiteSequence1ICF buOK buCancel RECT-6 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequence C-Win 
PROCEDURE getSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cCalNumberRevICF  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCalNumberRevRV   AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE iLoop             AS INTEGER      NO-UNDO.

  DEFINE VARIABLE iSeqObj1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqObj2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSessnId          AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      iSiteNumberICF    = 0
      cSiteReverseICF   = "0":U
      cSiteDivisionICF  = "0":U
      cSiteSequenceICF  = "":U
      cCalNumberRevICF  = "":U
      iSiteSequence1ICF = 0
      iSiteSequence2ICF = 0
      iSiteSessionIDICF = 0
      iSiteNumberRV     = 0
      cSiteReverseRV    = "0":U
      cSiteDivisionRV   = "0":U
      cSiteSequenceRV   = "":U
      cCalNumberRevRV   = "":U
      iSiteSequence1RV  = 0
      iSiteSequence2RV  = 0
      iSiteSessionIDRV  = 0
      .

    IF CONNECTED("ICFDB":U)
    THEN DO:

      ASSIGN
        iSiteNumberICF:SENSITIVE = YES.

      RUN ry/app/rygetnobjp.p (INPUT NO,          /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).
      
      ASSIGN
        cSiteReverseICF   = STRING(iSeqSiteRev)
        cSiteDivisionICF  = STRING(iSeqSiteDiv)
        iSiteSequence1ICF = iSeqObj1
        iSiteSequence2ICF = iSeqObj2
        iSiteSessionIDICF = iSessnId
        .

      DO iLoop = LENGTH(cSiteReverseICF) TO 1 BY -1:
        cCalNumberRevICF  = cCalNumberRevICF + SUBSTRING(cSiteReverseICF,iLoop,1).
      END.

      IF  LENGTH(cSiteDivisionICF) > 1
      AND LENGTH(cSiteDivisionICF) > (LENGTH(cSiteReverseICF) + 1)
      THEN
      DO iLoop = (LENGTH(cSiteReverseICF) + 1) TO (LENGTH(cSiteDivisionICF) - 1):
        cCalNumberRevICF  = cCalNumberRevICF + "0".
      END.

      ASSIGN
        iSiteNumberICF    = INTEGER(cCalNumberRevICF)
        cSiteSequenceICF  = STRING( (INTEGER(cSiteReverseICF) / INTEGER(cSiteDivisionICF)) )
        .

    END.
    ELSE
      ASSIGN
        iSiteNumberICF:SENSITIVE = NO.

    IF CONNECTED("RVDB":U)
    THEN DO:

      ASSIGN
        iSiteNumberRV:SENSITIVE = YES.

      RUN rv/app/rvgetnobjp.p (INPUT  NO,         /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).

      ASSIGN
        cSiteReverseRV   = STRING(iSeqSiteRev)
        cSiteDivisionRV  = STRING(iSeqSiteDiv)
        iSiteSequence1RV = iSeqObj1
        iSiteSequence2RV = iSeqObj2
        iSiteSessionIDRV = iSessnId
        .

      DO iLoop = LENGTH(cSiteReverseRV) TO 1 BY -1:
        cCalNumberRevRV   = cCalNumberRevRV  + SUBSTRING(cSiteReverseRV,iLoop,1).
      END.

      IF  LENGTH(cSiteDivisionRV) > 1
      AND LENGTH(cSiteDivisionRV) > LENGTH(cCalNumberRevRV) + 1
      THEN
      DO iLoop = (LENGTH(cCalNumberRevRV) + 1) TO (LENGTH(cSiteDivisionRV) - 1 ):
        cCalNumberRevRV  = cCalNumberRevRV + "0".
      END.

      ASSIGN
        iSiteNumberRV     = INTEGER(cCalNumberRevRV)
        cSiteSequenceRV   = STRING( (INTEGER(cSiteReverseRV)  / INTEGER(cSiteDivisionRV)) )
        .

    END.
    ELSE
      ASSIGN
        iSiteNumberRV:SENSITIVE = NO.

    ASSIGN
      iSiteOldSequence1ICF = iSiteSequence1ICF
      iSiteOldSequence2ICF = iSiteSequence2ICF
      iSiteOldSessionIDICF = iSiteSessionIDICF
      iSiteOldSequence1RV  = iSiteSequence1RV
      iSiteOldSequence2RV  = iSiteSequence2RV
      iSiteOldSessionIDRV  = iSiteSessionIDRV
      .

    ASSIGN
      iSiteNumberICF:SCREEN-VALUE     = STRING(iSiteNumberICF)
      cSiteReverseICF:SCREEN-VALUE    = cSiteReverseICF
      cSiteDivisionICF:SCREEN-VALUE   = cSiteDivisionICF
      cSiteSequenceICF:SCREEN-VALUE   = cSiteSequenceICF
      iSiteNumberRV:SCREEN-VALUE      = STRING(iSiteNumberRV)
      cSiteReverseRV:SCREEN-VALUE     = cSiteReverseRV
      cSiteDivisionRV:SCREEN-VALUE    = cSiteDivisionRV
      cSiteSequenceRV:SCREEN-VALUE    = cSiteSequenceRV
      iSiteSequence1ICF:SCREEN-VALUE  = STRING(iSiteSequence1ICF)
      iSiteSequence2ICF:SCREEN-VALUE  = STRING(iSiteSequence2ICF)
      iSiteSessionIDICF:SCREEN-VALUE  = STRING(iSiteSessionIDICF)
      iSiteSequence1RV:SCREEN-VALUE   = STRING(iSiteSequence1RV)
      iSiteSequence2RV:SCREEN-VALUE   = STRING(iSiteSequence2RV)
      iSiteSessionIDRV:SCREEN-VALUE   = STRING(iSiteSessionIDRV)
      .

  END.

  RUN displaySequence.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSequence C-Win 
PROCEDURE setSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cCalReverseICF  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalReverseRV   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lContinueChange AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContinueDiff   AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iSeqObj1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqObj2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSessnId          AS INTEGER    NO-UNDO.

  ASSIGN
      cCalReverseICF = "":U
      cCalReverseRV  = "":U
      .

  IF CONNECTED("ICFDB":U)
  THEN DO:

    IF lUpdateSequence
    THEN DO:

      ASSIGN
        lContinueChange = NO
        lContinueDiff   = NO
        .

      RUN ry/app/rygetnobjp.p (INPUT NO,          /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).

      IF iSiteOldSequence1ICF <> iSeqObj1
      OR iSiteOldSequence2ICF <> iSeqObj2
      OR iSiteOldSessionIDICF <> iSessnId
      THEN
        MESSAGE "The ICFDB sequence values have been changed by another user"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueChange.
      ELSE
        ASSIGN
          lContinueChange = YES.

      IF iSiteSequence1ICF < iSeqObj1
      OR iSiteSequence2ICF < iSeqObj2
      OR iSiteSessionIDICF < iSessnId
      THEN
        MESSAGE "One or more of the new ICFDB sequence values are lower than the previous values"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueDiff.
      ELSE
        ASSIGN
          lContinueDiff = YES.

      IF  lContinueChange = NO
      OR lContinueDiff   = NO THEN
      DO: /* reset */
        ASSIGN
          iSiteSequence1ICF = iSeqObj1
          iSiteSequence2ICF = iSeqObj2
          iSiteSessionIDICF = iSessnId
          .
      END.
    END.

    DO iLoop = LENGTH(STRING(iSiteNumberICF)) TO 1 BY -1:
      cCalReverseICF = cCalReverseICF + SUBSTRING(STRING(iSiteNumberICF),iLoop,1).
    END.

    ASSIGN
      cSiteReverseICF    = cCalReverseICF
      cSiteDivisionICF   = "1":U + FILL("0":U,LENGTH(STRING(iSiteNumberICF)))
      cSiteSequenceICF   = STRING( (INTEGER(cSiteReverseICF) / INTEGER(cSiteDivisionICF)) )
      .

    RUN ry/app/rysetsitep.p (INPUT iSiteSequence1ICF,
                             INPUT iSiteSequence2ICF,
                             INPUT INTEGER(cSiteDivisionICF),
                             INPUT INTEGER(cSiteReverseICF),
                             INPUT iSiteSessionIDICF).
  END.

  IF CONNECTED("RVDB":U)
  THEN DO:

    IF lUpdateSequence
    THEN DO:

      ASSIGN
        lContinueChange = NO
        lContinueDiff   = NO
        .

      RUN rv/app/rvgetnobjp.p (INPUT  NO,         /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).

      IF iSiteOldSequence1RV <> iSeqObj1
      OR iSiteOldSequence2RV <> iSeqObj2
      OR iSiteOldSessionIDRV <> iSessnId
      THEN
        MESSAGE "The RVDB sequence values have been changed by another user"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueChange.
      ELSE
        ASSIGN
          lContinueChange = YES.

      IF iSiteSequence1RV < iSeqObj1
      OR iSiteSequence2RV < iSeqObj2
      OR iSiteSessionIDRV < iSessnId
      THEN
        MESSAGE "One or more of the new RVDB sequence values are lower than the previous values"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueDiff.
      ELSE
        ASSIGN
          lContinueDiff = YES.

      IF  lContinueChange = NO
      OR lContinueDiff   = NO THEN
      DO: /* reset */
        ASSIGN
          iSiteSequence1RV = iSeqObj1
          iSiteSequence2RV = iSeqObj2
          iSiteSessionIDRV = iSessnId
          .
      END.

    END.

    DO iLoop = LENGTH(STRING(iSiteNumberRV)) TO 1 BY -1:
      cCalReverseRV = cCalReverseRV + SUBSTRING(STRING(iSiteNumberRV),iLoop,1).
    END.

    ASSIGN
      cSiteReverseRV   = cCalReverseRV
      cSiteDivisionRV  = "1":U + FILL("0":U,LENGTH(STRING(iSiteNumberRV)))
      cSiteSequenceRV  = STRING( (INTEGER(cSiteReverseRV) / INTEGER(cSiteDivisionRV)) )
      .

    RUN rv/app/rvsetsitep.p (INPUT iSiteSequence1RV,
                             INPUT iSiteSequence2RV,
                             INPUT INTEGER(cSiteDivisionRV),
                             INPUT INTEGER(cSiteReverseRV),
                             INPUT iSiteSessionIDRV).

  END.

  ASSIGN
    lUpdateSequence = NO.

  RUN displaySequence.

  RUN getSequence.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

