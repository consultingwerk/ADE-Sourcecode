/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : AuthTagDataSource
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-04-26
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.DataAccess.DataAccessError.
using OpenEdge.DataAdmin.DataAccess.DataMapper.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnauthorizedOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Lang.WebUtil.
using Progress.Lang.AppError.
using Progress.Database.DBConfig.

class OpenEdge.DataAdmin.DataSource.AuthTagDataSource inherits DataSource:

    define private variable hBuffer as handle no-undo.

    define private variable msave as logical no-undo.
    define private variable oDBConfig as DBConfig no-undo.

    /* Is the current user a security admin? */
    define private variable mIsAdmin as logical no-undo init false.

	define private variable mMapping as char
	   init
"RoleName,_Role-name,~
Name,_Auth-tag,~
Description,_Description"
     no-undo.

	constructor public AuthTagDataSource ( ):
        super ("_sec-auth-tag":u,
               "dictdb._sec-auth-tag":u,
               mMapping).
		BaseQueryTemplate = "for each _sec-auth-tag&1no-lock ":u.
        oDBConfig = new DBConfig(ldbname("dictdb")).
        mIsAdmin = oDBConfig:IsDDMAdmin.

        create buffer hBuffer for table "dictdb._sec-auth-tag" no-error.
        if error-status:error then do:
            // If DDM is not enabled for the database, we cannot continue as
            // we cannot access the necessary table for modification.
            undo, throw new AppError("Dynamic Data Masking is not enabled for the target database; the table _sec-auth-tag is not available.", 0).
        end.

        finally:
            // Reset the error-status flag as we don't care at this point.
            if error-status:error then error-status:error = false.
        end finally.
    end constructor.

    method protected override void PrepareBuffer(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill":u, "AfterAuthTagRow":u).
    end method.

    /** Save all
         @param buffer the temp-table buffer handle with data */
    method public override logical Save(bufferHandle as handle):
        return this-object:Save(bufferHandle,?).
    end method.

    /** Save changes of specified state
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified)
                      ? = all */
    method public override logical Save(phBuffer as handle,piState as int):
        mSave = true.

        SaveAuthTag(phBuffer,piState).

        return true.

        finally:
            mSave = false.
        end finally.
    end method.

     /** SaveAuthTag changes of specified state
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified)
                      ? = all */
    method protected void SaveAuthTag(phbuffer as handle,pistate as int):
        define variable hBeforeBuff    as handle    no-undo.
        define variable hQuery         as handle    no-undo.
        define variable hDataset       as handle    no-undo.
        define variable cPrepareString as character no-undo.

        if not mIsAdmin then
            undo, throw new UnauthorizedOperationError('User with DDM admin privileges required for updates').

        case piState:
            when row-created or
            when row-modified or
            when row-deleted then
                assign cPrepareString = substitute("for each btAuthTag where row-state(btAuthTag) eq &1":u, piState).
            when ? then
                assign cPrepareString = 'for each btAuthTag':u.
            otherwise
                undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save.").
        end case.

        create query hQuery.
        hBeforeBuff = phBuffer:before-buffer.
        hQuery:add-buffer(hBeforeBuff).
        hQuery:query-prepare(cPrepareString).
        hQuery:query-open().

        SAVEBLK:
        do while true on error undo, throw:
            hQuery:get-next().
            if hQuery:query-off-end then
                leave SAVEBLK.

            if hBeforeBuff:row-state eq row-deleted then
            do:
                // There should be a unique match when using the role and auth-tag values.
                hBuffer:find-first("where _Role-Name eq " + quoter(hBeforeBuff::RoleName) + " and _Auth-tag eq " + quoter(hBeforeBuff::Name), exclusive-lock, no-wait) no-error.
                if hBuffer:available then
                    hBuffer:buffer-delete().

                // Reset the error-status flag as we don't care at this point.
                if error-status:error then error-status:error = false.
            end.
            else do:
                phBuffer:find-by-rowid(hBeforeBuff:after-rowid).
                BeforeRowSave(phBuffer).

                if hBeforeBuff:row-state eq row-created then
                do:
                    // Dynamically create the record, since we cannot compile code with a static table buffer.
                    hBuffer:buffer-create().
                    assign // Key field assignments.
                        hBuffer::_Role-name = phBuffer::RoleName
                        hBuffer::_Auth-tag  = phBuffer::Name
                        .
                end.
                else
                    hBuffer:find-first("where _Role-Name eq " + quoter(phBuffer::RoleName) + " and _Auth-tag eq " + quoter(phBuffer::Name), exclusive-lock).

                /* Value field assignments */
                assign
                    hBuffer::_description = phBuffer::description
                    hdataset = phBuffer:dataset
                    .
                hBuffer:buffer-release().
                AfterAuthTagRow(dataset-handle hdataset by-reference).
            end. /* else (not delete) */
        end.

        catch e as Progress.Lang.Error :
            undo, throw new DataAccessError(new DataMapper("AuthTag,_sec-auth-tag":u, mMapping), e).
        end catch.
        finally:
            if valid-handle(hQuery) then
	      hQuery:query-close().
            delete object hQuery no-error.
        end finally.
    end method.

    /* Validates a row before save */
    method private void BeforeRowSave(input phTTBuffer as handle):
        define variable cChanges as character no-undo.
        define variable hBeforeBuffer as handle no-undo.

        define buffer b_role for _sec-role.

        assign hBeforeBuffer = phTTBuffer:before-buffer
               cChanges      = CompareBuffers(phTTBuffer, hBeforeBuffer, "Entity":u, "case-sensitive":u).

        /* We cannot change key fields on modification of the option records */
        case hBeforeBuffer:row-state:
            when row-modified then
            case true:
                when lookup('RoleName':u, cChanges) gt 0 or
                when lookup('Name':u, cChanges) gt 0 then
                    undo, throw new IllegalOperationError('Key field changes not allowed ').
            end case.
            when row-created then
            do:
                Assert:NotNullOrEmpty(phTTBuffer::RoleName, 'Role Name').
                Assert:NotNullOrEmpty(phTTBuffer::Name, 'Auth Tag Name').

                Assert:Equals('#DDM_', substring(phTTBuffer::Name, 1, 5)).

                if not can-find(b_role where
                                b_role._role-name eq phTTBuffer::RoleName and
                                b_role._role-type eq 1) then
                    undo, throw new AppError(substitute('Role &1 not found, or is not a DDM role', phTTBuffer::RoleName), 0).
            end.
        end case.   /* row state */

        Assert:NotNull(phTTBuffer::Description, 'Auth Tag description').
    end method.

    method public void AfterAuthTagRow(dataset-handle hds):
        // No actions configured.
    end method.

end class.
