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

DEFINE VARIABLE gcColumnWidths      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQuery         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghttObjectInstance  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghttObjectType      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghColumn            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery             AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buMoveDown raPage buMoveUp fiFilter ~
fiWhichPage 
&Scoped-Define DISPLAYED-OBJECTS raPage fiPage fiFilter fiWhichPage 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD moveUpDown sObject 
FUNCTION moveUpDown RETURNS LOGICAL
  (pcDirection AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery sObject 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
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
     SIZE 4.8 BY 1.14 TOOLTIP "Move the instance down in the list (Initialize later)"
     BGCOLOR 8 .

DEFINE BUTTON buMoveUp 
     IMAGE-UP FILE "ry/img/moveup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move the instance up in the list (Initialize earlier)"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Increase page number by 1"
     BGCOLOR 8 .

DEFINE VARIABLE fiFilter AS CHARACTER FORMAT "X(256)":U INITIAL "  Filter" 
      VIEW-AS TEXT 
     SIZE 23 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPage AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
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
     SIZE 94.4 BY 7.62.

DEFINE RECTANGLE rctPage
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 2.52.

DEFINE RECTANGLE rctToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.8 BY 1.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buMoveDown AT ROW 7.38 COL 8.2
     raPage AT ROW 3.48 COL 72.6 NO-LABEL
     fiPage AT ROW 4.29 COL 82.8 COLON-ALIGNED NO-LABEL
     buMoveUp AT ROW 7.38 COL 3.4
     buDown AT ROW 4.76 COL 89
     buUp AT ROW 4.24 COL 89
     fiFilter AT ROW 1.76 COL 69 COLON-ALIGNED NO-LABEL
     fiWhichPage AT ROW 2.81 COL 72 NO-LABEL
     rctPage AT ROW 3.1 COL 71
     rctBorder AT ROW 1.29 COL 1
     rctToolbar AT ROW 7.29 COL 2.2
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
         HEIGHT             = 7.91
         WIDTH              = 94.4.
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
ASSIGN 
       fiPage:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiWhichPage IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE rctBorder IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctPage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctToolbar IN FRAME frMain
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
  DYNAMIC-FUNCTION("moveUpDown":U, "Down":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMoveUp sObject
ON CHOOSE OF buMoveUp IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("moveUpDown":U, "Up":U).
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
    DYNAMIC-FUNCTION("evaluateUpDown":U).
  ELSE
    ASSIGN
        fiPage:SENSITIVE = FALSE
        buDown:SENSITIVE = FALSE
        buUp:SENSITIVE   = FALSE.

  RUN refreshData (INPUT "":U, INPUT 0.00).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearFilters sObject 
PROCEDURE clearFilters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    fiPage:SCREEN-VALUE = "0":U.

    APPLY "VALUE-CHANGED":U TO raPage.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse sObject 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldLoop  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE     NO-UNDO EXTENT 7.

  IF NOT VALID-HANDLE(ghttObjectInstance) OR
     NOT VALID-HANDLE(ghttObjectType)     THEN
    RETURN.

  CREATE BUFFER ghttObjectInstance FOR TABLE ghttObjectInstance.
  CREATE BUFFER ghttObjectType     FOR TABLE ghttObjectType.
  CREATE QUERY  ghQuery.

  ghQuery:SET-BUFFERS(ghttObjectInstance, ghttObjectType).

  DO WITH FRAME {&FRAME-NAME}:
    gcBaseQuery    = "FOR EACH ttObjectInstance":U
                   + "   WHERE ttObjectInstance.d_customization_result_obj = '&1'":U
                   + "     AND ttObjectInstance.d_object_instance_obj     <> 0":U
                   + "     AND ttObjectInstance.i_page                     = &2":U
                   + "     AND ttObjectInstance.c_action                  <> 'D':U,":U
                   + "   FIRST ttObjectType":U
                   + "   WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U
                   + "      BY ttObjectInstance.i_object_sequence":U.

    CREATE BROWSE ghBrowse
    ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
           NAME             = "PageSequenceBrowse"
           COLUMN-MOVABLE   = TRUE
           SEPARATORS       = TRUE
           ROW-MARKERS      = FALSE
           EXPANDABLE       = TRUE
           COLUMN-RESIZABLE = TRUE
           QUERY            = ghQuery
           REFRESHABLE      = YES
    TRIGGERS:            
        ON "VALUE-CHANGED":U  PERSISTENT RUN trgValueChanged  IN THIS-PROCEDURE.
        ON "ROW-DISPLAY":U    PERSISTENT RUN trgRowDisplay    IN THIS-PROCEDURE.
    END TRIGGERS.

    ASSIGN
        hColumn[1]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("i_page":U))
        hColumn[2]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("i_row":U))
        hColumn[3]         = ghBrowse:ADD-CALC-COLUMN("CHAR":U, "X":U, "":U, "C  ":U)
        hColumn[4]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("c_instance_name":U))
        hColumn[5]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectType:BUFFER-FIELD("c_object_type_code":U))
        hColumn[6]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("l_visible_object":U))
        hColumn[7]         = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("c_instance_description":U))
        ghColumn           = hColumn[3]
        hColumn[3]:NAME    = "i_column":U
        ghBrowse:SENSITIVE = TRUE
        ghBrowse:VISIBLE   = YES.

    DO iFieldLoop = 1 TO ghBrowse:NUM-COLUMNS:
      cEntry = ENTRY(iFieldLoop, gcColumnWidths, "^":U).

      IF INTEGER(cEntry) <> 0 THEN
        hColumn[iFieldLoop]:WIDTH-PIXELS = INTEGER(cEntry).
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.

  cPreferences = "ColumnWidths":U + "|":U.

  DO iColumn = 1 TO ghBrowse:NUM-COLUMNS:
    cPreferences = cPreferences + STRING(ghBrowse:GET-BROWSE-COLUMN(iColumn):WIDTH-PIXELS) + "^":U.
  END.

  cPreferences = TRIM(cPreferences, "^":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code      */
                                             INPUT "CBuilder":U,        /* Profile code           */
                                             INPUT "ObjIOPreferences",  /* Profile data key       */
                                             INPUT ?,                   /* Rowid of profile data  */
                                             INPUT cPreferences,        /* Profile data value     */
                                             INPUT NO,                  /* Delete flag            */
                                             INPUT "PER":U).            /* Save flag (permanent)  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DELETE OBJECT ghttObjectInstance.
  DELETE OBJECT ghttObjectType.
  DELETE OBJECT ghBrowse.
  DELETE OBJECT ghQuery.

  ASSIGN
      ghttObjectInstance = ?
      ghttObjectType     = ?
      ghBrowse           = ?
      ghQuery            = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData sObject 
PROCEDURE getProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowId  AS ROWID      NO-UNDO.

  ASSIGN
      gcColumnWidths = "0^0^0^0^0^0^0":U.

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,            /* Profile type code     */
                                             INPUT "CBuilder":U,          /* Profile code          */
                                             INPUT "ObjIOPreferences":U,  /* Profile data key      */
                                             INPUT "NO":U,                /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,         /* Rowid of profile data */
                                             OUTPUT cPrefs).              /* Found profile data.   */

  /* --- Preference lookup --------------------- */ /* --- Preference value assignment --------------------------------- */
  iEntry = LOOKUP("ColumnWidths":U, cPrefs, "|":U). IF iEntry <> 0 THEN gcColumnWidths  = ENTRY(iEntry + 1, cPrefs, "|":U).

  RETURN.

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
  {get ContainerHandle ghContainerHandle ghContainerSource}.

  {get ContainerToolbarSource ghToolbar ghContainerSource}.

  SUBSCRIBE TO "clearFilters":U IN ghParentContainer.
  SUBSCRIBE TO "refreshData":U  IN ghParentContainer.
  SUBSCRIBE TO "toolbar":U      IN ghToolbar.

  ASSIGN
      ghttObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
      ghttObjectType     = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectType":U))
      
      gcTitle = ghContainerHandle:TITLE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN getProfileData.
  RUN createBrowse.
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiWhichPage:SCREEN-VALUE = " Objects on page ...":U
        fiFilter:SCREEN-VALUE    = " Filter":U
        fiPage:SCREEN-VALUE      = "0":U.

    APPLY "VALUE-CHANGED":U TO raPage.
  END.
  
  DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbMoveDown,cbMoveUp":U).

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
  
  DEFINE VARIABLE hContainerHandle  AS HANDLE     NO-UNDO.
  
  /* Update the container's title */
  {get ContainerHandle hContainerHandle ghParentContainer}.
  
  ghContainerHandle:TITLE = gcTitle + " - ":U + (IF NUM-ENTRIES(hContainerHandle:TITLE, "-":U) >= 2 THEN TRIM(ENTRY(2, hContainerHandle:TITLE, "-":U)) ELSE "":U).

  /* Refresh / rebuild the query */
  DYNAMIC-FUNCTION("reopenBrowseQuery":U).

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) = "FIND":U THEN
    RUN disableObject.
  ELSE
  DO:
    RUN enableObject.

    /* Determine the sensitivity of the up/down arrows */
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
        dDifference              = pdWidth            - rctBorder:WIDTH-CHARS
        rctBorder:HEIGHT-CHARS   = pdHeight           - rctBorder:ROW + 1.00
        rctBorder:WIDTH-CHARS    = pdWidth            
        fiWhichPage:COLUMN       = fiWhichPage:COLUMN + dDifference
        fiFilter:COLUMN          = fiFilter:COLUMN    + dDifference
        rctPage:COLUMN           = rctPage:COLUMN     + dDifference
        buDown:COLUMN            = buDown:COLUMN      + dDifference
        raPage:COLUMN            = raPage:COLUMN      + dDifference
        fiPage:COLUMN            = fiPage:COLUMN      + dDifference
        buUp:COLUMN              = buUp:COLUMN        + dDifference.
  
    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN
          ghBrowse:COLUMN          = 2.20
          ghBrowse:ROW             = 1.76
          ghBrowse:HEIGHT-CHARS    = rctBorder:HEIGHT-CHARS - ghBrowse:ROW    - rctToolbar:HEIGHT-CHARS + 0.75
          ghBrowse:WIDTH-CHARS     = fiFilter:COLUMN        - ghBrowse:COLUMN - 1.00
          rctToolbar:WIDTH-CHARS   = ghBrowse:WIDTH-CHARS
          rctToolbar:ROW           = ghBrowse:ROW           + ghBrowse:HEIGHT-CHARS + 0.25
          buMoveDown:Y             = rctToolbar:Y           + 2
          buMoveUp:Y               = buMoveDown:Y.
  END.
      

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar sObject 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.

  CASE pcAction:
    WHEN "MoveUp":U   THEN DYNAMIC-FUNCTION("moveUpDown":U, "Up":U).
    WHEN "MoveDown":U THEN DYNAMIC-FUNCTION("moveUpDown":U, "Down":U).
    WHEN "Export":U   THEN RUN transferToExcel IN ghParentContainer (INPUT ghBrowse, INPUT ghContainerSource).
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgRowDisplay sObject 
PROCEDURE trgRowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ghColumn:SCREEN-VALUE = KEY-LABEL(KEY-CODE("A") + ghttObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE - 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged sObject 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
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
  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbMoveDown,cbMoveUp":U).

    IF ghQuery:NUM-RESULTS <> 0 AND
       ghQuery:NUM-RESULTS <> ? THEN
    DO:
      IF ghQuery:CURRENT-RESULT-ROW = 1 THEN
        buMoveUp:SENSITIVE = FALSE.
      ELSE
      DO:
        DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbMoveUp":U).
  
        buMoveUp:SENSITIVE = TRUE.
      END.
  
      IF ghQuery:CURRENT-RESULT-ROW = ghQuery:NUM-RESULTS THEN
        buMoveDown:SENSITIVE = FALSE.
      ELSE
      DO:
        DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbMoveDown":U).
  
        buMoveDown:SENSITIVE = TRUE.
      END.
    END.
    ELSE
      DISABLE
          buMoveDown
          buMoveUp.
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
        buDown:SENSITIVE = (IF INTEGER(fiPage:SCREEN-VALUE)  = 0 THEN FALSE ELSE TRUE)
        buUp:SENSITIVE   = (IF INTEGER(fiPage:SCREEN-VALUE) >= (NUM-ENTRIES(cFolderLabels, "|":U) - 1) THEN FALSE ELSE TRUE).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION moveUpDown sObject 
FUNCTION moveUpDown RETURNS LOGICAL
  (pcDirection AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSecondInstanceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstInstanceName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSequenceNumber     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance   AS HANDLE     NO-UNDO.

  cFirstInstanceName = ghttObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
  
  /* Find the correct row */
  IF pcDirection = "Up":U THEN
    ghQuery:GET-PREV().
  ELSE
    ghQuery:GET-NEXT().

  cSecondInstanceName = ghttObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

  /* Reselect the row originally selected */
  IF pcDirection = "Up":U THEN
    ghQuery:GET-NEXT().
  ELSE
    ghQuery:GET-PREV().

  iSequenceNumber = ghttObjectInstance:BUFFER-FIELD("i_object_sequence":U):BUFFER-VALUE.

  DYNAMIC-FUNCTION("evaluateMoveUpDown":U).
  DYNAMIC-FUNCTION("updateSequence":U, cFirstInstanceName,  iSequenceNumber + (IF pcDirection = "Up":U THEN -1 ELSE 1)).
  DYNAMIC-FUNCTION("updateSequence":U, cSecondInstanceName, iSequenceNumber).
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery sObject 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPageNumber             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowID                  AS ROWID      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        raPage
        
        iPageNumber = (IF raPage:SCREEN-VALUE = "P":U THEN DYNAMIC-FUNCTION("getPageSequence":U IN ghParentContainer, INTEGER(fiPage:SCREEN-VALUE))
                                                      ELSE DYNAMIC-FUNCTION("getPageSequence":U IN ghParentContainer, ?))

        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        cBaseQuery              = SUBSTITUTE(gcBaseQuery, dCustomizationResultObj, iPageNumber).

    IF ghttObjectInstance:AVAILABLE THEN
      rRowID = ghttObjectInstance:ROWID.
    ELSE
      rRowID = ?.

    /* Always reopen, in case the sort has changed. */
    ghQuery:QUERY-PREPARE(cBaseQuery).
    
    IF ghQuery:IS-OPEN THEN
       ghQuery:QUERY-CLOSE().
  
    ghQuery:QUERY-OPEN().

    IF ghQuery:NUM-RESULTS > 0 THEN
      {fnarg enableActions 'cbExport':U ghToolbar}.
    ELSE
      {fnarg disableActions 'cbExport':U ghToolbar}.

    RUN trgValueChanged.
  END.

  RETURN TRUE.

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

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj =       DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        cContainerMode          =               DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U).

    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

    httObjectInstance:FIND-FIRST(" WHERE c_instance_name            = ":U + QUOTER(pcInstanceName)
                                 + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

    IF NOT httObjectInstance:AVAILABLE THEN
      httObjectInstance:FIND-FIRST(" WHERE c_instance_name            = ":U + QUOTER(pcInstanceName)
                                   + " AND d_customization_result_obj = 0":U) NO-ERROR.

    ASSIGN
        httObjectInstance:BUFFER-FIELD("i_object_sequence":U):BUFFER-VALUE = piPageSequence.

    IF httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
      httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

    IF cContainerMode <> "UPDATE":U AND
       cContainerMode <> "ADD":U    THEN
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

