&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
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

  File: dynbrowserd.w 

  Description: Instance Properties Dialog for Dynamic SmartDataBrowser.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  Modified: July 1, 1999, Version 9.1A
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
  DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
  DEFINE VARIABLE attr-list         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE orig-layout       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gcDisplayedFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gcEnabledFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ghDataSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE ghSDO             AS HANDLE    NO-UNDO.

&SCOPED-DEFINE NoValue '<none>':U 
/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l_Enable l_View l_calcWidth i_numdown ~
l_ScrollRemote l_FetchOnReposToEnd 
&Scoped-Define DISPLAYED-OBJECTS c_SDOList c_SearchField l_Enable l_View ~
l_calcWidth c_Layout i_numdown i_maxWidth l_ScrollRemote ~
l_FetchOnReposToEnd 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Attribute-Dlg 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateSearchField Attribute-Dlg 
FUNCTION populateSearchField RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Displayed-Btn 
     LABEL "Edit &Displayed field list" 
     SIZE 25 BY 1.14.

DEFINE BUTTON Enabled-Btn 
     LABEL "Edit E&nabled field list" 
     SIZE 25 BY 1.14.

DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE c_SDOList AS CHARACTER FORMAT "X(256)":U 
     LABEL "SmartDataObject" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c_SearchField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Search Field" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE i_maxWidth AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "&Max Width" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE i_numdown AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Do&wn" 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1 NO-UNDO.

DEFINE VARIABLE l_calcWidth AS LOGICAL INITIAL no 
     LABEL "&Calculate Width" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.2 BY .86 NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .86 NO-UNDO.

DEFINE VARIABLE l_FetchOnReposToEnd AS LOGICAL INITIAL no 
     LABEL "&Fetch Data to Fill Browse on Reposition to End of Batch" 
     VIEW-AS TOGGLE-BOX
     SIZE 58.6 BY .86 NO-UNDO.

DEFINE VARIABLE l_ScrollRemote AS LOGICAL INITIAL no 
     LABEL "&Scroll Remote Results List" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.2 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_SDOList AT ROW 2.67 COL 33.2 COLON-ALIGNED
     Displayed-Btn AT ROW 4.33 COL 3
     Enabled-Btn AT ROW 5.76 COL 3
     c_SearchField AT ROW 8.14 COL 4
     l_Enable AT ROW 10.52 COL 2.8
     l_View AT ROW 11.71 COL 2.8
     l_calcWidth AT ROW 12.91 COL 2.8
     c_Layout AT ROW 10.43 COL 33.2 COLON-ALIGNED
     i_numdown AT ROW 11.62 COL 33.2 COLON-ALIGNED
     i_maxWidth AT ROW 12.81 COL 33.2 COLON-ALIGNED
     l_ScrollRemote AT ROW 14.05 COL 2.8
     l_FetchOnReposToEnd AT ROW 15.1 COL 2.8
     "  Behavior During 'Initialize'" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 9.57 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  (Default is all fields)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 4.57 COL 30
     "  (Default is all Updatable fields)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 6 COL 30
     "  SmartDataObject fields to display and enable" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 1.24 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  Allow Reposition using a Search Field" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 7.19 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.19) SKIP(8.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Dynamic SmartDataBrowser Properties":L.


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

/* SETTINGS FOR COMBO-BOX c_Layout IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c_SDOList IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c_SearchField IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR BUTTON Displayed-Btn IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Enabled-Btn IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i_maxWidth IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
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
ON GO OF FRAME Attribute-Dlg /* Dynamic SmartDataBrowser Properties */
DO:     
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
     
   /* Reassign the attribute values back in the SmartObject. */
  ASSIGN l_Enable l_View c_SearchField l_ScrollRemote l_FetchOnReposToEnd
         c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE
         i_NumDown l_CalcWidth i_MaxWidth.
         
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, INPUT NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, INPUT NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setDisplayedFields":U IN p_hSMO, INPUT gcDisplayedFields) NO-ERROR.
  DYNAMIC-FUNC("setScrollRemote":U IN p_hSMO, INPUT l_ScrollRemote) NO-ERROR.
  DYNAMIC-FUNC("setEnabledFields":U IN p_hSMO, INPUT gcEnabledFields) NO-ERROR.
  DYNAMIC-FUNC("setFetchOnReposToEnd":U IN p_hSMO,l_FetchOnReposToEnd) NO-ERROR.

  cObjectName = DYNAMIC-FUNCTION('getObjectName' IN ghSDO) NO-ERROR.
  
  DYNAMIC-FUNC("setDataSourceNames":U IN p_hSMO,cObjectName) NO-ERROR. 
  
  IF gcEnabledFields <> '':U THEN
    IF {fn getObjectType ghSDO} = "SmartBusinessObject":U THEN
      DYNAMIC-FUNC("setUpdateTargetNames":U IN p_hSMO,cObjectName) NO-ERROR.

  DYNAMIC-FUNC("setSearchField":U IN p_hSMO, 
    IF c_SearchField = "<none>":U THEN "":U ELSE c_SearchField) NO-ERROR.

  /* Only set the layout if it has changed.  Remember that LAYOUT is an
     attribute whose changes must be explicitly applied. */
  IF c_Layout:SENSITIVE AND c_Layout ne orig-layout THEN DO:
    IF c_Layout eq "{&no-layout}":U THEN c_Layout = "":U.
    DYNAMIC-FUNC("setObjectLayout":U IN p_hSMO, INPUT c_Layout) NO-ERROR.
    RUN applyLayout IN p_hSMO.
  END.

  DYNAMIC-FUNC("setNumDown":U IN p_hSMO, INPUT i_NumDown) NO-ERROR.
  DYNAMIC-FUNC("setCalcWidth":U IN p_hSMO, INPUT l_CalcWidth) NO-ERROR.
  DYNAMIC-FUNC("setMaxWidth":U IN p_hSMO, INPUT i_MaxWidth) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* Dynamic SmartDataBrowser Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_SDOList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_SDOList Attribute-Dlg
ON VALUE-CHANGED OF c_SDOList IN FRAME Attribute-Dlg /* SmartDataObject */
DO:
  ASSIGN c_SDOList.
  /* Assign the handle of the SDO they chose and allow field picking. */
  ASSIGN ghSDO = WIDGET-HANDLE(c_SDOList) NO-ERROR.
  ASSIGN           
     Displayed-Btn:SENSITIVE = VALID-HANDLE(ghSDO)
     Enabled-btn:SENSITIVE   = VALID-HANDLE(ghSDO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Displayed-Btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Displayed-Btn Attribute-Dlg
ON CHOOSE OF Displayed-Btn IN FRAME Attribute-Dlg /* Edit Displayed field list */
DO:
  DEFINE VARIABLE iEntry     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(ghSDO) THEN    
  DO:
    RUN adecomm/_mfldsel.p
     (INPUT "":U,     /* Use an SDO, not db tables */
      INPUT ghSDO,     /* handle of the SDO */
      INPUT ?,        /* No additional temp-tables */
      INPUT "1":U,    /* No db or table name qualification of fields */
      INPUT ",":U,    /* list delimiter */
      INPUT "":U,     /* exclude field list */
      INPUT-OUTPUT gcDisplayedFields).
    /* If any fields were removed from the display list, then we need to make
       sure they are no longer in the enable list. */
    IF gcEnabledFields NE "":U THEN
    DO:
      gcEnabledFields = ",":U + gcEnabledFields + ",":U.  /* Allow removal from list. */
      DO iEntry = 1 TO NUM-ENTRIES(gcEnabledFields):
        cField = ENTRY(iEntry, gcEnabledFields).
        IF LOOKUP(cField, gcDisplayedFields) = 0 THEN
          gcEnabledFields = REPLACE(gcEnabledFields, ",":U + cField + ",":U, ",":U).
      END.   /* END DO iEntry */
      gcEnabledFields = SUBSTR(gcEnabledFields, 2, LENGTH(gcEnabledFields) - 2).
    END.     /* END DO IF gcEnabledFields */
    populateSearchField().
    c_SDOList:SENSITIVE = gcEnabledFields = '':U AND gcDisplayedFields = '':U
                          AND
                          ghSDO <> ghDataSource.
  END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Enabled-Btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Enabled-Btn Attribute-Dlg
ON CHOOSE OF Enabled-Btn IN FRAME Attribute-Dlg /* Edit Enabled field list */
DO:
    DEFINE VARIABLE cUpdatable AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cExclude   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDataCols  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iEntry     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(ghSDO) THEN    
  DO:
    {get UpdatableColumns cUpdatable ghSDO}.
    {get DataColumns cDataCols ghSDO}.
    
    /* We need to exclude from the permissible EnableFields list anything
       that either isn't in the UpdatableColumns of the SDO or isn't in
       the DisplayedFields list for the browser. */
    DO iEntry = 1 TO NUM-ENTRIES(cDataCols):
      cField = ENTRY(iEntry, cDataCols).
      IF LOOKUP(cField, cUpdatable) = 0 OR
        (gcDisplayedFields NE "":U AND LOOKUP(cField, gcDisplayedFields) = 0) 
      THEN
        cExclude = cExclude + (IF cExclude NE "":U THEN ",":U ELSE "":U) +
          cField.
    END.    /* END DO iEntry */
    
    RUN adecomm/_mfldsel.p
     (INPUT "":U,     /* Use an SDO, not db tables */
      INPUT ghSDO,     /* handle of the SDO */
      INPUT ?,        /* No additional temp-tables */
      INPUT "1":U,    /* No db or table name qualification of fields */
      INPUT ",":U,    /* list delimiter */
      INPUT cExclude, /* exclude field list */
      INPUT-OUTPUT gcEnabledFields).

    c_SDOList:SENSITIVE = gcEnabledFields = '':U AND gcDisplayedFields = '':U
                           AND
                           ghSDO <> ghDataSource.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_calcWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_calcWidth Attribute-Dlg
ON VALUE-CHANGED OF l_calcWidth IN FRAME Attribute-Dlg /* Calculate Width */
DO:
  ASSIGN l_CalcWidth.
  i_MaxWidth:SENSITIVE = l_CalcWidth. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_FetchOnReposToEnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_FetchOnReposToEnd Attribute-Dlg
ON VALUE-CHANGED OF l_FetchOnReposToEnd IN FRAME Attribute-Dlg /* Fetch Data to Fill Browse on Reposition to End of Batch */
DO:
  ASSIGN l_ScrollRemote.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_ScrollRemote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_ScrollRemote Attribute-Dlg
ON VALUE-CHANGED OF l_ScrollRemote IN FRAME Attribute-Dlg /* Scroll Remote Results List */
DO:
  ASSIGN l_ScrollRemote.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&Dynamic_SmDataBrowser_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignBrowseQueryObject Attribute-Dlg 
PROCEDURE assignBrowseQueryObject :
/*------------------------------------------------------------------------------
  Purpose:     Tells the Dialog which SDO matches a predefined Displayed fields
               list, so that the Dialog can assign that SDO's ObjectName.
  Parameters:  INPUT hBrowseQueryObject -- handle of the SDO
  Notes:       This is run in getDataHandle in the sbo to respond to the Dialog.
               This is now only used if DataSourceNames is not set.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hBrowseQueryObject AS HANDLE NO-UNDO.

  DEFINE VARIABLE cSDOName AS CHARACTER NO-UNDO.
 
  {get ObjectName cSDOName hBrowseQueryObject}.
  ASSIGN c_SDOList:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = 
                cSDOName + ",":U + STRING(hBrowseQueryObject)
         c_SDOList:INNER-LINES = 1
         c_SDOList =  STRING(hBrowseQueryObject)
         c_SDOList:SCREEN-VALUE = c_SDOList
         ghSDO = hBrowseQueryObject.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY c_SDOList c_SearchField l_Enable l_View l_calcWidth c_Layout i_numdown 
          i_maxWidth l_ScrollRemote l_FetchOnReposToEnd 
      WITH FRAME Attribute-Dlg.
  ENABLE l_Enable l_View l_calcWidth i_numdown l_ScrollRemote 
         l_FetchOnReposToEnd 
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
  DEFINE VARIABLE lDummy      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContext    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDO        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargets    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTarget     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hTarget     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHAR      NO-UNDO.
  DEFINE VARIABLE cSourceName AS CHAR      NO-UNDO.
  DEFINE VARIABLE cListPairs  AS CHAR      NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:   
    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    gcDisplayedFields = DYNAMIC-FUNC("getDisplayedFields":U IN p_hSMO).
    gcEnabledFields = DYNAMIC-FUNC("getEnabledFields":U IN p_hSMO).
    c_SearchField = DYNAMIC-FUNC("getSearchField":U IN p_hSMO).
    c_SearchField =  IF c_SearchField = "":U OR c_SearchField = ? THEN
       "<none>":U ELSE c_SearchField.
    i_NumDown = DYNAMIC-FUNC("getNumDown":U IN p_hSMO).
    l_CalcWidth = DYNAMIC-FUNC("getCalcWidth":U IN p_hSMO).
    i_MaxWidth  = DYNAMIC-FUNC("getMaxWidth":U IN p_hSMO).
    l_ScrollRemote = DYNAMIC-FUNC("getScrollRemote":U IN p_hSMO).
    l_FetchOnReposToEnd = DYNAMIC-FUNC("getFetchOnReposToEnd":U IN p_hSMO).
    cSourceName = DYNAMIC-FUNC("getDataSourceNames":U IN p_hSMO).
    
    /* MaxWidth needs be be enabled if CalcWidth is true */
    IF l_CalcWidth THEN 
        i_MaxWidth:SENSITIVE = TRUE.

    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "").
    
    ASSIGN 
      c_Layout:LIST-ITEMS  = c_Layout
      lDummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).

    /* V8: RUN get-attribute IN p_hSMO ("Layout":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getObjectLayout":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout    = IF c_Layout = ? OR c_Layout = "":U OR
                            c_Layout = "?":U /* Compatibility with ADM1.0 */
                         THEN "{&no-layout}":U 
                         ELSE c_Layout
           orig-layout = c_Layout.
    
    /* Also get the handle of the associated SmartDataObject, if any. */
    RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), "LINK DATA-SOURCE":U, 
      OUTPUT cContext).      /* Returns the Context ID of our Data-Source */
    IF cContext <> '' THEN
      RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
        OUTPUT cSDO).
    
    ghDataSource = WIDGET-HANDLE(cSDO).
    
    /* When trying to run the PropertySheet from the GenericDynamicsPropSheet (af/cod2/afpropwin.p),
       objects are run out of conext and as such, the SDO/SBO for a browser cannot be picked up.
       From afpropwin,p, the only way I could get the handle of the SDO across was to set a UserProperty
       in the Browse that was fired up. This will not break any current functionality and will ensure
       that if it could not locate a DataSource through the AppBuilder context, that it at least manages
       to get it through a UserProperty (Which also would not break anything) */
    IF NOT VALID-HANDLE(ghDataSource) THEN
      ghDataSource = WIDGET-HANDLE({fnarg getUserProperty 'DataSource' p_hSMO}).
    
    cTargets = DYNAMIC-FUNCTION('getContainedDataObjects' IN ghDataSource)
         NO-ERROR.
    IF cTargets = "":U THEN
         /* if it comes back blank, that means the DataSOurce is an SBO but
            hasn't been initialized yet, so do that here so that the list
            of DataObjects will be filled in. If it comes back unknown,
            that means the DataSOurce is an SDO, so don't use the property. */
    DO:
      RUN createObjects IN ghDataSource.
      cTargets = DYNAMIC-FUNCTION('getContainedDataObjects' IN ghDataSource).
    END.    /* END DO IF NO Targets yet */
    
    cListPairs = {&novalue} + ',':U.
     
    /* This is just an SDO, so set that handle which is used elsewhere. */  
    IF cTargets = ? THEN
    DO: 
      ASSIGN
        ghSDO = ghDataSource.
      
      IF VALID-HANDLE(ghSDO) THEN
        ASSIGN
          cObjectName = DYNAMIC-FUNCTION('getObjectName' IN ghSDO)
          cListPairs  = cListPairs +  ",":U 
                        + cObjectName +  ",":U + STRING(ghSDO)
          c_SDOList   = STRING(ghSDO). 
    END. /* cTargets = ? (Linked to an SDO) */
    ELSE 
    DO:
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        ASSIGN
          hTarget     = WIDGET-HANDLE(ENTRY(iTarget, cTargets))
          cObjectName = DYNAMIC-FUNCTION('getObjectName' IN hTarget)
          cListPairs  = cListPairs +  ",":U 
                        + cObjectName +  ",":U + STRING(hTarget).
          
        IF cObjectName = cSourceName THEN 
          ASSIGN
            c_SDOList = STRING(hTarget) 
            ghSDO     = hTarget. 
      END.  /* END DO iTarget */
    END. /* else (sbo)*/

    ASSIGN c_SDOList:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cListpairs
           c_SDOList:INNER-LINES = MAX(5,NUM-ENTRIES(cListPairs) / 2)
           c_SDOList:SCREEN-VALUE = c_SDOList
           c_SDOList:SENSITIVE =  
                     ghSDO <> ghDataSource  /* not sdo */
                     AND /* allow object change  if not fields selected */          
                    ((gcDisplayedFields = '':U AND gcEnabledfields = '':U)
                     OR  /* or no object selected yet */ 
                     NOT VALID-HANDLE(ghSDO)
                     )
           Enabled-Btn:SENSITIVE   = VALID-HANDLE(ghSDO)
           Displayed-Btn:SENSITIVE = VALID-HANDLE(ghSDO).
    
    /* Build list of combo box values unless the Data Object is an SBO. */
    populateSearchField().   
    
  END. /* DO WITH FRAME... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Attribute-Dlg 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  IP Dialog version of this function to return the handle of the
            SDBrowser to the SBO that needs to query its Signature.
    Params: <none>
------------------------------------------------------------------------------*/

  RETURN p_hSMO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateSearchField Attribute-Dlg 
FUNCTION populateSearchField RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  builds the list of values for the SearchField (= DisplayedFields).
    Notes:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE lResult AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
    
    /* Populate the search field only if our data source is an SDO, not an SBO.*/
    IF ghSDO = ghDataSource THEN
    DO:
      IF gcDisplayedFields = "":U THEN
        /* This means no explicit field list has been selected, so the fieldlist
           is in fact *all* SDO fields; so make these available as search fields. */
        cFields = dynamic-function('getDataColumns':U IN ghSDO) NO-ERROR.
      ELSE cFields = gcDisplayedFields.
    
      ASSIGN c_SearchField:LIST-ITEMS In FRAME {&FRAME-NAME} = cFields
             lResult = c_SearchField:ADD-FIRST ("<none>":U)
             c_SearchField:INNER-LINES = MAX(20,NUM-ENTRIES(cFields))
             c_SearchField:SCREEN-VALUE = c_SearchField 
             c_SearchField:SENSITIVE = YES NO-ERROR.
    END.         /* END DO IF DataSOurce = SDO */
    ELSE c_SearchField:SENSITIVE = NO.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

