&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

{checkerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raLocation lMinimum buBrowse fiFileName ~
lTemplates buGenerate RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS raLocation lMinimum fiFileName lTemplates ~
slSelected slAvailable 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAdd 
     LABEL "Add >" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE BUTTON btnAddAll 
     LABEL "Add All >>" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE BUTTON btnRemove 
     LABEL "< Remove" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE BUTTON btnRemoveAll 
     LABEL "<< Remove All" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE BUTTON buBrowse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     LABEL "&Generate Config File" 
     SIZE 94 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U INITIAL "icfconfig.xml" 
     LABEL "File Name" 
     VIEW-AS FILL-IN 
     SIZE 66.4 BY 1 NO-UNDO.

DEFINE VARIABLE raLocation AS CHARACTER INITIAL "L" 
     VIEW-AS RADIO-SET HORIZONTAL EXPAND 
     RADIO-BUTTONS 
          "Local File", "L",
"Remote File", "R"
     SIZE 49.4 BY .86 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.6 BY 12.57.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.6 BY 12.57.

DEFINE VARIABLE slAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 34.8 BY 10.91 NO-UNDO.

DEFINE VARIABLE slSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 34.4 BY 11.81 NO-UNDO.

DEFINE VARIABLE lMinimum AS LOGICAL INITIAL no 
     LABEL "Minimum XML" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.4 BY .81 TOOLTIP "If selected, only the minimum information to start the session is included" NO-UNDO.

DEFINE VARIABLE lTemplates AS LOGICAL INITIAL no 
     LABEL "Show Templates" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.2 BY .81 TOOLTIP "If selected, only the minimum information to start the session is included" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     raLocation AT ROW 1.19 COL 12.4 NO-LABEL
     lMinimum AT ROW 1.19 COL 64.6
     buBrowse AT ROW 2.38 COL 79.8
     fiFileName AT ROW 2.43 COL 10.6 COLON-ALIGNED
     lTemplates AT ROW 4.52 COL 7.8
     slSelected AT ROW 4.52 COL 59.2 NO-LABEL
     slAvailable AT ROW 5.48 COL 3.2 NO-LABEL
     btnAddAll AT ROW 6.86 COL 41
     btnAdd AT ROW 8.24 COL 41
     btnRemove AT ROW 10.24 COL 41
     btnRemoveAll AT ROW 11.67 COL 41
     buGenerate AT ROW 16.81 COL 1.8
     RECT-1 AT ROW 4.1 COL 2
     RECT-2 AT ROW 4.1 COL 57.8
     "Available Session Types:" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.76 COL 4
     "Selected Session Types:" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.76 COL 59.8
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
         HEIGHT             = 17.19
         WIDTH              = 95.2.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnAdd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnAddAll IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRemove IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRemoveAll IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST slAvailable IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST slSelected IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAdd sObject
ON CHOOSE OF btnAdd IN FRAME F-Main /* Add > */
DO:
  RUN moveItems("Add":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAddAll sObject
ON CHOOSE OF btnAddAll IN FRAME F-Main /* Add All >> */
DO:
  RUN moveItems("AddAll":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemove sObject
ON CHOOSE OF btnRemove IN FRAME F-Main /* < Remove */
DO:
  RUN moveItems("Remove":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemoveAll sObject
ON CHOOSE OF btnRemoveAll IN FRAME F-Main /* << Remove All */
DO:
  RUN moveItems("RemoveAll":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse sObject
ON CHOOSE OF buBrowse IN FRAME F-Main /* Browse... */
DO:
  RUN browseForFile.
  APPLY "VALUE-CHANGED":U TO fiFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate sObject
ON CHOOSE OF buGenerate IN FRAME F-Main /* Generate Config File */
DO:
  RUN generateConfigFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName sObject
ON VALUE-CHANGED OF fiFileName IN FRAME F-Main /* File Name */
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lTemplates
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lTemplates sObject
ON VALUE-CHANGED OF lTemplates IN FRAME F-Main /* Show Templates */
DO:
  RUN populateSelectionList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raLocation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raLocation sObject
ON VALUE-CHANGED OF raLocation IN FRAME F-Main
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slAvailable sObject
ON VALUE-CHANGED OF slAvailable IN FRAME F-Main
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slSelected sObject
ON VALUE-CHANGED OF slSelected IN FRAME F-Main
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseForFile sObject 
PROCEDURE browseForFile :
/*------------------------------------------------------------------------------
  Purpose:     Confirms that a file can be created locally.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns  AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    cFileName = fiFileName:SCREEN-VALUE.

    SYSTEM-DIALOG GET-FILE cFileName  
      FILTERS "XML Files (*.xml)":U "*.xml":U,
              "All Files (*.*)":U "*.*":U
      ASK-OVERWRITE
      CREATE-TEST-FILE
      INITIAL-DIR ".":U
      RETURN-TO-START-DIR
      SAVE-AS
      USE-FILENAME
      UPDATE lAns
      IN WINDOW {&WINDOW-NAME}.

    IF lAns THEN
      fiFileName:SCREEN-VALUE = cFileName.
  END.

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateConfigFile sObject 
PROCEDURE generateConfigFile :
/*------------------------------------------------------------------------------
  Purpose:     Generate XML configuration file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE mptr      AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE hXDoc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRemFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLocal    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cError    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER  NO-UNDO.


  /* Set up the file name */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      lMinimum
    .
    ASSIGN
      cFileName = fiFileName:SCREEN-VALUE
      lLocal    = raLocation:SCREEN-VALUE = "L":U
      .

    /* If the user wants the file created locally, we need to 
       retrieve the XML document via the MEMPTR, otherwise
       we just write it to the remote file */
    IF lLocal THEN
      cRemFile = "<MEMPTR>":U.
    ELSE
      cRemFile = cFileName.
  
    /* Always set the size of the pointer to 0 */
    set-size(mptr) = 0.
  
    /* Make the call to the remote procedure that
       runs this stuff. */
    {launch.i &PLIP = 'af/app/afcfgwritep.p'
                      &IProc = 'writeConfigXML'
                      &OnApp = 'YES'
                      &PList = "(INPUT slSelected:LIST-ITEMS,
                                 cRemFile,
                                 lMinimum,
                                 OUTPUT mptr)" 
                      &AutoKill = YES}
  
    /* Check for any errors */
    {checkerr.i &display-error = YES}.
  
    /* If everything worked, and we want the stuff written out locally,
       we need to load the XML document from the MEMPTR */
    IF lLocal THEN
    DO:
      /* Create the X document */
      CREATE X-DOCUMENT hXDoc.
  
      /* Load the contents of the MEMPTR into the
         X document and check for any errors */
      lAns = hXDoc:LOAD("MEMPTR":U,mptr,FALSE) NO-ERROR.
      {checkerr.i &no-return = YES
                    &errors-not-zero = YES}
      IF cMessageList <> "":U THEN
        cError = cMessageList.
  
      /* If the load succeeded, save the X document to disk */
      IF lAns THEN
      DO:
        lAns = hXDoc:SAVE("FILE":U,cFileName) NO-ERROR.
        {checkerr.i &no-return = YES
                      &errors-not-zero = YES}
        IF cMessageList <> "":U THEN
          cError = cMessageList.
      END.
  
      DELETE OBJECT hXDoc.
      hXDoc = ?.
  
    END.
  
    /* Empty the memptr */
    set-size(mptr) = 0.
  
    IF cError <> '':U  THEN
    DO:
      ASSIGN lAns = FALSE.
      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Save Configuration XML file":U,
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    END.  /* if error */
    ELSE DO:
      ASSIGN lAns = TRUE. 
      /* Only show the success message if running this from the Validate
         Dataset Query button */
      IF PROGRAM-NAME(2) BEGINS 'USER-INTERFACE-TRIGGER':U THEN
      DO:
        cError = {af/sup2/aferrortxt.i 'AF' '108' '' '' "'configuration file save'"}.
        RUN showMessages IN gshSessionManager (INPUT cError,
                                               INPUT "MES":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Save Configuration XML file",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
      END.  /* if called from ui trigger */
    END.  /* else do */
  END.

  RUN populateSelectionList.
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
  DEFINE VARIABLE cSessList                 AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */


  /* Populate the selection list with the list of session types */
  RUN populateSelectionList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveItems sObject 
PROCEDURE moveItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    DEFINE VARIABLE lAll   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hTo    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hFrom  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cList  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEntry AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

    CASE pcMode:
      WHEN "Add":U THEN
        ASSIGN
          hTo   = slSelected:HANDLE
          hFrom = slAvailable:HANDLE
          lAll  = NO
        .
      WHEN "AddAll":U THEN
        ASSIGN
          hTo   = slSelected:HANDLE
          hFrom = slAvailable:HANDLE
          lAll  = YES
        .
      WHEN "Remove":U THEN
        ASSIGN
          hTo   = slAvailable:HANDLE
          hFrom = slSelected:HANDLE
          lAll  = NO
        .
      WHEN "RemoveAll":U THEN
        ASSIGN
          hTo   = slAvailable:HANDLE
          hFrom = slSelected:HANDLE
          lAll  = YES
        .
    END CASE.

    IF lAll THEN
      cList = hFrom:LIST-ITEMS.
    ELSE
      cList = hFrom:SCREEN-VALUE.

    DO iCount = 1 TO NUM-ENTRIES(cList,hFrom:DELIMITER):
      cEntry = ENTRY(iCount,cList,hFrom:DELIMITER).
      hTo:ADD-LAST(cEntry).
      hFrom:DELETE(cEntry).
    END.

  END.
  
  RUN setState.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateSelectionList sObject 
PROCEDURE populateSelectionList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTypes    AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      lTemplates
    .
    IF lTemplates THEN
      cTypes = "":U.
    ELSE
      cTypes = "!Templates":U.
  END.

  RUN getSessionList IN gshSessionManager
    (INPUT cTypes,
     OUTPUT cSessList) NO-ERROR.
  {checkerr.i &display-error = YES}

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      slAvailable:LIST-ITEMS = cSessList
      slSelected:LIST-ITEMS = ?
    .
  END.


  RUN setState.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState sObject 
PROCEDURE setState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      raLocation
      fiFileName
    .
    ASSIGN
      lTemplates:SENSITIVE    = slSelected:LIST-ITEMS = "":U OR
                                slSelected:LIST-ITEMS = ?
      slAvailable:SENSITIVE   = slAvailable:LIST-ITEMS <> "":U AND
                                slAvailable:LIST-ITEMS <> ?
      slSelected:SENSITIVE    = slSelected:LIST-ITEMS <> "":U AND
                                slSelected:LIST-ITEMS <> ?
      btnAddAll:SENSITIVE     = slAvailable:LIST-ITEMS <> "":U AND
                                slAvailable:LIST-ITEMS <> ?
      btnAdd:SENSITIVE        = slAvailable:SCREEN-VALUE <> "":U AND
                                slAvailable:SCREEN-VALUE <> ?   
      btnRemove:SENSITIVE     = slSelected:SCREEN-VALUE <> "":U AND
                                slSelected:SCREEN-VALUE <> ?
      btnRemoveAll:SENSITIVE  = slSelected:LIST-ITEMS <> "":U AND
                                slSelected:LIST-ITEMS <> ?
      buGenerate:SENSITIVE    = slSelected:LIST-ITEMS <> "":U AND
                                slSelected:LIST-ITEMS <> ? AND 
                                fiFileName <> "":U AND
                                fiFileName <> ?
      buBrowse:SENSITIVE      = raLocation = "L":U

    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

