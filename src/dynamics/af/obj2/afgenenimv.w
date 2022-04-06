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
/* Copyright (C) 2005-2007 by Progress Software Corporation. All rights    
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */ 
/*---------------------------------------------------------------------------------
  File: afgenemimv.w

  Description:  Object Generator Entity Import

  Purpose:      Object Generator Entity Import

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/12/2002  Author:     Peter Judge

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

&scop object-name       afgenenimv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttImport      NO-UNDO
    FIELD cDatabase      AS CHARACTER
    FIELD cTable         AS CHARACTER
    FIELD cDumpName      AS CHARACTER
    FIELD cDescription   AS CHARACTER
    FIELD lImport        AS LOGICAL
    .

DEFINE VARIABLE ghToolbarSource                 AS HANDLE               NO-UNDO.
DEFINE VARIABLE ghContainerSource               AS HANDLE               NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType fiPrefixLength ~
fiSeparator ToAuto raAuditing buGenerate 
&Scoped-Define DISPLAYED-OBJECTS coProductModule coObjectType ~
fiPrefixLength fiSeparator ToAuto raAuditing 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buGenerate 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "&Import" 
     SIZE 5.6 BY 1.19 TOOLTIP "Press to start the entity import process."
     BGCOLOR 8 .

DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the DataField Objects belong." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the DataFields will be created." NO-UNDO.

DEFINE VARIABLE fiPrefixLength AS INTEGER FORMAT ">9":U INITIAL 4 
     LABEL "Prefix Length" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Table prefix length or 0 for none, default is 4" NO-UNDO.

DEFINE VARIABLE fiSeparator AS CHARACTER FORMAT "X(5)":U INITIAL "_" 
     LABEL "Field Name Separator" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "Word separation character for field names, default is underscore" NO-UNDO.

DEFINE VARIABLE raAuditing AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Yes", "Y",
"No", "N",
"Ignore", "I"
     SIZE 12 BY 2.29 TOOLTIP "Enable auditing for selected entities" NO-UNDO.

DEFINE VARIABLE ToAuto AS LOGICAL INITIAL yes 
     LABEL "Auto Properform Strings" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 TOOLTIP "Enable properforming of character strings for selected entities" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProductModule AT ROW 1 COL 29 COLON-ALIGNED
     coObjectType AT ROW 2.05 COL 29 COLON-ALIGNED
     fiPrefixLength AT ROW 3.14 COL 29 COLON-ALIGNED
     fiSeparator AT ROW 4.29 COL 29 COLON-ALIGNED
     ToAuto AT ROW 5.33 COL 31
     raAuditing AT ROW 6.29 COL 31 NO-LABEL
     buGenerate AT ROW 7.29 COL 52.2
     "Auditing Enabled:" VIEW-AS TEXT
          SIZE 17.6 BY .76 AT ROW 6.14 COL 13
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
         HEIGHT             = 7.57
         WIDTH              = 78.
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
       coObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "OBJECT-TYPE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "MODULE".

ASSIGN 
       fiPrefixLength:PRIVATE-DATA IN FRAME frMain     = 
                "4".

ASSIGN 
       fiSeparator:PRIVATE-DATA IN FRAME frMain     = 
                "_".

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
ON CHOOSE OF buGenerate IN FRAME frMain /* Import */
DO:
    RUN importEntities NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityFrame sObject 
PROCEDURE getEntityFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phFrame                 AS HANDLE           NO-UNDO.

    ASSIGN phFrame = FRAME {&FRAME-NAME}:HANDLE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getEntityFrame */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importEntities sObject 
PROCEDURE importEntities :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButton             AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cAnswer             AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cError              AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE hContainerSource    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hCaller             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBrowse             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBuffer             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hRDM                AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iRowCount           AS INTEGER                      NO-UNDO.

    {get ContainerSource hContainerSource}.
    {get CallerProcedure hCaller hContainerSource}.
    
    PUBLISH "getBrowseHandle":U FROM hCaller ( OUTPUT hBrowse ).

    IF hBrowse:NUM-SELECTED-ROWS EQ 0 THEN
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '5' '?' '?' '"entity to import"'},
                                               INPUT  "ERR":U,
                                               INPUT  "OK":U,
                                               INPUT  "OK":U,
                                               INPUT  "OK":U,
                                               INPUT  "Entity Import",
                                               INPUT  NOT SESSION:REMOTE,
                                               INPUT  THIS-PROCEDURE,
                                               OUTPUT cButton).
    ELSE
        RUN askQuestion IN gshSessionManager ( INPUT "Do you wish to continue and import entity records for the selected tables and options?":U,
                                               INPUT "&Yes,&No":U,     /* button list */
                                               INPUT "&No":U,         /* default */
                                               INPUT "&No":U,          /* cancel */
                                               INPUT "Continue import":U, /* title */
                                               INPUT "":U,             /* datatype */
                                               INPUT "":U,             /* format */
                                               INPUT-OUTPUT cAnswer,   /* answer */
                                               OUTPUT cButton          /* button pressed */ ).

    IF CAN-DO("&Yes,Yes":U, cButton) THEN
    DO WITH FRAME {&FRAME-NAME}:
        /* The separator should be either blank, a single character or Upper. */
        IF LENGTH(fiSeparator:INPUT-VALUE, "CHARACTER":U) GT 1          AND
           fiSeparator:INPUT-VALUE                        NE "Upper":U  THEN
        DO:            
            RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '5' '?' '?' '"field separator"' '"The field separator should be either blank, a single character or ~~'Upper~~'"'},
                                                   INPUT  "ERR":U,
                                                   INPUT  "OK":U,
                                                   INPUT  "OK":U,
                                                   INPUT  "OK":U,
                                                   INPUT  "Entity Mnemonic Import Complete",
                                                   INPUT  YES,
                                                   INPUT  TARGET-PROCEDURE,
                                                   OUTPUT cButton               ).
            RETURN ERROR.
        END.    /* separator incorrect. */

        SESSION:SET-WAIT-STATE("GENERAL":U). 

        EMPTY TEMP-TABLE ttImport.

        ASSIGN hQuery  = hBrowse:QUERY
               hBuffer = hQuery:GET-BUFFER-HANDLE(1)
               .
        /* Get all the relevant information. */
        DO iRowCount = 1 TO hBrowse:NUM-SELECTED-ROWS:
            hBrowse:FETCH-SELECTED-ROW(iRowCount).
            CREATE ttImport.
            ASSIGN ttImport.cDatabase    = hBuffer:BUFFER-FIELD("tTableDBName":U):BUFFER-VALUE
                   ttImport.cTable       = hBuffer:BUFFER-FIELD("tTableName":U):BUFFER-VALUE
                   ttImport.cDumpName    = hBuffer:BUFFER-FIELD("tTableDump":U):BUFFER-VALUE
                   ttImport.cDescription = hBuffer:BUFFER-FIELD("tTableDesc":U):BUFFER-VALUE
                   ttImport.lImport      = YES.
                   .
        END.    /* get all rows */

        ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "RepositoryDesignManager":U).

        FOR EACH ttImport:
            RUN generateEntityObject IN hRDM ( INPUT (ttImport.cDatabase + CHR(3) + ttImport.cTable),
                                               INPUT coObjectType:SCREEN-VALUE,
                                               INPUT TRIM(ENTRY(1, coProductModule:SCREEN-VALUE, "(":U)),
                                               INPUT toAuto:SCREEN-VALUE,
                                               INPUT fiPrefixLength:SCREEN-VALUE,
                                               INPUT fiSeparator:SCREEN-VALUE,
                                               INPUT raAuditing:SCREEN-VALUE,
                                               INPUT "":U,      /* pcDescFieldQualifiers */
                                               INPUT "":U,      /* pcKeyFieldQualifiers  */
                                               INPUT "":U,      /* pcObjFieldQualifiers  */
                                               INPUT NO,        /* version_data */
                                               INPUT NO,        /* deploy_data */
                                               INPUT NO,        /* reuse_deleted_keys */
                                               INPUT NO         /* plAssociateDataFields   */  ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            DO:
                ASSIGN cError = RETURN-VALUE.
                LEAVE.
            END.    /* error */
        END.    /* each ttImpor t. */
        SESSION:SET-WAIT-STATE("":U).

        IF cError NE "":U THEN        
            RUN showMessages IN gshSessionManager ( INPUT cError,
                                                    INPUT "ERR":U,
                                                    INPUT "OK":U,
                                                    INPUT "OK":U,
                                                    INPUT "OK":U,
                                                    INPUT "Entity Mnemonic Import Failure",
                                                    INPUT YES,
                                                    INPUT ?,
                                                    OUTPUT cButton ).
        PUBLISH "populateBrowse" FROM hCaller.

        /* Kill me. */
        RUN destroyObject IN hContainerSource.
    END.    /* Button is YES */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* importEntities */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hHeaderInfoBuffer           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hCaller                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cCalcFieldChildren          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProductModuleCode          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iNumChild                   AS INTEGER              NO-UNDO.

    RUN SUPER.

    {get ContainerSource ghContainerSource}.
    {get ToolbarSource ghToolbarSource ghContainerSource}.
    {get CallerProcedure hCaller ghContainerSource}.

    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "ProductModuleChanged":U IN hCaller.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiPrefixLength:SCREEN-VALUE = STRING(4)
               fiSeparator:SCREEN-VALUE    = "_":U
               toAuto:CHECKED              = YES
               raAuditing:SCREEN-VALUE     = "I":U.

        /* Clear the combo. */
        ASSIGN coProductModule:LIST-ITEM-PAIRS = coProductModule:SCREEN-VALUE.

        PUBLISH "getHeaderInfoBuffer" FROM hCaller ( OUTPUT hHeaderInfoBuffer ).
    
        IF VALID-HANDLE(hHeaderInfoBuffer) THEN
        DO:
            CREATE WIDGET-POOL "initializeObject":U.
        
            CREATE QUERY hQuery IN WIDGET-POOL "initializeObject":U.
            hQuery:ADD-BUFFER(hHeaderInfoBuffer).
    
            hQuery:QUERY-PREPARE(" FOR EACH ttHeaderInfo WHERE ttHeaderInfo.tType = 'MODULE' AND ttHeaderInfo.tDisplayRecord ":U).
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST().
            DO WHILE hHeaderInfoBuffer:AVAILABLE:
                ASSIGN cLabel = hHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                              + " ( ":U + ENTRY(2, hHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)) + " )":U
                       cValue = hHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                       .
                coProductModule:ADD-LAST(cLabel, cValue).
    
                hQuery:GET-NEXT().
            END.    /* available headerinfo */
            hQuery:QUERY-CLOSE().
            
            DELETE WIDGET-POOL "initializeObject":U.
    
            ASSIGN coProductModule:SCREEN-VALUE = coProductModule:ENTRY(1) NO-ERROR.
        END.    /* valid buffer handle */
    
        /* Set to the default value. */
        PUBLISH "getDefaultModuleInfo":U FROM hCaller ( OUTPUT cProductModuleCode ).

        ASSIGN coProductModule:SCREEN-VALUE = cProductModuleCode NO-ERROR.

        /* Get the object type */
        ASSIGN coObjectType:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "Entity":U)
               NO-ERROR.
        IF coObjectType:LIST-ITEMS EQ "":U OR coObjectType:LIST-ITEMS EQ ? THEN
            ASSIGN coObjectType:LIST-ITEMS = "Entity":U.
        ASSIGN coObjectType:SCREEN-VALUE = coObjectType:ENTRY(1) NO-ERROR.  
    END.    /* with frame ... */

    SUBSCRIBE TO "getEntityFrame":U IN hCaller.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProductModuleChanged sObject 
PROCEDURE ProductModuleChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER        NO-UNDO.

    IF {fn ObjectInitialized} EQ NO THEN
        ASSIGN coProductModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcProductModule.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* ProductModuleChanged */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

