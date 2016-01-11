&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Dynamics Dynamic TreeView Container. No new instances of this should be created. Use the Dynamics TreeView Wizard Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" wWin _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*---------------------------------------------------------------------------------
  File: rydyntreew.w

  Description:  Dynamic TreeView Object Control
  
  Purpose:      Dynamic TreeView Object Control

  Parameters:

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/23/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3227 - Entry 2 out of range errs treeview

  (v:010001)    Task:    90000163   UserRef:    
                Date:   04/0072001  Author:     Mark Davies

  Update Notes: TreeView - Enhancements - Bug fixes
                Add new SmartTreeView class object

  (v:010002)    Task:           0   UserRef:    
                Date:   10/26/2001  Author:     Mark Davies

  Update Notes: Fix to work with -E 'European Numeric' format.

  (v:010003)    Task:           0   UserRef:    IZ#2754
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: Problem when initializing objects where the extension is now saved in the object_extension field.
                Made changes to returnSDOName() to accomondate for these objects

  (v:010004)    Task:           0   UserRef:    
                Date:   11/05/2001  Author:     Mark Davies (MIP)

  Update Notes: Some very strange behavior caused the UI Event SDO to add it's own key field as a foreign field.
                Added some code to check for this occurrence and rectify where possible.

  (v:010005)    Task:           0   UserRef:    
                Date:   11/06/2001  Author:     Mark Davies (MIP)

  Update Notes: Made change to check for any toolbars on page 0 when not running as a menu MDI to redirect that toolbar's handle to the existing folder toolbar.

  (v:010006)    Task:           0   UserRef:    
                Date:   11/07/2001  Author:     Mark Davies (MIP)

  Update Notes: Removed dependancy from TreeView Controller.

  (v:010007)    Task:           0   UserRef:    
                Date:   11/07/2001  Author:     Mark Davies (MIP)

  Update Notes: Remove RUN SUPER in updateState. This isn't used anymore since the TV Controller is not it's super anymore.

  (v:010008)    Task:           0   UserRef:    
                Date:   11/07/2001  Author:     Mark Davies (MIP)

  Update Notes: The code that creates the links assumed that there should always be an Update link where there is a Data link.
                Fixed this code to make sure that the object needs an Update link before adding such a link.

  (v:010009)    Task:           0   UserRef:    
                Date:   11/23/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3223 - Property not defined with treeview

  (v:010010)    Task:           0   UserRef:    
                Date:   12/03/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3377 - Sizing errors on startup of Repository Maintenance in -E session - tool unusable

  (v:010011)    Task:           0   UserRef:    
                Date:   12/04/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3387 - Right mouse click for Add only on childless nodes in ROM treeview - inconsistent
                Fixed issue #3395 - Error message when running treeview container with menu in it

  (v:010012)    Task:           0   UserRef:    
                Date:   01/14/2002  Author:     Mark Davies

  Update Notes: Fixed issue #3628 - Dynamic treeview container with menu items based on relative layout problem

  (v:010013)    Task:           0   UserRef:    
                Date:   01/09/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3660 - Treeview filtering fails with FCS

  (v:010014)    Task:           0   UserRef:    
                Date:   01/17/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3712 - Node text is not trimmed when substituting with database values.

  (v:010015)    Task:           0   UserRef:    
                Date:   01/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3704 - Can't translate text treeview items.
                Allow translation of plain text nodes.

  (v:010016)    Task:           0   UserRef:    
                Date:   01/28/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3786 - errors generated when trying to resize a treeview that display a folder window

  (v:010017)    Task:           0   UserRef:    
                Date:   02/15/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3955 - Data Source (Parent SDO) is lost in Dynamic TreeView

-----------------------------------------------------------------*/
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

&scop object-name       rydyntreew.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamiccontainer yes

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* include temp-table definitions */

{af/sup2/afrun2.i &DEFINE-ONLY=YES}
{af/sup2/afcheckerr.i &DEFINE-ONLY=YES}
{af/sup2/afglobals.i}
{ry/app/rycsofetch.i}

/* Define temp-tables required */
{ry/inc/rytrettdef.i}

DEFINE TEMP-TABLE tt_tree_object_instance LIKE tt_object_instance.

DEFINE TEMP-TABLE tt_exclude_page_instance LIKE tt_page_instance
  FIELDS iOldPageNo AS INTEGER.

DEFINE TEMP-TABLE tt_view_page_instance LIKE tt_page_instance.

DEFINE TEMP-TABLE tt_view_page LIKE tt_page.

DEFINE TEMP-TABLE ttNonTreeObjects NO-UNDO
  FIELDS hObjectHandle AS HANDLE.

DEFINE TEMP-TABLE ttDataLinks NO-UNDO
  FIELDS hSourceHandle  AS HANDLE
  FIELDS hTargetHandle  AS HANDLE
  FIELDS lUpdateLink    AS LOGICAL.
  
&SCOPED-DEFINE SDO-TYPE-CODE SmartDataObject
&GLOBAL-DEFINE xpLogicalObjectName

DEFINE VARIABLE glOnceOnlyDone AS LOGICAL INITIAL FALSE.
DEFINE VARIABLE glInitialised AS LOGICAL INITIAL FALSE.

DEFINE NEW GLOBAL SHARED VARIABLE gsh_LayoutManager AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gsh_LayoutManagerID AS INTEGER.

IF NOT VALID-HANDLE(gsh_LayoutManager) 
OR gsh_LayoutManager:UNIQUE-ID <> gsh_LayoutManagerID THEN 
DO: 
    RUN ry/prc/rylayoutsp.p PERSISTENT SET gsh_LayoutManager.
    IF VALID-HANDLE(gsh_LayoutManager) THEN ASSIGN gsh_LayoutManagerID = gsh_LayoutManager:UNIQUE-ID.
END.

DEFINE VARIABLE ghTableioSource       AS HANDLE  NO-UNDO.
DEFINE VARIABLE gdMinimumWindowWidth  AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMinimumWindowHeight AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMaximumWindowWidth  AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMaximumWindowHeight AS DECIMAL INITIAL ?.

DEFINE VARIABLE gdMinimumFolderWidth AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMinimumFolderHeight AS DECIMAL INITIAL ?.

DEFINE VARIABLE gcLaunchLogicalObject AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcLaunchRunAttribute  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcValueList           AS CHARACTER NO-UNDO.

DEFINE VARIABLE gcContainerMode       AS CHARACTER NO-UNDO.

DEFINE VARIABLE gcObjectHandles       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcToolbarHandles      AS CHARACTER    NO-UNDO.

DEFINE VARIABLE ghContainerToolbar    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTreeViewOCX         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFolderToolbar       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFilterViewer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFolder              AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcTreeLayoutCode      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcLogicalObjectName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcInstanceAttributes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOldSDOName          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE glMenuMaintenance     AS LOGICAL    NO-UNDO INIT FALSE.
DEFINE VARIABLE glTreeViewDefaults    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE ghDefaultMenuBar      AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcCurrentOEM          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCurrentRecordObj    AS DECIMAL    NO-UNDO.

DEFINE VARIABLE gcCurrentNodeKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrExpandNodeKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastLaunchedNode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcParentNode          AS CHARACTER  NO-UNDO.


DEFINE VARIABLE gcWindowName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFolderTitle         AS CHARACTER  NO-UNDO.


DEFINE VARIABLE gcFilterValue AS CHARACTER  NO-UNDO.

{af/app/afttsecurityctrl.i}
{af/app/aftttranslate.i}

DEFINE VARIABLE glAutoSort          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glHideSelection     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glShowRootLines     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glShowCheckBoxes    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE giImageHeight       AS INTEGER    NO-UNDO.
DEFINE VARIABLE giImageWidth        AS INTEGER    NO-UNDO.
DEFINE VARIABLE giTreeStyle         AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcRootNodeCode      AS CHARACTER  NO-UNDO.
                                    
DEFINE VARIABLE gcCurrentMode       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcNewContainerMode  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcState             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSDOHandle         AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcObjectName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPrimarySDOName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDelete            AS LOGICAL    NO-UNDO.

DEFINE VARIABLE ghOverridenSubMenu  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCurrentLabel      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glExpand            AS LOGICAL    NO-UNDO INITIAL TRUE.

DEFINE VARIABLE glFilterApplied     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gdResizeCol         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glNewChildNode      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glReposSDO          AS LOGICAL    NO-UNDO.

DEFINE VARIABLE glNoMessage         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gdNodeObj           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdMinInstanceWidth  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdMinInstanceHeight AS DECIMAL    NO-UNDO.

PROCEDURE GetSysColor EXTERNAL "user32":
  define input parameter nIn as LONG.
  define return parameter nCol as LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiResizeFillIn fiTitle rctBorder 
&Scoped-Define DISPLAYED-OBJECTS fiResizeFillIn fiTitle 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD childWindowsOpen wWin 
FUNCTION childWindowsOpen RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoSort wWin 
FUNCTION getAutoSort RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerHandle wWin 
FUNCTION getContainerHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerMode wWin 
FUNCTION getContainerMode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerObjectHandles wWin 
FUNCTION getContainerObjectHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldList wWin 
FUNCTION getFieldList RETURNS CHARACTER
  (pcForeignFields AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle wWin 
FUNCTION getFrameHandle RETURNS HANDLE
  ( ip_procedure_handle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideSelection wWin 
FUNCTION getHideSelection RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageHeight wWin 
FUNCTION getImageHeight RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImageWidth wWin 
FUNCTION getImageWidth RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceObjectId wWin 
FUNCTION getInstanceObjectId RETURNS DECIMAL
    ( phProcedureHandle     AS HANDLE    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalObjectName wWin 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMainTableObj wWin 
FUNCTION getMainTableObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNodeDetails wWin 
FUNCTION getNodeDetails RETURNS CHARACTER
  ( INPUT phTable   AS HANDLE,
    INPUT pcNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectVersionNumber wWin 
FUNCTION getObjectVersionNumber RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRootNodeCode wWin 
FUNCTION getRootNodeCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunTimeAttribute wWin 
FUNCTION getRunTimeAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowCheckBoxes wWin 
FUNCTION getShowCheckBoxes RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowRootLines wWin 
FUNCTION getShowRootLines RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioSource wWin 
FUNCTION getTableioSource RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHandles wWin 
FUNCTION getToolbarHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTranslatableNodes wWin 
FUNCTION getTranslatableNodes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeRunAttribute wWin 
FUNCTION getTreeRunAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeStyle wWin 
FUNCTION getTreeStyle RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnSDOName wWin 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoSort wWin 
FUNCTION setAutoSort RETURNS LOGICAL
  ( INPUT plAutoSort AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerMode wWin 
FUNCTION setContainerMode RETURNS LOGICAL
  ( INPUT cContainerMode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideSelection wWin 
FUNCTION setHideSelection RETURNS LOGICAL
  ( INPUT plHideSelection AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageHeight wWin 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT piImageHeight AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageWidth wWin 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT piImageWidth AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogicalObjectName wWin 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( INPUT cObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNodeExpanded wWin 
FUNCTION setNodeExpanded RETURNS LOGICAL
  ( INPUT pcNode         AS CHARACTER,
    INPUT plNodeExpanded AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRootNodeCode wWin 
FUNCTION setRootNodeCode RETURNS LOGICAL
  ( INPUT pcRootNodeCode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunAttribute wWin 
FUNCTION setRunAttribute RETURNS LOGICAL
  ( INPUT pcRunAttr AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowCheckBoxes wWin 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( INPUT plShowCheckBoxes AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowRootLines wWin 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( INPUT plShowRootLines AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusBarText wWin 
FUNCTION setStatusBarText RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER,
    INPUT pcLabel   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableioSource wWin 
FUNCTION setTableioSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTemplateObjectName wWin 
FUNCTION setTemplateObjectName RETURNS LOGICAL
  ( INPUT pcTemplateObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTreeStyle wWin 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( INPUT piTreeStyle AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupFolderPages wWin 
FUNCTION setupFolderPages RETURNS LOGICAL
  (pcLogicalObjectName  AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowName wWin 
FUNCTION setWindowName RETURNS LOGICAL
  ( pcWindowName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showMessages wWin 
FUNCTION showMessages RETURNS LOGICAL
  ( INPUT pcMessage AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toLogical wWin 
FUNCTION toLogical RETURNS LOGICAL
  ( INPUT pcText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_smarttreeview AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiResizeFillIn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.4 BY 10.29
     BGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 54 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE rctBorder
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 98 BY 10.48.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fiResizeFillIn AT ROW 1.48 COL 41 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiTitle AT ROW 1.57 COL 42.6 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     rctBorder AT ROW 1.38 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 10.95.


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
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.95
         WIDTH              = 99
         MAX-HEIGHT         = 39.19
         MAX-WIDTH          = 230.4
         VIRTUAL-HEIGHT     = 39.19
         VIRTUAL-WIDTH      = 230.4
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
ASSIGN 
       fiResizeFillIn:MOVABLE IN FRAME fMain          = TRUE
       fiResizeFillIn:READ-ONLY IN FRAME fMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  
  /* If ESC pressed on 1st window, application will exit - give chance to 
     abort this if windows open
  */
  IF NOT THIS-PROCEDURE:PERSISTENT AND childWindowsOpen() THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
    RUN askQuestion IN gshSessionManager (INPUT "There are child windows open - continue with exit of application?",    /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&Yes":U,         /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Exit Application":U, /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&No":U OR cButton = "No":U THEN RETURN NO-APPLY.
  END.
  
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
  ELSE APPLY "CLOSE":U TO THIS-PROCEDURE. /* ensure close down nicely */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON RIGHT-MOUSE-CLICK OF wWin
DO:
  /* We do not want the TreeView popup to appear on the window */
  DEFINE VARIABLE hPopupMenu AS HANDLE     NO-UNDO.

  ASSIGN hPopupMenu = {&WINDOW-NAME}:POPUP-MENU.
         {&WINDOW-NAME}:POPUP-MENU = ?.
  
  IF VALID-HANDLE( hPopupMenu ) THEN
    DELETE WIDGET hPopupMenu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  
  /* If close window - give chance to abort this if windows open */
  IF childWindowsOpen() THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.
    RUN askQuestion IN gshSessionManager (INPUT "The window you are closing has child windows open." + CHR(10) + "Do you want to continue to close this window and all its children?",    /* messages */
                                          INPUT "&Yes,&No":U,     /* button list */
                                          INPUT "&Yes":U,         /* default */
                                          INPUT "&No":U,          /* cancel */
                                          INPUT "Windows Open on EXIT":U, /* title */
                                          INPUT "":U,             /* datatype */
                                          INPUT "":U,             /* format */
                                          INPUT-OUTPUT cAnswer,   /* answer */
                                          OUTPUT cButton          /* button pressed */
                                          ).
    IF cButton = "&No":U OR cButton = "No":U THEN RETURN NO-APPLY.
  END.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin
DO:
    
    IF {&WINDOW-NAME}:WIDTH-CHARS < gdMinimumWindowWidth THEN
      {&WINDOW-NAME}:WIDTH-CHARS = gdMinimumWindowWidth.
      
    RUN resizeWindow.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiResizeFillIn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiResizeFillIn wWin
ON END-MOVE OF fiResizeFillIn IN FRAME fMain
DO:
  DEFINE VARIABLE hTreeViewFrame  AS HANDLE   NO-UNDO.
  /*
  ASSIGN {&WINDOW-NAME}:MIN-WIDTH-CHARS = {&WINDOW-NAME}:MIN-WIDTH-CHARS + (fiResizeFillIn:COL - gdResizeCol).
  */         
  RUN resizeWindow.
  
  /* Make sure the User does not resize the OCX smaller than the allowed size */
  {get ContainerHandle hTreeViewFrame h_SmartTreeView}.
  IF VALID-HANDLE(hTreeViewFrame) THEN DO:
    IF hTreeViewFrame:COL + hTreeViewFrame:WIDTH - .8 > fiResizeFillIn:COL THEN DO:
      ASSIGN fiResizeFillIn:COL = hTreeViewFrame:COL + hTreeViewFrame:WIDTH - .8.
      RUN resizeWindow.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiResizeFillIn wWin
ON START-MOVE OF fiResizeFillIn IN FRAME fMain
DO:
  ASSIGN gdResizeCol = fiResizeFillIn:COL.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
/* {src/adm2/windowmn.i} */


/* windowmn.i - New V9 Main Block code for objects which create windows.*/
/* Skip all of this if no window was created. */
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */

DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN DO:
    ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{af/sup2/aficonload.i}

    /* The CLOSE event can be used from inside or outside the procedure to  */
    /* terminate it.                                                        */
    ON CLOSE OF THIS-PROCEDURE 
    DO:
       RUN destroyObject.
       IF ERROR-STATUS:ERROR THEN
         RETURN NO-APPLY.
    END.

    /* This will bring up all the links of the current object */
    ON CTRL-ALT-SHIFT-HOME ANYWHERE
    DO:
        RUN displayLinks IN THIS-PROCEDURE.
    END.      

/* Execute this code only if not being run PERSISTENT, i.e., if in test mode
   of one kind or another or if this is a Main Window. Otherwise postpone 
   'initialize' until told to do so. */

&IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
&ENDIF
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
      /* Now enable the interface and wait for the exit condition.            */
        IF NOT THIS-PROCEDURE:PERSISTENT THEN
        DO: 
            
            ASSIGN
              gcLaunchLogicalObject = "":U
              gcLaunchRunAttribute = "":U
              .
            
            /* the logical object name is presumed to be the first entry of 
               session param, and the run attribute is the second (if present) */
            IF SESSION:PARAM <> "":U THEN
            DO:
              ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,SESSION:PARAMETER)).
              IF NUM-ENTRIES(SESSION:PARAMETER) >= 2 THEN
                ASSIGN
                  gcLaunchRunAttribute = TRIM(ENTRY(2,SESSION:PARAMETER)).                
            END.
            ELSE
            DO:
              /* Try and get launch logical object and run attribute from
                 session properties instead
              */
              gcValueList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                                 INPUT "launchlogicalobject,launchrunattribute":U,
                                                                 INPUT YES).
              ASSIGN
                gcLaunchLogicalObject = TRIM(ENTRY(1,gcValueList, CHR(3)))
                gcLaunchRunAttribute = TRIM(ENTRY(2,gcValueList, CHR(3)))
                .
            END.
            
            IF gcLaunchLogicalObject = "" THEN
            DO:
                MESSAGE "Cannot launch a dynamic object since SESSION:PARAMETER and/or the launchlogicalobject property does not contain a Logical Object Name.".
                RETURN.
            END.
               
            setLogicalObjectName(gcLaunchLogicalObject).
            IF gcLaunchRunAttribute <> "":U THEN setRunAttribute(gcLaunchRunAttribute).
        END.
  
        RUN initializeObject.
       
        IF NOT THIS-PROCEDURE:PERSISTENT THEN
           WAIT-FOR CLOSE OF THIS-PROCEDURE.
    END.
&IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
END.
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord wWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     We need to override this procedure to reposition the parent SDO
               to the correct record before we add. This needs to be done due
               to foreign fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNodeRef  AS CHARACTER  NO-UNDO.

  {get TreeDataTable hTable ghTreeViewOCX}.  
            
  ASSIGN cNodeDetail = getNodeDetails(hTable, gcParentNode).

  ASSIGN dNodeObj = DECIMAL(ENTRY(1,cNodeDetail,CHR(2))).
  
  gcNewContainerMode = "Add".
  /* Get Parent Node Info */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN DO:
    IF ttNode.run_attribute = "STRUCTURED":U THEN DO:
      cParentNodeRef = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "TAG":U,gcParentNode).
      DYNAMIC-FUNCTION("setUserProperty":U IN THIS-PROCEDURE, "ParentKeyValue":U, cParentNodeRef).
    END.
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
  END.
  /* We need to reposition the Parent SDO for the foreign Fields */
  RUN repositionParentSDO (INPUT cParentNodeSDO,
                           INPUT gcParentNode).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTTLinks wWin 
PROCEDURE addTTLinks :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOName       AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER tt_source_object_instance FOR tt_object_instance.
  DEFINE BUFFER tt_target_object_instance FOR tt_object_instance.
  DEFINE BUFFER btt_link                  FOR tt_link.
  
  DEFINE VARIABLE hSourceObject AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hTargetObject AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cLinks        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lLinkExists   AS LOGICAL      NO-UNDO.
  
  DEFINE VARIABLE cSourceType   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hToolbarTrg   AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSDOHandle    AS HANDLE       NO-UNDO.
  
  DEFINE VARIABLE hViewer AS HANDLE   NO-UNDO.
  
  EMPTY TEMP-TABLE ttLinksAdded.
  FOR EACH  tt_link
      WHERE tt_link.link_created = NO:
    
    FIND FIRST tt_source_object_instance
        WHERE tt_source_object_instance.object_instance_obj = tt_link.source_object_instance_obj NO-ERROR.

    FIND FIRST tt_target_object_instance
        WHERE tt_target_object_instance.object_instance_obj = tt_link.target_object_instance_obj NO-ERROR.

    hSourceObject = (IF AVAILABLE tt_source_object_instance THEN tt_source_object_instance.object_instance_handle ELSE THIS-PROCEDURE).
    hTargetObject = (IF AVAILABLE tt_target_object_instance THEN tt_target_object_instance.object_instance_handle ELSE THIS-PROCEDURE).

    IF tt_link.link_name = "Update" AND
       hTargetObject = THIS-PROCEDURE THEN
      NEXT.
    IF tt_link.link_name = "TableIO":U AND hSourceObject = ghFolderToolbar THEN
      SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "updateState"  IN hTargetObject.
    /* Link the primary viewer to the SDO */
    IF tt_link.link_name = "Data":U AND hSourceObject = THIS-PROCEDURE THEN
    DO:
      FIND FIRST ttRunningSDOs NO-LOCK
           WHERE ttRunningSDOs.cSDOName = pcSDOName 
           NO-ERROR.
      IF AVAILABLE ttRunningSDOs THEN DO:
        RUN addLink(ttRunningSDOs.hSDOHandle, "Data":U, hTargetObject).
        IF CAN-FIND(FIRST btt_link
                    WHERE btt_link.link_name = "Update":U
                    AND btt_link.source_object_instance_obj = tt_target_object_instance.object_instance_obj) THEN
          RUN addLink(hTargetObject, "Update":U, ttRunningSDOs.hSDOHandle).
      END.
    END.
    ELSE DO:
      lLinkExists = FALSE.
      
      /* The page link already exists, so do not add it again */
      IF tt_link.link_name BEGINS "Page":U THEN DO:
        IF DYNAMIC-FUNCTION("linkHandles":U, tt_link.link_name + "-Source":U) <> "":U THEN
          NEXT.
        ELSE 
          IF NOT VALID-HANDLE(hTargetObject) THEN hTargetObject = THIS-PROCEDURE.
      END.
      
      /* The toolbar target is currently a single object link 
         This need to be revisited.. */
      {get ObjectType cSourceType hSourceObject}.
      IF cSourceType MATCHES '*toolbar*':U THEN 
      DO:
        {get ToolbarTarget hToolbarTrg hSourceObject}.      
        IF VALID-HANDLE(hToolbarTrg) THEN
          {set ToolbarTarget ? hSourceObject}.
      END.
      
      /*IF tt_link.link_name = 'toolbar':U  */
      RUN addLink(hSourceObject, tt_link.link_name, hTargetObject).
      
      IF glMenuMaintenance AND 
         hTargetObject = THIS-PROCEDURE THEN
         NEXT.
      IF tt_link.link_name = "Navigation":U THEN DO: 
      
        FIND FIRST ttRunningSDOs NO-LOCK
             WHERE ttRunningSDOs.cSDOName = pcSDOName 
             NO-ERROR.
        
        IF AVAILABLE ttRunningSDOs THEN
          ASSIGN hSourceObject = THIS-PROCEDURE
                 hTargetObject = ttRunningSDOs.hSDOHandle.
      
        FIND FIRST ttLinksAdded
             WHERE ttLinksAdded.hSourceHandle = hSourceHandle 
             AND   ttLinksAdded.cLinkName     = tt_link.link_name
             AND   ttLinksAdded.hTargetHandle = hTargetHandle 
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttLinksAdded THEN DO:
          CREATE ttLinksAdded.
          ASSIGN ttLinksAdded.hSourceHandle = hSourceObject
                 ttLinksAdded.cLinkName     = tt_link.link_name
                 ttLinksAdded.hTargetHandle = hTargetObject.
          RUN addLink(hSourceObject, tt_link.link_name, hTargetObject).
        END.
      END. /* Navigation Links */
    END.
  END. /* FOR EACH tt_link */

  /* Ensure that this object does not send messages to the toolbar and that 
     the toolbar does not consider it to be an active TableioTarget */
  RUN LinkStateHandler('inactive':U,getTableioSource(),'TableioSource':U). 
  
  /** Add a Navigation link from the Folder Toolbar 
      to the Dynamic TreeView to trap ToolBar Navigation */
  lLinkExists = FALSE.
  ASSIGN cLinks = DYNAMIC-FUNCTION("linkHandles":U, "Navigation-Target":U).
  IF cLinks = "":U THEN
    lLinkExists = FALSE.
  DO iLoop = 1 TO NUM-ENTRIES(cLinks):
    ASSIGN hTargetObject = WIDGET-HANDLE(ENTRY(iLoop,cLinks)).
    IF VALID-HANDLE(hTargetObject) AND
       hTargetObject = THIS-PROCEDURE THEN
      lLinkExists = TRUE.
  END.
  IF lLinkExists = FALSE AND 
     VALID-HANDLE(ghFolderToolBar) THEN
    RUN addLink(ghFolderToolBar, "NAVIGATION":U, THIS-PROCEDURE).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dyntreeview.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AutoSortyesHideSelectionnoImageHeight16ImageWidth16ShowCheckBoxesnoShowRootLinesyesTreeStyle7ExpandOnAddnoFullRowSelectnoOLEDragnoOLEDropnoScrollyesSingleSelnoIndentation5LabelEdit1LineStyle1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_smarttreeview ).
       RUN repositionObject IN h_smarttreeview ( 1.48 , 2.20 ) NO-ERROR.
       RUN resizeObject IN h_smarttreeview ( 10.10 , 40.80 ) NO-ERROR.

       /* Links to SmartTreeView h_smarttreeview. */
       RUN addLink ( h_smarttreeview , 'TVController':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPopupMenu wWin 
PROCEDURE buildPopupMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdNodeObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hPopupMenu    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupItem    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRootNodeCode AS CHARACTER  NO-UNDO.

  ASSIGN hPopupMenu = {&WINDOW-NAME}:POPUP-MENU.
         {&WINDOW-NAME}:POPUP-MENU = ?.
  
  IF VALID-HANDLE( hPopupMenu ) THEN
    DELETE WIDGET hPopupMenu.

  CREATE MENU hPopupMenu
      ASSIGN
          POPUP-ONLY  = YES.
  
  /* Add option to add the different child node records */
  
  /* If Child Nodes are allowed, but none were Found, 
     Prompt user if if they want to add a new record */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttNode AND 
     ttNode.run_attribute = "STRUCTURED":U THEN DO:
    CREATE MENU-ITEM hPopupItem
        ASSIGN
            LABEL       = "&Add " + ttNode.node_label
            PARENT      = hPopupMenu
            SENSITIVE   = TRUE
        TRIGGERS:
            ON CHOOSE PERSISTENT RUN nodeAddRecord IN THIS-PROCEDURE ( INPUT ttNode.node_obj,
                                                                       INPUT INTEGER(DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U,pcNodeKey)),
                                                                       INPUT pcNodeKey).
        END TRIGGERS.
  END.
  ELSE DO:
    IF CAN-FIND(FIRST ttNode 
                WHERE ttNode.parent_node_obj = pdNodeObj
                AND   ttNode.data_source_type <> "TXT":U) THEN DO:
      FOR EACH   ttNode 
           WHERE ttNode.parent_node_obj = pdNodeObj
           AND   ttNode.data_source_type <> "TXT":U
           NO-LOCK:
        CREATE MENU-ITEM hPopupItem
            ASSIGN
                LABEL       = "&Add " + ttNode.node_label
                PARENT      = hPopupMenu
                SENSITIVE   = TRUE
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN nodeAddRecord IN THIS-PROCEDURE ( INPUT ttNode.node_obj,
                                                                           INPUT INTEGER(DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U,pcNodeKey)),
                                                                           INPUT pcNodeKey).
            END TRIGGERS.
      END.
    END. /* Prompt For Adding */
  END.
  


  /* Assign the new popup menu to the window */
  ASSIGN
      {&WINDOW-NAME}:POPUP-MENU = hPopupMenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord wWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Captures the event when an Add/Copy/Modify was cancelled.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hBuf    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hQry    AS HANDLE   NO-UNDO.

  IF glNewChildNode THEN DO:
    {get TreeDataTable hTable ghTreeViewOCX}.
    ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
    IF gcCurrentNodeKey <> ? THEN DO:
      CREATE QUERY hQry.  
      hQry:ADD-BUFFER(hBuf).
      hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,gcCurrentNodeKey)).
      hQry:QUERY-OPEN().
      hQry:GET-FIRST().
      
      IF hBuf:AVAILABLE THEN
        hBuf:BUFFER-DELETE().
      IF VALID-HANDLE(hQry) THEN
        DELETE OBJECT hQry.
    END.
    
    RUN deleteNode IN ghTreeViewOCX (gcCurrentNodeKey).
    DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, gcParentNode).
    RUN tvNodeSelected (gcParentNode).
  END.
    
  ASSIGN gcCurrentMode  = "Cancel"
         glNewChildNode = FALSE.
  
  gcNewContainerMode = "View".

  RUN setContainerViewMode.
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    RUN enableObject IN ghTreeViewOCX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkToolbarState wWin 
PROCEDURE checkToolbarState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerToolbar     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderToolbar        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSavedContainerMode   AS CHARACTER  NO-UNDO.
  
  hContainerToolbar = WIDGET-HANDLE(ENTRY(1,linkHandles("Navigation-Source"))).
  ghContainerToolbar = hContainerToolbar.

  ASSIGN hFolderToolbar = WIDGET-HANDLE(ENTRY(1,linkHandles("TableIO-Source")))
         ghFolderToolbar = hFolderToolbar.
  
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "cancelRecord":U IN ghFolderToolbar.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "addRecord":U    IN ghFolderToolbar.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "copyRecord":U   IN ghFolderToolbar.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "resetRecord":U  IN ghFolderToolbar.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "updateRecord":U IN ghFolderToolbar.
  
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "toolbar":U   IN ghContainerToolbar.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "toolbar":U   IN ghFolderToolbar.

  /* Make sure the FolderToolbar does not Auto Size */
  IF VALID-HANDLE(ghFolderToolbar) THEN DO:
    {set ToolbarAutoSize NO ghFolderToolbar}.
  END.

    IF VALID-HANDLE (hContainerToolbar) AND hContainerToolbar <> THIS-PROCEDURE THEN
    DO:
        /* go back into modify mode after an add is saved */
        IF gcContainerMode = "add":U OR
           gcContainerMode = "Copy":U THEN
        DO:
          ASSIGN cSavedContainerMode = "modify":U.
          {set savedContainerMode cSavedContainerMode}.
        END.
    
        CASE gcContainerMode:
            WHEN "view" THEN RUN setContainerViewMode.
            WHEN "modify" THEN RUN setContainerModifyMode.
            WHEN "Copy"   THEN PUBLISH 'copyRecord'   FROM hContainerToolbar.
            WHEN "Add"    THEN PUBLISH 'addRecord'    FROM hContainerToolbar.
        END CASE.
    END.

    /* Special case for container toolbar and view mode - put all other toolbars
       into view mode
    */
    

    /* see if navigation target of container toolbar is a valid SDO. If this is the case, then
       enable the navigation buttons on the container toolbar.
    */
    DEFINE VARIABLE hNavigateSdo AS HANDLE NO-UNDO.
    IF VALID-HANDLE(hContainerToolbar) THEN
      hNavigateSdo = DYNAMIC-FUNCTION("linkHandles" IN hContainerToolbar, 'Navigation-Target') NO-ERROR.
    
    IF VALID-HANDLE(hNavigateSdo) AND
       LOOKUP("openQuery":U, hNavigateSdo:INTERNAL-ENTRIES) <> 0 THEN
      RUN setbuttons IN hContainerToolbar("enable-nav":U).

    /* end of initialization - now turn off data links */

    PUBLISH 'ToggleData' (INPUT FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructTTInstances wWin 
PROCEDURE constructTTInstances :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInsanceAttributes AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piCurrentPage       AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hObjectHandle     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cToolbarBands     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFrom             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iTo               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLength           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lObjectIsAToolbar AS LOGICAL    NO-UNDO.
  
  /* Clear list of constructed objects on container */
  ASSIGN
    gcObjectHandles  = "":U
    gcToolbarHandles = "":U.                

IF glMenuMaintenance THEN
  gcLaunchRunAttribute = pcInsanceAttributes.

FOR EACH tt_object_instance EXCLUSIVE-LOCK
   WHERE tt_object_instance.PAGE_number          = piCurrentPage
     AND tt_object_instance.object_instance_obj <> 0
      BY tt_object_instance.PAGE_number 
      BY tt_object_instance.instance_order 
      BY tt_object_instance.layout_position :

  IF tt_object_instance.page_number <> ? THEN
      DYNAMIC-FUNCTION("setCurrentPage":U, INPUT tt_object_instance.page_number).
    ELSE
      DYNAMIC-FUNCTION("setCurrentPage":U, INPUT 0).
    
  hObjectHandle = ?.
            
  lObjectIsAToolbar = FALSE.
  IF glMenuMaintenance THEN
  IF INDEX(tt_object_instance.object_pathed_filename, "dyntool":U) <> 0 THEN
    lObjectIsAToolbar = TRUE.

  
  IF INDEX(tt_object_instance.object_pathed_filename, "dyntool":U) <> 0 THEN DO:
    IF tt_object_instance.layout_position = "TOP" THEN DO: 
      /** ORIGINAL 
      IF glMenuMaintenance AND 
         VALID-HANDLE(ghContainerToolbar) THEN DO:
        hObjectHandle = ghContainerToolbar.
      END.
      IF VALID-HANDLE(ghFolderToolbar) THEN 
        hObjectHandle = ghFolderToolbar.
      ****/      
      /*
      IF glMenuMaintenance AND 
         VALID-HANDLE(ghContainerToolbar) THEN DO:
        hObjectHandle = ghContainerToolbar.
      END.
      */
      
      /*    
      IF VALID-HANDLE(ghContainerToolbar) AND
         glMenuMaintenance THEN DO:
        ASSIGN iFrom         = INDEX(tt_object_instance.instance_attribute_list,"ToolbarBands")
               iTo           = INDEX(tt_object_instance.instance_attribute_list,CHR(3),iFrom)
               iLength       = iTo - iFrom
               cToolbarBands = SUBSTRING(tt_object_instance.instance_attribute_list,iFrom,iLength)
               NO-ERROR.
        /* Need to get new procedure name to do this 
        RUN deleteMenu2 IN ghContainerToolbar.
        */
        DYNAMIC-FUNCTION("setToolbarBands" IN ghContainerToolbar, ENTRY(2,cToolbarBands,CHR(4))) NO-ERROR.
        RUN initializeObject IN ghContainerToolbar.
      END.
      */
      
      
      IF VALID-HANDLE(ghFolderToolbar) AND 
         NOT glMenuMaintenance THEN 
        hObjectHandle = ghFolderToolbar.
    
    
      /* This piece of code ensures that any top toolbar will not
         be created - but redirected to use the current top
         toolbar instead */
      IF VALID-HANDLE(ghContainerToolbar) AND
         glMenuMaintenance THEN
        hObjectHandle = ghContainerToolbar.
    END.
    ELSE DO:
      IF NOT glMenuMaintenance THEN DO:
        IF tt_object_instance.page_number = 0 AND 
           VALID-HANDLE(ghFolderToolbar) THEN
          hObjectHandle = ghFolderToolbar.
      END.
    END.
  END.
  
  
  
  /** this needs to come back if I figure out what has changed **
  /* Also destory any menu-objects created for the previous launched object */
  IF VALID-HANDLE(ghFolderToolBar) AND
     LOOKUP("deleteMenu2":U,ghFolderToolBar:INTERNAL-ENTRIES) > 0 THEN
    RUN deleteMenu2 IN ghFolderToolBar.
  **/
  IF INDEX(tt_object_instance.object_pathed_filename, "afspfoldr":U) <> 0 AND 
     VALID-HANDLE(ghFolder) 
    AND NOT glMenuMaintenance THEN
    hObjectHandle = ghFolder.
  
  IF glMenuMaintenance AND 
    (tt_object_instance.db_aware OR  
     tt_object_instance.object_pathed_filename MATCHES "*o.w") THEN 
    gcPrimarySDOName = tt_object_instance.object_pathed_filename.
  IF hObjectHandle = ? THEN
    RUN constructObject (INPUT  tt_object_instance.object_pathed_filename + (IF tt_object_instance.db_aware OR  tt_object_instance.object_pathed_filename MATCHES "*o.w" THEN CHR(3) + "DBAWARE" ELSE ""),
                         INPUT  FRAME {&FRAME-NAME}:HANDLE,
                         INPUT  tt_object_instance.instance_attribute_list,
                         OUTPUT hObjectHandle).
  /** ALWAYS MAKE SURE ANY TOOLBAR STARTED IS NOT AUTO RESIZE **/
  IF lObjectIsAToolbar THEN 
    {set ToolbarAutoSize NO hObjectHandle}.
  
  IF tt_object_instance.page_number = 0 THEN DO:
    IF INDEX(tt_object_instance.object_pathed_filename, "afspfoldr":U) <> 0 AND 
       NOT VALID-HANDLE(ghFolder) 
      AND NOT glMenuMaintenance THEN
      ghFolder = hObjectHandle.
    IF INDEX(tt_object_instance.object_pathed_filename, "dyntool":U) <> 0 THEN DO:
      IF tt_object_instance.layout_position = "TOP" AND 
         NOT VALID-HANDLE(ghContainerToolbar) THEN DO:
        ghContainerToolbar = hObjectHandle.
      END.
      IF tt_object_instance.layout_position = "CENTRE" AND 
         NOT VALID-HANDLE(ghFolderToolbar) THEN DO:
        ghFolderToolbar = hObjectHandle.
      END.
    END.
  END.
  
  /** MAKE SURE THAT THE TREEVIEW OCX VIEWER KNOWS ABOUT THE SDO'S CREATED HERE **/
  IF INDEX(tt_object_instance.object_type_code,"sdo":U) <> 0 THEN DO:
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = tt_object_instance.object_pathed_filename
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttRunningSDOs THEN DO:
      CREATE ttRunningSDOs.
      ASSIGN ttRunningSDOs.cSDOName   = tt_object_instance.object_pathed_filename
             ttRunningSDOs.hSDOHandle = hObjectHandle.
    END.
  END.
  /* keep ordered list of objects constructed on container */
  IF VALID-HANDLE(hObjectHandle) THEN
    ASSIGN 
        gcObjectHandles = gcObjectHandles + (IF gcObjectHandles <> "":U THEN ",":U ELSE "":U) + STRING(hObjectHandle).
  
  IF VALID-HANDLE(hObjectHandle) AND INDEX(hObjectHandle:FILE-NAME, "dyntool":U) <> 0 THEN
    ASSIGN 
        gcToolbarHandles = gcToolbarHandles + (IF gcToolbarHandles <> "":U THEN ",":U ELSE "":U) + STRING(hObjectHandle).
  
  /* Start any custom super procedure if any */
  IF VALID-HANDLE(hObjectHandle) AND tt_object_instance.custom_super_procedure <> "":U THEN DO:
    {launch.i &PLIP = tt_object_instance.custom_super_procedure &OnApp = 'NO' &Iproc = '' &NewInstance = YES}
    IF VALID-HANDLE(hPlip) THEN
    DO:
       hObjectHandle:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).       
       ASSIGN tt_object_instance.custom_super_handle = hPlip
              tt_object_instance.destroy_custom_super = TRUE.

    END.
  END.

  IF VALID-HANDLE(hObjectHandle) THEN
    tt_object_instance.object_instance_handle = hObjectHandle.
  ELSE
    ASSIGN
        tt_object_instance.object_instance_handle = ?
        tt_object_instance.object_frame_handle    = ?.

  /* update page instance temp-table with correct handle */
  FOR EACH  tt_page_instance
      WHERE tt_page_instance.object_instance_obj = tt_object_instance.object_instance_obj:
    ASSIGN      
        tt_page_instance.object_instance_handle = tt_object_instance.object_instance_handle
        tt_page_instance.object_type_code       = tt_object_instance.object_type_code.
  END. /* FOR EACH tt_page_instance */
END. /* FOR EACH tt_object_instance */

/* Set THIS-PROCEDURE */
FOR EACH tt_object_instance EXCLUSIVE-LOCK
   WHERE tt_object_instance.PAGE_number         = piCurrentPage
     AND tt_object_instance.object_instance_obj = 0:
  ASSIGN tt_object_instance.object_instance_handle = THIS-PROCEDURE.
  FOR EACH  tt_page_instance
      WHERE tt_page_instance.object_instance_obj = tt_object_instance.object_instance_obj:
    ASSIGN      
        tt_page_instance.object_instance_handle = tt_object_instance.object_instance_handle
        tt_page_instance.object_type_code       = tt_object_instance.object_type_code.
  END. /* FOR EACH tt_page_instance */
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord wWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     We need to override this procedure to reposition the parent SDO
               to the correct record before we add. This needs to be done due
               to foreign fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO  AS CHARACTER  NO-UNDO.
  
  {get TreeDataTable hTable ghTreeViewOCX}.  
            
  ASSIGN cNodeDetail = getNodeDetails(hTable, gcParentNode).

  ASSIGN dNodeObj = DECIMAL(ENTRY(1,cNodeDetail,CHR(2))).
  
  gcNewContainerMode = "Copy".
  
  /* Get Parent Node Info */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.
  
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U THEN ttNode.data_source ELSE ttNode.primary_sdo.
  /* We need to reposition the Parent SDO for the foreign Fields */
  RUN repositionParentSDO (INPUT cParentNodeSDO,
                           INPUT gcParentNode).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDummyChild wWin 
PROCEDURE createDummyChild :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBuf           AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcType          AS CHARACTER  NO-UNDO.
  
  
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  

  ASSIGN hParentNodeKey = phBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = phBuf:BUFFER-FIELD('node_key':U)
         hNodeLabel     = phBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = phBuf:BUFFER-FIELD('record_ref':U)
         hNodeInsert    = phBuf:BUFFER-FIELD('node_insert':U).
         
  phBuf:BUFFER-CREATE().
  ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
         hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
         hNodeLabel:BUFFER-VALUE     = IF pcType = "New":U THEN "<New>":U ELSE "+":U
         hRecordRef:BUFFER-VALUE     = IF pcType = "New":U THEN 0 ELSE 99
         hNodeInsert:BUFFER-VALUE    = 4.

  IF pcType = "NEW":U THEN
    ASSIGN gcParentNode     = pcParentNodeKey
           gcCurrentNodeKey = hNodeKey:BUFFER-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN glOnceOnlyDone = TRUE. /* used when initializing page 0 */

DEFINE BUFFER tt_source_object_instance FOR tt_object_instance.
DEFINE BUFFER tt_target_object_instance FOR tt_object_instance.

DEFINE VARIABLE cLocalAttributes    AS CHARACTER    NO-UNDO.                                                      
DEFINE VARIABLE cLogicalObjectName  AS CHARACTER    NO-UNDO.                                                      
DEFINE VARIABLE lv_object_handle    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hSourceObject       AS HANDLE       NO-UNDO.
DEFINE VARIABLE hTargetObject       AS HANDLE       NO-UNDO.

DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.

DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPhysicalObject     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCurrentPage        AS INTEGER      NO-UNDO.
DEFINE VARIABLE iStartPage          AS INTEGER      NO-UNDO.
DEFINE VARIABLE lResized            AS LOGICAL      NO-UNDO.

DEFINE VARIABLE lMenuController     AS LOGICAL    NO-UNDO.

/* For the TreeView - we will only come in here once during initialization */
/* For any page changes we will need to run createRepositoryObjects */
IF getCurrentPage() <> 0 THEN
  RETURN.

/* Code placed here will execute PRIOR to standard behavior. */

RUN SUPER.


/* get logical object name once only and store in a variable */
ASSIGN 
  cLogicalObjectName = getLogicalObjectName().

ASSIGN
  iCurrentPage = getCurrentPage()
  iStartPage = iCurrentPage
  lResized = NO.

IF iCurrentPage = 0 THEN DO:    
  /* get attributes for all objects on all pages. This is so that we only have a single
     appserver hit for the entire container for retrieving its dynamic properties from 
     the repository - instead of getting a hit per page */
  RUN getObjectAttributes IN gshRepositoryManager (INPUT  cLogicalObjectName,
                                                   OUTPUT TABLE tt_object_instance,
                                                   OUTPUT TABLE tt_page,
                                                   OUTPUT TABLE tt_page_instance,
                                                   OUTPUT TABLE tt_link,
                                                   OUTPUT TABLE ttAttributeValue,
                                                   OUTPUT TABLE ttUiEvent         ) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
      {af/sup2/afcheckerr.i &NO-RETURN=YES}
      RUN destroyObject.
      RETURN.
  END.
  
  ASSIGN cLocalAttributes = "":U.
  
  /* get attributes that are for the container itself - special instance record with 0 object number */
  FIND FIRST tt_object_instance 
       WHERE tt_object_instance.object_instance_obj = 0
       NO-ERROR.
  IF AVAILABLE tt_object_instance THEN
    ASSIGN cLocalAttributes = tt_object_instance.instance_attribute_list. 
  
  ASSIGN
      lMenuController = NO.
  
  RUN setLocalAttributes(cLocalAttributes).
  
  /* clear list of constructed objects on container */
  ASSIGN gcObjectHandles  = "":U
         gcToolbarHandles = "":U.
  
  FIND FIRST tt_page WHERE tt_page.page_number = 0 NO-ERROR.
  IF AVAILABLE tt_page THEN
  DO:
    {set Page0LayoutManager tt_page.layout_code}.
  END.

END. /* page = 0 */

/* start off by making the frame's virtual dimensions very big */

ASSIGN
    FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = SESSION:WIDTH + 1
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = SESSION:HEIGHT + 1
    FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE.
    
/* work out the start page and if pages exists */
FIND FIRST tt_page WHERE tt_page.page_number > 0 NO-ERROR.
IF AVAILABLE tt_page THEN
  ASSIGN iStartPage = tt_page.page_number.

/* set page initialized flag */
FIND FIRST tt_page 
     WHERE tt_page.page_number = iCurrentPage 
     NO-ERROR.
IF AVAILABLE tt_page THEN
  tt_page.page_initialized = YES.

/* Construct the objects based on the tt_object_instance temp-table*/
RUN constructTTInstances (INPUT "?":U, 0) NO-ERROR.

/*****
/* loop through instances on page and create objects on them */
FOR EACH  tt_object_instance
    WHERE tt_object_instance.page_number          = iCurrentPage
    AND   tt_object_instance.object_instance_obj <> 0
    BY    tt_object_instance.page_number
    BY    tt_object_instance.instance_order
    BY    tt_object_instance.page_number.layout_position:

  IF tt_object_instance.object_pathed_filename = "ry/obj/rystatusbv.w" THEN
    ASSIGN
        lMenuController = YES.

  IF tt_object_instance.page_number <> ? THEN
    DYNAMIC-FUNCTION("setCurrentPage":U, INPUT tt_object_instance.page_number).
  ELSE
    DYNAMIC-FUNCTION("setCurrentPage":U, INPUT 0).
  
  
  /* Deal with defaults */
  IF tt_object_instance.layout_position = "":U           AND 
     INDEX(instance_attribute_list,"ADM2Navigation") > 0 THEN
    ASSIGN tt_object_instance.layout_position = "TOP".
  ELSE
    IF tt_object_instance.layout_position = "":U         AND 
       INDEX(instance_attribute_list,"BROWSESEARCH") > 0 THEN
      ASSIGN tt_object_instance.layout_position = "BOTTOM".
    ELSE
      IF tt_object_instance.layout_position = "" THEN
        tt_object_instance.layout_position = "CENTRE".

  /* set instantiation order */
  IF INDEX(tt_object_instance.object_type_code,"sdo":U) <> 0 THEN
    ASSIGN tt_object_instance.instance_order = 1.
  ELSE
    IF INDEX(tt_object_instance.object_type_code,"toolbar":U) <> 0 THEN
    DO:
      IF tt_object_instance.layout_position BEGINS "top":U THEN
        ASSIGN tt_object_instance.instance_order = 2.
      ELSE
        ASSIGN tt_object_instance.instance_order = 3.
    END.
    ELSE
      IF INDEX(tt_object_instance.object_type_code,"smartfolder":U) <> 0 THEN
        ASSIGN tt_object_instance.instance_order = 4.
      ELSE
        ASSIGN tt_object_instance.instance_order = 99.

  /* set page */
  FIND FIRST tt_page_instance
       WHERE tt_page_instance.object_instance_obj = tt_object_instance.object_instance_obj
       NO-ERROR.
  IF AVAILABLE tt_page_instance THEN
    ASSIGN tt_object_instance.page_number = tt_page_instance.page_number.
  ELSE
    ASSIGN tt_object_instance.page_number = 0.
    
  /* add page to layout if not there already */
  IF tt_object_instance.page_number > 0 AND NUM-ENTRIES(tt_object_instance.layout_position) = 1 THEN
    ASSIGN tt_object_instance.layout_position = tt_object_instance.layout_position + ",":U + TRIM(STRING(tt_object_instance.page_number)).
      
END.
  
  FOR EACH tt_page_instance,
     FIRST tt_object_instance
     WHERE tt_object_instance.object_instance_obj = tt_page_instance.object_instance_obj:
    
    ASSIGN tt_page_instance.layout_position = tt_object_instance.layout_position.
  END.

  FOR EACH tt_page_instance,
     FIRST tt_object_instance 
     WHERE tt_object_instance.object_instance_obj = tt_page_instance.object_instance_obj:
      
    ASSIGN      
        tt_page_instance.object_instance_handle = tt_object_instance.object_instance_handle
        tt_page_instance.object_type_code       = tt_object_instance.object_type_code.
  END. /* FOR EACH tt_page_instance */
*********/

  /* Add the required links */
  RUN addTTLinks (INPUT "":U) NO-ERROR.
  
  /*********
  /* force child object initialization to take place now */
  FOR EACH tt_page WHERE tt_page.page_number <> 0:
    RUN hidePage(tt_page.page_number).
  END.

  /* pass SdoForeignFields to any SDO's with a data link from THIS-PROCEDURE */
  RUN passSDOForeignFields (INPUT "":U).
                                 
  RUN selectPage(1).
            ***********/
  /* the last thing we do is pack the frame to the size of its contents.  The actual work performed here will
  be subject to the chosen layout managers */
  
  FIND FIRST tt_page WHERE tt_page.page_number = 0 NO-ERROR.
  IF AVAILABLE tt_page THEN
  DO:
    gcTreeLayoutCode = tt_page.layout_code.
    {set Page0LayoutManager tt_page.layout_code}.
  END.
  
  RUN checkToolbarState.
  /* Set the container and frame's minimum and maximum width and height */
  IF NOT glMenuMaintenance THEN
    RUN setMinMaxDefaults (INPUT  lMenuController,
                           OUTPUT cProfileData).

  RUN packWindow IN THIS-PROCEDURE (INPUT 0, NOT(NUM-ENTRIES(cProfileData, CHR(3)) = 4)).

  IF VALID-HANDLE(ghFolderToolBar) THEN
    RUN viewObject IN ghFolderToolBar.
  /* Resize and place window on previous saved settings */
  RUN resizeAndPositionWindow (INPUT lMenuController,
                               INPUT cProfileData).
  RUN setTreeViewWidth.
FOR EACH tt_object_instance
    NO-LOCK:
  CREATE tt_tree_object_instance.
  BUFFER-COPY tt_object_instance TO 
              tt_tree_object_instance.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRepositoryObjects wWin 
PROCEDURE createRepositoryObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName               AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phCallingProcedure      AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcInsanceAttributes     AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER tt_source_object_instance FOR tt_object_instance.
  DEFINE BUFFER tt_target_object_instance FOR tt_object_instance.
  
  DEFINE VARIABLE cLocalAttributes    AS CHARACTER    NO-UNDO.                                                      
  DEFINE VARIABLE lv_object_handle    AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSourceObject       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hTargetObject       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lMenuController     AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPhysicalObject     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectHandles      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cToolbarHandles     AS CHARACTER    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  glTreeViewDefaults = FALSE.
  
  DYNAMIC-FUNCTION("setContainerMode":U, "View":U).
  RUN setContainerViewMode.
  /* The Objects are already running, do not instantiate them again */
  IF gcLogicalObjectName = pcLogicalObjectName AND 
     gcInstanceAttributes = pcInsanceAttributes AND
     gcPrimarySDOName    = pcSDOName THEN RETURN.

  FIND FIRST ttRunningSDOs 
       WHERE ttRunningSDOs.cSDOName = pcSDOName
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttRunningSDOs AND
     VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
    ghSDOHandle = ttRunningSDOs.hSDOHandle.

  /* A new logical Object was chosen. Close down the currently running Objects and start the new ones */
  
  RUN destroyNonTreeObjects.
  
  ASSIGN gcLogicalObjectName = pcLogicalObjectName
         gcInstanceAttributes = pcInsanceAttributes
         gcPrimarySDOName    = pcSDOName
         gcOldSDOName        = pcSDOName.
  
  RUN getObjectAttributes IN gshRepositoryManager (INPUT pcLogicalObjectName,
                                                   OUTPUT TABLE tt_object_instance,
                                                   OUTPUT TABLE tt_page,
                                                   OUTPUT TABLE tt_page_instance,
                                                   OUTPUT TABLE tt_link,
                                                   OUTPUT TABLE ttAttributeValue,
                                                   OUTPUT TABLE ttUiEvent) NO-ERROR.
  
  IF ERROR-STATUS:ERROR THEN
  DO:
    {af/sup2/afcheckerr.i &NO-RETURN=YES}
    RUN destroyObject.
    RETURN.
  END.

  ASSIGN cLocalAttributes = "":U.
  
  /* get attributes that are for the container itself - special instance record with 0 object number */
  FIND FIRST tt_object_instance 
       WHERE tt_object_instance.object_instance_obj = 0
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE tt_object_instance THEN
    ASSIGN cLocalAttributes = tt_object_instance.instance_attribute_list
           tt_object_instance.object_instance_handle = THIS-PROCEDURE. 
  
  ASSIGN
      lMenuController = NO.

  RUN setLocalAttributes(cLocalAttributes).

  /***
  FOR EACH tt_object_instance:

    IF tt_object_instance.object_pathed_filename = "ry/obj/rystatusbv.w" THEN
      ASSIGN
          lMenuController = YES.

    
    /* Deal with defaults */
    IF tt_object_instance.layout_position = "":U           AND 
       INDEX(instance_attribute_list,"ADM2Navigation") > 0 THEN
      ASSIGN tt_object_instance.layout_position = "TOP".
    ELSE
      IF tt_object_instance.layout_position = "":U         AND 
         INDEX(instance_attribute_list,"BROWSESEARCH") > 0 THEN
        ASSIGN tt_object_instance.layout_position = "BOTTOM".
      ELSE
        IF tt_object_instance.layout_position = "" THEN
          tt_object_instance.layout_position = "CENTRE".

    /* set instantiation order */
    IF INDEX(tt_object_instance.object_type_code,"sdo":U) <> 0 THEN
      ASSIGN tt_object_instance.instance_order = 1.
    ELSE
      IF INDEX(tt_object_instance.object_type_code,"toolbar":U) <> 0 THEN
      DO:
        IF tt_object_instance.layout_position BEGINS "top":U THEN 
          ASSIGN tt_object_instance.instance_order = 2.
        ELSE
          ASSIGN tt_object_instance.instance_order = 3.
      END.
      ELSE
        IF INDEX(tt_object_instance.object_type_code,"smartfolder":U) <> 0 THEN
          ASSIGN tt_object_instance.instance_order = 4.
        ELSE
          ASSIGN tt_object_instance.instance_order = 99.

    /* set page */
    FIND FIRST tt_page_instance
         WHERE tt_page_instance.object_instance_obj = tt_object_instance.object_instance_obj
         NO-ERROR.
    IF AVAILABLE tt_page_instance THEN
      ASSIGN tt_object_instance.page_number = tt_page_instance.page_number.
    ELSE
      ASSIGN tt_object_instance.page_number = 0.
      
    /* add page to layout if not there already */
    IF tt_object_instance.page_number > 0 AND NUM-ENTRIES(tt_object_instance.layout_position) = 1 THEN
      ASSIGN tt_object_instance.layout_position = tt_object_instance.layout_position + ",":U + TRIM(STRING(tt_object_instance.page_number)).
      
  END.
  
  FOR EACH tt_page_instance,
     FIRST tt_object_instance
     WHERE tt_object_instance.object_instance_obj = tt_page_instance.object_instance_obj:
    ASSIGN tt_page_instance.layout_position = tt_object_instance.layout_position.
  END.
  **/
  /* start off by making the frame's virtual dimensions very big */

  ASSIGN
      FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
      FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = SESSION:WIDTH + 1
      FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = SESSION:HEIGHT + 1
      FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
      .
  ASSIGN
    cObjectHandles  = "":U
    cToolbarHandles = "":U.                

  FOR EACH tt_page NO-LOCK:
    /* Construct the objects based on the tt_object_instance temp-table for each page */
    RUN constructTTInstances (INPUT pcInsanceAttributes, INPUT tt_page.page_number) NO-ERROR.
    ASSIGN
      cObjectHandles  = cObjectHandles + (IF cObjectHandles <> "":U THEN ",":U ELSE "":U) + gcObjectHandles
      cToolbarHandles = cToolbarHandles + (IF cToolbarHandles <> "":U THEN ",":U ELSE "":U) + gcToolbarHandles.
  END.
    /*
  /* Construct the objects based on the tt_object_instance temp-table for page 1*/
  RUN constructTTInstances (INPUT pcInsanceAttributes, INPUT 1) NO-ERROR.
      */    
  IF glMenuMaintenance AND pcSDOName = "":U THEN
    pcSDOName = gcPrimarySDOName.
  /* Add the required links */
  RUN addTTLinks (INPUT pcSDOName) NO-ERROR.
  
  FOR EACH tt_page_instance,
     FIRST tt_object_instance 
     WHERE tt_object_instance.object_instance_obj = tt_page_instance.object_instance_obj:
    ASSIGN      
        tt_page_instance.object_instance_handle = tt_object_instance.object_instance_handle
        tt_page_instance.object_type_code       = tt_object_instance.object_type_code.
    
    IF tt_page_instance.object_instance_handle = ghContainerToolbar OR
       tt_page_instance.object_instance_handle = ghTreeViewOCX      OR 
       tt_page_instance.object_instance_handle = ghFolderToolbar    OR 
       tt_page_instance.object_instance_handle = ghFilterViewer     THEN
      NEXT.
    IF tt_page_instance.object_instance_handle = ghFolder AND
       glMenuMaintenance = FALSE THEN
      NEXT.
      
    CREATE tt_view_page_instance.
    BUFFER-COPY tt_page_instance TO tt_view_page_instance.
  END. /* FOR EACH tt_page_instance */

  FOR EACH tt_page NO-LOCK:
    CREATE tt_view_page.
    BUFFER-COPY tt_page TO tt_view_page.
  END.
  
  /* pass SdoForeignFields to any SDO's with a data link from THIS-PROCEDURE */
  RUN passSDOForeignFields (INPUT pcSDOName).
  
  /* the last thing we do is pack the frame to the size of its contents.  The actual work performed here will
  be subject to the chosen layout managers */
  FIND FIRST tt_page WHERE tt_page.page_number = 0 NO-ERROR.
  IF AVAILABLE tt_page THEN DO:
    {set Page0LayoutManager tt_page.layout_code}.
  END.
  
  RUN packWindow IN THIS-PROCEDURE (INPUT 0, NO).
          
  {set Page0LayoutManager gcTreeLayoutCode}.

  IF glMenuMaintenance THEN DO:
    IF VALID-HANDLE(ghFolderToolbar) THEN
      RUN hideObject IN ghFolderToolbar.
  END.
  ELSE DO:
    IF VALID-HANDLE(ghFolderToolbar) THEN
      RUN viewObject IN ghFolderToolbar.
  END.
  
  RUN resizeWindow.
  
  DYNAMIC-FUNCTION("setupFolderPages":U, pcLogicalObjectName).
  RUN selectPage(0).
  
  ASSIGN
    gcObjectHandles  = cObjectHandles
    gcToolbarHandles = cToolbarHandles.
  RUN manualInitializeObjects.
  
  FOR EACH tt_page WHERE tt_page.page_number <> 1:
      RUN hidePage(tt_page.page_number).
  END.
  
  DYNAMIC-FUNCTION("setContainerMode":U, "View":U).
  
  RUN setContainerViewMode.
  RUN selectPage(1).
  RUN toolbar ("EnableData").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete wWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:    When the SDO has successfully deleted a record is publishes a 
              'deleteComplete'. We catch this and route it to updateState to  
              synchronise the TreeView.
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN updateState ("deleteComplete":U).
  /***DIAG***/
  glDelete = TRUE.
  gcCurrentMode = "delete":U.
  gcNewContainerMode = "View".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyNonTreeObjects wWin 
PROCEDURE destroyNonTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will destroy all current logical objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Delete Previously Added Navigation Links */
  FOR EACH  ttLinksAdded
      WHERE ttLinksAdded.cLinkName = "Navigation":U
      NO-LOCK:
      IF VALID-HANDLE(ttLinksAdded.hSourceHandle) AND 
         VALID-HANDLE(ttLinksAdded.hTargetHandle) THEN
        RUN removeLink(ttLinksAdded.hSourceHandle, ttLinksAdded.cLinkName, ttLinksAdded.hTargetHandle).
  END.
  
  /* It might look like I'm duplicating code, but it only works this way - do not change */
  IF NOT glMenuMaintenance THEN DO:
    FIND FIRST ttRunningSDOs NO-LOCK
         WHERE ttRunningSDOs.cSDOName = gcOldSDOName NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND 
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      IF DYNAMIC-FUNCTION("linkHandles" IN ttRunningSDOs.hSDOHandle, "Navigation-Source":U) <> "":U THEN
        RUN removeLink(ghFolderToolbar, "Navigation":U, ttRunningSDOs.hSDOHandle).
    END.
    RUN removeTTLinks (gcOldSDOName).
  END.
  ELSE DO:
    /* When the Dyn TreeView is used as a Menu, we need to kill all running SDOs */
    FOR EACH ttRunningSDOs 
        EXCLUSIVE-LOCK:
      IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
        IF DYNAMIC-FUNCTION("linkHandles" IN ttRunningSDOs.hSDOHandle, "Navigation-Source":U) <> "":U THEN
          RUN removeLink(ghFolderToolbar, "Navigation":U, ttRunningSDOs.hSDOHandle).
      END.
      RUN removeTTLinks (ttRunningSDOs.cSDOName).
      DELETE ttRunningSDOs.
    END.
    IF VALID-HANDLE(ghFolder) THEN DO:
      RUN destroyObject IN ghFolder.
      ghFolder = ?.
    END.
  END.

  FOR EACH ttNonTreeObjects 
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttNonTreeObjects.hObjectHandle) THEN DO:
      FIND FIRST tt_page_instance
           WHERE tt_page_instance.object_instance_handle = ttNonTreeObjects.hObjectHandle
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE tt_page_instance THEN
        DELETE tt_page_instance.
      
      RUN destroyObject IN ttNonTreeObjects.hObjectHandle.
      DELETE ttNonTreeObjects.
    END.
  END.
  
  EMPTY TEMP-TABLE tt_view_page_instance.
  EMPTY TEMP-TABLE tt_view_page.
  EMPTY TEMP-TABLE ttDataLinks.
    
  IF VALID-HANDLE(ghOverridenSubMenu) THEN DO:
    DELETE WIDGET ghOverridenSubMenu.
    ghOverridenSubMenu = ?.
  END.

  /* Disable Toolbar */
  IF VALID-HANDLE(ghFolderToolbar) THEN
    DYNAMIC-FUNCTION("sensitizeActions":U IN ghFolderToolbar ,"Update,Add,Delete,Copy,Save,Cancel,Reset", FALSE).
  
  /* Clear folder pages */
  DYNAMIC-FUNCTION("setupFolderPages":U, INPUT "":U).
  
  RUN updateTitleOverride (INPUT "":U).
  
  ASSIGN gcLogicalObjectName = "":U
         gcInstanceAttributes = "":U
         gcPrimarySDOName    = "":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure was added to make sure that the object name is 
               set to the name of the TreeView and not the other logical object 
               loaded. This will ensure that the TreeView's position and size 
               is saved.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {set LogicalObjectName gcObjectName}.

  RUN saveTreeViewWidth.
  RUN SUPER.
  FOR EACH tt_object_instance WHERE tt_object_instance.destroy_custom_super = TRUE:
    DELETE OBJECT tt_object_instance.custom_super_handle NO-ERROR. 
  END.
END PROCEDURE .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doThisOnceOnly wWin 
PROCEDURE doThisOnceOnly :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF glOnceOnlyDone THEN RETURN.
  
  RUN createObjects. 

  IF NOT VALID-HANDLE(ghTreeViewOCX) THEN 
    ghTreeViewOCX = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("linkHandles":U, INPUT "TVController-Source":U))).
  
  IF  VALID-HANDLE(ghTreeViewOCX) THEN DO:
    {set ShowCheckBoxes glShowCheckBoxes ghTreeViewOCX}.
    {set ShowRootLines glShowRootLines ghTreeViewOCX}.
    {set HideSelection glHideSelection ghTreeViewOCX}.
    {set ImageHeight giImageHeight ghTreeViewOCX}.
    {set ImageWidth giImageWidth ghTreeViewOCX}.
    {set TreeStyle giTreeStyle ghTreeViewOCX}.
    {set AutoSort FALSE ghTreeViewOCX}.
  END.
  
  /* Initialize the SmartTreeView Manually */
  RUN initializeObject IN h_smarttreeview.
  
  {get StartPage iStartPage}.
  IF iStartPage NE ? AND iStartPage NE 0 THEN
    RUN selectPage(iStartPage).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY fiResizeFillIn fiTitle 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE fiResizeFillIn fiTitle rctBorder 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
          
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst wWin 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     Move to first node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast wWin 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     Move to last node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext wWin 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     Move to next node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev wWin 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     Move to previous node in heirarachy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN fetchRequest.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRequest wWin 
PROCEDURE fetchRequest :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will fire after a fetch.... request from the SDO.
               It is usually run from fetchNext/Prev/Firs/Last in this procedure.
               This procedure will read the RowId from the Node Temp Table and
               reposition to that record on the SDO.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cCurrentNode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentNode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hNode                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hPrivateData            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPrivateData            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef              AS CHARACTER  NO-UNDO.
  
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN ghTreeViewOCX).
  
  IF cCurrentNode = ? THEN
    RETURN.
  
  ASSIGN cParentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX ,INPUT "PARENT":U, INPUT cCurrentNode) NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
     cParentNode = ? OR
     cParentNode = "":U THEN
    cParentNode = ?.
    
  {get TreeDataTable hTable ghTreeViewOCX}.
  
  FIND FIRST ttRunningSDOs
       WHERE ttRunningSDOs.cSDOName = gcPrimarySDOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttRunningSDOs THEN
    RETURN.
  ELSE
    hSDOHandle = ttRunningSDOs.hSDOHandle.
  
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hSDOHandle).

  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cObjField = ENTRY(3, cValueList, CHR(4)).
  
  ASSIGN cRecordRef = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cObjField)).
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf  = hTable:DEFAULT-BUFFER-HANDLE
         hNode = hBuf:BUFFER-FIELD('node_key':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  IF cParentNode = ? THEN
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.record_ref = "&2" AND &1.parent_node_key = ?':U, hTable:NAME,cRecordRef)).
  ELSE
    hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.record_ref = "&2" AND &1.parent_node_key = "&3"':U, hTable:NAME,cRecordRef,cParentNode)).
  
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN cNodeKey = hNode:BUFFER-VALUE
           NO-ERROR.
    hQry:GET-NEXT().
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.

  ASSIGN gcCurrentNodeKey = cNodeKey.
    
  IF gcCurrentNodeKey <> ? AND 
     VALID-HANDLE(ghTreeViewOCX) THEN
    DYNAMIC-FUNCTION("selectNode":U IN ghTreeViewOCX, gcCurrentNodeKey).  
 
  RUN setDataLinkActive.
  RUN nodeSelected (INPUT cNodeKey).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterDataAvailable wWin 
PROCEDURE filterDataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be launched from a FilterViewer and it will
               filter the root node data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilterData  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hDataTable    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.

  IF (gcNewContainerMode <> "View":U AND
      gcNewContainerMode <> "":U) OR
      gcState = "Update" THEN DO:
    cErrorMessage = "You are currently modifying a record, save or undo your change before applying your new filter.".
    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                           INPUT  "ERR":U,                  /* error type */
                                           INPUT  "&OK":U,                  /* button list */
                                           INPUT  "&OK":U,                  /* default button */ 
                                           INPUT  "&OK":U,                  /* cancel button */
                                           INPUT  "Error":U,                /* error window title */
                                           INPUT  YES,                      /* display if empty */ 
                                           INPUT  THIS-PROCEDURE,           /* container handle */ 
                                           OUTPUT cButton                   /* button pressed */
                                          ).
    
    
    RETURN.
  END.

  ASSIGN gcContainerMode     = "":U
         gcLogicalObjectName = "":U
         gcInstanceAttributes = "":U
         gcOldSDOName        = "":U
         gcCurrentOEM        = "":U
         gdCurrentRecordObj  = 0
         gcCurrentNodeKey    = "":U
         gcLastLaunchedNode  = "":U
         gcParentNode        = "":U
         gcFilterValue       = "":U
         gcCurrentMode       = "":U
         gcNewContainerMode  = "":U
         gcState             = "":U
         ghSDOHandle         = ?
         gcPrimarySDOName    = "":U
         glDelete            = FALSE
         glExpand            = TRUE
         glFilterApplied     = FALSE
         glNewChildNode      = FALSE.
  
  IF pcFilterData <> ? AND
     pcFilterData <> "":U THEN DO:
    gcFilterValue = pcFilterData.
  END.
  glFilterApplied = TRUE.
  
  {get TreeDataTable hDataTable ghTreeViewOCX}.

  /* We want to destroy all the current running SDO's and other running objects*/
  RUN destroyNonTreeObjects.
  
  FOR EACH ttRunningSDOs
      EXCLUSIVE-LOCK:
    IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
      RUN destroyObject IN ttRunningSDOs.hSDOHandle.
    DELETE ttRunningSDOs.
  END.

  RUN loadTreeData.
  glExpand = FALSE.
  RUN populateTree IN ghTreeViewOCX (hDataTable, "":U).
  glExpand = TRUE.
  RUN selectFirstNode IN ghTreeViewOCX.
  cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN ghTreeViewOCX).
  RUN tvNodeSelected (cNodeKey).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentRecordData wWin 
PROCEDURE getCurrentRecordData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcCurrentOEM  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pdCurrentObj  AS DECIMAL    NO-UNDO.
  

  ASSIGN pcCurrentOEM = gcCurrentOEM      
         pdCurrentObj = gdCurrentRecordObj.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTopLeft wWin 
PROCEDURE getTopLeft :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pdRow     AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdColumn  AS DECIMAL    NO-UNDO.

  ASSIGN
      pdColumn = 0
      pdRow    = 0.
        
  ASSIGN
      pdColumn = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN THIS-PROCEDURE, "LeftCoordinate":U))
      pdRow    = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN THIS-PROCEDURE, "TopCoordinate":U)) NO-ERROR.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTreeObjects wWin 
PROCEDURE getTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phFolder            AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phFolderToolbar     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phContainerToolbar  AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phTitleFillIn       AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phResizeFillIn      AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pghTreeViewOCX      AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phRectangle         AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER plStatusBarVisible  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER phFilterViewer      AS HANDLE     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        phFolder            = IF glMenuMaintenance = FALSE THEN ghFolder ELSE ?
        phFolderToolbar     = ghFolderToolbar
        phContainerToolbar  = ghContainerToolbar
        phTitleFillIn       = IF VALID-HANDLE(fiTitle:HANDLE) THEN fiTitle:HANDLE ELSE ?
        pghTreeViewOCX      = IF VALID-HANDLE(ghTreeViewOCX) THEN ghTreeViewOCX ELSE ?
        phResizeFillIn      = IF VALID-HANDLE(fiResizeFillIn:HANDLE) THEN fiResizeFillIn:HANDLE ELSE ?
        phRectangle         = IF VALID-HANDLE(rctBorder:HANDLE) THEN rctBorder:HANDLE ELSE ?
        plStatusBarVisible  = TRUE  /* Assum yes until property has been implemented */
        phFilterViewer      = ghFilterViewer
        NO-ERROR.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject wWin 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /** THIS WAS TO MAKE SURE THE CONTAINER WINDOW IS NOT HIDDEN WHEN CHANGING FOLDER PAGES **/
  /*
  RUN SUPER.
  */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCurrentPageNumber   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSavedContainerMode  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorMessage        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cButton              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cInstanceAttribute   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hMenuBar             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSubMenu             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE dTextWidth           AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dTotalTextWidth      AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE iMenus               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dMenuControllerWidth AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE cNodeKey             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dFilterHeight        AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dFilterWidth         AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE hDataTable           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRootNodeCode        AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  IF glInitialised THEN RETURN.
  glInitialised = TRUE.
  
  cInstanceAttribute = DYNAMIC-FUNCTION("getRunAttribute").
  
  /* retrieve container mode set already, i.e. from where window was launched from
     and before initializeobject was run. If a mode is retrieved here, we will not
     overwrite it with the default mode from the object properties.
  */
  gcContainerMode = getContainerMode().
  
  fiResizeFillIn:LOAD-MOUSE-POINTER("size-e":U) IN FRAME {&FRAME-NAME}.
  
  /* {get ContainerMode gcContainerMode}. */

  IF NOT glOnceOnlyDone THEN RUN doThisOnceOnly.
  /* Check forced exit of the dynamic container.
   * We may get window packing errors here.      */
  IF LENGTH({&WINDOW-NAME}:PRIVATE-DATA)           GT 0              AND
     ENTRY(1, {&WINDOW-NAME}:PRIVATE-DATA, CHR(3)) EQ "ForcedExit":U THEN
  DO:
      IF NUM-ENTRIES({&WINDOW-NAME}:PRIVATE-DATA, CHR(3)) GE 2 THEN
          ASSIGN cErrorMessage = ENTRY(2, {&WINDOW-NAME}:PRIVATE-DATA, CHR(3)).
      ELSE
          ASSIGN cErrorMessage = "Program aborted due to unknown reason":U.

      RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,            /* message to display */
                                              INPUT  "ERR":U,                  /* error type */
                                              INPUT  "&OK":U,                  /* button list */
                                              INPUT  "&OK":U,                  /* default button */ 
                                              INPUT  "&OK":U,                  /* cancel button */
                                              INPUT  "Folder window error":U,  /* error window title */
                                              INPUT  YES,                      /* display if empty */ 
                                              INPUT  THIS-PROCEDURE,           /* container handle */ 
                                              OUTPUT cButton               ).  /* button pressed */
      RUN exitObject.
      RETURN.
  END.    /* forced exit */
  
  /* hide window until all the window sizes have been calculated */
  {&WINDOW-NAME}:VISIBLE = FALSE.

  IF NOT VALID-HANDLE(ghFilterViewer) THEN 
    ghFilterViewer = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U, INPUT "TreeFilter-Source"))).
  IF VALID-HANDLE(ghFilterViewer) THEN
    SUBSCRIBE TO "filterDataAvailable":U IN ghFilterViewer.

  IF VALID-HANDLE(ghFilterViewer) THEN DO:
    ASSIGN dFilterHeight = DYNAMIC-FUNCTION("getHeight" IN ghFilterViewer)
           dFilterWidth  = DYNAMIC-FUNCTION("getWidth" IN ghFilterViewer).
    IF {&WINDOW-NAME}:WIDTH-CHARS < dFilterWidth THEN
      ASSIGN {&WINDOW-NAME}:WIDTH-CHARS      = dFilterWidth + .5
             FRAME {&FRAME-NAME}:WIDTH-CHARS = {&WINDOW-NAME}:WIDTH-CHARS.
             
    ASSIGN gdMinimumWindowWidth = {&WINDOW-NAME}:WIDTH-CHARS.
    RUN resizeWindow.
  END.
  
  RUN SUPER.

  /* This is to see whether the folder window changed the mode because there is
     possibly no enabled tab */
  
  ASSIGN gcContainerMode    = getContainerMode()
         iCurrentPageNumber = getCurrentPage().
    
  FOR EACH tt_page WHERE tt_page.PAGE_number <> iCurrentPageNumber:
      RUN hidePage(tt_page.PAGE_number).
  END.

  /* Check if any enabled tabs and if not - exit the program */
  DEFINE VARIABLE hFolder AS HANDLE NO-UNDO.
  ASSIGN hFolder = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles':U, 'Page-Source':U)).
  IF VALID-HANDLE(hFolder) AND DYNAMIC-FUNCTION("getTabsEnabled" IN hFolder) = NO THEN
  DO:
    
    ASSIGN cErrorMessage = {af/sup2/aferrortxt.i 'RY' '11'}.

    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                           INPUT  "ERR":U,                  /* error type */
                                           INPUT  "&OK":U,                  /* button list */
                                           INPUT  "&OK":U,                  /* default button */ 
                                           INPUT  "&OK":U,                  /* cancel button */
                                           INPUT  "Folder window error":U,  /* error window title */
                                           INPUT  YES,                      /* display if empty */ 
                                           INPUT  THIS-PROCEDURE,           /* container handle */ 
                                           OUTPUT cButton                   /* button pressed */
                                          ).
    
    /* Shut down the folder window */
    RUN exitObject. 
    RETURN.             
  END.
  
  IF LENGTH({&WINDOW-NAME}:PRIVATE-DATA) > 0 AND
     ENTRY(1,{&WINDOW-NAME}:PRIVATE-DATA,CHR(3)) = "forcedexit":U THEN
  DO:
    IF NUM-ENTRIES({&WINDOW-NAME}:PRIVATE-DATA,CHR(3)) = 2 THEN
      ASSIGN cErrorMessage = ENTRY(2,{&WINDOW-NAME}:PRIVATE-DATA,CHR(3)).
    ELSE 
      ASSIGN cErrorMessage = "Program aborted due to unknown reason":U.
    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                           INPUT  "ERR":U,                  /* error type */
                                           INPUT  "&OK":U,                  /* button list */
                                           INPUT  "&OK":U,                  /* default button */ 
                                           INPUT  "&OK":U,                  /* cancel button */
                                           INPUT  "Folder window error":U,  /* error window title */
                                           INPUT  YES,                      /* display if empty */ 
                                           INPUT  THIS-PROCEDURE,           /* container handle */ 
                                           OUTPUT cButton                   /* button pressed */
                                          ).
    RUN exitObject.
    RETURN.
  END.
      

  /* Code placed here will execute AFTER standard behavior.    */

  PROCESS EVENTS.
  
  /* calculate the menu width */
  hMenuBar = {&WINDOW-NAME}:MENU-BAR.
  ghDefaultMenuBar = hMenuBar.
  IF VALID-HANDLE(hMenuBar) THEN
  DO:
    hSubMenu = hMenuBar:FIRST-CHILD.
    REPEAT WHILE VALID-HANDLE(hSubMenu):
        dTextWidth = FONT-TABLE:GET-TEXT-WIDTH(REPLACE(hSubMenu:LABEL,"&",""), hSubMenu:FONT).
        dTotalTextWidth = dTotalTextWidth + dTextWidth.
        iMenus = iMenus + 1.
        hSubMenu = hSubMenu:NEXT-SIBLING.
    END.

    dMenuControllerWidth = MAX(dTotalTextWidth + (iMenus * 2.6) + 1, 1).
    dMenuControllerWidth = MAX({&WINDOW-NAME}:MIN-WIDTH,MIN(dMenuControllerWidth, SESSION:WIDTH - 1)).

    IF {&WINDOW-NAME}:WIDTH < dMenuControllerWidth THEN
    DO:
      ASSIGN
        FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
        {&WINDOW-NAME}:MIN-WIDTH = dMenuControllerWidth
        {&WINDOW-NAME}:WIDTH = dMenuControllerWidth
        FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = dMenuControllerWidth
        FRAME {&FRAME-NAME}:WIDTH = dMenuControllerWidth
        FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
        .
      APPLY "window-resized":u TO {&WINDOW-NAME}.
    END.

    IF {&WINDOW-NAME}:MIN-WIDTH < dMenuControllerWidth THEN
    DO:
      ASSIGN
        {&WINDOW-NAME}:MIN-WIDTH = dMenuControllerWidth.
    END.
  END.

  /* calculate window width */
  {&WINDOW-NAME}:VISIBLE = TRUE.
  
  RUN applyEntry(?).

  SUBSCRIBE TO "tvNodeSelected" IN ghTreeViewOCX.
  SUBSCRIBE TO "tvNodeEvent"    IN ghTreeViewOCX.
  
  {get TreeDataTable hDataTable ghTreeViewOCX}.
  
  RUN loadTreeData.
  glExpand = FALSE.
  RUN populateTree IN ghTreeViewOCX (hDataTable, "":U).
  glExpand = TRUE.
  RUN selectFirstNode IN ghTreeViewOCX.
  cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN ghTreeViewOCX).
  RUN tvNodeSelected (cNodeKey).
  /**
  /* Not to sure why I did this, but to fix issue #3786 I had to comment this out
  I did have a look at another issue where I think I might have added this piece
  of code and this still works fine - leaving this uncommented for a while to 
  make sure that an issue does not REOPEN after a while */
  IF VALID-HANDLE(ghFolder) AND
   glMenuMaintenance THEN DO:
    RUN destroyObject IN ghFolder.
    ASSIGN ghFolder = ?.
  END.
  **/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadMNUData wWin 
PROCEDURE loadMNUData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through menu items in the gsm_menu_item
               table for the structure code specified. This is only done once, since
               you can't add new menu items from withing the treeview
  Parameters:  pcParentNodeKey   - The parent node key - "" for Root
               pdChildNodeObj - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDetailList             AS CHARACTER  NO-UNDO.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  ASSIGN cDataSource            = ttNode.data_source
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         NO-ERROR.
  
  {get TreeDataTable hTable ghTreeViewOCX}.  
  
  {aflaunch.i &PLIP  = 'ry/app/rytrenodep.p' 
              &IPROC = 'readMenuStructure' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT cDataSource, INPUT 0, OUTPUT cDetailList)"
              &AUTOKILL = YES}

   RUN stripMNUDetails (INPUT pcParentNodeKey,
                        INPUT cDetailList,
                        INPUT pdChildNodeObj,
                        INPUT cImageFileName,
                        INPUT cSelectedImageFileName).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadNodeData wWin 
PROCEDURE loadNodeData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will deternine what type of Node data would be loaded
               and run the appropriate procedure
  Parameters:  pcParentNodeKey   - The parent node key - "" for Root
               pdChildNodeObj - The Obj number of the child node found on gsm_node
  Notes:       The following procedures are used to load Node Data
               SDO/SBO (SDO)        - loadSDOSBOData
               Program (PRG)        - loadPRGData
               Text (TXT)           - loadTXTData
               Menu Structure (MNU) - loadMNUData
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataSourceType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  IF pdChildNodeObj = 0 THEN
    RETURN.
    
  cDataSourceType = "":U.
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  ELSE
    ASSIGN cDataSourceType = ttNode.data_source_type NO-ERROR.

  CASE cDataSourceType:
    WHEN "SDO":U THEN DO:
      RUN loadSDOSBOData (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    WHEN "PRG":U THEN DO:
      RUN loadPRGData (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    WHEN "TXT":U THEN DO:
      RUN loadTXTData (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    WHEN "MNU":U THEN DO:
      RUN loadMNUData (INPUT pcParentNodeKey, INPUT pdChildNodeObj).
    END.
    OTHERWISE DO:
      RUN showMessages IN gshSessionManager (INPUT  "Unknown Data Source Specified (" + cDataSourceType + ")",    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "Populate Tree Data":U,             /* error window title */
                                             INPUT  NO,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPRGData wWin 
PROCEDURE loadPRGData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through a SDO/SBO and populate the temp-table
               with the data
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
                                         
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRowAvailable           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubstitute             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.
  
  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  ASSIGN lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         cParentNodeSDO         = ttNode.primary_sdo
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cPrimarySDO            = ttNode.primary_sdo
         NO-ERROR.
  
  DO TRANSACTION:
    FIND CURRENT ttNode EXCLUSIVE-LOCK.
    ASSIGN ttNode.data_source = ttNode.primary_sdo
           ttNode.data_source_type = "SDO":U.
    FIND CURRENT ttNode NO-LOCK.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    /* Now we need to start the SDO for this NODE */
    /** First check that the SDO/SBO is relatively pathed **/
    IF INDEX(cPrimarySDO,"/":U) = 0 AND
       INDEX(cPrimarySDO,"\":U) = 0 THEN DO:
       cSDOSBOName = returnSDOName(cPrimarySDO).
    END.
    RUN manageSDOs (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT FALSE,
                    INPUT "":U,
                    OUTPUT hSDOHandle).
     IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
       SESSION:SET-WAIT-STATE("":U).
       RETURN.
     END.
  END.
  
  {get TreeDataTable hTable ghTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
         
  
  /* See if the SDO is already running */
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hSDOHandle).
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /* Run the program to populate the data */
  {aflaunch.i &PLIP  = cDataSource 
              &IPROC = 'loadData' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT pcParentNodeKey, INPUT cParentNodeSDO, INPUT gcFilterValue, INPUT-OUTPUT TABLE-HANDLE hTable)"
              &AUTOKILL = YES}
  IF ERROR-STATUS:ERROR THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    cErrorMessage = "Could not launch extract program '" + cDataSource + "' on AppServer.~nError returned from launch program: " + ERROR-STATUS:GET-MESSAGE(1).
    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,            /* message to display */
                                           INPUT  "ERR":U,                  /* error type */
                                           INPUT  "&OK":U,                  /* button list */
                                           INPUT  "&OK":U,                  /* default button */ 
                                           INPUT  "&OK":U,                  /* cancel button */
                                           INPUT  "Error":U,                /* error window title */
                                           INPUT  YES,                      /* display if empty */ 
                                           INPUT  THIS-PROCEDURE,           /* container handle */ 
                                           OUTPUT cButton                   /* button pressed */
                                          ).
    
    
    RETURN.
  END.

  CREATE QUERY hQry.
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.parent_node_key = "&2":U AND &1.node_obj = 0 BY &1.node_key':U, hTable:NAME,pcParentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  /* Now we'll just add the other data from the gsm_node record */
  DO WHILE hBuf:AVAILABLE:
    ASSIGN hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = IF hImage:BUFFER-VALUE = "":U OR hImage:BUFFER-VALUE = ? THEN cImageFileName ELSE hImage:BUFFER-VALUE
           hSelectedImage:BUFFER-VALUE = IF hSelectedImage:BUFFER-VALUE = "":U OR hSelectedImage:BUFFER-VALUE = ? THEN cSelectedImageFileName ELSE hSelectedImage:BUFFER-VALUE
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
    
    /* Create a Dummy Child node record */
    IF lHasChildren THEN
      RUN createDummyChild (INPUT hBuf,
                           INPUT hNodeKey:BUFFER-VALUE,
                           INPUT "DUMMY":U).
    hQry:GET-NEXT().
  END.
  SESSION:SET-WAIT-STATE("":U).

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSDOSBOData wWin 
PROCEDURE loadSDOSBOData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through a SDO/SBO and populate the temp-table
               with the data
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRootParentNodeKey      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cErrorMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValueList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRowAvailable           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubstitute             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid            AS ROWID      NO-UNDO.
  DEFINE VARIABLE cRecordRef              AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  IF pdChildNodeObj = 0 THEN
    RETURN.
    
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.

  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
         cNodeLabelExpression   = ttNode.node_text_label_expression
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         gcInstanceAttributes   = ttNode.run_attribute
         NO-ERROR.
  
  /* Always assume children for structured Tree Nodes */
  IF (gcInstanceAttributes = "STRUCTURED":U) THEN
    lHasChildren = TRUE.

  /* Get Parent Node Info */
  cDataset = "":U.
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dParentNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN
    ASSIGN cParentNodeSDO = IF ttNode.data_source_type <> "TXT":U /*AND ttNode.data_source_type <> "PRG":U*/ THEN ttNode.data_source ELSE ttNode.primary_sdo.
  /* We need to reposition the Parent SDO for the foreign Fields */
  IF cParentNodeSDO <> "":U THEN DO:
    RUN repositionParentSDO (INPUT cParentNodeSDO,
                             INPUT pcParentNodeKey).
  END.
  
  /** First check that the SDO/SBO is relatively pathed **/
  IF INDEX(cDataSource,"/":U) = 0 AND
     INDEX(cDataSource,"\":U) = 0 THEN DO:
     cDataSource = returnSDOName(cDataSource).
     IF cDataSource = "":U OR 
        cDataSource = ? THEN
      RETURN.
  END.
  
  RUN manageSDOs (INPUT  cDataSource,
                  INPUT  cForeignFields,
                  INPUT  cParentNodeSDO,
                  INPUT  cLabelSubsFields,
                  INPUT  (gcInstanceAttributes = "STRUCTURED":U),
                  INPUT  cFieldToStore,
                  OUTPUT hSDOHandle).
  IF NOT VALID-HANDLE(hSDOHandle) THEN
    RETURN.

  {get TreeDataTable hTable ghTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U).
         
         cRootParentNodeKey = DYNAMIC-FUNCTION('getRootNodeParentKey':u IN ghTreeViewOCX).
  
  /* See if the SDO is already running */
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hSDOHandle).
  
  IF cValueList = ? THEN DO:
    cErrorMessage = "No Entity Mnemonic detail for the table(s) in " + 
                    hSDOHandle:FILE-NAME + " could be found.~n" +
                    "Do an Entity Mnemonic Import of the appropriate table(s).~n~n" +
                    "NOTE:~n" +
                    "After doing an import you MUST trim the servers on your AppServer in order for the details to be cached.".
                    
    RUN showMessages IN gshSessionManager (INPUT  cErrorMessage ,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "&Cancel":U,       /* cancel button */
                                           INPUT  "Entity Mnemonic Detail Not Found":U,             /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.
  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cTable    = ENTRY(2, cValueList, CHR(4))
           cObjField = ENTRY(3, cValueList, CHR(4)).
  
  RUN setDataLinkInActive.
  
  RUN fetchFirst IN hSDOHandle.
  lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "CURRENT":U).
  IF NOT lRowAvailable THEN DO:
    glExpand = FALSE.
    RETURN.
  END.
           
  RECORD_AVAILABLE:
  DO WHILE lRowAvailable = TRUE:
    DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
      cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
      IF cSubstitute[iLoop] = ? THEN
        cSubstitute[iLoop] = "":U.
    END.
    IF NUM-ENTRIES(cObjField) > 1 THEN DO:
      ASSIGN cRecordRef = "":U
             cRecordRef = FILL(CHR(1),NUM-ENTRIES(cObjField) - 1).
      DO iLoop = 1 TO NUM-ENTRIES(cObjField):
        ENTRY(iLoop,cRecordRef,CHR(1)) = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cObjField))).
      END.
    END.
    ELSE 
      cRecordRef = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cObjField)).
    
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeLabel:BUFFER-VALUE     = TRIM(SUBSTITUTE(cNodeLabelExpression,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
           hRecordRef:BUFFER-VALUE     = cRecordRef
           hRecordRowId:BUFFER-VALUE   = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = TRIM(cImageFileName)
           hSelectedImage:BUFFER-VALUE = TRIM(cSelectedImageFileName)
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
    IF (gcInstanceAttributes = "STRUCTURED":U) THEN DO:
      DEFINE VARIABLE cChildKey AS CHARACTER  NO-UNDO.
      IF NUM-ENTRIES(cFieldToStore,"^":U) >= 3 THEN DO:
        cChildKey = ENTRY(3,cFieldToStore,"^":U).
        hPrivateData:BUFFER-VALUE = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cChildKey)).
      END.
    END.
    /* Create a Dummy Child node record */
    IF lHasChildren THEN
      RUN createDummyChild (INPUT hBuf,
                            INPUT hNodeKey:BUFFER-VALUE,
                            INPUT "DUMMY":U).

    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hSDOHandle, "NEXT":U). 
    IF lRowAvailable THEN 
      RUN fetchNext IN hSDOHandle.
    ELSE 
      LEAVE RECORD_AVAILABLE.
  END. /* WHILE */
  
  RUN setDataLinkActive.
  glExpand = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTreeData wWin 
PROCEDURE loadTreeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootNodeCode         AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTable                AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE hBuf                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRootParentNodeKey    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dRootNodeObj          AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cMode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeKey              AS CHARACTER  NO-UNDO.

  IF glFilterApplied = FALSE AND
     VALID-HANDLE(ghFilterViewer) THEN
    RETURN.
  
  {get UIBMode cMode}.
  IF cMode BEGINS 'design':u THEN
    RETURN.
  
/* Make sure that we have valid handles to the SmartTreeView and
  get the handle to the node temp-table */
  {get TreeDataTable hTable ghTreeViewOCX}.

  IF NOT VALID-HANDLE(hTable) THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "Invalide Handle found for TreeData temp-table.",    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,  /* button list */
                                           INPUT  "&OK":U,          /* default button */ 
                                           INPUT  "&Cancel":U,      /* cancel button */
                                           INPUT  "Loading Data":U, /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    
    RETURN.
  END.

  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  
  /* Clear the data from the TreeView */
  hBuf:EMPTY-TEMP-TABLE().
  RUN emptyTree IN ghTreeViewOCX.
  EMPTY TEMP-TABLE ttNode.
  cRootNodeCode = getRootNodeCode().
  {aflaunch.i &PLIP  = 'ry/app/rytrenodep.p' 
              &IPROC = 'cacheNodeTable' 
              &ONAPP = 'YES'
              &PLIST = "(INPUT cRootNodeCode, INPUT 0, OUTPUT TABLE ttNode)"
              &AUTOKILL = YES}
  
  FIND FIRST ttNode
       WHERE ttNode.node_code = cRootNodeCode 
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN DO:
    RUN showMessages IN gshSessionManager (INPUT  "The Root Node code specified could not be found! - " + cRootNodeCode,    /* message to display */
                                           INPUT  "ERR":U,          /* error type */
                                           INPUT  "&OK,&Cancel":U,  /* button list */
                                           INPUT  "&OK":U,          /* default button */ 
                                           INPUT  "&Cancel":U,      /* cancel button */
                                           INPUT  "Loading Data":U, /* error window title */
                                           INPUT  YES,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    RETURN.
  END.
  
  ASSIGN dRootNodeObj = ttNode.node_obj.
  
  RUN prepareNodeTranslation.
  
  RUN loadNodeData (INPUT "":U,
                    INPUT dRootNodeObj).

  RUN selectFirstNode IN ghTreeViewOCX.
  cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN ghTreeViewOCX).
  RUN tvNodeSelected (cNodeKey).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTXTData wWin 
PROCEDURE loadTXTData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will create a node with the specified text for that node
  Parameters:  pcParentNodeKey - The parent node key - "" for Root
               pdChildNodeObj  - The Obj number of the child node found on gsm_node
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdChildNodeObj  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  
  /* Define Temp-Table Variables */
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeKey                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeLabel              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeInsert             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldToStore           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dParentNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cParentNodeSDO          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasChildren            AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  IF pdChildNodeObj = 0 THEN
    RETURN.
  
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.

  FIND FIRST bttNode
       WHERE bttNode.parent_node_obj = pdChildNodeObj
       NO-LOCK NO-ERROR.
  IF AVAILABLE bttNode THEN
    lHasChildren = TRUE.
  
  IF NOT AVAILABLE ttNode THEN
    RETURN.
  
  ASSIGN cNodeLabel             = ttNode.node_label
         lNodeChecked           = ttNode.node_checked
         cDataSource            = ttNode.data_source
         cFieldToStore          = ttNode.fields_to_store
         cNodeLabelExpression   = ttNode.node_text_label_expression
         cLabelSubsFields       = ttNode.label_text_substitution_fields
         cForeignFields         = ttNode.foreign_fields
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         dParentNodeObj         = ttNode.parent_node_obj
         NO-ERROR.
  
  /* Get Parent Node Info */
  cDataset = "":U.
  FIND FIRST ttNode
       WHERE ttNode.node_obj = dParentNodeObj
       NO-LOCK NO-ERROR.
  cParentNodeSDO = "":U.
  IF AVAILABLE ttNode THEN /* Check for Parent Node */
    ASSIGN cParentNodeSDO = ttNode.data_source.
  
  
  {get TreeDataTable hTable ghTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
         
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_label = "&2" AND &1.parent_node_key = "&3":U':U, hTable:NAME,cDataSource,pcParentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().

  IF NOT hBuf:AVAILABLE THEN DO:
      IF CAN-FIND(FIRST ttTranslate) THEN DO:
        FIND FIRST ttTranslate 
             WHERE ttTranslate.cOriginalLabel    = cDataSource
             AND   ttTranslate.cTranslatedLabel <> "":U
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttTranslate THEN
          cDataSource = ttTranslate.cTranslatedLabel.
      END.
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
           hNodeObj:BUFFER-VALUE       = pdChildNodeObj
           hNodeLabel:BUFFER-VALUE     = cDataSource
           hRecordRef:BUFFER-VALUE     = "":U
           hRecordRowId:BUFFER-VALUE   = ?
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = cImageFileName
           hSelectedImage:BUFFER-VALUE = cSelectedImageFileName
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
   /* Create a Dummy Child node record */
   IF lHasChildren THEN
     RUN createDummyChild (INPUT hBuf,
                           INPUT hNodeKey:BUFFER-VALUE,
                           INPUT "DUMMY":U).
  END.
  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manageSDOs wWin 
PROCEDURE manageSDOs :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will initialize and SDO/SBO
  Parameters:  
  Notes:     I pcSDOSBOName      - The name of the SDO/SBO to be initialized
             I pcForeignFields   - The Foreign Fields to be used when initializing 
             I pcParentSDOSBO    - The name of the SDO/SBO (if any) of the parent node
             I pcLabelSubsFields - These fields will be used to SORT the SDO/SBO
             O phSDOHandle       - The handle to the initialized SDO/SBO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOSBOName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcForeignFields   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentSDOSBO    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLabelSubsFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plStructuredSDO   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentChildFld  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phSDOHandle       AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE hParentSDO                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectPath               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOAttributes            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFieldAttr         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIndex                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cForeignFields            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFieldValues       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cFilterString             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldNameOnly      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperator           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAlreadyInQuery           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDoNotSetFilter           AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cDataTargetLinks          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTarget               AS HANDLE     NO-UNDO.

  DEFINE BUFFER bu_object_instance FOR tt_object_instance.
  DEFINE BUFFER bu_page            FOR tt_page.
  DEFINE BUFFER bu_page_instance   FOR tt_page_instance.
  DEFINE BUFFER bu_link            FOR tt_link.
  DEFINE BUFFER buRunningSDOs      FOR ttRunningSDOs.
  DEFINE BUFFER buAttributeValue   FOR ttAttributeValue.
  DEFINE BUFFER buUiEvent          FOR ttUiEvent.

  IF pcSDOSBOName = "":U THEN
    RETURN.
  
  /** First check that the SDO/SBO is relatively pathed **/
  IF INDEX(pcSDOSBOName,"/":U) = 0 AND
     INDEX(pcSDOSBOName,"\":U) = 0 THEN DO:
     pcSDOSBOName = returnSDOName(pcSDOSBOName).
     IF pcSDOSBOName = "":U OR 
        pcSDOSBOName = ? THEN
      ASSIGN pcSDOSBOName = gcPrimarySDOName.
  END.

  /** Secondly check that the Parent SDO/SBO is relatively pathed **/
  IF INDEX(pcParentSDOSBO,"/":U) = 0 AND
     INDEX(pcParentSDOSBO,"\":U) = 0 AND 
     pcParentSDOSBO <> "":U THEN DO:
     pcParentSDOSBO = returnSDOName(pcParentSDOSBO).
     
  END.
  
  RUN setDataLinkInActive.
  /* First Find the Parent SDO/SBO */
  hParentSDO = ?.
  FIND FIRST buRunningSDOs
       WHERE buRunningSDOs.cSDOName = pcParentSDOSBO
       NO-LOCK NO-ERROR.
  
  IF AVAILABLE buRunningSDOs AND 
     VALID-HANDLE(buRunningSDOs.hSDOHandle) THEN
    ASSIGN hParentSDO = buRunningSDOs.hSDOHandle.
  /* See if the SDO is already running */
  FIND FIRST buRunningSDOs
       WHERE buRunningSDOs.cSDOName = pcSDOSBOName 
       EXCLUSIVE-LOCK NO-ERROR.

  IF NOT AVAILABLE(buRunningSDOs) THEN DO:
    ASSIGN
        cObjectName = pcSDOSBOName
        cObjectName = IF INDEX(cObjectName, "\":U) <> 0 THEN REPLACE(cObjectName, "\":U, "/":U) ELSE cObjectName
        cObjectName = SUBSTRING(cObjectName, R-INDEX(cObjectName, "/":U) + 1).
        /*cObjectName = SUBSTRING(cObjectName, 1, R-INDEX(cObjectName, ".":U) - 1).*/
    
    RUN getObjectAttributes IN gshRepositoryManager (INPUT cObjectName,
                                                     OUTPUT TABLE bu_object_instance,
                                                     OUTPUT TABLE bu_page,
                                                     OUTPUT TABLE bu_page_instance,
                                                     OUTPUT TABLE bu_link,
                                                     OUTPUT TABLE buAttributeValue,
                                                     OUTPUT TABLE buUiEvent) NO-ERROR.
    
    IF ERROR-STATUS:ERROR OR
       NOT CAN-FIND(FIRST buAttributeValue) THEN DO:
      /* Now try finding the object without an extension */
      cObjectName = ENTRY(1,cObjectName,".":U).
      RUN getObjectAttributes IN gshRepositoryManager (INPUT cObjectName,
                                                       OUTPUT TABLE bu_object_instance,
                                                       OUTPUT TABLE bu_page,
                                                       OUTPUT TABLE bu_page_instance,
                                                       OUTPUT TABLE bu_link,
                                                       OUTPUT TABLE buAttributeValue,
                                                       OUTPUT TABLE buUiEvent) NO-ERROR.
       
      IF ERROR-STATUS:ERROR OR
         NOT CAN-FIND(FIRST buAttributeValue) THEN DO:
        IF NOT glNoMessage THEN
          RUN showMessages IN gshSessionManager (INPUT  "The SDO/SBO " + cObjectName + " could not be found, or there are no attributes available for this object. The object could not be launched. Action aborted.",    /* message to display */
                                                 INPUT  "ERR":U,          /* error type */
                                                 INPUT  "&OK,&Cancel":U,    /* button list */
                                                 INPUT  "&OK":U,           /* default button */ 
                                                 INPUT  "&Cancel":U,       /* cancel button */
                                                 INPUT  "SDO/SBO Invalid attributes":U,             /* error window title */
                                                 INPUT  YES,              /* display if empty */ 
                                                 INPUT  ?,                /* container handle */ 
                                                 OUTPUT cButton           /* button pressed */
                                                ).
        RUN setDataLinkActive.
        RETURN.
      END.
    END.
    
    cSDOAttributes = "":U.
    FOR EACH buAttributeValue
        EXCLUSIVE-LOCK:
      IF buAttributeValue.AttributeLabel = "ForeignFields":U THEN
         buAttributeValue.AttributeValue = pcForeignFields.
      
      IF buAttributeValue.AttributeLabel = "RowsToBatch":U AND 
        ((gcFilterValue <> "":U AND gcFilterValue <> ?) /*OR  
         glExpand = FALSE*/) THEN
         buAttributeValue.AttributeValue = "1".
      IF buAttributeValue.AttributeValue = ? THEN
        buAttributeValue.AttributeValue = "?":U.
      ASSIGN cSDOAttributes = IF cSDOAttributes = "":U 
                              THEN buAttributeValue.AttributeLabel + CHR(4) + buAttributeValue.AttributeValue
                              ELSE cSDOAttributes + CHR(3) + buAttributeValue.AttributeLabel + CHR(4) + buAttributeValue.AttributeValue.
    END.
    
    IF INDEX(cSDOAttributes,"ForeignFields") = 0 AND 
       pcForeignFields <> "":U THEN
      ASSIGN cSDOAttributes = IF cSDOAttributes = "":U 
                              THEN "ForeignFields":U + CHR(4) + pcForeignFields
                              ELSE cSDOAttributes + CHR(3) + "ForeignFields":U + CHR(4) + pcForeignFields.
    
    {get ContainerHandle hWindow}.
    RUN constructObject (INPUT  pcSDOSBOName + CHR(3) + "DBAWARE",
                         INPUT  hWindow:HANDLE,
                         INPUT  cSDOAttributes,
                         OUTPUT phSDOHandle).
    DYNAMIC-FUNCTION("setOpenOnInit":U IN phSDOHandle, FALSE).
    
    RUN initializeObject IN phSDOHandle.
    
    /* We don't need these tables */
    EMPTY TEMP-TABLE bu_object_instance.
    EMPTY TEMP-TABLE bu_page.
    EMPTY TEMP-TABLE bu_page_instance.
    EMPTY TEMP-TABLE bu_link.
    EMPTY TEMP-TABLE buAttributeValue.
    EMPTY TEMP-TABLE buUiEvent.
    
    IF VALID-HANDLE(hParentSDO) AND 
       VALID-HANDLE(phSDOHandle) THEN DO:
       RUN addLink (hParentSDO, "DATA":U, phSDOHandle).
       {set DataSource hParentSDO phSDOHandle}.
    END.
    
    IF pcForeignFields <> "":U THEN
      RUN dataAvailable IN phSDOHandle (?).

    CREATE buRunningSDOs.
    ASSIGN buRunningSDOs.cSDOName   = pcSDOSBOName
           buRunningSDOs.hSDOHandle = phSDOHandle.
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "deleteComplete":U IN phSDOHandle.
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "dataAvailable":U IN phSDOHandle.
  END.
  ELSE DO:
    /* Need to re-initialize this SDO to refresh the foreign fields */
    phSDOHandle = buRunningSDOs.hSDOHandle.
    /* This will reset the query to it's initial state */
    DYNAMIC-FUNCTION("setQueryWhere":U IN phSDOHandle, "":U).
    
    IF pcForeignFields <> "":U THEN DO:
      cForeignFields = "":U.
      DO iLoop = 1 TO NUM-ENTRIES(pcForeignFields):
        cForeignFields = IF cForeignFields = "":U THEN ENTRY(iLoop + 1,pcForeignFields) ELSE cForeignFields + ",":U + ENTRY(iLoop + 1,pcForeignFields).
        iLoop = iLoop + 1.
      END.
      cForeignFieldValues = DYNAMIC-FUNCTION("columnStringValue":U IN hParentSDO, cForeignFields).
      DYNAMIC-FUNCTION("setForeignValues":U IN phSDOHandle, cForeignFieldValues).
      RUN dataAvailable IN phSDOHandle (?).
    END.
  END.
  
  IF gcFilterValue <> "":U AND
     gcFilterValue <> ?    AND
     VALID-HANDLE(phSDOHandle) THEN DO:
    ASSIGN cQueryString    = "":U.
           cQueryString    = DYNAMIC-FUNCTION("getQueryString":U IN phSDOHandle).
    DO iLoop = 1 TO NUM-ENTRIES(gcFilterValue,CHR(1)):
      cFilterString = ENTRY(iLoop,gcFilterValue,CHR(1)).
      /* This might look like a complicated way to retrieve the values specified     
        for the filter, but when this was initially designed I didn't take the      
        European numeric format into account and I used a ',' comma as the separator
        and the ENTRY function wouldn't work with our Obj fields.                   
        I had one of two choices:                                                   
        1. Update the document and change the way the filter viewer works; or       
        2. Change the TreeView (here) to accommodate with the -E format.             
                                                                                    
        The later made more sense since it would only confuse all the users that    
        already started to use the filter viewer.                                   */
      IF NUM-ENTRIES(cFilterString) >= 3 THEN DO:
        ASSIGN cFilterFieldName  = ENTRY(1,cFilterString)
               cFilterFieldValue = SUBSTRING(cFilterString,INDEX(cFilterString,",":U,1) + 1,LENGTH(cFilterString))
               cFilterFieldValue = SUBSTRING(cFilterFieldValue,1,R-INDEX(cFilterFieldValue,",":U) - 1)
               cFilterOperator   = TRIM(SUBSTRING(cFilterString,R-INDEX(cFilterString,",":U) + 1,LENGTH(cFilterString)))
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          NEXT.
        
        IF cFilterOperator = "":U THEN
          cFilterOperator = "=":U.
      END.
      ELSE
        NEXT.
      cWhere = "":U.
      /* Make sure that the filter we are setting is not already in 
         the query string. We do not want to duplicate the filter */
      ASSIGN lAlreadyInQuery = FALSE
             lDoNotSetFilter = FALSE.

      IF INDEX(cQueryString,cFilterFieldName + " ":U + TRIM(cFilterOperator)) > 0 THEN
        lAlreadyInQuery = TRUE.
      /* Check the SDO if we can set the tree filter for this query */
      IF LOOKUP("noTreeFilter",phSDOHandle:INTERNAL-ENTRIES) > 0 THEN
        lDoNotSetFilter = TRUE.
      /* Strip field name ONLY from filter field name - tables or db names should
         not be included when checking if the field is available in the query */
      IF NUM-ENTRIES(cFilterFieldName,".":U) >= 2 THEN
        cFilterFieldNameOnly = ENTRY(NUM-ENTRIES(cFilterFieldName,".":U),cFilterFieldName,".":U).
      ELSE
        cFilterFieldNameOnly = cFilterFieldName.
      
      IF cFilterFieldNameOnly = "":U THEN
        cFilterFieldNameOnly = cFilterFieldName.
      IF (NUM-ENTRIES(cFilterFieldName,".":U) = 2 AND 
          DYNAMIC-FUNCTION("ColumnTable":U IN phSDOHandle, cFilterFieldNameOnly) = ENTRY(1,cFilterFieldName,".":U)) OR
         NUM-ENTRIES(cFilterFieldName,".":U) = 1 THEN DO:
        IF LOOKUP(cFilterFieldNameOnly,DYNAMIC-FUNCTION("getDataColumns":U IN phSDOHandle)) > 0 AND 
           NOT lAlreadyInQuery AND
           NOT lDoNotSetFilter THEN DO:
          DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cFilterFieldName + " ":U + TRIM(cFilterOperator) + " '" + cFilterFieldValue + "'", "":U, "AND":U).
          ASSIGN cWhere = cFilterFieldName + " ":U + TRIM(cFilterOperator) + " '" + cFilterFieldValue + "'" + CHR(3) + CHR(3) + "AND":U.
          cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
          {set manualAddQueryWhere cWhere phSDOHandle}.
        END.
      END.
    END.
  END.
  
  IF plStructuredSDO AND 
     NUM-ENTRIES(pcParentChildFld,"^":U) >= 3 THEN DO:
    DEFINE VARIABLE cFirstFilter AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cParentField AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDataType    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMatchValue  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cParentRef   AS CHARACTER  NO-UNDO.

    ASSIGN cFirstFilter = ENTRY(1,pcParentChildFld,"^":U).
           cParentField = ENTRY(2,pcParentChildFld,"^":U).
           cDataType    = ENTRY(4,pcParentChildFld,"^":U).
           cParentRef   = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX,"TAG",gcCurrExpandNodeKey).

    cMatchValue = "":U.
    IF cParentRef = "":U THEN DO:
      CASE cDataType:
        WHEN "CHARACTER":U THEN
          cMatchValue = "''":U.
        WHEN "DECIMAL":U OR WHEN "INTEGER":U THEN
            cMatchValue = "0":U.
        WHEN "DATE":U THEN
          cMatchValue = "?":U.
      END CASE.
    END.
    ELSE DO:
      CASE cDataType:
        WHEN "CHARACTER":U THEN
          cMatchValue = "'" + cParentRef + "'":U.
        WHEN "DECIMAL":U THEN
            cMatchValue = "DECIMAL(":U + cParentRef + ")":U.
        WHEN "INTEGER":U THEN
          cMatchValue = "INTEGER(":U + cParentRef + ")":U.
        WHEN "DATE":U THEN
          cMatchValue = "DATE(":U + cParentRef + ")":U.
      END CASE.
    END.
    
    IF DYNAMIC-FUNCTION("ColumnTable":U IN phSDOHandle, cParentField) <> ? AND 
       DYNAMIC-FUNCTION("ColumnTable":U IN phSDOHandle, cParentField) <> "":U THEN DO:
      /* For first round only list parent objects */
      IF cParentRef = "":U THEN DO:
        IF cFirstFilter <> "":U THEN DO:
        DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cFirstFilter,"":U, "AND":U).
          ASSIGN cWhere = cFirstFilter + CHR(3) + CHR(3) + "AND":U.
          cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
          {set manualAddQueryWhere cWhere phSDOHandle}.
        END.
      END.
      ELSE DO:
        /* Clear any previous queries */
        {set QueryWhere "":U phSDOHandle}.
        DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cParentField + " = ":U + cMatchValue, "":U, "AND":U).
        ASSIGN cWhere = cParentField + " = ":U + cMatchValue + CHR(3) + CHR(3) + "AND":U.
        cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
        {set manualAddQueryWhere cWhere phSDOHandle}.
      END.
    END.
  END.
  /* Since we set the SDO not to open the query on initialization - we should now 
     open the query manually */
  IF glExpand = TRUE THEN
    DYNAMIC-FUNCTION("setRowsToBatch":U IN phSDOHandle, 200).
  DYNAMIC-FUNCTION("openQuery":U IN phSDOHandle).
  
  IF VALID-HANDLE(hParentSDO) THEN
    ASSIGN buRunningSDOs.hParentSDO = hParentSDO.
  
  /* If there is an SDV running that uses the last launched SDO
     we want to reposition the SDO to that last displayed record
     in that viewer. This will ensure that it is repositioned 
     after the node has been expanded. */
  IF ghSDOHandle = phSDOHandle THEN
    glReposSDO = TRUE.
  
  RUN setDataLinkActive.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manualInitializeObjects wWin 
PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     To instantiate objects on container in controlled order.
  Parameters:  <none>
  Notes:       Called from initializeObject of containr.p via Astra2
               customisation.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
            
  IF NUM-ENTRIES(gcObjectHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(gcObjectHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, gcObjectHandles)).
    /* We do not want the folder toolbar visualized when the node selected 
       is a menu object */
    IF glMenuMaintenance AND 
       hHandle = ghFolderToolbar THEN
      NEXT.
    
    /* Do not re-initialize Folder Window */
    IF VALID-HANDLE(ghFolder) AND
       ghFolder = hHandle AND 
       INDEX(hHandle:FILE-NAME,"afspfoldr":U) <> 0 THEN
      NEXT.
    RUN initializeObject IN hHandle.
    
    IF hHandle = ghContainerToolbar OR
       hHandle = ghTreeViewOCX      OR 
       hHandle = ghFolderToolbar    OR 
       hHandle = ghFilterViewer     OR
       hHandle = ghFolder           THEN
      NEXT.
    ELSE DO:
      CREATE ttNonTreeObjects.
      ASSIGN ttNonTreeObjects.hObjectHandle = hHandle.
    END.
  END.
  
  ghDefaultMenuBar = {&WINDOW-NAME}:MENU-BAR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuOverride wWin 
PROCEDURE menuOverride :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates a new sub-menu to create menu-items usually
               found under the File menu option, but due to the Folder ToolBar
               added onto this container, the File menu item was duplicated 
               each time a new object was instansiated.
  Parameters:  IO Handle - The handle of the parent menu for menu items being
                           created for the Folder ToolBar.
  Notes:       This sub-menu is destroyed whenever a new logical object is 
               launched.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER phParentMenu  AS HANDLE   NO-UNDO.

  DEFINE VARIABLE hNewSubMenu AS HANDLE   NO-UNDO.
  
  IF VALID-HANDLE(ghOverridenSubMenu) THEN DO:
    phParentMenu = ghOverridenSubMenu.
    RETURN.
  END.
    
  /* Supply a default menu-item */
  IF ghCurrentLabel = "":U THEN
    ghCurrentLabel = "Folder".
    
  CREATE SUB-MENU hNewSubMenu
  ASSIGN
      NAME = STRING(RANDOM(0,TIME))
      SENSITIVE = TRUE
      LABEL = ghCurrentLabel
      PARENT = phParentMenu 
      PRIVATE-DATA = "dynamictoolbar":U
      .
  ASSIGN phParentMenu       = hNewSubMenu
         ghOverridenSubMenu = phParentMenu.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeAddRecord wWin 
PROCEDURE nodeAddRecord :
/*------------------------------------------------------------------------------
  Purpose:     When no child nodes are available, we want to launch the appropriate
               logical object in 'ADD' mode to allow the user to add the first 
               child node.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdNodeObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piChildren    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNode  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuf                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrentNode            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeChecked            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNodeLabelExpression    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeObj                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hImage                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelectedImage          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeChecked            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSort                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFirstChildNodeKey      AS CHARACTER  NO-UNDO.

  /* If the node has children other than the first dummy record, first expand
     the node, select the first object so that the objects is instansiated and
     then publish the ADD event - this is a shortcut for expanding the node, 
     selecting the first one and then pressing the ADD icon from a users point of view */
  cFirstChildNodeKey = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILD":U,pcParentNode).
  
  IF DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "TEXT":U,cFirstChildNodeKey) = "+":U THEN
    RUN tvNodeEvent ("EXPAND", pcParentNode).
  IF INTEGER(DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U,pcParentNode)) > 0  THEN DO:
    DYNAMIC-FUNCTION("setProperty" IN ghTreeViewOCX, "EXPANDED":U,pcParentNode, "YES").
    ASSIGN cFirstChildNodeKey = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILD", pcParentNode).
    DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cFirstChildNodeKey).
    RUN tvNodeSelected (cFirstChildNodeKey).
    PUBLISH 'addRecord' FROM ghFolderToolbar.
    RETURN.
  END.
  
  /* Only if there are no child nodes (except the dummy) we will continue with 
    this process */
  FIND FIRST ttNode
       WHERE ttNode.node_obj = pdNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN 
    RETURN.
  ASSIGN cLogicalObject         = ttNode.logical_object
         cRunAttribute          = ttNode.run_attribute
         cNodeLabel             = ttNode.node_label
         cPrimarySDO            = ttNode.data_source
         gdNodeObj              = pdNodeObj
         lNodeChecked           = ttNode.node_checked
         cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         NO-ERROR.
  
  
  IF INDEX(cPrimarySDO,"/":U) = 0 AND
     INDEX(cPrimarySDO,"\":U) = 0 THEN DO:
     cSDOSBOName = returnSDOName(cPrimarySDO).
  END.
  
  /* Create A dummy Node that will become the new child node */
  {get TreeDataTable hTable ghTreeViewOCX}.  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
  
  
  RUN createDummyChild (INPUT hBuf,
                        INPUT gcCurrentNodeKey,
                        INPUT "NEW":U).
  
  ASSIGN hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,gcCurrentNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  IF hBuf:AVAILABLE THEN
    ASSIGN hNodeObj:BUFFER-VALUE       = pdNodeObj
           hNodeChecked:BUFFER-VALUE   = lNodeChecked
           hImage:BUFFER-VALUE         = cImageFileName
           hSelectedImage:BUFFER-VALUE = cSelectedImageFileName
           hSort:BUFFER-VALUE          = TRUE.
  
  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
  
  cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN ghTreeViewOCX).
  IF cCurrentNode <> ? THEN DO:
    DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
    setNodeExpanded(cCurrentNode,FALSE).
    glExpand = TRUE.
    RUN tvNodeSelected (cCurrentNode).
    RUN tvNodeEvent    ("EXPANDNOW", cCurrentNode).
    ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILD", cCurrentNode).
           cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "FIRSTSIBLING", cCurrentNode).
    IF cCurrentNode <> ? THEN DO:
      DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
      RUN tvNodeSelected (cCurrentNode).
    END.
  END.
  
  /* Launch the appropriate object in 'Add' mode */
  RUN createRepositoryObjects 
            (INPUT cLogicalObject, 
             INPUT cSDOSBOName,
             INPUT THIS-PROCEDURE,
             INPUT cRunAttribute).
  
  ASSIGN gcNewContainerMode = "Add":U.

  PUBLISH 'addRecord' FROM ghFolderToolbar.
  
  glNewChildNode = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeSelected wWin 
PROCEDURE nodeSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey               AS CHARACTER  NO-UNDO.
  
  
  DEFINE VARIABLE dNodeObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cLogicalObject          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMenuObject             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSDOSBOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeExpanded           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTable                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDetailList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImageFileName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSelectedImageFileName  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cPrivateData            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeLabel              AS CHARACTER  NO-UNDO.

  glDelete = FALSE.

  {get TreeDataTable hTable ghTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  RUN setDataLinkActive.
  /* Force container to VIEW mode when a new node is selected */
  gcNewContainerMode = "View".
  
  ASSIGN cNodeDetail = getNodeDetails(hTable, pcNodeKey).
  
  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)) 
         lNodeExpanded = ENTRY(4,cNodeDetail,CHR(2)) = "TRUE":U.
  
  /* Check if the node is a MENU structure - we need to read the submenus */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0  THEN DO:
    lMenuObject = TRUE.
            
    ASSIGN cLogicalObject  = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 1 THEN ENTRY(2,ENTRY(1,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cRunAttribute   = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 2 THEN ENTRY(2,ENTRY(2,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cDataSource     = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 3 THEN ENTRY(2,ENTRY(3,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           NO-ERROR.
  END.
  ELSE
    lMenuObject = FALSE.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN 
    RETURN.
  ELSE IF lMenuObject = FALSE THEN
    ASSIGN cLogicalObject   = ttNode.logical_object
           cRunAttribute    = ttNode.run_attribute
           cDataSource      = ttNode.data_source
           cNodeLabel       = ttNode.node_label
           cPrimarySDO      = ttNode.primary_sdo
           NO-ERROR.
  
  ASSIGN cImageFileName         = ttNode.image_file_name
         cSelectedImageFileName = ttNode.selected_image_file_name
         ghCurrentLabel         = ttNode.node_label
         NO-ERROR.

  setStatusBarText(pcNodeKey, cNodeLabel).

  cSDOSBOName = returnSDOName(cPrimarySDO).
  ASSIGN gcCurrentNodeKey = pcNodeKey
         gcParentNode     = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, INPUT "PARENT":U, INPUT gcCurrentNodeKey) 
         NO-ERROR.

  glMenuMaintenance = FALSE.
  IF cLogicalObject <> "":U AND 
     glNewChildNode = FALSE THEN DO:
    ASSIGN glMenuMaintenance  = lMenuObject
           gcLastLaunchedNode = gcCurrentNodeKey.
    RUN createRepositoryObjects 
              (INPUT cLogicalObject, 
               INPUT cSDOSBOName,
               INPUT THIS-PROCEDURE,
               INPUT cRunAttribute).
  END.
  ELSE IF cLogicalObject = "":U THEN DO:
    RUN destroyNonTreeObjects. /* Clear the application side */
  END.
  
  IF lMenuObject = TRUE AND 
     INTEGER(DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U,pcNodeKey)) = 0 THEN DO:
    {aflaunch.i &PLIP  = 'ry/app/rytrenodep.p' 
                &IPROC = 'readMenuStructure' 
                &ONAPP = 'YES'
                &PLIST = "(INPUT '':U, INPUT DECIMAL(cDataSource), OUTPUT cDetailList)"
                &AUTOKILL = YES}

    RUN stripMNUDetails (INPUT pcNodeKey,
                         INPUT cDetailList,
                         INPUT dNodeObj,
                         INPUT cImageFileName,
                         INPUT cSelectedImageFileName).
    RUN populateTree IN ghTreeViewOCX (hTable, pcNodeKey).
    IF VALID-HANDLE(ghFolderToolbar) THEN
      RUN hideObject IN ghFolderToolbar.
  END.
  
  glExpand = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindow wWin 
PROCEDURE packWindow :
/*------------------------------------------------------------------------------
  Purpose:     To work out minimum window dimensions according to contents
  Parameters:  input resize flag
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piPage   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plResize AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE lv_layout_code  AS CHARACTER.
  DEFINE VARIABLE hPageInstanceTT AS HANDLE NO-UNDO.
  DEFINE VARIABLE hPageTT         AS HANDLE NO-UNDO.

  DEFINE VARIABLE dContainerToolbarHeight   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderToolbarHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFilterViewerHeight       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFilterViewerWidth        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dTitleHeight              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRectangleHeight          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cButton                   AS CHARACTER  NO-UNDO.
  
  hPageInstanceTT = TEMP-TABLE tt_page_instance:HANDLE.
  hPageTT         = TEMP-TABLE tt_page:HANDLE.
  
  {get Page0LayoutManager lv_layout_code}.
  
  IF gcTreeLayoutCode <> lv_layout_code THEN DO:
    /* Store TreeView's ContainerToolbar and Folder Info elsewhere for the momemnt */
    /* If whe don't do this, the resize procedure will try to reposition them */
    EMPTY TEMP-TABLE tt_exclude_page_instance.
    FOR EACH  tt_page_instance
        WHERE tt_page_instance.object_instance_handle = ghContainerToolbar
        OR    tt_page_instance.object_instance_handle = ghFolderToolbar
        OR    tt_page_instance.object_instance_handle = ghFolder
        EXCLUSIVE-LOCK:
        CREATE tt_exclude_page_instance.
        BUFFER-COPY tt_page_instance TO
                    tt_exclude_page_instance.
      DELETE tt_page_instance.
    END.
    FOR EACH  tt_page_instance
        WHERE tt_page_instance.page_number <> 0
        EXCLUSIVE-LOCK:
      CREATE tt_exclude_page_instance.
      BUFFER-COPY tt_page_instance TO
                  tt_exclude_page_instance.
      ASSIGN tt_exclude_page_instance.iOldPageNo = tt_page_instance.page_number
             tt_page_instance.page_number        = 0.
    END.
  END.
  
  RUN packWindow IN gsh_LayoutManager (
      INPUT piPage,
      INPUT lv_layout_code,
      INPUT hPageInstanceTT:DEFAULT-BUFFER-HANDLE,
      INPUT hPageTT:DEFAULT-BUFFER-HANDLE,
      INPUT {&WINDOW-NAME}, 
      INPUT FRAME {&FRAME-NAME}:HANDLE,
      INPUT 0, /*gdMinimumWindowWidth,*/
      INPUT 0, /*gdMinimumWindowHeight,*/
      INPUT gdMaximumWindowWidth,
      INPUT gdMaximumWindowHeight,
      INPUT plResize
      ).  

  /* Check forced exit of the dynamic container.
   * We may get window packing errors here.      */
  IF RETURN-VALUE NE "":U THEN
  DO:
      RUN showMessages IN gshSessionManager ( INPUT  RETURN-VALUE,
                                              INPUT  "ERR":U,                  /* error type */
                                              INPUT  "&OK":U,                  /* button list */
                                              INPUT  "&OK":U,                  /* default button */ 
                                              INPUT  "&OK":U,                  /* cancel button */
                                              INPUT  "Folder window error":U,  /* error window title */
                                              INPUT  YES,                      /* display if empty */ 
                                              INPUT  THIS-PROCEDURE,           /* container handle */ 
                                              OUTPUT cButton               ).  /* button pressed */
      RUN exitObject.
      RETURN.
  END.    /* forced exit */
  
  IF gcTreeLayoutCode <> lv_layout_code THEN DO:
    ASSIGN gdMinInstanceWidth  = {&WINDOW-NAME}:MIN-WIDTH-CHARS
           gdMinInstanceHeight = {&WINDOW-NAME}:MIN-HEIGHT-CHARS.
           
    /* Now copy these Saved Instances back */
    FOR EACH  tt_exclude_page_instance
        WHERE tt_exclude_page_instance.iOldPageNo <> 0
        EXCLUSIVE-LOCK:
        FIND FIRST tt_page_instance
             WHERE tt_page_instance.object_instance_handle = tt_exclude_page_instance.object_instance_handle
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE tt_page_instance THEN
          ASSIGN tt_page_instance.page_number = tt_exclude_page_instance.iOldPageNo.
      DELETE tt_exclude_page_instance.
    END.
    
    FOR EACH  tt_exclude_page_instance
        EXCLUSIVE-LOCK:
      CREATE tt_page_instance.
      BUFFER-COPY tt_exclude_page_instance TO
                  tt_page_instance.
      DELETE tt_exclude_page_instance.
    END.
  END.
  
  IF VALID-HANDLE(ghFilterViewer) THEN 
    ASSIGN dFilterViewerHeight = DYNAMIC-FUNCTION("getHeight" IN ghFilterViewer)
           dFilterViewerWidth  = DYNAMIC-FUNCTION("getWidth" IN ghFilterViewer).
  
  IF gcTreeLayoutCode = lv_layout_code THEN
    ASSIGN gdMinimumWindowWidth  = IF dFilterViewerWidth > {&WINDOW-NAME}:MIN-WIDTH-CHARS THEN dFilterViewerWidth ELSE {&WINDOW-NAME}:MIN-WIDTH-CHARS
           {&WINDOW-NAME}:MIN-WIDTH-CHARS  = IF dFilterViewerWidth <> 0 AND {&WINDOW-NAME}:MIN-WIDTH-CHARS < dFilterViewerWidth THEN dFilterViewerWidth ELSE {&WINDOW-NAME}:MIN-WIDTH-CHARS + 2
           gdMinimumWindowHeight = {&WINDOW-NAME}:MIN-HEIGHT-CHARS + dFilterViewerHeight.
  ELSE
    ASSIGN gdMinimumFolderWidth            = {&WINDOW-NAME}:MIN-WIDTH-CHARS
           gdMinimumFolderHeight           = {&WINDOW-NAME}:MIN-HEIGHT-CHARS
           {&WINDOW-NAME}:MIN-HEIGHT-CHARS = {&WINDOW-NAME}:MIN-HEIGHT-CHARS + rctBorder:COL + fiTitle:HEIGHT + DYNAMIC-FUNCTION("getHeight":U IN ghFolderToolbar) + 2 + dFilterViewerHeight
           {&WINDOW-NAME}:MIN-WIDTH-CHARS  = {&WINDOW-NAME}:MIN-WIDTH-CHARS + 2 /*fiResizeFillIn:COL + 7 /*+ dFilterViewerWidth*/*/ .
             
  IF {&WINDOW-NAME}:MIN-WIDTH-CHARS < dFilterViewerWidth THEN
    {&WINDOW-NAME}:MIN-WIDTH-CHARS = dFilterViewerWidth + 2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passSDOForeignFields wWin 
PROCEDURE passSDOForeignFields :
/*------------------------------------------------------------------------------
  Purpose:  pass SdoForeignFields to any SDO's with a data link from THIS-PROCEDURE

  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOName AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cDataTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSdoForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTarget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE   NO-UNDO.
  
  FIND FIRST ttRunningSDOs NO-LOCK
       WHERE ttRunningSDOs.cSDOName = pcSDOName NO-ERROR.
  IF AVAILABLE ttRunningSDOs THEN DO:
    {get ForeignFields cSdoForeignFields ttRunningSDOs.hSDOHandle}.
  END.
  ELSE DO:
    {get SdoForeignFields cSdoForeignFields}.
  END.
    
  {get DataTarget cDataTargets}.
  
  IF cSdoForeignFields <> "" THEN DO:   
    DO iEntry = 1 TO NUM-ENTRIES(cDataTargets):
      hDataTarget = WIDGET-HANDLE(ENTRY(iEntry,cDataTargets)).
          
      IF LOOKUP("setForeignFields", hDataTarget:INTERNAL-ENTRIES) <> 0 THEN DO: 
        DYNAMIC-FUNCTION('setForeignFields' IN hDataTarget, cSdoForeignFields).                                             
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareNodeTranslation wWin 
PROCEDURE prepareNodeTranslation :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will step through all the Plain Text nodes and
               create a record in the translate temp-table to get the translated
               values back to be translated when creating these text nodes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL    NO-UNDO.

  EMPTY TEMP-TABLE ttTranslate.

  dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentLanguageObj":U,
                                INPUT NO)).
     
  FOR EACH  ttNode
      WHERE ttNode.data_source_type = "TXT":U
      NO-LOCK:
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = dCurrentLanguageObj
      ttTranslate.cObjectName = gcObjectName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "Node":U
      ttTranslate.cWidgetName = "Node_":U + ttNode.data_source
      ttTranslate.hWidgetHandle = ?
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = ttNode.data_source
      ttTranslate.cTranslatedLabel = "":U
      ttTranslate.cOriginalTooltip = "":U
      ttTranslate.cTranslatedTooltip = "":U
      .
  END.
  
  RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                 INPUT-OUTPUT TABLE ttTranslate).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeTTLinks wWin 
PROCEDURE removeTTLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDOName       AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER tt_source_object_instance FOR tt_object_instance.
  DEFINE BUFFER tt_target_object_instance FOR tt_object_instance.
  
  DEFINE VARIABLE hSourceObject AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hTargetObject AS HANDLE       NO-UNDO.
  
  DEFINE VARIABLE hObject       AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cLinks        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop         AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lLinkExists   AS LOGICAL      NO-UNDO.
  
  /* Just delete the navigation link to the Folder Toolbar - This link will be
     ra-added for the new object bieng started */
  FOR EACH  tt_link
      WHERE tt_link.link_name = "Navigation":
      FIND FIRST tt_source_object_instance
          WHERE tt_source_object_instance.object_instance_obj = tt_link.source_object_instance_obj NO-ERROR.

      FIND FIRST tt_target_object_instance
          WHERE tt_target_object_instance.object_instance_obj = tt_link.target_object_instance_obj NO-ERROR.

      hSourceObject = (IF AVAILABLE tt_source_object_instance THEN tt_source_object_instance.object_instance_handle ELSE THIS-PROCEDURE).
      hTargetObject = (IF AVAILABLE tt_target_object_instance THEN tt_target_object_instance.object_instance_handle ELSE THIS-PROCEDURE).
      
      FIND FIRST ttRunningSDOs NO-LOCK
           WHERE ttRunningSDOs.cSDOName = pcSDOName NO-ERROR.
      IF AVAILABLE ttRunningSDOs THEN
        ASSIGN hSourceObject = THIS-PROCEDURE
               hTargetObject = ttRunningSDOs.hSDOHandle.
      
      /* For a TreeView with a FolderToolbar the Link is changed from the Container To the FolderToolbar handle */
      IF VALID-HANDLE(ghFolderToolbar) THEN
        cLinks = DYNAMIC-FUNCTION("linkHandles":U IN ghFolderToolbar, tt_link.link_name + "-Target":U).
      ELSE
        cLinks = DYNAMIC-FUNCTION("linkHandles":U, tt_link.link_name + "-Source":U).
      
      lLinkExists = FALSE.
      CHECK_EXISTS:
      DO iLoop = 1 TO NUM-ENTRIES(cLinks):
        hObject = WIDGET-HANDLE(ENTRY(iLoop,cLinks)).
        IF (VALID-HANDLE(ghFolderToolbar)     AND 
            hObject = hTargetObject)          OR 
           (NOT VALID-HANDLE(ghFolderToolbar) AND 
            hObject = hSourceObject)          THEN DO:
          lLinkExists = TRUE.
          LEAVE CHECK_EXISTS.
        END.
      END.
      IF lLinkExists = TRUE THEN DO:
        IF VALID-HANDLE(ghFolderToolbar) THEN
          RUN removeLink(ghFolderToolbar, tt_link.link_name, hTargetObject).
        ELSE
          RUN removeLink(hSourceObject, tt_link.link_name, hTargetObject).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionParentSDO wWin 
PROCEDURE repositionParentSDO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentNodeSDO AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid   AS ROWID      NO-UNDO.
  DEFINE VARIABLE dNodeObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttNode FOR ttNode.

  /** Check that the Parent SDO/SBO is relatively pathed **/
  IF INDEX(pcParentNodeSDO,"/":U) = 0 AND
     INDEX(pcParentNodeSDO,"\":U) = 0 AND 
     pcParentNodeSDO <> "":U THEN DO:
     pcParentNodeSDO = returnSDOName(pcParentNodeSDO).
  END.
  /* Now we need to loop through the parent nodes to find the 
     parent node that is an SDO - then we need to reposition that
     SDO to the current selected record to get the correct foreign
     fields */
  FIND FIRST ttRunningSDOs
       WHERE ttRunningSDOs.cSDOName = pcParentNodeSDO
       NO-LOCK NO-ERROR.
  IF AVAILABLE ttRunningSDOs THEN DO:
    cParentNodeKey = "":U.
    {get TreeDataTable hTable ghTreeViewOCX}.
    cParentNodeKey = pcParentNodeKey.
    SEARCH_FOR_PARENT:
    DO WHILE TRUE:
      IF cParentNodeKey = ? OR
         cParentNodeKey = "":U THEN
        LEAVE SEARCH_FOR_PARENT.
      ELSE DO:
        IF VALID-HANDLE(hTable) THEN DO:
          ASSIGN cNodeDetail = getNodeDetails(hTable, cParentNodeKey).

          ASSIGN dNodeObj     = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
                 rRecordRowid = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
          FIND FIRST bttNode
               WHERE bttNode.node_obj = dNodeObj
               NO-LOCK NO-ERROR.
          IF bttNode.data_source_type = "SDO":U THEN
            LEAVE SEARCH_FOR_PARENT.
        END.
      END.
      cParentNodeKey = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "PARENT":U, cParentNodeKey).
    END. /* WHILE TRUE */
    IF cParentNodeKey <> ? AND
       cParentNodeKey <> "":U THEN DO:
      RUN setDataLinkInActive.
      RUN repositionSDO (INPUT "":U,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ?,
                         INPUT rRecordRowid,
                         INPUT cParentNodeKey).
      RUN setDataLinkActive.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionSDO wWin 
PROCEDURE repositionSDO :
/*------------------------------------------------------------------------------
  Purpose:     Repositions an SDO to a selected Record Rowid
  Parameters:  I - pcForeignFields - Foreign Field pairs
               I - phSDOHandle     - The handle to the SDO to be repositioned
               I - prRecordRowid   - The RowID of the record to reposition to
               I - phParentSDO     - The handle to the parent node's SDO
               I - pcNodeKey       - The key to the selected node
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phSDOHandle     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phParentSDO     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER prRecordRowid   AS ROWID      NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey       AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNodeDetail AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordRef  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable      AS HANDLE     NO-UNDO.

  {get TreeDataTable hTable ghTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT phSDOHandle).

  IF LENGTH(TRIM(cValueList)) > 0 THEN 
    ASSIGN cObjField = ENTRY(3, cValueList, CHR(4)).


  ASSIGN cNodeDetail = getNodeDetails(hTable, pcNodeKey).
  ASSIGN cRecordRef  = IF NUM-ENTRIES(cNodeDetail,CHR(2)) >= 5 THEN ENTRY(5,cNodeDetail,CHR(2)) ELSE "":U.

  IF prRecordRowid <> ? THEN DO:
    DYNAMIC-FUNCTION("setQueryWhere":U IN phSDOHandle, "":U).
    /* Re-initialze the SDO to get the query back to a normal state */
    DYNAMIC-FUNCTION('assignQuerySelection':U IN phSDOHandle, cObjField , cRecordRef, '':U).
    DYNAMIC-FUNCTION('openQuery':U IN phSDOHandle). 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord wWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Captures the event when a record being Modify was reset.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  ASSIGN gcCurrentMode = "Cancel".
  
  gcNewContainerMode = "View".
  
  RUN setContainerViewMode.
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    RUN enableObject IN ghTreeViewOCX.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeAndPositionWindow wWin 
PROCEDURE resizeAndPositionWindow :
/*------------------------------------------------------------------------------
  Purpose:     Resize and place window on previous saved settings
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plMenuController    AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcProfileData       AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cWidth      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHeight     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cColumn     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRow        AS CHARACTER  NO-UNDO.
    
    IF NUM-ENTRIES(pcProfileData, CHR(3)) = 4 THEN
    DO:
        ASSIGN
            /* Ensure that the values have the correct decimal points. 
             * These values are always stored using the American numeric format
             * ie. using a "." as decimal point.                               */
            cColumn = ENTRY(1, pcProfileData, CHR(3))
            cColumn = REPLACE(cColumn, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

            cRow = ENTRY(2, pcProfileData, CHR(3))
            cRow = REPLACE(cRow, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

            cWidth = ENTRY(3, pcProfileData, CHR(3))
            cWidth = REPLACE(cWidth, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

            cHeight = ENTRY(4, pcProfileData, CHR(3))
            cHeight = REPLACE(cHeight, ".":U, SESSION:NUMERIC-DECIMAL-POINT)        
          .
          
      IF DECIMAL(cWidth) < 1 THEN
        cWidth = "1":U.
      IF DECIMAL(cHeight) < 1 THEN
        cHeight = "1":U.
      ASSIGN
          FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
          {&WINDOW-NAME}:WIDTH-CHARS  = MIN(MAX(DECIMAL(cWidth), {&WINDOW-NAME}:MIN-WIDTH-CHARS), 
                                             (SESSION:WIDTH-CHARS - 2.5))
          {&WINDOW-NAME}:HEIGHT-CHARS = MIN(MAX(DECIMAL(cHeight), ({&WINDOW-NAME}:MIN-HEIGHT-CHARS)),({&WINDOW-NAME}:MAX-HEIGHT-CHARS),
                                             (SESSION:HEIGHT-CHARS - 2))
          {&WINDOW-NAME}:COLUMN        = IF (DECIMAL(cColumn) + {&WINDOW-NAME}:WIDTH-CHARS) >= SESSION:WIDTH-CHARS THEN
                                              MAX(SESSION:WIDTH-CHARS - {&WINDOW-NAME}:WIDTH-CHARS, 1)
                                         ELSE IF DECIMAL(cColumn) < 0 THEN 1
                                         ELSE DECIMAL(cColumn)
          {&WINDOW-NAME}:ROW           = IF (DECIMAL(cRow) + {&WINDOW-NAME}:HEIGHT-CHARS) >= SESSION:HEIGHT-CHARS THEN
                                              MAX(SESSION:HEIGHT-CHARS - {&WINDOW-NAME}:HEIGHT-CHARS - 1.5, 1)
                                         ELSE IF DECIMAL(cRow) < 0 THEN 1
                                         ELSE DECIMAL(cRow)
          FRAME {&FRAME-NAME}:WIDTH = {&WINDOW-NAME}:WIDTH
          FRAME {&FRAME-NAME}:HEIGHT = {&WINDOW-NAME}:HEIGHT
          FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = {&WINDOW-NAME}:WIDTH
          FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
          FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
          NO-ERROR.
    END.
    ELSE DO:
      IF plMenuController THEN DO:        
        ASSIGN
            FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
            {&WINDOW-NAME}:ROW = 1
            {&WINDOW-NAME}:COL = 1
            {&WINDOW-NAME}:MIN-WIDTH-CHARS = IF gdMinimumWindowWidth <= 0 THEN 1 ELSE gdMinimumWindowWidth 
            {&WINDOW-NAME}:WIDTH-CHARS = IF gdMaximumWindowWidth <= 0 THEN 1 ELSE gdMaximumWindowWidth
            {&WINDOW-NAME}:MIN-HEIGHT-CHARS = IF gdMinimumWindowHeight <= 0 THEN 1 ELSE gdMinimumWindowHeight
            {&WINDOW-NAME}:MAX-HEIGHT-CHARS = IF gdMaximumWindowHeight <= 0 THEN 1 ELSE gdMaximumWindowHeight
            FRAME {&FRAME-NAME}:WIDTH = {&WINDOW-NAME}:WIDTH
            FRAME {&FRAME-NAME}:HEIGHT = {&WINDOW-NAME}:HEIGHT
            FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = {&WINDOW-NAME}:WIDTH
            FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
            FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
            NO-ERROR.
      END.
      ELSE DO:
        ASSIGN
            FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
            {&WINDOW-NAME}:ROW = 1
            {&WINDOW-NAME}:COL = 1
            {&WINDOW-NAME}:MIN-WIDTH-CHARS  = IF gdMinimumWindowWidth <= 0 THEN 1 ELSE gdMinimumWindowWidth 
            {&WINDOW-NAME}:MIN-HEIGHT-CHARS = IF gdMinimumWindowHeight <= 0 THEN 1 ELSE gdMinimumWindowHeight
            {&WINDOW-NAME}:MAX-HEIGHT-CHARS = IF gdMaximumWindowHeight <= 0 THEN 1 ELSE gdMaximumWindowHeight
            FRAME {&FRAME-NAME}:SCROLLABLE  = FALSE
            NO-ERROR.
      END.
    END.
    /** Make sure that we will still see a treeView if and error was encountered with one of the other statements **/
    /** Set to maximum size **/
    IF ERROR-STATUS:ERROR THEN
        ASSIGN
            FRAME {&FRAME-NAME}:SCROLLABLE  = TRUE
            {&WINDOW-NAME}:ROW              = 1
            {&WINDOW-NAME}:COL              = 1
            {&WINDOW-NAME}:MIN-WIDTH-CHARS  = 10
            {&WINDOW-NAME}:MAX-WIDTH-CHARS  = SESSION:WIDTH - 1
            {&WINDOW-NAME}:WIDTH-CHARS      = SESSION:WIDTH - 5
            {&WINDOW-NAME}:MIN-HEIGHT-CHARS = 10
            {&WINDOW-NAME}:MAX-HEIGHT-CHARS = SESSION:HEIGHT - 1
            {&WINDOW-NAME}:HEIGHT-CHARS     = SESSION:HEIGHT - 6
            FRAME {&FRAME-NAME}:WIDTH       = {&WINDOW-NAME}:WIDTH
            FRAME {&FRAME-NAME}:HEIGHT      = {&WINDOW-NAME}:HEIGHT
            FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = {&WINDOW-NAME}:WIDTH
            FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
            FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
            NO-ERROR.
    
                                                      
    APPLY "WINDOW-RESIZED":U TO {&WINDOW-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow wWin 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayoutCode         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPageInstanceTT     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPageTT             AS HANDLE     NO-UNDO.  
                                                 
  DEFINE VARIABLE dAllowedMinWidth    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAllowedMinHeight   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRow                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn             AS DECIMAL    NO-UNDO.
  
  RUN getTopLeft (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.
      
  {get Page0LayoutManager cLayoutCode}.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN dAllowedMinWidth  = gdMinimumFolderWidth  + fiResizeFillIn:COL + 3.5 
           dAllowedMinHeight = gdMinimumFolderHeight.
  END.
  IF {&WINDOW-NAME}:WIDTH-CHARS < dAllowedMinWidth THEN
    ASSIGN {&WINDOW-NAME}:WIDTH-CHARS  = dAllowedMinWidth.
  IF {&WINDOW-NAME}:HEIGHT-CHARS < dAllowedMinHeight THEN
    ASSIGN {&WINDOW-NAME}:HEIGHT-CHARS = dAllowedMinHeight.
                                    
  IF {&WINDOW-NAME}:WIDTH-CHARS > SESSION:WIDTH-CHARS THEN DO:
    ASSIGN {&WINDOW-NAME}:WIDTH-CHARS = SESSION:WIDTH-CHARS.
    IF fiResizeFillIn:COL > ({&WINDOW-NAME}:WIDTH-CHARS - gdMinInstanceWidth - 5) THEN
      fiResizeFillIn:COL = ({&WINDOW-NAME}:WIDTH-CHARS - gdMinInstanceWidth - 5).
           
    APPLY "WINDOW-RESIZED":U TO {&WINDOW-NAME}.
  END.
  
  IF glMenuMaintenance AND 
     NOT glTreeViewDefaults THEN DO:
    /* Store TreeView's ContainerToolbar and Folder Info elsewhere for the momemnt */
    /* If whe don't do this, the resize procedure will try to reposition them */
    EMPTY TEMP-TABLE tt_exclude_page_instance.
    FOR EACH  tt_page_instance
        WHERE tt_page_instance.object_instance_handle = ghContainerToolbar
        OR (   tt_page_instance.object_instance_handle = ghFolder
               AND NOT glMenuMaintenance)
        OR    tt_page_instance.object_instance_handle = ghFolderToolBar
        EXCLUSIVE-LOCK:
        CREATE tt_exclude_page_instance.
        BUFFER-COPY tt_page_instance TO
                    tt_exclude_page_instance.
      DELETE tt_page_instance.
    END.
  END.
  
  IF CAN-FIND(FIRST tt_view_page_instance) THEN DO:
    EMPTY TEMP-TABLE tt_page_instance.
    FOR EACH tt_view_page_instance:
      CREATE tt_page_instance.
      BUFFER-COPY tt_view_page_instance TO tt_page_instance.
    END.
    EMPTY TEMP-TABLE tt_page.
    FOR EACH tt_view_page:
      CREATE tt_page.
      BUFFER-COPY tt_view_page TO tt_page.
    END.
  END.
  hPageInstanceTT = TEMP-TABLE tt_page_instance:HANDLE.
  hPageTT         = TEMP-TABLE tt_page:HANDLE.
  
  PUBLISH "windowToBeSized":U FROM THIS-PROCEDURE.
    
  /* The code to find the following handles were placed here because of some timing issues that were encountered with resizing */
  IF NOT VALID-HANDLE(ghContainerToolbar) THEN ghContainerToolbar = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U, INPUT "Toolbar-Source"))).
  IF NOT VALID-HANDLE(ghTreeViewOCX)      THEN ghTreeViewOCX      = WIDGET-HANDLE(entry(1, DYNAMIC-FUNCTION("linkHandles":U, INPUT "TVController-Source":U))). 
  IF NOT VALID-HANDLE(ghFilterViewer)     THEN ghFilterViewer     = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U, INPUT "TreeFilter-Source"))).
  IF NOT VALID-HANDLE(ghFolder)           THEN ghFolder           = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U, INPUT "Page-Source"))).

  IF VALID-HANDLE(ghFilterViewer) THEN
    SUBSCRIBE PROCEDURE ghTreeViewOCX TO "filterDataAvailable":U IN ghFilterViewer.

  RUN resizeWindow IN gsh_LayoutManager (
      INPUT cLayoutCode,
      INPUT hPageInstanceTT:DEFAULT-BUFFER-HANDLE,
      INPUT hPageTT:DEFAULT-BUFFER-HANDLE,
      INPUT {&WINDOW-NAME}, 
      INPUT FRAME {&FRAME-NAME}:HANDLE
      ).  
    
  IF glMenuMaintenance AND 
     NOT glTreeViewDefaults THEN DO:
    /* Now copy these Saved Instances back */
    FOR EACH  tt_exclude_page_instance
        EXCLUSIVE-LOCK:
      CREATE tt_page_instance.
      BUFFER-COPY tt_exclude_page_instance TO
                  tt_page_instance.
      DELETE tt_exclude_page_instance.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator wWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm2\dyntreeview.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveTreeViewWidth wWin 
PROCEDURE saveTreeViewWidth :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSaveWindowPos      AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.

  ASSIGN lSaveWindowPos = NO.

  /* We have to check if this handle is valid since it might 
    have been killed if a developer was running something
    and closed the AppBuilder and it then attempts to close
    down any running containers. */
  IF VALID-HANDLE(gshProfileManager) THEN
   RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT "SaveSizPos":U,
                                            INPUT NO,
                                            INPUT-OUTPUT rProfileRid,
                                            OUTPUT cProfileData).
  ASSIGN
    lSaveWindowPos = cProfileData <> "NO":U.

  /* Only position and size if asked to */
  IF lSaveWindowPos THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cProfileData = REPLACE(STRING(fiResizeFillIn:COL), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
  
    IF cProfileData <> "":U AND LENGTH(gcObjectName) > 0 THEN DO:
     /* We have to check if this handle is valid since it might 
        have been killed if a developer was running something
        and closed the AppBuilder and it then attempts to close
        down any running containers. */
     IF VALID-HANDLE(gshProfileManager) THEN
       RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code */
                                                INPUT "DynTVSize":U,         /* Profile code */
                                                INPUT gcObjectName,         /* Profile data key */
                                                INPUT ?,                   /* Rowid of profile data */
                                                INPUT cProfileData,        /* Profile data value */
                                                INPUT NO,                  /* Delete flag */
                                                INPUT "PER":u).            /* Save flag (permanent) */
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerModifyMode wWin 
PROCEDURE setContainerModifyMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio modify mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  
  IF NUM-ENTRIES(gcToolbarHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(gcToolbarHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, gcToolbarHandles)).
    PUBLISH "updateMode" FROM hHandle ("enable").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerViewMode wWin 
PROCEDURE setContainerViewMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio view mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle                   AS HANDLE     NO-UNDO.
  
  IF NUM-ENTRIES(gcToolbarHandles) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(gcToolbarHandles):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, gcToolbarHandles)).
    PUBLISH "updateMode" FROM hHandle ("view").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCurrentRecordData wWin 
PROCEDURE setCurrentRecordData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCurrentOEM  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdCurrentObj  AS DECIMAL    NO-UNDO.
  

  ASSIGN gcCurrentOEM       = pcCurrentOEM
         gdCurrentRecordObj = pdCurrentObj.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataLinkActive wWin 
PROCEDURE setDataLinkActive :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reset all data-links to active
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE BUFFER b_ttRunningSDOs FOR ttRunningSDOs.
  
  FIND FIRST b_ttRunningSDOs
       WHERE b_ttRunningSDOs.cSDOName = gcPrimarySDOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE b_ttRunningSDOs THEN
    NEXT.
  
  FOR EACH  ttDataLinks
      WHERE ttDataLinks.hSourceHandle = b_ttRunningSDOs.hSDOHandle
      EXCLUSIVE-LOCK:
    RUN addLink (ttDataLinks.hSourceHandle, 'Data':U, ttDataLinks.hTargetHandle) NO-ERROR.
    IF ttDataLinks.lUpdateLink THEN
      RUN addLink (ttDataLinks.hTargetHandle, 'Update':U, ttDataLinks.hSourceHandle) NO-ERROR.
    DELETE ttDataLinks.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataLinkInActive wWin 
PROCEDURE setDataLinkInActive :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reset all data-links to inactive
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinks          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER b_ttRunningSDOs FOR ttRunningSDOs.
  
  FIND FIRST b_ttRunningSDOs
       WHERE b_ttRunningSDOs.cSDOName = gcPrimarySDOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE b_ttRunningSDOs THEN
    NEXT.
  
  cLinks = DYNAMIC-FUNCTION("linkHandles":U IN b_ttRunningSDOs.hSDOHandle, "Data-Target":U).
  CHECK_EXISTS:
  DO iLoop = 1 TO NUM-ENTRIES(cLinks):
    hObject = WIDGET-HANDLE(ENTRY(iLoop,cLinks)).
    IF NOT VALID-HANDLE(hObject) THEN
      NEXT CHECK_EXISTS.
    cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN hObject).
    IF hObject <> THIS-PROCEDURE AND 
       cObjectType = "SmartDataViewer" THEN DO:
      CREATE ttDataLinks.
      ASSIGN ttDataLinks.hSourceHandle = b_ttRunningSDOs.hSDOHandle
             ttDataLinks.hTargetHandle = hObject.
      RUN removeLink (b_ttRunningSDOs.hSDOHandle, 'Data':U, hObject).
      IF DYNAMIC-FUNCTION("linkHandles":U IN hObject, "Update-Target":U) <> "":U THEN DO:
        RUN removeLink (hObject, 'Update':U, b_ttRunningSDOs.hSDOHandle).
        ASSIGN ttDataLinks.lUpdateLink = TRUE.
      END.
      ELSE
        ASSIGN ttDataLinks.lUpdateLink = FALSE.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLocalAttributes wWin 
PROCEDURE setLocalAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Setup properties of dynamic container as read from object
               repository
  Parameters:  Input list of properties.
  Notes:       The list is in the same format as returned to the function
               instancePropertyList, with CHR(3) between entries and CHR(4)
               between the property name and its value in each entry. 
               NOTE: we must get the datatype for each property in order to set
               it.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcPropList AS CHARACTER NO-UNDO.

DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cProperty         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry            AS CHARACTER  NO-UNDO.    
DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSignature        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE phObject          AS HANDLE     NO-UNDO.
DEFINE VARIABLE lAnswer           AS LOGICAL    NO-UNDO.

phObject = THIS-PROCEDURE.
     
attribute-loop:
DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
  ASSIGN
    cEntry = ENTRY(iEntry, pcPropList, CHR(3))
    cProperty = ENTRY(1, cEntry, CHR(4))
    cValue = ENTRY(2, cEntry, CHR(4))
    .
  /* Do not overwrite container mode if set */
  IF cProperty = "ContainerMode":U AND gcContainerMode <> "":U THEN
    NEXT attribute-loop.
  
  /* Get the datatype from the return type of the get function. */
  cSignature = dynamic-function
    ("Signature":U IN phObject, "get":U + cProperty).
  
  /** The message code removed to avoid issues with attributes being set in an
   *  object which are not available as properties in the object. This becomes
   *  as issue as more objects become dynamic (eg viewers, lookups, etc); attributes
   *  such as HEIGHT-CHARS are necessary for the instantiation of the object, but 
   *  are not strictly properties of the object.                                  */
  IF cSignature NE "":U THEN  
  CASE ENTRY(2,cSignature):
    WHEN "INTEGER":U THEN
      dynamic-function("set":U + cProperty IN phObject, INT(cValue)).
    WHEN "DECIMAL":U THEN
      dynamic-function("set":U + cProperty IN phObject, DEC(cValue)).
    WHEN "CHARACTER":U THEN
      dynamic-function("set":U + cProperty IN phObject, cValue).
    WHEN "LOGICAL":U THEN
      dynamic-function("set":U + cProperty IN phObject,
        IF cValue = "yes":U THEN yes ELSE no).
  END CASE.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMinMaxDefaults wWin 
PROCEDURE setMinMaxDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Set the container and frame's minimum and maximum width and height
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plMenuController    AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcProfileData       AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.
    DEFINE VARIABLE lSaveWindowPos      AS LOGICAL      NO-UNDO.

    IF plMenuController THEN
    DO:
      ASSIGN
          gdMinimumWindowWidth = 100
          gdMinimumWindowHeight = 11                  
          gdMaximumWindowWidth = SESSION:WIDTH - 1
          gdMaximumWindowHeight = SESSION:HEIGHT - 1.
    END.
    ELSE DO:
      ASSIGN 
          gdMinimumWindowWidth = 100
          gdMinimumWindowHeight = 11
          gdMaximumWindowWidth = SESSION:WIDTH - 1
          gdMaximumWindowHeight = SESSION:HEIGHT - 1.                  
    END.

    /* determine if window positions and sizes are saved */
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rProfileRid,
                                             OUTPUT pcProfileData).
                                             
    ASSIGN
        lSaveWindowPos = pcProfileData <> "NO":U.

    IF  lSaveWindowPos THEN
    DO:
      ASSIGN
        cObjectName  = getLogicalObjectName()
        pcProfileData = "":U
        rProfileRid  = ?.
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code                            */
                                               INPUT "SizePos":U,         /* Profile code                                 */
                                               INPUT cObjectName,         /* Profile data key                             */
                                               INPUT "NO":U,              /* Get next record flag                         */
                                               INPUT-OUTPUT rProfileRid,  /* Rowid of profile data                        */
                                               OUTPUT pcProfileData).      /* Found profile data. Positions as follows:    */
                                                                          /* 1 = col,         2 = row,                    */
                                                                          /* 3 = width chars, 4 = height chars            */
    END. /* save window position and sizes */
    ELSE ASSIGN pcProfileData = "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTreeViewWidth wWin 
PROCEDURE setTreeViewWidth :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProfileData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rProfileRid     AS ROWID      NO-UNDO.
  DEFINE VARIABLE lSaveWindowPos  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dTVCol          AS DECIMAL    NO-UNDO.
  /* determine if window positions and sizes are saved */
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT "SaveSizPos":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rProfileRid,
                                             OUTPUT cProfileData).
                                           
  ASSIGN
      lSaveWindowPos = cProfileData <> "NO":U.

  IF  lSaveWindowPos THEN DO:
    ASSIGN
      cProfileData = "":U
      rProfileRid  = ?.
    
    IF VALID-HANDLE(gshProfileManager) THEN
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                               INPUT "DynTVSize":U,       /* Profile code          */
                                               INPUT gcObjectName,        /* Profile data key      */
                                               INPUT "NO":U,              /* Get next record flag  */
                                               INPUT-OUTPUT rProfileRid,  /* Rowid of profile data */
                                               OUTPUT cProfileData).      /* Found profile data. */
  END. /* save window position and sizes */
  ELSE ASSIGN cProfileData = "":U.
  
  IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND INDEX(cProfileData,".") <> 0 THEN
    cProfileData = REPLACE(cProfileData,".":U,",":U).
  IF SESSION:NUMERIC-DECIMAL-POINT = ".":U AND INDEX(cProfileData,",") <> 0 THEN
    cProfileData = REPLACE(cProfileData,",":U,".":U).
  
  dTVCol = 0.
  IF cProfileData <> "":U THEN
    dTVCol = DECIMAL(cProfileData) NO-ERROR.
  
  IF dTVCol >= {&WINDOW-NAME}:WIDTH-CHARS THEN
    dTVCol = {&WINDOW-NAME}:WIDTH-CHARS / 3. /* Make it one third of the window's width */
  
  IF dTVCol <= 0 THEN
    fiResizeFillIn:COL IN FRAME {&FRAME-NAME} = 41.
  
  IF NOT ERROR-STATUS:ERROR AND
     dTVCol > 0 THEN
    fiResizeFillIn:COL IN FRAME {&FRAME-NAME} = dTVCol.
  
  APPLY "END-MOVE":U TO fiResizeFillIn IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stripMNUDetails wWin 
PROCEDURE stripMNUDetails :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will strip the details passed to it to create
               nodes for a menu structure
  Parameters:  I pcParentNodeKey - The Node Key of the parent node
               I pcDetailList    - The list of menu details to be created
               I pdNodeObj       - The node_obj of the gsm_node record that
                                   created this list
               I pcImage         - The File name of the image to be displayed
               I pcSelectedImage - The File name of the image to be displayed 
                                   when selected
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentNodeKey AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDetailList    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdNodeObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcImage         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSelectedImage AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hTable                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hBuf                  AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hParentNodeKey        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeKey              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeObj              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeLabel            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hPrivateData          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hImage                AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSelectedImage        AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hNodeInsert           AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSort                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cNodeLabel            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER    NO-UNDO.
  
  {get TreeDataTable hTable ghTreeViewOCX}.  

  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = hTable:DEFAULT-BUFFER-HANDLE
         hParentNodeKey = hBuf:BUFFER-FIELD('parent_node_key':U)
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
         hNodeLabel     = hBuf:BUFFER-FIELD('node_label':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
         hImage         = hBuf:BUFFER-FIELD('image':U)
         hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
         hSort          = hBuf:BUFFER-FIELD('node_sort':U)
         hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
      
  DO iLoop = 1 TO NUM-ENTRIES(pcDetailList,CHR(3)):
    ASSIGN cNodeLabel   = ENTRY(1,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           cPrivateData = ENTRY(2,ENTRY(iLoop,pcDetailList,CHR(3)),CHR(4))
           NO-ERROR.
    IF cNodeLabel = "":U THEN
      NEXT.
    hBuf:BUFFER-CREATE().
    ASSIGN hParentNodeKey:BUFFER-VALUE = pcParentNodeKey
           hNodeObj:BUFFER-VALUE       = pdNodeObj
           hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
           hNodeLabel:BUFFER-VALUE     = cNodeLabel
           hPrivateData:BUFFER-VALUE   = cPrivateData
           hImage:BUFFER-VALUE         = pcImage
           hSelectedImage:BUFFER-VALUE = pcSelectedImage
           hSort:BUFFER-VALUE          = TRUE
           hNodeInsert:BUFFER-VALUE    = IF pcParentNodeKey = "":U THEN 1 ELSE 4.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar wWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCurrentNode  AS CHARACTER   NO-UNDO.
  
  CASE pcAction:
    WHEN "disableData":U THEN DO: 
      /* If an error occurred of validation vailed - don't continue */
      IF RETURN-VALUE = "ADM-ERROR":U THEN
        RETURN.
      
      IF gcState = "updateComplete":U AND 
         (gcCurrentMode = 'add':U   OR 
          gcCurrentMode = 'copy':U) THEN DO:
        ASSIGN cCurrentNode     = gcCurrentNodeKey
               gcCurrentNodeKey = ?.
        DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
        RUN tvNodeSelected (cCurrentNode).
        gcState = "":U.
      END.
      IF gcCurrentMode = "delete":U  AND 
         VALID-HANDLE(ghTreeViewOCX) THEN DO:
        /* This solves the problem when deleting a child node that is
           the last node of a parent. It used to jump to the parent node */
        gcCurrentNodeKey = ?.
        cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN ghTreeViewOCX).
        IF cCurrentNode = gcParentNode THEN DO:
          ASSIGN cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILD":U, gcParentNode).
                 cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "LASTSIBLING", cCurrentNode).
          IF cCurrentNode <> ? THEN DO:
            DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
            RUN tvNodeSelected (cCurrentNode).
          END.
          ELSE DO: /* The last child node was deleted - select parent and apply selection to refresh screen */
            IF gcParentNode <> ? THEN DO:
              DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, gcParentNode).
              RUN tvNodeSelected (gcParentNode).
            END. /* VALID-HANDLE(gcParentNode) */
          END. /* ELSE */
        END. /* cCurrentNode = gcParentNode */
        ELSE DO:
          DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
          RUN tvNodeSelected (cCurrentNode).
        END.
        ASSIGN gcState        = "":U
               gcCurrentMode  = "":U.
      END. /* gcCurrentMode = "delete":U */
      
      IF gcCurrentMode = "Cancel":U THEN
        ASSIGN gcState        = "":U
               gcCurrentMode  = "":U
               glNewChildNode = FALSE.
    END. /* "disableData":U */
    OTHERWISE
      RUN SUPER (pcAction).
  END CASE.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent wWin 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEvent     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNodeKey   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeDetail         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNodeExpanded       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid        AS ROWID      NO-UNDO.
  DEFINE VARIABLE cCurrentNodeKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstChild         AS CHARACTER  NO-UNDO.

  IF pcNodeKey = ? AND pcEvent <> "RIGHTCLICK" THEN
    RETURN.
  
  IF pcNodeKey <> ? THEN 
    {get TreeDataTable hTable ghTreeViewOCX}.  
  
  IF VALID-HANDLE(hTable) THEN DO:
    cNodeDetail = getNodeDetails(hTable, pcNodeKey).
    ASSIGN dNodeObj     = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
           rRecordRowid = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
  END.
  
  glReposSDO = FALSE.
  CASE pcEvent:
    WHEN "EXPAND":U OR WHEN "EXPANDNOW":U THEN DO:
      gcCurrExpandNodeKey = pcNodeKey.
      IF NOT VALID-HANDLE(hTable) OR
         pcNodeKey = ? THEN
        RETURN.
      IF pcEvent = "EXPAND":U THEN DO:
        cFirstChild = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "CHILD":U, pcNodeKey).
        IF cFirstChild <> ? THEN DO:
          IF DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, "TEXT":U, cFirstChild) <> "+":U THEN
            LEAVE.
          SESSION:SET-WAIT-STATE("GENERAL":U).
          /* First delete the dummy node */
          ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
          CREATE QUERY hQry.  
          hQry:ADD-BUFFER(hBuf).
          hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cFirstChild)).
          hQry:QUERY-OPEN().
          hQry:GET-FIRST().
          
          IF hBuf:AVAILABLE THEN
            hBuf:BUFFER-DELETE().
          IF VALID-HANDLE(hQry) THEN
            DELETE OBJECT hQry.
          
          RUN deleteNode IN ghTreeViewOCX (cFirstChild).
        END.
      END.
      SESSION:SET-WAIT-STATE("GENERAL":U).
      /* Now scan for new nodes */

      /* First check if the current node is a structured node */
      FIND FIRST ttNode
           WHERE ttNode.node_obj = dNodeObj
           NO-LOCK NO-ERROR.
      IF AVAILABLE ttNode AND 
         ttNode.run_attribute = "STRUCTURED":U THEN
        RUN loadNodeData (pcNodeKey, ttNode.node_obj).
      ELSE DO:
        FOR EACH ttNode 
            WHERE ttNode.parent_node_obj = dNodeObj
            NO-LOCK
            BREAK BY ttNode.node_label:
          RUN loadNodeData (pcNodeKey, ttNode.node_obj).
        END.
      END.
      RUN populateTree IN ghTreeViewOCX (hTable, pcNodeKey).
      /* In some instances we might be viewing data on a SDV on a level, and
         decide to expand nodes on the same level, but for another parent. 
         In such a case the SDO will be refreshed thus losing our data in the
         SDV and we have to refresh the SDO again after the new nodes have
         been build to have the corresponding data on the SDV be the same as
         the current record in the SDO */
      IF glReposSDO THEN DO:
        ASSIGN cCurrentNodeKey  = gcCurrentNodeKey
               gcCurrentNodeKey = ?.
        RUN tvNodeSelected (INPUT cCurrentNodeKey).
      END.
      SESSION:SET-WAIT-STATE("":U).
    END. /* EXPAND */
    WHEN "RIGHTCLICK":U THEN DO:
      IF dNodeObj <> 0 THEN
        RUN buildPopupMenu (INPUT dNodeObj,
                            INPUT pcNodeKey).
      ELSE
        RUN buildPopupMenu (INPUT 0,
                            INPUT "":U).
    END.
  END. /* CASE */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeSelected wWin 
PROCEDURE tvNodeSelected :
/*------------------------------------------------------------------------------
  Purpose:     Occurs when a user selected a node
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNodeKey AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hNodeKey          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNodeKey          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNodeObj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cDataset          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimarySDO       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOSBOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabelSubsFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecordRowid      AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lMenuObject       AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hTable            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cNodeDetail       AS CHARACTER  NO-UNDO.

  IF pcNodeKey = ? THEN
    RETURN.
  
  glDelete = FALSE.

  {get TreeDataTable hTable ghTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN.
  
  RUN setDataLinkActive.
  
  ASSIGN cNodeKey = pcNodeKey.

  /* If the user re-selected the same node - we don't want to do anything again */
  IF cNodeKey = gcCurrentNodeKey THEN
    RETURN.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  ASSIGN cNodeDetail        = getNodeDetails(hTable, cNodeKey)
         gcCurrentNodeKey   = cNodeKey
         gcLastLaunchedNode = IF gcLastLaunchedNode = "":U OR gcLastLaunchedNode = ? THEN cNodeKey ELSE gcLastLaunchedNode.
  
  ASSIGN dNodeObj      = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
         rRecordRowid  = TO-ROWID(ENTRY(2,cNodeDetail,CHR(2))).
         cPrivateData  = ENTRY(3,cNodeDetail,CHR(2)).
  
  ASSIGN gcParentNode = DYNAMIC-FUNCTION("getProperty":U IN ghTreeViewOCX, INPUT "PARENT":U, INPUT gcCurrentNodeKey) 
         NO-ERROR.
  
  /* Check if the node is a MENU structure - we need to read the submenus */
  IF INDEX(cPrivateData,"LogicalObject":U) > 0  THEN DO:
    lMenuObject = TRUE.
            
    ASSIGN cLogicalObject  = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 1 THEN ENTRY(2,ENTRY(1,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           cForeignFields  = "":U
           cDataSourceType = "MNU":U
           cDataSource     = IF NUM-ENTRIES(cPrivateData,CHR(6)) >= 3 THEN ENTRY(2,ENTRY(3,cPrivateData,CHR(7)),CHR(6)) ELSE "":U
           NO-ERROR.
  END.
  ELSE
    lMenuObject = FALSE.

  FIND FIRST ttNode
       WHERE ttNode.node_obj = dNodeObj
       NO-LOCK NO-ERROR.

  IF NOT AVAILABLE ttNode THEN DO:
    SESSION:SET-WAIT-STATE("":U).
    RETURN.
  END.
  
  IF lMenuObject = FALSE THEN
    ASSIGN cLogicalObject   = ttNode.logical_object
           cForeignFields   = ttNode.foreign_fields
           cLabelSubsFields = ttNode.label_text_substitution_fields
           cDataSourceType  = ttNode.data_source_type
           cDataSource      = ttNode.data_source
           cPrimarySDO      = ttNode.primary_sdo
           NO-ERROR.
  
  IF cDataSourceType = "SDO":U OR
    (cDataSourceType = "TXT":U AND
     cPrimarySDO <> "":U) THEN DO:
    /** First check that the SDO/SBO is relatively pathed **/
    IF INDEX(cPrimarySDO,"/":U) = 0 AND
       INDEX(cPrimarySDO,"\":U) = 0 THEN DO:
       cSDOSBOName = returnSDOName(cPrimarySDO).
    END.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey).
    END.
  END.

  /* When an extract program was used to create a node we 
     need to launch the SDO/SBO that is required by the 
     logical object being launched. */
  IF cDataSourceType = "PRG":U AND 
     cLogicalObject <> "":U THEN DO:
    /** First check that the SDO/SBO is relatively pathed **/
    IF INDEX(cPrimarySDO,"/":U) = 0 AND
       INDEX(cPrimarySDO,"\":U) = 0 THEN DO:
       cSDOSBOName = returnSDOName(cPrimarySDO).
    END.
    RUN manageSDOs (INPUT  cSDOSBOName,
                    INPUT  cForeignFields,
                    INPUT  "":U,
                    INPUT cLabelSubsFields,
                    INPUT (ttNode.run_attribute = "STRUCTURED":U),
                    INPUT ttNode.fields_to_store,
                    OUTPUT hSDOHandle).
    IF NOT VALID-HANDLE(hSDOHandle) THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      RETURN.
    END.
    FIND FIRST ttRunningSDOs
         WHERE ttRunningSDOs.cSDOName = cSDOSBOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND
       VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN DO:
      RUN repositionSDO (INPUT cForeignFields,
                         INPUT ttRunningSDOs.hSDOHandle,
                         INPUT ttRunningSDOs.hParentSDO,
                         INPUT rRecordRowid,
                         INPUT cNodeKey).
    END.
  END.
  
  RUN nodeSelected (INPUT cNodeKey).
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord wWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState wWin 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will capture any events like Add, Modify or Copy
  Parameters:  <none>
  Notes:       I pcState - Indicates the new state of the Container
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cParentNode       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentNode      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hCurrentNodeKey   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTable            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNewTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuf              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQry              AS HANDLE     NO-UNDO.

DEFINE VARIABLE hNodeBuf          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNodeKey          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentKey        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPrivateData      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLabel            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hImage            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSelectedImage    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNodeInsert       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSort             AS HANDLE     NO-UNDO.

DEFINE VARIABLE dNodeObj          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cDataset          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSource       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNodeLabel        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabelSubsFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cNodeLabelExpr    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cImageFileName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSelImgFileName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldsToStore    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSubstitute       AS CHARACTER  NO-UNDO EXTENT 10.
DEFINE VARIABLE lNodeChecked      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hNodeObj          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDOHandle        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParentSDO        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValueList        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRecordRef        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRecordRowId      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNodeChecked      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lLabelBlank       AS LOGICAL    NO-UNDO.

RUN setDataLinkActive.

IF pcState = "VIEW":U THEN
  NEXT.
IF gcLastLaunchedNode = ? OR 
   gcLastLaunchedNode = "":U THEN DO:
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    cCurrentNode = DYNAMIC-FUNCTION("getSelectedNode" IN ghTreeViewOCX).
END.
ELSE
  cCurrentNode = gcLastLaunchedNode.
IF pcState = "Update" THEN DO:
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    RUN disableObject IN ghTreeViewOCX.
  gcCurrentMode = gcNewContainerMode.
END.

{get TreeDataTable hTable ghTreeViewOCX}.

IF cCurrentNode = ? THEN DO:
  IF pcState = 'updateComplete':U AND
    (gcCurrentMode = "Add":U OR 
     gcCurrentMode = "Copy":U) THEN DO:
    RUN loadTreeData.
    RUN populateTree IN ghTreeViewOCX (hTable, "":U).
    IF VALID-HANDLE(ghTreeViewOCX) THEN
      RUN enableObject IN ghTreeViewOCX.
    RUN selectFirstNode IN ghTreeViewOCX.    
  END.
  RETURN.
END.

cParentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, INPUT "PARENT":U, INPUT cCurrentNode) NO-ERROR.

IF cParentNode = ? OR
   ERROR-STATUS:ERROR THEN
  ASSIGN cParentNode = DYNAMIC-FUNCTION("getRootNodeParentKey" IN ghTreeViewOCX) NO-ERROR.

/* Grab the handles to the individual fields in the tree data table. */
ASSIGN hBuf            = hTable:DEFAULT-BUFFER-HANDLE
       hNodeObj        = hBuf:BUFFER-FIELD('node_obj':U)
       hCurrentNodeKey = hBuf:BUFFER-FIELD('node_key':U).

CREATE QUERY hQry.  
hQry:ADD-BUFFER(hBuf).
hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,cCurrentNode)).
hQry:QUERY-OPEN().
hQry:GET-FIRST().

DO WHILE hBuf:AVAILABLE:
  ASSIGN dNodeObj     = hNodeObj:BUFFER-VALUE
         cCurrentNode = hCurrentNodeKey:BUFFER-VALUE
         NO-ERROR.
  LEAVE.
END.

IF glNewChildNode THEN
  dNodeObj = gdNodeObj  .

IF VALID-HANDLE(hQry) THEN
  DELETE OBJECT hQry.

FIND FIRST ttNode
     WHERE ttNode.node_obj = dNodeObj
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttNode THEN
  RETURN.

ASSIGN cNodeLabel       = ttNode.node_label
       lNodeChecked     = ttNode.node_checked
       cDataSourceType  = ttNode.data_source_type
       cDataSource      = ttNode.data_source
       cNodeLabelExpr   = ttNode.node_text_label_expression
       cLabelSubsFields = ttNode.label_text_substitution_fields
       cImageFileName   = ttNode.image_file_name
       cSelImgFileName  = ttNode.selected_image_file_name
       cRunAttribute    = ttNode.run_attribute
       cFieldsToStore   = ttNode.fields_to_store
       NO-ERROR.

/* Since we can only add nodes from a DataSource of SDO's in this procedure, */
/* we will not execute this code for any other Data Sources                  */
IF cDataSourceType = "PRG":U THEN DO:
  /* If nodes were created from an extraction program, we will delete all child nodes for that node tree */
  /* and rebuild from scratch */
  
  IF pcState <> "updateComplete":U AND
     pcState <> "deleteComplete":U OR 
     gcCurrentMode = "Cancel" THEN
    RETURN.
  
  /** First we will delete the current structure **/
  DEFINE VARIABLE hDelTree    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hDelNodeKey AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hTBuf       AS HANDLE   NO-UNDO.
  
  
  CREATE TEMP-TABLE hDelTree.
  hDelTree:ADD-NEW-FIELD("NodeKey","Character").
  hDelTree:TEMP-TABLE-PREPARE("ttDelTree").
  
  ASSIGN hTBuf = hDelTree:DEFAULT-BUFFER-HANDLE.
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_obj = &2':U, hTable:NAME,dNodeObj)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  ASSIGN hDelNodeKey = hTBuf:BUFFER-FIELD("NodeKey")
         hNodeKey    = hBuf:BUFFER-FIELD("node_key")
         hParentKey  = hBuf:BUFFER-FIELD("parent_node_key").
  DO WHILE hBuf:AVAILABLE:
    hTBuf:BUFFER-CREATE().
    ASSIGN hDelNodeKey:BUFFER-VALUE = hNodeKey:BUFFER-VALUE.
    RUN deleteNode IN ghTreeViewOCX (INPUT hNodeKey:BUFFER-VALUE).
    hQry:GET-NEXT().
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  RUN loadPRGData (INPUT cParentNode, dNodeObj).
  RUN populateTree IN ghTreeViewOCX (hTable, cParentNode).
  
  /* Select the first child of the rebuild node structure */
  cCurrentNode = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILD":U, cParentNode).
  DYNAMIC-FUNCTION("selectNode" IN ghTreeViewOCX, cCurrentNode).
  RUN tvNodeSelected (cCurrentNode).
  
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    RUN enableObject IN ghTreeViewOCX.
  IF VALID-HANDLE(hDelTree) THEN
    DELETE OBJECT hDelTree.
END.
ELSE
IF cDataSourceType <> "SDO":U THEN
  RETURN.

/** First check that the SDO/SBO is relatively pathed **/
IF INDEX(cDataSource,"/":U) = 0 AND
   INDEX(cDataSource,"\":U) = 0 THEN DO:
   cDataSource = returnSDOName(cDataSource).
   IF cDataSource = "":U THEN
    RETURN.
END.

FIND FIRST ttRunningSDOs
     WHERE ttRunningSDOs.cSDOName = cDataSource
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttRunningSDOs THEN
  RETURN.
ELSE
  ASSIGN hSDOHandle = ttRunningSDOs.hSDOHandle
         hParentSDO = ttRunningSDOs.hParentSDO.

IF NOT VALID-HANDLE(hSDOHandle) THEN
  RETURN.

ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hSDOHandle).
IF LENGTH(TRIM(cValueList)) > 0 THEN 
  ASSIGN cObjField = ENTRY(3, cValueList, CHR(4)).

gcState = pcState.
IF pcState = 'updateComplete':U AND 
   gcCurrentMode <> "Cancel" THEN DO:
  IF VALID-HANDLE(ghTreeViewOCX) AND 
     VALID-HANDLE(hTable) THEN DO:
    IF gcCurrentMode = 'add':U OR 
        gcCurrentMode = 'copy':U THEN DO:
      IF NOT glNewChildNode THEN DO:
        gcCurrentNodeKey = ?.
        ASSIGN hNodeBuf = hTable:DEFAULT-BUFFER-HANDLE.
        CREATE TEMP-TABLE hNewTable.
        hNewTable:CREATE-LIKE(hNodeBuf).
        hNewTable:TEMP-TABLE-PREPARE('tTreeData').
        hBuf = hNewTable:DEFAULT-BUFFER-HANDLE.
        
        hBuf:BUFFER-CREATE().
        lLabelBlank = FALSE.
        
        LABEL_LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
          IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
            LEAVE LABEL_LOOP.
          cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
          IF cSubstitute[iLoop] = ? OR 
             cSubstitute[iLoop] = "":U THEN
            ASSIGN cSubstitute[iLoop] = "":U
                   lLabelBlank        = TRUE.
        END.
        
        ASSIGN hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
               hParentKey     = hBuf:BUFFER-FIELD('parent_node_key':U)
               hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
               hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
               hLabel         = hBuf:BUFFER-FIELD('node_label':U)
               hImage         = hBuf:BUFFER-FIELD('image':U)
               hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
               hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
               hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
               hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
               hSort          = hBuf:BUFFER-FIELD('node_sort':U)
               hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
        
        ASSIGN hParentKey:BUFFER-VALUE     = cParentNode
               hNodeKey:BUFFER-VALUE       = DYNAMIC-FUNCTION('getNextNodeKey':U IN ghTreeViewOCX)
               hNodeObj:BUFFER-VALUE       = dNodeObj
               hLabel:BUFFER-VALUE         = TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
               hRecordRef:BUFFER-VALUE     = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cObjField))
               hRecordRowId:BUFFER-VALUE   = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
               hNodeChecked:BUFFER-VALUE   = lNodeChecked
               hImage:BUFFER-VALUE         = cImageFileName
               hSelectedImage:BUFFER-VALUE = cSelImgFileName
               hSort:BUFFER-VALUE          = TRUE
               hNodeInsert:BUFFER-VALUE    = IF cParentNode = "":U THEN 1 ELSE 4.
        
        hNodeBuf:BUFFER-CREATE().
        hNodeBuf:BUFFER-COPY(hBuf).
        
        gcCurrentNodeKey = hNodeKey:BUFFER-VALUE.
        
        /* For some SDO's we might reference to a field in a table other
           than the primary table, and for these instances the label
           will mostly be blank since the query needs to be refreshed 
           before the secondary tables are fetched. For this reason we
           check the new label created and if it is BLANK we will 
           reposition the SDO to the new record and then get the labels
           and then update the label on the TreeView */
        IF lLabelBlank THEN DO:
          RUN repositionSDO (INPUT "":U,
                             INPUT hSDOHandle,
                             INPUT ?,
                             INPUT hRecordRowId:BUFFER-VALUE,
                             INPUT gcCurrentNodeKey).
          lLabelBlank = FALSE.
          LABEL_LOOP:
          DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
            IF ENTRY(iLoop,cLabelSubsFields) = "":U THEN
              LEAVE LABEL_LOOP.
            cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
            IF cSubstitute[iLoop] = ? THEN
              ASSIGN cSubstitute[iLoop] = "":U
                     lLabelBlank        = TRUE.
          END.
          DYNAMIC-FUNCTION("setProperty":U IN ghTreeViewOCX, "TEXT":U, gcCurrentNodeKey, TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))).
        END.
        /* Now we need to check if the new node might have child nodes */
        IF CAN-FIND(FIRST ttNode
                    WHERE ttNode.parent_node_obj = dNodeObj
                    NO-LOCK) THEN DO:
          RUN createDummyChild (INPUT hBuf,
                                INPUT hNodeKey:BUFFER-VALUE,
                                INPUT "DUMMY":U).
        END.
        RUN populateTree IN ghTreeViewOCX (hBuf, gcParentNode).
      END.
      ELSE DO: /* New Child Node */
        ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
        hSDOHandle = ghSDOHandle.
        
        ASSIGN cCurrentNode = gcCurrentNodeKey
               cParentNode  = gcParentNode.
        CREATE QUERY hQry.  
        hQry:ADD-BUFFER(hBuf).
        hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,gcCurrentNodeKey)).
        hQry:QUERY-OPEN().
        hQry:GET-FIRST().
        
        ASSIGN hNodeKey       = hBuf:BUFFER-FIELD('node_key':U)
               hParentKey     = hBuf:BUFFER-FIELD('parent_node_key':U)
               hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
               hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
               hLabel         = hBuf:BUFFER-FIELD('node_label':U)
               hImage         = hBuf:BUFFER-FIELD('image':U)
               hSelectedImage = hBuf:BUFFER-FIELD('selected_image':U)
               hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U)
               hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
               hNodeChecked   = hBuf:BUFFER-FIELD('node_checked':U)
               hSort          = hBuf:BUFFER-FIELD('node_sort':U)
               hNodeInsert    = hBuf:BUFFER-FIELD('node_insert':U).
        
        gcCurrentNodeKey = hNodeKey:BUFFER-VALUE.
        
        IF INDEX(DYNAMIC-FUNCTION("getQueryString":U IN hSDOHandle),cObjField) > 0 THEN
          RUN manageSDOs (INPUT  IF VALID-HANDLE(hSDOHandle) THEN hSDOHandle:FILE-NAME ELSE "":U,
                          INPUT  DYNAMIC-FUNCTION("getForeignFields":U IN hSDOHandle),
                          INPUT  IF VALID-HANDLE(hParentSDO) THEN hParentSDO:FILE-NAME ELSE "":U,
                          INPUT  cLabelSubsFields,
                          INPUT  (cRunAttribute = "STRUCTURED":U),
                          INPUT  cFieldsToStore,
                          OUTPUT  hSDOHandle).
        
        ASSIGN cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hSDOHandle).
        IF LENGTH(TRIM(cValueList)) > 0 THEN 
          ASSIGN cObjField = ENTRY(3, cValueList, CHR(4)).
        
        DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
          cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
          IF cSubstitute[iLoop] = ? THEN
            cSubstitute[iLoop] = "":U.
        END.
        
        DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).
        RUN refreshRow IN hSDOHandle.
        
        ASSIGN hNodeObj:BUFFER-VALUE       = gdNodeObj
               hLabel:BUFFER-VALUE         = TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))
               hRecordRef:BUFFER-VALUE     = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, cObjField))
               hRecordRowId:BUFFER-VALUE   = TO-ROWID(ENTRY(1,DYNAMIC-FUNCTION("getRowIdent":U IN hSDOHandle)))
               hNodeChecked:BUFFER-VALUE   = lNodeChecked
               hImage:BUFFER-VALUE         = cImageFileName
               hSelectedImage:BUFFER-VALUE = cSelImgFileName
               hSort:BUFFER-VALUE          = TRUE
               hNodeInsert:BUFFER-VALUE    = 4.
        
        /* Now we need to check if the new node might have child nodes */
        IF CAN-FIND(FIRST ttNode
                    WHERE ttNode.parent_node_obj = gdNodeObj
                    NO-LOCK) THEN DO:
          RUN createDummyChild (INPUT hBuf,
                                INPUT cCurrentNode,
                                INPUT "DUMMY":U).
        END.
        
        RUN deleteNode IN ghTreeViewOCX (cCurrentNode).
        RUN populateTree IN ghTreeViewOCX (hBuf, gcParentNode).
        glNewChildNode = FALSE.
        IF VALID-HANDLE(hQry) THEN
          DELETE OBJECT hQry.
      END. /* New Child Node */
    END.
    ELSE DO:
      DYNAMIC-FUNCTION("openQuery":U IN hSDOHandle).

      DO iLoop = 1 TO NUM-ENTRIES(cLabelSubsFields):
        cSubstitute[iLoop] = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hSDOHandle, ENTRY(iLoop,cLabelSubsFields))).
        IF cSubstitute[iLoop] = ? THEN
          cSubstitute[iLoop] = "":U.
      END.
      DYNAMIC-FUNCTION("setProperty":U IN ghTreeViewOCX, "TEXT":U, cCurrentNode, TRIM(SUBSTITUTE(cNodeLabelExpr,cSubstitute[1],cSubstitute[2],cSubstitute[3],cSubstitute[4],cSubstitute[5],cSubstitute[6],cSubstitute[7],cSubstitute[8],cSubstitute[9]))).
    END.
  END.
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    RUN enableObject IN ghTreeViewOCX.
END.

IF pcState = 'deleteComplete':u THEN DO:
  {get TreeDataTable hTable ghTreeViewOCX}.
  IF VALID-HANDLE(ghTreeViewOCX) AND 
     VALID-HANDLE(hTable) THEN DO:
    RUN deleteNode IN ghTreeViewOCX (gcCurrentNodeKey).
    IF gcCurrentNodeKey <> ? THEN DO:
      CREATE QUERY hQry.  
      hQry:ADD-BUFFER(hBuf).
      hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,gcCurrentNodeKey)).
      hQry:QUERY-OPEN().
      hQry:GET-FIRST().
      
      IF hBuf:AVAILABLE THEN
        hBuf:BUFFER-DELETE().
      IF VALID-HANDLE(hQry) THEN
        DELETE OBJECT hQry.
    END.
    gcLastLaunchedNode = "":U.
  END.
END.

RUN setDataLinkActive.

IF pcState = "updateComplete" OR
   pcState = "deleteComplete" THEN DO:
  gcCurrentMode = IF pcState = "deleteComplete" THEN "delete" ELSE gcCurrentMode.
  RUN toolbar (INPUT "disableData").
END.

{set ContainerMode 'VIEW':U}.

IF pcState = 'updateComplete':U AND 
   (gcCurrentMode = 'add':U OR 
    gcCurrentMode = 'copy':U) THEN DO:
  ghSDOHandle = hSDOHandle.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTitleOverride wWin 
PROCEDURE updateTitleOverride :
/*------------------------------------------------------------------------------
  Purpose:     This is an override procedure for the standard ADM2 updateTitle.
               This procedure will make sure that the WINDOW:TITLE is never changes
               when a new record is being displayed in the application area.
  Parameters:  I pcFolderTitle - A character field with the new Folder Title.
  Notes:       
------------------------------------------------------------------------------*/  
  DEFINE INPUT  PARAMETER pcFolderTitle AS CHARACTER  NO-UNDO.
  
  ASSIGN fiTitle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " " + pcFolderTitle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION childWindowsOpen wWin 
FUNCTION childWindowsOpen RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: to check if child windows open from this window - use to give warning
           when closing window with X or ESC 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChildren         AS LOGICAL    NO-UNDO.

  {get containertarget cTargets}.

  ASSIGN lChildren  = NO.
  
  target-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cTargets):
    ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cTargets)) NO-ERROR.
    IF VALID-HANDLE(hHandle) AND
       INDEX(hHandle:FILE-NAME, "rydyncontw":U) <> 0 THEN
    DO:
      ASSIGN lChildren  = YES.
      LEAVE target-loop.    
    END.
  END.
  
  RETURN lChildren.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoSort wWin 
FUNCTION getAutoSort RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns whether there should be lines leading to the roots of the tree or
 not.
------------------------------------------------------------------------------*/
  
  RETURN glAutoSort.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerHandle wWin 
FUNCTION getContainerHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle AS HANDLE   NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE hFrameHandle  AS HANDLE   NO-UNDO.
  
  hFrameHandle = DYNAMIC-FUNCTION("getFrameHandle", {&WINDOW-NAME}:HANDLE).
  hFrameHandle:TITLE = "":U.

  RETURN hFrameHandle.
/*  
  RETURN SUPER( ).
  */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerMode wWin 
FUNCTION getContainerMode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

RETURN gcNewContainerMode.
             
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerObjectHandles wWin 
FUNCTION getContainerObjectHandles RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     To pass out a comma delimited list of object handles created on
               the container - in createobjects.
  Notes:       Used as part of initializeObject in containr.p to initialize
               objects in best possible order, i.e. toolbars, then sdos, then
               other objects, by page.
------------------------------------------------------------------------------*/

  RETURN gcObjectHandles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldList wWin 
FUNCTION getFieldList RETURNS CHARACTER
  (pcForeignFields AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Return a comma delimited list of just the field names in the foreign
            fields list. (Removes table prefixes, and list the fields just once)
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  
  /* Initialize the output value */
  cFieldList = "":U.
  
  /* Check if valid Foreign Fields were specified */
  IF pcForeignFields <> "":U                AND
     pcForeignFields <> ?                   AND
     NUM-ENTRIES(pcForeignFields) MOD 2 = 0 THEN
  
  DO iEntry = 2 TO NUM-ENTRIES(pcForeignFields) BY 2:
    cFieldList = cFieldList + (IF TRIM(cFieldList) = "":U THEN "":U ELSE ",":U)
               + ENTRY(iEntry, pcForeignFields).
  END.
  
  RETURN cFieldList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle wWin 
FUNCTION getFrameHandle RETURNS HANDLE
  ( ip_procedure_handle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR idx AS INT NO-UNDO.
DEF VAR hdl AS HANDLE NO-UNDO.
DEF VAR FRAME_handle AS HANDLE NO-UNDO.

                              
    hdl = ip_procedure_handle:FIRST-CHILD.
    FRAME_handle = ?.
    
    DO WHILE VALID-HANDLE(hdl):
        IF hdl:TYPE = "FRAME" THEN
          RETURN hdl.
        hdl = hdl:FIRST-CHILD NO-ERROR.       
    END.
                                 
  RETURN FRAME_handle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideSelection wWin 
FUNCTION getHideSelection RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns whether the current node in the TreeView will be left highlighted 
 when focus leaves the TreeView.
------------------------------------------------------------------------------*/
  
  RETURN glHideSelection.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageHeight wWin 
FUNCTION getImageHeight RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns the height of images in the image list associated with the TreeView.
------------------------------------------------------------------------------*/
  
  RETURN giImageHeight.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImageWidth wWin 
FUNCTION getImageWidth RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns the width of images in the image list associated with the TreeView.
------------------------------------------------------------------------------*/
  
  RETURN giImageWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceObjectId wWin 
FUNCTION getInstanceObjectId RETURNS DECIMAL
    ( phProcedureHandle     AS HANDLE    ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object Id of the object instance which is found
            using the procedure handle.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER tt_object_instance            FOR tt_object_instance.
    
    FIND FIRST tt_object_instance WHERE
               tt_object_instance.object_instance_handle = phProcedureHandle
               NO-ERROR.
    IF AVAILABLE tt_object_instance THEN
        ASSIGN dObjectInstanceObj = tt_object_instance.object_instance_obj.
    ELSE
        ASSIGN dObjectInstanceObj = 0.

    RETURN dObjectInstanceObj.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalObjectName wWin 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       We needed to override this procedure to keep the original name
               of the TreeView object.
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF gcObjectName = "":U THEN
  gcObjectName =  SUPER( ).
  
  RETURN gcObjectName.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMainTableObj wWin 
FUNCTION getMainTableObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMainTableObj AS DECIMAL    NO-UNDO.
  
  IF VALID-HANDLE(ghTreeViewOCX) THEN
    dMainTableObj = DYNAMIC-FUNCTION("getMainTableObj" IN ghTreeViewOCX).
  RETURN dMainTableObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNodeDetails wWin 
FUNCTION getNodeDetails RETURNS CHARACTER
  ( INPUT phTable   AS HANDLE,
    INPUT pcNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return most common requred information for a 
            selected node.
    Notes:  The string returned is CHR(2) delimited and contains the following
            information:
            nodeObj       - The object number of the gsm_node record
            rRecordRowid  - The rowid of the selected node record
            cPrivateData  - The privateData of the selected node.
            lNodExpanded  - Was the node expanded TRUE/FALSE
            cRecordRef    - The unique record reference 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuf            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeObj        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRowId    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPrivateData    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeExpanded   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRecordRef      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rRecordRowid    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cPrivateData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetails    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNodeExpanded   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRecordRef      AS CHARACTER  NO-UNDO.
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf           = phTable:DEFAULT-BUFFER-HANDLE
         hNodeObj       = hBuf:BUFFER-FIELD('node_obj':U)
         hRecordRowId   = hBuf:BUFFER-FIELD('record_rowid':U)
         hPrivateData   = hBuf:BUFFER-FIELD('private_data':U)
         hNodeExpanded  = hBuf:BUFFER-FIELD('node_expanded':U)
         hRecordRef     = hBuf:BUFFER-FIELD('record_ref':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2":U':U, phTable:NAME,pcNodeKey)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN dNodeObj        = hNodeObj:BUFFER-VALUE 
           rRecordRowid    = hRecordRowId:BUFFER-VALUE 
           cPrivateData    = hPrivateData:BUFFER-VALUE
           lNodeExpanded   = hNodeExpanded:BUFFER-VALUE
           cRecordRef      = hRecordRef:BUFFER-VALUE
           NO-ERROR.
    LEAVE.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
  cNodeDetails = IF dNodeObj <> ? THEN STRING(dNodeObj,">>>>>>>>>>>>>9.999999999":U) ELSE "0.0":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF rRecordRowid <> ? THEN STRING(rRecordRowid) ELSE "?":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF cPrivateData <> ? THEN cPrivateData ELSE "":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF lNodeExpanded <> ? THEN STRING(lNodeExpanded) ELSE "":U.
  cNodeDetails = cNodeDetails + CHR(2) + IF cRecordRef <> ? THEN STRING(cRecordRef) ELSE "":U.

  
  RETURN cNodeDetails.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectVersionNumber wWin 
FUNCTION getObjectVersionNumber RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRootNodeCode wWin 
FUNCTION getRootNodeCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns the Root Node Code to be used to find the gsm_node record that will 
 populate the Root node of the TreeView.
------------------------------------------------------------------------------*/
  
  RETURN gcRootNodeCode.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunTimeAttribute wWin 
FUNCTION getRunTimeAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcInstanceAttributes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowCheckBoxes wWin 
FUNCTION getShowCheckBoxes RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns whether there will be check boxes on the TreeView.
 
------------------------------------------------------------------------------*/
  
  RETURN glShowCheckBoxes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowRootLines wWin 
FUNCTION getShowRootLines RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns whether there should be lines leading to the roots of the tree or
 not.
------------------------------------------------------------------------------*/
  
  RETURN glShowRootLines.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioSource wWin 
FUNCTION getTableioSource RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN ghTableioSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHandles wWin 
FUNCTION getToolbarHandles RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return handles of all toolbars on the container 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcToolbarHandles.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTranslatableNodes wWin 
FUNCTION getTranslatableNodes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return a CHR(1) seperated list with plain text 
            nodes that could be translated.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNodes AS CHARACTER  NO-UNDO.

  FOR EACH  ttNode
      WHERE ttNode.data_source_type = "TXT":U
      NO-LOCK:
    IF LOOKUP(ttNode.data_source,cNodes,CHR(1)) > 0 THEN
      NEXT.
    cNodes = IF cNodes = "":U 
                THEN ttNode.data_source
                ELSE cNodes + CHR(1) + ttNode.data_source.
  END.
  
  RETURN cNodes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeRunAttribute wWin 
FUNCTION getTreeRunAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcLaunchRunAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeStyle wWin 
FUNCTION getTreeStyle RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
 Returns style of the TreeView.
 ------------------------------------------------------------------------------*/
  
  RETURN giTreeStyle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF gcFolderTitle <> "":U THEN
    RETURN gcFolderTitle.
  ELSE
    RETURN {&WINDOW-NAME}:TITLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnSDOName wWin 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will add a relative path to the SDO/SBO name passed to it
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDataSet    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectPath AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectExt  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cButton     AS CHARACTER  NO-UNDO.
    
    
    RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH ryc_smartobject 
                                                  WHERE ryc_smartobject.object_filename = '" + pcSDOSBOName + "', 
                                                  FIRST gsc_object 
                                                  WHERE gsc_object.object_obj = ryc_smartobject.object_obj NO-LOCK ":U,
                                           OUTPUT cDataset ).
    
    cObjectPath = "":U.
    IF cDataset = "":U OR cDataset = ? THEN 
      RETURN "".
    ELSE
      ASSIGN cObjectPath = ENTRY(LOOKUP("gsc_object.object_path":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
             cObjectExt  = ENTRY(LOOKUP("gsc_object.object_extension":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) NO-ERROR.
    IF cObjectPath = "":U OR cObjectPath = ? THEN DO:
      RUN showMessages IN gshSessionManager (INPUT  "The SDO/SBO specified is invalid, remove any path information and check for any typing errors.",    /* message to display */
                                             INPUT  "ERR":U,          /* error type */
                                             INPUT  "&OK,&Cancel":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "&Cancel":U,       /* cancel button */
                                             INPUT  "Initializing SDO/SBO":U,             /* error window title */
                                             INPUT  YES,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).
      
      RETURN "":U.
    END.
    ELSE
      ASSIGN pcSDOSBOName = cObjectPath + "/":U + pcSDOSBOName
             pcSDOSBOName = REPLACE(pcSDOSBOName,"\":U,"/":U).
  
  IF cObjectExt <> "":U AND
     NUM-ENTRIES(pcSDOSBOName,".":U) < 2 THEN
    pcSDOSBOName = pcSDOSBOName + ".":U + cObjectExt.
  
  RETURN pcSDOSBOName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoSort wWin 
FUNCTION setAutoSort RETURNS LOGICAL
  ( INPUT plAutoSort AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Determines whether the TreeView will automatically sort nodes in label order
 or not.
------------------------------------------------------------------------------*/
  
  ASSIGN glAutoSort = plAutoSort.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerMode wWin 
FUNCTION setContainerMode RETURNS LOGICAL
  ( INPUT cContainerMode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /*
  gcNewContainerMode = cContainerMode.
  */
  RETURN SUPER( INPUT cContainerMode ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideSelection wWin 
FUNCTION setHideSelection RETURNS LOGICAL
  ( INPUT plHideSelection AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Sets whether the current node in the TreeView will be left highlighted 
 when focus leaves the TreeView.
------------------------------------------------------------------------------*/
  
  ASSIGN glHideSelection = plHideSelection.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageHeight wWin 
FUNCTION setImageHeight RETURNS LOGICAL
  ( INPUT piImageHeight AS INTEGER ) :
/*------------------------------------------------------------------------------
 Sets the height of the images in image list.
------------------------------------------------------------------------------*/
  
  ASSIGN giImageHeight = piImageHeight.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageWidth wWin 
FUNCTION setImageWidth RETURNS LOGICAL
  ( INPUT piImageWidth AS INTEGER ) :
/*------------------------------------------------------------------------------
 Sets the Width of the images in image list.
------------------------------------------------------------------------------*/
  
  ASSIGN giImageWidth = piImageWidth.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogicalObjectName wWin 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( INPUT cObjectName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/
  gcObjectName = IF gcObjectName = "":U THEN cObjectName ELSE gcObjectName.
  /* Code placed here will execute PRIOR to standard behavior. */

  RETURN SUPER( INPUT cObjectName ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNodeExpanded wWin 
FUNCTION setNodeExpanded RETURNS LOGICAL
  ( INPUT pcNode         AS CHARACTER,
    INPUT plNodeExpanded AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  This function will set the value of the node expanded flag.
    Notes:  lNodeExpanded will contain a value of TRUE or FALSE.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNodeExpanded AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNodeExpanded AS LOGICAL    NO-UNDO.
  
  {get TreeDataTable hTable ghTreeViewOCX}.  
  
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN FALSE.
  
  /* Grab the handles to the individual fields in the tree data table. */
  ASSIGN hBuf          = hTable:DEFAULT-BUFFER-HANDLE
         hNodeExpanded = hBuf:BUFFER-FIELD('node_expanded':U).
  
  CREATE QUERY hQry.  
  hQry:ADD-BUFFER(hBuf).
  hQry:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE &1.node_key = "&2"':U, hTable:NAME,pcNode)).
  hQry:QUERY-OPEN().
  hQry:GET-FIRST().
  
  DO WHILE hBuf:AVAILABLE:
    ASSIGN hNodeExpanded:BUFFER-VALUE = plNodeExpanded
           NO-ERROR.
    LEAVE.
  END.

  IF VALID-HANDLE(hQry) THEN
    DELETE OBJECT hQry.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRootNodeCode wWin 
FUNCTION setRootNodeCode RETURNS LOGICAL
  ( INPUT pcRootNodeCode AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Sets the Root Node Code to be used to find the gsm_node record that will 
 populate the Root node of the TreeView.
------------------------------------------------------------------------------*/
  
  ASSIGN gcRootNodeCode = pcRootNodeCode.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunAttribute wWin 
FUNCTION setRunAttribute RETURNS LOGICAL
  ( INPUT pcRunAttr AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF gcLaunchRunAttribute = "":U AND 
     pcRunAttr <> ? AND
     pcRunAttr <> "?":U THEN
    gcLaunchRunAttribute = pcRunAttr.

   RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowCheckBoxes wWin 
FUNCTION setShowCheckBoxes RETURNS LOGICAL
  ( INPUT plShowCheckBoxes AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Determines whether lines leading to the roots of the tree will be displayed
 or not.
------------------------------------------------------------------------------*/
  
  ASSIGN glShowCheckBoxes = plShowCheckBoxes.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowRootLines wWin 
FUNCTION setShowRootLines RETURNS LOGICAL
  ( INPUT plShowRootLines AS LOGICAL ) :
/*------------------------------------------------------------------------------
 Determines whether lines leading to the roots of the tree will be displayed
 or not.
------------------------------------------------------------------------------*/
  
  ASSIGN glShowRootLines = plShowRootLines.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusBarText wWin 
FUNCTION setStatusBarText RETURNS LOGICAL
  ( INPUT pcNodeKey AS CHARACTER,
    INPUT pcLabel   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  The function will set text in Container's Status Bar
    Notes:  
------------------------------------------------------------------------------*/
  /**
  DEFINE VARIABLE iNumChildren    AS INTEGER    NO-UNDO.
  
  STATUS DEFAULT "":U.
  
  IF NOT VALID-HANDLE(ghTreeViewOCX) THEN
    RETURN FALSE.

  iNumChildren = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U, pcNodeKey).
  IF iNumChildren = 0 THEN DO:
    pcNodeKey = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "PARENT":U, pcNodeKey).
    IF pcNodeKey = ? OR pcNodeKey = "?":U THEN DO:
      STATUS DEFAULT "Select a " + pcLabel + " record.".
      RETURN FALSE.
    END.
    ELSE
      iNumChildren = DYNAMIC-FUNCTION("getProperty" IN ghTreeViewOCX, "CHILDREN":U, pcNodeKey).
  END.
  IF iNumChildren = 1 THEN
    STATUS DEFAULT "1 " + pcLabel + " Record Listed.".
  ELSE
    STATUS DEFAULT STRING(iNumChildren) + " " + pcLabel + " Records Listed.".
**/  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableioSource wWin 
FUNCTION setTableioSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghTableioSource = phSource.

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTemplateObjectName wWin 
FUNCTION setTemplateObjectName RETURNS LOGICAL
  ( INPUT pcTemplateObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Added as placeholder - this was a new property added and am not to 
            sure what the purpose of the attribute is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTreeStyle wWin 
FUNCTION setTreeStyle RETURNS LOGICAL
  ( INPUT piTreeStyle AS INTEGER ) :
/*------------------------------------------------------------------------------
 Set the Style of the Tree.
------------------------------------------------------------------------------*/
  
  ASSIGN giTreeStyle = piTreeStyle.
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupFolderPages wWin 
FUNCTION setupFolderPages RETURNS LOGICAL
  (pcLogicalObjectName  AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Setup the labels of the folder
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindow       AS HANDLE     NO-UNDO.
  
  IF NOT VALID-HANDLE(ghFolder) THEN
    RETURN FALSE.
  /* If the maintenance programs where shut down, then put the folder window back
     to its original state */
  IF TRIM(pcLogicalObjectName) = "":U THEN
  DO:
    DYNAMIC-FUNCTION("setFolderLabels":U IN ghFolder, INPUT "&Details":U).
    RUN initializeObject IN ghFolder.
    RETURN TRUE.
  END.
  
  cFolderLabels = "&Details".
  FOR FIRST tt_object_instance NO-LOCK
      WHERE tt_object_instance.object_type_code = "smartfolder":U:
    
    cFolderLabels = DYNAMIC-FUNCTION("getPropertyFromList":U IN gshGenManager, tt_object_instance.instance_attribute_list, "FolderLabels":U).
  END.
  
  /* Translate window title and tab folder page labels plus check security for page labels */
  DO:
    DEFINE VARIABLE cContainerName            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRunAttribute             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecuredTokens            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDisabledPages            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectList               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectType               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cLabel                    AS CHARACTER  NO-UNDO.

    {get ContainerHandle hWindow}.
    cContainerName = DYNAMIC-FUNCTION('getLogicalObjectName').
    cRunAttribute  = DYNAMIC-FUNCTION('getRunAttribute').  
    /*
    /* 1st empty current temp-table contents */
    EMPTY TEMP-TABLE ttTranslate.

    /* Add entry for window title */
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = 0
      ttTranslate.cObjectName = cContainerName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "TITLE":U
      ttTranslate.cWidgetName = "TITLE":U
      ttTranslate.hWidgetHandle = hWindow
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = hWindow:TITLE    
      ttTranslate.cTranslatedLabel = "":U  
      ttTranslate.cOriginalTooltip = "":U  
      ttTranslate.cTranslatedTooltip = "":U
      .  
    RELEASE ttTranslate.
*/
    /* check security for folder labels */
    RUN tokenSecurityCheck IN gshSecurityManager (INPUT pcLogicalObjectName,
                                                  INPUT cRunAttribute,
                                                  OUTPUT cSecuredTokens).
    
    label-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
    
      ASSIGN cLabel = ENTRY(iLoop, cFolderLabels, "|":U).

      IF  cSecuredTokens <> "":U
          AND LOOKUP(cLabel,cSecuredTokens) <> 0 THEN
        ASSIGN cDisabledPages = cDisabledPages + (IF cDisabledPages <> "":U THEN ",":U ELSE "":U) +
                                STRING(iLoop).
/*
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = 0
        ttTranslate.cObjectName = cContainerName
        ttTranslate.lGlobal = NO
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = "TAB":U
        ttTranslate.cWidgetName = "TAB":U
        ttTranslate.hWidgetHandle = ghFolder
        ttTranslate.iWidgetEntry = iLoop
        ttTranslate.cOriginalLabel = cLabel
        ttTranslate.cTranslatedLabel = "":U
        ttTranslate.cOriginalTooltip = "":U
        ttTranslate.cTranslatedTooltip = "":U
        .
      RELEASE ttTranslate.
    */
    END.  /* label-loop */
/*
    /* Now got all translation widgets - get translations */
    RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                                   INPUT-OUTPUT TABLE ttTranslate).

    /* now action the translations */  
    translate-loop:
    FOR EACH ttTranslate:
      IF ttTranslate.cTranslatedLabel = "":U AND
         ttTranslate.cTranslatedTooltip = "":U THEN NEXT translate-loop.

      IF ttTranslate.cWidgetType = "title":U AND ttTranslate.cTranslatedLabel <> "":U THEN
      DO:
        hWindow:TITLE = ttTranslate.cTranslatedLabel.
        {set windowName hWindow:TITLE}.      
      END.
      
      IF ttTranslate.cWidgetType = "tab":U THEN
      DO:
         ASSIGN iLoop = LOOKUP(ttTranslate.cOriginalLabel, cFolderLabels, "|":U).
         IF iLoop > 0 THEN
          ASSIGN ENTRY(iLoop, cFolderLabels, "|":U) = ttTranslate.cTranslatedLabel. 
      END.
    END.
    */
    /* translate pages */
    IF cFolderLabels <> "":U THEN
      DYNAMIC-FUNCTION("setFolderLabels":U IN ghFolder, INPUT cFolderLabels).

    /* secure pages */
    IF cDisabledPages <> "":U THEN
      DYNAMIC-FUNCTION("disablePagesInFolder":U IN TARGET-PROCEDURE, INPUT "security," + cDisabledPages).

    RUN initializeObject IN ghFolder.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowName wWin 
FUNCTION setWindowName RETURNS LOGICAL
  ( pcWindowName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF {&WINDOW-NAME}:TITLE = "":U AND pcWindowName <> "":U THEN
    ASSIGN {&WINDOW-NAME}:TITLE = pcWindowName
           gcWindowName         = pcWindowName.
  ELSE DO:
    ASSIGN gcFolderTitle = pcWindowName.
    RUN updateTitleOverride (gcFolderTitle).
  END.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showMessages wWin 
FUNCTION showMessages RETURNS LOGICAL
  ( INPUT pcMessage AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cButton    AS CHARACTER  NO-UNDO.

  RUN showMessages IN gshSessionManager (INPUT  pcMessage,                      /* message to display */
                                         INPUT  "ERR":U,                        /* error type         */
                                         INPUT  "&OK":U,                        /* button list        */
                                         INPUT  "&OK":U,                        /* default button     */ 
                                         INPUT  "&OK":U,                        /* cancel button      */
                                         INPUT  "'TreeViewController Error'":U, /* error window title */
                                         INPUT  YES,                            /* display if empty   */ 
                                         INPUT  THIS-PROCEDURE,                 /* container handle   */ 
                                         OUTPUT cButton).                       /* button pressed     */

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toLogical wWin 
FUNCTION toLogical RETURNS LOGICAL
  ( INPUT pcText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return TRUE/FALSE for any logical text 
            YES/NO 1/0 TRUE/FALSE
    Notes:  
------------------------------------------------------------------------------*/

  CASE pcText:
    WHEN "YES" THEN
      RETURN TRUE.
    WHEN "TRUE" THEN
      RETURN TRUE.
    WHEN "1" THEN
      RETURN TRUE.
    WHEN "NO" THEN
      RETURN FALSE.
    WHEN "FALSE" THEN
      RETURN FALSE.
    WHEN "0" THEN
      RETURN FALSE.
    OTHERWISE 
      RETURN FALSE.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

