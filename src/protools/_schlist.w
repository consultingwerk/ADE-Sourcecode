&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: protools/_schlist.w

  Description: This is the Schema Detail window of the DB Connections PRO*Tool.
               It displays the tables, fields and indices of the selected database.
               
  Input Parameters:
      hParentProc - procedure handle for DB Connections procedure (_dblist)

  Output Parameters:
      <none>

  Author: Tammy Marshall

  Created: 04/09/99

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{protools/_schdef.i}  /* TableDetails, FieldDetails, IndexDetails temp table definition */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hParentProc AS HANDLE NO-UNDO.  /* handle of DB connection procedure */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hParentWin AS HANDLE NO-UNDO.  /* handle of DB connection window */
DEFINE VARIABLE rDB AS RECID NO-UNDO.  /* recid of selected _db */
DEFINE VARIABLE hTblDetail AS HANDLE NO-UNDO.  /* handle Table Detail procedure */
DEFINE VARIABLE hFldDetail AS HANDLE NO-UNDO.  /* handle Field Detail procedure */
DEFINE VARIABLE hIdxDetail AS HANDLE NO-UNDO.  /* handle Index Detail procedure */
DEFINE VARIABLE hTblWin AS HANDLE NO-UNDO.  /* handle Table Detail window */
DEFINE VARIABLE hFldWin AS HANDLE NO-UNDO.  /* handle Field Detail window */
DEFINE VARIABLE hIdxWin AS HANDLE NO-UNDO.  /* handle Index Detail window */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS selTables selFields selIndices bTables ~
bFields bIndex bClose bHelp RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS selTables selFields selIndices 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bClose 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bFields 
     LABEL "&Field Details" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bIndex 
     LABEL "&Index Details" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bTables 
     LABEL "&Table Details" 
     SIZE 15 BY 1.14.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.2 BY 10.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.2 BY 10.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.2 BY 10.

DEFINE VARIABLE selFields AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 25 BY 6.19 NO-UNDO.

DEFINE VARIABLE selIndices AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 25 BY 6.19 NO-UNDO.

DEFINE VARIABLE selTables AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 25 BY 6.19 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     selTables AT ROW 2.19 COL 4 NO-LABEL
     selFields AT ROW 2.19 COL 33.2 NO-LABEL
     selIndices AT ROW 2.19 COL 62.2 NO-LABEL
     bTables AT ROW 9.48 COL 9.2
     bFields AT ROW 9.48 COL 37.8
     bIndex AT ROW 9.48 COL 67.2
     bClose AT ROW 12.67 COL 20.4
     bHelp AT ROW 12.67 COL 55.6
     RECT-1 AT ROW 1.48 COL 2.6
     RECT-2 AT ROW 1.48 COL 31.6
     RECT-3 AT ROW 1.48 COL 60.6
     "Tables" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.14 COL 5.2
     "Fields" VIEW-AS TEXT
          SIZE 7.2 BY .62 AT ROW 1.14 COL 34.2
     "Indices" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.14 COL 63.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91 BY 15.05.


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
         TITLE              = "Schema"
         HEIGHT             = 13.86
         WIDTH              = 89.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 98.2
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 98.2
         MAX-BUTTON         = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Schema */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON PARENT-WINDOW-CLOSE OF C-Win /* Schema */
DO:
  /* When the db connections window is close, parent-window-close event fires for
     this window and we want to apply window-close here to close this window and
     any child windows */
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Schema */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "ENTRY":U TO hParentWin.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bClose C-Win
ON CHOOSE OF bClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  /* Applying window-close to this window will close this window and will cause
     a parent-window-close event to fire in any child windows */
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bFields C-Win
ON CHOOSE OF bFields IN FRAME DEFAULT-FRAME /* Field Details */
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */

  ELSE DO:  /* if selected db is still connected */
    /* If the Field detail window is running, don't run it again, bring it to the
       top of all other windows */
    IF VALID-HANDLE(hFldDetail) THEN DO:
      hFldWin = hFldDetail:CURRENT-WINDOW.
      hFldWin:MOVE-TO-TOP().
      APPLY "ENTRY":U TO hFldWin.
    END.  /* if Field detail window is already running */
  
    /* Field detail window is not already running, so run it */
    ELSE DO:
      RUN protools/_flddetl.w PERSISTENT SET hFldDetail (INPUT C-Win:HANDLE).
      /* We need to create a temp-table record for this field's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE FieldDetails.
      ASSIGN 
        FieldDetails.tblname = selTables:SCREEN-VALUE
        FieldDetails.fldname = selFields:SCREEN-VALUE.
      RUN getFieldDetails IN hParentProc (INPUT-OUTPUT TABLE FieldDetails). 
      RUN refreshField IN hFldDetail (INPUT TABLE FieldDetails).
      FIND FIRST FieldDetails.
      DELETE FieldDetails.
    END.  /* else do - field detail win not running */
  END.  /* else do - selected db still connected */
END.  /* choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bHelp C-Win
ON CHOOSE OF bHelp IN FRAME DEFAULT-FRAME /* Help */
DO:
  RUN adecomm/_adehelp.p
    (INPUT "ptls":U, 
     INPUT "CONTEXT":U, 
     INPUT 10, 
     INPUT  ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bIndex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bIndex C-Win
ON CHOOSE OF bIndex IN FRAME DEFAULT-FRAME /* Index Details */
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */

  ELSE DO:  /* if selected db is still connected */
    /* If the Index detail window is running, don't run it again, bring it to the
       top of all other windows */
    IF VALID-HANDLE(hIdxDetail) THEN DO:
      hIdxWin = hIdxDetail:CURRENT-WINDOW.
      hIdxWin:MOVE-TO-TOP().
      APPLY "ENTRY":U TO hIdxWin.
    END.  /* if Index detail window is already running */
  
    /* Index detail window is not already running, so run it */
    ELSE DO:  
      RUN protools/_idxdetl.w PERSISTENT SET hIdxDetail (INPUT C-Win:HANDLE).
         /* We need to create a temp-table record for this index's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE IndexDetails. 
      ASSIGN 
        IndexDetails.tblname = selTables:SCREEN-VALUE
        IndexDetails.idxname = selIndices:SCREEN-VALUE.
      RUN getIndexDetails IN hParentProc (INPUT-OUTPUT TABLE IndexDetails, OUTPUT TABLE IndxFldDetails).
      RUN refreshIndex IN hIdxDetail (INPUT TABLE IndexDetails, INPUT TABLE IndxFldDetails).
      FIND FIRST IndexDetails.
      DELETE IndexDetails.
    END.  /* else do - index detail win not running */
  END.  /* else do - selected db still connected */
END.  /* choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bTables C-Win
ON CHOOSE OF bTables IN FRAME DEFAULT-FRAME /* Table Details */
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */
  
  ELSE DO:  /* selected db still connected */
    /* If the Table detail window is running, don't run it again, bring it to the
       top of all other windows */
    IF VALID-HANDLE(hTblDetail) THEN DO:
      hTblWin = hTblDetail:CURRENT-WINDOW.
      hTblWin:MOVE-TO-TOP().
      APPLY "ENTRY":U TO hTblWin.
    END.  /* if Table detail window is already running */
  
    /* Table detail window is not running, so run it */ 
    ELSE DO:
      RUN protools/_tbldetl.w PERSISTENT SET hTblDetail (INPUT C-Win:HANDLE).
      /* We need to create a temp-table record for this table's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE TableDetails.
      ASSIGN TableDetails.name = selTables:SCREEN-VALUE.
      RUN getTableDetails IN hParentProc (INPUT-OUTPUT TABLE TableDetails).
      RUN refreshTable IN hTblDetail (INPUT TABLE TableDetails).
      FIND FIRST TableDetails.
      DELETE TableDetails.
    END.  /* else do - table detail not running */
  END.  /* else do - selected db still connected */
END.  /* choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME selFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL selFields C-Win
ON VALUE-CHANGED OF selFields IN FRAME DEFAULT-FRAME
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */
  
  ELSE DO:  /* selected db still connected */
    /* Need to see if the field still exists in the database - it may have
       been removed with the data dictionary */
    IF NOT DYNAMIC-FUNCTION("availFld" IN hParentProc, 
      INPUT selTables:SCREEN-VALUE, INPUT selFields:SCREEN-VALUE) THEN DO:
      MESSAGE selFields:SCREEN-VALUE "field no longer exists in the database"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN selFields:LIST-ITEMS = 
        DYNAMIC-FUNCTION("getFld" IN hParentProc, INPUT selTables:SCREEN-VALUE).
      selFields:SCREEN-VALUE = ENTRY(1, selFields:LIST-ITEMS).
    END.  /* if table no longer avail */

    /* If Field Detail window is running, get field details for the
       newly selected table and refresh those details in the detail window */
    IF VALID-HANDLE(hFldDetail) THEN DO:
         /* We need to create a temp-table record for this field's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE FieldDetails.
      ASSIGN 
        FieldDetails.tblname = selTables:SCREEN-VALUE
        FieldDetails.fldname = selFields:SCREEN-VALUE.
      RUN getFieldDetails IN hParentProc (INPUT-OUTPUT TABLE FieldDetails).
      RUN RefreshField IN hFldDetail (INPUT TABLE FieldDetails).
      FIND FIRST FieldDetails.
      DELETE FieldDetails.
    END.  /* if child window is running */
  END.  /* else do - selected db still connected */
END.  /* value-changed */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME selIndices
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL selIndices C-Win
ON VALUE-CHANGED OF selIndices IN FRAME DEFAULT-FRAME
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */

  ELSE DO:  /* selected db still connected */
    /* Need to see if the field still exists in the database - it may have
       been removed with the data dictionary */
    IF NOT DYNAMIC-FUNCTION("availIdx" IN hParentProc, 
      INPUT selTables:SCREEN-VALUE, INPUT selIndices:SCREEN-VALUE) THEN DO:
      MESSAGE selIndices:SCREEN-VALUE "index no longer exists in the database"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN selIndices:LIST-ITEMS = 
        DYNAMIC-FUNCTION("getIndx" IN hParentProc, INPUT selTables:SCREEN-VALUE).
      selIndices:SCREEN-VALUE = ENTRY(1, selIndices:LIST-ITEMS).
    END.  /* if table no longer avail */
 
    /* If Index Detail window is running, get index details for the
       newly selected table and refresh those details in the detail window */
    IF VALID-HANDLE(hIdxDetail) THEN DO:
         /* We need to create a temp-table record for this index's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE IndexDetails.
      ASSIGN 
        IndexDetails.tblname = selTables:SCREEN-VALUE
        IndexDetails.idxname = selIndices:SCREEN-VALUE.
      RUN getIndexDetails IN hParentProc (INPUT-OUTPUT TABLE IndexDetails, OUTPUT TABLE IndxFldDetails).
      RUN RefreshIndex IN hIdxDetail (INPUT TABLE IndexDetails, INPUT TABLE IndxFldDetails).
      FIND FIRST IndexDetails.
      DELETE IndexDetails.
    END.  /* if child window is running */
  END.  /* else do - selected db still connected */
END.  /* value-changed */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME selTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL selTables C-Win
ON VALUE-CHANGED OF selTables IN FRAME DEFAULT-FRAME
DO:
  /* Need to see if the database is still connected - it may have been
     disconnected through the data dictionary */
  IF NOT DYNAMIC-FUNCTION("dbconn" IN hParentProc) THEN DO:
    MESSAGE "You are no longer connected to" 
      CAPS(DYNAMIC-FUNCTION("getDbName" IN hParentProc)) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    RUN initialize-dblist IN hParentProc.  /* refresh list of connected dbs */
    APPLY "WINDOW-CLOSE":U TO C-Win.  /* close this window and any child windows */
  END.  /* if selected db no longer connected */
  
  ELSE DO:  /* selected db still connected */
    /* Need to see if the table still exists in the database - it may have
       been removed with the data dictionary */
    IF NOT DYNAMIC-FUNCTION("availTbl" IN hParentProc, INPUT selTables:SCREEN-VALUE) THEN DO:
      MESSAGE selTables:SCREEN-VALUE "table no longer exists in the database"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN selTables:LIST-ITEMS = 
        DYNAMIC-FUNCTION("getTbl" IN hParentProc).  /* refresh list of tables */
      selTables:SCREEN-VALUE = ENTRY(1, selTables:LIST-ITEMS).
    END.  /* if table no longer avail */
    
    /* Refresh Field and Index lists when Table is changed */
    ASSIGN 
      selFields:LIST-ITEMS = 
        DYNAMIC-FUNCTION("getFld" IN hParentProc, INPUT selTables:SCREEN-VALUE)
      selFields:SCREEN-VALUE = ENTRY(1, selFields:LIST-ITEMS)
      selIndices:LIST-ITEMS =
        DYNAMIC-FUNCTION("getIndx" IN hParentProc, INPUT selTables:SCREEN-VALUE)
      selIndices:SCREEN-VALUE = ENTRY(1, selIndices:LIST-ITEMS).
    APPLY "VALUE-CHANGED":U TO selFields.
    APPLY "VALUE-CHANGED":U TO selIndices.
  
    /* If Table Detail window is running, get table details for the
       newly selected table an refresh those details in the detail window */
    IF VALID-HANDLE(hTblDetail) THEN DO:
      /* We need to create a temp-table record for this table's details to be
         displayed in the detail window.  The temp-table record is populated 
         in a separate program that uses an alias to
         access the db metaschema */
      CREATE TableDetails.  
      ASSIGN TableDetails.name = selTables:SCREEN-VALUE.
      RUN getTableDetails IN hParentProc (INPUT-OUTPUT TABLE TableDetails).
      RUN RefreshTable IN hTblDetail (INPUT TABLE TableDetails).
      FIND FIRST TableDetails.
      DELETE TableDetails. 
    END.  /* if child window is running */
  END.  /* else do - selected db still connected */
END.  /* value changed */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
hParentWin = hParentProc:CURRENT-WINDOW.  /* get the handle of the previous window */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ASSIGN CURRENT-WINDOW:PARENT = hParentWin. /* parent the previous window to this window */

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY selTables selFields selIndices 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE selTables selFields selIndices bTables bFields bIndex bClose bHelp 
         RECT-1 RECT-2 RECT-3 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshSchema C-Win 
PROCEDURE RefreshSchema :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts the currently selected database name and type 
           and a comma separated list of tables for that database.  It changes
           the window title and the list of tables displayed.  
  Parameters: pcDBName - currently selected database
              pcDBType - database type for the currently selected database
              pcTableList - list of tables for the currently selected db
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcTableList AS CHARACTER NO-UNDO.

  ASSIGN 
    {&WINDOW-NAME}:TITLE = "Schema - " + pcDBName + " [" + pcDBType + "]"
    selTables:LIST-ITEMS IN FRAME {&FRAME-NAME} = pcTableList
    selTables:SCREEN-VALUE = ENTRY(1, pcTableList)
    selFields:LIST-ITEMS = 
      DYNAMIC-FUNCTION("getFld" IN hParentProc, INPUT selTables:SCREEN-VALUE)
    selFields:SCREEN-VALUE = ENTRY(1, selFields:LIST-ITEMS)
    selIndices:LIST-ITEMS =
      DYNAMIC-FUNCTION("getIndx" IN hParentProc, INPUT selTables:SCREEN-VALUE)
    selIndices:SCREEN-VALUE = ENTRY(1, selIndices:LIST-ITEMS).

  APPLY "ENTRY":U TO C-Win.
  APPLY "VALUE-CHANGED":U TO selTables.
  APPLY "VALUE-CHANGED":U TO selFields.
  APPLY "VALUE-CHANGED":U TO selIndices.
  APPLY "ENTRY":U TO bClose.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

