&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */ 
 
DEFINE VARIABLE xcADMDestroy AS CHARACTER  NO-UNDO  
              INIT 'adm2/*,*/custom/*,web2/*' .
  
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.
 
DEFINE VARIABLE hLaunchContainer AS HANDLE   NO-UNDO.
DEFINE VARIABLE glStop           AS LOGICAL.
DEFINE VARIABLE glStopped        AS LOGICAL    NO-UNDO.
DEFINE TEMP-TABLE ttRun 
  FIELD hdl        AS HANDLE
  FIELD ObjectName AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFile buRun ToPersistent toTreeView ~
ToClearCache ToDestroyAdm 
&Scoped-Define DISPLAYED-OBJECTS fiFile ToPersistent toTreeView ~
ToClearCache ToDestroyAdm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkAB wWin 
FUNCTION checkAB RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkADM wWin 
FUNCTION checkADM RETURNS CHARACTER
  (pcCheck AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyADM wWin 
FUNCTION destroyADM RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buRun 
     LABEL "&Run" 
     SIZE 14 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buStop 
     LABEL "&Stop" 
     SIZE 14 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)" INITIAL "rywizmencw" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Specify the dynamic container to launch".

DEFINE VARIABLE ToClearCache AS LOGICAL INITIAL no 
     LABEL "&Clear Cache" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToDestroyAdm AS LOGICAL INITIAL no 
     LABEL "&Destroy ADM Super Procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToPersistent AS LOGICAL INITIAL no 
     LABEL "Run &Persistent" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.4 BY .81 NO-UNDO.

DEFINE VARIABLE toTreeView AS LOGICAL INITIAL no 
     LABEL "&Tree View Container" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiFile AT ROW 2.05 COL 3 HELP
          "Enter the name of the dynamic container you wish to run" NO-LABEL
     buRun AT ROW 3.19 COL 39
     ToPersistent AT ROW 3.29 COL 3
     toTreeView AT ROW 4.14 COL 3
     buStop AT ROW 4.52 COL 39
     ToClearCache AT ROW 5 COL 3
     ToDestroyAdm AT ROW 5.91 COL 3
     "&Name of Container to Launch" VIEW-AS TEXT
          SIZE 29.2 BY .62 AT ROW 1.19 COL 3.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 52.2 BY 5.86
         DEFAULT-BUTTON buRun.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamic Launcher"
         HEIGHT             = 5.86
         WIDTH              = 52.4
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/smrtprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
/* SETTINGS FOR BUTTON buStop IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiFile IN FRAME fMain
   ALIGN-L                                                              */
ASSIGN 
       fiFile:PRIVATE-DATA IN FRAME fMain     = 
                "run-pgm".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Dynamic Launcher */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Dynamic Launcher */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fMain wWin
ON HELP OF FRAME fMain
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Dynamic_Launcher_Dialog_Box}  , "":U).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRun wWin
ON CHOOSE OF buRun IN FRAME fMain /* Run */
DO:
  RUN runContainer (INPUT fiFile:SCREEN-VALUE).

/*     RUN launchContainer (                                                                                      */
/*         INPUT 'ry/uib/rydyncontw.w':U,                                                                         */
/*         INPUT 'LogicalObjectName' + fiFile:SCREEN-VALUE + 'HideOnInitnoDisableOnInitnoObjectLayout':U). */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buStop wWin
ON CHOOSE OF buStop IN FRAME fMain /* Stop */
DO:
  IF glStop THEN STOP.
  ELSE RUN destroyPersistent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hOtherME AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

hOtherMe = SESSION:FIRST-PROCEDURE.
/* loop through the session and check if another kauncher is running.
   We only start one launcher. This shoould not be a problem as it 
   is able to launch as many persistent objects as one like and ity does
   not make sense to run several non-persistent objects. The ability to 
   destroy supers may also cause problems if several launchers were able 
   to run  */

DO WHILE VALID-HANDLE(hOtherMe):
  IF hOtherME:FILE-NAME = PROGRAM-NAME(1) AND hOtherMe <> THIS-PROCEDURE THEN
  DO:
    hWin = DYNAMIC-FUNCTION('getWindowHandle' IN hOtherMe).
    hWin:MOVE-TO-TOP().
    /* just in case we found a hidden one */ 
    VIEW hWin.
    /* or minimized one (max is disabled) */
    hWin:WINDOW-STATE = window-normal.
    APPLY "ENTRY":U TO hWin.
    
    /* Commit suicide */
    RUN DISABLE_ui.   
    RETURN.
  END.
  hOtherMe = hOtherMe:NEXT-SIBLING. 
END.
 
ON ALT-N OF FRAME {&FRAME-NAME} ANYWHERE DO:
  APPLY "ENTRY" TO fifile IN FRAME {&FRAME-NAME}.
END.

/* Include custom  Main Block code for SmartWindows. */
ON CLOSE OF THIS-PROCEDURE 
DO:
  RUN destroyObject IN THIS-PROCEDURE.
  IF ERROR-STATUS:ERROR THEN
     RETURN NO-APPLY.
END.

toClearCache = TRUE.
toPersistent = TRUE.

RUN ENABLE_UI.
APPLY 'ENTRY' TO fifile IN FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeObject wWin 
PROCEDURE closeObject :
/*------------------------------------------------------------------------------
  Purpose: persistent trigger defined at 'close' of persistent objects
           to keep track of when DestroyAdm can be enabled again.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phRun AS HANDLE  NO-UNDO.
  DEFINE BUFFER bttRun FOR ttRun.
  FIND bttRun WHERE bttRun.hdl = phRun NO-ERROR.
  IF VALID-HANDLE(phRun) THEN
  DO:

    RUN destroyObject IN phRun.
  
    IF AVAIL bttRun THEN 
      DELETE bttRun. 
  
    IF NOT CAN-FIND(FIRST ttRun)  THEN
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
        toDestroyADM:SENSITIVE = TRUE
        toDestroyADM:CHECKED = toDestroyADM
        buStop:SENSITIVE       = FALSE.        
    END.
  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL    NO-UNDO.
  IF glStop OR CAN-FIND(FIRST ttrun) THEN
  DO:

    MESSAGE 'This will close all containers that is running from the Launcher.'
            SKIP
            'Confirm close of the Launcher and all running containers?' 

        VIEW-AS ALERT-BOX QUESTION  BUTTONS YES-NO UPDATE lok.
    IF NOT lok THEN RETURN.
  END.

  /* glStop is set to true to indicate that we need to STOP to get
     out of a non persistent run */ 
  IF glStop THEN 
  DO:
    /* We cannot run disable_UI from here as we are in a wait-for of the
       non-persistent object. glStopped will tell the runContainer to 
       call us again when it has gotten out of the wait-for.*/ 
    glStopped = TRUE.  
    STOP.
  END.
  ELSE DO:
    /* destroy  all persistent objects that we have started */
    RUN destroyPersistent.
    RUN DISABLE_ui. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyPersistent wWin 
PROCEDURE destroyPersistent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ttRun:
    APPLY 'close' TO ttRun.hdl. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY fiFile ToPersistent toTreeView ToClearCache ToDestroyAdm 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE fiFile buRun ToPersistent toTreeView ToClearCache ToDestroyAdm 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchContainer wWin 
PROCEDURE launchContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcContainerName AS CHARACTER.
DEFINE INPUT PARAMETER pcAttributeList AS CHARACTER.
DEFINE VARIABLE iETime1   AS INTEGER.
DEFINE VARIABLE iETime2   AS INTEGER.
DEFINE VARIABLE iETime3   AS INTEGER.
DEFINE VARIABLE h_object AS HANDLE NO-UNDO.

PROCESS EVENTS.

ASSIGN h_Object = ?.

iETime1 = ETIME(YES).
/* MESSAGE "about to construct". */
    RUN constructObject (
         INPUT  pcContainerName,
         INPUT  {&WINDOW-NAME} ,
         INPUT  pcAttributeList,
         OUTPUT h_object ).

    iETime1 = ETIME(YES).                         
/*     RUN addLink IN h_object (THIS-PROCEDURE, 'container', h_object). */
/* MESSAGE "about to init". */
    RUN initializeObject IN h_object.            

    iETime2 = ETIME(YES).
    
    iETime3 = iETime1 + iETime2.           
/*     MESSAGE "Construct=" iETime1 / 1000  "s Initialize=" iETime2 / 1000  "s Total =" iEtime3 / 1000 "s". */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshADM wWin 
PROCEDURE refreshADM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cProc     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSmart    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iProc     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE i         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cFile     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cProchdl  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hObj      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE ctype     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWin      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSuper    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cFileList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE h AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cOpenProc AS CHARACTER  NO-UNDO.
   
 RUN adeuib/_uibinfo.p(?,'session','procedures', OUTPUT cProc).
 
 cOpenProc = checkADM('ab').

 IF INDEX(cOpenproc,'.ab') <> 0 THEN
 DO WITH FRAME {&FRAME-NAME}:
   MESSAGE 'The ADM Super Procedures are currently being used'
           'by procedures started from the AppBuilder.'
           SKIP
           'You must close these procedures or uncheck the'
           "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
           'option before running.' 
           VIEW-AS ALERT-BOX information.
   RETURN ERROR.
 END.

 /* Check and close design windows */ 
 DO i = 1 TO NUM-ENTRIES(cProc):
   ASSIGN iProc = ENTRY(i,cProc).
   /*
   RUN adeuib/_uibinfo.p(iProc,?,'TYPE', OUTPUT cType).
   
   IF CAN-DO('procedure,window',ctype) THEN NEXT.
   */

   RUN adeuib/_uibinfo.p(iProc,?,'contains smartobject', OUTPUT cSmart).
 
   IF cSmart = '':U THEN NEXT.
   RUN adeuib/_uibinfo.p(iProc,'WINDOW ?','HANDLE', OUTPUT cWin).
   RUN adeuib/_uibinfo.p(iProc,?,'file-name', OUTPUT cFile).
   
   /* find current desing window and filename */
   hObj = WIDGET-HANDLE(cWin) NO-ERROR.
   
   IF cfile = '?' OR cfile = ?  THEN
   DO WITH FRAME {&FRAME-NAME}:
      MESSAGE 'You have unsaved design windows in the AppBuilder.'
              'You must save the' hObj:title 'window or uncheck the'
              "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
              'option before running.' 
      VIEW-AS ALERT-BOX information.
      APPLY 'Entry':U TO hobj.
      hObj:MOVE-TO-TOP().
      RETURN ERROR.        
   END.

   IF VALID-HANDLE(hObj) THEN 
   DO:
     APPLY 'window-close' TO hObj.
     cFileList = cFileList + (IF cFileList = '' THEN '' ELSE ',') + cfile.
   END.
 END.
 
 cOpenProc = checkADM('').
 
 IF cOpenProc <> '':U THEN
 DO WITH FRAME {&FRAME-NAME}:
  MESSAGE 'The ADM Super Procedures are currently being used by' cOpenProc '.'
          SKIP
          'You must close these procedures or uncheck the'
          "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
          'option before running.' 
          VIEW-AS ALERT-BOX information.
  RETURN ERROR.
 END.


 destroyADM(). 

 DO i = 1 TO NUM-ENTRIES(cfileList):
  cFile = ENTRY(i,cFileList).
  IF cFile <> '' AND cFile <> ? THEN
   RUN adeuib/_open-w.p 
      (cfile,
       '',
       'OPEN').
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runContainer wWin 
PROCEDURE runContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcRunFile      AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cPropertyList         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hRun                  AS HANDLE       NO-UNDO.
DEFINE VARIABLE lStopped              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cContainer            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hUIB                  AS HANDLE       NO-UNDO.
  
DO WITH FRAME {&FRAME-NAME}:
 IF toClearCache:CHECKED THEN 
    RUN clearClientCache IN gshRepositoryManager.
 ASSIGN 
  cContainer   = IF INDEX(pcRunfile,'.':U) <> 0 THEN pcrunfile
                 ELSE IF toTreeView:CHECKED 
                 THEN "ry/uib/rydyntreew.w":U 
                 ELSE "ry/uib/rydyncontw.w":U
  toPersistent
  toDestroyADM WHEN toDestroyADM:SENSITIVE.
  
  IF toDestroyAdm AND toDestroyADM:SENSITIVE THEN
  DO:
    RUN refreshADM NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.
  END.
  IF pcRunFile = '':U THEN RETURN.

  ASSIGN
   cPropertyList = "launchphysicalobject,launchlogicalobject,launchrunattribute":U
   cValueList = "ry/uib/rydyncontw.w":U + CHR(3) +
                 pcRunFile + CHR(3) +
                 "":U.
END.


DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                     INPUT cPropertyList,
                                     INPUT cValueList,
                                     INPUT YES).


DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
  IF toPersistent THEN
  DO WITH FRAME {&FRAME-NAME}:
    RUN VALUE(ccontainer) PERSISTENT SET hRun.
    SESSION:SET-WAIT-STATE('wait':U).
    DYNAMIC-FUNCTION('setLogicalObjectName' IN hrun, pcRunfile). 
    RUN initializeObject IN hRun.
    ASSIGN
      toDestroyAdm:SENSITIVE = FALSE
      toDestroyAdm:CHECKED = FALSE
      buStop:SENSITIVE = TRUE.

    IF VALID-HANDLE(hRun) THEN
    DO:
        /* steal the close event so we can keep track of deleted objects 
         * in order to enable the Destroy adm check box again */
        ON 'close':U OF hrun PERSISTENT RUN closeObject IN THIS-PROCEDURE (hRun).

        CREATE ttRun.
        ASSIGN ttRun.hdl        = hRun
               ttRun.ObjectNAME = pcRunFile
               .
    END.    /* valid hRun */
  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
    IF checkAB() = FALSE THEN
    DO:
       MESSAGE
           'You must close procedures running from the AppBuilder before'
           'you do a non persistent launch of a container.' 
           VIEW-AS ALERT-BOX  INFORMATION BUTTONS OK.
       RETURN. 
    END.
    ASSIGN
      hUIB             = h_ade_tool
      buRun:SENSITIVE  = FALSE
      buStop:SENSITIVE = TRUE
      glStop           = TRUE.

    IF VALID-HANDLE(hUIB) THEN
       RUN disable_widgets in hUIB.
    SESSION:SET-WAIT-STATE('wait':U).
    RUN VALUE("ry/uib/rydyncontw.w":U).
  END.
END.
SESSION:SET-WAIT-STATE('':U).

IF NOT toPersistent THEN
DO:
  IF VALID-HANDLE(hUIB) THEN
    RUN enable_widgets in hUIB.
  buStop:SENSITIVE = FALSE. 
END.

buRun:SENSITIVE = TRUE. 
glStop = FALSE.
IF glStopped THEN 
  RUN destroyObject.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkAB wWin 
FUNCTION checkAB RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE h        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hObj     AS HANDLE     NO-UNDO.
 ASSIGN hObj = SESSION:FIRST-PROCEDURE.
 DO WHILE VALID-HANDLE(hObj):
   IF ENTRY(NUM-ENTRIES(hObj:FILE-NAME,'.':U),hObj:FILE-NAME,'.':U) = 'ab' THEN
      RETURN FALSE.
   hObj = hObj:NEXT-SIBLING.
 END. 

 RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkADM wWin 
FUNCTION checkADM RETURNS CHARACTER
  (pcCheck AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE h        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hObj     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSupers  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSuper   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cList    AS CHARACTER  NO-UNDO.

 ASSIGN hObj = SESSION:FIRST-PROCEDURE.
 ProcLoop:
 DO WHILE VALID-HANDLE(hObj):
   cSupers = hObj:SUPER-PROCEDURES.
   DO i = 1 TO NUM-ENTRIES(cSupers):
     hSuper= WIDGET-HANDLE(ENTRY(i,cSupers)).
     IF (pccheck = '':u 
         OR ENTRY(NUM-ENTRIES(hObj:FILE-NAME,'.':U),hObj:FILE-NAME,'.':U) = pcCheck)
     AND CAN-DO(xcADMdestroy,hSuper:FILE-NAME) THEN 
     DO:
        cList = cList + (IF clist = '' THEN '' ELSE ', ') + hObj:FILE-NAME. 
        LEAVE. 
     END.
   END.
   hObj = hObj:NEXT-SIBLING.
 END. 
 
 IF INDEX(cList,',') > 0 THEN
   SUBSTR(cList,R-INDEX(cList,','),1) = ' and'.
 
 RETURN cList.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyADM wWin 
FUNCTION destroyADM RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE h      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSuper AS HANDLE     NO-UNDO.

 ASSIGN hSuper = SESSION:FIRST-PROCEDURE.
 DO WHILE VALID-HANDLE(hSuper) WITH DOWN:
   h = hSuper:NEXT-SIBLING. 
   IF CAN-DO(xcADMdestroy,hSuper:FILE-NAME) THEN 
   DO:
      /* cDeleted = cDeleted + chr(10) + hSuper:FILE-NAME. */
     DELETE PROCEDURE hSuper.     
   END.
   ASSIGN hSuper = h.   
 END.
 return TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN {&WINDOW-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

