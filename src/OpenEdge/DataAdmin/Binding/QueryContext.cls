 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : QueryContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.AbstractFilteredContext.
using OpenEdge.DataAdmin.Lang.QueryString.
using OpenEdge.DataAdmin.Message.ITableResponse.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.QueryContext inherits AbstractFilteredContext: 
    
    define private variable mTableNum as integer no-undo.
    define private variable mBuffer as handle extent no-undo.
	constructor public QueryContext ( pModel as IDataAdminModel,pcQuery as char, phBuffer as handle extent):	
		super (input pModel).
		BaseQuery  = pcQuery.
        mBuffer = phBuffer.
	    CreateQuery().
	end constructor.
	
	method protected override handle extent GetBufferHandles():
        return mBuffer.
    end method.  
	
    constructor public QueryContext ( pModel as IDataAdminModel,pcQuery as char, phBuffer as handle):        
        this-object(pModel,pcQuery,SingleExtent(phBuffer)).
    end constructor.
    
    method protected override void CreateQuery():
        super:CreateQuery().
        prepare().
        QueryHandle:query-open ().
    end method.
      
    method protected override void RowCreated().       
        define variable rid as rowid no-undo.
        define variable lok as logical no-undo.
        rid = TableHandle:default-buffer-handle:rowid.
        QueryHandle:query-open().
        QueryHandle:get-buffer-handle(1):find-by-rowid(rid).         
        OnRowCreated().
    end method.
    
    method protected override void RowDeleted(). 
    
    end method. 
    
    method protected logical FindInQuery(rid as rowid):
        define variable i   as integer no-undo.
        define variable lok as logical no-undo.
        define variable hbuffer as handle no-undo.
        define variable qstring as QueryString no-undo.
        define variable ridarray as rowid extent 18 no-undo.
        define variable hUniqueQuery as handle no-undo. 
        
        if QueryHandle:get-buffer-handle(i):rowid = rid then 
           return true.
        
        if QueryHandle:num-buffers = 1 then
            lok = QueryHandle:reposition-to-rowid(rid) no-error. 
        else do :   
 
            create query hUniqueQuery.
            do i = 1 to QueryHandle:num-buffers: 
                hUniqueQuery:add-buffer(QueryHandle:get-buffer-handle(i)).
            end.    
            qstring = new QueryString(QueryHandle:prepare-string).
            qstring:AddExpression("rowid(" + QueryHandle:get-buffer-handle(mTableNum):name + ") = to-rowid(" + quoter(rid) + ")").
            hUniqueQuery:query-prepare (qstring:BuildQueryString()).
            hUniqueQuery:query-open.
            hUniqueQuery:get-first.
/*            extent(ridarray) = hUniqueQuery:num-buffers.*/
            do i = 1 to hUniqueQuery:num-buffers: 
                hBuffer = hUniqueQuery:get-buffer-handle(i).
                
                ridarray[i] = hbuffer:rowid. 
            end.
            lok = QueryHandle:reposition-to-rowid(ridarray).     
            delete object hUniqueQuery.  
        end.
        if lok and not QueryHandle:get-buffer-handle(i):avail then 
            QueryHandle:get-next. 
        return lok.
    end method.     
    
    method public override logical CanFind(i as int):
        define variable lok as logical no-undo.
        define variable rid as rowid   no-undo.   
        if Model:Find(i) then 
        do:
            rid = QueryHandle:get-buffer-handle (1):rowid.     
            lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error. 
            if rid <> ? then
                QueryHandle:reposition-to-rowid(rid).
        end.       
        return lok.
    end method. 
    
    
    method public override logical Find(i as int):
        define variable lok as logical no-undo.
        define variable hbuf as handle no-undo.
        if Model:Find(i) then 
        do: 
            hBuf = QueryHandle:get-buffer-handle(1).
            lok = TableHandle:default-buffer-handle:rowid = hBuf:rowid.
            if not lok then 
            do:
                lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error. 
                if lok and not hBuf:avail then 
                    QueryHandle:get-next.
            end.
        end.
        return lok.          
    end method. 
    
    method public override logical CanFind(c as char):
        define variable lok as logical no-undo.
        define variable rid as rowid   no-undo.   
        
        if Model:Find(c) then 
        do:
        
            rid = QueryHandle:get-buffer-handle (1):rowid.     
            lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error. 
          
        end.     
        return lok.
    end method. 
    
    method public override logical Find(c as char):
        define variable lok as logical no-undo.   
        define variable hbuf as handle no-undo. 
        if Model:Find(c) then 
        do: 
            hBuf = QueryHandle:get-buffer-handle(1).
            lok = TableHandle:default-buffer-handle:rowid = hBuf:rowid.
            if not lok then 
            do:
                lok = QueryHandle:reposition-to-rowid(TableHandle:default-buffer-handle:rowid) no-error. 
                if lok and not hBuf:avail then 
                    QueryHandle:get-next.
            end.
        end.
        return lok.          
    end method.
     
    /* single table import of the entity (flat - no tree)*/
    method public override void Import(pcfile as char,pcMode as char):
        Model:Import(pcfile,pcMode).
        QueryHandle:query-open(). 
    end method.
    
     /* single table import of the entity (flat - no tree)*/
    method public override void Import(pJson as JsonObject,pcMode as char):
        Model:Import(pJson,pcMode).
        QueryHandle:query-open(). 
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, i as int).
        Model:ImportRow(pcfile,i).
    end method.
    
    /* single row import of the entity (flat no tree) */     
    method public override void ImportRow(pcfile as char, c as char).
        Model:Importrow(pcfile,c).
    end method.
    
/*    method public override void ImportTree(pcfile as char).*/
/*        Model:ImportTree(pcfile).                         */
/*    end method.                                            */
    
    method public override void ReadChild(pParentrow as IRow, pjson as JSONObject).
        Model:ReadChild(pParentrow, pjson).
    end method.
    
    method public override void TableRefreshed(msg as ITableResponse):
        QueryHandle:query-open(). 
    end method.   
end class.