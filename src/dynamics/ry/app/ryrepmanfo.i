/*---------------------------------------------------------------------------------
  File: ryrepmanfo.i

  Description:  Repository Manager -fetchObject include

  Purpose:      This include contains the contents of fetchObject in the Repository Manager,
                since that procedure has become too large for the AppBuilder

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/15/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
DEFINE VARIABLE hBufferCacheTable           AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hBufferTableBuffer          AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hSourceBuffer               AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hTargetBuffer               AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hCacheClassTable            AS HANDLE           EXTENT 26                   NO-UNDO.
DEFINE VARIABLE hCacheObjectTable           AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hCachePageTable             AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hCachePageInstanceTable     AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hCacheLinkTable             AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hCacheUiEventTable          AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hReturnBufferCacheTable     AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hObjectQuery                AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hObjectBuffer               AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE hReturnBufferCache          AS HANDLE                                       NO-UNDO.
DEFINE VARIABLE lReturnTable                AS LOGICAL                                      NO-UNDO.
DEFINE VARIABLE dRecordIdentifier           AS DECIMAL                                      NO-UNDO.
DEFINE VARIABLE iAttributeExtent            AS INTEGER                                      NO-UNDO.
DEFINE VARIABLE iResultLoop                 AS INTEGER                                      NO-UNDO.
DEFINE VARIABLE cQueryWhere                 AS CHARACTER                                    NO-UNDO.
DEFINE VARIABLE cResultCode                 AS CHARACTER                                    NO-UNDO.

/* Ensure that we always attempt to retrieve the  default object(s) */
RUN resolveResultCodes ( INPUT plDesignMode, INPUT-OUTPUT pcResultCode ).

/** Don't cache objects when in design mode. This is because we want to be sure
 *  that we have the most up-to-date object available.
 *  ----------------------------------------------------------------------- **/
FIND FIRST ttMasterObjectCache WHERE
           ttMasterObjectCache.tLogicalObjectName = pcLogicalObjectName AND
           ttMasterObjectCache.tUserObj           = pdUserObj           AND
           ttMasterObjectCache.tResultCode        = pcResultCode        AND
           ttMasterObjectCache.tRunAttribute      = pcRunAttribute      AND
           ttMasterObjectCache.tLanguageObj       = pdLanguageObj
           NO-ERROR.

IF plDesignMode                                                     OR 
   NOT AVAILABLE ttMasterObjectCache                                OR
   ( AVAILABLE ttMasterObjectCache                            AND 
     NOT VALID-HANDLE(ttMasterObjectCache.tCacheObjectBuffer)     ) THEN
DO:
    &IF DEFINED(Server-Side) = 0 &THEN

        /* We're going to make a dynamic call to the Appserver, we need to build the temp-table of parameters */
        DEFINE VARIABLE hTableNotUsed    AS HANDLE     NO-UNDO.
        DEFINE VARIABLE hParamTable      AS HANDLE     NO-UNDO.
        DEFINE VARIABLE hTTHandlesToSend AS HANDLE     NO-UNDO EXTENT 64.        

        DEFINE VARIABLE iCnt             AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cDynCallParams   AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cParamString     AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cParamValue      AS CHARACTER  NO-UNDO.

        EMPTY TEMP-TABLE ttSeqType.

        /* Instead of several create and assigns, string the params and create the temp-table from the string */

        ASSIGN cDynCallParams = "INPUT,pcLogicalObjectName,CHARACTER," + CHR(26) + pcLogicalObjectName
                    + CHR(27) + "INPUT,pdUserObj,DECIMAL,"             + CHR(26) + (IF pdUserObj <> ? THEN STRING(pdUserObj) ELSE "":U)
                    + CHR(27) + "INPUT,pcResultCode,CHARACTER,"        + CHR(26) + pcResultCode
                    + CHR(27) + "INPUT,pdLanguageObj,DECIMAL,"         + CHR(26) + (IF pdLanguageObj <> ? THEN STRING(pdLanguageObj) ELSE "":U)
                    + CHR(27) + "INPUT,pcRunAttribute,CHARACTER,"      + CHR(26) + pcRunAttribute
                    + CHR(27) + "INPUT,plDesignMode,LOGICAL,"          + CHR(26) + (IF plDesignMode <> ? THEN STRING(plDesignMode) ELSE "":U)        
                    + CHR(27) + "OUTPUT,hBufferTableBuffer,HANDLE,"
                    + CHR(27) + "OUTPUT,T:27,TABLE-HANDLE,"  /* Cache Object table */
                    + CHR(27) + "OUTPUT,T:28,TABLE-HANDLE,"  /* Cache Page Table */
                    + CHR(27) + "OUTPUT,T:29,TABLE-HANDLE,"  /* Cache Page Instance Table */
                    + CHR(27) + "OUTPUT,T:30,TABLE-HANDLE,"  /* Cache Link Table */
                    + CHR(27) + "OUTPUT,T:31,TABLE-HANDLE,"  /* Cache UI event table */
                    + CHR(27) + "OUTPUT,T:01,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:02,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:03,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:04,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:05,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:06,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:07,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:08,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:09,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:10,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:11,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:12,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:13,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:14,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:15,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:16,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:17,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:18,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:19,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:20,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:21,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:22,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:23,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:24,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:25,TABLE-HANDLE,"
                    + CHR(27) + "OUTPUT,T:26,TABLE-HANDLE,".

        /* Build the parameters */

        DO iCnt = 1 TO NUM-ENTRIES(cDynCallParams, CHR(27)):
        
            CREATE ttSeqType.
            ASSIGN cParamString         = ENTRY(iCnt, cDynCallParams, CHR(27))
                   ttSeqType.iParamNo   = iCnt
                   ttSeqType.cIOMode    = ENTRY(1, cParamString, ",":U)
                   ttSeqType.cParamName = ENTRY(2, cParamString, ",":U)
                   ttSeqType.cDataType  = ENTRY(3, cParamString, ",":U).
        
            IF (ttSeqType.cIOMode = "INPUT":U
            OR  ttSeqType.cIOMode = "INPUT-OUTPUT":U)
            AND ttSeqType.cDataType <> "TABLE-HANDLE":U
            THEN DO:
                ASSIGN cParamValue = ENTRY(2, cParamString, CHR(26)).
        
                IF  ttSeqType.cDataType <> "CHARACTER":U
                AND cParamValue = "":U THEN
                    ASSIGN cParamValue = ?.
        
                CASE ttSeqType.cDataType:
                    WHEN "CHARACTER":U THEN ASSIGN ttSeqType.cCharacter = cParamValue.
                    WHEN "DECIMAL":U   THEN ASSIGN ttSeqType.dDecimal   = DECIMAL(cParamValue).
                    WHEN "DATE":U      THEN ASSIGN ttSeqType.tDate      = DATE(cParamValue).
                    WHEN "LOGICAL":U   THEN ASSIGN ttSeqType.lLogical   = (cParamValue = "YES":U).
                    WHEN "INTEGER":U   THEN ASSIGN ttSeqType.iInteger   = INTEGER(cParamValue).
                END CASE.
            END.
        END.
        
        /* Now assign the TABLE-HANDLEs, note they map directly to the ttSeq records of type TABLE-HANDLE */
        
        DO iCnt = 1 TO 26:
            ASSIGN hTTHandlesToSend[iCnt] = hCacheClassTable[iCnt].
        END.
        
        ASSIGN hParamTable          = TEMP-TABLE ttSeqType:HANDLE
               hTTHandlesToSend[27] = hCacheObjectTable
               hTTHandlesToSend[28] = hCachePageTable
               hTTHandlesToSend[29] = hCachePageInstanceTable
               hTTHandlesToSend[30] = hCacheLinkTable
               hTTHandlesToSend[31] = hCacheUiEventTable.
        
        /* calltablett.p will construct and execute the call on the Appserver */

        RUN adm2/calltablett.p ON gshAstraAppserver
            (
             "ServerFetchObject":U,
             "RepositoryManager":U,
             INPUT "S":U,
             INPUT-OUTPUT hTableNotUsed,
             INPUT-OUTPUT TABLE-HANDLE hParamTable,
             "*",  /* Tables not to destroy, * for all */
             {src/adm2/callttparam.i &ARRAYFIELD = "hTTHandlesToSend"}  /* The actual array of table handles */ 
            ) NO-ERROR.

        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Now assign the TABLE-HANDLEs back, so we can use them further down */

        DO iCnt = 1 TO 26:
            ASSIGN hCacheClassTable[iCnt] = hTTHandlesToSend[iCnt].
        END.

        FIND ttSeqType NO-LOCK
             WHERE ttSeqType.cParamName = "hBufferTableBuffer".

        ASSIGN hBufferTableBuffer      = ttSeqType.hHandle
               hCacheObjectTable       = hTTHandlesToSend[27]
               hCachePageTable         = hTTHandlesToSend[28]
               hCachePageInstanceTable = hTTHandlesToSend[29]
               hCacheLinkTable         = hTTHandlesToSend[30]
               hCacheUiEventTable      = hTTHandlesToSend[31].

        DELETE OBJECT hParamTable NO-ERROR.
        ASSIGN hParamTable = ?.
    &ELSE

    RUN ServerFetchObject ( INPUT pcLogicalObjectName, INPUT pdUserObj, INPUT pcResultCode,
                            INPUT pdLanguageObj, INPUT pcRunAttribute, INPUT plDesignMode,

                           OUTPUT  hBufferTableBuffer,
                           OUTPUT  TABLE-HANDLE hCacheObjectTable       ,
                           OUTPUT  TABLE-HANDLE hCachePageTable         ,
                           OUTPUT  TABLE-HANDLE hCachePageInstanceTable ,
                           OUTPUT  TABLE-HANDLE hCacheLinkTable         ,
                           OUTPUT  TABLE-HANDLE hCacheUiEventTable      ,
                        
                           OUTPUT  TABLE-HANDLE hCacheClassTable[01],   OUTPUT  TABLE-HANDLE hCacheClassTable[02],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[03],   OUTPUT  TABLE-HANDLE hCacheClassTable[04],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[05],   OUTPUT  TABLE-HANDLE hCacheClassTable[06],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[07],   OUTPUT  TABLE-HANDLE hCacheClassTable[08],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[09],   OUTPUT  TABLE-HANDLE hCacheClassTable[10],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[11],   OUTPUT  TABLE-HANDLE hCacheClassTable[12],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[13],   OUTPUT  TABLE-HANDLE hCacheClassTable[14],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[15],   OUTPUT  TABLE-HANDLE hCacheClassTable[16],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[17],   OUTPUT  TABLE-HANDLE hCacheClassTable[18],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[19],   OUTPUT  TABLE-HANDLE hCacheClassTable[20],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[21],   OUTPUT  TABLE-HANDLE hCacheClassTable[22],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[23],   OUTPUT  TABLE-HANDLE hCacheClassTable[24],
                           OUTPUT  TABLE-HANDLE hCacheClassTable[25],   OUTPUT  TABLE-HANDLE hCacheClassTable[26]  )  NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.
    &ENDIF  /* Server-Side */
    
    /* Make sure that the cache_BufferCache table is populated.
     * This will make it easier to work with the handles, since they are 
     * in a temp-table, and we don't have to depend on hard-coded numbers.
     *
     * If the buffer cache handle is valid, then we assume that the 
     * handles in the cache_Object table are valid, and we don't need to update
     * them                                                                  */
    IF NOT VALID-HANDLE(hBufferTableBuffer) THEN
    DO:
        CREATE TEMP-TABLE hBufferCacheTable.
        hBufferCacheTable:CREATE-LIKE(TEMP-TABLE cache_BufferCache:DEFAULT-BUFFER-HANDLE).
        hBufferCacheTable:TEMP-TABLE-PREPARE("cache_BufferCache":U).
        ASSIGN hBufferTableBuffer = hBufferCacheTable:DEFAULT-BUFFER-HANDLE.

        /* Populate with class attribute tables.
         * The class attribute tables will be in a contiguous sequence. */
        DO iAttributeExtent = 1 TO EXTENT(hCacheClassTable) WHILE VALID-HANDLE(hCacheClassTable[iAttributeExtent]):
            DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCacheClassTable[iAttributeExtent], INPUT YES, INPUT hBufferTableBuffer ).
        END.    /* loop through extents */

        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCacheObjectTable,       INPUT NO, INPUT hBufferTableBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCachePageTable,         INPUT NO, INPUT hBufferTableBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCachePageInstanceTable, INPUT NO, INPUT hBufferTableBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCacheLinkTable,         INPUT NO, INPUT hBufferTableBuffer).
        DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hCacheUiEventTable,      INPUT NO, INPUT hBufferTableBuffer).
    END.    /* not valid buffer cache. */

    /* Cache Objects */
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_Object":U, INPUT hBufferTableBuffer).

    /* Make sure that the cache_Object records point to the correct buffer handles. 
     * This uses the cache_BufferCache table. This is because it is more efficient to 
     * read through a table than to do a case statement to determine an index-based 
     * variable.                                                                     */
    IF VALID-HANDLE(hObjectBuffer) THEN
        DYNAMIC-FUNCTION("UpdateBufferHandles":U, INPUT hObjectBuffer, INPUT hBufferTableBuffer ).

    /* Add to cache */
    DYNAMIC-FUNCTION("CacheMasterObjects":U,
                     INPUT hObjectBuffer,
                     INPUT pdUserObj,
                     INPUT pcResultCode,
                     INPUT pcRunAttribute,
                     INPUT pdLanguageObj,
                     INPUT DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectLink":U,         INPUT hBufferTableBuffer),
                     INPUT DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectUiEvent":U,      INPUT hBufferTableBuffer),
                     INPUT DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectPage":U,         INPUT hBufferTableBuffer),
                     INPUT DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectPageInstance":U, INPUT hBufferTableBuffer) ).
END.    /* objects not cached */
ELSE
DO:
    /* We need to ensure that the various cache_* temp-tables appear in the
     * buffer cache temp-table because we use this for the CreateReturnCopy function. */
    CREATE TEMP-TABLE hBufferCacheTable.
    hBufferCacheTable:CREATE-LIKE(TEMP-TABLE cache_BufferCache:DEFAULT-BUFFER-HANDLE).
    hBufferCacheTable:TEMP-TABLE-PREPARE("cache_BufferCache":U).
    ASSIGN hBufferTableBuffer = hBufferCacheTable:DEFAULT-BUFFER-HANDLE.

    DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT ttMasterObjectCache.tCacheObjectBuffer             , INPUT NO, INPUT hBufferTableBuffer).
    DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT ttMasterObjectCache.tCacheObjectLinkBuffer         , INPUT NO, INPUT hBufferTableBuffer).
    DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT ttMasterObjectCache.tCacheObjectUiEventBuffer      , INPUT NO, INPUT hBufferTableBuffer).
    DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT ttMasterObjectCache.tCacheObjectPageBuffer         , INPUT NO, INPUT hBufferTableBuffer).
    DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT ttMasterObjectCache.tCacheObjectPageInstanceBuffer , INPUT NO, INPUT hBufferTableBuffer).
    /* Stuff is now in the client-side (with user customisations, etc) cache.
     * We need to return this data to the calling procedure.                  */

    IF NOT VALID-HANDLE(hObjectBuffer) THEN
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_Object":U, INPUT hBufferTableBuffer).

    /* Make sure that the cache_Object records point to the correct buffer handles. 
     * This uses the cache_BufferCache table. This is because it is more efficient to 
     * read through a table than to do a case statement to determine an index-based 
     * variable.                                                                     */

    IF VALID-HANDLE(hObjectBuffer) THEN
        DYNAMIC-FUNCTION("UpdateBufferHandles":U, INPUT hObjectBuffer, INPUT hBufferTableBuffer ).

END.    /* cached version stored on ttMasterObjectCache  */

/* Determine whether to return the buffer or handle. */
ASSIGN lReturnTable = (SESSION:CLIENT-TYPE = "APPSERVER":U OR SESSION:CLIENT-TYPE = "MULTI-SESSION-AGENT":U) AND (PROGRAM-NAME(2) = "":U OR PROGRAM-NAME(2) = ?).

/* Stuff is now in the client-side (with user customisations, etc) cache.
 * We need to return this data to the calling procedure.                  */
IF NOT VALID-HANDLE(hObjectBuffer) THEN
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_Object":U, INPUT hBufferTableBuffer).

IF plReturnEntireContainer THEN
DO:
    /** We build a TT of all the container objects which the requested object
     *  contains.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE ttContainedObject.
    DYNAMIC-FUNCTION("getContainerList":U, INPUT hObjectBuffer, INPUT pcLogicalObjectName ).
END.    /* return entire container */

/* Retrieve things on a per-object basis. i.e. get all of the links, pages,
 * attributes, etc for a specific object and not per container.            */
CREATE WIDGET-POOL "FetchObject":U.
CREATE QUERY hObjectQuery IN WIDGET-POOL "FetchObject":U.

IF NOT plDesignMode THEN
    ASSIGN cQueryWhere = " FOR EACH ":U 
                       + ( IF plReturnEntireContainer THEN
                               ( " ttContainedObject, EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                                 + hObjectBuffer:NAME + ".tContainerObjectName = ttContainedObject.tLogicalObjectName AND ":U)
                           ELSE 
                               ( hObjectBuffer:NAME + " WHERE ":U
                                 + hObjectBuffer:NAME + ".tContainerObjectName = '" + pcLogicalObjectName + "' AND ":U))
                       + hObjectBuffer:NAME + ".tResultCode = '":U + pcResultCode + "' AND ":U
                       + hObjectBuffer:NAME + ".tUserObj = '":U + STRING(pdUserObj) + "' AND ":U
                       + hObjectBuffer:NAME + ".tRunAttribute = '":U + pcRunAttribute + "' AND ":U                        
                       + hObjectBuffer:NAME + ".tLanguageObj = '":U + STRING(pdLanguageObj) + "' ":U.
ELSE
/* When in design mode, return the result codes individually. */
DO:
    ASSIGN cQueryWhere = " FOR EACH ":U 
                      + ( IF plReturnEntireContainer THEN
                              ( " ttContainedObject, EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                                + hObjectBuffer:NAME + ".tContainerObjectName = ttContainedObject.tLogicalObjectName AND ":U)
                          ELSE 
                              ( hObjectBuffer:NAME + " WHERE ":U
                                + hObjectBuffer:NAME + ".tContainerObjectName = '" + pcLogicalObjectName + "' AND ":U))
                      + hObjectBuffer:NAME + ".tUserObj = 0 AND ":U
                      + hObjectBuffer:NAME + ".tRunAttribute = '' AND ":U
                      + hObjectBuffer:NAME + ".tLanguageObj = 0 AND ":U
                      + " ( ":U.
    DO iResultLoop = 1 TO NUM-ENTRIES(pcResultCode):
       ASSIGN cResultCode = ENTRY(iResultLoop, pcResultCode)
              cQueryWhere = cQueryWhere + hObjectBuffer:NAME + ".tResultCode = '":U + pcResultCode + "' OR ":U.
    END.    /* result code loop. */
    
    ASSIGN cQueryWhere = RIGHT-TRIM(cQueryWhere, "OR ":U)
           cQueryWhere = cQueryWhere + " ) ":U
           .
END.    /* design mode */

/** We create a separate _BufferCache temp-table which only contains the 
 *  buffer handles of the record returned to the caller.
 *  ----------------------------------------------------------------------- **/
CREATE TEMP-TABLE hReturnBufferCacheTable.
hReturnBufferCacheTable:CREATE-LIKE(hBufferTableBuffer).
hReturnBufferCacheTable:TEMP-TABLE-PREPARE(REPLACE(hBufferTableBuffer:NAME, "cache_":U, "return_":U)) NO-ERROR.

/* Check whether we've created this TT already. */
ASSIGN hReturnBufferCache      = hReturnBufferCacheTable:DEFAULT-BUFFER-HANDLE
       hReturnBufferCacheTable = ?
       .
/* Cache the return_BufferCache in the cache_BufferCache TT. */
DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hReturnBufferCache, INPUT NO, INPUT hBufferTableBuffer).

IF plReturnEntireContainer THEN
    hObjectQuery:ADD-BUFFER(BUFFER ttContainedObject:HANDLE).

hObjectQuery:ADD-BUFFER(hObjectBuffer).
hObjectQuery:QUERY-PREPARE(cQueryWhere).

hObjectQuery:QUERY-OPEN().
hObjectQuery:GET-FIRST().

ASSIGN iAttributeExtent = 1.

/* Cache the return_BufferCache table, so that it can be cleaned up like any other return_* table.
 * This table is cached in the cache_BufferCache table.                                            */

DYNAMIC-FUNCTION("CreateBufferCacheRecord":U, INPUT hReturnBufferCache, INPUT NO, INPUT hBufferTableBuffer).

DO WHILE hObjectBuffer:AVAILABLE:
    /* Record ID of this object */
    ASSIGN dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.

    /* This part we're only going to do when we need to return TABLE-HANDLEs across the Appserver.    *
     * If we're not running across the Appserver, the calling program can use the class buffer handle *
     * on return_object to find the class buffer.  In this case, this handle is going to point to the * 
     * class cache_ buffer, which is fine.                                                            */
    IF lReturnTable = YES
    THEN DO:
        /* Class Attributes */
        ASSIGN hSourceBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

        hReturnBufferCache:FIND-FIRST(" WHERE ":U + hReturnBufferCache:NAME + ".tBufferName = '":U 
                                      + REPLACE(hSourceBuffer:NAME, "cache_":U, "return_") + "' ":U ) NO-ERROR.

        IF NOT hReturnBufferCache:AVAILABLE 
        THEN DO:
            ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                                    INPUT dRecordIdentifier,
                                                    INPUT hSourceBuffer,
                                                    INPUT YES,
                                                    INPUT hReturnBufferCache).
            CASE iAttributeExtent:
                WHEN 01 THEN ASSIGN phClassAttributeTable01 = hTargetBuffer:TABLE-HANDLE.
                WHEN 02 THEN ASSIGN phClassAttributeTable02 = hTargetBuffer:TABLE-HANDLE.
                WHEN 03 THEN ASSIGN phClassAttributeTable03 = hTargetBuffer:TABLE-HANDLE.
                WHEN 04 THEN ASSIGN phClassAttributeTable04 = hTargetBuffer:TABLE-HANDLE.
                WHEN 05 THEN ASSIGN phClassAttributeTable05 = hTargetBuffer:TABLE-HANDLE.
                WHEN 06 THEN ASSIGN phClassAttributeTable06 = hTargetBuffer:TABLE-HANDLE.
                WHEN 07 THEN ASSIGN phClassAttributeTable07 = hTargetBuffer:TABLE-HANDLE.
                WHEN 08 THEN ASSIGN phClassAttributeTable08 = hTargetBuffer:TABLE-HANDLE.
                WHEN 09 THEN ASSIGN phClassAttributeTable09 = hTargetBuffer:TABLE-HANDLE.
                WHEN 10 THEN ASSIGN phClassAttributeTable10 = hTargetBuffer:TABLE-HANDLE.
                WHEN 11 THEN ASSIGN phClassAttributeTable11 = hTargetBuffer:TABLE-HANDLE.
                WHEN 12 THEN ASSIGN phClassAttributeTable12 = hTargetBuffer:TABLE-HANDLE.
                WHEN 13 THEN ASSIGN phClassAttributeTable13 = hTargetBuffer:TABLE-HANDLE.
                WHEN 14 THEN ASSIGN phClassAttributeTable14 = hTargetBuffer:TABLE-HANDLE.
                WHEN 15 THEN ASSIGN phClassAttributeTable15 = hTargetBuffer:TABLE-HANDLE.
                WHEN 16 THEN ASSIGN phClassAttributeTable16 = hTargetBuffer:TABLE-HANDLE.
                WHEN 17 THEN ASSIGN phClassAttributeTable17 = hTargetBuffer:TABLE-HANDLE.
                WHEN 18 THEN ASSIGN phClassAttributeTable18 = hTargetBuffer:TABLE-HANDLE.
                WHEN 19 THEN ASSIGN phClassAttributeTable19 = hTargetBuffer:TABLE-HANDLE.
                WHEN 20 THEN ASSIGN phClassAttributeTable20 = hTargetBuffer:TABLE-HANDLE.
                WHEN 21 THEN ASSIGN phClassAttributeTable21 = hTargetBuffer:TABLE-HANDLE.
                WHEN 22 THEN ASSIGN phClassAttributeTable22 = hTargetBuffer:TABLE-HANDLE.
                WHEN 23 THEN ASSIGN phClassAttributeTable23 = hTargetBuffer:TABLE-HANDLE.
                WHEN 24 THEN ASSIGN phClassAttributeTable24 = hTargetBuffer:TABLE-HANDLE.
                WHEN 25 THEN ASSIGN phClassAttributeTable25 = hTargetBuffer:TABLE-HANDLE.
                WHEN 26 THEN ASSIGN phClassAttributeTable26 = hTargetBuffer:TABLE-HANDLE.            
            END CASE.   /* handle number */
            ASSIGN iAttributeExtent = iAttributeExtent + 1.
        END.    /* created new table. */
    END.

    /* Object Instances */
    ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                            INPUT dRecordIdentifier,
                                            INPUT hObjectBuffer,
                                            INPUT NO,
                                            INPUT hReturnBufferCache).
    IF lReturnTable THEN ASSIGN phObjectTable = hTargetBuffer:TABLE-HANDLE.

    /* Pages */
    ASSIGN hSourceBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectPage":U, INPUT hBufferTableBuffer).
    ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                            INPUT dRecordIdentifier,
                                            INPUT hSourceBuffer,
                                            INPUT NO,
                                            INPUT hReturnBufferCache).
    IF lReturnTable THEN ASSIGN phPageTable = hTargetBuffer:TABLE-HANDLE.

    /* Page Instances */
    ASSIGN hSourceBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectPageInstance":U, INPUT hBufferTableBuffer).
    ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                            INPUT dRecordIdentifier,
                                            INPUT hSourceBuffer,
                                            INPUT NO,
                                            INPUT hReturnBufferCache).
    IF lReturnTable THEN ASSIGN phPageInstanceTable = hTargetBuffer:TABLE-HANDLE.

    /* Links */
    ASSIGN hSourceBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectLink":U, INPUT hBufferTableBuffer).
    ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                            INPUT dRecordIdentifier,
                                            INPUT hSourceBuffer,
                                            INPUT NO,
                                            INPUT hReturnBufferCache).
    IF lReturnTable THEN ASSIGN phLinkTable = hTargetBuffer:TABLE-HANDLE.

    /* UI Events */
    ASSIGN hSourceBuffer = DYNAMIC-FUNCTION("getBufferHandle":U, INPUT "cache_ObjectUiEvent":U, INPUT hBufferTableBuffer).
    ASSIGN hTargetBuffer = DYNAMIC-FUNCTION("CreateReturnCopy":U,
                                            INPUT dRecordIdentifier,
                                            INPUT hSourceBuffer,
                                            INPUT NO,
                                            INPUT hReturnBufferCache).
    IF lReturnTable THEN ASSIGN phUiEventTable = hTargetBuffer:TABLE-HANDLE.

    hObjectQuery:GET-NEXT().
END.    /* loop through object query */

hObjectQuery:QUERY-CLOSE().

DELETE WIDGET-POOL "FetchObject":U.

/* Clean up "return_" TTs if we're passing them back across an AppServer. */

IF lReturnTable THEN
DO:    
    IF VALID-HANDLE(hBufferCacheTable) THEN
        DYNAMIC-FUNCTION("destroyObjectCache":U, INPUT hBufferCacheTable:DEFAULT-BUFFER-HANDLE).
    DELETE OBJECT hBufferCacheTable NO-ERROR.
    ASSIGN hBufferCacheTable   = ?
           phBufferCacheBuffer = ?
           .
END.    /* return table */
ELSE DO:
    /* This table was only used to build the return table, delete it */
    
    IF VALID-HANDLE(hBufferCacheTable) 
    AND SESSION = gshAstraAppserver THEN
        DYNAMIC-FUNCTION("destroyObjectCache":U, INPUT hBufferCacheTable:DEFAULT-BUFFER-HANDLE).

    ASSIGN phBufferCacheBuffer = hReturnBufferCache
           phObjectTable       = ? 
           phPageTable         = ?
           phPageInstanceTable = ?
           phLinkTable         = ?
           phUiEventTable      = ?
           phClassAttributeTable01 = ? phClassAttributeTable02 = ? phClassAttributeTable03 = ? phClassAttributeTable04 = ?
           phClassAttributeTable05 = ? phClassAttributeTable06 = ? phClassAttributeTable07 = ? phClassAttributeTable08 = ?
           phClassAttributeTable09 = ? phClassAttributeTable10 = ? phClassAttributeTable11 = ? phClassAttributeTable12 = ?
           phClassAttributeTable13 = ? phClassAttributeTable14 = ? phClassAttributeTable15 = ? phClassAttributeTable16 = ?
           phClassAttributeTable17 = ? phClassAttributeTable18 = ? phClassAttributeTable19 = ? phClassAttributeTable20 = ?
           phClassAttributeTable21 = ? phClassAttributeTable22 = ? phClassAttributeTable23 = ? phClassAttributeTable24 = ?
           phClassAttributeTable25 = ? phClassAttributeTable26 = ? 
           .
END.

ASSIGN hSourceBuffer      = ?
       hTargetBuffer      = ?
       hObjectBuffer      = ?
       hReturnBufferCache = ?
       .
/* EOF */
