&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
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

  File: datad.w 

  Description: Dialog for getting settable attributes for a SmartData.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartData.

  Output Parameters:
      <none>
  Modified:  February 8, 1999
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fRowsToBatch lBatch RebuildOnRepos ~
fObjectname 
&Scoped-Define DISPLAYED-OBJECTS c_AppPartition fRowsToBatch fObjectname 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initRowsToBatch Attribute-Dlg 
FUNCTION initRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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
DEFINE VARIABLE c_AppPartition AS CHARACTER FORMAT "x(23)" 
     LABEL "&Partition" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 27.8 BY 1 NO-UNDO.

DEFINE VARIABLE fObjectname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Instance &Name" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fRowsToBatch AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "&Rows" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .95 NO-UNDO.

DEFINE VARIABLE ckCurChanged AS LOGICAL INITIAL no 
     LABEL "&Check Current Changed" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE DestroyStateless AS LOGICAL INITIAL no 
     LABEL "&Destroy on each stateless Web Request" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.6 BY .81 NO-UNDO.

DEFINE VARIABLE DisconnectAppServer AS LOGICAL INITIAL no 
     LABEL "Disconnect &AppServer on each Web Request" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE lBatch AS LOGICAL INITIAL no 
     LABEL "Read Data in &Batches of:" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.6 BY .81 NO-UNDO.

DEFINE VARIABLE RebuildOnRepos AS LOGICAL INITIAL no 
     LABEL "Rebuild Dataset &on Reposition" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE ServerOperatingMode AS LOGICAL INITIAL no 
     LABEL "&Force to Stateful Operating Mode" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_AppPartition AT ROW 2.67 COL 17.4 COLON-ALIGNED
     fRowsToBatch AT ROW 3.95 COL 46.2 COLON-ALIGNED
     lBatch AT ROW 4.1 COL 19.4
     ckCurChanged AT ROW 5.24 COL 19.4
     RebuildOnRepos AT ROW 6.43 COL 19.4
     ServerOperatingMode AT ROW 7.57 COL 19.4
     DestroyStateless AT ROW 8.71 COL 19.4
     DisconnectAppServer AT ROW 9.91 COL 19.4
     fObjectname AT ROW 1.38 COL 17.4 COLON-ALIGNED
     SPACE(40.59) SKIP(8.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartDataObject Properties":L.


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
   Custom                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX ckCurChanged IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX c_AppPartition IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX DestroyStateless IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX DisconnectAppServer IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lBatch IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX RebuildOnRepos IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX ServerOperatingMode IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
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
ON GO OF FRAME Attribute-Dlg /* SmartDataObject Properties */
DO:
    
  ASSIGN
    saveAppPartition = IF c_AppPartition:SCREEN-VALUE = noPartition 
                       THEN "":U
                       ELSE c_AppPartition:SCREEN-VALUE.
  /* Check web properties and give warning about bad (locked) choice */
  IF web AND NOT webStateCheck() THEN
      RETURN NO-APPLY.
  /* Put the attributes back into the SmartObject. */
  DYNAMIC-FUNCTION("setAppService":U IN p_hSMO, 
                            saveAppPartition).
  DYNAMIC-FUNCTION("setRowsToBatch":U IN p_hSMO,
                    INT(fRowsToBatch:SCREEN-VALUE)).
  DYNAMIC-FUNCTION("setCheckCurrentChanged":U IN p_hSMO,
                    ckCurChanged:CHECKED).
  DYNAMIC-FUNCTION("setRebuildOnRepos":U IN p_hSMO,
                    RebuildOnRepos:CHECKED).
  DYNAMIC-FUNCTION("setServerOperatingMode":U IN p_hSMO,
                    IF ServerOperatingMode:CHECKED THEN "STATE-RESET"
                                                   ELSE "NONE").
  DYNAMIC-FUNCTION("setDestroyStateless":U IN p_hSMO,
                    DestroyStateless:CHECKED).
  DYNAMIC-FUNCTION("setDisconnectAppServer":U IN p_hSMO,
                    DisconnectAppServer:CHECKED).
  DYNAMIC-FUNCTION("setObjectname":U IN p_hSMO, fObjectName:SCREEN-VALUE).
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartDataObject Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_AppPartition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_AppPartition Attribute-Dlg
ON VALUE-CHANGED OF c_AppPartition IN FRAME Attribute-Dlg /* Partition */
DO:
  initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DestroyStateless
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DestroyStateless Attribute-Dlg
ON VALUE-CHANGED OF DestroyStateless IN FRAME Attribute-Dlg /* Destroy on each stateless Web Request */
DO:
  initObjects().       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lBatch Attribute-Dlg
ON VALUE-CHANGED OF lBatch IN FRAME Attribute-Dlg /* Read Data in Batches of: */
DO:
  /* we store the currentvalue if unchecking */
  IF NOT SELF:CHECKED THEN 
    ASSIGN fRowsToBatch.   
  initRowsToBatch().
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
                   &CONTEXT = {&SmartDataObject_Attributes_Dlg_Box} }

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
  DISPLAY c_AppPartition fRowsToBatch fObjectname 
      WITH FRAME Attribute-Dlg.
  ENABLE fRowsToBatch lBatch RebuildOnRepos fObjectname 
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
  DEF VAR ldummy              AS LOGICAL                   NO-UNDO.
  DEF VAR definedAppPartition AS CHARACTER                 NO-UNDO.
  DEF VAR PartitionChosen     AS CHARACTER                 NO-UNDO.
  DEF VAR cOpMode             AS CHARACTER                 NO-UNDO.
  DEF VAR cObjType            AS CHARACTER  NO-UNDO.
  DO WITH FRAME Attribute-Dlg:
    
    /* Get desing window procedure type */
    RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT cobjtype).

    /********* Application Partition *********/
    /* 
     * Get the application Partition from the object, if none defined, set to (None)
     * Get the list of defined application Partitions, add (None) to the list
     * Add the object application Partition to the list if not already there
     * Set the application Partition screen-value to the given app Partition
     */
    ASSIGN c_AppPartition:DELIMITER = CHR(3)
           appPartition = IF cObjType BEGINS "SmartBusinessObject":U 
                          THEN noPartition 
                          ELSE dynamic-function("getAppService" IN p_hSMO) NO-ERROR.
    ASSIGN PartitionChosen = IF ERROR-STATUS:ERROR 
                             OR appPartition = "":U  
                             OR appPartition = ? 
                             THEN noPartition
                             ELSE appPartition.
  
    /* Check to see if adecomm/ad-utils.w is running. If it is then query the
     * it to get the list of defined Application Partitions */
    IF VALID-HANDLE(AppSrvUtils) THEN
    DO:
       ASSIGN 
          definedAppPartition = 
              dynamic-function("definedPartitions" IN AppSrvUtils) NO-ERROR.
          c_AppPartition:LIST-ITEMS  = IF ERROR-STATUS:ERROR    OR 
                                        definedAppPartition = ? OR 
                                        definedAppPartition = "":U
                                       THEN noPartition
                                       ELSE noPartition + CHR(3) + definedAppPartition.
    END.
  
    IF NOT CAN-DO(REPLACE(noPartition + CHR(3) + definedAppPartition,CHR(3),",":U),
                  appPartition) THEN
       ASSIGN c_AppPartition:SORT = TRUE
              ldummy              = c_AppPartition:ADD-FIRST (appPartition).
  
    ASSIGN 
      c_AppPartition:SENSITIVE    = NOT (cObjType BEGINS "SmartBusinessObject":U)
      c_AppPartition:SCREEN-VALUE = PartitionChosen.

    /********* Rows To Batch *********/
    fRowsToBatch:SCREEN-VALUE    = DYNAMIC-FUNCTION("getRowsToBatch":U IN p_hSMO).
    ASSIGN fRowsToBatch           = INTEGER(fRowsToBatch:SCREEN-VALUE)
           fRowsToBatch:SENSITIVE = TRUE
           lBatch:CHECKED         = fRowsToBatch <> 0. /* initRowsToBatch takes care of the rest*/

    /********* Check Current Changed *********/
    ckCurChanged:SCREEN-VALUE = DYNAMIC-FUNCTION("getCheckCurrentChanged":U IN p_hSMO).
    ASSIGN ckCurChanged           = ckCurChanged:CHECKED
           ckCurChanged:SENSITIVE = TRUE.

    /* RebuildOnRepos *******************/
    RebuildOnRepos:SCREEN-VALUE = DYNAMIC-FUNCTION("getRebuildOnRepos":U IN p_hSMO).
    ASSIGN RebuildOnRepos:SENSITIVE = TRUE.

    /* Server Operating Mode  *******************/
    cOpMode = DYNAMIC-FUNCTION("getServerOperatingMode":U IN p_hSMO). 
    ASSIGN ServerOperatingMode:CHECKED   = cOpMode EQ "STATE-RESET":U
           ServerOperatingMode:SENSITIVE = TRUE.
       
    /* Destroy Stateless */
    ASSIGN DestroyStateless:CHECKED = DYNAMIC-FUNCTION("getDestroyStateless":U IN p_hSMO).
    
    /* Disconnect AppServer */
    ASSIGN DisconnectAppServer:CHECKED = DYNAMIC-FUNCTION("getDisconnectAppServer":U IN p_hSMO).
   
    /* ObjectNeme */
    ASSIGN fObjectName = DYNAMIC-FUNCTION('getObjectName':U IN p_hSMO).
    initRowsToBatch(). 
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
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowsLabel AS HANDLE     NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    VIEW. /* The algorithm for adjusting the label requires realized widgets. */
    ASSIGN
      /* Move the label AFTER the field */  
      hRowsLabel                    = fRowsToBatch:SIDE-LABEL-HANDLE
      hRowsLabel:COL                = fRowsToBatch:COL + fRowsToBatch:WIDTH + 0.5
      /* and remove the colon */
      hRowsLabel:WIDTH              = FONT-TABLE:GET-TEXT-WIDTH-CHARS
                                                  (SUBSTR(hRowsLabel:SCREEN-VALUE,
                                                          1,
                                                          LENGTH(hRowsLabel:SCREEN-VALUE) - 1)) 
      ckCurChanged:SENSITIVE        = NOT web
      ckCurChanged:CHECKED          = IF web 
                                      THEN FALSE 
                                      ELSE ckCurChanged:CHECKED 
      serverOperatingMode:SENSITIVE = c_AppPartition:SCREEN-VALUE <> noPartition 
      destroyStateless:SENSITIVE    = web
      disconnectAppServer:SENSITIVE = web AND NOT destroyStateless:CHECKED   
                                      AND 
                                      c_AppPartition:SCREEN-VALUE <> noPartition.

  END.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initRowsToBatch Attribute-Dlg 
FUNCTION initRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: UI adjustments for RowsToBatch 
    Notes: lbatch is set checked if RowsToBatch <> 0 at startup.
           and this is also called form the trigger     
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
   IF lBatch:CHECKED THEN
   DO:
     ASSIGN 
       fRowsToBatch:READ-ONLY    = FALSE
       fRowsToBatch:TAB-STOP     = TRUE  
       fRowsTOBatch:FORMAT       = ">>>>>>>9".
       fRowsToBatch:SCREEN-VALUE = IF fRowsToBatch <> 0 
                                   THEN STRING(fRowsTOBatch)
                                   ELSE STRING(200). /* ?? */
     fRowsToBatch:MOVE-AFTER(lBatch:HANDLE).
   END. /* checked*/
   ELSE DO:
     ASSIGN 
       fRowsToBatch:READ-ONLY    = TRUE
       fRowsToBatch:TAB-STOP     = FALSE 
       fRowsToBatch:SCREEN-VALUE = STRING(0).
       fRowsTOBatch:FORMAT       = "ZZZZZZZ".
   END. /* unchecked */
 END.
 RETURN TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Give warning if user has selected options that locks the AppServer  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
  IF  ServerOperatingMode:CHECKED 
  AND NOT DestroyStateless:CHECKED 
  AND NOT DisconnectAppServer:CHECKED THEN 
  DO:
    MESSAGE 
  "Setting Force to Stateful without setting Disconnect or Destroy on each Web Request" SKIP
  "will lock the AppServer agent to WebSpeed for the whole session." 
             SKIP(1)
  "Do you want to keep this properties?"
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lOk AS LOG.    
  END.
  ELSE lok = TRUE.
 END. /* do with frame */

 RETURN lok.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

