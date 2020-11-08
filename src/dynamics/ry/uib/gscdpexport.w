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
  File: gscddexport.w

  Description:  Dataset Export Utility

  Purpose:      This utility generates XML files for selected data.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/26/2001  Author:     

  Update Notes: Created from Template rysttbconw.w
                Created from Template gscddexport.w

---------------------------------------------------------------------------------*/
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

&scop object-name       gscdpexport.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{src/adm2/globals.i}
{launch.i     &define-only = YES}
{checkerr.i &define-only = YES}

/* ttRequiredRecord contains the list of parameters that get passed to the 
   XML export procedure. This UI window derives the contents of this table
   from one of the contained objects. */
DEFINE TEMP-TABLE ttRequiredRecord          NO-UNDO
    FIELD iSequence             AS INTEGER
    FIELD cJoinFieldValue       AS CHARACTER        FORMAT "X(50)":U
    INDEX pudx IS UNIQUE PRIMARY
        iSequence
    .
DEFINE VARIABLE ghPackageDeploy         AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghDataSet               AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghDataSetEntity         AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghRecordSet             AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gcAction                AS CHARACTER                NO-UNDO.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buGenerate buExit buHelp fiProcess RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fiProcess 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetAction wiWin 
FUNCTION SetAction RETURNS LOGICAL
    ( INPUT pcAction     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscddrsxprtf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscdpxprtf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscdpxprtv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buExit 
     LABEL "E&xit" 
     SIZE 18.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     LABEL "&Export" 
     SIZE 18.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buHelp 
     LABEL "&Help" 
     SIZE 19 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiProcess AS CHARACTER FORMAT "X(256)":U 
     LABEL "Processing" 
      VIEW-AS TEXT 
     SIZE 72.4 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 147.2 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buGenerate AT ROW 25.48 COL 3.8
     buExit AT ROW 25.48 COL 109.8
     buHelp AT ROW 25.48 COL 129.4
     fiProcess AT ROW 25.76 COL 33 COLON-ALIGNED
     RECT-1 AT ROW 25.19 COL 2.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 150 BY 26.24.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Deployment Package Import and Export"
         HEIGHT             = 26.24
         WIDTH              = 150
         MAX-HEIGHT         = 28.57
         MAX-WIDTH          = 160
         VIRTUAL-HEIGHT     = 28.57
         VIRTUAL-WIDTH      = 160
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT wiWin:LOAD-ICON("adeicon/icfdev.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/icfdev.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Deployment Package Import and Export */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Deployment Package Import and Export */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buExit wiWin
ON CHOOSE OF buExit IN FRAME frMain /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate wiWin
ON CHOOSE OF buGenerate IN FRAME frMain /* Export */
DO:
  RUN writeADOs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + 'Package|Datasets|Record List' + 'TabFGcolor':U + 'Default' + 'TabBGcolor':U + 'Default' + 'TabINColor':U + 'GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '' + 'TabHidden':U + 'No' + 'EnableStates':U + 'All' + 'DisableStates':U + 'All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'AutoSized' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.57 , 2.20 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 23.43 , 147.20 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/gscdpxprtv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNamegsdddsxprtf.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscdpxprtv ).
       RUN repositionObject IN h_gscdpxprtv ( 3.57 , 5.80 ) NO-ERROR.
       /* Size in AB:  ( 18.38 , 103.20 ) */

       /* Links to SmartObject h_gscdpxprtv. */
       RUN addLink ( h_folder , 'Page':U , h_gscdpxprtv ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/gscdpxprtf.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'LogicalObjectNamePhysicalObjectNamegscdpxprtf.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscdpxprtf ).
       RUN repositionObject IN h_gscdpxprtf ( 3.48 , 3.40 ) NO-ERROR.
       /* Size in AB:  ( 21.10 , 144.60 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('1') NO-ERROR.

       /* Links to SmartFrame h_gscdpxprtf. */
       RUN addLink ( h_gscdpxprtv , 'Package':U , h_gscdpxprtf ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscddrsxprtf.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'LogicalObjectNamePhysicalObjectNamegscddrsxprtf.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscddrsxprtf ).
       RUN repositionObject IN h_gscddrsxprtf ( 3.38 , 3.00 ) NO-ERROR.
       /* Size in AB:  ( 20.91 , 144.20 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY fiProcess 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE buGenerate buExit buHelp fiProcess RECT-1 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
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
    DEFINE VARIABLE lAns            AS LOGICAL                          NO-UNDO.

    ASSIGN lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                                   "ICFDB":U) NO-ERROR.
    
    IF lAns = NO OR lAns = ? THEN
    DO:
        MESSAGE "This procedure requires a connection to at least the ICFDB database to work. It cannot be run across an AppServer."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN.
    END.

    RUN SUPER.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeADOs wiWin 
PROCEDURE writeADOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Obtain the buffer handles to the tables that we need to do this job. */
    RUN getPackageDeployBuffer  IN h_gscdpxprtv   ( OUTPUT ghPackageDeploy  /* HANDLE */).

    RUN getDatasetBuffer        IN h_gscdpxprtf   ( OUTPUT ghDataset        /* HANDLE */).
    RUN getDatasetEntityBuffer  IN h_gscdpxprtf   ( OUTPUT ghDatasetEntity  /* HANDLE */).

    RUN getRecordSetBuffer      IN h_gscddrsxprtf ( OUTPUT ghRecordSet      /* HANDLE */).

    /***
    { launch.i
        &PLIP         = 'af/app/gscddxmlp.p'
        &IProc        = '[Import|Export]Package'
        &PList        = "( INPUT ghPackageDeploy,
                           INPUT ghDataset,
                           INPUT ghDatasetEntity,
                           INPUT ghRecordSet     )"
        &AutoKill     = YES
    }
    ***/

    /* Reset the viewer. */
    RUN SetViewerState IN h_gscdpxprtv ( INPUT "INIT":U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetAction wiWin 
FUNCTION SetAction RETURNS LOGICAL
    ( INPUT pcAction     AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF pcAction EQ "INIT":U THEN
        ASSIGN buGenerate:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE
        ASSIGN buGenerate:LABEL     IN FRAME {&FRAME-NAME} = pcAction
               buGenerate:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               .
    ASSIGN gcAction = pcAction.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

