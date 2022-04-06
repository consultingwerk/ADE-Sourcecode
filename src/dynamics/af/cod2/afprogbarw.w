&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afprogbarw.w

  Description:  Progress Bar Window
  
  Purpose:      Progress Bar Window

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: AF2/NEW/ Debtors' Statements

----------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afprogbarw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{ af/sup2/afglobals.i }

DEFINE VARIABLE glStopRunning                   AS LOGICAL              NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buEnd 
     IMAGE-UP FILE "ry/img/foldopen.gif":U
     IMAGE-INSENSITIVE FILE "ry/img/foldopen.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 8.8 BY 1.91
     BGCOLOR 8 .

DEFINE BUTTON buRunner 
     IMAGE-UP FILE "adeicon/run.ico":U
     IMAGE-INSENSITIVE FILE "adeicon\run.ico":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 8.8 BY 1.91
     BGCOLOR 8 .

DEFINE BUTTON buStart 
     IMAGE-UP FILE "ry/img/foldclos.gif":U
     IMAGE-INSENSITIVE FILE "ry/img/foldclos.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 8.8 BY 1.91
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buEnd AT ROW 1 COL 47
     buRunner AT ROW 1 COL 10.2
     buStart AT ROW 1 COL 1.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.8 BY 1.91.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Progress Bar"
         HEIGHT             = 1.91
         WIDTH              = 54.8
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         ALWAYS-ON-TOP      = yes
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
/* SETTINGS FOR BUTTON buEnd IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buRunner IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buStart IN FRAME frMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Progress Bar */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Progress Bar */
DO:
    /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */
/* Include custom  Main Block code for SmartWindows. */
/* {src/adm2/windowmn.i} */

/* windowmn.i - New V9 Main Block code for objects which create windows.*/
/* Skip all of this if no window was created. */
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN
DO:
    ASSIGN CURRENT-WINDOW                    = {&WINDOW-NAME} 
           {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
           THIS-PROCEDURE:CURRENT-WINDOW     = {&WINDOW-NAME}
           .

    {af/sup2/aficonload.i}

    /* The CLOSE event can be used from inside or outside the procedure to  */
    /* terminate it.                                                        */
    ON CLOSE OF THIS-PROCEDURE 
    DO:
       RUN destroyObject.
       IF ERROR-STATUS:ERROR THEN
         RETURN NO-APPLY.
    END.

    /* Execute this code only if not being run PERSISTENT, i.e., if in test mode
       of one kind or another or if this is a Main Window. Otherwise postpone 
       'initialize' until told to do so. */
    &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    DO:
    &ENDIF
        /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
        MAIN-BLOCK:
        DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
     
            RUN initializeObject.
           
            IF NOT THIS-PROCEDURE:PERSISTENT THEN
               WAIT-FOR CLOSE OF THIS-PROCEDURE.
        END.
    &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
    END.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  VIEW FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endProgressBar wiWin 
PROCEDURE endProgressBar :
/*------------------------------------------------------------------------------
  Purpose:     Stops the progress bar.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN glStopRunning = YES.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
    APPLY "CLOSE":U TO THIS-PROCEDURE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCurrentWindow              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hCallingWindow              AS HANDLE               NO-UNDO.
    
    ASSIGN glStopRunning = NO.

    RUN SUPER.

    /* Reposition and get the run attribute. */
    {get ContainerHandle hCurrentWindow}.
    {get CallerWindow hCallingWindow}.

    ASSIGN hCurrentWindow:TITLE = DYNAMIC-FUNCTION("getRunAttribute":U).

    IF VALID-HANDLE(hCallingWindow) THEN
        ASSIGN hCurrentWindow:X = hCallingWindow:X + (hCallingWindow:WIDTH-PIXELS  - hCurrentWindow:WIDTH-PIXELS)  / 2
               hCurrentWindow:Y = hCallingWindow:Y + (hCallingWindow:HEIGHT-PIXELS - hCurrentWindow:HEIGHT-PIXELS) / 2
               NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startProgressBar wiWin 
PROCEDURE startProgressBar :
/*------------------------------------------------------------------------------
  Purpose:     Starts the progress bar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE iNewPosition            AS INTEGER                  NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        /* Start Position */
        ASSIGN buRunner:X = buStart:X + buStart:WIDTH-PIXELS.

        REPEAT:
            /* We process events to check whether to stop running.
             * The stop running flag is set in "endProgressBar".  */
            PROCESS EVENTS.
            IF glStopRunning = YES THEN
                LEAVE.

            PAUSE 1 NO-MESSAGE.

            ASSIGN iNewPosition = buRunner:X + ( buRunner:WIDTH-PIXELS / 2 ).

            IF (iNewPosition + buRunner:WIDTH-PIXELS) < buEnd:X THEN
                ASSIGN buRunner:X = iNewPosition.
            ELSE
                ASSIGN buRunner:X = buStart:X + buStart:WIDTH-PIXELS.           
        END.    /* repeat runner */
    END.    /* with frame ... */
        
    /* Once done, close down this window. */
    RUN exitObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

