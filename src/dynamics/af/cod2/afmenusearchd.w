&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" diDialog _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" diDialog _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afmenusearchd.w

  Description:  Search DIalog

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:
                Date:   09/29/2001  Author:     Don Bulua

  Update Notes: Created from Template rysttdilgd.w
                Created from Template afmenusearchd.w

  (v:010001)    Task:         0    UserRef:
                Date:   04/23/2002  Author:     Sunil Belgaonkar

  Update Notes: Changed the Image paths from af/bmp to ry/img
                Also Changed the images from .bmp to .gif formats.

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

&scop object-name       afmenusearchd.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_IS_RUNNING) NE 0 &THEN
  DEFINE VARIABLE ghCallingProc  AS HANDLE NO-UNDO.
&ELSE
 DEFINE INPUT  PARAMETER ghCallingProc AS HANDLE NO-UNDO.
&ENDIF
/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcModuleObj AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdcol       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdcol2      AS DECIMAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnSplitBar btnSplitBar-2 EdEditor buOk ~
fiChar fiBand fiRef 
&Scoped-Define DISPLAYED-OBJECTS EdEditor fiChar fiBand fiRef 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getbandImage diDialog 
FUNCTION getbandImage RETURNS CHARACTER
 ( pcBandType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getItemImage diDialog 
FUNCTION getItemImage RETURNS CHARACTER
  ( pcItemType AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getItemLabel diDialog 
FUNCTION getItemLabel RETURNS CHARACTER
  ( pcLabel       AS CHAR,
    pcReference   AS CHAR,
    pcDescription AS CHAR,
    pcType        AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynbrowser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynbrowser-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynbrowser-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynbrowser-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntreeview AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntreeview-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscicfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmit2fullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmifullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmmsfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmomfullo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmtm2fullo AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSplitBar  NO-FOCUS FLAT-BUTTON NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 2.8 BY 17.62
     BGCOLOR 8 .

DEFINE BUTTON btnSplitBar-2  NO-FOCUS FLAT-BUTTON NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 17.62
     BGCOLOR 8 .

DEFINE BUTTON buOk AUTO-GO 
     LABEL "Close" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE EdEditor AS CHARACTER INITIAL "Expand a category and click on an item to view all bands that contain that item" 
     VIEW-AS EDITOR
     SIZE 109 BY 1.19 NO-UNDO.

DEFINE VARIABLE fiBand AS CHARACTER FORMAT "X(256)":U INITIAL "Bands:" 
      VIEW-AS TEXT 
     SIZE 8 BY .62 NO-UNDO.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U INITIAL "Categories:" 
      VIEW-AS TEXT 
     SIZE 11 BY .62 NO-UNDO.

DEFINE VARIABLE fiRef AS CHARACTER FORMAT "X(256)":U INITIAL "Band Reference Label:" 
      VIEW-AS TEXT 
     SIZE 23 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     btnSplitBar AT ROW 1 COL 37
     btnSplitBar-2 AT ROW 1 COL 45
     EdEditor AT ROW 17.43 COL 1 NO-LABEL
     buOk AT ROW 17.43 COL 111
     fiChar AT ROW 2.33 COL 2.6 NO-LABEL
     fiBand AT ROW 2.43 COL 38 COLON-ALIGNED NO-LABEL
     fiRef AT ROW 10.76 COL 38 COLON-ALIGNED NO-LABEL
     SPACE(64.99) SKIP(7.42)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         NO-LABELS SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Search Nodes"
         DEFAULT-BUTTON buOk.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB diDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX diDialog
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

ASSIGN 
       btnSplitBar:MOVABLE IN FRAME diDialog          = TRUE.

ASSIGN 
       btnSplitBar-2:MOVABLE IN FRAME diDialog          = TRUE.

ASSIGN 
       EdEditor:RETURN-INSERTED IN FRAME diDialog  = TRUE
       EdEditor:READ-ONLY IN FRAME diDialog        = TRUE.

/* SETTINGS FOR FILL-IN fiChar IN FRAME diDialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Search Nodes */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSplitBar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBar diDialog
ON END-MOVE OF btnSplitBar IN FRAME diDialog
DO:
  IF SELF:COL >  gdcol THEN
     RUN repositionSPlitBar ("RIGHT":U).
  ELSE
     RUN repositionSPlitBar ("LEFT":U).

  gdcol = SELF:COL.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSplitBar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBar-2 diDialog
ON END-MOVE OF btnSplitBar-2 IN FRAME diDialog
DO:
  IF SELF:COL >  gdcol2 THEN
     RUN repositionSPlitBar2 ("RIGHT":U).
  ELSE
     RUN repositionSPlitBar2 ("LEFT":U).

  gdcol2 = SELF:COL.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects diDialog  _ADM-CREATE-OBJECTS
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
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'FolderLabels':U + 'Items|Bands' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.00 , 1.20 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 16.19 , 126.80 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmit2fullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmit2fulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gsmit2fullo ).
       RUN repositionObject IN h_gsmit2fullo ( 1.00 , 58.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 14.00 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'DisplayedFieldsmenu_structure_code,menu_structure_description,menu_structure_typeEnabledFieldsScrollRemotenoNumDown0CalcWidthnoMaxWidth90FetchOnReposToEndyesSearchFieldDataSourceNamesgsmit2fulloUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser ).
       RUN repositionObject IN h_dynbrowser ( 3.24 , 33.00 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser ( 7.29 , 87.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/obj2/gsmmsfullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmmsfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gsmmsfullo ).
       RUN repositionObject IN h_gsmmsfullo ( 1.24 , 96.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 14.00 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'DisplayedFieldsmenu_structure_code,menu_structure_description,menu_structure_typeEnabledFieldsScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesSearchFieldDataSourceNamesgsmmsfulloUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser-2 ).
       RUN repositionObject IN h_dynbrowser-2 ( 11.48 , 33.00 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser-2 ( 5.48 , 86.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/obj2/gscicfullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegscicfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gscicfullo ).
       RUN repositionObject IN h_gscicfullo ( 1.00 , 70.00 ) NO-ERROR.
       /* Size in AB:  ( 1.91 , 15.00 ) */

       RUN constructObject (
             INPUT  'af/obj2/gsmmifullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmmifulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gsmmifullo ).
       RUN repositionObject IN h_gsmmifullo ( 1.00 , 83.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 17.00 ) */

       RUN constructObject (
             INPUT  'adm2/dyntreeview.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AutoSortyesHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesnoTreeStyle7ExpandOnAddnoFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation10LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntreeview ).
       RUN repositionObject IN h_dyntreeview ( 3.14 , 2.60 ) NO-ERROR.
       RUN resizeObject IN h_dyntreeview ( 13.81 , 35.40 ) NO-ERROR.

       /* Links to SmartDataBrowser h_dynbrowser. */
       RUN addLink ( h_gsmit2fullo , 'Data':U , h_dynbrowser ).

       /* Links to SmartDataBrowser h_dynbrowser-2. */
       RUN addLink ( h_gsmmsfullo , 'Data':U , h_dynbrowser-2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynbrowser ,
             h_dyntreeview , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynbrowser-2 ,
             h_dynbrowser , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gsmtm2fullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmtm2fulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gsmtm2fullo ).
       RUN repositionObject IN h_gsmtm2fullo ( 1.71 , 108.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'DisplayedFieldsBandname,ToolbarNameEnabledFieldsScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesSearchFieldDataSourceNamesgsmtm2fulloUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser-3 ).
       RUN repositionObject IN h_dynbrowser-3 ( 3.38 , 47.60 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser-3 ( 5.95 , 72.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/obj2/gsmomfullo.wDB-AWARE':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegsmomfulloUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_gsmomfullo ).
       RUN repositionObject IN h_gsmomfullo ( 2.19 , 95.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'DisplayedFieldsmenu_structure_code,object_filename,object_descriptionEnabledFieldsScrollRemoteyesNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesSearchFieldDataSourceNamesgsmomfulloUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser-4 ).
       RUN repositionObject IN h_dynbrowser-4 ( 9.81 , 47.60 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser-4 ( 6.67 , 72.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyntreeview.w':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'AutoSortyesHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesnoTreeStyle7ExpandOnAddyesFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation10LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntreeview-2 ).
       RUN repositionObject IN h_dyntreeview-2 ( 3.38 , 2.80 ) NO-ERROR.
       RUN resizeObject IN h_dyntreeview-2 ( 13.33 , 43.20 ) NO-ERROR.

       /* Links to SmartDataBrowser h_dynbrowser-3. */
       RUN addLink ( h_gsmtm2fullo , 'Data':U , h_dynbrowser-3 ).

       /* Links to SmartDataBrowser h_dynbrowser-4. */
       RUN addLink ( h_gsmomfullo , 'Data':U , h_dynbrowser-4 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynbrowser-3 ,
             h_dyntreeview-2 , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynbrowser-4 ,
             h_dynbrowser-3 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects diDialog 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iPage AS INTEGER    NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
 {get currentPage iPage}.
 IF iPage = 2 THEN
   {set openOninit NO h_gsmomfullo}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI diDialog  _DEFAULT-DISABLE
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
  HIDE FRAME diDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI diDialog  _DEFAULT-ENABLE
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
  DISPLAY EdEditor fiChar fiBand fiRef 
      WITH FRAME diDialog.
  ENABLE btnSplitBar btnSplitBar-2 EdEditor buOk fiChar fiBand fiRef 
      WITH FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expandbands diDialog 
PROCEDURE expandbands :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pckey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNodeKey        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBandAvailable  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChildKey       AS CHARACTER  NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

{get TreeDataTable hTable h_dyntreeview-2}.

/* Get buffer handles */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview-2,"TAG":U,pcKey).

IF NOT cTag begins "@":U  THEN
    RETURN.

  cChildKey = DYNAMIC-FUNCTION("GetProperty":U IN h_dyntreeview-2,"Child":U,pckey).
  RUN deletenode IN h_dyntreeview-2 (cChildKey).
  cTag = SUBSTRING(cTag,2).
  DYNAMIC-FUNCTION("SetProperty":U IN h_dyntreeview-2,"TAG":U,pckey,cTag).


hBuf:EMPTY-TEMP-TABLE().

  /* Remove data link before building nodes for greater performance */
/* If specific module is selected in combo-box, refine query */
IF gcModuleObj > "0":U THEN
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'product_module_obj':U,gcModuleObj,'EQ':U).
 /* Query all menu bands for the specific menu structure type (Menubars, Toolbars, Submenus, Menu&Toolbars) */
DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'menu_structure_type':U,ENTRY(2,cTag,"|"),'EQ':U).
{fn OpenQuery h_gsmmsfullo}.
DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmmsfullo, 'menu_structure_type':U,"EQ":U).

lBandAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmsfullo,"CURRENT":U).
  /* Add all items for specific band that was expanded */
DO WHILE lBandAvailable:
  cCols = DYNAMIC-FUNC("colValues":U IN h_gsmmsfullo,"menu_structure_description,menu_structure_type,menu_structure_obj,menu_structure_code":U).
  hbuf:BUFFER-CREATE().
  ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
         cNodeKey                      = hKey:BUFFER-VALUE
         hParentKey:BUFFER-VALUE       = pcKey
         hInsert:BUFFER-VALUE          = 4
         hLabel:BUFFER-VALUE           = ENTRY(5,cCols,CHR(1)) + (IF ENTRY(2,cCols,CHR(1)) > "" 
                                                                  AND TRIM(ENTRY(2,cCols,CHR(1))) <> TRIM(ENTRY(5,cCols,CHR(1))) 
                                                                  THEN "  (" + ENTRY(2,cCols,CHR(1)) + ")"
                                                                  ELSE "")
         hImage:BUFFER-VALUE           = getBandImage(ENTRY(3,cCols,CHR(1)))
         hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
         hSort:BUFFER-VALUE            = TRUE
         hTag:BUFFER-VALUE             = "BAND|":U + ENTRY(4,cCols,CHR(1)) + "|" + ENTRY(3,cCols,CHR(1)) + "|" + ENTRY(5,cCols,CHR(1))
         NO-ERROR.

   /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "(None)".

  lBandAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmsfullo,"NEXT":U).
  IF lbandAvailable THEN
    RUN fetchNext IN h_gsmmsfullo.
END.

RUN populateTree IN h_dyntreeview-2 (hTable,pcKey).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expanditems diDialog 
PROCEDURE expanditems :
/*------------------------------------------------------------------------------
  Purpose:   Called from tvNodeEvent when an item is expanded.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChildkey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

  ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,pcKey).

  IF NOT cTag begins "@":U  THEN
    RETURN.

  cChildKey = DYNAMIC-FUNCTION("GetProperty":U IN h_dyntreeview,"Child":U,pckey).
  RUN deletenode IN h_dyntreeview (cChildKey).
  cTag = SUBSTRING(cTag,2).
  DYNAMIC-FUNCTION("SetProperty":U IN h_dyntreeview,"TAG":U,pckey,cTag).

  hTable = DYNAMIC-FUNC("getTreeDataTable":U IN h_dyntreeview).

  ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
         hKey            = hBuf:BUFFER-FIELD('node_key':U)
         hlabel          = hBuf:BUFFER-FIELD('node_label':U)
         hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
         hTag            = hBuf:BUFFER-FIELD('private_data':U)
         hImage          = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
         hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
         hSort           = hBuf:BUFFER-FIELD('node_sort':U)
         hInsert         = hBuf:BUFFER-FIELD('node_insert':U).
   /* Clear the data from the TreeView */
  hBuf:EMPTY-TEMP-TABLE().
  DYNAMIC-FUNC("assignQuerySelection":U IN h_gsmmifullo, 'item_category_obj':U,ENTRY(2,cTag,"|"),"EQ":U).
  IF gcModuleObj > "0":U THEN
    DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,gcModuleObj,'EQ':U).
  {fn OpenQuery h_gsmmifullo}.
  DYNAMIC-FUNC("removeQuerySelection":U IN h_gsmmifullo, 'item_category_obj':U,"EQ":U).
  lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"CURRENT":U).
  /* Add all items for specific category that was expanded */
  DO WHILE lRowAvailable:
    cCols = DYNAMIC-FUNC("colValues" IN h_gsmmifullo,"menu_item_reference,menu_item_label,menu_item_description,item_control_type,menu_item_obj").
    ASSIGN cLabel = getItemLabel(ENTRY(3,cCols,CHR(1)),ENTRY(2,cCols,CHR(1)),ENTRY(4,cCols,CHR(1)),ENTRY(5,cCols,CHR(1))).
    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview)
           hParentKey:BUFFER-VALUE       = pcKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = cLabel
           hImage:BUFFER-VALUE           = getItemImage(ENTRY(5,cCols,CHR(1)))
           hSelectedImage:BUFFER-VALUE   = hImage:BUFFER-VALUE
           hSort:BUFFER-VALUE            = TRUE
           hTag:BUFFER-VALUE             = "ITEM|":U + ENTRY(6,cCols,CHR(1))
           NO-ERROR.
     /* Ensure the Text is never blank */
   IF hLabel:BUFFER-VALUE = "" OR hLabel:BUFFER-VALUE = ? THEN
       hLabel:BUFFER-VALUE = "???".

    lRowAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"NEXT":U).
    IF lRowAvailable THEN
      RUN fetchNext IN h_gsmmifullo.
  END.

  RUN populateTree IN h_dyntreeview (hTable,pcKey).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initbands diDialog 
PROCEDURE initbands :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

DEFINE VARIABLE cParentKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBandLabelKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRootKey        AS CHARACTER  NO-UNDO.


{get TreeDataTable hTable h_dyntreeview}.
IF NOT VALID-HANDLE(hTable) THEN DO:
    MESSAGE "Invalid Handle found for TreeData temp-table"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.

ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hKey            = hBuf:BUFFER-FIELD('node_key':U)
       hlabel          = hBuf:BUFFER-FIELD('node_label':U)
       hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
       hTag            = hBuf:BUFFER-FIELD('private_data':U)
       hImage          = hBuf:BUFFER-FIELD('image':U)
       hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
       hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
       hSort           = hBuf:BUFFER-FIELD('node_sort':U)
       hInsert         = hBuf:BUFFER-FIELD('node_insert':U).

/* Clear the data from the TreeView */
hBuf:EMPTY-TEMP-TABLE().
RUN emptyTree IN h_dyntreeview-2.

/* Add Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
       hParentKey:BUFFER-VALUE       = cRootKey
       cBandLabelKey                 = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif":U
       hExpanded:BUFFER-VALUE        = YES
       hTag:BUFFER-VALUE             = "BANDLABEL|":U
       NO-ERROR.

/* Add MenuBar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "MenuBar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif":U
       hExpanded:BUFFER-VALUE        = YES
       hTag:BUFFER-VALUE             = "@BANDLABEL|MenuBar":U
       NO-ERROR.

/* Add dummy record for MenuBar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.

/* Add SubMenu Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Submenu Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|SubMenu":U
       NO-ERROR.

/* Add dummy record for SubMenu bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.

/* Add Toolbar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Toolbar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|Toolbar":U
       NO-ERROR.

/* Add dummy record for Toolbar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord":U
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy":U
        NO-ERROR.


/* Add Menu&Toolbar Bands label Node */
hbuf:BUFFER-CREATE().
ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
       hParentKey:BUFFER-VALUE       = cBandLabelKey
       cParentKey                    = hKey:BUFFER-VALUE
       hInsert:BUFFER-VALUE          = 4
       hLabel:BUFFER-VALUE           = "Menu & Toolbar Bands"
       hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif":U
       hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif":U
       hExpanded:BUFFER-VALUE        = NO
       hTag:BUFFER-VALUE             = "@BANDLABEL|Menu&Toolbar":U
       NO-ERROR.


/* Add dummy record for Menu&Toolbar bands */
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dyntreeview-2)
        hParentKey:BUFFER-VALUE       = cParentKey
        hInsert:BUFFER-VALUE          = 4
        hLabel:BUFFER-VALUE           = "@DummyRecord"
        hImage:BUFFER-VALUE           = ""
        hSelectedImage:BUFFER-VALUE   = ""
        hTag:BUFFER-VALUE             = "@Dummy"
        NO-ERROR.

 RUN populatetree IN h_dyntreeview-2 (hTable,cRootKey).

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "tvNodeEvent":U IN h_dyntreeview-2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject diDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

   /* BUFFER FIELD handles */
 DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

 DEFINE VARIABLE cCatgLabelKey   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCatgKey        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lCatgAvailable  AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lItemAvailable  AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE Lok             AS LOGICAL    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
 SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "tvNodeEvent":U IN h_dyntreeview.

 {set HideOnInit YES}.
 
 {set openOnInit NO h_gsmit2fullo }.
 {set openOnInit NO h_gsmmsfullo }.

 /* Get the product module */
 IF VALID-HANDLE(ghCallingProc) THEN
    gcModuleObj = DYNAMIC-FUNC("getModuleObj":U IN ghCallingProc).

 RUN SUPER.
 
 /* Code placed here will execute AFTER standard behavior.    */
 hTable = DYNAMIC-FUNC("getTreeDataTable":U IN h_dyntreeview).

 ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
        hKey            = hBuf:BUFFER-FIELD('node_key':U)
        hlabel          = hBuf:BUFFER-FIELD('node_label':U)
        hParentKey      = hBuf:BUFFER-FIELD('parent_node_key':U)
        hTag            = hBuf:BUFFER-FIELD('private_data':U)
        hImage          = hBuf:BUFFER-FIELD('image':U)
        hSelectedImage  = hBuf:BUFFER-FIELD('selected_image':U)
        hExpanded       = hBuf:BUFFER-FIELD('node_expanded':U)
        hSort           = hBuf:BUFFER-FIELD('node_sort':U)
        hInsert         = hBuf:BUFFER-FIELD('node_insert':U).
 /* Clear the data from the TreeView */
 hBuf:EMPTY-TEMP-TABLE().
 RUN emptyTree IN h_dynTreeview.
 lCatgAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscicfullo,"CURRENT":U).
 DO WHILE lCatgAvailable:
   cCols = DYNAMIC-FUNC("colValues" IN h_gscicfullo,"item_category_label,item_category_obj").

   hbuf:BUFFER-CREATE().
   ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dynTreeview)
          hParentKey:BUFFER-VALUE       = "":U
          cCatgKey                      = hKey:BUFFER-VALUE
          hInsert:BUFFER-VALUE          = 1
          hLabel:BUFFER-VALUE           = ENTRY(2,cCols,CHR(1))
          hImage:BUFFER-VALUE           = "ry/img/menucategory.gif"
          hSelectedImage:BUFFER-VALUE   = "ry/img/menucategory.gif"
          hSort:BUFFER-VALUE            = TRUE
          hTag:BUFFER-VALUE             = "@CATG|" + ENTRY(3,cCols,CHR(1))
          NO-ERROR.
    RUN addNode IN h_dynTreeview (hTable:DEFAULT-BUFFER-HANDLE).
   /* Determine whether any items exist per category. If yes, add dummy node*/
   DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,ENTRY(3,cCols,CHR(1)),'EQ':U).
   {fn OpenQuery h_gsmmifullo}.
   DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'EQ':U).
   lItemAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gsmmifullo,"CURRENT":U).
   IF lItemAvailable  THEN
   DO:
     hbuf:BUFFER-CREATE().
     ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dynTreeview)
            hParentKey:BUFFER-VALUE       = cCatgKey
            hInsert:BUFFER-VALUE          = 4
            hLabel:BUFFER-VALUE           = "@DummyRecord"
            hImage:BUFFER-VALUE           = "ry/img/folderclosed.gif"
            hSelectedImage:BUFFER-VALUE   = "ry/img/folderopen.gif"
            hTag:BUFFER-VALUE             = "@Dummy"
            NO-ERROR.
     RUN addNode IN h_dynTreeview (hTable:DEFAULT-BUFFER-HANDLE).
     hBuf:EMPTY-TEMP-TABLE().
   END.
   lCatgAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscicfullo,"NEXT":U).
   IF lCatgAvailable THEN
     RUN fetchNext IN h_gscicfullo.
 END. /* End loop through gsc_item_category */


 /* Add (None) Categories for all items not having a category*/
 hbuf:BUFFER-CREATE().
 ASSIGN hKey:BUFFER-VALUE             = "x4item":U
        hParentKey:BUFFER-VALUE       = "":U
        cCatgKey                      = hKey:BUFFER-VALUE
        hInsert:BUFFER-VALUE          = 1
        hLabel:BUFFER-VALUE           = "(None)"
        hImage:BUFFER-VALUE           = "ry/img/menucategory.gif"
        hSelectedImage:BUFFER-VALUE   = "ry/img/menucategory.gif"
        hSort:BUFFER-VALUE            = TRUE
        hTag:BUFFER-VALUE             = "@CATG|0"
        NO-ERROR.
 RUN addNode IN h_dynTreeview (hTable:DEFAULT-BUFFER-HANDLE).
 hBuf:EMPTY-TEMP-TABLE().

 /* Determine whether there are any items not having an item assigned */
 IF gcModuleObj > '0':U  THEN
   DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'product_module_obj':U,gcModuleObj,'EQ':U).
 DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'0':U,'EQ':U).
 {fn OpenQuery h_gsmmifullo}.
 DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmifullo,'item_category_obj':U,'EQ':U).

 lCatgAvailable = DYNAMIC-FUNCTION('rowAvailable':U in h_gscicfullo,"CURRENT":U).
 IF lCatgAvailable THEN DO:
    hbuf:BUFFER-CREATE().
    ASSIGN hKey:BUFFER-VALUE             = DYNAMIC-FUNC('getNextNodeKey':U IN h_dynTreeview)
           hParentKey:BUFFER-VALUE       = cCatgKey
           hInsert:BUFFER-VALUE          = 4
           hLabel:BUFFER-VALUE           = "@DummyRecord"
           hImage:BUFFER-VALUE           = ""
           hSelectedImage:BUFFER-VALUE   = ""
           hTag:BUFFER-VALUE             = "@Dummy"
           NO-ERROR.
    RUN addNode IN h_dynTreeview (hTable:DEFAULT-BUFFER-HANDLE) .
    hBuf:EMPTY-TEMP-TABLE().

 END.

 ASSIGN btnSplitBar:WIDTH IN FRAME {&Frame-name}=  1.5
        btnSplitBar-2:WIDTH IN FRAME {&Frame-name}=  1.5
        lOK   = btnSplitBar:LOAD-MOUSE-POINTER("ry/img/splitbar.cur":U)
        lOK   = btnSplitBar-2:LOAD-MOUSE-POINTER("ry/img/splitbar.cur":U)
        btnSplitBar-2:HIDDEN = TRUE
        gdcol = btnSplitBar:COL
        gdcol2 = btnSplitBar-2:COL.

RUN repositionSplitbar ("RIGHT":U).

RUN viewObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSplitBar diDialog 
PROCEDURE repositionSplitBar :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER cDir AS CHARACTER  NO-UNDO.

ASSIGN btnSplitBar:ROW IN FRAME {&FRAME-NAME}    = 1.0
       btnSplitBar:COL = MAX(btnSplitBar:COL  ,10)
       btnSplitBar:COL    = MIN(btnSplitBar:COL, 100)
       btnSplitBar:HEIGHT = FRAME {&FRAME-NAME}:HEIGHT - FRAME {&FRAME-NAME}:BORDER-BOTTOM-CHARS
                              - FRAME {&FRAME-NAME}:BORDER-TOP-CHARS 
       fiBand:COL = MIN(btnSplitBar:COL + btnSplitBar:WIDTH + .5, FRAME {&FRAME-NAME}:WIDTH - fiBand:WIDTH - 1)
       fiRef:COL  = MIN(btnSplitBar:COL + btnSplitBar:WIDTH + .5, FRAME {&FRAME-NAME}:WIDTH - fiRef:WIDTH - 1)
       .

RUN resizeObject IN h_dyntreeview (13.81, btnSplitBar:COL - 1).
RUN repositionObject IN h_dyntreeview (3.0, 2.0).
IF cDir = "RIGHT":U THEN
DO:
  RUN resizeObject IN h_dynbrowser (7.29, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser (3.24,btnSplitBar:COL + btnSplitBar:WIDTH).
  RUN resizeObject IN h_dynbrowser-2 (5.40, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser-2 (11.48,btnSplitBar:COL + btnSplitBar:WIDTH).
END.
ELSE
DO:
  RUN repositionObject IN h_dynbrowser (3.24,btnSplitBar:COL + btnSplitBar:WIDTH).
  RUN resizeObject IN h_dynbrowser (7.29, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser-2 (11.48,btnSplitBar:COL + btnSplitBar:WIDTH).
  RUN resizeObject IN h_dynbrowser-2 (5.40, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar:COL - btnSplitBar:WIDTH - 3).

END.
EdEditor:move-to-top().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSplitbar2 diDialog 
PROCEDURE repositionSplitbar2 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER cDir AS CHARACTER  NO-UNDO.

ASSIGN btnSplitBar-2:ROW IN FRAME {&FRAME-NAME}    = 1.0
       btnSplitBar-2:COL = MAX(btnSplitBar-2:COL  ,10)
       btnSplitBar-2:COL    = MIN(btnSplitBar-2:COL, 100)
       btnSplitBar-2:HEIGHT = FRAME {&FRAME-NAME}:HEIGHT - FRAME {&FRAME-NAME}:BORDER-BOTTOM-CHARS
                              - FRAME {&FRAME-NAME}:BORDER-TOP-CHARS
       NO-ERROR.

RUN resizeObject IN h_dyntreeview-2 (13.81, btnSplitBar-2:COL - 1).
RUN repositionObject IN h_dyntreeview-2 (3.0, 2.0).

IF cDir = "RIGHT":U THEN
DO:
  RUN resizeObject IN h_dynbrowser-3 (7.0, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar-2:COL - btnSplitBar-2:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser-3 (3.38,btnSplitBar-2:COL + btnSplitBar-2:WIDTH).
  RUN resizeObject IN h_dynbrowser-4 (5.8, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar-2:COL - btnSplitBar-2:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser-4 (11.0,btnSplitBar-2:COL + btnSplitBar-2:WIDTH).


END.
ELSE
DO:
  RUN repositionObject IN h_dynbrowser-3 (3.38,btnSplitBar-2:COL + btnSplitBar-2:WIDTH).
  RUN resizeObject IN h_dynbrowser-3 (7.00, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar-2:COL - btnSplitBar-2:WIDTH - 3).
  RUN repositionObject IN h_dynbrowser-4 (11.0,btnSplitBar-2:COL + btnSplitBar-2:WIDTH).
  RUN resizeObject IN h_dynbrowser-4 (5.8, FRAME {&FRAME-NAME}:WIDTH - btnSplitBar-2:COL - btnSplitBar-2:WIDTH - 3).
END.

EdEditor:move-to-top().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage diDialog 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

DEFINE VARIABLE cObjects AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  cObjects = pageNTargets(TARGET-PROCEDURE, piPageNum).

  RUN SUPER( INPUT piPageNum).

  IF piPageNum = 2 THEN
    ASSIGN fiChar:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
           fiBand:HIDDEN         = TRUE
           firef:HIDDEN          = TRUE
           btnSplitBar:HIDDEN    = TRUE
           btnSplitBar-2:HIDDEN  = FALSE
           EdEditor:SCREEN-VALUE = "Expand a band type and click on a band to view all SmartToolbars that contain that band".
  ELSE
    ASSIGN fiChar:HIDDEN         = FALSE
           fiBand:HIDDEN         = FALSE
           firef:HIDDEN          = FALSE
           btnSplitBar:HIDDEN    = FALSE
           btnSplitBar-2:HIDDEN  = TRUE
           EdEditor:SCREEN-VALUE = "Expand a category and click on an item to view all bands that contain that item".


  IF piPageNum = 2 AND cObjects = "" THEN
  DO:
    RUN initBands.
    RUN repositionSplitbar2 ("RIGHT":U).
  END.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent diDialog 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEvent  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKey    AS CHARACTER     NO-UNDO.

DEFINE VARIABLE cTag            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChildkey       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCols           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRowAvailable   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.

  /* BUFFER FIELD handles */
DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKey            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTag            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExpanded       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hInsert         AS HANDLE     NO-UNDO.

IF SOURCE-PROCEDURE = h_dyntreeview THEN
  ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview,"TAG":U,pcKey).
ELSE
 ASSIGN cTag  = DYNAMIC-FUNC('getProperty':U IN h_dyntreeview-2,"TAG":U,pcKey).

IF pcEvent = "EXPAND":U  THEN
DO:
  IF SOURCE-PROCEDURE = h_dyntreeview THEN
     RUN expandItems (pcKey).
  ELSE IF SOURCE-PROCEDURE = h_dyntreeview-2 AND valid-handle(h_dyntreeview-2) THEN
    RUN expandBands(pcKey).
END.
ELSE IF pcEvent = "CLICK":U THEN
DO:
  IF SOURCE-PROCEDURE = h_dyntreeview THEN
  DO:
    IF cTag BEGINS "ITEM":U THEN
    DO:
      IF gcModuleObj > "0":U THEN DO:
         DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmit2fullo,'product_module_obj':U,gcModuleObj,'EQ':U).
         DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'product_module_obj':U,gcModuleObj,'EQ':U).
      END.

      DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmit2fullo,'gsm_menu_structure_item.menu_item_obj':U,ENTRY(2,cTag,"|") ,'EQ':U).
      {fn OpenQuery h_gsmit2fullo}.
      DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmit2fullo,'gsm_menu_structure_item.menu_item_obj':U,'EQ':U).

      DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmmsfullo,'gsm_menu_structure.menu_item_obj':U,ENTRY(2,cTag,"|") ,'EQ':U).
      {fn OpenQuery h_gsmmsfullo}.
      DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmmsfullo,'gsm_menu_structure.menu_item_obj':U,'EQ':U).

    END.
  END.
  ELSE
  DO:
    IF ENTRY(1,cTag,"|") = "BAND":U  THEN
    DO:
      DYNAMIC-FUNC("setBand":U IN h_gsmtm2fullo, ENTRY(2,cTag,"|"), ENTRY(4,cTag,"|"), gcModuleObj).
      {fn OpenQuery h_gsmtm2fullo}.
      IF gcModuleObj > "0":U THEN
         DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmomfullo,'product_module_obj':U,gcModuleObj,'EQ':U).
      DYNAMIC-FUNC('assignQuerySelection':U IN h_gsmomfullo,'menu_structure_obj':U,ENTRY(2,cTag,"|") ,'EQ':U).
     {fn OpenQuery h_gsmomfullo}.
     DYNAMIC-FUNC('removeQuerySelection':U IN h_gsmomfullo,'menu_structure_obj':U,'EQ':U).


    END.
  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getbandImage diDialog 
FUNCTION getbandImage RETURNS CHARACTER
 ( pcBandType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the appropriate image of band, based on the band type
    Notes:
------------------------------------------------------------------------------*/
CASE pcBandType:
    WHEN "MenuBar":U THEN
        RETURN "ry/img/menumenubar.gif":U.
    WHEN "Toolbar":U THEN
        RETURN "ry/img/menutoolbar.gif":U.
    WHEN "Submenu":U THEN
        RETURN "ry/img/menusubmenu.gif":U.
    WHEN "menu&Toolbar":U THEN
        RETURN "ry/img/menumenutoolbar.gif":U.
    OTHERWISE
        RETURN "ry/img/menusubmenu.gif":U.
END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getItemImage diDialog 
FUNCTION getItemImage RETURNS CHARACTER
  ( pcItemType AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the required item image based on the item type
    Notes:
------------------------------------------------------------------------------*/
CASE pcItemType:
    WHEN "Action" THEN
        RETURN "ry/img/itemaction.gif".
    WHEN "Text" THEN
        RETURN "ry/img/itemtext.gif".
    WHEN "Separator" THEN
        RETURN "ry/img/itemseparator.gif".
    WHEN "EditField" THEN
        RETURN "ry/img/itemedit.gif".
    WHEN "ComboBox" THEN
        RETURN "ry/img/itemcombo.gif".
    WHEN "Dynamic" THEN
        RETURN "ry/img/itemdynamic.gif".
    OTHERWISE
        RETURN "ry/img/itemaction.gif".
END CASE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getItemLabel diDialog 
FUNCTION getItemLabel RETURNS CHARACTER
  ( pcLabel       AS CHAR,
    pcReference   AS CHAR,
    pcDescription AS CHAR,
    pcType        AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Build the Item label string in the format Menu Label (Reference)
    Notes: Strips the ampersands out of the menu label
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lAddRef      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cReturnLabel AS CHARACTER  NO-UNDO.

   ASSIGN cReturnLabel = pcLabel
          cReturnLabel = IF cReturnLabel = "" OR cReturnLabel = ? THEN pcDescription ELSE pcLabel
          lAddRef      = IF pcReference = cReturnLabel OR pcReference = "" OR pcReference = ? THEN NO ELSE YES
          cReturnLabel = REPLACE(cReturnLabel,"&&":U,"~~")
          cReturnLabel = REPLACE(cReturnLabel,"&","")
          cReturnLabel = REPLACE(cReturnLabel,"~~","&")
          cReturnLabel = IF (cReturnLabel = "" AND pcType = "Separator")  THEN "Separator" ELSE cReturnLabel
          lAddRef      = IF pcReference = cReturnLabel OR pcReference = "" OR pcReference = ? THEN NO ELSE lAddref
          cReturnLabel = IF lAddref THEN cReturnLabel
                                      + (IF cReturnLabel = "" THEN "" ELSE "  (" )
                                      + LC(pcReference)
                                      + IF cReturnLabel = "" THEN "" ELSE ")" ELSE cReturnLabel
           NO-ERROR.
  RETURN cReturnLabel.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

