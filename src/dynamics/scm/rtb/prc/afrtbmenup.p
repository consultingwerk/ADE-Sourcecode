&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
  File: afrtbmenup.p

  Description:  Add Dynamics SCM options to RTB menu

  Purpose:      Add Dynamics SCM to RTB menu

  Parameters:   input rtb main procedure handle

  History:
  --------
  (v:010006)    Task:    90000000   UserRef:    
                Date:   15/02/2002  Author:     Pieter Meyer

  Update Notes: Revise Menu options

  (v:010003)    Task:    90000024   UserRef:    
                Date:   02/20/2002  Author:     Dynamics Admin User

  Update Notes: 

  (v:010000)    Task:    90000007   UserRef:    
                Date:   02/26/2002  Author:     Dynamics Admin User

  Update Notes: 

  (v:010001)    Task:    90000010   UserRef:    
                Date:   03/04/2002  Author:     Dynamics Admin User

  Update Notes: 

  (v:020000)    Task:          49   UserRef:    
                Date:   06/18/2003  Author:     Thomas Hansen

  Update Notes: Create maintenace tool for SCM tool

  (v:020001)    Task:          59   UserRef:    
                Date:   09/01/2003  Author:     Thomas Hansen

  Update Notes: Set product maintenance back to product control

------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbmenup.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    020001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER hRtbProc AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gshRepositoryManager  AS HANDLE       NO-UNDO.

DEFINE TEMP-TABLE ttMenuItem       NO-UNDO
            FIELD tiMenuItemSeq     AS INTEGER
            FIELD tcMenuItemType    AS CHARACTER
            FIELD tcMenuItemLabel   AS CHARACTER
            FIELD tcMenuItemStatic  AS CHARACTER
            FIELD tcMenuItemLogical AS CHARACTER
            INDEX tIndexSeq         IS PRIMARY
                  tiMenuItemSeq     ASCENDING
            .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnAddMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAddMenuItem Procedure 
FUNCTION fnAddMenuItem RETURNS LOGICAL
  (piMenuItemSeq     AS INTEGER
  ,pcMenuItemLabel   AS CHARACTER
  ,pcMenuItemType    AS CHARACTER
  ,pcMenuItemStatic  AS CHARACTER
  ,pcMenuItemLogical AS CHARACTER
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.43
         WIDTH              = 50.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE lICFIsRunning           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMenuWhere              AS CHARACTER  NO-UNDO. /* TOOL / MAIN */

DEFINE VARIABLE cWidgetPool             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabelTool              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabelDynamics          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabelRuler             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPrefixPData            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPrefixName             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hWindow                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTopMenu                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hToolSubMenu            AS HANDLE     NO-UNDO.

DEFINE VARIABLE hDynamicsRuler          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDynamicsSubMenu        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDynamicsMenuItem       AS HANDLE     NO-UNDO.

DEFINE VARIABLE cFileChoose             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileSearch             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hLoopHandle AS HANDLE   NO-UNDO.
DEFINE VARIABLE hXMLConfMan AS HANDLE   NO-UNDO.

/* Get the handle of the Configuration Manager if possible. 

   This is needed for calls to isICFRunning, which gives errors
   if we use it without the manager running
*/
ASSIGN
  hLoopHandle = SESSION:FIRST-PROCEDURE.

DO WHILE VALID-HANDLE(hLoopHandle):
  IF NOT VALID-HANDLE(hXMLConfMan) AND
     (R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0 OR 
      R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0)
  THEN
    ASSIGN hXMLConfMan = hLoopHandle.

  IF  VALID-HANDLE(hXMLConfMan) THEN 
    ASSIGN hLoopHandle = ?.
  ELSE
    ASSIGN hLoopHandle = hLoopHandle:NEXT-SIBLING.
END.

/* If ROUNDTABLE HANDLE Grtb-proc-handle is invalid RETURN */
IF NOT VALID-HANDLE(hRtbProc)
THEN RETURN.

IF hRtbProc:TYPE <> "Window":U
THEN /* RTB */
  ASSIGN
    cWidgetPool     = "Desktop_menu_items":U
    hWindow         = hRtbProc:CURRENT-WINDOW
    cLabelTool      = "&Tool":U
    cLabelDynamics  = "Progress &Dynamics":U
    cLabelRuler     = "RULER 00":U
    cPrefixPData    = "pdDyn_":U
    cPrefixName     = "mnDyn_":U
    .
ELSE /* AB */
  RETURN.
  /*
  ASSIGN
    cWidgetPool     = "_ADE_AB-Main":U
    hWindow         = hRtbProc
    cLabelTool      = "&Tools":U
    cLabelDynamics  = "&Build":U
    cPrefixPData    = "pdDyn_":U
    cPrefixName     = "mnDyn_":U
    .
  */

ASSIGN
  hTopMenu          = hWindow:MENU-BAR
  hToolSubMenu      = ?
  hDynamicsRuler    = ?
  hDynamicsSubMenu  = ?
  hDynamicsMenuItem = ?
  NO-ERROR.

/* If the MENUBAR is not available then RETURN */
IF NOT VALID-HANDLE(hTopMenu)
THEN RETURN.

/* Running with a valid environment - Continue */

/* Function    Seq  Label                                     Type          Static                       Logical        */               
fnAddMenuItem( 01 , "Administration...":U                  , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "afallmencw":U).
fnAddMenuItem( 02 , "Development...":U                     , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "rywizmencw":U).
fnAddMenuItem( 10 , "RULER 10":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 11 , "Repository Maintenance...":U          , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "rycsotreew":U).
fnAddMenuItem( 12 , "Object Type Control...":U             , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "gscottreew":U).
fnAddMenuItem( 13 , "Product Control...":U                 , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "gscprobjcw":U).
fnAddMenuItem( 20 , "RULER 20":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 21 , "XML Export...":U                      , "STATIC":U  , "rtb/uib/ryxmldumpw.w":U   , "":U).
fnAddMenuItem( 22 , "XML Import...":U                      , "STATIC":U  , "rtb/uib/ryxmlloadw.w":U   , "":U).
fnAddMenuItem( 30 , "RULER 30":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 31 , "Dataset Export...":U                  , "LOGICAL":U  , "ry/prc/rycsolnchp.p":U    , "gscddexprtw":U).
fnAddMenuItem( 32 , "Dataset Import...":U                  , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "gscddimpcw":U ).
/*
fnAddMenuItem( 33 , "Dataset Conflict Resolution...":U     , "STATIC":U  , "af/obj2/gscddconflict.w":U, "":U).
*/
fnAddMenuItem( 40 , "RULER 40":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 41 , 'Clear "ActionUnderway" Records ...':U , "STATIC":U  , "ry/prc/ryclractup.p":U    , "":U).
fnAddMenuItem( 50 , "RULER 50":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 51 , "&Compile Import Table...":U           , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "rtb/uib/rtbimportcompilew":U).
fnAddMenuItem( 52 , "&Compile Objects in Directory...":U   , "LOGICAL":U , "ry/prc/rycsolnchp.p":U    , "ry/uib/ryoscompilew":U).
/*
fnAddMenuItem( 60 , "RULER 60":U                           ,"RULE":U     , "":U                       , "":U).
fnAddMenuItem( 61 , "&Compile / Update Appserver(s)...":U  ,"STATIC":U   , "rtb/uib/afoascopyw.w":U   , "":U).
*/
fnAddMenuItem( 70 , "RULER 70":U                           , "RULE":U    , "":U                       , "":U).
fnAddMenuItem( 71 , "Dynamics Configuration Utility (DCU)...":U          , "STATIC":U  , "icfcfg.w":U , "":U).

ASSIGN
  lICFIsRunning = NO
  cMenuWhere    = "":U
  .

/* Check if Dynamics is running. 
   This call should only be made if the conFiguration Manager is running. If it 
   isn't, then we get errors when this function call is made
*/
IF VALID-HANDLE(hXMLConfMan) THEN
 lICFIsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN hXMLConfMan) NO-ERROR. 

/* Only change the value of lICFIsRunning if this is set to ? */
IF lICFIsRunning = ? THEN
  lICFIsRunning = NO.
ERROR-STATUS:ERROR = NO.

/* TO DO: function (getPropertyList) to retrieve value for cMenuWhere if set */
IF   cMenuWhere = "":U
THEN cMenuWhere = "TOOL":U.
ERROR-STATUS:ERROR = NO.

IF LOOKUP(cMenuWhere,"MAIN,TOOL":U) = 0
THEN RETURN.

IF cMenuWhere = "MAIN":U
THEN DO:

  /* Find the Dynamics Sub-Menu */
  RUN findMenuItem IN TARGET-PROCEDURE
                  (INPUT "SUB-MENU":U
                  ,INPUT cLabelDynamics
                  ,INPUT cPrefixPData + cLabelDynamics
                  ,INPUT hTopMenu:FIRST-CHILD
                  ,INPUT NO
                  ,INPUT-OUTPUT hDynamicsSubMenu
                  ).

END.
ELSE
IF cMenuWhere = "TOOL":U
THEN DO:

  /* Find the Tools Sub-Menu */
  RUN findMenuItem IN TARGET-PROCEDURE
                  (INPUT "SUB-MENU":U
                  ,INPUT cLabelTool
                  ,INPUT cPrefixPData + cLabelTool
                  ,INPUT hTopMenu:FIRST-CHILD
                  ,INPUT NO
                  ,INPUT-OUTPUT hToolSubMenu
                  ).
  IF NOT VALID-HANDLE(hToolSubMenu)
  THEN RETURN.

  /* Find the Dynamics added Ruler */
  RUN findMenuItem IN TARGET-PROCEDURE
                  (INPUT "MENU-ITEM":U
                  ,INPUT "":U
                  ,INPUT cPrefixPData + cLabelRuler
                  ,INPUT hTopMenu:FIRST-CHILD
                  ,INPUT YES
                  ,INPUT-OUTPUT hDynamicsRuler
                  ).

  /* Find the Dynamics added Sub-Menu */
  RUN findMenuItem IN TARGET-PROCEDURE
                  (INPUT "SUB-MENU":U
                  ,INPUT cLabelDynamics
                  ,INPUT cPrefixPData + cLabelDynamics
                  ,INPUT hTopMenu:FIRST-CHILD
                  ,INPUT YES
                  ,INPUT-OUTPUT hDynamicsSubMenu
                  ).

END.

IF VALID-HANDLE(hDynamicsSubMenu)
THEN DO:

  IF lICFIsRunning
  THEN
    ASSIGN
      hDynamicsSubMenu:SENSITIVE = YES.
  ELSE
    ASSIGN
      hDynamicsSubMenu:SENSITIVE = NO.

END.
ELSE DO:

  IF lICFIsRunning
  THEN DO:

    IF cMenuWhere = "MAIN":U
    THEN DO:

      CREATE SUB-MENU hDynamicsSubMenu IN WIDGET-POOL cWidgetPool
      ASSIGN
          NAME          = cPrefixName  + cLabelDynamics
          PARENT        = hTopMenu
          PRIVATE-DATA  = cPrefixPData + cLabelDynamics
          LABEL         = cLabelDynamics
          SENSITIVE     = YES
          .

      hWindow:WIDTH  = (hWindow:WIDTH + 10) NO-ERROR.

    END.
    ELSE
    IF cMenuWhere = "TOOL":U
    THEN DO:

      CREATE MENU-ITEM hDynamicsRuler  IN WIDGET-POOL cWidgetPool
        ASSIGN
          SUBTYPE       = "RULE":U
          PARENT        = hToolSubMenu
          PRIVATE-DATA  = cPrefixPData + cLabelRuler
          .

      CREATE SUB-MENU hDynamicsSubMenu IN WIDGET-POOL cWidgetPool
        ASSIGN
          NAME          = cPrefixName  + cLabelDynamics
          PARENT        = hToolSubMenu
          PRIVATE-DATA  = cPrefixPData + cLabelDynamics
          LABEL         = cLabelDynamics
          SENSITIVE     = YES
          .

    END.

  END.
  ELSE DO:
    /* Nothing should be done at this stage */
  END.

END.

blkMenuItem:
FOR EACH ttMenuItem NO-LOCK
  BY ttMenuItem.tiMenuItemSeq
  :

  ASSIGN
    hDynamicsMenuItem = ?.

  RUN findMenuItem IN TARGET-PROCEDURE
                  (INPUT "MENU-ITEM":U
                  ,INPUT ttMenuItem.tcMenuItemLabel
                  ,INPUT cPrefixPData + ttMenuItem.tcMenuItemLabel
                  ,INPUT hTopMenu:FIRST-CHILD
                  ,INPUT YES
                  ,INPUT-OUTPUT hDynamicsMenuItem
                  ).

  ASSIGN
    cFileChoose = "":U
    cFileSearch = ?
    .
  CASE ttMenuItem.tcMenuItemType:
    WHEN "RULE":U
      THEN DO:
        /* Nothing should be done for Rulers */
      END.
    WHEN "LOGICAL":U OR
    WHEN "STATIC":U
      THEN DO:
        ASSIGN
          cFileChoose = ttMenuItem.tcMenuItemStatic.
        ASSIGN
          cFileSearch = SEARCH(cFileChoose).
        IF cFileSearch = ?
        THEN
          ASSIGN
            cFileChoose = SUBSTRING(cFileChoose , 1 , R-INDEX(cFileChoose,".":U)) + "r":U
            cFileSearch = SEARCH(cFileChoose)
            .
      END.
  END CASE.

  IF VALID-HANDLE(hDynamicsMenuItem)
  THEN DO:

    IF lICFIsRunning
    THEN DO:
      CASE ttMenuItem.tcMenuItemType:
        WHEN "RULE":U
          THEN DO:
            /* Nothing should be done for Rulers */
          END.
        WHEN "LOGICAL":U OR
        WHEN "STATIC":U
          THEN DO:
            IF cFileSearch <> ?
            THEN
              ASSIGN
                hDynamicsMenuItem:SENSITIVE = YES.
            ELSE
              ASSIGN
                hDynamicsMenuItem:SENSITIVE = NO.
          END.
        OTHERWISE DO:
          ASSIGN
            hDynamicsMenuItem:SENSITIVE = NO.
        END.
      END CASE.
    END.
    ELSE DO:
      DELETE WIDGET hDynamicsMenuItem.
    END.

  END.
  ELSE DO:

    IF lICFIsRunning
    THEN DO:

      CASE ttMenuItem.tcMenuItemType:
        WHEN "RULE":U
          THEN DO:
            CREATE MENU-ITEM hDynamicsMenuItem IN WIDGET-POOL cWidgetPool
            ASSIGN
              SUBTYPE       = "RULE":U
              PARENT        = hDynamicsSubMenu
              PRIVATE-DATA  = cPrefixPData + ttMenuItem.tcMenuItemLabel
              .
          END.
        WHEN "LOGICAL":U
          THEN DO:
            CREATE MENU-ITEM hDynamicsMenuItem IN WIDGET-POOL cWidgetPool
            ASSIGN  
              PARENT        = hDynamicsSubMenu
              PRIVATE-DATA  = cPrefixPData + ttMenuItem.tcMenuItemLabel
              LABEL         = ttMenuItem.tcMenuItemLabel
              SENSITIVE     = (IF cFileSearch <> ? THEN YES ELSE NO)
            TRIGGERS:
              ON "CHOOSE" PERSISTENT RUN VALUE(ttMenuItem.tcMenuItemStatic) (INPUT ttMenuItem.tcMenuItemLogical , INPUT YES , INPUT YES ).
            END TRIGGERS.
          END.
        WHEN "STATIC":U
          THEN DO:
            CREATE MENU-ITEM hDynamicsMenuItem IN WIDGET-POOL cWidgetPool
            ASSIGN  
              PARENT        = hDynamicsSubMenu
              PRIVATE-DATA  = cPrefixPData + ttMenuItem.tcMenuItemLabel
              LABEL         = ttMenuItem.tcMenuItemLabel
              SENSITIVE     = (IF cFileSearch <> ? THEN YES ELSE NO)
            TRIGGERS:
              ON "CHOOSE" PERSISTENT RUN VALUE(ttMenuItem.tcMenuItemStatic).
            END TRIGGERS.
          END.
      END CASE.

    END.
    ELSE DO:
      NEXT blkMenuItem.
    END.

  END.

END.

IF NOT lICFIsRunning
THEN DO:

  IF VALID-HANDLE(hDynamicsSubMenu)
  THEN DO:

    DELETE WIDGET hDynamicsSubMenu.

    IF cMenuWhere = "MAIN":U
    THEN DO:
      hWindow:WIDTH  = (hWindow:WIDTH - 10) NO-ERROR.
    END.
    IF cMenuWhere = "TOOL":U
    THEN DO:
      IF VALID-HANDLE(hDynamicsRuler)
      THEN
        DELETE WIDGET hDynamicsRuler.
    END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-findMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMenuItem Procedure 
PROCEDURE findMenuItem :
/*------------------------------------------------------------------------------
  Purpose:     Recursive procedure to locate a menu item in a windows menu
  Parameters:  Input type of widget to locate (MENU-ITEM or SUB-MENU or blank for any)
               Input label of menu item to look for (& will be stripped)
               Input handle of menu item to start searching from
               Input whether to recurse all submenus
               Output handle of found menu item (if found)
  Notes:       To search whole menu, pass in start handle as windows menu-bar 
               first-child.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcType      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcLabel     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcPData     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  phStart     AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER  plRecurse   AS LOGICAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER phMenuItem  AS HANDLE NO-UNDO.

  DO WHILE VALID-HANDLE(phStart)
   AND NOT VALID-HANDLE(phMenuItem)
    :

    IF phStart:TYPE BEGINS pcType
    THEN DO:
/*
MESSAGE pcType " --> " phStart:TYPE
  SKIP pcLabel " --> " phStart:LABEL
  SKIP pcPData " --> " phStart:PRIVATE-DATA
  SKIP plRecurse
  VIEW-AS ALERT-BOX INFORMATION.
*/
      IF REPLACE(phStart:LABEL,"&":U,"":U) = REPLACE(pcLabel,"&":U,"":U)
      THEN DO: /* found it */
        ASSIGN
          phMenuItem = phStart.
        RETURN.
      END.
      ELSE
      IF pcPData <> "":U
      AND REPLACE(phStart:PRIVATE-DATA,"&":U,"":U) = REPLACE(pcPData,"&":U,"":U)
      THEN DO: /* found it */
        ASSIGN
          phMenuItem = phStart.
        RETURN.
      END.
    END.

    IF plRecurse = YES
    AND phStart:TYPE = "SUB-MENU":U
    AND VALID-HANDLE(phStart:FIRST-CHILD)
    THEN DO:
      RUN findMenuItem IN TARGET-PROCEDURE
                      (INPUT pcType
                      ,INPUT pcLabel
                      ,INPUT pcPData
                      ,INPUT phStart:FIRST-CHILD
                      ,INPUT plRecurse
                      ,INPUT-OUTPUT phMenuItem
                      ).
    END.

    /* move onto next item */
    IF phMenuItem = ?
    THEN
      ASSIGN
        phStart = phStart:NEXT-SIBLING.
    ELSE
      RETURN.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnAddMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAddMenuItem Procedure 
FUNCTION fnAddMenuItem RETURNS LOGICAL
  (piMenuItemSeq     AS INTEGER
  ,pcMenuItemLabel   AS CHARACTER
  ,pcMenuItemType    AS CHARACTER
  ,pcMenuItemStatic  AS CHARACTER
  ,pcMenuItemLogical AS CHARACTER
  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  plAction          - ADD or DEL
            piMenuItemSeq     - The default sequence. If already in use the sequence will be increased.
            pcMenuItemType    - STATIC or LOGICAL
            pcMenuItemLabel   - Menu Item Label
            pcMenuItemStatic  - The choose triggers static object name that will be run.
            pcMenuItemStatic  - The choose triggers logical object name.
------------------------------------------------------------------------------*/

  IF piMenuItemSeq < 1
  THEN DO:

    FIND LAST ttMenuItem NO-LOCK NO-ERROR.
    IF AVAILABLE ttMenuItem
    THEN
      ASSIGN
        piMenuItemSeq = ttMenuItem.tiMenuItemSeq + 1.
    ELSE
      ASSIGN
        piMenuItemSeq = 1.

  END.

  blkFindSeq:
  REPEAT:
    IF CAN-FIND(FIRST ttMenuItem
                WHERE ttMenuItem.tiMenuItemSeq = piMenuItemSeq
                )
    THEN ASSIGN piMenuItemSeq = piMenuItemSeq + 1.
    ELSE LEAVE blkFindSeq.
  END.

  CREATE ttMenuItem.
  ASSIGN
    ttMenuItem.tiMenuItemSeq      = piMenuItemSeq
    ttMenuItem.tcMenuItemType     = pcMenuItemType
    ttMenuItem.tcMenuItemLabel    = pcMenuItemLabel
    ttMenuItem.tcMenuItemStatic   = pcMenuItemStatic
    ttMenuItem.tcMenuItemLogical  = pcMenuItemLogical
    .

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


