&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*---------------------------------------------------------------------------------
  File: rysttdilgd.w

  Description:  

  Purpose:

  Parameters:  ph_WIndow

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/13/2003  Author:     

  Update Notes: Created from Template rysttdilgd.w

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

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _propsbo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT PARAMETER phWindow  AS HANDLE   NO-UNDO.
&ELSE
DEFINE VARIABLE phWIndow AS HANDLE  NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/sharvars.i}             /* The shared variables                     */
{src/adm2/globals.i}            /* Global vars for Dynamics */
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnLkup btnsearch buOk buCancel btnClear 
&Scoped-Define DISPLAYED-OBJECTS fiObject fiDLP 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter diDialog 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSBOProperty diDialog 
FUNCTION setSBOProperty RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnClear 
     IMAGE-UP FILE "src/adeicon/del-au.bmp":U NO-FOCUS
     LABEL "Clear" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14 TOOLTIP "Clear data logic procedure".

DEFINE BUTTON btnLkup  NO-FOCUS
     LABEL "Lookup" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14 TOOLTIP "Lookup data logic procedure in repository".

DEFINE BUTTON btnsearch 
     IMAGE-UP FILE "src/adeicon/open.bmp":U NO-FOCUS
     LABEL "Search" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14 TOOLTIP "Search for data logic procedure".

DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buOk AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiDLP AS CHARACTER FORMAT "X(200)":U 
     LABEL "DLP" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 TOOLTIP "Data Logic Procedure" NO-UNDO.

DEFINE VARIABLE fiObject AS CHARACTER FORMAT "X(20)":U 
     LABEL "Object Type" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 48.8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     btnLkup AT ROW 2.67 COL 64
     fiObject AT ROW 1.48 COL 13 COLON-ALIGNED
     btnsearch AT ROW 2.67 COL 69
     fiDLP AT ROW 2.67 COL 13 COLON-ALIGNED
     buOk AT ROW 4.57 COL 24
     buCancel AT ROW 4.57 COL 41.4
     btnClear AT ROW 2.67 COL 74
     SPACE(1.79) SKIP(2.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Property Sheet - SmartBusinessObject"
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB diDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX diDialog
                                                                        */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiDLP IN FRAME diDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiObject IN FRAME diDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Property Sheet - SmartBusinessObject */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClear diDialog
ON CHOOSE OF btnClear IN FRAME diDialog /* Clear */
DO:
  ASSIGN
     fiDLP:SCREEN-VALUE = ""
     fiDLP:MODIFIED     = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLkup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLkup diDialog
ON CHOOSE OF btnLkup IN FRAME diDialog /* Lookup */
DO:
  RUN dataLookup IN THIS-PROCEDURE ("Dynamics":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnsearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnsearch diDialog
ON CHOOSE OF btnsearch IN FRAME diDialog /* Search */
DO:
  RUN dataLookup IN THIS-PROCEDURE ("System":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* OK */
DO:
  setSBOProperty().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects diDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataLookup diDialog 
PROCEDURE dataLookup :
/* ***********************************************************
   Purpose: Lookup dialog call for Dynamics data logic 
            procedure when the lookup button is choosen
*************************************************************/
 DEFINE INPUT  PARAMETER pcType AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cFilename             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK                   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cPathedFilename       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRepDesManager        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cCalcRelativePath     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRootDir          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRelPathSCM       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFullPath         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcObject           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFile             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcError            AS CHARACTER  NO-UNDO.


 ASSIGN CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 IF pcType= "Dynamics":U AND _DynamicsIsRunning THEN
 DO:
   RUN adecomm/_setcurs.p ("WAIT":U).
   RUN ry/obj/gopendialog.w (INPUT CURRENT-WINDOW,
                             INPUT "",
                             INPUT No,
                             INPUT "Get Object",
                             OUTPUT cFilename,
                             OUTPUT lok).
   RUN adecomm/_setcurs.p ("":U).
   IF lOK THEN
   DO:
      hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
      /* Retrieve the objects for the specified object */
      RUN retrieveDesignObject IN hRepDesManager ( INPUT  cFilename,
                                                   INPUT  "",  /* Get default result Code */
                                                   OUTPUT TABLE ttObject ,
                                                   OUTPUT TABLE ttPage,
                                                   OUTPUT TABLE ttLink,
                                                   OUTPUT TABLE ttUiEvent,
                                                   OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
      FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cFilename 
                            AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
      IF AVAIL ttObject THEN
      DO:
         /* Get relative directory of specified object */ 
         RUN calculateObjectPaths IN gshRepositoryManager
                            (cFilename,  /* ObjectName */          0.0, /* Object Obj */      
                             "",  /* Object Type */         "",  /* Product Module Code */
                             "", /* Param */                "",
                             OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                             OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                             OUTPUT cCalcObject,            OUTPUT cCalcFile,
                             OUTPUT cCalcError).
         IF cCalcRelPathSCM > "" THEN
            cCalcRelativePath = cCalcRelPathSCM.
         ASSIGN cPathedFilename = cCalcRelativePath + (IF cCalcRelativePath = "" then "" ELSE "/":U )
                                                    + cCalcFile .
         
         IF (_P.static_object = NO AND DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassName, "DLProc":U))
             OR (_P.static_object = YES AND (DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassName, "Procedure":U)
                                         OR  DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassName, "DLProc":U)))
         THEN ASSIGN  fiDLP:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = cPathedFilename
                      fiDLP:MODIFIED       = YES
                      fiDLP:TOOLTIP = "Data Logic Procedure: " + fiDLP:SCREEN-VALUE.
      END.
   END.
 END.
 ELSE DO:
    ASSIGN cFileName = TRIM(fiDLP:SCREEN-VALUE).
  
    RUN adecomm/_opnfile.w 
                ("Choose a logic procedure",
                 "Logic Files (*.p), All Files (*.*)",
                 INPUT-OUTPUT cFileName).
  
    IF cFileName <> "":U THEN
      ASSIGN  fiDLP:SCREEN-VALUE = REPLACE(cFileName,"~\","/")
              fiDLP:MODIFIED = YES
              fiDLP:TOOLTIP = "Data Logic Procedure: " + fiDLP:SCREEN-VALUE.
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI diDialog  _DEFAULT-DISABLE
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
  HIDE FRAME diDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI diDialog  _DEFAULT-ENABLE
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
  DISPLAY fiObject fiDLP 
      WITH FRAME diDialog.
  ENABLE btnLkup btnsearch buOk buCancel btnClear 
      WITH FRAME diDialog.
  VIEW FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject diDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataLogicProc AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF _DynamicsIsRunning THEN
     btnLkup:LOAD-IMAGE("ry/img/afbinos.gif":U) IN FRAME {&FRAME-NAME} NO-ERROR.
  ELSE
     ASSIGN btnLkup:VISIBLE = FALSE
            btnSearch:COL   = fiDLP:COL + FiDLP:WIDTH
            btnClear:COL    = btnSearch:COL + btnSearch:WIDTH.


  FIND _U WHERE _U._HANDLE = phWindow NO-ERROR.
  IF AVAIL _U THEN DO:
    FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
    FIND _C WHERE RECID(_C)  = _U._x-recid NO-ERROR.
  END.
  IF AVAIL _P THEN
     ASSIGN fiObject = IF _P.OBJECT_type_code > "" 
                       THEN _P.object_type_code ELSE _P._TYPE.

   IF AVAIL _C AND _C._DATA-LOGIC-PROC <> ? AND _C._DATA-LOGIC-PROC <> "" THEN
   DO:
       RUN adecomm/_relname.p (_C._DATA-LOGIC-PROC, "",OUTPUT cDataLogicProc).
       ASSIGN fiDLP         = cDataLogicProc
              fiDLP:TOOLTIP = "Data Logic Procedure: " + cDataLogicProc.
   END.
   

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter diDialog 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF _DynamicsIsRunning THEN
  RETURN REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                 INPUT "Procedure,DLProc":U),CHR(3),",":U).
  
RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSBOProperty diDialog 
FUNCTION setSBOProperty RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
    IF AVAIL _C AND fiDLP:MODIFIED IN FRAME {&FRAME-NAME} THEN
       ASSIGN _C._DATA-LOGIC-PROC = fiDLP:SCREEN-VALUE.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

