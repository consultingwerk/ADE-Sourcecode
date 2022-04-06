&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
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
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gscemimptv.w

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/02/2002  Author:     

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

&scop object-name       gscemimptv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE gdDbList    AS CHARACTER    NO-UNDO.



/* temp table to store the tables to be imported */
DEFINE TEMP-TABLE ttTable
  FIELD cDatabase      AS CHARACTER
  FIELD cTable         AS CHARACTER
  FIELD cDumpName      AS CHARACTER
  FIELD cDescription   AS CHARACTER
  FIELD lImport        AS LOGICAL.

/* temp table to process the importing of table data */
DEFINE TEMP-TABLE ttImport LIKE ttTable.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttTable

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttTable.cTable   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse   
&Scoped-define SELF-NAME BrBrowse
&Scoped-define QUERY-STRING-BrBrowse PRESELECT EACH ttTable     WHERE ttTable.cDatabase = coDatabase:SCREEN-VALUE
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} PRESELECT EACH ttTable     WHERE ttTable.cDatabase = coDatabase:SCREEN-VALUE.
&Scoped-define TABLES-IN-QUERY-BrBrowse ttTable
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttTable


/* Definitions for FRAME frMain                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frMain ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coDatabase BrBrowse 
&Scoped-Define DISPLAYED-OBJECTS coDatabase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildTableNames sObject 
FUNCTION buildTableNames RETURNS CHARACTER
    ( INPUT pcDatabaseName      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeselectAll 
     LABEL "Deselect A&ll" 
     SIZE 15 BY 1.14 TOOLTIP "Deselect all the current selected tables"
     BGCOLOR 8 .

DEFINE BUTTON buDeSelectOne 
     LABEL "&Deselect" 
     SIZE 15 BY 1.14 TOOLTIP "Mark the currently selected table as deselected"
     BGCOLOR 8 .

DEFINE BUTTON buImport 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "&Import" 
     SIZE 5.2 BY 1.33 TOOLTIP "Import entities with selected options"
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14 TOOLTIP "Select all the current listed tables"
     BGCOLOR 8 .

DEFINE BUTTON buSelectOne 
     LABEL "&Select" 
     SIZE 15 BY 1.14 TOOLTIP "Mark the currently selected table as selected"
     BGCOLOR 8 .

DEFINE VARIABLE coEntityClass AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the Entity Objects belong." NO-UNDO.

DEFINE VARIABLE coEntityProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "<None>","<None>"
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the Entity objects will be created." NO-UNDO.

DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the DataField Objects belong." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "<None>","<None>"
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the DataFields will be created." NO-UNDO.

DEFINE VARIABLE fiPrefixLength AS INTEGER FORMAT ">9":U INITIAL 4 
     LABEL "Prefix length" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 TOOLTIP "Table prefix length or 0 for none, default is 4" NO-UNDO.

DEFINE VARIABLE fiSeparator AS CHARACTER FORMAT "X(5)":U INITIAL "_" 
     LABEL "Field name separator" 
     VIEW-AS FILL-IN 
     SIZE 18.8 BY 1 TOOLTIP "Word separation character for field names, default is underscore" NO-UNDO.

DEFINE VARIABLE raAuditing AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Yes", "Y",
"No", "N",
"Ignore", "I"
     SIZE 12 BY 2.29 TOOLTIP "Enable auditing for selected entities" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74.4 BY 3.71.

DEFINE VARIABLE toAssociateDF AS LOGICAL INITIAL no 
     LABEL "Associate DataFields with entities" 
     VIEW-AS TOGGLE-BOX
     SIZE 40.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToAuto AS LOGICAL INITIAL yes 
     LABEL "Auto properform strings" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 TOOLTIP "Enable properforming of character strings for selected entities" NO-UNDO.

DEFINE VARIABLE toGenerateDataFields AS LOGICAL INITIAL yes 
     LABEL "Generate DataFields" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 TOOLTIP "Update lists of fields for entities to display in generic objects" NO-UNDO.

DEFINE VARIABLE toOverrideWithSchema AS LOGICAL INITIAL no 
     LABEL "Overwrite all attributes from schema" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.8 BY .81 TOOLTIP "Overwrite all local attributes such as Format, Label and Help with schema values" NO-UNDO.

DEFINE VARIABLE coDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 68.2 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttTable SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse sObject _FREEFORM
  QUERY BrBrowse DISPLAY
      ttTable.cTable FORMAT 'x(75)':U LABEL 'Table name':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 80.4 BY 9.05 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coDatabase AT ROW 1.29 COL 11.6 COLON-ALIGNED
     BrBrowse AT ROW 2.62 COL 1.4
     SPACE(0.00) SKIP(14.28)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

DEFINE FRAME frDetails
     buSelectAll AT ROW 1.1 COL 1.4
     buSelectOne AT ROW 1.1 COL 22.6
     buDeSelectOne AT ROW 1.1 COL 44.6
     buDeselectAll AT ROW 1.1 COL 65.6
     fiPrefixLength AT ROW 2.76 COL 21 COLON-ALIGNED
     raAuditing AT ROW 2.76 COL 66.2 NO-LABEL
     fiSeparator AT ROW 3.86 COL 21 COLON-ALIGNED
     ToAuto AT ROW 4.91 COL 23
     toGenerateDataFields AT ROW 5.67 COL 23
     toAssociateDF AT ROW 6.52 COL 26.6
     coEntityProductModule AT ROW 7.43 COL 20.6 COLON-ALIGNED
     coEntityClass AT ROW 8.52 COL 20.6 COLON-ALIGNED
     coProductModule AT ROW 10.24 COL 21 COLON-ALIGNED
     coObjectType AT ROW 11.33 COL 21 COLON-ALIGNED
     toOverrideWithSchema AT ROW 12.43 COL 23.4
     buImport AT ROW 13.57 COL 72.2
     "  DataFields" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 9.67 COL 7.4
     "Auditing enabled:" VIEW-AS TEXT
          SIZE 17.6 BY .76 AT ROW 2.76 COL 48.2
     RECT-1 AT ROW 9.86 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.4 ROW 11.76
         SIZE 80 BY 14.19.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
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
         HEIGHT             = 25.1
         WIDTH              = 81.
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
/* REPARENT FRAME */
ASSIGN FRAME frDetails:FRAME = FRAME frMain:HANDLE.

/* SETTINGS FOR FRAME frDetails
                                                                        */
ASSIGN 
       coEntityClass:PRIVATE-DATA IN FRAME frDetails     = 
                "OBJECT-TYPE".

ASSIGN 
       coEntityProductModule:PRIVATE-DATA IN FRAME frDetails     = 
                "MODULE".

ASSIGN 
       coObjectType:PRIVATE-DATA IN FRAME frDetails     = 
                "OBJECT-TYPE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frDetails     = 
                "MODULE".

ASSIGN 
       fiPrefixLength:PRIVATE-DATA IN FRAME frDetails     = 
                "4".

ASSIGN 
       fiSeparator:PRIVATE-DATA IN FRAME frDetails     = 
                "_".

/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB BrBrowse coDatabase frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} PRESELECT EACH ttTable
    WHERE ttTable.cDatabase = coDatabase:SCREEN-VALUE.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frDetails
/* Query rebuild information for FRAME frDetails
     _Query            is NOT OPENED
*/  /* FRAME frDetails */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define FRAME-NAME frDetails
&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll sObject
ON CHOOSE OF buDeselectAll IN FRAME frDetails /* Deselect All */
DO:
    BROWSE {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeSelectOne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeSelectOne sObject
ON CHOOSE OF buDeSelectOne IN FRAME frDetails /* Deselect */
DO:
  BROWSE {&BROWSE-NAME}:DESELECT-FOCUSED-ROW().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImport sObject
ON CHOOSE OF buImport IN FRAME frDetails /* Import */
DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

    IF BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
    THEN DO:
      RUN showMessages IN gshSessionManager (INPUT {aferrortxt.i 'AF' '5' '?' '?' '"entity to import"'},
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Entity Import",
                                             INPUT NOT SESSION:REMOTE,
                                             INPUT THIS-PROCEDURE,
                                             OUTPUT cButton).
    END.
    ELSE DO:
        RUN askQuestion IN gshSessionManager ( INPUT "Do you wish to continue and import entity records for the selected tables and options?",    /* messages */
                                               INPUT "&Yes,&No":U,     /* button list */
                                               INPUT "&No":U,         /* default */
                                               INPUT "&No":U,          /* cancel */
                                               INPUT "Continue import":U, /* title */
                                               INPUT "":U,             /* datatype */
                                               INPUT "":U,             /* format */
                                               INPUT-OUTPUT cAnswer,   /* answer */
                                               OUTPUT cButton          /* button pressed */ ).
        IF cButton = "&Yes":U OR cButton = "Yes":U THEN
        DO:
            RUN importData NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN NO-APPLY.
        END.    /* import. */
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll sObject
ON CHOOSE OF buSelectAll IN FRAME frDetails /* Select All */
DO:
  BROWSE {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectOne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectOne sObject
ON CHOOSE OF buSelectOne IN FRAME frDetails /* Select */
DO:
  BROWSE {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase sObject
ON VALUE-CHANGED OF coDatabase IN FRAME frMain /* Database */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frDetails
&Scoped-define SELF-NAME toGenerateDataFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toGenerateDataFields sObject
ON VALUE-CHANGED OF toGenerateDataFields IN FRAME frDetails /* Generate DataFields */
DO:
    ASSIGN coProductModule:SENSITIVE = SELF:CHECKED
           coObjectType:SENSITIVE    = SELF:CHECKED
           toAssociateDF:CHECKED     = SELF:CHECKED     WHEN NOT toAssociateDF:CHECKED
           toAssociateDF:SENSITIVE   = NOT SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse
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
  HIDE FRAME frDetails.
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importData sObject 
PROCEDURE importData :
/*------------------------------------------------------------------------------
  Purpose:     Starts the import process on the AppServer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cError          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cTableNames     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iNumSelected    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE hRDM            AS HANDLE       NO-UNDO.

    DO WITH FRAME frDetails:
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

        /* Builds a list of the table names to be imported. */
        ASSIGN cTableNames = DYNAMIC-FUNCTION("buildTableNames":U IN TARGET-PROCEDURE,
                                              INPUT coDatabase:SCREEN-VALUE IN FRAME frMain).

        ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U).
        IF NOT VALID-HANDLE(hRDM) THEN 
            ASSIGN cError = {aferrortxt.i 'AF' '29' '?' '?' '"Repository Design Manager"' '"The handle to the Repository design Manager is invalid. Entity import failed"'}.

        /* First import DataFields */
        IF cError EQ "":U AND toGenerateDataFields:CHECKED THEN
        DO:
            RUN generateDataFields IN hRDM ( INPUT coDatabase:SCREEN-VALUE IN FRAME frMain,             /* pcDataBaseName */
                                             INPUT cTableNames,                                         /* pcTableName */
                                             INPUT TRIM(coProductModule:SCREEN-VALUE),  /* pcProductModuleCode */
                                             INPUT "":U,                            /* pcResultCode */
                                             INPUT NO,                              /* plGenerateFromDataObject */
                                             INPUT "":U,                            /* pcDataObjectFieldList */
                                             INPUT "":U,                            /* pcSdoObjectName */
                                             INPUT coObjectType:SCREEN-VALUE,       /* pcObjectTypeCode  */
                                             INPUT (IF toOverrideWithSchema:CHECKED THEN "*":U ELSE "":U),
                                             INPUT "*":U /* pcFieldNames */  ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                ASSIGN cError = RETURN-VALUE.
        END.    /* Display datafields */
        
        IF cError EQ "":U THEN
        DO:
            RUN generateEntityObject IN hRDM ( INPUT (coDatabase:SCREEN-VALUE IN FRAME frMain + CHR(3) + cTableNames),
                                               INPUT coEntityClass:SCREEN-VALUE,
                                               INPUT TRIM(coEntityProductModule:SCREEN-VALUE),
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
                                               INPUT toAssociateDF:CHECKED         /* plAssociateDataFields   */  ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                ASSIGN cError = RETURN-VALUE.
        END.    /* Import the Entities */

        /* Lastly, refresh the Repository cache, so the new entities are available to the session.
         * The entity menmonic cache is dependant on the REpository cache.                        */
        IF cError EQ "":U THEN
            RUN clearClientCache IN gshRepositoryManager.            

        SESSION:SET-WAIT-STATE("":U).

        IF cError EQ "":U THEN
            ASSIGN cError             = "The entity mnemonic import completed successfully.":U
                   ERROR-STATUS:ERROR = NO.
        ELSE
            ASSIGN ERROR-STATUS:ERROR = YES.

        RUN showMessages IN gshSessionManager (INPUT  cError,
                                               INPUT  (IF ERROR-STATUS:ERROR THEN "ERR":U ELSE "MES":U),
                                               INPUT  "&OK":U,
                                               INPUT  "&OK":U,
                                               INPUT  "&OK":U,
                                               INPUT  "Entity Mnemonic Import ":U,
                                               INPUT  YES,
                                               INPUT  TARGET-PROCEDURE,
                                               OUTPUT cButton           ).

        /* Reset the flags on the temp-table. */
        FOR EACH ttTable:
            ASSIGN ttTable.lImport = NO.
        END.    /* each table */
    END.  /* do with with frame */ 

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* importData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData sObject 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     Gets the list of connected databases (on the AppServer) and tables
               for those database 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDisplayRepository      AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cAllChildren            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cCalcFieldChildren      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDBList                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cMessage                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hRDM                    AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iNumChild               AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cCurrentPM              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iDBNum                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iListLoop               AS INTEGER                  NO-UNDO.

    EMPTY TEMP-TABLE ttTable.

    /* Display Repository?  */
    /* If we do not have an active session filter set, it means we want to see all repository objects */
    lDisplayRepository = ({fn getSessionFilterSet gshGenManager} = "":U).

    /* We only run this procedure locally, as we don't support Appserver databases from the client */
    RUN gscemrddbp.p ( INPUT  lDisplayRepository,
                       OUTPUT cDBList,
                       OUTPUT TABLE ttTable) NO-ERROR.

    /* If the database list comes back blank (and it may if preferences are set to not see repository
       data and no other databases are connected) then we inform the user and exit */

    IF cDBList = "":U 
    THEN DO:
        ASSIGN cMessage = "There are no connected databases from which to import data.".
        IF SESSION <> gshAstraAppserver THEN
            ASSIGN cMessage = cMessage
                            + "  Please note that only client database connections are supported.  "
                            + "Databases connected on the Appserver are not available for import.".

        RUN showMessages IN gshSessionManager (INPUT cMessage,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Entity Mnemonic Import Failure",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        RETURN "EXIT":U.
    END.  /* if DBList is blank */

    IF NUM-ENTRIES(cDBList) > 1 THEN
       iDBNum = 2.
    ELSE
       iDBNum = 1.
    blkDbLoop:
    DO iListLoop = 1 TO NUM-ENTRIES(cDBList):
      IF ENTRY(iListLoop, cDBList) = "ICFDB":U
      OR ENTRY(iListLoop, cDBList) = "TEMP-DB":U
      THEN
        NEXT blkDbLoop.
      ELSE DO:
        ASSIGN
          iDBNum = iListLoop.
      END.
    END.

    DO WITH FRAME frMain:
        ASSIGN coDatabase:LIST-ITEMS   = cDBList
               coDatabase:SCREEN-VALUE = coDatabase:ENTRY(iDBNum)
               raAuditing:SCREEN-VALUE IN FRAME frDetails = "I":U
               .
        /* Get the object type */
        ASSIGN cAllChildren             = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField,Entity":U)
               coObjectType:LIST-ITEMS  = ENTRY(1, cAllChildren, CHR(3))
               coEntityClass:LIST-ITEMS = ENTRY(2, cAllChildren, CHR(3))
               NO-ERROR.
        /* Calculated fields should not be included in the list of object types
           for import.  This is a temporary fix that should be removed once
           CalculatedFields are changed to be siblings of DataFields rather
           than children of DataFields. */
        cCalcFieldChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "CalculatedField":U).
        DO iNumChild = 1 TO NUM-ENTRIES(cCalcFieldChildren):
          coObjectType:DELETE(ENTRY(iNumChild,cCalcFieldChildren)).
        END.  /* do iNumChild */
        IF coObjectType:LIST-ITEMS = "":U OR coObjectType:LIST-ITEMS = ? THEN
            ASSIGN coObjectType:LIST-ITEMS = "DataField":U.

        IF coEntityClass:LIST-ITEMS = "":U OR coEntityClass:LIST-ITEMS = ? THEN
            ASSIGN coEntityClass:LIST-ITEMS = "Entity":U.
        
        ASSIGN coObjectType:SCREEN-VALUE  = coObjectType:ENTRY(1) 
               coEntityClass:SCREEN-VALUE = coEntityClass:ENTRY(1) 
               NO-ERROR.

        ASSIGN hRdm = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U)
               coProductModule:DELIMITER       = CHR(3)
               coProductModule:LIST-ITEM-PAIRS = DYNAMIC-FUNCTION("getProductModuleList":U IN hRdm,
                                                     INPUT "product_module_Code":U,
                                                     INPUT "product_module_code,product_module_description":U,
                                                     INPUT "&1 // &2":U,
                                                     INPUT CHR(3))  
               cCurrentPM       = DYNAMIC-FUNC("getCurrentProductModule":U IN hRdm) 
               cCurrentPM       = IF INDEX(cCurrentPM,"//":U) > 0 THEN SUBSTRING(cCurrentPM,1,INDEX(cCurrentPM,"//":U) - 1)
                                                        ELSE cCurrentPM
               cCurrentPM       = IF NUM-ENTRIES(coProductModule:LIST-ITEM-PAIRS,CHR(3)) > 1  
                                     AND  (cCurrentPM = "" OR LOOKUP(cCurrentPM, coProductModule:LIST-ITEM-PAIRS,CHR(3)) = 0)
                                  THEN ENTRY(2,coProductModule:LIST-ITEM-PAIRS,CHR(3)) ELSE cCurrentPM                                         
               coProductModule:SCREEN-VALUE            = cCurrentPM
               coEntityProductModule:DELIMITER         = CHR(3)
               coEntityProductModule:LIST-ITEM-PAIRS   = coProductModule:LIST-ITEM-PAIRS
               coEntityProductModule:SCREEN-VALUE      = cCurrentPM
               NO-ERROR.

        {&OPEN-QUERY-{&BROWSE-NAME}}        
    END.    /* with frame ... */

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

    RUN initializeData IN TARGET-PROCEDURE.

    ENABLE ALL WITH FRAME frDetails.
    ASSIGN fiPrefixLength:SCREEN-VALUE  = "4":U
           fiSeparator:SCREEN-VALUE     = "_":U
           toAuto:CHECKED               = TRUE
           toGenerateDataFields:CHECKED = TRUE
           coProductModule:SENSITIVE    = YES
           coObjectType:SENSITIVE       = YES.

    APPLY "VALUE-CHANGED":U TO toGenerateDataFields.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
    
    define variable lHidden     as logical no-undo.
    
    ASSIGN lHidden                                   = FRAME {&FRAME-NAME}:HIDDEN    
           FRAME {&FRAME-NAME}:HIDDEN                = YES
           FRAME {&FRAME-NAME}:SCROLLABLE            = YES
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS  = SESSION:HEIGHT-CHARS
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS   = SESSION:WIDTH-CHARS
           FRAME {&FRAME-NAME}:HEIGHT-CHARS          = pdHeight.
           /* No horizontal resizing supported. */
    
    FRAME frMain:HEIGHT = pdHeight.
    FRAME frDetails:ROW = FRAME frMain:HEIGHT - FRAME frDetails:HEIGHT + 1.
    BROWSE {&BROWSE-NAME}:HEIGHT = FRAME frDetails:ROW - 2.62 - .24.

    ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS = FRAME {&FRAME-NAME}:HEIGHT-CHARS
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS  = FRAME {&FRAME-NAME}:WIDTH-CHARS
           FRAME {&FRAME-NAME}:SCROLLABLE           = NO
           FRAME {&FRAME-NAME}:HIDDEN               = lHidden.
    
    error-status:error = no.
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildTableNames sObject 
FUNCTION buildTableNames RETURNS CHARACTER
    ( INPUT pcDatabaseName      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Builds a list of tables to import.
    Notes: * If less than half are selected, then we build a list of those tables.
             If half or more are selected then we build a list of tables to exclude
             from the import.
           * This is done because we don't want to blow the -TOK parameter.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTableNames             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iNumSelected            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iCountTo                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE lMajoritySelected       AS LOGICAL                  NO-UNDO.

    DEFINE BUFFER importTable   FOR ttTable.

    IF BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS EQ QUERY {&BROWSE-NAME}:NUM-RESULTS THEN
        ASSIGN cTableNames = "*":U.
    ELSE
    DO:
        ASSIGN lMajoritySelected = BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS / QUERY {&BROWSE-NAME}:NUM-RESULTS GE 0.5.

        DO iNumSelected = 1 TO BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS:
            BROWSE {&BROWSE-NAME}:FETCH-SELECTED-ROW(iNumSelected).
            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            ASSIGN ttTable.lImport = YES.
        END.  /* do iNumSelected */

        FOR EACH importTable WHERE
                 importTable.cDatabase = pcDatabaseName:
            IF lMajoritySelected AND NOT importTable.lImport THEN
                ASSIGN cTableNames = cTableNames + "!":U + importTable.cTable + ",":U.
            ELSE
            IF NOT lMajoritySelected AND importTable.lImport THEN
                ASSIGN cTableNames = cTableNames + importTable.cTable + ",":U.
        END.    /* Each importTable. */

        IF lMajoritySelected THEN
            ASSIGN cTableNames = cTableNames + "*":U.
    END.    /* mnore than half selected. */

    ASSIGN cTableNames = RIGHT-TRIM(cTableNames, ",":U).

    RETURN cTableNames.
END FUNCTION.   /* buildTableNames */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

