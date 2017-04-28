/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RoleContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-25
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.GrantedRoleContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.DataError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.Role.
using OpenEdge.DataAdmin.RoleSet.
using Progress.Lang.Error.
using OpenEdge.DataAdmin.IDataAdminService.

class OpenEdge.DataAdmin.Binding.RoleContext inherits DataAdminContext :

    {daschema/role.i} 
    define private dataset dsRole serialize-name "root" for ttRole.
    define buffer bRole for ttRole.
    define temp-table copytable reference-only like ttRole .  
   
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttRole:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "Name":u. 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bRole for ttRole.
            define query qryRole for bRole.
            
            if Count = ? then
            do:
                open query qryRole preselect each bRole.
                assign this-object:Count = query qryRole:num-results. 
            end.
            return this-object:Count.
        end get.
        protected set.
    
    constructor public RoleContext ():
        this-object().
        AddChild(new GrantedRoleContext(this-object:ContextScope)).
    end constructor.
    
    constructor public RoleContext (pscope as IContextScope):
        super ("Role",pScope).
        AddChild(new GrantedRoleContext(pscope)).
    end constructor.

    constructor public RoleContext (grants as GrantedRoleContext):
        super ("Role").
        AddChild(grants).
    end constructor.
            
    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsRole:handle. 
    end method.

	method public override character GetJoinFields(parentid as char):
        return '':u.	       
    end.
    
    method override protected IDataAdminModel GetNamedChild(pqname as character):
 	  case pqname:
 	      /* the AddChild stuff earlier depends on the TT's serialize-name which is GRANTS and not GRANTEDROLE ,
 	         so we end up returning a new one each time */
 	      when 'GrantedRole' then
 	          return new GrantedRoleContext(this-object:ContextScope).
        end case.
    end method.
 	    
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity, IRole)).    
	end method.

    method protected override void CopyTableForParent(pRow as IRow,cntxt as IDataAdminModel):
        case pRow:SerializeName:          
            otherwise 
                undo, throw new IllegalArgumentError("RoleContext:CopyTableForParent called with IRow " + quoter(prow:SerializeName)).        
        end.
        
        assign Loaded = false.
    end method.    
    
    method protected override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.    
    
    method override protected FilteredContext CreateFilteredContext(pRow as IRow,pReq as IRequestInfo):     
        case pRow:SerializeName :          
            otherwise
                return super:CreateFilteredContext(pRow,pReq).              
        end.        
    end method.
    
    method private void CopyTable(input table copytable):
        CopyTable(input table copytable by-reference,?,"").  
    end method.
   
	method private void CopyTable(input table copytable,pcTenantId as int,pcTenantName as char):
        define variable dataerror as DataContextError no-undo.      
        for each copytable on error undo, throw:  
            if valid-object(Service) and valid-object(copytable.Entity) then 
                ValidateRole(cast(copytable.Entity, IRole)).
            do on error undo, throw:
                find bRole where bRole.Name = copytable.Name no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bRole then
                do:
                    create bRole.
                    assign bRole.Name = copytable.Name.               
                end.    
                catch e as Progress.Lang.Error :
                    delete bRole.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("Role", e).
                    else 
                        dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttRole:tracking-changes = true.
        for each copytable:
            create ttRole.    
            Count = Count + 1.
            buffer-copy copytable to ttRole.    
            OnRowCreated().
        end.
        temp-table ttRole:tracking-changes = false.
            
    end method.  
	
	method private character GetCreateError(input poRole as IRole):
        return this-object:GetCreateError(cast(poRole,IDataAdminElement), poRole:Name). 
    end method.
    
	method private void ValidateRole(input poRole as IRole):
	    Assert:NotNull(poRole, 'Security role').
        Assert:NotNullOrEmpty(poRole:Name, 'Role name').
        Assert:NotNull(poRole:Description, 'Role description').
        Assert:NotNullOrEmpty(poRole:Creator, 'Role creator').         
	end method.
	
	method public void CreateRow(input poRole as IRole):
	    define variable validateError as DataContextError no-undo.
       
	    temp-table ttRole:tracking-changes = true.
	    ValidateRole(poRole).
	    
	    do on error undo, throw: 
	        Count = Count + 1.
	        create ttRole.
            assign 
                ttRole.Name          = poRole:Name
                ttRole.Description   = poRole:Description
                ttRole.Creator       = poRole:Creator
                ttRole.CustomDetail  = poRole:CustomDetail
                .   
            OnRowCreated().      
            catch e as Error:  
                delete ttRole.
                assign Count = Count - 1.
                undo, throw new DataContextError(GetCreateError(poRole),"Role",e).  
            end catch.  
        end.
        finally:
            temp-table ttRole:tracking-changes = false.        		
        end finally.
    end method.
    
    method public override logical CanFind(name as character):
        return can-find(ttRole where ttRole.Name = name).            
    end.     
     
    method public override logical Find(name as character):
        find ttRole where ttRole.Name = name no-error.
        return avail ttRole.            
    end.
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new RoleSet(cntxt).
    end method.
    
    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new Role(this-object, req).
    end method.

    method override protected void InitRow( input pName as character ):
        super:InitRow(input pName).
        
        InitRowValues().
    end method.

    method override protected void InitRow(  ):
        super:InitRow().
        
        InitRowValues().
    end method.

    method override protected void InitRow( input pId as integer ):
        super:InitRow(input pId).
        
        InitRowValues().
    end method.
    
    method private void InitRowValues():
        define variable hCurrentUser as handle no-undo.
        define variable oService as IDataAdminService no-undo.

        assign oService = if valid-object(Service) then Service else TargetService
               .
        if valid-object(oService) then
            assign hCurrentUser    = get-db-client(oService:Name)
                   ttRole.Creator = substitute('&1@&2':u,
                                        hCurrentUser:user-id,
                                        hCurrentUser:domain-name).
                   .
    end method.

    method override protected logical Remove():
        undo, throw new UnsupportedOperationError('security role delete').
    end method.
	 
end class.

