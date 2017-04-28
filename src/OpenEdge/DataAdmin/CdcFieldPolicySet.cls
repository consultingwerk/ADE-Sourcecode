 
 /*------------------------------------------------------------------------
    File        : CdcFieldPolicySet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Nov 23 16:42:26 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.ICdcFieldPolicySet.
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.DataAccess.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Core.CodeWriter from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.CdcFieldPolicySet inherits DataAdminCollection implements ICdcFieldPolicySet:
    
    constructor CdcFieldPolicySet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
    
    constructor CdcFieldPolicySet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,CdcFieldPolicyContext)) then 
             undo, throw new IllegalArgumentError("Invalid context type passed to CdcPolicy constructor"). 
    end constructor. 
    
    constructor CdcFieldPolicySet(cntxt as CdcFieldPolicyContext):
        super(cntxt).  
    end constructor. 
    
    constructor CdcFieldPolicySet(cntxt as FilteredContext):
        super(cntxt).  
    end constructor. 

	method public logical Add( input newfpolicy as ICdcFieldPolicy ):
		if Contains(newfpolicy) then
            return false.   
        return Context:AddEntity(newfpolicy).
	end method.

	method public logical CanFind( input fpolicyName as character ):
		return Context:CanFind(fpolicyName).
	end method.

	method override public logical Contains( input obj as Object ):
		return Contains(cast(obj,ICdcFieldPolicy)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
	end method.

	method public logical Contains( input fpolicy as ICdcFieldPolicy ):
		 if fpolicy:ContextId <> ContextId then 
            return false.
        //if not CanFind(fpolicy:CdcTablePolicyname) then
        //    return false.
        //return fpolicy:Equals(this-object:Find(fpolicy:CdcTablePolicyname)). 
	end method.
	
	method public override void ExportTree(pcfile as char):
        define variable writer as IDataAdminExporter no-undo.
        define variable codewriter as CodeWriter no-undo.
        writer = GetExporter(pcfile).
        writer:WriteToFile(this-object,pcfile,"All").
    end method. 
    
     method public override void  ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        define variable codewriter as CodeWriter no-undo.
        define variable fileext as character no-undo.
        define variable iPos as integer no-undo.
        fileExt = GetFileExtension(pcFile).
        case fileExt:
            /* deal with current limitations that does not handle the TenantGroups collection */  
            when "p" or when CodeExtension then 
            do:
                /* The code writer actually support this, but it writes tenants, so externally 
                   we give error if actually asking for it (see below) */ 
                iPos = lookup("TenantGroupMembers",pcCollectionList).
                if iPos > 0 then
                    undo, throw new UnsupportedOperationError("Cannot generate code for TenantGroupMembers. Use Tenants instead.").
                /* for .p we generate code for Tenants when passing TenantGroupMembers, 
                   so we just fix the list internally. */
                iPos = lookup("Tenants",pcCollectionList).
                if iPos > 0 then 
                   entry(iPos,pcCollectionList) = "TenantGroupMembers".
            end.
            otherwise 
            do:
               iPos = lookup("Tenants",pcCollectionList).
               if iPos > 0 then
                    undo, throw new UnsupportedOperationError("Export of Tenants collection. Use TenantGroupMembers instead.").
               
            end.
        end.
            
        super:ExportTree(pcfile,pcCollectionlist). 
    end method.
    
    

	method override protected IDataAdminContext CreateLocalContext(  ):
		define variable cntxt as IDataAdminContext no-undo.
        return new CdcTablePolicyContext().
	end method.

	method public ICdcFieldPolicy Find( input fpolicy as character ):
		return cast(Context:FindEntity(fpolicy),ICdcFieldPolicy ).   
	end method.

	method override protected void PrepareExport(  ):
		
	end method.

	method override protected void PrepareExportList(  ):
		TableHandle:default-buffer-handle:buffer-field("DataAreaName"):serialize-hidden = true.               
        TableHandle:default-buffer-handle:buffer-field("IndexAreaName"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("DataAreaurl"):serialize-hidden = true.         
        TableHandle:default-buffer-handle:buffer-field("IndexAreaurl"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("cdcFieldPoliciesurl"):serialize-hidden = true.   
        TableHandle:default-buffer-handle:buffer-field("numFields"):serialize-hidden = false.  
        /* @todo - not nice add some higher level logic to deal with this*/    
        TableHandle:default-buffer-handle:buffer-field("numFields"):serialize-name = "numFields". 
	end method.

	method override protected void PrepareExportTree(  ):
		 TableHandle:default-buffer-handle:buffer-field("CdcsURL"):serialize-hidden = true.
	end method.
	
	method override logical Equals(obj as Object): 
        define variable tset as TenantGroupSet no-undo. 
        if super:Equals(obj) then 
            return true.
        else do:
            tset = cast(obj,TenantGroupSet).  
            return this-object:ContextId = tset:ContextId. 
        end.
        catch e as Error :
            return false.   
        end catch.    
    end method.
	
	method public override logical Remove(o as Object):
        define variable det as ICdcFieldPolicy no-undo.
        det = cast(o,ICdcFieldPolicy). /* cast to get error */
        return Remove(det). 
    end method. 

	method public logical Remove( input fpolicy as ICdcFieldPolicy ):
		AssertNotNull(fpolicy,"CdcFieldPolicy").
        return Context:Delete(fpolicy:Field:name).
	end method. 

end class.