&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*--------------------------------------------------------------------------
    File        : data.p
    Purpose     : Super Procedure for all SmartDataObjects

    Syntax      : adm2/data.p

    Modified    : August 9, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataattr.i that this is the Super procedure. */
   &SCOP ADMSuper data.p
   
  {src/adm2/custom/dataexclcustom.i}

  DEFINE VARIABLE ghRowObject AS HANDLE    NO-UNDO. /* Handle of current TT rec.*/

/* This AddStartRow number, is used as a global sequence for new records, 
   This may very well change in a future release. */
&SCOP  xiAddStartRow 9000000 /* high # for new rows*/
  DEFINE VARIABLE giAddRowNum  AS INTEGER NO-UNDO 
    INIT {&xiAddStartRow}. /* tmp row num for add */

  /* Include the file which defines AppServerConnect procedures. */
  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRow Procedure 
FUNCTION createRow RETURNS LOGICAL
  (pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRow Procedure 
FUNCTION findRow RETURNS LOGICAL
  (pcKeyValues AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS LOGICAL
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowWhere Procedure 
FUNCTION findRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstRowIds Procedure 
FUNCTION firstRowIds RETURNS CHARACTER
 (pcQueryString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasOneToOneTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasOneToOneTarget Procedure 
FUNCTION hasOneToOneTarget RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
  (pcMode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openDataQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openDataQuery Procedure 
FUNCTION openDataQuery RETURNS LOGICAL
  (pcPosition AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowAvailable Procedure 
FUNCTION rowAvailable RETURNS LOGICAL
  ( pcDirection  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowValues Procedure 
FUNCTION rowValues RETURNS CHARACTER
  ( pcColumns   AS CHAR,
    pcFormat    AS CHAR,
    pcDelimiter AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  (pcKeyValues AS CHAR,
   pcValueList AS CHAR)  FORWARD.

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
         HEIGHT             = 14.33
         WIDTH              = 53.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-batchServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE batchServices Procedure 
PROCEDURE batchServices :
/*------------------------------------------------------------------------------
  Purpose:     To group a sequence of SDO service requests into a single request
               and thereby minimize network messaging and improve performance.
  
  Parameters:
    INPUT pcServices - A character string containing a CHR(1) delimitted list of
                       SDO internal procedures and functions to be executed.  
                       Each entry consists of a CHR(2) delimitted list of INPUT
                       PARAMETER values with the first entry being the NAME of
                       the procedure or function to be executed.
    OUTPUT pcValues  - A character string containing a CHR(1) delimitted list of
                       CHR(2) delimitted strings of output values that result 
                       from the execution of the services listed in pcServices
                       (above).  There is a one-to-one correspondence between
                       the CHR(1) delimitted list of Services in pcServices 
                       (above) and the CHR(1) delimitted list in pcValues.  
                       Procedures with no output paramters have a NULL entry.
                       The return value of functions appear as the first entry 
                       of the corresponding CHR(2) delimitted list, followed
                       by any output parameters.
  
  Notes:       As shipped, batchServices only supports a limited list of services.
               This list consists of all "get" and "set" functions that don't
               require processing other than getting and setting the property in
               the ADMprops temp-table record as well as columnProps,
               initializeObject, openQuery and synchronizeProperties. The list of
               cases will be extended from release to release.  Developers can
               extend the list by overriding batchServices with a local version
               that has an extended list then running SUPER.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcServices AS CHARACTER                         NO-UNDO.
DEFINE OUTPUT PARAMETER pcValues   AS CHARACTER                         NO-UNDO.

  DEFINE VARIABLE iService         AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE numServices      AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE cRequest         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cService         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cDataType        AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER                         NO-UNDO.

  numServices = NUM-ENTRIES(pcServices, CHR(1)).
  DO iService = 1 TO numServices:  /* FOR EACH Service */

    ASSIGN cRequest = ENTRY(iService, pcServices, CHR(1))
           cService = ENTRY(1, cRequest, CHR(2)).

    CASE cService:

      WHEN "columnProps" THEN DO:
        pcValues = pcValues +
                      columnProps(INPUT ENTRY(2,cRequest,CHR(2)),
                                  INPUT ENTRY(3,cRequest,CHR(2))).
      END.

      WHEN "initializeObject" THEN DO:
        RUN initializeObject IN TARGET-PROCEDURE.
      END.
  
      WHEN "openQuery" THEN DO:
        pcValues = pcValues + STRING({fn openQuery}).
      END.

      WHEN "synchronizeProperties" THEN DO:
        RUN synchronizeProperties IN TARGET-PROCEDURE
                                 (INPUT ENTRY(2, cRequest, CHR(2)),
                                  OUTPUT cValue).
        pcValues = pcValues + cValue.
      END.

      OTHERWISE DO:
        /* See if it is a get- or set- property function */
        IF (cService BEGINS "get" AND NUM-ENTRIES(cRequest,CHR(2)) = 1) OR
           (cService BEGINS "set" AND NUM-ENTRIES(cRequest,CHR(2)) = 2) THEN DO:

          /* Get the datatype of the property */
          cDataType = DYNAMIC-FUNCTION("propertyType":U IN TARGET-PROCEDURE,
                                        SUBSTRING(cService,4)).
          IF cDataType EQ ? THEN  /* It wasn't found */
            RUN addMessage IN TARGET-PROCEDURE ("Function ":U + cService + " not defined.":U, ?, ?).
          ELSE IF cService BEGINS "s":U THEN DO:
            CASE cDataType:
              WHEN "CHARACTER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) )).
              WHEN "INTEGER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             INTEGER(ENTRY(2,cRequest,CHR(2))) )).
              WHEN "LOGICAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) = "yes" )).
              WHEN "DECIMAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             DECIMAL(ENTRY(2,cRequest,CHR(2))) )).
            END CASE.  /* Case on Signature */
          END.  /* setProperty case */
          ELSE DO:  /* getProperty case */
            pcValues = pcValues + STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE)).
          END.  /* getProperty case */
        END. /* If cService begins get or set */
        ELSE  /* Not a get or set function */
          RUN addMessage IN TARGET-PROCEDURE ("Function ":U + cService + " not defined.":U, ?, ?).
      END.  /* Otherwise do: */

    END CASE.  /* CASE on cService */

    IF iService NE numServices THEN
      ASSIGN pcValues = pcValues + CHR(1).

  END. /* DO iService = 1 TO numServices */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clientSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clientSendRows Procedure 
PROCEDURE clientSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Calls across the AppServer boundary to serverSendRows to fetch
               a batch of RowObject temp-table records.  When the 
               SmartDataObject is split between client and AppServer, 
               this client-side procedure is run from the generic sendRows 
               procedure.  It simply turns around and runs a server-side 
               version which returns the RowObject temp-table records.

  Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
  
  Notes:       All of the parameters are simply received from the caller and
               passed through to serverSendRows on the AppServer.
               If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
               In 9.1B, we are prepared to run in our Container's ASHandle
               if we are in an SBO.
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE VARIABLE cQueryString   AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE hAppServer     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowNum        AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowIdent      AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE lAdded         AS LOGICAL           NO-UNDO INIT TRUE.
 DEFINE VARIABLE nextPosition   AS ROWID             NO-UNDO.
 DEFINE VARIABLE cLastResult    AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cOperatingMode AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE lInitRowObject AS LOGICAL           NO-UNDO.
 DEFINE VARIABLE hSource        AS HANDLE            NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE lBrowsed       AS LOGICAL           NO-UNDO.
 DEFINE VARIABLE cAsDivision    AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE hRowObjectTbl  AS HANDLE            NO-UNDO.
 
  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) THEN 
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).

  IF piStartRow = ? OR piStartRow = 0 THEN 
  DO:
    /* If the query is already open then we need to get last in order to 
       save the rowid of the last RowObject in the batch so that we can 
       reposition appropriately after retrieving another batch below. */
    IF VALID-HANDLE(hDataQuery) AND hDataQuery:IS-OPEN THEN 
    DO:
      hDataQuery:GET-LAST().
      IF hRowObject:AVAILABLE THEN 
      DO:
        hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
          /* If the last record has a row number that is greater than
             {&xiAddStartRow} then this is a newly added record and not part 
             of the batch that was retrieved so we do not want to save off
             this rowid. We want to keep getting previous records until
             we get to the rowid of the last RowObject in the last batch 
             that was retrieved - that is the rowid we want to save off.  */  
        DO WHILE lAdded:
          /* The xiAddStartRow preprocessor is used to set the row number 
             for newly added records, 
           - we don't want to make this a property because using row number
             like this will likely change in a future release */
          IF hRowNum:BUFFER-VALUE > {&xiAddStartRow} THEN
          DO:
            hDataQuery:GET-PREV().
            /* If only new rows, we might end up at the top.  */
            IF hRowObject:AVAILABLE = FALSE THEN
              LEAVE. 
          END.
          ELSE lAdded = FALSE.
        END.  /* Do while lAdded */
        nextPosition = hRowObject:ROWID.
        
        /* If we are running stateless we need to re-assign the LastResultRow
           to be the RowNum and RowIdent of the RowObject record which is the 
           last record of the batch (excluding newly added records).  This is
           to handle cases where the last row in the batch may have been 
           deleted.  LastResultRow is used in sendRows (when fetchNext is done) 
           to determine which record to start at when retrieving records for 
           the next batch.  */
        {get serverOperatingMode cOperatingMode}.                     
        IF cOperatingMode = "STATELESS":U AND hRowObject:AVAILABLE THEN 
        DO:                    
          ASSIGN hRowIdent   = hRowObject:BUFFER-FIELD('RowIdent':U)
                 cLastResult = hRowNum:BUFFER-VALUE + ";":U + hRowIdent:BUFFER-VALUE. 
          {set LastResultRow cLastResult}.                                            
        END.  /* If Stateless */
      END.  /* If hRowObject Available */
    END.  /* If Query is open */
  END.  /* If piStartRow = ? or 0 */
 
  /* 9.1B - If this object is in a container with its own AppServer Handle,
     then we run fetchContainedRows in that in order to retrieve this objects
     data together with all child objects data. */

  {get ContainerSource hSource}.
  {get ASDivision cASDivision hSource} NO-ERROR.
  
  IF cASDivision = "Client":U THEN
  DO:
    {get ObjectName cObjectName}.
    /* If we are inside a split SBO let it take care of the connection/data */ 
    RUN fetchContainedRows IN hSource 
        (cObjectName, 
         piStartRow, 
         pcRowIdent, 
         plNext, 
         piRowsToReturn, 
         OUTPUT piRowsReturned).

  END.     /* END DO IF parent is a CLient object. */
  ELSE DO:
    {get ASHandle hAppServer}.         /*   use our own ASHandle. */ 
  
    IF VALID-HANDLE(hAppServer) THEN 
    DO:
    /* New to 9.1B: get the handle of the RowObject table itself to receive
       the temp-table from the server. If this is already defined, then
       either this is a static SDO, or it is a dynamic one which has already
       been initialized by going through this code. If not, then simply
       receive the temp-table into the handle, and set the corresponding
       SDO properties now. */
      
      {get RowObjectTable hRowObjectTbl}. /* get handle to pass to server call */
      lInitRowObject = NOT VALID-HANDLE(hRowObjectTbl).
      RUN serverSendRows IN hAppServer 
          (piStartRow, 
           pcRowIdent, 
           plNext, 
           piRowsToReturn, 
           OUTPUT piRowsReturned, 
           OUTPUT TABLE-HANDLE hRowObjectTbl APPEND).
      
      IF lInitRowObject THEN 
      DO:
        /* New to 9.1B: if the table handle wasn't init'd yet, we set
           its property to the table handle we got back, and create
           the query for it here and set query/buffer properties. */
        {set RowObjectTable hRowObjectTbl}.
        /* Retrieve the updated properties. */
        {get RowObject hRowObject}.
        {get DataHandle hDataQuery}.
      END. /* lInitRowObject */
       
      RUN endClientDataRequest IN TARGET-PROCEDURE.
    END.  /* If valid hAppServer */
    hDataQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
  END. /* not client sbo  */
    
  IF nextPosition = ? AND (piStartRow = ? OR piStartRow = 0) THEN
  DO:               /* This was our first fetch. Position BEFORE the first row. */
    hDataQuery:GET-FIRST().
    hDataQuery:GET-PREV().
  END.

  ELSE IF piRowsReturned > 0 THEN 
  DO:
    /* When piStartRow is > 0 then this (may) have been called from refreshRow 
       and we need to reposition to the same row. We don't know anything but 
       the rownum, because the rowobject is deleted in refreshRow we cannot use
       the old ROWID.  */
    IF piStartRow > 0 THEN 
    DO:
        DEFINE VARIABLE hReposQuery   AS HANDLE     NO-UNDO.
        DEFINE VARIABLE hAltRowObject AS HANDLE     NO-UNDO.
        CREATE QUERY hReposQuery.
        CREATE BUFFER hAltRowObject FOR TABLE hRowObject.
        hReposQuery:SET-BUFFERS(hAltRowObject).
        hReposQuery:QUERY-PREPARE
            ('FOR EACH RowObject WHERE RowObject.RowNum = ':U +
             STRING(piStartRow)).
        hReposQuery:QUERY-OPEN().
        hReposQuery:GET-FIRST().
        nextPosition = hAltRowObject:ROWID.
        hDataQuery:REPOSITION-TO-ROWID(nextPosition) NO-ERROR.
        hReposQuery:QUERY-CLOSE().
        DELETE OBJECT hReposQuery.
        DELETE OBJECT hAltRowObject.
    END.  /* If piStartRow > 0 */
    ELSE DO:
      /* If piRowsToReturn is negative - we are navigating backwards, we need 
         to reposition to the last record in the new batch. */
      IF piRowsToReturn < 0 THEN
          hDataQuery:REPOSITION-TO-ROW(piRowsReturned).
      ELSE DO:
      /* We need to reposition to the last row in the previous batch and
         depending on plNext, we may need to move one additional row forward. */
        hDataQuery:REPOSITION-TO-ROWID(nextPosition).       
        IF plNext THEN 
        DO:
          /* Another akward effect of the fact that reposition of a browse 
             implicit fetches a record is that reposition-forward(1) will go
             to the SECOND record.... */ 
          {get DataQueryBrowsed lBrowsed}.
          hDataQuery:REPOSITION-FORWARD(IF lBrowsed THEN 0 ELSE 1).
        END.
      END.  /* Else do - piRowsToReturn is positive */
    END.  /* Else do - piStartRow = 0 or ? */
  END.  /* If piRowsReturned > 0 */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction Procedure 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     This event procedure receives the Commit "command" from a
               Commit panel or other Commit-Source. It then invokes the Commit
               function to actually commit the changes.  After the commit
               function finishes, commitTransaction handles any error messages 
               by calling showDataMessages.
 
  Parameters:  <none>
 
  Notes:       A transaction block is opened in serverCommit (called by the
               commit function) only if the SDO is running C/S.  That is no
               transaction block occurs occurs on the client side of a split
               SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsgNum        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
  
  /* If they have made record changes they haven't saved, they must
     do that before they Commit. Make this check if it came from the
     Commit Panel, but skip if it came locally or from an SBO. */
  {get CommitSource hSource}.
  IF hSource = SOURCE-PROCEDURE THEN
  DO:
     /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmCommit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN 'ADM-ERROR':U.
  END.    /* END IF hSource  */
  
  /* Continue only if no unsaved changes. */
  lSuccess = {fn Commit}. 
  
  /* IF no errors, signal to Commit Panel to disable itself again. */
  IF lSuccess THEN
    {set RowObjectState 'NoUpdates':U}.
  ELSE DO:
    /* If there were errors, get the Update-Source to deal with them. */
    {get UpdateSource hSource}.
    IF VALID-HANDLE (hSource) THEN      /* sanity check */
      {fn showDataMessages hSource}.
    RETURN "ADM-ERROR":U.               /* Signal error to caller. */
  END.  /* END ELSE DO IF Not lSuccess */
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyColumns Procedure 
PROCEDURE copyColumns :
/*------------------------------------------------------------------------------
  Purpose:     Called from copyRow to move column values to the new row.
  
  Parameters:
    INPUT pcViewColList - Comma delimited list of column names
    INPUT phDataQuery   - Handle to the RowObject query.
  
  Notes:       copyColumns exists primarily to remove code from the function
               copyRow, to reduce the size of the r-code action segment.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcViewColList   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phDataQuery     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cVals      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hCol       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iValue     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cArrayVal  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
 
  hRowObject= phDataQuery:GET-BUFFER-HANDLE(1).
  IF phDataQuery:IS-OPEN THEN  /* Don't copy from RowObject if not used.*/
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    /* Copy arrays a value at a time, into a CHR(1) - delimited list,
       with array elements separated by CHR(2). */
    IF hCol:EXTENT NE 0 THEN DO:
      cArrayVal = "":U.
      DO iValue = 1 TO hCol:EXTENT:
        cArrayVal = cArrayVal +
                    (IF iValue > 1 THEN CHR(2) ELSE "":U) +
                    IF hCol:BUFFER-VALUE(iValue) = ? THEN "":U
                    ELSE hCol:STRING-VALUE[iValue].
      END.   /* END DO iValue */
      cVals = cVals + (IF iCol > 1 THEN CHR(1) ELSE "":U) + cArrayVal.
    END.     /* END DO for EXTENT */
    ELSE cVals = cVals + (IF iCol > 1 THEN CHR(1) ELSE "":U) +
                 IF hCol:BUFFER-VALUE = ? THEN "":U ELSE hCol:STRING-VALUE.
  END.       /* END DO iCol */
  ELSE    /* DO IF NOT IS-OPEN - get current vals from db rec */
    cVals = {fnarg colValues pcViewColList}.
      
  /* Now create the new record */
  hRowObject:BUFFER-CREATE().
  
  /* Move all the copied values into it. */
  IF phDataQuery:IS-OPEN THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    IF hCol:EXTENT NE 0 THEN DO:
      cArrayVal = ENTRY(iCol, cVals, CHR(1)).
      DO iValue = 1 TO hCol:EXTENT:
        hCol:BUFFER-VALUE[iValue] = ENTRY(iValue, cArrayVal, CHR(2)).
      END.   /* END DO iValue */
    END.     /* END DO Extent */
    ELSE hCol:BUFFER-VALUE = ENTRY(iCol, cVals, CHR(1)) NO-ERROR. 
  END.       /* END DO iCol   */
  /* If we're not using the RowObject temp-table for data reads, move values
     by name into the new Copy record. */
  ELSE DO iCol = 1 TO NUM-ENTRIES(pcViewColList):
    hCol = hRowObject:BUFFER-FIELD(ENTRY(iCol, pcViewColList)).
    hCol:BUFFER-VALUE = ENTRY(iCol + 1  /* First entry is RowIdent */ ,
                              cVals, CHR(1)).
  END.        /* END DO iCol IF RowsToBatch is 0 */
  
  /* set RowNum, RowIdent and navigation Properties etc*/  
  {fnarg newRowObject 'Copy':U}.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:  Event procedure that handles change of dataSource data or record 
            position or change of this object's data or record position by 
            assigning new ForeignFields values and reopen the query, resetting 
            QueryPosition and republish the event.   
  Parameters:
    INPUT pcRelative - A flag to indicate something about the "new" or "changed"
                       current record.                                       
      SAME          - Simply RETURN, because the new record is the same as the 
                      current record.                            
      DIFFERENT     - Request to reapply foreign Fields
                      except if called from a dataTarget  
      ?             - Workaround used to apply Foreign Fields when caller not 
                      was dataSource. (Not really needed anymore)        
      VALUE-CHANGED - dataTarget changed position 
      FIRST         - 
      NEXT          -
      PREV          -
      LAST          -
      REPOSITIONED  -
                                        
  Notes: - From 9.1C the dataTarget will pass 'VALUE-CHANGED' to indicate
           a change that don't need to reapply foreign fields. 
           
         - If 'VALUE-CHANGED' or no foreignfields we don't call super and just 
           run updateQueryPosition and republish the event, but make sure that 
           we don't resend 'VALUE-CHANGED', but 'DIFFERENT'. Other events 
           are just passed as is (although we might have just as well sent 
           'DIFFERENT' always).  
              
         - This makes dataAvailable self-contained as there is no longer a 
           need to check who the source is. This was done to add support for 
           SBOs as dataSources.  
           
        -  However, we still check the source to support backwards compatibility,
           but we now deal with potential datatargets passing 'different' and 
           treat this case as 'VALUE-CHANGED'.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataTarget    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitted       AS LOGICAL   NO-UNDO.
    
  {get ObjectInitialized lInitted}.
  /* Ignore if we haven't been initialized yet; also, 
     if for some reason this object is in addmode.
    (Called from cancelRow in the first of two SDOs in SBOs for example) 
     updated row (pcRelative = 'SAME') requires no reset.*/
  IF (NOT lInitted) OR (pcRelative = "SAME":U) THEN RETURN.  
  
  /* For backwards Compatibility we still deal with 'different' calls 
     from DataTargets as a request to NOT reapply ForeignFields. */
  IF pcRelative = 'DIFFERENT':U THEN 
  DO:
    {get DataTarget cDataTarget}.
    IF CAN-DO(cDataTarget,STRING(SOURCE-PROCEDURE)) THEN
       pcRelative = 'VALUE-CHANGED':U.
  END.
  ELSE IF pcRelative = ? THEN
    pcRelative = 'DIFFERENT':U. 
  
  {get ForeignFields cForeignFields}.

  IF cForeignFields <> '':U AND pcRelative <> 'VALUE-CHANGED':U THEN 
    RUN SUPER(pcRelative).
      
  ELSE DO:
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* 'Value-changed' from a data target has told us not to reapply Foreign 
      Fields, but we need to pass this as 'DIFFERENT' to our targets.
      (We could probably always have passed 'DIFFERENT') */  
    IF pcRelative = 'VALUE-CHANGED':U  THEN pcRelative = 'DIFFERENT':U. 
        
    PUBLISH 'DataAvailable':U FROM TARGET-PROCEDURE(pcRelative).
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyServerObject Procedure 
PROCEDURE destroyServerObject :
/*------------------------------------------------------------------------------
  Purpose:  Destroy the server object and retrieve its context.    
  Parameters:  <none>
  Notes:     Called from unbindServer when stateless.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lASBound  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hASHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext  AS CHARACTER  NO-UNDO.

  {get ASBound lASBound}.
  
  IF lASBound THEN
  DO:
    {get ASHandle hASHandle}.
     RUN saveContextAndDestroy IN hASHandle (OUTPUT cContext).
     RUN setPropertyList IN TARGET-PROCEDURE (cContext).
    /* getAsHandle checks valid-handle, but handles are resused so make sure
       that valid-handle returns false */
    {set AsHandle ?}. 
  END. /* if ASBound */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endClientDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endClientDataRequest Procedure 
PROCEDURE endClientDataRequest :
/*------------------------------------------------------------------------------
  Purpose: Contains logic to retrieve data properties from the Appserver 
           after a data request. Both queries and commit is considered as data 
           requests.        
    Notes: The purpose of this function is to encapsulate the logic for 
           stateless and state-aware requests in one call.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAsDivision       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatingMode    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAsHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cContext          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  
  {get AsDivision cAsDivision}.

  /* Get out if not 'client' */
  IF cAsDivision <> 'Client':U THEN 
    RETURN.
  
  {get ServerOperatingMode cOperatingMode}.
  
  IF cOperatingMode = 'stateless':U THEN  
    /* We must pass the caller to unbindServer to ensure proper unbinding. */ 
    RUN unbindServer IN TARGET-PROCEDURE(PROGRAM-NAME(2)).
  
  /* Check if we still are bound. */ 
  {get AsBound lAsBound}.
  
  /* If we are state-aware or the unbind did not yet unbind, we need these 
     properties immediately after a data request. */ 
  IF lAsBound THEN 
  DO:
    {get ASHandle hASHandle}.
    RUN genContextList IN hASHandle (OUTPUT cContext).
    RUN setPropertyList IN TARGET-PROCEDURE (cContext).
  END. /* if ASBound */ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     To transfer another "batch" of rows from the database query to 
               the RowObject Temp-Table query, without changing the current 
               record position.
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after the current rows,
                       FALSE if before.
  Notes:       Run from a Browser to get another batch of rows from the database
               query appended to the RowObject temp-table query (when the 
               browser scrolls to the end).
               fetchBatch does some checking and sets up the proper parameters
               to sendRows, but sendRows is called to do the actual work.  
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plForwards  AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRow      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPosition     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rCurrentRow   AS ROWID     NO-UNDO.

  {get RowObjectState cRowState}.   
  IF cRowState = 'RowUpdated':U THEN DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
     RETURN.
  END.
  
  /* The setting of queryPosition is most likely complete paranoia, so if 
     they ever cause an irritation of any sort, just get rid of them .. */

  {get LastRowNum iLastRow}.
  IF iLastRow NE ? AND plForwards THEN 
  DO:
    {get QueryPosition cPosition}.  /* IF not already set, set it.*/
    IF cPosition NE 'LastRecord':U THEN
      {set QueryPosition 'LastRecord':U}.      
    RETURN.      /* We're already at the end of the db query. */
  END.     /* END DO IF iLastRow */
  
  {get FirstRowNum iFirstRow}.
  IF iFirstRow NE ? AND NOT plForwards THEN 
  DO:
     {get QueryPosition cPosition}.  /* IF not already set, set it.*/
     IF cPosition NE 'FirstRecord':U THEN
       {set QueryPosition 'FirstRecord':U}.      
     RETURN.      /* We're already at the end of the db query. */
  END.     /* END DO IF iLastRow */


  {get DataHandle hDataQuery}.
  IF NOT hDataQuery:IS-OPEN           /* sanity check. */
    THEN RETURN.
   
  {get RowsToBatch iRowsToBatch}.
  RUN sendRows IN TARGET-PROCEDURE 
      (?, /* Don't repos., just get more rows. */
       ?,  /* no RowIdent specified to repos to */
       true,   /* Do a Next before getting more rows */
         /* Signal whether to move forward or back */
       IF plForwards THEN iRowsToBatch ELSE - iRowsToBatch, 
       OUTPUT iRowsReturned).
      
  IF iRowsReturned NE 0 THEN   
    PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iRowsReturned).
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject temp-table to the first record, or
               to the row matching the QueryRowIdent property (if it has been
               set.)  If the first record has not been fetched (from the db) 
               yet, then calls sendRows to get the first batch of RowObject 
               records of the SDO and then reposition the RowObject Temp-Table
               to the first row.
 
  Parameters:  <none>
------------------------------ ------------------------------------------------*/
  DEFINE VARIABLE iReturnRows   AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lRowIdent     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iFirstRow     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryCont    AS LOGICAL   NO-UNDO.
  
     /* If we're the server side of a divided DataObject, just return and
       wait for the client to invoke sendRows itself, unless (9.1B)
       we're inside an SBO (QueryContainer), in which case we go ahead and 
       fill the table. */
    {get ASDivision cASDivision}.
    
    IF cASDivision = 'Server':U THEN
    DO:
      {get QueryContainer lQueryCont} NO-ERROR.
      IF NOT (lQueryCont EQ YES) THEN
        RETURN.
    END.     /* END DO IF Server */

    {get DataHandle hDataQuery}.
    {get RowObject hRowObject}.
    {get FirstRowNum iRowNum}.
    
    IF iRowNum = ? THEN       /* First row hasn't been retrieved yet. */      
    DO:
      {get RowsToBatch iRowsToBatch}.
      /* If there are already rows in the temp-table, then
         the query has already been opened and repositioned. In that case,
         pass the special value of "First" to sendRows to get it to flush
         the temp-table and restart from the beginning. Otherwise if
         QueryRowIdent is set, then start at that row. Otherwise just
         start at the beginning. */
      IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN 
      DO: /* First time through. */
        {get QueryRowIdent cRowIdent}.     /* See if there's a special start row.*/
        IF cRowIdent NE ? AND cRowIdent NE "":U THEN 
        DO:
          lRowIdent = yes.
          {set QueryRowIdent ?}.          /* Reset once we have the value. */
        END.   /* END DO IF cRowIdent has a valid value */
      END.   /* END DO IF there is no RowObject available */
      ELSE cRowIdent = "First":U.  /* Else signal restart at beginning. */
      
      RUN sendRows IN TARGET-PROCEDURE 
        (?                  /* Start at the first row if RowIdent is not set */, 
         cRowIdent          /* or use this RowIdent key if its set. */,
         FALSE              /* Don't next initially (unless skipRowident)  */, 
         iRowsToBatch       /* how many rows to retrieve */, 
         OUTPUT iReturnRows /* how many rows were actually returned */ ).
      /* New to 9.1B: If the temp-table is dynamic and wasn't already 
         initialized, the handle variables set above will be unknown,
         so reset them here -- clientSendRows has set the properties for them.*/
      IF NOT VALID-HANDLE(hDataQuery) THEN
      DO:
        {get DataHandle hDataQuery}.
        {get RowObject hRowObject}.
      END.
  
      IF NOT hDataQuery:IS-OPEN THEN
        hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
      IF iReturnRows NE 0 THEN 
      DO:
        IF iReturnRows < iRowsToBatch THEN 
        DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set LastRowNum 
             as well as First. */
          hDataQuery:GET-LAST().
          {set LastRowNum hColumn:BUFFER-VALUE}.
        END.   /* END DO IF < iRowsToBatch */
        
        hDataQuery:GET-FIRST().
        
        IF NOT lRowIdent THEN /* If there was no QueryRowIdent prop then we */
          {set FirstRowNum hColumn:BUFFER-VALUE}.
      END.     /* END DO IF iReturnRows NE 0 */
      ELSE DO:
        {get RebuildOnRepos lRebuild}.      
        IF lRebuild THEN DO:
           /* See if fetch failed due to an update in progress */
          {get FirstRowNum iFirstRow}.
          {get RowObjectState cRowState}.
          IF cRowState = 'RowUpdated':U AND iFirstRow eq ?
          THEN DO:
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
            {set FirstRowNum ?}.
            RETURN.
          END.   /* If in a commit */
        END.  /* Rebuild On Reposition is set */
        hRowObject:BUFFER-RELEASE().
      END. /* END ELSE DO IF no rows returned */
    END.   /* END IF iRowNum = ? */
    ELSE hDataQuery:GET-FIRST().
 
    /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* Send dataAvail whether's a record or not; if not, the recipients
       will close queries or clear frames. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("FIRST":U).     
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the last row of the dataset.
               If the last row has not yet been retrieved from the DB, then
               fetchLast gets the last batch of RowObject records for the SDO 
               and then repositions the RowObject query to the last row.
  
  Parameters:  <none>

  Notes:       IF the SDO property RebuildOnReposition is false and the last row
               from the db query has not been fetch yet, fetchLast keeps asking
               for batches of rows till the last batch is recieved. This is 
               required, because otherwise there would be a discontinuous set of
               rows in the RowObject temp-table, and also, the RowNum of the last
               record, which is the key value, can be known by the db query only
               by walking all the way to the end.
               If RebuildOnReposition is true and the last row from the db query
               has not been fetch yet, all RowObject records are discarded and
               just the last batch is fetched. In this case the RowNum of the
               last row becomes 2000000 and all other records have smaller numbers
               (except for additions.)
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  
    {get DataHandle hDataQuery}.
    {get RowObject hRowObject}.
     hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
             
    {get LastRowNum iLastRow}.
    
    IF iLastRow = ? THEN        /* Last row not been retrieved yet.*/
    DO:
      RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
      {get RowsToBatch iRowsToBatch}.
      {get RebuildOnRepos lRebuild}.
      
      IF lRebuild THEN   /* Jump direct to Last and rebuilt temp-table */
        RUN sendRows IN TARGET-PROCEDURE 
          (?,            /* No particular rownum to start at */
           'Last':U,     /* special value for pcRowIdent */
           FALSE,        /* No need to "next" after repositioning */
           iRowsToBatch, /* sendRows knows to go backwards from Last */
           OUTPUT iRowsReturned).
      ELSE DO:           /* No Rebuild on Reposition */
        /* Keep asking for rows until we get fewer than we asked for. */
        iRowsReturned = iRowsToBatch.
        /* Set the cursor first in case this takes a while. */
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE 
            ('LastStart':U).
        DO WHILE iRowsReturned = iRowsToBatch:
          RUN sendRows IN TARGET-PROCEDURE 
            (?, ?, TRUE, iRowsToBatch, OUTPUT iRowsReturned).
        END.
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastEnd':U).   
      END.    /* END ELSE DO IF NOT lRebuild */
      
      IF NOT hDataQuery:IS-OPEN THEN
        hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      IF iRowsReturned = 0 THEN
      DO:
        /* See if fetch failed due to an update in progress */
        {get LastRowNum iLastRow}.
        {get RowObjectState cRowState}.
        IF cRowState = 'RowUpdated':U AND iLastRow eq ? THEN 
        DO:
          DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
          {set LastRowNum ?}.
          RETURN.
        END.   /* If in a commit */
      END.  /* iRowsReturned = 0 */
      
      RUN changeCursor IN TARGET-PROCEDURE('':U).
    END.
    
    hDataQuery:GET-LAST().
     
    IF hRowObject:AVAILABLE THEN
    DO:
      hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).
      {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
      {set LastRowNum hRowNum:BUFFER-VALUE}.
    END.
    
     /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    RUN updateQueryPosition IN TARGET-PROCEDURE.

    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("LAST":U).
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the next row.  If a new 
               batch is required to do so, then sendRows is called to get the
               new batch.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRowNum      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLastDbRowId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER  NO-UNDO.
  DEFINE VARIABLE rCurrentRow  AS ROWID    NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG       NO-UNDO.
  DEFINE VARIABLE lFirstDeleted AS LOGICAL  NO-UNDO.
    
    {get DataHandle hDataQuery}.
    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
           hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).

    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get LastRowNum iRow}.
      {get LastDbRowIdent cLastDbRowId}. 

      /* Already on the last row. */
      IF iRow          =  hRowNum:BUFFER-VALUE 
      OR (cLastDbRowid <> "":U AND cLastDbRowId = hRowIdent:BUFFER-VALUE) THEN 
        RETURN.
    END. /* if hRowObject:available */
    ELSE DO:  /* if no record is avail, but queryposition is first we 
                 must have deleted it */ 
      {get QueryPosition cQueryPos}.
      /* This seems to be  handled in updateQueryPos ..
      IF cQueryPos = 'LastRecord':U THEN
         lLastDeleted = TRUE. */  
      IF cQueryPos = 'FirstRecord':U THEN
         lFirstDeleted = TRUE.
    END.
    
    hDataQuery:GET-NEXT().
    
    IF NOT hRowObject:AVAILABLE THEN
    DO:                                 /* No data so ask the Query. */
      {get RowsToBatch iRowsToBatch}.
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextStart':U).
      
      RUN sendRows IN TARGET-PROCEDURE
        (?, /* sendRows will know what row to start at */
         ?, /* No pcRowIdent */
         TRUE /* start with next row */, 
         iRowsToBatch, 
         OUTPUT iReturnRows).
      
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
      IF iReturnRows NE 0 THEN
      DO:
        PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iReturnRows).
        IF iReturnRows < iRowsToBatch THEN
        DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set LastRowNum. 
             First save off the current position so we can get back to it. 
             Don't next if available (reposition with browse) */
          IF NOT hRowObject:AVAILABLE THEN 
            hDataQuery:GET-NEXT().  
          
          rCurrentRow = hRowObject:ROWID.  /* save its ROWID to repos to. */
          hDataQuery:GET-LAST().
          {set LastRowNum hRowNum:BUFFER-VALUE}.
          {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
          hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
        END.   /* END DO IF < iRowsToBatch */
        /* Set ReposAvail flag if avail after reposition above or in sendRows
           (will be avail if we browse) so we can pass right parameter to the
           browser when we publish dataAvailable further down */  
        lReposAvail = hRowObject:AVAILABLE. 
        IF NOT lReposAvail THEN 
          hDataQuery:GET-NEXT().           
      END.     /* END DO IF ReturnRows NE 0 */
      ELSE DO:
        hDataQuery:GET-PREV(). /* get-last messes up the browse and get-prev is
                                  the same */
        {get LastRowNum iLastRow}.
        
        /* See if fetch failed due to an update in progress */
        {get RowObjectState cRowState}.
        
        /* Don't return, but publish dataavailable further down */
        IF cRowState = 'RowUpdated':U AND iLastRow eq ? THEN 
          DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
        
        ELSE IF NOT hRowObject:AVAILABLE THEN
        DO:
          {set LastRowNum ?}.
          RUN fetchLast IN TARGET-PROCEDURE.         
        END. /* if not hRowObject:available */
        ELSE DO:
          iRowNum = hRowNum:BUFFER-VALUE.
          {set LastRowNum iRowNum}.
          {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
        END.  /* If there is a last record */
      END.     /* END ELSE DO IF ReturnRows = 0 */
    END.       /* END DO IF no next record AVAILABLE  */
    
    IF lFirstDeleted AND hROwObject:AVAILABLE THEN  
    DO:
      iRowNum = hRowNum:BUFFER-VALUE NO-ERROR.
      {set FirstRowNum iRowNum}.
    END.

    /* Set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPOSITIONED' to make sure dataAvailable doesn't select-next- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "NEXT":U). 
    
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the previous row.  If a new
               batch is needed to do so, then sendRows is called to get the new
               batch.  (Getting a new batch will only be necessary when the 
               RebuildOnReposition property is set to true.)
 
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE rCurrentRow  AS ROWID    NO-UNDO.
  DEFINE VARIABLE lRebuild     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG    NO-UNDO.
   
    {get DataHandle hDataQuery}.

    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
        
    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get FirstRowNum iRow}.
      IF iRow = hRowNum:BUFFER-VALUE THEN 
        RETURN.
    END.
    
    hDataQuery:GET-PREV().
    
    IF NOT hRowObject:AVAILABLE THEN
    DO:                        
      /* If we are rebuilding the query from the end or some middle point,
         then we have to check to see if there are more rows in the dataset.*/      
      {get RebuildOnRepos lRebuild}.

      IF lRebuild THEN
      DO:
        {get RowsToBatch iRowsToBatch}.
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
        RUN sendRows IN TARGET-PROCEDURE
         (?, /* sendRows will know what row to start at */
          ?, /* No pcRowIdent */
          TRUE, /* start with previous row */
          - iRowsToBatch, /* Negative rows means move backwards */
          OUTPUT iReturnRows).

        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).
        
        IF iReturnRows NE 0 THEN
        DO:
          PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iReturnRows).
          IF iReturnRows < iRowsToBatch THEN
          DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set FirstRowNum. 
             First save off the current position so we can get back to it.
           (if the REPOSITION in sendRows made it available it's browsed so
            don't get-next) */
            IF NOT hRowObject:AVAILABLE THEN
              hDataQuery:GET-NEXT().         
            rCurrentRow = hRowObject:ROWID.  /* save its ROWID to repos to. */
            hDataQuery:GET-FIRST().
            {set FirstRowNum hRowNum:BUFFER-VALUE}.
            hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
          END.   /* END DO IF < iRowsToBatch */
          /* Set ReposAvail flag if avail after reposition above or in sendRows
             (will be avail if we browse) so we can pass right parameter to the
             browser when we publish dataAvailable further down */  
          lReposAvail = hRowObject:AVAILABLE.

          /* Reposition to the record we were on before this was called and 
             then get the now previous record */
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
          
          IF NOT lReposAvail THEN /* get the row that we have repositioned to */
            hDataQuery:GET-NEXT(). 
          
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).
        END.     /* END DO IF ReturnRows NE 0 */
      END. /* if lRebuild */

      /* ReturnsRow = 0 indicates either 
         NOT RebuildOnRepos OR RebuildonRepos, but no more records */
      IF iReturnRows = 0 THEN
      DO:
        hDataQuery:GET-FIRST().        
         
        /* See if fetch failed due to an update in progress */ 
        IF lRebuild THEN
        DO:
          {get FirstRowNum iRow}. 
          {get RowObjectState cRowState}.
          IF cRowState = 'RowUpdated':U AND iRow eq ? THEN 
          DO:
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
            {set FirstRowNum ?}.
            RETURN.
          END. /* If in a commit */
        END. /* lRebuild */
        
        IF hRowObject:AVAIL THEN
          {set FirstRowNum hRowNum:BUFFER-VALUE}.
        ELSE 
          {set FirstRowNum ?}.

      END. /* IF ReturnRows = 0 */
    END. /* IF not hRowObject:available */
    
    /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
   
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPSOTIONED' to make sure dataAvailable doesn't select-prev- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "PREV":U). 
           
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genContextList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genContextList Procedure 
PROCEDURE genContextList :
/*------------------------------------------------------------------------------
  Purpose:     To generate a list of properties and their values needed to save
               (and restore) the context of a stateless SDO between invocations. 
   
  Parameters:
    OUTPUT pcContext - The context string to be returned. pcContext is a CHR(3) 
                       delimited list of propertyCHR(4)Value pairs.
 
  Notes:       Currently there are only 5 properties needed to restore the
               context: CheckCurrentChanged, RowObjectState, FirstResultRow,
               LastResultRow and QueryRowIdent.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext     AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lCheckCurrentChanged  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cRowObjectState       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFirstResultRow       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cLastResultRow        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQueryRowIdent        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cLastRowNum           AS CHARACTER   NO-UNDO.

  {get CheckCurrentChanged lCheckCurrentChanged}.
  {get RowObjectState cRowObjectState}.
  {get FirstResultRow cFirstResultRow}.
  {get LastResultRow cLastResultRow}.
  {get QueryRowIdent cQueryRowIdent}.
  {get LastRowNum iLastRowNum}. 

  /* Rebuild the context string to look like:
     prop1 CHR(4) val1 CHR(3) prop2 CHR(4) val2 CHR(3) ...                  */
          
  ASSIGN pcContext =
       "CheckCurrentChanged":U + CHR(4) +
            (IF lCheckCurrentChanged THEN "Yes":U ELSE "No":U)     + CHR(3) +
        "RowObjectState":U + CHR(4) + 
            (IF cRowObjectState = ? THEN "?":U ELSE cRowObjectState) + CHR(3) +
        "FirstResultRow":U + CHR(4) + 
            (IF cFirstResultRow = ? THEN "?":U ELSE cFirstResultRow) + CHR(3) +
        "LastResultRow":U + CHR(4) + 
            (IF cLastResultRow = ? THEN "?":U ELSE cLastResultRow)   + CHR(3) +
        "LastRowNum":U + CHR(4) + 
            (IF iLastRowNum = ? THEN "?":U ELSE STRING(iLastRowNum))   + CHR(3) +
        "QueryRowIdent":U + CHR(4) + 
            (IF cQueryRowIdent = ? THEN "?":U ELSE cQueryRowIdent).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     To performs SmartDataObject-specific initialization. Specifically,
               to start the server-side copy of this object if the AppService
               (partition) is defined.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSvrFileName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQuerySource   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataSource    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iProp          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPropName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSignature     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProp          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cDynamicSDO     AS CHARACTER NO-UNDO.

  /* If the object has a Partition named, then connect to it. */
  /* Skip all this if we're in design mode. */
  {get UIBMode cUIBMode}.
  IF cUIBMode = "":U THEN
  DO:
    /* If this object's Container is itself a QueryObject, set a prop
       to indicate that; this tells us if we're in an SBO. */
    {get ContainerSource hContainer}.
    IF VALID-HANDLE (hContainer) THEN
      {get QueryObject lQueryContainer hContainer} NO-ERROR.
    
    IF lQueryContainer = YES THEN
      {set QueryContainer YES}.   /* by default it's NO */
   
    /* The sbo subscribes to this event in order to update ObjectMapping
       (This is needed in the case the dataSource is an SBO)*/
    PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.
    
    {get AppService cAppService}.
    IF cAppService NE "":U THEN
    DO:
      RUN startServerObject IN TARGET-PROCEDURE NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
         RETURN "ADM-ERROR":U.
    END.  /* IF AppService NE "":U */
    ELSE
    DO:
      /* If no AppService defined, check if the user is running the client
         proxy, or the dynamic SDO. If so, there can't be any required databases 
         connected for the object to show data. Probably an AppServer setup 
         problem. If there's no container handle, then we are running on
         the AppServer, so there's nothing to check. */
      IF VALID-HANDLE(hContainer) THEN
      DO:
           /* This new property in 9.1B holds the file name to run on the
              AppServer. If it's a dynamic SDO, the file name being run won't
              be usable (it will be dyndata). */
          {get ServerFileName cSvrFileName}.
          {get DynamicSDOProcedure cDynamicSDO hContainer} NO-ERROR.
          cDynamicSDO = ENTRY(1, cDynamicSDO, ".":U).  /* Remove .r or .w */
          IF (TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.*':U OR
              TARGET-PROCEDURE:FILE-NAME MATCHES '*':U + cDynamicSDO + '.*':U) AND
              NOT lQueryContainer THEN  /* DOn't complain if inside an SBO - 9.1B */
          DO:
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, cSvrFileName + 
            " SmartDataObject has no AppServer partition defined and is ":U +
            "running locally without proper database connection(s).":U).
            RETURN "ADM-ERROR":U.
          END.    /* END DO IF running the wrong object -- showMessage */
      END.      /* END DO IF hContainer defined -- not on AppServer. */
    END.          /* ELSE DO IF AppService EQ "":U */
    
    /* If this SDO is just being used to update a SDBrowser with its own
       database query, then turn its QueryObject property off and don't
       have the query opened. */
    /* In case our Update-Source is an object such as a SDViewer, we
       may have to ask whether it in turn has a Data-Source. If that
       is the case and it is not the current object, also suppress
       opening the query. */
    cQuerySource = dynamic-function('linkProperty':U IN TARGET-PROCEDURE, 
      'Update-Source':U, 'QueryObject':U).
    IF cQuerySource NE "Yes":U THEN
      /* Does the Update-Source have a Data-Source that isn't us? */
      cDataSource = DYNAMIC-FUNCTION('linkProperty':U IN TARGET-PROCEDURE, 
        'Update-Source':U, 'DataSource':U).
    IF cQuerySource = "Yes":U OR 
       (VALID-HANDLE(WIDGET-HANDLE(cDataSource)) AND
        WIDGET-HANDLE(cDataSource) NE TARGET-PROCEDURE) THEN
    DO:
      cQuerySource = "Yes":U.  /* Set positively for check below. */
      {set QueryObject no}.
      {set OpenOnInit no}.
    END.   /* END DO IF QuerySource */
    
    /* If this object has a Commit-Source (a Commit Panel or the like) then
       we set the AutoCommit flag off. If this object is just being used
       to update another QueryObject, then this is an error. */
    {get CommitSource hSource}.
    IF hSource NE ? THEN
    DO:
      IF cQuerySource = "Yes":U THEN
      DO:
         DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,
           "Commit Source may not be used in this configuration.":U).
         RETURN "ADM-ERROR":U.
      END.   /* END DO IF QuerySource */
      ELSE {set AutoCommit no}.
    END.     /* END DO IF hSource */
  END.       /* END IF not UIBMode   */
   
  RUN SUPER.     /* NOTE: This should really happen first; check later. */

  RUN unbindServer IN TARGET-PROCEDURE('unconditional':U).

  IF RETURN-VALUE = "ADM-ERROR":U THEN
     RETURN "ADM-ERROR":U.

  ELSE RETURN.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject Procedure 
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
  Purpose: Intialize and set context in the serverObject after it has been 
           started or restarted    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lASBound             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lASHasStarted        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hASHandle            AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE lCheck               AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE cServerState         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryWhere          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cPropertiesForClient AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertiesForServer AS CHARACTER  NO-UNDO.

  /* This is to be called from runServerObject during start or restart, so
     if we are not bound we just return  */ 
  {get ASBound lASBound}.
  
  IF NOT lASBound THEN
    RETURN. 
  
  {get ASHandle hASHandle}.

  {get ASHasStarted lASHasStarted}.
  
  IF NOT lASHasStarted THEN
  DO:
    /* We don't run Initialize on the server object from the client anymore 
      (9.1B05) This has been moved to synchronizeProperties instead to reduce 
      the number of AppServer calls  
      RUN initializeObject IN hAppServer. */ 
         
    /* Set the CheckCurrentChanged property on the server and get back the 
       AppServer Operating mode  */
     {get CheckCurrentChanged lCheck}.
     {get ServerOperatingMode cServerState}.
      cPropertiesForServer = 
         /* If ObjectInitialized is the FIRST ENTRY, synchronizeProperties 
            will return the properties we need to retrieve at start up.
            We may come up with something better later...  */
           "ObjectInitialized":U  + CHR(4) + "No":U
           + CHR(3) +
           "CheckCurrentChanged":U + CHR(4) + STRING(lCheck).          
                
      RUN synchronizeProperties IN hASHandle  (INPUT  cPropertiesForServer,
                                               OUTPUT cPropertiesForClient).  
      RUN setPropertyList IN TARGET-PROCEDURE (cPropertiesForClient).
      /* Override the actual state if the instance property is force stateful */
      IF cServerState = "STATE-RESET":U THEN
        {set ServerOperatingMode cServerState}. 
  END. /* First call, if not lASHasStarted */
  ELSE DO:
    RUN genContextList IN TARGET-PROCEDURE (OUTPUT cPropertiesForServer).
    
    /* Set QueryWhere on the server to reset context (includes BY phrases)
       First check if it has been changed BY assignQuerySelection or 
       addQueryWhere */
    {get QueryString cQueryWhere}.
    IF cQueryWhere = '':U THEN
       {get QueryWhere cQueryWhere}.
    
    ELSE  /* This is hereby the context and can be used by openQuery to
             avoid sending QueryString in an extra call */  
      {set QueryContext cQueryWhere}. 
   
    IF cQuerywhere <> ? THEN
       cPropertiesForServer = (IF cPropertiesForServer  <> ? 
                               AND cPropertiesForServer <> "":U 
                               THEN cPropertiesForServer + CHR(3)
                               ELSE "":U) 
                            + "QueryWhere":U + CHR(4) + cQueryWhere.
     
    RUN synchronizeProperties IN hASHandle  (INPUT  cPropertiesForServer,
                                             OUTPUT cPropertiesForClient).

  END. /* else ( hASHasStarted ) */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:  Published through data-targets to check if any updates are pending.   
  Parameters: input-output plUpdate 
              Returns TRUE and stops the publishing if update is pending. 
  Notes:      New is included as a pending update. 
              Called from canNavigate, which is used by navigating objects to 
              check if they can trust an updateState('updatecomplete') message
          NB! This check is only valid from a DataSource point of view. 
              Use canNavigate to check an actual object.  
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL    NO-UNDO.
   
   DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lDataModified   AS LOGICAL    NO-UNDO.
   
   /* No need to check a pending update was found somewhere else */
   IF NOT plUpdate THEN
   DO:
     {get RowObjectState cRowObjectState}.
     {get DataModified lDataModified}.
     /* We can use NewRow and not newMode, as RowObjectstate 'RowUpdated' also 
        is included.  */
     {get NewRow lNew}.

     plUpdate = (cRowObjectState = 'RowUpdated':U) 
                 OR (lNew = TRUE) /* unknown is no (NewRow is sometimes ?) */
                 OR (lDataModified = TRUE). 
   
     IF NOT plUpdate THEN 
       PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plUpdate).
   END. /* not plUpdate */
   RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshRow Procedure 
PROCEDURE refreshRow :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve the current database values for a row already
               in the RowObject table.

  Parameters:  <none>
  
  Notes:       PUBLISHes dataAvailable ('SAME') to cause a SDViewer or
               Browser to display the latest values. Since the database 
               records are never locked on read, this procedure can fetch the
               latest values but cannot guarantee that they will not change
               before an update is done.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRows           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lNewRow         AS LOG       NO-UNDO.

  {get RowObjectState cRowState}.
  IF cRowState = 'RowUpdated':U THEN DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "24":U).
     RETURN.
  END.  /* if cRowState = rowupdated */
  
  /* Nothing to refresh ..  */
  {get NewRow lNewRow}.    
  IF lNewRow THEN 
     RETURN.
  
  {get DataHandle hDataQuery}.
  {get RowObject  hRowObject}.
  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN.

  /* Save off the current RowIdent to pass to sendRows. It will re-retrieve
     that row from the database. */
  ASSIGN hField    = hRowObject:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hField:BUFFER-VALUE
         hField    = hRowObject:BUFFER-FIELD('RowNum':U)
         iRowNum   = hField:BUFFER-VALUE.
  
  hRowObject:BUFFER-DELETE().      /* remove the old copy of the row. */
  /* This special calling sequence tells sendRows to retrieve a new copy
     of the record pointed to by cRowIdent, give it the number iRowNum,
     and add it to the existing RowObject table. */
  
  RUN sendRows IN TARGET-PROCEDURE
                (iRowNum, 
                 cRowIdent, 
                 false /* no Next */, 
                 1 /* Get just 1 row */, 
                 OUTPUT iRows).  
  /* sendRows has re-opened the query and repositioned to the newly
     retrieved row; so if the row is not available we do a Next to 
     move onto the row itself. We check whether the record is available
     in order NOT to do this on a browser, which of course fetches the record
     when the query is repositioned.  */  
  IF NOT hRowObject:AVAILABLE THEN
     hDataQuery:GET-NEXT().          
  
  /* Tell everyone we have a new copy of the same row. */
  PUBLISH 'dataAvailable' FROM TARGET-PROCEDURE ('SAME':U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next.  restartServerObject is run on the client to restart
              the SmartDataObject on the server.
 
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/   
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
  /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:     To pass on the flag which indicates when a SmartDataObject row 
               has been changed locally but not committed. This gets passed on 
               until it reaches the Commit Panel or other first Commit-Source.
 
  Parameters:
    INPUT pcState - the new state
  
  Notes:       This SmartDataObject version doesn't do anything itself with 
               the state setting, but simply passes it on up the chain 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
   
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveContextAndDestroy Procedure 
PROCEDURE saveContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:     To save the context of the server-side SDO and then destroy it.
    
  Parameters:  
    OUTPUT pcContext - The context string to be returned
 
  Notes:       saveContextAndDestroy is invoked from the client side of the
               SmartDataObject and executed on the server side.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext     AS CHARACTER                   NO-UNDO.
  
  RUN genContextList IN TARGET-PROCEDURE (OUTPUT pcContext).
  RUN destroyObject IN TARGET-PROCEDURE.  /* Disc. from AppServer if present. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendRows Procedure 
PROCEDURE sendRows :
/*-----------------------------------------------------------------------------
Purpose:     To fetch the requested number of rows (views) from the DB Query
             and to create corresponding records in the Row Object Temp-Table.
             The batch will typically start at row indicated by the pcRowIdent
             parameter, but may start on the row indicated by the piStartRow
             parameter.
Parameters:
   INPUT piStartRow      - RowNum to start on. (? indicates that pcRowIdent
                           will determine the start of the batcvh to be 
                           returned.) 
   INPUT pcRowIdent      - An alternative to StartRow. pcRowIdent is either
                           "FIRST", "LAST" or a comma delimited list of DB
                           ROWIDs.  If it is "FIRST" (or "LAST") then the 
                           first (or last) batch of records in the data set
                           are retrieved and piStartRow is forced to ?. If
                           pcRowIdent is a comma delimited list of DB ROWIDs
                           then the batch will start with a RowObject
                           comprised of those records.
   INPUT plNext          - TRUE if query should perform NEXT/PREV (depending
                           on the direction of navigation) before starting
                           to return more rows.  In otherwords, "SKIP" to 
                           the next record at the start of the batch. 
   INPUT piRowsToReturn  - Maximum number of rows to be returned (negative
                           to move backwards in the result set)
                           0 to retrieve ALL rows in the dataset (forward) .
   OUTPUT piRowsReturned - Actual number of rows returned.
    
  Notes:       Before returning, sendRows repositions the RowObject query to
               what was the current row when it started. The pcRowIdent
               argument is used by fetchRowIdent to allow query repositioning
               to a specific db query row.
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO INIT 0.
 
 DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hBuffer        AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hFirstBuffer   AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hFldRowIdent   AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hAppServer     AS HANDLE  NO-UNDO.
 DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE rRowIDs        AS ROWID   EXTENT 10 NO-UNDO.
 DEFINE VARIABLE lOK            AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE iCnt           AS INTEGER   NO-UNDO.
 DEFINE VARIABLE rCurrentRow    AS ROWID     NO-UNDO.
 DEFINE VARIABLE cStartRow      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFirstRow      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cLastRow       AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cStartRowIds   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cCurrentRow    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cRowIdent      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iRowNum        AS INTEGER   NO-UNDO.
 DEFINE VARIABLE lNexting       AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE hRowNum        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE lRefresh       AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lOffEnd        AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE iLastRowNum    AS INTEGER   NO-UNDO INIT ?.
 DEFINE VARIABLE iFirstRowNum   AS INTEGER   NO-UNDO INIT ?.
 DEFINE VARIABLE cLastDbRowident AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFetchOnOpen    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lRebuild       AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE lOpened        AS LOGICAL     NO-UNDO.
  
  /* The RowObjectState property signals whether there are uncommitted
     changes. If so, we cannot get more rows from the database until
     changes are committed. */
  {get RowObjectState cStartRow}.
  
  IF cStartRow = 'RowUpdated':U THEN
    RETURN.

  /* Filter out invalid input parameters */
  IF piStartRow     = 0 THEN piStartRow = ?.
  /* unknown or 0 means get all, the code below checks for the 0  */
  IF piRowsToReturn = ? THEN piRowsToReturn = 0. 
  
  IF LOOKUP(pcRowIdent,"FIRST,LAST":U) > 0 THEN
    ASSIGN piStartRow = ?
           plNext     = no.

  {get ASDivision cASDivision}.
  {get RowObject hRowObject}.
  /* Find out whether we're running with a query on an AppServer.
     If so then run a special client-to-server version of sendRows. 
     Or, if we are *on* the server, being run from serverSendRows,
     skip any references to the RowObject query. */
  IF cASDivision = 'Client':U THEN
  DO:
    {get ServerOperatingMode cOperatingMode}.
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
    
    IF LOOKUP(pcRowIdent,"FIRST,LAST":U) > 0 THEN 
    DO:
      hRowObject:EMPTY-TEMP-TABLE().
      {set FirstRowNum ?}.
      {set LastRowNum ?}.
      {set FirstResultRow ?}.
      {set LastResultRow ?}.
      {get ServerOperatingMode cOperatingMode}.
      {get ASHandle hAppServer}.
      
      IF VALID-HANDLE(hAppServer) THEN
        RUN doEmptyModTable IN hAppServer.
    END.  /* If first or last */
    
    RUN clientSendRows IN TARGET-PROCEDURE
      (piStartRow, pcRowIdent, plNext, piRowsToReturn, OUTPUT piRowsReturned).
    
    RUN changeCursor IN TARGET-PROCEDURE('':U).
    
    RETURN.
  END.
  ELSE IF cASDivision = 'Server':U THEN  /* Always empty RowObject on Server */
    hRowObject:EMPTY-TEMP-TABLE().

  /* If we're running locally or on a server, continue on... */
  {get QueryHandle hQuery}.
  hFirstBuffer = hQuery:GET-BUFFER-HANDLE(1).

  /* NB! Get these context properties before openQuery */    
  {get LastResultRow cLastRow}.
  {get FirstResultRow cFirstRow}.
  {get LastRowNum  iLastRowNum}.
  {get FirstRowNum iFirstRowNum}.
  
  IF NOT hQuery:IS-OPEN THEN
  DO:
    {get FetchOnOpen cFetchOnOpen}.
    {set FetchOnOpen '':U}.
    {fn openQuery}.
    {set FetchOnOpen cFetchOnOpen}.
    /* Avoid trouble if record is avail, but not in synch with query */ 
    hFirstbuffer:BUFFER-RELEASE().
    lOpened = TRUE. /* if lRefresh we always reopen so set this flag (see below)*/
  END.

  IF hQuery:IS-OPEN THEN 
  DO:
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
    {get DataHandle hDataQuery}.  
    
    ASSIGN lNexting       = (piRowsToReturn >= 0)
           piRowsToReturn = ABS(piRowsToReturn).
      
    /* Check the RowIdent argument first; if this is set, it overrides the
       RowNum argument. */
    IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN
    DO:
      /* First close the RowObject query and empty the current temp-table. 
         Reset all the associated properties and variables.
         Special case: If RowNum is also specified, then
         the caller wants to *refresh* one or more rows starting with
         pcRowIdent, and to give them numbers starting with
         piStartRow, so in that case, don't empty the current temp-table. */
      IF piStartRow EQ ? THEN
      DO:
        IF cASDivision NE "Server":U THEN DO:
          hDataQuery:QUERY-CLOSE().
          RUN doEmptyModTable IN TARGET-PROCEDURE.
        END.  /* IF Local (NOT Server and we don't get here if Client) */
        hRowObject:EMPTY-TEMP-TABLE().
        {set FirstRowNum ?}.
        {set LastResultRow ?}.
        {set LastRowNum ?}.
        {set FirstResultRow ?}.
        ASSIGN cFirstRow = ? cLastRow = ? lRefresh = no.
      END.  /* END plNext or Return > 1 */
      ELSE DO:
        lRefresh = yes.   /* IF StartRow also there, signal refresh. */
        IF NOT lOpened THEN hQuery:QUERY-OPEN. /* include new records */
      END.
      IF pcRowIdent = "Last":U THEN   /* Special signal for fetchLast */
      DO:
        ASSIGN lNexting = no           /* Last means work backwards */
               iRowNum = 2000000       /* All Rows will have high numbers */
                                       /* We know to go backwards whether */
               piRowsToReturn = ABS(piRowsToReturn).  /* Rows is + or - */
        hQuery:GET-LAST().
      END.  /* END DO IF 'Last' */
      ELSE IF pcRowIdent = "First":U THEN  /* Re-starting the query */
      DO:
        ASSIGN lNexting = yes
               iRowNum = 0.
        hQuery:GET-FIRST().
      END.  /* END DO IF 'First' */
      ELSE DO:           /* Reposition to a specific RowIdent */
        
        /* If StartRow is specified, use that
           RowNum as a starting number. */        
        ASSIGN iRowNum = IF piStartRow NE ? 
                         THEN IF lNexting 
                              THEN piStartRow - 1
                              ELSE piStartRow + 1 /* Allow for incr/decr below*/
                         ELSE 2000000    /* Start with a high row num.*/
               rRowIDs = ?.       /* Fill in this array with the rowids. */
        
        DO iCnt = 1 TO NUM-ENTRIES(pcRowIdent):
          rRowIDs[iCnt] = TO-ROWID(ENTRY(iCnt, pcRowIdent)).
        END.        /* END DO iCnt */ 
     /* When there is a join, the first buffer may still be available here. 
        This causes a problem down below where we only GET-NEXT if it is NOT
        available. When the GET-NEXT doesn't get done any additional buffers 
        are not available. We now release the buffer here before the reposition 
        so that it is not available and the GET-NEXT is done. */
        hFirstBuffer:BUFFER-RELEASE. 
        hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.        
        IF NOT ERROR-STATUS:ERROR AND NOT hFirstBuffer:AVAILABLE THEN
          hQuery:GET-NEXT().
      END.  /* END ELSE DO IF real RowIdent */
    END.    /* END DO pcRowIdent */
    ELSE DO:
     /* Starting in 9.0B, piStartRow of ? means either start at the
        beginning if no rows have been retrieved yet, or start at the
        current end of the retrieved rows (if RowsToReturn > 0) or the
        beginning of the retrieved rows (if RowsToReturn < 0). */
      cStartRow = IF lNexting THEN cLastRow ELSE cFirstRow.
      IF cStartRow = ? AND (piStartRow = 0 OR piStartRow = ?) THEN
        /* means no rows have been retrieved yet. */
      DO:
        hQuery:GET-FIRST().
        iRowNum = 0.                 /* Starting at the beginning. */
      END.    /* END DO IF No StartRow */
      ELSE DO:
        /* Reposition to the right starting point unless we're already there.*/
        DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
          ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
                 cCurrentRow = cCurrentRow + 
                  (IF cCurrentRow NE "":U THEN ",":U ELSE "":U)
                    + (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
        END.   /* END DO iCnt */
        /* Format of First/LastResultRow is "RowNum;ROWID1[,...]ROWIDn" */
        cStartRowIds = ENTRY(2, cStartRow, ";":U).
        /* Restrict piStartRow to the same first or last
           RowNum that sendRows would have calculated on its own. If some
           other row is wanted which is already in RowObject, fetchRow
           will reposition to it. Otherwise RowNum is not meaningful. */
        iRowNum = INT(ENTRY(1, cStartRow, ";":U)).        
        IF piStartRow NE ? AND piStartRow NE iRowNum THEN
        DO:
          RUN addMessage IN TARGET-PROCEDURE("Invalid RowNum argument to procedure sendRows.":U,
            ?, ?).
          RETURN ERROR.
        END.  /* END TEMPORARY error block. */
          
        IF cCurrentRow NE cStartRowIds THEN  /* If not already on right row. */
        DO:
          rRowIDs = ?.       /* Fill in this array with all the rowids. */
          DO iCnt = 1 TO NUM-ENTRIES(cStartRowIds):
            rRowIDs[iCnt] = TO-ROWID(ENTRY(iCnt, cStartRowIds)).
          END.        /* END DO iCnt */
          lOffEnd = hQuery:QUERY-OFF-END. 
          /* When we delete the absolute last record the reposition 
             returns false in some rare cases also when we are OFF-END. 
            (Viewer add and delete add and delete, probably a query bug) 
             So we use the off-end flag to ensure that we always do get-next 
             if we were off-end. (Assuming that the rare case when it returns 
             false must indicate that we repositioned to the last record) */
          lok = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
          IF lok OR (lOffEnd AND NOT ERROR-STATUS:ERROR) THEN 
            hQuery:GET-NEXT().
        END.  /* END DO IF Not on StartRowIds */
      END.    /* END ELSE DO IF cStartRow NOT ? */
    END.      /* END ELSE DO IF no pcRowIdent */    
    IF plNext THEN 
    DO:
      IF lNexting THEN 
        hQuery:GET-NEXT().
      ELSE 
        hQuery:GET-PREV().
    END.  /* If plNext */
    
    ASSIGN piRowsReturned = 0.
    
    Generate-Record-Blk:
    DO WHILE hFirstBuffer:AVAILABLE 
       AND  (piRowsReturned < piRowsToReturn OR piRowsToReturn = 0):
      
      hRowObject:BUFFER-CREATE().
      ASSIGN
        iRowNum      = IF lNexting THEN iRowNum + 1
                       ELSE             iRowNum - 1.
      
      RUN transferDBRow IN TARGET-PROCEDURE
        ("":U /* Signal to use the current db row */, iRowNum).
      
      IF RETURN-VALUE = "ADM-ERROR":U THEN 
      DO:
        piRowsReturned = 0. /* NOTE: Error conditions? Do the right thing here. */
        RUN changeCursor IN TARGET-PROCEDURE('':U).
        RETURN.
      END.  /* END DO on error */

      /* Check to see if this record is already on the client */
      ASSIGN hFldRowIdent = hRowObject:BUFFER-FIELD("RowIdent")
             cRowIdent    = hFldRowIdent:BUFFER-VALUE.
      
      IF NOT lRefresh AND {fnarg canFindModRow cRowIdent} THEN 
      DO:
        /* Back out of this */
        hRowObject:BUFFER-DELETE().
        iRowNum = IF lNexting 
                  THEN iRowNum - 1
                  ELSE iRowNum + 1.
        IF lNexting THEN 
          hQuery:GET-NEXT().
        ELSE 
          hQuery:GET-PREV().
        NEXT Generate-Record-Blk.
      END.  /* If record is all ready on the client */
      IF piRowsReturned = 0 THEN
      DO:               
        /* At the *start* of the loop, save off the rownum & id
           if we're Nexting and FirstResult isn't set, or vice versa. 
           Don't bother in the special "refresh" case where both RowNum and
           RowIdent are specified. */
        IF (NOT lRefresh) AND 
           ((lNexting AND cFirstRow = ?) OR
            ((NOT lNexting) AND cLastRow = ?)) THEN
        DO:
          cStartRow = STRING(iRowNum) + ';':U.
          DO iCnt = 1 TO hQuery:NUM-BUFFERS:
            hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt).
            cStartRow = cStartRow + 
              (IF iCnt > 1 THEN ",":U ELSE "":U) + 
                (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
          END.  /* END DO iCnt */
          IF lNexting THEN
          DO:
            {set FirstResultRow cStartRow}.
            IF pcRowident = 'FIRST':U THEN
              iFirstRowNum = iRowNum.
          END.
          ELSE DO: 
            {set LastResultRow cStartRow}.
            IF pcRowident = 'LAST':U THEN
              iLastRowNum = iRowNum.
          END.
        END.    /* END DO IF lNexting */
        /* We want to save off the Rowid of the first newly created
           RowObject row to reposition to before returning. */
        rCurrentRow = hRowObject:ROWID.
      END.  /* END DO IF RowsReturned = 0 */
      piRowsReturned = piRowsReturned + 1.
      
      IF piRowsReturned < piRowsToReturn OR piRowsToReturn = 0 THEN
      DO:
        IF lNexting THEN 
        DO:
          hQuery:GET-NEXT().
          /* Is this is the Last record?*/
          IF hQuery:QUERY-OFF-END THEN
            iLastRowNum = iRowNum.
        END.
        ELSE DO: 
          hQuery:GET-PREV().
          /* Is this the First record?*/
          IF hQuery:QUERY-OFF-END THEN
            iFirstRowNum = iRowNum.
        END.
      END.  /* END DO IF not last RowToReturn */
    END.    /* END DO WHILE hFirstBuffer:AVAILABLE... */
    IF piRowsReturned > 0 THEN /* Repos. to where we were before we started. */
    DO:
      /* At the *end* of the loop, save off the final rownum & id.
         To do this, we must be prepared to go back to the first/last
         row if we've gone off the end. Again, don't bother if we're
         refreshing existing rows. */
      IF (NOT lRefresh) THEN
      DO:
        cStartRow = STRING(iRowNum) + ';':U.     
        DO iCnt = 1 TO hQuery:NUM-BUFFERS:
          hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt).
          IF iCnt = 1 AND NOT hBuffer:AVAILABLE THEN
          DO:
            IF lNexting THEN hQuery:GET-PREV().
            ELSE             hQuery:GET-NEXT().
          END.
          cStartRow = cStartRow + 
            (IF iCnt > 1 THEN ",":U ELSE "":U) + 
              (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
        END.  /* END DO iCnt */
        
        IF lNexting THEN
          {set LastResultRow cStartRow}.
        ELSE 
          {set FirstResultRow cStartRow}.
      END.    /* END DO IF NOT lRefresh */
      /* If we are nexting, check if lastrow need to be detected */
      IF lNexting THEN
      DO:
        /* We MUST now find out if we are on the last record. */
        IF iLastRowNum = ? THEN
        DO: 
          /* Did we get-last on open? */
          {get LastDbRowIdent cLastDbRowIdent}.
          /* if no lastDbrowIdent then look ahead */
          IF cLastDbRowident = '':U THEN
          DO:
            hQuery:GET-NEXT. /* We only get here if we are NOT off end */
            IF hQuery:QUERY-OFF-END THEN 
              iLastRowNum = iRowNum.
            hQuery:GET-PREV. 
          END. /* LastDbrowIdent = ''  */
          ELSE IF cLastDbRowident = ENTRY(2,cLastRow,';':U) THEN
            iLastRowNum = iRowNum.
        END. /* lastrowNum ? (try to find last) */
      END. /* lNexting */
      ELSE IF iFirstRowNum = ? THEN 
      DO:
        /* If we implemented a firstDbrowident we may avoid this..*/
        hQuery:GET-PREV. /* We only get here if we are NOT yet off end */
        IF hQuery:QUERY-OFF-END THEN
          iFirstRowNum = iRowNum.
        hQuery:GET-NEXT.
      END. /* Not nexting and FirstrowNum = ? */
      
      {get RebuildOnRepos lRebuild}.
      IF (NOT lRebuild OR (lRebuild AND pcRowIdent NE 'First':U)) AND iLastrowNum <> ? THEN
        {set LastRowNum iLastRowNum}.
      IF (NOT lRebuild OR (lRebuild AND pcRowIdent NE 'Last':U)) AND iFirstrowNum <> ? THEN
        {set FirstRowNum iFirstRowNum}.

      IF cASDivision NE "Server":U THEN
      DO:
        hDataQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
        IF rCurrentRow = ? THEN
        DO: /* This was our first fetch. Position BEFORE the first row. */
          hDataQuery:GET-FIRST().
          hDataQuery:GET-PREV().
        END.  /* END DO IF rCurrentRow = ? */
        ELSE hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
      END.    /* END DO IF NOT Server */
    END.      /* END DO IF RowsReturned > 0 */
    RUN changeCursor IN TARGET-PROCEDURE('':U).
  END.    /* END IF query IS-OPEN */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchRowObjUpdTable Procedure 
PROCEDURE serverFetchRowObjUpdTable :
/*------------------------------------------------------------------------------
  Purpose:     Returns the table-handle of the  Update table
               from the server to a dynamic client Data Object.
  Parameters:  OUTPUT TABLE-HANDLE phRowObjUpd.
  Notes:       We can't use the getRowObjUpdTable function 
               because that only returns the HANDLE, to be used by an object 
               on the same side of the AppServer connection. 
               This procedure returns the TABLE-HANDLE,
               so the entire table definition comes along with it.
------------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd.

  {get RowObjUpdTable phRowObjUpd}.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertyList Procedure 
PROCEDURE setPropertyList :
/*------------------------------------------------------------------------------
  Purpose:     To set a list of properties taken from a CHR(3) delimitted list
               of "propCHR(4)value" pairs.
  
  Parameters:  
    INPUT pcProperties - the CHR(3) delimitted list of "propCHR(4)value" pairs
                         to be set.
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER                    NO-UNDO.
  
  DEFINE VARIABLE iProp        AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cSignature   AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER                             NO-UNDO.

  iCnt = NUM-ENTRIES(pcProperties,CHR(3)).
  DO iProp = 1 TO iCnt:
    /* Process Prop<->Value pairs */
    ASSIGN cProp  = ENTRY(iProp,pcProperties,CHR(3))
           cValue = ENTRY(2,cProp,CHR(4))
           cProp  = ENTRY(1,cProp,CHR(4)).

    /* Get the datatype of the property */
    cSignature = DYNAMIC-FUNCTION("Signature":U IN TARGET-PROCEDURE, "get":U + cProp).
    
    IF cSignature EQ "":U THEN  /* It wasn't found */
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Property ":U + cProp + " not defined.":U).
    ELSE CASE ENTRY(2, cSignature):
      WHEN "CHARACTER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         IF cValue = "?" THEN ? ELSE cValue).
      WHEN "INTEGER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         INT(IF cValue = "?" THEN ? ELSE cValue)).
      WHEN "LOGICAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE,
                         IF cValue = "YES" THEN yes ELSE no).
      WHEN "DECIMAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         DEC(IF cValue = "?" THEN ? ELSE cValue)).
    END.  /* CASE on property type */
  END.  /* DO iProp = 1 TO NUM-ENTRIES */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startServerObject Procedure 
PROCEDURE startServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, startServerObject is run on the client to start
              the SmartDataObject on the server.
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
  /* Handles only one message, which is sufficent with the current appserver 
     class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.
  ELSE IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitCommit Procedure 
PROCEDURE submitCommit :
/*------------------------------------------------------------------------------
  Purpose:     Called by submitRow to commit changes to the database.
  
  Parameters:  
    INPUT pcRowIdent - Identifier of the row to commit.  It is a comma delimited
                       list of ROWIDS.  The first entry is the ROWID of the 
                       RowObject Temp-Table containing the record to commit.
                       Subsequent entries (of the comma delimited list) are the
                       DB ROWIDs of the records to be modified.
    INPUT plReopen   - TRUE if the RowObject query is to be reopened and
                       repositioned to the RowObject record identified by 
                       pcRowIdent.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER plReopen   AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE lAutoCommit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cReturn         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject      AS ROWID     NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hColumn         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLastRow        AS INTEGER   NO-UNDO.
  
  IF DYNAMIC-FUNCTION("anyMessage":U IN TARGET-PROCEDURE) THEN
  DO:
    /* Add the update cancelled message */
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).

    RETURN "ADM-ERROR":U.    /* If there were any Data messages */
  END.
  ELSE DO:
    /* Tell others the update is done and to redisplay the rec if appropriate */
    RUN dataAvailable IN TARGET-PROCEDURE ("SAME":U).  /* not a different row. */    
    {get AutoCommit lAutoCommit}.
    IF lAutoCommit THEN 
    DO:
      /* Go ahead with the DB transaction now. */
      RUN commitTransaction IN TARGET-PROCEDURE.
      cReturn = RETURN-VALUE.
    END.   /* END DO IF lAutoCommit */
    ELSE DO:
      cReturn = "":U.              /* success pending final Commit */
      {set RowObjectState 'RowUpdated':U}.
    END.  /* END ELSE DO IF Not AutoCommit */
    
    rRowObject = TO-ROWID(ENTRY(1,pcRowIdent)).
    
    {get RowObject hRowObject}.
    {get DataQueryBrowsed lBrowsed}.
    {get DataHandle hDataQuery}.
    IF cReturn = '':U THEN
    DO:      
      /* If doCreateUpdate told us to reopen (because a new record was added to 
         the RowObject table), re-open the RowObject Query and reposition to the
         newly added row. */
      IF plReopen THEN 
      DO:
        hDataQuery:QUERY-CLOSE().
        hDataQuery:QUERY-OPEN().        
        IF lBrowsed THEN 
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).      
      END.   /* END DO IF lReopen */
  
      IF rRowObject <> ? 
      AND (plReopen OR NOT hRowObject:AVAILABLE OR hRowObject:ROWID <> rRowObject) THEN
      DO:

        hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
        /* Make this RowObject available if reposition didn't (not browsed) */
        IF NOT hRowObject:AVAILABLE AND ERROR-STATUS:GET-MESSAGE(1) = '':U THEN
          hDataQuery:GET-NEXT().
      END. /* not avail or wrong record */
  
      /* A new record is added at the end so fix LastRowNum and maybe First- */
      IF plReopen THEN
      DO:         
        {get QueryPosition cQuery}.  
        hColumn = hRowObject:BUFFER-FIELD('RowNum':U).  
        IF cQuery = 'NoRecordAvailable':U THEN
        DO:
          {set LastRowNum hColumn:BUFFER-VALUE}.
          {set FirstRowNum hColumn:BUFFER-VALUE}.
        END. /* NoRecordAvailable  */     
        /* If we already had the last record, change LastRowNum if this is after*/
        ELSE DO: 
          {get LastRowNum iLastRow}.
          IF iLastRow <> ? AND hColumn:BUFFER-VALUE > iLastRow THEN
          DO:
            {set LastRowNum hColumn:BUFFER-VALUE}.
            {set LastDBRowIdent '':U}. /* We don't need this if we have lastRownum*/
          END.
        END. /*else do (records was available) */  
        /* Tell everybody about a potential change of QueryPosition. */
        RUN updateQueryPosition IN TARGET-PROCEDURE.
      END. /* if plReopen */

      /* From 9.1B+ we also publish uncommitted changes. */ 
      IF NOT plReopen THEN
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('SAME':U).  
      
      /*** Note that submitForeignKey currently still is getting
          the ForeignFields from the parent instead of ForeignValues if
          the source is NewRow and RowObjectState is 'RowUpdated'.
          because we did not use to commit here if not autocommit . */     
      ELSE 
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).  

    END. /* Return = '' (Successful commit or not autocommit) */
    ELSE DO: 
      IF NOT hRowObject:AVAILABLE OR rRowObject <> hRowObject:ROWID THEN
        /* A failed record is not in the query so we cannot reposition */
        hRowObject:FIND-BY-ROWID(rRowObject).
    END.
  END.  /* END DO IF no validation errors */
       
  RETURN cReturn.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitForeignKey Procedure 
PROCEDURE submitForeignKey :
/*------------------------------------------------------------------------------
  Purpose:     Called from submitRow to define Foreign Key values for a new row.
  
  Parameters:
    INPUT pcRowIdent          - The RowIdent (a comma delimited list of ROWIDs
                                that uniquely identify the RowObject record) of
                                the new RowObject record to be stored in the
                                database.  Since this is a new record, only the
                                first ROWID (that of the RowObject itself) is
                                valid.  There are no DB ROWIDs because they
                                have not yet been created.
    INPUT-OUTPUT pcValueList  - A CHR(1) delimited list of ForeignField column
                                and value pairs to be set in the RowObject 
                                record identified by pcRowIdent.  On input it is
                                a list that has been set before submitForeignKey
                                was called.  On output it is the now current list
                                of foreign fields that have been set.
    INPUT-OUTPUT pcUpdColumns - A comma delimited list of column names that are
                                updatable in the SDO.
                                
    Notes:     The list of udpdatable fields (pcUpdColumns - derived from the
               UpdatableColumns property in submitRow) usually doesn't
               contain key fields.  However, because submitForiegnKey is called
               when creating a new RowObject record, key fields need to be 
               populated so pcUpdColumns is expanded to allow for this.  
               However, only the variable pcUpdColumns is expanded, the 
               UpdatableColumns property remains unchanged.
               
------------------------------------------------------------------------------*/
 
  DEFINE INPUT        PARAMETER pcRowIdent   AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcValueList  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcUpdColumns AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cForFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cCurrField   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLookupParent    AS LOGICAL    NO-UNDO.

  /* If this is a newly Added row, and there are Foreign Fields, 
    assign those values to the RowObject columns. */
  {get RowObject hRowObject}.
  hField = hRowObject:BUFFER-FIELD('RowMod':U).
  IF hField:BUFFER-VALUE = "A":U THEN
  DO:
    {get ForeignFields cForFields}.
    IF cForFields NE "":U THEN
    DO:
      {get DataSource hSource}.      
      {get RowObjectState cRowObjectState hSource}.
      {get NewRow lNew hSource}.
      /* if multiple add for one-to-one or otherwise uncommitted new parent
         get the foreignkey from the source, because submitcommit does not 
         publish DataAvailable under these circumstances (new/autocommit off)
        NOTE: This is no longer true, but was changed too late to mess with it*/ 
      IF cRowObjectstate = 'RowUpdated' AND lNew  THEN
         lLookupParent = TRUE. 
      ELSE 
        {get ForeignValues cForValues}.

      {get DataColumns cDataColumns}.
      DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
                      /* Make sure this works with unqualified field */ 
        cCurrField = ENTRY(iCol, cForFields).
        cField = ENTRY(NUM-ENTRIES(cCurrField,".":U),cCurrField, ".":U).
        
        IF LOOKUP(cField, cDataColumns) NE 0 AND /* It's in the SDO, and */
           LOOKUP(cField, pcValueList, CHR(1)) = 0 THEN /* not already assigned */
        DO:

          ASSIGN cValue = IF NOT lLookupParent 
                          THEN ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)) 
                          ELSE {fnarg columnValue cField hSource}
              
                  pcValueList = cField + CHR(1) 
                              + cValue 
                              + (IF pcValueList = "":U THEN "":U ELSE CHR(1)) 
                              + pcValueList
                 /* Make it updatable for Add if not already */
                 pcUpdColumns = cField + ",":U + pcUpdColumns.
        END.   /* END DO IF LOOKUP... */
      END.     /* END DO iCol         */
    END.       /* END DO IF cForFields NE "" */
  END.         /* END DO IF "Add"     */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitValidation Procedure 
PROCEDURE submitValidation :
/*------------------------------------------------------------------------------
  Purpose:     To do validation on each of the columns of the a new RowObject 
               record, and on the record as a whole,  before committing it 
               to the database.

  Parameters:
    INPUT pcValueList  - A CHR(1) delimited list of Column Name<->value pairs
                         that need validation before committing a transaction.
    INPUT pcUpdColumns - A comma delimited list of the SmartDataObject columns
                         that are updatable.

  Notes:       There are three types of validation performed:
                 1) Newly entered data meets the format criteria.
                 2) Newly entered data is in an updatable field.
                 3) Any developer defined validation in the form of a
                    (FieldName)Validation procedure.
                 4) Any developer defined validation in the form of a
                    RowObjectValidation procedure for the whole row.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcValueList    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcUpdColumns   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iColNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCol        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHAR   NO-UNDO.
  
  {get RowObject hRowObject}.
  
  DO iColNum = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColName = ENTRY(iColNum, pcValueList,CHR(1)).
    hCol = hRowObject:BUFFER-FIELD(cColName) NO-ERROR.
    IF hCol = ? THEN 
       RUN addMessage IN TARGET-PROCEDURE ("Column name ":U + cColName + 
         " not found in the SmartDataObject.":U, cColName, ?).
    ELSE DO:
      /* Verify that they're not trying to update a non-enabled field. */
      IF LOOKUP(cColName, pcUpdColumns) = 0 THEN
          RUN addMessage IN TARGET-PROCEDURE ("Column ":U + cColName + 
            " may not be updated.":U, cColName, ?).
      ELSE DO:
         cValue = ENTRY(iColNum + 1, pcValueList,CHR(1)).
         /* Check for unknown values in the list of changes. */
         hCol:BUFFER-VALUE = IF cValue = "?":U 
                             THEN ?
                             ELSE cValue NO-ERROR.
        
        /* Allow for the possibility that the value they entered in the 
           View object may be completely invalid for the format associated 
           with the Frame field. */
        IF ERROR-STATUS:ERROR THEN
         RUN addMessage IN TARGET-PROCEDURE (? /* Use GET-MESSAGE */ , cColName, ?).
        ELSE DO:
          /* If there's a field validation procedure, run it. */
          RUN VALUE(hCol:NAME + 'Validate':U) IN TARGET-PROCEDURE 
            (hCol:BUFFER-VALUE) NO-ERROR. 
          /* The expectation is that such a procedure will return an error 
             message if there is one; we will log it for the column. 
             Otherwise the code assumes that an error-status simply means 
             there wasn't a validate procedure for this column. 
             We keep going even if there's a field error. */
          IF NOT ERROR-STATUS:ERROR AND   /* procedure was found and executed */
            /* NOTE: No longer checked? -> ERROR-STATUS:GET-NUMBER(1) NE 6456 THEN 
               (proc not found) - here and below */
            RETURN-VALUE NE "":U THEN
              RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, hCol:NAME, ?).
        END. /* END DO Validate procedure. */
      END.   /* END DO all column validation */
    END.     /* END DO check that column is updatable */
  END.       /* END DO for each updated column */
  
  /* If there's a user-defined validation procedure for the entire row,
     run that now. */
  RUN RowObjectValidate IN TARGET-PROCEDURE NO-ERROR.   
  IF NOT ERROR-STATUS:ERROR AND      /* Procedure was found and executed. */
    RETURN-VALUE NE "":U THEN
     RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-synchronizeProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchronizeProperties Procedure 
PROCEDURE synchronizeProperties :
/*------------------------------------------------------------------------------
   Purpose:   To synchronize certain properties on the derver side with its
              server side.
Parameters:
    INPUT pcPropertiesForServer  - a CHR(3) delimitted list of "propCHR(4)value" 
                                   pairs to be set on the server half of the
                                   SmartDataObject.
    OUTPUT pcPropertiesForClient - a CHR(3) delimitted list of "propCHR(4)value"
                                   pairs to be set on the client half of the 
                                   SmartDataObject.

    Notes:   synchronizeProperties is designed to be invoked from the client
             side, but executed on the server half of a SmartDataObject.
             While executing on the server side it calls setPropertyList to
             set the properties in pcPropertiesForServer, then accumulates
             properties to be sent back to the client so that the client can
             set them.
             There's no need to initialize from the clcient as the
             actual initialization also happens here! 
       NB!   If the FIRST entry is ObjectInitialized we take that as a signal
             to send back the 'init' properties that only needs to be sent 
             once. (We may improve this in the future)   
             The form of both pcPropertiesForServer and pcPropertiesForClient
             is designed to work with the setPropertyList method.
             We are currently sending some properties back only if the object 
             was initialized when this was called. This is true only when this
             is called from initializeObject.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPropertiesForServer AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPropertiesForClient AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cOperatingMode       AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE cQueryWhere          AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE cOpenQuery           AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE cDBNames             AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE cIndexInfo           AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE lInitFlag            AS LOGICAL             NO-UNDO.
 
  /* We only want to send some data back to the client ONCE, so we are 
     currently relying on the fact that the client passes 
     ObjectInitialized AS THE FIRST ENTRY.  */
  lInitFlag = pcPropertiesForServer BEGINS "ObjectInitialized":U + CHR(4).

  /* There is no set function and although it's a correct value let's just 
     remove it..  */
  IF lInitFlag THEN
  DO:
    ASSIGN
      lInitFlag = /* Let's pay respect the value of Objectinitialized */    
       CAN-DO('false,no',ENTRY(2,ENTRY(1,pcPropertiesForServer,CHR(3)),CHR(4)))
      ENTRY(1,pcPropertiesForServer,CHR(3)) = '':U
      pcPropertiesforserver = TRIM(pcPropertiesforserver,CHR(3)). 
  END.
   
  RUN setPropertyList IN TARGET-PROCEDURE (pcPropertiesForServer).
  
  /* Neither initializeObject or restartServerObject on the client does
     a separate initializeObject call anymore, so let's do it here.
     There's however no need to open the query, so set openOnInit to false.
     The query will be opened when needed (separate openQuery call or in 
     sendRows when batching) */
  {set OpenOninit FALSE}.
  RUN initializeObject IN TARGET-PROCEDURE.
  
  /* If stateless then send back QueryWhere as QueryContext, which will be 
     used to reset the context again and also by getQueryWhere to return 
     data without connecting. */    
  {get ServerOperatingMode cOperatingMode}.
  IF cOperatingMode = 'STATELESS':U THEN 
  DO:
    {get QueryWhere cQueryWhere}.
    IF cQueryWhere <> ? THEN
      pcPropertiesForClient = (IF pcPropertiesForClient <> "":U 
                               THEN pcPropertiesForClient + CHR(3)
                               ELSE "":U) 
                               + "QueryContext":U + CHR(4) + cQueryWhere.
  END. /* if stateless */

  /* IF lClientFirstCall THEN */
  IF lInitFlag THEN DO:
    {get IndexInformation cIndexInfo}.
    {get OpenQuery cOpenQuery}.
    {get DBNames cDBNames}.
    ASSIGN
      cOperatingMode = (IF cOperatingMode = ? THEN '?':U ELSE cOperatingMode)
      cIndexInfo     = (IF cIndexInfo     = ? THEN '?':U ELSE cIndexInfo)
      cOpenQuery     = (IF cOpenQuery     = ? THEN '?':U ELSE cOpenQuery)
      cDBNames       = (IF cDBNames       = ? THEN '?':U ELSE cDBNames)
      pcPropertiesForClient = (IF pcPropertiesForClient <> "":U 
                               THEN pcPropertiesForClient + CHR(3)
                               ELSE "":U) 
                             + "IndexInformation":U + CHR(4) + cIndexInfo
                             + CHR(3) 
                             + "ServerOperatingMode":U + CHR(4) + cOperatingMode
                             + CHR(3) 
                             + "OpenQuery":U + CHR(4) + cOpenQuery
                             + CHR(3) 
                             + "DBNames":U + CHR(4) + cDBNames.

  END. /* initialized */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     To undo any uncommitted changes to the RowObject table when the
               "Undo" button is pressed in the commit panel.

  Parameters:  <none>

  Notes:       undoTransaction calls doUndoTrans to restore the RowObject 
               Temp-Table and empty the RowObjUpd Temp-Table.
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE rRowObject  AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE  NO-UNDO.

  DEFINE VARIABLE hContainer         AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lQueryContainer    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lHasOneToOneTarget AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
  
  /* If they have made record changes they haven't saved, they must
     confirm that it is ok to Cancel this also. 
     Make this check if it came from the Commit Panel, but skip if it 
     came locally or from an SBO. */
  {get CommitSource hSource}.
  IF hSource = SOURCE-PROCEDURE THEN
  DO:
     /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmUndo':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN 'ADM-ERROR':U.
  END.    /* END IF hSource  */


  /* Restore the RowObject Temp-Table and empty the RowObjUpd Temp-Table.
     This is done in a separate procedure in data.i for simplicity, and
     to support the needed BUFFER-COPY statements. */
  
  RUN doUndoTrans IN TARGET-PROCEDURE.
     
  /* Now reopen the RowObject query, in order to refresh any dependent 
     SmartDataBrowser, reposition to the previously current row, and do
     dataAvailable to refresh that row in SmartDataViewers and other objects. */
    
  {get DataHandle hDataQuery}.
  hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
  rRowObject = hRowObject:ROWID.
  hDataQuery:QUERY-CLOSE().
  hDataQuery:QUERY-OPEN().
  hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
  IF NOT hRowObject:AVAILABLE THEN
    hDataQuery:GET-NEXT().   /* next if needed (for Viewer, not Browser target)*/
  
  {set RowObjectState 'NoUpdates':U}.
  
  /* if we have other targets in update then avoid all publisity..  */
  lHasOneTOOneTarget = {fn hasOneTOOneTarget}.     

  /* If we are inside a container with autocommit turned OFF, the container 
     should manage the undo and also has the responsibility to publish 
     dataAvailable. This is necessary because the container's undoTransaction
     calls undoTransaction in all SDOs and publising dataAvailble during this
     makes no sense, amongst other this avoids problems when the dataSources 
     still have rowObjectState 'RowUpdated' when receiving 'dataAvailable' */
  {get QueryContainer lQueryContainer}.

  IF NOT lhasOneTOOneTarget AND NOT lQueryContainer THEN
     PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQueryPosition Procedure 
PROCEDURE updateQueryPosition :
/*------------------------------------------------------------------------------
  Purpose: Reset the QueryPosition property after a record navigation.  
           The main purpose of this function is to eliminate duplication, 
           errors and minimalize messaging (setQueryPosition PUBLISHes)
           in fetchFirst, fetchPrev, fetchNext and fetchLast.   
    Notes: data.p should update LastRowNum, FirstRowNum and LastDbRowIdent
           properties and call this. 
         - The properties LastRowNum and FirstRowNum stores the 
           RowObject.RowNum of the first and last record in the database query. 
         - The LastDbRowIdent is updated at openQuery() if CheckLastOnOpen is 
           true and enables identification of the last record in cases where 
           LastRowNum has not yet been updated. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iLastRowNum  AS INT     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INT     NO-UNDO.  
  DEFINE VARIABLE cLastDbRowId AS CHAR    NO-UNDO.  
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lLast        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHAR    NO-UNDO.
  DEFINE VARIABLE cFFields     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cFValues     AS CHAR    NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE  NO-UNDO.

  {get RowObject hRowObject}.
  
  IF hRowObject:AVAILABLE THEN
  DO:
    {get FirstRowNum iFirstRowNum}.
    {get LastRowNum iLastRowNum}.
    {get LastDbRowIdent cLastDbRowId}.
    
    ASSIGN
      hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
      hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U)
      /* Are we on the last record?  */
      lLast     = hRowNum:BUFFER-VALUE   = iLastRowNum
                  OR
                 (hRowIdent:BUFFER-VALUE <> "":U AND  
                  hRowIdent:BUFFER-VALUE = cLastDbRowId) 

      cQueryPos = IF hRowNum:BUFFER-VALUE = iFirstRowNum                   
                  THEN (IF NOT lLast 
                        THEN 'FirstRecord':U 
                        ELSE 'OnlyRecord':U) /* first AND last is ONLY */
                  ELSE (IF NOT lLast 
                        THEN 'NotFirstOrLast':U /* not first and not last */ 
                        ELSE 'LastRecord':U).   
  END. /* If hRowObject:available */
  ELSE DO: 
     /* Check for a DataSource.  If there is a data source then we test
        foreign key values, we could also have checked queryPosition..
        but this is what Add uses, and this QueryPos is used to disable Add 
        in toolbar .. */
     {get DataSource hDataSource}.

     IF VALID-HANDLE(hDataSource) THEN 
     DO:
       /* Check and see if any foreign fields are used */
       {get ForeignFields cFFields}.
       IF cFFields <> ? THEN 
       DO:
         /* get the values for the foreign fields */
         {get ForeignValues cFValues}.
         IF cFvalues = ? THEN
            /* No Foreign values */
           cQueryPos = 'NoRecordAvailableExt':U.
       END. /* cFFields <> ? */
       IF cQueryPos = '':U THEN
       DO:
         /* Check if dataSource has an unsaved new record */
         {get NewMode lNew hDataSource}.
         IF lNew THEN
           cQueryPos = 'NoRecordAvailableExt':U.
       END. /* cQueryPos = '' */
     END.  /* valid DataSource */
     
     /* If not set above set the cQueryPos variable to NoRecordAvailable */ 
     IF cQueryPos = '':U THEN
       cQueryPos = 'NoRecordAvailable':U.
  END.  /* else (not avail)*/
  {set QueryPosition cQueryPos}.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     To passes along update-related messages (to its 
               Navigation-Source, e.g) and to adjust the DataModified property.
               
  Parameters:  
    INPUT pcState - A indicator of the state of a an updatable record. Valid
                    values are:
                      'UpdateBegin'    -  The user has indicated that an update
                                          will take place (either by pressing
                                          the Update button in a panel, or by
                                          entering an updatable field in a
                                          browser.)
                      'Update'         -  An update is in progress in another
                                          object (a viewer or browser.)
                      'UpdateEnd'      -  A save has completed (same as
                                          'UpdateComplete'.)
                      'UpdateComplete' -  Any changes to the RowObject
                                          Temp-Table have either been 
                                          committed or backed out.
                      'Reset'          -  Changes to the roewObject has been
                                          reset, passed on as 'UpdateComplete'  
                      'Delete'         -  An uncommitted delete, which we 
                                          pass on as 'update'.    
                        
  Notes:    -  The SmartDataObject also saves its own "copy" of the 
               DataModified property, set true when updateState is 'Update' 
               and false when updateState is 'UpdateComplete', so that it 
               can be queried by other objects (such as other dataTargets).  
            -  For visual objects the updateState is both a DataSourceEvent 
               and DataTargetEvent. In order to not bounce messages back to the 
               dataTargets that are both subscribers and publishers, we check 
               the source-procedure's DataSourceEvents and if 'updateState' is
               present in the list, we do not publish, but RUN in dataSource.
               See more comments in datavis.p version on this subject. 
               Note that even if we diod send the message back to the visual
               object it would not get bakc to us as visual object only 
               publish updatestate from internal events, including GAtargets   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hDataSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified         AS LOGICAL   NO-UNDO INIT ?.
  DEFINE VARIABLE lAutoCommit       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE    NO-UNDO.

  /* If a row is deleted when autoCommit is off it publishes 'delete' in order     
     NOT to disable its nav-source or browse data-target, but still get the 
     message to its data-source, (which in this case will be us). 
     Note: Navsources does not really need this anymore as they use 
           canNavigate  to check the validity of the message, but browsers still 
           disables on 'update' and does nothing on 'delete' and only use
           canNavigate to validate 'updateComplete'.
          (they could be changed to use canNavigate for all states)           
     The data source republishes this as 'update', so that all nav-source and 
     data-target browsers ABOVE the uncommitted delete is disabled. */          
  IF pcState = 'Delete':U THEN
    pcState = 'Update':U.

  /* Reset is passed as a workaround from visual objects to avoid that a 
     tableio with updatemode publishes updatemode('updateend'). */ 
  IF pcState = 'Reset':U THEN
  DO:
    /* if Reset in autocommit or inside an SBO with autocommit ensure that 
       a potential rowObjUpd record left over from a failed save is rolled 
       back and deleted.  */  
    {get AutoCommit lAutoCommit}.
    IF NOT lAutoCommit THEN 
    DO:
       {get ContainerSource hContainerSource}.
       {get AutoCommit lAutoCommit hContainerSource} NO-ERROR.
    END.
    IF lAutoCommit THEN 
      RUN doUndoRow IN TARGET-PROCEDURE.

    pcState = 'UpdateComplete':U.
  END.

  IF pcState = 'Update':U THEN
    lModified = yes.

  ELSE IF pcState = 'UpdateComplete':U THEN
    lModified = no.
  
  {set DataModified lModified}.

  PUBLISH 'updateState':U FROM TARGET-PROCEDURE (pcState).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, initializes it, and
               returns CHR(1) delimited list of values for the requested 
               columns (in pcViewColList) of the new RowObject row.
               The first entry in the list is the RowObect ROWID and db RowIds
               separated with commas. (The db Rowids are blank as the record 
               has not been created)    
  Parameters:
    INPUT pcViewColList - comma-separated list of columns names that are to
                          be displayed in the SmartDataViewer that called
                          addRow.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cForFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.

    {get RowObject hRowObject}.
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      /* ... or it might just be because we're adding multiple new
         rows at a time or for some other reason, so SOURCE-PROC may not be
         a SmartObject. In that case RowIdent will come back Unknown. 
         Use dynamic-function in case the object has no such property. */
      cRowid = DYNAMIC-FUNCTION('getRowIdent':U IN SOURCE-PROCEDURE) NO-ERROR.
      cRowid = ENTRY(1, cRowid).
      IF cRowid = ? THEN cRowid = "":U.  /* NOTE: On 2nd txn add. Is this OK? */
      {set CurrentRowid TO-ROWID(cRowid)}.
    END.   /* END No RowObject Available */  
    
    hRowObject:BUFFER-CREATE().
    
    {get DataColumns cColList}.
    iColCount = NUM-ENTRIES(cColList).
    DO iCol = 1 TO iColCount:
      hColumn = hRowObject:BUFFER-FIELD(iCol).
      hColumn:BUFFER-VALUE = 
        IF hColumn:INITIAL = ? THEN "":U
        ELSE IF hColumn:DATA-TYPE = "DATE":U AND hColumn:INITIAL = "TODAY":U THEN
          STRING(TODAY)
        ELSE hColumn:INITIAL NO-ERROR.   /* INITIAL is always CHARACTER. */
    END.
    
    /* If there are Foreign Fields, assign their values as initial
       values for those columns. */
    {get ForeignFields cForFields}.
    IF cForFields NE "":U THEN
    DO:
      {get ForeignValues cForValues}.
      
      /* Each ForField pair is db name, RowObject name */
      DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
        cField = ENTRY(iCol, cForFields).
        hColumn = hRowObject:BUFFER-FIELD(ENTRY(NUM-ENTRIES(cField, ".":U), cField, ".":U)).
        IF VALID-HANDLE(hColumn) THEN  /* might not be in SDO */
          hColumn:BUFFER-VALUE = ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)).
      END.  /* END DO iCol */
    END.    /* END DO IF cForFields NE "" */
    
    /* set RowNum and first last status */  
    {fnarg newRowObject 'Add':U}.
    
    RETURN {fnarg colValues pcViewColList}.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Cancels an Add, Copy, or Save operation.
  
  Parameters:  <none>
  
  Notes:       cancelRow calls doUndoUpdate which restores the original values
               of a modified row from the RowObjUpd record then deletes the
               RowObjUdp record.  In the cases of an Add or a Copy, both the
               new RowObject and the RowObjUpd records are deleted.  After all
               of this work has been done, doUndoUpdate repositions the 
               RowObject temp-table to what was previously the current row.
               This is all done in doUndoUpd because direct access to the 
               tables in the data.i include file greatly simplifies the code.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lNew          AS LOG       NO-UNDO.

 {get NewRow lNew}.
 RUN doUndoUpdate IN TARGET-PROCEDURE.

 /* Tell the data-targets that we're back in business */
 IF lNew THEN
   PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).

 RETURN cError.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Check if this object or its children has any updates   
    Notes: You can navigate an object that has uncommiited changes, but not 
           if the children has uncommitted changes, so this publishes 
           IsUpdatePending to check children as this includes rowObjectState 
           in the check.
         - Navigating objects will typically call this to check if the object
           that they are navigating can be navigated. Nav objects receives
           updateState from the objects they navigate and will perform this 
           check in the source of any 'updateComplete' message. This is required
           because an 'updateComplete' may come from a branch of a data-link 
           tree while publish isUpdatePending will check the whole tree to 
           ensure that no branches has pending updates. 
         - This returns true if we can navigate while isUpdatePending is the 
           opposite and returns true if update is pending. 
          (The real reason: It's easier to have default false for i-o params)   
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lDataModified   AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lUpdate         AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lNewMode        AS LOGICAL    NO-UNDO.  
   {get DataModified lDataModified}.   
   
    /* Use NewMode refers to the current Object's state, NOT newRow */ 
   {get NewMode lNewMode}.

   /* Use = TRUE to ensure that unknown is treated similar to false */
   lUpdate =  (lDataModified = TRUE) OR (lNewMode = TRUE). 
   /* This object does not block navigation, check all targets, 
      updatePending does the same check, but it always checks rowObjectstate 
      also to see if there are any pending uncommitted changes */      

   IF NOT lUpdate THEN  
     PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lUpdate).
   
   RETURN NOT lUpdate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Closes the RowObject temp-table query on both the client side
               and the server side (if the SmartDataObject is split.)  Then
               calls SUPER (which resolves to closeQuery in query.p) to close
               the database query.
 
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lReturnCode     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  
  {get DataHandle hDataQuery}.  /* Close the RowObject query. */
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    hDataQuery:QUERY-CLOSE().
    {set FirstRowNum ?}.
    {set LastRowNum ?}.
    {set FirstResultRow ?}.
    {set LastResultRow ?}.
    hRowObject = hdataQuery:GET-BUFFER-HANDLE(1).
    hRowObject:BUFFER-RELEASE().

    /* Don't do QueryPosition and dataAvailable if we're just closing
       a query to re-open it, because these cause unnecessary flashing. */
    IF ENTRY(1, PROGRAM-NAME(2), " ":U) NE 'openQuery':U AND
       ENTRY(1, PROGRAM-NAME(3), " ":U) NE 'openQuery':U THEN
    DO:
      RUN updateQueryPosition IN TARGET-PROCEDURE.
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U).
    END.

   /* Empty the current RowObject table.  Note that the buffer method works 
      only if there is no transaction active, so do it "by hand" if there is 
      one. */
    IF NOT TRANSACTION THEN
    DO:
      hBuffer = hDataQuery:GET-BUFFER-HANDLE(1).
      hBuffer:EMPTY-TEMP-TABLE().
    END.  /* END IF NOT TRANS */
    ELSE
      RUN doEmptyTempTable IN TARGET-PROCEDURE. 

    /* Empty the modification record temp-table. This should really be done
       only on the server; just do it no-error in case the proc's not there
       (in a dynamic SDO, e.g.) */
    RUN doEmptyModTable IN TARGET-PROCEDURE NO-ERROR.
  END.  /* If valid-handle */
  
  {get ASDivision cASDivision}.
  
  IF cASDivision = 'Client':U THEN
  DO:
    
     /* No server calls possible inside an SBO */ 
    {get QueryContainer lQueryContainer}. 
    IF NOT lQueryContainer THEN
    DO:
      /* If we're just the client then tell the AppServer to close. */
      {get ServerOperatingMode cOperatingMode}.
    
      /* We don't connect just to close the query in stateless mode. */  
      IF cOperatingMode <> 'STATELESS':U THEN 
      DO:
        {get ASHandle hAppServer}.
        IF VALID-HANDLE(hAppServer) THEN 
          RETURN {fn closeQuery hAppServer}.
        ELSE 
         RETURN FALSE.  
      END. /* IF cOperatingMode <> 'STATELESS':U */
    END. /* not QueryContainer */
    RETURN TRUE. 

  END.    /*  DO IF Client */
  ELSE RETURN SUPER(). /* Get query.p's version of this to close the db query. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of all requested properties for all the requested
               columns of the RowObject table.  If the pcColList parameter is 
               "*", then all the columns in the RowObject Column List.
  
  Parameters:
    INPUT pcColList  - comma-seperated list of column names for which properties
                       are to be returned.  "*" indicates all of the columns in
                       the DataObject.
    INPUT pcPropList - comma-separated list of properties to be returned.
                       Valid list items are: DataType, Extent, Format, Help,
                       Initial, Label, Modified, PrivateData,
                       QuerySelection, ReadOnly, StringValue,ValExp, ValMsg
                       and Width.
  
  Notes:       Returns a character string of <col1Props> CHR(3) <col2Props> ...
               where each <colnProps> is of the form:
                  <columnName> CHR(4) Prop1Value> CHR(4) Prop2Value ... 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iProp      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPropCount AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColProps  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cPropValue AS CHARACTER NO-UNDO.
  
  IF pcColList = "*":U THEN
    {get DataColumns pcColList}.
  
  ASSIGN iColCount  = NUM-ENTRIES(pcColList)
         iPropCount = NUM-ENTRIES(pcPropList).
         
  DO iCol = 1 TO iColCount:
    cColumn = TRIM(ENTRY(iCol, pcColList)).
    cColProps = cColProps + cColumn + CHR(4).
    DO iProp = 1 TO iPropCount:
      cProp = TRIM(ENTRY(iProp, pcPropList)).
      /* Note that for now at least we suppress errors and leave it up
       to the caller to make sure that all column names and properties 
       are valid.*/
      cPropValue = STRING(dynamic-function 
          ("column":U + cProp IN TARGET-PROCEDURE, cColumn)) NO-ERROR.
      cColProps = cColProps + 
        (IF cPropValue = ? THEN "" ELSE cPropValue) +
          (IF iProp < iPropCount THEN CHR(4) ELSE "":U).
    END.  /* END DO iProp */
    cColProps = cColProps + (IF iCol < iColCount THEN CHR(3) ELSE "":U).
  END.    /* END DO iCol  */
  
  RETURN cColProps.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) delimited list of values for the requested
               columns (in pcViewColList) of the current row of the RowObject.
               The first value is the RowObect ROWID and RowIdent separated 
               with a comma.     
  Parameters:
    INPUT pcViewColList - Comma delimited list of RowObject column names
  
  Notes:       The form of the first value is:
                 <RowObject ROWID>,<DB Buffer1 ROWID>,<DB Buffer2 ROWID>,...
               This is used as a key to uniquely identify the row and its
               origins in the optimistic locking system.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
  
  {get RowObject hRowObject}.     
  IF VALID-HANDLE(hrowObject) AND hRowObject:AVAILABLE THEN 
  DO:    
     /* The first value passed back is always a "key" consisting of the RowObject
        ROWID plus the ROWIDs of the individual db records which make up the row. */
     ASSIGN 
       cColValues = STRING(hRowObject:ROWID) + ",":U
       hColumn    = hRowObject:BUFFER-FIELD('RowIdent':U)
       cColvalues = cColValues + hColumn:BUFFER-VALUE + CHR(1)
       iColCount  = NUM-ENTRIES(pcViewColList).
     
     DO iCol = 1 TO iColCount:
       hColumn = hRowObject:BUFFER-FIELD(ENTRY(iCol, pcViewColList)) NO-ERROR.
       IF NOT VALID-HANDLE(hColumn) THEN
       DO:
         /* If this is a <calc> field, make put a constant in so that the
            browser does not fail during displayFields */
         IF ENTRY(iCol, pcViewColList) = "<calc>":U THEN
         DO:
           cColValues = cColValues + CHR(4) + "<calc>":U + CHR(4). 
         END.
         ELSE
         DO:
           /* If the column was not found in this object, look to see
              if this object has a parent that can supply it. */
           {get DataSource hDataSource}.
           IF VALID-HANDLE(hDataSource) THEN
           DO:
             cValue = DYNAMIC-FUNCTION('colValues':U IN hDataSource,
                                        ENTRY(iCol, pcViewColList)).
             IF cValue NE ? THEN
                cColValues = cColValues + ENTRY(2, cValue, CHR(1)).
             ELSE RETURN ?.
           END.   /* IF cValue */
           ELSE RETURN ?.
         END.
       END.       /* IF NOT VALID-HANDLE */
       ELSE DO:
          cColValues = cColValues 
                       + IF hColumn:BUFFER-VALUE = ? 
                         THEN "?":U 
                         ELSE RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)). 
      END.       /* END ELSE DO if hColumn found locally */

      IF iCol NE iColCount THEN cColValues = cColValues + CHR(1).
    END.  /* END iCol */
    RETURN cColValues.       
  END. /* valid and avail rowObject*/
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, copies all of the 
               current row values to it.  The return value of this function is 
               a CHR(1) delimited list of the values of the current row as 
               specified in the input parameter pcViewColList.  The first value 
               of this return value is the RowIdent of the newly created row.
               
  Parameters:  
    INPUT pcViewColList - comma-separated list of columns whose values are to
                          be returned for the newly created row.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowObject AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lBrowsed   AS LOGICAL   NO-UNDO.
    
    {get RowObject hRowObject}.
    {get DataHandle hDataQuery}.
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    /* NOTE: Here and in addRow just checking AVAILABLE is not really a reliable
       way to tell whether the record that happens to be current in the DO is the
       one the client wants to COpy. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      IF hDataQuery:IS-OPEN THEN    /* not open means not using temp-table */
      DO:
        {get RowIdent cRowid SOURCE-PROCEDURE}.
        cRowid = ENTRY(1, cRowid).
        {set CurrentRowid TO-ROWID(cRowid)}.
        rRowObject = TO-ROWID(cRowid).
        {get DataQueryBrowsed lBrowsed}.
        IF lBrowsed THEN
          hRowObject:FIND-BY-ROWID(rRowObject).
        ELSE DO:
            hDataQuery:REPOSITION-TO-ROWID(rRowObject).
            IF NOT hRowObject:AVAILABLE THEN
              hDataQuery:GET-NEXT().      /* To move onto the row itself. */
        END. /* END Not Browsed */
      END.   /* END DO IF IS-OPEN */
    END.     /* END No RowObject Available */  
           
    RUN copyColumns IN TARGET-PROCEDURE (pcViewColList, hDataQuery).
    
  RETURN {fnarg colValues pcViewColList}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRow Procedure 
FUNCTION createRow RETURNS LOGICAL
  (pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of values for a new row to CREATE, returning FALSE
               if any errors occur. This is done only to the RowObject 
               Temp-Table; committing the changes back to the database is 
               a separate step, which will be invoked from here if AutoCommit 
               is set on.
 
  Parameters:
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowObjId AS CHAR NO-UNDO.
  DEFINE VARIABLE lOk       AS LOG    NO-UNDO.
  
  /* get the RowObject ROWID from the new row */ 
  cRowObjId = ENTRY(1,
                    DYNAMIC-FUNCTION("addRow":U IN TARGET-PROCEDURE,"":U),
                    CHR(1)). 
  
  lOk = DYNAMIC-FUNCTION("submitRow":U IN TARGET-PROCEDURE, 
                         cRowObjId, 
                         pcValueList).
  
  IF NOT lOk THEN  
    DYNAMIC-FUNCTION('cancelRow':U IN TARGET-PROCEDURE).  
  
  RETURN lOk.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Submits a row for deletion. Returns FALSE if an error occurs. 
  Parameters:  INPUT pcRowIdent - RowId of the RowObject temp-table to delete.
                                  (Usually from the visual object's RowIdent 
                                   or refined by the SBO's deleteRow)    
                                - Unknown means delete current.
  Notes:       If auto-commit is on, the row will immediately be sent back 
               to the db for deletion.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessages      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowUpdField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdRowMod     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed       AS LOGICAL   NO-UNDO.  
  DEFINE VARIABLE lNextNeeded    AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO INIT yes.
  DEFINE VARIABLE rDataQuery     AS ROWID     NO-UNDO.
  DEFINE VARIABLE rRowAfter      AS ROWID     NO-UNDO.
  DEFINE VARIABLE lUpdFromSource AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRepos         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cMsg           AS CHAR      NO-UNDO.
  DEFINE VARIABLE lNewDeleted    AS LOGICAL   NO-UNDO.

  {get RowObject hRowObject}.
  {get RowObjUpd hRowObjUpd}.
  {get DataHandle hDataQuery}.
  {get DataQueryBrowsed lBrowsed}.
    
  /* Extract the RowObject ROWID from the RowIdent passed. If it's
     a valid ROWID and found in the Temp-Table, delete that row.
     If that entry isn't defined, then we're doing a delete for
     a query this object isn't managing. Create a RowObjUpd record
     for it (no data needed, just the RowIdent field) and delete it. */
  /* This includes ? which means delete current from 9.1B */
  IF ENTRY(1, pcRowIdent) NE "":U THEN
  DO TRANSACTION:
    IF pcRowIdent <> ? THEN
    DO: 

      rDataQuery = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.
    
      IF NOT hRowObject:AVAILABLE OR hRowObject:ROWID <> rDataQuery THEN
      DO:
        hRowObject:BUFFER-RELEASE.
        lRepos = hDataQuery:REPOSITION-TO-ROWID(rDataQuery).
        
        IF lRepos = FALSE THEN
        DO:
          cMSg = string(29) + "," 
                 + 'RowObject' + "," + 'ROWID ' + pcRowident + ''.
          {fnarg showMessage cMsg}.
          RETURN FALSE.
        END.
      END.

      /* If a Viewer is handling the delete, then we must Next on the query
         to make the row available. If the query's being browsed this is 
         implicit */    
      IF NOT hRowObject:AVAILABLE AND lRepos THEN
        hDataQuery:GET-NEXT(). 
      
      /* We need to try to find a RowObjUpd record for this row before 
         creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
         buffers and returns RowObjUpd buffer. */

    END. /* pcRowIdent <> ?  */
    
    DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                      hRowObject, 
                      hRowObjUpd).

    IF NOT hRowObjUpd:AVAILABLE THEN 
    DO:
      /* Copy the record to the Update table to be able to restore it 
         if UNDOne. */
      hRowObjUpd:BUFFER-CREATE().
      hRowObjUpd:BUFFER-COPY(hRowObject).
    END.  /* if RowObjUpd not avail */

    hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U).
    /* If we deleted a new record then just get rid of the rowobjupd */
    IF CAN-DO('A,C':U,hUpdRowMod:BUFFER-VALUE) THEN
      /*  future..need to change data rowObjectstate to dynamically use 
                  the existance of rowObjUpd.rowmod <> '' and sbo 
                  rowObjectState to only look in SDOs to make this work.                     
      hRowObjUpd:BUFFER-DELETE().
      */
      lNewDeleted = TRUE.
    
    hUpdRowMod:BUFFER-VALUE = "D".
  END.   /* END DO IF ENTRY(1) */
  ELSE DO:
    /* We need to try to find a RowObjUpd record for this row before 
       creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
       buffers and returns RowObjUpd buffer. */
    DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                      hRowObject, 
                      hRowObjUpd).
    IF hRowObjUpd:AVAILABLE THEN 
    DO:
      hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U).
      /* If we deleted a new record then just get rid of the rowobjupd */
      IF CAN-DO('A,C':U,hUpdRowMod:BUFFER-VALUE) THEN
        /*  future..need to change data rowObjectstate to dynamically use 
                   the existance of rowObjUpd.rowmod <> '' and sbo 
                   rowObjectState to only look in SDOs to make this work.                     
           hRowObjUpd:BUFFER-DELETE(). */
        lNewDeleted = TRUE.
      hUpdRowMod:BUFFER-VALUE = "D".
    END.
    ELSE DO:
        /* IF first entry in RowIdent is blank, use the rest to create
           a row to delete on behalf of a query managed elsewhere. */
      hRowObjUpd:BUFFER-CREATE().
      ASSIGN hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
             hRowUpdField:BUFFER-VALUE =
                            SUBSTR(pcRowIdent,INDEX(pcRowIdent, ",":U) + 1)
             hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdentIdx':U)
             hRowUpdField:BUFFER-VALUE =
                            SUBSTR(SUBSTR(pcRowIdent,INDEX(pcRowIdent, ",":U) + 1), 1, xiRocketIndexLimit)
             hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowMod':U)
             hRowUpdField:BUFFER-VALUE = "D":U.
      /* Make sure we do a Next (in the db query) following the delete,
         if there's no RowObject record. */
    END.  /* Else do - if RowObjUpd not avail */
  END.     /* END DO IF no ENTRY(1) */
  
  {get AutoCommit lAutoCommit}.
  
  IF lAutoCommit THEN 
  DO:  /* Go ahead with the DB transaction now. */
    RUN commitTransaction IN TARGET-PROCEDURE.
    lSuccess = RETURN-VALUE NE "ADM-ERROR":U.
    /* If there were no errors, delete the RowObject copy of the row. */
  END.  /* END DO IF AutoCommit */
  
  /* If we returned successfully from the Delete, or we have a Commit Panel
     so the delete has been done only locally for now, delete the RowObject. */
  IF (NOT lAutoCommit) OR lSuccess THEN
  DO:
    {get QueryPosition cQueryPos}.  /* Were we on the first/last record? */
    
    IF ENTRY(1, pcRowIdent) NE "":U THEN
    /* if the object has its own query, there's no temp-table rec to delete.*/
    DO:      
      IF NOT hRowObject:AVAILABLE THEN
      DO:
        hDataQuery:REPOSITION-TO-ROWID(rDataQuery).
        /* It's available already if repositioned in a browse */
        IF NOT hRowObject:AVAILABLE THEN
          hDataQuery:GET-NEXT.        
      END.
      
      /* If browsed we check whether the next record will be available 
         after deleteComplete. (implicit delete-current-row) */
      IF lBrowsed THEN 
      DO:
        hDataQuery:GET-NEXT.      
        lNextNeeded = hDataQuery:QUERY-OFF-END. 
        /* Back to Current */
        hDataQuery:GET-PREV.
      END.
      ELSE lNextNeeded = TRUE.
      
      hRowObject:BUFFER-DELETE().
    END.  /* END DO IF pcRowIdent */
    
    /* This will result in a delete-current-row in the browser */
    PUBLISH 'deleteComplete':U FROM TARGET-PROCEDURE. /* Tell Browser, e.g */
    
    /* if we are deleted as part of a one-to-one delete there's no need to try 
       to keep track of where we are since the parent will need to change anyway*/  
    {get UpdateFromSource lUpdFromSource}.
    IF NOT lUpdFromSource THEN
    DO:
      /* If there is a Commit-Source, signal that a row has been changed. */
      IF NOT lAutoCommit THEN 
      DO:                  
        PUBLISH "updateState":U FROM TARGET-PROCEDURE('delete':U).
        {set RowObjectState 'RowUpdated':U}.
      END.
    
      /* NextNeeded = false if the browse 'autopositioned', also if we deleted 
         the only or last record don't try to fetch another batch. */
      IF lNextNeeded AND {fnarg rowAvailable 'NEXT':U} AND NOT lNewDeleted THEN
        RUN fetchNext IN TARGET-PROCEDURE.
      ELSE 
      DO:    
        /* If no browser is used the rowObject is unavail, but more records
           may exists in a few cases (lNewDeleted and/or last deleted) */ 
        
        /* The only case we can get here and there may be records AFTER the 
           deleted is if a new record has been deleted (it would normally be 
           the last, but other new records may be behind  */
        IF lNewDeleted AND NOT hRowObject:AVAILABLE THEN
          hDataQuery:GET-NEXT.

        /* If we deleted the last (including a new which is last of the batch )
           position to the prev */ 
        IF NOT hRowObject:AVAILABLE THEN
           hDataQuery:GET-PREV.
        
        /* If we deleted the first/last record, we need to   
           set the properties for the "new" first record or last record. */        
        IF hRowObject:AVAILABLE THEN 
        DO:
          hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
          IF cQueryPos = 'FirstRecord':U THEN
            {set FirstRowNum hRowNum:BUFFER-VALUE}.        
          IF cQueryPos = 'LastRecord':U THEN
            {set LastRowNum hRowNum:BUFFER-VALUE}.        
        END.

        RUN updateQueryPosition IN TARGET-PROCEDURE.
        PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('different':U).      
      END.
    END. /* not lUpdFromSource */ 
  END.  /* END DO IF NOT AutoCommit OR Success from Commit */
  /* In the event of a failed delete, doreturnUpd has deleted the
     Update temp-table row. */
  /* Return false if there were any error messages returned. */
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the Row Object's query to the desired row (indicated
               by piRow) and returns that row's values (as specified in 
               pcViewColList).  The return value is CHR(1) delimited list of
               values (formatted according to each columns FORMAT expression.)
               The first value in the list is the RowIdent of the fetched row.
 
  Parameters:
    INPUT piRow         - desired row number within the result set
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE iRowNum    AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE rRowId     AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLastDbRowId  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRow       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRow       AS CHAR    NO-UNDO INIT ?.
  DEFINE VARIABLE lBrowsed   AS LOGICAL NO-UNDO.
  
    {get DataQueryBrowsed lBrowsed}.   
    {get DataHandle hDataQuery}.
    IF NOT hDataQuery:IS-OPEN THEN hDataQuery:QUERY-OPEN().
    
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
       
    IF hRowObject:AVAILABLE THEN
      ASSIGN hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U)
             hRowIdent  = hRowObject:BUFFER-FIELD('RowIdent':U)
             iRowNum    = hRowNum:BUFFER-VALUE.  /* Save off for comparison.*/
    CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
    lOK = hRowQuery:SET-BUFFERS(hRowObject).
    IF lOK THEN
      lOK = hRowQuery:QUERY-PREPARE
         ('FOR EACH RowObject WHERE RowObject.RowNum = ':U + STRING(piRow)).
    IF lOK THEN lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN lOK = hRowQuery:GET-FIRST().
    IF hRowObject:AVAILABLE THEN
    DO:
        rRowId = hRowObject:ROWID.
        lOK = hDataQuery:REPOSITION-TO-ROWID(rRowId).
        IF lOK AND (NOT lBrowsed) THEN hDataQuery:GET-NEXT().
        IF lOK THEN
        DO:
          IF VALID-HANDLE(hRowNum) THEN
          DO:  /* If we were previously positioned on some actual record... */
            {get LastRowNum iRow}.            
            {get LastDbRowIdent cLastDbRowId}.                              
            IF iRow = hRowNum:BUFFER-VALUE 
            OR cLastDbRowId = hRowIdent:BUFFER-VALUE THEN  
              {set QueryPosition 'LastRecord':U}.
            ELSE IF hRowNum:BUFFER-VALUE = 1 THEN
              {set QueryPosition 'FirstRecord':U}.
            ELSE IF iRowNum = 1 OR iRowNum = iRow THEN
              {set QueryPosition 'NotFirstOrLast':U}.
          END.   /* END DO IF VALID-HANDLE */
          /* Signal row change in any case. */
          PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
          /* This will return ? if not AVAILABLE. */
          cRow = {fnarg colValues pcViewColList}.
        END.     /* END DO IF lOK */
    END. /* if hRowObject:availabel */
    DELETE WIDGET hRowQuery.

    RETURN cRow. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Repositions the RowObject's query to the desired row, based on
            the corresponding database record rowid(s) (specified by 
            pcRowIdent), and returns that row's values (as specified in 
            pcViewColList).  The return value is CHR(1) delimited list of
            values (formatted according to each columns FORMAT expression.)
            The first value in the list is the RowIdent of the fetched row.
            If that row is not in the RowObject table, it repositions the 
            database query to that row and resets the RowObject table.
 
  Parameters:
    INPUT pcRowIdent    - desired rowid(s) within the result set, expressed 
                          as a comma-separated list of db rowids;
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
                          
       Note: If called with unknown or non-existing rowid the query is closed
             and the SDO will be in a bad state.(fetchNext and -Prev don't work) 
             The application need to call fetchRowident with a valid value 
             or fetchFirst, fetchLast or openQuery to get back to normal.                    
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE rRowId        AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDBQuery      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowQuery     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE cLastDbRowId  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRow          AS CHAR    NO-UNDO INIT ?.
  DEFINE VARIABLE lBrowsed      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHAR    NO-UNDO.
  DEFINE VARIABLE lFillBatch    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHAR    NO-UNDO.
  DEFINE VARIABLE lClient       AS LOGICAL NO-UNDO.
  
  {get RowObjectState cRowState}.
  {get RowsToBatch iRowsToBatch}.
  {get DataHandle hDataQuery}.
  
  hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
  
  /* Determines if this SDO is being browsed by a SmartDataBrowser */
  {get DataQueryBrowsed lBrowsed}.
     
  CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
  lOK = hRowQuery:SET-BUFFERS(hRowObject).
  IF lOK THEN
      /* Note that the where clause uses 'BEGINS' because the caller
         may have specified a partial RowIdent (first table of a join). */
    lOK = hRowQuery:QUERY-PREPARE
       (
        'FOR EACH RowObject WHERE RowObject.RowIdentIdx BEGINS "':U 
        + 
        SUBSTR(pcRowIdent, 1, xiRocketIndexLimit) 
        + 
        '" AND ':U 
        + 
        'RowObject.RowIdent BEGINS "':U 
        + 
        pcRowIdent 
        + 
        '"':U
       )
       .
  IF lOK THEN
    lOK = hRowQuery:QUERY-OPEN().
  
  IF lOK THEN
    lOK = hRowQuery:GET-FIRST().

    /* If update in progress and record not in the current batch */    
  IF cRowState = 'RowUpdated':U AND NOT hRowObject:AVAILABLE THEN 
  DO:
    DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "16":U).
    DELETE WIDGET hRowQuery.
    RETURN ?.
  END.   
    
  /* If it's not in the current RowObject set, keep getting batches of
     rows until we get to it, unless the RebuildOnRepos property is set,
     in which case we get sendRows to jump right to that record. */
  {get RebuildOnRepos lRebuild}.

  /* If RebuildOnReposition is true and the row we are looking for isn't in the
     current batch and we have a valid ID to look for, flush out the current set
     of RowObject records and reset the associated flags. */
  IF lRebuild AND NOT hRowObject:AVAILABLE and pcRowIdent NE "" THEN 
  DO:
    hRowObject:EMPTY-TEMP-TABLE().
    {set FirstRowNum ?}.
    {set LastRowNum ?}.
    {set FirstResultRow ?}.
    {set LastResultRow ?}.
  END.
  
  iRowsReturned = iRowsToBatch.

  IF lBrowsed THEN  /* set browser refreshable = false */
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U).
    
  ReadRows:
  DO WHILE (NOT hRowObject:AVAILABLE) AND iRowsReturned EQ iRowsToBatch:
    RUN sendRows IN TARGET-PROCEDURE 
            (?,    /* No RowNum specified */
             IF lRebuild THEN pcRowIdent ELSE ?, 
             /* If we are cycling through until we locate the desired row,
                (Rebuild = no), then nextflag is True; otherwise, if
                we are jumping to that rec as a starting point, it is
                the first row returned, so Nextflag is False. */
             NOT lRebuild,  
             iRowsToBatch, 
             OUTPUT iRowsReturned).

    IF iRowsReturned = 0 THEN    
      LEAVE ReadRows.
    ELSE IF NOT lRebuild THEN 
      PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iRowsReturned).

    /* If last record read set properties */
    IF iRowsReturned <> iRowsToBatch THEN
    DO:
      hDataQuery:GET-LAST.
      IF hRowObject:AVAILABLE THEN
      DO:
        ASSIGN hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U)
               hRowIdent  = hRowObject:BUFFER-FIELD('RowIdent':U).
        {set LastRowNum hRowNum:BUFFER-VALUE}.
        {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
      END.
    END.
    
    hRowQuery:QUERY-OPEN().     /* reopen the query on the one row. */
    hRowQuery:GET-FIRST().      /* see if that row is now AVAILABLE */
      
    IF hRowObject:AVAILABLE THEN
      LEAVE ReadRows.
    
    IF lRebuild THEN  /* Only one loop if Rebuild */
      LEAVE ReadRows.
  END.   /* END DO WHILE */
  
  IF hRowObject:AVAILABLE THEN
  DO:
    rRowId = hRowObject:ROWID.

    lOK = hDataQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.

    IF lOK AND (NOT lBrowsed) THEN 
       lOK = hDataQuery:GET-NEXT().
    
    IF lOK THEN
    DO:
      /* When rebuild on reposition is turned on and a SmartDataBrowser is
         being used to display data for this SDO, if the reposition is to 
         the end or near the end of the dataset we may not get a full
         batch and the browse may appear half empty and in certains 
         cases (when we've repositioned to the last row) the scrollbar
         becomes disabled.  To solve this we get more rows, enough rows
         to fill the batch thus filling the browse.  This behavior is 
         based on the fillBatchOnRepos property. */
      {get fillBatchOnRepos lFillBatch}.
      IF lFillBatch AND lRebuild AND lBrowsed AND iRowsReturned < iRowsToBatch THEN
      DO:
        {get ASDivision cASDivision}.
        IF cASDivision = 'client':U THEN lClient = TRUE. 
          ELSE lClient = FALSE.
        /* When a RowIdent is passed to sendRows locally, the temp-table
           is emptied so we need to re-read the record we just repositioned
           to (thus is FALSE used and we need to add 1 to the number of
           rows to return).  When the SDO is partially running on an 
           AppServer, the temp-table is not emptied on the server, it just
           gets more rows (thus TRUE used and we do not need to add 1 to 
           the number of rows to return and we have to reposition back 
           to the row that were originally repositioning to.  */
        RUN sendRows IN TARGET-PROCEDURE
          (?,
          pcRowIdent,
          lClient,
          IF lClient THEN - (iRowsToBatch - iRowsReturned) 
            ELSE - (iRowsToBatch - iRowsReturned + 1),
          OUTPUT iRowsReturned).
        IF lClient THEN 
          lOK = hDataQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
      END.
        /* This will return ? if not AVAILABLE. */
      cRow = {fnarg colValues pcViewColList}.
    END.     /* END DO IF lOK */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    IF lBrowsed THEN
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).
  END.         /* END DO IF AVAILABLE */
  ELSE DO:   
     /* No rows returned, close down everything 
        This exception should normally not happen. 
        The application would need to call fetchRowident with a valid value 
        or fetchfirst, fetchLast or openQuery to get back to normal behavior */      
      IF lBrowsed THEN 
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).

      hRowObject:EMPTY-TEMP-TABLE().
      hDataQuery:QUERY-CLOSE().
      
      {set FirstRowNum ?}.
      {set LastRowNum ?}.
      {set FirstResultRow ?}.
      {set LastResultRow ?}.
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Unable to locate record in current query.").
  END.
  
  /* Signal row change in any case. */
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).

  DELETE WIDGET hRowQuery.
 
  RETURN cRow.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRow Procedure 
FUNCTION findRow RETURNS LOGICAL
  (pcKeyValues AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find and reposition to a row using the key.
Parameter: pcKeyFields - Comma or chr(1) separated list of keyfields. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields AS CHAR   NO-UNDO.
  
  {get KeyFields cKeyFields}.

  IF NUM-ENTRIES(cKeyFields) > 1 THEN
  DO:
    /* If comma separated list replace with chr(1) */
    IF INDEX(pcKeyValues,CHR(1)) = 0 THEN 
      REPLACE(pcKeyValues,",":U,CHR(1)).
  END. /* if num-entries(cKeyFields) > 1  */

  RETURN DYNAMIC-FUNCTION('findRowWhere':U IN TARGET-PROCEDURE, 
                          cKeyFields,
                          pcKeyValues,
                          "=":U). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS LOGICAL
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle for RowObjUpd buffer for the RowObjUpd record that 
           corresponds to the RowObject record being passed to this function.
   Params: phRowObject AS HANDLE
           phRowObjUpd AS HANDLE  
    Notes: Called from deleteRow to check for a RowObjUpd for a row being deleted
           before creating a new one. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRowNum    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hRowNum    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hRowQuery  AS HANDLE NO-UNDO.

  ASSIGN hRowNum = phRowObject:BUFFER-FIELD('RowNum':U)
         cRowNum = hRowNum:BUFFER-VALUE.

  CREATE QUERY hRowQuery.
  hRowQuery:SET-BUFFERS(phRowObjUpd).
  hRowQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U + cRowNum).
  hRowQuery:QUERY-OPEN().
  hRowQuery:GET-FIRST().
  DELETE WIDGET hRowQuery.

  RETURN phRowObjUpd:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowWhere Procedure 
FUNCTION findRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
Purpose: Find and reposition to a row 
Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.

       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
                              
  Notes: The logic is in the query.p super                            
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumn AS CHAR  NO-UNDO.
  DEFINE VARIABLE i       AS INT   NO-UNDO.
  DEFINE VARIABLE cRowids AS CHARACTER  NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(pcColumns):
    cColumn            = ENTRY(i,pcColumns).
    /* pass the database columnname to the super. */
    ENTRY(i,pcColumns) = {fnarg columnDbColumn cColumn}. 
  END.
  
  cRowids = DYNAMIC-FUNCTION('rowidWhereCols':U IN TARGET-PROCEDURE,
                              pcColumns,pcValues,pcOperators).
  
  IF cRowids = ? THEN
    RETURN FALSE.

  DYNAMIC-FUNCTION('fetchRowident':U IN TARGET-PROCEDURE,
                    cRowids,
                    '':U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstRowIds Procedure 
FUNCTION firstRowIds RETURNS CHARACTER
 (pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:   Returns the ROWID (converted to a character string) of the first 
              database query row satisfying the passed query prepare string.   
Parameters:
    pcWhere - A complete query where clause that matches the database query's 
              buffers.
     Notes:   Used by rowidwhere, findRow and findRowWhere    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowid         AS CHARACTER NO-UNDO.
  /* Determine where to direct the request - client or server.
     The actual code for the function is in query.p. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO: 
    /* If we're just the client then do this on the AppServer. */
    {get ASHandle hAppServer}.
    IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
    DO:
      cRowid = DYNAMIC-FUNCTION("firstRowIds":U IN hAppServer, pcQueryString).
      /* unbind if getASHandle above did the binding */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END. /* valid Appserver */
    ELSE 
      cRowid = ?.
    
    RETURN cRowid. 

  END.  /* END DO IF Client */
  ELSE RETURN SUPER(pcQueryString).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the dataSource Foreignfields are different 
           from the current ForeignValues  
    Notes: Use by SBO commitTransaction  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentValues AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentValues  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSourceFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.

 {get ForeignFields cForeignFields}.
 {get ForeignValues cCurrentValues}.  
 {get DataSource    hDataSource}.

 IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN FALSE.

 DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
   cSourceFields =  cSourceFields 
                    + (IF iField = 1 THEN "":U ELSE ",":U)                 
                     /* 2nd of pair is source RowObject fld */ 
                    +  ENTRY(iField + 1, cForeignFields).
 END.

 ASSIGN
   cParentValues  = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
   /* Throw away the RowIdent entry returned by colValues*/
   ENTRY(1,cParentValues,CHR(1)) = '':U.
   /* Remove the chr(1).. DON'T TRIM it may cause a problem if the first 
      value(s) in the list is blank */ 
   cParentValues  = SUBSTR(cParentValues,2).


 RETURN cParentValues <> cCurrentValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasOneToOneTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasOneToOneTarget Procedure 
FUNCTION hasOneToOneTarget RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if this DataObject has DataTargets that are updated
            as part of this.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneToOne    AS LOGICAL    NO-UNDO.

  {get DataTarget cDataTargets}.
  DO i = 1 TO NUM-ENTRIES(cDataTargets):
    hTarget = WIDGET-HANDLE(ENTRY(i,cDataTargets)).
    IF VALID-HANDLE(hTarget) THEN
    DO:
      {get UpdateFromSource lOneToOne hTarget} NO-ERROR.
       IF lOneTOOne THEN
         RETURN TRUE.
    END.
  END.
  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
  (pcMode AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Assign some general RowObject fields and update LastRowNum,
            FirstRowNum when a new RowObject has been created . 
Parameters: pcMode - char  - A(dd) or C(opy)     
     Notes: The main purpose for this procedure is to ensure that copy and add
            behaves similar. 
            The buffer must be created first.  
            Currently defined as PRIVATE. 
            Used in procedure copyColumns and function addRow().  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryPos  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
 DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
 DEFINE VARIABLE iLastRow   AS INT    NO-UNDO.
 DEFINE VARIABLE cBlank     AS CHAR   NO-UNDO.

 {get RowObject hRowObject}.
 
 ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowIdent':U)
        hColumn:BUFFER-VALUE = "":U
        hColumn = hRowObject:BUFFER-FIELD('RowIdentIdx':U)
        hColumn:BUFFER-VALUE = "":U
        giAddRowNum = giAddRowNum + 1  /* Assign high temp row number */
        hColumn = hRowObject:BUFFER-FIELD('RowNum':U)
        hColumn:BUFFER-VALUE = giAddRowNum
        hColumn = hRowObject:BUFFER-FIELD('RowMod':U)
        hColumn:BUFFER-VALUE = SUBSTR(pcMode,1,1).  

 PUBLISH "dataAvailable" FROM TARGET-PROCEDURE ('DIFFERENT').    

 RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openDataQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openDataQuery Procedure 
FUNCTION openDataQuery RETURNS LOGICAL
  (pcPosition AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Open the DataQuery  
Parameters: pcPosition - 'first' or last' 
                         Expected to be extended with Rowid support.  
     Notes: Currently used by SBOs after new temp-tables have been fetched.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataQuery AS HANDLE  NO-UNDO.
 DEFINE VARIABLE cQuery     AS CHARACTER  NO-UNDO.
 
 {get DataHandle hDataQuery}.
 {get DataQueryString cQuery}.
 
 IF VALID-HANDLE(hDataQuery) THEN
 DO:
   hDataQuery:QUERY-PREPARE(cQuery).
   hDataQuery:QUERY-OPEN().
   
   CASE pcPosition: 
     WHEN 'FIRST':U THEN
       hDataQuery:GET-FIRST().  
     WHEN 'LAST':U THEN
       hDataQuery:GET-LAST().  
     /**  future ?? 
     OTHERWISE DO:
       IF pcPosition <> '':U AND pcPosition <> ? THEN
       DO:
         hDataQuery:REPOSITION-TO-ROWID(TO-ROWID(pcPosition)) NO-ERROR. 
         IF not avail THEN get-next... 
       END.
     END.
     **/ 
   END CASE.
   /* update QueryPosition property and publish this to toolbars etc */
   RUN updateQueryPosition IN TARGET-PROCEDURE.
 END. /* valid hDataquery */

 RETURN IF VALID-HANDLE(hDataQuery) 
        THEN hDataQuery:IS-OPEN 
        ELSE FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Opens the SmartDataObject's database query based on the current 
               WHERE clause.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/    
 DEFINE VARIABLE cASDivision      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cDataQueryString AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hAppServer       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hDataQuery       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cQueryString     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iByClause        AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cQueryWhere      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lOk              AS LOG       NO-UNDO.
 DEFINE VARIABLE hSource          AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cOperatingMode   AS CHARACTER NO-UNDO.

 /* Close the RowObject query and empty the current RowObject table. */
 {get DataHandle hDataQuery}.

 IF VALID-HANDLE(hDataQuery) THEN 
 DO: 
   IF hDataQuery:IS-OPEN THEN
     {fn closeQuery}.
   ELSE DO:
     {get DataQueryString cDataQueryString}.
     IF cDataQueryString NE hDataQuery:PREPARE-STRING THEN
        hDataQuery:QUERY-PREPARE(cDataQueryString).
   END.  /* else do - query not open */
 END.  /* if valid hDataQuery */

  /* NOTE: How to do this without actually repreparing the temp-table query twice.
  {set DataSort '':U}.           /* Reset these qualifiers on the Temp-Table */
  {set DataWhere '':U}.          /*  in case the data has been filtered. */
  */
   
 /* If this SDO's Container is an SBO which is a CLient, then ask it to
    fetch the data from the server starting at this object's level. */
 {get ContainerSource hSource}.
 {get ASDivision cASDivision hSource} NO-ERROR.
 IF cASDivision = "Client":U THEN
 DO:
   {get ObjectName cObjectName}.
   RUN fetchContainedData IN hSource (INPUT cObjectName).
 END.     /* END DO IF parent is a CLient object. */
 ELSE 
 DO:
   /* If this is the client half of a divided DataObject, fetchFirst will
      retrieve the Temp-table across the connection. */
   {get ASDivision cASDivision}.
   IF cASDivision = 'Client':U THEN
   DO:
     /* Reset this last-record flag on the client */ 
     {set LastRowNum ?}.
     {get ASHandle hAppServer}.
     IF VALID-HANDLE(hAppServer) THEN 
     DO:              
       /* The getQueryString will return the client side QueryString 
          if query manipulation methods has been used. */ 
       {get QueryString cQueryString}. 
       IF cQueryString <> "":U THEN
       DO:
         /* initializeServerObject passes queryString and immediately 
            sets QueryWhere with it, so if this is a 'stateless' connection
            we check if they are the same and see if we can avoid an extra 
            server call. */   
         {get ServerOperatingMode cOperatingMode}.
         IF cOperatingMode = 'stateless':U THEN
           {get QueryWhere cQueryWhere}.
         
         IF cQueryWhere <> cQueryString THEN
           {fnarg prepareQuery cQueryString}. /* will be sendt to server. */
       END. /* QueryString <> '' */
       IF {fn openQuery hAppServer} THEN 
       DO:
         RUN fetchFirst IN TARGET-PROCEDURE.
         /* Some visual objects that shows more than one record may need to know 
            that the query changed, this cannot be detected through the ordinary
            publish "dataAvailable" from the navigation methods. 
            The SmartSelect populates its list on this event and OCX objects
            like lists and Tree-views may also need to subscribe to this event. */
         PUBLISH "queryOpened":U FROM TARGET-PROCEDURE.
         lOK = TRUE. 
       END. /* If successfully opened the query */
       /* unbind if we did the bind with the call to getASHandle above */
       RUN unbindServer IN TARGET-PROCEDURE (?).
       RETURN lOk.
     END. /* If a valid appserver handle */
     ELSE RETURN FALSE.
   END.   /* END DO client */
   ELSE DO:  /* This is not the client */                 
     /* We must ensure that old context is wiped out in stateless mode,
        Although client openQuery does pass the correct context 
       (nullified in closeQuery) it is a risk that the context have been 
       reset from another function before openQuery is called. */
     IF cASDivision = 'SERVER':U THEN 
     DO:
       {set FirstRowNum ?}.
       {set LastRowNum ?}.
       {set FirstResultRow ?}.
       {set LastResultRow ?}.
     END.  /* If on the server */
  
     RETURN SUPER().
   END.  /* ELSE DO: Not the client */
 END. /* else do (not sbo client ) */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Prepare the SmartDataObject's database query based with the
            passed parameter  
            The main purpose of this procedure is to isolate the query 
            preparation for client server, thus keeping that away from the 
            logic needed to clean up and keep track of the QueryString property.
Parameters: Complete query expression. 
     Notes: History of client and server query manipulation:            
            9.0A setQueryWhere    - prepares immediately   (data and query)
                 setQuerySort     - prepares immediately   (data and query
                 openQuery        - just open              (data and query)
            9.0B addQueryWhere    - stored in queryString prop on client (query)
                 assignQueryWhere - stored in queryString prop on client (query)
                 openQuery        - prepares if queryString is set, open
            The logic added in setQueryWhere and openQuery to make sure that  
            setQueryWhere did blank the QueryString property, but NOT when it 
            was used to pass the queryString to the server, was rather 
            "difficult". This function simplifies this and setQueryWhere
            now only exists in query.p.    
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lOk            AS LOGICAL   NO-UNDO.

   /* If this is the client half of a divided DataObject prepare the query
      on the server. */                                   
   {get ASDivision cASDivision}.
   IF cASDivision = 'Client':U THEN
   DO:
     {get ASHandle hAppServer}.
     IF VALID-HANDLE(hAppServer) THEN 
     DO:
       lOk = {fnarg prepareQuery pcQuery hAppServer}.
       
       /* If the prepare was a success we must ensure that the new queryWhere 
          is set in stateless SDOs, which depends on QueryContext both to keep 
          context and to return the current query in getQueryWhere. */    
       IF lOk THEN 
       DO:
         {get ServerOperatingMode cOperatingMode}.         
         IF cOperatingMode = 'STATELESS':U THEN
            {set QueryContext pcQuery}.
       END. /* if lOk */
       RETURN lok. 
     END. /* valid-handle(hAppserver) */
     ELSE
      RETURN FALSE. /* No hAppServer (should we have a lost contact message?)*/

   END.   /* If client */
   ELSE  /* This is not the client */
     RETURN SUPER(pcQuery).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowAvailable Procedure 
FUNCTION rowAvailable RETURNS LOGICAL
  ( pcDirection  AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Check RowObject availability. 
            Encapsulates the different queryposition alternatives required to
            check for availability.
Parameters: pcDirection 
                   NEXT              Is there a next record available
                   PREV              Is there a prev record available
                   '', ?, or CURRENT Current record.
     Notes: This can be used in loops to simplify logic when navigating. 
            Simplifed example without dynamic-func and handles:
            -----------------------------------------                                          
            if rowAvailable('') then 
            do while true 
              run fetchNext.
              if not rowAvailable('next') then leave.  
            end.            
            ----------------------------------------
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAvail         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lAny           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE xcOneOrNone    AS CHARACTER  NO-UNDO
      INIT 'OnlyRecord,NoRecordAvailable,NoRecordAvailableExt':U.

  {get QueryPosition cQueryPosition}.   
  CASE pcDirection:
    WHEN 'Next':U THEN
      RETURN 
        NOT CAN-DO('LastRecord,':U + xcOneOrNone,cQueryPosition). 
    WHEN 'Prev':U THEN
      RETURN 
        NOT CAN-DO('FirstRecord,':U + xcOneOrNOne,cQueryPosition).
    WHEN '':U OR WHEN 'Current':U OR WHEN ? THEN 
      RETURN NOT cQueryPosition BEGINS 'NoRecord':U. 
  END CASE.

  RETURN FALSE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowValues Procedure 
FUNCTION rowValues RETURNS CHARACTER
  ( pcColumns   AS CHAR,
    pcFormat    AS CHAR,
    pcDelimiter AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a list of data from ALL rows in the dataobject.     
  Parameters: pcColumns   - Comma separated list of RowObject column names.
              pcFormatMode      - Formatting option.  
                  blank or ?     - unformatted: columnValue()  
                 'Formatted'     - Formatted without trailing blanks                                     
                 'TrimNumeric'   - Formatted without leading spaces for
                                   numeric data.     
                 'NoTrim'        - Formatted with leading and trailing blanks.     
              pcDelimiter  - Delimiter  ?     = chr(1)) ! 
                                        blank = space   !         
              
  Notes: - This is intended for use by the SmartSelect or other non-browser
           objects that need to show all rows of the SDO.   
         - Should not be used with large amounts of data as all data
           need to fit in the return value.
         - The purpose is to read all data without publishing data available to
           its datasources. However, if the query is browsed that will happen 
           when reposition-to-rowid is executed.                                                         
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid      AS ROWID      NO-UNDO.
  DEFINE VARIABLE cLastRowids AS CHAR       NO-UNDO.
  DEFINE VARIABLE iLastRowNum AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowIdent   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowNum     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmpcList    AS CHARACTER  NO-UNDO. /* use this to avoid bfx errors */
  DEFINE VARIABLE cColumnCall AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iReturnRows AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSizeError  AS LOGICAL    NO-UNDO. /* if bfx size error was detected */
  
  {get DataHandle hDataQuery}.
  
  ASSIGN
    lSizeError = FALSE
    cList      = "":U
    pcFormat   = REPLACE(pcformat,"-":U,"":U). /* allow dashes */

  /* We are not opening the query for anyone from here !!!  */
  IF hdataQuery:IS-OPEN THEN
  DO:
    {get RowObject hRowObject}. 
    
    ASSIGN hRowNum     = hRowObject:BUFFER-FIELD('RowNum':U)
           hRowIdent   = hRowObject:BUFFER-FIELD('RowIdent':U)
           rRowid      = hRowObject:ROWID 
           cColumnCall = IF pcFormat = '':U 
                         THEN 'columnValue':U
                         ELSE 'columnStringValue':U.     
    
    /* Just in case the SDO is browsed */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U). 
    
    hDataQuery:GET-FIRST.
    
    IF hrowObject:AVAILABLE THEN 
    buildBlock:
    DO iLoop = 1 TO 2: /* need two loops in case we are batching */
      
      DO WHILE hDataQuery:QUERY-OFF-END = FALSE:
        DO iCol = 1 TO NUM-ENTRIES(pcColumns):
          ASSIGN
            cColumn = ENTRY(icol,pcColumns)
            cValue  = DYNAMIC-FUNCTION(cColumnCall IN TARGET-PROCEDURE,
                                       cColumn).
          IF pcFormat <> '':U THEN 
          DO:
            CASE pcFormat:
              WHEN 'Formatted':U THEN
                   cValue = RIGHT-TRIM(cValue).

              WHEN 'TrimNumeric':U THEN /* Remove leading blanks from numeric*/
                 ASSIGN 
                   cDataType =  {fnarg columnDataType cColumn}
                   cValue    =  IF CAN-DO('Decimal,Integer':U,cDataType) 
                                THEN TRIM(cValue)
                                ELSE RIGHT-TRIM(cValue).
              
            END.
          END.
      
          /* these on stop undo, leave blocks are to avoid bfx errors
           * when the clist is getting too big. The only way to get it is 
           * to do the assign to temp variable and then check for the error. If there is
           * an error then we'll leave clist alone and return it as is. If there
           * isn't an error then we will update clist to be the same as the temporary
           * variable. Sometimes this will error out too so we have to check for
           * errors there.
           */
          
          DO ON STOP UNDO, LEAVE :
            ASSIGN
                tmpcList       = cList 
                               + (IF pcDelimiter = "":U THEN " ":U else pcDelimiter)
                               + cValue
                cLastRowIds = hRowIdent:BUFFER-VALUE
                iLastRowNum = hRowNum:BUFFER-VALUE NO-ERROR.
        
          END. /* end assign block */
          
          IF ERROR-STATUS:ERROR THEN 
          DO:
              lsizeError = TRUE.
              LEAVE BuildBLOCK.
          END.
          ELSE DO ON STOP UNDO,LEAVE:
              ASSIGN cList = tmpClist NO-ERROR.
          END.
          IF ERROR-STATUS:ERROR THEN 
          DO:
              lsizeError = TRUE.
              LEAVE BuildBLOCK.
          END.
        END. /* do iCol = 1 to num-entries */         
        hDataQuery:GET-NEXT.
      END. /* while Query-off-end = false */
    
      /* If First loop check if the sdo has any unread data */ 
      IF iLoop = 1  THEN
      DO:
        RUN sendRows IN TARGET-PROCEDURE
          (iLastRowNum + 1, /* Don't close the query, append to existing data */
           cLastRowids,     /* Start on the last Row */
           TRUE /* Jump to next row */, 
           ?, /* All records (no need to waste the time on batching) */
           OUTPUT iReturnRows).
     
        IF iReturnRows > 0 THEN
        DO:
          IF NOT hRowObject:AVAILABLE THEN
            hDataQuery:GET-NEXT.
        END.
        ELSE
          LEAVE.
      END.
      ELSE IF iLoop = 2 THEN
      /* A second loop means that we read data from the server, 
         so we must make sure that the last* properties are updated. */     
      DO:
        {set LastRowNum     iLastRownum}.
        {set LastDbRowIdent cLastRowids}.        
      END.      
    END. /* do while hRowObject available (BuildBlock:) */
    
    IF lSizeError AND iLoop = 2 THEN 
    DO:
        /* We quit in the middle of building the list because the list
           was too big and a stop condition occurred. So we need to do
           some stuff that didn't get done:
           A second loop means that we read data from the server, 
           so we must make sure that the last* properties are updated. 
         */     
        {set LastRowNum     iLastRownum}.
        {set LastDbRowIdent cLastRowids}.        
    END.

    IF rRowid <> ? THEN
    DO:  
      hDataQuery:REPOSITION-TO-ROWID(rRowid). 
      IF NOT hRowObject:AVAILABLE THEN
        hDataQuery:GET-NEXT.
    END.

    /* Just in case the SDO is browsed */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).     
  END. /* queryopen */
  
  IF lSizeError THEN 
    RETURN ?.

 /* This will trim only the first delimiter; as opposed to the 
    left-trim(...,Separator). Because we may have blank as delimiter 
    the usual (if '' then '' else delimiter) cannot be used,
    so we ALWAYS prepend the delimiter above  */
  RETURN SUBSTRING(cList,2).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of changed values for a row and ASSIGNs them,
               returning FALSE if any errors occur. 
               This is done only to the RowObject Temp-Table; 
               committing the changes back to the database is 
               a separate step, which will be invoked from here if 
               AutoCommit is set on.
 
  Parameters:
    INPUT pcRowIdent  - "key" with row number to update, plus a list of the 
                        ROWID(s) of the db record(s) the RowObject is derived 
                        from.
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReopen        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdColumns    AS CHARACTER NO-UNDO.
    
  /* NOTE: check here to make sure that the RowIdent passed in 
     matched the current ROWID or could be repositioned to removed in 9.1B.
     There is no supported case where repositioning should be necessary,
     and the new SBO does not always have the correct RowIdent. */
 
  {get UpdatableColumns cUpdColumns}.
  
  /* Assign Foreign Key values if needed for new records. */
  RUN submitForeignKey IN TARGET-PROCEDURE
                        (INPUT pcRowIdent,
                         INPUT-OUTPUT pcValueList,
                         INPUT-OUTPUT cUpdColumns).

  /* Create a "before" row in the Update table for an Update, or create a new
     row in the RowObject table for an Add/Copy. */
  RUN doCreateUpdate IN TARGET-PROCEDURE 
                        (INPUT pcRowIdent, 
                         INPUT pcValueList,
                         OUTPUT lReopen, 
                         OUTPUT cErrorMessages).

  IF cErrorMessages NE "":U THEN
    RETURN FALSE.  

  /* Perform any validation on individual columns. */
  RUN submitValidation In TARGET-PROCEDURE (pcValueList, cUpdColumns).
  
  /* Undo the update if there are errors; else commit if AutoCommit. */
  RUN submitCommit In TARGET-PROCEDURE (pcRowIdent, lReopen).

  RETURN RETURN-VALUE NE "ADM-ERROR":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  (pcKeyValues AS CHAR,
   pcValueList AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Update an existing row 
Parameters: pcKeyValues - comma separated or chr(1) separated list of keyvalues
                          ? - update current row
            pcValueList - CHR(1) delimited list of alternating column names 
                          and values to be assigned.
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk       AS LOG    NO-UNDO.
  DEFINE VARIABLE cRowIdent AS CHAR   NO-UNDO.
  DEFINE VARIABLE lNewRow   AS LOG    NO-UNDO.

  IF pcKeyValues <> ? THEN 
  DO:
    lOk = DYNAMIC-FUNCTION('findRow':U IN TARGET-PROCEDURE,
                           pcKeyValues).
    IF NOT lOk THEN
      RETURN FALSE.
  END.

  cRowIdent = ENTRY(1,DYNAMIC-FUNCTION('colValues' IN TARGET-PROCEDURE,'':U),
                    CHR(1)).
  
  IF cRowIdent = ? THEN
    RETURN FALSE.

  {get NewRow lNewRow}.

  lOk = DYNAMIC-FUNCTION("submitRow":U IN TARGET-PROCEDURE, 
                          cRowIdent, 
                          pcValueList).

  IF lNewRow AND NOT lok THEN
    DYNAMIC-FUNCTION('cancelRow':U IN TARGET-PROCEDURE).  

  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

