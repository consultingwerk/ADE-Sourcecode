/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Data Access for Role data
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-25
    Notes       :  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.DataAccess.
using OpenEdge.DataAdmin.DataAccess.IDataAccess.
using OpenEdge.DataAdmin.DataSource.IDataSource.
using OpenEdge.DataAdmin.DataSource.RoleDataSource.
using OpenEdge.DataAdmin.DataSource.UserDataSource.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.ITableRequest.
using OpenEdge.DataAdmin.DataSource.GrantedRoleDataSource.

class OpenEdge.DataAdmin.DataAccess.RoleData inherits DataAccess implements IDataAccess : 
 
  define public property BaseQuery as character no-undo
        get():
           return "for each _sec-role no-lock, each _sec-granted-role outer-join where _sec-granted-role._role-name eq _sec-role._role-name no-lock".
        end get.     
        set.
    
    method public override ISaveRequest SaveData(pChanges as ISaveRequest): 
        define variable hRole  as handle no-undo.
        define variable hGrant as handle no-undo. 
        define variable roleSource as IDataSource no-undo.
        define variable grantSource as IDataSource no-undo.
         
        do transaction on error undo, throw:
            hRole = pChanges:DataHandle:get-buffer-handle ("ttRole":u) no-error.
            if valid-handle(hRole) then
            do:
                roleSource = new RoleDataSource().
                roleSource:Url = pChanges:Url.
                roleSource:Save(hRole).
            end.
            hGrant = pChanges:DataHandle:get-buffer-handle ("ttGrantedRole":u) no-error.
            if valid-handle(hGrant) then
            do:   
                grantSource = new GrantedRoleDataSource().  
                grantSource:Url = pChanges:Url.
                grantSource:Save(hGrant).
            end.
        end.
        
        return pChanges.
    end method.      
 
    method public override void FetchData(msg as IFetchRequest):
        Url = msg:url.
        DatasetHandle = msg:DataHandle.       
        FillData(msg).
    end method.
    
    method public void FillData(msg as IFetchRequest):
        define variable hRole  as handle no-undo.
        define variable hGrant as handle no-undo. 
        define variable roleSource as IDataSource no-undo.
        define variable grantSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        
        hRole = msg:DataHandle:get-buffer-handle ("ttRole":u) no-error.
        if valid-handle(hRole) then
        do:    
            roleSource = new RoleDataSource().
            roleSource:FillMode = "Replace":u.
            roleSource:Url = this-object:Url.
            tableRequest = msg:GetTableRequest("ttRole":u).
            if valid-object(tableRequest) then 
                roleSource:Prepare(hRole,tableRequest).         
            else
                roleSource:Prepare(hRole).           
        end.
        
        hGrant = msg:DataHandle:get-buffer-handle ("ttGrantedRole":u) no-error.
        if valid-handle(hGrant) then
        do:    
            grantSource = new GrantedRoleDataSource().
            grantSource:FillMode = "Replace":u.
            grantSource:Url = this-object:Url.
            grantSource:Prepare(hGrant,msg:GetTableQuery("ttGrantedRole":u), "":u).          
        end.     

        msg:DataHandle:Fill().
        if valid-object(roleSource) and roleSource:NumRecords <> ? then 
            msg:SetTableTotal("ttRole":u, roleSource:NumRecords).
        finally:
            delete object roleSource no-error.		
            delete object grantSource no-error.        
        end finally.
    end method.                                                                           
 
end class.
