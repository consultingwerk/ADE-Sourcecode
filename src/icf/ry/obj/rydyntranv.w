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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydyntranv.w

  Description:  Translation Viewer

  Purpose:      Translation Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7405   UserRef:    
                Date:   27/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

  (v:010001)    Task:           0   UserRef:    
                Date:   11/19/2001  Author:     Mark Davies (MIP)

  Update Notes: Changed Combo delimiter to CHR(3) - avoid -E parameter errors.

  (v:010002)    Task:           0   UserRef:    
                Date:   01/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3704 - Can't translate text treeview items.
                Allow translation of plain text nodes.

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

&scop object-name       rydyntranv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

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

{af/sup2/afttcombo.i}
{af/app/aftttranslate.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coLanguage 
&Scoped-Define DISPLAYED-OBJECTS coLanguage fiContainer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coLanguage AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Language" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 47.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiContainer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 47.2 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coLanguage AT ROW 1.19 COL 13 COLON-ALIGNED
     fiContainer AT ROW 1.19 COL 74.6 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 124.2 BY 11.33.


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
         HEIGHT             = 11.33
         WIDTH              = 124.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiContainer IN FRAME frMain
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME coLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage sObject
ON ENTRY OF coLanguage IN FRAME frMain /* Language */
DO:
  ASSIGN gcSavedLanguage = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage sObject
ON VALUE-CHANGED OF coLanguage IN FRAME frMain /* Language */
DO:
  IF gcSavedLanguage <> SELF:SCREEN-VALUE AND glModified THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
    RUN askQuestion IN gshSessionManager (INPUT "You have unsaved translations that will be lost if you change the language, continue?",    /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&No":U,         /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Unsaved Translations Exist":U, /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&No":U OR cButton = "No":U THEN
    DO:
      SELF:SCREEN-VALUE = gcSavedLanguage.
      RETURN NO-APPLY.
    END.
    ELSE
    DO:
      ASSIGN gcSavedLanguage = SELF:SCREEN-VALUE.
      RUN buildTempTable (INPUT YES).
    END.
  END.
  ELSE IF gcSavedLanguage <> SELF:SCREEN-VALUE THEN
  DO:
    ASSIGN gcSavedLanguage = SELF:SCREEN-VALUE.
    RUN buildTempTable (INPUT YES).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addFolderTabs sObject 
PROCEDURE addFolderTabs :
/*------------------------------------------------------------------------------
  Purpose:     Add folder tabs to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject                 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phFrame                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cFolderLabels                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLabel                          AS CHARACTER  NO-UNDO.

cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN phObject).

label-loop:
DO iLoop = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):

  ASSIGN cLabel = ENTRY(iLoop, cFolderLabels, "|":U).

  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = coLanguage
    ttTranslate.cObjectName = pcObjectName
    ttTranslate.lGlobal = NO
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "TAB":U
    ttTranslate.cWidgetName = "TAB":U
    ttTranslate.hWidgetHandle = phObject
    ttTranslate.iWidgetEntry = iLoop
    ttTranslate.cOriginalLabel = cLabel
    ttTranslate.cTranslatedLabel = "":U
    ttTranslate.cOriginalTooltip = "":U
    ttTranslate.cTranslatedTooltip = "":U
    .

END.  /* label-loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNodes sObject 
PROCEDURE addNodes :
/*------------------------------------------------------------------------------
  Purpose:     Add folder tabs to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodes                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeText                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.

cNodes = DYNAMIC-FUNCTION("getTranslatableNodes":U IN ghCallerHandle).

IF cNodes = "":U THEN
  RETURN.

label-loop:
DO iLoop = 1 TO NUM-ENTRIES(cNodes, CHR(1)):
  
  cNodeText = "":U.
  ASSIGN cNodeText = TRIM(ENTRY(iLoop, cNodes, CHR(1))) NO-ERROR.
  IF cNodeText = "":U OR
     cNodeText = ? THEN
    NEXT label-loop.

  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = coLanguage
    ttTranslate.cObjectName = pcObjectName
    ttTranslate.lGlobal = NO
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "Node":U
    ttTranslate.cWidgetName = "NODE_":U + cNodeText
    ttTranslate.hWidgetHandle = ?
    ttTranslate.iWidgetEntry = 0
    ttTranslate.cOriginalLabel = cNodeText
    ttTranslate.cTranslatedLabel = "":U
    ttTranslate.cOriginalTooltip = "":U
    ttTranslate.cTranslatedTooltip = "":U
    .

END.  /* label-loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addWidgets sObject 
PROCEDURE addWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Add widgets to translation temp-table
  Parameters:  input object procedure handle
               input object name
               input object frame handle
  Notes:       Recursive procedure to cope with SDF's
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject                 AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phFrame                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE hWidgetGroup                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNewObject                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNewObjectName                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWidget                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel                          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRadioButtons                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iRadioLoop                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBrowseLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hLiteralHandle                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLiteralHandles                 AS CHARACTER  NO-UNDO.

/* for dynamic toolbars - use container object name  (NO - force gloabl rather) */
/* IF phFrame:NAME = "Panel-Frame":U THEN */
/*   ASSIGN pcObjectName = gcCallerName.  */

ASSIGN
  hwidgetGroup = phFrame:HANDLE
  hwidgetGroup = hwidgetGroup:FIRST-CHILD
  hWidget = hwidgetGroup:FIRST-CHILD
  hLiteralHandle = hWidget.

/* First build list of LITERAL handles that are labels to other widgets */
cLiteralHandles = "":U.
literal-widget-walk:
REPEAT WHILE VALID-HANDLE (hLiteralHandle):
  IF LOOKUP(hLiteralHandle:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0 THEN DO:
    ASSIGN hLiteralHandle = hLiteralHandle:NEXT-SIBLING.
    NEXT literal-widget-walk.
  END.
  IF CAN-QUERY(hLiteralHandle, "SIDE-LABEL-HANDLE":U) AND hLiteralHandle:SIDE-LABEL-HANDLE <> ? THEN
    ASSIGN cLiteralHandles = IF cLiteralHandles = "":U
                                THEN STRING(hLiteralHandle:SIDE-LABEL-HANDLE)
                                ELSE cLiteralHandles + ",":U + STRING(hLiteralHandle:SIDE-LABEL-HANDLE).
  ASSIGN hLiteralHandle = hLiteralHandle:NEXT-SIBLING.
END.

widget-walk:
REPEAT WHILE VALID-HANDLE (hWidget):
  IF LOOKUP(hWidget:TYPE, "literal,text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) > 0 THEN
  DO:
    /* Check that the literal widget is not a label for another widget */
    IF hWidget:TYPE = "LITERAL" AND
       LOOKUP(STRING(hWidget),cLiteralHandles) > 0 THEN DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.
    
    ASSIGN
      cFieldName = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
    
    IF hWidget:TYPE = "LITERAL" AND
       (cFieldName = ? OR
        cFieldName = "":U) THEN
      ASSIGN cFieldname = IF CAN-QUERY(hWidget,"SCREEN-VALUE":U) AND hWidget:SCREEN-VALUE <> ? THEN hWidget:SCREEN-VALUE ELSE "TEXT":U.

    IF (cFieldName = ? OR cFieldName = "":U) AND hWidget:TYPE <> "LITERAL" THEN
    DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.

    /* Avoid duplicates */
    IF CAN-FIND(FIRST ttTranslate
                WHERE ttTranslate.dLanguageObj = coLanguage
                  AND ttTranslate.cObjectName = pcObjectName
                  AND ttTranslate.cWidgetType = hWidget:TYPE
                  AND ttTranslate.cWidgetName = cFieldName) THEN
    DO:
      ASSIGN hWidget = hWidget:NEXT-SIBLING.
      NEXT widget-walk.
    END.

    IF hWidget:TYPE <> "RADIO-SET":U THEN
    DO:
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = coLanguage
        ttTranslate.cObjectName = pcObjectName
        ttTranslate.lGlobal = (phFrame:NAME = "Panel-Frame":U)
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = hWidget:TYPE
        ttTranslate.cWidgetName = cFieldName
        ttTranslate.hWidgetHandle = hWidget
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = (IF CAN-QUERY(hWidget,"LABEL":U) AND hWidget:LABEL <> ? THEN hWidget:LABEL ELSE IF CAN-QUERY(hWidget,"SCREEN-VALUE":U) AND hWidget:SCREEN-VALUE <> ? THEN hWidget:SCREEN-VALUE ELSE "":U)
        ttTranslate.cTranslatedLabel = "":U
        ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
        ttTranslate.cTranslatedTooltip = "":U
        .

      /* deal with SDF's where label is separate */
      IF INDEX(pcObjectName, ":":U) <> 0 AND ttTranslate.cOriginalLabel = "":U THEN
      DO:
        ASSIGN hLabel = ?.
        ASSIGN hLabel = DYNAMIC-FUNCTION("getLabelHandle":U IN phObject) NO-ERROR.
        IF VALID-HANDLE(hLabel) AND hLabel:SCREEN-VALUE <> ? AND hLabel:SCREEN-VALUE <> "":U THEN
          ttTranslate.cOriginalLabel = REPLACE(hLabel:SCREEN-VALUE,":":U,"":U).
      END.

    END. /* not a radio-set */
    ELSE  /* It is a radio-set */
    DO:
      ASSIGN cRadioButtons = hWidget:RADIO-BUTTONS.
      radio-loop:
      DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:

        CREATE ttTranslate.
        ASSIGN
          ttTranslate.dLanguageObj = coLanguage
          ttTranslate.cObjectName = pcObjectName
          ttTranslate.lGlobal = NO
          ttTranslate.lDelete = NO
          ttTranslate.cWidgetType = hWidget:TYPE
          ttTranslate.cWidgetName = cFieldName
          ttTranslate.hWidgetHandle = hWidget
          ttTranslate.iWidgetEntry = (iRadioLoop + 1) / 2
          ttTranslate.cOriginalLabel = ENTRY(iRadioLoop, cRadioButtons)
          ttTranslate.cTranslatedLabel = "":U
          ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
          ttTranslate.cTranslatedTooltip = "":U
          .

      END. /* radio-loop */
    END. /* radio-set */
  END.  /* valid widget type */
  ELSE IF INDEX(hWidget:TYPE,"browse":U) <> 0 THEN
  DO:
    ASSIGN
      hColumn = hWidget:FIRST-COLUMN.
    col-loop:
    DO iBrowseLoop = 1 TO hWidget:NUM-COLUMNS:
      ASSIGN
        cFieldName = (IF CAN-QUERY(hColumn, "TABLE":U) AND LENGTH(hColumn:TABLE) > 0 AND hColumn:TABLE <> "RowObject":U THEN (hColumn:TABLE + ".":U) ELSE "":U) + hColumn:NAME.

      IF NOT VALID-HANDLE(hColumn) THEN LEAVE col-loop.

      IF cFieldName = ? OR cFieldName = "":U THEN
      DO:
        ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
        NEXT col-loop.
      END.

      /* Avoid duplicates */
      IF CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.dLanguageObj = 0
                    AND ttTranslate.cObjectName = cObjectName
                    AND ttTranslate.cWidgetType = hWidget:TYPE
                    AND ttTranslate.cWidgetName = cFieldName) THEN
      DO:
        ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
        NEXT col-loop.
      END.

      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = coLanguage
        ttTranslate.cObjectName = pcObjectName
        ttTranslate.lGlobal = NO
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = hWidget:TYPE
        ttTranslate.cWidgetName = cFieldName
        ttTranslate.hWidgetHandle = hWidget
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = (IF CAN-QUERY(hColumn,"LABEL":U) AND hColumn:LABEL <> ? THEN hColumn:LABEL ELSE "":U)
        ttTranslate.cTranslatedLabel = "":U
        ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hColumn,"TOOLTIP":U) AND hColumn:TOOLTIP <> ? THEN hColumn:TOOLTIP ELSE "":U)
        ttTranslate.cTranslatedTooltip = "":U
        .

      ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
    END.
  END.
  ELSE IF hWidget:TYPE = "frame":U THEN
  DO:
    /* SDF's have procedure handle in private data of frame, so can get
       real fieldname of SDF using this and change object name to be
       SDF + fieldname so it is unique within container object
    */
    ASSIGN hNewObject = ?.
    ASSIGN hNewObject = WIDGET-HANDLE(hWidget:PRIVATE-DATA) NO-ERROR.
    IF VALID-HANDLE(hNewObject) AND hNewObject:TYPE = "procedure":U THEN
    DO:
      IF LOOKUP("getFieldName":U, hNewObject:INTERNAL-ENTRIES) <> 0 THEN
        ASSIGN cNewObjectName = TRIM(pcObjectName) + ":":U + DYNAMIC-FUNCTION('getFieldName' IN hNewObject). 
      ELSE
      DO:
        /* get object name */
        ASSIGN cNewObjectName = hNewObject:FILE-NAME.
        IF LOOKUP("getLogicalObjectName":U, hNewObject:INTERNAL-ENTRIES) <> 0 THEN
          ASSIGN cNewObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hNewObject).
        IF cNewObjectName = "":U OR cNewObjectName = ? THEN
          ASSIGN cNewObjectName = hNewObject:FILE-NAME.
        /* strip off path if any */
        ASSIGN
          cNewObjectName = LC(TRIM(REPLACE(cNewObjectName,"\":U,"/":U)))
          cNewObjectName = SUBSTRING(cNewObjectName,R-INDEX(cNewObjectName,"/":U) + 1)
          .
      END.
    END.
    ELSE
      ASSIGN
        hNewObject = phObject
        cNewObjectName = pcObjectName
        .
    RUN addWidgets (INPUT hNewObject, INPUT cNewObjectName, INPUT hWidget). /* SDF */
  END.

  ASSIGN hWidget = hWidget:NEXT-SIBLING.
END.  /* widget-walk */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseValueChanged sObject 
PROCEDURE browseValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Disable global setting for window titles as these cannot be global
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hColumn                   AS HANDLE   NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER  NO-UNDO.

IF NOT ghBuffer:AVAILABLE THEN RETURN.

ASSIGN
  hColumn = ghBrowse:FIRST-COLUMN
  NO-ERROR.

column-loop:
DO iLoop = 1 TO ghBrowse:NUM-COLUMNS:

  IF hColumn:LABEL = "Global":U THEN
  DO:
    IF ghObjectField:BUFFER-VALUE = "":U OR 
       ghObjectField:BUFFER-VALUE = "rydyntoolt.w":U OR 
       ghTypeField:BUFFER-VALUE = "title":U OR
       ghTypeField:BUFFER-VALUE = "tab":U OR
       NUM-ENTRIES(ghObjectField:BUFFER-VALUE,":":U) = 2 /* SDF */ THEN
    DO:
      hColumn:READ-ONLY = TRUE.
    END.
    ELSE
    DO:
      hColumn:READ-ONLY = FALSE.
    END.
  END.

  IF hColumn:LABEL = "Translated Tooltip":U THEN
  DO:
    IF ghTypeField:BUFFER-VALUE = "title":U OR
       ghTypeField:BUFFER-VALUE = "tab":U THEN
    DO:
      hColumn:READ-ONLY = TRUE.
    END.
    ELSE
    DO:
      hColumn:READ-ONLY = FALSE.
    END.
  END.

  ASSIGN hColumn = hColumn:NEXT-COLUMN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser sObject 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Construct dynamic browser onto viewer for translations
  Parameters:  input handle of lookup SDF
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookup                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValue                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowseLabels             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.

/* populate temp-table */
ASSIGN
  ghTable = TEMP-TABLE ttTranslate:HANDLE
  ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
  . 

RUN buildTempTable (INPUT NO).

CREATE QUERY ghQuery.
ghQuery:ADD-BUFFER(ghBuffer).
ASSIGN cQuery = "FOR EACH ttTranslate NO-LOCK":U.
ghQuery:QUERY-PREPARE(cQuery).

/* Create the dynamic browser here */

/* make the viewer as big as it can be to fit on tab page */
DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
DEFINE VARIABLE dHeight               AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWidth                AS DECIMAL NO-UNDO.

FRAME {&FRAME-NAME}:HEIGHT-PIXELS = ghWindow:HEIGHT-PIXELS - 70.
FRAME {&FRAME-NAME}:WIDTH-PIXELS = ghWindow:WIDTH-PIXELS - 28.

CREATE BROWSE ghBrowse
       ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
              ROW              = 2.5
              COL              = 1.5
              WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS - 2
              HEIGHT-PIXELS    = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40
              SEPARATORS       = TRUE
              ROW-MARKERS      = FALSE
              EXPANDABLE       = TRUE
              COLUMN-RESIZABLE = TRUE
              COLUMN-SCROLLING = TRUE
              ALLOW-COLUMN-SEARCHING = TRUE
              READ-ONLY        = NO
              QUERY            = ghQuery
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
field-loop:
DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
  hCurField = ghBuffer:BUFFER-FIELD(iLoop).

  IF hCurField:DATA-TYPE = "DECIMAL" OR
     hCurField:DATA-TYPE = "HANDLE" THEN NEXT field-loop.

  hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).

  IF INDEX(hCurField:NAME, "translated":U) <> 0 OR 
     INDEX(hCurField:NAME, "global":U) <> 0 OR
     INDEX(hCurField:NAME, "delete":U) <> 0 THEN
    ASSIGN
      hField:READ-ONLY = FALSE.
  ELSE
    ASSIGN
      hField:READ-ONLY = TRUE.

  /* Build up the list of browse columns for use in rowDisplay */
  IF VALID-HANDLE(hField) THEN
    cBrowseColHdls = cBrowseColHdls + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                     + STRING(hField).
END.

ASSIGN
  ghObjectField = ghBuffer:BUFFER-FIELD("cObjectName":U)
  ghGlobalField = ghBuffer:BUFFER-FIELD("lGlobal":U)
  ghTypeField = ghBuffer:BUFFER-FIELD("cWidgetType":U)
  .

ghBrowse:NUM-LOCKED-COLUMNS = 0.

/* Now open the query */
ghQuery:QUERY-OPEN().
APPLY "VALUE-CHANGED":U TO ghBrowse.

/* And show the browse to the user */
FRAME {&FRAME-NAME}:VISIBLE = FALSE.
ghBrowse:VISIBLE = YES.
ghBrowse:SENSITIVE = YES.
FRAME {&FRAME-NAME}:VISIBLE = TRUE.

APPLY "ENTRY":U TO ghBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempTable sObject 
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

/* 1st empty current temp-table contents */
EMPTY TEMP-TABLE ttTranslate.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN coLanguage.

  /* Add entry for window title */
  CREATE ttTranslate.
  ASSIGN
    ttTranslate.dLanguageObj = coLanguage
    ttTranslate.cObjectName = gcCallerName
    ttTranslate.lGlobal = NO
    ttTranslate.lDelete = NO
    ttTranslate.cWidgetType = "TITLE":U
    ttTranslate.cWidgetName = "TITLE":U
    ttTranslate.hWidgetHandle = ghCallerWindow
    ttTranslate.iWidgetEntry = 0
    ttTranslate.cOriginalLabel = ghCallerWindow:TITLE    
    ttTranslate.cTranslatedLabel = "":U  
    ttTranslate.cOriginalTooltip = "":U  
    ttTranslate.cTranslatedTooltip = "":U
    .  

  /* Now go through all calling container, container targets and get all
     widgets in these for translation - watch out for browsers and SDF's.
     Always use container object name for translations.
  */
  ASSIGN
    cObjectList = /* STRING(ghCallerHandle) + ",":U + */
                  DYNAMIC-FUNCTION('linkHandles' IN ghCallerHandle, 'Container-Target':U)
    .
  object-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cObjectList):
    ASSIGN hObject = ?.
    ASSIGN hObject = WIDGET-HANDLE(ENTRY(iLoop, cObjectList)) NO-ERROR. 
    IF NOT VALID-HANDLE(hObject) THEN NEXT object-loop.
    
    /* get object name */
    ASSIGN cObjectName = hObject:FILE-NAME.
    IF LOOKUP("getLogicalObjectName":U, hObject:INTERNAL-ENTRIES) <> 0 THEN
      ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hObject).
    IF cObjectName = "":U OR cObjectName = ? THEN
      ASSIGN cObjectName = hObject:FILE-NAME.

    /* strip off path if any */
    ASSIGN
      cObjectName = LC(TRIM(REPLACE(cObjectName,"\":U,"/":U)))
      cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1)
      .

    /* ignore SDO's and windows launcched from container window */
    ASSIGN cObjectType = "":U.
    ASSIGN
      cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hObject) NO-ERROR.
    IF cObjectType = "":U THEN NEXT object-loop.
    IF INDEX(cObjectType,"window":U) <> 0 AND hObject <> ghCallerHandle THEN NEXT object-loop.
    IF INDEX(cObjectType,"smartdataobject":U) <> 0 AND hObject <> ghCallerHandle THEN NEXT object-loop.

    /* have a valid object - walk widget tree for object to get objects widgets
       for translation
    */
    hFrame = DYNAMIC-FUNCTION("getContainerHandle":U IN hObject).
    IF hFrame:TYPE = "window":U THEN
      hFrame = hFrame:FIRST-CHILD.

    IF hFrame:NAME = "FolderFrame":U THEN
      RUN addFolderTabs (INPUT hObject, INPUT gcCallerName, INPUT hFrame).
    ELSE
      RUN addWidgets (INPUT hObject, INPUT cObjectName, INPUT hFrame). 
  END. /* object-loop */
  
  IF LOOKUP("getTranslatableNodes":U,ghCallerHandle:INTERNAL-ENTRIES) > 0 THEN
    RUN addNodes (INPUT gcCallerName).

  /* Now got all translation widgets - get any existing translations */
  RUN af/app/afgetmtrnp.p ON gshAstraAppserver (INPUT coLanguage = 0,
                                                INPUT-OUTPUT TABLE ttTranslate).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* save handle of calling container */
  ghContainerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).
  IF VALID-HANDLE(ghContainerHandle) THEN
    ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN ghContainerHandle).
  IF VALID-HANDLE(ghCallerHandle) AND
     LOOKUP("getLogicalObjectName":U, ghCallerHandle:INTERNAL-ENTRIES) > 0 THEN
    gcCallerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN ghCallerHandle).  
  
  {get ContainerHandle ghWindow ghContainerHandle}.
  {get ContainerHandle ghCallerWindow ghCallerHandle}.
  
  ghWindow:TITLE = "Translate Window: " + ghCallerWindow:TITLE.

  RUN populateCombos.
  RUN buildBrowser.

  RUN SUPER.
  
  /* Display current data values */
  DO WITH FRAME {&FRAME-NAME}:
    fiContainer:SCREEN-VALUE = gcCallerName.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos sObject 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coLanguage":U
    ttComboData.hWidget = coLanguage:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_language NO-LOCK BY gsc_language.language_name":U
    ttComboData.cBufferList = "gsc_language":U
    ttComboData.cKeyFieldName = "gsc_language.language_obj":U
    ttComboData.cDescFieldNames = "gsc_language.language_name":U
    ttComboData.cDescSubstitute = "&1":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = CHR(3)
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .
  coLanguage:DELIMITER = CHR(3).

  /* build combo list-item pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coLanguage":U.

  /* and set-up combos */
  coLanguage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  /* get logged in language and default to this */
  DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj           AS DECIMAL    INITIAL 0 NO-UNDO.

  cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "currentLanguageObj":U,
                                   INPUT NO).
  dCurrentLanguageObj = DECIMAL(cPropertyList) NO-ERROR.

  coLanguage:SCREEN-VALUE = STRING(dCurrentLanguageObj) NO-ERROR.
  IF coLanguage:SCREEN-VALUE = "0":U OR coLanguage:SCREEN-VALUE = ? THEN
    ASSIGN coLanguage:SCREEN-VALUE = "0":U NO-ERROR.
  ASSIGN gcSavedLanguage = coLanguage:SCREEN-VALUE
         coLanguage.
         coLanguage:SENSITIVE =TRUE.
END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
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

  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.


  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 70.
  FRAME {&FRAME-NAME}:WIDTH-PIXELS = hWindow:WIDTH-PIXELS - 28.

  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:WIDTH-CHARS = FRAME {&FRAME-NAME}:WIDTH-CHARS - 2.
    ghBrowse:HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 40.
  END.

  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowleave sObject 
PROCEDURE rowleave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hCol                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.

IF ghBrowse:CURRENT-ROW-MODIFIED THEN DO:
  REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
      hCol = ghBrowse:GET-BROWSE-COLUMN(iLoop).
      IF hCol:MODIFIED THEN
      DO:
          RUN valueChanged.
          hField = hCol:BUFFER-FIELD.
      /* if buff-field-hdl is unknown, this is a calculated field
            and cannot be updated */
          IF hField NE ? THEN
              hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
      END.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startsearch sObject 
PROCEDURE startsearch :
/*------------------------------------------------------------------------------
  Purpose:     Implement column sorting
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  ASSIGN
      hColumn = ghBrowse:CURRENT-COLUMN
      rRow    = ghBuffer:ROWID.

  IF VALID-HANDLE( hColumn ) THEN
  DO:
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME)
          .
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      IF ghQuery:NUM-RESULTS > 0 THEN
        DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
          APPLY 'VALUE-CHANGED':U TO ghBrowse.
        END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord sObject 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     /* save our data */
  APPLY "row-leave":U TO ghBrowse.
  RUN updateTranslations IN gshTranslationManager (INPUT TABLE ttTranslate).
  {set DataModified FALSE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged sObject 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Procedure fired on value changed of any of the widgets on the viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT glModified THEN
  DO:
      ASSIGN glModified = TRUE.
      {set DataModified TRUE}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

