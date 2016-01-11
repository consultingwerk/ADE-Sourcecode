&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bTableWin 
/*---------------------------------------------------------------------------------
  File: _calcselb

  Description:  Calculated field selector SmartDataBrowser

  Purpose:      Displays calculated fields available for inclusion in a Dynamic SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/14/2004  Author:     

  Update Notes: Created from Template rysttbrowb.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/globals.i}
{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target,Data-Target,Update-Source

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "adeuib/_calcseld.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME brTable

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rowObject

/* Definitions for BROWSE brTable                                       */
&Scoped-define FIELDS-IN-QUERY-brTable rowObject.tName rowObject.tEntity ~
rowObject.tInstanceName rowObject.tDesc rowObject.tProductModule 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable 
&Scoped-define QUERY-STRING-brTable FOR EACH rowObject NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable OPEN QUERY brTable FOR EACH rowObject NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable rowObject
&Scoped-define FIRST-TABLE-IN-QUERY-brTable rowObject


/* Definitions for FRAME frMain                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brTable 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE TEMP-TABLE RowObject NO-UNDO
    {{&DATA-FIELD-DEFS}}
    {src/adm2/robjflds.i}.

DEFINE QUERY brTable FOR 
      rowObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable bTableWin _STRUCTURED
  QUERY brTable NO-LOCK DISPLAY
      rowObject.tName FORMAT "x(70)":U WIDTH 30
      rowObject.tEntity FORMAT "x(70)":U WIDTH 30
      rowObject.tInstanceName FORMAT "x(35)":U WIDTH 30
      rowObject.tDesc FORMAT "x(35)":U WIDTH 40
      rowObject.tProductModule FORMAT "x(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS SIZE 115 BY 13.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     brTable AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataBrowser
   Data Source: "adeuib/_calcseld.w"
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW bTableWin ASSIGN
         HEIGHT             = 13.95
         WIDTH              = 115.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW bTableWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB brTable 1 frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable
/* Query rebuild information for BROWSE brTable
     _TblList          = "rowObject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > _<SDO>.rowObject.tName
"rowObject.tName" ? ? "character" ? ? ? ? ? ? no "?" no no "30" yes no no "U" "" ""
     _FldNameList[2]   > _<SDO>.rowObject.tEntity
"rowObject.tEntity" ? ? "character" ? ? ? ? ? ? no "?" no no "30" yes no no "U" "" ""
     _FldNameList[3]   > _<SDO>.rowObject.tInstanceName
"rowObject.tInstanceName" ? ? "character" ? ? ? ? ? ? no "?" no no "30" yes no no "U" "" ""
     _FldNameList[4]   > _<SDO>.rowObject.tDesc
"rowObject.tDesc" ? ? "character" ? ? ? ? ? ? no "?" no no "40" yes no no "U" "" ""
     _FldNameList[5]   > _<SDO>.rowObject.tProductModule
"rowObject.tProductModule" ? ? "character" ? ? ? ? ? ? no "?" no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE brTable */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME brTable
&Scoped-define SELF-NAME brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON CTRL-END OF brTable IN FRAME frMain
DO:
  APPLY "END":U TO BROWSE brTable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON CTRL-HOME OF brTable IN FRAME frMain
DO:
  APPLY "HOME":U TO BROWSE brTable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON DEFAULT-ACTION OF brTable IN FRAME frMain
DO:
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  {src/adm2/brsdefault.i}

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  IF VALID-HANDLE(hContainerSource) THEN
    RUN selectCalcField IN hContainerSource.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON END OF brTable IN FRAME frMain
DO:
  {src/adm2/brsend.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON HOME OF brTable IN FRAME frMain
DO:
  {src/adm2/brshome.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON OFF-END OF brTable IN FRAME frMain
DO:
  {src/adm2/brsoffnd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON OFF-HOME OF brTable IN FRAME frMain
DO:
  {src/adm2/brsoffhm.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON ROW-ENTRY OF brTable IN FRAME frMain
DO:
  {src/adm2/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON ROW-LEAVE OF brTable IN FRAME frMain
DO:
  {src/adm2/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON SCROLL-NOTIFY OF brTable IN FRAME frMain
DO:
  {src/adm2/brsscrol.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable bTableWin
ON VALUE-CHANGED OF brTable IN FRAME frMain
DO:
  {src/adm2/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bTableWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN initializeObject.        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

