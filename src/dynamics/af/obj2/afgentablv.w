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

DEFINE VARIABLE ghContainerSource                   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghBrowse                            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery                             AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghHeaderInfoBuffer                  AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghBrowseDataTable                   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghScmTool                           AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buGenerate toGenerateDataObjects ~
toGenerateDataFields toGenerateViewers toGenerateBrowses toSizeHolder ~
RECT-11 
&Scoped-Define DISPLAYED-OBJECTS toGenerateDataObjects toGenerateDataFields ~
toGenerateViewers toGenerateBrowses toSizeHolder 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createObjectInformation sObject 
FUNCTION createObjectInformation RETURNS LOGICAL
    ( INPUT pcObjectType    AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInfoValue sObject 
FUNCTION getObjectInfoValue RETURNS CHARACTER
    ( INPUT pcObjectType    AS CHARACTER,
      INPUT pcTag           AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buGenerate 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "" 
     SIZE 4.4 BY 1.14
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.2 BY 1.71.

DEFINE VARIABLE toGenerateBrowses AS LOGICAL INITIAL no 
     LABEL "Browses" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateDataFields AS LOGICAL INITIAL no 
     LABEL "Data Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateDataObjects AS LOGICAL INITIAL yes 
     LABEL "Data Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "When unchecked, objects will be generated based on existing data objects" NO-UNDO.

DEFINE VARIABLE toGenerateViewers AS LOGICAL INITIAL no 
     LABEL "Viewers" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toSizeHolder AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buGenerate AT ROW 1.57 COL 87
     toGenerateDataObjects AT ROW 1.86 COL 7
     toGenerateDataFields AT ROW 1.86 COL 26.6
     toGenerateViewers AT ROW 1.86 COL 48.2
     toGenerateBrowses AT ROW 1.86 COL 69
     toSizeHolder AT ROW 13.38 COL 87.4
     RECT-11 AT ROW 1.48 COL 3.8
     " Generate these objects:" VIEW-AS TEXT
          SIZE 23.6 BY .62 AT ROW 1.19 COL 5
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
         HEIGHT             = 13.19
         WIDTH              = 90.4.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate sObject
ON CHOOSE OF buGenerate IN FRAME frMain
DO:
    RUN generateObjects NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toGenerateDataObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toGenerateDataObjects sObject
ON VALUE-CHANGED OF toGenerateDataObjects IN FRAME frMain /* Data Objects */
, toGenerateDataFields, toGenerateViewers, toGenerateBrowses
DO:
    RUN changeGeneratedObjects ( INPUT SELF:NAME, INPUT SELF:CHECKED ).
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
        ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
               ROW              = 3.3
               COLUMN           = 3.4
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
    RUN resizeObject ( INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

    /* View the browse. We only make it sensitive once there is some
     * data in it.                                                  */
    ASSIGN ghBrowse:HIDDEN = NO.

    RETURN.
END PROCEDURE.  /* buildBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeGeneratedObjects sObject 
PROCEDURE changeGeneratedObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcWidgetName         AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER plChecked            AS LOGICAL              NO-UNDO.

    DEFINE VARIABLE cWidgetName         AS CHARACTER                    NO-UNDO.  
    DEFINE VARIABLE cPageNumber         AS CHARACTER                    NO-UNDO.

    CASE pcWidgetName:
        WHEN "toGenerateDataObjects":U THEN ASSIGN cPageNumber = "2,3":U.
        WHEN "toGenerateDataFields":U  THEN ASSIGN cPageNumber = "3":U.
        WHEN "toGenerateBrowses":U     THEN ASSIGN cPageNumber = "4":U.
        WHEN "toGenerateViewers":U     THEN ASSIGN cPageNumber = "5":U.
        OTHERWISE                           ASSIGN cPageNumber = "":U.
    END CASE.   /* widget name */

    IF cPageNumber NE "":U THEN
    DO:
        IF plChecked THEN
            DYNAMIC-FUNCTION("enablePagesInFolder":U IN ghContainerSource, INPUT cPageNumber).
        ELSE
            DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT cPageNumber).
    END.    /* valid page number */

    /* If all the buttons are unchecked, then disable the generate button .*/
    DO WITH FRAME {&FRAME-NAME}:
        IF NOT toGenerateDataFields:CHECKED  AND
           NOT toGenerateDataObjects:CHECKED AND
           NOT toGenerateBrowses:CHECKED     AND
           NOT toGenerateViewers:CHECKED     THEN
            ASSIGN buGenerate:SENSITIVE = NO.
        ELSE
            ASSIGN buGenerate:SENSITIVE = YES.
    END.    /* with frame ... */

    /* Special case is the toGenerateDataObjects. We need to populate some data based on this flag. */
    IF pcWidgetName EQ "toGenerateDataObjects":U THEN
    DO:
        RUN populateBrowse ( INPUT (IF plChecked THEN "SCHEMA":U ELSE "REPOSITORY":U)).

        IF plChecked THEN
            ASSIGN toGenerateDataFields:CHECKED = YES.
    END.    /* generate DataObject */

    RETURN.
END PROCEDURE.  /* changeGeneratedObjects */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObjects sObject 
PROCEDURE generateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButtonPressed              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lRunOnAppserver             AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lRunSilent                  AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE iBrowseLoop                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE rBuffer                     AS RAW                  NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
    
    /* Retrieve all information from the relevant objects */
    DO WITH FRAME {&FRAME-NAME}:
        EMPTY TEMP-TABLE ttObjectInfo.

        IF toGenerateDataFields:CHECKED THEN
            DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "DataField":U).

        IF toGenerateDataObjects:CHECKED THEN
            DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "DataObject":U).

        IF toGenerateBrowses:CHECKED THEN
            DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Browse":U).
                   
        IF toGenerateViewers:CHECKED THEN
            DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Viewer":U).

        /* Get header information. */
        DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Header":U).
    END.    /* with frame ... */

    /* Validate what we can. */
    ASSIGN hBuffer = ghQuery:GET-BUFFER-HANDLE(1).

    IF ghBrowse:NUM-SELECTED-ROWS EQ 0 THEN
    DO:
        RUN showMessages IN gshSessionManager (INPUT  "At least one table or object should be selected.",    /* message to display */
                                               INPUT  "ERR",          /* error type */
                                               INPUT  "&OK",    /* button list */
                                               INPUT  "&OK",           /* default button */ 
                                               INPUT  "&OK",       /* cancel button */
                                               INPUT  "Data selection error",             /* error window title */
                                               INPUT  YES,              /* display if empty */ 
                                               INPUT  ghContainerSource,                /* container handle */
                                               OUTPUT cButtonPressed       ).    /* button pressed */
        RETURN ERROR.
    END.    /* no rows selected */
    ELSE
    DO iBrowseLoop = 1 TO ghBrowse:NUM-SELECTED-ROWS:
        ghBrowse:FETCH-SELECTED-ROW(iBrowseLoop).
        ghQuery:GET-CURRENT().

        CREATE ttObjectInfo.
        ASSIGN ttObjectInfo.tObjectType     = "BROWSE-DATA":U
               ttObjectInfo.tTag            = ghBrowse:PRIVATE-DATA
               ttObjectInfo.tPrimaryValue   = hBuffer:BUFFER-FIELD(1):BUFFER-VALUE
               ttObjectInfo.tSecondaryValue = hBUffer:BUFFER-FIELD(2):BUFFER-VALUE
               .
    END.    /* loop through browse */

    /* Perform the generation. */
    ASSIGN lRunOnAppServer = NOT CONNECTED("RTB").

    ASSIGN lRunSilent = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Header":U, INPUT "RUN-SILENT":U)).

    IF NOT lRunSilent THEN
    DO:
        /* Change to the 'Logging' Page */
        RUN selectPage IN ghContainerSource ( INPUT 6 ).

        PUBLISH "listenForLogMessages":U FROM ghContainerSource.
        ASSIGN lRunOnAppserver = NO.
    END.    /* not run silent. */

    SESSION:SET-WAIT-STATE("GENERAL":U). 

    { launch.i
        &PLIP         = 'af/app/afgenplipp.p'
        &IProc        = 'generateObjects'
        &PList        = "( INPUT lRunSilent, INPUT  TABLE ttObjectInfo, OUTPUT TABLE ttErrorLog )"
        &OnApps       = lRunOnAppserver
        &AutoKill     = YES        
    }
    SESSION:SET-WAIT-STATE("":U).

    /* Process errors if they have not yet been processed. */
    IF lRunSilent THEN
    DO:
        PUBLISH "listenForLogMessages":U FROM ghContainerSource.

        FOR EACH ttErrorLog 
                 BY ttErrorLog.tDateLogged
                 BY ttErrorLog.tTimeLogged :
            MESSAGE '[PJ]' {&line-number}  PROGRAM-NAME(1) PROGRAM-NAME(2) SKIP '---->' SKIP 
                    ttErrorLog.tTimeLogged
            SKIP '<----' VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
            RAW-TRANSFER BUFFER ttErrorLog TO FIELD rBuffer.
            PUBLISH "logObjectGeneratorMessage" ( INPUT rBuffer ).
        END.    /* each error log */

        /* Change to the 'Logging' Page */
        RUN selectPage IN ghContainerSource ( INPUT 6 ).
    END.    /* process errors. */

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
    RUN SUPER.

    /* Move the Generate Button. */
    ASSIGN buGenerate:ROW IN FRAME {&FRAME-NAME} = toGenerateBrowses:ROW IN FRAME {&FRAME-NAME} 
           NO-ERROR.

    PUBLISH "getHeaderInfoBuffer":U FROM ghContainerSource ( OUTPUT ghHeaderInfoBuffer ).

    RUN buildBrowse.

    /** Initialise the tab pages based on the toggle settings
     *  ----------------------------------------------------------------------- **/
    ASSIGN toGenerateDataObjects:CHECKED IN FRAME {&FRAME-NAME} = YES.
    APPLY "VALUE-CHANGED" TO toGenerateDataObjects.
    DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT "4,5":U).

    SUBSCRIBE "queryBasisChange" IN ghContainerSource.

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
    DEFINE INPUT PARAMETER pcDataBasedOn        AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cDatabaseName           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cProductModuleCode      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cProductModulePath      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hBrowseDataBuffer       AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBrowseDataTable        AS HANDLE                   NO-UNDO.

    IF pcDataBasedOn NE ghBrowse:PRIVATE-DATA THEN
    DO:
        SESSION:SET-WAIT-STATE("GENERAL":U). 
        IF VALID-HANDLE(ghBrowseDataTable) THEN
        DO:
            DELETE OBJECT ghBrowseDataTable NO-ERROR.
            ASSIGN ghBrowseDataTable = ?.
        END.    /* valid browse data table. */

        /* Get the information we need */
        IF pcDataBasedOn EQ "SCHEMA":U THEN        
            PUBLISH "getSelectedDatabase":U FROM ghContainerSource ( OUTPUT cDatabaseName ).            
        ELSE
            PUBLISH "getDefaultModuleInfo":U FROM ghContainerSource ( OUTPUT cProductModuleCode ).

        ASSIGN ghBrowse:PRIVATE-DATA = pcDataBasedOn.

        { launch.i
            &PLIP         = 'af/app/afgenplipp.p'
            &IProc        = 'retrieveBrowseData'
            &PList        = "( INPUT  pcDataBasedOn,
                               INPUT  cDatabaseName,
                               INPUT  cProductModuleCode,
                               OUTPUT TABLE-HANDLE hBrowseDataTable )"
            &AutoKill     = YES            
        }
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        DO:
            SESSION:SET-WAIT-STATE("":U).
            RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE,                     /* message to display */
                                                   INPUT  "ERR",                            /* error type */
                                                   INPUT  "&OK",                            /* button list */
                                                   INPUT  "&OK",                            /* default button */ 
                                                   INPUT  "&OK",                            /* cancel button */
                                                   INPUT  "Data retrieval error", /* error window title */
                                                   INPUT  YES,                              /* display if empty */ 
                                                   INPUT  ghContainerSource,                /* container handle */ 
                                                   OUTPUT cButtonPressed           ).
            RETURN ERROR.
        END.    /* error */

        ASSIGN hBrowseDataBuffer = hBrowseDataTable:DEFAULT-BUFFER-HANDLE
               ghBrowseDataTable = hBrowseDataTable
               NO-ERROR.

        IF VALID-HANDLE(hBrowseDataBuffer) THEN
        DO:
            /* Set the query */
            IF VALID-HANDLE(ghQuery) AND
               ghQuery:IS-OPEN       THEN
                ghQuery:QUERY-CLOSE().
            ELSE
                CREATE QUERY ghQuery.
            
            ghQuery:SET-BUFFERS(hBrowseDataBuffer).
    
            ghQuery:QUERY-PREPARE(" FOR EACH ":U + hBrowseDataBuffer:NAME ).
            ASSIGN ghBrowse:QUERY = ghQuery.
    
            /* Create the relevant columns in the browse. */        
            ghBrowse:ADD-COLUMNS-FROM(hBrowseDataBuffer).
    
            ghQuery:QUERY-OPEN().

            /* Sensitise the browse */
            ASSIGN ghBrowse:SENSITIVE = YES.
        END.    /* valid buffer */

        SESSION:SET-WAIT-STATE("":U).
    END.    /* basis has changed. */   

    RETURN.
END PROCEDURE.  /* populateBrowse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryBasisChange sObject 
PROCEDURE queryBasisChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcWhatChanged        AS CHARACTER            NO-UNDO.

    IF ( pcWhatChanged EQ "DATABASE" AND ghBrowse:PRIVATE-DATA EQ "SCHEMA":U ) OR
       ( pcWhatChanged EQ "MODULE"   AND ghBrowse:PRIVATE-DATA EQ "REPOSITORY":U ) THEN
    DO: 
        /* Set the PRIVATE-DATA to "" to force a change. */
        ASSIGN ghBrowse:PRIVATE-DATA = "":U.
        RUN changeGeneratedObjects ( INPUT "toGenerateDataObjects":U,
                                     INPUT toGenerateDataObjects:CHECKED IN FRAME {&FRAME-NAME}).
    END.

    RETURN.
END PROCEDURE.

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

    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE           = TRUE
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS

           FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdNewHeight
           FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdNewWidth
           NO-ERROR.

    ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS
           FRAME {&FRAME-NAME}:SCROLLABLE           = FALSE
           .
    IF VALID-HANDLE(ghBrowse) THEN
        ASSIGN ghBrowse:HEIGHT-CHARS = pdNewHeight - ghBrowse:ROW - 1
               ghBrowse:WIDTH-CHARS  = pdNewWidth - ghBRowse:COLUMN - 1
               NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createObjectInformation sObject 
FUNCTION createObjectInformation RETURNS LOGICAL
    ( INPUT pcObjectType    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE hFrame                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hWidget                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cPublishEvent           AS CHARACTER                NO-UNDO.

    ASSIGN cPublishEvent = "get":U + pcObjectType + "Frame":U.
    
    PUBLISH cPublishEvent FROM ghContainerSource ( OUTPUT hFrame ).

    IF NOT VALID-HANDLE(hFrame) THEN
        RETURN FALSE.    

    IF pcObjectType NE "Header":U THEN
    DO:
        FIND FIRST ttObjectInfo WHERE
                   ttObjectInfo.tObjectType = "Header":U              AND
                   ttObjectInfo.tTag        = "HEADER-CREATE-OBJECT-TYPES":U
                   NO-ERROR.
        IF NOT AVAILABLE ttObjectINfo THEN
        DO:
            CREATE ttObjectInfo.
            ASSIGN ttObjectInfo.tObjectType   = "Header":U
                   ttObjectInfo.tTag          = "HEADER-CREATE-OBJECT-TYPES":U
                   ttObjectInfo.tPrimaryValue = pcObjectType.
                   .
        END.    /* n/a object info */
        ELSE
            ASSIGN ttObjectInfo.tPrimaryValue = ttObjectInfo.tPrimaryValue + ",":U + pcObjectType.
    END.    /* object type <> header */

    ASSIGN hWidget = hFrame
           hWidget = hWidget:FIRST-CHILD        /* field group */
           hWidget = hWidget:FIRST-CHILD
           .
    DO WHILE VALID-HANDLE(hWidget):
        IF CAN-QUERY(hWidget, "PRIVATE-DATA":U) AND
           CAN-QUERY(hWidget, "SCREEN-VALUE":U) AND
           CAN-QUERY(hWidget, "SENSITIVE":U)    AND
           hWidget:SENSITIVE                    AND
           hWidget:PRIVATE-DATA         NE "":U AND
           hWidget:PRIVATE-DATA         NE ?    THEN
        DO:
            CREATE ttObjectInfo.
            ASSIGN ttObjectInfo.tObjectType   = pcObjectType
                   ttObjectInfo.tTag          = CAPS(pcObjectType) + "-":U + hWidget:PRIVATE-DATA
                   ttObjectInfo.tPrimaryValue = hWidget:SCREEN-VALUE
                   .
        END.    /* can get information */

        ASSIGN hWidget = hWidget:NEXT-SIBLING.
    END.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInfoValue sObject 
FUNCTION getObjectInfoValue RETURNS CHARACTER
    ( INPUT pcObjectType    AS CHARACTER,
      INPUT pcTag           AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cValue              AS CHARACTER                    NO-UNDO.

    FIND FIRST ttObjectInfo WHERE
               ttObjectInfo.tObjectType = pcObjectType AND
               ttObjectInfo.tTag        = CAPS(pcObjectType) + "-":U + pcTag
               NO-ERROR.
    IF AVAILABLE ttObjectInfo THEN
        ASSIGN cValue = ttObjectInfo.tPrimaryValue.
    ELSE
        ASSIGN cValue = ?.

    RETURN cValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

