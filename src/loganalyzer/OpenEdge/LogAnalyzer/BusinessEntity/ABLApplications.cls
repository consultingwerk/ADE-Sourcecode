 
/*------------------------------------------------------------------------
   File        : ABLApplications
   Syntax      : 
   Author(s)   : isyed
   Created     : Mon Jan 01 23:18:55 EST 2018
   Notes       : 
 ----------------------------------------------------------------------*/
  
@program FILE(name="ABLApplications.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="ABLApplications", URI="/ABLApplications", schemaName="dsABLApplications", schemaFile="LogAnalyzer/PASOEContent/WEB-INF/openedge/OpenEdge/LogAnalyzer/Include/eABLapplications.i").

USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.JsonObject FROM PROPATH.
USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.
USING OpenEdge.LogAnalyzer.BusinessEntity.ABLApplications FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.LogAnalyzer.BusinessEntity.ABLApplications INHERITS BusinessEntity:
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    
    {"OpenEdge/LogAnalyzer/Include/eABLapplications.i"}
    
    DEFINE DATA-SOURCE srcABLApplications FOR logdb.ABLApplications.
    
    
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ABLApplications():
        
        DEFINE VARIABLE hDataSourceArray AS HANDLE    NO-UNDO EXTENT 1.
        DEFINE VARIABLE cSkipListArray   AS CHARACTER NO-UNDO EXTENT 1.
        
        SUPER (DATASET dsABLApplications:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
        hDataSourceArray[1] =  DATA-SOURCE srcABLApplications:HANDLE.
         
                  
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
    METHOD PUBLIC VOID ReadABLApplications(
        INPUT filter AS CHARACTER, 
        OUTPUT DATASET dsABLApplications):
        
        SUPER:ReadData(filter).
              
    END METHOD.
     
    
END CLASS.
