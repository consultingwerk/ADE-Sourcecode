/*************************************************************/
 /* Copyright (c) 2014 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : IndexDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sep 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.DataAccess.DataMapper from propath.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using Progress.Lang.*.

block-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.LocalIndexDataSource inherits DataSource: 
    define protected variable mBuffer as handle no-undo.
    define protected variable mDBRecid as recid no-undo.
    define protected variable mSaving as logical no-undo.
 	define private variable mMapping as char
	   init  	   
"IndexName,_Index-name,~
PartitionPolicyName,_Partition-Policy._Partition-Policy-Name,~
TableName,_File-Name,~
SchemaName,_File._owner"
 no-undo.
  
	constructor public LocalIndexDataSource ( ):	    
		super ("_Partition-Policy,_File,_Index","dictdb._Partition-Policy,dictdb._File,dictdb._index", mMapping).	
	    BaseQuery = "for each _Partition-Policy no-lock, each _file  where " + DatabaseInfo:FileExpression + " and _file._file-number = _Partition-Policy._object-number no-lock, each _index of _file where _index._index-attributes[1] = 'true' no-lock".
    end constructor.
    
    method protected override void PrepareBuffer(phBuffer as handle):
        phBuffer:set-callback("After-Row-fill","AfterRow").
        mBuffer = phBuffer.
    end method.
    
    method public override logical Save(phbuffer as handle):
        this-object:Save(phbuffer,?).
    end method.
       /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
    
    method public override logical Save(phbuffer as handle,piState as int):
        this-object:Save(?,phbuffer,?).
    end method.
                       
                      
    method public override logical Save(parentbufferHandle as handle,phBuffer as handle,piState as integer).
        define variable hDataset     as handle no-undo.
        define variable hBeforeBuff  as handle    no-undo.
        define variable hquery       as handle    no-undo.
        define variable dbRecid      as recid     no-undo.
        define variable hQueryBuffer as handle no-undo.
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
        mSaving = true. 
        hBeforeBuff = phBuffer:before-buffer.
        
        create query hquery.
        
        if piState = row-modified then
            undo, throw new UnsupportedOperationError("Update of Local Index").
        else if piState = row-created then
        do:
            hQueryBuffer = phBuffer.
        end.
        else do:
            hQueryBuffer = hBeforebuff.
        end.
        
        hQuery:add-buffer(hQueryBuffer).
        hQuery:query-prepare("for each "  + hQueryBuffer:name
                              + (if piState <> ?
                                 then " where row-state(" + hQueryBuffer:name + ") = " + string(piState)
                                 else "")
                                 /* only tru if state is passed */
                              + (if valid-handle(parentBufferHandle)
                                 then " and " + hQueryBuffer:name + ".PartitionPolicyName = " + quoter(parentBufferHandle::Name)
                                 else "" )

                               ).
               
        hquery:query-open().
         /* The first call to DatabaseInfo may call the constructor which
             has a find that will give error 7254 , so don't use in where clause */
        dbRecid = DatabaseInfo:DatabaseRecid. 
                 
        /* This is not likely to be the transacton at runtime. 
           The DataAccess will typically define the transaction for all sources */
        do transaction on error undo, throw:
            do while true:
                hquery:get-next.   
                
                if not hQueryBuffer:avail then 
                    leave.
                
                if hQueryBuffer = hBeforebuff then 
                    phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                               
                if phBuffer:row-state > 0 then
                do:
                    phBuffer:error = true.
                    phBuffer:rejected = true.
                end. 
               
                find dictdb._file where dictdb._file._db-recid = dbRecid
                                  and   dictdb._file._file-name = hQueryBuffer::TableName 
                                  and   dictdb._file._owner = hQueryBuffer::SchemaName no-lock no-error. 
                if not avail dictdb._file then       
                    undo, throw new DataAccessError("Table " + quoter(hQueryBuffer::TableName) + " does not exist"). 
              
                find dictdb._index of dictdb._file where dictdb._index._index-name = hQueryBuffer::IndexName exclusive no-wait no-error.
                if locked dictdb._index then 
                    undo, throw new DataAccessError("Index " + quoter(hQueryBuffer::IndexName) +  " in table " + quoter(hQueryBuffer::TableName) + " is locked").
                else if not avail dictdb._index then
                    undo, throw new DataAccessError("Index " + quoter(hQueryBuffer::IndexName) + " was not found in table " + quoter(hQueryBuffer::TableName)). 
                else if error-status:error then
                do:
                    undo, throw new DataAccessError(error-status:get-message (1)).
                end.          
                
                /* local (true) if created - global if deleted - rely on core message if not allowed  */
                dictdb._index._index-attributes[1] = phBuffer:row-state = row-created.
                if phBuffer:row-state = row-created then
                do:  
                    mbuffer = phBuffer. 
                    hdataset = phBuffer:dataset.
                    AfterRow(dataset-handle hdataset  by-reference).
                end.
                phBuffer:error =false.
                phBuffer:rejected = false.
            end.
            
            catch e2 as DataAccessError:
                undo, throw e2.                 
            end catch.
            
            catch e as Progress.Lang.Error :
                undo, throw new DataAccessError(
                    new DataMapper("Index,_Index",
                    FieldMapping), e). 
            end catch.
        end. /* transaction (most likely sub-trans ) */   
        finally:
           delete object hQuery no-error. 
           mSaving = false. 
           mbuffer = ?.
        end finally. 
    end method.      
    
    method public override void AfterRow(dataset-handle hds):
         mBuffer::IndexURL = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::TableName) 
                                           +  "/indexes/" + WebUtil:UrlEncode(mBuffer::IndexName).
    end method.
    
end class.