&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" C-Win _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" C-Win _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" C-Win _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftemwizpw.w
  
  Description:  Wizard page for maintaining program dets

  Purpose:      Standard page to allow program details to be updated by the
                wizard - i.e. the wizard will automatically update the definition
                section of the program to update the comments for the current
                version, task, user, etc.
                The wizard also facilitates full SCM integration and allows
                comments to be imported / exported from / to SCM, and
                version history to be pulled in from SCM.

  Parameters:   p_hwizard (handle) - handle of Wizard controller

  History:
  --------
  (v:010000)    Task:          41   UserRef:    AS0
                Date:   05/02/1998  Author:     Anthony Swindells

  (v:010001)    Task:          18   UserRef:    
                Date:   02/18/2003  Author:     Thomas Hansen

  Update Notes: - Removed code that start afrtbprocp.p itself. Changed to use the version already running in memory.

  (v:010002)    Task:          53   UserRef:    
                Date:   16/02/1998  Author:     Anthony Swindells

  Update Notes: Fix problem with copy from/to Roundtable

  (v:010005)    Task:         103   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: Fix WRX problems.

  (v:010006)    Task:         131   UserRef:    
                Date:   01/04/1998  Author:     Anthony Swindells

  Update Notes: Misc Wizard Fixes

  (v:010007)    Task:         142   UserRef:    
                Date:   06/04/1998  Author:     Anthony Swindells

  Update Notes: Modify wizards to only run if not editing in read-only mode, i.e. if the object
                being edited belongs to the current task.

  (v:010008)    Task:         180   UserRef:    AS
                Date:   29/04/1998  Author:     Anthony Swindells

  Update Notes: Fix tab order again

  (v:010010)    Task:         373   UserRef:    
                Date:   26/06/1998  Author:     Anthony Swindells

  Update Notes: try and prevent afrtbprocp from being left running

  (v:010014)    Task:        5459   UserRef:    
                Date:   00/04/0026  Author:     Jenny Bond

  Update Notes: Set and get session date format into lv_date_format and use this variable when
                formatting date formats.

  (v:010015)    Task:        5653   UserRef:    
                Date:   11/05/2000  Author:     Anthony Swindells

  Update Notes: fix tab order plus object name length

  (v:010003)    Task:    90000150   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Added POSSE License

-----------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from SCM if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemwizpw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/*{ adm2/support/admhlp.i} /* ADM Help File Defs */*/

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) NE 0 &THEN
    DEFINE VARIABLE ip_hwizard AS WIDGET-HANDLE NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER ip_hwizard AS WIDGET-HANDLE NO-UNDO.
&ENDIF

/* UIB API call general variables */
DEFINE VARIABLE lv_uibinfo                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_srecid                       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_code                         AS CHARACTER    NO-UNDO.

/* Handle to procedure containing SCM procedures */
DEFINE VARIABLE hScmTool                     AS HANDLE       NO-UNDO.

/* SCM/Object information variables */
DEFINE VARIABLE lv_task_number          AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_task_summary         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_description     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_programmer      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_userref         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_workspace       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_date            AS DATE NO-UNDO.
DEFINE VARIABLE lv_user_code            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_user_name            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_name          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_template_name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version       AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_object_summary       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_description   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_upd_notes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_previous_versions    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version_task  AS INTEGER NO-UNDO.

{af/sup/afproducts.i}
{src/adm2/globals.i}

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE gFuncLibHdl               AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fr_main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi_object_name fi_object_description ~
ed_object_purpose ed_object_parameters ed_version_notes bu_blank_definition ~
bu_reread_definition bu_import_scm bu_import_scm_history bu_update_scm ~
bu_help fi_object_version fi_task fi_date fi_author fi_project_ref RECT-4 ~
RECT-5 
&Scoped-Define DISPLAYED-OBJECTS fi_object_name fi_object_description ~
ed_object_purpose ed_object_parameters ed_version_notes fi_object_version ~
fi_task fi_date fi_author fi_project_ref cProductModule 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle C-Win 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle C-Win 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_blank_definition 
     LABEL "&Blank Definition Section" 
     SIZE 27 BY 1.14 TOOLTIP "Refresh the screen with blank definitions"
     BGCOLOR 8 .

DEFINE BUTTON bu_help 
     LABEL "&Help" 
     SIZE 26.8 BY 1.14 TOOLTIP "Obtain help on using this wizard"
     BGCOLOR 8 .

DEFINE BUTTON bu_import_scm 
     LABEL "&Import from SCM" 
     SIZE 27 BY 1.14 TOOLTIP "Refresh the screen with details from the SCM Tool"
     BGCOLOR 8 .

DEFINE BUTTON bu_import_scm_history 
     LABEL "Import Full &Version History" 
     SIZE 27.2 BY 1.14 TOOLTIP "Import SCM version history for previous versions"
     BGCOLOR 8 .

DEFINE BUTTON bu_reread_definition 
     LABEL "&ReRead Definition Section" 
     SIZE 27 BY 1.14 TOOLTIP "Refresh the screen with the current contents of the definition section"
     BGCOLOR 8 .

DEFINE BUTTON bu_update_scm 
     LABEL "Just &Copy to SCM" 
     SIZE 27.2 BY 1.14 TOOLTIP "Update SCM with the current screen details"
     BGCOLOR 8 .

DEFINE VARIABLE ed_object_parameters AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 100000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 74.2 BY 3.52 TOOLTIP "The parameters and their type for this object" NO-UNDO.

DEFINE VARIABLE ed_object_purpose AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 100000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 74.2 BY 3.52 TOOLTIP "The purpose of the object, full description" NO-UNDO.

DEFINE VARIABLE ed_version_notes AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 100000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 74.2 BY 3.52 TOOLTIP "Version update notes for entered object version" NO-UNDO.

DEFINE VARIABLE cProductModule AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 52.4 BY 1 NO-UNDO.

DEFINE VARIABLE fi_author AS CHARACTER FORMAT "X(256)":U 
     LABEL "Author" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 TOOLTIP "The programmer doing the modification" NO-UNDO.

DEFINE VARIABLE fi_date AS DATE FORMAT "99/99/9999":U 
     LABEL "Date" 
     VIEW-AS FILL-IN 
     SIZE 16.4 BY 1 TOOLTIP "The date of the modification" NO-UNDO.

DEFINE VARIABLE fi_object_description AS CHARACTER FORMAT "X(40)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 52.4 BY 1 TOOLTIP "The summary description for the object - what it does" NO-UNDO.

DEFINE VARIABLE fi_object_name AS CHARACTER FORMAT "X(35)":U 
     LABEL "Object" 
     VIEW-AS FILL-IN 
     SIZE 52.4 BY 1 TOOLTIP "Enter the filename and extension of the object, minus the path" NO-UNDO.

DEFINE VARIABLE fi_object_version AS INTEGER FORMAT "999999":U INITIAL 10000 
     LABEL "Version" 
     VIEW-AS FILL-IN 
     SIZE 9.6 BY 1 TOOLTIP "Object version being modified,. new = 010000" NO-UNDO.

DEFINE VARIABLE fi_project_ref AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ref." 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 TOOLTIP "User reference to Project Code" NO-UNDO.

DEFINE VARIABLE fi_task AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Task" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "The task this change is under" NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 11.81.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 14.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fr_main
     fi_object_name AT ROW 1.24 COL 14 COLON-ALIGNED
     fi_object_description AT ROW 2.43 COL 14 COLON-ALIGNED
     ed_object_purpose AT ROW 6.33 COL 16 NO-LABEL
     ed_object_parameters AT ROW 10.1 COL 16 NO-LABEL
     ed_version_notes AT ROW 13.81 COL 16 NO-LABEL
     bu_blank_definition AT ROW 8.14 COL 98
     bu_reread_definition AT ROW 9.33 COL 98
     bu_import_scm AT ROW 10.52 COL 98
     bu_import_scm_history AT ROW 11.71 COL 98
     bu_update_scm AT ROW 12.91 COL 98
     bu_help AT ROW 16.24 COL 98
     fi_object_version AT ROW 2.19 COL 100 COLON-ALIGNED
     fi_task AT ROW 3.33 COL 100 COLON-ALIGNED
     fi_date AT ROW 4.48 COL 100 COLON-ALIGNED
     fi_author AT ROW 5.71 COL 100 COLON-ALIGNED
     fi_project_ref AT ROW 6.86 COL 100 COLON-ALIGNED
     cProductModule AT ROW 3.62 COL 14 COLON-ALIGNED NO-LABEL
     RECT-4 AT ROW 5.62 COL 1
     RECT-5 AT ROW 1.48 COL 93
     "Purpose:" VIEW-AS TEXT
          SIZE 8.8 BY .62 AT ROW 6.33 COL 7
     "Parameters:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 10.1 COL 4
     "Version notes:" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 13.52 COL 1.8
     "Definition Section" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 5.38 COL 2
     "Source Code Management Info" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 1.24 COL 94
     "Product" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.52 COL 7.4
     "module:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.1 COL 7.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1.05
         SIZE 128 BY 16.43
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Program Definition Section"
         HEIGHT             = 16.91
         WIDTH              = 128
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 204.8
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
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fr_main
   UNDERLINE L-To-R,COLUMNS                                             */
/* SETTINGS FOR FILL-IN cProductModule IN FRAME fr_main
   NO-ENABLE                                                            */
ASSIGN 
       cProductModule:READ-ONLY IN FRAME fr_main        = TRUE.

ASSIGN 
       ed_object_parameters:RETURN-INSERTED IN FRAME fr_main  = TRUE.

ASSIGN 
       ed_object_purpose:RETURN-INSERTED IN FRAME fr_main  = TRUE.

ASSIGN 
       ed_version_notes:RETURN-INSERTED IN FRAME fr_main  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Program Definition Section */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Program Definition Section */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_blank_definition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_blank_definition C-Win
ON CHOOSE OF bu_blank_definition IN FRAME fr_main /* Blank Definition Section */
DO:
    IF SEARCH("af/sup/afcomment.i":U) = ? THEN
        DO:
            MESSAGE "Cannot reset comment section as comment template file" SKIP
                    "af/sup/afcomment.i":U SKIP
                    "Could not be found."
                    VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.


    /* Reset definition section back to skeleton from af/sup/afcomment.i */
    DEFINE VARIABLE lv_comments         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_after_comments   AS CHARACTER    NO-UNDO.

    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).

    ASSIGN lv_comments = "":U.
    DEFINE VARIABLE lv_line AS CHARACTER NO-UNDO.
    INPUT FROM VALUE(SEARCH("af/sup/afcomment.i":U)) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED lv_line.
        ASSIGN lv_comments = lv_comments + lv_line + CHR(10).
    END.
    INPUT CLOSE.

    RUN refresh-screen-from-definitions ( INPUT lv_comments).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_help C-Win
ON CHOOSE OF bu_help IN FRAME fr_main /* Help */
DO:
    MESSAGE

"Program Definition Section Wizard Help" SKIP
"----------------------------------------------------------------" SKIP
"This wizard allows you to maintain the comment block at the top of the definition" SKIP
"section, containing the program details and version history." SKIP(1)
"If details are available in SCM Tool for the current object version, then these" SKIP
"may be pulled in using the import button."  SKIP(1)
"The only button that actually updates anything are the copy to SCM Tool button" SKIP
" All other buttons simply read information" SKIP
"either from SCM Tool or the current definition section." SKIP(1)
"Even after you have updated SCM Tool and/or the definition section, the changes" SKIP
"may be undone by pressing the cancel button, as everything is part of a single" SKIP
"transaction." SKIP(1)
"The definition section must conform to the standard as in the template file" SKIP
"af/sup/afcomment.i for this wizard to function correctly." SKIP(1)
"It is important that the definition section and SCM Tool are in synch and both" SKIP
"contain a full version history of the object. Please remember to actually update" SKIP
"both when you have finished entering the details." SKIP

    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_import_scm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_import_scm C-Win
ON CHOOSE OF bu_import_scm IN FRAME fr_main /* Import from SCM */
DO:
DO WITH FRAME {&FRAME-NAME}:

    IF NOT VALID-HANDLE(hScmTool) THEN RETURN NO-APPLY.

    RUN getScmInfo.

    DISPLAY lv_task_number @ fi_task
            lv_task_userref @ fi_project_ref
            TODAY @ fi_date
            lv_user_name @ fi_author.

    IF lv_object_version > 0 THEN
        DISPLAY lv_object_version @ fi_object_version.
    ELSE
        DISPLAY 010000 @ fi_object_version.

    IF lv_object_summary <> "" THEN
        DISPLAY lv_object_summary @ fi_object_description.

    /* Display Purpose from SCM if setup. Purpose is full description
       in SCM. It is returned in a | delimited list */                
    IF NUM-ENTRIES(lv_object_description,"|":U) > 0 THEN
        ASSIGN ed_object_purpose:SCREEN-VALUE = REPLACE(lv_object_description,"|":U,CHR(10)).

    /* Display Version Update Notes from SCM if setup */                
    IF lv_object_upd_notes <> "" THEN
        ASSIGN ed_version_notes:SCREEN-VALUE = lv_object_upd_notes.

END.    /* do with frame */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_import_scm_history
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_import_scm_history C-Win
ON CHOOSE OF bu_import_scm_history IN FRAME fr_main /* Import Full Version History */
DO:
DO WITH FRAME {&FRAME-NAME}:

    IF NOT VALID-HANDLE(hScmTool) THEN RETURN NO-APPLY.

    MESSAGE "This option will import the version update notes and task information" SKIP
            "of all prior versions of object " + lv_object_name + ", version " + STRING(lv_object_version,"999999":U) SKIP
            "from SCM Tool. It will update the definition history section with the" SKIP
            "version update notes for each version found." SKIP(1)
            "The previous versions of this object are " + lv_previous_versions + " !" SKIP(1)
            "Any existing notes found in the definition section will be replaced with" SKIP
            "the new details imported from SCM Tool." SKIP(1)
            "Are you sure you want to continue ?"
            UPDATE lv_continue AS LOGICAL
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.

    IF NOT lv_continue THEN RETURN NO-APPLY.

    RUN importScmHistory.

END.    /* do with frame */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_reread_definition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_reread_definition C-Win
ON CHOOSE OF bu_reread_definition IN FRAME fr_main /* ReRead Definition Section */
DO:
    DEFINE VARIABLE lv_comments         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_after_comments   AS CHARACTER    NO-UNDO.

    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).

    RUN refresh-screen-from-definitions ( INPUT lv_comments).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bu_update_scm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_update_scm C-Win
ON CHOOSE OF bu_update_scm IN FRAME fr_main /* Just Copy to SCM */
DO:

  DO WITH FRAME {&FRAME-NAME}:

/*    MESSAGE "Are you sure you want to write the contents of the Project Reference" SKIP
 *             "field to SCM task " + STRING(lv_task_number,">>>>>>>>9":U) SKIP
 *             "Plus update the object description, purpose, and version notes for  " SKIP
 *             "object " + lv_object_name + ", version " + STRING(lv_object_version,"999999":U) + " !"
 *             UPDATE lv_continue AS LOGICAL
 *             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.
 * 
 *     IF NOT lv_continue THEN RETURN NO-APPLY.*/

    ASSIGN
        ed_object_purpose
        ed_version_notes
        fi_object_description
        fi_project_ref.


    IF VALID-HANDLE(hScmTool)
    AND lv_task_number > 0
    THEN
        RUN rtb-set-taskinfo IN hScmTool
                    (   INPUT  lv_task_number,
                        INPUT  fi_project_ref  ).

    IF VALID-HANDLE(hScmTool)
    AND lv_object_name <> ""
    AND lv_task_number > 0
    THEN
        RUN rtb-set-objectinfo IN hScmTool
                    (    INPUT   lv_object_name,
                         INPUT   lv_task_number,
                         INPUT   lv_object_version,
                         INPUT   fi_object_description,
                         INPUT   ed_object_purpose,
                         INPUT   ed_version_notes).

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
IF VALID-HANDLE(ip_hwizard) THEN
    ASSIGN FRAME {&FRAME-NAME}:FRAME    = ip_hwizard.

ASSIGN FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P =  FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  =  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       .

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
    RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  getRDMHandle().
  IF VALID-HANDLE(ghRepositoryDesignManager) THEN
    cProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":U IN ghRepositoryDesignManager).
  
  RUN enable_UI.

  RUN setup.

  IF VALID-HANDLE(ip_hwizard) THEN
    APPLY "U1":U TO ip_hwizard. /* ok to finish */

  {af/sup/afendcmain.i}
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME fr_main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fi_object_name fi_object_description ed_object_purpose 
          ed_object_parameters ed_version_notes fi_object_version fi_task 
          fi_date fi_author fi_project_ref cProductModule 
      WITH FRAME fr_main.
  ENABLE fi_object_name fi_object_description ed_object_purpose 
         ed_object_parameters ed_version_notes bu_blank_definition 
         bu_reread_definition bu_import_scm bu_import_scm_history bu_update_scm 
         bu_help fi_object_version fi_task fi_date fi_author fi_project_ref 
         RECT-4 RECT-5 
      WITH FRAME fr_main.
  {&OPEN-BROWSERS-IN-QUERY-fr_main}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-block C-Win 
PROCEDURE find-block :
/*------------------------------------------------------------------------------
  Purpose:     To return a | delimited block of text between ip_lookup1 and ip_lookup2
  Parameters:  INPUT  ip_lookup1
               INPUT  ip_lookup2
               INPUT  ip_text
               INPUT  ip_start_posn
               OUTPUT op_result
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_lookup1      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_lookup2      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_text         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_start_posn   AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER op_result       AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_posn         AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_start_posn   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_end_posn     AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_lf_posn      AS INTEGER INITIAL 0 NO-UNDO.

ASSIGN  ip_text = REPLACE(ip_text,"|":U, " ":U)
        lv_start_posn = INDEX(ip_text,ip_lookup1,ip_start_posn)
        lv_end_posn = INDEX(ip_text,ip_lookup2,lv_start_posn + 1)
        lv_posn = lv_start_posn + LENGTH(ip_lookup1)
        op_result = "".

IF lv_start_posn > 0 AND lv_end_posn > 0 THEN
    DO WHILE (lv_posn < lv_end_posn):
        ASSIGN  lv_lf_posn = INDEX(ip_text,CHR(10),lv_posn).
        IF lv_lf_posn = 0 THEN LEAVE.
        IF lv_lf_posn < lv_end_posn THEN
            ASSIGN op_result =  op_result +
                                    (IF NUM-ENTRIES(op_result,"|":U) > 0 THEN "|":U ELSE "":U) +
                                    TRIM(SUBSTRING(ip_text,lv_posn,lv_lf_posn - lv_posn)).                                    
        ASSIGN lv_posn = lv_lf_posn + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find-text C-Win 
PROCEDURE find-text :
/*------------------------------------------------------------------------------
  Purpose:     To return trimmed text after the lookup string and before a <cr>
  Parameters:  INPUT  ip_lookup
               INPUT  ip_text
               OUTPUT op_result
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_lookup   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  ip_text     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_result   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_start_posn   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_end_posn     AS INTEGER INITIAL 0 NO-UNDO.

ASSIGN  lv_start_posn = INDEX(ip_text,ip_lookup)
        lv_end_posn = INDEX(ip_text,CHR(10),lv_start_posn + 1)
        op_result = "".

IF lv_end_posn = 0 THEN
    ASSIGN lv_end_posn = lv_start_posn + LENGTH(ip_lookup).

IF lv_start_posn <> 0 THEN
    ASSIGN op_result = TRIM(SUBSTRING(ip_text,lv_start_posn + LENGTH(ip_lookup), lv_end_posn - (lv_start_posn + LENGTH(ip_lookup)))).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getScmInfo C-Win 
PROCEDURE getScmInfo :
/*------------------------------------------------------------------------------
  Purpose:     Read information from SCM if possible
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  IF VALID-HANDLE(hScmTool)
  THEN
      RUN rtb-get-taskinfo IN hScmTool
                  (   OUTPUT  lv_task_number,
                      OUTPUT  lv_task_summary,
                      OUTPUT  lv_task_description,
                      OUTPUT  lv_task_programmer,
                      OUTPUT  lv_task_userref,
                      OUTPUT  lv_task_workspace,
                      OUTPUT  lv_task_date   ).

  IF VALID-HANDLE(hScmTool)
  THEN
      RUN rtb-get-userinfo IN hScmTool
                  (   OUTPUT  lv_user_code,
                      OUTPUT  lv_user_name).

  IF VALID-HANDLE(hScmTool)
  AND lv_object_name <> ""
  AND lv_task_number > 0
  THEN
      RUN rtb-get-objectinfo IN hScmTool
                  (    INPUT   lv_object_name,
                       INPUT   lv_task_number,
                       OUTPUT  lv_object_version,
                       OUTPUT  lv_object_summary,
                       OUTPUT  lv_object_description,
                       OUTPUT  lv_object_upd_notes,
                       OUTPUT  lv_previous_versions,
                       OUTPUT  lv_object_version_task).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importScmHistory C-Win 
PROCEDURE importScmHistory :
/*------------------------------------------------------------------------------
  Purpose:     To import the version notes for all versions of the current object
               prior to the latest version into the definition section. The version notes
               for the latest version will be tagged onto the end if they exist. The version
               notes will be inserted, oldest first.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_loop1                    AS INTEGER  NO-UNDO.
DEFINE VARIABLE lv_loop2                    AS INTEGER  NO-UNDO.

DEFINE VARIABLE lv_start_posn               AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_end_posn                 AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_posn                     AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_comments                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_result                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_after_comments           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_scm_object_version       AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_scm_object_upd_notes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_scm_task_number          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_scm_task_programmer      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_scm_task_userref         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_scm_task_date            AS CHARACTER NO-UNDO.


  IF VALID-HANDLE(hScmTool)
  THEN
  DO WITH FRAME {&FRAME-NAME}:

    /* Get the current definition section */
    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).

    ASSIGN
        lv_code = ""
        lv_end_posn = INDEX(lv_comments,"  (v:":U) - 1.
        lv_code =   SUBSTRING(lv_comments,1,lv_end_posn). /* upto the start of 1st comment */

    DO lv_loop1 = NUM-ENTRIES(lv_previous_versions) TO 1 BY -1:

        /* 1st get version notes for this version from SCM - remember
           each parameter is returned as a | delimited list */
        ASSIGN lv_scm_object_version = INTEGER(ENTRY(lv_loop1,lv_previous_versions)).
        RUN rtb-get-version-notes IN hScmTool
                (   INPUT   lv_object_name,
                    INPUT   lv_scm_object_version,
                    OUTPUT  lv_scm_object_upd_notes,
                    OUTPUT  lv_scm_task_number,
                    OUTPUT  lv_scm_task_programmer,
                    OUTPUT  lv_scm_task_userref,
                    OUTPUT  lv_scm_task_date   ).

        /* Now we have the notes, update them into the definition section starting
           just below the history: title and going down so that the oldest notes
           appear first. Be sure that if we update one because it exists, then the
           next one appears after the one we just updated or last checked.
        */

        DO lv_loop2 = 1 TO NUM-ENTRIES(lv_scm_task_number,"|":U):
            ASSIGN lv_end_posn = INDEX(lv_comments,"  (v:":U).
            RUN write-version-history-entry
                    (   INPUT           lv_comments,
                        INPUT-OUTPUT    lv_end_posn,
                        INPUT-OUTPUT    lv_code,
                        INPUT           lv_scm_object_version,
                        INPUT           INTEGER(ENTRY(lv_loop2,lv_scm_task_number,"|":U)),
                        INPUT           (IF NUM-ENTRIES(lv_scm_task_userref,"|":U) < lv_loop2
                                        THEN "" ELSE ENTRY(lv_loop2,lv_scm_task_userref,"|":U)),
                        INPUT           (IF NUM-ENTRIES(lv_scm_task_date,"|":U) < lv_loop2
                                        THEN ? ELSE DATE(ENTRY(lv_loop2,lv_scm_task_date,"|":U))),
                        INPUT           (IF NUM-ENTRIES(lv_scm_task_programmer,"|":U) < lv_loop2
                                        THEN "" ELSE ENTRY(lv_loop2,lv_scm_task_programmer,"|":U)),
                        INPUT           (IF NUM-ENTRIES(lv_scm_object_upd_notes,"|":U) < lv_loop2
                                        THEN "" ELSE ENTRY(lv_loop2,lv_scm_object_upd_notes,"|":U))).
        END.    /* DO lv_loop2 = 1 TO NUM-ENTRIES(lv_scm_task_number,"|":U): */

    END.    /* lv_loop1 = 1 TO NUM-ENTRIES(lv_previous_versions): */

    /* Get version notes for latest version if any and append them */
    ASSIGN
        lv_result = "":U
        lv_start_posn = INDEX(lv_comments,"  (v:":U + STRING(lv_object_version,"999999":U)).
    IF lv_start_posn > 0 THEN
      DO:   /* Find end position */
        IF INDEX(lv_comments,"  (v:":U,lv_start_posn + 1) > 0 THEN
            ASSIGN lv_end_posn = INDEX(lv_comments,"  (v:":U,lv_start_posn + 1).
        ELSE
            ASSIGN lv_end_posn = INDEX(lv_comments,"--------------------":U,lv_start_posn + 1).
        ASSIGN lv_code = lv_code + SUBSTRING(lv_comments,lv_start_posn,(lv_end_posn - lv_start_posn) + 1).
      END.

    ASSIGN
        lv_start_posn = R-INDEX(lv_comments,"Notes:":U)
        lv_start_posn = INDEX(lv_comments,"-----------------------------":U,lv_start_posn).

    /* Append rest of comments */
    ASSIGN lv_code = lv_code + SUBSTRING(lv_comments,lv_start_posn).

    /* Write back new definition section with updated comments */
    ASSIGN lv_code = lv_code + lv_after_comments.

    IF lv_code <> ? AND lv_code <> "" THEN
        RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                               INPUT-OUTPUT lv_srecid,
                               INPUT-OUTPUT lv_code ).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE read-current-definitions C-Win 
PROCEDURE read-current-definitions :
/*------------------------------------------------------------------------------
  Purpose:     To return contents of current definition section
  Parameters:  OUTPUT   op_comments
               OUTPUT   op_after_comments 
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER op_comments         AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_after_comments   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lv_last_comment_line AS CHARACTER NO-UNDO INITIAL "------------------------------------*/":U.
DEFINE VARIABLE lv_end_posn AS INTEGER NO-UNDO.

/* Get the current contents of the definition section */
RUN adeuib/_accsect.p( "GET":U, ?, "DEFINITIONS":U,
                       INPUT-OUTPUT lv_srecid,
                       INPUT-OUTPUT lv_code ).

/* We will assume the top of the program to be the start of the comment block
   and look for the end of the comment block
*/

/* Find the last comment line */
IF INDEX(lv_code,lv_last_comment_line) <> 0 THEN
    ASSIGN lv_end_posn = INDEX(lv_code,lv_last_comment_line) + LENGTH(lv_last_comment_line) - 1.
ELSE
    ASSIGN lv_end_posn = INDEX(lv_code,"*/":U) + LENGTH("*/":U) - 1.

/* Also include UIB / Appbuilder line as part of header comments if there */
IF INDEX(lv_code,"This .W file was created with the Progress UIB":U,lv_end_posn) <> 0 
   AND INDEX(lv_code,lv_last_comment_line,lv_end_posn) <> 0 THEN
    ASSIGN lv_end_posn = INDEX(lv_code,lv_last_comment_line,lv_end_posn) + LENGTH(lv_last_comment_line) - 1.

IF INDEX(lv_code,"This .W file was created with the Progress AppBuilder":U,lv_end_posn) <> 0 
   AND INDEX(lv_code,lv_last_comment_line,lv_end_posn) <> 0 THEN
    ASSIGN lv_end_posn = INDEX(lv_code,lv_last_comment_line,lv_end_posn) + LENGTH(lv_last_comment_line) - 1.

ASSIGN  op_comments = SUBSTRING(lv_code,1,lv_end_posn)
        op_after_comments = SUBSTRING(lv_code,lv_end_posn + 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-screen-from-definitions C-Win 
PROCEDURE refresh-screen-from-definitions :
/*------------------------------------------------------------------------------
  Purpose:     Display contents of comments in the screen-value of all widgets
               If any details are missing that we know, then fill them in
               automatically.
  Parameters:  INPUT ip_comments
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_comments AS CHARACTER NO-UNDO.

DEFINE VARIABLE lv_result       AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE lv_start_posn   AS INTEGER INITIAL 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    IF lv_object_name = "" AND fi_object_name:SCREEN-VALUE = "" THEN
        DISPLAY lv_template_name @ fi_object_name.

    /* Next get the description of the object from the definition section */
    RUN find-text(  INPUT   "Description:":U,
                    INPUT   ip_comments,
                    OUTPUT  lv_result).
    DISPLAY lv_result @ fi_object_description.

    /* Next display object purpose from definition section */
    RUN find-block( INPUT   "Purpose:":U,
                    INPUT   "Parameters:":U,
                    INPUT   ip_comments,
                    INPUT   1,
                    OUTPUT  lv_result).
    ASSIGN ed_object_purpose:SCREEN-VALUE = REPLACE(lv_result,"|":U,CHR(10)).

    /* Next display object parameters from definition section */
    RUN find-block( INPUT   "Parameters:":U,
                    INPUT   "History:":U,
                    INPUT   ip_comments,
                    INPUT   1,
                    OUTPUT  lv_result).
    ASSIGN ed_object_parameters:SCREEN-VALUE = REPLACE(lv_result,"|":U,CHR(10)).

    /* Next display version history notes if any exist for this object version */
    ASSIGN
        lv_result = "":U
        lv_start_posn = INDEX(ip_comments,"(v:":U + fi_object_version:SCREEN-VALUE).
    IF lv_start_posn > 0 THEN
      DO:    
        IF INDEX(ip_comments,"(v:":U,lv_start_posn + 1) > 0 THEN
            RUN find-block( INPUT   "Notes:":U,
                            INPUT   "(v:":U,
                            INPUT   ip_comments,
                            INPUT   lv_start_posn,
                            OUTPUT  lv_result).
        ELSE    /* Last version notes */
            RUN find-block( INPUT   "Notes:":U,
                            INPUT   "------------------------":U,
                            INPUT   ip_comments,
                            INPUT   lv_start_posn,
                        OUTPUT  lv_result).
      END.

    /* remove trailing |'s */
    DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
    ASSIGN lv_loop = LENGTH(lv_result).
    IF NUM-ENTRIES(lv_result,"|":U) > 1 THEN
      DO WHILE lv_loop > 1 AND SUBSTRING(lv_result,lv_loop,1) = "|":U:
        ASSIGN lv_loop = lv_loop - 1.            
      END.
    ASSIGN ed_version_notes:SCREEN-VALUE = TRIM(REPLACE(SUBSTRING(lv_result,1,lv_loop),"|":U,CHR(10))).

    IF lv_template_name <> "" AND INDEX(ed_version_notes:SCREEN-VALUE,lv_template_name) = 0 THEN
        ASSIGN ed_version_notes:SCREEN-VALUE =  ed_version_notes:SCREEN-VALUE +
                                                (IF NUM-ENTRIES(ed_version_notes:SCREEN-VALUE,CHR(10)) > 0 AND ENTRY(NUM-ENTRIES(ed_version_notes:SCREEN-VALUE,CHR(10)),ed_version_notes:SCREEN-VALUE,CHR(10)) <> "" THEN CHR(10) ELSE "") +
                                                "Created from Template " +
                                                lv_template_name.

END.    /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-trailing-lfs C-Win 
PROCEDURE remove-trailing-lfs :
/*------------------------------------------------------------------------------
  Purpose:     Remove trailing line feeds from string passed in
  Parameters:  INPUT-OUTPUT iop_text
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER   iop_text        AS CHARACTER NO-UNDO.

DEFINE VARIABLE                 lv_loop         AS INTEGER NO-UNDO.

ASSIGN lv_loop = LENGTH(iop_text).
IF NUM-ENTRIES(iop_text,CHR(10)) > 1 THEN
  DO WHILE lv_loop > 1 AND SUBSTRING(iop_text,lv_loop,1) = CHR(10):
    ASSIGN lv_loop = lv_loop - 1.            
  END.
ASSIGN iop_text = TRIM(SUBSTRING(iop_text,1,lv_loop)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-definitions-from-scm C-Win 
PROCEDURE reset-definitions-from-scm :
/*------------------------------------------------------------------------------
  Purpose:     To blank the definition section completely, and reset it from
               the details held in SCM.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

    /* Reset definition section back to skeleton from af/sup/afcomment.i */
    DEFINE VARIABLE lv_comments         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_after_comments   AS CHARACTER    NO-UNDO.

    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).

    ASSIGN lv_comments = "":U.
    DEFINE VARIABLE lv_line AS CHARACTER NO-UNDO.
    INPUT FROM VALUE(SEARCH("af/sup/afcomment.i":U)) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED lv_line.
        ASSIGN lv_comments = lv_comments + lv_line + CHR(10).
    END.
    INPUT CLOSE.
    /* Remove extra line-feed from end of imported comments */
    ASSIGN lv_comments = SUBSTRING(lv_comments,1,LENGTH(lv_comments) - 1).

    /* Write back new definition section with updated comments */
    ASSIGN lv_code = lv_comments + lv_after_comments.

    IF lv_code <> ? AND lv_code <> "" THEN
        RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                               INPUT-OUTPUT lv_srecid,
                               INPUT-OUTPUT lv_code ).

    IF lv_object_summary <> "" THEN
        DISPLAY lv_object_summary @ fi_object_description.

    /* Display Purpose from SCM if setup. Purpose is full description
       in SCM. It is returned in a | delimited list */                
    IF NUM-ENTRIES(lv_object_description,"|":U) > 0 THEN
        ASSIGN ed_object_purpose:SCREEN-VALUE = REPLACE(lv_object_description,"|":U,CHR(10)).

    /* Display Version Update Notes from SCM if setup */                
    IF lv_object_upd_notes <> "" THEN
        ASSIGN ed_version_notes:SCREEN-VALUE = lv_object_upd_notes.

    /* Write current screen values to definition section */
    RUN update-screen-to-definitions.
    RUN importScmHistory.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup C-Win 
PROCEDURE setup :
/*------------------------------------------------------------------------------
  Purpose:     Initial setup of window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_comments         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_after_comments   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_error            AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_line             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_lookup           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_start_posn       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_end_posn         AS INTEGER      NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  DISABLE
    bu_import_scm
    bu_update_scm
    bu_import_scm_history
    .

  hScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U).

  IF VALID-HANDLE(hScmTool)
  THEN DO:
    ENABLE
      bu_import_scm
      bu_update_scm
      bu_import_scm_history
      .

    DISABLE
      fi_author
      fi_date
      fi_task
      fi_object_version
      .
  END.

    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).

    /* Get the object name if it has been saved */
    ASSIGN lv_object_name = "".
    RUN adeuib/_uibinfo.p ( ?, ?, "FILE-NAME":U, OUTPUT lv_uibinfo ).
    IF lv_uibinfo <> ? THEN
        DO:
            ASSIGN lv_uibinfo = TRIM(LC(REPLACE(lv_uibinfo,"~\":U,"/":U))).
            IF R-INDEX(lv_uibinfo,"/":U) > 0 THEN
                ASSIGN lv_uibinfo = TRIM(SUBSTRING(lv_uibinfo, R-INDEX(lv_uibinfo,"/":U) + 1)).
            ASSIGN lv_object_name = lv_uibinfo.
        END.

    /* Next populate the SCM details if we can */
    RUN getScmInfo.

    IF NUM-ENTRIES(lv_previous_versions) = 0 THEN
        DISABLE bu_import_scm_history.

    IF lv_object_name <> "" THEN    /* Object has been saved already */
      DO:
        DISPLAY lv_object_name @ fi_object_name.
        DISABLE fi_object_name.
      END.

    DISPLAY lv_task_number @ fi_task
            lv_task_userref @ fi_project_ref
            TODAY @ fi_date
            lv_user_name @ fi_author.

    IF lv_object_version > 0 THEN
        DISPLAY lv_object_version @ fi_object_version.
    ELSE
        DISPLAY 010000 @ fi_object_version.

    /* Check the structure of the comments section is as per the standards */
    /* A BIG if or assign here causes a -s stack overflow */
    ASSIGN  lv_error = NO. 
    IF INDEX(lv_comments,"File:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Description:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Purpose:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Parameters:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"History:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"v:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Task:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"UserRef:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Date:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Author:":U) = 0 THEN ASSIGN lv_error = YES.
    IF NOT lv_error AND INDEX(lv_comments,"Notes:":U) = 0 THEN ASSIGN lv_error = YES.

    /* If the definition section is in the wrong format, but the object exists in RTB, then
       give the option to overwrite definition section with details from SCM */
    IF lv_error AND VALID-HANDLE(hScmTool) AND lv_object_name <> "":U AND lv_object_version > 0 THEN
      DO:
        MESSAGE "The layout of the definition section comments is not as per the template" SKIP
                "af/sup/afcomment.i.":U SKIP(1)
                "Do you want to overwrite the comment section at the top from the details" SKIP
                "in the SCM Tool in the correct format? "
                UPDATE lv_choice AS LOGICAL
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.
        IF lv_choice = YES THEN
          DO:
            RUN reset-definitions-from-scm.
            ASSIGN lv_error = NO.       /* error now cleared */
            RETURN.
          END.                        
      END.

    IF lv_error THEN
      DO:
        DISABLE
            bu_blank_definition
            bu_import_scm
            bu_reread_definition
            bu_update_scm.
        MESSAGE "The layout of the definition section comments is not as per the template" SKIP
                "af/sup/afcomment.i. It must contain the following:" SKIP(1)
                "File:":U SKIP
                "Description:":U SKIP
                "Purpose:":U SKIP
                "Parameters:":U SKIP
                "History:":U SKIP(1)
                "and at least 1 history entry with the following text specified" SKIP(1)
                "v:":U SKIP
                "Task:":U SKIP
                "UserRef:":U SKIP
                "Date:":U SKIP
                "Author:":U SKIP
                "Update Notes:":U SKIP(1)
                "Please make the definition section conform to this standard before using" SKIP
                "this wizard."
                VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
      END.

    IF lv_object_name = "" THEN    /* Object has not been saved */
      DO:   /* Object not saved so must be created from a template - get rid of
               template comments before continuing and store the template name 
               for future use in writing a line saying where the program was
               created from */
        DISABLE bu_import_scm bu_update_scm bu_import_scm_history. /* Can't cause object not saved */
        RUN find-text(  INPUT   "File:":U,
                        INPUT   lv_comments,
                        OUTPUT  lv_template_name).
        ASSIGN lv_template_name = LC(lv_template_name).

        RUN find-text(  INPUT   "Description:":U,
                        INPUT   lv_comments,
                        OUTPUT  lv_line).
        IF INDEX(lv_line,"Template":U) <> 0 THEN 
          DO:       /* Only do this if no description is set-up - i.e. the 1st
                       time we create from a template the description will be
                       read in as ? from the template - if this has been changed
                       then we should not blank the definitions again as we will
                       lose their changes */

            /* Read in template definition section */
            ASSIGN lv_comments = "":U.
            INPUT FROM VALUE(SEARCH("af/sup/afcomment.i":U)) NO-ECHO.
            REPEAT:
                IMPORT UNFORMATTED lv_line.
                ASSIGN lv_comments = lv_comments + lv_line + CHR(10).
            END.
            INPUT CLOSE.
            /* Remove extra line-feed from end of imported comments */
            ASSIGN lv_comments = SUBSTRING(lv_comments,1,LENGTH(lv_comments) - 1).

            /* Write template name to definition section as example name the rest of comments blank */
            ASSIGN
                lv_code = ""
                lv_lookup = "File:":U
                lv_start_posn = INDEX(lv_comments,lv_lookup)
                lv_end_posn = INDEX(lv_comments,CHR(10),lv_start_posn + 1).
            IF lv_end_posn = 0 THEN
                ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup).
            ASSIGN
                lv_code =   SUBSTRING(lv_comments,1,lv_start_posn + LENGTH(lv_lookup) - 1) + /* upto the colon of File: */
                            " ":U +
                            lv_template_name +
                            CHR(10) +
                            SUBSTRING(lv_comments,lv_end_posn + 1) +
                            lv_after_comments.

            IF lv_code <> ? AND lv_code <> "" THEN
                RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                                       INPUT-OUTPUT lv_srecid,
                                       INPUT-OUTPUT lv_code ).
          END. /* IF lv_line <> "?":U */
      END.

    RUN refresh-screen-from-definitions ( INPUT lv_comments).

    /* Display Version Update Notes from SCM if setup */                
    IF lv_object_upd_notes <> "" THEN
        ASSIGN ed_version_notes:SCREEN-VALUE =
           IF ed_version_notes:SCREEN-VALUE = "" THEN
              lv_object_upd_notes
           ELSE
              (ed_version_notes:SCREEN-VALUE + CHR(10) + lv_object_upd_notes).

END.    /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-screen-to-definitions C-Win 
PROCEDURE update-screen-to-definitions :
/*------------------------------------------------------------------------------
  Purpose:     To update the screen values to the definition section
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_comments         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_after_comments   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_lookup1          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_lookup2          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lv_start_posn       AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_end_posn         AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_posn             AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE lv_loop             AS INTEGER              NO-UNDO.
DEFINE VARIABLE lv_num_entries      AS INTEGER              NO-UNDO.
DEFINE VARIABLE lv_error            AS LOGICAL              NO-UNDO.
DEFINE VARIABLE cPosseLicFile       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cPosselicense       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cLicLine            AS CHARACTER            NO-UNDO.


DO WITH FRAME {&FRAME-NAME}:

    IF lv_template_name <> "" AND INDEX(ed_version_notes:SCREEN-VALUE,lv_template_name) = 0 THEN
        ASSIGN ed_version_notes:SCREEN-VALUE =  ed_version_notes:SCREEN-VALUE +
                                                (IF NUM-ENTRIES(ed_version_notes:SCREEN-VALUE,CHR(10)) > 0 AND ENTRY(NUM-ENTRIES(ed_version_notes:SCREEN-VALUE,CHR(10)),ed_version_notes:SCREEN-VALUE,CHR(10)) <> "" THEN CHR(10) ELSE "") +
                                                "Created from Template " +
                                                lv_template_name.

    ASSIGN
        fi_object_name
        fi_object_version
        ed_object_parameters
        ed_object_purpose
        ed_version_notes
        fi_author
        fi_date
        fi_object_description
        fi_project_ref
        fi_task.

    RUN remove-trailing-lfs (INPUT-OUTPUT ed_object_parameters).
    DISPLAY ed_object_parameters.
    RUN remove-trailing-lfs (INPUT-OUTPUT ed_object_purpose).
    DISPLAY ed_object_purpose.

    /* Get the current definition section */
    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).


    /* Find the POSSE license file and load it if it exists */
    cPosseLicFile = SEARCH("af/doc/posse.lic":U).
    IF INDEX(lv_comments, "* http://www.possenet.org/license.html") = 0 AND
       cPosseLicFile <> ? THEN 
    DO:
      /* 23-MAY-2001 */
      /* Read POSSE.LIC file */
      INPUT FROM VALUE(cPosseLicFile) NO-ECHO.
      REPEAT:
        IMPORT UNFORMATTED cLicLine.
        ASSIGN cPosseLicense = cPosseLicense + cLicLine + CHR(10).
      END.
      INPUT CLOSE.
      lv_comments = cPosseLicense + lv_comments.
    END.

    /* Replace new comment section into lv_code */
    /* 1st put new object name in and the code before it */
    ASSIGN
        lv_code = ""
        lv_lookup1 = "File:":U
        lv_start_posn = INDEX(lv_comments,lv_lookup1)
        lv_end_posn = INDEX(lv_comments,CHR(10),lv_start_posn + 1).
    IF lv_end_posn = 0 THEN
        ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup1).
    ASSIGN
        lv_code =   SUBSTRING(lv_comments,1,lv_start_posn + LENGTH(lv_lookup1) - 1) + /* upto the colon of File: */
                    " ":U +
                    LC(TRIM(fi_object_name)) +
                    CHR(10).

    /* 2nd put new description in */
    ASSIGN
        lv_lookup1 = "Description:":U
        lv_start_posn = INDEX(lv_comments,lv_lookup1)
        lv_code = lv_code + SUBSTRING(lv_comments,lv_end_posn + 1,lv_start_posn - lv_end_posn + LENGTH(lv_lookup1) - 1)
        lv_end_posn = INDEX(lv_comments,CHR(10),lv_start_posn + 1).
    IF lv_end_posn = 0 THEN
        ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup1).
    ASSIGN
        lv_code =   lv_code + "  ":U +
                    TRIM(fi_object_description) +
                    CHR(10).

    /* 3rd put new purpose in. */
    ASSIGN
        lv_lookup1 = "  Purpose:":U
        lv_start_posn = INDEX(lv_comments,lv_lookup1)
        lv_code = lv_code + SUBSTRING(lv_comments,lv_end_posn + 1,lv_start_posn - lv_end_posn + LENGTH(lv_lookup1) - 1)
        lv_end_posn = INDEX(lv_comments,"  Parameters:":U,lv_start_posn + 1).
    IF lv_end_posn = 0 THEN
        ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup1).

    IF NUM-ENTRIES(ed_object_purpose,CHR(10)) > 0 THEN
        ASSIGN
            lv_code =   lv_code + "      ":U +
                        TRIM(ENTRY(1,ed_object_purpose,CHR(10))) +
                        CHR(10).
    ELSE
        ASSIGN lv_code = lv_code + CHR(10).                                   

    IF NUM-ENTRIES(ed_object_purpose,CHR(10)) > 1 THEN
      DO lv_loop = 2 TO NUM-ENTRIES(ed_object_purpose,CHR(10)):
        ASSIGN
            lv_code =   lv_code + "                ":U +
                        TRIM(ENTRY(lv_loop,ed_object_purpose,CHR(10))) +
                        CHR(10).
      END.
    ASSIGN lv_code = lv_code + CHR(10).

    /* 4th put new parameters in. */
    ASSIGN
        lv_lookup1 = "  Parameters:":U
        lv_start_posn = INDEX(lv_comments,lv_lookup1)
        lv_code = lv_code + SUBSTRING(lv_comments,lv_end_posn,lv_start_posn - lv_end_posn + LENGTH(lv_lookup1))
        lv_end_posn = INDEX(lv_comments,"  History:":U,lv_start_posn + 1).
    IF lv_end_posn = 0 THEN
        ASSIGN lv_end_posn = lv_start_posn + LENGTH(lv_lookup1).

    IF NUM-ENTRIES(ed_object_parameters,CHR(10)) > 0 THEN
        ASSIGN
            lv_code =   lv_code + "   ":U +
                        TRIM(ENTRY(1,ed_object_parameters,CHR(10))) +
                        CHR(10).
    ELSE
        ASSIGN lv_code = lv_code + CHR(10).                                   

    IF NUM-ENTRIES(ed_object_parameters,CHR(10)) > 1 THEN
      DO lv_loop = 2 TO NUM-ENTRIES(ed_object_parameters,CHR(10)):
        ASSIGN
            lv_code =   lv_code + "                ":U +
                        TRIM(ENTRY(lv_loop,ed_object_parameters,CHR(10))) +
                        CHR(10).
      END.
    ASSIGN lv_code = lv_code + CHR(10).

    /* 5th put new version history entry in. If our version exists, then replace the notes
       or else just tag some new notes onto the end. */
    RUN write-version-history-entry
            (   INPUT           lv_comments,
                INPUT-OUTPUT    lv_end_posn,
                INPUT-OUTPUT    lv_code,
                INPUT           fi_object_version,
                INPUT           fi_task,
                INPUT           fi_project_ref,
                INPUT           fi_date,
                INPUT           fi_author,
                INPUT           ed_version_notes).

    /* Finally append the rest of the comments until the end of the comments */ 
    ASSIGN lv_code = lv_code + SUBSTRING(lv_comments,lv_end_posn).    

    /* Write back new definition section with updated comments */
    ASSIGN lv_code = lv_code + lv_after_comments.

    IF lv_code <> ? AND lv_code <> "" THEN
        RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                               INPUT-OUTPUT lv_srecid,
                               INPUT-OUTPUT lv_code ).


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-window C-Win 
PROCEDURE validate-window :
/*------------------------------------------------------------------------------
  Purpose:     To validate whether the window is correct and return an error
               if not. If the return-value is returned as "ERROR" then no warning
               will be given, otherwise a warning of the return-value will be
               given to the user. 
               Any return value will cause the window not to be closed, as controlled
               by the wizard controller.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_comments         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_after_comments   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_error            AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_line             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_lookup           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_start_posn       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_end_posn         AS INTEGER      NO-UNDO.
DEFINE VARIABLE cPrecid             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectPM           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectPath         AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

 /* update information automatically*/    
 ASSIGN
     fi_object_name
     fi_object_version
     fi_object_description.

 ASSIGN cObjectPM = TRIM(ENTRY(1, cProductModule, '/':u)).
     
 FIND FIRST gsc_product_module NO-LOCK WHERE gsc_product_module.product_module_code =
                                             cObjectPM NO-ERROR.
 IF AVAILABLE gsc_product_module THEN
   ASSIGN cObjectPath = gsc_product_module.relative_path
          cObjectPM   = gsc_product_module.product_module_code.

 /* Assign this info to the _P record for this viewer */
 RUN adeuib/_uibinfo.p (INPUT ?, INPUT ?, INPUT "PROCEDURE":U, OUTPUT cPrecid).
 getFuncLibHandle().
 DYNAMIC-FUNCTION("setDynamicProcData":U IN gFuncLibHdl, 
                            INTEGER(cPrecid),
                            fi_object_name,
                            fi_object_description,
                            cObjectPM,
                            cObjectPath).

/*
   /* Change the TITLE of the design window */
   IF fi_object_name NE "":U THEN DO:
     /* Get the handle of the window */
     RUN adeuib/_uibinfo.p(?,'WINDOW ?','HANDLE', OUTPUT cWin).
     hWin = WIDGET-HANDLE(cWin).
     IF NUM-ENTRIES(hWin:TITLE,"-":U) > 1 THEN
         hWin:TITLE = ENTRY(1, hWin:TITLE, "-":U) + " - " + fi_object_name.
   END.
*/
/*    MESSAGE "Are you sure you want to update the definition section comment block with the" SKIP
 *             "object details and version notes for object " + fi_object_name + ", version " + STRING(fi_object_version,"999999":U) + " !"
 *             UPDATE lv_continue AS LOGICAL
 *             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.
 * 
 *     IF NOT lv_continue THEN RETURN NO-APPLY.*/

    RUN update-screen-to-definitions.

    APPLY "CHOOSE":U TO bu_update_scm.




    /* Read definition section of program, and ensure a valid object, description,
       purpose, and version notes for the current version have been entered
    */    
  
    RUN read-current-definitions (  OUTPUT lv_comments,
                                    OUTPUT lv_after_comments).
    
    /* Check the object name from the definition section */
    RUN find-text(  INPUT   "File:":U,
                    INPUT   lv_comments,
                    OUTPUT  lv_line).
    IF LENGTH(lv_line) = 0 THEN 
        RETURN "Please update the definition section with an object name".

    IF LENGTH(lv_object_name) > 0 AND lv_object_name <> lv_line THEN
        RETURN "Please correct the object name in the definition section". 

    /****************************
    /* Check the description of the object from the definition section */
    RUN find-text(  INPUT   "Description:":U,
                    INPUT   lv_comments,
                    OUTPUT  lv_line).
    IF LENGTH(lv_line) = 0 THEN 
        RETURN "Please update the definition section with an object description".

    /* Check the object purpose from definition section */
    RUN find-block( INPUT   "Purpose:":U,
                    INPUT   "Parameters:":U,
                    INPUT   lv_comments,
                    INPUT   1,
                    OUTPUT  lv_line).
    IF LENGTH(lv_line) = 0 THEN 
        RETURN "Please update the definition section with an object purpose".


    /* Check the version history notes exist for this object version */
    ASSIGN
        lv_line = "":U
        lv_start_posn = INDEX(lv_comments,"(v:":U + fi_object_version:SCREEN-VALUE).
    IF lv_start_posn > 0 THEN
      DO:    
        IF INDEX(lv_comments,"(v:":U,lv_start_posn + 1) > 0 THEN
            RUN find-block( INPUT   "Notes:":U,
                            INPUT   "(v:":U,
                            INPUT   lv_comments,
                            INPUT   lv_start_posn,
                            OUTPUT  lv_line).
        ELSE    /* Last version notes */
            RUN find-block( INPUT   "Notes:":U,
                            INPUT   "------------------------":U,
                            INPUT   lv_comments,
                            INPUT   lv_start_posn,
                        OUTPUT  lv_line).
      END.
    IF LENGTH(lv_line) = 0 THEN 
        RETURN "Please update the definition section with version notes for this version".
******************************************************/
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-version-history-entry C-Win 
PROCEDURE write-version-history-entry :
/*------------------------------------------------------------------------------
  Purpose:     To write an entry in the version history for the passed in object
               version. If a version entry already exists, then it will be replaced,
               else it will be added on to the end of the version history.
  Parameters:  INPUT        ip_comments         Current contents of comments
               INPUT-OUTPUT iop_code            New code written so far
               INPUT-OUTPUT iop_comments_posn    Pointer to end of new code written so far
               INPUT        ip_object_version   Version of object notes are for
               INPUT        ip_task_number
               INPUT        ip_project_ref
               INPUT        ip_task_date
               INPUT        ip_author
               INPUT        ip_update_notes
  Notes:       
------------------------------------------------------------------------------*/

DEFINE  INPUT PARAMETER         ip_comments         AS CHARACTER    NO-UNDO.
DEFINE  INPUT-OUTPUT PARAMETER  iop_comments_posn   AS INTEGER      NO-UNDO.
DEFINE  INPUT-OUTPUT PARAMETER  iop_code            AS CHARACTER    NO-UNDO.
DEFINE  INPUT PARAMETER         ip_object_version   AS INTEGER      NO-UNDO.
DEFINE  INPUT PARAMETER         ip_task_number      AS INTEGER      NO-UNDO.
DEFINE  INPUT PARAMETER         ip_project_ref      AS CHARACTER    NO-UNDO.
DEFINE  INPUT PARAMETER         ip_task_date        AS DATE         NO-UNDO.
DEFINE  INPUT PARAMETER         ip_author           AS CHARACTER    NO-UNDO.
DEFINE  INPUT PARAMETER         ip_version_notes    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE                 lv_start_posn       AS INTEGER      NO-UNDO.
DEFINE VARIABLE                 lv_posn             AS INTEGER      NO-UNDO.
DEFINE VARIABLE                 lv_loop             AS INTEGER      NO-UNDO.

/* Look for existing version notes for this version */
ASSIGN lv_start_posn = INDEX(ip_comments,"  (v:":U + STRING(ip_object_version,"999999":U)).

/* If none exist, append to end of version notes - i.e. just before end of
   comments section indicated by ---------------- comment */
IF lv_start_posn = 0 THEN
  DO:   /* look for last version note and use after this as start position */
    ASSIGN
        lv_start_posn = R-INDEX(ip_comments,"Notes:":U)
        lv_posn = INDEX(ip_comments,"------------------------------------*/":U,lv_start_posn)
        lv_posn = R-INDEX(ip_comments,CHR(10),lv_posn).
    DO WHILE SUBSTRING(ip_comments,lv_posn,1) = CHR(10):
        ASSIGN lv_posn = lv_posn - 1.
    END.
    ASSIGN lv_start_posn = lv_posn + 3.
  END.

/* write code from last code added upto the start position of this new section, if
   it is not there yet ! */
IF INDEX(iop_code,"  History:":U) = 0 THEN
    ASSIGN iop_code = iop_code + SUBSTRING(ip_comments,iop_comments_posn,lv_start_posn - iop_comments_posn - 1) + CHR(10).

/* Find next new position in comments to start searching from */
ASSIGN iop_comments_posn = INDEX(ip_comments,"  (v:":U,lv_start_posn + 1).
IF iop_comments_posn = 0 THEN /* last version history entry */
    ASSIGN iop_comments_posn = INDEX(ip_comments,"------------------------":U,lv_start_posn + 1).

/* insert new version notes */
ASSIGN
    iop_code =  iop_code + "  (v:":U + STRING(ip_object_version,"999999":U) +
                ")    Task:   ":U + STRING(ip_task_number,"ZZZZZZZZ9":U) + 
                "   UserRef:    ":U + ip_project_ref +
                CHR(10) + "                Date:   ":U + STRING(ip_task_date,"99/99/9999":U) +
                "  Author:     ":U + ip_author +
                CHR(10) + CHR(10) +
                "  Update Notes: ":U.

RUN remove-trailing-lfs (INPUT-OUTPUT ip_version_notes).

IF NUM-ENTRIES(ip_version_notes,CHR(10)) > 0 THEN
    ASSIGN
        iop_code =   iop_code +
                    TRIM(ENTRY(1,ip_version_notes,CHR(10))) +
                    CHR(10).
ELSE
    ASSIGN iop_code = iop_code + CHR(10).                                   

IF NUM-ENTRIES(ip_version_notes,CHR(10)) > 1 THEN
  DO lv_loop = 2 TO NUM-ENTRIES(ip_version_notes,CHR(10)):
    ASSIGN
        iop_code =   iop_code + "                ":U +
                    TRIM(ENTRY(lv_loop,ip_version_notes,CHR(10))) +
                    CHR(10).
  END.

/* Ensure empty line at end */
ASSIGN iop_code = iop_code + CHR(10).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle C-Win 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the AppBuilder function library .   
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(gFuncLibHdl) THEN 
  DO:
      gFuncLibHdl = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(gFuncLibHdl):
        IF gFuncLibHdl:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        gFuncLibHdl = gFuncLibHdl:NEXT-SIBLING.
      END.
  END.
  RETURN gFuncLibHdl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle C-Win 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

