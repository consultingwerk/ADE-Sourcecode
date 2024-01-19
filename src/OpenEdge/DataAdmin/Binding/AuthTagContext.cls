/**************************************************************************
Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : AuthTagContext
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2023-07-24
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
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
using OpenEdge.DataAdmin.IAuthTag.
using OpenEdge.DataAdmin.AuthTag.
using OpenEdge.DataAdmin.AuthTagSet.
using Progress.Lang.Error.
using OpenEdge.DataAdmin.IDataAdminService.

class OpenEdge.DataAdmin.Binding.AuthTagContext inherits DataAdminContext:

    {daschema/authtag.i}

    define private dataset dsAuthTag serialize-name "root" for ttAuthTag.

    define buffer bAuthTag for ttAuthTag.

    define temp-table copytable reference-only like ttAuthTag.

	define public override property TableHandle as handle no-undo
    	get():
    		return temp-table ttAuthTag:handle.
    	end get.

    define public override property KeyFields as character no-undo
        get():
            return "Name":u.
        end.

    define public override property Count as integer init ? no-undo
        get():
            define buffer bAuthTag for ttAuthTag.
            define query qryAuthTag for bAuthTag.

            if Count = ? then
            do:
                open query qryAuthTag preselect each bAuthTag.
                assign this-object:Count = query qryAuthTag:num-results.
            end.
            return this-object:Count.
        end get.
        protected set.

    constructor public AuthTagContext ():
        this-object().
    end constructor.

    constructor public AuthTagContext (pscope as IContextScope):
        super("AuthTag",pScope).
    end constructor.

    /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsAuthTag:handle.
    end method.

	method public override character GetJoinFields(parentid as char):
        return "":u.
    end.

	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity, IAuthTag)).
	end method.

    method protected override void CopyTableForParent(pRow as IRow,cntxt as IDataAdminModel):
        case pRow:SerializeName:
            otherwise
                undo, throw new IllegalArgumentError("AuthTagContext:CopyTableForParent called with IRow " + quoter(prow:SerializeName)).
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
        case pRow:SerializeName:
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
                ValidateAuthTag(cast(copytable.Entity, IAuthTag)).
            do on error undo, throw:
                find bAuthTag where bAuthTag.RoleName eq copytable.RoleName
                                and bAuthTag.Name eq copytable.Name no-error.
                /* force error message
                   - DataError will transform progress message
                     to "entity" message */
                if avail bAuthTag then
                do:
                    create bAuthTag.
                    assign bAuthTag.RoleName = copytable.RoleName
                           bAuthTag.Name     = copytable.Name.
                end.
                catch e as Progress.Lang.Error :
                    delete bAuthTag.
                    if not valid-object(DataError) then
                        dataError = new DataContextError("AuthTag", e).
                    else
                        dataError:AddMessage(e).
                end catch.
            end.
        end.

        if valid-object(dataError) then
            undo, throw dataError.
        temp-table ttAuthTag:tracking-changes = true.
        for each copytable:
            create ttAuthTag.
            Count = Count + 1.
            buffer-copy copytable to ttAuthTag.
            OnRowCreated().
        end.
        temp-table ttAuthTag:tracking-changes = false.

    end method.

	method private character GetCreateError(input poAuthTag as IAuthTag):
        return this-object:GetCreateError(cast(poAuthTag,IDataAdminElement), poAuthTag:Name).
    end method.

	method private void ValidateAuthTag(input poAuthTag as IAuthTag):
	    Assert:NotNull(poAuthTag, 'Authorization Tag').
        Assert:NotNullOrEmpty(poAuthTag:RoleName, 'Role Name').
        Assert:NotNullOrEmpty(poAuthTag:Name, 'Auth Tag Name').
        Assert:NotNull(poAuthTag:Description, 'Auth Tag Description').
        Assert:Equals('#DDM_', substring(poAuthTag:Name, 1, 5)).
	end method.

	method public void CreateRow(input poAuthTag as IAuthTag):
	    define variable validateError as DataContextError no-undo.

	    temp-table ttAuthTag:tracking-changes = true.
	    ValidateAuthTag(poAuthTag).

	    do on error undo, throw:
	        Count = Count + 1.
	        create ttAuthTag.
            assign
                ttAuthTag.RoleName    = poAuthTag:RoleName
                ttAuthTag.Name        = poAuthTag:Name
                ttAuthTag.Description = poAuthTag:Description
                .
            OnRowCreated().
            catch e as Error:
                delete ttAuthTag.
                assign Count = Count - 1.
                undo, throw new DataContextError(GetCreateError(poAuthTag), "AuthTag", e).
            end catch.
        end.
        finally:
            temp-table ttAuthTag:tracking-changes = false.
        end finally.
    end method.

    method public override logical CanFind(pcName as character):
        return can-find(ttAuthTag where ttAuthTag.Name eq pcName).
    end.

    method public override logical Find(pcName as character):
        find ttAuthTag where ttAuthTag.Name eq pcName no-error.
        return available(ttAuthTag).
    end.

    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):
        return new AuthTagSet(cntxt).
    end method.

    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new AuthTag(this-object, req).
    end method.

end class.
