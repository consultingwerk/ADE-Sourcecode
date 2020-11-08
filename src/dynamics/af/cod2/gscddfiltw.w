&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscddfiltw.w

  Description:  Dynamic Filter

  Purpose:      Filter Window for dynamic queries used in dynamic dataset manipulation.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       gscddfiltw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER gphSource AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER gphBrowse AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER gpcTitle  AS CHARACTER  NO-UNDO.

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE ttFilter NO-UNDO RCODE-INFORMATION
  FIELD cFieldLabel AS CHARACTER FORMAT "X(40)":U LABEL "Field"
  FIELD cFromValue  AS CHARACTER FORMAT "X(40)":U LABEL "From"
  FIELD cToValue    AS CHARACTER FORMAT "X(40)":U LABEL "To"
  FIELD cFieldName  AS CHARACTER
  FIELD hBrowseCol  AS HANDLE
  FIELD hField      AS HANDLE
  FIELD iSeq        AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    iSeq
  INDEX hBrowseCol IS UNIQUE
    hBrowseCol
  INDEX cFieldName IS UNIQUE
    cFieldName
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME brFilter

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFilter

/* Definitions for BROWSE brFilter                                      */
&Scoped-define FIELDS-IN-QUERY-brFilter ttFilter.cFieldLabel ttFilter.cFromValue ttFilter.cToValue   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brFilter ttFilter.cFromValue   ttFilter.cToValue   
&Scoped-define ENABLED-TABLES-IN-QUERY-brFilter ttFilter
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brFilter ttFilter
&Scoped-define SELF-NAME brFilter
&Scoped-define QUERY-STRING-brFilter FOR EACH ttFilter
&Scoped-define OPEN-QUERY-brFilter OPEN QUERY {&SELF-NAME} FOR EACH ttFilter.
&Scoped-define TABLES-IN-QUERY-brFilter ttFilter
&Scoped-define FIRST-TABLE-IN-QUERY-brFilter ttFilter


/* Definitions for FRAME frMain                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frMain ~
    ~{&OPEN-QUERY-brFilter}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buClear buApply deProdMod brFilter 
&Scoped-Define DISPLAYED-OBJECTS deProdMod 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyntoolbar-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "&Apply" 
     SIZE 17.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClear 
     LABEL "&Clear" 
     SIZE 17.8 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE deProdMod AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0
     DROP-DOWN-LIST
     SIZE 38.4 BY 1 TOOLTIP "Select a Product Module" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brFilter FOR 
      ttFilter SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFilter wiWin _FREEFORM
  QUERY brFilter DISPLAY
      ttFilter.cFieldLabel  WIDTH 25
    ttFilter.cFromValue   WIDTH 25
    ttFilter.cToValue     WIDTH 25
  ENABLE
    ttFilter.cFromValue
    ttFilter.cToValue
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 8.86 ROW-HEIGHT-CHARS .71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buClear AT ROW 2.67 COL 57.6
     buApply AT ROW 2.67 COL 76
     deProdMod AT ROW 2.76 COL 16.6 COLON-ALIGNED
     brFilter AT ROW 4.71 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94 BY 12.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 12.62
         WIDTH              = 94
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
/* BROWSE-TAB brFilter deProdMod frMain */
ASSIGN 
       brFilter:COLUMN-RESIZABLE IN FRAME frMain       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFilter
/* Query rebuild information for BROWSE brFilter
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttFilter.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brFilter */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply wiWin
ON CHOOSE OF buApply IN FRAME frMain /* Apply */
DO:
  RUN applyFilter.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear wiWin
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  RUN clearFilter.
  deProdMod:SCREEN-VALUE = "0":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME deProdMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL deProdMod wiWin
ON VALUE-CHANGED OF deProdMod IN FRAME frMain /* Product Module */
DO:
  RUN setFilterVal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFilter
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

{af/sup2/aficonload.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableioSubModulesTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceToolbarBandsToolbarParentMenuToolbarAutoSizeyesToolbarDrawDirectionHorizontalToolbarInitialStateLogicalObjectNameObjcTopAutoResizeDisabledActionsHiddenActionsUpdateHiddenToolbarBandsNavigationHiddenMenuBandsNavigationMenuMergeOrder0EdgePixels2PanelTypeToolbarDeactivateTargetOnHidenoDisabledActionsNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar-2 ).
       RUN repositionObject IN h_dyntoolbar-2 ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar-2 ( 1.57 , 94.00 ) NO-ERROR.

       /* Links to toolbar h_dyntoolbar-2. */
       RUN addLink ( h_dyntoolbar-2 , 'ContainerToolbar':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar-2 ,
             buClear:HANDLE IN FRAME frMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilter wiWin 
PROCEDURE applyFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE BUFFER bttFilter FOR ttFilter.

   DEFINE VARIABLE cWhere AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hField AS HANDLE     NO-UNDO.

   FOR EACH bttFilter
     BY iSeq:
     IF bttFilter.cFromValue = "":U AND
        bttFilter.cToValue = "":U THEN
       NEXT.
     IF bttFilter.cFromValue <> "":U AND
        bttFilter.cToValue = "":U THEN
       bttFilter.cToValue = bttFilter.cFromValue.
     hField = bttFilter.hField.
     cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
            + hField:NAME + " ":U.

     CASE hField:DATA-TYPE:
       WHEN "CHARACTER":U THEN
       DO:
         IF bttFilter.cToValue = bttFilter.cFromValue THEN
           cWhere = cWhere + " BEGINS ":U + QUOTER(bttFilter.cToValue).
         ELSE
           cWhere = cWhere + " >= ":U + QUOTER(bttFilter.cFromValue) + " AND ":U 
                  + hField:NAME + " <= ":U + QUOTER(bttFilter.cToValue).
       END.
       WHEN "DATE":U THEN
       DO:
         IF bttFilter.cToValue = bttFilter.cFromValue THEN
           cWhere = cWhere + " = ":U + QUOTER(bttFilter.cToValue).
         ELSE
           cWhere = cWhere + " >= ":U + QUOTER(bttFilter.cFromValue) + " AND ":U 
                  + hField:NAME + " <= ":U + QUOTER(bttFilter.cToValue).
       END.
       OTHERWISE
       DO:
         IF bttFilter.cToValue = bttFilter.cFromValue THEN
           cWhere = cWhere + " = ":U + QUOTER(bttFilter.cToValue).
         ELSE
           cWhere = cWhere + " >= ":U + QUOTER(bttFilter.cFromValue) + " AND ":U 
                  + hField:NAME + " <= ":U + QUOTER(bttFilter.cToValue).
       END.
     END.
   END.

   PUBLISH "applyFilter":U (cWhere).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilter wiWin 
PROCEDURE buildFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTitle  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCol     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFld     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lProdMod AS LOGICAL    NO-UNDO.
  DEFINE BUFFER bttFilter FOR ttFilter.

  
  {&WINDOW-NAME}:TITLE = "Filter Records For " + pcTitle.

  CLOSE QUERY {&BROWSE-NAME}.
  EMPTY TEMP-TABLE bttFilter.

  DO WITH FRAME {&FRAME-NAME}:

    REPEAT iCount = 1 TO gphBrowse:NUM-COLUMNS:
      hCol = gphBrowse:GET-BROWSE-COLUMN(iCount).
      hFld = hCol:BUFFER-FIELD.
      IF hFld:NAME = "product_module_obj":U OR
         hFld:NAME = "product_module_code":U THEN
        lProdMod = YES.

      CREATE bttFilter.
      ASSIGN
        bttFilter.hBrowseCol  = hCol
        bttFilter.hField      = hFld
        bttFilter.cFieldName  = hFld:NAME
        bttFilter.cFieldLabel = REPLACE(hFld:COLUMN-LABEL,"!":U," ":U)
        bttFilter.cFromValue  = "":U
        bttFilter.cToValue    = "":U
        bttFilter.iSeq        = iCount
      .
    END.

    deProdMod:SENSITIVE = lProdMod.
    deProdMod = 0.
    DISPLAY deProdMod.

  END.
  OPEN QUERY {&BROWSE-NAME} 
    FOR EACH ttFilter NO-LOCK BY iSeq.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildProductMod wiWin 
PROCEDURE buildProductMod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE  BUFFER bgsc_product_module FOR gsc_product_module.

  DO WITH FRAME {&FRAME-NAME}:
    deProdMod:LIST-ITEM-PAIRS = "<All>,0".
    FOR EACH bgsc_product_module NO-LOCK
      BY bgsc_product_module.product_module_code:
      deProdMod:ADD-LAST( bgsc_product_module.product_module_code, bgsc_product_module.product_module_obj).
    END.

  END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearFilter wiWin 
PROCEDURE clearFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE BUFFER bttFilter FOR ttFilter.

   FOR EACH bttFilter:
     ASSIGN
       bttFilter.cFromValue = "":U
       bttFilter.cToValue = "":U
     .
   END.

   OPEN QUERY {&BROWSE-NAME} 
     FOR EACH ttFilter NO-LOCK BY iSeq.

   RUN applyFilter.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  DISPLAY deProdMod 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE buClear buApply deProdMod brFilter 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN buildProductMod.
  
  RUN SUPER.

  SUBSCRIBE PROCEDURE gphSource TO "applyFilter":U IN THIS-PROCEDURE.

  RUN buildFilter (gpcTitle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilterVal wiWin 
PROCEDURE setFilterVal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE  BUFFER bgsc_product_module FOR gsc_product_module.
  DEFINE  BUFFER bttFilter FOR ttFilter.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      deProdMod
      .

    FIND FIRST bttFilter 
      WHERE bttFilter.cFieldName = "product_module_obj":U
      NO-ERROR.
    
    IF AVAILABLE(bttFilter) THEN
    DO:
      IF deProdMod > 0 THEN
        ASSIGN
          bttFilter.cFromValue = STRING(deProdMod)
          bttFilter.cToValue   = STRING(deProdMod)
        .
      ELSE
        ASSIGN          
          bttFilter.cFromValue = "":U
          bttFilter.cToValue   = "":U
        .
    END.
    ELSE
    DO:
      FIND FIRST bttFilter 
        WHERE bttFilter.cFieldName = "product_module_code":U
        NO-ERROR.
      FIND FIRST bgsc_product_module 
        WHERE bgsc_product_module.product_module_obj = deProdMod
        NO-ERROR.
      IF AVAILABLE(bttFilter) THEN
      DO:
        IF AVAILABLE(bgsc_product_module) THEN
          ASSIGN
            bttFilter.cFromValue = bgsc_product_module.product_module_code
            bttFilter.cToValue   = bgsc_product_module.product_module_code
          .
        ELSE
          ASSIGN
            bttFilter.cFromValue = "":U
            bttFilter.cToValue   = "":U
          .
      END.
        
    END.

    BROWSE {&BROWSE-NAME}:REFRESH().

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

