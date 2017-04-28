 
 
/**************************************************************************************************************
*    Copyright (C) 2014-2016 by Progress Software Corporation. All rights reserved.                           *
*    Prior versions of this work may contain portions contributed by participants of Possenet.                *
*                                                                                                             *
***************************************************************************************************************/


/*-------------------------------------------------------------------------------------------------------------
    File        : BusinessEntity.cls
    Syntax      : 
    Author(s)   : Maura Regan
    Created     : Tues Mar 04 11:50:26 EST 2014
    Notes       : Abstract class that contains generic methods performing CRUD operations for Busines Entities
  -------------------------------------------------------------------------------------------------------------*/
 
BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.BusinessLogic.BusinessEntity ABSTRACT:
   
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
      
            
    CONSTRUCTOR PROTECTED BusinessEntity(INPUT hDS AS HANDLE):
        
        ProDataSet = hDS.
        
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
                
        THIS-OBJECT:AttachDataSources().
        
        THIS-OBJECT:CommitData(ROW-CREATED).   
                                 
        FINALLY: 
            THIS-OBJECT:DetachDataSources().
        END FINALLY.      
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
            Purpose: Delete one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/ 
    METHOD PROTECTED VOID UpdateData(INPUT-OUTPUT DATASET-HANDLE hDataSet):            
         
         THIS-OBJECT:AttachDataSources().
         
         THIS-OBJECT:CommitData(ROW-MODIFIED).  
                                 
         FINALLY: 
            THIS-OBJECT:DetachDataSources().
        END FINALLY.  
                  
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose:    Delete one or more records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PROTECTED VOID DeleteData(INPUT-OUTPUT DATASET-HANDLE hDataSet):                   
       
        THIS-OBJECT:AttachDataSources().
         
        THIS-OBJECT:CommitData(ROW-DELETED).   
                                 
        FINALLY: 
            THIS-OBJECT:DetachDataSources().
        END FINALLY.  
         
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Purpose:  Submits one or more changed records (creates, updates, and/or deletes)                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/ 
    METHOD PROTECTED VOID Submit(INPUT-OUTPUT DATASET-HANDLE hDataSet):           
       
       THIS-OBJECT:AttachDataSources().
       
       /* Do deletes first, next creates, and finally modifies */
       THIS-OBJECT:CommitData(ROW-DELETED). 
       THIS-OBJECT:CommitData(ROW-CREATED).
       THIS-OBJECT:CommitData(ROW-MODIFIED). 
          
        FINALLY: 
            THIS-OBJECT:DetachDataSources().
        END FINALLY.  
          
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
            hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            hCurBuffer:ATTACH-DATA-SOURCE(ProDataSource[iIndex]).
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
            hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            hCurBuffer:ATTACH-DATA-SOURCE(ProDataSource[iIndex], cFieldList[iIndex]).
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
            hCurBuffer = ProDataSet:GET-BUFFER-HANDLE(iIndex).
            hCurBuffer:DETACH-DATA-SOURCE().
        END.
                                    
    END METHOD.
    
    /*-----------------------------------------------------------------------------------
            Purpose: Must verify that ProDataSource contains a data source entry for each 
                     table specified in dataset. Also verify that they are valid handles.                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------------*/  
    METHOD PROTECTED VOID ValidateDataSources():
        
        DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
        
        IF ProDataSet:NUM-BUFFERS NE EXTENT(ProDataSource) THEN
            UNDO, THROW NEW Progress.Lang.AppError("ProDataSource's EXTENT value must equal number of buffers in DataSet.", 0).
           
        REPEAT iIndex = 1 TO ProDataSet:NUM-BUFFERS:         
            IF NOT VALID-HANDLE(ProDataSource[iIndex]) THEN
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
            IF hRelation:PARENT-BUFFER EQ hParentBuffer THEN DO:
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
        DEFINE VARIABLE hAfterQuery AS HANDLE NO-UNDO.
        DEFINE VARIABLE lAvailable AS LOGICAL NO-UNDO.
        DEFINE VARIABLE lReturnValue AS LOGICAL NO-UNDO.
        DEFINE VARIABLE lCreatedBeforeRows AS LOGICAL INIT FALSE NO-UNDO.
        
        hBeforeBuffer = hBuffer:BEFORE-BUFFER.
        
        IF hBeforeBuffer EQ ? THEN
            UNDO, THROW NEW 
            Progress.Lang.AppError("In order to use BusinessEntity CUD functionality, temp-tables must be specified with BEFORE-TABLE.", 0).
        
        /* First let's determine if the BEFORE-TABLE has any records. If not, then we need to call MARK-ROW-STATE() 
         * which will create the before-table records. Before-table records are required by SAVE-ROW-CHANGES().
         *
         * So we'll create a query and attach the before-buffer to it so we can access the before-table rows.
         */
        CREATE QUERY hBeforeQuery.
        hBeforeQuery:SET-BUFFERS(hBeforeBuffer).
        
        /* We're only concerned with rows with iRowState */
        lReturnValue = hBeforeQuery:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1 WHERE ROW-STATE(&1) EQ &2', hBeforeBuffer:NAME, iRowState)).
        lReturnValue = hBeforeQuery:QUERY-OPEN().
        lAvailable = hBeforeQuery:GET-FIRST().
        
        /* If before-table has no rows, call MARK-ROW-STATE() to create them. */
        IF lAvailable EQ FALSE THEN DO:
            lCreatedBeforeRows = TRUE.
            CREATE QUERY hAfterQuery.
            hAfterQuery:SET-BUFFERS(hBuffer).
            lReturnValue = hAfterQuery:QUERY-PREPARE(SUBSTITUTE('FOR EACH &1', hBuffer:NAME)).
            lReturnValue = hAfterQuery:QUERY-OPEN().
            lAvailable = hAfterQuery:GET-FIRST().
            
            DO WHILE lAvailable:
                hBuffer:MARK-ROW-STATE(iRowState).
                lAvailable = hAfterQuery:GET-NEXT().
            END.
            
            /* Now that the before-table rows have been created, reopen and set to first row in before-table */
            lReturnValue = hBeforeQuery:QUERY-OPEN().
            lAvailable = hBeforeQuery:GET-FIRST().         
        END.
        
        /* Once we get here, we have have before-table rows, with first row in before-buffer */
        DO WHILE lAvailable:
            hBeforeBuffer:SAVE-ROW-CHANGES(1, cSkip) NO-ERROR .
                   
            IF hBeforeBuffer:ERROR THEN DO:
                IF ERROR-STATUS:NUM-MESSAGES >= 1 THEN DO:
                    hBeforeBuffer:ERROR-STRING = ERROR-STATUS:GET-MESSAGE(1).
                END.
                
                /* Check to see if RETURN-VALUE is set. This is possible if error was returned from DB trigger */
                IF  hBeforeBuffer:ERROR-STRING EQ ? THEN
                     hBeforeBuffer:ERROR-STRING = RETURN-VALUE.
                     
                /* If there is no Before-Image data, then throw the error */
                IF lCreatedBeforeRows THEN
                    UNDO, THROW NEW Progress.Lang.AppError(hBeforeBuffer:ERROR-STRING, 0).

            END.
           
           lAvailable = hBeforeQuery:GET-NEXT().
        END.
        
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
      
     
/*--------------------------------------------------------------------------------------------------
            Purpose:                                                            
            Notes:                                                                   
  -------------------------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID SetFillWhereString(INPUT cWhere AS CHARACTER, 
                                           INPUT hBuffer AS HANDLE):
        DEFINE VARIABLE hDataSrc AS HANDLE NO-UNDO.
         
        /* Set FILL-WHERE-STRING if applicable */
        IF cWhere NE "" AND cWhere NE ? THEN DO:
            hDataSrc =  hBuffer:DATA-SOURCE.
            hDataSrc:FILL-WHERE-STRING = cWhere.
        END.  
    
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
    
          
END CLASS.
