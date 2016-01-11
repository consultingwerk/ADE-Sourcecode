&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:        _clasnew.w

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:      xbonnamy
  
  Notes:       - References 3 SmartFrames: fclasnewbasic.w ,fclasnewcustom.w
                 and fclasnewstatus.w
               Dialog to create a new ADM Class
               
               - Coded a workaround for bug# 99-05-17-005 in the ENTRY event
               of this SmartDialog
                

  Created: 05/1999
  Modified: 06/03/99 xbonnamy - Removed page 3 (adeuib/fclasnewstatus.w)  
            07/06/99 xbonnamy - Changed SmartFrames file name to have a '_'
                                like all uib files
            11/08/99 tomn     - Changed references from "ADM2" to "ADM"
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
     
/* Don't uncomment that - It has to be commented to avoid files opened
   to be parented to this SmartDialog */
/*CREATE WIDGET-POOL.*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&GLOBAL-DEFINE WIN95-BTN  YES

  {adecomm/adestds.i}        /* Standared ADE Preprocessor Directives     */
  IF NOT initialized_adestds
  THEN RUN adecomm/_adeload.p.

  { adeuib/uibhlp.i }          /* Help File Preprocessor Directives       */


  /* Check to see first if AppBuilder is Running, if not Return */
  RUN isABRunning.
  IF RETURN-VALUE = "ERROR":U THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS lReplace 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToggleEnable gDialog 
FUNCTION setToggleEnable RETURNS LOGICAL
  ( INPUT plEnable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_fclasnewbasic AS HANDLE NO-UNDO.
DEFINE VARIABLE h_fclasnewcustom AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE lReplace AS LOGICAL INITIAL no 
     LABEL "Replace e&xisting files if exist" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     lReplace AT ROW 17.48 COL 7.6
     SPACE(27.39) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New ADM Class".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Design Page: 1
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX lReplace IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ALT-B OF FRAME gDialog /* New ADM Class */
ANYWHERE DO:
    RUN selectPage (1).                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ALT-C OF FRAME gDialog /* New ADM Class */
ANYWHERE DO:
    RUN selectPage (2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON ENTRY OF FRAME gDialog /* New ADM Class */
DO:
    /* Workaround for bug 99-05-17-005 */
    IF VALID-HANDLE(FOCUS) THEN DO:
      /* Make sure disable-auto-zap can be used */
      IF CAN-QUERY(FOCUS, "DISABLE-AUTO-ZAP":U) THEN FOCUS:DISABLE-AUTO-ZAP = TRUE.
      APPLY "ENTRY":U TO FOCUS.
      IF CAN-QUERY(FOCUS, "DISABLE-AUTO-ZAP":U) THEN FOCUS:DISABLE-AUTO-ZAP = FALSE.      
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON GO OF FRAME gDialog /* New ADM Class */
DO:
  /* Make sure information is correct */
  RUN screenValidation IN h_fclasnewbasic.
  IF RETURN-VALUE = "ERROR":U THEN RETURN NO-APPLY.
  
  /* Generate files */
  RUN generateFiles IN h_fclasnewbasic.
  IF RETURN-VALUE = "ERROR":U THEN RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON HELP OF FRAME gDialog /* New ADM Class */
DO:
    RUN adecomm/_adehelp.p
      (INPUT "AB":U, 
       INPUT "CONTEXT":U, 
       INPUT {&New_ADM_2_Class_Dialog_Box}, 
       INPUT  ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* New ADM Class */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lReplace gDialog
ON VALUE-CHANGED OF lReplace IN FRAME gDialog /* Replace existing files if exist */
DO:
  DYNAMIC-FUNCTION('setReplace':U IN h_fclasnewbasic, INPUT SELF:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&New_ADM_2_Class_Dialog_Box} }


{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/folder.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'FolderLabels':U + '&Basic|&Custom Files' + 'FolderTabType1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.00 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 16.43 , 78.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_fclasnewbasic.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_fclasnewbasic ).
       RUN repositionObject IN h_fclasnewbasic ( 2.43 , 6.00 ) NO-ERROR.
       /* Size in AB:  ( 14.76 , 68.20 ) */

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'adeuib/_fclasnewcustom.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_fclasnewcustom ).
       RUN repositionObject IN h_fclasnewcustom ( 5.05 , 6.00 ) NO-ERROR.
       /* Size in AB:  ( 8.43 , 70.40 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('1') NO-ERROR.

       /* Links to SmartFrame h_fclasnewcustom. */
       RUN addLink ( h_fclasnewbasic , 'Names':U , h_fclasnewcustom ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage gDialog 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  /* Be sure the cursor is back on the page */
  IF DYNAMIC-FUNCTION('getCurrentPage':U) = 1 THEN
    RUN applyEntry IN h_fclasnewbasic (?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY lReplace 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrameBasic    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hFrame         AS HANDLE   NO-UNDO.
    
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Initialize all pages so that all the objects may communicate */
  RUN initPages (INPUT "2,3":U).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* This trick serves to place the focus on the first enable field
     in the SmartFrame on page 1. Using Run applyEntry IN h_('cName') doesn't work */
  ASSIGN
    hFrameBasic = DYNAMIC-FUNCTION('getContainerHandle':U IN h_fclasnewbasic) /* SmartFrame on page 1 */
    hFrame      = DYNAMIC-FUNCTION('getContainerHandle':U) /* Current conatiner */
    hFrame      = hFrame:CURRENT-ITERATION
    hFrame:FIRST-TAB-ITEM = hFrameBasic
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isABRunning gDialog 
PROCEDURE isABRunning :
/*------------------------------------------------------------------------------
  Purpose:     Check to see if AppBuilder is running
               Necessary when people want to open files in the AppBuilder after
               generation
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLevel          AS INTEGER NO-UNDO INITIAL 1. 
  DEFINE VARIABLE lABRunning      AS LOGICAL NO-UNDO INITIAL NO.

  REPEAT WHILE PROGRAM-NAME(iLevel) <> ?.
    IF PROGRAM-NAME(iLevel) = "adeuib/_uibmain.p" THEN lABRunning = TRUE.
    ASSIGN iLevel = iLevel + 1.
  END.
  IF NOT lABRunning THEN DO:
    MESSAGE
      "The AppBuilder is not running. You must start the AppBuilder before running the New ADM Class tool."
      VIEW-AS ALERT-BOX ERROR.
    RETURN "ERROR":U.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToggleEnable gDialog 
FUNCTION setToggleEnable RETURNS LOGICAL
  ( INPUT plEnable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Invoked from fclasnewbasic.w
    Notes:  
------------------------------------------------------------------------------*/
  lReplace:SENSITIVE IN FRAME {&FRAME-NAME} = plEnable.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

