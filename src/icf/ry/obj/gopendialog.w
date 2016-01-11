&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
/*--------------------------------------------------------------------------
    File        : gopendialog.w
    Purpose     : Open Object Dialog for repository objects.

    Syntax      : 
    
    Input Parameters:
        phWindow        : Window in which to display the dialog box.
        gcProductModule : Initial Product Module Code.
    
    Output Parameters:
        p_filename: The filename selected.
        p_ok      : TRUE if user successfully choose an object file name.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     : 
                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 2009 Objects the AB can't open are in dialog.
                  Fix: Filter the Object Type combo query and the
                  SDO query with preprocessor gcOpenObjectTypes, which
                  lists the object type codes that the AB knows to open.

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 1940 Long delay in Open Object dialog browser.
                  Fix: Changed rows-to-batch instance property for SDO
                  to 20 (was 200).
                  
                  08/16/2001      created by          Yongjian Gu
                  
                  04/12/2001      Update By           Peter Judge
                  IZ3130: Change delimiter in combos from comma to CHR(3)
                  to avoid issue with non-American numeric formats.
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
DEFINE INPUT  PARAMETER phWindow        AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule LIKE icfdb.gsc_product_module.product_module_code. 
DEFINE OUTPUT PARAMETER gcFileName      LIKE icfdb.gsc_object.object_filename. 
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL.

/* Local Variable Definitions ---                                       */
/*{af/sup2/afglobals.i} 8/19 */
DEFINE VARIABLE gcOriginalWhere            AS CHARACTER INITIAL "". 
/*DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". */
DEFINE VARIABLE glDisplayRepository         AS LOGICAL          NO-UNDO.

/* IZ 2009: jep-icf: Valid object_type_code the AppBuilder can open. */
&GLOBAL-DEFINE gcOpenObjectTypes DynObjc,DynMenc,DynFold,DynBrow,Shell,hhpFile,hhcFile,DatFile,CGIProcedure,SBO,StaticSO,StaticFrame,StaticSDF,StaticDiag,StaticCont,StaticMenc,StaticObjc,StaticFold,StaticSDV,StaticSDB,SDO,JavaScript,CGIWrapper,SmartViewer,SmartQuery,SmartPanel,SmartFrame,SmartBrowser,Container,Procedure,Window,SmartWindow,SmartFolder,SmartDialog
&GLOBAL-DEFINE REPOSITORY-MODULES RY,RV,ICF,AF,GS,AS,RTB

{src/adm2/ttcombo.i}

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
&Scoped-Define ENABLED-OBJECTS coProductModule Btn_OK fiFileName Btn_Cancel ~
coObjectType 
&Scoped-Define DISPLAYED-OBJECTS coProductModule fiFileName coObjectType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bopendialog AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dopendialog AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0.00
     DROP-DOWN-LIST
     SIZE 55.8 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0.00
     DROP-DOWN-LIST
     SIZE 55.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     coProductModule AT ROW 1.38 COL 29.2 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 12.33 COL 97
     fiFileName AT ROW 12.48 COL 29 COLON-ALIGNED NO-LABEL
     Btn_Cancel AT ROW 13.67 COL 97
     coObjectType AT ROW 13.95 COL 29.2 COLON-ALIGNED NO-LABEL
     "Product Module:" VIEW-AS TEXT
          SIZE 25 BY 1.43 AT ROW 1.14 COL 4.2
     "Object Filename:" VIEW-AS TEXT
          SIZE 23 BY 1.43 AT ROW 12.19 COL 3
     "Object Type:" VIEW-AS TEXT
          SIZE 21 BY 1.43 AT ROW 13.38 COL 3
     SPACE(89.39) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Open Object"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
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
ON GO OF FRAME gDialog /* Open Object */
DO:
    APPLY 'CHOOSE' TO Btn_OK.   /* go to search the object file */
   
    IF gcFileName = ? THEN  RETURN NO-APPLY.   /* if no such a file, do not close the dialog */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Open Object */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  ASSIGN gcFileName = ?               /* these values are by default, just reaffirm it. */
         pressedOK = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
      
DEFINE VARIABLE hBrowser                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDO                        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cModuleWhere                AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cTypeWhere                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileNameWhere              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cModuleField                AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cTypeField                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileNameField              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE openObjectName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE currentProductModule           AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN coObjectType coProductModule fiFileName.
  
  ASSIGN hBrowser = h_bopendialog        /* SmartDataBrowser widget-handle */
         hsdo = h_dopendialog.           /* SmartDataObject widget-handle */

  /* retrieve the SmartDataObject's original query and put it in a variable, it is just done
     once in the Open Dialog, which is the first time when the browser wants to view data that
     are retrieved using a different query from SDO's original (by clicking on Open, or pressing F2,
     choosing different values in Product Module and Object Type comdo-boxes, oressing Return). 
     After that, when the browser's query changes, firstly use this original to reset the SDO's 
     query, then add somethinb extra as needed. */
  IF gcOriginalWhere = "" THEN           /* get SDO original query */
   ASSIGN gcOriginalWhere = DYNAMIC-FUNCTION('getOpenQuery':U IN hsdo).
  

  IF (fiFileName <> "" AND fiFileName <> ?) THEN    /* only do the search when there is a filename string */
  DO:
    IF coObjectType <> 0 THEN
      /* type criterion */
      ASSIGN   
        cTypeField = "gsc_object.object_type_obj":U 
        cTypeWhere = cTypeField + " = '":U + STRING(coObjectType) + "' ":U.
    /* Module criterion */
    IF coProductModule <> 0 THEN
      ASSIGN
        cModuleField = "gsc_object.product_module_obj":U 
        cModuleWhere = cTypeWhere + (IF cTypeWhere = "":U THEN "":U ELSE " AND ":U)
               + cModuleField + " = '":U + STRING(coProductModule) + "' ":U. 
    /* filename criterion */
   IF fiFileName <> "":U THEN
      ASSIGN
        cFileNameField = "gsc_object.object_filename":U 
        cFileNameWhere = cModuleWhere + (IF cModuleWhere = "":U THEN "":U ELSE " AND ":U)
               + cFileNameField + " = '":U + TRIM(fiFileName) + "'":U.

    /* reset SDO to its original query. */
    DYNAMIC-FUNCTION('setQueryWhere':U IN hsdo, INPUT gcOriginalWhere).
    /* append the additional searching criteria to the SDO's query */
    DYNAMIC-FUNCTION('setQueryWhere':U IN hsdo, INPUT cFileNameWhere). 
    /* do the new query and update the browser */
    DYNAMIC-FUNCTION('openQuery' IN hSDO).

    /* check where there is the object with this name being shown in the browser.
       if the object exists, there must be a row in the browser; if not, the browser
       must be empty. */        
    RUN checkAvailability IN hBrowser (OUTPUT openObjectName).
    
    /* if the file is found, it must have a valid openObjectName (filename) */
    IF  (openObjectName = ?) THEN
    DO:
        IF fiFileName <> "" THEN
        MESSAGE fiFileName SKIP
                "File not found." SKIP
                "Please verify that the correct file name, product module, and type were given."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
  
        /* refresh the broser to bring up the old contents before the filename search */
        DYNAMIC-FUNCTION('setQueryWhere':U IN hsdo, INPUT gcOriginalWhere). 
        DYNAMIC-FUNCTION('setQueryWhere':U IN hsdo, INPUT cModuleWhere).
        DYNAMIC-FUNCTION('openQuery' IN hSDO).
    
        ASSIGN gcFileName = ?             /* reaffirm output values */
               pressedOK = NO.
       /*  RETURN NO-APPLY.  */
    END. /* openObjectName = ?  */
    ELSE DO:
       ASSIGN gcFileName = STRING(fiFileName)    /* assign valid outputs, GO to close the dialog */
               pressedOK = YES.
       /* Create the _RyObject record to be later used by AppBuilder to copy data to _P. */
       RUN createRyObject IN h_dopendialog.
       /* Update the current product module for the user, unles it's "<All>".
          Repository API session super procedure handles this call. */
       ASSIGN currentProductModule =
           ENTRY(LOOKUP(" " + coProductModule:SCREEN-VALUE, coProductModule:LIST-ITEM-PAIRS) - 1, coProductModule:LIST-ITEM-PAIRS) NO-ERROR.
       IF (currentProductModule <> "<All>":u) AND (currentProductModule <> "") THEN
            DYNAMIC-FUNCTION("setCurrentProductModule":u, currentProductModule) NO-ERROR.
       APPLY 'GO' TO FRAME {&FRAME-NAME}. 
    END. /* valid filename found */
  END. /* search if filename string */
  ELSE DO:                    /* doing nothing because there is no object filename to search. */
      ASSIGN gcFileName = ?             /* reaffirm output values */
             pressedOK = NO.
       RETURN NO-APPLY.       
  END.
END.      /* DO WITH {&FRAME-NAME} */
END.     /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType gDialog
ON VALUE-CHANGED OF coObjectType IN FRAME gDialog
DO:
  RUN updateBrowserContents.    /* update contents in the browser according to 
                                   the newly-changed object type. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON ENTRY OF coProductModule IN FRAME gDialog
DO:
  /* ASSIGN gcSavedModule = SELF:SCREEN-VALUE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON VALUE-CHANGED OF coProductModule IN FRAME gDialog
DO:
  RUN updateBrowserContents.  /* update contents in the browser according to 
                                 the newly-changed Product Module. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
 
{src/adm2/dialogmn.i} 

/* If testing in the UIB, initialize the SmartObject. */  
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
             INPUT  'ry/obj/dopendialog.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch20CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyes':U ,
             OUTPUT h_dopendialog ).
       RUN repositionObject IN h_dopendialog ( 1.24 , 94.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'ry/obj/bopendialog.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'ScrollRemotenoDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bopendialog ).
       RUN repositionObject IN h_bopendialog ( 2.91 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_bopendialog ( 9.29 , 109.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bopendialog. */
       RUN addLink ( h_dopendialog , 'Data':U , h_bopendialog ).
       RUN addLink ( h_bopendialog , 'F2Pressed':U , THIS-PROCEDURE ).
       RUN addLink ( h_bopendialog , 'updateFileName':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bopendialog ,
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
  DISPLAY coProductModule fiFileName coObjectType 
      WITH FRAME gDialog.
  ENABLE coProductModule Btn_OK fiFileName Btn_Cancel coObjectType 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE F2Pressed gDialog 
PROCEDURE F2Pressed :
/*------------------------------------------------------------------------------
  Purpose:     
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
    DEFINE VARIABLE rRowid              AS ROWID                        NO-UNDO.
    DEFINE VARIABLE cProfileData        AS CHARACTER                    NO-UNDO.

    /* Parent the dialog-box to the specified window. */
    IF VALID-HANDLE(phWindow) THEN
        ASSIGN FRAME {&FRAME-NAME}:PARENT = phWindow.

    /* override the SDO default dehavoir, don't run query and populate SBO after initializing
     * SDO. It is because we want to do query based on information passed-in, in addition to 
     * SDO's original. Waiting until we specifically order it to do by calling openQuery(). */
    DYNAMIC-FUNCTION('setOpenOnInit' IN h_dopendialog, NO).  

    /* Change combo delimiter to avoid numeric format issues, particularly
     * with non-American formats.                                         */
    ASSIGN coProductModule:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3)
           coObjectType:DELIMITER    IN FRAME {&FRAME-NAME} = CHR(3)
           .
    RUN SUPER.

    /* Display Repository?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN glDisplayRepository = (cProfileData EQ "YES":U).

    RUN populateCombos. /* populate combos */
    RUN showBrowser.    /* construct new query and ask SDO to openQuery(),
                         * show result in the SmartDataBrowser */

    RETURN.
END PROCEDURE.    /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos gDialog 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:    populate combo-boxes: Product Module and Object Type,
              based on the information from the repository.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWhere                      AS CHARACTER                NO-UNDO.        
    DEFINE VARIABLE cField                      AS CHARACTER                NO-UNDO.  
    DEFINE VARIABLE moduleEntry                 AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE typeName                    AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iModuleCount                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cWhereClause                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEntry                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE i                           AS INTEGER                  NO-UNDO.
    
    DO WITH FRAME {&FRAME-NAME}:
        EMPTY TEMP-TABLE ttComboData.

        CREATE ttComboData.
        ASSIGN ttComboData.cWidgetName        = "coObjectType":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coObjectType:HANDLE
               ttComboData.cForEach           = "FOR EACH gsc_object_type WHERE CAN-DO('{&gcOpenObjectTypes}', gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
               ttComboData.cBufferList        = "gsc_object_type":U
               ttComboData.cKeyFieldName      = "gsc_object_type.object_type_obj":U
               ttComboData.cDescFieldNames    = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U 
               ttComboData.cDescSubstitute    = "&1 (&2)":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coObjectType:DELIMITER
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               .
        /* IZ 3195 cDescFieldNames has both code and description with // seperator in cDescSubstitute. */
        CREATE ttComboData.
        ASSIGN ttComboData.cWidgetName        = "coProductModule":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coProductModule:HANDLE
               ttComboData.cBufferList        = "gsc_product_module":U
               ttComboData.cKeyFieldName      = "gsc_product_module.product_module_obj":U
               ttComboData.cDescFieldNames    = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
               ttComboData.cDescSubstitute    = "&1 // &2":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coProductModule:DELIMITER
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               ttComboData.cForEach           = "FOR EACH gsc_product_module WHERE ":U
               .
        IF NOT glDisplayRepository THEN
        DO iModuleCount = 1 TO NUM-ENTRIES("{&REPOSITORY-MODULES}":U):
            ASSIGN cWhereClause = cWhereClause + (IF NUM-ENTRIES(cWhereClause, "AND":U) EQ 0 THEN "":U ELSE " AND ":U)
                                + " NOT gsc_product_module.product_module_code BEGINS '" + ENTRY(iModuleCount, "{&REPOSITORY-MODULES}":U) + "' ":U.
        END.

        ASSIGN ttComboData.cForEach = ttComboData.cForEach + cWhereClause + " NO-LOCK BY gsc_product_module.product_module_code ":U.

        /* build combo list-item pairs */
        RUN af/app/afcobuildp.p (INPUT-OUTPUT TABLE ttComboData).

        /* and set-up object type combo */
        FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
        ASSIGN coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* Select 1st entry */
        IF coObjectType:NUM-ITEMS > 0 THEN
        DO:
            ASSIGN cEntry = coObjectType:ENTRY(1) NO-ERROR.
            IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
                ASSIGN coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
            ELSE
                /* blank the combo */
                ASSIGN coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
        END.

        /* and set-up product module combo */
        FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
        ASSIGN coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* If no product module passed in, try using the user's current product module.
         * This value comes from the Repository API session super-procedure. */
        IF (gcProductModule = ? OR gcProductModule = "") THEN
            ASSIGN gcProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":u) NO-ERROR.

        /* display the product module passed in */
        IF (gcProductModule <> ? AND gcProductModule <> "") THEN
        DO:
            /* Because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
             * and the second is the value. gcProductModule (product_module_code // product_module_description)
             * is the description. Look it up in the temple table string list first, then halve the size,
             * which should be its pair location in the drop-down list. Then we retrieve the value, which
             * should be gsc_product_module.product_module_obj, assign the value to the combo. */
            ASSIGN moduleEntry = LOOKUP(gcProductModule, coProductModule:LIST-ITEM-PAIRS)
                   moduleEntry = INTEGER((moduleEntry + 1) / 2)
                   cEntry      = coProductModule:ENTRY(moduleEntry)
                   NO-ERROR.
            IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
                ASSIGN coProductModule.
            END.
        END.
        /* else take the 1st entry, which should not be the case normally, because a valid 
         * gcProductModule should always be passed-in in order to run the dialog box. */
        ELSE
        DO:
            IF coProductModule:NUM-ITEMS > 0 THEN
            DO:
                ASSIGN cEntry = coProductModule:ENTRY(1) NO-ERROR.
                IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
                DO:
                    ASSIGN coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
                    ASSIGN coProductModule.
                END.
                ELSE
                    /* blank the combo */
                    ASSIGN coProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS.            
            END.
        END. /* IF gcProductModule */
    END. /* {&FRAME-NAME} */
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBrowser gDialog 
PROCEDURE showBrowser :
/*------------------------------------------------------------------------------
  Purpose:     show result records of the query in the browser
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /* store the original SDO query, so we reset SDO to its original query later on if needed. */
    IF gcOriginalWhere = "" THEN
        ASSIGN gcOriginalWhere = DYNAMIC-FUNCTION("getOpenQuery":U IN h_dopendialog).

    /* Force a the product module to populate the browse. */
    APPLY "VALUE-CHANGED":U TO coProductModule IN FRAME {&FRAME-NAME}.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateBrowserContents gDialog 
PROCEDURE updateBrowserContents :
/*------------------------------------------------------------------------------
  Purpose:     when a value in Product Module or Object Type combo-boxes changes, 
               update the object files listed in the bowser based on the new criteria.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWhere                      AS CHARACTER            NO-UNDO.        
    DEFINE VARIABLE iComboCount                 AS INTEGER              NO-UNDO.
    
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coProductModule coObjectType fiFileName.

        /* When the all product modules option is selected, we only want to see
         * all of the objects for the product modules which appear in the combo.
         * This will usually exclude the Repository product modules.
         *
         * This unfortunately slows the opening of the query down.                */
        CASE TRUE:
            /* Both selected */
            WHEN (coObjectType NE 0 AND coProductModule NE 0) THEN
                ASSIGN cWhere = " gsc_object.object_type_obj    = DECIMAL('":U + STRING(coObjectType) + "') AND ":U
                              + " gsc_object.product_module_obj = DECIMAL('":U + STRING(coProductModule) + "') ":U
                      .
            /* Object Type selected */
            WHEN (coObjectType NE 0 AND coProductModule EQ 0) THEN
            DO iComboCount = 1 TO coProductModule:NUM-ITEMS:
                ASSIGN cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " OR ":U)
                              + "( gsc_object.object_type_obj    = DECIMAL('":U + STRING(coObjectType) + "') AND ":U
                              + "  gsc_object.product_module_obj = DECIMAL('":U + coProductModule:ENTRY(iComboCount) + "') ) ":U.
            END.    /* selected <All> option */
            /* Product Module selected */
            WHEN (coObjectType EQ 0 AND coProductModule NE 0) THEN
                ASSIGN cWhere = " gsc_object.product_module_obj = DECIMAL('":U + STRING(coProductModule) + "') ":U.
            /* Neither selected */
            WHEN (coObjectType EQ 0 AND coProductModule EQ 0) THEN
            DO iComboCount = 1 TO coProductModule:NUM-ITEMS:
                ASSIGN cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " OR ":U)
                              + "  gsc_object.product_module_obj = DECIMAL('":U + coProductModule:ENTRY(iComboCount) + "') ":U.
            END.    /* selected <All> option */
        END CASE.   /* true */

        SESSION:SET-WAIT-STATE("GENERAL":U).

        /* reset SDO to its original query. */
        DYNAMIC-FUNCTION('setQueryWhere':U IN h_dopendialog, INPUT gcOriginalWhere).
        /* append the additional searching criteria to the SDO's query */
        DYNAMIC-FUNCTION('setQueryWhere':U IN h_dopendialog, INPUT cWhere).
        /* do the new query and update the browser */
        DYNAMIC-FUNCTION('openQuery' IN h_dopendialog).        

        SESSION:SET-WAIT-STATE("":U).
    END.  /* end {&FRAME-NAME} */
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFileName gDialog 
PROCEDURE updateFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER newFileName AS CHARACTER NO-UNDO.
 
fiFileName = newFileName.

DISPLAY fiFileName WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

