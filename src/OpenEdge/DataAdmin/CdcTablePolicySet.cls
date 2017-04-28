 /* ***********************************************************/
/* Copyright (c) 2015-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

 /*------------------------------------------------------------------------
    File        : CdcPolicySet
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Nov 23 14:41:46 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw. 
using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminCollection.
using OpenEdge.DataAdmin.ICdcTablePolicySet.
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.DataAccess.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Core.CodeWriter from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.CdcTablePolicySet inherits DataAdminCollection implements ICdcTablePolicySet: 
    
     constructor CdcTablePolicySet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
    
     constructor CdcTablePolicySet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,CdcTablePolicyContext)) then 
             undo, throw new IllegalArgumentError("Invalid context type passed to CdcTablePolicy constructor"). 
    end constructor.
    
    constructor CdcTablePolicySet(cntxt as CdcTablePolicyContext):
        super(cntxt).  
    end constructor.
    
    constructor CdcTablePolicySet(cntxt as FilteredContext):
        super(cntxt).  
    end constructor. 

	method public logical Add(newpolicy as ICdcTablePolicy ):
		if Contains(newpolicy) then
            return false.   
        return Context:AddEntity(newpolicy).
	end method.
	
	method public override logical Add(o as Object):
        define variable policy as ICdcTablePolicy no-undo.
        policy = cast(o,ICdcTablePolicy). /* cast to get error */
        return this-object:Add(policy).
    end method.

	method public logical CanFind( input policyname as character ):
		return Context:CanFind(policyname).
	end method.

	method override public logical Contains( obj as Object ):
		return Contains(cast(obj,ICdcTablePolicy)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
	end method.

	method public logical Contains( policy as ICdcTablePolicy ):
		if policy:ContextId <> ContextId then 
            return false.
        if not CanFind(policy:Name) then
            return false.
        return policy:Equals(this-object:Find(policy:Name)).  
	end method.

	method override protected IDataAdminContext CreateLocalContext(  ):		
		define variable cntxt as IDataAdminContext no-undo.
        return new CdcTablePolicyContext().
	end method.

	method public ICdcTablePolicy Find( policyname as character ):
		 return cast(Context:FindEntity(policyname),ICdcTablePolicy ).  
	end method.
	
	 method public override void Export(pcFile as char):  
        ExportTree(pcFile) .
    end method. 
    
     method public override void ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        define variable codewriter as CodeWriter no-undo.
        define variable fileext as character no-undo.
        define variable iPos as integer no-undo.
        fileExt = GetFileExtension(pcFile).
        case fileExt:
            /* deal with current limitations that does not handle the TenantGroups collection */  
            when "p" or when CodeExtension then 
            do:
                /*
                /* The code writer actually support this, but it writes tenants, so externally 
                   we give error if actually asking for it (see below) */ 
                iPos = lookup("CdcTablePolicyFields",pcCollectionList).
                if iPos > 0 then
                    undo, throw new UnsupportedOperationError("Cannot generate code for CdcTablePolicyFields. Use Fields instead.").
                /* for .p we generate code for Tenants when passing TenantGroupMembers, 
                   so we just fix the list internally. */
                iPos = lookup("Fields",pcCollectionList).
                if iPos > 0 then 
                   entry(iPos,pcCollectionList) = "CdcTablePolicyFields".*/
            end.
            otherwise 
            do:
               iPos = lookup("Fields",pcCollectionList).
               if iPos > 0 then
                    undo, throw new UnsupportedOperationError("Export of Fields collection. Use CdcTablePolicyFields instead.").
               
            end.
        end.
            
        super:ExportTree(pcfile,pcCollectionlist). 
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
		TableHandle:default-buffer-handle:buffer-field("PartitionsURL"):serialize-hidden = true.
	end method.

	method public logical Remove(policy as ICdcTablePolicy ):
		 AssertNotNull(policy,"CdcTablePolicy").
        return Context:Delete(policy:Name).
	end method.
	
	method public override logical Remove(o as Object):
        define variable policy as ICdcTablePolicy no-undo.
        policy = cast(o,ICdcTablePolicy). /* cast to get error */
        return Remove(policy).
    end method. 

end class.