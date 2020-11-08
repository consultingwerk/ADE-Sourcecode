&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
* Copyright (C) 2000,2007 by Progress Software Corporation. All      *
*rights reserved. Prior versions of this work may contain portions   *
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

&scop object-name       gscddexprtw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}
{afrun2.i     &define-only = YES}

DEFINE VARIABLE glDoOnceOnly  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghDSAPI       AS HANDLE     NO-UNDO.
DEFINE VARIABLE glWritingADOs AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 buGenerate fiProcess 
&Scoped-Define DISPLAYED-OBJECTS fiProcess 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscdddsxprtf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscddrsxprtf AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buGenerate 
     LABEL "&Generate" 
     SIZE 18.8 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiProcess AS CHARACTER FORMAT "X(256)":U 
     LABEL "Processing" 
      VIEW-AS TEXT 
     SIZE 113.2 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 147.2 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buGenerate AT ROW 27.95 COL 3.8
     fiProcess AT ROW 28.24 COL 33 COLON-ALIGNED
     RECT-1 AT ROW 27.67 COL 2.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 150 BY 28.52.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 2
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dataset Export"
         HEIGHT             = 28.52
         WIDTH              = 150
         MAX-HEIGHT         = 29.43
         MAX-WIDTH          = 160
         VIRTUAL-HEIGHT     = 29.43
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
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Dataset Export */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Dataset Export */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate wiWin
ON CHOOSE OF buGenerate IN FRAME frMain /* Generate */
DO:
  RUN writeADOs.
  RETURN NO-APPLY.
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
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceToolbarBandsToolbarAutoSizeyesToolbarDrawDirectionHorizontalLogicalObjectNameFolderTopNoSDODisabledActionsHiddenActionsUpdate,Txtok,TxtcancelHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.57 , 150.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + 'Datasets|Record List' + 'TabFGcolor':U + 'Default|Default' + 'TabBGcolor':U + 'Default|Default' + 'TabINColor':U + 'GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '' + 'TabHidden':U + 'no|no' + 'EnableStates':U + 'All|All' + 'DisableStates':U + 'All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'Tabs' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 2.43 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 25.00 , 147.00 ) NO-ERROR.

       /* Links to toolbar h_dyntoolbar. */
       RUN addLink ( h_dyntoolbar , 'ContainerToolbar':U , THIS-PROCEDURE ).

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             buGenerate:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscdddsxprtf.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'LogicalObjectNamePhysicalObjectNamegsdddsxprtf.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscdddsxprtf ).
       RUN repositionObject IN h_gscdddsxprtf ( 3.62 , 4.00 ) NO-ERROR.
       /* Size in AB:  ( 23.57 , 144.00 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('2':U) NO-ERROR.

       /* Links to SmartFrame h_gscdddsxprtf. */
       RUN addLink ( h_gscddrsxprtf , 'recordSet':U , h_gscdddsxprtf ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscdddsxprtf ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscddrsxprtf.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'LogicalObjectNamePhysicalObjectNamegscddrsxprtf.wDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscddrsxprtf ).
       RUN repositionObject IN h_gscddrsxprtf ( 4.14 , 3.40 ) NO-ERROR.
       /* Size in AB:  ( 20.91 , 144.20 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('1':U) NO-ERROR.

       /* Links to SmartFrame h_gscddrsxprtf. */
       RUN addLink ( h_gscdddsxprtf , 'updateRecordSet':U , h_gscddrsxprtf ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscddrsxprtf ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelWrite wiWin 
PROCEDURE cancelWrite :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    buGenerate:LABEL = "&Generate":U.
    glWritingADOs = NO.
    MESSAGE "Cancel":U
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DSAPI_StatusUpdate wiWin 
PROCEDURE DSAPI_StatusUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Handles the status update event in from the API
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcText AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    fiProcess:SCREEN-VALUE = pcText.
  END.
  PROCESS EVENTS.
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
  ENABLE RECT-1 buGenerate fiProcess 
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
  DEFINE VARIABLE lAns AS LOGICAL    NO-UNDO.

  lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                          "ICFDB":U) NO-ERROR.

  IF lAns = NO OR 
     lAns = ? THEN
  DO:
    MESSAGE "This procedure requires a connection to at least the ICFDB database to work. It cannot be run across an AppServer."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN.
  END.

  {af/sup2/aficonload.i}

    /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                        OUTPUT ghDSAPI).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects wiWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dInnerRow         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  IF NOT glDoOnceOnly THEN
  DO:
    /* Fetch the repository class*/
    hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).
  
    IF VALID-HANDLE(hClassBuffer) THEN
      hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   
  
    IF VALID-HANDLE(hAttributeBuffer) THEN
    DO:
      hAttributeBuffer:BUFFER-CREATE().
  
      {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" h_folder}.
      {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      h_folder}.
      {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           h_folder}.
  
      hAttributeBuffer:BUFFER-DELETE().
    END.
    
    glDoOnceOnly = TRUE.

    RUN initializeObject IN h_folder.
  END.
  
  dInnerRow = {fn getInnerRow h_folder} + 0.12.

  IF VALID-HANDLE(h_gscdddsxprtf) THEN
    RUN repositionObject IN h_gscdddsxprtf (INPUT dInnerRow,
                                            INPUT {fn getCol h_gscdddsxprtf}).
  
  IF VALID-HANDLE(h_gscddrsxprtf) THEN
    RUN repositionObject IN h_gscddrsxprtf (INPUT dInnerRow,
                                            INPUT {fn getCol h_gscddrsxprtf}).

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
  DEFINE VARIABLE hDataSet        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordSet      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cOutDir         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutBlank       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOutRelative    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cExtra          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lResetModified  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIncludeDeletes AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRemoveDeletes  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDeployModified AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFullDS         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lByDate         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dtStart         AS DATE       NO-UNDO.
  DEFINE VARIABLE dtEnd           AS DATE       NO-UNDO.


  DEFINE VARIABLE dStart AS DATE       NO-UNDO.
  DEFINE VARIABLE tStart AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dEnd   AS DATE       NO-UNDO.
  DEFINE VARIABLE tEnd   AS INTEGER    NO-UNDO.
  
  /* Obtain the buffer handles to the two tables that we need to do this
     job. */
  RUN getDatasetBuffer IN h_gscdddsxprtf
    ( OUTPUT hDataset   /* HANDLE */).

  RUN getRecordSetBuffer IN h_gscddrsxprtf
    ( OUTPUT hRecordset /* HANDLE */).

  RUN getDirectory IN h_gscdddsxprtf
    ( OUTPUT cOutDir /* CHARACTER */,
      OUTPUT cOutBlank,
      OUTPUT lResetModified,
      OUTPUT lIncludeDeletes,
      OUTPUT lRemoveDeletes,
      OUTPUT lDeployModified,
      OUTPUT lFullDS,
      OUTPUT lByDate,
      OUTPUT dtStart,
      OUTPUT dtEnd).

  SUBSCRIBE TO "DSAPI_StatusUpdate":U IN ghDSAPI.

  dStart = TODAY.
  tStart = TIME.

  session:set-wait-state('general':u).  
  RUN writeADOSet IN ghDSAPI
    (cOutDir, 
     cOutBlank, 
     lResetModified,
     lIncludeDeletes,
     lRemoveDeletes,
     lDeployModified,
     lFullDS,
     hDataset, 
     hRecordSet,
     lByDate,
     dtStart,
     dtEnd).  
  session:set-wait-state('':u).
  UNSUBSCRIBE TO "DSAPI_StatusUpdate":U IN ghDSAPI.
  
  dEnd = TODAY.
  tEnd = TIME.

  IF LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "_debug_tools_on":U)) = YES THEN
  DO:
    OUTPUT TO gscddxmlpstat.txt APPEND.
    EXPORT "Dataset Export":U STRING(dStart,"99/99/9999") STRING(tStart,"HH:MM:SS") STRING(dEnd,"99/99/9999") STRING(tEnd,"HH:MM:SS").
    OUTPUT CLOSE.
  END.
  
  RUN refreshData IN h_gscdddsxprtf.
  RUN refreshData IN h_gscddrsxprtf.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

