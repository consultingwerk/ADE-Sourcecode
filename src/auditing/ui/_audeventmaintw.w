&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: _audeventmaintw.w

  Description: Audit event maintenance window. Allows user to view, create
               and update the records in the _aud-event table in the database
               passed in pcDbInfo. Used by the APMT utility.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: March 04, 2005

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
DEFINE INPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hEventTT     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hEventBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE cMode        AS CHARACTER NO-UNDO.
DEFINE VARIABLE isDbReadOnly AS LOGICAL   NO-UNDO.
DEFINE VARIABLE isAdmin      AS LOGICAL   NO-UNDO INIT NO.

{auditing/include/_aud-cache.i}
{auditing/include/_aud-std.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnAdd RECT-2 RECT-3 btnImport ~
disp-sys-events Description 
&Scoped-Define DISPLAYED-OBJECTS disp-sys-events Event-id Event-type ~
Event-name Description 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Export       LABEL "&Export..."    
       MENU-ITEM m_Import       LABEL "&Import..."    
       RULE
       MENU-ITEM m_Add_record   LABEL "&Add record"   
       MENU-ITEM m_Copy_record  LABEL "&Copy record"  
       RULE
       MENU-ITEM m_Save_record  LABEL "&Save record"  
       MENU-ITEM m_Reset        LABEL "&Reset"        
       MENU-ITEM m_Cancel       LABEL "Cance&l"       
       RULE
       MENU-ITEM m_Exit         LABEL "&Exit"         .

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_OpenEdge_Master_Help LABEL "OpenEdge Master Help"
       MENU-ITEM m_Audit_Policy_Maintenance_To LABEL "Audit Policy Maintenance Help Topics".

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAdd 
     IMAGE-UP FILE "auditing/ui/image/add.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 1" 
     SIZE 5 BY 1.14 TOOLTIP "Add record"
     BGCOLOR 8 .

DEFINE BUTTON btnCancel 
     IMAGE-UP FILE "auditing/ui/image/cancel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "btnCancel" 
     SIZE 5 BY 1.14 TOOLTIP "Cancel"
     BGCOLOR 8 .

DEFINE BUTTON btnCopy 
     IMAGE-UP FILE "auditing/ui/image/copyrec.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "btnCopy" 
     SIZE 5 BY 1.14 TOOLTIP "Copy record"
     BGCOLOR 8 .

DEFINE BUTTON btnExport 
     LABEL "Export" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btnImport 
     LABEL "Import" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btnReset 
     IMAGE-UP FILE "auditing/ui/image/reset.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "btnReset" 
     SIZE 5 BY 1.14 TOOLTIP "Reset"
     BGCOLOR 8 .

DEFINE BUTTON btnSave 
     IMAGE-UP FILE "auditing/ui/image/saverec.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "btnSave" 
     SIZE 5 BY 1.14 TOOLTIP "Save record"
     BGCOLOR 8 .

DEFINE VARIABLE Description AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
     SIZE 82 BY 4.05 NO-UNDO.

DEFINE VARIABLE Event-id AS INTEGER FORMAT "->>>>>9":U INITIAL 0 
     LABEL "Event id" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE Event-name AS CHARACTER FORMAT "X(35)":U 
     LABEL "Event name" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE Event-type AS CHARACTER FORMAT "X(15)":U 
     LABEL "Event type" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 98 BY 8.57.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 101 BY 1.33.

DEFINE VARIABLE disp-sys-events AS LOGICAL INITIAL no 
     LABEL "Display System Events" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnAdd AT ROW 1.24 COL 1.6 NO-TAB-STOP WIDGET-ID 2
     btnExport AT ROW 2.67 COL 68 WIDGET-ID 4
     btnImport AT ROW 2.67 COL 85 WIDGET-ID 6
     disp-sys-events AT ROW 15.05 COL 3 WIDGET-ID 8
     Event-id AT ROW 16.86 COL 15 COLON-ALIGNED WIDGET-ID 10
     Event-type AT ROW 18 COL 15 COLON-ALIGNED WIDGET-ID 12
     Event-name AT ROW 19.24 COL 15 COLON-ALIGNED WIDGET-ID 14
     Description AT ROW 20.43 COL 17 NO-LABEL WIDGET-ID 16
     btnCancel AT ROW 1.24 COL 21.6 NO-TAB-STOP  WIDGET-ID 18
     btnCopy AT ROW 1.24 COL 6.6 NO-TAB-STOP WIDGET-ID 20
     btnReset AT ROW 1.24 COL 16.6 NO-TAB-STOP WIDGET-ID 22
     btnSave AT ROW 1.24 COL 11.6 NO-TAB-STOP WIDGET-ID 24
     "Event details" VIEW-AS TEXT 
          SIZE 13 BY .62 AT ROW 16.14 COL 5 WIDGET-ID 26
     "Description:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 20.52 COL 5.4 WIDGET-ID 28
     RECT-2 AT ROW 16.38 COL 3 WIDGET-ID 30
     RECT-3 AT ROW 1.14 COL 1 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.8 BY 24.29.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Events Maintenance"
         HEIGHT             = 24.29
         WIDTH              = 101.8
         MAX-HEIGHT         = 29.19
         MAX-WIDTH          = 103
         VIRTUAL-HEIGHT     = 29.19
         VIRTUAL-WIDTH      = 103
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon/progress.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/progress.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btnCancel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnCopy IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnExport IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnReset IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnSave IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       Description:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN Event-id IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Event-name IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Event-type IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Events Maintenance */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON ENTRY OF C-Win /* Events Maintenance */
DO:
    ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON HELP OF C-Win /* Events Maintenance */
DO:
  RUN adecomm/_adehelp.p ("audit":U, "TOPICS":U, ?, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Events Maintenance */
DO:
  /* check if there are changes to be saved before exiting */
  IF cMode <> "" THEN DO:
      MESSAGE "You have made changes to a record that are not saved.~n~nDo you wish to save your changes now?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE choice AS LOGICAL.

      CASE choice:
          WHEN YES THEN DO:
              RUN doSaveRecord.
          END.
          WHEN NO THEN DO:
              /* ok to leave */.
          END.
          OTHERWISE DO:
              /* user selected the Cancel button, so don't exit   */
              RETURN NO-APPLY.
          END.
      END CASE.

  END.

  RUN cleanup.

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAdd C-Win
ON CHOOSE OF btnAdd IN FRAME DEFAULT-FRAME /* Button 1 */
DO:
    RUN doAddRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCancel C-Win
ON CHOOSE OF btnCancel IN FRAME DEFAULT-FRAME /* btnCancel */
DO:
    RUN doCancelRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCopy C-Win
ON CHOOSE OF btnCopy IN FRAME DEFAULT-FRAME /* btnCopy */
DO:
    RUN doCopyRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExport C-Win
ON CHOOSE OF btnExport IN FRAME DEFAULT-FRAME /* Export */
DO:
  RUN doExport.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImport C-Win
ON CHOOSE OF btnImport IN FRAME DEFAULT-FRAME /* Import */
DO:
  RUN doImport.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnReset C-Win
ON CHOOSE OF btnReset IN FRAME DEFAULT-FRAME /* btnReset */
DO:
    RUN doResetRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSave C-Win
ON CHOOSE OF btnSave IN FRAME DEFAULT-FRAME /* btnSave */
DO:
    RUN doSaveRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Description
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Description C-Win
ON VALUE-CHANGED OF Description IN FRAME DEFAULT-FRAME
DO:
    /* set mode to update if no set yet */
    IF cMode = "" THEN DO:
       RUN enable-update (INPUT "Update":U).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME disp-sys-events
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL disp-sys-events C-Win
ON VALUE-CHANGED OF disp-sys-events IN FRAME DEFAULT-FRAME /* Display System Events */
DO:
  /* reopen the query so we display the events the user wants. Also apply event
     to the browse so user sees the values of the record selected on the browse
     in the event details fields.
  */
  RUN open-query-event.

  APPLY "value-changed" TO hBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Event-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Event-id C-Win
ON LEAVE OF Event-id IN FRAME DEFAULT-FRAME /* Event id */
DO:
  /* make sure event id is valid */
  IF INTEGER(SELF:SCREEN-VALUE) < 32000 THEN DO:
      MESSAGE "Event id must be a value greater than 31999"
               VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Event-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Event-name C-Win
ON VALUE-CHANGED OF Event-name IN FRAME DEFAULT-FRAME /* Event name */
DO:
  /* set mode to update if no set yet */
  IF cMode = "" THEN DO:
     RUN enable-update (INPUT "Update":U).
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Event-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Event-type C-Win
ON VALUE-CHANGED OF Event-type IN FRAME DEFAULT-FRAME /* Event type */
DO:
    /* set mode to update if no set yet */
    IF cMode = "" THEN DO:
       RUN enable-update (INPUT "Update":U).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Add_record
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Add_record C-Win
ON CHOOSE OF MENU-ITEM m_Add_record /* Add record */
DO:
  RUN doAddRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Audit_Policy_Maintenance_To
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Audit_Policy_Maintenance_To C-Win
ON CHOOSE OF MENU-ITEM m_Audit_Policy_Maintenance_To /* Audit Policy Maintenance Help Topics */
DO:
  APPLY "HELP" TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cancel C-Win
ON CHOOSE OF MENU-ITEM m_Cancel /* Cancel */
DO:
  RUN doCancelRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Copy_record
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Copy_record C-Win
ON CHOOSE OF MENU-ITEM m_Copy_record /* Copy record */
DO:
  RUN doCopyRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit C-Win
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "window-close" TO c-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Export
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Export C-Win
ON CHOOSE OF MENU-ITEM m_Export /* Export... */
DO:
  RUN doExport.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Import C-Win
ON CHOOSE OF MENU-ITEM m_Import /* Import... */
DO:
  RUN doImport.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_OpenEdge_Master_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_OpenEdge_Master_Help C-Win
ON CHOOSE OF MENU-ITEM m_OpenEdge_Master_Help /* OpenEdge Master Help */
DO:
  RUN adecomm/_adehelp.p ("mast", "TOPICS", ?, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Reset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Reset C-Win
ON CHOOSE OF MENU-ITEM m_Reset /* Reset */
DO:
  RUN doResetRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_record
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_record C-Win
ON CHOOSE OF MENU-ITEM m_Save_record /* Save record */
DO:
  RUN doSaveRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* this event gets published when the user switches the working db 
(from the main window of the APMT)
*/
SUBSCRIBE TO "changeAuditDatabase":U ANYWHERE RUN-PROCEDURE "refresh-Audit-Events":U.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  RUN enable_UI.

  /* check if user is admin - info passed in pcDbInfo */
  IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&AUDIT-ADMIN})  THEN
     ASSIGN isAdmin = TRUE.

  /* get the audit event records into the cache */
  RUN get-audit-events IN hAuditCacheMgr (INPUT pcDbInfo).

  /* build the browse */
  RUN buildDynamicBrowse.

  /* make sure this window has focus */
  APPLY "entry" TO c-Win.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browse-value-changed C-Win 
PROCEDURE browse-value-changed :
/*------------------------------------------------------------------------------
  Purpose:     Procedure executed for the browse's value-changed trigger
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.

 /* no records available, return */
 IF NOT hEventBuffer:AVAILABLE THEN
    RETURN.

 DO WITH FRAME {&FRAME-NAME}:
 
     /* populate the fields in the "Event details" section with the values
        of the row selected 
     */
     ASSIGN event-id:SCREEN-VALUE = STRING(hEventBuffer::_Event-id)
            Event-type:SCREEN-VALUE = hEventBuffer::_Event-type
            Event-name:SCREEN-VALUE = hEventBuffer::_Event-name
            Description:SCREEN-VALUE = hEventBuffer::_Event-Description.

     IF NOT isDbReadOnly THEN DO:
         /* user can't change systeem events, so disable fields if eevent id
            is < 32000
         */
         IF hEventBuffer::_Event-id < 32000 THEN
            RUN disable-fields.
         ELSE
            RUN enable-fields.
         END.
     END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDynamicBrowse C-Win 
PROCEDURE buildDynamicBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Build a dynamic browse against the temp-table from the 
               _aud-cache.p procedure. We build a query and a browse
               so user can view the records. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* get the handle of the temp-table */
    RUN get-audit-event-tbl-handle IN hAuditCacheMgr (OUTPUT hEventTT).
    
    /* get the temp-table's buffer */
    ASSIGN hEventBuffer = hEventTT:DEFAULT-BUFFER-HANDLE.
    
    /* create a query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hEventBuffer).
    
    /* create the dynamic browse */
    CREATE BROWSE hBrowse
        ASSIGN FRAME = FRAME {&FRAME-NAME}:HANDLE
               QUERY = hQuery
               X = disp-sys-events:X
               Y = btnImport:Y +  btnImport:HEIGHT-PIXELS + (btnImport:HEIGHT-PIXELS / 3 )
               WIDTH = 97
               DOWN = 12
               READ-ONLY = YES
               SEPARATORS = YES
               ROW-MARKERS = NO
               WIDGET-ID = 34
        TRIGGERS:
        ON VALUE-CHANGED PERSISTENT RUN browse-value-changed IN THIS-PROCEDURE.
        END TRIGGERS. 

    /* add the fields to the browse */
    hBrowse:ADD-LIKE-COLUMN(hEventBuffer:BUFFER-FIELD('_Event-id')).
    hBrowse:ADD-LIKE-COLUMN(hEventBuffer:BUFFER-FIELD('_Event-Name')).
    hBrowse:ADD-LIKE-COLUMN(hEventBuffer:BUFFER-FIELD('_Event-Type')).
    hBrowse:ADD-LIKE-COLUMN(hEventBuffer:BUFFER-FIELD('_Event-Description')).

    /* let's view the object */
    ASSIGN hBrowse:EXPANDABLE = YES 
           hBrowse:VISIBLE = YES
           hBrowse:SENSITIVE = TRUE.

    /* opens the query */
    RUN open-query-event.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup C-Win 
PROCEDURE cleanup :
/*------------------------------------------------------------------------------
  Purpose:     Delete the objects created in this procedure.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 IF VALID-HANDLE (hBrowse) THEN
     DELETE OBJECT hBrowse.

 IF VALID-HANDLE (hQuery) THEN DO:

     IF hQuery:IS-OPEN THEN
        hQuery:QUERY-CLOSE.

     DELETE OBJECT hQuery.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clear-fields C-Win 
PROCEDURE clear-fields :
/*------------------------------------------------------------------------------
  Purpose:     Clear the value of all fields in the 'event details' section
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  ASSIGN event-id:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         EVENT-TYPE:SCREEN-VALUE = ""
         event-name:SCREEN-VALUE = ""
         DESCRIPTION:SCREEN-VALUE = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-fields C-Win 
PROCEDURE disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Disable the fields in the "Event details" section
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN event-id:SENSITIVE = NO
               Event-type:SENSITIVE = NO
               Event-name:SENSITIVE = NO
               Description:SENSITIVE = NO
               Description:READ-ONLY = YES.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-record-options C-Win 
PROCEDURE disable-record-options :
/*------------------------------------------------------------------------------
  Purpose:     Disable the menu and buttonsrelated to record operations
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   ASSIGN btnAdd:SENSITIVE IN FRAME {&FRAME-NAME} = NO
          MENU-ITEM m_Add_record:SENSITIVE IN MENU m_File = NO
          btnCopy:SENSITIVE = NO
          MENU-ITEM m_Copy_record:SENSITIVE IN MENU m_File = NO
          btnSave:SENSITIVE = NO
          MENU-ITEM m_Save_record:SENSITIVE IN MENU m_File = NO
          btnReset:SENSITIVE = NO
          MENU-ITEM m_Reset:SENSITIVE IN MENU m_File = NO
          btnCancel:SENSITIVE = NO
          MENU-ITEM m_Cancel:SENSITIVE IN MENU m_File = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-update C-Win 
PROCEDURE disable-update :
/*------------------------------------------------------------------------------
  Purpose:     Change the buttons and menu-items sensitivity when
               turning off update/add/copy mode.
  Parameters:  <none>                
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN btnAdd:SENSITIVE = YES
             MENU-ITEM m_Add_record:SENSITIVE IN MENU m_File = YES
             btnSave:SENSITIVE = NO
             MENU-ITEM m_Save_record:SENSITIVE IN MENU m_File = NO
             btnReset:SENSITIVE = NO
             MENU-ITEM m_Reset:SENSITIVE IN MENU m_File = NO
             btnCancel:SENSITIVE = NO
             MENU-ITEM m_Cancel:SENSITIVE IN MENU m_File = NO
             /* if there are no records in the browse, disable the copy option */
             btnCopy:SENSITIVE = hQuery:NUM-RESULTS <> 0
             MENU-ITEM m_Copy_record:SENSITIVE IN MENU m_File = btnCopy:SENSITIVE.
  END.

  /* make sure browse and toggle-box are sensitive - we disable them 
     when an update is started 
  */
  ASSIGN hBrowse:SENSITIVE = YES
         disp-sys-events:SENSITIVE = YES NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doAddRecord C-Win 
PROCEDURE doAddRecord :
/*------------------------------------------------------------------------------
  Purpose:     User chose the Add record option
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* take care of enabling the correct buttons */                
  RUN enable-update (INPUT "Add":U).

  /* clear the values of the fill-ins */
  RUN clear-fields.

  /* get the next event id (the one after the highest event id value) and assign
     it when adding a new record
  */
  ASSIGN event-id:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
         DYNAMIC-FUNCTION ('getNextAppLevelEventID' IN hAuditCacheMgr).

  APPLY "ENTRY" TO event-id.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCancelRecord C-Win 
PROCEDURE doCancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     User chose the Cancel option while adding or copying a record.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* take care of enabling the buttons properly */
    RUN disable-update.

    /* if export button is disabled, there are no application level events, 
       so disable all fields 
    */
    IF btnExport:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN DO:
       RUN disable-fields.
       /* reset value to 0 in case browse has no other record */
       ASSIGN event-id:SCREEN-VALUE = "0".
    END.

    /* so we display the correct values in the fields */
    APPLY "value-changed" TO hBrowse.

    /* make sure thr event id field is disabled */
    ASSIGN event-id:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           cMode = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCopyRecord C-Win 
PROCEDURE doCopyRecord :
/*------------------------------------------------------------------------------
  Purpose:     user chose the Copy record option
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* take care of enabling the correct buttons */                
    RUN enable-update (INPUT "Copy":U).

    APPLY "ENTRY" TO event-id IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doExport C-Win 
PROCEDURE doExport :
/*------------------------------------------------------------------------------
  Purpose:    Export the audit event records to a .d file. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE csave-file       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE errorMsg         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE numRecs          AS INTEGER     NO-UNDO.

    DO ON ERROR UNDO, LEAVE.
    
       IF NOT isAdmin THEN DO:
           MESSAGE "You are not allowed to run this option" VIEW-AS ALERT-BOX ERROR.
           RETURN.
       END.

       /* bring up the dialog to get the file name */
       RUN auditing/ui/_exp-events.w (OUTPUT csave-file).
                    
       /* check if file name was specified */
       IF csave-file <> "":U THEN DO:

            RUN adecomm/_setcurs.p ("WAIT":u).

            /* call the procedure in the auditCacheMgr procedure to export the 
               audit events
            */
            RUN export-cached-audit-events IN hAuditCacheMgr (INPUT csave-file,
                                                              OUTPUT numRecs).
            /* trap error */
            IF RETURN-VALUE <> "":U THEN
                errorMsg = RETURN-VALUE.
                
            RUN adecomm/_setcurs.p ("":U).

            /* either display error message or number of records exported to the file */
            IF errorMsg <> "":U THEN
               MESSAGE errorMsg VIEW-AS ALERT-BOX.
            ELSE
                MESSAGE numRecs " records exported to " csave-file
                    VIEW-AS ALERT-BOX INFO.
       END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doImport C-Win 
PROCEDURE doImport :
/*------------------------------------------------------------------------------
  Purpose:    Import audit event records from a .d file. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-file           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE errorMsg         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE numRecs          AS INTEGER     NO-UNDO.
DEFINE VARIABLE hEventDataSet    AS HANDLE      NO-UNDO.
DEFINE VARIABLE error%           AS INTEGER     NO-UNDO.

    DO ON ERROR UNDO, LEAVE.
    
       IF NOT isAdmin THEN DO:
           MESSAGE "You are not allowed to run this option!" VIEW-AS ALERT-BOX ERROR.
           RETURN.
       END.

       /* bring up the dialog to get the file name */
       RUN auditing/ui/_imp-events.w (OUTPUT c-file, OUTPUT error%).
                    
       /* check if file name was specified */
       IF c-file <> "":U THEN DO:

            RUN adecomm/_setcurs.p ("WAIT":u).

            /* call the procedure in the auditCacheMgr procedure to import 
               audit events from a .d file
            */
            RUN import-audit-events IN hAuditCacheMgr (INPUT c-file,
                                                       INPUT error%,
                                                       OUTPUT numRecs).

            /* trap error */
            IF RETURN-VALUE <> "":U THEN DO:
                errorMsg = RETURN-VALUE.

                RUN adecomm/_setcurs.p ("":U).

                MESSAGE errorMsg SKIP "Import process canceled.":U VIEW-AS ALERT-BOX ERROR.

                RETURN.
            END.

            /* save the data imported back to the database */
            RUN saveAuditEventChanges IN hAuditCacheMgr.

            ASSIGN errorMsg = RETURN-VALUE.

            RUN adecomm/_setcurs.p ("":U).

            IF errorMsg <> "":U THEN
                MESSAGE errorMsg SKIP "Import process canceled." VIEW-AS ALERT-BOX.
            ELSE DO:

                MESSAGE numRecs " records imported from " c-file
                    VIEW-AS ALERT-BOX INFO.

                IF numRecs > 0 THEN
                   /* reopen the query so user sees records */
                   RUN open-query-event.
            END.
       END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doResetRecord C-Win 
PROCEDURE doResetRecord :
/*------------------------------------------------------------------------------
  Purpose:    user chose the Reset option while updating an existing record. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* restore the value in the record to the fill-ins */
    APPLY "value-changed" TO hBrowse.

    /* go back to the the first editable field */
    APPLY "entry" TO EVENT-TYPE IN FRAME {&FRAME-NAME}.

    /* take care of enabling the buttons properly*/
    RUN disable-update.

    /* reset mode */
    ASSIGN cMode = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doSaveRecord C-Win 
PROCEDURE doSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     User chose the save record option. We save the record right away
               to the database by calling the methods in the 
               _aud-cache.p procedure. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lcData AS LONGCHAR NO-UNDO.

  /* trim everything */
  ASSIGN EVENT-TYPE:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(EVENT-TYPE:SCREEN-VALUE)
         event-name:SCREEN-VALUE = TRIM(event-name:SCREEN-VALUE)
         DESCRIPTION:SCREEN-VALUE = TRIM(DESCRIPTION:SCREEN-VALUE).

  /* check for mandatory fields */
  IF EVENT-TYPE:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Event type is a mandatory field"
               VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  IF event-name:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Event name is a mandatory field"
               VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  /* check if adding/copying or updating record */
  IF cMode = "Add":U OR cMode = "Copy":U THEN DO:
      /* make  sure event-id is valid */
      IF INTEGER(event-id:SCREEN-VALUE) < 32000 THEN DO:
          MESSAGE "Event id must be a value greater than 31999"
                   VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

      /* build the list with the value of each field  */
      ASSIGN lcData = cMode + chr(1) + event-id:SCREEN-VALUE + CHR(1) 
                      + EVENT-TYPE:SCREEN-VALUE + CHR(1) 
                      + event-name:SCREEN-VALUE + CHR(1)
                      + DESCRIPTION:SCREEN-VALUE.

      RUN save-audit-event IN hAuditCacheMgr (INPUT lcData).

      IF RETURN-VALUE <> "" THEN DO:
          MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

      /* reopen the query so we display the new record. Reposition the
         query to the newly added row 
      */
      hBrowse:query:QUERY-OPEN().
      hEventBuffer:FIND-FIRST("where _Event-id = " + event-id:SCREEN-VALUE).

      hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).

      hQuery:REPOSITION-TO-ROWID(hEventBuffer:ROWID).

  END.
  ELSE IF cMode = "Update" THEN DO:

      /* update mode, let's save the record */
      /* build a string with the value of each field */
      ASSIGN lcData = cMode + chr(1) + event-id:SCREEN-VALUE + CHR(1) 
                      + EVENT-TYPE:SCREEN-VALUE + CHR(1) 
                      + event-name:SCREEN-VALUE + CHR(1)
                      + DESCRIPTION:SCREEN-VALUE.

      /* try to save the record */
      RUN save-audit-event IN hAuditCacheMgr (INPUT lcData).

      IF RETURN-VALUE <> "" THEN DO:
          MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

      hBrowse:REFRESH().

  END.

  /* disable buttons properly */
  RUN disable-update.

  ASSIGN event-id:SENSITIVE = NO  /*  event-id should be disabled */
         cMode = "".              /* reset mode */

  /* if the user saved the first application-defined event, enable the 
     export option 
  */
  IF NOT isDbReadOnly AND btnExport:SENSITIVE = NO THEN DO:
     RUN sensitize-export(DYNAMIC-FUNCTION('hasApplEvents' IN hAuditCacheMgr)).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-fields C-Win 
PROCEDURE enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Enable the fields for editing
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
 
     ASSIGN Event-type:SENSITIVE = YES
            Event-name:SENSITIVE = YES
            Description:SENSITIVE = YES
            Description:READ-ONLY = NO.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-update C-Win 
PROCEDURE enable-update :
/*------------------------------------------------------------------------------
  Purpose:     Change the buttons and menus sensitivity accordingly
               depending on the mode the user is running on: add, copy
               or update record
                
  Parameters:  INPUT pcModer - "Add", "Copy" or "Update"
  Notes:       It also enables the event-id field when in Add or Copy mode.
               User can't change the event-id once the record is saved.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      /* change the buttons's sensitivity and allow user to edit the event-id */
      ASSIGN cMode = pcMode
             btnAdd:SENSITIVE = NO
             MENU-ITEM m_Add_record:SENSITIVE IN MENU m_File = NO
             btnCopy:SENSITIVE = NO
             MENU-ITEM m_Copy_record:SENSITIVE IN MENU m_File = NO
             btnSave:SENSITIVE = YES
             MENU-ITEM m_Save_record:SENSITIVE IN MENU m_File = YES
             btnReset:SENSITIVE = IF cMode = "Update":U THEN YES ELSE NO
             MENU-ITEM m_Reset:SENSITIVE IN MENU m_File = btnReset:SENSITIVE
             btnCancel:SENSITIVE = IF cMode = "Update":U THEN NO ELSE YES
             MENU-ITEM m_Cancel:SENSITIVE IN MENU m_File = btnCancel:SENSITIVE.
            
      /* enable the event-id fill-in if adding or copying record */
      IF cMode = "Add":U OR cMode = "Copy":U THEN
         ASSIGN event-id:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

      /* make sure all other fields are enabled if this is the first event */
      IF event-name:SENSITIVE = NO THEN 
         RUN enable-fields.
  END.

  /* make the browse insensitive so user can't change rows. Also don't allow
     user to change the toggle-box */
  ASSIGN hBrowse:SENSITIVE = NO
         disp-sys-events:SENSITIVE = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY disp-sys-events Event-id Event-type Event-name Description 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnAdd RECT-2 RECT-3 btnImport disp-sys-events Description 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-event C-Win 
PROCEDURE open-query-event :
/*------------------------------------------------------------------------------
  Purpose:     Open the query used by the browse. It checks if the
               user wants to see system events.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO INIT "".
                           
    /* close query first */
    IF hQuery:IS-OPEN THEN
       hQuery:QUERY-CLOSE.

    /* build a where clause if user doesn't want to see system events */
    IF disp-sys-events:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO":U  THEN
       ASSIGN cWhere = " where _Event-id >= 32000":U. 

    /* prepare query */
    hQuery:QUERY-PREPARE("FOR EACH ":U + hEventBuffer:NAME + cWhere + " INDEXED-REPOSITION":U).

    /* open query */
    hQuery:QUERY-OPEN.

    RUN query-opened.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE query-opened C-Win 
PROCEDURE query-opened :
/*------------------------------------------------------------------------------
  Purpose:     Called from oopen-query-event so we enable and disable
               the options accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* disable all fields in the 'event details' section */  
    RUN disable-fields.

    /* check if db info passed in  is read-only */
    ASSIGN isDbReadOnly = DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&DB-READ-ONLY}).

    /* if db is read-only then don't allow any changes */
    IF isDbReadOnly OR NOT isAdmin THEN DO:
       RUN sensitize-import(INPUT NO).

       /* disable all record options */
       RUN disable-record-options.
    END.
    ELSE DO:
        RUN sensitize-import(INPUT YES).

        /* disable the buttons which would be enabled if an update is in progress */
        RUN disable-update.
    END.

    /* check if there are any application level events */
    IF isAdmin THEN
       RUN sensitize-export(DYNAMIC-FUNCTION('hasApplEvents' IN hAuditCacheMgr)).
    ELSE
       RUN sensitize-export(INPUT NO).

    RUN clear-fields.

    /* apply this so we display the record selected in the browse
       using the fields in the 'event details' section
    */
    APPLY 'VALUE-CHANGED' TO hBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-Audit-Events C-Win 
PROCEDURE refresh-Audit-Events :
/*------------------------------------------------------------------------------
  Purpose:    This event gets published when we need to reopen
              the query. This happens when the user changes
              the working db in the main window of the APMT utility.
  Parameters:  pcInfo - info on the db, including dbname.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcInfo AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ret AS LOGICAL NO-UNDO.
  
  ASSIGN pcDbInfo = pcInfo.

  /* check if user is admin - info passed in pcDbInfo */
  IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&AUDIT-ADMIN})  THEN
     ASSIGN isAdmin = TRUE.
  ELSE
     ASSIGN isAdmin = FALSE.

  /* get the audit event records from the cache */
  RUN get-audit-events IN hAuditCacheMgr (INPUT pcDbInfo).
  
  /* trap errors */
  IF RETURN-VALUE <> "":U THEN
     MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR.

  /* reopen query so we show the corrct records */
  RUN open-query-event.
    
  /* apply this so we display the record selected in the browse
     using the fields in the 'event details' section
  */
  APPLY 'VALUE-CHANGED' TO hBrowse.

   /* check if there are any application level events defined in this database, in
      which case we want to enable the Export option/button
   */
   IF isAdmin THEN
      RUN sensitize-export(DYNAMIC-FUNCTION('hasApplEvents' IN hAuditCacheMgr)).
   ELSE
      RUN sensitize-export(INPUT NO).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitize-export C-Win 
PROCEDURE sensitize-export :
/*------------------------------------------------------------------------------
  Purpose:     Enable/disable export option
  Parameters:  isSensitive - yes or no
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER isSensitive AS LOGICAL NO-UNDO.

   ASSIGN btnExport:SENSITIVE IN FRAME {&FRAME-NAME} = isSensitive
          MENU-ITEM m_Export:SENSITIVE IN MENU m_File = isSensitive.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitize-import C-Win 
PROCEDURE sensitize-import :
/*------------------------------------------------------------------------------
  Purpose:     Enable/disable import option
  Parameters:  isSensitive - yes or no
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER isSensitive AS LOGICAL NO-UNDO.

  ASSIGN btnImport:SENSITIVE IN FRAME {&FRAME-NAME} = isSensitive
         MENU-ITEM m_Import:SENSITIVE IN MENU m_File = isSensitive.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

