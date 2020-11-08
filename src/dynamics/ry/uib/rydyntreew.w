&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Dynamic Container. No new instances of this should be created."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wTreeWin
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" wTreeWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wTreeWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wTreeWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wTreeWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyntreew.w

  Description:  Dynamic TreeView Container
  
  Purpose:      Dynamic TreeView Container

  Parameters:   <none>

  History:
  --------
  (v:010000)    July 2003 - Rewrite (Mark Davies - MIP)

-----------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       rydyntreew.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamiccontainer YES
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcLaunchLogicalObject   AS CHARACTER        NO-UNDO.
DEFINE VARIABLE gcLaunchRunAttribute    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE gcValueList             AS CHARACTER        NO-UNDO.

DEFINE VARIABLE ghTreeViewOCX AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fTreeMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiResizeFillIn fiTitle 
&Scoped-Define DISPLAYED-OBJECTS fiResizeFillIn fiTitle 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeBar wTreeWin 
FUNCTION getResizeBar RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTitleBar wTreeWin 
FUNCTION getTitleBar RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeViewOCX wTreeWin 
FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wTreeWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_smarttreeview AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiResizeFillIn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.4 BY 10.29
     BGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 54 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fTreeMain
     fiResizeFillIn AT ROW 1.48 COL 41 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTitle AT ROW 1.57 COL 42.6 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 10.86.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wTreeWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamic TreeView Controller"
         HEIGHT             = 10.86
         WIDTH              = 99
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wTreeWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/tvcontnr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wTreeWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fTreeMain
                                                                        */
ASSIGN 
       fiResizeFillIn:MOVABLE IN FRAME fTreeMain          = TRUE
       fiResizeFillIn:READ-ONLY IN FRAME fTreeMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wTreeWin)
THEN wTreeWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wTreeWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wTreeWin wTreeWin
ON END-ERROR OF wTreeWin /* Dynamic TreeView Controller */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE
DO:
    RUN windowEndError IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN NO-APPLY.
    
    APPLY "CLOSE":U TO TARGET-PROCEDURE. /* ensure close down nicely */

    /* Add the return no-apply so that the entire application doesn't shut down. */
    IF TARGET-PROCEDURE:PERSISTENT THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wTreeWin wTreeWin
ON WINDOW-CLOSE OF wTreeWin /* Dynamic TreeView Controller */
DO:
    /* This ADM code must be left here in order for the SmartWindow
     * and its descendents to terminate properly on exit. */
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wTreeWin wTreeWin
ON WINDOW-MINIMIZED OF wTreeWin /* Dynamic TreeView Controller */
DO:
    RUN windowMinimized IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wTreeWin wTreeWin
ON WINDOW-RESIZED OF wTreeWin /* Dynamic TreeView Controller */
DO:
  RUN resizeWindow IN TARGET-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      RETURN NO-APPLY.
  PUBLISH "windowResized":U FROM TARGET-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiResizeFillIn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiResizeFillIn wTreeWin
ON END-MOVE OF fiResizeFillIn IN FRAME fTreeMain
DO:
  PUBLISH "treeResized":U FROM TARGET-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wTreeWin 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN
DO:
    /* Window Container Specific Stuff */
    RUN start-super-proc IN TARGET-PROCEDURE ("ry/app/rydynwindp.p":U).   

    ASSIGN CURRENT-WINDOW                    = {&WINDOW-NAME} 
           {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
           TARGET-PROCEDURE:CURRENT-WINDOW   = {&WINDOW-NAME}
           .
  /* The CLOSE event can be used from inside or outside the procedure to  */
  /* terminate it.                                                        */
  ON CLOSE OF TARGET-PROCEDURE
  DO:
     RUN destroyObject IN TARGET-PROCEDURE NO-ERROR.
     IF ERROR-STATUS:ERROR THEN
       RETURN NO-APPLY.
  END.

  /* This will bring up all the links of the current object */
  ON CTRL-ALT-SHIFT-HOME ANYWHERE
  DO:
      RUN displayLinks IN TARGET-PROCEDURE.
  END.      

  /* By default, Make sure current-window is always the window with focus. */
  /* To get the old behavior, simply define OldCurrentWindowFocus.    */
  &IF DEFINED(OldCurrentWindowFocus) = 0 &THEN    /* if not defined */
    ON ENTRY OF {&WINDOW-NAME} DO:
      ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
    END.
  &ENDIF

  /* Execute this code only if not being run PERSISTENT, i.e., if in test mode
   of one kind or another or if this is a Main Window. Otherwise postpone 
   'initialize' until told to do so. */

  &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
  IF NOT TARGET-PROCEDURE:PERSISTENT THEN
  DO:
  &ENDIF
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
    /* Now enable the interface and wait for the exit condition.            */
        IF NOT TARGET-PROCEDURE:PERSISTENT THEN
        DO: 
            
            ASSIGN
              gcLaunchLogicalObject = "":U
              gcLaunchRunAttribute = "":U
              .
            
            /* the logical object name is presumed to be the first entry of 
               session param, and the run attribute is the second (if present) */
            IF SESSION:PARAM <> "":U THEN
            DO:
              ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,SESSION:PARAMETER)).
              IF NUM-ENTRIES(SESSION:PARAMETER) >= 2 THEN
                ASSIGN
                  gcLaunchRunAttribute = TRIM(ENTRY(2,SESSION:PARAMETER)).                
            END.
            ELSE
            DO:
              /* Try and get launch logical object and run attribute from
                 session properties instead
              */
                ASSIGN gcValueList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                      INPUT "launchlogicalobject,launchrunattribute":U,
                                                      INPUT YES).
                ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,gcValueList, CHR(3)))
                gcLaunchRunAttribute = TRIM(ENTRY(2,gcValueList, CHR(3)))
                .
            END.
            
            IF gcLaunchLogicalObject = "" THEN
            DO:
                MESSAGE "Cannot launch a dynamic object since SESSION:PARAMETER and/or the launchlogicalobject property does not contain a Logical Object Name.".
                RETURN.
            END.
               
            {set LogicalObjectName gcLaunchLogicalObject}.
            IF gcLaunchRunAttribute <> "":U THEN 
              {set RunAttribute gcLaunchRunAttribute}.    
        END.
        RUN initializeObject IN TARGET-PROCEDURE.
       
        IF NOT TARGET-PROCEDURE:PERSISTENT THEN
           WAIT-FOR CLOSE OF TARGET-PROCEDURE.
    END.
  &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
  END. /* IF NOT TARGET-PROCEDURE:PERSISTENT THEN */
  &ENDIF

END. /* IF VALID-HANDLE({&WINDOW-NAME}) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wTreeWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dyntreeview.w':U ,
             INPUT  FRAME fTreeMain:HANDLE ,
             INPUT  'AutoSortyesHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesnoTreeStyle7ExpandOnAddnoFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation5LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_smarttreeview ).
       RUN repositionObject IN h_smarttreeview ( 1.57 , 1.80 ) NO-ERROR.
       RUN resizeObject IN h_smarttreeview ( 10.19 , 41.20 ) NO-ERROR.

       /* Links to SmartTreeView h_smarttreeview. */
       RUN addLink ( h_smarttreeview , 'TVController':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wTreeWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wTreeWin)
  THEN DELETE WIDGET wTreeWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wTreeWin  _DEFAULT-ENABLE
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
  DISPLAY fiResizeFillIn fiTitle 
      WITH FRAME fTreeMain IN WINDOW wTreeWin.
  ENABLE fiResizeFillIn fiTitle 
      WITH FRAME fTreeMain IN WINDOW wTreeWin.
  {&OPEN-BROWSERS-IN-QUERY-fTreeMain}
  VIEW wTreeWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wTreeWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
    APPLY "CLOSE":U TO TARGET-PROCEDURE.
END PROCEDURE.  /* exitObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wTreeWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cErrorMessage           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.

    /* This is to in the .W to ensure that if there is stuff in a custom super procedure
     * that it will run. This is because the custom super procedure will execute BEFORE
     * any of the super procedures associated with this container window, rydywindp.p and
     * rydynframp.p.                                                                      */
    IF NOT {fn getObjectsCreated} THEN
    DO:
        RUN createObjects IN TARGET-PROCEDURE.

        /* The container handle will always be a window.
         * Check the error status because the window may already have been
         * shut down.                                                     */
        {get ContainerHandle hWindow} NO-ERROR.

        /* Check forced exit of the dynamic container. We may get window packing errors here. */
        IF NOT VALID-HANDLE(hWindow)                                    OR
            (VALID-HANDLE(hWindow)                                      AND
             LENGTH(hWindow:PRIVATE-DATA)            GT 0               AND
             ENTRY(1, hWindow:PRIVATE-DATA, CHR(3))  EQ "ForcedExit":U) THEN
        DO:
            /* Select Page in rydynframp.p might have shown this message already */
            IF NOT VALID-HANDLE(hWindow) OR (VALID-HANDLE(hWindow) AND LOOKUP("MessageShown-YES":U, hWindow:PRIVATE-DATA, CHR(3)) = 0) THEN
            DO:
                IF VALID-HANDLE(hWindow) AND NUM-ENTRIES(hWindow:PRIVATE-DATA, CHR(3)) GE 2 THEN
                    ASSIGN cErrorMessage = ENTRY(2, hWindow:PRIVATE-DATA, CHR(3)).

                IF cErrorMessage EQ "":U OR cErrorMessage EQ ? THEN
                    ASSIGN cErrorMessage = "Program aborted due to unknown reason":U.

                RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,           /* message to display */
                                                        INPUT  "ERR":U,                 /* error type */
                                                        INPUT  "&OK":U,                 /* button list */
                                                        INPUT  "&OK":U,                 /* default button */
                                                        INPUT  "&OK":U,                 /* cancel button */
                                                        INPUT  "Error on folder window creation":U, /* error window title */
                                                        INPUT  YES,                     /* display if empty */
                                                        INPUT  TARGET-PROCEDURE,        /* container handle */
                                                        OUTPUT cButton               ). /* button pressed */
            END.

            RUN destroyObject IN TARGET-PROCEDURE.
            RETURN.
        END.    /* forced exit */
    END.    /* Objects not already created. */

    /* The super will not run if there has been a forced exit. */
    RUN SUPER.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manualInitializeObjects wTreeWin 
PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       * This procedure is here because manualInitializeObjects is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that manualInitializeObjects will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    RUN SUPER.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* manualInitializeObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject wTreeWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize procedure.
  Parameters:  pdHeight -
               pcWidth  -
  Notes:       * This procedure is here because resizeObject is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that resizing will happen for 
                 dynamic containers.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeight             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdWidth              AS DECIMAL              NO-UNDO.
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this cse, simply ignore 
     * any errors.                                                         */
    RUN SUPER (INPUT pdHeight, INPUT pdWidth) NO-ERROR.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeBar wTreeWin 
FUNCTION getResizeBar RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN fiResizeFillIn:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTitleBar wTreeWin 
FUNCTION getTitleBar RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiTitle:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeViewOCX wTreeWin 
FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghTreeViewOCX) THEN 
    ghTreeViewOCX = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "TVController-Source":U))).

  RETURN ghTreeViewOCX.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

