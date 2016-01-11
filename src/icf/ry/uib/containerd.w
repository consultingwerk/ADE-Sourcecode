&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ afglobals.i }
{ adeuib/uniwidg.i }
{ ry/app/containeri.i }

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pPrecid AS RECID      NO-UNDO.

DEFINE BUFFER local_P FOR _P.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE giCurrentPage           AS INTEGER              NO-UNDO INITIAL 0.
DEFINE VARIABLE glModified              AS LOGICAL              NO-UNDO INITIAL NO.
DEFINE VARIABLE glVisible               AS LOGICAL              NO-UNDO INITIAL YES.
/* used to add to etime to avoid ttpageinstance errors when updates happen within
   a millisecond with the same random number                                     */
DEFINE VARIABLE giCnt                   AS INTEGER              NO-UNDO INITIAL 0.
ASSIGN giCnt = TIME.

DEFINE TEMP-TABLE ttLocalPage               NO-UNDO
    FIELD tPageNumber           AS INTEGER
    FIELD tObjectName           AS CHARACTER
    FIELD tObjectHandle         AS HANDLE
    FIELD tObjectQueryHandle    AS HANDLE
    FIELD tObjectBufferHandle   AS HANDLE
    FIELD tKeyFieldHandle       AS HANDLE
    FIELD tBaseQuery            AS CHARACTER
    FIELD tCurrentSort          AS CHARACTER
    INDEX idxPage
        tPageNumber
    INDEX idxObjectName
        tObjectName
    INDEX idxObjectHandle
        tObjectHandle
    .

/* Used to pass records to the viewers. */
DEFINE TEMP-TABLE ttPassPage        NO-UNDO LIKE ttPage.
DEFINE TEMP-TABLE ttPassInstance    NO-UNDO LIKE ttPageInstance.
DEFINE TEMP-TABLE ttPassLink        NO-UNDO LIKE ttLink.

&SCOPED-DEFINE ICF-FOLDER-OBJECT afspfoldrw.w

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiObjectName buLookupTemplate ~
fiObjectDescription coObjectType fiWindowTitle coProductModule ~
fiDefaultMode fiCustomSuperProc toMakeThisTemplate buOK buHelp RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fiObjectName fiTemplateObjectName ~
fiObjectDescription fiWindowTitle fiDefaultMode fiPhysicalObject ~
fiCustomSuperProc toMakeThisTemplate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CleanupFolderObjects wWin 
FUNCTION CleanupFolderObjects RETURNS LOGICAL
    ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createAllPages wWin 
FUNCTION createAllPages RETURNS LOGICAL
    ( INPUT pdContainerObj      AS DECIMAL,
      INPUT plTemplateRecord    AS LOGICAL  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createInstanceLinks wWin 
FUNCTION createInstanceLinks RETURNS LOGICAL
    ( INPUT pdContainerObj          AS DECIMAL,
      INPUT plTemplateRecord        AS LOGICAL,
      INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT pdObjectId              AS DECIMAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createPageNInstance wWin 
FUNCTION createPageNInstance RETURNS LOGICAL
    ( INPUT pdContainerObj      AS DECIMAL,
      INPUT plTemplateRecord    AS LOGICAL,
      INPUT pdPageObj           AS DECIMAL,
      INPUT piPageSequence      AS INTEGER,
      INPUT pcPageLabel         AS CHARACTER,
      INPUT pcLayoutName        AS CHARACTER,
      INPUT pdPageLocalSequence AS DECIMAL,
      INPUT plIsPageZero        AS LOGICAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValue wWin 
FUNCTION getAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeLabel            AS CHARACTER,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerType wWin 
FUNCTION getContainerType RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceObjects wWin 
FUNCTION getInstanceObjects RETURNS CHARACTER
    ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrecid wWin 
FUNCTION getPrecid RETURNS RECID
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HasFolderObject wWin 
FUNCTION HasFolderObject RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HasPageLink wWin 
FUNCTION HasPageLink RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isModified wWin 
FUNCTION isModified RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery wWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    ( INPUT pcBrowseName        AS CHARACTER,
      INPUT pcSubstituteList    AS CHARACTER   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD selectPage2 wWin 
FUNCTION selectPage2 RETURNS LOGICAL
    ( /**/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD selectPage3 wWin 
FUNCTION selectPage3 RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_containr1v AS HANDLE NO-UNDO.
DEFINE VARIABLE h_containr2v AS HANDLE NO-UNDO.
DEFINE VARIABLE h_containr3v AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buLookupTemplate 
     IMAGE-UP FILE "ry/img/affind.gif":U
     LABEL "" 
     SIZE 4.8 BY 1 TOOLTIP "Choose a container to use as a template for this container."
     BGCOLOR 8 .

DEFINE BUTTON buOK 
     LABEL "&OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiCustomSuperProc AS CHARACTER FORMAT "X(70)":U 
     LABEL "Custom Super Procedure" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiDefaultMode AS CHARACTER FORMAT "X(70)":U 
     LABEL "Default Mode" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(70)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The logical obejct name of the container being updated." NO-UNDO.

DEFINE VARIABLE fiPhysicalObject AS CHARACTER FORMAT "X(70)":U 
     LABEL "Physical Object" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiTemplateObjectName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Container Template" 
     VIEW-AS FILL-IN 
     SIZE 43.4 BY 1 TOOLTIP "This object acts as a template for the entire container." NO-UNDO.

DEFINE VARIABLE fiWindowTitle AS CHARACTER FORMAT "X(70)":U 
     LABEL "Window Title" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 151.2 BY 5.81.

DEFINE VARIABLE toMakeThisTemplate AS LOGICAL INITIAL no 
     LABEL "Template Object?" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.8 BY .81 TOOLTIP "If checked, this container will be able to be used as a container template." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiObjectName AT ROW 1.76 COL 22.2 COLON-ALIGNED
     fiTemplateObjectName AT ROW 1.76 COL 100.6 COLON-ALIGNED
     buLookupTemplate AT ROW 1.76 COL 145.8
     fiObjectDescription AT ROW 2.81 COL 22.2 COLON-ALIGNED
     coObjectType AT ROW 2.81 COL 100.6 COLON-ALIGNED
     fiWindowTitle AT ROW 3.86 COL 22.2 COLON-ALIGNED
     coProductModule AT ROW 3.86 COL 100.6 COLON-ALIGNED
     fiDefaultMode AT ROW 4.91 COL 22.2 COLON-ALIGNED
     fiPhysicalObject AT ROW 4.91 COL 100.6 COLON-ALIGNED
     fiCustomSuperProc AT ROW 5.91 COL 100.6 COLON-ALIGNED
     toMakeThisTemplate AT ROW 6.14 COL 24.2
     buOK AT ROW 25.86 COL 3.4
     buHelp AT ROW 25.86 COL 138.2
     RECT-1 AT ROW 1.43 COL 2.4
     "Container" VIEW-AS TEXT
          SIZE 10.4 BY .62 AT ROW 1.1 COL 5.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 154 BY 26.19.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Property Sheet"
         HEIGHT             = 26.19
         WIDTH              = 153.6
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         SHOW-IN-TASKBAR    = no
         MAX-BUTTON         = no
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
IF NOT wWin:LOAD-ICON("adeicon/icfdev.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/icfdev.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
/* SETTINGS FOR COMBO-BOX coObjectType IN FRAME fMain
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME fMain
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fiPhysicalObject IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTemplateObjectName IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Property Sheet */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Property Sheet */
DO:
    RUN hideObject.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupTemplate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupTemplate wWin
ON CHOOSE OF buLookupTemplate IN FRAME fMain
DO:
    DEFINE VARIABLE cObjectFilename         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectTypeCode         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectTypeWhere        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj          AS DECIMAL                  NO-UNDO.

    ASSIGN cObjectFileName  = fiTemplateObjectName:SCREEN-VALUE
           dObjectTypeObj   = coObjectType:INPUT-VALUE
           cObjectTypeWhere = " gsc_object_type.object_type_code = 'DynObjc':U OR ":U
                            + " gsc_object_type.object_type_code = 'DynFold':U OR ":U
                            + " gsc_object_type.object_type_code = 'DynWind':U OR ":U
                            + " gsc_object_type.object_type_code = 'DynMenc':U     ":U
           .
    RUN ry/uib/containrbd.w ( INPUT        YES,       /* template object? */
                              INPUT        cObjectTypeWhere,
                              INPUT        YES,       /* container object? */
                              INPUT-OUTPUT dObjectTypeObj,
                              INPUT-OUTPUT cObjectFilename,
                              OUTPUT cObjectTypeCode) NO-ERROR.
    IF cObjectFilename NE "":U THEN
    DO:
        ASSIGN fiTemplateObjectName:SCREEN-VALUE = cObjectFilename
               fiObjectName:SENSITIVE            = YES
               .
        RUN getData ( INPUT YES ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN NO-APPLY.

        /* Populate the browses */
        DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brPage":U, INPUT "":U).
        DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brLink":U, INPUT "":U).

        RUN selectPage( INPUT 1).

        APPLY "VALUE-CHANGED":U TO coObjectType.
        /* Force the browse value changed event to populate the viewer. */
        RUN trgValueChanged ( INPUT "brPage":U).

        ASSIGN glModified = YES.
    END.    /* valid filename */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK wWin
ON CHOOSE OF buOK IN FRAME fMain /* OK */
DO:
    RUN hideObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType wWin
ON VALUE-CHANGED OF coObjectType IN FRAME fMain /* Object Type */
DO:
    /* Don't use DYN-FUNC because we need to know the function type. */
    CASE getContainerType():
        WHEN "DynFold":U THEN
            ASSIGN fiDefaultMode:SENSITIVE = YES.
        OTHERWISE
            ASSIGN fiDefaultMode:SCREEN-VALUE = ?
                   fiDefaultMode:SENSITIVE    = NO
                   .
    END CASE.   /* object type */

    ASSIGN fiDefaultMode:VISIBLE = fiDefaultMode:SENSITIVE
           glModified            = YES
           .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription wWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME fMain /* Description */
, fiObjectName, fiObjectDescription, fiWindowTitle, fiDefaultMode, coProductModule, fiCustomSuperProc
DO:
    ASSIGN glModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */
FIND local_P WHERE RECID(local_P) = pPrecid NO-ERROR.

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + '&Pages|Page &Instances|&Links' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 7.48 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 18.19 , 150.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/containr1v.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_containr1v ).
       RUN repositionObject IN h_containr1v ( 19.76 , 5.00 ) NO-ERROR.
       /* Size in AB:  ( 4.57 , 146.20 ) */

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/containr2v.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_containr2v ).
       RUN repositionObject IN h_containr2v ( 18.91 , 4.60 ) NO-ERROR.
       /* Size in AB:  ( 5.43 , 143.60 ) */

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/containr3v.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_containr3v ).
       RUN repositionObject IN h_containr3v ( 20.81 , 4.20 ) NO-ERROR.
       /* Size in AB:  ( 4.52 , 145.20 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 3 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildLinkBrowse wWin 
PROCEDURE buildLinkBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBrowse             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBuffer              AS HANDLE                   NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN hBuffer = TEMP-TABLE ttLink:DEFAULT-BUFFER-HANDLE.

    RUN createBrowse ( INPUT  hBuffer,
                       INPUT  "brLink":U,
                       OUTPUT hBrowse,
                       OUTPUT hQuery       ) NO-ERROR.

    /* Position */
    ASSIGN hBrowse:X             = 15
           hBrowse:Y             = 165
           hBrowse:WIDTH-PIXELS  = 740
           hBrowse:HEIGHT-PIXELS = 245
           .
    /* Extra Triggers */

    CREATE ttLocalPage.
    ASSIGN ttLocalPage.tPageNumber         = 3
           ttLocalPage.tObjectName         = "brLink"
           ttLocalPage.tObjectHandle       = hBrowse
           ttLocalPage.tObjectQueryHandle  = hQuery
           ttLocalPage.tObjectBufferHandle = hBuffer
           ttLocalPage.tBaseQuery          = " FOR EACH ttLink WHERE ":U
                                           + " ttLink.tAction = 'OLD'      OR ":U
                                           + " ttLink.tAction = 'TEMPLATE' OR ":U
                                           + " ttLink.tAction = 'NEW'         ":U
                                           + " NO-LOCK ":U
           ttLocalPage.tCurrentSort        = "BY ttLink.tLinkName ":U
           .
    /* The last thing we do is to make the browse visible. */
    ASSIGN hBrowse:VISIBLE = YES.

    SESSION:SET-WAIT-STATE("":U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageBrowse wWin 
PROCEDURE buildPageBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBrowse             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBuffer             AS HANDLE                   NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN hBuffer = TEMP-TABLE ttPage:DEFAULT-BUFFER-HANDLE.

    RUN createBrowse ( INPUT  hBuffer,
                       INPUT  "brPage":U,
                       OUTPUT hBrowse,
                       OUTPUT hQuery       ) NO-ERROR.

    /* Position */
    ASSIGN hBrowse:X             = 15
           hBrowse:Y             = 165
           hBrowse:WIDTH-PIXELS  = 740
           hBrowse:HEIGHT-PIXELS = 210
           .
    /* Triggers */

    CREATE ttLocalPage.
    ASSIGN ttLocalPage.tPageNumber         = 1
           ttLocalPage.tObjectName         = "brPage"
           ttLocalPage.tObjectHandle       = hBrowse
           ttLocalPage.tObjectQueryHandle  = hQuery
           ttLocalPage.tObjectBufferHandle = hBuffer
           ttLocalPage.tKeyFieldHandle     = hBuffer:BUFFER-FIELD("tLocalSequence":U)
           ttLocalPage.tBaseQuery          = " FOR EACH ttPage WHERE ":U
                                           + " ttPage.tAction = 'OLD'      OR ":U
                                           + " ttPage.tAction = 'TEMPLATE' OR ":U
                                           + " ttPage.tAction = 'NEW'         ":U
                                           + " NO-LOCK ":U
           ttLocalPage.tCurrentSort        = "BY ttPage.tPageSequence ":U
           .
    /* The last thing we do is to make the browse visible. */
    ASSIGN hBrowse:VISIBLE = YES.

    SESSION:SET-WAIT-STATE("":U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageInstanceBrowse wWin 
PROCEDURE buildPageInstanceBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBrowse             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBuffer              AS HANDLE                   NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN hBuffer = TEMP-TABLE ttPageInstance:DEFAULT-BUFFER-HANDLE.

    RUN createBrowse ( INPUT  hBuffer,
                       INPUT  "brPageInstance":U,
                       OUTPUT hBrowse,
                       OUTPUT hQuery       ) NO-ERROR.

    /* Position */
    ASSIGN hBrowse:X             = 15
           hBrowse:Y             = 165
           hBrowse:WIDTH-PIXELS  = 740
           hBrowse:HEIGHT-PIXELS = 200
           .
    /* Triggers */

    CREATE ttLocalPage.
    ASSIGN ttLocalPage.tPageNumber         = 2
           ttLocalPage.tObjectName         = "brPageInstance"
           ttLocalPage.tObjectHandle       = hBrowse
           ttLocalPage.tObjectQueryHandle  = hQuery
           ttLocalPage.tObjectBufferHandle = hBuffer
           ttLocalPage.tKeyFieldHandle     = hBuffer:BUFFER-FIELD("tObjectInstanceObj":U)
           ttLocalPage.tBaseQuery          = " FOR EACH ttPageInstance WHERE ":U
                                           + " ttPageInstance.tParentKey = &1 AND ":U
                                           + " ( ttPageInstance.tPOAction <> 'DEL':U OR ":U
                                           + "   ttPageInstance.tOIAction <> 'DEL':U    ) ":U
           ttLocalPage.tCurrentSort        = "BY ttPageInstance.tPageObjectSequence":U.
           .
    /* The last thing we do is to make the browse visible. */
    ASSIGN hBrowse:VISIBLE = YES.

    SESSION:SET-WAIT-STATE("":U).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse wWin 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT  PARAMETER phBuffer        AS HANDLE                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcBrowseName    AS CHARACTER                NO-UNDO.
    DEFINE OUTPUT PARAMETER phBrowse        AS HANDLE                   NO-UNDO.
    DEFINE OUTPUT PARAMETER phQuery         AS HANDLE                   NO-UNDO.

    DEFINE VARIABLE hColumn                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBufferField            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iFieldLoop              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cColumnName             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cQueryPrepare           AS CHARACTER                NO-UNDO.

    CREATE QUERY phQuery.
    phQuery:ADD-BUFFER(phBuffer).

    /* Create and reposition the parent browse.
     * ----------------------------------------------------------------------- */
    CREATE BROWSE phBrowse
        ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
               NAME                   = pcBrowseName
               SEPARATORS             = TRUE
               ROW-MARKERS            = FALSE
               EXPANDABLE             = TRUE
               COLUMN-RESIZABLE       = TRUE
               ALLOW-COLUMN-SEARCHING = TRUE
               QUERY                  = phQuery
               REFRESHABLE            = YES
        TRIGGERS:            
            ON "START-SEARCH":U   PERSISTENT RUN trgStartSearch   IN THIS-PROCEDURE (INPUT pcBrowseName).
            ON "VALUE-CHANGED":U  PERSISTENT RUN trgValueChanged  IN THIS-PROCEDURE (INPUT pcBrowseName).
        END TRIGGERS
    .
    DO iFieldLoop = 1 TO phBuffer:NUM-FIELDS:
        ASSIGN hBufferField = phBuffer:BUFFER-FIELD(iFieldLoop).

        IF hBufferField:COLUMN-LABEL NE "?":U THEN
            phBrowse:ADD-LIKE-COLUMN(hBufferField).
    END.    /* fields in browse */

    /* And show the browse to the user */
    ASSIGN phBrowse:VISIBLE            = NO     /* The build...Browse code makes the relevant browses visible. */
           phBrowse:SENSITIVE          = YES
           phBrowse:NUM-LOCKED-COLUMNS = 1
           .   
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createFolderInstance wWin 
PROCEDURE createFolderInstance :
/*------------------------------------------------------------------------------
  Purpose:     Creates an instance of the default Folder Object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLocalSequence      AS INTEGER                      NO-UNDO.

    DEFINE BUFFER ttPage            FOR ttPage.
    DEFINE BUFFER ttPageInstance    FOR ttPageInstance.
    DEFINE BUFFER lbPageInstance    FOR ttPageInstance.
    DEFINE BUFFER ryc_smartObject   FOR ryc_smartObject.
    DEFINE BUFFER gsc_object_type   FOR gsc_object_type.

    FIND FIRST ttPage WHERE
               ttPage.tIsPageZero = YES.

    FOR EACH lbPageInstance WHERE
             lbPageInstance.tParentKey = ttPage.tLocalSequence
             BY lbPageInstance.tPageObjectSequence DESCENDING:
        IF ttPage.tPageSequence GT 0 THEN
            ASSIGN iLocalSequence = ( lbPageInstance.tPageObjectSequence MOD ( ttPage.tPageSequence * 100 ) ) + 1.
        ELSE
            ASSIGN iLocalSequence = lbPageInstance.tPageObjectSequence + 1.

        LEAVE.
    END.    /* lbPageInstance. */

    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.object_filename = "{&ICF-FOLDER-OBJECT}":U
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartObject THEN
    DO:
        FIND FIRST gsc_object_type WHERE
                   gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                   NO-LOCK.
        /* Add the page instance. */
        CREATE ttPageInstance.
        ASSIGN ttPageInstance.tOIAction               = "NEW":U
               ttPageInstance.tParentKey              = ttPage.tLocalSequence
               ttPageInstance.tLocalSequence          = (RANDOM(4,22) * -1 * ETIME) + giCnt
               ttPageInstance.tPageObjectSequence     = iLocalSequence
               ttPageInstance.tPageLabel              = ttPage.tPageLabel
               ttPageInstance.tPOAction               = "ZERO":U
               ttPageInstance.tObjectInstanceObj      = 0
               ttPageInstance.tTemplateObjectFilename = "":U
               ttPageInstance.tLayoutPosition         = "M11":U         /* Assume Relative Layout. */
               ttPageInstance.tLayoutName             = ttPage.tLayoutName
               ttPageInstance.tObjectFilename         = ryc_smartObject.object_filename
               ttPageInstance.tIsATemplateRecord      = NO
               ttPageInstance.tObjectTypeCode         = gsc_object_type.object_type_code
               giCnt                                  = giCnt + 1
               .
        /* Add the page link */
        RUN createPageLink ( INPUT ttPageInstance.tObjectFilename,
                             INPUT ttPageInstance.tLocalSequence  ).
    END.    /* avail smartobject */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPageLink wWin 
PROCEDURE createPageLink :
/*------------------------------------------------------------------------------
  Purpose:     Creates a "Page" link between THIS-OBJECT and the folder object
  Parameters:  pcObjectFilename -
               pdObjectId       -
  Notes:       * If we can't find the page instance record based on the object
                 ID, we find the first page instance of the Folder Object and 
                 use that.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectFilename     AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectId           AS DECIMAL              NO-UNDO.

    DEFINE BUFFER ttLink            FOR ttLink.
    DEFINE BUFFER ttPageInstance    FOR ttPageInstance.

    FIND ttPageInstance WHERE
         ttPageInstance.tLocalSequence =  pdObjectId
         NO-ERROR.
    IF NOT AVAILABLE ttPageInstance THEN
        FIND FIRST ttPageInstance WHERE
                   ttPageInstance.tObjectFilename = pcObjectFilename
                   NO-ERROR.

    IF AVAILABLE ttPageInstance THEN
    DO:   
        /* Add the page link */
        CREATE ttLink.
        ASSIGN ttLink.tLinkName          = "Page"
               ttLink.tAction            = "NEW":U
               ttLink.tLinkObj           = 0
               ttLink.tTargetInstanceObj = 0
               ttLink.tTargetId          = 0
               ttLink.tTargetObjectName  = "THIS-OBJECT"
               ttLink.tSourceInstanceObj = 0
               ttLink.tSourceObjectName  = ttPageInstance.tObjectFilename
               ttLink.tSourceId          = ttPageInstance.tLocalSequence
               .
    END.    /* avail page instance. */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY fiObjectName fiTemplateObjectName fiObjectDescription fiWindowTitle 
          fiDefaultMode fiPhysicalObject fiCustomSuperProc toMakeThisTemplate 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE fiObjectName buLookupTemplate fiObjectDescription coObjectType 
         fiWindowTitle coProductModule fiDefaultMode fiCustomSuperProc 
         toMakeThisTemplate buOK buHelp RECT-1 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getData wWin 
PROCEDURE getData :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the data about the container.
  Parameters:  plTemplateRecord - 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plTemplateRecord         AS LOGICAL          NO-UNDO.
    
    DEFINE VARIABLE cPathedObjectName       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.

    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    DEFINE BUFFER gsc_object            FOR gsc_object.
    DEFINE BUFFER gscob                 FOR gsc_object.
    DEFINE BUFFER ttPage                FOR ttPage.
    DEFINE BUFFER ttContainer           FOR ttContainer.

    /* If a template only exists, use the template (adding a new container). */
    IF plTemplateRecord THEN
        FIND FIRST ryc_smartObject WHERE
                   ryc_smartObject.object_filename = fiTemplateObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME}
                   NO-LOCK NO-ERROR.
    ELSE
        FIND FIRST ryc_smartObject WHERE
                   ryc_smartObject.object_filename = fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME}
                   NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ryc_smartObject THEN
    DO:
        RUN showMessages IN gshSessionManager (INPUT  "The SmartObject name specified is invalid.",
                                               INPUT  "ERR",                            /* error type */
                                               INPUT  "&OK",                            /* button list */
                                               INPUT  "&OK",                            /* default button */ 
                                               INPUT  "&OK",                            /* cancel button */
                                               INPUT  "Input Error",                    /* error window title */
                                               INPUT  YES,                              /* display if empty */ 
                                               INPUT  ?,                                /* container handle */ 
                                               OUTPUT cButtonPressed           ).
        RETURN ERROR.
    END.    /* n/a smartobject */
    
    IF fiTemplateObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} EQ "":U THEN    
        ASSIGN fiTemplateObjectName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                                           INPUT "TemplateObjectName":U,
                                                                                           INPUT ryc_smartObject.object_type_obj,
                                                                                           INPUT ryc_smartObject.smartObject_obj,
                                                                                           INPUT 0,
                                                                                           INPUT 0                              ).

    EMPTY TEMP-TABLE ttPage.
    EMPTY TEMP-TABLE ttPageInstance.
    EMPTY TEMP-TABLE ttLink.

    /* Display on screen. */
    FIND FIRST gsc_object WHERE
               gsc_object.object_obj =  ryc_smartobject.object_obj
               NO-LOCK.
    IF gsc_object.logical_object THEN
        FIND FIRST gscob WHERE
                   gscob.object_obj = gsc_object.physical_object_obj
                   NO-LOCK NO-ERROR.
    IF AVAILABLE gscob THEN
        ASSIGN cPathedObjectName = RIGHT-TRIM(gscob.object_path, "/~\":U)
                                 + ( IF gscob.object_path EQ "":U THEN "":U ELSE "/":U )
                                 + gscob.object_filename.
    ELSE
        ASSIGN cPathedObjectName = RIGHT-TRIM(gsc_object.object_path, "/~\":U)
                                 + ( IF gsc_object.object_path EQ "":U THEN "":U ELSE "/":U )
                                 + gsc_object.object_filename.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiPhysicalObject:SCREEN-VALUE = cPathedObjectName
               coObjectType:SCREEN-VALUE     = STRING(gsc_object.object_type_obj)
               .
        /* If this is a template record, then keep the values already entered. */
        IF NOT plTemplateRecord THEN
            ASSIGN fiObjectDescription:SCREEN-VALUE = gsc_object.object_description
                   coProductModule:SCREEN-VALUE     = STRING(gsc_object.product_module_obj)
                   fiCustomSuperProc:SCREEN-VALUE   = ryc_smartObject.custom_super_procedure
                   fiWindowTitle:SCREEN-VALUE       = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "WindowName":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT 0,
                                                                       INPUT 0                              )
                   fiDefaultMode:SCREEN-VALUE       = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "ContainerMode":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT 0,
                                                                       INPUT 0                              )
                   toMakeThisTemplate:CHECKED       = ryc_smartObject.template_smartObject
                   .
        /* Container Info */
        EMPTY TEMP-TABLE ttContainer.

        CREATE ttContainer.
        ASSIGN ttContainer.tAction               = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
               ttContainer.tContainerObj         = (IF plTemplateRecord THEN 0 ELSE ryc_smartObject.smartObject_obj)
               ttContainer.tTemplateContainerObj = (IF plTemplateRecord THEN ryc_smartObject.smartObject_obj ELSE 0)
               ttContainer.tObjectName           = fiObjectName:INPUT-VALUE
               ttContainer.tObjectDescription    = fiObjectDescription:INPUT-VALUE
               ttContainer.tWindowTitle          = fiWindowTitle:INPUT-VALUE
               ttContainer.tObjectTypeObj        = coObjectType:INPUT-VALUE
               ttContainer.tProductModuleObj     = coProductModule:INPUT-VALUE
               ttContainer.tDefaultMode          = fiDefaultMode:INPUT-VALUE
               ttContainer.tCustomSuperProc      = fiCustomSuperProc:INPUT-VALUE
               ttContainer.tDefaultMode          = fiDefaultMode:INPUT-VALUE
               ttContainer.tPhysicalSmartObject  = (IF AVAILABLE gscob THEN gscob.object_obj ELSE 0)
               ttContainer.tIsATemplateRecord    = plTemplateRecord
               ttContainer.tTemplateObjectName   = fiTemplateObjectName:INPUT-VALUE
               .
    END.    /* with frame ... */

    /* Page */
    /* We always create a Page0 */
    CREATE ttPage.
    ASSIGN ttPage.tAction         = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
           ttPage.tLocalSequence  = (RANDOM(2,15) * ETIME * -1) + giCnt
           ttPage.tPageObj        = -1
           ttPage.tLayoutObj      = ryc_smartObject.layout_obj
           ttPage.tPageSequence   = 0
           ttPage.tPageLabel      = "Page0"
           ttPage.tIsPageZero     = YES
           ttPage.tSecurityToken  = "":U
           ttPage.tEnableOnCreate = YES
           ttPage.tEnableOnModify = YES
           ttPage.tEnableOnView   = YES
           giCnt                  = giCnt + 1
           .
    FIND FIRST ryc_layout WHERE
               ryc_layout.layout_obj = ryc_smartObject.layout_obj
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_layout THEN
        ASSIGN ttPage.tLayoutName      = ryc_layout.layout_name
               ttPage.tLayoutType      = ryc_layout.layout_type
               ttPage.tLayoutFilename  = ryc_layout.layout_filename
               ttPage.tLayoutCode      = ryc_layout.layout_code
               .
    /* This RELEASE statement ensures that the ttPage record is available for the query below,
     * if there are no ryc_page records available.                                            */
    RELEASE ttPage.

    /* Build the page instance information. */
    FIND FIRST ttPage NO-ERROR.
    IF AVAILABLE ttPage THEN
        DYNAMIC-FUNCTION("createPageNInstance":U,
                         INPUT ryc_smartObject.smartObject_obj,
                         INPUT plTemplateRecord,
                         INPUT ttPage.tPageObj,
                         INPUT ttPage.tPageSequence,
                         INPUT ttPage.tPageLabel,
                         INPUT ttPage.tLayoutName,
                         INPUT ttPage.tLocalSequence,
                         INPUT ttPage.tIsPageZero        ).
    
    /* Get all the actual pages. */
    DYNAMIC-FUNCTION("createAllPages":U, INPUT ryc_smartObject.smartObject_obj, INPUT plTemplateRecord).

    /* Create Links for the container.
     * Other links are created when the page instances are created. */
    DYNAMIC-FUNCTION("CreateInstanceLinks":U,
                     INPUT ryc_smartObject.smartObject_obj,
                     INPUT plTemplateRecord,
                     INPUT 0,
                     INPUT 0 ).

    /** Clean up the Folder Objects. There should only ever be one folder object,
     *  and that should reside on Page0.
     *  ----------------------------------------------------------------------- **/
    DYNAMIC-FUNCTION("CleanupFolderObjects":U).

    /* Reset the modified flag. */
    ASSIGN glModified = NO.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLinkDetail wWin 
PROCEDURE getLinkDetail :
/*------------------------------------------------------------------------------
  Purpose:     Returns detail of a linked object.
  Parameters:  pdObjectId         -
               pcLinkName         - link name has 2 entries: NAME-[SOURCE|TARGET]
               pcLinkedObjectName -
               pcLinkedObjectId   -
               pcLinkedObjectType - 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdObjectId          AS DECIMAL              NO-UNDO.
    DEFINE INPUT  PARAMETER pcLinkName          AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLinkedObjectName  AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLinkedObjectId    AS DECIMAL              NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLinkedObjectType  AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cLinkType           AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLinkName           AS CHARACTER                    NO-UNDO.

    IF NUM-ENTRIES(pcLinkName, "-":U) EQ 2 THEN
    DO:
        ASSIGN cLinkName        = ENTRY(1, pcLinkName, "-":U)
               cLinkType        = ENTRY(2, pcLinkName, "-":U)
               pcLinkedObjectId = 0
               .
        IF cLinkType EQ "SOURCE":U THEN
        DO:        
            FIND FIRST ttLink WHERE
                       ttLink.tLinkName = cLinkName  AND
                       ttLink.tTargetId = pdObjectId AND
                       ttLink.tAction  <> "DEL":U
                       NO-ERROR.
            IF AVAILABLE ttLink THEN
                ASSIGN pcLinkedObjectId = ttLink.tSourceId.
        END.    /* SOURCE */
        ELSE
        DO:        
            FIND FIRST ttLink WHERE
                       ttLink.tLinkName = cLinkName  AND
                       ttLink.tSourceId = pdObjectId AND
                       ttLink.tAction  <> "DEL":U
                       NO-ERROR.
            IF AVAILABLE ttLink THEN
                ASSIGN pcLinkedObjectId = ttLink.tTargetId.
        END.    /* TARGET */

        IF pcLinkedObjectId NE 0 THEN
        DO:
            FIND FIRST ttPageInstance WHERE
                       ttPageInstance.tLocalSequence = pcLinkedObjectId
                       NO-ERROR.
            IF AVAILABLE ttPageInstance THEN
                ASSIGN pcLinkedObjectName = ttPageInstance.tObjectFilename
                       pcLInkedObjectType = ttPageInstance.tObjectTypeCode
                       .
        END.    /* can find link */
    END.    /* link name has 2 entries NAME-[SOURCE|TARGET] */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject wWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}:
        IF VALID-HANDLE({&WINDOW-NAME}) THEN
            ASSIGN {&WINDOW-NAME}:VISIBLE = FALSE
                   glVisible              = NO
                   .
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/    
    /* Populate combos. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coProductModule:DELIMITER = CHR(3)
               coObjectType:DELIMITER    = CHR(3)
               .
    END.    /* with frame ... */

    RUN SUPER.

    DO WITH FRAME {&FRAME-NAME}:
        RUN populateCombos.
    END.    /* with frame ... */

    /* Build Browses */
    RUN buildPageBrowse             NO-ERROR.
    RUN buildPageInstanceBrowse     NO-ERROR.
    RUN buildLinkBrowse             NO-ERROR.

    /* If this is an 'OPEN' event, the display the given filename,
     * and automatically fetch the data.                          */
    IF Local_P.design_action EQ "OPEN":U THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiObjectName:SCREEN-VALUE  = Local_P.object_filename
               fiObjectName:SENSITIVE     = NO
               coObjectType:SENSITIVE     = NO
               buLookupTemplate:SENSITIVE = NO
               .
        RUN getData ( INPUT NO ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            DISABLE ALL WITH FRAME {&FRAME-NAME}.

        /* Populate the browses */
        DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brPage":U, INPUT "":U).
        DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brLink":U, INPUT "":U).
    END.    /* OPEN, with frame ...  */
    ELSE
    IF Local_P.design_action EQ "NEW":U THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiObjectName:SCREEN-VALUE     = "":U
               fiObjectName:SENSITIVE        = YES
               buLookupTemplate:SENSITIVE    = YES
               fiPhysicalObject:SCREEN-VALUE = "ry/uib/rydyncontw.w":U               
               .
    END.    /* NEW, with frame ...  */

    /* Force the object type to change. */
    APPLY "VALUE-CHANGED":U TO coObjectType.

    ASSIGN {&WINDOW-NAME}:PARENT = Local_P._WINDOW-HANDLE
           {&WINDOW-NAME}:TITLE  = {&WINDOW-NAME}:TITLE + " - ":U + Local_P._WINDOW-HANDLE:TITLE
           NO-ERROR.

    RUN selectPage (INPUT 1).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos wWin 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCombo              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cProfileData        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLipString          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dProductModuleObj   AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj      AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE rRowid              AS ROWID                        NO-UNDO.
    DEFINE VARIABLE lDisplayRepository  AS LOGICAL                      NO-UNDO.

    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    DEFINE BUFFER gsc_product_module        FOR gsc_product_module.
    
    /* Object Type */
    ASSIGN hCombo     = coObjectType:HANDLE IN FRAME {&FRAME-NAME}
           cLipString = "":U
           .
    FOR EACH gsc_object_type WHERE
             gsc_object_type.object_type_code = "DynObjc":U OR
             gsc_object_type.object_type_code = "DynFold":U OR
             gsc_object_type.object_type_code = "DynWind":U OR
             gsc_object_type.object_type_code = "DynMenc":U
             NO-LOCK:
        IF gsc_object_type.object_type_code = Local_P.object_type_code THEN
            ASSIGN dObjectTypeObj = gsc_object_type.object_type_obj.
             
        ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, hCombo:DELIMITER) EQ 0 THEN "":U ELSE hCombo:DELIMITER) 
                          + (gsc_object_type.object_type_code + " // ":U + gsc_object_type.object_type_description + hCombo:DELIMITER + STRING(gsc_object_type.object_type_obj)).
    END.    /* object type */
    ASSIGN hCombo:LIST-ITEM-PAIRS = cLipString
           hCombo:SCREEN-VALUE    = hCombo:ENTRY(1)
           NO-ERROR.

    /* Product Module */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN lDisplayRepository = (cProfileData EQ "YES":U).

    ASSIGN hCombo     = coProductModule:HANDLE IN FRAME {&FRAME-NAME}
           cLipString = "":U
           .
    FOR EACH gsc_product_module
             NO-LOCK:
        IF NOT lDisplayRepository AND
           ( gsc_product_module.product_module_code BEGINS "RY":U  OR
             gsc_product_module.product_module_code BEGINS "RV":U  OR
             gsc_product_module.product_module_code BEGINS "ICF":U OR
             gsc_product_module.product_module_code BEGINS "AF":U  OR
             gsc_product_module.product_module_code BEGINS "GS":U  OR
             gsc_product_module.product_module_code BEGINS "AS":U  OR
             gsc_product_module.product_module_code BEGINS "RTB":U   ) THEN
            NEXT.

        IF gsc_product_module.product_module_code EQ Local_P.product_module_code THEN
            ASSIGN dProductModuleObj = gsc_product_module.product_module_obj.

        ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, hCombo:DELIMITER) EQ 0 THEN "":U ELSE hCombo:DELIMITER) 
                          + (gsc_product_module.product_module_code + " // ":U + gsc_product_module.product_module_description + hCombo:DELIMITER + STRING(gsc_product_module.product_module_obj)).
    END.    /* product module */

    ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, hCombo:DELIMITER) EQ 0 THEN "":U ELSE hCombo:DELIMITER) 
                      + ("<None>" + hCombo:DELIMITER + STRING(0)).   
    
    ASSIGN hCombo:LIST-ITEM-PAIRS = cLipString
           NO-ERROR.

    IF dProductModuleObj EQ 0 THEN
        ASSIGN coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1) NO-ERROR.
    ELSE
        ASSIGN coProductModule:SCREEN-VALUE = STRING(dProductModuleObj) NO-ERROR.

    IF dObjectTypeObj EQ 0 THEN
        ASSIGN coObjectType:SCREEN-VALUE = coObjectType:ENTRY(1) NO-ERROR.
    ELSE
        ASSIGN coObjectType:SCREEN-VALUE = STRING(dObjectTypeObj) NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator wWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm2\folder.w *RTB-SmObj* ".
  RUN "ry\obj\containr1v.w *RTB-SmObj* ".
  RUN "ry\obj\containr2v.w *RTB-SmObj* ".
  RUN "ry\obj\containr3v.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveObject wWin 
PROCEDURE saveObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <None>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pSaveFile         AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT       PARAMETER pSavedCancelled   AS LOGICAL          NO-UNDO.

    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cError                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cCurrentWaitState       AS CHARACTER                NO-UNDO.

    DEFINE BUFFER gscob             FOR gsc_object.

    IF fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} EQ "":U THEN
    DO:
        RUN viewObject.
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '1' '?' '?' '"container object name"' },
                                               INPUT  "ERR",                            /* error type */
                                               INPUT  "&OK",                            /* button list */
                                               INPUT  "&OK",                            /* default button */ 
                                               INPUT  "&OK",                            /* cancel button */
                                               INPUT  "Validation Error",               /* error window title */
                                               INPUT  YES,                              /* display if empty */ 
                                               INPUT  ?,                                /* container handle */ 
                                               OUTPUT cButtonPressed           ).
        ASSIGN pSavedCancelled = YES.
        RETURN.
    END.    /* no container name */

    FIND FIRST ttContainer NO-ERROR.
    IF NOT AVAILABLE ttContainer THEN
    DO WITH FRAME {&FRAME-NAME}:    
        FIND FIRST gscob WHERE
                   gscob.object_filename = ENTRY(NUM-ENTRIES(fiPhysicalObject:INPUT-VALUE, "/":U), fiPhysicalObject:INPUT-VALUE, "/":U)
                   NO-LOCK NO-ERROR.

        CREATE ttContainer.
        ASSIGN ttContainer.tAction               = "NEW":U
               ttContainer.tIsATemplateRecord    = NO
               ttContainer.tContainerObj         = 0
               ttContainer.tTemplateContainerObj = 0
               ttContainer.tDefaultMode          = fiDefaultMode:INPUT-VALUE
               ttContainer.tPhysicalSmartObject  = (IF AVAILABLE gscob THEN gscob.object_obj ELSE 0)
               .
    END.    /* n/a container */

    /* Ensure that we're not overwriting another record. */
    IF ttContainer.tAction NE "OLD":U AND
       CAN-FIND(FIRST ryc_smartObject WHERE
                      ryc_smartObject.object_filename = fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} ) THEN
    DO WITH FRAME {&FRAME-NAME}:    
        RUN viewObject.
        RUN showMessages IN gshSessionManager (INPUT  "A SmartObject named `" + fiObjectName:INPUT-VALUE + "` already exists. Please use another name.",
                                               INPUT  "ERR",                            /* error type */
                                               INPUT  "&OK",                            /* button list */
                                               INPUT  "&OK",                            /* default button */ 
                                               INPUT  "&OK",                            /* cancel button */
                                               INPUT  "Validation Error", /* error window title */
                                               INPUT  YES,                              /* display if empty */ 
                                               INPUT  ?,                    /* container handle */ 
                                               OUTPUT cButtonPressed           ).
        ASSIGN pSavedCancelled = YES.
        RETURN.
    END.    /* duplicate file name */

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN ttContainer.tObjectName         = fiObjectName:INPUT-VALUE
               ttContainer.tObjectDescription  = fiObjectDescription:INPUT-VALUE
               ttContainer.tWindowTitle        = fiWindowTitle:INPUT-VALUE
               ttContainer.tObjectTypeObj      = coObjectType:INPUT-VALUE
               ttContainer.tProductModuleObj   = coProductModule:INPUT-VALUE
               ttContainer.tDefaultMode        = fiDefaultMode:INPUT-VALUE
               ttContainer.tCustomSuperProc    = fiCustomSuperProc:INPUT-VALUE
               ttContainer.tMakeThisTemplate   = toMakeThisTemplate:CHECKED
               ttContainer.tTemplateObjectName = fiTemplateObjectName:INPUT-VALUE               
               .
        /* The container's layout is the layout from Page0 */
        FIND FIRST ttPage WHERE
                   ttPage.tIsPageZero = YES
                   NO-ERROR.
        IF AVAILABLE ttPage THEN
            ASSIGN ttContainer.tLayoutObj = ttPage.tLayoutObj.
    END.    /* with frame ... */

    /* If a Folder Object exists on Page0 and there are no pages, then remove the Folder Object. */
    FIND FIRST ttPage WHERE
               ttPage.tIsPageZero = NO      AND
               ttPage.tAction    <> "DEL":U
               NO-ERROR.
    IF NOT AVAILABLE ttPage THEN
    DO:
        FIND FIRST ttPage WHERE
                   ttPage.tIsPageZero = YES
                   NO-ERROR.
        FIND FIRST ttPageInstance WHERE
                   ttPageInstance.tParentKey      = ttPage.tLocalSequence AND
                   ttPageInstance.tObjectTypeCode = "SmartFolder":U
                   NO-ERROR.
        /* Links, Attribute values, UI events and page objects are removed by the 
         * object instance delete trigger.                                        */
        IF AVAILABLE ttPageInstance THEN
            ASSIGN ttPageInstance.tOIAction = "DEL":U
                   ttPageInstance.tPOAction = "ZERO":U
                   .
    END.    /* there are no other pages. */

    /* Update the Repository */
    ASSIGN cCurrentWaitState = SESSION:GET-WAIT-STATE().
    SESSION:SET-WAIT-STATE("GENERAL":U).

    RUN ry/app/contbuildp.p ( INPUT TABLE ttContainer,
                              INPUT TABLE ttPage,
                              INPUT TABLE ttPageInstance,
                              INPUT TABLE ttLink          ) NO-ERROR.

    SESSION:SET-WAIT-STATE(cCurrentWaitState).

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    DO:
        ASSIGN cError = RETURN-VALUE.

        RUN viewObject.
        RUN showMessages IN gshSessionManager (INPUT  cError,                   /* message to display */
                                               INPUT  "ERR",                    /* error type */
                                               INPUT  "&OK",                    /* button list */
                                               INPUT  "&OK",                    /* default button */ 
                                               INPUT  "&OK",                    /* cancel button */
                                               INPUT  "Build Container Errors", /* error window title */
                                               INPUT  YES,                      /* display if empty */ 
                                               INPUT  ?,                        /* container handle */ 
                                               OUTPUT cButtonPressed           ).
        ASSIGN pSavedCancelled = YES.
        RETURN.
    END.    /* error */

    /* Refresh the dialogue. */
    ASSIGN fiTemplateObjectName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
           glModified                                               = NO
           .
    RUN getData ( INPUT NO ) NO-ERROR.

    /* If the object is visible, make sure that the browses display. */
    IF glVisible THEN
        RUN viewObject.

    /* We have a successful save. Update some AB-related fields and UI. */
    ASSIGN pSavedCancelled = NO.

    IF AVAILABLE(local_P)                   AND
       VALID-HANDLE(Local_P._window-handle) THEN
    DO:    
        ASSIGN local_P.object_filename    = fiObjectName:INPUT-VALUE
               local_P.object_type_code   = getContainerType()
               local_P._type              = local_P.object_type_code
               fiObjectName:SENSITIVE     = NO                /* } */
               coObjectType:SENSITIVE     = NO                /* } These are not updateable for an OPEN action */
               buLookupTemplate:SENSITIVE = NO                /* } */              
               pSaveFile                  = local_P.object_filename
               Local_P.design_action      = "OPEN":U
               .
        /* Ensure that the window title stays as the format: "PropSheet - ObjTypeCOde - ObjFilename" */
        IF NUM-ENTRIES({&WINDOW-NAME}:TITLE, "-":U) GE 1 THEN
            ASSIGN {&WINDOW-NAME}:TITLE = TRIM(ENTRY(1, {&WINDOW-NAME}:TITLE, "-":U)) + " - ":U
                                        + Local_P.object_type_code + " - ":U
                                        + Local_P.object_filename.
        ELSE
            ASSIGN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - ":U
                                        + Local_P.object_type_code + " - ":U
                                        + Local_P.object_filename.
    END.    /* can update the window title. */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCurrentPageNumber      AS INTEGER          NO-UNDO.

    RUN SUPER ( INPUT piCurrentPageNumber ).

    IF giCurrentPage NE piCurrentPageNumber THEN
    DO:    
        /* Page-specific stuff. */
        IF LOOKUP("selectPage":U + TRIM(STRING(piCurrentPageNumber)), THIS-PROCEDURE:INTERNAL-ENTRIES) NE 0 THEN
            DYNAMIC-FUNCTION("selectPage":U + TRIM(STRING(piCurrentPageNumber))).

        FOR EACH ttLocalPage WHERE
                 VALID-HANDLE(ttLocalPage.tObjectHandle) AND
                 ttLocalPage.tPageNumber NE 0 :
    
            IF ttLocalPage.tPageNumber EQ piCurrentPageNumber THEN
            DO:
                ttLocalPage.tObjectHandle:MOVE-TO-TOP().
                RUN trgValueChanged ( INPUT ttLocalPage.tObjectName).
            END.    /* obejcts on this page. */
            ELSE
                ttLocalPage.tObjectHandle:MOVE-TO-BOTTOM().
        END.    /* Local Page */
    END.    /* we are changing pages. */

    ASSIGN giCurrentPage = piCurrentPageNumber.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgStartSearch wWin 
PROCEDURE trgStartSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcBrowseName         AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hColumn         AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE rCurrentRow     AS ROWID                            NO-UNDO.
    DEFINE VARIABLE cColumnName     AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cTableName      AS CHARACTER                        NO-UNDO.

    DEFINE BUFFER ttLocalPage       FOR ttLocalPage.

    /* Determine current row. */
    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = pcBrowseName.

    IF ttLocalPage.tObjectQueryHandle:NUM-RESULTS GT 0 THEN
    DO:
        IF NOT ttLocalPage.tObjectHandle:SELECT-FOCUSED-ROW() THEN
            ttLocalPage.tObjectHandle:SELECT-ROW(1).

        ASSIGN rCurrentRow = ttLocalPage.tObjectBufferHandle:ROWID.
    END.    /* records available */
    ELSE
        ASSIGN rCurrentRow = ?.

    /* Determine the new row. */
    ASSIGN hColumn                  = ttLocalPage.tObjectHandle:CURRENT-COLUMN
           cColumnName              = hColumn:NAME
           cTableName               = hColumn:TABLE
           ttLocalPage.tCurrentSort = " BY ":U + (IF cTableName EQ ? THEN "":U ELSE (".":U + cTableName)) + cColumnName + " ":U
           .
    /* Reopen Query */
    IF pcBrowseName EQ "brPageInstance":U THEN
        DYNAMIC-FUNCTION("SelectPage2":U).
    ELSE
        DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT pcBrowseName, INPUT "":U).

    /* Reposition to the saved record. */
    IF ttLocalPage.tObjectQueryHandle:NUM-RESULTS GT 0 THEN
        ttLocalPage.tObjectQueryHandle:REPOSITION-TO-ROWID(rCurrentRow) NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged wWin 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcBrowseName         AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTableHandle            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hViewer                 AS HANDLE                   NO-UNDO.

    CASE pcBrowseName:
        WHEN "brPage":U THEN
        DO:
            EMPTY TEMP-TABLE ttPassPage.
            ASSIGN hBuffer      = TEMP-TABLE ttPassPage:DEFAULT-BUFFER-HANDLE
                   hTableHandle = TEMP-TABLE ttPassPage:HANDLE
                   hViewer      = h_containr1v
                   .
        END.    /* brPage*/
        WHEN "brPageInstance":U THEN
        DO:
            EMPTY TEMP-TABLE ttPassInstance.
            ASSIGN hBuffer      = TEMP-TABLE ttPassInstance:DEFAULT-BUFFER-HANDLE
                   hTableHandle = TEMP-TABLE ttPassInstance:HANDLE
                   hViewer      = h_containr2v
                   .
        END.    /* brPageInstance */
        WHEN "brLink":U THEN
        DO:
            EMPTY TEMP-TABLE ttPassLink.
            ASSIGN hBuffer      = TEMP-TABLE ttPassLink:DEFAULT-BUFFER-HANDLE
                   hTableHandle = TEMP-TABLE ttPassLink:HANDLE
                   hViewer      = h_containr3v
                   .
        END.    /* brLink */
        /* Do nothing. */
        OTHERWISE RETURN.
    END CASE.   /* pcBrowseName  */

    /* Get the current Page record. */
    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = pcBrowseName
         NO-ERROR.

    IF AVAILABLE ttLocalPage THEN
    DO:
        IF ttLocalPage.tObjectQueryHandle:NUM-RESULTS GT 0 THEN
            ttLocalPage.tObjectHandle:SELECT-FOCUSED-ROW() NO-ERROR.

        IF ttLocalPage.tObjectBufferHandle:AVAILABLE THEN
        DO:
            hBuffer:BUFFER-CREATE().
            hBuffer:BUFFER-COPY(ttLocalPage.tObjectBufferHandle).
            hBuffer:BUFFER-RELEASE().
        END.    /* avail page. */
    END.    /* avail local page */

    IF VALID-HANDLE(hViewer)                                   AND
       LOOKUP("RecordChange":U, hViewer:INTERNAL-ENTRIES) NE 0 THEN
        RUN RecordChange IN hViewer ( INPUT TABLE-HANDLE hTableHandle ).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateLinkRecord wWin 
PROCEDURE updateLinkRecord :
/*------------------------------------------------------------------------------
  Purpose:     Commit changs made in the link viewer to the browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttPassLink.

    DEFINE VARIABLE rCurrentRow             AS ROWID                NO-UNDO.
    
    DEFINE BUFFER ttLink                FOR ttLink.
    DEFINE BUFFER lbSourcePageInstance  FOR ttPageInstance.
    DEFINE BUFFER lbTargetPageInstance  FOR ttPageInstance.
    
    FIND FIRST ttPassLink NO-ERROR.

    IF AVAILABLE ttPassLink THEN
    DO:
        /* Update the Source and Target object names and obj's */
        /* Find source object */
        FIND FIRST lbSourcePageInstance WHERE
                   lbSourcePageInstance.tLocalSequence = ttPassLink.tSourceId
                   NO-ERROR.
        IF AVAILABLE lbSourcePageInstance THEN  
            ASSIGN ttPassLink.tSourceInstanceObj = lbSourcePageInstance.tObjectInstanceObj
                   ttPassLink.tSourceObjectName  = lbSourcePageInstance.tObjectFileName
                   .
        ELSE
            ASSIGN ttPassLink.tSourceInstanceObj = 0
                   ttPassLink.tSourceObjectName  = "THIS-OBJECT"
                   .
        /* Find Target object */
        FIND FIRST lbTargetPageInstance WHERE
                   lbTargetPageInstance.tLocalSequence = ttPassLink.tTargetId
                   NO-ERROR.
        IF AVAILABLE lbTargetPageInstance THEN
            ASSIGN ttPassLink.tTargetInstanceObj = lbTargetPageInstance.tObjectInstanceObj
                   ttPassLink.tTargetObjectName  = lbTargetPageInstance.tObjectFileName
                   .
        ELSE
            ASSIGN ttPassLink.tTargetInstanceObj = 0
                   ttPassLink.tTargetObjectName  = "THIS-OBJECT"
                   .
        FIND ttLink WHERE
             ttLink.tSourceId = ttPassLink.tSourceId AND
             ttLink.tLinkName = ttPassLink.tLinkName AND
             ttLink.tTargetId = ttPassLink.tTargetId
             NO-ERROR.

        IF ttPassLink.tAction EQ "NEW":U AND
           NOT AVAILABLE ttLink          THEN
        DO:
            CREATE ttLink.
            ASSIGN ttLink.tAction = "NEW":U.
        END.    /* NEW */

        /* If a newly added link has been deleted before being committed to the Repository,
         * we can simply delete the link.                                                   */
        IF ttPassLink.tAction EQ "DEL":U AND
           ttLink.tAction     EQ "NEW":U THEN
            DELETE ttLink.

        IF AVAILABLE ttLink THEN
        DO:
            BUFFER-COPY ttPassLink TO ttLink.

            IF ttLink.tAction EQ "DEL":U THEN
                ASSIGN rCurrentRow = ?.
            ELSE
                ASSIGN rCurrentRow = ROWID(ttLink).
        END.    /* avail page */
        ELSE
            ASSIGN rCurrentRow = ?.
    END.    /* avail ttPassLink */

    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = "brLink":U
         NO-ERROR.
    IF AVAILABLE ttLocalPage THEN
    DO:
        /* Reopen the query */
        DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT "brLink":U, INPUT "":U).

        /* Reposition to the current record. */
        IF rCurrentRow NE ? THEN
            ttLocalPage.tObjectQueryHandle:REPOSITION-TO-ROWID(rCurrentRow).

        RUN trgValueChanged( INPUT ttLocalPage.tObjectName).
    END.    /* avail local page */    

    ASSIGN glModified = YES.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePage wWin 
PROCEDURE updatePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttPassPage.

    DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE rCurrentRow             AS ROWID                NO-UNDO.
    DEFINE VARIABLE cButtonPressed          AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ttPage            FOR ttPage.
    DEFINE BUFFER lbPage            FOR ttPage.
    DEFINE BUFFER lbPageInstance    FOR ttPageInstance.
    DEFINE BUFFER ttPageInstance    FOR ttPageInstance.
    DEFINE BUFFER ttLink            FOR ttLink.
    DEFINE BUFFER ryc_layout        FOR ryc_layout.

    FIND FIRST ttPassPage NO-ERROR.

    IF AVAILABLE ttPassPage THEN
    DO:
        /* Get the local version of this page. */
        FIND ttPage WHERE
             ttPage.tLocalSequence = ttPassPage.tLocalSequence
             NO-ERROR.

        /* If this page does not exist in the repository yet, we can safely delete the
         * ttPage record. If the page does exist in the repository, we must flag the 
         * page for deletion.                                                         */
        IF ttPassPage.tAction EQ "DEL":U THEN
        DO:
            /* Make sure that the template is not used. */
            ASSIGN ttPassPage.tUpdateContainer = NO.

            /* Always delete the page instances and links from the Property Sheet.
             * If need be, the business logic will delete the links, pages, page
             * objects and object instances from the Repository if necessary.     */
            FOR EACH ttPageInstance WHERE
                     ttPageInstance.tParentKey = ttPassPage.tLocalSequence :

                /* Remove all existing links to this page. */
                FOR EACH ttLink WHERE
                         ttLink.tSourceId = ttPageInstance.tLocalSequence OR
                         ttLink.tTargetId = ttPageInstance.tLocalSequence   :
                    DELETE ttLink.
                END.    /* links */

                /* Remove all page instances on this page. */
                DELETE ttPageInstance.
            END.    /* page instances. */

            /* If ths is a NEW or TEMPLATE record, then delete the ttPage record. */
            IF ttPage.tAction NE "OLD":U THEN
                DELETE ttPage.
        END.    /* delete */

        IF ttPassPage.tAction EQ "NEW":U AND
           NOT AVAILABLE ttPage          THEN
        DO:
            /* Check that we're not re-creating a deleted page.
             * Also check for duplicates. The page sequence must be unique per
             * container.                                                       */
            FIND FIRST ttPage WHERE
                       ttPage.tPageSequence = ttPassPage.tPageSequence
                       NO-ERROR.
            IF AVAILABLE ttPage THEN
            DO:
                IF ttPage.tAction EQ "DEL":U THEN
                    /* We want to update the existing page record in the
                     * Repository, instead of deleting this record, and creating
                     * an new record.
                     * To be able to do this we must use the pointers from the 
                     * existing ttPage record.                                 */
                    ASSIGN ttPassPage.tAction          = "OLD":U
                           ttPassPage.tPageObj         = ttPage.tPageObj
                           ttPassPage.tUpdateContainer = YES
                           ttPage.tLocalSequence       = ttPassPage.tLocalSequence
                           /* This flag should only ever be set here. */
                           ttPassPage.tReCreated       = YES
                           .
                ELSE
                DO:
                    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '8' '?' '?' '"a page sequence of"' "ttPassPage.tPageSequence" },
                                                           INPUT  "ERR",                    /* error type */
                                                           INPUT  "&OK",                    /* button list */
                                                           INPUT  "&OK",                    /* default button */ 
                                                           INPUT  "&OK",                    /* cancel button */
                                                           INPUT  "Validation Error",       /* error window title */
                                                           INPUT  YES,                      /* display if empty */ 
                                                           INPUT  ?,                        /* container handle */
                                                           OUTPUT cButtonPressed       ).   /* button pressed */
                    RETURN ERROR.
                END.    /* attempting to create a duplicate page. */
            END.    /* can find a duplicate page sequence */
            ELSE
            DO:
                CREATE ttPage.
                ASSIGN ttPage.tLocalSequence = ttPassPage.tLocalSequence
                       ttPage.tAction        = "NEW":U
                       ttPage.tIsPageZero    = (ttPassPage.tPageSequence EQ 0)
                       .
                RELEASE ttPage.
            END.    /* no duplicate found */

            /* Create a Page0 if none exists. */
            IF NOT CAN-FIND(FIRST ttPage WHERE ttPage.tIsPageZero) THEN
            DO:
                CREATE ttPage.
                ASSIGN ttPage.tAction            = "NEW":U
                       ttPage.tLocalSequence     = (RANDOM(4,12) * ETIME * -1) + giCnt
                       ttPage.tPageObj           = -1
                       ttPage.tLayoutObj         = 0
                       ttPage.tPageSequence      = 0
                       ttPage.tPageLabel         = "Page0"
                       ttPage.tIsPageZero        = YES
                       ttPage.tSecurityToken     = "Page0":U
                       ttPage.tEnableOnCreate    = YES
                       ttPage.tEnableOnModify    = YES
                       ttPage.tEnableOnView      = YES
                       ttPage.tUpdateContainer   = YES
                       giCnt                     = giCnt + 1
                       .
                /* Always use a RELATIVE layout for new pages/objects etc. */
                FIND FIRST ryc_layout WHERE
                           ryc_layout.layout_name = "RELATIVE":U
                           NO-LOCK NO-ERROR.
                IF AVAILABLE ryc_layout THEN
                    ASSIGN ttPage.tLayoutName     = ryc_layout.layout_name
                           ttPage.tLayoutType     = ryc_layout.layout_type
                           ttPage.tLayoutFilename = ryc_layout.layout_filename
                           ttPage.tLayoutCode     = ryc_layout.layout_code
                           ttPage.tLayoutObj      = ryc_layout.layout_obj
                           .
                RELEASE ttPage.
            END.    /* create Page0 */
        END.    /* NEW */

        /* Make sure that we have the correct ttPage record, otherwise
         * we are going to update the PageO record.                    */
        FIND ttPage WHERE
             ttPage.tLocalSequence = ttPassPage.tLocalSequence
             NO-ERROR.

        IF AVAILABLE ttPage THEN
        DO:
            /* update layout info */
            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_obj = ttPassPage.tLayoutObj
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_layout THEN
                ASSIGN ttPassPage.tLayoutName      = ryc_layout.layout_name
                       ttPassPage.tLayoutType      = ryc_layout.layout_type
                       ttPassPage.tLayoutFilename  = ryc_layout.layout_filename
                       ttPassPage.tLayoutCode      = ryc_layout.layout_code
                       .            
            BUFFER-COPY ttPassPage EXCEPT tIsPageZero tReCreated
                TO ttPage.

            /* Ensure that the */
            ASSIGN ttPassPage.tIsPageZero = ttPage.tIsPageZero.

            IF ttPage.tAction EQ "DEL":U THEN
                ASSIGN rCurrentRow = ?.
            ELSE
                ASSIGN rCurrentRow = ROWID(ttPage).
            
            /* The page template has changed, or needs updating. */
            /* Page0 is the entire window, and is equivalent to changing the entire template */
            IF ttPage.tUpdateContainer THEN
                RUN updatePageN ( INPUT ttPage.tLocalSequence,
                                  INPUT ttPage.tPageSequence,
                                  INPUT ttPage.tLayoutTemplateObject,
                                  INPUT ttPage.tIsPageZero            ).

            /* Reset this flag if a template object exists. It should only be YES when adding a page.  */
            ASSIGN ttPage.tUpdateContainer = NO.

            /* Update the page instances of this page with 
             * the new page label, layout etc.             */
            FOR EACH ttPageInstance WHERE
                     ttPageInstance.tParentKey = ttPage.tLocalSequence :
                ASSIGN ttPageInstance.tPageLabel  = ttPage.tPageLabel
                       ttPageInstance.tLayoutName = ttPage.tLayoutName
                       .
            END.    /* don't update container. */

            /** If we are adding more that just Page0, we need to be sure that the folder
             *  object exists on Page0.
             *  ----------------------------------------------------------------------- **/
            IF ttPage.tAction                 NE "DEL":U AND
               NOT DYNAMIC-FUNCTION("HasFolderObject":U) THEN
            DO:
                RUN showMessages IN gshSessionManager (INPUT  "You are adding pages to this container, but no Folder Object exists on Page0.~n"
                                                            + " One will be added automatically for you.",
                                                       INPUT  "INF",                /* error type */
                                                       INPUT  "&OK",                /* button list */
                                                       INPUT  "&OK",                /* default button */ 
                                                       INPUT  "&OK",                /* cancel button */
                                                       INPUT  "Page Inconsistency", /* error window title */
                                                       INPUT  YES,                  /* display if empty */ 
                                                       INPUT  ?,                    /* container handle */
                                                       OUTPUT cButtonPressed       ).    /* button pressed */
                RUN CreateFolderInstance NO-ERROR.
            END.    /* NOT Page0 and no folder page exists */

            /** Clean up the Folder Objects. There should only ever be one folder object,
             *  and that should reside on Page0.
             *  ----------------------------------------------------------------------- **/
            DYNAMIC-FUNCTION("CleanupFolderObjects":U).

            /** If there is a folder object, make sure that there's a Page Link.
             *  ----------------------------------------------------------------------- **/
            IF DYNAMIC-FUNCTION("HasFolderObject":U) AND
               NOT DYNAMIC-FUNCTION("HasPageLink":U) THEN
            DO:
                RUN showMessages IN gshSessionManager (INPUT  "You are adding pages to this container, but no Page link exists.~n"
                                                            + " One will be added automatically for you.",
                                                       INPUT  "INF",                /* error type */
                                                       INPUT  "&OK",                /* button list */
                                                       INPUT  "&OK",                /* default button */ 
                                                       INPUT  "&OK",                /* cancel button */
                                                       INPUT  "Page Link Inconsistency", /* error window title */
                                                       INPUT  YES,                  /* display if empty */ 
                                                       INPUT  ?,                    /* container handle */
                                                       OUTPUT cButtonPressed       ).    /* button pressed */
                RUN CreatePageLink (INPUT "{&ICF-FOLDER-OBJECT}":U, INPUT 0) NO-ERROR.
            END.    /* NOT Page0 and no fodler page exists */
        END.    /* avail page */
    END.    /* avail ttPassPage */

    /* Update the Links. */
    DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT "brLink":U, INPUT "":U).

    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = "brPage":U
         NO-ERROR.
    IF AVAILABLE ttLocalPage THEN
    DO:
        /* Reopen the query */
        DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT "brPage":U, INPUT "":U).
        
        /* Reposition to the current record. */
        IF rCurrentRow NE ? THEN
            ttLocalPage.tObjectQueryHandle:REPOSITION-TO-ROWID(rCurrentRow).

        RUN trgValueChanged ( INPUT ttLocalPage.tObjectName ).
    END.    /* avail local page */

    ASSIGN glModified = YES.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageInstance wWin 
PROCEDURE updatePageInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttPassInstance.

    DEFINE BUFFER ttPageInstance            FOR ttPageInstance.
    DEFINE BUFFER ryc_smartObejct           FOR ryc_smartObject.

    FIND FIRST ttPassInstance NO-ERROR.

    IF AVAILABLE ttPassInstance THEN
    DO:
        /* 'Old' Object */
        FIND FIRST ttPageInstance WHERE 
                   ttPageInstance.tParentKey     = ttPassInstance.tParentKey    AND
                   ttPageInstance.tLocalSequence = ttPassInstance.tLocalSequence
                   NO-ERROR.

        /* Update any links.
         * We only update the object names,because the links to the smartLink table
         * are via the object instance obj. This value will only be updated once
         * we commit the changes to the DB.                                         */

        /* Change Source object name */
        FOR EACH ttLink WHERE
                 ttLink.tSourceId = ttPageInstance.tLocalSequence :
            ASSIGN ttLink.tSourceObjectName = ttPassInstance.tObjectFilename.
        END.    /* Source Links */

        /* Change target object name */
        FOR EACH ttLink WHERE
                 ttLink.tTargetId = ttPageInstance.tLocalSequence :
            ASSIGN ttLink.tTargetObjectName = ttPassInstance.tObjectFilename.
        END.    /* Target Links */

        /* Update the Page Instance record. */
        IF AVAILABLE ttPageInstance THEN
            BUFFER-COPY ttPassInstance TO ttPageInstance.
    END.    /* available page instance */

    /* Update the Page Instance. */
    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = "brPageInstance":U
         NO-ERROR.
    IF AVAILABLE ttLocalPage                           AND
       ttLocalPage.tObjectQueryHandle:NUM-RESULTS GT 0 THEN
        ttLocalPage.tObjectHandle:REFRESH().

    DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT "brLink":U, INPUT "":U).
    
    ASSIGN glModified = YES.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageN wWin 
PROCEDURE updatePageN :
/*------------------------------------------------------------------------------
  Purpose:     Updates a page with a page template's instances. 
  Parameters:  pdPageLocalSequence    -
               piPageSequence         -
               pcLayoutTemplateObject -
               plIsPageZero           -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdPageLocalSequence          AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER piPageSequence               AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER pcLayoutTemplateObject       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER plIsPageZero                 AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE iPageObjectSequence     AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iLocalSequence          AS INTEGER                  NO-UNDO.

    DEFINE BUFFER ttLink            FOR ttLink.
    DEFINE BUFFER ttPageInstance    FOR ttPageInstance.
    DEFINE BUFFER rycoi             FOR ryc_object_instance.
    DEFINE BUFFER rycso             FOR ryc_smartObject.
    DEFINE BUFFER ryc_smartObject   FOR ryc_smartObject.

    /* First remove existing data.
     * The records are deleted, and not just flagged to be deleted,
     * because the business logica procedure looks at the UpdateContainer
     * flag, and deletes records based on that flag.                     */
    FOR EACH ttPageInstance WHERE
             ttPageInstance.tParentKey = pdPageLocalSequence :
        /* Remove all existing links to this page. */
        FOR EACH ttLink WHERE
                 ttLink.tSourceId = ttPageInstance.tLocalSequence OR
                 ttLink.tTargetId = ttPageInstance.tLocalSequence   :
            DELETE ttLink.
        END.    /* links */

        /* Remove all page instances on this page. */
        DELETE ttPageInstance.
    END.    /* page instances. */

    /* Add new template records. */
    ASSIGN iPageObjectSequence = ( 100 * piPageSequence ) + 1.

    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.object_filename = pcLayoutTemplateObject
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartObject THEN
    DO:
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj
                 NO-LOCK,
           FIRST ryc_smartObject WHERE
                 ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
                 NO-LOCK,
           FIRST gsc_object_type WHERE
                 gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                 NO-LOCK:
            CREATE ttPageInstance.
            ASSIGN ttPageInstance.tPOAction               = (IF plIsPageZero THEN "ZERO":U ELSE "NEW":U)
                   ttPageInstance.tOIAction               = "TEMPLATE":U
                   ttPageInstance.tParentKey              = pdPageLocalSequence
                   ttPageInstance.tLocalSequence          = (RANDOM(1,7) * ETIME * -1) + giCnt
                   ttPageInstance.tPageObjectObj          = 0
                   ttPageInstance.tPageObjectSequence     = iPageObjectSequence
                   iPageObjectSequence                    = iPageObjectSequence + 1
                   ttPageInstance.tObjectInstanceObj      = ryc_object_instance.object_instance_obj
                   ttPageInstance.tTemplateObjectFilename = ryc_smartObject.object_filename
                   ttPageInstance.tLayoutPosition         = ryc_object_instance.layout_position
                   ttPageInstance.tObjectFilename         = ryc_smartObject.object_filename
                   ttPageInstance.tIsATemplateRecord      = YES
                   ttPageInstance.tObjectTypeCode         = gsc_object_type.object_type_code
                   giCnt                                  = giCnt + 1
                   .
            ASSIGN ttPageInstance.tWindowTitleField = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "WindowTitleField":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT ryc_object_instance.object_instance_obj,
                                                                       INPUT ryc_object_instance.container_smartObject_obj)
                   ttPageInstance.tForeignFields    = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "ForeignFields":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT ryc_object_instance.object_instance_obj,
                                                                       INPUT ryc_object_instance.container_smartObject_obj)
                   ttPageInstance.tLaunchContainer  = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "FolderWindowToLaunch":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT ryc_object_instance.object_instance_obj,
                                                                       INPUT ryc_object_instance.container_smartObject_obj)
                   ttPageInstance.tNavigationTargetName = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "NavigationTargetName":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT ryc_object_instance.object_instance_obj,
                                                                       INPUT ryc_object_instance.container_smartObject_obj)

                   .
            /* Create Links for this instance. */
            DYNAMIC-FUNCTION("CreateInstanceLinks":U,
                             INPUT ryc_object_instance.container_smartObject_obj,
                             INPUT YES,                                             /* Template? */
                             INPUT ryc_object_instance.object_instance_obj,
                             INPUT ttPageInstance.tLocalSequence ).
        END.    /* rycoi */
    END.    /*  avail smartobject */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject wWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCurrentPage            AS INTEGER                  NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN {&WINDOW-NAME}:VISIBLE = TRUE
               iCurrentPage           = giCurrentPage
               giCurrentPage          = 0    /* reset this value so that the page displays */
               glVisible              = YES
               .
        {&WINDOW-NAME}:MOVE-TO-TOP().

        IF NOT glModified THEN
        DO:
            /* Reopen the query */
            DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brPage":U, INPUT "":U).
            DYNAMIC-FUNCTION("reopenBrowseQuery", INPUT "brLink":U, INPUT "":U).
        END.    /* this is for cases where we have minimised and saved. */

        RUN selectPage (INPUT iCurrentPage).
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CleanupFolderObjects wWin 
FUNCTION CleanupFolderObjects RETURNS LOGICAL
    ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  Ensures that there is only one Folder object, and that it is on Page0.
    Notes:  * This code is necessary because the ADM doesn't support folders
              within folders.
            * This code assumes that the necessary checking for the existence 
              of folder objects has already been performed.
            * This function also ensures that a "Page" link exists.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lFoundOnPage0           AS LOGICAL                  NO-UNDO.     
    DEFINE VARIABLE lCleanedUp              AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE dLocalSequence          AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.

    DEFINE BUFFER ttPageInstance        FOR ttPageInstance.
    DEFINE BUFFER ttPage                FOR ttPage.
    DEFINE BUFFER ttLink                FOR ttLink.

    /* There should be at least one folder object. */
    IF CAN-FIND(FIRST ttPageInstance WHERE ttPageInstance.tObjectTypeCode = "SmartFolder":U) THEN
    DO:
        /* We will need Page0 */
        FIND FIRST ttPage WHERE
                   ttPage.tIsPageZero = YES
                   NO-ERROR.
        /* Ensure that the folder object exists on Page0 */
        FIND FIRST ttPageInstance WHERE
                   ttPageInstance.tParentKey      = ttPage.tLocalSequence AND
                   ttPageInstance.tObjectTypeCode = "SmartFolder"
                   NO-ERROR.
        ASSIGN lFoundOnPage0  = (AVAILABLE ttPageInstance)
               dLocalSequence = (IF AVAILABLE ttPageInstance THEN ttPageInstance.tLocalSequence ELSE 0)
               lCleanedUp     = NOT lFoundOnPage0
               .
        IF NOT lFoundOnPage0 THEN
        DO:
            /* Take the first folder object we can find and place on Page0.
             * Any other folder objects will be deleted, as will their
             * links.
             *
             * Delete the Page Object record, since this object must now
             * appear on Page0.                                          */
            FIND FIRST ttPageInstance WHERE
                       ttPageInstance.tObjectTypeCode = "SmartFolder".
            ASSIGN dLocalSequence                     = ttPageInstance.tLocalSequence
                   ttPageInstance.tParentKey          = ttPage.tLocalSequence
                   ttPageInstance.tPOAction           = "DEL":U
                   ttPageInstance.tPageObjectSequence = ( 100 * ttPage.tPageSequence ) + 99
                   ttPageInstance.tPageLabel          = ttPage.tPageLabel
                   ttPageInstance.tLayoutName         = ttPage.tLayoutName
                   .
            /* Make sure that the "Page" link is correct.
             * IF a link doesn't exist, we create it later. */
            FIND FIRST ttLink WHERE
                       ttLink.tSourceId = dLocalSequence AND
                       ttLink.tLinkName = "Page":U
                       NO-ERROR.
            IF AVAILABLE ttLink THEN
                ASSIGN ttLink.tAction            = (IF ttLink.tAction EQ "NEW":U THEN "NEW":U ELSE "OLD":U)
                       ttLink.tTargetId          = 0
                       ttLink.tTargetObjectName  = "THIS-OBJECT"
                       ttLink.tSourceObjectName  = ttPageInstance.tObjectFilename
                       ttLink.tSourceId          = ttPageInstance.tLocalSequence
                       .
        END.    /* can't find folder object on page0 */
        ELSE
            ASSIGN lCleanedUp = CAN-FIND(FIRST ttPageInstance WHERE
                                               ttPageInstance.tObjectTypeCode = "SmartFolder":U AND
                                               ttPageInstance.tLocalSequence <> dLocalSequence ).

        /* Remove all other Folder object instances. */
        FOR EACH ttPageInstance WHERE
                 ttPageInstance.tObjectTypeCode = "SmartFolder":U AND
                 ttPageInstance.tLocalSequence <> dLocalSequence     :
            /* Remove the links that these objects use. */
            FOR EACH ttLink WHERE
                     ttLink.tSourceId = ttPageInstance.tLocalSequence OR
                     ttLink.tTargetId = ttPageInstance.tLocalSequence    :
                IF ttLink.tAction EQ "NEW":U THEN
                    DELETE ttLink.
                ELSE
                    ASSIGN ttLink.tAction = "DEL":U.
            END.    /* matching links. */

            /* Remove these objects.
             * If the SmartFolder is a template object, we can just remove it from the
             * container's page instances.                                            */
            IF ttPageInstance.tOIAction EQ "TEMPLATE":U OR ttPageInstance.tPOAction EQ "TEMPLATE":U THEN
                DELETE ttPageInstance.
            ELSE
                ASSIGN ttPageInstance.tOIAction = "DEL":U
                       ttPageInstance.tPOAction = "DEL":U
                       .
        END.    /* all other folder objects. */

        /* Clean up all extra Page links.
         * There should only be one link - between the (single) folder object and
         * the container (THIS-OBJECT).                                          */
        FOR EACH ttLink WHERE
                 ttLink.tLinkName = "Page":U     AND
                 ttLink.tSourceId <> dLocalSequence :
            IF ttLink.tAction EQ "NEW":U THEN
                DELETE ttLink.
            ELSE
                ASSIGN ttLink.tAction = "DEL":U.
        END.    /* delete extra Page links. */

        /* There should be either 1 or 0 Page links at this stage. 
         * Make sure a Page link exists between the folder object and the container. */
        IF NOT DYNAMIC-FUNCTION("HasPageLink":U) THEN
            RUN CreatePageLink (INPUT "{&ICF-FOLDER-OBJECT}":U, INPUT 0) NO-ERROR.        

        IF lCleanedUp THEN
        DO:
            ASSIGN glModified = YES.
            RUN showWarningMessages IN gshSessionManager (INPUT  "The SmartFolder Object was not on Page0, "
                                                               + "or multiple SmartFolder Objects were detected.~n"
                                                               + "This inconsistency has been corrected.",
                                                          INPUT  "INF",          /* error type */
                                                          INPUT  "Folder Object Cleanup" ).             /* error window title */
        END.    /* cleaned up */       
    END.    /* folder object exists */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createAllPages wWin 
FUNCTION createAllPages RETURNS LOGICAL
    ( INPUT pdContainerObj      AS DECIMAL,
      INPUT plTemplateRecord    AS LOGICAL  ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttPage            FOR ttPage.
    DEFINE BUFFER ryc_page          FOR ryc_page.
    DEFINE BUFFER ryc_layout        FOR ryc_layout.

    FOR EACH ryc_page WHERE
             ryc_page.container_smartObject_obj = pdContainerObj
             NO-LOCK:

        FIND FIRST ryc_layout WHERE
                   ryc_layout.layout_obj = ryc_page.layout_obj
                   NO-LOCK NO-ERROR.
        
        CREATE ttPage.
        ASSIGN ttPage.tAction         = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
               ttPage.tLocalSequence  = (RANDOM(2,17) * ETIME * -1) + giCnt
               ttPage.tPageObj        = ryc_page.page_obj
               ttPage.tIsPageZero     = NO
               ttPage.tLayoutObj      = ryc_page.layout_obj
               ttPage.tPageSequence   = ryc_page.page_sequence
               ttPage.tPageLabel      = ryc_page.page_label
               ttPage.tSecurityToken  = ryc_page.security_token
               ttPage.tEnableOnCreate = ryc_page.enable_on_create
               ttPage.tEnableOnModify = ryc_page.enable_on_modify
               ttPage.tEnableOnView   = ryc_page.enable_on_view
               giCnt                  = giCnt + 1
               .
        IF AVAILABLE ryc_layout THEN
            ASSIGN ttPage.tLayoutName      = ryc_layout.layout_name
                   ttPage.tLayoutType      = ryc_layout.layout_type
                   ttPage.tLayoutFilename  = ryc_layout.layout_filename
                   ttPage.tLayoutCode      = ryc_layout.layout_code
                   .
        RELEASE ttPage.

        /* Build the page instance information. */
        FIND FIRST ttPage WHERE 
                   ttPage.tPageSequence = ryc_page.page_sequence
                   NO-ERROR.
        IF AVAILABLE ttPage THEN
            DYNAMIC-FUNCTION("createPageNInstance":U,
                             INPUT pdContainerObj,
                             INPUT plTemplateRecord,
                             INPUT ttPage.tPageObj,
                             INPUT ttPage.tPageSequence,
                             INPUT ttPage.tPageLabel,
                             INPUT ttPage.tLayoutName,
                             INPUT ttPage.tLocalSequence,
                             INPUT ttPage.tIsPageZero       ).

    END.    /* page */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createInstanceLinks wWin 
FUNCTION createInstanceLinks RETURNS LOGICAL
    ( INPUT pdContainerObj          AS DECIMAL,
      INPUT plTemplateRecord        AS LOGICAL,
      INPUT pdObjectInstanceObj     AS DECIMAL,
      INPUT pdObjectId              AS DECIMAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates links for a specific object instance.
    Notes:  * There may be cases where the same page template is applied to
              different pages. In this case, we need to create all the links
              as many times as the page template is applied. If both the source
              and target object names have been populated, we assume that we 
              are dealing with a new set of links.              
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cObjectFilename             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lCreateLink                 AS LOGICAL              NO-UNDO.

    DEFINE BUFFER ttLink                FOR ttLink.
    DEFINE BUFFER ryc_smartLink         FOR ryc_smartLink.
    DEFINE BUFFER rycoi                 FOR ryc_object_instance.
    DEFINE BUFFER rycso                 FOR ryc_smartObject.

    FOR EACH ryc_smartLink WHERE
             ryc_smartLink.container_smartObject_obj = pdContainerObj AND
             ( ryc_smartLink.source_object_instance_obj = pdObjectInstanceObj OR
               ryc_smartLink.target_object_instance_obj = pdObjectInstanceObj    )
             NO-LOCK:

        FIND FIRST ttLink WHERE
                   ttLink.tSourceInstanceObj = ryc_smartLink.source_object_instance_obj AND
                   ttLink.tLinkName          = ryc_smartLink.link_name                  AND
                   ttLink.tTargetInstanceObj = ryc_smartLink.target_object_instance_obj AND
                   ( ttLink.tSourceObjectName <> "":U OR
                     ttLink.tTargetObjectName <> "":U )
                   NO-ERROR.

        IF NOT AVAILABLE ttLink THEN
            ASSIGN lCreateLink = YES.
        ELSE
        DO:
            ASSIGN lCreateLink = NO.

            IF ryc_smartLink.source_object_instance_obj EQ pdObjectInstanceObj AND
               ttLink.tSourceObjectName                 NE "":U                THEN
                ASSIGN lCreateLink = YES.

            IF ryc_smartLink.target_object_instance_obj EQ pdObjectInstanceObj AND
               ttLink.tTargetObjectName                 NE "":U                THEN
                ASSIGN lCreateLink = YES.
        END.    /* avail ttLink */

        IF lCreateLink THEN
        DO:
            CREATE ttLink.
            ASSIGN ttLink.tLinkName          = ryc_smartLink.link_name
                   ttLink.tAction            = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
                   ttLink.tLinkObj           = ryc_smartLink.smartLink_obj
                   ttLink.tSourceInstanceObj = ryc_smartLink.source_object_instance_obj
                   ttLink.tTargetInstanceObj = ryc_smartLink.target_object_instance_obj
                   .
        END.    /* create link */

        IF ( ttLink.tSourceObjectName EQ "":U AND ryc_smartLink.source_object_instance_obj EQ pdObjectInstanceObj ) OR
           ( ttLink.tTargetObjectName EQ "":U AND ryc_smartLink.target_object_instance_obj EQ pdObjectInstanceObj ) THEN
        DO:
            FIND FIRST rycoi WHERE
                       rycoi.object_instance_obj = pdObjectInstanceObj
                       NO-LOCK NO-ERROR.
            IF AVAILABLE rycoi THEN
            DO:
                FIND FIRST rycso WHERE
                           rycso.smartObject_obj = rycoi.smartObject_obj
                           NO-LOCK NO-ERROR.
                IF AVAILABLE rycso THEN
                    ASSIGN cObjectFilename = rycso.object_filename.
                ELSE
                    ASSIGN cObjectFilename = "<<Object Not Found>>".
            END.    /* avail source rycoi */
            ELSE
                ASSIGN cObjectFilename = "THIS-OBJECT".

            IF ryc_smartLink.source_object_instance_obj EQ pdObjectInstanceObj THEN            
                ASSIGN ttLink.tSourceId          = pdObjectId
                       ttLink.tSourceObjectName  = cObjectFileName                       
                       .
            ELSE
                ASSIGN ttLink.tTargetId          = pdObjectId
                       ttLink.tTargetObjectName  = cObjectFileName
                       .
        END.    /* object names blank. */
    END.    /* links */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createPageNInstance wWin 
FUNCTION createPageNInstance RETURNS LOGICAL
    ( INPUT pdContainerObj      AS DECIMAL,
      INPUT plTemplateRecord    AS LOGICAL,
      INPUT pdPageObj           AS DECIMAL,
      INPUT piPageSequence      AS INTEGER,
      INPUT pcPageLabel         AS CHARACTER,
      INPUT pcLayoutName        AS CHARACTER,
      INPUT pdPageLocalSequence AS DECIMAL,
      INPUT plIsPageZero        AS LOGICAL      ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLocalSequence          AS INTEGER                  NO-UNDO.

    DEFINE BUFFER ryc_page_object       FOR ryc_page_object.
    DEFINE BUFFER ryc_object_instance   FOR ryc_object_instance.
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    DEFINE BUFFER gsc_object_type       FOR gsc_object_type.

    /* Get the page instance records. We must check for > 0 because
     * the Page0 page has an "obj" of -1. */
    IF NOT plIsPageZero THEN
    FOR EACH ryc_page_object WHERE
             ryc_page_object.container_smartObject_obj = pdContainerObj AND
             ryc_page_object.page_obj                  = pdPageObj
             NO-LOCK,
       EACH ryc_object_instance WHERE
            ryc_object_instance.object_instance_obj = ryc_page_object.object_instance_obj
            NO-LOCK,
      FIRST ryc_smartObject WHERE
            ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
            NO-LOCK,
      FIRST gsc_object_type WHERE
            gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
            NO-LOCK:

        CREATE ttPageInstance.
        ASSIGN ttPageInstance.tPOAction               = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
               ttPageInstance.tOIAction               = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
               ttPageInstance.tParentKey              = pdPageLocalSequence
               ttPageInstance.tLocalSequence          = (RANDOM(3,12) * ETIME * -1) + giCnt
               ttPageInstance.tPageLabel              = pcPageLabel
               ttPageInstance.tPageObjectObj          = ryc_page_object.page_object_obj
               ttPageInstance.tPageObjectSequence     = ryc_page_object.page_object_sequence
               ttPageInstance.tObjectInstanceObj      = ryc_page_object.object_instance_obj
               ttPageInstance.tTemplateObjectFilename = (IF plTemplateRecord THEN ryc_smartObject.object_filename ELSE "":U)
               ttPageInstance.tLayoutPosition         = ryc_object_instance.layout_position
               ttPageInstance.tLayoutName             = pcLayoutName
               ttPageInstance.tObjectFilename         = ryc_smartObject.object_filename
               ttPageInstance.tIsATemplateRecord      = plTemplateRecord
               ttPageInstance.tObjectTypeCode         = gsc_object_type.object_type_code
               giCnt                                  = giCnt + 1
               .
        ASSIGN ttPageInstance.tWindowTitleField          = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                            INPUT "WindowTitleField":U,
                                                                            INPUT ryc_smartObject.object_type_obj,
                                                                            INPUT ryc_smartObject.smartObject_obj,
                                                                            INPUT ryc_object_instance.object_instance_obj,
                                                                            INPUT ryc_object_instance.container_smartObject_obj)
               ttPageInstance.tForeignFields             = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                            INPUT "ForeignFields":U,
                                                                            INPUT ryc_smartObject.object_type_obj,
                                                                            INPUT ryc_smartObject.smartObject_obj,
                                                                            INPUT ryc_object_instance.object_instance_obj,
                                                                            INPUT ryc_object_instance.container_smartObject_obj)
               ttPageInstance.tLaunchContainer           = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                            INPUT "FolderWindowToLaunch":U,
                                                                            INPUT ryc_smartObject.object_type_obj,
                                                                            INPUT ryc_smartObject.smartObject_obj,
                                                                            INPUT ryc_object_instance.object_instance_obj,
                                                                            INPUT ryc_object_instance.container_smartObject_obj)
               ttPageInstance.tNavigationTargetName      = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                            INPUT "NavigationTargetName":U,
                                                                            INPUT ryc_smartObject.object_type_obj,
                                                                            INPUT ryc_smartObject.smartObject_obj,
                                                                            INPUT ryc_object_instance.object_instance_obj,
                                                                            INPUT ryc_object_instance.container_smartObject_obj)
               .
               
        IF ttPageInstance.tTemplateObjectFilename EQ "":U THEN
            ASSIGN ttPageInstance.tTemplateObjectFilename = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                             INPUT "TemplateObjectName":U,
                                                                             INPUT ryc_smartObject.object_type_obj,
                                                                             INPUT ryc_smartObject.smartObject_obj,
                                                                             INPUT ryc_object_instance.object_instance_obj,
                                                                             INPUT ryc_object_instance.container_smartObject_obj).

        /* Create Links for this instance. */
        DYNAMIC-FUNCTION("CreateInstanceLinks":U,
                         INPUT pdContainerObj,
                         INPUT plTemplateRecord,
                         INPUT ryc_object_instance.object_instance_obj,
                         INPUT ttPageInstance.tLocalSequence ).
    END.    /* page object */
    ELSE
    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.container_smartObject_obj = pdContainerObj AND
             NOT CAN-FIND(FIRST ryc_page_object WHERE
                                ryc_page_object.container_smartObject_obj = pdContainerObj AND
                                ryc_page_object.object_instance_obj       = ryc_object_instance.object_instance_obj )
             NO-LOCK,
       FIRST ryc_smartObject WHERE
             ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
             NO-LOCK,
      FIRST gsc_object_type WHERE
            gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
            NO-LOCK:
        CREATE ttPageInstance.
        ASSIGN ttPageInstance.tPOAction               = "ZERO":U
               ttPageInstance.tOIAction               = (IF plTemplateRecord THEN "TEMPLATE":U ELSE "OLD":U)
               ttPageInstance.tParentKey              = pdPageLocalSequence
               ttPageInstance.tLocalSequence          = (RANDOM(2,9) * -1 * ETIME) + giCnt
               iLocalSequence                         = iLocalSequence + 1
               ttPageInstance.tPageObjectSequence     = ( piPageSequence * 100 ) + iLocalSequence
               ttPageInstance.tPageLabel              = pcPageLabel
               ttPageInstance.tObjectInstanceObj      = ryc_object_instance.object_instance_obj
               ttPageInstance.tTemplateObjectFilename = (IF plTemplateRecord THEN ryc_smartObject.object_filename ELSE "":U)
               ttPageInstance.tLayoutPosition         = ryc_object_instance.layout_position
               ttPageInstance.tLayoutName             = pcLayoutName
               ttPageInstance.tObjectFilename         = ryc_smartObject.object_filename
               ttPageInstance.tIsATemplateRecord      = plTemplateRecord
               ttPageInstance.tObjectTypeCode         = gsc_object_type.object_type_code
               giCnt                                  = giCnt + 1
               .
        ASSIGN ttPageInstance.tWindowTitleField = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                   INPUT "WindowTitleField":U,
                                                                   INPUT ryc_smartObject.object_type_obj,
                                                                   INPUT ryc_smartObject.smartObject_obj,
                                                                   INPUT ryc_object_instance.object_instance_obj,
                                                                   INPUT ryc_object_instance.container_smartObject_obj)
               ttPageInstance.tForeignFields    = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                   INPUT "ForeignFields":U,
                                                                   INPUT ryc_smartObject.object_type_obj,
                                                                   INPUT ryc_smartObject.smartObject_obj,
                                                                   INPUT ryc_object_instance.object_instance_obj,
                                                                   INPUT ryc_object_instance.container_smartObject_obj)                
               ttPageInstance.tLaunchContainer  = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                   INPUT "FolderWindowToLaunch":U,
                                                                   INPUT ryc_smartObject.object_type_obj,
                                                                   INPUT ryc_smartObject.smartObject_obj,
                                                                   INPUT ryc_object_instance.object_instance_obj,
                                                                   INPUT ryc_object_instance.container_smartObject_obj)                
               ttPageInstance.tNavigationTargetName = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                       INPUT "NavigationTargetName":U,
                                                                       INPUT ryc_smartObject.object_type_obj,
                                                                       INPUT ryc_smartObject.smartObject_obj,
                                                                       INPUT ryc_object_instance.object_instance_obj,
                                                                       INPUT ryc_object_instance.container_smartObject_obj)
               .
        IF ttPageInstance.tTemplateObjectFilename EQ "":U THEN
            ASSIGN ttPageInstance.tTemplateObjectFilename = DYNAMIC-FUNCTION("getAttributeValue":U,
                                                                             INPUT "TemplateObjectName":U,
                                                                             INPUT ryc_smartObject.object_type_obj,
                                                                             INPUT ryc_smartObject.smartObject_obj,
                                                                             INPUT ryc_object_instance.object_instance_obj,
                                                                             INPUT ryc_object_instance.container_smartObject_obj).
        /* Create Links for this instance. */
        DYNAMIC-FUNCTION("CreateInstanceLinks":U,
                         INPUT pdContainerObj,
                         INPUT plTemplateRecord,
                         INPUT ryc_object_instance.object_instance_obj,
                         INPUT ttPageInstance.tLocalSequence ).
    END.    /* object instance */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValue wWin 
FUNCTION getAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeLabel            AS CHARACTER,
      INPUT pdObjectTypeObj             AS DECIMAL,
      INPUT pdSmartObjectObj            AS DECIMAL,
      INPUT pdObjectInstanceObj         AS DECIMAL,
      INPUT pdContainerSmartObjectObj   AS DECIMAL   ):      
/*------------------------------------------------------------------------------
  Purpose:  Returns attribute values.
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE cAttributeValue         AS CHARACTER                NO-UNDO.

    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    
    FIND FIRST ryc_attribute_value WHERE
               ryc_attribute_value.object_type_obj           = pdObjectTypeObj           AND
               ryc_attribute_value.smartobject_obj           = pdSmartObjectObj          AND
               ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj       AND
               ryc_attribute_value.container_smartobject_obj = pdContainerSmartObjectObj AND
               ryc_attribute_value.attribute_label           = pcAttributeLabel
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
        ASSIGN cAttributeValue = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                  INPUT ryc_attribute_value.attribute_type_TLA,
                                                  INPUT ryc_attribute_value.attribute_value).
    ELSE
        ASSIGN cAttributeValue = ?.

    RETURN cAttributeValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerType wWin 
FUNCTION getContainerType RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cObjectTypeCode         AS CHARACTER                NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN cObjectTypeCode = ENTRY(( coObjectType:LOOKUP(coObjectType:SCREEN-VALUE) * 2 ) - 1,
                                       coObjectType:LIST-ITEM-PAIRS,
                                       coObjectType:DELIMITER                                     )
               cObjectTypeCode = ENTRY(1, cObjectTypeCode , "//":U)
               NO-ERROR.
    END.    /* with frame ... */

    RETURN cObjectTypeCode.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceObjects wWin 
FUNCTION getInstanceObjects RETURNS CHARACTER
    ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the objects on this container.
    Notes:  * Assumes a CHR(3) delimiter.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cObjectNames        AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER ttPageInstance        FOR ttPageInstance.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN cObjectNames = "THIS-OBJECT":U
                            + FILL(" ":U, 15)
                            + " of type "
                            + DYNAMIC-FUNCTION("getContainerType":U)
                            + CHR(3) + STRING(0)
               NO-ERROR.

        FOR EACH ttPageInstance
                 NO-LOCK,
           FIRST ttPage WHERE
                 ttPage.tLocalSequence = ttPageInstance.tParentKey
                 NO-LOCK:
            ASSIGN cObjectNames = cObjectNames
                                + CHR(3)
                                + ttPageInstance.tObjectFilename
                                + FILL(" ":U, 15)
                                + " of type "       + ttPageInstance.tObjectTypeCode
                                + " is at  '"        + ttPageInstance.tLayoutPosition
                                + "' on page "       + STRING(ttPage.tPageSequence)
                                + CHR(3) + STRING(ttPageInstance.tLocalSequence)
                   NO-ERROR.
        END.    /* each page instance. */
    END.    /* with frame ... */

    RETURN cObjectNames.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrecid wWin 
FUNCTION getPrecid RETURNS RECID
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the AppBuilder design window _P recid for this Property Sheet.
    Notes:  
------------------------------------------------------------------------------*/

    RETURN pPrecid.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HasFolderObject wWin 
FUNCTION HasFolderObject RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether a folder object should be added to the container
            on Page0.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lHasFolder          AS LOGICAL                  NO-UNDO.

    DEFINE BUFFER ttPageInstance        FOR ttPageInstance.
    DEFINE BUFFER ttPage                FOR ttPage.

    FIND FIRST ttPage WHERE
               ttPage.tIsPageZero = NO      AND
               ttPage.tAction     <> "DEL":U
               NO-ERROR.
    IF AVAILABLE ttPage THEN
    DO:
        FIND FIRST ttPageInstance WHERE
                   ttPageInstance.tObjectTypeCode = "SmartFolder":U
                   NO-ERROR.
        ASSIGN lHasFolder = (AVAILABLE ttPageInstance).
    END.    /* available other page. */
    ELSE
        ASSIGN lHasFolder = YES.

    RETURN lHasFolder.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HasPageLink wWin 
FUNCTION HasPageLink RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether a "Page" link exists between THIS-OBJECT and the
            Folder Object.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lHasPageLink            AS LOGICAL                  NO-UNDO.

    DEFINE BUFFER ttPageInstance        FOR ttPageInstance.
    DEFINE BUFFER ttLink                FOR ttLink.

    FIND FIRST ttPageInstance WHERE
               ttPageInstance.tObjectTypeCode = "SmartFolder":U
               NO-ERROR.
    IF AVAILABLE ttPageInstance THEN
    DO:
        FIND FIRST ttLink WHERE
                   ttLink.tLinkName = "Page"                        AND
                   ttLInk.tSourceId = ttPageInstance.tLocalSequence AND
                   ttLink.tTargetId = 0                             AND
                   ttLink.tAction  <> "DEL":U
                   NO-ERROR.
        ASSIGN lHasPageLink = (AVAILABLE ttLink).
    END.    /* available other page. */
    ELSE
        ASSIGN lHasPageLink = YES.

    RETURN lHasPageLink.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isModified wWin 
FUNCTION isModified RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN glModified.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery wWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    ( INPUT pcBrowseName        AS CHARACTER,
      INPUT pcSubstituteList    AS CHARACTER   ) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSubstituteList     AS CHARACTER    EXTENT 9        NO-UNDO.
    DEFINE VARIABLE cBaseQuery          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iEntries            AS INTEGER                      NO-UNDO.

    DEFINE BUFFER ttLocalPage           FOR ttLocalPage.

    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = pcBrowseName
         NO-ERROR.
    IF AVAILABLE ttLocalPage THEN
    DO:
        /* Make the relevant substitutions. */
        ASSIGN iEntries = NUM-ENTRIES(pcSubstituteList, CHR(3)).

        IF iEntries GT 0 THEN ASSIGN cSubstituteList[1] = ENTRY(1, pcSubstituteList, CHR(3)).
        IF iEntries GT 1 THEN ASSIGN cSubstituteList[2] = ENTRY(2, pcSubstituteList, CHR(3)).
        IF iEntries GT 2 THEN ASSIGN cSubstituteList[3] = ENTRY(3, pcSubstituteList, CHR(3)).
        IF iEntries GT 3 THEN ASSIGN cSubstituteList[4] = ENTRY(4, pcSubstituteList, CHR(3)).
        IF iEntries GT 4 THEN ASSIGN cSubstituteList[5] = ENTRY(5, pcSubstituteList, CHR(3)).
        IF iEntries GT 5 THEN ASSIGN cSubstituteList[6] = ENTRY(6, pcSubstituteList, CHR(3)).
        IF iEntries GT 6 THEN ASSIGN cSubstituteList[7] = ENTRY(7, pcSubstituteList, CHR(3)).
        IF iEntries GT 7 THEN ASSIGN cSubstituteList[8] = ENTRY(8, pcSubstituteList, CHR(3)).
        IF iEntries GT 8 THEN ASSIGN cSubstituteList[9] = ENTRY(9, pcSubstituteList, CHR(3)).

        ASSIGN cBaseQuery = SUBSTITUTE(ttLocalPage.tBaseQuery,
                                       cSubstituteList[1],
                                       cSubstituteList[2],
                                       cSubstituteList[3],
                                       cSubstituteList[4],
                                       cSubstituteList[5],
                                       cSubstituteList[6],
                                       cSubstituteList[7],
                                       cSubstituteList[8],
                                       cSubstituteList[9]      ).

        /* Always reopen, in case the sort has changed. */
        ttLocalPage.tObjectQueryHandle:QUERY-PREPARE(cBaseQuery + ttLocalPage.tCurrentSort).

        IF ttLocalPage.tObjectQueryHandle:IS-OPEN THEN
            ttLocalPage.tObjectQueryHandle:QUERY-CLOSE().

        ttLocalPage.tObjectQueryHandle:QUERY-OPEN().

        APPLY "ENTRY":U TO ttLocalPage.tObjectHandle.
    END.    /* avail ttlocalpage */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION selectPage2 wWin 
FUNCTION selectPage2 RETURNS LOGICAL
    ( /**/ ) :
/*------------------------------------------------------------------------------
  Purpose:  Code to execute when Page 2 is chosen.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPageSequence           AS CHARACTER                NO-UNDO.

    DEFINE BUFFER ttLocalPage           FOR ttLocalPage.

    /* Get the current Page record. */
    FIND ttLocalPage WHERE
         ttLocalPage.tObjectName = "brPage":U.
    IF ttLocalPage.tObjectQueryHandle:NUM-RESULTS GT 0 THEN
       IF NOT ttLocalPage.tObjectHandle:SELECT-FOCUSED-ROW() THEN
           ttLocalPage.tObjectHandle:SELECT-ROW(1).    

    IF ttLocalPage.tObjectBufferHandle:AVAILABLE THEN
        ASSIGN cPageSequence = STRING(ttLocalPage.tKeyFieldHandle:BUFFER-VALUE).

    IF cPageSequence EQ "":U THEN
        ASSIGN cPageSequence = "?":U.

    DYNAMIC-FUNCTION("reopenBrowseQuery":U, INPUT "brPageInstance":U, INPUT cPageSequence).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION selectPage3 wWin 
FUNCTION selectPage3 RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h_containr3v) THEN
        DYNAMIC-FUNCTION("setInstanceObjects":U IN h_containr3v, INPUT DYNAMIC-FUNCTION("getInstanceObjects":U)).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

