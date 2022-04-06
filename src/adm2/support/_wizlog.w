&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
/* Procedure Description
"SDO Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: src/adm2/support/_wizlog.w

  Description: SDO business logic procedure page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Don Bulua

  Created: 12/06/2001
  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE Variable gWizardHdl         AS HANDLE  NO-UNDO.
DEFINE VARIABLE gcObjectName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLogicProc        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLogicTemplate    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lIsDynamicsRunning AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 e_msg ToLog fiTemplate ToNoUndo 
&Scoped-Define DISPLAYED-OBJECTS e_msg ToLog radDLP fLogicProc fiTemplate ~
ToNoUndo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectName C-Win 
FUNCTION getObjectName RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setobjectName C-Win 
FUNCTION setobjectName RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_brws 
     LABEL "B&rowse..." 
     SIZE 11.8 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 29 BY 9.86
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiTemplate AS CHARACTER FORMAT "X(100)":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE fLogicProc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 NO-UNDO.

DEFINE VARIABLE radDLP AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Generate new DLP", 1,
"Attach existing DLP", 2
     SIZE 49.4 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 9.86.

DEFINE VARIABLE ToLog AS LOGICAL INITIAL no 
     LABEL "Use SDO logic procedure" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .71 NO-UNDO.

DEFINE VARIABLE ToNoUndo AS LOGICAL INITIAL yes 
     LABEL "Use NO-UNDO for RowObject" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.62 COL 57 NO-LABEL
     ToLog AT ROW 1.95 COL 5
     radDLP AT ROW 3.86 COL 5 NO-LABEL
     b_brws AT ROW 5.52 COL 42.2
     fLogicProc AT ROW 5.62 COL 5.2 NO-LABEL
     fiTemplate AT ROW 7.71 COL 3.4 COLON-ALIGNED NO-LABEL
     ToNoUndo AT ROW 9.76 COL 5
     "Logic procedure file name:" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 4.91 COL 5.2
     "Use template:" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 6.95 COL 5
     RECT-3 AT ROW 1.62 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 86.4 BY 11.57
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.57
         WIDTH              = 86.4
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 107.2
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 107.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON b_brws IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fLogicProc IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RADIO-SET radDLP IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_brws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_brws C-Win
ON CHOOSE OF b_brws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  RUN getFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fLogicProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fLogicProc C-Win
ON VALUE-CHANGED OF fLogicProc IN FRAME DEFAULT-FRAME
DO: 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fld-list = "":U.
    APPLY "U2":U TO hWizard. /* not ok to finish */
    ASSIGN hWizard:PRIVATE-DATA    = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME radDLP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL radDLP C-Win
ON VALUE-CHANGED OF radDLP IN FRAME DEFAULT-FRAME
DO:
  IF SELF:SCREEN-VALUE = "1" THEN
  DO:
     fiTemplate:SENSITIVE = TRUE.
     IF fiTemplate:SCREEN-VALUE = "" THEN
        RUN getTemplate.
  END.
  ELSE
     ASSIGN fiTemplate:SENSITIVE = FALSE
            fiTemplate:SCREEN-VALUE = "".
   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToLog C-Win
ON VALUE-CHANGED OF ToLog IN FRAME DEFAULT-FRAME /* Use SDO logic procedure */
DO:
  DEFINE VARIABLE cContextID AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootDir   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.

  IF SELF:CHECKED THEN
  DO:
    ASSIGN fLogicProc:SENSITIVE = TRUE
           b_brws:SENSITIVE     = TRUE
           radDLP:SENSITIVE     = TRUE
           fiTemplate:SENSITIVE = TRUE.
    
    IF gcLogicProc = ".p":U or gcLogicProc = "" THEN 
    DO:
       fLogicProc:SCREEN-VALUE = ENTRY(1,gcObjectName,".") + "log.p".
       IF lIsDynamicsRunning THEN
          RUN getModuleObjectPath.
      END.
    ELSE
       fLogicProc:SCREEN-VALUE = gcLogicproc.
  
    /* Get the template procedure */
       
    IF gcLogicTemplate = "" THEN
       RUN getTemplate.
    APPLY "VALUE-CHANGED":U TO radDLP.

  END.
  ELSE DO:
     ASSIGN fLogicProc:SCREEN-VALUE = ""
            fitemplate:SCREEN-VALUE = ""
            fLogicProc:SENSITIVE    = FALSE
            b_brws:SENSITIVE        = FALSE
            radDLP:SENSITIVE        = FALSE
            fiTemplate:SENSITIVE    = FALSE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToNoUndo
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.      

/* Get the Objectname and Logic procedure from the definitions section */
getObjectName().
IF gcLogicProc = "" THEN
   ToLog = FALSE.
ELSE 
   ASSIGN ToLog      = TRUE
          fLogicProc = gcLogicProc.
ASSIGN e_msg = 
      "Specify this SDO's 'Logic Procedure' that will contain the business logic. "+ CHR(10) + CHR(10)
      + "If you select to generate a new DLP, enter a relative directory and filename (i.e. mydirectory/custlog.p) " + CHR(10) + CHR(10)
      + "The RowObject temp table should be defined with NO-UNDO in most cases. " 
      + "It must be defined NO-UNDO if BLOB or CLOB fields are included in the SDO.".

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   RUN validateWin IN THIS-PROCEDURE.
   IF ERROR-STATUS:ERROR THEN
      RETURN NO-APPLY.
   RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  /* Get dynamics information */
  lIsDynamicsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) = YES NO-ERROR.
  IF lIsDynamicsRunning THEN
     ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  APPLY "Value-changed":U TO toLog.
 
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME DEFAULT-FRAME.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY e_msg ToLog radDLP fLogicProc fiTemplate ToNoUndo 
      WITH FRAME DEFAULT-FRAME.
  ENABLE RECT-3 e_msg ToLog fiTemplate ToNoUndo 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFileName C-Win 
PROCEDURE getFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileName AS CHAR.
DEFINE VARIABLE lOK       AS LOGICAL  NO-UNDO.
DEFINE VARIABLE crelfile  AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
   IF radDlp:SCREEN-VALUE = "1" THEN
     SYSTEM-DIALOG GET-FILE cfilename
       TITLE   "Choose Data Logic Procedure "
       FILTERS "DLP Files (*.p)"  "*.p",
               "All Files (*.*)"  "*.*"
       SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE
               DEFAULT-EXTENSION ".p"
       UPDATE  lok .
   ELSE
      SYSTEM-DIALOG GET-FILE cfilename
         TITLE   "Choose Data Logic Procedure "
         FILTERS "DLP Files (*.p)"  "*.p",
                 "All Files (*.*)"  "*.*"
         SAVE-AS USE-FILENAME  CREATE-TEST-FILE
                 DEFAULT-EXTENSION ".p"
         UPDATE  lok .


    IF lOK AND cFileName <> "":U THEN
    DO:
      RUN adecomm\_relname.p (cFileName,?,OUTPUT cRelFile).
      ASSIGN
        fLogicProc:SCREEN-VALUE = REPLACE(cRelFile,"~\","/")
        hWizard:PRIVATE-DATA    = "".
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getModuleObjectPath C-Win 
PROCEDURE getModuleObjectPath :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModule      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelPath     AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(ghRepositoryDesignManager) THEN
     cModule = DYNAMIC-FUNCTION("getCurrentProductModule":U IN ghRepositoryDesignManager).
  
 IF NUM-ENTRIES(cModule,"/") > 1 THEN
 DO WITH FRAME {&FRAME-NAME}:
   cQuery = "FOR EACH gsc_product_module NO-LOCK":U
         + "   WHERE gsc_product_module.product_module_code = ":U + QUOTER(TRIM(ENTRY(1,cModule,"/"))) 
         + "   INDEXED-REPOSITION":U.

   RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                        OUTPUT cFieldValues) NO-ERROR. 

   ASSIGN cRelPath = ENTRY(LOOKUP("gsc_product_module.relative_path":U,  cFieldValues, CHR(3)) + 1, cFieldValues, CHR(3)).
          fLogicProc:SCREEN-VALUE = cRelPath + (IF cRelPath > "" AND fLogicProc:SCREEN-VALUE > "" THEN "/" ELSE "")
                                             + fLogicProc:SCREEN-VALUE.
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTemplate C-Win 
PROCEDURE getTemplate :
/*------------------------------------------------------------------------------
  Purpose:     get the template of the DATA LOGIC PROCEDURE file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cContextID AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.

RUN adeuib/_uibinfo.p (?, "TEMPLATE-ITEM DATA LOGIC PROCEDURE":U,"TEMPLATE":U, OUTPUT cContextID).

IF cContextID > "" THEN
DO:
   RUN adecomm/_relname.p (cContextID, "MUST-BE-REL":U,
                           OUTPUT cFilename).
   ASSIGN fiTemplate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFileName.
END. 
ELSE
    fiTemplate:SCREEN-VALUE  = "src/adm2/template/datalogic.p".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateWin C-Win 
PROCEDURE validateWin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.  
   DEFINE VARIABLE cDirectory  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lUpdate     AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cFullName   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cContextID  AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE LastButton AS CHARACTER NO-UNDO.

   ASSIGN LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).

   IF LastButton = "CANCEL" THEN RETURN.

   /* Set the Logical procedure into the definitions section */
   SetObjectName().

   IF LastButton = "BACK":U THEN RETURN.

   RUN adecomm/_setcurs.p("WAIT":U).

   ASSIGN FRAME {&FRAME-NAME} fLogicProc.   
   
   IF (LastButton = "NEXT":U OR LastButton = "" ) 
      AND ToLog:CHECKED AND  fLogicProc = "":U THEN
   DO:  
      MESSAGE 'You need to supply the name of a logic procedure.':U 
         VIEW-AS ALERT-BOX.

      RETURN ERROR.    
   END.
     
   ASSIGN radDLP.
   /* Check that directory exists and file doesn't already exist*/
   IF ToLog:CHECKED AND radDLP = 1 THEN
   DO:
      ASSIGN cDirectory = REPLACE(fLogicProc:SCREEN-VALUE IN FRAME {&FRAME-NAME},"~\":U,"/")
             cDirectory = TRIM(SUBSTRING(cDirectory,1,R-INDEX(cDirectory,"/":U)),"/").

      IF cDirectory > "" THEN
      DO:
        FILE-INFO:FILE-NAME = cDirectory NO-ERROR.
        /* Ensure the directory exists */
        IF FILE-INFO:FULL-PATHNAME = ? THEN
        DO:
           MESSAGE "The specified directory '" + cDirectory + " ' does not exist." 
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN ERROR.
        END.
        ELSE 
           cDirectory = FILE-INFO:FULL-PATHNAME.
      END.

      /* Check that template is valid */
      ASSIGN FILE-INFO:FILE-NAME = fiTemplate:SCREEN-VALUE 
             cFullName           = FILE-INFO:FULL-PATHNAME 
             cFullName           = REPLACE(cFullName,"~\","/") NO-ERROR.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
         MESSAGE "The specified template file '" + fiTemplate:SCREEN-VALUE + " ' does not exist." 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN ERROR.
      END.


      /* Check that file doesn't already exist */
      ASSIGN FILE-INFO:FILE-NAME = fLogicProc:SCREEN-VALUE 
             cFullName           = FILE-INFO:FULL-PATHNAME 
             cFullName           = REPLACE(cFullName,"~\","/") NO-ERROR.
      
      IF cFullName <> ? AND hWizard:PRIVATE-DATA  <> "NO-ASK":U THEN
      DO:
         MESSAGE "The specified file '" + ENTRY(NUM-ENTRIES(cFullName,"/"),cFullName,"/") + " ' already exists in folder '" cDirectory "'." SKIP
                 "Do you want to replace the existing file?"
            VIEW-AS ALERT-BOX INFO BUTTONS OK-CANCEL UPDATE lUpdate.
         IF lUpdate = ? OR NOT lUpdate THEN
            RETURN ERROR.
         ELSE
            hWizard:PRIVATE-DATA = "NO-ASK":U.

      END.
   END.
      /* Check that file exists */
   ELSE IF ToLog:CHECKED AND radDLP = 2 THEN
   DO:
      FILE-INFO:FILE-NAME = fLogicProc:SCREEN-VALUE NO-ERROR.
        /* Ensure the file exists */
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
         MESSAGE "The specified file '" +  fLogicProc:SCREEN-VALUE + " ' does not exist." 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN ERROR.
      END.

   END.
     

  RUN adecomm/_setcurs.p("":U). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectName C-Win 
FUNCTION getObjectName RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the data logic procedure name 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDefCode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextID  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRecID      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBufferC    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferU    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFuncLib    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE xRecid      AS RECID      NO-UNDO.
  DEFINE VARIABLE cRowID      AS CHAR       NO-UNDO.

  /* Get the data logic procedure name */
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "DATA-LOGIC-PROCEDURE":U, OUTPUT cContextID).
  ASSIGN gcLogicProc = cContextID.
 
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "DATA-LOGIC-PROCEDURE-NEW":U, OUTPUT cContextID).
  ASSIGN radDLP = IF cContextID = "Yes":U OR cContextID = "True":U OR cContextID = "" OR cContextID = ?
                  THEN 1 ELSE 2.
  APPLY "VALUE-CHANGED":U TO radDLP IN FRAME {&FRAME-NAME}.

  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "DATA-LOGIC-PROCEDURE-TEMPLATE":U, OUTPUT cContextID).
  
  IF cContextID > "" THEN 
     ASSIGN fiTemplate = cContextID
            gcLogicTemplate = cContextID.
  
  /* Get the file name */
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT cContextID).
  /* Get the current contents of the definition section */
  RUN adeuib/_accsect.p( "GET":U,
                         INT(cContextID),
                         "DEFINITIONS":U,
                         INPUT-OUTPUT iRecID,
                         INPUT-OUTPUT cDefCode ).
  
  /* Find the ObjectName entered in the previous page */
  ASSIGN iStart       = INDEX(cDefCode,"File:":U)
         iEnd         = IF iStart > 0 
                        THEN INDEX(cDefCode,CHR(10), iStart)
                        ELSE 0
         cLine        = IF iStart > 0 AND iEnd > 0 
                        THEN  SUBSTRING(cDefCode, iStart, iEnd - iStart + 2)
                        ELSE ""
         gcObjectName = IF iStart > 0 AND iEnd > 0
                        THEN  trim(SUBSTRING(cLine, 6))
                        ELSE "".

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setobjectName C-Win 
FUNCTION setobjectName RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Data-Logic-Procedure equal to the specified fill-in value
            and writes it to the definitions section. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContextID  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Win       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE l_status    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBufferU    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferC    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFuncLib    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE xRecID      AS RECID      NO-UNDO.
  DEFINE VARIABLE cRowID      AS CHAR       NO-UNDO.


  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT cContextID).
  
  RUN adeuib/_setwatr.w (INPUT INT(cContextID), 
                         INPUT "Data-Logic-Proc",
                         INPUT fLogicProc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         OUTPUT l_status ).
  RUN adeuib/_setwatr.w (INPUT INT(cContextID), 
                         INPUT "Data-Logic-Proc-template",
                         INPUT fiTemplate:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         OUTPUT l_status ).


 
  ASSIGN radDLP.
  IF toLog:CHECKED THEN
    RUN adeuib/_setwatr.w (INPUT INT(cContextID), 
                           INPUT "Data-Logic-Proc-New",
                           INPUT IF radDlp = 1 THEN "Yes":U ELSE "No":U,
                           OUTPUT l_status ).
  ELSE 
    RUN adeuib/_setwatr.w (INPUT INT(cContextID), 
                            INPUT "Data-Logic-Proc-New",
                            INPUT ?,
                            OUTPUT l_status ).

  RUN adeuib/_setwatr.w (INPUT INT(cContextID),
                         INPUT "RowObject-NO-UNDO",
                         INPUT ToNoUndo:CHECKED,
                         OUTPUT l_status).

 /* Get handle of the window */
  RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "HANDLE":U, OUTPUT c_win).
  /* flag window as 'dirty' (needs to be saved) */
  RUN adeuib/_winsave.p (WIDGET-HANDLE(c_win), FALSE).          
   
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

