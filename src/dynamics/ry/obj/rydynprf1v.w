&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
* Copyright (C) 2000,2007 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
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

  (v:010001)    Task:           0   UserRef:    
                Date:   04/04/2002  Author:     Mark Davies (MIP

  Update Notes: Added Source Language combo. This is part of the Menu Translation implementation required.

--------------------------------------------------------------------------------*/
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

{src/adm2/globals.i}
{src/adm2/ttcombo.i}
{af/app/afttsecurityctrl.i}
{af/app/afttglobalctrl.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.
DEFINE VARIABLE gcCallerName                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCallerHandle              AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDFCacheManager           AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiReportDirectory coSourceLanguage ~
flnTemplate flnPalette coFilterSet coMessageBoxType BuClearSesFilters ~
ToDebugEnabled BuClearPerFilters toShowTooltips BuClearSesSDO ~
toInitPagesForTrans BuClearPerSDO toCustomizeDefault buClearWindowPositions ~
toSaveWindowPositions buClearSDFCache BuClearTopOnly toTopOnly 
&Scoped-Define DISPLAYED-OBJECTS fiReportDirectory coSourceLanguage ~
flnTemplate flnPalette coFilterSet ToSesFiltersActive ToDebugEnabled ~
ToPerFiltersActive toShowTooltips ToSesSDOActive toInitPagesForTrans ~
ToPerSDOActive toCustomizeDefault toSaveWindowPositions toTopOnly 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BuClearPerFilters 
     LABEL "C&lear All >>" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved permanent filter settings"
     BGCOLOR 8 .

DEFINE BUTTON BuClearPerSDO 
     LABEL "C&lear All >>" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved permanent sdo attribute settings"
     BGCOLOR 8 .

DEFINE BUTTON buClearSDFCache 
     LABEL "Clear &SDF Cache" 
     SIZE 19.6 BY 1.14 TOOLTIP "Clear SDF client cache"
     BGCOLOR 8 .

DEFINE BUTTON BuClearSesFilters 
     LABEL "C&lear All >>" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved filter settings for session"
     BGCOLOR 8 .

DEFINE BUTTON BuClearSesSDO 
     LABEL "C&lear All >>" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved sdo attribute settings for session"
     BGCOLOR 8 .

DEFINE BUTTON BuClearTopOnly 
     LABEL "Clear &All >>" 
     SIZE 15 BY 1 TOOLTIP "Remove top only setting from all windows for user"
     BGCOLOR 8 .

DEFINE BUTTON buClearWindowPositions 
     LABEL "Cl&ear All >>" 
     SIZE 15 BY 1 TOOLTIP "Clear all saved window positions and sizes for current user"
     BGCOLOR 8 .

DEFINE VARIABLE coFilterSet AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Session Filter Set" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","0"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE coMessageBoxType AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Message Box Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Simple","Simple",
                     "Detail","Detail",
                     "Complex","Complex"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE coSourceLanguage AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Source language" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE fiReportDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Report directory" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Root Directory containing report definition files (*.rpt) e.g. g:/gs/dev/" NO-UNDO.

DEFINE VARIABLE flnPalette AS CHARACTER FORMAT "X(256)":U 
     LABEL "Custom palettes" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE flnTemplate AS CHARACTER FORMAT "X(256)":U 
     LABEL "Custom templates" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE toCustomizeDefault AS LOGICAL INITIAL no 
     LABEL "&Customize from default layout" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.6 BY 1 TOOLTIP "When off, customized layouts will build from previous layouts" NO-UNDO.

DEFINE VARIABLE ToDebugEnabled AS LOGICAL INITIAL no 
     LABEL "Debug alert enabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.6 BY 1 NO-UNDO.

DEFINE VARIABLE toInitPagesForTrans AS LOGICAL INITIAL no 
     LABEL "Initialize all pages when translating" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE ToPerFiltersActive AS LOGICAL INITIAL no 
     LABEL "Filters active permanently" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.6 BY 1 NO-UNDO.

DEFINE VARIABLE ToPerSDOActive AS LOGICAL INITIAL no 
     LABEL "SDO attributes active permanently" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.6 BY 1 NO-UNDO.

DEFINE VARIABLE toSaveWindowPositions AS LOGICAL INITIAL no 
     LABEL "Save &window positions && sizes" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE ToSesFiltersActive AS LOGICAL INITIAL no 
     LABEL "Filters active for session" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.6 BY 1 NO-UNDO.

DEFINE VARIABLE ToSesSDOActive AS LOGICAL INITIAL no 
     LABEL "SDO attributes active for session" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE toShowTooltips AS LOGICAL INITIAL no 
     LABEL "&Show tooltips" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.6 BY 1 NO-UNDO.

DEFINE VARIABLE toTopOnly AS LOGICAL INITIAL no 
     LABEL "&Top only" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiReportDirectory AT ROW 1.48 COL 20 COLON-ALIGNED
     coSourceLanguage AT ROW 2.62 COL 20 COLON-ALIGNED
     flnTemplate AT ROW 3.81 COL 20 COLON-ALIGNED
     flnPalette AT ROW 4.95 COL 20 COLON-ALIGNED
     coFilterSet AT ROW 6.1 COL 20 COLON-ALIGNED
     coMessageBoxType AT ROW 7.38 COL 20 COLON-ALIGNED WIDGET-ID 2
     BuClearSesFilters AT ROW 8.71 COL 5.8
     ToSesFiltersActive AT ROW 8.71 COL 22
     ToDebugEnabled AT ROW 8.71 COL 61.4
     BuClearPerFilters AT ROW 9.91 COL 5.8
     ToPerFiltersActive AT ROW 9.91 COL 22
     toShowTooltips AT ROW 9.91 COL 61.4
     BuClearSesSDO AT ROW 11.1 COL 5.8
     ToSesSDOActive AT ROW 11.1 COL 22
     toInitPagesForTrans AT ROW 11.1 COL 61.4
     BuClearPerSDO AT ROW 12.29 COL 5.8
     ToPerSDOActive AT ROW 12.29 COL 22
     toCustomizeDefault AT ROW 12.29 COL 61.4
     buClearWindowPositions AT ROW 13.48 COL 5.8
     toSaveWindowPositions AT ROW 13.48 COL 22
     buClearSDFCache AT ROW 13.52 COL 61.4
     BuClearTopOnly AT ROW 14.67 COL 5.8
     toTopOnly AT ROW 14.67 COL 22
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
         HEIGHT             = 14.67
         WIDTH              = 98.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX coMessageBoxType IN FRAME frMain
   NO-DISPLAY                                                           */
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
ON CHOOSE OF BuClearPerFilters IN FRAME frMain /* Clear All >> */
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
ON CHOOSE OF BuClearPerSDO IN FRAME frMain /* Clear All >> */
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


&Scoped-define SELF-NAME buClearSDFCache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClearSDFCache sObject
ON CHOOSE OF buClearSDFCache IN FRAME frMain /* Clear SDF Cache */
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
  
  RUN askQuestion IN gshSessionManager (INPUT "Do you want to clear all the cached data for all SmartDataFields?",    /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&Yes":U,         /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Clear SmartDataField Cache":U, /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton = "&Yes":U THEN
    RUN clearCache IN ghSDFCacheManager NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BuClearSesFilters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuClearSesFilters sObject
ON CHOOSE OF BuClearSesFilters IN FRAME frMain /* Clear All >> */
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
ON CHOOSE OF BuClearSesSDO IN FRAME frMain /* Clear All >> */
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
ON CHOOSE OF BuClearTopOnly IN FRAME frMain /* Clear All >> */
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
ON CHOOSE OF buClearWindowPositions IN FRAME frMain /* Clear All >> */
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
    /* Clear TreeView width */
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "DynTVSize":U,
                                             INPUT "":U,
                                             INPUT ?,
                                             INPUT "NO":U,
                                             INPUT YES,     /* delete */
                                             INPUT "PER":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFilterSet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterSet sObject
ON VALUE-CHANGED OF coFilterSet IN FRAME frMain /* Session Filter Set */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coMessageBoxType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coMessageBoxType sObject
ON VALUE-CHANGED OF coMessageBoxType IN FRAME frMain /* Message Box Type */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSourceLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSourceLanguage sObject
ON VALUE-CHANGED OF coSourceLanguage IN FRAME frMain /* Source language */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiReportDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiReportDirectory sObject
ON VALUE-CHANGED OF fiReportDirectory IN FRAME frMain /* Report directory */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME flnPalette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL flnPalette sObject
ON VALUE-CHANGED OF flnPalette IN FRAME frMain /* Custom palettes */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME flnTemplate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL flnTemplate sObject
ON VALUE-CHANGED OF flnTemplate IN FRAME frMain /* Custom templates */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toCustomizeDefault
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toCustomizeDefault sObject
ON VALUE-CHANGED OF toCustomizeDefault IN FRAME frMain /* Customize from default layout */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToDebugEnabled
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToDebugEnabled sObject
ON VALUE-CHANGED OF ToDebugEnabled IN FRAME frMain /* Debug alert enabled */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toInitPagesForTrans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toInitPagesForTrans sObject
ON VALUE-CHANGED OF toInitPagesForTrans IN FRAME frMain /* Initialize all pages when translating */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSaveWindowPositions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSaveWindowPositions sObject
ON VALUE-CHANGED OF toSaveWindowPositions IN FRAME frMain /* Save window positions  sizes */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toShowTooltips
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toShowTooltips sObject
ON VALUE-CHANGED OF toShowTooltips IN FRAME frMain /* Show tooltips */
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toTopOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toTopOnly sObject
ON VALUE-CHANGED OF toTopOnly IN FRAME frMain /* Top only */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DEFINE VARIABLE cFilterSet  AS CHARACTER  NO-UNDO.

  RUN SUPER.
  
  IF NOT CAN-FIND(FIRST ttSecurityControl) OR
     NOT CAN-FIND(FIRST ttGlobalControl) THEN
  DO:
    RUN af/app/afgetgansp.p ON gshAstraAppserver (OUTPUT TABLE ttGlobalControl,
                                                  OUTPUT TABLE ttSecurityControl).
    FIND FIRST ttGlobalControl NO-ERROR.
    FIND FIRST ttSecurityControl NO-ERROR.
  END.
  
  /* Get handle to SDF Cache Manager */
  ghSDFCacheManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "SDFCacheManager":U).

  IF NOT VALID-HANDLE(ghSDFCacheManager) THEN
    DISABLE buClearSDFCache WITH FRAME {&FRAME-NAME}.
  ELSE
    ENABLE buClearSDFCache WITH FRAME {&FRAME-NAME}.

  /* save handle of calling container */
  ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN THIS-PROCEDURE).
  IF VALID-HANDLE(ghCallerHandle) THEN
    ghCallerHandle = DYNAMIC-FUNCTION('getContainerSource' IN ghCallerHandle).
  IF VALID-HANDLE(ghCallerHandle) THEN
    gcCallerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN ghCallerHandle) NO-ERROR.  

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

    /* FilterSet  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "SessionFS":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cFilterSet).
  END.
  
  /* Get Source Language */
  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                           INPUT "SLanguage":U,
                                           INPUT "SLanguage":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
  RUN populateCombo (INPUT cProfileData, INPUT cFilterSet).

  /* Display whether all pages should be initialized for translation */
  ASSIGN rRowid = ?.
  RUN checkProfileDataExists IN gshProfileManager (INPUT  "Window":U,
                                                   INPUT  "InitForTrn":U,
                                                   INPUT  "InitForTrn":U,
                                                   INPUT  YES,
                                                   INPUT  NO,
                                                   OUTPUT lExists).
  IF lExists THEN
    RUN getProfileData IN gshProfileManager ( INPUT        "Window":U,
                                              INPUT        "InitForTrn":U,
                                              INPUT        "InitForTrn":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).

  toInitPagesForTrans:CHECKED = (IF lExists THEN cProfileData = "YES":U ELSE TRUE).

  /* Check for custom palettes and custom templates */
  ASSIGN lExists = NO.
  RUN checkProfileDataExists IN gshProfileManager (INPUT "General":U,
                                                   INPUT "Preference":U,
                                                   INPUT "":U,
                                                   INPUT YES,
                                                   INPUT NO,
                                                   OUTPUT lExists).

  .
  IF lExists THEN 
  DO:
    ASSIGN rRowid       = ?
         cProfileData = "".
    RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                             INPUT "Preference":U,
                                             INPUT "CustomTemplate":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).
  
    ASSIGN flnTemplate:SCREEN-VALUE = cProfileData .
  END.
  ELSE ASSIGN flnTemplate:SCREEN-VALUE = "*".
  ASSIGN rRowid        = ?
         cProfileData = "".   
  IF lExists THEN DO:
   RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                            INPUT "Preference":U,
                                            INPUT "CustomPalette":U,
                                            INPUT NO,
                                            INPUT-OUTPUT rRowid,
                                            OUTPUT cProfileData).
      ASSIGN flnPalette:SCREEN-VALUE = cProfileData.
  END.
  ELSE ASSIGN flnPalette:SCREEN-VALUE = "*":U.

  /* Determine if user wants to builf customizations from the default layout
     or the previous layout */
  ASSIGN rRowid  = ?
         cProfileData = "".
  RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                           INPUT "Preference":U,
                                           INPUT "CustomizeFromDefault":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
  IF cProfileData = "Yes":U OR cProfileData = "" OR cProfileData = ? THEN
    toCustomizeDefault:CHECKED = YES.

    rRowid = ?.
    cProfileData = ?.
    /* check user prefs first. */
    run checkProfileDataExists in gshProfileManager ('General',
                                                     'Preference',
                                                     'MessageBoxType',
                                                     No,    /*plCheckPermanentOnly*/
                                                     No,    /*plCheckCacheOnly*/
                                                     output lExists ) no-error.
        
    if lExists then
        run getProfileData in gshProfileManager ('General':u, /* Profile type code     */
                                                 'Preference':u, /* Profile code          */
                                                 'MessageBoxType':u, /* Profile data key      */
                                                 "No":U,              /* Get next record flag  */
                                                 input-output rRowid,       /* Rowid of profile data */
                                                 output cProfileData ).
    else
        /* defaults from session param */
        cProfileData = dynamic-function('getSessionParam':u in target-procedure, 'MessageBoxType').

    if cProfileData eq ? or cProfileData eq '':u then
        cProfileData = 'Complex':u.
    
    coMessageBoxType:screen-value = cProfileData no-error.                                                 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombo sObject 
PROCEDURE populateCombo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will read through all the available languages
               and default to the system language if the user's source language
               have not been selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcSourceLanguageObj  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcFilterSetCode      AS CHARACTER  NO-UNDO. 

  DEFINE VARIABLE dDefaultLanguageObj AS DECIMAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        coSourceLanguage:DELIMITER = CHR(3)
        coFilterSet:DELIMITER      = CHR(3).

    EMPTY TEMP-TABLE ttComboData.
  
    CREATE ttComboData.
    ASSIGN
        ttComboData.cWidgetName         = "coSourceLanguage":U
        ttComboData.hWidget             = coSourceLanguage:HANDLE
        ttComboData.cForEach            = "FOR EACH gsc_language NO-LOCK BY gsc_language.language_name":U
        ttComboData.cBufferList         = "gsc_language":U
        ttComboData.cKeyFieldName       = "gsc_language.language_obj":U
        ttComboData.cDescFieldNames     = "gsc_language.language_name":U
        ttComboData.cDescSubstitute     = "&1":U
        ttComboData.cFlag               = "N":U
        ttComboData.cCurrentKeyValue    = "":U
        ttComboData.cListItemDelimiter  = coSourceLanguage:DELIMITER
        ttComboData.cListItemPairs      = "":U
        ttComboData.cCurrentDescValue   = "":U
        .
  
    CREATE ttComboData.
    ASSIGN
        ttComboData.cWidgetName         = "coFilterSet":U
        ttComboData.hWidget             = coFilterSet:HANDLE
        ttComboData.cForEach            = "FOR EACH gsm_filter_set NO-LOCK BY gsm_filter_set.filter_set_code":U
        ttComboData.cBufferList         = "gsm_filter_set":U
        ttComboData.cKeyFieldName       = "gsm_filter_set.filter_set_code":U
        ttComboData.cDescFieldNames     = "gsm_filter_set.filter_set_code,gsm_filter_set.filter_set_description":U
        ttComboData.cDescSubstitute     = "&1 / &2":U
        ttComboData.cFlag               = "N":U
        ttComboData.cCurrentKeyValue    = "":U
        ttComboData.cListItemDelimiter  = coFilterSet:DELIMITER
        ttComboData.cListItemPairs      = "":U
        ttComboData.cCurrentDescValue   = "":U
        .

    /* build combo list-item pairs */
    RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

    FIND FIRST ttComboData
         WHERE ttComboData.cWidgetName = "coSourceLanguage":U.

    coSourceLanguage:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

    /* If profile language was not set, default to user loging language, and
       if it was not set, default to system language */
    IF pcSourceLanguageObj = "":U OR
       pcSourceLanguageObj = ?    THEN
    DO:
      /* First find the login language */
      dDefaultLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageObj":U, NO)) NO-ERROR.
      IF dDefaultLanguageObj = 0 OR
         dDefaultLanguageObj = ? THEN
        IF AVAILABLE ttGlobalControl THEN 
          dDefaultLanguageObj = ttGlobalControl.default_language_obj NO-ERROR.

      IF dDefaultLanguageObj = ? THEN
        dDefaultLanguageObj = 0.

      coSourceLanguage:SCREEN-VALUE = STRING(dDefaultLanguageObj) NO-ERROR.

      {set DataModified TRUE}.
    END.
    ELSE
      coSourceLanguage:SCREEN-VALUE = pcSourceLanguageObj NO-ERROR.
    
    /* Make sure we could set the value */
    IF ERROR-STATUS:ERROR OR coSourceLanguage:SCREEN-VALUE = ? THEN
    DO:
      coSourceLanguage:SCREEN-VALUE = coSourceLanguage:ENTRY(1) NO-ERROR.

      {set DataModified TRUE}.
    END.

    /* Populate the filter set combo */
    FIND FIRST ttComboData
         WHERE ttComboData.cWidgetName = "coFilterSet":U.

    ASSIGN
        pcFilterSetCode             = (IF pcFilterSetCode = "":U THEN "0":U ELSE pcFilterSetCode)
        coFilterSet:LIST-ITEM-PAIRS = ttComboData.cListItemPairs
        coFilterSet:SCREEN-VALUE    = pcFilterSetCode NO-ERROR.

    /* Make sure we could set the value */
    IF ERROR-STATUS:ERROR OR coFilterSet:SCREEN-VALUE = ? THEN
    DO:
      coFilterSet:SCREEN-VALUE = coFilterSet:ENTRY(1) NO-ERROR.

      {set DataModified TRUE}.
    END.
  END.

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
           
            IF VALID-HANDLE(ghCallerHandle) THEN
/*               RUN "setTopOnly":U IN ghCallerHandle (INPUT toTopOnly:SCREEN-VALUE = "YES":U). */
              DYNAMIC-FUNCTION("setTopOnly":U IN ghCallerHandle,INPUT toTopOnly:SCREEN-VALUE = "yes":U) NO-ERROR.
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

          /* Save the DisplayRepository flag - the session filter set */
          ASSIGN coFilterSet.
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "DispRepos":U,
                                                   INPUT "SessionFS":U,
                                                   INPUT ?,
                                                   INPUT (IF TRIM(coFilterSet:SCREEN-VALUE) = "0":U THEN "":U ELSE coFilterSet:SCREEN-VALUE),
                                                   INPUT NO,
                                                   INPUT "PER":U).
          
          /* DispRepos is kept (for now) for backwards compatability */
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "DispRepos":U,
                                                   INPUT "DispRepos":U,
                                                   INPUT ?,
                                                   INPUT (IF TRIM(coFilterSet:SCREEN-VALUE) = "0":U THEN "yes":U ELSE "no":U),
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* Save the User's Source Langauge */
          ASSIGN coSourceLanguage.
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "SLanguage":U,
                                                   INPUT "SLanguage":U,
                                                   INPUT ?,
                                                   INPUT coSourceLanguage,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* Save the preference that checks whether all pages should be initialized for translation */
          ASSIGN toInitPagesForTrans.
          RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                                   INPUT "InitForTrn":U,
                                                   INPUT "InitForTrn":U,
                                                   INPUT ?,
                                                   INPUT toInitPagesForTrans:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* Save the custom template and palette information */
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "Preference":U,
                                                   INPUT "CustomTemplate":U,
                                                   INPUT ?,
                                                   INPUT flnTemplate:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "Preference":U,
                                                   INPUT "CustomPalette":U,
                                                   INPUT ?,
                                                   INPUT flnPalette:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).

          /* Save preference on how to build custom layouts */
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "Preference":U,
                                                   INPUT "CustomizeFromDefault":U,
                                                   INPUT ?,
                                                   INPUT toCustomizeDefault:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).
                                                   
          /* Save MB type */
          RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                                   INPUT "Preference":U,
                                                   INPUT "MessageBoxType":U,
                                                   INPUT ?,
                                                   INPUT coMessageBoxType:SCREEN-VALUE,
                                                   INPUT NO,
                                                   INPUT "PER":U).
          /* Trigger a re-fetch of the MessageBoxType on next request */
          {set MessageBoxType ?}.

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

