/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : GrantedRoleDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-18
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.DataAccess.DataAccessError.
using OpenEdge.DataAdmin.DataAccess.DataMapper.
using OpenEdge.DataAdmin.DatabaseOptionTypeEnum.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnauthorizedOperationError.
using OpenEdge.DataAdmin.Lang.WebUtil.
using Progress.Lang.AppError.

class OpenEdge.DataAdmin.DataSource.GrantedRoleDataSource inherits DataSource: 
    define buffer b_grant for dictdb._sec-granted-role.
    
    define private variable msave as logical no-undo.

    /* Is the current user a security admin? */
    define private variable mIsAdmin as logical no-undo init false.
   
	define private variable mMapping as char
	   init 
"Id,_Granted-role-guid,~
RoleName,_Role-name,~
Grantor,_Grantor,~
Grantee,_Grantee,~
CanGrant,_Grant-rights,~
CustomDetail,_Custom-grant-detail":u
     no-undo.

    constructor public GrantedRoleDataSource (pcurl as char):        
        this-object ().   
        assign this-object:Url = pcURL. 
    end constructor.

	constructor public GrantedRoleDataSource ( ):	    
        super ("_sec-granted-role":u,
               "dictdb._sec-granted-role":u,
               mMapping).
		assign BaseQueryTemplate = "for each _sec-granted-role&1no-lock ":u.
		
        run prodict/_dctadmn.p ( input userid('dictdb':u), output mIsAdmin ).
    end constructor.
    
    method protected override void PrepareBuffer(phBuffer as handle):
     /* after row only needed for url */
        if url > "" then
        phBuffer:set-callback("After-Row-fill":u, "AfterGrantRoleRow":u).
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
        define variable cErrormap   as character no-undo.
        define variable hBeforeBuff as handle    no-undo.
        define variable hQuery      as handle    no-undo.
        define variable hDataset    as handle no-undo.
        define variable cChanges     as character no-undo.
        define variable cPrepareString as character no-undo.
        
        if not mIsAdmin then
            undo, throw new UnauthorizedOperationError('Security admin user required for updates').
        
        case piState:
            when row-deleted or
            when row-created or 
            when row-modified then
                assign cPrepareString = substitute("for each ttGrantedRoleCopy where row-state(ttGrantedRoleCopy) eq &1":u, piState).
            when ? then
                assign cPrepareString = 'for each ttGrantedRoleCopy ':u.
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
            
            case hBeforeBuff:row-state:
                when row-created or 
                when row-modified then 
                do:
                    phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                    BeforeRowSave(phBuffer).
                    
                    if hBeforeBuff:row-state eq row-created then
                    do:
                        create b_grant.
                        assign b_grant._Granted-role-guid = phBuffer::Id
                               b_grant._Role-name = phBuffer::RoleName
                               b_grant._Grant-rights = phBuffer::CanGrant
                               b_grant._Grantor = phBuffer::Grantor
                               b_grant._Grantee = phBuffer::Grantee.
                    end.
                    else
                        find b_grant where 
                             b_grant._Granted-role-guid eq phBuffer::Id 
                             exclusive-lock no-wait.
                    
                    assign b_grant._Custom-grant-detail = phBuffer::CustomDetail                        
                           hdataset = phBuffer:dataset
                           .
                    buffer b_grant:buffer-validate ().    
                    msave = true.
                    AfterGrantRoleRow(dataset-handle hdataset  by-reference).
                    msave = false.
                end.    /* create/modify */
                when row-deleted then
                do:
                    BeforeRowSave(hBeforeBuff).
                    
                    find b_grant where 
                         b_grant._Granted-role-guid eq hBeforeBuff::Id 
                         exclusive-lock no-wait.
                    
                    delete  b_grant.
                end.    /* delete */
            end case.            
         end.
        
        return true. 
        catch e as Progress.Lang.Error :
            undo, throw new DataAccessError(
                new DataMapper("GrantedRole,b_grant":u, mMapping),
                e). 
        end catch.          
        finally:
           delete object hQuery no-error. 		
        end finally.
    end method.    
    
    method public void AfterGrantRoleRow(dataset-handle hds):
        define variable hbuffer as handle no-undo.
        
        assign
            hBuffer      = hds:get-buffer-handle("ttGrantedRole":u)
            hBuffer::Url = substitute('&1/grants/&2':u,
                                this-object:Url,
                                WebUtil:UrlEncode(hBuffer::Id))
            .
    end method.
    
    /* Validates the userid's format and domain
       
       @param character The qualified user-id
       @param character The type of the user id (eg grantor) 
       @throws Progress.Lang.AppError   */
    method private void ValidateUserId(input pcUserId as character,
                                       input pcName as character):
        define buffer b_domain for _sec-authentication-domain.
        
        Assert:NotNullOrEmpty(pcUserId, pcName).
        if index(pcUserId, '@':u) eq 0 then
            undo, throw new AppError(substitute('&1 &2 must be a qualified user-id',
                                                pcName,
                                                quoter(pcUserId)),
                                            0).
		
        if not can-find(b_domain where
                        b_domain._domain-name eq entry(2, pcUserId, '@':u)) then
            undo, throw new AppError(substitute('Domain not found for user-id &1',
                                        quoter(pcUserId)),
                                             0).
    end method.                  

    /* Validates a row before save */
    method private void BeforeRowSave(input phTTBuffer as handle):
        define variable cChanges as character no-undo.
        define variable hBeforeBuffer as handle no-undo.
        define variable cConnectionRole as character no-undo.
        define variable hCurrentUser as handle no-undo.
        define variable lCanGrant as logical no-undo.
	                
        define buffer b_grant for _sec-granted-role.
        define buffer b_role for _sec-role.
        define buffer b_dboption for _db-option.
        
        if valid-handle(phTTBuffer:before-buffer) then
            assign hBeforeBuffer = phTTBuffer:before-buffer.
        else
            assign hBeforeBuffer = phTTBuffer.
            
        /* The current user must always be the grantor for create and update.
           Sometimes for deletes */
        assign hCurrentUser = get-db-client('dictdb':u).
		        
        if hBeforeBuffer:row-state ne row-deleted and
           phTTBuffer::Grantor ne substitute('&1@&2':u, hCurrentUser:user-id, hCurrentUser:domain-name) then
            undo, throw new AppError(substitute('Grantor &1 is not the current database user',
                                                    phTTBuffer::Grantor),
                                             0).
        
        case hBeforeBuffer:row-state:
            when row-modified then
            do:
                assign cChanges = CompareBuffers(phTTBuffer, hBeforeBuffer, "Entity":u, "case-sensitive":u).
                if cChanges eq '':u then
                    return.
                
                /* updates can ONLY change CustomDetail values and NO others */
                if cChanges ne 'CustomDetail':u then
                    undo, throw new IllegalOperationError('Only CustomDetail values may be updated for a grant').
            end.
            when row-created then
            do:
                Assert:NotNull(phTTBuffer::Id, 'Id').
                Assert:NotNullOrEmpty(phTTBuffer::RoleName, 'Role name').
                
                /* Role must exist */
                if not can-find(b_role where b_role._role-name eq phTTBuffer::RoleName) then
                    undo, throw new AppError(substitute('Unable to find defined role &1 for grant',
                                                quoter(phTTBuffer::RoleName)),
                                             0).
                
                ValidateUserId(phTTBuffer::Grantee, 'Grantee').
                ValidateUserId(phTTBuffer::Grantor, 'Grantor').
                
                /* Roles can be granted (created) by the grantor IF they were granted the
                   permission can-grant, or it is the first instance of the role-name and the
                   grantor is a SQL DBA or ABL security administrator */
                 assign lCanGrant = FALSE.
                 
                 find first b_grant where
                            b_grant._grantee   eq phTTBuffer::Grantor  and
                            b_grant._role-name eq phTTBuffer::RoleName
                            no-lock no-error.
                /* User as been granted the role and is allowed to grant to others */
                if available b_grant and b_grant._grant-rights then
                    assign lCanGrant = true.

                do while not lCanGrant: 
                    /* the user has been granted the role, but can NOT grant to others */
                    if available b_grant then
                        leave.
                    
                    /* If there is at least one grant for this role, we cannot grant this right.
                       At this point we know there isn't a grant for the grantor, so if we find any
                       records we know it's for another grantor somewhere. */
                    if can-find(first b_grant where b_grant._role-name eq phTTBuffer::RoleName) then
                        leave.
                    
                    /* finally, make sure current-user is an admin */
                    run prodict/_dctadmn.p (hCurrentUser:qualified-user-id, output lCanGrant).
                    /* all done: need this in case we cannot grant yet */
                    leave.
                end.
                if not lCanGrant then
                    undo, throw new UnauthorizedOperationError(
                                    substitute('User cannot grant rights to role &1', phTTBuffer::RoleName)).
            end.
            when row-deleted then
            do:
                /* Check rights-to-revoke 
                   
                   Roles can be revoked (deleted) by the grantor, OR it is the last instance
                   of the role-name and the grantor is a SQL DBA or ABL security administrator */
                assign lCanGrant = FALSE.
                
                find first b_grant where
                           b_grant._grantee   eq phTTBuffer::Grantor  and
                           b_grant._role-name eq phTTBuffer::RoleName
                           no-lock no-error.
                /* User as been granted the role and is allowed to grant to others */
                if available b_grant and b_grant._grant-rights then
                do:
                    /* even though we're allowed to delete, make sure that there's at least one other
                       role that has grant rights (unless this is the last record) */
                    find first b_grant where 
                               b_grant._role-name         eq phTTBuffer::RoleName and
                               b_grant._granted-role-guid ne phTTBuffer::Id
                               no-lock no-error.
                    assign lCanGrant = (available b_grant and b_grant._grant-rights).
                end.
                
                do while not lCanGrant: 
                    /* the user has been granted the role, but can NOT grant to others */
                    if available b_grant then
                        leave.
                    
                    /* If there is at least one other grant for this Role that's 
                       not the one we're trying to delete, we cannot delete */
                    find first b_grant where 
                               b_grant._role-name         eq phTTBuffer::RoleName and
                               b_grant._granted-role-guid ne phTTBuffer::Id
                               no-lock no-error.                               
                    if available b_grant then
                        leave.
                    
                    /* Make sure we're not totally pooching ourselves by removing the last grant
                       for the the db connection authorisation */
                    if this-object:DatabaseInfo:AuthenticationGatewayEnabled then
                    do:
                        find b_dboption where
                             b_dboption._db-recid       eq this-object:DatabaseInfo:DatabaseRecid and
                             b_dboption._db-option-code eq '_db.connection.roles':u and
                             b_dboption._db-option-type eq integer(DatabaseOptionTypeEnum:AuthenticationGateway)
                             no-lock no-error.
                        assign cConnectionRole = b_dboption._db-option-value.   
                        /* ? means disabled */
                        if cConnectionRole ne ? then
                        do:
                            if cConnectionRole eq '':u then
                                assign cConnectionRole = '_db.connection':u.
                            /* if this is the last grant for the the db connection role */
                            if not (cConnectionRole eq phTTBuffer::RoleName) then
                                leave.
                        end.    /* roles enabled */
                    end.    /* auth gateway enabled */
                    
                    /* finally, make sure current-user is a security admin */
                    run prodict/_dctadmn.p (hCurrentUser:qualified-user-id, output lCanGrant).
                    
                    /* all done: need this in case we cannot grant yet */
                    leave.
                end.
                if not lCanGrant then
                    undo, throw new UnauthorizedOperationError(
                                    substitute('User cannot revoke rights for role &1', phTTBuffer::RoleName)).
            end.
        end case.   /* row state */        
    end method.

end class.
