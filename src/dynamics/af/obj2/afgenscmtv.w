&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: afgenscmtv.w

  Description:  Object Generator SCM Viewer

  Purpose:      Object Generator SCM Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/10/2002  Author:     Peter Judge

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:          18   UserRef:    
                Date:   02/15/2003  Author:     Thomas Hansen

  Update Notes: Issue 8579:
                Extended reference to RTB include files to be :
                scm/rtb/inc/ryrtbproch.i
                
                Removed dependency on RTB variables.

--------------------------------------------------------------------------------*/
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

&scop object-name       afgenscmtv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource           AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiWorkSpace fiTaskNumber fiWorkSpaceRoot ~
fiLogicGroup fiLogicSubtype ToLogicOverwrite fiDLProcLabel RECT-8 
&Scoped-Define DISPLAYED-OBJECTS fiWorkSpace fiTaskNumber fiWorkSpaceRoot ~
fiLogicGroup fiLogicSubtype ToLogicOverwrite fiDLProcLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiDLProcLabel AS CHARACTER FORMAT "X(100)":U INITIAL "DataLogic procedure" 
      VIEW-AS TEXT 
     SIZE 34.4 BY .62 NO-UNDO.

DEFINE VARIABLE fiLogicGroup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Group" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 TOOLTIP "Specify SDO Logic Procedure Group (usually same as subtype)" NO-UNDO.

DEFINE VARIABLE fiLogicSubtype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Subtype" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 TOOLTIP "Specify SDO Logic Procedure subtype, e.g. DLProc" NO-UNDO.

DEFINE VARIABLE fiTaskNumber AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Task" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 TOOLTIP "Current selected task number in SCM" NO-UNDO.

DEFINE VARIABLE fiWorkSpace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 TOOLTIP "Name of current SCM workspace selected" NO-UNDO.

DEFINE VARIABLE fiWorkSpaceRoot AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace root" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "Root directory for current SCM workspace selected" NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.8 BY 3.81.

DEFINE VARIABLE ToLogicOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwite logic in task" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 TOOLTIP "If SDO Logic is found checked-out in the selected task, it will be overwritten" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiWorkSpace AT ROW 1.05 COL 21.4 COLON-ALIGNED
     fiTaskNumber AT ROW 2.14 COL 21.2 COLON-ALIGNED
     fiWorkSpaceRoot AT ROW 3.24 COL 21 COLON-ALIGNED
     fiLogicGroup AT ROW 5.29 COL 21 COLON-ALIGNED
     fiLogicSubtype AT ROW 6.33 COL 21 COLON-ALIGNED
     ToLogicOverwrite AT ROW 7.38 COL 23
     fiDLProcLabel AT ROW 4.43 COL 5.4 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 4.62 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Compile into: af/obj2
   Allow: Basic
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 10
         WIDTH              = 84.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       fiLogicGroup:PRIVATE-DATA IN FRAME frMain     = 
                "DLP-GROUP".

ASSIGN 
       fiLogicSubtype:PRIVATE-DATA IN FRAME frMain     = 
                "DLP-SUBTYPE".

ASSIGN 
       fiTaskNumber:READ-ONLY IN FRAME frMain        = TRUE
       fiTaskNumber:PRIVATE-DATA IN FRAME frMain     = 
                "TASK".

ASSIGN 
       fiWorkSpace:READ-ONLY IN FRAME frMain        = TRUE
       fiWorkSpace:PRIVATE-DATA IN FRAME frMain     = 
                "WORKSPACE".

ASSIGN 
       fiWorkSpaceRoot:READ-ONLY IN FRAME frMain        = TRUE
       fiWorkSpaceRoot:PRIVATE-DATA IN FRAME frMain     = 
                "WORKSPACEROOT".

ASSIGN 
       ToLogicOverwrite:PRIVATE-DATA IN FRAME frMain     = 
                "DLP-OVERWRITE-IN-TASK".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSCMFrame sObject 
PROCEDURE getSCMFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER phFrame             AS HANDLE               NO-UNDO.

  ASSIGN
    phFrame = FRAME {&FRAME-NAME}:HANDLE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN
      fiDlProcLabel:SCREEN-VALUE    = " DataLogic Procedure "
      fiDlProcLabel:WIDTH-CHARS     = FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiDlProcLabel:SCREEN-VALUE, fiDlProcLabel:FONT) + 0.5
      fiWorkspace:SCREEN-VALUE      = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "_scm_current_workspace":U)
      fiTaskNumber:SCREEN-VALUE     = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "_scm_current_task_number":U)
      fiWorkspaceRoot:SCREEN-VALUE  = DYNAMIC-FUNCTION('getComponentRootDirectory' IN THIS-PROCEDURE, "SCM":U) 
      fiLogicGroup:SCREEN-VALUE     = "DLProc":U
      fiLogicSubtype:SCREEN-VALUE   = "DLProc":U
      .
  END.    /* with frame ... */

  SUBSCRIBE TO "getSCMFrame":U IN ghContainerSource.

  RETURN.

END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

    RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

    /* Set the handle of the container source immediately upon making the link */
    IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
        ASSIGN ghContainerSource = phObject.

    RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

