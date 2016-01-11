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

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbmenup.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER hRtbProc AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 6.76
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hWindow                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hMenuBar                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSubMenu                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hMenu                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hToolSubMenu            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDynamicsSubMenu        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWidgetPool             AS CHARACTER  NO-UNDO.

IF NOT VALID-HANDLE(hRtbProc)
THEN RETURN.

ASSIGN
  hWindow           = IF hRtbProc:TYPE <> "WINDOW":U 
                      THEN hRtbProc:CURRENT-WINDOW  /* RoundTable */
                      ELSE hRtbProc                 /* AppBuilder */
  hMenuBar          = hWindow:MENU-BAR
  hDynamicsSubMenu  = ?
  hToolSubMenu      = ?
  cWidgetPool       = IF hRtbProc:TYPE <> "Window":U
                      THEN "Desktop_menu_items":U   /* RoundTable */
                      ELSE "_ADE_AB-Main":U         /* AppBuilder */
  NO-ERROR
  .

IF NOT VALID-HANDLE(hMenuBar)
THEN RETURN.

/* Ensure only added once */
RUN findMenuItem IN TARGET-PROCEDURE
                (INPUT "sub-menu":U
                ,INPUT "&Dynamics":U
                ,INPUT hMenuBar:FIRST-CHILD
                ,INPUT YES
                ,INPUT-OUTPUT hDynamicsSubMenu
                ).

IF VALID-HANDLE(hDynamicsSubMenu)
THEN RETURN.

/* Add Astra submenu to tools menu */
RUN findMenuItem IN TARGET-PROCEDURE
                (INPUT "sub-menu":U
                ,INPUT (IF hRtbProc:TYPE <> "Window":U THEN "&Tool" /* RTB */ ELSE "&Tools":U /* AB */ )
                ,INPUT hMenuBar:FIRST-CHILD
                ,INPUT NO
                ,INPUT-OUTPUT hToolSubMenu
                ).

IF NOT VALID-HANDLE(hToolSubMenu)
THEN RETURN.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
  ASSIGN
    SUBTYPE = 'RULE':U
    PRIVATE-DATA = "ICF":U
    PARENT  = hToolSubMenu.

CREATE SUB-MENU hDynamicsSubMenu IN WIDGET-POOL cWidgetPool
    ASSIGN
        LABEL         = "&Dynamics":U
        PRIVATE-DATA  = "ICF":U
        NAME          = "m_ICF":U
        PARENT        = hToolSubMenu.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "XML Export...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN rtb/uib/ryxmldumpw.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "XML Import...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN rtb/uib/ryxmlloadw.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
  ASSIGN
    SUBTYPE      = 'RULE':U
    PRIVATE-DATA = "ICF":U
    PARENT       = hDynamicsSubMenu.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "Dataset Export...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN af/obj2/gscddexport.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "Dataset Import...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN af/obj2/gscddimport.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "Dataset Conflict Resolution...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN af/obj2/gscddconflict.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
  ASSIGN
    SUBTYPE      = 'RULE':U
    PRIVATE-DATA = "ICF":U
    PARENT       = hDynamicsSubMenu.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = 'Clear "ActionUnderway" Records ...':U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN ry/prc/ryclractup.p.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
  ASSIGN
    SUBTYPE      = 'RULE':U
    PRIVATE-DATA = "ICF":U
    PARENT       = hDynamicsSubMenu.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "&Compile Import Table...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN rtb/uib/afrtbcompw.w.
END.

CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "&Compile Task Directory...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN af/cod/afcompile.w.
END.

/*
CREATE MENU-ITEM hMenu IN WIDGET-POOL cWidgetPool
ASSIGN  
  LABEL         = "&Compile / Update Appserver(s)...":U
  PARENT        = hDynamicsSubMenu
  PRIVATE-DATA  = "ICF":U
  SENSITIVE     = YES
TRIGGERS:
  ON "CHOOSE" PERSISTENT RUN rtb/uib/afoascopyw.w.
END.
*/

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
  DEFINE INPUT PARAMETER  phStart     AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER  plRecurse   AS LOGICAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER phMenuItem  AS HANDLE NO-UNDO.

  DO WHILE VALID-HANDLE(phStart)
   AND NOT VALID-HANDLE(phMenuItem)
    :

    IF phStart:TYPE BEGINS pcType
    AND REPLACE(phStart:LABEL,"&":U,"":U) = REPLACE(pcLabel,"&":U,"":U)
    THEN DO: /* found it */
      ASSIGN
        phMenuItem = phStart.
      RETURN.
    END.

    IF plRecurse = YES
    AND phStart:TYPE = "sub-menu"
    AND VALID-HANDLE(phStart:FIRST-CHILD)
    THEN DO:
      RUN findMenuItem IN TARGET-PROCEDURE
                      (INPUT pcType
                      ,INPUT pcLabel
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

