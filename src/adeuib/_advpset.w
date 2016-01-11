&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_advprocset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_advprocset 
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

  File: _advpset.w

  Description: Advanced Procedure Settings

  Input Parameters:
     p_Precid - recid of the Procedure record.

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 02/21/95 -  9:57 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Precid AS RECID NO-UNDO.
&GLOBAL-DEFINE WIN95-BTN  TRUE
{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */
{adeuib/custwidg.i}             /* _custom & _palette_item TTs */
/* ***************************  Definitions  ************************** */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l        AS LOGICAL NO-UNDO.
DEFINE VARIABLE i        AS INTEGER NO-UNDO.
DEFINE VARIABLE isdialog AS LOGICAL NO-UNDO. /* yes = dialog, no = window */

&Scoped-define NONE <None>

/* Find the correct record */
FIND _P WHERE RECID(_P) eq p_Precid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_advprocset

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-5 RECT-4 cb_proctype b_New ~
s_Links tg_Query b_Add b_Remove tg_window cb_filetype tg_template ~
tg_persist 
&Scoped-Define DISPLAYED-OBJECTS cb_proctype rs_frames s_Links tg_window ~
cb_filetype 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Add 
     LABEL "&Add..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_New 
     LABEL "&New..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb_filetype AS CHARACTER FORMAT "X(2)":U 
     LABEL "File Type" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "w","p","i" 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE cb_proctype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procedure T&ype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE rs_addfields AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Fra&me Query", 1,
"&External Tables", 2,
"&Neither", 3
     SIZE 41.6 BY 3.33 NO-UNDO.

DEFINE VARIABLE rs_frames AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&One Only", 1,
"Multi&ple", 2
     SIZE 26 BY .86 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.6 BY 7.14.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.6 BY 4.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 7.14.

DEFINE VARIABLE s_Links AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 31.4 BY 4.86 NO-UNDO.

DEFINE VARIABLE tg_basic AS LOGICAL INITIAL no 
     LABEL "&Basic Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE tg_browsers AS LOGICAL INITIAL no 
     LABEL "Bro&wsers" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.2 BY .86 NO-UNDO.

DEFINE VARIABLE tg_DBFields AS LOGICAL INITIAL no 
     LABEL "&Database Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .86 NO-UNDO.

DEFINE VARIABLE tg_frames AS LOGICAL INITIAL no 
     LABEL "&Frames" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.2 BY .86 NO-UNDO.

DEFINE VARIABLE tg_persist AS LOGICAL INITIAL no 
     LABEL "&Persistent Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE VARIABLE tg_Query AS LOGICAL INITIAL no 
     LABEL "&Queries" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.6 BY .86 NO-UNDO.

DEFINE VARIABLE tg_so AS LOGICAL INITIAL no 
     LABEL "&Smart Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE tg_template AS LOGICAL INITIAL no 
     LABEL "&Template" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.1 NO-UNDO.

DEFINE VARIABLE tg_window AS LOGICAL INITIAL no 
     LABEL "&Window" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.2 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_advprocset
     cb_proctype AT ROW 1.29 COL 24 COLON-ALIGNED
     b_New AT ROW 1.29 COL 61
     tg_frames AT ROW 3.43 COL 4
     rs_frames AT ROW 3.43 COL 19 NO-LABEL
     s_Links AT ROW 3.43 COL 49.6 NO-LABEL
     tg_so AT ROW 4.33 COL 4
     tg_basic AT ROW 5.24 COL 4
     tg_DBFields AT ROW 6.14 COL 4
     tg_browsers AT ROW 7.05 COL 4
     tg_Query AT ROW 7.91 COL 4
     b_Add AT ROW 8.62 COL 50
     b_Remove AT ROW 8.62 COL 66
     tg_window AT ROW 8.76 COL 4
     rs_addfields AT ROW 11.24 COL 3.6 NO-LABEL
     cb_filetype AT ROW 11.38 COL 58 COLON-ALIGNED
     tg_template AT ROW 11.38 COL 70
     tg_persist AT ROW 12.67 COL 60
     " Allow Drawing of:" VIEW-AS TEXT
          SIZE 19.6 BY .62 AT ROW 2.67 COL 3.6
     RECT-3 AT ROW 2.91 COL 2
     RECT-5 AT ROW 2.91 COL 47.6
     " Add fields to:" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 10.52 COL 3.6
     RECT-4 AT ROW 10.71 COL 2
     "Run Option:" VIEW-AS TEXT
          SIZE 11.6 BY .86 AT ROW 12.67 COL 48
     " Supported SmartLinks" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 2.67 COL 49.6
     SPACE(11.99) SKIP(11.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Advanced Procedure Settings".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_advprocset
                                                                        */
ASSIGN 
       FRAME d_advprocset:SCROLLABLE       = FALSE.

/* SETTINGS FOR RADIO-SET rs_addfields IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RADIO-SET rs_frames IN FRAME d_advprocset
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg_basic IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_browsers IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_DBFields IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_frames IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_persist IN FRAME d_advprocset
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX tg_Query IN FRAME d_advprocset
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX tg_so IN FRAME d_advprocset
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg_template IN FRAME d_advprocset
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d_advprocset
/* Query rebuild information for DIALOG-BOX d_advprocset
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d_advprocset */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_advprocset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_advprocset d_advprocset
ON GO OF FRAME d_advprocset /* Advanced Procedure Settings */
DO: 
  DEFINE VAR old-subtype AS CHAR NO-UNDO.
   
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER xx_U FOR _U.
  
  /* We want the list to equal "Basic,Browse,DB-Fields" if nothing
     else is selected. (We look for this value for efficiency in 
     some places.) */
  ASSIGN _P._ALLOW = "".
  IF tg_basic:CHECKED    THEN _P._ALLOW = _P._ALLOW + ",Basic".
  IF tg_browsers:CHECKED THEN _P._ALLOW = _P._ALLOW + ",Browse".
  IF tg_DBFields:CHECKED THEN _P._ALLOW = _P._ALLOW + ",DB-Fields".
  /* Other ALLOWable options */
  IF tg_so:CHECKED     THEN _P._ALLOW = _P._ALLOW + ",Smart".
  IF tg_window:CHECKED THEN _P._ALLOW = _P._ALLOW + ",Window".
  IF tg_query:CHECKED  THEN _P._ALLOW = _P._ALLOW + ",Query".
  
  /* Remove leading comma, if one exists */
  IF SUBSTRING(_P._ALLOW,1,1,"CHARACTER":U) = "," THEN
    _P._ALLOW = SUBSTRING(_P._ALLOW,2,-1,"CHARACTER").
  
  /* Handle 'Frames' */
  IF tg_frames:CHECKED THEN DO:
      IF rs_frames:SCREEN-VALUE = "1" THEN 
          ASSIGN _P._max-frame-count  = 1.
      ELSE ASSIGN _P._max-frame-count = ?.
  END.
  ELSE ASSIGN _P._max-frame-count = 0.
  ASSIGN _P._persistent-only = tg_persist:CHECKED.
  
  /* Handle _LINKS */
  IF s_Links:LIST-ITEMS NE ? AND s_Links:LIST-ITEMS NE "{&NONE}":U THEN 
    _P._LINKS = s_Links:LIST-ITEMS.
  ELSE _P._LINKS = "".
      
  /* Handle 'Add fields to:' */
  CASE rs_addfields:SCREEN-VALUE:
      WHEN "1" THEN _P._ADD-FIELDS = "Frame-Query":U.
      WHEN "2" THEN _P._ADD-FIELDS = "External-Tables":U.
      OTHERWISE _P._ADD-FIELDS     = "Neither":U.
  END CASE.
  /* Handle Procedure and file type. */
  ASSIGN _P._TYPE = cb_proctype:SCREEN-VALUE
         _P._TEMPLATE = tg_template:CHECKED
         _P._FILE-TYPE = cb_filetype:SCREEN-VALUE
         .
    
  /* If the procedure has a design-window that is not a real window, make
     sure the window label shows the procedure type.  (If its not a 
     DIALOG-BOX and no window is allowed then make sure the SUBTYPE is 
     "Design-Window". */
  FIND x_U WHERE x_U._HANDLE = _P._WINDOW-HANDLE AND
                 x_U._STATUS NE "DELETED":U NO-LOCK NO-ERROR.  
  IF x_U._TYPE eq "WINDOW":U THEN DO:
    old-subtype = x_U._SUBTYPE.
    IF CAN-DO(_P._ALLOW, "WINDOW":U) 
    THEN ASSIGN x_U._SUBTYPE = "".
    ELSE ASSIGN x_U._SUBTYPE = "Design-Window":U
                x_U._LABEL = _P._TYPE. 
   
    /* If we changed to, or from, a Design-Window, then make sure all child
       frames are "size-to-parent". */
    IF old-subtype ne x_U._SUBTYPE THEN DO:
      /* Turn off "size-to-parent" except where their is only one frame in a 
         design window. NOTE that size-to-parent frame are not directly
         movable or sizable, and they always sit at position (1,1). */  
      IF x_U._SUBTYPE eq "Design-Window" AND _P._max-frame-count eq 1 THEN DO:
        FIND FIRST xx_U WHERE xx_U._TYPE eq "FRAME":U 
                          AND xx_U._STATUS eq "NORMAL":U
                          AND xx_U._parent-recid eq RECID(x_U)
                        NO-ERROR.
        IF AVAILABLE xx_U THEN DO: 
          FIND _L WHERE RECID(_L) eq xx_U._lo-recid.
          ASSIGN xx_U._size-to-parent = yes
                 _L._ROW = 1
                 _L._COL = 1
                 xx_U._HANDLE:ROW = 1
                 xx_U._HANDLE:COL = 1
                 xx_U._HANDLE:RESIZABLE = no
                 xx_U._HANDLE:MOVABLE = no.   
        END.
      END. /* Design Window with 1 frame */
      ELSE DO:
        /* For regular windows, or where there are multiple frames, make all
           the frames independently movable and sizable. */
        FOR EACH xx_U WHERE xx_U._TYPE eq "FRAME":U 
                        AND xx_U._STATUS eq "NORMAL":U
                        AND xx_U._parent-recid eq RECID(x_U):   
          ASSIGN xx_U._size-to-parent = no
                 xx_U._HANDLE:RESIZABLE = yes
                 xx_U._HANDLE:MOVABLE = yes.  
        END.
      END. 
    END. /* IF old-subtype ne x_U._SUBTYPE ... */
  END. /* IF x_U._TYPE eq "WINDOW":U... */
    
  MESSAGE "Be very careful to ensure that all necessary"
          "method libraries are included in this procedure." 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Add d_advprocset
ON CHOOSE OF b_Add IN FRAME d_advprocset /* Add... */
DO:
  DEFINE VARIABLE l        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE linktype AS CHARACTER NO-UNDO.
  
  RUN Add_Link (OUTPUT linktype).
  IF linktype NE "" THEN DO:
    IF s_Links:LOOKUP(linktype) > 0 THEN DO:
      MESSAGE CAPS(linktype) "already exists." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
    IF s_Links:LIST-ITEMS = "{&NONE}":U 
    THEN ASSIGN s_Links:LIST-ITEMS = linktype
                b_Remove:SENSITIVE = yes. /* Something to remove, finally. */
    ELSE l = s_Links:ADD-LAST(linktype).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_New
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_New d_advprocset
ON CHOOSE OF b_New IN FRAME d_advprocset /* New... */
DO:  
  RUN Get_New_Proctype(OUTPUT cb_proctype).
  IF cb_proctype <> "" THEN DO:
    i = cb_proctype:LOOKUP(cb_proctype).
    IF i = 0 THEN ASSIGN
        l = cb_proctype:ADD-FIRST(cb_proctype).
    cb_proctype:SCREEN-VALUE = cb_proctype.   
  END.
  ELSE cb_proctype:SCREEN-VALUE = _P._TYPE.

  ASSIGN _P._TYPE = cb_proctype:SCREEN-VALUE.
  RUN adeuib/_admpset.p (INPUT RECID(_P)).
  RUN Update_Screen. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Remove d_advprocset
ON CHOOSE OF b_Remove IN FRAME d_advprocset /* Remove */
DO:
  IF s_Links:DELETE(s_Links:SCREEN-VALUE) THEN DO:
    IF s_Links:NUM-ITEMS eq 0 THEN DO:
      /* Nothing left to remove. */
      ASSIGN s_Links:LIST-ITEMS = "{&NONE}":U
             SELF:SENSITIVE     = no.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_filetype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_filetype d_advprocset
ON VALUE-CHANGED OF cb_filetype IN FRAME d_advprocset /* File Type */
DO:
  ASSIGN _P._FILE-TYPE = SELF:SCREEN-VALUE.
  IF SELF:SCREEN-VALUE = "p" OR SELF:SCREEN-VALUE = "i" THEN RUN Set_PI_Mode.
  RUN Update_Screen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_proctype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_proctype d_advprocset
ON VALUE-CHANGED OF cb_proctype IN FRAME d_advprocset /* Procedure Type */
DO:
  ASSIGN _P._TYPE = cb_proctype:SCREEN-VALUE.
  RUN adeuib/_admpset.p (INPUT RECID(_P)).
  RUN Update_Screen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg_frames
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg_frames d_advprocset
ON VALUE-CHANGED OF tg_frames IN FRAME d_advprocset /* Frames */
DO:
  /* If no frames are allowed, disable the "One vs. Multiple" radio-set. */
  rs_frames:SENSITIVE = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_advprocset 


/* ***************************  Main Block  *************************** */
{ adecomm/commeng.i }
{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Advanced_Procedure_Settings_Dlg_Box} }

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN Init.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add_Link d_advprocset 
PROCEDURE Add_Link :
/*------------------------------------------------------------------------------
  Purpose:     Add a link type to the selection list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER linktype AS CHARACTER FORMAT "X(30)" NO-UNDO.
  DEFINE BUTTON b_OK     LABEL "OK"     SIZE 15 BY 1.125 AUTO-GO.
  DEFINE BUTTON b_Cancel LABEL "Cancel" SIZE 15 BY 1.125 AUTO-ENDKEY.
  DEFINE VARIABLE rs_link AS CHARACTER
    VIEW-AS RADIO-SET HORIZONTAL
    RADIO-BUTTONS "Source","-Source":U,"Target","-Target":U.
  
  FORM "Link Type:" AT ROW 1   COL 2 
       linktype     AT ROW 2   COL 2
       rs_link      AT ROW 3.1 COL 2 NO-LABEL
       b_ok         AT ROW 1.5 COL 36 
       b_cancel     AT ROW 2.8 COL 36
    WITH FRAME pt SIDE-LABELS 
    TITLE "Add Supported Link" THREE-D NO-LABELS
      SIZE 52 BY 5
    VIEW-AS DIALOG-BOX DEFAULT-BUTTON b_OK.

  ON " " OF linktype DO:
    MESSAGE "Spaces are not allowed in the Link Type." VIEW-AS ALERT-BOX
      ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  
  ON GO OF FRAME pt DO:
      IF linktype:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Please enter a link type." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO linktype.
        RETURN NO-APPLY.
      END.
      /* Don't add Source/Target if it is already in the string. 
         NOTE: that it is not strictly necessary to assign the Radio-set, but
         I do it incase future coding decides to look at it. */
      ASSIGN linktype = linktype:SCREEN-VALUE.
      IF (linktype MATCHES "*-Source":U) THEN DO:
        rs_link:SCREEN-VALUE = "-Source":U.
      END.
      ELSE IF (linktype MATCHES "*-Target":U) THEN DO:
        rs_link:SCREEN-VALUE = "-Target":U.
      END.
      ELSE linktype = linktype + rs_link:SCREEN-VALUE.
  END.
  ON ENDKEY,END-ERROR OF FRAME pt DO:
      ASSIGN linktype = "".
  END.
  
  ENABLE ALL WITH FRAME pt.
  WAIT-FOR GO OF FRAME pt.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_advprocset  _DEFAULT-DISABLE
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
  HIDE FRAME d_advprocset.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_advprocset  _DEFAULT-ENABLE
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
  DISPLAY cb_proctype rs_frames s_Links tg_window cb_filetype 
      WITH FRAME d_advprocset.
  ENABLE RECT-3 RECT-5 RECT-4 cb_proctype b_New s_Links tg_Query b_Add b_Remove 
         tg_window cb_filetype tg_template tg_persist 
      WITH FRAME d_advprocset.
  {&OPEN-BROWSERS-IN-QUERY-d_advprocset}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_New_Proctype d_advprocset 
PROCEDURE Get_New_Proctype :
/* -----------------------------------------------------------
  Purpose:     Prompts for New Proctype
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER proctype AS CHARACTER FORMAT "X(30)" NO-UNDO.
  DEFINE BUTTON b_OK     LABEL "OK"     SIZE 15 BY 1.125 AUTO-GO.
  DEFINE BUTTON b_Cancel LABEL "Cancel" SIZE 15 BY 1.125 AUTO-ENDKEY.
  
  FORM "Procedure Type:" AT ROW 1 COL 2 
       proctype AT ROW 2   COL 2
       b_ok     AT ROW 1.5 COL 36 
       b_cancel AT ROW 2.8 COL 36
    WITH FRAME pt SIDE-LABELS 
    TITLE "New Procedure Type" THREE-D NO-LABELS
    &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN
      SIZE 52 BY 3.5
    &ELSE
      SIZE 52 BY 4.5
    &ENDIF
    VIEW-AS DIALOG-BOX DEFAULT-BUTTON b_OK.

  ON " " OF proctype DO:
    MESSAGE "Spaces are not allowed in the Procedure Type." VIEW-AS ALERT-BOX
      ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  
  ON GO OF FRAME pt DO:
      IF proctype:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Please enter a procedure type." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
      END.
      /* Spaces could have been pasted into this field. This is unlikely, so
         just remove them. */
      ASSIGN proctype = REPLACE(proctype:SCREEN-VALUE,' ':U, '-':U).
      /* Are we calling a Window a dialog (or visa versa). */
      IF isdialog AND INDEX(proctype,'Window':U) > 0 THEN DO:
        MESSAGE "Dialog-Boxes cannot have a procedure type using 'Window'."
                VIEW-AS ALERT-BOX ERROR.
         IF proctype eq 'Window':U 
         THEN proctype = 'Dialog-Box':U.
         ELSE proctype = REPLACE (proctype, 'Window':U, 'Dialog':U).
         proctype:SCREEN-VALUE = proctype.
         APPLY 'ENTRY':U TO proctype.
         RETURN NO-APPLY.
      END.
  END.
  ON ENDKEY,END-ERROR OF FRAME pt DO:
      ASSIGN proctype = "".
  END.
  
  ENABLE ALL WITH FRAME pt.
  WAIT-FOR GO OF FRAME pt.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Init d_advprocset 
PROCEDURE Init :
/* -----------------------------------------------------------
  Purpose:     Initialize dialog.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/    
  DEF VAR c_type AS CHAR NO-UNDO.
   
  /* Is this a Dialog-box? If so, we need to treat things differently. */
  FIND _U WHERE _U._HANDLE = _P._WINDOW-HANDLE.
  isdialog = (_U._TYPE eq "DIALOG-BOX":U).
  
  /* Initialize Combo-box of Procedure Types. For simple types, don't show the
     SmartOptions. */
  IF CAN-DO('Dialog,Dialog-Box,Window':U, _P._TYPE)
  THEN ASSIGN cb_proctype:LIST-ITEMS IN FRAME {&FRAME-NAME} = _P._TYPE.
  ELSE DO:
    FOR EACH _custom WHERE _custom._type = "Container" BY _custom._name:
      /* Custom files show the name with "&" character -- remove this. 
         Also, don't include WINDOW types if this is a dialog-box (or
         dialog-box types if this is a Window). The name "dialog" should convert
         to the TYPE Dialog-Box (unless the type is "dialog").   
         Finally, if the name in the File/New list has a space, then this is
         not a valid type, so ignore it (in this list). */
      c_type = REPLACE(_custom._name, "&":U, "":U).
      IF INDEX(c_type, ' ':U) > 0 THEN NEXT. 
      IF isdialog AND INDEX(c_type, 'Window':U) > 0 THEN NEXT.
      IF NOT isdialog AND INDEX(c_type, 'Dialog':U) > 0 THEN NEXT.
      IF c_type eq 'Dialog':U AND _P._TYPE ne 'Dialog':U 
      THEN c_type = 'Dialog-Box':U.
      /* Add the new type to the list. */
      l = cb_proctype:ADD-LAST(c_type) IN FRAME {&FRAME-NAME}.
    END.
    FOR EACH _palette_item WHERE _palette_item._type > {&P-BASIC}
                             AND _palette_item._New_Template <> ""  
                             AND _palette_item._New_Template <> ? 
                             AND _palette_item._name <> "Folder":
      l = cb_proctype:ADD-LAST(_palette_item._label2) IN FRAME {&FRAME-NAME}.
    END.
  END. /* Initialize Combo-box... */

  /* Find current in list */
  i = cb_proctype:LOOKUP(_P._TYPE).
  IF i = 0 THEN /* if not found, add it */
    l = cb_proctype:ADD-FIRST(_P._TYPE).
  IF i <> ? THEN
    cb_proctype:SCREEN-VALUE = _P._TYPE.
   
  RUN Update_Screen.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Sensitize d_advprocset 
PROCEDURE Sensitize :
/* -----------------------------------------------------------
  Purpose:     Turns most fields sensitivity on or off.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE l_customizable AS LOGICAL INITIAL YES NO-UNDO.
  DEFINE VARIABLE l_dotw AS LOGICAL INITIAL YES NO-UNDO.
  DEFINE VARIABLE l_on AS LOGICAL INITIAL YES NO-UNDO.
  
  /* Is this a standard SmartObject? We don't allow the user to customize the
     standard ones. */
  IF CAN-DO("SmartWindow,SmartBrowser,SmartFrame,SmartPanel,SmartFolder,SmartViewer,SmartQuery", _P._TYPE)
  THEN l_customizable = no.
  
  /* Is it a .w file (as opposed to a .p or .i) */
  l_dotw = _P._FILE-TYPE eq "w":U.
  
  /* Most fields are sensitive only if they are in a Customizable .w file */
  l_on = l_customizable AND l_dotw.
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN tg_basic:SENSITIVE     = l_on
             tg_browsers:SENSITIVE  = l_on
             tg_DBFields:SENSITIVE  = l_on
             tg_frames:SENSITIVE    = l_on
             rs_frames:SENSITIVE    = l_on AND _P._MAX-FRAME-COUNT ne 0
             tg_so:SENSITIVE        = l_on             
             rs_addfields:SENSITIVE = l_customizable AND _P._FILE-TYPE ne "i":U
             tg_persist:SENSITIVE   = l_on
             tg_Query:SENSITIVE     = l_on
             b_Add:SENSITIVE        = l_on
             b_Remove:SENSITIVE     = l_on AND s_Links:LIST-ITEMS ne "{&NONE}":U
             /* Dialog-boxes can't have WINDOWS, and must be .w files. */
             cb_filetype:SENSITIVE  = l_customizable AND NOT isdialog
             tg_window:SENSITIVE    = l_on AND NOT isdialog
             .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_PI_Mode d_advprocset 
PROCEDURE Set_PI_Mode :
/* -----------------------------------------------------------
  Purpose:     Turns off everything for P and I file types.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      tg_basic:CHECKED    = no 
      tg_browsers:CHECKED = no 
      tg_DBFields:CHECKED = no 
      tg_frames:CHECKED   = no  
      tg_so:CHECKED       = no 
      tg_window:CHECKED   = no
      tg_Query:CHECKED    = no 
      tg_persist:CHECKED  = no
      s_Links:LIST-ITEMS  = "{&NONE}".
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Update_Screen d_advprocset 
PROCEDURE Update_Screen :
/* -----------------------------------------------------------
  Purpose:     Updates screen fields.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
 
    /* Read Supported Links */
    ASSIGN s_Links:LIST-ITEMS = (IF _P._LINKS NE "" THEN _P._LINKS ELSE "{&NONE}").
 
    IF _P._FILE-TYPE = "" OR _P._FILE-TYPE = ? THEN _P._FILE-TYPE = "w".
    ASSIGN cb_filetype:SCREEN-VALUE = _P._FILE-TYPE.
  
    /* Initialize Allow */
    ASSIGN tg_so:CHECKED       = NO
           tg_basic:CHECKED    = NO
           tg_DBFields:CHECKED = NO
           tg_browsers:CHECKED = NO
           tg_window:CHECKED   = NO.
    DO i = 1 TO NUM-ENTRIES(_P._ALLOW):
        CASE ENTRY(i,_P._ALLOW):
            WHEN "Smart"     THEN tg_so:CHECKED       = YES.
            WHEN "Basic"     THEN tg_basic:CHECKED    = YES.
            WHEN "DB-Fields" THEN tg_DBFields:CHECKED = YES.
            WHEN "Browse"    THEN tg_browsers:CHECKED = YES.
            WHEN "Window"    THEN tg_window:CHECKED   = YES.
            WHEN "Query"     THEN tg_query:CHECKED    = YES.
        END CASE.
    END.
  
    /* Handle 'Allow Addition of FRAMES' */
    CASE _P._MAX-FRAME-COUNT:
        WHEN ? THEN
          ASSIGN tg_frames:CHECKED      = YES
                 rs_frames:SCREEN-VALUE = "2":U.
        WHEN 1 THEN
          ASSIGN tg_frames:CHECKED      = YES
                 rs_frames:SCREEN-VALUE = "1":U.
        OTHERWISE
          ASSIGN tg_frames:CHECKED   = NO.
    END CASE.
    /* Handle SmartBehavior */
    IF _P._persistent-only THEN tg_persist:CHECKED = YES.
    ELSE tg_persist:CHECKED = NO.
           
    /* Handle Add Fields to... */
    CASE _P._ADD-FIELDS:
        WHEN "FRAME-QUERY" THEN
            rs_addfields:SCREEN-VALUE = "1":U.
        WHEN "EXTERNAL-TABLES" THEN
            rs_addfields:SCREEN-VALUE = "2":U.
        WHEN "NEITHER" THEN
            rs_addfields:SCREEN-VALUE = "3":U.
    END CASE.
    
    /* Handle Code-only */
    IF _P._FILE-TYPE = "p" OR _P._FILE-TYPE = "i" THEN RUN set_PI_Mode.
   
    /* Is this a Template. */
    tg_template:CHECKED = _P._TEMPLATE.
   
    /* Enable the screen correctly. */
    RUN Sensitize.
 
  END. /* DO WITH FRAME {&FRAME-NAME} */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

