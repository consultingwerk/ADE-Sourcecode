/*************************************************************/
/* Copyright (c) 2013-2014 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 2013
    Notes       : Mapped to the partitionpolicy buffer and uses Beforefill 
                  to fill the partitionpolicyfields  
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.DataAccess.DataAccessError.
using OpenEdge.DataAdmin.DataAccess.DataMapper.
using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.DataSource.DataSourceUtil.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Lang.QueryString.
using Progress.Lang.*.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.PartitionPolicyFieldDataSource inherits DataSource : 
   
    define variable msave as logical no-undo.
    define buffer b_domain for dictdb._Sec-Authentication-Domain.
    define private property TenantURL  as character no-undo get. set.
    define protected variable mBuffer as handle no-undo.
    define protected property DataSourceUtil as DataSourceUtil no-undo 
        get():
            if not valid-object(DataSourceUtil) then
                DataSourceUtil = new DataSourceUtil().
            return DataSourceUtil.     
        end. 
        set.
	 
/*DomainId,_sec-authentication-domain._domain-id,~*/
    
    
    constructor public PartitionPolicyFieldDataSource ():      
        super ("_Partition-Policy","dictdb._Partition-Policy", "PartitionPolicyName,_Partition-Policy-name"). 
        BaseQuery = "for each _Partition-Policy no-lock".
    end constructor.
     
        /* allow subclasses to override to not set call back even if we  have call back here */
    method protected logical SetCallBack(phBuffer as handle):
        /* creates a row for each field */
        phBuffer:set-callback("Before-row-fill","BeforeFill").
        
        /* deletes auto created if none were created */
        phBuffer:set-callback("After-row-fill","AfterFill").
 
        TenantUrl = url + "/tenants/".
    end method.
    
    method public final override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        define variable lok as logical no-undo.
        SetCallBack(phBuffer).
        lok  = super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        mBuffer = phBuffer.
      
        return lok.
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
    
    /** Save changes of specified state 
         @param buffer the temp-table buffer handle with data
         @param state  the row-state to save (row-created, row-deleted or row-modified) 
                      ? = all */
                      
    method public override logical Save(parentbufferHandle as handle,phBuffer as handle,piState as integer).
        define buffer b_policy-detail for dictdb._Partition-Set-Detail.
        define variable hDataset as handle no-undo. 
        define variable hBeforeBuff as handle    no-undo.
        define variable hquery      as handle    no-undo.
        define variable cMsg        as character no-undo.
        define variable dbRecid     as recid no-undo.
        define variable iNumber     as integer no-undo. 
        define variable iLoop       as integer no-undo.
        define variable i           as integer no-undo.
        define variable dbRecod     as rowid no-undo.
        define variable cFields     as character extent 15 init ? no-undo. 
        define variable inumidx as integer no-undo. 
        define variable cidxmsg as character no-undo.
        define variable ipos as integer no-undo.
        define variable cidx as character no-undo.
        define variable lMod     as logical no-undo.
        define variable filerecid  as recid no-undo.
        define variable cFields2 as character extent no-undo. 
        if not valid-handle(parentbufferHandle) then
            undo, throw new UnknownValueError("PartitionPolicyFieldDataSource save","parent buffer").
            
        if piState  = ?  then
            undo, throw new IllegalArgumentError("PartitionPolicyFieldDataSource save does not support unknown value in state parameter." ).
        
        if piState < 1 or pistate > 3 then
            undo, throw new IllegalArgumentError("Invalid state " + string(piState) + " passed to save." ).
       
        mSave = true.
        
        dbRecid = DatabaseInfo:DatabaseRecid. 
        hBeforeBuff = phBuffer:before-buffer.
        create query hquery.
       
        /* delete shifts array up so start from bottom */
        if pistate = row-deleted then
        do:
            hquery:add-buffer(hBeforeBuff).
            hQuery:query-prepare("for each ttPartitionPolicyFieldCopy where row-state(ttPartitionPolicyFieldCopy) = " + string(piState)
                                  + " and ttPartitionPolicyFieldCopy.PartitionPolicyName = " + quoter(parentbufferHandle::name)
                                  + " by ttPartitionPolicyFieldCopy.Number descending").
            hquery:query-open().       
            hquery:get-first.   
            do transaction on error undo, throw:
                do while hBeforebuff:avail:
                    find dictdb._Partition-Policy where dictdb._Partition-Policy._Partition-Policy-Name = hBeforeBuff::PartitionPolicyName exclusive-lock no-wait.
                    iNumber = hBeforeBuff::Number.
                    do iloop = iNumber to extent(dictdb._Partition-Policy._Column-Name) - 1:
                        dictdb._Partition-Policy._Column-Name[iLoop] = dictdb._Partition-Policy._Column-Name[iLoop + 1].
                    end.                        
                    dictdb._Partition-Policy._Column-Name[iLoop] = ? .
                    hQuery:get-next.
                end.    
                catch e as Progress.Lang.Error :
                	undo, throw e. 	
                end catch.       
            end.   
        end.
        else do transaction on error undo, throw:
            hquery:add-buffer(phBuffer).
            /* use after buffer to join by name  */     
            hQuery:query-prepare("for each ttPartitionPolicyField where row-state(ttPartitionPolicyField) = " + string(piState)
                                 + " and ttPartitionPolicyField.PartitionPolicyName = " + quoter(parentbufferHandle::name)
                                 + " by ttPartitionPolicyField.Number").
            hquery:query-open().       
            hquery:get-first.   
            do on error undo, throw:
                do while phBuffer:avail:
                    /* avoid merge changes if not success set to false at end */ 
                    phBuffer:error = true.
                    find dictdb._file where dictdb._file._db-recid = dbRecid
                                      and   dictdb._file._file-name = phBuffer::TableName 
                                      and   dictdb._file._owner = "PUB" no-lock no-error. 
                    if not avail dictdb._file then       
                         undo, throw new DataAccessError("Table " + quoter(phBuffer::TableName) + " does not exist"). 
                  
                    find dictdb._field of dictdb._file where dictdb._field._Field-name = phBuffer::FieldName no-lock no-error.
                     if not avail dictdb._field then       
                         undo, throw new DataAccessError("Field " + quoter(phBuffer::FieldName) + " was not found in table " + quoter(phBuffer::TableName)). 
                  
                    iNumber = phBuffer::Number.
                    filerecid = recid(dictdb._file).
                    if iNumber > extent(cFields ) then
                         undo, throw new DataAccessError("Failed to add field " + quoter( phBuffer::FieldName) + " to policy detail "  +  quoter( phBuffer::TableName)
                                                         + ". The policy cannot have more than 15 fields." ). 
             
                    cFields[iNumber] = phBuffer::FieldName.
                    phBuffer::DataType = dictdb._field._data-type.
                    phBuffer::Description = dictdb._field._desc.   
                    phBuffer:error =false.
                    phBuffer:rejected = false.
                    hQuery:get-next.
                end.
            end.
            /* check if changes and use core error message if there is any  */
            if piState = row-modified then
            do:
                do i = 1 to iNumber :
                    find dictdb._Partition-Policy where dictdb._Partition-Policy._partition-policy-name = parentbufferHandle::name no-lock.
                    if dictdb._Partition-Policy._Column-Name[i] <> cFields[i] then
                    do:
                        lMod = true.
                        leave.
                    end.      
                  /* leave to core 
                     undo, throw new DataAccessError("Cannot modify the fields of an existing Partition Policy.").*/
                end.
            end.
            else if piState = row-created then 
            do:
                /* any created */
                if filerecid <> ? then
                do:
                    /* create a local index if non exists 
                      (currently first matching found )
                       no error is thrown if index does not exist 
                       leave error handling to AVM schema trap */
                    extent(cFields2) = INumber.
                    do i = 1 to iNumber :
                        cFields2[i] = cFields[i].
                    end.   
                    MakeIndexLocal(recid(dictdb._file),cFields2).
                    lMod = true.
                end.
            end.
                
            if lMod then 
            do:
/*                find dictdb._Partition-Policy where dictdb._Partition-Policy._Partition-policy-name = parentbufferHandle::name exclusive.*/
                do i = 1 to iNumber:
                    /* row-modified assigned to throw error if changed */
                    if piState = row-modified then 
                        dictdb._Partition-Policy._Column-Name[i] = cFields[i].   
                    else    
                        parentbufferHandle::FieldNames(i) = cFields[i].
                end.
            end.
            
            catch e2 as DataAccessError :
                undo, throw e2.
            end. 
            
            catch e as Progress.Lang.Error :
                undo, throw new DataAccessError(new DataMapper("PartitionPolicy,_Partition-Policy,fields,_Column-name",FieldMapping), e). 
            end.            
        end.
        catch e as Progress.Lang.Error :
        	undo, throw e.	
        end catch.
        finally:
           delete object hQuery no-error. 
           mSave = false.           
        end finally.
    end method.   
      
    method public override logical Fill().
         define variable hDs as handle.
         define variable i as integer no-undo.
         define variable hPolicy as handle no-undo.       
         define variable hField as handle no-undo.    
         define variable cFields as character extent no-undo.
         
         QueryHandle:query-open().   
         hds = DataBuffer:dataset.
         hPolicy = QueryHandle:get-buffer-handle(1).
         hField = hds:get-buffer-handle("ttPartitionPolicyField").
         QueryHandle:get-first(). 
         do while hPolicy:avail:
             cFields = hPolicy::_Column-name.
             find dictdb._file where dictdb._file._file-number = hPolicy::_object-number no-lock.
           
             FillFields(hField,hPolicy::_Partition-policy-name,dictdb._file._file-name,recid( dictdb._file ),cFields). 
             QueryHandle:get-next().   
         end.
          
    end method.
    
    method public void BeforeFill(dataset-handle hds):
        define variable hbuffer as handle    no-undo.
        define variable hfIELD as handle    no-undo.
        define variable cFields as character extent no-undo.
        define variable cFieldName as character no-undo.
        define variable i as integer no-undo.
        hBuffer = hds:get-buffer-handle("ttPartitionPolicy").
        find dictdb._file where dictdb._file._file-number = hBuffer::objectnumber no-lock.
        hField = hds:get-buffer-handle("ttPartitionPolicyField").
        cFields = hBuffer::FieldNames.
        
        FillFields(hField,hBuffer::name,dictdb._file._file-name,recid( dictdb._file ),cFields).
        
    end method.  
    
    method private void FillFields(phField as handle,pcPolicy as char,pcTable as char,pfilerecid as recid,pcFields as char extent):
        define variable cFieldName as character no-undo.
        define variable i as integer no-undo.
        do i = 1 to extent(pcfields):
            cFieldName = pcFields[i].
            if cFieldName > "" then
            do:
                find dictdb._field  where dictdb._field._file-recid = pfilerecid and dictdb._field._Field-name = cFieldName no-lock.
                
                phfield:buffer-create.
                
                assign
                    phField::Number = i
                    phField::DataType = dictdb._field._data-type
                    phField::Description = dictdb._field._desc
                    phField::fieldName = cFieldName
                    phField::Tablename = pcTable
                    phField::PartitionPolicyName = pcPolicy. 
                /* Note that the field mapping of PartitionPolicyName kicks in after this 
                   when called from beforefill - for the first record only */      
            end. 
        end. 
    end method.  
      
    method private void MakeIndexLocal(pfilerecid as recid,cfields as char extent):
        define variable cIndexes as character no-undo.
        define variable cIndex  as character no-undo.
        define variable i as integer no-undo.
        cIndexes = DataSourceUtil:GetIndexes(pfilerecid,cfields).
        do i = 1 to num-entries(cIndexes):
            find dictdb._index where dictdb._index._file-recid = pfilerecid 
                                 and  dictdb._index._index-name = entry(1,cIndexes) no-lock. 
            if dictdb._index._index-attributes[1]  then
               return.
        end.    
        cIndex = entry(1,cIndexes).
        if cIndex > "" then
        do:
            find dictdb._index where dictdb._index._file-recid = pfilerecid 
                                 and  dictdb._index._index-name = cIndex exclusive-lock no-wait.
            dictdb._index._index-attributes[1] = true.                      
        end.
            
    end.    
    
    /* delete auto created detail if no fields. There could be a better way to do this.
       tried return error in before fill and it stops the entire fill 
       also note that policy with no fields probably will not be supported (was allowed when this was added) */                
    method public void AfterFill(dataset-handle hds):
        define variable hfIELD as handle    no-undo.
        define variable cFields as character extent no-undo.
        hField = hds:get-buffer-handle("ttPartitionPolicyField").
        if hField:available and hField::FieldName = "" then
           hField:buffer-delete.
          
    end method. 
end class.