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

&IF DEFINED(EXCLUDE-buildPageTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageTables Procedure 
PROCEDURE buildPageTables :
/*------------------------------------------------------------------------------
  Purpose:     Build temp-tables used for folder generation
  Parameters:  input folder wizard object number
               output table of sdo info on container
               output table of viewer info on container
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdFoldObj                AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttSDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttViewer.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE cViewerSDOList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowserSDOList                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSDO                            AS CHARACTER  NO-UNDO.

EMPTY TEMP-TABLE ttSDO.
EMPTY TEMP-TABLE ttViewer.
EMPTY TEMP-TABLE ttBrowser.

FIND FIRST brym_wizard_fold NO-LOCK WHERE brym_wizard_fold.wizard_fold_obj = pdFoldObj
     NO-ERROR.

FOR EACH rym_wizard_fold_page NO-LOCK
   WHERE rym_wizard_fold_page.wizard_fold_obj = pdFoldObj
      BY PAGE_number:

  /* Is the SDO there already ?
     NOTE: we also create a ttSDO when sdoname = '', which represents the SDO/SBO
     passed from the object container, we use this to store info for which 
     pass-thru links to create. */
  FIND FIRST ttSDO
       WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
       NO-ERROR.
  IF NOT AVAILABLE ttSDO THEN
  DO:
    CREATE ttSDO.
    ASSIGN
      ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
      ttSDO.iPageNumber = rym_wizard_fold_page.PAGE_number
      ttSDO.lForeignFields = rym_wizard_fold_page.sdo_foreign_fields <> "":U
      ttSDO.cParentSDO = rym_wizard_fold_page.parent_sdo_object_name
      ttSDO.dSDOSmartObject = 0
      ttSDO.dSDOObjectInstance = 0        
      .
  END.
  IF ttSDO.lForeignFields = NO AND rym_wizard_fold_page.sdo_foreign_fields <> "":U THEN
    ASSIGN ttSDO.lForeignFields = YES.
  IF ttSDO.cBrowserName = "":U AND rym_wizard_fold_page.browser_object_name <> "":U THEN
    ASSIGN ttSDO.cBrowserName = rym_wizard_fold_page.browser_object_name.


  /* Found a viewer */
  IF rym_wizard_fold_page.viewer_object_name <> "":U THEN
  DO:
    FIND FIRST ttViewer
         WHERE ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
         NO-ERROR.
    IF NOT AVAILABLE ttViewer THEN
    DO:
      CREATE ttViewer.
      ASSIGN
        ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
        ttViewer.iPageNumber = rym_wizard_fold_page.PAGE_number
        ttViewer.dViewerSmartObject = 0
        ttViewer.dViewerObjectInstance = 0        
        ttViewer.lPrimary = rym_wizard_fold_page.primary_viewer
        ttViewer.lLinkToSDO = rym_wizard_fold_page.link_viewer_to_sdo
        .
    END.
    IF ttViewer.cSDOName = "":U AND rym_wizard_fold_page.sdo_object_name <> "":U THEN
      ASSIGN ttViewer.cSDOName = rym_wizard_fold_page.sdo_object_name.
    IF ttViewer.lPrimary = NO AND rym_wizard_fold_page.primary_viewer = YES THEN
      ASSIGN ttViewer.lPrimary = YES.

    IF ttViewer.cSDOName <> "":U AND 
       LOOKUP(ttViewer.cSDOName, cViewerSDOList) = 0 THEN
      ASSIGN
        cViewerSDOList = cViewerSDOList + (IF cViewerSDOList <> "":U THEN ",":U ELSE "":U) +
                         ttViewer.cSDOName
        .
    ASSIGN
      /* We know it's a one-to-one if there's more than one of them OR the user has 'forced'       
         GroupAssign link between viewers, (a special case of viewer_link_name ) */   
      ttSDO.lOneToOneContainer = ttSDO.lOneToOneContainer  
                                 OR brym_wizard_fold.viewer_link_name = 'GroupAssign':U
                                 OR NUM-ENTRIES(rym_wizard_fold_page.viewer_update_target_names) > 1
      /* We know we have a Container (SBO) if any of the viewers defines UpdateTargetNames */
      ttSDO.lSBO              = ttSDO.lSBO OR rym_wizard_fold_page.viewer_update_target_names <> '':U
                                OR ttSDO.lOneToOneContainer
      ttSDO.lOneToManyContainer = ttSDO.lSBO AND NOT lOneToOneContainer
      /* We currently only use commit if it's a onetomany container and NOT onetoOne, 
         we keep it as separate info just to simplify a future independent change of this.. */ 
      ttSDO.lCommit       = ttSDO.lOneToManyContainer.
  END.

  /* Found a browser */
  IF rym_wizard_fold_page.browser_object_name <> "":U THEN
  DO:
    FIND FIRST ttBrowser
         WHERE ttBrowser.cBrowserName = rym_wizard_fold_page.browser_object_name
         NO-ERROR.
    IF NOT AVAILABLE ttBrowser THEN
    DO:
      CREATE ttBrowser.
      ASSIGN
        ttBrowser.cBrowserName = rym_wizard_fold_page.Browser_object_name
        ttBrowser.iPageNumber = rym_wizard_fold_page.PAGE_number
        ttBrowser.lToolbarRequired = NO
        ttBrowser.dBrowserSmartObject = 0
        ttBrowser.dBrowserObjectInstance = 0        
        .
    END.
    IF ttBrowser.cSDOName = "":U AND rym_wizard_fold_page.sdo_object_name <> "":U THEN
      ASSIGN ttBrowser.cSDOName = rym_wizard_fold_page.sdo_object_name.

    IF ttBrowser.cSDOName <> "":U AND 
       LOOKUP(ttBrowser.cSDOName, cBrowserSDOList) = 0 THEN
      ASSIGN
        cBrowserSDOList = cBrowserSDOList + (IF cBrowserSDOList <> "":U THEN ",":U ELSE "":U) +
                         ttBrowser.cSDOName
        .
  END.

END.

/* Check if browsers linked to sdo have foreign fields if not set yet */
FOR EACH ttSDO
   WHERE ttSDO.lForeignFields = NO AND ttSDO.cBrowserName <> "":U:

  FIND FIRST rym_wizard_brow NO-LOCK
       WHERE rym_wizard_brow.OBJECT_name = ttSDO.cBrowserName
       NO-ERROR.
  IF AVAILABLE rym_wizard_brow
     AND rym_wizard_brow.sdo_foreign_fields <> "":U THEN
    ASSIGN ttSDO.lForeignFields = YES.
END.

/* check at least 1 and only 1 primary viewer per SDO */
DO iLoop = 1 TO NUM-ENTRIES(cViewerSDOList):
  ASSIGN cSDO = ENTRY(iLoop, cViewerSDOList).

  /* ensure only 1 primary viewer per sdo */
  IF NOT CAN-FIND(ttViewer WHERE ttViewer.cSDOName = cSDO
                             AND ttViewer.lPrimary = YES) THEN
  FOR EACH ttViewer
     WHERE ttViewer.cSDOName = cSDO
       AND ttViewer.lPrimary = YES:
    ASSIGN ttViewer.lPrimary = NO.
  END.

  /* ensure 1 primary viewer per sdo */
  IF NOT CAN-FIND(FIRST ttViewer
                  WHERE ttViewer.cSDOName = cSDO
                    AND ttViewer.lPrimary = YES) THEN
  DO:
    FIND FIRST ttViewer
         WHERE ttViewer.cSDOName = cSDO
         NO-ERROR.
    IF AVAILABLE ttViewer THEN ASSIGN ttViewer.lPrimary = YES.
  END.

END.

/* See if browser has a viewer linked to sdo and if not, set browser
   to require a toolbar
*/
FOR EACH ttBrowser:
/*   IF NOT CAN-FIND(FIRST ttViewer                                     */
/*                   WHERE ttViewer.cSDOName = ttBrowser.cSDOName) THEN */
    ASSIGN ttBrowser.lToolbarRequired = YES.
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
  Notes:       Does not delete the gsc_object or ryc_smartobject records
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

&IF DEFINED(EXCLUDE-generateBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateBrowser Procedure 
PROCEDURE generateBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a dynamic browser object based on
               information in the Browser Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_brow FOR rym_wizard_brow.

DEFINE VARIABLE dBrowser                            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserType                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cEnabledFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_brow TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_brow EXCLUSIVE-LOCK
       WHERE brym_wizard_brow.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_brow THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Browser'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "brow":U,
                           INPUT brym_wizard_brow.product_module_code,
                           INPUT brym_wizard_brow.OBJECT_name,
                           INPUT brym_wizard_brow.OBJECT_description,
                           INPUT ENTRY(NUM-ENTRIES(brym_wizard_brow.sdo_name, "/":U), brym_wizard_brow.sdo_name, "/":U),
                           INPUT brym_wizard_brow.custom_super_procedure,
                           INPUT "":U,
                           OUTPUT dBrowser,
                           OUTPUT dBrowserType).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Assign browser attribute values */
  ASSIGN
    cAttributeLabels = "FolderWindowToLaunch,WindowTitleField":U
    cAttributeValues = brym_wizard_brow.launch_container + CHR(3) + brym_wizard_brow.WINDOW_title_field
    cEnabledFields = ""
    cDisplayedFields = ""
    .

  DO iLoop = 1 TO NUM-ENTRIES(brym_wizard_brow.SELECTED_fields, CHR(3)):
    ASSIGN
      cEntry = ENTRY(iLoop, brym_wizard_brow.SELECTED_fields, CHR(3)).

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
    cAttributeLabels = cAttributeLabels + ",DisplayedFields,EnabledFields":U
    cAttributeValues = cAttributeValues + CHR(3) + cDisplayedFields +
                                          CHR(3) + cEnabledFields
    .

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dBrowserType,
                             INPUT dBrowser,
                             INPUT 0,
                             INPUT 0,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_brow.generated_date = TODAY
    brym_wizard_brow.generated_time = TIME
    .
  VALIDATE brym_wizard_brow NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateFolderPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateFolderPages Procedure 
PROCEDURE generateFolderPages :
/*------------------------------------------------------------------------------
  Purpose:     Generate folder wizard pages
  Parameters:  input folder object name
               input container object number
               input container toolbar instance object number
               output error message text if any
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcObjectName                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pdContainer                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdContainerToolbarInstance   AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerToolbarInstance              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserToolbarInstance             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserInstance                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDOInstance                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLayout                             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iSequence                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

EMPTY TEMP-TABLE ttPage.

ASSIGN
  pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_fold TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  FIND FIRST brym_wizard_fold NO-LOCK
       WHERE brym_wizard_fold.OBJECT_name = pcObjectName
       NO-ERROR.

  RUN buildPageTables (INPUT brym_wizard_fold.wizard_fold_obj,
                       OUTPUT TABLE ttSDO,
                       OUTPUT TABLE ttViewer).

  FOR EACH rym_wizard_fold_page NO-LOCK
     WHERE rym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
        BY rym_wizard_fold_page.PAGE_number:

    ASSIGN cLayout = rym_wizard_fold_page.PAGE_layout.
    IF cLayout = "":U THEN
      ASSIGN cLayout = brym_wizard_fold.PAGE_layout.
    IF cLayout = "":U THEN 
      ASSIGN cLayout = "Top/Multi/Bottom":U.

    RUN updatePage (INPUT pdContainer,
                    INPUT rym_wizard_fold_page.PAGE_number,
                    INPUT rym_wizard_fold_page.PAGE_label,
                    INPUT cLayout).   
    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.

  /* Add SDO's */
  RUN addSDOsToPage (INPUT pcObjectName,
                     INPUT pdContainer,
                     OUTPUT pcErrorText).
  IF pcErrorText <> "":U THEN DO: UNDO tran-block, LEAVE tran-block. END.

  ASSIGN iSequence = 199.
  page-loop:
  FOR EACH rym_wizard_fold_page NO-LOCK
     WHERE rym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
        BY rym_wizard_fold_page.PAGE_number:

    FIND FIRST ttPage WHERE ttPage.iPageNumber = rym_wizard_fold_page.PAGE_number.

    FIND FIRST ttSDO 
         WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
         NO-ERROR.

        /* create object instances on page */
    IF LENGTH(rym_wizard_fold_page.browser_object_name) > 0 THEN
    DO: /* browser on page */
      /* Add browser */
      RUN updateObjectInstance (INPUT pcObjectName,
                                INPUT pdContainer,
                                INPUT rym_wizard_fold_page.browser_object_name,
                                INPUT "centre2,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                INPUT "brow":U,
                                OUTPUT dSmartObject,
                                OUTPUT dObjectType,
                                OUTPUT dBrowserInstance).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* Force all fields in browser to disabled for now, 
         also set DataSourceNames, which indicates the SDO query when linked to an SBO */
      ASSIGN
        cAttributeLabels = "EnabledFields,DataSourceNames":U

        cAttributeValues = "":U + CHR(3)
                         + rym_wizard_fold_page.query_sdo_name 
        .
      RUN updateAttributeValues (INPUT dObjectType,
                                 INPUT dSmartObject,
                                 INPUT pdContainer,
                                 INPUT dBrowserInstance,
                                 INPUT cAttributeLabels,
                                 INPUT cAttributeValues).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* update browser temp-table */
      FIND FIRST ttBrowser 
           WHERE ttBrowser.cBrowserName = rym_wizard_fold_page.Browser_object_name
           NO-ERROR.
      IF NOT AVAILABLE ttBrowser THEN
      DO:
        ASSIGN pcErrorText = "Browser not found in temp table: " + rym_wizard_fold_page.browser_object_name.
        UNDO tran-block, LEAVE tran-block.
      END.

      ASSIGN
        ttBrowser.dBrowserSmartObject = dSmartObject
        ttBrowser.dBrowserObjectInstance = dBrowserInstance
        .


      /* Add toolbar on Browser page if required */
      IF ttBrowser.lToolbarRequired = YES AND ttBrowser.cSDOName <> "":U THEN
      DO:
        RUN updateObjectInstance (INPUT pcObjectName,
                                  INPUT pdContainer,
                                  INPUT "BrowseToolbar":U,
                                  INPUT "bottom,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                  INPUT "tool":U,
                                  OUTPUT dSmartObject,
                                  OUTPUT dObjectType,
                                  OUTPUT dBrowserToolbarInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        ASSIGN
          cAttributeLabels = "EdgePixels,ToolbarParentMenu,ToolbarAutoSize":U
          cAttributeValues = "1":U + CHR(3) 
                           + rym_wizard_fold_page.browser_toolbar_parent_menu + CHR(3) 
                           + "no":U.

        RUN updateAttributeValues (INPUT dObjectType,
                                   INPUT dSmartObject,
                                   INPUT pdContainer,
                                   INPUT dBrowserToolbarInstance,
                                   INPUT cAttributeLabels,
                                   INPUT cAttributeValues).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        ASSIGN iSequence = iSequence + 1.
        RUN updatePageObject(INPUT pdContainer,
                             INPUT dBrowserToolbarInstance,
                             INPUT ttPage.dPageObj,
                             INPUT iSequence).    
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
      ELSE ASSIGN dBrowserToolbarInstance = 0.

      /* Add links for browser, from browser sdo and toolbar? */
      IF AVAILABLE ttSDO THEN
      DO:
        RUN updateLink (INPUT "data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttSDO.dSDOObjectInstance,
                        INPUT dBrowserInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        IF dBrowserToolbarInstance <> 0 THEN
        DO:
          RUN updateLink (INPUT "navigation":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dBrowserToolbarInstance,
                          INPUT ttSDO.dSDOObjectInstance).
          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
          RUN updateLink (INPUT "update":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dBrowserInstance,
                          INPUT ttSDO.dSDOObjectInstance).
          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        END.
      END.

      IF dBrowserToolbarInstance <> 0 THEN
      DO:
        RUN updateLink (INPUT "toolbar":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dBrowserToolbarInstance,
                        INPUT dBrowserInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.

      /* Add page object records */
      ASSIGN iSequence = iSequence + 1.
      RUN updatePageObject(INPUT pdContainer,
                           INPUT dBrowserInstance,
                           INPUT ttPage.dPageObj,
                           INPUT iSequence).    
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
    END. /* browser on page */

    IF LENGTH(rym_wizard_fold_page.viewer_object_name) > 0 THEN
    DO: /* viewer on page */
      /* add viewer */
      RUN updateObjectInstance (INPUT pcObjectName,
                                INPUT pdContainer,
                                INPUT rym_wizard_fold_page.viewer_object_name,
                                INPUT "centre1,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                INPUT "view":U,
                                OUTPUT dSmartObject,
                                OUTPUT dObjectType,
                                OUTPUT dViewerInstance).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      ASSIGN
        cAttributeLabels = "DataSourceNames,UpdateTargetNames":U
        cAttributeValues =  rym_wizard_fold_page.viewer_data_source_names + CHR(3) 
                            + rym_wizard_fold_page.viewer_update_target_names. 

      RUN updateAttributeValues (INPUT dObjectType,
                                 INPUT dSmartObject,
                                 INPUT pdContainer,
                                 INPUT dViewerInstance,
                                 INPUT cAttributeLabels,
                                 INPUT cAttributeValues).
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* update viewer temp-table */
      FIND FIRST ttViewer 
           WHERE ttViewer.cViewerName = rym_wizard_fold_page.viewer_object_name
           NO-ERROR.
      IF NOT AVAILABLE ttViewer THEN
      DO:
        ASSIGN pcErrorText = "Viewer not found in temp table: " + rym_wizard_fold_page.viewer_object_name.
        UNDO tran-block, LEAVE tran-block.
      END.
      ASSIGN
        ttViewer.dViewerSmartObject = dSmartObject
        ttViewer.dViewerObjectInstance = dViewerInstance
        .

      /* Add toolbar on viewer page if required; 
         - Primary viewer with a specified SDO (Not SBO). 
         - Secondary viewer for one-to-many SBO */
      IF (ttViewer.cSDOName <> "":U AND ttViewer.lPrimary AND NOT (AVAIL ttSDO AND ttSDO.lSBO))  
      OR (NOT ttViewer.lPrimary AND (AVAIL ttSDO AND ttSDO.lOneToManyContainer)) THEN
      DO:        
        RUN updateObjectInstance (INPUT pcObjectName,
                                  INPUT pdContainer,
                                  INPUT "FolderPageTop":U,
                                  INPUT "top,":U + STRING(rym_wizard_fold_page.PAGE_number),
                                  INPUT "tool":U,
                                  OUTPUT dSmartObject,
                                  OUTPUT dObjectType,
                                  OUTPUT dViewerToolbarInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        ASSIGN
          cAttributeLabels = "ToolbarParentMenu,ToolbarAutoSize":U
                             /* Add NavigationTarget if navigating an SBO */ 
          cAttributeValues =  rym_wizard_fold_page.viewer_toolbar_parent_menu + CHR(3)
                              + "no":U
          .

        /* If navigatying an SBO ensure the navigation target matches the viewer */
        IF (AVAIL ttSDO AND ttSDO.lSBO) THEN
         ASSIGN
           cAttributeLabels = cAttributeLabels + ',':U + "NavigationTargetName":U
           cAttributeValues = cAttributeValues + CHR(3) 
                                 + IF rym_wizard_fold_page.viewer_update_target_names <> '':U
                                   THEN ENTRY(1,rym_wizard_fold_page.viewer_update_target_names)
                                   ELSE ENTRY(1,rym_wizard_fold_page.viewer_data_source_names). 

        RUN updateAttributeValues (INPUT dObjectType,
                                   INPUT dSmartObject,
                                   INPUT pdContainer,
                                   INPUT dViewerToolbarInstance,
                                   INPUT cAttributeLabels,
                                   INPUT cAttributeValues).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        ASSIGN iSequence = iSequence + 1.
        RUN updatePageObject(INPUT pdContainer,
                             INPUT dViewerToolbarInstance,
                             INPUT ttPage.dPageObj,
                             INPUT iSequence).    
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
      ELSE ASSIGN dViewerToolbarInstance = 0.

      /* Add viewer page object record */
      ASSIGN iSequence = iSequence + 1.
      RUN updatePageObject(INPUT pdContainer,
                           INPUT ttViewer.dViewerObjectInstance,
                           INPUT ttPage.dPageObj,
                           INPUT iSequence).    
      IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

      /* Add viewer related links */

      /* Find viewer linked SDO if applicable */
      FIND FIRST ttSDO
           WHERE ttSDO.cSDOName = rym_wizard_fold_page.sdo_object_name
           NO-ERROR.

      IF dViewerToolbarInstance <> 0 THEN
      DO:
        RUN updateLink (INPUT "TableIO":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dViewerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).

        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        RUN updateLink (INPUT "Toolbar":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT dViewerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).

        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        IF AVAILABLE ttSDO AND ttSDO.dSDOObjectInstance <> 0 THEN
        DO:
          RUN updateLink (INPUT "Navigation":U,
                          INPUT "":U,
                          INPUT pdContainer,
                          INPUT dViewerToolbarInstance,
                          INPUT ttSDO.dSDOObjectInstance).

          IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        END.
      END.

      IF AVAILABLE ttSDO AND ttSDO.dSDOObjectInstance <> 0 AND NOT (ttViewer.lLinkToSDO = NO) THEN
      DO:
        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT ttSDO.dSDOObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
        RUN updateLink (INPUT "Data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttSDO.dSDOObjectInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.

      /* Tableio to top panel if primary viwer and sdo is blank OR always if we are using an sbo */
      IF ttViewer.lPrimary = YES 
      AND (ttViewer.cSDOName = "":U OR (AVAIL ttSDO AND ttSDO.lSBO))  THEN
      DO:
        RUN updateLink (INPUT "TableIO":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT pdContainerToolbarInstance,
                        INPUT ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.        
      END.

      IF brym_wizard_fold.no_sdo = NO AND ttViewer.lPrimary = YES AND ttViewer.cSDOName = "":U THEN
      DO:
        RUN updateLink (INPUT "Data":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT 0,
                        INPUT  ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        RUN updateLink (INPUT "ToggleData":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT 0,
                        INPUT  ttViewer.dViewerObjectInstance).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

        RUN updateLink (INPUT "Update":U,
                        INPUT "":U,
                        INPUT pdContainer,
                        INPUT ttViewer.dViewerObjectInstance,
                        INPUT 0).
        IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
      END.
    END. /* viewer on page */

  END.  /* page-loop */

  RUN updateViewerLinks (INPUT pdContainer,
                         INPUT brym_wizard_fold.viewer_link_name). 

  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateFolderWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateFolderWindow Procedure 
PROCEDURE generateFolderWindow :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a folder window object based on
               information in the Folder Window Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerToolbarInstance           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFolderInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN
  pcErrorText = "":U
  .

tran-block:
DO FOR brym_wizard_fold TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_fold EXCLUSIVE-LOCK
       WHERE brym_wizard_fold.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_fold THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Folder Window'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "fold":U,
                           INPUT brym_wizard_fold.product_module_code,
                           INPUT brym_wizard_fold.OBJECT_name,
                           INPUT brym_wizard_fold.OBJECT_description,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT brym_wizard_fold.PAGE_layout,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'WindowName,ContainerMode',
                             INPUT brym_wizard_fold.WINDOW_title + CHR(3) + brym_wizard_fold.DEFAULT_mode).
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
                            INPUT IF brym_wizard_fold.no_sdo = YES
                                  THEN "FolderTopNoSDO":U
                                  ELSE "FolderTop":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dContainerToolbarInstance).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.


  /* Now add folder page information */
  RUN generateFolderPages (INPUT pcObjectName,
                           INPUT dContainer,
                           INPUT dContainerToolbarInstance,
                           OUTPUT pcErrorText).
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

  /* We need to find the SDO/SBO record created to store info for the 
     Pass-thru object controller to see if we need to add the commit band */ 
  FIND FIRST ttSDO WHERE ttSDO.cParentSDO = '':U NO-ERROR. 

  /*
  IF AVAIL ttSDO AND NOT ttSDO.lCommit THEN
  DO:
     
    ASSIGN
      cAttributeLabels = "HiddenToolbarBands,HiddenMenuBands":U
      cAttributeValues = "Transaction":U + CHR(3) + "Transaction":U.
     
    RUN updateAttributeValues (INPUT dObjectType,
                               INPUT dSmartObject,
                               INPUT dContainer,
                               INPUT dContainerToolbarInstance,
                               INPUT cAttributeLabels,
                               INPUT cAttributeValues).

    IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.
  */

  IF AVAIL ttSDO AND ttSDO.lCommit THEN
  DO:
     RUN updateLink (INPUT "Commit":U,
                     INPUT "":U,
                     INPUT dContainer,
                     INPUT dContainerToolbarInstance,
                     INPUT ttSDO.dSDOObjectInstance).
     IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.
  END.

  /* Set-up standard folder links */
  RUN updateLink (INPUT "page":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dFolderInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  RUN updateLink (INPUT "toolbar":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).
  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.

  RUN updateLink (INPUT "navigation":U,
                  INPUT "":U,
                  INPUT dContainer,
                  INPUT dContainerToolbarInstance,
                  INPUT 0).

  IF RETURN-VALUE <> "":U THEN DO: ASSIGN pcErrorText = RETURN-VALUE. UNDO tran-block, LEAVE tran-block. END.


  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_fold.generated_date = TODAY
    brym_wizard_fold.generated_time = TIME
    .
  VALIDATE brym_wizard_fold NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateMenuController) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateMenuController Procedure 
PROCEDURE generateMenuController :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a menu controller object based on
               information in the Menu Controller Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_menc FOR rym_wizard_menc.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dToolbarInstance                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dStatusbarInstance                  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_menc TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_menc EXCLUSIVE-LOCK
       WHERE brym_wizard_menc.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_menc THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Menu Controller'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "menc":U,
                           INPUT brym_wizard_menc.product_module_code,
                           INPUT brym_wizard_menc.OBJECT_name,
                           INPUT brym_wizard_menc.OBJECT_description,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT "Top/Center/Bottom":U,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'WindowName',
                             INPUT brym_wizard_menc.WINDOW_title).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Now add object instances to container - a menu controller has a toolbar
     at the top and a statusbar viewer at the bottom
  */

  /* Add toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "MenuController":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dToolbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /*
  ASSIGN
    cAttributeLabels = "":U
    cAttributeValues = "":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.
  */

  /* Add status bar viewer */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "rystatusbv.w":U,
                            INPUT "bottom":U,
                            INPUT "view":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dStatusbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Add links */
  RUN updateLink (INPUT "toolbar":U,          /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dToolbarInstance,     /* from instance, 0 = container */
                  INPUT 0).                   /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_menc.generated_date = TODAY
    brym_wizard_menc.generated_time = TIME
    .
  VALIDATE brym_wizard_menc NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateObjectController) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateObjectController Procedure 
PROCEDURE generateObjectController :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate an object controller object based on
               information in the Object Controller Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_objc FOR rym_wizard_objc.
DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

DEFINE VARIABLE dContainer                          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dContainerType                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSmartObject                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dObjectType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTopToolbarInstance                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBottomToolbarInstance              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerInstance                     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dBrowserInstance                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSDOInstance                        AS DECIMAL    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_objc TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_objc EXCLUSIVE-LOCK
       WHERE brym_wizard_objc.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_objc THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'Object Controller'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "objc":U,
                           INPUT brym_wizard_objc.product_module_code,
                           INPUT brym_wizard_objc.OBJECT_name,
                           INPUT brym_wizard_objc.OBJECT_description,
                           INPUT "":U,
                           INPUT "":U,
                           INPUT brym_wizard_objc.PAGE_layout,
                           OUTPUT dContainer,
                           OUTPUT dContainerType).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dContainerType,
                             INPUT dContainer,
                             INPUT 0,
                             INPUT 0,
                             INPUT 'WindowName',
                             INPUT brym_wizard_objc.WINDOW_title).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Now add object instances to container.
     An object controller has a top toolbar, a browser, an sdo, and a
     bottom toolbar.
  */

  /* add SDO */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT brym_wizard_objc.sdo_name + CHR(3) + brym_wizard_objc.browser_name,
                            INPUT "":U,
                            INPUT "sdo":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dSDOInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Add viewer if there is one */
  IF LENGTH(brym_wizard_objc.viewer_name) > 0 THEN
  DO:
    RUN updateObjectInstance (INPUT pcObjectName,
                              INPUT dContainer,
                              INPUT brym_wizard_objc.viewer_name,
                              INPUT "centre1":U,
                              INPUT "view":U,
                              OUTPUT dSmartObject,
                              OUTPUT dObjectType,
                              OUTPUT dViewerInstance).
    IF RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN pcErrorText = RETURN-VALUE.
      UNDO tran-block, LEAVE tran-block. 
    END.
  END.

  /* add browser */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT brym_wizard_objc.browser_name,
                            INPUT "centre2":U,
                            INPUT "brow":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dBrowserInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* For browsers on object controllers - update DataSourceNames */
  IF LENGTH(brym_wizard_objc.query_sdo_name) > 0 THEN
  DO:
    /* For browsers on object controllers - ensure all fields disabled */
    ASSIGN
      cAttributeLabels = 'DataSourceNames':U
      cAttributeValues = brym_wizard_objc.query_sdo_name
      .

    RUN updateAttributeValues (INPUT dObjectType,
                               INPUT dSmartObject,
                               INPUT dContainer,
                               INPUT dBrowserInstance,
                               INPUT cAttributeLabels,
                               INPUT cAttributeValues).
    IF RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN pcErrorText = RETURN-VALUE.
      UNDO tran-block, LEAVE tran-block. 
    END.
  END.

  /* For browsers on object controllers - ensure all fields disabled */
  ASSIGN
    cAttributeLabels = "EnabledFields":U
    cAttributeValues = "":U
    .

  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dBrowserInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).

  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Add top toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "ObjcTop":U,
                            INPUT "top":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dTopToolbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.
  /*
  ASSIGN
    cAttributeLabels = "ToolbarBands":U
    cAttributeValues = "Adm2Navigation,txtaction,AstraHelp,AstraWindow,AstraAbout,AstraMenuExit,DynamicMenu":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dTopToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.
  */

  /* Add bottom toolbar and set attributes */
  RUN updateObjectInstance (INPUT pcObjectName,
                            INPUT dContainer,
                            INPUT "BrowseToolbar":U,
                            INPUT "bottom":U,
                            INPUT "tool":U,
                            OUTPUT dSmartObject,
                            OUTPUT dObjectType,
                            OUTPUT dBottomToolbarInstance).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  ASSIGN
    cAttributeLabels = "EdgePixels,ToolbarParentMenu,ToolbarAutoSize":U
    cAttributeValues = "1":U + CHR(3) 
                        + brym_wizard_objc.browser_toolbar_parent_menu + CHR(3)
                        + "no":U
    .
  RUN updateAttributeValues (INPUT dObjectType,
                             INPUT dSmartObject,
                             INPUT dContainer,
                             INPUT dBottomToolbarInstance,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

/* Add links */
  RUN updateLink (INPUT "PrimarySDO":U,       /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT 0,                    /* from instance, 0 = container */
                  INPUT dSDOInstance).        /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  RUN updateLink (INPUT "toolbar":U,          /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dTopToolbarInstance,  /* from instance, 0 = container */
                  INPUT 0).                   /* to instance, 0 = container */                   

  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  RUN updateLink (INPUT "navigation":U,         /* link name */
                  INPUT "":U,                   /* user defined link name */
                  INPUT dContainer,             /* handle of container */
                  INPUT dBottomToolbarInstance, /* from instance, 0 = container */
                  INPUT dSDOInstance).          /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  RUN updateLink (INPUT "toolbar":U,            /* link name */
                  INPUT "":U,                   /* user defined link name */
                  INPUT dContainer,             /* handle of container */
                  INPUT dBottomToolbarInstance, /* from instance, 0 = container */
                  INPUT dBrowserInstance).      /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  RUN updateLink (INPUT "data":U,             /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dSDOInstance,         /* from instance, 0 = container */
                  INPUT dBrowserInstance).    /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  RUN updateLink (INPUT "update":U,           /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dBrowserInstance,     /* from instance, 0 = container */
                  INPUT dSDOInstance).        /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF LENGTH(brym_wizard_objc.viewer_name) > 0 THEN
  DO:
    RUN updateLink (INPUT "data":U,             /* link name */
                    INPUT "":U,                 /* user defined link name */
                    INPUT dContainer,           /* handle of container */
                    INPUT dSDOInstance,         /* from instance, 0 = container */
                    INPUT dViewerInstance).     /* to instance, 0 = container */                   
    IF RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN pcErrorText = RETURN-VALUE.
      UNDO tran-block, LEAVE tran-block. 
    END.
    RUN updateLink (INPUT "user1":U,            /* link name */
                    INPUT "":U,                 /* user defined link name */
                    INPUT dContainer,           /* handle of container */
                    INPUT dViewerInstance,      /* from instance, 0 = container */
                    INPUT dBrowserInstance).    /* to instance, 0 = container */                   
    IF RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN pcErrorText = RETURN-VALUE.
      UNDO tran-block, LEAVE tran-block. 
    END.
  END.

/*   IF LENGTH(brym_wizard_objc.sdo_foreign_fields) > 0 THEN                          */
/*   DO:                                                                              */
/*     RUN updateLink (INPUT "ToggleData":U,       /* link name */                    */
/*                     INPUT "":U,                 /* user defined link name */       */
/*                     INPUT dContainer,           /* handle of container */          */
/*                     INPUT 0,                    /* from instance, 0 = container */ */
/*                     INPUT dSDOInstance).        /* to instance, 0 = container */   */
/*     IF RETURN-VALUE <> "":U THEN                                                   */
/*     DO:                                                                            */
/*       ASSIGN pcErrorText = RETURN-VALUE.                                           */
/*       UNDO tran-block, LEAVE tran-block.                                           */
/*     END.                                                                           */
/*   END.                                                                             */

  RUN updateLink (INPUT "navigation":U,       /* link name */
                  INPUT "":U,                 /* user defined link name */
                  INPUT dContainer,           /* handle of container */
                  INPUT dTopToolbarInstance,  /* from instance, 0 = container */
                  INPUT 0).                   /* to instance, 0 = container */                   
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_objc.generated_date = TODAY
    brym_wizard_objc.generated_time = TIME
    .
  VALIDATE brym_wizard_objc NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  pcErrorText = cMessageList.
  IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

END. /* tran-block */

RETURN.
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
  
  /* create / update gsc_object and ryc_smartobject records */
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

&IF DEFINED(EXCLUDE-generateViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateViewer Procedure 
PROCEDURE generateViewer :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to forward generate a dynamic viewer object based on
               information in the viewer Wizard table.
  Parameters:  input object name
               input delete object first
               output structured error message text (if failed)
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plDeleteFirst               AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText                 AS CHARACTER  NO-UNDO.

DEFINE BUFFER brym_wizard_view FOR rym_wizard_view.

DEFINE VARIABLE dViewer                             AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dViewerType                         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cAttributeLabels                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValues                    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cEnabledFields                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.

ASSIGN pcErrorText = "":U.

tran-block:
DO FOR brym_wizard_view TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:

  /* locate wizard data */
  FIND FIRST brym_wizard_view EXCLUSIVE-LOCK
       WHERE brym_wizard_view.OBJECT_name = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE brym_wizard_view THEN
  DO:
    ASSIGN pcErrorText = {af/sup2/aferrortxt.i 'RY' '2' '?' '?' pcObjectName "'viewer'"}.
    UNDO tran-block, LEAVE tran-block. 
  END.

  IF plDeleteFirst THEN
  DO:
    RUN deleteObjectFirst (INPUT pcObjectName, OUTPUT pcErrorText).
    IF pcErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  /* create / update gsc_object and ryc_smartobject records */
  RUN updateDynamicObject (INPUT "view":U,
                           INPUT brym_wizard_view.product_module_code,
                           INPUT brym_wizard_view.OBJECT_name,
                           INPUT brym_wizard_view.OBJECT_description,
                           INPUT "":U,
                           INPUT brym_wizard_view.custom_super_procedure,
                           INPUT "":U,
                           OUTPUT dviewer,
                           OUTPUT dviewerType).
  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Assign viewer attribute values */
  ASSIGN
    cEnabledFields = ""
    cDisplayedFields = ""
    .

  DO iLoop = 1 TO NUM-ENTRIES(brym_wizard_view.SELECTED_fields, CHR(3)):
    ASSIGN
      cEntry = ENTRY(iLoop, brym_wizard_view.SELECTED_fields, CHR(3)).
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
    cAttributeLabels = "WindowTitleField,DisplayedFields,EnabledFields":U
    cAttributeValues = brym_wizard_view.window_title_field + CHR(3) + cDisplayedFields + CHR(3) + cEnabledFields
    .

  /* Update attribute values */
  RUN updateAttributeValues (INPUT dViewerType,
                             INPUT dViewer,
                             INPUT 0,
                             INPUT 0,
                             INPUT cAttributeLabels,
                             INPUT cAttributeValues).

  IF RETURN-VALUE <> "":U THEN
  DO:
    ASSIGN pcErrorText = RETURN-VALUE.
    UNDO tran-block, LEAVE tran-block. 
  END.

  /* Finally update generated date and time onto wizard data */
  ASSIGN
    brym_wizard_view.generated_date = TODAY
    brym_wizard_view.generated_time = TIME
    .
  VALIDATE brym_wizard_view NO-ERROR.
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
        bryc_attribute_value.attribute_group_obj = ryc_attribute.attribute_group_obj
        bryc_attribute_value.attribute_type_tla = ryc_attribute.attribute_type_tla
        bryc_attribute_value.constant_value = NO
        .        
      IF bryc_attribute_value.container_smartobject_obj > 0 THEN
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.container_smartobject_obj.
      ELSE
        ASSIGN bryc_attribute_value.primary_smartobject_obj = bryc_attribute_value.smartobject_obj.
    END.

    ASSIGN
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.attribute_value = cAttributeValue
      bryc_attribute_value.inheritted_value = NO
      .

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
  Purpose:     Procedure to create / update ASDB gsc_object and RYDB
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

DEFINE INPUT PARAMETER  pcObjectType                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProductModuleCode         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectDescription         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSDOName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcSuper                     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcLayout                    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdSmartObject               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdObjectType                AS DECIMAL    NO-UNDO.

DEFINE BUFFER bgsc_object FOR gsc_object.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
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
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Top/Center/Bottom":U)
      .
  END.
  WHEN "objc":U THEN  /* object controller */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyncontw.w":U
      cObjectType = "dynobjc":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Top/Multi/Bottom":U)
      .
  END.
  WHEN "fold":U THEN  /* folder window */
  DO:
    ASSIGN
      lContainer = YES
      cPhysicalObject = "rydyncontw.w":U
      cObjectType = "dynfold":U
      cLayout = (IF pcLayout <> "":U THEN pcLayout ELSE "Top/Multi/Bottom":U)
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
FIND FIRST gsc_object NO-LOCK
     WHERE gsc_object.OBJECT_filename = cPhysicalObject
     NO-ERROR.
IF NOT AVAILABLE gsc_object THEN
DO:
  RETURN {af/sup2/aferrortxt.i 'RY' '3' '?' '?' cPhysicalObject}.   
END.
ELSE ASSIGN dPhysicalObject = gsc_object.OBJECT_obj.

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
DO FOR bgsc_object, bryc_smartobject, bryc_attribute_value TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* find existing ASDB object / create new one */
  FIND FIRST bgsc_object EXCLUSIVE-LOCK
       WHERE bgsc_object.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE bgsc_object THEN
  DO:
    CREATE bgsc_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    ASSIGN
      bgsc_object.object_filename = pcObjectName
      bgsc_object.DISABLED = NO
      .      
  END.

  /* Update ASDB object details */
  ASSIGN
    bgsc_object.object_description = pcObjectDescription 
    bgsc_object.logical_object = YES
    bgsc_object.generic_object = NO
    bgsc_object.container_object = lContainer
    bgsc_object.object_path = "":U
    bgsc_object.object_type_obj = dObjectType
    bgsc_object.physical_object_obj = dPhysicalObject
    bgsc_object.product_module_obj = dProductModule
    bgsc_object.required_db_list = "":U
    bgsc_object.runnable_from_menu = lContainer  
    bgsc_object.run_persistent = YES
    bgsc_object.run_when = "ANY":U
    bgsc_object.security_object_obj = bgsc_object.object_obj
    bgsc_object.toolbar_image_filename = "":U
    bgsc_object.toolbar_multi_media_obj = 0
    bgsc_object.tooltip_text = "":U
    .
  VALIDATE bgsc_object NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  /* Find/create RYDB repository object */
  FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.

  IF NOT AVAILABLE bryc_smartobject THEN
  DO:
    CREATE bryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_smartobject.object_filename = pcObjectName
      bryc_smartobject.system_owned = NO
      bryc_smartobject.shutdown_message_text = "":U
      bryc_smartobject.template_smartobject = NO
      .      
  END.

  /* Update rest of details */
  ASSIGN
    bryc_smartobject.static_object = NO
    bryc_smartobject.product_module_obj = dProductModule
    bryc_smartobject.layout_obj = dLayout
    bryc_smartobject.object_obj = bgsc_object.OBJECT_obj
    bryc_smartobject.object_type_obj = dObjectType
    bryc_smartobject.sdo_smartobject_obj = dSDO
    bryc_smartobject.custom_super_procedure = pcSuper
    .  
  VALIDATE bryc_smartobject NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    pdSmartObject = bryc_smartobject.smartobject_obj
    pdObjectType = dObjectType
    .

  /* now cascade attribute values down off object type, updating them if they
     already exist.
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

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

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
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdSmartObject
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
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

DEFINE BUFFER brym_wizard_objc FOR rym_wizard_objc.
DEFINE BUFFER brym_wizard_fold FOR rym_wizard_fold.
DEFINE BUFFER brym_wizard_fold_page FOR rym_wizard_fold_page.
DEFINE BUFFER brym_wizard_brow FOR rym_wizard_brow.
DEFINE BUFFER brym_wizard_view FOR rym_wizard_view.
DEFINE BUFFER bryc_object_instance FOR ryc_object_instance.
DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

/* use hard code attributes off object controller if found */
IF CAN-FIND(FIRST brym_wizard_objc
            WHERE brym_wizard_objc.OBJECT_name = pcContainerName) THEN
DO:
  FIND FIRST brym_wizard_objc NO-LOCK
       WHERE brym_wizard_objc.OBJECT_name = pcContainerName
       NO-ERROR.

  IF AVAILABLE brym_wizard_objc THEN
    ASSIGN
      cForeignFields = brym_wizard_objc.sdo_foreign_fields
      cLaunchContainer = brym_wizard_objc.launch_container
      cWindowTitleField = brym_wizard_objc.WINDOW_title_field
      cSelectedFields = "":U
      .

END.

/* use hard code attributes off folder window page object if found */
IF CAN-FIND(FIRST brym_wizard_fold
            WHERE brym_wizard_fold.OBJECT_name = pcContainerName) THEN
DO:
  FIND FIRST brym_wizard_fold NO-LOCK
       WHERE brym_wizard_fold.OBJECT_name = pcContainerName
       NO-ERROR.
  IF AVAILABLE brym_wizard_fold THEN
  DO:
    ASSIGN lNoSDO = brym_wizard_fold.NO_sdo.

    FIND FIRST brym_wizard_fold_page NO-LOCK
         WHERE brym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
           AND brym_wizard_fold_page.viewer_object_name = cObjectName         
        NO-ERROR.
    IF NOT AVAILABLE brym_wizard_fold_page THEN
      FIND FIRST brym_wizard_fold_page NO-LOCK
           WHERE brym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
             AND brym_wizard_fold_page.browser_object_name = cObjectName
           NO-ERROR.

    /* Only require foreignfields on the first SDO/SBO reference */ 
    IF NOT AVAILABLE brym_wizard_fold_page THEN
    FOR EACH brym_wizard_fold_page NO-LOCK
        WHERE brym_wizard_fold_page.wizard_fold_obj = brym_wizard_fold.wizard_fold_obj
        AND   brym_wizard_fold_page.sdo_object_name = cObjectName
        BY brym_wizard_fold_page.page_number:

       LEAVE.
    END.

    IF AVAILABLE brym_wizard_fold_page THEN
      ASSIGN
        cForeignFields = brym_wizard_fold_page.sdo_foreign_fields
        cLaunchContainer = "":U
        cWindowTitleField = brym_wizard_fold_page.WINDOW_title_field
        cSelectedFields = "":U
        .
  END.
END.

/* use default values off browser object if found and not set specifically on container */
IF CAN-FIND(FIRST brym_wizard_brow
            WHERE brym_wizard_brow.OBJECT_name = (IF cSDOBrowser <> "":U THEN cSDOBrowser ELSE cObjectName)) THEN
DO:
  FIND FIRST brym_wizard_brow NO-LOCK
       WHERE brym_wizard_brow.OBJECT_name = (IF cSDOBrowser <> "":U THEN cSDOBrowser ELSE cObjectName)
       NO-ERROR.
  IF AVAILABLE brym_wizard_brow THEN
  DO:
    ASSIGN
      cForeignFields = (IF cForeignFields <> "":U THEN cForeignFields ELSE brym_wizard_brow.sdo_foreign_fields)
      cLaunchContainer = (IF cLaunchContainer <> "":U THEN cLaunchContainer ELSE brym_wizard_brow.launch_container)
      cWindowTitleField = (IF cWindowTitleField <> "":U THEN cWindowTitleField ELSE brym_wizard_brow.WINDOW_title_field)
      cSelectedFields = (IF cSelectedFields <> "":U THEN cSelectedFields ELSE brym_wizard_brow.SELECTED_fields)
      .
  END.
END.

/* use default values off viewer object if found and not set specifically on container - and depending on type of object */
IF CAN-FIND(FIRST brym_wizard_view
            WHERE brym_wizard_view.OBJECT_name = cObjectName) THEN
DO:
  FIND FIRST brym_wizard_view NO-LOCK
       WHERE brym_wizard_view.OBJECT_name = cObjectName
       NO-ERROR.
  IF AVAILABLE brym_wizard_view THEN
  DO:
    ASSIGN
      cWindowTitleField = (IF cWindowTitleField <> "":U THEN cWindowTitleField ELSE brym_wizard_view.WINDOW_title_field)
      cSelectedFields = (IF cSelectedFields <> "":U THEN cSelectedFields ELSE brym_wizard_view.SELECTED_fields)
      .
  END.
END.

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
      bryc_object_instance.instance_height = 0
      bryc_object_instance.instance_width = 0
      bryc_object_instance.instance_x = 0
      bryc_object_instance.instance_y = 0
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

    IF AVAILABLE bryc_attribute_value AND bryc_attribute_value.inheritted_value = FALSE THEN
      NEXT attribute-loop.  /* do not override manual customisations */

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
      bryc_attribute_value.collect_attribute_value_obj = bryc_attribute_value.attribute_value_obj
      bryc_attribute_value.collection_sequence = 0
      bryc_attribute_value.constant_value = ryc_attribute_value.constant_value
      bryc_attribute_value.attribute_group_obj = ryc_attribute_value.attribute_group_obj
      bryc_attribute_value.attribute_type_tla = ryc_attribute_value.attribute_type_tla
      bryc_attribute_value.attribute_label = ryc_attribute_value.attribute_label
      bryc_attribute_value.PRIMARY_smartobject_obj = pdContainer
      bryc_attribute_value.inheritted_value = TRUE
      bryc_attribute_value.attribute_value = ryc_attribute_value.attribute_value
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
  Purpose:     Procedure to create / update ASDB gsc_object and RYDB
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

DEFINE BUFFER bgsc_object FOR gsc_object.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

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
ELSE ASSIGN dObjectType = gsc_object_type.OBJECT_type_obj.

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
DO FOR bgsc_object, bryc_smartobject TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  /* find existing ASDB object / create new one */
  FIND FIRST bgsc_object EXCLUSIVE-LOCK
       WHERE bgsc_object.OBJECT_filename = pcObjectName
       NO-ERROR.
  IF NOT AVAILABLE bgsc_object THEN
  DO:
    CREATE bgsc_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

    ASSIGN
      bgsc_object.object_filename = pcObjectName
      bgsc_object.DISABLED = NO
      .      
  END.

  /* Update ASDB object details */
  ASSIGN
    bgsc_object.object_description = pcObjectDescription 
    bgsc_object.logical_object = NO
    bgsc_object.generic_object = NO
    bgsc_object.container_object = plContainer
    bgsc_object.object_path = pcObjectPath
    bgsc_object.object_type_obj = dObjectType
    bgsc_object.physical_object_obj = 0
    bgsc_object.product_module_obj = dProductModule
    bgsc_object.required_db_list = pcRequiredDBList
    bgsc_object.runnable_from_menu = plContainer  
    bgsc_object.run_persistent = YES
    bgsc_object.run_when = "ANY":U
    bgsc_object.security_object_obj = bgsc_object.object_obj
    bgsc_object.toolbar_image_filename = "":U
    bgsc_object.toolbar_multi_media_obj = 0
    bgsc_object.tooltip_text = "":U
    .
  VALIDATE bgsc_object NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  /* Find/create RYDB repository object */
  FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
       WHERE bryc_smartobject.OBJECT_filename = pcObjectName
       NO-ERROR.

  IF NOT AVAILABLE bryc_smartobject THEN
  DO:
    CREATE bryc_smartobject NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.
    ASSIGN
      bryc_smartobject.object_filename = pcObjectName
      bryc_smartobject.custom_super_procedure = "":U
      bryc_smartobject.system_owned = NO
      bryc_smartobject.shutdown_message_text = "":U
      bryc_smartobject.template_smartobject = NO
      .      
  END.

  /* Update rest of details */
  ASSIGN
    bryc_smartobject.static_object = YES
    bryc_smartobject.product_module_obj = dProductModule
    bryc_smartobject.layout_obj = 0
    bryc_smartobject.object_obj = bgsc_object.OBJECT_obj
    bryc_smartobject.object_type_obj = dObjectType
    bryc_smartobject.sdo_smartobject_obj = dSDO
    .  
  VALIDATE bryc_smartobject NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN UNDO trn-block, LEAVE trn-block.

  ASSIGN
    pdSmartObject = bryc_smartobject.smartobject_obj
    pdObjectType = dObjectType
    .

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

