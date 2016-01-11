&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"auditing/sdo/_audevpolicysdo.i"}.



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
&Scoped-define DATA-FIELD-DEFS "auditing/sdo/_audevpolicysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject._Event-id RowObject._Event-level ~
RowObject._Event-criteria 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS RowObject._Event-id RowObject._Event-level ~
RowObject._Event-criteria 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnLookup 
     IMAGE-UP FILE "adeicon/select.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 5 BY 1.14 TOOLTIP "Find event id".

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 146 BY 6.05.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnLookup AT ROW 2.19 COL 34 WIDGET-ID 2 NO-TAB-STOP 
     RowObject._Event-id AT ROW 2.19 COL 32 RIGHT-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN NATIVE 
          SIZE 16 BY 1 TOOLTIP "The unique identifier for the event"
     RowObject._Event-level AT ROW 4.1 COL 15 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Off",0,
                     "Mininum",1,
                     "Full",2
          DROP-DOWN-LIST
          SIZE 34 BY 1 TOOLTIP "Defines if auditing is on or off for this event"
     RowObject._Event-criteria AT ROW 1.71 COL 65 NO-LABEL WIDGET-ID 8
          VIEW-AS EDITOR MAX-CHARS 3000 SCROLLBAR-VERTICAL
          SIZE 80 BY 5.24 TOOLTIP "Optional field that stores extra info for application-level events"
     "Criteria:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.71 COL 56 WIDGET-ID 10
     "Audit Event Details" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 1 COL 4 WIDGET-ID 12
     RECT-2 AT ROW 1.24 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 110.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "auditing/sdo/_audevpolicysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {auditing/sdo/_audevpolicysdo.i}
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
         HEIGHT             = 6.38
         WIDTH              = 147.2.
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

/* SETTINGS FOR BUTTON btnLookup IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR RowObject._Event-criteria IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject._Event-id IN FRAME F-Main
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
  DEFINE VARIABLE cEventList     AS CHARACTER NO-UNDO.

  /* bring up the window so the user can select the event */
  RUN auditing/ui/_addmultevents.w (INPUT NO, /* not multi-select */
                                    OUTPUT cEventList).
    
  /* cEventList will have only one entry which is the event the user selected */
  IF cEventList <> ""  THEN DO:
      /* set the fields with the values returned */
      assignWidgetValue('_Event-id':U,ENTRY(1,cEventList)).
      APPLY "value-changed" TO RowObject._Event-id IN FRAME {&FRAME-NAME}.
  END.

  RUN applyEntry IN TARGET-PROCEDURE ('_Event-id').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject._Event-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Event-id vTableWin
ON F4 OF RowObject._Event-id IN FRAME F-Main /* Event id */
DO:
    APPLY "choose" TO btnLookup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Event-id vTableWin
ON LEAVE OF RowObject._Event-id IN FRAME F-Main /* Event id */
DO:
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.

  /* check if event id is valid */
  ASSIGN hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
  IF NOT DYNAMIC-FUNCTION('is-valid-event-id':U IN hDataSource, INPUT INTEGER(SELF:SCREEN-VALUE)) THEN DO:
      MESSAGE "Event id " SELF:SCREEN-VALUE " is not a valid id" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  /* depending on the event id, the options in the event level combo are
     different - for db events (event id < 10000), the only options are
     OFF or ON
  */
  IF INTEGER(SELF:SCREEN-VALUE) < 10000 THEN DO: /* db events */
      /* remove "Full" for db events */
      IF LOOKUP("Full",RowObject._Event-level:LIST-ITEM-PAIRS) > 0 THEN
         RowObject._Event-level:DELETE("Full").

      /* for non-db events, option 2 is 'On' */
      IF LOOKUP("On",RowObject._Event-level:LIST-ITEM-PAIRS) = 0 THEN
          RowObject._Event-level:REPLACE("On",1,2).
  END.
  ELSE DO:
      /* add 'full" for non-db events */
      IF LOOKUP("Full",RowObject._Event-level:LIST-ITEM-PAIRS) = 0 THEN
         RowObject._Event-level:ADD-LAST("Full",2).

      /* for non-db events, option 2 is 'Minimum' */
      IF LOOKUP("Minimum",RowObject._Event-level:LIST-ITEM-PAIRS) = 0 THEN
          RowObject._Event-level:REPLACE("Minimum",1,2).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject._Event-id vTableWin
ON VALUE-CHANGED OF RowObject._Event-id IN FRAME F-Main /* Event id */
DO:
    IF INTEGER(SELF:SCREEN-VALUE) < 32000 THEN /* system events */
        ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE
        ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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
  Notes:       This override enables event-id when adding a new record. 
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN RowObject._Event-id:SENSITIVE IN FRAME {&FRAME-NAME}= YES
         btnLookup:SENSITIVE =  YES.

  /* make event on by default */
  ASSIGN RowObject._Event-level:SCREEN-VALUE =  RowObject._Event-level:ENTRY(2)
         RowObject._Event-level:MODIFIED = YES.
  
  APPLY "entry" TO RowObject._Event-id.
  
  /* this will get the events cached. Do it now, just in case we haven't cached
     them yet, so we don't do in the middle of the transaction started when the user
     tries to save the record (this is because the temp-table used to store
     the events is a NO-UNDO temp-table, and we don't want to mess up with
     transaction backout and no-undo temp-table/dataset.
  */
  RUN get-audit-events IN hAuditCacheMgr (INPUT ? /* using the APMT's working db */).

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
  Notes:        This override enables event-id when adding a new record. 
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN RowObject._Event-id:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         btnLookup:SENSITIVE =  YES.

  APPLY "entry" TO RowObject._Event-id.

  /* this will get the events cached. Do it now, just in case we haven't cached
     them yet, so we don't do in the middle of the transaction started when the user
     tries to save the record (this is because the temp-table used to store
     the events is a NO-UNDO temp-table, and we don't want to mess up with
     transaction backout and no-undo temp-table/dataset.
  */
  RUN get-audit-events IN hAuditCacheMgr (INPUT ? /* using the APMT's working db */).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override disables the event-id smartselect. We only enable i
               in addRecord and copyRecord.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN RowObject._Event-id:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               btnLookup:SENSITIVE =  NO
               RowObject._Event-criteria:SENSITIVE = NO.


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
  Notes:       This override disables the event-id smartselect. We only enable i
               in addRecord and copyRecord.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE id AS INTEGER NO-UNDO INIT 32000.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* depending on the event id, the options in the event level combo are
     different - for db events (event id < 10000), the only options are
     OFF or ON. Also, the criteria field is really only for appl level events, so
     disable the editor for system events after the call to SUPER.
  */
  IF NUM-ENTRIES(pcColValues) > 1 THEN DO:
      ASSIGN id = INTEGER(ENTRY(2, pcColValues, CHR(1))).
  
      IF id < 10000 THEN /* db events */
          RowObject._Event-level:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} ="Off,0,On,1".
      ELSE
          RowObject._Event-level:LIST-ITEM-PAIRS ="Off,0,Mininum,1,Full,2".

  END.

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  /* we should have set the id properly above */

  IF id < 32000 THEN /* system events */
      ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE
      ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  ASSIGN RowObject._Event-id:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         btnLookup:SENSITIVE =  NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This override subscribe to an event and populates the event id
               combo-box.
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
  Notes:       This override takes care of the case where the user added a new record,
               and hit the resrt button. We need to leave the event-id combo-box enabled. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE isEnabled AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN isEnabled = RowObject._Event-id:SENSITIVE IN FRAME {&FRAME-NAME} .
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

   IF isEnabled THEN DO:
       ASSIGN RowObject._Event-id:SENSITIVE = YES
              btnLookup:SENSITIVE =  YES.
       APPLY "entry" TO RowObject._Event-id.
   END.

   IF INTEGER(RowObject._Event-id:SCREEN-VALUE) < 32000 THEN /* system events */
       ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
   ELSE
       ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = YES.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectedMultipleRows vTableWin 
PROCEDURE selectedMultipleRows :
/*------------------------------------------------------------------------------
  Purpose:     Decides if the criteria field should be enabled or not.
               The smartbrowse publishes an event when the user selects
               multiple rows and he deselects them
               
  Parameters:  INPUT lMod - either YES or NO.

  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lMod AS LOGICAL NO-UNDO.

    /* disable the criteria field if more than one row is selected in the
       browse, otherwise make sure it's enabled if the event level is enabled.
    */
    IF lMod = YES THEN
       ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE IF RowObject._Event-level:SENSITIVE = YES THEN DO:
            IF INTEGER(RowObject._Event-id:SCREEN-VALUE) < 32000 THEN /* system events */
                ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN RowObject._Event-criteria:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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
               to, so when the user updates an existng record, we propagate the
               same changes to all records selected in the smartbrowse.
------------------------------------------------------------------------------*/
DEFINE VARIABLE IsNew       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValues     AS CHARACTER NO-UNDO.
DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* check if this is a new or existing record */
  ASSIGN isNew = getNewRecord().

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

   IF isNew = "NO":U THEN DO:
       /* if updating, publish this event so the smartbrowse can reset the
          record value if more than one record is selected 
       */
       ASSIGN hDataSource = DYNAMIC-FUNCTION('getDataSource')
           cValues = "_Event-level":U + CHR(1) + RowObject._Event-level:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
          
       PUBLISH "updatedEventPolicy" FROM hDataSource (INPUT cValues).
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

