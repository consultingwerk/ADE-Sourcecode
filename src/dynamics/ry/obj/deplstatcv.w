&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
/*---------------------------------------------------------------------------------
  File: deplstatcv.w

  Description:  Static Object Deployment Viewer

  Purpose:      Static Object Deployment Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/18/2002  Author:     

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

&scop object-name       deplstatcv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE STREAM one.
DEFINE STREAM two.
define stream sLogging.

&scoped-define LOG-TYPES LOG,LISTING
define variable gcLogFiles         as character    extent 10 no-undo.
DEFINE VARIABLE cStoreSelListValue AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttDir NO-UNDO
    FIELD tt_dirname AS CHARACTER
    INDEX idx-whatever tt_dirname.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiSource RECT-1 fiTarget fiLogFile ~
fiListingFile seDestination seList toDesign toBlankType ~
fiAdditionalDirectory seAdditionalDirectories toOpenLogFile buDeploy ~
buDestinations edStatus fiLabel fiDestLabel fiAddDirHeader fiDirLabel ~
fiNote fiProgLabel 
&Scoped-Define DISPLAYED-OBJECTS fiSource fiTarget fiLogFile fiListingFile ~
seDestination seList toDesign toBlankType fiAdditionalDirectory ~
seAdditionalDirectories toOpenLogFile edStatus fiLabel fiDestLabel ~
fiAddDirHeader fiDirLabel fiNote fiProgLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeLogFile sObject 
FUNCTION initializeLogFile RETURNS LOGICAL
  ( INPUT pcLog     AS CHARACTER,
    INPUT pcLogfile AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateEditor sObject 
FUNCTION updateEditor RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateLogFile sObject 
FUNCTION updateLogFile RETURNS LOGICAL
  ( INPUT pcLog AS CHARACTER,
    INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAddToList 
     LABEL "&Add to List" 
     SIZE 20 BY 1.14 TOOLTIP "Create the deployment package"
     BGCOLOR 8 .

DEFINE BUTTON buDeploy 
     LABEL "&Deploy" 
     SIZE 20 BY 1.14 TOOLTIP "Create the deployment package"
     BGCOLOR 8 .

DEFINE BUTTON buDestinations 
     LABEL "D&estinations" 
     SIZE 20 BY 1.14 TOOLTIP "Launches the static object destination maintenance suite"
     BGCOLOR 8 .

DEFINE BUTTON buRemoveFromList 
     LABEL "&Remove from List" 
     SIZE 20 BY 1.14 TOOLTIP "Create the deployment package"
     BGCOLOR 8 .

DEFINE VARIABLE edStatus AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 77.2 BY 5.52 NO-UNDO.

DEFINE VARIABLE fiAddDirHeader AS CHARACTER FORMAT "X(256)":U INITIAL " Additionally, include ALL files in these directories with the deployment:" 
      VIEW-AS TEXT 
     SIZE 75.4 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiAdditionalDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Directory (Relative Path)" 
     VIEW-AS FILL-IN 
     SIZE 29.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiDestLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Deployment type:" 
      VIEW-AS TEXT 
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE fiDirLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Additional Directories:" 
      VIEW-AS TEXT 
     SIZE 20.4 BY .81 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U INITIAL " Deployment will Include:" 
      VIEW-AS TEXT 
     SIZE 32.2 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiListingFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Listing file" 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1 NO-UNDO.

DEFINE VARIABLE fiLogFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Log file" 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1 TOOLTIP "Enter the preferred deployment log file name" NO-UNDO.

DEFINE VARIABLE fiNote AS CHARACTER FORMAT "X(256)":U INITIAL "*** NOTE: Please add sub-directories of the above manually" 
      VIEW-AS TEXT 
     SIZE 68.2 BY .81 NO-UNDO.

DEFINE VARIABLE fiProgLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Deployment progress:" 
      VIEW-AS TEXT 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE fiSource AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dynamics root directory" 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1 TOOLTIP "Enter your Dynamics root directory" NO-UNDO.

DEFINE VARIABLE fiTarget AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deployment directory" 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1 TOOLTIP "The directory to build the deployment package into" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.2 BY 6.24.

DEFINE VARIABLE seAdditionalDirectories AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SIZE 29.4 BY 3
     FONT 3 NO-UNDO.

DEFINE VARIABLE seDestination AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     LIST-ITEM-PAIRS "4GL client-server","WEB:SRV:CLN",
                     "Appserver","SRV",
                     "Webclient","CLN",
                     "Webspeed Server","WEB:SRV" 
     SIZE 27.2 BY 3 TOOLTIP "Select the deployment destination"
     FONT 3 NO-UNDO.

DEFINE VARIABLE seList AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     LIST-ITEM-PAIRS "Remote Server Objects","SRV" 
     SIZE 32.4 BY 2.19
     FONT 3 NO-UNDO.

DEFINE VARIABLE toBlankType AS LOGICAL INITIAL no 
     LABEL "Include objects with blank deployment types" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE toDesign AS LOGICAL INITIAL no 
     LABEL "Include design objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.8 BY .81 TOOLTIP "Include design objects in the deployment" NO-UNDO.

DEFINE VARIABLE toOpenLogFile AS LOGICAL INITIAL no 
     LABEL "Open log file automatically" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.8 BY .81 TOOLTIP "Open the deployment log file automatically" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiSource AT ROW 1 COL 5.2
     fiTarget AT ROW 2 COL 26.4 COLON-ALIGNED
     fiLogFile AT ROW 3 COL 26.4 COLON-ALIGNED
     fiListingFile AT ROW 4 COL 26.4 COLON-ALIGNED WIDGET-ID 2
     seDestination AT ROW 5.1 COL 28.4 NO-LABEL
     seList AT ROW 6 COL 73.2 NO-LABEL NO-TAB-STOP 
     toDesign AT ROW 8.19 COL 28.8
     toBlankType AT ROW 9.05 COL 28.8
     buAddToList AT ROW 11.05 COL 84.2
     fiAdditionalDirectory AT ROW 11.1 COL 51.8 COLON-ALIGNED
     seAdditionalDirectories AT ROW 12.14 COL 53.8 NO-LABEL
     buRemoveFromList AT ROW 12.33 COL 84.2
     toOpenLogFile AT ROW 16.38 COL 28.6
     buDeploy AT ROW 17.29 COL 28
     buDestinations AT ROW 17.29 COL 49
     edStatus AT ROW 18.57 COL 28 NO-LABEL NO-TAB-STOP 
     fiLabel AT ROW 5.14 COL 71.2 COLON-ALIGNED NO-LABEL
     fiDestLabel AT ROW 5.19 COL 11.4 NO-LABEL
     fiAddDirHeader AT ROW 10.14 COL 27 COLON-ALIGNED NO-LABEL
     fiDirLabel AT ROW 12.19 COL 32.8 NO-LABEL
     fiNote AT ROW 15.19 COL 29 COLON-ALIGNED NO-LABEL
     fiProgLabel AT ROW 18.52 COL 7 NO-LABEL
     RECT-1 AT ROW 9.95 COL 28.2
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
         HEIGHT             = 23.1
         WIDTH              = 104.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

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

/* SETTINGS FOR BUTTON buAddToList IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buRemoveFromList IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       edStatus:RETURN-INSERTED IN FRAME frMain  = TRUE
       edStatus:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiDestLabel IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiDirLabel IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiProgLabel IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiSource IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME buAddToList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddToList sObject
ON CHOOSE OF buAddToList IN FRAME frMain /* Add to List */
DO:
  seAdditionalDirectories:ADD-LAST(TRIM(REPLACE(fiAdditionalDirectory:SCREEN-VALUE, "~\":U, "/":U), "/":U)).

  ASSIGN
      fiAdditionalDirectory:SCREEN-VALUE = "":U.
      SELF:SENSITIVE                     = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeploy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeploy sObject
ON CHOOSE OF buDeploy IN FRAME frMain /* Deploy */
DO:
  DEFINE VARIABLE cMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileLine      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogDir        AS CHARACTER  NO-UNDO.
    define variable hContainer             as handle                no-undo.
    
  /* Validation */
  {get ContainerSource hContainer}.

  IF fiSource:SCREEN-VALUE = "":U 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The Dynamics root directory specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiSource.
      RETURN NO-APPLY.
  END.

  FILE-INFO:FILE-NAME = fiSource:SCREEN-VALUE.

  IF FILE-INFO:FILE-TYPE = ?
  OR INDEX(FILE-INFO:FILE-TYPE, "d":U) = 0 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The Dynamics root directory specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiSource.
      RETURN NO-APPLY.
  END.

  IF fiTarget:SCREEN-VALUE = "":U 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The deployment directory specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiTarget.
      RETURN NO-APPLY.
  END.

  IF fiLogFile:SCREEN-VALUE = "":U 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The log file specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiLogFile.
      RETURN NO-APPLY.
  END.

  ASSIGN cLogDir = fiLogFile:SCREEN-VALUE.
  IF ENTRY(NUM-ENTRIES(cLogDir, "/":U), cLogDir, "/":U) = "":U /* No filename specified */
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The log file specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiLogFile.
      RETURN NO-APPLY.
  END.
  ELSE
      ASSIGN cLogDir = REPLACE(cLogDir, ENTRY(NUM-ENTRIES(cLogDir, "/":U), cLogDir, "/":U), "":U)
             cLogDir = RIGHT-TRIM(cLogDir, "/":U).

  FILE-INFO:FILE-NAME = cLogDir.

  IF FILE-INFO:FILE-TYPE = ? OR INDEX(FILE-INFO:FILE-TYPE, "d":U) = 0 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The log file directory specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiLogFile.
      RETURN NO-APPLY.
  END.
    
    /* If specified, the listing file directory must exist. */        
    cLogDir = fiListingFile:screen-value.
    if cLogDir ne '' and cLogDir ne ? then
    do:
        /* Determine directory from input */
        cLogDir = replace(cLogDir, '~\':u, '/':u).        
        cLogDir = replace(cLogDir, entry(num-entries(cLogDir, '/':u), cLogDir, '/':u), '':u).
        cLogDir = right-trim(cLogDir, '/':u).
            
        file-info:file-name = cLogDir.
        /* return an error if the directory for the listing file
           doesn't exist.
         */
        if file-info:file-type eq ? or index(file-info:file-type, 'd':u) eq 0 then
        do:
            run showMessages in gshSessionManager (input  {aferrortxt.i 'AF' '5' '?' '?' '"directory for the listing file"' "'Listing directory: ' + cLogDir"},
                                                   input  'Err':u,    /* Message type */
                                                   input  '&Ok':u,    /* Button list */
                                                   input  '&Ok':u,    /* Default Button */
                                                   input  '':u,    /* Cancel Button */
                                                   input  'Invalid listing directory':u,    /* Message title */
                                                   input  yes,    /* show if blank */
                                                   input  hContainer,
                                                   output cButtonPressed).
            
            run applyEntry in target-procedure ('fiListingFile':u).
            return no-apply.
        end.    /* listing directory invalid */
    end.    /* listing file specified */
        
  ASSIGN cLogDir = fiLogFile:SCREEN-VALUE.
  IF ENTRY(NUM-ENTRIES(cLogDir, "/":U), cLogDir, "/":U) = "":U /* No filename specified */
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The log file specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiLogFile.
      RETURN NO-APPLY.
  END.
  ELSE
      ASSIGN cLogDir = REPLACE(cLogDir, ENTRY(NUM-ENTRIES(cLogDir, "/":U), cLogDir, "/":U), "":U)
             cLogDir = RIGHT-TRIM(cLogDir, "/":U).

  FILE-INFO:FILE-NAME = cLogDir.

  IF FILE-INFO:FILE-TYPE = ? OR INDEX(FILE-INFO:FILE-TYPE, "d":U) = 0 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "The log file directory specified is invalid.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO fiLogFile.
      RETURN NO-APPLY.
  END.

  IF seDestination:SCREEN-VALUE = ?
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "No deployment type specified.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      APPLY "ENTRY":U TO seDestination.
      RETURN NO-APPLY.
  END.

  /* Ask nicely */

  ASSIGN cMessage = "You are about to deploy static objects, please confirm:" + CHR(10)
                  + "- All static objects have been loaded into the Repository.  If not, they will not be deployed." + CHR(10)
                  + "- Static object deployment destinations have been correctly set for all objects. " + CHR(10) 
                  + "- All static objects have been compiled." + CHR(10)
                  + "- The target directory will be cleared before the deployment is done." + CHR(10) + CHR(10)
                  + "Are you sure you wish to proceed?".

  RUN askQuestion IN gshSessionManager (INPUT cMessage,
                                        INPUT "&Yes,&No",
                                        INPUT "&No",
                                        INPUT "&No",
                                        INPUT "Create Deployment Package",
                                        INPUT "",
                                        INPUT "",
                                        INPUT-OUTPUT cAnswer,
                                        OUTPUT cButtonPressed).
  IF cButtonPressed = "&NO" THEN
      RETURN.

  /* And now - deploy */

  RUN createDeploymentPackage no-error.
    if return-value ne '' or error-status:error then
    do:
        run showMessages in gshSessionManager (input  return-value,
                                               input  'Err':u,    /* Message type */
                                               input  '&Ok':u,    /* Button list */
                                               input  '&Ok':u,    /* Default Button */
                                               input  '':u,    /* Cancel Button */
                                               input  'Deployment package creation error':u,    /* Message title */
                                               input  yes,    /* show if blank */
                                               input  hContainer,
                                               output cButtonPressed).      
        return no-apply.
    end.    /* error */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDestinations
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDestinations sObject
ON CHOOSE OF buDestinations IN FRAME frMain /* Destinations */
DO:
    DEFINE VARIABLE hHandle   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cProcType AS CHARACTER  NO-UNDO.

    RUN launchContainer IN gshSessionManager 
                    (INPUT  "rycsodeplw":U       /* object filename if physical/logical names unknown */
                    ,INPUT  "":U                 /* physical object name (with path and extension) if known */
                    ,INPUT  "rycsodeplw":U       /* logical object name if applicable and known */
                    ,INPUT  YES                  /* run once only flag YES/NO */
                    ,INPUT  "":U                 /* instance attributes to pass to container */
                    ,INPUT  "":U                 /* child data key if applicable */
                    ,INPUT  "":U                 /* run attribute if required to post into container run */
                    ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
                    ,INPUT  ?                    /* parent (caller) window handle if known (container window handle) */
                    ,INPUT  ?                    /* parent (caller) procedure handle if known (container procedure handle) */
                    ,INPUT  ?                    /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                    ,OUTPUT hHandle              /* procedure handle of object run/running */
                    ,OUTPUT cProcType            /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
                    ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveFromList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveFromList sObject
ON CHOOSE OF buRemoveFromList IN FRAME frMain /* Remove from List */
DO:
  seAdditionalDirectories:DELETE(seAdditionalDirectories:SCREEN-VALUE).
  
  SELF:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAdditionalDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAdditionalDirectory sObject
ON VALUE-CHANGED OF fiAdditionalDirectory IN FRAME frMain /* Directory (Relative Path) */
DO:
  FILE-INFO:FILE-NAME = fiAdditionalDirectory:SCREEN-VALUE.

  IF INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0 AND
     INDEX(FILE-INFO:FILE-TYPE, "D":U) <> ? THEN
  DO:
    IF seAdditionalDirectories:LOOKUP(TRIM(REPLACE(fiAdditionalDirectory:SCREEN-VALUE, "~\":U, "/":U), "/":U)) = 0 THEN
      buAddToList:SENSITIVE = TRUE.
  END.
  ELSE
    buAddToList:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiListingFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiListingFile sObject
ON LEAVE OF fiListingFile IN FRAME frMain /* Listing file */
DO:
    ASSIGN SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE, "~\":U, "/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLogFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLogFile sObject
ON LEAVE OF fiLogFile IN FRAME frMain /* Log file */
DO:
    ASSIGN SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE, "~\":U, "/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSource sObject
ON LEAVE OF fiSource IN FRAME frMain /* Dynamics root directory */
DO:
  ASSIGN SELF:SCREEN-VALUE = RIGHT-TRIM(SELF:SCREEN-VALUE, "~\":U)
         SELF:SCREEN-VALUE = RIGHT-TRIM(SELF:SCREEN-VALUE, "/":U)
         SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE, "~\":U, "/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTarget sObject
ON LEAVE OF fiTarget IN FRAME frMain /* Deployment directory */
DO:
    ASSIGN SELF:SCREEN-VALUE = RIGHT-TRIM(SELF:SCREEN-VALUE, "~\":U)
           SELF:SCREEN-VALUE = RIGHT-TRIM(SELF:SCREEN-VALUE, "/":U)
           SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE, "~\":U, "/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seAdditionalDirectories
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAdditionalDirectories sObject
ON VALUE-CHANGED OF seAdditionalDirectories IN FRAME frMain
DO:
  buRemoveFromList:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seDestination
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seDestination sObject
ON VALUE-CHANGED OF seDestination IN FRAME frMain
DO:
  ASSIGN seList:SCREEN-VALUE = "":U
         seList:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE, ":":U, ",":U)
         cStoreSelListValue  = seList:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seList sObject
ON ENTRY OF seList IN FRAME frMain
DO:  
  DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
  ASSIGN hHandle           = LAST-EVENT:WIDGET-LEAVE
         SELF:SCREEN-VALUE = "":U
         SELF:SCREEN-VALUE = cStoreSelListValue.

  IF VALID-HANDLE(hHandle) THEN
    APPLY "ENTRY":U TO hHandle.

  MESSAGE "This field only indicates which objects will be deployed" SKIP
          "with the deployment type you selected." SKIP(1)
          "It is not meant to be updated."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN NO-APPLY.
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

PROCEDURE FindExecutableA EXTERNAL "shell32" :
  define input parameter lpFile as char.
  define input parameter lpDirectory as char.
  define input-output parameter lpResult as char.
  define return parameter hInstance as long.
END PROCEDURE.

PROCEDURE ShellExecuteA EXTERNAL "shell32" :
  define input parameter hwnd as long.
  define input parameter lpOperation as char.
  define input parameter lpFile as char.
  define input parameter lpParameters as char.
  define input parameter lpDirectory as char.
  define input parameter nShowCmd as long.
  define return parameter hInstance as long.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDeploymentPackage sObject 
PROCEDURE createDeploymentPackage :
/*------------------------------------------------------------------------------
  Purpose:     Create the static object deployment package.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cInvalidDir     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lWeb            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lClient         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lServer         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lSDO            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSourceFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullDirPath    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTargetFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCreateDir      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDirImport      AS CHARACTER  NO-UNDO EXTENT 3.
DEFINE VARIABLE iDirectory      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iDirCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE rRowid          AS ROWID      NO-UNDO.
DEFINE VARIABLE cDataFieldChildren AS CHARACTER  NO-UNDO.
define variable lWriteListing   as logical    no-undo.
define variable lOk             as logical    no-undo.

DEFINE BUFFER ryc_smartobject FOR ryc_smartobject.

IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazy frame scoping */

ASSIGN lWeb    = (LOOKUP("WEB":U, seDestination:SCREEN-VALUE, ":") > 0) /* The SCREEN-VALUE is : seperated */
       lClient = (LOOKUP("CLN":U, seDestination:SCREEN-VALUE, ":") > 0)
       lServer = (LOOKUP("SRV":U, seDestination:SCREEN-VALUE, ":") > 0)
       lWriteListing = fiListingFile:screen-value ne ? and fiListingFile:screen-value ne '':u.

RUN setProfileData IN gshProfileManager (INPUT "General":U,
                                         INPUT "Preference":U,
                                         INPUT "AdditionalDeployDir":U,
                                         INPUT rRowid,
                                         INPUT (IF seAdditionalDirectories:LIST-ITEMS = "":U OR
                                                   seAdditionalDirectories:LIST-ITEMS = ?    THEN "?":U ELSE seAdditionalDirectories:LIST-ITEMS),
                                         INPUT NO,
                                         INPUT "PER":U).

/* First, check the target directory.  If it already exists, delete it.  We'll recreate it. *
 * This makes sure we don't end up sending stuff we didn't want to.                         */

ASSIGN FILE-INFO:FILE-NAME = fiTarget:SCREEN-VALUE.

IF FILE-INFO:FILE-TYPE = ? THEN. /* Fine, we'll create this directory later */
ELSE DO:
    updateEditor("Clearing target directory - " + fiTarget:SCREEN-VALUE).
    PROCESS EVENTS.
    OS-DELETE VALUE(FILE-INFO:FILE-NAME) RECURSIVE.
END.

/* Create the log file directory if it doesn't exist yet */

ASSIGN cCreateDir = fiLogFile:SCREEN-VALUE
       cCreateDir = REPLACE(cCreateDir, ENTRY(NUM-ENTRIES(cCreateDir, "/":U), cCreateDir, "/":U), "":U)
       cCreateDir = RIGHT-TRIM(cCreateDir, "/":U).

FILE-INFO:FILE-NAME = cCreateDir.
IF FILE-INFO:FILE-TYPE = ? 
THEN DO:
    updateEditor("Creating log file directory - " + FILE-INFO:FILE-NAME).

    OS-CREATE-DIR VALUE(FILE-INFO:FILE-NAME).
    IF OS-ERROR <> 0 THEN
        updateEditor("Unable to create log file directory.").
END.

/* Clear the log file */
lOk = dynamic-function('initializeLogFile' in target-procedure,
                       'Log', fiLogFile:SCREEN-VALUE) no-error.
if not lOk or error-status:error then
    return error 'Unable to initialize log file ' + fiLogFile:SCREEN-VALUE.
    
if lWriteListing then
do:
    lOk = dynamic-function('initializeLogFile' in target-procedure,
                           'Listing', fiListingFile:SCREEN-VALUE) no-error.
    if not lOk or error-status:error then
        return error 'Unable to initialize listing file ' + fiListingFile:SCREEN-VALUE.
end.    /* write listing */

updateLogFile('Log':u, "Deployment Process started : " + STRING(TIME, "HH:MM:SS":U)).
updateLogFile('Log':u, "").

/* Write listing file header. */
if lWriteListing then
    updateLogFile('Listing':u, 'File Name' + '~t':u
                             + 'Relative Path' + '~t':u
                             + 'Deployment Type' + '~t':u
                             + 'Design Object' + '~t':u ).

/* Reset the editor */

ASSIGN edStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

updateEditor("Deployment Process started : " + STRING(TIME, "HH:MM:SS":U)).


/* Now cycle through each object and determine if it needs to be deployed */

cDataFieldChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dataField":U).

object-blk:
FOR EACH gsc_object_type NO-LOCK
   WHERE gsc_object_type.static_object = TRUE
     AND LOOKUP(gsc_object_type.object_type_code,cDataFieldChildren) = 0,
    EACH ryc_smartobject NO-LOCK OF gsc_object_type
   WHERE ryc_smartobject.static_object = TRUE
     AND NOT ryc_smartobject.OBJECT_path MATCHES "*template*"
     AND NOT ryc_smartobject.OBJECT_path = "ry/tem"
   BREAK BY ryc_smartobject.object_path
         BY ryc_smartobject.object_filename:

    ASSIGN cObjectPath = RIGHT-TRIM(ryc_smartobject.object_path, "/":U)
           cObjectPath = RIGHT-TRIM(cObjectPath, "~\":U)
           cObjectPath = REPLACE(cObjectPath, "/":U, "~\":U).

    /* We're starting on a new directory, so make sure it exists */

    IF FIRST-OF(ryc_smartobject.object_path) 
    THEN DO:
        ASSIGN cFullDirPath    = REPLACE(fiTarget:SCREEN-VALUE, "/":U, "~\":U) + "~\":U + cObjectPath
               cCreateDir      = "":U
               cInvalidDir     = CHR(27).

        updateEditor("Deploying directory - " + cFullDirPath + " : " + STRING(TIME, "HH:MM:SS":U)).
        updateLogFile('Log':u, "Deploying directory - " + cFullDirPath).

        /* See if we need to create any directories, take the directory path subdir by subdir */

        DO iDirCount = 1 TO NUM-ENTRIES(cFullDirPath, "~\":U):
            IF cCreateDir = "":U THEN
                ASSIGN cCreateDir = ENTRY(iDirCount, cFullDirPath, "~\":U).
            ELSE
                ASSIGN cCreateDir = cCreateDir + "~\":U + ENTRY(iDirCount, cFullDirPath, "~\":U).

            FILE-INFO:FILE-NAME = cCreateDir.
            IF FILE-INFO:FILE-TYPE = ? 
            THEN DO:
                updateEditor("Creating directory - " + FILE-INFO:FILE-NAME).

                OS-CREATE-DIR VALUE(FILE-INFO:FILE-NAME).
                IF OS-ERROR <> 0 
                THEN DO:
                    updateEditor("Unable to create directory.").
                    updateLogFile('Log':u, "Unable to create directory - " + FILE-INFO:FILE-NAME).
                    ASSIGN cInvalidDir = cObjectPath.
                END.
            END.
        END.
    END.

    /* Copy the object from source to target */

    IF (lWeb    = YES AND LOOKUP("WEB":U, ryc_smartobject.deployment_type) > 0) 
    OR (lClient = YES AND LOOKUP("CLN":U, ryc_smartobject.deployment_type) > 0) 
    OR (lServer = YES AND LOOKUP("SRV":U, ryc_smartobject.deployment_type) > 0) 
    OR (toBlankType:CHECKED AND ryc_smartobject.deployment_type = "")
    THEN then-blk: DO:

        /* If we don't want design objects, and this is one, skip it */
        IF toDesign:CHECKED = NO
        AND ryc_smartobject.design_only = YES THEN
            LEAVE then-blk.

        /* Right, we need to deploy this object */

        IF cObjectPath <> cInvalidDir /* cInvalidDir will be set if we were unable to create the target directory */
        THEN DO:
            /*----------------------------*
             * Build the .r code filename *
             *----------------------------*/

            /* First, look in the source dir specified by the user, relatively pathed: c:/source/ry/prc/ryrepclntp.r */

            ASSIGN cSourceFile = fiSource:SCREEN-VALUE
                               + (IF cObjectPath = "":U THEN "/":U ELSE "/":U + cObjectPath + "/")
                               + ryc_smartobject.OBJECT_filename 
                               + (IF ryc_smartobject.object_extension = "" THEN "" ELSE "." + ryc_smartobject.object_extension).
            OVERLAY(cSourceFile, LENGTH(cSourceFile) - 1) = ".r":U.

            /* Secondly, look in the source dir specified by the user, root only, ignore the relative path: c:/source/ryrepclntp.r */

            IF SEARCH(cSourceFile) = ? 
            THEN DO:
                ASSIGN cSourceFile = fiSource:SCREEN-VALUE + "/":U
                                   + ryc_smartobject.OBJECT_filename
                                   + (IF ryc_smartobject.object_extension = "" THEN "" ELSE "." + ryc_smartobject.object_extension).
                OVERLAY(cSourceFile, LENGTH(cSourceFile) - 1) = ".r":U.

                /* If we can't find it here either, look for it in the PROPATH: SEARCH("ry/prc/ryrepclntp.r") */

                IF SEARCH(cSourceFile) = ? 
                THEN DO:
                    ASSIGN cSourceFile = (IF cObjectPath = "":U THEN "":U ELSE cObjectPath + "/")
                                       + ryc_smartobject.OBJECT_filename 
                                       + (IF ryc_smartobject.object_extension = "" THEN "" ELSE "." + ryc_smartobject.object_extension).
                    OVERLAY(cSourceFile, LENGTH(cSourceFile) - 1) = ".r":U.
                END.

                IF SEARCH(cSourceFile) = ?
                THEN DO:
                    updateLogFile('Log':u, ".r code not found for object - " + cSourceFile).
                    LEAVE then-blk.
                END.
            END.

            ASSIGN cSourceFile = SEARCH(cSourceFile)
                   cTargetFile = (IF cObjectPath = "":U THEN "":U ELSE cObjectPath + "/")
                               + ryc_smartobject.OBJECT_filename 
                               + (IF ryc_smartobject.object_extension = "" THEN "" ELSE "." + ryc_smartobject.object_extension).
            OVERLAY(cTargetFile, LENGTH(cTargetFile) - 1) = ".r":U.

            /* Check if we're dealing with an SDO or logic procedure, they work a bit differently */

            ASSIGN lSDO = SEARCH(REPLACE(cSourceFile, ".r":U, "_cl.r":U)) <> ?.

            updateEditor("Deploying " + cSourceFile).

            IF lSDO 
            THEN DO:
                /* Deploy only the applicable half, or both if required */

                IF lClient = YES /* we'll only deploy the _cl part of the procedure */
                THEN DO:
                    OS-COPY VALUE(REPLACE(cSourceFile, ".r":U, "_cl.r":U)) VALUE(fiTarget:SCREEN-VALUE + "/" + REPLACE(cTargetFile, ".r":U, "_cl.r":U)).
                    IF OS-ERROR <> 0 
                    THEN DO:
                        updateLogFile('Log':u, "Unable to copy " + REPLACE(cSourceFile, ".r":U, "_cl.r":U) + " to " + fiTarget:SCREEN-VALUE + "/" + REPLACE(cTargetFile, ".r":U, "_cl.r":U)).
                        LEAVE then-blk.
                    END.
                END.

                IF lServer = YES 
                THEN DO:
                    OS-COPY VALUE(cSourceFile) VALUE(fiTarget:SCREEN-VALUE + "/" + cTargetFile).
                    IF OS-ERROR <> 0 
                    THEN DO:
                        updateLogFile('Log':u, "Unable to copy " + cSourceFile + " to " + fiTarget:SCREEN-VALUE + "/" + cTargetFile).
                        LEAVE then-blk.
                    END.
                END.
            END.
            ELSE DO: /* The object is not an SDO */
                OS-COPY VALUE(cSourceFile) VALUE(fiTarget:SCREEN-VALUE + "/" + cTargetFile).
                IF OS-ERROR <> 0
                THEN DO:
                    updateLogFile('Log':u, "Unable to copy " + cSourceFile + " to " + fiTarget:SCREEN-VALUE + "/" + cTargetFile).
                    LEAVE then-blk.
                END.
            END.    /* not an SDO */
            
            if lWriteListing then
                updateLogFile('Listing':u, ryc_smartobject.object_filename
                                            + (if ryc_smartobject.object_extension eq '':u then '':u 
                                                else '.':u + ryc_smartobject.object_extension) + '~t':u
                                            + ryc_smartobject.object_path + '~t':u
                                            + ryc_smartobject.deployment_type + '~t':u
                                            + string(ryc_smartobject.design_only) +  '~t':u).
        END.    /* deploy the obejct */
    END.    /* candidate for deployment */
END.    /* object-blk: each object */

/* Now copy the additional directories the user specified - if any */
IF NUM-ENTRIES(seAdditionalDirectories:LIST-ITEMS, seAdditionalDirectories:DELIMITER) > 0 THEN
DO:
    DO iDirectory = 1 TO NUM-ENTRIES(seAdditionalDirectories:LIST-ITEMS, seAdditionalDirectories:DELIMITER):

        ASSIGN cFullDirPath    = REPLACE(fiTarget:SCREEN-VALUE, "/":U, "~\":U) + "~\":U
                               + REPLACE(seAdditionalDirectories:ENTRY(iDirectory), "/":U, "~\":U) + "~\":U
               cCreateDir      = "":U
               cInvalidDir     = CHR(27).

        updateEditor("Copying directory - " + cFullDirPath + " : " + STRING(TIME, "HH:MM:SS":U)).
        updateLogFile('Log':u, "Copying directory - " + cFullDirPath).

        /* See if we need to create any directories, take the directory path subdir by subdir */
        DO iDirCount = 1 TO NUM-ENTRIES(cFullDirPath, "~\":U):
            IF cCreateDir = "":U THEN
                ASSIGN cCreateDir = ENTRY(iDirCount, cFullDirPath, "~\":U).
            ELSE
                ASSIGN cCreateDir = cCreateDir + "~\":U + ENTRY(iDirCount, cFullDirPath, "~\":U).

            FILE-INFO:FILE-NAME = cCreateDir.
            IF FILE-INFO:FILE-TYPE = ? 
            THEN DO:
                updateEditor("Creating directory - " + FILE-INFO:FILE-NAME).

                OS-CREATE-DIR VALUE(FILE-INFO:FILE-NAME).
                IF OS-ERROR <> 0 
                THEN DO:
                    updateEditor("Unable to create directory.").
                    updateLogFile('Log':u, "Unable to create directory - " + FILE-INFO:FILE-NAME).
                    ASSIGN cInvalidDir = cObjectPath.
                END.
            END.
        END.    /* check whether to create dirs */
        
        /* Find the exact location of the directory on disk */
        IF cInvalidDir = CHR(27) THEN
        DO:
            FILE-INFO:FILE-NAME = REPLACE(seAdditionalDirectories:ENTRY(iDirectory), "/":U, "~\":U) + "~\":U.

            IF FILE-INFO:FILE-TYPE <> ? THEN
            DO:
                /* At this point, the directory will exist, so copy all the files in the specified addtional
                   directory over to the deployment directory */
                INPUT FROM OS-DIR(FILE-INFO:FULL-PATHNAME).

                REPEAT:
                    IMPORT cDirImport.

                    IF INDEX(cDirImport[3], "F":U) <> 0 THEN
                    DO:
                        updateEditor("Copying " + cDirImport[2]).

                        OS-COPY VALUE(cDirImport[2]) VALUE(cFullDirPath + cDirImport[1]).

                        IF OS-ERROR <> 0 THEN
                        DO:
                            updateLogFile('Log':u, "Unable to copy " + cDirImport[2] + " to " + cFullDirPath + cDirImport[1]).
                        END.                        
                    END.    /* file doesn't exist */
                END.    /* repeat */
            END.    /* dir exists */
        END.    /* invalidDir eq chr(27) */
    END.    /* loop through directories */
END.    /* Additional items */

/* Delete any empty directories */

RUN deleteEmptyDirs (INPUT fiTarget:SCREEN-VALUE).

/* Finished */

updateLogFile('Log':u, "").
updateLogFile('Log':u, "Deployment Process finished : " + STRING(TIME, "HH:MM:SS":U)).

updateEditor("").
updateEditor("Deployment Process finished : " + STRING(TIME, "HH:MM:SS":U)).

/* Open the log file */

IF toOpenLogFile:CHECKED = YES THEN
    RUN openDocument (INPUT REPLACE(fiLogFile:SCREEN-VALUE, "/":U, "~\":U)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteEmptyDirs sObject 
PROCEDURE deleteEmptyDirs :
/*------------------------------------------------------------------------------
  Purpose:     Deletes any directories with no files in them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDirectory AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cFullDirPath    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lObjectDeployed AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFileName       AS CHARACTER  NO-UNDO.

/* Right, now run through the directory structure, and delete any empty directories we've created. *
 * We have to check if there's anything in the directory structure under each directory as well.   */

updateEditor("").
updateEditor("Deleting empty directories:":U).
updateEditor("").

EMPTY TEMP-TABLE ttDir.

OS-COMMAND SILENT VALUE('dir "' + REPLACE(pcDirectory, "/":U, "~\":U) + '" /ad /s /b > "' + SESSION:TEMP-DIRECTORY + 'deployment_dirs.tmp"').

INPUT STREAM one FROM VALUE(SESSION:TEMP-DIRECTORY + "deployment_dirs.tmp").
rep-blk:
REPEAT:
    IMPORT STREAM one UNFORMATTED cFullDirPath.
    CREATE ttDir.
    ASSIGN ttDir.tt_dirname = cFullDirPath.
END.

fe-blk:
FOR EACH ttDir
      BY ttDir.tt_dirname DESCENDING:

    FILE-INFO:FILE-NAME = ttDir.tt_dirname.
    IF FILE-INFO:FILE-NAME = ? THEN /* We could have deleted this directories parent dir already */
        NEXT fe-blk.

    OS-COMMAND SILENT VALUE('dir "' + ttDir.tt_dirname + '" /a /s /b > "' + SESSION:TEMP-DIRECTORY + 'deployment_dir_files.tmp"':U).

    INPUT STREAM two FROM VALUE(SESSION:TEMP-DIRECTORY + "deployment_dir_files.tmp":U).
    ASSIGN lObjectDeployed = NO.
    file-blk:
    REPEAT:
        IMPORT STREAM two UNFORMATTED cFileName.

        IF SEARCH(cFileName) <> ? /* We'll be getting dirs and filenames, this will only be true for filenames */
        THEN DO:
            ASSIGN lObjectDeployed = YES.
            LEAVE file-blk.
        END.
    END.
    INPUT STREAM two CLOSE.

    IF lObjectDeployed = NO
    THEN DO:
        updateEditor("Deleting directory - " + ttDir.tt_dirname).
        OS-DELETE VALUE(ttDir.tt_dirname).
        IF OS-ERROR <> 0 THEN
            updateLogFile('Log':u, "Unable to delete directory - " + ttDir.tt_dirname).
    END.
END.
INPUT STREAM one CLOSE.

OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "deployment_dirs.tmp":U).
OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "deployment_dir_files.tmp":U).

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
  DEFINE VARIABLE cAdditionalDirectories  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid                  AS ROWID      NO-UNDO.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:

      ASSIGN fiSource:SCREEN-VALUE       = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE, INPUT "_framework_directory":U) NO-ERROR.
      ASSIGN fiLogFile:SCREEN-VALUE      = SESSION:TEMP-DIRECTORY + "deployment.log"
             fiListingFile:screen-value  = session:temp-directory + "listing.log":u
             fiListingFile:tooltip       = 'The name of a file into which a formatted listing of the deployed files will be written. '
                                         + 'The listing will not be written if this field is empty.'
             fiLabel:SCREEN-VALUE        = " Deployment will include:"
             fiAddDirHeader:SCREEN-VALUE = " Additionally, include ALL files in these directories with the deployment:"
             fiDirLabel:SCREEN-VALUE     = " Additional Directories:"
             fiDestLabel:SCREEN-VALUE    = "Deployment type:"
             fiProgLabel:SCREEN-VALUE    = "Deployment progress:"
             fiNote:SCREEN-VALUE         = "*** NOTE: Please add sub-directories of the above manually"
             seList:LIST-ITEM-PAIRS      = "Remote Server Objects,SRV,Client Objects,CLN,Web Objects,WEB"
             toOpenLogFile:CHECKED       = YES
             toBlankType:CHECKED         = YES.
      
      APPLY "LEAVE":U TO fiSource.
      APPLY "LEAVE":U TO fiLogFile.

      RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                               INPUT "Preference":U,
                                               INPUT "AdditionalDeployDir":U,
                                               INPUT NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cAdditionalDirectories)
                                               NO-ERROR.

      /* This will indicate that it is set to nothing... */
      IF cAdditionalDirectories <> "?":U THEN
          IF cAdditionalDirectories = "":U THEN
              /* This means that no profile data exists */
              seAdditionalDirectories:LIST-ITEMS = "ry/img":U.
          ELSE
              /* This means actual profile data exists */
              seAdditionalDirectories:LIST-ITEMS = cAdditionalDirectories.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openDocument sObject 
PROCEDURE openDocument :
/*------------------------------------------------------------------------------

  Purpose:  Open  Document
  Parameters:  pcDocument
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDocument AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cExecutable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iInstance   AS INTEGER    NO-UNDO.

/* Find the associated cExecutable in registry */
ASSIGN cExecutable = fill("x", 255). /* Dallocate memory */
RUN FindExecutableA (pcDocument,
                     "",
                     INPUT-OUTPUT cExecutable,
                     OUTPUT iInstance).

/* If not found, show the OpenAs dialog from the Explorer */
IF iInstance > 0 AND iInstance<= 32 THEN
    RUN ShellExecuteA (0,
                       "open",
                       "rundll32.exe",
                       "shell32.dll,OpenAs_RunDLL " + pcDocument,
                       "",
                       1,
                       OUTPUT iInstance).

/* Now open the pcDocument. If the user canceled the OpenAs dialog, *
 * this ShellExecute call will silently fail.                       */

RUN ShellExecuteA (0,
                   "open",
                   pcDocument,
                   "",
                   "",
                   1,
                   OUTPUT iInstance).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeLogFile sObject 
FUNCTION initializeLogFile RETURNS LOGICAL
  ( INPUT pcLog     AS CHARACTER,
    INPUT pcLogfile AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores name of logfile internally, and clears log.
    Notes:  pclog = LISTING or LOG
            pclogfile = name of logfile
------------------------------------------------------------------------------*/
    define variable iIndex         as integer            no-undo.
    
    iIndex = lookup(pcLog, '{&LOG-TYPES}':u) no-error.
    if iIndex eq ? then iIndex = 0.
    
    if iIndex gt 0 then
    do:
        gcLogfiles[iIndex] = pcLogFile.
        
        output stream sLogging to value(gcLogfiles[iIndex]).
        output stream sLogging close.
    end.    /* valid logfile */
    
    error-status:error = no.
    return (iIndex gt 0).
END FUNCTION.   /* initializeLogFile */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateEditor sObject 
FUNCTION updateEditor RETURNS LOGICAL
  ( INPUT pcLine AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      /* We don't want the editor blowing any limits */
      IF LENGTH(edStatus:SCREEN-VALUE) > 30000 THEN
          ASSIGN edStatus:SCREEN-VALUE = "":U.

      IF edStatus:SCREEN-VALUE = "":U THEN
          ASSIGN edStatus:SCREEN-VALUE = pcLine.
      ELSE
          ASSIGN edStatus:SCREEN-VALUE = edStatus:SCREEN-VALUE + CHR(10) + pcLine.
      
      edStatus:MOVE-TO-EOF().
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateLogFile sObject 
FUNCTION updateLogFile RETURNS LOGICAL
  ( INPUT pcLog AS CHARACTER,
    INPUT pcLine AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  pcLog is one of LISTING or LOG
------------------------------------------------------------------------------*/
    define variable iIndex         as integer                        no-undo.
    
    iIndex = lookup(pcLog, '{&LOG-TYPES}':u) no-error.
    if iIndex eq ? then iIndex = 0.
    
    if iIndex gt 0 then
    do:
        output stream sLogging to value(gcLogfiles[iIndex]) append.
        put stream sLogging unformatted pcLine skip.
        output stream sLogging close.
    end.    /* valid logfile */
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

