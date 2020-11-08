&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/rycsoful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: rycsochgtypv.w

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/21/2002  Author:     

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       rycsochgtypv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/ttcombo.i}

DEFINE VARIABLE gdType                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE STREAM sLog.

ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                             INPUT "RepositoryDesignManager":U).

DEFINE TEMP-TABLE ttObject
    FIELD cName   AS CHARACTER
    FIELD cDesc   AS CHARACTER
    FIELD cModule AS CHARACTER
    INDEX idxName cName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttObject

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ttObject.cName ttObject.cDesc ttObject.cModule   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse   
&Scoped-define SELF-NAME BrBrowse
&Scoped-define QUERY-STRING-BrBrowse FOR EACH ttObject BY ttObject.cName
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttObject BY ttObject.cName.
&Scoped-define TABLES-IN-QUERY-BrBrowse ttObject
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse ttObject


/* Definitions for FRAME frMain                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frMain ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule buRefresh BrBrowse ~
lChangeType lRemoveDefault lRemoveOthers raProcess 
&Scoped-Define DISPLAYED-OBJECTS coProductModule lChangeType lRemoveDefault ~
lRemoveOthers raProcess 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_fromType AS HANDLE NO-UNDO.
DEFINE VARIABLE h_toType AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buProcess 
     LABEL "&Process" 
     SIZE 61 BY 1.14 TOOLTIP "Process the object type change and/or attribute removal"
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 18 BY 1.14 TOOLTIP "Press Refresh to fill the browser with objects of this type and product module"
     BGCOLOR 8 .

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE raProcess AS CHARACTER INITIAL "All" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Process All Objects In Browser", "all",
"Process Selected Objects", "selected"
     SIZE 68 BY 1.52 TOOLTIP "Choose to process all objects displayed in the browser or only those selected" NO-UNDO.

DEFINE VARIABLE lChangeType AS LOGICAL INITIAL yes 
     LABEL "Change Object Type" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE lRemoveDefault AS LOGICAL INITIAL yes 
     LABEL "Remove Attributes That Match Object Type Defaults" 
     VIEW-AS TOGGLE-BOX
     SIZE 54 BY .95 NO-UNDO.

DEFINE VARIABLE lRemoveOthers AS LOGICAL INITIAL yes 
     LABEL "Remove Attributes That Are Not Part Of The Class" 
     VIEW-AS TOGGLE-BOX
     SIZE 59 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      ttObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse vTableWin _FREEFORM
  QUERY BrBrowse DISPLAY
      ttObject.cName   FORMAT 'x(35)':U LABEL 'Object Filename':U
 ttObject.cDesc   FORMAT 'x(60)':U LABEL 'Object Description':U
 ttObject.cModule FORMAT 'x(25)':U LABEL 'Product Module Code':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 125 BY 13.91 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProductModule AT ROW 2.43 COL 32 COLON-ALIGNED
     buRefresh AT ROW 2.43 COL 89.6
     BrBrowse AT ROW 3.81 COL 3
     lChangeType AT ROW 18 COL 6
     lRemoveDefault AT ROW 18.91 COL 6
     lRemoveOthers AT ROW 19.91 COL 6
     raProcess AT ROW 20.76 COL 30 NO-LABEL
     buProcess AT ROW 22.57 COL 33
     SPACE(34.00) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,Browse,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
      END-FIELDS.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 23.05
         WIDTH              = 130.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB BrBrowse buRefresh frMain */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buProcess IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttObject BY ttObject.cName.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buProcess
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProcess vTableWin
ON CHOOSE OF buProcess IN FRAME frMain /* Process */
DO:

  ASSIGN 
    raProcess
    lChangeType
    lRemoveDefault
    lRemoveOthers.

  IF lChangeType THEN 
    RUN changeObjectType.

  IF (NOT lChangeType) AND (lRemoveDefault OR lRemoveOthers) THEN 
    RUN removeAttributes.

  RUN initializeData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh vTableWin
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
  ASSIGN gdType = DYNAMIC-FUNCTION('getDataValue':U IN h_fromType).
  
  IF gdType > 0 THEN 
  DO:
    RUN initializeData.
    buProcess:SENSITIVE = TRUE.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelFrom Object Type CodeFieldTooltipPress F4 for Object Type LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatx(30)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_object_typeBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(15)|X(35)RowsToBatch200BrowseTitleObject Type LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatx(30)SDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldName<Local_1>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_fromType ).
       RUN repositionObject IN h_fromType ( 1.29 , 34.00 ) NO-ERROR.
       RUN resizeObject IN h_fromType ( 1.00 , 55.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelTo Object Type CodeFieldTooltipPress F4 for Object Type LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatx(30)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_object_typeBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(15)|X(35)RowsToBatch200BrowseTitleObject Type LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatx(30)SDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldName<Local_2>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_toType ).
       RUN repositionObject IN h_toType ( 17.91 , 73.00 ) NO-ERROR.
       RUN resizeObject IN h_toType ( 1.00 , 55.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_fromType ,
             coProductModule:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_toType ,
             BrBrowse:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectType vTableWin 
PROCEDURE changeObjectType PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Changes object type for all objects in the browser or all selected
               objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAnswer            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildObjectTypes  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentObjectTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectType        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iNumSelected       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lError             AS LOGICAL    NO-UNDO.

  dObjectType = DYNAMIC-FUNCTION('getDataValue':U IN h_toType).
  
  IF dObjectType > 0 THEN
  DO:
    ASSIGN 
      cFromType = DYNAMIC-FUNCTION('getDisplayValue':U IN h_fromType)
      cToType = DYNAMIC-FUNCTION('getDisplayValue':U IN h_toType)
      cChildObjectTypes = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT cFromType)
      cParentObjectTypes = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT cFromType).
    
    IF LOOKUP(cToType,cChildObjectTypes) > 1 OR 
       LOOKUP(cToType,cParentObjectTypes) > 1 THEN
    DO:
      RUN askQuestion IN gshSessionManager
          (INPUT 'You have chosen to change the object type to ':U + cToType + ' for ':U + 
             (IF raProcess = 'all':U THEN 'all objects displayed in the browser.  ':U
              ELSE 'the selected objects in the browser.  ':U) +
             (IF lRemoveDefault THEN 'Any attribute values for these objects and their instances ':U +
              'that match the default values at the object type level will be removed.  ':U ELSE '':U) +
             (IF lRemoveOthers THEN 'Any attribute values for these objects and their instances ':U +
               'that are not part of the new class will be removed.  ':U ELSE '':U) +
              'Do you wish to continue?':U,
           INPUT "&Yes,&No":U,     /* button list */
           INPUT "&No":U,         /* default */
           INPUT "&No":U,          /* cancel */
           INPUT "Continue object type change":U, /* title */
           INPUT "":U,             /* datatype */
           INPUT "":U,             /* format */
           INPUT-OUTPUT cAnswer,   /* answer */
           OUTPUT cButton          /* button pressed */ ).
      IF cButton = "&Yes":U OR cButton = "Yes":U THEN 
      DO:
        OUTPUT STREAM sLog TO 'OTC.log':U APPEND.
        PUT STREAM sLog UNFORMATTED 
          'Object Type Change Utility Log':U SPACE(2) TODAY SPACE(2) STRING(TIME,'HH:MM':U) SKIP(1)
          'Options Selected':U SKIP
          '================':U SKIP
          'Object Type: ':U cFromType SKIP
          'Changing Object Type to: ':U cToType SKIP
          'Remove Attributes That Match Object Type Defaults: ':U lRemoveDefault SKIP
          'Remove Attributes That Are Not Part Of The New Class: ':U lRemoveOthers SKIP
          'Objects to Change: ':U raProcess SKIP(1)
          'Processing':U SKIP 
          '----------':U SKIP.
        SESSION:SET-WAIT-STATE('GENERAL':U).      
        Trans-Block:
        DO TRANSACTION:
          IF raProcess = 'all':U THEN 
          DO:
            FOR EACH ttObject:
              RUN changeObjectType IN ghRepositoryDesignManager
                  (INPUT ttObject.cName,
                   INPUT cToType,
                   INPUT lRemoveDefault,
                   INPUT lRemoveOthers) NO-ERROR.

              IF RETURN-VALUE NE '':U THEN
              DO:
                cError = RETURN-VALUE.
                UNDO Trans-Block, LEAVE Trans-Block.
              END.  /* if return-value ne '' */

              PUT STREAM sLog UNFORMATTED
                ttObject.cName SKIP.
            END.  /* for each ttObject */
          END.  /* if change all objects */
          ELSE DO iNumSelected = 1 TO BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS:
            BROWSE {&BROWSE-NAME}:FETCH-SELECTED-ROW(iNumSelected).
            GET CURRENT {&BROWSE-NAME} NO-LOCK.
       
            RUN changeObjectType IN ghRepositoryDesignManager
                (INPUT ttObject.cName,
                 INPUT cToType,
                 INPUT lRemoveDefault,
                 INPUT lRemoveOthers) NO-ERROR.

            IF RETURN-VALUE NE '':U THEN
            DO:
              cError = RETURN-VALUE.
              UNDO Trans-Block, LEAVE Trans-Block.
            END.  /* if return-value ne '' */

            PUT STREAM sLog UNFORMATTED
              ttObject.cName SKIP.
          END.  /* if change selected objects */
        END.  /* do transaction */
        
        SESSION:SET-WAIT-STATE('':U).

        IF cError NE '':U THEN
        DO:
          PUT STREAM sLog UNFORMATTED SKIP(1)
            'A failure occurred during the processing of object type changes, ':U SKIP
            'all object type changes have been backed out.':U SKIP.

          cError  = cError + CHR(3) + 
                    'A failure has occurred during the processing of object type changes.  ':U +
                    'All object type changes have been backed out.':U.
                     
          RUN showMessages IN gshSessionManager (INPUT cError,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Object Type Change Failure",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
        END.  /* if error */
        ELSE
          RUN showMessages IN gshSessionManager (INPUT 'The Object Type Change was successful.':U,
                                                 INPUT "INF":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Object Type Change",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
        PUT STREAM sLog UNFORMATTED SKIP(1) 'Finished Processing':U SPACE(2) STRING(TIME,'HH:MM':U) SKIP(2).
        OUTPUT STREAM sLog CLOSE.
      END.  /* if choose to continue */
      ELSE RETURN.
    END.  /* if to type in hierarchy */
    ELSE DO:
      RUN showMessages IN gshSessionManager
        (INPUT 'The Object Type that the objects are being changed to ':U + 
               'must be in the same hierarchy as the Object Type they are being changed from.':U,
         INPUT 'ERR':U,
         INPUT 'OK':U,
         INPUT 'OK':U,
         INPUT 'OK':U,
         INPUT 'Change Object Type Failure':U,
         INPUT YES,
         INPUT ?,
         OUTPUT cButton).                
    END.  /* else do - to type not in from type hierarchy */
  END.  /* if to object type specified */
  ELSE DO:
    RUN showMessages IN gshSessionManager 
        (INPUT 'The Object Type the objects are being changed to must be specified.':U,
         INPUT 'ERR':U,
         INPUT 'OK':U,
         INPUT 'OK':U,
         INPUT 'OK':U,
         INPUT 'Change Object Type Failure':U,
         INPUT YES,
         INPUT ?,
         OUTPUT cButton).
  END.  /* else do - to object type not specified */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData vTableWin 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     Populates ttObject with objects for the selected type to 
               display in the browser
  Parameters:  <none>
  Notes:       Invoked when bRefresh is chosen.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWhere      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dModule     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hObject     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hModule     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iComboCount AS INTEGER    NO-UNDO.

  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttObject. ELSE FOR EACH ttObject: DELETE ttObject. END.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      coProductModule
      dModule = coProductModule.
  END.  /* do with frame */

  CREATE QUERY hQuery.
  CREATE BUFFER hObject FOR TABLE 'ryc_smartobject':U.
  CREATE BUFFER hModule FOR TABLE 'gsc_product_module':U.

  hQuery:SET-BUFFERS(hObject, hModule).
  
  cWhere = 'FOR EACH ryc_smartobject NO-LOCK':U
         + '   WHERE ryc_smartobject.customization_result_obj = 0 ':U
         + '     AND ryc_smartobject.object_type_obj          = ':U + QUOTER(gdType)

         + (IF dModule > 0 THEN ' AND ryc_smartobject.product_module_obj = ':U + QUOTER(dModule) ELSE '':U) + ",":U

         + '  FIRST gsc_product_module NO-LOCK ':U
         + '  WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj ':U
         + '    AND [&FilterSet=|&EntityList=GSCPM,RYCSO] ':U
         + '     BY ryc_smartobject.object_filename':U.     

  RUN processQueryStringFilterSets IN gshGenManager (INPUT  cWhere,
                                                     OUTPUT cWhere).

  hQuery:QUERY-PREPARE(cWhere).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE hObject:AVAILABLE:
      
    CREATE ttObject.
    ASSIGN 
      ttObject.cName   = hObject:BUFFER-FIELD('object_filename':U):BUFFER-VALUE 
      ttObject.cDesc   = hObject:BUFFER-FIELD('object_description':U):BUFFER-VALUE
      ttObject.cModule = hModule:BUFFER-FIELD('product_module_code':U):BUFFER-VALUE.

    hQuery:GET-NEXT().

  END.  /* do while no off end */
  hQuery:QUERY-CLOSE().

  DELETE OBJECT hQuery.
  DELETE OBJECT hObject.
  DELETE OBJECT hModule.
  ASSIGN 
    hQuery  = ?
    hObject = ?
    hModule = ?.

  {&OPEN-QUERY-{&BROWSE-NAME}}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override of initializeObject
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  coProductModule:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3).

  BROWSE {&BROWSE-NAME}:ROW-MARKERS = TRUE.
  
  RUN SUPER.

  RUN populateCombo. 
  RUN enableField IN h_FromType.
  RUN enableField IN h_toType.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombo vTableWin 
PROCEDURE populateCombo :
/*------------------------------------------------------------------------------
  Purpose:     Populate Product Module combo-box
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cWhereClause  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iModuleCount  AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    EMPTY TEMP-TABLE ttComboData.

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
           ttComboData.cForEach           = "FOR EACH gsc_product_module NO-LOCK":U
                                          + "   WHERE [&FilterSet=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U.

    RUN processQueryStringFilterSets IN gshGenManager (INPUT  ttComboData.cForEach,
                                                       OUTPUT ttComboData.cForEach).

    /* build combo list-item pairs */
    RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

    FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
    coProductModule:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

    IF coProductModule:NUM-ITEMS > 0 THEN
    DO:
      ASSIGN cEntry = coProductModule:ENTRY(1) NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
      DO:
        ASSIGN coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
        ASSIGN coProductModule.
      END.
    END.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeAttributes vTableWin 
PROCEDURE removeAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Resets attributes of all objects or selected objects in the browser
               to default values for the object type 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cAnswer            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFromType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumSelected       AS INTEGER    NO-UNDO.

  cFromType = DYNAMIC-FUNCTION('getDisplayValue':U IN h_fromType).
  RUN askQuestion IN gshSessionManager
      (INPUT 'You have chosen to remove attribute values of ':U + 
         (IF raProcess = 'all':U THEN 'all objects displayed in the browser and their instances.  ':U
          ELSE 'the selected objects in the browser and their instances.  ':U) +
         (IF lRemoveDefault THEN 'Any attribute values that match the default values at the object type level will be removed.  ':U
          ELSE '':U) +
         (IF lRemoveOthers THEN 'Any attribute values that are not part of the class will be removed.  ':U
          ELSE '':U) +
         'Do you wish to continue?':U,
       INPUT "&Yes,&No":U,     /* button list */
       INPUT "&No":U,         /* default */
       INPUT "&No":U,          /* cancel */
       INPUT "Continue removal of attribute values":U, /* title */
       INPUT "":U,             /* datatype */
       INPUT "":U,             /* format */
       INPUT-OUTPUT cAnswer,   /* answer */
       OUTPUT cButton          /* button pressed */ ).
  IF cButton = "&Yes":U OR cButton = "Yes":U THEN 
  DO:     
    OUTPUT STREAM sLog TO 'OTC.log':U APPEND.
    PUT STREAM sLog UNFORMATTED 
      'Object Type Change Utility Log':U SPACE(2) TODAY SPACE(2) STRING(TIME,'HH:MM':U) SKIP(1)
      'Options Selected':U SKIP
      '================':U SKIP
      'Object Type: ':U cFromType SKIP
      'Remove Attributes That Match Object Type Defaults: ':U lRemoveDefault SKIP
      'Remove Attributes That Are Not Part Of The Class: ':U lRemoveOthers SKIP
      'Objects to Change: ':U raProcess SKIP(1)
      'Processing':U SKIP 
      '----------':U SKIP.
    SESSION:SET-WAIT-STATE('GENERAL':U).

    Trans-Block:
    DO TRANSACTION:
      IF raProcess = 'all':U THEN 
      DO:
        FOR EACH ttObject:
        
          RUN removeDefaultAttrValues IN ghRepositoryDesignManager
              (INPUT ttObject.cName,
               INPUT lRemoveDefault,
               INPUT lRemoveOthers) NO-ERROR.

          IF RETURN-VALUE NE '':U THEN
          DO:
            cError = RETURN-VALUE.
            UNDO Trans-Block, LEAVE Trans-Block.
          END.  /* if return-value ne '' */
        
          PUT STREAM sLog UNFORMATTED
            ttObject.cName SKIP.
        END.  /* for each ttObject */
      END.  /* if change all objects */
      ELSE DO iNumSelected = 1 TO BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        BROWSE {&BROWSE-NAME}:FETCH-SELECTED-ROW(iNumSelected).
        GET CURRENT {&BROWSE-NAME} NO-LOCK.
   
          RUN removeDefaultAttrValues IN ghRepositoryDesignManager
              (INPUT ttObject.cName,
               INPUT lRemoveDefault,
               INPUT lRemoveOthers) NO-ERROR.

          IF RETURN-VALUE NE '':U THEN
          DO:
            cError = RETURN-VALUE.
            UNDO Trans-Block, LEAVE Trans-Block.
          END.  /* if return-value ne '' */
   
        PUT STREAM sLog UNFORMATTED
          ttObject.cName SKIP.
      END.  /* if change selected objects */
    END.  /* do transaction */
    SESSION:SET-WAIT-STATE('':U).

    IF cError NE '':U THEN
    DO:
      PUT STREAM sLog UNFORMATTED SKIP(1)
        'A failure occurred during the processing of attribute removal, ':U SKIP
        'all attribute removals have been backed out.':U SKIP.

      cError  = cError + CHR(3) + 
                'A failure has occurred during the processing of attribute removal.  ':U +
                'All attribute removals have been backed out.':U.

      RUN showMessages IN gshSessionManager (INPUT cError,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Object Attribute Removal Failure",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    END.  /* if error */
    ELSE
      RUN showMessages IN gshSessionManager (INPUT 'The attribute removal was successful.':U,
                                             INPUT "INF":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Object Type Change",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
    PUT STREAM sLog UNFORMATTED SKIP(1) 'Finished Processing':U SPACE(2) STRING(TIME,'HH:MM':U) SKIP(2).
    OUTPUT STREAM sLog CLOSE.
  END.  /* if choose to continue */
  ELSE RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

