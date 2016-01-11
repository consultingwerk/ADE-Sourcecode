&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ASInfo
{adecomm/appserv.i}
DEFINE VARIABLE h_aaaa                     AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_asbroker1                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_sports2000partition      AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ASInfo 
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

  File: _ASInfo.w

  Description: AppServer Information PRO*Tool

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 11/19/98
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/
{adecomm/appsrvtt.i "NEW GLOBAL"} /* Partition info temp table defn */
{adecomm/appserv.i}
{protools/ptlshlp.i} /* Pro*Tools help contexts */
{adecomm/_adetool.i}

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h AS HANDLE NO-UNDO. /* server handle */

DEFINE TEMP-TABLE OtherAS
    FIELD ASName AS CHARACTER
    FIELD hAS    AS HANDLE
    INDEX iAS IS PRIMARY AsName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ASInfo

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS AppService Btn_GetInfo connid connctxt ~
ASppath conndbs connpps Btn_Close Btn_Help RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS AppService connid opmode connreq connbnd ~
connctxt ASppath conndbs connpps 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close AUTO-GO 
     LABEL "&Close" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_GetInfo 
     LABEL "&Get Info" 
     SIZE 15 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE AppService AS CHARACTER FORMAT "X(256)":U 
     LABEL "Partition" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE connctxt AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 75 BY 3 NO-UNDO.

DEFINE VARIABLE connbnd AS LOGICAL FORMAT "yes/no":U INITIAL NO 
     LABEL "Connection Bound" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE connid AS CHARACTER FORMAT "X(256)":U 
     LABEL "Connection Id" 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE connreq AS LOGICAL FORMAT "yes/no":U INITIAL NO 
     LABEL "Connection Bound Req." 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE opmode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operating Mode" 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 8.1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 5.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 5.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 5.71.

DEFINE VARIABLE ASppath AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 75 BY 5 NO-UNDO.

DEFINE VARIABLE conndbs AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 35 BY 5 NO-UNDO.

DEFINE VARIABLE connpps AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 35 BY 5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ASInfo
     AppService AT ROW 1.48 COL 10 COLON-ALIGNED
     Btn_GetInfo AT ROW 1.48 COL 67
     connid AT ROW 3.62 COL 27 COLON-ALIGNED
     opmode AT ROW 4.81 COL 27 COLON-ALIGNED
     connreq AT ROW 6 COL 27 COLON-ALIGNED
     connbnd AT ROW 6 COL 71 COLON-ALIGNED
     connctxt AT ROW 7.91 COL 5 NO-LABEL
     ASppath AT ROW 12.19 COL 5 NO-LABEL
     conndbs AT ROW 18.38 COL 5 NO-LABEL
     connpps AT ROW 18.38 COL 45 NO-LABEL
     Btn_Close AT ROW 1.48 COL 83
     Btn_Help AT ROW 2.91 COL 83
     RECT-1 AT ROW 3.14 COL 3
     RECT-2 AT ROW 11.71 COL 3
     RECT-3 AT ROW 17.91 COL 43
     RECT-4 AT ROW 17.91 COL 3
     "Connection Context" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 7.19 COL 5
     "Server-side session attributes" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 2.91 COL 5
     "Running persistent procedures" VIEW-AS TEXT
          SIZE 29 BY .62 AT ROW 17.67 COL 45
     "Propath" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 11.48 COL 5
     "Connected Databases" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 17.67 COL 5
     SPACE(71.79) SKIP(5.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "AppServer Session Information"
         DEFAULT-BUTTON Btn_Close.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ASInfo
   Custom                                                               */
ASSIGN 
       FRAME ASInfo:SCROLLABLE       = FALSE
       FRAME ASInfo:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN connbnd IN FRAME ASInfo
   NO-ENABLE                                                            */
ASSIGN 
       connctxt:READ-ONLY IN FRAME ASInfo        = TRUE.

ASSIGN 
       connid:READ-ONLY IN FRAME ASInfo        = TRUE.

/* SETTINGS FOR FILL-IN connreq IN FRAME ASInfo
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN opmode IN FRAME ASInfo
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ASInfo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ASInfo ASInfo
ON WINDOW-CLOSE OF FRAME ASInfo /* AppServer Session Information */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AppService
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AppService ASInfo
ON VALUE-CHANGED OF AppService IN FRAME ASInfo /* Partition */
DO:
  IF AppService NE AppService:SCREEN-VALUE THEN DO:
    /* Clear out the contents of the dialog */
    CLEAR FRAME {&FRAME-NAME} NO-PAUSE.
    ASSIGN 
      asppath:LIST-ITEMS = ? 
      conndbs:LIST-ITEMS = ?
      connpps:LIST-ITEMS = ?
    .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_GetInfo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_GetInfo ASInfo
ON CHOOSE OF Btn_GetInfo IN FRAME ASInfo /* Get Info */
DO:
  DEFINE VARIABLE ppath   AS CHARACTER NO-UNDO. /* receives Propath */
  DEFINE VARIABLE dbs     AS CHARACTER NO-UNDO. /* receives List of Databases */
  DEFINE VARIABLE pprocs  AS CHARACTER NO-UNDO. /* receives List of Running Persistent Procedures */
  DEFINE VARIABLE addme   AS LOGICAL   NO-UNDO INITIAL TRUE. /* answer to question below */
  DEFINE VARIABLE hAsynch AS HANDLE    NO-UNDO. /* handle to asynch run */
  DEFINE VARIABLE scid    AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-CONNECTION-ID */
  DEFINE VARIABLE som     AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-OPERATING-MODE */
  DEFINE VARIABLE scbr    AS LOGICAL   NO-UNDO. /* receives SESSION:SERVER-CONNECTION-BOUND-REQUEST */
  DEFINE VARIABLE scb     AS LOGICAL   NO-UNDO. /* receives SESSION:SERVER-CONNECTION-BOUND */
  DEFINE VARIABLE scc     AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-CONNECTION-CONTEXT */
  DEFINE VARIABLE useconn AS LOGICAL   NO-UNDO. /* indicates whether or not we used an existing connection from AppServ-TT */ 
  
  ASSIGN AppService.
  FIND FIRST AppSrv-TT WHERE Partition = AppService NO-LOCK NO-ERROR.
  IF AVAILABLE(AppSrv-TT) THEN 
  DO:
    IF NOT AppSrv-TT.Configuration THEN DO: /* Local */
      MESSAGE "The AppService" AppSrv-TT.App-Service "is defined as being local." SKIP
              "This session's information will be displayed." 
              VIEW-AS ALERT-BOX INFORMATION TITLE "AppServer Session Information".
      ASSIGN h = SESSION:HANDLE. 
    END.
    ELSE DO: /* Remote */          
      ASSIGN useconn = FALSE. 
      /* Connect to the AppServer */
      RUN appServerConnect(
        INPUT AppSrv-TT.Partition, 
        INPUT AppSrv-TT.Security, 
        INPUT AppSrv-TT.Info,
        OUTPUT h) NO-ERROR.
      /* if both of these conditions are true then cancel must have been pressed */
      IF h = ? AND RETURN-VALUE = 'ERROR':U 
          THEN RETURN NO-APPLY.
      IF h = SESSION:HANDLE THEN DO:
        MESSAGE "Could not access connection to AppService" AppSrv-TT.App-Service 
                VIEW-AS ALERT-BOX INFORMATION TITLE "AppServer Session Information".
        RETURN NO-APPLY. 
      END.
    END.      
  END.
  ELSE DO:  
    ASSIGN useconn = FALSE.
    /* Look for connections in alternative list */
    FIND FIRST OtherAS WHERE AppService = OtherAS.ASName NO-ERROR.
    IF AVAILABLE OtherAS THEN 
      ASSIGN h = OtherAS.hAS.
    ELSE DO:
      MESSAGE "A server by the name of" AppService:SCREEN-VALUE "was not found."
        VIEW-AS ALERT-BOX ERROR TITLE "AppServer Session Information".
      RETURN NO-APPLY.
    END.
  END.
  /* Are there any asynchronous requests oustanding on this AppServer? */
  IF h:ASYNC-REQUEST-COUNT > 0 THEN DO:
      MESSAGE "There are currently " TRIM(STRING(h:ASYNC-REQUEST-COUNT,">>>9")) 
          " asynchronous requests queued for this AppServer." SKIP 
          "Do you want to continue?" 
          VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE addme.
  END.
  /* 
   * Gather up information from companion program running asynchronously
   * on SERVER h 
   */
  IF addme THEN DO:
      RUN adecomm/_asread.p ON SERVER h 
        ASYNCHRONOUS SET hAsynch
        EVENT-PROCEDURE "ASInfo":U
       (OUTPUT scid,     /* SESSION:SERVER-CONNECTION-ID */
        OUTPUT som,      /* SESSION:SERVER-OPERATING-MODE */
        OUTPUT scbr,     /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
        OUTPUT scb,      /* SESSION:SERVER-CONNECTION-BOUND */
        OUTPUT scc,      /* SESSION:SERVER-CONNECTION-CONTEXT */
        OUTPUT ppath,    /* PROPATH */
        OUTPUT dbs,      /* List of Databases */
        OUTPUT pprocs).  /* List of Running Persistent Procedures */
  
      WAIT-FOR PROCEDURE-COMPLETE OF hAsynch.
  END.
  
  IF AVAILABLE(AppSrv-TT) AND NOT useconn THEN
    /* Disconnect and destroy handle to the AppServer */
    RUN appServerDisconnect(
      INPUT AppSrv-TT.Partition).
END.


PROCEDURE ASInfo:
    /* 
     * Event procedure for the asnych call we made to _asread 
     * If receives, assigns and displays the data received.   
     */
    DEFINE INPUT PARAMETER scid    AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-CONNECTION-ID */
    DEFINE INPUT PARAMETER som     AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-OPERATING-MODE */
    DEFINE INPUT PARAMETER scbr    AS LOGICAL   NO-UNDO. /* receives SESSION:SERVER-CONNECTION-BOUND-REQUEST */
    DEFINE INPUT PARAMETER scb     AS LOGICAL   NO-UNDO. /* receives SESSION:SERVER-CONNECTION-BOUND */
    DEFINE INPUT PARAMETER scc     AS CHARACTER NO-UNDO. /* receives SESSION:SERVER-CONNECTION-CONTEXT */
    DEFINE INPUT PARAMETER ppath   AS CHARACTER NO-UNDO. /* PROPATH */
    DEFINE INPUT PARAMETER dbs     AS CHARACTER NO-UNDO. /* List of Databases */
    DEFINE INPUT PARAMETER pprocs  AS CHARACTER NO-UNDO. /* Load selection lists */
    
    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN 
          connid   = scid
          opmode   = som 
          connreq  = scbr 
          connbnd  = scb 
          connctxt = scc
          asppath:LIST-ITEMS = ppath 
          conndbs:LIST-ITEMS = dbs
          connpps:LIST-ITEMS = pprocs
        .
        DISPLAY connid opmode connreq connbnd connctxt ASppath conndbs connpps WITH
          FRAME {&FRAME-NAME}.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help ASInfo
ON CHOOSE OF Btn_Help IN FRAME ASInfo /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("ptls":U,"CONTEXT":U, {&AppServer_Session_Information}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ASInfo 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN PopulateAppService.
  IF RETURN-VALUE = "NONE":U THEN DO:
    MESSAGE "There are no AppServers currently defined." SKIP
            "You can define them with the Service Parameter Maintenance tool."
            VIEW-AS ALERT-BOX ERROR
            TITLE "AppServer Session Information".
    RETURN.
  END.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ASInfo  _DEFAULT-DISABLE
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
  HIDE FRAME ASInfo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ASInfo  _DEFAULT-ENABLE
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
  DISPLAY AppService connid opmode connreq connbnd connctxt ASppath conndbs 
          connpps 
      WITH FRAME ASInfo.
  ENABLE AppService Btn_GetInfo connid connctxt ASppath conndbs connpps 
         Btn_Close Btn_Help RECT-1 RECT-2 RECT-3 RECT-4 
      WITH FRAME ASInfo.
  VIEW FRAME ASInfo.
  {&OPEN-BROWSERS-IN-QUERY-ASInfo}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PopulateAppService ASInfo 
PROCEDURE PopulateAppService :
/*------------------------------------------------------------------------------
  Purpose:     Populates the AppService combo-box with defined AppServers.
  Parameters:  <none>
  Notes:       Returns "NONE" if no AppServers are defined.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hServ     AS HANDLE NO-UNDO.
DEFINE VARIABLE hServName AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:  
  /* Load up definitions from the Appserver PRO*Tool */
  AppService:DELIMITER = CHR(3).
  AppService:LIST-ITEMS = DYNAMIC-FUNCTION('definedPartitions':U IN appSrvUtils) .
  AppService:DELIMITER = ',':U.
      
  /* Also load up any AppServer connections which were created outside of the tool */
  ASSIGN hServ = SESSION:FIRST-SERVER.
  DO WHILE VALID-HANDLE(hServ):
    /* check if it's already active in the other list */
    FIND FIRST AppSrv-TT WHERE hServ = AppSrv-TT.AS-Handle NO-ERROR.
    IF NOT AVAILABLE AppSrv-TT THEN DO: /* If not, add it */
      IF hServ:NAME <> ? AND hServ:NAME <> "" THEN 
      DO: /* If we find one, we'll display the name off the handle and add it to our list */
        IF NUM-ENTRIES(hServ:NAME,":":U) >= 2 THEN DO:
          /*
           * If the handle is not in AppSrv-TT, it has an ugly name delimited by "::". 
           * Let's create a friendly one 
           */
          ASSIGN hServName = ENTRY(3,hServ:NAME,":":U) + " on " + ENTRY(1,hServ:NAME,":":U).
        END.
        ELSE
          ASSIGN hServName = hServ:NAME. /* Not sure what it is, so let's leave it alone */
        AppService:ADD-LAST(hServName).
        CREATE OtherAS.
        ASSIGN ASName = hServName
               hAS    = hServ.
      END.  
    END.
    hServ = hServ:NEXT-SIBLING.
  END.
  
  IF AppService:LIST-ITEMS <> ? THEN 
    AppService:SCREEN-VALUE = AppService:ENTRY(1).
  ELSE
    RETURN "NONE":U.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

