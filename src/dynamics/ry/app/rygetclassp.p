/*---------------------------------------------------------------------------------
  File: rygetclassp.p

  Description:  Dynamics Repository Class Retrieval Code; server-side portion.

  Purpose:      This procedure acts as the server-side proxy for the buildClassCache()
                  API in the Repository Manager. This code executes the object retrieval
                  on the server, and returns its results in the form of temp-tables.                  

  Parameters:   pcObjectName
                  pcResultCode
                  pdUserObj
                  pdLanguageObj
                  pcRunAttribute
                  pdRenderTypeObj
                  pcPageList
                  pdInstanceID
                table-handle phCacheObject
                table-handle phCachePage
                table-handle phCacheLink
                  
                  
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/08/2003  Author:     Pjudge

  Update Notes: Created from Template aftemplipp.p
  
 -------------------------------------------------------------------------------------*/
    /* Defines the transportClass TT. */
    {ry/inc/getobjecti.i}
 
    DEFINE INPUT  PARAMETER pcClassName                 AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR transportClass.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable01.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable02.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable03.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable04.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable05.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable06.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable07.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable08.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable09.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable10.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable11.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable12.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable13.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable14.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable15.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable16.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable17.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable18.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable19.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable20.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable21.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable22.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable23.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable24.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable25.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable26.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable27.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable28.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable29.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable30.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable31.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassTable32.
               
     {src/adm2/globals.i}
            
    DEFINE VARIABLE iReturnTablesUsed    AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE iReturnTablesNeeded    AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE iLoopCount            AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE hClassBuffer        AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hTransportBuffer    AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer    AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hEventBuffer        AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE cWhereClause        AS CHARACTER                    NO-UNDO.
                            
    EMPTY TEMP-TABLE transportClass.
            
    /* Get the class buffer handle from the Repository Manager. This request also ensures that
     * those classes are cached on the server.
     */
    ASSIGN hClassBuffer     = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager,
                                               INPUT pcClassName)
           hTransportBuffer = BUFFER transportClass:HANDLE.
    
    /* Build the query string if there is a list of classes. */
    IF pcClassName NE "*":U THEN
    DO iLoopCount = 1 TO NUM-ENTRIES(pcClassName):
        ASSIGN cWhereClause = cWhereClause
                            + (IF iLoopCount EQ 1 THEN " WHERE ":U ELSE " OR ":U) 
                            +  hClassBuffer:NAME + ".ClassName = ":U
                            + QUOTER(ENTRY(iLoopCount, pcClassName)).
    END.    /* build the query clause. */
           
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hClassBuffer).
    hQuery:QUERY-PREPARE(" FOR EACH " + hClassBuffer:NAME
                         + (IF cWhereClause EQ "":U THEN "":U ELSE cWhereClause) ).                         
    
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    
    BUILD-RETURN-TABLES:
    DO WHILE hClassBuffer:AVAILABLE:
        /* Determine how many tables we are going to return. If we don't have any space
         * left for these tables, then we need to return. The calling procedure will ensure that
         * all of the tables referred to in the original request are retrieved.
         */
        ASSIGN hAttributeBuffer = hClassBuffer:BUFFER-FIELD("ClassBufferHandle"):BUFFER-VALUE.
        IF VALID-HANDLE(hAttributeBuffer) THEN
            ASSIGN iReturnTablesNeeded = 1.
        
        ASSIGN hEventBuffer = hClassBuffer:BUFFER-FIELD("EventBufferHandle"):BUFFER-VALUE.
        IF VALID-HANDLE(hEventBuffer) THEN
            ASSIGN iReturnTablesNeeded = iReturnTablesNeeded + 1.
            
        IF (iReturnTablesUsed + iReturnTablesNeeded) GT 32 THEN
            LEAVE BUILD-RETURN-TABLES.
                                            
        /* Create an entry for the ttClass records. */
        hTransportBuffer:BUFFER-CREATE().
        /* Don't bring the values of any of the handle-containing fields across to the client.
         */
        hTransportBuffer:BUFFER-COPY(hClassBuffer, "SuperHandles,InstanceBufferHandle":U).
        hTransportBuffer:BUFFER-RELEASE().
                                
        /* Create a return table for the attributes. */
        ASSIGN iReturnTablesUsed = iReturnTablesUsed + 1.
        CASE iReturnTablesUsed:
            WHEN 01 THEN ASSIGN phClassTable01 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 02 THEN ASSIGN phClassTable02 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 03 THEN ASSIGN phClassTable03 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 04 THEN ASSIGN phClassTable04 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 05 THEN ASSIGN phClassTable05 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 06 THEN ASSIGN phClassTable06 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 07 THEN ASSIGN phClassTable07 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 08 THEN ASSIGN phClassTable08 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 09 THEN ASSIGN phClassTable09 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 10 THEN ASSIGN phClassTable10 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 11 THEN ASSIGN phClassTable11 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 12 THEN ASSIGN phClassTable12 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 13 THEN ASSIGN phClassTable13 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 14 THEN ASSIGN phClassTable14 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 15 THEN ASSIGN phClassTable15 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 16 THEN ASSIGN phClassTable16 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 17 THEN ASSIGN phClassTable17 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 18 THEN ASSIGN phClassTable18 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 19 THEN ASSIGN phClassTable19 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 20 THEN ASSIGN phClassTable20 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 21 THEN ASSIGN phClassTable21 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 22 THEN ASSIGN phClassTable22 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 23 THEN ASSIGN phClassTable23 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 24 THEN ASSIGN phClassTable24 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 25 THEN ASSIGN phClassTable25 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 26 THEN ASSIGN phClassTable26 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 27 THEN ASSIGN phClassTable27 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 28 THEN ASSIGN phClassTable28 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 29 THEN ASSIGN phClassTable29 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 30 THEN ASSIGN phClassTable30 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 31 THEN ASSIGN phClassTable31 = hAttributeBuffer:TABLE-HANDLE.
            WHEN 32 THEN ASSIGN phClassTable32 = hAttributeBuffer:TABLE-HANDLE.
        END CASE.   /* handle number */
        
        /* If there is a valid event buffer, then return that too. */
        IF VALID-HANDLE(hEventBuffer) THEN
        DO:
            ASSIGN iReturnTablesUsed = iReturnTablesUsed + 1.
            CASE iReturnTablesUsed:
                WHEN 01 THEN ASSIGN phClassTable01 = hEventBuffer:TABLE-HANDLE.
                WHEN 02 THEN ASSIGN phClassTable02 = hEventBuffer:TABLE-HANDLE.
                WHEN 03 THEN ASSIGN phClassTable03 = hEventBuffer:TABLE-HANDLE.
                WHEN 04 THEN ASSIGN phClassTable04 = hEventBuffer:TABLE-HANDLE.
                WHEN 05 THEN ASSIGN phClassTable05 = hEventBuffer:TABLE-HANDLE.
                WHEN 06 THEN ASSIGN phClassTable06 = hEventBuffer:TABLE-HANDLE.
                WHEN 07 THEN ASSIGN phClassTable07 = hEventBuffer:TABLE-HANDLE.
                WHEN 08 THEN ASSIGN phClassTable08 = hEventBuffer:TABLE-HANDLE.
                WHEN 09 THEN ASSIGN phClassTable09 = hEventBuffer:TABLE-HANDLE.
                WHEN 10 THEN ASSIGN phClassTable10 = hEventBuffer:TABLE-HANDLE.
                WHEN 11 THEN ASSIGN phClassTable11 = hEventBuffer:TABLE-HANDLE.
                WHEN 12 THEN ASSIGN phClassTable12 = hEventBuffer:TABLE-HANDLE.
                WHEN 13 THEN ASSIGN phClassTable13 = hEventBuffer:TABLE-HANDLE.
                WHEN 14 THEN ASSIGN phClassTable14 = hEventBuffer:TABLE-HANDLE.
                WHEN 15 THEN ASSIGN phClassTable15 = hEventBuffer:TABLE-HANDLE.
                WHEN 16 THEN ASSIGN phClassTable16 = hEventBuffer:TABLE-HANDLE.
                WHEN 17 THEN ASSIGN phClassTable17 = hEventBuffer:TABLE-HANDLE.
                WHEN 18 THEN ASSIGN phClassTable18 = hEventBuffer:TABLE-HANDLE.
                WHEN 19 THEN ASSIGN phClassTable19 = hEventBuffer:TABLE-HANDLE.
                WHEN 20 THEN ASSIGN phClassTable20 = hEventBuffer:TABLE-HANDLE.
                WHEN 21 THEN ASSIGN phClassTable21 = hEventBuffer:TABLE-HANDLE.
                WHEN 22 THEN ASSIGN phClassTable22 = hEventBuffer:TABLE-HANDLE.
                WHEN 23 THEN ASSIGN phClassTable23 = hEventBuffer:TABLE-HANDLE.
                WHEN 24 THEN ASSIGN phClassTable24 = hEventBuffer:TABLE-HANDLE.
                WHEN 25 THEN ASSIGN phClassTable25 = hEventBuffer:TABLE-HANDLE.
                WHEN 26 THEN ASSIGN phClassTable26 = hEventBuffer:TABLE-HANDLE.
                WHEN 27 THEN ASSIGN phClassTable27 = hEventBuffer:TABLE-HANDLE.
                WHEN 28 THEN ASSIGN phClassTable28 = hEventBuffer:TABLE-HANDLE.
                WHEN 29 THEN ASSIGN phClassTable29 = hEventBuffer:TABLE-HANDLE.
                WHEN 30 THEN ASSIGN phClassTable30 = hEventBuffer:TABLE-HANDLE.
                WHEN 31 THEN ASSIGN phClassTable31 = hEventBuffer:TABLE-HANDLE.
                WHEN 32 THEN ASSIGN phClassTable32 = hEventBuffer:TABLE-HANDLE.
            END CASE.   /* handle number */
        END.    /* valid event buffer */
        
        hQuery:GET-NEXT().
    END.    /* BUILD-RETURN-TABLES: available query result */
    hQuery:QUERY-CLOSE().
    
    DELETE OBJECT hQuery.
    ASSIGN hQuery = ?.
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
/* E O F */