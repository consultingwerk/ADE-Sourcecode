/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Set of db options 
    Syntax      : 
    Description : 
    Author(s)   : 
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DatabaseOptionContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.DatabaseOptionSet.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IDatabaseOptionSet.
using Progress.Lang.Error.
using Progress.Lang.Object.

class OpenEdge.DataAdmin.DatabaseOptionSet inherits DataAdminCollection implements IDatabaseOptionSet: 
    
    constructor DatabaseOptionSet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
   
    constructor DatabaseOptionSet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt, DatabaseOptionContext)) then 
            undo, throw new IllegalArgumentError("Invalid context type passed to DatabaseOptionSet constructor"). 
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        return new DatabaseOptionContext().
    end.     
    
    method public override logical Add(o as Object):
        return this-object:Add(cast(o, IDatabaseOption)).
    end method.
    
    method public logical Add(input poDbOption as IDatabaseOption):  
        if Contains(poDbOption) then
            return false. 
            
        return Context:AddEntity(poDbOption).
    end method.  
    
	method override public void Import(pcFile as character ):	
		super:Import(input pcFile).	
    end method.

	method override protected void PrepareExport(  ):
	    /* noop */
	end method.

	method override protected void PrepareExportList(  ):
	    /* noop */
	end method.

	method override protected void PrepareExportTree(  ):
        /* noop */
	end method.

    method public override logical Remove(input poDbOption as Object):
        return Remove(cast(poDbOption, IDatabaseOption)).
    end method.  
    
    method public logical Remove(input poDbOption as IDatabaseOption):
        AssertNotNull(poDbOption, "Database Option").
        
        return Context:Delete(poDbOption:Code).
    end method.  
   
    method public override logical Contains(obj as Object):
        return Contains(cast(obj, IDatabaseOption)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.
   
    method public logical Contains(input poDbOption as IDatabaseOption):
        if poDbOption:ContextId <> ContextId then 
            return false.
        if not CanFind(poDbOption:Code) then
            return false.
        return poDbOption:Equals(this-object:Find(poDbOption:Code)).      
    end method.  
    
    method override logical Equals(obj as Object): 
        define variable tset as DatabaseOptionSet no-undo. 
        if super:Equals(obj) then 
            return true.
        else do:
            tset = cast(obj,DatabaseOptionSet).  
            return this-object:ContextId = tset:ContextId. 
        end.
        catch e as Error :
            return false.   
        end catch.
    end method.
        
     method public IDatabaseOption Find(input pcCode as character):
        return cast(Context:FindEntity(pcCode), IDatabaseOption). 
    end method.   
             
    method public logical CanFind(input pcCode as character):
        return Context:CanFind(pcCode).
    end method.   
    
end class.
