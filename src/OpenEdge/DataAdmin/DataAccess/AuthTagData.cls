/************************************************
  Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    Purpose     : Data Access for AuthTag data
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2023-07-24
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.DataAccess.
using OpenEdge.DataAdmin.DataAccess.IDataAccess.
using OpenEdge.DataAdmin.DataSource.AuthTagDataSource.
using OpenEdge.DataAdmin.DataSource.IDataSource.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.ITableRequest.

class OpenEdge.DataAdmin.DataAccess.AuthTagData inherits DataAccess implements IDataAccess:

    define public property BaseQuery as character no-undo
        get():
           return "for each _sec-auth-tag no-lock".
        end get.
        set.

    method public override ISaveRequest SaveData(pChanges as ISaveRequest):
        define variable hAuthTag as handle no-undo.
        define variable tagSource as IDataSource no-undo.

        do transaction on error undo, throw:
            hAuthTag = pChanges:DataHandle:get-buffer-handle("ttAuthTag":u) no-error.
            if valid-handle(hAuthTag) then
            do:
                tagSource = new AuthTagDataSource().
                tagSource:Save(hAuthTag).
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
        define variable hAuthTag as handle no-undo.
        define variable tagSource as IDataSource no-undo.
        define variable tableRequest as ITableRequest no-undo.

        hAuthTag = msg:DataHandle:get-buffer-handle("ttAuthTag":u) no-error.
        if valid-handle(hAuthTag) then
        do:
            tagSource = new AuthTagDataSource().
            tagSource:FillMode = "Replace":u.
            tagSource:Prepare(hAuthTag,msg:GetTableQuery("ttAuthTag":u), "":u).
        end.

        msg:DataHandle:Fill().
        if valid-object(tagSource) and tagSource:NumRecords ne ? then
            msg:SetTableTotal("ttAuthTag":u, tagSource:NumRecords).
        finally:
            delete object tagSource no-error.
            delete object tagSource no-error.
        end finally.
    end method.

end class.
