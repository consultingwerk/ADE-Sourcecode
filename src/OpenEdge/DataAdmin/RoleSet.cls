 /************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Set of security roles 
    Syntax      : 
    Description : 
    Author(s)   : pjudge 
    Created     : 2016-04-26
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.RoleContext.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IRoleSet.
using OpenEdge.DataAdmin.RoleSet.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.DataAdmin.RoleSet inherits DataAdminCollection implements IRoleSet: 
    
    constructor RoleSet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
   
    constructor RoleSet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,RoleContext)) then 
            undo, throw new IllegalArgumentError("Invalid context type passed to RoleSet constructor"). 
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        return new RoleContext().
    end.     
    
    method public override logical Add(o as Object):
        return this-object:Add(cast(o,IRole)).
    end method.
    
    method public logical Add(input poRole as IRole):  
        if Contains(poRole) then
            return false. 
        return Context:AddEntity(poRole).
    end method.  
    
	method override public void Import(pcFile as character ):	
		super:Import(input pcFile).	
    end method.

    method public override logical Remove(input poRole as Object):
        return Remove(cast(poRole, IRole)).
    end method.  
    
    method public logical Remove(input poRole as IRole):
        AssertNotNull(poRole, "Role").
        return Context:Delete(poRole:Name).
    end method.  
   
    method public override logical Contains(obj as Object):
        return Contains(cast(obj, IRole)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.
   
    method public logical Contains(input poRole as IRole):
        if poRole:ContextId <> ContextId then 
            return false.
        if not CanFind(poRole:Name) then
            return false.
        return poRole:Equals(this-object:Find(poRole:Name)).      
    end method.  
    
    method override logical Equals(obj as Object): 
        define variable tset as RoleSet no-undo. 
        if super:Equals(obj) then 
            return true.
        else do:
            tset = cast(obj,RoleSet).  
            return this-object:ContextId = tset:ContextId. 
        end.
        catch e as Error :
            return false.   
        end catch.
    end method.
        
     method public IRole Find(domainname as char):
        return cast(Context:FindEntity(domainname),IRole). 
    end method.   
             
    method public logical CanFind(domainname as char):
        return Context:CanFind(domainname).
    end method.   
         
    method override protected void PrepareExport(  ):
    end method.

    method override protected void PrepareExportTree(  ):
    end method.
    
    method override protected void PrepareExportList(  ):
    end method.
    
end class.
