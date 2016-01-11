&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
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
/*---------------------------------------------------------------------------------
  File: rydynprf1v.w

  Description:  Preferences Viewer 1

  Purpose:      Preferences Viewer 1

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6179   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
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
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynprf1v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiReportDirectory BuClearSesFilters ~
BuClearPerFilters BuClearSesSDO BuClearPerSDO toSaveWindowPositions ~
buClearWindowPositions toTopOnly BuClearTopOnly ToDebugEnabled ~
toShowTooltips toDisplayRepository 
&Scoped-Define DISPLAYED-OBJECTS fiReportDirectory ToSesFiltersActive ~
ToPerFiltersActive ToSesSDOActive ToPerSDOActive toSaveWindowPositions ~
toTopOnly ToDebugEnabled toShowTooltips toDisplayRepository 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BuClearPerFilters 
     LABEL "C&lear All" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved permanent filter settings"
     BGCOLOR 8 .

DEFINE BUTTON BuClearPerSDO 
     LABEL "C&lear All" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved permanent sdo attribute settings"
     BGCOLOR 8 .

DEFINE BUTTON BuClearSesFilters 
     LABEL "C&lear All" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved filter settings for session"
     BGCOLOR 8 .

DEFINE BUTTON BuClearSesSDO 
     LABEL "C&lear All" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved sdo attribute settings for session"
     BGCOLOR 8 .

DEFINE BUTTON BuClearTopOnly 
     LABEL "Clear &All" 
     SIZE 15 BY 1 TOOLTIP "Remove top only setting from all windows for user"
     BGCOLOR 8 .

DEFINE BUTTON buClearWindowPositions 
     LABEL "Cl&ear All" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved window positions and sizes for current user"
     BGCOLOR 8 .

DEFINE VARIABLE fiReportDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Report Directory" 
     VIEW-AS FILL-IN 
     SIZE 50.4 BY 1 TOOLTIP "Root Directory containing report definition files (*.rpt) e.g. g:/gs/dev/" NO-UNDO.

DEFINE VARIABLE ToDebugEnabled AS LOGICAL INITIAL no 
     LABEL "Debug Alert Enabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE toDisplayRepository AS LOGICAL INITIAL no 
     LABEL "Display &Repository Data?" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.4 BY 1 NO-UNDO.

DEFINE VARIABLE ToPerFiltersActive AS LOGICAL INITIAL no 
     LABEL "Filterts Active Permanently" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.4 BY 1 NO-UNDO.

DEFINE VARIABLE ToPerSDOActive AS LOGICAL INITIAL no 
     LABEL "SDO Attributes Active Permanently" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.8 BY 1 NO-UNDO.

DEFINE VARIABLE toSaveWindowPositions AS LOGICAL INITIAL no 
     LABEL "Save &Window Positions && Sizes" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.8 BY 1 NO-UNDO.

DEFINE VARIABLE ToSesFiltersActive AS LOGICAL INITIAL no 
     LABEL "Filters Active for Session" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.4 BY 1 NO-UNDO.

DEFINE VARIABLE ToSesSDOActive AS LOGICAL INITIAL no 
     LABEL "SDO Attributes Active for Session" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.8 BY 1 NO-UNDO.

DEFINE VARIABLE toShowTooltips AS LOGICAL INITIAL no 
     LABEL "&Show Tooltips" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.4 BY 1 NO-UNDO.

DEFINE VARIABLE toTopOnly AS LOGICAL INITIAL no 
     LABEL "&Top Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 48.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiReportDirectory AT ROW 1.38 COL 20.6 COLON-ALIGNED
     ToSesFiltersActive AT ROW 2.62 COL 22.4
     BuClearSesFilters AT ROW 2.62 COL 73
     ToPerFiltersActive AT ROW 3.81 COL 22.4
     BuClearPerFilters AT ROW 3.81 COL 73
     ToSesSDOActive AT ROW 5 COL 22.4
     BuClearSesSDO AT ROW 5 COL 73
     ToPerSDOActive AT ROW 6.19 COL 22.4
     BuClearPerSDO AT ROW 6.19 COL 73
     toSaveWindowPositions AT ROW 7.38 COL 22.4
     buClearWindowPositions AT ROW 7.38 COL 73
     toTopOnly AT ROW 8.57 COL 22.4
     BuClearTopOnly AT ROW 8.57 COL 73
     ToDebugEnabled AT ROW 9.76 COL 22.4
     toShowTooltips AT ROW 10.81 COL 22.4
     toDisplayRepository AT ROW 11.95 COL 22.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 11.95
         WIDTH              = 87.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX ToPerFiltersActive IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToPerSDOActive IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToSesFiltersActive IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToSesSDOActive IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BuClearPerFilters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearPerFilters sObject
ON CHOOSE OF BuClearPerFilters IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Clear all filter settings for user - session and permanent.
  Notes:       
------------------------------------------------------------------------------*/
DO:

  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Permanent Browse Filters",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Permanent Browse Filters":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    RUN setProfileData IN gshProfileManager (INPUT "BrwFilters":U,
                                             INPUT "FilterSet":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "":U,
                                             INPUT YES,     /* delete */
                                             INPUT "PER":U).
    RUN updateCacheToDb IN gshProfileManager (INPUT "BrwFilters":U).

    /* See if any saved filters still active and display accordingly */
    DEFINE VARIABLE lExists AS LOGICAL INITIAL NO NO-UNDO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "BrwFilters":U,
                                                     INPUT "FilterSet":U,
                                                     INPUT "":U,
                                                     INPUT YES,
                                                     INPUT NO,
                                                     OUTPUT lExists).
    ASSIGN ToPerFiltersActive:SCREEN-VALUE = STRING(lExists).

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BuClearPerSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearPerSDO sObject
ON CHOOSE OF BuClearPerSDO IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Clear all sdo settings for user - session and permanent.
  Notes:       
------------------------------------------------------------------------------*/
DO:

  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Permanent SDO Attributes",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Permanent SDO Attributes":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    RUN setProfileData IN gshProfileManager (INPUT "SDO":U,
                                             INPUT "Attributes":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "":U,
                                             INPUT YES,     /* delete */
                                             INPUT "PER":U).
    RUN updateCacheToDb IN gshProfileManager (INPUT "Attributes":U).

    /* See if any saved filters still active and display accordingly */
    DEFINE VARIABLE lExists AS LOGICAL INITIAL NO NO-UNDO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                     INPUT "Attributes":U,
                                                     INPUT "":U,
                                                     INPUT YES,
                                                     INPUT NO,
                                                     OUTPUT lExists).
    ASSIGN ToPerSDOActive:SCREEN-VALUE = STRING(lExists).

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BuClearSesFilters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearSesFilters sObject
ON CHOOSE OF BuClearSesFilters IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Clear all filter settings for user - session and permanent.
  Notes:       
------------------------------------------------------------------------------*/
DO:

  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Session Browse Filters",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Session Browse Filters":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO:
    RUN setProfileData IN gshProfileManager (INPUT "BrwFilters":U,
                                             INPUT "FilterSet":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "":U,
                                             INPUT YES,     /* delete */
                                             INPUT "SES":U).

    /* See if any saved filters active and display accordingly */
    DEFINE VARIABLE lExists AS LOGICAL INITIAL NO NO-UNDO.
    ASSIGN lExists = NO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "BrwFilters":U,
                                                     INPUT "FilterSet":U,
                                                     INPUT "":U,
                                                     INPUT NO,
                                                     INPUT YES,
                                                     OUTPUT lExists).
    ASSIGN ToSesFiltersActive:SCREEN-VALUE = STRING(lExists).
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BuClearSesSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearSesSDO sObject
ON CHOOSE OF BuClearSesSDO IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Clear all sdo settings for user - session and permanent.
  Notes:       
------------------------------------------------------------------------------*/
DO:

  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Session SDO Attributes",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Session SDO Attributes":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO:
    RUN setProfileData IN gshProfileManager (INPUT "SDO":U,
                                             INPUT "Attributes":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "":U,
                                             INPUT YES,     /* delete */
                                             INPUT "SES":U).

    /* See if any saved sdo attributes active and display accordingly */
    DEFINE VARIABLE lExists AS LOGICAL INITIAL NO NO-UNDO.
    ASSIGN lExists = NO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                     INPUT "Attributes":U,
                                                     INPUT "":U,
                                                     INPUT NO,
                                                     INPUT YES,
                                                     OUTPUT lExists).
    ASSIGN ToSesSDOActive:SCREEN-VALUE = STRING(lExists).
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BuClearTopOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearTopOnly sObject
ON CHOOSE OF BuClearTopOnly IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Update all top-only parameters for this user and clear them
  Notes:       
------------------------------------------------------------------------------*/
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Window Top Only Settings",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Window Top Only Settings":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO:
    DEFINE VARIABLE rRowid                AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileData          AS CHARACTER  NO-UNDO.
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "TopOnly":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "NO":U,
                                             INPUT YES,     /* delete */
                                             INPUT "PER":U).
    /* Get Top Only for Caller */
    IF gcCallerName <> "":U THEN
    DO:
      ASSIGN rRowid = ?.
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                               INPUT "TopOnly":U,
                                               INPUT gcCallerName,
                                               INPUT NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cProfileData).
      ASSIGN
        toTopOnly:SCREEN-VALUE = STRING(cProfileData = "YES":U).
    END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClearWindowPositions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClearWindowPositions sObject
ON CHOOSE OF buClearWindowPositions IN FRAME frMain /* Clear All */
/*------------------------------------------------------------------------------
  Purpose:     Remove all window geometry parameter records for this user
  Notes:       
------------------------------------------------------------------------------*/
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  RUN askQuestion IN gshSessionManager (INPUT "Clear Window Positions and Sizes",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear Window Positions and Sizes":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
  DO:
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SizePos":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "NO":U,
                                             INPUT YES,     /* delete */
                                             INPUT "PER":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiReportDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiReportDirectory sObject
ON VALUE-CHANGED OF fiReportDirectory IN FRAME frMain /* Report Directory */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToDebugEnabled
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToDebugEnabled sObject
ON VALUE-CHANGED OF ToDebugEnabled IN FRAME frMain /* Debug Alert Enabled */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDisplayRepository
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDisplayRepository sObject
ON VALUE-CHANGED OF toDisplayRepository IN FRAME frMain /* Display Repository Data? */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSaveWindowPositions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSaveWindowPositions sObject
ON VALUE-CHANGED OF toSaveWindowPositions IN FRAME frMain /* Save Window Positions  Sizes */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toShowTooltips
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toShowTooltips sObject
ON VALUE-CHANGED OF toShowTooltips IN FRAME frMain /* Show Tooltips */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toTopOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toTopOnly sObject
ON VALUE-CHANGED OF toTopOnly IN FRAME frMain /* Top Only */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* save handle of calling container */
  ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).
  IF VALID-HANDLE(ghCallerHandle) THEN
    ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN ghCallerHandle).
  IF VALID-HANDLE(ghCallerHandle) AND
     LOOKUP("getLogicalObjectName":U, ghCallerHandle:INTERNAL-ENTRIES) > 0 THEN
    gcCallerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN ghCallerHandle).  

  /* Display current data values */
  DO WITH FRAME {&FRAME-NAME}:

    DEFINE VARIABLE rRowid                AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileData          AS CHARACTER  NO-UNDO.

    /* Get Report Directory */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                             INPUT "ReportDir":U,
                                             INPUT "ReportDir":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).
    ASSIGN
      fiReportDirectory:SCREEN-VALUE = cProfileData.

    /* Get Window Positions / Sizes Setting */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).
    ASSIGN
      toSaveWindowPositions:SCREEN-VALUE = STRING(cProfileData <> "NO":U).

    /* Get Top Only for Caller */
    IF gcCallerName <> "":U THEN
    DO:
      ENABLE toTopOnly.
      ASSIGN rRowid = ?.
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                               INPUT "TopOnly":U,
                                               INPUT gcCallerName,
                                               INPUT NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cProfileData).
      ASSIGN
        toTopOnly:SCREEN-VALUE = STRING(cProfileData = "YES":U).
    END.
    ELSE 
    DO:
      toTopOnly:SCREEN-VALUE = "NO":U.
      DISABLE toTopOnly.
    END.

    ASSIGN ToDebugEnabled:SCREEN-VALUE = STRING(SESSION:DEBUG-ALERT).
    ASSIGN toShowTooltips:SCREEN-VALUE = STRING(SESSION:TOOLTIPS).

    /* See if any saved filters active and display accordingly */
    DEFINE VARIABLE lExists AS LOGICAL INITIAL NO NO-UNDO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "BrwFilters":U,
                                                     INPUT "FilterSet":U,
                                                     INPUT "":U,
                                                     INPUT YES,
                                                     INPUT NO,
                                                     OUTPUT lExists).
    ASSIGN ToPerFiltersActive:SCREEN-VALUE = STRING(lExists).

    ASSIGN lExists = NO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "BrwFilters":U,
                                                     INPUT "FilterSet":U,
                                                     INPUT "":U,
                                                     INPUT NO,
                                                     INPUT YES,
                                                     OUTPUT lExists).
    ASSIGN ToSesFiltersActive:SCREEN-VALUE = STRING(lExists).

    /* See if any saved sdo filters active and display accordingly */
    DEFINE VARIABLE lExists2 AS LOGICAL INITIAL NO NO-UNDO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                     INPUT "Attributes":U,
                                                     INPUT "":U,
                                                     INPUT YES,
                                                     INPUT NO,
                                                     OUTPUT lExists2).
    ASSIGN ToPerSDOActive:SCREEN-VALUE = STRING(lExists2).

    ASSIGN lExists2 = NO.
    RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                     INPUT "Attributes":U,
                                                     INPUT "":U,
                                                     INPUT NO,
                                                     INPUT YES,
                                                     OUTPUT lExists2).
    ASSIGN ToSesSDOActive:SCREEN-VALUE = STRING(lExists2).

    /* Display Repository?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN toDisplayRepository:CHECKED = cProfileData EQ "YES":U.
  END.


  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of contaner which will give
     us the containers toolbar.
     We then subscribe this procedure to toolbar events in the containers toolbar so
     that we can action an OK or CANCEL being pressed in the toolbar.
     We also subscribe the container toolbar to update states in this procedure so we
     can change the state of the toolbar into update mode when something is changed
     on the viewer.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord sObject 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.

 DO WITH FRAME {&FRAME-NAME}: 
          /* save our data */
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "ReportDir":U,
                                                   INPUT "ReportDir":U,
                                                   INPUT ?,
                                                   INPUT fiReportDirectory:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* save our data */
          RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                                   INPUT "SaveSizPos":U,
                                                   INPUT "SaveSizPos":U,
                                                   INPUT ?,
                                                   INPUT toSaveWindowPositions:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* save our data */
          IF gcCallerName <> "":U THEN
          DO:
            RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                                     INPUT "TopOnly":U,
                                                     INPUT gcCallerName,
                                                     INPUT ?,
                                                     INPUT toTopOnly:SCREEN-VALUE,
                                                     INPUT NO,
                                                     INPUT "PER":U).
           
            IF VALID-HANDLE(ghCallerHandle) AND LOOKUP("setTopOnly":U, ghCallerHandle:INTERNAL-ENTRIES) > 0 THEN
            DO:
/*               RUN "setTopOnly":U IN ghCallerHandle (INPUT toTopOnly:SCREEN-VALUE = "YES":U). */
                DYNAMIC-FUNCTION("setTopOnly":U IN ghCallerHandle,INPUT toTopOnly:SCREEN-VALUE = "yes":U).
            END.
          END.

          /* save our data */
          RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                                   INPUT "DebugAlert":U,
                                                   INPUT "DebugAlert":U,
                                                   INPUT ?,
                                                   INPUT ToDebugEnabled:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).
          SESSION:DEBUG-ALERT = ToDebugEnabled:SCREEN-VALUE = "YES":U.

          /* save our data */
          RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                                   INPUT "Tooltips":U,
                                                   INPUT "Tooltips":U,
                                                   INPUT ?,
                                                   INPUT toShowTooltips:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).
          SESSION:TOOLTIPS = toShowTooltips:SCREEN-VALUE = "YES":U.

          /* Save the DisplayRepository flag. **/
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "DispRepos":U,
                                                   INPUT "DispRepos":U,
                                                   INPUT ?,
                                                   INPUT STRING(toDisplayRepository:INPUT-VALUE),
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* instruct the other viewers to do likewise */
          lContinue = TRUE.  
          {set DataModified FALSE}.
          PUBLISH 'user1' (INPUT 'ok', INPUT-OUTPUT lContinue).
          RETURN.
      END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged sObject 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Procedure fired on value changed of any of the widgets on the viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT glModified THEN
  DO:
    glModified = TRUE.
    {set dataModified TRUE}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

