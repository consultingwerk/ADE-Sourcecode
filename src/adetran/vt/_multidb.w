&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: adetran/vt/_multidb.w

  Description: Procedure to collect MultiUser Kit info from end user
               so that a proper multiUser DB connection can be made.

  Input Parameters:
      <none>

  Output Parameters:
    pKitDB     - Database name of the Translation Kit
    pHost      - DB Server machine name
    pService   - DB Server port number
    pUsrId     - User Id if kit is password protected
    pPassWrd   - Password if kit is password protected
    pConParms  - Miscellaneous connection parmaters
    pOkPressed - True if user has selected a Kit db.

  Author: Ross Hunter

  Created: 6/3/99
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
  DEFINE OUTPUT PARAMETER pKitDB     AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pHost      AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pService   AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pUsrId     AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pPassWrd   AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pConParms  AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER pOkPressed AS LOGICAL         NO-UNDO.

/* Local Variable Definitions ---                                       */

{adetran/vt/vthlp.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS KitDB Brws_btn Host Service UsrId PassWrd ~
ConParms Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS KitDB Host Service UsrId PassWrd ConParms 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Brws_btn 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14 TOOLTIP "Select the kit database from the file system".

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

DEFINE VARIABLE ConParms AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 74 BY 5 TOOLTIP "Specify any remain connect parameters necessary for the kit db" NO-UNDO.

DEFINE VARIABLE Host AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hos&t Name" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 TOOLTIP "Enter the name of the computer that hosts the kit database" NO-UNDO.

DEFINE VARIABLE KitDB AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Kit DB" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1 TOOLTIP "Enter the name of the kit database name (xxxxx.db)." NO-UNDO.

DEFINE VARIABLE PassWrd AS CHARACTER FORMAT "x(256)":U 
     LABEL "&Password" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 TOOLTIP "Specify your password if the kit is password protected" NO-UNDO.

DEFINE VARIABLE Service AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Service Name" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 TOOLTIP "Specify the port of the database server" NO-UNDO.

DEFINE VARIABLE UsrId AS CHARACTER FORMAT "X(256)":U 
     LABEL "&User ID" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 TOOLTIP "Specify your UserID if the kit db is password protected" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     KitDB AT ROW 1.24 COL 13 COLON-ALIGNED
     Brws_btn AT ROW 1.24 COL 62
     Host AT ROW 2.91 COL 13 COLON-ALIGNED
     Service AT ROW 2.91 COL 54 COLON-ALIGNED
     UsrId AT ROW 4.33 COL 13 COLON-ALIGNED
     PassWrd AT ROW 4.33 COL 54 COLON-ALIGNED PASSWORD-FIELD
     ConParms AT ROW 6.71 COL 4 NO-LABEL
     Btn_OK AT ROW 1.24 COL 82
     Btn_Cancel AT ROW 2.48 COL 82
     Btn_Help AT ROW 4.48 COL 82
     "&Other CONNECT Statement Parameters:" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 6 COL 4
     SPACE(46.79) SKIP(6.08)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Open Multi-User Kit Database"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
   Custom                                                               */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Open Multi-User Kit Database */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Brws_btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brws_btn Dialog-Frame
ON CHOOSE OF Brws_btn IN FRAME Dialog-Frame /* Browse... */
DO:
  DEFINE VARIABLE filter    AS CHARACTER INITIAL "*.db"   NO-UNDO.
  DEFINE VARIABLE name      AS CHARACTER                  NO-UNDO.
  DEFINE VARIABLE PickedOne AS LOGICAL                    NO-UNDO.

  ASSIGN name = KitDB:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  SYSTEM-DIALOG GET-FILE
      name
      filters            filter filter
      default-extension  ".db":U
      title              "Find Kit Database"
      must-exist
      update             pickedOne.

  IF pickedOne THEN KitDB:SCREEN-VALUE IN FRAME {&FRAME-NAME} = name.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("VT":U, "CONTEXT":U, {&Open_MU_Kit_Dialog_Box}, ?).      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  ASSIGN KitDB Host Service UsrId PassWrd ConParms.
  ASSIGN pKitDB    = KitDB
         pHost     = Host
         pService  = Service
         pUsrId    = UsrId
         pPassWrd  = PassWrd
         pConParms = ConParms.
  IF pKitDB NE "" THEN pOkPressed = True.
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
  DISPLAY KitDB Host Service UsrId PassWrd ConParms 
      WITH FRAME Dialog-Frame.
  ENABLE KitDB Brws_btn Host Service UsrId PassWrd ConParms Btn_OK Btn_Cancel 
         Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

