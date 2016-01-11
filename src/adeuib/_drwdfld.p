&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: _drwdfld.p

  Description:  Procedure to create _U, _L and _F records for DB-FIELDS being
                dropped onto a dynamic viewer.  The _U, _L and _F values are
                populated with datafield master attributes values.  Invoked
                by adeuib/_drawobj.p and adeuib/_crtsobj.w.

  Purpose:

  Parameters:   pcFields AS CHARACTER - indicates fields that have already
                                        been selected
                                        

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/23/2003  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _drwdfld.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i }
/** Contains definitions for all design-time temp-tables. **/
{destdefi.i}


DEFINE INPUT  PARAMETER pcFields AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cAttribute        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFieldList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcMasterName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalculatedCols   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cErrorFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInheritsFromClasses AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessageList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDOName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmp              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdColumns       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVisType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dFormatHeight     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFormatWidth      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iCnt              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTabNumber        AS INTEGER    NO-UNDO.
DEFINE VARIABLE dColumn           LIKE _L._COL  NO-UNDO.
DEFINE VARIABLE dRow              LIKE _L._ROW  NO-UNDO.
DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldNum         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lCalculatedCol   AS LOGICAL    NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

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
         HEIGHT             = 10.86
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE parent_L._u-recid = RECID(parent_U) AND
                    parent_L._lo-name = "Master Layout".

hDataSource = DYNAMIC-FUNCTION('get-proc-hdl':U IN _h_func_lib, INPUT _P._data-object).
hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

ASSIGN 
   cUpdColumns     = DYNAMIC-FUNCTION('getUpdatableColumns':U IN hDataSource)
   cDataSourceType = DYNAMIC-FUNCTION('getObjectType':U IN hDataSource)
   cCalculatedCols = DYNAMIC-FUNCTION('getCalculatedColumns':U IN hDataSource)
   cCalcFieldList  = DYNAMIC-FUNCTION('getCalcFieldList':U IN hDataSource).

/* selectFields invokes the multi-field selector if the fields parameter is
   blank */
IF pcFields = '':U THEN 
  RUN selectFields.
ELSE cFields = pcFields.

/* adjustColumn reads labels for each field and adjust _frmx 
   to accomodate those labels.  It also caches the datafield master object on 
   the client and if it does not exist it returns 'DataField' to indicate this.
   If 'DataField' is returned, fields are not drawn on the viewer. */
RUN adjustColumn.
IF cMessageList NE '':U THEN
  MESSAGE cMessageList VIEW-AS ALERT-BOX ERROR.

ASSIGN 
  dColumn = 1.0 + (_frmx / SESSION:PIXELS-PER-COL) 
  dRow    = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW).


/* Read through picked fields and create _U, _L and _F records and populate
   them from datafield master attribute values. */
FieldLoop:
DO iFieldNum = 1 TO NUM-ENTRIES(cFields):
  cListField = ENTRY(iFieldNum, cFields).
  IF LOOKUP(cListField, cErrorFields) > 0 THEN 
    NEXT FieldLoop.        
  
  ASSIGN
    lCalculatedCol = LOOKUP(cListField, cCalculatedCols) > 0
    cTable         = DYNAMIC-FUNCTION('ColumnPhysicalTable':U IN hDataSource, cListField) 
    cObjectName    = IF LOOKUP(cListField, cCalculatedCols) > 0 
                     THEN cListField
                     ELSE DYNAMIC-FUNCTION('ColumnPhysicalColumn':U IN hDataSource, cListField)
    cObjectName    = REPLACE(cObjectName,"[","")
    cObjectName    = REPLACE(cObjectName,"]","") NO-ERROR.

  IF lCalculatedCol AND cCalcFieldList NE '':U THEN
    cObjectName = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                    INPUT cObjectName,             
                                    INPUT cCalcFieldList,         
                                    INPUT TRUE,                   
                                    INPUT ",":U).

  IF cDataSourceType = 'SmartBusinessObject':U AND NUM-ENTRIES(cListField, '.':U) > 1 THEN
  DO:
     ASSIGN cSDOName    = ENTRY(1, cListField, '.':U).
     IF lCalculatedCol THEN 
         cObjectName = ENTRY(2,cObjectName,".":U).
  END.  /* if data source SBO */
  
  /* Retrieve the master datafield from the repository */
  RUN retrieveDesignObject IN hRepDesignManager ( INPUT  cObjectName,
                                                  INPUT  "",  /* Get default result Code */
                                                  OUTPUT TABLE ttObject ,
                                                  OUTPUT TABLE ttPage,
                                                  OUTPUT TABLE ttLink,
                                                  OUTPUT TABLE ttUiEvent,
                                                  OUTPUT TABLE ttObjectAttribute ) NO-ERROR.                                            
  
  /* Get the Master datafield */
  FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cObjectName NO-ERROR.
  IF AVAIL ttObject THEN 
  DO:   
  /* get inherited values of the class */
     RUN retrieveDesignClass IN hRepDesignManager
                                ( INPUT  ttObject.tClassname,
                                  OUTPUT cInheritsFromClasses,
                                  OUTPUT TABLE ttClassAttribute,
                                  OUTPUT TABLE ttUiEvent,
                                  OUTPUT TABLE ttSupportedLink ) NO-ERROR.       
     CREATE _U.
     CREATE _L.
     CREATE _F.
     
     FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                              AND ttObjectAttribute.tAttributeLabel    = 'Data-Type':U NO-ERROR.
     
     IF AVAIL ttObjectAttribute THEN
        cDataType = ttObjectAttribute.tAttributeValue.    
     ELSE DO:   
        FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = ttObject.tClassname 
                                AND ttClassAttribute.tAttributelabel = "Data-Type":U NO-ERROR.
        IF AVAIL ttClassAttribute THEN
           cDataType = ttClassAttribute.tAttributeValue.
     END.   
     
     FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                              AND ttObjectAttribute.tAttributeLabel    = 'VisualizationType':U NO-ERROR.
     
     IF AVAIL ttObjectAttribute THEN
        cVisType = ttObjectAttribute.tAttributeValue.    
     ELSE DO:   
        FIND ttClassAttribute WHERE ttClassAttribute.tClassname      = ttObject.tClassname 
                                AND ttClassAttribute.tAttributelabel = "VisualizationType":U NO-ERROR.
        IF AVAIL ttClassAttribute THEN
           cVisType = ttClassAttribute.tAttributeValue.
     END.   
     IF cDataType = 'CLOB':U THEN
       ASSIGN cVisType = 'EDITOR':U.
     
     ASSIGN
       iTabNumber        = iTabNumber + 1
       _U._NAME          = IF cDataSourceType = 'SmartBusinessObject':U AND NUM-ENTRIES(cListField, '.':U) > 1
                           THEN ENTRY(2,cListField,".") ELSE cListField /* If from SBO, remove SDO qualifier */
       _U._DBNAME        = 'Temp-Tables':U
       _U._TABLE         = IF cDataSourceType = 'SmartDataObject':U THEN cTable
                           ELSE cSDOName
       _U._BUFFER        = IF cDataSourceType = 'SmartDataObject':U THEN 'RowObject':U
                           ELSE cTable
       _L._ROW           = dRow
       _L._COL           = dColumn
       _L._COL-MULT      = parent_L._COL-MULT
       _L._ROW-MULT      = parent_L._ROW-MULT
       _U._lo-recid      = RECID(_L)
       _L._u-recid       = RECID(_U)
       _U._x-recid       = RECID(_F)
       _U._parent-recid  = RECID(parent_U)
       _U._WINDOW-HANDLE = _h_win
       _U._PARENT        = parent_U._HANDLE
       _L._LO-NAME       = 'Master Layout':U
       _U._LABEL-SOURCE  = "D":U 
       _U._HELP-SOURCE   = "D":U 
       _U._ALIGN         = IF CAN-DO('FILL-IN,COMBO-BOX', cVisType) THEN 'C':U
                           ELSE 'L':U                   
       _U._SENSITIVE     = YES
       _F._FRAME         = parent_U._HANDLE
       _F._FORMAT-SOURCE = "D":U
       _U._TYPE          = cVisType
       _L._WIN-TYPE      = parent_L._WIN-TYPE
       _U._CLASS-NAME    = ttObject.tClassname
       _U._OBJECT-NAME   = ttObject.tLogicalObjectName
       _U._TAB-ORDER     = iTabNumber.
     
     /* Set the class attributes */
     FOR EACH ttClassAttribute WHERE ttClassAttribute.tClassname = ttObject.tClassname:
       RUN setAttributes(ttClassAttribute.tAttributeLabel,ttClassAttribute.tAttributeValue).
     END.  /* For each ttClassAttribute */
     
          
     /* Set the master attributes */
     FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                  AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj:
        RUN setAttributes(ttObjectAttribute.tAttributeLabel,ttObjectAttribute.tAttributeValue).                          
     END.  /* For each ttObjectAttribute */

     /* Now that we have read all of the attributes in, and know the delimiter (if any),
        fix list-items and list-item-pairs */
     IF _F._LIST-ITEMS NE ? AND _U._TYPE NE "RADIO-SET":U
       THEN _F._LIST-ITEMS = REPLACE(_F._LIST-ITEMS, _F._DELIMITER, CHR(10)).
     ELSE IF _U._TYPE EQ "RADIO-SET" THEN DO:
       /* Put <CR> after the values */
       IF NUM-ENTRIES(_F._LIST-ITEMS, _F._DELIMITER) > 3 AND
          NUM-ENTRIES(_F._LIST-ITEMS, CHR(10)) < 2 THEN DO:
         DO iCnt = 3 TO NUM-ENTRIES(_F._LIST-ITEMS, _F._DELIMITER) BY 2:
           ENTRY(iCnt, _F._LIST-ITEMS, _F._DELIMITER) = CHR(10) + 
               ENTRY(iCnt, _F._LIST-ITEMS, _F._DELIMITER).
         END.
       END.  /* There are more than 1 item and no <CR>s */
     END.  /* if radio-set */

     IF _F._LIST-ITEM-PAIRS NE ? AND _F._LIST-ITEM-PAIRS NE "":U THEN DO: 
       cTmp = "":U.
       DO iCnt = 1 TO NUM-ENTRIES(_F._LIST-ITEM-PAIRS, _F._DELIMITER):
         cTmp = cTmp + _F._DELIMITER + 
                       (IF iCnt MOD 2 = 1 THEN CHR(10) ELSE "") +
                       ENTRY(iCnt, _F._LIST-ITEM-PAIRS, _F._DELIMITER). 
       END.
       _F._LIST-ITEM-PAIRS = TRIM(cTmp, CHR(10) + _F._DELIMITER).
     END. /* IF List ITEM PAIRS is non blank */

     IF _L._HEIGHT = 0 OR _L._WIDTH = 0 OR _L._HEIGHT = ? OR _L._WIDTH = ? THEN
     DO:
       dFormatWidth = DYNAMIC-FUNCTION('getWidgetSizeFromFormat':U IN hRepDesignManager,
                                        INPUT _F._FORMAT,
                                        INPUT 'CHARACTER':U,
                                        OUTPUT dFormatHeight).
       IF _L._HEIGHT = 0 OR _L._HEIGHT = ? THEN _L._HEIGHT = dFormatHeight.
       IF _L._WIDTH  = 0 OR _L._WIDTH = ?  THEN _L._WIDTH  = dFormatWidth.
     END.  /* if height or width is 0 */
     IF _L._HEIGHT = 0 OR _L._HEIGHT = ? THEN _L._HEIGHT = 1.
     IF _L._WIDTH = 0 OR _L._WIDTH = ?   THEN _L._WIDTH  = 10.

     /* Create multiple layout records if necessary */
     {adeuib/crt_mult.i}

     /* Instantiate the field in the design window */
     CASE cVisType:
       WHEN 'FILL-IN':U OR WHEN 'TEXT':U THEN RUN adeuib/_undfill.p (RECID(_U)).
       WHEN 'COMBO-BOX':U      THEN RUN adeuib/_undcomb.p (RECID(_U)).
       WHEN 'EDITOR':U         THEN RUN adeuib/_undedit.p (RECID(_U)).
       WHEN 'RADIO-SET':U      THEN RUN adeuib/_undradi.p (RECID(_U)).
       WHEN 'SELECTION-LIST':U THEN RUN adeuib/_undsele.p (RECID(_U)).
       WHEN 'TOGGLE-BOX':U     THEN RUN adeuib/_undtogg.p (RECID(_U)).
     END CASE.

     dRow = dRow + _L._HEIGHT.

   END.  /* if ttObject avail */
      
END.  /* do iFieldNum to number fields picked */

RUN adeuib/_tabordr.p (INPUT 'NORMAL':U, INPUT RECID(parent_U)).
DYNAMIC-FUNCTION('shutdown-proc':U IN _h_func_lib, INPUT _P._data-object).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adjustColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustColumn Procedure 
PROCEDURE adjustColumn :
/*------------------------------------------------------------------------------
  Purpose:     Reads the label for each field and adjusts _frmx to accomodate 
               these labels
  Parameters:  <none>
  Notes:       The is the first time the datafield master object read from
               from the repository, if a master object does not exist, that
               field is not added to the viewer.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDataType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFormat          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHelp            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInvalidAttrs    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValidateMessage AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iMessageLoop     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWidth           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSDOName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lObjectExists    AS LOGICAL    NO-UNDO.

DEFINE BUFFER another_U FOR _U.

FieldLoop:
DO iFieldNum = 1 TO NUM-ENTRIES(cFields):
  cListField = ENTRY(iFieldNum, cFields).
 
  FIND FIRST another_U WHERE another_U._NAME EQ cListField AND
      another_U._WINDOW-HANDLE EQ _P._WINDOW-HANDLE AND
      another_U._STATUS NE 'DELETED':U NO-ERROR.
  IF AVAILABLE another_U THEN
  DO:
    cMessageList = cMessageList + (IF cMessageList NE '':U THEN CHR(10) + CHR(10) ELSE '':U) + 
                   'The datafield "':U + cListField + '" could not be added to the viewer because ' +
                   'another object on the viewer is named "':U + cListField + '".  ':U +
                   'Please rename the existing object.':U.
    ASSIGN cErrorFields = cErrorFields + (IF NUM-ENTRIES(cErrorFields) > 0 THEN ',':U ELSE '':U) +
                          cListField.
    NEXT FieldLoop.
  END.  /* if another_U available */

  lCalculatedCol = LOOKUP(cListField, cCalculatedCols) > 0. 
  cObjectName = IF lCalculatedCol THEN cListField 
                ELSE DYNAMIC-FUNCTION('columnPhysicalColumn':U IN hDataSource, cListField).

  ASSIGN cObjectName = REPLACE(cObjectName,"[","")
         cObjectName = REPLACE(cObjectName,"]","").

  IF lCalculatedCol AND cCalcFieldList NE '':U THEN
    cObjectName = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                    INPUT cObjectName,             
                                    INPUT cCalcFieldList,         
                                    INPUT TRUE,                   
                                    INPUT ",":U).

/*   If calculated field and data source is an SBO, the name will have the SDO as a prefix
     as in <sdoName>.<FieldName>.  */
  IF lCalculatedCol AND cDataSourceType = 'SmartBusinessObject':U AND NUM-ENTRIES(cObjectName, '.':U) > 1 THEN
     ASSIGN cSDOName    = ENTRY(1,cObjectName,".":U)       
            cObjectName = ENTRY(2,cObjectName,".":U) 
            NO-ERROR.
  
  lObjectExists = DYNAMIC-FUNCTION('ObjectExists':U IN hRepDesignManager, INPUT cObjectName).
  
  IF NOT lObjectExists THEN
  DO:
    cMessageList = cMessageList + (IF cMessageList NE '':U THEN CHR(10) + CHR(10) ELSE '':U) + 
                   IF lCalculatedCol 
                   THEN 'The calculated field "':U + cObjectName + '" has no master object in the repository. ':U + CHR(10) + 
                        'Please add a calculated field master object called "':U + cObjectName + '" to an entity of the data source using the Entity Control. ':U
                   ELSE 'The datafield "':U + cObjectName + '" has no master object in the repository. ':U + CHR(10) + 
                        'Please use Entity Import to import it or add it using the Entity Control.':U.

    ASSIGN cErrorFields = cErrorFields + (IF NUM-ENTRIES(cErrorFields) > 0 THEN ',':U ELSE '':U) +
                          cListField.
    NEXT FieldLoop.
  END.  /* if object doesn't exist */

  /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
  RUN retrieveDesignObject IN hRepDesignManager ( INPUT  cObjectName,
                                                  INPUT  "",  /* Get default result Code */
                                                  OUTPUT TABLE ttObject ,
                                                  OUTPUT TABLE ttPage,
                                                  OUTPUT TABLE ttLink,
                                                  OUTPUT TABLE ttUiEvent,
                                                  OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
  
  /* get the master Object */
  FIND FIRST ttObject WHERE ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
  IF AVAIL ttObject THEN 
  DO:
    /* If this is a calculated field in a static SDO, the field could have the same name
       as a repository object that is not a calculated fields so there is a check for this */
    IF lCalculatedCol AND 
        NOT DYNAMIC-FUNCTION('ClassIsA':U IN gshRepositoryManager, ttObject.tClassName, 'CalculatedField':U) THEN
    DO:
      cMessageList = cMessageList + (IF cMessageList NE '':U THEN CHR(10) + CHR(10) ELSE '':U)
                     + 'The calculated field "':U + cObjectName + '" has the same name as ':U
                     + 'another repository object.  Please rename the calculated field in the data source.':U.                                                                                            

      ASSIGN cErrorFields = cErrorFields + (IF NUM-ENTRIES(cErrorFields) > 0 THEN ',':U ELSE '':U) +
                          cListField.
      NEXT FieldLoop.
    END.  /* if calc field object is not calc field */

    cValidateMessage = '':U.
    RUN validateDataFieldAttrs IN hRepDesignManager (INPUT cObjectName, 
                                                     OUTPUT cInvalidAttrs,
                                                     OUTPUT cValidateMessage).
    IF cValidateMessage NE '':U THEN
    DO:
      cMessageList = cMessageList + (IF cMessageList NE '':U THEN CHR(10) + CHR(10) ELSE '':U) + 
               cObjectName + ' has invalid attribute values in its Datafield master object.  ':U + CHR(10) +
              'Its invalid attributes are: ':U + cInvalidAttrs + CHR(10) + CHR(10) +
              'Its attribute values must be corrected in DataField Maintenance in order to ':U + CHR(10) +
              'include this datafield in a viewer.':U.
      ASSIGN cErrorFields = cErrorFields + (IF NUM-ENTRIES(cErrorFields) > 0 THEN ',':U ELSE '':U) +
                            cListField.
      NEXT FieldLoop. 
    END.  /* if cMessage not blank */

    FIND FIRST ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                   AND ttObjectAttribute.tAttributelabel    = "LABEL":U  NO-ERROR.
    IF AVAIL ttObjectattribute THEN
        ASSIGN  cLabel = ttObjectAttribute.tAttributevalue + ':  ':U
                iWidth = IF parent_L._FONT <> ? THEN FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLabel, parent_L._FONT)
                                                ELSE FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLabel).
    IF _frmx < iWidth THEN _frmx = iWidth.
  END.  /* if Avail ttobject */
END.  /* do iFieldNum to number fields picked */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectFields Procedure 
PROCEDURE selectFields :
/*------------------------------------------------------------------------------
  Purpose:     Invoke the multi-field selector for the user to choose fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDataFieldName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExcludeFields   AS CHARACTER  NO-UNDO.

DEFINE BUFFER fld_U FOR _U.
DEFINE BUFFER x_S FOR _S.

FOR EACH fld_U WHERE fld_U._PARENT-Recid = RECID(parent_U) AND 
                     fld_U._STATUS <> "DELETED":U NO-LOCK:
  IF fld_U._TABLE = "RowObject":U OR fld_U._BUFFER = "RowObject":U OR 
     fld_U._CLASS-NAME = "DataField":U THEN 
  DO:
    IF cDataSourceType = 'SmartBusinessObject':U THEN
      ASSIGN cExcludeFields = cExcludeFields + fld_U._TABLE + ".":U + fld_U._NAME + ",":U.
    ELSE ASSIGN cExcludeFields = cExcludeFields + fld_U._NAME + ",":U.
  END.  /* if datafield */
  /* special case is when the table is ? but the subtype is a smart
   * data field. We need to go and get the actual field name so we exclude
   * it from the list too.
   */
  ELSE IF fld_U._subtype = 'SmartDataField':U THEN 
  DO:
    FIND x_S WHERE RECID(x_S) = fld_U._x-recid. 
    cDataFieldName = DYNAMIC-FUNCTION('getFieldName':U IN X_S._HANDLE).
    ASSIGN cExcludeFields = cExcludeFields + cDataFieldName + ',':U NO-ERROR.
  END. /* end else if subtype*/
END. /* end for each */
ASSIGN cExcludeFields = TRIM(cExcludeFields, ',') NO-ERROR.   

RUN adecomm/_mfldsel.p
    (INPUT '':U, 
     INPUT hDataSource, 
     INPUT '.|RowObject':U, 
     INPUT '1':U,  
     INPUT ',':U, 
     INPUT cExcludeFields, 
     INPUT-OUTPUT cFields).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributes Procedure 
PROCEDURE setAttributes :
/*------------------------------------------------------------------------------
  Purpose:   Sets the attributes  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcAttribute AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcValue     AS CHARACTER  NO-UNDO.

 CASE pcAttribute :
     WHEN 'AUTO-COMPLETION':U      THEN _F._AUTO-COMPLETION  = LOGICAL(pcValue).
     WHEN 'AUTO-INDENT':U          THEN _F._AUTO-INDENT      = LOGICAL(pcValue).
     WHEN 'AUTO-RESIZE':U          THEN _F._AUTO-RESIZE      = LOGICAL(pcValue).
     WHEN 'AUTO-RETURN':U          THEN _F._AUTO-RETURN      = LOGICAL(pcValue).
     WHEN 'BGCOLOR':U              THEN _L._BGCOLOR          = INTEGER(pcValue).
     WHEN 'BLANK':U                THEN _F._BLANK            = LOGICAL(pcValue).
     WHEN 'BOX':U                  THEN _L._NO-BOX           = NOT LOGICAL(pcValue).
     WHEN 'CONTEXT-HELP-ID':U      THEN _U._CONTEXT-HELP-ID  = INTEGER(pcValue).
     WHEN 'Data-Type':U            THEN 
     DO:
       IF pcValue NE ? THEN
         IF pcValue = 'CLOB':U THEN
           ASSIGN
             _F._DATA-TYPE        = 'LONGCHAR':U
             _F._SOURCE-DATA-TYPE = 'CLOB':U.
         ELSE _F._DATA-TYPE = pcValue.
     END.  /* if data type */
     WHEN 'DEBLANK':U              THEN _F._DEBLANK          = LOGICAL(pcValue).
     WHEN 'DELIMITER':U            THEN _F._DELIMITER        = pcValue.
     WHEN 'DISABLE-AUTO-ZAP':U     THEN _F._DISABLE-AUTO-ZAP = LOGICAL(pcValue).
     WHEN 'DisplayField':U         THEN _U._DISPLAY          = LOGICAL(pcValue).
     WHEN 'DRAG-ENABLED':U         THEN _F._DRAG-ENABLED     = LOGICAL(pcValue).
     WHEN 'DROP-TARGET':U          THEN _U._DROP-TARGET      = LOGICAL(pcValue).
     WHEN 'Enabled':U              THEN DO:
       IF NOT CAN-DO(cUpdColumns, cListField) THEN _U._ENABLE = NO.
       ELSE _U._ENABLE = LOGICAL(pcValue).
     END.
     WHEN 'EXPAND':U               THEN _F._EXPAND           = LOGICAL(pcValue).
     WHEN 'FGCOLOR':U              THEN _L._FGCOLOR          = INTEGER(pcValue).
     WHEN 'FONT':U                 THEN _L._FONT             = INTEGER(pcValue).
     WHEN 'FORMAT':U               THEN _F._FORMAT           = pcValue.
     WHEN 'HEIGHT-CHARS':U         THEN _L._HEIGHT           = DECIMAL(pcValue).
     WHEN 'HELP':U                 THEN _U._HELP             = pcValue.
     WHEN 'Horizontal':U           THEN _F._HORIZONTAL       = LOGICAL(pcValue).
     WHEN 'InitialValue':U         THEN _F._INITIAL-DATA     = pcValue.
     WHEN 'INNER-LINES':U          THEN _F._INNER-LINES      = INTEGER(pcValue).
     WHEN 'LABEL':U                THEN 
     DO: 
       _U._LABEL = pcValue.
       IF _U._LABEL = ? OR _U._LABEL = '':U THEN
         _U._LABEL = _U._NAME.
       _L._LABEL = _U._LABEL.
     END.  /* when label */
     WHEN 'LABELS':U               THEN _L._NO-LABEL         = NOT LOGICAL(pcValue).
     WHEN 'LARGE':U                THEN 
       _F._LARGE = IF _F._SOURCE-DATA-TYPE = 'CLOB':U THEN YES 
                   ELSE LOGICAL(pcValue).
     WHEN 'LIST-ITEM-PAIRS'        THEN _F._LIST-ITEM-PAIRS  = pcValue.
     WHEN 'LIST-ITEMS'             THEN IF cVisType NE 'RADIO-SET':U THEN 
                                          _F._LIST-ITEMS = pcValue.
     WHEN 'MAX-CHARS':U            THEN _F._MAX-CHARS        = INTEGER(pcValue).
     WHEN 'PASSWORD-FIELD':U       THEN _F._PASSWORD-FIELD   = LOGICAL(pcValue).
     WHEN 'PRIVATE-DATA':U         THEN _U._PRIVATE-DATA     = pcValue.
     WHEN 'RADIO-BUTTONS':U        THEN IF cVisType = 'RADIO-SET':U THEN
                                          _F._LIST-ITEMS = pcValue.
     WHEN 'READ-ONLY':U            THEN _F._READ-ONLY        = LOGICAL(pcValue).
     WHEN 'RETURN-INSERTED':U      THEN _F._RETURN-INSERTED  = LOGICAL(pcValue).
     WHEN 'SCROLLBAR-HORIZONTAL':U THEN _F._SCROLLBAR-H      = LOGICAL(pcValue).
     WHEN 'SCROLLBAR-VERTICAL':U   THEN _U._SCROLLBAR-V      = LOGICAL(pcValue).
     WHEN 'ShowPopup':U            THEN _U._SHOW-POPUP       = LOGICAL(pcValue).
     WHEN 'SORT':U                 THEN _F._SORT             = LOGICAL(pcValue).
     WHEN 'SubType':U              THEN IF _U._SUBTYPE NE 'TEXT':U THEN 
                                          _U._SUBTYPE = pcValue.
     WHEN 'TAB-STOP':U             THEN _U._NO-TAB-STOP      = NOT LOGICAL(pcValue).
     WHEN 'TOOLTIP':U              THEN _U._TOOLTIP          = pcValue.
     WHEN 'WIDTH-CHARS':U          THEN _L._WIDTH            = DECIMAL(pcValue).

     WHEN 'VisualizationType':U    THEN 
     DO: 
       _U._TYPE             = IF _F._SOURCE-DATA-TYPE = 'CLOB':U THEN 'EDITOR':U 
                              ELSE pcValue.
       IF _U._TYPE = 'TEXT':U THEN
       DO:
         cColDataType = DYNAMIC-FUNCTION('ColumnDataType':U IN hDataSource, _U._NAME).
         ASSIGN
           _U._TYPE    = 'FILL-IN':U
           _U._SUBTYPE = 'TEXT':U.
           _F._DATA-TYPE = cColDataType.
       END.  /* if text */
     END.  /* when visualization type */
     WHEN 'Visible':U              THEN _U._HIDDEN           = NOT LOGICAL(pcValue).
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

