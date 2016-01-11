&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{adecomm/adestds.i}   /* Standard Definitions             */
{adeuib/uniwidg.i}    /* Universal widgt records          */
{adeuib/sharvars.i}   /* Shared variables                 */
{adeuib/advice.i}     /* Shared Advisor variables         */
{adeshar/mrudefs.i}   /* Shared vars for mru preferences */

DEFINE VARIABLE cur_bg  AS INTEGER                                    NO-UNDO.
DEFINE VARIABLE cur_fg  AS INTEGER                                    NO-UNDO.
DEFINE VARIABLE old_cue AS LOGICAL                                    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Def_Window QualifyDBFields MinimizeOnRun ~
SuppressViewAs MRUEntries MRUFileList DblClickSectionEd MultipleSectionEd ~
DfltFunctDataType TtyColors Advisor_messages Cue_Cards RECT-18 RECT-19 
&Scoped-Define DISPLAYED-OBJECTS Def_Window QualifyDBFields MinimizeOnRun ~
SuppressViewAs MRUEntries MRUFileList DblClickSectionEd MultipleSectionEd ~
DfltFunctDataType Advisor_messages Cue_Cards 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON TtyColors 
     LABEL "Character &Terminal Colors..." 
     SIZE 31 BY 1.14.

DEFINE VARIABLE DfltFunctDataType AS CHARACTER FORMAT "X(256)":U INITIAL "Logical" 
     LABEL "Default &Function Data-Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "CHARACTER","COM-HANDLE","DATE","DATETIME","DATETIME-TZ","DECIMAL","HANDLE","INTEGER","LOGICAL","LONGCHAR","MEMPTR","RAW","RECID","ROWID","WIDGET-HANDLE" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE MRUEntries AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE Advisor_messages AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Currently Activated", ?,
"All", yes,
"None", no
     SIZE 23 BY 2.62 NO-UNDO.

DEFINE VARIABLE Cue_Cards AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Currently Activated", ?,
"All", yes,
"None", no
     SIZE 24 BY 2.62 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 4.52.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 4.52.

DEFINE VARIABLE DblClickSectionEd AS LOGICAL INITIAL no 
     LABEL "&Double-click on object for Section Editor" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE Def_Window AS LOGICAL INITIAL no 
     LABEL "&Create a Default Window at Startup" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE MinimizeOnRun AS LOGICAL INITIAL no 
     LABEL "&Minimize Main Window while Running or Debugging" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE MRUFileList AS LOGICAL INITIAL no 
     LABEL "&Recently Used File List:" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE MultipleSectionEd AS LOGICAL INITIAL no 
     LABEL "Display multiple Section &Editors" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE QualifyDBFields AS LOGICAL INITIAL no 
     LABEL "&Qualify Database Fields with a Database Name" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE SuppressViewAs AS LOGICAL INITIAL no 
     LABEL "Default to &Suppressing Database VIEW-AS Phrases" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Def_Window AT ROW 1.52 COL 3
     QualifyDBFields AT ROW 2.52 COL 3
     MinimizeOnRun AT ROW 3.52 COL 3
     SuppressViewAs AT ROW 4.52 COL 3
     MRUEntries AT ROW 5.43 COL 34 COLON-ALIGNED NO-LABEL
     MRUFileList AT ROW 5.52 COL 3
     DblClickSectionEd AT ROW 6.52 COL 3
     MultipleSectionEd AT ROW 7.52 COL 3
     DfltFunctDataType AT ROW 8.86 COL 28 COLON-ALIGNED
     TtyColors AT ROW 10.29 COL 18
     Advisor_messages AT ROW 13.86 COL 7 NO-LABEL
     Cue_Cards AT ROW 13.86 COL 38 NO-LABEL
     RECT-18 AT ROW 12.19 COL 3
     RECT-19 AT ROW 12.19 COL 34
     "Display These Advisors:" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 12.91 COL 5
     "  Cue Cards" VIEW-AS TEXT
          SIZE 13 BY .71 AT ROW 11.95 COL 36
     "  Advisor" VIEW-AS TEXT
          SIZE 9 BY .71 AT ROW 11.95 COL 4
     "Display These Cue Cards:" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 12.91 COL 36
     "entries" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 5.52 COL 44.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 16.05
         WIDTH              = 65.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME MRUEntries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MRUEntries V-table-Win
ON LEAVE OF MRUEntries IN FRAME F-Main
DO:
  IF MRUEntries:SCREEN-VALUE = "0" THEN ASSIGN
    MRUFileList:SCREEN-VALUE = "no"
    MRUEntries:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MRUFileList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MRUFileList V-table-Win
ON VALUE-CHANGED OF MRUFileList IN FRAME F-Main /* Recently Used File List: */
DO:
  IF MRUFileList:SCREEN-VALUE = "yes" THEN ASSIGN
    MRUEntries:SCREEN-VALUE = "4"
    MRUEntries:SENSITIVE = TRUE.
  ELSE ASSIGN
    MRUEntries:SCREEN-VALUE = "0"
    MRUEntries:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TtyColors
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TtyColors V-table-Win
ON CHOOSE OF TtyColors IN FRAME F-Main /* Character Terminal Colors... */
DO:
  DEFINE VAR ans      AS LOGICAL  NO-UNDO.
  DEFINE VAR cur_sp   AS INTEGER  NO-UNDO.
   
  RUN adecomm/_chscolr.p ("Character Terminal Simulator Colors", "", FALSE, ?, ?, ?,
                         INPUT-OUTPUT cur_bg, INPUT-OUTPUT cur_fg, INPUT-OUTPUT cur_sp,
                         OUTPUT ans).
  /* NOTE: we are currently not marking the file-saved field, as we are
     not supporting tty simulation.  This needs to be fixed when we support
     tty simulation */
  IF ans AND (cur_bg <> _tty_bgcolor OR cur_fg <> _tty_fgcolor)
  THEN RUN adeuib/_updtclr.p (cur_fg, cur_bg).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  ASSIGN cur_bg      = _tty_bgcolor
         cur_fg      = _tty_fgcolor.
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-new-values V-table-Win 
PROCEDURE assign-new-values :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE choice  AS LOGICAL   INITIAL YES                      NO-UNDO.
  DEFINE VARIABLE dlist   AS CHARACTER                                  NO-UNDO.
  DEFINE VARIABLE ix      AS INTEGER                                    NO-UNDO.
  DEFINE VARIABLE lReturn AS LOGICAL   INITIAL YES                      NO-UNDO.
  DEFINE VARIABLE sctn    AS CHARACTER INITIAL "Pro{&UIB_SHORT_NAME}"   NO-UNDO.
  DEFINE VARIABLE hDesignManager            AS HANDLE                   NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN Def_Window
           MinimizeOnRun
           QualifyDBFields
           SuppressViewAs
           MRUFileList
           MRUEntries
           DblClickSectionEd
           MultipleSectionEd
           DfltFunctDataType
           Cue_Cards
           Advisor_Messages.

    FIND FIRST _uib_prefs.
    ASSIGN _uib_prefs._user_dfltwindow = Def_Window
           _minimize_on_run            = MinimizeOnRun
           _suppress_dict_view-as      = SuppressViewAS
           _mru_filelist               = MRUFileList
           _mru_entries                = MRUEntries
           _dblclick_section_ed        = DblClickSectionEd
           _default_function_type      = DfltFunctDataType
           _uib_prefs._user_hints      = Cue_Cards
           _tty_bgcolor                = cur_bg
           _tty_fgcolor                = cur_fg.

    /* If user changes the Advisor Messages setting, reflect this change in
       the Advisor Never_Advise settings (which is the opposite of the
       Advisor Messages setting).                                           */
    ASSIGN _uib_prefs._user_advisor = Advisor_Messages .
    IF ( Advisor_Messages <> ? ) THEN  DO:
      DO ix = 1 TO {&Advisor-Count} :
        ASSIGN _never-advise[ ix ] = NOT Advisor_Messages .
      END.
    END.

    /* If the user has cards in the disabled list and they went from
       None to ALL, ask if they want to activate everything.              */
    GET-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE dlist.
    IF old_cue = NO AND Cue_Cards = YES AND (dlist NE ? AND dlist NE "") THEN
      MESSAGE "There cue cards which are disabled." skip
              "Do you want to activate them all?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE choice. 
    IF choice EQ NO THEN ASSIGN _uib_prefs._user_hints = ?.
  
    /* If user changes the Cue Cards setting to yes clear the exception
       list to get 'em all back!                                            */
    IF ( Cue_Cards EQ YES AND choice EQ YES) THEN DO:
      USE "" NO-ERROR.
      PUT-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE "" NO-ERROR. 
      GET-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE dlist.
      IF dlist NE ? AND dlist NE "" THEN
        RUN adeshar/_puterr.p (INPUT "AB", INPUT _h_uib).
    END.

    /* User has switched the qualify dbfields. */
    IF _suppress_dbname = QualifyDBFields THEN DO:
      FOR EACH _P:
        _P._FILE-SAVED = FALSE.
      END.
      _suppress_dbname = NOT QualifyDBFields.
    END. /* DB qualify has been switched */

    /* Publish AB event to indicate refresh in qualify db fields. */
    PUBLISH "AB_refreshFields":U.

    /* Multiple Section Editors, possibly one per design window. */
    IF _multiple_section_ed NE MultipleSectionEd THEN DO:
      /* multiple SE --> single: disallow change if more than one SE is open. */
      IF MultipleSectionEd EQ FALSE THEN DO:
        ix = 0.
        FOR EACH _P:
          ix = ix + (IF VALID-HANDLE(_P._hSecEd) THEN 1 ELSE 0).
        END.
        
        IF ix > 1 THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":U, "ok-cancel":U,
            'There are multiple open Section Editor windows.  The Editor connected to the design window with focus will be kept.  All other Editors will be deleted.').
            
          /* Delete all but SE parented to current design window. */
          IF lReturn THEN DO:
            FOR EACH _P WHERE _P._WINDOW-HANDLE NE _h_win AND
              VALID-HANDLE(_P._hSecEd):
              
              RUN SEClose IN _P._hSecEd ("SE_EXIT":U).
              ASSIGN _P._hSecEd = ?.
            END.
          END.
        END.
      END.
       
      /* single SE --> multiple: clear _P._hSecEd for all BUT the current 
         design window with focus. */
      ELSE
        FOR EACH _P WHERE _P._WINDOW-HANDLE NE _h_win:
          _P._hSecEd = ?.
        END.
    END.
       
    ASSIGN _multiple_section_ed = (IF lReturn THEN MultipleSectionEd
                                   ELSE _multiple_section_ed).

    /** If Dynamics is running, then we need to set some things.
     *  ----------------------------------------------------------------------- **/
    IF _DynamicsIsRunning THEN
    DO:
        /* Set the suppress db flag in the Repository Design Manager. */
        ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                                 INPUT "RepositoryDesignManager":U) NO-ERROR.
        IF VALID-HANDLE(hDesignManager) THEN
            DYNAMIC-FUNCTION("setQualifiedTableName":U IN hDesignManager, INPUT _suppress_dbname).
    END.    /* Dynamics is running. */

  END.  /* DO WITH FRAME {&FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject V-table-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.

  /* Entries is disabled if recently used file list is turned off */
  IF NOT MRUFileList THEN MRUEntries:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-init V-table-Win 
PROCEDURE set-init :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ret_value    AS LOGICAL                               NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER                               NO-UNDO.
  DEFINE VARIABLE num_noadvise AS INTEGER                               NO-UNDO.

  FIND FIRST _uib_prefs.
  ASSIGN Def_Window        = _uib_prefs._user_dfltwindow
         MinimizeOnRun     = _minimize_on_run
         QualifyDBFields   = NOT _suppress_dbname
         Cue_Cards         = _uib_prefs._user_hints
         old_cue           = Cue_Cards
         SuppressViewAs    = _suppress_dict_view-as
         MRUFileList       = _mru_filelist
         MRUEntries        = _mru_entries
         DfltFunctDataType = _default_function_type
         DblClickSectionEd = _dblclick_section_ed
         MultipleSectionEd = _multiple_section_ed.
  
  /* User may have set the preference to ALL but then disabled along the 
   * way. Reflect the change from All to Active */
  IF _uib_prefs._user_advisor THEN DO: /* YES = all */
    num_noadvise = 0.
    DO i = 1 TO {&Advisor-Count} :
      IF _never-advise[ i ] = NO THEN 
        ASSIGN num_noadvise = num_noadvise + 1.
    END.
    IF num_noadvise <> {&Advisor-Count} THEN
      ASSIGN _uib_prefs._user_advisor = ?. /* ? = Only Active */
  END.
  ASSIGN Advisor_Messages = _uib_prefs._user_advisor.
  DISPLAY {&DISPLAYED-OBJECTS} WITH FRAME F-Main.
  
  /* 19981001-037 
  IF (Advisor_Messages = NO) THEN
    ASSIGN ret_value = Advisor_Messages:DISABLE("Currently Activated")
                       IN FRAME {&FRAME-NAME} .
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

