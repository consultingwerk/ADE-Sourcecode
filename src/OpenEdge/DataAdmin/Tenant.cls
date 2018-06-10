/*************************************************************/
/* Copyright (c) 2010,2012 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : Tenant
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Jun 12 21:20:19 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.Error from propath.
using Progress.Lang.Object from propath.

using OpenEdge.DataAdmin.DataAdminService from propath. 
using OpenEdge.DataAdmin.AbstractPartitionOwner from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.IPartitionMap from propath.
using OpenEdge.DataAdmin.ITenantGroupSet from propath.
using OpenEdge.DataAdmin.ITenantGroupMemberSet from propath.
using OpenEdge.DataAdmin.IDomainSet from propath.
using OpenEdge.DataAdmin.IUserSet from propath.
using OpenEdge.DataAdmin.ISequenceValueMap from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IDataAdminExporter from propath.
using OpenEdge.DataAdmin.IDataAdminSerializable from propath. 
using OpenEdge.DataAdmin.IRequestInfo from propath. 
using OpenEdge.DataAdmin.Tenant from propath.

using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Binding.TenantContext from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext from propath.

using OpenEdge.DataAdmin.Error.DataAdminError from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.Error.ForbiddenOperationError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath. 
using OpenEdge.DataAdmin.Error.DataError from propath. 
using OpenEdge.DataAdmin.Error.InvalidPropertyValueError from propath. 
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath. 
using OpenEdge.DataAdmin.Error.CreateOnlyPropertyError from propath. 
using OpenEdge.DataAdmin.Error.ValidationError from propath. 
using OpenEdge.DataAdmin.Core.JSONWriter from propath.  
using OpenEdge.DataAdmin.Core.CodeWriter from propath.  

class OpenEdge.DataAdmin.Tenant inherits AbstractPartitionOwner implements ITenant:
    /* implements ITenant, IDataAdminElement, IDataAdminSerializable */  
    define private property ValidTypeList as char 
       init "Regular,Super"
       get.
          
    define private variable mChild as logical no-undo. 
    
    
    define public property Type as character no-undo           
       init "Regular"
       get():
           if valid-handle(mBuffer) then
               return mBuffer::Type.
           else do:
               return Type. 
           end.    
        end.
        set(pType as character):
            if valid-object(Service) then
            do:
                undo, throw new CreateOnlyPropertyError("Tenant",Name,"Type").
            end.     
            if pType = "Default" then 
                undo, throw new ValidationError("Tenant",Name,"Type","cannot be set to ~"Default~". There can only be one default Tenant").   
            
            if lookup(pType,ValidTypeList) = 0 then 
                undo, throw new InvalidPropertyValueError("Tenant",Name,"Type",pType,ValidTypeList).   
            if valid-handle(mBuffer) then
            do:
                Context:SetProperty(mBuffer:rowid,"Type",pType).
            end.
            Type = pType.
        end.    
    
    define public property ExternalID as char no-undo           
        get():
            if valid-handle(mBuffer) then
                return mBuffer::ExternalID.
            else
                return ExternalID. 
        end.
        set(pExternalID as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::ExternalID = pExternalID.
            end.
            else
                ExternalID = pExternalID.
        end.    
       
    define public override property DefaultAllocation as char no-undo                 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::DefaultAllocation.
            else
                return DefaultAllocation. 
        end.
        set(pDefaultAllocation as char):
            if Type = "Super" or Type = "Default" then
            do:
                undo, throw new ReadOnlyPropertyError("Tenant",Name,"Type",
                     "The property is not editable for super and default Tenants" 
                                                      ).
            end.     
            if lookup(pDefaultAllocation,ValidDefaultAllocationList) = 0 then 
                undo, throw new InvalidPropertyValueError("Tenant",Name,"DefaultAllocation",pDefaultAllocation,ValidDefaultAllocationList).   
         
                
            if valid-handle(mBuffer) then
            do:
                Context:SetProperty(mBuffer:rowid,"DefaultAllocation",pDefaultAllocation).
            end.
            DefaultAllocation = pDefaultAllocation.
        end.    
          
    define public override  property IsDataEnabled as logical no-undo  
        init true        
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsDataEnabled.
            else
                return IsDataEnabled. 
        end.
        set(pIsDataEnabled as logical):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsDataEnabled = pIsDataEnabled.
            end.
            else
                IsDataEnabled = pIsDataEnabled.
        end. 

    define public override property DefaultDataArea as IArea no-undo   
        get():
            if not valid-object(DefaultDataArea) then
            do: 
                if valid-handle(mBuffer) and valid-object(Service) then do:
                    /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
                    if mBuffer::DefaultDataAreaNumber <> 0 then 
                        return Service:GetArea(mBuffer::DefaultDataAreaNumber).
                    else if mBuffer::DefaultDataAreaName > "" then
                        return Service:GetArea(mBuffer::DefaultDataAreaName).
                end.                    
            end.
            return DefaultDataArea.
        end.
        set(pDefaultDataArea as IArea):
            if Type = "Super" or Type = "Default" then
            do:
                undo, throw new ReadOnlyPropertyError("Tenant",Name,"Type",
                     "The property is not editable for super and default Tenants" 
                                                        ).     
            end.
            if not valid-object(pDefaultDataArea) then 
            do:
                undo, throw new UnknownValueError("DefaultDataArea").          
            end.
            /* if we want to support optimistic locking we may need to do a RefreshRow here since
               the areaname may not have been populated if the read was lazy 
               Alternatively update -Areanumber, but this requires change in datasource also  */  
            if valid-handle(mBuffer) then
                Context:SetProperty(mBuffer:rowid,"DefaultDataAreaName",pDefaultDataArea:Name).
            DefaultDataArea = pDefaultDataArea.
        end. 
    
    define public override property DefaultIndexArea as IArea no-undo     
        get():
            if not valid-object(DefaultIndexArea) then
            do: 
                if valid-handle(mBuffer) and valid-object(Service) then do:
                    /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
                    if mBuffer::DefaultIndexAreaNumber <> 0 then 
                        return Service:GetArea(mBuffer::DefaultIndexAreaNumber).
                    else if mBuffer::DefaultIndexAreaName > "" then
                        return Service:GetArea(mBuffer::DefaultIndexAreaName).
                end.                    
            end.
            return DefaultIndexArea. 
        end.
        set(pDefaultIndexArea as IArea):
            if Type = "Super" or Type = "Default" then
            do:
                undo, throw new ReadOnlyPropertyError("Tenant",Name,"DefaultIndexArea",
                     "The property is not editable for super and default Tenants" 
                                                      ).
            end.   
            if not valid-object(pDefaultIndexArea) then 
            do:
                undo, throw new UnknownValueError("DefaultIndexArea").          
            end.   
             /* if we want to support optimistic locking we may need to do a RefreshRow here since
               the areaname may not have been populated if the read was lazy 
               Alternatively update -Areanumber, but this requires change in datasource also  */  
            if valid-handle(mBuffer) then
                Context:SetProperty(mBuffer:rowid,"DefaultIndexAreaName",pDefaultIndexArea:Name).
            DefaultIndexArea = pDefaultIndexArea.
        end. 
        
    define public override property DefaultLobArea   as IArea no-undo    
        get():
            
            if not valid-object(DefaultLobArea) then
            do: 
                /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
                if valid-handle(mBuffer) and valid-object(Service) then do:
                    if mBuffer::DefaultLobAreaNumber <> 0 then 
                        return Service:GetArea(mBuffer::DefaultLobAreaNumber).
                    else if mBuffer::DefaultDataAreaName > "" then
                        return Service:GetArea(mBuffer::DefaultLobAreaName).
                end.                   
            end.
            return DefaultLobArea. 
        end.
        set(pDefaultLobArea as IArea):
            if Type = "Super" or Type = "Default" then
            do:
                undo, throw new ReadOnlyPropertyError("Tenant",Name,"DefaultLobArea",
                     "The property is not editable for super and default Tenants" 
                                                      ).
            end.  
            if not valid-object(pDefaultLobArea) then 
            do:
               undo, throw new UnknownValueError("DefaultLobArea").          
            end.         
             /* if we want to support optimistic locking we may need to do a RefreshRow here since
               the areaname may not have been populated if the read was lazy 
               Alternatively update -Areanumber, but this requires change in datasource also  */   
            if valid-handle(mBuffer) then
                Context:SetProperty(mBuffer:rowid,"DefaultLobAreaName",pDefaultLobArea:Name).
            DefaultLobArea = pDefaultLobArea.
        end. 
        
/*    define public property SequenceBlock as int no-undo*/
/*        get():                                         */
/*            return mBuffer::SequenceBlock.             */
/*        end.                                           */
/*        set.                                           */
        
    define public property SequenceValues as ISequenceValueMap no-undo      
        get():
            define variable err as Error no-undo.
            if not valid-object(SequenceValues) then
            do:
                SequenceValues = cast(GetChildCollection("sequenceValues"),ISequenceValueMap).
            end.
            return SequenceValues.
            catch e as DataAdminError :
                err =  e:InnerError.
                if valid-object(err) then 
                do:
                    if err:GetMessageNum(1) = 15956 then 
                         undo, throw new ForbiddenOperationError("SequenceValues for other tenants can only be accessed by a super-tenant.", e).
                end. 
                undo, throw e.   
            end catch.
        end.     
        private set.
     /* ROhit- change name to use ID instead */
     
    define public property TenantGroups as ITenantGroupSet no-undo                 
        get():
            if not valid-object(TenantGroups) then
            do:
                TenantGroups = cast(GetChildCollection("tenantGroups"),ITenantGroupSet).
                
            end.
            return TenantGroups.
        end.
        private set .
    
    define public property TenantGroupMembers as ITenantGroupMemberSet no-undo                 
        get():
            if not valid-object(TenantGroupMembers) then
            do:
                TenantGroupMembers = cast(GetChildCollection("tenantGroupMembers"),ITenantGroupMemberSet).
/*                TenantGroupMembers:Tenant = this-object.*/
            end.
            return TenantGroupMembers.
        end.
        private set .
    
      
    define public property Domains as IDomainSet no-undo  
        get():
            if not valid-object(Domains) then
            do:             
                Domains = cast(GetChildCollection("domains"),IDomainSet).
            end.         
            return Domains.     
        end.
        private set.
     
     define public property Users as IUserSet no-undo  
        get():
            if not valid-object(Users) then
            do:
                Users = cast(GetChildCollection("users"),IUserSet).
/*                Users:Tenant = this-object.*/
                /*
                if valid-object(Service) then 
                do:
                     Users = Service:GetUsers(serializename + ".id/" + string(id)).     
                     Users:Tenant = this-object. 
                end.
                */                        
            end.         
            return Users.     
        end.
        private set. 
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
        
    constructor public Tenant (cntxt as IDataAdminModel):
        super (cntxt). 
    end constructor.
   
    constructor public Tenant (cntxt as IDataAdminModel,preq as IRequestInfo):
        super (cntxt,pReq). 
    end constructor.
      
    constructor public Tenant (cname as character):
        super (cname).
    end constructor. 
    
    /* if lazy datasource none of the arename fields will have data 
       it is sufficient to check one of them - super does not have 
       area  - default may have...  */ 
    method protected override logical NeedsRefresh():
        return Type <> "Super" and valid-handle(mBuffer) and mBuffer::DefaultDataAreaName = "".
    end method.    
    method protected override IDataAdminModel CreateLocalContext(): 
        return new TenantContext().  
    end method.
    
    method public override logical Allocate():
        IsAllocated = true.
        return Partitions:Allocate().
    end method.        
    
    method public void RemoveData():
    end method.   
        
    method public override void Export():
        Export("tenant.json").
    end method.          
    
    method protected character GetCreateError():
        return "Tenant" + Name + " was not " 
               + (if valid-object(Service) 
                  then "created in service " + quoter(Service:Name) 
                  else "added to TenantSet")
               + ".". 
    end method.
    
    method public override void WriteTree(tree as IContextTree):
        WriteTree(tree,"domains,partitions,tenantGroupMembers").        
    end method.
    
      /* write specified collections (default all)
         See override in ExportTree(file,collection) that deals with tenantGroups versus TenantGroupMembers for .p */
    method public override void WriteTree(tree as IContextTree,pcCollections as char):
        define variable i as integer no-undo.
        define variable cntxt as TenantContext no-undo.
        define variable cColl as character no-undo.
        
        if not valid-object(Context) then
        do:
            cntxt = new TenantContext().
            Attach(cntxt).
        end.
        
        tree:SetHandle(SerializeName,mBuffer,mBuffer:rowid).   
        do i = 1 to num-entries(pccollections):
           ccoll = entry(i,pccollections).
           case ccoll:
               when "partitions" then 
               do:
                   tree:SetJoin(SerializeName,"partitions","Name,TenantName").
                   Partitions:WriteTree(tree,"").
               end.  
               when "domains" then 
               do:
                   tree:SetJoin(SerializeName,"domains","Name,TenantName").
                   Domains:WriteTree(tree,"users").
               end.  
               when "users" then 
               do:
                   tree:SetJoin(SerializeName,"domains","Name,TenantName").
                   Users:WriteTree(tree,"users").
               end.  
               when "tenantGroupMembers" then 
               do:
                   tree:SetJoin(SerializeName,"tenantGroupMembers","Name,TenantName").
                   TenantGroupMembers:WriteTree(tree,"").
               end.    
               otherwise 
                   undo, throw new IllegalArgumentError("WriteTree collection " + quoter(ccoll)). 
 
           end.    
        end.
    end method.
 
    method public override void ExportAsProcedure(pcfile as char,pcCollectionlist as char):
        define variable iPos as integer no-undo.
         /* The code writer actually support this, but it writes tenants, so externally 
             we give error if actually asking for it (see below) */ 
        iPos = lookup("TenantGroupMembers",pcCollectionList).
        if iPos > 0 then
           undo, throw new UnsupportedOperationError("Cannot generate code for TenantGroupMembers. Use TenantGroups instead.").
               
        /*  we generate code for TenantGroups when passing TenantGroupMembers, 
            so we just fix the list internally. */
        iPos = lookup("TenantGroups",pcCollectionList).
        if iPos > 0 then 
            entry(iPos,pcCollectionList) = "TenantGroupMembers".
            
        super:ExportAsProcedure(pcfile,pcCollectionlist).     
    end.
    
    /** override to get codewriter if .p and to handle collections for this */
    method public override void ExportTree(pcfile as char,pcCollectionlist as char):
        define variable writer as IDataAdminExporter no-undo.
        define variable iPos as integer no-undo.
        define variable cExt as character no-undo.
        /* The code writer support this, but it writes tenants, so externally 
            we give error if actually asking for it (see below) */ 
        cExt = GetFileExtension(pcfile).
             /* deal with current limitations that does not handle the TenantGroups collection */  
        if cExt = "p" or cExt = CodeExtension then 
        do:
            ExportAsProcedure(pcfile,pcCollectionlist).
        end.
        else do:
            iPos = lookup("TenantGroups",pcCollectionList).
             if iPos > 0 then
                 undo, throw new UnsupportedOperationError("Export of TenantGroups collection. Use TenantGroupMembers instead.").
                    
            super:ExportTree(pcfile,pcCollectionlist). 
        end.    
    end method. 
        
    method protected override void AssertPartitions():
        /* all valid */    
    end method.    
end class.
