 /************************************************
  Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Set of Auth Tags granted to Roles
    Syntax      : 
    Description : 
    Author(s)   : dugrau 
    Created     : 2023-07-24
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.AuthTagContext.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.IAuthTag.
using OpenEdge.DataAdmin.IAuthTagSet.
using OpenEdge.DataAdmin.AuthTagSet.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.DataAdmin.AuthTagSet inherits DataAdminCollection implements IAuthTagSet:
    
    constructor AuthTagSet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
   
    constructor AuthTagSet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,AuthTagContext)) then 
            undo, throw new IllegalArgumentError("Invalid context type passed to AuthTagSet constructor"). 
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        return new AuthTagContext().
    end.     
    
    method public override logical Add(o as Object):
        return this-object:Add(cast(o,IAuthTag)).
    end method.
    
    method public logical Add(input poAuthTag as IAuthTag):  
        if Contains(poAuthTag) then
            return false. 
        return Context:AddEntity(poAuthTag).
    end method.  
    
	method override public void Import(pcFile as character ):	
		super:Import(input pcFile).	
    end method.

    method public override logical Remove(input poAuthTag as Object):
        return Remove(cast(poAuthTag, IAuthTag)).
    end method.  
    
    method public logical Remove(input poAuthTag as IAuthTag):
        AssertNotNull(poAuthTag, "AuthTag").
        return Context:Delete(poAuthTag:Name).
    end method.  
   
    method public override logical Contains(obj as Object):
        return Contains(cast(obj, IAuthTag)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.
   
    method public logical Contains(input poAuthTag as IAuthTag):
        if poAuthTag:ContextId <> ContextId then 
            return false.
        if not CanFind(poAuthTag:Name) then
            return false.
        return poAuthTag:Equals(this-object:Find(poAuthTag:Name)).      
    end method.  
    
    method override logical Equals(obj as Object): 
        define variable tset as AuthTagSet no-undo. 
        if super:Equals(obj) then 
            return true.
        else do:
            tset = cast(obj,AuthTagSet).  
            return this-object:ContextId = tset:ContextId. 
        end.
        catch e as Error :
            return false.   
        end catch.
    end method.
        
     method public IAuthTag Find(pcAuthTag as character):
        return cast(Context:FindEntity(pcAuthTag),IAuthTag). 
    end method.   
             
    method public logical CanFind(pcAuthTag as character):
        return Context:CanFind(pcAuthTag).
    end method.   

    method override protected void PrepareExport(  ):
    end method.

    method override protected void PrepareExportTree(  ):
    end method.
    
    method override protected void PrepareExportList(  ):
    end method.
    
end class.
