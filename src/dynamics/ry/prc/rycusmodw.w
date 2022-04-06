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
/*---------------------------------------------------------------------------------
  File:         ry/prc/rycusmodw.w
  
  Description:  Presents users with a resizeable window containing 2 selection lists,
                and a combo box.  The selection list on the left shows users the available
                customization types and the selection list on the right shows the customization
                types chossen and their sequence indicates their priority.  When a 
                customization type is selected from the right side, is may be moved up, down,
                to the top, to the bottom or back to the left. Also, when it is selected the
                combo-box will show the possible result codes for that customization type.
                When the user selects a result code and presses the "Use" button, it will
                appear in parentheses after the customization type in the right column.
                
                All customization types in the right column must have an associated result code
                when the OK button is pressed.
                
                The window is emulated to be a dialog by making all other windows in the 
                session insensitive.

  Purpose:      Provide users with the ability to reset the session parameter for customization
                type priority.

  Parameters:   pgcTextString    Delimited list (based on specified delimiter) of Window Title, 
                                 Available label, Selected label. If blank, defaults to 'Select', 
                                 'Available', 'Selected'.
                pgcDelimiter     Delimiter used for lists
                pglUseImages     If Yes, images are loaded for the buttons
                pglSortAvailable If Yes, The Available selection list is sorted
                pglSortSelected  If Yes, the sort buttons (Up,down,top,bottom) appear, else they are hidden
                pglUseListPairs  If yes, the next 2 lists will be list item pairs
                pgcAvailableList List of all available items (either list-items or list-item-pairs)
   Input-Output pgcSelectedList  List of all selected items
   Output       plOK             Yes if OK is selected.
  
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/06/2003  Author:   Don Bulua

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

&scop object-name       rycusmodw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
  DEFINE INPUT  PARAMETER pgcTextString    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pgcDelimiter     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pglUseImages     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pglSortAvailable AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pglSortSelected  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pglUseListPairs  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pgcAvailableList AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pgcSelectedList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plOK          AS logical no-undo.
  
/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

 /* Stores a delimited string of all window handles of the session */
DEFINE VARIABLE gcWindowHandles AS CHARACTER  NO-UNDO.
/* Stores a delimited string indicating whether the window was sensitive or not corresponding 
   to the gcWindowHandles string */
DEFINE VARIABLE gcWindowState   AS CHARACTER  NO-UNDO. 

&SCOPED-DEFINE WIDGET-SPACE 5 /* Defines the pixels between the selection list and the buttons */
&SCOPED-DEFINE MIN-HEIGHT 10
&SCOPED-DEFINE MIN-WIDTH  50

{adecomm/oeideservice.i}
{src/adm2/globals.i}

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
&Scoped-Define ENABLED-OBJECTS seAvailable seSelected buAdd buUp buRemove ~
buDown buAddAll buTop buRemoveAll buBottom buUse cbResultCode buCancel ~
buClear fiAvailable fiSelected 
&Scoped-Define DISPLAYED-OBJECTS seAvailable seSelected cbResultCode ~
fiAvailable fiSelected 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stripResultCode wiWin 
FUNCTION stripResultCode RETURNS CHARACTER
  ( INPUT cValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "&Add >" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add available item"
     BGCOLOR 8 .

DEFINE BUTTON buAddAll 
     LABEL "Add Al&l >>" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add all available items"
     BGCOLOR 8 .

DEFINE BUTTON buBottom 
     LABEL "&Bottom" 
     SIZE 9 BY 1.14 TOOLTIP "Move selected item to bottom"
     BGCOLOR 8 .

DEFINE BUTTON buCancel 
     LABEL "Cancel" 
     SIZE 15 BY 1.14 TOOLTIP "Dismiss the Customization window and don't apply the changes"
     BGCOLOR 8 .

DEFINE BUTTON buClear 
     LABEL "&Clear" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14 TOOLTIP "Revert to default layouts by removing all customization codes".

DEFINE BUTTON buDown 
     LABEL "&Down" 
     SIZE 9 BY 1.14 TOOLTIP "Move selected item down"
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14 TOOLTIP "Reset the session customization priorities and result codes"
     BGCOLOR 8 .

DEFINE BUTTON buRemove 
     LABEL "< &Remove" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove selected item"
     BGCOLOR 8 .

DEFINE BUTTON buRemoveAll 
     LABEL "<< Re&move All" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove all selected items"
     BGCOLOR 8 .

DEFINE BUTTON buTop 
     LABEL "&Top" 
     SIZE 9 BY 1.14 TOOLTIP "Move selected item to top"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     LABEL "&Up" 
     SIZE 9 BY 1.14 TOOLTIP "Move selected item up"
     BGCOLOR 8 .

DEFINE BUTTON buUse 
     LABEL "&Use" 
     SIZE 9 BY 1.14 TOOLTIP "Associate the Result Code with the highlighted customization type"
     BGCOLOR 8 .

DEFINE VARIABLE cbResultCode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Re&sult Code" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE fiAvailable AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 21 BY .62 NO-UNDO.

DEFINE VARIABLE fiSelected AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 21 BY .62 NO-UNDO.

DEFINE VARIABLE seAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SIZE 35 BY 7.62
     FONT 3 NO-UNDO.

DEFINE VARIABLE seSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SIZE 32 BY 7.86
     FONT 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     seAvailable AT ROW 1.86 COL 2 NO-LABEL
     seSelected AT ROW 1.91 COL 57 NO-LABEL
     buAdd AT ROW 2.67 COL 40
     buUp AT ROW 2.71 COL 90.6
     buRemove AT ROW 4.1 COL 40
     buDown AT ROW 4.14 COL 90.6
     buAddAll AT ROW 5.52 COL 40
     buTop AT ROW 5.57 COL 90.6
     buRemoveAll AT ROW 6.95 COL 40
     buBottom AT ROW 7 COL 90.6
     buUse AT ROW 12.33 COL 90.6
     cbResultCode AT ROW 12.43 COL 56 COLON-ALIGNED
     buOK AT ROW 14.81 COL 4.4
     buCancel AT ROW 14.81 COL 23.4
     buClear AT ROW 14.81 COL 48
     fiAvailable AT ROW 1.19 COL 2 NO-LABEL
     fiSelected AT ROW 1.24 COL 55 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.6 BY 15.67
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 15.67
         WIDTH              = 100.6
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         MIN-BUTTON         = no
         MAX-BUTTON         = no
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
/* SETTINGS FOR BUTTON buOK IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiAvailable IN FRAME frMain
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. 
     don't do this if embedded in ide (this is probably not called, but..)*/
  if not OEIDEIsRunning  then
    RUN setModal IN THIS-PROCEDURE (SESSION,NO).
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-RESIZED OF wiWin /* <insert SmartWindow title> */
DO:
  ASSIGN SELF:WIDTH-P  = MAX(400, SELF:WIDTH-P)
         SELF:HEIGHT-P = MAX(250, SELF:HEIGHT-P).
  RUN resizeWidgets IN THIS-PROCEDURE (SELF:WIDTH-P,SELF:HEIGHT-P).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd wiWin
ON CHOOSE OF buAdd IN FRAME frMain /* Add > */
OR MOUSE-SELECT-DBLCLICK OF seAvailable
DO:
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.

  DO iSel = 1 to NUM-ENTRIES(seAvailable:screen-value,pgcDelimiter):
     cValue = ENTRY(iSel,seAvailable:screen-value,pgcDelimiter).
     IF pglUseListPairs THEN 
     DO:
        ASSIGN cLabel = ENTRY(LOOKUP(cValue, seAvailable:LIST-ITEM-PAIRS,pgcDelimiter) - 1,seAvailable:LIST-ITEM-PAIRS,pgcDelimiter).
        seSelected:ADD-LAST(cLabel,cValue).
     END.
     ELSE 
        seSelected:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seAvailable:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,pgcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,pgcDelimiter)
            iPos   = seAvailable:LOOKUP(cScreenVal).
     seAvailable:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seAvailable:screen-value = seAvailable:ENTRY(iPos) NO-ERROR.
        IF seAvailable:ENTRY(iPos) = ? THEN
           seAvailable:SCREEN-VALUE = seAvailable:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seAvailable.
  RUN buttonsensitive.
  buOK:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddAll wiWin
ON CHOOSE OF buAddAll IN FRAME frMain /* Add All >> */
DO:
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.

  DO iSel = 1 to seAvailable:NUM-ITEMS:
     IF pglUseListPairs THEN 
     DO:
        ASSIGN cValue = ENTRY(iSel * 2,seAvailable:LIST-ITEM-PAIRS,pgcDelimiter).
               cLabel = ENTRY(LOOKUP(cValue, seAvailable:LIST-ITEM-PAIRS,pgcDelimiter) - 1,seAvailable:LIST-ITEM-PAIRS,pgcDelimiter).
               
        seSelected:ADD-LAST(cLabel,cValue).
     END.
     ELSE DO:
        cValue = ENTRY(iSel ,seAvailable:LIST-ITEMS,pgcDelimiter).
        seSelected:ADD-LAST(cValue).
     END.
        
  END.
  IF pglUseListPairs THEN 
     seAvailable:LIST-ITEM-PAIRS = ?.
  ELSE
     seAvailable:LIST-ITEMS = "".
  APPLY "VALUE-CHANGED":U TO seAvailable.
  RUN buttonsensitive.
  buOK:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBottom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBottom wiWin
ON CHOOSE OF buBottom IN FRAME frMain /* Bottom */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hSelection     AS HANDLE     NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE.

   CREATE SELECTION-LIST hSelection
        ASSIGN FRAME     = FRAME {&FRAME-NAME}:HANDLE
               DELIMITER = seSelected:DELIMITER.

   IF pglUseListPairs THEN
     ASSIGN hSelection:LIST-ITEM-PAIRS = seSelected:LIST-ITEM-PAIRS.
   ELSE
     ASSIGN hSelection:LIST-ITEMS = seSelected:LIST-ITEMS.

   DO isel = 1 TO seSelected:NUM-ITEMS  :

      IF pglUseListPairs THEN
      DO:
         cEntry = ENTRY(iSel * 2 ,seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
         IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN
         DO:
           cLabel = ENTRY(LOOKUP(cEntry,seSelected:LIST-ITEM-PAIRS,pgcDelimiter) - 1, seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
           hSelection:DELETE(cEntry).
           hSelection:ADD-LAST(cLabel,cEntry).
         END.
      END.
      ELSE DO:
         cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,pgcDelimiter).
         IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN
         DO:
           hSelection:DELETE(cEntry).
           hSelection:ADD-LAST(cEntry).
         END.
      END.

    END.
    IF pglUseListPairs THEN
     ASSIGN seSelected:LIST-ITEM-PAIRS = hSelection:LIST-ITEM-PAIRS.
   ELSE
     ASSIGN seSelected:LIST-ITEMS = hSelection:LIST-ITEMS.

    DELETE WIDGET hSelection.

    ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

    APPLY "VALUE-CHANGED":U TO seSelected.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel wiWin
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
   if not OEIDEIsRunning then
       RUN setModal IN THIS-PROCEDURE (SESSION,NO).
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear wiWin
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  RUN ClearAll.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown wiWin
ON CHOOSE OF buDown IN FRAME frMain /* Down */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cNewList      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwap          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwapLabel     AS CHARACTER  NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE
          cNewList      = IF pglUseListPairs 
                           THEN seSelected:LIST-ITEM-PAIRS
                           ELSE seSelected:LIST-ITEMS.
   DO isel = seSelected:NUM-ITEMS TO 1 BY -1:
      cEntry = IF pglUseListPairs 
               THEN ENTRY(iSel * 2,seSelected:LIST-ITEM-PAIRS,pgcDelimiter)
               ELSE ENTRY(iSel,seSelected:LIST-ITEMS,pgcDelimiter).
      IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN 
      DO:
         IF pglUseListPairs THEN
         DO:
            ASSIGN cSwap      = ENTRY(iSel * 2 + 2,cNewList,pgcDelimiter).
                   cSwapLabel = ENTRY(iSel * 2 + 1,cnewList,pgcDelimiter).
            ENTRY(isel * 2 + 2,cNewList,pgcDelimiter) = cEntry.
            ENTRY(isel * 2 + 1,cNewList,pgcDelimiter) = ENTRY(iSel * 2 - 1,seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
            ENTRY(iSel * 2,cNewList,pgcDelimiter) = cSwap.
            ENTRY(iSel * 2 - 1,cNewList,pgcDelimiter) = cSwapLabel.
         END.
         ELSE DO:
            ASSIGN cSwap   = ENTRY(iSel + 1,cNewList,pgcDelimiter).
            ENTRY(isel + 1,cNewList,pgcDelimiter) = cEntry.
            ENTRY(isel ,cNewList,pgcDelimiter) = cSwap.
         END.
      END.
     
        
    END.
    IF pglUseListPairs THEN
       ASSIGN seSelected:LIST-ITEM-PAIRS = cNewList.
    ELSE
       ASSIGN seSelected:LIST-ITEMS = cNewList.
    ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

    APPLY "VALUE-CHANGED":U TO seSelected.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK wiWin
ON CHOOSE OF buOK IN FRAME frMain /* OK */
DO:
   ASSIGN pgcSelectedList = IF pglUseListPairs 
                            THEN seSelected:LIST-ITEM-PAIRS
                            ELSE seSelected:LIST-ITEMS
          pgcSelectedList = IF pgcSelectedList = ? 
                            THEN "" 
                            ELSE pgcSelectedList
          plOK            = YES.
   if not OEIDEIsRunning then
      RUN setModal IN THIS-PROCEDURE (SESSION,NO).
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove wiWin
ON CHOOSE OF buRemove IN FRAME frMain /* < Remove */
OR MOUSE-SELECT-DBLCLICK OF seSelected
DO:
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.
  DO iSel = 1 to NUM-ENTRIES(seSelected:screen-value,pgcDelimiter):
     cLabel = stripResultCode(ENTRY(iSel,seSelected:screen-value,pgcDelimiter)).
     IF pglUseListPairs THEN 
     DO:
        ASSIGN cValue = cLabel + CHR(4).
        seAvailable:ADD-LAST(cLabel,cValue).
     END.
     ELSE 
        seAvailable:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seSelected:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,pgcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,pgcDelimiter)
            iPos   = seSelected:LOOKUP(cScreenVal).
     seSelected:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seSelected:screen-value = seSelected:ENTRY(iPos) NO-ERROR.
        IF seSelected:ENTRY(iPos) = ? THEN
           seSelected:SCREEN-VALUE = seSelected:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seSelected.
  RUN buttonsensitive.
  buOK:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveAll wiWin
ON CHOOSE OF buRemoveAll IN FRAME frMain /* << Remove All */
DO:
  RUN ClearAll.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTop wiWin
ON CHOOSE OF buTop IN FRAME frMain /* Top */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hSelection     AS HANDLE     NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE.

   CREATE SELECTION-LIST hSelection
        ASSIGN FRAME     = FRAME {&FRAME-NAME}:HANDLE
               DELIMITER = seSelected:DELIMITER.

   IF pglUseListPairs THEN
     ASSIGN hSelection:LIST-ITEM-PAIRS = seSelected:LIST-ITEM-PAIRS.
   ELSE
     ASSIGN hSelection:LIST-ITEMS = seSelected:LIST-ITEMS.
         
   DO isel = seSelected:NUM-ITEMS TO 1 BY -1:
      
      IF pglUseListPairs THEN
      DO:
         cEntry = ENTRY(iSel * 2 ,seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
         IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN
         DO:
           cLabel = ENTRY(LOOKUP(cEntry,seSelected:LIST-ITEM-PAIRS,pgcDelimiter) - 1, seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
           hSelection:DELETE(cEntry).
           hSelection:ADD-FIRST(cLabel,cEntry).
         END.
      END.
      ELSE DO:
         cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,pgcDelimiter).
         IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN
         DO:
           hSelection:DELETE(cEntry).
           hSelection:ADD-FIRST(cEntry).
         END.
      END.
         
    END.
    IF pglUseListPairs THEN
     ASSIGN seSelected:LIST-ITEM-PAIRS = hSelection:LIST-ITEM-PAIRS.
   ELSE
     ASSIGN seSelected:LIST-ITEMS = hSelection:LIST-ITEMS.
    
    DELETE WIDGET hSelection.

    ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

    APPLY "VALUE-CHANGED":U TO seSelected.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp wiWin
ON CHOOSE OF buUp IN FRAME frMain /* Up */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cNewList      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwap          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwapLabel     AS CHARACTER  NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE
          cNewList      = IF pglUseListPairs 
                           THEN seSelected:LIST-ITEM-PAIRS
                           ELSE seSelected:LIST-ITEMS.
   DO isel = 1 TO seSelected:NUM-ITEMS:
      cEntry = IF pglUseListPairs 
               THEN ENTRY(iSel * 2,seSelected:LIST-ITEM-PAIRS,pgcDelimiter)
               ELSE ENTRY(iSel,seSelected:LIST-ITEMS,pgcDelimiter).
      IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,pgcDelimiter) > 0 THEN 
      DO:
         IF pglUseListPairs THEN
         DO:
            ASSIGN cSwap      = ENTRY(iSel * 2 - 2,cNewList,pgcDelimiter).
                   cSwapLabel = ENTRY(iSel * 2 - 3,cnewList,pgcDelimiter).
            ENTRY(isel * 2 - 2,cNewList,pgcDelimiter) = cEntry.
            ENTRY(isel * 2 - 3,cNewList,pgcDelimiter) = ENTRY(iSel * 2 - 1,seSelected:LIST-ITEM-PAIRS,pgcDelimiter).
            ENTRY(iSel * 2,cNewList,pgcDelimiter) = cSwap.
            ENTRY(iSel * 2 - 1,cNewList,pgcDelimiter) = cSwapLabel.
         END.
         ELSE DO:
            ASSIGN cSwap = ENTRY(iSel - 1,cNewList,pgcDelimiter).
            ENTRY(isel - 1,cNewList,pgcDelimiter) = cEntry.
            ENTRY(isel ,cNewList,pgcDelimiter) = cSwap.
         END.
      END.
     
        
    END.
    IF pglUseListPairs THEN
       ASSIGN seSelected:LIST-ITEM-PAIRS = cNewList.
    ELSE
       ASSIGN seSelected:LIST-ITEMS = cNewList.
    ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

    APPLY "VALUE-CHANGED":U TO seSelected.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUse wiWin
ON CHOOSE OF buUse IN FRAME frMain /* Use */
DO:
  RUN showResultCode.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbResultCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbResultCode wiWin
ON VALUE-CHANGED OF cbResultCode IN FRAME frMain /* Result Code */
OR MOUSE-SELECT-DBLCLICK OF cbResultCode DO:
  RUN showResultCode.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAvailable wiWin
ON VALUE-CHANGED OF seAvailable IN FRAME frMain
DO:
  SeSelected:screen-value = "".
  cbResultCode:LIST-ITEMS = "".
  if self:SCREEN-VALUE <> ? then
    assign
       buAdd:SENSITIVE        = TRUE 
       buRemove:SENSITIVE     = FALSE
       buTop:SENSITIVE        = FALSE 
       buUp:SENSITIVE         = FALSE 
       buDown:SENSITIVE       = FALSE 
       buBottom:SENSITIVE     = FALSE
       buUse:SENSITIVE        = FALSE
       cbResultCode:SENSITIVE = FALSE.
  ELSE
   assign
       buAdd:SENSITIVE        = FALSE
       buRemove:SENSITIVE     = FALSE 
       buTop:SENSITIVE        = FALSE 
       buUp:SENSITIVE         = FALSE 
       buDown:SENSITIVE       = FALSE 
       buBottom:SENSITIVE     = FALSE
       buUse:SENSITIVE        = FALSE
       cbResultCode:SENSITIVE = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected wiWin
ON VALUE-CHANGED OF seSelected IN FRAME frMain
DO:
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMoveUp     AS LOGICAL    NO-UNDO INIT YES.
  DEFINE VARIABLE lMoveDown   AS LOGICAL    NO-UNDO INIT YES.
  DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomType AS CHARACTER  NO-UNDO.

  seAvailable:screen-value = "".
  IF SELF:SCREEN-VALUE <> ? THEN 
  DO:
    ASSIGN buAdd:SENSITIVE        = FALSE 
           buRemove:SENSITIVE     = TRUE
           cbResultCode:SENSITIVE = TRUE
           buUse:SENSITIVE        = TRUE.

    DO isel = 1 TO NUM-ENTRIES(seSelected:screen-value,pgcDelimiter):
       cValue = ENTRY(iSel,seSelected:screen-value,pgcDelimiter).
       IF seSelected:LOOKUP(cValue) = 1 THEN
          lMoveUp = NO.
       IF seSelected:LOOKUP(cValue) = seSelected:NUM-ITEMS THEN
          lMoveDown = NO.
    END.

    ASSIGN  buTop:SENSITIVE        = lMoveUp
            buUp:SENSITIVE         = lMoveUp
            buDown:sensitive       = lMoveDown
            buBottom:sensitive     = lMoveDown.


    /* Populate the combo box */
    cValue = ENTRY(1, seSelected:SCREEN-VALUE, pgcDelimiter).
    cCustomType = stripResultCode(cValue).
    cbResultCode:TOOLTIP = "Select a result code to be associated with " + cCustomType.
    FIND FIRST ryc_customization_type NO-LOCK
        WHERE ryc_customization_type.customization_type_code = cCustomType NO-ERROR.
    IF AVAILABLE ryc_customization_type THEN DO:
      FOR EACH ryc_customization_result 
         WHERE ryc_customization_result.customization_type_obj = 
               ryc_customization_type.customization_type_obj NO-LOCK:
        cList = cList + ",":U + ryc_customization_result.customization_result_code.
      END.
      cList = LEFT-TRIM(cList,",":U).
      ASSIGN cbResultCode:LIST-ITEMS = cList.
     
      IF NUM-ENTRIES(cValue,CHR(4)) > 1 AND
         ENTRY(2, cValue, CHR(4)) NE "" and
         entry(2, cValue, chr(4)) NE "DEFAULT":U THEN
          cbResultCode:SCREEN-VALUE = TRIM(ENTRY(2, cValue, CHR(4))).
      ELSE cbResultCode:SCREEN-VALUE = cbResultCode:ENTRY(1) NO-ERROR.
    END. /* If available ryc_customization_type */
    ELSE cbResultCode:LIST-ITEMS = "":U.
  END.
  ELSE 
     ASSIGN
       buRemove:SENSITIVE     = FALSE
       buTop:SENSITIVE        = FALSE
       buUp:SENSITIVE         = FALSE
       buDown:sensitive       = FALSE
       buBottom:sensitive     = FALSE
       cbResultCode:TOOLTIP   = "Result code to be associated with a customization type"
       cbResultCode:SENSITIVE = FALSE
       buUse:SENSITIVE        = FALSE.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buttonSensitive wiWin 
PROCEDURE buttonSensitive :
/*------------------------------------------------------------------------------
  Purpose:     Sets the sensitivity of the buttons based on the screen value
               and contents of the selection lists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
 ASSIGN  
   buAdd:SENSITIVE        = IF seAvailable:SCREEN-VALUE  = ? THEN FALSE ELSE TRUE
   buAddAll:SENSITIVE     = IF pglUseListPairs AND seAvailable:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ? 
                               OR NOT pglUseListPairs AND seAvailable:LIST-ITEMS = ? 
                            THEN FALSE 
                            ELSE TRUE 
  buRemove:SENSITIVE      = IF seSelected:SCREEN-VALUE = ? THEN FALSE ELSE TRUE  
  buRemoveAll:SENSITIVE   = IF pglUseListPairs AND seSelected:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ? 
                               OR NOT pglUseListPairs AND seSelected:LIST-ITEMS = ? 
                            THEN FALSE 
                            ELSE TRUE 
  NO-ERROR.
 END.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearAll wiWin 
PROCEDURE ClearAll :
/*------------------------------------------------------------------------------
  Purpose:     To reset to default layout by removing all customization codes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DO iSel = 1 to seSelected:NUM-ITEMS:
       IF pglUseListPairs THEN 
       DO:
          ASSIGN cLabel = stripResultCode(ENTRY(iSel * 2,seSelected:LIST-ITEM-PAIRS,pgcDelimiter))
                 cValue = cLabel + CHR(4).
                 
          seAvailable:ADD-LAST(cLabel,cValue).
       END.
       ELSE DO:
          cValue = stripResultCode(ENTRY(iSel ,seSelected:LIST-ITEMS,pgcDelimiter)).
          seAvailable:ADD-LAST(cValue).
       END.
          
    END.
    IF pglUseListPairs THEN 
       seSelected:LIST-ITEM-PAIRS = ?.
    ELSE
       seSelected:LIST-ITEMS = "".
    APPLY "VALUE-CHANGED":U TO seSelected.
    RUN buttonsensitive.
    buOK:SENSITIVE = TRUE.
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
  DISPLAY seAvailable seSelected cbResultCode fiAvailable fiSelected 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE seAvailable seSelected buAdd buUp buRemove buDown buAddAll buTop 
         buRemoveAll buBottom buUse cbResultCode buCancel buClear fiAvailable 
         fiSelected 
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
  DEFINE VARIABLE lMethod   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRemove   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSel2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNewAvail AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.

  /* Set the minimum width and height based on preprocessors defined in definition section */
  ASSIGN {&WINDOW-NAME}:MIN-WIDTH  = {&MIN-WIDTH}
         {&WINDOW-NAME}:MIN-HEIGHT = {&MIN-HEIGHT} .
  STATUS INPUT OFF.  /* Turn off default status message */
  /* Load Images */
  IF pglUseImages THEN
  ASSIGN
     lmethod = buAdd:LOAD-IMAGE("ry/img/next.gif") IN FRAME {&FRAME-NAME}
     lmethod = buRemove:LOAD-IMAGE("ry/img/prev.gif")
     lmethod = buAddAll:LOAD-IMAGE("ry/img/nextbatch.gif")
     lmethod = buRemoveAll:LOAD-IMAGE("ry/img/prevbatch.gif")
     lmethod = buUp:LOAD-IMAGE("ry/img/moveup.gif")
     lmethod = buDown:LOAD-IMAGE("ry/img/movedown.gif")
     lmethod = buTop:LOAD-IMAGE("ry/img/movetop.gif")  
     lmethod = buBottom:LOAD-IMAGE("ry/img/movebottom.gif")  
     NO-ERROR.

   /* Set sort of selection list */
  IF pglSortAvailable THEN
     seAvailable:SORT = TRUE.

  RUN SUPER.

  
  /* Set the delimiters */
  IF pgcDelimiter = "" OR pgcDelimiter = ? THEN
     pgcDelimiter = ",".
  ASSIGN seAvailable:DELIMITER = pgcDelimiter
         seSelected:DELIMITER  = pgcDelimiter.
  /* Assign the window title and selection list labels */
  IF pgcTextString = "" OR pgcTextString = ? OR NUM-ENTRIES(pgcTextString,pgcDelimiter) <> 3 THEN 
     ASSIGN {&WINDOW-NAME}:TITLE     = "Select"
            fiAvailable:SCREEN-VALUE = "Available"
            fiSelected:SCREEN-VALUE  = "Selected".
  ELSE IF NUM-ENTRIES(pgcTextString,pgcDelimiter) = 3 THEN
    ASSIGN {&WINDOW-NAME}:TITLE      = ENTRY(1,pgcTextString,pgcDelimiter)
            fiAvailable:SCREEN-VALUE = ENTRY(2,pgcTextString,pgcDelimiter)
            fiSelected:SCREEN-VALUE  = ENTRY(3,pgcTextString,pgcDelimiter).
 
  /* Set the selection lists based on whether using list-items or pairs */
  IF pglUseListPairs THEN 
  DO:
     /* Remove any duplicate values from the available list that are also in the selected list */
     DUP-BLOCK:
     DO isel = 2 TO NUM-ENTRIES(pgcAvailableList,pgcDelimiter) BY 2:
        DO isel2 = 2 TO NUM-ENTRIES(pgcSelectedList,pgcDelimiter) BY 2:
           IF stripResultCode(ENTRY(isel2,pgcSelectedList,pgcDelimiter)) = 
              stripResultCode(ENTRY(isel,pgcAvailableList,pgcDelimiter)) THEN DO:
              NEXT DUP-BLOCK.
           END.
        END.
          cNewAvail =  cNewAvail + (IF cNewAvail > "" THEN pgcDelimiter ELSE "") 
                                 + ENTRY(isel - 1,pgcAvailableList,pgcDelimiter)
                                 + pgcDelimiter + ENTRY(isel,pgcAvailableList,pgcDelimiter).
     END. /* DUP-BLOCK */

     /* Show existing associated ResultCodes */
     DO isel2 = 2 TO NUM-ENTRIES(pgcSelectedList,pgcDelimiter) BY 2:
       cValue = ENTRY(isel2,pgcSelectedList,pgcDelimiter).
       IF NUM-ENTRIES(cValue,CHR(4)) > 1 THEN DO:
         IF ENTRY(2,cValue,CHR(4)) NE "":U THEN 
           ENTRY(isel2 - 1,pgcSelectedList,pgcDelimiter) = ENTRY(isel2 - 1,pgcSelectedList,pgcDelimiter) +
                                                           " <":U + ENTRY(2,cValue,CHR(4)) + ">":U.
       END.
     END.
     ASSIGN seAvailable:LIST-ITEM-PAIRS = cNewAvail
            seSelected:LIST-ITEM-PAIRS  = pgcSelectedList 
            seAvailable:SCREEN-VALUE    = ENTRY(2,seAvailable:LIST-ITEM-PAIRS,pgcDelimiter)
     NO-ERROR.
  END.
  ELSE DO:
     /* Remove any duplicate values from the available list that are also in the selected list */
     DO isel = 1 TO NUM-ENTRIES(pgcAvailableList,pgcDelimiter):
        IF LOOKUP(ENTRY(isel,pgcAvailableList,pgcDelimiter),pgcSelectedList,pgcDelimiter) > 0 THEN
           NEXT.
        ELSE
          cNewAvail =  cNewAvail + (IF cNewAvail > "" THEN pgcDelimiter ELSE "") + ENTRY(isel,pgcAvailableList,pgcDelimiter).
     END.
     ASSIGN seAvailable:LIST-ITEMS   = cNewAvail
            seSelected:LIST-ITEMS    = pgcSelectedList 
            seAvailable:SCREEN-VALUE  = ENTRY(1,seAvailable:LIST-ITEMS,pgcDelimiter)
     NO-ERROR.
  END.
   
  APPLY "VALUE-CHANGED":U to seAvailable.

  RUN resizeWidgets IN THIS-PROCEDURE ({&WINDOW-NAME}:WIDTH-P,{&WINDOW-NAME}:HEIGHT-P).
  if not OEIDEIsRunning then
      RUN setModal IN THIS-PROCEDURE (SESSION,YES).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWidgets wiWin 
PROCEDURE resizeWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Resizes the selection lists to be proportinal to the
               size of the window. Also repositions the buttons.
  Parameters:  <none>
  Notes:       The widgets are resized so that there are 5 pixels between the 
               buttons and the 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL  NO-UNDO.
DEFINE INPUT  PARAMETER pdHeight AS DECIMAL  NO-UNDO.

DEFINE VARIABLE hcbLabel         AS HANDLE   NO-UNDO.


ASSIGN FRAME {&FRAME-NAME}:WIDTH  = MAX(FRAME {&FRAME-NAME}:WIDTH,{&WINDOW-NAME}:WIDTH)
       FRAME {&FRAME-NAME}:HEIGHT = MAX(FRAME {&FRAME-NAME}:HEIGHT,{&WINDOW-NAME}:HEIGHT)
       seAvailable:WIDTH-P         = (pdWidth -  buAdd:WIDTH-P 
                                    - (IF pglSortSelected THEN buTop:WIDTH-P + {&WIDGET-SPACE} ELSE 0)
                                    -  {&WIDGET-SPACE} * 4)   / 2
       seAvailable:HEIGHT-P        = pdHeight - seAvailable:Y - buOK:HEIGHT-P - ({&WIDGET-SPACE} * 6)
       fiAvailable:X               = seAvailable:X
       fiAvailable:WIDTH           = seAvailable:WIDTH
       seSelected:X                = seAvailable:WIDTH-P + seAvailable:X + buAdd:WIDTH-P
                                      + {&WIDGET-SPACE} + {&WIDGET-SPACE}
       seSelected:HEIGHT           = seAvailable:HEIGHT - 1.5
       cbResultCode:X              = seSelected:X
       cbResultCode:ROW            = seSelected:ROW + seSelected:HEIGHT + .5
       fiSelected:X                = seSelected:X
       fiSelected:WIDTH            = seSelected:WIDTH
       seSelected:WIDTH-P          = seAvailable:WIDTH-P
       cbResultCode:WIDTH          = seSelected:WIDTH
       hcbLabel                    = cbResultCode:SIDE-LABEL-HANDLE
       hcbLabel:HEIGHT             = cbResultCode:HEIGHT
       hcbLabel:COLUMN             = seSelected:COLUMN - FONT-TABLE:GET-TEXT-WIDTH("Result Code: ")
       hcbLabel:ROW                = cbResultCode:ROW
       buAdd:X                     = seAvailable:WIDTH-P + seAvailable:X + {&WIDGET-SPACE}
       buRemove:X                  = buAdd:X
       buAddAll:X                  = buAdd:X
       buRemoveAll:X               = buAdd:X
       buOK:X                      = 20
       buOK:Y                      = seAvailable:Y + seAvailable:HEIGHT-P + ({&WIDGET-SPACE} * 4)
       buCancel:X                  = buOK:X + buOK:WIDTH-P + {&WIDGET-SPACE} * 2 
       buCancel:Y                  = buOK:Y
       buClear:X                   = MAX(seSelected:X,
                                         buCancel:X + buCancel:WIDTH-P + {&WIDGET-SPACE} * 6)
       buClear:Y                   = buOK:Y
   NO-ERROR.

IF NOT pglSortSelected THEN 
   ASSIGN buTop:VISIBLE    = FALSE
          buUp:VISIBLE     = FALSE
          buDown:VISIBLE   = FALSE
          buBottom:VISIBLE = FALSE.
ELSE
  ASSIGN buTop:X    = seSelected:X + seSelected:WIDTH-P + {&WIDGET-SPACE}
         buUp:X     = buTop:X
         buDown:X   = buTop:X
         buBottom:X = buTop:X 
         buUse:X    = buTop:X 
         buUse:Y    = cbResultCode:Y - (buUse:HEIGHT-P - cbResultCode:HEIGHT-P) / 2 
                      NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setModal wiWin 
PROCEDURE setModal :
/*------------------------------------------------------------------------------
  Purpose:     Emulates a modal dialog by making all visible windows
               insensitive
  Parameters:   phWindow  Handle of Window containing a first child.
                plType    YES  Make all windows insensitive
                          NO Return all windows to their previous state
  Notes:       This is called from the choose trigger on the OK and Cancel buttons
               and on the Close of the window.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phWindow  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plType    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hWindow          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPos             AS INTEGER    NO-UNDO.
  
  /* Make all windows insensitive except for current window */
  IF plType THEN DO:
     hWindow = phWindow:FIRST-CHILD.
     DO WHILE VALID-HANDLE(hWindow):
        IF hWindow:TYPE = "WINDOW":U THEN
        DO:
          ASSIGN
             gcWindowState   = gcWindowState + (IF gcWindowState = "" THEN "" ELSE ",") 
                                         + STRING(hWindow:SENSITIVE,"yes/no":U)
             gcWindowHandles = gcWindowHandles + (IF gcWindowHandles = "" THEN "" ELSE ",") 
                                         + STRING(hWindow) .
          IF hWindow <> {&WINDOW-NAME} THEN
              hWindow:SENSITIVE = FALSE.
        END.
        IF CAN-QUERY(hWindow,"FIRST-CHILD":U) THEN 
           RUN setModal IN THIS-PROCEDURE (hWindow,YES).
        hWindow = hWindow:NEXT-SIBLING.
     END.
  END.
  ELSE DO:
   /* Return all windows to their original state */
    hWindow = phWindow:FIRST-CHILD.
    DO WHILE VALID-HANDLE(hWindow):
       IF hWindow:TYPE = "WINDOW":U THEN
       DO:
          iPos = LOOKUP(STRING(hWindow),gcWindowHandles) .
          IF iPos > 0 THEN
             hWindow:SENSITIVE = (ENTRY(ipos,gcWindowState) = "yes":U).
       END.
       IF CAN-QUERY(hWindow,"FIRST-CHILD":U) THEN 
              RUN setModal IN THIS-PROCEDURE (hWindow,NO).
       hWindow = hWindow:NEXT-SIBLING.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showResultCode wiWin 
PROCEDURE showResultCode :
/*------------------------------------------------------------------------------
  Purpose:     Take the screen value of cbResultCode and append it to the
               CustomizationType (in <>'s) to the currently selected item
               in the seSelected list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResultCode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomizationType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewLabel          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue          AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cResultCode        = cbResultCode:SCREEN-VALUE
           cCustomizationType = seSelected:SCREEN-VALUE.
    
    /* Strip off any existing ResultCode*/
    cNewLabel = stripResultCode(cCustomizationType) + " <":U + cResultCode + ">":U.
    cNewValue = stripResultCode(cCustomizationType) + CHR(4) + cResultCode.

    seSelected:REPLACE(cNewLabel, cNewValue, cCustomizationType).
    ASSIGN seSelected:SCREEN-VALUE = cNewValue.

    APPLY "VALUE-CHANGED":U TO seSelected.

  END.  /* Do with frame {&FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION stripResultCode wiWin 
FUNCTION stripResultCode RETURNS CHARACTER
  ( INPUT cValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: To take a selected value from the seSelection list and return only
           the customizationType.  This means that we strip off the 
           " <ResultCode>" if present.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationType AS CHARACTER  NO-UNDO.

  cCustomizationType = ENTRY(1, cValue, CHR(4)).

  RETURN cCustomizationType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

