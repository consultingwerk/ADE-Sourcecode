&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _TEMP-TABLE 
/* ***********Included Temp-Table & Buffer definitions **************** */

{adeuib/calctt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*---------------------------------------------------------------------------------
  File: _calcseld

  Description:  Calculated Field Selector SDO  

  Purpose:      Finds calculated fields in the repository and make them available to 
                the Calculated Field Selector for inclusion in Dynamic SDOs.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/13/2004  Author:     

  Update Notes: Created from Template rysttasdoo.w

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/globals.i}
{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

DEFINE TEMP-TABLE ttCalcEntity NO-UNDO
  FIELD tCalculatedField AS CHARACTER
  FIELD tEntity          AS CHARACTER FORMAT "x(30)"
  FIELD tInstanceName    AS CHARACTER.

DEFINE VARIABLE gcShowCalc AS CHARACTER    NO-UNDO.



/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _calcseld.w
&scop object-version    000000

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCalcField

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  tDesc tEntity tName tProductModule tInstanceName tDataType tHelp tLabel~
 tFormat tColumnLabel
&Scoped-define ENABLED-FIELDS-IN-ttCalcField tDesc tEntity tName ~
tProductModule tInstanceName tDataType tHelp tLabel tFormat tColumnLabel 
&Scoped-Define DATA-FIELDS  tDesc tEntity tName tProductModule tInstanceName tDataType tHelp tLabel~
 tFormat tColumnLabel
&Scoped-define DATA-FIELDS-IN-ttCalcField tDesc tEntity tName ~
tProductModule tInstanceName tDataType tHelp tLabel tFormat tColumnLabel 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "adeuib/_calcseld.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH ttCalcField NO-LOCK ~
    BY ttCalcField.tName ~
       BY ttCalcField.tEntity INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ttCalcField NO-LOCK ~
    BY ttCalcField.tName ~
       BY ttCalcField.tEntity INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ttCalcField
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ttCalcField


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowCalc dTables  _DB-REQUIRED
FUNCTION getShowCalc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ttCalcField SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
   Temp-Tables and Buffers:
      TABLE: ttCalcField T "?" NO-UNDO temp-db ttCalcField
   END-TABLES.
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "Temp-Tables.ttCalcField"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.ttCalcField.tName|yes,Temp-Tables.ttCalcField.tEntity|yes"
     _FldNameList[1]   > Temp-Tables.ttCalcField.tDesc
"tDesc" "tDesc" ? "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no ""
     _FldNameList[2]   > Temp-Tables.ttCalcField.tEntity
"tEntity" "tEntity" ? "x(70)" "character" ? ? ? ? ? ? yes ? no 70 no ""
     _FldNameList[3]   > Temp-Tables.ttCalcField.tName
"tName" "tName" ? "x(70)" "character" ? ? ? ? ? ? yes ? no 70 no ""
     _FldNameList[4]   > Temp-Tables.ttCalcField.tProductModule
"tProductModule" "tProductModule" ? "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no ""
     _FldNameList[5]   > Temp-Tables.ttCalcField.tInstanceName
"tInstanceName" "tInstanceName" ? "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no ""
     _FldNameList[6]   > Temp-Tables.ttCalcField.tDataType
"tDataType" "tDataType" ? ? "character" ? ? ? ? ? ? yes ? no 10 no ""
     _FldNameList[7]   > Temp-Tables.ttCalcField.tHelp
"tHelp" "tHelp" ? ? "character" ? ? ? ? ? ? yes ? no 8 no ""
     _FldNameList[8]   > Temp-Tables.ttCalcField.tLabel
"tLabel" "tLabel" ? ? "character" ? ? ? ? ? ? yes ? no 8 no ""
     _FldNameList[9]   > Temp-Tables.ttCalcField.tFormat
"tFormat" "tFormat" ? ? "character" ? ? ? ? ? ? yes ? no 8 no ""
     _FldNameList[10]   > Temp-Tables.ttCalcField.tColumnLabel
"tColumnLabel" "tColumnLabel" ? ? "character" ? ? ? ? ? ? yes ? no 12.8 no ?
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createttForAllCalc dTables  _DB-REQUIRED
PROCEDURE createttForAllCalc :
/*------------------------------------------------------------------------------
  Purpose:     Creates temp table records for all calculate fields in
               the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cInheritClasses   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.

  /* Gets temp table of calculated fields and their entities */
  RUN ry/prc/rycalcp.p (OUTPUT TABLE ttCalcEntity).

  FOR EACH ttCalcEntity:
    hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.

    /* Get calculated field object */
    RUN retrieveDesignObject IN hRepDesignManager
      (INPUT ttCalcEntity.tCalculatedField,
       INPUT '':U,              /* Default result codes */
       OUTPUT TABLE ttObject,
       OUTPUT TABLE ttPage,
       OUTPUT TABLE ttLink,
       OUTPUT TABLE ttUIEvent,
       OUTPUT TABLE ttObjectAttribute) NO-ERROR.
    
    FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = ttCalcEntity.tCalculatedField NO-ERROR.
    IF AVAILABLE ttObject THEN
    DO:
      FIND FIRST ttCalcField WHERE ttCalcField.tName = ttObject.tLogicalObjectname AND
          ttCalcField.tEntity = ttCalcEntity.tEntity AND
          ttCalcField.tInstanceName = ttCalcEntity.tInstanceName NO-ERROR.
      IF NOT AVAILABLE ttCalcField THEN
      DO:
        CREATE ttCalcField.
        ASSIGN
          ttCalcField.tName          = ttObject.tLogicalObjectname
          ttCalcField.tDesc          = ttObject.tObjectDescription   
          ttCalcField.tProductModule = ttObject.tProductModuleCode
          ttCalcField.tEntity        = ttCalcEntity.tEntity
          ttCalcField.tInstanceName  = ttCalcEntity.tInstanceName.

        IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassName) THEN
          RUN retrieveDesignClass IN hRepDesignManager
                            ( INPUT  ttObject.tClassName,
                              OUTPUT cInheritClasses,
                              OUTPUT TABLE ttClassAttribute ,
                              OUTPUT TABLE ttUiEvent,
                              OUTPUT TABLE ttSupportedLink    ) NO-ERROR.  


        /* Get attributes for the calculated field to display in the SDO's column editor */
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Data-Type':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tDataType = IF ttObjectAttribute.tAttributeValue = ? 
                                         THEN '?':U 
                                         ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Data-Type':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tDataType = IF ttClassAttribute.tAttributeValue = ?
                                           THEN '?':U
                                           ELSE ttClassAttribute.tAttributeValue.
        END.
      
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Label':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tLabel = IF ttObjectAttribute.tAttributeValue = ? 
                                      THEN '?':U 
                                      ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Label':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tLabel = IF ttClassAttribute.tAttributeValue = ?
                                        THEN '?':U
                                        ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Format':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tFormat = IF ttObjectAttribute.tAttributeValue = ? 
                                       THEN '?':U 
                                       ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Format':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tFormat = IF ttClassAttribute.tAttributeValue = ?
                                         THEN '?':U
                                         ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Help':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tHelp = IF ttObjectAttribute.tAttributeValue = ? 
                                     THEN '?':U 
                                     ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Help':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tHelp = IF ttClassAttribute.tAttributeValue = ?
                                       THEN '?':U
                                       ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'ColumnLabel':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tColumnLabel = IF ttObjectAttribute.tAttributeValue = ? 
                                            THEN '?':U 
                                            ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'ColumnLabel':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tColumnLabel = IF ttClassAttribute.tAttributeValue = ?
                                              THEN '?':U
                                              ELSE ttClassAttribute.tAttributeValue.
        END.

      END.
    END.
  END.

  EMPTY TEMP-TABLE ttCalcEntity.

  gcShowCalc = 'All':U.                                           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createttFromSDO dTables  _DB-REQUIRED
PROCEDURE createttFromSDO :
/*------------------------------------------------------------------------------
  Purpose:     Invokes createttRecs for all entities of the SDO to create
               records for calculated fields on the SDO's entities.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntityName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cReturnValue      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTableList        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iNumTable         AS INTEGER    NO-UNDO.

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  cTableList = DYNAMIC-FUNCTION('getTableList':U IN hContainerSource).

  DO iNumTable = 1 TO NUM-ENTRIES(cTableList):
    cTable = IF NUM-ENTRIES(ENTRY(iNumTable, cTableList), '.':U) > 1 
             THEN ENTRY(2, ENTRY(iNumTable, cTableList), '.':U)
             ELSE ENTRY(iNumTable,cTableList).

    /* Gets entity for table */
    RUN getTableInfo IN gshGenManager
        (INPUT cTable,
         OUTPUT cReturnValue).
    cEntityName = ENTRY(2, cReturnValue, CHR(4)).

    RUN createttRecs (INPUT cEntityName).
        
  END.  /* do iNumTable to number tables */
  gcShowCalc = 'SDO':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createttRecs dTables  _DB-REQUIRED
PROCEDURE createttRecs :
/*------------------------------------------------------------------------------
  Purpose:     Creates temp table record for each calculated field of the 
               entity passsed.
  Parameters:  pcEntityName AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEntityName AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cCalcClassList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInheritClasses   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.

  hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.
  
  /* Get entity object and its instances */
  RUN retrieveDesignObject IN hRepDesignManager
    (INPUT pcEntityName,
     INPUT '':U,              /* Default result codes */
     OUTPUT TABLE ttObject,
     OUTPUT TABLE ttPage,
     OUTPUT TABLE ttLink,
     OUTPUT TABLE ttUIEvent,
     OUTPUT TABLE ttObjectAttribute) NO-ERROR.
  IF RETURN-VALUE > '':U THEN RETURN.

  cCalcClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT 'CalculatedField':U).
  
  /* Read though the entity's instances and create a temp-table record for the 
     calculated fields */
  FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj > 0:
    IF LOOKUP(ttObject.tClassName, cCalcClassList) > 0 THEN
    DO:
      FIND FIRST ttCalcField WHERE ttCalcField.tName = ttObject.tLogicalObjectname AND
          ttCalcField.tEntity = pcEntityName AND
          ttCalcField.tInstanceName = ttObject.tObjectInstanceName NO-ERROR.
      IF NOT AVAILABLE ttCalcField THEN
      DO:
        CREATE ttCalcField.
        ASSIGN
          ttCalcField.tName          = ttObject.tLogicalObjectname
          ttCalcField.tDesc          = ttObject.tObjectDescription   
          ttCalcField.tProductModule = ttObject.tProductModuleCode
          ttCalcField.tEntity        = pcEntityName
          ttCalcField.tInstanceName  = ttObject.tObjectInstanceName.

        IF NOT CAN-FIND(FIRST ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassName) THEN
          RUN retrieveDesignClass IN hRepDesignManager
                            ( INPUT  ttObject.tClassName,
                              OUTPUT cInheritClasses,
                              OUTPUT TABLE ttClassAttribute ,
                              OUTPUT TABLE ttUiEvent,
                              OUTPUT TABLE ttSupportedLink    ) NO-ERROR.   
        
        /* Get attributes for the calculated field to display in the SDO's column editor */
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Data-Type':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tDataType = IF ttObjectAttribute.tAttributeValue = ? 
                                         THEN '?':U 
                                         ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Data-Type':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tDataType = IF ttClassAttribute.tAttributeValue = ?
                                           THEN '?':U
                                           ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Label':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tLabel = IF ttObjectAttribute.tAttributeValue = ? 
                                      THEN '?':U 
                                      ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Label':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tLabel = IF ttClassAttribute.tAttributeValue = ?
                                        THEN '?':U
                                        ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Format':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tFormat = IF ttObjectAttribute.tAttributeValue = ? 
                                       THEN '?':U 
                                       ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Format':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tFormat = IF ttClassAttribute.tAttributeValue = ?
                                         THEN '?':U
                                         ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'Help':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tHelp = IF ttObjectAttribute.tAttributeValue = ? 
                                     THEN '?':U 
                                     ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'Help':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tHelp = IF ttClassAttribute.tAttributeValue = ?
                                       THEN '?':U
                                       ELSE ttClassAttribute.tAttributeValue.
        END.

        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartobjectObj AND
                                 ttObjectAttribute.tObjectInstanceObj = 0 AND 
                                 ttObjectAttribute.tAttributeLabel    = 'ColumnLabel':U NO-ERROR.
        IF AVAILABLE ttObjectAttribute THEN
          ASSIGN ttCalcField.tColumnLabel = IF ttObjectAttribute.tAttributeValue = ? 
                                            THEN '?':U 
                                            ELSE ttObjectAttribute.tAttributeValue.
        ELSE DO:
          FIND ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName AND
                                  ttClassAttribute.tAttributeLabel = 'ColumnLabel':U NO-ERROR.
          IF AVAILABLE ttClassAttribute THEN
            ASSIGN ttCalcField.tColumnLabel = IF ttClassAttribute.tAttributeValue = ?
                                              THEN '?':U
                                              ELSE ttClassAttribute.tAttributeValue.
        END.

      END.  /* if not avail ttCalcField */
    END.  /* if calculated field */
  END.  /* for each instance */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject dTables  _DB-REQUIRED
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ttCalcField.

  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* First get the calculated fields for the entities of the SDO, if none are found
     all calculated fields are retrieved */
  RUN createttFromSDO.
  FIND FIRST ttCalcField NO-ERROR.
  IF NOT AVAILABLE ttCalcField THEN
    RUN createttForAllCalc.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recreatettRecs dTables  _DB-REQUIRED
PROCEDURE recreatettRecs :
/*------------------------------------------------------------------------------
  Purpose:     Re-creates the calculated field temp table records.
  Parameters:  pcShowCalc AS CHARACTER 
  Notes:       Invoked from the Calculated Field Selector when the All or 
               Entity radio set is changed.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcShowCalc AS CHARACTER    NO-UNDO.

  closeQuery().
  EMPTY TEMP-TABLE ttCalcField.
  CASE pcShowCalc:
      WHEN 'All':U THEN RUN createttForAllCalc.
      WHEN 'SDO':U THEN RUN createttFromSDO.
  END CASE.
  openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowCalc dTables  _DB-REQUIRED
FUNCTION getShowCalc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns value indicating whether the calc field temp table records
            include calculated fields from all entities or just the SDO entities.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcShowCalc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

