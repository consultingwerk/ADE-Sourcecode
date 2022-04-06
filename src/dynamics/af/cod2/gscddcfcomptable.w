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
  File: gscddcftablecomp.w

  Description:  Table Comparison Page

  Purpose:      Table Comparison Page

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/01/2001  Author:     Bruce Gruenbaum

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

&scop object-name       gscddcfcomptable.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartFrame yes

{af/sup2/afglobals.i}
DEFINE VARIABLE ghRecordSet      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDDXML          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTableList      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTrans          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEntity         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTTBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTableBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDSQry          AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcDSCols         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghFieldQry       AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcEntityMnemonic AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttAlteredField NO-UNDO RCODE-INFORMATION
  FIELD cFieldName AS CHARACTER FORMAT "X(30)":U COLUMN-LABEL "Field Name"
  FIELD cDataType  AS CHARACTER FORMAT "X(15)":U COLUMN-LABEL "Data Type"
  FIELD cLabel     AS CHARACTER FORMAT "X(30)":U COLUMN-LABEL "Label"
  FIELD hTTField   AS HANDLE 
  FIELD hDBField   AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    cFieldName
 .

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
&Scoped-define BROWSE-NAME brDataset

/* Definitions for FRAME fMain                                          */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brDataset brFields edDSValue edDBValue ~
fiLabel RECT-5 RECT-6 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-OBJECTS edDSValue edDBValue fiLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canAddField fFrameWin 
FUNCTION canAddField RETURNS LOGICAL
  ( INPUT phField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeBrowse fFrameWin 
FUNCTION closeBrowse RETURNS LOGICAL
  ( INPUT phBrowse AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupBrowse fFrameWin 
FUNCTION setupBrowse RETURNS HANDLE
  ( INPUT phTable AS HANDLE,
    INPUT phBrowse AS HANDLE,
    INPUT pcFields AS CHARACTER,
    OUTPUT pcColumnHandles AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE edDBValue AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 43.6 BY 8.67 NO-UNDO.

DEFINE VARIABLE edDSValue AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 43.6 BY 8.67 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.6 BY 9.52.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.6 BY 9.52.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.4 BY 9.52.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 142.8 BY 11.62.


/* Browse definitions                                                   */
DEFINE BROWSE brDataset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDataset fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140.8 BY 10.76 ROW-HEIGHT-CHARS .62.

DEFINE BROWSE brFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFields fFrameWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48.4 BY 8.95 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     brDataset AT ROW 1.86 COL 2.6
     brFields AT ROW 13.86 COL 2.6
     edDSValue AT ROW 13.95 COL 54 NO-LABEL
     edDBValue AT ROW 13.95 COL 100.4 NO-LABEL
     fiLabel AT ROW 1.1 COL 1.4 COLON-ALIGNED NO-LABEL
     RECT-5 AT ROW 13.48 COL 53
     RECT-6 AT ROW 13.48 COL 99.4
     RECT-7 AT ROW 13.48 COL 1.8
     RECT-8 AT ROW 1.38 COL 1.8
     "Dataset Value:" VIEW-AS TEXT
          SIZE 15.4 BY .62 AT ROW 13.14 COL 55.2
     "Database Value:" VIEW-AS TEXT
          SIZE 16.4 BY .62 AT ROW 13.1 COL 101
     "Altered Fields:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 13.14 COL 3.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144 BY 22.05.


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
         HEIGHT             = 22.05
         WIDTH              = 144.
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
/* BROWSE-TAB brDataset 1 fMain */
/* BROWSE-TAB brFields brDataset fMain */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

ASSIGN 
       edDBValue:RETURN-INSERTED IN FRAME fMain  = TRUE
       edDBValue:READ-ONLY IN FRAME fMain        = TRUE.

ASSIGN 
       edDSValue:RETURN-INSERTED IN FRAME fMain  = TRUE
       edDSValue:READ-ONLY IN FRAME fMain        = TRUE.

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

&Scoped-define BROWSE-NAME brDataset
&Scoped-define SELF-NAME brDataset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDataset fFrameWin
ON ROW-DISPLAY OF brDataset IN FRAME fMain
DO:
  RUN rowDisplay.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDataset fFrameWin
ON VALUE-CHANGED OF brDataset IN FRAME fMain
DO:
  RUN getFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFields
&Scoped-define SELF-NAME brFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFields fFrameWin
ON VALUE-CHANGED OF brFields IN FRAME fMain
DO:
  RUN displayFieldVal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDataset
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDataset fFrameWin 
PROCEDURE buildDataset :
/*------------------------------------------------------------------------------
  Purpose:     Builds a browse of the data in the table referenced by the 
               current ttTableList.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTTField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDBNameField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableNameField AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cDBTable        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hEMField        AS HANDLE     NO-UNDO.

  /* Get the handles to all the buffers. The transaction buffer is not used yet */ 
  RUN getRecordSet IN ghRecordSet
    (OUTPUT ghTable, OUTPUT ghTableList, OUTPUT ghTrans, OUTPUT ghEntity).

  IF NOT VALID-HANDLE(ghTableList) OR
     NOT ghTableList:AVAILABLE THEN
  DO:
    RETURN.
  END.

  /* Obtain the handle to the TEMP-TABLE's buffer */
  hTTField          = ghTableList:BUFFER-FIELD("hTable":U).
  hEMField          = ghTableList:BUFFER-FIELD("cEntityMnemonic":U).
  hBuffer           = hTTField:BUFFER-VALUE.
  hBuffer           = hBuffer:DEFAULT-BUFFER-HANDLE.
  gcEntityMnemonic  = hEMField:BUFFER-VALUE.
  

  /* Create a new buffer on the temp-table because we need to browse this
     table and if we don't create a buffer, we're going to mess up the 
     cursor for any queries that the default buffer may use. */
  CREATE BUFFER ghTTBuffer FOR TABLE hBuffer.
  
  /* Now create a buffer on the database table */
  hDBNameField      = ghTableList:BUFFER-FIELD("cDBName":U).
  hTableNameField   = ghTableList:BUFFER-FIELD("cTableName":U).

  IF hDBNameField:BUFFER-VALUE <> "TEMP-TABLE":U THEN
  DO:
    cDBTable          = hDBNameField:BUFFER-VALUE + ".":U + hTableNameField:BUFFER-VALUE.
  
    CREATE BUFFER ghTableBuffer FOR TABLE cDBTable.
  END.

  /* Open the query and the browse on the temp-table */
  DO WITH FRAME {&FRAME-NAME}:
    fiLabel:SCREEN-VALUE = "Table: " + cDBTable.
    fiLabel:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(fiLabel:SCREEN-VALUE) + 2.
    ghDSQry = setupBrowse(ghTTBuffer, BROWSE brDataset:HANDLE, "*":U, OUTPUT gcDSCols).
    ghDSQry:QUERY-OPEN().

    RUN getFields.
  END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFieldVal fFrameWin 
PROCEDURE displayFieldVal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTTField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDBField AS HANDLE     NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:

    IF AVAILABLE(ttAlteredField) THEN
    DO:
      hTTField = ttAlteredField.hTTField.
      hDBField = ttAlteredField.hDBField.
      edDSValue:SCREEN-VALUE = hTTField:STRING-VALUE.
      IF VALID-HANDLE(hDBField) THEN
        edDBValue:SCREEN-VALUE = hDBField:STRING-VALUE.
      ELSE
        edDBValue:SCREEN-VALUE = "":U.
    END.
    ELSE
    DO:
      edDSValue:SCREEN-VALUE = "":U.
      edDBValue:SCREEN-VALUE = "":U.
    END.
  END.

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
  DISPLAY edDSValue edDBValue fiLabel 
      WITH FRAME fMain.
  ENABLE edDSValue edDBValue fiLabel RECT-5 RECT-6 RECT-7 RECT-8 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRelated fFrameWin 
PROCEDURE findRelated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hBuffer    AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER plChanged  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hTTField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDBField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.


  IF NOT hBuffer:AVAILABLE THEN
  DO:
    plChanged = NO.
    RETURN.
  END.
    

  DYNAMIC-FUNCTION("obtainDatabaseRec":U IN ghDDXML,
                   gcEntityMnemonic,
                   hBuffer,
                   ghTableBuffer).

  IF VALID-HANDLE(ghTableBuffer) AND
     ghTableBuffer:AVAILABLE THEN
  DO:
    plChanged = NO.
    REPEAT iCount = 1 TO ghTTBuffer:NUM-FIELDS:
      hTTField = hBuffer:BUFFER-FIELD(iCount).
      hDBField = ghTableBuffer:BUFFER-FIELD(hTTField:NAME) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF VALID-HANDLE(hDBField) THEN
      DO:
        IF hTTField:BUFFER-VALUE <> hDBField:BUFFER-VALUE THEN
        DO:
          plChanged = YES.
          LEAVE.
        END.
      END.
    END.
  END.
  ELSE 
    plChanged = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFields fFrameWin 
PROCEDURE getFields :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the fields that don't match
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lChanged  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDBField  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTField  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cString   AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttAlteredField FOR ttAlteredField.

  EMPTY TEMP-TABLE bttAlteredField.

  RUN findRelated (ghTTBuffer, OUTPUT lChanged).

  IF lChanged = YES OR
     lChanged = ? THEN
  DO:
    REPEAT iCount = 1 TO ghTTBuffer:NUM-FIELDS:
      hTTField = ghTTBuffer:BUFFER-FIELD(iCount).

      IF lChanged = ? THEN
      DO:
        hDBField = ?.
      END.
      ELSE
      DO:
        hDBField = ghTableBuffer:BUFFER-FIELD(hTTField:NAME) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
        IF VALID-HANDLE(hDBField) AND
           hTTField:BUFFER-VALUE = hDBField:BUFFER-VALUE THEN
          NEXT.
      END.

      CREATE bttAlteredField.
      ASSIGN
        bttAlteredField.cFieldName = hTTField:NAME
        bttAlteredField.cDataType  = hTTField:DATA-TYPE
        bttAlteredField.cLabel     = hTTField:LABEL
        bttAlteredField.hTTField   = hTTField
        bttAlteredField.hDBField   = hDBField
        .
    END.

  END.

  DO WITH FRAME {&FRAME-NAME}:
    ghFieldQry = setupBrowse(INPUT BUFFER ttAlteredField:HANDLE, 
                             BROWSE brFields:HANDLE, 
                             "!hTTField,!hDBField,*":U, 
                             OUTPUT cString).
    ghFieldQry:QUERY-OPEN().
  END.
  
  RUN displayFieldVal.
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

  ghTable = ?.
  ghTableList = ?.
  ghTrans = ?.

  DO WITH FRAME {&FRAME-NAME}:
    closeBrowse(BROWSE brDataset:HANDLE).
    closeBrowse(BROWSE brFields:HANDLE).
  END.

  IF VALID-HANDLE(ghTTBuffer) THEN
  DO:
    DELETE OBJECT ghTTBuffer.
    ghTTBuffer = ?.
  END.
  
  IF VALID-HANDLE(ghTableBuffer) THEN
  DO:
    DELETE OBJECT ghTableBuffer.
    ghTableBuffer = ?.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  PUBLISH "RecordSet":U (THIS-PROCEDURE:HANDLE).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay fFrameWin 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Row display trigger for display of dataset 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjCol    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChanged   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCol       AS HANDLE     NO-UNDO.

  IF NOT ghTTBuffer:AVAILABLE THEN
    RETURN.
  
  RUN findRelated(ghTTBuffer, OUTPUT lChanged).

  REPEAT iCount = 1 TO NUM-ENTRIES(gcDSCols):
    hCol = WIDGET-HANDLE(ENTRY(iCount,gcDSCols)).
    IF NOT VALID-HANDLE(hCol) THEN
      NEXT.
    
    CASE lChanged:
      WHEN YES THEN   /* record exists and has changed */
      DO:
        hCol:BGCOLOR = 12. /* red */
        hCol:FGCOLOR = 15. /* white */
      END.
      WHEN NO THEN   /* record exists - no change */
      DO:
        hCol:BGCOLOR = 15. /* white */
        hCol:FGCOLOR = 0.  /* black */
      END.
      WHEN ? THEN   /* record does not exist in database */
      DO:
        hCol:BGCOLOR = 9.  /* blue */
        hCol:FGCOLOR = 15. /* white */
      END.
    END.
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecordSet fFrameWin 
PROCEDURE setRecordSet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phProc  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phDDXML AS HANDLE     NO-UNDO.

  ghRecordSet = phProc.
  ghDDXML     = phDDXML.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  IF VALID-HANDLE(ghDDXML) THEN
    RUN buildDataset.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupBrowse fFrameWin 
FUNCTION setupBrowse RETURNS HANDLE
  ( INPUT phTable AS HANDLE,
    INPUT phBrowse AS HANDLE,
    INPUT pcFields AS CHARACTER,
    OUTPUT pcColumnHandles AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Opens a query and a brows
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowseCol AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColHdl    AS CHARACTER  NO-UNDO.

  /* Close down the existing Browse's query */
  closeBrowse(phBrowse).

  /* Create a new query */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(phTable).
  hQuery:QUERY-PREPARE("FOR EACH ":U + phTable:NAME + " NO-LOCK":U).

  /* Add the query to the Browse */
  phBrowse:QUERY = hQuery.

  REPEAT iCount = 1 TO phTable:NUM-FIELDS:
    hField = phTable:BUFFER-FIELD(iCount).
    IF NOT CAN-DO(pcFields,hField:NAME) THEN
      NEXT.
    IF canAddField(hField) THEN
    DO:
      hBrowseCol = phBrowse:ADD-LIKE-COLUMN(hField).
      IF VALID-HANDLE(hBrowseCol) THEN
      DO:
        cColHdl = cColHdl + (IF cColHdl = "":U THEN "":U ELSE ",":U)
                + STRING(hBrowseCol).
      END.
    END.
  END.
  phBrowse:COLUMN-RESIZABLE = YES.
  phBrowse:SENSITIVE = YES.
  pcColumnHandles = cColHdl.
  
  RETURN hQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

