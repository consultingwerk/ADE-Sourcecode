&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"The Dialog-Box for TableIO SmartPanels

This dialog-box is used to set the TableIO SmartPanel-specific attributes during design time."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SP-attr-dialog 
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

  File: u-paneld.w

  Description: ADM2 Dialog for getting setable attributes of a TableIO
               SmartPanel.

  Input Parameters:
      Handle of the calling SmartPanel.

  Output Parameters:
      <none>

  Modified:  July 12, 1998
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN  YES

DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE attr-list  AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE i          AS INTEGER NO-UNDO.
DEFINE VARIABLE entries    AS INTEGER NO-UNDO.

DEFINE VARIABLE gcActionGroups  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gcSupportedLinks AS CHARACTER NO-UNDO.

DEFINE VARIABLE cSubModules AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-SPtype AS CHARACTER NO-UNDO.

DEFINE VARIABLE cContext     AS CHAR   NO-UNDO.
DEFINE VARIABLE cSDO         AS CHAR   NO-UNDO.
DEFINE VARIABLE hNavTarget   AS HANDLE NO-UNDO.
DEFINE VARIABLE cObjectNames AS CHAR   NO-UNDO.
DEFINE VARIABLE cListItems   AS CHAR   NO-UNDO.
DEFINE VARIABLE lEnableSDOs  AS LOGICAL  NO-UNDO.

&SCOP OK btnOk 
&SCOP CANCEL btnCancel 
&SCOP HELP btnHelp

DEFINE TEMP-TABLE tAction  
 FIELD Name   AS CHAR
 FIELD Hdl AS HANDLE
 FIELD Sort1  AS INT
 FIELD Sort2  AS INT 
 FIELD Link   AS CHAR
 FIELD Menu   AS LOG
 FIELD Tool   AS LOG
 INDEX Sort AS PRIMARY sort1 sort2.

DEFINE TEMP-TABLE tPage
 FIELD PageNum AS INT FORMAT "ZZ9" LABEL "Page"
 FIELD Hdl     AS HANDLE
 FIELD Name    AS CHAR
 FIELD Caption AS CHAR FORMAT "X(255)"
 INDEX PageNum PageNum.

DEFINE QUERY qPage FOR tPage.

DEFINE BROWSE bPage QUERY qPage
  DISPLAY 
    tPage.PageNum   
    tPage.Caption WIDTH 40
    tPage.Name
  ENABLE
    tPAge.Caption
  WITH NO-ROW-MARKERS SEPARATORS 4 DOWN EXPANDABLE.
  
DEFINE FRAME {&FRAME-NAME}
     bPAge .

bPAge:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-Menu v-Toolbar v-show c_SDOList v-divider1 ~
v-divider2 
&Scoped-Define DISPLAYED-OBJECTS v-Menu v-Toolbar v-show v-type c_SDOLabel ~
c_SDOList v-divider1 v-divider2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initContents SP-attr-dialog 
FUNCTION initContents RETURNS LOGICAL
  (pcContents AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initPages SP-attr-dialog 
FUNCTION initPages RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectStates SP-attr-dialog 
FUNCTION setObjectStates RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_SDOList AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c_SDOLabel AS CHARACTER FORMAT "X(256)":U INITIAL "SmartDataObject:" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .76 NO-UNDO.

DEFINE VARIABLE v-divider1 AS CHARACTER FORMAT "X(75)":U INITIAL "Style" 
      VIEW-AS TEXT 
     SIZE 53 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider2 AS CHARACTER FORMAT "X(75)":U INITIAL "Contents" 
      VIEW-AS TEXT 
     SIZE 53 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-type AS CHARACTER INITIAL "Save" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&Save", "Save":U,
"&Update", "Update":U
     SIZE 22 BY .71 NO-UNDO.

DEFINE VARIABLE v-Menu AS LOGICAL INITIAL yes 
     LABEL "Menu" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Border" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE v-Toolbar AS LOGICAL INITIAL yes 
     LABEL "Toolbar" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     v-Menu AT ROW 2.43 COL 8
     v-Toolbar AT ROW 3.43 COL 8
     v-show AT ROW 4.43 COL 13.6
     v-type AT ROW 6.95 COL 13.6 NO-LABEL
     c_SDOLabel AT ROW 7.91 COL 3 COLON-ALIGNED NO-LABEL
     c_SDOList AT ROW 8.38 COL 22 COLON-ALIGNED NO-LABEL
     v-divider1 AT ROW 1.43 COL 1.8 NO-LABEL
     v-divider2 AT ROW 5.76 COL 1.8 NO-LABEL
     SPACE(1.39) SKIP(6.09)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartToolbar Properties".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SP-attr-dialog
                                                                        */
ASSIGN 
       FRAME SP-attr-dialog:SCROLLABLE       = FALSE
       FRAME SP-attr-dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c_SDOLabel IN FRAME SP-attr-dialog
   NO-ENABLE                                                            */
ASSIGN 
       c_SDOLabel:READ-ONLY IN FRAME SP-attr-dialog        = TRUE.

ASSIGN 
       c_SDOList:HIDDEN IN FRAME SP-attr-dialog           = TRUE.

/* SETTINGS FOR FILL-IN v-divider1 IN FRAME SP-attr-dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v-divider2 IN FRAME SP-attr-dialog
   ALIGN-L                                                              */
/* SETTINGS FOR RADIO-SET v-type IN FRAME SP-attr-dialog
   NO-ENABLE                                                            */
ASSIGN 
       v-type:HIDDEN IN FRAME SP-attr-dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON GO OF FRAME SP-attr-dialog /* SmartToolbar Properties */
DO:
  DEF VAR ok AS LOG.
  RUN supportLinks(OUTPUT ok).
  IF NOT ok THEN 
    RETURN NO-APPLY.
  
  ASSIGN 
    v-type
    v-menu
    v-show
    v-toolbar.
  
  {set TableioType v-type p_hSMO}.
  {set menu v-menu p_hSMO}.
  {set toolbar v-toolbar p_hSMO}.
  {set actionGroups gcActionGroups p_hSMO}. 
  {set ShowBorder v-show p_hSMO}.
  IF c_SDOList NE "<none>":U THEN
      {set NavigationTargetName c_SDOList p_hSMO}.

  RUN InitializeObject IN p_hSMO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* SmartToolbar Properties */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_SDOList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_SDOList SP-attr-dialog
ON VALUE-CHANGED OF c_SDOList IN FRAME SP-attr-dialog
DO:
  ASSIGN c_SDOList.
  /* Assign the handle of the SDO they chose */
/*   IF c_SDOList NE "":U THEN            */
/*       hSDO = WIDGET-HANDLE(c_SDOList). */
/*                                        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-Menu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-Menu SP-attr-dialog
ON VALUE-CHANGED OF v-Menu IN FRAME SP-attr-dialog /* Menu */
DO:
  IF NOT SELF:CHECKED THEN 
    v-toolbar:CHECKED = TRUE. 
  setObjectStates().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-Toolbar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-Toolbar SP-attr-dialog
ON VALUE-CHANGED OF v-Toolbar IN FRAME SP-attr-dialog /* Toolbar */
DO:
  IF NOT SELF:CHECKED THEN 
    v-menu:CHECKED = TRUE.
  setObjectStates().  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SP-attr-dialog 


/* ****************** Standard Buttons and ADM Help ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

 /* Attach the standard OK/Cancel/Help button bar. */
 { adecomm/okbar.i  &TOOL = "AB"
                    &CONTEXT = {&SmartToolbar_Instance_Properties_Dialog_Box} }


/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK WITH FRAME {&FRAME-NAME}:
   attr-list = dynamic-function ("instancePropertyList":U IN p_hSMO, '':U).
   entries = NUM-ENTRIES (attr-list, CHR(3)).
  DO i = 1 TO entries:
     ASSIGN attr-entry = ENTRY (i, attr-list, CHR(3))
            attr-name  = TRIM (ENTRY(1, attr-entry, CHR(4)))
            attr-value = TRIM (ENTRY(2, attr-entry, CHR(4))).
     CASE attr-name:
        WHEN "TableioType":U THEN
        DO:
          v-type   = attr-value.
        END.
        /*
        WHEN "AddFunction":U THEN
           v-add = attr-value.
        */
        WHEN "Menu":U THEN
           v-Menu =  IF attr-value = 'Yes' THEN yes ELSE no.
        WHEN "ToolBar":U THEN
           v-Toolbar =  IF attr-value = 'Yes' THEN yes ELSE no.        
        WHEN "actionGroups" THEN 
           gcActionGroups = attr-value. 
        WHEN "ShowBorder":U THEN
           v-show = IF attr-value = 'Yes' THEN yes ELSE no.  
        WHEN "NavigationTargetName":U THEN
        DO:
            /* New code for 9.1B to support an SBO as a Naviogation-Target.
               If this is the case, the DataObjectNames property will come back with
               a list of all the SDO names, and the developer can pick one as the
               intended Navigation-target for this panel. */
            /* Get the handle of the associated SmartDataObject, if any. */
            RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), 
                 "LINK NAVIGATION-TARGET":U, 
                     OUTPUT cContext).      /* Returns the Context ID  */
            IF cContext NE "":U AND cContext NE ? THEN
            DO:
              RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
                OUTPUT cSDO).
              hNavTarget = WIDGET-HANDLE(cSDO).

              cObjectNames = DYNAMIC-FUNCTION('getDataObjectNames' IN hNavTarget)
                NO-ERROR.     /* Fn won't exist if this isn't an SBO. */
              IF cObjectNames = "":U THEN   /* Blank means the prop isn't set.*/
              DO:
                RUN initializeObject IN hNavTarget.
                cObjectNames = 
                    DYNAMIC-FUNCTION('getDataObjectNames' IN hNavTarget)
                        NO-ERROR.
              END.    /* END DO IF NO Targets yet */
              /* This would be if the target has no such property (is not an SBO). */     
              IF cObjectNames = ? THEN    
                cObjectNames = "":U.

              cListItems = '<none>':U + 
                (IF cObjectNames NE "":U THEN ",":U ELSE "":U)
                   + cObjectNames.
     
              ASSIGN c_SDOList:LIST-ITEMS IN FRAME {&FRAME-NAME} = cListItems
                     c_SDOList:INNER-LINES = MAX(5,NUM-ENTRIES(cListItems) / 2)
                     c_SDOList = 
                       IF attr-value = "":U THEN "<none>":U ELSE attr-value.
                     c_SDOList:SCREEN-VALUE = c_SDOList.
            END.   /* END DO if cContext defined */
        END.       /* END WHEN "NavigationTargetName" */
      END CASE.
  END.
   
  initContents(gcActionGroups).   
  RUN enable_UI.
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
  
  setObjectStates(). 
  APPLY "ENTRY" TO v-Menu IN FRAME  {&FRAME-NAME}.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    
  FOR EACH tPage:
    ASSIGN 
      cSubModules = cSubModules 
                    + (IF cSubModules = "":U THEN "":U ELSE CHR(1))
                    + string(tPage.Pagenum) + CHR(1) + tPage.Caption.
  END.
END.  
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SP-attr-dialog  _DEFAULT-DISABLE
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
  HIDE FRAME SP-attr-dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SP-attr-dialog  _DEFAULT-ENABLE
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
  DISPLAY v-Menu v-Toolbar v-show v-type c_SDOLabel c_SDOList v-divider1 
          v-divider2 
      WITH FRAME SP-attr-dialog.
  ENABLE v-Menu v-Toolbar v-show c_SDOList v-divider1 v-divider2 
      WITH FRAME SP-attr-dialog.
  VIEW FRAME SP-attr-dialog.
  {&OPEN-BROWSERS-IN-QUERY-SP-attr-dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onValueChanged SP-attr-dialog 
PROCEDURE onValueChanged :
/*------------------------------------------------------------------------------
  Purpose:   fires on value0-changed of the dynamic toggle-boxes
             Keeps track of the content changes.
             This is also the place to add additionl logic for actions: 
             - TABLEIO set v-type radioset sensitivity on/off        
  Parameters:  action id
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  
  FIND tAction WHERE tAction.Name = pcAction NO-ERROR.
  
  IF NOT AVAIL tAction THEN 
    RETURN.
   
  DO WITH FRAME {&FRAME-NAME}:
    CASE pcAction:
      WHEN "TABLEIO" THEN
        v-type:SENSITIVE = SELF:CHECKED.
    END.
  END.
  
  IF SELF:CHECKED THEN
  DO:
    gcActionGroups = gcActionGroups 
                     + (IF gcActionGroups = "":U THEN "":U ELSE ",":U)
                     + pcAction.
                      
  END.
  ELSE DO:
    ENTRY(LOOKUP(pcAction,gcActionGroups),gcActionGroups) = "":U.
    gcActionGroups = TRIM(REPLACE(gcActionGroups,",,":U,",":U),",":U).
  END.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE supportLinks SP-attr-dialog 
PROCEDURE supportLinks :
/*------------------------------------------------------------------------------
  Purpose:  Parse the selected contents and check which link to support or not.    
  Parameters:  OUTPUT plOk - NO means we cancelled 
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER plOk AS LOGICAL NO-UNDO.  

   DEFINE VARIABLE iLinkPos      AS INT  NO-UNDO.
   DEFINE VARIABLE cRecid        AS CHAR NO-UNDO.
   DEFINE VARIABLE cLink         AS CHAR NO-UNDO.
   DEFINE VARIABLE cSuppLinks    AS CHAR NO-UNDO.
   DEFINE VARIABLE cOldSuppLinks AS CHAR NO-UNDO.
   DEFINE VARIABLE cInfo         AS CHAR NO-UNDO.
   DEFINE VARIABLE lOk           AS LOG  NO-UNDO.
   DEFINE VARIABLE lAnyNew       AS LOG  NO-UNDO.
   
   cOldSuppLinks = DYNAMIC-FUNC("getSupportedLinks":U IN p_hSMO).
                
   FOR EACH tAction:
   
      IF  tAction.link <> "":U  
      AND   tAction.Link <> "Container-source":U
      AND   tAction.HdL:CHECKED
      AND   tAction.HDL:SENSITIVE THEN
      DO:
        ENTRY(2,tAction.Link,"-":U) = IF ENTRY(2,tAction.Link,"-":U) = "source":U 
                                      THEN "target":U 
                                      ELSE "source":U .
        iLinkPos = LOOKUP(tAction.Link,cSuppLinks).
        IF iLinkPos = 0 THEN
          ASSIGN
            cSupplinks = cSuppLinks 
                         + (IF cSuppLinks = "":U THEN "":U ELSE ",":U)
                         + tAction.Link
             lAnyNew   = IF lAnyNew 
                         THEN lAnyNew 
                         ELSE LOOKUP(tAction.Link,cOldSuppLinks) = 0.
     END.
   END.
   
   /* Get context id of procedure */
   RUN adeuib/_uibinfo.p (?, "HANDLE " + STRING(p_hSMO), "CONTEXT":U, 
                              OUTPUT cRecid).
    
   DO i = 1 TO num-entries(cOldSuppLinks): 
     
     clink = ENTRY(i,cOldSuppLinks).
     
     /* Is this old link still amongst the new links? */ 
     iLinkPos = LOOKUP(cLink,cSuppLinks).
      
     IF iLinkPos = 0 THEN
     DO: 
       ENTRY(2,cLink,"-":U) = IF ENTRY(2,cLink,"-":U) = "source":U 
                              THEN "target":U 
                              ELSE "source":U .
      
       /* If there exisits links for a link that we don't support anymore,
          suggest that we remove the link(s) */   
       RUN adeuib/_uibinfo.p (?, ?, "LINK ":U + cLink,output cInfo).       
       IF cInfo <> "" THEN
       DO:
         MESSAGE
          "The SmartToolbar is linked to one or more " cLink + "s." SKIP  
          "According to the selected contents this link is not supported." 
          SKIP(1)
          "Do you want to remove" clink "link(s)?"
          VIEW-AS ALERT-BOX
          BUTTONS YES-NO-CANCEL
          UPDATE lOk .         
          
          /* Cancel out of message, return to dialog */
          IF lok = ? THEN
          DO:
            plOk = FALSE.
            RETURN. 
          END.  
          ELSE IF lok = yes THEN
          DO: 
            IF ENTRY(2,cLink,"-":U) = "target":U THEN
              RUN adeuib/_ablink.p("DELETE":U,
                                    cRecid, 
                                    ENTRY(1,cLink,"-":U),
                                    "*":U).         
            ELSE 
              RUN adeuib/_ablink.p("DELETE":U,
                                    "*":U, 
                                    ENTRY(1,cLink,"-":U),
                                    cRecid).         
          END. /* if lok = yes */
       END. /* if cinfo <> '' (found unsupported links) */
     END. /* linkpos = 0 (not supported anymore) */ 
   END. /* do i = 1 to num-entries(oldsupported) */
   
   plOk = DYNAMIC-FUNC("setSupportedLinks":U IN p_hSMO,cSuppLinks).
   
   /* The current advslnk suggests already linked links  
   IF lAnyNew THEN
     RUN adeuib/_advslnk.p (iRecid).
   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initContents SP-attr-dialog 
FUNCTION initContents RETURNS LOGICAL
  (pcContents AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Generate togle-boxes for all actiongroups that are available in 
            the toolbar. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMenuActions    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cToolbarActions AS CHAR   NO-UNDO.
  DEFINE VARIABLE cActions        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cAction         AS CHAR   NO-UNDO.
  DEFINE VARIABLE cChildren       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLabel          AS CHAR   NO-UNDO.
  DEFINE VARIABLE i               AS INT    NO-UNDO.
  DEFINE VARIABLE iCol            AS DEC    NO-UNDO.
  DEFINE VARIABLE iRow            AS DEC    NO-UNDO.
  DEFINE VARIABLE iOldHeight      AS DEC    NO-UNDO.
  DEFINE VARIABLE iOldWidth       AS DEC    NO-UNDO.
  DEFINE VARIABLE iNewWidth       AS DEC    NO-UNDO.
  /* make sure progress default is displayed first */
  DEFINE VARIABLE cSort           AS CHAR   NO-UNDO INIT 
"Navigation,Tableio,Transaction,Filter".
        
  ASSIGN
    cMenuActions    = DYNAMIC-FUNCTION("getAvailMenuActions" IN p_hSMO).
    cToolbarActions = DYNAMIC-FUNCTION("getAvailToolbarActions" IN p_hSMO).

  DO i = 1 TO NUM-ENTRIES(cMenuActions):
    CREATE tAction.    
    ASSIGN 
      tAction.Name  = ENTRY(i,cMenuActions)
      tAction.Link  = DYNAMIC-FUNCTION("actionLink" IN p_hSMO,tAction.Name)
      tAction.Sort1 = IF LOOKUP(tAction.Name,cSort) > 0  
                      THEN LOOKUP(tAction.Name,cSort)
                      ELSE 10  
      tAction.Sort2 = i
      tAction.Menu  = TRUE.
  END.
  
  DO i = 1 TO NUM-ENTRIES(cToolbarActions):
    FIND tAction WHERE tAction.Name = ENTRY(i,cToolbarActions) NO-ERROR.  
    IF NOT AVAIL tAction THEN
    DO:
      CREATE tAction.    
   
      ASSIGN 
        tAction.Name  = ENTRY(i,cToolbarActions)
        tAction.Link  = DYNAMIC-FUNCTION("actionLink" IN p_hSMO,tAction.Name)
        tAction.Sort1 = IF LOOKUP(tAction.Name,cSort) > 0  
                        THEN LOOKUP(tAction.Name,cSort)
                        ELSE 10  
        tAction.Sort2 = i.
    END.
    tAction.Tool  = TRUE.
  END.       
       
  DO WITH FRAME {&FRAME-NAME}:
    iRow = v-divider2:ROW + 1.
    iCol = v-menu:COL. 

    FOR EACH tAction: 
      /* if the group has one child we display it's label */
      ASSIGN
        cLabel    = "":U
        cChildren = DYNAMIC-FUNCTION("actionChildren":U IN p_hSMO,
                                      tAction.Name).
      IF cChildren <> "":U AND NUM-ENTRIES(cChildren) = 1 THEN
        cLabel = DYNAMIC-FUNCTION("actionName":U IN p_hSMO,cChildren).
      IF cLabel = "":U THEN
        cLabel = DYNAMIC-FUNCTION("actionName":U IN p_hSMO,tAction.Name).
      
      CREATE TOGGLE-BOX tAction.Hdl
       ASSIGN 
        FRAME     = FRAME {&FRAME-NAME}:HANDLE
        LABEL     = cLabel
        CHECKED   = CAN-DO(pcContents,tAction.Name)
        HIDDEN    = FALSE
        COL       = iCol
        ROW       = iRow
        SENSITIVE = (v-Menu AND tAction.Menu) OR (v-toolbar AND tAction.tool)
      TRIGGERS:
        ON VALUE-CHANGED 
          PERSISTENT RUN onValueChanged IN TARGET-PROCEDURE (tAction.Name).
      END.  
      iRow = iRow + 1.
      CASE tAction.Name:
        WHEN "TABLEIO":U THEN
          ASSIGN v-type:ROW = iRow
                 iRow       = iRow + 1
                 v-type:HIDDEN    = FALSE
                 v-type:SENSITIVE = tAction.Hdl:CHECKED.
          WHEN "NAVIGATION":U THEN
          DO:
              /* Enable the SDO list later in setObjectStates if 
                 Navigation is enabled &  "<none>" isn't only entry */
              lEnableSDOs =         
                 (tAction.Hdl:CHECKED AND   
                  c_SDOList:NUM-ITEMS > 1). 
              IF lEnableSDOs THEN
                ASSIGN c_SDOList:ROW = iRow
                       iRow          = iRow + 2.
          END.   /* END DO WHEN Navigation */
       END CASE.
     
      /* Resize if some case added widgets that did not fit */
      ASSIGN
        iOldHeight = FRAME {&FRAME-NAME}:HEIGHT 
        iOldWidth  = FRAME {&FRAME-NAME}:WIDTH 
        FRAME {&FRAME-NAME}:HEIGHT = MAX(iOldHeight,iROw + 4) 
        FRAME {&FRAME-NAME}:WIDTH = MAX(iOldWidth,iNewWidth + 4) 
        {&ok}:ROW = {&ok}:ROW +  FRAME {&FRAME-NAME}:HEIGHT - iOldHeight
        {&cancel}:ROW = {&cancel}:ROW +  FRAME {&FRAME-NAME}:HEIGHT - iOldHeight
        {&help}:ROW = {&help}:ROW + FRAME {&FRAME-NAME}:HEIGHT - iOldHeight
        {&help}:COL = MAX({&help}:COL, iNewWidth - {&help}:WIDTH)
        v-divider1:WIDTH =  MAX(v-divider1:WIDTH,iNewWidth) 
        v-divider2:WIDTH =  v-divider1:WIDTH.  
    END.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initPages SP-attr-dialog 
FUNCTION initPages RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i     AS INT.
  DEF VAR iPos  AS INT.
  DEF VAR imaxPos AS INT.
  DEF VAR iPos2 AS INT.
  DEF VAR iPos3 AS INT.
  DEF VAR cObjects AS CHAR NO-UNDO.
  DEF VAR cStrHdl  AS CHAR NO-UNDO.
  DEF VAR iPage    AS INT NO-UNDO.
  def var proc as char.
  def var C-CODE as char.
  def var C-pageCODE as char.
  def var C-page as char.
  def var hWin AS HANDLE.
  
   
  /* Get context id of procedure */
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT Proc).
  
  /* Get context id of procedure */
  RUN adeuib/_uibinfo.p (int(proc), ?, "contains smartobject", OUTPUT cObjects).
  /*
  DO i = 1 TO NUM-ENTRIES(cobjects):
    RUN adeuib/_uibinfo.p (int(entry(i,cobjects)), ?, "name", OUTPUT c-code).
    message c-code view-aS ALERT-BOX.
    RUN adeuib/_uibinfo.p (int(entry(i,cobjects)), ?, "type", OUTPUT c-code).
    message c-code view-aS ALERT-BOX.
    RUN adeuib/_uibinfo.p (int(entry(i,cobjects)), ?, "handle", OUTPUT c-code).
    message c-code view-aS ALERT-BOX.
      
  END. 
  */
  DEF VAR I-CONTEXT AS INT INIT ?.
 
  run adeuib/_accsect.p 
                            ("GET", ?, "PROCEDURE:ADM-CREATE-OBJECTS", 
                              INPUT-OUTPUT i-context,
                              INPUT-OUTPUT c-code).
 
  ipos2 = 1.
  DO WHILE TRUE:
    ipos = INDEX(c-code,"WHEN",ipos2).
    IF ipos > 0 THEN 
    DO:  
      ipos2   = ipos + 1.
      imaxpos = INDEX(c-code,"WHEN",ipos2).
      c-pagecode = IF imaxpos = 0
                   THEN SUBSTR(c-code,ipos)
                   ELSE SUBSTR(c-code,ipos,imaxpos - ipos).
      iPage = int(ENTRY(2,c-pagecode," ")).
      iPos3 = 1.
      IF iPage > 0 THEN
      DO WHILE TRUE:
        ipos = INDEX(c-pagecode,"OUTPUT",ipos3).
        IF ipos > 0 THEN     
        DO:
          create tPage.          
          tPage.pageNum = iPage.
          tPage.name = ENTRY(2,SUBSTR(c-pagecode,ipos)," ":U).
          RUN adeuib/_uibinfo.p (?,tPage.Name, "procedure-handle", OUTPUT cStrHdl).
          tPage.Hdl = WIDGET-HANDLE(cStrHdl).
          IF valid-handle(tPage.Hdl) THEN 
          DO:
            hWin = DYNAMIC-FUNCTION("getContainerHandle" in tPage.Hdl).
            IF hWin:TYPe = "WINDOW":U THEN 
              tPage.Caption = hWin:TITLE.
            ELSE DO:
              DELETE tPage.
            END. 
          END.
          ipos3 = ipos + 1.        
        END.
        ELSE DO:
          ipos2 = ipos2 + ipos3.
          LEAVE.
        END.
      END.
    END.
    ELSE leave.
  END.  
    
  RETURN can-find(first tpage).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectStates SP-attr-dialog 
FUNCTION setObjectStates RETURNS LOGICAL
  (  ) :
/*-----------------------------------------------------------------------------
  Purpose: Set sensitivity of dynamic toggle-boxes according to 
           whether menu and toolbar is checked  
    Notes:  
 ---------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH tAction WHERE tAction.Tool = FALSE OR tAction.Menu = FALSE :
       tAction.Hdl:SENSITIVE = tAction.Tool AND v-toolbar:CHECKED
                               OR
                               tAction.Menu AND v-Menu:CHECKED.
    END. /* for each tAction */   
    ASSIGN v-show:SENSITIVE = v-toolbar:CHECKED
           c_SDOList:SENSITIVE = lEnableSDOs  /* This was set in initContents. */
           c_SDOList:HIDDEN = NOT lEnableSDOs
           c_SDOLabel:HIDDEN = NOT lEnableSDOs.
  END. 

  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

