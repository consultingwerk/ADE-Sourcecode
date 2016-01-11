&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          appsrvtt         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME AS-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS AS-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: protools/as-partn.w

  Description: AppServer Partition Deployment PRO*Tool

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 1998
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE askCommit  AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE old-rowid AS ROWID                                NO-UNDO.
DEFINE VARIABLE orig-name AS CHARACTER CASE-SENSITIVE             NO-UNDO.

{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/appserv.i}
{protools/ptlshlp.i} /* Pro*Tools help contexts */
{adecomm/_adetool.i}

DEFINE BUFFER x_as  FOR AppSrv-TT.
DEFINE BUFFER x_as2 FOR AppSrv-TT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME AS-Frame
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AppSrv-TT

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 AppSrv-TT.Partition 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 AppSrv-TT.Partition 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-1 AppSrv-TT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-1 AppSrv-TT
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH AppSrv-TT NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 AppSrv-TT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 AppSrv-TT


/* Definitions for DIALOG-BOX AS-Frame                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-AS-Frame ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AppSrv-TT.App-Service AppSrv-TT.Host ~
AppSrv-TT.Service AppSrv-TT.Security AppSrv-TT.Info 
&Scoped-define ENABLED-TABLES AppSrv-TT
&Scoped-define FIRST-ENABLED-TABLE AppSrv-TT
&Scoped-define DISPLAYED-TABLES AppSrv-TT
&Scoped-define FIRST-DISPLAYED-TABLE AppSrv-TT
&Scoped-Define ENABLED-OBJECTS RECT-1 BROWSE-1 Btn_OK Btn_Cancel btn-Add ~
btn-Remove Btn_Help RS-Config 
&Scoped-Define DISPLAYED-FIELDS AppSrv-TT.App-Service AppSrv-TT.Host ~
AppSrv-TT.Service AppSrv-TT.Security AppSrv-TT.Info 
&Scoped-Define DISPLAYED-OBJECTS RS-Config Info-lbl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Add 
     LABEL "&Add..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn-Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

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
     SIZE 23 BY 1.19 TOOLTIP "Select the current configuration" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 10.76.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      AppSrv-TT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 AS-Frame _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      AppSrv-TT.Partition
  ENABLE
      AppSrv-TT.Partition
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47 BY 4.29 EXPANDABLE TOOLTIP "Edit the partition name".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME AS-Frame
     BROWSE-1 AT ROW 1.48 COL 5
     Btn_OK AT ROW 1.48 COL 59
     Btn_Cancel AT ROW 2.71 COL 59
     btn-Add AT ROW 4.33 COL 59
     btn-Remove AT ROW 5.57 COL 59
     AppSrv-TT.App-Service AT ROW 7 COL 19 COLON-ALIGNED
          LABEL "Service Name"
          VIEW-AS FILL-IN 
          SIZE 27 BY 1 TOOLTIP "Enter the Application service name"
     Btn_Help AT ROW 7.29 COL 59
     AppSrv-TT.Host AT ROW 8 COL 19 COLON-ALIGNED
          LABEL "Host (-H)"
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "Host (-H) of the Name Server for this partition"
     AppSrv-TT.Service AT ROW 9 COL 19 COLON-ALIGNED
          LABEL "Service (-S)"
          VIEW-AS FILL-IN 
          SIZE 17 BY 1 TOOLTIP "Service (-S) of Name Server for this partition"
     RS-Config AT ROW 10 COL 21 NO-LABEL
     AppSrv-TT.Security AT ROW 11.24 COL 7.4
          LABEL "Prompt for userid and password"
          VIEW-AS TOGGLE-BOX
          SIZE 39 BY .81
     AppSrv-TT.Info AT ROW 13.14 COL 5 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 46 BY 3.57 TOOLTIP "AppServer Connection Information string"
     Info-lbl AT ROW 12.43 COL 5 NO-LABEL
     "Configuration:" VIEW-AS TEXT
          SIZE 13 BY 1 AT ROW 10.05 COL 7.4
     RECT-1 AT ROW 6.52 COL 3
     SPACE(20.00) SKIP(0.47)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "AppServer Partition Deployment"
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
/* SETTINGS FOR DIALOG-BOX AS-Frame
                                                                        */
/* BROWSE-TAB BROWSE-1 RECT-1 AS-Frame */
ASSIGN 
       FRAME AS-Frame:SCROLLABLE       = FALSE
       FRAME AS-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN AppSrv-TT.App-Service IN FRAME AS-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AppSrv-TT.Host IN FRAME AS-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Info-lbl IN FRAME AS-Frame
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       Info-lbl:READ-ONLY IN FRAME AS-Frame        = TRUE.

/* SETTINGS FOR TOGGLE-BOX AppSrv-TT.Security IN FRAME AS-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AppSrv-TT.Service IN FRAME AS-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "appsrvtt.AppSrv-TT"
     _FldNameList[1]   > appsrvtt.AppSrv-TT.Partition
"AppSrv-TT.Partition" ? ? "character" ? ? ? ? ? ? yes ? no no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME AS-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AS-Frame AS-Frame
ON WINDOW-CLOSE OF FRAME AS-Frame /* AppServer Partition Deployment */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AppSrv-TT.App-Service
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AppSrv-TT.App-Service AS-Frame
ON LEAVE OF AppSrv-TT.App-Service IN FRAME AS-Frame /* Service Name */
, Host, Service, RS-Config
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

  IF SELF:LABEL = "Service Name" THEN DO:
    FIND x_as WHERE ROWID(x_as) = old-rowid NO-ERROR.
    IF AVAILABLE x_as THEN 
      ASSIGN x_as.App-Service = SELF:SCREEN-VALUE
             askCommit        = yes.
    
    /* Now set other fields like current AppService rows if any */
    FIND FIRST x_as WHERE x_as.App-Service = SELF:SCREEN-VALUE AND
                          x_as.Partition NE AppSrv-TT.Partition
                    NO-ERROR.
    IF AVAILABLE x_as THEN DO:
      ASSIGN AppSrv-TT.HOST = x_as.HOST
             AppSrv-TT.Service = x_as.Service
             AppSrv-TT.Configuration = x_as.Configuration
             AppSrv-TT.Security = x_as.Security
             AppSrv-TT.Info = x_as.Info.
      DISPLAY AppSrv-TT.Host AppSrv-TT.Service AppSrv-TT.Security
              AppSrv-TT.Info 
        WITH FRAME AS-FRAME.
    END.  /* IF available x_as */
  END.  /* If leaving AppService Field */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 AS-Frame
ON ENTRY OF BROWSE-1 IN FRAME AS-Frame
DO:
   orig-name = AppSrv-TT.Partition:SCREEN-VALUE IN BROWSE BROWSE-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 AS-Frame
ON ROW-LEAVE OF BROWSE-1 IN FRAME AS-Frame
DO:
   IF orig-name NE AppSrv-TT.Partition:SCREEN-VALUE IN BROWSE BROWSE-1
     THEN askCommit = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 AS-Frame
ON VALUE-CHANGED OF BROWSE-1 IN FRAME AS-Frame
DO:
  RUN update-old-record.
  RUN display-record.
  IF AVAILABLE AppSrv-TT THEN old-rowid = ROWID(AppSrv-TT).
  APPLY "ENTRY" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Add AS-Frame
ON CHOOSE OF btn-Add IN FRAME AS-Frame /* Add... */
DO:
  RUN update-old-record.
  run protools/addpart.w.
  {&OPEN-QUERY-BROWSE-1}
  RUN display-record.
  IF AVAILABLE AppSrv-TT THEN DO:
    old-rowid = ROWID(AppSrv-TT).
    btn-REMOVE:SENSITIVE IN FRAME {&FRAME-NAME} = (AVAILABLE AppSrv-TT).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Remove AS-Frame
ON CHOOSE OF btn-Remove IN FRAME AS-Frame /* Remove */
DO:
  DELETE AppSrv-TT.
  {&OPEN-QUERY-BROWSE-1}
  RUN display-record.
  IF AVAILABLE AppSrv-TT THEN old-rowid = ROWID(AppSrv-TT).
  ASSIGN SELF:SENSITIVE = (AVAILABLE AppSrv-TT)
         askCommit      = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help AS-Frame
ON CHOOSE OF Btn_Help IN FRAME AS-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("ptls":U,"CONTEXT":U, {&AppServer_Partition}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK AS-Frame
ON CHOOSE OF Btn_OK IN FRAME AS-Frame /* OK */
DO:
  DEFINE VARIABLE ans AS LOGICAL                              NO-UNDO.

  RUN update-old-record.

  IF askCommit THEN DO:  /* Something has changed */  
    MESSAGE "The partition setup has been changed only for this session." SKIP
            "Do you want to save these partition setups permanently" SKIP
            "for future sessions?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET ans.
    IF ans THEN DO:
      OUTPUT TO appsrvtt.d.
      FOR EACH AppSrv-TT NO-LOCK:
        /* This next 3 lines shouldn't be necessary, but there seems to be a bug
           in the updatable browse */
        IF AppSrv-TT.App-Service = "" AND AppSrv-TT.Host = "" AND
           AppSrv-TT.Service = "" AND AppSrv-TT.Configuration = NO THEN
          DELETE AppSrv-TT.
        ELSE
          EXPORT AppSrv-TT.Partition
                 AppSrv-TT.Host
                 AppSrv-TT.Service
                 AppSrv-TT.Configuration
                 AppSrv-TT.Security
                 AppSrv-TT.Info
                 AppSrv-TT.App-Service.
      END.  /* For Each */
      OUTPUT CLOSE.
    END.  /* If ans */
  END.  /* If askCommit */
END.  /* On choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK AS-Frame 


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
  RUN display-record.
  IF AVAILABLE AppSrv-TT THEN old-rowid = ROWID(AppSrv-TT).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI AS-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME AS-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-record AS-Frame 
PROCEDURE display-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF AVAILABLE AppSrv-TT THEN DO:
    RS-Config = AppSrv-TT.Configuration.
    DISPLAY AppSrv-TT.App-Service AppSrv-TT.Host AppSrv-TT.Service
            RS-Config AppSrv-TT.Security AppSrv-TT.Info 
      WITH FRAME AS-Frame.
    ENABLE BROWSE-1 AppSrv-TT.App-Service 
           AppSrv-TT.Host AppSrv-TT.Service RS-Config
           AppSrv-TT.Security AppSrv-TT.Info 
           Btn_OK Btn_Cancel btn-Add btn-Remove Btn_Help
      WITH FRAME AS-Frame.
  END.  /* If we have an AppSrv-TT record */
  ELSE DO WITH FRAME {&FRAME-NAME}:
    ASSIGN AppSrv-TT.App-Service:SCREEN-VALUE   = ""
           AppSrv-TT.App-Service:SENSITIVE      = FALSE
           btn-Remove:SENSITIVE                 = FALSE 
           AppSrv-TT.Host:SCREEN-VALUE          = ""
           AppSrv-TT.Host:SENSITIVE             = FALSE
           AppSrv-TT.Service:SCREEN-VALUE       = "" 
           AppSrv-TT.Service:SENSITIVE          = FALSE 
           RS-Config:SCREEN-VALUE               = STRING(FALSE)
           RS-Config:SENSITIVE                  = FALSE
           AppSrv-TT.Security:CHECKED           = FALSE
           AppSrv-TT.Security:SENSITIVE         = FALSE
           AppSrv-TT.Info:SCREEN-VALUE          = "" 
           AppSrv-TT.Info:SENSITIVE             = FALSE. 
  END.  /* There are no AppSrv-TT records */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI AS-Frame  _DEFAULT-ENABLE
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
  DISPLAY RS-Config Info-lbl 
      WITH FRAME AS-Frame.
  IF AVAILABLE AppSrv-TT THEN 
    DISPLAY AppSrv-TT.App-Service AppSrv-TT.Host AppSrv-TT.Service 
          AppSrv-TT.Security AppSrv-TT.Info 
      WITH FRAME AS-Frame.
  ENABLE RECT-1 BROWSE-1 Btn_OK Btn_Cancel btn-Add btn-Remove 
         AppSrv-TT.App-Service Btn_Help AppSrv-TT.Host AppSrv-TT.Service 
         RS-Config AppSrv-TT.Security AppSrv-TT.Info 
      WITH FRAME AS-Frame.
  VIEW FRAME AS-Frame.
  {&OPEN-BROWSERS-IN-QUERY-AS-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-old-record AS-Frame 
PROCEDURE update-old-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND x_as WHERE ROWID(x_AS) = old-rowid NO-ERROR.
  
  IF AVAILABLE x_as THEN DO WITH FRAME AS-FRAME:
    /* To ensure a clean run next time, disconnect the AppServer. */
    RUN appServerDisconnect(x_as.Partition).
    
    IF x_as.App-Service   NE AppSrv-TT.App-Service:SCREEN-VALUE  OR
       x_as.Host          NE AppSrv-TT.Host:SCREEN-VALUE         OR
       x_as.Service       NE AppSrv-TT.Service:SCREEN-VALUE      OR
       x_as.Configuration NE (RS-Config:SCREEN-VALUE = "yes":U)  OR
       x_as.Security      NE AppSrv-TT.Security:CHECKED          OR
       x_as.Info          NE AppSrv-TT.Info:SCREEN-VALUE
      THEN askCommit = yes.


    ASSIGN x_as.App-Service   = AppSrv-TT.App-Service:SCREEN-VALUE
           x_as.Host          = AppSrv-TT.Host:SCREEN-VALUE 
           x_as.Service       = AppSrv-TT.Service:SCREEN-VALUE
           x_as.Configuration = (RS-Config:SCREEN-VALUE = "yes":U)
           x_as.Security      = AppSrv-TT.Security:CHECKED
           x_as.Info          = AppSrv-TT.Info:SCREEN-VALUE.

    /* Now update other rows sharing the same App-Service */
    FOR EACH x_as2 WHERE x_as2.App-Service = x_as.App-Service AND
                         x_as2.Partition  NE x_as.Partition:
    ASSIGN x_as2.Host          = x_as.Host 
           x_as2.Service       = x_as.Service
           x_as2.Configuration = x_as.Configuration
           x_as2.Security      = x_as.Security
           x_as2.Info          = x_as.Info.
    END.  /* For each x_as2 */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


