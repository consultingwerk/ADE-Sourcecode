&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Dialog-Frame _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Dialog-Frame _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Dialog-Frame _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftemsuspd.w

  Description:  ICF Suspend Diaog

  Purpose:      ICF Suspend Diaog

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         415   UserRef:    Astra
                Date:   09/07/1998  Author:     Anthony Swindells

  Update Notes: Written from scratch

  (v:010001)    Task:        6560   UserRef:    
                Date:   23/08/2000  Author:     Jenny Bond

  Update Notes: Suspend dialog sometimes has row error

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemsuspd.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{af/sup2/afglobals.i}
{af/sup2/dynhlp.i}          /* Help File Preprocessor Directives         */

DEFINE VARIABLE cUserProperties           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUserValues               AS CHARACTER NO-UNDO.

DEFINE VARIABLE dCurrentUserObj           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dCurrentOrganisationObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentUserLogin         AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buLogout fiPassword buOK imLogo 
&Scoped-Define DISPLAYED-OBJECTS fiPassword 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buLogout AUTO-END-KEY 
     LABEL "&Logout" 
     SIZE 15.2 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK 
     LABEL "&OK" 
     SIZE 15.2 BY 1.14
     BGCOLOR 8 FONT 4.

DEFINE VARIABLE fiPassword AS CHARACTER FORMAT "X(25)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE IMAGE imLogo
     FILENAME "adeicon/icfdev.ico":U TRANSPARENT
     SIZE 8.8 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     buLogout AT ROW 1.19 COL 68.2
     fiPassword AT ROW 1.76 COL 21 COLON-ALIGNED PASSWORD-FIELD
     buOK AT ROW 2.43 COL 68.2
     imLogo AT ROW 1.38 COL 3.8
     SPACE(72.59) SKIP(0.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "User -"
         DEFAULT-BUTTON buOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON HELP OF FRAME Dialog-Frame /* User - */
DO:
    /* Help for this Frame */
   RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Suspend_User_Dialog_Box}  , "").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* User - */
DO:
  APPLY "CHOOSE":U TO buLogout. /* (010100) */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLogout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLogout Dialog-Frame
ON CHOOSE OF buLogout IN FRAME Dialog-Frame /* Logout */
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Logout User",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Quit Session":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
    QUIT.
  ELSE
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK Dialog-Frame
ON CHOOSE OF buOK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VARIABLE dUserObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cUserName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserEmail            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrganisationCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrganisationName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrganisationShort    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLanguageName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFailedReason         AS CHARACTER  NO-UNDO.

  ASSIGN
    fiPassword.

  RUN checkUser IN gshSecurityManager (INPUT cCurrentUserLogin,
                                       INPUT IF fiPassword <> "":U THEN ENCODE(fiPassword) ELSE "":U,
                                       INPUT dCurrentOrganisationObj,
                                       INPUT 0,
                                       OUTPUT dUserObj,
                                       OUTPUT cUserName,
                                       OUTPUT cUserEmail,
                                       OUTPUT cOrganisationCode,
                                       OUTPUT cOrganisationName,
                                       OUTPUT cOrganisationShort,
                                       OUTPUT cLanguageName,
                                       OUTPUT cFailedReason).

  IF cFailedReason = "Expired":U THEN
    ASSIGN cFailedReason = "Password Expired":U.

  IF cFailedReason <> "":U THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.      
    RUN showMessages IN gshSessionManager (INPUT cFailedReason,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "User Authentication Failure",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    fiPassword:SCREEN-VALUE = "":U.                                           
    RETURN NO-APPLY.      
  END.
  ELSE
    APPLY "U1":U TO FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME imLogo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL imLogo Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF imLogo IN FRAME Dialog-Frame
DO:
  RCODE-INFO:FILE-NAME = THIS-PROCEDURE:FILE-NAME.
  MESSAGE "Databases Referenced = " RCODE-INFO:DB-REFERENCES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Centre dialog */
DEFINE VARIABLE hParent AS HANDLE NO-UNDO.
ASSIGN
  hParent        = FRAME {&FRAME-NAME}:PARENT
  FRAME {&FRAME-NAME}:ROW    = MAX(MAX(1,(SESSION:HEIGHT - FRAME {&FRAME-NAME}:HEIGHT) / 2)
                   - hParent:ROW, 1)
  FRAME {&FRAME-NAME}:COLUMN = MAX(MAX(1,(SESSION:WIDTH - FRAME {&FRAME-NAME}:WIDTH) / 2)
                   - hParent:COLUMN, 1).

RUN af/sup/afwinstatp.p (INPUT ?, INPUT "HID":U, INPUT ?).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, RETRY MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, RETRY MAIN-BLOCK:
  RUN enable_UI.

  ASSIGN
    cUserProperties = "CurrentUserObj,CurrentOrganisationObj,CurrentUserLogin":U.

  cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                                     INPUT cUserProperties,
                                                     INPUT NO).
  ASSIGN
    dCurrentUserObj = DECIMAL(ENTRY(1, cUserValues, CHR(3)))
    dCurrentOrganisationObj = DECIMAL(ENTRY(2, cUserValues, CHR(3)))
    cCurrentUserLogin = ENTRY(3, cUserValues, CHR(3))
    NO-ERROR.                                                           

  ASSIGN FRAME {&FRAME-NAME}:TITLE = "Suspended User - " + CAPS(cCurrentUserLogin).                                                   
  SESSION:SET-WAIT-STATE('':U).
  WAIT-FOR U1 OF FRAME {&FRAME-NAME} FOCUS fiPassword.
  RUN af/sup/afwinstatp.p (INPUT ?, INPUT "VEW":U, INPUT ?).

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
  DISPLAY fiPassword 
      WITH FRAME Dialog-Frame.
  ENABLE buLogout fiPassword buOK imLogo 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

