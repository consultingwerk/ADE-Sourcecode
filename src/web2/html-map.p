&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 - ADM2
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000,2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : html-map.p
    Purpose     : Super procedure to web2/html-map.i.  Contains all
                  the procedures formerly in web/method/html-map.i.

    Syntax      :
    Description :
    Author(s)   : D.M.Adams
    Created     : March, 1998
    Notes       :
    Modified    : April 5, 1999  
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* Tell web2/admweb.i that this is the Super Procedure */
&SCOPED-DEFINE ADMSuper html-map.p

{src/web2/htmoff.i NEW}

DEFINE VARIABLE hDataSource  AS HANDLE NO-UNDO.
DEFINE VARIABLE cCharType    AS CHARACTER NO-UNDO.

DEFINE STREAM InStream.

{src/web2/custom/html-mapexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcTableName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHTMLName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHTMLName Procedure 
FUNCTION columnHTMLName RETURNS CHARACTER
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 14.76
         WIDTH              = 60.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}
{src/web/method/tagmap.i}
{src/web2/htmlprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFields Procedure 
PROCEDURE assignFields :
/*------------------------------------------------------------------------------
  Purpose:    Assigns the current form buffer values in the enabled fields/
              objects to the SmartDataObject, the database, and/or to local 
              object variables.
  Parameters: <none>
  Notes:      Commonly used in process-web-request procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnabledFieldHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjectHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledTables        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledFields        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowObjId             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColString            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFieldHandle          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hbFieldHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTableHandle          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lAddMode              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ix                    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDbTable              AS CHAR      NO-UNDO.
  DEFINE VARIABLE hQuery                AS HANDLE    NO-UNDO.

  {get EnabledFieldHandles cEnabledFieldHandles}.
  {get EnabledObjectHandles cEnabledObjectHandles}.
  {get EnabledTables cEnabledTables}.
  {get EnabledFields cEnabledFields}.
  {get DataSource hDataSource}.
      
  DO ix = 1 TO NUM-ENTRIES(cEnabledObjectHandles):
    ASSIGN
      hFieldHandle = WIDGET-HANDLE(ENTRY(ix,cEnabledObjectHandles))
      hTableHandle = WIDGET-HANDLE(ENTRY(LOOKUP(hFieldHandle:TABLE,
                     cEnabledTables) + 1, cEnabledTables))
      hbFieldHandle = hTableHandle:BUFFER-FIELD(hFieldHandle:NAME) NO-ERROR.
      
    IF VALID-HANDLE(hTableHandle) AND hTableHandle:AVAILABLE THEN
       ASSIGN hbFieldHandle:BUFFER-VALUE = hFieldHandle:SCREEN-VALUE NO-ERROR.
  END. /* DO ix = 1 TO NUM-ENTRIES(cEnabledObjectHandles): */
   
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get AddMode lAddMode}.
    IF lAddMode THEN 
        cRowObjId = 
          ENTRY(1,dynamic-function("addRow":U IN hDataSource,"":U),CHR(1)). 
    ELSE 
        cRowObjId = 
          ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("colValues":U IN hDataSource,"":U),
                  chr(1))).
    
    DO ix = 1 TO NUM-ENTRIES(cEnabledFieldHandles):
      ASSIGN
        hFieldHandle = WIDGET-HANDLE(ENTRY(ix,cEnabledFieldHandles))
        hTableHandle = WIDGET-HANDLE(ENTRY(LOOKUP(hFieldHandle:TABLE,
                         cEnabledTables) + 1, cEnabledTables)) 
        hbFieldHandle = hTableHandle:BUFFER-FIELD(hFieldHandle:NAME)
        cColString = cColString  
                       + (IF cColString = "":U THEN "":U ELSE CHR(1)) 
                       + hFieldHandle:NAME + CHR(1) + hFieldHandle:SCREEN-VALUE
       NO-ERROR.
    END. /* do ix = 1 to num-entries() */ 
          
    DYNAMIC-FUNCTION("submitRow":U IN hDataSource,cRowObjId,cColString).

    IF {fn anyMessage} AND lAddMode THEN  /* 99-03-30-046 */
       DYNAMIC-FUNCTION('cancelRow':U IN hDataSource).

  END. /* if valid-handle(hDataSource)*/
  ELSE DO: 
    {get QueryHandle hQuery}.
    DO TRANSACTION:
      IF DYNAMIC-FUNCTION('LockRow':U IN TARGET-PROCEDURE,"EXCLUSIVE":U) THEN        
      DO ix = 1 TO NUM-ENTRIES(cEnabledFieldHandles):        
        ASSIGN
          hFieldHandle = WIDGET-HANDLE(ENTRY(ix,cEnabledFieldHandles))
          cDbTable     = {fnarg columnTable ENTRY(ix,cEnabledFields)}
          hTableHandle = WIDGET-HANDLE(ENTRY(LOOKUP(cDbTable,cEnabledTables) + 1,
                                       cEnabledTables))
          hbFieldHandle = hTableHandle:BUFFER-FIELD(hFieldHandle:NAME) NO-ERROR.
        IF hTableHandle:AVAILABLE THEN
        DO:
          ASSIGN hbFieldHandle:BUFFER-VALUE(hFieldHandle:INDEX) = hFieldHandle:SCREEN-VALUE NO-ERROR.
          IF ERROR-STATUS:ERROR THEN 
          DO:
            RUN AddMessage IN TARGET-PROCEDURE(?, hFieldHandle:name, ?).           
            UNDO,LEAVE.
          END. /* if error status:error */
        END. /* if htablehandle available */ 
      END. /* do ix = 1 to num-entries(cEnabledfieldshandles) */
    END. /* else do TRANSACTION */
    DYNAMIC-FUNCTION('LockRow':U IN TARGET-PROCEDURE,"NO-LOCK":U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject Procedure 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:    Run from adm-create-objects to run a SmartObject and to 
              establish its parent and initial property settings.
  Parameters (INPUT):  
              pcProcName (CHAR)   - procedure name to run
              phParent   (HANDLE) - NOT used 
              pcPropList (CHAR)   - property list to set
  Parameters (OUTPUT):  
              phObject   (HANDLE) - new procedure handle
  Note:       This is used only to 1) start the SmartDataObject that is the 
              dataSource and 2) set the instance properties.                 
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER  pcProcName   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER  phParent     AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER  pcPropList   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject      AS HANDLE    NO-UNDO.

  DEFINE VARIABLE         iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE         cEntry        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cProperty     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cSignature    AS CHARACTER NO-UNDO.
  
  IF NUM-ENTRIES(pcProcName, CHR(3)) > 1 THEN 
    /* Strip of the DB-AWARE parameter  */
    ASSIGN pcProcName = ENTRY(1, pcProcName, CHR(3)).
   
  /* Store the AppService property in this object to be able to use it 
     in startDataObject to decide which object to start or reuse */     
  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry    = ENTRY(iEntry, pcPropList, CHR(3)).
    cProperty = ENTRY(1, cEntry, CHR(4)).    
    IF cProperty = "AppService":U THEN 
    DO:      
      cValue = ENTRY(2, cEntry, CHR(4)).  
      {set AppService cValue}.
      LEAVE. 
    END.
  END.
    
  {fnarg startDataObject pcProcName}.
  {get DataSource phObject}. 
  
  IF NOT VALID-HANDLE (phObject) THEN RETURN ERROR.  

    /* Set any Instance Properties specified. The list is in the same format
     as returned to the function instancePropertyList, with CHR(3) between
     entries and CHR(4) between the property name and its value in each entry. 
     NOTE: we must get the datatype for each property in order to set it. */
  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry = ENTRY(iEntry, pcPropList, CHR(3)).
    cProperty = ENTRY(1, cEntry, CHR(4)).
    
    IF cProperty = "AppService":U THEN NEXT. /* this is done above */
     
    cValue = ENTRY(2, cEntry, CHR(4)).
    /* Get the datatype from the return type of the get function. */
    cSignature = dynamic-function
      ("Signature":U IN phObject, "get":U + cProperty).

    IF cSignature EQ "":U THEN    /* Blank means it wasn't found anywhere */
      dynamic-function('showMessage':U,
       "Property ":U  + cProperty + " not defined.":U). 
    ELSE CASE ENTRY(2,cSignature):
      WHEN "INTEGER":U THEN
        dynamic-function("set":U + cProperty IN phObject, INT(cValue)).
      WHEN "DECIMAL":U THEN
        dynamic-function("set":U + cProperty IN phObject, DEC(cValue)).
      WHEN "CHARACTER":U THEN
        dynamic-function("set":U + cProperty IN phObject, cValue).
      WHEN "LOGICAL":U THEN
        dynamic-function("set":U + cProperty IN phObject,
          IF cValue = "yes":U THEN yes ELSE no).
    END CASE.
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose: Override dataAvailable      
  Parameters:  pcMode  - See query.p 
  Notes:      This is a workaround to avoid running query.p logic when 
              this object uses a data-source. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMode AS CHAR NO-UNDO.

  DEFINE VARIABLE hDataSourc AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF NOT VALID-HANDLE(hDataSource) THEN
      RUN SUPER(pcMode).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteOffsets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteOffsets Procedure 
PROCEDURE deleteOffsets :
/*------------------------------------------------------------------------------
  Purpose:    Deletes all HTML tag field offset temp-table records for a HTML 
              Mapping procedure.
  Parameters: <none>
  Notes:      Internal use only.
------------------------------------------------------------------------------*/
  DEFINE BUFFER htmoff-delete FOR htmoff.

  FOR EACH htmoff-delete WHERE htmoff-delete.proc-id = TARGET-PROCEDURE:
    DELETE htmoff-delete.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatchUtilityProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispatchUtilityProc Procedure 
PROCEDURE dispatchUtilityProc :
/*------------------------------------------------------------------------------
  Purpose:    Call the standard utility procedure, as defined in tagmap.dat, 
              for the current Web object.
  Parameters (INPUT):
              p_method       (CHAR)   - method procedure to run in the utility 
                                        procedure (WEB.INPUT, WEB.OUTPUT)
              p_field-hdl    (HANDLE) - Progress object handle
              p_field-data   (CHAR)   - data to send to the procedure
              p_item-counter (INT)    - radio-set item to process
    
  Parameters (OUTPUT):
              p_result       (LOG)    - indicates method ran successfully
  Notes:      Internal use only.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_method        AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_field-hdl     AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_field-data    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_item-counter  AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER p_proc-id       AS HANDLE    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_result        AS LOGICAL   NO-UNDO.

  DEFINE BUFFER htmoff-disp FOR htmoff.

  /* Note: htmoff-disp.ITEM-CNT will be 0 for all non-radio-sets */
  FIND FIRST htmoff-disp WHERE htmoff-disp.proc-id = p_proc-id
    AND htmoff-disp.HANDLE   = p_field-hdl
    AND htmoff-disp.ITEM-CNT = p_item-counter NO-ERROR.

  IF AVAILABLE htmoff-disp THEN DO:
    /* Get the TAGMAP record. */
    FIND FIRST tagmap WHERE tagmap.htm-Tag  = htmoff-disp.HTM-TAG 
                        AND tagmap.htm-Type = htmoff-disp.HTM-TYPE NO-ERROR.

    IF NOT AVAILABLE (tagmap) THEN
      FIND FIRST tagmap WHERE tagmap.htm-Tag EQ htmoff-disp.HTM-TAG 
                        USE-INDEX i-order NO-ERROR.  
    /* If a TAG is not found, this is a "serious" error, so report it. */
    IF NOT AVAILABLE (tagmap) THEN
      RUN HtmlError IN web-utilities-hdl 
        (SUBSTITUTE ('HTML tag mapping procedure for tag &1&2 not found.',
                     htmoff-disp.HTM-TAG,
                     IF htmoff-disp.HTM-TYPE ne '':U 
                       THEN ' (TYPE = ':U + htmoff-disp.HTM-TYPE + ')':U
                       ELSE '':U) + htmoff-disp.HANDLE:NAME).
    ELSE DO: 
      /* Is there a TAGMAP utility procedure? */
      IF VALID-HANDLE (tagmap.util-Proc-Hdl) THEN DO:
        IF htmoff-disp.WDT-TYPE = "radio-set":U 
          AND p_method = "web.output":U THEN
          RUN VALUE(p_method) IN tagmap.util-Proc-Hdl
            (htmoff-disp.HANDLE, p_field-data, p_item-counter) NO-ERROR.
        ELSE
          RUN VALUE(p_method) IN tagmap.util-Proc-Hdl
            (htmoff-disp.HANDLE, p_field-data) NO-ERROR.

        IF NOT ERROR-STATUS:ERROR THEN p_result = yes.

      END.
    END. /* IF AVAIL...tagmap */
  END. /* IF AVAIL...htmoff-disp */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:    Copies SmartDataObject or database values to the displayed 
              object and field form buffer screen values.
  Parameters: <none>
  Notes:      Commonly used in process-web-request procedure.  Will display 
              initial values of the data-source if UpdateMode is set to TRUE. 
              If the source is an SDO this will include the value of the 
              ForeignField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldPosition          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cUpdateMode             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbTable                AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedDataFields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFields        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFieldHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedObjects       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedObjectHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedTables        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFieldHandle            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hbFieldHandle           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTableHandle            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE ix                      AS INTEGER   NO-UNDO.

  {get DisplayedDataFields cDisplayedDataFields}.
  {get DisplayedFields cDisplayedFields}.
  {get DisplayedFieldHandles cDisplayedFieldHandles}.
  {get DisplayedObjects cDisplayedObjects}.
  {get DisplayedObjectHandles cDisplayedObjectHandles}.
  {get DisplayedTables cDisplayedTables}.
  {get DataSource hDataSource}.
  {get UpdateMode cUpdateMode}.

  IF VALID-HANDLE(hDataSource) THEN 
  DO:
    IF cUpdateMode = "ADD":U THEN
      cColValues = DYNAMIC-FUNCTION("addRow":U IN hDataSource, 
                     cDisplayedDataFields).
    ELSE
      cColValues = DYNAMIC-FUNCTION("colValues":U IN hDataSource, 
                     cDisplayedDataFields).
    
    DO ix = 1 TO NUM-ENTRIES(cDisplayedDataFields):
      ASSIGN
        cFieldName                = "RowObject.":U + 
                                    ENTRY(ix,cDisplayedDataFields)
        cFieldPosition            = LOOKUP(cFieldName,cDisplayedFields)
        hFieldHandle              = WIDGET-HANDLE(ENTRY(cFieldPosition,
                                      cDisplayedFieldHandles))
        hFieldHandle:SCREEN-VALUE = ENTRY(ix + 1,cColValues,CHR(1)).
    END. /* do ix = 1 to num-entries(cDisplayedDataFields) */ 
    
    /* Turn off the addmode in the data-source */
    IF cUpdateMode = "ADD":U THEN
      DYNAMIC-FUNCTION("cancelRow":U IN hDataSource).
  END. /* if valid-handle(hDatasource) */
  ELSE 
  DO:
    IF cDisplayedTables <> "":U THEN 
    DO:
      /* Unmapped fields */
      DO ix = 1 TO NUM-ENTRIES(cDisplayedObjectHandles):
        ASSIGN
          hFieldHandle  = WIDGET-HANDLE(ENTRY(ix,cDisplayedObjectHandles))

          hTableHandle  = WIDGET-HANDLE(ENTRY(LOOKUP(hFieldHandle:TABLE,
                          cDisplayedTables) + 1, cDisplayedTables))
          hbFieldHandle = hTableHandle:BUFFER-FIELD(hFieldHandle:NAME) NO-ERROR.
        
        IF VALID-HANDLE(hTableHandle) AND hTableHandle:AVAILABLE THEN DO:
          IF hFieldHandle:TYPE = "toggle-box":U THEN
            hFieldHandle:CHECKED = (hbFieldHandle:BUFFER-VALUE = yes).
          ELSE
            hFieldHandle:SCREEN-VALUE = hbFieldHandle:BUFFER-VALUE.
        END.
      END. /* do ix = 1 to num-entries(cDisplayedObjectHandles) */
      
      {get QueryHandle hQuery}.

      /* Mapped fields */
      DO ix = 1 TO NUM-ENTRIES(cDisplayedFieldHandles):
        ASSIGN
          hFieldHandle  = WIDGET-HANDLE(ENTRY(ix,cDisplayedFieldHandles))
          cDbTable      = {fnarg columnTable ENTRY(ix,cDisplayedFields)}                          
          hTableHandle  = WIDGET-HANDLE(
                            ENTRY(LOOKUP(cDbTable,cDisplayedTables) + 1,
                                         cDisplayedTables))
          hbFieldHandle = hTableHandle:BUFFER-FIELD(hFieldHandle:NAME) NO-ERROR.
        IF hTableHandle:AVAILABLE THEN
        DO:
          IF cUpdateMode = "ADD":U THEN
            hFieldHandle:SCREEN-VALUE = hbFieldHandle:INITIAL.
          ELSE DO:
            IF hFieldHandle:TYPE = "toggle-box":U THEN
              hFieldHandle:CHECKED = 
                (hbFieldHandle:BUFFER-VALUE(hFieldHandle:INDEX) = yes).
            ELSE
              hFieldHandle:SCREEN-VALUE = 
                hbFieldHandle:BUFFER-VALUE(hFieldHandle:INDEX).
          END.
        END.
      END. /*  do ix = 1 to num-entries(cDisplayedFieldHandles) */
    END. /* if cDisplayedTables <> "":u then */
  END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:    Enables object and field form buffer widgets by setting their 
              SENSITIVE attribute to TRUE.
  Parameters: <none>
  Notes:      Commonly used in process-web-request procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnabledFieldHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjectHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFieldHandle          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE ix                    AS INTEGER   NO-UNDO.
  
  {get EnabledFieldHandles cEnabledFieldHandles}.
  {get EnabledObjectHandles cEnabledObjectHandles}.
  DO ix = 1 TO NUM-ENTRIES(cEnabledObjectHandles):
    ASSIGN
      hFieldHandle = WIDGET-HANDLE(ENTRY(ix,cEnabledObjectHandles))
      hFieldHandle:SENSITIVE = TRUE.
      
  END. /* do ix = 1 to num-entries(cEnabledObjectHandles) */

  DO ix = 1 TO NUM-ENTRIES(cEnabledFieldHandles):
    ASSIGN
      hFieldHandle = WIDGET-HANDLE(ENTRY(ix,cEnabledFieldHandles))
      hFieldHandle:SENSITIVE = TRUE.
      
  END. /* do ix = 1 to num-entries(cEnabledFieldHandles) */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRecords Procedure 
PROCEDURE findRecords :
/*------------------------------------------------------------------------------
  Purpose:    Opens the SmartDataObject or database query that finds the 
              records in this frame.
  Parameters: <none>
  Notes:      Commonly used in process-web-request procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedDataFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryWhere            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryTables           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hWebQuery              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lReturn                AS LOGICAL   NO-UNDO.
 
  {get DataSource hDataSource}.
     
  IF VALID-HANDLE(hDataSource) THEN 
    {fn Openquery hDataSource}.
    
  ELSE
  DO: 
    {get QueryHandle hWebQuery}.
    IF VALID-HANDLE(hWebQuery) THEN  
    DO:
      lReturn = {fn OpenQuery}.   
      IF NOT lReturn OR ERROR-STATUS:ERROR THEN DO:
        RUN AddError ("The query could not be opened.",?,?).
        RETURN.
      END.
    END.
  END. /* if not valid hdataSource */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextHtmlField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextHtmlField Procedure 
PROCEDURE getNextHtmlField :
/*------------------------------------------------------------------------------
  Purpose:    Reads the HTML file a line at a time, sending each line to the
              WEBSTREAM, up to the next HTML field definition.
              
  Parameters (INPUT-OUTPUT):  
              next-line         (CHAR) - full text of current line 
              line-no           (INT)  - line position counter
              start-line-no     (INT)  - beginning field definition line
              start-line-offset (INT)  - beginning field definition column
              end-line-no       (INT)  - ending field definition line
              end-line-offset   (INT)  - ending field definition column
              field-def         (CHAR) - field definition between "<" and ">"
              clip-bytes        (INT)  - chars on line already processed 
  Notes:      Internal use only.  The field definition is extracted from the 
              [row, column] offsets [start-line-no, start-line-offset] to 
              [end-line-no, end-line-offset] and returned.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER next-line         AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER line-no           AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER start-line-no     AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER start-line-offset AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER end-line-no       AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER end-line-offset   AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER field-def         AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER clip-bytes        AS INTEGER   NO-UNDO.

  DEFINE VARIABLE org-line-len AS INTEGER   NO-UNDO. /* original HTML line length */
  DEFINE VARIABLE last-line    AS CHARACTER NO-UNDO. /* last line read */
  DEFINE VARIABLE num-lines    AS INTEGER   NO-UNDO. /* # lines in field definition */
 
  /* Go through file until we get in the vicinity of the next seek offset. */
  REPEAT WHILE line-no < start-line-no:
    ASSIGN last-line = next-line.
    IMPORT STREAM instream UNFORMATTED next-line.
    ASSIGN
      clip-bytes   = 0
      line-no      = line-no + 1.
  
    {&OUT} last-line + CHR(10).
  END.

  /* Adjust the starting byte offset to account for any preceding text we
     may have already 'stripped' off and sent to the web. */
  ASSIGN
    org-line-len      = LENGTH(next-line,cCharType)
    start-line-offset = start-line-offset - clip-bytes.

  /* We read up to start-seek-offset and then some */
  IF (org-line-len > start-line-offset AND start-line-offset > 1) THEN DO:
    /* Number of bytes in the string to the left of the start of the field
       definition that should be passed along to the output stream.  This
       should be cumulative if more than one field exists on a line. */
    ASSIGN 
      clip-bytes = clip-bytes + start-line-offset - 1.
  
    IF clip-bytes > 0 THEN DO:
      {&OUT} SUBSTRING(next-line,1,start-line-offset - 1,cCharType).  
      ASSIGN 
        next-line    = SUBSTRING(next-line,start-line-offset,-1,cCharType)
        org-line-len = LENGTH(next-line,cCharType).
    END.
  END.
  
  ASSIGN field-def = next-line.
 
  REPEAT WHILE line-no < end-line-no:
    IMPORT STREAM instream UNFORMATTED next-line.
  
    ASSIGN
      line-no      = line-no + 1
      clip-bytes   = 0
      org-line-len = LENGTH(next-line,cCharType)

      /* If we're looking at the last line of a multi-line field definition, only 
         add that part that pertains to this field, otherwise add the whole line. */
      field-def    = field-def + CHR(10) + 
        (IF line-no < end-line-no THEN next-line ELSE
         SUBSTRING(next-line,1,end-line-offset,cCharType)).
  END.

  /* Adjust the ending byte offset to account for any preceding text we
     may have already 'stripped' off and sent to the web. */
  ASSIGN
    num-lines       = NUM-ENTRIES(field-def,CHR(10))
    end-line-offset = end-line-offset - clip-bytes.

  IF (org-line-len > end-line-offset) AND num-lines = 1 THEN
    ASSIGN
      field-def = SUBSTRING(field-def,1,end-line-offset,cCharType).

  /* Adjust clip-bytes to account for the last line of the field-def we're sending 
     to the web */ 
  ASSIGN clip-bytes = clip-bytes + 
    LENGTH(ENTRY(num-lines,field-def,CHR(10)),cCharType).

  IF (org-line-len - end-line-offset >= 0) THEN
    ASSIGN next-line = SUBSTRING(next-line,end-line-offset + 1,-1,cCharType).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmAssociate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmAssociate Procedure 
PROCEDURE htmAssociate :
/*------------------------------------------------------------------------------
  Purpose:    Maps HTML fields to their Web object widget counterparts.
  Parameters (INPUT):
              htmField  (CHAR)   - HTML field name
              wdtField  (CHAR)   - Web object field name
              widHandle (HANDLE) - Web object field handle
  Notes:      Internal use only.  The essential HTML "mapping" procedure.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER htmField  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER wdtField  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER widHandle AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE found AS LOGICAL NO-UNDO.

  DEFINE BUFFER htmoff-assoc FOR htmoff.
  
  /* Previously a FIND FIRST, this FOR EACH will only find one record per
     htmField, EXCEPT for radio-sets.  In this case, one htmoff-assoc record 
     will exist for each radio-item.
  */
  FOR EACH htmoff-assoc WHERE htmoff-assoc.proc-id  = TARGET-PROCEDURE
                          AND htmoff-assoc.HTM-NAME = htmField:
    /* Check to see if the datatype has changed.  If so, raise error.  For
       radio-sets, this will abort on the first radio-item. */
    IF htmoff-assoc.WDT-TYPE <> widHandle:TYPE THEN DO:
      RUN HtmlError IN web-utilities-hdl 
        (SUBSTITUTE("For the field &1, the HTML datatype (&2) does not match the Web object datatype (&3).", 
                     wdtField, htmoff-assoc.WDT-TYPE, widHandle:TYPE)).
      RETURN.
    END.
    
    ASSIGN
      htmoff-assoc.WDT-NAME = wdtField
      htmoff-assoc.HANDLE   = widHandle
      found                 = TRUE.
  END.
  IF NOT found THEN DO: /* ERROR: HTML field deleted since Web object updated */
    RUN HtmlError IN web-utilities-hdl 
      (SUBSTITUTE("The '&1' field was found in the Web object, but missing from the offset file.", 
                   wdtField)).
    RETURN.
  END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:    Sets the list of displayed and enabled objects/fields.
  Parameters: <none>
  Notes:      Internal use only.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cContainerHandle         AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cDisplayedFields         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFieldHandles   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedObjects        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedObjectHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledDataFields       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledFieldHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjects          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledObjectHandles    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldHandles            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLockedObject            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cWidgetList              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryWhere              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFrameField              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFound                   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lUseDb                   AS LOGICAL   NO-UNDO.
   
  /* the query is opened in findRecords, so skip this */
  {set OpenOnInit FALSE}.
  RUN SUPER. 
  {set ObjectHidden no}.
    /* Load .htm field offset table. */
  RUN htmoffsets IN TARGET-PROCEDURE NO-ERROR.
  
  {get ContainerHandle cContainerHandle}.
  {get DisplayedFields cDisplayedFields}.
  {get DisplayedObjects cDisplayedObjects}.
  {get EnabledDataFields cEnabledDataFields}.
  {get EnabledFields cEnabledFields}. 
  {get EnabledObjects cEnabledObjects}.

  ASSIGN
    cWidgetList = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,":U +
                  "SELECTION-LIST,SLIDER,TOGGLE-BOX,TEXT":U
    hFrameField = WIDGET-HANDLE(cContainerHandle) /* Frame */
    hFrameField = hFrameField:FIRST-CHILD         /* Field group */
    hFrameField = hFrameField:FIRST-CHILD         /* First field */
    lUseDB      = NUM-ENTRIES(ENTRY(1,cDisplayedFields),".":U) = 3. 

  DO WHILE VALID-HANDLE(hFrameField):
    /* Clear widget screen-values (in form buffer) -- this should be 
       unnecessary if you haven't done a display. */
    IF CAN-SET(hFrameField, "SCREEN-VALUE":U) THEN
      ASSIGN hFrameField:SCREEN-VALUE = "":U NO-ERROR.
    
    IF CAN-DO(cWidgetList,hFrameField:TYPE) THEN DO:
      cFieldName = 
          ((IF NOT lUseDb OR hFrameField:DBNAME = ? 
            THEN "":U
            ELSE hFrameField:DBNAME + ".":U)
            + (IF hFrameField:TABLE = ? 
               THEN "":U 
               ELSE hFrameField:TABLE + ".":U)
            + hFrameField:NAME
           )
           + (IF hFrameField:INDEX <> 0 
              THEN "[":U + STRING(hFrameField:INDEX) + "]":U 
              ELSE "":U).
          
      /* Build list of displayed object handles */
      IF CAN-DO(cDisplayedObjects,cFieldName) THEN
        cDisplayedObjectHandles = cDisplayedObjectHandles + 
          (IF cDisplayedObjectHandles NE "":U THEN ",":U ELSE "") + 
          STRING(hFrameField).
        
      /* Build list of SDO field handles */
      IF CAN-DO(cEnabledDataFields,hFrameField:NAME) AND
        hFrameField:TABLE = "RowObject":U THEN
        cFieldHandles = cFieldHandles + 
          (IF cFieldHandles NE "":U THEN ",":U ELSE "") + 
          STRING(hFrameField).          
          
      /* Build list of enabled object handles */
      IF CAN-DO(cEnabledObjects,cFieldName) THEN
        cEnabledObjectHandles = cEnabledObjectHandles + 
          (IF cEnabledObjectHandles NE "":U THEN ",":U ELSE "") + 
          STRING(hFrameField).
          
      /* Build list of displayed field handles */
      IF CAN-DO(cDisplayedFields,cFieldName) THEN
        cDisplayedFieldHandles = cDisplayedFieldHandles +
          (IF cDisplayedFieldHandles NE "":U THEN ",":U ELSE "") +
          STRING(hFrameField).
          
      /* Build list of enabled field handles */
      IF CAN-DO(cEnabledFields,cFieldName) THEN
        cEnabledFieldHandles = cEnabledFieldHandles +
          (IF cEnabledFieldHandles NE "":U THEN ",":U ELSE "") +
          STRING(hFrameField).
    END. 
    hFrameField = hFrameField:NEXT-SIBLING.
  END.
  
  {set DisplayedFieldHandles cDisplayedFieldHandles}.
  {set DisplayedObjectHandles cDisplayedObjectHandles}.
  {set EnabledFieldHandles cEnabledFieldHandles}.
  {set EnabledObjectHandles cEnabledObjectHandles}.
  {set FieldHandles cFieldHandles}.
  
  {set ObjectInitialized yes}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-inputFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputFields Procedure 
PROCEDURE inputFields :
/*------------------------------------------------------------------------------
  Purpose:    Receives field input from the Web browser and populates the form 
              buffer field values.
  Parameters: <none>
  Notes:      Runs the WEB.INPUT procedure for each HTML field in the offset 
              (.off) file.  Commonly used in process-web-request procedure.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE utilProcResult AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE fieldValue     AS CHARACTER NO-UNDO.

  DEFINE BUFFER htmoff-input FOR htmoff.
 
  FOR EACH htmoff-input WHERE htmoff-input.proc-id = TARGET-PROCEDURE:
    fieldValue = get-field(htmoff-input.HTM-NAME).
   
    /* Dispatch to WEB.INPUT procedure */ 
    IF CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, 
      htmoff-input.WDT-NAME + ".INPUT":U) THEN
      /* User-defined INPUT procedure */
      RUN VALUE(htmoff-input.WDT-NAME + '.INPUT':U) IN TARGET-PROCEDURE 
        (fieldValue) NO-ERROR.
    ELSE
      /* Call the default utility procedure. */
      RUN dispatchUtilityProc ("WEB.INPUT":U, htmoff-input.HANDLE, 
                               fieldValue, htmoff-input.ITEM-CNT, 
                               TARGET-PROCEDURE, OUTPUT utilProcResult).
  END. /* FOR EACH htmoff-input... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputFields Procedure 
PROCEDURE outputFields :
/*------------------------------------------------------------------------------
  Purpose:    Replaces the tagged HTML field definition with the data values 
              stored in the form buffer.
  Parameters: <none>
  Notes:      Merges the HTML file with the results of running the WEB.OUTPUT 
              procedure, if one exists, for each HTML field.  Otherwise just 
              the HTML field definition is output.  When available, default 
              utility procedures containing the WEB.OUTPUT procedure are run,
              based on HTML field type.  Commonly used in process-web-request 
              procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE util-proc-result AS LOGICAL NO-UNDO.

  DEFINE VARIABLE c-name            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-path            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE clip-bytes        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE field-def         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE file-ext          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE html-path         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE htmfname          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE next-line         AS CHARACTER NO-UNDO.
  
  /* line numbers and line offset of the field definition */
  DEFINE VARIABLE line-no           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE start-line-no     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE end-line-no       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE start-line-offset AS INTEGER   NO-UNDO.
  DEFINE VARIABLE end-line-offset   AS INTEGER   NO-UNDO.
  
  DEFINE BUFFER htmoff-output FOR htmoff.
  
  {get WebFile htmFname}.
  
  /* Look for HTML file. */
  RUN webutil/_htmsrch.p (htmFname,TARGET-PROCEDURE:FILE-NAME,
                          OUTPUT html-path).
  IF html-path = ? THEN DO:
    RUN adecomm/_osfext.p (htmFname,OUTPUT file-ext).
    
    IF file-ext <> "htm":U AND file-ext <> "html":U THEN
      c-name = SUBSTRING(htmFname,1,R-INDEX(htmFname,".":U),
                 "CHARACTER":U) + "htm":U.
      
    RUN HtmlError IN web-utilities-hdl (SUBSTITUTE("<b>ERROR:</b> The file &1 could not be found. [html-map.i]",htmFname)).
    RETURN "Error".
  END.
    
  INPUT STREAM instream FROM VALUE(html-path) NO-ECHO.
  ASSIGN start-line-offset = 1.

  FIND FIRST htmoff-output 
    WHERE htmoff-output.proc-id = TARGET-PROCEDURE NO-ERROR.
    
  REPEAT ON ENDKEY UNDO, RETRY:
    IF AVAILABLE (htmoff-output) THEN
      ASSIGN
        start-line-no     = htmoff-output.BEG-LINE
        start-line-offset = htmoff-output.BEG-BYTE 
        end-line-no       = htmoff-output.END-LINE
        end-line-offset   = htmoff-output.END-BYTE
        .
    ELSE DO: 
      /* Flush out the rest of the html file. */
      REPEAT:
        {&OUT} next-line + CHR(10).
  
        IMPORT STREAM instream UNFORMATTED next-line.
      END.
      LEAVE.
    END.

    cCharType = IF (SESSION:CPINTERNAL = "UTF-8":U) THEN "RAW":U
                ELSE "CHARACTER":U.
                
    /* Snip the field definition out of the file using the offsets */
    RUN getNextHtmlField (INPUT-OUTPUT next-line,
                          INPUT-OUTPUT line-no,
                          INPUT-OUTPUT start-line-no,
                          INPUT-OUTPUT start-line-offset,
                          INPUT-OUTPUT end-line-no,
                          INPUT-OUTPUT end-line-offset,
                          INPUT-OUTPUT field-def,
                          INPUT-OUTPUT clip-bytes).
    
    /* dispatch to WEB.OUTPUT procedure if one exists */
    IF CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES, 
      htmoff-output.WDT-NAME + ".OUTPUT":U) THEN DO:
      /* found that the user has defined a local WEB.OUTPUT procedure */
      IF htmoff-output.WDT-TYPE = "radio-set":U THEN
        RUN VALUE(htmoff-output.WDT-NAME + '.OUTPUT':U) IN TARGET-PROCEDURE 
          (field-def, htmoff-output.ITEM-CNT) NO-ERROR.
      ELSE
        RUN VALUE(htmoff-output.WDT-NAME + '.OUTPUT':U) IN TARGET-PROCEDURE 
          (field-def) NO-ERROR.
           END.
    ELSE DO:
      /* There is no local procedure defined so call the default proc. */
      RUN dispatchUtilityProc ("WEB.OUTPUT":U, htmoff-output.HANDLE, 
                               field-def, htmoff-output.ITEM-CNT, 
                               TARGET-PROCEDURE, OUTPUT util-proc-result).

      IF (util-proc-result <> TRUE) THEN
        /* Could not invoke default utility proc so send as is. */
        {&OUT} field-def + CHR(10).
    END.

    FIND NEXT htmoff-output 
      WHERE htmoff-output.proc-id = TARGET-PROCEDURE NO-ERROR.
  END. /* repeat */
  
  INPUT STREAM instream CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readOffsets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readOffsets Procedure 
PROCEDURE readOffsets :
/*------------------------------------------------------------------------------
  Purpose:    Wrapper to a procedure that reads the HTML Mapping offset file 
              and populates internal temp-tables.
  Parameters (INPUT):
              cWebFile (CHAR) - name of offset file
  Notes:      Internal use only.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cWebFile AS CHARACTER NO-UNDO.
   
  RUN web2/support/rdoffr.p (TARGET-PROCEDURE,cWebFile).                  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcTableName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: Get the handle of a buffer by name.
Parameters: INPUT pcTableName - The name of a table in the query/object.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDisplayedTables AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTbl             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFound           AS LOGICAL    NO-UNDO.

  {get DataSource hDataSource}.  
  {get QueryHandle hQuery}.
  
  IF VALID-HANDLE(hDataSource) OR VALID-HANDLE(hQuery) THEN 
    RETURN SUPER(pcTableName).
  
  {get DisplayedTables cDisplayedTables}.

  hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(pcTableName,cDisplayedTables) + 1,
                          cDisplayedTables)
                         ) NO-ERROR.

  IF VALID-HANDLE(hBuffer) THEN
     RETURN hBuffer.

  /* now check each handle to see if the qualification in the input is 
     different from what's stored */

  DO iTbl = 2 TO NUM-ENTRIES(cDisplayedTables) BY 2:
    ASSIGN 
      hBuffer = WIDGET-HANDLE(ENTRY(iTbl,cDisplayedTables)).
    
    IF NUM-ENTRIES(pcTableName,".":U) = 2 THEN 
    DO:
      IF  hBuffer:DBNAME  = ENTRY(1,pcTableName,".":U)
      AND hBuffer:NAME    = ENTRY(2,pcTableName,".":U) THEN
        RETURN hBuffer.
    END.
    ELSE IF hBuffer:NAME = pcTableName THEN
    DO:
      IF lFound THEN 
        RETURN ?.  /* ambigous */
      lFound = TRUE. 
    END.
  END.
     
  RETURN hBuffer.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHTMLName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHTMLName Procedure 
FUNCTION columnHTMLName RETURNS CHARACTER
  (pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Finds the HTML field name of a Column.
  Returns:    (CHAR) - HTML field name
  Parameters: (CHAR) - Column name
  Notes:   
------------------------------------------------------------------------------*/
 FIND FIRST htmoff WHERE htmoff.proc-id  = TARGET-PROCEDURE     
                   AND   htmoff.wdt-name = pColumn NO-ERROR.                    

 RETURN (IF AVAILABLE htmoff THEN htmoff.htm-name ELSE "":U).
        
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
    Purpose: Override to handle HTML mapping objects with neither query or sdo  
 Paramerers: pcColumn              
      Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lUseDbQual       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDBQual          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayedFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFound           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQualColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTbl             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumEntries      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDbs             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTableHandle     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedTables AS CHARACTER  NO-UNDO.

  {get DataSource  hDataSource}.  
  {get QueryHandle hQuery}.
  
  IF VALID-HANDLE(hDataSource) OR VALID-HANDLE(hQuery) THEN
    RETURN SUPER(pcColumn).
  
  /* Code below this point deals with HTML mapping with no query or sdo */

  {get DisplayedFields cDisplayedFields}. 
  /* If the Column is in the fieldlist just remove the .field and 
     return the rest */ 
 
  IF LOOKUP(pcColumn,cDisplayedFields) > 0 THEN
  DO:
     ENTRY(NUM-ENTRIES(pcColumn,".":U),pcColumn,".":U) = "":U.
     RETURN RIGHT-TRIM(pcColumn,".":U).
  END.
  
  iNumEntries = NUM-ENTRIES(pcColumn,".":U). 
  
  {get UseDbQualifier lUseDbQual}. 
  
  /* If it's correctly qualifed then it does not exist inhte field list */
  IF (    lUseDBQual AND iNumEntries = 3) 
  OR (NOT lUseDBQual AND iNumEntries = 2)  THEN 
    RETURN '':U.

  {get Tables cTables}.

  /* Column without table name */
  IF iNumEntries = 1 THEN
  DO:
    /* Just add each table as qaulifer and see if its in the field list ONCE */
    DO iTbl = 1 TO NUM-ENTRIES(cTables):
      ASSIGN
        cTable      = ENTRY(iTbl,cTables)
        cQualColumn = cTable + ".":U + pcColumn.   
      
      IF LOOKUP(cQualColumn,cDisplayedFields) > 0 THEN
      DO:
        IF lFound THEN 
          RETURN ?.   /* more than one match.. */
        lFound = TRUE.
      END.
    END. /* do itbl = 1 */
    RETURN cTable. /* This will be blank if nothing was found. */    
  END. /* unqualifed column */
  
    /* if we are here with useDBqual the column is of form table.field */  
  IF lUSeDbQual THEN
  DO:
    /* Just add each table as qualifer and see if its in the field list ONCE */
    DO iTbl = 1 TO NUM-ENTRIES(cTables):
      ASSIGN
        cTable      = ENTRY(iTbl,cTables).
      
      IF ENTRY(2,cTable,".":U) = ENTRY(1,pcColumn,".":U) THEN
      DO:
        cQualColumn = cTable + ".":U + pcColumn.   
        IF LOOKUP(cQualColumn,cDisplayedFields) > 0 THEN
        DO:
          IF lFound THEN 
            RETURN ?.   /* more than one match.. */
          lFound = TRUE.
        END.
      END. /* entry(2,table) */ 
    END. /* do itbl = 1 */
    RETURN cTable. /* This will be blank if nothing was found. */    
  END.
  
  /* if we got this far the we don't use dbqualifer, but the column does */
  {get DisplayedTables cDisplayedTables}.
  DO iTbl = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cTable       = ENTRY(iTbl,cTables)
      hTableHandle = WIDGET-HANDLE(ENTRY(LOOKUP(cTable,cDisplayedTables) + 1,
                                         cDisplayedTables)
                                  ).
    
    IF  hTableHandle:DBNAME  = ENTRY(1,pcColumn,".":U)
    AND hTableHandle:NAME    = ENTRY(2,pcColumn,".":U) THEN
    DO:
      cQualColumn = cTable + ".":U + ENTRY(3,pcColumn,".":U).   
      IF LOOKUP(cQualColumn,cDisplayedFields) > 0 THEN
      DO:
        IF lFound THEN 
          RETURN ?.   /* more than one match.. */
        lFound = TRUE.
      END.
    END. /* db and tbl = entry 1 and 2 */
  END. /* do itbl = 1 */
  
  RETURN cTable. /* This will be blank if nothing was found. */    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Called by adm-create-objects to check the current page.
  Returns:    (INT) - 0 (zero)
  Parameters: <none>
  Notes:      This belongs in a container, but is implemented here until 
              WebSpeed supports containers.
------------------------------------------------------------------------------*/
  RETURN 0.   /* Always 0 */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Override to use the property for HTML mapping with no data-source  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTableList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTbl        AS INTEGER   NO-UNDO.

  {get DataSource  hDataSource}.  
  {get QueryHandle hQuery}.
  
  IF VALID-HANDLE(hDataSource) OR VALID-HANDLE(hQuery) THEN 
    RETURN SUPER().
  
  /* DisplayedTables stores Tablename,handle[Tablename,handle] */

  {get DisplayedTables cTableList}.
  
  DO iTbl = 1 TO NUM-ENTRIES(cTableList) BY 2:
    cTable  = ENTRY(iTbl,cTableList).
    IF cTable <> 'ab_unmap':U THEN
      cTables = cTables 
                + (IF cTables = '':U THEN "":U ELSE ",":U) 
                + cTable.
  END.
  RETURN cTables. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

