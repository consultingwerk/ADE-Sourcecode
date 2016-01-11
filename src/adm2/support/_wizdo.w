&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
/* Procedure Description
"SDO Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _wizdo.w

  Description: SDO wizard page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Ross Hunter 

  Created: 4/4/95 
  Modified: 03/25/98 SLK Changed d-*.* to d*.*
  Modified: 04/08/98 HD   Validate Filename when NEXT
  
  Notes:  The three types are treated as follows. 
          SmartBusinessObject
              - use a homemade toggle box object to allow 
                the user to specify enabled and disabled fields.
              - Use the main wizard DataSourcenames and UpdataSourcenames
                as storage of the selected values.
          DataView - include file 
              - use a selection list to select the dataTable.      
              - STARTS another object if table is changed (storedataObjectList)
              - The object's DataTable then also stores the selected values.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{src/adm2/support/admhlp.i} /* ADM Help File Defs */
{destdefi.i} /*  Contains definitions for dynamics design-time temp-tables. */
{src/adm2/globals.i}
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE objtype    AS CHARACTER NO-UNDO.
DEFINE VARIABLE obj-recid  AS CHARACTER NO-UNDO.
DEFINE VARIABLE proc-recid AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-status   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE gWizardHdl          AS HANDLE  NO-UNDO.
DEFINE VARIABLE gDOHdl              AS HANDLE  NO-UNDO.
DEFINE VARIABLE ghSDOSelect         AS HANDLE  NO-UNDO.
DEFINE VARIABLE glDynamicsIsRunning AS LOGICAL NO-UNDO.

DEFINE VARIABLE xiHorMargin   AS INTEGER NO-UNDO INIT 4.
DEFINE VARIABLE xiToggleSpace AS INTEGER NO-UNDO INIT 10.

DEFINE TEMP-TABLE ttDataObject
    FIELD DOName        AS CHAR
    FIELD hName         AS HANDLE 
    FIELD hDataSource   AS HANDLE 
    FIELD hUpdateTarget AS HANDLE 
    INDEX DOName DOName .

FUNCTION getDataSourceNames   RETURNS CHARACTER IN gWizardHdl.
FUNCTION setDataSourceNames   RETURNS LOGICAL (pcNames AS CHAR) IN gWizardHdl.
FUNCTION getUpdateTargetNames RETURNS CHARACTER IN gWizardHdl.
FUNCTION setUpdateTargetNames RETURNS LOGICAL (pcNames AS CHAR) IN gWizardHdl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg cObjectType Data_Object b_Helpq 
&Scoped-Define DISPLAYED-OBJECTS e_msg cObjectType Data_Object 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitialFileName C-Win 
FUNCTION getInitialFileName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter C-Win 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObject C-Win 
FUNCTION initDataObject RETURNS LOGICAL
  (pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObjectList C-Win 
FUNCTION initDataObjectList RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isRepositoryObject C-Win 
FUNCTION isRepositoryObject RETURNS LOGICAL
  ( pcObject AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeDataObjectList C-Win 
FUNCTION removeDataObjectList RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeObjectsFromList C-Win 
FUNCTION removeObjectsFromList RETURNS LOGICAL
  (pcObjectList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetDataSource C-Win 
FUNCTION resetDataSource RETURNS LOGICAL
  ( pcDataObject AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetFromRepository C-Win 
FUNCTION resetFromRepository RETURNS LOGICAL
  ( plFromRepository AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetObjectType C-Win 
FUNCTION resetObjectType RETURNS LOGICAL
  ( pcObjectType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeDataObjectList C-Win 
FUNCTION storeDataObjectList RETURNS LOGICAL
  ( plCheck AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnbrws 
     LABEL "Brow&se..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON btnRepos 
     IMAGE-UP FILE "adeicon/browse-u.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 4.6 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON b_Helpq 
     LABEL "&Help on definition source" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 4.81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE cIncludeLabel AS CHARACTER FORMAT "X(50)":U INITIAL "DataTables:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE cSBOLabel AS CHARACTER FORMAT "X(50)":U INITIAL "DataObjects:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE Data_Object AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cObjectType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "SmartDataObject", "SmartDataObject",
"SmartBusinessObject", "SmartBusinessObject",
"Include file", "DataView"
     SIZE 26.4 BY 2.71 NO-UNDO.

DEFINE VARIABLE lFromRepos AS LOGICAL 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "From Repository", yes,
"Static", no
     SIZE 21.6 BY 1.81 NO-UNDO.

DEFINE RECTANGLE rRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 4.81.

DEFINE VARIABLE cDataTable AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 54 BY 5.29 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnRepos AT ROW 4.91 COL 50.2 WIDGET-ID 8 NO-TAB-STOP 
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     cObjectType AT ROW 1.95 COL 3 NO-LABEL
     lFromRepos AT ROW 1.95 COL 33.4 NO-LABEL WIDGET-ID 10
     Data_Object AT ROW 4.91 COL 3 NO-LABEL
     btnbrws AT ROW 4.91 COL 40
     cDataTable AT ROW 7.14 COL 2 NO-LABEL WIDGET-ID 2
     b_Helpq AT ROW 11.33 COL 57
     cIncludeLabel AT ROW 6.48 COL 2 NO-LABEL WIDGET-ID 4
     cSBOLabel AT ROW 6.48 COL 2 NO-LABEL WIDGET-ID 6
     "Data definition source" VIEW-AS TEXT
          SIZE 21.6 BY .62 AT ROW 1.19 COL 3.4
     rRect AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 11.86
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.86
         WIDTH              = 83.8
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 107.2
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 107.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME UNDERLINE                                                 */
/* SETTINGS FOR BUTTON btnbrws IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRepos IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST cDataTable IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cDataTable:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cIncludeLabel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       cIncludeLabel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSBOLabel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       cSBOLabel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN Data_Object IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR RADIO-SET lFromRepos IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RECTANGLE rRect IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnbrws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnbrws C-Win
ON CHOOSE OF btnbrws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DEFINE VARIABLE lcancelled  AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE otherthing AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE Attributes AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE Template   AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE ObjLabel      AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE oldData_Object AS CHARACTER        NO-UNDO.  
  DEFINE VARIABLE cFilterlist    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject        AS CHARACTER  NO-UNDO.
  IF cObjectType = 'DataView':U THEN
  DO:
    IF index(data_object,'.') > 0 OR index(data_object,'*') > 0 THEN
      cObject = data_object.
    ELSE IF data_object > '' THEN
      cFilterList = data_object.
          
    RUN adecomm/_getfiledialog.p ( "Select data definition include",
                                   (IF cfilterlist > '' 
                                    THEN "Filtered include files (" + cFilterList + "*.i),"
                                    ELSE "")
                                    + "Include files (*.i),All files(*.*)",
                                    INPUT-OUTPUT cobject).
    lcancelled = cobject = ''. 
    IF NOT lcancelled THEN
      data_object = cObject.
  END.
  ELSE DO:
    RUN adeuib/_uibinfo.p (
        INPUT ?,
        INPUT "PALETTE-ITEM ":U + cObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME},
        INPUT "ATTRIBUTES":U,
        OUTPUT Attributes).
    /*
    Cannot use template if the template starts a wizard  
    
    RUN adeuib/_uibinfo.p (
        INPUT ?,
        INPUT "PALETTE-ITEM ":U + xSmartDataObject,
        INPUT "TEMPLATE":U,
        OUTPUT Template).
    */
    
    IF Attributes <> "" THEN
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN oldData_Object = Data_Object:SCREEN-VALUE.
      RUN adecomm/_chosobj.w (
          INPUT "smartObject",
          INPUT Attributes,
          INPUT Template,
          INPUT "BROWSE,PREVIEW":U,
          OUTPUT Data_Object,
          OUTPUT OtherThing,
          OUTPUT lcancelled).
    END.
  END.
  IF NOT lcancelled THEN 
  DO:

    IF Data_Object BEGINS('.~\':U) THEN
      Data_Object = SUBSTR(Data_Object,3).
    IF oldData_Object <> Data_Object THEN
    DO:
      IF NOT resetDataSource(Data_Object) THEN 
        Data_Object = oldData_Object.
      DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRepos C-Win
ON CHOOSE OF btnRepos IN FRAME DEFAULT-FRAME
DO:
 DEFINE VARIABLE cObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

 ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 
 RUN ry/obj/gopendialog.w (INPUT {&WINDOW-NAME},
                           INPUT "",
                           INPUT No,
                           INPUT "Get Object",
                           OUTPUT cObject,
                           OUTPUT lok).
 IF lOK THEN
 DO:
   IF Data_Object <> cObject THEN
   DO:
     IF resetDataSource(cObject) THEN 
       Data_Object = cObject.
      DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.
   END.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpq C-Win
ON CHOOSE OF b_Helpq IN FRAME DEFAULT-FRAME /* Help on definition source */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Data_Object}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDataTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataTable C-Win
ON VALUE-CHANGED OF cDataTable IN FRAME DEFAULT-FRAME
DO:
  ASSIGN cDataTable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cObjectType C-Win
ON VALUE-CHANGED OF cObjectType IN FRAME DEFAULT-FRAME
DO:
  DEFINE VARIABLE cOldType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk      AS LOGICAL    NO-UNDO.
  ASSIGN 
    cOldType = cObjectType
    cObjectType.
  RUN objectTypechanged(SELF:SCREEN-VALUE, OUTPUT lok).
  IF NOT lok THEN 
  DO:
    cObjectType = cOldType.
    DISPLAY cObjectType WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Data_Object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Data_Object C-Win
ON VALUE-CHANGED OF Data_Object IN FRAME DEFAULT-FRAME
DO: 
  /* nullify all data 
   (NOTE that data_object is used as stored property for comparison in logic ) */
  resetDataSource(data_object:SCREEN-VALUE). 
  DISPLAY data_object WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lFromRepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lFromRepos C-Win
ON VALUE-CHANGED OF lFromRepos IN FRAME DEFAULT-FRAME
DO:
  IF resetDataSource('') THEN
  DO:
    ASSIGN lFromRepos.
    resetFromRepository(lFromRepos).
  END.
  DISPLAY lFromRepos WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.      
              
glDynamicsIsRunning = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
IF glDynamicsIsRunning = ? THEN
   glDynamicsIsRunning = NO.

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get procedure type (SmartViewer or SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT objtype).

/* If this SmartViewer or SmartBrowser already has a DataObject defined  */
/* then preset Data_Object.                                              */
RUN adeuib/_uibinfo.p (INTEGER(proc-recid)," ","DataObject", OUTPUT Data_Object).

lFromRepos = glDynamicsIsrunning.
IF NUM-ENTRIES(Data_object) > 1 THEN
DO:
  resetObjectType('DataView':U).
  cDataTable = ENTRY(2,Data_object).
  Data_object = ENTRY(1,Data_object).
  lFromRepos = FALSE.
END.
ELSE IF glDynamicsIsrunning AND Data_Object <> '' THEN
DO:
  lFromRepos = isRepositoryObject(Data_Object).
END.
ELSE lFromRepos = glDynamicsIsrunning.

DO WITH FRAME {&FRAME-NAME}:
  /* SBO was selected from this page previously */
  IF getDataSourceNames() = '' THEN
  DO:
    cObjectType = 'SmartbusinessObject':U.
    DISPLAY cObjectType.
  END.
  IF NOT glDynamicsIsrunning THEN
    lFromRepos:HIDDEN = TRUE.
END.

resetFromRepository(lFromRepos).
initDataObject(Data_object).

ASSIGN e_msg = 
      "You need to specify the DataObject or include file that will provide data definitions for this " +
      objtype + ".".

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   /* Store DataObject filename */
   DO WITH FRAME {&FRAME-NAME}:
     RUN ProcessPage NO-ERROR. 
     IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.  
   END.
   IF VALID-HANDLE(ghSDOSelect) THEN
     RUN destroyObject IN ghSDOSelect.
   RUN disable_UI.
END.

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
  /* Hide all frames. */
  HIDE FRAME DEFAULT-FRAME.
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
  DISPLAY e_msg cObjectType Data_Object 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg cObjectType Data_Object b_Helpq 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ObjectTypeChanged C-Win 
PROCEDURE ObjectTypeChanged :
/*------------------------------------------------------------------------------
  Purpose: Object type change called from trigger 
    Notes: Must be a procedure, since it calls db connect which has input
           blocking statements. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectType AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk         AS LOGICAL    NO-UNDO INIT TRUE.

  DEFINE VARIABLE lReset AS LOGICAL      NO-UNDO.

  IF NUM-DBS = 0 
  AND pcObjectType <> 'DataView':U THEN
  DO:
    lReset = TRUE.
    RUN adecomm/_dbcnnct.p (
      INPUT "You must have at least one connected database to be able to use a " 
            + pcObjectType + " as data definition source. ~n",
      OUTPUT lReset).
    IF lReset EQ NO THEN
      plOk = FALSE.
  END.
  IF plOk THEN
     plOk = resetDataSource('').
  
  IF plOk THEN
  DO WITH FRAME {&FRAME-NAME}:
    resetObjectType(pcObjectType).
    Data_object = ''.
    DISPLAY data_object.
  END.

END PROCEDURE .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose: Fires when next or back button is pressed
           does error checking on next.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lok          AS LOG       NO-UNDO.
  DEFINE VARIABLE cSDOType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE LastButton AS CHARACTER NO-UNDO.
  
  LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).
   
  IF LastButton = "CANCEL" THEN RETURN.
   
  RUN adecomm/_setcurs.p("WAIT":U).
 
  ASSIGN FRAME {&FRAME-NAME} Data_Object.   
 
  IF LastButton = "NEXT":U THEN 
  DO:

    IF Data_Object = "":U THEN
    DO:  
      MESSAGE 'You need to supply the name of a data definition source.':U 
         view-as alert-box information. 
      
      RETURN ERROR.    
    END.
 
    IF NOT VALID-HANDLE(gDOhdl) THEN
    DO:
      IF cObjectType = 'DataView':U AND Data_Object <> "":U THEN
      DO:  
        IF SEARCH(Data_Object) <> ? THEN
        DO:
          COMPILE VALUE(Data_Object) NO-ERROR. 
          IF COMPILER:ERROR THEN
          DO:
            MESSAGE 
/*               Data_object "include cannot be used as data definition source" */
/*               "as it has a syntax error:"                                    */
/*                 SKIP(1)                                                      */
              ERROR-STATUS:GET-MESSAGE(1) SKIP
              ERROR-STATUS:GET-MESSAGE(2)
              VIEW-AS ALERT-BOX 
                ERROR. 

             RETURN ERROR.    
          END.
        END.
      END.

      MESSAGE 
        Data_object "is not a valid data definition source." SKIP
        "Select a DataObject or an include file with TEMP-TABLE and PRODATASET definitions."  
         view-as alert-box information. 
       RETURN ERROR.
    END.
    ELSE DO:
      IF cObjectType = 'DataView':U 
      AND cDataTable = "":U OR cDataTable = ? THEN
      DO:  

        MESSAGE 'You need to select a DataTable.':U 
            view-as alert-box information. 
      
        RETURN ERROR.    
      END.

      {get ObjectType cSDOType gDOHdl}.
      IF LOOKUP(cSDOType,'SmartDataObject,SmartBusinessObject') = 0 THEN
      DO:
        MESSAGE 
          Data_object "is a " cObjectType "and cannot be used as definition source." skip
         "Select a DataObject or an include file with TEMP-TABLE and/or PRODATASET definitions."  
          view-as alert-box information. 
        RETURN ERROR.
      END.
    END.
  
     /* Repository has presedence in get-sdo-hdl and the data object has already 
       been launched from there if it exists, so check if the data object 
       is in in repository and inform the user. */ 
    IF NOT lFromRepos AND glDynamicsIsRunning AND cObjectType <> 'Dataview' THEN
    DO:
      IF isRepositoryObject(Data_object) THEN 
      DO:
        /* the prev logic in the message is not used since we are inside
          'if next' .. because PREV cannot be interupted */
        lok = TRUE.
        MESSAGE 
            Data_object "exists in Repository and will be started from there"
            + (IF LastButton = "NEXT":U
               THEN " on subsequent pages as well as in the AppBuilder."
               ELSE " when returning to this page.")
            SKIP 
            "Confirm ok to continue."
            VIEW-AS ALERT-BOX BUTTONS OK-CANCEL UPDATE lok.
        IF NOT lok THEN 
           RETURN ERROR.
        ELSE DO:
          resetFromRepository(TRUE).
          /* restart so storeDataObjectList can store data */
          IF LastButton = "NEXT":U THEN
            IF NOT resetDataSource(Data_object) THEN
              RETURN ERROR.
        END.
      END.   
    END.
  END. /* if lastbutton = next */
 
  /* store and check */
  IF storeDataObjectList(LastButton = 'NEXT':U) = FALSE THEN
    RETURN ERROR .

  /* 
  Store even if we are going back in order to have what we entered
  if we come back to this page
  */   

  RUN adeuib/_setwatr.w(INTEGER(proc-recid), 
                        "DataObject", 
                        Data_Object
                        + (IF cObjectType = 'DataView' THEN
                           ',' + cDataTable
                           ELSE ''), 
                        OUTPUT lok).
  
  RUN adecomm/_setcurs.p("":U). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitialFileName C-Win 
FUNCTION getInitialFileName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: call back for the object browse for initial filtering  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN Data_object:SCREEN-VALUE  IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter C-Win 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Call back to filter object type in the repository browse 
    Notes: This is not automatic, but relies on the window handle's  
           private-data being marked with this-procedure handle before being 
           passed to the gopendialog.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList2 AS CHARACTER  NO-UNDO.

  IF cObjectType = 'SmartDataObject' THEN
  DO:
     /* don't include the base Data class */
    ASSIGN
      cList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                              "SDO":U)
      cList2 = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                              "DynSDO":U)
      cList = cList
            + (IF cList <> '' AND cList2 <> '' THEN ',' ELSE '')
            +  cList2.
  END.
  
  ELSE DO: /* The SBO is parent class of dynSBO,  */
    cList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                             "SBO":U).
  END.

  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObject C-Win 
FUNCTION initDataObject RETURNS LOGICAL
  (pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: start the dataobject and initialize the screen depending 
           of objectType and contents.     
    Notes: For SBOs we create fill-ins to display the Objects within and 
           check boxes so the user can select whether to display or update
           the objects from this visual object.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUpd       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisp      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneTOOne  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cSDO       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOSelect AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMaster    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSingle    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataset   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRun       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExists    AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    
    IF lFromRepos AND cObjectType <> 'DataView':U THEN
      lExists = isRepositoryObject(pcName). 
    ELSE 
      lExists = SEARCH(pcName) <> ?.
    
    /* All sdos are shut down at end by main wizard, so we just make the handle 
       invalid without any clean up here */    
    IF NOT lExists THEN
       gDOHdl = ?.

    ELSE DO:
      cRun = pcName.
      
      IF cObjectType = 'DataView':U  THEN
        cRun = cRun + ',' + cDataTable.

      RUN getSDOhandle IN gWizardHdl (cRun, OUTPUT gDOHdl).
    END.

    /* Only viewers supports SBOs, so disable otherwise */ 
    IF NOT (objType MATCHES "*viewer*":U) THEN
       cObjectType:DISABLE('SmartBusinessObject':U). 
    

    /* check and set dataobject Object type  
       Dataview (include file) is handled from stored dataobject 
       format in main block and is not set from running object  */
    IF cObjectType <> 'DataView':U  THEN
    DO:
      /* Set radioset to the objectType */
      IF NUM-DBS = 0 THEN
        ASSIGN
          cObjectType:SCREEN-VALUE = 'DataView':U
          cObjectType.
      /* This handles pick of SDO when SBO selected
         and vice versa and also ensures the otype is kept 
         when paging back and forth. 
         */
      ELSE 
        ASSIGN
          cObjectType:SCREEN-VALUE = {fn getObjectType gDOHdl} 
          cObjectType   NO-ERROR.
    END.

    /* If SBO prpeare the 'toogle list'  */
    IF cObjectType = 'SmartBusinessObject':U THEN
    DO:
      hSDOSelect = initDataObjectList().
      IF VALID-HANDLE(gDOHdl) THEN
      DO:
        {get MasterDataObject hMaster gDOHdl}.
        /* 2nd toggle can only have one checked object if not one-to-one*/ 
        lSingle = NOT {fn hasOneToOneTarget hMaster}.
        {fnarg setSecondSingleOnly lSingle hSDOSelect}.

        ASSIGN
          cDisp    = getDataSourceNames()
          cUpd     = getUpdateTargetNames()
          cSDOlist = {fn getDataObjectNames gDOHdl}.
        IF cDisp = ? THEN
          cDisp = ''.
        IF cUpd = ? THEN
          cUpd = ''.
        DO i = 1 TO NUM-ENTRIES(cSDOlist):
          cSDO = ENTRY(i,cSDOlist).
          DYNAMIC-FUNCTION('addItem':U IN hSDOSelect,
                                          cSDO,
                                          LOOKUP(cSDO,cDisp),
                                          LOOKUP(cSDO,cUpd)).
        END.
        {fn viewItems hSDOSelect}.
      END.
    END.
    ELSE /* not SBO..  */ 
      removeDataObjectList().

    IF cObjectType = 'DataView':U THEN
    DO:
      cDataTable:SENSITIVE = TRUE.
      cDataTable:HIDDEN = FALSE.
      /* this views and displays the label */ 
      DISPLAY cIncludeLabel WITH FRAME {&FRAME-NAME}.        
      IF VALID-HANDLE(gDOHdl) THEN
      DO:
        {get DatasetSource hDataset gDOHdl}.
        {get DataTable cTable gDOHdl}.
        IF VALID-HANDLE(hDataSet) THEN
        DO:
          {get DataTables cTableList hDataSet}.
           cDataTable:LIST-ITEMS = cTableList.
        END.
        ELSE DO:
          cDataTable:LIST-ITEMS = cTable.
        END.
        IF cTable > '' THEN
          ASSIGN 
            cDataTable:SCREEN-VALUE  = cTable
            cDataTable.
      END.
      ELSE 
        ASSIGN
          cDataTable = ''
          cDataTable:LIST-ITEMS = ''.
    END.
    ELSE 
      ASSIGN
        cDataTable = ''
        cDataTable:HIDDEN = TRUE
        cIncludeLabel:HIDDEN = TRUE.
  END.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObjectList C-Win 
FUNCTION initDataObjectList RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: View and/or clear the widgets used to update dataobjects for an sbo 
   Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
  DEFINE VARIABLE deHeight AS DECIMAL    NO-UNDO.

  DISPLAY cSBOLabel WITH FRAME {&FRAME-NAME}.
  
  IF NOT VALID-HANDLE(ghSDOSelect)  THEN
  DO:
    RUN adm2/support/toggleframe.w PERSISTENT SET ghSDOSelect.

    {fnarg setRow 7.14 ghSDOSelect}.
    {fnarg setCol 2 ghSDOSelect}.
     hFrame = FRAME {&FRAME-NAME}:HANDLE.
     {fnarg setFrame hframe ghSDOSelect}.
     deHeight = b_Helpq:ROW + b_Helpq:HEIGHT - 7.14.
     {fnarg setHeight deHeight ghSDOSelect}.
     {fnarg setWidth 54 ghSDOSelect}.
     {fnarg setTextWidth 24 ghSDOSelect}.
     {fnarg set3D TRUE  ghSDOSelect}.
     {fnarg setFirstLabel 'Display':U ghSDOSelect}.
     {fnarg setSecondLabel 'Enable':U ghSDOSelect}.
     RUN initializeObject IN ghSDOSelect.  
  END.
  ELSE 
    {fn deleteItems ghSDOSelect}. 

  RETURN ghSDOSelect.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isRepositoryObject C-Win 
FUNCTION isRepositoryObject RETURNS LOGICAL
  ( pcObject AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRepDesignManager AS HANDLE NO-UNDO.
  /* objectexists resolves pathed names, but we are working with logical
     names  */
  IF INDEX(REPLACE(pcObject,'~\','~/'),'~/') = 0 THEN
  DO:
    hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
    IF VALID-HANDLE(hRepDesignManager) THEN
      RETURN DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager, pcObject).
  END.

  RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeDataObjectList C-Win 
FUNCTION removeDataObjectList RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghSDOSelect)  THEN
    RUN destroyObject IN ghSDOSelect.
  cSBOLabel:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeObjectsFromList C-Win 
FUNCTION removeObjectsFromList RETURNS LOGICAL
  (pcObjectList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Remove deselected objects fom shared fld-list  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFld      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewList  AS CHARACTER  NO-UNDO.
    
  DO i = 1 TO NUM-ENTRIES(fld-list):
    cFld = ENTRY(i,fld-list).
    /* Build new list for objects not passed in */
    IF LOOKUP(ENTRY(1,cFld,'.':U),pcObjectList) = 0 THEN
    DO:
      cNewList = cNewList 
                 + (IF cNewList <> '':U THEN ',':U ELSE '':U)
                 + cFld.
    END.
  END.
  
  fld-list = cNewList.

  IF fld-list = '':U THEN
     APPLY "U2":U TO hWizard. /* not ok to finish */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetDataSource C-Win 
FUNCTION resetDataSource RETURNS LOGICAL
  ( pcDataObject AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Called from value-changed or choose to reset data when the datasource
           has changed 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAnswer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cExt    AS CHARACTER  NO-UNDO.

  IF FLd-list <> '' THEN
  DO:  
     lAnswer = YES.
     MESSAGE 
      'Confirm removal of all fields selected from current data source from the list.'
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE lAnswer.
     IF NOT lAnswer THEN
       RETURN FALSE.
  END.
  
  IF INDEX(pcDataobject,'.') > 0 THEN
    cExt = ENTRY(NUM-ENTRIES(pcDataObject,'.':U),pcDataObject,'.':U) NO-ERROR.
  IF cExt > '' THEN
  DO:
    IF cObjectType = 'DataView':U THEN 
    DO:
      IF LOOKUP(cExt ,'p,w':U) > 0 THEN
      DO:
        lanswer = yes.
        MESSAGE 
         "Do you want to run"  pcDataObject 
         " or do you want to parse it as an include file?"  SKIP(1)
         "Yes, this object is to be run." skip
         "No, this file is to be parsed"
         VIEW-AS ALERT-BOX question BUTTONS yes-no update lanswer.
        IF lanswer THEN
          resetObjectType('SmartDataObject').
      END.
      IF LOOKUP(cExt ,'r':U) > 0 THEN
        /* will be fixed to sbo after run if necessary */
        resetObjectType('SmartDataObject').
    END.
    ELSE DO:
      IF LOOKUP(cExt ,'i':U) > 0 THEN
      DO:
        lanswer = yes.
        MESSAGE 
         "Do you want to parse" pcDataObject "as an include file"
         "or do you want run it?" SKIP(1)
         "Yes, this file is to be parsed." SKIP
         "No, this object is to be run." skip  
        VIEW-AS ALERT-BOX question BUTTONS yes-no update lanswer.
        IF lanswer THEN
          resetObjectType('DataView':U).
      END.
    END.
  END.
  Data_object = pcDataObject.
  DISPLAY Data_object WITH FRAME {&FRAME-NAME}.
  Fld-list = '':U.
  setDataSourceNames(?).
  setUpdateTargetNames(?).
  initDataObject(pcDataObject).
  APPLY "U2":U TO hWizard. /* not ok to finish */
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetFromRepository C-Win 
FUNCTION resetFromRepository RETURNS LOGICAL
  ( plFromRepository AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
   lFromRepos = plFromRepository.
   lFromRepos:SENSITIVE = TRUE.
   lFromRepos:SCREEN-VALUE = STRING(lFromRepos).
   /* prepare screen with dynamics repos lookup */
   IF plFromRepository THEN
   DO:
     btnRepos:SENSITIVE = TRUE.
     btnRepos:HIDDEN = FALSE.    
     btnBrws:HIDDEN = TRUE.    
     Data_Object:WIDTH-P = btnRepos:X - Data_Object:X - xiHormargin. 
   END.
    /* else prepare screen with browse button */
   ELSE DO:
     btnBrws:SENSITIVE = TRUE.
     btnBrws:HIDDEN = FALSE.    
     btnRepos:HIDDEN = TRUE.    
     Data_Object:WIDTH-P = btnBrws:X - Data_Object:X - xiHormargin. 
   END.
 END.

 RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetObjectType C-Win 
FUNCTION resetObjectType RETURNS LOGICAL
  ( pcObjectType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTrueLabel AS CHARACTER  NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    
    cTrueLabel = ENTRY(LOOKUP('yes':U,lFromRepos:RADIO-BUTTONS) - 1,lFromRepos:RADIO-BUTTONS).
    ASSIGN cObjectType = pcObjectType.
    DISPLAY cObjectType.
    IF pcObjectType = 'DataView':U THEN
    DO:
      lFromRepos:DISABLE(cTrueLabel).
      resetFromRepository(FALSE).
    END.
    ELSE
      lFromRepos:ENABLE(cTrueLabel).
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeDataObjectList C-Win 
FUNCTION storeDataObjectList RETURNS LOGICAL
  ( plCheck AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Store and check data for dataobject links 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDisp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRemoved AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUpd     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDO     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAnswer  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
  
  CASE cObjectType:
    WHEN 'SmartDataObject':U THEN
      ASSIGN 
        cOldDisp = Data_Object
        cDisp    = Data_Object.

    WHEN 'SmartBusinessObject':U THEN
    DO:
      ASSIGN 
        cOldDisp = getDataSourceNames()
        cUpd     = {fn getSecondItems ghSDOSelect}
        cDisp    = {fn getFirstItems ghSDOSelect}
        lSBO     = TRUE.
      IF plCheck THEN 
      DO:
        IF cDisp = '':U  THEN
        DO:
          MESSAGE "At least one DataObject must be checked as the Display Data Source."
          VIEW-AS ALERT-BOX  INFORMATION.
          RETURN FALSE.
        END.
      END.
    END. /* WHEN 'SmartBusinessObject':U */    
    WHEN 'DataView':U THEN
    DO: 
      IF plCheck AND cDataTable = '':U THEN
      DO:
        MESSAGE 
          "A DataTable must be selected from the list. "
        VIEW-AS ALERT-BOX  INFORMATION.
        RETURN FALSE.
      END.
      
      IF VALID-HANDLE(gDOHdl) THEN
      DO:
        IF cDataTable <> {fn getDataTable gDOHdl} THEN
        DO:
          cOldDisp = {fn getViewTables gDOHdl}.
          RUN getSDOhandle IN gWizardHdl (Data_object + ',' + cDataTable, 
                                          OUTPUT gDOHdl).
          cDisp = {fn getViewTables gDOHdl}.
        END.
      END.

    END. /* WHEN 'DataView':U */
  END CASE. /* cObjectType */

  IF cOldDisp <> cDisp THEN
  DO:
    DO i = 1 TO NUM-ENTRIES(cOldDisp):
      cSDO = ENTRY(i,cOlddisp).
      IF LOOKUP(cSDO,cdisp) = 0 
      AND INDEX("," + fld-list,"," + cSDo + '.':U) > 0 THEN
        cRemoved = cRemoved 
                 + (IF cRemoved = "" THEN "" ELSE ",") 
                 + cSDO.
    END.
    IF cRemoved <> '':U THEN
    DO:
      lanswer = YES. 
      MESSAGE 
             "There are fields from "
             
             + REPLACE(cRemoved,",":U,' and ') 
             + " in the list of selected fields." SKIP(1) 
             'Confirm removal of these fields from the list.' 
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE lAnswer.
      IF lAnswer THEN
         removeObjectsFromList(cRemoved).
      ELSE
       RETURN FALSE.
    END.
  END.

  setUpdateTargetNames(IF lSBO THEN cUpd ELSE ?).
  setDataSourceNames(IF lSBO THEN cDisp ELSE ?).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

