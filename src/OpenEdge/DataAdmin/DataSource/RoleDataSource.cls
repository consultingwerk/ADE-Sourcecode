/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RoleDataSource
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

class OpenEdge.DataAdmin.DataSource.RoleDataSource inherits DataSource: 
    define private buffer b_role for dictdb._sec-role.
    
    define private variable msave as logical no-undo.

    /* Is the current user a security admin? */
    define private variable mIsAdmin as logical no-undo init false.
   
	define private variable mMapping as char
	   init  	
"Name,_Role-name,~
Description,_Role-description,~
Creator,_Role-creator,~
CustomDetail,_Custom-role-detail"
     no-undo.

    constructor public RoleDataSource (pcurl as char):        
        this-object().
           
        assign this-object:Url = pcURL. 
    end constructor.

	constructor public RoleDataSource ( ):	    
        super ("_sec-role":u,
               "dictdb._sec-role":u,
               mMapping).
		BaseQueryTemplate = "for each _sec-role&1no-lock ":u.
        run prodict/_dctadmn.p ( input userid('dictdb':u), output mIsAdmin ).
    end constructor.
    
    method protected override void PrepareBuffer(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill":u, "AfterRoleRow":u).
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
        define variable hBeforeBuff as handle    no-undo.
        define variable hQuery      as handle    no-undo.
        define variable hDataset    as handle no-undo.
        define variable cChanges     as character no-undo.
        define variable cPrepareString as character no-undo.
        
        if not mIsAdmin then
            undo, throw new UnauthorizedOperationError('Security admin user required for updates').
        
        case piState:
            /* DELETE not allowed */
            when row-created or 
            when row-modified then
                assign cPrepareString = substitute("for each ttRoleCopy where row-state(ttRoleCopy) eq &1":u, piState).
            when ? then
                assign cPrepareString = 'for each ttRoleCopy ':u.
            otherwise 
                undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
        end case.
        
        create query hQuery.
        hBeforeBuff = phBuffer:before-buffer.
        hQuery:add-buffer(hBeforeBuff).
        hQuery:query-prepare(cPrepareString).
        hQuery:query-open().
        
        do while true on error undo, throw:
            hQuery:get-next.
            if not hBeforebuff:avail then 
                leave.
            
            /* for the case where piState eq ? */
            if hBeforeBuff:row-state = row-deleted then 
                undo, throw new UnsupportedOperationError('Deletes not allowed for database options.').
            else do:
                phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                BeforeRowSave(phBuffer).
            
                if hBeforeBuff:row-state eq row-created then 
                do:
                    create b_role.
                    /* key field assugnments */
                    assign b_role._role-name    = phBuffer::Name
                           b_role._role-creator = phBuffer::Creator
                           .
                end. 
                else
                    find b_role where 
                         b_role._role-name eq hBeforeBuff::Name 
                         exclusive-lock no-wait.
                /* value field assigmemnts */
                assign
                    b_role._Role-description = phBuffer::Description
                    b_role._Custom-role-detail = phBuffer::CustomDetail
                    
                    hdataset = phBuffer:dataset
                    .
                buffer b_role:buffer-validate ().    
                msave = true.
                AfterRoleRow (dataset-handle hdataset  by-reference).
                msave = false.
            end. /* else (not delete)*/
        end. 
        return true. 
        catch e as Progress.Lang.Error :
            undo, throw new DataAccessError(
                new DataMapper("Role,b_role":u, mMapping),
                e). 
        end catch.          
        finally:
           delete object hQuery no-error. 		
        end finally.
    end method.    
    
    /* Validates a row before save */
    method private void BeforeRowSave(input phTTBuffer as handle):
        define variable cChanges as character no-undo.
        define variable hBeforeBuffer as handle no-undo.
        
        define buffer b_domain for _sec-authentication-domain.
        
        assign hBeforeBuffer = phTTBuffer:before-buffer
               cChanges      = CompareBuffers(phTTBuffer, hBeforeBuffer, "Entity":u, "case-sensitive":u).
        
        /* We cannot change key fields on modification of the option records */
        case hBeforeBuffer:row-state:
            when row-modified then
            case true:
                when lookup('Name':u, cChanges) gt 0 or
                when lookup('Creator':u, cChanges) gt 0 then
                    undo, throw new IllegalOperationError('Key field changes not allowed '). 
            end case.
            when row-created then
            do:
                Assert:NotNullOrEmpty(phTTBuffer::Name, 'Role name').
                Assert:NotNullOrEmpty(phTTBuffer::Creator, 'Role creator').
                
                if index(phTTBuffer::Creator, '@':u) eq 0 then
                    undo, throw new AppError(substitute('Creator &1 must be a qualified user-id',
                                                quoter(phTTBuffer::Creator)),
                                            0).
                if not can-find(b_domain where
                                b_domain._domain-name eq entry(2, phTTBuffer::Creator, '@':u)) then
                    undo, throw new AppError(substitute('Domain &1 not found', entry(2, phTTBuffer::Creator, '@':u)),
                                             0).
            end.
        end case.   /* row state */
        
        Assert:NotNull(phTTBuffer::Description, 'Role description').
    end method.
    
    method public void AfterRoleRow(dataset-handle hds):
        define variable hbuffer as handle no-undo.
        define variable iSource as integer no-undo.
        assign
            hBuffer             = hds:get-buffer-handle("ttRole":u)
            hBuffer::Url        = substitute('&1/roles/&2':u,
                                                this-object:Url,
                                                WebUtil:UrlEncode(hBuffer::Name)) 
            hBuffer::GrantsUrl  = substitute('&1/grants':u, hBuffer::Url )
            .
            
        /* we cannot create a builtin so the value is always correct on save
           (false if new, from read if update)  */    
        if not msave then   
        do:
            isource = lookup("_sec-role":u, Tables).
            hBuffer::IsBuiltin = DataSourceHandle:get-source-buffer(isource)::_Role-name begins '_':u.
        end.
    end method.                 
    
    method private char IsBuiltInExpression(istrue as log):
        if istrue then
            return  "(_sec-role._Role-name begins '_')":u. 
        else  
            return  "(not _sec-role._Role-name begins '_')":u.
    end method.  
    
    method public override character ColumnSortSource(pcColumn as char):
        case pcColumn:
            when "_sec-role.IsBuiltin":u then
                return IsBuiltInExpression(true).
            otherwise
                return super:ColumnSortSource(pccolumn).
        end case.   
    end. 
    
     /* convert  values in query to the expression required in the db */
    method public override character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
        if pccolumn = "_sec-role.IsBuiltin":u then
            return IsBuiltInExpression(logical(pcValue)).

        return super:ColumnExpression(pccolumn,pcOperator,pcValue).   
    end. 
    
    /* rename table to match to right table when building  */
    method public override character ColumnSource (pcColumn as char):
        case pcColumn:
            when "ttRole.IsBuiltin":u then
                return "_sec-authentication-domain.IsBuiltIn":u.      
            otherwise 
                return super:ColumnSource(pccolumn).
        end case.
    end method.     
    
end class.