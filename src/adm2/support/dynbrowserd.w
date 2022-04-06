&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
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

  /*Used in rebuildViewAsProperties to store the view-as property
    values for the old displayed fields.*/
  DEFINE TEMP-TABLE ttViewAsProperties NO-UNDO
    FIELD cField          AS CHARACTER INITIAL ?
    FIELD cType           AS CHARACTER INITIAL ?
    FIELD cDelimiter      AS CHARACTER INITIAL ?
    FIELD cItems          AS CHARACTER INITIAL ?
    FIELD cItemPairs      AS CHARACTER INITIAL ?
    FIELD cInnerLines     AS CHARACTER INITIAL ?
    FIELD cMaxChars       AS CHARACTER INITIAL ?
    FIELD cSort           AS CHARACTER INITIAL ?
    FIELD cAutoCompletion AS CHARACTER INITIAL ?
    FIELD cUniqueMatch    AS CHARACTER INITIAL ?
    INDEX xField AS PRIMARY UNIQUE cField.

&SCOPED-DEFINE NoValue '<none>':U 
/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l_Enable l_View l_calcWidth i_numdown ~
l_ScrollRemote l_FetchOnReposToEnd lUseSortIndicator 
&Scoped-Define DISPLAYED-OBJECTS c_SDOList c_SearchField l_Enable l_View ~
l_calcWidth c_Layout i_numdown i_maxWidth l_ScrollRemote ~
l_FetchOnReposToEnd lUseSortIndicator 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewAsButton Attribute-Dlg 
FUNCTION setViewAsButton RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Displayed-Btn 
     LABEL "Edit &displayed field list..." 
     SIZE 25 BY 1.14.

DEFINE BUTTON Enabled-Btn 
     LABEL "Edit e&nabled field list..." 
     SIZE 25 BY 1.14.

DEFINE BUTTON Viewas-Btn 
     LABEL "View-as" 
     SIZE 13 BY 1.14 TOOLTIP "Browse Column View-as properties".

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
     LABEL "&Max width" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE i_numdown AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Do&wn" 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1 NO-UNDO.

DEFINE VARIABLE lUseSortIndicator AS LOGICAL INITIAL no 
     LABEL "&Show sort indicator" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE l_calcWidth AS LOGICAL INITIAL no 
     LABEL "&Calculate width" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.2 BY .86 NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .86 NO-UNDO.

DEFINE VARIABLE l_FetchOnReposToEnd AS LOGICAL INITIAL no 
     LABEL "&Fetch data to fill browse on reposition to end of batch" 
     VIEW-AS TOGGLE-BOX
     SIZE 58.6 BY .86 NO-UNDO.

DEFINE VARIABLE l_ScrollRemote AS LOGICAL INITIAL no 
     LABEL "&Scroll remote results List" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.2 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     Viewas-Btn AT ROW 4.33 COL 51 WIDGET-ID 2
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
     l_ScrollRemote AT ROW 14.1 COL 2.8
     l_FetchOnReposToEnd AT ROW 15.19 COL 2.8
     lUseSortIndicator AT ROW 16.29 COL 2.8 WIDGET-ID 4
     "  Behavior" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 9.57 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  (Default is all fields)" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 4.57 COL 30
     "  (Default is all updatable fields)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 6 COL 30
     "  SmartDataObject fields to display and enable" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 1.24 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  Allow reposition using a search field" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 7.19 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(0.19) SKIP(9.37)
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
   FRAME-NAME Custom                                                    */
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
/* SETTINGS FOR BUTTON Viewas-Btn IN FRAME Attribute-Dlg
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
  DEFINE VARIABLE cOlddisp         AS CHARACTER  NO-UNDO.

  cOldDisp = DYNAMIC-FUNC("getDisplayedFields":U IN p_hSMO) NO-ERROR.

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
  DYNAMIC-FUNC("setUseSortIndicator":U IN p_hSMO,lUseSortIndicator) NO-ERROR.

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


  /* repaint */
  IF colddisp <> gcDisplayedFields THEN
  DO:
    DYNAMIC-FUNC("destroyBrowse":U IN p_hSMO).
    RUN initializeobject IN p_hsmo.
  END.

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
ON CHOOSE OF Displayed-Btn IN FRAME Attribute-Dlg /* Edit displayed field list... */
DO:
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExclude     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldFields AS CHARACTER   NO-UNDO.

  IF VALID-HANDLE(ghSDO) THEN    
  DO:
    {get DataColumns cDataColumns ghSDO}.
    {get QueryTables cSortTables ghSDO}.
    IF INDEX(cDataColumns,'.':U) > 0 THEN
    DO iEntry = 1 TO NUM-ENTRIES(cDataColumns):
      cField = ENTRY(iEntry, cDataColumns).
      IF LOOKUP(ENTRY(1,cField,'.':U),cSortTables) = 0 THEN
        cExclude = cExclude
                 + (IF cExclude = '' THEN '' ELSE ',')
                 + cField.
    END.   /* END DO iEntry */

    ASSIGN cOldFields = gcDisplayedFields.

    RUN adecomm/_mfldsel.p
     (INPUT "":U,     /* Use an SDO, not db tables */
      INPUT ghSDO,     /* handle of the SDO */
      INPUT ?,        /* No additional temp-tables */
      INPUT "1":U,    /* No db or table name qualification of fields */
      INPUT ",":U,    /* list delimiter */
      INPUT cExclude,     /* exclude field list */
      INPUT-OUTPUT gcDisplayedFields).

    /*Set the sensitive status of the view-as button. If not fields are selected, this
      button cannot be selected*/
    setViewAsButton().
    
    RUN removeLargeObjects(INPUT-OUTPUT gcDisplayedFields).

    /*If this is not the first time that fields are selected (cOldFields ne "") and
      if the displayed field list was modified (cOldFields NE gcDisplayedFields)
      we have to rebuild the view-as property lists.*/
    IF cOldFields NE "" AND cOldFields NE gcDisplayedFields THEN
        RUN rebuildViewAsProperties (INPUT cOldFields).

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
ON CHOOSE OF Enabled-Btn IN FRAME Attribute-Dlg /* Edit enabled field list... */
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

    RUN removeLargeObjects(INPUT-OUTPUT gcEnabledFields).

    c_SDOList:SENSITIVE = gcEnabledFields = '':U AND gcDisplayedFields = '':U
                           AND
                           ghSDO <> ghDataSource.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUseSortIndicator
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUseSortIndicator Attribute-Dlg
ON VALUE-CHANGED OF lUseSortIndicator IN FRAME Attribute-Dlg /* Show sort indicator */
DO:
  ASSIGN lUseSortIndicator.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_calcWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_calcWidth Attribute-Dlg
ON VALUE-CHANGED OF l_calcWidth IN FRAME Attribute-Dlg /* Calculate width */
DO:
  ASSIGN l_CalcWidth.
  i_MaxWidth:SENSITIVE = l_CalcWidth. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_FetchOnReposToEnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_FetchOnReposToEnd Attribute-Dlg
ON VALUE-CHANGED OF l_FetchOnReposToEnd IN FRAME Attribute-Dlg /* Fetch data to fill browse on reposition to end of batch */
DO:
  ASSIGN l_ScrollRemote.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_ScrollRemote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_ScrollRemote Attribute-Dlg
ON VALUE-CHANGED OF l_ScrollRemote IN FRAME Attribute-Dlg /* Scroll remote results List */
DO:
  ASSIGN l_ScrollRemote.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Viewas-Btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Viewas-Btn Attribute-Dlg
ON CHOOSE OF Viewas-Btn IN FRAME Attribute-Dlg /* View-as */
DO:
DEFINE VARIABLE cDataTypes             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldFormats          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnTypes           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnDelimiters      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnItems           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnItemPairs       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnInnerLines      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnMaxChars        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnSorts           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnAutoCompletions AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnUniqueMatches   AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCancel AS LOGICAL     NO-UNDO.

DEFINE VARIABLE iField  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFields AS INTEGER     NO-UNDO.
DEFINE VARIABLE cField  AS CHARACTER   NO-UNDO.

ASSIGN cColumnTypes           = DYNAMIC-FUNCTION('getBrowseColumnTypes':U           IN p_hsmo)
       cColumnDelimiters      = DYNAMIC-FUNCTION('getBrowseColumnDelimiters':U      IN p_hsmo)
       cColumnItems           = DYNAMIC-FUNCTION('getBrowseColumnItems':U           IN p_hsmo)
       cColumnItemPairs       = DYNAMIC-FUNCTION('getBrowseColumnItemPairs':U       IN p_hsmo)
       cColumnInnerLines      = DYNAMIC-FUNCTION('getBrowseColumnInnerLines':U      IN p_hsmo)
       cColumnMaxChars        = DYNAMIC-FUNCTION('getBrowseColumnMaxChars':U        IN p_hsmo)
       cColumnSorts           = DYNAMIC-FUNCTION('getBrowseColumnSorts':U           IN p_hsmo)
       cColumnAutoCompletions = DYNAMIC-FUNCTION('getBrowseColumnAutoCompletions':U IN p_hsmo)
       cColumnUniqueMatches   = DYNAMIC-FUNCTION('getBrowseColumnUniqueMatches':U   IN p_hsmo)
       iFields                = NUM-ENTRIES(gcDisplayedFields).

/*Builds the field format and data-type values*/
DO iField = 1 TO iFields:
    ASSIGN cField        = ENTRY(iField, gcDisplayedFields)
           cFieldFormats = cFieldFormats + DYNAMIC-FUNCTION('columnFormat':U   IN ghDataSource, INPUT cField) + ",":U
           cDataTypes    = cDataTypes    + DYNAMIC-FUNCTION('columnDataType':U IN ghDataSource, INPUT cField) + ",":U.
END.

ASSIGN cFieldFormats = TRIM(cFieldFormats, ",":U)
       cDataTypes    = TRIM(cDataTypes,    ",":U).

RUN adecomm/_viewasd.w (INPUT gcDisplayedFields,
                        INPUT cDataTypes,
                        INPUT cFieldFormats,
                        INPUT "SmartDataBrowser":U,
                        INPUT-OUTPUT cColumnTypes,
                        INPUT-OUTPUT cColumnDelimiters,
                        INPUT-OUTPUT cColumnItems,
                        INPUT-OUTPUT cColumnItemPairs,
                        INPUT-OUTPUT cColumnInnerLines,
                        INPUT-OUTPUT cColumnMaxChars,
                        INPUT-OUTPUT cColumnSorts,
                        INPUT-OUTPUT cColumnAutoCompletions,
                        INPUT-OUTPUT cColumnUniqueMatches,
                        OUTPUT cCancel).

IF cCancel THEN RETURN NO-APPLY.

DYNAMIC-FUNCTION('setBrowseColumnTypes':U           IN p_hsmo, INPUT cColumnTypes).
DYNAMIC-FUNCTION('setBrowseColumnDelimiters':U      IN p_hsmo, INPUT cColumnDelimiters).
DYNAMIC-FUNCTION('setBrowseColumnItems':U           IN p_hsmo, INPUT REPLACE(cColumnItems, CHR(10), "")).
DYNAMIC-FUNCTION('setBrowseColumnItemPairs':U       IN p_hsmo, INPUT REPLACE(cColumnItemPairs, CHR(10), "")).
DYNAMIC-FUNCTION('setBrowseColumnInnerLines':U      IN p_hsmo, INPUT cColumnInnerLines).
DYNAMIC-FUNCTION('setBrowseColumnMaxChars':U        IN p_hsmo, INPUT cColumnMaxChars).
DYNAMIC-FUNCTION('setBrowseColumnSorts':U           IN p_hsmo, INPUT cColumnSorts).
DYNAMIC-FUNCTION('setBrowseColumnAutoCompletions':U IN p_hsmo, INPUT cColumnAutoCompletions).
DYNAMIC-FUNCTION('setBrowseColumnUniqueMatches':U   IN p_hsmo, INPUT cColumnUniqueMatches).
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
          i_maxWidth l_ScrollRemote l_FetchOnReposToEnd lUseSortIndicator 
      WITH FRAME Attribute-Dlg.
  ENABLE l_Enable l_View l_calcWidth i_numdown l_ScrollRemote 
         l_FetchOnReposToEnd lUseSortIndicator 
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
    lUseSortIndicator = DYNAMIC-FUNC("getUseSortIndicator":U IN p_hSMO).
    
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
    
    cListPairs = {&novalue} + ',':U.
    
    if valid-handle(ghDataSource) then 
    do:
      if {fnarg instanceOf 'SBO':U ghDataSource} then  
      do: 
        /* this old problem should be fixed by now (10.1C), but... */
        if not {fn getObjectsCreated ghDataSource} then
          RUN createObjects IN ghDataSource.
      
        cTargets = DYNAMIC-FUNCTION('getContainedDataObjects' IN ghDataSource).
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
      END.    /* END DO IF NO Targets yet */
      else  /* This is an SDO or DataView, set that handle which is used elsewhere. */  
      DO: 
        ASSIGN
          ghSDO = ghDataSource.
        
        IF VALID-HANDLE(ghSDO) THEN
          ASSIGN
            cObjectName = DYNAMIC-FUNCTION('getObjectName' IN ghSDO)
            cListPairs  = cListPairs +  ",":U 
                          + cObjectName +  ",":U + STRING(ghSDO)
            c_SDOList   = STRING(ghSDO). 
      END. /* else (Linked to an SDO) */
    end. /* valid ghdatasource */ 
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

    /*Set the sensitive status of the view-as button. If not fields are selected, this
      button cannot be selected*/
    setViewAsButton().

  END. /* DO WITH FRAME... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildViewAsProperties Attribute-Dlg 
PROCEDURE rebuildViewAsProperties :
/*------------------------------------------------------------------------------
  Purpose: Rebuilds the view-as properties when the displayedField list is
                   modified.     
  Parameters:  <none>
  
  Notes: The displayedFields list can be modified in several ways: add, delete or
         modify fields, or all of those togheter.
         When the displayedFields list is modified, this procedure stores the
         view-as property values in the ttViewAsProperties for each field in the
         old list, and then rebuilds the view-as properties using the values
         stored in the temp-table.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcOldFields AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iNumFields  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iProperty   AS INTEGER    NO-UNDO.

DEFINE VARIABLE cPropertiesToLoad     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyValue        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldValue           AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cColumnTypes           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnDelimiters      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnItems           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnItemPairs       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnInnerLines      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnMaxChars        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnSorts           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnAutoCompletions AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cColumnUniqueMatches   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cCurrentField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentType          AS CHARACTER  NO-UNDO.

EMPTY TEMP-TABLE ttViewAsProperties.

ASSIGN cColumnTypes           = DYNAMIC-FUNCTION('getBrowseColumnTypes':U           IN p_hsmo)
       cColumnDelimiters      = DYNAMIC-FUNCTION('getBrowseColumnDelimiters':U      IN p_hsmo)
       cColumnItems           = DYNAMIC-FUNCTION('getBrowseColumnItems':U           IN p_hsmo)
       cColumnItemPairs       = DYNAMIC-FUNCTION('getBrowseColumnItemPairs':U       IN p_hsmo)
       cColumnInnerLines      = DYNAMIC-FUNCTION('getBrowseColumnInnerLines':U      IN p_hsmo)
       cColumnMaxChars        = DYNAMIC-FUNCTION('getBrowseColumnMaxChars':U        IN p_hsmo)
       cColumnSorts           = DYNAMIC-FUNCTION('getBrowseColumnSorts':U           IN p_hsmo)
       cColumnAutoCompletions = DYNAMIC-FUNCTION('getBrowseColumnAutoCompletions':U IN p_hsmo)
       cColumnUniqueMatches   = DYNAMIC-FUNCTION('getBrowseColumnUniqueMatches':U   IN p_hsmo).

/*Gets the browse column properties for the old fields list*/
DO iNumFields = 1 TO NUM-ENTRIES(pcOldFields):

    ASSIGN cCurrentField = ENTRY(iNumFields, pcOldFields).

    /*All columns are fill-ins (defaults), so do nothing and return*/
    IF cColumnTypes = "" OR cColumnTypes = ? THEN RETURN.

    ASSIGN cCurrentType = ENTRY(iNumFields, cColumnTypes, CHR(5)).

    /*If the browse column is a fill-in, all values are ? (null), so there is not
      need to load those values*/
    IF cCurrentType = "" OR cCurrentType = "FI":U OR cCurrentType = ? OR cCurrentType = "?" THEN NEXT.

    CREATE ttViewAsProperties.
    ASSIGN ttViewAsProperties.cField = cCurrentField
           ttViewAsProperties.cType  = cCurrentType.

    /*If the browse column is a toggle-box, the others fields does not matter*/
    IF cCurrentType = "TB":U THEN NEXT. 

    ASSIGN ttViewAsProperties.cItems          = (IF cColumnItems           NE "" 
                                                 THEN ENTRY(iNumFields, cColumnItems, CHR(5)) 
                                                 ELSE ?)
           ttViewAsProperties.cItemPairs      = (IF cColumnItemPairs       NE "" 
                                                 THEN ENTRY(iNumFields, cColumnItemPairs,CHR(5))
                                                 ELSE ?)
           ttViewAsProperties.cDelimiter      = (IF cColumnDelimiters      NE "" 
                                                 THEN ENTRY(iNumFields, cColumnDelimiters, CHR(5)) 
                                                 ELSE ?)
           ttViewAsProperties.cInnerLines     = (IF cColumnInnerLines      NE "" 
                                                 THEN ENTRY(iNumFields, cColumnInnerLines,     CHR(5))
                                                 ELSE ?)
           ttViewAsProperties.cMaxChars       = (IF cColumnMaxChars        NE "" 
                                                 THEN ENTRY(iNumFields, cColumnMaxChars,       CHR(5)) 
                                                 ELSE ?)
           ttViewAsProperties.cSort           = (IF cColumnSorts           NE "" 
                                                 THEN ENTRY(iNumFields, cColumnSorts, CHR(5)) 
                                                 ELSE ?)
           ttViewAsProperties.cAutoCompletion = (IF cColumnAutoCompletions NE "" 
                                                 THEN ENTRY(iNumFields, cColumnAutoCompletions, CHR(5))
                                                 ELSE ?)
           ttViewAsProperties.cUniqueMatch    = (IF cColumnUniqueMatches   NE "" 
                                                 THEN ENTRY(iNumFields, cColumnUniqueMatches,CHR(5)) 
                                                 ELSE ?)
           .
END. /* DO iNumFields = 1 TO NUM-ENTRIES(pcOldFields):*/

/*Builds the list of properties to be restored*/
IF cColumnTypes          NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnTypes":U + ",".
IF cColumnDelimiters     NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnDelimiters":U + ",".
IF cColumnItems          NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnItems":U + ",".
IF cColumnItemPairs      NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnItemPairs":U + ",".
IF cColumnInnerLines     NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnInnerLines":U + ",".
IF cColumnMaxChars       NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnMaxChars":U + ",".
IF cColumnSorts           NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnSorts":U + ",".
IF cColumnAutoCompletions NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnAutoCompletions":U + ",".
IF cColumnUniqueMatches    NE "" THEN
   ASSIGN cPropertiesToLoad = cPropertiesToLoad + "BrowseColumnUniqueMatches":U + ",".

  ASSIGN cPropertiesToLoad = TRIM(cPropertiesToLoad, ",").

  /*Now builds the view-as property lists with the new displayed fields*/
  DO iProperty = 1 TO NUM-ENTRIES(cPropertiesToLoad):

    ASSIGN cPropertyName  = ENTRY(iProperty, cPropertiesToLoad)
           cPropertyValue = "".

    DO iNumFields = 1 TO NUM-ENTRIES(gcDisplayedFields):

        ASSIGN cCurrentField = ENTRY(iNumFields, gcDisplayedFields).

        FIND FIRST ttViewAsProperties NO-LOCK WHERE ttViewAsProperties.cField = cCurrentField NO-ERROR.

        IF NOT AVAILABLE(ttViewAsProperties) THEN
            ASSIGN cPropertyValue = cPropertyValue + "?" + CHR(5).
        ELSE DO:
            IF cPropertyName = "BrowseColumnTypes":U THEN 
              ASSIGN cPropertyValue = cPropertyValue 
                                    + ttViewAsProperties.cType + CHR(5).
          
          CASE cPropertyName:
            WHEN "BrowseColumnDelimiters":U      THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cDelimiter      = ? THEN "?" ELSE ttViewAsProperties.cDelimiter)      + CHR(5).
            WHEN "BrowseColumnItems":U           THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cItems          = ? THEN "?" ELSE ttViewAsProperties.cItems)          + CHR(5).
            WHEN "BrowseColumnItemPairs":U       THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cItemPairs      = ? THEN "?" ELSE ttViewAsProperties.cItemPairs)      + CHR(5).
            WHEN "BrowseColumnInnerLines":U      THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cInnerLines     = ? THEN "?" ELSE ttViewAsProperties.cInnerLines)     + CHR(5).
            WHEN "BrowseColumnMaxChars":U        THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cMaxChars       = ? THEN "?" ELSE ttViewAsProperties.cMaxChars)       + CHR(5).
            WHEN "BrowseColumnSorts":U           THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cSort           = ? THEN "?" ELSE ttViewAsProperties.cSort)           + CHR(5).
            WHEN "BrowseColumnAutoCompletions":U THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cAutoCompletion = ? THEN "?" ELSE ttViewAsProperties.cAutoCompletion) + CHR(5).
            WHEN "BrowseColumnUniqueMatches":U   THEN ASSIGN cPropertyValue = cPropertyValue + (IF ttViewAsProperties.cUniqueMatch    = ? THEN "?" ELSE ttViewAsProperties.cUniqueMatch)    + CHR(5).
          END CASE.
        END.
    END. /* DO iField = 1 TO NUM-ENTRIES(gcDisplayedFields):*/

    ASSIGN cPropertyValue = TRIM(cPropertyValue, CHR(5)).

    DYNAMIC-FUNCTION('set':U + cPropertyName IN p_hsmo, INPUT cPropertyValue).
  END. /* DO iProperty = 1 TO NUM-ENTRIES(cPropertiesToLoad):*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeLargeObjects Attribute-Dlg 
PROCEDURE removeLargeObjects :
/*------------------------------------------------------------------------------
  Purpose:     Removes large objects from the parameter list
  Parameters:  pcFieldList AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT  PARAMETER pcFieldList AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLargeFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.

    /* Builds list of large objects in the list */
    DO iEntry = 1 TO NUM-ENTRIES(pcFieldList):
      cField = ENTRY(iEntry, pcFieldList).
      IF LOOKUP(DYNAMIC-FUNCTION('columnDataType':U IN ghSDO, cField),
                'BLOB,CLOB':U) > 0 THEN
        cLargeFieldList = cLargeFieldList + cField + ',':U.
    END.  /* do 1 to number fields */
    
    IF cLargeFieldList > '':U THEN
    DO: 
      cLargeFieldList = TRIM(cLargeFieldList, ',':U).
      cMessage = IF NUM-ENTRIES(cLargeFieldList) > 1 THEN 
                 ' are defined as large objects and cannot be added to a SmartDataBrowser.':U
                 ELSE ' is defined as a large object and cannot be added to a SmartDataBrowser.':U.
      MESSAGE 
        cLargeFieldList + cMessage 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      /* Removes large objects from list */
      DO iEntry = 1 TO NUM-ENTRIES(cLargeFieldList):
        pcFieldList = 
            DYNAMIC-FUNCTION('deleteEntry':U IN ghSDO,
                              INPUT LOOKUP(ENTRY(iEntry,cLargeFieldList),pcFieldList),
                              INPUT pcFieldList,
                              INPUT ',':U).
      END.
    END.
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
    
    DEFINE VARIABLE lResult    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFields    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDatatable AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cNewFields AS CHARACTER  NO-UNDO.
    /* Populate the search field only if our data source is an SDO, not an SBO.*/
    IF ghSDO = ghDataSource THEN
    DO:
      IF gcDisplayedFields = "":U THEN
        /* This means no explicit field list has been selected, so the fieldlist
           is in fact *all* SDO fields; so make these available as search fields. */
        cFields = dynamic-function('getDataColumns':U IN ghSDO) NO-ERROR.
      ELSE 
        cFields = gcDisplayedFields.
      
      /* If qualified fields of a dataview use only Datatable columns */
      IF INDEX(cFields,'.':U) > 0 THEN
      DO:
        {get DataTable cDataTable ghSDO} NO-ERROR.
        DO iField = 1 TO NUM-ENTRIES(cFields):
          cField = ENTRY(iField,cFields).
          IF ENTRY(1,cField,'.':U) = cDataTable THEN
          DO:
             cNewFields = cNewFields
                        + (IF cnewFields = '' THEN '' ELSE ',')
                        + cField.
          END.
        END.
        cFields = cNewFields.
      END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewAsButton Attribute-Dlg 
FUNCTION setViewAsButton RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF gcDisplayedFields = "":U OR gcDisplayedFields = ? OR NOT VALID-HANDLE(ghSDO) THEN
   ASSIGN Viewas-Btn:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
ELSE 
   ASSIGN Viewas-Btn:SENSITIVE = TRUE.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

