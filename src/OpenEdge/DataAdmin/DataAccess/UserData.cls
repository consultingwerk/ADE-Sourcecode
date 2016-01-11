 /*************************************************************/
 /* Copyright (c) 2010 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : UserData 
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
 
routine-level on error undo, throw.

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAccess.IDataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccess from propath.


using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.DataSource.UserDataSource from propath.
 
using OpenEdge.DataAdmin.DataSource.UserTablePermissionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.UserFieldPermissionDataSource from propath.
 
using OpenEdge.DataAdmin.DataSource.UserPermissionDataSource from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.ISaveRequest from propath.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.

using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.

class OpenEdge.DataAdmin.DataAccess.UserData inherits DataAccess implements IDataAccess : 
 .
 
    define private variable TenantURL as character no-undo.
    
    define private variable mStart as integer no-undo.
    define private variable mSingle as logical no-undo.
    define private variable domainsURL     as character no-undo.
    define private variable  URL     as character no-undo.
    
 
    define public property BaseQuery as character no-undo
        get.     
        set.
    
    method public override void FetchData(msg as IFetchRequest):
        SetUrl(msg:url).
        DatasetHandle = msg:DataHandle.       
        FillData(msg).
    end method.
    
    method public void FillData(msg as IFetchRequest):
        define variable hBuffer as handle no-undo.
        define variable userDataSource as UserDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        
        case msg:EntityName:
            when "User" then
            do:
                hBuffer = msg:DataHandle:get-buffer-handle ("ttUser").
                if valid-handle(hBuffer) then
                do:
                    userDataSource = new UserDataSource( ).    
                    userDataSource:FillMode = "Replace".
                    userDataSource:Url = Url.
                    tableRequest = msg:GetTableRequest("ttUser").
                    if valid-object(tableRequest) then 
                        userDataSource:Prepare(hBuffer,tableRequest).         
                    else
                        userDataSource:Prepare(hBuffer).     
                
                end.     
                msg:DataHandle:Fill().
                if valid-object(userDataSource) and userDataSource:NumRecords <> ? then 
                    msg:SetTableTotal("ttUser",userDataSource:NumRecords).
       
            end.
            when "UserPermission" then
            do:
                 FillPermisssion(msg).
            end.
        end case.
        finally: /* is not garbage collected if set-callback is used */       
            delete object userDatasource no-error.		
        end finally.               
    end method.    
    
    method private void  FillPermisssion(msg as IFetchRequest):
        define variable hUserPermission as handle no-undo.
        define variable hUserFieldPermission as handle no-undo.
        define variable hUserTablePermission as handle no-undo.
        define variable userPerm as UserPermissionDataSource no-undo.
        define variable userfieldPerm as IDataSource no-undo.
        define variable hFieldRel as handle no-undo.
        define variable usertablePerm as IDataSource no-undo.
        define variable hTableRel as handle no-undo.
        
        hUserPermission = msg:DataHandle:get-buffer-handle ("ttUserPermission").
        userPerm = new UserPermissionDataSource().
        PrepareDataSource(userPerm,hUserPermission,msg:GetTableQuery("ttUserPermission"),"Append").
        
        hUserTablePermission = msg:DataHandle:get-buffer-handle ("ttUserTablePermission").
        if valid-handle(hUserTablePermission) then
        do:
            hUserTablePermission:fill-mode = "no-fill".
        end.
        hUserFieldPermission = msg:DataHandle:get-buffer-handle ("ttUserFieldPermission").
        if valid-handle(hUserFieldPermission) then
        do:
            hUserFieldPermission:fill-mode = "no-fill".
        end.
       
        msg:DataHandle:Fill().
        hUserPermission:fill-mode = "no-fill".
        
        if not hUserPermission:table-handle:has-records 
        and userPerm:ExternalIDValue > "" then 
        do transaction:
            hUserPermission:buffer-create().
            hUserPermission::Id = userPerm:ExternalIDValue.  
        end.
        
        if valid-handle(hUserTablePermission) then
        do:
            usertablePerm = new UserTablePermissionDataSource(hUserPermission).
            hTablerel = hUserTablePermission:parent-relation.
            hTablerel:active = false.   
            PrepareDataSource(usertablePerm,hUserTablePermission,"","Append").
        end.
      
        if valid-handle(hUserFieldPermission) then
        do:
             userFieldPerm = new UserFieldPermissionDataSource(hUserPermission).
             hFieldRel = hUserFieldPermission:parent-relation.
             hFieldRel:active = false.
             PrepareDataSource(userFieldPerm,hUserFieldPermission,"","Append").
        end.
       
        msg:DataHandle:Fill().
      
        if valid-handle(hUserTablePermission) then
            hUserTablePermission:detach-data-source ().
        if valid-handle(hUserFieldPermission) then
            hUserFieldPermission:detach-data-source ().
        if valid-handle(hTablerel) then
              hTablerel:active = true.       
        if valid-handle(hFieldRel) then
             hFieldRel:active = true.       
        
        finally: /* are not garbage collected if set-callback is used*/
            delete object usertablePerm no-error. 		
            delete object userFieldPerm no-error.       
            delete object userPerm no-error.       
        end finally.
    end method.    
     
    method protected override void SetUrl(pcUrl as char):   
        Url = pcurl.
        TenantUrl =  pcurl + "/tenants/".
        domainsURL = pcurl + "/domains/".
     end method.
     
    /* This is the call back for the QueryString parsing. There is currently no mapping, but we override it in 
       order to return the ttPartition's parent keys to the Query. This allows us to extract the expression later.
       Because it is added as parent (i.e _tenant) we can also extract the actual query fields without these.        
    */
    method public override character ColumnSource (pcColumn as char):
        if pcColumn = "ttUser.TenantName" then 
        do:
            return "_tenant._tenant-name".    
        end.
        return super:ColumnSource(pccolumn).     
   
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
    
	 
	method protected logical PrepareDataSource(ds as IDataSource,phbuffer as handle,pcQuery as char,pcMode as char):      
        ds:FillMode = pcMode.
        ds:Url = Url.
        return ds:Prepare(phBuffer,pcQuery,"").
    end method.     
    	
	method public override ISaveRequest SaveData(pChanges as ISaveRequest): 
        define variable hUser   as handle no-undo. 
        define variable userDataSource as UserDataSource no-undo.
        
        do transaction on error undo, throw:
             
            hUser = pChanges:DataHandle:get-buffer-handle ("ttUser") no-error.
            if valid-handle(hUser) then
            do:     
                userDataSource = new UserDataSource().
                userDataSource:Url = pChanges:Url.
                userDataSource:Save(hUser).
            end.
        end.
     
        return pChanges.
    end method.   
 
end class.
