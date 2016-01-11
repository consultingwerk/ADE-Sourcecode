&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w_cfg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w_cfg 
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
/*------------------------------------------------------------------------

  File: _PROCFG.W

  Description: Display PROGRESS.CFG information

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 01/08/95 -  3:51 pm

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
{ adecomm/_adetool.i }
{ protools/ptlshlp.i } /* help definitions */
{ protools/_runonce.i }

DEFINE TEMP-TABLE cfg
    FIELD product         AS CHARACTER FORMAT "X(28)" COLUMN-LABEL "Product!Name"
    FIELD install_date    AS CHARACTER FORMAT "X(30)" LABEL "Install Date"
    FIELD user_limit      AS INTEGER   FORMAT ">,>>9" LABEL "User Limit"
    FIELD expiration_date AS CHARACTER FORMAT "X(30)" LABEL "Expire Date"
    FIELD serial_number   AS CHARACTER FORMAT "X(11)" COLUMN-LABEL "Serial!Number"
    FIELD control_numbers AS CHARACTER FORMAT "X(25)" LABEL "Control Numbers"
    FIELD version_number  AS CHARACTER FORMAT "X(8)"  LABEL "Version Number"
    FIELD machine_class   AS CHARACTER FORMAT "X(4)"  LABEL "Machine Class"
    FIELD port_number     AS INTEGER   FORMAT ">>9"   LABEL "Port Number".
    
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */   
DEFINE VARIABLE rc AS INTEGER NO-UNDO. /* return code */

&IF LOOKUP(OPSYS, "MSDOS,WIN32") = 0 &THEN
    &SCOPED-DEFINE SLASH /
&ELSE 
    &SCOPED-DEFINE SLASH ~~~\
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_cfg
&Scoped-define BROWSE-NAME b_cfg

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cfg

/* Definitions for BROWSE b_cfg                                         */
&Scoped-define FIELDS-IN-QUERY-b_cfg cfg.product cfg.serial_number 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b_cfg 
&Scoped-define OPEN-QUERY-b_cfg OPEN QUERY b_cfg FOR EACH cfg NO-LOCK ~
    BY cfg.product.
&Scoped-define FIRST-TABLE-IN-QUERY-b_cfg cfg
&Scoped-define TABLES-IN-QUERY-b_cfg cfg

/* Definitions for FRAME f_cfg                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f_cfg ~
    ~{&OPEN-QUERY-b_cfg}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_cfg b_Close b_Help r_cfg 
&Scoped-Define DISPLAYED-FIELDS cfg.control_numbers cfg.expiration_date ~
cfg.install_date cfg.machine_class cfg.port_number cfg.user_limit ~
cfg.version_number 
&Scoped-Define DISPLAYED-OBJECTS company 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w_cfg AS WIDGET-HANDLE NO-UNDO.
DEFINE BUTTON b_Close 
     LABEL "&Close" 
     SIZE 15 BY 1.125.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.125.

DEFINE VARIABLE company AS CHARACTER FORMAT "X(256)":U 
     LABEL "Company Name" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1 NO-UNDO.

DEFINE RECTANGLE r_cfg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 8.

DEFINE RECTANGLE r_splash
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.89 BY 4.47.


&ANALYZE-SUSPEND
/* Query definitions                                                    */
DEFINE QUERY b_cfg FOR 
      cfg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b_cfg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b_cfg w_cfg _STRUCTURED
  QUERY b_cfg NO-LOCK DISPLAY
      cfg.product
      cfg.serial_number
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SIZE 44.5 BY 8.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_cfg
     company AT ROW 1.28 COL 16 COLON-ALIGNED
     b_cfg AT ROW 3 COL 2
     cfg.install_date AT ROW 3.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY 1
          FONT 4
     cfg.user_limit AT ROW 4.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.89 BY 1
          FONT 4
     cfg.expiration_date AT ROW 5.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY 1
          FONT 4
     cfg.control_numbers AT ROW 6.47 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY 1
          FONT 4
     cfg.version_number AT ROW 7.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.11 BY 1
          FONT 4
     cfg.machine_class AT ROW 8.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.11 BY 1
          FONT 4
     cfg.port_number AT ROW 9.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.56 BY 1
          FONT 4
     b_Close AT ROW 11.22 COL 31
     b_Help AT ROW 11.22 COL 51
     " Product Configuration Information" VIEW-AS TEXT
          SIZE 33 BY .88 AT ROW 2.5 COL 48
     r_cfg AT ROW 3 COL 47
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87 BY 12
         DEFAULT-BUTTON b_Close.

DEFINE FRAME f_splash
     r_splash AT ROW 1.13 COL 1
     "PROGRESS Configuration File Browser" VIEW-AS TEXT
          SIZE 37 BY .84 AT ROW 1.66 COL 3
     "Version 1.0" VIEW-AS TEXT
          SIZE 12 BY .66 AT ROW 2.66 COL 16
     "Attempting to read PROGRESS.CFG file..." VIEW-AS TEXT
          SIZE 38 BY .88 AT ROW 4.16 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COL 26.22 ROW 4.13
         SIZE 41.57 BY 4.92.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w_cfg ASSIGN
         HIDDEN             = YES
         TITLE              = "PROGRESS Configuration File"
         HEIGHT             = 12
         WIDTH              = 88
         MAX-HEIGHT         = 12
         MAX-WIDTH          = 88
         VIRTUAL-HEIGHT     = 12
         VIRTUAL-WIDTH      = 88
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         MAX-BUTTON         = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT w_cfg:LOAD-ICON("adeicon/cnfginfo") THEN
    MESSAGE "Unable to load icon: adeicon/cnrginfo"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w_cfg
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FILL-IN company IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.control_numbers IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.expiration_date IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.install_date IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.machine_class IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.port_number IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.user_limit IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cfg.version_number IN FRAME f_cfg
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f_splash
   NOT-VISIBLE UNDERLINE                                                */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w_cfg)
THEN w_cfg:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b_cfg
/* Query rebuild information for BROWSE b_cfg
     _TblList          = "sports.cfg"
     _Options          = "NO-LOCK"
     _OrdList          = "sports.cfg.product|yes"
     _FldNameList[1]   = sports.cfg.product
     _FldNameList[2]   = sports.cfg.serial_number
     _Query            is OPENED
*/  /* BROWSE b_cfg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f_splash
/* Query rebuild information for FRAME f_splash
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f_splash */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME b_cfg
&Scoped-define SELF-NAME b_cfg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_cfg w_cfg
ON VALUE-CHANGED OF b_cfg IN FRAME f_cfg
DO:
  RUN Display_Details.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Close w_cfg
ON CHOOSE OF b_Close IN FRAME f_cfg /* Close */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help w_cfg
ON CHOOSE OF b_Help IN FRAME f_cfg /* Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Configuration_File}, ? ).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w_cfg 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Adjust for Win95 font */
IF SESSION:PIXELS-PER-COLUMN = 5 THEN
  ASSIGN {&WINDOW-NAME}:WIDTH      = 94
         FRAME {&FRAME-NAME}:WIDTH = 93
         r_cfg:WIDTH               = 47
         cfg.install_date:WIDTH    = 24
         cfg.control_numbers:WIDTH = 28
         FRAME f_splash:WIDTH      = 42
         r_splash:WIDTH            = 42
  .
         
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

VIEW FRAME f_splash.
RUN Get_CFG(OUTPUT rc).
IF rc > 0 THEN DO:
    IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
    RETURN. /* error */
END.
ASSIGN FRAME f_splash:HIDDEN = yes.
HIDE FRAME f_splash.

STATUS DEFAULT "Select product or click Close to exit.".  
STATUS INPUT  "Select product or click Close to exit.". 
/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF CAN-FIND (FIRST cfg) THEN DO:
    IF b_cfg:SELECT-ROW(1) THEN.
    APPLY "VALUE-CHANGED" TO b_cfg IN FRAME {&FRAME-NAME}.
  END.
  APPLY "ENTRY" TO b_cfg.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w_cfg _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET w_cfg.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display_Details w_cfg 
PROCEDURE Display_Details :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DISPLAY cfg.control_numbers cfg.expiration_date cfg.install_date 
        cfg.machine_class cfg.port_number cfg.user_limit cfg.version_number  
        WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w_cfg _DEFAULT-ENABLE
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
  DISPLAY company 
      WITH FRAME f_cfg IN WINDOW w_cfg.
  IF AVAILABLE cfg THEN 
    DISPLAY cfg.install_date cfg.user_limit cfg.expiration_date 
          cfg.control_numbers cfg.version_number cfg.machine_class 
          cfg.port_number 
      WITH FRAME f_cfg IN WINDOW w_cfg.
  ENABLE b_cfg r_cfg b_Close b_Help 
      WITH FRAME f_cfg IN WINDOW w_cfg.
  {&OPEN-BROWSERS-IN-QUERY-f_cfg}
  ENABLE r_splash 
      WITH FRAME f_splash IN WINDOW w_cfg.
  {&OPEN-BROWSERS-IN-QUERY-f_splash}
  VIEW w_cfg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_CFG w_cfg 
PROCEDURE Get_CFG :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER rc AS INTEGER   NO-UNDO INITIAL 0.
    DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE batchfile  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE outputfile AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dlcvalue   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE showcfgloc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cfgline    AS CHARACTER NO-UNDO FORMAT "X(255)".
    DEFINE VARIABLE cmd        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cfgfile    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE unixshell  AS CHARACTER NO-UNDO.
    
    RUN adecomm/_setcurs.p ("WAIT").

    /* Delete previous temp-table records. */
    FOR EACH cfg:
        DELETE cfg.
    END.
      
    /* Determine DLC path. */
    GET-KEY-VALUE SECTION "Startup" KEY "DLC" VALUE dlcvalue.
    IF dlcvalue = ? OR dlcvalue = "" THEN
        ASSIGN dlcvalue   = OS-GETENV("DLC").           
    ASSIGN batchfile  = SESSION:TEMP-DIRECTORY + "cfg.bat".
    ASSIGN outputfile = SESSION:TEMP-DIRECTORY + "cfg.out".
    IF OPSYS = "UNIX" THEN unixshell = OS-GETENV("SHELL").
    OS-DELETE VALUE(batchfile).
    OS-DELETE VALUE(outputfile). 

    /* Determine PROCFG path and filename. */
    GET-KEY-VALUE SECTION "Startup" KEY "PROCFG" VALUE cfgfile.
    IF cfgfile = ? OR cfgfile = "" THEN
    DO:
      ASSIGN cfgfile = OS-GETENV("PROCFG").
      IF cfgfile = ? THEN
        ASSIGN cfgfile = dlcvalue + "{&SLASH}" + "progress.cfg".
    END.

    /* Determine showcfg executable name. */
    ASSIGN showcfgloc = SEARCH("showcfg").
    IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
        ASSIGN showcfgloc = SEARCH("showcfgd.exe").
    ELSE ASSIGN showcfgloc = SEARCH("showcfg").
    IF showcfgloc = ? THEN 
        ASSIGN showcfgloc = dlcvalue + "{&SLASH}" + "bin" + "{&SLASH}" +
                            (IF LOOKUP(OPSYS , "MSDOS,WIN32":U) > 0
                                THEN "showcfgd"
                                ELSE "showcfg").

    /* Create cfg.bat which we'll run to capture the output of showcfg exe
       in cfg.out. We will then read cfg.out and display it to the user in
       a friendly interface. */
    OUTPUT TO VALUE(batchfile). /* cfg.bat */
    IF cfgfile NE ? OR cfgfile NE "" THEN 
        PUT UNFORMATTED "set PROCFG=" + '"' + cfgfile + '"' SKIP.
    PUT UNFORMATTED '"' + showcfgloc + '"' + " " + '"' + cfgfile + '"' + " > " + '"' + outputfile + '"' SKIP.
    OUTPUT CLOSE.
    
    /* Execute the batch file and read the cfg.out file. */
    ASSIGN cmd = (IF OPSYS = "unix" THEN unixshell + " " ELSE "") + '"' + batchfile + '"'.
    OS-COMMAND SILENT VALUE(cmd).
    
    IF SEARCH(outputfile) <> ? THEN DO:
        INPUT FROM VALUE(outputfile) NO-ECHO.
        DO i = 1 to 4:
            IMPORT UNFORMATTED cfgline.
            ASSIGN cfgline = TRIM(cfgline).
            IF SUBSTRING(cfgline,1,19) = "Configuration file:" THEN
                ASSIGN {&WINDOW-NAME}:TITLE = "PROGRESS Configuration File - "
                        + TRIM(SUBSTRING(cfgline,21)).
            ELSE IF SUBSTRING(cfgline,1,13) = "Company Name:" THEN
                ASSIGN company = TRIM(SUBSTRING(cfgline,15)).
            ELSE IF SUBSTRING(cfgline,1,6) = "Error:" THEN
            DO: /* Bad thing happened */
                MESSAGE cfgline skip 
                        "Try setting the PROCFG environment variable in your O/S environment."
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RUN adecomm/_setcurs.p ("").
                ASSIGN rc = 1.
                RETURN.
            END.
        END.
        REPEAT:
            IMPORT UNFORMATTED cfgline.
            ASSIGN cfgline = TRIM(cfgline).
            CASE substring(cfgline,1,2):
                WHEN 'Pr' THEN DO:
                    CREATE cfg.
                    ASSIGN cfg.product = TRIM(SUBSTRING(cfgline,15)).
                END.
                WHEN 'In' THEN
                    ASSIGN cfg.install_date = TRIM(SUBSTRING(cfgline,20)).
                WHEN 'Us' THEN
                    ASSIGN cfg.user_limit = INTEGER(SUBSTRING(cfgline,13)).
                WHEN 'Ex' THEN
                    ASSIGN cfg.expiration_date = TRIM(SUBSTRING(cfgline,18)).
                WHEN 'Se' THEN
                    ASSIGN cfg.serial_number = TRIM(SUBSTRING(cfgline,16)).
                WHEN 'Co' THEN
                    ASSIGN cfg.control_numbers = TRIM(SUBSTRING(cfgline,18)).
                WHEN 'Ve' THEN
                    ASSIGN cfg.version_number = TRIM(SUBSTRING(cfgline,17)).
                WHEN 'Ma' THEN
                    ASSIGN cfg.machine_class = TRIM(SUBSTRING(cfgline,16)).
                WHEN 'Po' THEN
                    ASSIGN cfg.port_number = INTEGER(TRIM(SUBSTRING(cfgline,14))).
            END CASE.
        END.
        INPUT CLOSE.
        RUN adecomm/_setcurs.p ("").
    END. 
    ELSE DO:
        MESSAGE "Program was not able to extract configuration information."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RUN adecomm/_setcurs.p ("").
        ASSIGN rc = 1.
        RETURN.
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




