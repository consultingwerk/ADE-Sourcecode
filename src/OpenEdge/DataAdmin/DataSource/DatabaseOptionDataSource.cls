/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DatabaseOptionDataSource
    Purpose     : Dataseource for the_db-option schema table 
    Syntax      : 
    Description : 
    Author(s)   : pjudge    
    Created     : 2016-04-25
    Notes       : 
  ------------------------------------- ---------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.DataAdmin.DataAccess.DataAccessError.
using OpenEdge.DataAdmin.DataAccess.DataMapper.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.DatabaseOptionTypeEnum.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnauthorizedOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Lang.WebUtil.
using Progress.Lang.AppError.

class OpenEdge.DataAdmin.DataSource.DatabaseOptionDataSource inherits DataSource:
    define buffer b_dboption for dictdb._db-option.
    
    define private variable mSave as logical no-undo.

    /* Is the current user a security admin? */
    define private variable mIsAdmin as logical no-undo init false.
   
	define private variable mMapping as char
	   init  	
"Code,_Db-option-code,~
OptionType,_Db-option-type,~
Description,_Db-option-description,~
OptionValue,_Db-option-value"	   
     no-undo.

    constructor public DatabaseOptionDataSource (input pcUrl as character):        
        this-object().
        assign this-object:Url = pcURL. 
    end constructor.

	constructor public DatabaseOptionDataSource ( ):	    
        super ("_db-option":u,
               "dictdb._db-option":u,
               mMapping).
		BaseTableExpression = substitute("_db-option._db-recid eq &1":u, this-object:DatabaseInfo:DatabaseRecid).
		BaseQueryTemplate  = "for each _db-option&1no-lock". 
        
        run prodict/_dctadmn.p ( input userid('dictdb':u), output mIsAdmin).
    end constructor.
    
    method protected override void PrepareBuffer(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill":u, "AfterDbOptionRow":u).
    end method.
    
    /** Save all  
         @param buffer the temp-table buffer handle with data */
    method public override logical Save(bufferHandle as handle):
        return this-object:Save(bufferHandle,?).  
    end method.
    
    /* Validates a row before save */
    method private void BeforeRowSave(input phTTBuffer as handle):
        define variable cChanges as character no-undo.
        define variable hBeforeBuffer as handle no-undo.
        define variable cGrantedRoleName as character no-undo.
        define variable cScheme as character no-undo.
        define variable cHost as character no-undo.
        define variable iMax as integer no-undo.
        
        define buffer b_role for _sec-role.
        define buffer b_granted_role for _sec-granted-role.
        
        assign hBeforeBuffer = phTTBuffer:before-buffer
               cChanges      = CompareBuffers(phTTBuffer, hBeforeBuffer, "Entity":u, "case-sensitive":u).
        
        /* We cannot change key fields on modification of the option records */
        if hBeforeBuffer:row-state eq row-modified then
        case true:
            when lookup('Code':u, cChanges) gt 0 or
            when lookup('OptionType':u, cChanges) gt 0 then
                undo, throw new IllegalOperationError('Key field changes not allowed'). 
        end case.
        
        case string(phTTBuffer::Code):
            when '_pvm.noBlankUser':u        or
            when '_pvm.recordSessions':u     or 
            when '_pvm.RuntimePermissions':u or
            when '_pvm.useAppRegistry':u     then
            do:
                /* must have a type value of 2 */
                Assert:Equals(phTTBuffer::OptionType,
                              integer(DatabaseOptionTypeEnum:GeneralSecurity)).
                
                Assert:IsLogical(phTTBuffer::OptionValue, 'Option value').
            end.    /* security options  */
            when '_db.sts.url':u then
            do:
                if this-object:DatabaseInfo:AuthenticationGatewayEnabled then
                    undo, throw new IllegalOperationError('Authentication gateway URL changes not allowed while feature is enabled').
                
                /* must have a type value of 3 */
                Assert:Equals(phTTBuffer::OptionType,
                              integer(DatabaseOptionTypeEnum:AuthenticationGateway)).
                
                /* its maximum size is 256 characters (the maximum size is imposed whether the feature is enabled or not). 
                   When the feature is enabled, we will also not allow you to change the string “_db.sts.url” for that 
                   record. The schema traps will not validate that the actual value of the URL is a proper URL. The ABL 
                   utility may do validation or provide a way for the user to test that the URL reaches the STS successfully 
                   via a test URL that will be available. The requirement is that we only allow HTTPS for the scheme and do 
                   not allow the host to be ‘localhost’ or ‘127.0.0.1’ (and equivalent for IPV6). */
                Assert:NotNullOrEmpty(phTTBuffer::OptionValue, 'Authentication gateway URL').
                
                if length(phTTBuffer::OptionValue, 'raw':u) gt 256 then
                    undo, throw new AppError('Authentication gateway URL cannot be more than 256 characters in length',
                                             0).
                /* Must be HTTPS */
                assign iMax = num-entries(phTTBuffer::OptionValue, '/':u).
                /* we need at least 3 entries for this to be a decent URL:
                     1  - scheme (eg http:)
                     2  - the space between the 2 /'s
                     3  - the host, port amnd optionally user/password 
                     4+ - the path and other slugs */
                assign cScheme = right-trim(entry(1, phTTBuffer::OptionValue, '/':u), ':':u).
                Assert:NotNullOrEmpty(cScheme, 'Authentication gateway URL scheme').
                if cScheme ne 'https':u then
                    undo, throw new AppError(substitute('Authentication gateway URL schema must be HTTPS, not &1', cScheme),
                                        0).
                
                /* entry 2 is the 'space' between the double slashes */
                if iMax ge 3 then
                    assign cHost = entry(3, phTTBuffer::OptionValue, '/':u).
            
                Assert:NotNullOrEmpty(cHost, 'Authentication gateway URL host').
                
                /* Must be a 'real' network address. It may resolve to 'this machine' but cannot be 
                   in the localhost format */
                if cHost eq 'localhost':u or 
                   cHost eq '127.0.0.1':u or
                   cHost eq '::1':u       then
                    undo, throw new AppError('Authentication gateway host cannot be a local host (localhost, 127.0.0.1,::1)',
                                             0).                
            end.    /* STS URL */
            when '_db.connection.roles':u then
            do: 
                /* must have a type value of 3 */
                Assert:Equals(phTTBuffer::OptionType,
                              integer(DatabaseOptionTypeEnum:AuthenticationGateway)).
                
                case string(phTTBuffer::OptionValue):
                    /* disables feature, no further checks needed */
                    when ? then
                        /*NO-OP*/ .
                    
                    /* enables feature: must have previously created at least one _sec-granted-role 
                       record for the "_db.connection" or other named role, granting the role to a user. */                    
                    otherwise
                    do:
                        assign cGrantedRoleName = phTTBuffer::OptionValue.
                        Assert:IsEmpty(cGrantedRoleName, 'Connection role name').
                        
                        if cGrantedRoleName eq '':u then
                            assign cGrantedRoleName = '_db.connection':u.
                        
                        find b_role where b_role._role-name eq cGrantedRoleName no-lock no-error.
                        if not available b_role then
                            undo, throw new AppError(substitute('Unable to find role &1 for connection authorization',
                                                            quoter(cGrantedRoleName)),
                                                    0).
                        
                        /* must be at least one grant, somewhere */
                        find first b_granted_role where 
                                   b_granted_role._role-name eq b_role._role-name
                                   no-lock no-error.
                        if not available b_granted_role then
                            undo, throw new AppError(substitute('Unable to find at least one grant for connection authorization role &1',
                                                            quoter(cGrantedRoleName)),
                                                    0). 
                    end.    /* blank value */
                end case. /* value */
            end.    /* roles */
        end case.
    end method.
    
    /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    method public override logical Save(phBuffer as handle, piState as int):
        define variable hBeforeBuff as handle    no-undo.
        define variable hquery      as handle    no-undo.
        define variable hDataset    as handle no-undo.
        define variable cChanges     as character no-undo.
        define variable cPrepareString as character no-undo.
        
        if not mIsAdmin then
            undo, throw new UnauthorizedOperationError('Security admin user required for updates').
        
        case piState:
            /* DELETE not allowed */
            when row-created or 
            when row-modified then
                assign cPrepareString = substitute("for each ttDbOptionCopy where row-state(ttDbOptionCopy) eq &1":u, piState).
            when ? then
                assign cPrepareString = 'for each ttDbOptionCopy ':u.
            otherwise 
                undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
        end case.
        
        create query hquery.
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare(cPrepareString).
        hquery:query-open().
        
        do while true on error undo, throw:
            hquery:get-next.
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
                    create b_dboption.
                    /* update the keys */
                    assign b_dboption._db-recid       = this-object:DatabaseInfo:DatabaseRecid
                           b_dboption._db-option-code = phBuffer::Code
                           b_dboption._db-option-type = phBuffer::OptionType
                           .
                end. 
                else
                    find b_dboption where 
                         b_dboption._db-recid       eq this-object:DatabaseInfo:DatabaseRecid and
                         b_dboption._db-option-code eq phBuffer::Code and
                         b_dboption._db-option-type eq phBuffer::OptionType
                         exclusive-lock no-wait .

                /* Update the values  */
                assign b_dboption._db-option-value       = phBuffer::OptionValue
                       b_dboption._db-option-description = phBuffer::Description
                
                       hdataset = phBuffer:dataset
                       .
                buffer b_dboption:buffer-validate ().    
                mSave = true.
                AfterDbOptionRow (dataset-handle hdataset by-reference).
                mSave = false.
                /* TODO   - save-row-changes? */
            end. /* else (not delete)*/
        end. 
        return true. 
        catch e as Progress.Lang.Error :
            undo, throw new DataAccessError(
                new DataMapper("DatabaseOption,b_dboption":u,
                mMapping),
                e). 
            
        end catch.          
        finally:
           delete object hQuery no-error. 		
        end finally.
    end method.    
    
    method public void AfterDbOptionRow(dataset-handle hds):
        define variable hBuffer as handle no-undo.
        define variable iSource as integer no-undo.
        
        assign hBuffer      = hds:get-buffer-handle("ttDbOption":u)
               hBuffer::Url = substitute('&1/dboptions/&2':u,
                                            this-object:Url,
                                            WebUtil:UrlEncode(hBuffer::Code)) when url > ""
               .        
        /* we cannot create a builtin so the value is always correct on save (false if new, from read if update) */    
        if not mSave then
            assign iSource = lookup("_db-option":u, Tables)
                   hBuffer::IsBuiltin = DataSourceHandle:get-source-buffer(isource)::_db-option-type <= 32000.
    end method.
    
    method private char IsBuiltInExpression(istrue as log):
        if istrue then
            return "(_db-option._db-option-type <= 32000 )":u. 
        else  
            return "(_db-option._db-option-type > 32000 )":u.
    end method.  
    
    method public override character ColumnSortSource(pcColumn as char):
        case pcColumn:
            when "_db-option.IsBuiltin":u then
                return IsBuiltInExpression(true).
            otherwise
                return super:ColumnSortSource(pccolumn).
        end case.   
    end method. 
    
     /* convert  values in query to the expression required in the db */
    method public override character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
        case pccolumn:
            when "_db-option.IsBuiltin":u then
                return IsBuiltInExpression(logical(pcValue)).
            otherwise 
                return super:ColumnExpression(pccolumn,pcOperator,pcValue).
        end case.   
    end method. 
    
    /* rename table to match to right table when building  */
    method public override character ColumnSource (pcColumn as char):
        case pcColumn:
            when "ttDbOption.IsBuiltin":u then
                return "_db-option.IsBuiltIn":u.      
            otherwise 
                return super:ColumnSource(pccolumn).
        end case.
    end method.     
    
end class.