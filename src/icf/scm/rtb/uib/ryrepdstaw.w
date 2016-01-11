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

  File: ryrepdstaw.w

  Description: Repository Static Data Dump Window

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDirectory buFindPath buDump buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiDirectory 

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
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDump DEFAULT 
     LABEL "&Dump Static Repository Data" 
     SIZE 64.4 BY 1.14 TOOLTIP "Dump repository static data into directory specified"
     BGCOLOR 8 .

DEFINE BUTTON buFindPath 
     LABEL "Find Path..." 
     SIZE 14.4 BY 1.14 TOOLTIP "Find directory".

DEFINE VARIABLE fiDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dump Directory" 
     VIEW-AS FILL-IN 
     SIZE 48.8 BY 1 TOOLTIP "Specify full path of root directory to dump repository data into" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiDirectory AT ROW 1.1 COL 3.2
     buFindPath AT ROW 1.1 COL 69
     buDump AT ROW 2.33 COL 3.4
     buCancel AT ROW 2.33 COL 69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.2 BY 2.91
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
         HEIGHT             = 2.91
         WIDTH              = 87.2
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
/* SETTINGS FOR FILL-IN fiDirectory IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
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
ON CHOOSE OF buDump IN FRAME DEFAULT-FRAME /* Dump Static Repository Data */
DO:

    ASSIGN
        fiDirectory:SCREEN-VALUE = TRIM(REPLACE(fiDirectory:SCREEN-VALUE,"~\":U,"~/":U),"/":U)
        fiDirectory
        gcRepositoryDirectory    = fiDirectory + "~/":U + "icf_dbdata":U
        .

    MESSAGE  "Do you want to dump the repository static data into the root directory:" SKIP
             fiDirectory SKIP(1)
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
  DISPLAY fiDirectory 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE fiDirectory buFindPath buDump buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportRYData C-Win 
PROCEDURE exportRYData :
/*------------------------------------------------------------------------------
  Purpose:     Export Repository Static Data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExportAction           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttribute        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeGroup   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeType    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportBand             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportBandAction       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportLayout           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartLinkType    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSubscribe        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSupportedLink    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportUITrigger        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportValidUITrigger   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWidgetType       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportLookupField      AS CHARACTER    NO-UNDO.

  cExportAction             = getDumpName("ryc_action":U).
  cExportAttribute          = getDumpName("ryc_attribute":U).
  cExportAttributeGroup     = getDumpName("ryc_attribute_group":U).
  cExportAttributeType      = getDumpName("ryc_attribute_type":U).
  cExportBand               = getDumpName("ryc_band":U).
  cExportBandAction         = getDumpName("ryc_band_action":U).
  cExportLayout             = getDumpName("ryc_layout":U).
  cExportSmartLinkType      = getDumpName("ryc_smartlink_type":U).
  cExportSubscribe          = getDumpName("ryc_subscribe":U).
  cExportSupportedLink      = getDumpName("ryc_supported_link":U).
  cExportUITrigger          = getDumpName("ryc_ui_trigger":U).
  cExportValidUITrigger     = getDumpName("ryc_valid_ui_trigger":U).
  cExportWidgetType         = getDumpName("ryc_widget_type":U).
  cExportLookupField        = getDumpName("rym_lookup_field":U).

  /* Zap current dumps incase we re-run */
  OS-DELETE VALUE(cExportAction) NO-ERROR.
  OS-DELETE VALUE(cExportAttribute) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeGroup) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeType) NO-ERROR.
  OS-DELETE VALUE(cExportBand) NO-ERROR.
  OS-DELETE VALUE(cExportBandAction) NO-ERROR.
  OS-DELETE VALUE(cExportLayout) NO-ERROR.
  OS-DELETE VALUE(cExportSmartLinkType) NO-ERROR.
  OS-DELETE VALUE(cExportSubscribe) NO-ERROR.
  OS-DELETE VALUE(cExportSupportedLink) NO-ERROR.
  OS-DELETE VALUE(cExportUITrigger) NO-ERROR.
  OS-DELETE VALUE(cExportValidUITrigger) NO-ERROR.
  OS-DELETE VALUE(cExportWidgetType) NO-ERROR.
  OS-DELETE VALUE(cExportLookupField) NO-ERROR.

  OUTPUT STREAM sOut1 TO VALUE(cExportAction).
  FOR EACH ryc_action NO-LOCK:
    EXPORT STREAM sOut1 ryc_action.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttribute).
  FOR EACH ryc_attribute NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttributeGroup).
  FOR EACH ryc_attribute_group NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute_group.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttributeType).
  FOR EACH ryc_attribute_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportBand).
  FOR EACH ryc_band NO-LOCK:
    EXPORT STREAM sOut1 ryc_band.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportBandAction).
  FOR EACH ryc_band_action NO-LOCK:
    EXPORT STREAM sOut1 ryc_band_action.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportLayout).
  FOR EACH ryc_layout NO-LOCK:
    EXPORT STREAM sOut1 ryc_layout.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSmartLinkType).
  FOR EACH ryc_smartlink_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_smartlink_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSubscribe).
  FOR EACH ryc_subscribe NO-LOCK:
    EXPORT STREAM sOut1 ryc_subscribe.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSupportedLink).
  FOR EACH ryc_supported_link NO-LOCK:
    EXPORT STREAM sOut1 ryc_supported_link.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportUITrigger).
  FOR EACH ryc_ui_trigger NO-LOCK:
    EXPORT STREAM sOut1 ryc_ui_trigger.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportValidUITrigger).
  FOR EACH ryc_valid_ui_trigger NO-LOCK:
    EXPORT STREAM sOut1 ryc_valid_ui_trigger.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportWidgetType).
  FOR EACH ryc_widget_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_widget_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportLookupField).
  FOR EACH rym_lookup_field NO-LOCK:
    EXPORT STREAM sOut1 rym_lookup_field.
  END.
  OUTPUT STREAM sOut1 CLOSE.

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
            {&WINDOW-NAME}:TITLE = "Dynamics -  Dump Static Repository Data":U
            .

        IF NOT CONNECTED("ICFDB")
        THEN DO:

                MESSAGE
                    "*** Failure : Repository Database (ICFDB) not connected ":U
                    VIEW-AS ALERT-BOX INFORMATION.

            DISABLE
                buDump.

        END.
        ELSE DO:
            ENABLE
                buDump.
        END.

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

