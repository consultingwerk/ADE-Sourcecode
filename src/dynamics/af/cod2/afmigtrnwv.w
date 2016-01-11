&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:        ryclcentityv.w
               This object viewer will display the list of entites on a 
               browse and allow multiple selections.

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:      Sunil Belgaonkar
  Created:     08/15/2003

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

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCancelMigration AS LOGICAL    NO-UNDO.

DEFINE STREAM logStream.

 DEFINE TEMP-TABLE ttEntityList
  FIELD ttDBName     AS CHARACTER
  FIELD ttEntityName AS CHARACTER 
  FIELD ttEntityDesc AS CHARACTER 
 INDEX idxMain ttEntityName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEntityList

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 ttEntityName ttEntityDesc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7   
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define OPEN-QUERY-BROWSE-7 DO WITH FRAME {&FRAME-NAME}:   IF ( coDatabase:SCREEN-VALUE = "<ALL>" ) THEN     OPEN QUERY {&SELF-NAME} FOR EACH ttEntityList NO-LOCK.   ELSE     OPEN QUERY {&SELF-NAME} FOR EACH ttEntityList WHERE ttDBName = coDatabase:SCREEN-VALUE NO-LOCK. END.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 ttEntityList
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 ttEntityList


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coSourceLanguage coTargetLanguage coDatabase ~
BROWSE-7 buDeselectAll toRemove toSkip toTestMigration 
&Scoped-Define DISPLAYED-OBJECTS coSourceLanguage coTargetLanguage ~
coDatabase toRemove toSkip toTestMigration 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateStatus sObject 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT phStatus AS HANDLE,
    INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeselectAll 
     LABEL "Deselect A&ll" 
     SIZE 15 BY 1.14 TOOLTIP "Deselect all the current selected classes"
     BGCOLOR 8 .

DEFINE BUTTON buSelectAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.14 TOOLTIP "Select all the current listed classes"
     BGCOLOR 8 .

DEFINE VARIABLE coDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 37 BY 1 TOOLTIP "Select a db and press Refresh to show information for the selected db only" NO-UNDO.

DEFINE VARIABLE coSourceLanguage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Source Language" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 37 BY 1 TOOLTIP "Select a db and press Refresh to show information for the selected db only" NO-UNDO.

DEFINE VARIABLE coTargetLanguage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target Language" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 37 BY 1 TOOLTIP "Select a db and press Refresh to show information for the selected db only" NO-UNDO.

DEFINE VARIABLE toRemove AS LOGICAL INITIAL no 
     LABEL "Remove widget-based translation" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 96 BY .81 NO-UNDO.

DEFINE VARIABLE toSkip AS LOGICAL INITIAL no 
     LABEL "Skip creation of datafield translation if multiple translations are found" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 104 BY .81 NO-UNDO.

DEFINE VARIABLE toTestMigration AS LOGICAL INITIAL no 
     LABEL "Test migration - Report migration changes without updating the repository" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 96 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      ttEntityList SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 sObject _FREEFORM
  QUERY BROWSE-7 DISPLAY
      ttEntityName FORMAT "X(35)":U LABEL "Entity Name"
     ttEntityDesc FORMAT "X(40)":U LABEL "Description"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 110 BY 10.71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     coSourceLanguage AT ROW 1.33 COL 20.4 COLON-ALIGNED
     coTargetLanguage AT ROW 2.57 COL 20.4 COLON-ALIGNED
     coDatabase AT ROW 3.71 COL 20.4 COLON-ALIGNED
     BROWSE-7 AT ROW 5.19 COL 4
     buSelectAll AT ROW 16.38 COL 41.8
     buDeselectAll AT ROW 16.38 COL 56.8
     toRemove AT ROW 18.14 COL 4
     toSkip AT ROW 19.1 COL 4
     toTestMigration AT ROW 20.05 COL 4
     "" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 21 COL 101
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
         HEIGHT             = 22.1
         WIDTH              = 115.8.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB BROWSE-7 coDatabase F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-7:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE
       BROWSE-7:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE
       BROWSE-7:COLUMN-MOVABLE IN FRAME F-Main         = TRUE.

/* SETTINGS FOR BUTTON buSelectAll IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coDatabase IN FRAME F-Main
   DEF-HELP                                                             */
/* SETTINGS FOR COMBO-BOX coSourceLanguage IN FRAME F-Main
   DEF-HELP                                                             */
/* SETTINGS FOR COMBO-BOX coTargetLanguage IN FRAME F-Main
   DEF-HELP                                                             */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _START_FREEFORM
DO WITH FRAME {&FRAME-NAME}:
  IF ( coDatabase:SCREEN-VALUE = "<ALL>" ) THEN
    OPEN QUERY {&SELF-NAME} FOR EACH ttEntityList NO-LOCK.
  ELSE
    OPEN QUERY {&SELF-NAME} FOR EACH ttEntityList WHERE ttDBName = coDatabase:SCREEN-VALUE NO-LOCK.
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

&Scoped-define SELF-NAME buDeselectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselectAll sObject
ON CHOOSE OF buDeselectAll IN FRAME F-Main /* Deselect All */
DO:
    BROWSE {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelectAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelectAll sObject
ON CHOOSE OF buSelectAll IN FRAME F-Main /* Select All */
DO:
  BROWSE {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase sObject
ON VALUE-CHANGED OF coDatabase IN FRAME F-Main /* Database */
DO:
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  ENABLE ALL WITH FRAME F-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRemove sObject
ON VALUE-CHANGED OF toRemove IN FRAME F-Main /* Remove widget-based translation */
DO:
  DEFINE VARIABLE cAnswer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.

  IF SELF:CHECKED THEN
  DO:
     RUN askQuestion IN gshSessionManager ( 
         INPUT "Do you really want to remove widget-based translations while migrating?" + 
               "~n~nIf you do, some translations may be lost since they are only available when using widget-based translations.~n",
         INPUT "&Yes,&No":U,     /* button list */
         INPUT "&No":U,         /* default */
         INPUT "&No":U,          /* cancel */
         INPUT "Migrate Widget Translation":U, /* title */
         INPUT "":U,             /* datatype */
         INPUT "":U,             /* format */
         INPUT-OUTPUT cAnswer,   /* answer */
         OUTPUT cButton          /* button pressed */ ).  
  END.
  IF cButton = "&No":U OR cButton = "No":U THEN
  DO:
     SELF:CHECKED = FALSE.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelMigration sObject 
PROCEDURE cancelMigration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  glCancelMigration = TRUE.
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
    RETURN ERROR "Entities Browse Handle is invalid".
  ELSE
    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEntityList sObject 
PROCEDURE getEntityList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will find the entity list.
  Parameters:  output - Comma separated entity list.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcEntityList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iBrowseLoop AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cClassList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

  ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.
  
  IF NOT VALID-HANDLE(hBrowse) THEN
    RETURN ERROR "Entities Browse Handle is invalid".

  /* First get the list of classes from the Browse selection */
  ASSIGN
    hQuery  = hBrowse:QUERY
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).

  DO iBrowseLoop = 1 TO hBrowse:NUM-SELECTED-ROWS:
    hBrowse:FETCH-SELECTED-ROW(iBrowseLoop).
    pcEntityList = pcEntityList + "," + hBuffer:BUFFER-FIELD('ttEntityName'):BUFFER-VALUE.
  END.
  pcEntityList = TRIM(pcEntityList, ",":U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTestMigration sObject 
PROCEDURE getTestMigration :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will return the state of TestMigration toggle
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plTestMigration AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN plTestMigration = toTestMigration:CHECKED.
  END.
  
  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData sObject 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will populate the ttEntityList TT.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntityClasses AS CHARACTER  NO-UNDO.

  ASSIGN cEntityClasses = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "Entity":U) NO-ERROR.
  
  FOR EACH gsc_object_type 
     WHERE LOOKUP(OBJECT_type_code, cEntityClasses) > 0 NO-LOCK,
      EACH ryc_smartobject
     WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK,
     FIRST gsc_entity_mnemonic WHERE gsc_entity_mnemonic.entity_mnemonic_description = ryc_smartobject.object_filename 
  NO-LOCK :
    CREATE ttEntityList.
    ASSIGN ttEntityList.ttDBName = gsc_entity_mnemonic.entity_dbname
           ttEntityList.ttEntityName = ryc_smartobject.object_filename
           ttEntityList.ttEntityDesc = ryc_smartobject.object_description.

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
  DEFINE VARIABLE cDBList                  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cLanguageList            AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE i                        AS INTEGER     NO-UNDO INITIAL 1.
  DEFINE VARIABLE iPick                    AS INTEGER     NO-UNDO INITIAL 1.
  DEFINE VARIABLE cTargetLng               AS CHARACTER   NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  /* first populate a temp table based with SDO list */
  ASSIGN BROWSE {&browse-name}:ALLOW-COLUMN-SEARCHING      = TRUE.

  RUN initializeData IN TARGET-PROCEDURE.
  
  ASSIGN cDBList = "<ALL>":U.
  FOR EACH ttEntityList
    BREAK BY ttDBName:
    IF FIRST-OF(ttDBName) THEN
    DO:
       i = i + 1.
       cDBList = cDBList + ",":U + ttDBName.
       IF ttDBName <> "ICFDB":U AND ttDBName <> "TEMP-DB":U AND iPick = 1 THEN
         iPick = i.
    END.
  END.
  cDBList = TRIM(cDBList, ",":U).

  FOR EACH gsc_language BY language_code:
      cLanguageList = cLanguageList + ",":U + language_code.
  END.
  cLanguageList = TRIM(cLanguageList, ",":U).

  IF VALID-HANDLE(gshSessionManager) THEN
      cTargetLng = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
  FIND gsc_language WHERE gsc_language.language_code = cTargetLng NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
    coDatabase:LIST-ITEMS = cDBList.
    coDatabase:SCREEN-VALUE = coDatabase:ENTRY(iPick).
    ASSIGN cosourceLanguage:LIST-ITEMS   = cLanguageList
           coSourceLanguage:SCREEN-VALUE = coSourceLanguage:ENTRY(1) 
           coTargetLanguage:LIST-ITEMS   = cLanguageList
           coTargetLanguage:SCREEN-VALUE =  IF AVAILABLE gsc_language THEN cTargetLng ELSE coTargetLanguage:ENTRY(1)
           NO-ERROR.
  END.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  ENABLE ALL WITH FRAME F-main.

  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "getEntityBrowse":U IN ghContainerSource.
      SUBSCRIBE TO "getTestMigration":U IN ghContainerSource.
      SUBSCRIBE TO "cancelMigration":U IN ghContainerSource.
      SUBSCRIBE TO "runMigration":U IN ghContainerSource.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE migrateWidgetTranslations sObject 
PROCEDURE migrateWidgetTranslations :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETE hStatus AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cButton             AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE hEntityBrowse       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE iBrowseLoop         AS INTEGER     NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj      AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE cEntity             AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDataField          AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE iWidgetEntry        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSrcWidgetType      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSrcObjectFilename  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE dSourceLanguageObj  AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE dTargetLanguageObj  AS DECIMAL     NO-UNDO.

  DEFINE VARIABLE cOriginalLabel      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTranslatedLabel    AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lRemoveWidgetTranslation     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lSkipTranslationWhenMultiple AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lTestMigration               AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lMultipleTranslationFound    AS LOGICAL     NO-UNDO.

  DEFINE BUFFER bNewTranslation FOR gsm_translation.

  DO WITH FRAME {&FRAME-NAME}:
      
      hEntityBrowse = BROWSE {&BROWSE-NAME}:HANDLE.
      IF hEntityBrowse:NUM-SELECTED-ROWS = 0 THEN
      DO:
          RUN showMessages IN gshSessionManager (INPUT "No entities were selected for migration.",
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Migrate Widget Translation",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
          RETURN.
      END.

      FIND gsc_object_type WHERE gsc_object_type.object_type_code = "DATAFIELD":U NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gsc_object_type THEN
      DO:
          updateStatus(hStatus, "gsc_object_type record for DATAFIELD was not found. Migration borted.") NO-ERROR.
          RETURN.
      END.
      dObjectTypeObj = gsc_object_type.object_type_obj.
    
      FIND gsc_language WHERE gsc_language.LANGUAGE_code = coSourceLanguage:SCREEN-VALUE NO-ERROR.
      IF NOT AVAILABLE gsc_language THEN
      DO:
          updateStatus(hStatus, "gsc_language record for source language was not found. Migration borted.") NO-ERROR.
          RETURN.
      END.
      dSourceLanguageObj = gsc_language.language_obj.
    
      FIND gsc_language WHERE gsc_language.LANGUAGE_code = coTargetLanguage:SCREEN-VALUE NO-ERROR.
      IF NOT AVAILABLE gsc_language THEN
      DO:
          updateStatus(hStatus, "gsc_language record for source language was not found. Migration borted.") NO-ERROR.
          RETURN.
      END.
      dTargetLanguageObj = gsc_language.language_obj.
    
      ASSIGN lRemoveWidgetTranslation     = toRemove:CHECKED
             lSkipTranslationWhenMultiple = toSkip:CHECKED
             lTestMigration               = toTestMigration:CHECKED.
  END.

  updateStatus(hStatus, "~nWidget-based Translation Migration Started "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS") + "~n") NO-ERROR.
  updateStatus(hStatus, "Source Language: " + coSourceLanguage:SCREEN-VALUE ) NO-ERROR.
  updateStatus(hStatus, "Target Language: " + coTargetLanguage:SCREEN-VALUE ) NO-ERROR.
  updateStatus(hStatus, "~nOptions:") NO-ERROR.
  updateStatus(hStatus, "Remove Widget Translation: " + STRING(lRemoveWidgetTranslation)) NO-ERROR.
  updateStatus(hStatus, "Skip Datafield when ambiguous translation: " + STRING(lSkipTranslationWhenMultiple)) NO-ERROR.
  updateStatus(hStatus, "Test Migration: " + STRING(lTestMigration) + "~n") NO-ERROR.

  glCancelMigration = FALSE.
  DO iBrowseLoop = 1 TO hEntityBrowse:NUM-SELECTED-ROWS:
      PROCESS EVENTS.
      IF glCancelMigration THEN
      DO:
         updateStatus(hStatus, "~nMigration process was aborted. "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS")) NO-ERROR.
         RETURN.
      END.
      hEntityBrowse:FETCH-SELECTED-ROW(iBrowseLoop).
      FOR EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.object_type_obj = dObjectTypeObj
                                 AND ryc_smartobject.object_filename BEGINS ttEntityList.ttEntityName + ".":
          
          DO iWidgetEntry = 1 TO 2: /* 1 - LABEL, 2 - COLUMN LABEL */
              ASSIGN cOriginalLabel = ? cTranslatedLabel = ? lMultipleTranslationFound = FALSE.

              FIND FIRST gsm_translation WHERE gsm_translation.widget_type         = "DATAFIELD":U
                                           AND gsm_translation.WIDGET_entry        = iWidgetEntry
                                           AND gsm_translation.source_language_obj = dSourceLanguageObj
                                           AND gsm_translation.language_obj        = dTargetLanguageObj
                                           AND gsm_translation.object_filename     = ENTRY(1, ryc_smartobject.object_filename, '.')
                                           AND gsm_translation.widget_name         = ENTRY(2, ryc_smartobject.object_filename, '.') NO-ERROR.
              IF AVAILABLE gsm_translation THEN
              DO:
                  updateStatus(hStatus, "EXISTING TRANSLATION FOUND for: DATAFIELD "
                                        + gsm_translation.object_filename + " " 
                                        + gsm_translation.widget_name) NO-ERROR.
                  NEXT.
              END.
              FOR EACH gsm_translation NO-LOCK /* A translation can come from any widget_type DATAFIELD */
                       WHERE (IF iWidgetEntry = 1 THEN gsm_translation.widget_type <> "BROWSE":U 
                                                  ELSE (gsm_translation.widget_type = "BROWSE":U OR gsm_translation.widget_type = "DATAFIELD":U))
                         AND gsm_translation.source_language_obj = dSourceLanguageObj
                         AND gsm_translation.language_obj        = dTargetLanguageObj
                         AND gsm_translation.widget_name         = ENTRY(2, ryc_smartobject.object_filename, '.'):

                  IF gsm_translation.widget_type = "DATAFIELD" AND gsm_translation.widget_entry <> iWidgetEntry THEN
                      NEXT.
                  IF cTranslatedLabel = ? THEN
                      ASSIGN cOriginalLabel     = gsm_translation.original_label
                             cTranslatedLabel   = gsm_translation.translation_label
                             cSrcObjectFilename = gsm_translation.object_filename
                             cSrcWidgetType     = gsm_translation.widget_type.
                  ELSE
                  DO:
                      IF cTranslatedLabel <> gsm_translation.translation_label THEN
                      DO:
                          lMultipleTranslationFound = TRUE.
                          updateStatus(hStatus, "MULTIPLE TRANSLATIONS FOUND for: DATAFIELD "
                                       + ENTRY(1, ryc_smartobject.object_filename, '.') + " " 
                                       + ENTRY(2, ryc_smartobject.object_filename, '.') 
                                       + IF lSkipTranslationWhenMultiple THEN " (translation skipped)" ELSE " (ignored)"
                                       ) NO-ERROR.
                          IF lSkipTranslationWhenMultiple THEN 
                              cTranslatedLabel = "". /* Disables creation of translation record */
                          LEAVE.
                      END.
                  END.
              END. /* FOR EACH gsm_translation */
    
              IF cTranslatedLabel > "" THEN
              DO:
                  IF NOT lTestMigration THEN
                  DO:
                      CREATE bNewTranslation.
                      /* Uses automatic value of translation_obj */
                      ASSIGN bNewTranslation.object_filename     = ENTRY(1, ryc_smartobject.object_filename, '.')
                             bNewTranslation.widget_name         = ENTRY(2, ryc_smartobject.object_filename, '.')
                             bNewTranslation.source_language_obj = dSourceLanguageObj
                             bNewTranslation.language_obj        = dTargetLanguageObj
                             bNewTranslation.widget_type         = "DATAFIELD":U
                             bNewTranslation.widget_entry        = iWidgetEntry
                             bNewTranslation.original_label      = cOriginalLabel
                             bNewTranslation.translation_label   = cTranslatedLabel
                             bNewTranslation.original_tooltip    = ""
                             bNewTranslation.translation_tooltip = "".
                      RELEASE bNewTranslation.
                  END.
                  updateStatus(hStatus, "~n" + (IF lTestMigration THEN "[TEST MIGRATION] " ELSE " ")
                                        + "TRANSLATION CREATED: DATAFIELD "
                                        + ENTRY(2, ryc_smartobject.object_filename, '.') + " on entity " 
                                        + ENTRY(1, ryc_smartobject.object_filename, '.')
                                        + " from " 
                                        + cSrcWidgetType + " "
                                        + ENTRY(2, ryc_smartobject.object_filename, '.')
                                        + " on " + cSrcObjectFilename + ". " 
                                        + (IF cSrcWidgetType = "BROWSE" THEN "Column label: " ELSE "Label: ")
                                        + cTranslatedLabel) NO-ERROR.

                  /* Delete widget-based translation records */
                  IF lRemoveWidgetTranslation THEN
                  DO:
                       /* Deletes gsm_translation records for the same type of widget with matching translations 
                          and blank tooltips */
                      FOR EACH gsm_translation 
                          WHERE gsm_translation.widget_type <> "DATAFIELD":U /* Do not delete datafield translations */
                            AND gsm_translation.widget_type         = cSrcWidgetType
                            AND gsm_translation.source_language_obj = dSourceLanguageObj
                            AND gsm_translation.language_obj        = dTargetLanguageObj
                            AND gsm_translation.widget_name         = ENTRY(2, ryc_smartobject.object_filename, '.')
                            AND gsm_translation.translation_label   = cTranslatedLabel
                            AND gsm_translation.original_label      = cOriginalLabel
                            :
                          IF gsm_translation.original_tooltip    > "" 
                             OR gsm_translation.translation_tooltip > "" THEN
                          DO:
                             updateStatus(hStatus, "WIDGET-BASED TRANSLATION HAS TOOLTIPS. NOT DELETED") NO-ERROR.
                             NEXT.
                          END.
                          updateStatus(hStatus, (IF lTestMigration THEN "[TEST MIGRATION] " ELSE " ")
                                                + "TRANSLATION REMOVED: " + cSrcWidgetType + " "
                                                + gsm_translation.widget_name + " on "
                                                + gsm_translation.object_filename) NO-ERROR.
                          IF NOT lTestMigration THEN
                              DELETE gsm_translation.
                      END.
                  END.
              END.
          END.
      END.
  END. /* DO iBrowseLoop */
  updateStatus(hStatus, "~nWidget-based Translation Migration Ended "
                        + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS")) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runMigration sObject 
PROCEDURE runMigration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETE hStatus AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cLogFileName  AS CHARACTER  NO-UNDO.

  cLogFileName = SESSION:TEMP-DIRECTORY + "translation_migration.log".

  /* Create log file */
  OUTPUT STREAM logStream TO VALUE(cLogFileName) APPEND.

  RUN migrateWidgetTranslations (hStatus).
  
  updateStatus(hStatus, "~nMigration log appended to " + cLogFileName + "~n").
  OUTPUT STREAM logStream CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateStatus sObject 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT phStatus AS HANDLE,
    INPUT pcLine AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function appends the status in the status window.
    Notes:  Input - phStatus - The handle to the status Editor widget
                  - pcLine - the contents to be displayed.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lStatus AS LOGICAL     NO-UNDO.

  PUT STREAM logStream UNFORMATTED pcLine SKIP. /* Write log file */

  IF NOT VALID-HANDLE(phStatus) THEN
    RETURN FALSE.

  lStatus = phStatus:INSERT-STRING(pcLine).
  lStatus = phStatus:INSERT-STRING("~n").

  /* If editor limit has been reached,
        clear editor and continue adding content */
  IF NOT lStatus THEN
  DO:
      phStatus:SCREEN-VALUE = "":U. 
      phStatus:INSERT-STRING(pcLine).
      phStatus:INSERT-STRING("~n").
  END.

  phStatus:MOVE-TO-EOF().

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

