&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fFrameWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrfrm.w - ADM2 SmartFrame Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

 
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS edComment lCreate lBuild buPath1 fiPath1 ~
buPath2 fiPath2 edConnect fiConnect RECT-1 
&Scoped-Define DISPLAYED-OBJECTS edComment lCreate lBuild fiPath1 fiPath2 ~
edConnect fiConnect 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buPath1 
     LABEL "Browse..." 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buPath2 
     LABEL "Browse..." 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE edComment AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 77.2 BY 6.38 NO-UNDO.

DEFINE VARIABLE edConnect AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 73.6 BY 2.86 NO-UNDO.

DEFINE VARIABLE fiConnect AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 26.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiPath1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Path 1" 
     VIEW-AS FILL-IN 
     SIZE 43.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiPath2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Path 2" 
     VIEW-AS FILL-IN 
     SIZE 43.2 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76.4 BY 3.52.

DEFINE VARIABLE lBuild AS LOGICAL INITIAL no 
     LABEL "Build" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.4 BY .81 NO-UNDO.

DEFINE VARIABLE lCreate AS LOGICAL INITIAL no 
     LABEL "Create" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     edComment AT ROW 1.19 COL 1.4 NO-LABEL
     lCreate AT ROW 7.91 COL 4.6
     lBuild AT ROW 7.91 COL 42.6
     buPath1 AT ROW 8.95 COL 62.8
     fiPath1 AT ROW 9 COL 17.2 COLON-ALIGNED
     buPath2 AT ROW 10.24 COL 63
     fiPath2 AT ROW 10.29 COL 17.4 COLON-ALIGNED
     edConnect AT ROW 12.43 COL 3 NO-LABEL
     fiConnect AT ROW 11.67 COL 1 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 12.05 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.8 BY 14.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW fFrameWin ASSIGN
         HEIGHT             = 14.62
         WIDTH              = 78.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB fFrameWin 
/* ************************* Included-Libraries *********************** */

{install/inc/inuiframe.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW fFrameWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE                                                          */
ASSIGN 
       edComment:RETURN-INSERTED IN FRAME fMain  = TRUE
       edComment:READ-ONLY IN FRAME fMain        = TRUE.

ASSIGN 
       edConnect:RETURN-INSERTED IN FRAME fMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buPath1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buPath1 fFrameWin
ON CHOOSE OF buPath1 IN FRAME fMain /* Browse... */
DO:
  RUN btnChoose IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buPath2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buPath2 fFrameWin
ON CHOOSE OF buPath2 IN FRAME fMain /* Browse... */
DO:
  RUN btnChoose IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPath1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPath1 fFrameWin
ON LEAVE OF fiPath1 IN FRAME fMain /* Path 1 */
DO:
  RUN eventProc IN THIS-PROCEDURE ("LEAVE":U,"{&SELF-NAME}":U) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPath2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPath2 fFrameWin
ON LEAVE OF fiPath2 IN FRAME fMain /* Path 2 */
DO:
  RUN eventProc IN THIS-PROCEDURE ("LEAVE":U,"{&SELF-NAME}":U) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lCreate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lCreate fFrameWin
ON VALUE-CHANGED OF lCreate IN FRAME fMain /* Create */
DO:
  ASSIGN
    lCreate
  .
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fFrameWin 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects fFrameWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fFrameWin  _DEFAULT-DISABLE
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
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fFrameWin  _DEFAULT-ENABLE
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
  DISPLAY edComment lCreate lBuild fiPath1 fiPath2 edConnect fiConnect 
      WITH FRAME fMain.
  ENABLE edComment lCreate lBuild buPath1 fiPath1 buPath2 fiPath2 edConnect 
         fiConnect RECT-1 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSensitive fFrameWin 
PROCEDURE setSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF lCreate THEN
      ASSIGN
        lBuild:CHECKED = YES
        lBuild:SENSITIVE = NO
      .
    ELSE
      ASSIGN
        lBuild:SENSITIVE = YES
      .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

