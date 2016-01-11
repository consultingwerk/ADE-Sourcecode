&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
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

  File:     gobjectlookup.w
  Purpose:  Repository Object Lookup dialog.

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters: See definitions section.

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER gcProductModule     LIKE icfdb.gsc_product_module.product_module_code. 
DEFINE INPUT PARAMETER gcObjectType        LIKE icfdb.gsc_object_type.object_type_code.
DEFINE INPUT-OUTPUT PARAMETER gcFileName   LIKE icfdb.ryc_smartobject.object_filename. 

/* Local Variable Definitions ---                                       */
/* create a space to hold the SmartDataObject's original query string. */
DEFINE VARIABLE gcOriginalWhere            AS CHARACTER INITIAL "". 
DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". 


{af/sup2/afttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS coProductModule 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bobjectlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dobjectlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0.00
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 47 BY 1.05 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     coProductModule AT ROW 1.52 COL 16.8 COLON-ALIGNED
     coObjectType AT ROW 9.1 COL 2 NO-LABEL
     Btn_OK AT ROW 10.52 COL 2
     Btn_Cancel AT ROW 10.52 COL 18
     Btn_Help AT ROW 10.52 COL 51
     SPACE(0.19) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Choose Object"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX coObjectType IN FRAME gDialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       coObjectType:HIDDEN IN FRAME gDialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Choose Object */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help gDialog
ON CHOOSE OF Btn_Help IN FRAME gDialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    IF (fiFileName = "" AND fiFileName = ?) THEN
      RETURN NO-APPLY.   /* only do when there is a filename string */
  ELSE DO:
      ASSIGN gcFileName = fiFileName.
      /* MESSAGE "The Object filename is: " gcFileName.*/
  END.
 END.     /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON VALUE-CHANGED OF coProductModule IN FRAME gDialog /* Product Module */
DO:
  RUN updateBrowserContents. /* update the browser */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
{src/adm2/dialogmn.i}   

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN   
 RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
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
             INPUT  'ry/obj/dobjectlookup.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamery/obj/dobjectlookupUpdateFromSourcenoToggleDataTargetsyesOpenOnInityes':U ,
             OUTPUT h_dobjectlookup ).
       RUN repositionObject IN h_dobjectlookup ( 10.05 , 36.00 ) NO-ERROR.
       /* Size in AB:  ( 1.67 , 12.00 ) */

       RUN constructObject (
             INPUT  'ry/obj/bobjectlookup.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bobjectlookup ).
       RUN repositionObject IN h_bobjectlookup ( 2.91 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bobjectlookup ( 7.38 , 64.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bobjectlookup. */
       RUN addLink ( h_dobjectlookup , 'Data':U , h_bobjectlookup ).
       RUN addLink ( h_bobjectlookup , 'F2Pressed':U , THIS-PROCEDURE ).
       RUN addLink ( h_bobjectlookup , 'updateFileName':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bobjectlookup ,
             coProductModule:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY coProductModule 
      WITH FRAME gDialog.
  ENABLE coProductModule Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE F2Pressed gDialog 
PROCEDURE F2Pressed :
/*------------------------------------------------------------------------------
  Purpose:    Press F2 is equivalent to GO 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY 'CHOOSE' TO Btn_OK IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* override the SDO default dehavoir, don't run query and populate SBO after initializing
   SDO. It is because we want to do query based on information passed-in, in addition to 
   SDO's original. Waiting until we specifically order it to do by calling openQuery(). */
DYNAMIC-FUNCTION('setOpenOnInit' IN h_dobjectlookup, NO).  

   RUN SUPER.

   RUN populateCombo.   /* populate combos, one visible and the other invisible */
   RUN showBrowser.     /* construct new query and ask SDO to openQuery(), 
                           show result in the SmartDataBrowser */
END PROCEDURE.    /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombo gDialog 
PROCEDURE populateCombo :
/*------------------------------------------------------------------------------
  Purpose:    populate combo-boxes: Product Module and Object Type,
              based on the information from the repository.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE moduleName                  AS INTEGER.
DEFINE VARIABLE typeName                    AS INTEGER.

DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cEntry                          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                               AS INTEGER.

  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_obj":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_code":U
    ttComboData.cDescSubstitute = "&1":U
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
  RUN af/app/afcobuildp.p (INPUT-OUTPUT TABLE ttComboData).

  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
  coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  
  /* display the product module passed in */
  IF (gcProductModule <> ? AND gcProductModule <> "") THEN DO:
      /* because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
         and the second is the value. gcProductModule (gsc_product_module.product_module_code) is the 
         description. Look it up in the temple table string list first, then halve the size, which should 
         be its pair location in the drop-down list. Then we retrieve the value, which should be 
         gsc_product_module.product_module_obj, assign the value to the combo. */
      ASSIGN moduleName = LOOKUP(gcProductModule, coProductModule:LIST-ITEM-PAIRS).
      ASSIGN moduleName = INTEGER((moduleName + 1) / 2).
      cEntry = coProductModule:ENTRY(moduleName) NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
      ASSIGN coProductModule.
    END.
  END.

  /* else take the 1st entry, which should not be the case normally, because a valid 
     gcProductModule should always be passed-in in order to run the dialog box. */
ELSE DO:
  IF coProductModule:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coProductModule:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
      ASSIGN coProductModule.
    END.
    ELSE
    DO:
      /* blank the combo */
      coProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS.
    END.
  END.
END.

/* and set-up object type combo, which is invisible when the program is running,
   its purpose is just to hold passed-in type value. */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
  coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
 
/* because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
   and the second is the value. gcObjectType (gsc_object_type.object_type_code) is the 
   description. Look it up in the temple table string list first, then halve the size, which should 
   be its pair location in the drop-down list. Then we retrieve the value, which should be 
   gsc_object_type.object_type_obj, assign the value to the combo. */
  IF (gcObjectType <> ? AND gcObjectType <> "") THEN DO:
      ASSIGN typeName = LOOKUP(gcObjectType, coObjectType:LIST-ITEM-PAIRS).
      ASSIGN typeName = INTEGER((typeName + 1) / 2).
      cEntry = coObjectType:ENTRY(typeName) NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
      ASSIGN coObjectType.
    END.
  END.

  /* else take the 1st entry, which should not be the case normally, because a valid 
     gcObjectType should always be passed-in in order to run the dialog box. */
  ELSE DO:
  IF coObjectType:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coObjectType:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
      ASSIGN coObjectType.
    END.
    ELSE
    DO:
      /* blank the combo */
      coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
    END.
  END.
  END.

END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBrowser gDialog 
PROCEDURE showBrowser :
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.  
 
/* store the original SDO query, so we reset SDO to its original query later on if needed. */
IF gcOriginalWhere = "" THEN
 ASSIGN gcOriginalWhere = DYNAMIC-FUNCTION('getOpenQuery':U IN h_dobjectlookup). 

IF (coObjectType <> 0) THEN
      ASSIGN
        cField = "ryc_smartobject.object_type_obj":U 
        cWhere = cField + " = ":U + STRING(coObjectType). 
 IF (coProductModule <> 0) THEN
      ASSIGN
        cField = "ryc_smartobject.product_module_obj":U 
        cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
                 + cField + " = ":U + STRING(coProductModule). 

/* reset SDO to its original query, now it should be the original, just make it sure. */
DYNAMIC-FUNCTION('setQueryWhere':U IN h_dobjectlookup, INPUT gcOriginalWhere).
/* append the additional searching criteria to the SDO's query */
DYNAMIC-FUNCTION('setQueryWhere':U IN h_dobjectlookup, cWhere).
/* do the new query and update the browser */
DYNAMIC-FUNCTION('openQuery' IN h_dobjectlookup).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateBrowserContents gDialog 
PROCEDURE updateBrowserContents :
/*------------------------------------------------------------------------------
  Purpose:     when a value in Product Module combo-boxes changes, update the object 
               files listed in the bowser based on the new criteria (the object type
               remain the same, which is the passedin value.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.  

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN coProductModule.
 
/*  IF gcOriginalWhere = "" THEN
   ASSIGN gcOriginalWhere = DYNAMIC-FUNCTION('getOpenQuery':U IN h_dobjectlookup).
 */  
  
  IF (coObjectType <> 0) THEN
      ASSIGN
      cField = "ryc_smartobject.object_type_obj":U 
        cWhere = cField + " = ":U + STRING(coObjectType). 
  IF (coProductModule <> 0) THEN
      ASSIGN
        cField = "ryc_smartobject.product_module_obj":U 
        cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
                    + cField + " = ":U + STRING(coProductModule). 
        
/* reset SDO to its original query. */
DYNAMIC-FUNCTION('setQueryWhere':U IN h_dobjectlookup, INPUT gcOriginalWhere).
/* append the additional searching criteria to the SDO's query */
DYNAMIC-FUNCTION('setQueryWhere':U IN h_dobjectlookup, INPUT cWhere).
/* do the new query and update the browser */
DYNAMIC-FUNCTION('openQuery' IN h_dobjectlookup).

END.  /* end {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFilename gDialog 
PROCEDURE updateFilename :
/*------------------------------------------------------------------------------
  Purpose:     every time the highlighted row in the browser is changed, update 
               the filename value, which will be the output value.
  Parameters:  INPUT newFileName -- the filename whose row is highlighted in 
               browser.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER newFileName AS CHARACTER NO-UNDO.

fiFileName = newFileName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

