&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
      File      : wbdata.p 
    Purpose     : Super procedure that handles updates of Web Objects
    Syntax      : web2/wbdata.p

    Modified    : January 19, 2000
 ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE admsuper wbdata.p

{src/web2/custom/wbdataexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteBuffer Procedure 
FUNCTION deleteBuffer RETURNS LOGICAL
  (phBuffer AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exclusiveLockBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD exclusiveLockBuffer Procedure 
FUNCTION exclusiveLockBuffer RETURNS LOGICAL PRIVATE
  (phBuffer AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeleteTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDeleteTables Procedure 
FUNCTION getDeleteTables RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle Procedure 
FUNCTION getFrameHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockRow Procedure 
FUNCTION lockRow RETURNS LOGICAL
  (pLock AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAddMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAddMode Procedure 
FUNCTION setAddMode RETURNS LOGICAL
  (plAdd  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDeleteTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDeleteTables Procedure 
FUNCTION setDeleteTables RETURNS LOGICAL
  (pcDeleteTables AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFrameHandle Procedure 
FUNCTION setFrameHandle RETURNS LOGICAL
  (pHdl AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateColumns Procedure 
FUNCTION validateColumns RETURNS LOGICAL
  ()  FORWARD.

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
         HEIGHT             = 10.91
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}
{src/web2/wbdaprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFields Procedure 
PROCEDURE assignFields :
/*-----------------------------------------------------------------------------
  Purpose:     Save all columns in the DataColumns attribute. The values are 
               retrieved from the web with the get-field function. 
  Parameters:  <none>
  Notes:       If the AddMode property is TRUE a new record will be created. 
               If the data-source is an SDO a call to addRow() is done if 
               AddMode = TRUE while submitRow() always saves the record. 
               If the data-source is a database validateColumns() must 
               return TRUE before data is saved inside a TRANSACTION block. 
               The lockRow() function achieves the exclusive lock and will 
               create a record if AddMode = TRUE.                        
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cColName    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cHTMLName   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cColString  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hColHdl     AS HANDLE NO-UNDO.  
  DEFINE VARIABLE hFrame      AS HANDLE NO-UNDO.  
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.  
  DEFINE VARIABLE cRowObjId   AS CHAR   NO-UNDO.  
  DEFINE VARIABLE iFld        AS INT    NO-UNDO.  
  DEFINE VARIABLE lOK         AS LOG    NO-UNDO.  
  DEFINE VARIABLE lAddMode    AS LOG    NO-UNDO.  
  DEFINE VARIABLE cError      AS CHAR   NO-UNDO.
  DEFINE VARIABLE i           AS INT    NO-UNDO.  
  DEFINE VARIABLE iExt        AS INT    NO-UNDO.  
    
  {get DataColumns cColumns}.
  {get DataSource hDataSource}.
  {get AddMode lAddMode}.
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    IF lAddMode THEN 
      cRowObjId = ENTRY(1,dynamic-function("addRow":U IN hDataSource,"":U),CHR(1)). 
    ELSE 
      cRowObjId = ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("colValues":U IN hDataSource,"":U),chr(1))).
    
    DO iFld = 1 TO NUM-ENTRIES(cColumns):      
      ASSIGN
        cColName   = ENTRY(iFld,cColumns).
      
      IF DYNAMIC-FUNCTION('columnReadOnly':U IN hDataSource, cColName) THEN NEXT.
          
      ASSIGN
        cHTMLName  = DYNAMIC-FUNCTION('columnHTMLName':U IN TARGET-PROCEDURE, 
                                       cColName)
        cColString = cColString  
                     + (IF cColString = "":U THEN "":U ELSE CHR(1)) 
                     + cColName + CHR(1) + get-field(cHTMLName).
    END.    
    DYNAMIC-FUNCTION("submitRow":U IN hDataSource,cRowObjId,cColString).
    IF {fn anyMessage} AND lAddMode THEN  
      DYNAMIC-FUNCTION('cancelRow':U IN hDataSource).

  END.     
  ELSE
  DO:    
    IF DYNAMIC-FUNCTION ('validateColumns':U IN TARGET-PROCEDURE) THEN
    DO:       
      DO TRANSACTION ON ERROR UNDO,LEAVE:
        IF DYNAMIC-FUNCTION('LockRow':U IN TARGET-PROCEDURE,"EXCLUSIVE":U) THEN
        DO iFld = 1 TO NUM-ENTRIES(cColumns):      
          ASSIGN
            cColName  = ENTRY(iFld,cColumns)
            hColHdl   = DYNAMIC-FUNCTION('ColumnHandle' IN TARGET-PROCEDURE, 
                                        cColname)      
            cHTMLName = DYNAMIC-FUNCTION('columnHTMLName':U IN TARGET-PROCEDURE, 
                                       cColName)
            iExt      = DYNAMIC-FUNCTION('extentValue' in TARGET-PROCEDURE,
                                         cColName) 
            hColHdl:BUFFER-VALUE(iExt) = get-field(cHTMLName)       
          NO-ERROR.
          IF ERROR-STATUS:ERROR THEN 
          DO:
            RUN AddMessage IN TARGET-PROCEDURE(
                            ?,
                            cColName,
                            ?).           
            UNDO,LEAVE.
          END. /* if error */
        END. /* if ..lock.. then do ifld = 1 to */            
      END. /* do transaction */            
      DYNAMIC-FUNCTION('LockRow':U IN TARGET-PROCEDURE,"NO-LOCK":U).
    END. /* if validate(frame) */        
  END. /* else do  (not valid-handle(hdatasource)) */  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessWebRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessWebRequest Procedure 
PROCEDURE ProcessWebRequest :
/*------------------------------------------------------------------------------
  Purpose: Process the request submitted from the web browser.        
  Parameters:  <none>
  Notes:     The main logic is in the SUPER version in webrep.p while this 
             has the necessary logic to handle saving or deleting records 
             when get-field('maintOption') equals "submit" or "delete". 
             It also sets the CurrentRowids property that are returned 
             to the web in these cases. Otherwise the SUPER procedure maintains 
             this property.   
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE MaintOption AS CHAR NO-UNDO.
  DEFINE VARIABLE lAdd        AS LOG  NO-UNDO.
  DEFINE VARIABLE cRowids     AS CHAR NO-UNDO.
  
  ASSIGN
    MaintOption = get-field('MaintOption':U)
    lAdd        = get-field('AddMode':U) = "yes":U.
  
  {set AddMode lAdd}.
  
  RUN SUPER.   
  
  IF NOT lAdd AND DYNAMIC-FUNCTION('getQueryEmpty':U IN TARGET-PROCEDURE) THEN 
  DO:
    {set UpdateMode 'Add':U}.
    RUN AddMessage IN TARGET-PROCEDURE 
             ('Record not found. Switching to add mode.',?,?).        
    RETURN.
  END.

  CASE MaintOption:
    WHEN "Submit" THEN
      RUN AssignFields IN TARGET-PROCEDURE NO-ERROR.
    WHEN "Delete" THEN DO:
      DYNAMIC-FUNCTION("DeleteRow":U IN TARGET-PROCEDURE). 
    END. 
  END CASE /* Maintoption */.  
  
  /* This is usually done in the super procedure, but must be done here in case 
     of a delete or add */      
  IF MaintOption <> "":U THEN
  DO:
    cRowids = DYNAMIC-FUNCTION("getRowids":U IN TARGET-PROCEDURE).
    
    IF cRowids = ? THEN 
      cRowids = "":U.
  
    {set CurrentRowids cRowids}.
  END.
                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR):
/*-----------------------------------------------------------------------------
  Purpose: Returns the validation message of the database or SDO column. 
Parameter: pcColumn - column name.  
    Notes: This function is currently called from validateColumns to create  
           an error message in the case a validation fails.  
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hColumn     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN 
    RETURN DYNAMIC-FUNCTION('columnValMsg':U IN hDataSource, pcColumn).
  
  ELSE
    hColumn = DYNAMIC-FUNCTION('columnHandle':U IN TARGET-PROCEDURE,pcColumn).
  
  RETURN hColumn:VALIDATE-MESSAGE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteBuffer Procedure 
FUNCTION deleteBuffer RETURNS LOGICAL
  (phBuffer AS HANDLE) :
/*----------------------------------------------------------------------------
  Purpose: Delete a buffer record.  
Parameter: The BUFFER's handle.   
    Notes: Called from deleteRow() INSIDE of the transaction.   
           The main reason for this construct is to make it overrideable in 
           the target-procedure. This is necessary for tables with schema 
           validation because the BUFFER-DELETE which is used in deleteRow()
           does not work for these tables. 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE lDelete AS LOGICAL    NO-UNDO.

  IF DYNAMIC-FUNCTION('exclusiveLockBuffer' IN TARGET-PROCEDURE, phBuffer) THEN
  DO:    
    DO ON ERROR UNDO, LEAVE: 
      phBuffer:BUFFER-DELETE.  
      lDelete = TRUE.
    END.

    IF NOT lDelete THEN
      RUN AddMessage IN TARGET-PROCEDURE (?,?,phBuffer:TABLE).             
        
    RETURN lDelete. 
  END. /* if exclusive-lock*/

  ELSE 
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Delete the current row  
    Notes: If the data-source is an SDO it will get it's RowObject rowid and 
           use it as input parameter to the SDO's deleteRow.  
           In the case where a database is the data-source it will loop thru 
           the table's returned from the DeleteTables property and pass the
           buffer's handle found in the query to the deleteBuffer function. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDeleteTables   AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cTable          AS CHAR   NO-UNDO.  
  DEFINE VARIABLE hBuffer         AS HANDLE NO-UNDO.  
  DEFINE VARIABLE iBuff           AS INT    NO-UNDO.  
  DEFINE VARIABLE lOk             AS LOG    NO-UNDO.  
  DEFINE VARIABLE hDataSource     AS HANDLE NO-UNDO.  
  DEFINE VARIABLE cRowObjId       AS CHAR   NO-UNDO.  
      
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Get the RowObject's rowid */
    cRowObjId = ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("colValues":U IN hDataSource,"":U),chr(1))).    
    RETURN DYNAMIC-FUNCTION("deleteRow":U IN hDataSource,cRowObjId).
  END.     
  ELSE DO:  
    cDeleteTables = DYNAMIC-FUNCTION('getDeleteTables':U IN TARGET-PROCEDURE).           
    
    DO TRANSACTION ON ERROR UNDO, LEAVE:
      DO iBuff = 1 TO NUM-ENTRIES(cDeleteTables):
        ASSIGN
          cTable  = ENTRY(iBuff,cDeleteTables)
          hBuffer = DYNAMIC-FUNCTION('bufferHandle':U IN TARGET-PROCEDURE,
                                      cTable) 
          lOk     = DYNAMIC-FUNCTION('deleteBuffer':U IN TARGET-PROCEDURE,
                                      hBuffer).        
        IF NOT lOk THEN UNDO, LEAVE.      
      END. /* do ibuff = 1 to num-entries(cDeleteTables) */      
    END. /* do transaction */ 
        
    IF NOT lOK THEN 
      RUN fetchCurrent IN TARGET-PROCEDURE.      
    ELSE
      RUN fetchPrev IN TARGET-PROCEDURE.
    
    RETURN lOk.
  END. /* else do (delete a queryrow) */       
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exclusiveLockBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION exclusiveLockBuffer Procedure 
FUNCTION exclusiveLockBuffer RETURNS LOGICAL PRIVATE
  (phBuffer AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose: Exclusive Lock a buffer in the query.   
    Notes: Defined as private because its only used by deleteBuffer and lockRow 
           and there is no check whether this is a table in the query.
------------------------------------------------------------------------------*/    
   DEFINE VARIABLE rRowid AS ROWID  NO-UNDO.

   IF phBuffer:ROWID <> ? THEN
   DO:
     rRowid = phBuffer:ROWID.
     phBuffer:FIND-BY-ROWID(phBuffer:ROWID, EXCLUSIVE-LOCK, NO-WAIT). 
     
     IF phBuffer:CURRENT-CHANGED THEN 
     DO:
       RUN AddMessage IN TARGET-PROCEDURE
            ("Record has been changed by another user.",?,phBuffer:TABLE).
       RETURN FALSE. 
     END. /* changed */

     IF phBuffer:LOCKED THEN 
     DO:
       phBuffer:FIND-BY-ROWID(rRowid, NO-LOCK). 

       RUN AddMessage IN TARGET-PROCEDURE
            ("Record is locked.",?,phBuffer:TABLE).
       
       RETURN FALSE.   
     END. /* locked */
     
     IF phBuffer:AVAIL = FALSE THEN 
     DO:
       RUN AddMessage IN TARGET-PROCEDURE
         ("Record is not available for update",?,phBuffer:TABLE).
       RETURN FALSE.      
     END. /* avail = false */ 
   
     RETURN TRUE.   /* Function return value. */
   END. /* rowid <> ? */
   ELSE 
     RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeleteTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDeleteTables Procedure 
FUNCTION getDeleteTables RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a comma separated list of tables to delete.  
    Notes: The getTables is used if this attribute is not set.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDeleteTables AS CHAR.
  {get DeleteTables cDeleteTables}.
  
  IF cDeleteTables = "":U THEN
    cDeleteTables = DYNAMIC-FUNCTION("getTables":U IN TARGET-PROCEDURE).
 
  RETURN cDeleteTables. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle Procedure 
FUNCTION getFrameHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the frame handle of the object. 
    Notes: This is the optional frame used for validation for Embedded 
           SpeedScripta detail.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.
  {get FrameHandle hHdl}.
  RETURN hHdl. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockRow Procedure 
FUNCTION lockRow RETURNS LOGICAL
  (pLock AS CHAR) :
/*-----------------------------------------------------------------------------
  Purpose: Lock ALL the buffers in the query 
  Parameter: pLock as CHAR - begins "EXCLUSIVE" will exclusive-lock the 
                             record(s).
                           - all other values wil be interpreted as no-lock. 
    Notes: Only used when the data-source is a data-base. Used by assignFields 
           and deleteRow. 
           It checks the AddMode Property and creates record(s) if it's TRUE.
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE NO-UNDO.  
  DEFINE VARIABLE cTables         AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cTable          AS CHAR   NO-UNDO.  
  DEFINE VARIABLE iBuff           AS INT    NO-UNDO.
  DEFINE VARIABLE lAddMode        AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk             AS LOG    NO-UNDO.
  
  {get Tables cTables}.
  {get AddMode lAddMode}.

  DO iBuff = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cTable  = ENTRY(iBuff,cTables)
      hBuffer = DYNAMIC-FUNCTION('bufferHandle':U IN TARGET-PROCEDURE,
                                  cTable).
 
    IF pLock BEGINS "EXCLUSIVE":U THEN
    DO:        
      IF lAddMode THEN
        lOk = hBuffer:BUFFER-CREATE.           
      ELSE   
        lOk = DYNAMIC-FUNCTION('exclusiveLockBuffer':U IN TARGET-PROCEDURE,
                                hBuffer).        
      IF NOT lOk THEN 
        RETURN FALSE. 
    END. /* plock begins 'exclusive' */
    ELSE IF hBuffer:ROWID <> ? THEN
      hBuffer:FIND-BY-ROWID(hBuffer:ROWID, NO-LOCK).     
  END. /* Do iBuff = 1 TO NUM-ENTRIES(cBuffers) */
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAddMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAddMode Procedure 
FUNCTION setAddMode RETURNS LOGICAL
  (plAdd  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Set the ADDMode property
           If it is true the assignFields procedure will create a new record.  
    Notes:  
------------------------------------------------------------------------------*/
  {set AddMode plAdd}.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDeleteTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDeleteTables Procedure 
FUNCTION setDeleteTables RETURNS LOGICAL
  (pcDeleteTables AS CHAR): 
/*------------------------------------------------------------------------------
  Purpose: Stores a comma separated list of tables to delete.  
    Notes: This may be used to delete only one of the joined tables, it may also 
           be useful to define the sequence of deletion.   
           If this is blank the deleteRow will delete all the tables in the query.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables AS CHAR NO-UNDO.
  DEFINE VARIABLE i       AS INT  NO-UNDO.

  {get Tables cTables}.

  DO i = 1 TO NUM-ENTRIES(pcDeleteTables):
    
    /* This is a programmer error, so we don't bother to use an alertbox */
    IF NOT CAN-DO(cTables,ENTRY(i,pcDeleteTables)) THEN
    DO:
      {&OUT} 
      "The table " ENTRY(i,pcDeleteTables) " was specified in the 
      ~'setDeleteTables~' function, but not defined in the query. <br>"
      "The attribute will be ignored. <br>".
      RETURN FALSE.   
    END.
  END.
   
  {set DeleteTables pcDeleteTables}.

  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFrameHandle Procedure 
FUNCTION setFrameHandle RETURNS LOGICAL
  (pHdl AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Store the handle of the frame 
    Notes:  
------------------------------------------------------------------------------*/
  {set FrameHandle pHdl}.
  
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateColumns Procedure 
FUNCTION validateColumns RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Loops through the validation frame and validates fields.
    Notes: If the columns are found in the DataColumns attribute the data is 
           read from the WebPage using get-field. If not we assume that the 
           frame already has data. This is implemented to support HTML mapping, 
           but the HTML mapping object does not currently support this function
           as default behavior.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame          AS HANDLE NO-UNDO.
  DEFINE VARIABLE hFld            AS HANDLE NO-UNDO.
  DEFINE VARIABLE lUseDb          AS LOG    NO-UNDO.
  DEFINE VARIABLE cColumns        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cEnabledFields  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cColName        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cHTMLName       AS CHAR   NO-UNDO.
  DEFINE VARIABLE lDataInFrame    AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk             AS LOG    NO-UNDO.
  DEFINE VARIABLE lValidate       AS LOG    NO-UNDO INIT TRUE.
      
  {get FrameHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
  DO:
    {get DataColumns cColumns}.
    
    /* If no datacolumns, check if there is any enabledFields.
       This indicates that this is a mapped object with data in the frame */ 
    
    IF cColumns = "" THEN
      ASSIGN lDataInFrame = TRUE.
       
    hFrame:HIDDEN = TRUE.
    
    ASSIGN 
      lUseDb = NUM-ENTRIES(ENTRY(1,cColumns),".") > 2
      hFld   = hFrame:FIRST-CHILD
      hFld   = hFld:FIRST-CHILD.
    
    DO WHILE VALID-HANDLE(hFld):
      ASSIGN 
        lOk      = TRUE
        cColName = (IF lUseDb AND hFld:DBNAME <> ? 
                    THEN hFld:DBNAME + ".":U 
                    ELSE "":U)
                    + (IF hFld:TABLE <> ? 
                       THEN hFld:TABLE + ".":U
                       ELSE "":U)
                    + hFld:NAME
      .        
      IF hFld:SENSITIVE THEN
      DO:
        /* If no data in the frame we use get-gield to get data from the WEB */ 
        IF NOT lDataInFrame THEN 
        DO:  
          ASSIGN
            cHTMLName   = DYNAMIC-FUNCTION('columnHTMLName':U IN TARGET-PROCEDURE,        
                                            cColName)
            hFld:FORMAT = DYNAMIC-FUNCTION('columnFormat':U IN TARGET-PROCEDURE, 
                                            cColName). 
                                              
          ASSIGN 
            hFld:SCREEN-VALUE = get-field(cHTMLName) 
            NO-ERROR.
          
          /* If wrong datatype in screenvalue the error-status:error is false */ 
          IF ERROR-STATUS:GET-MESSAGE(1) <> '':U THEN
          DO:
            /* We pass only the first to avoid screen-value error etc */
            RUN AddMessage IN TARGET-PROCEDURE(ERROR-STATUS:GET-MESSAGE(1),
                                               cColName,
                                               ?).           
            lOk = FALSE.
          END.
        END. /* If not lDataInFrame */     
        IF lOk THEN
        DO:
          ASSIGN lok = hFld:VALIDATE() NO-ERROR.
          IF NOT lOk THEN 
            RUN AddMessage IN TARGET-PROCEDURE(
                DYNAMIC-FUNCTION('columnValMsg':U IN TARGET-PROCEDURE,cColName),
                cColName,
                ?).           
        END. /* if lok */
      END. /* if colname:sensitive */
      ASSIGN
        lValidate = if NOT lok THEN FALSE ELSE lValidate
        hFld      = hFld:NEXT-SIBLING.
    END. /* do while valid-handle(hfld)*/   
  END. /* if valid-handle(hFrame) */   
  ELSE lValidate = TRUE.
   
  RETURN lValidate. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

