/*************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

 /*------------------------------------------------------------------------
    File        : PartitionPolicyIndexSet
    Purpose     : Extend TableIndexSet to support add and remove
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Feb 26 2014
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyIndexQuery from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IIndex from propath.
 
using OpenEdge.DataAdmin.Support.TableIndexSet.
using Progress.Lang.*.

block-level on error undo, throw.

class OpenEdge.DataAdmin.Support.PartitionPolicyIndexSet inherits TableIndexSet: 

	constructor public PartitionPolicyIndexSet (cntxt as PartitionPolicyIndexQuery ):
		super (cntxt).
	end constructor.
	
    method protected override IDataAdminContext CreateLocalContext():
        undo, throw new UnsupportedOperationError("Create local context in PartitionPolicyIndexSet"). 
    end.    
     
    method public override logical Add(o as Object):
        define variable idx as IIndex no-undo.
        idx = cast(o,IIndex). /* cast to get error  (no error if done in input) */
        return this-object:Add(idx).
    end method.  
    
    method public logical Add( pidx as IIndex ).  
        if Contains(pidx) then
            return false.   
        return Context:AddEntity(pidx).
    end method.  
    
    method public override logical Remove(o as Object):
        define variable idx as IIndex no-undo.
        idx = cast(o,IIndex). /* cast to get error  (no error if done in input) */
        return Remove(idx).
    end method.  
    
    method public logical Remove(pidx as IIndex):
        AssertNotNull(pidx,"Index").
        return Context:Delete(pidx:Name).
    end method.  
   
end class.