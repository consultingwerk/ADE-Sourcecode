/*************************************************************/
/* Copyright (c) 2012,2013 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query for Users
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Apr 2012
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.UserContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.Query.PartitionQuery abstract inherits FilteredContext implements IPartitionContext: 
	
	/** Parent context (Model) may change so don't store this */
	define protected property UserContext as UserContext no-undo
	    get():
	        return cast(Model,UserContext).
	    end.
  
    constructor public PartitionQuery (sourcecntxt as IDataAdminModel,pfilter as char):
        super (sourcecntxt,pfilter).      
    end constructor.
    
    constructor public PartitionQuery (sourcecntxt as IDataAdminModel,pReq as IRequestInfo):
        super(sourcecntxt,pReq).
    end constructor.
    
    constructor public PartitionQuery (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyvalue as char):
        super(sourcecntxt,pcParent,pcKeyValue). 
    end constructor.
    
    constructor public PartitionQuery (sourcecntxt as IDataAdminModel,pparent as iRow,pReq as IRequestInfo):
        super(sourcecntxt,pParent,pReq). 
    end constructor.
    
    constructor public PartitionQuery (sourcecntxt as IDataAdminModel,pcparent as char,pcKeyValues as char extent,pReq as IRequestInfo):
        super (sourcecntxt,pcparent,pcKeyValues,pReq).      
    end constructor.
    
	constructor protected PartitionQuery (pSource as IDataAdminModel, pcParent as char, pcKeyValue as char,pReq as IRequestInfo ):
		super (pSource,pcParent,pcKeyValue,pReq).	    
	end constructor.
    
     
    method abstract public logical FindTable(pctable as char).   
    method abstract public logical FindField(pctable as char,pcField as char).   
    method abstract public logical FindIndex(pctable as char,pcIndex as char, pccollation as char).   
  
    method abstract public logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).   
    method abstract public logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).
    method abstract public logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).
    method abstract public logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).    
    method abstract public logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).
    method abstract public logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char).
    
    method abstract public logical Allocate().
/*    method abstract public logical Deallocate():*/
   
    method public IDataAdminElement FindGroupEntity(pcGroup as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
        define variable hBuffer as handle no-undo.
        if FindGroup(pcGroup,pctable,pcField, pcIndex, pccollation) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.          
    end method.  
    
    method public IDataAdminElement FindTenantEntity(pcTenant as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
        define variable hBuffer as handle no-undo.
        if FindTenant(pcTenant,pctable,pcField, pcIndex, pccollation) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.                   
    end method.  
    
    method public IDataAdminElement FindPolicyDetailEntity(pcDetail as char,pctable as char,pcField as char, pcIndex as char,pccollation as char):
        define variable hBuffer as handle no-undo.
        if FindPolicyDetail(pcDetail,pctable,pcField, pcIndex, pccollation) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.                                    
    end method.    
    
    method public IDataAdminElement FindTableEntity(pctable as char):
        define variable hBuffer as handle no-undo.
        if FindTable(pctable) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.          
    end method.  
    
    method public IDataAdminElement FindFieldEntity(pctable as char,pcField as char):
        define variable hBuffer as handle no-undo.
        if FindField(pctable,pcField) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.          
    end method.  
    
    method public IDataAdminElement FindIndexEntity(pctable as char,pcIndex as char,pcCollation as char):
        define variable hBuffer as handle no-undo.
        if FindIndex(pctable,pcIndex,pcCollation) then
        do:
            hBuffer = QueryHandle:get-buffer-handle (this-object:Table).
            return Model:FindEntity(hBuffer,RequestInfo).  
        end.          
    end method.  
    
    /* we cannot pass ttPartion.AreaName to server, since it is mapped
       to tenant and mess up join of area of partition   */  
    method public override character ColumnSource(pcColumn as char):
        if pccolumn = "AreaName" then 
            pcColumn = "Area.Name". 
        return super:ColumnSource(pcColumn).
    end method.
    
    method public override character ColumnSortSource(pcColumn as char):
        if pccolumn = "AreaName" then 
            pcColumn = "Area.Name". 
        return super:ColumnSortSource(pcColumn).
    end method.
    
end class.