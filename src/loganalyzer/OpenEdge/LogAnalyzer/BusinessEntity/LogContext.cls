 
/*------------------------------------------------------------------------
   File        : LogContext
   Syntax      : 
   Author(s)   : isyed
   Created     : Mon Jan 01 23:19:57 EST 2018
   Notes       : 
 ----------------------------------------------------------------------*/
  
@program FILE(name="LogContext.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="LogContext", URI="/LogContext", schemaName="dsLogContext", schemaFile="LogAnalyzer/PASOEContent/WEB-INF/openedge/OpenEdge/LogAnalyzer/Include/eLogcontext.i").

USING Progress.Lang.*.
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.
USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.
USING OpenEdge.BusinessLogic.BusinessEntity.
USING OpenEdge.LogAnalyzer.BusinessEntity.LogContext FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.LogAnalyzer.BusinessEntity.LogContext INHERITS BusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"OpenEdge/LogAnalyzer/Include/eLogcontext.i"}
    
    DEFINE DATA-SOURCE srcLogContext FOR logdb.LogContext.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC LogContext():
        
        DEFINE VARIABLE hDataSourceArray AS HANDLE    NO-UNDO EXTENT 1.
        DEFINE VARIABLE cSkipListArray   AS CHARACTER NO-UNDO EXTENT 1.
        
        SUPER (DATASET dsLogContext:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
        hDataSourceArray[1] =  DATA-SOURCE srcLogContext:HANDLE.
         
                  
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
   
    METHOD PUBLIC VOID ReadLogContext(
        INPUT filter AS CHARACTER, 
        OUTPUT DATASET dsLogContext):
        
        SUPER:ReadData(filter).
              
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
        qh:SET-BUFFERS(BUFFER LogContext:HANDLE).
        qh:QUERY-PREPARE("PRESELECT EACH LogContext " + cWhere).
        qh:QUERY-OPEN ().
        numRecs = qh:NUM-RESULTS.

    END METHOD.
    
    
END CLASS.
