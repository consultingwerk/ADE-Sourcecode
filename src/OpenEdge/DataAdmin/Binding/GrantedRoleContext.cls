/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : GrantedRoleContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-26
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.DataError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.GrantedRole.
using OpenEdge.DataAdmin.GrantedRoleSet.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.Error.
using OpenEdge.DataAdmin.IDataAdminService.

class OpenEdge.DataAdmin.Binding.GrantedRoleContext inherits DataAdminContext :

    {daschema/grantedrole.i} 
    define private dataset dsGrantedRole serialize-name "root" for ttGrantedRole.
    define buffer bGrant for ttGrantedRole.
    define temp-table copytable reference-only like ttGrantedRole .  
   
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttGrantedRole:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo
        init "Id":u
        get.
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bGrant for ttGrantedRole.
            define query qryRole for bGrant.
            if Count eq ? then
            do:
                open query qryRole preselect each bGrant.
                assign this-object:Count = query qryRole:num-results. 
            end.
            return this-object:Count.
        end.
        protected set.
    
    constructor public GrantedRoleContext ():
        super ("GrantedRole":u). 
    end constructor.
    
    constructor public GrantedRoleContext (pscope as IContextScope):
        super ("GrantedRole":u, pScope).    
    end constructor.

    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsGrantedRole:handle. 
    end method.

	method public override character GetJoinFields(parentid as char):
        case parentid:
            when "roles":u then return "Name,RoleName":u.
            otherwise           return '':u.
        end.
    end.
    
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity, IGrantedRole)).    
	end method.

    method protected override void CopyTableForParent(pRow as IRow,cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        case pRow:SerializeName:   
            when "roles" then
                CopyTable(table-handle hTbl by-reference,pRow:KeyIntValue,pRow:FieldValue("Name")). 
            otherwise 
                undo, throw new IllegalArgumentError("GrantedRoleContext:CopyTableForParent called with IRow " + quoter(prow:SerializeName)).        
        end.
        Loaded = false.
    end method.    
    
    /** default find expression assumes there is a name field 
       override in context with different key name or more complex logic */
    method override protected character FindExpression(c as char):
        return substitute('&1.&2 eq &3', TableHandle:name, this-object:KeyFields, quoter(c)).
    end method.    
    
    method protected override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.    
    
    method override protected FilteredContext CreateFilteredContext(pRow as IRow,pReq as IRequestInfo):     
        return super:CreateFilteredContext(pRow,pReq).              
    end method.
    
    method private void CopyTable(input table copytable):
        CopyTable(input table copytable by-reference,?,"").  
    end method.
   
	method private void CopyTable(input table copytable,pcTenantId as int,pcTenantName as char):
        define variable dataerror as DataContextError no-undo.      
        for each copytable on error undo, throw:  
            if valid-object(Service) and valid-object(copytable.Entity) then 
                ValidateGrantedRole(cast(copytable.Entity, IGrantedRole)).
            do on error undo, throw:
                find bGrant where bGrant.Id = copytable.Id no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bGrant then
                do:
                    create bGrant.
                    assign bGrant.Id = copytable.Id.               
                end.    
                catch e as Progress.Lang.Error :
                    delete bGrant.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("GrantedRole",e).
                    else 
                        dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttGrantedRole:tracking-changes = true.
        for each copytable:
            create ttGrantedRole.    
            Count = Count + 1.
            buffer-copy copytable to ttGrantedRole.    
            OnRowCreated().
        end.
        temp-table ttGrantedRole:tracking-changes = false.
            
    end method.  
	
	method private character GetCreateError(input poRole as IGrantedRole):
        return this-object:GetCreateError(cast(poRole,IDataAdminElement),poRole:Id). 
    end method.

	method private void ValidateGrantedRole(input poRole as IGrantedRole):
	end method.    
	
	method private void InitRowValues():
        define variable hCurrentUser as handle no-undo.
        define variable oService as IDataAdminService no-undo.

        assign oService = if valid-object(Service) then Service else TargetService
               .
        if valid-object(oService) then
            assign hCurrentUser          = get-db-client(oService:Name)
                   ttGrantedRole.Grantor = substitute('&1@&2':u, hCurrentUser:user-id, hCurrentUser:domain-name).
        /* Use a GUID for the Id if not is supplied. */
        if ttGrantedRole.Id eq '':u or ttGrantedRole.Id eq ? then
            assign ttGrantedRole.Id = guid.
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
	
	method public void CreateRow(input poRole as IGrantedRole):
	    define variable validateError as DataContextError no-undo.

	    temp-table ttGrantedRole:tracking-changes = true.
	    ValidateGrantedRole(poRole).
	    
	    do on error undo, throw: 
	        Count = Count + 1.
	        create ttGrantedRole.
            assign 
                ttGrantedRole.RoleName     = poRole:Role:Name
                ttGrantedRole.Grantor      = poRole:Grantor
                ttGrantedRole.Grantee      = poRole:Grantee
                ttGrantedRole.CustomDetail = poRole:CustomDetail
                ttGrantedRole.Id           = poRole:Id
                ttGrantedRole.CanGrant     = poRole:CanGrant
                .   
            OnRowCreated().      
            catch e as Error:  
                delete ttGrantedRole.
                Count = Count - 1.
                undo, throw new DataContextError(GetCreateError(poRole),"GrantedRole",e).  
            end catch.  
        end.
        finally:
            temp-table ttGrantedRole:tracking-changes = false.        		
        end finally.
    end method.
    
    method public override logical CanFind(input pcID as character):
        return can-find(ttGrantedRole where ttGrantedRole.Id = pcID).            
    end.     
     
    method public override logical Find(pcID as character):
        find ttGrantedRole where ttGrantedRole.Id = pcID no-error.
        return avail ttGrantedRole.            
    end.     
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new GrantedRoleSet(cntxt).
    end method.
    
    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new GrantedRole(this-object, req).
    end method.
    
end class.
