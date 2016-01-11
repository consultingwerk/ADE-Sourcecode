/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 01 23:52:38 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.QueryContext.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminElement.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.PartitionQueryContext inherits QueryContext implements IPartitionContext: 
    
    constructor public PartitionQueryContext ( pModel as IDataAdminModel,pcQuery as char, phBuffer as handle extent): 
        super (pModel,pcquery,phbuffer).
    end constructor.
    
    constructor public PartitionQueryContext ( pModel as IDataAdminModel,pcQuery as char, phBuffer as handle):        
        super (pModel,pcquery,phbuffer).
    end constructor.
    
    method public logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):FindGroup(pcGroup,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):FindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):FindPolicyDetail(pcDetail,pctable,pcField,pcIndex,pcCollection).
    end method.  
    
    method public logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):CanFindGroup(pcGroup,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):CanFindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):CanFindPolicyDetail(pcDetail,pctable,pcField,pcIndex,pcCollection).
    end method.  
    
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
      
    /*  Allocate currently not supported for querycontext  */
    method public logical Allocate():
        undo, throw new UnsupportedOperationError("Allocate() in PartitionQueryContext").
    end method.
     
    /*  Deallocate currently not supported for querycontext  */
    method public logical Deallocate():
        undo, throw new UnsupportedOperationError("Deallocate() in PartitionQueryContext").
    end method.
 
    
end class.