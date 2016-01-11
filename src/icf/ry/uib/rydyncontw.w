&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This is the Astra 2 Dynamic Container. No new instances of this should be created. Use the Astra 2 Wizard Menu Controller to create instances using Repository Data."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
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
/*---------------------------------------------------------------------------------
  File: rydyncontw.w

  Description:  Astra 2 Dynamic Container
  
  Purpose:      Astra 2 Dynamic Container

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000006   UserRef:    
                Date:   08/01/2001  Author:     Peter Judge

  Update Notes: Changed calls to getObjectAttributes in the Repository Manager, and the way
                that the attribute value lists are determined. This change was needed because
                of the changes necessary for the Dynamic Viewer.

  (v:010001)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Apply entry to first page of window

  (v:010002)    Task:        6194   UserRef:    
                Date:   28/06/2000  Author:     Robin Roos

  Update Notes: Window title field for data vis objects

  (v:010003)    Task:        6205   UserRef:    
                Date:   30/06/2000  Author:     Robin Roos

  Update Notes: Dynamic Viewer

  (v:010004)    Task:        6236   UserRef:    
                Date:   05/07/2000  Author:     Jenny Bond

  Update Notes: Implement Window Position & Sizes

  (v:010005)    Task:        6405   UserRef:    9.1B
                Date:   02/08/2000  Author:     Anthony Swindells

  Update Notes: Rename Astra 2 objectname property to AstraObjectName to avoid conflict with
                new 9.1B property for objectname that is the object name without an extension
                or path for use as a prefix for example with sdo's in a sbo.
                Also check new session properties for launched container via protools.

  (v:010006)    Task:        6462   UserRef:    
                Date:   14/08/2000  Author:     Jenny Bond

  Update Notes: When positioning window, ensure not off screen entirely.  If so, position in
                centre of screen.

  (v:010007)    Task:        6498   UserRef:    
                Date:   17/08/2000  Author:     Jenny Bond

  Update Notes: Refine window pos & size

  (v:010008)    Task:        6517   UserRef:    
                Date:   23/08/2000  Author:     Jenny Bond

  Update Notes: Fix problems with height not exactly right.

  (v:010009)    Task:        6812   UserRef:    
                Date:   05/10/2000  Author:     Anthony Swindells

  Update Notes: Fix Astra2 nav buttons sensitivity when running object controller to object
                controller. Also fix switch from view to modify mode when nav buttons are
                pressed on a folder.

  (v:010011)    Task:        7024   UserRef:    
                Date:   09/11/2000  Author:     Chris Koster

  Update Notes: Extending FolderPage Enable / Disable Functionsble Functions

  (v:010012)    Task:        7415   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix issues with European format decimals

  (v:010013)    Task:        7419   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix European format issues

  (v:010014)    Task:        7452   UserRef:    
                Date:   03/01/2001  Author:     Anthony Swindells

  Update Notes: fix instantiation order

  (v:010015)    Task:        7538   UserRef:    
                Date:   09/01/2001  Author:     Anthony Swindells

  Update Notes: Fix icons

  (v:010016)    Task:        7487   UserRef:    
                Date:   10/01/2001  Author:     Anthony Swindells

  Update Notes: Fix issues with multi-pages and folder wizard.
                Order of instantiation by page then sequence with sdos first, then toolbars,
                then other objects

  (v:010017)    Task:        7694   UserRef:    
                Date:   24/01/2001  Author:     Anthony Swindells

  Update Notes: support more layouts

  (v:010018)    Task:        7737   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Change ESC exit hook to first ask a question if windows open.

  (v:010019)    Task:        8171   UserRef:    
                Date:   16/03/2001  Author:     Chris Koster

  Update Notes: Adding Visit TreeView

  (v:010020)    Task:        8722   UserRef:    
                Date:   14/05/2001  Author:     Anthony Swindells

  Update Notes: implement forced exit functionality. If window private-data is set to
                forcedexit, then exit the folder at end of initializeobject. The reason for the
                exit could also be set in the private-data of the window, seperated by a chr(3)
                from the forced exit text.
 
 
  (v:010021)    Issue:      1663   UserRef:    
                Date:   10/10/2001  Author:     Don Bulua
 Update Notes: Adding Calculation of relativePages. Modified createpages to
               calculate pages that are dependent on current page

  (v:010022)    Task:           0   UserRef:    
                Date:   01/24/2002  Author:     Mark Davies (MIP)

  Update Notes: Removed this 'PROCESS EVENTS' statement in initializeObject due to Issue #3333 and #3641 loged on issuezilla

-----------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       rydyncontw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamiccontainer yes

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* include temp-table definitions */
{af/sup2/afglobals.i}
{ry/app/rycsofetch.i}

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

DEFINE VARIABLE gdMinimumWindowWidth AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMinimumWindowHeight AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMaximumWindowWidth AS DECIMAL INITIAL ?.
DEFINE VARIABLE gdMaximumWindowHeight AS DECIMAL INITIAL ?.

DEFINE VARIABLE gcLaunchLogicalObject AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcLaunchRunAttribute  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcValueList           AS CHARACTER NO-UNDO.

DEFINE VARIABLE gcContainerMode       AS CHARACTER NO-UNDO.

DEFINE VARIABLE gcObjectHandles       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcToolbarHandles      AS CHARACTER    NO-UNDO.

/* use global variables as createobjects called for each page and only
   want to get this info once - for performance reasons mainly
*/
DEFINE VARIABLE glMenuController      AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE glSaveWindowPos       AS LOGICAL INITIAL ? NO-UNDO.
DEFINE VARIABLE glFoundSavedSize      AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE gdSavedWidth          AS DECIMAL INITIAL ? NO-UNDO.
DEFINE VARIABLE gdSavedHeight         AS DECIMAL INITIAL ? NO-UNDO.
DEFINE VARIABLE gdSavedColumn         AS DECIMAL INITIAL ? NO-UNDO.
DEFINE VARIABLE gdSavedRow            AS DECIMAL INITIAL ? NO-UNDO.
DEFINE VARIABLE giResizeOnPage        AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE gcPageLinkList        AS CHARACTER  NO-UNDO.

{af/app/afttsecurityctrl.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerObjectHandles wWin 
FUNCTION getContainerObjectHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle wWin 
FUNCTION getFrameHandle RETURNS HANDLE
  ( ip_procedure_handle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceObjectId wWin 
FUNCTION getInstanceObjectId RETURNS DECIMAL
    ( phProcedureHandle     AS HANDLE    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHandles wWin 
FUNCTION getToolbarHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
  (  )  FORWARD.

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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.8 BY 15.57.


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
         TITLE              = "Dynamic Object Controller"
         HEIGHT             = 15.57
         WIDTH              = 118.8
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Dynamic Object Controller */
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
ON WINDOW-CLOSE OF wWin /* Dynamic Object Controller */
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
ON WINDOW-RESIZED OF wWin /* Dynamic Object Controller */
DO:
    RUN resizeWindow.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF VALID-HANDLE({&WINDOW-NAME}) THEN
DO:
  ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    {&WINDOW-NAME}:KEEP-FRAME-Z-ORDER = YES
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

  {aficonload.i}

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

  /* By default, Make sure current-window is always the window with focus. */
  /* To get the old behavior, simply define OldCurrentWindowFocus.    */
  &IF DEFINED(OldCurrentWindowFocus) = 0 &THEN    /* if not defined */
    ON ENTRY OF {&WINDOW-NAME} DO:
      ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
    END.
  &ENDIF

  /* Execute this code only if not being run PERSISTENT, i.e., if in test mode
   of one kind or another or if this is a Main Window. Otherwise postpone 
   'initialize' until told to do so. */

  &IF DEFINED(UIB_IS_RUNNING) EQ 0 &THEN
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
  DO:
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
  END. /* IF NOT THIS-PROCEDURE:PERSISTENT THEN */
  &ENDIF

END. /* IF VALID-HANDLE({&WINDOW-NAME}) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageLinkRecursive wWin 
PROCEDURE buildPageLinkRecursive :
/*------------------------------------------------------------------------------
  Purpose:     For a given object, this procedure calculates those pages
               that are dependent on that object. The system checks whether there
               exist any ADM DATA or GROUP-ASSIGN links that would necessitate the initialization of
               those objects across the link.
               
  Parameters:  INPUT        piCurrentPage   The current page that is being contstructed
               INPUT        pdSourceObject  ObjectID of object    
               INPUT-OUTPUT pcPageList      Comma delimited list of relative pages
  Notes:       This procedure is called from buildPageLinks and is recursivly called.
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER piCurrentPage AS INTEGER    NO-UNDO.
DEFINE INPUT        PARAMETER pdSourceObj   AS DECIMAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcPageList    AS CHARACTER  NO-UNDO.

DEFINE BUFFER BBtt_object_instance FOR tt_object_instance.
DEFINE BUFFER BBtt_link FOR tt_link.

DEFINE VARIABLE cObjects AS CHARACTER  NO-UNDO.

FIND BBtt_object_instance
  WHERE BBtt_object_instance.object_instance_obj = pdSourceObj NO-ERROR.
IF NOT AVAILABLE  BBtt_object_instance THEN RETURN.

IF BBtt_object_instance.page_number > 0 AND BBtt_object_instance.PAGE_number <> piCurrentPage
      AND LOOKUP(STRING(BBtt_object_instance.page_number),pcPageList) = 0 THEN
DO:
   cObjects = pageNTargets(THIS-PROCEDURE, BBtt_object_instance.page_number).
   IF cObjects = "" THEN
      pcPageList = pcPageList + (IF pcPageList = "" THEN "" ELSE ",") + STRING(BBtt_object_instance.page_number).
END.
FOR EACH BBtt_link
     WHERE BBtt_link.target_object_instance_obj = BBtt_object_instance.object_instance_obj
       AND (BBtt_link.link_name = "DATA":U OR BBtt_link.link_name = "GROUP-ASSIGN":U):
    
  IF BBtt_link.source_object_instance_obj > 0 THEN
     RUN buildPageLinkRecursive ( INPUT piCurrentPage,
                                  INPUT BBtt_link.source_object_instance_obj,
                                  INPUT-OUTPUT pcPageList).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageLinks wWin 
PROCEDURE buildPageLinks :
/*------------------------------------------------------------------------------
  Purpose:     For a given page, this procedure calculates those pages
               that are dependent on that page. The system checks whether there
               exist any ADM DATA links that would necessitate the initialization of
               those objects across the link.
               
  Parameters:  INPUT  piCurrentPage  Current selected page
               OUTPUT pcPageList     Comma delimited list of relative pages
  Notes:       This procedure is called from createObjects and calls procedure
               buildPageLinkrecursive.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piCurrentPage AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcPageList    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cPageList AS CHARACTER  NO-UNDO.

FOR EACH tt_object_instance
    WHERE tt_object_instance.page_number = piCurrentPage
      AND tt_object_instance.object_instance_obj <> 0
       BY tt_object_instance.page_number 
        BY tt_object_instance.instance_order 
         BY tt_object_instance.layout_position :

  FOR EACH tt_link
     WHERE tt_link.target_object_instance_obj = tt_object_instance.object_instance_obj
       AND tt_link.link_name = "DATA":U :
    
    IF tt_link.source_object_instance_obj > 0  THEN DO:
      RUN buildPageLinkRecursive ( INPUT piCurrentPage,
                                   INPUT tt_link.source_object_instance_obj,
                                   INPUT-OUTPUT cPageList).
    END.
  END.
END.
ASSIGN pcPageList = cPageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects wWin 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Use many global variables in here as it is called for each page
               and much of what it does must only be done once.
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
DEFINE VARIABLE cInitialPageList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cInitPages          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iEntry              AS INTEGER      NO-UNDO.
DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.
DEFINE VARIABLE cDataTargets        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSdoForeignFields   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataTarget         AS HANDLE       NO-UNDO.
DEFINE VARIABLE cPageLinkList       AS CHARACTER    NO-UNDO.


/* Code placed here will execute PRIOR to standard behavior. */

RUN SUPER.

/* get logical object name once only and store in a variable */
ASSIGN 
  cLogicalObjectName = getLogicalObjectName().

ASSIGN
  iCurrentPage = getCurrentPage()
  iStartPage = iCurrentPage
  lResized = NO.

IF iCurrentPage = 0 THEN
DO:
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
         WHERE tt_object_instance.OBJECT_instance_obj = 0
         NO-ERROR.
    IF AVAILABLE tt_object_instance THEN
      ASSIGN cLocalAttributes = tt_object_instance.instance_attribute_list. 

    /* Container Attribute Values */
    RUN setLocalAttributes( INPUT cLocalAttributes ).

    /* Clear list of constructed objects on container */
    ASSIGN
      gcObjectHandles = "":U
      gcToolbarHandles = "":U.                

    FIND FIRST tt_page WHERE tt_page.PAGE_number = 0 NO-ERROR.
    IF AVAILABLE tt_page THEN
    DO:
      {set Page0LayoutManager tt_page.layout_code}.
    END.

    /* get list of initial pages to construct - if setup.
       The list is a comma delimited list of initial pages, or * for all or
       empty for just the start page and page 0, which is the default
    */
    {get InitialPageList cInitialPageList}.
    IF cInitialPageList = "*":U THEN /* Deal with all pages option */
    DO:
      ASSIGN cInitialPageList = "":U.
      FOR EACH tt_page WHERE tt_page.PAGE_number > 0 BY tt_page.PAGE_number:
        ASSIGN 
          cInitialPageList = cInitialPageList + (IF cInitialPageList = "":U THEN "":U ELSE ",":U)
                             + STRING(tt_page.PAGE_number)
          .
      END.
    END.

END. /* page 0 */

/* Common code for all pages - including page 0 */    

/* exit if invalid page */
IF iCurrentPage > 0 AND NOT CAN-FIND(FIRST tt_page WHERE tt_page.PAGE_number = iCurrentPage) THEN RETURN.

/* start off by making the frame's virtual dimensions very big */
ASSIGN
    FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = SESSION:WIDTH + 1
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = SESSION:HEIGHT + 1
    FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
    .
/* Work out start page and if pages exist */
FIND FIRST tt_page WHERE tt_page.PAGE_number > 0 NO-ERROR.
IF AVAILABLE tt_page THEN 
  ASSIGN iStartPage = tt_page.PAGE_number.
/* set resize on page to start page */
IF iCurrentPage = 0 THEN ASSIGN giResizeOnPage = iStartPage.

/* Set page initialized flag */
FIND FIRST tt_page
     WHERE tt_page.PAGE_number = iCurrentPage
     NO-ERROR.
IF AVAILABLE tt_page THEN
  ASSIGN tt_page.page_initialized = YES.

 /* loop through instances on page and create objects on them */
FOR EACH tt_object_instance
   WHERE tt_object_instance.PAGE_number = iCurrentPage
     AND tt_object_instance.OBJECT_instance_obj <> 0
      BY tt_object_instance.PAGE_number BY tt_object_instance.instance_order BY tt_object_instance.layout_position :


  IF tt_object_instance.object_pathed_filename = "ry/obj/rystatusbv.w" THEN
      ASSIGN
          glMenuController = YES.
  
  IF tt_object_instance.PAGE_number <> ? THEN
    DYNAMIC-FUNCTION("setCurrentPage":U, INPUT tt_object_instance.PAGE_number).
  ELSE
    DYNAMIC-FUNCTION("setCurrentPage":U, INPUT 0).
  
  RUN constructObject (INPUT  tt_object_instance.object_pathed_filename + (IF tt_object_instance.db_aware OR  tt_object_instance.object_pathed_filename MATCHES "*o.w" THEN CHR(3) + "DBAWARE" ELSE ""),
                       INPUT  FRAME {&FRAME-NAME}:HANDLE,
                       INPUT  tt_object_instance.instance_attribute_list,
                       OUTPUT lv_object_handle).
  /* keep ordered list of objects constructed on container */
  IF VALID-HANDLE(lv_object_handle) THEN
    ASSIGN 
      gcObjectHandles = gcObjectHandles + (IF gcObjectHandles <> "":U THEN ",":U ELSE "":U) +
                       STRING(lv_object_handle).
  IF VALID-HANDLE(lv_object_handle)
  AND INDEX(lv_object_handle:FILE-NAME, "dyntool":U) <> 0 THEN
    ASSIGN 
      gcToolbarHandles = gcToolbarHandles + (IF gcToolbarHandles <> "":U THEN ",":U ELSE "":U) +
                       STRING(lv_object_handle).
  IF VALID-HANDLE(lv_object_handle) AND tt_object_instance.custom_super_procedure <> "":U THEN DO:
    {launch.i &PLIP = tt_object_instance.custom_super_procedure &OnApp = 'NO' &Iproc = '' &NewInstance = YES}
    IF VALID-HANDLE(hPlip) THEN
    DO:
       lv_object_handle:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).       
       ASSIGN tt_object_instance.custom_super_handle = hPlip
              tt_object_instance.destroy_custom_super = TRUE.

    END.
  END.
  
  IF VALID-HANDLE(lv_object_handle) THEN
  DO:
    ASSIGN tt_object_instance.object_instance_handle = lv_object_handle.
  END.
  ELSE
  DO:
    ASSIGN
        tt_object_instance.object_instance_handle = ?
        tt_object_instance.object_frame_handle = ?.           
  END.

  /* update page instance temp-table with correct handle */
  FOR EACH tt_page_instance
     WHERE tt_page_instance.OBJECT_instance_obj = tt_object_instance.OBJECT_instance_obj:
    ASSIGN
        tt_page_instance.OBJECT_instance_handle = tt_object_instance.OBJECT_instance_handle
        tt_page_instance.OBJECT_type_code = tt_object_instance.OBJECT_type_code.
  END. /* FOR EACH tt_page_instance */


END. /* FOR EACH tt_object_instance on page */

/* Add links between objects that are now valid handles and for which the links do not yet exist */    
FOR EACH tt_link
   WHERE tt_link.link_created = NO :
    FIND FIRST tt_source_object_instance
        WHERE tt_source_object_instance.object_instance_obj = tt_link.source_object_instance_obj NO-ERROR.

    FIND FIRST tt_target_object_instance
        WHERE tt_target_object_instance.object_instance_obj = tt_link.target_object_instance_obj NO-ERROR.

    hSourceObject = (IF AVAILABLE tt_source_object_instance AND tt_link.source_object_instance_obj > 0 THEN tt_source_object_instance.object_instance_handle
        ELSE THIS-PROCEDURE).
    hTargetObject = (IF AVAILABLE tt_target_object_instance AND tt_link.target_object_instance_obj > 0 THEN tt_target_object_instance.object_instance_handle
        ELSE THIS-PROCEDURE).

    IF VALID-HANDLE(hSourceObject) AND VALID-HANDLE(hTargetObject) THEN
    DO:
      RUN addLink(hSourceObject, tt_link.link_name, hTargetObject).
      ASSIGN tt_link.link_created = YES.    
    END.
END. /* FOR EACH tt_link */

{get DataTarget cDataTargets}.
{get SdoForeignFields cSdoForeignFields}.

IF cSdoForeignFields <> "" THEN DO:   
    DO iEntry = 1 TO NUM-ENTRIES(cDataTargets):
        hDataTarget = WIDGET-HANDLE(ENTRY(iEntry,cDataTargets)).
        
        IF LOOKUP("setForeignFields", hDataTarget:INTERNAL-ENTRIES) <> 0 THEN DO: 
    
            DYNAMIC-FUNCTION('setForeignFields' IN hDataTarget, cSdoForeignFields).                                             
        END.
    END.
END.

IF iCurrentPage = 0 THEN
DO:
  IF glMenuController THEN
  DO:
    ASSIGN
        gdMinimumWindowWidth = 84.4
        gdMinimumWindowHeight = 2.38                  
        gdMaximumWindowWidth = SESSION:WIDTH - 1
        gdMaximumWindowHeight = 2.38.                  
  END.
  ELSE DO:
    ASSIGN 
        gdMinimumWindowWidth = 81
        gdMinimumWindowHeight = 10.14                  
        gdMaximumWindowWidth = SESSION:WIDTH - 1
        gdMaximumWindowHeight = SESSION:HEIGHT - 1.                  
  END.

  {&WINDOW-NAME}:MIN-WIDTH-CHARS =  gdMinimumWindowWidth.
  {&WINDOW-NAME}:MIN-HEIGHT-CHARS =  gdMinimumWindowHeight.
  {&WINDOW-NAME}:WIDTH-CHARS =  gdMinimumWindowWidth.
  {&WINDOW-NAME}:HEIGHT-CHARS =  gdMinimumWindowHeight.
END.

IF glSaveWindowPos = ? THEN /* do once */
DO:
  RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                           INPUT "SaveSizPos":U,
                                           INPUT "SaveSizPos":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rProfileRid,
                                           OUTPUT cProfileData).
  ASSIGN
      glSaveWindowPos = cProfileData <> "NO":U.

  IF glSaveWindowPos THEN
  DO:
    ASSIGN
      cObjectName  = getLogicalObjectName()
      cProfileData = "":U
      rProfileRid  = ?.
    
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code                            */
                                             INPUT "SizePos":U,         /* Profile code                                 */
                                             INPUT cObjectName,         /* Profile data key                             */
                                             INPUT "NO":U,              /* Get next record flag                         */
                                             INPUT-OUTPUT rProfileRid,  /* Rowid of profile data                        */
                                             OUTPUT cProfileData).      /* Found profile data. Positions as follows:    */
                                                                        /* 1 = col,         2 = row,                    */
                                                                        /* 3 = width chars, 4 = height chars            */
  END. 
  ELSE ASSIGN cProfileData = "":U.

  IF NUM-ENTRIES(cProfileData, CHR(3)) = 4 THEN
  DO:
    DEFINE VARIABLE cWidth      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cHeight     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cColumn     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRow        AS CHARACTER  NO-UNDO.

    ASSIGN
      glFoundSavedSize = YES

        /* Ensure that the values have the correct decimal points. 
         * These values are always stored using the American numeric format
         * ie. using a "." as decimal point.                               */
        cColumn = ENTRY(1, cProfileData, CHR(3))
        cColumn = REPLACE(cColumn, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

        cRow = ENTRY(2, cProfileData, CHR(3))
        cRow = REPLACE(cRow, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

        cWidth = ENTRY(3, cProfileData, CHR(3))
        cWidth = REPLACE(cWidth, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

        cHeight = ENTRY(4, cProfileData, CHR(3))
        cHeight = REPLACE(cHeight, ".":U, SESSION:NUMERIC-DECIMAL-POINT)        
      .
    ASSIGN
      gdSavedWidth = DECIMAL(cWidth)
      gdSavedHeight = DECIMAL(cHeight)
      gdSavedColumn = DECIMAL(cColumn)
      gdSavedRow = DECIMAL(cRow)
      NO-ERROR.   
  END. 
  ELSE
    ASSIGN
        gdSavedWidth = ?
        gdSavedHeight = ?
        gdSavedColumn = ?
        gdSavedRow = ?
        .    
END. /* getting saved size and position */

/* Work out new min sizes to ensure the contents of this page fit onto the
   folder. Do not do this for page 0 if the start page is > 0 as the work will
   just be duplicated.
*/
IF NOT(iCurrentPage = 0 AND iStartPage > 0) THEN
DO:
    RUN packWindow IN THIS-PROCEDURE (INPUT iCurrentPage, INPUT NOT(glFoundSavedSize)) NO-ERROR.

    IF RETURN-VALUE NE "":U THEN
        ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = "ForcedExit":U + CHR(3) + RETURN-VALUE.

    /* save off new minimums and maximums */
    ASSIGN gdMinimumWindowWidth = {&WINDOW-NAME}:MIN-WIDTH-CHARS
           gdMinimumWindowHeight = {&WINDOW-NAME}:MIN-HEIGHT-CHARS
           gdMaximumWindowWidth = {&WINDOW-NAME}:MAX-WIDTH-CHARS
           gdMaximumWindowHeight = {&WINDOW-NAME}:MAX-HEIGHT-CHARS
           .
END.

/* if on 0, init other initial pages */
IF iCurrentPage = 0 AND iStartPage > 0 THEN
DO:
    ASSIGN
      cInitPages = "":U
      .
    page-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cInitialPageList):
      ASSIGN iEntry = INTEGER(ENTRY(iLoop, cInitialPageList)) NO-ERROR.
      IF ERROR-STATUS:ERROR OR iEntry = 0 THEN NEXT page-loop.
      ASSIGN
        cInitPages = cInitPages + (IF cInitPages = "":U THEN "":U ELSE ",":U) + STRING(iEntry)
        giResizeOnPage = iEntry. /* ensure only resize on last page being initialized */
        .
    END.
    IF LOOKUP(STRING(iStartPage),cInitPages) = 0 THEN
      ASSIGN giResizeOnPage = iStartPage. /* start page not in list so resize on start page */
    IF cInitPages <> "":U THEN RUN initPages(cInitPages).
END.

IF iCurrentPage > 0 THEN DO:
   /* Build string 'cPageLinkList' containing delimited list of pages that 
   are dependent on the current page, then run initpages */
    RUN BuildPageLinks (INPUT  iCurrentPage,
                        OUTPUT cPageLinkList).
    ASSIGN gcPageLinkList = gcPageLinkList + (IF cPageLinkList = "" THEN "" ELSE ",") + cPageLinkList.

    IF cPageLinkList <> "":U THEN RUN initPages(cPageLinkList).
END.

/* resize if on resize page or dimensions now too small */
IF iCurrentPage = giResizeOnPage
                   OR {&WINDOW-NAME}:MIN-WIDTH-CHARS > {&WINDOW-NAME}:WIDTH-CHARS 
                   OR {&WINDOW-NAME}:MIN-HEIGHT-CHARS > {&WINDOW-NAME}:HEIGHT-CHARS THEN
DO:
  IF glFoundSavedSize THEN
  DO:
  
    /* avoid re-move */
    IF iCurrentPage <> giResizeOnPage THEN
      ASSIGN
        gdSavedColumn = {&WINDOW-NAME}:COLUMN
        gdSavedRow = {&WINDOW-NAME}:ROW
        .  
    
    ASSIGN
        FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
        {&WINDOW-NAME}:WIDTH-CHARS  = MIN(MAX(gdSavedWidth, {&WINDOW-NAME}:MIN-WIDTH-CHARS), 
                                           (SESSION:WIDTH-CHARS - 2.5))
        {&WINDOW-NAME}:HEIGHT-CHARS = MIN(MAX(gdSavedHeight, ({&WINDOW-NAME}:MIN-HEIGHT-CHARS)),({&WINDOW-NAME}:MAX-HEIGHT-CHARS),
                                           (SESSION:HEIGHT-CHARS - 2))
        .
    
    ASSIGN
        {&WINDOW-NAME}:COLUMN        = IF (gdSavedColumn + {&WINDOW-NAME}:WIDTH-CHARS) >= SESSION:WIDTH-CHARS THEN
                                            MAX(SESSION:WIDTH-CHARS - {&WINDOW-NAME}:WIDTH-CHARS, 1)
                                       ELSE IF gdSavedColumn < 0 THEN 1
                                       ELSE gdSavedColumn
        {&WINDOW-NAME}:ROW           = IF (gdSavedRow + {&WINDOW-NAME}:HEIGHT-CHARS) >= SESSION:HEIGHT-CHARS THEN
                                            MAX(SESSION:HEIGHT-CHARS - {&WINDOW-NAME}:HEIGHT-CHARS - 1.5, 1)
                                       ELSE IF gdSavedRow < 0 THEN 1
                                       ELSE gdSavedRow
        FRAME {&FRAME-NAME}:WIDTH = {&WINDOW-NAME}:WIDTH
        FRAME {&FRAME-NAME}:HEIGHT = {&WINDOW-NAME}:HEIGHT
        FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = {&WINDOW-NAME}:WIDTH
        FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
        FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
        gdSavedColumn = {&WINDOW-NAME}:COLUMN
        gdSavedRow = {&WINDOW-NAME}:ROW
        .                                                  
    IF LOOKUP(string(iCurrentPage),gcPageLinkList) = 0  THEN DO: /* Added check to not run if page being init is a linked page */
      APPLY "window-resized":u TO {&WINDOW-NAME}.
      ASSIGN lResized = YES.
  END.
  END.
  ELSE IF glMenuController AND iCurrentPage = iStartPage THEN
  DO:        
    ASSIGN
        FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
        {&WINDOW-NAME}:ROW = 1
        {&WINDOW-NAME}:COL = 1
        {&WINDOW-NAME}:MIN-WIDTH-CHARS = gdMinimumWindowWidth
        {&WINDOW-NAME}:WIDTH-CHARS = gdMaximumWindowWidth
        {&WINDOW-NAME}:MIN-HEIGHT-CHARS = gdMinimumWindowHeight
        {&WINDOW-NAME}:MAX-HEIGHT-CHARS = gdMaximumWindowHeight
        FRAME {&FRAME-NAME}:WIDTH = {&WINDOW-NAME}:WIDTH
        FRAME {&FRAME-NAME}:HEIGHT = {&WINDOW-NAME}:HEIGHT
        FRAME {&FRAME-NAME}:VIRTUAL-WIDTH = {&WINDOW-NAME}:WIDTH
        FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
        FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
        .
    IF LOOKUP(string(iCurrentPage),gcPageLinkList) = 0  THEN DO: /* Added check to not run if page being init is a linked page */
      APPLY "window-resized":u TO {&WINDOW-NAME}.
      ASSIGN lResized = YES.
    END.
  END.
END.

/* finish off by resetting frame's virtual dimensions */
ASSIGN
    FRAME {&FRAME-NAME}:SCROLLABLE     = TRUE
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH  = {&WINDOW-NAME}:WIDTH
    FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = {&WINDOW-NAME}:HEIGHT
    FRAME {&FRAME-NAME}:SCROLLABLE     = FALSE
    .
/* if on 0, select start page */
IF iCurrentPage = 0 AND iStartPage > 0 THEN
DO:
  RUN selectPage(iStartPage).
END.
ELSE IF NOT lResized THEN 
DO:
  IF LOOKUP(string(iCurrentPage),gcPageLinkList) = 0  THEN  /* Added check to not run if page being init is a linked page */ 
    APPLY "window-resized":u TO {&WINDOW-NAME}.  /* position objects correctly */
  IF (({&WINDOW-NAME}:COLUMN + {&WINDOW-NAME}:WIDTH-CHARS) >= SESSION:WIDTH-CHARS)THEN
    ASSIGN
      {&WINDOW-NAME}:COLUMN        = MAX(SESSION:WIDTH-CHARS - {&WINDOW-NAME}:WIDTH-CHARS, 1)
      .
  IF (({&WINDOW-NAME}:ROW + {&WINDOW-NAME}:HEIGHT-CHARS) >= SESSION:HEIGHT-CHARS) THEN
    ASSIGN
      {&WINDOW-NAME}:ROW           = MAX(SESSION:HEIGHT-CHARS - {&WINDOW-NAME}:HEIGHT-CHARS - 1.5, 1)
      .
END.

ERROR-STATUS:ERROR = NO.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Override to delete custom super procedures   
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
   RUN SUPER.
   FOR EACH tt_object_instance WHERE tt_object_instance.destroy_custom_super = TRUE:
      DELETE OBJECT tt_object_instance.custom_super_handle NO-ERROR. 
   END.
END PROCEDURE.

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
  Purpose:     Call from initializeObject to do createObjects for page 0.
  Parameters:  <none>
  Notes:       Do NOT remove this procedure as the session manager looks for
               it and this is how the pass through links work - I know, I spent
               3 hours trying to fix things after removing this procedure !!
------------------------------------------------------------------------------*/
    IF glOnceOnlyDone THEN RETURN.

    RUN createObjects. 
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
  VIEW FRAME fMain IN WINDOW wWin.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  IF glInitialised THEN RETURN.
  glInitialised = TRUE.
  
  DEFINE VARIABLE iCurrentPageNumber  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSavedContainerMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerToolbar   AS HANDLE     NO-UNDO.

  /* retrieve container mode set already, i.e. from where window was launched from
     and before initializeobject was run. If a mode is retrieved here, we will not
     overwrite it with the default mode from the object properties.
  */
  gcContainerMode = getContainerMode().
    /* Do initial run of createObjects for page 0 */
    IF NOT glOnceOnlyDone THEN
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
    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'RY' '11'},
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

  /* check forced exit of the dynamic container */    
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

  {get ToolbarSource hContainerToolbar}.

  IF VALID-HANDLE (hContainerToolbar) THEN
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
          WHEN "Copy"   THEN PUBLISH 'copyRecord' FROM hContainerToolbar.
          WHEN "Add"    THEN PUBLISH 'addRecord'  FROM hContainerToolbar.
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
  
  /* end of initialization - now turn off data links */

  PUBLISH 'ToggleData' (INPUT FALSE).
  
  /* calculate window width */
  DEFINE VARIABLE hMenuBar AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSubMenu AS HANDLE NO-UNDO.
  DEFINE VARIABLE dTextWidth AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dTotalTextWidth AS DECIMAL NO-UNDO.
  DEFINE VARIABLE iMenus AS INTEGER NO-UNDO.
  DEFINE VARIABLE dMenuControllerWidth AS DECIMAL NO-UNDO.
  {&WINDOW-NAME}:VISIBLE = TRUE.

/*  PROCESS EVENTS. I'm removing this statement due to Issue #3333 and #3641 loged on issuezilla */

  /* calculate the menu width */
  hMenuBar = {&WINDOW-NAME}:MENU-BAR NO-ERROR.
  
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

  RUN applyEntry(?).

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
    RUN initializeObject IN hHandle.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindow wWin 
PROCEDURE packWindow :
/*------------------------------------------------------------------------------
  Purpose:     To work out new minimum window dimensions according to contents
  Parameters:  input current page number, 
               input resize flag
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER piPage   AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER plResize AS LOGICAL NO-UNDO.

DEFINE VARIABLE lv_layout_code  AS CHARACTER.
DEFINE VARIABLE hPageInstanceTT AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageTT         AS HANDLE NO-UNDO.

    {get Page0LayoutManager lv_layout_code}.

    hPageInstanceTT = TEMP-TABLE tt_page_instance:HANDLE.
    hPageTT         = TEMP-TABLE tt_page:HANDLE.

    RUN packWindow IN gsh_LayoutManager (
        INPUT piPage,
        INPUT lv_layout_code,
        INPUT hPageInstanceTT:DEFAULT-BUFFER-HANDLE,
        INPUT hPageTT:DEFAULT-BUFFER-HANDLE,
        INPUT {&WINDOW-NAME}, 
        INPUT FRAME {&FRAME-NAME}:HANDLE,
        INPUT gdMinimumWindowWidth,
        INPUT gdMinimumWindowHeight,
        INPUT gdMaximumWindowWidth,
        INPUT gdMaximumWindowHeight,
        INPUT plResize
        ).  
    
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

DEFINE VARIABLE lv_layout_code  AS CHARACTER.
DEFINE VARIABLE hPageInstanceTT AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageTT         AS HANDLE NO-UNDO.  
                                               
    {get Page0LayoutManager lv_layout_code}.                                               
    
    hPageInstanceTT = TEMP-TABLE tt_page_instance:HANDLE.
    hPageTT         = TEMP-TABLE tt_page:HANDLE.
    PUBLISH "windowToBeSized":U FROM THIS-PROCEDURE.
    RUN resizeWindow IN gsh_LayoutManager (
        INPUT lv_layout_code,
        INPUT hPageInstanceTT:DEFAULT-BUFFER-HANDLE,
        INPUT hPageTT:DEFAULT-BUFFER-HANDLE,
        INPUT {&WINDOW-NAME}, 
        INPUT FRAME {&FRAME-NAME}:HANDLE
        ).  
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
        MESSAGE hdl:TYPE.
        hdl = hdl:FIRST-CHILD.       
    END.
                                 
  RETURN FRAME_handle.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {&WINDOW-NAME}:TITLE.   /* Function return value. */

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

   
   {&WINDOW-NAME}:TITLE = pcWindowName.                             
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

