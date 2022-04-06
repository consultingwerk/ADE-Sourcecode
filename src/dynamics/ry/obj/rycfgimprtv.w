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
{checkerr.i
  &define-only = "yes"}

DEFINE VARIABLE hCFGParser AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnBrowse fiFile lManagers lLogSrv lPhysSrv ~
RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS fiFile lManagers lLogSrv lPhysSrv ~
slAvailable slSelected 

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

DEFINE BUTTON btnBrowse 
     LABEL "&Browse..." 
     CONTEXT-HELP-ID 0
     SIZE 18 BY 1.14.

DEFINE BUTTON btnImport 
     LABEL "Import Session Types" 
     CONTEXT-HELP-ID 0
     SIZE 94.2 BY 1.14.

DEFINE BUTTON btnLoad 
     LABEL "&Load XML File" 
     CONTEXT-HELP-ID 0
     SIZE 18 BY 1.14.

DEFINE BUTTON btnRemove 
     LABEL "< Remove" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE BUTTON btnRemoveAll 
     LABEL "<< Remove All" 
     CONTEXT-HELP-ID 0
     SIZE 15.8 BY 1.14.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Configuration XML File" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 51.4 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.6 BY 12.57.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.6 BY 12.57.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74.4 BY 1.24.

DEFINE VARIABLE slAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 34.8 BY 11.86 NO-UNDO.

DEFINE VARIABLE slSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 34.4 BY 11.81 NO-UNDO.

DEFINE VARIABLE lLogSrv AS LOGICAL INITIAL no 
     LABEL "Logical Services" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 TOOLTIP "If yes, existing ones will be overwritten. If no, imported ones will be ignored" NO-UNDO.

DEFINE VARIABLE lManagers AS LOGICAL INITIAL no 
     LABEL "Managers" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .81 TOOLTIP "If yes, existing ones will be overwritten. If no, imported ones will be ignored" NO-UNDO.

DEFINE VARIABLE lPhysSrv AS LOGICAL INITIAL no 
     LABEL "Physical Services" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.6 BY .81 TOOLTIP "If yes, existing ones will be overwritten. If no, new ones will be created." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnBrowse AT ROW 1 COL 77.2
     fiFile AT ROW 1.1 COL 23.2 COLON-ALIGNED
     btnLoad AT ROW 2.33 COL 77.2
     lManagers AT ROW 2.76 COL 6.6
     lLogSrv AT ROW 2.76 COL 27
     lPhysSrv AT ROW 2.76 COL 52.8
     slAvailable AT ROW 4.52 COL 3.2 NO-LABEL
     slSelected AT ROW 4.52 COL 59.2 NO-LABEL
     btnAddAll AT ROW 6.86 COL 41
     btnAdd AT ROW 8.24 COL 41
     btnRemove AT ROW 10.24 COL 41
     btnRemoveAll AT ROW 11.67 COL 41
     btnImport AT ROW 16.95 COL 1.6
     RECT-1 AT ROW 4.1 COL 2
     RECT-2 AT ROW 4.1 COL 57.8
     RECT-3 AT ROW 2.43 COL 2.2
     "Available Session Types:" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.76 COL 4
     "Selected Session Types:" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.76 COL 59.8
     "Overwrite:" VIEW-AS TEXT
          SIZE 10.4 BY .62 AT ROW 2.14 COL 3
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
         HEIGHT             = 17.43
         WIDTH              = 95.8.
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
/* SETTINGS FOR BUTTON btnImport IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnLoad IN FRAME F-Main
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


&Scoped-define SELF-NAME btnBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowse sObject
ON CHOOSE OF btnBrowse IN FRAME F-Main /* Browse... */
DO:
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.
  
  cFileName = fiFile:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE cFileName  
    FILTERS "XML Files (*.xml)" "*.xml":U,
            "All Files (*.*)" "*.*":U
    CREATE-TEST-FILE 
    DEFAULT-EXTENSION "*.xml":U
    RETURN-TO-START-DIR
    TITLE "Select XML File"
    USE-FILENAME
    UPDATE lAns
    IN WINDOW CURRENT-WINDOW.
  
  IF lAns THEN
    fiFile:SCREEN-VALUE = cFileName.

  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImport sObject
ON CHOOSE OF btnImport IN FRAME F-Main /* Import Session Types */
DO:
  RUN importCFGFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLoad sObject
ON CHOOSE OF btnLoad IN FRAME F-Main /* Load XML File */
DO:
  RUN loadXMLfile.
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


&Scoped-define SELF-NAME fiFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFile sObject
ON VALUE-CHANGED OF fiFile IN FRAME F-Main /* Configuration XML File */
DO:
  slSelected:LIST-ITEMS = ?.
  slAvailable:LIST-ITEMS = ?.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importCFGFile sObject 
PROCEDURE importCFGFile :
/*------------------------------------------------------------------------------
  Purpose:     Invokes the code that is responsible for importing the config
               XML file into the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE htProperty  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE htService   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE htManager   AS HANDLE     NO-UNDO.
    ASSIGN
      lManagers
      lLogSrv
      lPhysSrv
    .

    RUN getTableHandles IN hCFGParser
      (OUTPUT htProperty,
       OUTPUT htManager,
       OUTPUT htService).

    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN ry/app/ryimprtsessp.p ON gshAstraAppServer
      (slSelected:LIST-ITEMS,
       lManagers,
       lLogSrv,
       lPhysSrv,
       INPUT TABLE-HANDLE htProperty,
       INPUT TABLE-HANDLE htService,
       INPUT TABLE-HANDLE htManager) NO-ERROR.
    SESSION:SET-WAIT-STATE("":U).

    {checkerr.i
      &display-error = "yes"}
      
    fiFile = "":U.
    fiFile:SCREEN-VALUE = "":U.
    slSelected:LIST-ITEMS = ?.
    slAvailable:LIST-ITEMS = ?.
    RUN setState.

  END.

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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    lManagers = NO
    lLogSrv   = NO
    lPhysSrv  = NO
  .
  DISPLAY
    lManagers
    lLogSrv  
    lPhysSrv 
    WITH FRAME {&FRAME-NAME}.

  RUN setState.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadXMLFile sObject 
PROCEDURE loadXMLFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  DEFINE VARIABLE cSessionList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDoc         AS HANDLE     NO-UNDO.

  ASSIGN
    fiFile
  .
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN startProcedure IN TARGET-PROCEDURE
    ("ONCE|af/sup2/afcfgprsrp.p":U, OUTPUT hCFGParser).
  SESSION:SET-WAIT-STATE("":U).
  
  
  IF NOT VALID-HANDLE(hCFGParser) THEN
  DO:
    {checkerr.i
      &display-error = "yes"}
  END.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN readConfigFile IN hCFGParser
      (fiFile,
       "":U,
       NO,
       OUTPUT hDoc).
  SESSION:SET-WAIT-STATE("":U).
  
  IF RETURN-VALUE <> "":U THEN
  DO:
    {checkerr.i
      &display-error = "yes"}
  END.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN obtainSessionList IN hCFGParser
      (OUTPUT cSessionList).
  SESSION:SET-WAIT-STATE("":U).

  ASSIGN
    slAvailable:DELIMITER  = CHR(3)
    slAvailable:LIST-ITEMS = cSessionList
    slSelected:DELIMITER   = CHR(3)
    slSelected:LIST-ITEMS  = ?
  .

END.

RUN setState.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState sObject 
PROCEDURE setState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      btnLoad:SENSITIVE       = fiFile:SCREEN-VALUE <> "":U
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
      btnImport:SENSITIVE     = slSelected:LIST-ITEMS <> "":U AND
                                slSelected:LIST-ITEMS <> ?
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

