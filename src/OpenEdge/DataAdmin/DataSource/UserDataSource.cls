/**************************************************************************
Copyright (c) 2011,2012,2015,2023,2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : UserDataSource
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : hdaniels
    Created     : nov 2010
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
using OpenEdge.DataAdmin.DataSource.DataSource from propath.
using OpenEdge.DataAdmin.Lang.QueryString from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.UserDataSource inherits DataSource :

    define variable msave as logical no-undo.
    define buffer b_domain for dictdb._Sec-Authentication-Domain.
    define buffer b_tenant for dictdb._tenant.
    define private property TenantURL  as character no-undo get. set.
    define protected variable mBuffer as handle no-undo.
    define private variable mMapping as char
	   init
"Name,_Userid,~
Description,_description,~
Number,_User_number,~
TenantId,_user._tenantid,~
IsSqlOnly,_sql-only-user,~
GivenName,_given_name,~
MiddleInitial,_middle_initial,~
SurName,_surname,~
DomainName,_domain-name,~
Telephone,_Telephone,~
Email,_Email,~
Createdate,_create_date,~
Lastlogin,_last_login"
/*DomainId,_sec-authentication-domain._domain-id,~*/
     no-undo.
    define query dquery for b_domain .
    define query dtenant for dictdb._tenant.

    constructor public UserDataSource (cParent as char,cWhere as char):
        super (cParent + ",_user","dictdb." + cparent + ",dictdb.user", mMapping).
        BaseTableExpression = cWhere.
        BaseQueryTemplate = "for each " + cParent + " no-lock, "
                          + " each _user&1no-lock".
    end constructor.

	constructor public UserDataSource ( ):
		this-object (mMapping).
    end constructor.

    constructor public UserDataSource (pcMapping as char):
        super ("_user","dictdb._user", pcMapping).
        BaseQueryTemplate = "for each _user&1no-lock".
    end constructor.

    constructor public UserDataSource (pcJoinTables as char,pcPhysicalJoinTables as char, pcQuery as char):
        super ("_user," + pcJoinTables,
               "dictdb._user," + pcPhysicalJoinTables,
               mMapping
               + if lookup("_Domain",pcJoinTables) > 0
                 then ",DomainId,_Domain._Domain-id"
                 else "").
        BaseQueryTemplate = "for each _user&1no-lock, " + pcQuery.
    end constructor.

    /* allow subclasses to override to not set call back even if we  have call back here */
    method protected logical SetCallBack(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill","AfterUserRow").
        TenantUrl = url + "/tenants/".
    end method.

    method protected override void PrepareBuffer(phBuffer as handle):
        SetCallBack(phBuffer).
        mBuffer = phBuffer.

    end method.

    method protected override logical PrepareQueryString (poQueryString as QueryString):
        define variable isOk as logical no-undo.
        define variable cQuery as character no-undo.
        /*
        isOk = AddUniqueOrNone("_tenant",poQueryString).
        if isOk = ? then
            undo, throw new IllegalArgumentError("UserDataSource prepare with non unique tenant reference. Use the tenant constructor.").
        */
        cQuery = poQueryString:BuildQueryString(Tables).
        isOk = QueryHandle:query-prepare(cQuery).
        return isOk.
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

        SaveUser(phBuffer,piState).

        return true.

        finally:
            mSave = false.
        end finally.
    end method.

     /** SaveUser changes of specified state
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified)
                      ? = all */
    method protected void SaveUser(phbuffer as handle,pistate as int):
        define variable hBeforeBuff    as handle    no-undo.
        define variable hQuery         as handle    no-undo.
        define variable iType          as integer   no-undo.
        define variable cType          as character no-undo.
        define variable cPrepareString as character no-undo.
        define variable hDataset       as handle    no-undo.
        define variable isMultiTenant  as logical   no-undo.
        define variable preEncode      as logical   no-undo.

        isMultiTenant = can-find(first DICTDB._tenant).

        case piState:
            when row-created or
            when row-modified or
            when row-deleted then
                assign cPrepareString = substitute("for each ttUserCopy where row-state(ttUserCopy) eq &1":u, piState).
            when ? then
                assign cPrepareString = 'for each ttUserCopy':u.
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
            hQuery:get-next.
            if hQuery:query-off-end then
                leave SAVEBLK.

            if hBeforeBuff:row-state eq row-deleted then
            do:
                // Use of no-error prevents throwing of errors if the record cannot be found (we check for availability anyway).
                find dictdb._user where dictdb._user._domain-name eq hBeforeBuff::DomainName
                                    and dictdb._user._userid eq hBeforeBuff::name exclusive-lock no-wait no-error.

                if available(dictdb._user) then
                    delete dictdb._user.

                // Reset the error-status flag as we don't care at this point.
                if error-status:error then error-status:error = false.
            end.
            else do:
                phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                if hBeforeBuff:row-state eq row-created then
                do:
                    create dictdb._user.
                    dictdb._user._userid = phBuffer::name.
                end.
                else
                    find dictdb._user where dictdb._user._domain-name eq hBeforeBuff::DomainName
                                        and dictdb._user._userid      eq hBeforeBuff::name exclusive-lock no-wait.

                /* value field assigmemnts */
                assign
                    dictdb._user._domain = phBuffer::DomainName
                    dictdb._user._description  = phBuffer::description
                    dictdb._user._given_name = phBuffer::GivenName
                    dictdb._user._middle_initial = phBuffer::MiddleInitial
                    dictdb._user._surname = phBuffer::SurName
                    dictdb._user._sql-only-user = phBuffer::IsSqlOnly
                    dictdb._user._User_number = phBuffer::Number
                    dictdb._user._Telephone = phBuffer::Telephone
                    dictdb._user._email = phBuffer::Email.

                if hBeforeBuff::password ne phBuffer::password
                or hBeforeBuff:row-state eq row-created then
                do:
                    assign preEncode = phBuffer::PreEncodePassword /* set from Service:PasswordPolicy */
                           dictdb._user._password = if preEncode eq true then phBuffer::Password else encode(phBuffer::Password)
                           phBuffer::PreEncodePassword = false. /* turn off the flag */
                end.

                if isMultiTenant then
                do:
                    /* user._tenantid is assigned by the ABL */
                    find dictdb._tenant where dictdb._tenant._tenantid = dictdb._user._tenantId no-lock.
                    assign phBuffer::TenantName = dictdb._tenant._tenant-name
                           phBuffer::TenantId   = dictdb._user._tenantid.
                end.

                hdataset = phBuffer:dataset.
                mBuffer = phBuffer.
                AfterUserRow (dataset-handle hdataset  by-reference).
            end. /* else (not delete) */
        end.

        catch e as Progress.Lang.Error :
            if e:GetMessageNum(1) = 16000 then
                undo, throw new DataAccessError(replace(replace(replace(e:GetMessage(1),"_Domain-Name","Name"),"table _sec-authentication-domain","Domain Table"),"(16000)",""),e).
            undo, throw new DataAccessError(
                new DataMapper("User,_user", mMapping),
                e).
        end catch.
        finally:
            hQuery:query-close().
            delete object hQuery no-error.
        end finally.
    end method.

    method public void AfterUserRow(dataset-handle hds):
        define variable hbuffer as handle    no-undo.
        define variable userurl as character no-undo.
        define variable iusersrc   as integer no-undo.
        define variable husersrc as handle no-undo.
	define variable lIsAdmin as logical no-undo initial false. /* Is the current user a security admin? */

        if mSave = false then
        do:

            if not Lazy and mBuffer::TenantId <> ? then
            do:
                /* use fields to speed up for remote connections */
                for each b_tenant fields( _tenant-name _tenantid) where b_tenant._tenantid = mBuffer::TenantId no-lock:
                    assign
                        mBuffer::TenantName = b_tenant._tenant-name.
                    leave.
                end.
            end.
        end.

        assign
            mBuffer::DomainUrl  = url + "/domains/"
                                + if mBuffer::DomainName = ""
                                  then WebUtil:UrlEncode(" ")
                                  else WebUtil:UrlEncode(mBuffer::DomainName)  when url > ''

            mBuffer::Id        = mbuffer::name
                                 + if mBuffer::DomainName > ""
                                   then "@" + mBuffer::DomainName
                                   else ""
            mBuffer::Password  = "********"
            mBuffer::url = url + "/users/" + WebUtil:UrlEncode(mBuffer::Id) when url > ''
            mBuffer::UserPermissionUrl = url + "/userpermissions/" + WebUtil:UrlEncode(mBuffer::Id) when url > ''
             .
	run prodict/_dctadmn.p ( input mbuffer::Id, output lIsAdmin ).
        mBuffer::IsSecAdmin = lIsAdmin.	 

        if mBuffer::TenantName > "" and url > '' then
            mBuffer::TenantUrl  = TenantURL + WebUtil:UrlEncode(mBuffer::TenantName).

        if mbuffer::description = ? then
            mbuffer::description = "".
        if mbuffer::MiddleInitial = ? then
            mbuffer::MiddleInitial = "".
         catch e as Progress.Lang.Error :

                message "error afgter" skip e:GetMessage(1)
                view-as alert-box.
         end catch.
    end method.

    /* This is the call back for the QueryString parsing. There is currently no mapping, but we override it in
       order to return the ttPartition's parent keys to the Query. This allows us to extract the expression later.
       Because it is added as parent (i.e _tenant) we can also extract the actual query fields without these.
    */

     method public override character ColumnSource(pcColumn as char):
        /* input to columnexpression */
        if pcColumn = "ttUser.TenantName" then
        do:
            return "_tenant._tenant-name".
        end.
        if pcColumn = "ttUserPermission.id" or pcColumn = "ttUser.id"  then
             return "_user.id".
        else return super:ColumnSource(pcColumn).
    end method.

    method public override character ColumnSortSource(pcColumn as char):
        if pcColumn = "ttUser.TenantName" then
        do:
            return "_tenant._tenant-name".
        end.
        if pcColumn = "_User.id" then
        do:
            return "( _user._userid + '@' + _user._domain-name)".
        end.
        return super:ColumnSortSource(pccolumn).
    end method.

    method public override character ColumnExpression (pcColumn as char, pcOperator as char, pcValue as char):
        define variable cName as character no-undo.
        define variable cDomain as character no-undo.
        define variable cExpress as character no-undo.
        if pcColumn = "_User.id" then
        do:
            SplitId(pcValue,output cName,output cDomain).
            /* ensure domain is in query also when blank in expression value */
            if lookup(pcoperator,"EQ,=") > 0 then
                cExpress = "(_user._userid " + pcOperator + " " + quoter(cName)
                         + " and _user._domain-name " + pcOperator + " " + quoter(cDomain)
                         + ")".

            else if cDomain = "" then
               cExpress = "(_user._userid "
                         + pcOperator
                         + " "
                         + quoter(cName) + ")".
            else
                cExpress = "( _user._userid + "
                         +  "(if _user._domain-name = '' then '' else '@' + _user._domain-name) "
                         + pcOperator
                         + " "
                         + quoter(pcValue) + ")".

            return cExpress.
        end.

        return super:ColumnExpression(pccolumn,pcOperator,pcValue).

    end method.

    method private void SplitId(id as char,output puser as char, output pdomain as char):
        if num-entries(id,"@") > 1 then
            pdomain = entry(2,id,"@").

        puser = entry(1,id,"@").

    end method.

    method protected override character FindTableJoinValues(pTable as char,pFind as char):
        case pTable:
            when "_tenant" then
                return FindTenantJoin(pFind).

        end case.
        return ?.
    end method.

    method private character FindTenantJoin(pFind as char):
        buffer dictdb._tenant:find-unique(pFind).
        return "_User._Tenantid = " + quoter(_Tenant._Tenantid).
    end method.

end class.
