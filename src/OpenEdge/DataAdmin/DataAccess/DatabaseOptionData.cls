/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Data Access for Db-Option
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-04-26
    Notes       :  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.DataAccess.
using OpenEdge.DataAdmin.DataAccess.IDataAccess.
using OpenEdge.DataAdmin.DataSource.IDataSource.
using OpenEdge.DataAdmin.DataSource.DatabaseOptionDataSource.
using OpenEdge.DataAdmin.DataSource.UserDataSource.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.ITableRequest.

class OpenEdge.DataAdmin.DataAccess.DatabaseOptionData inherits DataAccess implements IDataAccess : 
    {daschema/securityoptions.i}
    
    define public property BaseQuery as character no-undo
        get():
           return 'for each _db-option no-lock':u.
        end get.     
        set.
    
    method public override ISaveRequest SaveData(pChanges as ISaveRequest): 
        define variable hOption  as handle no-undo.
        define variable hSecOption as handle no-undo.
        define variable optionSource as IDataSource no-undo.
        define variable secOptionsSource as IDataSource no-undo.
         
        do transaction on error undo, throw:
            assign hOption = pChanges:DataHandle:get-buffer-handle ('ttDbOption':u) no-error.
            if valid-handle(hOption) then
            do:
                optionSource = new DatabaseOptionDataSource().
                optionSource:Url = pChanges:Url.
                optionSource:Save(hOption).
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
        define variable hOption  as handle no-undo.
        define variable optionSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.     
        
        assign hOption = msg:DataHandle:get-buffer-handle ('ttDbOption':u) no-error.
        if valid-handle(hOption) then
        do:    
            optionSource = new DatabaseOptionDataSource().
            optionSource:FillMode = 'Replace':u. 
            optionSource:Url = this-object:Url.
            tableRequest = msg:GetTableRequest('ttDbOption':u).
            if valid-object(tableRequest) then 
                optionSource:Prepare(hOption, tableRequest).         
            else
                optionSource:Prepare(hOption).           
        end.
        
        msg:DataHandle:Fill().
        if valid-object(optionSource) and optionSource:NumRecords <> ? then 
            msg:SetTableTotal('ttDbOption':u, optionSource:NumRecords).
        finally:
            delete object optionSource no-error.		
        end finally.    
    end method.                                                                           
 
end class.
