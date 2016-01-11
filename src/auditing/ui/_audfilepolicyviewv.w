&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"auditing/sdo/_audfilepolicysdo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

{auditing/include/_aud-cache.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "auditing/sdo/_audfilepolicysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject._Audit-create-level ~
RowObject._Create-event-id RowObject._Audit-update-level ~
RowObject._Update-event-id RowObject._Audit-delete-level ~
RowObject._Delete-event-id 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-4 toggle-create toggle-update ~
toggle-delete 
&Scoped-Define DISPLAYED-FIELDS RowObject._File-name RowObject._Owner ~
RowObject._Audit-create-level RowObject._Create-event-id ~
RowObject._Audit-update-level RowObject._Update-event-id ~
RowObject._Audit-delete-level RowObject._Delete-event-id 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toggle-create toggle-update toggle-delete 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnLookup 
     IMAGE-UP FILE "adeicon/select.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find table name".

DEFINE BUTTON btnLookup-create 
     IMAGE-UP FILE "adeicon/select.bmp":U
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find event id".

DEFINE BUTTON btnLookup-delete 
     IMAGE-UP FILE "adeicon/select.bmp":U
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find event id".

DEFINE BUTTON btnLookup-update 
     IMAGE-UP FILE "adeicon/select.bmp":U
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find event id".

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 144 BY 5.48.

DEFINE VARIABLE toggle-create AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.8 BY .81 TOOLTIP "Store each field in an individual audit data value record during a create event" NO-UNDO.

DEFINE VARIABLE toggle-delete AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.8 BY .81 TOOLTIP "Store each field in an individual audit data value record during a delete event" NO-UNDO.

DEFINE VARIABLE toggle-update AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.8 BY .81 TOOLTIP "Store each field in individual audit data value record during an update event" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnLookup AT ROW 1.71 COL 69 WIDGET-ID 2 NO-TAB-STOP 
     RowObject._File-name AT ROW 1.71 COL 20 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 47 BY 1 TOOLTIP "Name of the table to be audited"
     RowObject._Owner AT ROW 1.71 COL 93 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 48 BY 1 TOOLTIP "The owner of this table"
     RowObject._Audit-create-level AT ROW 2.91 COL 20 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this table (Off)",0,
                     "Audit table but do not store initial values (Min)",1,
                     "Audit table and store initial values (Std)",12
          DROP-DOWN-LIST
          SIZE 52 BY 1 TOOLTIP "Level of auditing active for this table during a create event"
     RowObject._Create-event-id AT ROW 2.91 COL 111 RIGHT-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "The event ID that drives the auditing of the create event for this table"
     btnLookup-create AT ROW 2.91 COL 113 WIDGET-ID 12 NO-TAB-STOP 
     toggle-create AT ROW 3.05 COL 122.2 WIDGET-ID 120
     RowObject._Audit-update-level AT ROW 4.1 COL 20 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this table (Off)",0,
                     "Audit table but do not store old and new values (Min)",1,
                     "Audit table and store new values (Std)",12,
                     "Audit table and store old and new values (Full)",13
          DROP-DOWN-LIST
          SIZE 52 BY 1 TOOLTIP "Level of auditing active for this table during an update event"
     RowObject._Update-event-id AT ROW 4.1 COL 111 RIGHT-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "The event ID that drives the auditing of the update event for this table"
     btnLookup-update AT ROW 4.1 COL 113 WIDGET-ID 18 NO-TAB-STOP 
     toggle-update AT ROW 4.24 COL 122.2 WIDGET-ID 122
     RowObject._Audit-delete-level AT ROW 5.29 COL 20 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this table (Off)",0,
                     "Audit table but do not store deleted record (Min)",1,
                     "Audit table and store deleted record (Std)",12
          DROP-DOWN-LIST
          SIZE 52 BY 1 TOOLTIP "Level of auditing active for this table during a delete event"
     RowObject._Delete-event-id AT ROW 5.29 COL 111 RIGHT-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "The event ID that drives the auditing of the delete event for this table"
     btnLookup-delete AT ROW 5.29 COL 113 WIDGET-ID 24 NO-TAB-STOP 
     toggle-delete AT ROW 5.43 COL 122.2 WIDGET-ID 124
     "Audit Table Details" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 1 COL 5 WIDGET-ID 26
     RECT-4 AT ROW 1.24 COL 2 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 30.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "auditing/sdo/_audfilepolicysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {auditing/sdo/_audfilepolicysdo.i}
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
         HEIGHT             = 5.81
         WIDTH              = 145.6.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnLookup IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnLookup-create IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnLookup-delete IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnLookup-update IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject._Create-event-id IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN RowObject._Delete-event-id IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN RowObject._File-name IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject._Owner IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject._Update-event-id IN FRAME F-Main
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLookup vTableWin
ON CHOOSE OF btnLookup IN FRAME F-Main
DO:
  DEFINE VARIABLE cTableList AS CHARACTER NO-UNDO.

  /* bring up the window so the user can select the table name */
  RUN auditing/ui/_audfileselectw.w (INPUT 0, 
                                     OUTPUT cTableList).

  /* cTableList should have two entries: table-name,Owner */
  IF NUM-ENTRIES(cTableList) = 2 THEN DO:

      /* set the fields with the values returned */
      assignWidgetValue('_File-name':U,ENTRY(1,cTableList)).

      /* if owner info is empty, then user picked a table owned by "PUB" */
      IF  ENTRY(2,cTableList) = "":U THEN
          assignWidgetValue('_Owner':U,"PUB":U).
      ELSE
          assignWidgetValue('_Owner':U,ENTRY(2,cTableList)).

      /* assing these to zero so that we refresh them to display the proper values */
      ASSIGN RowObject._Create-event-id:SCREEN-VALUE = "0"
             RowObject._Update-event-id:SCREEN-VALUE = "0"
             RowObject._Delete-event-id:SCREEN-VALUE = "0".

      RUN assign-default-event-ids.
  END.

  RUN applyEntry IN TARGET-PROCEDURE ('_File-name').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLookup-create
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLookup-create vTableWin
ON CHOOSE OF btnLookup-create IN FRAME F-Main
DO:

DEFINE VARIABLE cEventList     AS CHARACTER NO-UNDO.

  /* bring up the window so the user can select the event */
  RUN auditing/ui/_addmultevents.w (INPUT NO, /* not multi-select */
                                    OUTPUT cEventList).
    
  /* cEventList will have only one entry which is the event the user selected */
  IF cEventList <> ""  THEN DO:
      /* set the fields with the values returned */
      assignWidgetValue('_Create-event-id':U,ENTRY(1,cEventList)).
  END.

  RUN applyEntry IN TARGET-PROCEDURE ('_Create-event-id').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLookup-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLookup-delete vTableWin
ON CHOOSE OF btnLookup-delete IN FRAME F-Main
DO:
 
DEFINE VARIABLE cEventList     AS CHARACTER NO-UNDO.

      /* bring up the window so the user can select the event */
      RUN auditing/ui/_addmultevents.w (INPUT NO, /* not multi-select */
                                        OUTPUT cEventList).

      /* cEventList will have only one entry which is the event the user selected */
      IF cEventList <> ""  THEN DO:
          /* set the fields with the values returned */
          assignWidgetValue('_Delete-event-id':U,ENTRY(1,cEventList)).
      END.

      RUN applyEntry IN TARGET-PROCEDURE ('_Delete-event-id').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLookup-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLookup-update vTableWin
ON CHOOSE OF btnLookup-update IN FRAME F-Main
DO:
    DEFINE VARIABLE cEventList     AS CHARACTER NO-UNDO.

      /* bring up the window so the user can select the event */
      RUN auditing/ui/_addmultevents.w (INPUT NO, /* not multi-select */
                                        OUTPUT cEventList).

      /* cEventList will have only one entry which is the event the user selected */
      IF cEventList <> ""  THEN DO:
          /* set the fields with the values returned */
          assignWidgetValue('_Update-event-id':U,ENTRY(1,cEventList)).
      END.

      RUN applyEntry IN TARGET-PROCEDURE ('_Update-event-id').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toggle-create
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toggle-create vTableWin
ON VALUE-CHANGED OF toggle-create IN FRAME F-Main /* 1 record/field */
DO:
   DEFINE VAR level AS INT NO-UNDO.

   /* the only level that can have '1 record/fld' turned on and off is
      level 2 (standard). So we can assume the level is neither 0 nor 1,
      since the toggle-box would not be sensitive in such cases.
   */
   ASSIGN level = RowObject._Audit-create-level:INPUT-VALUE IN
                          FRAME {&FRAME-NAME}.

   /* adjust the value of the entry in the combo-box and reassign the value */
   IF SELF:CHECKED THEN DO:
      level = level - 10. /* individual-record / non-streamed */
       RowObject._Audit-create-level:REPLACE (
                 "Audit table and store initial values (Std)",2,3).
   END.
   ELSE DO:
      level = level + 10. /* streamed */
             RowObject._Audit-create-level:REPLACE (
                 "Audit table and store initial values (Std)",12,3).
   END.
   
   /* get the right value to show up */
   assignWidgetValue('_Audit-create-level', STRING(level)).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toggle-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toggle-delete vTableWin
ON VALUE-CHANGED OF toggle-delete IN FRAME F-Main /* 1 record/field */
DO:
  
   DEFINE VAR level AS INT NO-UNDO.

   /* the only level that can have '1 record/fld' turned on and off is
      level 2 (standard).  So we can assume the level is neither 0 nor 1,
      since the toggle-box would not be sensitive in such cases.
   */
   ASSIGN level = RowObject._Audit-delete-level:INPUT-VALUE IN
                          FRAME {&FRAME-NAME}.

   /* adjust the value of the entry in the combo-box and reassign the value */
   IF SELF:CHECKED THEN DO:
      level = level - 10. /* individual-record / non-streamed */
       RowObject._Audit-delete-level:REPLACE (
                 "Audit table and store deleted record (Std)",2,3).
   END.
   ELSE DO:
      level = level + 10. /* streamed */
             RowObject._Audit-delete-level:REPLACE (
                 "Audit table and store deleted record (Std)",12,3).
   END.
   
   /* get the right value to show up */
   assignWidgetValue('_Audit-delete-level', STRING(level)).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toggle-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toggle-update vTableWin
ON VALUE-CHANGED OF toggle-update IN FRAME F-Main /* 1 record/field */
DO:
   DEFINE VAR level AS INT NO-UNDO.

   /* the only levels that can have '1 record/fld' turned on and off is
      level 2 (standard) and level 3 (full).  So we can assume the level 
      is neither 0 nor 1, since the toggle-box would not be sensitive 
      in such cases.
   */
   ASSIGN level = RowObject._Audit-update-level:INPUT-VALUE IN
                          FRAME {&FRAME-NAME}.

   /* adjust the value of the entry in the combo-box and reassign the value */
   IF SELF:CHECKED THEN DO:
      level = level - 10. /* individual-record / non-streamed */
       RowObject._Audit-update-level:REPLACE (
                 "Audit table and store new values (Std)",2,3).
       RowObject._Audit-update-level:REPLACE (
                 "Audit table and store old and new values (Full)",3,4).
   END.
   ELSE DO:
      level = level + 10. /* streamed */
      RowObject._Audit-update-level:REPLACE (
                "Audit table and store new values (Std)",12,3).
      RowObject._Audit-update-level:REPLACE (
                "Audit table and store old and new values (Full)",13,4).
   END.
   
   /* get the right value to show up */
   assignWidgetValue('_Audit-update-level', STRING(level)).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Audit-create-level
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Audit-create-level vTableWin
ON VALUE-CHANGED OF RowObject._Audit-create-level IN FRAME F-Main /* Audit create level */
DO:
  /* keep adm2/default behavior */
  RUN ValueChanged IN THIS-PROCEDURE.

  /* '1 rec/fld' (non-streamed) setting is only valid for level 2 (Standard) */
  IF SELF:INPUT-VALUE < 2 THEN DO:
      ASSIGN toggle-create:CHECKED = NO
             toggle-create:SENSITIVE = NO.
  END.
  ELSE
      toggle-create:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Audit-delete-level
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Audit-delete-level vTableWin
ON VALUE-CHANGED OF RowObject._Audit-delete-level IN FRAME F-Main /* Audit delete level */
DO:

  /* keep adm2/default behavior */
  RUN ValueChanged IN THIS-PROCEDURE.

  /* '1 rec/fld' (non-streamed) setting is only valid for level 2 (Standard) */
  IF SELF:INPUT-VALUE < 2 THEN DO:
      ASSIGN toggle-delete:CHECKED = NO 
             toggle-delete:SENSITIVE = NO.
  END.
  ELSE
      ASSIGN toggle-delete:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Audit-update-level
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Audit-update-level vTableWin
ON VALUE-CHANGED OF RowObject._Audit-update-level IN FRAME F-Main /* Audit update level */
DO:

  /* keep adm2/default behavior */
  RUN ValueChanged IN THIS-PROCEDURE.

  /* '1 rec/fld' (non-streamed) setting is only valid for levels 2 (Standard)
     and 3 (Full)
  */
  IF SELF:INPUT-VALUE < 2 THEN DO:
      ASSIGN toggle-update:CHECKED = NO
             toggle-update:SENSITIVE = NO.
  END.
  ELSE
      ASSIGN toggle-update:SENSITIVE = YES.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Create-event-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Create-event-id vTableWin
ON F4 OF RowObject._Create-event-id IN FRAME F-Main /* Create event id */
DO:
    APPLY "choose" TO btnLookup-create.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Delete-event-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Delete-event-id vTableWin
ON F4 OF RowObject._Delete-event-id IN FRAME F-Main /* Delete event id */
DO:
    APPLY "choose" TO btnLookup-delete.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._File-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._File-name vTableWin
ON F4 OF RowObject._File-name IN FRAME F-Main /* Table name */
DO:
  APPLY "choose" TO btnLookup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._File-name vTableWin
ON LEAVE OF RowObject._File-name IN FRAME F-Main /* Table name */
DO:

DEFINE VARIABLE cOwner AS CHARACTER NO-UNDO.

  ASSIGN RowObject._File-name:SCREEN-VALUE = TRIM(RowObject._File-name:SCREEN-VALUE).

  IF RowObject._File-name:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Table name is a mandatory field." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  /* if owner info is empty, we haven't had a chance to validate the
     table name, so do it now 
  */
  IF RowObject._Owner:SCREEN-VALUE = "" OR  
     RowObject._Owner:SCREEN-VALUE = ? THEN DO:
     cOwner = DYNAMIC-FUNCTION('get-owner-tbl-cache' IN hAuditCacheMgr, 
                                INPUT RowObject._File-name:SCREEN-VALUE).

         IF cOwner = "" THEN DO:
             MESSAGE "Could not find table " + RowObject._File-name:SCREEN-VALUE 
              + " in the working database" VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
         END.

         ASSIGN RowObject._Owner:SCREEN-VALUE = cOwner.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._File-name vTableWin
ON VALUE-CHANGED OF RowObject._File-name IN FRAME F-Main /* Table name */
DO:
DEFINE VARIABLE cOwner AS CHARACTER NO-UNDO.

   /* see if we can find the table the user chose so we can fill out
      the default event id values
   */
   cOwner = DYNAMIC-FUNCTION('get-owner-tbl-cache' IN hAuditCacheMgr, 
                             INPUT RowObject._File-name:SCREEN-VALUE).

   ASSIGN RowObject._Owner:SCREEN-VALUE = cOwner.

   IF cOwner <> "" THEN
         RUN assign-default-event-ids.
   ELSE
       ASSIGN RowObject._Create-event-id:SCREEN-VALUE = "0"
              RowObject._Update-event-id:SCREEN-VALUE = "0"
              RowObject._Delete-event-id:SCREEN-VALUE = "0".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Update-event-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Update-event-id vTableWin
ON F4 OF RowObject._Update-event-id IN FRAME F-Main /* Update event id */
DO:
    APPLY "choose" TO btnLookup-update.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override enables the table name field and the lookup button
               so user can set table name when adding record.
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* enable widgets that are only enabled when adding a new record */

  enableWidget('btnLookup,_File-name'). 
  
  RUN applyEntry IN TARGET-PROCEDURE ('_File-name').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjust-level-items vTableWin 
PROCEDURE adjust-level-items :
/*------------------------------------------------------------------------------
  Purpose:     Adjust the values of the items in the level combo-boxes to
               display the values from the record.
               
               The level contains two forms of information: recording-level and
               recording-method (> 10 streamed, otherwise non-streamed).
               Streamed mode is the default, and we indicate it as non-streamed
               with the toggle-create, toggle-update and toggle-delete widgets.
               
               Therefore, we need to make sure that the values in the combo-boxes
               have the level stored in the record that is about to be displayed. 
               
               This gets called from displayRecord only.
               
  Parameters:  pcColValues - string with the values to be displayed
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDisplayedFields   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iValue             AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFieldName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE tValueCreate       AS INTEGER   NO-UNDO.
DEFINE VARIABLE tValueUpdate       AS INTEGER   NO-UNDO.
DEFINE VARIABLE tValueDelete       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCount             AS INTEGER   NO-UNDO INIT 0.

    {get DisplayedFields cDisplayedFields}.

    /* I could just look at the entry, but if we add more fields to the viewer,
       then this code won't break. 
    */
    DO iValue = 1 TO NUM-ENTRIES(cDisplayedFields):
        
        cFieldName = ENTRY(iValue,cDisplayedFields).

        IF cFieldName = "_Audit-create-level" THEN DO:
           tValueCreate = INTEGER(ENTRY(iValue + 1,pcColValues,CHR(1))).
           iCount = iCount + 1.

        END.

        IF cFieldName = "_Audit-update-level" THEN DO:
           tValueUpdate = INTEGER(ENTRY(iValue + 1,pcColValues,CHR(1))).
           iCount = iCount + 1.
        END.

        IF cFieldName = "_Audit-delete-level" THEN DO:
           tValueDelete = INTEGER(ENTRY(iValue + 1,pcColValues,CHR(1))).
           iCount = iCount + 1.
        END.

        IF iCount = 3 THEN /* we are done */
           LEAVE.
    END.

    /* we need to adjust the values of some of the items in the level
       combo-boxes to account for streamed/non-streamed mode.
       
       If showing up levels 0, 1 or higher than 10, then the options in the
       combo-boxes default to the streamed mode (which is the default).
    */
    IF tValueCreate < 2 OR tValueCreate > 10 THEN DO:

       RowObject._Audit-create-level:REPLACE (
                 "Audit table and store initial values (Std)",12,3) IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        RowObject._Audit-create-level:REPLACE(
                "Audit table and store initial values (Std)",2,3).
    END.

    IF tValueUpdate  < 2 OR tValueUpdate > 10 THEN DO:

       RowObject._Audit-update-level:REPLACE (
                 "Audit table and store new values (Std)",12,3).
       RowObject._Audit-update-level:REPLACE(
               "Audit table and store old and new values (Full)",13,4).
    END.
    ELSE DO:
        RowObject._Audit-update-level:REPLACE(
                "Audit table and store new values (Std)",2,3).
        RowObject._Audit-update-level:REPLACE(
                "Audit table and store old and new values (Full)",3,4).

    END.

    IF tValueDelete < 2 OR tValueDelete > 10 THEN DO:

       RowObject._Audit-delete-level:REPLACE (
                 "Audit table and store deleted record (Std)",12,3).
    END.
    ELSE DO:
        RowObject._Audit-delete-level:REPLACE(
                "Audit table and store deleted record (Std)",2,3).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjust-toggle-boxes vTableWin 
PROCEDURE adjust-toggle-boxes :
/*------------------------------------------------------------------------------
  Purpose:   Adjust the values of the toggle-boxes to account for 
             streamed/non-streamed mode.
             
             If showing up levels 0, 1 or higher than 10, then the corresponding 
             toggle-box is checked off.  
             
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

    IF RowObject._Audit-create-level:INPUT-VALUE IN FRAME {&FRAME-NAME} < 2 OR 
       RowObject._Audit-create-level:INPUT-VALUE > 10 THEN
       ASSIGN toggle-create:CHECKED = NO.
    ELSE 
       ASSIGN toggle-create:CHECKED = YES.

    IF RowObject._Audit-update-level:INPUT-VALUE  < 2 OR 
       RowObject._Audit-update-level:INPUT-VALUE > 10 THEN
       ASSIGN toggle-update:CHECKED = NO.
    ELSE
       ASSIGN toggle-update:CHECKED = YES.

    IF RowObject._Audit-delete-level:INPUT-VALUE < 2 OR
       RowObject._Audit-delete-level:INPUT-VALUE > 10 THEN 
       ASSIGN toggle-delete:CHECKED = NO.
    ELSE
        ASSIGN toggle-delete:CHECKED = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-default-event-ids vTableWin 
PROCEDURE assign-default-event-ids :
/*------------------------------------------------------------------------------
  Purpose:     Assign the default-event-ids for the table selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cIds        AS CHARACTER NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
    
        IF INTEGER(RowObject._Create-event-id:SCREEN-VALUE) = 0 AND
           INTEGER(RowObject._Update-event-id:SCREEN-VALUE) = 0 AND
           INTEGER(RowObject._Delete-event-id:SCREEN-VALUE) = 0 THEN 
        DO:

            RUN auditing/_get-def-eventids.p (INPUT RowObject._File-name:SCREEN-VALUE,
                                              OUTPUT cIds).
            /* cIds has the ids in the following order:
               create,update,delete 
            */
            ASSIGN RowObject._Create-event-id:SCREEN-VALUE = ENTRY(1,cIds)
                   RowObject._Create-event-id:MODIFIED = YES 
                   RowObject._Update-event-id:SCREEN-VALUE = ENTRY(2,cIds)
                   RowObject._Update-event-id:MODIFIED = YES 
                   RowObject._Delete-event-id:SCREEN-VALUE = ENTRY(3,cIds)
                   RowObject._Delete-event-id:MODIFIED = YES.

            RUN check-fields-to-enable.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-fields-to-enable vTableWin 
PROCEDURE check-fields-to-enable :
/*------------------------------------------------------------------------------
  Purpose:     Checks which fields to enable based on the table name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cIds AS CHARACTER NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

         RUN auditing/_get-def-eventids.p (INPUT RowObject._File-name:SCREEN-VALUE,
                                           OUTPUT cIds).
    
         /* if any of the ids is 0 then it doesn't apply for this table */
         /* create */
         IF ENTRY(1,cIds) = "0":U THEN
             disableWidget('_Create-event-id,_Audit-create-level').
         ELSE
             enableWidget('_Create-event-id,_Audit-create-level').
    
          /* update */
          IF NUM-ENTRIES (cIds) > 1 AND ENTRY(2,cIds) = "0":U THEN
             disableWidget ('_update-event-id,_Audit-update-level').
          ELSE
             enableWidget ('_update-event-id,_Audit-update-level').
    
         /* delete */
         IF NUM-ENTRIES (cIds) > 2 AND ENTRY(3,cIds) = "0":U THEN
            disableWidget ('_Delete-event-id,_Audit-Delete-level').
         ELSE
            enableWidget ('_Delete-event-id,_Audit-Delete-level').
          
          /* make sure lookup buttons follow the sensitivity of the respective
             fill-in 
          */
          ASSIGN btnLookup-create:SENSITIVE =  RowObject._Create-event-id:SENSITIVE
                 btnLookup-update:SENSITIVE =  RowObject._Update-event-id:SENSITIVE
                 btnLookup-delete:SENSITIVE =  RowObject._Delete-event-id:SENSITIVE.

        /* sensitiviness of '1 rec/fld' toggles depend on the level */
        ASSIGN toggle-create:SENSITIVE = RowObject._Audit-create-level:SENSITIVE
               toggle-update:SENSITIVE = RowObject._Audit-update-level:SENSITIVE
               toggle-delete:SENSITIVE = RowObject._Audit-delete-level:SENSITIVE.

        IF RowObject._Audit-create-level:INPUT-VALUE < 2 THEN
           toggle-create:SENSITIVE = NO.

        IF RowObject._Audit-update-level:INPUT-VALUE < 2 THEN
           toggle-update:SENSITIVE = NO.

        IF RowObject._Audit-delete-level:INPUT-VALUE < 2 THEN
           toggle-delete:SENSITIVE = NO.
        
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmDelete vTableWin 
PROCEDURE confirmDelete :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Override so we display our own message
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER plAnswer AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lMult    AS LOGICAL   NO-UNDO INIT NO.
  DEFINE VARIABLE hCSource AS HANDLE    NO-UNDO.

  /* check if multiple records are selected before deleting */
  ASSIGN hCSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  lMult = DYNAMIC-FUNCTION ('hasMultipleSelected':U IN hCSource) NO-ERROR.
  IF lMult THEN DO:
      MESSAGE "Select only one record to be deleted" VIEW-AS ALERT-BOX ERROR.
      plAnswer = NO.
      RETURN.
  END.

  /* OVERRIDE STANDARD BEHAVIOR - DISPLAY OUR OWN MESSAGE */

  /* Code placed here will execute PRIOR to standard behavior. */
  /*  RUN SUPER( INPUT-OUTPUT plAnswer).*/
  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN hSDO = DYNAMIC-FUNCTION('getDataSource')
         cValue = DYNAMIC-FUNCTION("columnStringValue":U IN hSDO,
                                         INPUT "_File-name").
   ASSIGN cMessage = "Do you want to delete table " + QUOTER(TRIM(cValue)) + " ?" 
          cMessage = cMessage + "~n(Note that any field settings for this table will also be deleted)".

   MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
           UPDATE plAnswer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:      This override enables the table name field and the lookup button
               so user can set table name when adding record. 
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* when copying an existing record, enable these widgets */
  enableWidget('btnLookup,_File-name'). 

  RUN applyEntry IN TARGET-PROCEDURE ('_File-name').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN btnLookup-create:SENSITIVE =  RowObject._Create-event-id:SENSITIVE
             btnLookup-update:SENSITIVE =  RowObject._Update-event-id:SENSITIVE
             btnLookup-delete:SENSITIVE =  RowObject._Delete-event-id:SENSITIVE
             toggle-create:SENSITIVE = btnLookup-create:SENSITIVE
             toggle-update:SENSITIVE = btnLookup-update:SENSITIVE
             toggle-delete:SENSITIVE = btnLookup-delete:SENSITIVE.
  END.

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override disables the table name field and the lookup button
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFields   AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* adjust the values in the combo-boxes to match the value we are going
     to display 
  */
  RUN adjust-level-items (INPUT pcColValues).

  RUN SUPER( INPUT pcColValues).

  RUN adjust-toggle-boxes.

  /* Code placed here will execute AFTER standard behavior.    */
  disableWidget('btnLookup,_File-name'). 

  /* when display fields, make sure we don't enable the unnecessary fields */
  IF pcColValues <> ? THEN DO:
     /* check if we have an update target, otherwise don't call check-fields-to-enable,
        or we may end up enabling fields when we should not
     */
     {get UpdateTarget cTarget}.
     hUpdateTarget = WIDGET-HANDLE(cTarget).

     IF VALID-HANDLE(hUpdateTarget) THEN DO:
        RUN check-fields-to-enable.
     END.
  END.
  ELSE /* disable toggle boxes if not displaying any record */
     ASSIGN toggle-create:SENSITIVE IN FRAME {&FRAME-NAME} = NO
            toggle-update:SENSITIVE = NO
            toggle-delete:SENSITIVE = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override enables the table name field and the lookup button
               in case user hit the reset button while adding a new record..
------------------------------------------------------------------------------*/
  DEF VAR isEnabled AS LOGICAL.
  DEF VAR cValue AS CHAR.

  /* Code placed here will execute PRIOR to standard behavior. */

  ASSIGN isEnabled = RowObject._File-name:SENSITIVE IN FRAME {&FRAME-NAME}.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

   IF isEnabled THEN do:
        enableWidget('btnLookup,_File-name':U). 

        RUN applyEntry IN TARGET-PROCEDURE ('_File-name':U).
    END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override publishes an event which the smartbrowser subscribes
               to, so when the user updates an exising record, we propagate the
               same changes to all records selected in the smartbrowse.
------------------------------------------------------------------------------*/
DEFINE VARIABLE IsNew         AS CHARACTER NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cValues       AS CHARACTER NO-UNDO INIT "":U.
DEFINE VARIABLE cChangeInfo   AS CHARACTER NO-UNDO INIT "":U.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* check if this is a new or existing record */
  ASSIGN isNew = getNewRecord().

  /* get the updated fields */
  IF isNew = "NO":U THEN
     RUN collectChanges IN TARGET-PROCEDURE (INPUT-OUTPUT cValues,
                                             INPUT-OUTPUT cChangeInfo).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

   IF isNew = "NO":U THEN DO:
       /* if updating, publish this event so the smartbrowse can reset the
          record value if more than one record is selected 
       */
       ASSIGN hDataSource = DYNAMIC-FUNCTION('getDataSource').

       PUBLISH "updatedFilePolicy" FROM hDataSource (INPUT cValues).
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields vTableWin 
PROCEDURE validateFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override sets the owner to PUB if it was not set up to this point. This happens
               if the user typed the table name instead of picking one through the lookup
               button.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcNotValidFields AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cOwner AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPage  AS INTEGER   NO-UNDO.


  /* Code placed here will execute PRIOR to standard behavior. */

  /* if the owner info is blank, we didn't have a chance to validate the table
     name is valid
  */
  IF LENGTH(RowObject._Owner:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
      /* check if table name is valid in the working db */
      cOwner = DYNAMIC-FUNCTION('get-owner-tbl-cache' IN hAuditCacheMgr, 
                                 INPUT RowObject._File-name:SCREEN-VALUE).
      
      IF cOwner = "" THEN DO: /* didn't find a matching table name */

          {get ObjectPage iPage}.

           pcNotValidFields = 
               RowObject._File-name:NAME + ",":U 
              + STRING(iPage) + ",":U 
              + STRING(TARGET-PROCEDURE).

           RUN AddMessage IN TARGET-PROCEDURE ("Could not find table " + RowObject._File-name:SCREEN-VALUE 
                 + " in the working database","Table Name",?).     

           RETURN.
      END.
   END.

  RUN SUPER( INPUT-OUTPUT pcNotValidFields).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

