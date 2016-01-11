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

  File: ryrepdumpw.w

  Description: Repository Data Dump Window

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
DEFINE STREAM sOut1.
DEFINE STREAM sOut2.

DEFINE TEMP-TABLE ttSmartObjects
       FIELD tfSWorkspace       AS CHARACTER
       FIELD tfSProductModule   AS CHARACTER
       FIELD tfSObjectName      AS CHARACTER
       FIELD tfSBaseOverride    AS LOGICAL
       FIELD tfSDeleteHistory   AS LOGICAL
       INDEX tiSMain            IS PRIMARY UNIQUE
              tfSObjectName
       .
{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

DEFINE VARIABLE gcRepositoryDirectory AS CHARACTER NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS coProductModule BrBrowse buAllSelect ~
buAllDeselect fiDirectory buFindPath buDump buCancel 
&Scoped-Define DISPLAYED-OBJECTS coProductModule fiDirectory 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDumpName C-Win 
FUNCTION getDumpName RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDump DEFAULT 
     LABEL "&Dump Selected Objects Repository Data" 
     SIZE 64.4 BY 1.14 TOOLTIP "Create baseline RV version data for current version of selected objects"
     BGCOLOR 8 .

DEFINE BUTTON buFindPath 
     LABEL "Find Path..." 
     SIZE 14.4 BY 1.14 TOOLTIP "Find directory".

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dump Directory" 
     VIEW-AS FILL-IN 
     SIZE 48.8 BY 1 TOOLTIP "Specify full path of root directory to dump repository data into" NO-UNDO.

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
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 80 BY 14.86 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coProductModule AT ROW 1.48 COL 5.2
     BrBrowse AT ROW 3 COL 5
     buAllSelect AT ROW 18.1 COL 5
     buAllDeselect AT ROW 18.1 COL 23
     fiDirectory AT ROW 19.48 COL 4.8
     buFindPath AT ROW 19.48 COL 70.6
     buDump AT ROW 20.71 COL 5
     buCancel AT ROW 20.71 COL 70.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.8 BY 21.05
         DEFAULT-BUTTON buDump CANCEL-BUTTON buCancel.


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
         HEIGHT             = 21.05
         WIDTH              = 87.8
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
/* SETTINGS FOR FILL-IN fiDirectory IN FRAME DEFAULT-FRAME
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


&Scoped-define SELF-NAME buDump
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDump C-Win
ON CHOOSE OF buDump IN FRAME DEFAULT-FRAME /* Dump Selected Objects Repository Data */
DO:

    ASSIGN
        fiDirectory:SCREEN-VALUE = TRIM(REPLACE(fiDirectory:SCREEN-VALUE,"~\":U,"~/":U),"/":U)
        coProductModule
        fiDirectory
        gcRepositoryDirectory    = fiDirectory + "~/":U + "icf_dbdata":U
        .

    IF Grtb-wspace-id = "":U OR Grtb-wspace-id = ? THEN
    DO:
      MESSAGE "Cannot proceed - Roundtable workspace not available." SKIP
        VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
    END.

    MESSAGE  "Do you want to dump the repository data for the selected objects" SKIP
             "into the root directory : " + fiDirectory SKIP(1)
             "Note: Only repository data will be dumped. Version data will not" SKIP
             "be dumped, nor will any static data, so please ensure any static" SKIP
             "data such as object types or product modules is up to date wherever" SKIP
             "this data will be loaded." SKIP
             "You will also have to manually copy any physical files associated" SKIP
             "with the objects selected if you wish to deploy these also" SKIP(1)
             "Existing dumped data in the directory specified will first be deleted." SKIP(1)
             "Continue?" SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN
        RUN dumpData.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFindPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFindPath C-Win
ON CHOOSE OF buFindPath IN FRAME DEFAULT-FRAME /* Find Path... */
DO:

    RUN selectOutput.

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
            Grtb-wspace-id          = grtb-wspace-id
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
                WHERE ttSmartObjects.tfSWorkspace       = Grtb-wspace-id
                AND   ttSmartObjects.tfSProductModule   = gsc_product_module.product_module_code
                AND   ttSmartObjects.tfSObjectName      = ryc_smartobject.object_filename
                NO-ERROR.
            IF NOT AVAILABLE ttSmartObjects
            THEN
                CREATE ttSmartObjects.

            ASSIGN
                ttSmartObjects.tfSWorkspace     = Grtb-wspace-id
                ttSmartObjects.tfSProductModule = gsc_product_module.product_module_code
                ttSmartObjects.tfSObjectName    = ryc_smartobject.object_filename
                ttSmartObjects.tfSBaseOverride  = YES
                ttSmartObjects.tfSDeleteHistory = NO
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpData C-Win 
PROCEDURE dumpData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE VARIABLE cErrorValue AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cNumericDecimalPoint    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cNumericSeparator       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cNumericFormat          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDateFormat             AS CHARACTER    NO-UNDO.

    /* save session settings and reset to MIP dumped settings */
    ASSIGN
      cNumericDecimalPoint = SESSION:NUMERIC-DECIMAL-POINT
      cNumericSeparator = SESSION:NUMERIC-SEPARATOR
      cNumericFormat = SESSION:NUMERIC-FORMAT
      cDateFormat = SESSION:DATE-FORMAT
      .

    SESSION:NUMERIC-FORMAT = "AMERICAN".
    SESSION:SET-NUMERIC-FORMAT(",":U,".":U). /* seperator, decimal */ 
    SESSION:DATE-FORMAT = "dmy":U.

    OS-CREATE-DIR VALUE(gcRepositoryDirectory).

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

    /* now dump data for selected objects */
    RUN exportRYData.

    IF  SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

    SESSION:NUMERIC-FORMAT = cNumericFormat.
    SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
    SESSION:DATE-FORMAT = cDateFormat.

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
  DISPLAY coProductModule fiDirectory 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coProductModule BrBrowse buAllSelect buAllDeselect fiDirectory 
         buFindPath buDump buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportRYData C-Win 
PROCEDURE exportRYData :
/*------------------------------------------------------------------------------
  Purpose:     Export Repository Data
  Parameters:  <none>
  Notes:       Also deploy ICFDB data required by repository
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExportSmartObject      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportObjectInstance   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportPage             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportPageObject       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartLink        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartObjectField AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportCustomUiTrigger  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeValue   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportgscObject        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportDataVersion      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardMenc      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardObjc      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardFold      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardFoldPage  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardView      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardBrow      AS CHARACTER    NO-UNDO.

  cExportSmartObject        = getDumpName("ryc_smartobject":U).
  cExportObjectInstance     = getDumpName("ryc_object_instance":U).
  cExportPage               = getDumpName("ryc_page":U).
  cExportPageObject         = getDumpName("ryc_page_object":U).
  cExportSmartLink          = getDumpName("ryc_smartlink":U).
  cExportSmartObjectField   = getDumpName("ryc_smartobject_field":U).
  cExportCustomUiTrigger    = getDumpName("ryc_custom_ui_trigger":U).
  cExportAttributeValue     = getDumpName("ryc_attribute_value":U).
  cExportgscObject          = getDumpName("gsc_object":U).
  cExportDataVersion        = getDumpName("rym_data_version":U).
  cExportWizardMenc         = getDumpName("rym_wizard_menc":U).
  cExportWizardObjc         = getDumpName("rym_wizard_objc":U).
  cExportWizardFold         = getDumpName("rym_wizard_fold":U).
  cExportWizardFoldPage     = getDumpName("rym_wizard_fold_page":U).
  cExportWizardView         = getDumpName("rym_wizard_view":U).
  cExportWizardBrow         = getDumpName("rym_wizard_brow":U).

  /* Zap current dumps incase we re-run */
  OS-DELETE VALUE(cExportSmartObject) NO-ERROR.
  OS-DELETE VALUE(cExportObjectInstance) NO-ERROR.
  OS-DELETE VALUE(cExportPage) NO-ERROR.
  OS-DELETE VALUE(cExportPageObject) NO-ERROR.
  OS-DELETE VALUE(cExportSmartLink) NO-ERROR.
  OS-DELETE VALUE(cExportSmartObjectField) NO-ERROR.
  OS-DELETE VALUE(cExportCustomUiTrigger) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeValue) NO-ERROR.
  OS-DELETE VALUE(cExportgscObject) NO-ERROR.
  OS-DELETE VALUE(cExportDataVersion) NO-ERROR.
  OS-DELETE VALUE(cExportWizardMenc) NO-ERROR.
  OS-DELETE VALUE(cExportWizardObjc) NO-ERROR.
  OS-DELETE VALUE(cExportWizardFold) NO-ERROR.
  OS-DELETE VALUE(cExportWizardFoldPage) NO-ERROR.
  OS-DELETE VALUE(cExportWizardView) NO-ERROR.
  OS-DELETE VALUE(cExportWizardBrow) NO-ERROR.

  /* loop through objects to dump */  
  smartobject-loop:
  FOR EACH ryc_smartobject NO-LOCK:

    /* If not doing full repository dump - check if in list of objects required */
    IF NOT CAN-FIND(FIRST ttSmartObjects
                    WHERE ttSmartObjects.tfSObjectName = ryc_smartobject.OBJECT_filename) THEN NEXT smartobject-loop.


    /* dump smartobject table data */
    OUTPUT STREAM sOut1 TO VALUE(cExportSmartObject) APPEND.
    EXPORT STREAM sOut1 ryc_smartobject.
    OUTPUT STREAM sOut1 CLOSE.

    /* dump related tables info */
    OUTPUT STREAM sOut1 TO VALUE(cExportObjectInstance) APPEND.
    FOR EACH ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_object_instance.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportPage) APPEND.
    FOR EACH ryc_page NO-LOCK
        WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_page.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportPageObject) APPEND.
    FOR EACH ryc_page_object NO-LOCK
        WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_page_object.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportSmartLink) APPEND.
    FOR EACH ryc_smartlink NO-LOCK
        WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_smartlink.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportSmartObjectField) APPEND.
    FOR EACH ryc_smartobject_field NO-LOCK
        WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_smartobject_field.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportCustomUiTrigger) APPEND.
    FOR EACH ryc_custom_ui_trigger NO-LOCK
        WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_custom_ui_trigger.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportAttributeValue) APPEND.
    FOR EACH ryc_attribute_value NO-LOCK
        WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj:
        EXPORT STREAM sOut1 ryc_attribute_value.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportgscObject) APPEND.
    FOR EACH gsc_object NO-LOCK
        WHERE gsc_object.object_obj = ryc_smartobject.object_obj:
        EXPORT STREAM sOut1 gsc_object.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportDataVersion) APPEND.
    FOR EACH rym_data_version NO-LOCK
        WHERE rym_data_version.related_entity_mnemonic = "RYCSO":U
          AND rym_data_version.related_entity_key = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_data_version.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardMenc) APPEND.
    FOR EACH rym_wizard_menc NO-LOCK
        WHERE rym_wizard_menc.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_menc.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardObjc) APPEND.
    FOR EACH rym_wizard_objc NO-LOCK
        WHERE rym_wizard_objc.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_objc.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardFold) APPEND.
    OUTPUT STREAM sOut2 TO VALUE(cExportWizardFoldPage) APPEND.
    FOR EACH rym_wizard_fold NO-LOCK
        WHERE rym_wizard_fold.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_fold.

      FOR EACH rym_wizard_fold_page NO-LOCK
         WHERE rym_wizard_fold_page.wizard_fold_obj = rym_wizard_fold.wizard_fold_obj:
        EXPORT STREAM sOut2 rym_wizard_fold_page.
      END.
    END.
    OUTPUT STREAM sOut1 CLOSE.
    OUTPUT STREAM sOut2 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardView) APPEND.
    FOR EACH rym_wizard_view NO-LOCK
        WHERE rym_wizard_view.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_view.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardBrow) APPEND.
    FOR EACH rym_wizard_brow NO-LOCK
        WHERE rym_wizard_brow.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_brow.
    END.
    OUTPUT STREAM sOut1 CLOSE.

  END. /* smartobject loop */

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
            {&WINDOW-NAME}:TITLE = "Dynamics -  Deploy Repository Data":U
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
                buDump.

        END.
        ELSE DO:
            ENABLE
                buDump.
        END.

    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectOutput C-Win 
PROCEDURE selectOutput :
/*------------------------------------------------------------------------------
  Purpose:     Finds a Folder name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cOldValue       AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE lhServer        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lhFolder        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lhParent        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lvFolder        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lvCount         AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            cOldValue = fiDirectory.

        CREATE 'Shell.Application' lhServer.

        ASSIGN
            lhFolder = lhServer:BrowseForFolder(CURRENT-WINDOW:HWND,"Select Directory":U,0).

        IF VALID-HANDLE(lhFolder) = TRUE 
        THEN DO:
            ASSIGN 
                lvFolder = lhFolder:Title
                lhParent = lhFolder:ParentFolder
                lvCount  = 0
                .
            REPEAT:
                IF lvCount >= lhParent:Items:Count
                THEN DO:
                    ASSIGN
                        fiDirectory = "":U.
                END.
                ELSE
                IF lhParent:Items:Item(lvCount):Name = lvFolder
                THEN DO:
                    ASSIGN
                        fiDirectory = lhParent:Items:Item(lvCount):Path.
                    LEAVE.
                END.
                ASSIGN
                    lvCount = lvCount + 1.
            END.

        END.
        ELSE DO:
            ASSIGN
                fiDirectory = cOldValue.
        END.

        RELEASE OBJECT lhParent NO-ERROR.
        RELEASE OBJECT lhFolder NO-ERROR.
        RELEASE OBJECT lhServer NO-ERROR.

        ASSIGN
            fiDirectory:SCREEN-VALUE = fiDirectory
            lhParent = ?
            lhFolder = ?
            lhServer = ?
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDumpName C-Win 
FUNCTION getDumpName RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Return dump name for passed in table (plus .d extension and directory).
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer1                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDumpName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSchema                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk                     AS LOGICAL    NO-UNDO.

  /* Create buffer for passed in table */
  CREATE BUFFER hBuffer1 FOR TABLE pcTable NO-ERROR.

  /* get dump name for table from metaschema */
  ASSIGN cSchema = hBuffer1:DBNAME + "._file":U.

  CREATE BUFFER hBuffer FOR TABLE cSchema NO-ERROR.
  CREATE QUERY hQuery NO-ERROR.
  lOk = hQuery:SET-BUFFERS(hBuffer).
  lOk = hQuery:QUERY-PREPARE("FOR EACH ":U + cSchema + " NO-LOCK WHERE ":U + cSchema + "._file-name BEGINS '":U + pcTable + "'":U).
  hQuery:QUERY-OPEN() NO-ERROR.
  hQuery:GET-FIRST() NO-ERROR.

  IF VALID-HANDLE(hBuffer) AND hBuffer:AVAILABLE THEN
  ASSIGN
    hField  = hBuffer:BUFFER-FIELD("_dump-name":U)
    cDumpName = hField:BUFFER-VALUE
    .
  hQuery:QUERY-CLOSE() NO-ERROR.

  IF cDumpName = "":U THEN ASSIGN cDumpName = pcTable.

  DELETE OBJECT hBuffer1 NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
  DELETE OBJECT hBuffer NO-ERROR.
  ASSIGN
    hQuery = ?
    hBuffer = ?
    hBuffer1 = ?
    .

  RETURN gcRepositoryDirectory + "~/":U + cDumpName + ".d":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

