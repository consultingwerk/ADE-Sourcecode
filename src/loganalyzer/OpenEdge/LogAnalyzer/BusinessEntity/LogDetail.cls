 
/*------------------------------------------------------------------------
   File        : LogDetail
   Syntax      : 
   Author(s)   : isyed
   Created     : Mon Jan 01 23:20:35 EST 2018
   Notes       : 
 ----------------------------------------------------------------------*/
  
@program FILE(name="LogDetail.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="LogDetail", URI="/detail", schemaName="dsLogDetail", schemaFile="LogAnalyzer/PASOEContent/WEB-INF/openedge/OpenEdge/LogAnalyzer/Include/eLogdetail.i").

USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.
USING OpenEdge.LogAnalyzer.BusinessEntity.LogDetail FROM PROPATH.
USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.LogAnalyzer.BusinessEntity.LogDetail INHERITS BusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"OpenEdge/LogAnalyzer/Include/eLogdetail.i"}
    
    DEFINE DATA-SOURCE srcLogDetail FOR logdb.LogDetail.
    DEFINE VARIABLE iSeq AS INTEGER NO-UNDO.
    
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC LogDetail():
        
        DEFINE VARIABLE hDataSourceArray AS HANDLE    NO-UNDO EXTENT 1.
        DEFINE VARIABLE cSkipListArray   AS CHARACTER NO-UNDO EXTENT 1.
        
        SUPER (DATASET dsLogDetail:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
        hDataSourceArray[1] =  DATA-SOURCE srcLogDetail:HANDLE.
         
                  
        /* Skip-list entry for each table in dataset. Should be in temp-table order 
          as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
            ignored in create stmt */
             
        cSkipListArray[1] = "".
         
         
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        THIS-OBJECT:SkipList = cSkipListArray.
                 
    END CONSTRUCTOR.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json"). 
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
   
    METHOD PUBLIC VOID ReadLogDetail(
        INPUT filter AS CHARACTER, 
        OUTPUT DATASET dsLogDetail):
            
        IF filter BEGINS "~{" THEN
            THIS-OBJECT:JFPFillMethod (INPUT filter).
        ELSE 
        DO:
            BUFFER ttLogDetail:HANDLE:BATCH-SIZE = 0.
            BUFFER ttLogDetail:SET-CALLBACK ("AFTER-ROW-FILL", "AddIdField").

            SUPER:ReadData(filter).
        END.
        
        SUPER:ReadData(filter).
              
    END METHOD.
    
    METHOD PRIVATE VOID JFPFillMethod(INPUT filter AS CHARACTER):

        DEFINE VARIABLE jsonParser     AS ObjectModelParser NO-UNDO.
        DEFINE VARIABLE jsonObject     AS JsonObject        NO-UNDO.
        DEFINE VARIABLE cWhere         AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE hQuery         AS HANDLE            NO-UNDO.
        DEFINE VARIABLE lUseReposition AS LOGICAL           NO-UNDO.
        DEFINE VARIABLE iCount         AS INTEGER           NO-UNDO.
        DEFINE VARIABLE ablFilter      AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE id             AS CHARACTER         INITIAL ? NO-UNDO.
        DEFINE VARIABLE iMaxRows       AS INTEGER           INITIAL ? NO-UNDO.
        DEFINE VARIABLE iSkipRows      AS INTEGER           INITIAL ? NO-UNDO.
        DEFINE VARIABLE cOrderBy       AS CHARACTER         INITIAL "" NO-UNDO.

        /* purge any existing data */
        EMPTY TEMP-TABLE ttLogDetail.

        jsonParser  = NEW ObjectModelParser().
        jsonObject  = CAST(jsonParser:Parse(filter), jsonObject).
        iMaxRows    = jsonObject:GetInteger("top")  NO-ERROR.
        iSkipRows   = jsonObject:GetInteger("skip") NO-ERROR.
        ablFilter   = jsonObject:GetCharacter("ablFilter") NO-ERROR.
        id          = jsonObject:GetCharacter("id") NO-ERROR.
        cOrderBy    = jsonObject:GetCharacter("orderBy") NO-ERROR.
        cWhere      = "WHERE " + ablFilter NO-ERROR.

        IF cOrderBy > "" THEN 
        DO:
            cOrderBy = REPLACE(cOrderBy, ",", " by ").
            cOrderBy = "by " + cOrderBy + " ".
            /* NOTE: id and seq fields should be removed from 
               cWhere and cOrderBy */
            cOrderBy = REPLACE(cOrderBy, "by id desc", "").
            cOrderBy = REPLACE(cOrderBy, "by id ", "").
            cOrderBy = REPLACE(cOrderBy, "by seq desc", "").
            cOrderBy = REPLACE(cOrderBy, "by seq ", "").
        END.

        lUseReposition = iSkipRows <> ?.

        IF iMaxRows <> ? AND iMaxRows > 0 THEN 
        DO:
            BUFFER ttLogDetail:HANDLE:BATCH-SIZE = iMaxRows.
        END.
        ELSE 
        DO:
            IF id > "" THEN
                BUFFER ttLogDetail:HANDLE:BATCH-SIZE = 1.
            ELSE                                 
                BUFFER ttLogDetail:HANDLE:BATCH-SIZE = 0.
        END.                        

        BUFFER ttLogDetail:ATTACH-DATA-SOURCE(DATA-SOURCE srcLogDetail:HANDLE).

        IF cOrderBy = ? THEN cOrderBy = "".
        cWhere = IF cWhere > "" THEN (cWhere + " " + cOrderBy) 
        ELSE ("WHERE " + cOrderBy).
        DATA-SOURCE srcLogDetail:FILL-WHERE-STRING = cWhere.

        IF lUseReposition THEN 
        DO:
            hQuery = DATA-SOURCE srcLogDetail:QUERY.
            hQuery:QUERY-OPEN.

            IF id > "" AND id <> "?" THEN 
            DO:
                hQuery:REPOSITION-TO-ROWID(TO-ROWID(id)).
            END.
            ELSE IF iSkipRows <> ? AND iSkipRows > 0 THEN 
                DO:
                    hQuery:REPOSITION-TO-ROW(iSkipRows).
                    IF NOT AVAILABLE LogDetail THEN
                        hQuery:GET-NEXT() NO-ERROR.
                END.

            iCount = 0.
            REPEAT WHILE NOT hQuery:QUERY-OFF-END AND iCount < iMaxRows:
                hQuery:GET-NEXT () NO-ERROR.
                IF AVAILABLE LogDetail THEN 
                DO:
                    CREATE ttLogDetail.
                    BUFFER-COPY LogDetail TO ttLogDetail.
                    ASSIGN  
                        ttLogDetail.id  = STRING(ROWID(LogDetail))
                        iSeq            = iSeq + 1
                        ttLogDetail.seq = iSeq.
                END.
                iCount = iCount + 1.
            END.
        END.
        ELSE 
        DO:
            IF id > "" THEN DATA-SOURCE srcLogDetail:RESTART-ROWID(1) 
                = TO-ROWID ((id)).
            BUFFER ttLogDetail:SET-CALLBACK ("AFTER-ROW-FILL", "AddIdField").
            DATASET dsLogDetail:FILL().
        END.

        FINALLY:
            BUFFER ttLogDetail:DETACH-DATA-SOURCE().
        END FINALLY. 
  
    END METHOD.
      
     
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="count", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE jsonParser AS ObjectModelParser NO-UNDO.
        DEFINE VARIABLE jsonObject AS JsonObject        NO-UNDO.
        DEFINE VARIABLE ablFilter  AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cWhere     AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE qh         AS HANDLE            NO-UNDO.

        IF filter BEGINS "WHERE " THEN
            cWhere = filter.
        ELSE IF filter BEGINS "~{" THEN 
            DO:
                jsonParser  = NEW ObjectModelParser().
                jsonObject  = CAST(jsonParser:Parse(filter), jsonObject).
                ablFilter   = jsonObject:GetCharacter("ablFilter") NO-ERROR.
                cWhere      = "WHERE " + ablFilter.
            END.
            ELSE IF filter NE "" THEN
                DO:
                    /* Use filter as WHERE clause */
                    cWhere = "WHERE " + filter.
                END.

        CREATE QUERY qh.
        qh:SET-BUFFERS(BUFFER LogDetail:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH LogDetail " + cWhere).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.

    END METHOD.
    
    
END CLASS.
