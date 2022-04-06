/*---------------------------------------------------------------------------------
  File: rygetobjectp.p

  Description:  Dynamics Repository Object Retrieval Code; server-side portion.

  Purpose:      This procedure acts as the server-side proxy for the doObjectRetrieval
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
                  pcClassesReferenced
                  pcEntitiesReferenced
                  pcToolbarsReferenced
                table-handle phCacheObject
                table-handle phCachePage
                table-handle phCacheLink
                  
                  
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/08/2003  Author:     Pjudge

  Update Notes: Created from Template aftemplipp.p
  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj               AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj           AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdRenderTypeObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcPageList              AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceName          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcClassesReferenced     AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntitiesReferenced    AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcToolbarsReferenced    AS CHARACTER        NO-UNDO.
    define output parameter table-handle phCacheObject.
    define output parameter table-handle phCachePage.
    define output parameter table-handle phCacheLink.
    
    define variable hObjectBuffer        as handle                    no-undo.
    define variable hPageBuffer            as handle                    no-undo.
    define variable hLinkBuffer            as handle                    no-undo.
    
    {src/adm2/globals.i}
 
    /* Make sure that the object cache is clear on the server.
       The clearing cannot happen after retrieval else empty temp-tables are returned,
       which helps no-one.
     */
    RUN clearClientCache IN gshRepositoryManager NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
    /* Service the object retrieval request. */
    RUN doObjectRetrieval IN gshRepositoryManager ( INPUT  pcObjectName,
                                                    INPUT  pcResultCode,
                                                    INPUT  pdUserObj,
                                                    INPUT  pdLanguageObj,
                                                    INPUT  pcRunAttribute,
                                                    INPUT  pdRenderTypeObj,
                                                    INPUT  pcPageList,
                                                    INPUT  pdInstanceId,
                                                    INPUT  pcInstanceName,
                                                    OUTPUT pcClassesReferenced,
                                                    OUTPUT pcEntitiesReferenced,   
                                                    OUTPUT pcToolbarsReferenced) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
 
    /* Retrieve the buffer handles from the cache and return as tables. */
    RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT hObjectBuffer,
                                                       OUTPUT hPageBuffer,
                                                       OUTPUT hLinkBuffer    ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                                                      
    /* We need to return tables across the AppServer divide (deep copy). */
    ASSIGN phCacheObject = hObjectBuffer:TABLE-HANDLE
           phCachePage   = hPageBuffer:TABLE-HANDLE
           phCacheLink   = hLinkBuffer:TABLE-HANDLE.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
/* E O F */
