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
  File: gscdddsxprtf.w

  Description:  Dataset Export Frame

  Purpose:      Dataset Export Frame

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/26/2001  Author:     Bruce Gruenbaum

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

&scop object-name       gscdpxprtf.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartFrame yes

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttDeployDataSet       NO-UNDO         RCODE-INFORMATION
    FIELD dataset_code          LIKE gsc_deploy_dataset.dataset_code
    FIELD dataset_description   LIKE gsc_deploy_dataset.dataset_description FORMAT "X(30)"
    FIELD source_code_data      LIKE gsc_deploy_dataset.source_code_data COLUMN-LABEL "Source!Code"
    FIELD deploy_full_data      LIKE gsc_deploy_dataset.deploy_full_data COLUMN-LABEL "Deploy!Full Data"
    FIELD lInclude              AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include"
    FIELD lClearDMS             AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Clear Data!Modified"
    FIELD lIncludeDeleted       AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include!Deleted"
    FIELD lOverwrite            AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Overwrite!Existing"
    FIELD lFilePerRecord        AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "File Per!Record"
    FIELD cFileName             LIKE gsc_deploy_dataset.default_ado_filename FORMAT "X(30)":U COLUMN-LABEL "File Name"
    INDEX pudx IS UNIQUE PRIMARY
        dataset_code
    .

DEFINE TEMP-TABLE ttDataSetEntity       NO-UNDO         RCODE-INFORMATION
    FIELD entity_sequence        LIKE gsc_dataset_entity.entity_sequence
    FIELD entity_mnemonic        LIKE gsc_dataset_entity.entity_mnemonic
    FIELD cTableName             AS CHARACTER FORMAT "X(30)" COLUMN-LABEL "Table Name"
    FIELD delete_related_records LIKE gsc_dataset_entity.delete_related_records COLUMN-LABEL "Delete!Related"
    FIELD overwrite_records      LIKE gsc_dataset_entity.overwrite_records      COLUMN-LABEL "Overwrite"
    FIELD keep_own_site_data     LIKE gsc_dataset_entity.keep_own_site_data     COLUMN-LABEL "Keep Own!Site Data"
    FIELD deploy_full_data       LIKE gsc_deploy_dataset.deploy_full_data       COLUMN-LABEL "Deploy!Full Data"
    FIELD lInclude               AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include"
    FIELD lClearDMS              AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Clear Data!Modified"
    FIELD lIncludeDeleted        AS LOGICAL FORMAT "YES/NO" COLUMN-LABEL "Include!Deleted"
    FIELD dataset_code           LIKE gsc_deploy_dataset.dataset_code
    INDEX pudx IS UNIQUE PRIMARY
        dataset_code
        entity_sequence
    .

DEFINE VARIABLE hQryAvailable           AS HANDLE                   NO-UNDO.
DEFINE VARIABLE hQrySelected            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gdDeployPackageObj      AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE ghPackageSource         AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gcAction                AS CHARACTER                NO-UNDO.

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
&Scoped-define BROWSE-NAME brAvailable

/* Definitions for FRAME fMain                                          */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brAvailable brSelected RECT-2 RECT-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openLocalQuery fFrameWin 
FUNCTION openLocalQuery RETURNS LOGICAL
    ( INPUT        phBuffer     AS HANDLE,
      INPUT-OUTPUT phQuery      AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 143.6 BY 10.1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 143.2 BY 10.


/* Browse definitions                                                   */
DEFINE BROWSE brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAvailable fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141.2 BY 8.95.

DEFINE BROWSE brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSelected fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 8.95 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     brAvailable AT ROW 1.86 COL 3.8
     brSelected AT ROW 12.62 COL 3.4
     RECT-2 AT ROW 1.38 COL 1.4
     RECT-3 AT ROW 12.05 COL 1.8
     "Datasets:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.1 COL 3.4
     "Entities:" VIEW-AS TEXT
          SIZE 8.8 BY .62 AT ROW 11.76 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.6 BY 21.1.


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
         HEIGHT             = 21.1
         WIDTH              = 144.6.
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
/* BROWSE-TAB brAvailable 1 fMain */
/* BROWSE-TAB brSelected brAvailable fMain */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

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

&Scoped-define BROWSE-NAME brAvailable
&Scoped-define SELF-NAME brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAvailable fFrameWin
ON ROW-LEAVE OF brAvailable IN FRAME fMain
, BROWSE brSelected
DO:
    RUN trgRowLeave ( INPUT SELF:HANDLE ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultTo fFrameWin 
PROCEDURE defaultTo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hFile       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilePerRow AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSCode     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSCMManaged AS HANDLE     NO-UNDO.
  DEFINE BUFFER bgsc_deploy_dataset  FOR gsc_deploy_dataset.
  DEFINE BUFFER bgsc_dataset_entity  FOR gsc_dataset_entity.

  hFile       = phBuffer:BUFFER-FIELD("cFileName":U).
  hFilePerRow = phBuffer:BUFFER-FIELD("lFilePerRecord":U).
  hDSCode     = phBuffer:BUFFER-FIELD("dataset_code":U).
  hSCMManaged = phBuffer:BUFFER-FIELD("source_code_data":U).

  IF hSCMManaged:BUFFER-VALUE THEN
    hFilePerRow:BUFFER-VALUE = YES.
  ELSE
    hFilePerRow:BUFFER-VALUE = NO.

  IF hFilePerRow:BUFFER-VALUE THEN
  DO:
    FIND FIRST bgsc_deploy_dataset NO-LOCK
      WHERE bgsc_deploy_dataset.dataset_code = hDSCode:BUFFER-VALUE.

    FIND FIRST bgsc_dataset_entity NO-LOCK
      WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
        AND bgsc_dataset_entity.primary_entity.

    hFile:BUFFER-VALUE = bgsc_dataset_entity.join_field_list.
  END.
  ELSE
    hFile:BUFFER-VALUE = LC(hDSCode:BUFFER-VALUE + ".ado":U).

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
  ENABLE RECT-2 RECT-3 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatasetBuffer fFrameWin 
PROCEDURE getDatasetBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phBuffer        AS HANDLE                   NO-UNDO.

    ASSIGN phBuffer = BUFFER ttDeployDataSet:HANDLE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatasetEntityBuffer fFrameWin 
PROCEDURE getDatasetEntityBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phBuffer        AS HANDLE                   NO-UNDO.    

    ASSIGN phBuffer = BUFFER ttDataSetEntity:HANDLE.
    
    RETURN.
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
    DEFINE VARIABLE cLinks          AS CHARACTER                        NO-UNDO.

    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "RecordSet":U ANYWHERE.

    RUN SUPER.    
    
    IF NOT VALID-HANDLE(ghPackageSource) THEN
        ASSIGN cLinks          = DYNAMIC-FUNCTION("LinkHandles":U, INPUT "PACKAGE-SOURCE":U)
               ghPackageSource = WIDGET-HANDLE(ENTRY(1, cLinks))
               NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries fFrameWin 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCount              AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE hCol                AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBrowse             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cAvailFields        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cExcludeFields      AS CHARACTER    EXTENT 2        NO-UNDO
            INITIAL ["!":U,"dataset_code,entity_sequence":U].

    ASSIGN cAvailFields = "deploy_full_data,lInclude,lClearDMS,lIncludeDeleted,lOverwrite,lFilePerRecord,cFileName,":U
                        + "delete_related_records,overwrite_records,keep_own_site_data":U
           .
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN BROWSE brAvailable:QUERY = ?
               BROWSE brSelected:QUERY  = ?
               .
        OpenLocalQuery(INPUT BUFFER ttDeployDataSet:HANDLE, INPUT-OUTPUT hQryAvailable).
        OpenLocalQuery(INPUT BUFFER ttDataSetEntity:HANDLE, INPUT-OUTPUT hQrySelected).

        BROWSE brAvailable:QUERY = hQryAvailable.
        BROWSE brAvailable:ADD-COLUMNS-FROM(BUFFER ttDeployDataSet:HANDLE).

        hBrowse = BROWSE brAvailable:HANDLE.
        DO iCount = 1 TO hBrowse:NUM-COLUMNS:
            hCol = hBrowse:GET-BROWSE-COLUMN(iCount).
            
            IF CAN-DO(cAvailFields, hCol:NAME) THEN
                ASSIGN hCol:READ-ONLY    = FALSE
                       hBrowse:READ-ONLY = FALSE
                       .
            IF CAN-DO(cExcludeFields[1], hCol:NAME) THEN
                ASSIGN hCol:VISIBLE = NO.
        END.

        ASSIGN hBrowse                       = ?
               BROWSE brAvailable:SENSITIVE  = YES               
               BROWSE brSelected:QUERY       = hQrySelected
               .
        BROWSE brSelected:ADD-COLUMNS-FROM(BUFFER ttDataSetEntity:HANDLE).
        
        hBrowse = BROWSE brSelected:HANDLE.
        DO iCount = 1 TO hBrowse:NUM-COLUMNS:
            hCol = hBrowse:GET-BROWSE-COLUMN(iCount).
            
            IF CAN-DO(cAvailFields, hCol:NAME) THEN
                ASSIGN hCol:READ-ONLY    = FALSE
                       hBrowse:READ-ONLY = FALSE
                       .
            IF CAN-DO(cExcludeFields[2], hCol:NAME) THEN
                ASSIGN hCol:VISIBLE = NO.
        END.        
        ASSIGN BROWSE brSelected:SENSITIVE  = YES.
    END.    /* with frame ... */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateAvailable fFrameWin 
PROCEDURE populateAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdDeployPackageObj           AS DECIMAL      NO-UNDO.

    DEFINE BUFFER gsc_deploy_dataset        FOR gsc_deploy_dataset.
    DEFINE BUFFER gsc_dataset_entity        FOR gsc_dataset_entity.
    DEFINE BUFFER gsc_entity_mnemonic       FOR gsc_entity_mnemonic.

    IF pdDeployPackageObj NE gdDeployPackageObj THEN
    DO:    
        EMPTY TEMP-TABLE ttDeployDataSet.
        EMPTY TEMP-TABLE ttDataSetEntity.

        FOR EACH gsc_package_dataset WHERE
                 gsc_package_dataset.deploy_package_obj = pdDeployPackageObj
                 NO-LOCK,
            EACH gsc_deploy_dataset WHERE
                 gsc_deploy_dataset.deploy_dataset_obj = gsc_package_dataset.deploy_dataset_obj
                 NO-LOCK:
    
            FIND ttDeployDataSet WHERE
                 ttDeployDataSet.dataset_code = gsc_deploy_dataset.dataset_code  /* needs to be related to package */
                 NO-ERROR.
    
            IF NOT AVAILABLE(ttDeployDataSet) THEN
                CREATE ttDeployDataSet.
    
            BUFFER-COPY gsc_deploy_dataset TO ttDeployDataSet
                    ASSIGN ttDeployDataSet.cFileName = gsc_deploy_dataset.default_ado_filename.
    
            FOR EACH gsc_dataset_entity WHERE
                     gsc_dataset_entity.deploy_dataset_obj = gsc_deploy_dataset.deploy_dataset_obj
                     NO-LOCK:
    
                FIND gsc_entity_mnemonic WHERE
                     gsc_entity_mnemonic.entity_mnemonic = gsc_dataset_entity.entity_mnemonic
                     NO-LOCK.
                CREATE ttDataSetEntity.
                BUFFER-COPY gsc_dataset_entity TO ttDataSetEntity 
                    ASSIGN ttDataSetEntity.dataset_code = gsc_deploy_dataset.dataset_code
                           ttDataSetEntity.ctableName   = gsc_entity_mnemonic.entity_mnemonic_description
                           .
            END.
        END.    /* each deploy package, deploy dataset */
        ASSIGN gdDeployPackageObj = pdDeployPackageObj.
    END.    /* package has changed. */   

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recordSet fFrameWin 
PROCEDURE recordSet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phSource         AS HANDLE                   NO-UNDO.

    RUN setDatasetSource IN phSource (THIS-PROCEDURE:HANDLE).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgRowLeave fFrameWin 
PROCEDURE trgRowLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phBrowse             AS HANDLE               NO-UNDO.

    DEFINE VARIABLE hQuery          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE iColumnCount    AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE hColumn         AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hField          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE hBuffer         AS HANDLE                           NO-UNDO.

    ASSIGN hQuery = phBrowse:QUERY.

    IF hQuery:NUM-RESULTS GT 0 THEN
    DO:
        phBrowse:SELECT-FOCUSED-ROW().

        DO iColumnCount = 1 TO phBrowse:NUM-COLUMNS:
            ASSIGN hColumn = phBrowse:GET-BROWSE-COLUMN(iColumnCount)
                   hField  = hColumn:BUFFER-FIELD
                   .
            IF hColumn:MODIFIED THEN
                hField:BUFFER-VALUE = hColumn:INPUT-VALUE.
        END.    /* column count */

        phBrowse:REFRESH().
    END.    /* query has results */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject fFrameWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLinks              AS CHARACTER                    NO-UNDO.

    RUN SUPER.

    IF NOT VALID-HANDLE(ghPackageSource) THEN
        ASSIGN cLinks          = DYNAMIC-FUNCTION("LinkHandles":U, INPUT "PACKAGE-SOURCE":U)
               ghPackageSource = WIDGET-HANDLE(ENTRY(1, cLinks))
               NO-ERROR.

    IF VALID-HANDLE(ghPackageSource) THEN
    DO:    
        ASSIGN gcAction = DYNAMIC-FUNCTION("GetAction":U IN ghPackageSource).

        /* get the datasets for this deployment. */
        IF gcAction EQ "EXPORT":U THEN
            RUN PopulateAvailable ( INPUT DYNAMIC-FUNCTION("GetCurrentPackageObj":U IN ghPackageSource)).
        ELSE
        IF gcAction EQ "IMPORT":U THEN
            RUN GetTables IN ghPackageSource ( OUTPUT TABLE ttDeployDataSet, OUTPUT TABLE ttDataSetEntity ).

        RUN openQueries.
    END.    /* valid package source */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openLocalQuery fFrameWin 
FUNCTION openLocalQuery RETURNS LOGICAL
    ( INPUT        phBuffer     AS HANDLE,
      INPUT-OUTPUT phQuery      AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(phQuery) THEN
        CREATE QUERY phQuery.

    IF phQuery:IS-OPEN THEN
        phQuery:QUERY-CLOSE().
    ELSE
        phQuery:ADD-BUFFER(phBuffer).

    phQuery:QUERY-PREPARE("FOR EACH ":U + phBuffer:NAME).
    phQuery:QUERY-OPEN().

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

