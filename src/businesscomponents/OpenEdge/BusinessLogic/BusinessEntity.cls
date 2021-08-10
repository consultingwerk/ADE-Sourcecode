/**********************************************************************************************
*    Copyright (C) 2014-2019, 2021 by Progress Software Corporation. All rights reserved.           *
*    Prior versions of this work may contain portions contributed by participants of Possenet.*
***********************************************************************************************/
/*---------------------------------------------------------------------------------------------
    File        : BusinessEntity.cls
    Syntax      :
    Author(s)   : Maura Regan
    Created     : Tues Mar 04 11:50:26 EST 2014
    Notes       : Abstract class that contains generic methods performing CRUD operations
                  for Busines Entities
  --------------------------------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IGetDataResponse.
using Ccs.BusinessLogic.IGetResultCountResponse.
using Ccs.BusinessLogic.IGetTableResultCountResponse.
using Ccs.BusinessLogic.JoinEnum.
using OpenEdge.BusinessLogic.GetDataRequest.
using OpenEdge.BusinessLogic.GetDataResponse.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.GetDataTableResponse.
using OpenEdge.BusinessLogic.GetResultCountResponse.
using OpenEdge.BusinessLogic.GetTableResultCountResponse.
using OpenEdge.BusinessLogic.Query.QueryBuilder.
using OpenEdge.BusinessLogic.UpdateModeEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.

CLASS OpenEdge.BusinessLogic.BusinessEntity ABSTRACT:
    /* The dataset currently in use */
    DEFINE PROTECTED PROPERTY ProDataSet AS HANDLE NO-UNDO
            GET.
            SET.
    
    /* Stores a data source for each table in dataset. Should be in table order as defined in DataSet.
     * There must be a data source entry for each table in dataset. */
    DEFINE PROTECTED PROPERTY ProDataSource AS HANDLE NO-UNDO EXTENT
            GET.
            SET (INPUT hDataSrc AS HANDLE, INPUT idx AS INTEGER):
                IF  idx > ProDataSet:NUM-BUFFERS THEN
                    UNDO, THROW NEW Progress.Lang.AppError("ProDataSource's EXTENT value must equal number of buffers in DataSet.", 0).
                ProDataSource[idx] = hDataSrc.
            END SET.
            
    /* Stores skip-list entry for each table in dataset. Should be in table order as defined in DataSet.
     * Each skip-list entry is a comma-separated list of field names, to be ignored in create stmt. */
    DEFINE PROTECTED PROPERTY SkipList AS CHAR NO-UNDO EXTENT
            GET.
            SET (INPUT cSkip AS CHAR, INPUT idx AS INTEGER):
                IF  idx > ProDataSet:NUM-BUFFERS THEN
                    UNDO, THROW NEW Progress.Lang.AppError("SkipList's EXTENT value must equal number of buffers in DataSet.", 0).
                ELSE
                    SkipList[idx] = cSkip.
            END SET.
      
    /* BusinessEntity now supports 4 modes on how updates are performed:
     * TransactionalSubmit - where entire changeset is processed as single transaction.
     * BulkSubmit - where each row change is processed as a separate transaction.
     * CUD - client makes individual call to create, update or delete operation.
     * CUD_NOBI - client makes individual call to create, update or delete operation, but
     *            does not send/receive any BI data as part of request/response.
     *            This mode must support a single transaction, since there is no bi data sent
     */
    DEFINE PRIVATE PROPERTY UpdateMode AS UpdateModeEnum NO-UNDO
            GET.
            SET (INPUT mode AS UpdateModeEnum):
                UpdateMode = mode.
            END SET.
            
    /* Constructor
       
       @param handle The prodataset used by this BE */
    CONSTRUCTOR PROTECTED BusinessEntity(INPUT hDS AS HANDLE):
        ProDataSet = hDS.
        UpdateMode = UpdateModeEnum:UNDEFINED.
    END CONSTRUCTOR.
    
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to read data for the dataset.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ReadData(INPUT cFilter AS CHARACTER):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        
        THIS-OBJECT:AttachDataSources().
        
        /* Get rid of any existing data in DataSet */
        EmptyDataSet().
        
        cWhere = AdjustWhere(cFilter).
        
        /* Now set FILL-WHERE-STRING */
        SetFillWhereString(cWhere, ProDataSet:GET-TOP-BUFFER(1)).
       
        /* Finally, call FILL() for dataset  */
        ProDataSet:FILL().
        
        FINALLY:
            THIS-OBJECT:DetachDataSources().
        END FINALLY.
    END METHOD.
    
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to read data for the dataset with no filter specified.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ReadData():
        THIS-OBJECT:ReadData("").
    END METHOD.
    
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to read data for the dataset.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ReadData(INPUT cFilter AS CHARACTER EXTENT):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO EXTENT .
         
        THIS-OBJECT:AttachDataSources().
        
        /* Get rid of any existing data in DataSet */
        EmptyDataSet().
        
        cWhere = AdjustWheres(cFilter).
        
        /* Now set FILL-WHERE-STRINGs if applicable */
        SetFillWhereStrings(cWhere).
        
        /* Finally, call FILL() for dataset  */
        ProDataSet:FILL().
        
        FINALLY:
            THIS-OBJECT:DetachDataSources().
        END FINALLY.
          
    END METHOD.
    
    
     
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to read data for a table within a dataset.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ReadData(INPUT cFilter AS CHARACTER, INPUT hBuffer AS HANDLE):
        DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
        
        THIS-OBJECT:AttachDataSources().
        
        /* Get rid of any existing data in table */
        hBuffer:EMPTY-TEMP-TABLE().
        
        cWhere = AdjustWhere(cFilter).
        
        /* Now set FILL-WHERE-STRING if applicable */
        SetFillWhereString(cWhere, hBuffer).
        
        /* Finally, call FILL() for buffer's table */
        hBuffer:FILL().
        
        FINALLY:
            THIS-OBJECT:DetachDataSources().
        END FINALLY.
          
    END METHOD.
   
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to read data for a table within a dataset with no filter specified.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ReadData(INPUT hBuffer AS HANDLE):
        THIS-OBJECT:ReadData("", hBuffer).
    END METHOD.
    
    
    /*--------------------------------------------------------------------------------------------------------
            Purpose:  Generic routine to empty from the dataset.
            Notes:
     ---------------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID EmptyDataSet():
        
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE hCurBuffer AS HANDLE NO-UNDO.
        
        /* Get rid of any existing data in DataSet */
         REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            hCurBuffer:EMPTY-TEMP-TABLE().
        END.
    END METHOD.
    
     /*------------------------------------------------------------------------------
            Purpose: Create one or more new records
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID CreateData(INPUT-OUTPUT DATASET-HANDLE hDataSet):
         DEFINE VARIABLE hPDS AS HANDLE NO-UNDO.
         {&_proparse_ prolint-nowarn(varusage)}
         DEFINE VARIABLE saveUndos AS LOGICAL EXTENT NO-UNDO.
         
         /* if the Create-, Update- or DeleteData operation was called BY-REFERENCE
            we will have a different dataset than the one in the property. We want to work
            on the one was sent, not the one that's there :) */
         IF THIS-OBJECT:ProDataSet NE hDataSet THEN
            ASSIGN hPDS                   = THIS-OBJECT:ProDataSet
                   THIS-OBJECT:ProDataSet = hDataSet:HANDLE.

         // UNDO attrs needs to be false to preserve ERROR and REJECTED
         SetUndos(saveUndos, FALSE).
         
        THIS-OBJECT:AttachDataSources().
         
        DO TRANSACTION ON ERROR UNDO, THROW:
            // ProcessBIData() determines if BI data was sent as part of request.
            // If not sent, it adds it. BI data is required when calling SAVE-ROW-CHANGES()
            IF ProcessBIData(ROW-CREATED) EQ TRUE THEN
                UpdateMode = UpdateModeEnum:CUD.
            ELSE
                UpdateMode = UpdateModeEnum:CUD_NOBI.
            
            THIS-OBJECT:CommitData(ROW-CREATED).
        END.
        
        CATCH e AS CLASS Progress.Lang.Error:
           ProcessTransactionalError(e).
        END.
                                 
        FINALLY:
            THIS-OBJECT:DetachDataSources().
            
            // Reset undos to orig values
            SetUndos(saveUndos, ?).
            
            /* reset if we used a different PDS */
            if valid-handle(hPDS) then
                assign this-object:ProDataSet = hPDS.
        END FINALLY.
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Purpose: Update one or more new records
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID UpdateData(INPUT-OUTPUT DATASET-HANDLE hDataSet):
          DEFINE VARIABLE hPDS AS HANDLE NO-UNDO.
          {&_proparse_ prolint-nowarn(varusage)}
          DEFINE VARIABLE saveUndos AS LOGICAL EXTENT NO-UNDO.
         
         /* if the Create-, Update- or DeleteData operation was called BY-REFERENCE
            we will have a different dataset than the one in the property. We want to work
            on the one was sent, not the one that's there :) */
         IF THIS-OBJECT:ProDataSet NE hDataSet THEN
            ASSIGN hPDS                   = THIS-OBJECT:ProDataSet
                   THIS-OBJECT:ProDataSet = hDataSet:HANDLE.
           
         // UNDO attrs needs to be false to preserve ERROR and REJECTED
         SetUndos(saveUndos, FALSE).

         THIS-OBJECT:AttachDataSources().
         
         DO TRANSACTION ON ERROR UNDO, THROW:
            // ProcessBIData() determines if BI data was sent as part of request.
            // If not sent, it adds it. BI data is required when calling SAVE-ROW-CHANGES()
            IF ProcessBIData(ROW-MODIFIED) EQ TRUE THEN
                UpdateMode = UpdateModeEnum:CUD.
            ELSE
                UpdateMode = UpdateModeEnum:CUD_NOBI.
         
            THIS-OBJECT:CommitData(ROW-MODIFIED).
         END.
         
         CATCH e AS CLASS Progress.Lang.Error:
           ProcessTransactionalError(e).
         END.
                                 
         FINALLY:
            THIS-OBJECT:DetachDataSources().
            
            // Reset undos to orig values
            SetUndos(saveUndos, ?).
        
             /* reset if we used a different PDS */
             if valid-handle(hPDS) then
                assign this-object:ProDataSet = hPDS.
        END FINALLY.
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete one or more records
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID DeleteData(INPUT-OUTPUT DATASET-HANDLE hDataSet):
         DEFINE VARIABLE hPDS AS HANDLE NO-UNDO.
         {&_proparse_ prolint-nowarn(varusage)}
         DEFINE VARIABLE saveUndos AS LOGICAL EXTENT NO-UNDO.
         
         /* if the Create-, Update- or DeleteData operation was called BY-REFERENCE
            we will have a different dataset than the one in the property. We want to work
            on the one was sent, not the one that's there :) */
         IF THIS-OBJECT:ProDataSet NE hDataSet THEN
            ASSIGN hPDS                   = THIS-OBJECT:ProDataSet
                   THIS-OBJECT:ProDataSet = hDataSet:HANDLE.
                   
         // UNDO attrs needs to be false to preserve ERROR and REJECTED
         SetUndos(saveUndos, FALSE).
         
        THIS-OBJECT:AttachDataSources().
        
        DO TRANSACTION ON ERROR UNDO, THROW:
            // ProcessBIData() determines if BI data was sent as part of request.
            // If not sent, it adds it. BI data is required when calling SAVE-ROW-CHANGES()
            IF ProcessBIData(ROW-DELETED) EQ TRUE THEN
                UpdateMode = UpdateModeEnum:CUD.
            ELSE
                UpdateMode = UpdateModeEnum:CUD_NOBI.
            
            THIS-OBJECT:CommitData(ROW-DELETED).
        END.
        
        CATCH e AS CLASS Progress.Lang.Error:
           ProcessTransactionalError(e).
        END.
                                 
        FINALLY:
            THIS-OBJECT:DetachDataSources().
            
            // Reset undos to orig values
            SetUndos(saveUndos, ?).
        
             /* reset if we used a different PDS */
             if valid-handle(hPDS) then
                assign this-object:ProDataSet = hPDS.
        END FINALLY.
    END METHOD.
    
    
    /*---------------------------------------------------------------------------------------
            Purpose: Checks if ProDataSet was sent with bi data, returning TRUE or FALSE.
                     
            Notes:   It validates that all temp-tables are consistent in their usage of
                     before-image data, meaning either they all have it or don't.
                     If there is any inconsistency, an exception is thrown.
                     
                     Also, if no bi data was sent, then it's created based on iRowState param.
                     Before-Image data is a requirement in order to call SAVE-ROW-CHANGES()
    ----------------------------------------------------------------------------------------*/
     METHOD PRIVATE LOGICAL ProcessBIData(INPUT iRowState AS INTEGER):
     
          DEFINE VAR iIndex AS INTEGER NO-UNDO.
          DEFINE VAR hBuffer AS HANDLE NO-UNDO.
          DEFINE VAR hBeforeBuffer AS HANDLE NO-UNDO.
          DEFINE VAR lAvailable AS LOGICAL NO-UNDO.
          DEFINE VAR lReturnValue AS LOGICAL NO-UNDO.
          DEFINE VAR hAfterQuery  AS HANDLE EXTENT NO-UNDO.
          DEFINE VAR lHasBIData AS LOGICAL INIT ? NO-UNDO.
          
          EXTENT(hAfterQuery) = ProDataSet:NUM-BUFFERS.
          
          REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            // Only need to worry about tables that have data-source attached..
            IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                hBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
                hBeforeBuffer = hBuffer:BEFORE-BUFFER.

                IF hBeforeBuffer EQ ? THEN
                    UNDO, THROW NEW
                    Progress.Lang.AppError("To use BusinessEntity CUD functionality, temp-tables must be specified with BEFORE-TABLE.", 0).
            
                // Check for before-image rows. Skip over tables that have no rows at all
                IF hBuffer:TABLE-HANDLE:HAS-RECORDS OR hBeforeBuffer:TABLE-HANDLE:HAS-RECORDS THEN DO:
            
                    IF lHasBIData EQ ? THEN DO:
                        lHasBIData = hBeforeBuffer:TABLE-HANDLE:HAS-RECORDS.
                    END.
                    ELSE IF lHasBIData NE hBeforeBuffer:TABLE-HANDLE:HAS-RECORDS THEN DO:
                        UNDO, THROW NEW Progress.Lang.AppError("To use BusinessEntity CUD functionality, all temp-tables must have same setting of before-image data", 0).
                    END.
                END.
              END.
          END.
          
          // If no bi data, then create it..
          IF lHasBIData EQ FALSE AND iRowState NE ? THEN DO:
              REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
                  // Only need to worry about tables that have data-source attached..
                  IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                      hBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).

                      CREATE QUERY hAfterQuery[iIndex].
                      hAfterQuery[iIndex]:SET-BUFFERS(hBuffer).
                      lReturnValue = hAfterQuery[iIndex]:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1', hBuffer:NAME)).
                      lReturnValue = hAfterQuery[iIndex]:QUERY-OPEN().
                      lAvailable = hAfterQuery[iIndex]:GET-FIRST().
            
                      DO WHILE lAvailable:
                          /* Note: If a before-table row already exists, MARK-ROW-STATE() is a no-op */
                          lReturnValue = hBuffer:MARK-ROW-STATE(iRowState)
                                         // NO-ERROR is required, otherwise this statement 'fails' like a FIND, aka not
                                         // properly/well
                                         no-error.
                          
                          IF NOT lReturnValue THEN
                              UNDO, THROW NEW Progress.Lang.AppError('Unable to ' + GetRowState(iRowState) +
                                   ' record. Cannot create corresponding row in BEFORE-TABLE.', 0).
                          
                          lAvailable = hAfterQuery[iIndex]:GET-NEXT()
                                       // reset the ERROR-STATUS from above
                                       no-error.
                      END.
                  END.
              END.  // END REPEAT
          END.
          
          FINALLY:
              REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
                  IF VALID-HANDLE(hAfterQuery[iIndex]) THEN
                      DELETE OBJECT hAfterQuery[iIndex].
              END.
              {&_proparse_ prolint-nowarn(returnfinally)}
              RETURN lHasBIData.
          END FINALLY.
    END METHOD.

    /*----------------------------------------------------------------------------------------
            Purpose:  Saves/Submits one or more changed rows (creates, updates, and/or deletes)
                      where each changed row is processed as a separate transaction.
                      SaveRows() is similar to Submit(), but acts as a bulk submit, with separate
                      row transactions.
            Notes:
            
                                                         
    -----------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID SaveRows(INPUT-OUTPUT DATASET-HANDLE hDataSet):
        DEFINE VARIABLE hPDS AS HANDLE NO-UNDO.
         
        /* If the Create-, Update- or DeleteData operation was called BY-REFERENCE
          we will have a different dataset than the one in the property. We want to work
          on the one was sent, not the one that's there :) */
       IF THIS-OBJECT:ProDataSet NE hDataSet THEN
          ASSIGN hPDS = THIS-OBJECT:ProDataSet
                 THIS-OBJECT:ProDataSet = hDataSet:HANDLE.
    
       THIS-OBJECT:AttachDataSources().
      
       UpdateMode = UpdateModeEnum:BULK_SUBMIT.
         
       /* Do deletes first, next creates, and finally modifies */
       THIS-OBJECT:CommitData(ROW-DELETED).
       THIS-OBJECT:CommitData(ROW-CREATED).
       THIS-OBJECT:CommitData(ROW-MODIFIED).
          
        FINALLY:
            THIS-OBJECT:DetachDataSources().
        
             /* reset if we used a different PDS */
             if valid-handle(hPDS) then
                assign this-object:ProDataSet = hPDS.
        END FINALLY.
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose:  Submits one or more changed records (creates, updates, and/or deletes)
                      where the changed record set is processed as a single transaction.
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID Submit(INPUT-OUTPUT DATASET-HANDLE hDataSet):
         DEFINE VARIABLE hPDS AS HANDLE NO-UNDO.
         {&_proparse_ prolint-nowarn(varusage)}
         DEFINE VARIABLE saveUndos AS LOGICAL EXTENT NO-UNDO.

       /* If the Create-, Update- or DeleteData operation was called BY-REFERENCE
          we will have a different dataset than the one in the property. We want to work
          on the one was sent, not the one that's there :) */
       IF THIS-OBJECT:ProDataSet NE hDataSet THEN
          ASSIGN hPDS = THIS-OBJECT:ProDataSet
                 THIS-OBJECT:ProDataSet = hDataSet:HANDLE.
         
       // UNDO attrs needs to be false to preserve ERROR and REJECTED
       SetUndos(saveUndos, FALSE).
         
       THIS-OBJECT:AttachDataSources().
       
       UpdateMode = UpdateModeEnum:TRANSACTIONAL_SUBMIT.
  
       DO TRANSACTION ON ERROR UNDO, THROW:
           /* Do deletes first, next creates, and finally modifies */
           THIS-OBJECT:CommitData(ROW-DELETED).
           THIS-OBJECT:CommitData(ROW-CREATED).
           THIS-OBJECT:CommitData(ROW-MODIFIED).
       END.
       
       CATCH e AS CLASS Progress.Lang.Error:
           ProcessTransactionalError(e).
       END.
 
       FINALLY:
            THIS-OBJECT:DetachDataSources().
            
            // Reset undos to orig values
            SetUndos(saveUndos, ?).

            /* Reset if we used a different PDS */
            IF VALID-HANDLE(hPDS) THEN
                ASSIGN this-object:ProDataSet = hPDS.
       END FINALLY.
       
    END METHOD.
    
    /*-----------------------------------------------------------------------------------------
            Purpose:  ProcessTransactionalError() is called when we are processing a single
                      transaction, and an error occurs for one of the row changes.
                      When this occurs, all rows should have REJECTED set to TRUE,
                      and the error message should be set on the offending row.
            Notes:    If there is no bi data being sent between client and server (CUD_NOBI),
                      then we throw the error (resulting in http 500 error),
                      and we also must back out all changes.
     ------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ProcessTransactionalError(INPUT err AS Progress.Lang.Error):
                                           
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        DEFINE VAR hBuffer AS HANDLE NO-UNDO.
        DEFINE VAR hBeforeBuffer AS HANDLE NO-UNDO.
        DEFINE VAR lAvailable AS LOGICAL NO-UNDO.
        DEFINE VAR hBeforeQuery AS HANDLE EXTENT NO-UNDO.
        DEFINE VAR cErrMessage AS CHAR NO-UNDO.
        DEFINE VAR appError AS Progress.Lang.AppError NO-UNDO.
        
        EXTENT(hBeforeQuery) = ProDataSet:NUM-BUFFERS.
        
        cErrMessage = err:GetMessage(1).
        // Check to see if ReturnValue set
        IF (cErrMessage EQ ? OR LENGTH(cErrMessage) EQ 0) AND TYPE-OF(err, Progress.Lang.AppError) THEN DO:
            appError = CAST(err, Progress.Lang.AppError).
            cErrMessage = appError:ReturnValue.
        END.

        // If UpdateMode was never set, don't bother setting REJECTED attributes.
        // Error happened before we got a chance to call SAVE-ROW-CHANGES()
        IF UpdateMode NE UpdateModeEnum:UNDEFINED THEN DO:
            REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
                // Only need to worry about tables that have data-source attached..
                IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                    hBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
                    hBeforeBuffer = hBuffer:BEFORE-BUFFER.

                    CREATE QUERY hBeforeQuery[iIndex].
                    hBeforeQuery[iIndex]:SET-BUFFERS(hBeforeBuffer).
        
                    hBeforeQuery[iIndex]:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1', hBeforeBuffer:NAME)).
                    hBeforeQuery[iIndex]:QUERY-OPEN().
                    lAvailable = hBeforeQuery[iIndex]:GET-FIRST().
        
                    DO WHILE lAvailable:
                        hBeforeBuffer:REJECTED = TRUE.
                        IF hBeforeBuffer:ERROR EQ TRUE THEN DO:
                           hBeforeBuffer:ERROR-STRING = GetRowErrorMessage(hBeforeBuffer, cErrMessage).
                        END.
                        lAvailable = hBeforeQuery[iIndex]:GET-NEXT().
                    END.
                END.
            END.
        END.
        ELSE DO:
          cErrMessage = "Unable to call SAVE-ROW-CHANGES(). " + cErrMessage.
        END.
        
        IF UpdateMode EQ UpdateModeEnum:CUD_NOBI OR UpdateMode EQ UpdateModeEnum:UNDEFINED THEN DO:
            UNDO, THROW NEW Progress.Lang.AppError(cErrMessage, 0).
        END.
        
        FINALLY:
            REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
                IF VALID-HANDLE(hBeforeQuery[iIndex]) THEN
                    DELETE OBJECT hBeforeQuery[iIndex].
            END.
        END FINALLY.
              
    END METHOD.
    
    /*------------------------------------------------------------------------------------------------
            Purpose: If errMessage param is not set, create an error message for the current bi row
            Notes:
    -------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE CHAR GetRowErrorMessage(INPUT hBeforeBuffer AS HANDLE, INPUT errMessage AS CHAR):
        // Want to ensure that we always return an error message when a create, update, or delete record fails
        // when calling SAVE-ROW-CHANGES
        
        IF errMessage EQ ? OR LENGTH(errMessage) EQ 0 THEN
            errMessage = 'Unable to ' + GetRowState(hBeforeBuffer:ROW-STATE) +
                                   ' record in the database during SAVE-ROW-CHANGES().'.
        
        RETURN errMessage.
                                    
    END METHOD.


    /*---------------------------------------------------------------------------------------
            Purpose:  Generic routine to save or commit data for a dataset.
            Notes:
     ----------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID CommitData(INPUT iRowState AS INTEGER):
                                           
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        DEFINE VAR iTopBufferCnt AS INTEGER NO-UNDO.
        DEFINE VAR hBuffer AS HANDLE NO-UNDO.
        DEFINE VAR cSkip AS CHAR NO-UNDO.
                      
        iTopBufferCnt = ProDataSet:NUM-TOP-BUFFERS.
        DO iIndex = 1 TO iTopBufferCnt:
            hBuffer = ProDataSet:GET-TOP-BUFFER (iIndex).
            
            IF VALID-HANDLE(hBuffer:DATA-SOURCE) THEN
                CASE iRowState:
                    WHEN ROW-CREATED THEN DO:
                        /* Commit creates for parent. First get index into entire list of buffers */
                        cSkip = GetSkipListEntry(GetBufferIndex(hBuffer)).
                       
                        CommitRows(hBuffer, cSkip, iRowState).
                        /* Now commit creates for any child buffer */
                        CommitChildBuffers(iIndex, iRowState).
                    END.
                    WHEN ROW-MODIFIED OR WHEN ROW-DELETED THEN DO:
                        /* First  modify or delete child records, then modify parent records */
                        CommitChildBuffers(iIndex, iRowState).
                        /* Now modify or delete parent records */
                        CommitRows(hBuffer, "", iRowState).
                    END.
                END CASE.
            
        END.
                                     
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose: Attach Data Sources to  DataSet's buffers
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID AttachDataSources():
        
        ValidateDataSources().
        
        DEFINE VARIABLE hCurBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
           
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            // Only need to worry about tables that have data-source attached..
            IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
                hCurBuffer:ATTACH-DATA-SOURCE(ProDataSource[iIndex]).
            END.
        END.
                                    
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Purpose: Attach Data Sources to  DataSet's buffers
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID AttachDataSources(INPUT cFieldList AS CHAR EXTENT):
        
        DEFINE VARIABLE hCurBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        
        ValidateDataSources().
        ValidateFieldLists(INPUT-OUTPUT cFieldList).
                 
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            // Only need to worry about tables that have data-source attached..
            IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
                hCurBuffer:ATTACH-DATA-SOURCE(ProDataSource[iIndex], cFieldList[iIndex]).
            END.
        END.
                                    
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose: Detach Data Sources from DataSet's buffers
            Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID DetachDataSources():
    
        DEFINE VARIABLE hCurBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
           
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            // Only need to worry about tables that have data-source attached..
            IF VALID-HANDLE(ProDataSource[iIndex]) THEN DO:
                hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
                hCurBuffer:DETACH-DATA-SOURCE().
            END.
        END.
                                    
    END METHOD.
    
    /*-----------------------------------------------------------------------------------
            Purpose: Must verify that ProDataSource contains a data source entry for each
                     table specified in dataset. Also verify that they are valid handles.
                     A data source entry can be set to UNKNOWN as well, as allow for that.
            Notes:
    ------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ValidateDataSources():
        
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        
        IF ProDataSet:NUM-BUFFERS NE EXTENT(ProDataSource) THEN
            UNDO, THROW NEW Progress.Lang.AppError("ProDataSource's EXTENT value must equal number of buffers in DataSet.", 0).
           
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            IF ProDataSource[iIndex] NE ? AND NOT VALID-HANDLE(ProDataSource[iIndex]) THEN
                UNDO, THROW NEW Progress.Lang.AppError("ProDataSource extent value must be a valid DataSource Handle.", 0).
        END.
                                    
    END METHOD.
    
    
    /*-------------------------------------------------------------------------------------------------
            Purpose: Must verify that cFieldList's EXTENT value is same as number of buffers in dataset
            Notes:
    --------------------------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID ValidateFieldLists(INPUT-OUTPUT cFieldList AS CHAR EXTENT):
        
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        
        IF ProDataSet:NUM-BUFFERS NE EXTENT(cFieldList) THEN
            UNDO, THROW NEW Progress.Lang.AppError("cFieldList's EXTENT value must equal number of buffers in DataSet.", 0).
           
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:
            IF cFieldList[iIndex] EQ ? THEN
                cFieldList[iIndex] = "".
        END.
                                    
    END METHOD.
    
    
    /*-----------------------------------------------------------------------------------------------
            Purpose:  Returns the skip-list entry from array for specified buffer index.
            Notes:    Skip-list entries in array should be in temp-table order as defined in DataSet.
    ------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE CHARACTER GetSkipListEntry (INPUT iBufferIndex AS INTEGER):
               
        DEFINE VAR cSkip AS CHAR NO-UNDO.
        
        IF EXTENT(SkipList) NE ? AND iBufferIndex > 0 AND iBufferIndex <= EXTENT(ProDataSource) THEN DO:
            IF SkipList[iBufferIndex] NE ? THEN
                cSkip =  SkipList[iBufferIndex].
        END.
        
        RETURN cSkip.
                                              
    END METHOD.
    
    
    
    /*------------------------------------------------------------------------------------------
            Purpose:  Walks through specifed dataset's data-relations to find child tables for
                      specified parent table. For each child table, it then calls commitRows().
            Notes:
    ---------------------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID CommitChildBuffers(INPUT iParentBufferIndex AS INTEGER,
                                           INPUT iRowState AS INTEGER):
                                               
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        DEFINE VAR iRelationCnt AS INTEGER NO-UNDO.
        DEFINE VAR hRelation AS HANDLE NO-UNDO.
        DEFINE VAR hParentBuffer AS HANDLE NO-UNDO.
        DEFINE VAR cSkip AS CHAR NO-UNDO.
        DEFINE VAR iChildBufferIndex AS INTEGER NO-UNDO.
        
        hParentBuffer = ProDataSet:GET-BUFFER-HANDLE (iParentBufferIndex).
        iRelationCnt = ProDataSet:NUM-RELATIONS.
                    
        DO iIndex = 1 TO iRelationCnt:
            hRelation = ProDataSet:GET-RELATION(iIndex).
            IF hRelation:PARENT-BUFFER EQ hParentBuffer AND hRelation:ACTIVE THEN DO:
                IF iRowState EQ ROW-CREATED THEN DO:
                    iChildBufferIndex = GetBufferIndex(hRelation:CHILD-BUFFER).
                    cSkip = GetSkipListEntry(iChildBufferIndex).
                END.
                ELSE
                    cSkip = "".
                    
                commitRows(hRelation:CHILD-BUFFER, cSkip, iRowState).
            END.
        END.
    
    END METHOD.
    
     /*------------------------------------------------------------------------------------------
            Purpose:  Walks through dataset's buffers and returns index for specified buffer.
            Notes:
    ---------------------------------------------------------------------------------------------*/
    METHOD PRIVATE INTEGER GetBufferIndex(INPUT hBuffer AS HANDLE):
                                               
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        DEFINE VAR iBufferCnt AS INTEGER NO-UNDO.
        DEFINE VAR hCurBuffer AS HANDLE NO-UNDO.
        DEFINE VAR iBufferIndex AS INTEGER NO-UNDO INIT 0.
         
        iBufferCnt = ProDataSet:NUM-BUFFERS.
        DO iIndex = 1 TO iBufferCnt:
            hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            IF hCurBuffer:NAME EQ hBuffer:NAME THEN
                iBufferIndex = iIndex.
        END.
        
        RETURN iBufferIndex.
        
        END METHOD.
        
        
    /*------------------------------------------------------------------------------------------
            Purpose:  Generic routine for creating/updating/deleting rows for specified table
            Notes:
    ---------------------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID CommitRows(INPUT hBuffer AS HANDLE,
                                   INPUT cSkip AS CHAR,
                                   INPUT iRowState AS INTEGER):
                                       
        DEFINE VARIABLE hBeforeBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE hBeforeQuery AS HANDLE NO-UNDO.
        DEFINE VARIABLE lAvailable AS LOGICAL NO-UNDO.
        DEFINE VARIABLE cErrMessage AS CHAR NO-UNDO.
        DEFINE VARIABLE appError AS Progress.Lang.AppError NO-UNDO.
       
        hBeforeBuffer = hBuffer:BEFORE-BUFFER.
        
        IF hBeforeBuffer EQ ? THEN
            UNDO, THROW NEW
            Progress.Lang.AppError("In order to use BusinessEntity CUD functionality, temp-tables must be specified with BEFORE-TABLE.", 0).
        
        CREATE QUERY hBeforeQuery.
        hBeforeQuery:SET-BUFFERS(hBeforeBuffer).
        
        /* We're only concerned with rows with iRowState */
        hBeforeQuery:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE ROW-STATE(&1) EQ &2', hBeforeBuffer:NAME, iRowState)).
        hBeforeQuery:QUERY-OPEN().
        lAvailable = hBeforeQuery:GET-FIRST().
        
        /* Once here, we have before-table rows, with first row in before-buffer.
         * For CUD, CUD_NOBI, and TRANSACTIONAL_SUBMIT modes, all changes are processed in single transaction.
         *
         * Note: For CUD_NOBI, we can only process changes in a single transaction, since there is no bi data
         * exchanged between client and server. If error occurs, we throw exception (resulting in http 500 error),
         * so we must back out all changes.
         */
        IF UpdateMode NE UpdateModeEnum:BULK_SUBMIT THEN DO:
            DO WHILE lAvailable ON ERROR UNDO, THROW:
                hBeforeBuffer:SAVE-ROW-CHANGES(1, cSkip).
                lAvailable = hBeforeQuery:GET-NEXT().
            END.
        END.
        /* For BULK_SUBMIT mode, each row change is processed as a separate transaction */
        ELSE DO:
            DO WHILE lAvailable ON ERROR UNDO, LEAVE:
                DO TRANSACTION:
                    hBeforeBuffer:SAVE-ROW-CHANGES(1, cSkip).
                    
                    CATCH e AS CLASS Progress.Lang.Error:
                        hBeforeBuffer:ERROR = TRUE.
                        hBeforeBuffer:REJECTED = TRUE.
                        
                        cErrMessage = e:GetMessage(1).
                        // Check to see if ReturnValue set
                        IF (cErrMessage EQ ? OR LENGTH(cErrMessage) EQ 0) AND TYPE-OF(e, Progress.Lang.AppError) THEN DO:
                            appError = CAST(e, Progress.Lang.AppError).
                            cErrMessage = appError:ReturnValue.
                        END.
                        hBeforeBuffer:ERROR-STRING = GetRowErrorMessage(hBeforeBuffer, cErrMessage).
                    END.
                END.
        
                lAvailable = hBeforeQuery:GET-NEXT().
            END.
             
        END.
        
        FINALLY:
          IF VALID-HANDLE(hBeforeQuery) THEN
              DELETE OBJECT hBeforeQuery.
        END FINALLY.
        
    END METHOD.
    

/*--------------------------------------------------------------------------------------------------
           Purpose:
            Notes:
  -------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE CHARACTER GetRowState(INPUT iRowState AS INTEGER):
         DEFINE VARIABLE cRowState AS CHARACTER NO-UNDO.
         
         CASE iRowState:
             WHEN ROW-DELETED THEN
                 cRowState = "Delete".
             WHEN ROW-CREATED THEN
                 cRowState = "Create".
             WHEN ROW-MODIFIED THEN
                 cRowState = "Update".
             /* This should never happen... */
             OTHERWISE
                 cRowState = "Unexpected-RowState".
           
         END CASE.
         
         RETURN cRowState .
    END METHOD.
    

/*--------------------------------------------------------------------------------------------------
            Purpose:
            Notes:
  -------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE CHARACTER AdjustWhere(INPUT cFilter AS CHARACTER):
         DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
         
         IF cFilter BEGINS "WHERE " THEN
                 cWhere = cFilter.
             ELSE IF cFilter NE "" THEN
                 cWhere = "WHERE " + cFilter.
         
         RETURN cWhere.
    END METHOD.
    
    
/*--------------------------------------------------------------------------------------------------
            Purpose:
            Notes:
  -------------------------------------------------------------------------------------------------*/
     METHOD PRIVATE CHARACTER EXTENT AdjustWheres(INPUT cFilter AS CHARACTER EXTENT):
         DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO EXTENT.
         DEFINE VAR iBufferCnt AS INTEGER NO-UNDO.
         DEFINE VAR iIndex AS INTEGER NO-UNDO.
         
         iBufferCnt = ProDataSet:NUM-BUFFERS.
         EXTENT(cWhere) = iBufferCnt.
        
         DO iIndex = 1 TO iBufferCnt:
             cWhere[iIndex] = AdjustWhere(cFilter[iIndex]).
         END.
         
         RETURN cWhere.
    END METHOD.
    
    /* Adds a FILL-WHERE-STRING to a datasource
       
       @param character The where (filter) string to apply to buffer
       @param handpe A buffer handle in the dataset */
    METHOD PROTECTED VOID SetFillWhereString(INPUT cWhere AS CHARACTER,
                                             INPUT hBuffer AS HANDLE):
        DEFINE VARIABLE hDataSrc AS HANDLE NO-UNDO.
        
        /* Set FILL-WHERE-STRING if applicable */
        IF cWhere NE "" AND cWhere NE ? AND VALID-HANDLE(hBuffer:DATA-SOURCE) THEN
            // to combine data-relation fill-where-clause queries- "natural phrase" + "user query" = "merged"
            // If there are relations between tables in a dataset, the AVM adds a filter clause to the FILL-WHERE-STRING
            // when the datasources are attached.
            // We want to preserve those where clauses since we don't want to
            // a) return more records from the DB than match the combined where, especially with networked DBs
            // b) hold more records in memory in the session than needed
            assign hDataSrc                   = hBuffer:data-source
                   hDataSrc:fill-where-string = new QueryBuilder():MergeQueryStrings(cWhere,
                                                                                     JoinEnum:And,
                                                                                     hDataSrc:fill-where-string)
                   .
    END METHOD.
    
    /*--------------------------------------------------------------------------------------------------
            Purpose:
            Notes:
  -------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID SetFillWhereStrings(INPUT cWhere AS CHARACTER EXTENT):
        
        DEFINE VAR iBufferCnt AS INTEGER NO-UNDO.
        DEFINE VAR hBuffer AS HANDLE NO-UNDO.
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        
        iBufferCnt = ProDataSet:NUM-BUFFERS.
        DO iIndex = 1 TO iBufferCnt:
            hBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            SetFillWhereString(cWhere[iIndex], hBuffer).
        END.
    END METHOD.
    
    /*--------------------------------------------------------------------------------------------------
            Purpose: This method is used to set the UNDO attribute for all temp-tables in the ProDataSet.
                     With the addition of the the one transaction capability, the UNDO attributes need to
                     be set to FALSE to preserve the ERROR and REJECTED attributes, which are now sent to
                     backend.
                     
                     If the lUndos array parameter has been set appropriately, the method will use it to
                     restore the UNDO attributes (ignoring undoValue parameter).
                     
                     If lUndos has not been set, the method will set the UNDO attributes using undoValue,
                     and return the original UNDO attr values in lUndos.
            Notes:
     ---------------------------------------------------------------------------------------------------*/

    METHOD PRIVATE VOID SetUndos(INPUT-OUTPUT lUndos AS LOGICAL EXTENT, INPUT undoValue AS LOGICAL):
        
        DEFINE VAR iBufferCnt AS INTEGER NO-UNDO.
        DEFINE VAR hBuffer AS HANDLE NO-UNDO.
        DEFINE VAR iIndex AS INTEGER NO-UNDO.
        DEFINE VAR lSaveUndos AS LOGICAL INIT FALSE NO-UNDO.
        
        iBufferCnt = ProDataSet:NUM-BUFFERS.
        
        IF EXTENT(lUndos) EQ ? THEN DO:
            EXTENT(lUndos) = iBufferCnt.
            lSaveUndos = TRUE.
        END.
     
        DO iIndex = 1 TO iBufferCnt:
            hBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            
            IF lSaveUndos EQ TRUE THEN DO:
                lUndos[iIndex] = hBuffer:TABLE-HANDLE:UNDO.
                hBuffer:TABLE-HANDLE:UNDO = undoValue.
            END.
            /* Resetting them */
            ELSE DO:
               hBuffer:TABLE-HANDLE:UNDO = lUndos[iIndex].
            END.
        END.
    END METHOD.

    /* Generic read data routine using a filter object (instead of strings).
       This supports CCS-compliant BE's.
       
       @param IGetDataRequest The filter to apply.
       @param IGetDataResponse Response object.  */
    method protected IGetDataResponse ReadData(input pGetRequest as IGetDataRequest):
        define variable tbl as handle no-undo.
        define variable cnt as integer no-undo.
        define variable idx as integer no-undo.
        define variable loop as integer no-undo.
        define variable bufferList as character no-undo.
        define variable startRowid as rowid no-undo.
        define variable qb as QueryBuilder no-undo.
        define variable gdr as GetDataResponse no-undo.
        define variable gdtr as GetDataTableResponse no-undo.
        
        Assert:NotNull(pGetRequest, 'Get request').
        
        /* Get rid of any existing data in DataSet */
        EmptyDataSet().
        AttachDataSources().
        
        assign cnt        = ProDataSet:num-buffers
               gdr        = new GetDataResponse(cnt)
               qb         = new QueryBuilder()
               // pre-fill the spaces: we need an entry for the name and the serialize-name
               bufferList = fill(',':u, 2 * cnt - 1)
               .
        do loop = 1 to cnt:
            assign tbl                           = ProDataSet:get-buffer-handle(loop)
                   entry(loop,       bufferList) = tbl:serialize-name
                   entry(loop + cnt, bufferList) = tbl:name
                   // create a response for each buffer in the dataset
                   gdtr                     = new GetDataTableResponse(tbl:serialize-name)
                   gdr:TableResponses[loop] = gdtr
                   .
        end.
        
        assign cnt = extent(pGetRequest:TableRequests).
        do loop = 1 to cnt:
            assign idx = lookup(pGetRequest:TableRequests[loop]:TableName, bufferList).
            if idx gt cnt then
                assign idx = idx - cnt.
            else
            // use the first top buffer if no name is specified
            if idx eq 0
            and pGetRequest:TableRequests[loop]:TableName eq '':u
            then
                assign idx = lookup(ProDataSet:get-top-buffer(1):serialize-name, bufferList).
            
            // if the table is in this dataset, set the table request values to the input
            if idx gt 0 then
            do:
                assign tbl            = ProDataSet:get-buffer-handle(idx)
                       tbl:batch-size = pGetRequest:TableRequests[loop]:NumRecords
                       startRowid     = to-rowid(pGetRequest:TableRequests[loop]:PagingContext)
                       
                       // set the ROWID (not the input param value) to the PreviousPagingContext, since that's what is used
                       cast(gdr:TableResponses[idx], GetDataTableResponse):PreviousPagingContext = string(startRowid)
                       .
                if not startRowid eq ?
                and valid-handle(tbl:data-source)
                then
                    assign tbl:data-source:restart-rowid = startRowid.
                
                // apply the filter: empty will return WHERE TRUE
                SetFillWhereString(qb:BuildQueryString(pGetRequest:TableRequests[loop], yes, yes, tbl),
                                   tbl).
            end.
        end.
        
        // get all the data
        DoFill(ProDataSet).
        
        assign cnt = ProDataSet:num-buffers.
        do loop = 1 to cnt:
            assign tbl = ProDataSet:get-buffer-handle(loop).
            if  valid-handle(tbl:data-source)
            and not tbl:data-source:next-rowid eq ?
            then
                assign cast(gdr:TableResponses[loop], GetDataTableResponse):NextPagingContext = string(tbl:data-source:next-rowid).
        end.
        
        return gdr.
        finally:
            DetachDataSources().
        end finally.
    end method.
    
    /* Performs the dataset or buffer FILL() operation.
       
       @param handle A valid DATASET or BUFFER handle. */
    method protected void DoFill(input pDataset as handle):
        Assert:NotNull(pDataset, 'Handle').
        
        if not pDataset:type eq 'dataset':u
        and not pDataset:type eq 'buffer':u
        then
            undo, throw new AssertionFailedError(substitute('Handle must be a DATASET or BUFFER, not &1', pDataset:type)).
        
        pDataset:fill().
    end method.
    
    /* Returns the count of the total number of result records currently in a dataset.
       
       @param handle The dataset whose records to count
       @return IGetResultCountResponse The IGetResultCountResponse instance for the request */
    method protected IGetResultCountResponse CountDatasetRecords(input pData as handle):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable gdrc as GetResultCountResponse no-undo.
        
        Assert:NotNull(pData, 'Dataset handle').
        
        assign cnt  = pData:num-buffers
               gdrc = new GetResultCountResponse(cnt)
               .
        do loop = 1 to cnt:
            assign gdrc:ResultCounts[loop] = CountBufferRecords(pData:get-buffer-handle(loop)).
        end.
        
        return gdrc.
    end method.
    
    /* Returns the count of the total number of result records currently in a buffer
       
       @param handle The buffer whose records to count
       @return IGetTableResultCountResponse The IGetTableResultCountResponse instance for the request */
    method protected IGetTableResultCountResponse CountBufferRecords(input pData as handle):
        define variable qry as handle no-undo.
        define variable gtrc as IGetTableResultCountResponse no-undo.
        
        Assert:NotNull(pData, 'Buffer handle').
        
        create query qry.
        qry:set-buffers(pData).
        qry:query-prepare(substitute('preselect each &1 ':u, pData:name)).
        
        qry:query-open().
        assign gtrc = new GetTableResultCountResponse(pData:serialize-name,
                                                      qry:num-results,
                                                      // Exact=true because we open the query (per the interface description)
                                                      yes).
        qry:query-close().
        
        return gtrc.
        finally:
            delete object qry no-error.
        end finally.
    end method.
END CLASS.
