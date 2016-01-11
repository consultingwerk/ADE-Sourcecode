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

  File: _audmultfields.w

  Description: Enabled the user to pick one or more fields from a given table.
               The caller passes in a parameter that defines if the browse should
               be multi-select and if the table name. We will get the fields
               information from the cache manager.

  Input Parameters:
      pcTableInfo - table,owner information
      isMultiple  - YES if browse is to be multiple-selection

  Output Parameters:
      pcFieldList - comma separated list of field names.

  Author: Fernando de Souza

  Created: March 11,2005
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pcTableInfo    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pisMultiSelect AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldList    AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hBrowse         AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQuery          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE    NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 13.86 COL 23 WIDGET-ID 2
     Btn_Cancel AT ROW 13.86 COL 56 WIDGET-ID 4
     SPACE(20.99) SKIP(0.56)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select Database Field"
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
ON END-ERROR OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  RUN cleanup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
    /* get the list of selected fields and set the output parameter */
    RUN getSelectedFieldList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Moved from build-query() so that we don't call it inside the transaction
   scoped by the DO ON ERROR block below.
   We don't want mess up with transaction backout if the field information 
   is cached for the first time.
 
  get the fields from the given table into the cache
*/
RUN get-field-list-cache IN hAuditCacheMgr (INPUT pcTableInfo, OUTPUT hTable).


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN build-query.

  RUN build-browse.

  RUN enable_UI.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
RUN cleanup.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-browse Dialog-Frame 
PROCEDURE build-browse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the browse widget. Query should already be open by now.
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.

        /* create the dynamic browse */
    CREATE BROWSE hBrowse
        ASSIGN FRAME = FRAME {&FRAME-NAME}:HANDLE
               QUERY = hQuery
               X = 20
               Y = 10
               WIDTH = 85
               DOWN = 13
               READ-ONLY = YES
               SEPARATORS = YES
               ROW-MARKERS = NO
               COLUMN-RESIZABLE = YES
               WIDGET-ID = 6
        TRIGGERS:
        ON 'DEFAULT-ACTION':U PERSISTENT RUN defaultAction.
        END TRIGGERS.

    ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(1).

    /* add only 2 fields to the browse */
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Field-name')).
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Desc')).

    IF pisMultiSelect THEN
       ASSIGN hBrowse:MULTIPLE = YES.        

    /* let's view the object */
    ASSIGN hBrowse:EXPANDABLE = YES 
           hBrowse:VISIBLE = YES
           hBrowse:SENSITIVE = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-query Dialog-Frame 
PROCEDURE build-query :
/*------------------------------------------------------------------------------
  Purpose:     Rebuild the query after the user either switched databases or
               clicked on the toggle-box.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cWhere   AS CHARACTER NO-UNDO.

    /* hTable is set in the call to get-field-list-cache() in the main block */
    /* reopen the query to get the browse refreshed */

    IF NOT VALID-HANDLE (hQuery) THEN DO:
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(hTable:DEFAULT-BUFFER-HANDLE).
    END.
    ELSE IF hQuery:IS-OPEN THEN
            hQuery:QUERY-CLOSE.
    
    ASSIGN cWhere = " where _File-name = " + QUOTER(ENTRY(1,pcTableInfo))
                    + " AND _Owner = " + QUOTER (ENTRY(2,pcTableInfo)).

    hQuery:QUERY-PREPARE ("FOR EACH ":U + hQuery:GET-BUFFER-HANDLE(1):NAME + cWhere).
    
    hQuery:QUERY-OPEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup Dialog-Frame 
PROCEDURE cleanup :
/*------------------------------------------------------------------------------
  Purpose:     Delete objects created by this procedure.
  
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

PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:    Let the user double click on a row in the browse to make the
              selection. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT pisMultiSelect THEN
      APPLY "GO" TO FRAME {&FRAME-NAME}.
           
END PROCEDURE.

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
  ENABLE Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSelectedFieldList Dialog-Frame 
PROCEDURE getSelectedFieldList :
/*------------------------------------------------------------------------------
  Purpose:     This sets the list of fields selected in the browse.
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE vc      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE intSub  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.

    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    
    /* go through each entry and add it to the list */
    DO intSub = hBrowse:NUM-SELECTED-ROWS  TO 1 BY -1 : 
    
        hBrowse:FETCH-SELECTED-ROW(intSub).
        
        /* get the value of the field name and add it to the list */
        IF vc <> "" THEN
           ASSIGN vc = vc + "," + STRING( hBuffer::_Field-name ).
        ELSE
           ASSIGN vc = STRING( hBuffer::_Field-name ).
        
    END.

    /* set the output parameter */
    ASSIGN pcfieldList = vc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

