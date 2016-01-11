&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/******************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions     *
* contributed by participants of Possenet.                        *
*                                                                 *
******************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/_viewasd.w

  Description: Dialog to set the view-as property for browse columns.

  Input Parameters:
      pcFields: Comma delimited list with the field names.
      pcDataTypes: comma delimited list with the field data-types.
      pcFieldFormats: comma delimited list with the field formats.
      pcBrowseType: "SmartDataBrowser" = A Dynamic or Static SmartDataBrowser.
                    "STATIC"  = A Static browser widget.
      
  Input-Output Parameters:
      pcColumnTypes: CHR(5) delimited list with the browse column types
      pcColumnDelimiters: CHR(5) delimited list with the browse column delimiters
      pcColumnItems: CHR(5) delimited list with the browse column ITEMS
      pcColumnItemPairs: CHR(5) delimited list with the browse column ITEM-PAIRS
      pcColumnInnerLines: CHR(5) delimited list with the browse column INNER-LINES
      pcColumnMaxChars: CHR(5) delimited list with the browse column MAX-CHARS
      pcColumnSort: CHR(5) delimited list with the browse column SORTs
      pcCoumnAutoCompletion: CHR(5) delimited list with the browse column AUTO-COMPLETIONs
      pcColumnUniqueMatch: CHR(5) delimited list with the browse column UNIQUE-MATCHes

  Output Parameters:
      pcCancel: FALSE if the OK button is pressed, otherwise TRUE.

  Author: Marcelo Ferrante

  Created: June 29 2006
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/
{adecomm/commeng.i}   /* Help String Definitions                 */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pcFields       AS CHARACTER   NO-UNDO.
DEFINE INPUT        PARAMETER pcDataTypes    AS CHARACTER   NO-UNDO.
DEFINE INPUT        PARAMETER pcFieldFormats AS CHARACTER   NO-UNDO.
DEFINE INPUT        PARAMETER pcBrowseType   AS CHARACTER   NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER pcColumnTypes          AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnDelimiters     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnItems          AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnItemPairs      AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnInnerLines     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnMaxChars       AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnSort           AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnAutoCompletion AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcColumnUniqueMatch    AS CHARACTER NO-UNDO.

DEFINE       OUTPUT PARAMETER pcCancel AS LOGICAL     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcCurrentField   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcDataType       AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coFields RECT-5 coViewAs raItems edItems ~
coType fiDelimiter raDelimiter fiInnerLines fiMaxChars toSort ~
toAutoCompletion toUniqueMatch Btn_OK Btn_Cancel Btn_Help fiChr fiClose 
&Scoped-Define DISPLAYED-OBJECTS coFields coViewAs raItems edItems coType ~
fiDelimiter raDelimiter fiInnerLines fiMaxChars toSort toAutoCompletion ~
toUniqueMatch fiChr fiClose 

/* Custom List Definitions                                              */
/* isModified,comboObjects,List-3,List-4,List-5,List-6                  */
&Scoped-define isModified coViewAs edItems coType fiDelimiter fiInnerLines ~
fiMaxChars toSort toAutoCompletion toUniqueMatch 
&Scoped-define comboObjects raItems edItems coType fiDelimiter raDelimiter ~
fiInnerLines fiMaxChars toSort toAutoCompletion toUniqueMatch 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildPropertyList Dialog-Frame 
FUNCTION buildPropertyList RETURNS CHARACTER
  (INPUT pcPropertyValue AS CHARACTER,
   INPUT pcFieldName     AS CHARACTER,
   INPUT pcFieldValue    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatListItemPairs Dialog-Frame 
FUNCTION formatListItemPairs RETURNS CHARACTER
  (INPUT pcItems     AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataType Dialog-Frame 
FUNCTION getDataType RETURNS CHARACTER
  (INPUT pcField AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDelimiter Dialog-Frame 
FUNCTION getDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetNames Dialog-Frame 
FUNCTION getWidgetNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnListItemPairs Dialog-Frame 
FUNCTION returnListItemPairs RETURNS CHARACTER
  (INPUT pcItems     AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDelimiter Dialog-Frame 
FUNCTION setDelimiter RETURNS LOGICAL
  (INPUT pcDelimiter AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setType Dialog-Frame 
FUNCTION setType RETURNS LOGICAL
  (INPUT pcDataType AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateValues Dialog-Frame 
FUNCTION validateValues RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coFields AS CHARACTER FORMAT "X(90)":U INITIAL "custnum" 
     LABEL "Field" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 33.4 BY 1 NO-UNDO.

DEFINE VARIABLE coType AS CHARACTER FORMAT "X(256)":U INITIAL "DROP-DOWN-LIST" 
     LABEL "Type" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "DROP-DOWN","DROP-DOWN-LIST" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE coViewAs AS CHARACTER FORMAT "X(10)":U 
     LABEL "View-as" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Combo-box","Toggle-box","Fill-in" 
     DROP-DOWN-LIST
     SIZE 17.8 BY 1 NO-UNDO.

DEFINE VARIABLE edItems AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 60 BY 4 NO-UNDO.

DEFINE VARIABLE fiChr AS CHARACTER FORMAT "X(50)":U INITIAL "Delimiter" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 9 BY .62 NO-UNDO.

DEFINE VARIABLE fiClose AS CHARACTER FORMAT "X(50)":U INITIAL ")" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 2 BY .62 NO-UNDO.

DEFINE VARIABLE fiDelimiter AS CHARACTER FORMAT "X(50)":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE fiInnerLines AS CHARACTER FORMAT "X(50)":U INITIAL "5" 
     LABEL "Inner Lines" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiMaxChars AS CHARACTER FORMAT "X(50)":U 
     LABEL "Maximum Characters" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 15.2 BY 1 NO-UNDO.

DEFINE VARIABLE raDelimiter AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Printable", "printable",
"Non-printable", "non-printable"
     SIZE 31 BY .71 NO-UNDO.

DEFINE VARIABLE raItems AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "List-Items", "I",
"List-Item-Pairs", "P"
     SIZE 36 BY .86 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY .1.

DEFINE VARIABLE toAutoCompletion AS LOGICAL INITIAL no 
     LABEL "Auto-Completion" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toSort AS LOGICAL INITIAL no 
     LABEL "Sort" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE toUniqueMatch AS LOGICAL INITIAL no 
     LABEL "Unique-Match" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     coFields AT ROW 1.14 COL 7.6 COLON-ALIGNED WIDGET-ID 36
     coViewAs AT ROW 2.43 COL 10.8 COLON-ALIGNED WIDGET-ID 32
     raItems AT ROW 4.05 COL 3.8 NO-LABEL WIDGET-ID 12
     edItems AT ROW 5 COL 4 NO-LABEL WIDGET-ID 18
     coType AT ROW 9.29 COL 7.8 COLON-ALIGNED WIDGET-ID 4
     fiDelimiter AT ROW 10.52 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     raDelimiter AT ROW 10.67 COL 4 NO-LABEL WIDGET-ID 38
     fiInnerLines AT ROW 11.76 COL 13.6 COLON-ALIGNED WIDGET-ID 16
     fiMaxChars AT ROW 11.76 COL 46.8 COLON-ALIGNED WIDGET-ID 20
     toSort AT ROW 13.05 COL 4 WIDGET-ID 22
     toAutoCompletion AT ROW 13.05 COL 20.8 WIDGET-ID 24
     toUniqueMatch AT ROW 13.05 COL 47 WIDGET-ID 26
     Btn_OK AT ROW 14.33 COL 3.8
     Btn_Cancel AT ROW 14.33 COL 18.8
     Btn_Help AT ROW 14.33 COL 49.4
     fiChr AT ROW 10.71 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     fiClose AT ROW 10.71 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     RECT-5 AT ROW 3.71 COL 4 WIDGET-ID 30
     SPACE(2.19) SKIP(11.94)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "View-as attributes"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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

/* SETTINGS FOR COMBO-BOX coType IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR COMBO-BOX coViewAs IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR EDITOR edItems IN FRAME Dialog-Frame
   1 2                                                                  */
ASSIGN 
       edItems:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.

ASSIGN 
       fiClose:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR FILL-IN fiDelimiter IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR FILL-IN fiInnerLines IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR FILL-IN fiMaxChars IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR RADIO-SET raDelimiter IN FRAME Dialog-Frame
   2                                                                    */
/* SETTINGS FOR RADIO-SET raItems IN FRAME Dialog-Frame
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX toAutoCompletion IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR TOGGLE-BOX toSort IN FRAME Dialog-Frame
   1 2                                                                  */
/* SETTINGS FOR TOGGLE-BOX toUniqueMatch IN FRAME Dialog-Frame
   1 2                                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* View-as attributes */
DO:
ASSIGN pcCancel = TRUE.
APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
ASSIGN pcCancel = TRUE.
APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
   RUN adecomm/_adehelp.p ("COMM", "CONTEXT", {&Viewas_Attribute_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
IF getWidgetNames() NE "" THEN
DO:

    IF NOT validateValues() THEN
        RETURN NO-APPLY.

    RUN saveValues.
END.

    ASSIGN pcCancel = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFields Dialog-Frame
ON VALUE-CHANGED OF coFields IN FRAME Dialog-Frame /* Field */
DO:
SESSION:SET-WAIT-STATE("GENERAL":U).

IF getWidgetNames() NE "" THEN
DO:

   IF NOT validateValues() THEN
   DO:
      /*If wrong values were entered for the selected field we have to
        stay in the same field and let the user to fix the problem; then
        return no-apply so nothing is changed. Fix for bug: 20060921-037*/
      ASSIGN SELF:SCREEN-VALUE = gcCurrentField.
      RETURN NO-APPLY.
   END.

   RUN saveValues.

END.
   RUN newFieldSelected.
SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coType Dialog-Frame
ON VALUE-CHANGED OF coType IN FRAME Dialog-Frame /* Type */
DO:
IF SELF:SCREEN-VALUE = "DROP-DOWN-LIST":U THEN
    ASSIGN toAutoCompletion:SENSITIVE = FALSE
           toAutoCompletion:CHECKED   = FALSE
           fiMaxChars:SENSITIVE       = FALSE
           toUniqueMatch:SENSITIVE    = FALSE
           toUniqueMatch:CHECKED      = FALSE.

ELSE
    ASSIGN toAutoCompletion:SENSITIVE = TRUE
           fiMaxChars:SENSITIVE       = TRUE
           toUniqueMatch:SENSITIVE    = toAutoCompletion:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coViewAs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coViewAs Dialog-Frame
ON VALUE-CHANGED OF coViewAs IN FRAME Dialog-Frame /* View-as */
DO:
IF SELF:SCREEN-VALUE = 'Combo-box':U THEN
DO:
    ENABLE {&comboObjects} WITH FRAME {&FRAME-NAME}.

    IF pcBrowseType = "STATIC":U THEN
        ASSIGN fiDelimiter:SCREEN-VALUE = ","
               raDelimiter:SCREEN-VALUE = "printable":U
               fiDelimiter:SENSITIVE = FALSE
               raDelimiter:SENSITIVE = FALSE
               fiClose:HIDDEN        = TRUE.

    IF fiDelimiter:SCREEN-VALUE = "" THEN ASSIGN fiDelimiter:SCREEN-VALUE = ",".
END.
ELSE DO:
   DISABLE {&comboObjects} WITH FRAME {&FRAME-NAME}.
   fiClose:HIDDEN        = TRUE.
END.

setType(gcDataType).

APPLY 'VALUE-CHANGED':U TO coType.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raDelimiter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raDelimiter Dialog-Frame
ON VALUE-CHANGED OF raDelimiter IN FRAME Dialog-Frame
DO:

IF SELF:SCREEN-VALUE = "printable":U THEN
ASSIGN fiChr:SCREEN-VALUE = "Delimiter:":U
       fiChr:WIDTH = 9
       fiChr:COL = 38
       fiClose:HIDDEN = TRUE
       fiDelimiter:SCREEN-VALUE = "":U.

ELSE
ASSIGN fiChr:SCREEN-VALUE = "CHR(":U
       fiChr:WIDTH = 6
       fiChr:COL = 41
       fiClose:HIDDEN = FALSE
       fiDelimiter:SCREEN-VALUE = "":U.

ASSIGN fiDelimiter:MODIFIED = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raItems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raItems Dialog-Frame
ON VALUE-CHANGED OF raItems IN FRAME Dialog-Frame
DO:
  DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
  DEFINE VARIABLE tmpString  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDelimiter AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cItems     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFormat    AS CHARACTER   NO-UNDO.

  ASSIGN edItems:SCREEN-VALUE = RIGHT-TRIM(edItems:SCREEN-VALUE)
         cDelimiter = getDelimiter()
         cFormat    = ENTRY(LOOKUP(gcCurrentField, pcFields), pcFieldFormats) NO-ERROR.

  IF edItems:SCREEN-VALUE NE "" THEN
  DO:
    /* Try to convert current contents */
    IF SELF:SCREEN-VALUE = "I" /* LIST-ITEMS */ THEN
    DO:
      DO i = 1 TO NUM-ENTRIES(edItems:SCREEN-VALUE,CHR(10)):
        tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                     ENTRY(1,ENTRY(i,edItems:SCREEN-VALUE,CHR(10)),cDelimiter).
      END.

    END.
    ELSE DO: /* LIST-ITEM-PAIRS */
      DO i = 1 TO NUM-ENTRIES(edItems:SCREEN-VALUE,CHR(10)):
        ASSIGN tmpString = (IF tmpString NE "" THEN tmpString + CHR(10) ELSE tmpString) + 
                           ENTRY(i,edItems:SCREEN-VALUE,CHR(10)) + cDelimiter.
        CASE gcDataType: /* Figure out which value to display based on data type */
          WHEN "CHARACTER":U THEN tmpString = tmpString + ENTRY(i,edItems:SCREEN-VALUE,CHR(10)).
          WHEN "INTEGER":U   THEN tmpString = tmpString + STRING(i,     IF cFormat = ? OR cFormat = "" THEN "->,>>>,>>9" ELSE cFormat).
          WHEN "INT64":U     THEN tmpString = tmpString + STRING(i,     IF cFormat = ? OR cFormat = "" THEN "->,>>>,>>9" ELSE cFormat).
          WHEN "LOGICAL":U   THEN tmpString = tmpString + STRING(no,    IF cFormat = ? OR cFormat = "" THEN "yes/no" ELSE cFormat).
          WHEN "DECIMAL":U   THEN tmpString = tmpString + STRING(i,     IF cFormat = ? OR cFormat = "" THEN "->>,>>9.99" ELSE cFormat).
          WHEN "DATE":U      THEN tmpString = tmpString + STRING(TODAY, IF cFormat = ? OR cFormat = "" THEN "99/99/99" ELSE cFormat).
        END.
        ASSIGN tmpString = tmpString + (IF i <> NUM-ENTRIES(edItems:SCREEN-VALUE,CHR(10)) THEN cDelimiter ELSE "").
      END.
  END.

    ASSIGN edItems:SCREEN-VALUE = TRIM(tmpString).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toAutoCompletion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toAutoCompletion Dialog-Frame
ON VALUE-CHANGED OF toAutoCompletion IN FRAME Dialog-Frame /* Auto-Completion */
DO:
  ASSIGN toUniqueMatch:SENSITIVE = SELF:CHECKED
         toUniqueMatch:MODIFIED  = TRUE.
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

RUN fillFieldCombo.
RUN newFieldSelected.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY coFields coViewAs raItems edItems coType fiDelimiter raDelimiter 
          fiInnerLines fiMaxChars toSort toAutoCompletion toUniqueMatch fiChr 
          fiClose 
      WITH FRAME Dialog-Frame.
  ENABLE coFields RECT-5 coViewAs raItems edItems coType fiDelimiter 
         raDelimiter fiInnerLines fiMaxChars toSort toAutoCompletion 
         toUniqueMatch Btn_OK Btn_Cancel Btn_Help fiChr fiClose 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillFieldCombo Dialog-Frame 
PROCEDURE fillFieldCombo :
/*------------------------------------------------------------------------------
  Purpose: Fills the 'Field' combo-box using the pcFields parameters. Only valid
           data types for COMBO-BOX and TOGGLE-BOX are loaded. They are:
           DECIMAL,CHARACTER,INTEGER,INT64,DATE,LOGICAL.

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField AS INTEGER     NO-UNDO.

/*If there is one entry in pcFields is because the window was called*/
IF NUM-ENTRIES(pcFields) = 1 THEN
DO:
   coFields:ADD-LAST(pcFields) IN FRAME {&FRAME-NAME}.
   coFields:SENSITIVE = FALSE.
END.

ELSE
REPEAT iField = 1 TO NUM-ENTRIES(pcFields):
    IF NOT CAN-DO("DECIMAL,CHARACTER,INTEGER,INT64,DATE,LOGICAL":U, getDataType(ENTRY(iField, pcFields))) THEN
       NEXT.

       coFields:ADD-LAST(ENTRY(iField, pcFields)).
END.

coFields:SCREEN-VALUE = coFields:ENTRY(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadValues Dialog-Frame 
PROCEDURE loadValues :
/*------------------------------------------------------------------------------
  Purpose: Load the values received as parameters in the widgets.
  Parameters:  <none>
  Notes: This procedure is called from newFieldSelected
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFieldPosition AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPropertyValue AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItems         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDelimiter     AS CHARACTER   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

ASSIGN iFieldPosition       = LOOKUP(gcCurrentField, pcFields)
       cDelimiter           = ENTRY(iFieldPosition, pcColumnDelimiters, CHR(5)) NO-ERROR. /*Gets the delimiter*/

ASSIGN edItems:SCREEN-VALUE = "":U.

IF cDelimiter = "?" OR cDelimiter = ? OR cDelimiter = "" THEN
    ASSIGN cDelimiter = ",". /*Default value for delimiter is comma*/

setDelimiter(cDelimiter).

ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnTypes, CHR(5)) NO-ERROR. /*Gets the ColumnType property*/

CASE cPropertyValue:
    WHEN "TB":U THEN ASSIGN coViewAs:SCREEN-VALUE = "Toggle-box":U.

    WHEN "DD":U OR WHEN "DDL":U THEN
    DO:
         ASSIGN coViewAs:SCREEN-VALUE = "Combo-box":U
                coType:SCREEN-VALUE   = IF cPropertyValue = "DD":U THEN "DROP-DOWN":U ELSE "DROP-DOWN-LIST":U.

         ASSIGN cItems = ENTRY(iFieldPosition, pcColumnItems, CHR(5)) NO-ERROR.
        
        /*Sets the list-items or list-item-pairs property*/
        IF cItems = ? OR cItems = "?" OR cItems = "" THEN /*no list-items means we have list-item-pairs*/
           ASSIGN raItems:SCREEN-VALUE = "P":U
                  edItems:SCREEN-VALUE = returnListItemPairs(ENTRY(iFieldPosition, pcColumnItemPairs, CHR(5)), cDelimiter) NO-ERROR.

        ELSE
           ASSIGN raItems:SCREEN-VALUE = "I":U
                  edItems:SCREEN-VALUE = REPLACE(cItems, cDelimiter, CHR(10)).
    END. /*WHEN "DD":U OR WHEN "DDL":U*/

    OTHERWISE ASSIGN coViewAs:SCREEN-VALUE = "Fill-in":U.
END CASE.

/*Gets the inner-lines*/
ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnInnerLines, CHR(5)) NO-ERROR.
ASSIGN fiInnerLines:SCREEN-VALUE = IF ERROR-STATUS:ERROR OR cPropertyValue EQ ? OR cPropertyValue EQ "" OR cPropertyValue EQ "?" THEN "5" ELSE cPropertyValue.

/*Gets the max-chars*/
ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnMaxChars, CHR(5)) NO-ERROR.
ASSIGN fiMaxChars:SCREEN-VALUE = IF ERROR-STATUS:ERROR OR cPropertyValue EQ ? OR cPropertyValue EQ "" OR cPropertyValue EQ "?" THEN "0" ELSE cPropertyValue.

/*Gest the Sort*/
ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnSort, CHR(5)) NO-ERROR.
ASSIGN toSort:CHECKED = IF NOT ERROR-STATUS:ERROR AND cPropertyValue = "Y" THEN YES ELSE FALSE.

/*Gets the Auto-completion*/
ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnAutoCompletion, CHR(5)) NO-ERROR.
ASSIGN toAutoCompletion:CHECKED = IF NOT ERROR-STATUS:ERROR AND cPropertyValue = "Y" THEN YES ELSE FALSE.

/*Gets the Unique-match*/
ASSIGN cPropertyValue = ENTRY(iFieldPosition, pcColumnUniqueMatch, CHR(5)) NO-ERROR.
ASSIGN toUniqueMatch:CHECKED = IF NOT ERROR-STATUS:ERROR AND cPropertyValue = "Y" THEN YES ELSE FALSE.

END. /*DO WITH FRAME {&FRAME-NAME}*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newFieldSelected Dialog-Frame 
PROCEDURE newFieldSelected :
/*------------------------------------------------------------------------------
  Purpose: Sets variables and widgets according to the new field selected.

  Parameters:  <none>
  Notes: This procedure is called when the dialog is opened, or when a new field
         is selected in the 'Field' combo-box.

------------------------------------------------------------------------------*/
ASSIGN gcDataType     = getDataType(coFields:SCREEN-VALUE IN FRAME {&FRAME-NAME})
       gcCurrentField = coFields:SCREEN-VALUE.

setType(gcDataType).

IF gcDataType = "LOGICAL":U THEN
  ASSIGN coViewAs:LIST-ITEMS = "Combo-box,Toggle-box,Fill-in":U.
ELSE
  ASSIGN coViewAs:LIST-ITEMS = "Combo-box,Fill-in":U.

RUN loadValues.

APPLY 'VALUE-CHANGED':U TO coViewAs.
APPLY 'VALUE-CHANGED':U TO coType.
APPLY 'VALUE-CHANGED':U TO toAutoCompletion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveValues Dialog-Frame 
PROCEDURE saveValues :
/*------------------------------------------------------------------------------
  Purpose: Stores the new values in the input-output parameter lists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cModifiedFields AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cDelimiter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iField     AS INTEGER     NO-UNDO.

ASSIGN cModifiedFields = getWidgetNames().

DO WITH FRAME {&FRAME-NAME}:

REPEAT iField = 1 TO NUM-ENTRIES(cModifiedFields):
    ASSIGN cField = ENTRY(iField, cModifiedFields).

        IF cField = "coViewAs":U OR cField = "coType":U THEN
            CASE coViewAs:SCREEN-VALUE:
                WHEN "Toggle-box":U THEN ASSIGN pcColumnTypes = buildPropertyList(pcColumnTypes, gcCurrentField, "TB":U).
                WHEN "Combo-box":U  THEN ASSIGN pcColumnTypes = buildPropertyList(pcColumnTypes, gcCurrentField, IF coType:SCREEN-VALUE = "DROP-DOWN":U THEN "DD":U ELSE "DDL":U).
                WHEN "Fill-in":U    THEN
                DO:
                     /*If the field is set back to fill-in, we assign null to every property value.*/
                     ASSIGN pcColumnTypes           = buildPropertyList(pcColumnTypes,          gcCurrentField, "?":U)
                            pcColumnItemPairs       = buildPropertyList(pcColumnItemPairs,      gcCurrentField, "?":U)
                            pcColumnItems           = buildPropertyList(pcColumnItems,          gcCurrentField, "?":U)
                            pcColumnDelimiters      = buildPropertyList(pcColumnDelimiters,     gcCurrentField, "?":U)
                            pcColumnInnerLines      = buildPropertyList(pcColumnInnerLines,     gcCurrentField, "?":U)
                            pcColumnMaxChars        = buildPropertyList(pcColumnMaxChars,       gcCurrentField, "?":U)
                            pcColumnSort            = buildPropertyList(pcColumnSort,           gcCurrentField, "?":U)
                            pcColumnAutoCompletion  = buildPropertyList(pcColumnAutoCompletion, gcCurrentField, "?":U)
                            pcColumnUniqueMatch     = buildPropertyList(pcColumnUniqueMatch,    gcCurrentField, "?":U).
                     RETURN.
                END. /*WHEN "Fill-in":U*/
            END CASE.

        IF coViewAs:SCREEN-VALUE NE "Combo-box":U THEN NEXT.

        CASE cField:
        WHEN "edItems":U THEN
        DO:
            ASSIGN edItems:SCREEN-VALUE = TRIM(edItems:SCREEN-VALUE, CHR(10)).

            IF raItems:SCREEN-VALUE = "I":U THEN
                /*If the new value is a list-items list we have to reset list-item-pairs to ?*/
                ASSIGN pcColumnItemPairs = buildPropertyList(pcColumnItemPairs, gcCurrentField, "?":U)
                       pcColumnItems     = buildPropertyList(pcColumnItems,     gcCurrentField, REPLACE(edItems:SCREEN-VALUE, CHR(10), getDelimiter())).
            ELSE
                /*If the new value is a list-item-pairs list we have to reset list-items to ?*/
                ASSIGN pcColumnItems     = buildPropertyList(pcColumnItems, gcCurrentField, "?")
                       pcColumnItemPairs = buildPropertyList(pcColumnItemPairs, gcCurrentField, formatListItemPairs(edItems:SCREEN-VALUE, getDelimiter())).

        END. /*WHEN "edItems"*/

        WHEN "fiDelimiter":U THEN
             ASSIGN cDelimiter  = getDelimiter()
                    pcColumnDelimiters = buildPropertyList(pcColumnDelimiters, gcCurrentField, IF cDelimiter = "," THEN "?" ELSE cDelimiter).

        WHEN "fiInnerLines":U THEN
             ASSIGN pcColumnInnerLines = buildPropertyList(pcColumnInnerLines, gcCurrentField, IF fiInnerLines:SCREEN-VALUE = "0" THEN "?" ELSE fiInnerLines:SCREEN-VALUE).

        WHEN "fiMaxChars":U THEN
             ASSIGN pcColumnMaxChars = buildPropertyList(pcColumnMaxChars, gcCurrentField, IF fiMaxChars:SCREEN-VALUE = "0" THEN "?" ELSE fiMaxChars:SCREEN-VALUE).

        /*FALSE is the default value for logical properties, therefore we pass "?" if the value is false in the following properties.*/
        WHEN "toSort":U THEN
             ASSIGN pcColumnSort  = buildPropertyList(pcColumnSort, gcCurrentField, IF toSort:CHECKED THEN "Y":U ELSE "?").

        WHEN "toAutoCompletion":U THEN
             ASSIGN pcColumnAutoCompletion  = buildPropertyList(pcColumnAutoCompletion, gcCurrentField, IF toAutoCompletion:CHECKED THEN "Y":U ELSE "?":U).

        WHEN "toUniqueMatch":U THEN
             ASSIGN pcColumnUniqueMatch = buildPropertyList(pcColumnUniqueMatch, gcCurrentField, IF toUniqueMatch:CHECKED AND toAutoCompletion:CHECKED THEN "Y":U ELSE "?").

    END CASE.

END. /*REPEAT*/

END. /*DO WITH FRAME {&FRAME-NAME}:*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildPropertyList Dialog-Frame 
FUNCTION buildPropertyList RETURNS CHARACTER
  (INPUT pcPropertyValue AS CHARACTER,
   INPUT pcFieldName     AS CHARACTER,
   INPUT pcFieldValue    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Assigns the property value in the position related to the field.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFieldPosition         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPosition              AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPropertyEntries       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFieldsEntries         AS INTEGER     NO-UNDO.

DEFINE VARIABLE lDefValues             AS LOGICAL     NO-UNDO INITIAL TRUE.

ASSIGN iFieldPosition   = LOOKUP(pcFieldName, pcFields)
       iFieldsEntries   = NUM-ENTRIES(pcFields)
       iPropertyEntries = NUM-ENTRIES(pcPropertyValue, CHR(5)).

REPEAT iPosition = 1 TO iFieldsEntries:
    /*The property could be blank, so we add the default value ("?") to each entry*/
    IF iPropertyEntries LT iFieldsEntries THEN ASSIGN pcPropertyValue = pcPropertyValue + "?" + CHR(5).

    /*If we are in the entry that is the same position than the field passed as parameter, we set
      the value passed in pcValue in the current position*/
    IF iPosition = iFieldPosition THEN
        ASSIGN ENTRY(iFieldPosition, pcPropertyValue, CHR(5)) = pcFieldValue.

    /*lDefValues is initialized as TRUE, if some value is not the default, lDefValues is
      set to FALSE*/
    IF lDefValues AND ENTRY(iPosition, pcPropertyValue, CHR(5)) NE "?" THEN
       ASSIGN lDefValues = FALSE.
END.

/*If lDefValues=TRUE is because all of the values in the property are the defaults, so we blank the property*/
ASSIGN pcPropertyValue = IF lDefValues = TRUE THEN "" ELSE TRIM(pcPropertyValue, CHR(5)).

RETURN pcPropertyValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatListItemPairs Dialog-Frame 
FUNCTION formatListItemPairs RETURNS CHARACTER
  (INPUT pcItems     AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Replaces the CHR(10) in the editor with the delimiter. Then that value
           is written in the file.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cListItemPairs AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cItem          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iItem          AS INTEGER     NO-UNDO.

/*Each line (item) in the editor could finish with the delimiter or without it, so we
  add the delimiter if it is not pressent*/
REPEAT iItem = 1 TO NUM-ENTRIES(pcItems, CHR(10)):
       ASSIGN cItem          = ENTRY(iItem, pcItems, CHR(10))
              cListItemPairs = cListItemPairs + cItem +
              IF SUBSTRING(cItem, LENGTH(cItem), 1) = pcDelimiter THEN "" ELSE pcDelimiter.
END.

ASSIGN cListItemPairs = TRIM(cListItemPairs, pcDelimiter).

RETURN cListItemPairs.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataType Dialog-Frame 
FUNCTION getDataType RETURNS CHARACTER
  (INPUT pcField AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns the data-type for the field passed as parameter
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFieldPosition AS INTEGER     NO-UNDO.

ASSIGN iFieldPosition = LOOKUP(pcField, pcFields).

RETURN IF iFieldPosition EQ 0 THEN "" ELSE ENTRY(iFieldPosition, pcDataTypes).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDelimiter Dialog-Frame 
FUNCTION getDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the entered delimiter.
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

    IF raDelimiter:SCREEN-VALUE = "non-printable":U THEN
       RETURN CHR(fiDelimiter:INPUT-VALUE).

    ELSE
       RETURN fiDelimiter:SCREEN-VALUE.
END.

RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetNames Dialog-Frame 
FUNCTION getWidgetNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*-------------------------------------------------------------------------------
  Purpose: Returns a comma delimited list with the widget names that contains
           information for the view-as property.
    Notes:  
-------------------------------------------------------------------------------*/
DEFINE VARIABLE cModifiedFields AS CHARACTER   NO-UNDO.

DEFINE VARIABLE hField          AS HANDLE      NO-UNDO.

ASSIGN hField = FRAME {&FRAME-NAME}:FIRST-CHILD
       hField = hField:FIRST-CHILD.

DO WHILE VALID-HANDLE(hField):

    IF LOOKUP(hField:NAME, "{&isModified}":U, " ") > 0 AND CAN-DO("COMBO-BOX,EDITOR,TOGGLE-BOX,FILL-IN":U, hField:TYPE) THEN
                    ASSIGN cModifiedFields = cModifiedFields + hField:NAME + ",".

    ASSIGN hField = hField:NEXT-SIBLING NO-ERROR.

END.

ASSIGN cModifiedFields = TRIM(cModifiedFields, ",").

RETURN IF cModifiedFields = ? THEN "" ELSE cModifiedFields.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnListItemPairs Dialog-Frame 
FUNCTION returnListItemPairs RETURNS CHARACTER
  (INPUT pcItems     AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns the list-item-pairs values formated to be displayed in the
           editor.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTempItems AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.

REPEAT i = 1 TO NUM-ENTRIES(pcItems, pcDelimiter) BY 2:
    ASSIGN cTempItems = cTempItems + ENTRY(i, pcItems, pcDelimiter) + pcDelimiter +
                                     ENTRY(i + 1, pcItems, pcDelimiter) + pcDelimiter + CHR(10).
END.

ASSIGN cTempItems = TRIM(TRIM(cTempItems, CHR(10)), pcDelimiter).

RETURN cTempItems.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDelimiter Dialog-Frame 
FUNCTION setDelimiter RETURNS LOGICAL
  (INPUT pcDelimiter AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Sets the delimiter in the fiDelimiter and riDelimiter values
           according to its ASCII value.
    Notes:
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

    IF ASC(pcDelimiter) LE 31 OR ASC(pcDelimiter) GE 127 THEN
        ASSIGN raDelimiter:SCREEN-VALUE = "non-printable":U
               fiDelimiter:SCREEN-VALUE = STRING(ASC(pcDelimiter)).

    ELSE
        ASSIGN raDelimiter:SCREEN-VALUE = "printable":U
               fiDelimiter:SCREEN-VALUE = pcDelimiter
               fiClose:HIDDEN           = TRUE.

    IF raDelimiter:SCREEN-VALUE = "printable":U AND fiDelimiter:SCREEN-VALUE = "" THEN
        ASSIGN fiDelimiter:SCREEN-VALUE = ",".
END.

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setType Dialog-Frame 
FUNCTION setType RETURNS LOGICAL
  (INPUT pcDataType AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF pcDataType NE 'CHARACTER':U THEN
DO:
    ASSIGN coType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DROP-DOWN-LIST":U
           coType:SENSITIVE    = FALSE.
END.

IF coViewAs:SCREEN-VALUE NE "COMBO-BOX":U THEN
   ASSIGN coType:MODIFIED = FALSE.

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateValues Dialog-Frame 
FUNCTION validateValues RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF coViewAs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Combo-box":U THEN
DO:

    IF edItems:SCREEN-VALUE = "" OR edItems:SCREEN-VALUE = ? THEN
    DO:
        MESSAGE (IF raItems:SCREEN-VALUE = "P" THEN "LIST-ITEM-PAIRS":U ELSE "LIST-ITEMS":U) " must be entered for a COMBO-BOX widget" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN FALSE.
    END.

    RUN adecomm/_vtitems.p (INPUT edItems:SCREEN-VALUE,
                            INPUT IF raItems:SCREEN-VALUE = "P" THEN "LIST-ITEM-PAIRS":U ELSE "LIST-ITEMS":U,
                            INPUT gcDataType,
                            INPUT IF raDelimiter:SCREEN-VALUE = "printable":U THEN fiDelimiter:SCREEN-VALUE ELSE CHR(fiDelimiter:INPUT-VALUE)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
    DO:
        MESSAGE "Invalid '" (IF raItems:SCREEN-VALUE = "P" THEN "LIST-ITEM-PAIRS":U ELSE "LIST-ITEMS":U) "' definition for '" gcDataType "' datatype for" SKIP
                "field '" gcCurrentField + "'" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN FALSE.
    END.

    IF (fiDelimiter:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? OR fiDelimiter:SCREEN-VALUE = "") THEN
    DO:
        MESSAGE 'You must enter a delimiter'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN FALSE.
    END.

    IF ASC(fiDelimiter:SCREEN-VALUE) LE 5 THEN
    DO:
        MESSAGE 'Delimiter must be CHR(6) or greater'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN FALSE.
    END.
END.

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

