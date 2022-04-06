&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Basic Dialog-Box Template

Use this template to create a new dialog-box. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Connect 
/*********************************************************************
* Copyright (C) 2000,2009 by Progress Software Corporation. All rights*
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _dbconng.w  

Description:
   Display and handle the connect dialog box, doing the connection
   if the user presses OK. GUI only. adecomm/_dbconnc.p is called for
   character mode.
 
Input Parameters:
   p_Connect - whether the CONNECT should be executed
   
Input/Output Parameters:

   On input:  A value is supplied if known, otherwise, the value is ?
   On output: If connect succeeded, all values are set.  If more than one
              database is connected (via -db parms), the information is
              set for the first one that was connected successfully.
              If connect failed or if the user cancelled, PName and LName 
              are set to ?.
   
   p_PName        - the physical name of the database
   p_LName        - the logical name of the database
   p_Type         - the database type (e.g., PROGRESS, ORACLE) (internal name)
   p_Multi_User   - connect in single user (no) or multi-user (yes) mode
   p_Network      - network type - initial selection only.
   p_Host_Name    - host name
   p_Service_Name - service name
   p_UserId       - user id
   p_Password     - password
   p_Unix_Parms   - any other parms 

Output Parameters:
   p_args   - this is the argument string built for the connect
 
Author:  John Palazzo
Created: 04/14/95
         From older GUI and the current character version _dbconnx.p
         by Laura Stern.

Modified:
    fernando  05/06/09  support for manual start encryption
    mcmann    02/19/03  Removed AS400SNA
    jep       02/05/02  Issue 3656 : Not enough space for frames in XP
    mcmann    12/17/98  Removed other obsolete networks protocols
    mcmann    07/16/98  Removed AS400LFP from supported networks
    mcmann    05/04/98  Added check for length and spaces to logical name
                        98-04-02-053
    hutegger    97/03   put on stop phrase around connect
    jep         95/08   Enabled Host Name and Service Name fields even when
                        Network field is "(None)".
    hutegger    95/08   add -ld, -H, -S, -dt params only if logical
                        and/or physical dbname available
                        (sometimes people just enter pf-file. In this
                        case we need to ignore the other parameters)
    rkamboj   08/08/11  fixed issue of login when special chracter in password 
                        at the time of db connect. Applied set-db-client method.

----------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}
IF NOT initialized_adestds THEN
    RUN adecomm/_adeload.p.

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) = 0 &THEN
Define INPUT        parameter p_Connect      as logical   NO-UNDO.
Define INPUT-OUTPUT parameter p_PName        as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_LName        as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Type         as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Multi_User   as logical   NO-UNDO.
Define INPUT-OUTPUT parameter p_Network      as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Host_Name    as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Service_Name as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_UserId       as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Password     as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Trig_Loc     as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Parm_File    as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Unix_Parms   as char      NO-UNDO.
Define OUTPUT       parameter p_args         as char      NO-UNDO.
&ELSE
Define var p_Connect      as logical   NO-UNDO INITIAL YES.
Define var p_PName        as char      NO-UNDO.
Define var p_LName        as char      NO-UNDO.
Define var p_Type         as char      NO-UNDO INITIAL ?.
Define var p_Multi_User   as logical   NO-UNDO.
Define var p_Network      as char      NO-UNDO /*INIT "FAKE-NET"*/.
Define var p_Host_Name    as char      NO-UNDO.
Define var p_Service_Name as char      NO-UNDO.
Define var p_UserId       as char      NO-UNDO.
Define var p_Password     as char      NO-UNDO.
Define var p_Trig_Loc     as char      NO-UNDO.
Define var p_Parm_File    as char      NO-UNDO.
Define var p_Unix_Parms   as char      NO-UNDO.
Define var p_args         as char      NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */

Define variable  capab          as char      NO-UNDO. /* DataServ Cabap's */
Define variable  ext_Type       as char      NO-UNDO.
/*
Define variable  qbf_l_name     as logical   NO-UNDO. /* l-name NOT needed */
*/
Define variable  qbf_p_name     as logical   NO-UNDO. /* p-name NOT needed */
Define variable  enable_host    as logical   NO-UNDO.
Define variable  enable_service as logical   NO-UNDO.
Define variable  None           as char    initial "(None)":U NO-UNDO.
Define variable  Opts_Displayed as logical   NO-UNDO.
Define variable  Dlg_FullH      as integer   NO-UNDO. /* Full Height of Dialog */
Define variable  Dlg_ShortH     as integer   NO-UNDO. /* Short Height of Dialog */
Define variable  Full_First_Time as logical  NO-UNDO initial TRUE.
Define variable  h_parent_win   as handle    NO-UNDO.
DEFINE VARIABLE hCP             AS HANDLE  NO-UNDO.
DEFINE VARIABLE setdbclnt       AS LOGICAL NO-UNDO.
DEFINE VARIABLE currentdb       AS CHAR VIEW-AS TEXT FORMAT "x(32)" NO-UNDO.
/* Miscellaneous */
Define variable  stat           as logical NO-UNDO.
Define variable  ix             as integer NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Connect

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS PName btn_filen btn_OK Btn_Cancel LName ~
btn_Options Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS PName LName DB_Type 

/* Custom List Definitions                                              */
/* OPTIONAL-FIELDS,ENABLE-OPTIONAL,List-3,List-4,List-5,List-6          */
&Scoped-define OPTIONAL-FIELDS Network Multi_User Pass_Phrase Host_Name ~
Service_Name User_Id Pass_word Trig_Loc btn_filep Parm_File btn_filet ~
Unix_Parms Unix_Label 
&Scoped-define ENABLE-OPTIONAL Network Multi_User Pass_Phrase Host_Name ~
Service_Name User_Id Pass_word Trig_Loc btn_filep Parm_File btn_filet ~
Unix_Parms Unix_Label 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btn_filen 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_filep 
     LABEL "Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_filet 
     LABEL "Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btn_Options 
     LABEL "&Options >>" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE Network AS CHARACTER FORMAT "X(256)":U 
     LABEL "Net&work" 
     VIEW-AS COMBO-BOX SORT 
     LIST-ITEMS "(None)","TCP" 
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE Unix_Parms AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 82 BY 3 NO-UNDO.

DEFINE VARIABLE DB_Type AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database Type" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE Host_Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hos&t Name" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE LName AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Logical Name" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE Parm_File AS CHARACTER FORMAT "X(256)":U 
     LABEL "P&arameter File" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE Pass_word AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Password" 
     VIEW-AS FILL-IN 
     SIZE 66 BY 1 NO-UNDO.

DEFINE VARIABLE PName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Physical &Name" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE Service_Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Service Name" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE Trig_Loc AS CHARACTER FORMAT "X(256)":U 
     LABEL "T&rigger Location" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE Unix_Label AS CHARACTER FORMAT "X(256)":U 
     LABEL "Oth&er CONNECT Statement Parameters" 
      VIEW-AS TEXT 
     SIZE 9.8 BY .62 NO-UNDO.

DEFINE VARIABLE User_Id AS CHARACTER FORMAT "X(256)":U 
     LABEL "&User ID" 
     VIEW-AS FILL-IN 
     SIZE 66 BY 1 NO-UNDO.

DEFINE VARIABLE Multi_User AS LOGICAL INITIAL no 
     LABEL "&Multiple Users" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .76 NO-UNDO.

DEFINE VARIABLE Pass_Phrase AS LOGICAL INITIAL no 
     LABEL "Passphrase" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Connect
     PName AT ROW 1.29 COL 18 COLON-ALIGNED
     btn_filen AT ROW 1.29 COL 55
     btn_OK AT ROW 1.29 COL 71
     Btn_Cancel AT ROW 2.57 COL 71
     LName AT ROW 2.62 COL 18 COLON-ALIGNED
     btn_Options AT ROW 4.29 COL 55
     Btn_Help AT ROW 4.29 COL 71
     DB_Type AT ROW 4.33 COL 18 COLON-ALIGNED
     Network AT ROW 5.86 COL 18.2 COLON-ALIGNED
     Multi_User AT ROW 5.86 COL 44
     Pass_Phrase AT ROW 5.86 COL 64
     Host_Name AT ROW 7.19 COL 18 COLON-ALIGNED
     Service_Name AT ROW 7.19 COL 62 COLON-ALIGNED
     User_Id AT ROW 8.52 COL 18 COLON-ALIGNED
     Pass_word AT ROW 9.86 COL 18 COLON-ALIGNED PASSWORD-FIELD 
     Trig_Loc AT ROW 11.24 COL 18 COLON-ALIGNED
     btn_filep AT ROW 11.24 COL 71
     Parm_File AT ROW 12.67 COL 18 COLON-ALIGNED
     btn_filet AT ROW 12.67 COL 71
     Unix_Parms AT ROW 14.81 COL 4 NO-LABEL
     Unix_Label AT ROW 14 COL 1
     SPACE(35.99) SKIP(3.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Connect Database"
         DEFAULT-BUTTON btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Connect
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME Connect:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON btn_filep IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       btn_filep:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR BUTTON btn_filet IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       btn_filet:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN DB_Type IN FRAME Connect
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Host_Name IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Host_Name:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR TOGGLE-BOX Multi_User IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Multi_User:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR COMBO-BOX Network IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Network:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN Parm_File IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Parm_File:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR TOGGLE-BOX Pass_Phrase IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Pass_Phrase:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN Pass_word IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Pass_word:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN Service_Name IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Service_Name:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN Trig_Loc IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Trig_Loc:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR FILL-IN Unix_Label IN FRAME Connect
   NO-DISPLAY NO-ENABLE ALIGN-L 1 2                                     */
ASSIGN 
       Unix_Label:HIDDEN IN FRAME Connect           = TRUE.

/* SETTINGS FOR EDITOR Unix_Parms IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       Unix_Parms:HIDDEN IN FRAME Connect           = TRUE
       Unix_Parms:RETURN-INSERTED IN FRAME Connect  = TRUE.

/* SETTINGS FOR FILL-IN User_Id IN FRAME Connect
   NO-DISPLAY NO-ENABLE 1 2                                             */
ASSIGN 
       User_Id:HIDDEN IN FRAME Connect           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Connect
/* Query rebuild information for DIALOG-BOX Connect
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Connect */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Connect Connect
ON ALT-E OF FRAME Connect /* Connect Database */
ANYWHERE
DO:
  APPLY "ENTRY" TO Unix_Parms IN FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Connect Connect
ON GO OF FRAME Connect /* Connect Database */
DO:
  DO ON ERROR UNDO, RETRY :
    IF RETRY THEN
        RETURN NO-APPLY.
    ELSE
        RUN Pressed_OK.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Connect Connect
ON WINDOW-CLOSE OF FRAME Connect /* Connect Database */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_filen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_filen Connect
ON CHOOSE OF btn_filen IN FRAME Connect /* Browse... */
DO:
   RUN Get_File_Name (INPUT PName:HANDLE in frame connect,
                      INPUT ".db",
                      INPUT "Find Database File",
                      INPUT TRUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_filep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_filep Connect
ON CHOOSE OF btn_filep IN FRAME Connect /* Browse... */
DO:
   RUN Get_File_Name (INPUT Trig_Loc:HANDLE in frame connect,
                      INPUT ".pl",
                      INPUT "Find Procedure Library File",
                      INPUT TRUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_filet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_filet Connect
ON CHOOSE OF btn_filet IN FRAME Connect /* Browse... */
DO:
   RUN Get_File_Name (INPUT Parm_File:HANDLE in frame connect,
                      INPUT ".pf",
                      INPUT "Find Parameter File",
                      INPUT TRUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Connect
ON CHOOSE OF Btn_Help IN FRAME Connect /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   RUN adecomm/_adehelp.p (INPUT "comm", INPUT "CONTEXT", 
                           INPUT {&Connect_Database},
                           INPUT ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Options
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Options Connect
ON CHOOSE OF btn_Options IN FRAME Connect /* Options >> */
DO:
  DO WITH FRAME {&FRAME-NAME} :
  
    IF (FRAME {&FRAME-NAME}:HEIGHT-PIXELS <> Dlg_FullH) THEN
    DO:
      /* Display the full dialog. */
      ASSIGN btn_Options:LABEL = REPLACE(btn_Options:LABEL , ">>":U , "<<":U ).
      ASSIGN FRAME {&FRAME-NAME}:HEIGHT-PIXELS = Dlg_FullH NO-ERROR.
      
      IF Full_First_Time THEN
      DO:
        /* Only display optional fields the first time. This preserves the
           users typed values in subsequent full dialog displays.
        */
        DISPLAY {&OPTIONAL-FIELDS}.
        ASSIGN Full_First_Time = FALSE.
      END.
      ELSE
        VIEW {&OPTIONAL-FIELDS}.
        
      ENABLE {&ENABLE-OPTIONAL}.
      RUN enable_custom.
    END.
    ELSE
    DO:
      /* Display the shortened dialog. */
      ASSIGN btn_Options:LABEL = REPLACE(btn_Options:LABEL , "<<":U , ">>":U )
             . /* END ASSIGN */
      HIDE {&OPTIONAL-FIELDS}.
      DISABLE {&OPTIONAL-FIELDS}.
      ASSIGN FRAME {&FRAME-NAME}:HEIGHT-PIXELS = Dlg_ShortH NO-ERROR
             . /* END ASSIGN */
    END.
    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LName Connect
ON LEAVE OF LName IN FRAME Connect /* Logical Name */
DO:
   Define var name as char NO-UNDO.

   ASSIGN name = input frame connect LName.
   if LOOKUP(name, "DICTDB,DICTDB2,DICTDBG") <> 0 then
   do:   
      message "You cannot connect to a database" SKIP
              "with a logical name of " name "."
               view-as ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
      apply "ENTRY" to LName IN FRAME {&FRAME-NAME}.
      return NO-APPLY.  /* prevent user from leaving the field. */
   end.
   IF NUM-ENTRIES(name, " ") <> 1 AND LENGTH(name) > 1 THEN DO:
     message "You cannot have spaces in the logical name"
        VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
     APPLY "ENTRY" TO LName IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
   END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Trig_Loc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Trig_Loc Connect
ON LEAVE OF Trig_Loc IN FRAME Connect /* Trigger Location */
DO:
   Define var name as char NO-UNDO.

   assign name = input frame connect Trig_loc.
   if    length(name,"character") > 2
     and substring(name,length(name,"character") - 2,-1,"character") = ".pl"
     and SEARCH(name)    = ? 
   then
   do:   
     message "Cannot find Procedure Library file."
             view-as ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
     apply "ENTRY" to Trig_Loc IN FRAME {&FRAME-NAME}.
     return NO-APPLY.  /* prevent user from leaving the field. */
   end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Connect 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* If the parent window is delayed-minimized, the db connect dialog won't 
   display in a manner the user can see it. This can occur with the ADE
   Desktop window for example. By assigning the parent's window-state to
   its own current state, we can clear that situation, because window-state
   will not be minimized yet. -jep */
ASSIGN h_parent_win = FRAME {&FRAME-NAME}:PARENT.
h_parent_win:WINDOW-STATE = h_parent_win:WINDOW-STATE NO-ERROR.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, RETRY MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, RETRY MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, RETRY MAIN-BLOCK:
  
  IF RETRY THEN
  DO:
    ASSIGN p_PName = ?
           p_LName = ?
           . /* END ASSIGN */
    LEAVE MAIN-BLOCK.
  END.
  
  RUN Set_Init_Values.
  RUN enable_UI.
  RUN enable_custom.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Connect  _DEFAULT-DISABLE
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
  HIDE FRAME Connect.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_custom Connect 
PROCEDURE enable_custom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :
    
    ASSIGN PName:SENSITIVE        = qbf_p_name
           btn_Filen:SENSITIVE    = qbf_p_name
           . /* END ASSIGN */ 

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Connect  _DEFAULT-ENABLE
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
  DISPLAY PName LName DB_Type 
      WITH FRAME Connect.
  ENABLE PName btn_filen btn_OK Btn_Cancel LName btn_Options Btn_Help 
      WITH FRAME Connect.
  {&OPEN-BROWSERS-IN-QUERY-Connect}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_File_Name Connect 
PROCEDURE Get_File_Name :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   Define INPUT PARAMETER h_name  as widget-handle NO-UNDO.
   Define INPUT PARAMETER p_ext   as char          NO-UNDO. /* contains "." */
   Define INPUT PARAMETER p_title as char          NO-UNDO.
   Define INPUT PARAMETER p_exist as logical       NO-UNDO.

   Define var name       as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.
   Define var filter     as char    NO-UNDO.
   Define var must_exist as char    NO-UNDO.

   filter = "*" + p_ext.
   name = TRIM(h_name:screen-value).

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      if p_exist then
         system-dialog GET-FILE 
            name 
            filters            filter filter
            default-extension  p_ext
            title              p_title 
            must-exist
            update             picked_one.
      else
         system-dialog GET-FILE 
            name 
            filters            filter filter
            default-extension  p_ext
            title              p_title 
            update             picked_one.
   &ELSE
      ASSIGN must_exist = IF p_exist THEN "MUST-EXIST"
                                     ELSE "".
      RUN adecomm/_filecom.p
          ( INPUT filter /* p_Filter */, 
            INPUT ""     /* p_Dir */ , 
            INPUT ""     /* p_Drive */ ,
            INPUT NO ,   /* p_Save_As */
            INPUT p_Title ,
            INPUT must_exist ,
            INPUT-OUTPUT name,
            OUTPUT picked_one). 
   &ENDIF

   if picked_one then
      h_name:screen-value = name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pressed_OK Connect 
PROCEDURE Pressed_OK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   Define var args as char    NO-UNDO.
   Define var num  as integer NO-UNDO.
   Define var ix   as integer NO-UNDO.
   
   Define var cMsgs as char   NO-UNDO.

   assign 
      p_PName     = input frame connect PName
      p_Parm_File = input frame connect Parm_File.

   /* Check for required input. */
   IF (p_PName     = ""   OR p_PName     = ?) AND
      (p_Parm_File = ""   OR p_Parm_File = ?) AND
      qbf_p_name   = TRUE then
   do:
      message "You must supply a physical name or a parameter file."
               view-as ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
      return error.
   end.

   assign 
      input frame connect LName
      input frame connect DB_Type
      input frame connect Multi_User
      input frame connect Pass_Phrase
      input frame connect Network
      input frame connect Host_Name
      input frame connect Service_Name
      input frame connect User_Id
      input frame connect Pass_word
      input frame connect Trig_Loc
      input frame connect Unix_Parms.
      . /* end assign */

   if Unix_Parms = ? then assign Unix_Parms = "".
      
   assign
      p_LName       = LName
      p_Multi_User  = Multi_User
      p_Type        = DB_Type
      p_Network     = Network
      p_Host_Name   = Host_Name
      p_Service_Name = Service_Name
      p_Userid      = User_Id
      p_Password    = Pass_word
      p_Trig_Loc    = Trig_Loc
      p_Unix_Parms  = Unix_Parms
      . /* end assign */

   /* Set up parameters for CONNECT */
   /* WIN95-LFN : WIN95 Long Filename support requires physical and logical
      dbnames be quoted. - jep 12/14/95 */
   assign args = "'" + ( if qbf_p_name then p_Pname else p_LName ) + "'".
   if args = "''" or args = ? then args = "".
   
   if args <> "" then
   do:
     assign args = args + " -dt "   + p_Type.
     if p_LName        <> "" then assign args = args + " -ld " +
                                                "'" + p_LName + "'".
     if p_Network    <> None then assign args = args + " -N "  + p_Network.
     if p_Host_Name    <> "" then assign args = args + " -H "  + p_Host_Name.
     if p_Service_Name <> "" then assign args = args + " -S "  + p_Service_Name.
     if p_UserId       <> "" then assign args = args + " -U "  + p_UserId.
     IF p_Password <> "" then 
     DO:
         ASSIGN args = args + " -P ".
         IF INDEX(p_Password,'~"') > 0 THEN
              ASSIGN args = args + QUOTER(trim(p_Password),"'").
         ELSE 
            ASSIGN args = args + QUOTER(trim(p_Password)).
         
     END.

     if p_Multi_User    = no then assign args = args + ' -1 '.
   end.
   
   if p_Trig_Loc     <> "" then assign args = args + " -trig " + p_Trig_Loc.
   if p_Parm_File    <> "" then assign args = args + " -pf "   + p_Parm_File.
   
   assign p_args = args.
 
 
   /* If the caller did not want the database connected now, we're done */
   if (p_Connect = NO) then return.

   /* We need do ON ERROR because otherwise, if any connect fails, Progress
      will kick us out of the trigger.  Note that Progress will raise
      error on the first connect that fails and won't keep going to try
      to connect other ones.
   */
   assign num = NUM-DBS.
   /* num-dbs sometimes returns 1 instead of 0. If ldbname and pdbname 
    * are ? we reassign num to be 0 (hutegger 95/01)
    */
   if num        = 1 and
      ldbname(1) = ? and
      pdbname(1) = ? then assign num = 0.
   
   do on stop undo, retry:
     if retry
      then do:
       run adecomm/_setcurs.p ("").
       return error.
       end.
      else do:
       IF NOT Pass_Phrase THEN DO:
          run adecomm/_setcurs.p ("WAIT").
          connect VALUE(args) VALUE(p_Unix_Parms) NO-ERROR.
          run adecomm/_setcurs.p ("").
       END.

       IF Pass_Phrase OR 
          (ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) = 15271) THEN DO:
          /* if missing or incorrect passphrase for a database
             with encryption enabled and manual start, prompt
             for the passphrase now.
          */
          DEFINE VARIABLE cpassPhrase AS CHAR NO-UNDO.

          RUN _passphrase.p (OUTPUT cpassPhrase).

          /* if they don't specify a passphrase when asked to, we will
             just display the errors we got above.
          */
          IF cpassPhrase <> ? AND length(cpassPhrase) > 0 THEN DO:
              /* this will let them try once. If it fails, then they will
                 need to try to connect again.
              */
              connect VALUE(args) VALUE("-KeyStorePassPhrase " + QUOTER(cpassPhrase)) VALUE(p_Unix_Parms) NO-ERROR.
          END.
       END.
       if  NUM-DBS > num then ASSIGN currentdb = LDBNAME(num + 1).
       if p_UserId <> "" and connected(currentdb) and DB_Type = "PROGRESS"then
       do:
           create client-principal hCP. /* create a CLIENT-PRINCIPAL only once during login*/
           /* Use SET-DB-CLIENT instead of SETUSERID */ 
           hCP:initialize(p_UserId,?,?,p_Password) no-error.
           setdbclnt = set-db-client(hCP,currentdb) no-error.
             
           if NOT setdbclnt THEN 
           DO:
                MESSAGE "Userid/Password is incorrect."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
                disconnect value(currentdb).
               
           end.
           delete object hCP.
           hcp = ?.
       end.
      end.
     end.
   
   /* This will be set from any errors or warnings. Merge all the warnings
      together and display them in one shot.  */
   IF error-status:NUM-MESSAGES > 0 THEN DO:
     if lookup(string(error-status:GET-NUMBER(1)),'15944,13691,12710',',') = 0 then  
     cMsgs = error-status:get-message(1).
     do ix = 2 to error-status:num-messages:
        if lookup(string(error-status:GET-NUMBER(ix)),'15944,13691,12710',',') = 0 then
        cMsgs = cMsgs + CHR(10) + error-status:get-message(ix).
     end.
     if trim(cMsgs) <> "" then
     MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR IN WINDOW ACTIVE-WINDOW.
   END.

   /* If the user has tried to connect to more than one database 
      (via -db parms) one may succeed while another failed.  The only way 
      we can tell what's really happened is to check NUM-DBS again.
   */
   if  NUM-DBS > num then
   do:
      /* The database whose name was entered in the name fill-in, may in
         fact not be one of the ones that connected successfully.
         To be sure we get this right, get the info from Progress for
         the num+1 connected database - it should be the first of the ones
         that were just connected.
      */
      assign
         p_LName = LDBNAME(num + 1)
         p_PName = PDBNAME(num + 1)
         p_Type = DBTYPE(num + 1).
      return.
   end.
   else do:
      /* The connect failed on all counts  - we want to leave the box up, 
         so abort the OK button. */
      if qbf_p_name
       then apply "entry" to Pname in frame connect.
       else apply "entry" to Lname in frame connect.
      return error.
   end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_Init_Values Connect 
PROCEDURE Set_Init_Values :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
  DO WITH FRAME {&FRAME-NAME}:
                        
    /* Set the dialog size values and shorten the dialog height. */
    /* IZ 3656 : Add a small margin {&VM_OKBOX} in pixels to short and full height to
       ensure dialog is large enough for the widgets, particularly on Windows XP. */
    assign Dlg_ShortH = FRAME {&FRAME-NAME}:HEIGHT-PIXELS -
                        (FRAME {&FRAME-NAME}:HEIGHT-PIXELS
                         - Host_Name:Y IN FRAME {&FRAME-NAME})
           Dlg_ShortH = Dlg_ShortH + {&VM_OKBOX}
           Dlg_FullH  = FRAME {&FRAME-NAME}:HEIGHT-PIXELS + {&VM_OKBOX}
           . /* END ASSIGN */
    assign FRAME {&FRAME-NAME}:HEIGHT-PIXELS = Dlg_ShortH NO-ERROR.
    
    /* Change Unknown to Null if PName and LName are passed in that way. */
    assign  p_PName = (IF p_PName = ? THEN "" ELSE p_PName)
            p_LName = (IF p_LName = ? THEN "" ELSE p_LName)
            . /* END ASSIGN */
            
    /* Unfortunately, even if pname or lname are given, we can't figure out
       the type since the thing isn't connected!  So always default to
       PROGRESS.
    */
    if p_Type = ? then p_Type = "PROGRESS".

    if p_type <> "PROGRESS"
    then do: /* some DataServers do not need a physical db-name */
        { prodict/dictgate.i
            &action = "query"
            &output = "capab"
            &dbrec  = "?"
            &dbtype = "p_type"
        }
        assign
            /*  qbf_l_name = INDEX(ENTRY(5,capab),"l") > 0 /* l-name needed */ */
            qbf_p_name = INDEX(ENTRY(5,capab),"p") > 0  /* p-name needed */.
    end.
    else
        assign qbf_p_name = TRUE.
  
    /* Multi_User defaults no if not decided */
    if p_Multi_User = ? then p_Multi_User = no.

    /* If Network type is not passed, initialize to (None). If it is passed,
       add it to the Network Type list if its not already there. */
    if (p_Network = "" or p_Network = ?) then
        assign p_Network = None.
    else if Network:LOOKUP(p_Network) IN FRAME {&FRAME-NAME} = 0 then
        assign stat = Network:ADD-FIRST(p_Network) IN FRAME {&FRAME-NAME}.
    assign Network:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p_Network.
        
    assign ext_Type = {adecomm/ds_type.i
                        &direction = "itoe"
                        &from-type = "p_Type"
                      } .
                      
    if p_Unix_Parms = ? then assign p_Unix_Parms = "".

   /* Now initialize the screen objects program variables. */
   assign
      PName        = p_PName
      LName        = p_LName
      DB_Type      = p_Type
      Multi_User   = p_Multi_User
      Network      = p_Network  
      Host_Name    = p_Host_Name
      Service_Name = p_Service_Name
      User_Id      = p_UserId
      Pass_word    = p_Password
      Trig_Loc     = p_Trig_Loc
      Unix_Parms   = p_Unix_Parms
      . /* end assign */

  END.
END PROCEDURE.

PROCEDURE seruser:
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

