&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: sbod.w 

  Description: Dialog for getting settable attributes for a SmartBusinessObject.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartBusinessObject.

  Output Parameters:
      <none>
  Modified:  May 16, 2000 -- Version 9.1B
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-Btn YES
/* Starts Application Service tool if not already started 
 * The tool is used to populate the combo box with the Defined Application Service
 */
{adecomm/appserv.i}                 /* AppServer Application Service    */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cValue            AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE lValue            AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE cObjType          AS CHARACTER                 NO-UNDO.

DEFINE VARIABLE saveAppPartition    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE appPartition        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE noPartition         AS CHARACTER INIT "(None)":U NO-UNDO.
DEFINE VARIABLE Web                 AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE cDONs               AS CHARACTER                 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lOpenOnInit cObjectNames 
&Scoped-Define DISPLAYED-OBJECTS cAppPartition lOpenOnInit cObjectNames 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initObjects Attribute-Dlg 
FUNCTION initObjects RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Down 
     LABEL "Move &Down" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn-Up 
     LABEL "Move &Up" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cAppPartition AS CHARACTER FORMAT "x(25)" 
     LABEL "&Partition" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 36.6 BY 1 NO-UNDO.

DEFINE VARIABLE cObjectNames AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 34.6 BY 5.24 NO-UNDO.

DEFINE VARIABLE lOpenOnInit AS LOGICAL INITIAL no 
     LABEL "&Open query on initialization" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     cAppPartition AT ROW 2.19 COL 9.4 COLON-ALIGNED
     lOpenOnInit AT ROW 4.57 COL 11.4
     Btn-Up AT ROW 6.71 COL 11.4
     cObjectNames AT ROW 6.71 COL 27.4 NO-LABEL
     Btn-Down AT ROW 8.14 COL 11.4
     "  Select the AppServer partition on which to run:" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 1.24 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "   Toggle off to avoid retrieveing data on initialization:" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 3.62 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "   Place SDOs in proper update order:" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 5.76 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(1.19) SKIP(5.56)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartBusinessObject Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn-Down IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-Up IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cAppPartition IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
ASSIGN 
       cObjectNames:AUTO-RESIZE IN FRAME Attribute-Dlg      = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* SmartBusinessObject Properties */
DO:
  ASSIGN
    lOpenOnInit
    saveAppPartition = IF cAppPartition:SCREEN-VALUE = noPartition 
                       THEN "":U
                       ELSE cAppPartition:SCREEN-VALUE.
/*   /* Check web properties and give warning about bad (locked) choice */ */
/*   IF web AND NOT webStateCheck() THEN                                   */
/*       RETURN NO-APPLY.                                                  */
  /* Put the attributes back into the SmartObject. */
  DYNAMIC-FUNCTION("setAppService":U IN p_hSMO, 
                            saveAppPartition).
  DYNAMIC-FUNCTION("setOpenOnInit":U IN p_hSMO, lOpenOnInit).
  /*
  DYNAMIC-FUNCTION("setCascadeOnBrowse":U IN p_hSMO, lCascade).
  */
  DYNAMIC-FUNCTION("setUpdateOrder":U IN p_hSMO, cDONs).
/*   DYNAMIC-FUNCTION("setServerOperatingMode":U IN p_hSMO,                   */
/*                     IF ServerOperatingMode:CHECKED THEN "STATE-RESET"      */
/*                                                    ELSE "NONE").           */
/*   DYNAMIC-FUNCTION("setDestroyStateless":U IN p_hSMO,                      */
/*                     DestroyStateless:CHECKED).                             */
/*   DYNAMIC-FUNCTION("setDisconnectAppServer":U IN p_hSMO,                   */
/*                     DisconnectAppServer:CHECKED).                          */
/*   DYNAMIC-FUNCTION("setObjectname":U IN p_hSMO, fObjectName:SCREEN-VALUE). */
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartBusinessObject Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Down Attribute-Dlg
ON CHOOSE OF Btn-Down IN FRAME Attribute-Dlg /* Move Down */
DO:
  DEFINE VARIABLE iEntry AS INT    NO-UNDO.
  DEFINE VARIABLE cMove  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSave  AS CHAR   NO-UNDO.

  ASSIGN cMove = cObjectNames:SCREEN-VALUE
         iEntry = LOOKUP(cMove, cDONs)
         cSave  = ENTRY(iEntry + 1, cDONs)
         ENTRY(iEntry + 1, cDONs) = cMove
         ENTRY(iEntry, cDONs) = cSave
         cObjectNames:LIST-ITEMS = cDONs
         cObjectNames:SCREEN-VALUE = cMove.
  APPLY "value-changed" TO cObjectNames.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Up Attribute-Dlg
ON CHOOSE OF Btn-Up IN FRAME Attribute-Dlg /* Move Up */
DO:
  DEFINE VARIABLE iEntry AS INT    NO-UNDO.
  DEFINE VARIABLE cMove  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSave  AS CHAR   NO-UNDO.

  ASSIGN cMove = cObjectNames:SCREEN-VALUE
         iEntry = LOOKUP(cMove, cDONs)
         cSave  = ENTRY(iEntry - 1, cDONs)
         ENTRY(iEntry - 1, cDONs) = cMove
         ENTRY(iEntry, cDONs) = cSave
         cObjectNames:LIST-ITEMS = cDONs
         cObjectNames:SCREEN-VALUE = cMove.
  APPLY "value-changed" TO cObjectNames.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cAppPartition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cAppPartition Attribute-Dlg
ON VALUE-CHANGED OF cAppPartition IN FRAME Attribute-Dlg /* Partition */
DO:
  initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cObjectNames
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cObjectNames Attribute-Dlg
ON VALUE-CHANGED OF cObjectNames IN FRAME Attribute-Dlg
DO:
  IF LOOKUP (cObjectNames:SCREEN-VALUE, cDONs) = 1 THEN
      ASSIGN Btn-Up:SENSITIVE = NO
             Btn-Down:SENSITIVE = YES.
  ELSE IF LOOKUP (cObjectNames:SCREEN-VALUE, cDONs) = 
    NUM-ENTRIES(cDONs) THEN
      ASSIGN Btn-Up:SENSITIVE = YES
             Btn-Down:SENSITIVE = NO.
  ELSE ASSIGN Btn-Up:SENSITIVE = YES
              Btn-Down:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* ************************ Standard Setup **************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartBusinessObject_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

/* Get procedure type */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT cObjType).
web = cObjType BEGINS "WEB":U.
 
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
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
  DISPLAY cAppPartition lOpenOnInit cObjectNames 
      WITH FRAME Attribute-Dlg.
  ENABLE lOpenOnInit cObjectNames 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ldummy              AS LOGICAL                   NO-UNDO.
  DEFINE VARIABLE definedAppPartition AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE PartitionChosen     AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cOpMode             AS CHARACTER                 NO-UNDO.
  
  DO WITH FRAME Attribute-Dlg:
 
    /********* Application Partition *********/
    /* 
     * Get the application Partition from the object, if none defined, set to (None)
     * Get the list of defined application Partitions, add (None) to the list
     * Add the object application Partition to the list if not already there
     * Set the application Partition screen-value to the given app Partition
     */
    ASSIGN cAppPartition:DELIMITER = CHR(3)
           appPartition = dynamic-function("getAppService" IN p_hSMO) NO-ERROR.
    ASSIGN PartitionChosen = IF ERROR-STATUS:ERROR OR appPartition = "":U  OR 
                              appPartition = ? THEN noPartition
                                               ELSE appPartition.
  
    /* Check to see if adecomm/ad-utils.w is running. If it is then query the
     * it to get the list of defined Application Partitions */
    IF VALID-HANDLE(AppSrvUtils) THEN
    DO:
       ASSIGN 
          definedAppPartition = 
              dynamic-function("definedPartitions" IN AppSrvUtils) NO-ERROR.
          cAppPartition:LIST-ITEMS  = IF ERROR-STATUS:ERROR    OR 
                                        definedAppPartition = ? OR 
                                        definedAppPartition = "":U
                                       THEN noPartition
                                       ELSE noPartition + CHR(3) + definedAppPartition.
    END.
  
    IF NOT CAN-DO(REPLACE(noPartition + CHR(3) + definedAppPartition,CHR(3),",":U),
                  appPartition) THEN
       ASSIGN cAppPartition:SORT = TRUE
              ldummy              = cAppPartition:ADD-FIRST (appPartition).
  
    ASSIGN cAppPartition:SCREEN-VALUE = PartitionChosen
           cAppPartition:SENSITIVE    = TRUE.
           
    lOpenOnInit  = DYNAMIC-FUNCTION("getOpenOnInit":U IN p_hSMO).
    
    /* If the UpdateOrder property isn't defined, then the SBO
       hasn't created it's dataobjects yet. */
    cDONs = DYNAMIC-FUNCTION("getUpdateOrder":U IN p_hSMO).
    IF cDONs = "":U OR cDONs = ? THEN
    DO:
        RUN createObjects IN p_hSMO.
        cDONs = 
            DYNAMIC-FUNCTION("getDataObjectNames":U IN p_hSMO).
    END.    /* END DO IF NO Targets yet */
    ASSIGN cObjectNames:LIST-ITEMS = cDONs
           cObjectNames:INNER-LINES = MIN(8, cObjectNames:NUM-ITEMS).

/*     /* Server Operating Mode  *******************/                    */
/*     cOpMode = DYNAMIC-FUNCTION("getServerOperatingMode":U IN p_hSMO). */
/*     ASSIGN ServerOperatingMode:CHECKED   = cOpMode EQ "STATE-RESET":U */
/*            ServerOperatingMode:SENSITIVE = TRUE.                      */
/*                                                                                                  */
/*     /* Destroy Stateless */                                                                      */
/*     ASSIGN DestroyStateless:CHECKED = DYNAMIC-FUNCTION("getDestroyStateless":U IN p_hSMO).       */
/*                                                                                                  */
/*     /* Disconnect AppServer */                                                                   */
/*     ASSIGN DisconnectAppServer:CHECKED = DYNAMIC-FUNCTION("getDisconnectAppServer":U IN p_hSMO). */
/*                                                                                                  */
/*     /* ObjectNeme */                                                    */
/*     ASSIGN fObjectName = DYNAMIC-FUNCTION('getObjectName':U IN p_hSMO). */
/*                                                                         */
    initObjects().    
  END. /* DO WITH FRAME */
END PROCEDURE. /* get-SmO-attributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initObjects Attribute-Dlg 
FUNCTION initObjects RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: set check boxes sensitivity according to the object type   
    Notes:  These commented entries are here because these properties will
            be needed later by the stateless SBO.
------------------------------------------------------------------------------*/
/*   DO WITH FRAME {&FRAME-NAME}:                                                    */
/*     ASSIGN                                                                        */
/*                                                                                   */
/*       serverOperatingMode:SENSITIVE = c_AppPartition:SCREEN-VALUE <> noPartition  */
/*       destroyStateless:SENSITIVE    = web                                         */
/*       disconnectAppServer:SENSITIVE = web AND NOT destroyStateless:CHECKED        */
/*                                       AND                                         */
/*                                       c_AppPartition:SCREEN-VALUE <> noPartition. */
/*   END.                                                                            */
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Give warning if user has selected options that locks the AppServer  
    Notes:  This commented code is here because we may need it later.
------------------------------------------------------------------------------*/
/*  DO WITH FRAME {&FRAME-NAME}:                                                                */
/*   IF  ServerOperatingMode:CHECKED                                                            */
/*   AND NOT DestroyStateless:CHECKED                                                           */
/*   AND NOT DisconnectAppServer:CHECKED THEN                                                   */
/*   DO:                                                                                        */
/*     MESSAGE                                                                                  */
/*   "Setting Force to Stateful without setting Disconnect or Destroy on each Web Request" SKIP */
/*   "will lock the AppServer agent to WebSpeed for the whole session."                         */
/*              SKIP(1)                                                                         */
/*   "Do you want to keep this properties?"                                                     */
/*     VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lOk AS LOG.                              */
/*   END.                                                                                       */
/*   ELSE lok = TRUE.                                                                           */
/*  END. /* do with frame */                                                                    */
/*                                                                                              */
/*  RETURN lok. */
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

