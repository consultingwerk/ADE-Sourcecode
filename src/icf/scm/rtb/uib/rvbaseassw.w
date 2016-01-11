&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          icfdb             PROGRESS
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

/* Local Variable Definitions ---                                       */

DEFINE STREAM sMain.

DEFINE TEMP-TABLE ttSmartObjects
       FIELD tfSWorkspace       AS CHARACTER
       FIELD tfSProductModule   AS CHARACTER
       FIELD tfSObjectName      AS CHARACTER
       FIELD tfSBaseOverride    AS LOGICAL
       FIELD tfSDeleteHistory   AS LOGICAL
       INDEX tiSMain            IS PRIMARY UNIQUE
              tfSObjectName
       .
{rtb/inc/afrtbglobs.i}

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
&Scoped-define INTERNAL-TABLES gsc_product_module ryc_smartobject

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ~
gsc_product_module.product_module_code ryc_smartobject.object_filename 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH gsc_product_module ~
      WHERE gsc_product_module.product_module_code = (IF coProductModule = "<ALL>":U THEN gsc_product_module.product_module_code ELSE coProductModule) NO-LOCK, ~
      EACH ryc_smartobject WHERE ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse gsc_product_module ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse gsc_product_module
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse ryc_smartobject


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coWorkspace buCancel coProductModule ~
BrBrowse buAllSelect buAllDeselect toNewBaseline buBaseline buIntegrity ~
toDeleteHistory 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace coProductModule toNewBaseline ~
toDeleteHistory 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAllDeselect DEFAULT 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAllSelect DEFAULT 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buBaseline DEFAULT 
     LABEL "&Baseline" 
     SIZE 15 BY 1.14 TOOLTIP "Create baseline RV version data for current version of selected objects"
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buIntegrity DEFAULT 
     LABEL "&Integrity" 
     SIZE 15 BY 1.14 TOOLTIP "Synch selected objects RV version data with RTB Repository"
     BGCOLOR 8 .

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE toDeleteHistory AS LOGICAL INITIAL no 
     LABEL "Also Delete Version Data Prior to Baseline" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Recreate transaction and action records even if already a baseline version" NO-UNDO.

DEFINE VARIABLE toNewBaseline AS LOGICAL INITIAL no 
     LABEL "Also Re-Baseline Existing Baseline Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Recreate transaction and action records even if already a baseline version" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      gsc_product_module, 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      gsc_product_module.product_module_code FORMAT "X(10)":U
      ryc_smartobject.object_filename FORMAT "X(70)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 80 BY 14.38 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.48 COL 9.2
     buCancel AT ROW 1.48 COL 70
     coProductModule AT ROW 2.91 COL 5.2
     BrBrowse AT ROW 4.33 COL 5
     buAllSelect AT ROW 19.1 COL 5
     buAllDeselect AT ROW 19.1 COL 23
     toNewBaseline AT ROW 19.29 COL 41
     buBaseline AT ROW 20.52 COL 5
     buIntegrity AT ROW 20.52 COL 23
     toDeleteHistory AT ROW 20.62 COL 41
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.6 BY 21.43
         DEFAULT-BUTTON buBaseline CANCEL-BUTTON buCancel.


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
         WIDTH              = 87.6
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
/* BROWSE-TAB BrBrowse coProductModule DEFAULT-FRAME */
/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "icfdb.gsc_product_module,icfdb.ryc_smartobject WHERE icfdb.gsc_product_module ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "gsc_product_module.product_module_code = (IF coProductModule = ""<ALL>"":U THEN gsc_product_module.product_module_code ELSE coProductModule)"
     _JoinCode[2]      = "ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj"
     _FldNameList[1]   = icfdb.gsc_product_module.product_module_code
     _FldNameList[2]   = icfdb.ryc_smartobject.object_filename
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


&Scoped-define SELF-NAME buBaseline
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBaseline C-Win
ON CHOOSE OF buBaseline IN FRAME DEFAULT-FRAME /* Baseline */
DO:

    ASSIGN
        coWorkspace
        coProductModule
        toNewBaseline
        toDeleteHistory
        .

    MESSAGE  "Do you want to create new baseline version data for"
        SKIP "the selected objects."
        SKIP
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN
        RUN generateBaseline(INPUT "baseline":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Exit */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buIntegrity
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buIntegrity C-Win
ON CHOOSE OF buIntegrity IN FRAME DEFAULT-FRAME /* Integrity */
DO:
    ASSIGN
        coWorkspace
        coProductModule
        toNewBaseline
        toDeleteHistory
        .

    MESSAGE  "Do you want to synchronise the selected objects with the "
        SKIP "information held in Roundtable."
        SKIP
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN
        RUN generateBaseline(INPUT "integrity":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule C-Win
ON VALUE-CHANGED OF coProductModule IN FRAME DEFAULT-FRAME /* Product Module */
DO:

    ASSIGN
        coProductModule.

    RUN buildObjectBrw.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coWorkspace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coWorkspace C-Win
ON VALUE-CHANGED OF coWorkspace IN FRAME DEFAULT-FRAME /* Workspace */
DO:

    ASSIGN
        coWorkSpace.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDeleteHistory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDeleteHistory C-Win
ON VALUE-CHANGED OF toDeleteHistory IN FRAME DEFAULT-FRAME /* Also Delete Version Data Prior to Baseline */
DO:

    ASSIGN
        toNewBaseline.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toNewBaseline
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toNewBaseline C-Win
ON VALUE-CHANGED OF toNewBaseline IN FRAME DEFAULT-FRAME /* Also Re-Baseline Existing Baseline Data */
DO:

    ASSIGN
        toNewBaseline.

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

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoProductModule C-Win 
PROCEDURE buildCoProductModule :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coProductModule:LIST-ITEMS = "":U
            .

        FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code
            :
            coProductModule:ADD-LAST(LC(gsc_product_module.product_module_code)).
        END.

        coProductModule:ADD-FIRST(LC("<ALL>":U)).

        IF  coProductModule:LIST-ITEMS <> "":U
        AND coProductModule:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coProductModule:SCREEN-VALUE = ENTRY(1,coProductModule:LIST-ITEMS)
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoWorkspace C-Win 
PROCEDURE buildCoWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coWorkspace:LIST-ITEMS = "":U
            .

        FOR EACH rvm_workspace NO-LOCK BY rvm_workspace.workspace_code
            :
            coWorkspace:ADD-LAST(LC(rvm_workspace.workspace_code)).
        END.

        IF  coWorkspace:LIST-ITEMS <> "":U
        AND coWorkspace:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = ENTRY(1,coWorkspace:LIST-ITEMS)
                .

        IF  coWorkspace:LIST-ITEMS <> "":U
        AND coWorkspace:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = grtb-wspace-id NO-ERROR.
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectBrw C-Win 
PROCEDURE buildObjectBrw :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectTT C-Win 
PROCEDURE buildObjectTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSmartObjects.

    DEFINE VARIABLE iLoopRows   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iLoopCols   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        DO iLoopRows = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:

            lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoopRows).

            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            FIND FIRST ttSmartObjects EXCLUSIVE-LOCK
                WHERE ttSmartObjects.tfSWorkspace       = coWorkspace
                AND   ttSmartObjects.tfSProductModule   = gsc_product_module.product_module_code
                AND   ttSmartObjects.tfSObjectName      = ryc_smartobject.object_filename
                NO-ERROR.
            IF NOT AVAILABLE ttSmartObjects
            THEN
                CREATE ttSmartObjects.

            ASSIGN
                ttSmartObjects.tfSWorkspace     = coWorkspace
                ttSmartObjects.tfSProductModule = gsc_product_module.product_module_code
                ttSmartObjects.tfSObjectName    = ryc_smartobject.object_filename
                ttSmartObjects.tfSBaseOverride  = toNewBaseline
                ttSmartObjects.tfSDeleteHistory = toDeleteHistory
                .

        END.

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
  DISPLAY coWorkspace coProductModule toNewBaseline toDeleteHistory 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coWorkspace buCancel coProductModule BrBrowse buAllSelect 
         buAllDeselect toNewBaseline buBaseline buIntegrity toDeleteHistory 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateBaseline C-Win 
PROCEDURE generateBaseline :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE hRvBase     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cErrorValue AS CHARACTER    NO-UNDO.

    EMPTY TEMP-TABLE ttSmartObjects.
    RUN buildObjectTT (INPUT-OUTPUT TABLE ttSmartObjects).

    FIND FIRST ttSmartObjects NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttSmartObjects
    THEN DO:
        MESSAGE
            "*** No Records were found to process ":U
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    RUN rv/prc/rvbaseassp.p PERSISTENT SET hRvBase NO-ERROR.
    IF VALID-HANDLE(hRvBase)
    THEN DO:
        
        ASSIGN cErrorValue = "":U.
        
        IF pcType = "Baseline":U THEN
          RUN buildBaseLine IN hRvBase(INPUT TABLE ttSmartObjects
                                      ,OUTPUT cErrorValue).
        ELSE
          RUN fixIntegrity IN hRvBase(INPUT TABLE ttSmartObjects
                                      ,OUTPUT cErrorValue).
        ASSIGN
          cErrorValue = TRIM(REPLACE(TRIM(REPLACE(cErrorValue,"OK":U,"":U)),CHR(10),"":U)).
        IF cErrorValue <> "":U
        THEN
            MESSAGE
                "*** ERROR occured : ":U + CHR(10) + cErrorValue
                VIEW-AS ALERT-BOX INFORMATION.
        DELETE PROCEDURE hRvBase NO-ERROR.
        ASSIGN hRvBase = ?.
    END.

    IF cErrorValue <> "":U THEN
    DO:
      OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "baselineerrors.txt":U).
      PUT UNFORMATTED cErrorValue.
      OUTPUT CLOSE. 
      MESSAGE "Error can be viewed in file: " + SESSION:TEMP-DIRECTORY + "baselineerrors.txt":U
        VIEW-AS ALERT-BOX INFORMATION.
    END.

    IF  SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

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
            {&WINDOW-NAME}:TITLE = "Dynamics -  RV Baseline Objects":U
            .

        IF NOT CONNECTED("ICFDB")
        OR NOT CONNECTED("RVDB")
        THEN DO:

            IF NOT CONNECTED("ICFDB")
            THEN
                MESSAGE
                    "*** Failure : Repository Database (ICFDB) not connected ":U
                    VIEW-AS ALERT-BOX INFORMATION.
            IF NOT CONNECTED("RVDB")
            THEN
                MESSAGE
                    "*** Failure : Versioning Database (RVDB) not connected ":U
                    VIEW-AS ALERT-BOX INFORMATION.

            DISABLE
                buBaseline.

        END.
        ELSE DO:
            ENABLE
                buBaseline.
        END.

    END.

    RUN buildCoWorkspace.
    RUN buildCoProductModule.

    APPLY "VALUE-CHANGED" TO coProductModule.

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

