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
/*---------------------------------------------------------------------------------
  File: rycsodeplv.w

  Description:  Object Deployment Destination Viewer

  Purpose:      Object Deployment Destination Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/17/2002  Author:     

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

&scop object-name       rycsodeplv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghBrowserHandle AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buSelect buDeselect toServer toClient toWeb ~
toDesign toOverwrite buUpdate fiLabel 
&Scoped-Define DISPLAYED-OBJECTS toServer toClient toWeb toDesign ~
toOverwrite fiLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buDeselect 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14 TOOLTIP "Deselect all selected records in the browser"
     BGCOLOR 8 .

DEFINE BUTTON buSelect 
     LABEL "&Select All" 
     SIZE 15 BY 1.14 TOOLTIP "Select all records visible in the browser"
     BGCOLOR 8 .

DEFINE BUTTON buUpdate 
     LABEL "&Update" 
     SIZE 15 BY 1.14 TOOLTIP "Update all selected records in the browser"
     BGCOLOR 8 .

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U INITIAL " Deploy Selected Objects to:" 
      VIEW-AS TEXT 
     SIZE 31.2 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE toClient AS LOGICAL INITIAL no 
     LABEL "Client machines" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.4 BY .81 TOOLTIP "Indicates objects should be deployed to client machines eg. UI objects" NO-UNDO.

DEFINE VARIABLE toDesign AS LOGICAL INITIAL no 
     LABEL "Development only" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .81 TOOLTIP "Indicates objects are only used for development" NO-UNDO.

DEFINE VARIABLE toOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwrite existing setup" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.2 BY .81 TOOLTIP "YES will overwrite, NO will append - to existing object deployment setup" NO-UNDO.

DEFINE VARIABLE toServer AS LOGICAL INITIAL no 
     LABEL "Remote servers" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.8 BY .81 TOOLTIP "Indicates objects should be deployed to remote servers eg. Appserver procedures" NO-UNDO.

DEFINE VARIABLE toWeb AS LOGICAL INITIAL no 
     LABEL "Web" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Indicates objects should be deployed to the Web" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buSelect AT ROW 1.81 COL 1
     buDeselect AT ROW 3.1 COL 1
     toServer AT ROW 5.71 COL 1
     toClient AT ROW 6.62 COL 1
     toWeb AT ROW 7.57 COL 1
     toDesign AT ROW 8.52 COL 1
     toOverwrite AT ROW 10.05 COL 1
     buUpdate AT ROW 11.05 COL 1
     fiLabel AT ROW 4.57 COL 1 NO-LABEL
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
         HEIGHT             = 11.19
         WIDTH              = 31.2.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiLabel IN FRAME frMain
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

&Scoped-define SELF-NAME buDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeselect sObject
ON CHOOSE OF buDeselect IN FRAME frMain /* Deselect All */
DO:
  IF NOT VALID-HANDLE(ghBrowserHandle) THEN
    RETURN.

  ghBrowserHandle:DESELECT-ROWS().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelect sObject
ON CHOOSE OF buSelect IN FRAME frMain /* Select All */
DO:
  IF NOT VALID-HANDLE(ghBrowserHandle) THEN
      RETURN.

  ghBrowserHandle:SELECT-ALL().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUpdate sObject
ON CHOOSE OF buUpdate IN FRAME frMain /* Update */
DO:
  DEFINE VARIABLE cAnswer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed AS CHARACTER  NO-UNDO.

  /* Validation checks */

  IF ghBrowserHandle:NUM-SELECTED-ROWS = 0 
  THEN DO:
      RUN showMessages IN gshSessionManager (INPUT "You have not selected any objects to update." + CHR(10)
                                                 + "Update Cancelled.",
                                             INPUT "ERR":U,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT cButtonPressed).
      RETURN.
  END.

  /* Build a nice message explaining to the user what we plan to do */

  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.

  IF  toServer:CHECKED = FALSE
  AND toClient:CHECKED = FALSE  
  AND toWeb:CHECKED    = FALSE 
  AND toDesign:CHECKED = FALSE 
  THEN DO:
      IF toOverwrite:CHECKED = NO 
      THEN DO:
          RUN showMessages IN gshSessionManager (INPUT "You have not selected any environments to deploy to, and have set the Overwrite flag to NO." 
                                                     + " This effectively means objects will not be updated." + CHR(10)
                                                     + "If you wish to clear the existing information on objects, do not select any deployment environments, "
                                                     + "and set the Overwrite flag to YES."
                                                     + CHR(10) + CHR(10) + "Update Cancelled.",
                                                 INPUT "ERR":U,
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT "",
                                                 INPUT NO,
                                                 INPUT ?,
                                                 OUTPUT cButtonPressed).
          RETURN.
      END.

     ASSIGN cMessage = "You have not selected any environments to deploy to, the selected objects will not be deployed." + CHR(10) + CHR(10).
  END.
  ELSE DO:
      ASSIGN cMessage = "The selected objects will be updated to be deployed:" + CHR(10).

      IF toServer:CHECKED = TRUE THEN
          ASSIGN cMessage = cMessage + "- to Remote Servers." + CHR(10).
      IF toClient:CHECKED = TRUE THEN
          ASSIGN cMessage = cMessage + "- to Client Machines." + CHR(10).
      IF toWeb:CHECKED = TRUE THEN
          ASSIGN cMessage = cMessage + "- to the Web." + CHR(10).
      IF toDesign:CHECKED = TRUE THEN
          ASSIGN cMessage = cMessage + "- to Development Environments only." + CHR(10).
      ELSE
          ASSIGN cMessage = cMessage + "- to Development and Runtime Environments." + CHR(10).
  END.

  IF toOverwrite:CHECKED = TRUE THEN
      ASSIGN cMessage = cMessage + chr(10) + "Any deployment information already set up on the selected objects will be overwritten." + CHR(10).
  ELSE DO:
      ASSIGN cMessage = cMessage + chr(10) + "If deployment information is already set up for an object, the selected"
                      + " options will be appended to the existing information if necessary." + CHR(10).
  END.

  ASSIGN cMessage = cMessage + CHR(10) + "Are you sure you wish to continue?".

  RUN askQuestion IN gshSessionManager (INPUT cMessage,
                                        INPUT "&Yes,&No",
                                        INPUT "&No",
                                        INPUT "&No",
                                        INPUT "Update Object Deployment Destinations",
                                        INPUT "",
                                        INPUT "",
                                        INPUT-OUTPUT cAnswer,
                                        OUTPUT cButtonPressed).
  IF cButtonPressed = "&NO" THEN
      RETURN.

  /* And now go and update the selected objects */

  RUN updateObjects.
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
  ASSIGN fiLabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " Deploy Selected Objects to:"
         toOverwrite:CHECKED IN FRAME {&FRAME-NAME}  = TRUE.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN ghBrowserHandle = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U,"User1 *-Source":U))).
  {get browseHandle ghBrowserHandle ghBrowserHandle}.
  APPLY "VALUE-CHANGED":U TO ghBrowserHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateObjects sObject 
PROCEDURE updateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt               AS INTEGER    NO-UNDO.
DEFINE VARIABLE hBufferHandle      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDO               AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBrowser           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cStatus            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDeplType          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDesign            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iDeployCnt         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cDeploymentString       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectDeploymentString AS CHARACTER  NO-UNDO.

IF 1 = 2 THEN VIEW FRAME {&FRAME-NAME}. /* Lazee frame scoping */

ASSIGN cDeploymentString = (IF toServer:CHECKED = YES THEN "SRV,":U ELSE "":U)
                         + (IF toClient:CHECKED = YES THEN "CLN,":U ELSE "":U)
                         + (IF toWeb:CHECKED    = YES THEN "WEB":U  ELSE "":U)
       cDeploymentString = RIGHT-TRIM(cDeploymentString, ",":U)
       hBufferHandle     = ghBrowserHandle:QUERY:GET-BUFFER-HANDLE(1)
       hBrowser          = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U,"User1 *-Source":U))).

IF VALID-HANDLE(hBufferHandle)
AND hBufferHandle:AVAILABLE THEN
    ASSIGN cObjectName = hBufferHandle:BUFFER-FIELD("object_filename":U):BUFFER-VALUE.

{get dataSource hSDO hBrowser}.
{get containerSource hContainerSource}.

/* Find the deployment type column in the browser */

ASSIGN hColumn = ghBrowserHandle:FIRST-COLUMN.
do-blk:
DO WHILE VALID-HANDLE(hColumn):
    CASE hColumn:NAME:
        WHEN "deployment_type":U THEN
            ASSIGN hDeplType = hColumn.
        WHEN "design_only":U THEN
            ASSIGN hDesign = hColumn.
    END CASE.
    ASSIGN hColumn = hColumn:NEXT-COLUMN.
END.

/* Cycle through the selected records and update them */

DO iCnt = 1 TO ghBrowserHandle:NUM-SELECTED-ROWS:

    ghBrowserHandle:FETCH-SELECTED-ROW(iCnt).

    /* Give the user an indication of what we're busy with */

    ASSIGN cStatus = "Updating object - ":U + hBufferHandle:BUFFER-FIELD("object_filename"):BUFFER-VALUE.
    {set statusDefault cStatus hContainerSource}.

    /* Make sure the browser and SDO knows we've changed records */

    {set RowIdent STRING(hBufferHandle:ROWID) hBrowser}.
    RUN dataAvailable IN hSDO ("DIFFERENT":U) NO-ERROR.

    /* Now commit the updated deployment type for the object */

    IF toOverwrite:CHECKED = YES THEN
        ASSIGN hDeplType:SCREEN-VALUE = cDeploymentString.
    ELSE DO:
        IF hDeplType:SCREEN-VALUE = "":U THEN
            ASSIGN hDeplType:SCREEN-VALUE = cDeploymentString.
        ELSE DO:
            /* If we're appending, add any already set up deployment types to our list of deployment types */
            ASSIGN cObjectDeploymentString = cDeploymentString.
            DO iDeployCnt = 1 TO NUM-ENTRIES(hDeplType:SCREEN-VALUE):
                IF LOOKUP(ENTRY(iDeployCnt, hDeplType:SCREEN-VALUE), cDeploymentString) = 0 THEN
                    ASSIGN cObjectDeploymentString = cObjectDeploymentString + "," + ENTRY(iDeployCnt, hDeplType:SCREEN-VALUE).
            END.
            ASSIGN hDeplType:SCREEN-VALUE = cObjectDeploymentString.
        END.
    END.

    ASSIGN hDesign:SCREEN-VALUE = STRING(toDesign:CHECKED = YES). /* we don't want ? screwing things up */

    RUN updateRecord IN hBrowser.
END.

ASSIGN cStatus = "":U.
{set statusDefault cStatus hContainerSource}.

/* Now refresh our query */
IF VALID-HANDLE(hContainerSource) THEN
    DYNAMIC-FUNCTION("lockContainingWindow":U IN hContainerSource, YES).

DYNAMIC-FUNCTION("closeQuery":U IN hSDO) NO-ERROR.
DYNAMIC-FUNCTION("openQuery":U IN hSDO) NO-ERROR.
IF cObjectName <> "":U
THEN DO:
    {fnarg findRowWhere "'object_filename':U,cObjectName,'='" hSDO}.
    ghBrowserHandle:SELECT-FOCUSED-ROW().
END.

IF VALID-HANDLE(hContainerSource) THEN
    DYNAMIC-FUNCTION("lockContainingWindow":U IN hContainerSource, NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

