 /*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : PartitionPolicyFieldList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jul 18 19:41:31 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyFieldQuery.

class OpenEdge.DataAdmin.Support.PartitionPolicyFieldList inherits DataAdminCollection implements IFieldList: 
    define property ContextQuery as PartitionPolicyFieldQuery no-undo
    get():
          return cast(Context,PartitionPolicyFieldQuery).
    end.
    
	constructor public PartitionPolicyFieldList (  ):
		super ().
	end constructor.
		
	constructor public PartitionPolicyFieldList ( contxt as PartitionPolicyFieldQuery ):
		super (input contxt).
	end constructor.
	
    method public override logical Add(pObj as Object).
        define variable inst as IField no-undo.
        inst = cast(pObj,IField). /* cast to get error */
        return this-object:Add(inst).
    end.  
    
	method public logical Add( pfld as IField ):
	    AssertNotNull(pFld,"Field").
		Context:AddEntity(pfld).
		return true.
	end method.

	method override public logical Contains( iobj as Object ):
		if valid-object(iobj) and type-of(iobj,Ifield) then 
		    return Contains(cast(iobj,Ifield)).
		 return false.
	end method.
    
    method public logical Contains( iobj as IField):
        return Context:Canfind(iObj:name). 
    end method.

	method override protected IDataAdminContext CreateLocalContext(  ):
		return new PartitionPolicyFieldContext().
	end method.

	method public IField Get( i as integer ):
	    define variable elem as IDataAdminElement no-undo.
        return cast(ContextQuery:FindEntityAtRow(i),IField).
        catch e as Progress.Lang.Error :
        	return ?.	
        end catch.
    end method.    

	method public integer IndexOf( pfld as IField ):
	    AssertNotNull(pFld,"Field").
        return ContextQuery:IndexOf(pfld:Name).
	end method.

	method public integer IndexOf( iobj as Object ):
	    if valid-object(iobj) and type-of(iobj,Ifield) then 
             return IndexOf(cast(iobj,Ifield)).
        return 0.
    end method.

	method override protected void PrepareExport(  ):
	end method.

	method override protected void PrepareExportList(  ):
	end method.

	method override protected void PrepareExportTree(  ):
	end method.
    
    method public override logical Remove(obj as  Object):
        define variable fld as IField no-undo. 
        AssertNotNull(obj,"Field").
        fld = cast(obj,IField).
        return Remove(fld).
    end method.
    
    method public logical Remove(pFld as IField):
        AssertNotNull(pFld,"Field").
        if Contains(pFld) then
            return Context:Delete(pFld:name).
        return false.   
    end method.

end class.