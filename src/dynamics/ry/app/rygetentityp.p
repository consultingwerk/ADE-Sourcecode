/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rygetEntityp.p

  Description:  Dynamics Repository Entity Object Code; server-side portion.

  Purpose:      This procedure acts as the server-side proxy for the buildEntityCache()
                  API in the Repository Manager. This code executes the object retrieval
                  on the server, and returns its results in the form of temp-tables.

  Parameters:   pcEntityName
                pcLanguageCode
                table-handle phEntityTable01-32
                
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/08/2003  Author:     Pjudge

  Update Notes: Created from Template aftemplipp.p
  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEntityName                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcLanguageCode                AS CHARACTER    NO-UNDO.    
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable01.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable02.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable03.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable04.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable05.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable06.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable07.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable08.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable09.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable10.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable11.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable12.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable13.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable14.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable15.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable16.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable17.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable18.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable19.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable20.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable21.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable22.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable23.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable24.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable25.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable26.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable27.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable28.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable29.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable30.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable31.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phEntityTable32.
               
     {src/adm2/globals.i}
            
    DEFINE VARIABLE iReturnTablesUsed    AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE iLoopCount            AS INTEGER                        NO-UNDO.
    DEFINE VARIABLE hEntityBuffer        AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hEntityTableBuffer    AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE cWhereClause        AS CHARACTER                    NO-UNDO.
 
    /* Request that the entities be cached. Even though the getCacheEntityObject()
       will cache the requested classes, no decent errors are returned. Calling the
       createEntityCache procedure will return 'proper' errors.
       We still need to call the getCacheEntityObject() API to return the buffer
       handle we need to construct our query.
     */
    IF pcLanguageCode = ? OR pcLanguageCode = "":U THEN
       RETURN ERROR "Value for language code parameter is unknown".
    RUN createEntityCache IN gshRepositoryManager ( INPUT pcEntityName, pcLanguageCode) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    ASSIGN iReturnTablesUsed = 0
           hEntityBuffer     = DYNAMIC-FUNCTION("getCacheEntityObject":U IN gshRepositoryManager, ?).
    
    /* Build the query string if there is a list of Entities. 
     * If there is only one entity requested, then the call to getCacheEntityObject()
     * will ensure that the ttEntity record is available and repositioned to the correct
     * record.
     */
    IF NUM-ENTRIES(pcEntityName) NE 1 THEN
    DO:
        cWhereClause = " WHERE ":U + hEntityBuffer:NAME + ".LanguageCode = ":U + QUOTER(pcLanguageCode)
                     + " AND ( ":U.
        DO iLoopCount = 1 TO NUM-ENTRIES(pcEntityName):
            ASSIGN cWhereClause = cWhereClause
                                + (IF iLoopCount EQ 1 THEN "":U ELSE " OR ":U) 
                                +  hEntityBuffer:NAME + ".EntityName = ":U
                                + QUOTER(ENTRY(iLoopCount, pcEntityName)).
        END.    /* build the query clause. */
        cWhereClause = cWhereClause + " ) ":U.
                       
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(hEntityBuffer).
        hQuery:QUERY-PREPARE(" FOR EACH " + hEntityBuffer:NAME
                             + (IF cWhereClause EQ "":U THEN "":U ELSE cWhereClause) ).                         
        
        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST().
    END.    /* more than one entry. */
    ELSE
        hEntityBuffer:FIND-FIRST(" WHERE ":U + hEntityBuffer:NAME 
                                + ".EntityName = ":U + QUOTER(pcEntityName)
                                + " AND ":U 
                                + hEntityBuffer:NAME + ".LanguageCode = ":U + QUOTER(pcLanguageCode)) NO-ERROR.
    
    BUILD-RETURN-TABLES:
    DO WHILE hEntityBuffer:AVAILABLE:
        /* Determine how many tables we are going to return. If we don't have any space
         * left for these tables, then we need to return. The calling procedure will ensure that
         * all of the tables referred to in the original request are retrieved.
         */
        IF iReturnTablesUsed + 1 GT 32 THEN
            LEAVE BUILD-RETURN-TABLES.
                     
        ASSIGN hEntityTableBuffer = hEntityBuffer:BUFFER-FIELD("EntityBufferHandle"):BUFFER-VALUE.
        
        /* Create a return table for the attributes. */
        ASSIGN iReturnTablesUsed = iReturnTablesUsed + 1.
        CASE iReturnTablesUsed:
            WHEN 01 THEN ASSIGN phEntityTable01 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 02 THEN ASSIGN phEntityTable02 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 03 THEN ASSIGN phEntityTable03 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 04 THEN ASSIGN phEntityTable04 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 05 THEN ASSIGN phEntityTable05 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 06 THEN ASSIGN phEntityTable06 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 07 THEN ASSIGN phEntityTable07 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 08 THEN ASSIGN phEntityTable08 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 09 THEN ASSIGN phEntityTable09 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 10 THEN ASSIGN phEntityTable10 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 11 THEN ASSIGN phEntityTable11 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 12 THEN ASSIGN phEntityTable12 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 13 THEN ASSIGN phEntityTable13 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 14 THEN ASSIGN phEntityTable14 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 15 THEN ASSIGN phEntityTable15 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 16 THEN ASSIGN phEntityTable16 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 17 THEN ASSIGN phEntityTable17 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 18 THEN ASSIGN phEntityTable18 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 19 THEN ASSIGN phEntityTable19 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 20 THEN ASSIGN phEntityTable20 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 21 THEN ASSIGN phEntityTable21 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 22 THEN ASSIGN phEntityTable22 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 23 THEN ASSIGN phEntityTable23 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 24 THEN ASSIGN phEntityTable24 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 25 THEN ASSIGN phEntityTable25 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 26 THEN ASSIGN phEntityTable26 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 27 THEN ASSIGN phEntityTable27 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 28 THEN ASSIGN phEntityTable28 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 29 THEN ASSIGN phEntityTable29 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 30 THEN ASSIGN phEntityTable30 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 31 THEN ASSIGN phEntityTable31 = hEntityTableBuffer:TABLE-HANDLE.
            WHEN 32 THEN ASSIGN phEntityTable32 = hEntityTableBuffer:TABLE-HANDLE.
        END CASE.   /* handle number */
        
        /* If this is a query, then get the next record. If it is not, then 
           we know that there was only ever one record available and so we blow
           this joint.        
         */
        IF VALID-HANDLE(hQuery) THEN
            hQuery:GET-NEXT().
         ELSE
             LEAVE.
    END.    /* BUILD-RETURN-TABLES: available query result */
    
    IF VALID-HANDLE(hQuery) THEN
    DO:
        hQuery:QUERY-CLOSE().
        
        DELETE OBJECT hQuery.
        ASSIGN hQuery = ?.
    END.    /* valid query. */
 
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
/* E O F */
