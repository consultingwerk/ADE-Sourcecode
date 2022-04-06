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
       {"ry/obj/rycatfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: rycsutprpv.w

  Description:  This viewer will read all the class definition files from a specified
                directory and display them in a dynamic browser.
                It will then allow the user to create these classes and their attributes
                in the Repository database.

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:            0   UserRef: MIP   
                Date:   11/05/2002   Author:  Mark Davies (MIP)

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

&scop object-name       rycustpr2v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

{ry/inc/rycustprpt.i}

DEFINE VARIABLE ghAttrBrowse       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghAttrQuery        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbar          AS HANDLE     NO-UNDO.
DEFINE VARIABLE glTrackChange      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glChangesMade      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE grLastChangedRowid AS ROWID      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycatfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiTitle 
&Scoped-Define DISPLAYED-OBJECTS fiTitle 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusText vTableWin 
FUNCTION setStatusText RETURNS LOGICAL
  ( pcStatusText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coConstantLevel AS CHARACTER FORMAT "X(10)" 
     LABEL "Constant Level" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Instance Level","",
                     "Class Level","Class",
                     "Master Level","Master"
     DROP-DOWN-LIST
     SIZE 24 BY 1 TOOLTIP "Lowest level where the value can be stored and changed (also through instances)".

DEFINE VARIABLE fiAttrName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Attribute Label" 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiOverrideTypeLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Override Type" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE cOverride AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "None", ""
     SIZE 64.4 BY 3.24 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.8 BY 4.05.

DEFINE VARIABLE toDerivedValue AS LOGICAL INITIAL no 
     LABEL "Derived Value" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.4 BY 1 TOOLTIP "Check if the value is derived from other data and/or attributes".

DEFINE VARIABLE toDesignOnly AS LOGICAL INITIAL no 
     LABEL "Design Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.4 BY 1.

DEFINE VARIABLE toIsPrivate AS LOGICAL INITIAL no 
     LABEL "Private" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.6 BY 1.

DEFINE VARIABLE toLoad AS LOGICAL INITIAL no 
     LABEL "Load into Repository" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.2 BY .81 TOOLTIP "Check to load this attribute into the Repository" NO-UNDO.

DEFINE VARIABLE toRuntimeOnly AS LOGICAL INITIAL no 
     LABEL "Runtime Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.6 BY 1 TOOLTIP "Check if the value is set by runtime logic and not stored in the Repository" NO-UNDO.

DEFINE VARIABLE toSystemOwned AS LOGICAL INITIAL no 
     LABEL "System Owned" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.2 BY 1.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(500)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .71
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiTitle AT ROW 1 COL 1 NO-LABEL
     SPACE(94.00) SKIP(16.05)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .

DEFINE FRAME frDetail
     fiAttrName AT ROW 1 COL 15.4 COLON-ALIGNED
     coConstantLevel AT ROW 2.05 COL 15.4 COLON-ALIGNED HELP
          "Constant level"
     toLoad AT ROW 3.24 COL 17.4 HELP
          "Load attribute into repository"
     toRuntimeOnly AT ROW 4.24 COL 17.4 HELP
          "Runtime only"
     toDerivedValue AT ROW 5.24 COL 17.4 HELP
          "Derived value"
     toIsPrivate AT ROW 3.24 COL 42.2 HELP
          "Is private"
     toSystemOwned AT ROW 4.24 COL 42.2 HELP
          "System owned"
     toDesignOnly AT ROW 5.24 COL 42.2 HELP
          "Design only"
     cOverride AT ROW 7 COL 20.6 HELP
          "Override type" NO-LABEL
     fiOverrideTypeLabel AT ROW 6.24 COL 17.4 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 6.48 COL 17.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 7.95
         SIZE 96 BY 9.81.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycatfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycatfullo.i}
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
         HEIGHT             = 16.81
         WIDTH              = 96.4.
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
/* REPARENT FRAME */
ASSIGN FRAME frDetail:FRAME = FRAME frMain:HANDLE.

/* SETTINGS FOR FRAME frDetail
   Custom                                                               */
/* SETTINGS FOR FILL-IN fiOverrideTypeLabel IN FRAME frDetail
   NO-ENABLE                                                            */
ASSIGN 
       fiOverrideTypeLabel:PRIVATE-DATA IN FRAME frDetail     = 
                "Override Type".

/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiTitle IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define FRAME-NAME frDetail
&Scoped-define SELF-NAME coConstantLevel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coConstantLevel vTableWin
ON VALUE-CHANGED OF coConstantLevel IN FRAME frDetail /* Constant Level */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cOverride
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cOverride vTableWin
ON VALUE-CHANGED OF cOverride IN FRAME frDetail
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDerivedValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDerivedValue vTableWin
ON VALUE-CHANGED OF toDerivedValue IN FRAME frDetail /* Derived Value */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDesignOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDesignOnly vTableWin
ON VALUE-CHANGED OF toDesignOnly IN FRAME frDetail /* Design Only */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toIsPrivate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toIsPrivate vTableWin
ON VALUE-CHANGED OF toIsPrivate IN FRAME frDetail /* Private */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toLoad vTableWin
ON VALUE-CHANGED OF toLoad IN FRAME frDetail /* Load into Repository */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRuntimeOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRuntimeOnly vTableWin
ON VALUE-CHANGED OF toRuntimeOnly IN FRAME frDetail /* Runtime Only */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSystemOwned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSystemOwned vTableWin
ON VALUE-CHANGED OF toSystemOwned IN FRAME frDetail /* System Owned */
DO:
  IF glTrackChange THEN
    RUN changeMade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE centreText vTableWin 
PROCEDURE centreText :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldWidth           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSpaceWidth           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStringWidth          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumSpaces            AS INTEGER    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiTitle:SCREEN-VALUE = TRIM(fiTitle:SCREEN-VALUE)
           iFieldWidth          = fiTitle:WIDTH-PIXELS
           iSpaceWidth          = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(" ":U)
           iStringWidth         = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(fiTitle:SCREEN-VALUE).
                                 
    ASSIGN iNumSpaces = ROUND(((iFieldWidth - iStringWidth) / iSpaceWidth) / 2,0)
           fiTitle:SCREEN-VALUE = FILL(" ":U,iNumSpaces) + fiTitle:SCREEN-VALUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeMade vTableWin 
PROCEDURE changeMade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN setToolbarState (INPUT "Changed").
  glChangesMade = TRUE.
  IF AVAILABLE ttAttribute THEN
    grLastChangedRowid = ROWID(ttAttribute).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createAttrBrowser vTableWin 
PROCEDURE createAttrBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSortColumn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldChars     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldChars     AS INTEGER    NO-UNDO.

  CREATE QUERY ghAttrQuery.
  ghAttrQuery:ADD-BUFFER("ttAttribute").

  /* Create the dynamic browser and size it relative to the containing window */
  CREATE BROWSE ghAttrBrowse
     ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
            ROW              = fiTitle:ROW + fiTitle:HEIGHT + .1
            COL              = 1
            WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 3
            HEIGHT-CHARS     = FRAME {&FRAME-NAME}:HEIGHT-CHARS - (fiTitle:ROW IN FRAME frMain + fiTitle:HEIGHT IN FRAME frMain) - FRAME frDetail:ROW - .5
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = FALSE
            READ-ONLY        = FALSE
            QUERY            = ghAttrQuery
      /* Set procedures to handle browser events */
      TRIGGERS:
        ON VALUE-CHANGED
           PERSISTENT RUN valueChanged IN THIS-PROCEDURE.
      END TRIGGERS.

  /* The frame that the browser is on is hidden during construction, 
     so we don't need to hide the dynamic browser while it is being constructed.
     When the frame and window is viewed, then the browser will be viewed, too.
   */
  ASSIGN ghAttrBrowse:SENSITIVE = NO.
  
  hBuffer = TEMP-TABLE ttAttribute:DEFAULT-BUFFER-HANDLE.
  
  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hCurField = hBuffer:BUFFER-FIELD(iLoop).
  
    /* Set Sort Column to first column in browse */
    IF NOT VALID-HANDLE(hSortColumn) THEN
      hSortColumn = hCurField.
    
    IF hCurField:LABEL = "NODISPLAY":U THEN
      NEXT.
  
    hField = ghAttrBrowse:ADD-LIKE-COLUMN(hCurField).
    
    /* Check that Character format is never bigger than x(50) */
    IF hField:DATA-TYPE = "CHARACTER":U THEN DO:
      ASSIGN cFieldChars = TRIM(hField:FORMAT,"x(":U)
             cFieldChars = TRIM(hField:FORMAT,")":U).
      ASSIGN iFieldChars = INTEGER(cFieldChars) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        IF iFieldChars > 50 THEN
          hField:FORMAT = "x(50)":U.
      ERROR-STATUS:ERROR = FALSE.
    END.
  END.
  
  ASSIGN ghAttrBrowse:SENSITIVE = TRUE.

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
  HIDE FRAME frDetail.
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject vTableWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "ENTRY":U TO ghAttrBrowse.
  APPLY "VALUE-CHANGED":U TO ghAttrBrowse.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
  DO WITH FRAME frDetail:
    ASSIGN 
    cOverride:DELIMITER = CHR(1)  
    cOverride:RADIO-BUTTONS  =
         "None - Allow direct access to attribute value" + CHR(1) + '':U + CHR(1)
       + "Get  - Force value to be retrieved using get function" + CHR(1) + "GET" + CHR(1)
       + "Set  - Force value to be saved using set function" + CHR(1) + "SET" + CHR(1)
       + "Both - Force use of both set and get functions" + CHR(1) + "GET,SET".
  END.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  ASSIGN fiOverrideTypeLabel:SCREEN-VALUE IN FRAME frDetail = fiOverrideTypeLabel:PRIVATE-DATA.
  /* Code placed here will execute AFTER standard behavior.    */

  RUN createAttrBrowser.
  
  IF NOT VALID-HANDLE(ghToolbar) THEN
    ghToolbar = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U, "TableIO-Source":U)).
  
  RUN resizeObject (frame {&FRAME-NAME}:height, frame {&FRAME-NAME}:width).
                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  glChangesMade = FALSE.
  APPLY "ENTRY":U TO ghAttrBrowse.
  APPLY "VALUE-CHANGED":U TO ghAttrBrowse.
  RUN setToolbarState (INPUT "View").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the viewer
  Parameters: pd_height AS DECIMAL - the desired height (in rows)
              pd_width  AS DECIMAL - the desired width (in columns)
    Notes:    Used internally. Calls to resizeObject are generated by the
              AppBuilder in adm-create-objects for objects which implement it.
              Having a resizeObject procedure is also the signal to the AppBuilder
              to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE = TRUE  
         lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN
         
         FRAME {&FRAME-NAME}:HIDDEN     = TRUE
         FRAME {&FRAME-NAME}:SCROLLABLE = FALSE
         NO-ERROR.
        
  ASSIGN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
         FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth
         FRAME frDetail:ROW                 = FRAME {&FRAME-NAME}:HEIGHT - FRAME frDetail:HEIGHT + 0.9
         NO-ERROR.

        /* Resize dynamic browser (if exists) relative to current frame */
    IF VALID-HANDLE(ghAttrBrowse) THEN
        ASSIGN ghAttrBrowse:WIDTH-CHARS  = pdWidth - 1.5
               ghAttrBrowse:HEIGHT-CHARS = FRAME frDetail:ROW - ghAttrBrowse:ROW - 0.24
               fiTitle:WIDTH             = ghAttrBrowse:WIDTH-CHARS
               NO-ERROR.
    
    /* Centre Text */
    IF fiTitle:SCREEN-VALUE IN FRAME frMain <> "":U THEN
        RUN centreText.

        /* Restore original hidden state of current frame */
    APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
    ASSIGN FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAttributeData vTableWin 
PROCEDURE returnAttributeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttAttribute.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setToolbarState vTableWin 
PROCEDURE setToolbarState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
  
  IF NOT VALID-HANDLE(ghToolbar) THEN
    RETURN.
  
  DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "save,reset,cancel,folderview,folderupdate":U).
  CASE pcState:
    WHEN "Initial" THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "folderupdate":U).
    WHEN "modify" THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "folderview":U).
    WHEN "changed" THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "save,reset":U).
    WHEN "view" THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "folderupdate":U).
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar vTableWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.

  RUN setToolbarState (INPUT pcValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAttr vTableWin 
PROCEDURE updateAttr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttAttribute.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  CASE pcMode:
    WHEN "Modify":U THEN DO:
      IF AVAILABLE ttAttribute AND
         ttAttribute.lExistInDB = FALSE THEN DO:
        ENABLE ALL EXCEPT fiAttrName WITH FRAME frDetail.
        APPLY "ENTRY":U TO coConstantLevel IN FRAME frDetail.
        RUN setToolbarState (INPUT "Modify":U).
      END.
      ELSE DO:
        RUN showMessages IN gshSessionManager (INPUT "This Attribute already exists in the Repository and cannot be modified.",
                                               INPUT "INF":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Cannot Modify Record",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
      END.
    END.
    WHEN "View":U THEN DO:
      DISABLE ALL WITH FRAME frDetail.
      APPLY "ENTRY":U TO ghAttrBrowse.
      RUN setToolbarState (INPUT "View":U).
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowid AS ROWID      NO-UNDO.

  IF AVAILABLE ttAttribute THEN 
    DO WITH FRAME frDetail:
    rRowId = ROWID(ttAttribute).
    ASSIGN coConstantLevel.
    ASSIGN 
      ttAttribute.cConstantLevel = coConstantLevel
      ttAttribute.lLoad          = toLoad:CHECKED
      ttAttribute.lRuntimeOnly   = toRuntimeOnly:CHECKED
      ttAttribute.lDerivedValue  = toDerivedValue:CHECKED
      ttAttribute.lPrivate       = toIsPrivate:CHECKED
      ttAttribute.lSystemOwned   = toSystemOwned:CHECKED
      ttAttribute.lDesignOnly    = toDesignOnly:CHECKED
      ttAttribute.cOverrideType  = cOverride:SCREEN-VALUE.
    glChangesMade = FALSE.
    ghAttrQuery:QUERY-CLOSE().
    ghAttrQuery:QUERY-OPEN().
    ghAttrQuery:REPOSITION-TO-ROWID(rRowid).
  END.
  APPLY "ENTRY":U TO ghAttrBrowse.
  APPLY "VALUE-CHANGED":U TO ghAttrBrowse.
  RUN setToolbarState (INPUT "View").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged vTableWin 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid  AS ROWID      NO-UNDO.
    
  IF FOCUS:HANDLE <> ghAttrBrowse THEN
    RETURN.

  IF glChangesMade THEN DO:
    rRowid = ROWID(ttAttribute).
    RUN askQuestion IN gshSessionManager (INPUT        "You have made changes to this record that are not saved.~n~nDo you wish to save your changes now?",    /* message to display */
                                           INPUT        "&YES,&NO":U,    /* button list */
                                           INPUT        "&YES":U,                /* default button */ 
                                           INPUT        "&No":U,             /* cancel button */
                                           INPUT        "Save Changes":U, /* window title */
                                           INPUT        "":U,                    /* data type of question */ 
                                           INPUT        "":U,                    /* format mask for question */ 
                                           INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                 OUTPUT cButton                  /* button pressed */
                                           ).
    IF cButton = "&YES":U THEN DO:
      ghAttrQuery:REPOSITION-TO-ROWID(grLastChangedRowid).
      RUN updateRecord.
      ghAttrQuery:REPOSITION-TO-ROWID(rRowid).
    END.

  END.
  DO WITH FRAME frDetail:
    DISABLE ALL.
  END.
  
  CLEAR FRAME frDetail ALL NO-PAUSE.
  fiOverrideTypeLabel:SCREEN-VALUE IN FRAME frDetail = fiOverrideTypeLabel:PRIVATE-DATA.

  IF AVAILABLE ttAttribute AND 
     ghAttrQuery:NUM-RESULTS <> 0 THEN DO WITH FRAME frDetail:

    ASSIGN glTrackChange                = FALSE
           fiAttrName:SCREEN-VALUE      = ttAttribute.cAttrName
           coConstantLevel:SCREEN-VALUE = ttAttribute.cConstantLevel
           toLoad:CHECKED               = ttAttribute.lLoad
           toRuntimeOnly:CHECKED        = ttAttribute.lRuntimeOnly
           toDerivedValue:CHECKED       = ttAttribute.lDerivedValue
           toIsPrivate:CHECKED          = ttAttribute.lPrivate
           toSystemOwned:CHECKED        = ttAttribute.lSystemOwned
           toDesignOnly:CHECKED         = ttAttribute.lDesignOnly
           cOverride:SCREEN-VALUE       = ttAttribute.cOverrideType.
    RUN setToolbarState (INPUT "Initial").
    glTrackChange = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedClass vTableWin 
PROCEDURE valueChangedClass :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phClassBrowse AS HANDLE     NO-UNDO.

  RUN setToolbarState (INPUT "":U).

  IF phClassBrowse:NUM-SELECTED-ROWS = 1 THEN
    fiTitle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "<< Custom Properties for " + pcFileName + " >>":U.
  ELSE
    IF phClassBrowse:NUM-SELECTED-ROWS > 0 THEN
      fiTitle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "<< Multiple Rows Selected >>".
    ELSE
      fiTitle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  RUN centreText.
  ghAttrQuery:QUERY-CLOSE().
  IF phClassBrowse:NUM-SELECTED-ROWS = 1 THEN
    ghAttrQuery:QUERY-PREPARE("FOR EACH ttAttribute WHERE ttAttribute.cFileName = '" + pcFileName + "'").
  ELSE
    ghAttrQuery:QUERY-PREPARE("FOR EACH ttAttribute WHERE ttAttribute.cFileName = 'ZZ9XX9ZZ9XX'").
  ghAttrQuery:QUERY-OPEN().
  
  APPLY "ENTRY":U TO ghAttrBrowse.
  APPLY "VALUE-CHANGED":U TO ghAttrBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusText vTableWin 
FUNCTION setStatusText RETURNS LOGICAL
  ( pcStatusText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns Status Text
    Notes:  
------------------------------------------------------------------------------*/
  
  STATUS DEFAULT pcStatusText. 

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

