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
&Scoped-Define ENABLED-OBJECTS coDatabase coLanguage BROWSE-7 buDeselectAll 
&Scoped-Define DISPLAYED-OBJECTS coDatabase coLanguage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE VARIABLE coLanguage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Language" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 37 BY 1 TOOLTIP "Select a db and press Refresh to show information for the selected db only" NO-UNDO.

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
     coDatabase AT ROW 1.48 COL 15.6 COLON-ALIGNED
     coLanguage AT ROW 1.48 COL 68.8 COLON-ALIGNED
     BROWSE-7 AT ROW 3.14 COL 4
     buSelectAll AT ROW 14.33 COL 33
     buDeselectAll AT ROW 14.33 COL 48
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
         HEIGHT             = 14.67
         WIDTH              = 116.2.
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
/* BROWSE-TAB BROWSE-7 coLanguage F-Main */
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
/* SETTINGS FOR COMBO-BOX coLanguage IN FRAME F-Main
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLanguageList sObject 
PROCEDURE getLanguageList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will find the language list.
  Parameters:  output - Comma separated language list.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcLanguageList AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      CASE coLanguage:SCREEN-VALUE:
          WHEN "<ALL>":U THEN DO:
              FOR EACH gsc_language:
                   ASSIGN pcLanguageList = pcLanguageList + ",":U + gsc_language.language_code.
              END.
              ASSIGN pcLanguageList = TRIM(pcLanguageList, ",":U).
          END.
          WHEN "<None - No Translation>":U THEN DO:
              ASSIGN pcLanguageList = "NONE":U.
          END.
          OTHERWISE
              ASSIGN pcLanguageList = coLanguage:SCREEN-VALUE.
      END CASE.
  END.
  RETURN.
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

  ASSIGN cLanguageList = "<ALL>,<None - No Translation>":U.
  FOR EACH gsc_language BY language_code:
      cLanguageList = cLanguageList + ",":U + language_code.
  END.
  DO WITH FRAME {&FRAME-NAME}:
    coDatabase:LIST-ITEMS = cDBList.
    coDatabase:SCREEN-VALUE = coDatabase:ENTRY(iPick).
    coLanguage:LIST-ITEMS = cLanguageList.
    coLanguage:SCREEN-VALUE = "<ALL>":U.
  END.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  ENABLE ALL WITH FRAME F-main.

  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "getEntityList":U IN ghContainerSource.
      SUBSCRIBE TO "getLanguageList" IN ghContainerSource.
      SUBSCRIBE TO "getEntityBrowse":U IN ghContainerSource.
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

