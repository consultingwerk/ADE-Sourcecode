/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
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

class OpenEdge.DataAdmin.DataSource.IndexDataSource inherits DataSource: 
    define protected variable AreaUrl as char no-undo init "/areas/".
    define protected variable mBuffer as handle no-undo.
    define protected variable mDBRecid as recid no-undo.
    define protected variable mSaving as logical no-undo.
 	define private variable mMapping as char
	   init  	   
"Name,_Index-name,~
TableName,_File-Name,~
SchemaName,_owner,~
trowid,rowid(_Index),~
IsLocal,_Index-attributes[1],~
IsMultiTenant,_File-attributes[1],~
Description,_Index._Desc,~
IsActive,_Active,~
IsUnique,_Unique"
 no-undo.
  
	constructor public IndexDataSource ( ):	    
		super ("_File,_Index","dictdb._File,dictdb._index", mMapping).	
		BaseQuery = "for each _file no-lock, each _index of _file no-lock".
    end constructor.
    
    constructor public IndexDataSource (hchanges as handle ):     
        super (hchanges,"_File,_Index","dictdb._File,dictdb._Index",
               "Name,ttIndexChange.Indexname,ttindex.TableName,ttIndexChange.Tablename,trowid,rowid(_Index),IsMultiTenant,_File-attributes[1]").
        find first dictdb._db where _db._db-local = true no-lock.
        mDBRecid = recid(dictdb._db).
        BaseQuery = "for each ttIndexChange, each _file where _file._file-name = ttIndexChange.Tablename and _file._db-recid = " + quoter(mDBRecid) + " and  _file._owner = 'PUB' and _file._hidden = 'false' no-lock,"
                  + " each _index of _file where _index._index-name = ttIndexChange.Indexname no-lock" .
    end constructor.
     
    constructor public IndexDataSource (phParent as handle,pcFileJoin as char,pcIndexJoin as char):
        super (phParent,"_File,_Index","dictdb._File,dictdb._Index", mMapping). 
        BaseQuery = "for each " + phParent:name + ", each _file where " + pcFileJoin 
                  + " and " + DatabaseInfo:FileExpression + " no-lock,"
                  + " each _Index of _file where " + pcIndexJoin + " no-lock" .
         
    end constructor.
      
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        phBuffer:set-callback("After-Row-fill","AfterIndexRow").
        super:Prepare(phBuffer,pcTargetQuery,pcJoin).
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
        define variable cdealloctable as longchar no-undo.
        define variable hDataset as handle no-undo.
        define variable hBeforeBuff as handle    no-undo.
        define variable hquery      as handle    no-undo.
        define variable iType       as integer   no-undo.
        define variable cType       as character no-undo.
        define variable cName       as character no-undo.
        define variable dbRecid     as recid     no-undo.
        define variable iTenantid   as integer no-undo.
        define variable iObjectid   as integer no-undo.
        define variable iTypeId     as integer no-undo.
      
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
        mSaving = true. 
        create query hquery.
        
        hBeforeBuff = phBuffer:before-buffer.
        hquery:add-buffer(hBeforeBuff).
        hQuery:query-prepare("for each ttIndexCopy "
                              + (if piState <> ? 
                                 then " where row-state(ttIndexCopy) = " + string(piState)
                                 else "")   
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
                 
                if not hBeforebuff:avail then 
                    leave.
                
                if phBuffer:row-state > 0 then
                do:
                    phBuffer:error = true.
                    phBuffer:rejected = true.
                end. 
                      
                phBuffer:find-by-rowid (hBeforeBuff:after-rowid).
                if phBuffer:row-state = row-deleted then 
                    undo, throw new UnsupportedOperationError("Delete of index").  
                else if phBuffer:row-state = row-created  then 
                    undo, throw new UnsupportedOperationError("Create of index").
                else if phBuffer:row-state = row-modified then
                do:
                    find dictdb._file where dictdb._file._db-recid = dbRecid
                                      and   dictdb._file._file-name = phBuffer::TableName 
                                      and   dictdb._file._owner = phBuffer::SchemaName no-lock no-error. 
                    if not avail dictdb._file then       
                        undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist"). 
                  
                    find dictdb._index of dictdb._file where dictdb._index._index-name = hBeforeBuff::Name exclusive no-wait no-error.
                    if locked dictdb._index then 
                        undo, throw new DataAccessError("Index " + quoter(hBeforeBuff::Name) +  " in table " + quoter(phBuffer::TableName) + " is locked").
                    else if not avail dictdb._index then
                        undo, throw new DataAccessError("Index " + quoter(hBeforeBuff::Name) + " was not found in table " + quoter(phBuffer::TableName)). 
                    else if error-status:error then
                    do:
                        undo, throw new DataAccessError(error-status:get-message (1)).
                    end.          
                    if phBuffer::Name <> dictdb._index._index-name then
                    do:
                        undo, throw new UnsupportedOperationError("Rename of index is not supported").
                    end.    
                    
                    if phBuffer::IsActive <> dictdb._index._Active then
                    do:
                        dictdb._index._Active = phBuffer::IsActive. /* let core throw the fit */
                    end.    
                    
                    if phBuffer::IsPrimary <> hBeforeBuff::IsPrimary then
                    do:
                       if not phBuffer::IsPrimary then 
                       do:
                           undo, throw new IllegalOperationError("Cannot set the primary attribute on an index to false").
                       end.    
                       else do:
                          /* @todo client side refresh of primary on merge */
                           find current dictdb._file exclusive no-wait.
                           /* probably not possible - schema lock */
                           if locked dictdb._file then 
                               undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " is locked.").
                           
                           dictdb._file._prime-index = recid(dictdb._index).
                       end.    
                    end.   
                    if phBuffer::IsUnique <> dictdb._index._unique then
                    do:
                        undo, throw new IllegalOperationError("The unique/non-unique attribute cannot be changed on an existing index").
                    end.    
                    if phBuffer::IsWordIndex <> hBeforeBuff::IsWordIndex then
                    do:
                        if  hBeforeBuff::IsWordIndex then 
                            undo, throw new IllegalOperationError("An existing word index cannot be changed to a regular index").
                        else
                            undo, throw new IllegalOperationError("An existing index cannot be changed to a word index").
                    end.    
                    if phBuffer::IsLocal <> dictdb._index._index-attributes[1] then
                    do:
                        /* core message if not allowed */
                        dictdb._index._index-attributes[1] = phBuffer::IsLocal.
                    end.    
                    
                    if phBuffer::Description <>  hBeforeBuff::Description then
                    do:
                        dictdb._Index._Desc = phBuffer::Description.
                    end.
          
                    mbuffer = phBuffer. 
                    hdataset = phBuffer:dataset.
                    phBuffer:error =false.
                    phBuffer:rejected = false.
                    AfterIndexRow(dataset-handle hdataset  by-reference).
               end.
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
    
    
    method public void AfterIndexRow(dataset-handle hds):
        define variable cArea as character no-undo.
        define variable cAreaRef as character no-undo.
        define variable iSource as integer no-undo.
        assign 
            cArea = ""
            cAreaRef = ""
            iSource = lookup("_index",Tables).
        
        if not mSaving then
        do:
            find dictdb._index where recid(dictdb._index) = DataSourceHandle:get-source-buffer(iSource):recid no-lock.
            find dictdb._file of _index no-lock.
            
            if mBuffer::Description = ? then
                mBuffer::Description = "". 
            
            assign 
                mBuffer::IsWordIndex = if dictdb._index._Wordidx > 0 then true else false
                mBuffer::IsPrimary = dictdb._file._prime-index = recid(dictdb._index).
            
            if dictdb._file._file-attributes[1] = false 
            or dictdb._file._file-attributes[2] = true then
            do:    
                find dictdb._storage where dictdb._storage._db-recid = dictdb._file._db-recid
                                     and dictdb._storage._object-type = 2                                     
                                     and dictdb._storage._object-number = dictdb._index._idx-num 
                                     and dictdb._storage._Partitionid = 0
                                     no-lock no-error.
                /* table partitioning storage may or may not have an area so avoid if  0  */                     
                if avail dictdb._storage and dictdb._storage._Area-number > 0 then
                do:
                    find dictdb._area where dictdb._Area._Area-number
                                          =  dictdb._storage._Area-number no-lock.   
                    assign
                       cArea    = dictdb._area._area-name       
                       cAreaRef = url + AreaURL + WebUtil:UrlEncode(dictdb._Area._Area-name,"default"). 
                end. 
            end.
            assign
                mBuffer::AreaName = cArea
                mBuffer::AreaURL  = cAreaRef.
        end. 
        assign
            mBuffer::IndexFieldURL = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::TableName) 
                                         +  "/indexes/" + WebUtil:UrlEncode(mBuffer::Name)
                                         +  "/indexFields" 
            mBuffer::FieldURL = url + "/schemas/PUB/tables/" + WebUtil:UrlEncode(mBuffer::TableName) 
                                         +  "/indexes/" + WebUtil:UrlEncode(mBuffer::Name)
                                         +  "/fields" .
    
    end method.
    
end class.