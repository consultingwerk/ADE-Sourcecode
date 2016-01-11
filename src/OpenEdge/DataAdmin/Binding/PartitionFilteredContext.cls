/*************************************************************/
/* Copyright (c) 2010,2013 by progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : PartitionQueryContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 01 23:52:38 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.Query.PartitionQuery.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IDataAdminElement.
using Progress.Lang.*.


class OpenEdge.DataAdmin.Binding.PartitionFilteredContext inherits PartitionQuery implements IPartitionContext: 
    
    constructor public PartitionFilteredContext ( pModel as IDataAdminModel,filter as char ):
        super (pModel,filter).
    end constructor.
    
    constructor public PartitionFilteredContext ( pModel as IDataAdminModel,pReq as IRequestInfo):
        super (pModel,pReq).
    end constructor.
    
    method public override logical FindTable(pname as character):
        undo, throw new UnsupportedOperationError("PartitionFilteredContext FindTable").
    end.   
     
    method public override logical FindIndex(pname as character,pcIndex as char,pccol as char):
        undo, throw new UnsupportedOperationError("PartitionFilteredContext FindIndex").
    end.    
        
    method public override logical FindField(pname as character,pcField as char):
        undo, throw new UnsupportedOperationError("PartitionFilteredContext FindField").
    end. 
    
    
    method public override logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):FindGroup(pcGroup,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public override logical FindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,iPartitionContext):FindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public override logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,iPartitionContext):FindPolicyDetail(pcDetail,pctable,pcField,pcIndex,pcCollection).
    end method. 
    
    method public override logical CanFindGroup(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,iPartitionContext):CanFindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public override logical CanFindTenant(pcTenant as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,iPartitionContext):CanFindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection).
    end method.
    
    method public override logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return cast(Model,IPartitionContext):CanFindPolicyDetail(pcDetail,pctable,pcField,pcIndex,pcCollection).
    end method. 
    
    
    /*  Allocate currently not supported for filteredcontext  */
    method public override logical Allocate():
        undo, throw new UnsupportedOperationError("Allocate() in PartitionFilteredContext").
    end method.
 
end class.