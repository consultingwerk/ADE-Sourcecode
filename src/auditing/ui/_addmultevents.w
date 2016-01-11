&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: _addmultevents.w

  Description: brings up a window where the user can see all the audit events
               and pock either one or multiple events. The caller defines
               if the browse is multi-select or not.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Fernando de Souza

  Created:  March 04,2005
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER isMultiSelect AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcEventList   AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.

{auditing/include/_aud-cache.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel disp-sys-events 
&Scoped-Define DISPLAYED-OBJECTS disp-sys-events 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE disp-sys-events AS LOGICAL INITIAL yes 
     LABEL "Display System Events" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.48 COL 99 WIDGET-ID 2
     Btn_Cancel AT ROW 2.71 COL 99 WIDGET-ID 4
     disp-sys-events AT ROW 15.52 COL 1 WIDGET-ID 6
     SPACE(91.19) SKIP(0.52)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select Event"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON END-ERROR OF FRAME Dialog-Frame /* Select Event */
DO:
  RUN cleanup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Select Event */
DO:
   RUN get-selected-events.
   RUN cleanup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select Event */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME disp-sys-events
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL disp-sys-events Dialog-Frame
ON VALUE-CHANGED OF disp-sys-events IN FRAME Dialog-Frame /* Display System Events */
DO:
  RUN open-query-event.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* get the audit event records from the cache */
/* Moved this call from buildBrowse().
   the code in get-audit-events will do a fill on a dataset if this the events
   haven't been cache yet. Since it uses a NO-UNDO temp-table, we should not
   call it inside the DO ON ERROR UNDO block below  ( the client can't undo
   it and we actually don't want to undo it anyway - once it's cached, it's
   cached.
*/
RUN get-audit-events IN hAuditCacheMgr (INPUT ? /* using the APMT's working db */).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN buildBrowse.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
RUN cleanup.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowse Dialog-Frame 
PROCEDURE buildBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Build a dynamic browse that we use to display the events
               available. We get the handle of the temp-table available
               in the audit cache manager and build a query and a browse
               against the table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hEventTT  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE    NO-UNDO.


    /* get the handle of the temp-table */
    RUN get-audit-event-tbl-handle IN hAuditCacheMgr (OUTPUT hEventTT).
    
    /* get the temp-table's buffer */
    ASSIGN hBuffer = hEventTT:DEFAULT-BUFFER-HANDLE.
    
    /* create a query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hBuffer).
    
    /* create the dynamic browse */
    CREATE BROWSE hBrowse
        ASSIGN FRAME = FRAME {&FRAME-NAME}:HANDLE
               QUERY = hQuery
               X = 3.95
               Y = 10
               WIDTH = 94
               DOWN = 16
               READ-ONLY = YES
               SEPARATORS = YES
               ROW-MARKERS = NO
               MULTIPLE = isMultiSelect
               WIDGET-ID = 8
        TRIGGERS:
        ON 'DEFAULT-ACTION':U PERSISTENT RUN defaultAction.
        END TRIGGERS.


    /* add the fields to the browse */
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Event-id')).
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Event-Name')).
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Event-Type')).
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Event-Description')).

    /* let's view the object */
    ASSIGN hBrowse:EXPANDABLE = YES 
           hBrowse:VISIBLE = YES
           hBrowse:SENSITIVE = TRUE.

    /* opens the query */
    RUN open-query-event.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup Dialog-Frame 
PROCEDURE cleanup :
/*------------------------------------------------------------------------------
  Purpose:     Delete the dynamic objects we created
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hBrowse) THEN
        DELETE OBJECT hBrowse.
    
    IF VALID-HANDLE(hQuery) THEN DO:
        IF hQuery:IS-OPEN THEN
           hQuery:QUERY-CLOSE.
    
        DELETE OBJECT hQuery.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultAction Dialog-Frame 
PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:    Let the user double click on a row in the browse to make the
              selection. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT isMultiSelect THEN
      APPLY "GO" TO FRAME {&FRAME-NAME}.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY disp-sys-events 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK Btn_Cancel disp-sys-events 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-selected-events Dialog-Frame 
PROCEDURE get-selected-events :
/*------------------------------------------------------------------------------
  Purpose:     Set the output parameter to the list of ids selected in the browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE vc      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE intSub  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hField  AS HANDLE    NO-UNDO.

    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    
    /* go through each entry and add it to the list */
    DO intSub = hBrowse:NUM-SELECTED-ROWS  TO 1 BY -1 : 
    
        HBrowse:FETCH-SELECTED-ROW(intSub).
        
        /* get the value of the table name */
        hField = hBuffer:BUFFER-FIELD( "_Event-id").
        
        /* add it to the list */
        IF vc <> "" THEN
           ASSIGN vc = vc + "," + STRING( hField:BUFFER-VALUE ).
        ELSE
           ASSIGN vc = STRING( hField:BUFFER-VALUE ).
        
    END.

    /* set the output parameter */
    ASSIGN pcEventList = vc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-event Dialog-Frame 
PROCEDURE open-query-event :
/*------------------------------------------------------------------------------
  Purpose:     Open the query used by the browse. It checks if the
               user wants to see system events.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere  AS CHARACTER NO-UNDO INIT "".
DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
                           
    /* close query first */
    IF hQuery:IS-OPEN THEN
       hQuery:QUERY-CLOSE.

    /* build a where clause if user doesn't want to see system events */
    IF disp-sys-events:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO":U  THEN
       ASSIGN cWhere = " where _Event-id >= 32000":U. 

    hBuffer = hQuery:GET-BUFFER-HANDLE(1).

    /* prepare query */
    hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + cWhere).

    /* open query */
    hQuery:QUERY-OPEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

