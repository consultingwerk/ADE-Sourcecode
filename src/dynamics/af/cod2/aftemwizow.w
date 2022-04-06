&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"SDO Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
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
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */
{destdefi.i}             /*  Contains definitions for dynamics design-time temp-tables. */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE objtype    AS CHARACTER NO-UNDO.
DEFINE VARIABLE obj-recid  AS CHARACTER NO-UNDO.
DEFINE VARIABLE proc-recid AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-status   AS LOGICAL   NO-UNDO.

DEFINE Variable gWizardHdl AS HANDLE  NO-UNDO.
/* 
palette item to use when browsing for SmartDataObject.  
Current .cst implementation makes this hardcoding necessary 
*/ 
DEFINE VARIABLE xSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.
DEFINE VARIABLE h_dynLookup      AS HANDLE  NO-UNDO.
DEFINE VARIABLE gcDataObject     AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SimpleObject
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buSDO e_msg ToBoxRep fiDynSDO ToBoxStatic ~
b_brws fiStaticSDO b_Helpq RECT-3 
&Scoped-Define DISPLAYED-OBJECTS e_msg ToBoxRep fiDynSDO ToBoxStatic ~
fiStaticSDO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitialFileName C-Win 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter C-Win 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buSDO 
     IMAGE-UP FILE "ry/img/afbinos.gif":U NO-FOCUS
     LABEL "" 
     SIZE 5 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON b_brws 
     LABEL "B&rowse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Helpq 
     LABEL "&Help on DataObject" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 34 BY 5.95
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiDynSDO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiStaticSDO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61.2 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 5.91.

DEFINE VARIABLE ToBoxRep AS LOGICAL INITIAL yes 
     LABEL "Repository data source" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE ToBoxStatic AS LOGICAL INITIAL no 
     LABEL "Static data source" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buSDO AT ROW 3.14 COL 75 NO-TAB-STOP 
     e_msg AT ROW 1.48 COL 82 NO-LABEL
     ToBoxRep AT ROW 2.19 COL 4
     fiDynSDO AT ROW 3.14 COL 1.8 COLON-ALIGNED NO-LABEL
     ToBoxStatic AT ROW 4.86 COL 4
     b_brws AT ROW 5.76 COL 65
     fiStaticSDO AT ROW 5.81 COL 3.8 NO-LABEL
     b_Helpq AT ROW 9.33 COL 87
     RECT-3 AT ROW 1.52 COL 2
     "Data Source filename" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 1.24 COL 3.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 125.6 BY 11.81
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SimpleObject
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Smart,Window
   Container Links: 
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.76
         WIDTH              = 116.2
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 133.8
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 133.8
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fiStaticSDO IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME buSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSDO C-Win
ON CHOOSE OF buSDO IN FRAME DEFAULT-FRAME
DO:
 DEFINE VARIABLE cFilename AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

 ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 
 RUN ry/obj/gopendialog.w (INPUT {&WINDOW-NAME},
                           INPUT "",
                           INPUT No,
                           INPUT "Get Object",
                           OUTPUT cFilename,
                           OUTPUT lok).
 IF lOK THEN
    ASSIGN fiDynSDO:SCREEN-VALUE = cFilename.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_brws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_brws C-Win
ON CHOOSE OF b_brws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DEFINE VARIABLE lOk                     AS   LOGICAL                NO-UNDO.
  DEFINE VARIABLE cRoot                   AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cFileName               AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cFilterNameString       AS   CHARACTER EXTENT 5     NO-UNDO.
  DEFINE VARIABLE cFilterFileSpec         LIKE cFilterNameString      NO-UNDO.
  DEFINE VARIABLE cFile                   AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cString                 AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE iLoop                   AS   INTEGER                NO-UNDO.
  DEFINE VARIABLE hHandle                 AS   HANDLE                 NO-UNDO.
  DEFINE VARIABLE oldfiStaticSDO          AS CHARACTER                NO-UNDO.  
  
  /* Initialize the file filters, for special cases. */
  ASSIGN  cFilterNameString[1] = "SDO Files(*o.w)"
          cFilterFileSpec[1] = "*o.w"
          cFilterNameString[2] = "All .w Files(*.w)"
          cFilterFileSpec[2] = "*.w"
          cFilterNameString[3] = "All Files(*.*)"
          cFilterFileSpec[3] = "*.*".

  /*  Ask for a file name */ 
  ASSIGN
    cFileName = fiStaticSDO:SCREEN-VALUE
    oldfiStaticSDO = fiStaticSDO:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cFileName
      TITLE    "Lookup SDO File"
      FILTERS  cFilterNameString[ 1 ]   cFilterFileSpec[ 1 ],
               cFilterNameString[ 2 ]   cFilterFileSpec[ 2 ],
               cFilterNameString[ 3 ]   cFilterFileSpec[ 3 ]
      MUST-EXIST
      UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

  cRoot = IF  REPLACE(cFileName,"~\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"~\":U,"/":U) THEN
            REPLACE(ENTRY(2,PROPATH),"~\":U,"/":U)
            ELSE REPLACE(ENTRY(1,PROPATH),"~\":U,"/":U).

  IF lOk THEN 
  DO:
     ASSIGN
          cFile                      = REPLACE(REPLACE(TRIM(LC(cFileName)),"~\":U,"/":U),cRoot + "/":U,"":U)
          fiStaticSDO:SCREEN-VALUE   = cFile
          fiStaticSDO:MODIFIED        = TRUE.

     IF oldfiStaticSDO <> fiStaticSDO:SCREEN-VALUE THEN
       APPLY "VALUE-CHANGED" TO fiStaticSDO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpq C-Win
ON CHOOSE OF b_Helpq IN FRAME DEFAULT-FRAME /* Help on DataObject */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Data_Object}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiStaticSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiStaticSDO C-Win
ON VALUE-CHANGED OF fiStaticSDO IN FRAME DEFAULT-FRAME
DO: 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fld-list = "":U.
    APPLY "U2":U TO hWizard. /* not ok to finish */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBoxRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxRep C-Win
ON VALUE-CHANGED OF ToBoxRep IN FRAME DEFAULT-FRAME /* Repository data source */
DO:
   IF NOT SELF:CHECKED THEN DO:
      ASSIGN SELF:CHECKED = TRUE.
      RETURN NO-APPLY.
   END.
   ELSE DO:
      ASSIGN ToBoxStatic:CHECKED       = NOT SELF:CHECKED
             fiStaticSDO:SCREEN-VALUE  = ""
             fiStaticSDO:SENSITIVE     = FALSE
             fiDynSDO:SENSITIVE        = TRUE
             b_brws:SENSITIVE          = FALSE.
   END.
   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBoxStatic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxStatic C-Win
ON VALUE-CHANGED OF ToBoxStatic IN FRAME DEFAULT-FRAME /* Static data source */
DO:
 IF NOT SELF:CHECKED THEN DO:
    ASSIGN SELF:CHECKED = TRUE.
    RETURN NO-APPLY.
 END.
 ELSE DO:
    ASSIGN ToBoxRep:CHECKED       = NOT SELF:CHECKED
            fiDynSDO:SCREEN-VALUE = ""
            fiDynSDO:SENSITIVE    = FALSE
            fiStaticSDO:SENSITIVE = TRUE
            b_brws:SENSITIVE      = TRUE.
 END.

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

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get procedure type (SmartViewer or SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT objtype).

/* If this SmartViewer or SmartBrowser already has a DataObject defined  */
/* then preset fiStaticSDO.                                              */
RUN adeuib/_uibinfo.p (INTEGER(proc-recid)," ","DataObject", OUTPUT gcDataObject).

/* Determine whether a Repository object has already been defined */
fiDynSDO = DYNAMIC-FUNCTION("getRepositorySDO" IN gWizardHdl, 
                             OUTPUT ToBoxRep).

ASSIGN e_msg = 
      "You need to specify the DataObject that will be the data source for this " +
      objtype + ".".
IF gcDataObject > "" THEN
  ASSIGN fiStaticSDO:TOOLTIP = SEARCH(fiStaticSDO) NO-ERROR.
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
  
  IF ToBoxRep THEN 
    ASSIGN  ToBoxRep:CHECKED      = TRUE
            ToBoxStatic:CHECKED   = FALSE
            fiStaticSDO:SENSITIVE = FALSE 
            b_brws:SENSITIVE      = FALSE.
  ELSE
    ASSIGN ToBoxRep:CHECKED         = FALSE
           ToBoxStatic:CHECKED      = TRUE
           fiStaticSDO:SCREEN-VALUE = gcDataObject
           fiDynSDO:SENSITIVE       = FALSE
           b_brws:SENSITIVE         = TRUE.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display-Query C-Win 
PROCEDURE Display-Query :
/*------------------------------------------------------------------------------
  Purpose:     Display 4GL query if any and sets button label.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY fiStaticSDO WITH FRAME {&FRAME-NAME}.
  END.    
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
  DISPLAY e_msg ToBoxRep fiDynSDO ToBoxStatic fiStaticSDO 
      WITH FRAME DEFAULT-FRAME.
  ENABLE buSDO e_msg ToBoxRep fiDynSDO ToBoxStatic b_brws fiStaticSDO b_Helpq 
         RECT-3 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.  

   DEFINE VARIABLE LastButton      AS CHARACTER NO-UNDO.
   
   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).

   IF LastButton = "CANCEL" THEN RETURN.

   RUN adecomm/_setcurs.p("WAIT":U).

   ASSIGN FRAME {&FRAME-NAME} fiStaticSDO.   
   
   /* Store the specified SDO and toggle/check-box settings so
      it returns those settings when paging back and forth */
   DYNAMIC-FUNCTION("setRepositorySDO" IN gWizardHdl, 
                    INPUT fiDynSDO:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                    INPUT ToBoxRep:CHECKED).
   IF LastButton = "NEXT":U THEN 
   DO: 
     IF ToBoxRep:CHECKED THEN DO:
        IF fiDynSDO:SCREEN-VALUE = "":U THEN
        DO:  
         MESSAGE 'You need to supply the name of an SDO in the repository.':U 
            VIEW-AS ALERT-BOX.

         RETURN ERROR.    
        END.
        RUN validateRepositorySDO IN THIS-PROCEDURE (OUTPUT cRelName).
        IF RETURN-VALUE = "ERROR":U THEN
           RETURN ERROR.
     END.
        
     ELSE DO:
       IF fiStaticSDO = "":U THEN
       DO:  
         MESSAGE 'You need to supply the name of a SmartDataObject.':U 
            VIEW-AS ALERT-BOX.

         RETURN ERROR.    
       END.

       RUN adecomm/_relfile.p (fiStaticSDO,
                               NO, /* Never check remote */
                              "Verbose":U, 
                               OUTPUT cRelName).
       
       IF cRelname = ? THEN RETURN ERROR.
       
     END.
  END. /* if lastbutton = next */

  /* 
  Store even if we are going back in order to have what we entered
  if we come back to this page
  */    
  
  IF cRelName > ""  THEN
     RUN adeuib/_setwatr.w(INTEGER(proc-recid), "DataObject", cRelName, OUTPUT ok).

  RUN adecomm/_setcurs.p("":U). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRepositorySDO C-Win 
PROCEDURE validateRepositorySDO :
/*------------------------------------------------------------------------------
  Purpose:     Validates whether the specified SDO is in-fact a valid 
               SDO in the repository
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcPathedFilename AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cCalcRelativePath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRootDir       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRelPathSCM    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFullPath      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcObject        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFile          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcError         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathedFilename    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesManager     AS HANDLE     NO-UNDO.

hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
/* Retrieve the selected associated DynSDO  */
RUN retrieveDesignObject IN hRepDesManager ( INPUT  fiDynSDO:SCREEN-VALUE in FRAME {&FRAME-NAME},
                                             INPUT  "",  /* Get default result Code */
                                             OUTPUT TABLE ttObject ,
                                             OUTPUT TABLE ttPage,
                                             OUTPUT TABLE ttLink,
                                             OUTPUT TABLE ttUiEvent,
                                             OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = fiDynSDO:SCREEN-VALUE 
                      AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
IF AVAIL ttObject THEN
DO:
   /* Get relative directory of specified object */ 
   RUN calculateObjectPaths IN gshRepositoryManager
                      (fiDynSDO:SCREEN-VALUE,  /* ObjectName */          0.0, /* Object Obj */      
                       "",                     /* Object Type */         "",  /* Product Module Code */
                       "",                    /* Param */                "",
                       OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                       OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                       OUTPUT cCalcObject,            OUTPUT cCalcFile,
                       OUTPUT cCalcError).
   IF cCalcRelPathSCM > "" THEN
      cCalcRelativePath = cCalcRelPathSCM.
   ASSIGN cPathedFilename = cCalcRelativePath + (IF cCalcRelativePath = "" then "" ELSE "/":U )
                                                + cCalcFile .
   IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "DynSDO":U) THEN
     pcPathedFileName = fiDynSDO:SCREEN-VALUE.
             /* Test For Static SDO */
   ELSE IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "SDO":U) THEN
      pcPathedFilename = cPathedFilename .
        /* Test dynSBO  */
   ELSE IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "DynSBO":U) THEN
      pcPathedFilename = fiDynSDO:SCREEN-VALUE.
        /* Test SBO ... Static */
   ELSE IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "SBO":U) THEN
      pcPathedFilename = cPathedFilename .
   
   DYNAMIC-FUNCTION("setRepositorySDO" IN gWizardHdl, 
                     INPUT fiDynSDO:SCREEN-VALUE,
                     INPUT ToBoxRep:CHECKED).   
END.
ELSE DO:
   MESSAGE "The object " + fiDynSDO:SCREEN-VALUE + " does not exist in the repository."
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   RETURN "ERROR".
END.

   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitialFileName C-Win 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To pass the file name entered to the Object browse for intial 
           Filtering. 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiDynSDO:SCREEN-VALUE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter C-Win 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Filters out specified object types in the Opne Object Dialog
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSDO    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDynSDO AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSBO    AS CHARACTER  NO-UNDO.

ASSIGN
  cSDO    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "SDO":U)
  cSDO    = IF cSDO = "" OR cSDO = "DynSDO":U THEN "SDO":U ELSE cSDO
  cDynSDO = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynSDO":U)
  cDynSDO = IF cDynSDO = "" OR cDynSDO = "SDO":U THEN "DynSDO":U ELSE cDynSDO
  cSBO    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "SBO":U).


RETURN cSDO + (IF cSDO = "" THEN "" ELSE ",") + cDynSDO
            + (IF cSBO = "" THEN "" ELSE ",") + cSBO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

