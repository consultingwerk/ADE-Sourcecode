 /*************************************************************/
  /* Copyright (c) 2011-2016 by progress Software Corporation. */
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
    Created     : Wed Aug 18 14:19:53 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.AllFieldContext.
using OpenEdge.DataAdmin.Binding.AllTableContext.
using OpenEdge.DataAdmin.Binding.AreaContext.
using OpenEdge.DataAdmin.Binding.AuthenticationSystemContext.
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext.
using OpenEdge.DataAdmin.Binding.CdcTablePolicyContext.
using OpenEdge.DataAdmin.Binding.CreateContext.
using OpenEdge.DataAdmin.Binding.DatabaseOptionContext.
using OpenEdge.DataAdmin.Binding.DomainContext.
using OpenEdge.DataAdmin.Binding.ExtentContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextFactory from propath.
using OpenEdge.DataAdmin.Binding.FieldContext.
using OpenEdge.DataAdmin.Binding.GrantedRoleContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IndexContext.
using OpenEdge.DataAdmin.Binding.IndexFieldContext.
using OpenEdge.DataAdmin.Binding.LocalIndexContext from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.RoleContext.
using OpenEdge.DataAdmin.Binding.SchemaContext.
using OpenEdge.DataAdmin.Binding.SequenceContext.
using OpenEdge.DataAdmin.Binding.SequenceValueContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.Binding.TableContext.
using OpenEdge.DataAdmin.Binding.TenantContext.
using OpenEdge.DataAdmin.Binding.TenantGroupContext.
using OpenEdge.DataAdmin.Binding.TenantGroupMemberContext.
using OpenEdge.DataAdmin.Binding.UserContext.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using OpenEdge.DataAdmin.IDataAdminService from propath.

class OpenEdge.DataAdmin.Binding.Factory.AbstractContextFactory abstract implements IContextFactory: 
    define public property ServiceAdapter as ServiceAdapter no-undo get. private set. 
    define public property Service as IDataAdminService no-undo get. private set. 
    define public abstract property IsLocal as logical no-undo get. 
    /* pretend this is a constant */   
    define private variable CLASS_NAMES_THAT_ENDS_WITH_E as char init "tables,sequences" no-undo.
    
    define public property ExtentContext as ExtentContext no-undo 
        get():
            if not valid-object(ExtentContext) then 
            do:
                ExtentContext = new ExtentContext(this-object).       
            end.
            return ExtentContext.   
        end. 
        set.
    
    define public property AreaContext as AreaContext no-undo 
        get():
            if not valid-object(AreaContext) then 
            do:
                AreaContext = new AreaContext(this-object).       
            end.
            return AreaContext.   
        end. 
        set.
        
    define public property SequenceValueContext as SequenceValueContext no-undo 
        get():
            if not valid-object(SequenceValueContext) then 
            do:
                SequenceValueContext = new SequenceValueContext("PUB",this-object).       
            end.
            return SequenceValueContext.   
        end. 
        set.
     
    define public property UserContext as UserContext no-undo 
        get():
            if not valid-object(UserContext) then 
            do:
                UserContext = new UserContext(this-object).       
            end.
            return UserContext.   
        end. 
        set.
           
    define public property DomainContext as DomainContext no-undo 
        get():
            if not valid-object(DomainContext) then 
            do:
                DomainContext = new DomainContext(this-object).       
            end.
            return DomainContext.   
        end. 
        set.
    
    define public property AuthenticationSystemContext as AuthenticationSystemContext no-undo 
        get():
            if not valid-object(AuthenticationSystemContext) then 
            do:
                AuthenticationSystemContext = new AuthenticationSystemContext(this-object).       
            end.
            return  AuthenticationSystemContext.   
        end. 
        set.
        
    define public property FieldContext as FieldContext no-undo 
        get():
            if not valid-object(FieldContext) then 
            do:
                FieldContext = new FieldContext(this-object).       
            end.
            return FieldContext.   
        end. 
        set.
            
    define public property IndexContext as IndexContext no-undo 
        get():
            if not valid-object(IndexContext) then 
            do:
                IndexContext = new IndexContext(this-object).       
            end.
            return IndexContext.   
        end. 
        set.   
        
     define public property IndexFieldContext as IndexFieldContext no-undo 
        get():
            if not valid-object(IndexFieldContext) then 
            do:
                IndexFieldContext = new IndexFieldContext(this-object).       
            end.
            return IndexFieldContext.   
        end. 
        set.  
        
     define public abstract property PartitionContext as PartitionContext no-undo 
        get. set. 
              
    define public property TableContext as TableContext no-undo 
        get():
            if not valid-object(TableContext) then 
            do:
                TableContext = new TableContext(this-object).       
            end.
            return TableContext.   
        end. 
        set.   
    
    define public property AllTableContext as AllTableContext no-undo 
        get():
            if not valid-object(AllTableContext) then 
            do:
                AllTableContext = new AllTableContext(this-object).       
            end.
            return AllTableContext.   
        end. 
        set.       
        
     define public property AllFieldContext as AllFieldContext no-undo 
        get():
            if not valid-object(AllFieldContext) then 
            do:
                AllFieldContext = new AllFieldContext(this-object).       
            end.
            return AllFieldContext.   
        end. 
        set.
        
    define public property SequenceContext as SequenceContext no-undo 
        get():
            if not valid-object(SequenceContext) then 
            do:
                SequenceContext = new SequenceContext(this-object).       
            end.
            return SequenceContext.   
        end. 
        set.   
    
     define public property TenantGroupMemberContext as TenantGroupMemberContext no-undo 
        get():
            if not valid-object(TenantGroupMemberContext) then 
            do:
                TenantGroupMemberContext = new TenantGroupMemberContext(this-object).       
            end.
            return TenantGroupMemberContext.   
        end. 
        set.
     
    define public property TenantGroupContext as TenantGroupContext no-undo 
        get():
            if not valid-object(TenantGroupContext) then 
            do:
                TenantGroupContext = new TenantGroupContext(this-object).       
            end.
            return TenantGroupContext.   
        end. 
        set.
        
    define public property TenantContext as TenantContext no-undo 
        get():
            if not valid-object(TenantContext) then 
            do:
                TenantContext = new TenantContext(this-object).       
            end.
            return TenantContext.   
        end. 
        set.
        
    define public property LocalIndexContext as LocalIndexContext no-undo 
        get():
            if not valid-object(LocalIndexContext) then 
            do:
                LocalIndexContext = new LocalIndexContext(this-object).       
            end.
            return LocalIndexContext.   
        end. 
        set.
        
    define public property PartitionPolicyContext as PartitionPolicyContext no-undo 
        get():
            if not valid-object(PartitionPolicyContext) then 
            do:
                PartitionPolicyContext = new PartitionPolicyContext(this-object).       
            end.
            return PartitionPolicyContext.   
        end. 
        set.
        
    define public property CdcTablePolicyContext as CdcTablePolicyContext no-undo 
        get():
            if not valid-object(CdcTablePolicyContext) then 
            do:
                CdcTablePolicyContext = new CdcTablePolicyContext(this-object).       
            end.
            return CdcTablePolicyContext.   
        end. 
        set.
        
    define public property CdcFieldPolicyContext as CdcFieldPolicyContext no-undo 
        get():
            if not valid-object(CdcFieldPolicyContext) then 
            do:
                CdcFieldPolicyContext = new CdcFieldPolicyContext(this-object).       
            end.
            return CdcFieldPolicyContext.   
        end. 
        set.
    /*    
    define public property CdcTablePolicyFieldContext as CdcTablePolicyFieldContext no-undo 
        get():
            if not valid-object(CdcTablePolicyFieldContext) then 
            do:
                CdcTablePolicyFieldContext = new CdcTablePolicyFieldContext(this-object).       
            end.
            return CdcTablePolicyFieldContext.   
        end. 
        set.*/
    
    define public property PartitionPolicyFieldContext as PartitionPolicyFieldContext no-undo 
        get():
            if not valid-object(PartitionPolicyFieldContext) then 
            do:
                PartitionPolicyFieldContext = new PartitionPolicyFieldContext(this-object).       
            end.
            return PartitionPolicyFieldContext.   
        end. 
        set.
     
     define public property PartitionPolicyDetailContext as PartitionPolicyDetailContext no-undo
        get():
            if not valid-object(PartitionPolicyDetailContext) then
            do:
                PartitionPolicyDetailContext = new PartitionPolicyDetailContext(this-object).
            end.
            return PartitionPolicyDetailContext.
        end.
        set.
    
    define public property SchemaContext as SchemaContext no-undo 
        get():
            if not valid-object(SchemaContext) then 
            do:
                SchemaContext = new SchemaContext(this-object) .       
            end.
            return SchemaContext.   
        end. 
        set.
    
    define public property DatabaseOptionContext as DatabaseOptionContext no-undo 
        get():
            if not valid-object(DatabaseOptionContext) then 
                assign this-object:DatabaseOptionContext = new DatabaseOptionContext(this-object) .       
            return this-object:DatabaseOptionContext.   
        end get. 
        private set.

    define public property RoleContext as RoleContext no-undo 
        get():
            if not valid-object(RoleContext) then 
                assign this-object:RoleContext = new RoleContext(this-object) .       
            return this-object:RoleContext.   
        end get. 
        set.

    define public property GrantedRoleContext as GrantedRoleContext no-undo 
        get():
            if not valid-object(GrantedRoleContext) then 
                assign this-object:GrantedRoleContext = new GrantedRoleContext(this-object) .       
            return this-object:GrantedRoleContext.   
        end get. 
        set.
        
   /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public AbstractContextFactory (pservice as IDataAdminService,padapter as ServiceAdapter):
        super ().
       
        Service = pservice.
        ServiceAdapter = padapter.
    end constructor.
            
    method public IDataAdminContext GetCreateContext(cntxtname as char):
        define variable createcontext as CreateContext no-undo.
        createcontext = new CreateContext(GetContext(cntxtname)).   
    end method.
    
    method public IDataAdminContext GetFilterContext(cntxtname as char,filter as char):
        define variable filteredcontext as FilteredContext no-undo.
        filteredcontext = new FilteredContext(GetContext(cntxtname),filter).     
    end method.
    
    /* override in local context to allow joins for many to many for new objects 
       to use service for the other end of the relation  */        
    method public IDataAdminModel GetLookupContext(pname as char):
        return GetContext(pname).
    end method.
    
    /* override in local context to allow joins for many to many for new objects 
       to use service for the other end of the relation  */        
    method public IDataAdminModel GetLookupContextBySerializeName(pname as char):
        return GetContextBySerializeName(pname).
    end method.
    
    method public IDataAdminModel GetContext(pname as char):
        define variable cname as character no-undo.
        case pname:
            when "UserFieldPermission" or when "UserTablePermission" then
            do:
                undo, throw new UnsupportedOperationError
                          ("Context for " + quoter(pname) + " ." 
                           + chr(10)
                           + "is not managed by the service. The UserPermission manages this internally.").
            end.    
            otherwise 
                return GetInternalContext(pname). 
            
        end.
        catch e1 as NotFoundError  :
            undo, throw new NotFoundError("Context " + quoter(pname) + " was not found.").    
        end catch.  
        catch e2 as Progress.Lang.Error :
        	undo, throw e2.	
        end catch.        
    end method.
    
    method protected character GetNameFromTableName(pname as char):
        case pname:
            when "_Area" then
                return "Area".
            when "_sec-authentication-domain" then
                 return "Domain".
            when "_sec-authentication-system" then
                return "AuthenticationSystem".
            when "_AreaExtent" then
                return "Extent".
            when "_Field" then
                return "Field".
            when "_Index" then
                return "Index".
            when "_StorageObject" then
                return "Partition".
            when "_Partition-Policy" then
                return "PartitionPolicy".
            when "_Cdc-Table-Policy" then
                return "CdcTablePolicy".
            when "_Partition-Policy-Detail" then
                return "PartitionPolicyDetail".
            when "_Cdc-Field-Policy" then
                return "CdcFieldPolicy".
            when "_Partition-Set" then
                return "TenantGroup".
            when "_Partition-Set-Detail" then
                return "TenantGroupMember".
/*            when "Schema" then          */
/*                return "Schema".              */
/*            when "SchemaDefinition" then*/
/*                return "SchemaDefinition".              */
            when "_sequence" then
                return "Sequence".
/*            when "SequenceValue" then  */
/*                return "SequenceValue".*/
            when "_file" then
                return "Table".
/*            when "_File" then     */
/*                return "AllTable".*/
            when "_tenant" then
                return "Tenant".
            when "_user" then
                return "User".
            when '_db-option':u then
                return 'DatabaseOption':u.                
            when '_sec-role':u then
                return 'Role':u.
            when '_sec-granted-role':u then
                return 'GrantedRole':u.
         end.
         return ""  .      
    end method.
      
    method protected IDataAdminModel GetInternalContext(pname as char):
        case pname:
            when "Area" then
                return AreaContext.
            when "Domain" then
                return DomainContext.
            when "AuthenticationSystem" then
                return AuthenticationSystemContext.
            when "Extent" then
                return ExtentContext.
            when "Field" then
                return FieldContext.
            when "Index" then
                return IndexContext.
            when "LocalIndex" then
                return LocalIndexContext.
            when "Partition" then
                return PartitionContext.
            when "PartitionPolicy" then
                return PartitionPolicyContext.             
            when "PartitionPolicyDetail" then
                return PartitionPolicyDetailContext.
            when "PartitionPolicyField" then
                return PartitionPolicyFieldContext.
            when "CdcTablePolicy" then
                return CdcTablePolicyContext.
            when "CdcFieldPolicy" then
                return CdcFieldPolicyContext.
            /*when "CdcTablePolicyField" then
                return CdcTablePolicyFieldContext.*/
            when "TenantGroup" then
                return TenantGroupContext.
            when "TenantGroupMember" then
                return TenantGroupMemberContext.
            when "Schema" then
                return SchemaContext.
            when "SchemaDefinition" then
                return SchemaContext.
            when "Sequence" then
                return SequenceContext.
            when "SequenceValue" then
                return SequenceValueContext.
            when "Table" then
                return TableContext.
            when "AllTable" then
                return AllTableContext.
            when "Tenant" then
                return TenantContext.
            when "User" then
                return UserContext.
            when 'DatabaseOption':u then
                return DatabaseOptionContext.                           
            when 'Role':u then
                return RoleContext.                           
            when 'GrantedRole':u then
                return GrantedRoleContext.                           
        end.
        undo, throw new NotFoundError("Internal context " + quoter(pname) + " does not exist.").    
    end method.    
    
    method public IDataAdminModel GetContextBySerializeName(pname as char):
        define variable cname as character no-undo.
        if lookup(pname,CLASS_NAMES_THAT_ENDS_WITH_E) > 0 then 
            cName = substr(pname,1,length(pname) - 1).
        else if pname matches "*ies" then
            cName = substr(pname,1,length(pname) - 3) + "y".
        else if pname matches "*es" then
            cName = substr(pname,1,length(pname) - 2).
        else if pname matches "*s" then
            cName = substr(pname,1,length(pname) - 1).
        else 
            undo, throw new NotFoundError(pname).    
        return GetContext(cName).
        /* catch notfound from lower evel to return passed name and term that corresponds to api */
        catch e1 as NotFoundError :
            undo, throw new NotFoundError("Collection " + quoter(pname) + " was not found.").    
        end catch.
        catch e2 as Progress.Lang.Error :
            undo, throw e2. 
        end catch.
    end method.
    
    method public IDataAdminModel GetContextByAnyName(pname as char):
        define variable cname as character no-undo.
        /* support use of physical name (integration with dump and load) */ 
        if pname begins "_" then
        do: 
            cname = GetNameFromTableName(pname).
            if cname = "" then
               undo, throw new notfoundError(pName).
        end.
        /* NOTE: if we add a class that ends in s then this needs to avoid this call to byserializename */
        else if pname matches "*s" /* and pcname <> "entitynamethatendswiths"  */  then
        do:
            return GetContextBySerializeName(pname).
        end.  
        else 
           cname = pname.   
        
        return GetContext(cName).
       
          /* catch notfound from lower evel to return passed name and term that corresponds to api */
        catch e1 as NotFoundError :
            undo, throw new NotFoundError("Collection " + quoter(pname) + " was not found.").    
        end catch.
        catch e2 as Progress.Lang.Error :
            undo, throw e2. 
        end catch.
        
    end method.
    
end class.
