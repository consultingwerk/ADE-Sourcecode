&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File:           dcufiledump.w

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{src/adm2/globals.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ghDSAPI   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghXMLHlpr AS HANDLE     NO-UNDO.


DEFINE TEMP-TABLE ttFile NO-UNDO
  FIELD FileType        AS CHARACTER
  FIELD FileName        AS CHARACTER
  FIELD Description     AS CHARACTER
  FIELD Rerunnable      AS LOGICAL
  FIELD NewDB           AS LOGICAL
  FIELD ExistingDB      AS LOGICAL
  FIELD UpdateMandatory AS LOGICAL
  INDEX pudx IS PRIMARY 
    FileName
  .

DEFINE TEMP-TABLE ttSelected NO-UNDO RCODE-INFORMATION
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code
  FIELD cKey         AS CHARACTER FORMAT "X(50)" COLUMN-LABEL "Record Key":U
  FIELD cFileName    AS CHARACTER FORMAT "X(50)" COLUMN-LABEL "File Name":U
  INDEX udx IS UNIQUE PRIMARY
    dataset_code
    cKey
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buButton fiFile fiDump ToDFiles ToADO ~
buGenerate 
&Scoped-Define DISPLAYED-OBJECTS fiFile fiDump ToDFiles ToADO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buButton 
     LABEL "&Browse" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     LABEL "&Generate" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiDump AS CHARACTER FORMAT "X(256)":U INITIAL "db/icf/dump" 
     LABEL "Dump Path" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U INITIAL "dumplist.xml" 
     LABEL "XML File" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE ToADO AS LOGICAL INITIAL no 
     LABEL "ADO Files" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.

DEFINE VARIABLE ToDFiles AS LOGICAL INITIAL no 
     LABEL ".d Files" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buButton AT ROW 1.81 COL 68
     fiFile AT ROW 1.86 COL 13 COLON-ALIGNED
     fiDump AT ROW 3.1 COL 13 COLON-ALIGNED
     ToDFiles AT ROW 4.38 COL 15
     ToADO AT ROW 5.62 COL 15
     buGenerate AT ROW 6.19 COL 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.6 BY 6.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Dump utility for XML output"
         HEIGHT             = 6.71
         WIDTH              = 85.6
         MAX-HEIGHT         = 16.43
         MAX-WIDTH          = 102
         VIRTUAL-HEIGHT     = 16.43
         VIRTUAL-WIDTH      = 102
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Dump utility for XML output */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Dump utility for XML output */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate C-Win
ON CHOOSE OF buGenerate IN FRAME DEFAULT-FRAME /* Generate */
DO:
  RUN generateXML.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initializeProc.
  RUN enable_UI.
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
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
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
  DISPLAY fiFile fiDump ToDFiles ToADO 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE buButton fiFile fiDump ToDFiles ToADO buGenerate 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateXML C-Win 
PROCEDURE generateXML :
/*------------------------------------------------------------------------------
  Purpose:     Generates the XML file that contains the data that we need.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hXMLDoc   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootNode AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      fiFile
      fiDump
      ToDFiles
      ToADO
    .
  END.

  /* First lets create the XML document. Note that this document is intended 
     to be incorporated inside the icfsetup.xml file so we don't do a whole
     lot of stuff here. We're simply generating XML that will be copied into
     the other file. */
  CREATE X-DOCUMENT hXMLDoc.

  hXMLDoc:ENCODING = "utf-8":U.

  /* Create the root node */
  hRootNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                hXMLDoc, 
                                "data_to_load":U).

  IF toDFiles THEN
    RUN writeDFiles (hRootNode).

  IF toADO THEN
    RUN writeADOFiles (hRootNode).

  lAns = hXMLDoc:SAVE("FILE",fiFile).

  DELETE OBJECT hRootNode.
  DELETE OBJECT hXMLDoc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeProc C-Win 
PROCEDURE initializeProc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAns AS LOGICAL    NO-UNDO.

  lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                          "ICFDB":U) NO-ERROR.

  IF lAns = NO OR 
     lAns = ? THEN
  DO:
    MESSAGE "This procedure requires a connection to at least the ICFDB database to work. It cannot be run across an AppServer."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN.
  END.
    
  /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                        OUTPUT ghDSAPI).

  /* Start the XML helper API */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afxmlhlprp.p":U, 
                                        OUTPUT ghXMLHlpr).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeADOFiles C-Win 
PROCEDURE writeADOFiles :
/*------------------------------------------------------------------------------
  Purpose:     Does for the ADO files what writeDFiles does for the .d files.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER phRootNode AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDFiles            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdate            AS LOGICAL    NO-UNDO.

  hDFiles = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                              phRootNode, 
                              "adofiles_node":U).

  FOR EACH gsc_deploy_dataset NO-LOCK
    BY gsc_deploy_dataset.dataset_code:
    IF NOT gsc_deploy_dataset.source_code_data THEN
    DO:
      IF gsc_deploy_dataset.default_ado_filename <> "":U THEN
        cFileName = gsc_deploy_dataset.default_ado_filename.
      ELSE
        cFileName = gsc_deploy_dataset.dataset_code + ".ado":U.
      cFileName = LC(fiDump + "/":U + cFileName).
      cFileName = REPLACE(cFileName,"~\":U, "/":U).
      cFileName = REPLACE(cFileName,"//":U,"/":U).
      IF SEARCH(cFileName) = ? THEN
        lUpdate = NO.
      ELSE
        lUpdate = YES.
      CREATE ttFile.
      ASSIGN
        ttFile.FileType        = "ado":U
        ttFile.FileName        = cFileName
        ttFile.Description     = "Loading ADO for ":U + LC(gsc_deploy_dataset.dataset_code)
        ttFile.Rerunnable      = YES
        ttFile.NewDB           = NO
        ttFile.ExistingDB      = YES
        ttFile.UpdateMandatory = lUpdate
      .
      /* Put in a dataset records node */
      hRecordNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                     hdfiles, 
                                     "program":U).
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                       hRecordNode, 
                       INPUT BUFFER ttFile:HANDLE, 
                       "*":U).

      DELETE ttFile.
      DELETE OBJECT hRecordNode.
    END.
    ELSE
    DO:
      FIND FIRST gsc_dataset_entity NO-LOCK
        WHERE gsc_dataset_entity.deploy_dataset_obj = gsc_deploy_dataset.deploy_dataset_obj
          AND gsc_dataset_entity.primary_entity.
      EMPTY TEMP-TABLE ttSelected.
      RUN selectDSRecords IN ghDSAPI
        (gsc_deploy_dataset.dataset_code, 
         INPUT BUFFER ttSelected:HANDLE,
         gsc_dataset_entity.join_field_list,
         "ALL":U).
      FOR EACH ttSelected NO-LOCK:
        cFileName = REPLACE(ttSelected.cFileName,"~\":U, "/":U).
        cFileName = REPLACE(cFileName,"//":U,"/":U).
        IF NUM-ENTRIES(cFileName,"/":U) = 1 THEN
          cFileName = LC(fiDump + "/":U + cFileName).
        ELSE
          cFileName = LC(cFileName).

        IF SEARCH(cFileName) = ? THEN
          lUpdate = NO.
        ELSE
          lUpdate = YES.

        CREATE ttFile.
        ASSIGN
          ttFile.FileType        = "ado":U
          ttFile.FileName        = cFileName
          ttFile.Description     = "Loading ADO for ":U + LC(cFileName)
          ttFile.Rerunnable      = YES
          ttFile.NewDB           = NO
          ttFile.ExistingDB      = YES
          ttFile.UpdateMandatory = lUpdate
        .
        /* Put in a dataset records node */
        hRecordNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                       hdfiles, 
                                       "program":U).
        /* Create a Node Element for each field in the input buffer */
        DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                         hRecordNode, 
                         INPUT BUFFER ttFile:HANDLE, 
                         "*":U).

        DELETE ttFile.
        DELETE OBJECT hRecordNode.
      END.
    END.
  END.
  DELETE OBJECT hDFiles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeDFiles C-Win 
PROCEDURE writeDFiles :
/*------------------------------------------------------------------------------
  Purpose:     Loops through all the _File records and finds the dump name
               for the record and creates a temp-table record for it.
               It then loops through the temp-table record and exports
               these as XML.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phRootNode AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDFiles            AS HANDLE     NO-UNDO.

  hDFiles = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                              phRootNode, 
                              "dfiles_node":U).

  FOR EACH ICFDB._File NO-LOCK
    WHERE NOT _File._Hidden:
    CREATE ttFile.
    ASSIGN
      ttFile.FileType        = "d":U
      ttFile.FileName        = fiDump + "/":U + _File._Dump-name + ".d":U
      ttFile.Description     = "Loading contents of ":U + _File._File-name
      ttFile.Rerunnable      = NO
      ttFile.NewDB           = YES
      ttFile.ExistingDB      = NO
      ttFile.UpdateMandatory = YES
    .
    /* Put in a dataset records node */
    hRecordNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                   hdfiles, 
                                   "program":U).
    /* Create a Node Element for each field in the input buffer */
    DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                     hRecordNode, 
                     INPUT BUFFER ttFile:HANDLE, 
                     "*":U).

    DELETE ttFile.
    DELETE OBJECT hRecordNode.
  END.
  DELETE OBJECT hDFiles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

