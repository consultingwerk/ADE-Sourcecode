&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          appsrvtt         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME AddServ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS AddServ 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: protools/addpart.w

  Description: Add new partition to partition table

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 1998
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE askCommit  AS LOGICAL                      NO-UNDO.
{adecomm/appsrvtt.i}
{protools/ptlshlp.i} /* Pro*Tools help contexts */

DEFINE BUFFER x_as FOR AppSrv-TT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME AddServ

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AppSrv-TT

/* Definitions for DIALOG-BOX AddServ                                   */
&Scoped-define FIELDS-IN-QUERY-AddServ AppSrv-TT.Partition ~
AppSrv-TT.App-Service AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security ~
AppSrv-TT.Info 
&Scoped-define ENABLED-FIELDS-IN-QUERY-AddServ AppSrv-TT.Partition ~
AppSrv-TT.App-Service AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security ~
AppSrv-TT.Info 
&Scoped-define ENABLED-TABLES-IN-QUERY-AddServ AppSrv-TT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-AddServ AppSrv-TT
&Scoped-define OPEN-QUERY-AddServ OPEN QUERY AddServ FOR EACH AppSrv-TT SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-AddServ AppSrv-TT
&Scoped-define FIRST-TABLE-IN-QUERY-AddServ AppSrv-TT


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AppSrv-TT.Partition AppSrv-TT.App-Service ~
AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security AppSrv-TT.Info 
&Scoped-define ENABLED-TABLES AppSrv-TT
&Scoped-define FIRST-ENABLED-TABLE AppSrv-TT
&Scoped-define DISPLAYED-TABLES AppSrv-TT
&Scoped-define FIRST-DISPLAYED-TABLE AppSrv-TT
&Scoped-Define ENABLED-OBJECTS RS-Config Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS AppSrv-TT.Partition AppSrv-TT.App-Service ~
AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security AppSrv-TT.Info 
&Scoped-Define DISPLAYED-OBJECTS RS-Config Info-lbl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE Info-lbl AS CHARACTER FORMAT "X(256)":U INITIAL "AppServer Information String:" 
      VIEW-AS TEXT 
     SIZE 30 BY .62 NO-UNDO.

DEFINE VARIABLE RS-Config AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Remote", yes,
"Local", no
     SIZE 27 BY 1.19 TOOLTIP "Select the current configuration" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY AddServ FOR 
      AppSrv-TT SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME AddServ
     AppSrv-TT.Partition AT ROW 1.57 COL 16 COLON-ALIGNED
          LABEL "Partition Name"
          VIEW-AS FILL-IN 
          SIZE 27 BY 1 TOOLTIP "Enter the new partition name"
     AppSrv-TT.App-Service AT ROW 2.57 COL 16 COLON-ALIGNED
          LABEL "Service Name"
          VIEW-AS FILL-IN 
          SIZE 27 BY 1 TOOLTIP "Enter the Application Service Name"
     AppSrv-TT.Host AT ROW 3.57 COL 16 COLON-ALIGNED
          LABEL "Host (-H)"
          VIEW-AS FILL-IN 
          SIZE 27 BY 1 TOOLTIP "Host (-H) of the Name Server for this partition"
     AppSrv-TT.Service AT ROW 4.57 COL 16 COLON-ALIGNED
          LABEL "Service (-S)"
          VIEW-AS FILL-IN 
          SIZE 27 BY 1 TOOLTIP "Service (-S) of the Name Server for this partition"
     RS-Config AT ROW 5.52 COL 18 NO-LABEL
     AppSrv-TT.Security AT ROW 7 COL 9
          LABEL "Prompt for userid and password"
          VIEW-AS TOGGLE-BOX
          SIZE 40 BY .81
     AppSrv-TT.Info AT ROW 9.14 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 43 BY 3.57 TOOLTIP "AppServer Connection Information string"
     Btn_OK AT ROW 1.48 COL 47
     Btn_Cancel AT ROW 2.71 COL 47
     Btn_Help AT ROW 4.48 COL 47
     Info-lbl AT ROW 8.38 COL 3 NO-LABEL
     "Configuration:" VIEW-AS TEXT
          SIZE 13 BY 1 AT ROW 5.52 COL 4.6
     SPACE(45.59) SKIP(6.47)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Add Partition"
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
/* SETTINGS FOR DIALOG-BOX AddServ
   Custom                                                               */
ASSIGN 
       FRAME AddServ:SCROLLABLE       = FALSE
       FRAME AddServ:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN AppSrv-TT.App-Service IN FRAME AddServ
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AppSrv-TT.Host IN FRAME AddServ
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Info-lbl IN FRAME AddServ
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       Info-lbl:READ-ONLY IN FRAME AddServ        = TRUE.

/* SETTINGS FOR FILL-IN AppSrv-TT.Partition IN FRAME AddServ
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX AppSrv-TT.Security IN FRAME AddServ
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AppSrv-TT.Service IN FRAME AddServ
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX AddServ
/* Query rebuild information for DIALOG-BOX AddServ
     _TblList          = "appsrvtt.AppSrv-TT"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX AddServ */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME AddServ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AddServ AddServ
ON WINDOW-CLOSE OF FRAME AddServ /* Add Partition */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AppSrv-TT.App-Service
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AppSrv-TT.App-Service AddServ
ON LEAVE OF AppSrv-TT.App-Service IN FRAME AddServ /* Service Name */
, Partition, Host, Service
DO:
  DEFINE VARIABLE i          AS INTEGER         NO-UNDO.
  DEFINE VARIABLE n          AS INTEGER         NO-UNDO.
  DEFINE VARIABLE okay       AS LOGICAL         NO-UNDO.
  DEFINE VARIABLE tmp-string AS CHARACTER       NO-UNDO.
  
  ASSIGN tmp-string = SELF:SCREEN-VALUE
         n          = LENGTH(tmp-string,"RAW":U).
  okay = TRUE.
  DO i = 1 TO n WHILE okay:
    okay = INDEX("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-_",
                 SUBSTRING(tmp-string,i,1,"CHARACTER":U)) > 0.
  END.
  IF NOT okay THEN DO:
    MESSAGE 'There is at least one illegal character in the ' +
            SELF:LABEL + (IF NUM-ENTRIES(SELF:LABEL, " ":U) > 1 THEN
            '.' ELSE ' field.') SKIP
            'The only acceptable characters are "A-Z,a-z,0-9,- and _".' SKIP (1)
            'Please re-enter the name.' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF SELF:LABEL = "Partition Name" THEN DO:
    /* Prepopulate the Service Name */
    IF AppSrv-TT.App-Service:SCREEN-VALUE = "" THEN
         AppSrv-TT.App-Service:SCREEN-VALUE = SELF:SCREEN-VALUE.
  END.  /* If leaving the Partition field */
  
  IF SELF:LABEL = "Service Name" THEN DO:
    FIND FIRST x_as WHERE x_as.App-Service = SELF:SCREEN-VALUE AND
                          x_as.Partition NE AppSrv-TT.Partition:SCREEN-VALUE
                    NO-ERROR.
    IF AVAILABLE x_as THEN DO:
      ASSIGN AppSrv-TT.HOST = x_as.HOST
             AppSrv-TT.Service = x_as.Service
             AppSrv-TT.Configuration = x_as.Configuration
             AppSrv-TT.Security = x_as.Security
             AppSrv-TT.Info = x_as.Info.
      DISPLAY AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security
              AppSrv-TT.Info 
        WITH FRAME AddServ.
    END.  /* IF available x_as */
  END.  /* If leaving the AppService field */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel AddServ
ON CHOOSE OF Btn_Cancel IN FRAME AddServ /* Cancel */
DO:
  DELETE AppSrv-TT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help AddServ
ON CHOOSE OF Btn_Help IN FRAME AddServ /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("ptls":U, "CONTEXT":U, {&Add_Partition_DB}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK AddServ
ON CHOOSE OF Btn_OK IN FRAME AddServ /* OK */
DO:    
  IF AppSrv-TT.Partition:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must enter a partition name." VIEW-AS ALERT-BOX INFORMATION.
    APPLY "ENTRY" TO AppSrv-TT.Partition IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  ELSE IF AppSrv-TT.App-Service:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must enter an application service name." VIEW-AS ALERT-BOX INFORMATION.
    APPLY "ENTRY" TO AppSrv-TT.App-Service IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  
  ASSIGN {&ENABLED-FIELDS-IN-QUERY-{&FRAME-NAME}}
         RS-Config
         AppSrv-TT.Configuration = RS-Config
         askCommit = yes.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK AddServ 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  CREATE AppSrv-TT.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI AddServ  _DEFAULT-DISABLE
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
  HIDE FRAME AddServ.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI AddServ  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-AddServ}
  GET FIRST AddServ.
  DISPLAY RS-Config Info-lbl 
      WITH FRAME AddServ.
  IF AVAILABLE AppSrv-TT THEN 
    DISPLAY AppSrv-TT.Partition AppSrv-TT.App-Service AppSrv-TT.Host 
          AppSrv-TT.Service AppSrv-TT.Security AppSrv-TT.Info 
      WITH FRAME AddServ.
  ENABLE AppSrv-TT.Partition AppSrv-TT.App-Service AppSrv-TT.Host 
         AppSrv-TT.Service RS-Config AppSrv-TT.Security AppSrv-TT.Info Btn_OK 
         Btn_Cancel Btn_Help 
      WITH FRAME AddServ.
  VIEW FRAME AddServ.
  {&OPEN-BROWSERS-IN-QUERY-AddServ}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

