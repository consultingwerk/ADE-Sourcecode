&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
*/
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

  File: gsmsiassow.w

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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
DEFINE INPUT PARAMETER ipSite       AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ipDirectory  AS CHARACTER    NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED STREAM sMain.

DEFINE TEMP-TABLE ttAllDeltas
            FIELD tfAldbname    AS CHARACTER FORMAT "X(10)":U
            FIELD tfAdeltafile  AS CHARACTER FORMAT "X(50)":U
            FIELD tfAdeltatype  AS CHARACTER FORMAT "X(10)":U
            FIELD tfAselected   AS LOGICAL
            INDEX tiAMain       IS PRIMARY UNIQUE
                   tfAldbname
                   tfAdeltafile
            INDEX tiAprocess
                   tfAldbname
                   tfAselected
            .

DEFINE TEMP-TABLE ttLoadDeltas  NO-UNDO
            FIELD tfLldbname    AS CHARACTER
            FIELD tfLdeltaname  AS CHARACTER
            FIELD tfLdeltatype  AS CHARACTER
            FIELD tfLprocessed  AS LOGICAL
            INDEX tiLmain       IS PRIMARY UNIQUE
                    tfLldbname
                    tfLdeltaname
                    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAllDeltas

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttAllDeltas.tfAldbname ttAllDeltas.tfAdeltafile ttAllDeltas.tfAdeltatype   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse   
&Scoped-define SELF-NAME BrBrowse
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttAllDeltas                             WHERE ttAllDeltas.tfAldbname   = (IF coDatabase   = "<SELECTED>":U THEN ttAllDeltas.tfAldbname ELSE coDatabase)                             BY ttAllDeltas.tfAldbname                             BY ttAllDeltas.tfAdeltatype                             BY ttAllDeltas.tfAdeltafile                             .
&Scoped-define TABLES-IN-QUERY-BrBrowse ttAllDeltas
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttAllDeltas


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coDatabase BrBrowse buAllSelect buOneSelect ~
buDeselect buAllDeselect buCommit buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS coDatabase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAllDeselect DEFAULT 
     LABEL "Deselect All" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAllSelect DEFAULT 
     LABEL "Select All" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Cancel" 
     SIZE 18.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCommit DEFAULT 
     LABEL "Commit Selection" 
     SIZE 18.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeselect DEFAULT 
     LABEL "Deselect" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Deploy Data for Selected Tables" 
     SIZE 62 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOneSelect DEFAULT 
     LABEL "Select" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 64.4 BY 1
     BGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttAllDeltas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _FREEFORM
  QUERY BrBrowse NO-LOCK DISPLAY
      ttAllDeltas.tfAldbname   COLUMN-LABEL "Logical DB Name":U
      ttAllDeltas.tfAdeltafile COLUMN-LABEL "Data Definition Filename":U
      ttAllDeltas.tfAdeltatype COLUMN-LABEL "Data Definition Type":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82.4 BY 15.81 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coDatabase AT ROW 1.57 COL 6.6
     BrBrowse AT ROW 2.91 COL 5
     buAllSelect AT ROW 19.1 COL 5
     buOneSelect AT ROW 19.1 COL 21
     buDeselect AT ROW 19.1 COL 37
     buAllDeselect AT ROW 19.1 COL 53
     buCommit AT ROW 19.1 COL 69
     buOK AT ROW 20.52 COL 6.2
     buCancel AT ROW 20.52 COL 69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.43
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


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
         TITLE              = "<insert window title>"
         HEIGHT             = 21.43
         WIDTH              = 90
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 141.8
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 141.8
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
/* BROWSE-TAB BrBrowse coDatabase DEFAULT-FRAME */
ASSIGN 
       BrBrowse:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR COMBO-BOX coDatabase IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttAllDeltas
                            WHERE ttAllDeltas.tfAldbname   = (IF coDatabase   = "<SELECTED>":U THEN ttAllDeltas.tfAldbname ELSE coDatabase)
                            BY ttAllDeltas.tfAldbname
                            BY ttAllDeltas.tfAdeltatype
                            BY ttAllDeltas.tfAdeltafile
                            .
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllDeselect C-Win
ON CHOOSE OF buAllDeselect IN FRAME DEFAULT-FRAME /* Deselect All */
DO:

    RUN rowsAllDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllSelect C-Win
ON CHOOSE OF buAllSelect IN FRAME DEFAULT-FRAME /* Select All */
DO:

    RUN rowsAllSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCommit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCommit C-Win
ON CHOOSE OF buCommit IN FRAME DEFAULT-FRAME /* Commit Selection */
DO:

    RUN rowsCommit.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselect C-Win
ON CHOOSE OF buDeselect IN FRAME DEFAULT-FRAME /* Deselect */
DO:

    RUN rowsOneDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Deploy Data for Selected Tables */
DO:

    MESSAGE
        SKIP "Do you want to load the data definitions files selected "
        SKIP " into the relevant databases ?"
        SKIP
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN
        RUN loadDeltas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOneSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOneSelect C-Win
ON CHOOSE OF buOneSelect IN FRAME DEFAULT-FRAME /* Select */
DO:

    RUN rowsOneSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase C-Win
ON VALUE-CHANGED OF coDatabase IN FRAME DEFAULT-FRAME /* Database */
DO:

    ASSIGN
        coDatabase    = coDatabase:SCREEN-VALUE
        .

    RUN reopenSelected.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    APPLY "VALUE-CHANGED" TO coDatabase.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDumptables C-Win 
PROCEDURE assignDumptables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

    IF CONNECTED("ICFDB":U)
    THEN DO:
      RUN assignDumpASDB.
      RUN assignDumpASDB2.
      RUN assignDumpAFDB.
      RUN assignDumpAFDB2.
      RUN assignDumpRYDB.
      RUN assignDumpRYDB2.
    END.

    IF CONNECTED("RVDB":U)
    THEN DO:
      RUN assignDumpRVDB.
      RUN assignDumpRVDB2.
    END.

    IF NUM-DBS > 0
    THEN DO iLoop = 1 TO NUM-DBS:
        RUN assignDumpAll( LC(LDBNAME(iLoop)) ).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoDatabase C-Win 
PROCEDURE buildCoDatabase :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coDatabase:LIST-ITEMS = "":U
            .

        IF NUM-DBS > 0
        THEN DO iLoop = 1 TO NUM-DBS:
            coDatabase:ADD-LAST( TRIM(LC(LDBNAME(iLoop))) ).
        END.

        coDatabase:ADD-FIRST( "<SELECTED>":U).

        IF  coDatabase:LIST-ITEMS <> "":U
        AND coDatabase:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coDatabase:SCREEN-VALUE = ENTRY(1,coDatabase:LIST-ITEMS)
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDumptables C-Win 
PROCEDURE createDumptables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cDBName       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER cTableType    AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER cTableSelect  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER cTableName    AS CHARACTER    NO-UNDO.

    FIND FIRST ttAllDeltas EXCLUSIVE-LOCK
        WHERE ttAllDeltas.tfAldbname     = cDBName
        AND   ttAllDeltas.tfAdeltafile   = cTableName
        NO-ERROR.
    IF NOT AVAILABLE ttAllDeltas
    THEN DO:
        CREATE ttAllDeltas.
        ASSIGN
            ttAllDeltas.tfAldbname     = cDBName
            ttAllDeltas.tfAdeltafile   = cTableName
            ttAllDeltas.tfAdeltatype   = cTableType
            ttAllDeltas.tfAselected    = (IF cTableSelect = "INC":U THEN YES ELSE NO)
            .
    END.

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
  DISPLAY coDatabase 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coDatabase BrBrowse buAllSelect buOneSelect buDeselect buAllDeselect 
         buCommit buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadDeltas C-Win 
PROCEDURE loadDeltas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE VARIABLE cErrorValue AS CHARACTER    NO-UNDO.

    EMPTY TEMP-TABLE ttLoadDeltas.

    FOR EACH ttAllDeltas NO-LOCK
        WHERE ttAllDeltas.tfAselected = TRUE
        :

        FIND FIRST ttLoadDeltas EXCLUSIVE-LOCK
            WHERE ttLoadDeltas.tfLldbname   = ttAllDeltas.tfAldbname
            AND   ttLoadDeltas.tfLdeltaname = ttAllDeltas.tfAdeltafile
            NO-ERROR.
        IF NOT AVAILABLE ttLoadDeltas
        THEN
            CREATE ttLoadDeltas.
        ASSIGN
            ttLoadDeltas.tfLldbname   = ttAllDeltas.tfAldbname
            ttLoadDeltas.tfLdeltaname = ttAllDeltas.tfAdeltafile
            ttLoadDeltas.tfLdeltatype = ttAllDeltas.tfAdeltatype
            ttLoadDeltas.tfLprocessed = NO
            .

    END.

    FIND FIRST ttLoadDeltas NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttLoadDeltas
    THEN DO:
        MESSAGE
            "*** No Records were selected for loading ":U
            VIEW-AS ALERT-BOX INFORMATION.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    RUN loadProcess (INPUT TABLE ttLoadDeltas
                    ,OUTPUT cErrorValue).

    IF cErrorValue <> "":U
    THEN
        MESSAGE
            "*** ERROR occured while loading data definitions : ":U + cErrorValue
            VIEW-AS ALERT-BOX INFORMATION.
    ELSE
        MESSAGE
            " Completed Load of Data Definitions":U
            VIEW-AS ALERT-BOX INFORMATION.

    ASSIGN
        buCancel:LABEL IN FRAME {&FRAME-NAME} = "Close":U.

    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadProcess C-Win 
PROCEDURE loadProcess :
/*------------------------------------------------------------------------------
  Purpose:     TO dump any selected static and transaction data
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR ttLoadDeltas.
    DEFINE OUTPUT PARAMETER cErrorValue     AS CHARACTER    NO-UNDO.

    DEFINE BUFFER bttLoadDeltas FOR ttLoadDeltas.

    FOR EACH bttLoadDeltas NO-LOCK
        BREAK BY bttLoadDeltas.tfLldbname
        :
        IF FIRST-OF(bttLoadDeltas.tfLldbname)
        THEN
            RUN updateExport (INPUT bttLoadDeltas.tfLldbname
                             ,INPUT-OUTPUT TABLE ttLoadDeltas).
    END.

    DEFINE INPUT PARAMETER cDumpDirectory   AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttLoadDeltas.

    ASSIGN
        cDumpDirectory = LC( TRIM( REPLACE(cDumpDirectory,"~\":U,"~/":U) ,"~/":U ) ).

    FOR EACH ttLoadDeltas NO-LOCK
        :

        OUTPUT STREAM sMain TO VALUE( TRIM(cDumpDirectory,"~/":U) + "~/":U + ttLoadDeltas.tfLdeltatype + ".d":U ).
        CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(ttLoadDeltas.tfLldbname).
        RUN "rtb/inc/afdbdeplyw.i" ttLoadDeltas.tfLdeltaname .
        OUTPUT STREAM sMain CLOSE.

    END.

/*
    IF CONNECTED(ttLoadDeltas.tfLldbname)
    THEN DO:
        CREATE ALIAS DICTDB FOR DATABASE VALUE(ttLoadDeltas.tfLldbname).

        RUN prodict/dump_d.p (INPUT ttLoadDeltas.tfLdeltaname
                             ,INPUT cDumpDirectory
                             ,INPUT ?).
    END.
*/

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            {&WINDOW-NAME}:TITLE = "Load Database Definitions":U.
    END.

    RUN buildCoDatabase.

    EMPTY TEMP-TABLE ttAllDeltas.

    RUN assignAllDeltas.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openSelectedRows C-Win 
PROCEDURE openSelectedRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE rDumptable   AS ROWID       NO-UNDO.

    DEFINE BUFFER bttAllDeltas FOR ttAllDeltas.

    DO WITH FRAME {&FRAME-NAME}:

        FOR EACH bttAllDeltas NO-LOCK
            WHERE bttAllDeltas.tfAldbname   = (IF coDatabase   = "<SELECTED>":U THEN bttAllDeltas.tfAldbname ELSE coDatabase)
            AND   bttAllDeltas.tfAselected  = YES
            :

            /* Position query to this record and then select row in browse. */
            rDumptable = ROWID(bttAllDeltas).
            REPOSITION {&BROWSE-NAME} TO ROWID rDumptable.
            lBrwReturn = {&BROWSE-NAME}:SELECT-FOCUSED-ROW().

        END. 

        IF {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0
        THEN lBrwReturn = {&BROWSE-NAME}:SCROLL-TO-SELECTED-ROW(1).

    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputTrigger C-Win 
PROCEDURE outputTrigger :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cOutputFile      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttLoadDeltas.

    DEFINE VARIABLE iLoop                   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cTriggerList            AS CHARACTER    NO-UNDO.

    OUTPUT STREAM sMain TO VALUE(cOutputFile).

    FOR EACH ttLoadDeltas NO-LOCK
        BREAK BY ttLoadDeltas.tfLldbname
              BY ttLoadDeltas.tfLdeltaname
        :

        IF FIRST-OF(ttLoadDeltas.tfLldbname)
        THEN
            PUT STREAM sMain UNFORMATTED
                SKIP " "
                SKIP "~/* TRIGGERS FOR DB : ":U + ttLoadDeltas.tfLldbname + "*~/":U
                SKIP " "
                .

        PUT STREAM sMain UNFORMATTED SKIP 'DISABLE TRIGGERS FOR DUMP OF ' TRIM(ttLoadDeltas.tfLldbname) '.':U TRIM(ttLoadDeltas.tfLdeltaname) '.':U.
        PUT STREAM sMain UNFORMATTED SKIP 'DISABLE TRIGGERS FOR LOAD OF ' TRIM(ttLoadDeltas.tfLldbname) '.':U TRIM(ttLoadDeltas.tfLdeltaname) '.':U.

        PUT STREAM sMain UNFORMATTED SKIP ' '.

    END.

    OUTPUT STREAM sMain CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopenSelected C-Win 
PROCEDURE reopenSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-{&BROWSE-NAME}}

    RUN openSelectedRows.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllDeselect C-Win 
PROCEDURE rowsAllDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:DESELECT-ROWS().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllSelect C-Win 
PROCEDURE rowsAllSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.


    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:SELECT-ALL().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsCommit C-Win 
PROCEDURE rowsCommit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER  NO-UNDO.
    DEFINE BUFFER bttAllDeltas FOR ttAllDeltas.

    DO WITH FRAME {&FRAME-NAME}:

        FOR EACH bttAllDeltas EXCLUSIVE-LOCK
            WHERE bttAllDeltas.tfAldbname   = (IF coDatabase   = "<SELECTED>":U THEN bttAllDeltas.tfAldbname   ELSE coDatabase)
            /* AND   bttAllDeltas.tfAdeltatype = (IF cSelectedType = "<ALL>":U     THEN bttAllDeltas.tfAdeltatype ELSE cSelectedType) */
            :
            ASSIGN bttAllDeltas.tfAselected = NO.
        END. 

        DO iLoop = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:

            lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoop).

            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            FIND FIRST bttAllDeltas EXCLUSIVE-LOCK
                WHERE bttAllDeltas.tfAldbname     = ttAllDeltas.tfAldbname
                AND   bttAllDeltas.tfAdeltafile   = ttAllDeltas.tfAdeltafile
                NO-ERROR.
            IF AVAILABLE bttAllDeltas
            THEN ASSIGN bttAllDeltas.tfAselected = YES.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsOneDeselect C-Win 
PROCEDURE rowsOneDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:DESELECT-FOCUSED-ROW().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsOneSelect C-Win 
PROCEDURE rowsOneSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:SELECT-FOCUSED-ROW().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateExport C-Win 
PROCEDURE updateExport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER cDatabaseName AS CHARACTER    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLoadDeltas.

    DEFINE VARIABLE cQueryLine                  AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cWidgetPool                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTable                AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hFilename                   AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hDumpname                   AS HANDLE       NO-UNDO.

    ASSIGN
        cWidgetPool = "lWidgets"
        cQueryLine  = 'FOR EACH '   + TRIM(cDatabaseName) + '._file NO-LOCK '
                    + ' WHERE NOT ' + TRIM(cDatabaseName) + '._file._file-name BEGINS "_" '
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number > 0'
                    + ' AND '       + TRIM(cDatabaseName) + '._file._file-number < 32768 '
        .

    CREATE WIDGET-POOL cWidgetPool.
    CREATE QUERY hQuery IN WIDGET-POOL cWidgetPool.

    CREATE BUFFER hBufferTable
           FOR TABLE      TRIM(cDatabaseName) + "._file":U
           IN WIDGET-POOL cWidgetPool.
    IF NOT hQuery:ADD-BUFFER(hBufferTable)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error setting buffers for dynamic query".
    END.

    IF NOT hQuery:QUERY-PREPARE(cQueryLine)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error preparing dynamic query".
    END.
    IF NOT hQuery:QUERY-OPEN
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error opening dynamic query".
    END.

    IF NOT hQuery:REPOSITION-TO-ROW(1)
    THEN DO:
        DELETE WIDGET-POOL cWidgetPool.
        RETURN "Error re-positioning dynamic query".
    END.

    /* Retrieve the Field Values */
    REPEAT:

        IF NOT hQuery:GET-NEXT
        THEN LEAVE.

        ASSIGN
            hFilename  = hBufferTable:BUFFER-FIELD("_file-name")
            hDumpname  = hBufferTable:BUFFER-FIELD("_dump-name")
            .

        FIND FIRST ttLoadDeltas EXCLUSIVE-LOCK
            WHERE ttLoadDeltas.tfLldbname   = hBufferTable:DBNAME
            AND   ttLoadDeltas.tfLdeltaname = LC(TRIM(hFilename:STRING-VALUE))
            NO-ERROR.
        IF NOT AVAILABLE ttLoadDeltas
        THEN DO:
            CREATE ttLoadDeltas.
            ASSIGN
                ttLoadDeltas.tfLldbname   = hBufferTable:DBNAME
                ttLoadDeltas.tfLdeltaname = LC(TRIM(hFilename:STRING-VALUE))
                ttLoadDeltas.tfLdeltatype  = LC(TRIM(hDumpname:STRING-VALUE))
                .
        END.

    END.

    /* Release the Buffers for the tables */
    hBufferTable:BUFFER-RELEASE.
    DELETE OBJECT hBufferTable.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE WIDGET-POOL cWidgetPool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

