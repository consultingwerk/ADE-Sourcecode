&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS diDialog 
/*---------------------------------------------------------------------------------
  File:         adeuib/_tempdbEntity.w

  Description:  Dialog to prompt for Entity Import information

  Purpose:

  Parameters:   <none>

  History:
  --------
  
---------------------------------------------------------------------------------*/
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

&scop object-name       _tempdbentity.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE INPUT  PARAMETER pcTables AS CHARACTER  NO-UNDO .
  DEFINE OUTPUT PARAMETER plok     AS LOGICAL    NO-UNDO .
  DEFINE OUTPUT PARAMETER pErr     AS CHARACTER  NO-UNDO.
&ELSE
  DEFINE VARIABLE pcTables AS CHARACTER  NO-UNDO .
  DEFINE VARIABLE plOK     AS LOGICAL    NO-UNDO .
  DEFINE VARIABLE pErr     AS CHARACTER  NO-UNDO.
&ENDIF
/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDialog yes

{src/adm2/globals.i}

DEFINE VARIABLE glDynamicsRunning AS LOGICAL    NO-UNDO.

{ adeuib/uibhlp.i }          /* Help File Preprocessor Directives       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME diDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buOk buCancel btnHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "Help" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buOk AUTO-GO 
     LABEL "Import" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coDFType AS CHARACTER FORMAT "X(90)":U 
     LABEL "Object Type" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 46 BY 1 TOOLTIP "The class to which the DataField Objects belong." NO-UNDO.

DEFINE VARIABLE coEntityType AS CHARACTER FORMAT "X(90)":U 
     LABEL "ObjectType" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 46 BY 1 TOOLTIP "The class to which the Entity Objects belong." NO-UNDO.

DEFINE VARIABLE coModule AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product Module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 46 BY 1 TOOLTIP "The product module in which the Entity objects will be created." NO-UNDO.

DEFINE VARIABLE coModuleDF AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product Module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45.8 BY 1 TOOLTIP "he product module in which the DataFields will be created." NO-UNDO.

DEFINE VARIABLE fiPrefix AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Prefix length" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 TOOLTIP "Table prefix length or 0 for none" NO-UNDO.

DEFINE VARIABLE fiSep AS CHARACTER FORMAT "X(50)":U 
     LABEL "Field name separator" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 TOOLTIP "Word separation character for field names" NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69 BY 4.1.

DEFINE VARIABLE seTables AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 68 BY 3.81 NO-UNDO.

DEFINE VARIABLE toassociate AS LOGICAL INITIAL no 
     LABEL "Associate datafields with entities" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE togenerateDF AS LOGICAL INITIAL no 
     LABEL "Generate datafields" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 TOOLTIP "Update lists of fields for entities to display in generic objects" NO-UNDO.

DEFINE VARIABLE toOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwrite all attributes from schema" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .81 TOOLTIP "Override all local attributes such as Format, Label and Help with schema values" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME diDialog
     buOk AT ROW 19.33 COL 22
     buCancel AT ROW 19.33 COL 44
     btnHelp AT ROW 19.33 COL 61
     SPACE(0.79) SKIP(0.52)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Entity Import"
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.

DEFINE FRAME FRAME-B
     seTables AT ROW 1.71 COL 4 NO-LABEL
     fiSep AT ROW 5.76 COL 23.4 COLON-ALIGNED
     fiPrefix AT ROW 6.95 COL 23.4 COLON-ALIGNED
     coModule AT ROW 8.14 COL 23.4 COLON-ALIGNED
     coEntityType AT ROW 9.29 COL 23.4 COLON-ALIGNED
     togenerateDF AT ROW 10.62 COL 6
     coModuleDF AT ROW 11.57 COL 23.4 COLON-ALIGNED
     coDFType AT ROW 12.76 COL 23.4 COLON-ALIGNED
     toOverwrite AT ROW 13.95 COL 25.4
     toassociate AT ROW 15.38 COL 6
     "TEMP-DB Tables" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 1 COL 4
     RECT-14 AT ROW 11 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.67
         SIZE 72 BY 15.95.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB diDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME FRAME-B:FRAME = FRAME diDialog:HANDLE.

/* SETTINGS FOR DIALOG-BOX diDialog
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME diDialog:SCROLLABLE       = FALSE
       FRAME diDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME FRAME-B
                                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX diDialog
/* Query rebuild information for DIALOG-BOX diDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX diDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME diDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON HELP OF FRAME diDialog /* Entity Import */
ANYWHERE DO:
    RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL diDialog diDialog
ON WINDOW-CLOSE OF FRAME diDialog /* Entity Import */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp diDialog
ON CHOOSE OF btnHelp IN FRAME diDialog /* Help */
DO:
    RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk diDialog
ON CHOOSE OF buOk IN FRAME diDialog /* Import */
DO:
  RUN importData IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME FRAME-B
&Scoped-define SELF-NAME seTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seTables diDialog
ON MOUSE-SELECT-CLICK OF seTables IN FRAME FRAME-B
DO:
  SELF:SCREEN-VALUE = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togenerateDF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togenerateDF diDialog
ON VALUE-CHANGED OF togenerateDF IN FRAME FRAME-B /* Generate datafields */
DO:
   RUN ValueChangeGenerateDF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME diDialog
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK diDialog 


/* ***************************  Main Block  *************************** */

ASSIGN glDynamicsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
IF glDynamicsRunning = ? THEN glDynamicsRunning = NO.

{src/adm2/dialogmn.i}
&SCOPED-DEFINE FRAME-NAME FRAME-B

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects diDialog  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/folder.r':U ,
             INPUT  FRAME diDialog:HANDLE ,
             INPUT  'FolderLabels':U + 'Import Details' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 1.24 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 17.62 , 74.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_folder ,
             FRAME FRAME-B:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI diDialog  _DEFAULT-DISABLE
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
  HIDE FRAME diDialog.
  HIDE FRAME FRAME-B.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI diDialog  _DEFAULT-ENABLE
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
  ENABLE buOk buCancel btnHelp 
      WITH FRAME diDialog.
  {&OPEN-BROWSERS-IN-QUERY-diDialog}
  DISPLAY seTables fiSep fiPrefix coModule coEntityType togenerateDF coModuleDF 
          coDFType toOverwrite toassociate 
      WITH FRAME FRAME-B.
  ENABLE RECT-14 seTables fiSep fiPrefix coModule coEntityType togenerateDF 
         coModuleDF coDFType toOverwrite toassociate 
      WITH FRAME FRAME-B.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-B}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPreference diDialog 
PROCEDURE getPreference :
/*------------------------------------------------------------------------------
  Purpose:     Get the Preferences stored in the registry and set the
               values.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cSection AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

 ASSIGN cSection = "ProAB":U.

 
 GET-KEY-VALUE SECTION  cSection KEY "TempDBEntitySeparator":U VALUE cValue.
 fiSep          = IF cValue EQ ? THEN ""
                  ELSE cValue.

 GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrefix":U VALUE cValue.
 fiPrefix       = IF cValue EQ ? THEN 0
                  ELSE INT(cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityModule":U VALUE cValue.
 coModule       = IF LOOKUP(cValue,coModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},CHR(3)) = 0
                     AND NUM-ENTRIES(coModule:LIST-ITEM-PAIRS , CHR(3)) GE 2 
                     THEN ENTRY(2,coModule:LIST-ITEM-PAIRS,CHR(3))
                  ELSE cValue. 

 GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityType":U VALUE cValue.
 coEntityType   = IF cValue EQ ? 
                  THEN ENTRY(1,coEntityType:LIST-ITEMS)
                  ELSE cValue. 

 GET-KEY-VALUE SECTION  cSection KEY "TempDBGenerateDF":U VALUE cValue.
 togenerateDF   = IF cValue EQ ? THEN TRUE
                  ELSE CAN-DO ("true,yes,on",cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBDFModule":U VALUE cValue.
 coModuleDF     = IF LOOKUP(cValue,coModuleDF:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},CHR(3)) = 0
                      AND NUM-ENTRIES(coModuleDF:LIST-ITEM-PAIRS , CHR(3)) GE 2 
                  THEN ENTRY(2,coModuleDF:LIST-ITEM-PAIRS,CHR(3))
                  ELSE cValue. 
 
 GET-KEY-VALUE SECTION  cSection KEY "TempDBDFType":U VALUE cValue.
 coDFType       = IF cValue EQ ? 
                  THEN ENTRY(1,coDFType:LIST-ITEMS)
                  ELSE cValue. 

 GET-KEY-VALUE SECTION  cSection KEY "TempDBOverwriteAttr":U VALUE cValue.
 toOverwrite    = IF cValue EQ ? THEN TRUE
                  ELSE CAN-DO ("true,yes,on",cValue).

 GET-KEY-VALUE SECTION  cSection KEY "TempDBAssociateDF":U VALUE cValue.
 toassociate    = IF cValue EQ ? THEN TRUE
                  ELSE CAN-DO ("true,yes,on",cValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importData diDialog 
PROCEDURE importData :
/*------------------------------------------------------------------------------
  Purpose:     Starts the import process on the AppServer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cTableNames     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hRDM            AS HANDLE       NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
     /* The separator should be either blank, a single character or Upper. */
     IF LENGTH(fiSep:INPUT-VALUE, "CHARACTER":U) GT 1          AND
        fiSep:INPUT-VALUE                        NE "Upper":U  THEN
     DO:
         RUN showMessages IN gshSessionManager (INPUT  "AF^5^" + LC(PROGRAM-NAME(1)) + ":" + LC(PROGRAM-NAME(2)) + "^" 
                                                               + '"field separator"' 
                                                               + '"The field separator should be either blank, a single character or ´Upper´"'
                                                               +  CHR(4) + "?" + CHR(4) + "?" + CHR(4) + PROGRAM-NAME(1) 
                                                               + CHR(4) + PROGRAM-NAME(2),
                                                INPUT  "ERR":U,
                                                INPUT  "OK":U,
                                                INPUT  "OK":U,
                                                INPUT  "OK":U,
                                                INPUT  "Entity Mnemonic Import Complete",
                                                INPUT  YES,
                                                INPUT  TARGET-PROCEDURE,
                                                OUTPUT cButton               ).
         RETURN ERROR.
     END.    /* separator incorrect. */

     SESSION:SET-WAIT-STATE("GENERAL":U).

     /* Builds a list of the table names to be imported. */
     ASSIGN cTableNames = seTables:LIST-ITEMS.

     ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U).
     IF NOT VALID-HANDLE(hRDM) THEN 
         ASSIGN cError = "AF^29^" + LC(PROGRAM-NAME(1)) + ":" + LC(PROGRAM-NAME(2)) + "^" 
                                  + '"Repository Design Manager"' 
                                  + '"The handle to the Repository design Manager is invalid. Entity import failed"'
                                  +  CHR(4) + "?" + CHR(4) + "?" + CHR(4) + PROGRAM-NAME(1) 
                                  + CHR(4) + PROGRAM-NAME(2).

     /* First import DataFields */
     IF cError EQ "":U AND toGenerateDF:CHECKED THEN
     DO:
         RUN generateDataFields IN hRDM ( INPUT "TEMP-DB":U,                    /* pcDataBaseName */
                                          INPUT cTableNames,                    /* pcTableName */
                                          INPUT TRIM(coModuleDF:SCREEN-VALUE),  /* pcProductModuleCode */
                                          INPUT "":U,                           /* pcResultCode */
                                          INPUT NO,                             /* plGenerateFromDataObject */
                                          INPUT "":U,                           /* pcDataObjectFieldList */
                                          INPUT "":U,                           /* pcSdoObjectName */
                                          INPUT coDFType:SCREEN-VALUE,          /* pcObjectTypeCode  */
                                          INPUT (IF toOverwrite:CHECKED THEN "*":U ELSE "":U),
                                          INPUT "*":U /* pcFieldNames */  ) NO-ERROR.
         IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
             ASSIGN cError = RETURN-VALUE.
     END.    /* Display datafields */
     
     IF cError EQ "":U THEN
     DO:
         RUN generateEntityObject IN hRDM ( INPUT ("TEMP-DB":U + CHR(3) + cTableNames),
                                            INPUT coEntityType:SCREEN-VALUE,
                                            INPUT TRIM(coModule:SCREEN-VALUE),
                                            INPUT NO,
                                            INPUT fiPrefix:SCREEN-VALUE,
                                            INPUT fiSep:SCREEN-VALUE,
                                            INPUT "N",
                                            INPUT "":U,      /* pcDescFieldQualifiers */
                                            INPUT "":U,      /* pcKeyFieldQualifiers  */
                                            INPUT "":U,      /* pcObjFieldQualifiers  */
                                            INPUT NO,        /* version_data */
                                            INPUT NO,        /* deploy_data */
                                            INPUT NO,        /* reuse_deleted_keys */
                                            INPUT toAssociate:CHECKED         /* plAssociateDataFields   */  ) NO-ERROR.
         IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
             ASSIGN cError = RETURN-VALUE.
     END.    /* Import the Entities */

     /* Lastly, refresh the Repository cache, so the new entities are available to the session.
      * The entity menmonic cache is dependant on the REpository cache.                        */
     IF cError EQ "":U THEN
         RUN clearClientCache IN gshRepositoryManager.            

     SESSION:SET-WAIT-STATE("":U).

     IF cError EQ "":U THEN
         ASSIGN cError             = "The entity mnemonic import completed successfully for table(s) '":U + cTableNames + "'"
                ERROR-STATUS:ERROR = NO.
     ELSE
         ASSIGN ERROR-STATUS:ERROR = YES
                pErr               = cError.

     RUN showMessages IN gshSessionManager (INPUT  cError,
                                            INPUT  (IF ERROR-STATUS:ERROR THEN "ERR":U ELSE "MES":U),
                                            INPUT  "&OK":U,
                                            INPUT  "&OK":U,
                                            INPUT  "&OK":U,
                                            INPUT  "Entity Mnemonic Import ":U,
                                            INPUT  YES,
                                            INPUT  TARGET-PROCEDURE,
                                            OUTPUT cButton           ).
     
  END.  /* do with with frame */ 

  IF ERROR-STATUS:ERROR = NO THEN
  DO:
    RUN updateTempDB IN THIS-PROCEDURE (cTableNames).
    plOK = YES.
  END.
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject diDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

 RUN InitValues IN THIS-PROCEDURE.

 RUN getPreference IN THIS-PROCEDURE.

 RUN SUPER.

 RUN valueChangeGenerateDF IN THIS-PROCEDURE.
 
 IF seTables:LIST-ITEMS IN FRAME {&FRAME-NAME} = "" OR 
    seTables:LIST-ITEMS IN FRAME {&FRAME-NAME} = ?  THEN
   ASSIGN buOK:SENSITIVE IN FRAME diDialog = FALSE.
     /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initValues diDialog 
PROCEDURE initValues :
/*------------------------------------------------------------------------------
  Purpose:     Initialize the combos 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRDM           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cObjectList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDFListNoCalc  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntityList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFieldList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i              AS INTEGER    NO-UNDO.


ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U) NO-ERROR.
IF VALID-HANDLE(hRDM) THEN
   ASSIGN
     coModule:DELIMITER IN FRAME {&FRAME-NAME}    = CHR(3)
     coModuleDF:DELIMITER      = CHR(3)
     coModule:LIST-ITEM-PAIRS  = DYNAMIC-FUNCTION("getProductModuleList":U IN hRdm,
                                                   INPUT "product_module_Code":U,
                                                   INPUT "product_module_code,product_module_description":U,
                                                   INPUT "&1 // &2":U,
                                                   INPUT CHR(3)) 
    coModuleDF:LIST-ITEM-PAIRS = coModule:LIST-ITEM-PAIRS
    seTables:LIST-ITEMS        = pcTables
    .
/* Get the object type */
ASSIGN cObjectList     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DataField,Entity":U)
       cDataFieldList  = ENTRY(1, cObjectList, CHR(3))
       cEntityList     = ENTRY(2, cObjectList, CHR(3))
       cCalcFieldList  = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "CalculatedField":U)
       NO-ERROR.

/* Calculated fields should not be included in the list of object types for import.   */
DO i = 1 TO NUM-ENTRIES(cDataFieldList):
   IF LOOKUP(ENTRY(i,cDataFieldList),cCalcFieldList) > 0 THEN
        NEXT.
   cDFListNoCalc = cDFListNoCalc + (IF cDFListNoCalc  = "" THEN "" ELSE ",") + ENTRY(i,cDataFieldList).
END.
 
ASSIGN coEntityType:LIST-ITEMS = cEntityList
       coDFType:LIST-ITEMS     = cDFListNoCalc
       NO-ERROR.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runHelp diDialog 
PROCEDURE runHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF glDynamicsRunning THEN
        RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Entity_Import_Dlg_Dyn},?).
    ELSE
        RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Entity_Import_Dlg},?).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTempDB diDialog 
PROCEDURE updateTempDB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i      AS INTEGER    NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pcTables):
  cTable = ENTRY(i,pcTables).
  FIND TEMP-DB.temp-db-ctrl WHERE temp-db-ctrl.TableName = cTable EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL TEMP-DB.temp-db-ctrl THEN
     ASSIGN TEMP-DB.temp-db-ctrl.EntityImported = YES NO-ERROR.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangeGenerateDF diDialog 
PROCEDURE valueChangeGenerateDF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN coModuleDF:SENSITIVE IN FRAME {&FRAME-NAME} = toGenerateDF:CHECKED
       coDFType:SENSITIVE   = toGenerateDF:CHECKED
       toAssociate:CHECKED  = toGenerateDF:CHECKED   WHEN NOT toAssociate:CHECKED
       toAssociate:SENSITIVE = NOT toGenerateDF:CHECKED
       toOverwrite:SENSITIVE =  toGenerateDF:CHECKED.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

