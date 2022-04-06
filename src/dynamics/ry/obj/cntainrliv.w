&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: cntainrliv.w

  Description:  Container Links Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/06/2002  Author:     

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       cntainrliv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
/*{ry/inc/rycntnerbi.i}*/

DEFINE VARIABLE gcLocatorRequest    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllInstances      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllLinks          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glFromSource        AS LOGICAL    NO-UNDO INITIAL ?. /* TRUE: Show from Source, FALSE: show from Target, ? Show from Link */
DEFINE VARIABLE ghContainerToolbar  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGridObjectViewer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowseToolbar     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFilterViewer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSmartLink         AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buSource buTarget buValidFromLink ~
buValidFromSource buValidFromTarget seSource seTarget seLinks fiSource ~
fiLinks fiTarget imgLink imgSource imgTarget rctLink rctSource rctTarget 
&Scoped-Define DISPLAYED-OBJECTS seSource seTarget fiLinkName seLinks ~
fiSource fiLinks fiTarget 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD determineLists vTableWin 
FUNCTION determineLists RETURNS LOGICAL
  (pcSourceInstanceName AS CHARACTER,
   pcLinkName           AS CHARACTER,
   pcTargetInstanceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getValidLinks vTableWin 
FUNCTION getValidLinks RETURNS CHARACTER
  (pcSourceTarget AS CHARACTER,
   pcInstanceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getValidObjects vTableWin 
FUNCTION getValidObjects RETURNS CHARACTER
  (pcSourceTarget AS CHARACTER,
   pcLinkName     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldSensitivity vTableWin 
FUNCTION setFieldSensitivity RETURNS LOGICAL
  (plSensitive   AS LOGICAL,
   plClearFields AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkNameSensitivity vTableWin 
FUNCTION setLinkNameSensitivity RETURNS LOGICAL
  (pcLinkName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buSource 
     IMAGE-UP FILE "ry/img/objectlocator.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Launch Object Locator to find source"
     BGCOLOR 8 .

DEFINE BUTTON buTarget 
     IMAGE-UP FILE "ry/img/objectlocator.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Launch Object Locator to find target"
     BGCOLOR 8 .

DEFINE BUTTON buValidFromLink  NO-FOCUS FLAT-BUTTON
     LABEL "Filter from link" 
     SIZE 22 BY 1.14 TOOLTIP "Show applicable source and target objects based on link"
     BGCOLOR 8 .

DEFINE BUTTON buValidFromSource  NO-FOCUS FLAT-BUTTON
     LABEL "Filter from source" 
     SIZE 20.8 BY 1.14 TOOLTIP "Show applicable links and target objects from source"
     BGCOLOR 8 .

DEFINE BUTTON buValidFromTarget  NO-FOCUS FLAT-BUTTON
     LABEL "Filter from target" 
     SIZE 20.8 BY 1.14 TOOLTIP "Show applicable links and source objects from target"
     BGCOLOR 8 .

DEFINE VARIABLE fiLinkName AS CHARACTER FORMAT "X(28)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 TOOLTIP "If enabled, specify a name for the user-defined link" NO-UNDO.

DEFINE VARIABLE fiLinks AS CHARACTER FORMAT "X(256)":U INITIAL "Link:" 
      VIEW-AS TEXT 
     SIZE 27.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiSource AS CHARACTER FORMAT "X(256)":U INITIAL "Source:" 
      VIEW-AS TEXT 
     SIZE 31.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiTarget AS CHARACTER FORMAT "X(256)":U INITIAL "Target:" 
      VIEW-AS TEXT 
     SIZE 31.8 BY .62 NO-UNDO.

DEFINE IMAGE imgLink
     FILENAME "ry/img/redtick.bmp":U CONVERT-3D-COLORS
     SIZE 4 BY .95.

DEFINE IMAGE imgSource CONVERT-3D-COLORS
     SIZE 4 BY .95.

DEFINE IMAGE imgTarget CONVERT-3D-COLORS
     SIZE 4 BY .95.

DEFINE RECTANGLE rctLink
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 1.33.

DEFINE RECTANGLE rctLinkDetails
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106.6 BY 11.05.

DEFINE RECTANGLE rctSeperator1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSource
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.4 BY 1.33.

DEFINE RECTANGLE rctTarget
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.4 BY 1.33.

DEFINE VARIABLE seLinks AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 28 BY 7.05
     FONT 3 NO-UNDO.

DEFINE VARIABLE seSource AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 32.4 BY 8.29 TOOLTIP "Select source - if empty then there is no applicable objects" NO-UNDO.

DEFINE VARIABLE seTarget AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 32.4 BY 8.29 TOOLTIP "Select target - if empty then there is no applicable objects" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buSource AT ROW 10.81 COL 3
     buTarget AT ROW 10.81 COL 74
     buValidFromLink AT ROW 10.81 COL 40.6
     buValidFromSource AT ROW 10.81 COL 8.2
     buValidFromTarget AT ROW 10.81 COL 79.4
     seSource AT ROW 2.43 COL 2.4 NO-LABEL
     seTarget AT ROW 2.43 COL 73.6 NO-LABEL
     fiLinkName AT ROW 2.52 COL 38.2 COLON-ALIGNED NO-LABEL
     seLinks AT ROW 3.67 COL 40.2 NO-LABEL
     fiSource AT ROW 1.76 COL 1.2 COLON-ALIGNED NO-LABEL
     fiLinks AT ROW 1.76 COL 39 COLON-ALIGNED NO-LABEL
     fiTarget AT ROW 1.76 COL 72.4 COLON-ALIGNED NO-LABEL
     rctLinkDetails AT ROW 1.29 COL 1
     rctSeperator4 AT ROW 10.81 COL 78.6
     rctSeperator1 AT ROW 10.81 COL 7.6
     rctSeperator3 AT ROW 10.81 COL 62.8
     rctSeperator2 AT ROW 10.81 COL 29.4
     rctSeperator5 AT ROW 10.81 COL 100.6
     imgLink AT ROW 10.95 COL 63.6
     imgSource AT ROW 10.95 COL 30.2
     imgTarget AT ROW 10.95 COL 101.2
     rctLink AT ROW 10.71 COL 40.2
     rctSource AT ROW 10.71 COL 2.4
     rctTarget AT ROW 10.71 COL 73.6
     " Link details" VIEW-AS TEXT
          SIZE 12.6 BY .62 AT ROW 1 COL 2.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 11.33
         WIDTH              = 106.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiLinkName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctLinkDetails IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator3 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator4 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator5 IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSource vTableWin
ON CHOOSE OF buSource IN FRAME frMain
DO:
  gcLocatorRequest = "SOURCE":U.
  
  RUN launchLocator IN ghParentContainer (INPUT ghContainerSource, THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTarget vTableWin
ON CHOOSE OF buTarget IN FRAME frMain
DO:
  gcLocatorRequest = "TARGET":U.
  
  RUN launchLocator IN ghParentContainer (INPUT ghContainerSource, THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buValidFromLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buValidFromLink vTableWin
ON CHOOSE OF buValidFromLink IN FRAME frMain /* Filter from link */
DO:
  ASSIGN
      seSource
      seTarget
      seLinks

      glFromSource = ?.

  imgSource:LOAD-IMAGE("":U).
  imgTarget:LOAD-IMAGE("":U).
  imgLink:LOAD-IMAGE("ry/img/redtick.bmp":U).

  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).
/*
  DEFINE VARIABLE cLinks  AS CHARACTER  NO-UNDO.

  ASSIGN
      seLinks

      cLinks             = seLinks:SCREEN-VALUE
      seLinks:LIST-ITEMS = DYNAMIC-FUNCTION("getValidLinks":U, "SOURCE":U)
      toLinks:SENSITIVE  = TRUE
      toLinks:CHECKED    = FALSE.

  IF LOOKUP(cLinks, seLinks:LIST-ITEMS, seLinks:DELIMITER) <> 0 THEN
  DO:
    seLinks:SCREEN-VALUE = cLinks.

    DYNAMIC-FUNCTION("evaluateLink":U, FALSE, TRUE).
  END.
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buValidFromSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buValidFromSource vTableWin
ON CHOOSE OF buValidFromSource IN FRAME frMain /* Filter from source */
DO:
  ASSIGN
      seSource
      seTarget
      seLinks

      glFromSource = TRUE.

  imgSource:LOAD-IMAGE("ry/img/redtick.bmp":U).
  imgTarget:LOAD-IMAGE("":U).
  imgLink:LOAD-IMAGE("":U).

  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).
  
/*
  DEFINE VARIABLE cLinks  AS CHARACTER  NO-UNDO.

  ASSIGN
      seLinks

      cLinks             = seLinks:SCREEN-VALUE
      seLinks:LIST-ITEMS = DYNAMIC-FUNCTION("getValidLinks":U, "SOURCE":U)
      toLinks:SENSITIVE  = TRUE
      toLinks:CHECKED    = FALSE.

  IF LOOKUP(cLinks, seLinks:LIST-ITEMS, seLinks:DELIMITER) <> 0 THEN
  DO:
    seLinks:SCREEN-VALUE = cLinks.

    DYNAMIC-FUNCTION("evaluateLink":U, FALSE, TRUE).
  END.
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buValidFromTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buValidFromTarget vTableWin
ON CHOOSE OF buValidFromTarget IN FRAME frMain /* Filter from target */
DO:
  ASSIGN
      seSource
      seTarget
      seLinks

      glFromSource = FALSE.

  imgSource:LOAD-IMAGE("":U).
  imgTarget:LOAD-IMAGE("ry/img/redtick.bmp":U).
  imgLink:LOAD-IMAGE("":U).

  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).
/*  
  DEFINE VARIABLE cLinks  AS CHARACTER  NO-UNDO.

  ASSIGN
      seLinks

      cLinks             = seLinks:SCREEN-VALUE
      seLinks:LIST-ITEMS = DYNAMIC-FUNCTION("getValidLinks":U, "TARGET":U)
      toLinks:SENSITIVE  = TRUE
      toLinks:CHECKED    = FALSE.

  IF LOOKUP(cLinks, seLinks:LIST-ITEMS, seLinks:DELIMITER) <> 0 THEN
  DO:
    seLinks:SCREEN-VALUE = cLinks.

    DYNAMIC-FUNCTION("evaluateLink":U, TRUE, FALSE).
  END.
*/  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLinkName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLinkName vTableWin
ON VALUE-CHANGED OF fiLinkName IN FRAME frMain
DO:
  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
    
    DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seLinks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seLinks vTableWin
ON VALUE-CHANGED OF seLinks IN FRAME frMain
DO:
  ASSIGN
      seSource
      seTarget
      seLinks

      fiLinkName:SCREEN-VALUE = seLinks:SCREEN-VALUE.

  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).

    DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
  END.

  DYNAMIC-FUNCTION("setLinkNameSensitivity":U, seLinks:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSource vTableWin
ON VALUE-CHANGED OF seSource IN FRAME frMain
DO:
  ASSIGN
      seSource
      seTarget
      seLinks.
  
  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
  
    DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seTarget vTableWin
ON VALUE-CHANGED OF seTarget IN FRAME frMain
DO:
  ASSIGN
      seSource
      seTarget
      seLinks.
  
  DYNAMIC-FUNCTION("determineLists":U, seSource:SCREEN-VALUE, seLinks:SCREEN-VALUE, seTarget:SCREEN-VALUE).

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
    
    DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerTypeChange vTableWin 
PROCEDURE containerTypeChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDataContainer  AS LOGICAL    NO-UNDO.

  {fnarg determineLists "'?', '?', '?'"}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghSmartLink) THEN
    DELETE OBJECT ghSmartLink.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        seSource:DELIMITER = CHR(3)
        seTarget:DELIMITER = CHR(3)
        seLinks:DELIMITER  = CHR(3).
  END.
  
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.
  
  ASSIGN
      ghGridObjectViewer = DYNAMIC-FUNCTION("linkHandles":U IN ghParentContainer, "gridv-Source":U)
      ghContainerToolbar = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "TopToolbar-Source":U)
      ghBrowseToolbar    = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "BottomToolbar-Source":U)
      ghFilterViewer     = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "FilterViewer-Source":U)
      ghSmartLink        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLink":U)).
  
  CREATE BUFFER ghSmartLink FOR TABLE ghSmartLink.

  SUBSCRIBE TO "containerTypeChange":U  IN ghParentContainer.
  SUBSCRIBE TO "objectLocated":U        IN THIS-PROCEDURE.
  SUBSCRIBE TO "rowSelected":U          IN ghFilterViewer.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectLocated vTableWin 
PROCEDURE objectLocated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cInstanceName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lValidInstance    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.

  httObjectInstance = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance':U ghParentContainer}).

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(pdObjectInstanceObj)).

  ASSIGN
      cInstanceName  = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
      lValidInstance = TRUE.

  DO WITH FRAME {&FRAME-NAME}:

    CASE gcLocatorRequest:
      WHEN "SOURCE":U THEN
      DO:
        IF LOOKUP(cInstanceName, seSource:LIST-ITEMS, seSource:DELIMITER) <> 0 AND
           LOOKUP(cInstanceName, seSource:LIST-ITEMS, seSource:DELIMITER) <> ? THEN
        DO:
          seSource:SCREEN-VALUE = cInstanceName.
          APPLY "VALUE-CHANGED":U TO seSource.
        END.
        ELSE
          lValidInstance = FALSE.
      END.

      WHEN "TARGET":U THEN
      DO:
        IF LOOKUP(cInstanceName, seTarget:LIST-ITEMS, seTarget:DELIMITER) <> 0 AND
           LOOKUP(cInstanceName, seTarget:LIST-ITEMS, seTarget:DELIMITER) <> ? THEN
        DO:
          seTarget:SCREEN-VALUE = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
          APPLY "VALUE-CHANGED":U TO seTarget.
        END.
        ELSE
          lValidInstance = FALSE.
      END.
    END CASE.
  END.

  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.

  IF NOT lValidInstance THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '133' '?' '?' cInstanceName seLinks:SCREEN-VALUE gcLocatorRequest}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                         /* message to display */
                                           INPUT  "ERR":U,                          /* error type         */
                                           INPUT  "&OK":U,                          /* button list        */
                                           INPUT  "&OK":U,                          /* default button     */ 
                                           INPUT  "&OK":U,                          /* cancel button      */
                                           INPUT  "Instance specified is invalid",  /* error window title */
                                           INPUT  YES,                              /* display if empty   */ 
                                           INPUT  TARGET-PROCEDURE,                 /* container handle   */ 
                                           OUTPUT cButton).                         /* button pressed     */
    RETURN.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData vTableWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  RUN setupMaintenance.
    
  IF pcAction = "Updated" THEN
    RUN trgValueChanged IN ghFilterViewer.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.
  
  HIDE FRAME {&FRAME-NAME}.

  dFrameWidth = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the width of the frame was made smaller */
  IF pdWidth < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdWidth > dFrameWidth THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

    lResizedObjects = TRUE.

    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.

  FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  
  VIEW FRAME {&FRAME-NAME}.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dAvailableWidth AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dObjectWidth    AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dClearance      AS DECIMAL  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        rctLinkDetails:WIDTH-CHARS = pdWidth
        dAvailableWidth            = pdWidth - 3.00
        dClearance                 = 4.50
        dObjectWidth               = (dAvailableWidth - 2 * dClearance) / 3
        fiLinkName:WIDTH-CHARS     = dObjectWidth
        rctSource:WIDTH-CHARS      = dObjectWidth
        rctTarget:WIDTH-CHARS      = dObjectWidth
        seSource:WIDTH-CHARS       = dObjectWidth
        fiSource:WIDTH-CHARS       = dObjectWidth
        seTarget:WIDTH-CHARS       = dObjectWidth
        fiTarget:WIDTH-CHARS       = dObjectWidth
        seLinks:WIDTH-CHARS        = dObjectWidth
        fiLinks:WIDTH-CHARS        = dObjectWidth
        rctLink:WIDTH-CHARS        = dObjectWidth
        rctSource:COLUMN           = seSource:COLUMN
        seTarget:COLUMN            = pdWidth - seTarget:WIDTH-CHARS - 0.50
        rctTarget:COLUMN           = seTarget:COLUMN
        fiTarget:COLUMN            = seTarget:COLUMN
        seLinks:COLUMN             = seSource:COLUMN + seSource:WIDTH-CHARS + dClearance
        rctLink:COLUMN             = seLinks:COLUMN
        fiLinks:COLUMN             = seLinks:COLUMN
        fiLinkName:COLUMN          = seLinks:COLUMN
        
        buSource:X                 = seSource:X + 2
        buTarget:X                 = seTarget:X + 2

        /* Valid from Source 'toolbar' */
        buValidFromSource:WIDTH-CHARS = dObjectWidth        - buSource:WIDTH-CHARS            - 6.00
        buValidFromSource:X           = buSource:X          + buSource:WIDTH-PIXELS           + 2
        rctSeperator2:X               = buValidFromSource:X + buValidFromSource:WIDTH-PIXELS
        imgSource:X                   = rctSeperator2:X     + 3

        /* Valid from Source 'toolbar' */
        buValidFromLink:WIDTH-CHARS   = dObjectWidth        - 5.75
        buValidFromLink:COLUMN        = seLinks:COLUMN      + 0.35
        rctSeperator3:X               = buValidFromLink:X   + buValidFromLink:WIDTH-PIXELS
        imgLink:X                     = rctSeperator3:X     + 3

        /* Valid from Target 'toolbar' */
        buValidFromTarget:WIDTH-CHARS = dObjectWidth        - buTarget:WIDTH-CHARS            - 6.00
        buValidFromTarget:X           = buTarget:X          + buTarget:WIDTH-PIXELS           + 2
        rctSeperator4:X               = buTarget:X          + buTarget:WIDTH-PIXELS
        rctSeperator5:X               = buValidFromTarget:X + buValidFromTarget:WIDTH-PIXELS
        imgTarget:X                   = rctSeperator5:X     + 3
        .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowSelected vTableWin 
PROCEDURE rowSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdSmartLinkObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cSourceInstanceName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetInstanceName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLinkType        AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        httSmartLinkType        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLinkType":U))
        cContainerMode          = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

    IF cContainerMode = "UPDATE":U OR
       cContainerMode = "ADD":U    THEN.
    ELSE
    DO:
      DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, TRUE).

      IF pdSmartLinkObj <> ? AND
         pdSmartLinkObj <> 0 THEN
      DO:
        ghSmartLink:FIND-FIRST("WHERE d_smartlink_obj = ":U + QUOTER(pdSmartLinkObj)).

        IF ghSmartLink:AVAILABLE THEN
        DO:
          CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
          CREATE BUFFER httSmartLinkType  FOR TABLE httSmartLinkType.

          httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ghSmartLink:BUFFER-FIELD("d_source_object_instance_obj":U):BUFFER-VALUE)).
          httSmartLinkType:FIND-FIRST(" WHERE d_smartlink_type_obj = ":U  + QUOTER(ghSmartLink:BUFFER-FIELD("d_smartlink_type_obj":U):BUFFER-VALUE)).

          cSourceInstanceName = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

          httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ghSmartLink:BUFFER-FIELD("d_target_object_instance_obj":U):BUFFER-VALUE)).

          ASSIGN
              buValidFromSource:SENSITIVE = TRUE
              buValidFromTarget:SENSITIVE = TRUE
              cLinkName                   = httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE
              cTargetInstanceName         = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

          DYNAMIC-FUNCTION("determineLists":U, cSourceInstanceName, cLinkName, cTargetInstanceName).
          DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, FALSE).

          DELETE OBJECT httObjectInstance.
          httObjectInstance = ?.
          
          fiLinkName:SCREEN-VALUE = ghSmartLink:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE.
        END.
      END.
      ELSE
        DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, TRUE).

      DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
    END.
  END.

  IF ghSmartLink:AVAILABLE = TRUE AND dCustomizationResultObj <> ghSmartLink:BUFFER-FIELD("d_customization_result_obj"):BUFFER-VALUE THEN
     DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbModify,cbDelete":U).

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupMaintenance vTableWin 
PROCEDURE setupMaintenance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN    
      gcAllInstances = {fn getListItemPairs ghFilterViewer}
      gcAllLinks     = {fn getLinkNames     ghFilterViewer}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbarOverride vTableWin 
PROCEDURE toolbarOverride :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cContainerMode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSourceObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTargetObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartLinkTypeObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSmartLinkObj             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httSmartLinkType          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLink              AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httSmartLinkType        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLinkType":U))
        httSmartObject          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U)).

    CASE pcAction:
      WHEN "New":U THEN
      DO:
        DYNAMIC-FUNCTION("setFieldSensitivity":U, TRUE, FALSE /* TRUE */).
        DYNAMIC-FUNCTION("setUserProperty":U  IN ghContainerSource, "ContainerMode":U, "ADD":U).
        DYNAMIC-FUNCTION("evaluateActions":U  IN ghContainerSource).
        
        DYNAMIC-FUNCTION("setLinkNameSensitivity":U, seLinks:SCREEN-VALUE).

        DYNAMIC-FUNCTION("disableActions":U       IN ghBrowseToolbar, "cbModify":U).
        DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
      END.
      
      WHEN "Cancel":U OR WHEN "Undo":U THEN
      DO:
        DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, TRUE).
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).

        IF ghSmartLink:AVAILABLE THEN
          dSmartLinkObj = ghSmartLink:BUFFER-FIELD("d_smartlink_obj":U):BUFFER-VALUE.
        ELSE
          dSmartLinkObj = 0.00.

        RUN rowSelected (dSmartLinkObj).

        DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, TRUE).
      END.

      WHEN "Modify":U THEN
      DO:
        DYNAMIC-FUNCTION("setLinkNameSensitivity":U, ghSmartLink:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE).
        DYNAMIC-FUNCTION("setFieldSensitivity":U, TRUE, FALSE).
        DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, TRUE).
        DYNAMIC-FUNCTION("disableActions":U       IN ghBrowseToolbar, "cbModify":U).
      END.
      
      WHEN "Delete":U THEN
      DO:
        ghSmartLink:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U.
        {fnarg setUserProperty "'SameContainer', 'yes'" ghFilterViewer}.

        PUBLISH "refreshData":U FROM ghParentContainer (INPUT "NewData":U, INPUT 0.00).
        
        IF LOOKUP(ghSmartLink:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE, "Data,GroupAssign,Navigation,Update":U) <> 0 THEN
          RUN evaluateSBOProperties IN ghGridObjectViewer (INPUT TRUE).

        {fnarg setUserProperty "'SameContainer', 'no'" ghFilterViewer}.

        IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "UPDATE":U AND
           DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "ADD":U    THEN
        DO:
          DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
          DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
        END.
      END.
      
      WHEN "NoData":U THEN
      DO:
        DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, TRUE).
        DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, FALSE).
        DYNAMIC-FUNCTION("determineLists":U, "":U, "":U, "":U).
      END.

      WHEN "Save":U THEN
      DO:
        cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

        ASSIGN
            fiLinkName
            seSource
            seTarget
            seLinks.

        IF fiLinkName:SCREEN-VALUE = "":U OR
           fiLinkName:SCREEN-VALUE = ?    OR
           seSource:SCREEN-VALUE   = "":U OR
           seSource:SCREEN-VALUE   = ?    OR
           seTarget:SCREEN-VALUE   = "":U OR
           seTarget:SCREEN-VALUE   = ?    OR
           seLinks:SCREEN-VALUE    = "":U OR
           seLinks:SCREEN-VALUE    = ?    THEN
          RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"Please specify a source object, target object and link type. If it is a user defined link, please ensure the link name is specified."'}.

        IF seSource:SCREEN-VALUE = seTarget:SCREEN-VALUE THEN
          RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"The source and target objects should not be the same."'}.

        /* See if one already exists flagged as deleted - if so, change flag... */
        IF cContainerMode = "ADD":U THEN
        DO:
          ASSIGN
              dSourceObjectInstanceObj = DYNAMIC-FUNCTION("getObjectInstanceObj":U IN ghParentContainer, seSource:SCREEN-VALUE)
              dTargetObjectInstanceObj = DYNAMIC-FUNCTION("getObjectInstanceObj":U IN ghParentContainer, seTarget:SCREEN-VALUE).

          CREATE BUFFER httSmartLink FOR TABLE ghSmartLink.
          
          httSmartLink:FIND-FIRST("WHERE d_source_object_instance_obj = ":U + QUOTER(dSourceObjectInstanceObj)
                                 + " AND d_target_object_instance_obj = ":U + QUOTER(dTargetObjectInstanceObj)
                                 + " AND c_link_name                  = ":U + QUOTER(fiLinkName:SCREEN-VALUE)
                                 + " AND c_action                    <> 'D'":U) NO-ERROR.

          IF httSmartLink:AVAILABLE THEN
          DO:
            RETURN ERROR {aferrortxt.i 'AF' '8' '?' '?' 'the' '"specified details"'}.
          END.
          ELSE
          DO:
            ghSmartLink:BUFFER-CREATE().

            ASSIGN
                ghSmartLink:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE = dCustomizationResultObj
                ghSmartLink:BUFFER-FIELD("d_smartlink_obj":U):BUFFER-VALUE            = DYNAMIC-FUNCTION("getTemporaryObj":U IN ghParentContainer)
                ghSmartLink:BUFFER-FIELD("c_action":U):BUFFER-VALUE                   = "A":U.
          END.

          DELETE OBJECT httSmartLink.
          httSmartLink = ?.
        END.

        httSmartLinkType:FIND-FIRST("WHERE c_link_name = ":U + QUOTER(seLinks:SCREEN-VALUE)).

        httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 ":U
                                  + "AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

        ASSIGN
            ghSmartLink:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE  = httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
            ghSmartLink:BUFFER-FIELD("d_source_object_instance_obj":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getObjectInstanceObj":U IN ghParentContainer, seSource:SCREEN-VALUE)
            ghSmartLink:BUFFER-FIELD("d_target_object_instance_obj":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getObjectInstanceObj":U IN ghParentContainer, seTarget:SCREEN-VALUE)
            ghSmartLink:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE                  = fiLinkName:SCREEN-VALUE
            ghSmartLink:BUFFER-FIELD("d_smartlink_type_obj":U):BUFFER-VALUE         = httSmartLinkType:BUFFER-FIELD("d_smartlink_type_obj":U):BUFFER-VALUE.
        
        
        IF ghSmartLink:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
          ghSmartLink:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).

        {fnarg setUserProperty "'SameContainer', 'yes'" ghFilterViewer}.

        PUBLISH "refreshData":U FROM ghParentContainer (INPUT "NewData":U,
                                                        INPUT ghSmartLink:BUFFER-FIELD("d_smartlink_obj":U):BUFFER-VALUE).

        IF LOOKUP(ghSmartLink:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE, "Data,GroupAssign,Navigation,Update":U) <> 0 THEN
          RUN evaluateSBOProperties IN ghGridObjectViewer (INPUT TRUE).

        {fnarg setUserProperty "'SameContainer', 'no'" ghFilterViewer}.

        IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "UPDATE":U AND
           DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "ADD":U    THEN
        DO:
          DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
          DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
        END.

        DYNAMIC-FUNCTION("setBrowseSensitivity":U IN ghFilterViewer, TRUE).
      END.
    END CASE.
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION determineLists vTableWin 
FUNCTION determineLists RETURNS LOGICAL
  (pcSourceInstanceName AS CHARACTER,
   pcLinkName           AS CHARACTER,
   pcTargetInstanceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItems  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinksList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkName   AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF pcSourceInstanceName = ? THEN pcSourceInstanceName = "":U.
    IF pcTargetInstanceName = ? THEN pcTargetInstanceName = "":U.
    IF pcLinkName           = ? THEN pcLinkName           = "":U.

    cLinkName = pcLinkName.

    CASE glFromSource:
      /* ---------- SOURCE ---------- */
      WHEN TRUE THEN
      DO:
        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seSource:LIST-ITEMS <> gcAllInstances THEN
          seSource:LIST-ITEMS = gcAllInstances.

        IF NOT LOOKUP(pcSourceInstanceName, seSource:LIST-ITEMS, seSource:DELIMITER) > 0 THEN
          ASSIGN
              pcSourceInstanceName = ENTRY(1, seSource:LIST-ITEMS, seSource:DELIMITER).

        cListItems = DYNAMIC-FUNCTION("getValidLinks":U, "SOURCE":U, pcSourceInstanceName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seLinks:LIST-ITEMS <> cListItems THEN
          seLinks:LIST-ITEMS = cListItems.

        IF NOT LOOKUP(pcLinkName, seLinks:LIST-ITEMS, seLinks:DELIMITER) > 0 THEN
          ASSIGN
              pcLinkName = ENTRY(1, seLinks:LIST-ITEMS, seLinks:DELIMITER).

        cListItems = DYNAMIC-FUNCTION("getValidObjects":U, "TARGET":U, pcLinkName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seTarget:LIST-ITEMS <> cListItems THEN
          seTarget:LIST-ITEMS = cListItems.
      
        IF NOT LOOKUP(pcTargetInstanceName, seTarget:LIST-ITEMS, seTarget:DELIMITER) > 0 THEN
          ASSIGN
              pcTargetInstanceName = ENTRY(1, seTarget:LIST-ITEMS, seTarget:DELIMITER).
      END.
      
      /* ----------- LINK ----------- */
      WHEN ? THEN
      DO:
        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF ({fnarg getUserProperty 'DataContainer' ghParentContainer} = "yes":U) THEN
          cLinksList = "Data":U /*+ seLinks:DELIMITER + {fn getUserDefinedLinks ghFilterViewer}*/.
        ELSE
          cLinksList = gcAllLinks.

        IF seLinks:LIST-ITEMS <> cLinksList THEN
          seLinks:LIST-ITEMS = cLinksList.

        IF NOT LOOKUP(pcLinkName, seLinks:LIST-ITEMS, seLinks:DELIMITER) > 0 THEN
          ASSIGN
              pcLinkName = ENTRY(1, seLinks:LIST-ITEMS, seLinks:DELIMITER).

        cListItems = DYNAMIC-FUNCTION("getValidObjects":U, "SOURCE":U, pcLinkName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seSource:LIST-ITEMS <> cListItems THEN
          seSource:LIST-ITEMS = cListItems.

        cListItems = DYNAMIC-FUNCTION("getValidObjects":U, "TARGET":U, pcLinkName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seTarget:LIST-ITEMS <> cListItems THEN
          seTarget:LIST-ITEMS = cListItems.
      END.

       /* ---------- TARGET ---------- */
      WHEN FALSE THEN
      DO:
        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seTarget:LIST-ITEMS <> gcAllInstances THEN
          seTarget:LIST-ITEMS = gcAllInstances.

        IF NOT LOOKUP(pcTargetInstanceName, seTarget:LIST-ITEMS, seTarget:DELIMITER) > 0 THEN
          ASSIGN
              pcTargetInstanceName = ENTRY(1, seTarget:LIST-ITEMS, seTarget:DELIMITER).

        cListItems = DYNAMIC-FUNCTION("getValidLinks":U, "TARGET":U, pcTargetInstanceName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seLinks:LIST-ITEMS <> cListItems THEN
          seLinks:LIST-ITEMS = cListItems.

        IF NOT LOOKUP(pcLinkName, seLinks:LIST-ITEMS, seLinks:DELIMITER) > 0 THEN
          ASSIGN
              pcLinkName = ENTRY(1, seLinks:LIST-ITEMS, seLinks:DELIMITER).

        cListItems = DYNAMIC-FUNCTION("getValidObjects":U, "SOURCE":U, pcLinkName).

        /* If the LIST-ITEMS is not the same, set it to the retrieved list (Undoting it causes it to flicker) */
        IF seSource:LIST-ITEMS <> cListItems THEN
          seSource:LIST-ITEMS = cListItems.
      
        IF NOT LOOKUP(pcSourceInstanceName, seSource:LIST-ITEMS, seSource:DELIMITER) > 0 THEN
          ASSIGN
              pcSourceInstanceName = ENTRY(1, seSource:LIST-ITEMS, seSource:DELIMITER).
      END.
    END CASE.

    IF LOOKUP(pcSourceInstanceName, seSource:LIST-ITEMS, seSource:DELIMITER) > 0 THEN
      seSource:SCREEN-VALUE = pcSourceInstanceName.

    IF LOOKUP(pcLinkName, seLinks:LIST-ITEMS, seLinks:DELIMITER) > 0 THEN
      seLinks:SCREEN-VALUE = pcLinkName.

    fiLinkName:SCREEN-VALUE = seLinks:SCREEN-VALUE.

    IF LOOKUP(pcTargetInstanceName, seTarget:LIST-ITEMS, seTarget:DELIMITER) > 0 THEN
      seTarget:SCREEN-VALUE = pcTargetInstanceName.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getValidLinks vTableWin 
FUNCTION getValidLinks RETURNS CHARACTER
  (pcSourceTarget AS CHARACTER,
   pcInstanceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUserDefinedLinks   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValidLinks         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lDataContainer      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLinkType    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSupportedLink    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery              AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        seSource
        seTarget

        httObjectInstance  = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance' ghParentContainer})
        httSupportedLink   = WIDGET-HANDLE({fnarg getUserProperty 'ttSupportedLink'  ghParentContainer})
        httSmartLinkType   = WIDGET-HANDLE({fnarg getUserProperty 'ttSmartLinkType'  ghParentContainer})

        dObjectInstanceObj = {fnarg getObjectInstanceObj pcInstanceName  ghParentContainer}
        lDataContainer     = {fnarg getUserProperty      'DataContainer' ghParentContainer} = "yes":U
        cUserDefinedLinks  = {fn    getUserDefinedLinks  ghFilterViewer}
        .

    IF NOT lDataContainer THEN
    DO:
      CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
      CREATE QUERY  hQuery.

      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(dObjectInstanceObj)).

      cQueryString = "FOR EACH ttSupportedLink":U
                   + "   WHERE ttSupportedLink.d_object_type_obj = ":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)
                   + "     AND ttSupportedLink.l_link_":U + pcSourceTarget + " = TRUE,":U
                   + "   FIRST ttSmartLinkType":U
                   + "   WHERE ttSmartLinkType.d_smartlink_type_obj = ttSupportedLink.d_smartlink_type_obj":U
                   + "      BY ttSmartLinkType.c_link_name":U.

      hQuery:SET-BUFFERS(httSupportedLink, httSmartLinkType).
      hQuery:QUERY-PREPARE(cQueryString).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().

      DO WHILE NOT hQuery:QUERY-OFF-END:
        cValidLinks = cValidLinks + (IF cValidLinks = "":U THEN "":U ELSE CHR(3))
                    + httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE.

        hQuery:GET-NEXT().
      END.

      DELETE OBJECT httObjectInstance.
      DELETE OBJECT hQuery.

      ASSIGN
          httObjectInstance = ?
          hQuery            = ?.
    END.
    ELSE
      cValidLinks = "Data":U.

    IF cUserDefinedLinks <> "":U AND NOT lDataContainer THEN
      cValidLinks = cValidLinks + (IF cValidLinks = "":U THEN "":U ELSE CHR(3))
                  + cUserDefinedLinks.
  END.

  RETURN cValidLinks.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getValidObjects vTableWin 
FUNCTION getValidObjects RETURNS CHARACTER
  (pcSourceTarget AS CHARACTER,
   pcLinkName     AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValidObjects           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLinkType        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSupportedLink        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        httSupportedLink        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSupportedLink":U))
        httSmartLinkType        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLinkType":U)).

    httSmartLinkType:FIND-FIRST("WHERE c_link_name = ":U + QUOTER(pcLinkName)) NO-ERROR.

    IF httSmartLinkType:AVAILABLE THEN
    DO:
      IF httSmartLinkType:BUFFER-FIELD("l_user_defined_link":U):BUFFER-VALUE THEN
        ASSIGN
            cValidObjects = gcAllInstances.
      ELSE
      DO:
        CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
        CREATE QUERY  hQuery.
    
        cQueryString = "FOR EACH ttSupportedLink":U
                     + "   WHERE ttSupportedLink.d_smartlink_type_obj = ":U + QUOTER(httSmartLinkType:BUFFER-FIELD("d_smartlink_type_obj":U):BUFFER-VALUE)
                     + "     AND ttSupportedLink.l_link_":U + pcSourceTarget + " = TRUE,":U 
                     + "    EACH ttObjectInstance":U
                     + "   WHERE ttObjectInstance.d_object_type_obj = ttSupportedLink.d_object_type_obj":U
                     + "     AND ttObjectInstance.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                     + "     AND ttObjectInstance.c_action         <> 'D'":U
                     + "      BY ttObjectInstance.c_instance_name":U.
    
        hQuery:SET-BUFFERS(httSupportedLink, httObjectInstance).
        hQuery:QUERY-PREPARE(cQueryString).
        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST().
    
        DO WHILE NOT hQuery:QUERY-OFF-END:
          cValidObjects = cValidObjects + (IF cValidObjects = "":U THEN "":U ELSE CHR(3))
                        + httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
    
          hQuery:GET-NEXT().
        END.
    
        DELETE OBJECT httObjectInstance.
        DELETE OBJECT hQuery.
    
        ASSIGN
            httObjectInstance = ?
            hQuery            = ?.
      END.
    END.
    ELSE
      cValidObjects = "":U.
  END.

  RETURN cValidObjects.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldSensitivity vTableWin 
FUNCTION setFieldSensitivity RETURNS LOGICAL
  (plSensitive   AS LOGICAL,
   plClearFields AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFirstEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombo      AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF plSensitive = TRUE THEN
      ASSIGN
          seSource:SENSITIVE          = TRUE
          seTarget:SENSITIVE          = TRUE
          seLinks:SENSITIVE           = TRUE
          buSource:SENSITIVE          = TRUE
          buTarget:SENSITIVE          = TRUE
          buValidFromSource:SENSITIVE = TRUE
          buValidFromTarget:SENSITIVE = TRUE
          buValidFromLink:SENSITIVE   = TRUE.
    ELSE
      ASSIGN
          fiLinkname:SENSITIVE        = FALSE
          seSource:SENSITIVE          = FALSE
          seTarget:SENSITIVE          = FALSE
          seLinks:SENSITIVE           = FALSE
          buSource:SENSITIVE          = FALSE
          buTarget:SENSITIVE          = FALSE
          buValidFromSource:SENSITIVE = {fn getHasData ghFilterViewer}
          buValidFromTarget:SENSITIVE = buValidFromSource:SENSITIVE
          buValidFromLink:SENSITIVE   = buValidFromSource:SENSITIVE.
  
    IF plClearFields = TRUE                             AND 
       INDEX(seSource:LIST-ITEMS, "THIS-OBJECT":U) <> 0 THEN
    DO:
      ASSIGN
          fiLinkName:SCREEN-VALUE = "":U
/*          seSource:SCREEN-VALUE   = "THIS-OBJECT":U
          seTarget:SCREEN-VALUE   = "THIS-OBJECT":U*/
          /*cFirstEntry             = TRIM(ENTRY(2, hCombo:LIST-ITEMS, hCombo:DELIMITER))
          hCombo:SCREEN-VALUE     = cFirstEntry*/ .

      /*{set DataValue cFirstEntry hLink}.*/
      /*
      APPLY "VALUE-CHANGED":U TO hCombo.*/
    END.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkNameSensitivity vTableWin 
FUNCTION setLinkNameSensitivity RETURNS LOGICAL
  (pcLinkName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE httSmartLinkType  AS HANDLE     NO-UNDO.

  httSmartLinkType = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLinkType":U)).

  CREATE BUFFER httSmartLinkType FOR TABLE httSmartLinkType.

  httSmartLinkType:FIND-FIRST("WHERE c_link_name = ":U + QUOTER(pcLinkName)) NO-ERROR.

  DO WITH FRAME {&FRAME-NAME}:
    IF httSmartLinkType:AVAILABLE THEN
    DO:
      cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
      
      IF httSmartLinkType:BUFFER-FIELD("l_user_defined_link":U):BUFFER-VALUE = TRUE AND
         DYNAMIC-FUNCTION("getHasData":U IN ghFilterViewer)                  = TRUE THEN
        ASSIGN
            fiLinkName:SENSITIVE = TRUE.
      ELSE
        ASSIGN
            fiLinkName:SENSITIVE = FALSE.
  
      IF cContainerMode = "UPDATE":U OR
         cContainerMode = "ADD":U    THEN
        fiLinkName:SCREEN-VALUE = httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE.
    END.
    ELSE
      ASSIGN
          fiLinkName:SENSITIVE = FALSE.
  END.
  
  DELETE OBJECT httSmartLinkType.
  httSmartLinkType = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

