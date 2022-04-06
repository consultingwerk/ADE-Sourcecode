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
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: ryvobprop.w

  Description:  Visual Object Builder Property sheet

  Purpose:      Used for assigning properties to dynamic objects

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   26/02/2002  Author:     Don Bulua

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       ryvobpropw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{src/adm2/globals.i}
{af/sup2/dynhlp.i}          /* Help File Preprocessor Directives         */

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

/* Super procedure library */
DEFINE VARIABLE ghProcLib           AS HANDLE   NO-UNDO.

/* Dynamic browse handle for attribute browse */
DEFINE VARIABLE ghBrowse            AS HANDLE   NO-UNDO.

/* Dynamic browse handle for event browse */
DEFINE VARIABLE ghEventBrowse       AS HANDLE   NO-UNDO.

/* Dynamic Query to support attribute browse */
DEFINE VARIABLE ghQuery             AS HANDLE     NO-UNDO.

/* Dynamic Query to support event browse */
DEFINE VARIABLE ghEventQuery        AS HANDLE     NO-UNDO.


DEFINE VARIABLE ghValueColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLabelColumn        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghResultColumn      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGroupColumn      AS HANDLE     NO-UNDO.

/* Flag to prevent the object combo-box from being refreshed  */
DEFINE VARIABLE glSkipObjectList    AS LOGICAL    NO-UNDO.

/* Store last attribute and result code and try to reposition to it when changing widgets */
DEFINE VARIABLE gcLastAttribute     AS CHARACTER  NO-UNDO INIT "".
DEFINE VARIABLE gcLastResultCode    AS CHARACTER  NO-UNDO.

/* Store last event and result code and try to reposition to it when changing widgets */
DEFINE VARIABLE gcLastEvent         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastEventResultCode AS CHARACTER  NO-UNDO.

/* The last focused-row # in the attribute browse used when repositioning to keep rewcord on same row*/
DEFINE VARIABLE giBrowseRow         AS INTEGER    NO-UNDO.

/* The last focused-row # in the event browse used when repositioning to keep rewcord on same row*/
DEFINE VARIABLE giEventBrowseRow    AS INTEGER    NO-UNDO.

DEFINE VARIABLE gcByClause          AS CHARACTER  NO-UNDO INIT " BY attrLabel BY resultcode":U.

DEFINE VARIABLE gcEventByClause     AS CHARACTER  NO-UNDO INIT " BY eventName BY resultcode":U.
                                    
DEFINE VARIABLE gcLastColumn        AS CHARACTER  NO-UNDO INIT "attrLabel ASC":U.
                                    
DEFINE VARIABLE gcLastEventColumn   AS CHARACTER  NO-UNDO INIT "eventName ASC":U.

DEFINE VARIABLE glRepositionQuery   AS LOGICAL    NO-UNDO INIT YES.

DEFINE VARIABLE glFilterOn          AS LOGICAL    NO-UNDO INIT NO.

DEFINE VARIABLE gcWhere             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventWhere        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcLabelWhere        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEventLabelWhere   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcResultWhere       AS CHARACTER  NO-UNDO INIT "resultCode=''":U.
DEFINE VARIABLE gcGroupWhere        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectNameList    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcManagerList AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcStartupGroupValue AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcResultCode         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glResultCodeDisabled AS LOGICAL    NO-UNDO.

&SCOPED-DEFINE FOLDER_ROW 4.48
&SCOPED-DEFINE FOLDER_COL 1.0

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
&Scoped-Define ENABLED-OBJECTS buExit coObject coClass buFilter ~
coFilterResult selLookup ToBox ToBoxEvent EdDescription buPushPin buDialog ~
buList buList-2 
&Scoped-Define DISPLAYED-OBJECTS fiContainer coObject coClass ~
coFilterResult selLookup ToBox ToBoxEvent EdDescription 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FormatField wiWin 
FUNCTION FormatField RETURNS CHARACTER
 ( pcDataType AS CHAR,
    pcValue    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttribute wiWin 
FUNCTION getAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBYClause wiWin 
FUNCTION getBYClause RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEvent wiWin 
FUNCTION getEvent RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagers wiWin 
FUNCTION getManagers RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextItem wiWin 
FUNCTION getNextItem RETURNS CHARACTER
  ( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextItemPair wiWin 
FUNCTION getNextItemPair RETURNS CHARACTER
 ( pcListItemPair AS CHAR,
    pcValue       AS CHAR,
    pcDelim       AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrevItem wiWin 
FUNCTION getPrevItem RETURNS CHARACTER
 ( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrevItemPair wiWin 
FUNCTION getPrevItemPair RETURNS CHARACTER
( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProcLib wiWin 
FUNCTION getProcLib RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRepositionQuery wiWin 
FUNCTION getRepositionQuery RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResultCode wiWin 
FUNCTION getResultCode RETURNS CHARACTER
  ( OUTPUT plResultCodeDisabled AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow wiWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setByClause wiWin 
FUNCTION setByClause RETURNS LOGICAL
  (  pcTable AS CHAR,
     pcByClause AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerLabel wiWin 
FUNCTION setContainerLabel RETURNS LOGICAL
  ( pcNewLabel AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectList wiWin 
FUNCTION setObjectList RETURNS LOGICAL
  ( phCallingProc AS HANDLE,
    pcContainerName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRepositionQuery wiWin 
FUNCTION setRepositionQuery RETURNS LOGICAL
  ( plRepositionQuery AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResultCode wiWin 
FUNCTION setResultCode RETURNS LOGICAL
  ( pcResultCode AS CHAR,
    plDisabled   AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ValidateField wiWin 
FUNCTION ValidateField RETURNS LOGICAL
  ( pcDataType AS CHAR,
    pcValue    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coFilterGroup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Group" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 TOOLTIP "Enter a value to filter on the group name" NO-UNDO.

DEFINE VARIABLE fiFilterAttribute AS CHARACTER FORMAT "X(256)":U 
     LABEL "Attribute" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 TOOLTIP "Enter a value to filter on the attribute name" NO-UNDO.

DEFINE VARIABLE fiFilterEvent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Event" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Enter a value to filter on the event name" NO-UNDO.

DEFINE VARIABLE fiFilterLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Filter" 
      VIEW-AS TEXT 
     SIZE 5.2 BY .71 NO-UNDO.

DEFINE RECTANGLE Rect-Filter
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 1.67.

DEFINE BUTTON buDialog  NO-FOCUS
     LABEL "..." 
     SIZE 3.2 BY .76
     BGCOLOR 8 .

DEFINE BUTTON buExit  NO-FOCUS
     LABEL "Close" 
     SIZE 7 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buFilter 
     IMAGE-UP FILE "ry/img/showfilter.gif":U
     LABEL "Show &Filter >>" 
     SIZE 5.2 BY 1.05 TOOLTIP "Display/Hide filter fields"
     BGCOLOR 8 .

DEFINE BUTTON buFilterClear 
     IMAGE-UP FILE "ry/img/funnel.gif":U
     LABEL "" 
     SIZE 5.2 BY 1.05 TOOLTIP "Clear filter"
     BGCOLOR 8 .

DEFINE BUTTON buList 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS
     LABEL "" 
     SIZE 3.6 BY .76
     BGCOLOR 8 .

DEFINE BUTTON buList-2 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS
     LABEL "" 
     SIZE 3.6 BY .76
     BGCOLOR 8 .

DEFINE BUTTON buPushPin 
     IMAGE-UP FILE "ry/img/pushin.gif":U NO-FOCUS
     LABEL "" 
     SIZE 5.2 BY 1.05 TOOLTIP "Toggle on/off to change window on-top setting"
     BGCOLOR 8 .

DEFINE VARIABLE coClass AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Class" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 TOOLTIP "The class associated with this object" NO-UNDO.

DEFINE VARIABLE coFilterResult AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Result Code" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 15 BY 1 TOOLTIP "The customization result code" NO-UNDO.

DEFINE VARIABLE coObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Object" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.8 BY 1 TOOLTIP "The selected object name for the specified container" NO-UNDO.

DEFINE VARIABLE EdDescription AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 93 BY 3.1 NO-UNDO.

DEFINE VARIABLE fiContainer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "The container name of the selected object" NO-UNDO.

DEFINE VARIABLE selLookup AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 24 BY 2.05
     FONT 3 NO-UNDO.

DEFINE VARIABLE ToBox AS LOGICAL INITIAL NO 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .81 TOOLTIP "If checked, the entered value is overridding the default value" NO-UNDO.

DEFINE VARIABLE ToBoxEvent AS LOGICAL INITIAL NO 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .81 TOOLTIP "If checked, the entered event values override the default values" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiContainer AT ROW 1 COL 15.4 COLON-ALIGNED
     buExit AT ROW 1 COL 74
     coObject AT ROW 2.19 COL 15.4 COLON-ALIGNED
     coClass AT ROW 2.19 COL 48.6 COLON-ALIGNED
     buFilter AT ROW 3.33 COL 70.2 NO-TAB-STOP 
     buFilterClear AT ROW 3.33 COL 75
     coFilterResult AT ROW 3.38 COL 15.4 COLON-ALIGNED
     selLookup AT ROW 10.52 COL 17 NO-LABEL NO-TAB-STOP 
     ToBox AT ROW 10.76 COL 57 NO-TAB-STOP 
     ToBoxEvent AT ROW 11.48 COL 57 NO-TAB-STOP 
     EdDescription AT ROW 16.71 COL 3 NO-LABEL NO-TAB-STOP 
     buPushPin AT ROW 1 COL 68
     buDialog AT ROW 10.76 COL 63 NO-TAB-STOP 
     buList AT ROW 9.81 COL 65 NO-TAB-STOP 
     buList-2 AT ROW 10.76 COL 70 NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.4 BY 20.14.

DEFINE FRAME frameFilter
     fiFilterAttribute AT ROW 1.48 COL 5
     fiFilterEvent AT ROW 1.48 COL 45 COLON-ALIGNED
     coFilterGroup AT ROW 1.48 COL 64
     fiFilterLabel AT ROW 1 COL 2.6 NO-LABEL
     Rect-Filter AT ROW 1.24 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 6
         SIZE 100 BY 2.14.


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
         TITLE              = "Dynamic Properties"
         HEIGHT             = 20.14
         WIDTH              = 103.4
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = NO
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME frameFilter:FRAME = FRAME frMain:HANDLE.

/* SETTINGS FOR FRAME frameFilter
                                                                        */
/* SETTINGS FOR COMBO-BOX coFilterGroup IN FRAME frameFilter
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFilterAttribute IN FRAME frameFilter
   ALIGN-L                                                              */
ASSIGN 
       fiFilterEvent:HIDDEN IN FRAME frameFilter           = TRUE.

/* SETTINGS FOR FILL-IN fiFilterLabel IN FRAME frameFilter
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       buDialog:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR BUTTON buFilterClear IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buList:HIDDEN IN FRAME frMain           = TRUE.

ASSIGN 
       buList-2:HIDDEN IN FRAME frMain           = TRUE.

ASSIGN 
       buPushPin:PRIVATE-DATA IN FRAME frMain     = 
                "IN".

ASSIGN 
       EdDescription:RETURN-INSERTED IN FRAME frMain  = TRUE
       EdDescription:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiContainer IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiContainer:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       selLookup:HIDDEN IN FRAME frMain           = TRUE.

ASSIGN 
       ToBox:HIDDEN IN FRAME frMain           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Dynamic Properties */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON LEAVE OF wiWin /* Dynamic Properties */
DO:
 /* Set the value upon leaving the window */
  RUN rowLeave IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Dynamic Properties */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
   DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.

   {get currentPage iCurrentPage}.
   IF iCurrentPage = 1 THEN
     RUN rowLeave IN THIS-PROCEDURE.
   ELSE
     RUN rowLeaveEvent IN THIS-PROCEDURE.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-RESIZED OF wiWin /* Dynamic Properties */
DO:
  /* Resize the fill-ins proportionally as well as the browse,
     and resize the Value column */
  RUN resizeObject IN THIS-PROCEDURE (INPUT {&WINDOW-NAME}:HEIGHT,
                                      INPUT {&WINDOW-NAME}:WIDTH,
                                      INPUT YES   ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain wiWin
ON HELP OF FRAME frMain
DO:
    /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Dynamic_Property_Sheet}  , "").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDialog wiWin
ON CHOOSE OF buDialog IN FRAME frMain /* ... */
DO:
  /* Run the dialog lookup */
  RUN dialogLookup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buExit wiWin
ON CHOOSE OF buExit IN FRAME frMain /* Close */
DO:
  APPLY "WINDOW-CLOSE":U TO wiWin.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFilter wiWin
ON CHOOSE OF buFilter IN FRAME frMain /* Show Filter >> */
DO:
  /* Display the filter fields and resize based on global var glFilterOn */
  glFilterOn = NOT glFilterOn.

  /* Lock the window to avoid flickering */
  lockWindow(TRUE).

  buFilter:LOAD-IMAGE(IF glFilterOn THEN "ry/img/hidefilter.gif":U ELSE "ry/img/showfilter.gif":U).
  buFilter:MOVE-TO-TOP().
  
  RUN resizeObject (INPUT {&WINDOW-NAME}:HEIGHT,
                    INPUT {&WINDOW-NAME}:WIDTH, 
                    INPUT NO).
  IF glFilterOn THEN
     APPLY "ENTRY":U TO fiFilterAttribute IN FRAME frameFilter.
  ELSE
     APPLY "ENTRY":U TO SELF.
  
  /* Unlocking window as operation is finished */
  lockWindow(FALSE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFilterClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFilterClear wiWin
ON CHOOSE OF buFilterClear IN FRAME frMain
DO:
  /* Clear any filter field information */
  DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
  
  {get CurrentPage iCurrentPage}.

  buFilterClear:LOAD-IMAGE("ry/img/funnel.gif":U).

  IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
  DO:
    fiFilterAttribute:SCREEN-VALUE IN FRAME frameFilter = "".
    RUN assignFilterString("attrLabel=<ALL>":U). /* Build the filter query string */
    ASSIGN gcStartupGroupValue = "<ALL>" 
    coFilterGroup:SCREEN-VALUE = "<ALL>" NO-ERROR.
    RUN assignFilterString("attrGroup=<ALL>":U ).
  END.
  ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U THEN 
  DO:
    fiFilterEvent:SCREEN-VALUE = "".
    RUN assignFilterString("eventName=<ALL>":U). /* Build the filter query string */
  END.
  
  RUN refreshQuery ( INPUT WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                     INPUT fiContainer:PRIVATE-DATA IN FRAME {&FRAME-NAME},
                     INPUT fiContainer:SCREEN-VALUE  ,
                     INPUT coObject:PRIVATE-DATA).
  SELF:SENSITIVE = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buList wiWin
ON CHOOSE OF buList IN FRAME frMain
DO:
   /* If selection button is selected, display the selection list if not visible */
   IF SelLookup:VISIBLE THEN
      SelLookup:VISIBLE = FALSE.
   ELSE
     RUN SelectionListPlacement.
   SelLookup:PRIVATE-DATA = SELF:NAME.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buList-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buList-2 wiWin
ON CHOOSE OF buList-2 IN FRAME frMain
DO:
   /* If selection button is selected, display the selection list if not visible */
   IF SelLookup:VISIBLE THEN
      SelLookup:VISIBLE = FALSE.
   ELSE
     RUN SelectionListPlacement.
   SelLookup:PRIVATE-DATA = SELF:NAME.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buPushPin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buPushPin wiWin
ON CHOOSE OF buPushPin IN FRAME frMain
DO:
  ASSIGN SELF:PRIVATE-DATA = IF SELF:PRIVATE-DATA = "IN":U 
                             THEN "OUT":U 
                             ELSE "IN":U.
  IF SELF:PRIVATE-DATA = "IN":U THEN DO:
     SELF:LOAD-IMAGE("ry/img/pushin.gif":U).
     {&WINDOW-NAME}:TOP-ONLY  = TRUE. 
  END.
  ELSE DO:
     SELF:LOAD-IMAGE("ry/img/pushout.gif":U).
     {&WINDOW-NAME}:TOP-ONLY  = FALSE. 
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coClass
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coClass wiWin
ON ANY-KEY OF coClass IN FRAME frMain /* Class */
DO:
  DEFINE VARIABLE cOriginalValue AS CHARACTER  NO-UNDO.
  cOriginalValue = SELF:SCREEN-VALUE.

  RUN ApplyMnemonic.
  IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN" OR 
         KEYFUNCTION(LASTKEY) = "CURSOR-RIGHT"   THEN
     SELF:SCREEN-VALUE = getNextItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER).
  ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP" OR 
         KEYFUNCTION(LASTKEY) = "CURSOR-LEFT"   THEN
     SELF:SCREEN-VALUE = getPrevItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER).
  
  IF cOriginalValue <> SELF:SCREEN-VALUE THEN
    APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coClass wiWin
ON VALUE-CHANGED OF coClass IN FRAME frMain /* Class */
DO:
   PUBLISH 'PropertyChangedClass':U FROM ghProcLib
      (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
       fiContainer:PRIVATE-DATA,
       coObject:SCREEN-VALUE,
       SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameFilter
&Scoped-define SELF-NAME coFilterGroup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterGroup wiWin
ON ANY-KEY OF coFilterGroup IN FRAME frameFilter /* Group */
DO:
  DEFINE VARIABLE cNewValue      AS CHARACTER  NO-UNDO.
  
  RUN ApplyMnemonic.
  IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN":U 
      OR KEYFUNCTION(LASTKEY) = "CURSOR-RIGHT":U   THEN
     ASSIGN cNewValue = getNextItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER).
            
  ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP":U 
           OR KEYFUNCTION(LASTKEY) = "CURSOR-LEFT":U   THEN
    ASSIGN cNewValue = TRIM(getPrevItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER)).
     
  IF cNewValue <> SELF:SCREEN-VALUE THEN
  DO:
     ASSIGN SELF:SCREEN-VALUE = cNewValue.
     APPLY "VALUE-CHANGED":U TO SELF.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterGroup wiWin
ON VALUE-CHANGED OF coFilterGroup IN FRAME frameFilter /* Group */
DO:
  /* Rebuild the filter query string and refresh the browse query */
  glSkipObjectList = YES. 
  RUN ApplyFilter ("attrGroup=":U + SELF:SCREEN-VALUE).
  glSkipObjectList = NO. 
  RUN setFilterClear.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME coFilterResult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterResult wiWin
ON ANY-KEY OF coFilterResult IN FRAME frMain /* Result Code */
DO:
  
  DEFINE VARIABLE cNewValue      AS CHARACTER  NO-UNDO.
  
  RUN ApplyMnemonic.
  IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN":U 
      OR KEYFUNCTION(LASTKEY) = "CURSOR-RIGHT":U   THEN
     ASSIGN cNewValue = getNextItemPair(SELF:LIST-ITEM-PAIRS,SELF:SCREEN-VALUE,SELF:DELIMITER)
            cNewValue = IF cNewValue = "" THEN  " ":U ELSE cNewValue.
  ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP":U 
           OR KEYFUNCTION(LASTKEY) = "CURSOR-LEFT":U   THEN
    ASSIGN cNewValue = TRIM(getPrevItemPair(SELF:LIST-ITEM-PAIRS,SELF:SCREEN-VALUE,SELF:DELIMITER))
           cNewValue = IF cNewValue = "":U THEN  " ":U ELSE cNewValue.
     
  IF cNewValue <> SELF:SCREEN-VALUE THEN
  DO:
     ASSIGN SELF:SCREEN-VALUE = cNewValue.
     APPLY "VALUE-CHANGED":U TO SELF.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterResult wiWin
ON VALUE-CHANGED OF coFilterResult IN FRAME frMain /* Result Code */
DO:
/* Rebuild the filter query string and refresh the browse query */
   glSkipObjectList = YES. 
   setResultCode(SELF:SCREEN-VALUE,NO).
   RUN ApplyFilter ("resultCode=":U + SELF:SCREEN-VALUE).
   glSkipObjectList = NO. 
   RUN setFilterClear.
   glSkipObjectList = NO. 

   PUBLISH 'PropertyChangedResult':U FROM ghProcLib
      (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
       fiContainer:PRIVATE-DATA,
       coObject:SCREEN-VALUE,
       SELF:SCREEN-VALUE).
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObject wiWin
ON ANY-KEY OF coObject IN FRAME frMain /* Object */
DO:
  DEFINE VARIABLE cOriginalValue AS CHARACTER  NO-UNDO.
  cOriginalValue = SELF:SCREEN-VALUE.
  RUN ApplyMnemonic.

  IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN" OR 
         KEYFUNCTION(LASTKEY) = "CURSOR-RIGHT"   THEN
     SELF:SCREEN-VALUE = getNextItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER).
  ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP" OR 
         KEYFUNCTION(LASTKEY) = "CURSOR-LEFT"   THEN
     SELF:SCREEN-VALUE = getPrevItem(SELF:LIST-ITEMS,SELF:SCREEN-VALUE,SELF:DELIMITER).
     
  IF cOriginalValue <> SELF:SCREEN-VALUE THEN
     APPLY "VALUE-CHANGED":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObject wiWin
ON VALUE-CHANGED OF coObject IN FRAME frMain /* Object */
DO:
/* Re-display those attributes for the selected object. */
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.

/* This flag prevents the combo-box lists from being rebuilt in procedure refreshQuery */
  ASSIGN coFilterResult:PRIVATE-DATA = SELF:SCREEN-VALUE
         cObjectName           = IF gcObjectNameList > "" 
                                 THEN ENTRY(SELF:LOOKUP(SELF:SCREEN-VALUE), gcObjectNameList,CHR(3)) 
                                 ELSE SELF:SCREEN-VALUE
         NO-ERROR.

   /* Send out event notification to calling procedure */
  PUBLISH 'PropertyChangedObject':U FROM ghProcLib
     (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
      fiContainer:PRIVATE-DATA,
      cObjectName).
  
  IF VALID-HANDLE(ghProcLib) THEN 
    RUN displayProperties IN ghProcLib (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                                        fiContainer:PRIVATE-DATA,
                                        cObjectName,
                                        ?,?,?). /* rebuild temp table for specified widget */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameFilter
&Scoped-define SELF-NAME fiFilterAttribute
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFilterAttribute wiWin
ON ANY-KEY OF fiFilterAttribute IN FRAME frameFilter /* Attribute */
DO:
 /* Rebuild the filter query string and refresh the browse query */
   IF LASTKEY = 3 THEN DO:
      CLIPBOARD:VALUE = SELF:SELECTION-TEXT.
      RETURN NO-APPLY.
   END.
   glSkipObjectList = YES. 
   APPLY LASTKEY.
   
   RUN ApplyFilter ("attrLabel=":U + SELF:SCREEN-VALUE).
   glSkipObjectList = NO. 
   
   RUN setFilterClear.
   
   RUN applyMnemonic.
   
   RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFilterEvent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFilterEvent wiWin
ON ANY-KEY OF fiFilterEvent IN FRAME frameFilter /* Event */
DO:
  /* Rebuild the filter query string and refresh the browse query */
   glSkipObjectList = YES. 
   APPLY LASTKEY.
   
   RUN ApplyFilter ("eventName=":U + SELF:SCREEN-VALUE).
   glSkipObjectList = NO. 
   
   RUN setFilterClear.
   
   RUN applyMnemonic.
   RETURN NO-APPLY.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME selLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL selLookup wiWin
ON RETURN OF selLookup IN FRAME frMain
DO:
  APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL selLookup wiWin
ON VALUE-CHANGED OF selLookup IN FRAME frMain
DO:
/* Upon changing the selection in the selction list, set the value in browse */
  DEFINE VARIABLE cOriginalValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage   AS INTEGER  NO-UNDO.
  DEFINE VARIABLE hType          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE     NO-UNDO.
  
  {get CurrentPage iCurrentPage}.
  
/* Since the selection list is emulating a combo-box, only apply change when the
   user either clicks on an item on presses enter. Not when using cursor */
  IF LAST-EVENT:LABEL = "VALUE-CHANGED":U 
     OR LAST-EVENT:LABEL = "ENTER":U THEN
  DO:
    IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes" THEN
    DO:
      ASSIGN 
        cOriginalValue             = ghValueColumn:SCREEN-VALUE
        ghValueColumn:SCREEN-VALUE = SELF:SCREEN-VALUE
        SelLookup:VISIBLE          = FALSE
        NO-ERROR.
      
      IF cOriginalValue <> SELF:SCREEN-VALUE THEN
      DO:
        ASSIGN ToBOX:CHECKED = TRUE.
        RUN rowLeave IN THIS-PROCEDURE. 
      END.
      APPLY "ENTRY":U TO ghBrowse.
    END.
    ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U THEN
    DO:
       ASSIGN hType   = ghEventBrowse:GET-BROWSE-COLUMN(5)
              hTarget = ghEventBrowse:GET-BROWSE-COLUMN(6).
       IF SELF:PRIVATE-DATA = "buList-2":U THEN
          ASSIGN  cOriginalValue       = hTarget:SCREEN-VALUE
                  hTarget:SCREEN-VALUE = SELF:SCREEN-VALUE.
       ELSE
          ASSIGN  cOriginalValue       = hType:SCREEN-VALUE
                  hType:SCREEN-VALUE = SELF:SCREEN-VALUE.
       ASSIGN SelLookup:VISIBLE          = FALSE.
       IF cOriginalValue <> SELF:SCREEN-VALUE THEN
       DO:
         ASSIGN ToBOXEvent:CHECKED = TRUE.
         RUN rowLeaveEvent IN THIS-PROCEDURE. 
       END.
       IF SELF:PRIVATE-DATA = "buList-2":U THEN
          APPLY "ENTRY":U TO hTarget.
       ELSE
          APPLY "ENTRY":U TO hType.

    END.
  END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBox
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBox wiWin
ON VALUE-CHANGED OF ToBox IN FRAME frMain
DO:
   /* Set the override value */
   RUN RowLeave IN THIS-PROCEDURE.
   SELF:MODIFIED = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBoxEvent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxEvent wiWin
ON VALUE-CHANGED OF ToBoxEvent IN FRAME frMain
DO:
   /* Set the override value */
   RUN RowLeaveEvent IN THIS-PROCEDURE.
   SELF:MODIFIED = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */


/* Load  procedure library if not called from procedure library*/
IF SOURCE-PROCEDURE:FILE-NAME <> "ry/prc/ryvobplipp.p" THEN
DO:
  ghProcLib = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(ghProcLib) AND ghProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
    ghProcLib = ghProcLib:NEXT-SIBLING.
  END.
  IF NOT VALID-HANDLE(ghProcLib) THEN
    RUN ry/prc/ryvobplipp.p PERSISTENT SET ghProcLib NO-ERROR.
  DYNAMIC-FUNC("setPropSheet":U IN ghProcLib, THIS-PROCEDURE).
END.
ELSE
   ASSIGN ghProcLib = SOURCE-PROCEDURE.


{SET HideonInit TRUE}.


/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* Set the min width and size */
ASSIGN {&WINDOW-NAME}:MIN-HEIGHT = 11
       {&WINDOW-NAME}:MIN-WIDTH  = 50.

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
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + '&Attributes|&Events' + 'TabFGcolor':U + 'Default|Default' + 'TabBGcolor':U + 'Default|Default' + 'TabINColor':U + 'GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '' + 'TabHidden':U + 'no|no' + 'EnableStates':U + 'All|All' + 'DisableStates':U + 'All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '8' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'Tabs' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 4.57 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 15.00 , 102.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             coFilterResult:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage EQ 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anyBrowseKey wiWin 
PROCEDURE anyBrowseKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Called from ANY-KEY trigger of Attribute browse 
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
DEFINE VARIABLE hType        AS HANDLE     NO-UNDO.

{Get CurrentPage iCurrentPage}.

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  /* If space bar is selected, display selection list */
  IF LASTKEY = 32  AND buList:VISIBLE IN FRAME {&FRAME-NAME} THEN
     APPLY "CHOOSE":U TO buList.
  /* IF F4 is slected, display dialog */
  ELSE IF LASTKEY = 304 AND buDialog:VISIBLE THEN
     APPLY "CHOOSE":U TO buDialog.
  ELSE
    RUN applyMnemonic.
END.
ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U THEN 
DO: /* Page 2 Event Browse0*/
 IF LASTKEY = 32  AND buList:VISIBLE IN FRAME {&FRAME-NAME} AND SELF:NAME = "EventType":U THEN
   APPLY "CHOOSE":U TO buList.
 ELSE IF LASTKEY = 32  AND buList:VISIBLE IN FRAME {&FRAME-NAME} AND SELF:NAME = "EventTarget":U THEN
   APPLY "CHOOSE":U TO buList-2.
 ELSE IF KEYFUNCTION(LASTKEY) = "TAB":U OR   KEYFUNCTION(LASTKEY) = "BACK-TAB":U 
      OR KEYFUNCTION(LASTKEY) = "CURSOR-UP":U OR KEYFUNCTION(LASTKEY) = "CURSOR-DOWN":U THEN
    RETURN.
 ELSE IF SELF:NAME = "EventType":U AND (KEYFUNCTION(LASTKEY) = "P" OR  KEYFUNCTION(LASTKEY) = "R") THEN
 DO:
   ASSIGN hType   = ghEventBrowse:GET-BROWSE-COLUMN(5)
          hType:SCREEN-VALUE = IF KEYFUNCTION(LASTKEY) = "P" THEN "PUB":U ELSE "RUN":U
          ToBOXEvent:CHECKED = TRUE.
    RUN rowLeaveEvent IN THIS-PROCEDURE. 
 END.
 ELSE
   RUN applyMnemonic.

 RETURN NO-APPLY.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilter wiWin 
PROCEDURE applyFilter :
/*------------------------------------------------------------------------------
  Purpose:    Updates the filter query string and refreshes the query.
  Parameters:  pcFilter Filter string specifying the filtered field and
                        the value in the form field=Value
               i.e. attrLabel
  Notes:       Called from the value-changed triggers of the group and result combo-box, 
               and from the ANy-Key trigger of the attribute label filter fill-in
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilter AS CHARACTER  NO-UNDO.

  RUN assignFilterString(pcFilter).
  RUN refreshQuery ( INPUT WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                     INPUT fiContainer:PRIVATE-DATA IN FRAME {&FRAME-NAME},
                     INPUT fiContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                     INPUT coObject:PRIVATE-DATA).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyMnemonic wiWin 
PROCEDURE applyMnemonic :
/*------------------------------------------------------------------------------
  Purpose:     Allows the folder mnemonics to be captured along with 
               other mnemonics for other fields
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  IF LASTKEY = 1094 THEN     /* Alt+F */
     APPLY "CHOOSE":U TO buFilter.
  ELSE IF LASTKEY=1103 THEN   /* Alt+O */
     APPLY "ENTRY":U TO coObject.
  ELSE IF LASTKEY = 1091 THEN /* Alt+C */
     APPLY "ENTRY":U TO coClass.
  ELSE IF LASTKEY = 1089 THEN /* Alt+A */
     RUN selectPage (1).
  ELSE IF LASTKEY = 1093 THEN /* Alt+O */
     RUN selectPage (2).
  ELSE IF KEYFUNCTION(LASTKEY) = "HELP":U THEN DO:
     RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Dynamic_Property_Sheet}  , "").
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFilterString wiWin 
PROCEDURE assignFilterString :
/*------------------------------------------------------------------------------
  Purpose:    Updates the query string variable gcWhere
  Parameters: pcFilter  String defining the field and value in the form 
                        <field>=<value> 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFilter AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEntry AS CHARACTER  NO-UNDO.

ASSIGN cField = TRIM(ENTRY(1,pcFilter,"="))
       cValue = TRIM(ENTRY(2,pcFilter,"=")).


CASE cField:
   WHEN "attrLabel":U THEN
      gcLabelWhere = IF cValue = "<ALL>" THEN "" ELSE "attrLabel BEGINS '" + cValue + "'".

   WHEN "eventName":U THEN
      gcEventLabelWhere= IF cValue = "<ALL>" THEN "" ELSE "eventName BEGINS '" + cValue + "'".

   WHEN "resultCode":U THEN 
      gcResultWhere = IF cValue = "<ALL>" THEN "" 
                      ELSE IF cValue = "<DEFAULT>":U THEN "ResultCode=''"
                      ELSE "resultCode='" + cValue + "'".

   WHEN "attrGroup":U THEN
      gcGroupWhere = IF cValue = "<ALL>" THEN "" ELSE "attrGroup='" + cValue + "'".
END CASE.
ASSIGN gcWhere = gcLabelWhere + (IF gcLabelWhere > "" AND gcResultWhere > "" THEN " AND ":U ELSE "")
                              + gcResultWhere 
       gcWhere = (IF gcWhere > "" AND gcGroupWhere > "" THEN gcWhere + " AND ":U ELSE gcWhere) 
                              + gcGroupWhere
       gcEventWhere = gcEventLabelWhere + (IF gcEventLabelWhere > "" AND gcResultWhere > "" THEN " AND ":U ELSE "")
                              + gcResultWhere 
       NO-ERROR.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse wiWin 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the property browse widget
  Parameters:  <none>
  Notes:       Called form initializeObject
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBufferTable  AS HANDLE     NO-UNDO.
DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hBufferField  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hValueField   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTargetField  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTypeField    AS HANDLE     NO-UNDO.

/* ATTRIBUTES */
/* Get the temp table buffer handle for Attributes */
ASSIGN hBufferTable = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedAttribute":U).

/* Construct query for temp table 'ttSelectedAttribute' */
CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(hBufferTable).
/* Create attribute  browse widget */
CREATE BROWSE ghbrowse
     ASSIGN FRAME                  = FRAME {&FRAME-NAME}:handle
            ROW                    = 1
            COL                    = 1.0
            SEPARATORS             = TRUE
            ROW-MARKERS            = FALSE
            EXPANDABLE             = TRUE
            COLUMN-RESIZABLE       = TRUE
            ALLOW-COLUMN-SEARCHING = TRUE
            READ-ONLY              = FALSE
            QUERY                  = ghQuery
            SENSITIVE              = TRUE
            VISIBLE                = TRUE
      /* Set procedures to handle browser events */
      TRIGGERS:   
        ON START-SEARCH
           PERSISTENT RUN startSearch  IN THIS-PROCEDURE. 
        ON VALUE-CHANGED 
           PERSISTENT RUN rowChange    IN THIS-PROCEDURE.
        ON ROW-LEAVE
           PERSISTENT RUN rowLeave    IN THIS-PROCEDURE.
        ON ROW-DISPLAY
           PERSISTENT RUN rowDisplay  IN THIS-PROCEDURE.
        ON SCROLL-NOTIFY 
           PERSISTENT RUN scrollWidget IN THIS-PROCEDURE.
        ON MOUSE-SELECT-DBLCLICK
           PERSISTENT RUN mouseDoubleClick IN THIS-PROCEDURE.
        ON 'ANY-KEY':U  
           PERSISTENT RUN anyBrowseKey IN THIS-PROCEDURE  .
        
     END TRIGGERS.
     
     ON 'END-RESIZE':U OF ghbrowse ANYWHERE
        PERSISTENT RUN overlayWidget IN THIS-PROCEDURE.
        
   /* Add columns */  
ASSIGN
  hBufferField  = hBufferTable:BUFFER-FIELD("Override":U)
  hField        = ghBrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH  = 2.5
  hField:LABEL  = ""
  
  hBufferField = hBufferTable:BUFFER-FIELD("attrLabel":U)
  hField       = ghBrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 22
  hField:LABEL = "Attribute ^"
  ghLabelColumn = hField 
  
  hBufferField = hBufferTable:BUFFER-FIELD("setValue":U)
  hValueField  = ghBrowse:ADD-LIKE-COLUMN(hBufferField)
  hValueField:WIDTH = 14
  hValueField:LABEL = "Value"
  hValueField:READ-ONLY = FALSE
  ghValueColumn = hValueField
  ghBrowse:PRIVATE-DATA = STRING(hValueField)  /* Add Value column handle to private data for easy retrieval */

  hBufferField = hBufferTable:BUFFER-FIELD("resultCode":U)
  hField       = ghBrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 15
  hField:LABEL = "Result Code"
  ghResultColumn = hField

  hBufferField = hBufferTable:BUFFER-FIELD("attrGroup":U)
  hField       = ghBrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:LABEL = "Group"
  ghGroupColumn  = hfield
 NO-ERROR.

ON END-ERROR , CTRL-Z OF ghValueColumn 
    PERSISTENT RUN undoRow IN THIS-PROCEDURE.

ON 'ANY-KEY':U OF ghValueColumn
    PERSISTENT RUN anyBrowseKey IN THIS-PROCEDURE.

/* EVENTS */
/* Get the temp table buffer handles */
ASSIGN hBufferTable = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedEvent":U).

/* Construct query for temp table 'ttSelectedEvent' */
CREATE QUERY ghEventQuery.
ghEventQuery:ADD-BUFFER(hBufferTable).
/* Create attribute  browse widget */
CREATE BROWSE ghEventbrowse
     ASSIGN FRAME                  = FRAME {&FRAME-NAME}:handle
            ROW                    = 1
            COL                    = 1.0
            SEPARATORS             = TRUE
            ROW-MARKERS            = FALSE
            EXPANDABLE             = TRUE
            COLUMN-RESIZABLE       = TRUE
            ALLOW-COLUMN-SEARCHING = TRUE
            READ-ONLY              = FALSE
            QUERY                  = ghEventQuery
            SENSITIVE              = TRUE
      /* Set procedures to handle browser events */
      TRIGGERS:   
        ON START-SEARCH
           PERSISTENT RUN startSearch  IN THIS-PROCEDURE. 
        ON VALUE-CHANGED 
           PERSISTENT RUN rowChange    IN THIS-PROCEDURE.
        ON ROW-LEAVE
           PERSISTENT RUN rowLeaveEvent IN THIS-PROCEDURE.
        ON SCROLL-NOTIFY 
           PERSISTENT RUN scrollWidget IN THIS-PROCEDURE.
        ON 'ANY-KEY':U  
           PERSISTENT RUN applyMnemonic IN THIS-PROCEDURE  .
     END TRIGGERS.
   ON 'END-RESIZE':U OF ghEventbrowse ANYWHERE
        PERSISTENT RUN overlayWidget IN THIS-PROCEDURE.
   /* Add columns */  
ASSIGN
  hBufferField = hBufferTable:BUFFER-FIELD("Override":U)
  hField       = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 2.5
  hField:LABEL = ""
  
  hBufferField = hBufferTable:BUFFER-FIELD("eventName":U)
  hField       = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 22
  hField:LABEL = "Event ^"

  hBufferField = hBufferTable:BUFFER-FIELD("eventAction":U)
  hValueField  = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hValueField:WIDTH = 19
  hValueField:LABEL = "Action"
  hValueField:READ-ONLY = FALSE
  ghEventBrowse:PRIVATE-DATA = STRING(hValueField)  /* Add Value column handle to private data for easy retrieval */

  hBufferField = hBufferTable:BUFFER-FIELD("resultCode":U)
  hField       = ghEventBrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 13
  hField:LABEL = "Result Code"

  hBufferField         = hBufferTable:BUFFER-FIELD("eventType":U)
  hTypeField           = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hTypeField:WIDTH     = 10
  hTypeField:LABEL     = "Type"
  hTypeField:READ-ONLY = FALSE

  hBufferField = hBufferTable:BUFFER-FIELD("eventTarget":U)
  hTargetField       = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hTargetField:WIDTH = 10
  hTargetField:LABEL = "Target"
  hTargetField:READ-ONLY = FALSE

  hBufferField = hBufferTable:BUFFER-FIELD("eventParameter":U)
  hField       = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 10
  hField:LABEL = "Parameter"
  hField:READ-ONLY = FALSE
  
  hBufferField = hBufferTable:BUFFER-FIELD("eventDisabled":U)
  hField       = ghEventbrowse:ADD-LIKE-COLUMN(hBufferField)
  hField:WIDTH = 8
  hField:LABEL = "Disabled"
  hField:READ-ONLY = FALSE
  NO-ERROR.


ON END-ERROR OF hValueField 
    PERSISTENT RUN undoRow IN THIS-PROCEDURE.

ON 'ANY-KEY':U OF hTypeField
   PERSISTENT RUN anyBrowseKey IN THIS-PROCEDURE.

ON 'ANY-KEY':U OF hTargetField
   PERSISTENT RUN anyBrowseKey IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wiWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBufferAttribute AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferEvent     AS HANDLE     NO-UNDO.

  RUN propertyUserProfile ("SET":U).
  /* Set the event and attribute buffers back to the first record so that
     the browser repositions to the first record next time it is opened */
  ASSIGN hBufferAttribute = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedAttribute":U).
  hBufferAttribute:FIND-FIRST("") NO-ERROR.
  
  ASSIGN hBufferEvent = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedEvent":U).
  hBufferEvent:FIND-FIRST("") NO-ERROR.
  RUN SUPER.
  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> "ADM-ERROR":U THEN
  DO:
    IF VALID-HANDLE(ghProcLib) THEN
       DYNAMIC-FUNCTION("setPropSheet":U IN ghProcLib, ?).
    DELETE OBJECT ghBrowse NO-ERROR.
    DELETE OBJECT ghQuery  NO-ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dialogLookup wiWin 
PROCEDURE dialogLookup :
/*------------------------------------------------------------------------------
  Purpose:    Called upon selecting the dialog button from within
              a value field. 
  Parameters:  <none>
  Notes:       All procedures called must have the same signature,
                 Input-output character
                 Output       logical
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLookupValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProcedure   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK          AS LOGICAL    NO-UNDO.

ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
IF hBuffer:AVAILABLE THEN
DO:
  ASSIGN
    hField            = hBuffer:BUFFER-FIELD("lookupValue":U)
    cLookupValue      = hField:BUFFER-VALUE
    NO-ERROR. 

  IF R-INDEX(cLookupValue,".p":U) > 0 OR R-INDEX(cLookupValue,".w":U) > 0 THEN
  DO:
     IF SEARCH(cLookupValue)                          NE ? OR
        SEARCH(REPLACE(cLookupValue, ".p":U, ".r":U)) NE ? THEN
     DO:
       IF hBuffer:BUFFER-FIELD("lookupType":U):BUFFER-VALUE = "DIALOG-R":U THEN 
          ASSIGN cValue = hBuffer:BUFFER-FIELD("setValue":U):BUFFER-VALUE.
       ELSE 
          ASSIGN cValue = ghValueColumn:SCREEN-VALUE.

       RUN VALUE(cLookupValue) (INPUT-OUTPUT cValue, OUTPUT lOK) NO-ERROR.
       IF lOK THEN 
       DO:
          ASSIGN ghValueColumn:SCREEN-VALUE = cValue
                 ghValueColumn:MODIFIED     = TRUE.
                 ToBOX:CHECKED IN FRAME {&FRAME-NAME} = TRUE NO-ERROR.
          RUN rowLeave.
          APPLY "ENTRY":U TO ghValueColumn.
       END.
     END.
  END.
     
    
END. /* END If hBuffer:AVAILABLE  */

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
  DISPLAY fiContainer coObject coClass coFilterResult selLookup ToBox ToBoxEvent 
          EdDescription 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE buExit coObject coClass buFilter coFilterResult selLookup ToBox 
         ToBoxEvent EdDescription buPushPin buDialog buList buList-2 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  DISPLAY fiFilterAttribute fiFilterEvent coFilterGroup fiFilterLabel 
      WITH FRAME frameFilter IN WINDOW wiWin.
  ENABLE Rect-Filter fiFilterAttribute fiFilterEvent coFilterGroup 
         fiFilterLabel 
      WITH FRAME frameFilter IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frameFilter}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE folderVisible wiWin 
PROCEDURE folderVisible :
/*------------------------------------------------------------------------------
  Purpose:     Hides/Displays one or more folder tabs
  Parameters:  piPage   0 - View both pages
                        1 - View Attribute Tab page, Hide Event page
                        2 - View Events Tab page, Hide Attribute page
                        3 - View Attribute Tab page, Hide Event page, disable object combo
                        4 - View both pages and disable object combo
                        
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piPage  AS INTEGER    NO-UNDO.

DEFINE VARIABLE cFolderLabels  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCurrentPage   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hFrame         AS HANDLE     NO-UNDO.

IF piPage < 0 OR piPage > 4 THEN
   RETURN.

cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN h_folder).

CASE piPage:
   WHEN 0 OR WHEN 4 THEN
   DO:
     IF NUM-ENTRIES(cFolderLabels,"|":U) <> 2 THEN
     DO:
       h_folder:PRIVATE-DATA = "":U.
       {fnarg constructFolderLabels "'&Attributes|&Events'" h_folder}.
     END.
   END.

   WHEN 1 OR WHEN 3 THEN  /* View Attributes page only */
   DO:
     h_folder:PRIVATE-DATA = "Attributes":U.

     {fnarg constructFolderLabels "'&Attributes'" h_folder}.
   END.
   
   WHEN 2 THEN  /* View Event page only */
   DO:
     h_folder:PRIVATE-DATA = "Events":U.

     {fnarg constructFolderLabels "'&Events'" h_folder}.
   END.
END CASE.


IF piPage = 3 OR piPage = 4 THEN
   coObject:SENSITIVE IN FRAME {&FRAME-NAME}  = FALSE.
ELSE
   coObject:SENSITIVE = TRUE.
/*RUN selectPage(1).*/

{get ContainerHandle hFrame h_Folder}.
hFrame:HIDDEN= FALSE.
/* To avoid bug of folder not clearly showing selected tab */
{get CurrentPage iCurrentPage}.
RUN showCurrentPage IN h_folder (IF iCurrentPage = 2 THEN 1 ELSE 2). 
RUN showCurrentPage IN h_folder (iCurrentPage).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Create the dynamic browse and other set up functions.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResultCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectList     AS CHARACTER  NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Load correct application icon */
  {aficonload.i}

  ASSIGN gcManagerList = getManagers()
         gcManagerList = "SELF" + CHR(3) + "SELF":U + CHR(3) 
                          + "CONTAINER" + CHR(3) + "CONTAINER":U + CHR(3)
                          + "ANYWHERE":U + CHR(3) + "ANYWHERE" + CHR(3) 
                          + gcManagerList.

  /* Create dynamic browse */
  RUN createBrowse IN THIS-PROCEDURE.
  
  
  /* Reposition the folder */
  RUN RepositionObject IN h_folder ({&FOLDER_ROW},{&FOLDER_COL}).
  /* Get the User Property Sheet Profile information */
  RUN PropertyUserProfile IN THIS-PROCEDURE ("GET":U).
  
  RUN resizeObject IN THIS-PROCEDURE ({&WINDOW-NAME}:HEIGHT,{&WINDOW-NAME}:WIDTH, NO).
  ASSIGN {&WINDOW-NAME}:VISIBLE   = TRUE
         {&WINDOW-NAME}:PARENT    = SOURCE-PROCEDURE:CURRENT-WINDOW  /* PARENT Window */
         coObject:DELIMITER    IN FRAME {&FRAME-NAME}   = CHR(3)  /* Set delimiters */
         coFilterResult:DELIMITER = CHR(3)
         coFilterGroup:DELIMITER IN FRAME FrameFilter     = CHR(3) 
         h_folder:PRIVATE-DATA    = ""
         NO-ERROR.
  
  setRepositionQuery (NO).
  RUN selectPage (1).
  
  /* Apply a rowChange for first record in browse */
  RUN rowChange IN THIS-PROCEDURE.
  setRepositionQuery (YES). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mouseDoubleClick wiWin 
PROCEDURE mouseDoubleClick :
/*------------------------------------------------------------------------------
  Purpose:     On Double-clicking a row, if the row has a corresponding list-item,
               set the value equal to the next item in the list
  Parameters:  <none>
  Notes:       Called from MOUSE-SELECT-DBLCLICK persistent trigger of the browse
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLookupValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPos         AS INTEGER    NO-UNDO.
  
ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
IF hBuffer:AVAILABLE THEN
DO WITH FRAME {&FRAME-NAME}:
 IF hBuffer:BUFFER-FIELD("isDisabled":U):BUFFER-VALUE = TRUE THEN
    RETURN.
 
 ASSIGN
    hField       = hBuffer:BUFFER-FIELD("lookupValue":U)
    cLookupValue = hField:BUFFER-VALUE
    selLookup:VISIBLE IN FRAME {&FRAME-NAME} = FALSE
    NO-ERROR. 
  
  IF cLookupValue > "" AND NUM-ENTRIES(cLookupValue,CHR(3)) > 1 THEN
  DO:
    ghValueColumn:SCREEN-VALUE = getNextItemPair(cLookupValue,ghValueColumn:SCREEN-VALUE,CHR(3)).
    ASSIGN ToBOX:CHECKED = TRUE.
    RUN rowLeave IN THIS-PROCEDURE. 
  END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE overlayWidget wiWin 
PROCEDURE overlayWidget :
/*------------------------------------------------------------------------------
  Purpose:     Positions either the lookup button or the dialog button
               within the value field for the attribute browse
  Parameters:  <none>
  Notes:      Called from procedures rowChange, resizeObject and browse trigger Scroll-notify
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLookupType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hOverrideCol AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTypeCol     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTargetCol   AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.

{get CurrentPage iCurrentPage}.

/* If the current page is 1, set the overlay widgets for the attribute browse */
ASSIGN buList:VISIBLE  IN FRAME {&FRAME-NAME} = FALSE
       buDialog:VISIBLE  = FALSE
       toBox:VISIBLE     = FALSE
       buList-2:VISIBLE  = FALSE
       SelLookup:VISIBLE = FALSE
       toBoxEvent:VISIBLE = FALSE.   

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  /* Get the current buffer values for the lookupType and lookupValue */
  ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO:
    ASSIGN hField       = hBuffer:BUFFER-FIELD("lookupType":U)
           cLookupType  = hField:BUFFER-VALUE
           NO-ERROR.
    /* If lookup type is LIST or PROC, position the (combo-box imitation) lookup button */
    IF cLookupType = "LIST":U OR cLookupType = "PROC":U THEN
    DO:
      IF ghValueColumn:Y < 0 OR ghValueColumn:X < 0 
         OR ghValueColumn:X + ghValueColumn:WIDTH-P + buList:WIDTH-P > ghBrowse:WIDTH-P THEN
        buList:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.
      ELSE
      DO:                                
        ASSIGN buList:Y              = ghValueColumn:Y + ghBrowse:Y
               buList:X              = ghValueColumn:X + ghBrowse:X + ghValueColumn:WIDTH-PIXELS
                                        - buList:WIDTH-PIXELS + 4
               buList:VISIBLE        = TRUE
               NO-ERROR.
         buList:MOVE-TO-TOP().
      END.
    END. /* END IF cLookupType = "LIST" or "PROC" */
    /* IF the lookup type is DIALOG or DIALOG-R, position the lookup button [...] */
    ELSE IF cLookupType = "DIALOG":U OR cLookupType = "DIALOG-R":U THEN
    DO:
      IF ghValueColumn:Y < 0 OR ghValueColumn:X < 0 
         OR ghValueColumn:X + ghValueColumn:WIDTH-P + buDialog:WIDTH-P > ghBrowse:WIDTH-P THEN 
          buDialog:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.
      ELSE
      DO:
        ASSIGN buDialog:Y       = ghValueColumn:Y + ghBrowse:Y
               buDialog:X       = ghValueColumn:X + ghBrowse:X + ghValueColumn:WIDTH-PIXELS 
                                       - buDialog:WIDTH-PIXELS + 4
               buDialog:VISIBLE = TRUE   /* For DIALOG-R, make the field read-only */
               NO-ERROR . 
        buDialog:MOVE-TO-TOP().
          
      END.
      ASSIGN  buList:VISIBLE = FALSE.
    END. /* END IF cLookupType = "DIALOG"  */
  END. /* END IF hBuffer:Available */
 

  /* Overlay the toggle-box to the current row */
  IF hBuffer:AVAILABLE AND VALID-HANDLE(ghBrowse) THEN
  DO:
    ASSIGN
      hOverrideCol = ghBrowse:GET-BROWSE-COLUMN(1)
      toBox:Y       = hOverrideCol:Y + ghBrowse:Y
      toBox:X       = hOverrideCol:X + ghBrowse:X - 1
      toBox:WIDTH-P = hOverrideCol:WIDTH-P + 3
      tobox:VISIBLE = IF hOverrideCol:Y < 0 OR hOverrideCol:X < 0 THEN FALSE ELSE TRUE
     NO-ERROR.
     tobox:MOVE-TO-TOP().
  END.
END.  /* End CurrentPage = 1 */
/* If on Page 2, set overlay widgets for Event Browse */
ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA =  "Events":U THEN
DO:
  ASSIGN buList:VISIBLE     = FALSE
         buDialog:VISIBLE   = FALSE
         toBox:VISIBLE      = FALSE
         hTypeCol           = ghEventBrowse:GET-BROWSE-COLUMN(5)
         hTargetCol         = ghEventBrowse:GET-BROWSE-COLUMN(6)
         hOverrideCol       = ghEventBrowse:GET-BROWSE-COLUMN(1)
         toBoxEvent:Y       = hOverrideCol:Y + ghBrowse:Y
         toBoxEvent:X       = hOverrideCol:X + ghBrowse:X - 1
         toBoxEvent:WIDTH-P = hOverrideCol:WIDTH-P + 3
         toBoxEvent:VISIBLE = IF hOverrideCol:Y < 0 OR hOverrideCol:X < 0  THEN FALSE ELSE TRUE
         buList:VISIBLE     = IF hTypeCol:Y < 0 OR hTypeCol:X < 0 
                                 OR hTypeCol:X + hTypeCol:WIDTH-P + buList:WIDTH-P > ghEventBrowse:WIDTH-P
                              THEN FALSE
                              ELSE TRUE
         buList:Y           = hTypeCol:Y + ghEventBrowse:Y
         buList:X           = hTypeCol:X + ghEventBrowse:X + hTypeCol:WIDTH-PIXELS - buList:WIDTH-PIXELS + 4
         buList-2:VISIBLE   = IF hTargetCol:Y < 0 OR hTargetCol:X < 0 
                                OR hTargetCol:X + hTargetCol:WIDTH-P + buList-2:WIDTH-P > ghEventBrowse:WIDTH-P
                              THEN FALSE
                              ELSE TRUE
         buList-2:Y         = hTargetCol:Y + ghEventBrowse:Y
         buList-2:X         = hTargetCol:X + ghEventBrowse:X + hTargetCol:WIDTH-PIXELS - buList-2:WIDTH-PIXELS + 4
         NO-ERROR.
  buList-2:MOVE-TO-TOP().
  buList:MOVE-TO-TOP().
  toboxEvent:MOVE-TO-TOP().
  
END.


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
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyUserProfile wiWin 
PROCEDURE propertyUserProfile :
/*------------------------------------------------------------------------------
  Purpose:     Used to either get or set a user profile for size
               and width of property sheet and columns and filter info.
  Parameters:  pcMode    GET   Retrieve the user profile info on initialization
                         SET   Save the prop sheet info on destroying object (DestroyObject)
  Notes:       Uses new profile code 'PropSize' for profile type code 'Window'
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

DEFINE VARIABLE rRowid              AS ROWID      NO-UNDO.
DEFINE VARIABLE cProfileData        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hColumn             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cColWidths          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCols               AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEventColWidths     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterIsOn         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterString       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterGroup        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterResult       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEventFilterString  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lTopOnly            AS LOGICAL    NO-UNDO.

IF NOT VALID-HANDLE(ghBrowse) OR NOT VALID-HANDLE(gshProfileManager) 
    OR NOT VALID-HANDLE({&WINDOW-NAME}) THEN  
  RETURN.

IF pcMode = "GET":U THEN
DO:
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code     */
                                             INPUT "PropSheet":U,     /* Profile code          */
                                             INPUT "PropSize":U,      /* Profile data key      */
                                             INPUT "NO":U,            /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,     /* Rowid of profile data */
                                             OUTPUT cProfileData).    /* Found profile data. */
  
  IF cProfileData > "" THEN
  DO:
     ASSIGN {&WINDOW-NAME}:WIDTH-PIXELS  = INT(ENTRY(1,cProfileData,CHR(3)))
            {&WINDOW-NAME}:HEIGHT-PIXELS = INT(ENTRY(2,cProfileData,CHR(3)))
            {&WINDOW-NAME}:Y             = INT(ENTRY(3,cProfileData,CHR(3)))
            {&WINDOW-NAME}:X             = INT(ENTRY(4,cProfileData,CHR(3)))
            cColWidths                   = ENTRY(5,cProfileData,CHR(3))
            cFilterIsOn                  = ENTRY(6,cProfileData,CHR(3))
            cFilterString                = ENTRY(7,cProfileData,CHR(3))
            cFilterResult                = ENTRY(8,cProfileData,CHR(3))
            cFilterGroup                 = ENTRY(9,cProfileData,CHR(3))
            cEventColWidths              = ENTRY(10,cProfileData,CHR(3))
            cEventFilterString           = ENTRY(11,cProfileData,CHR(3))
            NO-ERROR.
     
     /* Set the widths of the attribute browse */
     IF cColWidths > "" THEN
     DO icols = 1 TO ghBrowse:NUM-COLUMNS:
       hColumn= ghBrowse:GET-BROWSE-COLUMN(icols).
       hColumn:WIDTH-PIXELS = INT(ENTRY(iCols,cColWidths,CHR(2))) NO-ERROR.
     END.
                                    
     /* Set the filter information for the attributes */
     IF cFilterIsOn = "yes":U THEN
     DO:
       ASSIGN glFilterOn = YES
              buFilter:LABEL IN FRAME {&FRAME-NAME}= "Hide &Filter <<" .
       
       buFilter:LOAD-IMAGE("ry/img/hidefilter.gif":U) IN FRAME {&FRAME-NAME}.
     END.

     IF cFilterString > "" THEN 
     DO:
        ASSIGN fiFilterAttribute:SCREEN-VALUE IN FRAME FrameFilter = cFilterString.
        RUN assignFilterString("attrLabel=":U + cFilterString).
        buFilterClear:SENSITIVE = TRUE.
     END.
        
     IF cFilterResult > "" THEN
     DO:
        ASSIGN coFilterResult:SCREEN-VALUE = cFilterResult NO-ERROR.
        setResultCode(cFilterResult,NO).
        IF NOT ERROR-STATUS:ERROR THEN 
        DO:
           RUN assignFilterString("resultCode=":U + cFilterResult ).
           buFilterClear:SENSITIVE = TRUE.
        END.

     END.
     ASSIGN gcStartupGroupValue      = cFilterGroup NO-ERROR.

     /* Set the widths of the events browse */
     IF cEventColWidths > "" THEN
     DO icols = 1 TO ghEventBrowse:NUM-COLUMNS:
       hColumn= ghEventBrowse:GET-BROWSE-COLUMN(icols).
       hColumn:WIDTH-PIXELS = INT(ENTRY(iCols,cEventColWidths,CHR(2))) NO-ERROR.
     END.

     /* Set the window's top-only attribute top-only */
     IF NUM-ENTRIES(cProfileData, CHR(3)) >= 12 THEN
       lTopOnly = (ENTRY(12,cProfileData,CHR(3)) = "yes":U).

     ASSIGN
        lTopOnly               = NOT lTopOnly  /* Invert the value of the stored top only attribute */
        buPushPin:PRIVATE-DATA = IF lTopOnly THEN "IN":U ELSE "OUT":U.

     APPLY "CHOOSE":U TO buPushPin.          /* Choosing the PushPin button wil invert the value again and give us the correct value and state on the PushPin button */

  END. /* End If cProfileData > "" */
END.
ELSE IF pcMode = "SET":U THEN
DO WITH FRAME {&FRAME-NAME}:
  
   DO icols = 1 TO ghBrowse:NUM-COLUMNS:
       hColumn= ghBrowse:GET-BROWSE-COLUMN(icols).
      cColWidths = cColWidths + (IF cColWidths = "" THEN "" ELSE CHR(2))
                              + STRING(hColumn:WIDTH-PIXELS).
   END.
   DO icols = 1 TO ghEventBrowse:NUM-COLUMNS:
       hColumn= ghEventBrowse:GET-BROWSE-COLUMN(icols).
      cEventColWidths = cEventColWidths + (IF cEventColWidths = "" THEN "" ELSE CHR(2))
                              + STRING(hColumn:WIDTH-PIXELS).
   END.

 ASSIGN cProfileData = STRING({&WINDOW-NAME}:WIDTH-PIXELS) + CHR(3) + STRING({&WINDOW-NAME}:HEIGHT-PIXELS)  
                         + CHR(3) + STRING({&WINDOW-NAME}:Y) + CHR(3) + STRING({&WINDOW-NAME}:X) 
                         + CHR(3) + cColWidths + CHR(3) 
                         + (IF glFilterOn THEN "yes":U ELSE "no":U) 
                         + CHR(3) + fiFilterAttribute:SCREEN-VALUE IN FRAME FrameFilter
                         + CHR(3) + (IF coFilterResult:SCREEN-VALUE = ? THEN "" ELSE coFilterResult:SCREEN-VALUE) 
                         + CHR(3) + (IF coFilterGroup:SCREEN-VALUE = ? THEN "" ELSE coFilterGroup:SCREEN-VALUE)
                         + CHR(3) + cEventColWidths + CHR(3) 
                         +  fiFilterEvent:SCREEN-VALUE
                         + CHR(3) + STRING({&WINDOW-NAME}:TOP-ONLY).

 IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code */
                                             INPUT "PropSheet":U,  /* Profile code */
                                             INPUT "PropSize",     /* Profile data key */
                                             INPUT ?,                 /* Rowid of profile data */
                                             INPUT cProfileData,      /* Profile data value */
                                             INPUT NO,                /* Delete flag */
                                             INPUT "PER":u).          /* Save flag (permanent) */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildObjects wiWin 
PROCEDURE rebuildObjects :
/*------------------------------------------------------------------------------
  Purpose:    Rebuilds the object combo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc   AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cObjectLabels  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentObject AS CHARACTER  NO-UNDO.


/* Rebuild Object List if required */
IF VALID-HANDLE(ghProcLib) THEN
    gcObjectNameList = DYNAMIC-FUNC("getObjectList":U IN ghProcLib, 
                                       INPUT phCallingProc,
                                       INPUT pcContainerName, 
                                       OUTPUT cObjectLabels).

  
IF cObjectLabels <> coObject:LIST-ITEMS IN FRAME {&FRAME-NAME} THEN
DO:
    ASSIGN cCurrentObject        = coObject:SCREEN-VALUE
           coObject:LIST-ITEMS   = cObjectLabels
           NO-ERROR.
    IF LOOKUP(cCurrentObject,cObjectLabels) > 0 THEN
       coObject:SCREEN-VALUE  = cCurrentObject.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBrowse wiWin 
PROCEDURE refreshBrowse :
/*------------------------------------------------------------------------------
  Purpose:    Refreshes the attribute browse and the event browse 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ghBrowse:REFRESH() NO-ERROR.
ghEventBrowse:REFRESH() NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQuery wiWin 
PROCEDURE refreshQuery :
/*------------------------------------------------------------------------------
  Purpose:     Refreshes the browse query and sets the Object combo-box.
  Parameters:  phCallingProc     Handle of calling procedure
               pcContainerName   Name of the container
               pcContainerLabel  Label of the container, appears in container fill-in
               pcObjectNameList  List of Object Names selected (chr(3) delimited)
  Notes:       Called from VALUE-CHANGED triggers of filter fields, from startSearch 
               trigger, from rowLeave proc and from DisplayProperties proc in library.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phCallingProc    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerName  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerLabel AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectNameList AS CHARACTER NO-UNDO.

DEFINE VARIABLE hBufferAttribute AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBufferEvent     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNewObject       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAttribute       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEvent           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowiD           AS ROWID      NO-UNDO.
DEFINE VARIABLE cObjectNameList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCode      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClassList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectClass     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cGroupList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPreviousGroup   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lResultCodeDisabled AS LOGICAL NO-UNDO.
DEFINE VARIABLE cResultCodeList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cResultListItems AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cQuery           AS CHARACTER  NO-UNDO.

/* Lock the window to avoid flickering */

lockWindow(TRUE).

/* If called from filter fields or start-search, OMIT the rebuilding of                              
   combo-fields. Only rebuild if called externally from displayProperties*/
IF NOT glSkipObjectList THEN  
DO:
  /* Get the list of Groups pertaining to this object and rebuild if necessary */
  cGroupList =  DYNAMIC-FUNC("getGroupList":U IN ghProcLib, phCallingProc,pcContainerName,pcObjectNameList).
  IF "<ALL>" + CHR(3) + cGroupList <> coFilterGroup:LIST-ITEMS IN FRAME FrameFilter THEN 
  DO:
    ASSIGN cPreviousGroup      = coFilterGroup:SCREEN-VALUE 
           coFilterGroup:LIST-ITEMS = "<All>" + IF cGroupList = "" THEN "" ELSE (CHR(3) + cGroupList).
    IF gcStartupGroupValue > "" AND LOOKUP(gcStartupGroupValue,cGroupList,CHR(3))> 0 THEN
    DO:
       RUN assignFilterString ( "attrGroup=":U + gcStartupGroupValue).
       ASSIGN coFilterGroup:SCREEN-VALUE  IN FRAME FrameFilter = gcStartupGroupValue
              gcStartupGroupValue     = "" NO-ERROR.
    END.
    ELSE IF LOOKUP(cPreviousGroup,cGroupList,CHR(3)) > 0 THEN
       coFilterGroup:SCREEN-VALUE = cPreviousGroup.
    ELSE
    DO:
       coFilterGroup:SCREEN-VALUE = "<All>".
       RUN assignFilterString ( "attrGroup=<ALL>").
    END.
    RUN setFilterClear.       
  END. /* END if list-item is different */

  /* Rebuild Object List if required */
  RUN rebuildObjects IN THIS-PROCEDURE (phCallingProc,pcContainerName). .
  /* Set up result code list. Build a list item list whereby the default label of blank is set to <Default> */
  /* Get the comma delimited list of result codes for the current object */
   IF NUM-ENTRIES(pcObjectNameList,CHR(3)) = 1 THEN
   DO:
      ASSIGN cResultCodeList = TRIM(DYNAMIC-FUNC("getResultCodeList":U IN ghProcLib,phCallingProc,pcContainerName,pcObjectNameList)).
      DO iLoop = 1 TO NUM-ENTRIES(cResultCodeList):
         /* Check for default result code */ 
         IF ENTRY(iLoop,cResultCodeList) = "{&DEFAULT-RESULT-CODE}":U THEN
            cResultListItems = cResultListItems + (IF cResultListItems = "" THEN "" ELSE CHR(3))
                                                + "<Default>" + CHR(3) + " ".
         ELSE
            cResultListItems = cResultListItems + (IF cResultListItems = "" THEN "" ELSE CHR(3))
                                                + ENTRY(iLoop,cResultCodeList) + CHR(3) + ENTRY(iLoop,cResultCodeList).
      END.
      IF NUM-ENTRIES(cResultCodeList) > 1 THEN
         cResultListItems = cResultListItems + CHR(3) + "<All>" + CHR(3) + "<All>":U.
      IF LOOKUP("<Default>",cResultListItems,CHR(3)) = 0 THEN
         cResultListItems = cResultListItems + CHR(3) + "<Default>" + CHR(3) + " ":U.

      ASSIGN coFilterResult:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cResultListItems
             coFilterResult:SCREEN-VALUE    = " "  /* Initially set the Result code to be 'Default' */
             NO-ERROR. 
   END.
END. /* END IF NOT glSkipObjectList */
 

/* Set the Object combo and class combo screen values. If more than 1 object is selected,
      set the Class and Object combos to blank  */
IF NUM-ENTRIES(pcObjectNameList,CHR(3)) = 1 THEN
DO:
  ASSIGN coObject:SCREEN-VALUE = ENTRY(LOOKUP(pcObjectNameList,gcObjectNameList,CHR(3)), coObject:LIST-ITEMS, CHR(3))
         cObjectClass          =  DYNAMIC-FUNC("getClassList":U IN ghProcLib, phCallingProc,pcContainerName,
                                                                              pcObjectNameList,OUTPUT cClassList)
         coClass:LIST-ITEMS    = cClassList 
         coClass:SCREEN-VALUE  = cObjectClass 
         coClass:SENSITIVE     = IF NUM-ENTRIES(cClassList) <= 1 THEN FALSE ELSE TRUE 
         NO-ERROR.
END.
ELSE
  ASSIGN coObject:LIST-ITEMS = "?" + coObject:DELIMITER + coObject:LIST-ITEMS
         coClass:LIST-ITEMS = "?" + coClass:DELIMITER + coClass:LIST-ITEMS
         coClass:SENSITIVE      = FALSE.

ASSIGN fiContainer:SCREEN-VALUE    = pcContainerLabel
       fiContainer:PRIVATE-DATA    = pcContainerName
       {&WINDOW-NAME}:PRIVATE-DATA = STRING(phCallingProc)
       coObject:PRIVATE-DATA       = pcObjectNameList
       cResultCode                 = getResultCode(lResultCodeDisabled)
       lResultCodeDisabled         = IF lResultCodeDisabled = ? 
                                     THEN NO 
                                     ELSE lResultCodeDisabled.

IF cResultCode <> ?  THEN 
DO:
  ASSIGN coFilterResult:SCREEN-VALUE = cResultCode NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
     RUN AssignFilterString ("resultCode=":U + cResultCode).
END.
 
ASSIGN coFilterResult:SENSITIVE    = NOT lResultCodeDisabled NO-ERROR.
/* Refresh the attribute query based on table ttSelectedAttribute */
ASSIGN hBufferAttribute = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedAttribute":U).
IF VALID-HANDLE(ghQuery) THEN
DO:
  cQuery = ghQuery:PREPARE-STRING.
  ghQuery:QUERY-PREPARE("for each " + hBufferAttribute:TABLE 
                        + (IF gcWhere > "" THEN " WHERE " + gcWhere ELSE "")
                        + getByClause('Attribute':U) ).
  lok = ghQuery:QUERY-OPEN NO-ERROR.
  IF lok THEN 
     ghQuery:GET-FIRST().
  ELSE DO:
    ghQuery:QUERY-PREPARE(cQuery).
    ghQuery:QUERY-OPEN(). 
  END.
END.
/* In order to keep the same attribute selected when switching between objects,
   reposition the Query to the last saved attribute and result code*/
IF lOK AND hBufferAttribute:AVAILABLE AND getRepositionQuery() THEN
DO:
  ASSIGN rRowID = ?.
  REPEAT:
    hField      = hBufferAttribute:BUFFER-FIELD("attrLabel":U).
    cAttribute  = hField:BUFFER-VALUE.
    hField      = hBufferAttribute:BUFFER-FIELD("resultCode":U).
    cResultCode = hField:BUFFER-VALUE.

    IF cAttribute = gcLastAttribute AND (cResultCode = gcLastResultCode OR cResultCode = coFilterResult:SCREEN-VALUE) THEN 
    DO:
       rRowID = hBufferAttribute:ROWID.
       LEAVE.
    END.
    ghQuery:GET-NEXT().
    IF ghQuery:QUERY-OFF-END THEN LEAVE.
  END.
  ghBrowse:SET-REPOSITIONED-ROW(giBrowseRow,"ALWAYS":U).
  IF rRowID <> ? THEN
     ghQuery:REPOSITION-TO-ROWID(rRowID).
  ELSE
     ghQuery:GET-FIRST().
END.


/* Refresh the event query based on table ttSelectedEvent */
ASSIGN hBufferEvent = DYNAMIC-FUNC("getBuffer" IN ghProcLib,"ttSelectedEvent":U).
IF VALID-HANDLE(ghEventQuery) THEN
DO:
  ghEventQuery:query-prepare("for each " + hBufferEvent:TABLE 
                        + (IF gcEventWhere > "" THEN " WHERE " + gcEventWhere ELSE "")
                        + getByClause('Event':U) ).
  lok = ghEventQuery:QUERY-OPEN NO-ERROR.
  IF lok THEN ghEventQuery:GET-FIRST().
END.


/* In order to keep the same attribute selected when switching between objects,
   reposition the Query to the last saved attribute and result code*/
IF lok AND hBufferEvent:AVAILABLE AND getRepositionQuery() THEN
DO:
    REPEAT:
    ASSIGN hField      = hBufferEvent:BUFFER-FIELD("eventName":U)
           cEvent       = hField:BUFFER-VALUE
           hField       = hBufferEvent:BUFFER-FIELD("resultCode":U)
           cResultCode  = hField:BUFFER-VALUE.

    IF cEvent = gcLastEvent AND (cResultCode = gcLastEventResultCode OR cResultCode = coFilterResult:SCREEN-VALUE) THEN 
    DO:
       rRowID = hBufferEvent:ROWID.
       LEAVE.
    END.
    ghEventQuery:GET-NEXT().
    IF ghEventQuery:QUERY-OFF-END THEN LEAVE.
  END.
  ghEventBrowse:SET-REPOSITIONED-ROW(giEventBrowseRow,"ALWAYS":U).
  IF rRowID <> ? THEN
     ghEventQuery:REPOSITION-TO-ROWID(rRowID) NO-ERROR.
  ELSE
     ghEventQuery:GET-FIRST().
END.

glSkipObjectList = NO.
RUN rowChange IN THIS-PROCEDURE.
RUN rowDisable IN THIS-PROCEDURE.

/* Unlocking window as operation is finished */
lockWindow(FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject wiWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the property window objects (Fill-ins, combo-boxes and column widths) 
  Parameters: pdHeight   Height of Container window
              pdWidth    Width of container window 
              plResizeColumn  If YES, the columns are proportionately adjusted.
  Notes:      Called from the WINDOW-RESIZED trigger 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdHeight       AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER pdWidth        AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER plResizeColumn AS LOGICAL    NO-UNDO.

DEFINE VARIABLE hColumn          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumnEvent     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lOk              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iInitialWidth    AS INTEGER    NO-UNDO.
DEFINE VARIABLE hSideLabel       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLabel           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hGroupColumn     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDisabledColumn  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCurrentPage     AS INTEGER    NO-UNDO.
DEFINE VARIABLE deWidthInc       AS DECIMAL    NO-UNDO.


IF NOT VALID-HANDLE(ghBrowse) OR  NOT VALID-HANDLE(ghEventBrowse) THEN
   RETURN.
/* Set the Frame equal to the maximum size to avoid frame too small errors */
/* Also, resize the fill-in and combo-box fields at the top */

ASSIGN FRAME {&FRAME-NAME}:WIDTH  = MAX(FRAME {&FRAME-NAME}:WIDTH,pdWidth)
       FRAME {&FRAME-NAME}:HEIGHT = MAX(FRAME {&FRAME-NAME}:HEIGHT,pdHeight)
       fiContainer:WIDTH          = pdWidth - fiContainer:COL + 1 - buExit:WIDTH - buPushPin:WIDTH
       buPushPin:COL              = fiContainer:COL + fiContainer:WIDTH 
       buExit:COL                 = fiContainer:COL + fiContainer:WIDTH + buPushPin:WIDTH
       hSideLabel                 = coClass:SIDE-LABEL-HANDLE
       cLabel                     = hSideLabel:SCREEN-VALUE + ": "
       coObject:WIDTH             = (pdWidth - coObject:COL - FONT-TABLE:GET-TEXT-WIDTH(cLabel) - 2 ) * 3 / 5
       coClass:COL                = coObject:COL + coObject:WIDTH + FONT-TABLE:GET-TEXT-WIDTH(cLabel) + 2    
       coClass:WIDTH              = pdWidth - coClass:COL + 1
       coFilterResult:ROW         = coObject:ROW + coObject:HEIGHT + .1     
       coFilterResult:WIDTH       = coObject:WIDTH
       hSideLabel:COL             = coClass:COL - FONT-TABLE:GET-TEXT-WIDTH(clabel)
       buFilter:COL               = pdWidth - buFilter:WIDTH - buFilterClear:WIDTH + .8
       buFilterClear:COL          =  buFilter:COL + buFilter:WIDTH + .05
       edDescription:COL          = 2
       edDescription:WIDTH        = pdWidth - edDescription:COL 
       edDescription:ROW          = pdHeight - edDescription:HEIGHT + .7
                                  - (IF {fn getTabPosition h_folder} = "Lower":U THEN {fn getTabRowHeight h_folder} ELSE 0)
       NO-ERROR.

/* Get the current page to determine if attribute browser or event browser is displayed */
{get CurrentPage iCurrentPage}.

  /* Increase Width of browse and proportionally increase the size of the columns */

RUN resizeObject IN h_Folder (pdHeight - {&FOLDER_ROW} + 1.0, pdWidth - {&FOLDER_COL} + 1.0).
RUN showCurrentPage IN h_folder (IF iCurrentPage = 2 THEN 1 ELSE 2). /* To avoid bug of folder not clearly showing selected tab */
RUN showCurrentPage IN h_folder (iCurrentPage).

/* Resize column widths for attribute columns*/
ASSIGN iInitialWidth        = ghBrowse:WIDTH
       ghBrowse:ROW         = {fn getInnerRow h_folder} + (IF glFilterOn THEN FRAME FrameFilter:HEIGHT-CHARS + 0.24 ELSE 0.12)
       ghBrowse:COL         = 2.1
       ghBrowse:WIDTH       = pdWidth - 2.5
       ghBrowse:HEIGHT      = pdHeight - ghBrowse:ROW - EdDescription:HEIGHT + .48
                            - (IF {fn getTabPosition h_folder} = "Lower":U THEN {fn getTabRowHeight h_folder} ELSE 0)
       ghEventBrowse:COL    = ghBrowse:COL NO-ERROR.

ASSIGN ghEventBrowse:WIDTH  = ghBrowse:WIDTH
       ghEventBrowse:HEIGHT = ghBrowse:HEIGHT + EDDescription:HEIGHT + 0.24
       NO-ERROR.

ASSIGN ghEventBrowse:ROW    = ghBrowse:ROW
       hGroupColumn         = ghBrowse:GET-BROWSE-COLUMN(5) /* GroupColumn */
       hColumn              = ghBrowse:GET-BROWSE-COLUMN(2) /* Label Column */
       hColumn:WIDTH        = IF plResizeColumn AND (hGroupColumn:COL + ghBrowse:COL + 13 < pdWidth OR pdWidth - 2.5 < iInitialWidth) 
                              THEN  MAX(20,hColumn:WIDTH * (1 + ((pdWidth - iInitialWidth) / 100) )) 
                              ELSE hColumn:WIDTH
       hColumn              = ghBrowse:GET-BROWSE-COLUMN(3)  /* Value Column  */
       hColumn:WIDTH        = IF plResizeColumn AND (hGroupColumn:COL + ghBrowse:COL + 13 < pdWidth  OR pdWidth - 2.5 < iInitialWidth) 
                              THEN  MAX(15,hColumn:WIDTH * (1 + ((pdWidth - iInitialWidth) / 100) )) 
                              ELSE hColumn:WIDTH
       hColumn              = ghBrowse:GET-BROWSE-COLUMN(4)  /* Result Column  */
       hColumn:WIDTH        = IF plResizeColumn AND (hGroupColumn:COL + ghBrowse:COL + 13 < pdWidth OR pdWidth - 2.5 < iInitialWidth) 
                              THEN MAX(15,hColumn:WIDTH * (1 + ((pdWidth - iInitialWidth) / 100) )) 
                              ELSE hColumn:WIDTH  
       hDisabledColumn      = ghEventBrowse:GET-BROWSE-COLUMN(8) /* DisabledColumn */
       deWidthInc           = pdWidth - hDisabledColumn:COL - ghEventBrowse:COL - 10  - 2.5 /* Length of Disabled Label = ~ 10 */
       deWidthInc           = IF deWidthInc = ? THEN 0 ELSE deWidthInc
       
       hColumn              = ghEventBrowse:GET-BROWSE-COLUMN(2) /* Event Name Column */
       hColumn:WIDTH        = IF plResizeColumn AND (hDisabledColumn:COL + ghEventBrowse:COL + 12.5 < pdWidth OR pdWidth - 2.5 < iInitialWidth) 
                              THEN MAX(20,hColumn:WIDTH * (1 + (deWidthInc / 100) ) ) 
                              ELSE hColumn:WIDTH
       hColumn              = ghEventBrowse:GET-BROWSE-COLUMN(3)  /* Event Action Column  */
       hColumn:WIDTH        = IF plResizeColumn AND (hDisabledColumn:COL + ghEventBrowse:COL + 12.5 < pdWidth  OR pdWIdth - 2.5 < iInitialWidth) 
                              THEN  MAX(15,hColumn:WIDTH * (1 + (deWidthInc / 100) ) - hDisabledColumn:WIDTH) 
                              ELSE hColumn:WIDTH
       hColumn              = ghEventBrowse:GET-BROWSE-COLUMN(4)  /* Result Column  */
       hColumn:WIDTH        = IF plResizeColumn AND (hDisabledColumn:COL + ghEventBrowse:COL + 12.5 < pdWidth OR pdWIdth - 2.5 < iInitialWidth) 
                              THEN MAX(15,hColumn:WIDTH * (1 + (deWidthInc / 100) )) 
                              ELSE hColumn:WIDTH
       hColumn              = ghEventBrowse:GET-BROWSE-COLUMN(6)  /* Event Target  Column  */
       hColumn:WIDTH        = IF plResizeColumn AND (hDisabledColumn:COL + ghEventBrowse:COL + 12.5 < pdWidth OR pdWIdth - 2.5 < iInitialWidth) 
                              THEN MAX(15,hColumn:WIDTH * (1 + (deWidthInc / 100) )) 
                              ELSE hColumn:WIDTH
      hColumn              = ghEventBrowse:GET-BROWSE-COLUMN(7)  /* Event Parameter  Column  */
      hColumn:WIDTH        = IF plResizeColumn AND (hDisabledColumn:COL + ghEventBrowse:COL + 12.5 < pdWidth OR pdWIdth - 2.5 < iInitialWidth) 
                             THEN MAX(15,hColumn:WIDTH * (1 + (deWidthInc / 100) )) 
                             ELSE hColumn:WIDTH
       NO-ERROR.

/* Resize and reposition filter fields */
ASSIGN FRAME frameFilter:COL   = {&FOLDER_COL} + 1
       FRAME frameFilter:ROW   = {fn getInnerRow h_folder} + 0.12
       Rect-Filter:ROW         = fiFilterLabel:ROW + .35
       Rect-Filter:COL         = 1
       Rect-Filter:WIDTH       = ghBrowse:WIDTH - Rect-Filter:COL + 1 
       fiFilterAttribute:COL   = 12
       fiFilterAttribute:ROW   = Rect-Filter:ROW + .35
       fiFilterAttribute:WIDTH = (ghBrowse:WIDTH - 23) / 2
       hSideLabel              = fiFilterAttribute:SIDE-LABEL-HANDLE
       hSideLabel:ROW          = fiFilterAttribute:ROW
       hSideLabel:COL          = fiFilterAttribute:COL - FONT-TABLE:GET-TEXT-WIDTH(hSideLabel:SCREEN-VALUE + ": ")
       coFilterGroup:ROW       = fiFilterAttribute:ROW
       coFilterGroup:COL       = fiFilterAttribute:COL + fiFilterAttribute:WIDTH + 10
       coFilterGroup:WIDTH     = fiFilterAttribute:WIDTH
       hSideLabel              = coFilterGroup:SIDE-LABEL-HANDLE
       hSideLabel:ROW          = coFilterGroup:ROW
       hSideLabel:COL          = coFilterGroup:COL - FONT-TABLE:GET-TEXT-WIDTH(hSideLabel:SCREEN-VALUE + ": ")
       fiFilterEvent:ROW       = fiFilterAttribute:ROW
       fiFilterEvent:COL       = 12.0
       fiFilterEvent:WIDTH     = fiFilterAttribute:WIDTH
       hSideLabel              = fiFilterEvent:SIDE-LABEL-HANDLE
       hSideLabel:ROW          = fiFilterEvent:ROW
       hSideLabel:COL          = fiFilterEvent:COL - FONT-TABLE:GET-TEXT-WIDTH(hSideLabel:SCREEN-VALUE + ": ")
       FRAME frameFilter:VIRTUAL-WIDTH    = pdWidth - 2.5 - {&FOLDER_COL} + 1
       FRAME frameFilter:WIDTH    = FRAME frameFilter:VIRTUAL-WIDTH 
   NO-ERROR.

IF glFilterOn THEN 
  ASSIGN FRAME FrameFilter:VISIBLE    = TRUE
               fiFilterAttribute:VISIBLE = IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA =  "Attributes":U THEN TRUE ELSE FALSE
               coFilterGroup:VISIBLE     = fiFilterAttribute:VISIBLE
               fiFilterEvent:VISIBLE     = NOT fiFilterAttribute:VISIBLE.
ELSE
  FRAME FrameFilter:VISIBLE    = FALSE.
lok = ghBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
RUN overlayWidget.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowChange wiWin 
PROCEDURE rowChange :
/*------------------------------------------------------------------------------
  Purpose:     When the user changes the row, the attribute Description is displayed
              and the override toggle-box is set.
  Parameters:  <none>
  Notes:       Called from the value-changed trigger of the browse and from
               the initializeObject proc.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
DEFINE VARIABLE cOverride     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.

{get CurrentPage iCurrentPage}.

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  IF VALID-HANDLE(ghQuery) THEN
  DO:
    hBuffer = ghQuery:GET-BUFFER-HANDLE(1).
    IF hBuffer:AVAILABLE THEN
      ASSIGN
        hField          = hBuffer:BUFFER-FIELD("narrative":U)
        EdDescription:SCREEN-VALUE IN FRAME {&FRAME-NAME} = hField:BUFFER-VALUE
        hField          = hBuffer:BUFFER-FIELD("attrLabel":U)
        gcLastAttribute = hField:BUFFER-VALUE
        hField          = hBuffer:BUFFER-FIELD("resultCode":U)
        gcLastResultCode = hField:BUFFER-VALUE
        hField          = hBuffer:BUFFER-FIELD("override":U)
        cOverride       = hField:BUFFER-VALUE
        giBrowseRow     = ghBrowse:FOCUSED-ROW
        ToBox:CHECKED   = IF TRIM(cOverride) ="*":U THEN TRUE ELSE FALSE
       NO-ERROR.
  END.
END.
ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA =  "Events":U THEN
DO:
   IF VALID-HANDLE(ghEventQuery) THEN
   DO:
     hBuffer = ghEventQuery:GET-BUFFER-HANDLE(1).
     IF hBuffer:AVAILABLE THEN
       ASSIGN
         hField                = hBuffer:BUFFER-FIELD("eventName":U)
         gcLastEvent           = hField:BUFFER-VALUE
         hField                = hBuffer:BUFFER-FIELD("resultCode":U)
         gcLastEventResultCode = hField:BUFFER-VALUE
         hField                = hBuffer:BUFFER-FIELD("override":U)
         cOverride             = hField:BUFFER-VALUE
         giEventBrowseRow      = ghEventBrowse:FOCUSED-ROW
         ToBoxEvent:CHECKED    = IF TRIM(cOverride) ="*":U THEN TRUE ELSE FALSE
         NO-ERROR.
   END.

END.
   /* IF lookup type requires a selection list drop-down, set the button in place */
RUN overlayWidget .

RUN RowDisable.
  
ASSIGN ToBoxEvent:MODIFIED   = FALSE
       ToBox:MODIFIED        = FALSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowDisable wiWin 
PROCEDURE RowDisable :
/*------------------------------------------------------------------------------
  Purpose:     Turns the read-only value row of the attribute browse
               on and off 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDisableRow  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cLookupType  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.

/* Get the current buffer values for the lookupType and lookupValue */
{get CurrentPage iCurrentPage}.

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO:
    ASSIGN hField       = hBuffer:BUFFER-FIELD("isDisabled":U)
           lDisableRow  = hField:BUFFER-VALUE
           hField       = hBuffer:BUFFER-FIELD("LookupType":U)
           cLookupType  = hField:BUFFER-VALUE
           NO-ERROR .
       /* If row is disabled, set the read-only attribute accordigly */
    IF lDisableRow OR LOOKUP(cLookupType,"LIST,PROC,DIALOG-R":U) > 0 THEN
    DO:                             /* Browse requires the focus to be moved off the browse before */
      IF FOCUS = ghBrowse OR FOCUS = ghValueColumn THEN
      DO:
         APPLY "ENTRY":U TO coObject IN FRAME {&FRAME-NAME}.  /* the read-only is set to true */
         ghValueColumn:READ-ONLY = TRUE.
         APPLY "ENTRY":U TO ghValueColumn.
      END.
      ELSE
           ghValueColumn:READ-ONLY = TRUE.
    END.
    ELSE DO:
      ghValueColumn:READ-ONLY = FALSE.
      IF FOCUS = ghBrowse OR FOCUS = ghValueColumn THEN
         APPLY "ENTRY":U TO ghValueColumn.
    END.
    IF lDisableRow THEN
       ASSIGN ToBox:VISIBLE = FALSE
              buList:VISIBLE = FALSE
              buDIalog:VISIBLE = FALSE.
     ELSE
       ASSIGN ToBox:VISIBLE = IF ToBox:VISIBLE THEN TRUE ELSE FALSE
              buList:VISIBLE = IF buList:VISIBLE THEN TRUE ELSE FALSE
              buDIalog:VISIBLE = IF buDialog:VISIBLE THEN TRUE ELSE FALSE.

  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay wiWin 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:    Called from the Row_Display trigger of the browse 
              Sets the disabled fields top grey.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDisableRow  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
DEFINE VARIABLE hfield1      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfield2     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfield3      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfield4      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfield5      AS HANDLE     NO-UNDO.

/* Get the current buffer values for the lookupType and lookupValue */
{get CurrentPage iCurrentPage}.

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO:
    ASSIGN lDisableRow  = hBuffer:BUFFER-FIELD("isDisabled":U):BUFFER-VALUE
           .
       /* If row is disabled, set the read-only attribute accordigly */
    IF lDisableRow THEN
       ASSIGN ghGroupColumn:FGCOLOR  = 7
              ghLabelColumn:FGCOLOR  = 7
              ghResultColumn:FGCOLOR = 7
              ghGroupColumn:FGCOLOR  = 7
              ghValueColumn:FGCOLOR  = 7.
    ELSE
       ASSIGN ghGroupColumn:FGCOLOR  = ?
              ghLabelColumn:FGCOLOR  = ?
              ghResultColumn:FGCOLOR = ?
              ghGroupColumn:FGCOLOR  = ?
              ghValueColumn:FGCOLOR  = ?.
  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave wiWin 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Updates the temp table ttAttribute with the changed
               attribute value
  Parameters:  <none>
  Notes:      Called from ROW-LEAVE trigger of browse, MouseDoubleCLick and 
              SelectionList Value-Changed event
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferAttribute AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSelectedBuffer  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDefaultField    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
DEFINE VARIABLE hValueField      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hOverrideField   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLabel           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResultCode      AS CHARACTER NO-UNDO.
DEFINE VARIABLE hOverrideColumn  AS HANDLE    NO-UNDO.
DEFINE VARIABLE cObjectIDList    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCount           AS INTEGER   NO-UNDO.
DEFINE VARIABLE hQueryAttribute  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSelectedQuery   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cWhere           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOK              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cDataType        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLookupType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSelectedValue   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeFirst  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValue  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOverride        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lRefreshBrowse   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectNameList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cScreenValue     AS CHARACTER  NO-UNDO.

/* Get values from ttSelectedAttribute temp table */
IF VALID-HANDLE(ghQuery) THEN
DO:
  hBuffer = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
    ASSIGN
      hField          = hBuffer:BUFFER-FIELD("attrLabel":U)
      cLabel          = hField:BUFFER-VALUE
      hField          = hBuffer:BUFFER-FIELD("objectList":U)
      cObjectIDList   = hField:BUFFER-VALUE
      hField          = hBuffer:BUFFER-FIELD("resultCode":U)
      cResultCode     = hField:BUFFER-VALUE
      hField          = hBuffer:BUFFER-FIELD("dataType":U)
      cDataType       = hField:BUFFER-VALUE
      hField          = hBuffer:BUFFER-FIELD("lookupType":U)
      cLookupType     = hField:BUFFER-VALUE
      hOverrideColumn = ghBrowse:GET-BROWSE-COLUMN(1)
      hValueField     = hBuffer:BUFFER-FIELD("setValue":U)
      hOverrideField  = hBuffer:BUFFER-FIELD("override":U)
      NO-ERROR.
      
    /* If the toggle box is selected or the field is modified, set the attribute equal to the default value */
  IF VALID-HANDLE(ghValueColumn) AND 
      (ghValueColumn:MODIFIED OR ToBox:MODIFIED IN FRAME {&FRAME-NAME}) THEN
  DO:   /* Perform data validation */
     IF cLookupType = "" AND NOT ValidateField(cDataType,ghValueColumn:SCREEN-VALUE) THEN
     DO:
        MESSAGE SUBSTITUTE("Invalid property value. Enter a '&1' value.", cDataType)
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN ghValueColumn:SCREEN-VALUE = hValueField:BUFFER-VALUE
               ghValueColumn:MODIFIED     = FALSE.
        RETURN NO-APPLY.
     END.

     
     /* Format field */
     IF ghValueColumn:MODIFIED THEN
       ghValueColumn:SCREEN-VALUE = FormatField(cDataType,ghValueColumn:SCREEN-VALUE).
     /* Set the override toggle field to the value based on the toggle widget.
        If the toggle has been deselected, set the attr value to the default value */
    ASSIGN 
      ToBox:CHECKED                = IF ToBox:MODIFIED THEN ToBox:CHECKED ELSE TRUE
      hOverrideColumn:SCREEN-VALUE = IF ToBox:CHECKED OR ghValueColumn:MODIFIED THEN " *":U ELSE ""
      hOverrideField:BUFFER-VALUE  = hOverrideColumn:SCREEN-VALUE
      hDefaultField                = hBuffer:BUFFER-FIELD("defaultValue":U)
      ghValueColumn:SCREEN-VALUE   = IF NOT Tobox:CHECKED THEN  hDefaultField:BUFFER-VALUE ELSE ghValueColumn:SCREEN-VALUE
      hValueField:BUFFER-VALUE     = ghValueColumn:SCREEN-VALUE
      ghValueColumn:MODIFIED       = FALSE
      cScreenvalue                 = ghValueColumn:SCREEN-VALUE
      NO-ERROR.
  
   
    ASSIGN hBufferAttribute = DYNAMIC-FUNC("getBuffer":U IN ghProcLib,"ttAttribute":U).
    CREATE QUERY hQueryAttribute.
    hQueryAttribute:SET-BUFFERS(hBufferAttribute).
    
    IF cLabel BEGINS "(" AND SUBSTRING(cLabel,LENGTH(clabel),1) = ")" THEN
    DO:
      cAttributeFirst = DYNAMIC-FUNCTION("getAttributeFirst":U IN ghProcLib,WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA)).
      IF LOOKUP(SUBSTRING(cLabel,2,LENGTH(cLabel) - 2),cAttributeFirst,CHR(2)) > 0 THEN
        cLabel = SUBSTRING(cLabel,2,LENGTH(cLabel) - 2).
    END.
    
     
    /* The cObjectIDList stores a delimited list of the widgets to update.
       Retrieve the handle of the ttAttribute table and update the setValue with the
       value stored in the browse (hValueColumn) */
    ASSIGN cObjectNameList = coObject:PRIVATE-DATA.
    DO iCount = 1 TO NUM-ENTRIES(cObjectIDList):
      cWhere = "FOR EACH ttAttribute WHERE ":U +
                "ttAttribute.ObjectID = '":U + ENTRY(icount,cObjectIDList) + "' AND ":U +
                "ttAttribute.resultCode = '":U + cResultCode + "' AND ":U +
                "ttAttribute.attrLabel = '" + cLabel + "'".
      hQueryAttribute:QUERY-PREPARE(cWhere).
      lok = hQueryAttribute:QUERY-OPEN() NO-ERROR.
      hQueryAttribute:GET-FIRST().
      IF hBufferAttribute:AVAILABLE THEN
      DO:
        
        ASSIGN hField              = hBufferAttribute:BUFFER-FIELD("setValue":U)
               hDefaultField       = hBufferAttribute:BUFFER-FIELD("defaultValue":U)
               hField:BUFFER-VALUE = IF ToBox:CHECKED 
                                     THEN ghValueColumn:SCREEN-VALUE
                                     ELSE hDefaultField:BUFFER-VALUE
               cAttributeValue     = hField:BUFFER-VALUE
               hField              = hBufferAttribute:BUFFER-FIELD("objectName":U)
               cObjectName         = hField:BUFFER-VALUE
               hField              = hBufferAttribute:BUFFER-FIELD("RowModified":U)
               hField:BUFFER-VALUE = TRUE
               hField              = hBufferAttribute:BUFFER-FIELD("RowOverride":U)
               hField:BUFFER-VALUE =  IF TRIM(hOverrideColumn:SCREEN-VALUE) = "*":U THEN TRUE ELSE FALSE
               NO-ERROR.

        PUBLISH 'PropertyChangedAttribute':U FROM ghProcLib 
            (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA), /* calling proc */
             fiContainer:PRIVATE-DATA,                /* Container Name */
             cObjectName,                            /* Object Name */
             cResultCode,                             /* Result Code */
             cLabel,                                  /* attribute label */
             cAttributeValue,                   /* attribute value */
             cDataType,                              /* attribute data type */
             ToBox:CHECKED            ).
        /* If the value being set is for the master or default result code, assign the
        default value for the non-default result codes equal to this value */
        
        IF cResultCode = "" THEN
        DO:
           cWhere = "FOR EACH ttAttribute WHERE ":U +
                    "ttAttribute.ObjectID = '":U + ENTRY(icount,cObjectIDList) + "' AND ":U +
                    "ttAttribute.resultCode > ''  AND ":U +
                    "ttAttribute.attrLabel = '" + cLabel + "'".
           hQueryAttribute:QUERY-PREPARE(cWhere).
           lok = hQueryAttribute:QUERY-OPEN() NO-ERROR.
           hQueryAttribute:GET-FIRST().

           IF hBufferAttribute:AVAILABLE THEN
           DO:
             REPEAT:
                ASSIGN hField              = hBufferAttribute:BUFFER-FIELD("defaultValue":U)
                       hField:BUFFER-VALUE = ghValueColumn:SCREEN-VALUE
                       hField              = hBufferAttribute:BUFFER-FIELD("RowOverride":U)
                       lOverride           = hField:BUFFER-VALUE
                       hField              = hBufferAttribute:BUFFER-FIELD("setValue":U)
                       lRefreshBrowse      = TRUE.
                IF lOverride = FALSE OR lOverride = ? THEN
                   ASSIGN hField:BUFFER-VALUE = ghValueColumn:SCREEN-VALUE.

               hQueryAttribute:GET-NEXT().
               IF hQueryAttribute:QUERY-OFF-END THEN LEAVE.
             END. /* End Repeat */
           END. /* End if hBufferAttribute Availabel */
        END. /* END if cResultCode = "" */

      END. /* END If hBufferAttribute:Available */
    END.  /* END Do iCount = 1 to NUM-ENTRIES(cObjectList) */

    IF NUM-ENTRIES(cObjectIDList) > 0 THEN 
    DO:
      RUN refreshQuery (INPUT WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                        INPUT fiContainer:PRIVATE-DATA IN FRAME {&FRAME-NAME},
                        INPUT fiContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        INPUT cObjectNameList).
       ASSIGN hField          = hBuffer:BUFFER-FIELD("objectList":U)
              hField:BUFFER-VALUE = cObjectIDList
              hField     = hBuffer:BUFFER-FIELD("setValue":U)
              hField:BUFFER-VALUE  = IF TOBox:CHECKED THEN cScreenValue 
                                     ELSE hBuffer:BUFFER-FIELD("defaultValue":U):BUFFER-VALUE.
    END.

    IF lRefreshBrowse THEN
      DO:
         ASSIGN hSelectedBuffer = DYNAMIC-FUNC("getBuffer":U IN ghProcLib,"ttSelectedAttribute":U).
         CREATE QUERY hSelectedQuery.
         hSelectedQuery:SET-BUFFERS(hSelectedBuffer).
         cWhere       = "FOR EACH ttSelectedAttribute WHERE ttSelectedAttribute.resultCode > '' AND " +
                                       "ttSelectedAttribute.attrLabel = '" + cLabel + "'".
         hSelectedQuery:QUERY-PREPARE(cWhere).
         lok = hSelectedQuery:QUERY-OPEN() NO-ERROR.
         hSelectedQuery:GET-FIRST().
         IF hSelectedBuffer:AVAILABLE THEN
         DO:
           REPEAT:
             ASSIGN hField              = hSelectedBuffer:BUFFER-FIELD("override")
                    lOverride           = IF TRIM(hField:BUFFER-VALUE) = "*" THEN TRUE ELSE FALSE
                    hField              = hSelectedBuffer:BUFFER-FIELD("defaultValue")
                    hField:BUFFER-VALUE = ghValueColumn:SCREEN-VALUE
                    hField              = hSelectedBuffer:BUFFER-FIELD("setValue")
                   .
              IF lOverride = FALSE OR lOverride = ? THEN
                   ASSIGN hField:BUFFER-VALUE = ghValueColumn:SCREEN-VALUE.
             hSelectedQuery:GET-NEXT().
             IF hSelectedQuery:QUERY-OFF-END THEN LEAVE.
           END.
         END.
         DELETE OBJECT hSelectedQuery.
      END.
    DELETE OBJECT hQueryAttribute.
    /* Redisplay the newly set values.*/
  /*  ghBrowse:REFRESH().*/

  END.   /* END hValueColumn:MODIFIED */
END. /* VALID-HANDLE ghQuer */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeaveEvent wiWin 
PROCEDURE rowLeaveEvent :
/*------------------------------------------------------------------------------
   Purpose:     Updates the temp table ttEvent with the changed
               event values
  Parameters:  <none>
  Notes:      Called from ROW-LEAVE trigger of Event browseand  MouseDoubleCLick and 
              SelectionList Value-Changed event
     
------------------------------------------------------------------------------*/

DEFINE VARIABLE hQueryBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferEvent      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField            AS HANDLE    NO-UNDO.
DEFINE VARIABLE hAction           AS HANDLE    NO-UNDO.
DEFINE VARIABLE cEventName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE htype             AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTarget           AS HANDLE    NO-UNDO.
DEFINE VARIABLE hParameter        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDisabled         AS HANDLE    NO-UNDO.
DEFINE VARIABLE cResultCode       AS CHARACTER NO-UNDO.
DEFINE VARIABLE hOverrideCol      AS HANDLE    NO-UNDO.
DEFINE VARIABLE cObjectIDList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCount            AS INTEGER   NO-UNDO.
DEFINE VARIABLE hQueryEvent       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cWhere            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOK               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cDefaultAction    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDefaultType      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDefaultTarget    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDefaultParam     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDefaultDisabled  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lModified         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cFieldsModified   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRefreshBrowse    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOverride         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hSelectedBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedQuery    AS HANDLE     NO-UNDO.


/* Get values from ttSelectedAttribute temp table */
IF VALID-HANDLE(ghEventQuery) THEN
DO:
  hQueryBuffer = ghEventQuery:GET-BUFFER-HANDLE(1).
  IF hQueryBuffer:AVAILABLE THEN
    ASSIGN
      hOverrideCol    = ghEventBrowse:GET-BROWSE-COLUMN(1)
      hField          = ghEventBrowse:GET-BROWSE-COLUMN(2)
      cEventName      = hField:SCREEN-VALUE
      hField          = hQueryBuffer:BUFFER-FIELD("objectList":U)
      cObjectIDList   = hField:BUFFER-VALUE
      hAction         = ghEventBrowse:GET-BROWSE-COLUMN(3)
      hField          = ghEventBrowse:GET-BROWSE-COLUMN(4)
      cResultCode     = hField:SCREEN-VALUE
      hType           = ghEventBrowse:GET-BROWSE-COLUMN(5)
      hTarget         = ghEventBrowse:GET-BROWSE-COLUMN(6)
      hParameter      = ghEventBrowse:GET-BROWSE-COLUMN(7)
      hDisabled       = ghEventBrowse:GET-BROWSE-COLUMN(8)
      hField          = hQueryBuffer:BUFFER-FIELD("defaultAction":U)
      cDefaultAction  = hField:BUFFER-VALUE
      hField          = hQueryBuffer:BUFFER-FIELD("defaultType":U)
      cDefaultType  = hField:BUFFER-VALUE
      hField          = hQueryBuffer:BUFFER-FIELD("defaultTarget":U)
      cDefaultTarget  = hField:BUFFER-VALUE
      hField          = hQueryBuffer:BUFFER-FIELD("defaultParameter":U)
      cDefaultParam   = hField:BUFFER-VALUE
      hField          = hQueryBuffer:BUFFER-FIELD("defaultDisabled":U)
      lDefaultDisabled = hField:BUFFER-VALUE
      cFieldsModified  = (IF haction:MODIFIED THEN "eventAction":U ELSE CHR(3) ) + "," + 
                                     (IF hType:MODIFIED THEN "eventType":U ELSE CHR(3) ) + "," + 
                                     (IF hTarget:MODIFIED THEN "eventTarget":U ELSE CHR(3) ) + "," + 
                                     (IF hParameter:MODIFIED THEN "eventParameter":U ELSE CHR(3) ) + "," + 
                                     (IF hDisabled:MODIFIED THEN "eventDisabled":U ELSE CHR(3) ) 
      cFieldsModified  = REPLACE(cFieldsModified,CHR(3) + ",","")
      cFieldsModified  = REPLACE(cFieldsModified,CHR(3),"") .
  ELSE
     RETURN.
  /* If the toggle box is selected or the field is modified, set the attribute equal to the default value */
  IF  hAction:MODIFIED OR hType:MODIFIED OR hTarget:MODIFIED 
        OR hParameter:MODIFIED OR hDisabled:MODIFIED THEN
     lModified = TRUE.

  IF lModified OR ToBoxEvent:MODIFIED IN FRAME {&FRAME-NAME} THEN
  DO:   
     /* Set the override toggle field to the value based on the toggle widget.
        If the toggle has been deselected, set the attr value to the default value */
    ASSIGN 
      ToBoxEvent:CHECKED           = IF ToBoxEvent:MODIFIED THEN ToBoxEvent:CHECKED ELSE TRUE
      hOverrideCol:SCREEN-VALUE    = IF ToBoxEvent:CHECKED OR lModified THEN " *":U ELSE ""
      hField                       = hQueryBuffer:BUFFER-FIELD("override":U)
      hField:BUFFER-VALUE          = hOverrideCol:SCREEN-VALUE
      hField                       = hQueryBuffer:BUFFER-FIELD("eventAction":U)
      hField:BUFFER-VALUE          = IF NOT ToBoxEvent:CHECKED THEN cDefaultAction ELSE hAction:SCREEN-VALUE
      hAction:SCREEN-VALUE         = hField:BUFFER-VALUE
      hField                       = hQueryBuffer:BUFFER-FIELD("eventType":U)
      hField:BUFFER-VALUE          = IF NOT ToBoxEvent:CHECKED THEN cDefaultType ELSE hType:SCREEN-VALUE
      hType:SCREEN-VALUE           = hField:BUFFER-VALUE
      hField                       = hQueryBuffer:BUFFER-FIELD("eventTarget":U)
      hField:BUFFER-VALUE          = IF NOT ToBoxEvent:CHECKED THEN cDefaultTarget ELSE hTarget:SCREEN-VALUE
      hTarget:SCREEN-VALUE         = hField:BUFFER-VALUE
      hField                       = hQueryBuffer:BUFFER-FIELD("eventParameter":U)
      hField:BUFFER-VALUE          = IF NOT ToBoxEvent:CHECKED THEN cDefaultParam ELSE hParameter:SCREEN-VALUE
      hParameter:SCREEN-VALUE      = hField:BUFFER-VALUE
      hField                       = hQueryBuffer:BUFFER-FIELD("eventDisabled":U)
      hField:BUFFER-VALUE          = IF NOT ToBoxEvent:CHECKED THEN lDefaultDisabled ELSE hDisabled:SCREEN-VALUE
      hDisabled:SCREEN-VALUE       = hField:BUFFER-VALUE
      NO-ERROR.
     

    ASSIGN hBufferEvent = DYNAMIC-FUNC("getBuffer":U IN ghProcLib,"ttEvent":U).
    CREATE QUERY hQueryEvent.
    hQueryEvent:SET-BUFFERS(hBufferEvent).
    
    /* The cObjectIDList stores a delimited list of the widgets to update.
       Retrieve the handle of the ttAttribute table and update the setValue with the
       value stored in the browse (hValueColumn) */
    DO iCount = 1 TO NUM-ENTRIES(cObjectIDList):
      cWhere = "FOR EACH ttEvent WHERE ":U +
                " ttEvent.resultCode = '":U + cResultCode + "' AND ":U +
                " ttEvent.ObjectID = '":U + ENTRY(icount,cObjectIDList) + "' AND ":U +
                " ttEvent.eventName = '" + cEventName + "'".
      hQueryEvent:QUERY-PREPARE(cWhere).
      lok = hQueryEvent:QUERY-OPEN() NO-ERROR.
      hQueryEvent:GET-FIRST().
      IF hBufferEvent:AVAILABLE THEN
      DO:
        ASSIGN hField              = hBufferEvent:BUFFER-FIELD("eventAction":U)
               hField:BUFFER-VALUE = hAction:SCREEN-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("eventType":U)
               hField:BUFFER-VALUE = hType:SCREEN-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("eventTarget":U)
               hField:BUFFER-VALUE = hTarget:SCREEN-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("eventParameter":U)
               hField:BUFFER-VALUE = hParameter:SCREEN-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("eventDisabled":U)
               hField:BUFFER-VALUE = hDisabled:SCREEN-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("RowModified":U)
               hField:BUFFER-VALUE = TRUE
               hField              = hBufferEvent:BUFFER-FIELD("objectName":U)
               cObjectName         = hField:BUFFER-VALUE
               hField              = hBufferEvent:BUFFER-FIELD("RowOverride":U)
               hField:BUFFER-VALUE =  IF TRIM(hOverrideCol:SCREEN-VALUE) = "*":U THEN TRUE ELSE FALSE
               NO-ERROR.
        PUBLISH 'PropertyChangedEvent':U FROM ghProcLib 
           (WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA), /* calling proc */
            fiContainer:PRIVATE-DATA,                   /* Container Name */
            cObjectName,                                /* Object Name */
            cResultCode,                                /* Result Code */
            cEventName,                                 /* event Name */
            hAction:SCREEN-VALUE,                       /* Event Action */
            hType:SCREEN-VALUE,
            hTarget:SCREEN-VALUE,
            hParameter:SCREEN-VALUE,
            hDisabled:SCREEN-VALUE,
            ToBoxEvent:CHECKED,
           cFieldsModified).            
         /* If the value being set is for the master or default result code, assign the
        default value for the non-default result codes equal to this value */
        IF cResultCode = "" THEN
        DO:
           cWhere = "FOR EACH ttEvent WHERE ":U +
                    "ttEvent.ObjectID = '":U + ENTRY(icount,cObjectIDList) + "' AND ":U +
                    "ttEvent.resultCode > ''  AND ":U +
                    "ttEvent.eventName = '" + cEventName + "'".
           hQueryEvent:QUERY-PREPARE(cWhere).
           lok = hQueryEvent:QUERY-OPEN() NO-ERROR.
           hQueryEvent:GET-FIRST().
           IF hBufferEvent:AVAILABLE THEN
           DO:
             REPEAT:
               ASSIGN hField              = hBufferEvent:BUFFER-FIELD("defaultAction":U)
                      hField:BUFFER-VALUE = hAction:SCREEN-VALUE
                      hField              = hBufferEvent:BUFFER-FIELD("defaultType":U)
                      hField:BUFFER-VALUE = hType:SCREEN-VALUE
                      hField              = hBufferEvent:BUFFER-FIELD("defaultTarget":U)
                      hField:BUFFER-VALUE = hTarget:SCREEN-VALUE
                      hField              = hBufferEvent:BUFFER-FIELD("defaultParameter":U)
                      hField:BUFFER-VALUE = hParameter:SCREEN-VALUE
                      hField              = hBufferEvent:BUFFER-FIELD("defaultDisabled":U)
                      hField:BUFFER-VALUE = IF hDisabled:SCREEN-VALUE = "YES":U OR hDisabled:SCREEN-VALUE = "true":U THEN YES ELSE FALSE
                      hField              = hBufferEvent:BUFFER-FIELD("RowOverride":U)
                      lOverride           = hField:BUFFER-VALUE
                      lRefreshBrowse      = TRUE
                      NO-ERROR.
                      
                      IF lOverride = FALSE OR lOverride = ? THEN
                         ASSIGN hField              = hBufferEvent:BUFFER-FIELD("eventAction":U)
                                hField:BUFFER-VALUE =  hAction:SCREEN-VALUE
                                hField              = hBufferEvent:BUFFER-FIELD("eventType":U)
                                hField:BUFFER-VALUE = hType:SCREEN-VALUE
                                hField              = hBufferEvent:BUFFER-FIELD("eventTarget":U)
                                hField:BUFFER-VALUE = hTarget:SCREEN-VALUE
                                hField              = hBufferEvent:BUFFER-FIELD("eventParameter":U)
                                hField:BUFFER-VALUE = hParameter:SCREEN-VALUE
                                hField              = hBufferEvent:BUFFER-FIELD("eventDisabled":U)
                                hField:BUFFER-VALUE = IF hDisabled:SCREEN-VALUE = "YES":U OR hDisabled:SCREEN-VALUE = "true":U THEN YES ELSE FALSE
                                NO-ERROR.

               hQueryEvent:GET-NEXT().
               IF hQueryEvent:QUERY-OFF-END THEN LEAVE.
             END. /* End Repeat */
           END. /* End if hBufferAttribute Availabel */
        END. /* END if cResultCode = "" */
      END.
      /* IF the attribute being modified has a result code, set the resultCode override for the master
         to indicate that there exists a customized version */
    END.
    DELETE OBJECT hQueryEvent.

    /* Redisplay the newly set values.*/
    IF lRefreshBrowse THEN
    DO:
      ASSIGN hSelectedBuffer = DYNAMIC-FUNC("getBuffer":U IN ghProcLib,"ttSelectedEvent":U).
      CREATE QUERY hSelectedQuery.
      hSelectedQuery:SET-BUFFERS(hSelectedBuffer).
      cWhere       = "FOR EACH ttSelectedEvent WHERE ttSelectedEvent.resultCode > '' AND " +
                                    "ttSelectedEvent.eventName = '" + cEventName + "'".
      hSelectedQuery:QUERY-PREPARE(cWhere).
      lok = hSelectedQuery:QUERY-OPEN() NO-ERROR.
      hSelectedQuery:GET-FIRST().
      IF hSelectedBuffer:AVAILABLE THEN
      DO:
        REPEAT:
          ASSIGN hField              = hSelectedBuffer:BUFFER-FIELD("override")
                 lOverride           = IF TRIM(hField:BUFFER-VALUE) = "*" THEN TRUE ELSE FALSE
                 hField              = hSelectedBuffer:BUFFER-FIELD("defaultAction":U)
                 hField:BUFFER-VALUE = hAction:SCREEN-VALUE
                 hField              = hSelectedBuffer:BUFFER-FIELD("defaultType":U)
                 hField:BUFFER-VALUE = hType:SCREEN-VALUE
                 hField              = hSelectedBuffer:BUFFER-FIELD("defaultTarget":U)
                 hField:BUFFER-VALUE = hTarget:SCREEN-VALUE
                 hField              = hSelectedBuffer:BUFFER-FIELD("defaultParameter":U)
                 hField:BUFFER-VALUE = hParameter:SCREEN-VALUE
                 hField              = hSelectedBuffer:BUFFER-FIELD("defaultDisabled":U)
                 hField:BUFFER-VALUE = IF hDisabled:SCREEN-VALUE = "YES":U OR hDisabled:SCREEN-VALUE = "true":U THEN YES ELSE FALSE
                 hField              = hBufferEvent:BUFFER-FIELD("RowOverride":U)
                 NO-ERROR.
      
           IF lOverride = FALSE OR lOverride = ? THEN
                ASSIGN hField              = hSelectedBuffer:BUFFER-FIELD("eventAction":U)
                       hField:BUFFER-VALUE =  hAction:SCREEN-VALUE
                       hField              = hSelectedBuffer:BUFFER-FIELD("eventType":U)
                       hField:BUFFER-VALUE = hType:SCREEN-VALUE
                       hField              = hSelectedBuffer:BUFFER-FIELD("eventTarget":U)
                       hField:BUFFER-VALUE = hTarget:SCREEN-VALUE
                       hField              = hSelectedBuffer:BUFFER-FIELD("eventParameter":U)
                       hField:BUFFER-VALUE = hParameter:SCREEN-VALUE
                       hField              = hSelectedBuffer:BUFFER-FIELD("eventDisabled":U)
                       hField:BUFFER-VALUE = IF hDisabled:SCREEN-VALUE = "YES":U OR hDisabled:SCREEN-VALUE = "true":U THEN YES ELSE FALSE
                       NO-ERROR.
          hSelectedQuery:GET-NEXT().
          IF hSelectedQuery:QUERY-OFF-END THEN LEAVE.
        END.
      END.
      DELETE OBJECT hSelectedQuery.
/*      ghEventBrowse:REFRESH().   */
    END.
    
    
  END.   /* END hValueColumn:MODIFIED */
END. /* VALID-HANDLE ghQuer */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scrollWidget wiWin 
PROCEDURE scrollWidget :
/*------------------------------------------------------------------------------
  Purpose:    Used to reposition the overlayed widgets 
  Parameters:  <none>
  Notes:      Called from SCROLL persistent trigger 
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLookupType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hOverrideCol AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTypeCol     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTargetCol   AS HANDLE    NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER   NO-UNDO.
DEFINE VARIABLE lDisableRow  AS LOGICAL    NO-UNDO.

{get CurrentPage iCurrentPage}.

IF ((iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U)  THEN
DO:
  /* Get the current buffer values for the lookupType and lookupValue */
  ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO:
    ASSIGN hField       = hBuffer:BUFFER-FIELD("lookupType":U)
           cLookupType  = hField:BUFFER-VALUE
           hField       = hBuffer:BUFFER-FIELD("isDisabled":U)
           lDisableRow  = hField:BUFFER-VALUE
           NO-ERROR.
    /* If lookup type is LIST or PROC, position the (combo-box imitation) lookup button */
    IF cLookupType = "LIST":U OR cLookupType = "PROC":U THEN
    DO:
      IF ghValueColumn:Y < 0 OR ghValueColumn:X < 0 
         OR ghValueColumn:X + ghValueColumn:WIDTH-P + buList:WIDTH-P IN FRAME {&FRAME-NAME} > ghBrowse:WIDTH-P THEN
        buList:VISIBLE  = FALSE.
      ELSE
      DO:                                
        ASSIGN buList:Y              = ghValueColumn:Y + ghBrowse:Y
               buList:X              = ghValueColumn:X + ghBrowse:X + ghValueColumn:WIDTH-PIXELS
                                        - buList:WIDTH-PIXELS + 4
               buList:VISIBLE        = IF ldisableRow THEN FALSE ELSE TRUE
               NO-ERROR.
         buList:MOVE-TO-TOP().
      END.
    END. /* END IF cLookupType = "LIST" or "PROC" */
    /* IF the lookup type is DIALOG or DIALOG-R, position the lookup button [...] */
    ELSE IF cLookupType = "DIALOG":U OR cLookupType = "DIALOG-R":U THEN
    DO:
      IF ghValueColumn:Y < 0 OR ghValueColumn:X < 0 
         OR ghValueColumn:X + ghValueColumn:WIDTH-P + buDialog:WIDTH-P > ghBrowse:WIDTH-P THEN 
          buDialog:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.
      ELSE
      DO:
        ASSIGN buDialog:Y       = ghValueColumn:Y + ghBrowse:Y
               buDialog:X       = ghValueColumn:X + ghBrowse:X + ghValueColumn:WIDTH-PIXELS 
                                       - buDialog:WIDTH-PIXELS + 4
               buDialog:VISIBLE = IF ldisableRow THEN FALSE ELSE TRUE   /* For DIALOG-R, make the field read-only */
               NO-ERROR . 
        buDialog:MOVE-TO-TOP().
          
      END.
      ASSIGN  buList:VISIBLE = FALSE.
    END. /* END IF cLookupType = "DIALOG"  */
  END. /* END IF hBuffer:Available */
 

  /* Overlay the toggle-box to the current row */
  IF hBuffer:AVAILABLE AND VALID-HANDLE(ghBrowse) THEN
  DO:
    ASSIGN
      hOverrideCol = ghBrowse:GET-BROWSE-COLUMN(1)
      toBox:Y       = hOverrideCol:Y + ghBrowse:Y
      toBox:X       = hOverrideCol:X + ghBrowse:X - 1
      toBox:WIDTH-P = hOverrideCol:WIDTH-P + 3
      tobox:VISIBLE = IF hOverrideCol:Y < 0 OR hOverrideCol:X < 0 OR ldisableRow THEN FALSE ELSE TRUE
      
     NO-ERROR.
     tobox:MOVE-TO-TOP().
  END.
END.  /* End CurrentPage = 1 */
/* If on Page 2, set overlay widgets for Event Browse */
ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA =  "Events":U THEN
DO:
  ASSIGN buList:VISIBLE     = FALSE
         buDialog:VISIBLE   = FALSE
         toBox:VISIBLE      = FALSE
         hTypeCol           = ghEventBrowse:GET-BROWSE-COLUMN(5)
         hTargetCol         = ghEventBrowse:GET-BROWSE-COLUMN(6)
         hOverrideCol       = ghEventBrowse:GET-BROWSE-COLUMN(1)
         toBoxEvent:Y       = hOverrideCol:Y + ghBrowse:Y
         toBoxEvent:X       = hOverrideCol:X + ghBrowse:X - 1
         toBoxEvent:WIDTH-P = hOverrideCol:WIDTH-P + 3
         toBoxEvent:VISIBLE = IF hOverrideCol:Y < 0 OR hOverrideCol:X < 0  THEN FALSE ELSE TRUE
         buList:VISIBLE     = IF hTypeCol:Y < 0 OR hTypeCol:X < 0 
                                 OR hTypeCol:X + hTypeCol:WIDTH-P + buList:WIDTH-P > ghEventBrowse:WIDTH-P
                              THEN FALSE
                              ELSE TRUE
         buList:Y           = hTypeCol:Y + ghEventBrowse:Y
         buList:X           = hTypeCol:X + ghEventBrowse:X + hTypeCol:WIDTH-PIXELS - buList:WIDTH-PIXELS + 4
         buList-2:VISIBLE   = IF hTargetCol:Y < 0 OR hTargetCol:X < 0 
                                OR hTargetCol:X + hTargetCol:WIDTH-P + buList-2:WIDTH-P > ghEventBrowse:WIDTH-P
                              THEN FALSE
                              ELSE TRUE
         buList-2:Y         = hTargetCol:Y + ghEventBrowse:Y
         buList-2:X         = hTargetCol:X + ghEventBrowse:X + hTargetCol:WIDTH-PIXELS - buList-2:WIDTH-PIXELS + 4
         NO-ERROR.
  buList-2:MOVE-TO-TOP().
  buList:MOVE-TO-TOP().
  toboxEvent:MOVE-TO-TOP().
  
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectionListPlacement wiWin 
PROCEDURE selectionListPlacement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cLookupValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLookupType  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTarget      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
DEFINE VARIABLE hType        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.


{get CurrentPage iCurrentPage}.


IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  ASSIGN hBuffer      = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      hField                    = hBuffer:BUFFER-FIELD("lookupValue":U)
      cLookupValue              = hField:BUFFER-VALUE
      hField                    = hBuffer:BUFFER-FIELD("lookupType":U)
      cLookupType               = hField:BUFFER-VALUE 
      NO-ERROR.
    IF cLookupType = "PROC":U THEN 
    DO:
       RUN VALUE(cLookupValue) NO-ERROR.
       ASSIGN cLookupValue = RETURN-VALUE.
    END.
    ASSIGN
      SelLookup:DELIMITER       = CHR(3)
      SelLookup:HEIGHT          = MAX(1,MIN(6,INT(NUM-ENTRIES(cLookupValue,CHR(3)) / 2 ) ))
      SelLookup:WIDTH-P         = ghValueColumn:WIDTH-P + 6
      SelLookup:Y               = IF ghValueColumn:Y + ghBrowse:Y + ghValueColumn:HEIGHT-PIXELS + SelLookup:HEIGHT-P < FRAME {&FRAME-NAME}:HEIGHT-P
                                  THEN ghValueColumn:Y + ghBrowse:Y + ghValueColumn:HEIGHT-PIXELS 
                                  ELSE ghValueColumn:Y + ghBrowse:Y - SelLookup:HEIGHT-P 
      SelLookup:X               = ghValueColumn:X + ghBrowse:X - 2
      SelLookup:LIST-ITEM-PAIRS = cLookupValue
      SelLookup:SCREEN-VALUE    = ghValueColumn:SCREEN-VALUE
      SelLookup:VISIBLE         = TRUE
      lok                       = SelLookup:MOVE-TO-TOP()
      NO-ERROR. 
    APPLY "ENTRY":U TO SelLookup.   
  END.
END.
ELSE IF(iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U THEN 
DO:
  ASSIGN hBuffer = ghEventQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
     ASSIGN
         hField  = hBuffer:BUFFER-FIELD("eventType":U)
         cType   = hField:BUFFER-VALUE
         hField  = hBuffer:BUFFER-FIELD("eventTarget":U)
         cTarget = hField:BUFFER-VALUE
         SelLookup:DELIMITER       =  CHR(3)
         SelLookup:LIST-ITEM-PAIRS = IF SELF:NAME = "buList":U 
                                     THEN "RUN" + CHR(3) + "RUN":U + CHR(3) + "PUBLISH" + CHR(3) + "PUB":U
                                     ELSE gcManagerList
         SelLookup:SCREEN-VALUE    = IF SELF:NAME = "buList":U THEN  cType ELSE cTarget
         hType                     = ghEventBrowse:GET-BROWSE-COLUMN(5)
         hTarget                   = ghEventBrowse:GET-BROWSE-COLUMN(6)
         SelLookup:WIDTH-P         = IF SELF:NAME = "buList":U THEN hType:WIDTH-P + 6 ELSE hTarget:WIDTH-P + 6
         SelLookup:HEIGHT          = MAX(1,MIN(6,INT(NUM-ENTRIES(SelLookup:LIST-ITEM-PAIRS,CHR(3)) / 2 ) ))
         SelLookup:Y               = IF   hType:Y + ghEventBrowse:Y + hType:HEIGHT-PIXELS + SelLookup:HEIGHT-P <  {&WINDOW-NAME}:HEIGHT-P
                                     THEN hType:Y + ghEventBrowse:Y + hType:HEIGHT-PIXELS 
                                     ELSE hType:Y + ghEventBrowse:Y - SelLookup:HEIGHT-P 
         SelLookup:X               = IF SELF:NAME = "buList":U 
                                     THEN  hType:X + ghEventBrowse:X - 2
                                     ELSE  hTarget:X + ghEventBrowse:X - 2
         SelLookup:VISIBLE         = TRUE
         lok                       = SelLookup:MOVE-TO-TOP()
         NO-ERROR.
    APPLY "ENTRY":U TO SelLookup.   
END.
  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wiWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

 DEFINE VARIABLE iCurrentpage AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
 
  /* Code placed here will execute PRIOR to standard behavior. */
 {get CurrentPage iCurrentPage}.

 /* Lock the window to avoid flickering */
 lockWindow(TRUE).
 
 RUN SUPER( INPUT piPageNum).
 
 IF h_folder:PRIVATE-DATA = "Attributes":U THEN
    piPageNum = 1.
 ELSE IF h_folder:PRIVATE-DATA = "Events":U THEN
    piPageNum = 2.

 IF NOT VALID-HANDLE(ghBrowse)  OR NOT VALID-HANDLE(ghEventBrowse) THEN
 DO:
      /* Unlocking window as operation is finished */
      lockWindow(FALSE).
      RETURN.
 END.
 
    /* Code placed here will execute AFTER standard behavior.    */
 DO WITH FRAME {&FRAME-NAME}:
   IF piPageNum = 2 THEN 
   DO:
      ASSIGN fiFilterAttribute:VISIBLE IN FRAME FrameFilter = FALSE
             coFilterGroup:VISIBLE     = FALSE 
             buList:VISIBLE            = FALSE
             buDialog:VISIBLE          = FALSE
             ToBox:VISIBLE             = FALSE
             SelLookup:VISIBLE         = FALSE
             toBox:VISIBLE             = FALSE
             toBoxEvent:VISIBLE        = TRUE
             fiFilterEvent:VISIBLE     = TRUE
             buDialog:VISIBLE          = FALSE
             buList:VISIBLE            = FALSE
             ghEventBrowse:VISIBLE     = TRUE
             ghBrowse:VISIBLE          = FALSE
             hBuffer                   = ghEventQuery:GET-BUFFER-HANDLE(1)
             NO-ERROR.
      IF hBuffer:AVAILABLE THEN
         ASSIGN hField                = hBuffer:BUFFER-FIELD("override":U)
                ToBoxEvent:CHECKED    = IF TRIM(hfield:BUFFER-VALUE) ="*":U THEN TRUE ELSE FALSE
                NO-ERROR.
      IF VALID-HANDLE(ghEventBrowse) THEN
        APPLY "ENTRY":U TO ghEventBrowse.
   END.
   ELSE 
   DO:  /* Page = 1 */
      ASSIGN fiFilterAttribute:VISIBLE = IF glFilterOn THEN TRUE ELSE FALSE
             coFilterGroup:VISIBLE     = IF glFilterOn THEN TRUE ELSE FALSE 
             fiFilterEvent:VISIBLE     = FALSE  
             toBoxEvent:VISIBLE        = FALSE
             ghBrowse:VISIBLE          = TRUE
             ghEventBrowse:VISIBLE     = FALSE 
             hBuffer                   = ghQuery:GET-BUFFER-HANDLE(1)
             NO-ERROR.
       IF hBuffer:AVAILABLE THEN
         ASSIGN
            hField          = hBuffer:BUFFER-FIELD("override":U)
            ToBox:CHECKED   = IF TRIM(hField:BUFFER-VALUE) ="*":U THEN TRUE ELSE FALSE
             NO-ERROR.
      IF VALID-HANDLE(ghBrowse) THEN
        APPLY "ENTRY":U TO ghBrowse.
   END.
   
   RUN resizeObject IN THIS-PROCEDURE (INPUT {&WINDOW-NAME}:HEIGHT,
                                       INPUT {&WINDOW-NAME}:WIDTH,
                                       INPUT NO 
                                      ).
                                       
   RUN setFilterClear.

   RUN RowDisable.

   

   /* Unlocking window as operation is finished */
   lockWindow(FALSE).
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilterClear wiWin 
PROCEDURE setFilterClear :
/*------------------------------------------------------------------------------
  Purpose:     Used to make the filter button either disabled or enabled
  Parameters: 
  Notes:       This is dependent on the selected page.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.
 
 {get CurrentPage iCurrentPage}.
 
 IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
 DO:
    IF fiFilterAttribute:SCREEN-VALUE IN FRAME FrameFilter = "" 
        AND coFilterGroup:SCREEN-VALUE IN FRAME FrameFilter = "<ALL>":U THEN
    DO:
      buFilterClear:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
      buFilterClear:LOAD-IMAGE("ry/img/funnel.gif":U).
    END.
   ELSE DO:
     buFilterClear:LOAD-IMAGE("ry/img/filterapp.gif":U).
     buFilterClear:SENSITIVE = TRUE.
   END.
 END.
 ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U THEN
 DO:
   IF fiFilterEvent:SCREEN-VALUE = ""  THEN
   DO:
     buFilterClear:SENSITIVE = FALSE.
     buFilterClear:LOAD-IMAGE("ry/img/funnel.gif":U).
   END.
   ELSE
   DO:
     buFilterClear:LOAD-IMAGE("ry/img/filterapp.gif":U).
     buFilterClear:SENSITIVE = TRUE.
   END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch wiWin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCurColumn    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lRefresh      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hCallingProc  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNewColumn    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAsc          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentCol   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.

{get CurrentPage iCurrentPage}.

IF (iCurrentPage = 1 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Attributes":U THEN
DO:
  ASSIGN hCurColumn  = ghBrowse:CURRENT-COLUMN
         cCurrentCol = hCurColumn:NAME.

  IF VALID-HANDLE(hCurColumn) THEN
  DO:
     IF ENTRY(1,gcLastColumn," ") = hCurColumn:NAME THEN
        ASSIGN cAsc = IF ENTRY(2,gcLastColumn," ") = "ASC" THEN "DESC":U ELSE "":U.
     IF hCurColumn:NAME= "override":U AND ENTRY(1,gcLastColumn," ") <> "override":U THEN
           cAsc = "DESC":U.
        /* Specify secondary sort criteria dependent on column selected */
     ASSIGN gcBYClause   = " BY " + hCurColumn:NAME + " " + cAsc 
                            + (IF hCurColumn:NAME = "attrLabel":U THEN " BY resultCode ":U 
                               ELSE IF hCurColumn:NAME = "override":U THEN " BY attrLabel " 
                                ELSE IF hCurColumn:NAME = "setValue":U THEN " BY attrLabel "
                                 ELSE " BY attrLabel ":U)
                            + (IF ENTRY(NUM-ENTRIES(gcByClause," "),gcByClause," ") = cAsc THEN "" ELSE cAsc)
            gcLastColumn = hCurColumn:NAME + " " + (IF cAsc = "" THEN "ASC":U ELSE "DESC":U)
            hColumn      = ghBrowse:GET-BROWSE-COLUMN(1)  /* Override Column */
            hColumn:LABEL = ""
            hColumn      = ghBrowse:GET-BROWSE-COLUMN(2)    /* Label Column */
            hColumn:LABEL = "Attribute"
            hColumn      = ghBrowse:GET-BROWSE-COLUMN(3)  /* Value Column  */
            hColumn:LABEL = "Value"
            hColumn      = ghBrowse:GET-BROWSE-COLUMN(4)  /* Result Column  */
            hColumn:LABEL = "Result Code"
            hColumn      = ghBrowse:GET-BROWSE-COLUMN(5)  /* Group Column  */
            hColumn:LABEL = "Group"
            hCurColumn:LABEL = hCurColumn:LABEL + " ^"
            NO-ERROR.

     glSkipObjectList = YES.
     RUN refreshQuery ( INPUT WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                     INPUT fiContainer:PRIVATE-DATA IN FRAME {&FRAME-NAME},
                     INPUT fiContainer:SCREEN-VALUE  ,
                     INPUT coObject:PRIVATE-DATA).
     glSkipObjectList = NO.
  END.
END.
ELSE IF (iCurrentPage = 2 AND h_folder:PRIVATE-DATA = "") OR h_folder:PRIVATE-DATA = "Events":U  THEN
DO:
   ASSIGN hCurColumn  = ghEventBrowse:CURRENT-COLUMN
          cCurrentCol = hCurColumn:NAME.

   IF VALID-HANDLE(hCurColumn) THEN
   DO:
      IF ENTRY(1,gcLastEventColumn," ") = hCurColumn:NAME THEN
         ASSIGN cAsc = IF ENTRY(2,gcLastEventColumn,"") = "ASC" THEN "DESC":U ELSE "":U.
      IF hCurColumn:NAME= "override":U AND ENTRY(1,gcLastEventColumn," ") <> "override":U THEN
            cAsc = "DESC":U.
         /* Specify secondary sort criteria dependent on column selected */
      ASSIGN gcEventBYClause   = " BY " + hCurColumn:NAME + " " + cAsc 
                                 + (IF hCurColumn:NAME = "eventName":U THEN " BY resultCode ":U 
                                    ELSE IF hCurColumn:NAME = "override":U THEN " BY eventName " 
                                    ELSE " BY eventName ":U )
                                 + cAsc
             gcLastEventColumn = hCurColumn:NAME + " " + (IF cAsc = "" THEN "ASC":U ELSE "DESC":U)
             hColumn           = ghEventBrowse:GET-BROWSE-COLUMN(1)  /* Override Column */
             hColumn:LABEL     = ""
             hColumn           = ghEventBrowse:GET-BROWSE-COLUMN(2)    /*Event Column */
             hColumn:LABEL = "Event"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(3)  /* Action Column  */
             hColumn:LABEL = "Action"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(4)  /* Result Column  */
             hColumn:LABEL = "Result Code"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(5)  /* Type Column  */
             hColumn:LABEL = "Type"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(6)  /* Target Column */
             hColumn:LABEL = "Target"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(7)  /* Parameter  */
             hColumn:LABEL = "Parameter"
             hColumn      = ghEventBrowse:GET-BROWSE-COLUMN(8)  /* Disabled  */
             hColumn:LABEL = "Disabled"
             hCurColumn:LABEL = hCurColumn:LABEL + " ^"
             NO-ERROR.

      glSkipObjectList = YES.
      RUN refreshQuery ( INPUT WIDGET-HANDLE({&WINDOW-NAME}:PRIVATE-DATA),
                     INPUT fiContainer:PRIVATE-DATA IN FRAME {&FRAME-NAME},
                     INPUT fiContainer:SCREEN-VALUE  ,
                     INPUT coObject:PRIVATE-DATA).
      glSkipObjectList = NO.
   END.
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoRow wiWin 
PROCEDURE undoRow :
/*------------------------------------------------------------------------------
  Purpose:    Undoes the entered value 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.

IF VALID-HANDLE(ghQuery) THEN
DO:
  hBuffer = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
    ASSIGN hField                     = hBuffer:BUFFER-FIELD("setValue":U) 
           ghValueColumn:SCREEN-VALUE = hField:BUFFER-VALUE
           ghValueColumn:MODIFIED     = FALSE
           NO-ERROR.
END.

RETURN NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FormatField wiWin 
FUNCTION FormatField RETURNS CHARACTER
 ( pcDataType AS CHAR,
    pcValue    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Validates that the value field is 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iType          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE deType         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE daType         AS DATE       NO-UNDO.
  DEFINE VARIABLE cFormatString  AS CHARACTER  NO-UNDO.

  ASSIGN cFormatString = pcValue.
  
 
  CASE pcDataType:
     WHEN "INTEGER":U OR WHEN "INT":U THEN
     DO:
        iType = INTEGER(pcValue) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
          cFormatString = STRING(iType).
     END.
     WHEN "DECIMAL":U OR WHEN "DEC":U THEN
     DO:
        deType = DECIMAL(pcValue) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
          cFormatString = STRING(deType).
     END.
     WHEN "DATE":U THEN
     DO:
        daType = DATE(pcValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          cFormatString = STRING(daType).
     END.

  END CASE.
  RETURN cFormatString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttribute wiWin 
FUNCTION getAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current attribute name
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.

  hBuffer = ghQuery:GET-BUFFER-HANDLE(1).
  IF hBuffer:AVAILABLE THEN
  DO:
    ASSIGN hField        = hBuffer:BUFFER-FIELD("attrLabel":U).
    RETURN hField:BUFFER-VALUE.   /* Function return value. */
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBYClause wiWin 
FUNCTION getBYClause RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the BY clause used to refresh the query
    Notes:  
------------------------------------------------------------------------------*/
  IF pcTable = "Attribute":U THEN
    RETURN gcByClause.   /* Function return value. */
  ELSE IF pcTable = "Event":U THEN
    RETURN gcEventByClause.
  ELSE
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEvent wiWin 
FUNCTION getEvent RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Reurns the current Event
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField AS HANDLE     NO-UNDO.

  hField          = ghEventBrowse:GET-BROWSE-COLUMN(2).
  RETURN hField:SCREEN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagers wiWin 
FUNCTION getManagers RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of valid managers that may be used
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hParam           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hManager         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hManagerBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cManagerList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.

RUN obtainCFMTables IN THIS-PROCEDURE (OUTPUT hParam, OUTPUT hManager).

ASSIGN hManagerBuffer = hManager:DEFAULT-BUFFER-HANDLE.

CREATE QUERY hQuery.
hQuery:ADD-BUFFER(hManagerBuffer).
hQuery:QUERY-PREPARE("FOR EACH ":U + hManagerBuffer:NAME + " NO-LOCK:":U).
hQuery:QUERY-OPEN() NO-ERROR.
REPEAT:
  hQuery:GET-NEXT().
  IF hQuery:QUERY-OFF-END THEN LEAVE.
  ASSIGN hField       = hManagerBuffer:BUFFER-FIELD("cManagerName":U)
         cFieldName   = hField:BUFFER-VALUE
         cManagerList = cManagerList + (IF cManagerList = "" THEN "" ELSE CHR(3))
                 + cFieldName + CHR(3) + cFieldName.
END.
DELETE OBJECT hQuery.


RETURN cManagerList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextItem wiWin 
FUNCTION getNextItem RETURNS CHARACTER
  ( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the next item of a list-item 
            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNextValue  AS CHARACTER  NO-UNDO.
  count-loop:
  DO icount = 1 TO NUM-ENTRIES(pcListItem,pcDelim):
    IF ENTRY(icount,pcListItem,pcDelim) = pcValue THEN
    DO:
       IF icount + 1 > NUM-ENTRIES(pcListItem,pcDelim) THEN
          cNextValue = ENTRY(1, pcListItem,pcDelim).
       ELSE
          cNextValue = ENTRY(icount + 1, pcListItem,pcDelim).
       LEAVE count-loop.
    END.
  END.

  RETURN cNextValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextItemPair wiWin 
FUNCTION getNextItemPair RETURNS CHARACTER
 ( pcListItemPair AS CHAR,
    pcValue       AS CHAR,
    pcDelim       AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the next item of a list-item-pair 
            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNextValue  AS CHARACTER  NO-UNDO.
  count-loop:
  DO icount = 2 TO NUM-ENTRIES(pcListItemPair,pcDelim) BY 2:
    IF ENTRY(icount,pcListItemPair,pcDelim) = pcValue THEN
    DO:
       IF icount + 2 > NUM-ENTRIES(pcListItemPair,pcDelim) THEN
          cNextValue = ENTRY(2, pcListItemPair,pcDelim).
       ELSE
          cNextValue = ENTRY(icount + 2, pcListItemPair,pcDelim).
       LEAVE count-loop.
    END.
  END.

  RETURN cNextValue.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrevItem wiWin 
FUNCTION getPrevItem RETURNS CHARACTER
 ( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the previous item of a list-item 
            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNextValue  AS CHARACTER  NO-UNDO.
  count-loop:
  DO icount =  1 TO NUM-ENTRIES(pcListItem,pcDelim) :
    IF ENTRY(icount,pcListItem,pcDelim) = pcValue THEN
    DO:
       IF icount = 1 THEN
          cNextValue = ENTRY(NUM-ENTRIES(pcListItem,pcDelim), pcListItem,pcDelim).
       ELSE
          cNextValue = ENTRY(icount - 1, pcListItem,pcDelim).
       LEAVE count-loop.
    END.
  END.

  RETURN cNextValue.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrevItemPair wiWin 
FUNCTION getPrevItemPair RETURNS CHARACTER
( pcListItem AS CHAR,
    pcValue    AS CHAR,
    pcDelim    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the previous item of a list-item pair
            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNextValue  AS CHARACTER  NO-UNDO.
  count-loop:
  DO icount =  2 TO NUM-ENTRIES(pcListItem,pcDelim) BY 2:
    IF ENTRY(icount,pcListItem,pcDelim) = pcValue THEN
    DO:
       IF icount = 2 THEN
          cNextValue = ENTRY(NUM-ENTRIES(pcListItem,pcDelim), pcListItem,pcDelim).
       ELSE
          cNextValue = ENTRY(icount - 2, pcListItem,pcDelim).
       LEAVE count-loop.
    END.
  END.

  RETURN cNextValue.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProcLib wiWin 
FUNCTION getProcLib RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the procedure library 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghProcLib.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRepositionQuery wiWin 
FUNCTION getRepositionQuery RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN glRepositionQuery.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResultCode wiWin 
FUNCTION getResultCode RETURNS CHARACTER
  ( OUTPUT plResultCodeDisabled AS LOG) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN plResultCodeDisabled = glResultCodeDisabled.

  RETURN gcResultCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow wiWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode AS INTEGER    NO-UNDO.

  IF plLockWindow AND {&WINDOW-NAME}:HWND EQ ? THEN
       RETURN FALSE. 

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT {&WINDOW-NAME}:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setByClause wiWin 
FUNCTION setByClause RETURNS LOGICAL
  (  pcTable AS CHAR,
     pcByClause AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF pcTable = "Attribute":U THEN
    gcByClause = pcByClause.
  ELSE IF pcTable = "Event":U THEN
    gcEventByClause = pcByClause.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerLabel wiWin 
FUNCTION setContainerLabel RETURNS LOGICAL
  ( pcNewLabel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN fiContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcNewLabel.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectList wiWin 
FUNCTION setObjectList RETURNS LOGICAL
  ( phCallingProc AS HANDLE,
    pcContainerName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Used to update the object combo-box.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCurrentObjectLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentObjectName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectLabels       AS CHARACTER  NO-UNDO.

ASSIGN cCurrentObjectLabel =  coObject:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
       cCurrentObjectName   = IF gcObjectNameList > "" 
                                 THEN ENTRY(coObject:LOOKUP(coObject:SCREEN-VALUE), gcObjectNameList,CHR(3)) 
                                 ELSE cCurrentObjectLabel
       NO-ERROR.
    
IF VALID-HANDLE(ghProcLib) THEN
    gcObjectNameList = DYNAMIC-FUNC("getObjectList":U IN ghProcLib, 
                                    phCallingProc,pcContainerName, OUTPUT cObjectLabels).

ASSIGN coObject:LIST-ITEMS   = cObjectLabels 
       coObject:SCREEN-VALUE = ENTRY(LOOKUP(cCurrentObjectName,gcObjectNameList,CHR(3)), coObject:LIST-ITEMS, CHR(3))
       NO-ERROR.

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRepositionQuery wiWin 
FUNCTION setRepositionQuery RETURNS LOGICAL
  ( plRepositionQuery AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Sets the RepositionQuery Flag on or off which is used in 
           refreshquery proc of property sheet window
    Notes:  
------------------------------------------------------------------------------*/
  glRepositionQuery = plRepositionQuery.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResultCode wiWin 
FUNCTION setResultCode RETURNS LOGICAL
  ( pcResultCode AS CHAR,
    plDisabled   AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN gcResultCode       = IF pcResultCode <> ? AND pcResultCode <> "?" THEN pcResultCode ELSE gcResultCode
           glResultCodeDisabled = IF plDisabled <> ? THEN plDisabled  ELSE glResultCodeDisabled
         NO-ERROR.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ValidateField wiWin 
FUNCTION ValidateField RETURNS LOGICAL
  ( pcDataType AS CHAR,
    pcValue    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Validates that the value field is 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iType          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE deType         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE daType         AS DATE       NO-UNDO.
  DEFINE VARIABLE lValidationOK  AS LOGICAL    NO-UNDO INIT YES.
  
  CASE pcDataType:
     WHEN "LOGICAL":U OR WHEN "LOG":U THEN 
     DO:
       IF LOOKUP(pcValue,"Yes,No,true,False") = 0 THEN
         lValidationOK = NO.
     END.
     WHEN "INTEGER":U OR WHEN "INT":U THEN
     DO:
        iType = INTEGER(pcValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          lValidationOK = NO.
     END.
     WHEN "DECIMAL":U OR WHEN "DEC":U THEN
     DO:
        deType = DECIMAL(pcValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          lValidationOK = NO.
     END.
     WHEN "DATE":U THEN
     DO:
        daType = DATE(pcValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          lValidationOK = NO.
     END.

  END CASE.
  



  RETURN lValidationOK.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

