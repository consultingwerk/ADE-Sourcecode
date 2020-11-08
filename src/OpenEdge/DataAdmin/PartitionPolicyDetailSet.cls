 /*************************************************************/
 /* Copyright (c) 2013,2019 by Progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.  
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.DataAccess.* from propath.
using OpenEdge.DataAdmin.Binding.* from propath.
using OpenEdge.DataAdmin.Core.CodeWriter from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

class OpenEdge.DataAdmin.PartitionPolicyDetailSet inherits DataAdminCollection implements IPartitionPolicyDetailSet : 
   
    
    constructor PartitionPolicyDetailSet():      
        /* the super empty constructor will call CreateLocalContext() */ 
        super(). 
    end constructor.
    
    constructor PartitionPolicyDetailSet(cntxt as IDataAdminContext):
        super(cntxt).
        if not (type-of(cntxt,FilteredContext) or type-of(cntxt,PartitionPolicyDetailContext)) then 
             undo, throw new IllegalArgumentError("Invalid context type passed to PartitionPolicy constructor"). 
    end constructor. 
    
    constructor PartitionPolicyDetailSet(cntxt as PartitionPolicyDetailContext):
        super(cntxt).  
    end constructor. 
    
    constructor PartitionPolicyDetailSet(cntxt as FilteredContext):
        super(cntxt).  
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
        define variable cntxt as IDataAdminContext no-undo.
        return new PartitionPolicyContext().
    end.     
    
    method public override logical Add(o as Object):
        define variable policy as IPartitionPolicy no-undo.
        policy = cast(o,IPartitionPolicy). /* cast to get error */
        return this-object:Add(policy).
    end method.  
    
    method public logical Add(detail as IPartitionPolicyDetail).  
        if Contains(detail) then
            return false.   
        return Context:AddEntity(detail).
    end method.  
    
    method public override logical Remove(o as Object):
        define variable det as IPartitionPolicyDetail no-undo.
        det = cast(o,IPartitionPolicyDetail). /* cast to get error */
        return Remove(det).
    end method.  
    
    method public logical Remove(policy as IPartitionPolicyDetail):
        AssertNotNull(policy,"PartitionPolicyDetail").
        return Context:Delete(policy:Name).
    end method.  
   
    method public override logical Contains(obj as Object):
        return Contains(cast(obj,IPartitionPolicyDetail)).   
        catch e as Progress.Lang.Error :
        	return false.	
        end catch.
    end method.
   
    method public logical Contains(policy as IPartitionPolicyDetail):
        if policy:ContextId <> ContextId then 
            return false.
        if not CanFind(policy:name) then
            return false.
        return policy:Equals(this-object:Find(policy:name)).      
    end method.  
      
    method public IPartitionPolicyDetail Find(policyname as char):
        return cast(Context:FindEntity(policyname),IPartitionPolicyDetail ).    
    end method.   
    
    method public logical CanFind(policyname as char):
        return Context:CanFind(policyname).
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
     
    method override protected void PrepareExport(  ):
/*        buffer ttTenant:handle:buffer-field("URL"):serialize-hidden = true.*/
    end method.    
     
    method override protected void PrepareExportTree():
        TableHandle:default-buffer-handle:buffer-field("PartitionsURL"):serialize-hidden = true.
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
    
    /**
     * 
     * @param context 
     */
     /*
    method public override void Attach(cntxt as IDataAdminContext).
    
        define variable oldcontext as IDataAdminContext no-undo.
        if not valid-object(cntxt) then
            undo, throw new UnknownValueError("Attach","context").  
        
        cntxt:Copy(this-object:Context).                     
        if valid-object(mpartitions) then 
        do:
            cntxt:Service:AttachPartitions(mpartitions).
        end.        
        oldcontext = this-object:Context.  
        this-object:Context = cntxt.
        OnContextChanged().
        if not oldcontext:IsShared then
            delete object oldcontext.        
  
    end method.
    */
       
    /* All - expand collections */
/*    method public override void WriteAllTo(writer as IDataAdminWriter):                                 */
/*        undo, throw new UnsupportedOperationError("WriteAllTo TenantSet.").                             */
/*                                                                                                        */
/*        writer:WriteContext(Context).                                                                   */
/*        if not valid-object(Service) then                                                               */
/*        do:                                                                                             */
/*            if not valid-object(mpartitions) then                                                       */
/*                mpartitions = new PartitionSchemaMap().                                                 */
/*            writer:WriteChild(cast(mpartitions,IDataAdminSerializable),SerializeName,"Name,TenantName").*/
/*/*            writer:WriteChild(cast(domains,IDataAdminSerializable),SerializeName,"Name,TenantName").*/*/
/*        end.                                                                                            */
/*        else do:                                                                                        */
/*            if not valid-object(mPartitions) then                                                       */
/*                mpartitions = Service:GetTenantPartitions().                                            */
/*            writer:WriteChild(cast(mpartitions,IDataAdminSerializable),SerializeName,"Name,TenantName").*/
/*/*            writer:WriteChild("domains",SerializeName,"Name,TenantName").*/                           */
/*        end.                                                                                            */
/*/*        partitions = Service:GetPartitions().*/                                                       */
/*        /* the domains will write users, so we don't call that from here  */                            */
/*                                                                                                        */
/*    end method.                                                                                         */

/*    /* write a short list of the data with url to details */            */
/*    method public override void WriteListTo(writer as IDataAdminWriter):*/
/*        writer:WriteContextList(Context,"Name,Id,Description,AreasUrl").*/
/*    end method.                                                         */
    
    method override protected void PrepareExportList():
        TableHandle:default-buffer-handle:buffer-field("DefaultDataAreaName"):serialize-hidden = true.    
        TableHandle:default-buffer-handle:buffer-field("DefaultLobAreaName"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("DefaultIndexAreaName"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("DefaultDataAreaurl"):serialize-hidden = true.    
        TableHandle:default-buffer-handle:buffer-field("DefaultLobAreaurl"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("DefaultIndexAreaurl"):serialize-hidden = true.      
        TableHandle:default-buffer-handle:buffer-field("partitionPolicyDetailsurl"):serialize-hidden = true.   
        TableHandle:default-buffer-handle:buffer-field("numFields"):serialize-hidden = false.  
        /* @todo - not nice add some higher level logic to deal with this*/    
        TableHandle:default-buffer-handle:buffer-field("numFields"):serialize-name = "numFields".   
    end method.    
    
   
end class.
