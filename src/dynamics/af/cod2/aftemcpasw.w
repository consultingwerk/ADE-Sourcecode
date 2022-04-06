&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" wiMain _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiMain _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiMain _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiMain 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftemcpasw.w

  Description:  ICF 2 Change User Password

  Purpose:      ICF 2 Change User Password

  Parameters:   input login name
                input login user object number
                input old password (encoded)
                input language object number
                output failed reason if any

  History:
  --------
  (v:010000)    Task:        6010   UserRef:    
                Date:   14/06/2000  Author:     Anthony Swindells

  Update Notes: Write ICF Toolbar

  (v:010001)    Task:        6010   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: ICF Login Window

  (v:010003)    Task:        7405   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: ICF translations

----------------------------------------------------------*/
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

DEFINE INPUT  PARAMETER pcLoginName                 AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdUserObj                   AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcOldPassword               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plExpired                   AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdLanguageObj               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                     AS CHARACTER  NO-UNDO.

{af/sup2/afglobals.i}
{af/sup2/dynhlp.i}         /* Help File Preprocessor Directives         */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemcpasw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE VARIABLE cAction                             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton                             AS CHARACTER NO-UNDO.      
DEFINE VARIABLE cFileName                           AS CHARACTER NO-UNDO.      

{af/app/afttsecurityctrl.i}

{af/app/aftttranslate.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiLoginName fiOldPassword fiNewPassword ~
fiConfirmPassword buOk buCancel imCompany imLogo 
&Scoped-Define DISPLAYED-OBJECTS fiLoginName fiOldPassword fiNewPassword ~
fiConfirmPassword 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiMain AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel 
     LABEL "&Cancel" 
     SIZE 15.4 BY 1.14 TOOLTIP "Abort login"
     BGCOLOR 8 .

DEFINE BUTTON buOk 
     LABEL "&OK" 
     SIZE 15.4 BY 1.14 TOOLTIP "Login to application"
     BGCOLOR 8 .

DEFINE VARIABLE fiConfirmPassword AS CHARACTER FORMAT "X(25)":U 
     LABEL "Confirm" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "Confirm new User password - (case sesnsitive)" NO-UNDO.

DEFINE VARIABLE fiLoginName AS CHARACTER FORMAT "X(25)":U 
     LABEL "Login Name" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "User login name for password to change" NO-UNDO.

DEFINE VARIABLE fiNewPassword AS CHARACTER FORMAT "X(25)":U 
     LABEL "New Password" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "New User password - (case sesnsitive)" NO-UNDO.

DEFINE VARIABLE fiOldPassword AS CHARACTER FORMAT "X(25)":U 
     LABEL "Old Password" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "Existng User password - (case sesnsitive)" NO-UNDO.

DEFINE IMAGE imCompany
     FILENAME "adeicon/login.bmp":U
     SIZE 14.4 BY 4.76.

DEFINE IMAGE imLogo
     FILENAME "adeicon/icfdev.ico":U TRANSPARENT
     SIZE 8.8 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiLoginName AT ROW 1.14 COL 31.4 COLON-ALIGNED
     fiOldPassword AT ROW 2.67 COL 31.4 COLON-ALIGNED PASSWORD-FIELD
     fiNewPassword AT ROW 3.76 COL 31.4 COLON-ALIGNED PASSWORD-FIELD
     fiConfirmPassword AT ROW 4.91 COL 31.4 COLON-ALIGNED PASSWORD-FIELD
     buOk AT ROW 1.14 COL 77.4
     buCancel AT ROW 2.33 COL 77.4
     imCompany AT ROW 1.19 COL 1.8
     imLogo AT ROW 5.1 COL 82.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.6 BY 5.86
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.


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
  CREATE WINDOW wiMain ASSIGN
         HIDDEN             = YES
         TITLE              = "Change User Password"
         COLUMN             = 50
         ROW                = 25.67
         HEIGHT             = 5.86
         WIDTH              = 92.6
         MAX-HEIGHT         = 6.33
         MAX-WIDTH          = 92.6
         VIRTUAL-HEIGHT     = 6.33
         VIRTUAL-WIDTH      = 92.6
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         TOP-ONLY           = yes
         RESIZE             = no
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
/* SETTINGS FOR WINDOW wiMain
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE L-To-R,COLUMNS                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiMain)
THEN wiMain:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiMain wiMain
ON END-ERROR OF wiMain /* Change User Password */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiMain wiMain
ON WINDOW-CLOSE OF wiMain /* Change User Password */
DO:
  ASSIGN cAction = "cancel":U.
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain wiMain
ON HELP OF FRAME frMain
DO:
   /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Change_User_Password_Dialog_Box}  , "").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel wiMain
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
    ASSIGN cAction = "cancel":U.
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk wiMain
ON CHOOSE OF buOk IN FRAME frMain /* OK */
DO:
    ASSIGN cAction = "ok":U.
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME imLogo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL imLogo wiMain
ON MOUSE-SELECT-DBLCLICK OF imLogo IN FRAME frMain
DO:
  RCODE-INFO:FILE-NAME = THIS-PROCEDURE:FILE-NAME.
  MESSAGE "Databases Referenced = " RCODE-INFO:DB-REFERENCES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiMain 


/* ***************************  Main Block  *************************** */

IF THIS-PROCEDURE:PERSISTENT THEN
  DO:
    MESSAGE "The Change password window should not be run persistently"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN ERROR.
  END.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Always centre the login window in the session as we can not yet get where
   the user prefers to have the login window as we do not know who the user is
   yet!
*/

CURRENT-WINDOW:X = (SESSION:WIDTH-PIXELS - CURRENT-WINDOW:WIDTH-PIXELS) / 2 NO-ERROR.
CURRENT-WINDOW:Y = (SESSION:HEIGHT-PIXELS - CURRENT-WINDOW:HEIGHT-PIXELS) / 2 NO-ERROR.   

/* See if customised logo's exist */          
IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

/* load icons if set-up in database */

ASSIGN
    cFileName = IF  AVAILABLE ttSecurityControl AND ttSecurityControl.company_logo_filename <> "":U THEN
                    ttSecurityControl.company_logo_filename ELSE "":U
  .

IF cFileName <> "":U AND SEARCH(cFileName) <> ? THEN
    IF imCompany:LOAD-IMAGE(cFileName ) THEN PROCESS EVENTS.

ASSIGN
    cFileName = IF  AVAILABLE ttSecurityControl AND ttSecurityControl.product_logo_filename <> "":U THEN
                    ttSecurityControl.product_logo_filename ELSE ""
  .

IF cFileName <> "":U AND SEARCH(cFileName) <> ? THEN
    IF imLogo:LOAD-IMAGE(cFileName ) THEN PROCESS EVENTS.


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
RUN enable_UI.

{af/sup2/aficonload.i}

RUN doTranslations.

IF plExpired THEN
  CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - Password Expired".

VIEW wiMain.
wiMain:SENSITIVE = YES.
VIEW FRAME {&FRAME-NAME}.
FRAME {&FRAME-NAME}:SENSITIVE = YES.

DO WITH FRAME {&FRAME-NAME}:
  DISPLAY pcLoginName @ fiLoginName.
END.

IF pdUserObj > 0 THEN
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
      fiLoginName:SENSITIVE = FALSE
      fiLoginName:BGCOLOR = 8
      fiOldPassword:SENSITIVE = FALSE
      fiOldPassword:BGCOLOR = 8
      .
  DISPLAY pcLoginName @ fiLoginName.
END.
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
REPEAT WHILE TRUE:

  IF pdUserObj > 0 THEN
    APPLY "entry":U TO fiNewPassword.
  ELSE
    APPLY "entry":U TO fiLoginName.

  /* ensure password fields are empty */
  fiOldPassword:SCREEN-VALUE = "":U.
  fiNewPassword:SCREEN-VALUE = "":U.
  fiConfirmPassword:SCREEN-VALUE = "":U.

  SESSION:SET-WAIT-STATE('':U).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

  /* check action and act accordingly */
  IF cAction = "OK":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiLoginName
        fiOldPassword
        fiNewPassword
        fiConfirmPassword
        pcError = "":U
        .

    IF fiNewPassword <> fiConfirmPassword THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT "Your password was not confirmed, please retry",
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "User Authentication Failure",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      NEXT main-block.      
    END.

    RUN changePassword IN gshSecurityManager (INPUT pdUserObj,
                                              INPUT fiLoginName,
                                              INPUT IF pdUserObj <> 0 THEN pcOldPassword ELSE (IF fiOldPassword  <> "":U THEN ENCODE(fiOldPassword) ELSE "":U) ,
                                              INPUT IF fiNewPassword  <> "":U THEN ENCODE(fiNewPassword) ELSE "":U,
                                              INPUT plExpired,
                                              INPUT LENGTH(fiNewPassword), /* characters entered in password */
                                              OUTPUT pcError).

    IF pcError <> "":U THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT pcError,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "User Authentication Failure",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      NEXT main-block.      
    END.
    ELSE
    DO:
      RUN showMessages IN gshSessionManager (INPUT "Your password has been changed",
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "User Password Change",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    END.

  END.  /* action = ok */

  LEAVE MAIN-BLOCK.

END.  /* repeat while true */

ASSIGN
    wiMain:HIDDEN = TRUE
    FRAME {&FRAME-NAME}:HIDDEN = TRUE.

APPLY "CLOSE":U TO THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiMain  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiMain)
  THEN DELETE WIDGET wiMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doTranslations wiMain 
PROCEDURE doTranslations :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN buildWidgetTable IN gshTranslationManager (INPUT THIS-PROCEDURE:FILE-NAME,
                                               INPUT pdLanguageObj,
                                               INPUT CURRENT-WINDOW,
                                               INPUT FRAME {&FRAME-NAME}:HANDLE,

                                               OUTPUT TABLE ttTranslate).

RUN translateWidgetTable IN gshTranslationManager (INPUT NO,    /* not yet translated */
                                                   INPUT pdLanguageObj, 
                                                   INPUT TABLE ttTranslate).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiMain  _DEFAULT-ENABLE
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
  DISPLAY fiLoginName fiOldPassword fiNewPassword fiConfirmPassword 
      WITH FRAME frMain IN WINDOW wiMain.
  ENABLE fiLoginName fiOldPassword fiNewPassword fiConfirmPassword buOk 
         buCancel imCompany imLogo 
      WITH FRAME frMain IN WINDOW wiMain.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

