&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
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
/*---------------------------------------------------------------------------------
  File: gsmsebconw.w

  Description:  Generate Configuration XML File

  Purpose:      Generate Configuration XML File

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000135   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       gsmsebconw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raLocation buBrowse fiFileName buGenerate ~
buClose 
&Scoped-Define DISPLAYED-OBJECTS raLocation fiFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buBrowse 
     LABEL "&Browse" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClose 
     LABEL "&Close" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     LABEL "&Generate" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U INITIAL "icfconfig.xml" 
     LABEL "File Name" 
     VIEW-AS FILL-IN 
     SIZE 50.8 BY 1 NO-UNDO.

DEFINE VARIABLE raLocation AS CHARACTER INITIAL "L" 
     VIEW-AS RADIO-SET HORIZONTAL EXPAND 
     RADIO-BUTTONS 
          "Local File", "L",
"Remote File", "R"
     SIZE 51.6 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     raLocation AT ROW 1.33 COL 15.8 NO-LABEL
     buBrowse AT ROW 2.71 COL 65.8
     fiFileName AT ROW 2.81 COL 12.6 COLON-ALIGNED
     buGenerate AT ROW 4.33 COL 49.8
     buClose AT ROW 4.33 COL 65.8
     "Generate to:" VIEW-AS TEXT
          SIZE 13.6 BY .62 AT ROW 1.38 COL 14.8 RIGHT-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.8 BY 4.95.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Generate Configuration XML File"
         HEIGHT             = 4.95
         WIDTH              = 79.8
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
/* SETTINGS FOR TEXT-LITERAL "Generate to:"
          SIZE 13.6 BY .62 AT ROW 1.38 COL 14.8 RIGHT-ALIGNED           */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Generate Configuration XML File */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Generate Configuration XML File */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse wiWin
ON CHOOSE OF buBrowse IN FRAME frMain /* Browse */
DO:
  RUN browseForFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClose wiWin
ON CHOOSE OF buClose IN FRAME frMain /* Close */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate wiWin
ON CHOOSE OF buGenerate IN FRAME frMain /* Generate */
DO:
  RUN generateConfigFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raLocation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raLocation wiWin
ON VALUE-CHANGED OF raLocation IN FRAME frMain
DO:
  RUN changeLoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseForFile wiWin 
PROCEDURE browseForFile :
/*------------------------------------------------------------------------------
  Purpose:     Confirms that a file can be created locally.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns  AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    cFileName = fiFileName:SCREEN-VALUE.

    SYSTEM-DIALOG GET-FILE cFileName  
      FILTERS "XML Files (*.xml)":U "*.xml":U,
              "All Files (*.*)":U "*.*":U
      ASK-OVERWRITE
      CREATE-TEST-FILE
      INITIAL-DIR ".":U
      RETURN-TO-START-DIR
      SAVE-AS
      USE-FILENAME
      UPDATE lAns
      IN WINDOW {&WINDOW-NAME}.

    IF lAns THEN
      fiFileName:SCREEN-VALUE = cFileName.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeLoc wiWin 
PROCEDURE changeLoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      raLocation
    .
    buBrowse:SENSITIVE = raLocation = "L":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  DISPLAY raLocation fiFileName 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE raLocation buBrowse fiFileName buGenerate buClose 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateConfigFile wiWin 
PROCEDURE generateConfigFile :
/*------------------------------------------------------------------------------
  Purpose:     Generate XML configuration file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE mptr      AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE hXDoc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRemFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLocal    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cError    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER  NO-UNDO.


  /* Set up the file name */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cFileName = fiFileName:SCREEN-VALUE
      lLocal    = raLocation:SCREEN-VALUE = "L":U
      .
  END.

  /* If the user wants the file created locally, we need to 
     retrieve the XML document via the MEMPTR, otherwise
     we just write it to the remote file */
  IF lLocal THEN
    cRemFile = "<MEMPTR>":U.
  ELSE
    cRemFile = cFileName.

  /* Always set the size of the pointer to 0 */
  set-size(mptr) = 0.

  /* Make the call to the remote procedure that
     runs this stuff. */
  {aflaunch.i &PLIP = 'af/app/afcfgwritep.p'
                    &IProc = 'writeConfigXML'
                    &OnApp = 'YES'
                    &PList = "('*',cRemFile,OUTPUT mptr)" 
                    &AutoKill = YES}

  /* Check for any errors */
  {afcheckerr.i &display-error = YES}.

  /* If everything worked, and we want the stuff written out locally,
     we need to load the XML document from the MEMPTR */
  IF lLocal THEN
  DO:
    /* Create the X document */
    CREATE X-DOCUMENT hXDoc.

    /* Load the contents of the MEMPTR into the
       X document and check for any errors */
    lAns = hXDoc:LOAD("MEMPTR":U,mptr,FALSE) NO-ERROR.
    {afcheckerr.i &no-return = YES
                  &errors-not-zero = YES}
    IF cMessageList <> "":U THEN
      cError = cMessageList.

    /* If the load succeeded, save the X document to disk */
    IF lAns THEN
    DO:
      lAns = hXDoc:SAVE("FILE":U,cFileName) NO-ERROR.
      {afcheckerr.i &no-return = YES
                    &errors-not-zero = YES}
      IF cMessageList <> "":U THEN
        cError = cMessageList.
    END.

    DELETE OBJECT hXDoc.
    hXDoc = ?.

  END.

  /* Empty the memptr */
  set-size(mptr) = 0.

  IF cError <> '':U  THEN
  DO:
    ASSIGN lAns = FALSE.
    RUN showMessages IN gshSessionManager (INPUT cError,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Save Configuration XML file":U,
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
  END.  /* if error */
  ELSE DO:
    ASSIGN lAns = TRUE. 
    /* Only show the success message if running this from the Validate
       Dataset Query button */
    IF PROGRAM-NAME(2) BEGINS 'USER-INTERFACE-TRIGGER':U THEN
    DO:
      cError = {af/sup2/aferrortxt.i 'AF' '108' '' '' "'configuration file save'"}.
      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "MES":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Save Configuration XML file",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    END.  /* if called from ui trigger */
  END.  /* else do */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN changeLoc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

