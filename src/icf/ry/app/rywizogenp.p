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
  File: rywizogenp.p

  Description:  Wizard Object Generation PLIP

  Purpose:      Wizard Object Generation PLIP

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6199   UserRef:    
                Date:   30/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rytemplipp.p

  (v:010001)    Task:        6234   UserRef:    
                Date:   09/07/2000  Author:     Anthony

  Update Notes: Test new wizards

  (v:010002)    Task:        6415   UserRef:    
                Date:   04/08/2000  Author:     Anthony Swindells

  Update Notes: Remove DB dependancy from wizards - only require DB if forward generating.

  (v:010004)    Task:        7618   UserRef:    
                Date:   18/01/2001  Author:     Anthony Swindells

  Update Notes: Enhance wizard forward engineer program to support header/detail folders
                plus non sdo folders

  (v:010005)    Task:        7659   UserRef:    
                Date:   22/01/2001  Author:     Anthony Swindells

  Update Notes: Enhance so that if there is a browser linked to an sdo then also add a toolbar to
                the bottom of the browser.

  (v:010006)    Task:        7694   UserRef:    
                Date:   25/01/2001  Author:     Anthony Swindells

  Update Notes: Enhance for extra repository fields.
                New viewer on object controller.
                New layout support for top/multi/bottom.
                New viewer toolbar parent menu, link viewer to sdo, and parent sdo object
                name fields implement.

  (v:010007)    Task:        7756   UserRef:    
                Date:   30/01/2001  Author:     Anthony Swindells

  Update Notes: Only add window title field to viewer if applicable - i.e. viewer is a
                smartdataviewer object type

  (v:010008)    Task:        7777   UserRef:    
                Date:   31/01/2001  Author:     Anthony Swindells

  Update Notes: Fix windowtitlefield issues with wizards

  (v:010003)    Task:    90000142   UserRef:    
                Date:   17/05/2001  Author:     Haavard Danielsen

  Update Notes: b

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rywizogenp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{af/app/afdatatypi.i}

DEFINE TEMP-TABLE ttSDO       NO-UNDO
FIELD cSDOName                AS CHARACTER
FIELD iPageNumber             AS INTEGER
FIELD cBrowserName            AS CHARACTER
FIELD cParentSDO              AS CHARACTER
FIELD dSDOSmartObject         AS DECIMAL
FIELD dSDOObjectInstance      AS DECIMAL
FIELD lForeignFields          AS LOGICAL
FIELD lSBO                    AS LOGICAL
FIELD lOneToOneContainer      AS LOGICAL
FIELD lOneToManyContainer     AS LOGICAL
FIELD lCommit                 AS LOGICAL
INDEX key1 cSDOName
INDEX key2 iPageNumber cSDOName.

DEFINE TEMP-TABLE ttViewer    NO-UNDO
FIELD cViewerName             AS CHARACTER
FIELD iPageNumber             AS INTEGER
FIELD cSDOName                AS CHARACTER
FIELD lPrimary                AS LOGICAL
FIELD lLinkToSDO              AS LOGICAL
FIELD dViewerSmartObject      AS DECIMAL
FIELD dViewerObjectInstance   AS DECIMAL
INDEX key1 cViewerName cSDOName lPrimary
INDEX key2 cSDOName cViewerName lPrimary
.

DEFINE TEMP-TABLE ttBrowser   NO-UNDO
FIELD cBrowserName            AS CHARACTER
FIELD iPageNumber             AS INTEGER
FIELD cSDOName                AS CHARACTER
FIELD lToolbarRequired        AS LOGICAL
FIELD dBrowserSmartObject     AS DECIMAL
FIELD dBrowserObjectInstance  AS DECIMAL
INDEX key1 cBrowserName cSDOName
INDEX key2 cSDOName cBrowserName
.

DEFINE TEMP-TABLE ttPage      NO-UNDO
FIELD iPageNumber             AS INTEGER
FIELD dPageObj                AS DECIMAL
INDEX key1 iPageNumber
.

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
         HEIGHT             = 16.62
         WIDTH              = 54.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addSDOsToPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSDOsToPage Procedure 
PROCEDURE addSDOsToPage :
/*------------------------------------------------------------------------------
  Purpose:     Put SDO's on page - once
  Parameters:  input object name
               input container object number
               output error text if any
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcObjectName                 AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdContainer                  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSequence                           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSDOInstance                        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dSource                             AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bttSDO FOR ttSDO.
  DEFINE BUFFER bttViewer FOR ttViewer.
  DEFINE BUFFER bttBrowser FOR ttBrowser.

  ASSIGN pcErrorText = "":U.

  /* create all SDO instances - each SDO only once on 1st page referenced */
  ASSIGN iSequence = 99.  /* to avoid compatibility issues with old version of program */
  /* We have created an SDO to represent the ObjectController .. 
     so make sure we don't create an instance for it.  */
  FOR EACH ttSDO WHERE ttSDO.cSDOName <> '':U BY ttSDO.iPageNumber:
    ASSIGN iSequence = iSequence + 1.

    FIND FIRST ttPage WHERE ttPage.iPageNumber = ttSDO.iPageNumber.

    RUN updateObjectInstance (INPUT pcObjectName,
                              INPUT pdContainer,
                              INPUT ttSDO.cSDOName
                                  + (IF ttSDO.cBrowserName <> "":U THEN (CHR(3) + ttSDO.cBrowserName) ELSE "":U),
                              INPUT ",":U + STRING(ttSDO.iPageNumber),
                              INPUT "sdo":U,
                              OUTPUT dSmartObject,
                              OUTPUT dObjectType,
                              OUTPUT dSDOInstance).

    ASSIGN ttSDO.dSDOSmartObject = dSmartObject
           ttSDO.dSDOObjectInstance = dSDOInstance.

    /* Check if there are viewers on browsers on the same page and if there is
       set the SDOs Asynchronous property to false. */

    FOR EACH bttViewer WHERE bttViewer.cSDOName = ttSDO.cSDOName:
       FIND bttBrowser WHERE bttBrowser.cSDOName    = ttSDO.cSDOName 
                      AND   bttBrowser.iPageNumber = bttViewer.iPageNumber NO-ERROR.

       IF AVAIL bttBrowser THEN
         RUN updateAttributeValues (INPUT dObjectType,
                                    INPUT dSmartObject,
                                    INPUT pdContainer,
                                    INPUT dSDOInstance,
                                    INPUT 'AsynchronousSDO':U,
                                    INPUT 'FALSE':U). 

    END.

    /* and add to appropriate page */
    RUN updatePageObject(INPUT pdContainer,
                         INPUT ttSDO.dSDOObjectInstance,
                         INPUT ttPage.dPageObj,
                         INPUT iSequence).    
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.
  END.

  /* Create links for SDO's with foreign fields */
  FOR EACH ttSDO WHERE ttSDO.lForeignFields = YES:

    IF ttSDO.cParentSDO <> "":U THEN
      FIND FIRST bttSDO
           WHERE bttSDO.cSDOName = ttSDO.cParentSDO
           NO-ERROR.
    IF ttSDO.cParentSDO <> "":U AND AVAILABLE bttSDO THEN
      ASSIGN dSource = bttSDO.dSDOObjectInstance.
    ELSE
      ASSIGN dSource = 0.

    /* create links from container for pass-thru if sdo has foreign fields */  
    RUN updateLink (INPUT "Data":U,
                    INPUT "":U,
                    INPUT pdContainer,
                    INPUT dSource,
                    INPUT ttSDO.dSDOObjectInstance).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.

    RUN updateLink (INPUT "ToggleData":U,
                    INPUT "":U,
                    INPUT pdContainer,
                    INPUT dSource,
                    INPUT ttSDO.dSDOObjectInstance).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. RETURN. END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjectFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObjectFirst Procedure 
PROCEDURE deleteObjectFirst :
/*------------------------------------------------------------------------------
  Purpose:     Delete all data for object first - before re-generating
  Parameters:  input object name
               output error text if any
  Notes:       Does not delete the ryc_smartobject records
               as this may cause issues due to the fact we need to retain their
               object numbers.
               It does however delete all the following records
               ryc_page information
               ryc_page_object information
               ryc_object_instance information
               ryc_smartlink information
               ryc_attribute_value information for smartobject and instances
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_page FOR ryc_page.
DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

tran-block:
DO FOR bryc_page, bryc_object_instance, bryc_attribute_value, bryc_smartobject
       TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block: 

  FIND FIRST bryc_smartobject NO-LOCK
       WHERE bryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE bryc_smartobject THEN RETURN.

  /* Object exists, delete all instances, which will also zap instance attributes and links */
  FOR EACH bryc_object_instance EXCLUSIVE-LOCK
     WHERE bryc_object_instance.container_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* zap any page records which will also zap page object records */
  FOR EACH bryc_page EXCLUSIVE-LOCK
     WHERE bryc_page.container_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* Finally zap object attributes */
  FOR EACH bryc_attribute_value EXCLUSIVE-LOCK
     WHERE bryc_attribute_value.PRIMARY_smartobject_obj = bryc_smartobject.smartobject_obj:
    DELETE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    pcErrorText = cMessageList.
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

END.  /* tran-block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateTreeView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateTreeView Procedure 
PROCEDURE generateTreeView :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a Dynamic TreeView controller object 
               based on information in the TreeView Controller Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_tree FOR rym_wizard_tree.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerToolbarInstance           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderToolbarInstance              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFilterViewer                       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN
  pcErrorText = "":U
  .

tran-block:
DO FOR brym_wizard_tree TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_tree EXCLUSIVE-LOCK
       WHERE brym_wizard_tree.object_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_tree THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Folder Window'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.
  
  /* create / update ryc_smartobject records */
  RUN updateDynamicObject (INPUT "tree":U,
                           INPUT brym_wizard_tree.product_module_code,
                           INPUT brym_wizard_tree.object_name,
                           INPUT brym_wizard_tree.object_description,
                           INPUT "":U,
                           INPUT brym_wizard_tree.custom_super_procedure,
                           INPUT brym_wizard_tree.page_layout,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'AutoSort,HideSelection,ImageHeight,ImageWidth,RootNodeCode,ShowCheckBoxes,ShowRootLines,TreeStyle,WindowName',
                             INPUT STRING(brym_wizard_tree.auto_sort) + CHR(3) + STRING(brym_wizard_tree.hide_selection) + CHR(3) + STRING(brym_wizard_tree.image_height) + CHR(3) + STRING(brym_wizard_tree.image_width) + CHR(3) + STRING(brym_wizard_tree.root_node_code) + CHR(3) + STRING(brym_wizard_tree.show_check_boxes) + CHR(3) + STRING(brym_wizard_tree.show_root_lines) + CHR(3) + STRING(brym_wizard_tree.tree_style) + CHR(3) + brym_wizard_tree.window_title).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Add Folder */  
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "afspfoldrw.w":U,
                            INPUT "":U,
                            INPUT "fold":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dFolderInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Add top container toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "ObjcTop":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dContainerToolbarInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /*
  ASSIGN
    cAttributeLabels = "":U
    cAttributeValues = "":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dContainerToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  */

  /* Add folder toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "FolderPageTop":U,
                            INPUT "centre":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dFolderToolbarInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* We need to hide the Std Navigation buttons for the FolderPageTop toolbar - not used in treeview*/
  ASSIGN
    cAttributeLabels = "HiddenToolbarBands,HiddenMenuBands":U
    cAttributeValues = "Navigation" + CHR(3) + "Navigation":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dFolderToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  /******/
  
  /* Add Filter Viewer */  
  IF brym_wizard_tree.filter_viewer <> "":U THEN DO:
    RUN updateObjectInstance (INPUT pcObjectName,
                              INPUT dContainer,
                              INPUT brym_wizard_tree.filter_viewer,
                              INPUT "top":U,
                              INPUT "view":U,
                              OUTPUT dSmartObject,
                              OUTPUT dObjectType,
                              OUTPUT dFilterViewer).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.
  
  /* Now add folder page 'Details'  */
  RUN updatePage (INPUT dContainer,
                  INPUT 1,
                  INPUT "&Details",
                  INPUT "Top/Multi/Bottom":U).   
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  
  /* Set-up link from Conatainer ToolBar to Container */
  RUN updateLink (INPUT "Navigation":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  
  /* Set-up standard folder links */
  RUN updateLink (INPUT "page":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dFolderInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Set-up link from Folder ToolBar to Container */
  RUN updateLink (INPUT "TableIO":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dFolderToolbarInstance,
                  INPUT 0).

  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Set-up link from Filter Viewer to Container */
  IF brym_wizard_tree.filter_viewer <> "":U THEN DO:
    RUN updateLink (INPUT "TreeFilter":U,
                    INPUT "":U,
                    INPUT dContainer,
                    INPUT dFilterViewer,
                    INPUT 0).
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.
  
  /* Set-up link from Folder ToolBar to Container */
  RUN updateLink (INPUT "Toolbar":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).

  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  
  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_tree.generated_date = TODAY
    brym_wizard_tree.generated_time = TIME
    .
  VALIDATE brym_wizard_tree NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Wizard forward engineer".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAttributeValues Procedure 
PROCEDURE updateAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to update attribute values for an object type, a
               smartobject, or an object instance.
  Parameters:  input object type object number
               input smartobject object number (optional)
               input container smartobject object number (optional)
               input object instance object number (optional)
               input comma delimited list of attribute labels
               input CHR(3) delimited list of corresponding attribute values
  Notes:       If only an object type is passed in, then the attribute values
               will be set for the object type.
               If an object type and smartobject are passed in but no container
               and object instance, then the smartobject attribute values will be
               updated.
               If a container object instance is passed in then the object instance
               attribute values will be updated.
               The attribute value record should first be created if it does not
               yet exist.
               This procedure does not deal with attribute collections and simply
               sets the collect_attribute_value_obj equal to the attribute_value_obj
               when creating a new attribute, and the sequence to 0.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdObjectType                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdSmartObject                 AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer                   AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdInstance                    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeLabels             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeValues             AS CHARACTER  NO-UNDO.

DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE iLoop                                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAttributeLabel                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValue                       AS CHARACTER  NO-UNDO.

ASSIGN cMessageList = "":U.

/* In case run from rycsomainw.w */
ON FIND OF ryc_attribute OVERRIDE DO: END.

trn-block:
DO FOR bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  DO iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels):
    ASSIGN
      cAttributeLabel = ENTRY(iLoop, pcAttributeLabels)
      cAttributeValue = ENTRY(iLoop, pcAttributeValues, CHR(3))
      .

    FIND FIRST ryc_attribute NO-LOCK
         WHERE ryc_attribute.attribute_label = cAttributeLabel
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
    DO:
      ASSIGN cMessageList = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Attribute Label'" cAttributeLabel}.
      UNDO trn-block, LEAVE trn-block.      
    END.

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.OBJECT_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.attribute_label = cAttributeLabel
         NO-ERROR.

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
      ASSIGN
        bryc_attribute_value.OBJECT_type_obj = pdObjectType
        bryc_attribute_value.smartobject_obj = pdSmartObject
        bryc_attribute_value.container_smartobject_obj = pdContainer
        bryc_attribute_value.object_instance_obj = pdInstance
        bryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        bryc_attribute_value.constant_value = NO
        .        
      IF bryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.container_smartobject_obj.
      ELSE
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.smartobject_obj.
    END.

    CASE ryc_attribute.data_type:
      WHEN {&DECIMAL-DATA-TYPE}   THEN bryc_attribute_value.decimal_value   = DECIMAL(cAttributeValue) NO-ERROR.
      WHEN {&INTEGER-DATA-TYPE}   THEN bryc_attribute_value.integer_value   = INTEGER(cAttributeValue) NO-ERROR.
      WHEN {&DATE-DATA-TYPE}      THEN bryc_attribute_value.date_value      =    DATE(cAttributeValue) NO-ERROR.
      WHEN {&RAW-DATA-TYPE}       THEN.
      WHEN {&LOGICAL-DATA-TYPE}   THEN bryc_attribute_value.logical_value   = (IF cAttributeValue = "TRUE":U OR
                                                                                 cAttributeValue = "YES":U  THEN TRUE ELSE FALSE) NO-ERROR.
      WHEN {&CHARACTER-DATA-TYPE} THEN bryc_attribute_value.character_value = cAttributeValue NO-ERROR.
    END CASE.
    
    VALIDATE bryc_attribute_value NO-ERROR.  
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* iLoop = 1 TO NUM-ENTRIES(pcAttributeLabels): */

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateDynamicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDynamicObject Procedure 
PROCEDURE updateDynamicObject :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update and ICFDB
               ryc_smartobject records for dynamic object passed in.
  Parameters:  input object type (menc, objc, fold, view, brow)
               input product module code
               input object name
               input object description
               input sdo name if required (browsers / viewers only)
               input custom super procedure
               input layout code
               output object number of smartobject created / updated
               output object type object number
  Notes:       Attribute values are cascaded down onto new smartobjects from the
               object type by the replication write trigger of the smartobject
               coded in rycsoreplw.i
               Despite this we copy them down again and update them, in case
               used delete object first option.
               Errors are passed back in return value.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSDOName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSuper                     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLayout                    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.

DEFINE BUFFER b2ryc_smartobject    FOR ryc_smartobject.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DEFINE VARIABLE lContainer                          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPhysicalObject                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dPhysicalObject                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cObjectType                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProductModule                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dLayout                             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDO                                AS DECIMAL    NO-UNDO.

ASSIGN cMessageList = "":U.

CASE pcObjectType:
  WHEN "menc":U THEN  /* menu controller */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyncontw.w":U
      cObjectType = "dynmenc":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Relative":U)
      .
  END.
  WHEN "objc":U THEN  /* object controller */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyncontw.w":U
      cObjectType = "dynobjc":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Relative":U)
      .
  END.
  WHEN "fold":U THEN  /* folder window */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyncontw.w":U
      cObjectType = "dynfold":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Relative":U)
      .
  END.
  WHEN "tree":U THEN  /* folder window */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyntreew.w":U
      cObjectType = "dyntree":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "TreeView":U)
      .
  END.
  WHEN "brow":U THEN  /* browser */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydynbrowb.w":U
      cObjectType = "dynbrow":U
      cLayout = "":U
      .
  END.
  WHEN "view":U THEN  /* viewer */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydynviewv.w":U
      cObjectType = "dynview":U
      cLayout = "":U
      .
  END.
  OTHERWISE
  DO:
    RETURN {af/sup2/aferrortxt.i 'RY' '5' '?' '?' pcObjectType}.   
  END.
END CASE.

/* find product module for object */

FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModuleCode
     NO-ERROR.

IF NOT AVAILABLE gsc_product_module THEN 
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.   
END.
ELSE ASSIGN dProductModule = gsc_product_module.product_module_obj.

/* Find layout if required */

IF cLayout <> "":U THEN
DO:
  FIND FIRST ryc_layout NO-LOCK
       WHERE ryc_layout.layout_name = cLayout
       NO-ERROR.
  IF NOT AVAILABLE ryc_layout THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" cLayout}.   
  END.
END.
IF cLayout <> "":U AND AVAILABLE ryc_layout THEN
  ASSIGN dLayout = ryc_layout.layout_obj.
ELSE
  ASSIGN dLayout = 0.

/* find corresponding physical object */

FIND FIRST ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.object_filename = cPhysicalObject
     NO-ERROR.

IF NOT AVAILABLE ryc_smartobject THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'RY' '3' '?' '?' cPhysicalObject}.   
END.
ELSE ASSIGN dPhysicalObject = ryc_smartobject.smartobject_obj.

/* find object type for object */

FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = cObjectType
     NO-ERROR.

IF NOT AVAILABLE gsc_object_type THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'RY' '4' '?' '?' cObjectType}.   
END.
ELSE ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.

/* Find SDO name if passed in (viewers / browsers) */

IF pcSDOName <> "":U THEN
DO:
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.object_filename = pcSDOName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSDOName}.   
  END.
  ELSE ASSIGN dSDO = ryc_smartobject.smartobject_obj.
END.
ELSE ASSIGN dSDO = 0.

trn-block:
DO FOR b2ryc_smartobject, bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* find existing ASDB object / create new one */

  FIND FIRST b2ryc_smartobject EXCLUSIVE-LOCK
       WHERE b2ryc_smartobject.object_filename = pcObjectName
       NO-ERROR.

  IF NOT AVAILABLE b2ryc_smartobject THEN
  DO:
    CREATE b2ryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    ASSIGN b2ryc_smartobject.object_filename = pcObjectName
           b2ryc_smartobject.DISABLED = NO
           b2ryc_smartobject.system_owned = NO
           b2ryc_smartobject.shutdown_message_text = "":U
           b2ryc_smartobject.template_smartobject = NO.
  END.
  ELSE DO:
      /* ObjType - The object exists already, if the object type is being changed, raise an error */
      IF b2ryc_smartobject.object_type_obj <> dObjectType THEN
          RETURN {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the repository object'" "'object types can not be updated once assigned'"}.
  END.

  /* Update ICFDB object details */

  ASSIGN b2ryc_smartobject.object_description = pcObjectDescription 
         b2ryc_smartobject.generic_object = NO
         b2ryc_smartobject.container_object = lContainer
         b2ryc_smartobject.object_path = "":U
         b2ryc_smartobject.object_type_obj = dObjectType
         b2ryc_smartobject.physical_smartobject_obj = dPhysicalObject
         b2ryc_smartobject.product_module_obj = dProductModule
         b2ryc_smartobject.required_db_list = "":U
         b2ryc_smartobject.runnable_from_menu = lContainer  
         b2ryc_smartobject.run_persistent = YES
         b2ryc_smartobject.run_when = "ANY":U
         b2ryc_smartobject.security_smartobject_obj = b2ryc_smartobject.smartobject_obj
         b2ryc_smartobject.static_object = NO
         b2ryc_smartobject.product_module_obj = dProductModule
         b2ryc_smartobject.layout_obj = dLayout
         b2ryc_smartobject.sdo_smartobject_obj = dSDO.

  IF  pcSuper <> "":U
  AND pcSuper <> ?
  THEN DO:
      DEFINE BUFFER brycso_object FOR ryc_smartobject.
    
      DEFINE VARIABLE cProcName AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE cProcExt  AS CHARACTER  NO-UNDO.
    
      ASSIGN cProcName = REPLACE(pcSuper, "~\":U, "/":U)
             cProcName = ENTRY(NUM-ENTRIES(cProcName, "/":U), cProcName, "/":U)
             cProcExt  = ENTRY(NUM-ENTRIES(cProcName, ".":U), cProcName, ".":U)
             cProcName = REPLACE(cProcName, ".":U + cProcExt, "":U).
    
      FIND brycso_object NO-LOCK
           WHERE brycso_object.object_filename  = cProcName
             AND brycso_object.object_extension = cProcExt
           NO-ERROR.
    
      IF NOT AVAILABLE brycso_object 
      THEN DO:
          FIND brycso_object NO-LOCK
               WHERE brycso_object.object_filename = cProcName + ".":U + cProcExt
               NO-ERROR.
    
          IF NOT AVAILABLE brycso_object 
          THEN DO:
              ASSIGN cMessageList = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' '"custom super procedure"' '"The custom super procedure specified does not exist in the repository."'}.
              UNDO trn-block, LEAVE trn-block.
          END.
      END.

      IF AVAILABLE brycso_object THEN
          ASSIGN b2ryc_smartobject.custom_smartobject_obj = brycso_object.smartobject_obj.
  END.

  VALIDATE b2ryc_smartobject NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN pdSmartObject = b2ryc_smartobject.smartobject_obj
         pdObjectType  = dObjectType.

  /* 
   * now cascade attribute values down off object type, updating them if they
   * already exist.
   */

  attribute-loop:
  FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = pdObjectType
        AND ryc_attribute_value.smartobject_obj           = 0
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = 0
           AND bryc_attribute_value.container_smartobject_obj = 0
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = pdObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = 0
      bryc_attribute_value.container_smartobject_obj = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdSmartObject
      bryc_attribute_value.decimal_value   = ryc_attribute_value.decimal_value  
      bryc_attribute_value.integer_value   = ryc_attribute_value.integer_value  
      bryc_attribute_value.date_value      = ryc_attribute_value.date_value     
      bryc_attribute_value.logical_value   = ryc_attribute_value.logical_value  
      bryc_attribute_value.character_value = ryc_attribute_value.character_value
      .

    VALIDATE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* attribute-loop */

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatelink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatelink Procedure 
PROCEDURE updatelink :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to add/update a smartlink between 2 objects
  Parameters:  input link name
               input user defined link name (blank if not user defined)
               input container object number
               input source instance object number or 0 for container
               input target instance object number or 0 for container
  Notes:       For non user defined links the link name must exist in the 
               smartlink type table. For user defined links, we look in the
               smartlink type table for a link name equal to the user defined
               link name specified, and the actual link name is not validated.
               If the source or target are passed in as 0, then it is a link
               to or from the container. 
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcLinkName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcUserLinkName            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdSource                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdTarget                  AS DECIMAL    NO-UNDO.

DEFINE BUFFER bryc_smartlink FOR ryc_smartlink.

ASSIGN cMessageList = "":U.

/* validate link name / user link name specified */
IF pcUserLinkName <> "":U THEN
DO:
  FIND FIRST ryc_smartlink_type NO-LOCK
       WHERE ryc_smartlink_type.link_name = pcUserLinkName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartlink_type THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'User Defined Link Name'" pcUserLinkName}.      
  END.
END.
ELSE
DO:
  FIND FIRST ryc_smartlink_type NO-LOCK
       WHERE ryc_smartlink_type.link_name = pcLinkName
       NO-ERROR.
  IF NOT AVAILABLE ryc_smartlink_type THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Link Name'" pcLinkName}.      
  END.
END.

/* link specified is valid, see if link already exist */
FIND FIRST ryc_smartlink NO-LOCK
     WHERE ryc_smartlink.container_smartobject_obj = pdContainer
       AND ryc_smartlink.link_name = ryc_smartlink_type.link_name
       AND ryc_smartlink.source_object_instance_obj = pdSource
       AND ryc_smartlink.target_object_instance_obj = pdTarget
     NO-ERROR.
IF AVAILABLE ryc_smartlink THEN RETURN.

/* create new smartlink */
trn-block:
DO FOR bryc_smartlink TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
  CREATE bryc_smartlink NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  ASSIGN
    bryc_smartlink.container_smartobject_obj = pdContainer
    bryc_smartlink.smartlink_type_obj = ryc_smartlink_type.smartlink_type_obj
    bryc_smartlink.link_name = ryc_smartlink_type.link_name
    bryc_smartlink.source_object_instance_obj = pdSource
    bryc_smartlink.target_object_instance_obj = pdTarget
    .    
  VALIDATE bryc_smartlink NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateObjectInstance Procedure 
PROCEDURE updateObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object instance on a container
  Parameters:  input container object name
               input container object number
               input object filename of object on container (must exist)
                     nb: for sdo, object name is sdo + chr(3) + browser
               input layout position of object on container, e.g. top
               input object type code for object instance,
                     e.g. SDO, brow, view, fold, tool.
               output object number of object on container
               output object type object number of object on container
               output instance object number of object on container

  Notes:       If object already exists on container, the instance and its
               attribute values will be updated accordingly, otherwise the
               instance will be created.
               We determine whether the object exists based on the objects layout
               position, as an object can exist on a container multiple times. This
               means that the layout position must always be different for every
               object on a container for this to work.
               We must also manually cascade smartobject attribute values down
               onto new object instance if creating a new instance.
               Some attribute values are specified in the wizards and these will
               be updated from the values in the wizards if specified. For browser
               and sdo objects, attributes will be updated from the browser wizard
               unless specifically overridden in the container wizard.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcContainerName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdContainer                 AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayoutPosition            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdInstance                  AS DECIMAL    NO-UNDO.

/* Hard coded attributes to try and get from wizard tables */
DEFINE VARIABLE cObjectName                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDOBrowser                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cForeignFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLaunchContainer                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWindowTitleField                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSelectedFields                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.
DEFINE VARIABLE lNoSDO                              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lSDV                                AS LOGICAL    NO-UNDO.

ASSIGN cMessageList = "":U.

IF pcObjectName <> "":U THEN
  ASSIGN
    cObjectName = ENTRY(1, pcObjectName, CHR(3)).
IF NUM-ENTRIES(pcObjectName,CHR(3)) = 2 THEN
  ASSIGN
    cSDOBrowser = ENTRY(2, pcObjectName, CHR(3)).

/* 1st find smartobject to put on page - this must already exist */
FIND FIRST ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.OBJECT_filename = cObjectName
     NO-ERROR.

IF NOT AVAILABLE ryc_smartobject THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SmartObject'" cObjectName}. 
END.

ASSIGN lNoSDO = NO.

IF pcObjectType = "view":U THEN
DO:
  FIND FIRST gsc_object_type NO-LOCK
       WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj
       NO-ERROR.

  IF AVAILABLE gsc_object_type AND INDEX(gsc_object_type.OBJECT_type_code,"sdv":U) <> 0 THEN
    ASSIGN lSDV = YES.
  ELSE
    ASSIGN lSDV = NO.
END.
ELSE ASSIGN lSDV = YES.

DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

/* update object instance and instance attribute values */
trn-block:
DO FOR bryc_object_instance, bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_object_instance EXCLUSIVE-LOCK
       WHERE bryc_object_instance.container_smartobject_obj = pdContainer
         AND bryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
         AND bryc_object_instance.layout_position = pcLayoutPosition
       NO-ERROR.

  IF NOT AVAILABLE bryc_object_instance THEN
  DO:
    CREATE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_object_instance.container_smartobject_obj = pdContainer
      bryc_object_instance.smartobject_obj  = ryc_smartobject.smartobject_obj
      bryc_object_instance.layout_position = pcLayoutPosition
      bryc_object_instance.system_owned = NO
      .
    VALIDATE bryc_object_instance NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.

  /* Set-up return values */
  ASSIGN
    pdSmartObject = ryc_smartobject.smartobject_obj
    pdObjectType = ryc_smartobject.OBJECT_type_obj
    pdInstance = bryc_object_instance.OBJECT_instance_obj
    .

  /* now cascade attribute values down off smartobject onto instance - this will not
     override any customisations, i.e attributes that already exist but the inherrited
     value is set to NO
  */
  attribute-loop:
  FOR EACH ryc_attribute_value NO-LOCK
      WHERE ryc_attribute_value.object_type_obj           = pdObjectType
        AND ryc_attribute_value.smartobject_obj           = pdSmartObject
        AND ryc_attribute_value.OBJECT_instance_obj       = 0
        AND ryc_attribute_value.container_smartobject_obj = 0:

    FIND FIRST bryc_attribute_value EXCLUSIVE-LOCK
         WHERE bryc_attribute_value.object_type_obj = pdObjectType
           AND bryc_attribute_value.smartobject_obj = pdSmartObject
           AND bryc_attribute_value.object_instance_obj = pdInstance
           AND bryc_attribute_value.container_smartobject_obj = pdContainer
           AND bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
         NO-ERROR.           

    IF NOT AVAILABLE bryc_attribute_value THEN
    DO:
      CREATE bryc_attribute_value NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    END.

    ASSIGN
      bryc_attribute_value.object_type_obj = pdObjectType
      bryc_attribute_value.smartobject_obj = pdSmartObject
      bryc_attribute_value.object_instance_obj = pdInstance
      bryc_attribute_value.container_smartobject_obj = pdContainer
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdContainer
      bryc_attribute_value.decimal_value   = ryc_attribute_value.decimal_value  
      bryc_attribute_value.integer_value   = ryc_attribute_value.integer_value  
      bryc_attribute_value.date_value      = ryc_attribute_value.date_value     
      bryc_attribute_value.logical_value   = ryc_attribute_value.logical_value  
      bryc_attribute_value.character_value = ryc_attribute_value.character_value
      .

    VALIDATE bryc_attribute_value NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  END. /* attribute-loop */

  /* now update hard-code attribute values onto instance if set-up */
  ASSIGN
    cAttributeLabels = "":U
    cAttributeValues = "":U
    .

  IF cForeignFields <> "":U AND pcObjectType = "SDO":U OR pcObjectType = "SBO":U THEN
    ASSIGN
      cAttributeLabels = cAttributeLabels + (IF cAttributeLabels <> "":U THEN ",":U ELSE "":U) + "ForeignFields":U
      cAttributeValues = cAttributeValues + (IF cAttributeValues <> "":U THEN CHR(3) ELSE "":U) + cForeignFields
      .
  IF cLaunchContainer <> "":U AND pcObjectType = "brow":U THEN
    ASSIGN
      cAttributeLabels = cAttributeLabels + (IF cAttributeLabels <> "":U THEN ",":U ELSE "":U) + "FolderWindowToLaunch":U
      cAttributeValues = cAttributeValues + (IF cAttributeValues <> "":U THEN CHR(3) ELSE "":U) + cLaunchContainer
      .

  IF cWindowTitleField <> "":U AND (pcObjectType = "brow":U OR pcObjectType = "view":U)
     AND pcObjectName <> "rystatusbv.w":U AND lNoSDO = NO AND lSDV = YES THEN
    ASSIGN
      cAttributeLabels = cAttributeLabels + (IF cAttributeLabels <> "":U THEN ",":U ELSE "":U) + "WindowTitleField":U
      cAttributeValues = cAttributeValues + (IF cAttributeValues <> "":U THEN CHR(3) ELSE "":U) + cWindowTitleField
      .
  IF cSelectedFields <> "":U AND (pcObjectType = "brow":U OR pcObjectType = "view":U) THEN
  DO:
    ASSIGN
      cEnabledFields = ""
      cDisplayedFields = ""
      .
    DO iLoop = 1 TO NUM-ENTRIES(cSelectedFields, CHR(3)):
      ASSIGN
        cEntry = ENTRY(iLoop, cSelectedFields, CHR(3)).

      IF NUM-ENTRIES(cEntry, CHR(4)) = 3 THEN
      DO:
        ASSIGN
          cDisplayedFields = cDisplayedFields + 
                             (IF cDisplayedFields <> "":U THEN ",":U ELSE "":U) +
                             ENTRY(2, cEntry, CHR(4)).
        IF ENTRY(3, cEntry, CHR(4)) = "YES":U THEN
        DO:
          ASSIGN
            cEnabledFields = cEnabledFields + 
                             (IF cEnabledFields <> "":U THEN ",":U ELSE "":U) +
                             ENTRY(2, cEntry, CHR(4)).
        END.
      END.
    END.

    ASSIGN
      cAttributeLabels = cAttributeLabels + (IF cAttributeLabels <> "":U THEN ",":U ELSE "":U) + "DisplayedFields,EnabledFields":U
      cAttributeValues = cAttributeValues + (IF cAttributeValues <> "":U THEN CHR(3) ELSE "":U) + cDisplayedFields + CHR(3) + cEnabledFields
      .
  END.

  IF cAttributeLabels <> "":U THEN
  DO:
    RUN updateAttributeValues (INPUT pdObjectType,
                               INPUT pdSmartObject,
                               INPUT pdContainer,
                               INPUT pdInstance,
                               INPUT cAttributeLabels,
                               INPUT cAttributeValues).
    IF RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN cMessageList = RETURN-VALUE.
      UNDO trn-block, LEAVE trn-block. 
    END.
  END.
END. /* trn-block */

IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePage Procedure 
PROCEDURE updatePage :
/*------------------------------------------------------------------------------
  Purpose:     To add/update a container page
  Parameters:  input container object number
               input page number
               input page label
               input layout name
               output page object number
  Notes:       This routine assumes the security token to be the same as the
               page label. It also assumes all pages will be enabled in create,
               view and modify mode for now.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pdContainer                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  piPageNumber                    AS INTEGER    NO-UNDO.
DEFINE INPUT PARAMETER  pcPageLabel                     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayout                        AS CHARACTER  NO-UNDO.

/* validate layout specified */
FIND FIRST ryc_layout NO-LOCK
     WHERE ryc_layout.layout_name = pcLayout
     NO-ERROR.
IF NOT AVAILABLE ryc_layout THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Layout'" pcLayout}.      
END.

DEFINE BUFFER bryc_page FOR ryc_page.

ASSIGN cMessageList = "":U.

trn-block:
DO FOR bryc_page TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST bryc_page EXCLUSIVE-LOCK
       WHERE bryc_page.container_smartobject_obj = pdContainer
         AND bryc_page.PAGE_sequence = piPageNumber
       NO-ERROR.

  IF NOT AVAILABLE bryc_page THEN
  DO:
    CREATE bryc_page NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page.container_smartobject_obj = pdContainer
      bryc_page.PAGE_sequence = piPageNumber
      bryc_page.enable_on_create = YES
      bryc_page.enable_on_modify = YES
      bryc_page.enable_on_view = YES
      .
  END.

  ASSIGN
    bryc_page.page_label = pcPageLabel
    bryc_page.security_token = pcPageLabel
    bryc_page.layout_obj = ryc_layout.layout_obj 
    .
  VALIDATE bryc_page NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  FIND FIRST ttPage
       WHERE ttPage.iPageNumber = piPageNumber
       NO-ERROR.
  IF NOT AVAILABLE ttPage THEN
  DO:
    CREATE ttPage.
    ASSIGN ttPage.iPageNumber = piPageNumber.
  END.
  ASSIGN
    ttPage.dPageObj = bryc_page.PAGE_obj.

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePageObject Procedure 
PROCEDURE updatePageObject :
/*------------------------------------------------------------------------------
  Purpose:     To add/update an object instance on a container page
  Parameters:  input container object number
               input object instance object number
               input page object number
               input page object sequence
  Notes:       If the object sequence number already exists on the page, then
               only the object appearing in the sequence will be updated.
               Also, delete instance off container if exists with another
               sequence - for now we are assuming that an object instance can
               only appear once on a folder window.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdContainer                    AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdInstance                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdPage                         AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER piObjectSequence               AS INTEGER    NO-UNDO.

DEFINE BUFFER bryc_page_object FOR ryc_page_object.

ASSIGN cMessageList = "":U.

trn-block:
DO FOR bryc_page_object TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* Zap object from container - in cased moved page or sequence */
  FOR EACH bryc_page_object EXCLUSIVE-LOCK
     WHERE bryc_page_object.container_smartobject_obj = pdContainer
       AND bryc_page_object.object_instance_obj = pdInstance:
    DELETE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
  END.

  FIND FIRST bryc_page_object EXCLUSIVE-LOCK
       WHERE bryc_page_object.container_smartobject_obj = pdContainer
         AND bryc_page_object.PAGE_obj = pdPage
         AND bryc_page_object.PAGE_object_sequence = piObjectSequence
       NO-ERROR.

  IF NOT AVAILABLE bryc_page_object THEN
  DO:
    CREATE bryc_page_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_page_object.container_smartobject_obj = pdContainer
      bryc_page_object.PAGE_obj = pdPage
      bryc_page_object.PAGE_object_sequence = piObjectSequence
      .
  END.

  ASSIGN
    bryc_page_object.object_instance_obj = pdInstance
    .
  VALIDATE bryc_page_object NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateStaticObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateStaticObject Procedure 
PROCEDURE updateStaticObject :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create / update ICFDB
               ryc_smartobject records for static object passed in.
  Parameters:  input object type (valid gsc_object_type)
               input container flag YES/NO
               input object name
               input product module code
               input object path
               input object description
               input required DB list
               input sdo name if required
               output object number of smartobject created / updated
               output object type object number
  Notes:       Attribute values are cascaded down onto new smartobjects from the
               object type by the replication write trigger of the smartobject
               coded in rycsoreplw.i
               Errors are passed back in return value.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plContainer                 AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProductModuleCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectPath                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectDescription         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcRequiredDBList            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSDOName                   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.

DEFINE BUFFER b2ryc_smartobject FOR ryc_smartobject.

DEFINE VARIABLE cPhysicalObject                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dProductModule                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDO                                AS DECIMAL    NO-UNDO.

ASSIGN cMessageList = "":U.

/* find product module for object */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = pcProductModuleCode
     NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Product Module'" pcProductModuleCode}.   
END.
ELSE ASSIGN dProductModule = gsc_product_module.product_module_obj.

/* find object type for object */

FIND FIRST gsc_object_type NO-LOCK
     WHERE gsc_object_type.OBJECT_type_code = pcObjectType
     NO-ERROR.

IF NOT AVAILABLE gsc_object_type THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'Object Type'" pcObjectType}.   
END.
ELSE
    ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.

/* Find SDO name if passed in (viewers / browsers) */
IF pcSDOName <> "":U THEN
DO:
  FIND FIRST ryc_smartobject NO-LOCK
       WHERE ryc_smartobject.OBJECT_filename = pcSDOName
       NO-ERROR.

  IF NOT AVAILABLE ryc_smartobject THEN
  DO:
    RETURN {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'SDO Object'" pcSDOName}.   
  END.
  ELSE ASSIGN dSDO = ryc_smartobject.smartobject_obj.
END.
ELSE ASSIGN dSDO = 0.

trn-block:
DO FOR b2ryc_smartobject TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* Find existing object / create new one */

  FIND FIRST b2ryc_smartobject EXCLUSIVE-LOCK
       WHERE b2ryc_smartobject.object_filename = pcObjectName
       NO-ERROR.

  IF NOT AVAILABLE b2ryc_smartobject THEN
  DO:
    CREATE b2ryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    ASSIGN b2ryc_smartobject.object_filename = pcObjectName
           b2ryc_smartobject.DISABLED = NO
           b2ryc_smartobject.custom_smartobject_obj = 0
           b2ryc_smartobject.system_owned = NO
           b2ryc_smartobject.shutdown_message_text = "":U
           b2ryc_smartobject.template_smartobject = NO.
  END.
  ELSE DO:
      /* ObjType - The object exists already, if the object type is being changed, raise an error */

      IF b2ryc_smartobject.object_type_obj <> dObjectType THEN
          RETURN {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the repository object'" "'object types can not be updated once assigned'"}.
  END.

  /* Update ICFDB object details */

  ASSIGN b2ryc_smartobject.object_description = pcObjectDescription 
         b2ryc_smartobject.generic_object = NO
         b2ryc_smartobject.container_object = plContainer
         b2ryc_smartobject.object_path = pcObjectPath
         b2ryc_smartobject.object_type_obj = dObjectType
         b2ryc_smartobject.physical_smartobject_obj = 0
         b2ryc_smartobject.product_module_obj = dProductModule
         b2ryc_smartobject.required_db_list = pcRequiredDBList
         b2ryc_smartobject.runnable_from_menu = plContainer  
         b2ryc_smartobject.run_persistent = YES
         b2ryc_smartobject.run_when = "ANY":U
         b2ryc_smartobject.security_smartobject_obj = b2ryc_smartobject.smartobject_obj
         b2ryc_smartobject.static_object = YES
         b2ryc_smartobject.product_module_obj = dProductModule
         b2ryc_smartobject.layout_obj = 0
         b2ryc_smartobject.sdo_smartobject_obj = dSDO
         .

  VALIDATE b2ryc_smartobject NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN pdSmartObject = b2ryc_smartobject.smartobject_obj
         pdObjectType  = dObjectType.

END. /* trn-block */
IF cMessageList <> "":U THEN RETURN cMessageList.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateViewerLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateViewerLinks Procedure 
PROCEDURE updateViewerLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdContainer AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcLinkName  AS CHARACTER  NO-UNDO.

  /* Finally add data and group assign links and user links between viewers */
  DEFINE BUFFER bttViewer FOR ttViewer.
  DEFINE BUFFER bttSDO FOR ttSDO.

  FOR EACH ttViewer 
      WHERE ttViewer.lPrimary = YES:

    /* The non primary viewers need to link to the primary viewer's SDO as 
       data source and possibly update-target */ 
    FIND FIRST bttSDO 
         WHERE bttSDO.cSDOName = ttViewer.cSDOName NO-ERROR. 

    FOR EACH bttViewer 
        WHERE bttViewer.cSDOName = ttViewer.cSDOName
        AND   bttViewer.lPrimary = NO:

      RUN updateLink (INPUT "Data":U,
                      INPUT "":U,
                      INPUT pdContainer,
                      INPUT IF AVAIL bttSDO THEN bttSDO.dSDOObjectInstance ELSE 0,
                      INPUT bttViewer.dViewerObjectInstance).
      IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 

      /* If this is a regular SmartObject or an SBO that updates OneTOOne SDOs then 
          use groupAssign */ 
      IF NOT bttSDO.lSBO OR bttSDO.lOneToOneContainer THEN
      DO:
        RUN updateLink (INPUT "GroupAssign":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT bttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.
      ELSE DO:
        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT bttViewer.dViewerObjectInstance,
                        INPUT IF AVAIL bttSDO THEN bttSDO.dSDOObjectInstance ELSE 0).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.

      /* A viewer link name of 'GroupAssign' indicates SBO one-to-one across 
         pages in order to update the SDOs in a one-to-one and has been used to 
         set the lsssss flag on ttSDO */
      IF pcLinkName <> "":U AND pcLinkName <> 'GroupAssign':U THEN
      DO:
        RUN updateLink (INPUT pcLinkName,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT bttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE. 
      END.
    END.  /* for each bttViewer (child of ttViewer and primary = no) */ 
  END. /* for ttViewer where lPrimary*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

