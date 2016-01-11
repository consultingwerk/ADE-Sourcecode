&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/***********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights      *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/_getwidobjs.w

  Description: Dialog used for the 'Runtime Widget-id assignment tool' to
               get the runtime or design objects, to then be imported in that
               tool.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Marcelo Ferrante

  Created: Jun 13, 2007.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{src/adm2/globals.i}
{src/adm2/tttoolbar.i}
{src/adm2/ttaction.i}
{src/adm2/treettdef.i}
{adecomm/dswid.i}

DEFINE TEMP-TABLE ttStoreAttribute      NO-UNDO
    FIELD tAttributeParent      AS CHARACTER
    FIELD tAttributeParentObj   AS DECIMAL
    FIELD tAttributeLabel       AS CHARACTER
    FIELD tConstantValue        AS LOGICAL      INITIAL NO
    FIELD tCharacterValue       AS CHARACTER
    FIELD tDecimalValue         AS DECIMAL
    FIELD tIntegerValue         AS INTEGER
    FIELD tDateValue            AS DATE
    FIELD tRawValue             AS RAW
    FIELD tLogicalValue         AS LOGICAL
    INDEX idxParent
        tAttributeParent
    INDEX idxObj
        tAttributeParentObj
    .

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pcExcludeObjects AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcXMLFileName    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plAssignGaps     AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsWidgetID.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hProcLibrary  AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcObjectsType AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghDSLibrary   AS HANDLE     NO-UNDO.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brObjects

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttObjectNames

/* Definitions for BROWSE brObjects                                     */
&Scoped-define FIELDS-IN-QUERY-brObjects ttObjectNames.lImport VIEW-AS TOGGLE-BOX ttObjectNames.isStatic ttObjectNames.cName   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjects ttObjectNames.lImport   
&Scoped-define ENABLED-TABLES-IN-QUERY-brObjects ttObjectNames
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brObjects ttObjectNames
&Scoped-define SELF-NAME brObjects
&Scoped-define QUERY-STRING-brObjects FOR EACH ttObjectNames NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brObjects OPEN QUERY {&SELF-NAME} FOR EACH ttObjectNames NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjects ttObjectNames
&Scoped-define FIRST-TABLE-IN-QUERY-brObjects ttObjectNames


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brObjects}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 buGetObjects rsType brObjects Btn_OK ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS rsType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isABRunning Dialog-Frame 
FUNCTION isABRunning RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buGetObjects 
     LABEL "Get Objects" 
     SIZE 14.6 BY 1.14.

DEFINE VARIABLE rsType AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Runtime", "Runtime",
"Design", "Design"
     SIZE 24.2 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brObjects FOR 
      ttObjectNames SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjects Dialog-Frame _FREEFORM
  QUERY brObjects NO-LOCK DISPLAY
      ttObjectNames.lImport COLUMN-LABEL "Add" FORMAT "yes/no":U VIEW-AS TOGGLE-BOX
      ttObjectNames.isStatic COLUMN-LABEL "Static" FORMAT "Yes/No":U
      ttObjectNames.cName COLUMN-LABEL "Name" FORMAT "X(128)":U
ENABLE ttObjectNames.lImport
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 14.05 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     buGetObjects AT ROW 1.29 COL 33.8 WIDGET-ID 202
     rsType AT ROW 1.57 COL 8.2 NO-LABEL WIDGET-ID 206
     brObjects AT ROW 2.81 COL 1 WIDGET-ID 2
     Btn_OK AT ROW 17 COL 1
     Btn_Cancel AT ROW 17 COL 16
     Btn_Help AT ROW 17 COL 40
     RECT-10 AT ROW 1.14 COL 7.4 WIDGET-ID 210
     SPACE(5.60) SKIP(15.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Get Objects"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB brObjects rsType Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjects
/* Query rebuild information for BROWSE brObjects
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttObjectNames NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brObjects */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Get Objects */
DO:
    IF VALID-HANDLE(hProcLibrary) THEN
    DELETE OBJECT hProcLibrary.

    IF VALID-HANDLE(ghDSLibrary) THEN
    DELETE OBJECT ghDSLibrary.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Get Objects */
DO:
IF VALID-HANDLE(hProcLibrary) THEN
DELETE OBJECT hProcLibrary.

IF VALID-HANDLE(ghDSLibrary) THEN
DELETE OBJECT ghDSLibrary.
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
RUN adecomm/_setcurs.p (INPUT "WAIT":U).
IF gcObjectsType = "Design":U THEN
DO:
    RUN getStaticDesignObject IN hProcLibrary (INPUT plAssignGaps, INPUT TABLE ttObjectNames, INPUT-OUTPUT DATASET dsWidgetID BY-REFERENCE).

    FOR EACH ttObjectNames WHERE ttObjectNames.lImport = TRUE AND 
                                 ttObjectNames.isStatic = TRUE:
            DYNAMIC-FUNCTION('setWidgetIDFileName':U IN hProcLibrary, INPUT ttObjectNames.cName, INPUT pcXMLFileName).
    END.

    IF CAN-FIND(FIRST ttObjectNames WHERE ttObjectNames.lImport  = TRUE AND
                                          ttObjectNames.isStatic = FALSE) THEN
       RUN getDynamicDesignObject (INPUT "Design":U).

END. /*IF gcObjectsType = "Design":U THEN*/
ELSE DO:
    IF CAN-FIND(FIRST ttObjectNames WHERE ttObjectNames.lImport  = TRUE AND
                                          ttObjectNames.isStatic = FALSE) THEN
        RUN getDynamicDesignObject (INPUT "Runtime":U).

    FOR EACH ttObjectNames WHERE ttObjectNames.lImport  = TRUE AND
                                 ttObjectNames.isStatic = TRUE:
        RUN getRuntimeObjectDetails (INPUT ttObjectNames.hHandle, INPUT plAssignGaps).
    END.
END.
RUN adecomm/_setcurs.p (INPUT "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGetObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGetObjects Dialog-Frame
ON CHOOSE OF buGetObjects IN FRAME Dialog-Frame /* Get Objects */
DO:
RUN adecomm/_setcurs.p (INPUT "WAIT":U).
EMPTY TEMP-TABLE ttObjectNames.

IF rsType:SCREEN-VALUE = "Design":U THEN
    RUN getDesignObjectNames IN hProcLibrary (INPUT pcExcludeObjects, INPUT-OUTPUT TABLE ttObjectNames).
ELSE
    RUN getRuntimeObjectNames IN ghDSLibrary (INPUT SESSION:FIRST-CHILD, INPUT pcExcludeObjects, INPUT-OUTPUT TABLE ttObjectNames).

{&OPEN-QUERY-{&BROWSE-NAME}}

ASSIGN gcObjectsType = rsType:SCREEN-VALUE.
RUN adecomm/_setcurs.p (INPUT "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjects
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   IF NOT isABRunning() THEN
    rsType:DISABLE("Design":U).

   ELSE
    RUN adeuib/_widfunc.p PERSISTENT SET hProcLibrary.

   RUN adecomm/_dswidfunc.p PERSISTENT SET ghDSLibrary.

   RUN enable_UI.
   WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-getRuntimeObjectDetails) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRuntimeObjectDetails Procedure
PROCEDURE getRuntimeObjectDetails:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject     AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER plAssignGaps AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cFile           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hInstance       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cActions        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldObjectType  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstances      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iInstances      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iInstance       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lIsVisual       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDuplicateNames AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iLastWidgetID   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLastPage       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lChanged        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE xp-assign
{get ObjectType cObjectType phObject}
{get LogicalObjectName cObjectName phObject}
{get ContainerTarget cInstances phObject}.
&UNDEFINE xp-assign

ASSIGN iInstances = NUM-ENTRIES(cInstances).

IF NOT DYNAMIC-FUNCTION('createContainer':U IN ghDSLibrary,
                   INPUT ttObjectNames.cName,
                   INPUT cObjectType,
                   INPUT TRUE,
                   OUTPUT cFile,
                   OUTPUT cPath,
                   INPUT DATASET dsWidgetID BY-REFERENCE)
THEN RETURN.

REPEAT iInstance = 1 TO iInstances:

    ASSIGN hInstance   = WIDGET-HANDLE(ENTRY(iInstance, cInstances))
           lIsVisual   = DYNAMIC-FUNCTION('instanceOf' IN hInstance, INPUT "visual":U) NO-ERROR.

    IF NOT lIsVisual OR lIsVisual = ? THEN
        NEXT.

    DYNAMIC-FUNCTION('createContainerDetails':U IN ghDSLibrary,
        INPUT cFile,
        INPUT cPath,
        INPUT hInstance,
        INPUT "":U,
        INPUT TRUE,
        INPUT plAssignGaps,
        INPUT DATASET dsWidgetID BY-REFERENCE,
        OUTPUT lDuplicateNames,
        OUTPUT iLastPage,
        OUTPUT lChanged,
        INPUT-OUTPUT cActions,
        INPUT-OUTPUT iLastWidgetID,
        INPUT-OUTPUT cOldObjectType).
        
        IF iLastWidgetID > 65535 THEN
            ASSIGN plAssignGaps = FALSE.
END. /*REPEAT iInstance = 1 TO iInstances:*/

/*If we have actions, we have to create them*/
IF cActions NE "" THEN
DO:
    DYNAMIC-FUNCTION('createActions':U IN ghDSLibrary,
        INPUT cFile,
        INPUT cPath,
        INPUT cActions,
        INPUT DATASET dsWidgetID BY-REFERENCE).

    ASSIGN cActions  = "". 
END. /*IF cActions NE "" THEN*/

RETURN.
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY rsType 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-10 buGetObjects rsType brObjects Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDynamicDesignObject Dialog-Frame 
PROCEDURE getDynamicDesignObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectState AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cPropertyNames    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValues   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dObjectId         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cObjectType       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRootNodeCode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPath             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cActions          AS CHARACTER NO-UNDO.
DEFINE VARIABLE iLastPage         AS INTEGER   NO-UNDO.
DEFINE VARIABLE lChanged          AS HANDLE    NO-UNDO.
DEFINE VARIABLE cNodes            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWidgetIDFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dObjectObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hTmp              AS HANDLE     NO-UNDO.

/*Gets all the Dynamic containers in design mode.*/
FOR EACH ttObjectNames WHERE ttObjectNames.lImport  = TRUE AND
                             ttObjectNames.isStatic = FALSE NO-LOCK:

    /*Gets the class name and instanceID for the current container*/
    ASSIGN cPropertyNames = "ClassName,InstanceId,RootNodeCode,WidgetIDFileName":U.
    RUN getInstanceProperties IN gshRepositoryManager (
        INPUT        ttObjectNames.cName,
        INPUT        "", 
        INPUT-OUTPUT cPropertyNames,
              OUTPUT cPropertyValues) NO-ERROR.

    ASSIGN dObjectId     = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, CHR(1)))
           cObjectType   = ENTRY(LOOKUP("ClassName":U, cPropertyNames), cPropertyValues, CHR(1))
           cRootNodeCode = IF CAN-DO(cPropertyNames, "RootNodeCode":U) THEN ENTRY(LOOKUP("RootNodeCode":U, cPropertyNames), cPropertyValues, CHR(1)) ELSE ""
           cWidgetIDFileName = ENTRY(LOOKUP("WidgetIDFileName":U, cPropertyNames), cPropertyValues, CHR(1)).

    IF cWidgetIDFileName = "":U THEN
        ASSIGN cWidgetIDFileName = ttObjectNames.cName + ".xml".

    ASSIGN cRelName = DYNAMIC-FUNCTION('getRelativeName':U IN ghDSLibrary, INPUT pcXMLFileName).

    /*We tell the user if the widgetidFileName stored in the repository is different than the widget-id file name
      being edited in the tool.*/
    IF cWidgetIDFileName NE cRelName THEN    DO:
        /*If we are in design mode, the user is given to the option to update the widget-id file name in the
          repository.*/
        IF pcObjectState = "Design":U THEN
        DO:
            MESSAGE "The WidgetID File Name assigned for the container '" + ttObjectNames.cName + "' is different than the" SKIP
                    "WidgetID file name being edited in this tool." SKIP(1)
                    "Do you want to assign the new WidgetID file Name '" + cRelName + "' to the selected Container?"
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
               TITLE FRAME dialog-frame:TITLE
               UPDATE lOk.

            /*If the user decides to update the widget-id file name, we do it using the 
              Repository Manager API.*/
            IF lOk THEN
            DO:
                CREATE ttStoreAttribute.
                ASSIGN dObjectObj                           = DYNAMIC-FUNCTION('getSmartObjectObj' IN gshRepositoryManager, INPUT ttObjectNames.cName, INPUT 0)
                       ttStoreAttribute.tAttributeParent    = 'Master':U
                       ttStoreAttribute.tAttributeParentObj = dObjectObj
                       ttStoreAttribute.tAttributeLabel     = "WidgetIDFileName":U
                       ttStoreAttribute.tCharacterValue     = cRelName
                       ttStoreAttribute.tConstantValue      = NO.
                RUN storeAttributeValues IN gshRepositoryManager (INPUT BUFFER ttStoreAttribute:HANDLE, INPUT TABLE-HANDLE hTmp).

                DYNAMIC-FUNCTION('refreshDPS' IN hProcLibrary, STRING(dObjectObj), STRING(dObjectObj), "WidgetIDFileName":U, cRelName).
            END. /*IF lOk THEN*/
        END. /* IF pcObjectState = "Design":U THEN*/
        /*If we are in runtime, we only warn the user, but he/she cannot modify the widget-id file name in the
          repository.*/
        ELSE MESSAGE "The WidgetID File Name assigned for the container '" + ttObjectNames.cName + "' is different than the" SKIP
                     "WidgetID file name being edited in this tool." SKIP(1)
                     VIEW-AS ALERT-BOX WARNING
                     TITLE FRAME dialog-frame:TITLE.
    END. /*IF cWidgetIDFileName NE cRelName THEN*/

    IF NOT DYNAMIC-FUNCTION('createContainer':U IN ghDSLibrary,
                 INPUT ttObjectNames.cName,
                 INPUT cObjectType,
                 INPUT TRUE,
                 OUTPUT cFile,
                 OUTPUT cPath,
                 INPUT DATASET dsWidgetID BY-REFERENCE)
    THEN NEXT.

    DYNAMIC-FUNCTION('createDynContainerDetails':U IN ghDSLibrary,
        INPUT ttObjectNames.cName,
        INPUT dObjectID,
        INPUT cRootNodeCode,
        INPUT plAssignGaps,
        INPUT DATASET dsWidgetID BY-REFERENCE,
        OUTPUT iLastPage,
        OUTPUT lChanged,
        OUTPUT cNodes,
        INPUT-OUTPUT cActions).

END. /*FOR EACH ttObjectNames*/

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isABRunning Dialog-Frame 
FUNCTION isABRunning RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLevel AS INTEGER NO-UNDO INITIAL 1. 
  
  REPEAT WHILE PROGRAM-NAME(iLevel) <> ?.
    IF PROGRAM-NAME(iLevel) = "adeuib/_uibmain.p" THEN RETURN TRUE.
    ASSIGN iLevel = iLevel + 1.
  END.

  RETURN FALSE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

