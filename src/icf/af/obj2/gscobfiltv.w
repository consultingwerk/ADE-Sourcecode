&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
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
  File: gscobfiltv.w

  Description:  Object Filter Viewer

  Purpose:      Object Filter Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000033   UserRef:    
                Date:   22/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:    90000018   UserRef:    
                Date:   05/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Added the Object FileName

--------------------------------------------------------------------------------*/
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

&scop object-name       gscobfiltv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcSavedType                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSavedModule              AS CHARACTER  NO-UNDO.


{af/sup2/afttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coObjectType coProductModule buRefresh ~
fiFileName 
&Scoped-Define DISPLAYED-OBJECTS coObjectType coProductModule fiFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh browser to only show data for selected Language (plus existing filters)"
     BGCOLOR 8 .

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 45.6 BY 1.05 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 45.6 BY 1.05 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Filename" 
     VIEW-AS FILL-IN 
     SIZE 45.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coObjectType AT ROW 1 COL 16.2 COLON-ALIGNED
     coProductModule AT ROW 2.1 COL 16.2 COLON-ALIGNED
     buRefresh AT ROW 3.05 COL 64.6
     fiFileName AT ROW 3.14 COL 16.2 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 3.38
         WIDTH              = 78.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh sObject
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:

DEFINE VARIABLE hBrowser                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDO                        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLinkHandles                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cManualAddQueryWhere        AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cQueryString                AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cQueryColumns               AS CHARACTER  NO-UNDO.        

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN coObjectType coProductModule fiFileName.


  /* Assumes a user1 link from viewer to browser */
  hBrowser = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'user1-Target')) NO-ERROR.
  IF VALID-HANDLE(hBrowser) THEN
    hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN hBrowser, 'data-source')) NO-ERROR.

  IF VALID-HANDLE(hSDO) THEN
  DO:
    IF coObjectType <> 0 THEN
      ASSIGN
        cField = "ryc_smartobject.object_type_obj":U 
        cWhere = cField + " = ":U + STRING(coObjectType). 
    IF coProductModule <> 0 THEN
      ASSIGN
        cField = "ryc_smartobject.product_module_obj":U 
        cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
               + cField + " = ":U + STRING(coProductModule). 
    IF fiFileName <> "":U THEN
      ASSIGN
        cField = "ryc_smartobject.object_filename":U 
        cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
               + cField + " BEGINS '":U + fiFileName + "'":U  .
    RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField). 
    DYNAMIC-FUNCTION('openQuery' IN hSDO).

  END.

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType sObject
ON ENTRY OF coObjectType IN FRAME frMain /* Object Type */
DO:
  ASSIGN gcSavedType = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType sObject
ON VALUE-CHANGED OF coObjectType IN FRAME frMain /* Object Type */
DO:
  IF gcSavedType <> SELF:SCREEN-VALUE THEN
  DO:
    ASSIGN gcSavedType = SELF:SCREEN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule sObject
ON ENTRY OF coProductModule IN FRAME frMain /* Product Module */
DO:
  ASSIGN gcSavedModule = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule sObject
ON VALUE-CHANGED OF coProductModule IN FRAME frMain /* Product Module */
DO:
  IF gcSavedModule <> SELF:SCREEN-VALUE THEN
  DO:
    ASSIGN gcSavedModule = SELF:SCREEN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN populateCombos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos sObject 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cEntry                          AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_obj":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_description,gsc_object_type.object_type_code":U
    ttComboData.cDescSubstitute = "&1 (&2)":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coProductModule":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coProductModule:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code":U
    ttComboData.cBufferList = "gsc_product_module":U
    ttComboData.cKeyFieldName = "gsc_product_module.product_module_obj":U
    ttComboData.cDescFieldNames = "gsc_product_module.product_module_code":U
    ttComboData.cDescSubstitute = "&1":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .
  /* build combo list-item pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

  /* and set-up combos */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
  coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* Select 1st entry */
  IF coObjectType:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coObjectType:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE
    DO:
      /* blank the combo */
      coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
    END.
  END.

  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
  coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* Select 1st entry */
  IF coProductModule:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coObjectType:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE
    DO:
      /* blank the combo */
      coProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS.
    END.
  END.
END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

