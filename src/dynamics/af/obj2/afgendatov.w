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
  File: afgendatov.w

  Description:  Object Generator DataObject Viewer

  Purpose:      Object Generator DataObject Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/02/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:           9   UserRef:    
                Date:   02/14/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579:
                Added support for use of RTB workspace root directory.

  (v:010002)    Task:          18   UserRef:    
                Date:   02/28/2003  Author:     Thomas Hansen

  Update Notes: Issue 3533:
                Issue 8579:
                Removed dependencies on RTB variables.
                
                Changed code to use new getSessionRootDirectory API

-------------------------------------------------------------------------------*/
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

&scop object-name       afgendatov.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource                       AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghHeaderInfoBuffer                      AS HANDLE                   NO-UNDO.

DEFINE VARIABLE gcOldProdMod AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS toMandatory fiRootFolder buLookupDirectory ~
toCreateMissing coDataObjectObjectType coProductModule fiDORelativePath ~
fiSDOSuffix coAsPartition toSuppressAll raFieldSequence toFollowJoins ~
coDataLogicObjectType coLPProductModule fiLPRelativePath fiLPSuffix ~
fiLPTemplateName fiDOLabel fiLPLabel toIndex RECT-12 RECT-13 RECT-15 
&Scoped-Define DISPLAYED-OBJECTS toMandatory fiRootFolder toCreateMissing ~
coDataObjectObjectType coProductModule fiDORelativePath fiSDOSuffix ~
coAsPartition toSuppressAll raFieldSequence toFollowJoins fiFollowDepth ~
coDataLogicObjectType coLPProductModule fiLPRelativePath fiLPSuffix ~
fiLPTemplateName fiDOLabel fiLPLabel toIndex 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buLookupDirectory 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.4 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE coAsPartition AS CHARACTER FORMAT "X(256)":U 
     LABEL "Appserver partition" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The Appserver partition to be used for the Data Object" NO-UNDO.

DEFINE VARIABLE coDataLogicObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the DataLogic Procedure Objects belong." NO-UNDO.

DEFINE VARIABLE coDataObjectObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The class to which the Data Objects belong." NO-UNDO.

DEFINE VARIABLE coLPProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the DataLogic Procedure Objects will be created." NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 TOOLTIP "The product module in which the Data Objects will be created." NO-UNDO.

DEFINE VARIABLE fiDOLabel AS CHARACTER FORMAT "X(70)":U INITIAL "DataObject" 
      VIEW-AS TEXT 
     SIZE 12.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiDORelativePath AS CHARACTER FORMAT "X(35)":U 
     LABEL "Relative path" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The path to the root directory where the DataObject Include is to be stored" NO-UNDO.

DEFINE VARIABLE fiFollowDepth AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Follow depth" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "If follow joins is checked will allow to specify the depth to follow joins" NO-UNDO.

DEFINE VARIABLE fiLPLabel AS CHARACTER FORMAT "X(70)":U INITIAL "DataLogic procedure" 
      VIEW-AS TEXT 
     SIZE 22.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiLPRelativePath AS CHARACTER FORMAT "X(35)":U 
     LABEL "Relative path" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The path to the root directory where the Logic procedure is to be stored" NO-UNDO.

DEFINE VARIABLE fiLPSuffix AS CHARACTER FORMAT "X(35)":U 
     LABEL "Name suffix" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "This suffix is used with the table entity to create the Logic Procedure name" NO-UNDO.

DEFINE VARIABLE fiLPTemplateName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Template" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "The name of a data logic procedure to be used as a template." NO-UNDO.

DEFINE VARIABLE fiRootFolder AS CHARACTER FORMAT "X(70)":U 
     LABEL "Root folder" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 TOOLTIP "The root directory for any static objects to be created on the server." NO-UNDO.

DEFINE VARIABLE fiSDOSuffix AS CHARACTER FORMAT "X(35)":U 
     LABEL "Name suffix" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 TOOLTIP "This suffix is used with the table entity to create the Data Object name" NO-UNDO.

DEFINE VARIABLE raFieldSequence AS CHARACTER INITIAL "NAME" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "By order", "ORDER",
"By field name", "NAME"
     SIZE 45 BY .81 TOOLTIP "Specifies the field order in the DataObject" NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 138 BY 6.05.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 138 BY 5.95.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.8 BY 2.29.

DEFINE VARIABLE toCreateMissing AS LOGICAL INITIAL no 
     LABEL "Create missing folders relative to the root directory ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 53.6 BY .81 TOOLTIP "Create any folder relative to the root directory?" NO-UNDO.

DEFINE VARIABLE toFollowJoins AS LOGICAL INITIAL no 
     LABEL "Follow &joins" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.4 BY .81 TOOLTIP "Check to automatically follow joins to related tables" NO-UNDO.

DEFINE VARIABLE toIndex AS LOGICAL INITIAL yes 
     LABEL "Index membership" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.8 BY .81 NO-UNDO.

DEFINE VARIABLE toMandatory AS LOGICAL INITIAL yes 
     LABEL "Mandatory fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 NO-UNDO.

DEFINE VARIABLE toSuppressAll AS LOGICAL INITIAL yes 
     LABEL "Suppress all &validation" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .81 TOOLTIP "Check to suppress all validation in the DataObject" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     toMandatory AT ROW 10.14 COL 89.8
     fiRootFolder AT ROW 1.05 COL 23.2 COLON-ALIGNED
     buLookupDirectory AT ROW 1.1 COL 81.4
     toCreateMissing AT ROW 1.24 COL 87.4
     coDataObjectObjectType AT ROW 2.76 COL 23 COLON-ALIGNED
     coProductModule AT ROW 3.81 COL 23 COLON-ALIGNED
     fiDORelativePath AT ROW 4.86 COL 23 COLON-ALIGNED
     fiSDOSuffix AT ROW 5.91 COL 23 COLON-ALIGNED
     coAsPartition AT ROW 6.95 COL 23 COLON-ALIGNED
     toSuppressAll AT ROW 3.71 COL 89.8
     raFieldSequence AT ROW 2.95 COL 89.8 NO-LABEL
     toFollowJoins AT ROW 4.43 COL 89.8
     fiFollowDepth AT ROW 5.24 COL 87.8 COLON-ALIGNED
     coDataLogicObjectType AT ROW 9.38 COL 23 COLON-ALIGNED
     coLPProductModule AT ROW 10.43 COL 23 COLON-ALIGNED
     fiLPRelativePath AT ROW 11.48 COL 23 COLON-ALIGNED
     fiLPSuffix AT ROW 12.52 COL 23 COLON-ALIGNED
     fiLPTemplateName AT ROW 13.57 COL 23 COLON-ALIGNED
     fiDOLabel AT ROW 2.14 COL 6.6 COLON-ALIGNED NO-LABEL
     fiLPLabel AT ROW 8.57 COL 6.6 COLON-ALIGNED NO-LABEL
     toIndex AT ROW 10.95 COL 89.8
     RECT-12 AT ROW 8.91 COL 3
     RECT-13 AT ROW 2.48 COL 3
     RECT-15 AT ROW 9.57 COL 85
     "Field sequence:" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 3.1 COL 73.6
     " Validation based on:" VIEW-AS TEXT
          SIZE 22.6 BY .95 AT ROW 9.24 COL 86.4
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
         HEIGHT             = 14.33
         WIDTH              = 141.6.
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
       coAsPartition:PRIVATE-DATA IN FRAME frMain     = 
                "AS-PARTITION".

ASSIGN 
       coDataLogicObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "LP-OBJECT-TYPE".

ASSIGN 
       coDataObjectObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "OBJECT-TYPE".

ASSIGN 
       coLPProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "LP-MODULE".

ASSIGN 
       coProductModule:PRIVATE-DATA IN FRAME frMain     = 
                "MODULE".

ASSIGN 
       fiDORelativePath:PRIVATE-DATA IN FRAME frMain     = 
                "PATH".

/* SETTINGS FOR FILL-IN fiFollowDepth IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiFollowDepth:PRIVATE-DATA IN FRAME frMain     = 
                "FOLLOW-DEPTH".

ASSIGN 
       fiLPRelativePath:PRIVATE-DATA IN FRAME frMain     = 
                "LP-PATH".

ASSIGN 
       fiLPSuffix:PRIVATE-DATA IN FRAME frMain     = 
                "LP-SUFFIX".

ASSIGN 
       fiLPTemplateName:PRIVATE-DATA IN FRAME frMain     = 
                "LP-TEMPLATE".

ASSIGN 
       fiRootFolder:PRIVATE-DATA IN FRAME frMain     = 
                "ROOT-FOLDER".

ASSIGN 
       fiSDOSuffix:PRIVATE-DATA IN FRAME frMain     = 
                "SUFFIX".

ASSIGN 
       raFieldSequence:PRIVATE-DATA IN FRAME frMain     = 
                "FIELD-SEQUENCE".

ASSIGN 
       toCreateMissing:PRIVATE-DATA IN FRAME frMain     = 
                "CREATE-MISSING-FOLDER".

ASSIGN 
       toFollowJoins:PRIVATE-DATA IN FRAME frMain     = 
                "FOLLOW-JOINS".

ASSIGN 
       toIndex:PRIVATE-DATA IN FRAME frMain     = 
                "VALIDATE-FROM-INDEX".

ASSIGN 
       toMandatory:PRIVATE-DATA IN FRAME frMain     = 
                "VALIDATE-FROM-MANDATORY".

ASSIGN 
       toSuppressAll:PRIVATE-DATA IN FRAME frMain     = 
                "SUPPRESS-VALIDATION".

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

&Scoped-define SELF-NAME buLookupDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupDirectory sObject
ON CHOOSE OF buLookupDirectory IN FRAME frMain /* ... */
DO:

  DEFINE VARIABLE cFolderName         AS CHARACTER            NO-UNDO.

  ASSIGN
    cFolderName = fiRootFolder:SCREEN-VALUE.

  RUN getFolderName ( INPUT-OUTPUT cFolderName ) NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN
    ASSIGN
      SELF:SENSITIVE = NO.
  ELSE
    ASSIGN
      fiRootFolder:SCREEN-VALUE = cFolderName.

  APPLY "LEAVE":U TO fiRootFolder.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLPProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLPProductModule sObject
ON VALUE-CHANGED OF coLPProductModule IN FRAME frMain /* Product module */
DO:
    ghHeaderInfoBuffer:FIND-FIRST(" WHERE ttHeaderInfo.tName = '":U + SELF:SCREEN-VALUE + "' AND ":U
                                  + " ttHeaderInfo.tType = 'MODULE' ":U ) NO-ERROR.
    IF ghHeaderInfoBuffer:AVAILABLE THEN
        ASSIGN fiLPRelativePath:SCREEN-VALUE = ENTRY(1, ghHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule sObject
ON VALUE-CHANGED OF coProductModule IN FRAME frMain /* Product module */
DO:
    ghHeaderInfoBuffer:FIND-FIRST(" WHERE ttHeaderInfo.tName = '":U + SELF:SCREEN-VALUE + "' AND ":U
                                  + " ttHeaderInfo.tType = 'MODULE' ":U ) NO-ERROR.
    IF ghHeaderInfoBuffer:AVAILABLE THEN
        ASSIGN fiDORelativePath:SCREEN-VALUE = ENTRY(1, ghHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)).
    IF gcOldProdMod = coLPProductModule:SCREEN-VALUE OR
       gcOldProdMod = "":U THEN DO:
      PUBLISH "ProductModuleChanged":U FROM ghContainerSource (INPUT gcOldProdMod, INPUT coProductModule:SCREEN-VALUE).
      ASSIGN coLPProductModule:SCREEN-VALUE = coProductModule:SCREEN-VALUE.
     APPLY "VALUE-CHANGED":U TO coLPProductModule.
    END.
    gcOldProdMod = coProductModule:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRootFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootFolder sObject
ON LEAVE OF fiRootFolder IN FRAME frMain /* Root folder */
DO:
    DEFINE VARIABLE cFileType           AS CHARACTER                    NO-UNDO.

    ASSIGN cFileType = DYNAMIC-FUNCTION("detectFileType":U, INPUT fiRootFOlder:SCREEN-VALUE).

    IF CAN-DO("D,X":U, cFileType) THEN
        ASSIGN fiRootFOlder:SCREEN-VALUE = TRIM(REPLACE(fiRootFOlder:SCREEN-VALUE,"~\":U,"/":U),"/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toFollowJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toFollowJoins sObject
ON VALUE-CHANGED OF toFollowJoins IN FRAME frMain /* Follow joins */
DO:

  ASSIGN
    toFollowJoins.
  
  IF toFollowJoins
  THEN DO:
    ASSIGN
      fiFollowDepth:SENSITIVE = YES.
    ENABLE
      fiFollowDepth.
  END.
  ELSE DO:
    ASSIGN
      fiFollowDepth:SENSITIVE = NO.
    DISABLE
      fiFollowDepth.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataObjectFrame sObject 
PROCEDURE getDataObjectFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phFrame                 AS HANDLE           NO-UNDO.

    ASSIGN phFrame = FRAME {&FRAME-NAME}:HANDLE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolderName sObject 
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
    RUN showMessages IN gshSessionManager
                    (INPUT  {aferrortxt.i 'AF' '40' '?' '?' "cErrorText" }
                    ,INPUT  "ERR"                                /* error type */
                    ,INPUT  "&OK"                                /* button list */
                    ,INPUT  "&OK"                                /* default button */ 
                    ,INPUT  "&OK"                                /* cancel button */
                    ,INPUT  "Error Creating Automation Server"   /* error window title */
                    ,INPUT  YES                                  /* display if empty */
                    ,INPUT  ?                                    /* container handle */ 
                    ,OUTPUT cButtonPressed                       /* button pressed */
                    ).
    RETURN.

  END.  /* Error. */

  ASSIGN
    hFolder = hServer:BrowseForFolder(CURRENT-WINDOW:HWND, "Select a folder to act as the root for any static objects generated", 0).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProductModuleCode          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFileType                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cValidateFrom               AS CHARACTER            NO-UNDO.
    
    RUN SUPER.

    DO WITH FRAME {&FRAME-NAME}:
        /* Clear the combo. */
        ASSIGN coProductModule:LIST-ITEM-PAIRS   = coProductModule:SCREEN-VALUE
               coLpProductModule:LIST-ITEM-PAIRS = coLpProductModule:SCREEN-VALUE
               .
        PUBLISH "getHeaderInfoBuffer" FROM ghContainerSource ( OUTPUT ghHeaderInfoBuffer ).

        IF VALID-HANDLE(ghHeaderInfoBuffer) THEN
        DO:
            CREATE WIDGET-POOL "initializeObject":U.

            CREATE QUERY hQuery IN WIDGET-POOL "initializeObject":U.
            hQuery:ADD-BUFFER(ghHeaderInfoBuffer).

            hQuery:QUERY-PREPARE(" FOR EACH ttHeaderInfo WHERE ttHeaderInfo.tType = 'MODULE' AND ttHeaderInfo.tDisplayRecord ":U).
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST().
            DO WHILE ghHeaderInfoBuffer:AVAILABLE:
                ASSIGN cLabel = ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE + " ( ":U + ENTRY(2, ghHeaderInfoBuffer:BUFFER-FIELD("tExtraInfo":U):BUFFER-VALUE, CHR(1)) + " )":U
                       cValue = ghHeaderInfoBuffer:BUFFER-FIELD("tName":U):BUFFER-VALUE
                       .
                coProductModule:ADD-LAST(cLabel, cValue).

                hQuery:GET-NEXT().
            END.    /* available headerinfo */
            hQuery:QUERY-CLOSE().

            DELETE WIDGET-POOL "initializeObject":U.

            ASSIGN coLpProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS
                   coProductModule:SCREEN-VALUE      = coProductModule:ENTRY(1)
                   coLpProductModule:SCREEN-VALUE    = coLpProductModule:ENTRY(1)
                   gcOldProdMod                      = coProductModule:SCREEN-VALUE
                   NO-ERROR.
        END.    /* valid buffer handle */

        /* Set to the default value. */
        PUBLISH "getDefaultModuleInfo":U FROM ghContainerSource ( OUTPUT cProductModuleCode ).

        ASSIGN coProductModule:SCREEN-VALUE = cProductModuleCode NO-ERROR.
        
        ASSIGN coAsPartition:LIST-ITEMS = REPLACE(DYNAMIC-FUNCTION("getServiceList":U IN THIS-PROCEDURE, INPUT "AppServer":U),CHR(3),",":U).
        coASPartition:ADD-FIRST("<None>").
        ASSIGN coAsPartition:SCREEN-VALUE = coAsPartition:ENTRY(1).

        ASSIGN 
          fiRootFolder = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE) NO-ERROR
          .
        
        ASSIGN fiRootFolder:SCREEN-VALUE     = fiRootFolder
               fiSDOSuffix:SCREEN-VALUE      = "fullo":U
               fiLPSuffix:SCREEN-VALUE       = "logcp.p":U
               fiLPTemplateName:SCREEN-VALUE = "ry/obj/rytemlogic.p":U
               toSuppressAll                 = YES
               toSuppressAll:CHECKED         = YES
               toFollowJoins                 = YES
               toFollowJoins:CHECKED         = YES
               fiFollowDepth:SCREEN-VALUE    = "0":U
               fiFollowDepth:SENSITIVE       = YES
               toCreateMissing               = YES
               toCreateMissing:CHECKED       = YES
               fiDOLabel:SCREEN-VALUE        = " DataObject "
               fiDOLabel:WIDTH-CHARS         = FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiDOLabel:SCREEN-VALUE, fiDOLabel:FONT) + 0.5
               fiLpLabel:SCREEN-VALUE        = " DataLogic Procedure "
               fiLpLabel:WIDTH-CHARS         = FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiLpLabel:SCREEN-VALUE, fiLpLabel:FONT) + 0.5
               NO-ERROR.

        ASSIGN cFileType = DYNAMIC-FUNCTION("detectFileType":U, INPUT fiRootFolder:SCREEN-VALUE).
        IF CAN-DO("D,X":U, cFileType) THEN
            ASSIGN fiRootFolder:SCREEN-VALUE = TRIM(REPLACE(fiRootFolder:SCREEN-VALUE,"~\":U,"/":U),"/":U).

        /* Make sure that the relevant object types are cached. */
        RUN createClassCache IN gshRepositoryManager ( INPUT "DynSDO,DlProc":U ).

        /* Get the object type */
        ASSIGN
          coDataObjectObjectType:LIST-ITEMS  = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynSDO":U),CHR(3),",":U)
          coDataLogicObjectType:LIST-ITEMS   = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DlProc":U),CHR(3),",":U)
          NO-ERROR.

        IF coDataObjectObjectType:LIST-ITEMS = "":U
        OR coDataObjectObjectType:LIST-ITEMS = ?
        THEN ASSIGN coDataObjectObjectType:LIST-ITEMS = "DynSDO":U.
        IF coDataLogicObjectType:LIST-ITEMS  = "":U
        OR coDataLogicObjectType:LIST-ITEMS  = ?
        THEN ASSIGN coDataLogicObjectType:LIST-ITEMS  = "DlProc":U.

        ASSIGN
          coDataObjectObjectType:SCREEN-VALUE = coDataObjectObjectType:ENTRY(1)
          coDataLogicObjectType:SCREEN-VALUE  = coDataLogicObjectType:ENTRY(1)
          NO-ERROR.

        ASSIGN cValidateFrom = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                INPUT "OG_ValidateFrom":U).
        IF cValidateFrom NE ? THEN
            ASSIGN toMandatory:CHECKED = CAN-DO(cValidateFrom, "Mandatory":U)
                   toIndex:CHECKED     = CAN-DO(cValidateFrom, "Index":U).           
    END.    /* with frame ... */

    SUBSCRIBE "getDataObjectFrame":U IN ghContainerSource.
    SUBSCRIBE "setPreferences":U IN ghContainerSource.

    APPLY "VALUE-CHANGED":U TO coProductModule IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO coLPProductModule IN FRAME {&FRAME-NAME}.
    RUN setPreferences.
    RETURN.
END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPreferences sObject 
PROCEDURE setPreferences :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE rRowid    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrefData AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOPM    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSuf   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSort  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSDOFlw   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSDOAps   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDLPType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDLPPM    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDLPSuf   AS CHARACTER  NO-UNDO.
  
  /* Get Report Directory */
  ASSIGN rRowid = ?.
  IF VALID-HANDLE(gshProfileManager) THEN
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                           INPUT "Preference":U,      /* Profile code          */
                                           INPUT "GenerateObjects":U, /* Profile data key      */
                                           INPUT "NO":U,              /* Get next record flag  */
                                           INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                           OUTPUT cPrefData).     /* Found profile data.   */
  IF cPrefData <> ? AND
     cPrefData <> "":U THEN DO:
    cSDOType = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_Type":U,cPrefData,TRUE,CHR(3)).
    cSDOPM   = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_PM":U,cPrefData,TRUE,CHR(3)).
    cSDOSuf  = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"OG_SDO_Suf":U,cPrefData,TRUE,CHR(3)).
    cSDOSort = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_Sort":U,cPrefData,TRUE,CHR(3)).
    lSDOFlw  = LOGICAL(DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_Follow":U,cPrefData,TRUE,CHR(3))).
    cSDOAps  = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_ApsPart":U,cPrefData,TRUE,CHR(3)).
    cDLPType = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"DLP_Type":U,cPrefData,TRUE,CHR(3)).
    cDLPPM   = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_DlpPM":U,cPrefData,TRUE,CHR(3)).
    cDLPSuf  = DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"OG_SDO_DLPSuf":U,cPrefData,TRUE,CHR(3)).
    
    DO WITH FRAME {&FRAME-NAME}:
      IF cSDOType <> ? AND
         cSDOType <> "":U THEN
        ASSIGN coDataObjectObjectType = cSDOType
               coDataObjectObjectType:SCREEN-VALUE = cSDOType.
  
      IF cSDOPM <> ? AND
         cSDOPM <> "":U THEN DO:
        ASSIGN coProductModule = cSDOPM
               coProductModule:SCREEN-VALUE = cSDOPM NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coProductModule.
      END.

      IF cSDOSuf <> ? AND 
         cSDOSuf <> "":U THEN
        ASSIGN fiSDOSuffix = cSDOSuf
               fiSDOSuffix:SCREEN-VALUE = cSDOSuf.

      IF cSDOAps <> ? AND 
         cSDOAps <> "":U THEN
        ASSIGN coAsPartition = cSDOAps
               coAsPartition:SCREEN-VALUE = cSDOAps.

      IF cDLPType <> ? AND
         cDLPType <> "":U THEN
        ASSIGN coDataLogicObjectType = cDLPType
               coDataLogicObjectType:SCREEN-VALUE = cDLPType.
  
      IF cDLPPM <> ? AND
         cDLPPM <> "":U THEN DO:
        ASSIGN coLPProductModule = cDLPPM
               coLPProductModule:SCREEN-VALUE = cDLPPM NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coLPProductModule.
      END.

      IF cDLPSuf <> ? AND 
         cDLPSuf <> "":U THEN
        ASSIGN fiLPSuffix = cDLPSuf
               fiLPSuffix:SCREEN-VALUE = cDLPSuf.

      IF cSDOSort <> ? AND
         cSDOSort <> "":U THEN
        ASSIGN raFieldSequence = cSDOSort
               raFieldSequence:SCREEN-VALUE = cSDOSort.
      
      IF lSDOFlw <> ? THEN DO:
        toFollowJoins = lSDOFlw.
        toFollowJoins:CHECKED = lSDOFlw.
        IF toFollowJoins:CHECKED THEN
          ASSIGN fiFollowDepth:SENSITIVE = TRUE.
        ELSE
          ASSIGN fiFollowDepth:SENSITIVE = FALSE.
      END.
    END.

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

