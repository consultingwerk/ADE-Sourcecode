&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*************************************************************/  
/* Copyright (c) 1984-2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:        ryclcentityv.w
               This object viewer will display the list of dynamic objects
               and allow multiple selections.

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:      Edsel Garcia
  Created:     11/05/2004

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&scop object-name       ryclasscachv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes
{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCancelGeneration  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghProcedure         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRepDesignManager  AS HANDLE     NO-UNDO.

DEFINE STREAM logStream.

DEFINE TEMP-TABLE ttObjectList
  FIELD ttObjectFilename    AS CHARACTER
  FIELD ttObjectDescription AS CHARACTER
  FIELD ttObjectTypeCode    AS CHARACTER
  FIELD ttProductModuleCode AS CHARACTER
  FIELD ttObjectTypeObj     AS DECIMAL
  FIELD ttObjectSelected    AS LOGICAL
 INDEX idxMain IS UNIQUE PRIMARY ttObjectFilename 
 INDEX idxObjectTypeObj ttObjectTypeObj
 INDEX idxs1 ttObjectDescription
 INDEX idxs2 ttObjectTypeCode
 INDEX idxs3 ttProductModuleCode.

DEFINE TEMP-TABLE ttGenerationTemplate
  FIELD ttObjectTypeObj     AS DECIMAL
  FIELD ttObjectTypeCode    AS CHARACTER
  FIELD ttTemplateFilename  AS CHARACTER
 INDEX idx IS UNIQUE ttObjectTypeObj.

DEFINE TEMP-TABLE ttDatafieldChild
  FIELD ttObjectTypeObj         AS DECIMAL INITIAL ?
 INDEX idx IS UNIQUE ttObjectTypeObj.

{destdefi.i}

DEFINE VARIABLE ghBrowse AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghColumn AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcOrder  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE ghSelectionQuery AS HANDLE     NO-UNDO.

DEFINE BUFFER bttObjectList FOR ttObjectList.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttObjectList

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 ttObjectFilename ttObjectDescription ttObjectTypeCode ttProductModuleCode   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7   
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define OPEN-QUERY-BROWSE-7 DO WITH FRAME {&FRAME-NAME}:     OPEN QUERY {&SELF-NAME} PRESELECT EACH ttObjectList NO-LOCK BY ttObjectList.ttObjectFilename. END.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 ttObjectList
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 ttObjectList


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 coObjectType coProductModule ~
fiModifiedDate fiObjectName toSelectModified toIncludeViewers ~
toIncludeInstances buApply BROWSE-7 buSelectAll buDeselectAll 
&Scoped-Define DISPLAYED-OBJECTS coObjectType coProductModule ~
fiModifiedDate fiObjectName toSelectModified toIncludeViewers ~
toIncludeInstances 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTypeCode sObject 
FUNCTION getObjectTypeCode RETURNS CHARACTER
  ( pcObjectTypeObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow sObject 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD putLog sObject 
FUNCTION putLog RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StringValue sObject 
FUNCTION StringValue RETURNS CHARACTER
  ( pcValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD WriteLog sObject 
FUNCTION WriteLog RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "Appl&y" 
     SIZE 15 BY 1.14 TOOLTIP "Apply filter conditions"
     BGCOLOR 8 .

DEFINE BUTTON buDeselectAll 
     LABEL "Deselect A&ll" 
     SIZE 15 BY 1.14 TOOLTIP "Deselect all the current selected objects"
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14 TOOLTIP "Select all the current listed objects"
     BGCOLOR 8 .

DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(90)":U 
     LABEL "Object type" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<All>","<All>"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<All>","<All>"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE fiModifiedDate AS DATE FORMAT "99/99/9999":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN NATIVE 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(50)":U INITIAL "*" 
     LABEL "Object name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "A 4GL match expression to filter objects by object name" NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 5.

DEFINE VARIABLE toIncludeInstances AS LOGICAL INITIAL no 
     LABEL "Include object instances for objects" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 95.8 BY .81 NO-UNDO.

DEFINE VARIABLE toIncludeViewers AS LOGICAL INITIAL no 
     LABEL "Include viewers referenced by datafield objects" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 95.8 BY .81 NO-UNDO.

DEFINE VARIABLE toSelectModified AS LOGICAL INITIAL no 
     LABEL "Modified since" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 17.6 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      ttObjectList SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 sObject _FREEFORM
  QUERY BROWSE-7 DISPLAY
      ttObjectFilename                                      FORMAT "X(35)":U LABEL "Object file name"
      ttObjectDescription                                   FORMAT "X(50)":U LABEL "Description"
      ttObjectTypeCode                                      FORMAT "X(20)":U LABEL "Object type"
      ttProductModuleCode                                   FORMAT "X(20)":U LABEL "Product module"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 141 BY 12.95 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     coObjectType AT ROW 1.76 COL 15.2 COLON-ALIGNED
     coProductModule AT ROW 1.76 COL 87.4 COLON-ALIGNED
     fiModifiedDate AT ROW 2.86 COL 116.6 COLON-ALIGNED NO-LABEL
     fiObjectName AT ROW 2.95 COL 15.2 COLON-ALIGNED
     toSelectModified AT ROW 3 COL 100.2
     toIncludeViewers AT ROW 4.19 COL 17.2
     toIncludeInstances AT ROW 5 COL 17.2
     buApply AT ROW 5 COL 124.4
     BROWSE-7 AT ROW 6.62 COL 2
     buSelectAll AT ROW 19.71 COL 58
     buDeselectAll AT ROW 19.71 COL 73.8
     "Filter" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 1.19 COL 3.6
     RECT-4 AT ROW 1.43 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic,Browse
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
         HEIGHT             = 22.62
         WIDTH              = 144.4.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB BROWSE-7 buApply F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-7:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _START_FREEFORM
DO WITH FRAME {&FRAME-NAME}:
    OPEN QUERY {&SELF-NAME} PRESELECT EACH ttObjectList NO-LOCK BY ttObjectList.ttObjectFilename.
END.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 sObject
ON START-SEARCH OF BROWSE-7 IN FRAME F-Main
DO:
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.

  /* lSelectionType: 0 - No rows selected, 1 - All rows selected, 2 - Some rows selected */
  DEFINE VARIABLE iSelectionType AS INTEGER NO-UNDO.

  /* Get handle to current column and save current position in browser */
  ASSIGN hColumn = ghBrowse:CURRENT-COLUMN.

  /* Handle to current column is valid */
  IF VALID-HANDLE(hColumn) 
  THEN DO:
      SESSION:SET-WAIT-STATE("GENERAL").

      IF ghBrowse:NUM-SELECTED-ROWS = 0 THEN
          iSelectionType = 0.
      ELSE
          iSelectionType = IF ghQuery:NUM-RESULTS = ghBrowse:NUM-SELECTED-ROWS THEN 1 ELSE 2.

      IF iSelectionType = 2 THEN
      DO:
          IF ghBrowse:NUM-SELECTED-ROWS > 0 THEN
          DO TRANSACTION:
              FOR EACH ttObjectList EXCLUSIVE-LOCK:
                  ttObjectList.ttObjectSelected = FALSE.
              END.
          
              /* Save list of rowids */
              DO iLoop = 1 TO ghBrowse:NUM-SELECTED-ROWS:
                  ghBrowse:FETCH-SELECTED-ROW(iLoop).
                  FIND ttObjectList WHERE ROWID(ttObjectList) = ghBuffer:ROWID EXCLUSIVE-LOCK NO-ERROR.
                  IF AVAILABLE ttObjectList THEN
                      ttObjectList.ttObjectSelected = TRUE.
              END.
          END.
      END.
      /* Construct sort string */
      ASSIGN cSortBy = (IF hColumn:TABLE <> ? 
                        THEN hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME).
      IF ghColumn = hColumn THEN
          gcOrder = IF gcOrder = "" THEN " DESC":U ELSE "".
      ELSE
         ASSIGN ghColumn = hColumn
                gcOrder = "".

      /* Construct query string using sort string, then open query */
      ASSIGN cQuery = "PRESELECT EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy + gcOrder.

      ghBrowse:SET-REPOSITIONED-ROW(1, "CONDITIONAL").

      IF ghQuery:IS-OPEN THEN ghQuery:QUERY-CLOSE().
      ghQuery:QUERY-PREPARE(cQuery).

      lockWindow(TRUE).
      ghQuery:QUERY-OPEN().

      CASE iSelectionType:
          WHEN 1 THEN ghBrowse:SELECT-ALL().
          WHEN 2 THEN 
          DO:
              cQuery = "FOR EACH bttObjectList WHERE ttObjectSelected NO-LOCK BY ":U + hColumn:NAME + gcOrder.
              ghSelectionQuery:QUERY-PREPARE(cQuery).
              ghSelectionQuery:QUERY-OPEN().
              ghSelectionQuery:GET-FIRST.
              DO WHILE AVAILABLE bttObjectList:
                  ghQuery:REPOSITION-TO-ROWID(ROWID(bttObjectList)). /* ROWID of buffer bttObjectList */
                  ghBrowse:SELECT-FOCUSED-ROW().
                  ghSelectionQuery:GET-NEXT.
              END.
          END.
      END CASE.

      lockWindow(FALSE).
      SESSION:SET-WAIT-STATE("").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply sObject
ON CHOOSE OF buApply IN FRAME F-Main /* Apply */
OR RETURN OF coObjectType
OR RETURN OF coProductModule
OR RETURN OF fiObjectName DO:
  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSmartObjectQuery AS HANDLE     NO-UNDO.

  DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dProductModuleObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cNumericSeparator AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDecimalPoint     AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bObjectList FOR ttObjectList.
  define BUFFER rycso        for ryc_smartobject.  

  IF coObjectType:SCREEN-VALUE <> "<All>":U THEN
  DO:
      FIND gsc_object_type WHERE gsc_object_type.object_type_code = coObjectType:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object_type THEN
          dObjectTypeObj = gsc_object_type.object_type_obj.
  END.
  IF coProductModule:SCREEN-VALUE <> "<All>":U THEN
  DO:
      FIND gsc_product_module WHERE gsc_product_module.product_module_code = coProductModule:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_product_module THEN
          dProductModuleObj = gsc_product_module.product_module_obj.
  END.

  hQuery = BROWSE BROWSE-7:QUERY.

  ASSIGN cNumericSeparator = SESSION:NUMERIC-SEPARATOR
         cDecimalPoint     = SESSION:NUMERIC-DECIMAL-POINT.

  SESSION:NUMERIC-FORMAT = "AMERICAN":U.
  DO ON ERROR UNDO, LEAVE:

  CREATE QUERY hSmartObjectQuery.
  IF toSelectModified:CHECKED THEN
  DO:
      hSmartObjectQuery:SET-BUFFERS(BUFFER gst_record_version:HANDLE, 
                                    BUFFER ryc_smartobject:HANDLE).

      cQueryString = "FOR EACH gst_record_version NO-LOCK"
                   +  "   WHERE gst_record_version.entity_mnemonic = 'RYCSO' AND gst_record_version.version_date >= " 
                   + (IF INPUT fiModifiedDate = ? THEN "?" ELSE fiModifiedDate:SCREEN-VALUE)
                   + " , EACH ryc_smartobject NO-LOCK"
                   + "    WHERE ryc_smartobject.smartobject_obj = DECIMAL(gst_record_version.key_field_value)"
                   + "      AND ryc_smartobject.object_filename MATCHES '" + INPUT fiObjectName + "' "
                   + "      and ryc_smartobject.customization_result_obj  = 0 "
                   + (IF dObjectTypeObj > 0 THEN 
                     "      AND ryc_smartobject.object_type_obj = " + STRING(dObjectTypeObj) 
                      ELSE "")
                   + (IF dProductModuleObj > 0 THEN 
                     "      AND ryc_smartobject.product_module_obj = " + STRING(dProductModuleObj) 
                     ELSE "")
                   .
  END.
  ELSE DO:
      hSmartObjectQuery:SET-BUFFERS(BUFFER ryc_smartobject:HANDLE).

      cQueryString = "FOR EACH ryc_smartobject NO-LOCK"
                   + "    WHERE ryc_smartobject.object_filename MATCHES '" + INPUT fiObjectName + "'"
                   + "      and ryc_smartobject.customization_result_obj = 0 "
                   + (IF dObjectTypeObj > 0 THEN 
                     "      AND ryc_smartobject.object_type_obj = " + STRING(dObjectTypeObj) 
                      ELSE "")
                   + (IF dProductModuleObj > 0 THEN 
                     "      AND ryc_smartobject.product_module_obj = " + STRING(dProductModuleObj) 
                      ELSE "")
                   .
  END.
  hSmartObjectQuery:QUERY-PREPARE(cQueryString).

  EMPTY TEMP-TABLE ttObjectList.
  
  hSmartObjectQuery:QUERY-OPEN().
  hSmartObjectQuery:GET-FIRST.
  DO TRANSACTION:
      DO WHILE AVAILABLE ryc_smartobject:

          IF ryc_smartobject.static_object THEN
          DO:
              FIND ttDatafieldChild WHERE ttDatafieldChild.ttObjectTypeObj = ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ttDatafieldChild THEN
              DO:
                  hSmartObjectQuery:GET-NEXT.
                  NEXT.                       /* Skip static objects or non datafield objects */
              END.
          END.

          FIND gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
          FIND gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.

          CREATE ttObjectList.
          ASSIGN ttObjectList.ttObjectFilename    = ryc_smartobject.object_filename
                 ttObjectList.ttObjectDescription = ryc_smartobject.object_description
                 ttObjectList.ttObjectTypeCode    = IF AVAILABLE gsc_object_type THEN gsc_object_type.object_type_code ELSE ""
                 ttObjectList.ttProductModuleCode = IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE ""
                 ttObjectList.ttObjectTypeObj     = ryc_smartobject.object_type_obj.

          hSmartObjectQuery:GET-NEXT.
      END.
  END.
  hSmartObjectQuery:QUERY-CLOSE().
  DELETE OBJECT hSmartObjectQuery.

  END.
  SESSION:SET-NUMERIC-FORMAT(cNumericSeparator, cDecimalPoint).

  IF toIncludeViewers:CHECKED THEN DO:
      FOR EACH ttDatafieldChild NO-LOCK,
          EACH bObjectList NO-LOCK
          WHERE bObjectList.ttObjectTypeObj = ttDatafieldChild.ttObjectTypeObj:
          
          /* get all possible containers, including customised stuff. */
          for each rycso where
                   rycso.object_filename = bObjectList.ttObjectFilename
                   no-lock,
              each ryc_object_instance where
                   ryc_object_instance.smartobject_obj = rycso.smartobject_obj
                   no-lock,
             first ryc_smartobject where
                   ryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj and
                   ryc_smartobject.static_obj = no
                   no-lock:
               
               if can-FIND(ttObjectList WHERE 
                           ttObjectList.ttObjectFilename = ryc_smartobject.object_filename) then
                    next.
               
               FIND gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
               FIND gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.

               CREATE ttObjectList.
               ASSIGN ttObjectList.ttObjectFilename    = ryc_smartobject.object_filename
                      ttObjectList.ttObjectDescription = ryc_smartobject.object_description
                      ttObjectList.ttObjectTypeCode    = IF AVAILABLE gsc_object_type THEN gsc_object_type.object_type_code ELSE ""
                      ttObjectList.ttProductModuleCode = IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE ""
                      ttObjectList.ttObjectTypeObj     = ryc_smartobject.object_type_obj.

          END.    /* each object */
      END.    /* each data field child */
  END.    /* include viewers */

  IF toIncludeInstances:CHECKED THEN DO:
      FOR EACH bObjectList NO-LOCK:
          RUN addObjectInstances(bObjectList.ttObjectFilename).
      END.
  END.
  
  hQuery:QUERY-PREPARE("PRESELECT EACH ttObjectList NO-LOCK BY ttObjectList.ttObjectFilename").
  hQuery:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll sObject
ON CHOOSE OF buDeselectAll IN FRAME F-Main /* Deselect All */
DO:
  IF AVAILABLE ttObjectList THEN
    BROWSE {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll sObject
ON CHOOSE OF buSelectAll IN FRAME F-Main /* Select All */
DO:
  IF AVAILABLE ttObjectList THEN
     BROWSE {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSelectModified
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSelectModified sObject
ON VALUE-CHANGED OF toSelectModified IN FRAME F-Main /* Modified since */
DO:
  fiModifiedDate:SENSITIVE = toSelectModified:CHECKED.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addObjectInstances sObject 
PROCEDURE addObjectInstances :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectFilename AS character NO-UNDO.
    
    define buffer rycso    for ryc_smartobject.
    
    for each rycso where
             rycso.object_filename = pcObjectFilename
             no-lock,             
        each ryc_object_instance WHERE 
             ryc_object_instance.container_smartobject_obj = rycso.smartobject_obj
             no-lock,
       first ryc_smartobject WHERE 
             ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj and
             ryc_smartobject.static_obj = no
             NO-LOCK:
        
            IF not can-find(ttObjectList where
                        ttObjectList.ttObjectFilename = ryc_smartobject.object_filename) then
            DO:

            FIND gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
            FIND gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.

            CREATE ttObjectList.
            ASSIGN ttObjectList.ttObjectFilename    = ryc_smartobject.object_filename
                   ttObjectList.ttObjectDescription = ryc_smartobject.object_description
                   ttObjectList.ttObjectTypeCode    = IF AVAILABLE gsc_object_type THEN gsc_object_type.object_type_code ELSE ""
                   ttObjectList.ttProductModuleCode = IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE ""
                   ttObjectList.ttObjectTypeObj     = ryc_smartobject.object_type_obj.
            END.
        
            RUN addObjectInstances(ryc_smartobject.object_filename).
        END.
    
    error-status:error = no.
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelGeneration sObject 
PROCEDURE cancelGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  glCancelGeneration = TRUE.
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generate4GLPrograms sObject 
PROCEDURE generate4GLPrograms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hEntityBrowse       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE iBrowseLoop         AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cHookFilename           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCodes            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedureLocation AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGeneratedFileRoot      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOptions                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLanguages              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutputFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInheritClasses         AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE lError                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCompile                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCompileDirectory       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOS-ERROR               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dElapsedTime            AS DECIMAL    NO-UNDO DECIMALS 4.
  DEFINE VARIABLE cCompileOptions         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrentDir             AS CHARACTER  NO-UNDO.

  PUBLISH "getHookProcedure":U          FROM ghContainerSource (OUTPUT cHookfilename).
  PUBLISH "getResultCodes":U            FROM ghContainerSource (OUTPUT cResultCodes).
  PUBLISH "getSuperProcedureLocation":U FROM ghContainerSource (OUTPUT cSuperProcedureLocation).
  PUBLISH "getGeneratedFileRoot":U      FROM ghContainerSource (OUTPUT cGeneratedFileRoot).
  PUBLISH "getOptions":U                FROM ghContainerSource (OUTPUT cOptions).
  PUBLISH "getLanguages":U              FROM ghContainerSource (OUTPUT cLanguages).
  PUBLISH "getCompileOption":U          FROM ghContainerSource (OUTPUT lCompile, OUTPUT cCompileDirectory, OUTPUT cCompileOptions).

  hEntityBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

  IF hEntityBrowse:NUM-SELECTED-ROWS = 0 THEN
  DO:
      RUN showMessages IN gshSessionManager (INPUT "No objects were selected for generation.",
                                       INPUT "ERR":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "Generate 4GL Programs",
                                       INPUT YES,
                                       INPUT ?,
                                       OUTPUT cButton).
      RETURN.
  END.

    lError = NO.
  writeLog("~nGeneration Process Started "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS") + "~n") NO-ERROR.

  writeLog("Options: ~n" +
           "~nTarget location         : " + StringValue(cGeneratedFileRoot) +
           "~nHook procedure          : " + StringValue(cHookFilename) +
           "~nGenerate security       : " + STRING(LOOKUP("generatesecurity":U, cOptions) > 0) +
           "~nGenerate thin rendering : " + STRING(LOOKUP("generatethinrendering":U, cOptions) > 0) +
           "~nSuper procedure         : " + StringValue(cSuperProcedureLocation) +
           "~nResult codes            : " + StringValue(cResultCodes) + 
           "~nGenerate translations   : " + STRING(LOOKUP("generatetranslations":U, cOptions) > 0) +
           (IF (LOOKUP("generatetranslations":U, cOptions) > 0) THEN
                 "~nLanguages               : " + StringValue(cLanguages)
            ELSE
                "") + 
           (IF lCompile THEN "~nRcode location          : " + cCompileDirectory ELSE "") + 
           (IF lCompile THEN "~nCompile options         : " + cCompileOptions ELSE "") +
           "~n~n"
           ) NO-ERROR.

  IF lCompile THEN /* Check Rcode directory */
  DO:
      cCompileDirectory = REPLACE(cCompileDirectory, '~\':u, '/':u).
      FILE-INFO:FILE-NAME = cCompileDirectory.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
          writeLog("Rcode directory was not found. Creating directory " + cCompileDirectory + "~n").

          DO iLoop = 1 TO NUM-ENTRIES(cCompileDirectory, '/':u).
            cCurrentDir = cCurrentDir 
                        + (IF iLoop EQ 1 THEN '':u ELSE '/':u)
                        + ENTRY(iLoop, cCompileDirectory, '/':u).

            writeLog('Creating directory - ' + cCurrentDir).
            OS-CREATE-DIR VALUE(cCurrentDir).
            iOS-Error = OS-ERROR.
            IF iOS-Error GT 0 THEN LEAVE.
          END.    /* loop through directories and create the missing ones */

          FILE-INFORMATION:FILE-NAME = cCompileDirectory.
      END.    /* create directory */
    
      IF iOS-ERROR NE 0 THEN
      DO:
          writeLog("Creation of rcode directory failed.").
          writeLog("~nGeneration process was aborted "
                         + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS")) NO-ERROR.
          RUN showMessages IN gshSessionManager (INPUT "Creation of rcode directory failed.~nGeneration process was aborted.",
                                   INPUT "ERR":U,
                                   INPUT "OK":U,
                                   INPUT "OK":U,
                                   INPUT "OK":U,
                                   INPUT "Generate 4GL Programs",
                                   INPUT YES,
                                   INPUT ?,
                                   OUTPUT cButton).
          RETURN.
      END.
  END.
  
  EMPTY TEMP-TABLE ttGenerationTemplate.
  glCancelGeneration = FALSE.
  DO iBrowseLoop = 1 TO hEntityBrowse:NUM-SELECTED-ROWS:
      PROCESS EVENTS.
      
      IF glCancelGeneration THEN
      DO:
         writeLog("~nGeneration process was aborted "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS")) NO-ERROR.
         RETURN.
      END.

      hEntityBrowse:FETCH-SELECTED-ROW(iBrowseLoop).

      FIND FIRST ttGenerationTemplate WHERE ttGenerationTemplate.ttObjectTypeObj = ttObjectList.ttObjectTypeObj NO-LOCK NO-ERROR.
      IF NOT AVAILABLE ttGenerationTemplate THEN
      DO:
          FIND gsc_object_type WHERE gsc_object_type.object_type_obj = ttObjectList.ttObjectTypeObj NO-LOCK NO-ERROR.
          IF AVAILABLE gsc_object_type THEN
          DO:
              RUN retrieveDesignClass IN ghRepDesignManager
                                          ( INPUT gsc_object_type.object_type_code,
                                            OUTPUT cInheritClasses,
                                            OUTPUT TABLE ttClassAttribute,
                                            OUTPUT TABLE ttUiEvent,
                                            OUTPUT TABLE ttSupportedLink    ) NO-ERROR.

              if error-status:error or return-value ne '' then return error return-value.

              FIND ttClassAttribute WHERE ttClassAttribute.tClassName = gsc_object_type.object_type_code
                                      AND ttClassAttribute.tAttributeLabel = "GenerationTemplate":U NO-LOCK NO-ERROR.

              CREATE ttGenerationTemplate.
              ASSIGN ttGenerationTemplate.ttObjectTypeObj  = gsc_object_type.object_type_obj
                     ttGenerationTemplate.ttObjectTypeCode = gsc_object_type.object_type_code
                     ttGenerationTemplate.ttTemplateFilename = IF AVAILABLE ttClassAttribute THEN ttClassAttribute.tAttributeValue ELSE "".
          END.
          ELSE
          DO:
              writeLog("Object type definition not found for object: " + ttObjectList.ttObjectFilename + " object type: " + STRING(ttOBjectList.ttObjectTypeObj)) NO-ERROR.
              NEXT.
          END.
      END.

      IF ttGenerationTemplate.ttTemplateFilename > "" THEN
          putLog("Processing " + ttGenerationTemplate.ttObjectTypeCode + " object: " + ttObjectList.ttObjectFilename + " with template: " + ttGenerationTemplate.ttTemplateFilename) NO-ERROR.
      ELSE DO:
          writeLog("Processing " + ttGenerationTemplate.ttObjectTypeCode + " object: " + ttObjectList.ttObjectFilename + " - template not found. Skipping.") NO-ERROR.
          PUBLISH "updateStatus":U FROM ghContainerSource (INPUT "Skipping   " + ttObjectList.ttObjectFilename +
                                                                 " [ " + STRING(iBrowseLoop) + " / " + STRING(hEntityBrowse:NUM-SELECTED-ROWS) + " ]").
          NEXT.
      END.

      PUBLISH "updateStatus":U FROM ghContainerSource (INPUT "Processing " + ttObjectList.ttObjectFilename +
                                                             " [ " + STRING(iBrowseLoop) + " / " + STRING(hEntityBrowse:NUM-SELECTED-ROWS) + " ]").
      ETIME(YES).
      RUN generateObject IN ghProcedure (

            input ttObjectList.ttObjectFilename, /*pcObject,*/
            input ttGenerationTemplate.ttTemplateFilename, /*pcTemplateFilename,*/
            input cHookFilename, /*pcHookFilename,   */
            input cLanguages, /*pcLanguages,*/
            input cResultCodes, /* 'default-result-code', /*pcResultCodes,*/ */
            INPUT cSuperProcedureLocation, /*pcSuperProcedureLocation,*/
            input cGeneratedFileRoot, /*pcGeneratedFileRoot*/   
            input cOptions, /* 'generatetranslations,generatesecurity' /*pcOptions */ */
            OUTPUT cOutputFilename
            ) no-error.
      dElapsedTime = ETIME / 1000.
      if return-value ne '' or error-status:error then
      DO:     
          writeLog("~n*** GENERATION FAILURE: " + RETURN-VALUE + '~n') no-error.
          lError = YES.
      END.  /* error */
      ELSE 
      DO:
          writeLog(". ( " + STRING(dElapsedTime) + " secs )") NO-ERROR.
          IF lCompile THEN /* Compile */
          DO:
              putLog("Compiling " + cOutputFilename) NO-ERROR.
              COMPILE VALUE(cOutputFilename) SAVE INTO VALUE(cCompileDirectory) 
                  GENERATE-MD5 = LOOKUP("GENERATE-MD5":U, cCompileOptions) > 0
                  MIN-SIZE = LOOKUP("MIN-SIZE":U, cCompileOptions) > 0 NO-ERROR.
              writeLog(".").
              IF COMPILER:ERROR OR COMPILER:WARNING THEN
              DO:
                  /* The NO-ERROR option is not used since it would reset the error message list. */
                  writeLog("Compilation messages: ").
                  RUN writeErrors.                  
                  writeLog("").
                  lError = YES.
              END.
          END.
      END.
  END.
  writeLog("~nGeneration Process Ended "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS")) NO-ERROR.

  IF lError THEN
      cMessage = 'Generation completed with errors. Please check the log file for details. '.
  ELSE
      cMessage = 'Generation completed successfully.'.
  
  /* Set mouse pointer */
  THIS-PROCEDURE:CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW":U).
  RUN showMessages IN gshSessionManager (INPUT cMessage,
                                         INPUT (IF lError THEN "ERR":U ELSE 'INF'),
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "Generate 4GL Programs",
                                         INPUT YES,
                                         INPUT ?,
                                         OUTPUT cButton).
    
    ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* generate4GLPrograms */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityBrowse sObject 
PROCEDURE getEntityBrowse :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will return the browse handle
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phBrowse AS HANDLE      NO-UNDO.
  ASSIGN phBrowse = BROWSE {&BROWSE-NAME}:HANDLE.
  
  IF NOT VALID-HANDLE(phBrowse) THEN
    RETURN ERROR "Object Browse Handle is invalid".
  ELSE
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData sObject 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will perform initialization of various variables 
               and widgets.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntityClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTemp          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.

  ghRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  
  DO WITH FRAME {&FRAME-NAME}:
      coObjectType:DELIMITER = CHR(3).
      FOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code:
          coObjectType:ADD-LAST(gsc_object_type.object_type_code + " / ":U + 
                                   gsc_object_type.object_type_description,
                                   gsc_object_type.object_type_code).
      END.
      coObjectType:SCREEN-VALUE = "<All>":U.

      coProductModule:DELIMITER = CHR(3).
      coProductModule:list-item-pairs = dynamic-function('getProductModuleList':u in ghRepDesignManager,
                                                         'product_module_code',
                                                         'product_module_code,product_module_description',
                                                         '&1 / &2',
                                                         chr(3)).
      coProductModule:add-first("<All>","<All>").
      coProductModule:SCREEN-VALUE = "<All>":U.
  END.

  cTemp = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField":U) NO-ERROR.
  DO iLoop = 1 TO NUM-ENTRIES(cTemp):
      FIND gsc_object_type WHERE object_type_code = ENTRY(iLoop, cTemp) NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object_type THEN
      DO:
          CREATE ttDatafieldChild.
          ASSIGN ttDatafieldChild.ttObjectTypeObj = gsc_object_type.object_type_obj.
      END.
  END.
  
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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  /* first populate a temp table based with SDO list */
  ASSIGN BROWSE {&browse-name}:ALLOW-COLUMN-SEARCHING      = TRUE.

  RUN initializeData IN TARGET-PROCEDURE.

  ASSIGN ghBrowse = BROWSE {&BROWSE-NAME}:HANDLE
         ghBuffer = BUFFER ttObjectList:HANDLE
         ghQuery  = ghBrowse:QUERY.

  CREATE QUERY ghSelectionQuery.
  ghSelectionQuery:SET-BUFFERS(BUFFER bttObjectList:HANDLE).
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN fiObjectName:SCREEN-VALUE    = "*".
  END.

  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  ENABLE ALL WITH FRAME F-main.
  fiModifiedDate:SENSITIVE = toSelectModified:CHECKED.
  
  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "getEntityBrowse":U  IN ghContainerSource.
      SUBSCRIBE TO "cancelGeneration":U IN ghContainerSource.
      SUBSCRIBE TO "runGeneration":U    IN ghContainerSource.
  END.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

  /* Code placed here will execute AFTER standard behavior.    */
  /* Set the handle of the container source immediately upon making the link */
  IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
     ASSIGN ghContainerSource = phObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runGeneration sObject 
PROCEDURE runGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogFilename AS CHARACTER  NO-UNDO.

  RUN ry/app/rygentempp.p PERSISTENT SET ghProcedure.

  PUBLISH "getLogFilename":U FROM ghContainerSource (OUTPUT cLogFilename).

  OUTPUT STREAM logStream TO VALUE(cLogFilename).

  RUN generate4GLPrograms.
  PUBLISH "updateStatus":U FROM ghContainerSource (INPUT "Generate 4GL using selected objects").

  OUTPUT STREAM logStream CLOSE.
  DELETE OBJECT ghProcedure NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeErrors sObject 
PROCEDURE writeErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
    writeLog(ERROR-STATUS:GET-MESSAGE(iLoop)).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypeCode sObject 
FUNCTION getObjectTypeCode RETURNS CHARACTER
  ( pcObjectTypeObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND gsc_object_type WHERE gsc_object_type.object_type_obj = pcObjectTypeObj NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_object_type THEN
      RETURN gsc_object_type.object_type_code.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow sObject 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode AS INTEGER    NO-UNDO.

  IF plLockWindow AND {&WINDOW-NAME}:HWND EQ ? THEN
       RETURN FALSE. 

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT {&WINDOW-NAME}:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION putLog sObject 
FUNCTION putLog RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER ) :

  DEFINE VARIABLE lStatus AS LOGICAL     NO-UNDO.

  IF pcLine <> "" THEN
      PUT STREAM logStream UNFORMATTED pcLine. /* Write log file */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StringValue sObject 
FUNCTION StringValue RETURNS CHARACTER
  ( pcValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF pcValue = ? THEN
      RETURN "<unknown>".
  ELSE
      RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION WriteLog sObject 
FUNCTION WriteLog RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER ) :

  DEFINE VARIABLE lStatus AS LOGICAL     NO-UNDO.

  IF pcLine = "" THEN
      PUT STREAM logStream UNFORMATTED SKIP(1). /* Write log file */
  ELSE
      PUT STREAM logStream UNFORMATTED pcLine SKIP. /* Write log file */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

