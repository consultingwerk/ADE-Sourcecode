&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmtlfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynhelpv.w

  Description:  Help Context Viewer

  Purpose:      Help Context Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:              UserRef:    
                Date:   05/07/2002  Author:     Neil Bell

  Update Notes: Help Context Viewer, copied from the translation viewer

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

&scop object-name       rydynhelpv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes
{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindow                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCallerWindow              AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSavedLanguage             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghObjectField               AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGlobalField               AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTypeField                 AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.


DEFINE TEMP-TABLE ttHelp NO-UNDO RCODE-INFORMATION
    FIELD dLanguageObj        AS DECIMAL
    FIELD cContainerFileName  AS CHARACTER FORMAT "X(60)":U  LABEL "Container":U 
    FIELD cObjectName         AS CHARACTER FORMAT "X(40)":U  LABEL "Object":U  
    FIELD cWidgetName         AS CHARACTER FORMAT "X(40)":U  LABEL "Widget":U        
    FIELD cHelpFilename       AS CHARACTER FORMAT "X(60)":U  LABEL "Help filename":U
    FIELD cHelpContext        AS CHARACTER FORMAT "X(60)":U  LABEL "Help context"
    FIELD lDelete             AS LOGICAL                     LABEL "Delete"
    FIELD cOriginalLabel      AS CHARACTER FORMAT "X(30)":U  LABEL "Widget label":U
    FIELD cWidgetType         AS CHARACTER FORMAT "X(20)":U  LABEL "Widget type":U
    INDEX key1 AS UNIQUE PRIMARY dLanguageObj cContainerFileName cObjectName cWidgetType cWidgetName
    INDEX key2 cObjectName cWidgetName 
    INDEX key4 cWidgetName cObjectName.

DEFINE VARIABLE gcSortBy        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBrowseColHdls AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmtlfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coObject bSelect cHelpFilename ~
bUpdateFileName cHelpContext bUpdateContext 
&Scoped-Define DISPLAYED-OBJECTS coObject cHelpFilename cHelpContext 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hLanguage AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bSelect 
     LABEL "&Select All" 
     SIZE 15 BY 1.14 TOOLTIP "Selects all rows, a help filename and context can then applied to selected rows"
     BGCOLOR 8 .

DEFINE BUTTON bUpdateContext 
     LABEL "U&pdate Selected" 
     SIZE 18.2 BY 1 TOOLTIP "Update the selected lines in the browser with the entered help context"
     BGCOLOR 8 .

DEFINE BUTTON bUpdateFileName 
     LABEL "&Update Selected" 
     SIZE 18.2 BY 1 TOOLTIP "Update the selected lines in the browser with the entered help filename"
     BGCOLOR 8 .

DEFINE VARIABLE coObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE cHelpContext AS CHARACTER FORMAT "X(256)":U 
     LABEL "Context" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Specify the help context to be applied to the selected lines in the browser." NO-UNDO.

DEFINE VARIABLE cHelpFilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "Help filename" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Specify the help filename to be applied to the selected lines in the browser." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coObject AT ROW 2.1 COL 10.6 COLON-ALIGNED
     bSelect AT ROW 3.14 COL 12.6
     cHelpFilename AT ROW 1 COL 63.8 COLON-ALIGNED
     bUpdateFileName AT ROW 1 COL 116.2
     cHelpContext AT ROW 2.1 COL 63.8 COLON-ALIGNED
     bUpdateContext AT ROW 2.1 COL 116.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 136.6 BY 11.52.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmtlfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmtlfullo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 11.52
         WIDTH              = 136.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME bSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bSelect vTableWin
ON CHOOSE OF bSelect IN FRAME frMain /* Select All */
DO:
  IF SELF:LABEL = "&Select All" 
  THEN DO:
      ghBrowse:SELECT-ALL() NO-ERROR.

      ASSIGN SELF:LABEL   = "&Deselect All"
             SELF:TOOLTIP = "Deselects all selected rows in the browser.".
  END.
  ELSE DO:
      ghBrowse:DESELECT-ROWS().

      ASSIGN SELF:LABEL   = "&Select All"
             SELF:TOOLTIP = "Selects all rows, a help filename and context can then applied to selected rows".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bUpdateContext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bUpdateContext vTableWin
ON CHOOSE OF bUpdateContext IN FRAME frMain /* Update Selected */
DO:
    DEFINE VARIABLE cButtonPressed AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.

    IF ghBrowse:NUM-SELECTED-ROWS = 0 
    THEN DO:
        RUN showMessages IN gshSessionManager (INPUT "You have not selected any rows in the browser.  To update multiple rows, enter the help context address, select the rows you wish to update by pressing CTRL and clicking on the row, and press this button again.  Note that you can update individual rows directly, by entering the help filename and help context in the browser row itself.",
                                               INPUT "INF":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Information",
                                               INPUT NO,
                                               INPUT THIS-PROCEDURE,
                                               OUTPUT cButtonPressed).
        APPLY "ENTRY":U TO ghBrowse.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        DEFINE VARIABLE iCnt AS INTEGER    NO-UNDO.

        ASSIGN hColumn = WIDGET-HANDLE(ENTRY(5,gcBrowseColHdls)).

        DO iCnt = 1 TO ghBrowse:NUM-SELECTED-ROWS:
            ghBrowse:FETCH-SELECTED-ROW(iCnt).

            ASSIGN ttHelp.cHelpContext  = cHelpContext:SCREEN-VALUE                 
                   hColumn:SCREEN-VALUE = ttHelp.cHelpContext.
            APPLY "value-changed":U TO hColumn.
        END.

        ghBrowse:FETCH-SELECTED-ROW(1).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bUpdateFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bUpdateFileName vTableWin
ON CHOOSE OF bUpdateFileName IN FRAME frMain /* Update Selected */
DO:
  DEFINE VARIABLE cButtonPressed AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.

  IF ghBrowse:NUM-SELECTED-ROWS = 0 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "You have not selected any rows in the browser.  To update multiple rows, enter a help filename, select the rows you wish to update by pressing CTRL and clicking on the row, and press this button again.  Note that you can update individual rows directly, by entering the help filename and help context in the browser row itself.",
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Information",
                                             INPUT NO,
                                             INPUT THIS-PROCEDURE,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO ghBrowse.
      RETURN NO-APPLY.
  END.
  ELSE DO:
      DEFINE VARIABLE iCnt AS INTEGER    NO-UNDO.

      ASSIGN hColumn = WIDGET-HANDLE(ENTRY(4,gcBrowseColHdls)).

      DO iCnt = 1 TO ghBrowse:NUM-SELECTED-ROWS:
          ghBrowse:FETCH-SELECTED-ROW(iCnt).

          ASSIGN ttHelp.cHelpFileName = cHelpFileName:SCREEN-VALUE                 
                 hColumn:SCREEN-VALUE = ttHelp.cHelpFileName.
          APPLY "value-changed":U TO hColumn.
      END.

      ghBrowse:FETCH-SELECTED-ROW(1).
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObject vTableWin
ON VALUE-CHANGED OF coObject IN FRAME frMain /* Object */
DO:
DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.

ASSIGN hColumn = ghBrowse:CURRENT-COLUMN
       rRow    = ghBuffer:ROWID.

ASSIGN cQuery  = "FOR EACH ttHelp NO-LOCK":U
               + (IF coObject:SCREEN-VALUE = "<All>":U THEN "":U ELSE  " WHERE ttHelp.cObjectName = '":U + coObject:SCREEN-VALUE + "'":U)
               + (IF gcSortBy = ? 
                  OR gcSortBy = "":U
                  THEN " BY ttHelp.cContainerFileName BY ttHelp.cObjectName":U
                  ELSE " BY " + gcSortBy).

ghQuery:QUERY-PREPARE(cQuery).
ghQuery:QUERY-OPEN().

IF ghQuery:NUM-RESULTS > 0 
THEN DO:
    ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
    ghBrowse:CURRENT-COLUMN = hColumn.
    APPLY "HOME":U TO ghBrowse.
    APPLY 'ENTRY':U TO ghBrowse.
    APPLY 'VALUE-CHANGED':U TO ghBrowse.
END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addWidgets vTableWin 
PROCEDURE addWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Add widgets to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject                 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phFrame                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cAllFieldHandles  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDFFieldName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDFLabel         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLabel            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNewObject        AS HANDLE     NO-UNDO.

DEFINE VARIABLE hSDFFrame         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidgetGroup      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iHandleCnt        AS INTEGER    NO-UNDO.

ASSIGN hwidgetGroup   = phFrame:HANDLE
       hwidgetGroup   = hwidgetGroup:FIRST-CHILD
       hWidget        = hwidgetGroup:FIRST-CHILD.

widget-walk:
REPEAT WHILE VALID-HANDLE (hWidget):

  IF LOOKUP(hWidget:TYPE, "browse,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) > 0 
  THEN DO:
      ASSIGN cFieldName = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
    
      IF (cFieldName = ? OR cFieldName = "":U) AND hWidget:TYPE <> "LITERAL" 
      THEN DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
      END.

      /* Avoid duplicates */

      IF CAN-FIND(FIRST ttHelp
                  WHERE ttHelp.dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
                    AND ttHelp.cContainerFileName = gcCallerName
                    AND ttHelp.cObjectName = pcObjectName
                    AND ttHelp.cWidgetType = hWidget:TYPE
                    AND ttHelp.cWidgetName = cFieldName) 
      THEN DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
      END.

      CREATE ttHelp.
      ASSIGN ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
             ttHelp.cContainerFileName = gcCallerName 
             ttHelp.cObjectName        = pcObjectName
             ttHelp.cWidgetName        = cFieldName
             ttHelp.cHelpFilename      = "":U
             ttHelp.cHelpContext       = "":U
             ttHelp.cWidgetType        = hWidget:TYPE
             ttHelp.cOriginalLabel     = IF CAN-QUERY(hWidget,"LABEL":U) AND hWidget:LABEL <> ? THEN hWidget:LABEL 
                                         ELSE 
                                           IF CAN-QUERY(hWidget,"SCREEN-VALUE":U) AND hWidget:SCREEN-VALUE <> ? 
                                             THEN hWidget:SCREEN-VALUE 
                                             ELSE "":U.

  END.  /* valid widget type */
  ELSE IF hWidget:TYPE = "frame":U THEN   /* SmartDataFields */
  DO:

    /* We need the procedure handle of the frame. */
    {get allFieldHandles cAllFieldHandles phObject}.
    proc-blk:
    DO iHandleCnt = 1 TO NUM-ENTRIES(cAllFieldHandles):
      ASSIGN hNewObject = WIDGET-HANDLE(ENTRY(iHandleCnt, cAllFieldHandles)) NO-ERROR.
      IF hNewObject:TYPE = "PROCEDURE":U THEN DO:
        {get containerHandle hSDFFrame hNewObject}.
        IF hSDFFrame = hWidget THEN
          LEAVE proc-blk.
      END.
    END.

    IF VALID-HANDLE(hNewObject) AND hNewObject:TYPE = "procedure":U THEN 
    DO:
   
      ASSIGN 
        cSDFFieldName = DYNAMIC-FUNCTION("getFieldName":U IN hNewObject)
        cSDFLabel     = DYNAMIC-FUNCTION("getLabel":U IN hNewObject) NO-ERROR.
     
      IF CAN-FIND(FIRST ttHelp
                  WHERE ttHelp.dLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
                    AND ttHelp.cContainerFileName = gcCallerName
                    AND ttHelp.cObjectName = pcObjectName
                    AND ttHelp.cWidgetType = hWidget:TYPE
                    AND ttHelp.cWidgetName = cSDFFieldName) 
      THEN DO:
          ASSIGN hWidget = hWidget:NEXT-SIBLING.
          NEXT widget-walk.
      END.

      CREATE ttHelp.
      ASSIGN ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
             ttHelp.cContainerFileName = gcCallerName 
             ttHelp.cObjectName        = pcObjectName
             ttHelp.cWidgetName        = cSDFFieldName
             ttHelp.cHelpFilename      = "":U
             ttHelp.cHelpContext       = "":U
             ttHelp.cWidgetType        = hWidget:TYPE
             ttHelp.cOriginalLabel     = cSDFLabel.
    END.
  END.

  ASSIGN hWidget = hWidget:NEXT-SIBLING.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_language.language_nameKeyFieldgsc_language.language_objFieldLabelLanguageFieldTooltipSelect the help language, from the list.KeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_language NO-LOCK BY gsc_language.language_nameQueryTablesgsc_languageSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5SortnoComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamelanguage_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLanguage ).
       RUN repositionObject IN hLanguage ( 1.00 , 12.60 ) NO-ERROR.
       RUN resizeObject IN hLanguage ( 1.05 , 37.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hLanguage ,
             coObject:HANDLE IN FRAME frMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseValueChanged vTableWin 
PROCEDURE browseValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Disable global setting for window titles as these cannot be global
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hColumn                   AS HANDLE   NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER  NO-UNDO.

IF NOT ghBuffer:AVAILABLE THEN RETURN.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic browser onto viewer for help
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowseLabels             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.

/* Populate temp-table */

ASSIGN ghTable  = TEMP-TABLE ttHelp:HANDLE
       ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE. 

RUN buildTempTable (INPUT NO).

CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(ghBuffer).
ASSIGN cQuery = "FOR EACH ttHelp NO-LOCK BY ttHelp.cContainerFileName BY ttHelp.cObjectName":U.
ghQuery:QUERY-PREPARE(cQuery).

/* Create the dynamic browser here */

/* make the viewer as big as it can be to fit on tab page */

DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

{get ContainerSource hContainerSource}.
{get ContainerHandle hWindow hContainerSource}.

CREATE BROWSE ghBrowse
       ASSIGN FRAME                       = FRAME {&FRAME-NAME}:handle
              ROW                         = 4.8
              COL                         = 1.5
              TOOLTIP                     = "Update the help filename, context and delete flag, or use the 'Update Selected' function to update multiple rows."
              SEPARATORS                  = TRUE
              ROW-MARKERS                 = FALSE
              EXPANDABLE                  = TRUE
              COLUMN-RESIZABLE            = TRUE
              COLUMN-SCROLLING            = TRUE
              ALLOW-COLUMN-SEARCHING      = TRUE
              MULTIPLE                    = YES
              READ-ONLY                   = NO
              QUERY                       = ghQuery
              VIEW-FIRST-COLUMN-ON-REOPEN = TRUE
        TRIGGERS:            
          ON 'row-leave':U
            PERSISTENT RUN rowLeave IN THIS-PROCEDURE.
          ON 'value-changed':U
            PERSISTENT RUN browseValueChanged IN THIS-PROCEDURE.
          ON 'start-search':U 
            PERSISTENT RUN startSearch IN THIS-PROCEDURE.
        end TRIGGERS.

/* Hide the browse while it is repopulated to avoid flashing */
ghBrowse:VISIBLE = NO.
ghBrowse:SENSITIVE = NO.

/* Add fields to browser */

DEFINE VARIABLE cFieldWidths AS CHARACTER  NO-UNDO INITIAL "18,18,20,20,38,38,8,20,15".

field-loop:
DO iLoop = 1 TO ghBuffer:NUM-FIELDS:

  hCurField = ghBuffer:BUFFER-FIELD(iLoop).

  IF hCurField:DATA-TYPE = "DECIMAL" OR
     hCurField:DATA-TYPE = "HANDLE" THEN NEXT field-loop.

  hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

  IF INDEX(hCurField:NAME, "helpFileName":U) <> 0 
  OR INDEX(hCurField:NAME, "HelpContext":U)  <> 0 
  OR INDEX(hCurField:NAME, "Delete":U)  <> 0 THEN
      ASSIGN hField:READ-ONLY = FALSE.
  ELSE
      ASSIGN hField:READ-ONLY = TRUE.

  ASSIGN hField:WIDTH = INTEGER(ENTRY(iLoop, cFieldWidths)).

  /* Build up the list of browse columns for use in rowDisplay */
  IF VALID-HANDLE(hField) THEN
      gcBrowseColHdls = gcBrowseColHdls + (IF gcBrowseColHdls = "":U THEN "":U ELSE ",":U) + STRING(hField).
END.

ASSIGN ghObjectField = ghBuffer:BUFFER-FIELD("cObjectName":U)
       ghTypeField   = ghBuffer:BUFFER-FIELD("cWidgetType":U).

ghBrowse:NUM-LOCKED-COLUMNS = 3.

/* Now open the query */
ghQuery:QUERY-OPEN().
APPLY "VALUE-CHANGED":U TO ghBrowse.

/* And show the browse to the user */

FRAME {&FRAME-NAME}:VISIBLE = FALSE.
ghBrowse:VISIBLE = YES.
ghBrowse:SENSITIVE = YES.
FRAME {&FRAME-NAME}:VISIBLE = TRUE.

APPLY "ENTRY":U TO ghBrowse.
ghBrowse:SELECT-ROW(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempTable vTableWin 
PROCEDURE buildTempTable :
/*------------------------------------------------------------------------------
  Purpose:     To build temp-table of widgets to translate for language
               selected (or all).
  Parameters:  input open query flag yes/no
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER plOpenQuery              AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cObjectName                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectList                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hFrame                          AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hTempTable                      AS HANDLE     NO-UNDO.

/* 1st empty current temp-table contents */
EMPTY TEMP-TABLE ttHelp.

DO WITH FRAME {&FRAME-NAME}:

    coObject:LIST-ITEMS = "<All>".

    /* Add a help record for system wide help */
    CREATE ttHelp.
    ASSIGN ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
           ttHelp.cContainerFileName = "":U
           ttHelp.cHelpFilename      = "":U
           ttHelp.cHelpContext       = "":U.

    /* Add the container, no object or widget specified.  This is for container help. */
    CREATE ttHelp.
    ASSIGN ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
           ttHelp.cContainerFileName = gcCallerName
           ttHelp.cHelpFilename      = "":U
           ttHelp.cHelpContext       = "":U.

  /* 
     Now go through all calling container, container targets and get all
     widgets in these for translation - watch out for browsers and SDF's.
     Always use container object name for translations.
  */
  ASSIGN cObjectList = DYNAMIC-FUNCTION('linkHandles' IN ghCallerHandle, 'Container-Target':U).

  object-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cObjectList):

    ASSIGN hObject = ?
           hObject = WIDGET-HANDLE(ENTRY(iLoop, cObjectList)) NO-ERROR. 

    IF NOT VALID-HANDLE(hObject) THEN NEXT object-loop.

    /* get object name */
    ASSIGN cObjectName = hObject:FILE-NAME.
    ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hObject) NO-ERROR.
    IF cObjectName = "":U OR cObjectName = ? THEN
      ASSIGN cObjectName = hObject:FILE-NAME.

    /* strip off path if any */
    ASSIGN cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
           cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).

    /* ignore SDO's and windows launcched from container window */

    ASSIGN cObjectType = "":U.
    ASSIGN cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hObject) NO-ERROR.

    IF cObjectType = "":U THEN NEXT object-loop.
    IF INDEX(cObjectType,"window":U) <> 0          AND hObject <> ghCallerHandle THEN NEXT object-loop.
    IF INDEX(cObjectType,"smartdataobject":U) <> 0 AND hObject <> ghCallerHandle THEN NEXT object-loop.
    IF INDEX(cObjectType,"smartBusinessobject":U) <> 0 AND hObject <> ghCallerHandle THEN NEXT object-loop.

    /* Add the container, object record. This is for object help */

    IF NOT CAN-FIND(FIRST ttHelp
                    WHERE ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
                      AND ttHelp.cContainerFileName = gcCallerName
                      AND ttHelp.cObjectName        = cObjectName)
    THEN DO:
        CREATE ttHelp.
        ASSIGN ttHelp.dLanguageObj       = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hLanguage))
               ttHelp.cContainerFileName = gcCallerName
               ttHelp.cObjectName        = cObjectName
               ttHelp.cHelpFilename      = "":U
               ttHelp.cHelpContext       = "":U.

        /* Add the object to the object combo */

        IF INDEX(coObject:LIST-ITEMS, cObjectName) = ?
        OR INDEX(coObject:LIST-ITEMS, cObjectName) = 0 THEN
            ASSIGN coObject:LIST-ITEMS = coObject:LIST-ITEMS + ",":U + cObjectName.
    END.

    /* 
       have a valid object - walk widget tree for object to get objects widgets
       for help
    */

    hFrame = DYNAMIC-FUNCTION("getContainerHandle":U IN hObject).
    IF hFrame:TYPE = "window":U THEN
      hFrame = hFrame:FIRST-CHILD.

    IF hFrame:NAME = "FolderFrame":U THEN. /* don't do a thing */
    ELSE
        RUN addWidgets (INPUT hObject, INPUT cObjectName, INPUT hFrame). 
  END. /* object-loop */

  /* Now got all translation widgets - get any existing translations */

  ASSIGN hTempTable = TEMP-TABLE ttHelp:HANDLE.

  RUN getHelp IN gshSessionManager (INPUT-OUTPUT TABLE-HANDLE hTempTable).

  coObject:SCREEN-VALUE = coObject:ENTRY(1).
END.

/* Re-open query if required */
IF plOpenQuery THEN
DO:
  ghQuery:QUERY-OPEN().
  APPLY "VALUE-CHANGED":U TO ghBrowse.
  APPLY "ENTRY":U TO ghBrowse.
END.

/* Reset panel buttons to no changes */

IF glModified THEN
DO:
  ASSIGN glModified = FALSE.
  PUBLISH 'updateState' ('updatecomplete').
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboEntry vTableWin 
PROCEDURE comboEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcScreenValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phCombo       AS HANDLE     NO-UNDO.

  IF phCombo = hLanguage THEN
      ASSIGN gcSavedLanguage = pcScreenValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcScreenValue   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phCombo         AS HANDLE     NO-UNDO.

  IF phCombo = hLanguage 
  THEN DO:
      IF gcSavedLanguage <> pcKeyFieldValue AND glModified 
      THEN DO:
          DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
          DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

          RUN askQuestion IN gshSessionManager (INPUT "You have unsaved help contexts that will be lost if you change the language, continue?",    /* messages */
                                                INPUT "&Yes,&No":U,     /* button list */
                                                INPUT "&No":U,         /* default */
                                                INPUT "&No":U,          /* cancel */
                                                INPUT "Unsaved Translations Exist":U, /* title */
                                                INPUT "":U,             /* datatype */
                                                INPUT "":U,             /* format */
                                                INPUT-OUTPUT cAnswer,   /* answer */
                                                OUTPUT cButton          /* button pressed */
                                                ).
          IF cButton = "&No":U OR cButton = "No":U 
          THEN DO:
              DYNAMIC-FUNCTION("setDataValue":U IN hLanguage,gcSavedLanguage).
              RETURN NO-APPLY.
          END.
          ELSE DO:
              ASSIGN gcSavedLanguage = pcKeyFieldValue.
              RUN buildTempTable (INPUT YES).
          END.
      END.
      ELSE 
          IF gcSavedLanguage <> pcKeyFieldValue 
          THEN DO:
              ASSIGN gcSavedLanguage = pcKeyFieldValue.
              RUN buildTempTable (INPUT YES).
          END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* tidy up dynamic object handles */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  /* save handle of calling container */
  ghContainerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).
  IF VALID-HANDLE(ghContainerHandle) THEN
      ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN ghContainerHandle).

  IF VALID-HANDLE(ghCallerHandle) THEN
    gcCallerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN ghCallerHandle) NO-ERROR.  
  
  {get ContainerHandle ghWindow ghContainerHandle}.
  {get ContainerHandle ghCallerWindow ghCallerHandle}.
  
  SUBSCRIBE TO "comboEntry":U IN THIS-PROCEDURE.
  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

  ghWindow:TITLE = "Map Help Context for Window: " + ghCallerWindow:TITLE.

  RUN SUPER.
  
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
    {set OpenOnInit FALSE hDataSource}.

  RUN displayFields (?).
  RUN enableField IN hLanguage.
  
  RUN setDefaults.  
  RUN buildBrowser. 
  RUN valueChanged IN hLanguage.
  
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS,
                    INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  ASSIGN
      lPreviouslyHidden              = FRAME {&FRAME-NAME}:HIDDEN
      FRAME {&FRAME-NAME}:HIDDEN     = TRUE
      FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.

  IF FRAME {&FRAME-NAME}:HEIGHT-CHARS < pdHeight OR
     FRAME {&FRAME-NAME}:WIDTH-CHARS  < pdWidth  THEN
  DO:
    IF pdHeight > FRAME {&FRAME-NAME}:HEIGHT-CHARS THEN
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.

    IF pdWidth > FRAME {&FRAME-NAME}:WIDTH-CHARS THEN
      FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  END.
  
  IF VALID-HANDLE(ghBrowse) THEN
    ASSIGN
        ghBrowse:HEIGHT-CHARS = pdHeight - ghBrowse:ROW + 1.00
        ghBrowse:WIDTH-CHARS  = pdWidth  - 1.12.

  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowleave vTableWin 
PROCEDURE rowleave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hCol                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.

IF ghBrowse:CURRENT-ROW-MODIFIED 
THEN DO:
    REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
        hCol = ghBrowse:GET-BROWSE-COLUMN(iLoop).
        IF hCol:MODIFIED 
        THEN DO:
            RUN valueChanged.
            hField = hCol:BUFFER-FIELD.
            /* if buff-field-hdl is unknown, this is a calculated field
               and cannot be updated */
            IF hField NE ? THEN
                hField:BUFFER-VALUE = hCol:SCREEN-VALUE.

            ASSIGN hCol:MODIFIED = NO.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults vTableWin 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dUserObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSrcLang            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL    NO-UNDO.

  ASSIGN dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                             INPUT "CurrentUserObj":U,
                                             INPUT NO)) NO-ERROR.
  
  ASSIGN dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                        INPUT "currentLanguageObj":U,
                                                        INPUT NO)) NO-ERROR.
  
  IF dCurrentLanguageObj <> 0 AND dCurrentLanguageObj <> ? THEN
      DYNAMIC-FUNCTION("setDataValue":U IN hLanguage, STRING(dCurrentLanguageObj)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startsearch vTableWin 
PROCEDURE startsearch :
/*------------------------------------------------------------------------------
  Purpose:     Implement column sorting
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}.

  ASSIGN hColumn = ghBrowse:CURRENT-COLUMN
         rRow    = ghBuffer:ROWID.

  IF VALID-HANDLE( hColumn ) 
  THEN DO:
      ASSIGN gcSortBy = (IF hColumn:TABLE <> ? 
                         THEN (hColumn:TABLE + '.':U + hColumn:NAME)
                         ELSE  hColumn:NAME)
             cQuery  = "FOR EACH ttHelp NO-LOCK"
                     + (IF coObject:SCREEN-VALUE = "<All>" THEN "":U ELSE " WHERE ttHelp.cObjectName = '" + coObject:SCREEN-VALUE + "'":U)
                     + " BY ":U + gcSortBy.

      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      IF ghQuery:NUM-RESULTS > 0 
      THEN DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Write the temp-table to the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.

  /* Save our data */
  
  APPLY "row-leave":U TO ghBrowse.

  RUN updateHelp IN gshSessionManager (INPUT TABLE ttHelp) NO-ERROR.
  ASSIGN cReturnValue = RETURN-VALUE.

  IF ERROR-STATUS:ERROR 
  OR cReturnValue <> "":U
  THEN DO:
      RUN showMessages IN gshSessionManager 
                                  (INPUT {af/sup2/aferrortxt.i 'AF' '40' '?' '?' 'cReturnValue'},
                                   INPUT "ERR":U,
                                   INPUT "OK":U,
                                   INPUT "OK":U,
                                   INPUT "OK":U,
                                   INPUT "Help Context Update Error",
                                   INPUT NOT SESSION:REMOTE,
                                   INPUT THIS-PROCEDURE,
                                   OUTPUT cButton).
      RETURN ERROR cReturnValue.
  END.

  {set DataModified FALSE}.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged vTableWin 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Procedure fired on value changed of any of the widgets on the viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT glModified 
  THEN DO:
      ASSIGN glModified = TRUE.
      {set DataModified TRUE}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

