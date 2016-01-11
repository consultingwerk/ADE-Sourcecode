 
 /*------------------------------------------------------------------------
    File        : prodict.pro._pro-model
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Feb 18 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.* from propath.

using OpenEdge.DataAdmin.Binding.ServiceAdapter from propath.
 
using OpenEdge.DataAdmin.Message.IFetchResponse from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.FetchRequest from propath.

using prodict.misc._query from propath.
using prodict.pro._imodel from propath.

class prodict.pro._pro-model implements _imodel: 
     
    define private variable serviceAdapter as ServiceAdapter no-undo.
    define private variable dataQueries    as _query  extent no-undo.
    define private variable cTables        as character no-undo.
    /* passed to serviceadpater DataAccessFactory */
    define public property EntityName as character no-undo get. set.
  
    define protected property DatasetHandle as handle no-undo get. set.
	
    /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public _pro-model (name as char,datasethdl as handle):
		define variable i as integer no-undo.
		super ().		
		DatasetHandle = datasethdl.
		extent(dataQueries) = DatasetHandle:num-buffers.
		EntityName = name.
		/* lookup  */
		do i = 1 to DatasetHandle:num-buffers:
		    cTables = cTables + (if i = 1 then "" else ",") + DatasetHandle:get-buffer-handle(i):name.
        end.        
        
		ServiceAdapter = new ServiceAdapter(ldbname("dictdb")).
	    ServiceAdapter:RequestComplete:Subscribe(DataRefreshed).     
	end constructor.
    
    method public _query GetQuery(pcTable as char):
        define variable i as integer no-undo.
        
        i = lookup(pcTable,cTables).
        if i = 0 then 
            undo, throw new AppError("Table " + pcTable + " not found in Model " + EntityName).
        if not valid-object(dataQueries[i]) then
            dataQueries[i] = CreateQuery(i).
        
        return dataQueries[i].
    end method. 
     
    method public _query GetQuery(i as int):
        if i > DatasetHandle:num-buffers then 
            undo, throw new AppError(String(i) +  " is out of range for num tables in Model " + EntityName).
        if not valid-object(dataQueries[i]) then
            dataQueries[i] = CreateQuery(i).    
        return dataQueries[i].
    end method.  
    
    method protected _query CreateQuery(pcTable as char):
        define variable newquery as _query no-undo.
        newquery = new _query(DatasetHandle:get-buffer-handle(pcTable)).
        return newquery.
    end method.
    
    method protected _query CreateQuery(i as int):
        define variable newquery as _query no-undo.
        newquery = new _query(DatasetHandle:get-buffer-handle(i)).
        return newquery.
    end method.
    
    method public void FetchData():
        define variable msg as IFetchRequest no-undo.
        msg = new FetchRequest(EntityName,"",DatasetHandle).
        FetchData(msg).   
    end method.
        
    method public void FetchData(pcTables as char extent,pcQueries as character extent):  
        define variable msg as IFetchRequest no-undo.  
        define variable cBuffer as character no-undo.
        define variable i as integer no-undo.
        msg = new FetchRequest(EntityName,"",DatasetHandle). 
        do i = 1 to extent(pctables):
           msg:SetTableQuery(pcTables[i],pcQueries[i]).
        end.        
        FetchData(msg).  
    end method.
    
    method public void FetchData(pcQuery as character):
        define variable cBuffers as character extent 1 no-undo.
        define variable cQueries as character extent 1 no-undo.  
        cBuffers[1] = DatasetHandle:get-buffer-handle(1):name.
        cQueries[1] = pcQuery.
        this-object:FetchData(cBuffers,cQueries).         
    end method.
    
    method protected void FetchData(msg as IFetchRequest): 
        ServiceAdapter:FetchData(msg).
    end method.

    method protected void DataRefreshed(msg as IFetchResponse): 
        define variable hBuffer as handle no-undo.
        if msg:DataHandle <> DatasetHandle then
        do:
            DatasetHandle:copy-dataset(msg:DataHandle,yes,yes).
        end.
    end method.
    

	/*------------------------------------------------------------------------------
			Purpose: Remove the queries 																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	destructor public _pro-model ( ):
        define variable i as integer no-undo.
        do i = 1 to extent(dataQueries):
            if valid-object(dataQueries[i]) then
                delete object dataQueries[i] .
        end.
	end destructor.
     
end class.