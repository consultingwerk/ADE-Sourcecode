&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" fFrameWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" fFrameWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fFrameWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscddcfdataset.w

  Description:  Conflict Dataset Smartframe

  Purpose:      Conflict Dataset Smartframe

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/29/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbfrmw.w

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

&scop object-name       gscddconflictds.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartFrame yes

{af/sup2/afglobals.i}


DEFINE VARIABLE glFileOpen      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghDDXML         AS HANDLE     NO-UNDO.
DEFINE VARIABLE giRequest       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghTranQry       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTableListQry  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTableQry      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTableList     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTables        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTransList     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEntity        AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brTable

/* Definitions for FRAME fMain                                          */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buOpen brTable brTran brTableList fiFile ~
ui_DatasetCode ui_Desc ui_DateCreated ui_Transactions ui_TimeCreated ~
ui_DateFormat ui_YearOffset RECT-1 RECT-2 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS ui_SCMManaged ui_FullHeader ui_DSInDB ~
fiFile ui_DatasetCode ui_Desc ui_DateCreated ui_Transactions ui_TimeCreated ~
ui_DateFormat ui_YearOffset 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeBrowse fFrameWin 
FUNCTION closeBrowse RETURNS LOGICAL
  ( INPUT phBrowse AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD confirmDatasetExists fFrameWin 
FUNCTION confirmDatasetExists RETURNS LOGICAL
  ( INPUT pcDataset AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openBrowse fFrameWin 
FUNCTION openBrowse RETURNS HANDLE
  ( INPUT phTable AS HANDLE,
    INPUT phBrowse AS HANDLE,
    INPUT pcFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUIProperties fFrameWin 
FUNCTION setUIProperties RETURNS LOGICAL
  ( INPUT phParent AS HANDLE,
    INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buOpen 
     LABEL "&Open File..." 
     SIZE 28 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dataset Filename" 
      VIEW-AS TEXT 
     SIZE 94.8 BY .62 NO-UNDO.

DEFINE VARIABLE ui_DatasetCode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Code" 
      VIEW-AS TEXT 
     SIZE 20.6 BY .62 NO-UNDO.

DEFINE VARIABLE ui_DateCreated AS CHARACTER FORMAT "X(256)":U 
     LABEL "Date Created" 
      VIEW-AS TEXT 
     SIZE 17.2 BY .62 NO-UNDO.

DEFINE VARIABLE ui_DateFormat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Date Format" 
      VIEW-AS TEXT 
     SIZE 17.2 BY .62 NO-UNDO.

DEFINE VARIABLE ui_Desc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
      VIEW-AS TEXT 
     SIZE 46.4 BY .62 NO-UNDO.

DEFINE VARIABLE ui_TimeCreated AS CHARACTER FORMAT "X(256)":U 
     LABEL "Time Created" 
      VIEW-AS TEXT 
     SIZE 17.2 BY .62 NO-UNDO.

DEFINE VARIABLE ui_Transactions AS CHARACTER FORMAT "X(256)":U 
     LABEL "No of Transactions" 
      VIEW-AS TEXT 
     SIZE 19.2 BY .62 NO-UNDO.

DEFINE VARIABLE ui_YearOffset AS CHARACTER FORMAT "X(256)":U 
     LABEL "Year Offset" 
      VIEW-AS TEXT 
     SIZE 17.2 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 143.2 BY 7.48.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.6 BY 6.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 143.2 BY 4.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71.2 BY 6.

DEFINE VARIABLE ui_DSInDB AS LOGICAL INITIAL no 
     LABEL "Dataset Exists in Repository" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.8 BY .81 NO-UNDO.

DEFINE VARIABLE ui_FullHeader AS LOGICAL INITIAL no 
     LABEL "Full Header" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE ui_SCMManaged AS LOGICAL INITIAL no 
     LABEL "SCM Managed" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.


/* Browse definitions                                                   */
DEFINE BROWSE brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140.8 BY 6.81.

DEFINE BROWSE brTableList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTableList fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66.8 BY 5.1.

DEFINE BROWSE brTran
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTran fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66.4 BY 5.05.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     buOpen AT ROW 1.29 COL 116.8
     ui_SCMManaged AT ROW 4.38 COL 5.6
     ui_FullHeader AT ROW 5.43 COL 5.6
     ui_DSInDB AT ROW 6.38 COL 5.6
     brTable AT ROW 8.14 COL 3
     brTran AT ROW 16.19 COL 76.2
     brTableList AT ROW 16.24 COL 3.4
     fiFile AT ROW 1.48 COL 19 COLON-ALIGNED
     ui_DatasetCode AT ROW 3.38 COL 8.6 COLON-ALIGNED
     ui_Desc AT ROW 3.38 COL 54 COLON-ALIGNED
     ui_DateCreated AT ROW 3.38 COL 124.4 COLON-ALIGNED
     ui_Transactions AT ROW 4.19 COL 54 COLON-ALIGNED
     ui_TimeCreated AT ROW 4.24 COL 124.4 COLON-ALIGNED
     ui_DateFormat AT ROW 5.1 COL 124.4 COLON-ALIGNED
     ui_YearOffset AT ROW 5.95 COL 124.4 COLON-ALIGNED
     RECT-1 AT ROW 7.76 COL 1.8
     RECT-2 AT ROW 15.67 COL 2.2
     RECT-4 AT ROW 3 COL 1.8
     RECT-5 AT ROW 15.67 COL 73.8
     "Dataset Structure:" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 7.43 COL 3
     "Dataset Tables:" VIEW-AS TEXT
          SIZE 16.4 BY .62 AT ROW 15.33 COL 3.8
     "Dataset Properties:" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 2.67 COL 2.8
     "Dataset Transactions:" VIEW-AS TEXT
          SIZE 22.6 BY .62 AT ROW 15.33 COL 76.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.2 BY 20.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
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
  CREATE WINDOW fFrameWin ASSIGN
         HEIGHT             = 20.76
         WIDTH              = 144.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB fFrameWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW fFrameWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE                                                          */
/* BROWSE-TAB brTable ui_DSInDB fMain */
/* BROWSE-TAB brTran brTable fMain */
/* BROWSE-TAB brTableList brTran fMain */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX ui_DSInDB IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ui_FullHeader IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ui_SCMManaged IN FRAME fMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOpen fFrameWin
ON CHOOSE OF buOpen IN FRAME fMain /* Open File... */
DO:
  IF glFileOpen THEN
    RUN closeFile.
  ELSE
    RUN openFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fFrameWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects fFrameWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeFile fFrameWin 
PROCEDURE closeFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  closeBrowse(BROWSE brTable:HANDLE).
  closeBrowse(BROWSE brTableList:HANDLE).
  closeBrowse(BROWSE brTran:HANDLE).

  ghTableQry = ?.
  ghTableListQry = ?.
  ghTranQry = ?.
  ghTables = ?.
  ghTableList = ?.
  ghTransList = ?.


  
  /* Clear the dataset properties fields */
  setUIProperties(FRAME {&FRAME-NAME}:HANDLE, "":U).

  RUN cleanupRequest IN ghDDXML (giRequest).
  
  giRequest = 0.
  glFileOpen = NO.
  buOpen:LABEL IN FRAME {&FRAME-NAME} = "&Open File...":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fFrameWin  _DEFAULT-DISABLE
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
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fFrameWin  _DEFAULT-ENABLE
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
  DISPLAY ui_SCMManaged ui_FullHeader ui_DSInDB fiFile ui_DatasetCode ui_Desc 
          ui_DateCreated ui_Transactions ui_TimeCreated ui_DateFormat 
          ui_YearOffset 
      WITH FRAME fMain.
  ENABLE buOpen fiFile ui_DatasetCode ui_Desc ui_DateCreated ui_Transactions 
         ui_TimeCreated ui_DateFormat ui_YearOffset RECT-1 RECT-2 RECT-4 RECT-5 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject fFrameWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  IF glFileOpen THEN
    RUN closeFile.

  RUN plipShutDown IN ghDDXML.

  IF VALID-HANDLE(ghDDXML) THEN
    DELETE OBJECT ghDDXML.

  ghDDXML = ?.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFile fFrameWin 
PROCEDURE findFile :
/*------------------------------------------------------------------------------
  Purpose:     Obtains a file using SYSTEM-DIALOG to parse into the environment.
  Parameters:  
    OUTPUT pcFileName:  The name of the file that we are parsing.    
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcFileName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hWin      AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      fiFile
     .

    cFileName = fiFile.
    hWin      = FRAME {&FRAME-NAME}:WINDOW.

    SYSTEM-DIALOG GET-FILE cFileName
      FILTERS "ADO Files (*.ado)":U "*.ado":U,
              "ADO Error Files (*.edo)":U "*.edo":U,
              "All ADO Files (*.ado,*.edo":U "*.ado,*.edo":U,
              "All Files (*.*)":U "*.*":U
      MUST-EXIST
      RETURN-TO-START-DIR
      TITLE "Open Dataset":U 
      USE-FILENAME
      UPDATE lAns
      IN WINDOW hWin.

    IF lAns = ? OR 
       lAns = NO THEN
    DO:
      pcFileName = ?.
      cFileName  = "":U.
    END.
    ELSE
      pcFileName = cFileName.

    ASSIGN
      fiFile = cFileName
      .

    DISPLAY fiFile.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordSet fFrameWin 
PROCEDURE getRecordSet :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handles to the three temp-table buffers that are the 
               basis of the queries.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phTable     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phTableList AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phTrans     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phEntity    AS HANDLE     NO-UNDO.

  phTable = ghTables.
  phTableList = ghTableList.
  phTrans = ghTransList.
  phEntity = ghEntity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject fFrameWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Initialize the XML handler API. */
  RUN af/app/gscddxmlp.p PERSISTENT SET ghDDXML.

  RUN SUPER.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openFile fFrameWin 
PROCEDURE openFile :
/*------------------------------------------------------------------------------
  Purpose:     Finds an XML file using the findFile call and calls the API 
               to parse the XML header so that it can be handled here.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.

  /* Find an XML file on disk */
  RUN findFile (OUTPUT cFileName).

  /* If the filename is unknown, return. */
  IF cFileName = "":U OR
     cFileName = ? THEN
    RETURN.

  /* Load the file for review */
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN loadForReview IN ghDDXML 
    (cFileName, 
     OUTPUT giRequest, 
     OUTPUT ghTables, 
     OUTPUT ghTableList, 
     OUTPUT ghTransList,
     OUTPUT ghEntity) NO-ERROR.
  SESSION:SET-WAIT-STATE("":U).
  {afcheckerr.i &display-error = YES}

  /* Get the properties for this dataset */
  setUIProperties(FRAME {&FRAME-NAME}:HANDLE, "FUNCTION-VALUE":U).

  /* We can now check whether the dataset exists on the database */
  confirmDatasetExists(ui_DatasetCode:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  ghTableQry = openBrowse(ghTables,BROWSE brTable:HANDLE,
  "iEntitySeq,lPrimary,cEntityMnemonic,cTableName,cJoinMnemonic,cJoinFieldList,cDatabase,cWhereClause":U).

  ghTableListQry = openBrowse(ghTableList,BROWSE brTableList:HANDLE,"cDBName,cTableName":U).

  ghTranQry = openBrowse(ghTransList,BROWSE brTran:HANDLE,"iTransNo,cObjFieldVal,cKeyFieldVal":U).

  glFileOpen = YES.
  buOpen:LABEL IN FRAME {&FRAME-NAME} = "&Close File":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recordSet fFrameWin 
PROCEDURE recordSet :
/*------------------------------------------------------------------------------
  Purpose:     Traps the recordSet event and sets the handle of this procedure
               as the record set source.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSource AS HANDLE     NO-UNDO.

  RUN setRecordSet IN phSource (THIS-PROCEDURE:HANDLE, ghDDXML).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeBrowse fFrameWin 
FUNCTION closeBrowse RETURNS LOGICAL
  ( INPUT phBrowse AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE     NO-UNDO.
  /* Get the Browse's query */
  hQuery = phBrowse:QUERY.

  phBrowse:QUERY = ?.

  IF VALID-HANDLE(hQuery) THEN
  DO:
    IF hQuery:IS-OPEN THEN
      hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    hQuery = ?.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION confirmDatasetExists fFrameWin 
FUNCTION confirmDatasetExists RETURNS LOGICAL
  ( INPUT pcDataset AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_deploy_dataset FOR gsc_deploy_dataset.

  DO WITH FRAME {&FRAME-NAME}:

    FIND FIRST bgsc_deploy_dataset NO-LOCK
      WHERE bgsc_deploy_dataset.dataset_code = pcDataset
      NO-ERROR.
    
    ui_DSInDB:CHECKED = AVAILABLE(bgsc_deploy_dataset).
  
    IF AVAILABLE(bgsc_deploy_dataset) THEN
      ui_Desc:SCREEN-VALUE = bgsc_deploy_dataset.dataset_description.
    ELSE
      ui_Desc:SCREEN-VALUE = "Dataset not on file".
  
    RETURN ui_DSInDB:CHECKED.   /* Function return value. */

  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openBrowse fFrameWin 
FUNCTION openBrowse RETURNS HANDLE
  ( INPUT phTable AS HANDLE,
    INPUT phBrowse AS HANDLE,
    INPUT pcFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Opens a query and a brows
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.

  /* Close down the existing Browse's query */
  closeBrowse(phBrowse).

  /* Create a new query */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(phTable).
  hQuery:QUERY-PREPARE("FOR EACH ":U + phTable:NAME + " NO-LOCK":U).
  hQuery:QUERY-OPEN().

  /* Add the query to the Browse */
  phBrowse:QUERY = hQuery.

  DO iCount = 1 TO NUM-ENTRIES(pcFields):
    hField = phTable:BUFFER-FIELD(ENTRY(iCount,pcFields)).
    phBrowse:ADD-LIKE-COLUMN(hField).
  END.
  phBrowse:COLUMN-RESIZABLE = YES.
  phBrowse:SENSITIVE = YES.
  
  RETURN hQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUIProperties fFrameWin 
FUNCTION setUIProperties RETURNS LOGICAL
  ( INPUT phParent AS HANDLE,
    INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function loops through the widgets in the frame and
            uses the widget name to determine the value of a property
            in the dataset.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.

  hHandle = phParent:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hHandle):
    IF CAN-QUERY(hHandle,"FIRST-CHILD":U) THEN
      setUIProperties(hHandle, pcValue).

    IF (hHandle:TYPE = "FILL-IN":U OR
        hHandle:TYPE = "TEXT":U OR
        hHandle:TYPE = "TOGGLE-BOX":U) AND
       SUBSTRING(hHandle:NAME,1,3) = "ui_":U THEN
    DO:
      IF pcValue = "FUNCTION-VALUE":U THEN
        cValue = DYNAMIC-FUNCTION("getAttribute":U IN ghDDXML,
                                  giRequest,
                                  SUBSTRING(hHandle:NAME,4)).
      ELSE
        cValue = pcValue.

      IF cValue <> ? THEN
      DO:
        IF hHandle:TYPE = "TOGGLE-BOX":U THEN
          hHandle:CHECKED = cValue = "YES":U.
        ELSE
          hHandle:SCREEN-VALUE = cValue.
      END.
    END.

    hHandle = hHandle:NEXT-SIBLING.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

