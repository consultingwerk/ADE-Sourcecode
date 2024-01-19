/************************************************
Copyright (c) 2011,2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ServiceContextFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Sep 13 22:02:26 EDT 2011
    Notes       : 
------------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.AdministratorContext.
using OpenEdge.DataAdmin.Binding.DataSecurityContext.
using OpenEdge.DataAdmin.Binding.Factory.AbstractContextFactory.
using OpenEdge.DataAdmin.Binding.Factory.IContextFactory.
using OpenEdge.DataAdmin.Binding.Factory.IServiceContextFactory.
using OpenEdge.DataAdmin.Binding.Factory.LocalContextFactory.
using OpenEdge.DataAdmin.Binding.FieldPermissionContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.PermissionContext.
using OpenEdge.DataAdmin.Binding.SchemaChanges.
using OpenEdge.DataAdmin.Binding.SecurityOptionsContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.Binding.TablePermissionContext.
using OpenEdge.DataAdmin.Binding.UserFieldPermissionContext.
using OpenEdge.DataAdmin.Binding.UserPermissionContext.
using OpenEdge.DataAdmin.Binding.UserTablePermissionContext.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.NotFoundError.
using OpenEdge.DataAdmin.IDataAdminService.
using Progress.Lang.*.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Factory.ServiceContextFactory inherits AbstractContextFactory implements IServiceContextFactory: 
     
     define public property AdministratorContext as AdministratorContext no-undo 
        get():
            if not valid-object(AdministratorContext) then 
            do:
                AdministratorContext = new AdministratorContext(this-object).       
            end.
            return AdministratorContext.   
        end. 
        set.
     
     define public property PermissionContext as PermissionContext no-undo 
        get():
            if not valid-object(PermissionContext) then 
            do:
                PermissionContext = new PermissionContext(this-object).                   
            end.
            return PermissionContext. 
        end. 
        set.
    
     define public property UserPermissionContext as UserPermissionContext no-undo 
        get():
            if not valid-object(UserPermissionContext) then 
            do:
                UserPermissionContext = new UserPermissionContext(this-object).       
            end.
            return UserPermissionContext.   
        end. 
        set.
     
     define public property FieldPermissionContext as FieldPermissionContext no-undo 
        get():
            if not valid-object(FieldPermissionContext) then 
            do:
                FieldPermissionContext = new FieldPermissionContext(this-object).       
            end.
            return FieldPermissionContext.   
        end. 
        set.
     
    define public property TablePermissionContext as TablePermissionContext no-undo 
        get():
            if not valid-object(TablePermissionContext) then 
            do:
                TablePermissionContext = new TablePermissionContext(this-object).       
            end.
            return TablePermissionContext.   
        end. 
        set.
      
      
    define public property DataSecurityContext as DataSecurityContext no-undo 
        get():
            if not valid-object(DataSecurityContext) then 
            do:
                DataSecurityContext = new DataSecurityContext(this-object).       
            end.
            return DataSecurityContext.   
        end. 
        set.
    
       define public override property PartitionContext as PartitionContext no-undo 
           get(): 

            if not valid-object(PartitionContext) then
            do:
                PartitionContext = new PartitionContext(this-object).
            end.
            return PartitionContext.
        end.
        set.
        
        define public property SecurityOptionsContext as SecurityOptionsContext no-undo 
        get():
            if not valid-object(SecurityOptionsContext) then 
            do:
                SecurityOptionsContext = new SecurityOptionsContext(this-object).                   
            end.
            return SecurityOptionsContext. 
        end. 
        set.
        
     /* override to be false... */
     define public override property IsLocal as logical  no-undo 
         get .
    
    constructor public ServiceContextFactory ( pservice as IDataAdminService, padapter as ServiceAdapter ):
        super (pservice, padapter).
    end constructor.
    
    method public IDataAdminModel GetLocalContext(pname as char):                
        define variable factory as IContextFactory no-undo.
        factory = new LocalContextFactory(this-object).
        return factory:GetContext(pname).
    end method.
    
    method public IDataAdminModel GetLocalContextByAnyName(pname as char):                
        define variable factory as IContextFactory no-undo.
        factory = new LocalContextFactory(this-object).
        return factory:GetContextByAnyName(pname).
    end method.
             
    method public SchemaChanges GetSchemaDefinitionContext(pcfile as char): 
        return new SchemaChanges(pcfile,this-object).       
    end method.
    
    method public UserTablePermissionContext GetUserTablePermissionContext():
        return new UserTablePermissionContext(this-object).
    end method.
    
    method public UserFieldPermissionContext GetUserFieldPermissionContext():
        return new UserFieldPermissionContext(this-object).
    end method.
    
    method protected override IDataAdminModel  GetInternalContext(pname as char):
        case pname:
            when "FieldPermission" then
                return FieldPermissionContext.

            when "TablePermission" then
                return TablePermissionContext.

            when "UserFieldPermission" then
                return GetUserFieldPermissionContext().

            when "UserTablePermission" then
                return UserPermissionContext:GetChild("userTablePermissions").

            when "UserPermission" then
                return UserPermissionContext.
            
            otherwise return super:GetInternalcontext(pname).      
        end.
     end method.    
            
end class.