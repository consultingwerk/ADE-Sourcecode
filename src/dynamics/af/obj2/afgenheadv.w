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
  File: afgenheadv.w

  Description:  Object Generator Common Viewer

  Purpose:      Object Generator Common Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/10/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:          18   UserRef:    
                Date:   02/18/2003  Author:     Thomas Hansen

  Update Notes: Cleaned up use of SCM handle and removed all direct references to RTB.

--------------------------------------------------------------------------------*/
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

&scop object-name       afgenheadv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{ src/adm2/globals.i }
{ af/app/afgenretin.i }
{ launch.i &Define-only=YES }
{ry/app/rydefrescd.i}    /* Global definitons needed for customization       */

DEFINE VARIABLE ghContainerSource           AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghScmTool                   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghWindow                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE glPromptOvrWrt              AS LOGICAL                  NO-UNDO.

DEFINE TEMP-TABLE ttHeaderInfo              NO-UNDO     RCODE-INFORMATION
    FIELD tType                 AS CHARACTER
    FIELD tName                 AS CHARACTER
    FIELD tIsRepository         AS LOGICAL
    FIELD tExtraInfo            AS CHARACTER
    FIELD tDisplayRecord        AS LOGICAL              INITIAL YES
    INDEX idxSort
        tType
        tDisplayRecord

    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buGenerate buCancel toGenerateDataObjects ~
toGenerateDataFields toGenerateBrowses toGenerateViewers toRunSilent ~
fiGenerateObjects RECT-11 
&Scoped-Define DISPLAYED-OBJECTS toGenerateDataObjects toGenerateDataFields ~
toGenerateBrowses toGenerateViewers toRunSilent fiGenerateObjects 

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
    ( INPUT pcObjectKey    AS CHARACTER,
      INPUT pcPrivateData  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataFieldsToggle sObject 
FUNCTION setDataFieldsToggle RETURNS LOGICAL
  ( plChecked AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectInfoValue sObject 
FUNCTION setObjectInfoValue RETURNS LOGICAL
    ( INPUT pcObjectKey    AS CHARACTER
    , INPUT pcPrivateData  AS CHARACTER
    , INPUT pcValue        AS CHARACTER
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel 
     IMAGE-UP FILE "ry/img/stop.gif":U
     LABEL "&Cancel" 
     SIZE 4.4 BY 1.14 TOOLTIP "Press to cancel generation process."
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "&Generate" 
     SIZE 5.6 BY 1.19 TOOLTIP "Press to start the object generation process."
     BGCOLOR 8 .

DEFINE VARIABLE fiGenerateObjects AS CHARACTER FORMAT "X(35)":U INITIAL "Generate objects" 
      VIEW-AS TEXT 
     SIZE 35 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.2 BY 1.33.

DEFINE VARIABLE toGenerateBrowses AS LOGICAL INITIAL no 
     LABEL "Browses" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateDataFields AS LOGICAL INITIAL no 
     LABEL "Data fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateDataObjects AS LOGICAL INITIAL yes 
     LABEL "Data objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "When unchecked, objects will be generated based on existing data objects" NO-UNDO.

DEFINE VARIABLE toGenerateViewers AS LOGICAL INITIAL no 
     LABEL "Viewers" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toRunSilent AS LOGICAL INITIAL no 
     LABEL "Run silent?" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "When checked, no feedback will be given until the entire process has completed." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buGenerate AT ROW 1.43 COL 86.6
     buCancel AT ROW 1.43 COL 86.6
     toGenerateDataObjects AT ROW 1.67 COL 6.2
     toGenerateDataFields AT ROW 1.67 COL 27
     toGenerateBrowses AT ROW 1.67 COL 47.8
     toGenerateViewers AT ROW 1.67 COL 63.8
     toRunSilent AT ROW 1.67 COL 92.6
     fiGenerateObjects AT ROW 1.1 COL 5.8 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 1.38 COL 3
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
         HEIGHT             = 1.71
         WIDTH              = 111.6.
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
       fiGenerateObjects:PRIVATE-DATA IN FRAME frMain     = 
                "Generate objects".

ASSIGN 
       toRunSilent:PRIVATE-DATA IN FRAME frMain     = 
                "RUN-SILENT".

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
ON CHOOSE OF buGenerate IN FRAME frMain /* Generate */
DO:
  /* Clear the Entity Cache */
  RUN refreshMnemonicsCache IN gshGenManager.
  RUN generateObjects NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toGenerateDataObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toGenerateDataObjects sObject
ON VALUE-CHANGED OF toGenerateDataObjects IN FRAME frMain /* Data objects */
, toGenerateDataFields, toGenerateViewers, toGenerateBrowses
DO:
    RUN changeGeneratedObjects ( INPUT SELF:NAME, INPUT SELF:CHECKED ).

    PUBLISH "DataObjectChanged":U FROM ghContainerSource (INPUT toGenerateDataObjects:CHECKED).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeGeneratedObjects sObject 
PROCEDURE changeGeneratedObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcWidgetName         AS CHARACTER            NO-UNDO.
  DEFINE INPUT PARAMETER plChecked            AS LOGICAL              NO-UNDO.

  DEFINE VARIABLE cWidgetName                 AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE cPageNumber                 AS CHARACTER            NO-UNDO.

  DEFINE VARIABLE cButtonPressed              AS CHARACTER            NO-UNDO.

  /* Fix for issue #7841 - Do not auto check off Data Fields toggle 
  /* If they have unchecked the Viewers checkbox we should uncheck the
     data fields toggle too */
  IF pcWidgetName = "toGenerateViewers":U AND NOT plChecked THEN
  DO WITH FRAME {&FRAME-NAME}:
    toGenerateDataFields:CHECKED = FALSE.
  END.
  */


/* **** NOTE: Because different tools allow you do create DataFields now, we will
              leave it up to the user to decide if he wants to create DataFields
              or not. If he is generating Viewers or SDOs, we will inform him that
              DataFields should be created for these objects and we will prompt
              him to see if he wants to continue or not (If he chose not to
              generate DataFields).
  
  /* If all the buttons are unchecked, then disable the generate button .*/
  IF pcWidgetName = "toGenerateDataFields":U AND NOT plChecked THEN
  DO WITH FRAME {&FRAME-NAME}:

    IF NOT toGenerateDataFields:CHECKED OR  toGenerateViewers:CHECKED THEN 
    DO:
        ASSIGN toGenerateDataFields:CHECKED = YES.

        RUN showMessages IN gshSessionManager
                      (INPUT  "Data Fields need to be selected for Objects that need to have Data Field instances associated with them." /* message to display */
                      ,INPUT  "ERR"             /* error type */
                      ,INPUT  "&OK"             /* button list */
                      ,INPUT  "&OK"             /* default button */ 
                      ,INPUT  "&OK"             /* cancel button */
                      ,INPUT  "Selection error" /* error window title */
                      ,INPUT  YES               /* display if empty */ 
                      ,INPUT  ghContainerSource /* container handle */
                      ,OUTPUT cButtonPressed    /* button pressed */
                      ).
      RETURN ERROR.
    END.

  END.    /* with frame ... */
*/
  CASE pcWidgetName:
    WHEN "toGenerateDataObjects":U THEN ASSIGN cPageNumber = "3":U. /* "3,4":U */
    WHEN "toGenerateDataFields":U  THEN ASSIGN cPageNumber = "4":U.
    WHEN "toGenerateBrowses":U     THEN ASSIGN cPageNumber = "5":U.
    WHEN "toGenerateViewers":U     THEN ASSIGN cPageNumber = "6":U.
    OTHERWISE                           ASSIGN cPageNumber = "":U.
  END CASE.   /* widget name */

  IF cPageNumber NE "":U
  THEN DO:
    IF plChecked
    THEN
      DYNAMIC-FUNCTION("enablePagesInFolder":U  IN ghContainerSource, INPUT cPageNumber).
    ELSE
      DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT cPageNumber).
  END.    /* valid page number */

  /* If all the buttons are unchecked, then disable the generate button .*/
  DO WITH FRAME {&FRAME-NAME}:
    IF  NOT toGenerateDataFields:CHECKED
    AND NOT toGenerateDataObjects:CHECKED
    AND NOT toGenerateBrowses:CHECKED
    AND NOT toGenerateViewers:CHECKED
    THEN
      ASSIGN
        buGenerate:SENSITIVE = NO.
    ELSE
      ASSIGN
        buGenerate:SENSITIVE = YES.

    /* *** NOTE: We will let the users decide what they want to generate, as per Issue 7483 and 7841

    IF NOT toGenerateDataFields:CHECKED AND toGenerateViewers:CHECKED THEN
    DO:
        ASSIGN toGenerateDataFields:CHECKED = YES.
        RUN changeGeneratedObjects ( INPUT "toGenerateDataFields":U, INPUT YES ).
    END. */
  END.    /* with frame ... */

  /* Special case is the toGenerateDataObjects. We need to populate some data based on this flag. */
  IF pcWidgetName EQ "toGenerateDataObjects":U THEN
  DO WITH FRAME {&FRAME-NAME}:    
      PUBLISH "toggleDataObjects":U  FROM ghContainerSource ( INPUT plChecked ).

  /*
  Remove this toggle and leave this for the users to decide.
  This shoule not happen if the Viewer is still checked as datafields is mandatory for viewers and/or dataobjects
        ASSIGN toGenerateDataFields:CHECKED = plChecked.
  */

  END.    /* generate DataObject */

  RETURN.

END PROCEDURE.  /* changeGeneratedObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDataObjectExist sObject 
PROCEDURE checkDataObjectExist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNameDataObject   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectSuffix AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDONames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewObjectExt     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError            AS CHARACTER  NO-UNDO.

  DEFINE BUFFER ttInfoInstance      FOR ttInfoInstance.
  
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
    RETURN.

  FIND FIRST  ttInfoInstance
        WHERE ttInfoInstance.tIKey    = "DataObject":U
        AND   ttInfoInstance.tIPData  = "DataObject":U + "-":U + "SUFFIX":U
        NO-ERROR.
  IF AVAILABLE ttInfoInstance
  THEN
    ASSIGN
      cDataObjectSuffix = ttInfoInstance.tIValue.
  ELSE
    ASSIGN
      cDataObjectSuffix = "fullo":U.
  
  /* Check all selected objects to see if they exist */
  FOR EACH ttInfoMaster NO-LOCK:
    IF ttInfoMaster.tMPData EQ "DATABASE":U THEN
      ASSIGN
        cNameDataObject = LC(ttInfoMaster.tMEntity + cDataObjectSuffix).
    ELSE
      ASSIGN
        cNameDataObject = LC(ttInfoMaster.tMName).
        
    cError = DYNAMIC-FUNCTION("prepareObjectName":U in ghRepositoryDesignManager,
                                   cNameDataObject,          /* Suggested Name */
                                   "{&DEFAULT-RESULT-CODE}", /* Result Code */
                                   cDataObjectSuffix,        /* Additional string - suffix */
                                   "DEFAULT":U,              /* Default or Save */
                                   ttInfoMaster.tMClass,     /* Object Type */
                                   ttInfoMaster.tMEntity,    /* Entity */
                                   ttInfoMaster.tMModule,    /* Module */   
                                   OUTPUT cNewObjectName,     
                                   OUTPUT cNewObjectExt ) .
    IF cError > "" THEN DO:
      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
     RETURN "ERROR":U.                                        
    END.
    ELSE IF cNewObjectName > "" THEN
         ASSIGN cNameDataObject = cNewObjectName + (IF cNewObjectExt > "" THEN "." ELSE "") + cNewObjectExt.  
        
        
    IF DYNAMIC-FUNCTION("objectExists" IN ghRepositoryDesignManager,cNameDataObject) THEN
      cSDONames = IF cSDONames = "":U 
                     THEN cNameDataObject  
                     ELSE cSDONames + "~n":U + cNameDataObject.
  END.
  
  IF cSDONames = "":U THEN
    RETURN.

  cMessage = {aferrortxt.i 'AF' '143' '' '' cSDONames}.

  RUN showMessages IN gshSessionManager
                  (INPUT  cMessage                                              /* message to display */
                  ,INPUT  "WAR"                                                 /* error type         */
                  ,INPUT  "&Yes,&No"                                            /* button list        */
                  ,INPUT  "&No"                                                 /* default button     */ 
                  ,INPUT  "&No"                                                 /* cancel button      */
                  ,INPUT  "Override Data Objects"                               /* error window title */
                  ,INPUT  YES                                                   /* display if empty   */ 
                  ,INPUT  ghContainerSource                                     /* container handle   */
                  ,OUTPUT cButtonPressed                                        /* button pressed     */
                        ).
                                         
  IF cButtonPressed = "&No":U THEN
    RETURN "FAILED":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /* REset the status area default message to the Progress default. */
    STATUS DEFAULT IN WINDOW ghWindow.

    RUN SUPER.

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
  DEFINE VARIABLE iBrowseLoop                 AS INTEGER              NO-UNDO.
  DEFINE VARIABLE rBuffer                     AS RAW                  NO-UNDO.
  DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hBrowse                     AS HANDLE               NO-UNDO.
  DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.

  DEFINE VARIABLE cValidationError            AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cMessage                    AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cAnswer                     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE lErrorOccured               AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER            NO-UNDO.

  EMPTY TEMP-TABLE ttInfoMaster.
  EMPTY TEMP-TABLE ttInfoInstance.

  DEFINE VARIABLE cTTPData                     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTName                      AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTDescription               AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTClass                     AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTModule                    AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTEntity                    AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTDBList                    AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE cTTTableList                 AS CHARACTER            NO-UNDO.

  /* PAGE 1 - VALIDATE and CREATE entries the selected records in the browser */
  PUBLISH "getBrowseHandle":U FROM ghContainerSource ( OUTPUT hBrowse ).

  ASSIGN
    hQuery  = hBrowse:QUERY
    hBuffer = hQuery:GET-BUFFER-HANDLE(1)
    .

  /* Retrieve all information from the relevant objects */
  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      toRunSilent
      toGenerateDataObjects
      toGenerateDataFields
      toGenerateBrowses
      toGenerateViewers
      cValidationError = "":U.

    IF hBrowse:NUM-SELECTED-ROWS EQ 0
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT  {aferrortxt.i 'AF' '138'}                             /* message to display */ /*At least one table or object should be selected*/
                      ,INPUT  "ERR"                                                 /* error type         */
                      ,INPUT  "&OK"                                                 /* button list        */
                      ,INPUT  "&OK"                                                 /* default button     */ 
                      ,INPUT  "&OK"                                                 /* cancel button      */
                      ,INPUT  "Data selection error"                                /* error window title */
                      ,INPUT  YES                                                   /* display if empty   */ 
                      ,INPUT  ghContainerSource                                     /* container handle   */
                      ,OUTPUT cButtonPressed                                        /* button pressed     */
                      ).
      RETURN ERROR.
    END.    /* no rows selected */
    ELSE DO:
      /* Inform the user that when generating SDOs and Viewers that the DataFields
         should exists (if he chose not to create it) and give the user the
         opportunity to continue if he wants to, as the DataFields might have been
         pre-generated */
      IF (NOT toGenerateDataFields:CHECKED)  AND
             (toGenerateDataObjects:CHECKED OR
              toGenerateViewers:CHECKED)    THEN
      DO:
        cMessage = {aferrortxt.i 'AF' '139'}.
        
        RUN showMessages IN gshSessionManager
                        (INPUT  cMessage                                              /* message to display */
                        ,INPUT  "WAR"                                                 /* error type         */
                        ,INPUT  "&Yes,&No"                                            /* button list        */
                        ,INPUT  "&No"                                                 /* default button     */ 
                        ,INPUT  "&No"                                                 /* cancel button      */
                        ,INPUT  "Continue object generation"                          /* error window title */
                        ,INPUT  YES                                                   /* display if empty   */ 
                        ,INPUT  ghContainerSource                                     /* container handle   */
                        ,OUTPUT cButtonPressed                                        /* button pressed     */
                        ).
                                                                                            
        IF cButtonPressed = "&No":U THEN
          RETURN.
      END.

      blkBrowseRows:
      DO iBrowseLoop = 1 TO hBrowse:NUM-SELECTED-ROWS:

        hBrowse:FETCH-SELECTED-ROW(iBrowseLoop).
        hQuery:GET-CURRENT().

        IF toGenerateDataObjects
        THEN DO:
          ASSIGN
            cTTPData        = hBrowse:PRIVATE-DATA
            cTTName         = hBuffer:BUFFER-FIELD(1):BUFFER-VALUE
            cTTDescription  = hBUffer:BUFFER-FIELD(4):BUFFER-VALUE
            cTTClass        = "":U
            cTTModule       = "":U
            cTTEntity       = hBUffer:BUFFER-FIELD(2):BUFFER-VALUE
            cTTDBList       = hBUffer:BUFFER-FIELD(3):BUFFER-VALUE
            cTTTableList    = hBuffer:BUFFER-FIELD(1):BUFFER-VALUE
            .
          IF cTTEntity = "< Not Available >":U
          OR cTTEntity = "":U
          THEN DO:
            ASSIGN
              cValidationError = cValidationError
                               + (IF cValidationError <> "":U THEN CHR(3) + CHR(10) ELSE "":U)
                               + "  TABLE : ":U  + cTTName
                               + "  ENTITY : ":U + cTTEntity
                               + CHR(10) + CHR(3)
                               + {aferrortxt.i 'AF' '140' '' '' cTTName}. 
             NEXT blkBrowseRows.
          END.
        END.
        ELSE DO:
          ASSIGN
            cTTPData        = hBrowse:PRIVATE-DATA
            cTTName         = hBuffer:BUFFER-FIELD(1):BUFFER-VALUE
            cTTDescription  = hBUffer:BUFFER-FIELD(4):BUFFER-VALUE
            cTTClass        = hBUffer:BUFFER-FIELD(2):BUFFER-VALUE
            cTTModule       = hBUffer:BUFFER-FIELD(3):BUFFER-VALUE
            cTTEntity       = "":U
            cTTDBList       = "":U
            cTTTableList    = "":U
            .
          IF cTTClass = "":U
          THEN DO:
            ASSIGN
              cValidationError = cValidationError
                               + (IF cValidationError <> "":U THEN CHR(3) + CHR(10) ELSE "":U)
                               + "  OBJECT : ":U + cTTName
                               + "  CLASS : ":U  + cTTClass
                               .
             NEXT blkBrowseRows.
          END.
        END.

        CREATE ttInfoMaster.
        ASSIGN
          ttInfoMaster.tMPData        = cTTPData
          ttInfoMaster.tMName         = cTTName
          ttInfoMaster.tMDescription  = cTTDescription
          ttInfoMaster.tMClass        = cTTClass
          ttInfoMaster.tMModule       = cTTModule
          ttInfoMaster.tMEntity       = cTTEntity
          ttInfoMaster.tMDBList       = cTTDBList
          ttInfoMaster.tMTableList    = cTTTableList
          .

      END.  /* loop through browse */

    END.

    IF cValidationError <> "":U
    THEN DO:
      ASSIGN
        cValidationError = "Selection Error."
                         + CHR(3) + CHR(10)
                         + cValidationError
                         .
     
      IF CAN-FIND(FIRST ttInfoMaster)
      THEN DO:
        ASSIGN
          cValidationError = cValidationError + CHR(3) + CHR(10)
                           + CHR(10)
                           + "Continue with generation ?"
                           .
        
        RUN showMessages IN gshSessionManager
                        (INPUT  cValidationError                                      /* message to display */
                        ,INPUT  "ERR"                                                 /* error type         */
                        ,INPUT  "&Yes,&No"                                            /* button list        */
                        ,INPUT  "&No"                                                 /* default button     */ 
                        ,INPUT  "&No"                                                 /* cancel button      */
                        ,INPUT  "Data selection error"                                /* error window title */
                        ,INPUT  YES                                                   /* display if empty   */ 
                        ,INPUT  ghContainerSource                                     /* container handle   */
                        ,OUTPUT cButtonPressed                                        /* button pressed     */
                        ).
                        
        IF cButtonPressed = "NO":U
        OR cButtonPressed = "&NO":U
        THEN
          RETURN ERROR.
      END.
      ELSE DO:
        RUN showMessages IN gshSessionManager
                        (INPUT  cValidationError                                      /* message to display */
                        ,INPUT  "ERR"                                                 /* error type         */
                        ,INPUT  "&OK"                                                 /* button list        */
                        ,INPUT  "&OK"                                                 /* default button     */ 
                        ,INPUT  "&OK"                                                 /* cancel button      */
                        ,INPUT  "Data selection error"                                /* error window title */
                        ,INPUT  YES                                                   /* display if empty   */ 
                        ,INPUT  ghContainerSource                                     /* container handle   */
                        ,OUTPUT cButtonPressed                                        /* button pressed     */
                        ).
        RETURN ERROR.
      END.
    END.    /* no rows selected */

/*  *** NOTE: The users were prompted to see whether they wanted DataFields to be created
    
    IF toGenerateViewers THEN
      ASSIGN
        toGenerateDataFields:CHECKED  = YES
        toGenerateDataFields          = YES
        .
*/
    /* PAGE 2 - Get all the SCM entries */
    IF valid-handle(ghSCMTool) THEN DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "SCM":U).
    /* PAGE 3 - Get all the DataObject & DataLogic Procedure entries */
    IF toGenerateDataObjects  THEN DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "DataObject":U).
    /* Check that we do not override existing SDOs - Issue #6241 */
    IF toGenerateDataObjects AND glPromptOvrWrt THEN DO:
      RUN checkDataObjectExist.
      IF RETURN-VALUE <> "":U THEN 
        RETURN ERROR.
    END.
    /* PAGE 4 - Get all the Data Field entries */
    IF toGenerateDataFields   THEN DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "DataField":U).
    /* PAGE 5 - Get all the Dynamic Browse entries */
    IF toGenerateBrowses      THEN DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Browse":U).
    /* PAGE 6 - Get all the Dynamic Viewer entries */
    IF toGenerateViewers      THEN DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Viewer":U).

    /* Get header information. */
    DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Header":U).
    /*
    No information is stored on the table, apart from the browse information
    DYNAMIC-FUNCTION("createObjectInformation":U, INPUT "Tables":U).
    */

  END.    /* with frame ... */

  /* Validate what we can. */
  ASSIGN
    cValidationError = "":U.

  /* PAGE 2 - VALIDATE all the SCM entries */
  IF cValidationError = "":U 
  THEN DO:
    IF CONNECTED("RTB":U)
    THEN RUN validateSCM.
    cValidationError = RETURN-VALUE.
  END.
  /* PAGE 3 - VALIDATE the DataObject & DataLogic Procedure entries */
  IF cValidationError = "":U 
  THEN DO:
    IF toGenerateDataObjects
    THEN RUN validateDataObject.
    cValidationError = RETURN-VALUE.
  END.
  /* PAGE 4 - VALIDATE the Data Field entries */
  IF cValidationError = "":U 
  THEN DO:
    IF toGenerateDataFields
    THEN RUN validateDataField.
    cValidationError = RETURN-VALUE.
  END.
  /* PAGE 5 - VALIDATE the Dynamic Browse entries */
  IF cValidationError = "":U 
  THEN DO:
    IF toGenerateBrowses
    THEN RUN validateBrowse.
    cValidationError = RETURN-VALUE.
  END.
  /* PAGE 6 - VALIDATE the Dynamic Viewer entries */
  IF cValidationError = "":U 
  THEN DO:
    IF toGenerateViewers
    THEN RUN validateViewer.
    cValidationError = RETURN-VALUE.
  END.

  IF cValidationError <> "":U
  THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  cValidationError    /* message to display */
                                          ,INPUT  "ERR"               /* error type */
                                          ,INPUT  "&OK"               /* button list */
                                          ,INPUT  "&OK"               /* default button */ 
                                          ,INPUT  "&OK"               /* cancel button */
                                          ,INPUT  "Data error"        /* error window title */
                                          ,INPUT  YES                 /* display if empty */ 
                                          ,INPUT  ghContainerSource   /* container handle */
                                          ,OUTPUT cButtonPressed  ).  /* button pressed */
    RETURN ERROR.
  END.

  /* Perform the generation. */
  ASSIGN
    lRunOnAppServer = NOT CONNECTED("RTB").

  IF NOT toRunSilent
  THEN DO:
    /* Change to the 'Logging' Page */
    RUN selectPage IN ghContainerSource ( INPUT 7 ).
    PUBLISH "listenForLogMessages":U FROM ghContainerSource.
    ASSIGN
      lRunOnAppserver = NO.
  END.    /* not run silent. */

  /* If we are not runnig on the AppServer then enable the Cancel button. */
  IF NOT lRunOnAppserver
  OR gshAStraAppServer EQ SESSION:HANDLE
  THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      buCancel:HIDDEN   = NO
      buGenerate:HIDDEN = YES
      .
  END.    /* not on appserver, with frame */

  PROCESS EVENTS.

  STATUS DEFAULT "Object Generation In Progress ... " IN WINDOW ghWindow.
  /* Not sure why we wouldn't want to see that we are busy 
    Always indicate that the session is busy - can't see
    that there is really  a way to stop the process anyway 
    since we are running a plip
  IF NOT toRunSilent
  THEN
  */
  SESSION:SET-WAIT-STATE("GENERAL":U). 

  { launch.i
      &PLIP     = 'af/app/afgenplipp.p'
      &IProc    = 'generateObjects'
      &PList    = "( INPUT toRunSilent, INPUT TABLE ttInfoMaster, INPUT TABLE ttInfoInstance, OUTPUT TABLE ttErrorLog )"
      &OnApps   = lRunOnAppserver
      &AutoKill = YES
  }
  
  STATUS DEFAULT "Object Generation Complete ... " IN WINDOW ghWindow.
  SESSION:SET-WAIT-STATE("":U).

  ASSIGN
    buCancel:HIDDEN   = YES
    buGenerate:HIDDEN = NO
    .

  /* Process errors if they have not yet been processed. */
  IF toRunSilent
  THEN DO:
    PUBLISH "listenForLogMessages":U FROM ghContainerSource.
    FOR EACH ttErrorLog 
      BY ttErrorLog.tDateLogged
      BY ttErrorLog.tTimeLogged
      :
      IF ttErrorLog.tErrorType EQ "ERROR":U THEN
          ASSIGN lErrorOccured = YES.

      RAW-TRANSFER BUFFER ttErrorLog TO FIELD rBuffer.
      PUBLISH "logObjectGeneratorMessage" ( INPUT rBuffer ).
    END.    /* each error log */
    /* Change to the 'Logging' Page */
    RUN selectPage IN ghContainerSource ( INPUT 7 ).
  END.    /* process errors. */
  ELSE 
    PUBLISH "errorInGeneration":U FROM ghContainerSource (OUTPUT lErrorOccured).

  /* Display the 'We're finished!' message */
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN showMessages IN gshSessionManager (INPUT IF lErrorOccured = NO
                                                 THEN {aferrortxt.i 'AF' '141'}
                                                 ELSE {aferrortxt.i 'AF' '142'},
                                           INPUT "MES":U,
                                           INPUT "OK",
                                           INPUT "OK",
                                           INPUT "OK",
                                           INPUT "Object Generator",
                                           INPUT NO,
                                           INPUT ?,
                                           OUTPUT cButton).
  RETURN.

END PROCEDURE.  /* generateObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHeaderInfoBuffer sObject 
PROCEDURE getHeaderInfoBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns the buffer handle of the headr info TT to a caller.
  Parameters:  phHeaderInfoBuffer - 
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phHeaderInfoBuffer          AS HANDLE       NO-UNDO.

    ASSIGN phHeaderInfoBuffer = BUFFER ttHeaderInfo:HANDLE.

    RETURN.
END PROCEDURE.  /* getHeaderInfoBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getScmToolHandle sObject 
PROCEDURE getScmToolHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER phScmTool           AS HANDLE               NO-UNDO.

    ASSIGN phScmTool = ghScmTool.

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

  DEFINE VARIABLE hProcedure                  AS HANDLE               NO-UNDO.

  RUN SUPER.

  ASSIGN 
    ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR
    .
  
  RUN populateHeader.

  /* Initialise the tab pages based on the toggle settings */
  ASSIGN
    toGenerateDataObjects:CHECKED  IN FRAME {&FRAME-NAME} = YES
    toGenerateDataFields:CHECKED   IN FRAME {&FRAME-NAME} = YES
    buCancel:HIDDEN                IN FRAME {&FRAME-NAME} = YES
    fiGenerateObjects:SCREEN-VALUE = " Generate objects:"
    fiGenerateObjects:WIDTH-CHARS  = FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiGenerateObjects:SCREEN-VALUE, fiGenerateObjects:FONT) + 0.5
    .

  APPLY "VALUE-CHANGED" TO toGenerateDataObjects.
  APPLY "VALUE-CHANGED" TO toGenerateDataFields.
  DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT "5,6":U).

  /* If a workspace is not currently selected and set as a session parameter, then  
     disable the SCM folder
  */
  IF DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, INPUT '_scm_current_workspace':U) = ?
  THEN
    DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT "2":U).

  SUBSCRIBE TO "getHeaderInfoBuffer":U  IN ghContainerSource.
  
  RUN populateHeader.
  
  /* If we are running on the AppServer then enable the Cancel button. */
  IF gshAStraAppServer <> SESSION:HANDLE
  THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      toRunSilent         = YES
      toRunSilent:CHECKED = YES
      .
    DISABLE
      toRunSilent
      .
  END.    /* not on appserver, with frame */

  {get containerHandle ghWindow ghContainerSource}.
  STATUS DEFAULT "Object Generator... " IN WINDOW ghWindow.
  
  SUBSCRIBE "setPreferences":U IN ghContainerSource.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateHeader sObject 
PROCEDURE populateHeader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDisplayRepository              AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE lExists                         AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE rRowid                          AS ROWID            NO-UNDO.
    DEFINE VARIABLE cProfileData                    AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cShareStatus                    AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cLabel                          AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE cValue                          AS CHARACTER        NO-UNDO.

    /* Get the information needed for the header. */
    { launch.i
        &PLIP         = 'af/app/afgenplipp.p'
        &IProc        = 'retrieveHeaderInformation'
        &PList        = "( OUTPUT TABLE ttHeaderInfo )"
        &AutoKill     = YES
        &PlipRunError = "RETURN ERROR cErrorMessage."         
    }

    /* Display Repository - Is there an active session filter set?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "SessionFS":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).

    /* IF there is not an active filter set, then it means we have to display repository data */
    IF cProfileData EQ "":U OR cProfileData EQ ? THEN
        ASSIGN cProfileData = STRING(YES).  /* Set to YES */
    ELSE
        ASSIGN cProfileData = STRING(NO).   /* Set to No  */

    ASSIGN lDisplayRepository = LOGICAL(cProfileData) NO-ERROR.

    FOR EACH ttHeaderInfo:
        CASE ttHeaderInfo.tType:
            WHEN "DATABASE":U THEN
            DO WITH FRAME {&FRAME-NAME}:            
                IF lDisplayRepository                                           OR
                   (NOT lDisplayRepository AND NOT ttHeaderInfo.tIsRepository ) THEN                
                    ASSIGN ttHeaderInfo.tDisplayRecord = YES.                
                ELSE
                    ASSIGN ttHeaderInfo.tDisplayRecord = NO.
            END.    /* DB */
            WHEN "MODULE":U THEN
            DO:
                IF VALID-HANDLE(ghScmTool) THEN
                DO:
                    /*Set the module to NOT display by default. If the module doies exist, then we will change
                     this as part of the return from the API call below.  */
                    ASSIGN ttHeaderInfo.tDisplayRecord = NO.

                    /* The following API call will return an ERROR-STATUS:ERROR and a RETURN-VALUE
                       if the module does not exist in thew workspace. We are not going to display this 
                       at this point, but simply not include the module to display. If modules 
                       do not appear in the combos and the user is expecting these, it is due to 
                       SCM Xref data not being set up or the modules not being valid in the workspace. */
                    RUN scmModuleInWorkspace IN ghScmTool (INPUT  ttHeaderInfo.tName,
                                                          INPUT  DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, INPUT "_scm_current_workspace":U),
                                                          OUTPUT ttHeaderInfo.tDisplayRecord ) NO-ERROR.
                END.
                ELSE
                    ASSIGN ttHeaderInfo.tDisplayRecord = YES.

                IF ttHeaderInfo.tIsRepository AND NOT lDisplayRepository THEN
                    ASSIGN ttHeaderInfo.tDisplayRecord = NO.
            END.    /* module */
        END CASE.   /* header type */
    END.    /* each header info */

    /* Make sure that there is at least one entry in the PM and DB combos. */
    FIND FIRST ttHeaderInfo WHERE
               ttHeaderInfo.tType          = "DATABASE":U AND
               ttHeaderInfo.tDisplayRecord = YES
               NO-ERROR.
    IF NOT AVAILABLE ttHeaderInfo THEN
    DO:
        CREATE ttHeaderInfo.
        ASSIGN ttHeaderInfo.tType          = "DATABASE":U
               ttHeaderInfo.tName          = "<None>"
               ttHeaderInfo.tIsRepository  = NO
               ttHeaderInfo.tExtraInfo     = "":U
               ttHeaderInfo.tDisplayRecord = YES
               .
    END.    /* no DB items */

    FIND FIRST ttHeaderInfo WHERE
               ttHeaderInfo.tType          = "MODULE":U AND
               ttHeaderInfo.tDisplayRecord = YES
               NO-ERROR.
    IF NOT AVAILABLE ttHeaderInfo THEN
    DO:
        CREATE ttHeaderInfo.
        ASSIGN ttHeaderInfo.tType          = "MODULE":U
               ttHeaderInfo.tName          = "<None>"
               ttHeaderInfo.tExtraInfo     = "<None>" + CHR(1) + "No product module available"
               ttHeaderInfo.tIsRepository  = NO
               ttHeaderInfo.tDisplayRecord = YES
               .        
    END.    /* no DB items */

    RETURN.
END PROCEDURE.  /* populateHeader */

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
     cPrefData <> "":U THEN  DO:
    glPromptOvrWrt = LOGICAL(DYNAMIC-FUNCTION("mappedEntry" IN target-procedure,"SDO_OvrWrt":U,cPrefData,TRUE,CHR(3))).
    IF glPromptOvrWrt = ? THEN
      glPromptOvrWrt = TRUE.
  END.
  ELSE
    glPromptOvrWrt = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBrowse sObject 
PROCEDURE validateBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cBrowseSuffix           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE iBrowseNumFields        AS INTEGER                  NO-UNDO.

  ASSIGN
    cBrowseSuffix     =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "SUFFIX":U)
    iBrowseNumFields  = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "NUM-FIELDS":U))
    .

  IF cBrowseSuffix = ?
  OR cBrowseSuffix = "":U
  THEN
    RETURN {aferrortxt.i 'AF' '135' '' '' "'Browse'"}.
    /* A suffix must be specified for the Browse */

  IF iBrowseNumFields = ?
  OR iBrowseNumFields = 0
  THEN
    RETURN {aferrortxt.i 'AF' '136' '' '' "'Browse'"}.
    /* The number of fields in the Browse must be greater than 0". */

/*
  DEFINE VARIABLE cBrowseModule           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cBrowseObjectType       AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lBrowseFromSDO          AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE lBrowseDeleteInstances  AS LOGICAL                  NO-UNDO.
  ASSIGN
    cBrowseModule          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "MODULE":U)
    cBrowseObjectType      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "OBJECT-TYPE":U)
    lBrowseFromSDO         = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "USE-DATA-OBJECT":U))
    lBrowseDeleteInstances = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Browse":U, INPUT "DELETE-INSTANCES":U))
    .
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDataField sObject 
PROCEDURE validateDataField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  DEFINE VARIABLE cDataFieldModule        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cDataFieldObjectType    AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lDataFieldFromSDO       AS LOGICAL                  NO-UNDO.
  ASSIGN
    cDataFieldModule     =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "MODULE":U)
    cDataFieldObjectType =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "OBJECT-TYPE":U)
    lDataFieldFromSDO    = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataField":U, INPUT "USE-DATA-OBJECT":U))
    .
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDataObject sObject 
PROCEDURE validateDataObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRootFolder             AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSdoSuffix              AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cLogicProcedureSuffix   AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE cErrorValue             AS CHARACTER      NO-UNDO.

  ASSIGN
    cSdoSuffix              = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "SUFFIX":U)
    cLogicProcedureSuffix   = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-SUFFIX":U)
    cRootFolder             = DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "ROOT-FOLDER":U)
    .

  IF cSdoSuffix = ?
  OR cSdoSuffix = "":U
  THEN
    RETURN {aferrortxt.i 'AF' '135' '' '' "'DataObject'"}.
    /* A suffix must be specified for the DataObject. */

  IF cLogicProcedureSuffix = ?
  OR cLogicProcedureSuffix = "":U 
  OR INDEX(cLogicProcedureSuffix, ".p":U) = 0 
  OR (INDEX(cLogicProcedureSuffix, ".p":U) <> 0 
  AND SUBSTRING(cLogicProcedureSuffix,INDEX(cLogicProcedureSuffix, ".p":U)) <> ".p")
  THEN
    RETURN {aferrortxt.i 'AF' '135' '' '' "'DataLogic Procedure and it must have a .p extension'"}.
    /* A suffix must be specified for the DataLogic Procedure */

  IF cRootFolder = ?
  OR cRootFolder = "":U
  THEN
    ASSIGN
      cRootFolder  = ".":U.

  { launch.i
      &PLIP         = 'af/app/afgenplipp.p'
      &IProc        = 'retreivePathInformation'
      &PList        = "( INPUT-OUTPUT cRootFolder
                       , OUTPUT cErrorValue )"
      &AutoKill     = YES
  }

  IF cErrorValue <> "":U
  THEN RETURN "ROOT Folder Error : " + cErrorValue.

  IF cRootFolder <> ?
  AND cRootFolder <> "":U
  THEN DYNAMIC-FUNCTION("setObjectInfoValue":U, INPUT "DataObject":U, INPUT "ROOT-FOLDER":U, INPUT cRootFolder).

/*
  DEFINE VARIABLE lSdoDeleteInstances     AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE cAppServerPartition     AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cSdoModule              AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cLogicProcedureModule   AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lSuppressValidation     AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE lFollowJoins            AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE lCreateMissingFolder    AS LOGICAL                  NO-UNDO.  
  DEFINE VARIABLE iFollowDepth            AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE cFieldSequence          AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cLogicProcedureTemplate AS CHARACTER                NO-UNDO.    
  DEFINE VARIABLE cDOObjectType           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cDLObjectType           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cRelativePath           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cLPRelativePath         AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cFolderIndicator        AS CHARACTER                NO-UNDO.
  ASSIGN
    lSdoDeleteInstances     = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "DELETE-INSTANCES":U))
    cAppServerPartition     =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "AS-PARTITION":U)            
    cSdoModule              =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "MODULE":U)
    cLogicProcedureModule   =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-MODULE":U)
    cLogicProcedureSuffix   =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-SUFFIX":U)
    lSuppressValidation     = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "SUPPRESS-VALIDATION":U))
    lFollowJoins            = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FOLLOW-JOINS":U))
    lCreateMissingFolder    = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "CREATE-MISSING-FOLDER":U))
    iFollowDepth            =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FOLLOW-DEPTH":U)
    cFieldSequence          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "FIELD-SEQUENCE":U)
    cLogicProcedureTemplate =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-TEMPLATE":U)
    cDOObjectType           =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "OBJECT-TYPE":U)
    cDLObjectType           =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-OBJECT-TYPE":U)
    cRelativePath           =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "PATH":U)
    cLPRelativePath         =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "DataObject":U, INPUT "LP-PATH":U)
    cFolderIndicator        = "/":U
    .
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSCM sObject 
PROCEDURE validateSCM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  DEFINE VARIABLE cWorkspace              AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE iTask                   AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE cLogicSubtype           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lOverwriteLogic         AS LOGICAL                  NO-UNDO.

  ASSIGN
    cWorkspace       =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "WORKSPACE":U)
    iTask            = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "TASK":U))
    cLogicSubtype    =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "SUBTYPE":U)
    lOverwriteLogic  = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "SCM":U, INPUT "OVERWRITE-IN-TASK":U))
    .
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateViewer sObject 
PROCEDURE validateViewer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cViewerSuffix           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE iViewerNumFields        AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE iViewerFieldsPerColumn  AS INTEGER                  NO-UNDO.

  ASSIGN
    cViewerSuffix          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "SUFFIX":U)
    iViewerNumFields       = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "NUM-FIELDS":U))
    iViewerFieldsPerColumn = INTEGER(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "NUM-FIELDS-COLUMN":U))
    .

  IF cViewerSuffix = ?
  OR cViewerSuffix = "":U
  THEN
    RETURN {aferrortxt.i 'AF' '135' '' '' "'Viewer'"}.
    /* A suffix must be specified for the Viewer */
    
  IF iViewerNumFields = ?
  OR iViewerNumFields = 0
  THEN
    RETURN {aferrortxt.i 'AF' '136' '' '' "'Viewer'"}.
    /* The number of fields in the Viewer must be greater than 0 */

  IF iViewerFieldsPerColumn = ?
  OR iViewerFieldsPerColumn = 0
  THEN
    RETURN {aferrortxt.i 'AF' '137'}.
    /* The number of fields per column in the Viewer must be greater than 0 */

/*
  DEFINE VARIABLE cViewerModule           AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE cViewerObjectType       AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE lViewerFromSDO          AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE lViewerDeleteInstances  AS LOGICAL                  NO-UNDO.
  ASSIGN
    cViewerModule          =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "MODULE":U)
    cViewerObjectType      =         DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "OBJECT-TYPE":U)
    lViewerFromSDO         = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "USE-DATA-OBJECT":U))
    lViewerDeleteInstances = LOGICAL(DYNAMIC-FUNCTION("getObjectInfoValue":U, INPUT "Viewer":U, INPUT "DELETE-INSTANCES":U))
    .
*/

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

  IF pcObjectType EQ "Header":U
  THEN
    ASSIGN
      hFrame = FRAME {&FRAME-NAME}:HANDLE.
  ELSE DO:
    ASSIGN
      cPublishEvent = "get":U + pcObjectType + "Frame":U.
    PUBLISH cPublishEvent FROM ghContainerSource ( OUTPUT hFrame ).
    IF NOT VALID-HANDLE(hFrame)
    THEN RETURN FALSE. 
  END.    /* not header */

  IF NOT CAN-DO("Header,SCM":U, pcObjectType)
  THEN DO:
    FIND FIRST ttInfoInstance
      WHERE ttInfoInstance.tIKey    = "Header":U
      AND   ttInfoInstance.tIPData  = "HEADER-CREATE-OBJECT-TYPES":U
      NO-ERROR.
    IF NOT AVAILABLE ttInfoInstance
    THEN DO:
      CREATE ttInfoInstance.
      ASSIGN
        ttInfoInstance.tIKey    = "Header":U
        ttInfoInstance.tIPData  = "HEADER-CREATE-OBJECT-TYPES":U
        ttInfoInstance.tIValue  = pcObjectType.
        .
    END.    /* n/a object info */
    ELSE
      ASSIGN
        ttInfoInstance.tIValue = ttInfoInstance.tIValue + ",":U + pcObjectType.
  END.    /* object type <> header */

  ASSIGN
    hWidget = hFrame
    hWidget = hWidget:FIRST-CHILD        /* field group */
    hWidget = hWidget:FIRST-CHILD
    .

  DO WHILE VALID-HANDLE(hWidget):

    IF  CAN-QUERY(hWidget, "PRIVATE-DATA":U)
    AND CAN-QUERY(hWidget, "SCREEN-VALUE":U)
    AND CAN-QUERY(hWidget, "SENSITIVE":U)
    AND hWidget:SENSITIVE
    AND hWidget:PRIVATE-DATA  NE "":U
    AND hWidget:PRIVATE-DATA  NE ?
    THEN DO:
      CREATE ttInfoInstance.
      ASSIGN
        ttInfoInstance.tIKey    = pcObjectType
        ttInfoInstance.tIPData  = CAPS(pcObjectType) + "-":U + hWidget:PRIVATE-DATA
        ttInfoInstance.tIValue  = hWidget:SCREEN-VALUE
        .
    END.    /* can get information */

    ASSIGN
      hWidget = hWidget:NEXT-SIBLING.

  END.

  RETURN TRUE.

END FUNCTION.   /* createObjectInformation */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInfoValue sObject 
FUNCTION getObjectInfoValue RETURNS CHARACTER
    ( INPUT pcObjectKey    AS CHARACTER,
      INPUT pcPrivateData  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValue              AS CHARACTER                    NO-UNDO.

  DEFINE BUFFER ttInfoInstance      FOR ttInfoInstance.

  FIND FIRST ttInfoInstance
    WHERE ttInfoInstance.tIKey    = pcObjectKey
    AND   ttInfoInstance.tIPData  = CAPS(pcObjectKey) + "-":U + pcPrivateData
    NO-ERROR.
  IF AVAILABLE ttInfoInstance
  THEN
    ASSIGN
      cValue = ttInfoInstance.tIValue.
  ELSE
    ASSIGN
      cValue = ?.

  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataFieldsToggle sObject 
FUNCTION setDataFieldsToggle RETURNS LOGICAL
  ( plChecked AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function allows other objects to set the value of the Data Fields
            toggle.
    Notes:  
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    IF toGenerateViewers:CHECKED AND plChecked = FALSE THEN
      RETURN TRUE.
    ASSIGN toGenerateDataFields:CHECKED = plChecked.
    APPLY "VALUE-CHANGED":U TO toGenerateDataFields.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectInfoValue sObject 
FUNCTION setObjectInfoValue RETURNS LOGICAL
    ( INPUT pcObjectKey    AS CHARACTER
    , INPUT pcPrivateData  AS CHARACTER
    , INPUT pcValue        AS CHARACTER
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER ttInfoInstance      FOR ttInfoInstance.

  FIND FIRST ttInfoInstance
    WHERE ttInfoInstance.tIKey = pcObjectKey
    AND   ttInfoInstance.tIPData        = CAPS(pcObjectKey) + "-":U + pcPrivateData
    NO-ERROR.
  IF AVAILABLE ttInfoInstance
  THEN
    ASSIGN
      ttInfoInstance.tIValue  = pcValue.
  ELSE DO:
    CREATE ttInfoInstance.
    ASSIGN
      ttInfoInstance.tIKey    = pcObjectKey
      ttInfoInstance.tIPData           = CAPS(pcObjectKey) + "-":U + pcPrivateData
      ttInfoInstance.tIValue  = pcValue
      .
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

