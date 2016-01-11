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

  File:  _audfileselectw.w

  Description: Enables the user to select one or more table names from a given db. The window contains
                    a combo-box with all connected db's (including db's from an AppServer, if the tool is connected
                    to an AppServer). The caller defines if the user can select one or multiple table names, and this
                    procedure returns a comma-separated list with the tables the user selected.

  Input Parameters:
      pisMultiSelect - YES if user can select multiple tables

  Output Parameters:
      pctableList - comma-separated list of tables selected

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE APPSRV-TAG   'AppSrv':U
&SCOPED-DEFINE READONLY-TAG 'Read-Only':U

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pisMultiSelect AS LOGICAL.
DEFINE OUTPUT PARAMETER pctableList    AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iCurrentdatabase AS INTEGER   NO-UNDO.
DEFINE VARIABLE hBrowse          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQuery           AS HANDLE    NO-UNDO.

/* temp-table used to hold the db information */
DEFINE TEMP-TABLE workDb
    FIELD id            AS INTEGER
    FIELD dbInfo        AS CHARACTER
    FIELD display-value AS CHARACTER
    INDEX id id.

{auditing/include/_aud-cache.i}

{auditing/include/_aud-std.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coDatabase toggleHidden Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS coDatabase toggleHidden 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coDatabase AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Database Name" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<None>",0
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE toggleHidden AS LOGICAL INITIAL no 
     LABEL "Display Hidden Tables" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     coDatabase AT ROW 1.24 COL 20 COLON-ALIGNED WIDGET-ID 2
     toggleHidden AT ROW 14.1 COL 5 WIDGET-ID 4
     Btn_OK AT ROW 15.76 COL 18 WIDGET-ID 6
     Btn_Cancel AT ROW 15.76 COL 40 WIDGET-ID 8
     SPACE(19.39) SKIP(0.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Select Database Table"
         DEFAULT-BUTTON Btn_OK.


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
ON END-ERROR OF FRAME Dialog-Frame /* Select Database Table */
DO:
  RUN cleanup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Select Database Table */
DO:
    /* get the list of selected tables and set the output parameter */
    RUN getSelectedTableList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Select Database Table */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase Dialog-Frame
ON VALUE-CHANGED OF coDatabase IN FRAME Dialog-Frame /* Database Name */
DO:
DEFINE VARIABLE cDbInfo AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTable  AS HANDLE    NO-UNDO.


    /* they changed the current database to work with for configuring the audit policy,
       so we need to refresh all the data for the newly selected database.
    */
    IF SELF:INPUT-VALUE <> 0 THEN
    DO:
      /* check if user really changed the database name selected */
      IF SELF:INPUT-VALUE <> iCurrentdatabase THEN DO:

          RUN build-query.

          IF NOT VALID-HANDLE (hBrowse) THEN
             RUN buildBrowse.

          /* remember which one is selected now */
          icurrentdatabase = SELF:INPUT-VALUE.
      END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toggleHidden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toggleHidden Dialog-Frame
ON VALUE-CHANGED OF toggleHidden IN FRAME Dialog-Frame /* Display Hidden Tables */
DO:
    RUN refresh-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  /* Let's populate the combo-box with all the databases avaiable */
  RUN buildDatabaseCombo.

  APPLY "entry":U TO coDatabase.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
RUN cleanup.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-query Dialog-Frame 
PROCEDURE build-query :
/*------------------------------------------------------------------------------
  Purpose:     Rebuild the query after the user either switched databases or
               clicked on the toggle-box.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDbInfo  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTable   AS HANDLE    NO-UNDO.

DEFINE VARIABLE cWhere   AS CHARACTER NO-UNDO.

    RUN getDbInfo (OUTPUT cDbInfo).
    
    /* get the name of the tables from the selected db into the cache
       and then refresh the browse to show the correct tables
    */
    RUN get-table-list-cache IN hAuditCacheMgr (INPUT cDbInfo, OUTPUT hTable).

    IF NOT VALID-HANDLE (hQuery) THEN DO:
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(hTable:DEFAULT-BUFFER-HANDLE).
    END.
    ELSE IF hQuery:IS-OPEN THEN
            hQuery:QUERY-CLOSE.
    
    ASSIGN cWhere = " where _db-name = " + QUOTER(cDbInfo).

    IF toggleHidden:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO" THEN 
        ASSIGN cWhere = cWhere + " AND _Hidden = NO ":U.
    
    hQuery:QUERY-PREPARE ("FOR EACH ":U + hQuery:GET-BUFFER-HANDLE(1):NAME + cWhere).
    
    hQuery:QUERY-OPEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowse Dialog-Frame 
PROCEDURE buildBrowse :
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
               X = toggleHidden:X
               Y = coDatabase:Y + coDatabase:HEIGHT-PIXELS + (coDataBase:HEIGHT-PIXELS / 3)
               WIDTH = 66
               DOWN = 13
               READ-ONLY = YES
               SEPARATORS = YES
               ROW-MARKERS = NO
               COLUMN-RESIZABLE = YES
               WIDGET-ID = 10
        TRIGGERS:
        ON 'DEFAULT-ACTION':U PERSISTENT RUN defaultAction.
        END TRIGGERS.

    ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(1).

    /* add only 2 fields to the browse */
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_File-name')).
    hBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD('_Owner')).

    IF pisMultiSelect THEN
       ASSIGN hBrowse:MULTIPLE = YES.        

    /* let's view the object */
    ASSIGN hBrowse:EXPANDABLE = YES 
           hBrowse:VISIBLE = YES
           hBrowse:SENSITIVE = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDatabaseCombo Dialog-Frame 
PROCEDURE buildDatabaseCombo :
/*------------------------------------------------------------------------------
  Purpose:     Builds the combo-box adding all connected db's to its list. This
               also handles db connected through the AppServer.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop     AS INTEGER   NO-UNDO INITIAL 1.
DEFINE VARIABLE cList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cdbInfo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWorkDB   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cdbName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbStr    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp     AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN coDatabase:LIST-ITEM-PAIRS = ?.

    /* get list of database connected - includes db's connected in the AppServer */
    RUN get-complete-dbname-list IN hAuditCacheMgr (OUTPUT cList).

    
    /* each entry is separated by chr(1) */
    DO iLoop = 1 TO NUM-ENTRIES(cList, CHR(1)):
        ASSIGN cdbInfo = ENTRY(iLoop, cList, CHR(1))
            /* db name is the first entry */
               cDbStr = "".

        ASSIGN cDbName = DYNAMIC-FUNCTION('get-DB-Name' IN  hAuditCacheMgr, cDbInfo).

        /* now check if there is any additional information about this db */

        IF {&NOT-WEBCLIENT} THEN DO:
          IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, cDbInfo, {&DB-APPSERVER})  THEN
                 cDbStr = {&APPSRV-TAG}.
        END.

        /* don't care about read-only tag for now*/
        /*
        IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&DB-READ-ONLY}) THEN
           IF cDbStr = "" THEN
              cDbStr = {&READONLY-TAG}.
           ELSE
              cDbStr = cDbStr + " ":U + {&READONLY-TAG}.
        */

        IF cDbStr = "" THEN
           /* the only thing we have is the db name */
           cDbStr = cDbName.
        ELSE
            cDbStr = "(" + cDbStr + ") " + cDbName.

        CREATE workDb.
        ASSIGN workDb.id = iLoop
               workDb.dbInfo = cDbInfo
               workDb.display-value = cDbStr.

        coDatabase:ADD-LAST(cDbStr, iLoop).
    END.

    /* should not happen, but anyway ...*/
   IF coDatabase:LIST-ITEM-PAIRS = "":U OR coDatabase:LIST-ITEM-PAIRS = ? THEN
      coDatabase:ADD-LAST("<None>",0).
    
    /* try to default to the current working database in the main window */
    RUN getWorkingDbInfo IN hAuditCacheMgr (OUTPUT cTemp).

    FIND FIRST workDb WHERE workDb.dbInfo = cTemp NO-ERROR.
    IF AVAILABLE workDb THEN
        cWorkDB = STRING(workDb.Id).
    ELSE
        cWorkDb = "".

    IF cWorkDB <> "" THEN                                            
        ASSIGN coDatabase:SCREEN-VALUE = cWorkDB NO-ERROR.
    ELSE
        ASSIGN coDatabase:SCREEN-VALUE = ENTRY(2,coDatabase:LIST-ITEM-PAIRS).
    
    APPLY "VALUE-CHANGED":U TO coDatabase. /* force refresh of database list */

END.

RETURN.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultAction Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:     The user picked a table by double-clicking.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    APPLY "GO" TO FRAME Dialog-Frame.

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
  DISPLAY coDatabase toggleHidden 
      WITH FRAME Dialog-Frame.
  ENABLE coDatabase toggleHidden Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDbInfo Dialog-Frame 
PROCEDURE getDbInfo :
/*------------------------------------------------------------------------------
  Purpose:     Get the dbinfo string with the info from the database selected
               in the combo-box
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDetails AS CHARACTER NO-UNDO.
DEFINE VARIABLE i        AS INTEGER   NO-UNDO.

    FIND FIRST workDb WHERE workDb.id = coDatabase:INPUT-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
    IF AVAILABLE workDb THEN DO:

      pcDbInfo = DYNAMIC-FUNCTION('get-DB-Name' IN  hAuditCacheMgr,workDb.dbInfo).

      IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, workDb.dbInfo, {&DB-APPSERVER})  THEN
           pcDbInfo = pcDbInfo + "," + {&DB-APPSERVER}.
    END.
    ELSE
       pcDbInfo = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSelectedTableList Dialog-Frame 
PROCEDURE getSelectedTableList :
/*------------------------------------------------------------------------------
  Purpose:     This sets the list of tables selected in the browse.
  
  Parameters:  <none>
  
  Notes:       The syntax of the entries on the list is db-name,owner
------------------------------------------------------------------------------*/
    DEFINE VARIABLE vc      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE intSub  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hField  AS HANDLE    NO-UNDO.

    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    
    /* go through each entry and add it to the list */
    DO intSub = hBrowse:NUM-SELECTED-ROWS  TO 1 BY -1 : 
    
        Hbrowse:FETCH-SELECTED-ROW(intSub).
        
        /* get the value of the table name */
        hField = hBuffer:BUFFER-FIELD( "_File-name" ).
        
        /* add it to the list */
        IF vc <> "" THEN
           ASSIGN vc = vc + "," + STRING( hField:BUFFER-VALUE ).
        ELSE
           ASSIGN vc = STRING( hField:BUFFER-VALUE ).
        
        /* get the owner and append to the table name */
        hField = hBuffer:BUFFER-FIELD( "_Owner" ).

        /* to save some space, omit the owner if it's PUB */
        IF hField:BUFFER-VALUE = "PUB":U THEN 
           ASSIGN vc = vc + ",":U.
        ELSE
           ASSIGN vc = vc + "," + STRING( hField:BUFFER-VALUE ).
      
    END.

    /* set the output parameter */
    ASSIGN pctableList = vc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-browse Dialog-Frame 
PROCEDURE refresh-browse :
/*------------------------------------------------------------------------------
  Purpose:     Refreshes the browse. Runs when the user selects the toggle-box
               so we display the correct tables
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbInfo  AS CHARACTER NO-UNDO.

    IF hQuery:IS-OPEN THEN
        hQuery:QUERY-CLOSE.
    
    RUN getDbInfo (OUTPUT cDbInfo).

    ASSIGN cWhere = " where _db-name = " + QUOTER(cDbInfo).

    IF toggleHidden:SCREEN-VALUE IN FRAME {&FRAME-NAME}= "NO":U THEN 
        ASSIGN cWhere = cwhere + " and _Hidden = NO":U.
    
    hQuery:QUERY-PREPARE ("FOR EACH ":U + hQuery:GET-BUFFER-HANDLE(1):NAME + cWhere).
    
    hQuery:QUERY-OPEN.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

