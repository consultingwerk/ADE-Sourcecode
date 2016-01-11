&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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

DEFINE VARIABLE cCalcFieldList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalculatedCols   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cErrorFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInheritsFromClasses AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInvalidAttrs     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListField        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDOName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmp              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdColumns       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValidateMessage  AS CHARACTER  NO-UNDO.
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
DEFINE VARIABLE lCalculatedCol    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iColX             AS INTEGER    NO-UNDO EXTENT 50.
DEFINE VARIABLE iColWidth         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iColumns          AS INTEGER    NO-UNDO  INIT 1.
DEFINE VARIABLE cLabel            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPrevColumnsWidth AS INTEGER    NO-UNDO.
DEFINE VARIABLE lFromWizard       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dNewWinWidth      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE lDbAware          AS LOGICAL    NO-UNDO.

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
         WIDTH              = 63.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER w_U FOR _U.
DEFINE BUFFER w_L FOR _L.
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER f_L FOR _L.

FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

FIND parent_U WHERE parent_U._HANDLE = _h_frame.
FIND parent_L WHERE parent_L._u-recid = RECID(parent_U) AND
                    parent_L._lo-name = "Master Layout".

hDataSource = DYNAMIC-FUNCTION('get-sdo-hdl':U IN _h_func_lib, 
                                             INPUT _P._data-object,
                                             INPUT TARGET-PROCEDURE).
hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

ASSIGN 
   cUpdColumns     = DYNAMIC-FUNCTION('getUpdatableColumns':U IN hDataSource)
   cDataSourceType = DYNAMIC-FUNCTION('getObjectType':U IN hDataSource)
   lDbAware        = DYNAMIC-FUNCTION('getDbAware':U IN hDataSource).

/* non dbaware (DataView) does not havecalculated columns */
IF lDbAware THEN
  ASSIGN
    cCalculatedCols = DYNAMIC-FUNCTION('getCalculatedColumns':U IN hDataSource)
    cCalcFieldList  = DYNAMIC-FUNCTION('getCalcFieldList':U IN hDataSource)
    NO-ERROR.

/* selectFields invokes the multi-field selector if the fields parameter is
   blank */
IF pcFields = '':U THEN 
  RUN selectFields.
ELSE cFields = pcFields.

SESSION:SET-WAIT-STATE('GENERAL':U).
/* validateColumn validates the master objects in the repository*/
RUN validateColumn IN THIS-PROCEDURE.
IF cMessageList NE '':U THEN 
DO:
   SESSION:SET-WAIT-STATE('':U).
   MESSAGE cMessageList VIEW-AS ALERT-BOX ERROR.
   SESSION:SET-WAIT-STATE('GENERAL':U).
   cMessageList = '':U.
END.
  
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
  IF lDbAware THEN
  DO:
    ASSIGN
      lCalculatedCol = LOOKUP(cListField, cCalculatedCols) > 0
      cTable         = DYNAMIC-FUNCTION('ColumnPhysicalTable':U IN hDataSource, 
                                        cListField) 
      cObjectName    = IF lCalculatedCol THEN cListField
                       ELSE DYNAMIC-FUNCTION('ColumnPhysicalColumn':U IN hDataSource, cListField)
      cObjectName    = REPLACE(cObjectName,"[","")
      cObjectName    = REPLACE(cObjectName,"]","") NO-ERROR.
  
    IF lCalculatedCol AND cCalcFieldList > '':U THEN
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
  END.
  /* non dbaware */
  ELSE DO:
    ASSIGN
      cTable      = ENTRY(1, cListField, '.':U)
      cObjectName = cListfield.
  END.
  
  /* Retrieve the master datafield from the repository */
  RUN retrieveDesignObject IN hRepDesignManager ( INPUT  cObjectName,
                                                  INPUT  "",  /* Get default result Code */
                                                  OUTPUT TABLE ttObject,
                                                  OUTPUT TABLE ttPage,
                                                  OUTPUT TABLE ttLink,
                                                  OUTPUT TABLE ttUiEvent,
                                                  OUTPUT TABLE ttObjectAttribute ) NO-ERROR.      


  /* Get the Master datafield */
  FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = cObjectName NO-ERROR.
  IF AVAIL ttObject THEN 
  DO:   
     /* If this is a calculated field in a static SDO, the field could have the same name
        as a repository object that is not a calculated fields so there is a check for this */
     IF lCalculatedCol AND 
         NOT DYNAMIC-FUNCTION('ClassIsA':U IN gshRepositoryManager, ttObject.tClassName, 'CalculatedField':U) THEN
     DO:
        MESSAGE 'The calculated field "':U + cObjectName + '" has the same name as ':U
                + 'another repository object.  Please rename the calculated field in the data source.':U
                VIEW-AS ALERT-BOX ERROR.
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
       NEXT FieldLoop. 
     END.  /* if cMessage not blank */

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
       _U._NAME          = IF NUM-ENTRIES(cListField, '.':U) > 1
                           THEN ENTRY(2,cListField,".") 
                           ELSE cListField /* remove qualifier */
       _U._DBNAME        = 'Temp-Tables':U
       _U._TABLE         = IF cDataSourceType = 'SmartBusinessObject':U 
                           THEN cSDOName 
                           ELSE cTable
       _U._BUFFER        = IF cDataSourceType = 'SmartBusinessObject':U 
                              OR NOT lDbAware 
                           THEN cTable
                           ELSE 'RowObject':U
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

     /* If next field is to be positioned on row greater than frame height,
        reset row to starting row and increment Column counter */
     IF VALID-HANDLE(PARENT_U._HANDLE) 
                 AND _L._ROW + _L._HEIGHT > PARENT_U._HANDLE:HEIGHT THEN
        ASSIGN dRow               =  1.0 + (_frmy / SESSION:PIXELS-PER-ROW)
               _L._ROW            = dRow
               iColumns           = MIN(iColumns + 1,Extent(iColX))
               iPrevColumnsWidth  = iColWidth + iColX[iColumns - 1] + 3 /* 3 pixel spacing */
               iColWidth          = 0.

    /* Calculate the length of each label and get the largest one so as to align
       each column. Also get the largest width field so as to calculate the next column position  */
     ASSIGN cLabel          =  _U._LABEL + ':  ':U
            iColX[iColumns] = MAX(iColX[iColumns]
                                  ,_frmx
                                  ,(IF parent_L._FONT <> ? 
                                    THEN FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLabel, parent_L._FONT) + iPrevColumnsWidth
                                    ELSE FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLabel) + iPrevColumnsWidth))
            iColWidth        = MAX(iColWidth,(_L._WIDTH * SESSION:PIXELS-PER-COL) )
            _U._PRIVATE-DATA = _U._PRIVATE-DATA + CHR(4) + STRING(iColumns).
      
     /* Create multiple layout records if necessary */
     {adeuib/crt_mult.i}

     dRow = dRow + _L._HEIGHT.
   END.  /* if ttObject avail */      
END.  /* do iFieldNum to number fields picked */

IF cMessageList NE '':U THEN 
DO:
   SESSION:SET-WAIT-STATE('':U).
   MESSAGE cMessageList VIEW-AS ALERT-BOX ERROR.
   SESSION:SET-WAIT-STATE('GENERAL':U).
END.

/* The frame resizing only occurs if the wizard is used to create a dynviewer */
ASSIGN lFromWizard = (_second_corner_X =  parent_U._HANDLE:WIDTH-P).

/* Need to find the handles of the frame and window so their size can be increased if necessary */
IF lFromWizard THEN
DO:
  FIND w_U WHERE w_U._handle = _h_win.       /* Get the window _U */
  FIND w_L WHERE w_L._u-recid = RECID(w_U).  /* Get window _L     */
  FIND f_U WHERE f_U._handle = _h_win.       /* Get the frame _U  */
  FIND f_L WHERE f_L._u-recid = RECID(w_U).  /* Get frame _L      */
END.

FOR EACH _U WHERE _U._PARENT = parent_U._HANDLE:
   FOR EACH _L WHERE _L._u-recid eq RECID(_U) :
     /* Store the column position in the private-data, then remove it */
     ASSIGN iColumns         = 1
            iColumns         = INTEGER(ENTRY(2,_U._PRIVATE-DATA,CHR(4))) 
            _U._PRIVATE-DATA = ENTRY(1,_U._PRIVATE-DATA,CHR(4))
            NO-ERROR.
     ASSIGN _L._COL      = 1.0 + (iColX[iColumns] / SESSION:PIXELS-PER-COL)
            dNewWinWidth =  MIN(_L._COL + _L._WIDTH,SESSION:WIDTH-CHARS) .
     
     /* Only resize window if called from wizard not if fields are dropped onto frame */
     IF lFromWizard AND dNewWinWidth > PARENT_U._HANDLE:WIDTH THEN
        ASSIGN _h_win:WIDTH            = dNewWinWidth
               PARENT_U._HANDLE:WIDTH  = dNewWinWidth
               w_L._WIDTH              = dNewWinWidth
               w_L._VIRTUAL-WIDTH      = MAX(w_L._VIRTUAL-WIDTH,dNewWinWidth)
               f_L._WIDTH              = dNewWinWidth
               f_L._VIRTUAL-WIDTH      = MAX(f_L._VIRTUAL-WIDTH, dNewWinWidth). 

   END. /* End For Each _L */
   /* Instantiate the field in the design window */
   CASE _U._TYPE:
       WHEN 'FILL-IN':U OR WHEN 'TEXT':U THEN RUN adeuib/_undfill.p (RECID(_U)).
       WHEN 'COMBO-BOX':U      THEN RUN adeuib/_undcomb.p (RECID(_U)).
       WHEN 'EDITOR':U         THEN RUN adeuib/_undedit.p (RECID(_U)).
       WHEN 'RADIO-SET':U      THEN RUN adeuib/_undradi.p (RECID(_U)).
       WHEN 'SELECTION-LIST':U THEN RUN adeuib/_undsele.p (RECID(_U)).
       WHEN 'TOGGLE-BOX':U     THEN RUN adeuib/_undtogg.p (RECID(_U)).
   END CASE.
END.

RUN adeuib/_tabordr.p (INPUT 'NORMAL':U, INPUT RECID(parent_U)).
DYNAMIC-FUNCTION('shutdown-sdo':U IN _h_func_lib, INPUT TARGET-PROCEDURE).

SESSION:SET-WAIT-STATE('':U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-selectFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectFields Procedure 
PROCEDURE selectFields :
/*------------------------------------------------------------------------------
  Purpose:     Invoke the multi-field selector for the user to choose fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExcludeFields   AS CHARACTER  NO-UNDO.

DEFINE BUFFER fld_U FOR _U.
DEFINE BUFFER x_S FOR _S.

FOR EACH fld_U WHERE fld_U._PARENT-Recid = RECID(parent_U) AND 
                     fld_U._STATUS <> "DELETED":U NO-LOCK:
        IF fld_U._subtype = "SmartDataField":U THEN 
        DO:
           FIND x_S WHERE RECID(x_S) = fld_U._x-recid. 
           If dynamic-function('getLocalField' IN X_S._HANDLE) = FALSE then 
           Do:
             cFieldName = dynamic-function('getFieldName' IN X_S._HANDLE).
             ASSIGN cExcludeFields = cExcludeFields + cFieldName + ',' NO-ERROR.
           End. 
        END.
        ELSE IF fld_U._BUFFER = "RowObject":U OR fld_U._TABLE = "RowObject":U THEN
           ASSIGN cExcludeFields = cExcludeFields + fld_U._NAME + ",":U.
        ELSE IF fld_U._TABLE > '' THEN
           ASSIGN cExcludeFields = cExcludeFields + fld_U._TABLE + ".":U +
                                                 fld_U._NAME + ",":U.
    END.

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
             _F._SOURCE-DATA-TYPE = 'CLOB':U
             _U._TYPE             = 'EDITOR':U.
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

&IF DEFINED(EXCLUDE-validateColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateColumn Procedure 
PROCEDURE validateColumn :
/*------------------------------------------------------------------------------
  Purpose:     Validates all fields
                
  Parameters:  <none>
  Notes:       The is the first time the datafield master object read from
               from the repository, if a master object does not exist, that
               field is not added to the viewer.
------------------------------------------------------------------------------*/
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
  IF lDbAware THEN
  DO:
    lCalculatedCol = LOOKUP(cListField, cCalculatedCols) > 0. 
    cObjectName = IF lCalculatedCol 
                  THEN cListField 
                  ELSE DYNAMIC-FUNCTION('columnPhysicalColumn':U IN hDataSource, cListField).

    ASSIGN cObjectName = REPLACE(cObjectName,"[","")
           cObjectName = REPLACE(cObjectName,"]","").

    IF lCalculatedCol AND cCalcFieldList NE '':U THEN
      cObjectName = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                      INPUT cObjectName,             
                                      INPUT cCalcFieldList,         
                                      INPUT TRUE,                   
                                      INPUT ",":U).

    /*   If calculated field and data source is an SBO, the name will have the 
          SDO as a prefix as in <sdoName>.<FieldName>.  */
    IF lCalculatedCol AND cDataSourceType = 'SmartBusinessObject':U AND NUM-ENTRIES(cObjectName, '.':U) > 1 THEN
      ASSIGN cObjectName = ENTRY(2,cObjectName,".":U) NO-ERROR.
  END.
  ElSE
    cObjectname = cListField.

  lObjectExists = DYNAMIC-FUNCTION('ObjectExists':U IN hRepDesignManager, INPUT cObjectName).
  
  IF NOT lObjectExists THEN
  DO:
    cMessageList = cMessageList + (IF cMessageList NE '':U THEN CHR(10) + CHR(10) ELSE '':U) + 
                   IF lCalculatedCol 
                   THEN 'The calculated field "':U + cObjectName + '" has no master object in the repository. ':U + CHR(10) + 
                        'Please add a calculated field master object called "':U + cObjectName + '" to an entity of the data source using the Entity Control. ':U
                   ELSE 'The datafield "':U + cObjectName + '" has no master object in the repository. ':U + CHR(10) + 
                        'Please use ' + (IF NOT lDbAware THEN 'TEMP-DB Maintenenace ' ELSE '') +
                        'Entity Import to import it or add it using the Entity Control.':U.
                            
    ASSIGN cErrorFields = cErrorFields + (IF NUM-ENTRIES(cErrorFields) > 0 THEN ',':U ELSE '':U) +
                          cListField.
    NEXT FieldLoop.
  END.  /* if object doesn't exist */

END.  /* do iFieldNum to number fields picked */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

