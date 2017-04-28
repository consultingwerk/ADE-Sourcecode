/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Data Access for granted role data
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     :  2016-04-18
    Notes       :  
  ----------------------------------------------------------------------*/
 
block-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.DataAccess.
using OpenEdge.DataAdmin.DataAccess.IDataAccess.
using OpenEdge.DataAdmin.DataSource.GrantedRoleDataSource.
using OpenEdge.DataAdmin.DataSource.IDataSource.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.ITableRequest.

class OpenEdge.DataAdmin.DataAccess.GrantedRoleData inherits DataAccess implements IDataAccess : 
 
  define public property BaseQuery as character no-undo 
        initial "for each _sec-granted-role no-lock":u
        get.
        set.
    
    method public override ISaveRequest SaveData(pChanges as ISaveRequest): 
        define variable hGrant as handle no-undo.
        define variable grantSource as IDataSource no-undo.
        
        do transaction on error undo, throw:
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
        assign this-object:Url = msg:url
               DatasetHandle = msg:DataHandle.       
        FillData(msg).
    end method.
    
    method public void FillData(msg as IFetchRequest):
        define variable hBuffer as handle no-undo.
        define variable grantSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
         
        hBuffer = msg:DataHandle:get-buffer-handle("ttGrantedRole":u) no-error.
        if valid-handle(hBuffer) then
        do:    
            grantSource = new GrantedRoleDataSource().
            grantSource:FillMode = "Replace":u.
            grantSource:Url = Url.
            tableRequest = msg:GetTableRequest("ttGrantedRole":u).
            if valid-object(tableRequest) then 
                grantSource:Prepare(hBuffer,tableRequest).         
            else
                grantSource:Prepare(hBuffer).           
        end.
        
        msg:DataHandle:Fill().
        if valid-object(grantSource) and grantSource:NumRecords <> ? then 
            msg:SetTableTotal("ttGrantedRole":u, grantSource:NumRecords).
        finally:
            delete object grantSource no-error.		
        end finally.    
    end method.                                                                           
 
end class.
