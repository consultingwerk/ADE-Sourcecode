/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Set of security roles 
    Syntax      : 
    Description : 
    Author(s)   : 
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.GrantedRoleContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.GrantedRoleSet.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Role.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.DataAdmin.GrantedRoleSet inherits DataAdminCollection implements IGrantedRoleSet: 
    
    constructor GrantedRoleSet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
   
    constructor GrantedRoleSet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,GrantedRoleContext)) then 
            undo, throw new IllegalArgumentError("Invalid context type passed to GrantedRoleSet constructor"). 
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        return new GrantedRoleContext().
    end.     
    
    method public override logical Add(o as Object):
        return this-object:Add(cast(o,IGrantedRole)).
    end method.
    
    method public logical Add(input poRole as IGrantedRole):  
        if Contains(poRole) then
            return false. 
        return Context:AddEntity(poRole).
    end method.  
    
	method override public void Import(pcFile as character ):	
		super:Import(input pcFile).	
    end method.

    method public override logical Remove(input poRole as Object):
        return Remove(cast(poRole, IGrantedRole)).
    end method.  
    
    method public logical Remove(input poRole as IGrantedRole):
        AssertNotNull(poRole, "Granted role").
        return Context:Delete(poRole:Id).
    end method.  
   
    method public override logical Contains(obj as Object):
        return Contains(cast(obj, IGrantedRole)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.
   
    method public logical Contains(input poRole as IGrantedRole):
        if poRole:ContextId <> ContextId then 
            return false.
        if not CanFind(poRole:Id) then
            return false.
        return poRole:Equals(this-object:Find(poRole:Id)).      
    end method.  
    
    method override logical Equals(obj as Object): 
        define variable tset as GrantedRoleSet no-undo. 
        if super:Equals(obj) then 
            return true.
        else do:
            tset = cast(obj,GrantedRoleSet).  
            return this-object:ContextId = tset:ContextId. 
        end.
        catch e as Error :
            return false.   
        end catch.
    end method.
        
     method public IGrantedRole Find(input pcGrantId as character):
        return cast(Context:FindEntity(pcGrantId),IGrantedRole). 
    end method.   
             
    method public logical CanFind(input pcGrantId as character):
        return Context:CanFind(pcGrantId).
    end method.   
         
    method override protected void PrepareExport(  ):
        
    end method.

    method override protected void PrepareExportTree(  ):
    end method.
    
    method override protected void PrepareExportList(  ):
        TableHandle:default-buffer-handle:buffer-field("Id"):serialize-hidden = false.
    end method.

end class.
