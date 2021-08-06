&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: ryobjinitv.w

  Description:  ryobjinitv

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/01/2002  Author:     

  Update Notes: Created from Template rysttsimpv.w

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

&scop object-name       ryobjinitv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buMoveDown buMoveUp seInstances raPage buOk ~
fiFilter fiWhichPage 
&Scoped-Define DISPLAYED-OBJECTS seInstances raPage fiPage fiFilter ~
fiWhichPage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateMoveUpDown sObject 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateUpDown sObject 
FUNCTION evaluateUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateSequence sObject 
FUNCTION updateSequence RETURNS LOGICAL
  (pcInstanceName AS CHARACTER,
   piPageSequence AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Decrease page number by 1"
     BGCOLOR 8 .

DEFINE BUTTON buMoveDown 
     IMAGE-UP FILE "ry/img/movedown.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.4 BY 1.05 TOOLTIP "Move the instance down in the list (Initialize later)"
     BGCOLOR 8 .

DEFINE BUTTON buMoveUp 
     IMAGE-UP FILE "ry/img/moveup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.4 BY 1.05 TOOLTIP "Move the instance up in the list (Initialize earlier)"
     BGCOLOR 8 .

DEFINE BUTTON buOk 
     LABEL "Close" 
     SIZE 15 BY 1.14 TOOLTIP "Close this window"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Increase page number by 1"
     BGCOLOR 8 .

DEFINE VARIABLE fiFilter AS CHARACTER FORMAT "X(256)":U INITIAL "  Filter" 
      VIEW-AS TEXT 
     SIZE 28.4 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPage AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS FILL-IN 
     SIZE 4.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiWhichPage AS CHARACTER FORMAT "X(256)":U INITIAL " Objects on page ..." 
      VIEW-AS TEXT 
     SIZE 19 BY .62 NO-UNDO.

DEFINE VARIABLE raPage AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Current", "C",
"Page", "P"
     SIZE 12 BY 1.76 NO-UNDO.

DEFINE RECTANGLE rctBorder
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 94.8 BY 6.

DEFINE RECTANGLE rctPage
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 2.52.

DEFINE VARIABLE seInstances AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 57.6 BY 5.24 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buMoveDown AT ROW 2.91 COL 60.6
     buMoveUp AT ROW 1.86 COL 60.6
     seInstances AT ROW 1.76 COL 2.2 NO-LABEL
     raPage AT ROW 3.48 COL 67.6 NO-LABEL
     fiPage AT ROW 4.29 COL 77.8 COLON-ALIGNED NO-LABEL
     buOk AT ROW 7.48 COL 80.2
     buDown AT ROW 4.76 COL 84
     buUp AT ROW 4.24 COL 84
     fiFilter AT ROW 1.76 COL 64 COLON-ALIGNED NO-LABEL
     fiWhichPage AT ROW 2.81 COL 67 NO-LABEL
     rctPage AT ROW 3.1 COL 66
     rctBorder AT ROW 1.29 COL 1
     " Arrange in required initialization order" VIEW-AS TEXT
          SIZE 35.8 BY .62 AT ROW 1 COL 2.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 7.62
         WIDTH              = 94.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buUp IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiWhichPage IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE rctBorder IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctPage IN FRAME frMain
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

&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME frMain
DO:
  ASSIGN
      fiPage
      fiPage:SCREEN-VALUE = STRING(INTEGER(fiPage:SCREEN-VALUE) - 1).

  DYNAMIC-FUNCTION("evaluateUpDown":U).
  APPLY "VALUE-CHANGED":U TO fiPage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMoveDown sObject
ON CHOOSE OF buMoveDown IN FRAME frMain
DO:
  DEFINE VARIABLE cListItems  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.

  ASSIGN
      seInstances

      cValue     = seInstances:SCREEN-VALUE
      cListItems = seInstances:LIST-ITEMS
      iEntry     = LOOKUP(cValue, cListItems, seInstances:DELIMITER)
      cTempValue = ENTRY(iEntry + 1, cListItems, seInstances:DELIMITER)

      ENTRY(iEntry + 1, cListItems, seInstances:DELIMITER) = cValue
      ENTRY(iEntry,     cListItems, seInstances:DELIMITER) = cTempValue
      
      seInstances:LIST-ITEMS   = cListItems
      seInstances:SCREEN-VALUE = cValue.

  DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
  DYNAMIC-FUNCTION("updateSequence":U, cValue, iEntry + 1).
  DYNAMIC-FUNCTION("updateSequence":U, cTempValue, iEntry).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMoveUp sObject
ON CHOOSE OF buMoveUp IN FRAME frMain
DO:
  DEFINE VARIABLE cListItems  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.

  ASSIGN
      seInstances

      cValue     = seInstances:SCREEN-VALUE
      cListItems = seInstances:LIST-ITEMS
      iEntry     = LOOKUP(cValue, cListItems, seInstances:DELIMITER)
      cTempValue = ENTRY(iEntry - 1, cListItems, seInstances:DELIMITER)

      ENTRY(iEntry - 1, cListItems, seInstances:DELIMITER) = cValue
      ENTRY(iEntry,     cListItems, seInstances:DELIMITER) = cTempValue
      
      seInstances:LIST-ITEMS   = cListItems
      seInstances:SCREEN-VALUE = cValue.

  DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
  DYNAMIC-FUNCTION("updateSequence":U, cValue, iEntry - 1).
  DYNAMIC-FUNCTION("updateSequence":U, cTempValue, iEntry).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk sObject
ON CHOOSE OF buOk IN FRAME frMain /* Close */
DO:
  RUN destroyObject IN ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME frMain
DO:
  ASSIGN
      fiPage
      fiPage:SCREEN-VALUE = STRING(INTEGER(fiPage:SCREEN-VALUE) + 1).

  DYNAMIC-FUNCTION("evaluateUpDown":U).
  APPLY "VALUE-CHANGED":U TO fiPage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPage sObject
ON VALUE-CHANGED OF fiPage IN FRAME frMain
DO:
  RUN refreshData (INPUT "":U, INPUT 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raPage sObject
ON VALUE-CHANGED OF raPage IN FRAME frMain
DO:
  ASSIGN
      raPage.
  
  IF raPage:SCREEN-VALUE = "P":U THEN
  DO:
    fiPage:SENSITIVE = TRUE.

    DYNAMIC-FUNCTION("evaluateUpDown":U).
  END.
  ELSE
    ASSIGN
        fiPage:SENSITIVE = FALSE
        buDown:SENSITIVE = FALSE
        buUp:SENSITIVE   = FALSE.

  RUN refreshData (INPUT "":U, INPUT 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seInstances
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seInstances sObject
ON VALUE-CHANGED OF seInstances IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If ryobjinitv in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.
  
  SUBSCRIBE TO "refreshData":U IN ghParentContainer.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiWhichPage:SCREEN-VALUE = " Objects on page ...":U
        fiFilter:SCREEN-VALUE    = " Filter":U
        seInstances:DELIMITER    = CHR(3)
        fiPage:SCREEN-VALUE      = "1":U.
  
    APPLY "VALUE-CHANGED":U TO raPage.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData sObject 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cListItems              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstance               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageNumber             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPageObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        seInstances
        raPage
        
        iPageNumber = (IF raPage:SCREEN-VALUE = "P":U THEN INTEGER(fiPage:SCREEN-VALUE) ELSE DYNAMIC-FUNCTION("getCurrentPage":U IN ghParentContainer) - 1)

        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        httPageObject           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPageObject":U))
        cInstance               = seInstances:SCREEN-VALUE
        cQuery                  = "FOR EACH ttObjectInstance":U
                                + "   WHERE ttObjectInstance.d_customization_result_obj = DECIMAL('&1')":U
                                + "     AND ttObjectInstance.i_page                     = &2,":U
                                + "   FIRST ttPageObject":U
                                + "   WHERE ttPageObject.d_customization_result_obj = DECIMAL('&1')":U
                                + "     AND ttPageObject.d_object_instance_obj      = ttObjectInstance.d_object_instance_obj":U
                                + "      BY ttPageObject.i_page_object_sequence":U
        cQuery                  = SUBSTITUTE(cQuery, dCustomizationResultObj, iPageNumber).

    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
    CREATE QUERY  hQuery.
  
    hQuery:SET-BUFFERS(httObjectInstance, httPageObject).
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
  
    DO WHILE NOT hQuery:QUERY-OFF-END:
      cListItems = cListItems
                 + (IF cListItems = "":U THEN "":U ELSE seInstances:DELIMITER)
                 + httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
      
      hQuery:GET-NEXT().
    END.
  
    DELETE OBJECT httObjectInstance.
    DELETE OBJECT hQuery.
  
    ASSIGN
        httObjectInstance        = ?
        hQuery                   = ?
        cInstance                = (IF LOOKUP(cInstance, cListItems, seInstances:DELIMITER) > 0 THEN cInstance ELSE ENTRY(1, cListItems, seInstances:DELIMITER))
        seInstances:LIST-ITEMS   = cListItems
        seInstances:SCREEN-VALUE = cInstance.
    
    IF NUM-ENTRIES(seInstances:LIST-ITEMS, seInstances:DELIMITER) <= 1 OR 
       NUM-ENTRIES(seInstances:LIST-ITEMS, seInstances:DELIMITER)  = ? THEN
      ASSIGN
          buMoveDown:SENSITIVE = FALSE
          buMoveUp:SENSITIVE   = FALSE.
    ELSE
      DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.

  HIDE FRAME {&FRAME-NAME}.

  ASSIGN
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS
      dFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > dFrameWidth  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.
    
    lResizedObjects = TRUE.
    
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).

  VIEW FRAME {&FRAME-NAME}.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects sObject 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE dDifference AS DECIMAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dDifference              = pdWidth  - rctBorder:WIDTH-CHARS
        rctBorder:HEIGHT-CHARS   = pdHeight - rctBorder:ROW          - 0.50
        rctBorder:WIDTH-CHARS    = pdWidth
        
        fiWhichPage:COLUMN       = fiWhichPage:COLUMN + dDifference
        buMoveDown:COLUMN        = buMoveDown:COLUMN  + dDifference
        buMoveUp:COLUMN          = buMoveUp:COLUMN    + dDifference
        fiFilter:COLUMN          = fiFilter:COLUMN    + dDifference
        rctPage:COLUMN           = rctPage:COLUMN     + dDifference
        buDown:COLUMN            = buDown:COLUMN      + dDifference
        raPage:COLUMN            = raPage:COLUMN      + dDifference
        fiPage:COLUMN            = fiPage:COLUMN      + dDifference
        buUp:COLUMN              = buUp:COLUMN        + dDifference
        buOk:COLUMN              = buOk:COLUMN        + dDifference
        
        buOk:ROW                 = rctBorder:ROW          + rctBorder:HEIGHT-CHARS + 0.25
        seInstances:HEIGHT-CHARS = rctBorder:HEIGHT-CHARS - seInstances:ROW        + 1.00
        seInstances:WIDTH-CHARS  = buMoveUp:COLUMN        - seInstances:COLUMN     - 1.00.
        
        
/*        
        buDown:COLUMN            = rctBorder:WIDTH-CHARS  - buDown:WIDTH-CHARS     - 0.25
        buUp:COLUMN              = rctBorder:WIDTH-CHARS  - buUp:WIDTH-CHARS       - 0.25
        buOk:COLUMN              = rctBorder:WIDTH-CHARS  - buOk:WIDTH-CHARS       - 0.25
        buOk:ROW                 = rctBorder:ROW          + rctBorder:HEIGHT-CHARS + 0.25
        seInstances:HEIGHT-CHARS = rctBorder:HEIGHT-CHARS - seInstances:ROW        + 1.00
        seInstances:WIDTH-CHARS  = rctBorder:WIDTH-CHARS  - seInstances:COLUMN     - buDown:WIDTH-CHARS - 1.00.
*/
  END.
      

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateMoveUpDown sObject 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCurrentEntry AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    iCurrentEntry = LOOKUP(seInstances:SCREEN-VALUE, seInstances:LIST-ITEMS, seInstances:DELIMITER).

    IF iCurrentEntry = 1 THEN
      buMoveUp:SENSITIVE = FALSE.
    ELSE
      buMoveUp:SENSITIVE = TRUE.
    
    IF iCurrentEntry = NUM-ENTRIES(seInstances:LIST-ITEMS, seInstances:DELIMITER) THEN
      buMoveDown:SENSITIVE = FALSE.
    ELSE
      buMoveDown:SENSITIVE = TRUE.
    
    
/*  ASSIGN
        
        buMoveDown:SENSITIVE = (IF INTEGER(fiPage:SCREEN-VALUE)  = 1 THEN FALSE ELSE TRUE)
        buMoveUp:SENSITIVE   = (IF INTEGER(fiPage:SCREEN-VALUE) >= (NUM-ENTRIES(cFolderLabels, "|":U) - 1) THEN FALSE ELSE TRUE).
*/  
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateUpDown sObject 
FUNCTION evaluateUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPageSource   AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    {get PageSource hPageSource ghParentContainer}.
    
    ASSIGN
        fiPage

        cFolderLabels    = DYNAMIC-FUNCTION("getFolderLabels":U IN hPageSource)
        buDown:SENSITIVE = (IF INTEGER(fiPage:SCREEN-VALUE)  = 1 THEN FALSE ELSE TRUE)
        buUp:SENSITIVE   = (IF INTEGER(fiPage:SCREEN-VALUE) >= (NUM-ENTRIES(cFolderLabels, "|":U) - 1) THEN FALSE ELSE TRUE).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateSequence sObject 
FUNCTION updateSequence RETURNS LOGICAL
  (pcInstanceName AS CHARACTER,
   piPageSequence AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPageObject           AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj =       DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        httSmartObject          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U))
        httPageObject           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPageObject":U))
        cContainerMode          =               DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U).

    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

    httObjectInstance:FIND-FIRST(" WHERE c_instance_name            = ":U + QUOTER(pcInstanceName)
                                 + " AND d_customization_result_obj = 0.00":U) NO-ERROR.

    IF NOT httObjectInstance:AVAILABLE THEN
      httObjectInstance:FIND-FIRST(" WHERE c_instance_name            = ":U + QUOTER(pcInstanceName)
                                   + " AND d_customization_result_obj = DECIMAL(":U + QUOTER(dCustomizationResultObj) + ")":U).

    httSmartObject:FIND-FIRST(" WHERE d_smartobject_obj <> 0.00":U
                              + " AND d_customization_result_obj = DECIMAL(":U + QUOTER(dCustomizationResultObj) + ")":U).

    httPageObject:FIND-FIRST(" WHERE d_container_smartobject_obj = DECIMAL(":U + QUOTER(httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE) + ")":U
                             + " AND d_object_instance_obj = DECIMAL(":U + QUOTER(httObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE) + ")":U
                             + " AND c_action             <> 'D'":U).

    ASSIGN
        httPageObject:BUFFER-FIELD("i_page_object_sequence":U):BUFFER-VALUE = piPageSequence.

    IF httPageObject:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
      httPageObject:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

    IF cContainerMode <> "UPDATE":U THEN
    DO:
      DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
      DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
    END.

    DELETE OBJECT httObjectInstance.
    httObjectInstance = ?.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

