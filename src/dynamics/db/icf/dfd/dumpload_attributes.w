&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE giCurrentDbVersion                  AS INTEGER    NO-UNDO.

DEFINE STREAM sAttribute.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buLookupFile fiFileName buProcess 
&Scoped-Define DISPLAYED-OBJECTS edNotes fiFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainDbVersion C-Win 
FUNCTION obtainDbVersion RETURNS INTEGER
  ( INPUT pclDBName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buLookupFile 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.4 BY 1
     BGCOLOR 8 .

DEFINE BUTTON buProcess 
     LABEL "Dump/Load" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE edNotes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 96.4 BY 9.71 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(70)":U 
     LABEL "File Name" 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     edNotes AT ROW 1.14 COL 2 NO-LABEL
     buLookupFile AT ROW 11.14 COL 94.8
     fiFileName AT ROW 11.24 COL 5.6
     buProcess AT ROW 12.33 COL 83.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99.4 BY 12.48.


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
         TITLE              = "<insert window title>"
         HEIGHT             = 12.48
         WIDTH              = 99.4
         MAX-HEIGHT         = 20.48
         MAX-WIDTH          = 140.6
         VIRTUAL-HEIGHT     = 20.48
         VIRTUAL-WIDTH      = 140.6
         RESIZE             = no
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
/* SETTINGS FOR EDITOR edNotes IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       edNotes:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edNotes:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fiFileName IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupFile C-Win
ON CHOOSE OF buLookupFile IN FRAME DEFAULT-FRAME /* ... */
DO:
    DEFINE VARIABLE cFileName               AS CHARACTER                NO-UNDO.

    ASSIGN cFileName = fiFileName:INPUT-VALUE.

    SYSTEM-DIALOG GET-FILE cFileName
        FILTERS "Text Files *.txt" "*.txt", "All Files" "*.*"
        MUST-EXIST
        TITLE "Select file"
        USE-FILENAME
        .
    ASSIGN fiFileName:SCREEN-VALUE = cFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProcess
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProcess C-Win
ON CHOOSE OF buProcess IN FRAME DEFAULT-FRAME /* Dump/Load */
DO:
    RUN dumploadData NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN NO-APPLY.
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
  RUN enable_UI.

  RUN initializeObject.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumploadData C-Win 
PROCEDURE dumploadData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE cFileName                   AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dObjectId                   AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iNumRecords                 AS INTEGER                  NO-UNDO.

    DEFINE BUFFER rycav FOR ryc_attribute_value.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN cFileName  = replace(fiFileName:INPUT-VALUE, '~\', '/').               
    END.    /* with frame ... */
    
    if giCurrentDbVersion ge 20019 then
    do:
        ASSIGN iNumRecords = 0.
        input stream sAttribute from value(cFileName).
        
        repeat transaction:
            import stream sAttribute
                dObjectId.
            
            find first rycav where
                       rycav.attribute_value_obj = dObjectId
                       exclusive-lock no-wait no-error.
            if locked rycav then
            do:
                message
                    "Unable to lock attribute value record for deletion."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                next.
            end.    /**/
            
            if not available rycav then
                next.
            
            delete rycav no-error.
            if error-status:error then
            do:
                message
                    "Unable to delete attribute value: " return-value error-status:get-message(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                
                undo, next.
            end.    /* error in deletion */

            ASSIGN iNumRecords = iNumRecords + 1.
        end.    /* transaction: load */
        input stream sAttribute close.

        IF iNumRecords EQ 0 THEN
            MESSAGE
            'No attribute value records could be found for deletion.'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE
            MESSAGE
            iNumRecords  ' attribute value records deleted.'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
    end.    /* post-19 */
    else
    do:
        ASSIGN iNumRecords = 0.
        output stream sAttribute to value(cFileName).
        
        for each ryc_object_instance no-lock,
            each ryc_attribute_value where
                 ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj and
                 ryc_attribute_value.smartobject_obj    <> ryc_object_instance.smartobject_obj
                 no-lock:
            put stream sAttribute unformatted
                ryc_attribute_value.attribute_value_obj
                SKIP.
            iNumRecords = iNumRecords + 1.
        end.    /* each object instance */
        
        output stream sAttribute close.

        IF iNumRecords EQ 0 THEN
            MESSAGE
            'No attribute value records could be found for deletion.'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE
            MESSAGE
            'Found ' iNumRecords  ' attributes for deletion.'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.       
    end.    /* pre-19 */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
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
  DISPLAY edNotes fiFileName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE buLookupFile fiFileName buProcess 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolderName C-Win 
PROCEDURE getFolderName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcFolderName    AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE cOriginalFolderName           AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE hServer                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hFolder                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hParent                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE iErrorCount                   AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cButtonPressed                AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cErrorText                    AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cFolder                       AS CHARACTER        NO-UNDO.

  ASSIGN
    cOriginalFolderName = pcFolderName.

  CREATE 'Shell.Application' hServer NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN
  DO WITH FRAME {&FRAME-NAME}:

    /* Inform user. */
    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN
        cErrorText = cErrorText
                   + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                   + ERROR-STATUS:GET-MESSAGE(iErrorCount).
    END.    /* count error messages */

    MESSAGE 
    cErrorText      
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
    RETURN.
  END.  /* Error. */

  ASSIGN
    hFolder = hServer:BrowseForFolder(CURRENT-WINDOW:HWND,
                                      "Select the folder for the exported attribute data.",
                                      0).

  IF VALID-HANDLE(hFolder)
  THEN DO:

    ASSIGN
      cFolder    = hFolder:TITLE
      hParent    = hFolder:ParentFolder
      iErrorCount = 0
      .

    REPEAT:
      IF iErrorCount >= hParent:Items:Count
      THEN DO:
        ASSIGN
          pcFolderName = "":U.
        LEAVE.
      END.
      ELSE
      IF hParent:Items:Item(iErrorCount):Name = cFolder
      THEN DO:
        ASSIGN
          pcFolderName = hParent:Items:Item(iErrorCount):Path.
        LEAVE.               
      END.
      ASSIGN
        iErrorCount = iErrorCount + 1.
    END.    /* repeat */

  END.    /* valid folder */
  ELSE
    ASSIGN
      pcFolderName = "":U.


  IF pcFolderName = "":U
  THEN
    ASSIGN
      pcFolderName = cOriginalFolderName.

  RELEASE OBJECT hParent NO-ERROR.
  RELEASE OBJECT hFolder NO-ERROR.
  RELEASE OBJECT hServer NO-ERROR.

  ASSIGN
    hParent = ?
    hFolder = ?
    hServer = ?
    .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE cFileName                   AS CHARACTER                NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        assign giCurrentDbVersion = obtainDbVersion("ICFDB")
               cFileName  = "orphan_attribute_"
                          + string(year(today)) + string(month(today)) + string(day(today))
                          + ".txt"
               
               fiFileName:SCREEN-VALUE = session:TEMP-DIRECTORY + cFileName
               CURRENT-WINDOW:TITLE    = 'Attribute cleanup utility - ICFDB version ' 
                                       + STRING(giCurrentDbVersion).
        
        ASSIGN edNotes:SCREEN-VALUE = 'As part of the Dynamics version 2.1 migration, a procedure was run that associated attribute records '
                                    + 'with object records incorrectly. This caused unexpected behaviour for some objects, since the records affected '
                                    + 'were not used prior to version 2.1.~n~nThese records should be removed. Since the migration procedure was run, '
                                    + 'however, it is not possible to determine which records are effected in a migrated 2.1 database. It is '
                                    + 'necessary to determine this from a version 2.0 database and then use this information to delete the records '
                                    + 'in the migrated database.~n ~nThis utility must first be run against a version 2.0 database, and then against a '
                                    + 'version 2.1 database.~n~n'
                                    .
        IF giCurrentDbVersion LT 20019 THEN
            ASSIGN buProcess:LABEL      = 'Export'                   
                   edNotes:SCREEN-VALUE = edNotes:SCREEN-VALUE
                                        + 'To use this utility, enter the name of a file to export the attribute value data into, and press the <Export> '
                                        + ' button. This file will contain object identifiers for the records to be deleted.'.   
        ELSE
            ASSIGN buProcess:LABEL      = 'Update'
                   edNotes:SCREEN-VALUE = edNotes:SCREEN-VALUE
                                        + 'To use this utility, enter the name of a file that contains object identifiers previously dumped by this tool '
                                        + 'and press the <Update> button. The records identified by the file will be deleted.'.
     

    END.    /* with frame ... */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainDbVersion C-Win 
FUNCTION obtainDbVersion RETURNS INTEGER
  ( INPUT pclDBName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the version number from the database sequences.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hVersion AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuery   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iVersion AS integer    NO-UNDO.
  DEFINE VARIABLE lAns     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSeqName AS CHARACTER  NO-UNDO.

  /* Create a buffer on the sequence table */
  CREATE BUFFER hBuffer FOR TABLE pclDBName + "._sequence":U.

  /* We're only concerned with the value in the _seq-max field as this
     comes from the delta file. */
  assign hVersion = hBuffer:BUFFER-FIELD("_seq-max":U)
         cSeqName = "seq_":U + pclDBName + "_DBVersion":U.

  /* We need to find a record with the sequence name seq_<dbname>_DBVersion */
  cQuery = "WHERE _Sequence._Seq-name = " + QUOTER(cSeqName).
  
  hBuffer:FIND-FIRST(cQuery, NO-LOCK) NO-ERROR.
  IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
    iVersion = 0.
  ELSE
    iVersion = hVersion:BUFFER-VALUE.
  
  /* Release the record and delete the buffer object */
  hBuffer:BUFFER-RELEASE().
  DELETE OBJECT hBuffer.
  hBuffer = ?.
  
  ERROR-STATUS:ERROR = NO.
  RETURN iVersion.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

