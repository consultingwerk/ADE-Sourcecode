&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: afgentablv.w

  Description:  Object Generator Tables Viewer

  Purpose:      Object Generator Tables Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/02/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

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

&scop object-name       afgentablv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{ src/adm2/globals.i }
{ af/app/afgenretin.i }
{ launch.i &Define-only=YES }

/* Needed for RTB SCM control. */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER                NO-UNDO.

DEFINE VARIABLE ghContainerSource                   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghBrowse                            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery                             AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gcColumnsHandles                    AS CHARACTER                NO-UNDO.
DEFINE VARIABLE ghHeaderInfoBuffer                  AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghBrowseDataTable                   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghScmTool                           AS HANDLE                   NO-UNDO.

DEFINE VARIABLE gcPopulateSource                    AS CHARACTER                NO-UNDO.
DEFINE VARIABLE ghQuery1                            AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule coDbName buSelectAll ~
buDeSelectAll toSizeHolder 
&Scoped-Define DISPLAYED-OBJECTS coProductModule coDbName toSizeHolder 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeSelectAll 
     LABEL "Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coDbName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 65 BY 1 TOOLTIP "Select a database to generate objects from." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 65 BY 1 TOOLTIP "Use this product module to filter the DataObjects shown." NO-UNDO.

DEFINE VARIABLE toSizeHolder AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3.6 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProductModule AT ROW 1.19 COL 19.4 COLON-ALIGNED
     coDbName AT ROW 1.19 COL 19.4 COLON-ALIGNED
     buSelectAll AT ROW 1.1 COL 88.2
     buDeSelectAll AT ROW 1.1 COL 103.8
     toSizeHolder AT ROW 8.81 COL 115.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Compile into: af/obj2
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
         HEIGHT             = 8.67
         WIDTH              = 118.4.
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
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       coDbName:PRIVATE-DATA IN FRAME frMain     = 
                "DATABASE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "MODULE".

ASSIGN 
       toSizeHolder:HIDDEN IN FRAME frMain           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buDeSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeSelectAll sObject
ON CHOOSE OF buDeSelectAll IN FRAME frMain /* Deselect All */
DO:
  RUN selectRecords(ghBrowse, NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll sObject
ON CHOOSE OF buSelectAll IN FRAME frMain /* Select All */
DO:
  RUN selectRecords(ghBrowse, YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDbName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDbName sObject
ON VALUE-CHANGED OF coDbName IN FRAME frMain /* Database */
DO:

  ASSIGN
    coDBName.

  ASSIGN
    ghBrowse:PRIVATE-DATA = "":U
    gcPopulateSource      = "DATABASE":U.

  RUN populateBrowse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule sObject
ON VALUE-CHANGED OF coProductModule IN FRAME frMain /* Product module */
DO:

  ASSIGN
    coProductModule.
  
  PUBLISH "ProductModuleChanged":U FROM ghContainerSource (INPUT coProductModule).

  ASSIGN
    ghBrowse:PRIVATE-DATA = "":U
    gcPopulateSource      = "MODULE":U.

  RUN populateBrowse.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowse sObject 
PROCEDURE buildBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Constructs the browse widget.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  CREATE BROWSE ghBrowse
    ASSIGN
      FRAME            = FRAME {&FRAME-NAME}:HANDLE
      ROW              = 2.5 
      COLUMN           = 1.5
      HEIGHT-CHARS     = 5
      WIDTH-CHARS      = 5
      SENSITIVE        = NO
      HIDDEN           = YES
      QUERY            = ghQuery
      EXPANDABLE       = YES
      ROW-MARKERS      = NO
      SEPARATORS       = YES
      MULTIPLE         = YES
      COLUMN-RESIZABLE = YES
      .

  RUN resizeObject(INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS
                  ,INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS
                  ).

  /* View the browse. We only make it sensitive once there is some data in it. */
  ASSIGN
    ghBrowse:HIDDEN = NO.

  RETURN.

END PROCEDURE.  /* buildBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN SUPER.

    IF VALID-HANDLE(ghBrowseDataTable) THEN
    DO:
        DELETE OBJECT ghBrowseDataTable NO-ERROR.
        ASSIGN ghBrowseDataTable = ?.
    END.    /* valid browse data table. */

    RETURN.
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBrowseHandle sObject 
PROCEDURE getBrowseHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER phBrowse  AS HANDLE   NO-UNDO.

  ASSIGN
    phBrowse = ghBrowse.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTablesFrame sObject 
PROCEDURE getTablesFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phFrame             AS HANDLE               NO-UNDO.

    ASSIGN phFrame = FRAME {&FRAME-NAME}:HANDLE.

    RETURN.
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
  DEFINE VARIABLE cLabel        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCountDB      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCountPMOD    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iListLoop     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDBNum        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPopupMenu    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupItem    AS HANDLE     NO-UNDO.

  RUN SUPER.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      coDbName:LIST-ITEM-PAIRS        = coDbName:SCREEN-VALUE
      coProductModule:LIST-ITEM-PAIRS = coProductModule:SCREEN-VALUE
      NO-ERROR.

    PUBLISH "getHeaderInfoBuffer" FROM ghContainerSource ( OUTPUT ghHeaderInfoBuffer ).

    IF VALID-HANDLE(ghHeaderInfoBuffer)
    THEN DO:

        IF NOT VALID-HANDLE(ghQuery1) THEN
            CREATE QUERY ghQuery1.

        ghQuery1:SET-BUFFERS(ghHeaderInfoBuffer).

      ghQuery1:QUERY-PREPARE(" FOR EACH ttHeaderInfo WHERE ttHeaderInfo.tDisplayRecord = YES":U).
      ghQuery1:QUERY-OPEN().
      ghQuery1:GET-FIRST().

      DO WHILE ghHeaderInfoBuffer:AVAILABLE:

        IF ghHeaderInfoBuffer:BUFFER-FIELD("tType":U):BUFFER-VALUE EQ "MODULE":U
        THEN DO:
          ASSIGN
            cLabel = ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                   + " ( ":U
                   + ENTRY(2, ghHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1))
                   + " )":U
            cValue = ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
            NO-ERROR.
          coProductModule:ADD-LAST(cLabel, cValue).
          iCountPMOD = iCountPMOD + 1.
        END.
        ELSE
        IF ghHeaderInfoBuffer:BUFFER-FIELD("tType":U):BUFFER-VALUE EQ "DATABASE":U
        THEN DO:
          ASSIGN
            cLabel = LC(ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE)
            cValue = LC(ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE)
            NO-ERROR.
          coDbName:ADD-LAST(cLabel, cValue).
          iCountDB = iCountDB + 1.
        END.

        ghQuery1:GET-NEXT().

      END.    /* available headerinfo */

      ghQuery1:QUERY-CLOSE().

      IF iCountPMOD > 1
      THEN coProductModule:ADD-FIRST("<All>":U,"<All>":U).
      IF iCountDB > 1
      THEN coDbName:ADD-FIRST("<All>":U,"<All>":U).

      IF iCountPMOD > 1
      THEN
        ASSIGN
          coProductModule:SCREEN-VALUE = coProductModule:ENTRY(2)
          NO-ERROR.
      ELSE
        ASSIGN
          coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1)
          NO-ERROR.

      IF iCountDB > 1
      THEN
        ASSIGN
          iDBNum = 2.
      ELSE
        ASSIGN
          iDBNum = 1.

      blkDbLoop:
      DO iListLoop = 1 TO coDBName:NUM-ITEMS:
        IF coDBName:ENTRY(iListLoop) = "<All>":U
        OR coDBName:ENTRY(iListLoop) = "ICFDB":U
        OR coDBName:ENTRY(iListLoop) = "TEMP-DB":U
        THEN
          NEXT blkDbLoop.
        ELSE DO:
          ASSIGN
            iDBNum = iListLoop.
          LEAVE blkDbLoop.
        END.
      END.

      IF iDBNum > 0
      THEN
        ASSIGN
          coDbName:SCREEN-VALUE = coDbName:ENTRY( iDBNum )
          NO-ERROR.
      ELSE
        ASSIGN
          coDbName:SCREEN-VALUE = coDbName:ENTRY(1)
          NO-ERROR.

    END.    /* valid buffer handle */

  END.    /* with frame ... */

    RUN buildBrowse.

    /* Removed the pop-up menu as part of issue 9635. This functionality will be replaced 
     * by the changes to be made for issue 9042.                                          */

  RUN toggleDataObjects ( INPUT YES).

  SUBSCRIBE TO "toggleDataObjects":U      IN ghContainerSource.
  SUBSCRIBE TO "getBrowseHandle":U        IN ghContainerSource.
  SUBSCRIBE TO "getTablesFrame":U         IN ghContainerSource.
  SUBSCRIBE TO "populateBrowse":U         IN ghContainerSource.

  RETURN.

END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

    RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

    /* Set the handle of the container source immediately upon making the link */
    IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
        ASSIGN ghContainerSource = phObject.

    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateBrowse sObject 
PROCEDURE populateBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDataBasedOn            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButtonPressed          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBrowseDataBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowseDataTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowseColumn           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iColumnLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumnField            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumnHandles          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iListLoop               AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cListDB                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListPMOD               AS CHARACTER  NO-UNDO.

  ASSIGN
    cDataBasedOn = (IF gcPopulateSource EQ "DATABASE":U
                    THEN "SCHEMA":U      /* DATABASE */
                    ELSE "REPOSITORY":U  /* MODULE   */
                    ).

  DO WITH FRAME {&FRAME-NAME}:

    SESSION:SET-WAIT-STATE("GENERAL":U). 

    IF VALID-HANDLE(ghBrowseDataTable)
    THEN DO:
      DELETE OBJECT ghBrowseDataTable NO-ERROR.
      ASSIGN ghBrowseDataTable = ?.
    END.    /* valid browse data table. */

    ASSIGN
      coDbName
      coProductModule
      .

    ASSIGN
      cListDB   = "":U
      cListPMOD = "":U
      .

    IF coDBName = "<ALL>":U
    THEN /* Do not do 1 as it will be <ALL> */
    DO iListLoop = 2 TO coDBName:NUM-ITEMS:
      ASSIGN
        cListDB = cListDB
                + (IF cListDB <> "":U THEN ",":U ELSE "":U)
                + coDBName:ENTRY(iListLoop).
    END.
    ELSE
      ASSIGN
        cListDB = coDBName.

    IF coProductModule = "<ALL>":U
    THEN /* Do not do 1 as it will be <ALL> */
    DO iListLoop = 2 TO coProductModule:NUM-ITEMS:
      ASSIGN
        cListPMOD = cListPMOD
                  + (IF cListPMOD <> "":U THEN ",":U ELSE "":U)
                  + coProductModule:ENTRY(iListLoop).
    END.
    ELSE
      ASSIGN
        cListPMOD = coProductModule.

    ASSIGN
      ghBrowse:PRIVATE-DATA = gcPopulateSource.

    { launch.i
        &PLIP         = 'af/app/afgenplipp.p'
        &IProc        = 'retrieveBrowseData'
        &PList        = "( INPUT  cDataBasedOn
                         , INPUT  cListDB
                         , INPUT  cListPMOD
                         , OUTPUT TABLE-HANDLE hBrowseDataTable )"
        &AutoKill     = YES
    }

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U
    THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      RUN showMessages IN gshSessionManager
                      (INPUT  RETURN-VALUE                     /* message to display */
                      ,INPUT  "ERR"                            /* error type */
                      ,INPUT  "&OK"                            /* button list */
                      ,INPUT  "&OK"                            /* default button */ 
                      ,INPUT  "&OK"                            /* cancel button */
                      ,INPUT  "Data retrieval error"           /* error window title */
                      ,INPUT  YES                              /* display if empty */ 
                      ,INPUT  ghContainerSource                /* container handle */ 
                      ,OUTPUT cButtonPressed
                      ).
      RETURN ERROR.
    END.    /* error */

    ASSIGN
      hBrowseDataBuffer = hBrowseDataTable:DEFAULT-BUFFER-HANDLE
      ghBrowseDataTable = hBrowseDataTable
      NO-ERROR.

    IF VALID-HANDLE(hBrowseDataBuffer)
    THEN DO:
      /* Set the query */
      IF VALID-HANDLE(ghQuery)
      AND ghQuery:IS-OPEN
      THEN
        ghQuery:QUERY-CLOSE().
      ELSE
        CREATE QUERY ghQuery.
      ghQuery:SET-BUFFERS(hBrowseDataBuffer).
      ghQuery:QUERY-PREPARE(" FOR EACH ":U + hBrowseDataBuffer:NAME).
      ASSIGN
        ghBrowse:QUERY = ghQuery.

      /* Resize the columns */
      DO iColumnLoop = 1 TO hBrowseDataBuffer:NUM-FIELDS:
          
        hColumnField  = hBrowseDataBuffer:BUFFER-FIELD(iColumnLoop).
        IF hColumnField:COLUMN-LABEL EQ "?":U THEN
            NEXT.

        hBrowseColumn = ghBrowse:ADD-LIKE-COLUMN(hColumnField).

        IF VALID-HANDLE(hBrowseColumn)
        THEN DO:

          IF LENGTH(hBrowseColumn:LABEL) > hColumnField:WIDTH-CHARS
          THEN
            ASSIGN
              hBrowseColumn:WIDTH = LENGTH(hBrowseColumn:LABEL).
          ELSE
            ASSIGN
              hBrowseColumn:WIDTH = hColumnField:WIDTH-CHARS.

          ASSIGN
            cColumnHandles = cColumnHandles
                        + (IF cColumnHandles = "":U THEN "":U ELSE ",":U)
                        + STRING(hBrowseColumn).

        END.

      END.

      gcColumnsHandles = cColumnHandles.

      ghBrowse:FIT-LAST-COLUMN  = YES.

      ghQuery:QUERY-OPEN().

      /* Sensitise the browse */
      ghBrowse:SENSITIVE = YES.

    END.    /* valid buffer */

    SESSION:SET-WAIT-STATE("":U).

  END.    /* basis has changed. */

  RETURN.

END PROCEDURE.  /* populateBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdNewHeight              AS DECIMAL          NO-UNDO.
  DEFINE INPUT PARAMETER pdNewWidth               AS DECIMAL          NO-UNDO.

  ASSIGN
    FRAME {&FRAME-NAME}:SCROLLABLE           = TRUE
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS
    FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdNewHeight
    FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdNewWidth
    NO-ERROR.

  ASSIGN
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS
    FRAME {&FRAME-NAME}:SCROLLABLE           = FALSE
    NO-ERROR.

  IF VALID-HANDLE(ghBrowse)
  THEN
    ASSIGN
      ghBrowse:HEIGHT-CHARS = pdNewHeight - ghBrowse:ROW
      ghBrowse:WIDTH-CHARS  = pdNewWidth  - ghBrowse:COLUMN
      NO-ERROR.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRecords sObject 
PROCEDURE selectRecords :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toggleDataObjects sObject 
PROCEDURE toggleDataObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plChecked            AS LOGICAL              NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    IF plChecked
    THEN
      ASSIGN
        coDbName:HIDDEN         = NO
        coProductModule:HIDDEN  = YES
        gcPopulateSource        = "DATABASE":U
        .
    ELSE
      ASSIGN
        coDbName:HIDDEN         = YES
        coProductModule:HIDDEN  = NO
        gcPopulateSource        = "MODULE":U
        .

    ASSIGN
      ghBrowse:PRIVATE-DATA = "":U.

  END.    /* with frame ... */

  RUN populateBrowse.

  RETURN.

END PROCEDURE.  /* toggleDataObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

