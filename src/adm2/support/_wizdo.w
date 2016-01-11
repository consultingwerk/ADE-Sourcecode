&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"SDO Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

  File: _wizdo.w

  Description: SDO wizard page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Ross Hunter 

  Created: 4/4/95 
  Modified: 03/25/98 SLK Changed d-*.* to d*.*
  Modified: 04/08/98 HD   Validate Filename when NEXT

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
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE objtype    AS CHARACTER NO-UNDO.
DEFINE VARIABLE obj-recid  AS CHARACTER NO-UNDO.
DEFINE VARIABLE proc-recid AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-status   AS LOGICAL   NO-UNDO.

DEFINE Variable gWizardHdl AS HANDLE  NO-UNDO.
DEFINE VARIABLE gDOHdl     AS HANDLE  NO-UNDO.

DEFINE VARIABLE xiHorMargin   AS INTEGER NO-UNDO INIT 4.
DEFINE VARIABLE xiToggleSpace AS INTEGER NO-UNDO INIT 10.

DEFINE TEMP-TABLE ttDataObject
    FIELD DOName        AS CHAR
    FIELD hName         AS HANDLE 
    FIELD hDataSource   AS HANDLE 
    FIELD hUpdateTarget AS HANDLE 
    INDEX DOName DOName .

FUNCTION getDataSourceNames   RETURNS CHARACTER IN gWizardHdl.
FUNCTION setDataSourceNames   RETURNS LOGICAL (pcNames AS CHAR) IN gWizardHdl.
FUNCTION getUpdateTargetNames RETURNS CHARACTER IN gWizardHdl.
FUNCTION setUpdateTargetNames RETURNS LOGICAL (pcNames AS CHAR) IN gWizardHdl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg cObjectType Data_Object b_brws b_Helpq 
&Scoped-Define DISPLAYED-OBJECTS e_msg cObjectType Data_Object 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyDataObjectList C-Win 
FUNCTION destroyDataObjectList RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObject C-Win 
FUNCTION initDataObject RETURNS LOGICAL
  (pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSDO C-Win 
FUNCTION initSDO RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeObjectsFromList C-Win 
FUNCTION removeObjectsFromList RETURNS LOGICAL
  (pcObjectList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetDataSource C-Win 
FUNCTION resetDataSource RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeDataObjectList C-Win 
FUNCTION storeDataObjectList RETURNS LOGICAL
  ( plCheck AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewDataObjectList C-Win 
FUNCTION viewDataObjectList RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_brws 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Helpq 
     LABEL "&Help on DataObject" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE cDisplayLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Disp." 
      VIEW-AS TEXT 
     SIZE 6 BY .62 NO-UNDO.

DEFINE VARIABLE cDisplayLabel-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Disp." 
      VIEW-AS TEXT 
     SIZE 6 BY .62 NO-UNDO.

DEFINE VARIABLE cEnableLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Enbl." 
      VIEW-AS TEXT 
     SIZE 5.4 BY .62 NO-UNDO.

DEFINE VARIABLE cEnableLabel-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Enbl." 
      VIEW-AS TEXT 
     SIZE 5.4 BY .62 NO-UNDO.

DEFINE VARIABLE cSDOlabel AS CHARACTER FORMAT "X(256)":U INITIAL "ObjectName" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE cSDOlabel-2 AS CHARACTER FORMAT "X(256)":U INITIAL "ObjectName" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE Data_Object AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cObjectType AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SmartDataObject", "SmartDataObject",
"SmartBusinessObject", "SmartBusinessObject"
     SIZE 50.6 BY .95 NO-UNDO.

DEFINE RECTANGLE rRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 2.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     cObjectType AT ROW 1.91 COL 3 NO-LABEL
     Data_Object AT ROW 2.91 COL 3 NO-LABEL
     b_brws AT ROW 2.91 COL 40
     b_Helpq AT ROW 9.81 COL 57
     cSDOlabel AT ROW 4.19 COL 1 COLON-ALIGNED NO-LABEL
     cDisplayLabel AT ROW 4.19 COL 15 COLON-ALIGNED NO-LABEL
     cEnableLabel AT ROW 4.19 COL 20.8 COLON-ALIGNED NO-LABEL
     cSDOlabel-2 AT ROW 4.19 COL 27.8 COLON-ALIGNED NO-LABEL
     cDisplayLabel-2 AT ROW 4.19 COL 41.2 COLON-ALIGNED NO-LABEL
     cEnableLabel-2 AT ROW 4.19 COL 47.2 COLON-ALIGNED NO-LABEL
     rRect AT ROW 1.52 COL 2
     "Data Source" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.24 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 11.67
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.86
         WIDTH              = 83.8
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 107.2
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 107.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
/* SETTINGS FOR FILL-IN cDisplayLabel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cDisplayLabel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cDisplayLabel-2 IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cDisplayLabel-2:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cEnableLabel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cEnableLabel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cEnableLabel-2 IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cEnableLabel-2:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSDOlabel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSDOlabel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN cSDOlabel-2 IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSDOlabel-2:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN Data_Object IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR RECTANGLE rRect IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_brws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_brws C-Win
ON CHOOSE OF b_brws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DEFINE VARIABLE cancelled  AS LOGICAL              NO-UNDO.
  DEFINE VARIABLE otherthing AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE Attributes AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE Template   AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE ObjLabel   AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE oldData_Object AS CHARACTER        NO-UNDO.  
 
  RUN adeuib/_uibinfo.p (
      INPUT ?,
      INPUT "PALETTE-ITEM ":U + cObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME},
      INPUT "ATTRIBUTES":U,
      OUTPUT Attributes).
  /*
  Cannot use template if the template starts a wizard  
  
  RUN adeuib/_uibinfo.p (
      INPUT ?,
      INPUT "PALETTE-ITEM ":U + xSmartDataObject,
      INPUT "TEMPLATE":U,
      OUTPUT Template).
  */
  
  IF Attributes <> "" THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN oldData_Object = Data_Object:SCREEN-VALUE.
    RUN adecomm/_chosobj.w (
        INPUT "smartObject",
        INPUT Attributes,
        INPUT Template,
        INPUT "BROWSE,PREVIEW":U,
        OUTPUT Data_Object,
        OUTPUT OtherThing,
        OUTPUT cancelled).
   
    IF NOT cancelled THEN 
    DO:
      DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.
      IF oldData_Object <> Data_Object:SCREEN-VALUE THEN
      DO:
        resetDataSource().
      END.
    END.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpq C-Win
ON CHOOSE OF b_Helpq IN FRAME DEFAULT-FRAME /* Help on DataObject */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Data_Object}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Data_Object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Data_Object C-Win
ON VALUE-CHANGED OF Data_Object IN FRAME DEFAULT-FRAME
DO: 
  /* nullify all data */
  ASSIGN data_object.
  resetDataSource().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.      
              
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get procedure type (SmartViewer or SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT objtype).

/* If this SmartViewer or SmartBrowser already has a DataObject defined  */
/* then preset Data_Object.                                              */
RUN adeuib/_uibinfo.p (INTEGER(proc-recid)," ","DataObject", OUTPUT Data_Object).

initDataObject(Data_object).

ASSIGN e_msg = 
      "You need to specify the DataObject that will be the data source for this " +
      objtype + ".".

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   /* Store DataObject filename */
   DO WITH FRAME {&FRAME-NAME}:
     RUN ProcessPage NO-ERROR. 
     IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.  
   END.
   RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
 
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeDataSource C-Win 
PROCEDURE changeDataSource :
/*------------------------------------------------------------------------------
  Purpose:   Value changed trigger for display of dataobject  
  Parameters:  <none>
  Notes:     if unchecked then we uncheck enable and make the update insensitive
             unless thr unchecked object has child objects that are dependant
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcName AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE hSDO                  AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hCurrentSDO           AS HANDLE   NO-UNDO.
   DEFINE VARIABLE lonetoone             AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE lHasOneToOneChild     AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE lOneToOneChildChecked AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hSource              AS HANDLE    NO-UNDO.

   DEFINE BUFFER bttDataObject FOR ttDataObject.  

   FIND ttDataObject WHERE ttDataObject.DOName = pcName NO-ERROR.
   
   hCurrentSDO = {fnarg DataObjectHandle pcName gDOHdl} NO-ERROR.
   {get UpdateFromSource lOneToOne hCurrentSDO} NO-ERROR.
   
   IF NOT lOneTOONe AND AVAIL ttDataObject THEN
   DO:
     IF ttDataObject.hDataSource:CHECKED THEN
     DO:
       ttDataObject.hUpdateTarget:SENSITIVE = TRUE.

     END.
     ELSE DO:       
       
       FOR EACH bttDataObject WHERE bttDataObject.DOName <> pcName:
         hSDO = {fnarg DataObjectHandle bttDataObject.DOName gDOHdl}.
         {get DataSource hSource hSDO}.         
         IF hSource = hCurrentSDO THEN
         DO:
           {get UpdateFromSource lOneToOne hSDO} NO-ERROR.
           IF NOT lhasOneToOneChild THEN 
             lhasOneToOneChild =  lOneToOne.
          /* Not yet, cause then we willneed to figure out when the last 
             of the one-to-one objects were unchecked and uncheck all updates 
           IF lOneToOne AND NOT lOnetoOneChildChecked THEN 
             lOnetoOneChildChecked = bttDataObject.hdataSource:CHECKED.
          */
         
         END.
       END.
       ASSIGN
         ttDataObject.hUpdateTarget:SENSITIVE = lhasOneToOneChild
         ttDataObject.hUpdateTarget:CHECKED   = FALSE.
       
       RUN changeUpdateTarget (pcName).  
     END.
   END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeUpdateTarget C-Win 
PROCEDURE changeUpdateTarget :
/*------------------------------------------------------------------------------
  Purpose:   uncheck/check other dataobjects enabling when one is changed
  Parameters:  <none>
  Notes:     Triggers when enable is changed or run from changedataSource    
             make sure that all other are unchekked or for all 
             objects that are child object defined as updatefrom source 
             we make sure they are in synch.
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcName AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE lOneTOOne   AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hSource     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hCurrentSDO AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hSDO        AS HANDLE     NO-UNDO.

   DEFINE BUFFER bttDataObject FOR ttDataObject.  
   
   FIND ttDataObject WHERE ttDataObject.DOName = pcName NO-ERROR.
   hCurrentSDO = {fnarg DataObjectHandle pcName gDOHdl}.

   IF AVAIL ttDataObject THEN
   DO:
     IF ttDataObject.hUpdateTarget:CHECKED THEN
     DO:
       FOR EACH bttDataObject WHERE bttDataObject.DOName <> pcName:
         hSDO = {fnarg DataObjectHandle bttDataObject.DOName gDOHdl}.

         {get DataSource hSource hSDO}.
         
         IF hSource = hCurrentSDO THEN
            {get UpdateFromSource  lOneToOne hSDO} NO-ERROR.
         ELSE lOneToOne = FALSE.

         bttDataObject.hUpdateTarget:CHECKED = lOneToOne.
       END.
     END.
     ELSE 
     DO:
       FOR EACH bttDataObject WHERE bttDataObject.DOName <> pcName:
         bttDataObject.hUpdateTarget:CHECKED = FALSE.
       END.
     END.
   END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME DEFAULT-FRAME.
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
  DISPLAY e_msg cObjectType Data_Object 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg cObjectType Data_Object b_brws b_Helpq 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose: Fires when next or back button is pressed
           does error checking on next.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.  
   
   DEFINE VARIABLE LastButton AS CHARACTER NO-UNDO.
  
   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).
   
   IF LastButton = "CANCEL" THEN RETURN.
   
   RUN adecomm/_setcurs.p("WAIT":U).
 
   ASSIGN FRAME {&FRAME-NAME} Data_Object.   
 
   IF LastButton = "NEXT":U THEN 
   DO: 
     IF Data_Object = "":U THEN
     DO:  
       MESSAGE 'You need to supply the name of a SmartDataObject.':U 
          VIEW-AS ALERT-BOX.
      
       RETURN ERROR.    
     END.
         
     RUN adecomm/_relfile.p (Data_Object,
                             NO, /* Never check remote */
                            "Verbose":U, 
                             OUTPUT cRelName).
     
     IF cRelname = ? THEN RETURN ERROR.

     ASSIGN 
        Data_Object = cRelname.                       
     DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.   
   
  END. /* if lastbutton = next */

            /* store and check */
  IF storeDataObjectList(LastButton = 'NEXT':U) = FALSE THEN
      RETURN ERROR .
  destroyDataObjectList().
  /* 
  Store even if we are going back in order to have what we entered
  if we come back to this page
  */    
  RUN adeuib/_setwatr.w(INTEGER(proc-recid), "DataObject", Data_Object, OUTPUT ok).
  
  RUN adecomm/_setcurs.p("":U). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyDataObjectList C-Win 
FUNCTION destroyDataObjectList RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy the tt and widgets used to update dataobject links 
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttDataObject:
    DELETE OBJECT ttDataObject.hName NO-ERROR.
    DELETE OBJECT ttDataObject.hDataSource NO-ERROR.
    DELETE OBJECT ttDataObject.hUpdateTarget NO-ERROR.
    DELETE ttDataObject.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObject C-Win 
FUNCTION initDataObject RETURNS LOGICAL
  (pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: start the dataobject and initialize the screen depending 
           of objectType and contents.     
    Notes: For SBOs we create fill-ins to display the Objects within and 
           check boxes so the user can select whether to display or update
           the objects from this visual object.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFill    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iX       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iY       AS INT        NO-UNDO.
  DEFINE VARIABLE iStartY  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUpd     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iHeight  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDynArea AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneTOOne AS LOGICAL   NO-UNDO.

  destroyDataObjectList().

  DO WITH FRAME {&FRAME-NAME}:
    RUN getSDOhandle IN gWizardHdl (pcName, OUTPUT gDOHdl).
    /* Set radioset to the objectType */
    ASSIGN
      cObjectType:SCREEN-VALUE = {fn getObjectType gDOHdl} 
      cObjectType   NO-ERROR.
    /* Only viewers supports SBOs, so disable otherwise */ 
    IF NOT (objType MATCHES "*viewer*":U) THEN
       cObjectType:DISABLE('SmartBusinessObject':U). 
 
    IF VALID-HANDLE(gDOHdl) AND cObjectType = 'SmartBusinessObject':U THEN
    DO:
      ASSIGN
        cDisp    = getDataSourceNames()
        cUpd     = getUpdateTargetNames()
        cSDOlist = {fn getDataObjectNames gDOHdl}
        iX       = Data_Object:X
        iStartY  = cSDOLabel:Y + cSDOLabel:HEIGHT-P + 1
        iY       = iStartY.
      IF NUM-ENTRIES(cSDOList) > 0 THEN
      DO:
        DISPLAY cSDOlabel
                cDisplaylabel
                cEnablelabel.
        ASSIGN 
          iHeight  = Data_Object:HEIGHT-P - 1
          iDynArea = FRAME {&FRAME-NAME}:HEIGHT-P - iY - xiHorMargin.
        /* Shrink field height to fit in two columns if necessary
           This ain't pretty, but decent with 20, which is the current 
           max number of SDOs in an SBO, and will 'work' even if that increases
        
        */
        IF INT(NUM-ENTRIES(cSDOList) / 2) * iHeight > iDynArea THEN
        DO:
          iHeight = INT (iDynArea / INT(NUM-ENTRIES(cSDOList) / 2) - 0.4999).
        END.

      END.
      DO i  = 1 TO NUM-ENTRIES(cSDOLIST):
        
        /* Not enough room for the field start on 2nd column 
           Substract 1 pixels for starting point */
        IF iY + iHeight + xiHorMargin - 1 > FRAME {&FRAME-NAME}:HEIGHT-P THEN
        DO:
          ASSIGN iX   = iX + ttDataObject.hUpdateTarget:X + 20
                 iY  = iStartY.
          DISPLAY cSDOlabel-2
                  cDisplaylabel-2
                  cEnablelabel-2.
        END.

        CREATE ttDataObject.

        ASSIGN
          ttDataObject.DoName = ENTRY(i,cSDOLIST).
        
        CREATE FILL-IN ttDataObject.hName 
          ASSIGN 
            FRAME = FRAME {&FRAME-NAME}:HANDLE
            Y  = iY  
            X   = iX
            HEIGHT-P = iHeight
            SENSITIVE = TRUE
            READ-ONLY = TRUE
            HIDDEN   = TRUE
            SCREEN-VALUE = ttDataObject.DoName.
        
        CREATE TOGGLE-BOX ttDataObject.hDataSource 
          ASSIGN 
            FRAME = FRAME {&FRAME-NAME}:HANDLE
            Y   = ttDataObject.hName:Y
            X   = ttDataObject.hName:X + ttDataObject.hName:WIDTH-P + xiToggleSpace
            HEIGHT-P = iHeight
            SENSITIVE = TRUE
            HIDDEN   = TRUE
                       /* cDisp = ? if first time */
            CHECKED  = IF cDisp = ? THEN TRUE
                       ELSE CAN-DO(cDisp,ttDataObject.DoName)
           TRIGGERS: 
             ON VALUE-CHANGED PERSISTENT 
               RUN changeDataSource IN THIS-PROCEDURE (ttDataObject.DoName).
           END.

           hSDO = {fnarg DataObjectHandle ttdataObject.DOName gDOHdl} NO-ERROR.
          {get UpdateFromSource lOneToOne hSDO} NO-ERROR.

         CREATE toggle-box ttDataObject.hUpdateTarget 
          ASSIGN 
            FRAME = FRAME {&FRAME-NAME}:HANDLE
            Y   = ttDataObject.hName:Y
            X   = ttDataObject.hDataSource:X + ttDataObject.hDataSource:WIDTH-P
            HEIGHT-P  = iHeight
            SENSITIVE = NOT (lOneTOOne = TRUE)
            HIDDEN   = TRUE                       
            CHECKED  = IF cUpd = ? THEN FALSE
                       ELSE CAN-DO(cUpd,ttDataObject.DoName)  
            TRIGGERS: 
               ON VALUE-CHANGED PERSISTENT 
                  RUN changeUpdateTarget IN THIS-PROCEDURE (ttDataObject.DoName).
            END.
            
        iY  = iY + iHeight.

      END.
      viewDataObjectList().
    END.
    ELSE initSDO().

  END.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSDO C-Win 
FUNCTION initSDO RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  init the screen for an SDO, (no dataobjectlist or labels) 
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      cSDOlabel:HIDDEN = TRUE
      cDisplaylabel:HIDDEN = TRUE
      cEnablelabel:HIDDEN = TRUE
      cSDOlabel-2:HIDDEN = TRUE
      cDisplaylabel-2:HIDDEN = TRUE
      cEnablelabel-2:HIDDEN = TRUE
      rRect:HEIGHT-P = b_brws:Y + b_brws:HEIGHT-P
                     + xiHorMargin
                     - rRect:Y.
  END.
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeObjectsFromList C-Win 
FUNCTION removeObjectsFromList RETURNS LOGICAL
  (pcObjectList AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Remove deselected objects fom shared fld-list  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFld      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewList  AS CHARACTER  NO-UNDO.
    
  DO i = 1 TO NUM-ENTRIES(fld-list):
    cFld = ENTRY(i,fld-list).
    /* Build new list for objects not passed in */
    IF LOOKUP(ENTRY(1,cFld,'.':U),pcObjectList) = 0 THEN
    DO:
      cNewList = cNewList 
                 + (IF cNewList <> '':U THEN ',':U ELSE '':U)
                 + cFld.
    END.
  END.
  
  fld-list = cNewList.

  IF fld-list = '':U THEN
     APPLY "U2":U TO hWizard. /* not ok to finish */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetDataSource C-Win 
FUNCTION resetDataSource RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Called from value-changed or choose to reset data when the datasource
          has changed 
    Notes:  
------------------------------------------------------------------------------*/
  Fld-list = '':U.
  setDataSourceNames(?).
  setUpdateTargetNames(?).
  initDataObject(Data_Object).
  APPLY "U2":U TO hWizard. /* not ok to finish */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeDataObjectList C-Win 
FUNCTION storeDataObjectList RETURNS LOGICAL
  ( plCheck AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Store and check data for dataobject links 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRemoved AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpd     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAnswer  AS LOGICAL    NO-UNDO.
  
  FOR EACH ttDataObject:
    lSBO = TRUE.
    IF ttDataObject.hDataSource:CHECKED THEN
        cDisp = cDisp 
                + (IF cDisp = '':U THEN '':U ELSE ',':U)     
                + ttDataObject.DOName.
    /* Check if objects in fields list have become unchecked */
    ELSE IF INDEX(fld-list,ttDataObject.DOName + '.':U) > 0 THEN
    DO:
      cRemoved = cRemoved 
              + (IF cRemoved = '':U THEN '':U ELSE ',':U)     
              + ttDataObject.DOName.
    END.

    IF ttDataObject.hUpdateTarget:CHECKED THEN
                cUpd = cUpd 
                + (IF cUpd = '':U THEN '':U ELSE ',':U)     
                + ttDataObject.DOName.
    
  END.

  IF plCheck AND lSBO THEN 
  DO:
    IF cDisp = '':U  THEN
    DO:
      MESSAGE "At least one Data Object must be checked as the Display Data Source."
         VIEW-AS ALERT-BOX  INFORMATION.
    
      RETURN FALSE.
    END.
    IF cRemoved <> '':U THEN
    DO:
      lanswer = YES. 
      MESSAGE 
             "There are fields from "
             
             + REPLACE(cRemoved,",":U,' and ') 
             + " in the list of selected fields." SKIP(1) 
             'Confirm removal of these fields from the list.' 
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lAnswer.
      IF lAnswer THEN removeObjectsFromList(cRemoved).
      ELSE RETURN FALSE.
    END.
  END.
  setUpdateTargetNames(IF lSBO THEN cUpd ELSE ?).
  setDataSourceNames(IF lSBO THEN cDisp ELSE ?).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewDataObjectList C-Win 
FUNCTION viewDataObjectList RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: View the widgets used to update dataobject links and adjust the 
           rectangle height.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iMaxY AS INT    NO-UNDO.
  FOR EACH ttDataObject:
    ttDataObject.hName:HIDDEN = FALSE NO-ERROR.
    ttDataObject.hDataSource :HIDDEN = FALSE NO-ERROR.
    ttDataObject.hUpdateTarget:HIDDEN = FALSE NO-ERROR.
    iMaxY = MAX(ttDataObject.hName:Y + ttDataObject.hName:HEIGHT-P,iMaxY).
  END.
  DO WITH FRAME {&FRAME-NAME}:
    rRect:HEIGHT-P = iMaxY + xiHorMargin - rRect:Y NO-ERROR. 
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

