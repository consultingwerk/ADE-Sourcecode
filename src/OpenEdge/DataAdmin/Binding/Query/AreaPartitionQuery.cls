/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : abstract query for partitions of an area 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Apr 2011
    Notes       : Known subclasses TablePartitionQuery, IndexPartitionQuery 
                  and FieldPartitionQuery 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.Query.PartitionQuery.
using OpenEdge.DataAdmin.Binding.Query.IPartitionQuery.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.Query.AreaPartitionQuery inherits PartitionQuery implements IPartitionContext: 
	/*------------------------------------------------------------------------------
			Purpose: Used for a collection of partitions of a schema element
			 		 mapped by tenant or group															  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	/** Parent context (Model) may change so don't store this */
	define private property PartitionContext as PartitionContext no-undo
	     get():
	         return cast(Model,PartitionContext).
	     end.
    define protected variable AreaName as character no-undo.
     
    constructor protected AreaPartitionQuery (pdatacontext as PartitionContext,pcAreaName as char,pReq as IRequestInfo):
		super (pdatacontext,"areas",pcAreaName,pReq).	 
 	    AreaName = pcAreaName.	     
	end constructor.
     
    method public override logical CanFind(pname as character):
        undo, throw new UnsupportedOperationError("AreaPartitionQuery CanFind with single key").
    end.    
     
    method public override logical Find(pname as character):
        undo, throw new UnsupportedOperationError("AreaPartitionQuery Find with single key").
    end.    
    
    method protected override IFetchRequest GetQueryRequest():
        define variable msg    as FetchRequest no-undo.
        define variable tree   as IContextTree no-undo.
        define variable hds    as handle no-undo.      
        tree = new ContextTree().
        AddTableTo(tree).       
        hds = tree:GetReadHandle().
        msg = new FetchRequest(Name,Id,hds,no). 
        return msg.  
    end method.
    
    method public override void ExportLastSaved(pcfile as char). 
        define variable hBuffer as handle no-undo.
        if valid-handle(LastSavedDataset) then
        do:
            hbuffer = LastSavedDataset:get-buffer-handle(TableHandle:Name) . 
            /*
            hbuffer:buffer-field ("SchemaName"):serialize-hidden = true.
            hbuffer:buffer-field ("SequenceName"):serialize-hidden = true.
            hbuffer:buffer-field ("Url"):serialize-hidden = true.         
             */
            if valid-handle(hBuffer) then 
                hBuffer:write-json ("File",pcFile,yes).    
        end.
    end method.  
           
    method public override logical FindTable(pname as character):
        undo, throw new UnsupportedOperationError("AreaPartitionQuery FindTable").
    end.   
     
    method public override logical FindIndex(pname as character,pcIndex as char,pccol as char):
        undo, throw new UnsupportedOperationError("AreaPartitionQuery FindIndex").
    end.    
        
    method public override logical FindField(pname as character,pcField as char):
        undo, throw new UnsupportedOperationError("AreaPartitionQuery FindField").
    end.    
             
    method public override logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):      
        return PartitionContext:FindAreaTenant(AreaName,pcTenant,pcTable,pcField,pcIndex,pcCollation).
    end method.
    
    method public override logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        return PartitionContext:FindAreaGroup(AreaName,pcGroup,pcTable,pcField,pcIndex,pcCollation).
    end method.
    
    method public override logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        return PartitionContext:FindAreaPolicyDetail(AreaName,pcDetail,pcTable,pcField,pcIndex,pcCollation).
    end method.
    
    method public override logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):      
        return PartitionContext:CanFindAreaTenant(AreaName,pcTenant,pcTable,pcField,pcIndex,pcCollation).
    end method.
    
    method public override logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        return PartitionContext:CanFindAreaGroup(AreaName,pcGroup,pcTable,pcField,pcIndex,pcCollation).
    end method.
     
    method public override logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollation as char):
        return PartitionContext:CanFindAreaPolicyDetail(AreaName,pcDetail,pcTable,pcField,pcIndex,pcCollation).
    end method.
    
     /*  Allocate probably does not make sense for area partitions  */
    method public override logical Allocate():
        undo, throw new UnsupportedOperationError("Allocate() in AreaPartitionContext").
    end method.
   
end class.