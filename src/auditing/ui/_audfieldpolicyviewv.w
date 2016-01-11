&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"auditing/sdo/_audfieldpolicysdo.i"}.



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
DEFINE VARIABLE firstTime AS LOGICAL NO-UNDO INIT YES.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "auditing/sdo/_audfieldpolicysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject._Audit-create-level ~
RowObject._Audit-update-level RowObject._Audit-delete-level 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS btnLookup Identifying toggle-create ~
toggle-update toggle-delete RECT-3 
&Scoped-Define DISPLAYED-FIELDS RowObject._File-name RowObject._Owner ~
RowObject._Field-name RowObject._Audit-identifying-field ~
RowObject._Audit-create-level RowObject._Audit-update-level ~
RowObject._Audit-delete-level 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS Identifying toggle-create toggle-update ~
toggle-delete 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnLookup 
     IMAGE-UP FILE "adeicon/select.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find field name".

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 6.43.

DEFINE VARIABLE Identifying AS LOGICAL INITIAL no 
     LABEL "Identifying field" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 TOOLTIP "Include field in the sequence of fields that make up the identifying info" NO-UNDO.

DEFINE VARIABLE toggle-create AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 TOOLTIP "Record field in an individual audit data value record during a create event" NO-UNDO.

DEFINE VARIABLE toggle-delete AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 TOOLTIP "Record field in an individual audit data value record during a delete event" NO-UNDO.

DEFINE VARIABLE toggle-update AS LOGICAL INITIAL no 
     LABEL "1 record/field" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 TOOLTIP "Record field in an individual audit data value record during an update event" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnLookup AT ROW 2.67 COL 68 WIDGET-ID 2 NO-TAB-STOP 
     RowObject._File-name AT ROW 1.48 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Name of the table that the field settings are for"
     RowObject._Owner AT ROW 1.48 COL 91 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 36 BY 1 TOOLTIP "The schema owner of the table"
     RowObject._Field-name AT ROW 2.67 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN NATIVE 
          SIZE 47 BY 1 TOOLTIP "Name of the field to be audited"
     Identifying AT ROW 2.71 COL 81 WIDGET-ID 70
     RowObject._Audit-identifying-field AT ROW 2.67 COL 119 COLON-ALIGNED WIDGET-ID 12
          LABEL "Ordinal Position"
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1 TOOLTIP "Field position in the sequence of fields that make up the identifying info"
     RowObject._Audit-create-level AT ROW 3.91 COL 19 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this field (Off)",-1,
                     "Use the audit level set for the table (Use Table)",0,
                     "Do not audit this field's value (Min)",1,
                     "Audit this field's value (Std)",12
          DROP-DOWN-LIST
          SIZE 53 BY 1 TOOLTIP "Level of auditing active for this field during a create event"
     toggle-create AT ROW 3.86 COL 81 WIDGET-ID 72
     RowObject._Audit-update-level AT ROW 5.14 COL 19 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this field (Off)",-1,
                     "Use the audit level set for the table (Use Table)",0,
                     "Audit this field; do not record the field's value (Min)",1,
                     "Audit this field; record the updated field value (Std)",12,
                     "Audit this field; record old and updated field values(Full)",13
          DROP-DOWN-LIST
          SIZE 53 BY 1 TOOLTIP "Level of auditing active for this field during an update event"
     toggle-update AT ROW 5.1 COL 81 WIDGET-ID 74
     RowObject._Audit-delete-level AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Do not audit this field (Off)",-1,
                     "Use the audit level set for the table (Use Table)",0,
                     "Do not audit this field's value (Min)",1,
                     "Audit this field's value (Std)",12
          DROP-DOWN-LIST
          SIZE 53 BY 1 TOOLTIP "Level of auditing active for this field during a delete event"
     toggle-delete AT ROW 6.33 COL 81 WIDGET-ID 76
     RowObject._Audit-read-level AT ROW 1 COL 109 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Use Table",0,
                     "Minimum Audit Data",1,
                     "Standard Audit Data",2
          DROP-DOWN-LIST
          SIZE 36 BY 1
     "Audit Field Details" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1 COL 3 WIDGET-ID 20
     RECT-3 AT ROW 1.24 COL 1 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 70.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "auditing/sdo/_audfieldpolicysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {auditing/sdo/_audfieldpolicysdo.i}
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
         HEIGHT             = 6.67
         WIDTH              = 146.4.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RowObject._Audit-identifying-field IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX RowObject._Audit-read-level IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RowObject._Audit-read-level:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN RowObject._Field-name IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject._File-name IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject._Owner IN FRAME F-Main
   NO-ENABLE                                                            */
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
  DEFINE VARIABLE cFieldList AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cInfo      AS CHARACTER NO-UNDO.

  ASSIGN cInfo = RowObject._File-name:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         + "," + RowObject._Owner:SCREEN-VALUE.

  /* bring up the window so the user can select the table name */
  RUN auditing/ui/_audmultfields.w (INPUT cInfo,
                                    INPUT NO /* no multiple selection */, 
                                    OUTPUT cFieldList).

  IF cFieldList <> "" THEN DO:

      ASSIGN RowObject._Field-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFieldList
             RowObject._Field-name:MODIFIED = YES.
  END.

  APPLY "entry" TO RowObject._Field-name.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Identifying
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Identifying vTableWin
ON VALUE-CHANGED OF Identifying IN FRAME F-Main /* Identifying field */
DO:
  IF SELF:CHECKED THEN DO:
     enableWidget('_Audit-identifying-field').

     assignWidgetValue('_Audit-identifying-field':U,"1").
  END.
  ELSE DO:
      assignWidgetValue('_Audit-identifying-field':U,"0").

      disableWidget('_Audit-identifying-field').
  END.
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
                  "Audit this field's value (Std)",2,4).
    END.
    ELSE DO:
       level = level + 10. /* streamed */
              RowObject._Audit-create-level:REPLACE (
                  "Audit this field's value (Std)",12,4).
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
       level = level - 10.    /* individual-record / non-streamed */
        RowObject._Audit-delete-level:REPLACE (
                  "Audit this field's value (Std)",2,4).
    END.
    ELSE DO:
       level = level + 10.   /* streamed */
              RowObject._Audit-delete-level:REPLACE (
                  "Audit this field's value (Std)",12,4).
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
                  "Audit this field; record the updated field value (Std)",2,4).
        RowObject._Audit-update-level:REPLACE (
                  "Audit this field; record old and updated field values(Full)",3,5).
    END.
    ELSE DO:
       level = level + 10. /* streamed */
       RowObject._Audit-update-level:REPLACE (
                 "Audit this field; record the updated field value (Std)",12,4).
       RowObject._Audit-update-level:REPLACE (
                 "Audit this field; record old and updated field values(Full)",13,5).
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

  /* '1 rec/fld' (non-streamed) setting is only valid for levels Standard(2) and
     Full(3)
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


&Scoped-define SELF-NAME RowObject._Field-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Field-name vTableWin
ON F4 OF RowObject._Field-name IN FRAME F-Main /* Field name */
DO:
  APPLY "choose" TO btnLookup.
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
  Notes:       This override publishs an event to the fields sdo so
               it shows the fields for the current table. It also enables
               the _Field-name smartselect.
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* enable field name so user can enter the info */
  ASSIGN  RowObject._Field-name:SENSITIVE IN FRAME {&FRAME-NAME} = YES
          btnLookup:SENSITIVE = YES.

  RUN check-fields-to-enable.

  APPLY "Entry" TO RowObject._Field-name.

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
                 "Audit this field's value (Std)",12,4) IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        RowObject._Audit-create-level:REPLACE(
                "Audit this field's value (Std)",2,4).
    END.

    IF tValueUpdate  < 2 OR tValueUpdate > 10 THEN DO:

       RowObject._Audit-update-level:REPLACE (
                 "Audit this field; record the updated field value (Std)",12,4).
       RowObject._Audit-update-level:REPLACE(
               "Audit this field; record old and updated field values(Full)",13,5).
    END.
    ELSE DO:
        RowObject._Audit-update-level:REPLACE(
                "Audit this field; record the updated field value (Std)",2,4).
        RowObject._Audit-update-level:REPLACE(
                "Audit this field; record old and updated field values(Full)",3,5).

    END.

    IF tValueDelete < 2 OR tValueDelete > 10 THEN DO:

       RowObject._Audit-delete-level:REPLACE (
                 "Audit this field's value (Std)",12,4).
    END.
    ELSE DO:
        RowObject._Audit-delete-level:REPLACE(
                "Audit this field's value (Std)",2,4).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjust-toggle-boxes vTableWin 
PROCEDURE adjust-toggle-boxes :
/*------------------------------------------------------------------------------
  Purpose:     Adjust the values of the toggle-boxes to account for
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-fields-to-enable vTableWin 
PROCEDURE check-fields-to-enable :
/*------------------------------------------------------------------------------
  Purpose:     Checks if we need to disable some of the fields or not.
               If the event does apply at the table level, it doesn't
               apply at the field level.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cIds        AS CHARACTER NO-UNDO.

DEFINE VARIABLE cLinks AS CHARACTER NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        /* disable it and uncheck it just in case we have no record to
          display.
        */
        ASSIGN Identifying:SENSITIVE = NO
               Identifying:CHECKED = NO.

        /* if table name is empty, then we don't have any records to display */
        IF RowObject._File-name:SCREEN-VALUE = "" OR 
           RowObject._File-name:SCREEN-VALUE = ? THEN DO:
           RETURN.
        END.

        cLinks = getUpdateTarget().

        /* if this object has no update target, don't bother checking if need to the fields
           enable fields, since we can't enable anything.
        */
        IF cLinks = "":U OR cLinks = ? THEN
           RETURN.

        RUN auditing/_get-def-eventids.p (INPUT RowObject._File-name:SCREEN-VALUE,
                                          OUTPUT cIds).
    
        /* if the default event for a given table is 0, then the event doesn't
           apply to the table, hence it doesn't apply to the field 
        */
        /* create */
        IF ENTRY(1,cIds) = "0" THEN 
            disableWidget('_Audit-create-level').
        ELSE
            enableWidget('_Audit-create-level').    

        /* update */
        IF ENTRY(2,cIds) = "0" THEN
            disableWidget('_Audit-update-level').
        ELSE
            enableWidget('_Audit-update-level').    
    
        /* delete */
        IF ENTRY(3,cIds) = "0" THEN
            disableWidget('_Audit-delete-level').
        ELSE
            enableWidget('_Audit-delete-level').    

        ASSIGN Identifying:SENSITIVE = YES.

        IF INTEGER(RowObject._Audit-identifying-field:SCREEN-VALUE) > 0 THEN DO:
            ASSIGN identifying:CHECKED = YES.
            enableWidget('_Audit-identifying-field').
        END.
        ELSE DO:
            ASSIGN identifying:CHECKED = NO.
            disableWidget('_Audit-identifying-field').
        END.

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
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER plAnswer AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE lMult    AS LOGICAL   NO-UNDO INIT NO.
  DEFINE VARIABLE hCSource AS HANDLE    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* check if multiple records are selected before deleting */
  ASSIGN hCSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  lMult = DYNAMIC-FUNCTION ('hasMultipleSelected':U IN hCSource) NO-ERROR.
  IF lMult THEN DO:
      MESSAGE "Select only one record to be deleted" VIEW-AS ALERT-BOX ERROR.
      plAnswer = NO.
      RETURN.
  END.

  RUN SUPER( INPUT-OUTPUT plAnswer).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override enables the _Field-name smartselect. 
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* enable field name so user can enter the info */
  ASSIGN RowObject._Field-name:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         btnLookup:SENSITIVE = YES.

  RUN check-fields-to-enable.

  APPLY "Entry" TO RowObject._Field-name.

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

  /* field name should only be enabled when adding record */
  ASSIGN RowObject._Field-name:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         btnLookup:SENSITIVE = NO
         Identifying:SENSITIVE = NO
         toggle-create:SENSITIVE = RowObject._Audit-create-level:SENSITIVE
         toggle-update:SENSITIVE = RowObject._Audit-update-level:SENSITIVE
         toggle-delete:SENSITIVE = RowObject._Audit-delete-level:SENSITIVE.
  
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
  Notes:       This override diables the _Field-name smartselect.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* adjust the values in the combo-boxes to match the value we are going
     to display 
  */
  RUN adjust-level-items (INPUT pcColValues).

  RUN SUPER( INPUT pcColValues).

  RUN adjust-toggle-boxes.

  /* disable the toggle-boxes if not displaying any record */
  IF pcColValues = ? THEN
     ASSIGN toggle-create:SENSITIVE IN FRAME {&FRAME-NAME} = NO
            toggle-update:SENSITIVE = NO
            toggle-delete:SENSITIVE = NO.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN check-fields-to-enable.

 /* field name should only be enabled when adding record */
  ASSIGN RowObject._Field-name:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         btnLookup:SENSITIVE = NO.


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
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* subscribe to this event which gets published by the smartbrowse when
     the user selects multiple rows 
  */
  ASSIGN 
      hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  IF VALID-HANDLE (hContainerSource) THEN
     SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'selectedMultipleRows' IN hContainerSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override takes care of the case where the user added a new record
               and hit the reset button. We should leave the field-name field
               enabled.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE isEnabled AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  ASSIGN isEnabled = RowObject._Field-name:SENSITIVE IN FRAME {&FRAME-NAME}.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

   IF isEnabled THEN DO:
          ASSIGN RowObject._Field-name:SENSITIVE= YES
                 btnLookup:SENSITIVE = YES.
          APPLY "Entry" TO RowObject._Field-name.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectedMultipleRows vTableWin 
PROCEDURE selectedMultipleRows :
/*------------------------------------------------------------------------------
  Purpose:     Decides if the identifying field should be enabled or not.
               The smartbrowse publishes an event when the user selects
               multiple rows and he deselects them
               
  Parameters:  INPUT lMod - either YES or NO.
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lMod AS LOGICAL NO-UNDO.

    /* disable the identifying field if more than one row is selected in the
       browse, otherwise make sure it's enabled if the update event level is enabled.
    */
    IF lMod = YES THEN
       ASSIGN RowObject._Audit-identifying-field:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              identifying:SENSITIVE = NO.
    ELSE IF RowObject._Audit-create-level:SENSITIVE = YES THEN
             ASSIGN RowObject._Audit-identifying-field:SENSITIVE = YES
                    identifying:SENSITIVE = YES .

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
DEFINE VARIABLE IsNew       AS CHARACTER NO-UNDO.
DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
DEFINE VARIABLE cValues     AS CHARACTER NO-UNDO INIT "":U.
DEFINE VARIABLE cChangeInfo AS CHARACTER NO-UNDO INIT "":U.

  /* Code placed here will execute PRIOR to standard behavior. */

   /* check if this is a new or existing record */
   ASSIGN isNew = getNewRecord().

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

       PUBLISH "updatedFieldPolicy" FROM hDataSource (INPUT cValues).
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

