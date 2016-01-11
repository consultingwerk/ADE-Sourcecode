&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Dynamics Dynamic TreeView Container. No new instances of this should be created. Use the Dynamics TreeView Wizard Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_Astra2                   AS HANDLE          NO-UNDO.
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

  (v:010018)    Task:           0   UserRef:    
                Date:   03/13/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #4146 - Smallest size error with tree view

  (v:010019)    Task:           0   UserRef:    
                Date:   03/28/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3183 - Custom Super Procedure support not implemented for Dynamic TreeView
                Also fixed various other issues with regards to the Structured TreeView implementation

  (v:010020)    Task:           0   UserRef:    
                Date:   05/31/2002  Author:     Mark Davies (MIP)

  Update Notes: Replaced all '\' with '~\'

  (v:010021)    Task:           0   UserRef:    
                Date:   06/27/2002  Author:     Mark Davies (MIP)

  Update Notes: Added fix submitted by KSM to fix iz#4527

--------------------------------------------------------------*/
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

&GLOBAL-DEFINE ICF-DYNAMIC-CONTAINER YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gdResizeCol           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcLaunchLogicalObject AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLaunchRunAttribute  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcValueList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glObjectInitialized   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glOnceOnly            AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gcContainerMode       AS CHARACTER NO-UNDO.



DEFINE VARIABLE ghTableioSource       AS HANDLE  NO-UNDO.
DEFINE VARIABLE ghContainerToolbar    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTreeViewOCX         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFolderToolbar       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFilterViewer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghFolder              AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcTreeLayoutCode      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcLogicalObjectName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLaunchedFolderName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLaunchedSDOName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLaunchedRunInstance AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcInstanceAttributes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOldSDOName          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gdMinimumWindowWidth  AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdMinimumWindowHeight AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdMaximumWindowWidth  AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdMaximumWindowHeight AS DECIMAL    NO-UNDO INITIAL ?.

DEFINE VARIABLE gdMinimumFolderWidth  AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE VARIABLE gdMinimumFolderHeight AS DECIMAL    NO-UNDO INITIAL ?.

DEFINE VARIABLE gcObjectHandles       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcToolbarHandles      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLockWindow          AS INTEGER    NO-UNDO.

DEFINE VARIABLE glMenuMaintenance     AS LOGICAL    NO-UNDO INIT FALSE.
DEFINE VARIABLE glTreeViewDefaults    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE ghDefaultMenuBar      AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcCurrentOEM          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCurrentRecordObj    AS DECIMAL    NO-UNDO.

DEFINE VARIABLE gcCurrentNodeKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrExpandNodeKey   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastLaunchedNode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcParentNode          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giLastLaunchedPage    AS INTEGER    NO-UNDO.

DEFINE VARIABLE gcWindowName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFolderTitle         AS CHARACTER  NO-UNDO.

DEFINE VARIABLE gcFilterValue AS CHARACTER  NO-UNDO.
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
DEFINE VARIABLE glExpand            AS LOGICAL    NO-UNDO INITIAL TRUE.

DEFINE VARIABLE glFilterApplied     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glNewChildNode      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glReposSDO          AS LOGICAL    NO-UNDO.

DEFINE VARIABLE glNoMessage         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gdNodeObj           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdMinInstanceWidth  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdMinInstanceHeight AS DECIMAL    NO-UNDO.

DEFINE VARIABLE gdTopCoordinate     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdLeftCoordinate    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghDynTreeContainer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDynTreeSuperProc  AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcCurrentLogicalName        AS CHARACTER        NO-UNDO.
DEFINE VARIABLE gdTreeviewInstanceId        AS DECIMAL          NO-UNDO.

DEFINE VARIABLE glReposParentNode           AS LOGICAL          NO-UNDO.

{launch.i &DEFINE-ONLY=YES}
{dynlaunch.i &DEFINE-ONLY=YES}
{checkerr.i &DEFINE-ONLY=YES}
{src/adm2/globals.i}

/* Define temp-tables required */
{src/adm2/treettdef.i}

DEFINE TEMP-TABLE ttNonTreeObjects NO-UNDO
    FIELD hObjectHandle AS HANDLE.

DEFINE TEMP-TABLE ttDataLinks NO-UNDO
    FIELD hSourceHandle  AS HANDLE
    FIELD hTargetHandle  AS HANDLE
    FIELD lUpdateLink    AS LOGICAL
    .

&SCOPED-DEFINE SDO-TYPE-CODE SmartDataObject
&GLOBAL-DEFINE xpLogicalObjectName

DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManager AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManagerID AS INTEGER.

IF NOT VALID-HANDLE(gshLayoutManager) 
OR gshLayoutManager:UNIQUE-ID <> gshLayoutManagerID THEN 
DO: 
  RUN ry/prc/rylayoutsp.p PERSISTENT SET gshLayoutManager.
  IF VALID-HANDLE(gshLayoutManager) THEN ASSIGN gshLayoutManagerID = gshLayoutManager:UNIQUE-ID.
END.

{af/app/afttsecurityctrl.i}
{af/app/aftttranslate.i}

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

/** Define some global queries here so that we can reduce the number of 
 *  CREATE QUERY ... statements.
 *  ----------------------------------------------------------------------- **/
DEFINE VARIABLE ghQuery1                AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery2                AS HANDLE                   NO-UNDO.

/* Define the container_* tables that local control the object. */
{ ry/app/ryobjretri.i &CONTAINER-TABLES=YES }

DEFINE TEMP-TABLE tTreeObjects LIKE container_Object.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildContainerTables wWin 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalname wWin 
FUNCTION getCurrentLogicalname RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentMode wWin 
FUNCTION getCurrentMode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentNodeKey wWin 
FUNCTION getCurrentNodeKey RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrExpandNodeKey wWin 
FUNCTION getCurrExpandNodeKey RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDelete wWin 
FUNCTION getDelete RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExpand wWin 
FUNCTION getExpand RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterApplied wWin 
FUNCTION getFilterApplied RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterValue wWin 
FUNCTION getFilterValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterViewerHandle wWin 
FUNCTION getFilterViewerHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle wWin 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceAttributes wWin 
FUNCTION getInstanceAttributes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceObjectId wWin 
FUNCTION getInstanceObjectId RETURNS DECIMAL
    ( phProcedureHandle     AS HANDLE    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastLaunchedNode wWin 
FUNCTION getLastLaunchedNode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalObjectName wWin 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenuMaintenance wWin 
FUNCTION getMenuMaintenance RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewChildNode wWin 
FUNCTION getNewChildNode RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewContainerMode wWin 
FUNCTION getNewContainerMode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNodeObj wWin 
FUNCTION getNodeObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNoMessage wWin 
FUNCTION getNoMessage RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectHandles wWin 
FUNCTION getObjectHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInitialized wWin 
FUNCTION getObjectInitialized RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectPage wWin 
FUNCTION getObjectPage RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOnceOnly wWin 
FUNCTION getOnceOnly RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentNode wWin 
FUNCTION getParentNode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrimarySDOName wWin 
FUNCTION getPrimarySDOName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRawAttributeValues wWin 
FUNCTION getRawAttributeValues RETURNS HANDLE
    ( INPUT pdInstanceId        AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRctBorderHandle wWin 
FUNCTION getRctBorderHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReposParentNode wWin 
FUNCTION getReposParentNode RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReposSDO wWin 
FUNCTION getReposSDO RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeFillInHandle wWin 
FUNCTION getResizeFillInHandle RETURNS HANDLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOHandle wWin 
FUNCTION getSDOHandle RETURNS HANDLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getState wWin 
FUNCTION getState RETURNS CHARACTER
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
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTranslatableNodes wWin 
FUNCTION getTranslatableNodes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeContainerMode wWin 
FUNCTION getTreeContainerMode RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeViewOCX wWin 
FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow wWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoSort wWin 
FUNCTION setAutoSort RETURNS LOGICAL
  ( INPUT plAutoSort AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentMode wWin 
FUNCTION setCurrentMode RETURNS LOGICAL
  ( pcCurrentMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentNodeKey wWin 
FUNCTION setCurrentNodeKey RETURNS LOGICAL
  ( pcCurrentNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrExpandNodeKey wWin 
FUNCTION setCurrExpandNodeKey RETURNS LOGICAL
  ( pcCurrExpandNodeKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultMenuBar wWin 
FUNCTION setDefaultMenuBar RETURNS LOGICAL
  ( phDefaultMenuBar AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDelete wWin 
FUNCTION setDelete RETURNS LOGICAL
  ( plDelete AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExpand wWin 
FUNCTION setExpand RETURNS LOGICAL
  ( plExpand AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterApplied wWin 
FUNCTION setFilterApplied RETURNS LOGICAL
  ( plFilterApplied AS LOGICAL )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInstanceAttributes wWin 
FUNCTION setInstanceAttributes RETURNS LOGICAL
  ( pcInstanceAttributes AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastLaunchedNode wWin 
FUNCTION setLastLaunchedNode RETURNS LOGICAL
  ( pcLastLaunchedNode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogicalObjectName wWin 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( INPUT cObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenuMaintenance wWin 
FUNCTION setMenuMaintenance RETURNS LOGICAL
  ( plMenuMaintenance AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNewChildNode wWin 
FUNCTION setNewChildNode RETURNS LOGICAL
  ( plNewChildNode AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNewContainerMode wWin 
FUNCTION setNewContainerMode RETURNS LOGICAL
  ( pcNewContainerMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNodeObj wWin 
FUNCTION setNodeObj RETURNS LOGICAL
  ( pdNodeObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectInitialized wWin 
FUNCTION setObjectInitialized RETURNS LOGICAL
  ( pcObjectInitialized AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOnceOnly wWin 
FUNCTION setOnceOnly RETURNS LOGICAL
  ( pcOnceOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentNode wWin 
FUNCTION setParentNode RETURNS LOGICAL
  ( pcParentNode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrimarySDOName wWin 
FUNCTION setPrimarySDOName RETURNS LOGICAL
  ( pcPrimarySDOName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReposParentNode wWin 
FUNCTION setReposParentNode RETURNS LOGICAL
  ( plReposParentNode AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReposSDO wWin 
FUNCTION setReposSDO RETURNS LOGICAL
  ( plReposSDO AS LOGICAL )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDOHandle wWin 
FUNCTION setSDOHandle RETURNS LOGICAL
  ( phSDOHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerOperatingMode wWin 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER)  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setState wWin 
FUNCTION setState RETURNS LOGICAL
  ( pcState AS CHARACTER )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTreeContainerMode wWin 
FUNCTION setTreeContainerMode RETURNS LOGICAL
  ( pcTreeContainerMode AS CHARACTER)  FORWARD.

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
         SIZE 99 BY 10.91.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.91
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

{adm2/tvcontnr.i}

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
     * abort this if windows open                                           */
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    DO:
        DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

        RUN askQuestion IN gshSessionManager ( INPUT "There are child windows open - continue with exit of application?",    /* messages */
                                               INPUT "&Yes,&No":U,     /* button list */
                                               INPUT "&Yes":U,         /* default */
                                               INPUT "&No":U,          /* cancel */
                                               INPUT "Exit Application":U, /* title */
                                               INPUT "":U,             /* datatype */
                                               INPUT "":U,             /* format */
                                               INPUT-OUTPUT cAnswer,   /* answer */
                                               OUTPUT cButton          /* button pressed */ ).
        IF cButton = "&No":U OR cButton = "No":U THEN RETURN NO-APPLY.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE. /* ensure close down nicely */

    /* Add the return no-appply so that the entire application doesn't shut down. */
    IF TARGET-PROCEDURE:PERSISTENT THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  
  /* If close window - give chance to abort this if windows open */
  IF DYNAMIC-FUNCTION("childWindowsOpen":U) THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTTLinks wWin 
PROCEDURE addTTLinks :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcSDOName                AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerInstanceId    AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE hSourceObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTargetObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSourceInstanceBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTargetInstanceBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hToolbarTrg                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cLinks                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSourceType                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSupported                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lLinkExists                 AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.

    DEFINE BUFFER source_Object         FOR container_Object.
    DEFINE BUFFER target_Object         FOR container_Object.
    DEFINE BUFFER container_Link        FOR container_Link.
    DEFINE BUFFER update_Link           FOR container_Link.
    
    FOR EACH container_Link WHERE
             container_Link.tTargetProcedure = TARGET-PROCEDURE AND
             container_Link.tLinkCreated     = NO                 :

        FIND FIRST source_Object WHERE
                   source_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   source_Object.tObjectInstanceObj = container_Link.tSourceObjectInstanceObj
                   NO-ERROR.

        FIND FIRST target_Object WHERE
                   target_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   target_Object.tObjectInstanceObj = container_Link.tTargetObjectInstanceObj
                   NO-ERROR.

        ASSIGN hSourceObject = ( IF AVAILABLE source_Object AND container_Link.tSourceObjectInstanceObj GT 0 THEN 
                                    source_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).
        ASSIGN hTargetObject = ( IF AVAILABLE target_Object  AND container_Link.tTargetObjectInstanceObj GT 0 THEN 
                                    target_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).

        IF NOT VALID-HANDLE(hSourceObject) OR
           NOT VALID-HANDLE(hTargetObject) THEN
          NEXT.
        IF container_Link.tLinkName EQ "Update" AND hTargetObject EQ TARGET-PROCEDURE THEN
            NEXT.
        IF container_Link.tLinkName EQ "TableIO":U AND hSourceObject = ghFolderToolbar THEN
            SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN hTargetObject.

        /* Link the primary viewer to the SDO */
        IF container_Link.tLinkName EQ "Data":U AND hSourceObject = TARGET-PROCEDURE THEN
        DO:
            FIND FIRST ttRunningSDOs WHERE ttRunningSDOs.cSDOName = pcSDOName NO-LOCK NO-ERROR.
            IF AVAILABLE ttRunningSDOs THEN
            DO:
                RUN addLink (ttRunningSDOs.hSDOHandle, "Data":U, hTargetObject).
                CREATE ttLinksAdded.
                ASSIGN ttLinksAdded.hSourceHandle = ttRunningSDOs.hSDOHandle
                       ttLinksAdded.cLinkName     = "Data":U
                       ttLinksAdded.hTargetHandle = hTargetObject
                       .
                FIND FIRST update_Link WHERE
                           update_Link.tTargetProcedure         = TARGET-PROCEDURE  AND
                           update_Link.tLinkName                = "Update":U        AND
                           update_Link.tSourceObjectInstanceObj = container_Link.tTargetObjectInstanceObj
                           NO-ERROR.
                IF AVAILABLE update_Link THEN
                DO:
                    RUN addLink (hTargetObject, "Update":U, ttRunningSDOs.hSDOHandle).
                    CREATE ttLinksAdded.
                    ASSIGN ttLinksAdded.hSourceHandle = hTargetObject
                           ttLinksAdded.cLinkName     = "Update":U
                           ttLinksAdded.hTargetHandle = ttRunningSDOs.hSDOHandle
                           .
                END.    /* available update link */
            END.    /* available runnig SDO */
        END.
        ELSE
        DO:
            ASSIGN lLinkExists = FALSE.

            /* The page link already exists, so do not add it again */
            IF container_Link.tLinkName BEGINS "Page":U THEN
            DO:
                IF DYNAMIC-FUNCTION("linkHandles":U, container_Link.tLinkName + "-Source":U) <> "":U THEN DO:
                  ASSIGN container_Link.tLinkCreated = YES.
                  NEXT.
                END.
                ELSE 
                    IF NOT VALID-HANDLE(hTargetObject) THEN
                        ASSIGN hTargetObject = TARGET-PROCEDURE.
            END.    /* page link */
            ELSE
            IF container_Link.tLinkName EQ "Navigation":U THEN
            DO: 
              /* We should not be adding the Navigation link from
                 the Object Top Toolbar to THIS-PROCEDURE, no support
                 for this has been implemented yet - leave it out for now 
                 Mark Davies (MIP) 28/08/2002 */
              IF hSourceObject = ghFolderToolbar AND hTargetObject = TARGET-PROCEDURE THEN DO:
                ASSIGN container_Link.tLinkCreated = YES.
                NEXT.
              END.
              
              /* If we have a navigation link from the TreeView SDO - find it in the running sdo table */
              IF INDEX(pcSDOName,DYNAMIC-FUNCTION("getLogicalObjectName" IN hTargetObject)) <> 0 THEN DO:
                FIND FIRST ttRunningSDOs WHERE ttRunningSDOs.cSDOName = pcSDOName NO-LOCK NO-ERROR.
                IF AVAILABLE ttRunningSDOs THEN
                DO:                
                  ASSIGN hSourceObject = TARGET-PROCEDURE
                         hTargetObject = ttRunningSDOs.hSDOHandle
                         .
                  /* We should not add a navigation link from the top toolbar
                     to the SDO when running the Tree as a menu */
                  IF hSourceObject = TARGET-PROCEDURE AND
                     glMenuMaintenance THEN DO:
                    ASSIGN container_Link.tLinkCreated = YES.
                    NEXT.
                  END.
                END.    /* available running SDO */
              END.

              IF VALID-HANDLE(hSourceObject) AND
                 VALID-HANDLE(hTargetObject) THEN DO:
                FIND FIRST ttLinksAdded WHERE
                           ttLinksAdded.hSourceHandle = hSourceObject AND
                           ttLinksAdded.cLinkName     = container_Link.tLinkName     AND
                           ttLinksAdded.hTargetHandle = hTargetObject
                           NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ttLinksAdded THEN
                DO:
                  RUN addLink (hSourceObject, container_Link.tLinkName, hTargetObject).
                  CREATE ttLinksAdded.
                  ASSIGN ttLinksAdded.hSourceHandle = hSourceObject
                         ttLinksAdded.cLinkName     = container_Link.tLinkName
                         ttLinksAdded.hTargetHandle = hTargetObject
                         .                       
                  ASSIGN container_Link.tLinkCreated = YES.
                  NEXT.
                END.
              END.
            END. /* Navigation Links */
            
            /* The toolbar target is currently a single object link 
             * This need to be revisited.. */            
            {get ObjectType cSourceType hSourceObject}.

            IF cSourceType MATCHES '*toolbar*':U THEN 
            DO:
                {get ToolbarTarget hToolbarTrg hSourceObject}.      
                IF VALID-HANDLE(hToolbarTrg) THEN
                    {set ToolbarTarget ? hSourceObject}.
            END.

            IF container_Link.tLinkName EQ "GroupAssign":U THEN
            DO:
                /* Source */
                ASSIGN cSupported = DYNAMIC-FUNCTION("getSupportedLinks":U IN hSourceObject).
                IF LOOKUP("GroupAssign-Source",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",GroupAssign-Source".
                IF LOOKUP("GroupAssign-Target",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",GroupAssign-Target".
                DYNAMIC-FUNCTION("setSupportedLinks":U IN hSourceObject,cSupported).

                /* Target */
                ASSIGN cSupported = DYNAMIC-FUNCTION("getSupportedLinks":U IN hTargetObject).
                IF LOOKUP("GroupAssign-Source",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",GroupAssign-Source".
                IF LOOKUP("GroupAssign-Target",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",GroupAssign-Target".
                DYNAMIC-FUNCTION("setSupportedLinks":U IN hTargetObject,cSupported).
            END.    /* Group Assign links */
            ELSE
            IF container_Link.tLinkName EQ "TableIO":U THEN
            DO:
                /* Source */
                ASSIGN cSupported = DYNAMIC-FUNCTION("getSupportedLinks":U IN hSourceObject).
                IF LOOKUP("TableIO-Source",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",TableIO-Source".
                IF LOOKUP("TableIO-Target",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",TableIO-Target".
                DYNAMIC-FUNCTION("setSupportedLinks":U IN hSourceObject,cSupported).
                
                /* Target */
                ASSIGN cSupported = DYNAMIC-FUNCTION("getSupportedLinks":U IN hTargetObject).
                IF LOOKUP("TableIO-Source",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",TableIO-Source".
                IF LOOKUP("TableIO-Target",cSupported) = 0 THEN
                    ASSIGN cSupported = cSupported + ",TableIO-Target".
                DYNAMIC-FUNCTION("setSupportedLinks":U IN hTargetObject,cSupported).
            END.    /* TableIO */

            RUN addLink (hSourceObject, container_Link.tLinkName, hTargetObject).
            CREATE ttLinksAdded.
            ASSIGN ttLinksAdded.hSourceHandle = hSourceObject
                   ttLinksAdded.cLinkName     = container_Link.tLinkName
                   ttLinksAdded.hTargetHandle = hTargetObject
                   .
            
            IF glMenuMaintenance AND hTargetObject = TARGET-PROCEDURE THEN DO:
              ASSIGN container_Link.tLinkCreated = YES.
              NEXT.
            END.
                
        END.    /* not the primary, data link */

        ASSIGN container_Link.tLinkCreated = YES.
    END. /* available link buffer  */

    /* Ensure that this object does not send messages to the toolbar and that 
     * the toolbar does not consider it to be an active TableioTarget */
    RUN LinkStateHandler IN TARGET-PROCEDURE ('inactive':U,DYNAMIC-FUNCTION("getTableioSource":U IN TARGET-PROCEDURE), 'TableioSource':U). 

    /* Add a Navigation link from the Folder Toolbar 
     * to the Dynamic TreeView to trap ToolBar Navigation */
    ASSIGN lLinkExists = FALSE.
    ASSIGN cLinks = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "Navigation-Target":U).
    IF cLinks = "":U THEN
        ASSIGN lLinkExists = FALSE.
    DO iLoop = 1 TO NUM-ENTRIES(cLinks):
        ASSIGN hTargetObject = WIDGET-HANDLE(ENTRY(iLoop,cLinks)).
        IF VALID-HANDLE(hTargetObject) AND hTargetObject = TARGET-PROCEDURE THEN
            ASSIGN lLinkExists = TRUE.
    END.

    IF lLinkExists = FALSE AND VALID-HANDLE(ghFolderToolBar) THEN
    DO:
        CREATE ttLinksAdded.
        ASSIGN ttLinksAdded.hSourceHandle = ghFolderToolBar
               ttLinksAdded.cLinkName     = "Navigation":U
               ttLinksAdded.hTargetHandle = TARGET-PROCEDURE
               .                        
        RUN addLink (ghFolderToolBar, "NAVIGATION":U, TARGET-PROCEDURE).
    END.

    RETURN.
END PROCEDURE.  /* addTTLinks */

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
       RUN resizeObject IN h_smarttreeview ( 10.19 , 40.80 ) NO-ERROR.

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
  DEFINE VARIABLE hTreeFrame    AS HANDLE     NO-UNDO.

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
  hTreeFrame = DYNAMIC-FUNCTION("getContainerHandle":U IN ghTreeViewOCX).
  IF VALID-HANDLE(hTreeFrame) THEN
    ASSIGN hTreeFrame:POPUP-MENU = hPopupMenu.
  ELSE
    ASSIGN
        {&WINDOW-NAME}:POPUP-MENU = hPopupMenu.

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
  DEFINE VARIABLE cContainerMode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNavigateSdo          AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(ghContainerToolbar) THEN
    ASSIGN hContainerToolbar = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U, "Navigation-Source")))
           ghContainerToolbar = hContainerToolbar.

  ASSIGN hFolderToolbar = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles":U, "TableIO-Source")))
         ghFolderToolbar = hFolderToolbar.

  IF VALID-HANDLE(ghFolderToolbar) THEN
  DO:
      SUBSCRIBE TO "cancelRecord":U IN ghFolderToolbar.
      SUBSCRIBE TO "addRecord":U    IN ghFolderToolbar.
      SUBSCRIBE TO "copyRecord":U   IN ghFolderToolbar.
      SUBSCRIBE TO "resetRecord":U  IN ghFolderToolbar.
      SUBSCRIBE TO "updateRecord":U IN ghFolderToolbar.
      SUBSCRIBE TO "toolbar":U   IN ghFolderToolbar.
  END.  /* valid folder toolbar */

  IF VALID-HANDLE(ghContainerToolbar) THEN
      SUBSCRIBE TO "toolbar":U   IN ghContainerToolbar. 

  /* Make sure the FolderToolbar does not Auto Size */
  IF VALID-HANDLE(ghFolderToolbar) THEN DO:
    {set ToolbarAutoSize NO ghFolderToolbar}.
  END.

    IF VALID-HANDLE (hContainerToolbar) AND hContainerToolbar <> THIS-PROCEDURE THEN
    DO:
        cContainerMode = DYNAMIC-FUNCTION("getTreeContainerMode":U).
        /* go back into modify mode after an add is saved */
        IF cContainerMode = "add":U OR
           cContainerMode = "Copy":U THEN
        DO:
          ASSIGN cSavedContainerMode = "modify":U.
          {set savedContainerMode cSavedContainerMode}.
        END.
    
        CASE cContainerMode:
            WHEN "view"   THEN RUN setContainerViewMode.
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
    IF VALID-HANDLE(hContainerToolbar) THEN
      hNavigateSdo = DYNAMIC-FUNCTION("linkHandles" IN hContainerToolbar, 'Navigation-Target') NO-ERROR.
    
    IF VALID-HANDLE(hNavigateSdo) AND
       LOOKUP("openQuery":U, hNavigateSdo:INTERNAL-ENTRIES) <> 0 THEN
      RUN setbuttons IN hContainerToolbar("enable-nav":U).

    /* end of initialization - now turn off data links */

    PUBLISH 'ToggleData' FROM TARGET-PROCEDURE (INPUT FALSE).

    RETURN.
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
    DEFINE INPUT PARAMETER pcInstanceAttributes     AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER piCurrentPage            AS INTEGER          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerInstanceId    AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE hObjectHandle               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cCustomSuperProc            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lObjectIsAToolbar           AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hPageBuffer                 AS HANDLE               NO-UNDO.
    
    /* Clear list of constructed objects on container */
    ASSIGN gcObjectHandles  = "":U
           gcToolbarHandles = "":U
           .
    IF glMenuMaintenance THEN
        ASSIGN gcLaunchRunAttribute = pcInstanceAttributes.
    
    FOR EACH container_Object WHERE
             container_Object.tTargetProcedure           = TARGET-PROCEDURE      AND
             container_Object.tContainerRecordIdentifier = pdContainerInstanceId AND
             container_Object.tPageNumber                = piCurrentPage
             BY container_Object.tPageNumber
             BY container_Object.tInstanceOrder
             BY container_Object.tLayoutPosition:

        IF container_Object.tPageNumber EQ ? THEN
            DYNAMIC-FUNCTION("setCurrentPage":U IN THIS-PROCEDURE, INPUT 0).
        ELSE
            DYNAMIC-FUNCTION("setCurrentPage":U IN THIS-PROCEDURE, INPUT container_Object.tPageNumber).

        ASSIGN hObjectHandle     = ?
               lObjectIsAToolbar = FALSE
               .
        IF glMenuMaintenance THEN
            IF INDEX(container_Object.tObjectPathedFilename, "dyntool":U) <> 0 THEN
                ASSIGN lObjectIsAToolbar = TRUE.

        /* Toolbar Object */
        IF INDEX(container_Object.tObjectPathedFilename, "dyntool":U) <> 0 THEN
        DO:
            IF container_Object.tLayoutPosition EQ "TOP":U THEN
            DO: 
                IF VALID-HANDLE(ghFolderToolbar) AND NOT glMenuMaintenance THEN 
                    ASSIGN hObjectHandle = ghFolderToolbar.

                /* This piece of code ensures that any top toolbar will not
                 * be created - but redirected to use the current top
                 * toolbar instead */
                IF VALID-HANDLE(ghContainerToolbar) AND glMenuMaintenance THEN
                    ASSIGN hObjectHandle = ghContainerToolbar.
            END.    /* TOP */
            ELSE
            DO:
                IF NOT glMenuMaintenance THEN
                DO:
                    IF container_Object.tPageNumber EQ 0 AND VALID-HANDLE(ghFolderToolbar) THEN
                        ASSIGN hObjectHandle = ghFolderToolbar.
                END.
            END.
        END.    /* instance is a toolbar */

        /* Folder Object */
        IF INDEX(container_Object.tObjectPathedFilename , "afspfoldr":U) <> 0 AND VALID-HANDLE(ghFolder) AND NOT glMenuMaintenance THEN
            ASSIGN hObjectHandle = ghFolder.

        IF glMenuMaintenance AND
            (container_Object.tDbAware                              OR
             container_Object.tObjectPathedFilename MATCHES "*o":U  OR
             container_Object.tObjectPathedFilename MATCHES "*o.w":U   ) THEN
            ASSIGN gcPrimarySDOName = container_Object.tObjectPathedFilename.

        IF hObjectHandle EQ ? THEN
        DO:
            ASSIGN gcCurrentLogicalName = "InstanceID=":U + STRING(container_Object.tRecordIdentifier)
                                        + CHR(1) + container_Object.tLogicalObjectName.
            /* Even though the ADMProps TT is populated with the values from the Repository, there 
             * may be attributes which need to be explicitly set. The list of attributes returned
             * buildAttributeList contains those attributes whicha re to be set.                  */
            RUN constructObject ( INPUT  container_Object.tObjectPathedFilename + (IF container_Object.tDbAware THEN CHR(3) + "DBAWARE" ELSE "":U),
                                  INPUT  FRAME {&FRAME-NAME}:HANDLE,
                                  INPUT  container_Object.tAttributeList,
                                  OUTPUT hObjectHandle).
        END.    /* object handle = ? */

        /** Always make sure that the handle is stored in the cache_Object buffer, even
         *  though this handle is set when the object is contrcuted. We need to do this
         *  since we may not always run constructObejct, and we need to be sure that we
         *  set this handle here.
         *  ----------------------------------------------------------------------- **/
        ASSIGN container_Object.tObjectInstanceHandle = hObjectHandle.

        /** ALWAYS MAKE SURE ANY TOOLBAR STARTED IS NOT AUTO RESIZE **/
        IF lObjectIsAToolbar THEN 
            {set ToolbarAutoSize NO hObjectHandle}.

        IF container_Object.tPageNumber EQ 0 THEN
        DO:
            IF INDEX(container_Object.tObjectPathedFilename, "afspfoldr":U) <> 0 AND NOT VALID-HANDLE(ghFolder) AND NOT glMenuMaintenance THEN
                ASSIGN ghFolder = hObjectHandle.

            IF INDEX(container_Object.tObjectPathedFilename, "dyntool":U) <> 0 THEN
            DO:
                IF container_Object.tLayoutPosition EQ "TOP" AND NOT VALID-HANDLE(ghContainerToolbar) THEN
                    ASSIGN ghContainerToolbar = hObjectHandle.

                IF container_Object.tLayoutPosition EQ "CENTRE" AND NOT VALID-HANDLE(ghFolderToolbar) THEN
                    ASSIGN ghFolderToolbar = hObjectHandle.
            END.    /* toolbar */
        END.    /* page = 0 */

        /** MAKE SURE THAT THE TREEVIEW OCX VIEWER KNOWS ABOUT THE SDO'S CREATED HERE **/
        IF DYNAMIC-FUNCTION('instanceOf':U IN hObjectHandle,"sdo":U) THEN
        DO:
            FIND FIRST ttRunningSDOs WHERE
                       ttRunningSDOs.cSDOName = container_Object.tObjectPathedFilename
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ttRunningSDOs THEN
            DO:
                CREATE ttRunningSDOs.
                ASSIGN ttRunningSDOs.cSDOName   = container_Object.tObjectPathedFilename
                       ttRunningSDOs.hSDOHandle = hObjectHandle
                       .
            END.
        END.

        /* keep ordered list of objects constructed on container */
        IF VALID-HANDLE(hObjectHandle) THEN
            ASSIGN gcObjectHandles = gcObjectHandles + (IF gcObjectHandles <> "":U THEN ",":U ELSE "":U) + STRING(hObjectHandle).

        IF VALID-HANDLE(hObjectHandle) AND INDEX(hObjectHandle:FILE-NAME, "dyntool":U) <> 0 THEN
            ASSIGN gcToolbarHandles = gcToolbarHandles + (IF gcToolbarHandles <> "":U THEN ",":U ELSE "":U) + STRING(hObjectHandle).

        /* Start any custom super procedure if any */
        IF VALID-HANDLE(hObjectHandle) AND container_Object.tCustomSuperProcedure NE "":U THEN
        DO:
            ASSIGN cCustomSuperProc = container_Object.tCustomSuperProcedure.
            {launch.i &PLIP = cCustomSuperProc &OnApp = 'NO' &Iproc = '' &NewInstance = YES}
            IF VALID-HANDLE(hPlip) THEN
            DO:                
                DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                                 INPUT hPLip, INPUT hObjectHandle).
                ASSIGN container_Object.tCustomSuperHandle  = hPlip
                       container_Object.tDestroyCustomSuper = TRUE
                       .
            END.    /* valid handle hPlip*/
        END.    /* has super procedure */
    END. /* FOR EACH tt_object_instance */

    RETURN.
END PROCEDURE.  /* constructTTInstances */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
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
    DEFINE VARIABLE lMenuController     AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE dInstanceId         AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE iPage               AS INTEGER      NO-UNDO.
    
    /* used when initializing page 0 */
    ASSIGN glOnceOnly = TRUE.

    {get CurrentPage iPage}.

    /* Get the instanceID of the treeview. */   
    {get InstanceId dInstanceId}.
    ASSIGN gdTreeviewInstanceId = dInstanceId.

    /* For the TreeView - we will only come in here once during initialization */
    /* For any page changes we will need to run createRepositoryObjects */
    IF DYNAMIC-FUNCTION("getCurrentPage":U) NE 0 THEN
        RETURN.

    RUN SUPER.

    /* get logical object name once only and store in a variable */
    ASSIGN cLogicalObjectName = DYNAMIC-FUNCTION("getLogicalObjectName":U IN TARGET-PROCEDURE).

    ASSIGN iCurrentPage = DYNAMIC-FUNCTION("getCurrentPage":U)
           iStartPage   = iCurrentPage
           lResized     = NO
           .
    IF iCurrentPage = 0 THEN
    DO:
        /* get attributes for all objects on all pages. This is so that we only have a single
         * appserver hit for the entire container for retrieving its dynamic properties from 
         * the repository - instead of getting a hit per page */
        RUN launchObject (INPUT cLogicalObjectName) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
            {af/sup2/afcheckerr.i &NO-RETURN=YES}
            RUN destroyObject.
            RETURN.
        END.    /* error */

        FIND FIRST container_Object WHERE
                   container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
                   container_Object.tRecordIdentifier = dInstanceId.

        RUN setAttributesInObject IN gshSessionManager (INPUT TARGET-PROCEDURE, INPUT container_Object.tAttributeList).

        /* clear list of constructed objects on container */
        ASSIGN gcObjectHandles  = "":U
               gcToolbarHandles = "":U
               
               container_Object.tObjectInstanceHandle = TARGET-PROCEDURE
               .

        FIND FIRST container_Page WHERE
                   container_Page.tTargetProcedure = TARGET-PROCEDURE AND
                   container_Page.tPageNumber     = 0
                   NO-ERROR.
        IF AVAILABLE container_Page THEN
            {set Page0LayoutManager container_Page.tLayoutCode }.
    END. /* page = 0 */

    /* start off by making the frame's virtual dimensions very big */
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = SESSION:WIDTH + 1
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = SESSION:HEIGHT + 1
           FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
           .

    /* work out the start page and if pages exists */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber      > 0
               NO-ERROR.
    IF AVAILABLE container_Page THEN
        ASSIGN iStartPage = container_Page.tPageNumber.

    /* set page initialized flag */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber      = iCurrentPage
               NO-ERROR.
    IF AVAILABLE container_Page THEN
        ASSIGN container_Page.tPageInitialized = YES.

    /* Construct the objects based on the tt_object_instance temp-table*/
    RUN constructTTInstances (INPUT "?":U,
                              INPUT 0,
                              INPUT dInstanceId ) NO-ERROR.
    
    /* Add the required links */
    RUN addTTLinks (INPUT "":U,  INPUT dInstanceID) NO-ERROR.
    
    /* the last thing we do is pack the frame to the size of its contents.  The actual work performed here will
    be subject to the chosen layout managers */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber      = 0
               NO-ERROR.
    IF AVAILABLE container_Page THEN
    DO:
        ASSIGN gcTreeLayoutCode = container_Page.tLayoutCode.
        {set Page0LayoutManager gcTreeLayoutCode}.
    END.    /* available page 0 */

    RUN checkToolbarState.

    /* Set the container and frame's minimum and maximum width and height */
    IF NOT glMenuMaintenance THEN
        RUN setMinMaxDefaults ( INPUT  lMenuController, OUTPUT cProfileData).

    RUN packWindow (INPUT 0, NOT(NUM-ENTRIES(cProfileData, CHR(3)) = 4)).

    IF VALID-HANDLE(ghFolderToolBar) THEN
        RUN viewObject IN ghFolderToolBar.

    /* Resize and place window on previous saved settings */
    RUN resizeAndPositionWindow ( INPUT lMenuController, INPUT cProfileData).

    RUN setTreeViewWidth.

    DYNAMIC-FUNCTION("setupFolderPages":U, "":U).

    RETURN.
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
    DEFINE INPUT PARAMETER pcLogicalObjectName    AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcSDOName              AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER phCallingProcedure     AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceAttributes   AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE lMenuController         AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cObjectHandles          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cToolbarHandles         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hObjectHandle           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iObjectLoop             AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iPage                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cInitialPageList        AS CHARACTER                NO-UNDO.

    ASSIGN glTreeViewDefaults = FALSE.

    DYNAMIC-FUNCTION("setContainerMode":U, "View":U).

    RUN setContainerViewMode.
    
    {get CurrentPage iPage}.
    {get InitialPageList cInitialPageList}.
    
    /* The Objects are already running, do not instantiate them again */
    IF gcLaunchedFolderName  EQ pcLogicalObjectName  AND 
       gcLaunchedRunInstance EQ pcInstanceAttributes AND
       gcLaunchedSDOName     EQ pcSDOName            AND 
       giLastLaunchedPage    EQ iPage                THEN
        RETURN.
    
    {set ReposSDO TRUE}.

    FIND FIRST ttRunningSDOs WHERE
               ttRunningSDOs.cSDOName = pcSDOName
               NO-LOCK NO-ERROR.
    IF AVAILABLE ttRunningSDOs AND VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
        ASSIGN ghSDOHandle = ttRunningSDOs.hSDOHandle.

    /* A new logical Object was chosen. Close down the currently running Objects and start the new ones */
    IF gcLaunchedFolderName <> pcLogicalObjectName THEN DO:
      RUN destroyNonTreeObjects.
      EMPTY TEMP-TABLE ttLinksAdded.
      
      /* The InstanceId is set to the current 'container' object. This will not
       * be the instanceId of the treeview, but rather of the currently running
       * container. The treeview's InstanceId is stored in the gcTreeviewInstanceId
       * variable, and this is set in createObjects.                                 */
      RUN launchObject (INPUT pcLogicalObjectName) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
      DO:
          {af/sup2/afcheckerr.i &NO-RETURN=YES}
          RUN destroyObject.
          RETURN.
      END.    /* error */

      giLastLaunchedPage = ?.
      /* Need to initiate page 0 first for links */
      IF iPage <> 0 THEN DO:
        {set CurrentPage 0}.
        RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT pcLogicalObjectName,
                                                         INPUT pcSDOName,
                                                         INPUT TARGET-PROCEDURE,
                                                         INPUT pcInstanceAttributes).
        {set CurrentPage 1}.
        iPage = 1.
      END.
    END.

    ASSIGN gcLogicalObjectName   = pcLogicalObjectName
           gcLaunchedFolderName  = pcLogicalObjectName
           gcLaunchedRunInstance = pcInstanceAttributes
           gcInstanceAttributes  = pcInstanceAttributes
           gcPrimarySDOName      = pcSDOName
           gcLaunchedSDOName     = pcSDOName
           gcOldSDOName          = pcSDOName
           giLastLaunchedPage    = iPage
           .
    
    IF CAN-FIND(FIRST container_Page 
                WHERE container_Page.tTargetProcedure = TARGET-PROCEDURE
                AND   container_page.tPageNumber      = iPage
                AND   container_Page.tPageInitialized = TRUE) THEN
      RETURN.

    
    {fnarg lockWindow TRUE}.

    ASSIGN lMenuController = NO.
    /* start off by making the frame's virtual dimensions very big */
    ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = SESSION:WIDTH + 1
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = SESSION:HEIGHT + 1
           FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
           .
    ASSIGN cObjectHandles  = "":U
           cToolbarHandles = "":U
           .
    /* This will be the instanceID of the current 'container' object */
    {get InstanceId dInstanceId}.
    FOR EACH  container_Page 
        WHERE container_Page.tTargetProcedure = TARGET-PROCEDURE
        AND   container_page.tPageNumber      = iPage 
        BY container_page.tPageNumber:
        IF cInitialPageList <> "":U THEN DO:
          IF NOT CAN-DO(cInitialPageList, STRING(iPage)) THEN
            NEXT.
        END.
        /* Construct the objects based on the tt_object_instance temp-table for each page */
        RUN constructTTInstances ( INPUT pcInstanceAttributes,
                                   INPUT container_Page.tPageNumber,
                                   INPUT dInstanceId                    ) NO-ERROR.
        ASSIGN cObjectHandles  = cObjectHandles + (IF cObjectHandles <> "":U THEN ",":U ELSE "":U) + gcObjectHandles
               cToolbarHandles = cToolbarHandles + (IF cToolbarHandles <> "":U THEN ",":U ELSE "":U) + gcToolbarHandles
               .
        ASSIGN container_Page.tPageInitialized = TRUE.
    END.    /* each page buffer */

    IF glMenuMaintenance AND pcSDOName = "":U THEN
        ASSIGN pcSDOName = gcPrimarySDOName.
    
    /* Add the required links */
    IF iPage <> 0 THEN
      RUN addTTLinks (INPUT pcSDOName, INPUT dInstanceId) NO-ERROR.
    IF glMenuMaintenance AND iPage = 0 THEN
      RUN addTTLinks (INPUT pcSDOName, INPUT dInstanceId) NO-ERROR.

  
    /* pass SdoForeignFields to any SDO's with a data link from THIS-PROCEDURE */
    RUN passSDOForeignFields (INPUT pcSDOName).

    /* The last thing we do is pack the frame to the size of its contents.  The actual work performed here will
     * be subject to the chosen layout managers */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber      = 0
               NO-ERROR.
    IF AVAILABLE container_Page THEN
        {set Page0LayoutManager container_Page.tLayoutCode}.

    DYNAMIC-FUNCTION("setupFolderPages":U, INPUT pcLogicalObjectName).
/*
    RUN selectPage (0).
  */
    ASSIGN gcObjectHandles  = cObjectHandles
           gcToolbarHandles = cToolbarHandles
           .
    
    DO iObjectLoop = 1 TO NUM-ENTRIES(cObjectHandles):
      hObjectHandle = WIDGET-HANDLE(ENTRY(iObjectLoop,cObjectHandles)).
      IF VALID-HANDLE(hObjectHandle) AND
         LOOKUP("adm-create-objects":U,hObjectHandle:INTERNAL-ENTRIES) > 0 AND 
         INDEX(hObjectHandle:FILE-NAME,"rydynview":U) = 0 THEN DO:
        RUN initializeDataObjects IN hObjectHandle (INPUT TRUE).
        /*
        RUN adm-create-objects IN hObjectHandle.
        */
        RUN postCreateObjects IN hObjectHandle NO-ERROR.
        DYNAMIC-FUNCTION("setObjectsCreated":U IN hObjectHandle, INPUT TRUE) NO-ERROR.
        ASSIGN NO-ERROR. /* get rid of any errors */
      END.
    END.
    
    RUN manualInitializeObjects.

    RUN packWindow (INPUT iPage, INPUT NO).

    {set Page0LayoutManager gcTreeLayoutCode}.

    
    IF glMenuMaintenance THEN
    DO:
        IF VALID-HANDLE(ghFolderToolbar) THEN
            RUN hideObject IN ghFolderToolbar.
    END.
    ELSE
    IF VALID-HANDLE(ghFolderToolbar) THEN
        RUN viewObject IN ghFolderToolbar.
    
    RUN resizeWindow.
    
    IF glMenuMaintenance THEN DO:
      FOR EACH ttNonTreeObjects:
        RUN viewObject IN ttNonTreeObjects.hObjectHandle.
      END.
    END.
    
    FOR EACH container_Page WHERE
             container_Page.tTargetProcedure = TARGET-PROCEDURE AND
             container_Page.tPageNumber     NE iPage:
        RUN hidePage ( INPUT container_Page.tPageNumber).
    END.
    
    DYNAMIC-FUNCTION("setContainerMode":U, "View":U).

    RUN setContainerViewMode.
    
    /* Ensure all objects on selected Page is visible */
    FOR EACH container_Object WHERE
             container_Object.tTargetProcedure           = TARGET-PROCEDURE AND
             container_Object.tContainerRecordIdentifier = dInstanceId      AND
             container_Object.tPageNumber                = iPage
             NO-LOCK:
      IF container_Object.tObjectInstanceHandle = ghFolder OR
         container_Object.tObjectInstanceHandle = ghFolderToolbar OR
         container_Object.tObjectInstanceHandle = ghContainerToolbar 
         THEN
        NEXT.
      RUN viewObject IN container_Object.tObjectInstanceHandle NO-ERROR.
    END.
                    
    IF iPage = 0 THEN
      RUN selectPage (1).
                      
    RUN toolbar ("EnableData").
    
    /* Set the UI Events for this object */
    {fn createUiEvents}.

    {fnarg lockWindow FALSE}.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* createRepositoryObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyNonTreeObjects wWin 
PROCEDURE destroyNonTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will destroy all current logical objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hDataSource         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cDataSource         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cData               AS CHARACTER                    NO-UNDO.

    /* Delete Previously Added Navigation Links */
    FOR EACH ttLinksAdded WHERE ttLinksAdded.cLinkName = "Navigation":U NO-LOCK:
        IF VALID-HANDLE(ttLinksAdded.hSourceHandle) AND VALID-HANDLE(ttLinksAdded.hTargetHandle) THEN
        DO:
            RUN removeLink (ttLinksAdded.hSourceHandle, ttLinksAdded.cLinkName, ttLinksAdded.hTargetHandle).
            DELETE ttLinksAdded.
        END.    /* valid source and target */
    END.    /* links added */

    /* It might look like I'm duplicating code, but it only works this way - do not change */
    IF NOT glMenuMaintenance THEN
    DO:
        FIND FIRST ttRunningSDOs WHERE ttRunningSDOs.cSDOName = gcOldSDOName NO-LOCK NO-ERROR.
        IF AVAILABLE ttRunningSDOs AND VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
        DO:
            IF DYNAMIC-FUNCTION("linkHandles" IN ttRunningSDOs.hSDOHandle, "Navigation-Source":U) <> "":U THEN
                RUN removeLink (ghFolderToolbar, "Navigation":U, ttRunningSDOs.hSDOHandle).
        END.
        RUN removeTTLinks (gcOldSDOName).
    END.
    ELSE
    DO:
        /* When the Dyn TreeView is used as a Menu, we need to kill all running SDOs */
        FOR EACH ttRunningSDOs EXCLUSIVE-LOCK:
            IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN
            DO:
                IF DYNAMIC-FUNCTION("linkHandles" IN ttRunningSDOs.hSDOHandle, "Navigation-Source":U) <> "":U THEN
                    RUN removeLink (ghFolderToolbar, "Navigation":U, ttRunningSDOs.hSDOHandle).
            END.

            RUN removeTTLinks (ttRunningSDOs.cSDOName).
            DELETE ttRunningSDOs.
        END.

        IF VALID-HANDLE(ghFolder) THEN
        DO:
            RUN destroyObject IN ghFolder.
            ASSIGN ghFolder = ?.
        END.
    END.

    FOR EACH ttNonTreeObjects EXCLUSIVE-LOCK:
        IF VALID-HANDLE(ttNonTreeObjects.hObjectHandle) THEN
        DO:
            /* KSM Fix for iz#4527 -- destroy all custom super procedures instantiated 
             * by the current SMO */
            FIND FIRST container_Object WHERE
                       container_Object.tTargetProcedure      = TARGET-PROCEDURE AND
                       container_Object.tObjectInstanceHandle = ttNonTreeObjects.hObjectHandle
                       NO-ERROR.
            IF AVAILABLE container_Object THEN
            DO:
                IF container_Object.tDestroyCustomSuper THEN
                DO:
                    DELETE OBJECT container_Object.tCustomSuperHandle NO-ERROR.
                    ASSIGN container_Object.tCustomSuperHandle = ?.
                END.

                ASSIGN container_Object.tObjectInstanceHandle = ?.
            END.    /* running super */      

            ASSIGN cDataSource = DYNAMIC-FUNCTION("linkHandles" IN ttNonTreeObjects.hObjectHandle, "Data-Source":U).
            
            IF cDataSource <> "":U THEN
            DO:
                DO iLoop = 1 TO NUM-ENTRIES(cDataSource):
                    ASSIGN hDataSource = WIDGET-HANDLE(ENTRY(iLoop,cDataSource)).
                    IF VALID-HANDLE(hDataSource) THEN
                        RUN removeLink (hDataSource, "Data":U, ttNonTreeObjects.hObjectHandle).
                END.
            END.    /* data source */
            
            DYNAMIC-FUNCTION("setpageNTarget" IN TARGET-PROCEDURE, INPUT "":U).
            DYNAMIC-FUNCTION("setObjectsCreated":U IN hObjectHandle, INPUT FALSE) NO-ERROR.

            RUN destroyObject IN ttNonTreeObjects.hObjectHandle.
        END.    /* valid non-tree object */

        DELETE ttNonTreeObjects.
    END.    /* each non-tree object */

    EMPTY TEMP-TABLE ttDataLinks.

    IF VALID-HANDLE(ghOverridenSubMenu) THEN
    DO:
        DELETE WIDGET ghOverridenSubMenu.
        ASSIGN ghOverridenSubMenu = ?.
    END.    /* valid overridden submenu */

    /* Disable Tablieo  */
    IF VALID-HANDLE(ghFolderToolbar) THEN
      RUN resetTableio IN ghFolderToolbar.
    
      /* Clear folder pages */
    DYNAMIC-FUNCTION("setupFolderPages":U, INPUT "":U).

    RUN updateTitleOverride (INPUT "":U).

    ASSIGN gcLogicalObjectName   = "":U
           gcInstanceAttributes  = "":U
           gcPrimarySDOName      = "":U
           gcLaunchedFolderName  = "":U
           gcLaunchedRunInstance = "":U
           gcLaunchedSDOName     = "":U
           .
    RUN setMinMaxDefaults (INPUT glMenuMaintenance, OUTPUT cData).

    ASSIGN {&WINDOW-NAME}:MIN-WIDTH-CHARS  = gdMinimumWindowWidth 
           {&WINDOW-NAME}:MIN-HEIGHT-CHARS = gdMinimumWindowHeight
           .

    FOR EACH container_Object WHERE container_Object.tTargetProcedure = TARGET-PROCEDURE:
        DELETE container_Object.
    END.

    FOR EACH container_Page WHERE container_Page.tTargetProcedure = TARGET-PROCEDURE:
        DELETE container_Page.
    END.

    FOR EACH container_Link WHERE container_Link.tTargetProcedure = TARGET-PROCEDURE:
        DELETE container_Link.
    END.

    RETURN.
END PROCEDURE.  /* destroyNonTreeObjects */

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
    DEFINE VARIABLE hDestroyObject          AS HANDLE                   NO-UNDO.
    
    RUN saveTreeViewWidth.

    RUN SUPER.

    /** Only destroy the objects after the RUN SUPER has comleted, so that any
     *  code in the super can execute first.
     *  ----------------------------------------------------------------------- **/
    FOR EACH ttRunningSDOs EXCLUSIVE-LOCK:
        IF VALID-HANDLE(ttRunningSDOs.hSDOHandle) THEN 
            RUN destroyObject IN ttRunningSDOs.hSDOHandle.
        DELETE ttRunningSDOs.
    END.

    /* Destroy all custom super procedures. */
    FOR EACH container_Object WHERE
             container_Object.tTargetProcedure    = TARGET-PROCEDURE AND
             container_Object.tDestroyCustomSuper = YES                :
        IF VALID-HANDLE(container_Object.tCustomSuperHandle) THEN 
            DELETE OBJECT container_Object.tCustomSuperHandle NO-ERROR.
    END.    /* each container object. */

    RETURN.
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
  DEFINE VARIABLE iStartPage AS INTEGER    NO-UNDO.

  IF glOnceOnly THEN RETURN.
  
  RUN createObjects. 

  IF NOT VALID-HANDLE(ghTreeViewOCX) THEN 
    ghTreeViewOCX = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, INPUT "TVController-Source":U))).
  
  IF  VALID-HANDLE(ghTreeViewOCX) THEN DO:
    {set ShowCheckBoxes glShowCheckBoxes ghTreeViewOCX}.
    {set ShowRootLines glShowRootLines ghTreeViewOCX}.
    {set HideSelection glHideSelection ghTreeViewOCX}.
    {set ImageHeight giImageHeight ghTreeViewOCX}.
    {set ImageWidth giImageWidth ghTreeViewOCX}.
    {set TreeStyle giTreeStyle ghTreeViewOCX}.
    {set AutoSort glAutoSort ghTreeViewOCX}.
  END.
  
  /* Initialize the SmartTreeView Manually */
  RUN initializeObject IN ghTreeViewOCX.
  
  {get StartPage iStartPage}.
  IF iStartPage NE ? AND iStartPage NE 0 THEN
    RUN selectPage (iStartPage).

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

  {fnarg lockWindow TRUE}.

  RUN loadTreeData IN TARGET-PROCEDURE.
  glExpand = FALSE.
  RUN populateTree IN ghTreeViewOCX (hDataTable, "":U).
  glExpand = TRUE.
  RUN selectFirstNode IN ghTreeViewOCX.
  cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN ghTreeViewOCX).
  RUN tvNodeSelected (cNodeKey).

  {fnarg lockWindow FALSE}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNodeTable wWin 
PROCEDURE getNodeTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttNode.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNonTreeObjects wWin 
PROCEDURE getNonTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttNonTreeObjects.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRunningSDOs wWin 
PROCEDURE getRunningSDOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttRunningSDOs.

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
  DEFINE OUTPUT PARAMETER pdTopCoordinate  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdLeftCoordinate AS DECIMAL    NO-UNDO.

  ASSIGN pdTopCoordinate  = gdTopCoordinate 
         pdLeftCoordinate = gdLeftCoordinate.

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
  
  ASSIGN
      phFolder            = IF glMenuMaintenance = FALSE THEN ghFolder ELSE ?
      phFolderToolbar     = ghFolderToolbar
      phContainerToolbar  = ghContainerToolbar
      phTitleFillIn       = fiTitle:HANDLE IN FRAME {&FRAME-NAME}
      phResizeFillIn      = fiResizeFillIn:HANDLE IN FRAME {&FRAME-NAME}
      pghTreeViewOCX      = IF VALID-HANDLE(ghTreeViewOCX) THEN ghTreeViewOCX ELSE ?
      phRectangle         = rctBorder:HANDLE IN FRAME {&FRAME-NAME}
      plStatusBarVisible  = TRUE  /* Assum yes until property has been implemented */
      phFilterViewer      = ghFilterViewer
      NO-ERROR.
  RETURN.

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
    DEFINE VARIABLE iCurrentPageNumber      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cSavedContainerMode     AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cErrorMessage           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cInstanceAttribute      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hQuery                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hFolder                 AS HANDLE                   NO-UNDO. 
    DEFINE VARIABLE hMenuBar                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hSubMenu                AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dTextWidth              AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dTotalTextWidth         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iMenus                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE dMenuControllerWidth    AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cNodeKey                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dFilterHeight           AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dFilterWidth            AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hDataTable              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cRootNodeCode           AS CHARACTER                NO-UNDO.

    IF glObjectInitialized THEN
        RETURN.
    
    ASSIGN glObjectInitialized = TRUE.

    ASSIGN cInstanceAttribute = DYNAMIC-FUNCTION("getRunAttribute").

    /* retrieve container mode set already, i.e. from where window was launched from
     * and before initializeobject was run. If a mode is retrieved here, we will not
     * overwrite it with the default mode from the object properties.               */
    ASSIGN gcContainerMode = DYNAMIC-FUNCTION("getContainerMode":U).
    
    fiResizeFillIn:LOAD-MOUSE-POINTER("size-e":U) IN FRAME {&FRAME-NAME}.

    /* {get ContainerMode gcContainerMode}. */
    IF NOT glOnceOnly THEN
        RUN doThisOnceOnly.

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
        SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "filterDataAvailable":U IN ghFilterViewer.

    IF VALID-HANDLE(ghFilterViewer) THEN
    DO:
        ASSIGN dFilterHeight = DYNAMIC-FUNCTION("getHeight" IN ghFilterViewer)
               dFilterWidth  = DYNAMIC-FUNCTION("getWidth" IN ghFilterViewer).
        IF {&WINDOW-NAME}:WIDTH-CHARS < dFilterWidth THEN
            ASSIGN {&WINDOW-NAME}:WIDTH-CHARS      = dFilterWidth + 0.5
                   FRAME {&FRAME-NAME}:WIDTH-CHARS = {&WINDOW-NAME}:WIDTH-CHARS - 1
                   .
        ASSIGN gdMinimumWindowWidth = {&WINDOW-NAME}:WIDTH-CHARS.
        RUN resizeWindow.
    END.    /* valid filter viewer */

    RUN SUPER.

    /* This is to see whether the folder window changed the mode because there is
     * possibly no enabled tab */
    ASSIGN gcContainerMode    = DYNAMIC-FUNCTION("getContainerMode":U)
           iCurrentPageNumber = DYNAMIC-FUNCTION("getCurrentPage":U)    
           .
    {get InstanceId dInstanceId}.

    FOR EACH container_Page WHERE
             container_Page.tRecordIdentifier = dInstanceId        AND
             container_Page.tPageNumber      <> iCurrentPageNumber AND
             container_Page.tTargetProcedure  = TARGET-PROCEDURE      :
        RUN hidePage (INPUT container_Page.tPageNumber).
    END.

    /* Check if any enabled tabs and if not - exit the program */
    ASSIGN hFolder = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles':U, 'Page-Source':U)) NO-ERROR.
    IF VALID-HANDLE(hFolder) AND DYNAMIC-FUNCTION("getTabsEnabled" IN hFolder) = NO THEN
    DO:
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'RY' '11'}, /* message to display */
                                               INPUT  "ERR":U,                  /* error type */
                                               INPUT  "&OK":U,                  /* button list */
                                               INPUT  "&OK":U,                  /* default button */ 
                                               INPUT  "&OK":U,                  /* cancel button */
                                               INPUT  "Folder window error":U,  /* error window title */
                                               INPUT  YES,                      /* display if empty */ 
                                               INPUT  THIS-PROCEDURE,           /* container handle */ 
                                               OUTPUT cButton     ).            /* button pressed */
        /* Shut down the folder window */
        RUN exitObject. 
        RETURN.
    END.

    IF LENGTH({&WINDOW-NAME}:PRIVATE-DATA) > 0 AND ENTRY(1,{&WINDOW-NAME}:PRIVATE-DATA,CHR(3)) = "forcedExit":U THEN
    DO:
        IF NUM-ENTRIES({&WINDOW-NAME}:PRIVATE-DATA,CHR(3)) = 2 THEN
            ASSIGN cErrorMessage = ENTRY(2,{&WINDOW-NAME}:PRIVATE-DATA,CHR(3)).
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
                                                OUTPUT cButton              ).   /* button pressed */
        RUN exitObject.
        RETURN.
    END.
    
    PROCESS EVENTS.

    /* calculate the menu width */
    ASSIGN hMenuBar         = {&WINDOW-NAME}:MENU-BAR
           ghDefaultMenuBar = hMenuBar
           .
    IF VALID-HANDLE(hMenuBar) THEN
    DO:
        ASSIGN hSubMenu = hMenuBar:FIRST-CHILD.
        REPEAT WHILE VALID-HANDLE(hSubMenu):
            ASSIGN dTextWidth      = FONT-TABLE:GET-TEXT-WIDTH(REPLACE(hSubMenu:LABEL,"&",""), hSubMenu:FONT)
                   dTotalTextWidth = dTotalTextWidth + dTextWidth
                   iMenus          = iMenus + 1
                   .
            hSubMenu = hSubMenu:NEXT-SIBLING.
        END.

        ASSIGN dMenuControllerWidth = MAX(dTotalTextWidth + (iMenus * 2.6) + 1, 1)
               dMenuControllerWidth = MAX({&WINDOW-NAME}:MIN-WIDTH,MIN(dMenuControllerWidth, SESSION:WIDTH - 1))
               .
        IF {&WINDOW-NAME}:WIDTH < dMenuControllerWidth THEN
        DO:
            ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE    = TRUE
                   {&WINDOW-NAME}:MIN-WIDTH          = dMenuControllerWidth
                   {&WINDOW-NAME}:WIDTH              = dMenuControllerWidth
                   FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = dMenuControllerWidth
                   FRAME {&FRAME-NAME}:WIDTH         = dMenuControllerWidth
                   FRAME {&FRAME-NAME}:SCROLLABLE    = FALSE
                   .
            APPLY "window-resized":u TO {&WINDOW-NAME}.
        END.

        IF {&WINDOW-NAME}:MIN-WIDTH < dMenuControllerWidth THEN        
            ASSIGN {&WINDOW-NAME}:MIN-WIDTH = dMenuControllerWidth.
    END.    /* valid menu bar */

    /* calculate window width */
    ASSIGN {&WINDOW-NAME}:VISIBLE = TRUE.

    RUN applyEntry (?).

    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "tvNodeSelected" IN ghTreeViewOCX.
    SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "tvNodeEvent"    IN ghTreeViewOCX.

    {get TreeDataTable hDataTable ghTreeViewOCX}.
    
    RUN loadTreeData.
    ASSIGN glExpand = FALSE.

    RUN populateTree IN ghTreeViewOCX (hDataTable, "":U).
    ASSIGN glExpand = TRUE.

    RUN selectFirstNode IN ghTreeViewOCX.
    ASSIGN cNodeKey = DYNAMIC-FUNCTION("getSelectedNode":U IN ghTreeViewOCX).

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

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchObject wWin 
PROCEDURE launchObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER            NO-UNDO.
    
    DEFINE VARIABLE iEntry                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cDataTargets                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSdoForeignFields           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hDataTarget                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dContainerRecordIdentifier  AS DECIMAL              NO-UNDO.
        
    DEFINE VARIABLE cLayoutCode                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iCurrentPage                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cAttributeList              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iFieldLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cMainObjAttrList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMessageList                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cMessage                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cButton                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFolderLabels               AS CHARACTER            NO-UNDO.

    ASSIGN gcLogicalObjectName =  pcLogicalObjectName.

    IF pcLogicalObjectName = {fn getLogicalObjectName} THEN    
        {get InstanceId dContainerRecordIdentifier}.
    ELSE
    DO:
        ASSIGN dContainerRecordIdentifier = ?.
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT pcLogicalObjectName,
                         INPUT ?,
                         INPUT ?,
                         INPUT NO       ).
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
        ASSIGN dContainerRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.
    END.    /* not the treeview object itself */

    /* If we have an InstanceID, then the cache_Object record will be repositioned to that record. 
     * If there is no instanceID, we have just retrieved the object from the cache, and the cacheObjectOnClient
     * call will have repositioned the cache_Object buffer to the correct record.                              */
    DYNAMIC-FUNCTION("buildContainerTables":U, INPUT dContainerRecordIdentifier).

    /* Set the InstanceId? */
    {set InstanceId dContainerRecordIdentifier}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dContainerRecordIdentifier.
    
    RUN setAttributesInObject IN gshSessionManager (INPUT TARGET-PROCEDURE, INPUT container_Object.tAttributeList).
    
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber       = 0
               NO-ERROR.
    IF AVAILABLE container_Page THEN
        {set Page0LayoutManager container_Page.tLayoutCode}.

    ASSIGN cFolderLabels = "":U.

    FOR EACH container_Page WHERE
             container_Page.tTargetProcedure  = TARGET-PROCEDURE AND
             container_Page.tPageNumber       > 0 :
        ASSIGN cFolderLabels = cFolderLabels + container_Page.tPageLabel + ",":U.
    END.    /* page available */

    ASSIGN cFolderLabels = RIGHT-TRIM(cFolderLabels, ",":U).
    IF VALID-HANDLE(ghFolder) THEN
        DYNAMIC-FUNCTION("setFolderLabels":U IN ghFolder, cFolderLabels).
    
    RETURN.
END PROCEDURE.  /* launchObject */

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
  DEFINE VARIABLE hNodeTable            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dParentObj            AS DECIMAL    NO-UNDO.

  IF glFilterApplied = FALSE AND
     VALID-HANDLE(ghFilterViewer) THEN
    RETURN.
  
  cMode = DYNAMIC-FUNCTION("getUIBMode":U).
  
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
  cRootNodeCode = DYNAMIC-FUNCTION("getRootNodeCode":U).
  
  hNodeTable = TEMP-TABLE ttNode:HANDLE.

  {dynlaunch.i &PLIP  = "'ry/app/rytrenodep.p'"
               &IPROC = "'cacheNodeTable'"
               &mode1  = INPUT  &parm1  = cRootNodeCode  &dataType1  = CHARACTER
               &mode2  = INPUT  &parm2  = dParentObj     &dataType2  = DECIMAL
               &mode3  = OUTPUT  &parm3  = hNodeTable     &dataType3  = TABLE-HANDLE}
              
  
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
  
  DEFINE VARIABLE hParentSDO           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectPath          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOAttributes       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFieldAttr    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIndex               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cForeignFields       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFieldValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIndex1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iIndex2              AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cFilterString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldNameOnly AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterTableNameOnly AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterFieldValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperator      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAlreadyInQuery      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDoNotSetFilter      AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cDataTargetLinks     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPrimarySDOName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrExpandNodeKey   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExpand              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSDOHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNoMessage           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX         AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cFirstFilter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMatchValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentRef           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNodeDetail          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dNodeObj             AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE hAttributeBuffer   AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObjectBuffer      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE dObjectBufferId    AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE hBufferCacheBuffer AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cSessionServerMode AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cGetSMode          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cServerMode        AS CHARACTER    NO-UNDO.

  DEFINE BUFFER buRunningSDOs      FOR ttRunningSDOs.
  
  IF pcSDOSBOName = "":U THEN
    RETURN.
  
  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U).
  cPrimarySDOName = DYNAMIC-FUNCTION("getPrimarySDOName":U).
  cFilterValue = DYNAMIC-FUNCTION("getFilterValue":U).
  hSDOHandle = DYNAMIC-FUNCTION("getSDOHandle":U).
  lNoMessage = DYNAMIC-FUNCTION("getNoMessage":U).
  
  /** First check that the SDO/SBO is relatively pathed **/
  IF INDEX(pcSDOSBOName,"/":U) = 0 AND
     INDEX(pcSDOSBOName,"~\":U) = 0 THEN DO:
      ASSIGN pcSDOSBOName = cPrimarySDOName.
  END.
  
  /** Secondly check that the Parent SDO/SBO is relatively pathed **/
  IF INDEX(pcParentSDOSBO,"/":U) = 0 AND
     INDEX(pcParentSDOSBO,"~\":U) = 0 AND 
     pcParentSDOSBO <> "":U THEN DO:
     pcParentSDOSBO = pcParentSDOSBO.     
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
  
  IF NOT AVAILABLE(buRunningSDOs) THEN 
  DO:
    ASSIGN
        cObjectName = pcSDOSBOName
        cObjectName = IF INDEX(cObjectName, "~\":U) <> 0 THEN REPLACE(cObjectName, "~\":U, "/":U) ELSE cObjectName
        cObjectName = SUBSTRING(cObjectName, R-INDEX(cObjectName, "/":U) + 1) NO-ERROR.
        /*cObjectName = SUBSTRING(cObjectName, 1, R-INDEX(cObjectName, ".":U) - 1).*/
  
    DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT cObjectName,
                     INPUT ?,
                     INPUT ?,
                     INPUT NO).
                     
    /* The record should be available after the cacheObjectOnClient call. */
    ASSIGN hObjectBuffer    = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
           hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
           dObjectBufferId  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           .

    ASSIGN cSDOAttributes = DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager,
                                             hAttributeBuffer,
                                             dObjectBufferId).
    

   /* Add ForeignField Information */
    IF INDEX(cSDOAttributes,"ForeignFields") <> 0 AND 
       pcForeignFields <> "":U THEN DO:
      ASSIGN iIndex1 = INDEX(cSDOAttributes,"ForeignFields" + CHR(4))
             iIndex2 = INDEX(cSDOAttributes,CHR(3),iIndex1).
      /* If Attribute is last in the list */
      IF iIndex2 = 0 THEN
        iIndex2 = LENGTH(cSDOAttributes).
      SUBSTRING(cSDOAttributes,iIndex1,(iIndex2 - iIndex1) + 1) = "ForeignFields" + CHR(4) + pcForeignFields + (IF iIndex2 <> LENGTH(cSDOAttributes) THEN CHR(3) ELSE "":U).
    END.
    
    IF INDEX(cSDOAttributes,"ForeignFields") = 0 AND 
       pcForeignFields <> "":U THEN
      ASSIGN cSDOAttributes = IF cSDOAttributes = "":U 
                              THEN "ForeignFields":U + CHR(4) + pcForeignFields
                              ELSE cSDOAttributes + CHR(3) + "ForeignFields":U + CHR(4) + pcForeignFields.
    /* Change RowsToBatch to a Default value of 1 */
    IF INDEX(cSDOAttributes,"RowsToBatch") <> 0 AND 
       pcForeignFields <> "":U THEN DO:
     ASSIGN iIndex1 = INDEX(cSDOAttributes,"RowsToBatch" + CHR(4))
            iIndex2 = INDEX(cSDOAttributes,CHR(3),iIndex1).
     /* If Attribute is last in the list */
     IF iIndex2 = 0 THEN
       iIndex2 = LENGTH(cSDOAttributes).
     SUBSTRING(cSDOAttributes,iIndex1,(iIndex2 - iIndex1) + 1) = "RowsToBatch" + CHR(4) + "1":U + (IF iIndex2 <> LENGTH(cSDOAttributes) THEN CHR(3) ELSE "":U).
    END.

    IF INDEX(cSDOAttributes,"RowsToBatch") = 0 
    AND pcForeignFields <> "":U THEN
      ASSIGN cSDOAttributes = IF cSDOAttributes = "":U 
                              THEN "RowsToBatch":U + CHR(4) + "1":U
                              ELSE cSDOAttributes + CHR(3) + "RowsToBatch":U + CHR(4) + "1":U.
   
   /* Create SDO */
    ASSIGN gcCurrentLogicalName = cObjectName.
    RUN constructObject (INPUT  hObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE + CHR(3) + "DBAWARE",
                         INPUT  FRAME {&FRAME-NAME}:HANDLE,
                         INPUT  cSDOAttributes,
                         OUTPUT phSDOHandle).

    DYNAMIC-FUNCTION("setOpenOnInit":U IN phSDOHandle, FALSE).
    
   RUN initializeObject IN phSDOHandle.
    
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
    IF pcForeignFields <> "":U AND DYNAMIC-FUNCTION("getForeignFields":U IN phSDOHandle) = "":U THEN DO:
      {set ForeignFields pcForeignFields phSDOHandle}.
    END.
    
    IF pcForeignFields <> "":U THEN DO:
      cForeignFields = "":U.
      DO iLoop = 1 TO NUM-ENTRIES(pcForeignFields):
        cForeignFields = IF cForeignFields = "":U THEN ENTRY(iLoop + 1,pcForeignFields) ELSE cForeignFields + ",":U + ENTRY(iLoop + 1,pcForeignFields).
        iLoop = iLoop + 1.
      END.
      IF VALID-HANDLE(hParentSDO) THEN
        cForeignFieldValues = DYNAMIC-FUNCTION("columnStringValue":U IN hParentSDO, cForeignFields).
      DYNAMIC-FUNCTION("setForeignValues":U IN phSDOHandle, cForeignFieldValues).
      RUN dataAvailable IN phSDOHandle (?).
    END.
  END.
  
  IF cFilterValue <> "":U AND
     cFilterValue <> ?    AND
     VALID-HANDLE(phSDOHandle) THEN DO:
    ASSIGN cQueryString    = "":U.
           cQueryString    = DYNAMIC-FUNCTION("getQueryString":U IN phSDOHandle).
    DO iLoop = 1 TO NUM-ENTRIES(cFilterValue,CHR(1)):
      cFilterString = ENTRY(iLoop,cFilterValue,CHR(1)).
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
        ASSIGN cFilterTableNameOnly = ENTRY(NUM-ENTRIES(cFilterFieldName,".":U) - 1,cFilterFieldName,".":U)
               cFilterFieldNameOnly = ENTRY(NUM-ENTRIES(cFilterFieldName,".":U),cFilterFieldName,".":U).
      ELSE
        ASSIGN cFilterTableNameOnly = "":U
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
          ASSIGN cWhere = cFilterFieldName + " ":U + cFilterTableNameOnly + TRIM(cFilterOperator) + " '" + cFilterFieldValue + "'" + CHR(3) + CHR(3) + "AND":U.
          cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
          {set manualAddQueryWhere cWhere phSDOHandle}.
        END.
      END.
    END.
  END.
  cCurrExpandNodeKey = DYNAMIC-FUNCTION("getCurrExpandNodeKey":U).
  
  
  IF plStructuredSDO AND 
     NUM-ENTRIES(pcParentChildFld,"^":U) >= 3 THEN DO:
    {get TreeDataTable hTable hTreeViewOCX}.  
    ASSIGN cFirstFilter = ENTRY(1,pcParentChildFld,"^":U)
           cParentField = ENTRY(2,pcParentChildFld,"^":U)
           cDataType    = ENTRY(4,pcParentChildFld,"^":U)
           cNodeDetail  = DYNAMIC-FUNCTION("getNodeDetails":U,hTable, cCurrExpandNodeKey)
           dNodeObj     = DECIMAL(ENTRY(1,cNodeDetail,CHR(2)))
           cParentRef   = ENTRY(3,cNodeDetail,CHR(2)).
    FIND FIRST ttNode
         WHERE ttNode.node_obj = dNodeObj 
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttNode THEN DO:
      IF ttNode.run_attribute <> "STRUCTURED":U THEN DO:
        cParentRef = "":U.
      END.
      IF ttNode.run_attribute = "STRUCTURED":U THEN DO:
        {set ForeignFields '':U phSDOHandle}.
      END.
    END.
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
            cMatchValue = QUOTER(cParentRef).
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
        {set QueryString ? phSDOHandle}.

        DYNAMIC-FUNCTION("addQueryWhere":U IN phSDOHandle,INPUT cParentField + " = ":U + cMatchValue, "":U, "AND":U).
        ASSIGN cWhere = cParentField + " = ":U + cMatchValue + CHR(3) + CHR(3) + "AND":U.
        cWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, cWhere).
        {set manualAddQueryWhere cWhere phSDOHandle}.
      END.
    END.
  END.
  /* Since we set the SDO not to open the query on initialization - we should now 
     open the query manually */
  lExpand = DYNAMIC-FUNCTION("getExpand":U).

  /* This is a work-around for issue #5814 when running
     on AppServer */
  FIND FIRST buRunningSDOs
       WHERE buRunningSDOs.cSDOName = pcSDOSBOName
       EXCLUSIVE-LOCK.
  IF AVAILABLE buRunningSDOs
     AND buRunningSDOs.cServerMode = "":U THEN DO:
    cSessionServerMode = DYNAMIC-FUNCTION('getServerOperatingMode':U IN phSDOHandle).
    IF cSessionServerMode = ? OR
       cSessionServerMode = "":U THEN
      cSessionServerMode = "NONE".
    ASSIGN buRunningSDOs.cServerMode = cSessionServerMode
           cServerMode               = cSessionServerMode.
  END.

  IF AVAILABLE buRunningSDOs
     AND buRunningSDOs.cServerMode <> "":U THEN
    cServerMode = buRunningSDOs.cServerMode.

  /********************************************************/
  /* This fixes issue #5814 - MAD - 10/04/2002 */
  cGetSMode = DYNAMIC-FUNCTION('getServerOperatingMode':U IN phSDOHandle).
  IF (cGetSMode = ? OR cGetSMode = "?":U) AND
     cServerMode <> "":U THEN
    DYNAMIC-FUNCTION('setServerOperatingMode':U IN phSDOHandle,cServerMode).
  
  IF lExpand = TRUE THEN
    DYNAMIC-FUNCTION("setRowsToBatch":U IN phSDOHandle, 200).

  /** PJudge 09.Jan.2003
   *  Removed this OpenQuery call because it causes the problems described in
   *  issue 8063: the details of the first expanded node (regardless of whether it
   *  was the first ordinal node or not) were not seen, and was found when running
   *  dynamic SDOs running across an AppServer connection.
   *  
   *  In theory, the SDO's query should not be opened here, because the OpenOnInit
   *  property is being set earlier, but this appears not to work too well.
   *  ----------------------------------------------------------------------- **/
  /***** 
  DYNAMIC-FUNCTION("openQuery":U IN phSDOHandle).
  *****/
  
  IF VALID-HANDLE(hParentSDO) THEN
    ASSIGN buRunningSDOs.hParentSDO = hParentSDO.
  
  /* If there is an SDV running that uses the last launched SDO
     we want to reposition the SDO to that last displayed record
     in that viewer. This will ensure that it is repositioned 
     after the node has been expanded. */
  IF hSDOHandle = phSDOHandle THEN
    DYNAMIC-FUNCTION("setReposSDO":U, TRUE).
  
  RUN setDataLinkActive.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyPage wWin 
PROCEDURE notifyPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProc AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iPage AS INTEGER    NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcProc).

  /* Code placed here will execute AFTER standard behavior.    */
  IF pcProc = "InitializeObject" THEN DO:
    {get CurrentPage iPage}.

    IF iPage > 0 THEN DO:
      RUN createRepositoryObjects IN TARGET-PROCEDURE (INPUT gcLaunchedFolderName,
                                                       INPUT gcLaunchedSDOName,
                                                       INPUT TARGET-PROCEDURE,
                                                       INPUT gcLaunchedRunInstance).
    END.
  END.

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
  DEFINE INPUT PARAMETER piPage       AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER plResize     AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE cButton             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dFilterViewerHeight AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dFilterViewerWidth  AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dInstanceId         AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE cLayoutCode         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hObjectBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cPagesDone          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPage               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dMinHeight          AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dMinWidth           AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE iPageCnt            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hPageBuffer         AS HANDLE    NO-UNDO.
  
  {get Page0LayoutManager cLayoutCode}.

  /* This will be the InstanceId of the current 'container'. This is not necessarily the treeview. */
  {get InstanceId dInstanceId}.
  ASSIGN hObjectBuffer = BUFFER container_Object:HANDLE
         hPageBuffer   = BUFFER container_Page:HANDLE
         .
  IF dInstanceId EQ gdTreeviewInstanceId THEN DO:
    RUN packWindow IN gshLayoutManager ( INPUT piPage,
                                         INPUT cLayoutCode,
                                         INPUT dInstanceId,
                                         INPUT hObjectBuffer,
                                         INPUT hPageBuffer,
                                         INPUT {&WINDOW-NAME}, 
                                         INPUT FRAME {&FRAME-NAME}:HANDLE,
                                         INPUT 0, 
                                         INPUT 0, 
                                         INPUT gdMaximumWindowWidth,
                                         INPUT gdMaximumWindowHeight,
                                         INPUT plResize                     ) NO-ERROR.
    
    ASSIGN dMinWidth  = MAX(dMinWidth,{&WINDOW-NAME}:MIN-WIDTH-CHARS)
           dMinHeight = MAX(dMinHeight,{&WINDOW-NAME}:MIN-HEIGHT-CHARS).
           
  END.
  ELSE DO:
      ASSIGN iPageCnt = 0.
      FOR EACH container_Page WHERE
               container_Page.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Page.tRecordIdentifier = dInstanceId         :
          ASSIGN iPageCnt = iPageCnt + 1.
      END.
      ASSIGN iPageCnt = iPageCnt - 1. /* For Page 0 */

      DO iPage = 0 TO iPageCnt:
      RUN packWindow IN gshLayoutManager ( INPUT iPage,
                                           INPUT cLayoutCode,
                                           INPUT dInstanceId,
                                           INPUT hObjectBuffer,
                                           INPUT hPageBuffer,
                                           INPUT {&WINDOW-NAME}, 
                                           INPUT FRAME {&FRAME-NAME}:HANDLE,
                                           INPUT 0,
                                           INPUT 0,
                                           INPUT gdMaximumWindowWidth,
                                           INPUT gdMaximumWindowHeight,
                                           INPUT plResize                         ).

      ASSIGN dMinWidth  = MAX(dMinWidth,{&WINDOW-NAME}:MIN-WIDTH-CHARS)
             dMinHeight = MAX(dMinHeight,{&WINDOW-NAME}:MIN-HEIGHT-CHARS)
             cPagesDone = cPagesDone + (IF NUM-ENTRIES(cPagesDone) EQ 0 THEN "":U ELSE ",":U) + STRING(iPage)
             .
    END.    /* page not yet done. */
    /*
    ASSIGN {&WINDOW-NAME}:MIN-WIDTH-CHARS  = gdMinInstanceWidth
           {&WINDOW-NAME}:MIN-HEIGHT-CHARS = gdMinInstanceHeight
           .*/
  END.    /* Not packing the treeview */

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
                                            INPUT  TARGET-PROCEDURE,         /* container handle */ 
                                            OUTPUT cButton               ).  /* button pressed */
    RUN exitObject.
    RETURN.
  END.    /* forced exit */

  /* Make sure we copied back all the page instances */
  IF VALID-HANDLE(ghFilterViewer) THEN 
      ASSIGN dFilterViewerHeight = DYNAMIC-FUNCTION("getHeight" IN ghFilterViewer)
             dFilterViewerWidth  = DYNAMIC-FUNCTION("getWidth" IN ghFilterViewer)
             .
  /*IF gcTreeLayoutCode EQ cLayoutCode THEN
      
      ASSIGN gdMinimumWindowWidth  = IF dFilterViewerWidth > {&WINDOW-NAME}:MIN-WIDTH-CHARS THEN dFilterViewerWidth ELSE {&WINDOW-NAME}:MIN-WIDTH-CHARS
             {&WINDOW-NAME}:MIN-WIDTH-CHARS  = IF dFilterViewerWidth <> 0 AND {&WINDOW-NAME}:MIN-WIDTH-CHARS < dFilterViewerWidth THEN dFilterViewerWidth ELSE {&WINDOW-NAME}:MIN-WIDTH-CHARS + .5
             gdMinimumWindowHeight = {&WINDOW-NAME}:MIN-HEIGHT-CHARS + dFilterViewerHeight
             .
  
  ELSE
  */
      ASSIGN gdMinimumFolderWidth            = dMinWidth
             gdMinimumFolderHeight           = dMinHeight
             {&WINDOW-NAME}:MIN-HEIGHT-CHARS = dMinHeight + RctBorder:COL + fiTitle:HEIGHT + DYNAMIC-FUNCTION("getHeight":U IN ghFolderToolbar) /*+ 2.8*/ + dFilterViewerHeight
             {&WINDOW-NAME}:MIN-WIDTH-CHARS  = dMinWidth + 2 /*fiResizeFillIn:COL + 7 /*+ dFilterViewerWidth*/*/ 
             .
  IF {&WINDOW-NAME}:MIN-WIDTH-CHARS < dFilterViewerWidth THEN
      ASSIGN {&WINDOW-NAME}:MIN-WIDTH-CHARS = dFilterViewerWidth + 0.5.

  RETURN.
END PROCEDURE.  /* packWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeTTLinks wWin 
PROCEDURE removeTTLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcSDOName        AS CHARACTER                NO-UNDO.

    DEFINE VARIABLE lLinkExists         AS LOGICAL                      NO-UNDO.

    FOR EACH ttLinksAdded WHERE
             ttLinksAdded.cLinkName = "Navigation":U 
             NO-LOCK:
        IF VALID-HANDLE(ghFolderToolbar) THEN
            RUN removeLink IN TARGET-PROCEDURE (ghFolderToolbar, ttLinksAdded.cLinkName, ttLinksAdded.hTargetHandle).
        ELSE
            RUN removeLink IN TARGET-PROCEDURE (ttLinksAdded.hSourceHandle, ttLinksAdded.cLinkName, ttLinksAdded.hTargetHandle).        

        DELETE ttLinksAdded.
    END.    /* each link added */

    RETURN.
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
          FRAME {&FRAME-NAME}:SCROLLABLE    = TRUE
          {&WINDOW-NAME}:WIDTH-CHARS  = MIN(MAX(DECIMAL(cWidth), {&WINDOW-NAME}:MIN-WIDTH-CHARS), 
                                             (SESSION:WIDTH-CHARS - 2.5))
          {&WINDOW-NAME}:HEIGHT-CHARS = MIN(MAX(DECIMAL(cHeight), ({&WINDOW-NAME}:MIN-HEIGHT-CHARS)),({&WINDOW-NAME}:MAX-HEIGHT-CHARS),
                                             (SESSION:HEIGHT-CHARS - 2))
          {&WINDOW-NAME}:COLUMN       = IF (DECIMAL(cColumn) + {&WINDOW-NAME}:WIDTH-CHARS) >= SESSION:WIDTH-CHARS THEN
                                              MAX(SESSION:WIDTH-CHARS - {&WINDOW-NAME}:WIDTH-CHARS, 1)
                                         ELSE IF DECIMAL(cColumn) < 0 THEN 1
                                         ELSE DECIMAL(cColumn)
          {&WINDOW-NAME}:ROW          = IF (DECIMAL(cRow) + {&WINDOW-NAME}:HEIGHT-CHARS) >= SESSION:HEIGHT-CHARS THEN
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
  DEFINE VARIABLE dAllowedMinWidth    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAllowedMinHeight   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRow                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dColumn             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dInstanceId         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hObjectBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPageBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dFolderWidth        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderHeight       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderCol          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFolderRow          AS DECIMAL    NO-UNDO.

  RUN getTopLeft (OUTPUT dRow, OUTPUT dColumn) NO-ERROR.

  {get Page0LayoutManager cLayoutCode}.
  {get InstanceId dInstanceId}.

  ASSIGN dAllowedMinWidth  = gdMinimumFolderWidth  + fiResizeFillIn:COL IN FRAME {&FRAME-NAME} + 3.5
         dAllowedMinHeight = gdMinimumFolderHeight
         .

  IF {&WINDOW-NAME}:WIDTH-CHARS LT dAllowedMinWidth THEN
      ASSIGN {&WINDOW-NAME}:WIDTH-CHARS  = dAllowedMinWidth.

  IF {&WINDOW-NAME}:HEIGHT-CHARS LT dAllowedMinHeight THEN
      ASSIGN {&WINDOW-NAME}:HEIGHT-CHARS = dAllowedMinHeight
             {&WINDOW-NAME}:MIN-HEIGHT-CHARS = dAllowedMinHeight
             .

  IF {&WINDOW-NAME}:WIDTH-CHARS GT SESSION:WIDTH-CHARS THEN
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN {&WINDOW-NAME}:WIDTH-CHARS = SESSION:WIDTH-CHARS.

      IF fiResizeFillIn:COL GT ({&WINDOW-NAME}:WIDTH-CHARS - gdMinimumFolderWidth - 5) THEN
          ASSIGN fiResizeFillIn:COL = ({&WINDOW-NAME}:WIDTH-CHARS - gdMinimumFolderWidth - 5).

      APPLY "WINDOW-RESIZED":U TO {&WINDOW-NAME}.
  END.

  PUBLISH "windowToBeSized":U FROM TARGET-PROCEDURE.

  /* The code to find the following handles were placed here because of some timing issues that were encountered with resizing */
  IF NOT VALID-HANDLE(ghContainerToolbar) THEN ghContainerToolbar = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U IN THIS-PROCEDURE, INPUT "Toolbar-Source"))).
  IF NOT VALID-HANDLE(ghTreeViewOCX)      THEN ghTreeViewOCX      = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("linkHandles":U IN THIS-PROCEDURE, INPUT "TVController-Source":U))). 
  IF NOT VALID-HANDLE(ghFilterViewer)     THEN ghFilterViewer     = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U IN THIS-PROCEDURE, INPUT "TreeFilter-Source"))).
  IF NOT VALID-HANDLE(ghFolder)           THEN ghFolder           = WIDGET-HANDLE(ENTRY(1, DYNAMIC-FUNCTION("LinkHandles":U IN THIS-PROCEDURE, INPUT "Page-Source"))).

  IF VALID-HANDLE(ghFilterViewer) THEN
      SUBSCRIBE PROCEDURE ghTreeViewOCX TO "filterDataAvailable":U IN ghFilterViewer.

  ASSIGN hObjectBuffer = BUFFER container_Object:HANDLE
         hPageBuffer   = BUFFER container_Page:HANDLE
         .

  /* Store TreeView's ContainerToolbar and Folder Info elsewhere for the momemnt */
  /* If whe don't do this, the resize procedure will try to reposition them */
  IF glMenuMaintenance AND NOT glTreeViewDefaults THEN
  DO:
    IF VALID-HANDLE(ghFolder) THEN
      RUN hideObject IN ghFolder.
    EMPTY TEMP-TABLE tTreeObjects.
    FOR EACH container_object 
        EXCLUSIVE-LOCK:
      IF container_object.tObjectInstanceHandle = ghFolderToolbar OR
         /*container_object.tObjectInstanceHandle = ghFolder        OR*/
         container_object.tObjectInstanceHandle = ghContainerToolbar THEN DO:
        CREATE tTreeObjects.
        BUFFER-COPY container_object TO tTreeObjects.
        DELETE container_object.
      END.
    END.
  END.
  
  IF NOT glMenuMaintenance AND NOT glTreeViewDefaults THEN DO:
    FOR EACH container_object 
        EXCLUSIVE-LOCK:
      IF container_object.tObjectInstanceHandle = ghFolderToolbar OR
         container_object.tObjectInstanceHandle = ghFolder        THEN DO:
        CREATE tTreeObjects.
        BUFFER-COPY container_object TO tTreeObjects.
        DELETE container_object.
      END.
    END.
  END.

  RUN resizeWindow IN gshLayoutManager ( INPUT cLayoutCode,
                                         INPUT {&WINDOW-NAME}, 
                                         INPUT FRAME {&FRAME-NAME}:HANDLE,
                                         INPUT dInstanceId,
                                         INPUT hObjectBuffer,
                                         INPUT hPageBuffer                ).

  /* Put back the TreeView's ContainerToolbar and Folder */
  FOR EACH tTreeObjects 
      EXCLUSIVE-LOCK:
    CREATE container_object.
    BUFFER-COPY tTreeObjects TO container_object.
    DELETE tTreeObjects.
  END.

  IF glMenuMaintenance AND NOT glTreeViewDefaults AND VALID-HANDLE(ghFolder) THEN
  DO:
    dFolderWidth = DYNAMIC-FUNCTION("getWidth":U IN ghFolder).
    dFolderHeight = DYNAMIC-FUNCTION("getHeight":U IN ghFolder).
    dFolderCol   = DYNAMIC-FUNCTION("getCol":U IN ghFolder).
    dFolderRow   = DYNAMIC-FUNCTION("getRow":U IN ghFolder).
    RUN repositionObject IN ghFolder (INPUT dFolderRow, INPUT dFolderCol - 1.6).
    RUN resizeObject IN ghFolder (INPUT dFolderHeight + 1, INPUT dFolderWidth + 3.5).
  END.

  RETURN.
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
  RUN "adm2/dyntreeview.w *RTB-SmObj* ".

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
  IF lSaveWindowPos THEN DO WITH FRAME {&FRAME-NAME}:
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
    DEFINE VARIABLE dFilterViewerWidth  AS DECIMAL    NO-UNDO.

    IF plMenuController THEN
    DO:
      ASSIGN
          gdMinimumWindowWidth = 100
          gdMinimumWindowHeight = 11                  
          gdMaximumWindowWidth = SESSION:WIDTH - 1
          gdMaximumWindowHeight = SESSION:HEIGHT - 1.
    END.
    ELSE DO:
      IF VALID-HANDLE(ghFilterViewer) THEN
        dFilterViewerWidth = DYNAMIC-FUNCTION("getWidth":u IN ghFilterViewer).
      ASSIGN 
          gdMinimumWindowWidth  = MAX(dFilterViewerWidth,100)
          gdMinimumWindowHeight = 11
          gdMaximumWindowWidth  = SESSION:WIDTH - 1
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
        cObjectName  = DYNAMIC-FUNCTION("getLogicalObjectName":U)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNonTreeObjects wWin 
PROCEDURE setNonTreeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttNonTreeObjects.

    RETURN.
END PROCEDURE.  /* setNonTreeObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRunningSDOs wWin 
PROCEDURE setRunningSDOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttRunningSDOs.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTopLeft wWin 
PROCEDURE setTopLeft :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdTopCoordinate  AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLeftCoordinate AS DECIMAL    NO-UNDO.

  ASSIGN gdTopCoordinate  = pdTopCoordinate 
         gdLeftCoordinate = pdLeftCoordinate.
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
  
  APPLY "END-MOVE":U TO fiResizeFillIn.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildContainerTables wWin 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates information which will be used by this container to construct
            objects on the container.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hPageBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hLinkBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerObject        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerPage          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerLink          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dInstanceInstanceId     AS DECIMAL                  NO-UNDO.
    
    EMPTY TEMP-TABLE container_Object.
    EMPTY TEMP-TABLE container_Page.
    EMPTY TEMP-TABLE container_Link.

    ASSIGN hContainerObject = BUFFER container_Object:HANDLE
           hContainerPage   = BUFFER container_Page:HANDLE
           hContainerLink   = BUFFER container_Link:HANDLE
           .
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId)
           hPageBuffer   = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager)
           hLinkBuffer   = DYNAMIC-FUNCTION("getCacheLinkBuffer":U IN gshRepositoryManager)
           .
    /* We create a local buffer here because we don't want it to go out of scope. 
     * constructObject results i the hObjectBuffer going out of scope, since there are FINDs
     * performed on that buffer.                                                            */
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    IF NOT VALID-HANDLE(ghQuery2) THEN
        CREATE QUERY ghQuery2.

    ghQuery1:SET-BUFFERS(hObjectBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(pdInstanceId) + " OR ":U 
                           + hObjectBuffer:NAME + ".tRecordIdentifier = "          + QUOTER(pdInstanceId) ).
    ghQuery1:QUERY-OPEN().

    ghQuery1:GET-FIRST().
    DO WHILE hObjectBuffer:AVAILABLE:

        hContainerObject:BUFFER-CREATE().
        hContainerObject:BUFFER-COPY(hObjectBuffer).

        ASSIGN dInstanceInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               hAttributeBuffer    = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceInstanceId) ).

        /* Store the list of settable attributes. */
        ASSIGN hContainerObject:BUFFER-FIELD("tAttributeList":U):BUFFER-VALUE = DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager,
                                                                                                 INPUT hAttributeBuffer,
                                                                                                 INPUT dInstanceInstanceId).
        /* Store all of the attributes in RAW format */
        hAttributeBuffer:RAW-TRANSFER(TRUE, hContainerObject:BUFFER-FIELD("tRawAttributes":U)).

        ASSIGN hContainerObject:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.

        hContainerObject:BUFFER-RELEASE().
        ghQuery1:GET-NEXT().
    END.    /* available buffer */
    ghQuery1:QUERY-CLOSE().

    ghQuery2:SET-BUFFERS(hPageBuffer).
    ghQuery2:QUERY-PREPARE(" FOR EACH ":U + hPageBuffer:NAME + " WHERE ":U + hPageBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ).
    ghQuery2:QUERY-OPEN().

    ghQuery2:GET-FIRST().
    DO WHILE hPageBuffer:AVAILABLE:
        hContainerPage:BUFFER-CREATE().
        hContainerPage:BUFFER-COPY(hPageBuffer).
        ASSIGN hContainerPage:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.
        hContainerPage:BUFFER-RELEASE().

        ghQuery2:GET-NEXT().
    END.    /* available page */
    ghQuery2:QUERY-CLOSE().

    ghQuery2:SET-BUFFERS(hLinkBuffer).
    ghQuery2:QUERY-PREPARE(" FOR EACH ":U + hLinkBuffer:NAME + " WHERE ":U + hLinkBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ).
    ghQuery2:QUERY-OPEN().

    ghQuery2:GET-FIRST().
    DO WHILE hLinkBuffer:AVAILABLE:
        hContainerLink:BUFFER-CREATE().
        hContainerLink:BUFFER-COPY(hLinkBuffer).
        ASSIGN hContainerLink:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.
        hContainerLink:BUFFER-RELEASE().

        ghQuery2:GET-NEXT().
    END.    /* available link */
    ghQuery2:QUERY-CLOSE().

    RETURN TRUE.
END FUNCTION.   /* buildContainerTables */

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
  
  {&WINDOW-NAME}:TITLE = "":U.

  RETURN {&WINDOW-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalname wWin 
FUNCTION getCurrentLogicalname RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN gcCurrentLogicalName.
END FUNCTION.   /* getCurrentLogicalname */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentMode wWin 
FUNCTION getCurrentMode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcCurrentMode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentNodeKey wWin 
FUNCTION getCurrentNodeKey RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcCurrentNodeKey.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrExpandNodeKey wWin 
FUNCTION getCurrExpandNodeKey RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcCurrExpandNodeKey.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDelete wWin 
FUNCTION getDelete RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glDelete.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExpand wWin 
FUNCTION getExpand RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glExpand.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterApplied wWin 
FUNCTION getFilterApplied RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glFilterApplied.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterValue wWin 
FUNCTION getFilterValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcFilterValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterViewerHandle wWin 
FUNCTION getFilterViewerHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  IF VALID-HANDLE(ghFilterViewer) THEN 
    RETURN ghFilterViewer.
  ELSE 
    RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle wWin 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN FRAME {&FRAME-NAME}:HANDLE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceAttributes wWin 
FUNCTION getInstanceAttributes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcInstanceAttributes.   /* Function return value. */

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
    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    
    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure     = TARGET-PROCEDURE   AND
               container_Object.tObjectInstanceHandle = phProcedureHandle
               NO-ERROR.
    IF AVAILABLE container_Object THEN
        ASSIGN dObjectInstanceObj = container_Object.tObjectInstanceObj.
    ELSE
        ASSIGN dObjectInstanceObj = 0.

    RETURN dObjectInstanceObj.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastLaunchedNode wWin 
FUNCTION getLastLaunchedNode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcLastLaunchedNode.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenuMaintenance wWin 
FUNCTION getMenuMaintenance RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glMenuMaintenance.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewChildNode wWin 
FUNCTION getNewChildNode RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glNewChildNode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewContainerMode wWin 
FUNCTION getNewContainerMode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcNewContainerMode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNodeObj wWin 
FUNCTION getNodeObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gdNodeObj.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNoMessage wWin 
FUNCTION getNoMessage RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glNoMessage.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectHandles wWin 
FUNCTION getObjectHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN gcObjectHandles.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInitialized wWin 
FUNCTION getObjectInitialized RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glObjectInitialized.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectPage wWin 
FUNCTION getObjectPage RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPageNum AS INTEGER    NO-UNDO.

  {get CurrentPage iPageNum}.

  IF iPageNum < 0 THEN
    iPageNum = 0.
  IF iPageNum = ? THEN
    iPageNum = 0.
  RETURN iPageNum.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOnceOnly wWin 
FUNCTION getOnceOnly RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glOnceOnly.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentNode wWin 
FUNCTION getParentNode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcParentNode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrimarySDOName wWin 
FUNCTION getPrimarySDOName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcPrimarySDOName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRawAttributeValues wWin 
FUNCTION getRawAttributeValues RETURNS HANDLE
    ( INPUT pdInstanceId        AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = pdInstanceId
               NO-ERROR.
    IF AVAILABLE container_Object THEN
        RETURN BUFFER container_Object:HANDLE.

    RETURN ?.
END FUNCTION.   /* getRawAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRctBorderHandle wWin 
FUNCTION getRctBorderHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF VALID-HANDLE(rctBorder:HANDLE) THEN 
      RETURN rctBorder:HANDLE .
    ELSE 
      RETURN ?. 
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReposParentNode wWin 
FUNCTION getReposParentNode RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glReposParentNode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReposSDO wWin 
FUNCTION getReposSDO RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glReposSDO.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeFillInHandle wWin 
FUNCTION getResizeFillInHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF VALID-HANDLE(fiResizeFillIn:HANDLE) THEN 
      RETURN fiResizeFillIn:HANDLE .
    ELSE 
      RETURN ?. 
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOHandle wWin 
FUNCTION getSDOHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghSDOHandle.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getState wWin 
FUNCTION getState RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcState.   /* Function return value. */

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
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeContainerMode wWin 
FUNCTION getTreeContainerMode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcContainerMode.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeViewOCX wWin 
FUNCTION getTreeViewOCX RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTreeViewOCX.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {&WINDOW-NAME}:HANDLE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow wWin 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode       AS INTEGER    NO-UNDO.
  
  giLockWindow = giLockWindow + (IF plLockWindow THEN 1 ELSE -1).

  IF plLockWindow AND giLockWindow > 1 THEN
    RETURN FALSE.

  IF NOT plLockWindow AND giLockWindow > 0 THEN
    RETURN FALSE.

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT {&WINDOW-NAME}:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentMode wWin 
FUNCTION setCurrentMode RETURNS LOGICAL
  ( pcCurrentMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcCurrentMode = pcCurrentMode.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentNodeKey wWin 
FUNCTION setCurrentNodeKey RETURNS LOGICAL
  ( pcCurrentNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcCurrentNodeKey = pcCurrentNodeKey.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrExpandNodeKey wWin 
FUNCTION setCurrExpandNodeKey RETURNS LOGICAL
  ( pcCurrExpandNodeKey AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcCurrExpandNodeKey = pcCurrExpandNodeKey.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultMenuBar wWin 
FUNCTION setDefaultMenuBar RETURNS LOGICAL
  ( phDefaultMenuBar AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghDefaultMenuBar = phDefaultMenuBar.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDelete wWin 
FUNCTION setDelete RETURNS LOGICAL
  ( plDelete AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glDelete = plDelete.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExpand wWin 
FUNCTION setExpand RETURNS LOGICAL
  ( plExpand AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glExpand = plExpand.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterApplied wWin 
FUNCTION setFilterApplied RETURNS LOGICAL
  ( plFilterApplied AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glFilterApplied = plFilterApplied.
  RETURN FALSE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInstanceAttributes wWin 
FUNCTION setInstanceAttributes RETURNS LOGICAL
  ( pcInstanceAttributes AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcInstanceAttributes = pcInstanceAttributes.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastLaunchedNode wWin 
FUNCTION setLastLaunchedNode RETURNS LOGICAL
  ( pcLastLaunchedNode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcLastLaunchedNode = pcLastLaunchedNode.
  RETURN FALSE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMenuMaintenance wWin 
FUNCTION setMenuMaintenance RETURNS LOGICAL
  ( plMenuMaintenance AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glMenuMaintenance = plMenuMaintenance.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNewChildNode wWin 
FUNCTION setNewChildNode RETURNS LOGICAL
  ( plNewChildNode AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glNewChildNode = plNewChildNode.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNewContainerMode wWin 
FUNCTION setNewContainerMode RETURNS LOGICAL
  ( pcNewContainerMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcNewContainerMode = pcNewContainerMode.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNodeObj wWin 
FUNCTION setNodeObj RETURNS LOGICAL
  ( pdNodeObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gdNodeObj = pdNodeObj.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectInitialized wWin 
FUNCTION setObjectInitialized RETURNS LOGICAL
  ( pcObjectInitialized AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glObjectInitialized = pcObjectInitialized.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOnceOnly wWin 
FUNCTION setOnceOnly RETURNS LOGICAL
  ( pcOnceOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glOnceOnly = pcOnceOnly.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentNode wWin 
FUNCTION setParentNode RETURNS LOGICAL
  ( pcParentNode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcParentNode = pcParentNode.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrimarySDOName wWin 
FUNCTION setPrimarySDOName RETURNS LOGICAL
  ( pcPrimarySDOName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcPrimarySDOName = pcPrimarySDOName.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReposParentNode wWin 
FUNCTION setReposParentNode RETURNS LOGICAL
  ( plReposParentNode AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glReposParentNode = plReposParentNode.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReposSDO wWin 
FUNCTION setReposSDO RETURNS LOGICAL
  ( plReposSDO AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glReposSDO = plReposSDO.
  RETURN FALSE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDOHandle wWin 
FUNCTION setSDOHandle RETURNS LOGICAL
  ( phSDOHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghSDOHandle = phSDOHandle.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerOperatingMode wWin 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  IF pcServerOperatingMode = ? OR
     pcServerOperatingMode = "?":U THEN
    RETURN FALSE.
  
  RETURN SUPER(pcServerOperatingMode).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setState wWin 
FUNCTION setState RETURNS LOGICAL
  ( pcState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcState = pcState.
  RETURN FALSE.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTreeContainerMode wWin 
FUNCTION setTreeContainerMode RETURNS LOGICAL
  ( pcTreeContainerMode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  gcContainerMode = pcTreeContainerMode.

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

  {fnarg lockWindow TRUE}.

  IF TRIM(pcLogicalObjectName) = "":U THEN
  DO:
    DYNAMIC-FUNCTION("setFolderLabels":U IN ghFolder, INPUT "&Details":U).
    RUN initializeObject IN ghFolder.

    {fnarg lockWindow FALSE}.

    RETURN TRUE.
  END.
  
  EMPTY TEMP-TABLE ttTranslate.
  
  cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN ghFolder).

  /* For some reason these are comma-delimited here, rather than pipe delimited.
   * Make sure that the delimiter is a pipe.                                    */
  ASSIGN cFolderLabels = REPLACE(cFolderLabels, ",":U, "|":U).

  cFolderLabels = REPLACE(cFolderLabels,"Page Zero|":U,"":U).
  IF cFolderLabels = "":U OR cFolderLabels = ? OR cFolderLabels = "|":U THEN
    cFolderLabels = "&Details".

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
    
    /* check security for folder labels */
    RUN tokenSecurityGet IN gshSecurityManager (INPUT THIS-PROCEDURE,
                                                INPUT pcLogicalObjectName,
                                                INPUT cRunAttribute,
                                                OUTPUT cSecuredTokens).
    
    label-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
    
      ASSIGN cLabel = ENTRY(iLoop, cFolderLabels, "|":U).

      IF  cSecuredTokens <> "":U
          AND LOOKUP(cLabel,cSecuredTokens) <> 0 THEN
        ASSIGN cDisabledPages = cDisabledPages + (IF cDisabledPages <> "":U THEN ",":U ELSE "":U) +
                                STRING(iLoop).
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
    END.  /* label-loop */
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
    
    /* translate pages */
    IF cFolderLabels <> "":U THEN
      DYNAMIC-FUNCTION("setFolderLabels":U IN ghFolder, INPUT cFolderLabels).

    /* secure pages */
    IF cDisabledPages <> "":U THEN
      DYNAMIC-FUNCTION("disablePagesInFolder":U, INPUT "security," + cDisabledPages).

    RUN initializeObject IN ghFolder.

    {fnarg lockWindow FALSE}.

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
           gcWindowName   = pcWindowName.
  ELSE DO:
    ASSIGN gcFolderTitle = pcWindowName.
    RUN updateTitleOverride (gcFolderTitle).
  END.
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

