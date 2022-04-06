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
* Copyright (C) 2000,2007 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscddrsxprtf.w

  Description:  Dataset Record Selection Frame

  Purpose:      Dataset Record Selection Frame

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/27/2001  Author:     Bruce Gruenbaum

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

&scop object-name       gscddrsxprtf.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartFrame yes

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE ttSelected NO-UNDO RCODE-INFORMATION
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code
  FIELD cKey         AS CHARACTER FORMAT "X(50)" COLUMN-LABEL "Record Key":U
  FIELD cFileName    AS CHARACTER FORMAT "X(50)" COLUMN-LABEL "File Name":U
  INDEX udx IS UNIQUE PRIMARY
    dataset_code
    cKey
  .

DEFINE VARIABLE ghQryAvailable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQrySelected     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDatasetSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDatasetBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEntityBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE glEntityHasObj    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcEntityForEach   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSelectedForEach AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcKeyField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDSKey           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryFilter     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDatasetCode     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glFilePerRow      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcFieldForFile    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghFilterProc      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDSAPI           AS HANDLE     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS brAvailable buFilter buSelAllAvail ~
buDeselAllAvail buAdd buAddAll buAddRelated buSelectModified brSelected ~
buSelAllSelect buDeselAllSelect buRemove buRemoveAll fiDataset fiAvailTitle ~
RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS fiDataset fiAvailTitle 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRowToSelected fFrameWin 
FUNCTION addRowToSelected RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canAddField fFrameWin 
FUNCTION canAddField RETURNS LOGICAL
  ( INPUT phField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasRelated fFrameWin 
FUNCTION hasRelated RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery fFrameWin 
FUNCTION openQuery RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT-OUTPUT phQuery AS HANDLE,
    INPUT pcForEach AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupBrowse fFrameWin 
FUNCTION setupBrowse RETURNS LOGICAL
  ( INPUT phBrowse AS HANDLE,
    INPUT phQuery  AS HANDLE,
    INPUT phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "Add" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAddAll 
     LABEL "Add All" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAddRelated 
     LABEL "Add Related" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllAvail 
     LABEL "Deselect All" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselAllSelect 
     LABEL "Deselect All" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buFilter 
     LABEL "Filter" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRemove 
     LABEL "Remove" 
     SIZE 17.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRemoveAll 
     LABEL "Remove All" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelAllAvail 
     LABEL "Select All" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelAllSelect 
     LABEL "Select All" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelectModified 
     LABEL "Select Modified" 
     SIZE 17.6 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiAvailTitle AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiDataset AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dataset" 
      VIEW-AS TEXT 
     SIZE 97.6 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 143.6 BY 11.52.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 144 BY 7.52.


/* Browse definitions                                                   */
DEFINE BROWSE brAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAvailable fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123.6 BY 10.71.

DEFINE BROWSE brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSelected fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123.6 BY 6.95 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     brAvailable AT ROW 2.52 COL 2
     buFilter AT ROW 2.52 COL 126.2
     buSelAllAvail AT ROW 3.91 COL 126.2
     buDeselAllAvail AT ROW 5.24 COL 126.2
     buAdd AT ROW 6.57 COL 126.2
     buAddAll AT ROW 7.91 COL 126.2
     buAddRelated AT ROW 9.24 COL 126.2
     buSelectModified AT ROW 10.62 COL 126.2
     brSelected AT ROW 14.76 COL 2
     buSelAllSelect AT ROW 14.81 COL 126.2
     buDeselAllSelect AT ROW 16.14 COL 126.2
     buRemove AT ROW 17.48 COL 126.2
     buRemoveAll AT ROW 18.81 COL 126.2
     fiDataset AT ROW 1.05 COL 22.6 COLON-ALIGNED
     fiAvailTitle AT ROW 1.81 COL 1 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 2.14 COL 1
     RECT-3 AT ROW 14.38 COL 1
     "Selected Dataset Transactions:" VIEW-AS TEXT
          SIZE 31.2 BY .62 AT ROW 14.05 COL 2.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.2 BY 20.91.


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
         HEIGHT             = 20.91
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
/* BROWSE-TAB brAvailable 1 fMain */
/* BROWSE-TAB brSelected buSelectModified fMain */
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
ON DEFAULT-ACTION OF brAvailable IN FRAME fMain
DO:
  APPLY "CHOOSE":U TO buAdd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAvailable fFrameWin
ON VALUE-CHANGED OF brAvailable IN FRAME fMain
DO:
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSelected
&Scoped-define SELF-NAME brSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSelected fFrameWin
ON DEFAULT-ACTION OF brSelected IN FRAME fMain
DO:
  APPLY "CHOOSE":U TO buRemove.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd fFrameWin
ON CHOOSE OF buAdd IN FRAME fMain /* Add */
DO:
  RUN moveRecs (YES, NO).
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddAll fFrameWin
ON CHOOSE OF buAddAll IN FRAME fMain /* Add All */
DO:
  RUN moveRecs (YES, YES).
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddRelated
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddRelated fFrameWin
ON CHOOSE OF buAddRelated IN FRAME fMain /* Add Related */
DO:
  RUN addRelated.
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllAvail fFrameWin
ON CHOOSE OF buDeselAllAvail IN FRAME fMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, NO).
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselAllSelect fFrameWin
ON CHOOSE OF buDeselAllSelect IN FRAME fMain /* Deselect All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFilter fFrameWin
ON CHOOSE OF buFilter IN FRAME fMain /* Filter */
DO:
  RUN filterProc.
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove fFrameWin
ON CHOOSE OF buRemove IN FRAME fMain /* Remove */
DO:
  RUN moveRecs ( NO, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveAll fFrameWin
ON CHOOSE OF buRemoveAll IN FRAME fMain /* Remove All */
DO:
  RUN moveRecs (NO, YES).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllAvail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllAvail fFrameWin
ON CHOOSE OF buSelAllAvail IN FRAME fMain /* Select All */
DO:
  RUN selectRecs(BROWSE brAvailable:HANDLE, YES).
  RUN setSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelAllSelect fFrameWin
ON CHOOSE OF buSelAllSelect IN FRAME fMain /* Select All */
DO:
  RUN selectRecs(BROWSE brSelected:HANDLE, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectModified
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectModified fFrameWin
ON CHOOSE OF buSelectModified IN FRAME fMain /* Select Modified */
DO:
  RUN selectModified.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAvailable
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
&IF DEFINED(EXCLUDE-updateRecordSet) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecordSet Procedure
PROCEDURE updateRecordSet:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(ghDatasetSource) THEN
    DO:
        RUN getDatasetBuffer IN ghDatasetSource (OUTPUT ghDatasetBuffer).
        RUN setupDatasetInfo.
        
        IF VALID-HANDLE(ghFilterProc) THEN
            RUN buildFilter IN ghFilterProc (fiAvailTitle:SCREEN-VALUE in frame {&frame-name}).
            
        RUN setSensitive.
    END.
    
    return.
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRelated fFrameWin 
PROCEDURE addRelated :
/*------------------------------------------------------------------------------
  Purpose:     This code allows the user to select records that are related
               to the ryc_smartobject table. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFromQry    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAvailable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hEntityBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rCurrRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSOObj      AS HANDLE     NO-UNDO.
  
  hAvailable = BROWSE brAvailable:HANDLE.
  hFromQry = hAvailable:QUERY.
  hEntityBuff = hFromQry:GET-BUFFER-HANDLE(1).

  IF hEntityBuff:NAME <> "ryc_smartobject":U THEN
  RETURN.

  hSOObj = hEntityBuff:BUFFER-FIELD("smartobject_obj":U).
  
  rCurrRow = hEntityBuff:ROWID.
  REPEAT iCount = 1 TO hAvailable:NUM-SELECTED-ROWS:
    hAvailable:FETCH-SELECTED-ROW(iCount).

    RUN recurseObjects(hEntityBuff).
  END.

  openQuery(INPUT BUFFER ttSelected:HANDLE, INPUT-OUTPUT ghQrySelected, gcSelectedForEach).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilter fFrameWin 
PROCEDURE applyFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilter AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cAddWord  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForEach  AS CHARACTER  NO-UNDO.

  IF pcFilter <> "":U THEN
  DO:
    IF INDEX(gcEntityForEach, " WHERE ":U) > 0 THEN
      cAddWord = " AND ":U.
    ELSE
      cAddWord = " WHERE ":U.
    cForEach = REPLACE(gcEntityForEach, " %1 ":U, cAddWord + pcFilter + " ":U).
  END.
  ELSE
    cForEach = REPLACE(gcEntityForEach, "%1":U, "":U).
    
  openQuery(ghEntityBuffer, INPUT-OUTPUT ghQryAvailable, cForEach).
    
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
/*
  DEFINE VARIABLE hFile       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilePerRow AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSCode     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSCMManaged AS HANDLE     NO-UNDO.

  hFile       = phBuffer:BUFFER-FIELD("cFileName":U).
  hFilePerRow = phBuffer:BUFFER-FIELD("lFilePerRecord":U).
  hDSCode     = phBuffer:BUFFER-FIELD("dataset_code":U).
  hSCMManaged = phBuffer:BUFFER-FIELD("source_code_data":U).

  IF hSCMManaged:BUFFER-VALUE THEN
    hFilePerRow:BUFFER-VALUE = YES.
  ELSE
    hFilePerRow:BUFFER-VALUE = NO.

  IF hFilePerRow:BUFFER-VALUE THEN
    hFile:BUFFER-VALUE = "":U.
  ELSE
    hFile:BUFFER-VALUE = hDSCode:BUFFER-VALUE + ".ado":U.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject fFrameWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghFilterProc) THEN
    APPLY "CLOSE":U TO ghFilterProc.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
  DISPLAY fiDataset fiAvailTitle 
      WITH FRAME fMain.
  ENABLE buFilter buSelAllAvail buDeselAllAvail buAdd buAddAll buAddRelated 
         buSelectModified buSelAllSelect buDeselAllSelect buRemove buRemoveAll 
         fiDataset fiAvailTitle RECT-2 RECT-3 
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
  IF VALID-HANDLE(ghFilterProc) THEN
    APPLY "CLOSE":U TO ghFilterProc.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterProc fFrameWin 
PROCEDURE filterProc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghFilterProc) THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}.
    RUN af/cod2/gscddfiltw.w PERSISTENT SET ghFilterProc
      (THIS-PROCEDURE, BROWSE brAvailable:HANDLE, fiAvailTitle:SCREEN-VALUE).
  
    RUN initializeObject IN ghFilterProc.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordSetBuffer fFrameWin 
PROCEDURE getRecordSetBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phBuffer AS HANDLE     NO-UNDO.

  phBuffer = BUFFER ttSelected:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject fFrameWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Delete all the queries and stuff and set the appropriate 
     handles to unknown. Browses should no longer have any
     queries associated with them. */
     
   
  
  DO WITH FRAME {&FRAME-NAME}:

    BROWSE brAvailable:QUERY = ?.
    BROWSE brSelected:QUERY = ?.
    glEntityHasObj = ?.
    gcObjField = "":U.
    gcKeyField = "":U.
    gcDSKey = "":U.
    ghDatasetBuffer = ?.
    gcDatasetCode = "":U.
    gcQueryFilter = "":U.
    
    IF VALID-HANDLE(ghQryAvailable) THEN
    DO:
      IF ghQryAvailable:IS-OPEN THEN
        ghQryAvailable:QUERY-CLOSE().
      DELETE OBJECT ghQryAvailable.
      ghQryAvailable = ?.
    END.
    
    IF VALID-HANDLE(ghQrySelected) THEN
    DO:
      IF ghQrySelected:IS-OPEN THEN
        ghQrySelected:QUERY-CLOSE().
      DELETE OBJECT ghQrySelected.
      ghQrySelected = ?.
    END.
  
    IF VALID-HANDLE(ghEntityBuffer) THEN
    DO:
      DELETE OBJECT ghEntityBuffer.
      ghEntityBuffer = ?.
    END.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                        OUTPUT ghDSAPI).

  RUN SUPER.

  /* Let the recordSet source know that I have been initialized so that
     I can get the recordSet source's handle */
  PUBLISH "recordSet":U (THIS-PROCEDURE:HANDLE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveRecs fFrameWin 
PROCEDURE moveRecs :
/*------------------------------------------------------------------------------
  Purpose:     Copies records from the Available set to the selected table or
               removes them from the selected table.
  Parameters:  
    plAdd : If set to yes indicates that we are adding to the selected table
            otherwise indicates that we are removing form the selected table.
    plAll : If yes, all the records in the from browse are moved
            to the to browse, otherwise only the selected records are moved.

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plAdd     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAll     AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hEntityBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelected    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAvailable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromQry     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rCurrRow     AS ROWID      NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttSelected FOR ttSelected.

  hSelected = BROWSE brSelected:HANDLE.
  hAvailable = BROWSE brAvailable:HANDLE.

  IF plAdd THEN
  DO:
    hFromQry = hAvailable:QUERY.
    IF NOT VALID-HANDLE(hFromQry) THEN 
      RETURN.
    hEntityBuff = hFromQry:GET-BUFFER-HANDLE(1).
    IF plAll THEN
    DO:
      rCurrRow = hEntityBuff:ROWID.
      hFromQry:GET-FIRST().
      REPEAT WHILE NOT hFromQry:QUERY-OFF-END:
        addRowToSelected(hEntityBuff).
        hFromQry:GET-NEXT().
      END.
      IF rCurrRow <> ? THEN
      DO:
        hFromQry:REPOSITION-TO-ROWID(rCurrRow) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
        hFromQry:GET-NEXT().
      END.
    END.
    ELSE
    DO:
      REPEAT iCount = 1 TO hAvailable:NUM-SELECTED-ROWS:
        hAvailable:FETCH-SELECTED-ROW(iCount).
        addRowToSelected(hEntityBuff).
      END.
    END.
  END.
  ELSE
  DO:
    IF plAll THEN
    DO:
      FOR EACH ttSelected 
        WHERE ttSelected.dataset_code = gcDatasetCode: 
        DELETE ttSelected.
      END.
    END.
    ELSE
    DO:
      REPEAT iCount = 1 TO hSelected:NUM-SELECTED-ROWS:
        hSelected:FETCH-SELECTED-ROW(iCount).
        DELETE ttSelected.
      END.
    END.
  END.
  
  openQuery(INPUT BUFFER ttSelected:HANDLE, INPUT-OUTPUT ghQrySelected, gcSelectedForEach).
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
  DEFINE VARIABLE cForEach AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    BROWSE brAvailable:QUERY = ?.
    
    BROWSE brSelected:QUERY = ?.

    openQuery(ghEntityBuffer, INPUT-OUTPUT ghQryAvailable, REPLACE(gcEntityForEach, "%1":U, "":U)).
    
    openQuery(INPUT BUFFER ttSelected:HANDLE, INPUT-OUTPUT ghQrySelected, gcSelectedForEach).

    setupBrowse(INPUT BROWSE brAvailable:HANDLE, ghQryAvailable, ghEntityBuffer).

    setupBrowse(INPUT BROWSE brSelected:HANDLE, ghQrySelected, INPUT BUFFER ttSelected:HANDLE).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseObjects fFrameWin 
PROCEDURE recurseObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hSmartObject AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hSOObj AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.

  hSOObj = hSmartObject:BUFFER-FIELD("smartobject_obj":U).
  
  addRowToSelected(hSmartObject).
  
  FOR EACH bryc_object_instance NO-LOCK
    WHERE bryc_object_instance.container_smartobject_obj = hSOObj:BUFFER-VALUE:

    FIND FIRST bryc_smartobject NO-LOCK
      WHERE bryc_smartobject.smartobject_obj = bryc_object_instance.smartobject_obj
      NO-ERROR.
    IF AVAILABLE(bryc_smartobject) THEN
    DO:
      RUN recurseObjects(INPUT BUFFER bryc_smartobject:HANDLE).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData fFrameWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttSelected.

  IF VALID-HANDLE(ghQrySelected) AND
     gcSelectedForEach <> "":U THEN
  DO:
    openQuery(INPUT BUFFER ttSelected:HANDLE, INPUT-OUTPUT ghQrySelected, gcSelectedForEach).

    setupBrowse(INPUT BROWSE brSelected:HANDLE, ghQrySelected, INPUT BUFFER ttSelected:HANDLE).
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectModified fFrameWin 
PROCEDURE selectModified :
/*------------------------------------------------------------------------------
  Purpose:     Scans the table in the browse and highlights all rows that have
               version data that is different from the last import.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hEntityBuff  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAvailable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromQry     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rCurrRow     AS ROWID      NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.

  hAvailable = BROWSE brAvailable:HANDLE.

  hFromQry = hAvailable:QUERY.
  IF NOT VALID-HANDLE(hFromQry) THEN 
    RETURN.
  hEntityBuff = hFromQry:GET-BUFFER-HANDLE(1).
  rCurrRow = hEntityBuff:ROWID.
  hFromQry:GET-FIRST().
  SESSION:SET-WAIT-STATE("GENERAL":U).
  REPEAT WHILE NOT hFromQry:QUERY-OFF-END:
    iCount = iCount + 1.
    IF DYNAMIC-FUNCTION("isDataModified":U IN ghDSAPI,
                        gcDatasetCode,
                        hEntityBuff,
                        NO) THEN
    DO:
      hFromQry:REPOSITION-TO-ROWID(hEntityBuff:ROWID).
      IF NOT hAvailable:FOCUSED-ROW-SELECTED THEN
        hAvailable:SELECT-FOCUSED-ROW().
    END.
    hFromQry:GET-NEXT().
  END.
  IF rCurrRow <> ? THEN
  DO:
    hFromQry:REPOSITION-TO-ROWID(rCurrRow) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    hFromQry:GET-NEXT().
  END.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRecs fFrameWin 
PROCEDURE selectRecs :
/*------------------------------------------------------------------------------
  Purpose:     Selects records in the browse.
  Parameters:  
    phBrowse:  Browse to select records in
    plSelect:  If set to yes, all records will be selected, otherwise all
               records will be deselected.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBrowse AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plSelect AS LOGICAL    NO-UNDO.

  IF plSelect THEN
    phBrowse:SELECT-ALL().
  ELSE
    phBrowse:DESELECT-ROWS().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDatasetSource fFrameWin 
PROCEDURE setDatasetSource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSource AS HANDLE     NO-UNDO.

  ASSIGN
    ghDatasetSource = phSource
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSensitive fFrameWin 
PROCEDURE setSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    buAddRelated:SENSITIVE = hasRelated().
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupDatasetInfo fFrameWin 
PROCEDURE setupDatasetInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDSCode     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDSDesc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFilePerRec AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFileName   AS HANDLE     NO-UNDO.


  IF NOT VALID-HANDLE(ghDatasetBuffer) OR
     ghDatasetBuffer:AVAILABLE = NO THEN 
  DO WITH FRAME {&FRAME-NAME}:
    fiDataset:SCREEN-VALUE = "No dataset record selected.".
    fiAvailTitle:SCREEN-VALUE = "":U.
    
    if valid-handle(ghEntityBuffer) then
        brAvailable:Query = ?.    
    RETURN.
  END.    /* no dataset selected */

  hDSCode     = ghDatasetBuffer:BUFFER-FIELD("dataset_code":U).
  hDSDesc     = ghDatasetBuffer:BUFFER-FIELD("dataset_description":U).
  hFilePerRec = ghDatasetBuffer:BUFFER-FIELD("lFilePerRecord":U).
  hFileName   = ghDatasetBuffer:BUFFER-FIELD("cFileName":U).

  gcDatasetCode = hDSCode:BUFFER-VALUE.
  fiDataset:SCREEN-VALUE = hDSCode:BUFFER-VALUE + " - ":U + hDSDesc:BUFFER-VALUE.
  glFilePerRow = hFilePerRec:BUFFER-VALUE.
  IF glFilePerRow THEN
    gcFieldForFile = hFileName:BUFFER-VALUE.
  ELSE
    gcFieldForFile = "":U.

  RUN setupQueryInfo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupQueryInfo fFrameWin 
PROCEDURE setupQueryInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFont   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER bgsc_deploy_dataset  FOR gsc_deploy_dataset.
  DEFINE BUFFER bgsc_dataset_entity  FOR gsc_dataset_entity.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

  FIND FIRST bgsc_deploy_dataset NO-LOCK
    WHERE bgsc_deploy_dataset.dataset_code = gcDatasetCode.

  FIND FIRST bgsc_dataset_entity NO-LOCK
    WHERE bgsc_dataset_entity.deploy_dataset_obj = bgsc_deploy_dataset.deploy_dataset_obj
      AND bgsc_dataset_entity.primary_entity.

  FIND FIRST bgsc_entity_mnemonic NO-LOCK
    WHERE bgsc_entity_mnemonic.entity_mnemonic = bgsc_dataset_entity.entity_mnemonic.

  glEntityHasObj = bgsc_entity_mnemonic.table_has_object_field.
  IF glEntityHasObj THEN
    gcObjField = bgsc_entity_mnemonic.entity_object_field.
  ELSE
    gcObjField = "":U.

  gcKeyField = bgsc_entity_mnemonic.entity_key_field.

  gcDSKey = bgsc_dataset_entity.join_field_list.

  DO WITH FRAME {&FRAME-NAME}:
    cString = bgsc_entity_mnemonic.entity_mnemonic + " - ":U
            + bgsc_entity_mnemonic.entity_mnemonic_description + ":":U.
    iFont = fiAvailTitle:FONT.
    fiAvailTitle:WIDTH-CHARS = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cString, iFont) + 2.
    fiAvailTitle:SCREEN-VALUE = cString.
  
  END.

  CREATE BUFFER ghEntityBuffer FOR 
    TABLE bgsc_entity_mnemonic.entity_dbname + ".":U + bgsc_entity_mnemonic.entity_mnemonic_description.

  gcEntityForEach = DYNAMIC-FUNCTION("buildForEach":U IN ghDSAPI,
                                     ghEntityBuffer,
                                     "":U,
                                     ?,
                                     "":U,
                                     bgsc_dataset_entity.filter_where_clause,
                                     NO).
  
  IF gcDSKey <> "":U THEN
  DO:
    gcEntityForEach = gcEntityForEach + " %1 ":U.
    DO iCount = 1 TO NUM-ENTRIES(gcDSKey):
      gcEntityForEach = gcEntityForEach + " BY ":U + ghEntityBuffer:NAME + ".":U
                      + ENTRY(iCount,gcDSKey).
    END.
  END.
  gcSelectedForEach = "FOR EACH ttSelected WHERE ttSelected.dataset_code = '" + gcDatasetCode + "'":U.

  RUN openQueries.
  
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
    RUN SUPER.
    
    run updateRecordSet.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRowToSelected fFrameWin 
FUNCTION addRowToSelected RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE ):

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKey        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttSelected         FOR ttSelected.

  /* Establish what the key field is */
  DO iCount = 1 TO NUM-ENTRIES(gcDSKey):
    hField = phBuffer:BUFFER-FIELD(ENTRY(iCount,gcDSKey)) NO-ERROR.
    IF VALID-HANDLE(hField) THEN
      cKey = cKey + (IF cKey <> "":U THEN CHR(3) ELSE "":U)
           + STRING(hField:BUFFER-VALUE).
    ELSE
      cKey = cKey + (IF cKey <> "":U THEN CHR(3) ELSE "":U)
           + "?":U.
  END.

  /* Now find a ttSelected record like this one */
  FIND FIRST bttSelected 
    WHERE bttSelected.dataset_code = gcDatasetCode
      AND bttSelected.cKey = cKey
    NO-ERROR.

  IF NOT AVAILABLE(bttSelected) THEN
  DO:
    CREATE bttSelected.
    ASSIGN
      bttSelected.dataset_code = gcDatasetCode
      bttSelected.cKey = cKey
      .
    IF glFilePerRow THEN
    DO:
      bttSelected.cFileName = DYNAMIC-FUNCTION("getFileNameFromField":U IN ghDSAPI,
                                               gcFieldForFile,
                                               phBuffer).
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canAddField fFrameWin 
FUNCTION canAddField RETURNS LOGICAL
  ( INPUT phField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iVal AS INTEGER    NO-UNDO.

  lAns = TRUE.

  CASE phField:DATA-TYPE:
  /*  WHEN "DECIMAL":U OR */
    WHEN "ROWID":U OR
    WHEN "RECID":U OR
    WHEN "RAW":U THEN
      lAns = FALSE.

    WHEN "CHARACTER":U THEN
    DO:
      IF SUBSTRING(phField:FORMAT,1,2) = "X(":U THEN
      DO:
        cVal = REPLACE(phField:FORMAT,"X(":U,"":U).
        cVal = TRIM(REPLACE(cVal,")":U,"":U)).
        iVal = INTEGER(cVal) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
        IF iVal > 70 THEN
          lAns = FALSE.
      END.

    END.
  END.

  RETURN lAns.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasRelated fFrameWin 
FUNCTION hasRelated RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFromQry    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAvailable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hEntityBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rCurrRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSOObj      AS HANDLE     NO-UNDO.

  DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
  DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
  
  hAvailable = BROWSE brAvailable:HANDLE.
  hFromQry = hAvailable:QUERY.
  IF NOT VALID-HANDLE(hFromQry) THEN
    RETURN FALSE.
  hEntityBuff = hFromQry:GET-BUFFER-HANDLE(1).
  
  IF hEntityBuff:NAME <> "ryc_smartobject":U THEN
    RETURN FALSE.

  hSOObj = hEntityBuff:BUFFER-FIELD("smartobject_obj":U).


  rCurrRow = hEntityBuff:ROWID.
  rpt-block:
  REPEAT iCount = 1 TO hAvailable:NUM-SELECTED-ROWS:
    hAvailable:FETCH-SELECTED-ROW(iCount).

    FOR EACH bryc_object_instance NO-LOCK
      WHERE bryc_object_instance.container_smartobject_obj = hSOObj:BUFFER-VALUE:

      FIND FIRST bryc_smartobject NO-LOCK
        WHERE bryc_smartobject.smartobject_obj = bryc_object_instance.smartobject_obj
        NO-ERROR.
      IF AVAILABLE(bryc_smartobject) THEN
        LEAVE rpt-block.
    END.

  END.
  
  RETURN AVAILABLE(bryc_smartobject).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery fFrameWin 
FUNCTION openQuery RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT-OUTPUT phQuery AS HANDLE,
    INPUT pcForEach AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  if not valid-handle(phBuffer) and not valid-handle(phQuery) then
    return false.
    
  IF NOT VALID-HANDLE(phQuery) THEN
    CREATE QUERY phQuery.

  IF phQuery:IS-OPEN THEN
    phQuery:QUERY-CLOSE().
  ELSE
    phQuery:ADD-BUFFER(phBuffer).

  phQuery:QUERY-PREPARE(pcForEach).
  phQuery:QUERY-OPEN().

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupBrowse fFrameWin 
FUNCTION setupBrowse RETURNS LOGICAL
  ( INPUT phBrowse AS HANDLE,
    INPUT phQuery  AS HANDLE,
    INPUT phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOtherCols AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDecCols   AS CHARACTER  NO-UNDO.

  phBrowse:QUERY = phQuery.
  DO iCount = 1 TO phBuffer:NUM-FIELDS:
    hField = phBuffer:BUFFER-FIELD(iCount).
    IF canAddField(hField) THEN
    DO:
      IF hField:DATA-TYPE = "DECIMAL":U THEN
        cDecCols = cDecCols + (IF cDecCols = "":U THEN "":U ELSE ",":U)
                 + STRING(hField).
      ELSE
        cOtherCols = cOtherCols + (IF cOtherCols = "":U THEN "":U ELSE ",":U)
                 + STRING(hField).
    END.
  END.
  cOtherCols = cOtherCols + ",":U + cDecCols.
  DO iCount = 1 TO NUM-ENTRIES(cOtherCols):
    hField = WIDGET-HANDLE(ENTRY(iCount,cOtherCols)).
    IF VALID-HANDLE(hField) THEN
      phBrowse:ADD-LIKE-COLUMN(hField) NO-ERROR. 
  END.
  phBrowse:COLUMN-RESIZABLE = YES. 
  phBrowse:COLUMN-MOVABLE = YES. 
  phBrowse:SENSITIVE = YES.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

