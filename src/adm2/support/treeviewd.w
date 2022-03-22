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

  File: treeviewd.w 

  Description: Dialog for getting settable attributes for a 
               SmartTreeView.

  Input Parameters:
     phSmrtObj -- Procedure Handle of calling SmartTreeView.

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE WIN95-Btn YES 
/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }  

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER phSmrtObj AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 flnIndent cboLabel cboLine ~
cbTreeStyle tgShowCheckBoxes fiImageHeight fiImageWidth tgSort ~
tgHideSelection tglexpand tgldrag tglfull tgldrop tglsingle tglscroll buOK ~
buCancel 
&Scoped-Define DISPLAYED-OBJECTS flnIndent cboLabel cboLine cbTreeStyle ~
tgShowCheckBoxes fiImageHeight fiImageWidth tgSort tgHideSelection ~
tglexpand tgldrag tglfull tgldrop tglsingle tglscroll 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cboLabel AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "LabelEdit" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0 - Automatic",0,
                     "1 - Manual",1
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE cboLine AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "LineStyle" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0 - TreeLines",0,
                     "1 - TreeLines & RootLines",1
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE cbTreeStyle AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Tree Style" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEM-PAIRS "Text only",0,
                     "Image & text",1,
                     "Plus/minus and text",2,
                     "Plus/minus; image & text",3,
                     "Text only with tree lines",4,
                     "Image & text with tree lines",5,
                     "Text only with tree lines & plus/minus",6,
                     "Image & text with tree lines & plus/minus",7
     DROP-DOWN-LIST
     SIZE 68 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageHeight AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Image Height" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE fiImageWidth AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Image Width" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE flnIndent AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Indentation" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 8.57.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.48.

DEFINE VARIABLE tgHideSelection AS LOGICAL INITIAL no 
     LABEL "Hide Selection" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE tgldrag AS LOGICAL INITIAL no 
     LABEL "OLE Drag" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE tgldrop AS LOGICAL INITIAL no 
     LABEL "OLE Drop" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE tglexpand AS LOGICAL INITIAL no 
     LABEL "Expand On Add" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tglfull AS LOGICAL INITIAL no 
     LABEL "Full Row Select" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE tglscroll AS LOGICAL INITIAL no 
     LABEL "Scroll" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE tglsingle AS LOGICAL INITIAL no 
     LABEL "Single Select" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .95 NO-UNDO.

DEFINE VARIABLE tgShowCheckBoxes AS LOGICAL INITIAL no 
     LABEL "Show Check Boxes" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE tgSort AS LOGICAL INITIAL no 
     LABEL "Sort Automatically" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     flnIndent AT ROW 1.95 COL 17.6 COLON-ALIGNED
     cboLabel AT ROW 3.05 COL 17.6 COLON-ALIGNED
     cboLine AT ROW 4.14 COL 17.6 COLON-ALIGNED
     cbTreeStyle AT ROW 5.29 COL 17.6 COLON-ALIGNED
     tgShowCheckBoxes AT ROW 6.48 COL 19.6
     fiImageHeight AT ROW 7.33 COL 17.6 COLON-ALIGNED
     fiImageWidth AT ROW 8.43 COL 17.6 COLON-ALIGNED
     tgSort AT ROW 11.24 COL 6
     tgHideSelection AT ROW 11.24 COL 35
     tglexpand AT ROW 12.14 COL 5.8
     tgldrag AT ROW 12.14 COL 35
     tglfull AT ROW 13.05 COL 5.8
     tgldrop AT ROW 13.05 COL 35
     tglsingle AT ROW 13.91 COL 5.8
     tglscroll AT ROW 13.91 COL 35.2
     buOK AT ROW 15.43 COL 3.2
     buCancel AT ROW 15.43 COL 18.8
     "Behaviour" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 10.33 COL 4.2
     "Appearance" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.14 COL 4.2
     RECT-1 AT ROW 1.57 COL 3
     RECT-2 AT ROW 10.71 COL 3
     SPACE(2.79) SKIP(1.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartTreeView Properties":L
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

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
ON GO OF FRAME Attribute-Dlg /* SmartTreeView Properties */
DO:
  /* Put the properties back into the SmartTreeView. */

  DYNAMIC-FUNC('setAutoSort':U        IN phSmrtObj, tgSort:CHECKED).
  DYNAMIC-FUNC('setHideSelection':U   IN phSmrtObj, tgHideSelection:CHECKED).
  DYNAMIC-FUNC('setImageHeight':U     IN phSmrtObj, (INPUT fiImageHeight)).
  DYNAMIC-FUNC('setImageWidth':U      IN phSmrtObj, (INPUT fiImageWidth)).
  DYNAMIC-FUNC('setShowCheckBoxes':U  IN phSmrtObj, tgShowCheckBoxes:CHECKED).
  DYNAMIC-FUNC('setTreeStyle':U       IN phSmrtObj, cbTreeStyle:SCREEN-VALUE).

  DYNAMIC-FUNC('setExpandOnAdd':U     IN phSmrtObj, tglExpand:CHECKED).
  DYNAMIC-FUNC('setFullRowSelect':U   IN phSmrtObj, tglfull:CHECKED).
  DYNAMIC-FUNC('setIndentation':U     IN phSmrtObj, INTEGER(flnIndent:SCREEN-VALUE)).
  DYNAMIC-FUNC('setLabelEdit':U       IN phSmrtObj, INTEGER(cboLabel:SCREEN-VALUE)).
  DYNAMIC-FUNC('setLineStyle':U       IN phSmrtObj, INTEGER(cboLine:SCREEN-VALUE)).
  DYNAMIC-FUNC('setOLEDrag':U         IN phSmrtObj, tglDrag:CHECKED).
  DYNAMIC-FUNC('setOLEDrop':U         IN phSmrtObj, tglDrop:CHECKED).
  DYNAMIC-FUNC('setScroll':U          IN phSmrtObj, tglScroll:CHECKED).
  DYNAMIC-FUNC('setSingleSel':U       IN phSmrtObj, tglSingle:CHECKED).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON HELP OF FRAME Attribute-Dlg /* SmartTreeView Properties */
OR HELP OF FRAME {&FRAME-NAME}
DO: 

/* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("AB":U, "CONTEXT":U, {&SmTreeView_Instance_Properties_Dialog_Box}  , "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartTreeView Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbTreeStyle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbTreeStyle Attribute-Dlg
ON VALUE-CHANGED OF cbTreeStyle IN FRAME Attribute-Dlg /* Tree Style */
DO:
  DEFINE VARIABLE iStyleNo AS INTEGER NO-UNDO.

  /* The root lines property only has an effect if the TreeView
   * is showing TreeLines. */

  iStyleNo = INPUT cbTreeStyle.

 IF iStyleNo MODULO 2 = 1 THEN
    ASSIGN fiImageHeight:SENSITIVE = TRUE
           fiImageWidth:SENSITIVE  = TRUE.
  ELSE
    ASSIGN fiImageHeight:SENSITIVE = FALSE
           fiImageWidth:SENSITIVE  = FALSE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* ************************ Standard Setup **************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  /* Get the values of the attributes in the SmartTreeView that can be 
   * changed in this dialog-box. */
  RUN fetchSmartObjectAttributes.

  /* Enable the interface. */         
  RUN enable_UI.

  APPLY 'value-changed':U TO cbTreeStyle.

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
  DISPLAY flnIndent cboLabel cboLine cbTreeStyle tgShowCheckBoxes fiImageHeight 
          fiImageWidth tgSort tgHideSelection tglexpand tgldrag tglfull tgldrop 
          tglsingle tglscroll 
      WITH FRAME Attribute-Dlg.
  ENABLE RECT-1 RECT-2 flnIndent cboLabel cboLine cbTreeStyle tgShowCheckBoxes 
         fiImageHeight fiImageWidth tgSort tgHideSelection tglexpand tgldrag 
         tglfull tgldrop tglsingle tglscroll buOK buCancel 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchSmartObjectAttributes Attribute-Dlg 
PROCEDURE fetchSmartObjectAttributes :
/*------------------------------------------------------------------------------
 Requests the current setting for the SmartTreeView properties and sets the
 widgets on the screen accordingly.
------------------------------------------------------------------------------*/
 
  ASSIGN tgHideSelection  = DYNAMIC-FUNC('getHideSelection':U  IN phSmrtObj)
         fiImageHeight    = DYNAMIC-FUNC('getImageHeight':U    IN phSmrtObj)
         fiImageWidth     = DYNAMIC-FUNC('getImageWidth':U     IN phSmrtObj) 
         tgShowCheckBoxes = DYNAMIC-FUNC('getShowCheckBoxes':U IN phSmrtObj)
         tgSort           = DYNAMIC-FUNC('getAutoSort':U       IN phSmrtObj)
         cbTreeStyle      = DYNAMIC-FUNC('getTreeStyle':U      IN phSmrtObj)
         tglExpand        = DYNAMIC-FUNC('getExpandOnAdd':U    IN phSmrtObj)
         tglFull          = DYNAMIC-FUNC('getFullRowSelect':U  IN phSmrtObj)
         tglDrag          = DYNAMIC-FUNC('getOLEDrag':U        IN phSmrtObj)
         tglDrop          = DYNAMIC-FUNC('getOLEDrop':U        IN phSmrtObj)
         tglScroll        = DYNAMIC-FUNC('getScroll':U         IN phSmrtObj)
         tglSingle        = DYNAMIC-FUNC('getSingleSel':U      IN phSmrtObj)
         flnIndent        = DYNAMIC-FUNC('getIndentation':U    IN phSmrtObj)
         cboLabel         = DYNAMIC-FUNC('getLabelEdit':U      IN phSmrtObj)
         cboLine          = DYNAMIC-FUNC('getLineStyle':U      IN phSmrtObj)
         NO-ERROR.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

