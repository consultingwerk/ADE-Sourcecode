&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Security Filter Viewer - Dynamic"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: secfiltervsupr.p

  Description:  Security Filter Viewer - Dynamic

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/14/2003  Author:     

  Update Notes: Created from Template viewv

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

&scop object-name       secfiltervsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE gdLastSetWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdLastSetHeight   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery           AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttFilterData
  FIELD cFieldLabel AS CHARACTER FORMAT "X(35)":U
  FIELD cFromValue  AS CHARACTER FORMAT "X(35)":U
  FIELD cToValue    AS CHARACTER FORMAT "X(35)":U
  FIELD cFormat     AS CHARACTER FORMAT "X(15)":U
  FIELD cDataType   AS CHARACTER FORMAT "X(10)":U
  FIELD cTableName  AS CHARACTER
  FIELD cFieldName  AS CHARACTER
  FIELD iFieldOrder AS INTEGER
  INDEX idx1        AS PRIMARY iFieldOrder
  INDEX idx2        AS UNIQUE cTableName cFieldName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10.71
         WIDTH              = 56.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilter Procedure 
PROCEDURE buildFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuffer AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName  AS CHARACTER  NO-UNDO.

  /* First, lets build the temp-table data */
  EMPTY TEMP-TABLE ttFilterData.
  DO iLoop = 1 TO phBuffer:NUM-FIELDS:
    hCurField = phBuffer:BUFFER-FIELD(iLoop).
    /* Do not include any _obj fields in browser */
    IF INDEX(hCurField:NAME,"_obj":U) > 0 AND
       SUBSTRING(hCurField:NAME,LENGTH(hCurField:NAME) - 3,4) = "_obj":U THEN
      NEXT.
    IF INDEX(hCurField:NAME,"__":U) > 0 THEN
      ASSIGN cFieldName = REPLACE(hCurField:NAME,"__":U,".":U)
             cTableName = ENTRY(1,cFieldName,".":U)
             cFieldName = ENTRY(2,cFieldName,".":U).
    ELSE DO:
      /* Do not include these fields to be filtered - 
         they are outer-joined */
      IF hCurField:NAME = "cProdMod":U OR
         hCurField:NAME = "cObject":U OR
         hCurField:NAME = "cInstanceAttr":U OR
         hCurField:NAME = "cSecurityType":U OR
         hCurField:NAME = "cFromValue":U OR 
         hCurField:NAME = "cToValue":U THEN
          NEXT.
        NEXT.
    END.
              
    CREATE ttFilterData.
    ASSIGN ttFilterData.iFieldOrder = iLoop
           ttFilterData.cFieldName  = cFieldName
           ttFilterData.cTableName  = cTableName
           ttFilterData.cFieldLabel = hCurField:LABEL
           ttFilterData.cFormat     = hCurField:FORMAT
           ttFilterData.cDataType   = hCurField:DATA-TYPE.
  END.

  RUN createBrowser IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseApply) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseApply Procedure 
PROCEDURE chooseApply :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hSecViewer  AS HANDLE     NO-UNDO.

  /* First validate fields in filter temp-table before applying */
  RUN validateFilter IN TARGET-PROCEDURE (OUTPUT lOk).
  IF NOT lOk THEN RETURN NO-APPLY.
  
  hSecViewer = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "SecFilter-Source":U)).

  /* Apply filter to the linked source */
  IF VALID-HANDLE(hSecViewer) THEN
     RUN applyFilters IN hSecViewer (INPUT TABLE ttFilterData).

  /* Change tab folder page to previous page */
  RUN processAction IN TARGET-PROCEDURE (INPUT "CTRL-PAGE-UP":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseClear) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseClear Procedure 
PROCEDURE chooseClear :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Clear from and to values */
  FOR EACH ttFilterData:
    ASSIGN
      ttFilterData.cFromValue = IF ttFilterData.cDataType EQ "LOGICAL":U THEN "NO"  ELSE "":U
      ttFilterData.cToValue   = IF ttFilterData.cDataType EQ "LOGICAL":U THEN "YES" ELSE "":U
      .
  END.

  /* Now open the query */
  ghQuery:QUERY-OPEN().

  /* Move focus to browser */
  IF VALID-HANDLE(ghBrowse) THEN
  APPLY "ENTRY":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowser Procedure 
PROCEDURE createBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Create the browse for the Non Secured Data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hButton                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldChars               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldChars               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSortColumn               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSortBy                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFieldList                AS CHARACTER  NO-UNDO.
  /* Construct query for dynamic temp table */
  
  {get ContainerHandle hFrame}.
  hButton = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buClear":U, "ALL":U).
  
  IF VALID-HANDLE(ghBrowse) THEN
    DELETE OBJECT ghBrowse.
  IF VALID-HANDLE(ghQuery) THEN
    DELETE OBJECT ghQuery.
  IF VALID-HANDLE(ghTable) THEN
    DELETE OBJECT ghTable.
  
  /* Get handles to filter temp table and filter temp table buffer */
  ASSIGN
    ghTable = TEMP-TABLE ttFilterData:HANDLE
    ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
    . 

  /* Construct query for filter temp table */
  CREATE QUERY ghQuery.
  ghQuery:ADD-BUFFER(ghBuffer).
  ASSIGN cQuery = "FOR EACH ttFilterData NO-LOCK":U.
  ghQuery:QUERY-PREPARE(cQuery).


  CREATE BROWSE ghBrowse
     ASSIGN FRAME            = hFrame
            ROW              = hButton:ROW + 1.2
            COL              = 1
            WIDTH-CHARS      = hFrame:WIDTH-CHARS - .8
            HEIGHT-CHARS     = hFrame:HEIGHT-CHARS - ghBrowse:ROW + .5
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = FALSE
            READ-ONLY        = FALSE
            MULTIPLE         = FALSE
            QUERY            = ghQuery
      /* Set procedures to handle browser events */
      TRIGGERS:            
        ON ROW-LEAVE
           PERSISTENT RUN rowLeave        IN THIS-PROCEDURE.
        ON ANY-PRINTABLE, 
           MOUSE-SELECT-DBLCLICK ANYWHERE
           PERSISTENT RUN setScreenValue  IN THIS-PROCEDURE.
      END TRIGGERS.
  
  /* Hide the dynamic browser while it is being constructed */
  ASSIGN
     ghBrowse:VISIBLE   = NO
     ghBrowse:SENSITIVE = NO.

  /* Add fields to browser using structure of dynamic temp table */
  DO iLoop = 1 TO 5:
    hCurField = ghBuffer:BUFFER-FIELD(iLoop).

    CASE iLoop:
      WHEN 1 THEN
        ASSIGN
          hCurField:FORMAT = "x(35)":U
          hCurField:LABEL = "Filter Field":U
          .
      WHEN 2 THEN
        ASSIGN
          hCurField:FORMAT = "x(20)":U
          hCurField:LABEL = "From Value":U
          .
      WHEN 3 THEN
        ASSIGN
          hCurField:FORMAT = "x(20)":U
          hCurField:LABEL = "To Value":U
          .
      WHEN 4 THEN
        ASSIGN
          hCurField:FORMAT = "x(20)":U
          hCurField:LABEL = "Format":U
          .
      WHEN 5 THEN
        ASSIGN
          hCurField:FORMAT = "x(20)":U
          hCurField:LABEL = "Datatype":U
          .
    END CASE. /* CASE iLoop */

    hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

    /* Enable To and From columns, disable the rest */
    IF iLoop = 2 OR iLoop = 3 THEN
      ASSIGN
        hField:READ-ONLY = FALSE.
    ELSE
      ASSIGN
        hField:READ-ONLY = TRUE.
/*
    /* Build up the list of browse columns for use in rowDisplay */
    IF VALID-HANDLE(hField) THEN
      cBrowseColHdls = cBrowseColHdls + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                       + STRING(hField).
*/
  END. /* DO iLoop = 1 TO 5 */

  /* Lock first column of browser */
  ghBrowse:NUM-LOCKED-COLUMNS = 1.

  /* Open the query for the browser */
  ghQuery:QUERY-OPEN() NO-ERROR.

  /* Show and move focus to the browser */
  ASSIGN
     hFrame:VISIBLE     = FALSE
     ghBrowse:VISIBLE   = FALSE
     ghBrowse:SENSITIVE = YES
     .
  APPLY "ENTRY":U TO ghBrowse.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Clean up dynamic object handles */
    DELETE OBJECT ghBrowse NO-ERROR.
    ASSIGN ghBrowse = ?.
    DELETE OBJECT ghQuery NO-ERROR.
    ASSIGN ghQuery = ?.
    DELETE OBJECT ghTable NO-ERROR.
    ASSIGN ghTable = ?.

    RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     Override procedure to add NO-ERROR to assignment of COL and ROW
               due to unexplained errors.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdRow AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCol AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.


  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    ASSIGN hContainer:ROW = pdRow
           hContainer:COL = pdCol NO-ERROR.
  ERROR-STATUS:ERROR = FALSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize the viewer and all widgets on it
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  IF pdHeight = 0
  OR pdWidth = 0 THEN
      RETURN.

  DEFINE VARIABLE hButton AS HANDLE     NO-UNDO EXTENT 2.
  DEFINE VARIABLE hFrame  AS HANDLE     NO-UNDO.

  {get ContainerHandle hFrame}.
          
  IF NOT VALID-HANDLE(hFrame) THEN
    RETURN.

  hButton[1] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buApply":U, "ALL":U).
  hButton[2] = DYNAMIC-FUNCTION("internalWidgetHandle" IN TARGET-PROCEDURE,"buClear":U, "ALL":U).

  ASSIGN gdLastSetWidth  = pdWidth
         gdLastSetHeight = pdHeight.
  
  IF NOT VALID-HANDLE(hButton[1]) THEN
    RETURN.

  IF pdWidth < hFrame:WIDTH THEN DO:
    /* Move All Widgets and then the frame */
    ASSIGN hButton[2]:COL = pdWidth - hButton[2]:WIDTH - .5
           hButton[1]:COL = hButton[2]:COL - hButton[2]:WIDTH - .05.
    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN ghBrowse:WIDTH = pdWidth - 1.5.

    ASSIGN hFrame:WIDTH         = pdWidth
           hFrame:SCROLLABLE    = TRUE
           hFrame:VIRTUAL-WIDTH = pdWidth
           hFrame:SCROLLABLE    = FALSE.
  END.
  ELSE DO:
    /* Move the frame and then the widgets */
    ASSIGN hFrame:WIDTH         = pdWidth
           hFrame:SCROLLABLE    = TRUE
           hFrame:VIRTUAL-WIDTH = pdWidth
           hFrame:SCROLLABLE    = FALSE.
    ASSIGN hButton[2]:COL = pdWidth - hButton[2]:WIDTH - .5
           hButton[1]:COL = hButton[2]:COL - hButton[2]:WIDTH - .05.
    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN ghBrowse:WIDTH = pdWidth - 1.5.
  END.
  
  IF pdHeight < hFrame:HEIGHT THEN DO:
    /* Move All Widgets and then the frame */
    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN ghBrowse:HEIGHT = pdHeight - ghBrowse:ROW + 1.
    ASSIGN hFrame:SCROLLABLE     = TRUE
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE     = FALSE
           hFrame:HEIGHT         = pdHeight.
  END.
  ELSE DO:
    /* Move the frame and then the widgets */
    ASSIGN hFrame:HEIGHT        = pdHeight
           hFrame:SCROLLABLE    = TRUE
           hFrame:VIRTUAL-HEIGHT = pdHeight
           hFrame:SCROLLABLE    = FALSE.
    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN ghBrowse:HEIGHT = pdHeight - ghBrowse:ROW + 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowLeave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave Procedure 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Procedure for 'ROW-LEAVE' browser event
  Parameters:  <none>
  Notes:       Assigns column screen values of the current record in the browser
               to the corresponding temp table buffer fields
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hCol                      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.

    /* if current record in browse has been modified */
    IF ghBrowse:CURRENT-ROW-MODIFIED THEN
    DO:
       /* for each column in the browse */
       REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
          hCol = ghBrowse:GET-BROWSE-COLUMN(iLoop).

          /* If modified then assign column screen value to corresponding temp table buffer field */
          IF hCol:MODIFIED THEN
          DO:
              hField = hCol:BUFFER-FIELD.
              IF VALID-HANDLE(hField) THEN
                  hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
          END.

       END. /* REPEAT */
    END. /* IF ghBrowse:CURRENT-ROW-MODIFIED */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValue Procedure 
PROCEDURE setScreenValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets screen values for columns in the browser for given UI events
               Also sets modified state
  Parameters:  <none>
  Notes:       For logical columns, the user may mouse-double-click to toggle YES and NO,
               or type 'Y' or 'N'.
               This approach needs rework as there is a lot of specific hard-coding.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hCurrentField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataTypeField       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCurrentColumn       AS HANDLE    NO-UNDO.

  /* If a record is available in browser */
  IF ghBuffer:AVAILABLE THEN
  DO:
     /* Gat handle to data type column of filter browser */
     hDataTypeField = ghBuffer:BUFFER-FIELD('cDataType':U).

     /* If the current column in the browser is of a logical data type */
     IF hDataTypeField:BUFFER-VALUE = 'LOGICAL':U THEN
     DO:

         /* Get handle of current column and handle of corresponding buffer field in the temp table */
         ASSIGN
            hCurrentColumn      = ghBrowse:CURRENT-COLUMN
            hCurrentField       = hCurrentColumn:BUFFER-FIELD
            .

         /* Toggle YES/NO screen value if mouse is double clicked */         
         IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U THEN
         DO:
             IF hCurrentColumn:SCREEN-VALUE EQ 'YES' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'NO'.
             ELSE IF hCurrentColumn:SCREEN-VALUE EQ 'NO' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'YES'.
         END. /* IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U */
         ELSE 
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'Y' THEN
              hCurrentColumn:SCREEN-VALUE = 'YES'.
         ELSE 
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'N' THEN
                hCurrentColumn:SCREEN-VALUE = 'NO'.

         /* Assign screen value to temp table buffer */
         hCurrentField:BUFFER-VALUE  = hCurrentColumn:SCREEN-VALUE.

         /* Return without processing the original browser event */
         RETURN NO-APPLY.

     END. /* IF hDataTypeField:BUFFER-VALUE = 'LOGICAL':U */

  END. /* IF ghBuffer:AVAILABLE */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFilter Procedure 
PROCEDURE validateFilter :
/*------------------------------------------------------------------------------
  Purpose:     Validate filter settings
  Parameters:  output flag indicating if the filter settings are valid or not
  Notes:       Checks that the values entered comply with the data type of the
               columns on the source browser
               Checks that From values are less than or equal to To values
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER lOk AS LOGICAL NO-UNDO.

    DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dDecimal        AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE tDateFrom       AS DATE         NO-UNDO.
    DEFINE VARIABLE tDateTo         AS DATE         NO-UNDO.

    /* Initialise result to valid */
    ASSIGN lOk = YES.

    /* for each record in the filter settings temp table */
    filter-loop:
    FOR EACH ttFilterData:

      /* if a From or To value has been entered */
      IF ttFilterData.cFromValue <> "":U OR ttFilterData.cToValue <> "":U THEN
      DO:

        CASE ttFilterData.cDataType:
          WHEN "decimal":U OR WHEN "integer":U THEN
          DO:
            /* Use ASSIGN statement with NO-ERROR to catch data type exception */
            ASSIGN 
                dDecimal = DECIMAL(ttFilterData.cFromValue)
                dDecimal = DECIMAL(ttFilterData.cToValue) 
                NO-ERROR.    
            IF  ERROR-STATUS:ERROR THEN
            DO:
              ASSIGN
                  cErrorMessage = "Invalid data type for " + ttFilterData.cFieldName + ".  Should be " + ttFilterData.cDataType + "."
                  lOk           = NO.
            END.
            ELSE
            /* From and To value range check */
            IF  ttFilterData.cToValue <> "":U
            AND DECIMAL(ttFilterData.cFromValue) > DECIMAL(ttFilterData.cToValue) THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                  lOk           = NO.
          END. /* WHEN "decimal":U OR WHEN "integer":U */

          WHEN "date":U THEN
          DO:
            /* Use ASSIGN statement with NO-ERROR to catch data type exception */
            ASSIGN 
                tDateFrom = DATE(ttFilterData.cFromValue)
                tDateTo   = DATE(ttFilterData.cToValue) 
                NO-ERROR.    
            IF  ERROR-STATUS:ERROR
            OR  (tDateFrom = ? AND ttFilterData.cFromValue <> "")
            OR  (tDateTo = ?   AND ttFilterData.cToValue   <> "":U) THEN
            DO:
              ASSIGN
                  cErrorMessage = "Invalid data type for " + ttFilterData.cFieldName + ".  Should be " + ttFilterData.cDataType + "."
                  lOk           = NO.    
            END.
            /* From and To value range check */
            ELSE IF  ttFilterData.cToValue <> "":U
            AND DATE(ttFilterData.cFromValue) > DATE(ttFilterData.cToValue) THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                  lOk = NO.
          END. /* WHEN "date":U */

          OTHERWISE
          DO: /* character, &c. */

            /* Valid From and To value range check */
            IF  ttFilterData.cToValue <> "":U
            AND ttFilterData.cFromValue > ttFilterData.cToValue THEN
              ASSIGN
                  cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value '" "'the from value'"}
                  lOk           = NO.
          END.

        END CASE. /* CASE ttFilterData.cDataType */

      END. /* IF ttFilterData.cFromValue <> "":U OR ttFilterData.cToValue <> "":U */

      /* Leave the loop if a check had failed */
      IF NOT lOk THEN LEAVE filter-loop.

    END.  /* filter-loop: FOR EACH ttFilterData */

    IF NOT lOk THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                             INPUT  "":U,             /* type */
                                             INPUT  "OK":U,           /* button list */
                                             INPUT  "OK":U,           /* default */
                                             INPUT  "OK":U,           /* cancel */
                                             INPUT  "":U,             /* title */
                                             INPUT  YES,              /* disp. empty */
                                             INPUT  ?,                /* container handle */
                                             OUTPUT cButton           /* button pressed */
                                            ).
    END. /* IF NOT lOk */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

  RUN SUPER.

  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
    RUN resizeObject IN TARGET-PROCEDURE (gdLastSetHeight, gdLastSetWidth).

  IF VALID-HANDLE(ghBrowse) THEN DO:
    ASSIGN ghBrowse:VISIBLE = TRUE.
    ghBrowse:REPOSITION-TO-ROW(1) NO-ERROR.
    APPLY "ENTRY":U TO ghBrowse.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Override this procedure, otherwise we will be prompted to save the
            data on leave.
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

