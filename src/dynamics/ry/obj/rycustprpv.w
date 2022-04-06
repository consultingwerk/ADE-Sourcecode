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

&scop object-name       rycustprpv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

{ry/inc/rycustprpt.i}

DEFINE VARIABLE DOS-SLASH      AS CHARACTER  NO-UNDO     /* Backslash */
  INITIAL "~\":U.
DEFINE VARIABLE UNIX-SLASH     AS CHARACTER  NO-UNDO     /* Forwardslash */
  INITIAL "/":U.

DEFINE VARIABLE ghClassBrowse  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghClassQuery   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghAttSO        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghClassField   AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcClassName    AS CHARACTER  NO-UNDO INITIAL
  "Action,Appserver,b2b,browser,combo,consumer,containr,data,datavis,FIELD,filter,LOOKUP,messaging,msghandler,panel,producer,QUERY,router,sbo,SELECT,smart,toolbar,tvcontnr,viewer,visual,xml".
DEFINE VARIABLE gcMappedClass  AS CHARACTER  NO-UNDO INITIAL
  "Action,Appserver,B2B,Browser,DynCombo,Consumer,Container,Data,DataVisual,FIELD,Filter,DynLookup,Messaging,MsgHandler,Panel,Producer,QUERY,Router,SBO,SELECT,Base,SmartToolbar,DynTree,Viewer,Visual,XML".

DEFINE STREAM s4GL.

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiInputDirectory buRootDirectory buSize 
&Scoped-Define DISPLAYED-OBJECTS fiInputDirectory 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinWidth vTableWin 
FUNCTION getMinWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSiteNumber vTableWin 
FUNCTION getSiteNumber RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidth vTableWin 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusText vTableWin 
FUNCTION setStatusText RETURNS LOGICAL
  ( pcStatusText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeselectAll 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buFetch DEFAULT 
     LABEL "&Fetch Class List" 
     SIZE 19 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buLoad 
     LABEL "&Load" 
     SIZE 15 BY 1.14 TOOLTIP "Load selected classes into Repository."
     BGCOLOR 8 .

DEFINE BUTTON buRootDirectory 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.4 BY 1 TOOLTIP "Directory lookup"
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSize  NO-FOCUS
     LABEL "DO NOT REMOVE" 
     SIZE .8 BY .19 TOOLTIP "This button is required to maintain the smallest size for this viewer"
     BGCOLOR 8 .

DEFINE VARIABLE EdReadFile AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 2 BY .76 TOOLTIP "DO NOT REMOVE" NO-UNDO.

DEFINE VARIABLE fiInputDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Directory" 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1 TOOLTIP "Select the directory where all the class definition files can be located." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     EdReadFile AT ROW 1.95 COL 1.8 NO-LABEL
     buSelectAll AT ROW 2.71 COL 1.6
     fiInputDirectory AT ROW 1.1 COL 17.4 COLON-ALIGNED
     buDeselectAll AT ROW 2.71 COL 17
     buLoad AT ROW 2.71 COL 32.6
     buRootDirectory AT ROW 1.14 COL 97.2
     buFetch AT ROW 1 COL 102.8
     buSize AT ROW 8.33 COL 121.8 NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 122.6 BY 7.52
         DEFAULT-BUTTON buFetch.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycatfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
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
         HEIGHT             = 7.52
         WIDTH              = 122.6.
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
   NOT-VISIBLE L-To-R,COLUMNS                                           */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buDeselectAll IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buFetch IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buLoad IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSelectAll IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buSize:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR EDITOR EdReadFile IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       EdReadFile:HIDDEN IN FRAME frMain           = TRUE
       EdReadFile:RETURN-INSERTED IN FRAME frMain  = TRUE.

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

&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll vTableWin
ON CHOOSE OF buDeselectAll IN FRAME frMain /* Deselect All */
DO:
  ghClassQuery:QUERY-CLOSE().
  ghClassQuery:QUERY-OPEN().
  APPLY "VALUE-CHANGED":U TO ghClassBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFetch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFetch vTableWin
ON CHOOSE OF buFetch IN FRAME frMain /* Fetch Class List */
DO:

  EMPTY TEMP-TABLE ttClassDef.
  EMPTY TEMP-TABLE ttAttribute.
  
  RUN fetchFiles.
  
  ghClassQuery:QUERY-CLOSE().
  ghClassQuery:QUERY-PREPARE("FOR EACH ttClassDef NO-LOCK").
  ghClassQuery:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLoad vTableWin
ON CHOOSE OF buLoad IN FRAME frMain /* Load */
DO:
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogString      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogFile        AS CHARACTER  NO-UNDO.
  
  IF NOT ghClassBrowse:NUM-SELECTED-ROWS >= 1 THEN
    RUN showMessages IN gshSessionManager (INPUT "You must select at least one class to be loaded into the repository.",
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "No class record selected",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  ELSE DO:
    EMPTY TEMP-TABLE ttAttribute.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN markSelected.
    setStatusText("Create new classes and attributes in Repository...").
    RUN returnAttributeData IN ghAttSO (OUTPUT TABLE ttAttribute).
    RUN ry/app/rycustload.p ON gshAstraAppserver (INPUT FALSE,
                                                  INPUT-OUTPUT TABLE ttClassDef,
                                                  INPUT-OUTPUT TABLE ttAttribute,
                                                  OUTPUT cLogString).
    RUN updateAttr IN ghAttSO (INPUT TABLE ttAttribute).

    FILE-INFO:FILE-NAME = ".":U.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN
      ASSIGN cLogFile = FILE-INFO:FULL-PATHNAME.
    ELSE 
      ASSIGN cLogFile = SESSION:TEMP-DIR.

    cLogFile = REPLACE(cLogFile,DOS-SLASH,UNIX-SLASH).

    IF R-INDEX(cLogFile,UNIX-SLASH) <> LENGTH(cLogFile) THEN
      cLogFile = cLogFile + UNIX-SLASH.

    cLogFile = cLogFile + "newClasses.log".

    OUTPUT TO VALUE(cLogFile).
    PUT UNFORMATTED cLogString.
    OUTPUT CLOSE.
    setStatusText("").
    SESSION:SET-WAIT-STATE("":U).
    RUN showMessages IN gshSessionManager (INPUT "The following log file was created for your review: " + cLogFile,
                                           INPUT "INF":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Log File",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).

    ghClassQuery:QUERY-CLOSE().
    ghClassQuery:QUERY-PREPARE("FOR EACH ttClassDef NO-LOCK").
    ghClassQuery:QUERY-OPEN().
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRootDirectory vTableWin
ON CHOOSE OF buRootDirectory IN FRAME frMain /* ... */
DO:
    RUN getFolder("Directory", OUTPUT fiInputDirectory).
    IF fiInputDirectory <> "":U THEN
      ASSIGN
          fiInputDirectory:SCREEN-VALUE = fiInputDirectory.
    APPLY "VALUE-CHANGED":U TO fiInputDirectory.
    APPLY "entry":U TO fiInputDirectory.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll vTableWin
ON CHOOSE OF buSelectAll IN FRAME frMain /* Select All */
DO:
  ghClassBrowse:SELECT-ALL().
  APPLY "VALUE-CHANGED":U TO ghClassBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInputDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInputDirectory vTableWin
ON LEAVE OF fiInputDirectory IN FRAME frMain /* Class Directory */
DO:
  IF {&SELF-NAME}:SCREEN-VALUE = "":U OR
     {&SELF-NAME}:SCREEN-VALUE = ? THEN
    buFetch:SENSITIVE = NO.
  ELSE
    buFetch:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInputDirectory vTableWin
ON VALUE-CHANGED OF fiInputDirectory IN FRAME frMain /* Class Directory */
DO:
  IF {&SELF-NAME}:SCREEN-VALUE = "":U OR
     {&SELF-NAME}:SCREEN-VALUE = ? THEN
    buFetch:SENSITIVE = NO.
  ELSE DO:
    FILE-INFO:FILE-NAME = {&SELF-NAME}:SCREEN-VALUE.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN
      ASSIGN SELF:FGCOLOR = ?
             buFetch:SENSITIVE = TRUE.
    ELSE
      ASSIGN SELF:FGCOLOR = 8
             buFetch:SENSITIVE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignCustomAttributes vTableWin 
PROCEDURE assignCustomAttributes :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create a temp file out to disk and run it and
               it should return any custom attributes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcCustomFile  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cTempFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFileRead AS LOGICAL    NO-UNDO.

  RUN adecomm/_tmpfile.p
      (INPUT 'dyn':U,
       INPUT '.ab':U,
       OUTPUT cTempFile).
  OUTPUT STREAM s4GL TO VALUE(cTempFile).

  PUT STREAM s4GL UNFORMATTED 
    "~{ry/inc/rycustprpt.i~}" SKIP(1) 
    "DEFINE INPUT        PARAMETER pcFileName AS CHARACTER NO-UNDO." SKIP
    "DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttAttribute." SKIP(1)

    "DEFINE VARIABLE ghADMProps   AS HANDLE     NO-UNDO." SKIP
    "DEFINE VARIABLE hADMPropsBuf AS HANDLE     NO-UNDO." SKIP
    "DEFINE VARIABLE lTTOkay      AS LOGICAL    NO-UNDO." SKIP
    "DEFINE VARIABLE hField       AS HANDLE     NO-UNDO." SKIP
    "DEFINE VARIABLE iNumField    AS INTEGER    NO-UNDO." SKIP(1)
    "CREATE TEMP-TABLE ghADMProps." SKIP(1).

  PUT STREAM s4GL UNFORMATTED
    "~{" pcCustomFile "~}" SKIP(1).

  PUT STREAM s4GL UNFORMATTED
    "lTTOkay = ghADMProps:TEMP-TABLE-PREPARE('ADMProps':U) NO-ERROR." SKIP
    "IF lTTOkay THEN DO:" SKIP
    "  hADMPropsBuf = ghADMProps:DEFAULT-BUFFER-HANDLE." SKIP
    "  hADMPropsBuf:BUFFER-CREATE()." SKIP.

  PUT STREAM s4GL UNFORMATTED
    "  DO iNumField = 1 TO hADMPropsBuf:NUM-FIELDS:" SKIP
    "    hField = hADMPropsBuf:BUFFER-FIELD(iNumField)." SKIP
    "    FIND FIRST ttAttribute" SKIP
    "         WHERE ttAttribute.cFileName = pcFileName" SKIP
    "         AND   ttAttribute.cAttrName = hField:NAME"
    "         NO-LOCK NO-ERROR." SKIP
    "    IF NOT AVAILABLE ttAttribute THEN DO:":U SKIP
    "      CREATE ttAttribute." SKIP
    "      ASSIGN ttAttribute.cFileName = pcFileName" SKIP
    "             ttAttribute.cAttrName = hField:NAME" SKIP
    "             ttAttribute.iExtent   = hField:EXTENT" SKIP
    "             ttAttribute.cFormat   = hField:FORMAT" SKIP
    "             ttAttribute.cDataType = hField:DATA-TYPE" SKIP
    "             ttAttribute.cInitial  = hField:INITIAL." SKIP
    "    END." SKIP
    "  END." SKIP
    "END.".

  OUTPUT STREAM s4GL CLOSE.

  RUN VALUE(cTempFile) (INPUT pcFileName, INPUT-OUTPUT TABLE ttAttribute) NO-ERROR.

  OS-DELETE VALUE(cTempFile).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN edReadFile:SCREEN-VALUE = "":U NO-ERROR.
    lFileRead = edReadFile:READ-FILE(pcCustomFile) NO-ERROR.
    /* Set other details */
    FOR EACH  ttAttribute
        WHERE ttAttribute.cFileName = pcFileName
        EXCLUSIVE-LOCK:
      ASSIGN ttAttribute.lLoad          = YES
             ttAttribute.cConstantLevel = "":U. /* Instance */
      IF lFileRead THEN
        IF edReadFile:SEARCH("xp":U + ttAttribute.cAttrName,17) THEN
          ttAttribute.cOverrideType = "":U.
        ELSE
          ttAttribute.cOverrideType = "GET,SET":U.
    END.
    ASSIGN edReadFile:SCREEN-VALUE = "":U NO-ERROR.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPropFileList vTableWin 
PROCEDURE buildPropFileList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLine           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearch         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourcePath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColPos         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessageList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.

  FOR EACH ttClassDef:
      
      INPUT FROM VALUE(ttClassDef.cPath) NO-ECHO.

      REPEAT:
        IMPORT UNFORMATTED cLine.
        ASSIGN cLine   = TRIM(cLine)
               iColPos = INDEX(cLine , ":":U)
               cSearch = SUBSTRING(cLine, 1, iColPos - 1)
               .
        CASE cSearch:       
            WHEN "Class SourcePath":U THEN
                ASSIGN cSourcePath = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)).
            WHEN "Custom Property":U THEN
                ASSIGN cCustomProperty = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)).            
        END CASE.
      END. /* repeat import */

      INPUT CLOSE.

      IF cCustomProperty NE "":U THEN  
      ASSIGN   
        cSourcePath     = REPLACE(RIGHT-TRIM(cSourcePath, UNIX-SLASH), UNIX-SLASH, DOS-SLASH)
        cSourcePath     = IF cSourcePath NE "":U THEN (cSourcePath + DOS-SLASH) ELSE cSourcePath
        cCustomProperty = cSourcePath + "custom":U + DOS-SLASH + cCustomProperty
        .

      IF SEARCH(cCustomProperty) <> ? THEN DO:
        setStatusText("Checking for custom properties in " + cCustomProperty).
        RUN assignCustomAttributes (INPUT ttClassDef.cFileName,cCustomProperty).
      END.
  END.

  setStatusText("Preparing table...").
  FOR EACH ttClassDef 
      EXCLUSIVE-LOCK:
    IF NOT CAN-FIND(FIRST ttAttribute
                    WHERE ttAttribute.cFileName = ttClassDef.cFileName) THEN
      DELETE ttClassDef.
  END.

  IF CAN-FIND(FIRST ttClassDef) THEN DO:
    ghClassQuery:QUERY-CLOSE().
    ghClassQuery:QUERY-PREPARE("FOR EACH ttClassDef NO-LOCK").
    ghClassQuery:QUERY-OPEN().
    APPLY "VALUE-CHANGED":U TO ghClassBrowse.
    ENABLE buSelectAll buDeselectAll buLoad WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
    DISABLE buSelectAll buDeselectAll WITH FRAME {&FRAME-NAME}.
    cMessageList = {af/sup2/aferrortxt.i 'AF' '39' '' '' '"Customized Class Property File"'}.
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "File not found",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  END.
  setStatusText("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createClassBrowser vTableWin 
PROCEDURE createClassBrowser :
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
  DEFINE VARIABLE dHeight         AS DECIMAL    NO-UNDO.

  CREATE QUERY ghClassQuery.
  ghClassQuery:ADD-BUFFER("ttClassDef").

  dHeight = (FRAME {&FRAME-NAME}:HEIGHT-CHARS - 3.5) / 2.
  
  IF dHeight < 4 THEN
    dHeight = 4.
  
  /* Create the dynamic browser and size it relative to the containing window */
  CREATE BROWSE ghClassBrowse
     ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
            ROW              = 2.5
            COL              = 1.5
            WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 3
            HEIGHT-CHARS     = dHeight
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = FALSE
            READ-ONLY        = FALSE
            MULTIPLE         = TRUE
            QUERY            = ghClassQuery
      /* Set procedures to handle browser events */
      TRIGGERS:
        ON VALUE-CHANGED
           PERSISTENT RUN valueChangedClass IN THIS-PROCEDURE.
        ON ROW-LEAVE
           PERSISTENT RUN saveClassName IN TARGET-PROCEDURE.
      END TRIGGERS.

  /* Hide the dynamic browser while it is being constructed */
  ASSIGN
   ghClassBrowse:VISIBLE   = NO
   ghClassBrowse:SENSITIVE = NO.
  
  hBuffer = TEMP-TABLE ttClassDef:DEFAULT-BUFFER-HANDLE.
  
  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO hBuffer:NUM-FIELDS:
    hCurField = hBuffer:BUFFER-FIELD(iLoop).
  
    /* Set Sort Column to first column in browse */
    IF NOT VALID-HANDLE(hSortColumn) THEN
      hSortColumn = hCurField.
    IF hCurField:LABEL = "NODISPLAY":U THEN
      NEXT.
    hField = ghClassBrowse:ADD-LIKE-COLUMN(hCurField).
  
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

    IF hField:NAME = "cClassName" THEN DO:
      hField:READ-ONLY = FALSE.
      ghClassField = hField.
    END.
  END.
  
  ASSIGN
   ghClassBrowse:VISIBLE   = TRUE
   ghClassBrowse:SENSITIVE = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFiles vTableWin 
PROCEDURE fetchFiles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogString   AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN 
      fiInputDirectory
    .

    IF fiInputDirectory = "":U OR
       fiInputDirectory = ? THEN 
      RETURN.
 
    setStatusText("Looking for class definition files in " + fiInputDirectory).
    EMPTY TEMP-TABLE ttClassDef.
    RUN readFiles(INPUT fiInputDirectory).
    setStatusText("":U).

    SESSION:SET-WAIT-STATE("":U).
    IF NOT CAN-FIND(FIRST ttClassDef) THEN DO:
      DISABLE buSelectAll buDeselectAll WITH FRAME {&FRAME-NAME}.
      cMessageList = {af/sup2/aferrortxt.i 'AF' '39' '' '' '"Class Definition File"'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "File not found",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN.
    END.

    RUN buildPropFileList.
    setStatusText("Check for existance of attributes in Repository...").
    RUN ry/app/rycustload.p ON gshAstraAppserver (INPUT TRUE,
                                                  INPUT-OUTPUT TABLE ttClassDef,
                                                  INPUT-OUTPUT TABLE ttAttribute,
                                                  OUTPUT cLogString).

    RUN updateAttr IN ghAttSO (INPUT TABLE ttAttribute).
    setStatusText("":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder vTableWin 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ipTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER opPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lhServer AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  hWin   = hFrame:WINDOW.
  
  CREATE 'Shell.Application' lhServer.
  
  ASSIGN
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,ipTitle,0).
  
  IF VALID-HANDLE(lhFolder) = True 
  THEN DO:
      ASSIGN 
          lvFolder = lhFolder:Title
          lhParent = lhFolder:ParentFolder
          lvCount  = 0.
      REPEAT:
          IF lvCount >= lhParent:Items:Count THEN
              DO:
                  ASSIGN
                      opPath = "":U.
                  LEAVE.
              END.
          ELSE
              IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                  DO:
                      ASSIGN
                          opPath = lhParent:Items:Item(lvCount):Path.
                      LEAVE.
                  END.
          ASSIGN lvCount = lvCount + 1.
      END.
  END.
  ELSE
      ASSIGN
          opPath = "":U.
  
  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.
  
  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?
    .
  
  IF SUBSTRING(opPath,1,2) <> "~\~\":U THEN
    ASSIGN opPath = TRIM(REPLACE(LC(opPath),"~\":U,"/":U),"/":U).

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

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN createClassBrowser.

  RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT, FRAME {&FRAME-NAME}:WIDTH).
  
  IF NOT VALID-HANDLE(ghAttSO) THEN
    ghAttSO = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U, "Attribute-Target":U)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE markSelected vTableWin 
PROCEDURE markSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttClassDef FOR ttClassDef.

  FOR EACH bttClassDef:
    bttClassDef.lCreate = FALSE.
  END.

  DO iCount = 1 TO ghClassBrowse:NUM-SELECTED-ROWS:
    ghClassBrowse:FETCH-SELECTED-ROW(iCount).
    ASSIGN ttClassDef.lCreate = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readFiles vTableWin 
PROCEDURE readFiles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcDirectory  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRootFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWrkDir      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttClassDef FOR ttClassDef.

  ERROR-STATUS:ERROR = NO.

  INPUT FROM OS-DIR(pcDirectory).
  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  REPEAT:
    IMPORT
      cRootFile
      cFullPath
      cFlags
    .
    IF cRootFile = ".":U OR
       cRootFile = "..":U THEN
      NEXT.

    IF INDEX(cFlags,"F":U) <> 0 THEN
    DO:
      IF NUM-ENTRIES(cRootFile,".":U) > 1 AND
         (ENTRY(NUM-ENTRIES(cRootFile,".":U), cRootFile, ".":U) = "cld":U) THEN
      DO:
        FILE-INFO:FILE-NAME = cFullPath.
        
        DO FOR bttClassDef:
          FIND FIRST bttClassDef 
            WHERE bttClassDef.cPath = cFullPath
            NO-ERROR.
          IF NOT AVAILABLE(bttClassDef) THEN
          DO:
            CREATE bttClassDef.
            ASSIGN
              cFullPath = REPLACE(cFullPath,"~\":U,"/":U)
              bttClassDef.cFileName  = TRIM(SUBSTRING(cFullPath,LENGTH(fiInputDirectory) + 1),"/":U)
              bttClassDef.cPath      = cFullPath
              bttClassDef.cRootDir   = TRIM(SUBSTRING(cFullPath,1,LENGTH(fiInputDirectory)),"/":U)
            .
            iEntry = LOOKUP(ENTRY(1,bttClassDef.cFileName,".":U),gcClassName).
            IF iEntry <> 0 THEN
              ASSIGN bttClassDef.cClassName   = ENTRY(iEntry,gcMappedClass) + "_SITE_":U + TRIM(STRING(getSiteNumber(),">>>>>>>>>>>>9":U))
                     bttClassDef.cExtendsFrom = ENTRY(iEntry,gcMappedClass).
            ELSE
              bttClassDef.cClassName = bttClassDef.cFileName.
          END.
        END.
      END.
    END.

  END.
  INPUT CLOSE.   

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

  IF pdHeight = 0 AND
     pdWidth = 0 THEN
    RETURN.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 80.
  FRAME {&FRAME-NAME}:WIDTH-PIXELS  = hWindow:WIDTH-PIXELS  - 28.

  /* Resize dynamic browser (if exists) relative to current frame */
  IF VALID-HANDLE(ghClassBrowse) THEN
  DO:
    ghClassBrowse:WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 2.
    ghClassBrowse:HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS - 3.

    ASSIGN buSelectAll:ROW   = FRAME {&FRAME-NAME}:HEIGHT - buSelectAll:HEIGHT + .8
           buDeselectAll:ROW = buSelectAll:ROW
           buLoad:ROW        = buSelectAll:ROW
           NO-ERROR.
  END.

  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveClassName vTableWin 
PROCEDURE saveClassName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO.

  IF ghClassField:SCREEN-VALUE = "":U THEN DO:
    rRowid = ROWID(ttClassDef).
    cMessageList = {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Repository Class"'}.
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Repository Class",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    ghClassBrowse:REFRESH().
    APPLY "ENTRY":U TO ghClassField.
    ghClassQuery:REPOSITION-TO-ROWID(rRowid).
    APPLY "ROW-ENTRY":U TO ghClassBrowse.
    RETURN NO-APPLY.
  END.
    
  IF AVAILABLE ttClassDef THEN
    ASSIGN ttClassDef.cClassName = ghClassField:SCREEN-VALUE.


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
  IF NOT VALID-HANDLE(ghAttSO) THEN
    RETURN.

  RUN valueChangedClass IN ghAttSO (INPUT ttClassDef.cFileName, ghClassBrowse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinWidth vTableWin 
FUNCTION getMinWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 122.60.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSiteNumber vTableWin 
FUNCTION getSiteNumber RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSiteFwd AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiteRev AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

  ASSIGN
    cSiteRev = STRING(CURRENT-VALUE(seq_site_reverse,ICFDB))
    cSiteFwd = "":U
    .

  DO iCount = LENGTH(cSiteRev) TO 1 BY -1:
    cSiteFwd = cSiteFwd + SUBSTRING(cSiteRev,iCount,1).
  END.
 
  RETURN INTEGER(cSiteFwd).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidth vTableWin 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 122.60.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

